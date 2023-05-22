create or replace
PACKAGE BODY           "PCE_ELL_LLMAINTENANCE" AS
  G_V_SQL VARCHAR2(10000);
  GLOB_EXCEPTION EXCEPTION;
  G_V_ORA_ERR_CD  VARCHAR2(10);
  G_V_USER_ERR_CD VARCHAR2(10);
  L_EXCP_FINISH EXCEPTION;
  G_V_WARNING VARCHAR2(100);
  L_DUPLICATE_STOW_EXCPTION EXCEPTION; -- *10
  G_V_DUPLICATE_STOW_ERR VARCHAR2(4000); -- *10, *12

  C_OPEN            VARCHAR2(2) DEFAULT '0';
  LOADING_COMPLETE  VARCHAR2(2) DEFAULT '10';
  READY_FOR_INVOICE VARCHAR2(2) DEFAULT '20';
  WORK_COMPLETE     VARCHAR2(2) DEFAULT '30';
  LL_DL_FLAG        VARCHAR2(1) DEFAULT 'L';
  BLANK CONSTANT VARCHAR2(1) DEFAULT NULL; --*18
  G_V_LOAD_CMPLT_STS_CHK VARCHAR2(2) DEFAULT '10';

  /*
         *2:  Modified by vikas, if shipment term is 'UC' then no need to
              check COC contianer, as k'chatgamol, 09.03.2012
         *3:  Modified by vikas,When updating load list status and cell location is blank then
              don't update list status, as k'chatgamol, 09.03.2012
         *4:  Added by vikas,stowage position as search criteria in
              booked tab, as k'chatgamol, 12.03.2012
         *5:  Added by vikas,Don't check blank stowage position for AFS and DFS service,
              as k'chatgamol,12.03.2012
         *6:  Added by vikas,Ex-mlo_vessel and ex_mlo_voyage as search criteria in
              booked tab, as k'chatgamol, 13.03.2012
         *7:  Modified by vikas, when changing load list status, allow blank cell location
              for ss,  as k'chatgamol, 15.03.2012
         *8:  Added by vikas, to get cran value in booked tab, as k'chatamol, 27.03.2012
         *9:  Added by leena, to add port and terminal as search criteria in maintenance screen,
              k'chatgamol, 09.04.2012
         *10: Modified by Vikas, When duplicte stowage position found then save changes and
              then show error msg, suggested by k'chatgamol, 19.04.2012
         *11: Modified by Leena to show the ROB containers in summary tab  23.04.2012
         *12: Modified by vikas, when too many duplicate cell location then error
              shows oracle exception, 08.05.2012.
         *13: Modifed by vikas, When list status is change to higher then 10 then log
              into the table. For the first time only, as k'chatgamol, 08.06.2012
         *14: Modified by vikas, All bookings in the DL/LL must be closed if status is changed to
             'Ready for Invoice' and 'Work Complete', as k'chatgamol, 12.06.2012
         *15: Modified by Leena, Set the local status non editable in Load list maintenance screen
              as k'chatgamol, 26.06.2012
         *16: Modified by vikas, When previous load list not found then show error msg
              Service, Vessel and Voyage information not match with present load list for equipment#,
              as k'chatgamol, 21.09.2012
         *17: Modified by vikas, When load list status changed from open to load complete
             (10 or more then 10) than, update load list status in discharge list booked table.
              and update Copy DG, OOG, REEFER details from load list to discharge list detail tablelist,
              as k'chatgamol, 08.10.2012
         *18: Modified by vikas, for special handl DG, OOG enable dg update and for normal
              check the size type is RE/RH then update dg details, as k'chatgamol, 26.11.2012
         *19: Modified by vikas, When changing list status from open to load complete or higher,
              check duplicate cell location, as k'chatgamol, 27.12.2012
         *20: Issue fix by vikas, Suspended records is also showing in search result for
              duplicate stowage position, booked table, as k'chatgamol, guru, 26.12.2012
         *21: Added by vikas, When update the load/Discharge list status  > Loading Complete
              System need to check if there???s the bundle booking then, Check the
              configuration table to check the type of bundle calculation/terminal,
              If no terminal found or it???s not = "EBP" then sytem need to check that
              for one booking there must be at least one container update the
              Load_Status as "Base", as k'chatgamol, 15.01.2013
         *22: Modified by vikas, send enotice only when list staus is not open
              as k'chatgamol, 16.01.2013
         *23: Modified by vikas, modify logic to get next discharge list, as k'chatgamol,
              11.06.2013
         *24: Modified by Leena, Commented the portclass and variant validation, and
              added port class type validation when saved from screen through booked and overshipped tab
         *25: Commented the code which will show the error Record updated by another user,
              as it was throwing this error if tried to edit and save without a find operation
              after first save
         *26: Modified by Leena, Log the port class changes done from screen. 17.02.2014
         *27: Modified by RAJA Log the IMDG,UNNO,VAR changes done from screen.12.02.2015
         *28: 4 APR 2016, Wutiporn K., Validate EMS and Terminal code.
        *29 02/06/16  Saisuda CR new VGM and Category  Add new column VGM and Category  at Booking tab for query data from tmp table (PRE_ELL_BOOKED_TAB_FIND).
                                                                              Add new column VGM,Category and First_leg_flag at Booking tab for insert data to tmp table (PRV_ELL_SET_BOOKING_TO_TEMP).
                                                                              Add new parameter VGM,Category and First_leg_flag for insert data (PRE_ELL_SYNCH_BOOKING)
        *30 : 6 JUN 2016, Nuttapol T., Comment validation for EDL.SE0189
        *31 : 11/07/2016  ,Saisuda , As per Guru's request (on 5.07.2016), to stamp first complete dtae/user whenever LL/DL status changed to Loading complete.
        *32 : 25/07/2016, Watcharee C. if nothing chnage for Weight then return NULL i/o 0.
        *33 : 09/08/2016, Pongkeit A. Remove FIRST_LEG Condition.
        *34 : 16/08/2016, Watcharee C. Add field VGM back & allow to complete EZLL if shipment type is UC and loading status = SS
                          as per K.Chatgamol advise.
        *35 : 06/09/2016, Watcharee C. If select No category in ezll, will flow back in bkp009 with  blank 
		*36 : 20/06/2017,  NIIT .System should show error message while completing EZLL , if any booking has status as open or waitlisted that  have POL service/vesse/voyage/port/terminal  same as  EZLL service/vesse/voyage/port/terminal
  */
  G_V_LOAD_LIST_ID TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE; -- *4
  PROCEDURE PRV_ELL_SET_BOOKING_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                       ,P_I_V_LOAD_LIST_ID IN VARCHAR2
                                       ,P_I_V_USER_ID      IN VARCHAR2
                                       ,P_O_V_ERR_CD       OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    DELETE FROM TOS_LL_BOOKED_LOADING_TMP
     WHERE SESSION_ID = P_I_V_SESSION_ID;

    INSERT INTO TOS_LL_BOOKED_LOADING_TMP
      (SEQ_NO
      ,SESSION_ID
      ,PK_BOOKED_LOADING_ID
      ,FK_LOAD_LIST_ID
      ,CONTAINER_SEQ_NO
      ,FK_BOOKING_NO
      ,FK_BKG_SIZE_TYPE_DTL
      ,FK_BKG_SUPPLIER
      ,FK_BKG_EQUIPM_DTL
      ,DN_EQUIPMENT_NO
      ,EQUPMENT_NO_SOURCE
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
      ,LOADING_STATUS
      ,STOWAGE_POSITION
      ,ACTIVITY_DATE_TIME
      ,CONTAINER_GROSS_WEIGHT
      ,DAMAGED
      ,VOID_SLOT
      ,PREADVICE_FLAG
      ,FK_SLOT_OPERATOR
      ,FK_CONTAINER_OPERATOR
      ,OUT_SLOT_OPERATOR
      ,DN_SPECIAL_HNDL
      ,SEAL_NO
      ,DN_DISCHARGE_PORT
      ,DN_DISCHARGE_TERMINAL
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
      ,EX_MLO_VESSEL
      ,EX_MLO_VESSEL_ETA
      ,EX_MLO_VOYAGE
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
      ,REEFER_TMP
      ,REEFER_TMP_UNIT
      ,DN_HUMIDITY
      ,DN_VENTILATION
      ,PUBLIC_REMARK
      ,CRANE_TYPE -- *8
      ,RECORD_CHANGE_USER
      ,RECORD_CHANGE_DATE
      --*29 begin
      ,VGM --*34
      ,CATEGORY_CODE
      ,FIRST_LEG_FLAG
      --*29 end
      )
      (SELECT ROW_NUMBER() OVER(ORDER BY PK_BOOKED_LOADING_ID)
             ,P_I_V_SESSION_ID
             ,PK_BOOKED_LOADING_ID
             ,FK_LOAD_LIST_ID
             ,CONTAINER_SEQ_NO
             ,FK_BOOKING_NO
             ,FK_BKG_SIZE_TYPE_DTL
             ,FK_BKG_SUPPLIER
             ,FK_BKG_EQUIPM_DTL
             ,DN_EQUIPMENT_NO
             ,EQUPMENT_NO_SOURCE
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
             ,LOADING_STATUS
             ,STOWAGE_POSITION
             ,TO_CHAR(ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
             ,CONTAINER_GROSS_WEIGHT
             ,DAMAGED
             ,VOID_SLOT
             ,PREADVICE_FLAG
             ,FK_SLOT_OPERATOR
             ,FK_CONTAINER_OPERATOR
             ,OUT_SLOT_OPERATOR
             ,DN_SPECIAL_HNDL
             ,SEAL_NO
             ,DN_DISCHARGE_PORT
             ,DN_DISCHARGE_TERMINAL
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
             ,EX_MLO_VESSEL
             ,TO_CHAR(EX_MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
             ,EX_MLO_VOYAGE
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
             ,REEFER_TMP
             ,REEFER_TMP_UNIT
             ,DN_HUMIDITY
             ,DN_VENTILATION
             ,PUBLIC_REMARK
             ,CRANE_TYPE -- *8
             ,RECORD_CHANGE_USER
             ,RECORD_CHANGE_DATE
              --*29 begin
              ,VGM --*34
              ,CATEGORY_CODE
              --COMMENT FOR CHANGE LOGIC NO FIRST LEG BY PONAPR1 *33
              --,NVL(FIRST_LEG_FLAG,'N')
              ,'Y'
              --*29 end
         FROM TOS_LL_BOOKED_LOADING
        WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
          AND RECORD_STATUS = 'A') ORDER BY PK_BOOKED_LOADING_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRV_ELL_SET_BOOKING_TO_TEMP;

  PROCEDURE PRV_ELL_SET_OVERSHIP_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                        ,P_I_V_LOAD_LIST_ID IN VARCHAR2
                                        ,P_I_V_USER_ID      IN VARCHAR2
                                        ,P_O_V_ERR_CD       OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    DELETE FROM TOS_LL_OVERSHIPPED_CONT_TMP
     WHERE SESSION_ID = P_I_V_SESSION_ID;

    INSERT INTO TOS_LL_OVERSHIPPED_CONT_TMP
      (SEQ_NO
      ,SESSION_ID
      ,PK_OVERSHIPPED_CONTAINER_ID
      ,FK_LOAD_LIST_ID
      ,BOOKING_NO
      ,BOOKING_NO_SOURCE
      ,EQUIPMENT_NO
      ,EQUIPMENT_NO_QUESTIONABLE_FLAG
      ,EQ_SIZE
      ,EQ_TYPE
      ,FULL_MT
      ,BKG_TYP
      ,FLAG_SOC_COC
      ,SHIPMENT_TERM
      ,SHIPMENT_TYPE
      ,LOCAL_STATUS
      ,LOCAL_TERMINAL_STATUS
      ,MIDSTREAM_HANDLING_CODE
      ,LOAD_CONDITION
      ,STOWAGE_POSITION
      ,ACTIVITY_DATE_TIME
      ,CONTAINER_GROSS_WEIGHT
      ,DAMAGED
      ,VOID_SLOT
      ,PREADVICE_FLAG
      ,SLOT_OPERATOR
      ,CONTAINER_OPERATOR
      ,OUT_SLOT_OPERATOR
      ,SPECIAL_HANDLING
      ,SEAL_NO
      ,DISCHARGE_PORT
      ,POD_TERMINAL
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
      ,EX_MLO_VESSEL
      ,EX_MLO_VESSEL_ETA
      ,EX_MLO_VOYAGE
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
      ,PORT_CLASS_TYPE
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
      ,RECORD_CHANGE_USER
      ,RECORD_CHANGE_DATE
      ,VGM --*34
      )
      (SELECT ROW_NUMBER() OVER(ORDER BY PK_OVERSHIPPED_CONTAINER_ID)
             ,P_I_V_SESSION_ID
             ,PK_OVERSHIPPED_CONTAINER_ID
             ,FK_LOAD_LIST_ID
             ,BOOKING_NO
             ,BOOKING_NO_SOURCE
             ,EQUIPMENT_NO
             ,EQUIPMENT_NO_QUESTIONABLE_FLAG
             ,EQ_SIZE
             ,EQ_TYPE
             ,FULL_MT
             ,BKG_TYP
             ,FLAG_SOC_COC
             ,SHIPMENT_TERM
             ,SHIPMENT_TYPE
             ,LOCAL_STATUS
             ,LOCAL_TERMINAL_STATUS
             ,MIDSTREAM_HANDLING_CODE
             ,LOAD_CONDITION
             ,STOWAGE_POSITION
             ,TO_CHAR(ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
             ,CONTAINER_GROSS_WEIGHT
             ,DAMAGED
             ,VOID_SLOT
             ,PREADVICE_FLAG
             ,SLOT_OPERATOR
             ,CONTAINER_OPERATOR
             ,OUT_SLOT_OPERATOR
             ,SPECIAL_HANDLING
             ,SEAL_NO
             ,DISCHARGE_PORT
             ,POD_TERMINAL
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
             ,EX_MLO_VESSEL
             ,TO_CHAR(EX_MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
             ,EX_MLO_VOYAGE
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
             ,PORT_CLASS_TYPE
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
             ,RECORD_CHANGE_USER
             ,RECORD_CHANGE_DATE
             ,VGM --*34
         FROM TOS_LL_OVERSHIPPED_CONTAINER
        WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
          AND RECORD_STATUS = 'A') ORDER BY PK_OVERSHIPPED_CONTAINER_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRV_ELL_SET_OVERSHIP_TO_TEMP;

  PROCEDURE PRV_ELL_SET_RESTOW_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                      ,P_I_V_LOAD_LIST_ID IN VARCHAR2
                                      ,P_I_V_USER_ID      IN VARCHAR2
                                      ,P_O_V_ERR_CD       OUT VARCHAR2) AS

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

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
      ,RECORD_CHANGE_DATE)
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
        WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
          AND RECORD_STATUS = 'A') ORDER BY PK_RESTOW_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRV_ELL_SET_RESTOW_TO_TEMP;

  PROCEDURE PRV_ELL_CLR_TMP(P_I_V_SESSION_ID IN VARCHAR2
                           ,P_I_V_USER_ID    IN VARCHAR2
                           ,P_O_V_ERR_CD     OUT VARCHAR2) AS
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    DELETE FROM TOS_LL_BOOKED_LOADING_TMP
     WHERE SESSION_ID = P_I_V_SESSION_ID;

    DELETE FROM TOS_LL_OVERSHIPPED_CONT_TMP
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
  END PRV_ELL_CLR_TMP;

  PROCEDURE PRE_ELL_BOOKED_TAB_FIND(P_O_REFBOOKEDTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                   ,P_I_V_SESSION_ID     IN VARCHAR2
                                   ,P_I_V_FIND1          IN VARCHAR2
                                   ,P_I_V_IN1            IN VARCHAR2
                                   ,P_I_V_FIND2          IN VARCHAR2
                                   ,P_I_V_IN2            IN VARCHAR2
                                   ,P_I_V_ORDER1         IN VARCHAR2
                                   ,P_I_V_ORDER1ORDER    IN VARCHAR2
                                   ,P_I_V_ORDER2         IN VARCHAR2
                                   ,P_I_V_ORDER2ORDER    IN VARCHAR2
                                   ,P_I_V_LOAD_LIST_ID   IN VARCHAR2
                                   ,P_O_V_TOT_REC        OUT VARCHAR2
                                   ,P_O_V_ERROR          OUT VARCHAR2) AS

    L_V_SQL_SORT_ORDER VARCHAR2(4000);
    L_V_ERR            VARCHAR2(5000);
    /* Open if required for debugging
    l_v_SQL_1 varchar2(4000);
    l_v_SQL_2 varchar2(4000);
    l_v_SQL_3 varchar2(4000);
    */
  BEGIN

    /* Set Success Code*/
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /* Set Total Record to Default -1  */
    P_O_V_TOT_REC := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

    /*
        *4: Reset value of globle discharge list variable
    */
    G_V_LOAD_LIST_ID := P_I_V_LOAD_LIST_ID;

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
                            'TOS_LL_BOOKED_LOADING.fk_booking_no
                , TOS_LL_BOOKED_LOADING.dn_eq_size
                , TOS_LL_BOOKED_LOADING.dn_eq_type
                , TOS_LL_BOOKED_LOADING.dn_equipment_no';
    END IF;

    /* Construct the SQL */
    G_V_SQL := ' SELECT TOS_LL_BOOKED_LOADING.SEQ_NO,
            TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO CONTAINER_SEQ_NO ,
            TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID PK_BOOKED_LOADING_ID,
            TOS_LL_BOOKED_LOADING.FK_BOOKING_NO FK_BOOKING_NO ,
            TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO DN_EQUIPMENT_NO ,
            CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP002.TYBLNO
                FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
                WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
                AND    IDP055.EYBLNO  = IDP010.AYBLNO
                AND    IDP002.TYBLNO  = IDP010.AYBLNO
                AND    IDP010.AYSTAT  >=1
                AND    IDP010.AYSTAT  <=6
                AND    IDP010.PART_OF_BL IS NULL
                AND    IDP002.TYBKNO  = FK_BOOKING_NO
                AND    IDP055.EYEQNO  = DN_EQUIPMENT_NO
                AND ROWNUM=''1'')
            ELSE
                ''''
            END BLNO,
            TOS_LL_BOOKED_LOADING.DN_EQ_SIZE DN_EQ_SIZE ,
            TOS_LL_BOOKED_LOADING.DN_EQ_TYPE DN_EQ_TYPE ,
            DECODE(TOS_LL_BOOKED_LOADING.DN_FULL_MT,''F'',''Full'',''E'',''Empty'') DN_FULL_MT ,
            DECODE(TOS_LL_BOOKED_LOADING.DN_BKG_TYP,''N'',''Normal'',''ER'',''Empty Repositioning'',''FC'',''Feeder Cargo'') DN_BKG_TYP ,
            DECODE(TOS_LL_BOOKED_LOADING.DN_SOC_COC,''S'',''SOC'',''C'',''COC'') DN_SOC_COC ,
            TOS_LL_BOOKED_LOADING.DN_SHIPMENT_TERM DN_SHIPMENT_TERM ,
            TOS_LL_BOOKED_LOADING.DN_SHIPMENT_TYP DN_SHIPMENT_TYP ,
            --TOS_LL_BOOKED_LOADING.LOCAL_STATUS LOCAL_STATUS , --*15
            DECODE(TOS_LL_BOOKED_LOADING.LOCAL_STATUS,''L'',''Local'',''T'',''Transhipment'') LOCAL_STATUS , --*15
            TOS_LL_BOOKED_LOADING.LOCAL_TERMINAL_STATUS LOCAL_TERMINAL_STATUS ,
            TOS_LL_BOOKED_LOADING.MIDSTREAM_HANDLING_CODE MIDSTREAM_HANDLING_CODE ,
            TOS_LL_BOOKED_LOADING.LOAD_CONDITION LOAD_CONDITION ,
            TOS_LL_BOOKED_LOADING.LOADING_STATUS LOADING_STATUS ,
            TOS_LL_BOOKED_LOADING.STOWAGE_POSITION STOWAGE_POSITION ,
            TOS_LL_BOOKED_LOADING.ACTIVITY_DATE_TIME ACTIVITY_DATE_TIME ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT, ''FM9,99,99,99,99,990.00'') CONTAINER_GROSS_WEIGHT ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.VGM, ''FM9,99,99,99,99,990.00'') AS VGM ,
            TOS_LL_BOOKED_LOADING.CATEGORY_CODE CATEGORY_CODE,
            --NVL(TOS_LL_BOOKED_LOADING.FIRST_LEG_FLAG,''N'') AS FIRST_LEG_FLAG, ---** when steam come back, please use this record
            ''Y'' AS FIRST_LEG_FLAG,  ---** when steam come back, please remove this record
            TOS_LL_BOOKED_LOADING.DAMAGED DAMAGED ,
            DECODE(TOS_LL_BOOKED_LOADING.VOID_SLOT,0,'''', TOS_LL_BOOKED_LOADING.VOID_SLOT) VOID_SLOT ,
            TOS_LL_BOOKED_LOADING.FK_SLOT_OPERATOR FK_SLOT_OPERATOR ,
            TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR ,
            TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR OUT_SLOT_OPERATOR ,
            DECODE(TOS_LL_BOOKED_LOADING.DN_SPECIAL_HNDL,''O0'',''OOG''               ,
                                                         ''D1'',''DG''                ,
                                                         ''N'',''Normal''             ,
                                                         ''DA'',''Door Ajar''         ,
                                                         ''OD'',''Open Door''         ,
                                                         ''NR'',''Non Reefer'') DN_SPECIAL_HNDL ,
            TOS_LL_BOOKED_LOADING.SEAL_NO SEAL_NO ,
            TOS_LL_BOOKED_LOADING.DN_DISCHARGE_PORT  DN_DISCHARGE_PORT ,
            TOS_LL_BOOKED_LOADING.DN_DISCHARGE_TERMINAL DN_DISCHARGE_TERMINAL ,
            TOS_LL_BOOKED_LOADING.DN_NXT_POD1 DN_NXT_POD1 ,
            TOS_LL_BOOKED_LOADING.DN_NXT_POD2 DN_NXT_POD2 ,
            TOS_LL_BOOKED_LOADING.DN_NXT_POD3 DN_NXT_POD3 ,
            TOS_LL_BOOKED_LOADING.DN_FINAL_POD DN_FINAL_POD ,
            TOS_LL_BOOKED_LOADING.FINAL_DEST FINAL_DEST ,
            TOS_LL_BOOKED_LOADING.DN_NXT_SRV DN_NXT_SRV ,
            TOS_LL_BOOKED_LOADING.DN_NXT_VESSEL DN_NXT_VESSEL ,
            TOS_LL_BOOKED_LOADING.DN_NXT_VOYAGE DN_NXT_VOYAGE ,
            TOS_LL_BOOKED_LOADING.DN_NXT_DIR DN_NXT_DIR ,
            TOS_LL_BOOKED_LOADING.MLO_VESSEL MLO_VESSEL ,
            TOS_LL_BOOKED_LOADING.MLO_VOYAGE MLO_VOYAGE ,
            TOS_LL_BOOKED_LOADING.MLO_VESSEL_ETA MLO_VESSEL_ETA ,
            TOS_LL_BOOKED_LOADING.MLO_POD1 MLO_POD1 ,
            TOS_LL_BOOKED_LOADING.MLO_POD2 MLO_POD2 ,
            TOS_LL_BOOKED_LOADING.MLO_POD3 MLO_POD3 ,
            TOS_LL_BOOKED_LOADING.MLO_DEL MLO_DEL ,
            TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1 FK_HANDLING_INSTRUCTION_1 ,
            HI1.SHI_DESCRIPTION HANDLING_DISCRIPTION_1,
            TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2 FK_HANDLING_INSTRUCTION_2 ,
            HI2.SHI_DESCRIPTION HANDLING_DISCRIPTION_2,
            TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3 FK_HANDLING_INSTRUCTION_3 ,
            HI3.SHI_DESCRIPTION HANDLING_DISCRIPTION_3,
            TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1 CONTAINER_LOADING_REM_1 ,
            TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2 CONTAINER_LOADING_REM_2 ,
            TOS_LL_BOOKED_LOADING.FK_SPECIAL_CARGO FK_SPECIAL_CARGO ,
            NVL(TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG1,''N'') TIGHT_CONNECTION_FLAG1 ,
            NVL(TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG2,''N'') TIGHT_CONNECTION_FLAG2 ,
            NVL(TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG3,''N'') TIGHT_CONNECTION_FLAG3 ,
            TOS_LL_BOOKED_LOADING.FK_IMDG FK_IMDG ,
            TOS_LL_BOOKED_LOADING.FK_UNNO FK_UNNO ,
            TOS_LL_BOOKED_LOADING.FK_UN_VAR FK_UN_VAR ,
            TOS_LL_BOOKED_LOADING.FK_PORT_CLASS FK_PORT_CLASS ,
            TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP FK_PORT_CLASS_TYP ,
            TOS_LL_BOOKED_LOADING.FLASH_UNIT FLASH_UNIT ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.FLASH_POINT, ''FM990.000'') FLASH_POINT ,
            TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY FUMIGATION_ONLY,
            TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG RESIDUE_ONLY_FLAG ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.OVERHEIGHT_CM, ''FM9,999,999,990.0000'') OVERHEIGHT_CM ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.OVERWIDTH_LEFT_CM, ''FM9,999,999,990.0000'') OVERWIDTH_LEFT_CM ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.OVERWIDTH_RIGHT_CM, ''FM9,999,999,990.0000'') OVERWIDTH_RIGHT_CM ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.OVERLENGTH_FRONT_CM, ''FM9,999,999,990.0000'') OVERLENGTH_FRONT_CM ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.OVERLENGTH_REAR_CM, ''FM9,999,999,990.0000'') OVERLENGTH_REAR_CM ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.REEFER_TMP, ''FM990.000'') REEFER_TEMPERATURE ,
            TOS_LL_BOOKED_LOADING.REEFER_TMP_UNIT REEFER_TMP_UNIT ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.DN_HUMIDITY, ''FM990.00'')  DN_HUMIDITY ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.DN_VENTILATION, ''FM990.00'')   DN_VENTILATION ,
            TOS_LL_BOOKED_LOADING.PUBLIC_REMARK PUBLIC_REMARK,
            TOS_LL_BOOKED_LOADING.OPN_STATUS,
            TOS_LL_BOOKED_LOADING.RECORD_CHANGE_DATE,
            TOS_LL_BOOKED_LOADING.EQUPMENT_NO_SOURCE,
            DECODE(TOS_LL_BOOKED_LOADING.PREADVICE_FLAG,''Y'',''Yes'',''N'',''No'')    PREADVICE_FLAG,
            TOS_LL_BOOKED_LOADING.EX_MLO_VESSEL,
            TOS_LL_BOOKED_LOADING.EX_MLO_VOYAGE,
            TOS_LL_BOOKED_LOADING.EX_MLO_VESSEL_ETA,
            (SELECT TRREFR FROM ITP075 WHERE TRTYPE = DN_EQ_TYPE) REEFER_FLAG,
            CRANE_TYPE CRANE_DESCRIPTION,
            PCE_ECM_SYNC_BOOKING_EZLL.FN_CAN_UPDATE_DG(
                TOS_LL_BOOKED_LOADING.DN_SPECIAL_HNDL,
                TOS_LL_BOOKED_LOADING.DN_EQ_TYPE
            ) AS "IS_UPDATE_DG"
            FROM
            TOS_LL_BOOKED_LOADING_TMP TOS_LL_BOOKED_LOADING,
            SHP007 HI1,
            SHP007 HI2,
            SHP007 HI3
            WHERE (TOS_LL_BOOKED_LOADING.OPN_STATUS IS NULL OR
                   TOS_LL_BOOKED_LOADING.OPN_STATUS <> ''' ||
               PCE_EUT_COMMON.G_V_REC_DEL || ''')
            AND   TOS_LL_BOOKED_LOADING.SESSION_ID = ''' ||
               P_I_V_SESSION_ID || '''
            AND FK_HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
            AND FK_HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
            AND FK_HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
            AND TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID = ''' ||
               P_I_V_LOAD_LIST_ID || '''';


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
  END PRE_ELL_BOOKED_TAB_FIND;

  PROCEDURE PRE_ELL_OVERSHIPPED_TAB_FIND(P_O_REFOVERSHIPPEDTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                        ,P_I_V_SESSION_ID          IN VARCHAR2
                                        ,P_I_V_FIND1               IN VARCHAR2
                                        ,P_I_V_IN1                 IN VARCHAR2
                                        ,P_I_V_FIND2               IN VARCHAR2
                                        ,P_I_V_IN2                 IN VARCHAR2
                                        ,P_I_V_ORDER1              IN VARCHAR2
                                        ,P_I_V_ORDER1ORDER         IN VARCHAR2
                                        ,P_I_V_ORDER2              IN VARCHAR2
                                        ,P_I_V_ORDER2ORDER         IN VARCHAR2
                                        ,P_I_V_LOAD_LIST_ID        IN VARCHAR2
                                        ,P_O_V_TOT_REC             OUT VARCHAR2
                                        ,P_O_V_ERROR               OUT VARCHAR2) AS
    L_V_SQL_SORT_ORDER VARCHAR2(4000);
    L_V_ERR            VARCHAR2(5000);
    /* Open if required for debugging
    l_v_SQL_1 varchar2(4000);
    l_v_SQL_2 varchar2(4000);
    l_v_SQL_3 varchar2(4000);
    */

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
                            'TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO
                , TOS_LL_OVERSHIPPED_CONTAINER.EQ_SIZE
                , TOS_LL_OVERSHIPPED_CONTAINER.EQ_TYPE
                , TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO';
    END IF;

    -- Construct the SQL
    G_V_SQL := ' SELECT
            ROW_NUMBER()  OVER (' || L_V_SQL_SORT_ORDER ||
               ') SR_NO,' ||
               'TOS_LL_OVERSHIPPED_CONTAINER.SEQ_NO SEQ_NO                                          ,
            TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO BOOKING_NO                                  ,
            TOS_LL_OVERSHIPPED_CONTAINER.PK_OVERSHIPPED_CONTAINER_ID PK_OVERSHIPPED_CONTAINER_ID,
            TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO EQUIPMENT_NO                              ,
            CASE WHEN TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO IS NOT NULL THEN
              ( SELECT IDP002.TYBLNO
                FROM  IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
                WHERE IDP055.EYBLNO  = IDP002.TYBLNO
                AND IDP055.EYBLNO      = IDP010.AYBLNO
                AND IDP002.TYBLNO      = IDP010.AYBLNO
                AND IDP010.AYSTAT     >=1
                AND IDP010.AYSTAT     <=6
                AND IDP010.part_of_bl IS NULL
                AND IDP002.TYBKNO      = TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO
                AND IDP055.EYEQNO      = TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO
                AND ROWNUM=''1'')
            ELSE
                ''''
            END BLNO,
            TOS_LL_OVERSHIPPED_CONTAINER.EQ_SIZE EQ_SIZE                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.EQ_TYPE EQ_TYPE                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.FULL_MT FULL_MT                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.BKG_TYP BKG_TYP                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.FLAG_SOC_COC FLAG_SOC_COC                       ,
            TOS_LL_OVERSHIPPED_CONTAINER.SHIPMENT_TERM SHIPMENT_TERM                     ,
            TOS_LL_OVERSHIPPED_CONTAINER.SHIPMENT_TYPE SHIPMENT_TYPE                     ,
            TOS_LL_OVERSHIPPED_CONTAINER.LOCAL_STATUS LOCAL_STATUS                       ,
            TOS_LL_OVERSHIPPED_CONTAINER.LOCAL_TERMINAL_STATUS LOCAL_TERMINAL_STATUS     ,
            TOS_LL_OVERSHIPPED_CONTAINER.MIDSTREAM_HANDLING_CODE MIDSTREAM_HANDLING_CODE ,
            TOS_LL_OVERSHIPPED_CONTAINER.LOAD_CONDITION LOAD_CONDITION                   ,
            TOS_LL_OVERSHIPPED_CONTAINER.STOWAGE_POSITION STOWAGE_POSITION               ,
            TOS_LL_OVERSHIPPED_CONTAINER.ACTIVITY_DATE_TIME ACTIVITY_DATE_TIME           ,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_GROSS_WEIGHT, ''FM9,99,99,99,99,990.00'') CONTAINER_GROSS_WEIGHT ,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.VGM, ''FM9,99,99,99,99,990.00'') VGM ,
            TOS_LL_OVERSHIPPED_CONTAINER.DAMAGED DAMAGED                                 ,
            DECODE(TOS_LL_OVERSHIPPED_CONTAINER.VOID_SLOT,0,'''', TOS_LL_OVERSHIPPED_CONTAINER.VOID_SLOT) VOID_SLOT              ,
            TOS_LL_OVERSHIPPED_CONTAINER.SLOT_OPERATOR SLOT_OPERATOR                     ,
            TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_OPERATOR CONTAINER_OPERATOR           ,
            TOS_LL_OVERSHIPPED_CONTAINER.OUT_SLOT_OPERATOR OUT_SLOT_OPERATOR             ,
            TOS_LL_OVERSHIPPED_CONTAINER.SPECIAL_HANDLING SPECIAL_HANDLING               ,
            TOS_LL_OVERSHIPPED_CONTAINER.SEAL_NO SEAL_NO                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.DISCHARGE_PORT DISCHARGE_PORT                   ,
            TOS_LL_OVERSHIPPED_CONTAINER.POD_TERMINAL POD_TERMINAL                       ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_POD1 NXT_POD1                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_POD2 NXT_POD2                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_POD3 NXT_POD3                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.FINAL_POD FINAL_POD                             ,
            TOS_LL_OVERSHIPPED_CONTAINER.FINAL_DEST FINAL_DEST                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_SRV NXT_SRV                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_VESSEL NXT_VESSEL                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_VOYAGE NXT_VOYAGE                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_DIR NXT_DIR                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_VESSEL MLO_VESSEL                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_VOYAGE MLO_VOYAGE                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_VESSEL_ETA MLO_VESSEL_ETA                   ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_POD1 MLO_POD1                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_POD2 MLO_POD2                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_POD3 MLO_POD3                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_DEL MLO_DEL                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_1 HANDLING_INSTRUCTION_1   ,
            HI1.SHI_DESCRIPTION HANDLING_DISCRIPTION_1                                    ,
            TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_2 HANDLING_INSTRUCTION_2   ,
            HI2.SHI_DESCRIPTION HANDLING_DISCRIPTION_2                                    ,
            TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_3 HANDLING_INSTRUCTION_3   ,
            HI3.SHI_DESCRIPTION HANDLING_DISCRIPTION_3                                    ,
            TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_LOADING_REM_1 CONTAINER_LOADING_REM_1 ,
            TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_LOADING_REM_2 CONTAINER_LOADING_REM_2 ,
            TOS_LL_OVERSHIPPED_CONTAINER.SPECIAL_CARGO SPECIAL_CARGO                     ,
            TOS_LL_OVERSHIPPED_CONTAINER.IMDG_CLASS IMDG_CLASS                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.UN_NUMBER UN_NUMBER                             ,
            TOS_LL_OVERSHIPPED_CONTAINER.UN_NUMBER_VARIANT UN_VAR                        ,
            TOS_LL_OVERSHIPPED_CONTAINER.PORT_CLASS PORT_CLASS                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.PORT_CLASS_TYPE PORT_CLASS_TYPE                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.FLASHPOINT_UNIT FLASHPOINT_UNIT                 ,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.FLASHPOINT, ''FM990.000'') FLASHPOINT   ,
            TOS_LL_OVERSHIPPED_CONTAINER.FUMIGATION_ONLY FUMIGATION_ONLY                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.RESIDUE_ONLY_FLAG RESIDUE_ONLY_FLAG             ,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.OVERHEIGHT_CM      , ''FM9,999,999,990.0000'')      OVERHEIGHT_CM,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.OVERWIDTH_LEFT_CM  , ''FM9,999,999,990.0000'')  OVERWIDTH_LEFT_CM,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.OVERWIDTH_RIGHT_CM , ''FM9,999,999,990.0000'') OVERWIDTH_RIGHT_CM,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.OVERLENGTH_FRONT_CM, ''FM9,999,999,990.0000'')OVERLENGTH_FRONT_CM,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.OVERLENGTH_REAR_CM , ''FM9,999,999,990.0000'') OVERLENGTH_REAR_CM,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.REEFER_TEMPERATURE, ''FM990.000'') REEFER_TEMPERATURE  ,
            TOS_LL_OVERSHIPPED_CONTAINER.REEFER_TMP_UNIT REEFER_TMP_UNIT                 ,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.HUMIDITY, ''FM990.00'') HUMIDITY        ,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.VENTILATION, ''FM990.00'') VENTILATION  ,
            TOS_LL_OVERSHIPPED_CONTAINER.DA_ERROR DA_ERROR                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.OPN_STATUS                                      ,
            TOS_LL_OVERSHIPPED_CONTAINER.LOADING_STATUS                                  ,
            TOS_LL_OVERSHIPPED_CONTAINER.RECORD_CHANGE_DATE                              ,
            DECODE(TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO_SOURCE, ''I'',''Manual Input'',''E'',''EDI'',''S'',''Split'') BOOKING_NO_SOURCE,
            DECODE(TOS_LL_OVERSHIPPED_CONTAINER.PREADVICE_FLAG,''Y'',''Yes'',''N'',''No'')    PREADVICE_FLAG,
            TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VESSEL                                   ,
            TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VOYAGE                                   ,
            TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VESSEL_ETA
            FROM TOS_LL_OVERSHIPPED_CONT_TMP TOS_LL_OVERSHIPPED_CONTAINER,
            SHP007 HI1,
            SHP007 HI2,
            SHP007 HI3
            WHERE (TOS_LL_OVERSHIPPED_CONTAINER.OPN_STATUS IS NULL OR
                   TOS_LL_OVERSHIPPED_CONTAINER.OPN_STATUS <> ''' ||
               PCE_EUT_COMMON.G_V_REC_DEL || ''')
            AND    TOS_LL_OVERSHIPPED_CONTAINER.SESSION_ID = ''' ||
               P_I_V_SESSION_ID || '''
            AND    HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
            AND    HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
            AND    HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
            AND    TOS_LL_OVERSHIPPED_CONTAINER.FK_LOAD_LIST_ID = ''' ||
               P_I_V_LOAD_LIST_ID || '''';

    -- Additional where clause conditions.
    IF (P_I_V_IN1 IS NOT NULL) THEN
      -- This function add the additional where clauss condtions in
      -- Dynamic sql according to the passed parameter.
      ADDITION_WHERE_CONDTIONS(TRIM(P_I_V_IN1),
                               TRIM(P_I_V_FIND1),
                               'OVERSHIPPED_TAB'); -- added trim func. 30.01.2012
    END IF;

    IF (P_I_V_IN2 IS NOT NULL) THEN
      -- This function add the additional where clauss condtions in
      -- Dynamic sql according to the passed parameter.
      ADDITION_WHERE_CONDTIONS(TRIM(P_I_V_IN2),
                               TRIM(P_I_V_FIND2),
                               'OVERSHIPPED_TAB'); -- added trim func. 30.01.2012
    END IF;

    G_V_SQL := G_V_SQL || ' ' || L_V_SQL_SORT_ORDER;

    -- Execute the SQL
    OPEN P_O_REFOVERSHIPPEDTABFIND FOR G_V_SQL;

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

  END PRE_ELL_OVERSHIPPED_TAB_FIND;

  PROCEDURE PRE_ELL_RESTOWED_TAB_FIND(P_O_REFRESTOWEDTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                     ,P_I_V_SESSION_ID       IN VARCHAR2
                                     ,P_I_V_FIND1            IN VARCHAR2
                                     ,P_I_V_IN1              IN VARCHAR2
                                     ,P_I_V_FIND2            IN VARCHAR2
                                     ,P_I_V_IN2              IN VARCHAR2
                                     ,P_I_V_ORDER1           IN VARCHAR2
                                     ,P_I_V_ORDER1ORDER      IN VARCHAR2
                                     ,P_I_V_ORDER2           IN VARCHAR2
                                     ,P_I_V_ORDER2ORDER      IN VARCHAR2
                                     ,P_I_V_LOAD_LIST_ID     IN VARCHAR2
                                     ,P_O_V_TOT_REC          OUT VARCHAR2
                                     ,P_O_V_ERROR            OUT VARCHAR2) AS
    L_V_SQL_SORT_ORDER VARCHAR2(4000);
    /* Open if required for debugging
    l_v_SQL_1 varchar2(4000);
    l_v_SQL_2 varchar2(4000);
    l_v_SQL_3 varchar2(4000);
    */
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
               ') SR_NO,' || ' TOS_RESTOW.SEQ_NO                                                 ,
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
            TOS_RESTOW.STOWAGE_POSITION STOWAGE_POSITION                        ,
            TOS_RESTOW.ACTIVITY_DATE_TIME ACTIVITY_DATE_TIME                    ,
            TO_CHAR(TOS_RESTOW.CONTAINER_GROSS_WEIGHT, ''FM9,99,99,99,99,990.00'') CONTAINER_GROSS_WEIGHT,
            TOS_RESTOW.DAMAGED DAMAGED                                           ,
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
            TOS_RESTOW.SEAL_NO SEAL_NO                                          ,
            TOS_RESTOW.OPN_STATUS                                               ,
            TOS_RESTOW.RECORD_CHANGE_DATE
            FROM TOS_RESTOW_TMP TOS_RESTOW
            WHERE (TOS_RESTOW.OPN_STATUS IS NULL OR
                   TOS_RESTOW.OPN_STATUS <> ''' ||
               PCE_EUT_COMMON.G_V_REC_DEL || ''')
            AND    TOS_RESTOW.SESSION_ID = ''' ||
               P_I_V_SESSION_ID || '''
            AND    TOS_RESTOW.FK_LOAD_LIST_ID = ''' ||
               P_I_V_LOAD_LIST_ID || '''';

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

  END PRE_ELL_RESTOWED_TAB_FIND;

  PROCEDURE PRE_ELL_SUMMARY_TAB_FIND(P_O_REFSUMMARYTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,P_I_V_LOAD_LIST_ID    VARCHAR2
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
                    ,LOADING_STATUS
                    ,COUNT(DN_EQUIPMENT_NO) COUNT
                    ,(SUM(DN_EQ_SIZE)/20) NO_OF_TEU
            FROM     TOS_LL_BOOKED_LOADING
            WHERE     TOS_LL_BOOKED_LOADING.RECORD_STATUS = ''A''
            AND     FK_LOAD_LIST_ID = ''' ||
               P_I_V_LOAD_LIST_ID || '''
            GROUP BY GROUPING SETS(FK_SLOT_OPERATOR,(FK_SLOT_OPERATOR,FK_CONTAINER_OPERATOR,DN_FULL_MT, DN_EQ_SIZE||DN_EQ_TYPE, DN_FULL_MT, LOADING_STATUS ),('''')) '; --*11

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
  END PRE_ELL_SUMMARY_TAB_FIND;

  -- This procedure called to get additional where clause conditions.
  PROCEDURE ADDITION_WHERE_CONDTIONS(P_I_V_IN   IN VARCHAR2
                                    ,P_I_V_FIND IN VARCHAR2
                                    ,P_I_V_TAB  IN VARCHAR2

                                     ) AS
    L_V_IN            VARCHAR2(30);
    DUPLICATE_STOWAGE VARCHAR2(1) := 'd'; -- *4

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
                   ' AND (DN_SPECIAL_HNDL = ''D1'' OR FK_UNNO IS NOT NULL    OR FK_UN_VAR IS NOT NULL OR FLASH_UNIT IS NOT NULL OR NVL(FLASH_POINT,0)!=0)'; -- IMO class NOT FOUND.
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
                   ' AND (DN_SPECIAL_HNDL != ''NR'' OR  NVL(REEFER_TMP,0)!=0 OR REEFER_TMP_UNIT IS NOT NULL OR NVL(DN_HUMIDITY,0)!=0 OR NVL(DN_VENTILATION,0)!=0 )';
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
                                                                                 ''FEEDER CARGO'',''FC'')';
      END IF;
      IF (P_I_V_IN = 'FK_CONTAINER_OPERATOR') THEN
        G_V_SQL := G_V_SQL || ' AND FK_CONTAINER_OPERATOR = ''' ||
                   P_I_V_FIND || '''';
      END IF;
      IF (P_I_V_IN = 'LOADING_STATUS') THEN
        G_V_SQL := G_V_SQL || ' AND  LOADING_STATUS = DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''BOOKED'',''BK'',
                                                                                    ''LOADED'',''LO'',
                                                                                    ''RETAINED ON BOARD'',''RB'',
                                                                                    ''ROB'',''RB'',
                                                                                    ''SHORT SHIPPED'',''SL'')';
      END IF;
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
                                                                                      ''BREAK BULK'',''L'')';
      END IF;
      IF (P_I_V_IN = 'LOCAL_STATUS') THEN
        G_V_SQL := G_V_SQL || ' AND LOCAL_STATUS =  DECODE(''' ||
                   P_I_V_FIND ||
                   ''',''LOCAL'',''L'',
                                                                                      ''TRANSHIPMENT'',''T'')';
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
          *4: Changes start
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
                     '    FK_LOAD_LIST_ID ' ||
                     '  FROM TOS_LL_BOOKED_LOADING IBL ' ||
                     '  WHERE STOWAGE_POSITION      IS NOT NULL ' ||
                     '  AND RECORD_STATUS= ''A'' ' -- *20
                     || '  AND IBL.FK_LOAD_LIST_ID = ''' ||
                     G_V_LOAD_LIST_ID || ''' ' ||
                     '  GROUP BY STOWAGE_POSITION, ' ||
                     '    FK_LOAD_LIST_ID ' || '  HAVING COUNT(1) > ''1'' ' ||
                     '  ) ' || ') ';
        ELSE
          G_V_SQL := G_V_SQL || ' AND STOWAGE_POSITION = ''' || P_I_V_FIND || '''';
        END IF;

      END IF; -- End of stowage position if block
      /*
          *4: Changes end
      */

      /*
          *6: Changes start
      */
      IF (P_I_V_IN = 'EX_MLO_VESSEL') THEN
        G_V_SQL := G_V_SQL || ' AND EX_MLO_VESSEL = ''' || P_I_V_FIND ||
                   ''' ';
      END IF;
      IF (P_I_V_IN = 'EX_MLO_VOYAGE') THEN
        G_V_SQL := G_V_SQL || ' AND EX_MLO_VOYAGE = ''' || P_I_V_FIND ||
                   ''' ';
      END IF;
      /*
          *6: Changes end
      */

      -- *************************************************************************************

      -- Where condition for OVERSHIPPED TAB.
    ELSIF (P_I_V_TAB = 'OVERSHIPPED_TAB') THEN

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
                   ' AND (SPECIAL_HANDLING = ''O0'' OR NVL(OVERHEIGHT_CM,0) != 0  OR NVL(OVERLENGTH_FRONT_CM,0)!= 0 OR NVL(OVERWIDTH_RIGHT_CM,0)!= 0 OR NVL(OVERWIDTH_LEFT_CM,0)!= 0)'; -- Over Length in Back  NOT FOUND.
      END IF;
      --  when Reefer Cargo is selectd
      IF (P_I_V_IN = 'REEFERCARGO') THEN
        -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
        G_V_SQL := G_V_SQL ||
                   ' AND (SPECIAL_HANDLING != ''NR'' OR NVL(REEFER_TEMPERATURE,0)!=0 OR REEFER_TMP_UNIT IS NOT NULL OR NVL(HUMIDITY,0) !=0 OR NVL(VENTILATION,0)!=0 )';
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

      -- add the find value in dynamic sql queries for overshipped tab.
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
        G_V_SQL := G_V_SQL || ' AND SHIPMENT_TYPE = ''' || P_I_V_FIND || '''';
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
          *9 changes start
      */
      IF (P_I_V_IN = 'DISCHARGE_PORT') THEN
        G_V_SQL := G_V_SQL || ' AND DISCHARGE_PORT = ''' || P_I_V_FIND || '''';
      END IF;

      IF (P_I_V_IN = 'POD_TERMINAL') THEN
        G_V_SQL := G_V_SQL || ' AND POD_TERMINAL = ''' || P_I_V_FIND || '''';
      END IF;
      /*
          *9 changes end
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
    END IF;

  END ADDITION_WHERE_CONDTIONS;

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

  PROCEDURE PRE_ELL_SAVE_BOOKED_TAB_DATA(P_I_V_SESSION_ID              VARCHAR2
                                        ,P_I_V_SEQ_NO                  VARCHAR2
                                        ,P_I_V_LOAD_LIST_ID            VARCHAR2
                                        ,P_I_V_DN_EQUIPMENT_NO         VARCHAR2
                                        ,P_I_V_LOCAL_TERMINAL_STATUS   VARCHAR2
                                        ,P_I_V_MIDSTREAM_HANDLING_CODE VARCHAR2
                                        ,P_I_V_LOAD_CONDITION          VARCHAR2
                                        ,P_I_V_LOADING_STATUS          VARCHAR2
                                        ,P_I_V_STOWAGE_POSITION        VARCHAR2
                                        ,P_I_V_ACTIVITY_DATE_TIME      VARCHAR2
                                        ,P_I_V_CONTAINER_GROSS_WEIGHT  VARCHAR2
                                        --*29 begin
                                        ,P_I_V_VGM VARCHAR2
                                        ,P_I_V_CATEGORY VARCHAR2
                                        --*29 end
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
                                        ,P_I_V_HUMIDITY                VARCHAR2
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
                                        ,P_I_V_LOCAL_STATUS            VARCHAR2
                                        ,P_I_V_EX_MLO_VESSEL           VARCHAR2
                                        ,P_I_V_EX_MLO_VESSEL_ETA       VARCHAR2
                                        ,P_I_V_EX_MLO_VOYAGE           VARCHAR2
                                        ,P_I_V_VENTILATION             VARCHAR2
                                        ,P_I_V_RESIDUE_ONLY_FLAG       VARCHAR2
                                        ,P_I_V_CRAN_DESCRIPTION        VARCHAR2 -- *8
                                        ,P_O_V_ERROR                   OUT VARCHAR2

                                         ) AS
    TEST_EXCEPTION EXCEPTION;

 BEGIN

    /* Set Success Code  */
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    -- Update data in TOS_LL_BOOKED_LOADING_TMP
    UPDATE TOS_LL_BOOKED_LOADING_TMP
       SET DN_EQUIPMENT_NO           = P_I_V_DN_EQUIPMENT_NO
          ,LOCAL_TERMINAL_STATUS     = P_I_V_LOCAL_TERMINAL_STATUS
          ,MIDSTREAM_HANDLING_CODE   = P_I_V_MIDSTREAM_HANDLING_CODE
          ,LOAD_CONDITION            = P_I_V_LOAD_CONDITION
          ,LOADING_STATUS            = P_I_V_LOADING_STATUS
          ,STOWAGE_POSITION          = P_I_V_STOWAGE_POSITION
          ,ACTIVITY_DATE_TIME        = P_I_V_ACTIVITY_DATE_TIME
          ,CONTAINER_GROSS_WEIGHT    = REPLACE(P_I_V_CONTAINER_GROSS_WEIGHT,  ',',  '')
          --*29 begin
          ,VGM =  REPLACE(P_I_V_VGM,',','') --*34
          ,CATEGORY_CODE = P_I_V_CATEGORY
          --*29 end
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
          ,REEFER_TMP                = REPLACE(P_I_V_REEFER_TEMPERATURE,
                                               ',',
                                               '')
          ,REEFER_TMP_UNIT           = P_I_V_REEFER_TMP_UNIT
          ,PUBLIC_REMARK             = P_I_V_PUBLIC_REMARK
          ,OPN_STATUS                = P_I_V_OPN_STS
          ,RECORD_CHANGE_USER        = P_I_V_USER_ID
           -- , LOCAL_STATUS                = p_i_v_local_status --*15
          ,EX_MLO_VESSEL     = P_I_V_EX_MLO_VESSEL
          ,EX_MLO_VESSEL_ETA = P_I_V_EX_MLO_VESSEL_ETA
          ,EX_MLO_VOYAGE     = P_I_V_EX_MLO_VOYAGE
          ,DN_VENTILATION    = REPLACE(P_I_V_VENTILATION, ',', '')
          ,MLO_DEL           = P_I_V_MLO_DEL
          ,DN_HUMIDITY       = P_I_V_HUMIDITY
          ,RESIDUE_ONLY_FLAG = P_I_V_RESIDUE_ONLY_FLAG
          ,CRANE_TYPE        = P_I_V_CRAN_DESCRIPTION -- *8
     WHERE SESSION_ID = P_I_V_SESSION_ID
       AND SEQ_NO = P_I_V_SEQ_NO;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) || ':' ||
                     SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));
  END PRE_ELL_SAVE_BOOKED_TAB_DATA;

  PROCEDURE PRE_ELL_SAVE_OVERSHIP_TAB_DATA(P_I_V_SESSION_ID               VARCHAR2
                                          ,P_I_V_SEQ_NO                   IN OUT VARCHAR2
                                          ,P_I_V_OVERSHIPPED_CONTAINER_ID VARCHAR2
                                          ,P_I_V_LOAD_LIST_ID             VARCHAR2
                                          ,P_I_V_BOOKING_NO               VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO             VARCHAR2
                                          ,P_I_V_EQ_SIZE                  VARCHAR2
                                          ,P_I_V_EQ_TYPE                  VARCHAR2
                                          ,P_I_V_FULL_MT                  VARCHAR2
                                          ,P_I_V_BKG_TYP                  VARCHAR2
                                          ,P_I_V_FLAG_SOC_COC             VARCHAR2
                                          ,P_I_V_SHIPMENT_TERM            VARCHAR2
                                          ,P_I_V_SHIPMENT_TYP             VARCHAR2
                                          ,P_I_V_LOCAL_STATUS             VARCHAR2
                                          ,P_I_V_LOCAL_TERMINAL_STATUS    VARCHAR2
                                          ,P_I_V_MIDSTREAM_HANDLING_CODE  VARCHAR2
                                          ,P_I_V_LOAD_CONDITION           VARCHAR2
                                          ,P_I_V_STOWAGE_POSITION         VARCHAR2
                                          ,P_I_V_ACTIVITY_DATE_TIME       VARCHAR2
                                          ,P_I_V_CONTAINER_GROSS_WEIGHT   VARCHAR2
                                          ,P_I_V_DAMAGED                  VARCHAR2
                                          ,P_I_V_SLOT_OPERATOR            VARCHAR2
                                          ,P_I_V_CONTAINER_OPERATOR       VARCHAR2
                                          ,P_I_V_OUT_SLOT_OPERATOR        VARCHAR2
                                          ,P_I_V_SPECIAL_HANDLING         VARCHAR2
                                          ,P_I_V_SEAL_NO                  VARCHAR2
                                          ,P_I_V_POD                      VARCHAR2
                                          ,P_I_V_POD_TERMINAL             VARCHAR2
                                          ,P_I_V_NXT_SRV                  VARCHAR2
                                          ,P_I_V_NXT_VESSEL               VARCHAR2
                                          ,P_I_V_NXT_VOYAGE               VARCHAR2
                                          ,P_I_V_NXT_DIR                  VARCHAR2
                                          ,P_I_V_MLO_VESSEL               VARCHAR2
                                          ,P_I_V_MLO_VOYAGE               VARCHAR2
                                          ,P_I_V_MLO_VESSEL_ETA           VARCHAR2
                                          ,P_I_V_MLO_POD1                 VARCHAR2
                                          ,P_I_V_MLO_POD2                 VARCHAR2
                                          ,P_I_V_MLO_POD3                 VARCHAR2
                                          ,P_I_V_MLO_DEL                  VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_1   VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_2   VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_3   VARCHAR2
                                          ,P_I_V_CONTAINER_LOADING_REM_1  VARCHAR2
                                          ,P_I_V_CONTAINER_LOADING_REM_2  VARCHAR2
                                          ,P_I_V_SPECIAL_CARGO            VARCHAR2
                                          ,P_I_V_IMDG_CLASS               VARCHAR2
                                          ,P_I_V_UN_NUMBER                VARCHAR2
                                          ,P_I_V_UN_VAR                   VARCHAR2
                                          ,P_I_V_PORT_CLASS               VARCHAR2
                                          ,P_I_V_PORT_CLASS_TYP           VARCHAR2
                                          ,P_I_V_FLASHPOINT_UNIT          VARCHAR2
                                          ,P_I_V_FLASHPOINT               VARCHAR2
                                          ,P_I_V_FUMIGATION_ONLY          VARCHAR2
                                          ,P_I_V_RESIDUE_ONLY_FLAG        VARCHAR2
                                          ,P_I_V_OVERHEIGHT_CM            VARCHAR2
                                          ,P_I_V_OVERWIDTH_LEFT_CM        VARCHAR2
                                          ,P_I_V_OVERWIDTH_RIGHT_CM       VARCHAR2
                                          ,P_I_V_OVERLENGTH_FRONT_CM      VARCHAR2
                                          ,P_I_V_OVERLENGTH_REAR_CM       VARCHAR2
                                          ,P_I_V_REEFER_TEMPERATURE       VARCHAR2
                                          ,P_I_V_REEFER_TMP_UNIT          VARCHAR2
                                          ,P_I_V_HUMIDITY                 VARCHAR2
                                          ,P_I_V_VENTILATION              VARCHAR2
                                          ,P_I_V_LOADING_STATUS           VARCHAR2
                                          ,P_I_V_USER_ID                  VARCHAR2
                                          ,P_I_V_OPN_STS                  VARCHAR2
                                          ,P_I_V_VOID_SLOT                VARCHAR2
                                          ,P_I_V_EX_MLO_VESSEL            VARCHAR2
                                          ,P_I_V_EX_MLO_VESSEL_ETA        VARCHAR2
                                          ,P_I_V_EX_MLO_VOYAGE            VARCHAR2
                                          ,P_I_V_VGM                      VARCHAR2 --*34
                                          ,P_O_V_ERROR                    OUT VARCHAR2) AS
    L_N_SEQ_NO NUMBER := 0;
  BEGIN
    /* Set Success Code  */
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF (((P_I_V_SEQ_NO = '0') OR (P_I_V_SEQ_NO IS NULL)) AND
       P_I_V_OPN_STS = PCE_EUT_COMMON.G_V_REC_ADD) THEN

      SELECT NVL(MAX(TO_NUMBER(SEQ_NO)), 0) + 1
        INTO L_N_SEQ_NO
        FROM TOS_LL_OVERSHIPPED_CONT_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID;

      INSERT INTO TOS_LL_OVERSHIPPED_CONT_TMP
        (SESSION_ID
        ,SEQ_NO
        ,BOOKING_NO
        ,BOOKING_NO_SOURCE
        ,EQUIPMENT_NO
        ,EQ_SIZE
        ,EQ_TYPE
        ,FULL_MT
        ,BKG_TYP
        ,FLAG_SOC_COC
        ,LOCAL_STATUS
        ,LOCAL_TERMINAL_STATUS
        ,MIDSTREAM_HANDLING_CODE
        ,LOAD_CONDITION
        ,LOADING_STATUS
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
        ,DISCHARGE_PORT
        ,POD_TERMINAL
        ,MLO_VESSEL
        ,MLO_VOYAGE
        ,MLO_VESSEL_ETA
        ,MLO_POD1
        ,MLO_POD2
        ,MLO_POD3
        ,MLO_DEL
        ,EX_MLO_VESSEL
        ,EX_MLO_VESSEL_ETA
        ,EX_MLO_VOYAGE
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
        ,PORT_CLASS_TYPE
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
        ,FK_LOAD_LIST_ID
        ,OPN_STATUS
        ,RECORD_CHANGE_USER
        ,RECORD_CHANGE_DATE
        ,VGM --*34
        )
      VALUES
        (P_I_V_SESSION_ID
        ,L_N_SEQ_NO
        ,P_I_V_BOOKING_NO
        ,'I'
        ,P_I_V_EQUIPMENT_NO
        ,P_I_V_EQ_SIZE
        ,P_I_V_EQ_TYPE
        ,P_I_V_FULL_MT
        ,P_I_V_BKG_TYP
        ,P_I_V_FLAG_SOC_COC
        ,P_I_V_LOCAL_STATUS
        ,P_I_V_LOCAL_TERMINAL_STATUS
        ,P_I_V_MIDSTREAM_HANDLING_CODE
        ,P_I_V_LOAD_CONDITION
        ,P_I_V_LOADING_STATUS
        ,P_I_V_STOWAGE_POSITION
        ,P_I_V_ACTIVITY_DATE_TIME
        ,REPLACE(P_I_V_CONTAINER_GROSS_WEIGHT, ',', '')
        ,P_I_V_DAMAGED
        ,P_I_V_VOID_SLOT
        ,P_I_V_SLOT_OPERATOR
        ,P_I_V_CONTAINER_OPERATOR
        ,P_I_V_OUT_SLOT_OPERATOR
        ,P_I_V_SPECIAL_HANDLING
        ,P_I_V_SEAL_NO
        ,P_I_V_POD
        ,P_I_V_POD_TERMINAL
        ,P_I_V_MLO_VESSEL
        ,P_I_V_MLO_VOYAGE
        ,P_I_V_MLO_VESSEL_ETA
        ,P_I_V_MLO_POD1
        ,P_I_V_MLO_POD2
        ,P_I_V_MLO_POD3
        ,P_I_V_MLO_DEL
        ,P_I_V_EX_MLO_VESSEL
        ,P_I_V_EX_MLO_VESSEL_ETA
        ,P_I_V_EX_MLO_VOYAGE
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
        ,P_I_V_LOAD_LIST_ID
        ,P_I_V_OPN_STS
        ,P_I_V_USER_ID
        ,SYSDATE
        ,REPLACE(P_I_V_VGM, ',', '') --*34
        );
      P_I_V_SEQ_NO := L_N_SEQ_NO;
    ELSE
      -- Update data in TOS_LL_OVERSHIPPED_CONT_TMP
      UPDATE TOS_LL_OVERSHIPPED_CONT_TMP
         SET BOOKING_NO              = P_I_V_BOOKING_NO
            ,EQUIPMENT_NO            = P_I_V_EQUIPMENT_NO
            ,EQ_SIZE                 = P_I_V_EQ_SIZE
            ,EQ_TYPE                 = P_I_V_EQ_TYPE
            ,FULL_MT                 = P_I_V_FULL_MT
            ,BKG_TYP                 = P_I_V_BKG_TYP
            ,FLAG_SOC_COC            = P_I_V_FLAG_SOC_COC
            ,SHIPMENT_TERM           = P_I_V_SHIPMENT_TERM
            ,SHIPMENT_TYPE           = P_I_V_SHIPMENT_TYP
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
            ,DISCHARGE_PORT          = P_I_V_POD
            ,POD_TERMINAL            = P_I_V_POD_TERMINAL
            ,MLO_VESSEL              = P_I_V_MLO_VESSEL
            ,MLO_VOYAGE              = P_I_V_MLO_VOYAGE
            ,MLO_VESSEL_ETA          = P_I_V_MLO_VESSEL_ETA
            ,MLO_POD1                = P_I_V_MLO_POD1
            ,MLO_POD2                = P_I_V_MLO_POD2
            ,MLO_POD3                = P_I_V_MLO_POD3
            ,HANDLING_INSTRUCTION_1  = P_I_V_HANDLING_INSTRUCTION_1
            ,HANDLING_INSTRUCTION_2  = P_I_V_HANDLING_INSTRUCTION_2
            ,HANDLING_INSTRUCTION_3  = P_I_V_HANDLING_INSTRUCTION_3
            ,CONTAINER_LOADING_REM_1 = P_I_V_CONTAINER_LOADING_REM_1
            ,CONTAINER_LOADING_REM_2 = P_I_V_CONTAINER_LOADING_REM_2
            ,IMDG_CLASS              = P_I_V_IMDG_CLASS
            ,UN_NUMBER               = P_I_V_UN_NUMBER
            ,UN_NUMBER_VARIANT       = P_I_V_UN_VAR
            ,PORT_CLASS              = P_I_V_PORT_CLASS
            ,PORT_CLASS_TYPE         = P_I_V_PORT_CLASS_TYP
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
            ,LOADING_STATUS          = P_I_V_LOADING_STATUS
            ,RECORD_CHANGE_USER      = P_I_V_USER_ID
            ,OPN_STATUS              = P_I_V_OPN_STS
            ,VOID_SLOT               = P_I_V_VOID_SLOT
            ,EX_MLO_VESSEL           = P_I_V_EX_MLO_VESSEL
            ,EX_MLO_VESSEL_ETA       = P_I_V_EX_MLO_VESSEL_ETA
            ,EX_MLO_VOYAGE           = P_I_V_EX_MLO_VOYAGE
            ,VGM                     = REPLACE(P_I_V_VGM,',','')
       WHERE SESSION_ID = P_I_V_SESSION_ID
         AND SEQ_NO = P_I_V_SEQ_NO;

    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) || ':' ||
                     SUBSTR(SQLERRM, 1, 100);

      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERROR));

  END PRE_ELL_SAVE_OVERSHIP_TAB_DATA;

  PROCEDURE PRE_ELL_DEL_OVERSHIPPED_DATA(P_I_V_SESSION_ID IN VARCHAR2
                                        ,P_I_V_SEQ_NO     IN VARCHAR2
                                        ,P_I_V_OPN_STS    IN VARCHAR2
                                        ,P_I_V_USER_ID    IN VARCHAR2
                                        ,P_O_V_ERR_CD     OUT VARCHAR2) AS
  BEGIN

    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF (P_I_V_OPN_STS = PCE_EUT_COMMON.G_V_REC_ADD) THEN

      DELETE FROM TOS_LL_OVERSHIPPED_CONT_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
         AND SEQ_NO = P_I_V_SEQ_NO;

    ELSE

      UPDATE TOS_LL_OVERSHIPPED_CONT_TMP
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
  END PRE_ELL_DEL_OVERSHIPPED_DATA;

  PROCEDURE PRE_ELL_SAVE_RESTOW_TAB_DATA(P_I_V_SESSION_ID             IN VARCHAR2
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
                                        ,P_I_V_LOAD_LIST_ID           IN VARCHAR2
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
        ,FK_LOAD_LIST_ID)
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
        ,P_I_V_LOAD_LIST_ID);
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
  END PRE_ELL_SAVE_RESTOW_TAB_DATA;

  PROCEDURE PRE_ELL_DEL_RESTOWED_TAB_DATA(P_I_V_SESSION_ID IN VARCHAR2
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
  END PRE_ELL_DEL_RESTOWED_TAB_DATA;

  PROCEDURE PRE_ELL_SAVE_TEMP_TO_MAIN(P_I_V_SESSION_ID       IN VARCHAR2
                                     ,P_I_V_USER_ID          IN VARCHAR2
                                     ,P_I_V_LOAD_LIST_STATUS IN VARCHAR2
                                     ,P_I_V_LOAD_LIST_ID     IN VARCHAR2
                                     ,P_I_V_ETA              IN VARCHAR2
                                     ,P_I_V_VESSEL           IN VARCHAR2
                                     ,P_I_V_HDR_ETA_TM       IN VARCHAR2
                                     ,P_I_V_HDR_PORT         IN VARCHAR2
                                     ,P_I_V_LOAD_ETD         IN VARCHAR2
                                     ,P_I_V_HDR_ETD_TM       IN VARCHAR2
                                     ,P_O_V_ERR_CD           OUT VARCHAR2) AS
    L_V_DATE      VARCHAR2(14);
    L_V_LL_STATUS VARCHAR2(2); -- *22
  BEGIN
    G_V_ORA_ERR_CD         := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    G_V_USER_ERR_CD        := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_ERR_CD           := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    G_V_DUPLICATE_STOW_ERR := PCE_EUT_COMMON.G_V_SUCCESS_CD; -- *10

    -- Get system date
    SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') INTO L_V_DATE FROM DUAL;

    /* *22 start * */
    /* * get updated list status * */
    L_V_LL_STATUS := P_I_V_LOAD_LIST_STATUS;


    /* * if list status is not updated then find old list status *  */
    IF (L_V_LL_STATUS IS NULL) THEN
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_GET_LIST_STATUS(P_I_V_LOAD_LIST_ID,
                                                    LL_DL_FLAG,
                                                    L_V_LL_STATUS);
    END IF;



    /* *22 end * */

    IF ((L_V_LL_STATUS = LOADING_COMPLETE) OR
       (L_V_LL_STATUS = READY_FOR_INVOICE) OR
       (L_V_LL_STATUS = WORK_COMPLETE)) THEN
      -- *22


      PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_DL_LL_MNTN(LL_DL_FLAG,
                                                         P_I_V_SESSION_ID,
                                                         P_I_V_USER_ID,
                                                         L_V_DATE,
                                                         P_O_V_ERR_CD);



      IF ((P_O_V_ERR_CD IS NULL) OR
         (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
        RAISE L_EXCP_FINISH;
      END IF;
    END IF; -- *22



    /* Save Booked tab data*/
    PRE_ELL_SAVE_BOOKED_TAB_MAIN(P_I_V_SESSION_ID,
                                 P_I_V_USER_ID,
                                 P_I_V_HDR_PORT,
                                 P_I_V_LOAD_ETD,
                                 P_I_V_HDR_ETD_TM,
                                 P_I_V_VESSEL,
                                 L_V_DATE,
                                 P_O_V_ERR_CD);



     IF ((P_O_V_ERR_CD IS NULL) OR
       (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
      RAISE L_EXCP_FINISH;
    END IF;

    /*Save overshipped tab data*/
    PRE_ELL_SAVE_OVERSHIP_TAB_MAIN(P_I_V_SESSION_ID,
                                   P_I_V_USER_ID,
                                   P_I_V_VESSEL,
                                   P_I_V_ETA,
                                   P_I_V_HDR_ETA_TM,
                                   P_I_V_HDR_PORT,
                                   L_V_DATE,
                                   P_I_V_LOAD_ETD,
                                   P_I_V_HDR_ETD_TM,
                                   P_O_V_ERR_CD);

    IF ((P_O_V_ERR_CD IS NULL) OR
       (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
      RAISE L_EXCP_FINISH;
    END IF;

    /*Save resetowed tab data*/
    PRE_ELL_SAVE_RESTOW_TAB_MAIN(P_I_V_SESSION_ID,
                                 P_I_V_USER_ID,
                                 P_I_V_VESSEL,
                                 P_I_V_ETA,
                                 P_I_V_HDR_ETA_TM,
                                 P_I_V_LOAD_ETD,
                                 P_I_V_HDR_ETD_TM,
                                 P_I_V_HDR_PORT,
                                 L_V_DATE,
                                 P_O_V_ERR_CD);

    IF ((P_O_V_ERR_CD IS NULL) OR
       (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
      RAISE L_EXCP_FINISH;
    END IF;


   IF (P_I_V_LOAD_LIST_STATUS IS NOT NULL) THEN

      PRE_ELL_SAVE_LL_STATUS(P_I_V_LOAD_LIST_ID,
                             P_I_V_LOAD_LIST_STATUS,
                             P_I_V_USER_ID,
                             P_I_V_SESSION_ID -- *19
                            ,
                             L_V_DATE,
                             P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        -- *28 start
        -- Raise EMS exception
        /*        IF P_O_V_ERR_CD = G_EXCP_EMS_CODE THEN
          RAISE L_EXCP_EMS;
        END IF;*/
        -- *28 end

        RAISE L_EXCP_FINISH;
      END IF;
    END IF;

    IF ((G_V_WARNING IS NOT NULL) AND (G_V_WARNING = 'ELL.SE0112')) THEN
      /* set the warning code to display warning message on screen */
      /*'Service, Vessel and Voyage information not match with present load list'*/
      P_O_V_ERR_CD := 'ELL.SE0112';
    END IF;

    /*
        *10 start
    */

    IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      P_O_V_ERR_CD := G_V_DUPLICATE_STOW_ERR; -- *10
    END IF;

    IF P_O_V_ERR_CD = G_V_DUPLICATE_STOW_ERR
       AND G_V_DUPLICATE_STOW_ERR <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
      COMMIT;
      RAISE L_DUPLICATE_STOW_EXCPTION;
    END IF;
    /*
        *10 end
    */

  EXCEPTION
    /*
        *10 start
    */
    WHEN L_DUPLICATE_STOW_EXCPTION THEN
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
      /*
          *10 end
      */

    WHEN L_EXCP_FINISH THEN
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                                PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));
      END IF;
      /*      -- *28 start
      WHEN L_EXCP_EMS THEN
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                                '|Missing Loading Activity in EMS.Please click Error Log button to see more detail.;');
       -- *28 end*/
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRE_ELL_SAVE_TEMP_TO_MAIN;

  PROCEDURE PRE_ELL_SAVE_BOOKED_TAB_MAIN(P_I_V_SESSION_ID IN VARCHAR2
                                        ,P_I_V_USER_ID    IN VARCHAR2
                                        ,P_I_V_PORT_CODE  IN VARCHAR2
                                        ,P_I_V_LOAD_ETD   IN VARCHAR2
                                        ,P_I_V_HDR_ETD_TM IN VARCHAR2
                                        ,P_I_V_VESSEL     IN VARCHAR2
                                        ,P_I_V_DATE       IN VARCHAR2
                                        ,P_O_V_ERR_CD     OUT VARCHAR2) AS
    L_V_BOOKED_LOAD_ID    NUMBER := 0;
    L_V_LOCK_DATA         VARCHAR2(14);
    L_V_BOOKED_ROW_NUM    NUMBER := 1;
    L_V_ERRORS            VARCHAR2(2000);
    L_V_REC_COUNT         NUMBER := 0;
    L_V_RESTOW_ROW_NUM    NUMBER := 1;
    L_V_FLAG              VARCHAR2(1);
    L_V_DISCHARGE_LIST_ID NUMBER;
    L_V_STOWAGE_POSITION  VARCHAR2(7);

    L_V_REPLACEMENT_TYPE VARCHAR2(1) := '3';
    L_V_PK_CONT_REPL_ID  NUMBER := 0;
    L_V_OLD_EQUIPMENT_NO TOS_LL_BOOKED_LOADING_TMP.DN_EQUIPMENT_NO%TYPE;
    L_V_TERMINAL         TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE;

    L_V_EQUIPMENT_NO           TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE;
    L_V_BOOKING_NO             TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE;
    L_V_BKG_EQUIPM_DTL         TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE;
    L_V_BKG_VOYAGE_ROUTING_DTL TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL%TYPE;
    L_V_DN_PORT                TOS_LL_LOAD_LIST.DN_PORT%TYPE; -- added 13.12.2011
    L_V_DN_TERMINAL            TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE; -- added 13.12.2011



    -- cursor to save booked tab data
    CURSOR L_CUR_BOOKED_DATA IS
      SELECT PK_BOOKED_LOADING_ID
            ,FK_LOAD_LIST_ID
            ,CONTAINER_SEQ_NO
            ,FK_BOOKING_NO
            ,FK_BKG_SIZE_TYPE_DTL
            ,FK_BKG_SUPPLIER
            ,FK_BKG_EQUIPM_DTL
            ,DN_EQUIPMENT_NO
            ,EQUPMENT_NO_SOURCE
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
            ,LOADING_STATUS
            ,STOWAGE_POSITION
            ,ACTIVITY_DATE_TIME
            ,CONTAINER_GROSS_WEIGHT
            --*29 begin
            ,VGM --*34
            ,CATEGORY_CODE
            --*29 end
            ,DAMAGED
            ,VOID_SLOT
            ,PREADVICE_FLAG
            ,FK_SLOT_OPERATOR
            ,FK_CONTAINER_OPERATOR
            ,OUT_SLOT_OPERATOR
            ,DN_SPECIAL_HNDL
            ,SEAL_NO
            ,DN_DISCHARGE_PORT
            ,DN_DISCHARGE_TERMINAL
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
            ,EX_MLO_VESSEL
            ,EX_MLO_VESSEL_ETA
            ,EX_MLO_VOYAGE
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
            ,REEFER_TMP
            ,REEFER_TMP_UNIT
            ,DN_HUMIDITY
            ,DN_VENTILATION
            ,PUBLIC_REMARK
            ,OPN_STATUS
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE
            ,SEQ_NO
            ,DECODE(OPN_STATUS, PCE_EUT_COMMON.G_V_REC_DEL, '1') ORD_SEQ
            ,CRANE_TYPE CRAN_DESCRIPTION -- *8
        FROM TOS_LL_BOOKED_LOADING_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       ORDER BY ORD_SEQ
               ,SEQ_NO;

    CURSOR L_CUR_DUPLICATE_EQUIP_NO IS
      SELECT DN_EQUIPMENT_NO
        FROM TOS_LL_BOOKED_LOADING_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       GROUP BY DN_EQUIPMENT_NO
      HAVING COUNT(DN_EQUIPMENT_NO) > 1
       ORDER BY COUNT(DN_EQUIPMENT_NO);

    /* *19 start * */
    /*
    CURSOR l_cur_duplicate_stowage_pos IS
        SELECT   STOWAGE_POSITION
        FROM     TOS_LL_BOOKED_LOADING_TMP
        WHERE    SESSION_ID              = p_i_v_session_id
        GROUP BY STOWAGE_POSITION
        HAVING   COUNT(STOWAGE_POSITION) >1
        ORDER BY COUNT(STOWAGE_POSITION);
    */
    /* *19 end * */

    L_V_DUPLICATE_ERROR VARCHAR2(4000) := NULL;
  BEGIN



    L_V_ERRORS   := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    /*
        *1-Modification start by vikas, when cell location is changed and discharge status is discharged then
        check if cell location is null then update cell location otherewise not, k'chatgamol, 06.03.2012
    */

    /* ********** Duplicate Equipment# and Stowage position Validation Start ************** */
    /* Check duplicate equipment # */
    FOR L_CUR_DUPLICATE_EQUIP_NO_REC IN L_CUR_DUPLICATE_EQUIP_NO
    LOOP
      IF L_V_DUPLICATE_ERROR IS NULL THEN
        L_V_DUPLICATE_ERROR := L_CUR_DUPLICATE_EQUIP_NO_REC.DN_EQUIPMENT_NO;
      ELSE
        L_V_DUPLICATE_ERROR := L_V_DUPLICATE_ERROR || ', ' ||
                               L_CUR_DUPLICATE_EQUIP_NO_REC.DN_EQUIPMENT_NO;
      END IF;
    END LOOP;


   /* When duplicate # record found then show error
    Duplicate record present in booked tab */
    IF L_V_DUPLICATE_ERROR IS NOT NULL THEN
      P_O_V_ERR_CD := 'EDL.SE0167' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      L_V_DUPLICATE_ERROR || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
    END IF;

    /* General Error Checking */
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* *19 start * */
    /*
    /* Check duplicate stowage position *
    FOR l_cur_dup_stowage_pos_rec IN l_cur_duplicate_stowage_pos
    LOOP
        IF l_v_duplicate_error IS NULL THEN
            l_v_duplicate_error := l_cur_dup_stowage_pos_rec.STOWAGE_POSITION;
        ELSE
            l_v_duplicate_error := l_v_duplicate_error || ', ' || l_cur_dup_stowage_pos_rec.STOWAGE_POSITION;
        END IF;
    END LOOP;

    /* When duplicate stowage position record found then show error
       Duplicate record present in booked tab *
    IF l_v_duplicate_error IS NOT NULL THEN
        p_o_v_err_cd := 'EDL.SE0168' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_duplicate_error ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
    END IF;

    */
    /* * check duplicate cell location exists or not * */

    PCE_EDL_DLMAINTENANCE.PRE_CHECK_DUP_CELL_LOCATION(P_I_V_SESSION_ID,
                                                      LL_DL_FLAG,
                                                      BLANK, /* session id must have value * */
                                                      P_O_V_ERR_CD);
    /* *19 end * */

    /* General Error Checking */

    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* ********** Duplicate Equipment# and Stowage position Validation End ************** */

    FOR L_CUR_BOOKED_DATA_REC IN L_CUR_BOOKED_DATA
    LOOP
      IF (L_CUR_BOOKED_DATA_REC.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_UPD) THEN

        -- call validation function for booked tab.
        PRE_ELL_BOOKED_VALIDATION(P_I_V_SESSION_ID,
                                  L_V_RESTOW_ROW_NUM,
                                  L_CUR_BOOKED_DATA_REC.FK_LOAD_LIST_ID,
                                  L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO,
                                  L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID,
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
                                  P_I_V_LOAD_ETD,
                                  P_I_V_HDR_ETD_TM,
                                  P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        /* Check if stowage possition is changed, then update the stowage position in load list table. */
        /* BOOKED TAB STOWAGE POSITION CHANGED */
        SELECT STOWAGE_POSITION
          INTO L_V_STOWAGE_POSITION
          FROM TOS_LL_BOOKED_LOADING
         WHERE PK_BOOKED_LOADING_ID =
               L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID;

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
            FROM TOS_LL_BOOKED_LOADING
           WHERE PK_BOOKED_LOADING_ID =
                 L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID;

          /* Equipment no# is changed to any value. then update load list. */
          IF (((L_V_EQUIPMENT_NO IS NULL) AND
             (L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO IS NOT NULL)) OR
             (L_V_EQUIPMENT_NO <> L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO)) THEN

            /* Update current discharge list */
            UPDATE TOS_DL_BOOKED_DISCHARGE
               SET STOWAGE_POSITION       = L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION
                  ,CONTAINER_GROSS_WEIGHT = L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                  ,RECORD_CHANGE_USER     = P_I_V_USER_ID -- added 14.12.2011,  update by vikas as, chatgamol
                  ,RECORD_CHANGE_DATE     = TO_DATE(P_I_V_DATE,
                                                    'YYYYMMDDHH24MISS') -- added 14.12.2011,  update by vikas as, chatgamol
             WHERE FK_BOOKING_NO = L_V_BOOKING_NO
               AND FK_BKG_EQUIPM_DTL = L_V_BKG_EQUIPM_DTL
               AND FK_BKG_VOYAGE_ROUTING_DTL = L_V_BKG_VOYAGE_ROUTING_DTL
               AND DISCHARGE_STATUS <> 'DI'
               AND RECORD_STATUS = 'A';

          ELSE
            /* Normal Case Check equipment# in next discharge list and update stowage
            possition in next discharge list. */
            /*Start added by vikas as logic is changed, 22.11.2011*/
            PCE_EDL_DLMAINTENANCE.PRE_NEXT_DISCHARGE_LIST_ID(L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO,
                                                             L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO,
                                                             L_CUR_BOOKED_DATA_REC.DN_DISCHARGE_TERMINAL,
                                                             L_CUR_BOOKED_DATA_REC.DN_DISCHARGE_PORT,
                                                             L_V_DISCHARGE_LIST_ID,
                                                             L_V_FLAG,
                                                             P_O_V_ERR_CD);
            /* End added by vikas, 22.11.2011*/

            /* Start Commented by vikas, 22.11.2011 *
            /* Get the discharge list id *
            PRE_ELL_NEXT_DISCHARGE_LIST_ID (
                  p_i_v_vessel
                , l_cur_booked_data_rec.DN_EQUIPMENT_NO
                , l_cur_booked_data_rec.FK_BOOKING_NO
                , p_i_v_load_etd
                , p_i_v_hdr_etd_tm
                , p_i_v_port_code
                , l_v_discharge_list_id
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
                  FROM TOS_DL_BOOKED_DISCHARGE
                 WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_LIST_ID
                -- AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012 -- *1
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
              /* update record in booked discharge list table */
              UPDATE TOS_DL_BOOKED_DISCHARGE
                 SET STOWAGE_POSITION       = L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION
                    ,CONTAINER_GROSS_WEIGHT = L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                    ,RECORD_CHANGE_USER     = P_I_V_USER_ID
                    ,RECORD_CHANGE_DATE     = TO_DATE(P_I_V_DATE,
                                                      'YYYYMMDDHH24MISS')
               WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_LIST_ID
                    -- AND DISCHARGE_STATUS <> 'DI'; -- *1
                 AND (STOWAGE_POSITION IS NULL OR DISCHARGE_STATUS <> 'DI'); -- *1
            END IF;
          END IF;
        END IF;

        IF (L_CUR_BOOKED_DATA_REC.DAMAGED = 'Y') THEN
          /* Check if equipment# is changed then update new equipment no# in container replacement table. */
          SELECT NVL(DN_EQUIPMENT_NO, '~')
            INTO L_V_OLD_EQUIPMENT_NO
            FROM TOS_LL_BOOKED_LOADING
           WHERE PK_BOOKED_LOADING_ID =
                 L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID;

          IF (L_V_OLD_EQUIPMENT_NO != L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO) THEN
            /* Eqipment# has changed. */

            /* Get pk for BKG_CONTAINER_REPLACEMENT table. */
            SELECT SE_CRZ01.NEXTVAL INTO L_V_PK_CONT_REPL_ID FROM DUAL;

            /* Get the terminal from Load list */
            SELECT DN_TERMINAL
              INTO L_V_TERMINAL
              FROM TOS_LL_LOAD_LIST
             WHERE PK_LOAD_LIST_ID = L_CUR_BOOKED_DATA_REC.FK_LOAD_LIST_ID;

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

        -- Call Synchronization with Booking
        PRE_ELL_SYNCH_BOOKING(L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID,
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
                              L_CUR_BOOKED_DATA_REC.REEFER_TMP,
                              L_CUR_BOOKED_DATA_REC.DN_HUMIDITY,
                              L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT,
                              L_CUR_BOOKED_DATA_REC.DN_VENTILATION,
                              L_CUR_BOOKED_DATA_REC.CATEGORY_CODE, --*29
                              L_CUR_BOOKED_DATA_REC.VGM, --*34
                              P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        SELECT COUNT(1)
          INTO L_V_REC_COUNT
          FROM TOS_LL_BOOKED_LOADING
         WHERE PK_BOOKED_LOADING_ID =
               L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID
           AND LOADING_STATUS = L_CUR_BOOKED_DATA_REC.LOADING_STATUS
           AND RECORD_STATUS = 'A'; -- modified 14.02.2012

        /* Loading status is changed then update in DL */
        IF (L_V_REC_COUNT = 0) THEN

          /*
              Start Changes by vikas, some time it is not updating
              the correct discharge list, as k'chatgamol, 13.12.2011
          */

          /*
              Get the load port and load termina from header table
          */
          SELECT DN_PORT
                ,DN_TERMINAL
            INTO L_V_DN_PORT
                ,L_V_DN_TERMINAL
            FROM VASAPPS.TOS_LL_LOAD_LIST
           WHERE PK_LOAD_LIST_ID = L_CUR_BOOKED_DATA_REC.FK_LOAD_LIST_ID;

          /*
              Get lock on the table.
          */
          BEGIN
            SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
              INTO L_V_LOCK_DATA
              FROM TOS_DL_BOOKED_DISCHARGE
             WHERE FK_BOOKING_NO = L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO
               AND DN_EQUIPMENT_NO = L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO
               AND DN_POL = L_V_DN_PORT
               AND DN_POL_TERMINAL = L_V_DN_TERMINAL
               AND RECORD_STATUS = 'A' -- ADDED 06.02.2012
            --AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012 -- *1
               FOR UPDATE NOWAIT;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              -- p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
              -- RETURN;  modified 14.02.2012
              NULL;
            WHEN OTHERS THEN
              -- p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
              --RETURN;
              NULL; -- modified 14.02.2012
          END;

          /*
              Update loading status in booked discharge table
          */

          BEGIN
            UPDATE TOS_DL_BOOKED_DISCHARGE
               SET DN_LOADING_STATUS      = L_CUR_BOOKED_DATA_REC.LOADING_STATUS
                  ,STOWAGE_POSITION       = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                                   'LO',
                                                   L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION,
                                                   STOWAGE_POSITION)
                  ,CONTAINER_GROSS_WEIGHT = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                                   'LO',
                                                   L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT,
                                                   CONTAINER_GROSS_WEIGHT)
                   -- block start by vikas, 20.02.2012
                  ,MLO_VESSEL     = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                           'LO',
                                           L_CUR_BOOKED_DATA_REC.MLO_VESSEL,
                                           MLO_VESSEL)
                  ,MLO_VOYAGE     = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                           'LO',
                                           L_CUR_BOOKED_DATA_REC.MLO_VOYAGE,
                                           MLO_VOYAGE)
                  ,MLO_VESSEL_ETA = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                           'LO',
                                           TO_DATE(L_CUR_BOOKED_DATA_REC.MLO_VESSEL_ETA,
                                                   'DD/MM/YYYY HH24:MI'),
                                           MLO_VESSEL_ETA)
                  ,MLO_POD1       = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                           'LO',
                                           L_CUR_BOOKED_DATA_REC.MLO_POD1,
                                           MLO_POD1)
                  ,MLO_POD2       = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                           'LO',
                                           L_CUR_BOOKED_DATA_REC.MLO_POD2,
                                           MLO_POD2)
                  ,MLO_POD3       = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                           'LO',
                                           L_CUR_BOOKED_DATA_REC.MLO_POD3,
                                           MLO_POD3)
                  ,MLO_DEL        = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                           'LO',
                                           L_CUR_BOOKED_DATA_REC.MLO_DEL,
                                           MLO_DEL)
                   -- block end by vikas, 20.02.2012
                  ,RECORD_CHANGE_USER = P_I_V_USER_ID
                  ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE,
                                                'YYYYMMDDHH24MISS')
                  ,VGM            = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                                   'LO',
                                                   L_CUR_BOOKED_DATA_REC.VGM,
                                                   VGM)
                  ,CATEGORY_CODE = DECODE(L_CUR_BOOKED_DATA_REC.LOADING_STATUS,
                                                   'LO',
                                                   L_CUR_BOOKED_DATA_REC.CATEGORY_CODE,
                                                   CATEGORY_CODE)
             WHERE FK_BOOKING_NO = L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO
               AND DN_EQUIPMENT_NO = L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO
               AND DN_POL = L_V_DN_PORT
               AND DN_POL_TERMINAL = L_V_DN_TERMINAL
               AND RECORD_STATUS = 'A'
               AND DISCHARGE_STATUS <> 'DI'; -- added by vikas, 17.02.2012
          EXCEPTION
            -- added 14.02.2012
            WHEN OTHERS THEN
              NULL;
          END;

          /*    old logic
          SELECT PK_BOOKED_DISCHARGE_ID
          INTO   l_v_discharge_list_id
          FROM   TOS_DL_BOOKED_DISCHARGE
          WHERE  FK_BOOKING_NO              = l_cur_booked_data_rec.FK_BOOKING_NO
          AND    FK_BKG_EQUIPM_DTL          = l_cur_booked_data_rec.FK_BKG_EQUIPM_DTL
          AND    DN_EQUIPMENT_NO            = l_cur_booked_data_rec.DN_EQUIPMENT_NO
          AND    FK_BKG_VOYAGE_ROUTING_DTL  = l_cur_booked_data_rec.FK_BKG_VOYAGE_ROUTING_DTL
          -- AND    CONTAINER_SEQ_NO           = l_cur_booked_data_rec.CONTAINER_SEQ_NO commented by vikas verma
          AND RECORD_STATUS='A';

          /* GET LOCK ON TABLE*
          BEGIN
              SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
              INTO l_v_lock_data
              FROM TOS_DL_BOOKED_DISCHARGE
              WHERE PK_BOOKED_DISCHARGE_ID = l_v_discharge_list_id
              FOR UPDATE NOWAIT;

          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
              RETURN;
          WHEN OTHERS THEN
              p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
              RETURN;
          END;

          /* update record in booked discharge list table *

          UPDATE TOS_DL_BOOKED_DISCHARGE
          SET DN_LOADING_STATUS  = l_cur_booked_data_rec.LOADING_STATUS
            , RECORD_CHANGE_USER = p_i_v_user_id
            , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
          WHERE PK_BOOKED_DISCHARGE_ID = l_v_discharge_list_id
          AND DISCHARGE_STATUS <> 'DI';

          *
              End added by vikas, 13.12.2011
          */
        END IF;

        /* Synchronize Next POD?s   */
        PRE_EDL_POD_UPDATE(L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID,
                           L_CUR_BOOKED_DATA_REC.FK_BOOKING_NO,
                           LL_DL_FLAG,
                           L_CUR_BOOKED_DATA_REC.FK_BKG_VOYAGE_ROUTING_DTL,
                           L_CUR_BOOKED_DATA_REC.LOAD_CONDITION,
                           L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT,
                           --*29 begin
                           L_CUR_BOOKED_DATA_REC.VGM, --*34
                           L_CUR_BOOKED_DATA_REC.CATEGORY_CODE,
                           --*29 end
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

        /* Get lock on the table. */
        PCV_ELL_RECORD_LOCK(L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID,
                            TO_CHAR(L_CUR_BOOKED_DATA_REC.RECORD_CHANGE_DATE,
                                    'YYYYMMDDHH24MISS'),
                            'BOOKED',
                            P_O_V_ERR_CD);

        IF ((P_O_V_ERR_CD IS NULL) OR
           (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
          RETURN;
        END IF;
        --*26 , *27 start
        --Log port class change
        PRE_LOG_PORTCLASS_CHANGE(L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID,
                                 L_CUR_BOOKED_DATA_REC.FK_PORT_CLASS,
                                 L_CUR_BOOKED_DATA_REC.FK_IMDG,
                                 L_CUR_BOOKED_DATA_REC.FK_UNNO,
                                 L_CUR_BOOKED_DATA_REC.FK_UN_VAR,
                                 'L',
                                 P_I_V_USER_ID);
        --*26 end
        UPDATE TOS_LL_BOOKED_LOADING
           SET DN_EQUIPMENT_NO           = L_CUR_BOOKED_DATA_REC.DN_EQUIPMENT_NO
              ,LOCAL_TERMINAL_STATUS     = L_CUR_BOOKED_DATA_REC.LOCAL_TERMINAL_STATUS
              ,MIDSTREAM_HANDLING_CODE   = L_CUR_BOOKED_DATA_REC.MIDSTREAM_HANDLING_CODE
              ,LOAD_CONDITION            = L_CUR_BOOKED_DATA_REC.LOAD_CONDITION
              ,LOADING_STATUS            = L_CUR_BOOKED_DATA_REC.LOADING_STATUS
              ,STOWAGE_POSITION          = L_CUR_BOOKED_DATA_REC.STOWAGE_POSITION
              ,ACTIVITY_DATE_TIME        = TO_DATE(L_CUR_BOOKED_DATA_REC.ACTIVITY_DATE_TIME,
                                                   'DD/MM/YYYY HH24:MI')
              ,CONTAINER_GROSS_WEIGHT    = L_CUR_BOOKED_DATA_REC.CONTAINER_GROSS_WEIGHT
              --*29 begin
              ,VGM = L_CUR_BOOKED_DATA_REC.VGM --*34
              ,CATEGORY_CODE = L_CUR_BOOKED_DATA_REC.CATEGORY_CODE
              --*29 end
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
              ,OVERHEIGHT_CM             = L_CUR_BOOKED_DATA_REC.OVERHEIGHT_CM
              ,OVERWIDTH_LEFT_CM         = L_CUR_BOOKED_DATA_REC.OVERWIDTH_LEFT_CM
              ,OVERWIDTH_RIGHT_CM        = L_CUR_BOOKED_DATA_REC.OVERWIDTH_RIGHT_CM
              ,OVERLENGTH_FRONT_CM       = L_CUR_BOOKED_DATA_REC.OVERLENGTH_FRONT_CM
              ,OVERLENGTH_REAR_CM        = L_CUR_BOOKED_DATA_REC.OVERLENGTH_REAR_CM
              ,REEFER_TMP                = L_CUR_BOOKED_DATA_REC.REEFER_TMP
              ,REEFER_TMP_UNIT           = L_CUR_BOOKED_DATA_REC.REEFER_TMP_UNIT
              ,DN_HUMIDITY               = L_CUR_BOOKED_DATA_REC.DN_HUMIDITY
              ,PUBLIC_REMARK             = L_CUR_BOOKED_DATA_REC.PUBLIC_REMARK
              ,RECORD_CHANGE_USER        = P_I_V_USER_ID
              ,RECORD_CHANGE_DATE        = TO_DATE(P_I_V_DATE,
                                                   'YYYYMMDDHH24MISS')
              ,LOCAL_STATUS              = L_CUR_BOOKED_DATA_REC.LOCAL_STATUS
              ,EX_MLO_VESSEL             = L_CUR_BOOKED_DATA_REC.EX_MLO_VESSEL
              ,EX_MLO_VESSEL_ETA         = TO_DATE(L_CUR_BOOKED_DATA_REC.EX_MLO_VESSEL_ETA,
                                                   'DD/MM/YYYY HH24:MI')
              ,EX_MLO_VOYAGE             = L_CUR_BOOKED_DATA_REC.EX_MLO_VOYAGE
              ,DN_VENTILATION            = L_CUR_BOOKED_DATA_REC.DN_VENTILATION
              ,MLO_DEL                   = L_CUR_BOOKED_DATA_REC.MLO_DEL
              ,RESIDUE_ONLY_FLAG         = L_CUR_BOOKED_DATA_REC.RESIDUE_ONLY_FLAG
              ,CRANE_TYPE                = L_CUR_BOOKED_DATA_REC.CRAN_DESCRIPTION -- *8
         WHERE PK_BOOKED_LOADING_ID =
               L_CUR_BOOKED_DATA_REC.PK_BOOKED_LOADING_ID;
      END IF;

      /* update booking status count in tos_ll_load_list table */
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(TO_NUMBER(L_CUR_BOOKED_DATA_REC.FK_LOAD_LIST_ID),
                                                     LL_DL_FLAG,
                                                     P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD = 0) THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      ELSE
        --  p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
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
  END PRE_ELL_SAVE_BOOKED_TAB_MAIN;

  PROCEDURE PRE_ELL_BOOKED_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                     ,P_I_ROW_NUM             NUMBER
                                     ,P_I_V_LOAD_LIST_ID      VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                     ,P_I_V_PK_LOAD_LIST      VARCHAR2
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
                                     ,P_I_V_LOAD_ETD          VARCHAR2
                                     ,P_I_V_HDR_ETD_TM        VARCHAR2
                                     ,P_O_V_ERR_CD            OUT VARCHAR2) AS

    L_V_ERRORS       VARCHAR2(2000);
    L_V_RECORD_COUNT NUMBER := 0;
    L_V_SHIPMENT_TYP TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP%TYPE; -- *2

  BEGIN
    -- Set the error code to its default value (0000);
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_LL_BOOKED_LOADING_TMP
     WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
       AND DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       AND PK_BOOKED_LOADING_ID != P_I_V_PK_LOAD_LIST
       AND SESSION_ID = P_I_V_SESSION_ID;

    -- When count is more then zero means record is already availabe, show error
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'ELL.SE0127' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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
        FROM TOS_LL_BOOKED_LOADING
       WHERE PK_BOOKED_LOADING_ID = P_I_V_PK_LOAD_LIST;

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
                                             P_I_V_LOAD_ETD,
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
    PRE_ELL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE1,
                            P_I_V_EQUIPMENT_NO,
                            P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the Container Loading Remark Code2 in dolphin master table. */
    PRE_ELL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE2,
                            P_I_V_EQUIPMENT_NO,
                            P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    IF P_I_V_DN_SOC_COC = 'C' THEN
      /* Check for the Slot Operator in OPERATOR_CODE Master Table. */
      PRE_ELL_OL_VAL_OPERATOR_CODE(P_I_V_SLOT_OPERATOR,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* Check for the Container Operator in OPERATOR_CODE Master Table */
      PRE_ELL_OL_VAL_OPERATOR_CODE(P_I_V_OPER_CD,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* Check for the Out Slot Operator in OPERATOR_CODE Master Table.
          PRE_ELL_OL_VAL_OPERATOR_CODE( p_i_v_OUT_SLOT_OPERATOR, p_i_v_equipment_no, p_o_v_err_cd);
          IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
              RETURN;
          END IF ;
      */

    END IF;
    /*    Handling Instruction Code1 validation */
    PRE_ELL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE1,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code2 validation */
    PRE_ELL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE2,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code3 validation */
    PRE_ELL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE3,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the IMDG Code in IMDG Master Table. */
    PRE_ELL_OL_VAL_IMDG(P_I_V_UNNO,
                        P_I_V_VARIANT,
                        P_I_V_IMDG,
                        P_I_V_EQUIPMENT_NO,
                        P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Validate UN Number and UN Number Variant */
    PRE_ELL_OL_VAL_UNNO(P_I_V_UNNO,
                        P_I_V_VARIANT,
                        P_I_V_EQUIPMENT_NO,
                        P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Validate Port Class Type if no data found then show error message: Invalid Port Class. */
    --*24 start
    /*
    PRE_ELL_OL_VAL_PORT_CLASS( p_i_v_port_code
        , p_i_v_unno, p_i_v_variant
        , p_i_v_imdg, p_i_v_port_class
        , p_i_v_port_class_type , p_i_v_equipment_no, p_o_v_err_cd);

    IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
        RETURN;
    END IF ;
     --*24 end
    */
    PRE_ELL_OL_VAL_PORT_CLASS_TYPE(P_I_V_PORT_CODE,
                                   P_I_V_PORT_CLASS_TYPE,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN;

  END PRE_ELL_BOOKED_VALIDATION;

  PROCEDURE PRE_ELL_SYNCH_BOOKING(P_I_V_PK_BOOKED_ID        VARCHAR2
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
                                 ,P_I_V_CATEGORY            VARCHAR2 --*29
                                 ,P_I_V_VGM                 VARCHAR2 --*34
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
    L_V_CATEGORY TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE%TYPE;
    L_V_FIRST_LEG_FLAG VARCHAR2(1 CHAR);
    V_VGM              NUMBER; --*34
      --*29 begin
        l_v_user                 BKP009.BICUSR%TYPE := 'EZLL';
        l_v_date                 BKP009.BICDAT%TYPE;
        l_v_time                 BKP009.BICTIM%TYPE;
    --*29 end

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

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
          ,REEFER_TMP
          ,DN_HUMIDITY
          ,CONTAINER_GROSS_WEIGHT
          ,DN_VENTILATION
          ,CATEGORY_CODE --*29
          ,NVL(FIRST_LEG_FLAG,'N') --*29
          ,VGM --*34
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
          ,L_V_CATEGORY --*29
          ,L_V_FIRST_LEG_FLAG --*29
          ,V_VGM --*34
      FROM TOS_LL_BOOKED_LOADING
     WHERE PK_BOOKED_LOADING_ID = P_I_V_PK_BOOKED_ID;

    -- check the value of passed data from db value
    IF (NVL(P_I_V_DN_EQUIPMENT_NO, '~') <> NVL(L_V_EQUIPNO, '~')) THEN
      L_V_EQUIPNO := NVL(P_I_V_DN_EQUIPMENT_NO, '~');
    ELSE
      L_V_EQUIPNO := NULL;
    END IF;

    IF (NVL(TO_NUMBER(P_I_V_OVERWIDTH_LEFT_CM), 0) <>
       NVL(L_N_OVERWIDTHLEFT, 0)) THEN
      L_N_OVERWIDTHLEFT := NVL(P_I_V_OVERWIDTH_LEFT_CM, 0);
    ELSE
      L_N_OVERWIDTHLEFT := NULL;
    END IF;

    IF (NVL(TO_NUMBER(P_I_V_OVERHEIGHT_CM), 0) <> NVL(L_N_OVERHEIGHT, 0)) THEN
      L_N_OVERHEIGHT := NVL(P_I_V_OVERHEIGHT_CM, 0);
    ELSE
      L_N_OVERHEIGHT := NULL;
    END IF;

    IF (NVL(TO_NUMBER(P_I_V_OVERWIDTH_RIGHT_CM), 0) <>
       NVL(L_N_OVERWIDTHRIGHT, 0)) THEN
      L_N_OVERWIDTHRIGHT := NVL(P_I_V_OVERWIDTH_RIGHT_CM, 0);
    ELSE
      L_N_OVERWIDTHRIGHT := NULL;
    END IF;

    IF (NVL(TO_NUMBER(P_I_V_OVERLENGTH_FRONT_CM), 0) <>
       NVL(L_N_OVERLENGTHFRONT, 0)) THEN
      L_N_OVERLENGTHFRONT := NVL(P_I_V_OVERLENGTH_FRONT_CM, 0);
    ELSE
      L_N_OVERLENGTHFRONT := NULL;
    END IF;

    IF (NVL(TO_NUMBER(P_I_V_OVERLENGTH_REAR_CM), 0) <>
       NVL(L_N_OVERLENGTHREAR, 0)) THEN
      L_N_OVERLENGTHREAR := NVL(P_I_V_OVERLENGTH_REAR_CM, 0);
    ELSE
      L_N_OVERLENGTHREAR := NULL;
    END IF;

    IF (NVL(P_I_V_FK_IMDG, '~') <> NVL(L_V_IMDG, '~')) THEN
      L_V_IMDG := NVL(P_I_V_FK_IMDG, '~');
    ELSE
      L_V_IMDG := NULL;
    END IF;

    IF (NVL(P_I_V_FK_UNNO, ' ') <> NVL(L_V_UNNO, ' ')) THEN
      L_V_UNNO := NVL(P_I_V_FK_UNNO, '~');
    ELSE
      L_V_UNNO := NULL;
    END IF;

    IF (NVL(P_I_V_FK_UN_VAR, '~') <> NVL(L_V_UNVAR, '~')) THEN
      L_V_UNVAR := NVL(P_I_V_FK_UN_VAR, '~');
    ELSE
      L_V_UNVAR := NULL;
    END IF;

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

    IF (NVL(P_I_V_FLASH_UNIT, '~') <> NVL(L_V_FLASHUNIT, '~')) THEN
      L_V_FLASHUNIT := NVL(P_I_V_FLASH_UNIT, '~');
    ELSE
      L_V_FLASHUNIT := NULL;
    END IF;

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

    IF (NVL(P_I_V_REEFER_TMP_UNIT, '~') <> NVL(L_V_REEFERTMPUNIT, '~')) THEN
      L_V_REEFERTMPUNIT := NVL(P_I_V_REEFER_TMP_UNIT, '~');
    ELSE
      L_V_REEFERTMPUNIT := NULL;
    END IF;

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

    IF (NVL(TO_NUMBER(P_I_V_WEIGHT), 0) <> NVL(L_N_GROSSWT, 0)) THEN
      L_N_GROSSWT := NVL(P_I_V_WEIGHT, 0);
    ELSE
     /*-- coment *32 by Watcharee C.
      IF (P_I_V_WEIGHT IS NOT NULL AND L_N_GROSSWT IS NULL)
         OR (P_I_V_WEIGHT IS NULL AND L_N_GROSSWT IS NOT NULL) THEN
        L_N_GROSSWT := 0;
      ELSE
        L_N_GROSSWT := NULL;
      END IF; --*/
        L_N_GROSSWT := NULL;
    END IF;

    --*29 BEGIN
     --IF (NVL(P_I_V_CATEGORY, '~') <> NVL(L_V_CATEGORY, '~')) THEN
      IF (NVL(P_I_V_CATEGORY, ' ') <> NVL(L_V_CATEGORY, ' ')) THEN --*35
     -- L_V_CATEGORY := NVL(P_I_V_CATEGORY, '~');
      L_V_CATEGORY := NVL(P_I_V_CATEGORY, ' '); --*35 
    ELSE
      L_V_CATEGORY := NULL;
    END IF;

    --*29 END
    -- START *34
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
    -- END *34

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
                                                       L_V_CATEGORY, --*29
                                                       --L_V_FIRST_LEG_FLAG, --*29
                                                       V_VGM, --*34
                                                       P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD = '0') THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      --*29 begin
       --get user update

       BEGIN
            SELECT
            'EZLL'
            , TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD'))
            , TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI'))
        INTO
            l_v_user
            , l_v_date
            , l_v_time
        FROM
            DUAL;
       END;
       -- Update category for flow data to all leg.
     --  insert into TEMP_20150424_STMT_TEST values (sysdate,'L_V_CATEGORY : '||L_V_CATEGORY,'',''); commit;
         BEGIN
            UPDATE BKP009
            SET EQP_CATEGORY = NVL(L_V_CATEGORY,EQP_CATEGORY)
                 , BICUSR        = l_v_user
                , BICDAT        = l_v_date
                , BICTIM        = l_v_time
            WHERE  BIBKNO   = P_I_V_FK_BOOKING_NO
            AND    BISEQN   = P_I_V_CONTAINER_SEQ_NO;
            COMMIT;
        END;
      --*29 end
    ELSE
      /* Error in Synchronization Equipment Update */
      P_O_V_ERR_CD := 'EDL.SE0179';
      RETURN;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_ELL_SYNCH_BOOKING;

  PROCEDURE PRE_ELL_SAVE_OVERSHIP_TAB_MAIN(P_I_V_SESSION_ID IN VARCHAR2
                                          ,P_I_V_USER_ID    IN VARCHAR2
                                          ,P_I_V_VESSEL     IN VARCHAR2
                                          ,P_I_V_ETA        IN VARCHAR2
                                          ,P_I_V_HDR_ETA_TM IN VARCHAR2
                                          ,P_I_V_PORT_CODE  IN VARCHAR2
                                          ,P_I_V_DATE       IN VARCHAR2
                                          ,P_I_V_LOAD_ETD   IN VARCHAR2
                                          ,P_I_V_HDR_ETD_TM IN VARCHAR2
                                          ,P_O_V_ERR_CD     OUT VARCHAR2) AS
    L_V_LOAD_CONDITION           VARCHAR2(1);
    L_V_LOCK_DATA                VARCHAR2(14);
    L_V_ERRORS                   VARCHAR2(2000);
    L_V_OVERSHIPPED_CONTAINER_ID NUMBER := 0;
    L_N_RESTOW_ID                NUMBER := 0;
    L_V_OVERSHIPPED_ROW_NUM      NUMBER := 1;
    L_V_FK_BKG_SIZE_TYPE_DTL     NUMBER;
    L_V_FK_BKG_SUPPLIER          NUMBER;
    L_V_FK_BKG_EQUIPM_DTL        NUMBER;
    L_V_DN_SHIPMENT_TERM         VARCHAR2(4);
    L_V_DN_SHIPMENT_TYP          VARCHAR2(3);
    L_V_DISCHARGE_LIST_ID        NUMBER;
    L_V_LOAD_LIST_ID             NUMBER;
    L_V_FLAG                     VARCHAR2(1);
    EXP_ERROR_ON_SAVE EXCEPTION;
    L_V_RECORD_COUNT       NUMBER := 0;
    L_V_CONTAINER_OPERATOR VARCHAR2(4);

    /* Cursor to save overshipped tab data */
    CURSOR L_CUR_OVERSHIPPED_DATA IS
      SELECT SEQ_NO
            ,PK_OVERSHIPPED_CONTAINER_ID
            ,FK_LOAD_LIST_ID
            ,BOOKING_NO
            ,BOOKING_NO_SOURCE
            ,EQUIPMENT_NO
            ,EQUIPMENT_NO_QUESTIONABLE_FLAG
            ,EQ_SIZE
            ,EQ_TYPE
            ,FULL_MT
            ,BKG_TYP
            ,FLAG_SOC_COC
            ,SHIPMENT_TERM
            ,SHIPMENT_TYPE
            ,LOCAL_STATUS
            ,LOCAL_TERMINAL_STATUS
            ,MIDSTREAM_HANDLING_CODE
            ,LOAD_CONDITION
            ,LOADING_STATUS
            ,STOWAGE_POSITION
            ,ACTIVITY_DATE_TIME
            ,CONTAINER_GROSS_WEIGHT
            ,DAMAGED
            ,VOID_SLOT
            ,PREADVICE_FLAG
            ,SLOT_OPERATOR
            ,CONTAINER_OPERATOR
            ,OUT_SLOT_OPERATOR
            ,SPECIAL_HANDLING
            ,SEAL_NO
            ,DISCHARGE_PORT
            ,POD_TERMINAL
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
            ,EX_MLO_VESSEL
            ,EX_MLO_VESSEL_ETA
            ,EX_MLO_VOYAGE
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
            ,PORT_CLASS_TYPE
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
            ,OPN_STATUS
            ,DECODE(OPN_STATUS, PCE_EUT_COMMON.G_V_REC_DEL, '1') ORD_SEQ
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE
            ,VGM --*34
        FROM TOS_LL_OVERSHIPPED_CONT_TMP
       WHERE SESSION_ID = P_I_V_SESSION_ID
       ORDER BY ORD_SEQ
               ,SEQ_NO;

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    FOR L_CUR_OVERSHIPPED_DATA_REC IN L_CUR_OVERSHIPPED_DATA
    LOOP
      IF (L_CUR_OVERSHIPPED_DATA_REC.FLAG_SOC_COC = 'C') THEN
        L_V_CONTAINER_OPERATOR := 'RCL';
      ELSE
        L_V_CONTAINER_OPERATOR := L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_OPERATOR;
      END IF;

      IF (L_CUR_OVERSHIPPED_DATA_REC.OPN_STATUS =
         PCE_EUT_COMMON.G_V_REC_ADD) THEN

        SELECT SE_OCZ02.NEXTVAL
          INTO L_V_OVERSHIPPED_CONTAINER_ID
          FROM DUAL;

        /* Call validation function for overshipped tab. */
        PRE_ELL_OVERSHIPPED_VALIDATION(P_I_V_SESSION_ID,
                                       L_V_OVERSHIPPED_ROW_NUM,
                                       L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID,
                                       L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO,
                                       L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID,
                                       L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_1,
                                       L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_2,
                                       L_V_CONTAINER_OPERATOR,
                                       L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_1,
                                       L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_2,
                                       L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_3,
                                       L_CUR_OVERSHIPPED_DATA_REC.UN_NUMBER,
                                       L_CUR_OVERSHIPPED_DATA_REC.UN_NUMBER_VARIANT,
                                       L_CUR_OVERSHIPPED_DATA_REC.IMDG_CLASS,
                                       P_I_V_PORT_CODE,
                                       L_CUR_OVERSHIPPED_DATA_REC.PORT_CLASS,
                                       L_CUR_OVERSHIPPED_DATA_REC.PORT_CLASS_TYPE,
                                       L_CUR_OVERSHIPPED_DATA_REC.OUT_SLOT_OPERATOR,
                                       L_CUR_OVERSHIPPED_DATA_REC.SLOT_OPERATOR,
                                       L_CUR_OVERSHIPPED_DATA_REC.SHIPMENT_TERM,
                                       L_CUR_OVERSHIPPED_DATA_REC.FLAG_SOC_COC,
                                       P_I_V_LOAD_ETD,
                                       P_I_V_HDR_ETD_TM,
                                       L_CUR_OVERSHIPPED_DATA_REC.EQ_TYPE,
                                       L_CUR_OVERSHIPPED_DATA_REC.DISCHARGE_PORT,
                                       L_CUR_OVERSHIPPED_DATA_REC.POD_TERMINAL,
                                       P_O_V_ERR_CD);

        /* Move data from temp table to main table.
        IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
            RETURN;
        END IF;
        */

        IF (L_CUR_OVERSHIPPED_DATA_REC.LOADING_STATUS NOT IN ('OS')) THEN
          SELECT COUNT(1)
            INTO L_V_RECORD_COUNT
            FROM TOS_RESTOW
           WHERE FK_LOAD_LIST_ID =
                 L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID
             AND DN_EQUIPMENT_NO = L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO;

          -- When count is more then zero means record is already availabe, show error
          IF (L_V_RECORD_COUNT > 0) THEN
            P_O_V_ERR_CD := 'ELL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                            L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO ||
                            PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          /*Start added by vikas as logic is changed, 22.11.2011*/
          PCE_EDL_DLMAINTENANCE.PRE_PREV_LOAD_LIST_ID(L_CUR_OVERSHIPPED_DATA_REC.BOOKING_NO,
                                                      L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO,
                                                      L_CUR_OVERSHIPPED_DATA_REC.POD_TERMINAL,
                                                      L_CUR_OVERSHIPPED_DATA_REC.DISCHARGE_PORT,
                                                      L_V_LOAD_LIST_ID,
                                                      L_V_FLAG,
                                                      P_O_V_ERR_CD);
          /* End added by vikas, 22.11.2011*/

          /* Start Commented by vikas, 22.11.2011 *
          PRE_ELL_PREV_LOAD_LIST_ID (
                p_i_v_vessel
              , l_cur_overshipped_data_rec.EQUIPMENT_NO
              , l_cur_overshipped_data_rec.BOOKING_NO
              , p_i_v_eta
              , p_i_v_hdr_eta_tm
              , p_i_v_port_code
              , l_v_load_list_id
              , l_v_flag
              , p_o_v_err_cd
          );
          * End commented by vikas, 22.11.2011*/

          IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
             P_O_V_ERR_CD <> 'ELL.SE0121') THEN
            RETURN;
          END IF;
          IF (P_O_V_ERR_CD = 'ELL.SE0121') THEN
            G_V_WARNING := 'ELL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                           L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO ||
                           PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

            SELECT FK_BKG_SIZE_TYPE_DTL
                  ,FK_BKG_SUPPLIER
                  ,FK_BKG_EQUIPM_DTL
                  ,LOAD_CONDITION
                  ,DN_SHIPMENT_TERM
                  ,DN_SHIPMENT_TYP
              INTO L_V_FK_BKG_SIZE_TYPE_DTL
                  ,L_V_FK_BKG_SUPPLIER
                  ,L_V_FK_BKG_EQUIPM_DTL
                  ,L_V_LOAD_CONDITION
                  ,L_V_DN_SHIPMENT_TERM
                  ,L_V_DN_SHIPMENT_TYP

              FROM TOS_LL_BOOKED_LOADING
             WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;

            SELECT SE_OCZ01.NEXTVAL INTO L_N_RESTOW_ID FROM DUAL;

            INSERT INTO TOS_RESTOW
              (PK_RESTOW_ID
              ,FK_LOAD_LIST_ID
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
              ,L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID
              ,L_CUR_OVERSHIPPED_DATA_REC.BOOKING_NO
              ,L_V_FK_BKG_SIZE_TYPE_DTL
              ,L_V_FK_BKG_SUPPLIER
              ,L_V_FK_BKG_EQUIPM_DTL
              ,L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO
              ,L_CUR_OVERSHIPPED_DATA_REC.EQ_SIZE
              ,L_CUR_OVERSHIPPED_DATA_REC.EQ_TYPE
              ,L_CUR_OVERSHIPPED_DATA_REC.FLAG_SOC_COC
              ,L_V_DN_SHIPMENT_TERM
              ,L_V_DN_SHIPMENT_TYP
              ,L_CUR_OVERSHIPPED_DATA_REC.MIDSTREAM_HANDLING_CODE
              ,L_V_LOAD_CONDITION
              ,L_CUR_OVERSHIPPED_DATA_REC.LOADING_STATUS
              ,L_CUR_OVERSHIPPED_DATA_REC.STOWAGE_POSITION
              ,L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_GROSS_WEIGHT
              ,L_CUR_OVERSHIPPED_DATA_REC.DAMAGED
              ,L_CUR_OVERSHIPPED_DATA_REC.VOID_SLOT
              ,L_CUR_OVERSHIPPED_DATA_REC.SLOT_OPERATOR
              ,L_V_CONTAINER_OPERATOR
              ,L_CUR_OVERSHIPPED_DATA_REC.SPECIAL_HANDLING
              ,L_CUR_OVERSHIPPED_DATA_REC.SEAL_NO
              ,L_CUR_OVERSHIPPED_DATA_REC.SPECIAL_CARGO
              ,'A'
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS'));

          END IF;

        ELSE

          INSERT INTO TOS_LL_OVERSHIPPED_CONTAINER
            (PK_OVERSHIPPED_CONTAINER_ID
            ,FK_LOAD_LIST_ID
            ,BOOKING_NO
            ,BOOKING_NO_SOURCE
            ,EQUIPMENT_NO
            ,EQ_SIZE
            ,EQ_TYPE
            ,FULL_MT
            ,BKG_TYP
            ,FLAG_SOC_COC
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
            ,DISCHARGE_PORT
            ,POD_TERMINAL
            ,MLO_VESSEL
            ,MLO_VOYAGE
            ,MLO_VESSEL_ETA
            ,MLO_POD1
            ,MLO_POD2
            ,MLO_POD3
            ,MLO_DEL
            ,EX_MLO_VESSEL
            ,EX_MLO_VESSEL_ETA
            ,EX_MLO_VOYAGE
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
            ,PORT_CLASS_TYPE
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
            ,RECORD_ADD_USER
            ,RECORD_ADD_DATE
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE
            ,VGM --*34
            )
          VALUES
            (L_V_OVERSHIPPED_CONTAINER_ID
            ,L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID
            ,L_CUR_OVERSHIPPED_DATA_REC.BOOKING_NO
            ,L_CUR_OVERSHIPPED_DATA_REC.BOOKING_NO_SOURCE
            ,L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO
            ,L_CUR_OVERSHIPPED_DATA_REC.EQ_SIZE
            ,L_CUR_OVERSHIPPED_DATA_REC.EQ_TYPE
            ,L_CUR_OVERSHIPPED_DATA_REC.FULL_MT
            ,L_CUR_OVERSHIPPED_DATA_REC.BKG_TYP
            ,L_CUR_OVERSHIPPED_DATA_REC.FLAG_SOC_COC
            ,L_CUR_OVERSHIPPED_DATA_REC.LOCAL_STATUS
            ,L_CUR_OVERSHIPPED_DATA_REC.LOCAL_TERMINAL_STATUS
            ,L_CUR_OVERSHIPPED_DATA_REC.MIDSTREAM_HANDLING_CODE
            ,L_CUR_OVERSHIPPED_DATA_REC.LOAD_CONDITION
            ,L_CUR_OVERSHIPPED_DATA_REC.STOWAGE_POSITION
            ,TO_DATE(L_CUR_OVERSHIPPED_DATA_REC.ACTIVITY_DATE_TIME,
                     'DD/MM/YYYY HH24:MI')
            ,L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_GROSS_WEIGHT
            ,L_CUR_OVERSHIPPED_DATA_REC.DAMAGED
            ,L_CUR_OVERSHIPPED_DATA_REC.VOID_SLOT
            ,L_CUR_OVERSHIPPED_DATA_REC.SLOT_OPERATOR
            ,L_V_CONTAINER_OPERATOR
            ,L_CUR_OVERSHIPPED_DATA_REC.OUT_SLOT_OPERATOR
            ,L_CUR_OVERSHIPPED_DATA_REC.SPECIAL_HANDLING
            ,L_CUR_OVERSHIPPED_DATA_REC.SEAL_NO
            ,L_CUR_OVERSHIPPED_DATA_REC.DISCHARGE_PORT
            ,L_CUR_OVERSHIPPED_DATA_REC.POD_TERMINAL
            ,L_CUR_OVERSHIPPED_DATA_REC.MLO_VESSEL
            ,L_CUR_OVERSHIPPED_DATA_REC.MLO_VOYAGE
            ,TO_DATE(L_CUR_OVERSHIPPED_DATA_REC.MLO_VESSEL_ETA,
                     'DD/MM/YYYY HH24:MI')
            ,L_CUR_OVERSHIPPED_DATA_REC.MLO_POD1
            ,L_CUR_OVERSHIPPED_DATA_REC.MLO_POD2
            ,L_CUR_OVERSHIPPED_DATA_REC.MLO_POD3
            ,L_CUR_OVERSHIPPED_DATA_REC.MLO_DEL
            ,L_CUR_OVERSHIPPED_DATA_REC.EX_MLO_VESSEL
            ,TO_DATE(L_CUR_OVERSHIPPED_DATA_REC.EX_MLO_VESSEL_ETA,
                     'DD/MM/YYYY HH24:MI')
            ,L_CUR_OVERSHIPPED_DATA_REC.EX_MLO_VOYAGE
            ,L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_1
            ,L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_2
            ,L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_3
            ,L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_1
            ,L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_2
            ,L_CUR_OVERSHIPPED_DATA_REC.SPECIAL_CARGO
            ,L_CUR_OVERSHIPPED_DATA_REC.IMDG_CLASS
            ,L_CUR_OVERSHIPPED_DATA_REC.UN_NUMBER
            ,L_CUR_OVERSHIPPED_DATA_REC.UN_NUMBER_VARIANT
            ,L_CUR_OVERSHIPPED_DATA_REC.PORT_CLASS
            ,L_CUR_OVERSHIPPED_DATA_REC.PORT_CLASS_TYPE
            ,L_CUR_OVERSHIPPED_DATA_REC.FLASHPOINT_UNIT
            ,L_CUR_OVERSHIPPED_DATA_REC.FLASHPOINT
            ,L_CUR_OVERSHIPPED_DATA_REC.FUMIGATION_ONLY
            ,L_CUR_OVERSHIPPED_DATA_REC.RESIDUE_ONLY_FLAG
            ,L_CUR_OVERSHIPPED_DATA_REC.OVERHEIGHT_CM
            ,L_CUR_OVERSHIPPED_DATA_REC.OVERWIDTH_LEFT_CM
            ,L_CUR_OVERSHIPPED_DATA_REC.OVERWIDTH_RIGHT_CM
            ,L_CUR_OVERSHIPPED_DATA_REC.OVERLENGTH_FRONT_CM
            ,L_CUR_OVERSHIPPED_DATA_REC.OVERLENGTH_REAR_CM
            ,L_CUR_OVERSHIPPED_DATA_REC.REEFER_TEMPERATURE
            ,L_CUR_OVERSHIPPED_DATA_REC.REEFER_TMP_UNIT
            ,L_CUR_OVERSHIPPED_DATA_REC.HUMIDITY
            ,L_CUR_OVERSHIPPED_DATA_REC.VENTILATION
            ,'A'
            ,P_I_V_USER_ID
            ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
            ,P_I_V_USER_ID
            ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
            ,L_CUR_OVERSHIPPED_DATA_REC.VGM --*34
            )
            ;
        END IF;

      ELSIF (L_CUR_OVERSHIPPED_DATA_REC.OPN_STATUS =
            PCE_EUT_COMMON.G_V_REC_UPD) THEN
        /* Call validation function for overshipped tab*/
        PRE_ELL_OVERSHIPPED_VALIDATION(P_I_V_SESSION_ID,
                                       L_V_OVERSHIPPED_ROW_NUM,
                                       L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID,
                                       L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO,
                                       L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID,
                                       L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_1,
                                       L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_2,
                                       L_V_CONTAINER_OPERATOR,
                                       L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_1,
                                       L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_2,
                                       L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_3,
                                       L_CUR_OVERSHIPPED_DATA_REC.UN_NUMBER,
                                       L_CUR_OVERSHIPPED_DATA_REC.UN_NUMBER_VARIANT,
                                       L_CUR_OVERSHIPPED_DATA_REC.IMDG_CLASS,
                                       P_I_V_PORT_CODE,
                                       L_CUR_OVERSHIPPED_DATA_REC.PORT_CLASS,
                                       L_CUR_OVERSHIPPED_DATA_REC.PORT_CLASS_TYPE,
                                       L_CUR_OVERSHIPPED_DATA_REC.OUT_SLOT_OPERATOR,
                                       L_CUR_OVERSHIPPED_DATA_REC.SLOT_OPERATOR,
                                       L_CUR_OVERSHIPPED_DATA_REC.SHIPMENT_TERM,
                                       L_CUR_OVERSHIPPED_DATA_REC.FLAG_SOC_COC,
                                       P_I_V_LOAD_ETD,
                                       P_I_V_HDR_ETD_TM,
                                       L_CUR_OVERSHIPPED_DATA_REC.EQ_TYPE,
                                       L_CUR_OVERSHIPPED_DATA_REC.DISCHARGE_PORT,
                                       L_CUR_OVERSHIPPED_DATA_REC.POD_TERMINAL,
                                       P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        PRE_TOS_REMOVE_ERROR(L_CUR_OVERSHIPPED_DATA_REC.DA_ERROR,
                             LL_DL_FLAG,
                             L_CUR_OVERSHIPPED_DATA_REC.EQ_SIZE,
                             L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_1,
                             L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_2,
                             L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO,
                             L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID,
                             L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID,
                             P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        IF (L_CUR_OVERSHIPPED_DATA_REC.LOADING_STATUS NOT IN ('OS')) THEN

          SELECT COUNT(1)
            INTO L_V_RECORD_COUNT
            FROM TOS_RESTOW
           WHERE FK_LOAD_LIST_ID =
                 L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID
             AND DN_EQUIPMENT_NO = L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO;

          -- When count is more then zero means record is already availabe, show error
          IF (L_V_RECORD_COUNT > 0) THEN
            P_O_V_ERR_CD := 'EDL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                            L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO ||
                            PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          /* Get Lock on table. */
          PCV_ELL_RECORD_LOCK(L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID,
                              TO_CHAR(L_CUR_OVERSHIPPED_DATA_REC.RECORD_CHANGE_DATE,
                                      'YYYYMMDDHH24MISS'),
                              'OVERSHIPPED',
                              P_O_V_ERR_CD);

          IF ((P_O_V_ERR_CD IS NULL) OR
             (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
            RETURN;
          END IF;

          /* Delete record from the overshipped table, and move to restow table.*/
          DELETE FROM TOS_LL_OVERSHIPPED_CONTAINER
           WHERE PK_OVERSHIPPED_CONTAINER_ID =
                 L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID;

          /*
              Start added by vikas, delete error message from tos_error_log table
              for this overshipped container, k'chatgamol, 15.12.2011
          */
          DELETE FROM TOS_ERROR_LOG
           WHERE FK_OVERSHIPPED_ID =
                 L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID;

          /*
              End added by vikas, 15.12.2011
          */

          /*Start added by vikas as logic is changed, 22.11.2011*/
          PCE_EDL_DLMAINTENANCE.PRE_PREV_LOAD_LIST_ID(L_CUR_OVERSHIPPED_DATA_REC.BOOKING_NO,
                                                      L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO,
                                                      L_CUR_OVERSHIPPED_DATA_REC.POD_TERMINAL,
                                                      L_CUR_OVERSHIPPED_DATA_REC.DISCHARGE_PORT,
                                                      L_V_LOAD_LIST_ID,
                                                      L_V_FLAG,
                                                      P_O_V_ERR_CD);
          /* End added by vikas, 22.11.2011*/

          /* Start Commented by vikas, 22.11.2011 *
          PRE_ELL_PREV_LOAD_LIST_ID (
                p_i_v_vessel
              , l_cur_overshipped_data_rec.EQUIPMENT_NO
              , l_cur_overshipped_data_rec.BOOKING_NO
              , p_i_v_eta
              , p_i_v_hdr_eta_tm
              , p_i_v_port_code
              , l_v_load_list_id
              , l_v_flag
              , p_o_v_err_cd
          );
          * End commented by vikas, 22.11.2011*/

          IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
             P_O_V_ERR_CD <> 'ELL.SE0121') THEN
            RETURN;
          END IF;
          IF (P_O_V_ERR_CD = 'ELL.SE0121') THEN
            G_V_WARNING := 'ELL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                           L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO ||
                           PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
          END IF;

          IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

            SELECT FK_BKG_SIZE_TYPE_DTL
                  ,FK_BKG_SUPPLIER
                  ,FK_BKG_EQUIPM_DTL
                  ,LOAD_CONDITION
                  ,DN_SHIPMENT_TERM
                  ,DN_SHIPMENT_TYP
              INTO L_V_FK_BKG_SIZE_TYPE_DTL
                  ,L_V_FK_BKG_SUPPLIER
                  ,L_V_FK_BKG_EQUIPM_DTL
                  ,L_V_LOAD_CONDITION
                  ,L_V_DN_SHIPMENT_TERM
                  ,L_V_DN_SHIPMENT_TYP

              FROM TOS_LL_BOOKED_LOADING
             WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;

            SELECT SE_OCZ01.NEXTVAL INTO L_N_RESTOW_ID FROM DUAL;

            INSERT INTO TOS_RESTOW
              (PK_RESTOW_ID
              ,FK_LOAD_LIST_ID
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
              ,L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID
              ,L_CUR_OVERSHIPPED_DATA_REC.BOOKING_NO
              ,L_V_FK_BKG_SIZE_TYPE_DTL
              ,L_V_FK_BKG_SUPPLIER
              ,L_V_FK_BKG_EQUIPM_DTL
              ,L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO
              ,L_CUR_OVERSHIPPED_DATA_REC.EQ_SIZE
              ,L_CUR_OVERSHIPPED_DATA_REC.EQ_TYPE
              ,L_CUR_OVERSHIPPED_DATA_REC.FLAG_SOC_COC
              ,L_V_DN_SHIPMENT_TERM
              ,L_V_DN_SHIPMENT_TYP
              ,L_CUR_OVERSHIPPED_DATA_REC.MIDSTREAM_HANDLING_CODE
              ,L_V_LOAD_CONDITION
              ,L_CUR_OVERSHIPPED_DATA_REC.LOADING_STATUS
              ,L_CUR_OVERSHIPPED_DATA_REC.STOWAGE_POSITION
              ,L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_GROSS_WEIGHT
              ,L_CUR_OVERSHIPPED_DATA_REC.DAMAGED
              ,L_CUR_OVERSHIPPED_DATA_REC.VOID_SLOT
              ,L_CUR_OVERSHIPPED_DATA_REC.SLOT_OPERATOR
              ,L_V_CONTAINER_OPERATOR
              ,L_CUR_OVERSHIPPED_DATA_REC.SPECIAL_HANDLING
              ,L_CUR_OVERSHIPPED_DATA_REC.SEAL_NO
              ,L_CUR_OVERSHIPPED_DATA_REC.SPECIAL_CARGO
              ,'A'
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
              ,P_I_V_USER_ID
              ,TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS'));

          END IF;

        ELSE
          /* Normal update case */
          PCV_ELL_RECORD_LOCK(L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID,
                              TO_CHAR(L_CUR_OVERSHIPPED_DATA_REC.RECORD_CHANGE_DATE,
                                      'YYYYMMDDHH24MISS'),
                              'OVERSHIPPED',
                              P_O_V_ERR_CD);

          IF ((P_O_V_ERR_CD IS NULL) OR
             (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
            RETURN;
          END IF;

          UPDATE TOS_LL_OVERSHIPPED_CONTAINER
             SET BOOKING_NO              = L_CUR_OVERSHIPPED_DATA_REC.BOOKING_NO
                ,EQUIPMENT_NO            = L_CUR_OVERSHIPPED_DATA_REC.EQUIPMENT_NO
                ,EQ_SIZE                 = L_CUR_OVERSHIPPED_DATA_REC.EQ_SIZE
                ,EQ_TYPE                 = L_CUR_OVERSHIPPED_DATA_REC.EQ_TYPE
                ,FULL_MT                 = L_CUR_OVERSHIPPED_DATA_REC.FULL_MT
                ,BKG_TYP                 = L_CUR_OVERSHIPPED_DATA_REC.BKG_TYP
                ,FLAG_SOC_COC            = L_CUR_OVERSHIPPED_DATA_REC.FLAG_SOC_COC
                ,LOCAL_STATUS            = L_CUR_OVERSHIPPED_DATA_REC.LOCAL_STATUS
                ,LOCAL_TERMINAL_STATUS   = L_CUR_OVERSHIPPED_DATA_REC.LOCAL_TERMINAL_STATUS
                ,MIDSTREAM_HANDLING_CODE = L_CUR_OVERSHIPPED_DATA_REC.MIDSTREAM_HANDLING_CODE
                ,LOAD_CONDITION          = L_CUR_OVERSHIPPED_DATA_REC.LOAD_CONDITION
                ,STOWAGE_POSITION        = L_CUR_OVERSHIPPED_DATA_REC.STOWAGE_POSITION
                ,ACTIVITY_DATE_TIME      = TO_DATE(L_CUR_OVERSHIPPED_DATA_REC.ACTIVITY_DATE_TIME,
                                                   'DD/MM/YYYY HH24:MI')
                ,CONTAINER_GROSS_WEIGHT  = L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_GROSS_WEIGHT
                ,DAMAGED                 = L_CUR_OVERSHIPPED_DATA_REC.DAMAGED
                ,VOID_SLOT               = L_CUR_OVERSHIPPED_DATA_REC.VOID_SLOT
                ,SLOT_OPERATOR           = L_CUR_OVERSHIPPED_DATA_REC.SLOT_OPERATOR
                ,CONTAINER_OPERATOR      = L_V_CONTAINER_OPERATOR
                ,OUT_SLOT_OPERATOR       = L_CUR_OVERSHIPPED_DATA_REC.OUT_SLOT_OPERATOR
                ,SPECIAL_HANDLING        = L_CUR_OVERSHIPPED_DATA_REC.SPECIAL_HANDLING
                ,SEAL_NO                 = L_CUR_OVERSHIPPED_DATA_REC.SEAL_NO
                ,DISCHARGE_PORT          = L_CUR_OVERSHIPPED_DATA_REC.DISCHARGE_PORT
                ,POD_TERMINAL            = L_CUR_OVERSHIPPED_DATA_REC.POD_TERMINAL
                ,MLO_VESSEL              = L_CUR_OVERSHIPPED_DATA_REC.MLO_VESSEL
                ,MLO_VOYAGE              = L_CUR_OVERSHIPPED_DATA_REC.MLO_VOYAGE
                ,MLO_VESSEL_ETA          = TO_DATE(L_CUR_OVERSHIPPED_DATA_REC.MLO_VESSEL_ETA,
                                                   'DD/MM/YYYY HH24:MI')
                ,MLO_POD1                = L_CUR_OVERSHIPPED_DATA_REC.MLO_POD1
                ,MLO_POD2                = L_CUR_OVERSHIPPED_DATA_REC.MLO_POD2
                ,MLO_POD3                = L_CUR_OVERSHIPPED_DATA_REC.MLO_POD3
                ,MLO_DEL                 = L_CUR_OVERSHIPPED_DATA_REC.MLO_DEL
                ,EX_MLO_VESSEL           = L_CUR_OVERSHIPPED_DATA_REC.EX_MLO_VESSEL
                ,EX_MLO_VESSEL_ETA       = TO_DATE(L_CUR_OVERSHIPPED_DATA_REC.EX_MLO_VESSEL_ETA,
                                                   'DD/MM/YYYY HH24:MI')
                ,EX_MLO_VOYAGE           = L_CUR_OVERSHIPPED_DATA_REC.EX_MLO_VOYAGE
                ,HANDLING_INSTRUCTION_1  = L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_1
                ,HANDLING_INSTRUCTION_2  = L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_2
                ,HANDLING_INSTRUCTION_3  = L_CUR_OVERSHIPPED_DATA_REC.HANDLING_INSTRUCTION_3
                ,CONTAINER_LOADING_REM_1 = L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_1
                ,CONTAINER_LOADING_REM_2 = L_CUR_OVERSHIPPED_DATA_REC.CONTAINER_LOADING_REM_2
                ,SPECIAL_CARGO           = L_CUR_OVERSHIPPED_DATA_REC.SPECIAL_CARGO
                ,IMDG_CLASS              = L_CUR_OVERSHIPPED_DATA_REC.IMDG_CLASS
                ,UN_NUMBER               = L_CUR_OVERSHIPPED_DATA_REC.UN_NUMBER
                ,UN_NUMBER_VARIANT       = L_CUR_OVERSHIPPED_DATA_REC.UN_NUMBER_VARIANT
                ,PORT_CLASS              = L_CUR_OVERSHIPPED_DATA_REC.PORT_CLASS
                ,PORT_CLASS_TYPE         = L_CUR_OVERSHIPPED_DATA_REC.PORT_CLASS_TYPE
                ,FLASHPOINT_UNIT         = L_CUR_OVERSHIPPED_DATA_REC.FLASHPOINT_UNIT
                ,FLASHPOINT              = L_CUR_OVERSHIPPED_DATA_REC.FLASHPOINT
                ,FUMIGATION_ONLY         = L_CUR_OVERSHIPPED_DATA_REC.FUMIGATION_ONLY
                ,RESIDUE_ONLY_FLAG       = L_CUR_OVERSHIPPED_DATA_REC.RESIDUE_ONLY_FLAG
                ,OVERHEIGHT_CM           = L_CUR_OVERSHIPPED_DATA_REC.OVERHEIGHT_CM
                ,OVERWIDTH_LEFT_CM       = L_CUR_OVERSHIPPED_DATA_REC.OVERWIDTH_LEFT_CM
                ,OVERWIDTH_RIGHT_CM      = L_CUR_OVERSHIPPED_DATA_REC.OVERWIDTH_RIGHT_CM
                ,OVERLENGTH_FRONT_CM     = L_CUR_OVERSHIPPED_DATA_REC.OVERLENGTH_FRONT_CM
                ,OVERLENGTH_REAR_CM      = L_CUR_OVERSHIPPED_DATA_REC.OVERLENGTH_REAR_CM
                ,REEFER_TEMPERATURE      = L_CUR_OVERSHIPPED_DATA_REC.REEFER_TEMPERATURE
                ,REEFER_TMP_UNIT         = L_CUR_OVERSHIPPED_DATA_REC.REEFER_TMP_UNIT
                ,HUMIDITY                = L_CUR_OVERSHIPPED_DATA_REC.HUMIDITY
                ,VENTILATION             = L_CUR_OVERSHIPPED_DATA_REC.VENTILATION
                ,DA_ERROR                = 'N'
                ,RECORD_CHANGE_USER      = P_I_V_USER_ID
                ,RECORD_CHANGE_DATE      = TO_DATE(P_I_V_DATE,
                                                   'YYYYMMDDHH24MISS')
                ,VGM  = L_CUR_OVERSHIPPED_DATA_REC.VGM --*34
           WHERE PK_OVERSHIPPED_CONTAINER_ID =
                 L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID;
        END IF;

      ELSIF (L_CUR_OVERSHIPPED_DATA_REC.OPN_STATUS =
            PCE_EUT_COMMON.G_V_REC_DEL) THEN

        PCV_ELL_RECORD_LOCK(L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID,
                            TO_CHAR(L_CUR_OVERSHIPPED_DATA_REC.RECORD_CHANGE_DATE,
                                    'YYYYMMDDHH24MISS'),
                            'OVERSHIPPED',
                            P_O_V_ERR_CD);

        IF ((P_O_V_ERR_CD IS NULL) OR
           (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD)) THEN
          RETURN;
        END IF;

        -- Delete the record from table.
        DELETE FROM TOS_LL_OVERSHIPPED_CONTAINER
         WHERE PK_OVERSHIPPED_CONTAINER_ID =
               L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID;

        /*
            Start added by vikas, delete error message from tos_error_log table
            for this overshipped container, k'chatgamol, 15.12.2011
        */
        DELETE FROM TOS_ERROR_LOG
         WHERE FK_OVERSHIPPED_ID =
               L_CUR_OVERSHIPPED_DATA_REC.PK_OVERSHIPPED_CONTAINER_ID;

        /*
            End added by vikas, 15.12.2011
        */

      END IF;

      /* update booking status count in tos_ll_load_list table */
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(TO_NUMBER(L_CUR_OVERSHIPPED_DATA_REC.FK_LOAD_LIST_ID),
                                                     LL_DL_FLAG,
                                                     P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD = 0) THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      ELSE
        --  p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        /* Error in Sync Booking Status count */
        P_O_V_ERR_CD := 'EDL.SE0180';
        RETURN;
      END IF;

      IF (L_CUR_OVERSHIPPED_DATA_REC.OPN_STATUS IS NULL OR
         L_CUR_OVERSHIPPED_DATA_REC.OPN_STATUS <>
         PCE_EUT_COMMON.G_V_REC_DEL) THEN
        L_V_OVERSHIPPED_ROW_NUM := L_V_OVERSHIPPED_ROW_NUM + 1;
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
  END PRE_ELL_SAVE_OVERSHIP_TAB_MAIN;

  PROCEDURE PRE_ELL_OVERSHIPPED_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                          ,P_I_ROW_NUM             VARCHAR2
                                          ,P_I_V_LOAD_LIST_ID      VARCHAR2
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
                                          ,P_I_V_LOAD_ETD          VARCHAR2
                                          ,P_I_V_HDR_ETD_TM        VARCHAR2
                                          ,P_I_V_EQUIP_TYPE        VARCHAR2
                                          ,P_I_V_POD_CODE          VARCHAR2
                                          ,P_I_V_POD_TERMINAL_CODE VARCHAR2
                                          ,P_O_V_ERR_CD            OUT VARCHAR2) AS
    L_V_RECORD_COUNT NUMBER := 0;

    L_V_SHIPMENT_TYP TOS_LL_OVERSHIPPED_CONTAINER.SHIPMENT_TYPE%TYPE; -- *2
  BEGIN
    /* Set the error code to its default value (00000) */
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_LL_OVERSHIPPED_CONT_TMP
     WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
       AND EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       AND PK_OVERSHIPPED_CONTAINER_ID != NVL(P_I_V_PK_CONT_ID, ' ')
       AND SESSION_ID = P_I_V_SESSION_ID;

    -- When count is more then zero means record is already availabe, show error
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'ELL.SE0122' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_LL_BOOKED_LOADING       BD
          ,TOS_LL_OVERSHIPPED_CONT_TMP OS
     WHERE OS.FK_LOAD_LIST_ID = BD.FK_LOAD_LIST_ID
       AND OS.FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
       AND OS.EQUIPMENT_NO = BD.DN_EQUIPMENT_NO
       AND OS.EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       AND OS.LOADING_STATUS NOT IN ('OS')
       AND BD.LOADING_STATUS != 'RB';

    -- Equipment# present in Booked tab with status other than 'ROB'
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'ELL.SE0123' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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

      SELECT SHIPMENT_TYPE
        INTO L_V_SHIPMENT_TYP
        FROM TOS_LL_OVERSHIPPED_CONT_TMP -- In overshipped tab, shipment type is editable so need to get from temp table
       WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
         AND EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
         AND PK_OVERSHIPPED_CONTAINER_ID = P_I_V_PK_CONT_ID
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
                                             P_I_V_LOAD_ETD,
                                             P_I_V_HDR_ETD_TM,
                                             P_O_V_ERR_CD) = FALSE) THEN
          P_O_V_ERR_CD := 'EDL.SE0132' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                          P_I_V_EQUIPMENT_NO ||
                          PCE_EUT_COMMON.G_V_ERR_CD_SEP;
          RETURN;
        END IF;
      END IF;
    END IF;

    /* Check for the Equipment Type in dolphin master table. */
    PRE_ELL_VAL_EQUIPMENT_TYPE(P_I_V_EQUIP_TYPE,
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

    IF P_I_V_SOC_COC = 'C' THEN
      /* Check for the Sloat Operator in OPERATOR_CODE Master Table. */
      PRE_ELL_OL_VAL_OPERATOR_CODE(P_I_V_SLOT_OPERATOR,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* Check for the Container Operator in OPERATOR_CODE Master Table */
      PRE_ELL_OL_VAL_OPERATOR_CODE(P_I_V_OPER_CD,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* Check for the Out Slot Operator in OPERATOR_CODE Master Table.
          PRE_ELL_OL_VAL_OPERATOR_CODE( p_i_v_out_slot_operator, p_i_v_equipment_no, p_o_v_err_cd);
          IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
              RETURN;
          END IF ;
      */
    END IF;

    /* Check for the POL Code in  Master Table. */
    PRE_ELL_VAL_PORT_CODE(P_I_V_POD_CODE, P_I_V_EQUIPMENT_NO, P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the POL Terminal Code in  Master Table. */
    PRE_ELL_VAL_PORT_TERMINAL_CODE(P_I_V_POD_TERMINAL_CODE,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code1 validation */
    PRE_ELL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE1,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code2 validation */
    PRE_ELL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE2,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /*    Handling Instruction Code3 validation */
    PRE_ELL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE3,
                             P_I_V_EQUIPMENT_NO,
                             P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the Container Loading Remark Code1 in dolphin master table. */
    PRE_ELL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE1,
                            P_I_V_EQUIPMENT_NO,
                            P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the Container Loading Remark Code2 in dolphin master table. */
    PRE_ELL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE2,
                            P_I_V_EQUIPMENT_NO,
                            P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Validate UN Number and UN Number Variant */
    PRE_ELL_OL_VAL_UNNO(P_I_V_UNNO,
                        P_I_V_VARIANT,
                        P_I_V_EQUIPMENT_NO,
                        P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Check for the IMDG Code in IMDG Master Table. */
    PRE_ELL_OL_VAL_IMDG(P_I_V_UNNO,
                        P_I_V_VARIANT,
                        P_I_V_IMDG,
                        P_I_V_EQUIPMENT_NO,
                        P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;

    /* Validate Port Class Type if no data found then show error message: Invalid Port Class. */
    -- *24 start
    /*
          PRE_ELL_OL_VAL_PORT_CLASS( p_i_v_port_code
              , p_i_v_unno, p_i_v_variant
              , p_i_v_imdg, p_i_v_port_class
              , p_i_v_port_class_type, p_i_v_equipment_no, p_o_v_err_cd);

          IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
              RETURN;
          END IF ;
    */

    PRE_ELL_OL_VAL_PORT_CLASS_TYPE(P_I_V_PORT_CODE,
                                   P_I_V_PORT_CLASS_TYPE,
                                   P_I_V_EQUIPMENT_NO,
                                   P_O_V_ERR_CD);
    IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;
    -- *24 end
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);

      RETURN;
  END PRE_ELL_OVERSHIPPED_VALIDATION;

  PROCEDURE PRE_ELL_SAVE_RESTOW_TAB_MAIN(P_I_V_SESSION_ID VARCHAR2
                                        ,P_I_V_USER_ID    VARCHAR2
                                        ,P_I_V_VESSEL     VARCHAR2
                                        ,P_I_V_ETA        VARCHAR2
                                        ,P_I_V_HDR_ETA_TM VARCHAR2
                                        ,P_I_V_LOAD_ETD   VARCHAR2
                                        ,P_I_V_HDR_ETD_TM VARCHAR2
                                        ,P_I_V_HDR_PORT   VARCHAR2
                                        ,P_I_V_DATE       VARCHAR2
                                        ,P_O_V_ERR_CD     OUT VARCHAR2) AS
    L_V_LOCK_DATA      VARCHAR2(14);
    L_V_ERRORS         VARCHAR2(2000);
    L_V_FK_BOOKING_NO  VARCHAR2(17);
    L_V_RESTOW_ROW_NUM NUMBER := 1;
    L_N_RESTOW_ID      NUMBER := 0;

    EXP_ERROR_ON_SAVE EXCEPTION;

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

        PRE_ELL_RESTOW_VALIDATION(P_I_V_SESSION_ID,
                                  L_V_RESTOW_ROW_NUM,
                                  L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID,
                                  L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                  L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID,
                                  L_CUR_RESTOWED_DATA_REC.DN_SOC_COC,
                                  P_I_V_HDR_PORT,
                                  P_I_V_LOAD_ETD,
                                  P_I_V_HDR_ETD_TM,
                                  P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        /* get port sequence # for the current discharge list */
        SELECT FK_PORT_SEQUENCE_NO
          INTO L_V_FK_PORT_SEQUENCE_NO
          FROM TOS_LL_LOAD_LIST
         WHERE PK_LOAD_LIST_ID = L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID
           AND ROWNUM = 1;

        /* Get the load list id */

        -- PRE_ELL_PREV_LOAD_LIST_ID (
        PCE_EDL_DLMAINTENANCE.PRE_EDL_PREV_LOAD_LIST_ID(P_I_V_VESSEL,
                                                        L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                                        L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                                        P_I_V_ETA,
                                                        P_I_V_HDR_ETA_TM,
                                                        P_I_V_HDR_PORT,
                                                        L_V_FK_PORT_SEQUENCE_NO,
                                                        L_V_LOAD_LIST_ID,
                                                        L_V_FLAG,
                                                        P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
           P_O_V_ERR_CD <> 'ELL.SE0121') THEN
          RETURN;
        END IF;
        IF (P_O_V_ERR_CD = 'ELL.SE0121') THEN
          G_V_WARNING := 'ELL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                         L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO ||
                         PCE_EUT_COMMON.G_V_ERR_CD_SEP;
          RETURN;
        END IF;

        IF (P_O_V_ERR_CD = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          BEGIN
            -- * 16
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

            /* *16 start * */
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              /* * Service, Vessel and Voyage information not match with
              present load list for equipment# * */
              G_V_WARNING := 'ELL.SE0112' ||
                             PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                             L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO ||
                             PCE_EUT_COMMON.G_V_ERR_CD_SEP;
              RETURN;
          END;
          /* *16 end * */

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
             WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;
          END IF;

          IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS IN
             ('LR', 'RA', 'LC', 'RP', 'XX')) THEN

            /* Start edited by vikas calling pre build sp
            of dl_maintenance , 22.11.2011*/
            /* get port sequence # for the current discharge list */
            SELECT FK_PORT_SEQUENCE_NO
              INTO L_V_FK_PORT_SEQUENCE_NO
              FROM TOS_LL_LOAD_LIST
             WHERE PK_LOAD_LIST_ID =
                   L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID
               AND ROWNUM = 1;

            /* *23 start * */

            -- PCE_EDL_DLMAINTENANCE.PRE_EDL_NEXT_DISCHARGE_LIST_ID  (
            -- p_i_v_vessel
            -- , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
            -- , l_cur_restowed_data_rec.FK_BOOKING_NO
            -- , p_i_v_load_etd
            -- , p_i_v_hdr_etd_tm
            -- , p_i_v_hdr_port
            -- , l_v_fk_port_sequence_no
            -- , l_v_discharge_id
            -- , l_v_flag
            -- , p_o_v_err_cd
            -- );
            /* End edited by vikas, 22.11.2011*/

            PRE_FIND_DISCHARGE_LIST(L_V_FK_BOOKING_NO,
                                    P_I_V_VESSEL,
                                    L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                    L_V_FLAG,
                                    L_V_DISCHARGE_ID,
                                    P_O_V_ERR_CD);

            /* *23 end * */
            IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
              RETURN;
            END IF;

            IF (L_V_FLAG = 'D') THEN

              BEGIN

                SELECT STOWAGE_POSITION
                  INTO L_V_STOWAGE_POSITION
                  FROM TOS_DL_BOOKED_DISCHARGE
                 WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                --AND    DISCHARGE_STATUS <> 'DI' -- Added by vikas, 17.02.2012 -- *1
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

              -- IF(l_v_stowage_position != l_cur_restowed_data_rec.STOWAGE_POSITION) THEN -- *23
              IF (NVL(L_V_STOWAGE_POSITION, '~') !=
                 NVL(L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION, '~')) THEN
                -- *23
                /* update record in booked load list table */
                UPDATE TOS_DL_BOOKED_DISCHARGE
                   SET STOWAGE_POSITION       = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                      ,CONTAINER_GROSS_WEIGHT = L_CUR_RESTOWED_DATA_REC.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                      ,RECORD_CHANGE_USER     = P_I_V_USER_ID
                      ,RECORD_CHANGE_DATE     = TO_DATE(P_I_V_DATE,
                                                        'YYYYMMDDHH24MISS')
                 WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                      -- AND DISCHARGE_STATUS <> 'DI';  -- *1
                   AND (STOWAGE_POSITION IS NULL OR
                       DISCHARGE_STATUS <> 'DI'); -- *1

              END IF;
            END IF;

          END IF;

        END IF;

        -- Move data from temp table to main table.
        INSERT INTO TOS_RESTOW
          (PK_RESTOW_ID
          ,FK_LOAD_LIST_ID
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
          ,L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID
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
        PRE_ELL_RESTOW_VALIDATION(P_I_V_SESSION_ID,
                                  L_V_RESTOW_ROW_NUM,
                                  L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID,
                                  L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                  L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID,
                                  L_CUR_RESTOWED_DATA_REC.DN_SOC_COC,
                                  P_I_V_HDR_PORT,
                                  P_I_V_LOAD_ETD,
                                  P_I_V_HDR_ETD_TM,
                                  P_O_V_ERR_CD);

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RETURN;
        END IF;

        /*
            check if equipment number is changed or not
            if equipment number is changed then get data
            from master table.
        */

        SELECT COUNT(1)
          INTO L_V_REC_COUNT
          FROM TOS_RESTOW
         WHERE PK_RESTOW_ID = L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID
           AND DN_EQUIPMENT_NO = L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO;

        /* No data found equipment no is changed */
        IF (L_V_REC_COUNT < 1) THEN

          /* get port sequence # for the current discharge list */
          SELECT FK_PORT_SEQUENCE_NO
            INTO L_V_FK_PORT_SEQUENCE_NO
            FROM TOS_LL_LOAD_LIST
           WHERE PK_LOAD_LIST_ID = L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID
             AND ROWNUM = 1;

          /* Get the load list id */
          -- PRE_ELL_PREV_LOAD_LIST_ID (
          PCE_EDL_DLMAINTENANCE.PRE_EDL_PREV_LOAD_LIST_ID(P_I_V_VESSEL,
                                                          L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                                          L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                                          P_I_V_ETA,
                                                          P_I_V_HDR_ETA_TM,
                                                          P_I_V_HDR_PORT,
                                                          L_V_FK_PORT_SEQUENCE_NO,
                                                          L_V_LOAD_LIST_ID,
                                                          L_V_FLAG,
                                                          P_O_V_ERR_CD);

          IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
             P_O_V_ERR_CD <> 'ELL.SE0121') THEN
            RETURN;
          END IF;
          IF (P_O_V_ERR_CD = 'ELL.SE0121') THEN
            G_V_WARNING := 'ELL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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
               WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;
            END IF;

            IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS IN
               ('LR', 'RA', 'LC', 'RP', 'XX')) THEN
              /* Start edited by vikas calling pre build sp
              of dl_maintenance , 22.11.2011*/
              /* get port sequence # for the current discharge list */
              SELECT FK_PORT_SEQUENCE_NO
                INTO L_V_FK_PORT_SEQUENCE_NO
                FROM TOS_LL_LOAD_LIST
               WHERE PK_LOAD_LIST_ID =
                     L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID
                 AND ROWNUM = 1;

              /* *23 start * */
              -- PCE_EDL_DLMAINTENANCE.PRE_EDL_NEXT_DISCHARGE_LIST_ID (
              -- p_i_v_vessel
              -- , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
              -- , l_cur_restowed_data_rec.FK_BOOKING_NO
              -- , p_i_v_load_etd
              -- , p_i_v_hdr_etd_tm
              -- , p_i_v_hdr_port
              -- , l_v_fk_port_sequence_no
              -- , l_v_discharge_id
              -- , l_v_flag
              -- , p_o_v_err_cd
              -- );

              PRE_FIND_DISCHARGE_LIST(L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                      P_I_V_VESSEL,
                                      L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                      L_V_FLAG,
                                      L_V_DISCHARGE_ID,
                                      P_O_V_ERR_CD);
              /* *23 end * */

              /* End edited by vikas, 22.11.2011*/

              IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
              END IF;

              IF (L_V_FLAG = 'D') THEN

                BEGIN

                  SELECT STOWAGE_POSITION
                    INTO L_V_STOWAGE_POSITION
                    FROM TOS_DL_BOOKED_DISCHARGE
                   WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                  --AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012 -- *1
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

                -- IF(l_v_stowage_position != l_cur_restowed_data_rec.STOWAGE_POSITION) THEN -- *23
                IF (NVL(L_V_STOWAGE_POSITION, '~') !=
                   NVL(L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION, '~')) THEN
                  -- *23

                  /* update record in booked load list table */
                  UPDATE TOS_DL_BOOKED_DISCHARGE
                     SET STOWAGE_POSITION       = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                        ,CONTAINER_GROSS_WEIGHT = L_CUR_RESTOWED_DATA_REC.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                        ,RECORD_CHANGE_USER     = P_I_V_USER_ID
                        ,RECORD_CHANGE_DATE     = TO_DATE(P_I_V_DATE,
                                                          'YYYYMMDDHH24MISS')
                   WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                        -- AND DISCHARGE_STATUS <> 'DI'; -- *1
                     AND (STOWAGE_POSITION IS NULL OR
                         DISCHARGE_STATUS <> 'DI'); -- *1
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

        ELSE
          /* Check if stowage position is changed */
          SELECT STOWAGE_POSITION
            INTO L_V_STOWAGE_POSITION
            FROM TOS_RESTOW
           WHERE PK_RESTOW_ID = L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID;

          IF NVL(L_V_STOWAGE_POSITION, '~') !=
             NVL(L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION, '~') THEN

            /* get port sequence # for the current discharge list */
            SELECT FK_PORT_SEQUENCE_NO
              INTO L_V_FK_PORT_SEQUENCE_NO
              FROM TOS_LL_LOAD_LIST
             WHERE PK_LOAD_LIST_ID =
                   L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID
               AND ROWNUM = 1;

            /* Get the load list id */
            -- PRE_ELL_PREV_LOAD_LIST_ID (
            PCE_EDL_DLMAINTENANCE.PRE_EDL_PREV_LOAD_LIST_ID(P_I_V_VESSEL,
                                                            L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                                            L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                                            P_I_V_ETA,
                                                            P_I_V_HDR_ETA_TM,
                                                            P_I_V_HDR_PORT,
                                                            L_V_FK_PORT_SEQUENCE_NO,
                                                            L_V_LOAD_LIST_ID,
                                                            L_V_FLAG,
                                                            P_O_V_ERR_CD);

            IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND
               P_O_V_ERR_CD <> 'ELL.SE0121') THEN
              RETURN;
            END IF;
            IF (P_O_V_ERR_CD = 'ELL.SE0121') THEN
              G_V_WARNING := 'ELL.SE0112' ||
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
                 WHERE PK_BOOKED_LOADING_ID = L_V_LOAD_LIST_ID;
              END IF;

              IF (L_CUR_RESTOWED_DATA_REC.RESTOW_STATUS IN
                 ('LR', 'RA', 'LC', 'RP', 'XX')) THEN
                /* Start edited by vikas calling pre build sp
                of dl_maintenance , 22.11.2011*/
                /* get port sequence # for the current discharge list */
                SELECT FK_PORT_SEQUENCE_NO
                  INTO L_V_FK_PORT_SEQUENCE_NO
                  FROM TOS_LL_LOAD_LIST
                 WHERE PK_LOAD_LIST_ID =
                       L_CUR_RESTOWED_DATA_REC.FK_LOAD_LIST_ID
                   AND ROWNUM = 1;

                /* *23 start * */
                -- PCE_EDL_DLMAINTENANCE.PRE_EDL_NEXT_DISCHARGE_LIST_ID (
                --       p_i_v_vessel
                --     , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                --     , l_cur_restowed_data_rec.FK_BOOKING_NO
                --     , p_i_v_load_etd
                --     , p_i_v_hdr_etd_tm
                --     , p_i_v_hdr_port
                --     , l_v_fk_port_sequence_no
                --     , l_v_discharge_id
                --     , l_v_flag
                --     , p_o_v_err_cd
                -- );
                /* End edited by vikas, 22.11.2011*/

                PRE_FIND_DISCHARGE_LIST(L_CUR_RESTOWED_DATA_REC.FK_BOOKING_NO,
                                        P_I_V_VESSEL,
                                        L_CUR_RESTOWED_DATA_REC.DN_EQUIPMENT_NO,
                                        L_V_FLAG,
                                        L_V_DISCHARGE_ID,
                                        P_O_V_ERR_CD);
                /* *23 end * */

                IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                  RETURN;
                END IF;

                IF (L_V_FLAG = 'D') THEN

                  BEGIN

                    SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                      INTO L_V_LOCK_DATA
                      FROM TOS_DL_BOOKED_DISCHARGE
                     WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                    --AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012 -- *1
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
                     SET STOWAGE_POSITION       = L_CUR_RESTOWED_DATA_REC.STOWAGE_POSITION
                        ,CONTAINER_GROSS_WEIGHT = L_CUR_RESTOWED_DATA_REC.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                        ,RECORD_CHANGE_USER     = P_I_V_USER_ID
                        ,RECORD_CHANGE_DATE     = TO_DATE(P_I_V_DATE,
                                                          'YYYYMMDDHH24MISS')
                   WHERE PK_BOOKED_DISCHARGE_ID = L_V_DISCHARGE_ID
                        -- AND DISCHARGE_STATUS <> 'DI'; -- *1
                     AND (STOWAGE_POSITION IS NULL OR
                         DISCHARGE_STATUS <> 'DI'); -- *1

                END IF;

              END IF;
            END IF;
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

        IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
          RAISE EXP_ERROR_ON_SAVE;
        END IF;

        /* get lock on restow table */
        PCV_ELL_RECORD_LOCK(L_CUR_RESTOWED_DATA_REC.PK_RESTOW_ID,
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
    END IF;

  EXCEPTION
    WHEN EXP_ERROR_ON_SAVE THEN
      RETURN;

    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;

  END PRE_ELL_SAVE_RESTOW_TAB_MAIN;

  PROCEDURE PRE_ELL_RESTOW_VALIDATION(P_I_V_SESSION_ID    VARCHAR2
                                     ,P_I_ROW_NUM         NUMBER
                                     ,P_I_V_LOAD_LIST_ID  VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO  VARCHAR2
                                     ,P_I_V_RESTOW_ID     VARCHAR2
                                     ,P_I_V_SOC_COC       VARCHAR2
                                     ,P_I_V_HDR_PORT      VARCHAR2
                                     ,P_I_V_DISCHARGE_ETD VARCHAR2
                                     ,P_I_V_HDR_ETD_TM    VARCHAR2
                                     ,P_O_V_ERR_CD        OUT VARCHAR2) AS

    L_V_ERRORS       VARCHAR2(2000);
    L_V_RECORD_COUNT NUMBER := 0;
    L_V_SHIPMENT_TYP TOS_RESTOW.DN_SHIPMENT_TYP%TYPE; -- *2

  BEGIN
    -- Set the error code to its default value (0000);
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    L_V_ERRORS   := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_RESTOW_TMP
     WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
       AND DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
       AND PK_RESTOW_ID != NVL(P_I_V_RESTOW_ID, ' ')
       AND SESSION_ID = P_I_V_SESSION_ID;

    -- When count is more then zero means record is already availabe, show error
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'ELL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_LL_BOOKED_LOADING BD
          ,TOS_RESTOW_TMP        RS
     WHERE RS.FK_LOAD_LIST_ID = BD.FK_LOAD_LIST_ID
       AND RS.FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
       AND RS.DN_EQUIPMENT_NO = BD.DN_EQUIPMENT_NO
       AND RS.DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO
          --AND    RS.RESTOW_STATUS    IN ('LR','RA','RP')
       AND BD.LOADING_STATUS != 'RB';

    -- Equipment# present in Booked tab with status other than 'ROB'
    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'ELL.SE0123' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
      RETURN;
    END IF;

    -- Equipment# present in overlanded tab
    SELECT COUNT(1)
      INTO L_V_RECORD_COUNT
      FROM TOS_LL_OVERSHIPPED_CONTAINER OL
          ,TOS_RESTOW_TMP               RS
     WHERE OL.FK_LOAD_LIST_ID = RS.FK_LOAD_LIST_ID
       AND RS.FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
       AND OL.EQUIPMENT_NO = RS.DN_EQUIPMENT_NO
       AND RS.DN_EQUIPMENT_NO = P_I_V_EQUIPMENT_NO;

    IF (L_V_RECORD_COUNT > 0) THEN
      P_O_V_ERR_CD := 'ELL.SE0125' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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
  END PRE_ELL_RESTOW_VALIDATION;

  PROCEDURE PRE_ELL_OL_VAL_PORT_CLASS(P_I_V_PORT_CODE       VARCHAR2
                                     ,P_I_V_UNNO            VARCHAR2
                                     ,P_I_V_VARIANT         VARCHAR2
                                     ,P_I_V_IMDG_CLASS      VARCHAR2
                                     ,P_I_V_PORT_CLASS      VARCHAR2
                                     ,P_I_V_PORT_CLASS_TYPE VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO    VARCHAR2
                                     ,P_O_V_ERR_CD          OUT VARCHAR2) AS

    /*
        Start Added by Vikas, 16.12.2011
    */
    L_REC_COUNT         NUMBER := 0;
    L_V_PORT_CODE       PORT_CLASS_TYPE.PORT_CODE%TYPE;
    L_V_UNNO            PORT_CLASS.UNNO%TYPE;
    L_V_VARIANT         PORT_CLASS.VARIANT%TYPE;
    L_V_IMDG_CLASS      PORT_CLASS.IMDG_CLASS%TYPE;
    L_V_PORT_CLASS      PORT_CLASS.PORT_CLASS_CODE%TYPE;
    L_V_PORT_CLASS_TYPE PORT_CLASS.PORT_CLASS_TYPE%TYPE;
    /*
        End added by vikas, 16.12.2011
    */
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    /*
        Start modified by vikas, because variant is not
        matching due to case, k'chatgamol,16.12.2011
    */
    L_V_PORT_CODE       := LOWER(P_I_V_PORT_CODE);
    L_V_UNNO            := LOWER(P_I_V_UNNO);
    L_V_VARIANT         := LOWER(P_I_V_VARIANT);
    L_V_IMDG_CLASS      := LOWER(P_I_V_IMDG_CLASS);
    L_V_PORT_CLASS      := LOWER(P_I_V_PORT_CLASS);
    L_V_PORT_CLASS_TYPE := LOWER(P_I_V_PORT_CLASS_TYPE);

    IF P_I_V_UNNO IS NOT NULL
       AND
      -- p_i_v_variant IS NOT NULL AND
       P_I_V_IMDG_CLASS IS NOT NULL
       AND L_V_PORT_CLASS IS NOT NULL THEN

      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM PORT_CLASS_TYPE PCT
            ,PORT_CLASS      PC
       WHERE LOWER(PCT.PORT_CODE) = L_V_PORT_CODE
         AND LOWER(PC.PORT_CLASS_TYPE) = LOWER(PCT.PORT_CLASS_TYPE)
         AND LOWER(PC.UNNO) = L_V_UNNO
         AND LOWER(PC.VARIANT) = L_V_VARIANT
         AND LOWER(PC.IMDG_CLASS) = L_V_IMDG_CLASS
         AND LOWER(PC.PORT_CLASS_CODE) = L_V_PORT_CLASS
         AND LOWER(PC.PORT_CLASS_TYPE) = L_V_PORT_CLASS_TYPE;

      /*
          validataion fails then validate port class without variant, k'chatgamol,16.12.2011
      */
      IF ((L_REC_COUNT < 1) AND (NVL(L_V_VARIANT, '-') = '-')) THEN
        SELECT COUNT(1)
          INTO L_REC_COUNT
          FROM PORT_CLASS_TYPE PCT
              ,PORT_CLASS      PC
         WHERE LOWER(PCT.PORT_CODE) = L_V_PORT_CODE
           AND LOWER(PC.PORT_CLASS_TYPE) = LOWER(PCT.PORT_CLASS_TYPE)
           AND LOWER(PC.UNNO) = L_V_UNNO
           AND LOWER(PC.IMDG_CLASS) = L_V_IMDG_CLASS
           AND LOWER(PC.PORT_CLASS_CODE) = L_V_PORT_CLASS
           AND LOWER(PC.PORT_CLASS_TYPE) = L_V_PORT_CLASS_TYPE;
      END IF;

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'ELL.SE0113' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;
    /*
        End modified by vikas, 16.12.2011
    */

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_ELL_OL_VAL_PORT_CLASS;

  /*    Check for the shipment term */
  PROCEDURE PRE_SHIPMENT_TERM_OL_CODE(P_I_V_SHIPMNT_CD   VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO VARCHAR2
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
        P_O_V_ERR_CD := 'ELL.SE0128' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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

  PROCEDURE PRE_ELL_OL_VAL_IMDG(P_I_V_UNNO         IN VARCHAR2
                               ,P_I_V_VARIANT      IN VARCHAR2
                               ,P_I_V_IMDG         IN VARCHAR2
                               ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                               ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;

    /*
        Start Added by Vikas, 16.12.2011
    */
    L_V_UNNO         PORT_CLASS.UNNO%TYPE;
    L_V_VARIANT      PORT_CLASS.VARIANT%TYPE;
    L_V_IMDG         PORT_CLASS.IMDG_CLASS%TYPE;
    L_V_EQUIPMENT_NO TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE;
    /*
        End added by vikas, 16.12.2011
    */

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    /*
        Start modified by vikas, because variant is not
        matching due to case, k'chatgamol,16.12.2011
    */
    L_V_UNNO         := LOWER(P_I_V_UNNO);
    L_V_VARIANT      := LOWER(P_I_V_VARIANT);
    L_V_IMDG         := LOWER(P_I_V_IMDG);
    L_V_EQUIPMENT_NO := LOWER(P_I_V_EQUIPMENT_NO);

    --IF l_v_unno IS NOT NULL AND l_v_variant IS NOT NULL AND l_v_imdg IS NOT NULL THEN --*24
    IF L_V_UNNO IS NOT NULL
       AND L_V_IMDG IS NOT NULL THEN
      --*24 start
      /*SELECT
          COUNT(1)
      INTO
          l_rec_count
      FROM
          DG_UNNO_CLASS_RESTRICTIONS
      WHERE
          LOWER(UNNO)           = l_v_unno
          AND LOWER(VARIANT)    = l_v_variant
          AND LOWER(IMDG_CLASS) = l_v_imdg;*/

      /*
          validate without variant, 16.12.2011
      */
      --IF ( (l_rec_count < 1) AND(NVL(l_v_variant, '-')  = '-') )THEN
      --*24 end
      L_REC_COUNT := 0;
      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM DG_UNNO_CLASS_RESTRICTIONS
       WHERE LOWER(UNNO) = L_V_UNNO
         AND LOWER(IMDG_CLASS) = L_V_IMDG;
      -- END IF;

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'ELL.SE0114' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;
    /*
        End modified by vikas, 16.12.2011
    */

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_ELL_OL_VAL_IMDG;

  PROCEDURE PRE_ELL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE     IN VARCHAR2
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
        P_O_V_ERR_CD := 'ELL.SE0115' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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
  END PRE_ELL_OL_VAL_HAND_CODE;

  PROCEDURE PRE_ELL_OL_VAL_OPERATOR_CODE(P_I_V_OPER_CD      IN VARCHAR2
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
        P_O_V_ERR_CD := 'ELL.SE0117' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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
  END PRE_ELL_OL_VAL_OPERATOR_CODE;

  PROCEDURE PRE_ELL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE     IN VARCHAR2
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
        P_O_V_ERR_CD := 'ELL.SE0116' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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
  END PRE_ELL_OL_VAL_CLR_CODE;

  PROCEDURE PRE_ELL_OL_VAL_UNNO(P_I_V_UNNO         IN VARCHAR2
                               ,P_I_V_VARIANT      IN VARCHAR2
                               ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                               ,P_O_V_ERR_CD       OUT VARCHAR2) AS
    L_REC_COUNT NUMBER := 0;

    /*
        Start Added by Vikas, 16.12.2011
    */
    L_V_UNNO    PORT_CLASS.UNNO%TYPE;
    L_V_VARIANT PORT_CLASS.VARIANT%TYPE;
    /*
        End added by vikas, 16.12.2011
    */
  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    /*
        Start modified by vikas, because variant is not
        matching due to case, k'chatgamol,16.12.2011
    */
    L_V_UNNO    := LOWER(P_I_V_UNNO);
    L_V_VARIANT := LOWER(P_I_V_VARIANT);

    --*24 start
    /* IF p_i_v_unno IS NOT NULL AND p_i_v_variant IS NOT NULL THEN

    SELECT COUNT(1)
    INTO
    l_rec_count
    FROM DG_UNNO_CLASS_RESTRICTIONS
    WHERE LOWER(UNNO) = l_v_unno
    AND LOWER(VARIANT) = l_v_variant;

    IF ( (l_rec_count < 1) AND(NVL(l_v_variant, '-')  = '-') )THEN
    */
    --*24 end
    IF P_I_V_UNNO IS NOT NULL THEN
      -- *24
      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM DG_UNNO_CLASS_RESTRICTIONS
       WHERE LOWER(UNNO) = L_V_UNNO;

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'ELL.SE0118' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_EQUIPMENT_NO || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF; -- *24
    /*
        End modified by vikas, 16.12.2011
    */
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_ELL_OL_VAL_UNNO;

  /*    Check for the Equipment Type in Master Table. */
  PROCEDURE PRE_ELL_VAL_EQUIPMENT_TYPE(P_I_V_OPER_CD      IN VARCHAR2
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
  END PRE_ELL_VAL_EQUIPMENT_TYPE;

  /*    Check for the Port Code Master Table. */
  PROCEDURE PRE_ELL_VAL_PORT_CODE(P_I_V_OPER_CD      IN VARCHAR2
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
  END PRE_ELL_VAL_PORT_CODE;

  /*    Check for the Port Code Master Table. */
  PROCEDURE PRE_ELL_VAL_PORT_TERMINAL_CODE(P_I_V_OPER_CD      IN VARCHAR2
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
  END PRE_ELL_VAL_PORT_TERMINAL_CODE;

  PROCEDURE PRE_LL_SPLIT(P_I_V_BOOKED_LOADING_ID NUMBER
                        ,P_O_V_ERR_CD            OUT NOCOPY VARCHAR2) AS
    P_O_V_RETURN_STATUS NUMBER;
  BEGIN
    P_O_V_ERR_CD        := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_RETURN_STATUS := '';

    PRE_TOS_MOVE_TO_OVERSHIPPED(P_I_V_BOOKED_LOADING_ID,
                                P_O_V_RETURN_STATUS);

    IF (P_O_V_RETURN_STATUS = 1) THEN
      P_O_V_ERR_CD := 'ELL.SE0130';
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,
                              PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(P_O_V_ERR_CD));

  END PRE_LL_SPLIT;

  PROCEDURE PRE_LL_COMMON_MATCHING(P_I_V_MATCH_TYPE               VARCHAR2
                                  ,P_I_V_LOAD_LIST_ID             NUMBER
                                  ,P_I_V_DL_CONTAINER_SEQ         NUMBER
                                  ,P_I_V_OVERSHIPPED_CONTAINER_ID NUMBER
                                  ,P_I_V_EQUIPMENT_NO             VARCHAR2
                                  ,P_O_V_ERR_CD                   OUT NOCOPY VARCHAR2) AS
    P_O_V_RETURN_STATUS NUMBER;
    L_V_REC_COUNT       NUMBER := 0;
    L_EXP_FINISH EXCEPTION;
    L_V_EQUIPMENT_NO TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE;
  BEGIN
    P_O_V_ERR_CD        := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_RETURN_STATUS := '';

    /* Check if the containter equipment no# is alredy available in
    booked tab or not. */

    /*
    SELECT COUNT(1), dn_equipment_no
    INTO l_v_rec_count, l_v_equipment_no
    FROM TOS_DL_BOOKED_DISCHARGE
    WHERE FK_DISCHARGE_LIST_ID = p_i_v_discharge_list_id
    AND  RECORD_STATUS = 'A'
    AND DN_EQUIPMENT_NO = p_i_v_equipment_no
    GROUP BY dn_equipment_no;
    */

    BEGIN
      SELECT COUNT(1)
            ,DN_EQUIPMENT_NO
        INTO L_V_REC_COUNT
            ,L_V_EQUIPMENT_NO
        FROM TOS_LL_BOOKED_LOADING
       WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
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
      /* Overshipped Equipment no# is already available in booked tab,
      show error message. "Equipment alredy exists in booked tab.." */
      P_O_V_ERR_CD := 'EDL.SE0182';
      RAISE L_EXP_FINISH;
    END IF;

    /* Call PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING for Automatch */
    IF (P_I_V_MATCH_TYPE = 'A') THEN
      PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING(P_I_V_MATCH_TYPE,
                                               'LL',
                                               '',
                                               '',
                                               '',
                                               P_I_V_LOAD_LIST_ID,
                                               P_I_V_DL_CONTAINER_SEQ,
                                               P_I_V_OVERSHIPPED_CONTAINER_ID,
                                               P_O_V_RETURN_STATUS);
    ELSE
      /* Call PCE_ECM_EDI.PRE_TOS_LLDL_MANUAL_MATCHING for Manual Match */
      PCE_ECM_EDI.PRE_TOS_LLDL_MANUAL_MATCHING(P_I_V_MATCH_TYPE,
                                               'LL',
                                               '',
                                               '',
                                               '',
                                               P_I_V_LOAD_LIST_ID,
                                               P_I_V_DL_CONTAINER_SEQ,
                                               P_I_V_OVERSHIPPED_CONTAINER_ID

                                              ,
                                               P_O_V_RETURN_STATUS);

    END IF;

    IF (P_O_V_RETURN_STATUS = '1') THEN
      P_O_V_ERR_CD := 'ELL.SE0129';
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

  END PRE_LL_COMMON_MATCHING;

  PROCEDURE PRE_TOS_MOVE_TO_OVERSHIPPED(P_I_N_BOOKED_LOADING_ID IN NUMBER
                                       ,P_O_V_RETURN_STATUS     OUT NOCOPY VARCHAR2) AS

    L_V_SQL_ID VARCHAR2(10);
    L_EXCE_MAIN EXCEPTION;
    L_D_TIME     TIMESTAMP;
    L_V_USER     VARCHAR2(10) := 'EZLL';
    L_V_ERR_CODE VARCHAR2(10);
    L_V_ERR_DESC VARCHAR2(100);
    CURSOR L_CUR_BOOKED_LOADING IS
      SELECT LOADING_STATUS
            ,NVL(PREADVICE_FLAG, 'N') PREADVICE_FLAG
            ,FK_BOOKING_NO
            ,EQUPMENT_NO_SOURCE
            ,FK_BKG_EQUIPM_DTL
        FROM TOS_LL_BOOKED_LOADING
       WHERE PK_BOOKED_LOADING_ID = P_I_N_BOOKED_LOADING_ID;
  BEGIN
    -- Insert data into overshipped container from booked loading based on passed parameters
    L_V_SQL_ID := 'SQL-00001';
    FOR L_CUR_BOOKED_DATA IN L_CUR_BOOKED_LOADING
    LOOP
      IF ((L_CUR_BOOKED_DATA.PREADVICE_FLAG = 'Y' AND
         L_CUR_BOOKED_DATA.LOADING_STATUS = 'BK') OR
         (L_CUR_BOOKED_DATA.LOADING_STATUS = 'LO')) THEN
        L_D_TIME := CURRENT_TIMESTAMP;
        INSERT INTO TOS_LL_OVERSHIPPED_CONTAINER
          (PK_OVERSHIPPED_CONTAINER_ID
          ,FK_LOAD_LIST_ID
          ,BOOKING_NO
          ,BKG_TYP
          ,BOOKING_NO_SOURCE
          ,EQUIPMENT_NO
          ,EQUIPMENT_NO_QUESTIONABLE_FLAG
          ,EQ_SIZE
          ,EQ_TYPE
          ,LOCAL_TERMINAL_STATUS
          ,LOAD_CONDITION
          ,SPECIAL_HANDLING
          ,FLAG_SOC_COC
          ,SHIPMENT_TERM
          ,SHIPMENT_TYPE
          ,CONTAINER_GROSS_WEIGHT
          ,DISCHARGE_PORT
          ,STOWAGE_POSITION
          ,MLO_VESSEL
          ,MLO_VOYAGE
          ,MLO_VESSEL_ETA
          ,HANDLING_INSTRUCTION_1
          ,HANDLING_INSTRUCTION_2
          ,HANDLING_INSTRUCTION_3
          ,CONTAINER_LOADING_REM_1
          ,CONTAINER_LOADING_REM_2
          ,ACTIVITY_DATE_TIME
          ,SLOT_OPERATOR
          ,CONTAINER_OPERATOR
          ,MIDSTREAM_HANDLING_CODE
          ,REEFER_TEMPERATURE
          ,REEFER_TMP_UNIT
          ,IMDG_CLASS
          ,UN_NUMBER
          ,UN_NUMBER_VARIANT
          ,PORT_CLASS_TYPE
          ,PORT_CLASS
          ,FLASHPOINT
          ,FLASHPOINT_UNIT
          ,RESIDUE_ONLY_FLAG
          ,OVERHEIGHT_CM
          ,OVERWIDTH_LEFT_CM
          ,OVERWIDTH_RIGHT_CM
          ,OVERLENGTH_FRONT_CM
          ,OVERLENGTH_REAR_CM
          ,VOID_SLOT
          ,POD_TERMINAL
          ,MLO_DEL
          ,DAMAGED
          ,FINAL_DEST
          ,FULL_MT
          ,FUMIGATION_ONLY
          ,MLO_POD1
          ,MLO_POD2
          ,MLO_POD3
          ,NXT_POD1
          ,NXT_POD2
          ,NXT_POD3
          ,FINAL_POD
          ,NXT_DIR
          ,NXT_SRV
          ,NXT_VESSEL
          ,NXT_VOYAGE
          ,OUT_SLOT_OPERATOR
          ,LOCAL_STATUS
          ,SEAL_NO
          ,SPECIAL_CARGO
          ,DA_ERROR
          ,HUMIDITY
          ,VENTILATION
          ,PREADVICE_FLAG
          ,EX_MLO_VESSEL
          ,EX_MLO_VESSEL_ETA
          ,EX_MLO_VOYAGE
          ,RECORD_STATUS
          ,RECORD_ADD_USER
          ,RECORD_ADD_DATE
          ,RECORD_CHANGE_USER
          ,RECORD_CHANGE_DATE
          ,VGM --*34
          )
          SELECT SE_OCZ02.NEXTVAL
                ,FK_LOAD_LIST_ID
                ,FK_BOOKING_NO
                ,DN_BKG_TYP
                ,'S'
                ,DN_EQUIPMENT_NO
                ,'N'
                ,DN_EQ_SIZE
                ,DN_EQ_TYPE
                ,LOCAL_TERMINAL_STATUS
                ,LOAD_CONDITION
                ,DN_SPECIAL_HNDL
                ,DN_SOC_COC
                ,DN_SHIPMENT_TERM
                ,DN_SHIPMENT_TYP
                ,CONTAINER_GROSS_WEIGHT
                ,DN_DISCHARGE_PORT
                ,STOWAGE_POSITION
                ,MLO_VESSEL
                ,MLO_VOYAGE
                ,MLO_VESSEL_ETA
                ,FK_HANDLING_INSTRUCTION_1
                ,FK_HANDLING_INSTRUCTION_2
                ,FK_HANDLING_INSTRUCTION_3
                ,CONTAINER_LOADING_REM_1
                ,CONTAINER_LOADING_REM_2
                ,ACTIVITY_DATE_TIME
                ,FK_SLOT_OPERATOR
                ,FK_CONTAINER_OPERATOR
                ,MIDSTREAM_HANDLING_CODE
                ,REEFER_TMP
                ,REEFER_TMP_UNIT
                ,FK_IMDG
                ,FK_UNNO
                ,FK_UN_VAR
                ,FK_PORT_CLASS_TYP
                ,FK_PORT_CLASS
                ,FLASH_POINT
                ,FLASH_UNIT
                ,RESIDUE_ONLY_FLAG
                ,OVERHEIGHT_CM
                ,OVERWIDTH_LEFT_CM
                ,OVERWIDTH_RIGHT_CM
                ,OVERLENGTH_FRONT_CM
                ,OVERLENGTH_REAR_CM
                ,VOID_SLOT
                ,DN_DISCHARGE_TERMINAL
                ,MLO_DEL
                ,DAMAGED
                ,FINAL_DEST
                ,DN_FULL_MT
                ,FUMIGATION_ONLY
                ,MLO_POD1
                ,MLO_POD2
                ,MLO_POD3
                ,DN_NXT_POD1
                ,DN_NXT_POD2
                ,DN_NXT_POD3
                ,DN_FINAL_POD
                ,DN_NXT_DIR
                ,DN_NXT_SRV
                ,DN_NXT_VESSEL
                ,DN_NXT_VOYAGE
                ,FK_SLOT_OPERATOR
                ,LOCAL_STATUS
                ,SEAL_NO
                ,FK_SPECIAL_CARGO
                ,'N'
                ,DN_HUMIDITY
                ,DN_VENTILATION
                ,L_CUR_BOOKED_DATA.PREADVICE_FLAG
                ,EX_MLO_VESSEL
                ,EX_MLO_VESSEL_ETA
                ,EX_MLO_VOYAGE
                ,'A'
                ,L_V_USER
                ,L_D_TIME
                ,L_V_USER
                ,L_D_TIME
                ,VGM --*34
            FROM TOS_LL_BOOKED_LOADING
           WHERE PK_BOOKED_LOADING_ID = P_I_N_BOOKED_LOADING_ID;

        IF SQL%NOTFOUND THEN
          L_V_ERR_CODE := TO_CHAR(SQLCODE);
          L_V_ERR_DESC := SUBSTR(SQLERRM, 1, 100);
          RAISE L_EXCE_MAIN;
        END IF;
      END IF;
      --Updating loading status in TOS_LL_BOOKED_LOADING table when loading status is 'LO'.
      L_V_SQL_ID := 'SQL-00002';
      IF L_CUR_BOOKED_DATA.LOADING_STATUS = 'LO' THEN
        UPDATE TOS_LL_BOOKED_LOADING
           SET LOADING_STATUS = 'BK'
         WHERE PK_BOOKED_LOADING_ID = P_I_N_BOOKED_LOADING_ID;
      ELSIF L_CUR_BOOKED_DATA.LOADING_STATUS = 'BK' THEN
        UPDATE TOS_LL_BOOKED_LOADING
           SET LOADING_STATUS = 'BK'
              ,PREADVICE_FLAG = 'N'
         WHERE PK_BOOKED_LOADING_ID = P_I_N_BOOKED_LOADING_ID;
      END IF;
      IF SQL%NOTFOUND THEN
        L_V_ERR_CODE := TO_CHAR(SQLCODE);
        L_V_ERR_DESC := SUBSTR(SQLERRM, 1, 100);
        RAISE L_EXCE_MAIN;
      END IF;
      --Remove container no from BKP009 if equipment no from source is from booking.
      L_V_SQL_ID := 'SQL-00003';
      IF L_CUR_BOOKED_DATA.EQUPMENT_NO_SOURCE != 'B' THEN
        UPDATE BKP009
           SET BICTRN = ''
         WHERE BIBKNO = L_CUR_BOOKED_DATA.FK_BOOKING_NO
           AND BISEQN = L_CUR_BOOKED_DATA.FK_BKG_EQUIPM_DTL;
      END IF;
      IF SQL%NOTFOUND THEN
        RAISE L_EXCE_MAIN;
      END IF;
    END LOOP;
    P_O_V_RETURN_STATUS := '0';
  EXCEPTION
    WHEN L_EXCE_MAIN THEN
      ROLLBACK;
      P_O_V_RETURN_STATUS := '1';
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(P_I_N_BOOKED_LOADING_ID,
                                                       '--',
                                                       'I',
                                                       L_V_SQL_ID || '~' ||
                                                       L_V_ERR_CODE || '~' ||
                                                       L_V_ERR_DESC,
                                                       'A',
                                                       L_V_USER,
                                                       CURRENT_TIMESTAMP,
                                                       L_V_USER,
                                                       CURRENT_TIMESTAMP);
      COMMIT;
    WHEN OTHERS THEN
      ROLLBACK;
      P_O_V_RETURN_STATUS := '1';
      L_V_ERR_CODE        := TO_CHAR(SQLCODE);
      L_V_ERR_DESC        := SUBSTR(SQLERRM, 1, 100);
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(P_I_N_BOOKED_LOADING_ID,
                                                       '--',
                                                       'I',
                                                       L_V_SQL_ID || '~' ||
                                                       L_V_ERR_CODE || '~' ||
                                                       L_V_ERR_DESC,
                                                       'A',
                                                       L_V_USER,
                                                       CURRENT_TIMESTAMP,
                                                       L_V_USER,
                                                       CURRENT_TIMESTAMP);
      COMMIT;
  END PRE_TOS_MOVE_TO_OVERSHIPPED;

  PROCEDURE PCV_ELL_RECORD_LOCK(P_I_V_ID       VARCHAR2
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
        FROM TOS_LL_BOOKED_LOADING
       WHERE PK_BOOKED_LOADING_ID = P_I_V_ID
         FOR UPDATE NOWAIT;

    ELSIF (P_I_V_TAB_NAME = 'OVERSHIPPED') THEN

      SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
        INTO L_V_LOCK_DATA
        FROM TOS_LL_OVERSHIPPED_CONTAINER
       WHERE PK_OVERSHIPPED_CONTAINER_ID = P_I_V_ID
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
        --p_o_v_err_cd :=  PCE_EUT_COMMON.G_V_GE0006 ; --*25
        -- RETURN;--*25
        NULL; --*25
      END IF;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --PCE_EUT_COMMON.G_V_GE0005 : Record Deleted by Another User
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
      RETURN;
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;
  END PCV_ELL_RECORD_LOCK;

  /**
  * @ FN_ELL_CONVERTDATE
  * Purpose : Converts a String date and time into globle time format date.
  * @param  : Date of type String
  * @param  : Time of type String
  * @param  : Port name of type String
  * @return Returns Date
  */
  FUNCTION FN_ELL_CONVERTDATE(P_I_V_DATE VARCHAR2
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

  PROCEDURE PRE_ELL_SAVE_LL_STATUS(P_I_V_LOAD_LIST_ID     VARCHAR2
                                  ,P_I_V_LOAD_LIST_STATUS VARCHAR2
                                  ,P_I_V_USER_ID          VARCHAR2
                                  ,P_I_V_SESSION_ID       VARCHAR2 -- *19
                                  ,P_I_V_DATE             VARCHAR2
                                  ,P_O_V_ERR_CD           OUT VARCHAR2) AS
    L_V_LOCK_DATA VARCHAR2(14);
    L_V_LL_STATUS VARCHAR2(2);
    EXP_ERROR_ON_SAVE EXCEPTION;
    L_O_V_BOOKING VARCHAR2(4000) DEFAULT NULL; -- *14
    V_SERVICE     VARCHAR2(5);
    V_VESSEL      VARCHAR2(5);
    V_VOYAGE      VARCHAR2(10);
    V_PORT        VARCHAR2(5);
    V_TERMINAL    VARCHAR2(5);
    V_PCSQ        NUMBER(12);
  BEGIN

    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    
    BEGIN
      SELECT LOAD_LIST_STATUS
            ,FK_SERVICE
            ,FK_VESSEL
            ,FK_VOYAGE
            ,DN_PORT
            ,DN_TERMINAL
            ,FK_PORT_SEQUENCE_NO
        INTO L_V_LL_STATUS
            ,V_SERVICE
            ,V_VESSEL
            ,V_VOYAGE
            ,V_PORT
            ,V_TERMINAL
            ,V_PCSQ
        FROM TOS_LL_LOAD_LIST
       WHERE PK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
         FOR UPDATE NOWAIT;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        -- PCE_EUT_COMMON.G_V_GE0005 : Record Deleted by Another User
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0005;
        RETURN;
      WHEN OTHERS THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                        PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        SUBSTR(SQLCODE, 1, 10) || ':' ||
                        SUBSTR(SQLERRM, 1, 100);
        RETURN;
    END;
    --##36 BEGIN
	IF (P_I_V_LOAD_LIST_STATUS > G_V_LOAD_CMPLT_STS_CHK) THEN
 	  VASAPPS.PCR_ELL_EDL_VALIDATE.PRE_ELL_STATUS_BKG_VALIDATION(V_SERVICE,
									                             V_VESSEL,
                                                                 V_VOYAGE,
									                             V_PORT,
									                             V_TERMINAL,
                                                                 P_O_V_ERR_CD);
	  IF P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
        RETURN;
      END IF;
	END IF;
	--##36 END
     /* perform validations for load list status update */
    PRE_ELL_LL_STATUS_VALIDATION(P_I_V_LOAD_LIST_ID,
                                 P_I_V_LOAD_LIST_STATUS,
                                 P_O_V_ERR_CD);
     IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
      RETURN;
    END IF;
    
    -- Validate EZLL status cannot change from Loading Complate to other status if Arrival/Departure complete
    IF L_V_LL_STATUS = WORK_COMPLETE
       AND P_I_V_LOAD_LIST_STATUS <> WORK_COMPLETE THEN
      VASAPPS.PCR_ELL_EDL_VALIDATE.PRR_ELL_ARR_DEP_VALIDATE(P_O_V_ERR_CD,
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

    /* If Load List Status value is changed from a lower value to a higher value*/
    IF ((L_V_LL_STATUS = C_OPEN) AND
       (P_I_V_LOAD_LIST_STATUS = LOADING_COMPLETE OR
       P_I_V_LOAD_LIST_STATUS = READY_FOR_INVOICE OR
       P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE)) THEN

      /* *19 start * */
      /* * check duplicate cell location exists or not * */
      PCE_EDL_DLMAINTENANCE.PRE_CHECK_DUP_CELL_LOCATION(P_I_V_SESSION_ID,
                                                        LL_DL_FLAG,
                                                        P_I_V_LOAD_LIST_ID,
                                                        P_O_V_ERR_CD);
      /* *19 end * */

      /* General Error Checking */
      IF (P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
        RETURN;
      END IF;

      /* *19 end * */

      /* *21 start * */
      L_O_V_BOOKING := NULL;
      PCE_EDL_DLMAINTENANCE.PRE_BUNDLE_UPDATE_VALIDATION(P_I_V_LOAD_LIST_ID,
                                                         LL_DL_FLAG,
                                                         L_O_V_BOOKING);
      IF (L_O_V_BOOKING IS NOT NULL) THEN
        P_O_V_ERR_CD := 'EDL.SE0190' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        L_O_V_BOOKING || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
      L_O_V_BOOKING := NULL;
      /* *21 end * */

      /* Call procedure PRE_BKG_CONDENSE */
      PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_CONDENSE(P_I_V_LOAD_LIST_ID,
                                                 P_O_V_ERR_CD);

      IF (P_O_V_ERR_CD = '0') THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      ELSE
        /* Error in calling PRE_BKG_CONDENSE.*/
        P_O_V_ERR_CD := 'ELL.SE0133';
        RETURN;
      END IF;

      /* Start Commented by vikas, as k'chatgamol say, 11.11.2011,
      k'chatgamol will again confirm the logic after then
      call ems activity

      PCE_ECM_EMS.PRE_INSERT_EMS_LL_DL(
          LL_DL_FLAG
         , TO_NUMBER(p_i_v_load_list_id)
         , ''
         , p_o_v_err_cd
      );

      IF(p_o_v_err_cd = '0' ) THEN
          p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      ELSE
          /* Error in EMS calling *
          p_o_v_err_cd := 'EDL.SE0181';
          RETURN;
      END IF ;
      * End  Commented by vikas, as k'chatgamol say, 11.11.2011 */

    END IF;

    /*
        *13: Changes start
    */
--    BEGIN
--
--
--      IF (P_I_V_LOAD_LIST_STATUS = LOADING_COMPLETE OR
--         --P_I_V_LOAD_LIST_STATUS = READY_FOR_INVOICE OR --*31
--         P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE) THEN
--
--        UPDATE TOS_LL_LOAD_LIST
--           SET FIRST_COMPLETE_USER = P_I_V_USER_ID
--              ,FIRST_COMPLETE_DATE = TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
--         WHERE PK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
--           AND FIRST_COMPLETE_USER IS NULL
--           AND FIRST_COMPLETE_DATE IS NULL;
--        /*
--        INSERT INTO TOS_LL_LOAD_LIST_HIS (
--            PK_LOAD_LIST_ID
--            , DN_SERVICE_GROUP_CODE
--            , FK_SERVICE
--            , FK_VESSEL
--            , FK_VOYAGE
--            , FK_DIRECTION
--            , FK_PORT_SEQUENCE_NO
--            , FK_VERSION
--            , DN_PORT
--            , DN_TERMINAL
--            , LOAD_LIST_STATUS
--            , RECORD_STATUS
--            , RECORD_ADD_USER
--            , RECORD_ADD_DATE
--            , RECORD_CHANGE_USER
--            , RECORD_CHANGE_DATE
--        ) SELECT
--            PK_LOAD_LIST_ID
--            , DN_SERVICE_GROUP_CODE
--            , FK_SERVICE
--            , FK_VESSEL
--            , FK_VOYAGE
--            , FK_DIRECTION
--            , FK_PORT_SEQUENCE_NO
--            , FK_VERSION
--            , DN_PORT
--            , DN_TERMINAL
--            , LOAD_LIST_STATUS
--            , RECORD_STATUS
--            , RECORD_ADD_USER
--            , RECORD_ADD_DATE
--            , RECORD_CHANGE_USER
--            , RECORD_CHANGE_DATE
--        FROM
--            TOS_LL_LOAD_LIST
--        WHERE
--            PK_LOAD_LIST_ID  = p_i_v_load_list_id;
--        */
--      END IF;
--    EXCEPTION
--      WHEN OTHERS THEN
--        NULL;
--    END;
--    /*
--        *13: Changes end
--        *14: Start
--    */
--     IF (P_I_V_LOAD_LIST_STATUS = READY_FOR_INVOICE OR
--       P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE) THEN
--      PCE_EDL_DLMAINTENANCE.PRE_LIST_OPEN_BOOOKINGS(P_I_V_LOAD_LIST_ID,
--                                                    LL_DL_FLAG,
--                                                    L_O_V_BOOKING);
--     --#30 BEGIN
--      /*
--      IF (L_O_V_BOOKING IS NOT NULL) THEN
--        P_O_V_ERR_CD := 'EDL.SE0189' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
--                        L_O_V_BOOKING || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
--        RETURN;
--      END IF;*/
--      --#30 END
--    END IF;
    /*
        *14: end
    */

    -- *28 start
    IF P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE THEN
      -- Validate EMS Activity
      VASAPPS.PCR_ELL_EDL_VALIDATE.PRR_ELL_EMS_VALIDATE(P_O_V_ERR_CD,
                                                        P_I_V_LOAD_LIST_ID,
                                                        P_I_V_USER_ID);

      IF P_O_V_ERR_CD <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
        RETURN;
      END IF;
    END IF;
    -- *28 end

    -- Update load list status in the database table.
    UPDATE TOS_LL_LOAD_LIST
       SET LOAD_LIST_STATUS   = P_I_V_LOAD_LIST_STATUS
          ,RECORD_CHANGE_USER = P_I_V_USER_ID
          ,RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
     WHERE PK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID;


    --*31 begin
     BEGIN
    --*31 --  IF (P_I_V_LOAD_LIST_STATUS = LOADING_COMPLETE OR  P_I_V_LOAD_LIST_STATUS = READY_FOR_INVOICE OR  P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE) THEN
--      C_OPEN           = '0';
--      LOADING_COMPLETE  = '10';
--      READY_FOR_INVOICE = '20';
--      WORK_COMPLETE     = '30';
      IF (( L_V_LL_STATUS = C_OPEN AND P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE) OR
          ( L_V_LL_STATUS = LOADING_COMPLETE AND P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE))
        THEN
        UPDATE TOS_LL_LOAD_LIST
           SET FIRST_COMPLETE_USER = P_I_V_USER_ID
              ,FIRST_COMPLETE_DATE = TO_DATE(P_I_V_DATE, 'YYYYMMDDHH24MISS')
         WHERE PK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
           AND FIRST_COMPLETE_USER IS NULL
           AND FIRST_COMPLETE_DATE IS NULL;
      END IF;

   END;
    --*31 end

    /* *17 start * */
    /* If Load List Status value is changed from a lower value to a higher value*/
    IF L_V_LL_STATUS = C_OPEN
       AND (P_I_V_LOAD_LIST_STATUS = LOADING_COMPLETE OR
       P_I_V_LOAD_LIST_STATUS = READY_FOR_INVOICE OR
       P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE) THEN

      PRE_UPD_MLO_DETAIL(P_I_V_LOAD_LIST_ID,
                         P_I_V_USER_ID,
                         P_I_V_DATE --  YYYYMMDDHH24MISS
                         );

    END IF;
    /* *17 end * */

  EXCEPTION
    WHEN EXP_ERROR_ON_SAVE THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);

      RETURN;
    WHEN OTHERS THEN

      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;
  END PRE_ELL_SAVE_LL_STATUS;

  PROCEDURE PRE_ELL_LL_STATUS_VALIDATION(P_I_V_LOAD_LIST_ID     VARCHAR2
                                        ,P_I_V_LOAD_LIST_STATUS VARCHAR2
                                        ,P_O_V_ERR_CD           OUT VARCHAR2) AS
    L_V_REC_COUNT NUMBER := 0;
    L_V_ERRORS    VARCHAR2(2000);
    L_V_SERVICE   TOS_LL_LOAD_LIST.FK_SERVICE%TYPE; -- *5

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    IF ((P_I_V_LOAD_LIST_STATUS = LOADING_COMPLETE) OR
       (P_I_V_LOAD_LIST_STATUS = READY_FOR_INVOICE) OR
       (P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE)) THEN

      SELECT COUNT(1)
        INTO L_V_REC_COUNT
        FROM TOS_LL_BOOKED_LOADING
       WHERE LOADING_STATUS = 'BK'
         AND FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
         AND RECORD_STATUS = 'A'; -- added 20.12.2011
    END IF;

    IF (L_V_REC_COUNT > 0) THEN
      --Then throw error message Container with discharge status Booked exists.
      P_O_V_ERR_CD := 'ELL.SE0124';
      RETURN;
    END IF;

    IF (P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE) THEN
      SELECT COUNT(1)
        INTO L_V_REC_COUNT
        FROM TOS_LL_BOOKED_LOADING
       WHERE LOADING_STATUS IN ('SS')
       -- START *34, IF IT IS SHIPPMENT TYPE UC (SIZE = 0,TYPE=**) WILL ALLOW TO COMPLETE.
         AND DN_EQ_SIZE <> 0
         AND DN_EQ_TYPE <> '**'
      -- END *34
         AND FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
         AND RECORD_STATUS = 'A'; -- added 20.12.2011

      IF (L_V_REC_COUNT > 0) THEN
        /*Then throw error message Container with discharge status Short shipped  exists*/
        P_O_V_ERR_CD := 'ELL.SE0120';
        RETURN;
      END IF;

      SELECT COUNT(1)
        INTO L_V_REC_COUNT
        FROM TOS_LL_OVERSHIPPED_CONTAINER
       WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
         AND RECORD_STATUS = 'A'; -- added 20.12.2011

      IF (L_V_REC_COUNT > 0) THEN
        /*Then throw error message container with discharge status Overlanded exists*/
        P_O_V_ERR_CD := 'ELL.SE0119';
        RETURN;
      END IF;
    END IF;

    /*
        *5: Changes start
    */
    SELECT NVL(LOWER(FK_SERVICE), '*')
      INTO L_V_SERVICE
      FROM TOS_LL_LOAD_LIST
     WHERE PK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID;
    /*
        *5: Changes End
    */

    /*
        *3: changes start
    */
    IF L_V_SERVICE <> 'afs'
       AND L_V_SERVICE <> 'dfs' THEN
      -- *5
      IF ((P_I_V_LOAD_LIST_STATUS = LOADING_COMPLETE) OR
         (P_I_V_LOAD_LIST_STATUS = READY_FOR_INVOICE) OR
         (P_I_V_LOAD_LIST_STATUS = WORK_COMPLETE)) THEN

        SELECT COUNT(1)
          INTO L_V_REC_COUNT
          FROM TOS_LL_BOOKED_LOADING
         WHERE FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
           AND RECORD_STATUS = 'A'
           AND STOWAGE_POSITION IS NULL
           AND LOADING_STATUS <> 'SS'; -- *7

        IF (L_V_REC_COUNT > 0) THEN
          -- Then throw error message Blank stowage position exists.
          P_O_V_ERR_CD := 'EDL.SE0186';
          RETURN;
        END IF;
      END IF;
    END IF; -- *5
    /*
        *3: Changes end
    */

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);

  END PRE_ELL_LL_STATUS_VALIDATION;

  /*Start commented by vikas, this logic is already available in
      pce_edl_dlmaintenance package, 22.11.2011*

  PROCEDURE PRE_ELL_PREV_LOAD_LIST_ID (
            p_i_v_vessel                     VARCHAR2
          , p_i_v_equip_no                   VARCHAR2
          , p_i_v_booking_no                 VARCHAR2
          , p_i_v_eta_date                   VARCHAR2
          , p_i_v_eta_tm                     VARCHAR2
          , p_i_port_code                    VARCHAR2
          , p_o_v_pk_loading_id          OUT VARCHAR2
          , p_o_v_flag                   OUT VARCHAR2
          , p_o_v_err_cd                 OUT VARCHAR2
      )
      AS

      BEGIN
          p_o_v_err_cd    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

          SELECT       PK_LOADING_ID
                  , FLAG
          INTO      p_o_v_pk_loading_id
                  , p_o_v_flag
          FROM (
                  SELECT    PK_LOADING_ID
                          , FLAG
                          , ROW_NUMBER() OVER (ORDER BY ACTIVITY_DATE_TIME DESC) SRNO
                  FROM    (
                              SELECT     LLB.PK_BOOKED_LOADING_ID PK_LOADING_ID
                                      ,'D' FLAG
                                      , ACTIVITY_DATE_TIME
                              FROM      TOS_LL_LOAD_LIST LL ,
                                      TOS_LL_BOOKED_LOADING LLB,
                                      ITP063 ITP,
                                      ITP040 P
                              WHERE     LL.RECORD_STATUS        = 'A'
                              AND       LLB.RECORD_STATUS       = 'A'
                              AND       LL.PK_LOAD_LIST_ID      = LLB.FK_LOAD_LIST_ID
                              AND       LL.FK_VESSEL             = p_i_v_vessel
                              AND       LLB.DN_EQUIPMENT_NO     = p_i_v_equip_no
                              AND       (
                                      (p_i_v_booking_no is NULL) OR
                                      (LLB.FK_BOOKING_NO        = p_i_v_booking_no)
                                      )
                              AND       P.PICODE                = LL.DN_PORT
                              AND       LL.FK_SERVICE           = ITP.VVSRVC
                              AND       LL.FK_VESSEL            = ITP.VVVESS
                              AND       LL.FK_VOYAGE            = ITP.VVVOYN
                              AND       LL.FK_DIRECTION         = ITP.VVPDIR
                              AND       ITP.OMMISSION_FLAG IS NULL
                              AND       LL.FK_PORT_SEQUENCE_NO  = ITP.VVPCSQ
                              AND       ITP.VVVERS              = 99
                              AND       LL.FK_VERSION           = 99
                              AND      (
                                      PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(  NVL2(TO_CHAR(LLB.ACTIVITY_DATE_TIME,'YYYYMMDD'),TO_CHAR(LLB.ACTIVITY_DATE_TIME,'YYYYMMDD'),ITP.VVSLDT )
                                                                        , NVL2(TO_CHAR(LLB.ACTIVITY_DATE_TIME,'HH24MI'),TO_CHAR(LLB.ACTIVITY_DATE_TIME,'HH24MI'), ITP.VVSLTM )
                                                                        , LL.DN_PORT )
                                      <
                                      PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL( TO_CHAR(TO_DATE(p_i_v_eta_date ,'DD/MM/YYYY'),'YYYYMMDD')
                                                                        , p_i_v_eta_tm
                                                                        , p_i_port_code )
                                      )

                              UNION ALL

                              SELECT     TS.PK_RESTOW_ID PK_LOADING_ID
                                      ,'R' FLAG
                                      , ACTIVITY_DATE_TIME
                              FROM      TOS_LL_LOAD_LIST LL ,
                                      TOS_RESTOW       TS ,
                                      ITP063 ITP          ,
                                      ITP040 P
                              WHERE     LL.RECORD_STATUS        = 'A'
                              AND       TS.RECORD_STATUS        = 'A'
                              AND       LL.PK_LOAD_LIST_ID      = TS.FK_LOAD_LIST_ID
                              AND       LL.FK_VESSEL             = p_i_v_vessel
                              AND       TS.DN_EQUIPMENT_NO      = p_i_v_equip_no
                              AND       (
                                      (p_i_v_booking_no is NULL) OR
                                      (TS.FK_BOOKING_NO        = p_i_v_booking_no)
                                      )
                              AND       P.PICODE                = LL.DN_PORT
                              AND       LL.FK_SERVICE           = ITP.VVSRVC
                              AND       LL.FK_VESSEL            = ITP.VVVESS
                              AND       LL.FK_VOYAGE            = ITP.VVVOYN
                              AND       LL.FK_DIRECTION         = ITP.VVPDIR
                              AND       ITP.OMMISSION_FLAG IS NULL
                              AND       LL.FK_PORT_SEQUENCE_NO  = ITP.VVPCSQ
                              AND       ITP.VVVERS              = 99
                              AND       LL.FK_VERSION           = 99
                              AND      (
                                      PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(  NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'),TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'),ITP.VVSLDT )
                                                                        , NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'),TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'), ITP.VVSLTM )
                                                                        , LL.DN_PORT )
                                      <
                                      PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL( TO_CHAR(TO_DATE(p_i_v_eta_date ,'DD/MM/YYYY'),'YYYYMMDD')
                                                                       , p_i_v_eta_tm
                                                                       , p_i_port_code )
                                      )
                          )
                          ORDER BY ACTIVITY_DATE_TIME DESC
                  )
          WHERE SRNO = 1;


      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           p_o_v_pk_loading_id       :=  NULL;
           p_o_v_flag                :=  NULL;
           p_o_v_err_cd              :=  'ELL.SE0121';
           RETURN;

        WHEN OTHERS THEN
          p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
          RETURN;

      END PRE_ELL_PREV_LOAD_LIST_ID;

  /*  End commented by vikas, this logic is already available in
      pce_edl_dlmaintenance package, 22.11.2011 */
  PROCEDURE PRE_ELL_PREV_LOADED_EQUIP_ID(P_I_V_EQUIP_NO      VARCHAR2
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
                  ,ROW_NUMBER() OVER(ORDER BY ACTIVITY_DATE_TIME DESC) SRNO
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
                       AND ITP.OMMISSION_FLAG IS NULL
                       AND LL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
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
                       AND ITP.OMMISSION_FLAG IS NULL
                       AND LL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
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
      P_O_V_ERR_CD        := 'ELL.SE0121';
      RETURN;

    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
      RETURN;

  END PRE_ELL_PREV_LOADED_EQUIP_ID;

  /* Start commented by vikas because this sp is alredy available
  in PRE_EDL_DLMAINTENANCE Package, 22.11.2011 *
  PROCEDURE PRE_ELL_NEXT_DISCHARGE_LIST_ID (
        p_i_v_vessel             VARCHAR2
      , p_i_v_equip_no           VARCHAR2
      , p_i_v_booking_no         VARCHAR2
      , p_i_v_etd_date           VARCHAR2
      , p_i_v_etd_tm             VARCHAR2
      , p_i_port_code            VARCHAR2
      , p_o_v_pk_discharge_id    OUT VARCHAR2
      , p_o_v_flag               OUT VARCHAR2
      , p_o_v_err_cd             OUT VARCHAR2
  )
  AS

  BEGIN
      p_o_v_err_cd    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      SELECT       PK_DISCHARGE_ID
              , FLAG
      INTO      p_o_v_pk_discharge_id
              , p_o_v_flag
      FROM (
              SELECT    PK_DISCHARGE_ID
                      , FLAG
                      , ROW_NUMBER() OVER (ORDER BY ACTIVITY_DATE_TIME) SRNO
              FROM    (
                          SELECT     DLB.PK_BOOKED_DISCHARGE_ID PK_DISCHARGE_ID
                                  ,'D' FLAG
                                  , ACTIVITY_DATE_TIME
                          FROM      TOS_DL_DISCHARGE_LIST   DL ,
                                  TOS_DL_BOOKED_DISCHARGE DLB,
                                  ITP063 ITP,
                                  ITP040 P
                          WHERE     DL.RECORD_STATUS        = 'A'
                          AND       DLB.RECORD_STATUS       = 'A'
                          AND       DL.PK_DISCHARGE_LIST_ID = DLB.FK_DISCHARGE_LIST_ID
                          AND       DL.FK_VESSEL             = p_i_v_vessel
                          AND       DLB.DN_EQUIPMENT_NO     = p_i_v_equip_no
                          AND       (
                                  (p_i_v_booking_no is NULL) OR
                                  (DLB.FK_BOOKING_NO        = p_i_v_booking_no)
                                  )
                          AND       P.PICODE                = DL.DN_PORT
                          AND       DL.FK_SERVICE           = ITP.VVSRVC
                          AND       DL.FK_VESSEL            = ITP.VVVESS
                          AND       DL.FK_VOYAGE            = DECODE(DL.FK_SERVICE , 'AFS', ITP.VVVOYN, ITP.INVOYAGENO)
                          AND       DL.FK_DIRECTION         = ITP.VVPDIR
                          AND       ITP.OMMISSION_FLAG IS NULL
                          AND       DL.FK_PORT_SEQUENCE_NO  = ITP.VVPCSQ
                          AND       ITP.VVVERS              = 99
                          AND       DL.FK_VERSION           = 99
                          AND      (
                                  PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(  NVL2(TO_CHAR(DLB.ACTIVITY_DATE_TIME,'YYYYMMDD'),TO_CHAR(DLB.ACTIVITY_DATE_TIME,'YYYYMMDD'),ITP.VVARDT )
                                                                    , NVL2(TO_CHAR(DLB.ACTIVITY_DATE_TIME,'HH24MI'),TO_CHAR(DLB.ACTIVITY_DATE_TIME,'HH24MI'), ITP.VVARTM )
                                                                    , DL.DN_PORT )
                                  >
                                  PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL( TO_CHAR(TO_DATE(p_i_v_etd_date ,'DD/MM/YYYY'),'YYYYMMDD')
                                                                    , p_i_v_etd_tm
                                                                    , p_i_port_code )
                                  )

                          UNION ALL

                          SELECT     TS.PK_RESTOW_ID PK_DISCHARGE_ID
                                  ,'R' FLAG
                                  , ACTIVITY_DATE_TIME
                          FROM      TOS_DL_DISCHARGE_LIST   DL ,
                                  TOS_RESTOW              TS ,
                                  ITP063 ITP,
                                  ITP040 P
                          WHERE     DL.RECORD_STATUS        = 'A'
                          AND       TS.RECORD_STATUS        = 'A'
                          AND       DL.PK_DISCHARGE_LIST_ID = TS.FK_DISCHARGE_LIST_ID
                          AND       DL.FK_VESSEL             = p_i_v_vessel
                          AND       TS.DN_EQUIPMENT_NO      = p_i_v_equip_no
                          AND       (
                                  (p_i_v_booking_no is NULL) OR
                                  (TS.FK_BOOKING_NO        = p_i_v_booking_no)
                                  )
                          AND       P.PICODE                = DL.DN_PORT
                          AND       DL.FK_SERVICE           = ITP.VVSRVC
                          AND       DL.FK_VESSEL            = ITP.VVVESS
                          AND       DL.FK_VOYAGE            = DECODE(DL.FK_SERVICE , 'AFS', ITP.VVVOYN, ITP.INVOYAGENO)
                          AND       DL.FK_DIRECTION         = ITP.VVPDIR
                          AND       DL.FK_PORT_SEQUENCE_NO  = ITP.VVPCSQ
                          AND       ITP.OMMISSION_FLAG IS NULL
                          AND       ITP.VVVERS              = 99
                          AND       DL.FK_VERSION           = 99
                          AND      (
                                  PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(  NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'),TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'),ITP.VVARDT )
                                                                    , NVL2(TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'),TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'), ITP.VVARTM )
                                                                    , DL.DN_PORT )
                                  >
                                  PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL( TO_CHAR(TO_DATE(p_i_v_etd_date ,'DD/MM/YYYY'),'YYYYMMDD')
                                                                    , p_i_v_etd_tm
                                                                    , p_i_port_code )
                                  )
                      )
                      ORDER BY ACTIVITY_DATE_TIME DESC
              )
      WHERE SRNO = 1;


  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       p_o_v_pk_discharge_id     :=  NULL;
       p_o_v_flag                :=  NULL;
       p_o_v_err_cd              :=  'ELL.SE0121';
       RETURN;

    WHEN OTHERS THEN
      p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
      RETURN;

  END PRE_ELL_NEXT_DISCHARGE_LIST_ID;

  * End commented by vikas because this sp is alredy available
  in PRE_EDL_DLMAINTENANCE Package, 22.11.2011 */

  PROCEDURE PRE_TOS_REMOVE_ERROR(P_I_V_DA_ERROR          VARCHAR2
                                ,P_I_V_LL_DL_FLAG        VARCHAR2
                                ,P_I_V_SIZE              VARCHAR2
                                ,P_I_V_CLR1              VARCHAR2
                                ,P_I_V_CLR2              VARCHAR2
                                ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                ,P_I_V_FK_OVERSHIPPED_ID VARCHAR2
                                ,P_I_V_FK_LOAD_LIST_ID   VARCHAR2
                                ,P_O_V_ERR_CD            OUT VARCHAR2) AS
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
       AND FK_OVERSHIPPED_ID = P_I_V_FK_OVERSHIPPED_ID
       AND FK_LOAD_LIST_ID = P_I_V_FK_LOAD_LIST_ID
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
       AND FK_OVERSHIPPED_ID = P_I_V_FK_OVERSHIPPED_ID
       AND FK_LOAD_LIST_ID = P_I_V_FK_LOAD_LIST_ID
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
       AND FK_OVERSHIPPED_ID = P_I_V_FK_OVERSHIPPED_ID
       AND FK_LOAD_LIST_ID = P_I_V_FK_LOAD_LIST_ID
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
       AND FK_OVERSHIPPED_ID = P_I_V_FK_OVERSHIPPED_ID
       AND FK_LOAD_LIST_ID = P_I_V_FK_LOAD_LIST_ID;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_TOS_REMOVE_ERROR;

  PROCEDURE PRE_EDL_POD_UPDATE(P_I_V_PK_BOOKED_ID            TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE
                              ,P_I_V_FK_BOOKING_NO           TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE
                              ,P_I_V_LLDL_FLAG               VARCHAR2
                              ,P_I_V_FK_BKG_VOYAGE_ROUT_DTL  TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
                              ,P_I_V_LOAD_CONDITION          TOS_LL_BOOKED_LOADING.LOAD_CONDITION%TYPE
                              ,P_I_V_CONTAINER_GROSS_WEIGHT  TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE
                              --*29 begin
                              ,P_I_V_VGM TOS_LL_BOOKED_LOADING.VGM%TYPE --*34
                              ,P_I_V_CATEGORY TOS_LL_BOOKED_LOADING.CATEGORY_CODE%TYPE
                              --*29 end
                              ,P_I_V_DAMAGED                 TOS_LL_BOOKED_LOADING.DAMAGED%TYPE
                              ,P_I_V_FK_CONTAINER_OPERATOR   TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE
                              ,P_I_V_OUT_SLOT_OPERATOR       TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE
                              ,P_I_V_SEAL_NO                 TOS_LL_BOOKED_LOADING.SEAL_NO%TYPE
                              ,P_I_V_MLO_VESSEL              TOS_LL_BOOKED_LOADING.MLO_VESSEL%TYPE
                              ,P_I_V_MLO_VOYAGE              TOS_LL_BOOKED_LOADING.MLO_VOYAGE%TYPE
                              ,P_I_V_MLO_VESSEL_ETA          DATE
                              ,P_I_V_MLO_POD1                TOS_LL_BOOKED_LOADING.MLO_POD1%TYPE
                              ,P_I_V_MLO_POD2                TOS_LL_BOOKED_LOADING.MLO_POD2%TYPE
                              ,P_I_V_MLO_POD3                TOS_LL_BOOKED_LOADING.MLO_POD3%TYPE
                              ,P_I_V_MLO_DEL                 TOS_LL_BOOKED_LOADING.MLO_DEL%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_1  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_2  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_3  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3%TYPE
                              ,P_I_V_CONTAINER_LOADING_REM_1 TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1%TYPE
                              ,P_I_V_CONTAINER_LOADING_REM_2 TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG1  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG1%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG2  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG2%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG3  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG3%TYPE
                              ,P_I_V_FUMIGATION_ONLY         TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY%TYPE
                              ,P_I_V_RESIDUE_ONLY_FLAG       TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG%TYPE
                              ,P_I_V_FK_BKG_SIZE_TYPE_DTL    TOS_LL_BOOKED_LOADING.FK_BKG_SIZE_TYPE_DTL%TYPE
                              ,P_I_V_FK_BKG_SUPPLIER         TOS_LL_BOOKED_LOADING.FK_BKG_SUPPLIER%TYPE
                              ,P_I_V_FK_BKG_EQUIPM_DTL       TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE
                              ,P_O_V_ERR_CD                  OUT VARCHAR2) AS
    L_V_LOAD_CONDITION          TOS_LL_BOOKED_LOADING.LOAD_CONDITION%TYPE;
    L_V_CONTAINER_GROSS_WEIGHT  TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE;
    --*29 begin
    L_V_VGM TOS_LL_BOOKED_LOADING.VGM%TYPE; --*34
    L_V_CATEGORY TOS_LL_BOOKED_LOADING.CATEGORY_CODE%TYPE;
    --*29 end
    L_V_DAMAGED                 TOS_LL_BOOKED_LOADING.DAMAGED%TYPE;
    L_V_FK_CONTAINER_OPERATOR   TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE;
    L_V_OUT_SLOT_OPERATOR       TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE;
    L_V_SEAL_NO                 TOS_LL_BOOKED_LOADING.SEAL_NO%TYPE;
    L_V_MLO_VESSEL              TOS_LL_BOOKED_LOADING.MLO_VESSEL%TYPE;
    L_V_MLO_VOYAGE              TOS_LL_BOOKED_LOADING.MLO_VOYAGE%TYPE;
    L_V_MLO_VESSEL_ETA          TOS_LL_BOOKED_LOADING.MLO_VESSEL_ETA%TYPE;
    L_V_MLO_POD1                TOS_LL_BOOKED_LOADING.MLO_POD1%TYPE;
    L_V_MLO_POD2                TOS_LL_BOOKED_LOADING.MLO_POD2%TYPE;
    L_V_MLO_POD3                TOS_LL_BOOKED_LOADING.MLO_POD3%TYPE;
    L_V_MLO_DEL                 TOS_LL_BOOKED_LOADING.MLO_DEL%TYPE;
    L_V_FK_HANDL_INSTRUCTION_1  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1%TYPE;
    L_V_FK_HANDL_INSTRUCTION_2  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2%TYPE;
    L_V_FK_HANDL_INSTRUCTION_3  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3%TYPE;
    L_V_CONTAINER_LOADING_REM_1 TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1%TYPE;
    L_V_CONTAINER_LOADING_REM_2 TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2%TYPE;
    L_V_TIGHT_CONNECTION_FLAG1  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG1%TYPE;
    L_V_TIGHT_CONNECTION_FLAG2  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG2%TYPE;
    L_V_TIGHT_CONNECTION_FLAG3  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG3%TYPE;
    L_V_FUMIGATION_ONLY         TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY%TYPE;
    L_V_RESIDUE_ONLY_FLAG       TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG%TYPE;

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    SELECT LOAD_CONDITION
          ,CONTAINER_GROSS_WEIGHT
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
          ,CATEGORY_CODE --*29
          ,VGM --*34
      INTO L_V_LOAD_CONDITION
          ,L_V_CONTAINER_GROSS_WEIGHT
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
          ,L_V_CATEGORY --*29
          ,L_V_VGM --*34
      FROM TOS_LL_BOOKED_LOADING
     WHERE PK_BOOKED_LOADING_ID = P_I_V_PK_BOOKED_ID;

    -- check the value of passed data from db value
    IF (NVL(P_I_V_LOAD_CONDITION, '~') <> NVL(L_V_LOAD_CONDITION, '~')) THEN
      L_V_LOAD_CONDITION := NVL(P_I_V_LOAD_CONDITION, '~');
    ELSE
      L_V_LOAD_CONDITION := NULL;
    END IF;

    IF (NVL(TO_NUMBER(P_I_V_CONTAINER_GROSS_WEIGHT), 0) <>
       NVL(L_V_CONTAINER_GROSS_WEIGHT, 0)) THEN
      L_V_CONTAINER_GROSS_WEIGHT := NVL(P_I_V_CONTAINER_GROSS_WEIGHT, 0);
    ELSE

    /*-- *32  IF (P_I_V_CONTAINER_GROSS_WEIGHT IS NOT NULL AND
         L_V_CONTAINER_GROSS_WEIGHT IS NULL)
         OR (P_I_V_CONTAINER_GROSS_WEIGHT IS NULL AND
         L_V_CONTAINER_GROSS_WEIGHT IS NOT NULL) THEN
        L_V_CONTAINER_GROSS_WEIGHT := 0;
      ELSE
        L_V_CONTAINER_GROSS_WEIGHT := NULL;
      --END IF; * 32--*/
      L_V_CONTAINER_GROSS_WEIGHT := NULL;
    END IF;

    -- START *34 VGM
    IF (NVL(TO_NUMBER(P_I_V_VGM), 0) <> NVL(L_V_VGM, 0)) THEN
      L_V_VGM := NVL(P_I_V_VGM, 0);
    ELSE
      L_V_VGM := NULL;
    END IF;
   -- END *34

     --Category start
    IF (NVL(P_I_V_CATEGORY, '~') <> NVL(L_V_CATEGORY, '~')) THEN
      L_V_CATEGORY := NVL(P_I_V_CATEGORY, '~');
    ELSE
      L_V_CATEGORY := NULL;
    END IF;
     --Category end
   --*29 end
   IF (NVL(P_I_V_DAMAGED, '~') <> NVL(L_V_DAMAGED, '~')) THEN
      L_V_DAMAGED := NVL(P_I_V_DAMAGED, '~');
    ELSE
      L_V_DAMAGED := NULL;
    END IF;

    IF (NVL(P_I_V_FK_CONTAINER_OPERATOR, '~') <>
       NVL(L_V_FK_CONTAINER_OPERATOR, '~')) THEN
      L_V_FK_CONTAINER_OPERATOR := NVL(P_I_V_FK_CONTAINER_OPERATOR, '~');
    ELSE
      L_V_FK_CONTAINER_OPERATOR := NULL;
    END IF;

    IF (NVL(P_I_V_OUT_SLOT_OPERATOR, '~') <>
       NVL(L_V_OUT_SLOT_OPERATOR, '~')) THEN
      L_V_OUT_SLOT_OPERATOR := NVL(P_I_V_OUT_SLOT_OPERATOR, '~');
    ELSE
      L_V_OUT_SLOT_OPERATOR := NULL;
    END IF;

    IF (NVL(P_I_V_SEAL_NO, '~') <> NVL(L_V_SEAL_NO, '~')) THEN
      L_V_SEAL_NO := NVL(P_I_V_SEAL_NO, '~');
    ELSE
      L_V_SEAL_NO := NULL;
    END IF;

    IF (NVL(P_I_V_MLO_VESSEL, '~') <> NVL(L_V_MLO_VESSEL, '~')) THEN
      L_V_MLO_VESSEL := NVL(P_I_V_MLO_VESSEL, '~');
    ELSE
      L_V_MLO_VESSEL := NULL;
    END IF;

    IF (NVL(P_I_V_MLO_VOYAGE, '~') <> NVL(L_V_MLO_VOYAGE, '~')) THEN
      L_V_MLO_VOYAGE := NVL(P_I_V_MLO_VOYAGE, '~');
    ELSE
      L_V_MLO_VOYAGE := NULL;
    END IF;

    IF (NVL(P_I_V_MLO_VESSEL_ETA, TO_DATE('01/01/1900', 'dd/mm/yyyy')) <>
       NVL(L_V_MLO_VESSEL_ETA, TO_DATE('01/01/1900', 'dd/mm/yyyy'))) THEN
      L_V_MLO_VESSEL_ETA := NVL(P_I_V_MLO_VESSEL_ETA,
                                TO_DATE('01/01/1900', 'dd/mm/yyyy'));
    ELSE
      L_V_MLO_VESSEL_ETA := NULL;
    END IF;

    IF (NVL(P_I_V_MLO_POD1, '~') <> NVL(L_V_MLO_POD1, '~')) THEN
      L_V_MLO_POD1 := NVL(P_I_V_MLO_POD1, '~');
    ELSE
      L_V_MLO_POD1 := NULL;
    END IF;

    IF (NVL(P_I_V_MLO_POD2, '~') <> NVL(L_V_MLO_POD2, '~')) THEN
      L_V_MLO_POD2 := NVL(P_I_V_MLO_POD2, '~');
    ELSE
      L_V_MLO_POD2 := NULL;
    END IF;

    IF (NVL(P_I_V_MLO_POD3, '~') <> NVL(L_V_MLO_POD3, '~')) THEN
      L_V_MLO_POD3 := NVL(P_I_V_MLO_POD3, '~');
    ELSE
      L_V_MLO_POD3 := NULL;
    END IF;

    IF (NVL(P_I_V_MLO_DEL, '~') <> NVL(L_V_MLO_DEL, '~')) THEN
      L_V_MLO_DEL := NVL(P_I_V_MLO_DEL, '~');
    ELSE
      L_V_MLO_DEL := NULL;
    END IF;

    IF (NVL(P_I_V_FK_HANDL_INSTRUCTION_1, '~') <>
       NVL(L_V_FK_HANDL_INSTRUCTION_1, '~')) THEN
      L_V_FK_HANDL_INSTRUCTION_1 := NVL(P_I_V_FK_HANDL_INSTRUCTION_1, '~');
    ELSE
      L_V_FK_HANDL_INSTRUCTION_1 := NULL;
    END IF;

    IF (NVL(P_I_V_FK_HANDL_INSTRUCTION_2, '~') <>
       NVL(L_V_FK_HANDL_INSTRUCTION_2, '~')) THEN
      L_V_FK_HANDL_INSTRUCTION_2 := NVL(P_I_V_FK_HANDL_INSTRUCTION_2, '~');
    ELSE
      L_V_FK_HANDL_INSTRUCTION_2 := NULL;
    END IF;

    IF (NVL(P_I_V_FK_HANDL_INSTRUCTION_3, '~') <>
       NVL(L_V_FK_HANDL_INSTRUCTION_3, '~')) THEN
      L_V_FK_HANDL_INSTRUCTION_3 := NVL(P_I_V_FK_HANDL_INSTRUCTION_3, '~');
    ELSE
      L_V_FK_HANDL_INSTRUCTION_3 := NULL;
    END IF;

    IF (NVL(P_I_V_CONTAINER_LOADING_REM_1, '~') <>
       NVL(L_V_CONTAINER_LOADING_REM_1, '~')) THEN
      L_V_CONTAINER_LOADING_REM_1 := NVL(P_I_V_CONTAINER_LOADING_REM_1, '~');
    ELSE
      L_V_CONTAINER_LOADING_REM_1 := NULL;
    END IF;

    IF (NVL(P_I_V_CONTAINER_LOADING_REM_2, '~') <>
       NVL(L_V_CONTAINER_LOADING_REM_2, '~')) THEN
      L_V_CONTAINER_LOADING_REM_2 := NVL(P_I_V_CONTAINER_LOADING_REM_2, '~');
    ELSE
      L_V_CONTAINER_LOADING_REM_2 := NULL;
    END IF;

    IF (NVL(P_I_V_TIGHT_CONNECTION_FLAG1, '~') <>
       NVL(L_V_TIGHT_CONNECTION_FLAG1, '~')) THEN
      L_V_TIGHT_CONNECTION_FLAG1 := NVL(P_I_V_TIGHT_CONNECTION_FLAG1, '~');
    ELSE
      L_V_TIGHT_CONNECTION_FLAG1 := NULL;
    END IF;

    IF (NVL(P_I_V_TIGHT_CONNECTION_FLAG2, '~') <>
       NVL(L_V_TIGHT_CONNECTION_FLAG2, '~')) THEN
      L_V_TIGHT_CONNECTION_FLAG2 := NVL(P_I_V_TIGHT_CONNECTION_FLAG2, '~');
    ELSE
      L_V_TIGHT_CONNECTION_FLAG2 := NULL;
    END IF;

    IF (NVL(P_I_V_TIGHT_CONNECTION_FLAG3, '~') <>
       NVL(L_V_TIGHT_CONNECTION_FLAG3, '~')) THEN
      L_V_TIGHT_CONNECTION_FLAG3 := NVL(P_I_V_TIGHT_CONNECTION_FLAG3, '~');
    ELSE
      L_V_TIGHT_CONNECTION_FLAG3 := NULL;
    END IF;

    IF (NVL(P_I_V_FUMIGATION_ONLY, '~') <> NVL(L_V_FUMIGATION_ONLY, '~')) THEN
      L_V_FUMIGATION_ONLY := NVL(P_I_V_FUMIGATION_ONLY, '~');
    ELSE
      L_V_FUMIGATION_ONLY := NULL;
    END IF;

    IF (NVL(P_I_V_RESIDUE_ONLY_FLAG, '~') <>
       NVL(L_V_RESIDUE_ONLY_FLAG, '~')) THEN
      L_V_RESIDUE_ONLY_FLAG := NVL(P_I_V_RESIDUE_ONLY_FLAG, '~');
    ELSE
      L_V_RESIDUE_ONLY_FLAG := NULL;
    END IF;

    PCE_EUT_COMMON.PRE_UPD_NEXT_POD(P_I_V_FK_BOOKING_NO,
                                    P_I_V_LLDL_FLAG,
                                    P_I_V_FK_BKG_VOYAGE_ROUT_DTL,
                                    L_V_LOAD_CONDITION,
                                    L_V_CONTAINER_GROSS_WEIGHT,
                                    --*29 begin
                                    L_V_VGM, --*34
                                    L_V_CATEGORY,
                                    --*29 end
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
      RETURN;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);
  END PRE_EDL_POD_UPDATE;

  /* *17 start * */
  /**
  Procedure: PRE_UPD_MLO_DETAIL
  Copy DG, OOG, REEFER details from load list to discharge list detail table.
  Parameter->
      P_I_V_LIST_ID := load list id
      P_I_V_USER_ID := record change user name
      P_I_V_DATE    := record change date ( format YYYYMMDDHH24MISS)
  */
  PROCEDURE PRE_UPD_MLO_DETAIL(P_I_V_LIST_ID VARCHAR2
                              ,P_I_V_USER_ID VARCHAR2
                              ,P_I_V_DATE    VARCHAR2 /* format YYYYMMDDHH24MISS */) AS
    C_LOAD_COMPLETE CONSTANT NUMBER DEFAULT 10;
    C_ACTIVE        CONSTANT VARCHAR2(1) DEFAULT 'A';
    C_DISCHARGE     CONSTANT VARCHAR2(2) DEFAULT 'DI';
    C_LOADED        CONSTANT VARCHAR2(2) DEFAULT 'LO';
    C_DATE_FORMAT   CONSTANT VARCHAR2(16) DEFAULT 'YYYYMMDDHH24MISS';
    SEP             CONSTANT VARCHAR2(1) DEFAULT '~';

    CURSOR CURSOR_FOR_DISCHARGE IS WITH QR1 AS(
      SELECT BL.REEFER_TMP
            ,BL.REEFER_TMP_UNIT
            ,BL.FK_IMDG
            ,BL.FK_UNNO
            ,BL.FK_UN_VAR
            ,BL.FLASH_POINT
            ,BL.FLASH_UNIT
            ,BL.FK_PORT_CLASS
            ,BL.OVERHEIGHT_CM
            ,BL.OVERLENGTH_FRONT_CM
            ,BL.OVERLENGTH_REAR_CM
            ,BL.OVERWIDTH_RIGHT_CM
            ,BL.OVERWIDTH_LEFT_CM
            ,BL.VOID_SLOT
            ,BL.STOWAGE_POSITION
            ,BL.FK_HANDLING_INSTRUCTION_1
            ,BL.FK_HANDLING_INSTRUCTION_2
            ,BL.FK_HANDLING_INSTRUCTION_3
            ,BL.CONTAINER_LOADING_REM_1
            ,BL.CONTAINER_LOADING_REM_2
            ,BL.MLO_VESSEL
            ,BL.MLO_VOYAGE
            ,BL.MLO_POD1
            ,BL.MLO_POD2
            ,BL.MLO_POD3
            ,BL.TIGHT_CONNECTION_FLAG1
            ,BL.TIGHT_CONNECTION_FLAG2
            ,BL.TIGHT_CONNECTION_FLAG3
            ,BL.DN_EQUIPMENT_NO
            ,BL.FK_BOOKING_NO
            ,BL.LOADING_STATUS
            ,BL.CONTAINER_GROSS_WEIGHT
            ,BL.MLO_VESSEL_ETA
            ,BL.MLO_DEL
            ,LL.DN_PORT
            ,LL.DN_TERMINAL
        FROM VASAPPS.TOS_LL_LOAD_LIST      LL
            ,VASAPPS.TOS_LL_BOOKED_LOADING BL
       WHERE LL.PK_LOAD_LIST_ID = P_I_V_LIST_ID
         AND LL.LOAD_LIST_STATUS >= C_LOAD_COMPLETE
         AND LL.PK_LOAD_LIST_ID = BL.FK_LOAD_LIST_ID
         AND BL.RECORD_STATUS = C_ACTIVE
         AND LL.RECORD_STATUS = C_ACTIVE)
        SELECT BD.PK_BOOKED_DISCHARGE_ID
        ,QR1.REEFER_TMP
        ,QR1.REEFER_TMP_UNIT
        ,QR1.FK_IMDG
        ,QR1.FK_UNNO
        ,QR1.FK_UN_VAR
        ,QR1.FLASH_POINT
        ,QR1.FLASH_UNIT
        ,QR1.FK_PORT_CLASS
        ,QR1.OVERHEIGHT_CM
        ,QR1.OVERLENGTH_FRONT_CM
        ,QR1.OVERLENGTH_REAR_CM
        ,QR1.OVERWIDTH_RIGHT_CM
        ,QR1.OVERWIDTH_LEFT_CM
        ,QR1.VOID_SLOT
        ,QR1.STOWAGE_POSITION
        ,QR1.FK_HANDLING_INSTRUCTION_1
        ,QR1.FK_HANDLING_INSTRUCTION_2
        ,QR1.FK_HANDLING_INSTRUCTION_3
        ,QR1.CONTAINER_LOADING_REM_1
        ,QR1.CONTAINER_LOADING_REM_2
        ,QR1.MLO_VESSEL
        ,QR1.MLO_VOYAGE
        ,QR1.MLO_POD1
        ,QR1.MLO_POD2
        ,QR1.MLO_POD3
        ,QR1.TIGHT_CONNECTION_FLAG1
        ,QR1.TIGHT_CONNECTION_FLAG2
        ,QR1.TIGHT_CONNECTION_FLAG3
        ,QR1.DN_EQUIPMENT_NO
        ,QR1.FK_BOOKING_NO
        ,QR1.LOADING_STATUS
        ,QR1.DN_PORT
        ,QR1.DN_TERMINAL
        ,QR1.CONTAINER_GROSS_WEIGHT
        ,QR1.MLO_VESSEL_ETA
        ,QR1.MLO_DEL
          FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
        ,QR1
         WHERE BD.FK_BOOKING_NO = QR1.FK_BOOKING_NO
           AND BD.DN_EQUIPMENT_NO = QR1.DN_EQUIPMENT_NO
           AND BD.DN_POL = QR1.DN_PORT
           AND BD.DN_POL_TERMINAL = QR1.DN_TERMINAL
           AND BD.RECORD_STATUS = C_ACTIVE
           AND BD.DISCHARGE_STATUS <> C_DISCHARGE;


  BEGIN

    /* * loop through each bookings in load list * */
    FOR L_V_CURSOR_LOAD_LIST_DATA IN CURSOR_FOR_DISCHARGE
    LOOP
      /* loop1 */

      DBMS_OUTPUT.PUT_LINE(L_V_CURSOR_LOAD_LIST_DATA.PK_BOOKED_DISCHARGE_ID || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.REEFER_TMP || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.REEFER_TMP_UNIT || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FK_IMDG || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FK_UNNO || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FK_UN_VAR || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FLASH_POINT || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FLASH_UNIT || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FK_PORT_CLASS || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.OVERHEIGHT_CM || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.OVERLENGTH_FRONT_CM || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.OVERLENGTH_REAR_CM || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.OVERWIDTH_RIGHT_CM || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.OVERWIDTH_LEFT_CM || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.VOID_SLOT || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.STOWAGE_POSITION || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_1 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_2 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_3 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_LOADING_REM_1 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_LOADING_REM_2 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.MLO_VESSEL || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.MLO_VOYAGE || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.MLO_POD1 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.MLO_POD2 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.MLO_POD3 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG1 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG2 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG3 || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.DN_EQUIPMENT_NO || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.FK_BOOKING_NO || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.LOADING_STATUS || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.DN_PORT || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.DN_TERMINAL || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_GROSS_WEIGHT || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.MLO_VESSEL_ETA || SEP ||
                           L_V_CURSOR_LOAD_LIST_DATA.MLO_DEL);

      /* * update discharge list * */
      UPDATE VASAPPS.TOS_DL_BOOKED_DISCHARGE
         SET DN_LOADING_STATUS         = L_V_CURSOR_LOAD_LIST_DATA.LOADING_STATUS
            ,STOWAGE_POSITION          = L_V_CURSOR_LOAD_LIST_DATA.STOWAGE_POSITION
            ,CONTAINER_GROSS_WEIGHT    = L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_GROSS_WEIGHT
            ,MLO_VESSEL                = L_V_CURSOR_LOAD_LIST_DATA.MLO_VESSEL
            ,MLO_VOYAGE                = L_V_CURSOR_LOAD_LIST_DATA.MLO_VOYAGE
            ,MLO_VESSEL_ETA            = TO_DATE(L_V_CURSOR_LOAD_LIST_DATA.MLO_VESSEL_ETA,
                                                 'DD/MM/YYYY HH24:MI')
            ,MLO_POD1                  = L_V_CURSOR_LOAD_LIST_DATA.MLO_POD1
            ,MLO_POD2                  = L_V_CURSOR_LOAD_LIST_DATA.MLO_POD2
            ,MLO_POD3                  = L_V_CURSOR_LOAD_LIST_DATA.MLO_POD3
            ,MLO_DEL                   = L_V_CURSOR_LOAD_LIST_DATA.MLO_DEL
            ,REEFER_TEMPERATURE        = L_V_CURSOR_LOAD_LIST_DATA.REEFER_TMP
            ,REEFER_TMP_UNIT           = L_V_CURSOR_LOAD_LIST_DATA.REEFER_TMP_UNIT
            ,FK_IMDG                   = L_V_CURSOR_LOAD_LIST_DATA.FK_IMDG
            ,FK_UNNO                   = L_V_CURSOR_LOAD_LIST_DATA.FK_UNNO
            ,FK_UN_VAR                 = L_V_CURSOR_LOAD_LIST_DATA.FK_UN_VAR
            ,FLASH_POINT               = L_V_CURSOR_LOAD_LIST_DATA.FLASH_POINT
            ,FLASH_UNIT                = L_V_CURSOR_LOAD_LIST_DATA.FLASH_UNIT
            ,FK_PORT_CLASS             = L_V_CURSOR_LOAD_LIST_DATA.FK_PORT_CLASS
            ,OVERHEIGHT_CM             = L_V_CURSOR_LOAD_LIST_DATA.OVERHEIGHT_CM
            ,OVERLENGTH_FRONT_CM       = L_V_CURSOR_LOAD_LIST_DATA.OVERLENGTH_FRONT_CM
            ,OVERLENGTH_REAR_CM        = L_V_CURSOR_LOAD_LIST_DATA.OVERLENGTH_REAR_CM
            ,OVERWIDTH_RIGHT_CM        = L_V_CURSOR_LOAD_LIST_DATA.OVERWIDTH_RIGHT_CM
            ,OVERWIDTH_LEFT_CM         = L_V_CURSOR_LOAD_LIST_DATA.OVERWIDTH_LEFT_CM
            ,VOID_SLOT                 = L_V_CURSOR_LOAD_LIST_DATA.VOID_SLOT
            ,FK_HANDLING_INSTRUCTION_1 = L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_1
            ,FK_HANDLING_INSTRUCTION_2 = L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_2
            ,FK_HANDLING_INSTRUCTION_3 = L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_3
            ,CONTAINER_LOADING_REM_1   = L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_LOADING_REM_1
            ,CONTAINER_LOADING_REM_2   = L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_LOADING_REM_2
            ,TIGHT_CONNECTION_FLAG1    = L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG1
            ,TIGHT_CONNECTION_FLAG2    = L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG2
            ,TIGHT_CONNECTION_FLAG3    = L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG3
            ,RECORD_CHANGE_USER        = P_I_V_USER_ID
            ,RECORD_CHANGE_DATE        = TO_DATE(P_I_V_DATE, C_DATE_FORMAT)
       WHERE PK_BOOKED_DISCHARGE_ID =
             L_V_CURSOR_LOAD_LIST_DATA.PK_BOOKED_DISCHARGE_ID;
    END LOOP; /* loop1 */

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END PRE_UPD_MLO_DETAIL;
  /* *17 end * */

  /* *23 start * */
  PROCEDURE PRE_FIND_DISCHARGE_LIST(P_I_V_BOOKING       VARCHAR2
                                   ,P_I_V_VESSEL        VARCHAR2
                                   ,P_I_V_EQUIPMENT     VARCHAR2
                                   ,P_O_V_FLAG          OUT NOCOPY VARCHAR2
                                   ,P_O_V_BOOKED_DIS_ID OUT NOCOPY VARCHAR2
                                   ,P_O_V_ERR_CD        OUT NOCOPY VARCHAR2) AS
    L_V_VESSEL            VARCHAR2(100);
    L_V_TERMINAL          VARCHAR2(100);
    L_V_VOYAGE            VARCHAR2(100);
    L_V_ITP_ETA           ITP063.VVARDT%TYPE;
    L_V_ITP_ETD           ITP063.VVDPDT%TYPE;
    L_V_ITP_ETA_TIME      ITP063.VVARTM%TYPE;
    L_DT_BAYPLAN          DATE;
    L_V_PORT              VARCHAR2(100);
    L_V_PORT_SEQ          ITP063.VVPCSQ%TYPE;
    L_V_ITP_ETD_TIME      ITP063.VVDPTM%TYPE;
    L_V_ACT_VOYAGE_NUMBER BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER%TYPE;
    L_V_LAST_PORT         ITP063.VVPCAL%TYPE;
    L_V_LOAD_PORT         BOOKING_VOYAGE_ROUTING_DTL.LOAD_PORT%TYPE;
    L_V_MAX_PORT_SEQ      ITP063.VVPCSQ%TYPE;
    L_V_POL_PCSQ          BOOKING_VOYAGE_ROUTING_DTL.POL_PCSQ%TYPE;
    L_V_ERROR             VARCHAR2(4000);
    NEXT_VOYAGE_NOT_FOUND EXCEPTION;
    ORACLE_EXCEPTION EXCEPTION;

    TRUE  CONSTANT VARCHAR2(5) DEFAULT 'true';
    FALSE CONSTANT VARCHAR2(5) DEFAULT 'false';

    C PLS_INTEGER := 0;

    TYPE TABLERECORD IS RECORD(
       BOOKING_NO        VASAPPS.TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE
      ,DISCHARGE_LIST_ID VASAPPS.TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID%TYPE);

    TYPE CHECKED_BOOKING_TABLE IS TABLE OF TABLERECORD INDEX BY BINARY_INTEGER;

    I                         INTEGER := 0;
    L_V_CHECKED_BOOKING_TABLE CHECKED_BOOKING_TABLE;
    IS_NEED_NEXT_VOYAGE_CHECK VARCHAR2(5) := FALSE;
    IS_ACTVOY_NXT_VOY_SAME    VARCHAR2(5) := FALSE;
    IS_PORT_FOUND_IN_NXT_VOY  VARCHAR2(5) := FALSE;
    IS_BOOKING_ROB            VARCHAR2(5) := FALSE;
    L_V_DISCHARGE_LIST        VARCHAR2(15);

  BEGIN

    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    P_O_V_FLAG   := 'D';

    IF (L_V_CHECKED_BOOKING_TABLE.COUNT <> 0) THEN

      ---------------- check booking already checked or not
      FOR I IN 1 .. L_V_CHECKED_BOOKING_TABLE.COUNT
      LOOP
        IF (P_I_V_BOOKING = L_V_CHECKED_BOOKING_TABLE(I).BOOKING_NO) THEN
          DBMS_OUTPUT.PUT_LINE(L_V_CHECKED_BOOKING_TABLE(I).BOOKING_NO);
          L_V_DISCHARGE_LIST := L_V_CHECKED_BOOKING_TABLE(I).BOOKING_NO;
          -- RETURN;
          EXIT;
        END IF;

      END LOOP;
    END IF;

    ---------------- get discharge list
    IS_NEED_NEXT_VOYAGE_CHECK := FALSE;
    IS_ACTVOY_NXT_VOY_SAME    := FALSE;
    IS_PORT_FOUND_IN_NXT_VOY  := FALSE;
    IS_BOOKING_ROB            := FALSE;

    ---------------- check need to check next voyage or not.
    BEGIN
      SELECT TRUE
            ,VOYNO
            ,ACT_VOYAGE_NUMBER
            ,VESSEL
            ,LOAD_PORT
            ,POL_PCSQ
        INTO IS_NEED_NEXT_VOYAGE_CHECK
            ,L_V_VOYAGE
            ,L_V_ACT_VOYAGE_NUMBER
            ,L_V_VESSEL
            ,L_V_LOAD_PORT
            ,L_V_POL_PCSQ
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE
      --            BOOKING_NO = L_CUR_DETAIL.DL_FK_BOOKING_NO
       BOOKING_NO = P_I_V_BOOKING
       AND VESSEL = P_I_V_VESSEL
      -- AND VOYNO <> ACT_VOYAGE_NUMBER
      ;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR 2: ' || SQLERRM);
    END;

    IF IS_NEED_NEXT_VOYAGE_CHECK = TRUE THEN

      L_V_LAST_PORT    := L_V_LOAD_PORT;
      L_V_MAX_PORT_SEQ := L_V_POL_PCSQ;

      LOOP
        /* find the max port sequence */
        BEGIN
          SELECT MAX(VVPCSQ)
            INTO L_V_MAX_PORT_SEQ
            FROM ITP063
           WHERE VVVERS = 99
             AND VVVESS = L_V_VESSEL
             AND VOYAGE_ID = L_V_VOYAGE
                /* AND VVPCAL    = L_V_LOAD_PORT */
             AND VVPCAL = L_V_LAST_PORT /* first time load port */
                /* AND VVPCSQ    >= L_V_POL_PCSQ */
             AND VVPCSQ >= L_V_MAX_PORT_SEQ /* first time load port seq */
             AND OMMISSION_FLAG IS NULL
             AND VVFORL IS NOT NULL;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_V_ERROR := 'MAX PORT SEQ NOT FOUND';
            RAISE NEXT_VOYAGE_NOT_FOUND;
          WHEN OTHERS THEN
            L_V_ERROR := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('ERROR 2: ' || SQLERRM);
            RAISE ORACLE_EXCEPTION;
        END;

        DBMS_OUTPUT.PUT_LINE('L_V_MAX_PORT_SEQ: ' || L_V_MAX_PORT_SEQ);

        /* find the last port using max port sequence */
        BEGIN
          SELECT VVARDT ETA
                ,VVDPDT ETD
                ,VVARTM
                ,VVDPTM
                ,VVPCAL
            INTO L_V_ITP_ETA
                ,L_V_ITP_ETD
                ,L_V_ITP_ETA_TIME
                ,L_V_ITP_ETD_TIME
                ,L_V_LAST_PORT
            FROM ITP063
           WHERE VVVERS = 99
             AND VVVESS = L_V_VESSEL
             AND VOYAGE_ID = L_V_VOYAGE
                /* AND VVPCAL    = L_V_LOAD_PORT */
                /* AND VVPCAL    = L_V_LAST_PORT */ /* first time load port */
             AND VVPCSQ = L_V_MAX_PORT_SEQ
             AND OMMISSION_FLAG IS NULL
             AND VVFORL IS NOT NULL;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_V_ERROR := 'LAST PORT NOT FOUND';
            RAISE NEXT_VOYAGE_NOT_FOUND;
          WHEN OTHERS THEN
            L_V_ERROR := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('ERROR 3: ' || SQLERRM);
            RAISE ORACLE_EXCEPTION;

        END;

        DBMS_OUTPUT.PUT_LINE('last port of current voyage: ' ||
                             L_V_LAST_PORT);

        /* find the next voyage using the last port */
        BEGIN
          DBMS_OUTPUT.PUT_LINE(L_V_VESSEL || '~' || L_V_LAST_PORT || '~' ||
                               L_DT_BAYPLAN || '~' || L_V_ITP_ETA ||
                               LPAD(L_V_ITP_ETA_TIME, 4, '0') || '~' ||
                               L_V_ITP_ETD ||
                               LPAD(L_V_ITP_ETD_TIME, 4, '0'));

          /* this sql gives first port of the voyage */
          SELECT VOYAGE_ID
                ,VVARDT ETA
                ,VVDPDT ETD
                ,VVARTM
                ,VVDPTM
                ,VVPCAL
                ,VVPCSQ
            INTO L_V_VOYAGE
                ,L_V_ITP_ETA
                ,L_V_ITP_ETD
                ,L_V_ITP_ETA_TIME
                ,L_V_ITP_ETD_TIME
                ,L_V_LAST_PORT
                ,L_V_MAX_PORT_SEQ
          -- L_V_PORT,
          -- L_V_PORT_SEQ
            FROM (SELECT ROW_NUMBER() OVER(ORDER BY TO_DATE(VVARDT || LPAD(VVARTM, 4, '0'), 'YYYYMMDDHH24MI')) R
                        ,VOYAGE_ID
                        ,VVARDT
                        ,VVDPDT
                        ,VVARTM
                        ,VVDPTM
                        ,VVPCAL
                        ,VVPCSQ
                    FROM ITP063
                   WHERE VVVERS = 99
                     AND VVVESS = L_V_VESSEL
                     AND (TO_DATE(VVDPDT || LPAD(VVDPTM, 4, '0'),
                                  'YYYYMMDDHH24MI') >
                         TO_DATE(L_V_ITP_ETD ||
                                  LPAD(L_V_ITP_ETD_TIME, 4, '0'),
                                  'YYYYMMDDHH24MI'))
                        -- 20130217
                     AND OMMISSION_FLAG IS NULL
                     AND VVFORL IS NOT NULL)
           WHERE R = 1;

          -- DBMS_OUTPUT.PUT_LINE('itp date');
          -- DBMS_OUTPUT.PUT_LINE(VVDPDT||' '|| VVDPTM);

          DBMS_OUTPUT.PUT_LINE('for voyage etd date');
          DBMS_OUTPUT.PUT_LINE(L_V_ITP_ETD || ' ' || L_V_ITP_ETD_TIME);

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_V_ERROR := 'NEXT VOYAGE NOT FOUND';

            RAISE NEXT_VOYAGE_NOT_FOUND;
          WHEN OTHERS THEN
            L_V_ERROR := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('ERROR 5: ' || SQLERRM);
            RAISE ORACLE_EXCEPTION;

        END;

        DBMS_OUTPUT.PUT_LINE('next voyage: ' || L_V_VOYAGE);

        /* check the next voyage and actual voyage of the booking
        is same or not */

        IF L_V_ACT_VOYAGE_NUMBER = L_V_VOYAGE THEN
          IS_ACTVOY_NXT_VOY_SAME := TRUE;
        ELSE
          IS_ACTVOY_NXT_VOY_SAME := FALSE;
        END IF;

        IS_PORT_FOUND_IN_NXT_VOY := FALSE;

        /* find the discharge list id here*/
        BEGIN
          DBMS_OUTPUT.PUT_LINE(P_I_V_VESSEL || '~' || L_V_LOAD_PORT || '~' ||
                               L_V_VOYAGE || '~' || P_I_V_BOOKING);

          ----------- find next discharge list.
          SELECT BD.FK_DISCHARGE_LIST_ID
            INTO L_V_DISCHARGE_LIST
            FROM VASAPPS.TOS_DL_DISCHARGE_LIST   DL
                ,VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
           WHERE DL.FK_VESSEL = P_I_V_VESSEL
             AND BD.DN_POL = L_V_LOAD_PORT
             AND DL.FK_VOYAGE = L_V_VOYAGE
             AND BD.FK_DISCHARGE_LIST_ID = DL.PK_DISCHARGE_LIST_ID
                --                    AND BD.FK_BOOKING_NO        = L_CUR_DETAIL.DL_FK_BOOKING_NO
             AND BD.FK_BOOKING_NO = P_I_V_BOOKING
             AND BD.RECORD_STATUS = 'A'
             AND BD.RECORD_STATUS = 'A'
             AND ROWNUM = 1;

          ----------- discharge list found exit the loop
          EXIT;
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE('discharge list not found');
        END;

        /* when actual voyage and last port voyage is same
        means it is the last voyage so no need to find
        the next voyage */
        IF IS_ACTVOY_NXT_VOY_SAME = TRUE THEN
          EXIT; /* exit from inner loop */
        END IF;

        C := C + 1;

        IF C > 3 THEN
          EXIT;
        END IF;
      END LOOP; /* INNER LOOP */
    END IF;

    DBMS_OUTPUT.PUT_LINE('DISCAHRGE LIST ID');
    DBMS_OUTPUT.PUT_LINE(L_V_DISCHARGE_LIST);

    BEGIN
      SELECT PK_BOOKED_DISCHARGE_ID
        INTO P_O_V_BOOKED_DIS_ID
        FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE
       WHERE FK_DISCHARGE_LIST_ID = L_V_DISCHARGE_LIST
         AND DN_EQUIPMENT_NO = P_I_V_EQUIPMENT
         AND RECORD_STATUS = 'A';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Not found container in discharge list.');
    END;

    DBMS_OUTPUT.PUT_LINE(P_O_V_BOOKED_DIS_ID);

  EXCEPTION
    WHEN OTHERS THEN
      -- P_O_V_ERR_CD := SQLERRM;
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END PRE_FIND_DISCHARGE_LIST;
  /* *23 end * */
  /* *24 start * */
  PROCEDURE PRE_ELL_OL_VAL_PORT_CLASS_TYPE(P_I_V_PORT_CODE       VARCHAR2
                                          ,P_I_V_PORT_CLASS_TYPE VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO    VARCHAR2
                                          ,P_O_V_ERR_CD          OUT VARCHAR2) AS
    L_REC_COUNT         NUMBER := 0;
    L_V_PORT_CODE       PORT_CLASS_TYPE.PORT_CODE%TYPE;
    L_V_PORT_CLASS_TYPE PORT_CLASS.PORT_CLASS_TYPE%TYPE;

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    L_V_PORT_CODE       := LOWER(P_I_V_PORT_CODE);
    L_V_PORT_CLASS_TYPE := LOWER(P_I_V_PORT_CLASS_TYPE);

    IF L_V_PORT_CLASS_TYPE IS NOT NULL THEN

      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM PORT_CLASS_TYPE PCT
       WHERE LOWER(PCT.PORT_CODE) = L_V_PORT_CODE
         AND LOWER(PCT.PORT_CLASS_TYPE) = L_V_PORT_CLASS_TYPE;

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'ELL.SE0134' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
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

  END;
  /* *24 end * */
  /* *26 start * */
  PROCEDURE PRE_LOG_PORTCLASS_CHANGE(P_I_V_BOOKED_LL_DL_ID     NUMBER
                                    ,P_I_V_PORT_CLASS          VARCHAR
                                    ,P_I_V_IMDG                VARCHAR
                                    ,P_I_V_UNNO                VARCHAR
                                    ,P_I_V_UN_VAR              VARCHAR
                                    ,P_I_V_LOAD_DISCHARGE_FLAG VARCHAR
                                    ,P_I_V_USER_ID             VARCHAR) AS
    L_IMDG           TOS_LL_BOOKED_LOADING.FK_IMDG%TYPE;
    L_UNNO           TOS_LL_BOOKED_LOADING.FK_UNNO%TYPE;
    L_UN_VAR         TOS_LL_BOOKED_LOADING.FK_UN_VAR%TYPE;
    L_PORT_CLASS_TYP TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP%TYPE;
    L_PORT_CLASS     VARCHAR2(5);
    L_EQUIPMENT_NO   VARCHAR2(20);
    L_BOOKING_NO     VARCHAR2(20);

  BEGIN
    IF (P_I_V_LOAD_DISCHARGE_FLAG = 'L') THEN
      SELECT FK_IMDG
            ,FK_UNNO
            ,FK_UN_VAR
            ,FK_PORT_CLASS
            ,FK_PORT_CLASS_TYP
            ,FK_BOOKING_NO
            ,DN_EQUIPMENT_NO
        INTO L_IMDG
            ,L_UNNO
            ,L_UN_VAR
            ,L_PORT_CLASS
            ,L_PORT_CLASS_TYP
            ,L_BOOKING_NO
            ,L_EQUIPMENT_NO
        FROM TOS_LL_BOOKED_LOADING
       WHERE PK_BOOKED_LOADING_ID = P_I_V_BOOKED_LL_DL_ID;
    ELSE
      SELECT FK_IMDG
            ,FK_UNNO
            ,FK_UN_VAR
            ,FK_PORT_CLASS
            ,FK_PORT_CLASS_TYP
            ,FK_BOOKING_NO
            ,DN_EQUIPMENT_NO
        INTO L_IMDG
            ,L_UNNO
            ,L_UN_VAR
            ,L_PORT_CLASS
            ,L_PORT_CLASS_TYP
            ,L_BOOKING_NO
            ,L_EQUIPMENT_NO
        FROM TOS_DL_BOOKED_DISCHARGE
       WHERE PK_BOOKED_DISCHARGE_ID = P_I_V_BOOKED_LL_DL_ID;
    END IF;
    IF ((P_I_V_PORT_CLASS <> L_PORT_CLASS) OR (P_I_V_IMDG <> L_IMDG) OR
       (P_I_V_UNNO <> L_UNNO) OR (P_I_V_UN_VAR <> L_UN_VAR)) THEN
      PRE_LOG_INFO('PCE_ELL_LLMAINTENANCE.PRE_LOG_PORTCLASS_CHANGE',
                   'PRE_LOG_PORTCLASS_CHANGE',
                   NULL,
                   P_I_V_USER_ID,
                   SYSDATE,
                   'Old Port Class value: ' || L_PORT_CLASS || ' ' ||
                   'New Port Class value: ' || P_I_V_PORT_CLASS || ' ' ||
                   'P_I_V_BOOKED_LL_DL_ID: ' || P_I_V_BOOKED_LL_DL_ID || ' ' ||
                   'P_I_V_LOAD_DISCHARGE_FLAG: ' ||
                   P_I_V_LOAD_DISCHARGE_FLAG || ' ' || 'EQUIPMENT NO: ' ||
                   L_EQUIPMENT_NO || ' ' || 'BOOKING NO: ' || L_BOOKING_NO || ' ' ||
                   'fk_imdg: ' || L_IMDG || ' ' || 'fk_unno: ' || L_UNNO || ' ' ||
                   'fk_un_var: ' || L_UN_VAR,
                   NULL,
                   NULL,
                   NULL);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END PRE_LOG_PORTCLASS_CHANGE;
  /* *26 end * */

  PROCEDURE PRE_ELL_BOOKED_SUMMARY(P_O_REFBOOKEDTABSUMMARY OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                  ,P_I_V_LOAD_LIST_ID      IN VARCHAR2
                                  ,P_O_V_ERROR             OUT VARCHAR2) AS
  BEGIN
    P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    OPEN P_O_REFBOOKEDTABSUMMARY FOR

      SELECT FK_LOAD_LIST_ID
            ,LOADING_STATUS
            ,CRANE_TYPE
            ,FK_SLOT_OPERATOR
            ,DN_SHIPMENT_TERM
            ,DN_SOC_COC
            ,LOCAL_STATUS
            ,MIDSTREAM_HANDLING_CODE
            ,DN_FULL_MT
            ,DN_SHIPMENT_TYP
            ,DN_SPECIAL_HNDL
            ,DN_EQ_SIZE
            ,DN_EQ_TYPE
            ,COUNT(*) COUNT
        FROM TOS_LL_BOOKED_LOADING DTL
            ,TOS_LL_LOAD_LIST      HDR
       WHERE HDR.PK_LOAD_LIST_ID = DTL.FK_LOAD_LIST_ID
         AND FK_LOAD_LIST_ID = '244'
       GROUP BY LOADING_STATUS
               ,CRANE_TYPE
               ,FK_SLOT_OPERATOR
               ,DN_SHIPMENT_TERM
               ,DN_SOC_COC
               ,LOCAL_STATUS
               ,MIDSTREAM_HANDLING_CODE
               ,DN_FULL_MT
               ,DN_SHIPMENT_TYP
               ,DN_SPECIAL_HNDL
               ,DN_EQ_SIZE
               ,DN_EQ_TYPE
               ,FK_LOAD_LIST_ID;

  END PRE_ELL_BOOKED_SUMMARY;

 /* PROCEDURE PRE_ELL_VALID_PLACE_DELV(P_I_V_PORT_CODE       VARCHAR2
                                    ,P_I_V_PORT_CLASS_TYPE VARCHAR2
                                    ,P_O_V_ERR_CD          OUT VARCHAR2
                                    ) AS
    L_REC_COUNT   NUMBER := 0;
    L_V_PORT_CODE EZLL_GBL_PORT_MASTER.PORT_CODE%TYPE;

  BEGIN
    P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    L_V_PORT_CODE := LOWER(P_I_V_PORT_CODE);

    IF L_V_PORT_CODE IS NOT NULL THEN

      SELECT COUNT(1)
        INTO L_REC_COUNT
        FROM EZLL_GBL_PORT_MASTER EZLL
       WHERE LOWER(EZLL.PORT_CODE) = L_V_PORT_CODE;

      IF (L_REC_COUNT < 1) THEN
        P_O_V_ERR_CD := 'ELL.SE0134' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                        P_I_V_PORT_CLASS_TYPE ||
                        PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RETURN;
      END IF;
    END IF;

  EXCEPTION

    WHEN OTHERS THEN
      P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
                      PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
                      SUBSTR(SQLCODE, 1, 10) || ':' ||
                      SUBSTR(SQLERRM, 1, 100);

  END; */

 END PCE_ELL_LLMAINTENANCE;