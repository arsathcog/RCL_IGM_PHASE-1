create or replace
PACKAGE BODY PCE_EDL_DLMAINTENANCE AS

  G_V_SQL VARCHAR2(10000);
  GLOB_EXCEPTION EXCEPTION;
  G_V_ORA_ERR_CD  VARCHAR2(10);
  G_V_USER_ERR_CD VARCHAR2(10);
  L_EXCP_FINISH EXCEPTION;
  G_V_WARNING VARCHAR2(100);
  L_DUPLICATE_STOW_EXCPTION EXCEPTION; -- *12
  G_V_DUPLICATE_STOW_ERR VARCHAR2(4000); -- *12, *15

  C_OPEN             VARCHAR2(2) DEFAULT '0';
  ALERT_REQUIRED     VARCHAR2(2) DEFAULT '5';
  DISCHARGE_COMPLETE VARCHAR2(2) DEFAULT '10';
  READY_FOR_INVOICE  VARCHAR2(2) DEFAULT '20';
  WORK_COMPLETE      VARCHAR2(2) DEFAULT '30';
  LL_DL_FLAG         VARCHAR2(1) DEFAULT 'D';
  LOAD_LIST      CONSTANT VARCHAR2(1) DEFAULT 'L'; -- *t
  DISCHARGE_LIST CONSTANT VARCHAR2(1) DEFAULT 'D'; -- *t
  BLANK          CONSTANT VARCHAR2(1) DEFAULT NULL; -- *t

  /*
     *2:  Modified by vikas, if shipment term is 'UC' then no need to check COC
          contianer, as k'chatgamol, 09.03.2012
     *3:  Modified by vikas, No need to show container information not found and
          record updated by
          another user error msg, as k'chatgamol, 09.03.2012
     *4:  Modified by vikas,When updating list status and cell location is blank
          then don't update list status, as k'chatgamol, 09.03.2012
     *5:  Added by vikas,stowage position as search criteria in
          booked tab, as k'chatgamol, 12.03.2012
     *6:  Added by vikas,Don't check blank stowage position for AFS and
          DFS service, as k'chatgamol,12.03.2012
     *7:  Added by vikas,Ex-mlo_vessel and ex_mlo_voyage as search criteria in
          booked tab, as k'chatgamol, 13.03.2012
     *8:  Modified by vikas, when changing discharge list status, allow blank cell
          location
          for ss/sl,  as k'chatgamol, 15.03.2012
     *9:  Added by vikas, When matching fails then download an excel shows the booked
          and overlanded
          container details, as k'chatgamol, 15.03.2012
     *10: Added by vikas, to get crane value in booked tab, as k'chatamol, 23.03.2012
     *11: Added by Leen, Added the POL Terminal into the search criteria of
          overlanded tab, K'Chatgamol, 09.04.2012
     *12: Modified by Vikas, When duplicte stowage position found then save changes and
          then show error msg, suggested by k'chatgamol, 19.04.2012
     *13: Modified by vikas, Activate EMS operations, as k'chatgamol, 20.04.2012
     *14: Modified by Leena to show the ROB containers in summary tab 23.04.2012
     *15: Modified by vikas, when too many duplicate cell location then error
          shows oracle exception, 08.05.2012.
     *16: Modifed by vikas, When list status is change to higher then 10 then log
          into the table. For the first time only, as k'chatgamol, 08.06.2012
     *17: Modified by vikas, All bookings in the DL/LL must be closed if status is changed to
         'Ready for Invoice' and 'Work Complete', as k'chatgamol, 12.06.2012
     *18: Modified by Leena, For change *17, ignore bookings which are cancelled, by checking
          the  suspended status in ezll table
     *19: Modified by Leena, Corrected the columns for pol terminal while showing
          error messages in excel
     *20: Modified by vikas, When previous load list not found then show error msg
          Service, Vessel and Voyage information not match with present load list for equipment#,
          as k'chatgamol, 21.09.2012
     *21: Changed by vikas, Add loading status in search criteria in booked tab,
          as k'chatgamol, 19.10.2012
     *22: Modified by vikas, for special handl DG, OOG enable dg update and for normal
          check the size type is RE/RH then update dg details, as k'chatgamol, 23.11.2012
     *23: Modified by vikas, raise enotice only for the discharge list which is complete or higher then
          discahrge complete, as k'chatgamol, 26.11.2012.
     *24: Modified by vikas, When changing list status from open to load completer or higher,
          check duplicate cell location, as k'chatgamol, 27.12.2012
     *25: Modified by vikas, Suspended records is also showing in search result for
          duplicate stowage position search, on booked table,
          as k'chatgamol, guru, 26.12.2012
     *26: Added by vikas, When update the load/Discharge list status  > Loading Complete
          System need to check if there's the bundle booking then, Check the
          configuration table to check the type of bundle calculation/terminal,
          If no terminal found or it's not = "EBP" then sytem need to check that
          for one booking there must be at least one container update the
          Load_Status as "Base", as k'chatgamol, 15.01.2013
     *27: Modified by vikas, When container number change for SOC, update container
          back to booking, as k'chatgamol, 01.04.2013
     *28: Modified by Leena, made null activity date time comes as last in the order by
          while finding prev load list and next discharge list procedures, for issue
          record not getting saved in restow tab, Corrected the error code from
          'ELL.SE0112' to 'EDL.SE0112', Changed the procedure to find the next
          discharge list id 01.08.2013
     *29: Modified by Leena, Commented the portclass and variant validation, and
          added port class type validation when saved from screen through booked and overlanded tab
     *30: Modified by Leena, Log the port class changes done from screen. 17.02.2014
     *31: 4 APR 2016, Wutiporn K., Validate EMS and Terminal
     *32: 6 JUN 2016, Nuttapol T., Comment validation for EDL.SE0189
     *33 02/06/16  Saisuda CR new VGM and Category  Add new column VGM and Category  at Booking tab for query data from tmp table (PRE_EDL_BOOKED_TAB_FIND).
                                                                              Add new column VGM,Category and First_leg_flag at Booking tab for insert data to tmp table (PRV_EDL_SET_BOOKING_TO_TEMP).
     *34 : 11/07/2016  ,Saisuda , As per Guru's request (on 5.07.2016), to stamp first complete dtae/user whenever LL/DL status changed to Loading complete.
     *35 : 25/07/2016, Watcharee C. if nothing chnage for Weight then return NULL i/o 0.
     *36 : 16/08/2016, Watcharee C. Add VGM field back and allow complete EZLL/EZDL for Shipment type UC 
                                    with SL status as per K.Chatgamol advise . 
  */
  G_V_DISCHARGE_LIST_ID TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID%TYPE; -- *5

  PROCEDURE PRV_EDL_SET_BOOKING_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                       ,P_I_V_DISCHARGE_ID IN VARCHAR2
                                       ,P_I_V_USER_ID      IN VARCHAR2
                                       ,P_O_V_ERR_CD       OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    -- Call Delete procedure to clear temp table before add data
    --PRV_EDL_CLR_TMP(p_i_v_session_id, p_i_v_user_id, p_o_v_err_cd);


    DELETE FROM TOS_DL_BOOKED_DISCHARGE_TMP
     WHERE SESSION_ID = P_I_V_SESSION_ID;

    INSERT INTO TOS_DL_BOOKED_DISCHARGE_TMP
      (SEQ_NO
      ,SESSION_ID
      ,PK_BOOKED_DISCHARGE_ID
      ,FK_DISCHARGE_LIST_ID
      ,CONTAINER_SEQ_NO
      ,FK_BOOKING_NO
      ,FK_BKG_SIZE_TYPE_DTL
      ,FK_BKG_SUPPLIER
      ,FK_BKG_EQUIPM_DTL
      ,DN_EQUIPMENT_NO
      ,FK_BKG_VOYAGE_ROUTING_DTL
      ,DN_EQ_SIZE
      ,DN_EQ_TYPE
      ,DN_FULL_MT
      ,DN_BKG_TYP
      ,DN_SOC_COC
      ,DN_SHIPMENT_TERM
      ,DN_SHIPMENT_TYP
      ,LOCAL_STATUS
      ,LOCAL_TERMINAL_STATUS
      ,MIDSTREAM_HANDLING_CODE
      ,LOAD_CONDITION
      ,DN_LOADING_STATUS
      ,DISCHARGE_STATUS
      ,STOWAGE_POSITION
      ,ACTIVITY_DATE_TIME
      ,CONTAINER_GROSS_WEIGHT
      ,DAMAGED
      ,VOID_SLOT
      ,FK_SLOT_OPERATOR
      ,FK_CONTAINER_OPERATOR
      ,OUT_SLOT_OPERATOR
      ,DN_SPECIAL_HNDL
      ,SEAL_NO
      ,DN_POL
      ,DN_POL_TERMINAL
      ,DN_NXT_POD1
      ,DN_NXT_POD2
      ,DN_NXT_POD3
      ,DN_FINAL_POD
      ,FINAL_DEST
      ,DN_NXT_SRV
      ,DN_NXT_VESSEL
      ,DN_NXT_VOYAGE
      ,DN_NXT_DIR
      ,MLO_VESSEL
      ,MLO_VOYAGE
      ,MLO_VESSEL_ETA
      ,MLO_POD1
      ,MLO_POD2
      ,MLO_POD3
      ,MLO_DEL
      ,SWAP_CONNECTION_ALLOWED
      ,FK_HANDLING_INSTRUCTION_1
      ,FK_HANDLING_INSTRUCTION_2
      ,FK_HANDLING_INSTRUCTION_3
      ,CONTAINER_LOADING_REM_1
      ,CONTAINER_LOADING_REM_2
      ,FK_SPECIAL_CARGO
      ,TIGHT_CONNECTION_FLAG1
      ,TIGHT_CONNECTION_FLAG2
      ,TIGHT_CONNECTION_FLAG3
      ,FK_IMDG
      ,FK_UNNO
      ,FK_UN_VAR
      ,FK_PORT_CLASS
      ,FK_PORT_CLASS_TYP
      ,FLASH_UNIT
      ,FLASH_POINT
      ,FUMIGATION_ONLY
      ,RESIDUE_ONLY_FLAG
      ,OVERHEIGHT_CM
      ,OVERWIDTH_LEFT_CM
      ,OVERWIDTH_RIGHT_CM
      ,OVERLENGTH_FRONT_CM
      ,OVERLENGTH_REAR_CM
      ,REEFER_TEMPERATURE
      ,REEFER_TMP_UNIT
      ,DN_HUMIDITY
      ,DN_VENTILATION
      ,PUBLIC_REMARK
      ,CRANE_TYPE
      , -- *10
       RECORD_CHANGE_USER
      ,RECORD_CHANGE_DATE
      ,CATEGORY_CODE --*33
      ,VGM --*36
      )
      (SELECT ROW_NUMBER() OVER(ORDER BY PK_BOOKED_DISCHARGE_ID)
             ,P_I_V_SESSION_ID
             ,PK_BOOKED_DISCHARGE_ID
             ,FK_DISCHARGE_LIST_ID
             ,CONTAINER_SEQ_NO
             ,FK_BOOKING_NO
             ,FK_BKG_SIZE_TYPE_DTL
             ,FK_BKG_SUPPLIER
             ,FK_BKG_EQUIPM_DTL
             ,DN_EQUIPMENT_NO
             ,FK_BKG_VOYAGE_ROUTING_DTL
             ,DN_EQ_SIZE
             ,DN_EQ_TYPE
             ,DN_FULL_MT
             ,DN_BKG_TYP
             ,DN_SOC_COC
             ,DN_SHIPMENT_TERM
             ,DN_SHIPMENT_TYP
             ,LOCAL_STATUS
             ,LOCAL_TERMINAL_STATUS
             ,MIDSTREAM_HANDLING_CODE
             ,LOAD_CONDITION
             ,DN_LOADING_STATUS
             ,DISCHARGE_STATUS
             ,STOWAGE_POSITION
             ,TO_CHAR(ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
             ,CONTAINER_GROSS_WEIGHT
             ,DAMAGED
             ,VOID_SLOT
             ,FK_SLOT_OPERATOR
             ,FK_CONTAINER_OPERATOR
             ,OUT_SLOT_OPERATOR
             ,DN_SPECIAL_HNDL
             ,SEAL_NO
             ,DN_POL
             ,DN_POL_TERMINAL
             ,DN_NXT_POD1
             ,DN_NXT_POD2
             ,DN_NXT_POD3
             ,DN_FINAL_POD
             ,FINAL_DEST
             ,DN_NXT_SRV
             ,DN_NXT_VESSEL
             ,DN_NXT_VOYAGE
             ,DN_NXT_DIR
             ,MLO_VESSEL
             ,MLO_VOYAGE
             ,TO_CHAR(MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
             ,MLO_POD1
             ,MLO_POD2
             ,MLO_POD3
             ,MLO_DEL
             ,SWAP_CONNECTION_ALLOWED
             ,FK_HANDLING_INSTRUCTION_1
             ,FK_HANDLING_INSTRUCTION_2
             ,FK_HANDLING_INSTRUCTION_3
             ,CONTAINER_LOADING_REM_1
             ,CONTAINER_LOADING_REM_2
             ,FK_SPECIAL_CARGO
             ,TIGHT_CONNECTION_FLAG1
             ,TIGHT_CONNECTION_FLAG2
             ,TIGHT_CONNECTION_FLAG3
             ,FK_IMDG
             ,FK_UNNO
             ,FK_UN_VAR
             ,FK_PORT_CLASS
             ,FK_PORT_CLASS_TYP
             ,FLASH_UNIT
             ,FLASH_POINT
             ,FUMIGATION_ONLY
             ,RESIDUE_ONLY_FLAG
             ,OVERHEIGHT_CM
             ,OVERWIDTH_LEFT_CM
             ,OVERWIDTH_RIGHT_CM
             ,OVERLENGTH_FRONT_CM
             ,OVERLENGTH_REAR_CM
             ,REEFER_TEMPERATURE
             ,REEFER_TMP_UNIT
             ,DN_HUMIDITY
             ,DN_VENTILATION
             ,PUBLIC_REMARK
             ,CRANE_TYPE
             , -- *10
              RECORD_CHANGE_USER
             ,RECORD_CHANGE_DATE
             ,CATEGORY_CODE --*33
             ,VGM --*36

         FROM TOS_DL_BOOKED_DISCHARGE
        WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_ID
          AND RECORD_STATUS = 'A') ORDER BY PK_BOOKED_DISCHARGE_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRV_EDL_SET_BOOKING_TO_TEMP;

  PROCEDURE PRV_EDL_SET_OVERLANDED_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                          ,P_I_V_DISCHARGE_ID IN VARCHAR2
                                          ,P_I_V_USER_ID      IN VARCHAR2
                                          ,P_O_V_ERR_CD       OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    -- Call Delete procedure to clear temp table before add data
    --        PRV_EDL_CLR_TMP(p_i_v_session_id, p_i_v_user_id, p_o_v_err_cd);

    DELETE FROM TOS_DL_OVERLANDED_CONT_TMP
     WHERE SESSION_ID = P_I_V_SESSION_ID;

    INSERT INTO TOS_DL_OVERLANDED_CONT_TMP
      (SEQ_NO
      ,SESSION_ID
      ,PK_OVERLANDED_CONTAINER_ID
      ,FK_DISCHARGE_LIST_ID
      ,BOOKING_NO
      ,EQUIPMENT_NO
      ,EQ_SIZE
      ,EQ_TYPE
      ,FULL_MT
      ,BKG_TYP
      ,FLAG_SOC_COC
      ,SHIPMENT_TERM
      ,SHIPMENT_TYP
      ,LOCAL_STATUS
      ,LOCAL_TERMINAL_STATUS
      ,MIDSTREAM_HANDLING_CODE
      ,LOAD_CONDITION
      ,STOWAGE_POSITION
      ,ACTIVITY_DATE_TIME
      ,CONTAINER_GROSS_WEIGHT
      ,DAMAGED
      ,VOID_SLOT
      ,SLOT_OPERATOR
      ,CONTAINER_OPERATOR
      ,OUT_SLOT_OPERATOR
      ,SPECIAL_HANDLING
      ,SEAL_NO
      ,POL
      ,POL_TERMINAL
      ,NXT_POD1
      ,NXT_POD2
      ,NXT_POD3
      ,FINAL_POD
      ,FINAL_DEST
      ,NXT_SRV
      ,NXT_VESSEL
      ,NXT_VOYAGE
      ,NXT_DIR
      ,MLO_VESSEL
      ,MLO_VOYAGE
      ,MLO_VESSEL_ETA
      ,MLO_POD1
      ,MLO_POD2
      ,MLO_POD3
      ,MLO_DEL
      ,HANDLING_INSTRUCTION_1
      ,HANDLING_INSTRUCTION_2
      ,HANDLING_INSTRUCTION_3
      ,CONTAINER_LOADING_REM_1
      ,CONTAINER_LOADING_REM_2
      ,SPECIAL_CARGO
      ,IMDG_CLASS
      ,UN_NUMBER
      ,UN_NUMBER_VARIANT
      ,PORT_CLASS
      ,PORT_CLASS_TYP
      ,FLASHPOINT_UNIT
      ,FLASHPOINT
      ,FUMIGATION_ONLY
      ,RESIDUE_ONLY_FLAG
      ,OVERHEIGHT_CM
      ,OVERWIDTH_LEFT_CM
      ,OVERWIDTH_RIGHT_CM
      ,OVERLENGTH_FRONT_CM
      ,OVERLENGTH_REAR_CM
      ,REEFER_TEMPERATURE
      ,REEFER_TMP_UNIT
      ,HUMIDITY
      ,VENTILATION
      ,DA_ERROR
      ,RECORD_STATUS
      ,RECORD_CHANGE_USER
      ,RECORD_CHANGE_DATE
      ,VGM --*36 
      )
      (SELECT ROW_NUMBER() OVER(ORDER BY PK_OVERLANDED_CONTAINER_ID)
             ,P_I_V_SESSION_ID
             ,PK_OVERLANDED_CONTAINER_ID
             ,FK_DISCHARGE_LIST_ID
             ,BOOKING_NO
             ,EQUIPMENT_NO
             ,EQ_SIZE
             ,EQ_TYPE
             ,FULL_MT
             ,BKG_TYP
             ,FLAG_SOC_COC
             ,SHIPMENT_TERM
             ,SHIPMENT_TYP
             ,LOCAL_STATUS
             ,LOCAL_TERMINAL_STATUS
             ,MIDSTREAM_HANDLING_CODE
             ,LOAD_CONDITION
             ,STOWAGE_POSITION
             ,TO_CHAR(ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
             ,CONTAINER_GROSS_WEIGHT
             ,DAMAGED
             ,VOID_SLOT
             ,SLOT_OPERATOR
             ,CONTAINER_OPERATOR
             ,OUT_SLOT_OPERATOR
             ,SPECIAL_HANDLING
             ,SEAL_NO
             ,POL
             ,POL_TERMINAL
             ,NXT_POD1
             ,NXT_POD2
             ,NXT_POD3
             ,FINAL_POD
             ,FINAL_DEST
             ,NXT_SRV
             ,NXT_VESSEL
             ,NXT_VOYAGE
             ,NXT_DIR
             ,MLO_VESSEL
             ,MLO_VOYAGE
             ,TO_CHAR(MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
             ,MLO_POD1
             ,MLO_POD2
             ,MLO_POD3
             ,MLO_DEL
             ,HANDLING_INSTRUCTION_1
             ,HANDLING_INSTRUCTION_2
             ,HANDLING_INSTRUCTION_3
             ,CONTAINER_LOADING_REM_1
             ,CONTAINER_LOADING_REM_2
             ,SPECIAL_CARGO
             ,IMDG_CLASS
             ,UN_NUMBER
             ,UN_NUMBER_VARIANT
             ,PORT_CLASS
             ,PORT_CLASS_TYP
             ,FLASHPOINT_UNIT
             ,FLASHPOINT
             ,FUMIGATION_ONLY
             ,RESIDUE_ONLY_FLAG
             ,OVERHEIGHT_CM
             ,OVERWIDTH_LEFT_CM
             ,OVERWIDTH_RIGHT_CM
             ,OVERLENGTH_FRONT_CM
             ,OVERLENGTH_REAR_CM
             ,REEFER_TEMPERATURE
             ,REEFER_TMP_UNIT
             ,HUMIDITY
             ,VENTILATION
             ,DA_ERROR
             ,RECORD_STATUS
             ,RECORD_CHANGE_USER
             ,RECORD_CHANGE_DATE
             ,VGM --*36 

         FROM TOS_DL_OVERLANDED_CONTAINER
        WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_ID
          AND RECORD_STATUS = 'A') ORDER BY PK_OVERLANDED_CONTAINER_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRV_EDL_SET_OVERLANDED_TO_TEMP;

  PROCEDURE PRV_EDL_SET_RESTOW_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                      ,P_I_V_DISCHARGE_ID IN VARCHAR2
                                      ,P_I_V_USER_ID      IN VARCHAR2
                                      ,P_O_V_ERR_CD       OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    -- Call Delete procedure to clear temp table before add data
    --        PRV_EDL_CLR_TMP(p_i_v_session_id, p_i_v_user_id, p_o_v_err_cd);

    DELETE FROM TOS_RESTOW_TMP WHERE SESSION_ID = P_I_V_SESSION_ID;

    INSERT INTO TOS_RESTOW_TMP
      (SEQ_NO
      ,SESSION_ID
      ,PK_RESTOW_ID
      ,FK_LOAD_LIST_ID
      ,FK_DISCHARGE_LIST_ID
      ,FK_BOOKING_NO
      ,FK_BKG_SIZE_TYPE_DTL
      ,FK_BKG_SUPPLIER
      ,FK_BKG_EQUIPM_DTL
      ,DN_EQUIPMENT_NO
      ,DN_EQ_SIZE
      ,DN_EQ_TYPE
      ,DN_SOC_COC
      ,DN_SHIPMENT_TERM
      ,DN_SHIPMENT_TYP
      ,MIDSTREAM_HANDLING_CODE
      ,LOAD_CONDITION
      ,RESTOW_STATUS
      ,STOWAGE_POSITION
      ,ACTIVITY_DATE_TIME
      ,CONTAINER_GROSS_WEIGHT
      ,DAMAGED
      ,VOID_SLOT
      ,FK_SLOT_OPERATOR
      ,FK_CONTAINER_OPERATOR
      ,DN_SPECIAL_HNDL
      ,SEAL_NO
      ,FK_SPECIAL_CARGO
      ,PUBLIC_REMARK
      ,RECORD_CHANGE_USER
      ,RECORD_CHANGE_DATE

       )
      (SELECT ROW_NUMBER() OVER(ORDER BY PK_RESTOW_ID)
             ,P_I_V_SESSION_ID
             ,PK_RESTOW_ID
             ,FK_LOAD_LIST_ID
             ,FK_DISCHARGE_LIST_ID
             ,FK_BOOKING_NO
             ,FK_BKG_SIZE_TYPE_DTL
             ,FK_BKG_SUPPLIER
             ,FK_BKG_EQUIPM_DTL
             ,DN_EQUIPMENT_NO
             ,DN_EQ_SIZE
             ,DN_EQ_TYPE
             ,DN_SOC_COC
             ,DN_SHIPMENT_TERM
             ,DN_SHIPMENT_TYP
             ,MIDSTREAM_HANDLING_CODE
             ,LOAD_CONDITION
             ,RESTOW_STATUS
             ,STOWAGE_POSITION
             ,TO_CHAR(ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
             ,CONTAINER_GROSS_WEIGHT
             ,DAMAGED
             ,VOID_SLOT
             ,FK_SLOT_OPERATOR
             ,FK_CONTAINER_OPERATOR
             ,DN_SPECIAL_HNDL
             ,SEAL_NO
             ,FK_SPECIAL_CARGO
             ,PUBLIC_REMARK
             ,RECORD_CHANGE_USER
             ,RECORD_CHANGE_DATE
         FROM TOS_RESTOW
        WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_ID
          AND RECORD_STATUS = 'A') ORDER BY PK_RESTOW_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRV_EDL_SET_RESTOW_TO_TEMP;

  PROCEDURE PRV_EDL_CLR_TMP(P_I_V_SESSION_ID IN VARCHAR2
                           ,P_I_V_USER_ID    IN VARCHAR2
                           ,P_O_V_ERR_CD     OUT VARCHAR2) AS
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    DELETE FROM TOS_DL_BOOKED_DISCHARGE_TMP
     WHERE SESSION_ID = P_I_V_SESSION_ID;

    DELETE FROM TOS_DL_OVERLANDED_CONT_TMP
     WHERE SESSION_ID = P_I_V_SESSION_ID;

    DELETE FROM TOS_RESTOW_TMP WHERE SESSION_ID = P_I_V_SESSION_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
  END PRV_EDL_CLR_TMP;

  PROCEDURE PRV_EDL_GET_PREV_PORT_VAL(P_O_V_HDRPREVPORT OUT VARCHAR2
                                     ,P_I_V_HDR_PORT    IN VARCHAR2
                                     ,P_I_V_HDR_SERVICE IN VARCHAR2
                                     ,P_I_V_HDR_VESSEL  IN VARCHAR2
                                     ,P_I_V_HDR_VOYAGE  IN VARCHAR2
                                     ,P_I_V_HDR_ETA     IN VARCHAR2
                                     ,P_I_V_HDR_ETA_TM  IN VARCHAR2
                                     ,P_O_V_ERR_CD      OUT VARCHAR2) AS
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT DECODE(LOAD_LIST_STATUS,
                  '0',
                  'Open',
                  '10',
                  'Loading',
                  '20',
                  'Ready For Invoice',
                  '30',
                  'Work Complete') STATUS
      INTO P_O_V_HDRPREVPORT
      FROM TOS_LL_LOAD_LIST LL
          ,(SELECT VVVESS
                  ,VVPCAL
                  ,VVVOYN
                  ,VVSRVC
                  ,VVPCSQ
              FROM ITP063 I
                  ,ITP040 P
             WHERE VVVESS = P_I_V_HDR_VESSEL
               AND VVPCAL = P_I_V_HDR_PORT
               AND INVOYAGENO = P_I_V_HDR_VOYAGE
               AND VVSRVC = P_I_V_HDR_SERVICE
               AND I.VVPCAL = P.PICODE
               AND ((TO_DATE(I.VVARDT, 'RRRRMMDD') +
                   (1 / 1440 *
                   (MOD(I.VVARTM, 100) + FLOOR(I.VVARTM / 100) * 60)) -
                   (1 / 1440 *
                   (MOD(P.PIVGMT, 100) + FLOOR(P.PIVGMT / 100) * 60))) <
                   (TO_DATE(TO_CHAR(TO_DATE(P_I_V_HDR_ETA, 'DD/MM/YYYY'),
                                     'YYYYMMDD'),
                             'RRRRMMDD') +
                   (1 / 1440 * (MOD(P_I_V_HDR_ETA_TM, 100) +
                   FLOOR(P_I_V_HDR_ETA_TM / 100) * 60)) -
                   (1 / 1440 *
                   (MOD(P.PIVGMT, 100) + FLOOR(P.PIVGMT / 100) * 60))))
               AND ROWNUM = 1
             ORDER BY VVARDT DESC) ITP
     WHERE LL.RECORD_STATUS = 'A'
       AND LL.FK_VESSEL = ITP.VVVESS
       AND LL.DN_PORT = ITP.VVPCAL
       AND LL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
       AND LL.FK_VOYAGE = ITP.VVVOYN
       AND LL.FK_SERVICE = ITP.VVSRVC;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_HDRPREVPORT := NULL;

    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
  END PRV_EDL_GET_PREV_PORT_VAL;

  PROCEDURE PRE_EDL_BOOKED_TAB_FIND(P_O_REFBOOKEDTABFIND    OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                   ,P_I_V_SESSION_ID        IN VARCHAR2
                                   ,P_I_V_FIND1             IN VARCHAR2
                                   ,P_I_V_IN1               IN VARCHAR2
                                   ,P_I_V_FIND2             IN VARCHAR2
                                   ,P_I_V_IN2               IN VARCHAR2
                                   ,P_I_V_ORDER1            IN VARCHAR2
                                   ,P_I_V_ORDER1ORDER       IN VARCHAR2
                                   ,P_I_V_ORDER2            IN VARCHAR2
                                   ,P_I_V_ORDER2ORDER       IN VARCHAR2
                                   ,P_I_V_DISCHARGE_LIST_ID IN VARCHAR2
                                   ,P_O_V_TOT_REC           OUT VARCHAR2
                                   ,P_O_V_ERROR             OUT VARCHAR2) AS

    L_V_SQL_SORT_ORDER VARCHAR2(4000);
    L_V_ERR            VARCHAR2(5000);
    L_V_SQL_1          VARCHAR2(4000);
    L_V_SQL_2          VARCHAR2(4000);
    L_V_SQL_3          VARCHAR2(4000);

  BEGIN

    /* Set Success Code*/
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /* Set Total Record to Default -1  */
    P_O_V_TOT_REC := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

    /*
        *5: Reset value of globle discharge list variable
    */
    G_V_DISCHARGE_LIST_ID := P_I_V_DISCHARGE_LIST_ID;

    -- sorting on the basis of sort order
    IF (P_I_V_ORDER1 IS NOT NULL)
       OR (P_I_V_ORDER2 IS NOT NULL) THEN
      L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ORDER BY ';
      -- when order1 is not not null.
      IF (P_I_V_ORDER1 IS NOT NULL) THEN
        L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || P_I_V_ORDER1 || ' ' ||
                              P_I_V_ORDER1ORDER;
      END IF;
      -- when order2 is not not null.
      IF (P_I_V_ORDER2 IS NOT NULL) THEN
        --  when order1 is not null then add comma(,) after first order by clause.
        IF (P_I_V_ORDER1 IS NOT NULL) THEN
          L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' , ' || P_I_V_ORDER2 || ' ' ||
                                P_I_V_ORDER2ORDER;
        ELSE
          L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ' || P_I_V_ORDER2 || ' ' ||
                                P_I_V_ORDER2ORDER;
        END IF;
      END IF;
    ELSE
      -- Default sort order.
      L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ORDER BY ' ||
                            'tos_dl_booked_discharge.fk_booking_no
                    , tos_dl_booked_discharge.dn_eq_size
                    , tos_dl_booked_discharge.dn_eq_type
                    , tos_dl_booked_discharge.dn_equipment_no';
    END IF;

    /* Construct the SQL */
    G_V_SQL := ' SELECT TOS_DL_BOOKED_DISCHARGE.SEQ_NO,
                TOS_DL_BOOKED_DISCHARGE.CONTAINER_SEQ_NO CONTAINER_SEQ_NO ,
                TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID PK_BOOKED_DISCHARGE_ID,
                TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO FK_BOOKING_NO ,
                TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO DN_EQUIPMENT_NO ,
                CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
                    ( SELECT IDP002.TYBLNO
                    FROM  IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
                    WHERE IDP055.EYBLNO  = IDP002.TYBLNO
                    AND IDP055.EYBLNO      = IDP010.AYBLNO
                    AND IDP002.TYBLNO      = IDP010.AYBLNO
                    AND IDP010.AYSTAT     >=1
                    AND IDP010.AYSTAT     <=6
                    AND IDP010.part_of_bl IS NULL
                    AND IDP002.TYBKNO      = FK_BOOKING_NO
                    AND IDP055.EYEQNO      = DN_EQUIPMENT_NO
                    AND ROWNUM=''1'')
                ELSE
                    ''''
                END BLNO,
                TOS_DL_BOOKED_DISCHARGE.DN_EQ_SIZE DN_EQ_SIZE ,
                TOS_DL_BOOKED_DISCHARGE.DN_EQ_TYPE DN_EQ_TYPE ,
                DECODE(TOS_DL_BOOKED_DISCHARGE.DN_FULL_MT,''F'',''Full'',''E'',''Empty'') DN_FULL_MT ,
                DECODE(TOS_DL_BOOKED_DISCHARGE.DN_BKG_TYP,''N'',''Normal'',''ER'',''Empty Repositioning'',''FC'',''Feeder Cargo'') DN_BKG_TYP ,
                DECODE(TOS_DL_BOOKED_DISCHARGE.DN_SOC_COC,''S'',''SOC'',''C'',''COC'') DN_SOC_COC ,
                TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TERM DN_SHIPMENT_TERM ,
                TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP DN_SHIPMENT_TYP ,
                DECODE(TOS_DL_BOOKED_DISCHARGE.LOCAL_STATUS,''L'',''Local'',''T'',''Transhipment'') LOCAL_STATUS ,
                TOS_DL_BOOKED_DISCHARGE.LOCAL_TERMINAL_STATUS LOCAL_TERMINAL_STATUS ,
                TOS_DL_BOOKED_DISCHARGE.MIDSTREAM_HANDLING_CODE MIDSTREAM_HANDLING_CODE ,
                TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION LOAD_CONDITION ,
                DECODE(TOS_DL_BOOKED_DISCHARGE.DN_LOADING_STATUS,''BK'',''Booked'',''LO'',''Loaded'',''RB'',''Retained on board'',''SS'',''Short Shipped'') DN_LOADING_STATUS ,
                TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS DISCHARGE_STATUS ,
                TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION STOWAGE_POSITION ,
                TOS_DL_BOOKED_DISCHARGE.ACTIVITY_DATE_TIME ACTIVITY_DATE_TIME ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT, ''FM9,99,99,99,99,990.00'') CONTAINER_GROSS_WEIGHT ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.VGM, ''FM9,99,99,99,99,990.00'') AS VGM ,
                TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE,
                TOS_DL_BOOKED_DISCHARGE.DAMAGED DAMAGED ,
                DECODE(TOS_DL_BOOKED_DISCHARGE.VOID_SLOT,0,'''', TOS_DL_BOOKED_DISCHARGE.VOID_SLOT) VOID_SLOT ,
                TOS_DL_BOOKED_DISCHARGE.FK_SLOT_OPERATOR FK_SLOT_OPERATOR ,
                TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR ,
                TOS_DL_BOOKED_DISCHARGE.OUT_SLOT_OPERATOR OUT_SLOT_OPERATOR ,
                DECODE(TOS_DL_BOOKED_DISCHARGE.DN_SPECIAL_HNDL,''O0'',''OOG''                ,
                                                                ''D1'',''DG''                ,
                                                                ''N'',''Normal''             ,
                                                                ''DA'',''Door Ajar''         ,
                                                                ''OD'',''Open Door''         ,
                                                                ''NR'',''Non Reefer'') DN_SPECIAL_HNDL ,
                TOS_DL_BOOKED_DISCHARGE.SEAL_NO SEAL_NO ,
                TOS_DL_BOOKED_DISCHARGE. DN_POL  DN_POL ,
                TOS_DL_BOOKED_DISCHARGE.DN_POL_TERMINAL DN_POL_TERMINAL ,
                TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD1 DN_NXT_POD1 ,
                TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD2 DN_NXT_POD2 ,
                TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD3 DN_NXT_POD3 ,
                TOS_DL_BOOKED_DISCHARGE.DN_FINAL_POD DN_FINAL_POD ,
                TOS_DL_BOOKED_DISCHARGE.FINAL_DEST FINAL_DEST ,
                TOS_DL_BOOKED_DISCHARGE.DN_NXT_SRV DN_NXT_SRV ,
                TOS_DL_BOOKED_DISCHARGE.DN_NXT_VESSEL DN_NXT_VESSEL ,
                TOS_DL_BOOKED_DISCHARGE.DN_NXT_VOYAGE DN_NXT_VOYAGE ,
                TOS_DL_BOOKED_DISCHARGE.DN_NXT_DIR DN_NXT_DIR ,
                TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL MLO_VESSEL ,
                TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE MLO_VOYAGE ,
                TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL_ETA MLO_VESSEL_ETA ,
                TOS_DL_BOOKED_DISCHARGE.MLO_POD1 MLO_POD1 ,
                TOS_DL_BOOKED_DISCHARGE.MLO_POD2 MLO_POD2 ,
                TOS_DL_BOOKED_DISCHARGE.MLO_POD3 MLO_POD3 ,
                TOS_DL_BOOKED_DISCHARGE.MLO_DEL MLO_DEL ,
                TOS_DL_BOOKED_DISCHARGE.SWAP_CONNECTION_ALLOWED SWAP_CONNECTION_ALLOWED ,
                TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1 FK_HANDLING_INSTRUCTION_1 ,
                HI1.SHI_DESCRIPTION HANDLING_DISCRIPTION_1,
                TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2 FK_HANDLING_INSTRUCTION_2 ,
                HI2.SHI_DESCRIPTION HANDLING_DISCRIPTION_2,
                TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3 FK_HANDLING_INSTRUCTION_3 ,
                HI3.SHI_DESCRIPTION HANDLING_DISCRIPTION_3,
                TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1 CONTAINER_LOADING_REM_1 ,
                TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2 CONTAINER_LOADING_REM_2 ,
                TOS_DL_BOOKED_DISCHARGE.FK_SPECIAL_CARGO FK_SPECIAL_CARGO ,
                NVL(TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1,''N'') TIGHT_CONNECTION_FLAG1 ,
                NVL(TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2,''N'') TIGHT_CONNECTION_FLAG2 ,
                NVL(TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3,''N'') TIGHT_CONNECTION_FLAG3 ,
                TOS_DL_BOOKED_DISCHARGE.FK_IMDG FK_IMDG ,
                TOS_DL_BOOKED_DISCHARGE.FK_UNNO FK_UNNO ,
                TOS_DL_BOOKED_DISCHARGE.FK_UN_VAR FK_UN_VAR ,
                TOS_DL_BOOKED_DISCHARGE.FK_PORT_CLASS FK_PORT_CLASS ,
                TOS_DL_BOOKED_DISCHARGE.FK_PORT_CLASS_TYP FK_PORT_CLASS_TYP ,
                TOS_DL_BOOKED_DISCHARGE.FLASH_UNIT FLASH_UNIT ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.FLASH_POINT, ''FM990.000'') FLASH_POINT ,
                TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY FUMIGATION_ONLY,
                TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG RESIDUE_ONLY_FLAG ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.OVERHEIGHT_CM, ''FM9,999,999,990.0000'') OVERHEIGHT_CM ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.OVERWIDTH_LEFT_CM, ''FM9,999,999,990.0000'') OVERWIDTH_LEFT_CM ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.OVERWIDTH_RIGHT_CM, ''FM9,999,999,990.0000'')  OVERWIDTH_RIGHT_CM ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.OVERLENGTH_FRONT_CM, ''FM9,999,999,990.0000'')  OVERLENGTH_FRONT_CM ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.OVERLENGTH_REAR_CM, ''FM9,999,999,990.0000'')  OVERLENGTH_REAR_CM ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.REEFER_TEMPERATURE, ''FM990.000'') REEFER_TEMPERATURE ,
                TOS_DL_BOOKED_DISCHARGE.REEFER_TMP_UNIT REEFER_TMP_UNIT ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.DN_HUMIDITY, ''FM990.00'')  DN_HUMIDITY ,
                TO_CHAR(TOS_DL_BOOKED_DISCHARGE.DN_VENTILATION, ''FM990.00'')  DN_VENTILATION ,
                TOS_DL_BOOKED_DISCHARGE.PUBLIC_REMARK PUBLIC_REMARK,
                TOS_DL_BOOKED_DISCHARGE.OPN_STATUS,
                TOS_DL_BOOKED_DISCHARGE.RECORD_CHANGE_DATE,
                (SELECT TRREFR FROM ITP075 WHERE TRTYPE = DN_EQ_TYPE) REEFER_FLAG,
                CRANE_TYPE CRANE_DESCRIPTION,
                PCE_ECM_SYNC_BOOKING_EZLL.FN_CAN_UPDATE_DG(
                    TOS_DL_BOOKED_DISCHARGE.DN_SPECIAL_HNDL,
                    TOS_DL_BOOKED_DISCHARGE.DN_EQ_TYPE
                ) AS "IS_UPDATE_DG"
                FROM TOS_DL_BOOKED_DISCHARGE_TMP TOS_DL_BOOKED_DISCHARGE,
                SHP007 HI1,
                SHP007 HI2,
                SHP007 HI3
                WHERE (TOS_DL_BOOKED_DISCHARGE.OPN_STATUS IS NULL OR
                       TOS_DL_BOOKED_DISCHARGE.OPN_STATUS <> ''' ||
               PCE_EUT_COMMON.G_V_REC_DEL || ''')
                AND   TOS_DL_BOOKED_DISCHARGE.SESSION_ID = ''' ||
               P_I_V_SESSION_ID || '''
                AND FK_HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
                AND FK_HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
                AND FK_HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
                AND   TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID = ''' ||
               P_I_V_DISCHARGE_LIST_ID || '''';

    --Where clause conditions.
    IF (P_I_V_IN1 IS NOT NULL) THEN
      -- this function add the additional where clauss condtions in
      -- dynamic sql according to the passed parameter.
      ADDITION_WHERE_CONDTIONS(TRIM(P_I_V_IN1),
                               TRIM(P_I_V_FIND1),
                               'BOOKED_TAB'); -- added trim func. 30.01.2012
    END IF;

    IF (P_I_V_IN2 IS NOT NULL) THEN
      -- this function add the additional where clauss condtions in
      -- dynamic sql according to the passed parameter.
      ADDITION_WHERE_CONDTIONS(TRIM(P_I_V_IN2),
                               TRIM(P_I_V_FIND2),
                               'BOOKED_TAB'); -- added trim func. 30.01.2012
    END IF;

    G_V_SQL := G_V_SQL || ' ' || L_V_SQL_SORT_ORDER;

    DBMS_OUTPUT.PUT_LINE('g_v_sql: ' || G_V_SQL);
    /* Execute the SQL */
    OPEN P_O_REFBOOKEDTABFIND FOR G_V_SQL;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_ERROR := PCE_EUT_COMMON.G_V_GE0004;
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));
    WHEN OTHERS THEN
      L_V_ERR := SUBSTR(SQLCODE, 1, 10) || ':' || SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(L_V_ERR));
  END PRE_EDL_BOOKED_TAB_FIND;

  PROCEDURE PRE_EDL_OVERLANDED_TAB_FIND(P_O_REFOVERLANDEDTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                       ,P_I_V_SESSION_ID         IN VARCHAR2
                                       ,P_I_V_FIND1              IN VARCHAR2
                                       ,P_I_V_IN1                IN VARCHAR2
                                       ,P_I_V_FIND2              IN VARCHAR2
                                       ,P_I_V_IN2                IN VARCHAR2
                                       ,P_I_V_ORDER1             IN VARCHAR2
                                       ,P_I_V_ORDER1ORDER        IN VARCHAR2
                                       ,P_I_V_ORDER2             IN VARCHAR2
                                       ,P_I_V_ORDER2ORDER        IN VARCHAR2
                                       ,P_I_V_DISCHARGE_LIST_ID  IN VARCHAR2
                                       ,P_O_V_TOT_REC            OUT VARCHAR2
                                       ,P_O_V_ERROR              OUT VARCHAR2) AS
    L_V_SQL_SORT_ORDER VARCHAR2(4000);
    L_V_ERR            VARCHAR2(5000);
    L_V_SQL_1          VARCHAR2(4000);
    L_V_SQL_2          VARCHAR2(4000);
    L_V_SQL_3          VARCHAR2(4000);

  BEGIN

    /* Set Success Code */
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /* Set Total Record to Default -1*/
    P_O_V_TOT_REC := -1;

    -- sorting on the basis of sort order
    IF (P_I_V_ORDER1 IS NOT NULL)
       OR (P_I_V_ORDER2 IS NOT NULL) THEN
      L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ORDER BY ';

      -- when order1 is not not null.
      IF (P_I_V_ORDER1 IS NOT NULL) THEN
        L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || P_I_V_ORDER1 || ' ' ||
                              P_I_V_ORDER1ORDER;
      END IF;

      --  when order1 is not null then add comma(,) after first order by clause.
      IF (P_I_V_ORDER2 IS NOT NULL) THEN
        IF (P_I_V_ORDER1 IS NOT NULL) THEN
          L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' , ' || P_I_V_ORDER2 || ' ' ||
                                P_I_V_ORDER2ORDER;
        ELSE
          L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ' || P_I_V_ORDER2 || ' ' ||
                                P_I_V_ORDER2ORDER;
        END IF;
      END IF;
    ELSE
      -- Default sort order.
      L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ORDER BY ' ||
                            'TOS_DL_OVERLANDED_CONTAINER.BOOKING_NO
                    , TOS_DL_OVERLANDED_CONTAINER.EQ_SIZE
                    , TOS_DL_OVERLANDED_CONTAINER.EQ_TYPE
                    , TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO';
    END IF;

    -- Construct the SQL
    G_V_SQL := ' SELECT
                ROW_NUMBER()  OVER (' || L_V_SQL_SORT_ORDER ||
               ') SR_NO,' ||
               'TOS_DL_OVERLANDED_CONTAINER.SEQ_NO SEQ_NO                                        ,
                TOS_DL_OVERLANDED_CONTAINER.BOOKING_NO BOOKING_NO                                ,
                TOS_DL_OVERLANDED_CONTAINER.PK_OVERLANDED_CONTAINER_ID PK_OVERLANDED_CONTAINER_ID,
                TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO EQUIPMENT_NO                            ,
                CASE WHEN TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO IS NOT NULL THEN
                    ( SELECT IDP002.TYBLNO
                    FROM  IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
                    WHERE IDP055.EYBLNO  = IDP002.TYBLNO
                    AND IDP055.EYBLNO      = IDP010.AYBLNO
                    AND IDP002.TYBLNO      = IDP010.AYBLNO
                    AND IDP010.AYSTAT     >=1
                    AND IDP010.AYSTAT     <=6
                    AND IDP010.part_of_bl IS NULL
                    AND IDP002.TYBKNO      = TOS_DL_OVERLANDED_CONTAINER.BOOKING_NO
                    AND IDP055.EYEQNO      = TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO
                    AND ROWNUM=''1'')
                ELSE
                    ''''
                END BLNO,
                TOS_DL_OVERLANDED_CONTAINER.EQ_SIZE EQ_SIZE                                 ,
                TOS_DL_OVERLANDED_CONTAINER.EQ_TYPE EQ_TYPE                                 ,
                TOS_DL_OVERLANDED_CONTAINER.FULL_MT FULL_MT                                 ,
                TOS_DL_OVERLANDED_CONTAINER.BKG_TYP BKG_TYP                                 ,
                TOS_DL_OVERLANDED_CONTAINER.FLAG_SOC_COC FLAG_SOC_COC                       ,
                TOS_DL_OVERLANDED_CONTAINER.SHIPMENT_TERM SHIPMENT_TERM                     ,
                TOS_DL_OVERLANDED_CONTAINER.SHIPMENT_TYP SHIPMENT_TYP                       ,
                TOS_DL_OVERLANDED_CONTAINER.LOCAL_STATUS LOCAL_STATUS                       ,
                TOS_DL_OVERLANDED_CONTAINER.LOCAL_TERMINAL_STATUS LOCAL_TERMINAL_STATUS     ,
                TOS_DL_OVERLANDED_CONTAINER.MIDSTREAM_HANDLING_CODE MIDSTREAM_HANDLING_CODE ,
                TOS_DL_OVERLANDED_CONTAINER.LOAD_CONDITION LOAD_CONDITION                   ,
                TOS_DL_OVERLANDED_CONTAINER.STOWAGE_POSITION STOWAGE_POSITION               ,
                TOS_DL_OVERLANDED_CONTAINER.ACTIVITY_DATE_TIME ACTIVITY_DATE_TIME           ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.CONTAINER_GROSS_WEIGHT, ''FM9,99,99,99,99,990.00'') CONTAINER_GROSS_WEIGHT   ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.VGM, ''FM9,99,99,99,99,990.00'') VGM   ,                
                TOS_DL_OVERLANDED_CONTAINER.DAMAGED DAMAGED                                 ,
                DECODE(TOS_DL_OVERLANDED_CONTAINER.VOID_SLOT,0,'''', TOS_DL_OVERLANDED_CONTAINER.VOID_SLOT) VOID_SLOT              ,
                TOS_DL_OVERLANDED_CONTAINER.SLOT_OPERATOR SLOT_OPERATOR                     ,
                TOS_DL_OVERLANDED_CONTAINER.CONTAINER_OPERATOR CONTAINER_OPERATOR           ,
                TOS_DL_OVERLANDED_CONTAINER.OUT_SLOT_OPERATOR OUT_SLOT_OPERATOR             ,
                TOS_DL_OVERLANDED_CONTAINER.SPECIAL_HANDLING SPECIAL_HANDLING               ,
                TOS_DL_OVERLANDED_CONTAINER.SEAL_NO SEAL_NO                                 ,
                TOS_DL_OVERLANDED_CONTAINER.POL POL                                         ,
                TOS_DL_OVERLANDED_CONTAINER.POL_TERMINAL POL_TERMINAL                       ,
                TOS_DL_OVERLANDED_CONTAINER.NXT_POD1 NXT_POD1                               ,
                TOS_DL_OVERLANDED_CONTAINER.NXT_POD2 NXT_POD2                               ,
                TOS_DL_OVERLANDED_CONTAINER.NXT_POD3 NXT_POD3                               ,
                TOS_DL_OVERLANDED_CONTAINER.FINAL_POD FINAL_POD                             ,
                TOS_DL_OVERLANDED_CONTAINER.FINAL_DEST FINAL_DEST                           ,
                TOS_DL_OVERLANDED_CONTAINER.NXT_SRV NXT_SRV                                 ,
                TOS_DL_OVERLANDED_CONTAINER.NXT_VESSEL NXT_VESSEL                           ,
                TOS_DL_OVERLANDED_CONTAINER.NXT_VOYAGE NXT_VOYAGE                           ,
                TOS_DL_OVERLANDED_CONTAINER.NXT_DIR NXT_DIR                                 ,
                TOS_DL_OVERLANDED_CONTAINER.MLO_VESSEL MLO_VESSEL                           ,
                TOS_DL_OVERLANDED_CONTAINER.MLO_VOYAGE MLO_VOYAGE                           ,
                TOS_DL_OVERLANDED_CONTAINER.MLO_VESSEL_ETA MLO_VESSEL_ETA                   ,
                TOS_DL_OVERLANDED_CONTAINER.MLO_POD1 MLO_POD1                               ,
                TOS_DL_OVERLANDED_CONTAINER.MLO_POD2 MLO_POD2                               ,
                TOS_DL_OVERLANDED_CONTAINER.MLO_POD3 MLO_POD3                               ,
                TOS_DL_OVERLANDED_CONTAINER.MLO_DEL MLO_DEL                                 ,
                TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_1 HANDLING_INSTRUCTION_1   ,
                HI1.SHI_DESCRIPTION HANDLING_DISCRIPTION_1                                    ,
                TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_2 HANDLING_INSTRUCTION_2   ,
                HI2.SHI_DESCRIPTION HANDLING_DISCRIPTION_2                                    ,
                TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_3 HANDLING_INSTRUCTION_3   ,
                HI3.SHI_DESCRIPTION HANDLING_DISCRIPTION_3                                    ,
                TOS_DL_OVERLANDED_CONTAINER.CONTAINER_LOADING_REM_1 CONTAINER_LOADING_REM_1 ,
                TOS_DL_OVERLANDED_CONTAINER.CONTAINER_LOADING_REM_2 CONTAINER_LOADING_REM_2 ,
                TOS_DL_OVERLANDED_CONTAINER.SPECIAL_CARGO SPECIAL_CARGO                     ,
                TOS_DL_OVERLANDED_CONTAINER.IMDG_CLASS IMDG_CLASS                           ,
                TOS_DL_OVERLANDED_CONTAINER.UN_NUMBER UN_NUMBER                             ,
                TOS_DL_OVERLANDED_CONTAINER.UN_NUMBER_VARIANT UN_VAR                        ,
                TOS_DL_OVERLANDED_CONTAINER.PORT_CLASS PORT_CLASS                           ,
                TOS_DL_OVERLANDED_CONTAINER.PORT_CLASS_TYP PORT_CLASS_TYP                   ,
                TOS_DL_OVERLANDED_CONTAINER.FLASHPOINT_UNIT FLASHPOINT_UNIT                 ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.FLASHPOINT, ''FM990.000'') FLASHPOINT ,
                TOS_DL_OVERLANDED_CONTAINER.FUMIGATION_ONLY FUMIGATION_ONLY                 ,
                TOS_DL_OVERLANDED_CONTAINER.RESIDUE_ONLY_FLAG RESIDUE_ONLY_FLAG             ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.OVERHEIGHT_CM, ''FM9,999,999,990.0000'') OVERHEIGHT_CM ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.OVERWIDTH_LEFT_CM, ''FM9,999,999,990.0000'') OVERWIDTH_LEFT_CM ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.OVERWIDTH_RIGHT_CM, ''FM9,999,999,990.0000'')  OVERWIDTH_RIGHT_CM ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.OVERLENGTH_FRONT_CM, ''FM9,999,999,990.0000'')  OVERLENGTH_FRONT_CM ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.OVERLENGTH_REAR_CM, ''FM9,999,999,990.0000'')  OVERLENGTH_REAR_CM ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.REEFER_TEMPERATURE, ''FM990.000'') REEFER_TEMPERATURE ,
                TOS_DL_OVERLANDED_CONTAINER.REEFER_TMP_UNIT REEFER_TMP_UNIT                 ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.HUMIDITY, ''FM990.00'') HUMIDITY     ,
                TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.VENTILATION, ''FM990.00'')  VENTILATION ,
                TOS_DL_OVERLANDED_CONTAINER.DA_ERROR DA_ERROR                               ,
                TOS_DL_OVERLANDED_CONTAINER.OPN_STATUS                                      ,
                TOS_DL_OVERLANDED_CONTAINER.DISCHARGE_STATUS                                ,
                TOS_DL_OVERLANDED_CONTAINER.RECORD_CHANGE_DATE
                -- ,
                -- PCE_ECM_SYNC_BOOKING_EZLL.FN_CAN_UPDATE_DG(
                --     TOS_DL_OVERLANDED_CONTAINER.SPECIAL_HANDLING,
                --     TOS_DL_OVERLANDED_CONTAINER.EQ_TYPE
                -- ) AS "IS_UPDATE_DG"
                FROM TOS_DL_OVERLANDED_CONT_TMP TOS_DL_OVERLANDED_CONTAINER,
                SHP007 HI1,
                SHP007 HI2,
                SHP007 HI3
                WHERE (TOS_DL_OVERLANDED_CONTAINER.OPN_STATUS IS NULL OR
                       TOS_DL_OVERLANDED_CONTAINER.OPN_STATUS <> ''' ||
               PCE_EUT_COMMON.G_V_REC_DEL || ''')
                AND    TOS_DL_OVERLANDED_CONTAINER.SESSION_ID = ''' ||
               P_I_V_SESSION_ID || '''
                AND HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
                AND HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
                AND HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
                AND    TOS_DL_OVERLANDED_CONTAINER.FK_DISCHARGE_LIST_ID = ''' ||
               P_I_V_DISCHARGE_LIST_ID || '''';

    -- Additional where clause conditions.
    IF (P_I_V_IN1 IS NOT NULL) THEN
      -- This function add the additional where clauss condtions in
      -- Dynamic sql according to the passed parameter.
      ADDITION_WHERE_CONDTIONS(TRIM(P_I_V_IN1),
                               TRIM(P_I_V_FIND1),
                               'OVERLANDED_TAB'); -- added trim func. 30.01.2012
    END IF;

    IF (P_I_V_IN2 IS NOT NULL) THEN
      -- This function add the additional where clauss condtions in
      -- Dynamic sql according to the passed parameter.
      ADDITION_WHERE_CONDTIONS(TRIM(P_I_V_IN2),
                               TRIM(P_I_V_FIND2),
                               'OVERLANDED_TAB'); -- added trim func. 30.01.2012
    END IF;

    G_V_SQL := G_V_SQL || ' ' || L_V_SQL_SORT_ORDER;

    -- Execute the SQL
    OPEN P_O_REFOVERLANDEDTABFIND FOR G_V_SQL;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_ERROR := PCE_EUT_COMMON.G_V_GE0004;
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));
    WHEN OTHERS THEN
      P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) || ':' ||
                     SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));

  END PRE_EDL_OVERLANDED_TAB_FIND;

  PROCEDURE PRE_EDL_RESTOWED_TAB_FIND(P_O_REFRESTOWEDTABFIND  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                     ,P_I_V_SESSION_ID        IN VARCHAR2
                                     ,P_I_V_FIND1             IN VARCHAR2
                                     ,P_I_V_IN1               IN VARCHAR2
                                     ,P_I_V_FIND2             IN VARCHAR2
                                     ,P_I_V_IN2               IN VARCHAR2
                                     ,P_I_V_ORDER1            IN VARCHAR2
                                     ,P_I_V_ORDER1ORDER       IN VARCHAR2
                                     ,P_I_V_ORDER2            IN VARCHAR2
                                     ,P_I_V_ORDER2ORDER       IN VARCHAR2
                                     ,P_I_V_DISCHARGE_LIST_ID IN VARCHAR2
                                     ,P_O_V_TOT_REC           OUT VARCHAR2
                                     ,P_O_V_ERROR             OUT VARCHAR2) AS
    L_V_SQL_SORT_ORDER VARCHAR2(4000);
    L_V_SQL_1          VARCHAR2(4000);
    L_V_SQL_2          VARCHAR2(4000);
    L_V_SQL_3          VARCHAR2(4000);

  BEGIN

    /* Set Success Code */
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /* Set Total Record to Default -1  */
    P_O_V_TOT_REC := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

    -- sorting on the basis of sort order
    IF (P_I_V_ORDER1 IS NOT NULL)
       OR (P_I_V_ORDER2 IS NOT NULL) THEN
      L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ORDER BY ';

      IF (P_I_V_ORDER1 IS NOT NULL) THEN
        -- when order1 is not not null.
        L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || P_I_V_ORDER1 || ' ' ||
                              P_I_V_ORDER1ORDER;
      END IF;
      IF (P_I_V_ORDER2 IS NOT NULL) THEN
        --  when order1 is not null then add comma(,) after first order by clause.
        IF (P_I_V_ORDER1 IS NOT NULL) THEN
          L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' , ' || P_I_V_ORDER2 || ' ' ||
                                P_I_V_ORDER2ORDER;
        ELSE
          L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ' || P_I_V_ORDER2 || ' ' ||
                                P_I_V_ORDER2ORDER;
        END IF;
      END IF;
    ELSE
      -- Default sort order.
      L_V_SQL_SORT_ORDER := L_V_SQL_SORT_ORDER || ' ORDER BY ' ||
                            'TOS_RESTOW.FK_BOOKING_NO
                    , TOS_RESTOW.DN_EQ_SIZE
                    , TOS_RESTOW.DN_EQ_TYPE
                    , TOS_RESTOW.DN_EQUIPMENT_NO';
    END IF;

    /* Construct the SQL */
    G_V_SQL := ' SELECT
                ROW_NUMBER()  OVER (' || L_V_SQL_SORT_ORDER ||
               ') SR_NO,' ||
               ' TOS_RESTOW.SEQ_NO                                                 ,
                TOS_RESTOW.FK_BOOKING_NO FK_BOOKING_NO                              ,
                TOS_RESTOW.PK_RESTOW_ID PK_RESTOW_ID                                ,
                TOS_RESTOW.DN_EQUIPMENT_NO DN_EQUIPMENT_NO                          ,
                TOS_RESTOW.DN_EQ_SIZE DN_EQ_SIZE                                    ,
                TOS_RESTOW.DN_EQ_TYPE DN_EQ_TYPE                                    ,
                DECODE(TOS_RESTOW.DN_SOC_COC,''S'',''SOC'',''C'',''COC'') DN_SOC_COC,
                TOS_RESTOW.DN_SHIPMENT_TERM DN_SHIPMENT_TERM                        ,
                TOS_RESTOW.DN_SHIPMENT_TYP DN_SHIPMENT_TYP                          ,
                TOS_RESTOW.MIDSTREAM_HANDLING_CODE MIDSTREAM_HANDLING_CODE          ,
                TOS_RESTOW.LOAD_CONDITION LOAD_COND                                 ,
                TOS_RESTOW.RESTOW_STATUS RESTOW_STATUS                              ,
                TOS_RESTOW.ACTIVITY_DATE_TIME ACTIVITY_DATE_TIME                    ,
                TOS_RESTOW.STOWAGE_POSITION STOWAGE_POSITION                        ,
                TO_CHAR(TOS_RESTOW.CONTAINER_GROSS_WEIGHT, ''FM9,99,99,99,99,990.00'') CONTAINER_GROSS_WEIGHT,
                TOS_RESTOW.DAMAGED DAMAGED                                          ,
                DECODE(TOS_RESTOW.VOID_SLOT,0,'''', TOS_RESTOW.VOID_SLOT) VOID_SLOT                       ,
                TOS_RESTOW.FK_SLOT_OPERATOR FK_SLOT_OPERATOR                        ,
                TOS_RESTOW.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR              ,
                DECODE(TOS_RESTOW.DN_SPECIAL_HNDL,''O0'',''OOG''               ,
                                                  ''D1'',''DG''                ,
                                                  ''N'',''Normal''             ,
                                                  ''DA'',''Door Ajar''         ,
                                                  ''OD'',''Open Door''         ,
                                                  ''NR'',''Non Reefer'') DN_SPECIAL_HNDL,
                TOS_RESTOW.FK_SPECIAL_CARGO FK_SPECIAL_CARGO                        ,
                TOS_RESTOW.PUBLIC_REMARK PUBLIC_REMARK                              ,
                TOS_RESTOW.SEAL_NO  SEAL_NO                               ,
                TOS_RESTOW.OPN_STATUS                                               ,
                TOS_RESTOW.RECORD_CHANGE_DATE
                FROM TOS_RESTOW_TMP TOS_RESTOW
                WHERE (TOS_RESTOW.OPN_STATUS IS NULL OR
                       TOS_RESTOW.OPN_STATUS <> ''' ||
               PCE_EUT_COMMON.G_V_REC_DEL || ''')
                AND    TOS_RESTOW.SESSION_ID = ''' ||
               P_I_V_SESSION_ID || '''
                AND    TOS_RESTOW.FK_DISCHARGE_LIST_ID = ''' ||
               P_I_V_DISCHARGE_LIST_ID || '''';

    -- Additional where clause conditions.
    IF (P_I_V_IN1 IS NOT NULL) THEN
      -- this function add the additional where clauss condtions in
      -- dynamic sql according to the passed parameter.
      ADDITION_WHERE_CONDTIONS(TRIM(P_I_V_IN1),
                               TRIM(P_I_V_FIND1),
                               'RESTOW_TAB'); -- added trim func. 30.01.2012
    END IF;

    IF (P_I_V_IN2 IS NOT NULL) THEN
      -- this function add the additional where clauss condtions in
      -- dynamic sql according to the passed parameter.
      ADDITION_WHERE_CONDTIONS(TRIM(P_I_V_IN2),
                               TRIM(P_I_V_FIND2),
                               'RESTOW_TAB'); -- added trim func. 30.01.2012
    END IF;

    G_V_SQL := G_V_SQL || ' ' || L_V_SQL_SORT_ORDER;

    /* Execute the SQL */
    OPEN P_O_REFRESTOWEDTABFIND FOR G_V_SQL;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_ERROR := PCE_EUT_COMMON.G_V_GE0004;
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));

    WHEN OTHERS THEN
      P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) || ':' ||
                     SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));

  END PRE_EDL_RESTOWED_TAB_FIND;

  PROCEDURE PRE_EDL_SUMMARY_TAB_FIND(P_O_REFSUMMARYTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,P_I_V_DISCHARGE_ID    VARCHAR2
                                    ,P_O_V_TOT_REC         OUT VARCHAR2
                                    ,P_O_V_ERROR           OUT VARCHAR2) AS

  BEGIN
    /* Set Success Code */
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /* Set Total Record to Default -1  */
    P_O_V_TOT_REC := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

    /* Construct the SQL */
    G_V_SQL := 'SELECT  FK_SLOT_OPERATOR
                        ,FK_CONTAINER_OPERATOR
                        ,DN_EQ_SIZE|| DN_EQ_TYPE SIZETYPE
                        ,DECODE(DN_FULL_MT, ''F'', ''FULL'', ''E'', ''EMPTY'') DN_FULL_MT
                        ,DISCHARGE_STATUS
                        ,COUNT(DN_EQUIPMENT_NO) COUNT
                        ,(SUM(DN_EQ_SIZE)/20) NO_OF_TEU
                FROM     TOS_DL_BOOKED_DISCHARGE
                WHERE     TOS_DL_BOOKED_DISCHARGE.RECORD_STATUS = ''A''
                AND     FK_DISCHARGE_LIST_ID = ''' ||
               P_I_V_DISCHARGE_ID || '''
                GROUP BY GROUPING SETS(FK_SLOT_OPERATOR,(FK_SLOT_OPERATOR,FK_CONTAINER_OPERATOR,DN_FULL_MT, DN_EQ_SIZE||DN_EQ_TYPE, DN_FULL_MT, DISCHARGE_STATUS ),(''''))'; -- *14

    /* Execute the SQL */
    OPEN P_O_REFSUMMARYTABFIND FOR G_V_SQL;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_ERROR := PCE_EUT_COMMON.G_V_GE0004;
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));
    WHEN OTHERS THEN
      P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) || ':' ||
                     SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));
  END PRE_EDL_SUMMARY_TAB_FIND;

  -- This procedure called to get additional where clause conditions.
  PROCEDURE ADDITION_WHERE_CONDTIONS(P_I_V_IN   IN VARCHAR2
                                    ,P_I_V_FIND IN VARCHAR2
                                    ,P_I_V_TAB  IN VARCHAR2

                                     ) AS
    L_V_IN            VARCHAR2(30);
    DUPLICATE_STOWAGE VARCHAR2(1) := 'd'; -- *5
  BEGIN
    -- Where condition for BOOKED TAB.
    IF (P_I_V_TAB = 'BOOKED_TAB') THEN
      --  when BB Cargo is selectd
      IF (P_I_V_IN = 'BBCARGO') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SHIPMENT_TERM = ''BBK''';
      END IF;
      --  when COC Customer is selectd
      IF (P_I_V_IN = 'COCCUST') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''N''';
      END IF;
      --  when COC Empty is selectd
      IF (P_I_V_IN = 'COCEMPTY') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''ER''';
      END IF;
      -- when COC Transshipped  is selectd
      IF (P_I_V_IN = 'COCTRANS') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
      END IF;
      --  when DG Cargo is selectd
      IF (P_I_V_IN = 'DGCARGO') THEN
        -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
        G_V_SQL := G_V_SQL ||
                   ' AND (DN_SPECIAL_HNDL = ''D1'' OR FK_UNNO IS NOT NULL OR FK_UN_VAR IS NOT NULL OR FLASH_UNIT IS NOT NULL OR NVL(FLASH_POINT,0)!=0)'; -- IMO class NOT FOUND.
      END IF;
      --  when OOG Cargo is selectd
      IF (P_I_V_IN = 'OOGCARGO') THEN
        -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
        G_V_SQL := G_V_SQL ||
                   ' AND (DN_SPECIAL_HNDL = ''O0'' OR NVL(OVERHEIGHT_CM,0) != 0  OR NVL(OVERLENGTH_FRONT_CM,0)!= 0 OR NVL(OVERWIDTH_RIGHT_CM,0)!= 0 OR NVL(OVERWIDTH_LEFT_CM,0)!= 0)'; -- Over Length in Back  NOT FOUND.
      END IF;
      --  when Reefer Cargo is selectd
      IF (P_I_V_IN = 'REEFERCARGO') THEN
        -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
        G_V_SQL := G_V_SQL ||
                   ' AND (DN_SPECIAL_HNDL != ''NR'' OR NVL(REEFER_TEMPERATURE,0) != 0 OR REEFER_TMP_UNIT IS NOT NULL OR NVL(DN_HUMIDITY,0)!= 0 OR NVL(DN_VENTILATION,0)!=0)';
      END IF;
      --  when SOC all is selectd
      IF (P_I_V_IN = 'SOCALL') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SOC_COC  = ''S''';
      END IF;
      --  when SOC is selectd
      IF (P_I_V_IN = 'SOCDIRECT') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''N''';
      END IF;
      --  when SOC Partner is selectd
      IF (P_I_V_IN = 'SOCPARTNER') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''FC''';
      END IF;

      -- when SOC transshipped is selectd
      IF (P_I_V_IN = 'SOCTRANS') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;

      --  when Tight Connection is selectd
      -- IF(p_i_v_in = 'TIGHTCON') then
      --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
      -- END IF;

      --  when Transshipped is selectd
      IF (P_I_V_IN = 'TRANSSHPD') THEN
        G_V_SQL := G_V_SQL || ' AND LOCAL_STATUS = ''T''';
      END IF;
      -- when With Remarks is selectd
      IF (P_I_V_IN = 'WITHREM') THEN
        G_V_SQL := G_V_SQL || ' AND PUBLIC_REMARK IS NOT NULL';
      END IF;

      -- add the find value in dynamic sql queries booked .
      -- *************************************************************************************
      IF (P_I_V_IN = 'FK_BOOKING_NO') THEN
        G_V_SQL := G_V_SQL || ' AND FK_BOOKING_NO = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_BKG_TYP') THEN
        G_V_SQL := G_V_SQL || ' AND DN_BKG_TYP = DECODE(''' || P_I_V_FIND ||
                   ''',''NORMAL'',''N'',
                                                                                     ''EMPTY REPOSITIONING'',''ER'',
                                                                                     ''FEEDER CARGO'',''FC'',
                                                                                     ''' ||
                   P_I_V_FIND || ''')'; -- *21
      END IF;
      IF (P_I_V_IN = 'FK_CONTAINER_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND FK_CONTAINER_OPERATOR = ''' ||
                   P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DISCHARGE_STATUS') THEN
        G_V_SQL := G_V_SQL || ' AND  DISCHARGE_STATUS = DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''BOOKED'',''BK'',
                                                                            ''DISCHARGED'',''DI'',
                                                                            ''RETAINED ON BOARD'',''RB'',
                                                                            ''ROB'',''RB'',
                                                                            ''SHORT LANDED'',''SL'',
                                                                            ''' ||
                   P_I_V_FIND || ''')'; -- *21
      END IF;

      /* *21 start * */
      IF (P_I_V_IN = 'LOADING_STATUS') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_LOADING_STATUS = DECODE(''' ||
                   P_I_V_FIND || ''',
                                                                                ''BOOKED'',''BK'',
                                                                                ''LOADED'',''LO'',
                                                                                ''RETAINED ON BOARD'',''RB'',
                                                                                ''ROB'',''RB'',
                                                                                ''SHORT SHIPPED'',''SS'',
                                                                                ''' ||
                   P_I_V_FIND || ''')';
      END IF;
      /* *21 end * */

      IF (P_I_V_IN = 'DN_EQUIPMENT_NO') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_EQUIPMENT_NO = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'LOAD_CONDITION') THEN
        G_V_SQL := G_V_SQL || ' AND LOAD_CONDITION =  DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''EMPTY'',''E'',
                                                                                          ''FULL'',''F'',
                                                                                          ''BUNDLE'',''P'',
                                                                                          ''BASE'',''B'',
                                                                                          ''RESIDUE'',''R'',
                                                                                          ''BREAK BULK'',''L'',
                                                                            ''' ||
                   P_I_V_FIND || ''')'; -- *21
      END IF;
      IF (P_I_V_IN = 'LOCAL_STATUS') THEN
        G_V_SQL := G_V_SQL || ' AND LOCAL_STATUS =  DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''LOCAL'',''L'',
                                                                                          ''TRANSHIPMENT'',''T'',
                                                                            ''' ||
                   P_I_V_FIND || ''')'; -- *21
      END IF;
      IF (P_I_V_IN = 'LOCAL_TERMINAL_STATUS') THEN
        G_V_SQL := G_V_SQL || ' AND LOCAL_TERMINAL_STATUS = ''' ||
                   P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_VESSEL') THEN
        G_V_SQL := G_V_SQL || ' AND  MLO_VESSEL= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_VOYAGE') THEN
        G_V_SQL := G_V_SQL || ' AND  MLO_VOYAGE= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_NXT_POD1') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_NXT_POD1= ''' || P_I_V_FIND || '''';
      END IF;

      IF (P_I_V_IN = 'DN_NXT_POD2') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_NXT_POD2= ''' || P_I_V_FIND || '''';
      END IF;

      IF (P_I_V_IN = 'DN_NXT_POD3') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_NXT_POD3= ''' || P_I_V_FIND || '''';
      END IF;

      IF (P_I_V_IN = 'DN_NXT_SRV') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_NXT_SRV= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_NXT_VESSEL') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_NXT_VESSEL = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_NXT_VOYAGE') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_NXT_VOYAGE= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_POD1') THEN
        G_V_SQL := G_V_SQL || ' AND  MLO_POD1 = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_POD2') THEN
        G_V_SQL := G_V_SQL || ' AND MLO_POD2 = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_POD3') THEN
        G_V_SQL := G_V_SQL || ' AND MLO_POD3 = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'OUT_SLOT_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND OUT_SLOT_OPERATOR = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_POL') THEN
        G_V_SQL := G_V_SQL || ' AND DN_POL = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_SHIPMENT_TYP') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SHIPMENT_TYP = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_EQ_SIZE') THEN
        G_V_SQL := G_V_SQL || ' AND DN_EQ_SIZE = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'FK_SLOT_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND FK_SLOT_OPERATOR = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_SOC_COC') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SOC_COC = DECODE(''' || P_I_V_FIND ||
                   ''',''SOC'',''S'',
                                                                                     ''COC'',''C'')';
      END IF;
      IF (P_I_V_IN = 'DN_SPECIAL_HNDL') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SPECIAL_HNDL = DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''OOG'',''O0'',
                                                                                          ''DG'',''D1'',
                                                                                          ''NORMAL'',''N'',
                                                                                          ''DOOR AJAR'',''DA'',
                                                                                          ''OPEN DOOR'',''OD'',
                                                                                          ''NON REFER '',''NR'')';
      END IF;

      IF (P_I_V_IN = 'DN_EQ_TYPE') THEN
        G_V_SQL := G_V_SQL || ' AND DN_EQ_TYPE = ''' || P_I_V_FIND || '''';
      END IF;

      IF (P_I_V_IN = 'L3EQPNUM') THEN
        L_V_IN  := '%' || P_I_V_FIND;
        G_V_SQL := G_V_SQL || ' AND  DN_EQUIPMENT_NO LIKE ''' || L_V_IN || '''';
      END IF;

      /*
          *5: Changes start
      */
      IF (P_I_V_IN = 'STOWAGE_POSITION') THEN
        /*
            if user input 'd', show only duplicate container.
        */
        IF LOWER(P_I_V_FIND) = DUPLICATE_STOWAGE THEN
          /* logic to get duplicate cell location */
          G_V_SQL := G_V_SQL || ' AND STOWAGE_POSITION IN ' ||
                     '(SELECT STOWAGE_POSITION ' || 'FROM ' ||
                     '  (SELECT STOWAGE_POSITION, ' ||
                     '    FK_DISCHARGE_LIST_ID ' ||
                     '  FROM TOS_DL_BOOKED_DISCHARGE IBD ' ||
                     '  WHERE STOWAGE_POSITION      IS NOT NULL ' ||
                     '  AND RECORD_STATUS= ''A'' ' -- *25
                     || '  AND IBD.FK_DISCHARGE_LIST_ID = ''' ||
                     G_V_DISCHARGE_LIST_ID || ''' ' ||
                     '  GROUP BY STOWAGE_POSITION, ' ||
                     '    FK_DISCHARGE_LIST_ID ' ||
                     '  HAVING COUNT(1) > ''1'' ' || '  ) ' || ') ';
        ELSE
          G_V_SQL := G_V_SQL || ' AND STOWAGE_POSITION = ''' || P_I_V_FIND || '''';
        END IF;

      END IF; -- End of stowage position if block
      /*
          *5: Changes end
      */

      /*
          *7: Changes start
      */
      IF (P_I_V_IN = 'EX_MLO_VESSEL') THEN
        G_V_SQL := G_V_SQL || ' AND MLO_VESSEL = ''' || P_I_V_FIND || ''' ';
      END IF;
      IF (P_I_V_IN = 'EX_MLO_VOYAGE') THEN
        G_V_SQL := G_V_SQL || ' AND MLO_VOYAGE = ''' || P_I_V_FIND || ''' ';
      END IF;
      /*
          *7: Changes end
      */

      -- *************************************************************************************

      -- Where condition for OVERLANDED TAB.
    ELSIF (P_I_V_TAB = 'OVERLANDED_TAB') THEN

      --  when BB Cargo is selectd
      IF (P_I_V_IN = 'BBCARGO') THEN
        G_V_SQL := G_V_SQL || ' AND SHIPMENT_TERM = ''BBK''';
      END IF;
      --  when COC Customer is selectd
      IF (P_I_V_IN = 'COCCUST') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''N''';
      END IF;
      --  when COC Empty is selectd
      IF (P_I_V_IN = 'COCEMPTY') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''ER''';
      END IF;
      --  when COC Transshipped  is selectd
      IF (P_I_V_IN = 'COCTRANS') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND FLAG_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
      END IF;
      --  when DG Cargo is selectd
      IF (P_I_V_IN = 'DGCARGO') THEN
        -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
        G_V_SQL := G_V_SQL ||
                   ' AND (SPECIAL_HANDLING = ''D1'' OR UN_NUMBER IS NOT NULL  OR UN_NUMBER_VARIANT IS NOT NULL OR FLASHPOINT_UNIT IS NOT NULL OR NVL(FLASHPOINT,0)!= 0 )'; -- IMO class NOT FOUND.
      END IF;

      --  when OOG Cargo is selectd
      IF (P_I_V_IN = 'OOGCARGO') THEN
        -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
        G_V_SQL := G_V_SQL ||
                   ' AND (SPECIAL_HANDLING = ''O0''  OR NVL(OVERHEIGHT_CM,0) != 0  OR NVL(OVERLENGTH_FRONT_CM,0)!= 0 OR NVL(OVERWIDTH_RIGHT_CM,0)!= 0 OR NVL(OVERWIDTH_LEFT_CM,0)!= 0)'; -- Over Length in Back  NOT FOUND.
      END IF;
      --  when Reefer Cargo is selectd
      IF (P_I_V_IN = 'REEFERCARGO') THEN
        -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
        G_V_SQL := G_V_SQL ||
                   ' AND (SPECIAL_HANDLING != ''NR''OR NVL(REEFER_TEMPERATURE,0)!=0 OR REEFER_TMP_UNIT IS NOT NULL OR NVL(HUMIDITY,0) !=0 OR NVL(VENTILATION,0)!=0)';
      END IF;
      --  when SOC all is selectd
      IF (P_I_V_IN = 'SOCALL') THEN
        G_V_SQL := G_V_SQL || ' AND FLAG_SOC_COC  = ''S''';
      END IF;
      --  when SOC is selectd
      IF (P_I_V_IN = 'SOCDIRECT') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''N''';
      END IF;
      --  when SOC Partner is selectd
      IF (P_I_V_IN = 'SOCPARTNER') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''FC''';
      END IF;

      --  when SOC transshipped is selectd
      IF (P_I_V_IN = 'SOCTRANS') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND FLAG_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;

      --  when Tight Connection is selectd
      -- IF(p_i_v_in = 'TIGHTCON') then
      --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
      -- END IF;

      --  when Transshipped is selectd
      IF (P_I_V_IN = 'TRANSSHPD') THEN
        G_V_SQL := G_V_SQL || ' AND LOCAL_STATUS = ''T''';
      END IF;

      -- add the find value in dynamic sql queries for overlanded tab.
      -- *************************************************************************************
      IF (P_I_V_IN = 'BOOKING_NO') THEN
        G_V_SQL := G_V_SQL || ' AND BOOKING_NO = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'BKG_TYP') THEN
        G_V_SQL := G_V_SQL || ' AND BKG_TYP = DECODE(''' || P_I_V_FIND ||
                   ''',''NORMAL'',''N'',''EMPTY REPOSITIONING'',''ER'',''FEEDER CARGO'',''FC'')';
      END IF;
      IF (P_I_V_IN = 'CONTAINER_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND CONTAINER_OPERATOR = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'EQUIPMENT_NO') THEN
        G_V_SQL := G_V_SQL || ' AND EQUIPMENT_NO = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'LOAD_CONDITION') THEN
        G_V_SQL := G_V_SQL || ' AND LOAD_CONDITION =  DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''EMPTY'',''E'',''FULL'',''F'',''BUNDLE'',''P'',''BASE'',''B'',''RESIDUE'',''R'',''BREAK BULK'',''L'')';
      END IF;
      IF (P_I_V_IN = 'LOCAL_STATUS') THEN
        G_V_SQL := G_V_SQL || ' AND LOCAL_STATUS =  DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''LOCAL'',''L'',''TRANSHIPMENT'',''T'')';
      END IF;
      IF (P_I_V_IN = 'LOCAL_TERMINAL_STATUS') THEN
        G_V_SQL := G_V_SQL || ' AND LOCAL_TERMINAL_STATUS = ''' ||
                   P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_VESSEL') THEN
        G_V_SQL := G_V_SQL || ' AND MLO_VESSEL= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_VOYAGE') THEN
        G_V_SQL := G_V_SQL || ' AND  MLO_VOYAGE= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'NXT_POD1') THEN
        G_V_SQL := G_V_SQL || ' AND NXT_POD1= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'NXT_POD2') THEN
        G_V_SQL := G_V_SQL || ' AND NXT_POD2= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'NXT_POD3') THEN
        G_V_SQL := G_V_SQL || ' AND NXT_POD3= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'NXT_SRV') THEN
        G_V_SQL := G_V_SQL || ' AND NXT_SRV= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'NXT_VESSEL') THEN
        G_V_SQL := G_V_SQL || ' AND NXT_VESSEL = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'NXT_VOYAGE') THEN
        G_V_SQL := G_V_SQL || ' AND NXT_VOYAGE= ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_POD1') THEN
        G_V_SQL := G_V_SQL || ' AND MLO_POD1 = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_POD2') THEN
        G_V_SQL := G_V_SQL || ' AND MLO_POD2 = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'MLO_POD3') THEN
        G_V_SQL := G_V_SQL || ' AND MLO_POD3 = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'OUT_SLOT_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND OUT_SLOT_OPERATOR = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'POL') THEN
        G_V_SQL := G_V_SQL || ' AND POL = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'SHIPMENT_TYP') THEN
        G_V_SQL := G_V_SQL || ' AND SHIPMENT_TYP = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'EQ_SIZE') THEN
        G_V_SQL := G_V_SQL || ' AND EQ_SIZE = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'SLOT_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND SLOT_OPERATOR = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'FLAG_SOC_COC') THEN
        G_V_SQL := G_V_SQL || ' AND FLAG_SOC_COC = DECODE(''' || P_I_V_FIND ||
                   ''',''SOC'',''S'',''COC'',''C'')';
      END IF;
      IF (P_I_V_IN = 'SPECIAL_HANDLING') THEN
        G_V_SQL := G_V_SQL || ' AND SPECIAL_HANDLING = DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''OOG'',''O0'',''DG'',''D1'',''NORMAL'',''N'',''DOOR AJAR'',''DA'',''OPEN DOOR'',''OD'',''NON REFER '',''NR'')';
      END IF;
      IF (P_I_V_IN = 'EQ_TYPE') THEN
        G_V_SQL := G_V_SQL || ' AND EQ_TYPE = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'L3EQPNUM') THEN
        L_V_IN  := '%' || P_I_V_FIND;
        G_V_SQL := G_V_SQL || ' AND  EQUIPMENT_NO LIKE ''' || L_V_IN || '''';
      END IF;

      IF (P_I_V_IN = 'STOWAGE_POSITION') THEN
        G_V_SQL := G_V_SQL || ' AND STOWAGE_POSITION = ''' || P_I_V_FIND || '''';
      END IF;

      /*
          *11: Changes start
      */
      IF (P_I_V_IN = 'POL_TERMINAL') THEN
        G_V_SQL := G_V_SQL || ' AND POL_TERMINAL = ''' || P_I_V_FIND || '''';
      END IF;
      /*
          *11: Changes end
      */

      -- *************************************************************************************

      -- Where condition for restow tab.
    ELSIF (P_I_V_TAB = 'RESTOW_TAB') THEN
      --  when BB Cargo is selectd
      IF (P_I_V_IN = 'BBCARGO') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SHIPMENT_TERM = ''BBK''';
      END IF;
      --  when COC Customer is selectd
      IF (P_I_V_IN = 'COCCUST') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''C'' AND FK_BKG_SIZE_TYPE_DTL = ''N''';
      END IF;
      --  when COC Empty is selectd
      IF (P_I_V_IN = 'COCEMPTY') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''C'' AND FK_BKG_SIZE_TYPE_DTL = ''ER''';
      END IF;
      --  when COC Transshipped  is selectd
      IF (P_I_V_IN = 'COCTRANS') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
      END IF;
      --  when SOC all is selectd
      IF (P_I_V_IN = 'SOCALL') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SOC_COC  = ''S''';
      END IF;
      --  when SOC is selectd
      IF (P_I_V_IN = 'SOCDIRECT') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''S'' AND FK_BKG_SIZE_TYPE_DTL = ''N''';
      END IF;
      --  when SOC Partner is selectd
      IF (P_I_V_IN = 'SOCPARTNER') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''S'' AND FK_BKG_SIZE_TYPE_DTL = ''FC''';
      END IF;

      --  when SOC transshipped is selectd
      IF (P_I_V_IN = 'SOCTRANS') THEN
        G_V_SQL := G_V_SQL ||
                   ' AND DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;
      --  when Tight Connection is selectd
      -- IF(p_i_v_in = 'TIGHTCON') then
      --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
      -- END IF;

      --  when Transshipped is selectd
      IF (P_I_V_IN = 'TRANSSHPD') THEN
        G_V_SQL := G_V_SQL || 'AND LOCAL_STATUS = ''T''';
      END IF;
      --  when With Remarks is selectd
      IF (P_I_V_IN = 'WITHREM') THEN
        G_V_SQL := G_V_SQL || ' AND PUBLIC_REMARK IS NOT NULL';
      END IF;

      -- add the find value in dynamic sql queries.
      -- *************************************************************************************
      IF (P_I_V_IN = 'FK_BOOKING_NO') THEN
        G_V_SQL := G_V_SQL || ' AND FK_BOOKING_NO = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'FK_CONTAINER_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND FK_CONTAINER_OPERATOR = ''' ||
                   P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_EQUIPMENT_NO') THEN
        G_V_SQL := G_V_SQL || ' AND DN_EQUIPMENT_NO = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'LOAD_CONDITION') THEN
        G_V_SQL := G_V_SQL || ' AND LOAD_CONDITION =  DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''EMPTY'',''E'',''FULL'',''F'',''BUNDLE'',''P'',''BASE'',''B'',''RESIDUE'',''R'',''BREAK BULK'',''L'')';
      END IF;
      IF (P_I_V_IN = 'DN_SHIPMENT_TYP') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SHIPMENT_TYP = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_EQ_SIZE') THEN
        G_V_SQL := G_V_SQL || ' AND DN_EQ_SIZE = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'FK_SLOT_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND FK_SLOT_OPERATOR = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'DN_SOC_COC') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SOC_COC  = DECODE(''' || P_I_V_FIND ||
                   ''',''SOC'',''S'',''COC'',''C'')';
      END IF;
      IF (P_I_V_IN = 'DN_SPECIAL_HNDL') THEN
        G_V_SQL := G_V_SQL || ' AND DN_SPECIAL_HNDL = DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''OOG'',''O0'',''DG'',''D1'',''NORMAL'',''N'',''DOOR AJAR'',''DA'',''OPEN DOOR'',''OD'',''NON REFER '',''NR'')';
      END IF;
      IF (P_I_V_IN = 'DN_EQ_TYPE') THEN
        G_V_SQL := G_V_SQL || ' AND  DN_EQ_TYPE = ''' || P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'L3EQPNUM') THEN
        L_V_IN  := '%' || P_I_V_FIND;
        G_V_SQL := G_V_SQL || ' AND DN_EQUIPMENT_NO LIKE ''' || L_V_IN || '''';
      END IF;
      -- *************************************************************************************
      -- Where condition for summary tab.
      -- ELSIF (p_i_v_tab = 'SUMMARY_TAB') THEN
    END IF;

  END ADDITION_WHERE_CONDTIONS;

  PROCEDURE PRE_EDL_SAVE_BOOKED_TAB_DATA(P_I_V_SESSION_ID              VARCHAR2
                                        ,P_I_V_SEQ_NO                  VARCHAR2
                                        ,P_I_V_DISCHARGE_LIST_ID       VARCHAR2
                                        ,P_I_V_DN_EQUIPMENT_NO         VARCHAR2
                                        ,P_I_V_LOCAL_TERMINAL_STATUS   VARCHAR2
                                        ,P_I_V_MIDSTREAM_HANDLING_CODE VARCHAR2
                                        ,P_I_V_LOAD_CONDITION          VARCHAR2
                                        ,P_I_V_DISCHARGE_STATUS        VARCHAR2
                                        ,P_I_V_STOWAGE_POSITION        VARCHAR2
                                        ,P_I_V_ACTIVITY_DATE_TIME      VARCHAR2
                                        ,P_I_V_CONTAINER_GROSS_WEIGHT  VARCHAR2
                                        ,P_I_V_DAMAGED                 VARCHAR2
                                        ,P_I_V_FK_CONTAINER_OPERATOR   VARCHAR2
                                        ,P_I_V_SLOT_OPERATOR           VARCHAR2
                                        ,P_I_V_SEAL_NO                 VARCHAR2
                                        ,P_I_V_MLO_VESSEL              VARCHAR2
                                        ,P_I_V_MLO_VOYAGE              VARCHAR2
                                        ,P_I_V_MLO_VESSEL_ETA          VARCHAR2
                                        ,P_I_V_MLO_POD1                VARCHAR2
                                        ,P_I_V_MLO_POD2                VARCHAR2
                                        ,P_I_V_MLO_POD3                VARCHAR2
                                        ,P_I_V_MLO_DEL                 VARCHAR2
                                        ,P_I_V_SWAP_CONNECTION_ALLOWED VARCHAR2
                                        ,P_I_V_HANDLING_INST1          VARCHAR2
                                        ,P_I_V_HANDLING_INST2          VARCHAR2
                                        ,P_I_V_HANDLING_INST3          VARCHAR2
                                        ,P_I_V_CONTAINER_LOADING_REM_1 VARCHAR2
                                        ,P_I_V_CONTAINER_LOADING_REM_2 VARCHAR2
                                        ,P_I_V_TIGHT_CONNECTION_FLAG1  VARCHAR2
                                        ,P_I_V_TIGHT_CONNECTION_FLAG2  VARCHAR2
                                        ,P_I_V_TIGHT_CONNECTION_FLAG3  VARCHAR2
                                        ,P_I_V_FK_IMDG                 VARCHAR2
                                        ,P_I_V_FK_UNNO                 VARCHAR2
                                        ,P_I_V_FK_UN_VAR               VARCHAR2
                                        ,P_I_V_FK_PORT_CLASS           VARCHAR2
                                        ,P_I_V_FK_PORT_CLASS_TYP       VARCHAR2
                                        ,P_I_V_FLASH_UNIT              VARCHAR2
                                        ,P_I_V_FLASH_POINT             VARCHAR2
                                        ,P_I_V_FUMIGATION_ONLY         VARCHAR2
                                        ,P_I_V_OVERHEIGHT_CM           VARCHAR2
                                        ,P_I_V_OVERWIDTH_LEFT_CM       VARCHAR2
                                        ,P_I_V_OVERWIDTH_RIGHT_CM      VARCHAR2
                                        ,P_I_V_OVERLENGTH_FRONT_CM     VARCHAR2
                                        ,P_I_V_OVERLENGTH_REAR_CM      VARCHAR2
                                        ,P_I_V_REEFER_TEMPERATURE      VARCHAR2
                                        ,P_I_V_REEFER_TMP_UNIT         VARCHAR2
                                        ,P_I_V_PUBLIC_REMARK           VARCHAR2
                                        ,P_I_V_OUT_SLOT_OPERATOR       VARCHAR2
                                        ,P_I_V_USER_ID                 VARCHAR2
                                        ,P_I_V_OPN_STS                 VARCHAR2
                                        ,P_I_V_RESIDUE_ONLY_FLAG       VARCHAR2
                                        ,P_I_V_HUMIDITY                VARCHAR2
                                        ,P_I_V_VENTILATION             VARCHAR2
                                        ,P_I_V_CRAN_DESCRIPTION        VARCHAR2 -- *10
                                        ,P_O_V_ERROR                   OUT VARCHAR2) AS
    TEST_EXCEPTION EXCEPTION;

  BEGIN
    /* Set Success Code  */
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    -- Update data in TOS_DL_BOOKED_DISCHARGE_TMP
    UPDATE TOS_DL_BOOKED_DISCHARGE_TMP
       SET DN_EQUIPMENT_NO           = P_I_V_DN_EQUIPMENT_NO
          ,LOCAL_TERMINAL_STATUS     = P_I_V_LOCAL_TERMINAL_STATUS
          ,MIDSTREAM_HANDLING_CODE   = P_I_V_MIDSTREAM_HANDLING_CODE
          ,LOAD_CONDITION            = P_I_V_LOAD_CONDITION
          ,DISCHARGE_STATUS          = P_I_V_DISCHARGE_STATUS
          ,STOWAGE_POSITION          = P_I_V_STOWAGE_POSITION
          ,ACTIVITY_DATE_TIME        = P_I_V_ACTIVITY_DATE_TIME
          ,CONTAINER_GROSS_WEIGHT    = REPLACE(P_I_V_CONTAINER_GROSS_WEIGHT,
                                               ',',
                                               '')
          ,DAMAGED                   = P_I_V_DAMAGED
          ,FK_CONTAINER_OPERATOR     = P_I_V_FK_CONTAINER_OPERATOR
          ,OUT_SLOT_OPERATOR         = P_I_V_OUT_SLOT_OPERATOR
          ,SEAL_NO                   = P_I_V_SEAL_NO
          ,MLO_VESSEL                = P_I_V_MLO_VESSEL
          ,MLO_VOYAGE                = P_I_V_MLO_VOYAGE
          ,MLO_VESSEL_ETA            = P_I_V_MLO_VESSEL_ETA
          ,MLO_POD1                  = P_I_V_MLO_POD1
          ,MLO_POD2                  = P_I_V_MLO_POD2
          ,MLO_POD3                  = P_I_V_MLO_POD3
          ,MLO_DEL                   = P_I_V_MLO_DEL -- place of delevery
          ,SWAP_CONNECTION_ALLOWED   = P_I_V_SWAP_CONNECTION_ALLOWED
          ,FK_HANDLING_INSTRUCTION_1 = P_I_V_HANDLING_INST1
          ,FK_HANDLING_INSTRUCTION_2 = P_I_V_HANDLING_INST2
          ,FK_HANDLING_INSTRUCTION_3 = P_I_V_HANDLING_INST3
          ,CONTAINER_LOADING_REM_1   = P_I_V_CONTAINER_LOADING_REM_1
          ,CONTAINER_LOADING_REM_2   = P_I_V_CONTAINER_LOADING_REM_2
          ,TIGHT_CONNECTION_FLAG1    = P_I_V_TIGHT_CONNECTION_FLAG1
          ,TIGHT_CONNECTION_FLAG2    = P_I_V_TIGHT_CONNECTION_FLAG2
          ,TIGHT_CONNECTION_FLAG3    = P_I_V_TIGHT_CONNECTION_FLAG3
          ,FK_IMDG                   = P_I_V_FK_IMDG
          ,FK_UNNO                   = P_I_V_FK_UNNO
          ,FK_UN_VAR                 = P_I_V_FK_UN_VAR
          ,FK_PORT_CLASS             = P_I_V_FK_PORT_CLASS
          ,FK_PORT_CLASS_TYP         = P_I_V_FK_PORT_CLASS_TYP
          ,FLASH_UNIT                = P_I_V_FLASH_UNIT
          ,FLASH_POINT               = P_I_V_FLASH_POINT
          ,FUMIGATION_ONLY           = P_I_V_FUMIGATION_ONLY
          ,RESIDUE_ONLY_FLAG         = P_I_V_RESIDUE_ONLY_FLAG
          ,OVERHEIGHT_CM             = REPLACE(P_I_V_OVERHEIGHT_CM, ',', '')
          ,OVERWIDTH_LEFT_CM         = REPLACE(P_I_V_OVERWIDTH_LEFT_CM,
                                               ',',
                                               '')
          ,OVERWIDTH_RIGHT_CM        = REPLACE(P_I_V_OVERWIDTH_RIGHT_CM,
                                               ',',
                                               '')
          ,OVERLENGTH_FRONT_CM       = REPLACE(P_I_V_OVERLENGTH_FRONT_CM,
                                               ',',
                                               '')
          ,OVERLENGTH_REAR_CM        = REPLACE(P_I_V_OVERLENGTH_REAR_CM,
                                               ',',
                                               '')
          ,REEFER_TEMPERATURE        = REPLACE(P_I_V_REEFER_TEMPERATURE,
                                               ',',
                                               '')
          ,REEFER_TMP_UNIT           = P_I_V_REEFER_TMP_UNIT
          ,DN_HUMIDITY               = REPLACE(P_I_V_HUMIDITY, ',', '')
          ,DN_VENTILATION            = REPLACE(P_I_V_VENTILATION, ',', '')
          ,PUBLIC_REMARK             = P_I_V_PUBLIC_REMARK
          ,OPN_STATUS                = P_I_V_OPN_STS
          ,CRANE_TYPE                = P_I_V_CRAN_DESCRIPTION -- *10
          ,RECORD_CHANGE_USER        = P_I_V_USER_ID
     WHERE SESSION_ID = P_I_V_SESSION_ID
       AND SEQ_NO = P_I_V_SEQ_NO;

  EXCEPTION
    --   WHEN test_exception THEN
    --        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
    WHEN OTHERS THEN
      P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) || ':' ||
                     SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));
  END PRE_EDL_SAVE_BOOKED_TAB_DATA;

  PROCEDURE PRE_EDL_SAVE_OVERLAND_TAB_DATA(P_I_V_SESSION_ID              VARCHAR2
                                          ,P_I_V_SEQ_NO                  IN OUT VARCHAR2
                                          ,P_I_V_OVERLANDED_CONTAINER_ID VARCHAR2
                                          ,P_I_V_DISCHARGE_LIST_ID       VARCHAR2
                                          ,P_I_V_BOOKING_NO              VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO            VARCHAR2
                                          ,P_I_V_EQ_SIZE                 VARCHAR2
                                          ,P_I_V_EQ_TYPE                 VARCHAR2
                                          ,P_I_V_FULL_MT                 VARCHAR2
                                          ,P_I_V_BKG_TYP                 VARCHAR2
                                          ,P_I_V_FLAG_SOC_COC            VARCHAR2
                                          ,P_I_V_SHIPMENT_TERM           VARCHAR2
                                          ,P_I_V_SHIPMENT_TYP            VARCHAR2
                                          ,P_I_V_LOCAL_STATUS            VARCHAR2
                                          ,P_I_V_LOCAL_TERMINAL_STATUS   VARCHAR2
                                          ,P_I_V_MIDSTREAM_HANDLING_CODE VARCHAR2
                                          ,P_I_V_LOAD_CONDITION          VARCHAR2
                                          ,P_I_V_STOWAGE_POSITION        VARCHAR2
                                          ,P_I_V_ACTIVITY_DATE_TIME      VARCHAR2
                                          ,P_I_V_CONTAINER_GROSS_WEIGHT  VARCHAR2
                                          ,P_I_V_DAMAGED                 VARCHAR2
                                          ,P_I_V_SLOT_OPERATOR           VARCHAR2
                                          ,P_I_V_CONTAINER_OPERATOR      VARCHAR2
                                          ,P_I_V_OUT_SLOT_OPERATOR       VARCHAR2
                                          ,P_I_V_SPECIAL_HANDLING        VARCHAR2
                                          ,P_I_V_SEAL_NO                 VARCHAR2
                                          ,P_I_V_POL                     VARCHAR2
                                          ,P_I_V_POL_TERMINAL            VARCHAR2
                                          ,P_I_V_NXT_SRV                 VARCHAR2
                                          ,P_I_V_NXT_VESSEL              VARCHAR2
                                          ,P_I_V_NXT_VOYAGE              VARCHAR2
                                          ,P_I_V_NXT_DIR                 VARCHAR2
                                          ,P_I_V_MLO_VESSEL              VARCHAR2
                                          ,P_I_V_MLO_VOYAGE              VARCHAR2
                                          ,P_I_V_MLO_VESSEL_ETA          VARCHAR2
                                          ,P_I_V_MLO_POD1                VARCHAR2
                                          ,P_I_V_MLO_POD2                VARCHAR2
                                          ,P_I_V_MLO_POD3                VARCHAR2
                                          ,P_I_V_MLO_DEL                 VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_1  VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_2  VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_3  VARCHAR2
                                          ,P_I_V_CONTAINER_LOADING_REM_1 VARCHAR2
                                          ,P_I_V_CONTAINER_LOADING_REM_2 VARCHAR2
                                          ,P_I_V_SPECIAL_CARGO           VARCHAR2
                                          ,P_I_V_IMDG_CLASS              VARCHAR2
                                          ,P_I_V_UN_NUMBER               VARCHAR2
                                          ,P_I_V_UN_VAR                  VARCHAR2
                                          ,P_I_V_PORT_CLASS              VARCHAR2
                                          ,P_I_V_PORT_CLASS_TYP          VARCHAR2
                                          ,P_I_V_FLASHPOINT_UNIT         VARCHAR2
                                          ,P_I_V_FLASHPOINT              VARCHAR2
                                          ,P_I_V_FUMIGATION_ONLY         VARCHAR2
                                          ,P_I_V_RESIDUE_ONLY_FLAG       VARCHAR2
                                          ,P_I_V_OVERHEIGHT_CM           VARCHAR2
                                          ,P_I_V_OVERWIDTH_LEFT_CM       VARCHAR2
                                          ,P_I_V_OVERWIDTH_RIGHT_CM      VARCHAR2
                                          ,P_I_V_OVERLENGTH_FRONT_CM     VARCHAR2
                                          ,P_I_V_OVERLENGTH_REAR_CM      VARCHAR2
                                          ,P_I_V_REEFER_TEMPERATURE      VARCHAR2
                                          ,P_I_V_REEFER_TMP_UNIT         VARCHAR2
                                          ,P_I_V_HUMIDITY                VARCHAR2
                                          ,P_I_V_VENTILATION             VARCHAR2
                                          ,P_I_V_DISCHARGE_STATUS        VARCHAR2
                                          ,P_I_V_USER_ID                 VARCHAR2
                                          ,P_I_V_OPN_STS                 VARCHAR2
                                          ,P_I_V_VGM                     VARCHAR2 --*36 
                                          ,P_O_V_ERROR                   OUT VARCHAR2) AS
    L_N_SEQ_NO NUMBER := 0;
  BEGIN
    /* Set Success Code  */
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF (((P_I_V_SEQ_NO = '0') OR (P_I_V_SEQ_NO IS NULL)) AND
       P_I_V_OPN_STS = PCE_EUT_COMMON.G_V_REC_ADD) THEN

      SELECT NVL(MAX(TO_NUMBER(SEQ_NO)), 0) + 1
        INTO L_N_SEQ_NO
        FROM TOS_DL_OVERLANDED_CONT_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID;

      INSERT INTO TOS_DL_OVERLANDED_CONT_TMP
        (SESSION_ID
        ,SEQ_NO
        ,BOOKING_NO
        ,EQUIPMENT_NO
        ,EQ_SIZE
        ,EQ_TYPE
        ,FULL_MT
        ,BKG_TYP
        ,FLAG_SOC_COC
        ,SHIPMENT_TERM
        ,SHIPMENT_TYP
        ,LOCAL_STATUS
        ,LOCAL_TERMINAL_STATUS
        ,MIDSTREAM_HANDLING_CODE
        ,LOAD_CONDITION
        ,STOWAGE_POSITION
        ,ACTIVITY_DATE_TIME
        ,CONTAINER_GROSS_WEIGHT
        ,DAMAGED
        ,SLOT_OPERATOR
        ,CONTAINER_OPERATOR
        ,OUT_SLOT_OPERATOR
        ,SPECIAL_HANDLING
        ,SEAL_NO
        ,POL
        ,POL_TERMINAL
        ,NXT_SRV
        ,NXT_VESSEL
        ,NXT_VOYAGE
        ,NXT_DIR
        ,MLO_VESSEL
        ,MLO_VOYAGE
        ,MLO_VESSEL_ETA
        ,MLO_POD1
        ,MLO_POD2
        ,MLO_POD3
        ,MLO_DEL
        ,HANDLING_INSTRUCTION_1
        ,HANDLING_INSTRUCTION_2
        ,HANDLING_INSTRUCTION_3
        ,CONTAINER_LOADING_REM_1
        ,CONTAINER_LOADING_REM_2
        ,SPECIAL_CARGO
        ,IMDG_CLASS
        ,UN_NUMBER
        ,UN_NUMBER_VARIANT
        ,PORT_CLASS
        ,PORT_CLASS_TYP
        ,FLASHPOINT_UNIT
        ,FLASHPOINT
        ,FUMIGATION_ONLY
        ,RESIDUE_ONLY_FLAG
        ,OVERHEIGHT_CM
        ,OVERWIDTH_LEFT_CM
        ,OVERWIDTH_RIGHT_CM
        ,OVERLENGTH_FRONT_CM
        ,OVERLENGTH_REAR_CM
        ,REEFER_TEMPERATURE
        ,REEFER_TMP_UNIT
        ,HUMIDITY
        ,VENTILATION
        ,FK_DISCHARGE_LIST_ID
        ,RECORD_STATUS
        ,OPN_STATUS
        ,DISCHARGE_STATUS
        ,RECORD_CHANGE_USER
        ,RECORD_CHANGE_DATE
        ,VGM --*36 
        )
      VALUES
        (P_I_V_SESSION_ID
        ,L_N_SEQ_NO
        ,P_I_V_BOOKING_NO
        ,P_I_V_EQUIPMENT_NO
        ,P_I_V_EQ_SIZE
        ,P_I_V_EQ_TYPE
        ,P_I_V_FULL_MT
        ,P_I_V_BKG_TYP
        ,P_I_V_FLAG_SOC_COC
        ,P_I_V_SHIPMENT_TERM
        ,P_I_V_SHIPMENT_TYP
        ,P_I_V_LOCAL_STATUS
        ,P_I_V_LOCAL_TERMINAL_STATUS
        ,P_I_V_MIDSTREAM_HANDLING_CODE
        ,P_I_V_LOAD_CONDITION
        ,P_I_V_STOWAGE_POSITION
        ,P_I_V_ACTIVITY_DATE_TIME
        ,REPLACE(P_I_V_CONTAINER_GROSS_WEIGHT, ',', '')
        ,P_I_V_DAMAGED
        ,P_I_V_SLOT_OPERATOR
        ,P_I_V_CONTAINER_OPERATOR
        ,P_I_V_OUT_SLOT_OPERATOR
        ,P_I_V_SPECIAL_HANDLING
        ,P_I_V_SEAL_NO
        ,P_I_V_POL
        ,P_I_V_POL_TERMINAL
        ,P_I_V_NXT_SRV
        ,P_I_V_NXT_VESSEL
        ,P_I_V_NXT_VOYAGE
        ,P_I_V_NXT_DIR
        ,P_I_V_MLO_VESSEL
        ,P_I_V_MLO_VOYAGE
        ,P_I_V_MLO_VESSEL_ETA
        ,P_I_V_MLO_POD1
        ,P_I_V_MLO_POD2
        ,P_I_V_MLO_POD3
        ,P_I_V_MLO_DEL
        ,P_I_V_HANDLING_INSTRUCTION_1
        ,P_I_V_HANDLING_INSTRUCTION_2
        ,P_I_V_HANDLING_INSTRUCTION_3
        ,P_I_V_CONTAINER_LOADING_REM_1
        ,P_I_V_CONTAINER_LOADING_REM_2
        ,P_I_V_SPECIAL_CARGO
        ,P_I_V_IMDG_CLASS
        ,P_I_V_UN_NUMBER
        ,P_I_V_UN_VAR
        ,P_I_V_PORT_CLASS
        ,P_I_V_PORT_CLASS_TYP
        ,P_I_V_FLASHPOINT_UNIT
        ,REPLACE(P_I_V_FLASHPOINT, ',', '')
        ,P_I_V_FUMIGATION_ONLY
        ,P_I_V_RESIDUE_ONLY_FLAG
        ,REPLACE(P_I_V_OVERHEIGHT_CM, ',', '')
        ,REPLACE(P_I_V_OVERWIDTH_LEFT_CM, ',', '')
        ,REPLACE(P_I_V_OVERWIDTH_RIGHT_CM, ',', '')
        ,REPLACE(P_I_V_OVERLENGTH_FRONT_CM, ',', '')
        ,REPLACE(P_I_V_OVERLENGTH_REAR_CM, ',', '')
        ,REPLACE(P_I_V_REEFER_TEMPERATURE, ',', '')
        ,P_I_V_REEFER_TMP_UNIT
        ,REPLACE(P_I_V_HUMIDITY, ',', '')
        ,REPLACE(P_I_V_VENTILATION, ',', '')
        ,P_I_V_DISCHARGE_LIST_ID
        ,'A'
        ,P_I_V_OPN_STS
        ,P_I_V_DISCHARGE_STATUS
        ,P_I_V_USER_ID
        ,SYSDATE
        ,P_I_V_VGM --*36 
        );
      P_I_V_SEQ_NO := L_N_SEQ_NO;
    ELSE
      -- Update data in TOS_DL_OVERLANDED_CONT_TMP

      UPDATE TOS_DL_OVERLANDED_CONT_TMP
         SET BOOKING_NO              = P_I_V_BOOKING_NO
            ,EQUIPMENT_NO            = P_I_V_EQUIPMENT_NO
            ,EQ_SIZE                 = P_I_V_EQ_SIZE
            ,EQ_TYPE                 = P_I_V_EQ_TYPE
            ,FULL_MT                 = P_I_V_FULL_MT
            ,BKG_TYP                 = P_I_V_BKG_TYP
            ,FLAG_SOC_COC            = P_I_V_FLAG_SOC_COC
            ,SHIPMENT_TERM           = P_I_V_SHIPMENT_TERM
            ,SHIPMENT_TYP            = P_I_V_SHIPMENT_TYP
            ,LOCAL_STATUS            = P_I_V_LOCAL_STATUS
            ,LOCAL_TERMINAL_STATUS   = P_I_V_LOCAL_TERMINAL_STATUS
            ,MIDSTREAM_HANDLING_CODE = P_I_V_MIDSTREAM_HANDLING_CODE
            ,LOAD_CONDITION          = P_I_V_LOAD_CONDITION
            ,STOWAGE_POSITION        = P_I_V_STOWAGE_POSITION
            ,ACTIVITY_DATE_TIME      = P_I_V_ACTIVITY_DATE_TIME
            ,CONTAINER_GROSS_WEIGHT  = REPLACE(P_I_V_CONTAINER_GROSS_WEIGHT,
                                               ',',
                                               '')
            ,DAMAGED                 = P_I_V_DAMAGED
            ,SLOT_OPERATOR           = P_I_V_SLOT_OPERATOR
            ,CONTAINER_OPERATOR      = P_I_V_CONTAINER_OPERATOR
            ,OUT_SLOT_OPERATOR       = P_I_V_OUT_SLOT_OPERATOR
            ,SPECIAL_HANDLING        = P_I_V_SPECIAL_HANDLING
            ,SEAL_NO                 = P_I_V_SEAL_NO
            ,POL                     = P_I_V_POL
            ,POL_TERMINAL            = P_I_V_POL_TERMINAL
            ,NXT_SRV                 = P_I_V_NXT_SRV
            ,NXT_VESSEL              = P_I_V_NXT_VESSEL
            ,NXT_VOYAGE              = P_I_V_NXT_VOYAGE
            ,NXT_DIR                 = P_I_V_NXT_DIR
            ,MLO_VESSEL              = P_I_V_MLO_VESSEL
            ,MLO_VOYAGE              = P_I_V_MLO_VOYAGE
            ,MLO_VESSEL_ETA          = TO_CHAR(TO_DATE(P_I_V_MLO_VESSEL_ETA,
                                                       'DD/MM/YYYY HH24:MI'),
                                               'DD/MM/YYYY HH24:MI')
            ,MLO_POD1                = P_I_V_MLO_POD1
            ,MLO_POD2                = P_I_V_MLO_POD2
            ,MLO_POD3                = P_I_V_MLO_POD3
            ,MLO_DEL                 = P_I_V_MLO_DEL
            ,HANDLING_INSTRUCTION_1  = P_I_V_HANDLING_INSTRUCTION_1
            ,HANDLING_INSTRUCTION_2  = P_I_V_HANDLING_INSTRUCTION_2
            ,HANDLING_INSTRUCTION_3  = P_I_V_HANDLING_INSTRUCTION_3
            ,CONTAINER_LOADING_REM_1 = P_I_V_CONTAINER_LOADING_REM_1
            ,CONTAINER_LOADING_REM_2 = P_I_V_CONTAINER_LOADING_REM_2
            ,SPECIAL_CARGO           = P_I_V_SPECIAL_CARGO
            ,IMDG_CLASS              = P_I_V_IMDG_CLASS
            ,UN_NUMBER               = P_I_V_UN_NUMBER
            ,UN_NUMBER_VARIANT       = P_I_V_UN_VAR
            ,PORT_CLASS              = P_I_V_PORT_CLASS
            ,PORT_CLASS_TYP          = P_I_V_PORT_CLASS_TYP
            ,FLASHPOINT_UNIT         = P_I_V_FLASHPOINT_UNIT
            ,FLASHPOINT              = REPLACE(P_I_V_FLASHPOINT, ',', '')
            ,FUMIGATION_ONLY         = P_I_V_FUMIGATION_ONLY
            ,RESIDUE_ONLY_FLAG       = P_I_V_RESIDUE_ONLY_FLAG
            ,OVERHEIGHT_CM           = REPLACE(P_I_V_OVERHEIGHT_CM, ',', '')
            ,OVERWIDTH_LEFT_CM       = REPLACE(P_I_V_OVERWIDTH_LEFT_CM,
                                               ',',
                                               '')
            ,OVERWIDTH_RIGHT_CM      = REPLACE(P_I_V_OVERWIDTH_RIGHT_CM,
                                               ',',
                                               '')
            ,OVERLENGTH_FRONT_CM     = REPLACE(P_I_V_OVERLENGTH_FRONT_CM,
                                               ',',
                                               '')
            ,OVERLENGTH_REAR_CM      = REPLACE(P_I_V_OVERLENGTH_REAR_CM,
                                               ',',
                                               '')
            ,REEFER_TEMPERATURE      = REPLACE(P_I_V_REEFER_TEMPERATURE,
                                               ',',
                                               '')
            ,REEFER_TMP_UNIT         = P_I_V_REEFER_TMP_UNIT
            ,HUMIDITY                = REPLACE(P_I_V_HUMIDITY, ',', '')
            ,VENTILATION             = REPLACE(P_I_V_VENTILATION, ',', '')
            ,DISCHARGE_STATUS        = P_I_V_DISCHARGE_STATUS
            ,RECORD_CHANGE_USER      = P_I_V_USER_ID
            ,OPN_STATUS              = P_I_V_OPN_STS
            ,VGM                     = REPLACE(P_I_V_VGM,',','')--*36 
       WHERE SESSION_ID = P_I_V_SESSION_ID
         AND SEQ_NO = P_I_V_SEQ_NO;

    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) || ':' ||
                     SUBSTR(SQLERRM, 1, 100);

      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));

  END PRE_EDL_SAVE_OVERLAND_TAB_DATA;

  PROCEDURE PRE_EDL_SAVE_RESTOW_TAB_DATA(P_I_V_SESSION_ID             IN VARCHAR2
                                        ,P_I_V_SEQ_NO                 IN OUT VARCHAR2
                                        ,P_I_V_PK_RESTOW_ID           IN VARCHAR2
                                        ,P_I_V_EQUIPMENT_NO           IN VARCHAR2
                                        ,P_I_V_MIDSTREAM              IN VARCHAR2
                                        ,P_I_V_LOAD_CONDITION         IN VARCHAR2
                                        ,P_I_V_RESTOW_STATUS          IN VARCHAR2
                                        ,P_I_V_STOWAGE_POSITION       IN VARCHAR2
                                        ,P_I_V_ACTIVITY_DATE_TIME     IN VARCHAR2
                                        ,P_I_V_PUBLIC_REMARK          IN VARCHAR2
                                        ,P_I_V_USER_ID                IN VARCHAR2
                                        ,P_I_V_DISCHARGE_LIST_ID      IN VARCHAR2
                                        ,P_I_V_OPN_STS                IN VARCHAR2
                                        ,P_I_V_CONTAINER_GROSS_WEIGHT IN VARCHAR2
                                        ,P_I_V_DAMAGED                IN VARCHAR2
                                        ,P_I_V_SEAL_NO                IN VARCHAR2
                                        ,P_O_V_ERROR                  OUT VARCHAR2) AS
    L_N_SEQ_NO NUMBER := 0;

  BEGIN
    -- Set the default error code.
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    IF (P_I_V_SEQ_NO IS NULL AND P_I_V_OPN_STS = PCE_EUT_COMMON.G_V_REC_ADD) THEN

      SELECT NVL(MAX(TO_NUMBER(SEQ_NO)), 0) + 1
        INTO L_N_SEQ_NO
        FROM TOS_RESTOW_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID;

      -- Insert new Record into TOS_RESTOW_TMP
      INSERT INTO TOS_RESTOW_TMP
        (SESSION_ID
        ,SEQ_NO
        ,PK_RESTOW_ID
        ,DN_EQUIPMENT_NO
        ,MIDSTREAM_HANDLING_CODE
        ,LOAD_CONDITION
        ,RESTOW_STATUS
        ,STOWAGE_POSITION
        ,ACTIVITY_DATE_TIME
        ,PUBLIC_REMARK
        ,RECORD_CHANGE_USER
        ,RECORD_CHANGE_DATE
        ,OPN_STATUS
        ,CONTAINER_GROSS_WEIGHT
        ,DAMAGED
        ,SEAL_NO
        ,FK_DISCHARGE_LIST_ID)
      VALUES
        (P_I_V_SESSION_ID
        ,L_N_SEQ_NO
        ,P_I_V_PK_RESTOW_ID
        ,P_I_V_EQUIPMENT_NO
        ,P_I_V_MIDSTREAM
        ,P_I_V_LOAD_CONDITION
        ,P_I_V_RESTOW_STATUS
        ,P_I_V_STOWAGE_POSITION
        ,P_I_V_ACTIVITY_DATE_TIME
        ,P_I_V_PUBLIC_REMARK
        ,P_I_V_USER_ID
        ,SYSDATE
        ,P_I_V_OPN_STS
        ,REPLACE(P_I_V_CONTAINER_GROSS_WEIGHT, ',', '')
        ,P_I_V_DAMAGED
        ,P_I_V_SEAL_NO
        ,P_I_V_DISCHARGE_LIST_ID);
      P_I_V_SEQ_NO := L_N_SEQ_NO;
    ELSE

      -- update record in restow temp table.
      UPDATE TOS_RESTOW_TMP
         SET DN_EQUIPMENT_NO         = P_I_V_EQUIPMENT_NO
            ,MIDSTREAM_HANDLING_CODE = P_I_V_MIDSTREAM
            ,LOAD_CONDITION          = P_I_V_LOAD_CONDITION
            ,RESTOW_STATUS           = P_I_V_RESTOW_STATUS
            ,STOWAGE_POSITION        = P_I_V_STOWAGE_POSITION
            ,ACTIVITY_DATE_TIME      = P_I_V_ACTIVITY_DATE_TIME
            ,PUBLIC_REMARK           = P_I_V_PUBLIC_REMARK
            ,RECORD_CHANGE_USER      = P_I_V_USER_ID
            ,OPN_STATUS              = P_I_V_OPN_STS
            ,CONTAINER_GROSS_WEIGHT  = REPLACE(P_I_V_CONTAINER_GROSS_WEIGHT,
                                               ',',
                                               '')
            ,DAMAGED                 = P_I_V_DAMAGED
            ,SEAL_NO                 = P_I_V_SEAL_NO
       WHERE SESSION_ID = P_I_V_SESSION_ID
         AND SEQ_NO = P_I_V_SEQ_NO;

    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) || ':' ||
                     SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));
  END PRE_EDL_SAVE_RESTOW_TAB_DATA;

  PROCEDURE PRE_EDL_RESTOW_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                     ,P_I_ROW_NUM             NUMBER
                                     ,P_I_V_DISCHARGE_LIST_ID VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                     ,P_I_V_RESTOW_ID         VARCHAR2
                                     ,P_I_V_DISCHARGE_ETD     VARCHAR2
                                     ,P_I_V_HDR_ETD_TM        VARCHAR2
                                     ,P_I_V_HDR_PORT          VARCHAR2
                                     ,P_I_V_SOC_COC           VARCHAR2
                                     ,P_O_V_ERR_CD            OUT VARCHAR2) AS
    L_V_ERRORS       VARCHAR2(2000);
    L_V_RECORD_COUNT NUMBER := 0;
    L_V_SHIPMENT_TYP TOS_RESTOW.DN_SHIPMENT_TYP%TYPE; -- *2

  BEGIN
    -- Set the error code to its default value (0000);
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_RESTOW_TMP
     WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
       AND DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       AND PK_RESTOW_ID != NVL(P_I_V_RESTOW_ID, ' ')
       AND SESSION_ID = P_I_V_SESSION_ID;

    -- When count is more then zero means record is already availabe, show error
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'EDL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_DL_BOOKED_DISCHARGE BD
          ,TOS_RESTOW_TMP          RS
     WHERE RS.FK_DISCHARGE_LIST_ID = BD.FK_DISCHARGE_LIST_ID
       AND RS.FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
       AND RS.DN_EQUIPMENT_NO = BD.DN_EQUIPMENT_NO
       AND RS.DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
          --AND    RS.RESTOW_STATUS        IN ('LR','LC','RA','RP')
       AND BD.DISCHARGE_STATUS != 'RB';

    -- Equipment# present in Booked tab with status other than 'ROB'
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'EDL.SE0123' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    -- Equipment# present in overlanded tab
    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_DL_OVERLANDED_CONTAINER OL
          ,TOS_RESTOW_TMP              RS
     WHERE OL.FK_DISCHARGE_LIST_ID = RS.FK_DISCHARGE_LIST_ID
       AND RS.FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
       AND OL.EQUIPMENT_NO = RS.DN_EQUIPMENT_NO
       AND RS.DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO;

    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'EDL.SE0125' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;
    /*
        *2 : Changes starts

    *
        Get the shipment type for the restow tab#
    */
    BEGIN
      L_V_SHIPMENT_TYP := NULL;
      SELECT DN_SHIPMENT_TYP
        INTO L_V_SHIPMENT_TYP
        FROM TOS_RESTOW
       WHERE PK_RESTOW_ID = P_I_V_RESTOW_ID;

    EXCEPTION
      WHEN OTHERS THEN
        L_V_SHIPMENT_TYP := NULL;
    END;
    /*
        *2 : Changes end
    */
    /* When OLD Equipment Type is COC then new equipment should be COC */
    IF (P_I_V_SOC_COC = 'C')
       AND (NVL(L_V_SHIPMENT_TYP, '*') <> 'UC') THEN
      -- *2
      IF P_I_V_EQUIPMENT_NO IS NOT NULL THEN
        /* Equipment Type should be COC */
        IF (PCE_EUT_COMMON.FN_CHECK_COC_FLAG(P_I_V_EQUIPMENT_NO,
                                             P_I_V_HDR_PORT,
                                             P_I_V_DISCHARGE_ETD,
                                             P_I_V_HDR_ETD_TM,
                                             P_O_V_ERR_CD) = FALSE) THEN
          P_O_V_ERR_CD := 'EDL.SE0132' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                          P_I_V_EQUIPMENT_NO ||
                          PCE_EUT_COMMON.G_V_ERR_CD_SEP;
          RETURN;
        END IF;
      END IF;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;
  END PRE_EDL_RESTOW_VALIDATION;

  PROCEDURE PRE_EDL_DEL_OVERLANDED_DATA(P_I_V_SESSION_ID IN VARCHAR2
                                       ,P_I_V_SEQ_NO     IN VARCHAR2
                                       ,P_I_V_OPN_STS    IN VARCHAR2
                                       ,P_I_V_USER_ID    IN VARCHAR2
                                       ,P_O_V_ERR_CD     OUT VARCHAR2) AS
  BEGIN

    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF (P_I_V_OPN_STS = PCE_EUT_COMMON.G_V_REC_ADD) THEN

      DELETE FROM TOS_DL_OVERLANDED_CONT_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
         AND SEQ_NO = P_I_V_SEQ_NO;

    ELSE

      UPDATE TOS_DL_OVERLANDED_CONT_TMP
         SET OPN_STATUS         = PCE_EUT_COMMON.G_V_REC_DEL
            ,RECORD_CHANGE_USER = P_I_V_USER_ID
       WHERE SESSION_ID = P_I_V_SESSION_ID
         AND SEQ_NO = P_I_V_SEQ_NO;

    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
  END PRE_EDL_DEL_OVERLANDED_DATA;

  PROCEDURE PRE_EDL_DEL_RESTOWED_TAB_DATA(P_I_V_SESSION_ID IN VARCHAR2
                                         ,P_I_V_SEQ_NO     IN VARCHAR2
                                         ,P_I_V_OPN_STS    IN VARCHAR2
                                         ,P_I_V_USER_ID    IN VARCHAR2
                                         ,P_O_V_ERR_CD     OUT VARCHAR2) AS
  BEGIN

    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF (P_I_V_OPN_STS = PCE_EUT_COMMON.G_V_REC_ADD) THEN
      DELETE FROM TOS_RESTOW_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
         AND SEQ_NO = P_I_V_SEQ_NO;

    ELSE
      UPDATE TOS_RESTOW_TMP
         SET OPN_STATUS         = PCE_EUT_COMMON.G_V_REC_DEL
            ,RECORD_CHANGE_USER = P_I_V_USER_ID
       WHERE SESSION_ID = P_I_V_SESSION_ID
         AND SEQ_NO = P_I_V_SEQ_NO;

    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
  END PRE_EDL_DEL_RESTOWED_TAB_DATA;

  -- Save data from temp to main.
  PROCEDURE PRE_EDL_SAVE_TEMP_TO_MAIN(P_I_V_SESSION_ID            IN VARCHAR2
                                     ,P_I_V_USER_ID               IN VARCHAR2
                                     ,P_I_V_DISCHARGE_LIST_STATUS IN VARCHAR2
                                     ,P_I_V_DISCHARGE_LIST_ID     IN VARCHAR2
                                     ,P_I_V_DISCHARGE_ETA         IN VARCHAR2
                                     ,P_I_V_VESSEL                IN VARCHAR2
                                     ,P_I_V_HDR_ETA_TM            IN VARCHAR2
                                     ,P_I_V_HDR_PORT              IN VARCHAR2
                                     ,P_I_V_DISCHARGE_ETD         IN VARCHAR2
                                     ,P_I_V_HDR_ETD_TM            IN VARCHAR2
                                     ,P_O_V_ERR_CD                OUT VARCHAR2) AS
    L_V_DATE      VARCHAR2(14);
    L_V_DL_STATUS VASAPPS.TOS_DL_DISCHARGE_LIST.DISCHARGE_LIST_STATUS%TYPE; -- *23
  BEGIN

    G_V_ORA_ERR_CD         := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    G_V_USER_ERR_CD        := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_ERR_CD           := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    G_V_DUPLICATE_STOW_ERR := PCE_EUT_COMMON.G_V_SUCCESS_CD; -- *12

    -- Get system date
    SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') INTO L_V_DATE FROM DUAL;

    /* *23 start * */

    /* * get updated list status * */
    L_V_DL_STATUS := P_I_V_DISCHARGE_LIST_STATUS;
    IF L_V_DL_STATUS IS NULL THEN
      /* get current list status from header table * */
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_GET_LIST_STATUS(P_I_V_DISCHARGE_LIST_ID,
                                                    LL_DL_FLAG,
                                                    L_V_DL_STATUS);
    END IF;



    /* *23 end * */

    /* * when list status is discharge complete or higher
    then only send mail * */
    IF ((L_V_DL_STATUS = DISCHARGE_COMPLETE) OR
       (L_V_DL_STATUS = READY_FOR_INVOICE) OR
       (L_V_DL_STATUS = WORK_COMPLETE)) THEN
      -- *23

      DBMS_OUTPUT.PUT_LINE('>>>call enotice<<<');
      PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_DL_LL_MNTN(LL_DL_FLAG,
                                                         P_I_V_SESSION_ID,
                                                         P_I_V_USER_ID,
                                                         L_V_DATE,
                                                         P_O_V_ERR_CD);

      DBMS_OUTPUT.PUT_LINE('>>>after enotice: <<<' || P_O_V_ERR_CD);
      IF ((P_O_V_ERR_CD IS NULL) OR
         (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
        RAISE L_EXCP_FINISH;
      END IF;

    END IF; -- *23



   -- Save Booked tab data.
    PRE_EDL_SAVE_BOOKED_TAB_MAIN(P_I_V_SESSION_ID,
                                 P_I_V_USER_ID,
                                 P_I_V_HDR_PORT,
                                 P_I_V_DISCHARGE_ETD,
                                 P_I_V_HDR_ETD_TM,
                                 P_I_V_VESSEL,
                                 L_V_DATE,
                                 P_I_V_DISCHARGE_ETA,
                                 P_I_V_HDR_ETA_TM,
                                 P_O_V_ERR_CD);


    IF ((P_O_V_ERR_CD IS NULL) OR
       (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
      RAISE L_EXCP_FINISH;
    END IF;


    -- Save overlanded tab data.
    PRE_EDL_SAVE_OVERLAND_TAB_MAIN(P_I_V_SESSION_ID,
                                   P_I_V_USER_ID,
                                   P_I_V_VESSEL,
                                   P_I_V_DISCHARGE_ETD,
                                   P_I_V_HDR_ETD_TM,
                                   P_I_V_HDR_PORT,
                                   L_V_DATE,
                                   P_I_V_DISCHARGE_ETA,
                                   P_I_V_HDR_ETA_TM,
                                   P_O_V_ERR_CD);

    IF ((P_O_V_ERR_CD IS NULL) OR
       (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
      RAISE L_EXCP_FINISH;
    END IF;

    -- Save resetowed tab data.
    PRE_EDL_SAVE_RESTOW_TAB_MAIN(P_I_V_SESSION_ID,
                                 P_I_V_USER_ID,
                                 P_I_V_VESSEL,
                                 P_I_V_DISCHARGE_ETA,
                                 P_I_V_HDR_ETA_TM,
                                 P_I_V_HDR_PORT,
                                 P_I_V_DISCHARGE_ETD,
                                 P_I_V_HDR_ETD_TM,
                                 L_V_DATE,
                                 P_O_V_ERR_CD);

    IF ((P_O_V_ERR_CD IS NULL) OR
       (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
      RAISE L_EXCP_FINISH;
    END IF;

    IF (P_I_V_DISCHARGE_LIST_STATUS IS NOT NULL) THEN

      PRE_EDL_SAVE_DL_STATUS(P_I_V_DISCHARGE_LIST_ID,
                             P_I_V_DISCHARGE_LIST_STATUS,
                             P_I_V_USER_ID,
                             L_V_DATE,
                             P_I_V_SESSION_ID -- *24
                            ,
                             P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        -- *31 start
        -- Raise missing EMS exception
        /*        IF P_O_V_ERR_CD = G_EXCP_EMS_CODE THEN
          RAISE L_EXCP_EMS;
        END IF;*/
        -- *31 end

        RAISE L_EXCP_FINISH;
      END IF;
    END IF;


    /* * use g_v_warning when you want to show error msg after all process completed * */
    IF ((G_V_WARNING IS NOT NULL) AND (G_V_WARNING = 'EDL.SE0112')) THEN
      /* set the warning code to display warning message on screen */
      /*'Service, Vessel and Voyage information not match with present load list'*/
      P_O_V_ERR_CD := 'EDL.SE0112';
    END IF;

    /*
        *12 start
    */
    IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      COMMIT;
      P_O_V_ERR_CD := G_V_DUPLICATE_STOW_ERR;
    END IF;

    IF P_O_V_ERR_CD = G_V_DUPLICATE_STOW_ERR
       AND G_V_DUPLICATE_STOW_ERR <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
      RAISE L_DUPLICATE_STOW_EXCPTION;
    END IF;
    /*
        *12 end
    */


  EXCEPTION
    /*
        *12 start
    */
    WHEN L_DUPLICATE_STOW_EXCPTION THEN
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
      /*
          *12 end
      */

    WHEN L_EXCP_FINISH THEN
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        --        p_o_v_err_cd := g_v_user_err_cd ;
        --        ROLLBACK ;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                                PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
      END IF;
      /*      -- *31 start
      WHEN L_EXCP_EMS THEN
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                                'Missing Discharge Activity in EMS.Please click Error Log button to see more detail.;');
        -- *31 end*/
    WHEN OTHERS THEN

      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);

      --      ROLLBACK;
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRE_EDL_SAVE_TEMP_TO_MAIN;
  /************************************ SAVE DATA FROM TEMP TO MAIN PROCEDURE END**********************************************/

  PROCEDURE PRE_EDL_SAVE_BOOKED_TAB_MAIN(P_I_V_SESSION_ID    IN VARCHAR2
                                        ,P_I_V_USER_ID       IN VARCHAR2
                                        ,P_I_V_PORT_CODE     IN VARCHAR2
                                        ,P_I_V_DISCHARGE_ETD IN VARCHAR2
                                        ,P_I_V_HDR_ETD_TM    IN VARCHAR2
                                        ,P_I_V_VESSEL        IN VARCHAR2
                                        ,P_I_V_DATE          IN VARCHAR2
                                        ,P_I_V_DISCHARGE_ETA IN VARCHAR2
                                        ,P_I_V_HDR_ETA_TM    IN VARCHAR2
                                        ,P_O_V_ERR_CD        OUT VARCHAR2) AS
    L_V_BOOKED_DISCHARGE_ID NUMBER := 0;
    L_V_LOCK_DATA           VARCHAR2(14);
    L_V_BOOKED_ROW_NUM      NUMBER := 1;
    L_V_ERRORS              VARCHAR2(2000);
    L_V_REC_COUNT           NUMBER := 0;
    L_V_REPLACEMENT_TYPE    VARCHAR2(1) := '3';
    L_V_PK_CONT_REPL_ID     NUMBER := 0;
    L_V_OLD_EQUIPMENT_NO    TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE;

    CURSOR L_CUR_BOOKED_DATA IS
      SELECT PK_BOOKED_DISCHARGE_ID
            ,FK_DISCHARGE_LIST_ID
            ,CONTAINER_SEQ_NO
            ,FK_BOOKING_NO
            ,FK_BKG_SIZE_TYPE_DTL
            ,FK_BKG_SUPPLIER
            ,FK_BKG_EQUIPM_DTL
            ,DN_EQUIPMENT_NO
            ,FK_BKG_VOYAGE_ROUTING_DTL
            ,DN_EQ_SIZE
            ,DN_EQ_TYPE
            ,DN_FULL_MT
            ,DN_BKG_TYP
            ,DN_SOC_COC
            ,DN_SHIPMENT_TERM
            ,DN_SHIPMENT_TYP
            ,LOCAL_STATUS
            ,LOCAL_TERMINAL_STATUS
            ,MIDSTREAM_HANDLING_CODE
            ,LOAD_CONDITION
            ,DN_LOADING_STATUS
            ,DISCHARGE_STATUS
            ,STOWAGE_POSITION
            ,ACTIVITY_DATE_TIME
            ,CONTAINER_GROSS_WEIGHT
            --*33BEGIN
            ,VGM --*36
            ,CATEGORY_CODE
            --*33 END
            ,DAMAGED
            ,VOID_SLOT
            ,FK_SLOT_OPERATOR
            ,FK_CONTAINER_OPERATOR
            ,OUT_SLOT_OPERATOR
            ,DN_SPECIAL_HNDL
            ,SEAL_NO
            ,DN_POL
            ,DN_POL_TERMINAL
            ,DN_NXT_POD1
            ,DN_NXT_POD2
            ,DN_NXT_POD3
            ,DN_FINAL_POD
            ,FINAL_DEST
            ,DN_NXT_SRV
            ,DN_NXT_VESSEL
            ,DN_NXT_VOYAGE
            ,DN_NXT_DIR
            ,MLO_VESSEL
            ,MLO_VOYAGE
            ,MLO_VESSEL_ETA
            ,MLO_POD1
            ,MLO_POD2
            ,MLO_POD3
            ,MLO_DEL
            ,SWAP_CONNECTION_ALLOWED
            ,FK_HANDLING_INSTRUCTION_1
            ,FK_HANDLING_INSTRUCTION_2
            ,FK_HANDLING_INSTRUCTION_3
            ,CONTAINER_LOADING_REM_1
            ,CONTAINER_LOADING_REM_2
            ,FK_SPECIAL_CARGO
            ,TIGHT_CONNECTION_FLAG1
            ,TIGHT_CONNECTION_FLAG2
            ,TIGHT_CONNECTION_FLAG3
            ,FK_IMDG
            ,FK_UNNO
            ,FK_UN_VAR
            ,FK_PORT_CLASS
            ,FK_PORT_CLASS_TYP
            ,FLASH_UNIT
            ,FLASH_POINT
            ,FUMIGATION_ONLY
            ,RESIDUE_ONLY_FLAG
            ,OVERHEIGHT_CM
            ,OVERWIDTH_LEFT_CM
            ,OVERWIDTH_RIGHT_CM
            ,OVERLENGTH_FRONT_CM
            ,OVERLENGTH_REAR_CM
            ,REEFER_TEMPERATURE
            ,REEFER_TMP_UNIT
            ,DN_HUMIDITY
            ,DN_VENTILATION
            ,PUBLIC_REMARK
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE
            ,SEQ_NO
            ,OPN_STATUS
            ,DECODE(OPN_STATUS, PCE_EUT_COMMON.G_V_REC_DEL, '1') ORD_SEQ
            ,CRANE_TYPE CRANE_TYPE -- *10

        FROM TOS_DL_BOOKED_DISCHARGE_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       ORDER BY ORD_SEQ
               ,SEQ_NO;

    CURSOR L_CUR_DUPLICATE_EQUIP_NO IS
      SELECT DN_EQUIPMENT_NO
        FROM TOS_DL_BOOKED_DISCHARGE_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       GROUP BY DN_EQUIPMENT_NO
      HAVING COUNT(DN_EQUIPMENT_NO) > 1
       ORDER BY COUNT(DN_EQUIPMENT_NO);

    /* *24 start * */
    /*
    CURSOR l_cur_duplicate_stowage_pos IS
        SELECT   STOWAGE_POSITION
        FROM     TOS_DL_BOOKED_DISCHARGE_TMP
        WHERE    SESSION_ID              = p_i_v_session_id
        GROUP BY STOWAGE_POSITION
        HAVING   COUNT(STOWAGE_POSITION) >1
        ORDER BY COUNT(STOWAGE_POSITION);
    */
    /* *24 end * */

    L_V_RESTOW_ROW_NUM   NUMBER := 1;
    L_V_FLAG             VARCHAR2(1);
    L_V_LOAD_LIST_ID     NUMBER;
    L_V_STOWAGE_POSITION VARCHAR2(7);
    L_V_DUPLICATE_ERROR  VARCHAR2(4000) := NULL;
    L_V_TERMINAL         TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE;
    L_V_EQUIPMENT_NO     TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE;

    L_V_BOOKING_NO             TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE;
    L_V_BKG_EQUIPM_DTL         TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL%TYPE;
    L_V_BKG_VOYAGE_ROUTING_DTL TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL%TYPE;
    L_V_OLD_DISCHARGE_STATUS   TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS%TYPE;
    L_V_DN_PORT                TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE;
    L_V_DN_TERMINAL            TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE;
    L_V_FK_PORT_SEQUENCE_NO    TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO%TYPE;

  BEGIN
    L_V_ERRORS   := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /*
        *1-Modification start by vikas, when cell location is changed and loading status is loaded then
        check if cell location is null then update cell location otherewise not, k'chatgamol, 06.03.2012
    */

    FOR L_CUR_DUPLICATE_EQUIP_NO_REC IN L_CUR_DUPLICATE_EQUIP_NO
    LOOP
      IF L_V_DUPLICATE_ERROR IS NULL THEN
        L_V_DUPLICATE_ERROR := L_CUR_DUPLICATE_EQUIP_NO_REC.DN_EQUIPMENT_NO;
      ELSE
        L_V_DUPLICATE_ERROR := L_V_DUPLICATE_ERROR || ', ' ||
                               L_CUR_DUPLICATE_EQUIP_NO_REC.DN_EQUIPMENT_NO;
      END IF;
    END LOOP;



    IF L_V_DUPLICATE_ERROR IS NOT NULL THEN
      P_O_V_ERR_CD := 'EDL.SE0167' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      L_V_DUPLICATE_ERROR || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
    END IF;



    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* *24 start * */
    /*
    FOR l_cur_dup_stowage_pos_rec IN l_cur_duplicate_stowage_pos
    LOOP
        IF l_v_duplicate_error IS NULL THEN
            l_v_duplicate_error := l_cur_dup_stowage_pos_rec.STOWAGE_POSITION;
        ELSE
            l_v_duplicate_error := l_v_duplicate_error || ', ' || l_cur_dup_stowage_pos_rec.STOWAGE_POSITION;
        END IF;
    END LOOP;

    IF l_v_duplicate_error IS NOT NULL THEN
        p_o_v_err_cd := 'EDL.SE0168' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_duplicate_error ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        G_v_duplicate_stow_err := p_o_v_err_cd;
    END IF;
    */

    /* * check duplicate cell location exists or not * */
    PRE_CHECK_DUP_CELL_LOCATION(P_I_V_SESSION_ID,
                                DISCHARGE_LIST,
                                BLANK, /* session would not be blank * */
                                P_O_V_ERR_CD);


    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      G_V_DUPLICATE_STOW_ERR := P_O_V_ERR_CD;
      RETURN;
    END IF;
    /* *24 end * */

    /*
            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;
    */
    FOR L_CUR_BOOKED_DATA_REC IN L_CUR_BOOKED_DATA
    LOOP
      IF (L_CUR_BOOKED_DATA_REC.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_UPD) THEN
        -- call validation function for booked tab.
        PRE_EDL_BOOKED_VALIDATION(P_I_V_SESSION_ID,
                                  L_V_RESTOW_ROW_NUM,
                                  L_CUR_BOOKED_DATA_REC.FK_DISCHARGE_LIST_ID,
                                  L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO,
                                  L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID,
                                  L_CUR_BOOKED_DATA_REC.CONTAINER_LOADING_REM_1,
                                  L_CUR_BOOKED_DATA_REC.CONTAINER_LOADING_REM_2,
                                  L_CUR_BOOKED_DATA_REC.FK_CONTAINER_OPERATOR,
                                  L_CUR_BOOKED_DATA_REC.FK_UNNO,
                                  P_I_V_PORT_CODE,
                                  L_CUR_BOOKED_DATA_REC.FK_UN_VAR,
                                  L_CUR_BOOKED_DATA_REC.FK_IMDG,
                                  L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_1,
                                  L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_2,
                                  L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_3,
                                  L_CUR_BOOKED_DATA_REC.FK_PORT_CLASS,
                                  L_CUR_BOOKED_DATA_REC.FK_PORT_CLASS_TYP,
                                  L_CUR_BOOKED_DATA_REC.FK_SLOT_OPERATOR,
                                  L_CUR_BOOKED_DATA_REC.OUT_SLOT_OPERATOR,
                                  L_CUR_BOOKED_DATA_REC.DN_SOC_COC,
                                  L_CUR_BOOKED_DATA_REC.DN_FULL_MT,
                                  P_I_V_DISCHARGE_ETD,
                                  P_I_V_HDR_ETD_TM,
                                  P_O_V_ERR_CD);



        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        /* Check if stowage possition is changed, then update the stowage position in load list table. */
        /* Booked tab stowage position changed */
        SELECT STOWAGE_POSITION
          INTO L_V_STOWAGE_POSITION
          FROM TOS_DL_BOOKED_DISCHARGE
         WHERE PK_BOOKED_DISCHARGE_ID =
               L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID;

        IF NVL(L_V_STOWAGE_POSITION, '~') !=
           NVL(L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION, '~') THEN
          /*  Get old equipment # */
          SELECT DN_EQUIPMENT_NO
                ,FK_BOOKING_NO
                ,FK_BKG_EQUIPM_DTL
                ,FK_BKG_VOYAGE_ROUTING_DTL
            INTO L_V_EQUIPMENT_NO
                ,L_V_BOOKING_NO
                ,L_V_BKG_EQUIPM_DTL
                ,L_V_BKG_VOYAGE_ROUTING_DTL
            FROM TOS_DL_BOOKED_DISCHARGE
           WHERE PK_BOOKED_DISCHARGE_ID =
                 L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID;

          /* Equipment no# is changed from null to any value. then update load list. */
          IF (((L_V_EQUIPMENT_NO IS NULL) AND
             (L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO IS NOT NULL)) OR
             (L_V_EQUIPMENT_NO <> L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO)) THEN
            /* Update load list */
            UPDATE TOS_LL_BOOKED_LOADING
               SET STOWAGE_POSITION = L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION
             WHERE FK_BOOKING_NO = L_V_BOOKING_NO
               AND FK_BKG_EQUIPM_DTL = L_V_BKG_EQUIPM_DTL
               AND FK_BKG_VOYAGE_ROUTING_DTL = L_V_BKG_VOYAGE_ROUTING_DTL
               AND LOADING_STATUS <> 'LO' -- vikas as, k'chatgamol 24.11.2011
                  -- AND CONTAINER_SEQ_NO  = l_cur_booked_data_rec.CONTAINER_SEQ_NO commented by vikas verma
               AND RECORD_STATUS = 'A';

          ELSE
            /* Normal Case Check equipment# in previous load list and update stowage
            possition in pervious load list. */

            /* get port sequence # for the current discharge list */
            SELECT FK_PORT_SEQUENCE_NO
              INTO L_V_FK_PORT_SEQUENCE_NO
              FROM TOS_DL_DISCHARGE_LIST
             WHERE PK_DISCHARGE_LIST_ID =
                   L_CUR_BOOKED_DATA_REC.FK_DISCHARGE_LIST_ID
               AND ROWNUM = 1;

            /*Start added by vikas as logic is changed, 22.11.2011*/
            /* Get the load list id */
            PRE_PREV_LOAD_LIST_ID(L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO,
                                  L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO,
                                  L_CUR_BOOKED_DATA_REC.DN_POL_TERMINAL,
                                  L_CUR_BOOKED_DATA_REC.DN_POL,
                                  L_V_LOAD_LIST_ID,
                                  L_V_FLAG,
                                  P_O_V_ERR_CD);


            /* End added by vikas, 22.11.2011*/

            /* Start Commented by vikas, 22.11.2011 *
            /* Get the load list id *
            PRE_EDL_PREV_LOAD_LIST_ID (
                  p_i_v_vessel
                , l_cur_booked_data_rec.DN_EQUIPMENT_NO
                , l_cur_booked_data_rec.FK_BOOKING_NO
                , p_i_v_discharge_eta
                , p_i_v_hdr_eta_tm
                , p_i_v_port_code
                , l_v_fk_port_sequence_no
                , l_v_load_list_id
                , l_v_flag
                , p_o_v_err_cd
            );

            * End commented by vikas, 22.11.2011*/
            IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
              RETURN;
            END IF;

            IF (L_V_FLAG = 'D') THEN
              /* GET LOCK ON TABLE*/
              BEGIN
                SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                  INTO L_V_LOCK_DATA
                  FROM TOS_LL_BOOKED_LOADING
                 WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID
                -- AND LOADING_STATUS <> 'LO'   -- vikas as, k'chatgamol 17.02.2012 -- *1
                   FOR UPDATE NOWAIT;

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
                  RETURN;
                WHEN OTHERS THEN
                  P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                                  PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                                  SUBSTR(SQLCODE, 1, 10) || ':' ||
                                  SUBSTR(SQLERRM, 1, 100);



                  RETURN;
              END;

              /* update record in booked load list table */

              UPDATE TOS_LL_BOOKED_LOADING
                 SET STOWAGE_POSITION   = L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION
                    ,RECORD_CHANGE_USER = P_I_V_USER_ID
                    ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                  'YYYYMMDDHH24MISS')
               WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID
                    -- AND LOADING_STATUS <> 'LO';     -- vikas as, k'chatgamol 24.11.2011 -- *1
                 AND (STOWAGE_POSITION IS NULL OR LOADING_STATUS <> 'LO'); -- *1

            END IF;

            IF (L_V_FLAG = 'R') THEN

              /* GET LOCK ON TABLE*/
              BEGIN
                SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                  INTO L_V_LOCK_DATA
                  FROM TOS_RESTOW
                 WHERE PK_RESTOW_ID = L_V_LOAD_LIST_ID
                   FOR UPDATE NOWAIT;

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;


                  RETURN;
                WHEN OTHERS THEN
                  P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                                  PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                                  SUBSTR(SQLCODE, 1, 10) || ':' ||
                                  SUBSTR(SQLERRM, 1, 100);


                  RETURN;
              END;

              /* update record in restow table */

              UPDATE TOS_RESTOW
                 SET STOWAGE_POSITION   = L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION
                    ,RECORD_CHANGE_USER = P_I_V_USER_ID
                    ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                  'YYYYMMDDHH24MISS')
               WHERE PK_RESTOW_ID = L_V_LOAD_LIST_ID;

            END IF;

          END IF;

        END IF;

        /* *27 start */
        /* get old container */
        SELECT NVL(DN_EQUIPMENT_NO, '~')
          INTO L_V_OLD_EQUIPMENT_NO
          FROM TOS_DL_BOOKED_DISCHARGE
         WHERE PK_BOOKED_DISCHARGE_ID =
               L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID;
        /* *27 end */

        IF (L_CUR_BOOKED_DATA_REC.DAMAGED = 'Y') THEN
          /* Check if equipment# is changed then update new equipment no# in container replacement table. */

          /* *27 start */
          /*
          SELECT NVL(DN_EQUIPMENT_NO,'~')
          INTO l_v_old_equipment_no
          FROM TOS_DL_BOOKED_DISCHARGE
          WHERE PK_BOOKED_DISCHARGE_ID = l_cur_booked_data_rec.PK_BOOKED_DISCHARGE_ID;
          */
          /* *27 start */
          -- AND DN_EQUIPMENT_NO =  l_cur_booked_data_rec.DN_EQUIPMENT_NO ;

          IF (L_V_OLD_EQUIPMENT_NO != L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO) THEN
            /* Eqipment# has changed. */

            /* Get pk for BKG_CONTAINER_REPLACEMENT table. */
            SELECT SE_CRZ01.NEXTVAL INTO L_V_PK_CONT_REPL_ID FROM DUAL;

            /* Get the terminal from discharge List */
            SELECT DN_TERMINAL
              INTO L_V_TERMINAL
              FROM TOS_DL_DISCHARGE_LIST
             WHERE PK_DISCHARGE_LIST_ID =
                   L_CUR_BOOKED_DATA_REC.FK_DISCHARGE_LIST_ID;

            INSERT INTO BKG_CONTAINER_REPLACEMENT
              (PK_CONTAINER_REPLACEMENT_ID
              ,DATE_OF_REPLACEMENT
              ,TERMINAL
              ,FK_BOOKING_NO
              ,OLD_EQUIPMENT_NO
              ,FK_BKG_SIZE_TYPE_DTL
              ,FK_BKG_SUPPLIER
              ,FK_BKG_EQUIPM_DTL
              ,NEW_EQUIPMENT_NO
              ,OLD_SEAL_NO
              ,NEW_SEAL_NO
              ,REPLACEMENT_TYPE
              ,REASON
              ,RECORD_STATUS
              ,RECORD_ADD_USER
              ,RECORD_ADD_DATE
              ,RECORD_CHANGE_USER
              ,RECORD_CHANGE_DATE)
            VALUES
              (L_V_PK_CONT_REPL_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
              ,L_V_TERMINAL
              ,L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO
              ,L_V_OLD_EQUIPMENT_NO
              ,L_CUR_BOOKED_DATA_REC.FK_BKG_SIZE_TYPE_DTL
              ,L_CUR_BOOKED_DATA_REC.FK_BKG_SUPPLIER
              ,L_CUR_BOOKED_DATA_REC.FK_BKG_EQUIPM_DTL
              ,L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO
              ,''
              ,''
              ,L_V_REPLACEMENT_TYPE
              ,'DAMAGED_CONTAINER'
              ,'A'
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS'));
          END IF;

        END IF;

        /* *27 start */
        IF (L_V_OLD_EQUIPMENT_NO != L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO) THEN
          /* Start Commented by vikas, to temporary suspend booking
          synchronization to reduce stream delay, as k'chatgamol 23.11.2011 */
          -- Call Synchronization with Booking
          PRE_EDL_SYNCH_BOOKING(L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID,
                                L_CUR_BOOKED_DATA_REC.FK_BKG_EQUIPM_DTL,
                                L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO,
                                L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO,
                                L_CUR_BOOKED_DATA_REC.OVERWIDTH_LEFT_CM,
                                L_CUR_BOOKED_DATA_REC.OVERHEIGHT_CM,
                                L_CUR_BOOKED_DATA_REC.OVERWIDTH_RIGHT_CM,
                                L_CUR_BOOKED_DATA_REC.OVERLENGTH_FRONT_CM,
                                L_CUR_BOOKED_DATA_REC.OVERLENGTH_REAR_CM,
                                L_CUR_BOOKED_DATA_REC.FK_IMDG,
                                L_CUR_BOOKED_DATA_REC.FK_UNNO,
                                L_CUR_BOOKED_DATA_REC.FK_UN_VAR,
                                L_CUR_BOOKED_DATA_REC.FLASH_POINT,
                                L_CUR_BOOKED_DATA_REC.FLASH_UNIT,
                                L_CUR_BOOKED_DATA_REC.REEFER_TMP_UNIT,
                                L_CUR_BOOKED_DATA_REC.REEFER_TEMPERATURE,
                                L_CUR_BOOKED_DATA_REC.DN_HUMIDITY,
                                L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT,
                                L_CUR_BOOKED_DATA_REC.DN_VENTILATION,
                                L_CUR_BOOKED_DATA_REC.CATEGORY_CODE,--*36
                                L_CUR_BOOKED_DATA_REC.VGM, --*36 
                                P_O_V_ERR_CD);




          IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
            RETURN;
          END IF;

          /* End Commented by vikas, to temporary suspend booking
          synchronization to reduce stream delay, as k'chatgamol 23.11.2011 */
        END IF;
        /* *27 end */

        /* Synchronize Next POD   */
        PRE_EDL_POD_UPDATE(L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID,
                           L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO,
                           LL_DL_FLAG,
                           L_CUR_BOOKED_DATA_REC.FK_BKG_VOYAGE_ROUTING_DTL,
                           L_CUR_BOOKED_DATA_REC.LOAD_CONDITION,
                           L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT,
                           --*33 BEGIN
                           L_CUR_BOOKED_DATA_REC.VGM, --*36
                           L_CUR_BOOKED_DATA_REC.CATEGORY_CODE,
                           --*33 END
                           L_CUR_BOOKED_DATA_REC.DAMAGED,
                           L_CUR_BOOKED_DATA_REC.FK_CONTAINER_OPERATOR,
                           L_CUR_BOOKED_DATA_REC.OUT_SLOT_OPERATOR,
                           L_CUR_BOOKED_DATA_REC.SEAL_NO,
                           L_CUR_BOOKED_DATA_REC.MLO_VESSEL,
                           L_CUR_BOOKED_DATA_REC.MLO_VOYAGE,
                           TO_DATE(L_CUR_BOOKED_DATA_REC.MLO_VESSEL_ETA,
                                   'dd/mm/yyyy hh24:mi'),
                           L_CUR_BOOKED_DATA_REC.MLO_POD1,
                           L_CUR_BOOKED_DATA_REC.MLO_POD2,
                           L_CUR_BOOKED_DATA_REC.MLO_POD3,
                           L_CUR_BOOKED_DATA_REC.MLO_DEL,
                           L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_1,
                           L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_2,
                           L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_3,
                           L_CUR_BOOKED_DATA_REC.CONTAINER_LOADING_REM_1,
                           L_CUR_BOOKED_DATA_REC.CONTAINER_LOADING_REM_2,
                           L_CUR_BOOKED_DATA_REC.TIGHT_CONNECTION_FLAG1,
                           L_CUR_BOOKED_DATA_REC.TIGHT_CONNECTION_FLAG2,
                           L_CUR_BOOKED_DATA_REC.TIGHT_CONNECTION_FLAG3,
                           L_CUR_BOOKED_DATA_REC.FUMIGATION_ONLY,
                           L_CUR_BOOKED_DATA_REC.RESIDUE_ONLY_FLAG,
                           L_CUR_BOOKED_DATA_REC.FK_BKG_SIZE_TYPE_DTL,
                           L_CUR_BOOKED_DATA_REC.FK_BKG_SUPPLIER,
                           L_CUR_BOOKED_DATA_REC.FK_BKG_EQUIPM_DTL,
                           P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        /* CR-41 changes start */
        /* update TOS_ONBOARD_LIST table */

        /* Get old discharge status value */
        SELECT DISCHARGE_STATUS
          INTO L_V_OLD_DISCHARGE_STATUS
          FROM TOS_DL_BOOKED_DISCHARGE
         WHERE PK_BOOKED_DISCHARGE_ID =
               L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID
           AND ROWNUM = 1;

        SELECT DN_PORT
              ,DN_TERMINAL
          INTO L_V_DN_PORT
              ,L_V_DN_TERMINAL
          FROM TOS_DL_DISCHARGE_LIST
         WHERE PK_DISCHARGE_LIST_ID =
               L_CUR_BOOKED_DATA_REC.FK_DISCHARGE_LIST_ID;

        /* update tos_onboard_list table for changed discharge status */
        PCE_ECM_SYNC_TOS_EZDL.PRE_TOS_UPDATE_DISCH_STS(L_CUR_BOOKED_DATA_REC.DISCHARGE_STATUS,
                                                       L_V_OLD_DISCHARGE_STATUS,
                                                       L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO,
                                                       L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO,
                                                       L_CUR_BOOKED_DATA_REC.FK_BKG_VOYAGE_ROUTING_DTL,
                                                       L_CUR_BOOKED_DATA_REC.FK_BKG_EQUIPM_DTL,
                                                       L_V_DN_PORT,
                                                       L_V_DN_TERMINAL,
                                                       L_CUR_BOOKED_DATA_REC.DN_POL -- added by by vikas 25.11.2011
                                                      ,
                                                       L_CUR_BOOKED_DATA_REC.DN_POL_TERMINAL,
                                                       P_O_V_ERR_CD);



        /* Check error status */
        IF (P_O_V_ERR_CD <> '0') THEN
          /* EZDL to TOS synchronization failed */

          -- p_o_v_err_cd := 'EDL.SE0185'; -- commented by vikas, do nothing when synch fails., 14.02.2012
          -- RETURN; -- commented by vikas, do nothing when synch fails., 14.02.2012
          P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD; -- added by vikas, do nothing when synch fails., 14.02.2012

        ELSE
          /* no error found then
          initialize p_o_v_err_cd with defaule value */
          P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        END IF;

        /* CR-41 changes end */

        /* Get lock on the table. */
        PCV_EDL_RECORD_LOCK(L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID,
                            TO_CHAR(L_CUR_BOOKED_DATA_REC.RECORD_CHANGE_DATE,
                                    'YYYYMMDDHH24MISS'),
                            'BOOKED',
                            P_O_V_ERR_CD);


        IF ((P_O_V_ERR_CD IS NULL) OR
           (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
          RETURN;
        END IF;
        --*30 start
        --Log port class change
        PCE_ELL_LLMAINTENANCE.PRE_LOG_PORTCLASS_CHANGE(L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID,
                                                       L_CUR_BOOKED_DATA_REC.FK_PORT_CLASS,
                                                       L_CUR_BOOKED_DATA_REC.FK_IMDG,
                                                       L_CUR_BOOKED_DATA_REC.FK_UNNO,
                                                       L_CUR_BOOKED_DATA_REC.FK_UN_VAR,
                                                       'D',
                                                       P_I_V_USER_ID);
        --*30 end
        UPDATE TOS_DL_BOOKED_DISCHARGE
           SET DN_EQUIPMENT_NO           = L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO
              ,LOCAL_TERMINAL_STATUS     = L_CUR_BOOKED_DATA_REC.LOCAL_TERMINAL_STATUS
              ,MIDSTREAM_HANDLING_CODE   = L_CUR_BOOKED_DATA_REC.MIDSTREAM_HANDLING_CODE
              ,LOAD_CONDITION            = L_CUR_BOOKED_DATA_REC.LOAD_CONDITION
              ,DISCHARGE_STATUS          = L_CUR_BOOKED_DATA_REC.DISCHARGE_STATUS
              ,STOWAGE_POSITION          = L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION
              ,ACTIVITY_DATE_TIME        = TO_DATE(L_CUR_BOOKED_DATA_REC.ACTIVITY_DATE_TIME,
                                                   'DD/MM/YYYY HH24:MI')
              ,CONTAINER_GROSS_WEIGHT    = L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT
              ,DAMAGED                   = L_CUR_BOOKED_DATA_REC.DAMAGED
              ,FK_CONTAINER_OPERATOR     = L_CUR_BOOKED_DATA_REC.FK_CONTAINER_OPERATOR
              ,OUT_SLOT_OPERATOR         = L_CUR_BOOKED_DATA_REC.OUT_SLOT_OPERATOR
              ,SEAL_NO                   = L_CUR_BOOKED_DATA_REC.SEAL_NO
              ,MLO_VESSEL                = L_CUR_BOOKED_DATA_REC.MLO_VESSEL
              ,MLO_VOYAGE                = L_CUR_BOOKED_DATA_REC.MLO_VOYAGE
              ,MLO_VESSEL_ETA            = TO_DATE(L_CUR_BOOKED_DATA_REC.MLO_VESSEL_ETA,
                                                   'DD/MM/YYYY HH24:MI')
              ,MLO_POD1                  = L_CUR_BOOKED_DATA_REC.MLO_POD1
              ,MLO_POD2                  = L_CUR_BOOKED_DATA_REC.MLO_POD2
              ,MLO_POD3                  = L_CUR_BOOKED_DATA_REC.MLO_POD3
              ,MLO_DEL                   = L_CUR_BOOKED_DATA_REC.MLO_DEL
              ,SWAP_CONNECTION_ALLOWED   = L_CUR_BOOKED_DATA_REC.SWAP_CONNECTION_ALLOWED
              ,FK_HANDLING_INSTRUCTION_1 = L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_1
              ,FK_HANDLING_INSTRUCTION_2 = L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_2
              ,FK_HANDLING_INSTRUCTION_3 = L_CUR_BOOKED_DATA_REC.FK_HANDLING_INSTRUCTION_3
              ,CONTAINER_LOADING_REM_1   = L_CUR_BOOKED_DATA_REC.CONTAINER_LOADING_REM_1
              ,CONTAINER_LOADING_REM_2   = L_CUR_BOOKED_DATA_REC.CONTAINER_LOADING_REM_2
              ,TIGHT_CONNECTION_FLAG1    = L_CUR_BOOKED_DATA_REC.TIGHT_CONNECTION_FLAG1
              ,TIGHT_CONNECTION_FLAG2    = L_CUR_BOOKED_DATA_REC.TIGHT_CONNECTION_FLAG2
              ,TIGHT_CONNECTION_FLAG3    = L_CUR_BOOKED_DATA_REC.TIGHT_CONNECTION_FLAG3
              ,FK_IMDG                   = L_CUR_BOOKED_DATA_REC.FK_IMDG
              ,FK_UNNO                   = L_CUR_BOOKED_DATA_REC.FK_UNNO
              ,FK_UN_VAR                 = L_CUR_BOOKED_DATA_REC.FK_UN_VAR
              ,FK_PORT_CLASS             = L_CUR_BOOKED_DATA_REC.FK_PORT_CLASS
              ,FK_PORT_CLASS_TYP         = L_CUR_BOOKED_DATA_REC.FK_PORT_CLASS_TYP
              ,FLASH_UNIT                = L_CUR_BOOKED_DATA_REC.FLASH_UNIT
              ,FLASH_POINT               = L_CUR_BOOKED_DATA_REC.FLASH_POINT
              ,FUMIGATION_ONLY           = L_CUR_BOOKED_DATA_REC.FUMIGATION_ONLY
              ,RESIDUE_ONLY_FLAG         = L_CUR_BOOKED_DATA_REC.RESIDUE_ONLY_FLAG
              ,OVERHEIGHT_CM             = L_CUR_BOOKED_DATA_REC.OVERHEIGHT_CM
              ,OVERWIDTH_LEFT_CM         = L_CUR_BOOKED_DATA_REC.OVERWIDTH_LEFT_CM
              ,OVERWIDTH_RIGHT_CM        = L_CUR_BOOKED_DATA_REC.OVERWIDTH_RIGHT_CM
              ,OVERLENGTH_FRONT_CM       = L_CUR_BOOKED_DATA_REC.OVERLENGTH_FRONT_CM
              ,OVERLENGTH_REAR_CM        = L_CUR_BOOKED_DATA_REC.OVERLENGTH_REAR_CM
              ,REEFER_TEMPERATURE        = L_CUR_BOOKED_DATA_REC.REEFER_TEMPERATURE
              ,REEFER_TMP_UNIT           = L_CUR_BOOKED_DATA_REC.REEFER_TMP_UNIT
              ,DN_HUMIDITY               = L_CUR_BOOKED_DATA_REC.DN_HUMIDITY
              ,DN_VENTILATION            = L_CUR_BOOKED_DATA_REC.DN_VENTILATION
              ,PUBLIC_REMARK             = L_CUR_BOOKED_DATA_REC.PUBLIC_REMARK
              ,CRANE_TYPE                = L_CUR_BOOKED_DATA_REC.CRANE_TYPE -- *10
              ,RECORD_CHANGE_USER        = P_I_V_USER_ID
              ,RECORD_CHANGE_DATE        = TO_DATE(P_I_V_DATE,
                                                   'YYYYMMDDHH24MISS')
              ,VGM                       = L_CUR_BOOKED_DATA_REC.VGM--*36                               
         WHERE PK_BOOKED_DISCHARGE_ID =
               L_CUR_BOOKED_DATA_REC.PK_BOOKED_DISCHARGE_ID;
      END IF;

      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(TO_NUMBER(L_CUR_BOOKED_DATA_REC.FK_DISCHARGE_LIST_ID),
                                                     LL_DL_FLAG,
                                                     P_O_V_ERR_CD);



      IF (P_O_V_ERR_CD = 0) THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      ELSE
        -- p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        /* Error in Sync Booking Status count */
        P_O_V_ERR_CD := 'EDL.SE0180';
        RETURN;
      END IF;

      -- Increment row number.
      IF (L_CUR_BOOKED_DATA_REC.OPN_STATUS IS NULL OR
         L_CUR_BOOKED_DATA_REC.OPN_STATUS <> PCE_EUT_COMMON.G_V_REC_DEL) THEN
        L_V_BOOKED_ROW_NUM := L_V_BOOKED_ROW_NUM + 1;
      END IF;
    END LOOP;


   IF (L_V_ERRORS IS NOT NULL AND
       (L_V_ERRORS != PCE_EUT_COMMON.G_V_SUCCESS_CD AND
       P_O_V_ERR_CD != PCE_EUT_COMMON.G_V_GE0005 AND
       P_O_V_ERR_CD != PCE_EUT_COMMON.G_V_GE0002)) THEN
      P_O_V_ERR_CD := L_V_ERRORS;
      RETURN;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;
  END PRE_EDL_SAVE_BOOKED_TAB_MAIN;

  /*Procedure for save overlanded data into main table. */
  PROCEDURE PRE_EDL_SAVE_OVERLAND_TAB_MAIN(P_I_V_SESSION_ID    IN VARCHAR2
                                          ,P_I_V_USER_ID       IN VARCHAR2
                                          ,P_I_V_VESSEL        IN VARCHAR2
                                          ,P_I_V_DISCHARGE_ETD IN VARCHAR2
                                          ,P_I_V_HDR_ETD_TM    IN VARCHAR2
                                          ,P_I_V_PORT_CODE     IN VARCHAR2
                                          ,P_I_V_DATE          IN VARCHAR2
                                          ,P_I_V_DISCHARGE_ETA IN VARCHAR2
                                          ,P_I_V_HDR_ETA_TM    IN VARCHAR2
                                          ,P_O_V_ERR_CD        OUT VARCHAR2) AS
    L_V_LOAD_CONDITION          VARCHAR2(1);
    L_V_LOCK_DATA               VARCHAR2(14);
    L_V_ERRORS                  VARCHAR2(2000);
    L_V_OVERLANDED_CONTAINER_ID NUMBER := 0;
    L_N_RESTOW_ID               NUMBER := 0;
    L_V_OVERLANDED_ROW_NUM      NUMBER := 1;
    L_V_FK_BKG_SIZE_TYPE_DTL    NUMBER;
    L_V_FK_BKG_SUPPLIER         NUMBER;
    L_V_FK_BKG_EQUIPM_DTL       NUMBER;
    L_V_LOAD_LIST_ID            NUMBER;
    L_V_FLAG                    VARCHAR2(1);
    EXP_ERROR_ON_SAVE EXCEPTION;
    L_V_RECORD_COUNT        NUMBER := 0;
    L_V_CONTAINER_OPERATOR  VARCHAR2(4);
    L_V_FK_PORT_SEQUENCE_NO TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO%TYPE;

    /* Cursor to save overlanded tab data */
    CURSOR L_CUR_OVERLANDED_DATA IS
      SELECT PK_OVERLANDED_CONTAINER_ID
            ,FK_DISCHARGE_LIST_ID
            ,BOOKING_NO
            ,EQUIPMENT_NO
            ,EQ_SIZE
            ,EQ_TYPE
            ,FULL_MT
            ,BKG_TYP
            ,FLAG_SOC_COC
            ,SHIPMENT_TERM
            ,SHIPMENT_TYP
            ,LOCAL_STATUS
            ,LOCAL_TERMINAL_STATUS
            ,MIDSTREAM_HANDLING_CODE
            ,LOAD_CONDITION
            ,STOWAGE_POSITION
            ,ACTIVITY_DATE_TIME
            ,CONTAINER_GROSS_WEIGHT
            ,DAMAGED
            ,VOID_SLOT
            ,SLOT_OPERATOR
            ,CONTAINER_OPERATOR
            ,OUT_SLOT_OPERATOR
            ,SPECIAL_HANDLING
            ,SEAL_NO
            ,POL
            ,POL_TERMINAL
            ,NXT_POD1
            ,NXT_POD2
            ,NXT_POD3
            ,FINAL_POD
            ,FINAL_DEST
            ,NXT_SRV
            ,NXT_VESSEL
            ,NXT_VOYAGE
            ,NXT_DIR
            ,MLO_VESSEL
            ,MLO_VOYAGE
            ,MLO_VESSEL_ETA
            ,MLO_POD1
            ,MLO_POD2
            ,MLO_POD3
            ,MLO_DEL
            ,HANDLING_INSTRUCTION_1
            ,HANDLING_INSTRUCTION_2
            ,HANDLING_INSTRUCTION_3
            ,CONTAINER_LOADING_REM_1
            ,CONTAINER_LOADING_REM_2
            ,SPECIAL_CARGO
            ,IMDG_CLASS
            ,UN_NUMBER
            ,UN_NUMBER_VARIANT
            ,PORT_CLASS
            ,PORT_CLASS_TYP
            ,FLASHPOINT_UNIT
            ,FLASHPOINT
            ,FUMIGATION_ONLY
            ,RESIDUE_ONLY_FLAG
            ,OVERHEIGHT_CM
            ,OVERWIDTH_LEFT_CM
            ,OVERWIDTH_RIGHT_CM
            ,OVERLENGTH_FRONT_CM
            ,OVERLENGTH_REAR_CM
            ,REEFER_TEMPERATURE
            ,REEFER_TMP_UNIT
            ,HUMIDITY
            ,VENTILATION
            ,DA_ERROR
            ,RECORD_STATUS
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE
            ,SEQ_NO
            ,OPN_STATUS
            ,DECODE(OPN_STATUS, PCE_EUT_COMMON.G_V_REC_DEL, '1') ORD_SEQ
            ,DISCHARGE_STATUS
            ,VGM --*36 
        FROM TOS_DL_OVERLANDED_CONT_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       ORDER BY ORD_SEQ
               ,SEQ_NO;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    FOR L_CUR_OVERLANDED_DATA_REC IN L_CUR_OVERLANDED_DATA
    LOOP
      IF (L_CUR_OVERLANDED_DATA_REC.FLAG_SOC_COC = 'C') THEN
        L_V_CONTAINER_OPERATOR := 'RCL';
      ELSE
        L_V_CONTAINER_OPERATOR := L_CUR_OVERLANDED_DATA_REC.CONTAINER_OPERATOR;
      END IF;

      IF (L_CUR_OVERLANDED_DATA_REC.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_ADD) THEN

        SELECT SE_OCZ01.NEXTVAL INTO L_V_OVERLANDED_CONTAINER_ID FROM DUAL;

        /* Call validation function for overlanded tab. */
        PRE_EDL_OVERLANDED_VALIDATION(P_I_V_SESSION_ID,
                                      L_V_OVERLANDED_ROW_NUM,
                                      L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID,
                                      L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO,
                                      L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID,
                                      L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_1,
                                      L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_2,
                                      L_V_CONTAINER_OPERATOR,
                                      L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_1,
                                      L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_2,
                                      L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_3,
                                      L_CUR_OVERLANDED_DATA_REC.UN_NUMBER,
                                      L_CUR_OVERLANDED_DATA_REC.UN_NUMBER_VARIANT,
                                      L_CUR_OVERLANDED_DATA_REC.IMDG_CLASS,
                                      P_I_V_PORT_CODE,
                                      L_CUR_OVERLANDED_DATA_REC.PORT_CLASS,
                                      L_CUR_OVERLANDED_DATA_REC.PORT_CLASS_TYP,
                                      L_CUR_OVERLANDED_DATA_REC.OUT_SLOT_OPERATOR,
                                      L_CUR_OVERLANDED_DATA_REC.SLOT_OPERATOR,
                                      L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TERM,
                                      L_CUR_OVERLANDED_DATA_REC.FLAG_SOC_COC,
                                      P_I_V_DISCHARGE_ETD,
                                      P_I_V_HDR_ETD_TM,
                                      L_CUR_OVERLANDED_DATA_REC.EQ_TYPE,
                                      L_CUR_OVERLANDED_DATA_REC.POL,
                                      L_CUR_OVERLANDED_DATA_REC.POL_TERMINAL,
                                      P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        IF (L_CUR_OVERLANDED_DATA_REC.DISCHARGE_STATUS IN ('DC', 'DR')) THEN
          -----------------
          SELECT COUNT(1)
            INTO L_V_RECORD_COUNT
            FROM TOS_RESTOW
           WHERE FK_DISCHARGE_LIST_ID =
                 L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID
             AND DN_EQUIPMENT_NO = L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO;

          -- When count is more then zero means record is already availabe, show error
          IF (L_V_RECORD_COUNT > 0) THEN
            P_O_V_ERR_CD := 'EDL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                            L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO ||
                            PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          /* get port sequence # for the current discharge list */
          SELECT FK_PORT_SEQUENCE_NO
            INTO L_V_FK_PORT_SEQUENCE_NO
            FROM TOS_DL_DISCHARGE_LIST
           WHERE PK_DISCHARGE_LIST_ID =
                 L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID
             AND ROWNUM = 1;

          /*Start added by vikas as logic is changed, 22.11.2011*/
          /* Get the load list id */
          PRE_PREV_LOAD_LIST_ID(L_CUR_OVERLANDED_DATA_REC.BOOKING_NO,
                                L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO,
                                L_CUR_OVERLANDED_DATA_REC.POL_TERMINAL,
                                L_CUR_OVERLANDED_DATA_REC.POL,
                                L_V_LOAD_LIST_ID,
                                L_V_FLAG,
                                P_O_V_ERR_CD);

          /* End added by vikas, 22.11.2011*/

          /* Start Commented by vikas, 22.11.2011 *
          /* Get the load list id *
          PRE_EDL_PREV_LOAD_LIST_ID (
                p_i_v_vessel
              , l_cur_overlanded_data_rec.EQUIPMENT_NO
              , l_cur_overlanded_data_rec.BOOKING_NO
              , p_i_v_discharge_eta
              , p_i_v_hdr_eta_tm
              , p_i_v_port_code
              , l_v_fk_port_sequence_no
              , l_v_load_list_id
              , l_v_flag
              , p_o_v_err_cd
          );
          * End commented by vikas, 22.11.2011*/

          IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
             P_O_V_ERR_CD <> 'EDL.SE0121') THEN
            RETURN;
          END IF;
          IF (P_O_V_ERR_CD = 'EDL.SE0121') THEN
            G_V_WARNING := 'EDL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                           L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO ||
                           PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

            SELECT FK_BKG_SIZE_TYPE_DTL
                  ,FK_BKG_SUPPLIER
                  ,FK_BKG_EQUIPM_DTL
                  ,LOAD_CONDITION
              INTO L_V_FK_BKG_SIZE_TYPE_DTL
                  ,L_V_FK_BKG_SUPPLIER
                  ,L_V_FK_BKG_EQUIPM_DTL
                  ,L_V_LOAD_CONDITION
              FROM TOS_LL_BOOKED_LOADING
             WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;

            SELECT SE_OCZ01.NEXTVAL INTO L_N_RESTOW_ID FROM DUAL;

            INSERT INTO TOS_RESTOW
              (PK_RESTOW_ID
              ,FK_DISCHARGE_LIST_ID
              ,FK_BOOKING_NO
              ,FK_BKG_SIZE_TYPE_DTL
              ,FK_BKG_SUPPLIER
              ,FK_BKG_EQUIPM_DTL
              ,DN_EQUIPMENT_NO
              ,DN_EQ_SIZE
              ,DN_EQ_TYPE
              ,DN_SOC_COC
              ,DN_SHIPMENT_TERM
              ,DN_SHIPMENT_TYP
              ,MIDSTREAM_HANDLING_CODE
              ,LOAD_CONDITION
              ,RESTOW_STATUS
              ,STOWAGE_POSITION
              ,CONTAINER_GROSS_WEIGHT
              ,DAMAGED
              ,VOID_SLOT
              ,FK_SLOT_OPERATOR
              ,FK_CONTAINER_OPERATOR
              ,DN_SPECIAL_HNDL
              ,SEAL_NO
              ,FK_SPECIAL_CARGO
              ,RECORD_STATUS
              ,RECORD_ADD_USER
              ,RECORD_ADD_DATE
              ,RECORD_CHANGE_USER
              ,RECORD_CHANGE_DATE)
            VALUES
              (L_N_RESTOW_ID
              ,L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID
              ,L_CUR_OVERLANDED_DATA_REC.BOOKING_NO
              ,L_V_FK_BKG_SIZE_TYPE_DTL
              ,L_V_FK_BKG_SUPPLIER
              ,L_V_FK_BKG_EQUIPM_DTL
              ,L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO
              ,L_CUR_OVERLANDED_DATA_REC.EQ_SIZE
              ,L_CUR_OVERLANDED_DATA_REC.EQ_TYPE
              ,L_CUR_OVERLANDED_DATA_REC.FLAG_SOC_COC
              ,L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TERM
              ,L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TYP
              ,L_CUR_OVERLANDED_DATA_REC.MIDSTREAM_HANDLING_CODE
              ,L_V_LOAD_CONDITION
              ,L_CUR_OVERLANDED_DATA_REC.DISCHARGE_STATUS
              ,L_CUR_OVERLANDED_DATA_REC.STOWAGE_POSITION
              ,L_CUR_OVERLANDED_DATA_REC.CONTAINER_GROSS_WEIGHT
              ,L_CUR_OVERLANDED_DATA_REC.DAMAGED
              ,L_CUR_OVERLANDED_DATA_REC.VOID_SLOT
              ,L_CUR_OVERLANDED_DATA_REC.SLOT_OPERATOR
              ,L_V_CONTAINER_OPERATOR
              ,L_CUR_OVERLANDED_DATA_REC.SPECIAL_HANDLING
              ,L_CUR_OVERLANDED_DATA_REC.SEAL_NO
              ,L_CUR_OVERLANDED_DATA_REC.SPECIAL_CARGO
              ,'A'
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS'));

          END IF;
          --------------------
        ELSE

          INSERT INTO TOS_DL_OVERLANDED_CONTAINER
            (PK_OVERLANDED_CONTAINER_ID
            ,FK_DISCHARGE_LIST_ID
            ,BOOKING_NO
            ,EQUIPMENT_NO
            ,EQ_SIZE
            ,EQ_TYPE
            ,FULL_MT
            ,BKG_TYP
            ,FLAG_SOC_COC
            ,SHIPMENT_TERM
            ,SHIPMENT_TYP
            ,LOCAL_STATUS
            ,LOCAL_TERMINAL_STATUS
            ,MIDSTREAM_HANDLING_CODE
            ,LOAD_CONDITION
            ,STOWAGE_POSITION
            ,ACTIVITY_DATE_TIME
            ,CONTAINER_GROSS_WEIGHT
            ,DAMAGED
            ,SLOT_OPERATOR
            ,CONTAINER_OPERATOR
            ,OUT_SLOT_OPERATOR
            ,SPECIAL_HANDLING
            ,SEAL_NO
            ,POL
            ,POL_TERMINAL
            ,NXT_SRV
            ,NXT_VESSEL
            ,NXT_VOYAGE
            ,NXT_DIR
            ,MLO_VESSEL
            ,MLO_VOYAGE
            ,MLO_VESSEL_ETA
            ,MLO_POD1
            ,MLO_POD2
            ,MLO_POD3
            ,MLO_DEL
            ,HANDLING_INSTRUCTION_1
            ,HANDLING_INSTRUCTION_2
            ,HANDLING_INSTRUCTION_3
            ,CONTAINER_LOADING_REM_1
            ,CONTAINER_LOADING_REM_2
            ,SPECIAL_CARGO
            ,IMDG_CLASS
            ,UN_NUMBER
            ,UN_NUMBER_VARIANT
            ,PORT_CLASS
            ,PORT_CLASS_TYP
            ,FLASHPOINT_UNIT
            ,FLASHPOINT
            ,FUMIGATION_ONLY
            ,RESIDUE_ONLY_FLAG
            ,OVERHEIGHT_CM
            ,OVERWIDTH_LEFT_CM
            ,OVERWIDTH_RIGHT_CM
            ,OVERLENGTH_FRONT_CM
            ,OVERLENGTH_REAR_CM
            ,REEFER_TEMPERATURE
            ,REEFER_TMP_UNIT
            ,HUMIDITY
            ,VENTILATION
            ,RECORD_STATUS
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE
            ,RECORD_ADD_USER
            ,RECORD_ADD_DATE
            ,VGM --*36 
            )
          VALUES
            (L_V_OVERLANDED_CONTAINER_ID
            ,L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID
            ,L_CUR_OVERLANDED_DATA_REC.BOOKING_NO
            ,L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO
            ,L_CUR_OVERLANDED_DATA_REC.EQ_SIZE
            ,L_CUR_OVERLANDED_DATA_REC.EQ_TYPE
            ,L_CUR_OVERLANDED_DATA_REC.FULL_MT
            ,L_CUR_OVERLANDED_DATA_REC.BKG_TYP
            ,L_CUR_OVERLANDED_DATA_REC.FLAG_SOC_COC
            ,L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TERM
            ,L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TYP
            ,L_CUR_OVERLANDED_DATA_REC.LOCAL_STATUS
            ,L_CUR_OVERLANDED_DATA_REC.LOCAL_TERMINAL_STATUS
            ,L_CUR_OVERLANDED_DATA_REC.MIDSTREAM_HANDLING_CODE
            ,L_CUR_OVERLANDED_DATA_REC.LOAD_CONDITION
            ,L_CUR_OVERLANDED_DATA_REC.STOWAGE_POSITION
            ,TO_DATE(L_CUR_OVERLANDED_DATA_REC.ACTIVITY_DATE_TIME,
                     'DD/MM/YYYY HH24:MI')
            ,L_CUR_OVERLANDED_DATA_REC.CONTAINER_GROSS_WEIGHT
            ,L_CUR_OVERLANDED_DATA_REC.DAMAGED
            ,L_CUR_OVERLANDED_DATA_REC.SLOT_OPERATOR
            ,L_V_CONTAINER_OPERATOR
            ,L_CUR_OVERLANDED_DATA_REC.OUT_SLOT_OPERATOR
            ,L_CUR_OVERLANDED_DATA_REC.SPECIAL_HANDLING
            ,L_CUR_OVERLANDED_DATA_REC.SEAL_NO
            ,L_CUR_OVERLANDED_DATA_REC.POL
            ,L_CUR_OVERLANDED_DATA_REC.POL_TERMINAL
            ,L_CUR_OVERLANDED_DATA_REC.NXT_SRV
            ,L_CUR_OVERLANDED_DATA_REC.NXT_VESSEL
            ,L_CUR_OVERLANDED_DATA_REC.NXT_VOYAGE
            ,L_CUR_OVERLANDED_DATA_REC.NXT_DIR
            ,L_CUR_OVERLANDED_DATA_REC.MLO_VESSEL
            ,L_CUR_OVERLANDED_DATA_REC.MLO_VOYAGE
            ,TO_DATE(L_CUR_OVERLANDED_DATA_REC.MLO_VESSEL_ETA,
                     'DD/MM/YYYY HH24:MI')
            ,L_CUR_OVERLANDED_DATA_REC.MLO_POD1
            ,L_CUR_OVERLANDED_DATA_REC.MLO_POD2
            ,L_CUR_OVERLANDED_DATA_REC.MLO_POD3
            ,L_CUR_OVERLANDED_DATA_REC.MLO_DEL
            ,L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_1
            ,L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_2
            ,L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_3
            ,L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_1
            ,L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_2
            ,L_CUR_OVERLANDED_DATA_REC.SPECIAL_CARGO
            ,L_CUR_OVERLANDED_DATA_REC.IMDG_CLASS
            ,L_CUR_OVERLANDED_DATA_REC.UN_NUMBER
            ,L_CUR_OVERLANDED_DATA_REC.UN_NUMBER_VARIANT
            ,L_CUR_OVERLANDED_DATA_REC.PORT_CLASS
            ,L_CUR_OVERLANDED_DATA_REC.PORT_CLASS_TYP
            ,L_CUR_OVERLANDED_DATA_REC.FLASHPOINT_UNIT
            ,L_CUR_OVERLANDED_DATA_REC.FLASHPOINT
            ,L_CUR_OVERLANDED_DATA_REC.FUMIGATION_ONLY
            ,L_CUR_OVERLANDED_DATA_REC.RESIDUE_ONLY_FLAG
            ,L_CUR_OVERLANDED_DATA_REC.OVERHEIGHT_CM
            ,L_CUR_OVERLANDED_DATA_REC.OVERWIDTH_LEFT_CM
            ,L_CUR_OVERLANDED_DATA_REC.OVERWIDTH_RIGHT_CM
            ,L_CUR_OVERLANDED_DATA_REC.OVERLENGTH_FRONT_CM
            ,L_CUR_OVERLANDED_DATA_REC.OVERLENGTH_REAR_CM
            ,L_CUR_OVERLANDED_DATA_REC.REEFER_TEMPERATURE
            ,L_CUR_OVERLANDED_DATA_REC.REEFER_TMP_UNIT
            ,L_CUR_OVERLANDED_DATA_REC.HUMIDITY
            ,L_CUR_OVERLANDED_DATA_REC.VENTILATION
            ,'A'
            ,P_I_V_USER_ID
            ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
            ,P_I_V_USER_ID
            ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
            ,L_CUR_OVERLANDED_DATA_REC.CONTAINER_GROSS_WEIGHT --*34 
            );
        END IF;

        /* Update Record  */
      ELSIF (L_CUR_OVERLANDED_DATA_REC.OPN_STATUS =
            PCE_EUT_COMMON.G_V_REC_UPD) THEN

        -- call validation function for overlanded tab.
        PRE_EDL_OVERLANDED_VALIDATION(P_I_V_SESSION_ID,
                                      L_V_OVERLANDED_ROW_NUM,
                                      L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID,
                                      L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO,
                                      L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID,
                                      L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_1,
                                      L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_2,
                                      L_V_CONTAINER_OPERATOR,
                                      L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_1,
                                      L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_2,
                                      L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_3,
                                      L_CUR_OVERLANDED_DATA_REC.UN_NUMBER,
                                      L_CUR_OVERLANDED_DATA_REC.UN_NUMBER_VARIANT,
                                      L_CUR_OVERLANDED_DATA_REC.IMDG_CLASS,
                                      P_I_V_PORT_CODE,
                                      L_CUR_OVERLANDED_DATA_REC.PORT_CLASS,
                                      L_CUR_OVERLANDED_DATA_REC.PORT_CLASS_TYP,
                                      L_CUR_OVERLANDED_DATA_REC.OUT_SLOT_OPERATOR,
                                      L_CUR_OVERLANDED_DATA_REC.SLOT_OPERATOR,
                                      L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TERM,
                                      L_CUR_OVERLANDED_DATA_REC.FLAG_SOC_COC,
                                      P_I_V_DISCHARGE_ETD,
                                      P_I_V_HDR_ETD_TM,
                                      L_CUR_OVERLANDED_DATA_REC.EQ_TYPE,
                                      L_CUR_OVERLANDED_DATA_REC.POL,
                                      L_CUR_OVERLANDED_DATA_REC.POL_TERMINAL,
                                      P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        PRE_TOS_REMOVE_ERROR(L_CUR_OVERLANDED_DATA_REC.DA_ERROR,
                             LL_DL_FLAG,
                             L_CUR_OVERLANDED_DATA_REC.EQ_SIZE,
                             L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_1,
                             L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_2,
                             L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO,
                             L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID,
                             L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID,
                             P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        IF (L_CUR_OVERLANDED_DATA_REC.DISCHARGE_STATUS IN ('DC', 'DR')) THEN

          SELECT COUNT(1)
            INTO L_V_RECORD_COUNT
            FROM TOS_RESTOW
           WHERE FK_DISCHARGE_LIST_ID =
                 L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID
             AND DN_EQUIPMENT_NO = L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO;

          -- When count is more then zero means record is already availabe, show error
          IF (L_V_RECORD_COUNT > 0) THEN
            P_O_V_ERR_CD := 'EDL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                            L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO ||
                            PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          /* Get Lock on table. */
          PCV_EDL_RECORD_LOCK(L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID,
                              TO_CHAR(L_CUR_OVERLANDED_DATA_REC.RECORD_CHANGE_DATE,
                                      'YYYYMMDDHH24MISS'),
                              'OVERLANDED',
                              P_O_V_ERR_CD);

          IF ((P_O_V_ERR_CD IS NULL) OR
             (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
            RETURN;
          END IF;

          /* Delete record from the overlanded table, and move to restow table.*/
          DELETE FROM TOS_DL_OVERLANDED_CONTAINER
           WHERE PK_OVERLANDED_CONTAINER_ID =
                 L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID;

          /*
              Start added by vikas, delete error message from tos_error_log table
              for this overlanded container, k'chatgamol, 15.12.2011
          */
          DELETE FROM TOS_ERROR_LOG
           WHERE FK_OVERLANDED_ID =
                 L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID;

          /*
              End added by vikas, 15.12.2011
          */

          /* get port sequence # for the current discharge list */
          SELECT FK_PORT_SEQUENCE_NO
            INTO L_V_FK_PORT_SEQUENCE_NO
            FROM TOS_DL_DISCHARGE_LIST
           WHERE PK_DISCHARGE_LIST_ID =
                 L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID
             AND ROWNUM = 1;

          /*Start added by vikas as logic is changed, 22.11.2011*/
          PRE_PREV_LOAD_LIST_ID(L_CUR_OVERLANDED_DATA_REC.BOOKING_NO,
                                L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO,
                                L_CUR_OVERLANDED_DATA_REC.POL_TERMINAL,
                                L_CUR_OVERLANDED_DATA_REC.POL,
                                L_V_LOAD_LIST_ID,
                                L_V_FLAG,
                                P_O_V_ERR_CD);

          /* End added by vikas, 22.11.2011*/

          /* Start Commented by vikas, 22.11.2011 *
          /* Get the load list id *
          PRE_EDL_PREV_LOAD_LIST_ID (
                p_i_v_vessel
              , l_cur_overlanded_data_rec.EQUIPMENT_NO
              , l_cur_overlanded_data_rec.BOOKING_NO
              , p_i_v_discharge_eta
              , p_i_v_hdr_eta_tm
              , p_i_v_port_code
              , l_v_fk_port_sequence_no
              , l_v_load_list_id
              , l_v_flag
              , p_o_v_err_cd
          );
          * End commented by vikas, 22.11.2011*/

          IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
             P_O_V_ERR_CD <> 'EDL.SE0121') THEN
            RETURN;
          END IF;
          IF (P_O_V_ERR_CD = 'EDL.SE0121') THEN
            G_V_WARNING := 'EDL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                           L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO ||
                           PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

            SELECT FK_BKG_SIZE_TYPE_DTL
                  ,FK_BKG_SUPPLIER
                  ,FK_BKG_EQUIPM_DTL
                  ,LOAD_CONDITION
              INTO L_V_FK_BKG_SIZE_TYPE_DTL
                  ,L_V_FK_BKG_SUPPLIER
                  ,L_V_FK_BKG_EQUIPM_DTL
                  ,L_V_LOAD_CONDITION
              FROM TOS_LL_BOOKED_LOADING
             WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;

            SELECT SE_OCZ01.NEXTVAL INTO L_N_RESTOW_ID FROM DUAL;

            INSERT INTO TOS_RESTOW
              (PK_RESTOW_ID
              ,FK_DISCHARGE_LIST_ID
              ,FK_BOOKING_NO
              ,FK_BKG_SIZE_TYPE_DTL
              ,FK_BKG_SUPPLIER
              ,FK_BKG_EQUIPM_DTL
              ,DN_EQUIPMENT_NO
              ,DN_EQ_SIZE
              ,DN_EQ_TYPE
              ,DN_SOC_COC
              ,DN_SHIPMENT_TERM
              ,DN_SHIPMENT_TYP
              ,MIDSTREAM_HANDLING_CODE
              ,LOAD_CONDITION
              ,RESTOW_STATUS
              ,STOWAGE_POSITION
              ,CONTAINER_GROSS_WEIGHT
              ,DAMAGED
              ,VOID_SLOT
              ,FK_SLOT_OPERATOR
              ,FK_CONTAINER_OPERATOR
              ,DN_SPECIAL_HNDL
              ,SEAL_NO
              ,FK_SPECIAL_CARGO
              ,RECORD_STATUS
              ,RECORD_ADD_USER
              ,RECORD_ADD_DATE
              ,RECORD_CHANGE_USER
              ,RECORD_CHANGE_DATE)
            VALUES
              (L_N_RESTOW_ID
              ,L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID
              ,L_CUR_OVERLANDED_DATA_REC.BOOKING_NO
              ,L_V_FK_BKG_SIZE_TYPE_DTL
              ,L_V_FK_BKG_SUPPLIER
              ,L_V_FK_BKG_EQUIPM_DTL
              ,L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO
              ,L_CUR_OVERLANDED_DATA_REC.EQ_SIZE
              ,L_CUR_OVERLANDED_DATA_REC.EQ_TYPE
              ,L_CUR_OVERLANDED_DATA_REC.FLAG_SOC_COC
              ,L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TERM
              ,L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TYP
              ,L_CUR_OVERLANDED_DATA_REC.MIDSTREAM_HANDLING_CODE
              ,L_V_LOAD_CONDITION
              ,L_CUR_OVERLANDED_DATA_REC.DISCHARGE_STATUS
              ,L_CUR_OVERLANDED_DATA_REC.STOWAGE_POSITION
              ,L_CUR_OVERLANDED_DATA_REC.CONTAINER_GROSS_WEIGHT
              ,L_CUR_OVERLANDED_DATA_REC.DAMAGED
              ,L_CUR_OVERLANDED_DATA_REC.VOID_SLOT
              ,L_CUR_OVERLANDED_DATA_REC.SLOT_OPERATOR
              ,L_V_CONTAINER_OPERATOR
              ,L_CUR_OVERLANDED_DATA_REC.SPECIAL_HANDLING
              ,L_CUR_OVERLANDED_DATA_REC.SEAL_NO
              ,L_CUR_OVERLANDED_DATA_REC.SPECIAL_CARGO
              ,'A'
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS'));

          END IF;

        ELSE

          /* Normal update case */
          PCV_EDL_RECORD_LOCK(L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID,
                              TO_CHAR(L_CUR_OVERLANDED_DATA_REC.RECORD_CHANGE_DATE,
                                      'YYYYMMDDHH24MISS'),
                              'OVERLANDED',
                              P_O_V_ERR_CD);

          IF ((P_O_V_ERR_CD IS NULL) OR
             (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
            RETURN;
          END IF;

          -- updating record in overlanded tab.e.
          UPDATE TOS_DL_OVERLANDED_CONTAINER
             SET BOOKING_NO              = L_CUR_OVERLANDED_DATA_REC.BOOKING_NO
                ,EQUIPMENT_NO            = L_CUR_OVERLANDED_DATA_REC.EQUIPMENT_NO
                ,EQ_SIZE                 = L_CUR_OVERLANDED_DATA_REC.EQ_SIZE
                ,EQ_TYPE                 = L_CUR_OVERLANDED_DATA_REC.EQ_TYPE
                ,FULL_MT                 = L_CUR_OVERLANDED_DATA_REC.FULL_MT
                ,BKG_TYP                 = L_CUR_OVERLANDED_DATA_REC.BKG_TYP
                ,FLAG_SOC_COC            = L_CUR_OVERLANDED_DATA_REC.FLAG_SOC_COC
                ,SHIPMENT_TERM           = L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TERM
                ,SHIPMENT_TYP            = L_CUR_OVERLANDED_DATA_REC.SHIPMENT_TYP
                ,LOCAL_STATUS            = L_CUR_OVERLANDED_DATA_REC.LOCAL_STATUS
                ,LOCAL_TERMINAL_STATUS   = L_CUR_OVERLANDED_DATA_REC.LOCAL_TERMINAL_STATUS
                ,MIDSTREAM_HANDLING_CODE = L_CUR_OVERLANDED_DATA_REC.MIDSTREAM_HANDLING_CODE
                ,LOAD_CONDITION          = L_CUR_OVERLANDED_DATA_REC.LOAD_CONDITION
                ,STOWAGE_POSITION        = L_CUR_OVERLANDED_DATA_REC.STOWAGE_POSITION
                ,ACTIVITY_DATE_TIME      = TO_DATE(L_CUR_OVERLANDED_DATA_REC.ACTIVITY_DATE_TIME,
                                                   'DD/MM/YYYY HH24:MI')
                ,CONTAINER_GROSS_WEIGHT  = L_CUR_OVERLANDED_DATA_REC.CONTAINER_GROSS_WEIGHT
                ,DAMAGED                 = L_CUR_OVERLANDED_DATA_REC.DAMAGED
                ,SLOT_OPERATOR           = L_CUR_OVERLANDED_DATA_REC.SLOT_OPERATOR
                ,CONTAINER_OPERATOR      = L_V_CONTAINER_OPERATOR
                ,OUT_SLOT_OPERATOR       = L_CUR_OVERLANDED_DATA_REC.OUT_SLOT_OPERATOR
                ,SPECIAL_HANDLING        = L_CUR_OVERLANDED_DATA_REC.SPECIAL_HANDLING
                ,SEAL_NO                 = L_CUR_OVERLANDED_DATA_REC.SEAL_NO
                ,POL                     = L_CUR_OVERLANDED_DATA_REC.POL
                ,POL_TERMINAL            = L_CUR_OVERLANDED_DATA_REC.POL_TERMINAL
                ,NXT_SRV                 = L_CUR_OVERLANDED_DATA_REC.NXT_SRV
                ,NXT_VESSEL              = L_CUR_OVERLANDED_DATA_REC.NXT_VESSEL
                ,NXT_VOYAGE              = L_CUR_OVERLANDED_DATA_REC.NXT_VOYAGE
                ,NXT_DIR                 = L_CUR_OVERLANDED_DATA_REC.NXT_DIR
                ,MLO_VESSEL              = L_CUR_OVERLANDED_DATA_REC.MLO_VESSEL
                ,MLO_VOYAGE              = L_CUR_OVERLANDED_DATA_REC.MLO_VOYAGE
                ,MLO_VESSEL_ETA          = TO_DATE(L_CUR_OVERLANDED_DATA_REC.MLO_VESSEL_ETA,
                                                   'DD/MM/YYYY HH24:MI')
                ,MLO_POD1                = L_CUR_OVERLANDED_DATA_REC.MLO_POD1
                ,MLO_POD2                = L_CUR_OVERLANDED_DATA_REC.MLO_POD2
                ,MLO_POD3                = L_CUR_OVERLANDED_DATA_REC.MLO_POD3
                ,MLO_DEL                 = L_CUR_OVERLANDED_DATA_REC.MLO_DEL
                ,HANDLING_INSTRUCTION_1  = L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_1
                ,HANDLING_INSTRUCTION_2  = L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_2
                ,HANDLING_INSTRUCTION_3  = L_CUR_OVERLANDED_DATA_REC.HANDLING_INSTRUCTION_3
                ,CONTAINER_LOADING_REM_1 = L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_1
                ,CONTAINER_LOADING_REM_2 = L_CUR_OVERLANDED_DATA_REC.CONTAINER_LOADING_REM_2
                ,SPECIAL_CARGO           = L_CUR_OVERLANDED_DATA_REC.SPECIAL_CARGO
                ,IMDG_CLASS              = L_CUR_OVERLANDED_DATA_REC.IMDG_CLASS
                ,UN_NUMBER               = L_CUR_OVERLANDED_DATA_REC.UN_NUMBER
                ,UN_NUMBER_VARIANT       = L_CUR_OVERLANDED_DATA_REC.UN_NUMBER_VARIANT
                ,PORT_CLASS              = L_CUR_OVERLANDED_DATA_REC.PORT_CLASS
                ,PORT_CLASS_TYP          = L_CUR_OVERLANDED_DATA_REC.PORT_CLASS_TYP
                ,FLASHPOINT_UNIT         = L_CUR_OVERLANDED_DATA_REC.FLASHPOINT_UNIT
                ,FLASHPOINT              = L_CUR_OVERLANDED_DATA_REC.FLASHPOINT
                ,FUMIGATION_ONLY         = L_CUR_OVERLANDED_DATA_REC.FUMIGATION_ONLY
                ,RESIDUE_ONLY_FLAG       = L_CUR_OVERLANDED_DATA_REC.RESIDUE_ONLY_FLAG
                ,OVERHEIGHT_CM           = L_CUR_OVERLANDED_DATA_REC.OVERHEIGHT_CM
                ,OVERWIDTH_LEFT_CM       = L_CUR_OVERLANDED_DATA_REC.OVERWIDTH_LEFT_CM
                ,OVERWIDTH_RIGHT_CM      = L_CUR_OVERLANDED_DATA_REC.OVERWIDTH_RIGHT_CM
                ,OVERLENGTH_FRONT_CM     = L_CUR_OVERLANDED_DATA_REC.OVERLENGTH_FRONT_CM
                ,OVERLENGTH_REAR_CM      = L_CUR_OVERLANDED_DATA_REC.OVERLENGTH_REAR_CM
                ,REEFER_TEMPERATURE      = L_CUR_OVERLANDED_DATA_REC.REEFER_TEMPERATURE
                ,REEFER_TMP_UNIT         = L_CUR_OVERLANDED_DATA_REC.REEFER_TMP_UNIT
                ,HUMIDITY                = L_CUR_OVERLANDED_DATA_REC.HUMIDITY
                ,VENTILATION             = L_CUR_OVERLANDED_DATA_REC.VENTILATION
                ,DA_ERROR                = 'N'
                ,RECORD_CHANGE_USER      = P_I_V_USER_ID
                ,RECORD_CHANGE_DATE      = TO_DATE(P_I_V_DATE,
                                                   'YYYYMMDDHH24MISS')
                ,VGM  = L_CUR_OVERLANDED_DATA_REC.VGM --*36                                                    
           WHERE PK_OVERLANDED_CONTAINER_ID =
                 L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID;
        END IF;

        /* DELETE  case */
      ELSIF (L_CUR_OVERLANDED_DATA_REC.OPN_STATUS =
            PCE_EUT_COMMON.G_V_REC_DEL) THEN

        PCV_EDL_RECORD_LOCK(L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID,
                            TO_CHAR(L_CUR_OVERLANDED_DATA_REC.RECORD_CHANGE_DATE,
                                    'YYYYMMDDHH24MISS'),
                            'OVERLANDED',
                            P_O_V_ERR_CD);

        IF ((P_O_V_ERR_CD IS NULL) OR
           (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
          RETURN;
        END IF;

        -- Delete the record from table.
        DELETE FROM TOS_DL_OVERLANDED_CONTAINER
         WHERE PK_OVERLANDED_CONTAINER_ID =
               L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID;

        /*
            Start added by vikas, delete error message from tos_error_log table
            for this overlanded container, k'chatgamol, 15.12.2011
        */
        DELETE FROM TOS_ERROR_LOG
         WHERE FK_OVERLANDED_ID =
               L_CUR_OVERLANDED_DATA_REC.PK_OVERLANDED_CONTAINER_ID;

        /*
            End added by vikas, 15.12.2011
        */

      END IF;

      /*  update status count in tos_dl_discharge_list table */
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(TO_NUMBER(L_CUR_OVERLANDED_DATA_REC.FK_DISCHARGE_LIST_ID),
                                                     LL_DL_FLAG,
                                                     P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD = 0) THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      ELSE
        -- p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        /* Error in Sync Booking Status count */
        P_O_V_ERR_CD := 'EDL.SE0180';
        RETURN;
      END IF;

      IF (L_CUR_OVERLANDED_DATA_REC.OPN_STATUS IS NULL OR
         L_CUR_OVERLANDED_DATA_REC.OPN_STATUS <>
         PCE_EUT_COMMON.G_V_REC_DEL) THEN
        L_V_OVERLANDED_ROW_NUM := L_V_OVERLANDED_ROW_NUM + 1;
      END IF;
    END LOOP;

    IF L_V_ERRORS IS NOT NULL
       AND (L_V_ERRORS != PCE_EUT_COMMON.G_V_SUCCESS_CD AND
       P_O_V_ERR_CD != PCE_EUT_COMMON.G_V_GE0005 AND
       P_O_V_ERR_CD != PCE_EUT_COMMON.G_V_GE0002) THEN
      P_O_V_ERR_CD := L_V_ERRORS;
      RETURN;
    END IF;

  EXCEPTION
    WHEN EXP_ERROR_ON_SAVE THEN
      RETURN;
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;
  END PRE_EDL_SAVE_OVERLAND_TAB_MAIN;

  -- for save rstows temp to main.
  PROCEDURE PRE_EDL_SAVE_RESTOW_TAB_MAIN(P_I_V_SESSION_ID    VARCHAR2
                                        ,P_I_V_USER_ID       VARCHAR2
                                        ,P_I_V_VESSEL        VARCHAR2
                                        ,P_I_V_DISCHARGE_ETA VARCHAR2
                                        ,P_I_V_HDR_ETA_TM    VARCHAR2
                                        ,P_I_V_HDR_PORT      VARCHAR2
                                        ,P_I_V_DISCHARGE_ETD VARCHAR2
                                        ,P_I_V_HDR_ETD_TM    VARCHAR2
                                        ,P_I_V_DATE          VARCHAR2
                                        ,P_O_V_ERR_CD        OUT VARCHAR2) AS

    L_V_LOCK_DATA      VARCHAR2(14);
    L_V_ERRORS         VARCHAR2(2000);
    L_V_RESTOW_ROW_NUM NUMBER := 1;
    L_N_RESTOW_ID      NUMBER := 0;
    EXP_ERROR_ON_SAVE EXCEPTION;
    L_V_FK_BOOKING_NO       VARCHAR2(17);
    L_V_FK_BKG_SIZE_TYP_DTL NUMBER;
    L_V_FK_BKG_SUPPLIER     NUMBER;
    L_V_FK_BKG_EQUIP_DTL    NUMBER;
    L_V_DN_EQ_SIZE          NUMBER;
    L_V_DN_EQ_TYPE          VARCHAR2(2);
    L_V_DN_SOC_COC          VARCHAR2(1);
    L_V_DN_SHIPMENT_TERM    VARCHAR2(4);
    L_V_DN_SHIPMENT_TYP     VARCHAR2(3);
    L_V_CONT_GROSS_WEIGHT   NUMBER;
    L_V_DAMAGED             VARCHAR2(1);
    L_V_VOID_SLOT           NUMBER;
    L_V_FK_SLOT_OPERATOR    VARCHAR2(4);
    L_V_FK_CONT_OPERATOR    VARCHAR2(4);
    L_V_DN_SPECIAL_HNDL     VARCHAR2(3);
    L_V_SEAL_NO             VARCHAR2(20);
    L_V_FK_SPECIAL_CARGO    VARCHAR2(3);
    L_V_LOAD_CONDITION      VARCHAR2(1);
    L_V_REC_COUNT           NUMBER;
    L_V_LOAD_LIST_ID        NUMBER;
    L_V_DISCHARGE_ID        NUMBER;
    L_V_STOWAGE_POSITION    VARCHAR2(7);
    L_V_FLAG                VARCHAR2(1);
    L_V_FK_PORT_SEQUENCE_NO TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO%TYPE;

    -- cursor to save restow tab data
    CURSOR L_CUR_RESTOWED_DATA IS
      SELECT PK_RESTOW_ID
            ,FK_LOAD_LIST_ID
            ,FK_DISCHARGE_LIST_ID
            ,FK_BOOKING_NO
            ,FK_BKG_SIZE_TYPE_DTL
            ,FK_BKG_SUPPLIER
            ,FK_BKG_EQUIPM_DTL
            ,DN_EQUIPMENT_NO
            ,DN_EQ_SIZE
            ,DN_EQ_TYPE
            ,DN_SOC_COC
            ,DN_SHIPMENT_TERM
            ,DN_SHIPMENT_TYP
            ,ACTIVITY_DATE_TIME
            ,MIDSTREAM_HANDLING_CODE
            ,LOAD_CONDITION
            ,RESTOW_STATUS
            ,STOWAGE_POSITION
            ,CONTAINER_GROSS_WEIGHT
            ,DAMAGED
            ,VOID_SLOT
            ,FK_SLOT_OPERATOR
            ,FK_CONTAINER_OPERATOR
            ,DN_SPECIAL_HNDL
            ,SEAL_NO
            ,FK_SPECIAL_CARGO
            ,PUBLIC_REMARK
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE
            ,SEQ_NO
            ,OPN_STATUS
            ,DECODE(OPN_STATUS, PCE_EUT_COMMON.G_V_REC_DEL, '1') ORD_SEQ
        FROM TOS_RESTOW_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       ORDER BY ORD_SEQ
               ,SEQ_NO;

  BEGIN
    L_V_ERRORS   := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    FOR L_CUR_RESTOWED_DATA_REC IN L_CUR_RESTOWED_DATA
    LOOP

      /* Save(add) selected record*/
      IF (L_CUR_RESTOWED_DATA_REC.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_ADD) THEN

        SELECT SE_RZZ01.NEXTVAL INTO L_N_RESTOW_ID FROM DUAL;

        -- call validation function for restowed tab.
        PRE_EDL_RESTOW_VALIDATION(P_I_V_SESSION_ID,
                                  L_V_RESTOW_ROW_NUM,
                                  L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID,
                                  L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                  L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID,
                                  P_I_V_DISCHARGE_ETD,
                                  P_I_V_HDR_ETD_TM,
                                  P_I_V_HDR_PORT,
                                  L_CUR_RESTOWED_DATA_REC.DN_SOC_COC,
                                  P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        /* get port sequence # for the current discharge list */
        SELECT FK_PORT_SEQUENCE_NO
          INTO L_V_FK_PORT_SEQUENCE_NO
          FROM TOS_DL_DISCHARGE_LIST
         WHERE PK_DISCHARGE_LIST_ID =
               L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID
           AND ROWNUM = 1;

        /* Get the load list id */
        PRE_EDL_PREV_LOAD_LIST_ID(P_I_V_VESSEL,
                                  L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                  L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                  P_I_V_DISCHARGE_ETA,
                                  P_I_V_HDR_ETA_TM,
                                  P_I_V_HDR_PORT,
                                  L_V_FK_PORT_SEQUENCE_NO,
                                  L_V_LOAD_LIST_ID,
                                  L_V_FLAG,
                                  P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
           P_O_V_ERR_CD <> 'EDL.SE0121') THEN
          RETURN;
        END IF;
        IF (P_O_V_ERR_CD = 'EDL.SE0121') THEN
          G_V_WARNING := 'EDL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                         L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO ||
                         PCE_EUT_COMMON.G_V_ERR_CD_SEP;
          RETURN;
        END IF;

        IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          BEGIN
            -- *20
            SELECT FK_BOOKING_NO
                  ,FK_BKG_SIZE_TYPE_DTL
                  ,FK_BKG_SUPPLIER
                  ,FK_BKG_EQUIPM_DTL
                  ,DN_EQ_SIZE
                  ,DN_EQ_TYPE
                  ,DN_SOC_COC
                  ,DN_SHIPMENT_TERM
                  ,DN_SHIPMENT_TYP
                  ,CONTAINER_GROSS_WEIGHT
                  ,DAMAGED
                  ,VOID_SLOT
                  ,FK_SLOT_OPERATOR
                  ,FK_CONTAINER_OPERATOR
                  ,DN_SPECIAL_HNDL
                  ,SEAL_NO
                  ,FK_SPECIAL_CARGO
                  ,LOAD_CONDITION
                  ,STOWAGE_POSITION
              INTO L_V_FK_BOOKING_NO
                  ,L_V_FK_BKG_SIZE_TYP_DTL
                  ,L_V_FK_BKG_SUPPLIER
                  ,L_V_FK_BKG_EQUIP_DTL
                  ,L_V_DN_EQ_SIZE
                  ,L_V_DN_EQ_TYPE
                  ,L_V_DN_SOC_COC
                  ,L_V_DN_SHIPMENT_TERM
                  ,L_V_DN_SHIPMENT_TYP
                  ,L_V_CONT_GROSS_WEIGHT
                  ,L_V_DAMAGED
                  ,L_V_VOID_SLOT
                  ,L_V_FK_SLOT_OPERATOR
                  ,L_V_FK_CONT_OPERATOR
                  ,L_V_DN_SPECIAL_HNDL
                  ,L_V_SEAL_NO
                  ,L_V_FK_SPECIAL_CARGO
                  ,L_V_LOAD_CONDITION
                  ,L_V_STOWAGE_POSITION
              FROM TOS_LL_BOOKED_LOADING
             WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;

            /* *20 start * */
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              /* * Service, Vessel and Voyage information not match with
              present load list for equipment# * */
              G_V_WARNING := 'EDL.SE0112' --*28
                             || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                             L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO ||
                             PCE_EUT_COMMON.G_V_ERR_CD_SEP;
              RETURN;
          END;
          /* *20 end * */

          IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS = 'XX' AND
             L_V_STOWAGE_POSITION !=
             L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION) THEN

            BEGIN
              SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                INTO L_V_LOCK_DATA
                FROM TOS_LL_BOOKED_LOADING
               WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID
              -- AND LOADING_STATUS <> 'LO'     -- vikas as, k'chatgamol 17.02.2012 -- *1
                 FOR UPDATE NOWAIT;

            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
                RETURN;
              WHEN OTHERS THEN
                P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                                PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                                SUBSTR(SQLCODE, 1, 10) || ':' ||
                                SUBSTR(SQLERRM, 1, 100);
                RETURN;
            END;

            /* update record in booked load list table */

            UPDATE TOS_LL_BOOKED_LOADING
               SET STOWAGE_POSITION   = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                  ,RECORD_CHANGE_USER = P_I_V_USER_ID
                  ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                'YYYYMMDDHH24MISS')
             WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID
                  -- AND LOADING_STATUS <> 'LO';     -- vikas as, k'chatgamol 24.11.2011 -- *1
               AND (STOWAGE_POSITION IS NULL OR LOADING_STATUS <> 'LO'); -- *1

          END IF;

          IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS IN
             ('LR', 'RA', 'LC', 'RP', 'XX')) THEN

            /* get port sequence # for the current discharge list */
            SELECT FK_PORT_SEQUENCE_NO
              INTO L_V_FK_PORT_SEQUENCE_NO
              FROM TOS_DL_DISCHARGE_LIST
             WHERE PK_DISCHARGE_LIST_ID =
                   L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID
               AND ROWNUM = 1;

            -- *28  Comemnted and add new procedure- start
            /*PRE_EDL_NEXT_DISCHARGE_LIST_ID (
                  p_i_v_vessel
                , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                , l_cur_restowed_data_rec.FK_BOOKING_NO
                , p_i_v_discharge_etd
                , p_i_v_hdr_etd_tm
                , p_i_v_hdr_port
                , l_v_fk_port_sequence_no
                , l_v_discharge_id
                , l_v_flag
                , p_o_v_err_cd
            );*/
            PCE_ELL_LLMAINTENANCE.PRE_FIND_DISCHARGE_LIST(L_V_FK_BOOKING_NO,
                                                          P_I_V_VESSEL,
                                                          L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                                          L_V_FLAG,
                                                          L_V_DISCHARGE_ID,
                                                          P_O_V_ERR_CD);
            --*28 end

            IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
              RETURN;
            END IF;

            IF (L_V_FLAG = 'D') THEN

              BEGIN

                SELECT STOWAGE_POSITION
                  INTO L_V_STOWAGE_POSITION
                  FROM TOS_DL_BOOKED_DISCHARGE
                 WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                   FOR UPDATE NOWAIT;

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
                  RETURN;
                WHEN OTHERS THEN
                  P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                                  PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                                  SUBSTR(SQLCODE, 1, 10) || ':' ||
                                  SUBSTR(SQLERRM, 1, 100);
                  RETURN;
              END;

              IF (L_V_STOWAGE_POSITION !=
                 L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION) THEN

                /* update record in booked load list table */
                UPDATE TOS_DL_BOOKED_DISCHARGE
                   SET STOWAGE_POSITION   = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                      ,RECORD_CHANGE_USER = P_I_V_USER_ID
                      ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                    'YYYYMMDDHH24MISS')
                 WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID;
              END IF;
            END IF;

          END IF;

        END IF;

        -- Move data from temp table to main table.
        INSERT INTO TOS_RESTOW
          (PK_RESTOW_ID
          ,FK_DISCHARGE_LIST_ID
          ,FK_BOOKING_NO
          ,FK_BKG_SIZE_TYPE_DTL
          ,FK_BKG_SUPPLIER
          ,FK_BKG_EQUIPM_DTL
          ,DN_EQUIPMENT_NO
          ,DN_EQ_SIZE
          ,DN_EQ_TYPE
          ,DN_SOC_COC
          ,DN_SHIPMENT_TERM
          ,DN_SHIPMENT_TYP
          ,MIDSTREAM_HANDLING_CODE
          ,RESTOW_STATUS
          ,STOWAGE_POSITION
          ,ACTIVITY_DATE_TIME
          ,CONTAINER_GROSS_WEIGHT
          ,DAMAGED
          ,VOID_SLOT
          ,FK_SLOT_OPERATOR
          ,FK_CONTAINER_OPERATOR
          ,DN_SPECIAL_HNDL
          ,SEAL_NO
          ,FK_SPECIAL_CARGO
          ,LOAD_CONDITION
          ,PUBLIC_REMARK
          ,RECORD_STATUS
          ,RECORD_ADD_USER
          ,RECORD_ADD_DATE
          ,RECORD_CHANGE_USER
          ,RECORD_CHANGE_DATE

           )
        VALUES
          (L_N_RESTOW_ID
          ,L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID
          ,L_V_FK_BOOKING_NO
          ,L_V_FK_BKG_SIZE_TYP_DTL
          ,L_V_FK_BKG_SUPPLIER
          ,L_V_FK_BKG_EQUIP_DTL
          ,L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO
          ,L_V_DN_EQ_SIZE
          ,L_V_DN_EQ_TYPE
          ,L_V_DN_SOC_COC
          ,L_V_DN_SHIPMENT_TERM
          ,L_V_DN_SHIPMENT_TYP
          ,L_CUR_RESTOWED_DATA_REC.MIDSTREAM_HANDLING_CODE
          ,L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS
          ,L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
          ,TO_DATE(L_CUR_RESTOWED_DATA_REC.ACTIVITY_DATE_TIME,
                   'DD/MM/YYYY HH24:MI')
          ,L_CUR_RESTOWED_DATA_REC.CONTAINER_GROSS_WEIGHT
          ,L_CUR_RESTOWED_DATA_REC.DAMAGED
          ,L_V_VOID_SLOT
          ,L_V_FK_SLOT_OPERATOR
          ,L_V_FK_CONT_OPERATOR
          ,L_V_DN_SPECIAL_HNDL
          ,L_CUR_RESTOWED_DATA_REC.SEAL_NO
          ,L_V_FK_SPECIAL_CARGO
          ,L_V_LOAD_CONDITION
          ,L_CUR_RESTOWED_DATA_REC.PUBLIC_REMARK
          ,'A'
          ,P_I_V_USER_ID
          ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
          ,P_I_V_USER_ID
          ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS'));

        /* Update the selected record*/
      ELSIF (L_CUR_RESTOWED_DATA_REC.OPN_STATUS =
            PCE_EUT_COMMON.G_V_REC_UPD) THEN

        -- call validation function for restowed tab.
        PRE_EDL_RESTOW_VALIDATION(P_I_V_SESSION_ID,
                                  L_V_RESTOW_ROW_NUM,
                                  L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID,
                                  L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                  L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID,
                                  P_I_V_DISCHARGE_ETD,
                                  P_I_V_HDR_ETD_TM,
                                  P_I_V_HDR_PORT,
                                  L_CUR_RESTOWED_DATA_REC.DN_SOC_COC,
                                  P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        /*
            check if equipment number is changed or not
            if equipment number is change then get data
            from master table.
        */

        SELECT COUNT(1)
          INTO L_V_REC_COUNT
          FROM TOS_RESTOW
         WHERE PK_RESTOW_ID = L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID
           AND DN_EQUIPMENT_NO = L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO;

        /* No data found equipment no is changed */
        IF (L_V_REC_COUNT < 1) THEN
          ------------
          /* get port sequence # for the current discharge list */
          SELECT FK_PORT_SEQUENCE_NO
            INTO L_V_FK_PORT_SEQUENCE_NO
            FROM TOS_DL_DISCHARGE_LIST
           WHERE PK_DISCHARGE_LIST_ID =
                 L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID
             AND ROWNUM = 1;

          PRE_EDL_PREV_LOAD_LIST_ID(P_I_V_VESSEL,
                                    L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                    L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                    P_I_V_DISCHARGE_ETA,
                                    P_I_V_HDR_ETA_TM,
                                    P_I_V_HDR_PORT,
                                    L_V_FK_PORT_SEQUENCE_NO,
                                    L_V_LOAD_LIST_ID,
                                    L_V_FLAG,
                                    P_O_V_ERR_CD);

          IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
             P_O_V_ERR_CD <> 'EDL.SE0121') THEN
            RETURN;
          END IF;
          IF (P_O_V_ERR_CD = 'EDL.SE0121') THEN
            G_V_WARNING := 'EDL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                           L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO ||
                           PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

            SELECT DN_EQ_SIZE
                  ,DN_EQ_TYPE
                  ,DN_SOC_COC
                  ,DN_SHIPMENT_TERM
                  ,DN_SHIPMENT_TYP
                  ,CONTAINER_GROSS_WEIGHT
                  ,DAMAGED
                  ,VOID_SLOT
                  ,FK_SLOT_OPERATOR
                  ,FK_CONTAINER_OPERATOR
                  ,DN_SPECIAL_HNDL
                  ,SEAL_NO
                  ,FK_SPECIAL_CARGO
                  ,LOAD_CONDITION
                  ,STOWAGE_POSITION
              INTO L_V_DN_EQ_SIZE
                  ,L_V_DN_EQ_TYPE
                  ,L_V_DN_SOC_COC
                  ,L_V_DN_SHIPMENT_TERM
                  ,L_V_DN_SHIPMENT_TYP
                  ,L_V_CONT_GROSS_WEIGHT
                  ,L_V_DAMAGED
                  ,L_V_VOID_SLOT
                  ,L_V_FK_SLOT_OPERATOR
                  ,L_V_FK_CONT_OPERATOR
                  ,L_V_DN_SPECIAL_HNDL
                  ,L_V_SEAL_NO
                  ,L_V_FK_SPECIAL_CARGO
                  ,L_V_LOAD_CONDITION
                  ,L_V_STOWAGE_POSITION
              FROM TOS_LL_BOOKED_LOADING
             WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;

            IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS = 'XX' AND
               L_V_STOWAGE_POSITION !=
               L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION) THEN

              BEGIN
                SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                  INTO L_V_LOCK_DATA
                  FROM TOS_LL_BOOKED_LOADING
                 WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID
                   FOR UPDATE NOWAIT;

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
                  RETURN;
                WHEN OTHERS THEN
                  P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                                  PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                                  SUBSTR(SQLCODE, 1, 10) || ':' ||
                                  SUBSTR(SQLERRM, 1, 100);
                  RETURN;
              END;

              /* update record in booked load list table */

              UPDATE TOS_LL_BOOKED_LOADING
                 SET STOWAGE_POSITION   = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                    ,RECORD_CHANGE_USER = P_I_V_USER_ID
                    ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                  'YYYYMMDDHH24MISS')
               WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID
                 AND LOADING_STATUS <> 'LO'; -- vikas as, k'chatgamol 24.11.2011
            END IF;

            IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS IN
               ('LR', 'RA', 'LC', 'RP', 'XX')) THEN
              /* get port sequence # for the current discharge list */
              SELECT FK_PORT_SEQUENCE_NO
                INTO L_V_FK_PORT_SEQUENCE_NO
                FROM TOS_DL_DISCHARGE_LIST
               WHERE PK_DISCHARGE_LIST_ID =
                     L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID
                 AND ROWNUM = 1;

              -- *28  Comemnted and add new procedure- start
              /*PRE_EDL_NEXT_DISCHARGE_LIST_ID (
                    p_i_v_vessel
                  , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                  , l_cur_restowed_data_rec.FK_BOOKING_NO
                  , p_i_v_discharge_etd
                  , p_i_v_hdr_etd_tm
                  , p_i_v_hdr_port
                  , l_v_fk_port_sequence_no
                  , l_v_discharge_id
                  , l_v_flag
                  , p_o_v_err_cd
              );*/
              PCE_ELL_LLMAINTENANCE.PRE_FIND_DISCHARGE_LIST(L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                                            P_I_V_VESSEL,
                                                            L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                                            L_V_FLAG,
                                                            L_V_DISCHARGE_ID,
                                                            P_O_V_ERR_CD);
              -- *28 end

              IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
              END IF;

              IF (L_V_FLAG = 'D') THEN

                BEGIN

                  SELECT STOWAGE_POSITION
                    INTO L_V_STOWAGE_POSITION
                    FROM TOS_DL_BOOKED_DISCHARGE
                   WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                     FOR UPDATE NOWAIT;

                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
                    RETURN;
                  WHEN OTHERS THEN
                    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                                    PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                                    SUBSTR(SQLCODE, 1, 10) || ':' ||
                                    SUBSTR(SQLERRM, 1, 100);
                    RETURN;
                END;

                IF (L_V_STOWAGE_POSITION !=
                   L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION) THEN

                  /* update record in booked load list table */
                  UPDATE TOS_DL_BOOKED_DISCHARGE
                     SET STOWAGE_POSITION   = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                        ,RECORD_CHANGE_USER = P_I_V_USER_ID
                        ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                      'YYYYMMDDHH24MISS')
                   WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID;
                END IF;
              END IF;

            END IF;

          END IF;

          UPDATE TOS_RESTOW
             SET DN_EQUIPMENT_NO         = L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO
                ,DN_EQ_SIZE              = L_V_DN_EQ_SIZE
                ,DN_EQ_TYPE              = L_V_DN_EQ_TYPE
                ,DN_SOC_COC              = L_V_DN_SOC_COC
                ,DN_SHIPMENT_TERM        = L_V_DN_SHIPMENT_TERM
                ,DN_SHIPMENT_TYP         = L_V_DN_SHIPMENT_TYP
                ,ACTIVITY_DATE_TIME      = TO_DATE(L_CUR_RESTOWED_DATA_REC.ACTIVITY_DATE_TIME,
                                                   'DD/MM/YYYY HH24:MI')
                ,CONTAINER_GROSS_WEIGHT  = L_CUR_RESTOWED_DATA_REC.CONTAINER_GROSS_WEIGHT
                ,DAMAGED                 = L_CUR_RESTOWED_DATA_REC.DAMAGED
                ,VOID_SLOT               = L_V_VOID_SLOT
                ,FK_SLOT_OPERATOR        = L_V_FK_SLOT_OPERATOR
                ,FK_CONTAINER_OPERATOR   = L_V_FK_CONT_OPERATOR
                ,DN_SPECIAL_HNDL         = L_V_DN_SPECIAL_HNDL
                ,SEAL_NO                 = L_CUR_RESTOWED_DATA_REC.SEAL_NO
                ,FK_SPECIAL_CARGO        = L_V_FK_SPECIAL_CARGO
                ,MIDSTREAM_HANDLING_CODE = L_CUR_RESTOWED_DATA_REC.MIDSTREAM_HANDLING_CODE
                ,LOAD_CONDITION          = L_V_LOAD_CONDITION
                ,RESTOW_STATUS           = L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS
                ,STOWAGE_POSITION        = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                ,PUBLIC_REMARK           = L_CUR_RESTOWED_DATA_REC.PUBLIC_REMARK
                ,RECORD_CHANGE_USER      = P_I_V_USER_ID
                ,RECORD_CHANGE_DATE      = TO_DATE(P_I_V_DATE,
                                                   'YYYYMMDDHH24MISS')
           WHERE PK_RESTOW_ID = L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID;

          -------------
        ELSE
          /* Check if stowage position is changed */
          SELECT STOWAGE_POSITION
            INTO L_V_STOWAGE_POSITION
            FROM TOS_RESTOW
           WHERE PK_RESTOW_ID = L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID;

          IF NVL(L_V_STOWAGE_POSITION, '~') !=
             NVL(L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION, '~') THEN
            --------------------

            /* get port sequence # for the current discharge list */
            SELECT FK_PORT_SEQUENCE_NO
              INTO L_V_FK_PORT_SEQUENCE_NO
              FROM TOS_DL_DISCHARGE_LIST
             WHERE PK_DISCHARGE_LIST_ID =
                   L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID
               AND ROWNUM = 1;

            PRE_EDL_PREV_LOAD_LIST_ID(P_I_V_VESSEL,
                                      L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                      L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                      P_I_V_DISCHARGE_ETA,
                                      P_I_V_HDR_ETA_TM,
                                      P_I_V_HDR_PORT,
                                      L_V_FK_PORT_SEQUENCE_NO,
                                      L_V_LOAD_LIST_ID,
                                      L_V_FLAG,
                                      P_O_V_ERR_CD);

            IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
               P_O_V_ERR_CD <> 'EDL.SE0121') THEN
              RETURN;
            END IF;
            IF (P_O_V_ERR_CD = 'EDL.SE0121') THEN
              G_V_WARNING := 'EDL.SE0112' ||
                             PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                             L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO ||
                             PCE_EUT_COMMON.G_V_ERR_CD_SEP;
              RETURN;
            END IF;

            IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

              IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS = 'XX') THEN

                BEGIN
                  SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                    INTO L_V_LOCK_DATA
                    FROM TOS_LL_BOOKED_LOADING
                   WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID
                  -- AND LOADING_STATUS <> 'LO'     -- vikas as, k'chatgamol 17.02.2012  -- *1
                     FOR UPDATE NOWAIT;

                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
                    RETURN;
                  WHEN OTHERS THEN
                    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                                    PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                                    SUBSTR(SQLCODE, 1, 10) || ':' ||
                                    SUBSTR(SQLERRM, 1, 100);
                    RETURN;
                END;

                /* update record in booked load list table */

                UPDATE TOS_LL_BOOKED_LOADING
                   SET STOWAGE_POSITION   = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                      ,RECORD_CHANGE_USER = P_I_V_USER_ID
                      ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                    'YYYYMMDDHH24MISS')
                 WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID
                      -- AND LOADING_STATUS <> 'LO';     -- vikas as, k'chatgamol 24.11.2011 -- *1
                   AND (STOWAGE_POSITION IS NULL OR LOADING_STATUS <> 'LO'); -- *1
              END IF;

              IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS IN
                 ('LR', 'RA', 'LC', 'RP', 'XX')) THEN

                /* get port sequence # for the current discharge list */
                SELECT FK_PORT_SEQUENCE_NO
                  INTO L_V_FK_PORT_SEQUENCE_NO
                  FROM TOS_DL_DISCHARGE_LIST
                 WHERE PK_DISCHARGE_LIST_ID =
                       L_CUR_RESTOWED_DATA_REC.FK_DISCHARGE_LIST_ID
                   AND ROWNUM = 1;
                -- *28  Comemnted and add new procedure- start
                /*PRE_EDL_NEXT_DISCHARGE_LIST_ID (
                      p_i_v_vessel
                    , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                    , l_cur_restowed_data_rec.FK_BOOKING_NO
                    , p_i_v_discharge_etd
                    , p_i_v_hdr_etd_tm
                    , p_i_v_hdr_port
                    , l_v_fk_port_sequence_no
                    , l_v_discharge_id
                    , l_v_flag
                    , p_o_v_err_cd
                );*/
                PCE_ELL_LLMAINTENANCE.PRE_FIND_DISCHARGE_LIST(L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                                              P_I_V_VESSEL,
                                                              L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                                              L_V_FLAG,
                                                              L_V_DISCHARGE_ID,
                                                              P_O_V_ERR_CD);
                -- *28 end

                IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                  RETURN;
                END IF;

                IF (L_V_FLAG = 'D') THEN

                  BEGIN

                    SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                      INTO L_V_LOCK_DATA
                      FROM TOS_DL_BOOKED_DISCHARGE
                     WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                       FOR UPDATE NOWAIT;

                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
                      RETURN;
                    WHEN OTHERS THEN
                      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                                      SUBSTR(SQLERRM, 1, 100);
                      RETURN;
                  END;

                  /* update record in booked load list table */
                  UPDATE TOS_DL_BOOKED_DISCHARGE
                     SET STOWAGE_POSITION   = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                        ,RECORD_CHANGE_USER = P_I_V_USER_ID
                        ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                      'YYYYMMDDHH24MISS')
                   WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID;

                END IF;

              END IF;

            END IF;
            --------------------
          END IF;

          UPDATE TOS_RESTOW
             SET DN_EQUIPMENT_NO         = L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO
                ,MIDSTREAM_HANDLING_CODE = L_CUR_RESTOWED_DATA_REC.MIDSTREAM_HANDLING_CODE
                ,LOAD_CONDITION          = L_CUR_RESTOWED_DATA_REC.LOAD_CONDITION
                ,RESTOW_STATUS           = L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS
                ,STOWAGE_POSITION        = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                ,ACTIVITY_DATE_TIME      = TO_DATE(L_CUR_RESTOWED_DATA_REC.ACTIVITY_DATE_TIME,
                                                   'DD/MM/YYYY HH24:MI')
                ,CONTAINER_GROSS_WEIGHT  = L_CUR_RESTOWED_DATA_REC.CONTAINER_GROSS_WEIGHT
                ,DAMAGED                 = L_CUR_RESTOWED_DATA_REC.DAMAGED
                ,SEAL_NO                 = L_CUR_RESTOWED_DATA_REC.SEAL_NO
                ,PUBLIC_REMARK           = L_CUR_RESTOWED_DATA_REC.PUBLIC_REMARK
                ,RECORD_CHANGE_USER      = P_I_V_USER_ID
                ,RECORD_CHANGE_DATE      = TO_DATE(P_I_V_DATE,
                                                   'YYYYMMDDHH24MISS')
           WHERE PK_RESTOW_ID = L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID;
        END IF;

        /* Deleted the selected record*/
      ELSIF (L_CUR_RESTOWED_DATA_REC.OPN_STATUS =
            PCE_EUT_COMMON.G_V_REC_DEL) THEN

        /* get lock on restow table */
        PCV_EDL_RECORD_LOCK(L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID,
                            TO_CHAR(L_CUR_RESTOWED_DATA_REC.RECORD_CHANGE_DATE,
                                    'YYYYMMDDHH24MISS'),
                            'RESTOWED',
                            P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        -- Delete the record from table.
        DELETE FROM TOS_RESTOW
         WHERE PK_RESTOW_ID = L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID;

      END IF;

      -- Increment row number.
      IF (L_CUR_RESTOWED_DATA_REC.OPN_STATUS IS NULL OR
         L_CUR_RESTOWED_DATA_REC.OPN_STATUS <> PCE_EUT_COMMON.G_V_REC_DEL) THEN
        L_V_RESTOW_ROW_NUM := L_V_RESTOW_ROW_NUM + 1;
      END IF;

    END LOOP;

    IF L_V_ERRORS IS NOT NULL
       AND (L_V_ERRORS != PCE_EUT_COMMON.G_V_SUCCESS_CD AND
       P_O_V_ERR_CD != PCE_EUT_COMMON.G_V_GE0005 AND
       P_O_V_ERR_CD != PCE_EUT_COMMON.G_V_GE0002) THEN
      P_O_V_ERR_CD := L_V_ERRORS;

      RETURN;
      --    raise exp_error_on_save;
    END IF;

  EXCEPTION
    WHEN EXP_ERROR_ON_SAVE THEN
      RETURN;
      --        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;
      --        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

  END PRE_EDL_SAVE_RESTOW_TAB_MAIN;

  PROCEDURE PRE_EDL_BOOKED_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                     ,P_I_ROW_NUM             NUMBER
                                     ,P_I_V_DISCHARGE_LIST_ID VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                     ,P_I_V_PK_DISCHARGE_LIST VARCHAR2
                                     ,P_I_V_CLR_CODE1         VARCHAR2
                                     ,P_I_V_CLR_CODE2         VARCHAR2
                                     ,P_I_V_OPER_CD           VARCHAR2
                                     ,P_I_V_UNNO              VARCHAR2
                                     ,P_I_V_PORT_CODE         VARCHAR2
                                     ,P_I_V_VARIANT           VARCHAR2
                                     ,P_I_V_IMDG              VARCHAR2
                                     ,P_I_V_SHI_CODE1         VARCHAR2
                                     ,P_I_V_SHI_CODE2         VARCHAR2
                                     ,P_I_V_SHI_CODE3         VARCHAR2
                                     ,P_I_V_PORT_CLASS        VARCHAR2
                                     ,P_I_V_PORT_CLASS_TYPE   VARCHAR2
                                     ,P_I_V_SLOT_OPERATOR     VARCHAR2
                                     ,P_I_V_OUT_SLOT_OPERATOR VARCHAR2
                                     ,P_I_V_DN_SOC_COC        VARCHAR2
                                     ,P_I_V_DN_FULL_MT        VARCHAR2
                                     ,P_I_V_DISCHARGE_ETD     VARCHAR2
                                     ,P_I_V_HDR_ETD_TM        VARCHAR2
                                     ,P_O_V_ERR_CD            OUT VARCHAR2) AS

    L_V_RECORD_COUNT NUMBER := 0;
    L_V_SHIPMENT_TYP TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP%TYPE; -- *2

  BEGIN

    -- Set the error code to its default value (0000);
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_DL_BOOKED_DISCHARGE_TMP
     WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
       AND DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       AND PK_BOOKED_DISCHARGE_ID != P_I_V_PK_DISCHARGE_LIST
       AND SESSION_ID = P_I_V_SESSION_ID;

    -- When count is more then zero means record is already availabe, show error
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'EDL.SE0127' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;

      RETURN;
    END IF;

    /*
        *2 : Changes starts

    *
        Get the shipment type for the booking#
    */
    BEGIN
      L_V_SHIPMENT_TYP := NULL;
      SELECT DN_SHIPMENT_TYP
        INTO L_V_SHIPMENT_TYP
        FROM TOS_DL_BOOKED_DISCHARGE
       WHERE PK_BOOKED_DISCHARGE_ID = P_I_V_PK_DISCHARGE_LIST;

    EXCEPTION
      WHEN OTHERS THEN
        L_V_SHIPMENT_TYP := NULL;
    END;
    /*
        *2 : Changes end
    */

    /* Check if old container was COC container then changed container should also be COC container*/
    IF (P_I_V_DN_SOC_COC = 'C')
       AND (NVL(L_V_SHIPMENT_TYP, '*') <> 'UC') THEN
      -- *2
      IF P_I_V_EQUIPMENT_NO IS NOT NULL THEN
        /* Equipment Type should be COC */
        IF (PCE_EUT_COMMON.FN_CHECK_COC_FLAG(P_I_V_EQUIPMENT_NO,
                                             P_I_V_PORT_CODE,
                                             P_I_V_DISCHARGE_ETD,
                                             P_I_V_HDR_ETD_TM,
                                             P_O_V_ERR_CD) = FALSE) THEN
          P_O_V_ERR_CD := 'EDL.SE0132' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                          P_I_V_EQUIPMENT_NO ||
                          PCE_EUT_COMMON.G_V_ERR_CD_SEP;

          RETURN;
        END IF;
      END IF;

    END IF;

    /* Check for the Container Loading Remark Code in dolphin master table. */
    PRE_EDL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE1,
                            P_I_V_EQUIPMENT_NO,
                            P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the Container Loading Remark Code in dolphin master table. */
    PRE_EDL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE2,
                            P_I_V_EQUIPMENT_NO,
                            P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    IF P_I_V_DN_SOC_COC = 'C' THEN
      /* Check for the Container Operator in OPERATOR_CODE Master Table. */
      PRE_EDL_OL_VAL_OPERATOR_CODE(P_I_V_OPER_CD,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* Check for the Sloat Operator in OPERATOR_CODE Master Table. */
      PRE_EDL_OL_VAL_OPERATOR_CODE(P_I_V_SLOT_OPERATOR,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* Check for the out Sloat Operator in OPERATOR_CODE Master Table.
          PRE_EDL_OL_VAL_OPERATOR_CODE( p_i_v_OUT_SLOT_OPERATOR, p_i_v_equipment_no, p_o_v_err_cd);
          IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
              RETURN;
          END IF ;
      */
    END IF;

    /*    Handling Instruction Code validation */
    PRE_EDL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE1,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code validation */
    PRE_EDL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE2,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code validation */
    PRE_EDL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE3,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the IMDG Code in IMDG Master Table. */

    /*
        Start modified by vikas,
        port class logic is already available in ll maintenance
        screen so no need to implemente again, 16.12.2011
    */
    /*
    PRE_EDL_OL_VAL_IMDG(p_i_v_unno, p_i_v_variant, p_i_v_imdg, p_i_v_equipment_no, p_o_v_err_cd);
    */
    PCE_ELL_LLMAINTENANCE.PRE_ELL_OL_VAL_IMDG(P_I_V_UNNO,
                                              P_I_V_VARIANT,
                                              P_I_V_IMDG,
                                              P_I_V_EQUIPMENT_NO,
                                              P_O_V_ERR_CD);

    /*
        End modified by vikas, 16.12.2011
    */

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*
        Start modified by vikas,
        port class logic is already available in ll maintenance
        screen so no need to implemente again, 16.12.2011
    */

    /* Validate Port Class Type if no data found then show error message: Invalid Port Class. *
        PRE_EDL_OL_VAL_PORT_CLASS( p_i_v_port_code
            , p_i_v_unno, p_i_v_variant
            , p_i_v_imdg, p_i_v_port_class
            , p_i_v_port_class_type, p_i_v_equipment_no,  p_o_v_err_cd);
    */
    -- *29 start
    /* PCE_ELL_LLMAINTENANCE.PRE_ELL_OL_VAL_PORT_CLASS(
        p_i_v_port_code
        , p_i_v_unno
        , p_i_v_variant
        , p_i_v_imdg
        , p_i_v_port_class
        , p_i_v_port_class_type
        , p_i_v_equipment_no
        , p_o_v_err_cd
    );*/

    /*
        End added by vikas, 16.12.2011
    */

    /*
    IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
        RETURN;
    END IF ;
    */
    -- *29 end

    /* Validate UN Number and UN Number Variant for discharge list overlanded tab */
    /*
        Start modified by vikas,
        port class logic is already available in ll maintenance
        screen so no need to implemente again, 16.12.2011
    */
    /*
    PRE_EDL_OL_VAL_UNNO(p_i_v_unno, p_i_v_variant, p_i_v_equipment_no, p_o_v_err_cd);
    */
    PCE_ELL_LLMAINTENANCE.PRE_ELL_OL_VAL_UNNO(P_I_V_UNNO,
                                              P_I_V_VARIANT,
                                              P_I_V_EQUIPMENT_NO,
                                              P_O_V_ERR_CD);

    /*
        End modified by vikas, 16.12.2011
    */
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;
    --*29 start
    PCE_ELL_LLMAINTENANCE.PRE_ELL_OL_VAL_PORT_CLASS_TYPE(P_I_V_PORT_CODE,
                                                         P_I_V_PORT_CLASS_TYPE,
                                                         P_I_V_EQUIPMENT_NO,
                                                         P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;
    --*29 end
  EXCEPTION
    WHEN OTHERS THEN
      RETURN;

  END PRE_EDL_BOOKED_VALIDATION;

  PROCEDURE PRE_EDL_OVERLANDED_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                         ,P_I_ROW_NUM             VARCHAR2
                                         ,P_I_V_DISCHARGE_LIST_ID VARCHAR2
                                         ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                         ,P_I_V_PK_CONT_ID        VARCHAR2
                                         ,P_I_V_CLR_CODE1         VARCHAR2
                                         ,P_I_V_CLR_CODE2         VARCHAR2
                                         ,P_I_V_OPER_CD           VARCHAR2
                                         ,P_I_V_SHI_CODE1         VARCHAR2
                                         ,P_I_V_SHI_CODE2         VARCHAR2
                                         ,P_I_V_SHI_CODE3         VARCHAR2
                                         ,P_I_V_UNNO              VARCHAR2
                                         ,P_I_V_VARIANT           VARCHAR2
                                         ,P_I_V_IMDG              VARCHAR2
                                         ,P_I_V_PORT_CODE         VARCHAR2
                                         ,P_I_V_PORT_CLASS        VARCHAR2
                                         ,P_I_V_PORT_CLASS_TYPE   VARCHAR2
                                         ,P_I_V_OUT_SLOT_OPERATOR VARCHAR2
                                         ,P_I_V_SLOT_OPERATOR     VARCHAR2
                                         ,P_I_V_SHIPMNT_CD        VARCHAR2
                                         ,P_I_V_SOC_COC           VARCHAR2
                                         ,P_I_V_DISCHARGE_ETD     VARCHAR2
                                         ,P_I_V_HDR_ETD_TM        VARCHAR2
                                         ,P_I_V_EQUIP_TYPE        VARCHAR2
                                         ,P_I_V_POL_CODE          VARCHAR2
                                         ,P_I_V_POL_TERMINAL_CODE VARCHAR2
                                         ,P_O_V_ERR_CD            OUT VARCHAR2) AS
    L_V_RECORD_COUNT NUMBER := 0;
    L_V_SHIPMENT_TYP TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP%TYPE; -- *2

  BEGIN
    /* Set the error code to its default value (00000) */
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_DL_OVERLANDED_CONT_TMP
     WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
       AND EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       AND PK_OVERLANDED_CONTAINER_ID != NVL(P_I_V_PK_CONT_ID, ' ')
       AND SESSION_ID = P_I_V_SESSION_ID;

    -- When count is more then zero means record is already availabe, show error
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'EDL.SE0122' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_DL_BOOKED_DISCHARGE    BD
          ,TOS_DL_OVERLANDED_CONT_TMP OS
     WHERE OS.FK_DISCHARGE_LIST_ID = BD.FK_DISCHARGE_LIST_ID
       AND OS.FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
       AND OS.EQUIPMENT_NO = BD.DN_EQUIPMENT_NO
       AND OS.EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       AND OS.DISCHARGE_STATUS IN ('DR', 'DC')
       AND BD.DISCHARGE_STATUS != 'RB';

    -- Equipment# present in Booked tab with status other than 'ROB'
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'EDL.SE0123' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    /*
        *2 : Changes starts
    *
        Get the shipment type for the Overlanded table
    */
    BEGIN
      L_V_SHIPMENT_TYP := NULL;

      SELECT SHIPMENT_TYP
        INTO L_V_SHIPMENT_TYP
        FROM TOS_DL_OVERLANDED_CONT_TMP -- In overlanded tab, shipment type is editable so need to get from temp table
       WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
         AND EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
         AND PK_OVERLANDED_CONTAINER_ID = P_I_V_PK_CONT_ID
         AND SESSION_ID = P_I_V_SESSION_ID;

    EXCEPTION
      WHEN OTHERS THEN
        L_V_SHIPMENT_TYP := NULL;
    END;
    /*
        *2 : Changes end
    */

    IF (P_I_V_SOC_COC = 'C')
       AND (NVL(L_V_SHIPMENT_TYP, '*') <> 'UC') THEN
      -- *2
      IF P_I_V_EQUIPMENT_NO IS NOT NULL THEN
        /* Equipment Type should be COC */
        IF (PCE_EUT_COMMON.FN_CHECK_COC_FLAG(P_I_V_EQUIPMENT_NO,
                                             P_I_V_PORT_CODE,
                                             P_I_V_DISCHARGE_ETD,
                                             P_I_V_HDR_ETD_TM,
                                             P_O_V_ERR_CD) = FALSE) THEN
          P_O_V_ERR_CD := 'EDL.SE0132' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                          P_I_V_EQUIPMENT_NO ||
                          PCE_EUT_COMMON.G_V_ERR_CD_SEP;
          RETURN;
        END IF;
      END IF;
    END IF;

    /* Check for the Container Loading Remark Code1 in dolphin master table. */
    PRE_EDL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE1,
                            P_I_V_EQUIPMENT_NO,
                            P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the Container Loading Remark Code2 in dolphin master table. */
    PRE_EDL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE2,
                            P_I_V_EQUIPMENT_NO,
                            P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the Equipment Type in dolphin master table. */
    PRE_EDL_VAL_EQUIPMENT_TYPE(P_I_V_EQUIP_TYPE,
                               P_I_V_EQUIPMENT_NO,
                               P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the shipment term. */
    PRE_SHIPMENT_TERM_OL_CODE(P_I_V_SHIPMNT_CD,
                              P_I_V_EQUIPMENT_NO,
                              P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    IF (P_I_V_SOC_COC = 'C') THEN
      /* Check for the Slot Operator in OPERATOR_CODE Master Table. */
      PRE_EDL_OL_VAL_OPERATOR_CODE(P_I_V_SLOT_OPERATOR,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* Check for the Container Operator in OPERATOR_CODE Master Table. */
      PRE_EDL_OL_VAL_OPERATOR_CODE(P_I_V_OPER_CD,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* Check for the Out slot OPERATOR_CODE Master Table.
      PRE_EDL_OL_VAL_OPERATOR_CODE( p_i_v_out_slot_operator, p_i_v_equipment_no, p_o_v_err_cd);
      IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
          RETURN;
      END IF ;
      */
    END IF;

    /* Check for the POL Code in  Master Table. */
    PRE_EDL_VAL_PORT_CODE(P_I_V_POL_CODE, P_I_V_EQUIPMENT_NO, P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the POL Terminal Code in  Master Table. */
    PRE_EDL_VAL_PORT_TERMINAL_CODE(P_I_V_POL_TERMINAL_CODE,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code validation */
    PRE_EDL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE1,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code validation */
    PRE_EDL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE2,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code validation */
    PRE_EDL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE3,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the IMDG Code in IMDG Master Table. */
    /*
        Start modified by vikas,
        port class logic is already available in ll maintenance
        screen so no need to implemente again, 16.12.2011
    */
    /*
    PRE_EDL_OL_VAL_IMDG(p_i_v_unno, p_i_v_variant, p_i_v_imdg, p_i_v_equipment_no,  p_o_v_err_cd);
    */

    PCE_ELL_LLMAINTENANCE.PRE_ELL_OL_VAL_IMDG(P_I_V_UNNO,
                                              P_I_V_VARIANT,
                                              P_I_V_IMDG,
                                              P_I_V_EQUIPMENT_NO,
                                              P_O_V_ERR_CD);

    /*
        End modified by vikas, 16.12.2011
    */

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*
        Start modified by vikas,
        port class logic is already available in ll maintenance
        screen so no need to implemente again, 16.12.2011
    */

    /* Validate Port Class Type if no data found then show error message: Invalid Port Class. *
    -- PRE_EDL_OL_VAL_PORT_CLASS( p_i_v_port_code, p_i_v_unno, p_i_v_variant , p_i_v_imdg, p_o_v_err_cd);
    PRE_EDL_OL_VAL_PORT_CLASS(
          p_i_v_port_code
        , p_i_v_unno
        , p_i_v_variant
        , p_i_v_imdg
        , p_i_v_port_class
        , p_i_v_port_class_type
        ,p_i_v_equipment_no
        , p_o_v_err_cd
    );
    */

    --*29 start
    /*
    PCE_ELL_LLMAINTENANCE.PRE_ELL_OL_VAL_PORT_CLASS(
          p_i_v_port_code
        , p_i_v_unno
        , p_i_v_variant
        , p_i_v_imdg
        , p_i_v_port_class
        , p_i_v_port_class_type
        , p_i_v_equipment_no
        , p_o_v_err_cd
    );
    */

    /*
        End added by vikas, 16.12.2011
    */

    /* IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
        RETURN;
    END IF ; */
    --*29 end

    /* Validate UN Number and UN Number Variant for discharge list overlanded tab */
    /*
        Start modified by vikas,
        port class logic is already available in ll maintenance
        screen so no need to implemente again, 16.12.2011
    */
    /*
    PRE_EDL_OL_VAL_UNNO(p_i_v_unno, p_i_v_variant,  p_i_v_equipment_no, p_o_v_err_cd);
    */
    PCE_ELL_LLMAINTENANCE.PRE_ELL_OL_VAL_UNNO(P_I_V_UNNO,
                                              P_I_V_VARIANT,
                                              P_I_V_EQUIPMENT_NO,
                                              P_O_V_ERR_CD);

    /*
        End modified by vikas, 16.12.2011
    */
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;
    --*29 start
    PCE_ELL_LLMAINTENANCE.PRE_ELL_OL_VAL_PORT_CLASS_TYPE(P_I_V_PORT_CODE,
                                                         P_I_V_PORT_CLASS_TYPE,
                                                         P_I_V_EQUIPMENT_NO,
                                                         P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;
    --*29 end
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;
  END PRE_EDL_OVERLANDED_VALIDATION;

  PROCEDURE PRE_EDL_SYNCH_BOOKING(P_I_V_PK_BOOKED_ID        VARCHAR2
                                 ,P_I_V_CONTAINER_SEQ_NO    VARCHAR2
                                 ,P_I_V_DN_EQUIPMENT_NO     VARCHAR2
                                 ,P_I_V_FK_BOOKING_NO       VARCHAR2
                                 ,P_I_V_OVERWIDTH_LEFT_CM   VARCHAR2
                                 ,P_I_V_OVERHEIGHT_CM       VARCHAR2
                                 ,P_I_V_OVERWIDTH_RIGHT_CM  VARCHAR2
                                 ,P_I_V_OVERLENGTH_FRONT_CM VARCHAR2
                                 ,P_I_V_OVERLENGTH_REAR_CM  VARCHAR2
                                 ,P_I_V_FK_IMDG             VARCHAR2
                                 ,P_I_V_FK_UNNO             VARCHAR2
                                 ,P_I_V_FK_UN_VAR           VARCHAR2
                                 ,P_I_V_FLASH_POINT         VARCHAR2
                                 ,P_I_V_FLASH_UNIT          VARCHAR2
                                 ,P_I_V_REEFER_TMP_UNIT     VARCHAR2
                                 ,P_I_V_TEMPERATURE         VARCHAR2
                                 ,P_I_V_DN_HUMIDITY         VARCHAR2
                                 ,P_I_V_WEIGHT              VARCHAR2
                                 ,P_I_V_DN_VENTILATION      VARCHAR2
                                 ,P_I_V_CATEGORY            VARCHAR2 --*36
                                 ,P_I_V_VGM                 VARCHAR2 --*36
                                 ,P_O_V_ERR_CD              OUT NOCOPY VARCHAR2) AS
    L_V_BOOKINGNO       VARCHAR2(17);
    L_N_EQUIPMENTSEQNO  NUMBER;
    L_V_EQUIPNO         VARCHAR2(12);
    L_N_OVERHEIGHT      NUMBER;
    L_N_OVERLENGTHREAR  NUMBER;
    L_N_OVERLENGTHFRONT NUMBER;
    L_N_OVERWIDTHLEFT   NUMBER;
    L_N_OVERWIDTHRIGHT  NUMBER;
    L_V_IMDG            VARCHAR2(4);
    L_V_UNNO            VARCHAR2(6);
    L_V_UNVAR           VARCHAR2(1);
    L_V_FLASHPOINT      VARCHAR2(7);
    L_V_FLASHUNIT       VARCHAR2(1);
    L_V_REEFERTMP       VARCHAR2(8);
    L_V_REEFERTMPUNIT   VARCHAR2(1);
    L_N_HUMIDITY        NUMBER;
    L_N_GROSSWT         NUMBER;
    L_N_DN_VENTILATION  NUMBER;
    L_V_SQL_ID          VARCHAR2(10);
    L_V_PARAMETER_STR   TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;
    L_V_ERR_DESC        VARCHAR2(100);
    V_VGM               NUMBER; --*36
    V_CATEGORY_CODE     VARCHAR2(100); --*36 
  BEGIN
    L_V_PARAMETER_STR := P_I_V_PK_BOOKED_ID || '~' ||
                         P_I_V_CONTAINER_SEQ_NO || '~' ||
                         P_I_V_DN_EQUIPMENT_NO || '~' ||
                         P_I_V_FK_BOOKING_NO || '~' ||
                         P_I_V_OVERWIDTH_LEFT_CM || '~' ||
                         P_I_V_OVERHEIGHT_CM || '~' ||
                         P_I_V_OVERWIDTH_RIGHT_CM || '~' ||
                         P_I_V_OVERLENGTH_FRONT_CM || '~' ||
                         P_I_V_OVERLENGTH_REAR_CM || '~' || P_I_V_FK_IMDG || '~' ||
                         P_I_V_FK_UNNO || '~' || P_I_V_FK_UN_VAR || '~' ||
                         P_I_V_FLASH_POINT || '~' || P_I_V_FLASH_UNIT || '~' ||
                         P_I_V_REEFER_TMP_UNIT || '~' || P_I_V_TEMPERATURE || '~' ||
                         P_I_V_DN_HUMIDITY || '~' || P_I_V_WEIGHT || '~' ||
                         P_I_V_DN_VENTILATION || '~' || 
                         P_I_V_CATEGORY || '~' || P_I_V_VGM --*36 
                         ;

    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    L_V_SQL_ID := 'SQL00S1';
    SELECT DN_EQUIPMENT_NO
          ,OVERWIDTH_LEFT_CM
          ,OVERHEIGHT_CM
          ,OVERWIDTH_RIGHT_CM
          ,OVERLENGTH_FRONT_CM
          ,OVERLENGTH_REAR_CM
          ,FK_IMDG
          ,FK_UNNO
          ,FK_UN_VAR
          ,FLASH_POINT
          ,FLASH_UNIT
          ,REEFER_TMP_UNIT
          ,REEFER_TEMPERATURE
          ,DN_HUMIDITY
          ,CONTAINER_GROSS_WEIGHT
          ,DN_VENTILATION
          ,VGM --*36
          ,CATEGORY_CODE --*36
      INTO L_V_EQUIPNO
          ,L_N_OVERWIDTHLEFT
          ,L_N_OVERHEIGHT
          ,L_N_OVERWIDTHRIGHT
          ,L_N_OVERLENGTHFRONT
          ,L_N_OVERLENGTHREAR
          ,L_V_IMDG
          ,L_V_UNNO
          ,L_V_UNVAR
          ,L_V_FLASHPOINT
          ,L_V_FLASHUNIT
          ,L_V_REEFERTMPUNIT
          ,L_V_REEFERTMP
          ,L_N_HUMIDITY
          ,L_N_GROSSWT
          ,L_N_DN_VENTILATION
          ,V_VGM --*36
          ,V_CATEGORY_CODE --*36
      FROM TOS_DL_BOOKED_DISCHARGE
     WHERE PK_BOOKED_DISCHARGE_ID = P_I_V_PK_BOOKED_ID;

    L_V_SQL_ID := 'SQL00S2';
    -- check the value of passed data from db value
    IF (NVL(P_I_V_DN_EQUIPMENT_NO, '~') <> NVL(L_V_EQUIPNO, '~')) THEN
      L_V_EQUIPNO := NVL(P_I_V_DN_EQUIPMENT_NO, '~');
    ELSE
      L_V_EQUIPNO := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S3';
    IF (NVL(TO_NUMBER(P_I_V_OVERWIDTH_LEFT_CM), 0) <>
       NVL(L_N_OVERWIDTHLEFT, 0)) THEN
      L_N_OVERWIDTHLEFT := NVL(P_I_V_OVERWIDTH_LEFT_CM, 0);
    ELSE
      L_N_OVERWIDTHLEFT := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S4';
    IF (NVL(TO_NUMBER(P_I_V_OVERHEIGHT_CM), 0) <> NVL(L_N_OVERHEIGHT, 0)) THEN
      L_N_OVERHEIGHT := NVL(P_I_V_OVERHEIGHT_CM, 0);
    ELSE
      L_N_OVERHEIGHT := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S5';
    IF (NVL(TO_NUMBER(P_I_V_OVERWIDTH_RIGHT_CM), 0) <>
       NVL(L_N_OVERWIDTHRIGHT, 0)) THEN
      L_N_OVERWIDTHRIGHT := NVL(P_I_V_OVERWIDTH_RIGHT_CM, 0);
    ELSE
      L_N_OVERWIDTHRIGHT := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S6';
    IF (NVL(TO_NUMBER(P_I_V_OVERLENGTH_FRONT_CM), 0) <>
       NVL(L_N_OVERLENGTHFRONT, 0)) THEN
      L_N_OVERLENGTHFRONT := NVL(P_I_V_OVERLENGTH_FRONT_CM, 0);
    ELSE
      L_N_OVERLENGTHFRONT := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S7';
    IF (NVL(TO_NUMBER(P_I_V_OVERLENGTH_REAR_CM), 0) <>
       NVL(L_N_OVERLENGTHREAR, 0)) THEN
      L_N_OVERLENGTHREAR := NVL(P_I_V_OVERLENGTH_REAR_CM, 0);
    ELSE
      L_N_OVERLENGTHREAR := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S8';
    IF (NVL(P_I_V_FK_IMDG, '~') <> NVL(L_V_IMDG, '~')) THEN
      L_V_IMDG := NVL(P_I_V_FK_IMDG, '~');
    ELSE
      L_V_IMDG := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S9';
    IF (NVL(P_I_V_FK_UNNO, ' ') <> NVL(L_V_UNNO, ' ')) THEN
      L_V_UNNO := NVL(P_I_V_FK_UNNO, '~');
    ELSE
      L_V_UNNO := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S10';
    IF (NVL(P_I_V_FK_UN_VAR, '~') <> NVL(L_V_UNVAR, '~')) THEN
      L_V_UNVAR := NVL(P_I_V_FK_UN_VAR, '~');
    ELSE
      L_V_UNVAR := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S11';
    IF (NVL(TO_NUMBER(P_I_V_FLASH_POINT), 0) <>
       NVL(TO_NUMBER(L_V_FLASHPOINT), 0)) THEN
      L_V_FLASHPOINT := NVL(P_I_V_FLASH_POINT, '~');
    ELSE
      IF (P_I_V_FLASH_POINT IS NOT NULL AND L_V_FLASHPOINT IS NULL)
         OR (P_I_V_FLASH_POINT IS NULL AND L_V_FLASHPOINT IS NOT NULL) THEN
        -- Repalce with l_n_flashPoint := NULL if no need to trigger on change from Null to 0 and Vice Versa.
        L_V_FLASHPOINT := NVL(P_I_V_FLASH_POINT, '~');
      ELSE
        L_V_FLASHPOINT := NULL;
      END IF;

    END IF;

    L_V_SQL_ID := 'SQL00S12';
    IF (NVL(P_I_V_FLASH_UNIT, '~') <> NVL(L_V_FLASHUNIT, '~')) THEN
      L_V_FLASHUNIT := NVL(P_I_V_FLASH_UNIT, '~');
    ELSE
      L_V_FLASHUNIT := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S13';
    IF (NVL(TO_NUMBER(P_I_V_TEMPERATURE), 0) <>
       NVL(TO_NUMBER(L_V_REEFERTMP), 0)) THEN
      L_V_REEFERTMP := NVL(P_I_V_TEMPERATURE, '~');
    ELSE
      IF (P_I_V_TEMPERATURE IS NOT NULL AND L_V_REEFERTMP IS NULL)
         OR (P_I_V_TEMPERATURE IS NULL AND L_V_REEFERTMP IS NOT NULL) THEN
        -- Repalce with l_n_flashPoint := NULL if no need to trigger on change from Null to 0 and Vice Versa.
        L_V_REEFERTMP := NVL(P_I_V_TEMPERATURE, '~');
      ELSE
        L_V_REEFERTMP := NULL;
      END IF;
    END IF;

    L_V_SQL_ID := 'SQL00S14';
    IF (NVL(P_I_V_REEFER_TMP_UNIT, '~') <> NVL(L_V_REEFERTMPUNIT, '~')) THEN
      L_V_REEFERTMPUNIT := NVL(P_I_V_REEFER_TMP_UNIT, '~');
    ELSE
      L_V_REEFERTMPUNIT := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S15';
    IF (NVL(TO_NUMBER(P_I_V_DN_HUMIDITY), 0) <> NVL(L_N_HUMIDITY, 0)) THEN
      L_N_HUMIDITY := NVL(P_I_V_DN_HUMIDITY, 0);
    ELSE
      IF (P_I_V_DN_HUMIDITY IS NOT NULL AND L_N_HUMIDITY IS NULL)
         OR (P_I_V_DN_HUMIDITY IS NULL AND L_N_HUMIDITY IS NOT NULL) THEN
        L_N_HUMIDITY := 0;
      ELSE
        L_N_HUMIDITY := NULL;
      END IF;
    END IF;

    L_V_SQL_ID := 'SQL00S16';
    IF (NVL(TO_NUMBER(P_I_V_DN_VENTILATION), 0) <>
       NVL(L_N_DN_VENTILATION, 0)) THEN
      L_N_DN_VENTILATION := NVL(P_I_V_DN_VENTILATION, 0);
    ELSE
      IF (P_I_V_DN_VENTILATION IS NOT NULL AND L_N_DN_VENTILATION IS NULL)
         OR
         (P_I_V_DN_VENTILATION IS NULL AND L_N_DN_VENTILATION IS NOT NULL) THEN
        L_N_DN_VENTILATION := 0;
      ELSE
        L_N_DN_VENTILATION := NULL;
      END IF;

    END IF;

    L_V_SQL_ID := 'SQL00S17';
    IF (NVL(TO_NUMBER(P_I_V_WEIGHT), 0) <> NVL(L_N_GROSSWT, 0)) THEN
      L_N_GROSSWT := NVL(P_I_V_WEIGHT, 0);
    ELSE
 /*-- *35 by watcharee C.
      IF (P_I_V_WEIGHT IS NOT NULL AND L_N_GROSSWT IS NULL)
         OR (P_I_V_WEIGHT IS NULL AND L_N_GROSSWT IS NOT NULL) THEN
        L_N_GROSSWT := 0;
      ELSE
        L_N_GROSSWT := NULL;
      END IF;
--*/
      L_N_GROSSWT := NULL;
    END IF;

    L_V_SQL_ID := 'SQL00S18';
    
    --START *36 
    IF (NVL(P_I_V_CATEGORY, '~') <> NVL(V_CATEGORY_CODE, '~')) THEN
      V_CATEGORY_CODE := NVL(P_I_V_CATEGORY, '~');
    ELSE
      V_CATEGORY_CODE := NULL;
    END IF;
    --END *36 
    
    L_V_SQL_ID := 'SQL00S19';
    
    --START *36 
--    IF (NVL(P_I_V_VGM, '~') <> NVL(V_VGM, '~')) THEN
--      V_VGM := NVL(P_I_V_VGM, '~');
--    ELSE
--      V_VGM := NULL;
--    END IF;
    IF (NVL(P_I_V_VGM, 0) <> NVL(V_VGM, 0)) THEN
      V_VGM := NVL(P_I_V_VGM, 0);
    ELSE
      V_VGM := NULL;
    END IF;
    --END *36     
    
    L_V_SQL_ID := 'SQL00S20';
    PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_EQUIPMENT_UPDATE(P_I_V_FK_BOOKING_NO,
                                                       P_I_V_CONTAINER_SEQ_NO,
                                                       L_V_EQUIPNO,
                                                       L_N_OVERHEIGHT,
                                                       L_N_OVERLENGTHREAR,
                                                       L_N_OVERLENGTHFRONT,
                                                       L_N_OVERWIDTHLEFT,
                                                       L_N_OVERWIDTHRIGHT,
                                                       L_V_IMDG,
                                                       L_V_UNNO,
                                                       L_V_UNVAR,
                                                       L_V_FLASHPOINT,
                                                       L_V_FLASHUNIT,
                                                       L_V_REEFERTMP,
                                                       L_V_REEFERTMPUNIT,
                                                       L_N_HUMIDITY,
                                                       L_N_GROSSWT,
                                                       L_N_DN_VENTILATION,
                                                       V_CATEGORY_CODE, --*36 --NULL, --*33
                                                       V_VGM, --*36
                                                    --   NULL,
                                                       P_O_V_ERR_CD);
    DBMS_OUTPUT.PUT_LINE('p_o_v_err_cd ' || P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD = '0') THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    ELSE
      /* Error in Synchronization Equipment Update */
      P_O_V_ERR_CD := 'EDL.SE0179';
      RETURN;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      L_V_ERR_DESC := SUBSTR(SQLERRM, 1, 100);
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER_STR,
                                                       'DLSYNC',
                                                       'T',
                                                       L_V_SQL_ID || '~' ||
                                                       L_V_ERR_DESC,
                                                       'A',
                                                       'EZLL',
                                                       CURRENT_TIMESTAMP,
                                                       'EZLL',
                                                       CURRENT_TIMESTAMP);
      COMMIT;

      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_SYNCH_BOOKING;

  PROCEDURE PRE_EDL_SAVE_DL_STATUS(P_I_V_DISCHARGE_LIST_ID     VARCHAR2
                                  ,P_I_V_DISCHARGE_LIST_STATUS VARCHAR2
                                  ,P_I_V_USER_ID               VARCHAR2
                                  ,P_I_V_DATE                  VARCHAR2
                                  ,P_I_V_SESSION_ID            VARCHAR2 -- *24
                                  ,P_O_V_ERR_CD                OUT VARCHAR2) AS
    L_V_LOCK_DATA VARCHAR2(14);
    L_V_DL_STATUS VARCHAR2(2);
    EXP_ERROR_ON_SAVE EXCEPTION;
    L_O_V_BOOKING VARCHAR2(4000) DEFAULT NULL; -- *17
    V_SERVICE     VARCHAR2(5);
    V_VESSEL      VARCHAR2(5);
    V_VOYAGE      VARCHAR2(10);
    V_PORT        VARCHAR2(5);
    V_TERMINAL    VARCHAR2(5);
    V_PCSQ        NUMBER(12);
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    -- Get lock on the table.

    /* perform validations for discharge list status update */
    PRE_EDL_DL_STATUS_VALIDATION(P_I_V_DISCHARGE_LIST_ID,
                                 P_I_V_DISCHARGE_LIST_STATUS,
                                 P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    BEGIN
      SELECT DISCHARGE_LIST_STATUS
            ,FK_SERVICE
            ,FK_VESSEL
            ,FK_VOYAGE
            ,DN_PORT
            ,DN_TERMINAL
            ,FK_PORT_SEQUENCE_NO
        INTO L_V_DL_STATUS
            ,V_SERVICE
            ,V_VESSEL
            ,V_VOYAGE
            ,V_PORT
            ,V_TERMINAL
            ,V_PCSQ
        FROM TOS_DL_DISCHARGE_LIST
       WHERE PK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
         FOR UPDATE NOWAIT;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;

        RETURN;
      WHEN OTHERS THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                        PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        SUBSTR(SQLCODE, 1, 10) || ':' ||
                        SUBSTR(SQLERRM, 1, 100);
        RETURN;
    END;

    -- Validate EZDL status cannot change from Discharge Complate to other status if Arrival/Departure complete
    IF L_V_DL_STATUS = WORK_COMPLETE
       AND P_I_V_DISCHARGE_LIST_STATUS <> WORK_COMPLETE THEN
      VASAPPS.PCR_ELL_EDL_VALIDATE.PRR_EDL_ARR_DEP_VALIDATE(P_O_V_ERR_CD,
                                                            V_SERVICE,
                                                            V_VESSEL,
                                                            V_VOYAGE,
                                                            V_PCSQ,
                                                            V_PORT,
                                                            V_TERMINAL);

      IF P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
        RETURN;
      END IF;
    END IF;

    /* Start Commented by vikas, as k'chatgamol say, 11.11.2011,
    k'chatgamol will again confirm the logic after then
    call ems activity */ -- *13

    /* If Discharge List Status value is changed from a lower value to a higher value*/
    IF ((L_V_DL_STATUS = C_OPEN OR L_V_DL_STATUS = ALERT_REQUIRED) AND
       (P_I_V_DISCHARGE_LIST_STATUS = DISCHARGE_COMPLETE OR
       P_I_V_DISCHARGE_LIST_STATUS = READY_FOR_INVOICE OR
       P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE)) THEN

      /* *24 start * */

      /* *26 start * */
      L_O_V_BOOKING := NULL;
      PRE_BUNDLE_UPDATE_VALIDATION(P_I_V_DISCHARGE_LIST_ID,
                                   LL_DL_FLAG,
                                   L_O_V_BOOKING);
      IF (L_O_V_BOOKING IS NOT NULL) THEN
        P_O_V_ERR_CD := 'EDL.SE0190' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        L_O_V_BOOKING || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
      L_O_V_BOOKING := NULL;
      /* *26 end * */
      /* * check duplicate cell location exists or not * */
      PRE_CHECK_DUP_CELL_LOCATION(P_I_V_SESSION_ID,
                                  DISCHARGE_LIST,
                                  P_I_V_DISCHARGE_LIST_ID,
                                  P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;
      /* *24 end * */

      PCE_ECM_EMS.PRE_INSERT_EMS_LL_DL(LL_DL_FLAG,
                                       '',
                                       TO_NUMBER(P_I_V_DISCHARGE_LIST_ID),
                                       P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD = '0') THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      ELSE
        /* Error in EMS calling */
        P_O_V_ERR_CD := 'EDL.SE0181';
        RETURN;
      END IF;
    END IF;
    /* End  Commented by vikas, as k'chatgamol say, 11.11.2011 */ -- *13

    /*
        *16: Changes start
    */
    --*comment by *34 begin
--    BEGIN
--      IF (P_I_V_DISCHARGE_LIST_STATUS = DISCHARGE_COMPLETE OR
--         P_I_V_DISCHARGE_LIST_STATUS = READY_FOR_INVOICE OR
--         P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE) THEN
--
--        UPDATE TOS_DL_DISCHARGE_LIST
--           SET FIRST_COMPLETE_USER = P_I_V_USER_ID
--              ,FIRST_COMPLETE_DATE = TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
--         WHERE PK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
--           AND FIRST_COMPLETE_USER IS NULL
--           AND FIRST_COMPLETE_DATE IS NULL;
--
--        /*
--        INSERT INTO TOS_DL_DISCHARGE_LIST_HIS(
--              PK_DISCHARGE_LIST_ID
--            , DN_SERVICE_GROUP_CODE
--            , FK_SERVICE
--            , FK_VESSEL
--            , FK_VOYAGE
--            , FK_DIRECTION
--            , FK_PORT_SEQUENCE_NO
--            , FK_VERSION
--            , DN_PORT
--            , DN_TERMINAL
--            , DISCHARGE_LIST_STATUS
--            , RECORD_STATUS
--            , RECORD_ADD_USER
--            , RECORD_ADD_DATE
--            , RECORD_CHANGE_USER
--            , RECORD_CHANGE_DATE
--        ) SELECT
--              PK_DISCHARGE_LIST_ID
--            , DN_SERVICE_GROUP_CODE
--            , FK_SERVICE
--            , FK_VESSEL
--            , FK_VOYAGE
--            , FK_DIRECTION
--            , FK_PORT_SEQUENCE_NO
--            , FK_VERSION
--            , DN_PORT
--            , DN_TERMINAL
--            , DISCHARGE_LIST_STATUS
--            , RECORD_STATUS
--            , RECORD_ADD_USER
--            , RECORD_ADD_DATE
--            , RECORD_CHANGE_USER
--            , RECORD_CHANGE_DATE
--        FROM
--            TOS_DL_DISCHARGE_LIST
--        WHERE
--            PK_DISCHARGE_LIST_ID  = p_i_v_discharge_list_id;
--        */
--      END IF;
--    EXCEPTION
--      WHEN OTHERS THEN
--        NULL;
--    END;
    --end coment by *34
    /*
        *16: Changes end
        *17: Start
    */
    IF (P_I_V_DISCHARGE_LIST_STATUS = READY_FOR_INVOICE OR
       P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE) THEN
      PRE_LIST_OPEN_BOOOKINGS(P_I_V_DISCHARGE_LIST_ID,
                              LL_DL_FLAG,
                              L_O_V_BOOKING);
    --#32 BEGIN
      /*
      IF (L_O_V_BOOKING IS NOT NULL) THEN
        P_O_V_ERR_CD := 'EDL.SE0189' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        L_O_V_BOOKING || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
      */
      --#32 END
    END IF;
    /*
        *17: end
    */

    -- *31 start
    IF P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE THEN
      -- Validate EMS Activity
      VASAPPS.PCR_ELL_EDL_VALIDATE.PRR_EDL_EMS_VALIDATE(P_O_V_ERR_CD,
                                                        P_I_V_DISCHARGE_LIST_ID,
                                                        P_I_V_USER_ID);
      IF P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
        RETURN;
      END IF;
    END IF;
    -- *31 end



    -- Update discharge list status in the database table.
    UPDATE TOS_DL_DISCHARGE_LIST
       SET DISCHARGE_LIST_STATUS = P_I_V_DISCHARGE_LIST_STATUS
          ,RECORD_CHANGE_USER    = P_I_V_USER_ID
          ,RECORD_CHANGE_DATE    = TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
     WHERE PK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID;
      --*34 begin
       BEGIN
    --*34  IF (P_I_V_DISCHARGE_LIST_STATUS = DISCHARGE_COMPLETE OR  P_I_V_DISCHARGE_LIST_STATUS = READY_FOR_INVOICE OR P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE) THEN
       IF ((L_V_DL_STATUS = C_OPEN AND P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE)
            OR
           (L_V_DL_STATUS = DISCHARGE_COMPLETE AND P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE)
           )
       THEN
        UPDATE TOS_DL_DISCHARGE_LIST
           SET FIRST_COMPLETE_USER = P_I_V_USER_ID
              ,FIRST_COMPLETE_DATE = TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
         WHERE PK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
           AND FIRST_COMPLETE_USER IS NULL
           AND FIRST_COMPLETE_DATE IS NULL;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;  --*34 end

  EXCEPTION
    WHEN EXP_ERROR_ON_SAVE THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);

      RETURN;
      --  RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);

      RETURN;
      -- RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
  END PRE_EDL_SAVE_DL_STATUS;

  PROCEDURE PRE_EDL_DL_STATUS_VALIDATION(P_I_V_DISCHARGE_LIST_ID     VARCHAR2
                                        ,P_I_V_DISCHARGE_LIST_STATUS VARCHAR2
                                        ,P_O_V_ERR_CD                OUT VARCHAR2) AS
    L_V_REC_COUNT NUMBER := 0;
    L_V_ERRORS    VARCHAR2(2000);
    L_V_SERVICE   TOS_DL_DISCHARGE_LIST.FK_SERVICE%TYPE; -- *6

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF ((P_I_V_DISCHARGE_LIST_STATUS = DISCHARGE_COMPLETE) OR
       (P_I_V_DISCHARGE_LIST_STATUS = READY_FOR_INVOICE) OR
       (P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE)) THEN
      SELECT COUNT(1)
        INTO L_V_REC_COUNT
        FROM TOS_DL_BOOKED_DISCHARGE
       WHERE DISCHARGE_STATUS = 'BK'
         AND FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
         AND RECORD_STATUS = 'A'; -- added 20.12.2011
    END IF;

    IF (L_V_REC_COUNT > 0) THEN
      --Then throw error message Container with discharge status Booked exists.
      P_O_V_ERR_CD := 'EDL.SE0124';
      RETURN;
    END IF;

    IF (P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE) THEN
      SELECT COUNT(1)
        INTO L_V_REC_COUNT
        FROM TOS_DL_BOOKED_DISCHARGE
       WHERE DISCHARGE_STATUS IN ('SL')
       -- START *36, IF IT IS SHIPPMENT TYPE UC (SIZE = 0,TYPE=**) WILL ALLOW TO COMPLETE.
         AND DN_EQ_SIZE <> 0 
         AND DN_EQ_TYPE <> '**' 
      -- END *36        
         AND FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
         AND RECORD_STATUS = 'A'; -- added 20.12.2011

      IF (L_V_REC_COUNT > 0) THEN
        --          Then throw error message Container with discharge status Short shipped exists
        P_O_V_ERR_CD := 'EDL.SE0120';
        RETURN;
      END IF;

      SELECT COUNT(1)
        INTO L_V_REC_COUNT
        FROM TOS_DL_OVERLANDED_CONTAINER
       WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
         AND RECORD_STATUS = 'A'; -- added 20.12.2011

      IF (L_V_REC_COUNT > 0) THEN
        --          Then throw error message Container with discharge status Overlanded exists
        P_O_V_ERR_CD := 'EDL.SE0119';
        RETURN;
      END IF;
    END IF;

    /*
        *6: Changes start
    */
    SELECT NVL(LOWER(FK_SERVICE), '*')
      INTO L_V_SERVICE
      FROM TOS_DL_DISCHARGE_LIST
     WHERE PK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID;
    /*
        *6: Changes End
    */

    /*
        *4: changes start
    */

    IF L_V_SERVICE <> 'afs'
       AND L_V_SERVICE <> 'dfs' THEN
      -- *6

      IF ((P_I_V_DISCHARGE_LIST_STATUS = DISCHARGE_COMPLETE) OR
         (P_I_V_DISCHARGE_LIST_STATUS = READY_FOR_INVOICE) OR
         (P_I_V_DISCHARGE_LIST_STATUS = WORK_COMPLETE)) THEN

        SELECT COUNT(1)
          INTO L_V_REC_COUNT
          FROM TOS_DL_BOOKED_DISCHARGE
         WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
           AND RECORD_STATUS = 'A'
           AND STOWAGE_POSITION IS NULL
           AND DISCHARGE_STATUS <> 'SL'; -- *8

        IF (L_V_REC_COUNT > 0) THEN
          -- Then throw error message Blank stowage position exists.
          P_O_V_ERR_CD := 'EDL.SE0186';
          RETURN;
        END IF;
      END IF;

    END IF; -- *6

    /*
        *4: Changes end
    */
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);

    -- RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
  END PRE_EDL_DL_STATUS_VALIDATION;

  PROCEDURE PCV_EDL_RECORD_LOCK(P_I_V_ID       VARCHAR2
                               ,P_I_V_REC_DT   VARCHAR2
                               ,P_I_V_TAB_NAME VARCHAR2
                               ,P_O_V_ERR_CD   OUT VARCHAR2)

   AS
    L_V_LOCK_DATA VARCHAR2(14);
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    -- get lock on the table.
    IF (P_I_V_TAB_NAME = 'BOOKED') THEN

      SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
        INTO L_V_LOCK_DATA
        FROM TOS_DL_BOOKED_DISCHARGE
       WHERE PK_BOOKED_DISCHARGE_ID = P_I_V_ID
         FOR UPDATE NOWAIT;

    ELSIF (P_I_V_TAB_NAME = 'OVERLANDED') THEN

      SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
        INTO L_V_LOCK_DATA
        FROM TOS_DL_OVERLANDED_CONTAINER
       WHERE PK_OVERLANDED_CONTAINER_ID = P_I_V_ID
         FOR UPDATE NOWAIT;

    ELSIF (P_I_V_TAB_NAME = 'RESTOWED') THEN

      SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
        INTO L_V_LOCK_DATA
        FROM TOS_RESTOW
       WHERE PK_RESTOW_ID = P_I_V_ID
         FOR UPDATE NOWAIT;

    ELSE

      P_O_V_ERR_CD := 'ILLEGAL ARGUMENT';
      RETURN;
    END IF;

    IF (P_I_V_REC_DT IS NOT NULL) THEN

      IF (L_V_LOCK_DATA <> P_I_V_REC_DT) THEN
        -- Record updated by another user.

        -- p_o_v_err_cd :=  PCE_EUT_COMMON.G_V_GE0006 ;  -- *3
        -- RETURN; -- *3
        NULL; -- *3
      END IF;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --  PCE_EUT_COMMON.G_V_GE0005 : Record Deleted by Another User
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;

      RETURN;
      --        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0002;

      RETURN;
      --        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
  END PCV_EDL_RECORD_LOCK;

  /*
          Start commented by vikas, no need for this logic, 16.12.2011

  /*     Validate UN Number and UN Number Variant for discharge list overlanded tab
      from DG_UNNO_CLASS_RESTRICTIONS.UNNO and DG_UNNO_CLASS_RESTRICTIONS.VARIANT
      If validation fails, show error message: Invalid UN Number.
  *

      PROCEDURE PRE_EDL_OL_VAL_UNNO(
            p_i_v_unno         IN VARCHAR2
          , p_i_v_variant      IN  VARCHAR2
          , p_i_v_equipment_no IN  VARCHAR2
          , p_o_v_err_cd      OUT VARCHAR2
      ) AS
      l_rec_count       NUMBER := 0;
      BEGIN
          p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      IF p_i_v_unno IS NOT NULL AND p_i_v_variant IS NOT NULL THEN
          SELECT COUNT(1)
          INTO
          l_rec_count
          FROM DG_UNNO_CLASS_RESTRICTIONS
          WHERE UNNO = p_i_v_unno
          AND VARIANT = p_i_v_variant;

          IF(l_rec_count < 1) THEN
              p_o_v_err_cd := 'EDL.SE0118' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
              RETURN;
          END IF;
      END IF;

      EXCEPTION
      WHEN OTHERS THEN
          p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
      END PRE_EDL_OL_VAL_UNNO;
      /*
          End commented by vikas, 16.12.2011
      */

  /*
    Check the value of Vessel Owner.
    If Vessel Owner value = Owner (O) or Charter(S) in table ITP060.VSPOWN
    If Stow Position is null, then throw error message: Stow Position value can not be null
  */
  PROCEDURE GET_VESSEL_OWNER_DTL(P_I_V_HDR_VESSEL VARCHAR2
                                ,P_I_V_OWNER_DTL  OUT VARCHAR2
                                ,P_I_V_VESSEL_NM  OUT VARCHAR2
                                ,P_O_V_ERR_CD     OUT VARCHAR2) AS
  BEGIN
    P_O_V_ERR_CD    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_I_V_OWNER_DTL := '';
    P_I_V_VESSEL_NM := '';

    SELECT VSLGNM VS_NAME
          ,VSPOWN VS_OWNER
      INTO P_I_V_VESSEL_NM
          ,P_I_V_OWNER_DTL
      FROM ITP060
     WHERE VSVESS = P_I_V_HDR_VESSEL;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0004;
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END GET_VESSEL_OWNER_DTL;

  /*
      Start commented by vikas, no need for this logic, 16.12.2011
  */

  /*
      Validate Port Class Type if no data found then show error message: Invalid Port Class.
  *
      PROCEDURE PRE_EDL_OL_VAL_PORT_CLASS(
        p_i_v_port_code              VARCHAR2
          , p_i_v_unno               VARCHAR2
          , p_i_v_variant            VARCHAR2
          , p_i_v_imdg_class         VARCHAR2
          , p_i_v_port_class         VARCHAR2
          , p_i_v_port_class_type    VARCHAR2
          , p_i_v_equipment_no     IN VARCHAR2
          , p_o_v_err_cd             OUT VARCHAR2
      ) AS

      l_rec_count        NUMBER := 0;
      BEGIN
          p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      IF p_i_v_unno IS NOT NULL OR
         p_i_v_variant IS NOT NULL OR
         p_i_v_imdg_class IS NOT NULL THEN

          SELECT COUNT(1)
          INTO l_rec_count
          FROM PORT_CLASS_TYPE PCT, PORT_CLASS PC
          WHERE PCT.PORT_CODE=p_i_v_port_code
          AND PC.PORT_CLASS_TYPE = PCT.PORT_CLASS_TYPE
          AND PC.UNNO = p_i_v_unno
          AND PC.VARIANT = p_i_v_variant
          AND PC.IMDG_CLASS = p_i_v_imdg_class
          AND PC.PORT_CLASS_CODE = p_i_v_port_class
          AND PC.PORT_CLASS_TYPE = p_i_v_port_class_type;

          IF(l_rec_count < 1) THEN
              p_o_v_err_cd := 'EDL.SE0113' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
          RETURN;
          END IF;
      END IF;

      EXCEPTION
          WHEN OTHERS THEN
          p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
      END PRE_EDL_OL_VAL_PORT_CLASS;


      /* Check for the IMDG Code in IMDG Master Table. *
      PROCEDURE PRE_EDL_OL_VAL_IMDG(
            p_i_v_unno        IN VARCHAR2
          , p_i_v_variant     IN VARCHAR2
          , p_i_v_imdg        IN VARCHAR2
          , p_i_v_equipment_no IN  VARCHAR2
          , p_o_v_err_cd      OUT VARCHAR2
      ) AS
      l_rec_count                NUMBER := 0;
      BEGIN
          p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      IF p_i_v_unno IS NOT NULL OR p_i_v_variant IS NOT NULL OR p_i_v_imdg IS NOT NULL THEN
          SELECT COUNT(1)
          INTO
          l_rec_count
          FROM DG_UNNO_CLASS_RESTRICTIONS
          WHERE UNNO         = p_i_v_unno
          AND VARIANT     = p_i_v_variant
          AND IMDG_CLASS     = p_i_v_imdg;

          IF(l_rec_count < 1) THEN
              p_o_v_err_cd := 'EDL.SE0114' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
              RETURN;
          END IF;
      END IF;
      EXCEPTION
          WHEN OTHERS THEN
          p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
      END PRE_EDL_OL_VAL_IMDG;

      /*
          End commented by vikas, 16.12.2011
      */

  /*    Handling Instruction Code validation */
  PROCEDURE PRE_EDL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE     IN VARCHAR2
                                    ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                    ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF P_I_V_SHI_CODE IS NOT NULL THEN

      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM SHP007
       WHERE SHI_CODE = P_I_V_SHI_CODE
         AND RECORD_STATUS = 'A';

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'EDL.SE0115' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_OL_VAL_HAND_CODE;

  /*    Check for the Equipment Type in Master Table. */
  PROCEDURE PRE_EDL_VAL_EQUIPMENT_TYPE(P_I_V_OPER_CD      IN VARCHAR2
                                      ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                      ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF P_I_V_OPER_CD IS NOT NULL THEN

      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM ITP075
       WHERE TRTYPE = P_I_V_OPER_CD
         AND TRRCST = 'A';

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'EDL.SE0151' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_VAL_EQUIPMENT_TYPE;

  /*    Check for the Container Operator in OPERATOR_CODE Master Table. */
  PROCEDURE PRE_EDL_OL_VAL_OPERATOR_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                        ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                        ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF P_I_V_OPER_CD IS NOT NULL THEN
      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM OPERATOR_CODE_MASTER
       WHERE OPERATOR_CODE = P_I_V_OPER_CD;

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'EDL.SE0117' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_OL_VAL_OPERATOR_CODE;

  /*    Check for the Port Code Master Table. */
  PROCEDURE PRE_EDL_VAL_PORT_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                 ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                 ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF P_I_V_OPER_CD IS NOT NULL THEN
      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM ITP040
       WHERE PICODE = P_I_V_OPER_CD
         AND PIRCST = 'A';

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'EDL.SE0153' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_VAL_PORT_CODE;

  /*    Check for the Port Code Master Table. */
  PROCEDURE PRE_EDL_VAL_PORT_TERMINAL_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                          ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF P_I_V_OPER_CD IS NOT NULL THEN
      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM ITP130
       WHERE TQTERM = P_I_V_OPER_CD
         AND TQRCST = 'A';

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'EDL.SE0158' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_VAL_PORT_TERMINAL_CODE;

  /* Check for the Container Loading Remark Code in dolphin master table. */
  PROCEDURE PRE_EDL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE     IN VARCHAR2
                                   ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                   ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF P_I_V_CLR_CODE IS NOT NULL THEN
      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM SHP041
       WHERE CLR_CODE = P_I_V_CLR_CODE
         AND RECORD_STATUS = 'A';

      IF (L_REC_COUNT < 1) THEN
        /*Invalid Container Loading Remark code*/
        P_O_V_ERR_CD := 'EDL.SE0116' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_OL_VAL_CLR_CODE;

  PROCEDURE PRE_DL_COMMON_MATCHING(P_I_V_MATCH_TYPE              VARCHAR2
                                  ,P_I_V_DISCHARGE_LIST_ID       NUMBER
                                  ,P_I_V_DL_CONTAINER_SEQ        NUMBER
                                  ,P_I_V_OVERLANDED_CONTAINER_ID NUMBER
                                  ,P_I_V_EQUIPMENT_NO            VARCHAR2
                                  ,P_O_V_ERR_CD                  OUT NOCOPY VARCHAR2) AS
    P_O_V_RETURN_STATUS NUMBER;
    L_V_REC_COUNT       NUMBER := 0;
    L_EXP_FINISH EXCEPTION;
    L_V_EQUIPMENT_NO TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE;
  BEGIN
    P_O_V_ERR_CD        := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_RETURN_STATUS := '';

    /* Check if the containter equipment no# is alredy available in
    booked tab or not. */

    /*
    SELECT COUNT(1)
    INTO l_v_rec_count
    FROM TOS_DL_BOOKED_DISCHARGE
    WHERE FK_DISCHARGE_LIST_ID = p_i_v_discharge_list_id
    AND  RECORD_STATUS = 'A'
    AND DN_EQUIPMENT_NO = p_i_v_equipment_no;
    */

    BEGIN
      SELECT COUNT(1)
            ,DN_EQUIPMENT_NO
        INTO L_V_REC_COUNT
            ,L_V_EQUIPMENT_NO
        FROM TOS_DL_BOOKED_DISCHARGE
       WHERE FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
         AND RECORD_STATUS = 'A'
         AND DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       GROUP BY DN_EQUIPMENT_NO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        L_V_EQUIPMENT_NO := NULL;
        L_V_REC_COUNT    := 0;
    END;

    IF ((L_V_REC_COUNT > 0) AND
       (NVL(L_V_EQUIPMENT_NO, '*') <> P_I_V_EQUIPMENT_NO)) THEN
      /* Overlanded Equipment no# is already available in booked tab,
      show error message. "Equipment alredy exists in booked tab.." */
      P_O_V_ERR_CD := 'EDL.SE0182';
      RAISE L_EXP_FINISH;
    END IF;

    /* Call PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING for Automatch */
    IF (P_I_V_MATCH_TYPE = 'A') THEN
      PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING(P_I_V_MATCH_TYPE,
                                               'DL',
                                               P_I_V_DISCHARGE_LIST_ID,
                                               P_I_V_DL_CONTAINER_SEQ,
                                               P_I_V_OVERLANDED_CONTAINER_ID,
                                               '',
                                               '',
                                               '',
                                               P_O_V_RETURN_STATUS);
    ELSE
      /* Call PCE_ECM_EDI.PRE_TOS_LLDL_MANUAL_MATCHING for Manual Match */
      PCE_ECM_EDI.PRE_TOS_LLDL_MANUAL_MATCHING(P_I_V_MATCH_TYPE,
                                               'DL',
                                               P_I_V_DISCHARGE_LIST_ID,
                                               P_I_V_DL_CONTAINER_SEQ,
                                               P_I_V_OVERLANDED_CONTAINER_ID,
                                               '',
                                               '',
                                               '',
                                               P_O_V_RETURN_STATUS);
    END IF;

    IF (P_O_V_RETURN_STATUS != '0') THEN
      P_O_V_ERR_CD := 'EDL.SE0129';
      RAISE L_EXP_FINISH;
    END IF;

  EXCEPTION
    WHEN L_EXP_FINISH THEN
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
  END PRE_DL_COMMON_MATCHING;

  PROCEDURE PRE_DL_CONT_REMARK_COMBO(P_O_REFCOMBODATA OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,P_O_V_ERR_CD     OUT NOCOPY VARCHAR2) AS
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    OPEN P_O_REFCOMBODATA FOR
      SELECT CLR_CODE
            ,CLR_DESC
        FROM SHP041
       WHERE RECORD_STATUS = 'A';

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRE_DL_CONT_REMARK_COMBO;

  /*    Check for the shipment term */
  PROCEDURE PRE_SHIPMENT_TERM_OL_CODE(P_I_V_SHIPMNT_CD   VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                     ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF P_I_V_SHIPMNT_CD IS NOT NULL THEN
      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM ITP070
       WHERE MMMODE = P_I_V_SHIPMNT_CD;

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'EDL.SE0128' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_SHIPMENT_TERM_OL_CODE;

  /**
  * @ PRE_EDL_ETA_DATE_TIME
  * Purpose : Return ETA date And time.
  * @param  : Service
  * @param  : Vessel
  * @param  : In Voyage
  * @param  : Port
  * @param  : Port Sequence no.
  * @param  : Direction
  * @param  : ETA Date            OUTPUT
  * @param  : ETA Time            OUTPUT
  * @param  : Error Code            OUTPUT
  * @RETURN Returns true when first date is less then second date.
  */
  PROCEDURE PRE_EDL_ETA_DATE_TIME(P_I_V_SERVICE       VARCHAR2
                                 ,P_I_V_VESSEL        VARCHAR2
                                 ,P_I_V_INVOYAGE      VARCHAR2
                                 ,P_I_V_PORT          VARCHAR2
                                 ,P_I_V_PORT_SEQUENCE NUMBER
                                 ,P_I_V_DIRECTION     VARCHAR2
                                 ,P_O_V_DATE          OUT VARCHAR2
                                 ,P_O_V_TIME          OUT VARCHAR2
                                 ,P_O_V_ERR_CD        OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT VVARDT
          ,VVARTM
      INTO P_O_V_DATE
          ,P_O_V_TIME
      FROM ITP063
     WHERE VVVERS = 99
       AND VVVESS = P_I_V_VESSEL
       AND DECODE(P_I_V_SERVICE, 'AFS', VVVOYN, INVOYAGENO) =
           P_I_V_INVOYAGE
       AND VVPCAL = P_I_V_PORT
       AND VVSRVC = P_I_V_SERVICE
       AND VVPCSQ = P_I_V_PORT_SEQUENCE
       AND VVPDIR = P_I_V_DIRECTION;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRE_EDL_ETA_DATE_TIME;

  /**
  * @ FN_EDL_DATE_COMPARE
  * Purpose : Convert String into date and then compare two dates
  * @param  : First Date of type String
  * @param  : First Time of type String
  * @param  : Second Date of type String
  * @param  : Second Time of type String
  * @param  : Port name of type String
  * @RETURN Returns 0 when first date is less then second date.
  */
  FUNCTION FN_EDL_DATE_COMPARE(P_I_V_DATE1 VARCHAR2
                              ,P_I_V_TIME1 VARCHAR2
                              ,P_I_V_DATE2 VARCHAR2
                              ,P_I_V_TIME2 VARCHAR2
                              ,P_I_V_PORT  VARCHAR2) RETURN NUMBER IS
    L_V_DATE1    DATE;
    L_V_DATE2    DATE;
    P_O_V_ERR_CD VARCHAR2(100);
  BEGIN

    SELECT FN_EDL_CONVERTDATE(P_I_V_DATE1, P_I_V_TIME1, P_I_V_PORT)
          ,FN_EDL_CONVERTDATE(P_I_V_DATE2, P_I_V_TIME2, P_I_V_PORT)
      INTO L_V_DATE1
          ,L_V_DATE2
      FROM DUAL;

    L_V_DATE2 := FN_EDL_CONVERTDATE(P_I_V_DATE2, P_I_V_TIME2, P_I_V_PORT);

    IF (L_V_DATE1 < L_V_DATE2) THEN
      RETURN 0;
    ELSE
      RETURN - 1;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      -- p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);

      RETURN - 1;
  END;

  /**
  * @ FN_EDL_CONVERTDATE
  * Purpose : Converts a String date and time into globle time format date.
  * @param  : Date of type String
  * @param  : Time of type String
  * @param  : Port name of type String
  * @RETURN Returns Date
  */
  FUNCTION FN_EDL_CONVERTDATE(P_I_V_DATE VARCHAR2
                             ,P_I_V_TIME VARCHAR2
                             ,P_I_V_PORT VARCHAR2) RETURN DATE IS
    L_V_DATE DATE := NULL;
  BEGIN

    SELECT (TO_DATE(P_I_V_DATE, 'RRRRMMDD') +
           (1 / 1440 *
           (MOD(P_I_V_TIME, 100) + FLOOR(P_I_V_TIME / 100) * 60)) -
           (1 / 1440 * (MOD(P.PIVGMT, 100) + FLOOR(P.PIVGMT / 100) * 60)))
      INTO L_V_DATE
      FROM ITP040 P
     WHERE PICODE = P_I_V_PORT;

    RETURN L_V_DATE;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN L_V_DATE;
  END;
  /* Start added by vikas, new logic give by k'Chatgamol, 22.11.2011 */
  PROCEDURE PRE_PREV_LOAD_LIST_ID(P_I_V_BOOKING_NO    VARCHAR2
                                 ,P_I_V_EQUIP_NO      VARCHAR2
                                 ,P_I_V_TERMINAL      VARCHAR2 -- dn_pol_terminal
                                 ,P_I_V_PORT          VARCHAR2 -- dn_pol
                                 ,P_O_V_BOOKED_DIS_ID OUT VARCHAR2
                                 ,P_O_V_FLAG          OUT VARCHAR2
                                 ,P_O_V_ERR_CD        OUT VARCHAR2) AS
  BEGIN

    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT PK_LOADING_ID
          ,FLAG
      INTO P_O_V_BOOKED_DIS_ID
          ,P_O_V_FLAG
      FROM (SELECT BL.PK_BOOKED_LOADING_ID PK_LOADING_ID
                  ,'D' FLAG
              FROM VASAPPS.TOS_LL_BOOKED_LOADING BL
                  ,VASAPPS.TOS_LL_LOAD_LIST      DL
             WHERE DL.PK_LOAD_LIST_ID = BL.FK_LOAD_LIST_ID
               AND DL.DN_PORT = P_I_V_PORT
               AND DL.DN_TERMINAL = P_I_V_TERMINAL
               AND BL.FK_BOOKING_NO = P_I_V_BOOKING_NO
               AND BL.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO

            UNION ALL

            SELECT TR.PK_RESTOW_ID PK_LOADING_ID
                  ,'R' FLAG
              FROM VASAPPS.TOS_RESTOW       TR
                  ,VASAPPS.TOS_LL_LOAD_LIST DL
             WHERE DL.PK_LOAD_LIST_ID = TR.FK_LOAD_LIST_ID
               AND DL.DN_PORT = P_I_V_PORT
               AND DL.DN_TERMINAL = P_I_V_TERMINAL
               AND TR.FK_BOOKING_NO = P_I_V_BOOKING_NO
               AND TR.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO)
     WHERE ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('p_o_v_booked_dis_id: ' || P_O_V_BOOKED_DIS_ID);
    DBMS_OUTPUT.PUT_LINE('p_o_v_flag: ' || P_O_V_FLAG);

  EXCEPTION

    WHEN NO_DATA_FOUND THEN
      NULL; --*3
    -- p_o_v_booked_dis_id       :=  NULL;          -- *3
    -- p_o_v_flag                :=  NULL;          -- *3
    -- p_o_v_err_cd              :=  'ELL.SE0121';  -- *3
    -- RETURN;                                      -- *3

    WHEN OTHERS THEN
      NULL; --*3
    -- p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100); -- *3
    -- RETURN;                                                               -- *3

  END PRE_PREV_LOAD_LIST_ID;

  /* End added by vikas, 22.11.2011 */

  PROCEDURE PRE_EDL_PREV_LOAD_LIST_ID(P_I_V_VESSEL        VARCHAR2
                                     ,P_I_V_EQUIP_NO      VARCHAR2
                                     ,P_I_V_BOOKING_NO    VARCHAR2
                                     ,P_I_V_ETA_DATE      VARCHAR2 -- DD/MM/YYYY
                                     ,P_I_V_ETA_TM        VARCHAR2
                                     ,P_I_PORT_CODE       VARCHAR2
                                     ,P_I_V_PORT_SEQ      VARCHAR2
                                     ,P_O_V_PK_LOADING_ID OUT VARCHAR2
                                     ,P_O_V_FLAG          OUT VARCHAR2
                                     ,P_O_V_ERR_CD        OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT PK_LOADING_ID
          ,FLAG
      INTO P_O_V_PK_LOADING_ID
          ,P_O_V_FLAG
      FROM (SELECT PK_LOADING_ID
                  ,FLAG
                  ,ROW_NUMBER() OVER(ORDER BY ACTIVITY_DATE_TIME DESC NULLS LAST) SRNO -- *28
              FROM (SELECT LLB.PK_BOOKED_LOADING_ID PK_LOADING_ID
                          ,'D' FLAG
                          ,ACTIVITY_DATE_TIME
                      FROM TOS_LL_LOAD_LIST      LL
                          ,TOS_LL_BOOKED_LOADING LLB
                          ,ITP063                ITP
                          ,ITP040                P
                     WHERE LL.RECORD_STATUS = 'A'
                       AND LLB.RECORD_STATUS = 'A'
                       AND LL.PK_LOAD_LIST_ID = LLB.FK_LOAD_LIST_ID
                       AND LL.FK_VESSEL = P_I_V_VESSEL
                       AND LLB.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO
                       AND ((P_I_V_BOOKING_NO IS NULL) OR
                           (LLB.FK_BOOKING_NO = P_I_V_BOOKING_NO))
                       AND P.PICODE = LL.DN_PORT
                       AND LL.FK_SERVICE = ITP.VVSRVC
                       AND LL.FK_VESSEL = ITP.VVVESS
                       AND LL.FK_VOYAGE = ITP.VVVOYN
                       AND LL.FK_DIRECTION = ITP.VVPDIR
                       AND LL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
                       AND ITP.OMMISSION_FLAG IS NULL
                       AND ITP.VVVERS = 99
                       AND LL.FK_VERSION = 99
                       AND LL.FK_PORT_SEQUENCE_NO < P_I_V_PORT_SEQ
                    /*
                                                                                                                                                                        AND      (
                                                                                                                                                                                PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(  NVL2(TO_CHAR(LLB.ACTIVITY_DATE_TIME,'YYYYMMDD'),TO_CHAR(LLB.ACTIVITY_DATE_TIME,'YYYYMMDD'),ITP.VVSLDT )
                                                                                                                                                                                                                  , NVL2(TO_CHAR(LLB.ACTIVITY_DATE_TIME,'HH24MI'),TO_CHAR(LLB.ACTIVITY_DATE_TIME,'HH24MI'), ITP.VVSLTM )
                                                                                                                                                                                                                  , LL.DN_PORT )
                                                                                                                                                                                <
                                                                                                                                                                                PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL( TO_CHAR(TO_DATE(p_i_v_eta_date ,'DD/MM/YYYY'),'YYYYMMDD')
                                                                                                                                                                                                                  , p_i_v_eta_tm
                                                                                                                                                                                                                  , p_i_port_code )
                                                                                                                                                                                )
                                                                                                                                                                        */
                    UNION ALL

                    SELECT TS.PK_RESTOW_ID PK_LOADING_ID
                          ,'R' FLAG
                          ,ACTIVITY_DATE_TIME
                      FROM TOS_LL_LOAD_LIST LL
                          ,TOS_RESTOW       TS
                          ,ITP063           ITP
                          ,ITP040           P
                     WHERE LL.RECORD_STATUS = 'A'
                       AND TS.RECORD_STATUS = 'A'
                       AND LL.PK_LOAD_LIST_ID = TS.FK_LOAD_LIST_ID
                       AND LL.FK_VESSEL = P_I_V_VESSEL
                       AND TS.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO
                       AND ((P_I_V_BOOKING_NO IS NULL) OR
                           (TS.FK_BOOKING_NO = P_I_V_BOOKING_NO))
                       AND P.PICODE = LL.DN_PORT
                       AND LL.FK_SERVICE = ITP.VVSRVC
                       AND LL.FK_VESSEL = ITP.VVVESS
                       AND LL.FK_VOYAGE = ITP.VVVOYN
                       AND LL.FK_DIRECTION = ITP.VVPDIR
                       AND LL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
                       AND ITP.OMMISSION_FLAG IS NULL
                       AND ITP.VVVERS = 99
                       AND LL.FK_VERSION = 99
                       AND LL.FK_PORT_SEQUENCE_NO < P_I_V_PORT_SEQ
                    /*
                                                                                                                                                                        AND      (
                                                                                                                                                                                PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(  NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'),TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'),ITP.VVSLDT )
                                                                                                                                                                                                                  , NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'),TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'), ITP.VVSLTM )
                                                                                                                                                                                                                  , LL.DN_PORT )
                                                                                                                                                                                <
                                                                                                                                                                                PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL( TO_CHAR(TO_DATE(p_i_v_eta_date ,'DD/MM/YYYY'),'YYYYMMDD')
                                                                                                                                                                                                                 , p_i_v_eta_tm
                                                                                                                                                                                                                 , p_i_port_code )
                                                                                                                                                                                )
                                                                                                                                                                        */
                    )
             ORDER BY ACTIVITY_DATE_TIME DESC)
     WHERE SRNO = 1;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
      -- p_o_v_pk_loading_id       :=  NULL;            -- *3
    -- p_o_v_flag                :=  NULL;            -- *3
    -- p_o_v_err_cd              :=  'EDL.SE0121';    -- *3
    -- RETURN;                                        -- *3

    WHEN OTHERS THEN
      NULL;
      -- p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100); -- *3
    -- RETURN;                                                               -- *3

  END PRE_EDL_PREV_LOAD_LIST_ID;

  /* End commented by vikas, 22.11.2011 */

  PROCEDURE PRE_EDL_PREV_LOADED_EQUIP_ID(P_I_V_EQUIP_NO      VARCHAR2
                                        ,P_I_V_ETA_DATE      VARCHAR2
                                        ,P_I_V_ETA_TM        VARCHAR2
                                        ,P_O_V_PK_LOADING_ID OUT VARCHAR2
                                        ,P_O_V_FLAG          OUT VARCHAR2
                                        ,P_O_V_ERR_CD        OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT PK_LOADING_ID
          ,FLAG
      INTO P_O_V_PK_LOADING_ID
          ,P_O_V_FLAG
      FROM (SELECT PK_LOADING_ID
                  ,FLAG
                  ,ROW_NUMBER() OVER(ORDER BY ACTIVITY_DATE_TIME DESC NULLS LAST) SRNO -- *28
              FROM (SELECT LLB.PK_BOOKED_LOADING_ID PK_LOADING_ID
                          ,'D' FLAG
                          ,ACTIVITY_DATE_TIME
                      FROM TOS_LL_LOAD_LIST      LL
                          ,TOS_LL_BOOKED_LOADING LLB
                          ,ITP063                ITP
                          ,ITP040                P
                     WHERE LL.RECORD_STATUS = 'A'
                       AND LLB.RECORD_STATUS = 'A'
                       AND LL.PK_LOAD_LIST_ID = LLB.FK_LOAD_LIST_ID
                       AND LLB.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO
                       AND LLB.LOADING_STATUS = 'LO'
                       AND P.PICODE = LL.DN_PORT
                       AND LL.FK_SERVICE = ITP.VVSRVC
                       AND LL.FK_VESSEL = ITP.VVVESS
                       AND LL.FK_VOYAGE = ITP.VVVOYN
                       AND LL.FK_DIRECTION = ITP.VVPDIR
                       AND LL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
                       AND ITP.OMMISSION_FLAG IS NULL
                       AND ITP.VVVERS = 99
                       AND LL.FK_VERSION = 99
                       AND (PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(NVL2(TO_CHAR(LLB.ACTIVITY_DATE_TIME,
                                                                           'YYYYMMDD'),
                                                                   TO_CHAR(LLB.ACTIVITY_DATE_TIME,
                                                                           'YYYYMMDD'),
                                                                   ITP.VVSLDT),
                                                              NVL2(TO_CHAR(LLB.ACTIVITY_DATE_TIME,
                                                                           'HH24MI'),
                                                                   TO_CHAR(LLB.ACTIVITY_DATE_TIME,
                                                                           'HH24MI'),
                                                                   ITP.VVSLTM),
                                                              LL.DN_PORT) <
                           PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(TO_CHAR(TO_DATE(P_I_V_ETA_DATE,
                                                                              'DD/MM/YYYY'),
                                                                      'YYYYMMDD'),
                                                              P_I_V_ETA_TM,
                                                              LL.DN_PORT))

                    UNION ALL

                    SELECT TS.PK_RESTOW_ID PK_LOADING_ID
                          ,'R' FLAG
                          ,ACTIVITY_DATE_TIME
                      FROM TOS_LL_LOAD_LIST LL
                          ,TOS_RESTOW       TS
                          ,ITP063           ITP
                          ,ITP040           P
                     WHERE LL.RECORD_STATUS = 'A'
                       AND TS.RECORD_STATUS = 'A'
                       AND LL.PK_LOAD_LIST_ID = TS.FK_LOAD_LIST_ID
                       AND TS.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO
                       AND P.PICODE = LL.DN_PORT
                       AND LL.FK_SERVICE = ITP.VVSRVC
                       AND LL.FK_VESSEL = ITP.VVVESS
                       AND LL.FK_VOYAGE = ITP.VVVOYN
                       AND LL.FK_DIRECTION = ITP.VVPDIR
                       AND LL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
                       AND ITP.OMMISSION_FLAG IS NULL
                       AND ITP.VVVERS = 99
                       AND LL.FK_VERSION = 99
                       AND (PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,
                                                                           'YYYYMMDD'),
                                                                   TO_CHAR(TS.ACTIVITY_DATE_TIME,
                                                                           'YYYYMMDD'),
                                                                   ITP.VVSLDT),
                                                              NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,
                                                                           'HH24MI'),
                                                                   TO_CHAR(TS.ACTIVITY_DATE_TIME,
                                                                           'HH24MI'),
                                                                   ITP.VVSLTM),
                                                              LL.DN_PORT) <
                           PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(TO_CHAR(TO_DATE(P_I_V_ETA_DATE,
                                                                              'DD/MM/YYYY'),
                                                                      'YYYYMMDD'),
                                                              P_I_V_ETA_TM,
                                                              LL.DN_PORT)))
             ORDER BY ACTIVITY_DATE_TIME DESC)
     WHERE SRNO = 1;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_PK_LOADING_ID := NULL;
      P_O_V_FLAG          := NULL;
      P_O_V_ERR_CD        := 'EDL.SE0121';
      RETURN;

    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;

  END PRE_EDL_PREV_LOADED_EQUIP_ID;

  /*Start added by vikas as logic is changed, 22.11.2011*/
  /*
      Parameters:
      =============
      p_i_v_booking_no    => booking no
      p_i_v_equip_no      => equipment no
      p_i_v_terminal      => booked loading, discharge terminal (TOS_LL_BOOKED_LOADING.dn_discharge_terminal)
      p_i_v_port           => booked loading, discharge port (TOS_LL_BOOKED_LOADING.dn_discharge_port)
  */
  PROCEDURE PRE_NEXT_DISCHARGE_LIST_ID(P_I_V_BOOKING_NO    VARCHAR2
                                      ,P_I_V_EQUIP_NO      VARCHAR2
                                      ,P_I_V_TERMINAL      VARCHAR2 -- dn_discharge_terminal
                                      ,P_I_V_PORT          VARCHAR2 -- dn_discharge_port
                                      ,P_O_V_BOOKED_DIS_ID OUT VARCHAR2
                                      ,P_O_V_FLAG          OUT VARCHAR2
                                      ,P_O_V_ERR_CD        OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT PK_DISCHARGE_ID
          ,FLAG
      INTO P_O_V_BOOKED_DIS_ID
          ,P_O_V_FLAG
      FROM (SELECT BD.PK_BOOKED_DISCHARGE_ID PK_DISCHARGE_ID
                  ,'D' FLAG
              FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
                  ,VASAPPS.TOS_DL_DISCHARGE_LIST   DL
             WHERE DL.PK_DISCHARGE_LIST_ID = BD.FK_DISCHARGE_LIST_ID
               AND DL.DN_PORT = P_I_V_PORT -- DN_DISCHARGE_PORT
               AND DL.DN_TERMINAL = P_I_V_TERMINAL -- DN_DISCHARGE_TERMINAL
               AND BD.FK_BOOKING_NO = P_I_V_BOOKING_NO
               AND BD.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO

            UNION ALL

            SELECT TR.PK_RESTOW_ID PK_DISCHARGE_ID
                  ,'R' FLAG
              FROM VASAPPS.TOS_RESTOW            TR
                  ,VASAPPS.TOS_DL_DISCHARGE_LIST DL
             WHERE DL.PK_DISCHARGE_LIST_ID = TR.FK_DISCHARGE_LIST_ID
               AND DL.DN_PORT = P_I_V_PORT -- DN_DISCHARGE_PORT
               AND DL.DN_TERMINAL = P_I_V_TERMINAL -- DN_DISCHARGE_TERMINAL
               AND TR.FK_BOOKING_NO = P_I_V_BOOKING_NO
               AND TR.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO)
     WHERE ROWNUM = 1;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_BOOKED_DIS_ID := NULL;
      P_O_V_FLAG          := NULL;
      P_O_V_ERR_CD        := 'ELL.SE0121';
      RETURN;

    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;

  END PRE_NEXT_DISCHARGE_LIST_ID;
  /* End added by vikas, 22.11.2011*/

  PROCEDURE PRE_EDL_NEXT_DISCHARGE_LIST_ID(P_I_V_VESSEL              VARCHAR2
                                          ,P_I_V_EQUIP_NO            VARCHAR2
                                          ,P_I_V_BOOKING_NO          VARCHAR2
                                          ,P_I_V_ETD_DATE            VARCHAR2
                                          ,P_I_V_ETD_TM              VARCHAR2
                                          ,P_I_PORT_CODE             VARCHAR2
                                          ,P_I_V_FK_PORT_SEQUENCE_NO VARCHAR2
                                          ,P_O_V_PK_DISCHARGE_ID     OUT VARCHAR2
                                          ,P_O_V_FLAG                OUT VARCHAR2
                                          ,P_O_V_ERR_CD              OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT PK_DISCHARGE_ID
          ,FLAG
      INTO P_O_V_PK_DISCHARGE_ID
          ,P_O_V_FLAG
      FROM (SELECT PK_DISCHARGE_ID
                  ,FLAG
                  ,ROW_NUMBER() OVER(ORDER BY ACTIVITY_DATE_TIME NULLS LAST) SRNO -- *28
              FROM (SELECT DLB.PK_BOOKED_DISCHARGE_ID PK_DISCHARGE_ID
                          ,'D' FLAG
                          ,ACTIVITY_DATE_TIME
                      FROM TOS_DL_DISCHARGE_LIST   DL
                          ,TOS_DL_BOOKED_DISCHARGE DLB
                          ,ITP063                  ITP
                          ,ITP040                  P
                     WHERE DL.RECORD_STATUS = 'A'
                       AND DLB.RECORD_STATUS = 'A'
                       AND DL.PK_DISCHARGE_LIST_ID = DLB.FK_DISCHARGE_LIST_ID
                       AND DL.FK_VESSEL = P_I_V_VESSEL
                       AND DLB.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO
                       AND ((P_I_V_BOOKING_NO IS NULL) OR
                           (DLB.FK_BOOKING_NO = P_I_V_BOOKING_NO))
                       AND P.PICODE = DL.DN_PORT
                       AND DL.FK_SERVICE = ITP.VVSRVC
                       AND DL.FK_VESSEL = ITP.VVVESS
                       AND DL.FK_VOYAGE =
                           DECODE(DL.FK_SERVICE,
                                  'AFS',
                                  ITP.VVVOYN,
                                  ITP.INVOYAGENO)
                       AND DL.FK_DIRECTION = ITP.VVPDIR
                       AND DL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
                       AND ITP.OMMISSION_FLAG IS NULL
                       AND ITP.VVVERS = 99
                       AND DL.FK_VERSION = 99
                       AND DL.FK_PORT_SEQUENCE_NO > P_I_V_FK_PORT_SEQUENCE_NO
                    /*
                                                                                                                                                                            AND      (
                                                                                                                                                                                    PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(  NVL2(TO_CHAR(DLB.ACTIVITY_DATE_TIME,'YYYYMMDD'),TO_CHAR(DLB.ACTIVITY_DATE_TIME,'YYYYMMDD'),ITP.VVARDT )
                                                                                                                                                                                                                      , NVL2(TO_CHAR(DLB.ACTIVITY_DATE_TIME,'HH24MI'),TO_CHAR(DLB.ACTIVITY_DATE_TIME,'HH24MI'), ITP.VVARTM )
                                                                                                                                                                                                                      , DL.DN_PORT )
                                                                                                                                                                                    >
                                                                                                                                                                                    PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL( TO_CHAR(TO_DATE(p_i_v_etd_date ,'DD/MM/YYYY'),'YYYYMMDD')
                                                                                                                                                                                                                      , p_i_v_etd_tm
                                                                                                                                                                                                                      , p_i_port_code )
                                                                                                                                                                                    )
                                                                                                                                                                            */
                    UNION ALL

                    SELECT TS.PK_RESTOW_ID PK_DISCHARGE_ID
                          ,'R' FLAG
                          ,ACTIVITY_DATE_TIME
                      FROM TOS_DL_DISCHARGE_LIST DL
                          ,TOS_RESTOW            TS
                          ,ITP063                ITP
                          ,ITP040                P
                     WHERE DL.RECORD_STATUS = 'A'
                       AND TS.RECORD_STATUS = 'A'
                       AND DL.PK_DISCHARGE_LIST_ID = TS.FK_DISCHARGE_LIST_ID
                       AND DL.FK_VESSEL = P_I_V_VESSEL
                       AND TS.DN_EQUIPMENT_NO = P_I_V_EQUIP_NO
                       AND ((P_I_V_BOOKING_NO IS NULL) OR
                           (TS.FK_BOOKING_NO = P_I_V_BOOKING_NO))
                       AND P.PICODE = DL.DN_PORT
                       AND DL.FK_SERVICE = ITP.VVSRVC
                       AND DL.FK_VESSEL = ITP.VVVESS
                       AND DL.FK_VOYAGE =
                           DECODE(DL.FK_SERVICE,
                                  'AFS',
                                  ITP.VVVOYN,
                                  ITP.INVOYAGENO)
                       AND DL.FK_DIRECTION = ITP.VVPDIR
                       AND DL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
                       AND ITP.OMMISSION_FLAG IS NULL
                       AND ITP.VVVERS = 99
                       AND DL.FK_VERSION = 99
                       AND DL.FK_PORT_SEQUENCE_NO > P_I_V_FK_PORT_SEQUENCE_NO
                    /*
                                                                                                                                                                            AND      (
                                                                                                                                                                                    PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(  NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'),TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'),ITP.VVARDT )
                                                                                                                                                                                                                      , NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'),TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'), ITP.VVARTM )
                                                                                                                                                                                                                      , DL.DN_PORT )
                                                                                                                                                                                    >
                                                                                                                                                                                    PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL( TO_CHAR(TO_DATE(p_i_v_etd_date ,'DD/MM/YYYY'),'YYYYMMDD')
                                                                                                                                                                                                                      , p_i_v_etd_tm
                                                                                                                                                                                                                      , p_i_port_code )
                                                                                                                                                                                    )
                                                                                                                                                                            */
                    )
             ORDER BY ACTIVITY_DATE_TIME DESC)
     WHERE SRNO = 1;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
      --  p_o_v_pk_discharge_id     :=  NULL;         -- *3
    --  p_o_v_flag                :=  NULL;         -- *3
    --  p_o_v_err_cd              :=  'EDL.SE0121'; -- *3
    --  RETURN;

    WHEN OTHERS THEN
      NULL;
      -- p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100); -- *3
    -- RETURN;                                                               -- *3

  END PRE_EDL_NEXT_DISCHARGE_LIST_ID;

  PROCEDURE PRE_TOS_REMOVE_ERROR(P_I_V_DA_ERROR             VARCHAR2
                                ,P_I_V_LL_DL_FLAG           VARCHAR2
                                ,P_I_V_SIZE                 VARCHAR2
                                ,P_I_V_CLR1                 VARCHAR2
                                ,P_I_V_CLR2                 VARCHAR2
                                ,P_I_V_EQUIPMENT_NO         VARCHAR2
                                ,P_I_V_PK_OVERLANDED_ID     VARCHAR2
                                ,P_I_V_FK_DISCHARGE_LIST_ID VARCHAR2
                                ,P_O_V_ERR_CD               OUT VARCHAR2) AS
    L_V_REC_COUNT NUMBER := 0;
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    /* Check the error status of record. */
    IF ((P_I_V_DA_ERROR = NULL) OR (P_I_V_DA_ERROR = 'N')) THEN
      RETURN;
    END IF;

    /* Check for Size mismatch error */
    SELECT COUNT(1)
      INTO L_V_REC_COUNT
      FROM TOS_ERROR_LOG
     WHERE LL_DL_FLAG = P_I_V_LL_DL_FLAG
       AND FK_OVERLANDED_ID = P_I_V_PK_OVERLANDED_ID
       AND FK_DISCHARGE_LIST_ID = P_I_V_FK_DISCHARGE_LIST_ID
       AND ERROR_CODE = 'EC001';

    /* Check new Size should not be null */
    IF ((L_V_REC_COUNT > 0) AND (P_I_V_SIZE IS NULL)) THEN
      P_O_V_ERR_CD := 'EDL.SE0133' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    /* Check for Container Loading Remark1 error */
    SELECT COUNT(1)
      INTO L_V_REC_COUNT
      FROM TOS_ERROR_LOG
     WHERE LL_DL_FLAG = P_I_V_LL_DL_FLAG
       AND FK_OVERLANDED_ID = P_I_V_PK_OVERLANDED_ID
       AND FK_DISCHARGE_LIST_ID = P_I_V_FK_DISCHARGE_LIST_ID
       AND ERROR_CODE = 'EC013';

    /* Check new Container Loading Remark1 should not be null */
    IF ((L_V_REC_COUNT > 0) AND (P_I_V_CLR1 IS NULL)) THEN
      P_O_V_ERR_CD := 'EDL.SE0134' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    /* Check for Container Loading Remark2 error */
    SELECT COUNT(1)
      INTO L_V_REC_COUNT
      FROM TOS_ERROR_LOG
     WHERE LL_DL_FLAG = P_I_V_LL_DL_FLAG
       AND FK_OVERLANDED_ID = P_I_V_PK_OVERLANDED_ID
       AND FK_DISCHARGE_LIST_ID = P_I_V_FK_DISCHARGE_LIST_ID
       AND ERROR_CODE = 'EC014';

    /* Check new Container Loading Remark1 should not be null */
    IF ((L_V_REC_COUNT > 0) AND (P_I_V_CLR2 IS NULL)) THEN
      P_O_V_ERR_CD := 'EDL.SE0135' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    /* Delete the the logged data from table. */
    DELETE FROM TOS_ERROR_LOG
     WHERE LL_DL_FLAG = P_I_V_LL_DL_FLAG
       AND FK_OVERLANDED_ID = P_I_V_PK_OVERLANDED_ID
       AND FK_DISCHARGE_LIST_ID = P_I_V_FK_DISCHARGE_LIST_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_TOS_REMOVE_ERROR;

  PROCEDURE PRE_EDL_POD_UPDATE(P_I_V_PK_BOOKED_ID            TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID%TYPE
                              ,P_I_V_FK_BOOKING_NO           TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE
                              ,P_I_V_LLDL_FLAG               VARCHAR2
                              ,P_I_V_FK_BKG_VOYAGE_ROUT_DTL  TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
                              ,P_I_V_LOAD_CONDITION          TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION%TYPE
                              ,P_I_V_CONTAINER_GROSS_WEIGHT  TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT%TYPE
                                 --*33 begin
                              ,P_I_V_VGM TOS_DL_BOOKED_DISCHARGE.VGM%TYPE --*36
                              ,P_I_V_CATEGORY TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE%TYPE
                              --*33 end
                              ,P_I_V_DAMAGED                 TOS_DL_BOOKED_DISCHARGE.DAMAGED%TYPE
                              ,P_I_V_FK_CONTAINER_OPERATOR   TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR%TYPE
                              ,P_I_V_OUT_SLOT_OPERATOR       TOS_DL_BOOKED_DISCHARGE.OUT_SLOT_OPERATOR%TYPE
                              ,P_I_V_SEAL_NO                 TOS_DL_BOOKED_DISCHARGE.SEAL_NO%TYPE
                              ,P_I_V_MLO_VESSEL              TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL%TYPE
                              ,P_I_V_MLO_VOYAGE              TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE%TYPE
                              ,P_I_V_MLO_VESSEL_ETA          DATE
                              ,P_I_V_MLO_POD1                TOS_DL_BOOKED_DISCHARGE.MLO_POD1%TYPE
                              ,P_I_V_MLO_POD2                TOS_DL_BOOKED_DISCHARGE.MLO_POD2%TYPE
                              ,P_I_V_MLO_POD3                TOS_DL_BOOKED_DISCHARGE.MLO_POD3%TYPE
                              ,P_I_V_MLO_DEL                 TOS_DL_BOOKED_DISCHARGE.MLO_DEL%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_1  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_2  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_3  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3%TYPE
                              ,P_I_V_CONTAINER_LOADING_REM_1 TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1%TYPE
                              ,P_I_V_CONTAINER_LOADING_REM_2 TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG1  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG2  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG3  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3%TYPE
                              ,P_I_V_FUMIGATION_ONLY         TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY%TYPE
                              ,P_I_V_RESIDUE_ONLY_FLAG       TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG%TYPE
                              ,P_I_V_FK_BKG_SIZE_TYPE_DTL    TOS_DL_BOOKED_DISCHARGE.FK_BKG_SIZE_TYPE_DTL%TYPE
                              ,P_I_V_FK_BKG_SUPPLIER         TOS_DL_BOOKED_DISCHARGE.FK_BKG_SUPPLIER%TYPE
                              ,P_I_V_FK_BKG_EQUIPM_DTL       TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL%TYPE
                              ,P_O_V_ERR_CD                  OUT VARCHAR2) AS
    L_V_LOAD_CONDITION          TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION%TYPE;
    L_V_CONTAINER_GROSS_WEIGHT  TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT%TYPE;
    --*33begin
    L_V_VGM TOS_DL_BOOKED_DISCHARGE.VGM%TYPE; --*36
    L_V_CATEGORY TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE%TYPE;
    --*33 end
    L_V_DAMAGED                 TOS_DL_BOOKED_DISCHARGE.DAMAGED%TYPE;
    L_V_FK_CONTAINER_OPERATOR   TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR%TYPE;
    L_V_OUT_SLOT_OPERATOR       TOS_DL_BOOKED_DISCHARGE.OUT_SLOT_OPERATOR%TYPE;
    L_V_SEAL_NO                 TOS_DL_BOOKED_DISCHARGE.SEAL_NO%TYPE;
    L_V_MLO_VESSEL              TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL%TYPE;
    L_V_MLO_VOYAGE              TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE%TYPE;
    L_V_MLO_VESSEL_ETA          TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL_ETA%TYPE;
    L_V_MLO_POD1                TOS_DL_BOOKED_DISCHARGE.MLO_POD1%TYPE;
    L_V_MLO_POD2                TOS_DL_BOOKED_DISCHARGE.MLO_POD2%TYPE;
    L_V_MLO_POD3                TOS_DL_BOOKED_DISCHARGE.MLO_POD3%TYPE;
    L_V_MLO_DEL                 TOS_DL_BOOKED_DISCHARGE.MLO_DEL%TYPE;
    L_V_FK_HANDL_INSTRUCTION_1  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1%TYPE;
    L_V_FK_HANDL_INSTRUCTION_2  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2%TYPE;
    L_V_FK_HANDL_INSTRUCTION_3  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3%TYPE;
    L_V_CONTAINER_LOADING_REM_1 TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1%TYPE;
    L_V_CONTAINER_LOADING_REM_2 TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2%TYPE;
    L_V_TIGHT_CONNECTION_FLAG1  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1%TYPE;
    L_V_TIGHT_CONNECTION_FLAG2  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2%TYPE;
    L_V_TIGHT_CONNECTION_FLAG3  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3%TYPE;
    L_V_FUMIGATION_ONLY         TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY%TYPE;
    L_V_RESIDUE_ONLY_FLAG       TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG%TYPE;
    L_V_SQL_ID                  VARCHAR2(10);
    L_V_PARAMETER_STR           TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;
    L_V_ERR_DESC                VARCHAR2(100);
    L_V_EXCEPTION EXCEPTION;

  BEGIN

    L_V_PARAMETER_STR := P_I_V_PK_BOOKED_ID || '~' || P_I_V_FK_BOOKING_NO || '~' ||
                         P_I_V_LLDL_FLAG || '~' ||
                         P_I_V_FK_BKG_VOYAGE_ROUT_DTL || '~' ||
                         P_I_V_LOAD_CONDITION || '~' ||
                         P_I_V_CONTAINER_GROSS_WEIGHT || '~' ||
                         P_I_V_DAMAGED || '~' ||
                         P_I_V_FK_CONTAINER_OPERATOR || '~' ||
                         P_I_V_OUT_SLOT_OPERATOR || '~' || P_I_V_SEAL_NO || '~' ||
                         P_I_V_MLO_VESSEL || '~' || P_I_V_MLO_VOYAGE || '~' ||
                         P_I_V_MLO_VESSEL_ETA || '~' || P_I_V_MLO_POD1 || '~' ||
                         P_I_V_MLO_POD2 || '~' || P_I_V_MLO_POD3 || '~' ||
                         P_I_V_MLO_DEL || '~' ||
                         P_I_V_FK_HANDL_INSTRUCTION_1 || '~' ||
                         P_I_V_FK_HANDL_INSTRUCTION_2 || '~' ||
                         P_I_V_FK_HANDL_INSTRUCTION_3 || '~' ||
                         P_I_V_CONTAINER_LOADING_REM_1 || '~' ||
                         P_I_V_CONTAINER_LOADING_REM_2 || '~' ||
                         P_I_V_TIGHT_CONNECTION_FLAG1 || '~' ||
                         P_I_V_TIGHT_CONNECTION_FLAG2 || '~' ||
                         P_I_V_TIGHT_CONNECTION_FLAG3 || '~' ||
                         P_I_V_FUMIGATION_ONLY || '~' ||
                         P_I_V_RESIDUE_ONLY_FLAG || '~' ||
                         P_I_V_FK_BKG_SIZE_TYPE_DTL || '~' ||
                         P_I_V_FK_BKG_SUPPLIER || '~' ||
                         P_I_V_FK_BKG_EQUIPM_DTL;

    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    L_V_SQL_ID   := 'SQL0SS1';
    SELECT LOAD_CONDITION
          ,CONTAINER_GROSS_WEIGHT
          --*33begin
          ,VGM --*36
          ,CATEGORY_CODE
          --*33end
          ,DAMAGED
          ,FK_CONTAINER_OPERATOR
          ,OUT_SLOT_OPERATOR
          ,SEAL_NO
          ,MLO_VESSEL
          ,MLO_VOYAGE
          ,MLO_VESSEL_ETA
          ,MLO_POD1
          ,MLO_POD2
          ,MLO_POD3
          ,MLO_DEL
          ,FK_HANDLING_INSTRUCTION_1
          ,FK_HANDLING_INSTRUCTION_2
          ,FK_HANDLING_INSTRUCTION_3
          ,CONTAINER_LOADING_REM_1
          ,CONTAINER_LOADING_REM_2
          ,TIGHT_CONNECTION_FLAG1
          ,TIGHT_CONNECTION_FLAG2
          ,TIGHT_CONNECTION_FLAG3
          ,FUMIGATION_ONLY
          ,RESIDUE_ONLY_FLAG
      INTO L_V_LOAD_CONDITION
          ,L_V_CONTAINER_GROSS_WEIGHT
          --*33 begin
          ,L_V_VGM --*36 
          ,L_V_CATEGORY
          --*33 end
          ,L_V_DAMAGED
          ,L_V_FK_CONTAINER_OPERATOR
          ,L_V_OUT_SLOT_OPERATOR
          ,L_V_SEAL_NO
          ,L_V_MLO_VESSEL
          ,L_V_MLO_VOYAGE
          ,L_V_MLO_VESSEL_ETA
          ,L_V_MLO_POD1
          ,L_V_MLO_POD2
          ,L_V_MLO_POD3
          ,L_V_MLO_DEL
          ,L_V_FK_HANDL_INSTRUCTION_1
          ,L_V_FK_HANDL_INSTRUCTION_2
          ,L_V_FK_HANDL_INSTRUCTION_3
          ,L_V_CONTAINER_LOADING_REM_1
          ,L_V_CONTAINER_LOADING_REM_2
          ,L_V_TIGHT_CONNECTION_FLAG1
          ,L_V_TIGHT_CONNECTION_FLAG2
          ,L_V_TIGHT_CONNECTION_FLAG3
          ,L_V_FUMIGATION_ONLY
          ,L_V_RESIDUE_ONLY_FLAG
      FROM TOS_DL_BOOKED_DISCHARGE
     WHERE PK_BOOKED_DISCHARGE_ID = P_I_V_PK_BOOKED_ID;

    -- check the value of passed data from db value
    L_V_SQL_ID := 'SQL0SS2';
    IF (NVL(P_I_V_LOAD_CONDITION, '~') <> NVL(L_V_LOAD_CONDITION, '~')) THEN
      L_V_LOAD_CONDITION := NVL(P_I_V_LOAD_CONDITION, '~');
    ELSE
      L_V_LOAD_CONDITION := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS3';
    IF (NVL(TO_NUMBER(P_I_V_CONTAINER_GROSS_WEIGHT), 0) <>
       NVL(L_V_CONTAINER_GROSS_WEIGHT, 0)) THEN
      L_V_CONTAINER_GROSS_WEIGHT := NVL(P_I_V_CONTAINER_GROSS_WEIGHT, 0);
    ELSE

      IF (P_I_V_CONTAINER_GROSS_WEIGHT IS NOT NULL AND
         L_V_CONTAINER_GROSS_WEIGHT IS NULL)
         OR (P_I_V_CONTAINER_GROSS_WEIGHT IS NULL AND
         L_V_CONTAINER_GROSS_WEIGHT IS NOT NULL) THEN
        L_V_CONTAINER_GROSS_WEIGHT := 0;
      ELSE
        L_V_CONTAINER_GROSS_WEIGHT := NULL;
      END IF;

    END IF;

    --*33 begin
    L_V_SQL_ID := 'SQL0SS26'; --VGM
    L_V_SQL_ID := 'SQL0SS27'; --CATEGORY
      IF (NVL(P_I_V_CATEGORY, '~') <> NVL(L_V_CATEGORY, '~')) THEN
      L_V_CATEGORY := NVL(P_I_V_CATEGORY, '~');
    ELSE
      L_V_CATEGORY := NULL;
    END IF;
    --*33 end
    L_V_SQL_ID := 'SQL0SS4';
    IF (NVL(P_I_V_DAMAGED, '~') <> NVL(L_V_DAMAGED, '~')) THEN
      L_V_DAMAGED := NVL(P_I_V_DAMAGED, '~');
    ELSE
      L_V_DAMAGED := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS5';
    IF (NVL(P_I_V_FK_CONTAINER_OPERATOR, '~') <>
       NVL(L_V_FK_CONTAINER_OPERATOR, '~')) THEN
      L_V_FK_CONTAINER_OPERATOR := NVL(P_I_V_FK_CONTAINER_OPERATOR, '~');
    ELSE
      L_V_FK_CONTAINER_OPERATOR := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS6';
    IF (NVL(P_I_V_OUT_SLOT_OPERATOR, '~') <>
       NVL(L_V_OUT_SLOT_OPERATOR, '~')) THEN
      L_V_OUT_SLOT_OPERATOR := NVL(P_I_V_OUT_SLOT_OPERATOR, '~');
    ELSE
      L_V_OUT_SLOT_OPERATOR := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS7';
    IF (NVL(P_I_V_SEAL_NO, '~') <> NVL(L_V_SEAL_NO, '~')) THEN
      L_V_SEAL_NO := NVL(P_I_V_SEAL_NO, '~');
    ELSE
      L_V_SEAL_NO := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS8';
    IF (NVL(P_I_V_MLO_VESSEL, '~') <> NVL(L_V_MLO_VESSEL, '~')) THEN
      L_V_MLO_VESSEL := NVL(P_I_V_MLO_VESSEL, '~');
    ELSE
      L_V_MLO_VESSEL := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS9';
    IF (NVL(P_I_V_MLO_VOYAGE, '~') <> NVL(L_V_MLO_VOYAGE, '~')) THEN
      L_V_MLO_VOYAGE := NVL(P_I_V_MLO_VOYAGE, '~');
    ELSE
      L_V_MLO_VOYAGE := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS10';
    IF (NVL(P_I_V_MLO_VESSEL_ETA, TO_DATE('01/01/1900', 'dd/mm/yyyy')) <>
       NVL(L_V_MLO_VESSEL_ETA, TO_DATE('01/01/1900', 'dd/mm/yyyy'))) THEN
      L_V_MLO_VESSEL_ETA := NVL(P_I_V_MLO_VESSEL_ETA,
                                TO_DATE('01/01/1900', 'dd/mm/yyyy'));
    ELSE
      L_V_MLO_VESSEL_ETA := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS11';
    IF (NVL(P_I_V_MLO_POD1, '~') <> NVL(L_V_MLO_POD1, '~')) THEN
      L_V_MLO_POD1 := NVL(P_I_V_MLO_POD1, '~');
    ELSE
      L_V_MLO_POD1 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS12';
    IF (NVL(P_I_V_MLO_POD2, '~') <> NVL(L_V_MLO_POD2, '~')) THEN
      L_V_MLO_POD2 := NVL(P_I_V_MLO_POD2, '~');
    ELSE
      L_V_MLO_POD2 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS13';
    IF (NVL(P_I_V_MLO_POD3, '~') <> NVL(L_V_MLO_POD3, '~')) THEN
      L_V_MLO_POD3 := NVL(P_I_V_MLO_POD3, '~');
    ELSE
      L_V_MLO_POD3 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS14';
    IF (NVL(P_I_V_MLO_DEL, '~') <> NVL(L_V_MLO_DEL, '~')) THEN
      L_V_MLO_DEL := NVL(P_I_V_MLO_DEL, '~');
    ELSE
      L_V_MLO_DEL := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS15';
    IF (NVL(P_I_V_FK_HANDL_INSTRUCTION_1, '~') <>
       NVL(L_V_FK_HANDL_INSTRUCTION_1, '~')) THEN
      L_V_FK_HANDL_INSTRUCTION_1 := NVL(P_I_V_FK_HANDL_INSTRUCTION_1, '~');
    ELSE
      L_V_FK_HANDL_INSTRUCTION_1 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS16';
    IF (NVL(P_I_V_FK_HANDL_INSTRUCTION_2, '~') <>
       NVL(L_V_FK_HANDL_INSTRUCTION_2, '~')) THEN
      L_V_FK_HANDL_INSTRUCTION_2 := NVL(P_I_V_FK_HANDL_INSTRUCTION_2, '~');
    ELSE
      L_V_FK_HANDL_INSTRUCTION_2 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS17';
    IF (NVL(P_I_V_FK_HANDL_INSTRUCTION_3, '~') <>
       NVL(L_V_FK_HANDL_INSTRUCTION_3, '~')) THEN
      L_V_FK_HANDL_INSTRUCTION_3 := NVL(P_I_V_FK_HANDL_INSTRUCTION_3, '~');
    ELSE
      L_V_FK_HANDL_INSTRUCTION_3 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS18';
    IF (NVL(P_I_V_CONTAINER_LOADING_REM_1, '~') <>
       NVL(L_V_CONTAINER_LOADING_REM_1, '~')) THEN
      L_V_CONTAINER_LOADING_REM_1 := NVL(P_I_V_CONTAINER_LOADING_REM_1, '~');
    ELSE
      L_V_CONTAINER_LOADING_REM_1 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS19';
    IF (NVL(P_I_V_CONTAINER_LOADING_REM_2, '~') <>
       NVL(L_V_CONTAINER_LOADING_REM_2, '~')) THEN
      L_V_CONTAINER_LOADING_REM_2 := NVL(P_I_V_CONTAINER_LOADING_REM_2, '~');
    ELSE
      L_V_CONTAINER_LOADING_REM_2 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS20';
    IF (NVL(P_I_V_TIGHT_CONNECTION_FLAG1, '~') <>
       NVL(L_V_TIGHT_CONNECTION_FLAG1, '~')) THEN
      L_V_TIGHT_CONNECTION_FLAG1 := NVL(P_I_V_TIGHT_CONNECTION_FLAG1, '~');
    ELSE
      L_V_TIGHT_CONNECTION_FLAG1 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS21';
    IF (NVL(P_I_V_TIGHT_CONNECTION_FLAG2, '~') <>
       NVL(L_V_TIGHT_CONNECTION_FLAG2, '~')) THEN
      L_V_TIGHT_CONNECTION_FLAG2 := NVL(P_I_V_TIGHT_CONNECTION_FLAG2, '~');
    ELSE
      L_V_TIGHT_CONNECTION_FLAG2 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS22';
    IF (NVL(P_I_V_TIGHT_CONNECTION_FLAG3, '~') <>
       NVL(L_V_TIGHT_CONNECTION_FLAG3, '~')) THEN
      L_V_TIGHT_CONNECTION_FLAG3 := NVL(P_I_V_TIGHT_CONNECTION_FLAG3, '~');
    ELSE
      L_V_TIGHT_CONNECTION_FLAG3 := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS23';
    IF (NVL(P_I_V_FUMIGATION_ONLY, '~') <> NVL(L_V_FUMIGATION_ONLY, '~')) THEN
      L_V_FUMIGATION_ONLY := NVL(P_I_V_FUMIGATION_ONLY, '~');
    ELSE
      L_V_FUMIGATION_ONLY := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS24';
    IF (NVL(P_I_V_RESIDUE_ONLY_FLAG, '~') <>
       NVL(L_V_RESIDUE_ONLY_FLAG, '~')) THEN
      L_V_RESIDUE_ONLY_FLAG := NVL(P_I_V_RESIDUE_ONLY_FLAG, '~');
    ELSE
      L_V_RESIDUE_ONLY_FLAG := NULL;
    END IF;

    L_V_SQL_ID := 'SQL0SS25';
    PCE_EUT_COMMON.PRE_UPD_NEXT_POD(P_I_V_FK_BOOKING_NO,
                                    P_I_V_LLDL_FLAG,
                                    P_I_V_FK_BKG_VOYAGE_ROUT_DTL,
                                    L_V_LOAD_CONDITION,
                                    L_V_CONTAINER_GROSS_WEIGHT,
                                    --*33 begin
                                    L_V_VGM, --*36 
                                    L_V_CATEGORY,
                                    --*33 end
                                    L_V_DAMAGED,
                                    L_V_FK_CONTAINER_OPERATOR,
                                    L_V_OUT_SLOT_OPERATOR,
                                    L_V_SEAL_NO,
                                    L_V_MLO_VESSEL,
                                    L_V_MLO_VOYAGE,
                                    L_V_MLO_VESSEL_ETA,
                                    L_V_MLO_POD1,
                                    L_V_MLO_POD2,
                                    L_V_MLO_POD3,
                                    L_V_MLO_DEL,
                                    L_V_FK_HANDL_INSTRUCTION_1,
                                    L_V_FK_HANDL_INSTRUCTION_2,
                                    L_V_FK_HANDL_INSTRUCTION_3,
                                    L_V_CONTAINER_LOADING_REM_1,
                                    L_V_CONTAINER_LOADING_REM_2,
                                    L_V_TIGHT_CONNECTION_FLAG1,
                                    L_V_TIGHT_CONNECTION_FLAG2,
                                    L_V_TIGHT_CONNECTION_FLAG3,
                                    L_V_FUMIGATION_ONLY,
                                    L_V_RESIDUE_ONLY_FLAG,
                                    P_I_V_FK_BKG_SIZE_TYPE_DTL,
                                    P_I_V_FK_BKG_SUPPLIER,
                                    P_I_V_FK_BKG_EQUIPM_DTL,
                                    P_O_V_ERR_CD);

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RAISE L_V_EXCEPTION;
    END IF;

  EXCEPTION
    WHEN L_V_EXCEPTION THEN
      L_V_ERR_DESC := SUBSTR(SQLERRM, 1, 100);
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER_STR,
                                                       'DLSYNC',
                                                       'T',
                                                       L_V_SQL_ID || '~' ||
                                                       L_V_ERR_DESC,
                                                       'A',
                                                       'EZLL',
                                                       CURRENT_TIMESTAMP,
                                                       'EZLL',
                                                       CURRENT_TIMESTAMP);
      COMMIT;

    WHEN OTHERS THEN
      L_V_ERR_DESC := SUBSTR(SQLERRM, 1, 100);
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER_STR,
                                                       'DLSYNC',
                                                       'T',
                                                       L_V_SQL_ID || '~' ||
                                                       L_V_ERR_DESC,
                                                       'A',
                                                       'EZLL',
                                                       CURRENT_TIMESTAMP,
                                                       'EZLL',
                                                       CURRENT_TIMESTAMP);
      COMMIT;

      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_POD_UPDATE;

  /*
      *9: changes start
  */
  PROCEDURE PRE_EDI_ERRRO_MSG(P_O_REFEDI    OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                             ,P_I_V_LIST_ID VARCHAR2
                             ,P_I_V_FLAG    VARCHAR2
                             ,P_O_V_ERR_CD  OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    OPEN P_O_REFEDI FOR
      SELECT BL.FK_BOOKING_NO         BL_FK_BOOKING_NO
            ,OS.BOOKING_NO            OS_BOOKING_NO
            ,BL.DN_EQUIPMENT_NO       BL_DN_EQUIPMENT_NO
            ,OS.EQUIPMENT_NO          OS_EQUIPMENT_NO
            ,BL.STOWAGE_POSITION      BL_STOWAGE_POSITION
            ,OS.STOWAGE_POSITION      OS_STOWAGE_POSITION
            ,OS.EQ_SIZE               OS_EQ_SIZE
            ,BL.DN_EQ_SIZE            BL_DN_EQ_SIZE
            ,OS.EQ_TYPE               OS_EQ_TYPE
            ,BL.DN_EQ_TYPE            BL_DN_EQ_TYPE
            ,BL.DN_FULL_MT            BL_DN_FULL_MT
            ,OS.FULL_MT               OS_FULL_MT
            ,BL.LOCAL_STATUS          BL_LOCAL_STATUS
            ,OS.LOCAL_STATUS          OS_LOCAL_STATUS
            ,BL.FK_SLOT_OPERATOR      BL_FK_SLOT_OPERATOR
            ,OS.SLOT_OPERATOR         OS_SLOT_OPERATOR
            ,BL.DN_SPECIAL_HNDL       BL_DN_SPECIAL_HNDL
            ,OS.SPECIAL_HANDLING      OS_SPECIAL_HANDLING
            ,BL.DN_DISCHARGE_PORT     BL_DN_DISCHARGE_PORT
            ,OS.DISCHARGE_PORT        OS_DISCHARGE_PORT
            ,BL.DN_DISCHARGE_TERMINAL BL_DN_DISCHARGE_TERMINAL
            ,OS.POD_TERMINAL          OS_POD_TERMINAL
            ,BL.FK_CONTAINER_OPERATOR BL_FK_CONTAINER_OPERATOR
            ,OS.CONTAINER_OPERATOR    OS_CONTAINER_OPERATOR
            ,BL.FK_SLOT_OPERATOR      BL_FK_SLOT_OPERATOR
            ,OS.SLOT_OPERATOR         OS_SLOT_OPERATOR
            ,BL.EX_MLO_VESSEL         BL_EX_MLO_VESSEL
            ,OS.EX_MLO_VESSEL         OS_EX_MLO_VESSEL
            ,BL.EX_MLO_VOYAGE         BL_EX_MLO_VOYAGE
            ,OS.EX_MLO_VOYAGE         OS_EX_MLO_VOYAGE
            ,BL.DN_SOC_COC            BL_DN_SOC_COC
            ,OS.FLAG_SOC_COC          OS_FLAG_SOC_COC
            ,OS.DA_ERROR              OS_DA_ERROR
        FROM VASAPPS.TOS_LL_BOOKED_LOADING        BL
            ,VASAPPS.TOS_LL_OVERSHIPPED_CONTAINER OS
       WHERE BL.FK_LOAD_LIST_ID = P_I_V_LIST_ID
         AND OS.FK_LOAD_LIST_ID = BL.FK_LOAD_LIST_ID
         AND BL.DN_EQUIPMENT_NO = OS.EQUIPMENT_NO
         AND P_I_V_FLAG = 'L'

      UNION ALL

      SELECT BD.FK_BOOKING_NO
            ,OL.BOOKING_NO
            ,BD.DN_EQUIPMENT_NO
            ,OL.EQUIPMENT_NO
            ,BD.STOWAGE_POSITION
            ,OL.STOWAGE_POSITION
            ,OL.EQ_SIZE
            ,BD.DN_EQ_SIZE
            ,OL.EQ_TYPE
            ,BD.DN_EQ_TYPE
            ,BD.DN_FULL_MT
            ,OL.FULL_MT
            ,BD.LOCAL_STATUS
            ,OL.LOCAL_STATUS
            ,BD.FK_SLOT_OPERATOR
            ,OL.SLOT_OPERATOR
            ,BD.DN_SPECIAL_HNDL
            ,OL.SPECIAL_HANDLING
            ,BD.DN_POL
            ,OL.POL
            ,BD.DN_POL_TERMINAL
            , --DN_POL, -- *19
             OL.POL_TERMINAL
            , --OL.POL, -- *19
             BD.FK_CONTAINER_OPERATOR
            ,OL.CONTAINER_OPERATOR
            ,BD.FK_SLOT_OPERATOR
            ,''
            ,''
            ,''
            ,''
            ,OL.SLOT_OPERATOR
            ,BD.DN_SOC_COC
            ,FLAG_SOC_COC
            ,OL.DA_ERROR
        FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE     BD
            ,VASAPPS.TOS_DL_OVERLANDED_CONTAINER OL
       WHERE BD.FK_DISCHARGE_LIST_ID = P_I_V_LIST_ID
         AND OL.FK_DISCHARGE_LIST_ID = BD.FK_DISCHARGE_LIST_ID
         AND BD.DN_EQUIPMENT_NO = OL.EQUIPMENT_NO
         AND P_I_V_FLAG = 'D';

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0004;
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
  END;

  /*
      *9: Changes end
      *17: Changes start
  */
  PROCEDURE PRE_LIST_OPEN_BOOOKINGS(P_I_V_LIST_ID    VARCHAR2
                                   ,P_I_V_LL_DL_FLAG VARCHAR2
                                   ,P_O_V_BOOKING    OUT NOCOPY VARCHAR2) AS

    /* DECLARE CONSTANTS */
    C_LOAD_LIST      VARCHAR2(1) DEFAULT 'L';
    C_DISCHARGE_LIST VARCHAR2(1) DEFAULT 'D';
    C_SEPERATOR      VARCHAR2(1) DEFAULT ',';
    C_CLOSED         VARCHAR2(1) DEFAULT 'L'; --'C'; --*18
    C_SUSPENDED      VARCHAR2(1) DEFAULT 'S';

    /* CURSOR TO GET OPEN BOOKINGS */
    CURSOR CUR_OPEN_BOOKINGS IS
      SELECT DISTINCT FK_BOOKING_NO FK_BOOKING_NO
        FROM TOS_LL_BOOKED_LOADING BL
       WHERE FK_LOAD_LIST_ID = P_I_V_LIST_ID
         AND P_I_V_LL_DL_FLAG = C_LOAD_LIST
         AND EXISTS (SELECT 1
                FROM BKP001
               WHERE BABKNO = BL.FK_BOOKING_NO
                 AND BASTAT != C_CLOSED)
         AND RECORD_STATUS <> C_SUSPENDED -- *18

      UNION ALL

      SELECT DISTINCT FK_BOOKING_NO FK_BOOKING_NO
        FROM TOS_DL_BOOKED_DISCHARGE BD
       WHERE FK_DISCHARGE_LIST_ID = P_I_V_LIST_ID
         AND P_I_V_LL_DL_FLAG = C_DISCHARGE_LIST
         AND EXISTS (SELECT 1
                FROM BKP001
               WHERE BABKNO = BD.FK_BOOKING_NO
                 AND BASTAT != C_CLOSED)
         AND RECORD_STATUS <> C_SUSPENDED; -- *18

  BEGIN

    /* CREATE COMMA SEPRATED BOOKING NAME STRING */
    FOR V_CUR_OPEN_BOOKINGS IN CUR_OPEN_BOOKINGS
    LOOP
      IF P_O_V_BOOKING IS NULL THEN
        P_O_V_BOOKING := V_CUR_OPEN_BOOKINGS.FK_BOOKING_NO;
      ELSE
        P_O_V_BOOKING := P_O_V_BOOKING || C_SEPERATOR ||
                         V_CUR_OPEN_BOOKINGS.FK_BOOKING_NO;
      END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE(P_O_V_BOOKING);

  EXCEPTION
    WHEN OTHERS THEN
      NULL;

  END PRE_LIST_OPEN_BOOOKINGS;
  /*
      *17: changes end
  */

  /* *24 start * */
  PROCEDURE PRE_CHECK_DUP_CELL_LOCATION(P_I_V_SESSION_ID VARCHAR2
                                       ,P_I_V_FLAG       VARCHAR2
                                       ,P_I_V_LIST_ID    VARCHAR2
                                       ,P_O_V_ERR_CD     OUT VARCHAR2) AS

    -- SET SERVEROUTPUT ON;
    -- DECLARE
    --     P_I_V_SESSION_ID              VARCHAR2(2000);
    --     P_I_V_FLAG                    VARCHAR2(2000);
    --     P_O_V_ERR_CD                  VARCHAR2(2000);

    CURSOR L_CUR_DUP_STOWAGE_POS_DL_TMP IS
      SELECT STOWAGE_POSITION
        FROM TOS_DL_BOOKED_DISCHARGE_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       GROUP BY STOWAGE_POSITION
      HAVING COUNT(STOWAGE_POSITION) > 1
       ORDER BY COUNT(STOWAGE_POSITION);

    CURSOR L_CUR_DUP_STOWAGE_POS_LL_TMP IS
      SELECT STOWAGE_POSITION
        FROM TOS_LL_BOOKED_LOADING_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       GROUP BY STOWAGE_POSITION
      HAVING COUNT(STOWAGE_POSITION) > 1
       ORDER BY COUNT(STOWAGE_POSITION);

    CURSOR L_CUR_DUP_STOWAGE_POS_DL IS
      SELECT STOWAGE_POSITION
        FROM TOS_DL_BOOKED_DISCHARGE
       WHERE FK_DISCHARGE_LIST_ID = P_I_V_LIST_ID
         AND RECORD_STATUS = 'A'
         AND STOWAGE_POSITION IS NOT NULL
       GROUP BY STOWAGE_POSITION
      HAVING COUNT(STOWAGE_POSITION) > 1
       ORDER BY COUNT(STOWAGE_POSITION);

    CURSOR L_CUR_DUP_STOWAGE_POS_LL IS
      SELECT STOWAGE_POSITION
        FROM TOS_LL_BOOKED_LOADING
       WHERE FK_LOAD_LIST_ID = P_I_V_LIST_ID
         AND RECORD_STATUS = 'A'
         AND STOWAGE_POSITION IS NOT NULL
       GROUP BY STOWAGE_POSITION
      HAVING COUNT(STOWAGE_POSITION) > 1
       ORDER BY COUNT(STOWAGE_POSITION);

    L_V_DUPLICATE_ERROR VARCHAR2(4000);

    L_V_FLG_DATA_FOUND VARCHAR2(5);
    TRUE  CONSTANT VARCHAR2(5) DEFAULT 'true';
    FALSE CONSTANT VARCHAR2(5) DEFAULT 'false';
  BEGIN

    /* * set default error message * */
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    L_V_FLG_DATA_FOUND := FALSE;

    /* * check for load list * */
    IF P_I_V_FLAG = LOAD_LIST THEN
      FOR L_CUR_DUP_STOWAGE_POS_REC IN L_CUR_DUP_STOWAGE_POS_LL_TMP
      LOOP
        L_V_FLG_DATA_FOUND := TRUE;
        IF L_V_DUPLICATE_ERROR IS NULL THEN
          L_V_DUPLICATE_ERROR := L_CUR_DUP_STOWAGE_POS_REC.STOWAGE_POSITION;
        ELSE
          L_V_DUPLICATE_ERROR := L_V_DUPLICATE_ERROR || ', ' ||
                                 L_CUR_DUP_STOWAGE_POS_REC.STOWAGE_POSITION;
        END IF;
      END LOOP;
    END IF;

    /* * check for discharge list * */
    IF P_I_V_FLAG = DISCHARGE_LIST THEN
      FOR L_CUR_DUP_STOWAGE_POS_REC IN L_CUR_DUP_STOWAGE_POS_DL_TMP
      LOOP
        L_V_FLG_DATA_FOUND := TRUE;
        IF L_V_DUPLICATE_ERROR IS NULL THEN
          L_V_DUPLICATE_ERROR := L_CUR_DUP_STOWAGE_POS_REC.STOWAGE_POSITION;
        ELSE
          L_V_DUPLICATE_ERROR := L_V_DUPLICATE_ERROR || ', ' ||
                                 L_CUR_DUP_STOWAGE_POS_REC.STOWAGE_POSITION;
        END IF;
      END LOOP;
    END IF;

    IF L_V_FLG_DATA_FOUND = FALSE THEN
      /* * check for load list * */
      IF P_I_V_FLAG = LOAD_LIST THEN
        FOR L_CUR_DUP_STOWAGE_POS_REC IN L_CUR_DUP_STOWAGE_POS_LL
        LOOP
          IF L_V_DUPLICATE_ERROR IS NULL THEN
            L_V_DUPLICATE_ERROR := L_CUR_DUP_STOWAGE_POS_REC.STOWAGE_POSITION;
          ELSE
            L_V_DUPLICATE_ERROR := L_V_DUPLICATE_ERROR || ', ' ||
                                   L_CUR_DUP_STOWAGE_POS_REC.STOWAGE_POSITION;
          END IF;
        END LOOP;
      END IF;

      /* * check for discharge list * */
      IF P_I_V_FLAG = DISCHARGE_LIST THEN
        FOR L_CUR_DUP_STOWAGE_POS_REC IN L_CUR_DUP_STOWAGE_POS_DL
        LOOP
          L_V_FLG_DATA_FOUND := TRUE;
          IF L_V_DUPLICATE_ERROR IS NULL THEN
            L_V_DUPLICATE_ERROR := L_CUR_DUP_STOWAGE_POS_REC.STOWAGE_POSITION;
          ELSE
            L_V_DUPLICATE_ERROR := L_V_DUPLICATE_ERROR || ', ' ||
                                   L_CUR_DUP_STOWAGE_POS_REC.STOWAGE_POSITION;
          END IF;
        END LOOP;
      END IF;
    END IF;

    /* * check if duplicate found * */
    IF L_V_DUPLICATE_ERROR IS NOT NULL THEN
      P_O_V_ERR_CD := 'EDL.SE0168' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      L_V_DUPLICATE_ERROR || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
    END IF;

    DBMS_OUTPUT.PUT_LINE(P_O_V_ERR_CD);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END PRE_CHECK_DUP_CELL_LOCATION;

  /* *24 end * */

  /* *26 start * */
  PROCEDURE PRE_BUNDLE_UPDATE_VALIDATION(P_I_V_LIST_ID  VARCHAR2
                                        ,P_I_V_FLAG     VARCHAR2
                                        ,P_O_V_BOOKINGS OUT VARCHAR2) AS

    --SET SERVEROUTPUT ON ;
    --
    --DECLARE
    --    P_I_V_LIST_ID VARCHAR2(100) DEFAULT 128043;
    --    P_I_V_FLAG VARCHAR2(2) DEFAULT 'DL';
    --    P_O_V_BOOKINGS VARCHAR2(5) ;

    L_V_IS_VALIDATE  VARCHAR2(5) DEFAULT 'FALSE';
    L_V_BOOKING_LIST VARCHAR2(4000);
    L_V_SQL_ID       VARCHAR2(10);
    TERMIANL_NOT_IN_CONFIG EXCEPTION;
    INVALID_BOOKING_FOUND_EXP EXCEPTION;
    ACTIVE                   CONSTANT VARCHAR2(1) DEFAULT 'A';
    BUNDLE                   CONSTANT VARCHAR2(1) DEFAULT 'P';
    BASE                     CONSTANT VARCHAR2(1) DEFAULT 'B';
    TOS_BUNDLE_FLATRACK_MODE CONSTANT VARCHAR2(30) DEFAULT 'TOS_BUNDLE_FLATRACK_MODE';
    EBP                      CONSTANT VARCHAR2(3) DEFAULT 'EBP';
    SEP                      CONSTANT VARCHAR2(3) DEFAULT '~';
    TRUE                     CONSTANT VARCHAR2(5) DEFAULT 'TRUE';
    FALSE                    CONSTANT VARCHAR2(5) DEFAULT 'FALSE';
    /* * Constant declaratin end * */

  BEGIN
    /* *1 */

    L_V_SQL_ID := 'SQL-1-01';

    IF P_I_V_FLAG = LOAD_LIST THEN
      /* i1 * */
      /*  Check terminal found in config table or not and configuration code is EBP or not */

      L_V_SQL_ID := 'SQL-1-02';

      BEGIN
        /* b1 * */
        SELECT TRUE
          INTO L_V_IS_VALIDATE
          FROM TOS_LL_LOAD_LIST LL
         WHERE LL.PK_LOAD_LIST_ID = P_I_V_LIST_ID
           AND LL.RECORD_STATUS = ACTIVE
           AND NOT EXISTS
         (SELECT 1
                  FROM VASAPPS.VCM_CONFIG_MST VCM
                 WHERE VCM.CONFIG_TYP = TOS_BUNDLE_FLATRACK_MODE
                   AND VCM.CONFIG_CD = LL.DN_TERMINAL
                   AND VCM.STATUS = ACTIVE
                   AND VCM.CONFIG_VALUE <> EBP);
      EXCEPTION
        /* b1 * */
        WHEN NO_DATA_FOUND THEN
          L_V_IS_VALIDATE := FALSE;
          RAISE TERMIANL_NOT_IN_CONFIG;
        WHEN OTHERS THEN
          L_V_IS_VALIDATE := FALSE;
      END; /* b1 * */

      L_V_SQL_ID := 'SQL-1-03';

      /*  Check if there's the bundle booking then sytem need to check that
      for one booking there must be at least one container update the
      Load_Status as 'Base' */
      IF L_V_IS_VALIDATE = TRUE THEN
        /* i2 * */

        L_V_SQL_ID := 'SQL-1-04';

        BEGIN
          /* b2 */
          SELECT SUBSTR(SYS_CONNECT_BY_PATH(BOOKING_NO, ','), 2, 4000)
            INTO L_V_BOOKING_LIST
            FROM (SELECT BOOKING_NO
                        ,ROWNUM ID
                        ,RANK() OVER(ORDER BY ROWNUM DESC) R
                    FROM (SELECT DISTINCT FK_BOOKING_NO AS "BOOKING_NO"
                            FROM TOS_LL_BOOKED_LOADING T1
                           WHERE T1.RECORD_STATUS = ACTIVE
                             AND T1.LOAD_CONDITION = BUNDLE
                             AND T1.FK_LOAD_LIST_ID = P_I_V_LIST_ID
                             AND NOT EXISTS
                           (SELECT 1
                                    FROM TOS_LL_BOOKED_LOADING T2
                                   WHERE T2.FK_BOOKING_NO = T1.FK_BOOKING_NO
                                     AND T2.FK_LOAD_LIST_ID = P_I_V_LIST_ID
                                     AND T2.RECORD_STATUS = ACTIVE
                                     AND T2.LOAD_CONDITION = BASE)))
           WHERE R = 1
             AND ROWNUM = 1
          CONNECT BY PRIOR ID = ID - 1;

          DBMS_OUTPUT.PUT_LINE('Invalid booking: ' || L_V_BOOKING_LIST);

          P_O_V_BOOKINGS := L_V_BOOKING_LIST;

        EXCEPTION
          /* b2 */
          WHEN NO_DATA_FOUND THEN
            NULL;
            DBMS_OUTPUT.PUT_LINE('ALL BOOKINGS ARE OKAY');
          WHEN OTHERS THEN
            RETURN;
            /* * LOG ERROR * */

        END; /* b2 */

      END IF; /* i2 * */
    ELSIF P_I_V_FLAG = DISCHARGE_LIST THEN
      /* i1 * */

      L_V_SQL_ID := 'SQL-1-05';

      /*  Check terminal found in config table or not and configuration code is EBP or not */
      BEGIN
        /* b3 */

        SELECT TRUE
          INTO L_V_IS_VALIDATE
          FROM TOS_DL_DISCHARGE_LIST DL
         WHERE DL.PK_DISCHARGE_LIST_ID = P_I_V_LIST_ID
           AND DL.RECORD_STATUS = ACTIVE
           AND NOT EXISTS
         (SELECT 1
                  FROM VASAPPS.VCM_CONFIG_MST VCM
                 WHERE VCM.CONFIG_TYP = TOS_BUNDLE_FLATRACK_MODE
                   AND VCM.CONFIG_CD = DL.DN_TERMINAL
                   AND VCM.STATUS = ACTIVE
                   AND VCM.CONFIG_VALUE <> EBP);

      EXCEPTION
        /* b3 */
        WHEN NO_DATA_FOUND THEN
          L_V_IS_VALIDATE := FALSE;
          RAISE TERMIANL_NOT_IN_CONFIG;
        WHEN OTHERS THEN
          L_V_IS_VALIDATE := FALSE;

      END; /* b3 */

      L_V_SQL_ID := 'SQL-1-06';

      /*  Check if there's the bundle booking then sytem need to check that
      for one booking there must be at least one container update the
      Load_Status as 'Base' */
      IF L_V_IS_VALIDATE = TRUE THEN
        /* i4 * */

        BEGIN
          /* b4 */
          SELECT SUBSTR(SYS_CONNECT_BY_PATH(BOOKING_NO, ','), 2, 4000)
            INTO L_V_BOOKING_LIST
            FROM (SELECT BOOKING_NO
                        ,ROWNUM ID
                        ,RANK() OVER(ORDER BY ROWNUM DESC) R
                    FROM (SELECT DISTINCT FK_BOOKING_NO BOOKING_NO
                            FROM TOS_DL_BOOKED_DISCHARGE T1
                           WHERE T1.RECORD_STATUS = ACTIVE
                             AND T1.LOAD_CONDITION = BUNDLE
                             AND T1.FK_DISCHARGE_LIST_ID = P_I_V_LIST_ID
                             AND NOT EXISTS
                           (SELECT 1
                                    FROM TOS_DL_BOOKED_DISCHARGE T2
                                   WHERE T2.FK_BOOKING_NO = T1.FK_BOOKING_NO
                                     AND T2.FK_DISCHARGE_LIST_ID =
                                         P_I_V_LIST_ID
                                     AND T2.RECORD_STATUS = ACTIVE
                                     AND T2.LOAD_CONDITION = BASE)))
           WHERE R = 1
             AND ROWNUM = 1
          CONNECT BY PRIOR ID = ID - 1;

          DBMS_OUTPUT.PUT_LINE('Invalid booking: ' || L_V_BOOKING_LIST);
          P_O_V_BOOKINGS := L_V_BOOKING_LIST;
        EXCEPTION
          /* b4 */
          WHEN NO_DATA_FOUND THEN
            NULL;
            DBMS_OUTPUT.PUT_LINE('ALL BOOKINGS ARE OKAY');
          WHEN OTHERS THEN
            NULL;
        END; /* b4 */
      END IF; /* i4 * */

      L_V_SQL_ID := 'SQL-1-07';

    END IF; /* i1 * */

  EXCEPTION

    WHEN TERMIANL_NOT_IN_CONFIG THEN
      NULL;
    WHEN OTHERS THEN
      NULL;
  END PRE_BUNDLE_UPDATE_VALIDATION; /* *1 */
/* *26 end * */
END PCE_EDL_DLMAINTENANCE;
