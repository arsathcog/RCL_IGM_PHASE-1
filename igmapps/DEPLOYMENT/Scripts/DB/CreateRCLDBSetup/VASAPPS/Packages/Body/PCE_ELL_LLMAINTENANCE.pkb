create or replace
PACKAGE BODY                                         PCE_ELL_LLMAINTENANCE AS
    g_v_sql                           VARCHAR2(10000);
    glob_exception                    EXCEPTION;
    g_v_ora_err_cd                    VARCHAR2(10);
    g_v_user_err_cd                   VARCHAR2(10);
    l_excp_finish                     EXCEPTION;
    g_v_warning                       VARCHAR2(100);
    l_duplicate_stow_excption         EXCEPTION; -- *10
    G_V_DUPLICATE_STOW_ERR            VARCHAR2(4000); -- *10, *12

    C_OPEN                            VARCHAR2(2) DEFAULT '0';
    LOADING_COMPLETE                  VARCHAR2(2) DEFAULT '10';
    READY_FOR_INVOICE                 VARCHAR2(2) DEFAULT '20';
    WORK_COMPLETE                     VARCHAR2(2) DEFAULT '30';
    LL_DL_FLAG                        VARCHAR2(1) DEFAULT 'L';
    BLANK                              CONSTANT VARCHAR2(1) DEFAULT NULL; --*18

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
             System need to check if there’s the bundle booking then, Check the
             configuration table to check the type of bundle calculation/terminal,
             If no terminal found or it’s not = "EBP" then sytem need to check that
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
 */
    g_v_load_list_id       TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE; -- *4
   PROCEDURE PRV_ELL_SET_BOOKING_TO_TEMP (
         p_i_v_session_id       IN  VARCHAR2
        ,p_i_v_load_list_id     IN  VARCHAR2
        ,p_i_v_user_id          IN  VARCHAR2
        ,p_o_v_err_cd           OUT VARCHAR2
    ) AS

    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        DELETE FROM TOS_LL_BOOKED_LOADING_TMP
        WHERE SESSION_ID = p_i_v_session_id;

        INSERT INTO TOS_LL_BOOKED_LOADING_TMP
            (
              SEQ_NO
            , SESSION_ID
            , PK_BOOKED_LOADING_ID
            , FK_LOAD_LIST_ID
            , CONTAINER_SEQ_NO
            , FK_BOOKING_NO
            , FK_BKG_SIZE_TYPE_DTL
            , FK_BKG_SUPPLIER
            , FK_BKG_EQUIPM_DTL
            , DN_EQUIPMENT_NO
            , EQUPMENT_NO_SOURCE
            , FK_BKG_VOYAGE_ROUTING_DTL
            , DN_EQ_SIZE
            , DN_EQ_TYPE
            , DN_FULL_MT
            , DN_BKG_TYP
            , DN_SOC_COC
            , DN_SHIPMENT_TERM
            , DN_SHIPMENT_TYP
            , LOCAL_STATUS
            , LOCAL_TERMINAL_STATUS
            , MIDSTREAM_HANDLING_CODE
            , LOAD_CONDITION
            , LOADING_STATUS
            , STOWAGE_POSITION
            , ACTIVITY_DATE_TIME
            , CONTAINER_GROSS_WEIGHT
            , DAMAGED
            , VOID_SLOT
            , PREADVICE_FLAG
            , FK_SLOT_OPERATOR
            , FK_CONTAINER_OPERATOR
            , OUT_SLOT_OPERATOR
            , DN_SPECIAL_HNDL
            , SEAL_NO
            , DN_DISCHARGE_PORT
            , DN_DISCHARGE_TERMINAL
            , DN_NXT_POD1
            , DN_NXT_POD2
            , DN_NXT_POD3
            , DN_FINAL_POD
            , FINAL_DEST
            , DN_NXT_SRV
            , DN_NXT_VESSEL
            , DN_NXT_VOYAGE
            , DN_NXT_DIR
            , MLO_VESSEL
            , MLO_VOYAGE
            , MLO_VESSEL_ETA
            , MLO_POD1
            , MLO_POD2
            , MLO_POD3
            , MLO_DEL
            , EX_MLO_VESSEL
            , EX_MLO_VESSEL_ETA
            , EX_MLO_VOYAGE
            , FK_HANDLING_INSTRUCTION_1
            , FK_HANDLING_INSTRUCTION_2
            , FK_HANDLING_INSTRUCTION_3
            , CONTAINER_LOADING_REM_1
            , CONTAINER_LOADING_REM_2
            , FK_SPECIAL_CARGO
            , TIGHT_CONNECTION_FLAG1
            , TIGHT_CONNECTION_FLAG2
            , TIGHT_CONNECTION_FLAG3
            , FK_IMDG
            , FK_UNNO
            , FK_UN_VAR
            , FK_PORT_CLASS
            , FK_PORT_CLASS_TYP
            , FLASH_UNIT
            , FLASH_POINT
            , FUMIGATION_ONLY
            , RESIDUE_ONLY_FLAG
            , OVERHEIGHT_CM
            , OVERWIDTH_LEFT_CM
            , OVERWIDTH_RIGHT_CM
            , OVERLENGTH_FRONT_CM
            , OVERLENGTH_REAR_CM
            , REEFER_TMP
            , REEFER_TMP_UNIT
            , DN_HUMIDITY
            , DN_VENTILATION
            , PUBLIC_REMARK
            , CRANE_TYPE -- *8
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE
            )
            (SELECT ROW_NUMBER() OVER (ORDER BY PK_BOOKED_LOADING_ID)
            , p_i_v_session_id
            , PK_BOOKED_LOADING_ID
            , FK_LOAD_LIST_ID
            , CONTAINER_SEQ_NO
            , FK_BOOKING_NO
            , FK_BKG_SIZE_TYPE_DTL
            , FK_BKG_SUPPLIER
            , FK_BKG_EQUIPM_DTL
            , DN_EQUIPMENT_NO
            , EQUPMENT_NO_SOURCE
            , FK_BKG_VOYAGE_ROUTING_DTL
            , DN_EQ_SIZE
            , DN_EQ_TYPE
            , DN_FULL_MT
            , DN_BKG_TYP
            , DN_SOC_COC
            , DN_SHIPMENT_TERM
            , DN_SHIPMENT_TYP
            , LOCAL_STATUS
            , LOCAL_TERMINAL_STATUS
            , MIDSTREAM_HANDLING_CODE
            , LOAD_CONDITION
            , LOADING_STATUS
            , STOWAGE_POSITION
            , TO_CHAR(ACTIVITY_DATE_TIME,'DD/MM/YYYY HH24:MI')
            , CONTAINER_GROSS_WEIGHT
            , DAMAGED
            , VOID_SLOT
            , PREADVICE_FLAG
            , FK_SLOT_OPERATOR
            , FK_CONTAINER_OPERATOR
            , OUT_SLOT_OPERATOR
            , DN_SPECIAL_HNDL
            , SEAL_NO
            , DN_DISCHARGE_PORT
            , DN_DISCHARGE_TERMINAL
            , DN_NXT_POD1
            , DN_NXT_POD2
            , DN_NXT_POD3
            , DN_FINAL_POD
            , FINAL_DEST
            , DN_NXT_SRV
            , DN_NXT_VESSEL
            , DN_NXT_VOYAGE
            , DN_NXT_DIR
            , MLO_VESSEL
            , MLO_VOYAGE
            , TO_CHAR(MLO_VESSEL_ETA,'DD/MM/YYYY HH24:MI')
            , MLO_POD1
            , MLO_POD2
            , MLO_POD3
            , MLO_DEL
            , EX_MLO_VESSEL
            , TO_CHAR(EX_MLO_VESSEL_ETA,'DD/MM/YYYY HH24:MI')
            , EX_MLO_VOYAGE
            , FK_HANDLING_INSTRUCTION_1
            , FK_HANDLING_INSTRUCTION_2
            , FK_HANDLING_INSTRUCTION_3
            , CONTAINER_LOADING_REM_1
            , CONTAINER_LOADING_REM_2
            , FK_SPECIAL_CARGO
            , TIGHT_CONNECTION_FLAG1
            , TIGHT_CONNECTION_FLAG2
            , TIGHT_CONNECTION_FLAG3
            , FK_IMDG
            , FK_UNNO
            , FK_UN_VAR
            , FK_PORT_CLASS
            , FK_PORT_CLASS_TYP
            , FLASH_UNIT
            , FLASH_POINT
            , FUMIGATION_ONLY
            , RESIDUE_ONLY_FLAG
            , OVERHEIGHT_CM
            , OVERWIDTH_LEFT_CM
            , OVERWIDTH_RIGHT_CM
            , OVERLENGTH_FRONT_CM
            , OVERLENGTH_REAR_CM
            , REEFER_TMP
            , REEFER_TMP_UNIT
            , DN_HUMIDITY
            , DN_VENTILATION
            , PUBLIC_REMARK
             ,CRANE_TYPE -- *8
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE
             FROM   TOS_LL_BOOKED_LOADING
             WHERE  FK_LOAD_LIST_ID = p_i_v_load_list_id
             AND    RECORD_STATUS   = 'A'
             )ORDER BY PK_BOOKED_LOADING_ID;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END PRV_ELL_SET_BOOKING_TO_TEMP;


   PROCEDURE PRV_ELL_SET_OVERSHIP_TO_TEMP (
         p_i_v_session_id       IN  VARCHAR2
        ,p_i_v_load_list_id     IN  VARCHAR2
        ,p_i_v_user_id          IN  VARCHAR2
        ,p_o_v_err_cd           OUT VARCHAR2
    ) AS

    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        DELETE FROM TOS_LL_OVERSHIPPED_CONT_TMP
        WHERE SESSION_ID = p_i_v_session_id;

        INSERT INTO TOS_LL_OVERSHIPPED_CONT_TMP
            (
              SEQ_NO
            , SESSION_ID
            , PK_OVERSHIPPED_CONTAINER_ID
            , FK_LOAD_LIST_ID
            , BOOKING_NO
            , BOOKING_NO_SOURCE
            , EQUIPMENT_NO
            , EQUIPMENT_NO_QUESTIONABLE_FLAG
            , EQ_SIZE
            , EQ_TYPE
            , FULL_MT
            , BKG_TYP
            , FLAG_SOC_COC
            , SHIPMENT_TERM
            , SHIPMENT_TYPE
            , LOCAL_STATUS
            , LOCAL_TERMINAL_STATUS
            , MIDSTREAM_HANDLING_CODE
            , LOAD_CONDITION
            , STOWAGE_POSITION
            , ACTIVITY_DATE_TIME
            , CONTAINER_GROSS_WEIGHT
            , DAMAGED
            , VOID_SLOT
            , PREADVICE_FLAG
            , SLOT_OPERATOR
            , CONTAINER_OPERATOR
            , OUT_SLOT_OPERATOR
            , SPECIAL_HANDLING
            , SEAL_NO
            , DISCHARGE_PORT
            , POD_TERMINAL
            , NXT_POD1
            , NXT_POD2
            , NXT_POD3
            , FINAL_POD
            , FINAL_DEST
            , NXT_SRV
            , NXT_VESSEL
            , NXT_VOYAGE
            , NXT_DIR
            , MLO_VESSEL
            , MLO_VOYAGE
            , MLO_VESSEL_ETA
            , MLO_POD1
            , MLO_POD2
            , MLO_POD3
            , MLO_DEL
            , EX_MLO_VESSEL
            , EX_MLO_VESSEL_ETA
            , EX_MLO_VOYAGE
            , HANDLING_INSTRUCTION_1
            , HANDLING_INSTRUCTION_2
            , HANDLING_INSTRUCTION_3
            , CONTAINER_LOADING_REM_1
            , CONTAINER_LOADING_REM_2
            , SPECIAL_CARGO
            , IMDG_CLASS
            , UN_NUMBER
            , UN_NUMBER_VARIANT
            , PORT_CLASS
            , PORT_CLASS_TYPE
            , FLASHPOINT_UNIT
            , FLASHPOINT
            , FUMIGATION_ONLY
            , RESIDUE_ONLY_FLAG
            , OVERHEIGHT_CM
            , OVERWIDTH_LEFT_CM
            , OVERWIDTH_RIGHT_CM
            , OVERLENGTH_FRONT_CM
            , OVERLENGTH_REAR_CM
            , REEFER_TEMPERATURE
            , REEFER_TMP_UNIT
            , HUMIDITY
            , VENTILATION
            , DA_ERROR
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE
            )
            (SELECT ROW_NUMBER() OVER (ORDER BY PK_OVERSHIPPED_CONTAINER_ID)
            , p_i_v_session_id
            , PK_OVERSHIPPED_CONTAINER_ID
            , FK_LOAD_LIST_ID
            , BOOKING_NO
            , BOOKING_NO_SOURCE
            , EQUIPMENT_NO
            , EQUIPMENT_NO_QUESTIONABLE_FLAG
            , EQ_SIZE
            , EQ_TYPE
            , FULL_MT
            , BKG_TYP
            , FLAG_SOC_COC
            , SHIPMENT_TERM
            , SHIPMENT_TYPE
            , LOCAL_STATUS
            , LOCAL_TERMINAL_STATUS
            , MIDSTREAM_HANDLING_CODE
            , LOAD_CONDITION
            , STOWAGE_POSITION
            , TO_CHAR(ACTIVITY_DATE_TIME,'DD/MM/YYYY HH24:MI')
            , CONTAINER_GROSS_WEIGHT
            , DAMAGED
            , VOID_SLOT
            , PREADVICE_FLAG
            , SLOT_OPERATOR
            , CONTAINER_OPERATOR
            , OUT_SLOT_OPERATOR
            , SPECIAL_HANDLING
            , SEAL_NO
            , DISCHARGE_PORT
            , POD_TERMINAL
            , NXT_POD1
            , NXT_POD2
            , NXT_POD3
            , FINAL_POD
            , FINAL_DEST
            , NXT_SRV
            , NXT_VESSEL
            , NXT_VOYAGE
            , NXT_DIR
            , MLO_VESSEL
            , MLO_VOYAGE
            , TO_CHAR(MLO_VESSEL_ETA,'DD/MM/YYYY HH24:MI')
            , MLO_POD1
            , MLO_POD2
            , MLO_POD3
            , MLO_DEL
            , EX_MLO_VESSEL
            , TO_CHAR(EX_MLO_VESSEL_ETA,'DD/MM/YYYY HH24:MI')
            , EX_MLO_VOYAGE
            , HANDLING_INSTRUCTION_1
            , HANDLING_INSTRUCTION_2
            , HANDLING_INSTRUCTION_3
            , CONTAINER_LOADING_REM_1
            , CONTAINER_LOADING_REM_2
            , SPECIAL_CARGO
            , IMDG_CLASS
            , UN_NUMBER
            , UN_NUMBER_VARIANT
            , PORT_CLASS
            , PORT_CLASS_TYPE
            , FLASHPOINT_UNIT
            , FLASHPOINT
            , FUMIGATION_ONLY
            , RESIDUE_ONLY_FLAG
            , OVERHEIGHT_CM
            , OVERWIDTH_LEFT_CM
            , OVERWIDTH_RIGHT_CM
            , OVERLENGTH_FRONT_CM
            , OVERLENGTH_REAR_CM
            , REEFER_TEMPERATURE
            , REEFER_TMP_UNIT
            , HUMIDITY
            , VENTILATION
            , DA_ERROR
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE
             FROM   TOS_LL_OVERSHIPPED_CONTAINER
             WHERE  FK_LOAD_LIST_ID = p_i_v_load_list_id
             AND    RECORD_STATUS = 'A'
             )ORDER BY PK_OVERSHIPPED_CONTAINER_ID;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END PRV_ELL_SET_OVERSHIP_TO_TEMP;


   PROCEDURE PRV_ELL_SET_RESTOW_TO_TEMP (
         p_i_v_session_id       IN  VARCHAR2
        ,p_i_v_load_list_id     IN  VARCHAR2
        ,p_i_v_user_id          IN  VARCHAR2
        ,p_o_v_err_cd           OUT VARCHAR2
    ) AS

    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        DELETE FROM TOS_RESTOW_TMP
        WHERE SESSION_ID = p_i_v_session_id;

        INSERT INTO TOS_RESTOW_TMP
            (
            SEQ_NO,
            SESSION_ID,
            PK_RESTOW_ID,
            FK_LOAD_LIST_ID,
            FK_DISCHARGE_LIST_ID,
            FK_BOOKING_NO,
            FK_BKG_SIZE_TYPE_DTL,
            FK_BKG_SUPPLIER,
            FK_BKG_EQUIPM_DTL,
            DN_EQUIPMENT_NO,
            DN_EQ_SIZE,
            DN_EQ_TYPE,
            DN_SOC_COC,
            DN_SHIPMENT_TERM,
            DN_SHIPMENT_TYP,
            MIDSTREAM_HANDLING_CODE,
            LOAD_CONDITION,
            RESTOW_STATUS,
            STOWAGE_POSITION,
            ACTIVITY_DATE_TIME,
            CONTAINER_GROSS_WEIGHT,
            DAMAGED,
            VOID_SLOT,
            FK_SLOT_OPERATOR,
            FK_CONTAINER_OPERATOR,
            DN_SPECIAL_HNDL,
            SEAL_NO,
            FK_SPECIAL_CARGO,
            PUBLIC_REMARK,
            RECORD_CHANGE_USER,
            RECORD_CHANGE_DATE
            )
            (
            SELECT  ROW_NUMBER() OVER (ORDER BY PK_RESTOW_ID),
                    p_i_v_session_id,
                    PK_RESTOW_ID,
                    FK_LOAD_LIST_ID,
                    FK_DISCHARGE_LIST_ID,
                    FK_BOOKING_NO,
                    FK_BKG_SIZE_TYPE_DTL,
                    FK_BKG_SUPPLIER,
                    FK_BKG_EQUIPM_DTL,
                    DN_EQUIPMENT_NO,
                    DN_EQ_SIZE,
                    DN_EQ_TYPE,
                    DN_SOC_COC,
                    DN_SHIPMENT_TERM,
                    DN_SHIPMENT_TYP,
                    MIDSTREAM_HANDLING_CODE,
                    LOAD_CONDITION,
                    RESTOW_STATUS,
                    STOWAGE_POSITION,
                    TO_CHAR(ACTIVITY_DATE_TIME,'DD/MM/YYYY HH24:MI'),
                    CONTAINER_GROSS_WEIGHT,
                    DAMAGED,
                    VOID_SLOT,
                    FK_SLOT_OPERATOR,
                    FK_CONTAINER_OPERATOR,
                    DN_SPECIAL_HNDL,
                    SEAL_NO,
                    FK_SPECIAL_CARGO,
                    PUBLIC_REMARK,
                    RECORD_CHANGE_USER,
                    RECORD_CHANGE_DATE
             FROM   TOS_RESTOW
             WHERE  FK_LOAD_LIST_ID = p_i_v_load_list_id
             AND    RECORD_STATUS = 'A'
             )ORDER BY PK_RESTOW_ID;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END PRV_ELL_SET_RESTOW_TO_TEMP;


    PROCEDURE PRV_ELL_CLR_TMP(
          p_i_v_session_id     IN  VARCHAR2
        , p_i_v_user_id        IN  VARCHAR2
        , p_o_v_err_cd         OUT VARCHAR2
      ) AS
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        DELETE FROM TOS_LL_BOOKED_LOADING_TMP
        WHERE SESSION_ID = p_i_v_session_id;

    DELETE FROM TOS_LL_OVERSHIPPED_CONT_TMP
        WHERE SESSION_ID = p_i_v_session_id;

    DELETE FROM TOS_RESTOW_TMP
        WHERE SESSION_ID = p_i_v_session_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
    END PRV_ELL_CLR_TMP;

    PROCEDURE PRE_ELL_BOOKED_TAB_FIND(
          p_o_refBookedTabFind      OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_session_id          IN  VARCHAR2
        , p_i_v_find1               IN  VARCHAR2
        , p_i_v_in1                 IN  VARCHAR2
        , p_i_v_find2               IN  VARCHAR2
        , p_i_v_in2                 IN  VARCHAR2
        , p_i_v_order1              IN  VARCHAR2
        , p_i_v_order1order         IN  VARCHAR2
        , p_i_v_order2              IN  VARCHAR2
        , p_i_v_order2order         IN  VARCHAR2
        , p_i_v_load_list_id        IN  VARCHAR2
        , p_o_v_tot_rec             OUT VARCHAR2
        , p_o_v_error               OUT VARCHAR2
    )  AS

        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_err   varchar2(5000);
        /* Open if required for debugging
        l_v_SQL_1 varchar2(4000);
        l_v_SQL_2 varchar2(4000);
        l_v_SQL_3 varchar2(4000);
        */
    BEGIN

        /* Set Success Code*/
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        /* Set Total Record to Default -1  */
        p_o_v_tot_rec  := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

        /*
            *4: Reset value of globle discharge list variable
        */
        g_v_load_list_id := p_i_v_load_list_id;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;
            -- when order1 is not not null.
            IF ( p_i_v_order1 IS NOT NULL ) THEN
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;
            -- when order2 is not not null.
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                --  when order1 is not null then add comma(,) after first order by clause.
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_LL_BOOKED_LOADING.fk_booking_no
                , TOS_LL_BOOKED_LOADING.dn_eq_size
                , TOS_LL_BOOKED_LOADING.dn_eq_type
                , TOS_LL_BOOKED_LOADING.dn_equipment_no' ;
        END IF;

        /* Construct the SQL */
       g_v_sql := ' SELECT TOS_LL_BOOKED_LOADING.SEQ_NO,
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
                   TOS_LL_BOOKED_LOADING.OPN_STATUS <> ''' || PCE_EUT_COMMON.G_V_REC_DEL || ''')
            AND   TOS_LL_BOOKED_LOADING.SESSION_ID = ''' || p_i_v_session_id || '''
            AND FK_HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
            AND FK_HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
            AND FK_HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
            AND TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID = ''' || p_i_v_load_list_id || '''';

        --Where clause conditions.
        IF(p_i_v_in1 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS(TRIM(p_i_v_in1), TRIM(p_i_v_find1), 'BOOKED_TAB'); -- added trim func. 30.01.2012
        END IF;

        IF(p_i_v_in2 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS(TRIM(p_i_v_in2), TRIM(p_i_v_find2), 'BOOKED_TAB'); -- added trim func. 30.01.2012
        END IF;

        g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

        /* Execute the SQL */
        OPEN p_o_refBookedTabFind FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                l_v_err := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(l_v_err));
    END PRE_ELL_BOOKED_TAB_FIND;


    PROCEDURE PRE_ELL_OVERSHIPPED_TAB_FIND(
          p_o_refOvershippedTabFind     OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_session_id              IN  VARCHAR2
        , p_i_v_find1                   IN  VARCHAR2
        , p_i_v_in1                     IN  VARCHAR2
        , p_i_v_find2                   IN  VARCHAR2
        , p_i_v_in2                     IN  VARCHAR2
        , p_i_v_order1                  IN  VARCHAR2
        , p_i_v_order1order             IN  VARCHAR2
        , p_i_v_order2                  IN  VARCHAR2
        , p_i_v_order2order             IN  VARCHAR2
        , p_i_v_load_list_id            IN  VARCHAR2
        , p_o_v_tot_rec                 OUT VARCHAR2
        , p_o_v_error                   OUT VARCHAR2
    ) AS
        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_err varchar2(5000);
        /* Open if required for debugging
        l_v_SQL_1 varchar2(4000);
        l_v_SQL_2 varchar2(4000);
        l_v_SQL_3 varchar2(4000);
        */

    BEGIN

        /* Set Success Code */
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        /* Set Total Record to Default -1*/
        p_o_v_tot_rec  := -1;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;

            -- when order1 is not not null.
            IF ( p_i_v_order1 IS NOT NULL ) THEN
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;

            --  when order1 is not null then add comma(,) after first order by clause.
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO
                , TOS_LL_OVERSHIPPED_CONTAINER.EQ_SIZE
                , TOS_LL_OVERSHIPPED_CONTAINER.EQ_TYPE
                , TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO' ;
        END IF;

        -- Construct the SQL
        g_v_sql := ' SELECT
            ROW_NUMBER()  OVER ('||l_v_SQL_SORT_ORDER || ') SR_NO,' ||
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
                   TOS_LL_OVERSHIPPED_CONTAINER.OPN_STATUS <> ''' || PCE_EUT_COMMON.G_V_REC_DEL || ''')
            AND    TOS_LL_OVERSHIPPED_CONTAINER.SESSION_ID = ''' || p_i_v_session_id || '''
            AND    HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
            AND    HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
            AND    HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
            AND    TOS_LL_OVERSHIPPED_CONTAINER.FK_LOAD_LIST_ID = ''' || p_i_v_load_list_id || '''';

        -- Additional where clause conditions.
        IF(p_i_v_in1 IS NOT NULL) THEN
            -- This function add the additional where clauss condtions in
            -- Dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS(TRIM(p_i_v_in1), TRIM(p_i_v_find1), 'OVERSHIPPED_TAB'); -- added trim func. 30.01.2012
        END IF;

        IF(p_i_v_in2 IS NOT NULL) THEN
            -- This function add the additional where clauss condtions in
            -- Dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS(TRIM(p_i_v_in2), TRIM(p_i_v_find2), 'OVERSHIPPED_TAB'); -- added trim func. 30.01.2012
        END IF;

        g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;


        -- Execute the SQL
        OPEN p_o_refOvershippedTabFind FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    END PRE_ELL_OVERSHIPPED_TAB_FIND;

    PROCEDURE PRE_ELL_RESTOWED_TAB_FIND  (
          p_o_refRestowedTabFind       OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_session_id             IN  VARCHAR2
        , p_i_v_find1                  IN  VARCHAR2
        , p_i_v_in1                    IN  VARCHAR2
        , p_i_v_find2                  IN  VARCHAR2
        , p_i_v_in2                    IN  VARCHAR2
        , p_i_v_order1                 IN  VARCHAR2
        , p_i_v_order1order            IN  VARCHAR2
        , p_i_v_order2                 IN  VARCHAR2
        , p_i_v_order2order            IN  VARCHAR2
        , p_i_v_load_list_id           IN  VARCHAR2
        , p_o_v_tot_rec                OUT VARCHAR2
        , p_o_v_error                  OUT VARCHAR2
    ) AS
        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        /* Open if required for debugging
        l_v_SQL_1 varchar2(4000);
        l_v_SQL_2 varchar2(4000);
        l_v_SQL_3 varchar2(4000);
        */
    BEGIN

        /* Set Success Code */
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        /* Set Total Record to Default -1  */
        p_o_v_tot_rec  := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;

            IF ( p_i_v_order1 IS NOT NULL ) THEN
                -- when order1 is not not null.
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                --  when order1 is not null then add comma(,) after first order by clause.
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_RESTOW.FK_BOOKING_NO
                , TOS_RESTOW.DN_EQ_SIZE
                , TOS_RESTOW.DN_EQ_TYPE
                , TOS_RESTOW.DN_EQUIPMENT_NO' ;
        END IF;

        /* Construct the SQL */
        g_v_sql := ' SELECT
            ROW_NUMBER()  OVER ('||l_v_SQL_SORT_ORDER || ') SR_NO,' ||
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
                   TOS_RESTOW.OPN_STATUS <> ''' || PCE_EUT_COMMON.G_V_REC_DEL || ''')
            AND    TOS_RESTOW.SESSION_ID = ''' || p_i_v_session_id || '''
            AND    TOS_RESTOW.FK_LOAD_LIST_ID = ''' || p_i_v_load_list_id || '''';

    -- Additional where clause conditions.
    IF(p_i_v_in1 IS NOT NULL) THEN
        -- this function add the additional where clauss condtions in
        -- dynamic sql according to the passed parameter.
        ADDITION_WHERE_CONDTIONS(TRIM(p_i_v_in1), TRIM(p_i_v_find1), 'RESTOW_TAB'); -- added trim func. 30.01.2012
    END IF;

    IF(p_i_v_in2 IS NOT NULL) THEN
        -- this function add the additional where clauss condtions in
        -- dynamic sql according to the passed parameter.
        ADDITION_WHERE_CONDTIONS(TRIM(p_i_v_in2), TRIM(p_i_v_find2), 'RESTOW_TAB'); -- added trim func. 30.01.2012
    END IF;

    g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;


    /* Execute the SQL */
    OPEN p_o_refRestowedTabFind FOR g_v_sql;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    END PRE_ELL_RESTOWED_TAB_FIND;

    PROCEDURE PRE_ELL_SUMMARY_TAB_FIND (
          p_o_refSummaryTabFind       OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_load_list_id          VARCHAR2
        , p_o_v_tot_rec               OUT VARCHAR2
        , p_o_v_error                 OUT VARCHAR2
        )  AS

        BEGIN
            /* Set Success Code */
            p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
            /* Set Total Record to Default -1  */
            p_o_v_tot_rec  := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

            /* Construct the SQL */
            g_v_sql :=
            'SELECT  FK_SLOT_OPERATOR
                    ,FK_CONTAINER_OPERATOR
                    ,DN_EQ_SIZE|| DN_EQ_TYPE SIZETYPE
                    ,DECODE(DN_FULL_MT, ''F'', ''FULL'', ''E'', ''EMPTY'') DN_FULL_MT
                    ,LOADING_STATUS
                    ,COUNT(DN_EQUIPMENT_NO) COUNT
                    ,(SUM(DN_EQ_SIZE)/20) NO_OF_TEU
            FROM     TOS_LL_BOOKED_LOADING
            WHERE     TOS_LL_BOOKED_LOADING.RECORD_STATUS = ''A''
            AND     FK_LOAD_LIST_ID = ''' || p_i_v_load_list_id || '''
            GROUP BY GROUPING SETS(FK_SLOT_OPERATOR,(FK_SLOT_OPERATOR,FK_CONTAINER_OPERATOR,DN_FULL_MT, DN_EQ_SIZE||DN_EQ_TYPE, DN_FULL_MT, LOADING_STATUS ),('''')) '; --*11

            /* Execute the SQL */
            OPEN p_o_refSummaryTabFind FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
    END PRE_ELL_SUMMARY_TAB_FIND;


    -- This procedure called to get additional where clause conditions.
    PROCEDURE ADDITION_WHERE_CONDTIONS(
          p_i_v_in      IN  VARCHAR2
        , p_i_v_find    IN  VARCHAR2
        , p_i_v_tab     IN  VARCHAR2

    )AS
        l_v_in  VARCHAR2(30);
        DUPLICATE_STOWAGE           VARCHAR2(1) := 'd'; -- *4

    BEGIN

            -- Where condition for BOOKED TAB.
        IF(p_i_v_tab = 'BOOKED_TAB') THEN
           --  when BB Cargo is selectd
        IF(p_i_v_in = 'BBCARGO') then
          g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TERM = ''BBK''' ;

            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''ER''' ;
            END IF;
            -- when COC Transshipped  is selectd
            IF(p_i_v_in = 'COCTRANS') then
          g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
               --  when DG Cargo is selectd
            IF(p_i_v_in = 'DGCARGO') then
                -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL = ''D1'' OR FK_UNNO IS NOT NULL    OR FK_UN_VAR IS NOT NULL OR FLASH_UNIT IS NOT NULL OR NVL(FLASH_POINT,0)!=0)' ; -- IMO class NOT FOUND.
            END IF;
              --  when OOG Cargo is selectd
            IF(p_i_v_in = 'OOGCARGO') then
                -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL = ''O0'' OR NVL(OVERHEIGHT_CM,0) != 0  OR NVL(OVERLENGTH_FRONT_CM,0)!= 0 OR NVL(OVERWIDTH_RIGHT_CM,0)!= 0 OR NVL(OVERWIDTH_LEFT_CM,0)!= 0)' ; -- Over Length in Back  NOT FOUND.
            END IF;
              --  when Reefer Cargo is selectd
            IF(p_i_v_in = 'REEFERCARGO') then
                -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
              g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL != ''NR'' OR  NVL(REEFER_TMP,0)!=0 OR REEFER_TMP_UNIT IS NOT NULL OR NVL(DN_HUMIDITY,0)!=0 OR NVL(DN_VENTILATION,0)!=0 )' ;
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''FC''' ;
            END IF;

            -- when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
                 g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;

            --  when Tight Connection is selectd
              -- IF(p_i_v_in = 'TIGHTCON') then
            --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
              -- END IF;

            --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
            g_v_sql := g_v_sql || ' AND LOCAL_STATUS = ''T''';
            END IF;
            -- when With Remarks is selectd
            IF(p_i_v_in = 'WITHREM') then
               g_v_sql := g_v_sql || ' AND PUBLIC_REMARK IS NOT NULL';
            END IF;

        -- add the find value in dynamic sql queries booked .
-- *************************************************************************************
            IF(p_i_v_in = 'FK_BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND FK_BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_BKG_TYP') then
                g_v_sql := g_v_sql || ' AND DN_BKG_TYP = DECODE(''' || p_i_v_find || ''',''NORMAL'',''N'',
                                                                                 ''EMPTY REPOSITIONING'',''ER'',
                                                                                 ''FEEDER CARGO'',''FC'')';
            END IF;
            IF(p_i_v_in = 'FK_CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND FK_CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOADING_STATUS') THEN
                g_v_sql := g_v_sql || ' AND  LOADING_STATUS = DECODE(''' || p_i_v_find || ''',''BOOKED'',''BK'',
                                                                                    ''LOADED'',''LO'',
                                                                                    ''RETAINED ON BOARD'',''RB'',
                                                                                    ''ROB'',''RB'',
                                                                                    ''SHORT SHIPPED'',''SL'')';
            END IF;
            IF(p_i_v_in = 'DN_EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND  DN_EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_CONDITION') THEN
                g_v_sql := g_v_sql || ' AND LOAD_CONDITION =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',
                                                                                      ''FULL'',''F'',
                                                                                      ''BUNDLE'',''P'',
                                                                                      ''BASE'',''B'',
                                                                                      ''RESIDUE'',''R'',
                                                                                      ''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_STATUS =  DECODE(''' || p_i_v_find || ''',''LOCAL'',''L'',
                                                                                      ''TRANSHIPMENT'',''T'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_TERMINAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_TERMINAL_STATUS = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VESSEL= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_POD1') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_POD1= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_POD2') THEN
                    g_v_sql := g_v_sql || ' AND  DN_NXT_POD2= ''' || p_i_v_find || '''';
                END IF;
            IF(p_i_v_in = 'DN_NXT_POD3') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_POD3= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_SRV') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_SRV= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_VESSEL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD1') THEN
                g_v_sql := g_v_sql || ' AND  MLO_POD1 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD2') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD2 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD3') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD3 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TYP = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND DN_EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND FK_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND DN_SOC_COC = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',
                                                                                 ''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'DN_SPECIAL_HNDL') THEN
                g_v_sql := g_v_sql || ' AND DN_SPECIAL_HNDL = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',
                                                                                      ''DG'',''D1'',
                                                                                      ''NORMAL'',''N'',
                                                                                      ''DOOR AJAR'',''DA'',
                                                                                      ''OPEN DOOR'',''OD'',
                                                                                      ''NON REFER '',''NR'')';
            END IF;

            IF(p_i_v_in = 'DN_EQ_TYPE') THEN
                g_v_sql := g_v_sql || ' AND DN_EQ_TYPE = ''' || p_i_v_find || '''';
            END IF;

            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND  DN_EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;

            /*
                *4: Changes start
            */
            IF(p_i_v_in = 'STOWAGE_POSITION') THEN
                /*
                    if user input 'd', show only duplicate container.
                */
                IF LOWER(p_i_v_find)  = DUPLICATE_STOWAGE THEN
                    /* logic to get duplicate cell location */
                    g_v_sql := g_v_sql
                        ||' AND STOWAGE_POSITION IN '
                        ||'(SELECT STOWAGE_POSITION '
                        ||'FROM '
                        ||'  (SELECT STOWAGE_POSITION, '
                        ||'    FK_LOAD_LIST_ID '
                        ||'  FROM TOS_LL_BOOKED_LOADING IBL '
                        ||'  WHERE STOWAGE_POSITION      IS NOT NULL '
                        ||'  AND RECORD_STATUS= ''A'' ' -- *20
                        ||'  AND IBL.FK_LOAD_LIST_ID = ''' || g_v_load_list_id || ''' '
                        ||'  GROUP BY STOWAGE_POSITION, '
                        ||'    FK_LOAD_LIST_ID '
                        ||'  HAVING COUNT(1) > ''1'' '
                        ||'  ) '
                        ||') ';
                ELSE
                    g_v_sql := g_v_sql || ' AND STOWAGE_POSITION = ''' || p_i_v_find || '''';
                END IF;

            END IF; -- End of stowage position if block
            /*
                *4: Changes end
            */

            /*
                *6: Changes start
            */
            IF(p_i_v_in = 'EX_MLO_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND EX_MLO_VESSEL = ''' || p_i_v_find || ''' ';
            END IF;
            IF(p_i_v_in = 'EX_MLO_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND EX_MLO_VOYAGE = ''' || p_i_v_find || ''' ';
            END IF;
            /*
                *6: Changes end
            */

-- *************************************************************************************

        -- Where condition for OVERSHIPPED TAB.
       ELSIF(p_i_v_tab = 'OVERSHIPPED_TAB') THEN

             --  when BB Cargo is selectd
            IF(p_i_v_in = 'BBCARGO') then
              g_v_sql := g_v_sql || ' AND SHIPMENT_TERM = ''BBK''' ;
            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''ER''' ;
            END IF;
             --  when COC Transshipped  is selectd
            IF(p_i_v_in = 'COCTRANS') then
                 g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
               --  when DG Cargo is selectd
            IF(p_i_v_in = 'DGCARGO') then
                -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING = ''D1'' OR UN_NUMBER IS NOT NULL  OR UN_NUMBER_VARIANT IS NOT NULL OR FLASHPOINT_UNIT IS NOT NULL OR NVL(FLASHPOINT,0)!= 0 )' ; -- IMO class NOT FOUND.
            END IF;

              --  when OOG Cargo is selectd
            IF(p_i_v_in = 'OOGCARGO') then
                -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING = ''O0'' OR NVL(OVERHEIGHT_CM,0) != 0  OR NVL(OVERLENGTH_FRONT_CM,0)!= 0 OR NVL(OVERWIDTH_RIGHT_CM,0)!= 0 OR NVL(OVERWIDTH_LEFT_CM,0)!= 0)' ; -- Over Length in Back  NOT FOUND.
            END IF;
              --  when Reefer Cargo is selectd
            IF(p_i_v_in = 'REEFERCARGO') then
                -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
              g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING != ''NR'' OR NVL(REEFER_TEMPERATURE,0)!=0 OR REEFER_TMP_UNIT IS NOT NULL OR NVL(HUMIDITY,0) !=0 OR NVL(VENTILATION,0)!=0 )' ;
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''FC''' ;
            END IF;

            --  when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
            END IF;

            --  when Tight Connection is selectd
              -- IF(p_i_v_in = 'TIGHTCON') then
            --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
              -- END IF;

      --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
                g_v_sql := g_v_sql || ' AND LOCAL_STATUS = ''T''';
            END IF;

            -- add the find value in dynamic sql queries for overshipped tab.
-- *************************************************************************************
            IF(p_i_v_in = 'BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'BKG_TYP') then
                g_v_sql := g_v_sql || ' AND BKG_TYP = DECODE(''' || p_i_v_find || ''',''NORMAL'',''N'',''EMPTY REPOSITIONING'',''ER'',''FEEDER CARGO'',''FC'')';
            END IF;
            IF(p_i_v_in = 'CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_CONDITION') THEN
                g_v_sql := g_v_sql || ' AND LOAD_CONDITION =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',''FULL'',''F'',''BUNDLE'',''P'',''BASE'',''B'',''RESIDUE'',''R'',''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_STATUS =  DECODE(''' || p_i_v_find || ''',''LOCAL'',''L'',''TRANSHIPMENT'',''T'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_TERMINAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_TERMINAL_STATUS = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND MLO_VESSEL= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_POD1') THEN
                g_v_sql := g_v_sql || ' AND NXT_POD1= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_POD2') THEN
                g_v_sql := g_v_sql || ' AND NXT_POD2= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_POD3') THEN
                g_v_sql := g_v_sql || ' AND NXT_POD3= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_SRV') THEN
                g_v_sql := g_v_sql || ' AND NXT_SRV= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND NXT_VESSEL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND NXT_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD1') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD1 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD2') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD2 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD3') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD3 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'POL') THEN
                g_v_sql := g_v_sql || ' AND POL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND SHIPMENT_TYPE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FLAG_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND FLAG_SOC_COC = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'SPECIAL_HANDLING') THEN
                g_v_sql := g_v_sql || ' AND SPECIAL_HANDLING = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',''DG'',''D1'',''NORMAL'',''N'',''DOOR AJAR'',''DA'',''OPEN DOOR'',''OD'',''NON REFER '',''NR'')';
            END IF;
            IF(p_i_v_in = 'EQ_TYPE') THEN
            g_v_sql := g_v_sql || ' AND EQ_TYPE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND  EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;

            IF(p_i_v_in = 'STOWAGE_POSITION') THEN
                g_v_sql := g_v_sql || ' AND STOWAGE_POSITION = ''' || p_i_v_find || '''';
            END IF;

        /*
            *9 changes start
        */
        IF(p_i_v_in = 'DISCHARGE_PORT') THEN
            g_v_sql := g_v_sql || ' AND DISCHARGE_PORT = ''' || p_i_v_find || '''';
        END IF;

        IF(p_i_v_in = 'POD_TERMINAL') THEN
            g_v_sql := g_v_sql || ' AND POD_TERMINAL = ''' || p_i_v_find || '''';
        END IF;
        /*
            *9 changes end
        */

-- *************************************************************************************
    -- Where condition for restow tab.
        ELSIF (p_i_v_tab = 'RESTOW_TAB') THEN
             --  when BB Cargo is selectd
            IF(p_i_v_in = 'BBCARGO') then
              g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TERM = ''BBK''' ;
            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND FK_BKG_SIZE_TYPE_DTL = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND FK_BKG_SIZE_TYPE_DTL = ''ER''' ;
            END IF;
             --  when COC Transshipped  is selectd
            IF(p_i_v_in = 'COCTRANS') then
                g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND FK_BKG_SIZE_TYPE_DTL = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND FK_BKG_SIZE_TYPE_DTL = ''FC''' ;
            END IF;

            --  when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
                g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
            END IF;

            --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
                    g_v_sql := g_v_sql || 'AND LOCAL_STATUS = ''T''';
            END IF;
            --  when With Remarks is selectd
            IF(p_i_v_in = 'WITHREM') then
              g_v_sql := g_v_sql || ' AND PUBLIC_REMARK IS NOT NULL';
            END IF;

            -- add the find value in dynamic sql queries.
-- *************************************************************************************
            IF(p_i_v_in = 'FK_BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND FK_BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND FK_CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_CONDITION') THEN
                g_v_sql := g_v_sql || ' AND LOAD_CONDITION =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',''FULL'',''F'',''BUNDLE'',''P'',''BASE'',''B'',''RESIDUE'',''R'',''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'DN_SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TYP = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND DN_EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND FK_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND DN_SOC_COC  = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'DN_SPECIAL_HNDL') THEN
                g_v_sql := g_v_sql || ' AND DN_SPECIAL_HNDL = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',''DG'',''D1'',''NORMAL'',''N'',''DOOR AJAR'',''DA'',''OPEN DOOR'',''OD'',''NON REFER '',''NR'')';
            END IF;
            IF(p_i_v_in = 'DN_EQ_TYPE') THEN
                g_v_sql := g_v_sql || ' AND  DN_EQ_TYPE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;
-- *************************************************************************************
    END IF;

    END ADDITION_WHERE_CONDTIONS;

    PROCEDURE GET_VESSEL_OWNER_DTL(
        p_i_v_hdr_vessel         VARCHAR2
      , p_i_v_owner_dtl          OUT VARCHAR2
      , p_i_v_vessel_nm          OUT VARCHAR2
      , p_o_v_err_cd             OUT VARCHAR2
    )
    AS
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        p_i_v_owner_dtl := '';
        p_i_v_vessel_nm := '';

        SELECT VSLGNM VS_NAME,  VSPOWN VS_OWNER
        INTO p_i_v_vessel_nm, p_i_v_owner_dtl
        FROM ITP060
        WHERE VSVESS = p_i_v_hdr_vessel;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_o_v_err_cd:= PCE_EUT_COMMON.G_V_GE0004;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
     WHEN OTHERS THEN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END GET_VESSEL_OWNER_DTL;

    PROCEDURE PRE_ELL_SAVE_BOOKED_TAB_DATA(
          p_i_v_session_id                     VARCHAR2
        , p_i_v_seq_no                         VARCHAR2
        , p_i_v_load_list_id                   VARCHAR2
        , p_i_v_dn_equipment_no                VARCHAR2
        , p_i_v_local_terminal_status          VARCHAR2
        , p_i_v_midstream_handling_code        VARCHAR2
        , p_i_v_load_condition                 VARCHAR2
        , p_i_v_loading_status                 VARCHAR2
        , p_i_v_stowage_position               VARCHAR2
        , p_i_v_activity_date_time             VARCHAR2
        , p_i_v_container_gross_weight         VARCHAR2
        , p_i_v_damaged                        VARCHAR2
        , p_i_v_fk_container_operator          VARCHAR2
        , p_i_v_slot_operator                  VARCHAR2
        , p_i_v_seal_no                        VARCHAR2
        , p_i_v_mlo_vessel                     VARCHAR2
        , p_i_v_mlo_voyage                     VARCHAR2
        , p_i_v_mlo_vessel_eta                 VARCHAR2
        , p_i_v_mlo_pod1                       VARCHAR2
        , p_i_v_mlo_pod2                       VARCHAR2
        , p_i_v_mlo_pod3                       VARCHAR2
        , p_i_v_mlo_del                        VARCHAR2
        , p_i_v_humidity                       VARCHAR2
        , p_i_v_handling_inst1                 VARCHAR2
        , p_i_v_handling_inst2                 VARCHAR2
        , p_i_v_handling_inst3                 VARCHAR2
        , p_i_v_container_loading_rem_1        VARCHAR2
        , p_i_v_container_loading_rem_2        VARCHAR2
        , p_i_v_tight_connection_flag1         VARCHAR2
        , p_i_v_tight_connection_flag2         VARCHAR2
        , p_i_v_tight_connection_flag3         VARCHAR2
        , p_i_v_fk_imdg                        VARCHAR2
        , p_i_v_fk_unno                        VARCHAR2
        , p_i_v_fk_un_var                      VARCHAR2
        , p_i_v_fk_port_class                  VARCHAR2
        , p_i_v_fk_port_class_typ              VARCHAR2
        , p_i_v_flash_unit                     VARCHAR2
        , p_i_v_flash_point                    VARCHAR2
        , p_i_v_fumigation_only                VARCHAR2
        , p_i_v_overheight_cm                  VARCHAR2
        , p_i_v_overwidth_left_cm              VARCHAR2
        , p_i_v_overwidth_right_cm             VARCHAR2
        , p_i_v_overlength_front_cm            VARCHAR2
        , p_i_v_overlength_rear_cm             VARCHAR2
        , p_i_v_reefer_temperature             VARCHAR2
        , p_i_v_reefer_tmp_unit                VARCHAR2
        , p_i_v_public_remark                  VARCHAR2
        , p_i_v_out_slot_operator              VARCHAR2
        , p_i_v_user_id                        VARCHAR2
        , p_i_v_opn_sts                        VARCHAR2
        , p_i_v_local_status                   VARCHAR2
        , p_i_v_ex_mlo_vessel                  VARCHAR2
        , p_i_v_ex_mlo_vessel_eta              VARCHAR2
        , p_i_v_ex_mlo_voyage                  VARCHAR2
        , p_i_v_ventilation                    VARCHAR2
        , p_i_v_residue_only_flag              VARCHAR2
        , p_i_v_cran_description               VARCHAR2 -- *8
        , p_o_v_error                         OUT VARCHAR2

    ) AS
        test_exception EXCEPTION;

    BEGIN
        /* Set Success Code  */
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- Update data in TOS_LL_BOOKED_LOADING_TMP
        UPDATE TOS_LL_BOOKED_LOADING_TMP
        SET   DN_EQUIPMENT_NO             = p_i_v_dn_equipment_no
            , LOCAL_TERMINAL_STATUS       = p_i_v_local_terminal_status
            , MIDSTREAM_HANDLING_CODE     = p_i_v_midstream_handling_code
            , LOAD_CONDITION              = p_i_v_load_condition
            , LOADING_STATUS              = p_i_v_loading_status
            , STOWAGE_POSITION            = p_i_v_stowage_position
            , ACTIVITY_DATE_TIME          = p_i_v_activity_date_time
            , CONTAINER_GROSS_WEIGHT      = REPLACE(p_i_v_container_gross_weight,',','')
            , DAMAGED                     = p_i_v_damaged
            , FK_CONTAINER_OPERATOR       = p_i_v_fk_container_operator
            , OUT_SLOT_OPERATOR           = p_i_v_out_slot_operator
            , SEAL_NO                     = p_i_v_seal_no
            , MLO_VESSEL                  = p_i_v_mlo_vessel
            , MLO_VOYAGE                  = p_i_v_mlo_voyage
            , MLO_VESSEL_ETA              = p_i_v_mlo_vessel_eta
            , MLO_POD1                    = p_i_v_mlo_pod1
            , MLO_POD2                    = p_i_v_mlo_pod2
            , MLO_POD3                    = p_i_v_mlo_pod3
            , FK_HANDLING_INSTRUCTION_1   = p_i_v_handling_inst1
            , FK_HANDLING_INSTRUCTION_2   = p_i_v_handling_inst2
            , FK_HANDLING_INSTRUCTION_3   = p_i_v_handling_inst3
            , CONTAINER_LOADING_REM_1     = p_i_v_container_loading_rem_1
            , CONTAINER_LOADING_REM_2     = p_i_v_container_loading_rem_2
            , TIGHT_CONNECTION_FLAG1      = p_i_v_tight_connection_flag1
            , TIGHT_CONNECTION_FLAG2      = p_i_v_tight_connection_flag2
            , TIGHT_CONNECTION_FLAG3      = p_i_v_tight_connection_flag3
            , FK_IMDG                     = p_i_v_fk_imdg
            , FK_UNNO                     = p_i_v_fk_unno
            , FK_UN_VAR                   = p_i_v_fk_un_var
            , FK_PORT_CLASS               = p_i_v_fk_port_class
            , FK_PORT_CLASS_TYP           = p_i_v_fk_port_class_typ
            , FLASH_UNIT                  = p_i_v_flash_unit
            , FLASH_POINT                 = p_i_v_flash_point
            , FUMIGATION_ONLY             = p_i_v_fumigation_only
            , OVERHEIGHT_CM               = REPLACE(p_i_v_overheight_cm,',','')
            , OVERWIDTH_LEFT_CM           = REPLACE(p_i_v_overwidth_left_cm,',','')
            , OVERWIDTH_RIGHT_CM          = REPLACE(p_i_v_overwidth_right_cm,',','')
            , OVERLENGTH_FRONT_CM         = REPLACE(p_i_v_overlength_front_cm,',','')
            , OVERLENGTH_REAR_CM          = REPLACE(p_i_v_overlength_rear_cm,',','')
            , REEFER_TMP                  = REPLACE(p_i_v_reefer_temperature,',','')
            , REEFER_TMP_UNIT             = p_i_v_reefer_tmp_unit
            , PUBLIC_REMARK               = p_i_v_public_remark
            , OPN_STATUS                  = p_i_v_opn_sts
            , RECORD_CHANGE_USER          = p_i_v_user_id
           -- , LOCAL_STATUS                = p_i_v_local_status --*15
            , EX_MLO_VESSEL               = p_i_v_ex_mlo_vessel
            , EX_MLO_VESSEL_ETA           = p_i_v_ex_mlo_vessel_eta
            , EX_MLO_VOYAGE               = p_i_v_ex_mlo_voyage
            , DN_VENTILATION              = REPLACE(p_i_v_ventilation, ',','')
            , MLO_DEL                     = p_i_v_mlo_del
            , DN_HUMIDITY                 = p_i_v_humidity
            , RESIDUE_ONLY_FLAG           = p_i_v_residue_only_flag
             , CRANE_TYPE                 = p_i_v_cran_description  -- *8
        WHERE SESSION_ID                  = p_i_v_session_id
        AND   SEQ_NO                      = p_i_v_seq_no;


        EXCEPTION
            WHEN OTHERS THEN
                p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        END PRE_ELL_SAVE_BOOKED_TAB_DATA;

    PROCEDURE PRE_ELL_SAVE_OVERSHIP_TAB_DATA(
          p_i_v_session_id                      VARCHAR2
        , p_i_v_seq_no                          IN  OUT VARCHAR2
        , p_i_v_overshipped_container_id        VARCHAR2
        , p_i_v_load_list_id                    VARCHAR2
        , p_i_v_booking_no                      VARCHAR2
        , p_i_v_equipment_no                    VARCHAR2
        , p_i_v_eq_size                         VARCHAR2
        , p_i_v_eq_type                         VARCHAR2
        , p_i_v_full_mt                         VARCHAR2
        , p_i_v_bkg_typ                         VARCHAR2
        , p_i_v_flag_soc_coc                    VARCHAR2
        , p_i_v_shipment_term                   VARCHAR2
        , p_i_v_shipment_typ                    VARCHAR2
        , p_i_v_local_status                    VARCHAR2
        , p_i_v_local_terminal_status           VARCHAR2
        , p_i_v_midstream_handling_code         VARCHAR2
        , p_i_v_load_condition                  VARCHAR2
        , p_i_v_stowage_position                VARCHAR2
        , p_i_v_activity_date_time              VARCHAR2
        , p_i_v_container_gross_weight          VARCHAR2
        , p_i_v_damaged                         VARCHAR2
        , p_i_v_slot_operator                   VARCHAR2
        , p_i_v_container_operator              VARCHAR2
        , p_i_v_out_slot_operator               VARCHAR2
        , p_i_v_special_handling                VARCHAR2
        , p_i_v_seal_no                         VARCHAR2
        , p_i_v_pod                             VARCHAR2
        , p_i_v_pod_terminal                    VARCHAR2
        , p_i_v_nxt_srv                         VARCHAR2
        , p_i_v_nxt_vessel                      VARCHAR2
        , p_i_v_nxt_voyage                      VARCHAR2
        , p_i_v_nxt_dir                         VARCHAR2
        , p_i_v_mlo_vessel                      VARCHAR2
        , p_i_v_mlo_voyage                      VARCHAR2
        , p_i_v_mlo_vessel_eta                  VARCHAR2
        , p_i_v_mlo_pod1                        VARCHAR2
        , p_i_v_mlo_pod2                        VARCHAR2
        , p_i_v_mlo_pod3                        VARCHAR2
        , p_i_v_mlo_del                         VARCHAR2
        , p_i_v_handling_instruction_1          VARCHAR2
        , p_i_v_handling_instruction_2          VARCHAR2
        , p_i_v_handling_instruction_3          VARCHAR2
        , p_i_v_container_loading_rem_1         VARCHAR2
        , p_i_v_container_loading_rem_2         VARCHAR2
        , p_i_v_special_cargo                   VARCHAR2
        , p_i_v_imdg_class                      VARCHAR2
        , p_i_v_un_number                       VARCHAR2
        , p_i_v_un_var                          VARCHAR2
        , p_i_v_port_class                      VARCHAR2
        , p_i_v_port_class_typ                  VARCHAR2
        , p_i_v_flashpoint_unit                 VARCHAR2
        , p_i_v_flashpoint                      VARCHAR2
        , p_i_v_fumigation_only                 VARCHAR2
        , p_i_v_residue_only_flag               VARCHAR2
        , p_i_v_overheight_cm                   VARCHAR2
        , p_i_v_overwidth_left_cm               VARCHAR2
        , p_i_v_overwidth_right_cm              VARCHAR2
        , p_i_v_overlength_front_cm             VARCHAR2
        , p_i_v_overlength_rear_cm              VARCHAR2
        , p_i_v_reefer_temperature              VARCHAR2
        , p_i_v_reefer_tmp_unit                 VARCHAR2
        , p_i_v_humidity                        VARCHAR2
        , p_i_v_ventilation                     VARCHAR2
        , p_i_v_loading_status                  VARCHAR2
        , p_i_v_user_id                         VARCHAR2
        , p_i_v_opn_sts                         VARCHAR2
        , p_i_v_void_slot                       VARCHAR2
        , p_i_v_ex_mlo_vessel                   VARCHAR2
        , p_i_v_ex_mlo_vessel_eta               VARCHAR2
        , p_i_v_ex_mlo_voyage                   VARCHAR2
        , p_o_v_error                           OUT VARCHAR2
        ) AS
            l_n_seq_no      NUMBER := 0;
        BEGIN
        /* Set Success Code  */
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF (((p_i_v_seq_no = '0') or (p_i_v_seq_no IS NULL)) AND p_i_v_opn_sts = PCE_EUT_COMMON.G_V_REC_ADD) THEN

            SELECT NVL(MAX(TO_NUMBER(SEQ_NO)),0)+1
            INTO   l_n_seq_no
            FROM   TOS_LL_OVERSHIPPED_CONT_TMP
            WHERE  SESSION_ID = p_i_v_session_id;

            INSERT INTO TOS_LL_OVERSHIPPED_CONT_TMP(
              SESSION_ID
            , SEQ_NO
            , BOOKING_NO
            , BOOKING_NO_SOURCE
            , EQUIPMENT_NO
            , EQ_SIZE
            , EQ_TYPE
            , FULL_MT
            , BKG_TYP
            , FLAG_SOC_COC
            , LOCAL_STATUS
            , LOCAL_TERMINAL_STATUS
            , MIDSTREAM_HANDLING_CODE
            , LOAD_CONDITION
            , LOADING_STATUS
            , STOWAGE_POSITION
            , ACTIVITY_DATE_TIME
            , CONTAINER_GROSS_WEIGHT
            , DAMAGED
            , VOID_SLOT
            , SLOT_OPERATOR
            , CONTAINER_OPERATOR
            , OUT_SLOT_OPERATOR
            , SPECIAL_HANDLING
            , SEAL_NO
            , DISCHARGE_PORT
            , POD_TERMINAL
            , MLO_VESSEL
            , MLO_VOYAGE
            , MLO_VESSEL_ETA
            , MLO_POD1
            , MLO_POD2
            , MLO_POD3
            , MLO_DEL
            , EX_MLO_VESSEL
            , EX_MLO_VESSEL_ETA
            , EX_MLO_VOYAGE
            , HANDLING_INSTRUCTION_1
            , HANDLING_INSTRUCTION_2
            , HANDLING_INSTRUCTION_3
            , CONTAINER_LOADING_REM_1
            , CONTAINER_LOADING_REM_2
            , SPECIAL_CARGO
            , IMDG_CLASS
            , UN_NUMBER
            , UN_NUMBER_VARIANT
            , PORT_CLASS
            , PORT_CLASS_TYPE
            , FLASHPOINT_UNIT
            , FLASHPOINT
            , FUMIGATION_ONLY
            , RESIDUE_ONLY_FLAG
            , OVERHEIGHT_CM
            , OVERWIDTH_LEFT_CM
            , OVERWIDTH_RIGHT_CM
            , OVERLENGTH_FRONT_CM
            , OVERLENGTH_REAR_CM
            , REEFER_TEMPERATURE
            , REEFER_TMP_UNIT
            , HUMIDITY
            , VENTILATION
            , FK_LOAD_LIST_ID
            , OPN_STATUS
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE
            )
            VALUES (
                p_i_v_session_id
              , l_n_seq_no
              , p_i_v_booking_no
              , 'I'
              , p_i_v_equipment_no
              , p_i_v_eq_size
              , p_i_v_eq_type
              , p_i_v_full_mt
              , p_i_v_bkg_typ
              , p_i_v_flag_soc_coc
              , p_i_v_local_status
              , p_i_v_local_terminal_status
              , p_i_v_midstream_handling_code
              , p_i_v_load_condition
              , p_i_v_loading_status
              , p_i_v_stowage_position
              , p_i_v_activity_date_time
              , REPLACE(p_i_v_container_gross_weight, ',','')
              , p_i_v_damaged
              , p_i_v_void_slot
              , p_i_v_slot_operator
              , p_i_v_container_operator
              , p_i_v_out_slot_operator
              , p_i_v_special_handling
              , p_i_v_seal_no
              , p_i_v_pod
              , p_i_v_pod_terminal
              , p_i_v_mlo_vessel
              , p_i_v_mlo_voyage
              , p_i_v_mlo_vessel_eta
              , p_i_v_mlo_pod1
              , p_i_v_mlo_pod2
              , p_i_v_mlo_pod3
              , p_i_v_mlo_del
              , p_i_v_ex_mlo_vessel
              , p_i_v_ex_mlo_vessel_eta
              , p_i_v_ex_mlo_voyage
              , p_i_v_handling_instruction_1
              , p_i_v_handling_instruction_2
              , p_i_v_handling_instruction_3
              , p_i_v_container_loading_rem_1
              , p_i_v_container_loading_rem_2
              , p_i_v_special_cargo
              , p_i_v_imdg_class
              , p_i_v_un_number
              , p_i_v_un_var
              , p_i_v_port_class
              , p_i_v_port_class_typ
              , p_i_v_flashpoint_unit
              , REPLACE(p_i_v_flashpoint, ',','')
              , p_i_v_fumigation_only
              , p_i_v_residue_only_flag
              , REPLACE(p_i_v_overheight_cm, ',','')
              , REPLACE(p_i_v_overwidth_left_cm, ',','')
              , REPLACE(p_i_v_overwidth_right_cm, ',','')
              , REPLACE(p_i_v_overlength_front_cm, ',','')
              , REPLACE(p_i_v_overlength_rear_cm, ',','')
              , REPLACE(p_i_v_reefer_temperature, ',','')
              , p_i_v_reefer_tmp_unit
              , REPLACE(p_i_v_humidity, ',','')
              , REPLACE(p_i_v_ventilation, ',','')
              , p_i_v_load_list_id
              , p_i_v_opn_sts
              , p_i_v_user_id
              , SYSDATE
            );
           p_i_v_seq_no := l_n_seq_no;
       ELSE
        -- Update data in TOS_LL_OVERSHIPPED_CONT_TMP
        UPDATE TOS_LL_OVERSHIPPED_CONT_TMP SET
              BOOKING_NO               =  p_i_v_booking_no
            , EQUIPMENT_NO               =  p_i_v_equipment_no
            , EQ_SIZE                   =  p_i_v_eq_size
            , EQ_TYPE                   =  p_i_v_eq_type
            , FULL_MT                   =  p_i_v_full_mt
            , BKG_TYP                   =  p_i_v_bkg_typ
            , FLAG_SOC_COC               =  p_i_v_flag_soc_coc
            , SHIPMENT_TERM               =  p_i_v_shipment_term
            , SHIPMENT_TYPE               =  p_i_v_shipment_typ
            , LOCAL_STATUS               =  p_i_v_local_status
            , LOCAL_TERMINAL_STATUS       =  p_i_v_local_terminal_status
            , MIDSTREAM_HANDLING_CODE  =  p_i_v_midstream_handling_code
            , LOAD_CONDITION           =  p_i_v_load_condition
            , STOWAGE_POSITION           =  p_i_v_stowage_position
            , ACTIVITY_DATE_TIME       = p_i_v_activity_date_time
            , CONTAINER_GROSS_WEIGHT   =  REPLACE(p_i_v_container_gross_weight, ',','')
            , DAMAGED                   =  p_i_v_damaged
            , SLOT_OPERATOR               =  p_i_v_slot_operator
            , CONTAINER_OPERATOR       =  p_i_v_container_operator
            , OUT_SLOT_OPERATOR           =  p_i_v_out_slot_operator
            , SPECIAL_HANDLING           =  p_i_v_special_handling
            , SEAL_NO                   =  p_i_v_seal_no
            , DISCHARGE_PORT           =  p_i_v_pod
            , POD_TERMINAL               =  p_i_v_pod_terminal
            , MLO_VESSEL               =  p_i_v_mlo_vessel
            , MLO_VOYAGE               =  p_i_v_mlo_voyage
            , MLO_VESSEL_ETA           =  p_i_v_mlo_vessel_eta
            , MLO_POD1                   =  p_i_v_mlo_pod1
            , MLO_POD2                   =  p_i_v_mlo_pod2
            , MLO_POD3                   =  p_i_v_mlo_pod3
            , HANDLING_INSTRUCTION_1   =  p_i_v_handling_instruction_1
            , HANDLING_INSTRUCTION_2   =  p_i_v_handling_instruction_2
            , HANDLING_INSTRUCTION_3   =  p_i_v_handling_instruction_3
            , CONTAINER_LOADING_REM_1  =  p_i_v_container_loading_rem_1
            , CONTAINER_LOADING_REM_2  =  p_i_v_container_loading_rem_2
            , IMDG_CLASS               =  p_i_v_imdg_class
            , UN_NUMBER                   =  p_i_v_un_number
            , UN_NUMBER_VARIANT           =  p_i_v_un_var
            , PORT_CLASS               =  p_i_v_port_class
            , PORT_CLASS_TYPE           =  p_i_v_port_class_typ
            , FLASHPOINT_UNIT           =  p_i_v_flashpoint_unit
            , FLASHPOINT               =  REPLACE(p_i_v_flashpoint, ',','')
            , FUMIGATION_ONLY           =  p_i_v_fumigation_only
            , RESIDUE_ONLY_FLAG           =  p_i_v_residue_only_flag
            , OVERHEIGHT_CM               =  REPLACE(p_i_v_overheight_cm, ',','')
            , OVERWIDTH_LEFT_CM           =  REPLACE(p_i_v_overwidth_left_cm, ',','')
            , OVERWIDTH_RIGHT_CM       =  REPLACE(p_i_v_overwidth_right_cm, ',','')
            , OVERLENGTH_FRONT_CM       =  REPLACE(p_i_v_overlength_front_cm, ',','')
            , OVERLENGTH_REAR_CM       =  REPLACE(p_i_v_overlength_rear_cm, ',','')
            , REEFER_TEMPERATURE       =  REPLACE(p_i_v_reefer_temperature, ',','')
            , REEFER_TMP_UNIT           =  p_i_v_reefer_tmp_unit
            , HUMIDITY                   =  REPLACE(p_i_v_humidity, ',','')
            , VENTILATION               =  REPLACE(p_i_v_ventilation, ',','')
            , LOADING_STATUS           =  p_i_v_loading_status
            , RECORD_CHANGE_USER       =  p_i_v_user_id
            , OPN_STATUS               =  p_i_v_opn_sts
            , VOID_SLOT                =  p_i_v_void_slot
            , EX_MLO_VESSEL            =  p_i_v_ex_mlo_vessel
            , EX_MLO_VESSEL_ETA        =  p_i_v_ex_mlo_vessel_eta
            , EX_MLO_VOYAGE            =  p_i_v_ex_mlo_voyage
        WHERE SESSION_ID               =  p_i_v_session_id
        AND   SEQ_NO                   =  p_i_v_seq_no;

        END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);

                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        END PRE_ELL_SAVE_OVERSHIP_TAB_DATA;

    PROCEDURE PRE_ELL_DEL_OVERSHIPPED_DATA (
          p_i_v_session_id    IN  VARCHAR2
        , p_i_v_seq_no        IN  VARCHAR2
        , p_i_v_opn_sts       IN  VARCHAR2
        , p_i_v_user_id       IN  VARCHAR2
        , p_o_v_err_cd        OUT VARCHAR2
    ) AS
    BEGIN

        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF ( p_i_v_opn_sts = PCE_EUT_COMMON.G_V_REC_ADD) THEN

            DELETE FROM TOS_LL_OVERSHIPPED_CONT_TMP
            WHERE SESSION_ID   = p_i_v_session_id
            AND   SEQ_NO       = p_i_v_seq_no;

        ELSE

            UPDATE TOS_LL_OVERSHIPPED_CONT_TMP SET
                  OPN_STATUS         = PCE_EUT_COMMON.G_V_REC_DEL
                , RECORD_CHANGE_USER = p_i_v_user_id
            WHERE SESSION_ID   = p_i_v_session_id
            AND   SEQ_NO       = p_i_v_seq_no;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
    END PRE_ELL_DEL_OVERSHIPPED_DATA;

    PROCEDURE PRE_ELL_SAVE_RESTOW_TAB_DATA (
          p_i_v_session_id              IN      VARCHAR2
        , p_i_v_seq_no                  IN OUT  VARCHAR2
        , p_i_v_pk_restow_id            IN      VARCHAR2
        , p_i_v_equipment_no            IN      VARCHAR2
        , p_i_v_midstream               IN      VARCHAR2
        , p_i_v_load_condition          IN      VARCHAR2
        , p_i_v_restow_status           IN      VARCHAR2
        , p_i_v_stowage_position        IN      VARCHAR2
        , p_i_v_activity_date_time      IN      VARCHAR2
        , p_i_v_public_remark           IN      VARCHAR2
        , p_i_v_user_id                 IN      VARCHAR2
        , p_i_v_load_list_id            IN      VARCHAR2
        , p_i_v_opn_sts                 IN      VARCHAR2
        , p_i_v_container_gross_weight  IN      VARCHAR2
        , p_i_v_damaged                 IN      VARCHAR2
        , p_i_v_seal_no                 IN      VARCHAR2
        , p_o_v_error                   OUT     VARCHAR2
    ) AS
        l_n_seq_no      NUMBER := 0;

    BEGIN
        -- Set the default error code.
        p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF (p_i_v_seq_no IS NULL AND p_i_v_opn_sts = PCE_EUT_COMMON.G_V_REC_ADD) THEN

            SELECT NVL(MAX(TO_NUMBER(SEQ_NO)),0)+1
            INTO   l_n_seq_no
            FROM   TOS_RESTOW_TMP
            WHERE  SESSION_ID = p_i_v_session_id;

            -- Insert new Record into TOS_RESTOW_TMP
            INSERT INTO TOS_RESTOW_TMP(
                 SESSION_ID
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
            VALUES(
                 p_i_v_session_id
                ,l_n_seq_no
                ,p_i_v_pk_restow_id
                ,p_i_v_equipment_no
                ,p_i_v_midstream
                ,p_i_v_load_condition
                ,p_i_v_restow_status
                ,p_i_v_stowage_position
                ,p_i_v_activity_date_time
                ,p_i_v_public_remark
                ,p_i_v_user_id
                ,SYSDATE
                ,p_i_v_opn_sts
                ,REPLACE(p_i_v_container_gross_weight, ',','')
                ,p_i_v_damaged
                ,p_i_v_seal_no
                ,p_i_v_load_list_id
            );
            p_i_v_seq_no := l_n_seq_no;
        ELSE

            -- update record in restow temp table.
           UPDATE  TOS_RESTOW_TMP SET
                  DN_EQUIPMENT_NO         = p_i_v_equipment_no
                , MIDSTREAM_HANDLING_CODE = p_i_v_midstream
                , LOAD_CONDITION          = p_i_v_load_condition
                , RESTOW_STATUS           = p_i_v_restow_status
                , STOWAGE_POSITION        = p_i_v_stowage_position
                , ACTIVITY_DATE_TIME      = p_i_v_activity_date_time
                , PUBLIC_REMARK           = p_i_v_public_remark
                , RECORD_CHANGE_USER      = p_i_v_user_id
                , OPN_STATUS              = p_i_v_opn_sts
                , CONTAINER_GROSS_WEIGHT  = REPLACE(p_i_v_container_gross_weight, ',','')
                , DAMAGED                 = p_i_v_damaged
                , SEAL_NO                 = p_i_v_seal_no
            WHERE SESSION_ID              = p_i_v_session_id
            AND   SEQ_NO                  = p_i_v_seq_no;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
    END PRE_ELL_SAVE_RESTOW_TAB_DATA ;

    PROCEDURE PRE_ELL_DEL_RESTOWED_TAB_DATA (
          p_i_v_session_id    IN VARCHAR2
        , p_i_v_seq_no        IN  VARCHAR2
        , p_i_v_opn_sts       IN VARCHAR2
        , p_i_v_user_id       IN VARCHAR2
        , p_o_v_err_cd        OUT VARCHAR2
    ) AS
    BEGIN

        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF ( p_i_v_opn_sts = PCE_EUT_COMMON.G_V_REC_ADD) THEN
            DELETE FROM TOS_RESTOW_TMP
            WHERE SESSION_ID   = p_i_v_session_id
            AND   SEQ_NO       = p_i_v_seq_no;

        ELSE
            UPDATE TOS_RESTOW_TMP SET
                  OPN_STATUS         = PCE_EUT_COMMON.G_V_REC_DEL
                , RECORD_CHANGE_USER = p_i_v_user_id
            WHERE SESSION_ID   = p_i_v_session_id
            AND   SEQ_NO       = p_i_v_seq_no;

        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
    END PRE_ELL_DEL_RESTOWED_TAB_DATA;

    PROCEDURE PRE_ELL_SAVE_TEMP_TO_MAIN(
        p_i_v_session_id              IN VARCHAR2
      , p_i_v_user_id                 IN VARCHAR2
      , p_i_v_load_list_status        IN VARCHAR2
      , p_i_v_load_list_id            IN VARCHAR2
      , p_i_v_eta                     IN VARCHAR2
      , p_i_v_vessel                  IN VARCHAR2
      , p_i_v_hdr_eta_tm              IN VARCHAR2
      , p_i_v_hdr_port                IN VARCHAR2
      , p_i_v_load_etd                IN VARCHAR2
      , p_i_v_hdr_etd_tm              IN VARCHAR2
      , p_o_v_err_cd                  OUT VARCHAR2
    ) AS
        l_v_date                        VARCHAR2(14);
        L_V_LL_STATUS                 VARCHAR2(2); -- *22
    BEGIN
        g_v_ora_err_cd    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        g_v_user_err_cd   := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        p_o_v_err_cd      := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        G_v_duplicate_stow_err := PCE_EUT_COMMON.G_V_SUCCESS_CD; -- *10

        -- Get system date
        SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS')
        INTO l_v_date
        FROM DUAL;

        /* *22 start * */
        /* * get updated list status * */
        L_V_LL_STATUS := P_I_V_LOAD_LIST_STATUS;

        /* * if list status is not updated then find old list status *  */
        IF (L_V_LL_STATUS IS NULL) THEN
            PCE_ECM_SYNC_BOOKING_EZLL.PRE_GET_LIST_STATUS (
                P_I_V_LOAD_LIST_ID,
                LL_DL_FLAG,
                L_V_LL_STATUS
            );
        END IF;
        /* *22 end * */

        IF ((L_V_LL_STATUS = LOADING_COMPLETE) OR
            (L_V_LL_STATUS = READY_FOR_INVOICE) OR
            (L_V_LL_STATUS = WORK_COMPLETE)) THEN  -- *22

        PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_DL_LL_MNTN (
                      LL_DL_FLAG
            , p_i_v_session_id
            , p_i_v_user_id
            , l_v_date
            , p_o_v_err_cd
        );
        IF ((p_o_v_err_cd IS NULL) OR (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD )) THEN
          RAISE l_excp_finish;
        END IF ;
        END IF; -- *22

        /* Save Booked tab data*/
        PRE_ELL_SAVE_BOOKED_TAB_MAIN(
              p_i_v_session_id
            , p_i_v_user_id
            , p_i_v_hdr_port
            , p_i_v_load_etd
            , p_i_v_hdr_etd_tm
            , p_i_v_vessel
            , l_v_date
            , p_o_v_err_cd
        );

        IF ((p_o_v_err_cd IS NULL) OR (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD )) THEN
          RAISE l_excp_finish;
        END IF ;

        /*Save overshipped tab data*/
        PRE_ELL_SAVE_OVERSHIP_TAB_MAIN(
              p_i_v_session_id
            , p_i_v_user_id
            , p_i_v_vessel
            , p_i_v_eta
            , p_i_v_hdr_eta_tm
            , p_i_v_hdr_port
            , l_v_date
            , p_i_v_load_etd
            , p_i_v_hdr_etd_tm
            , p_o_v_err_cd
        );

        IF ((p_o_v_err_cd IS NULL) OR (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD )) THEN
            RAISE l_excp_finish;
        END IF ;

        /*Save resetowed tab data*/
        PRE_ELL_SAVE_RESTOW_TAB_MAIN(
              p_i_v_session_id
            , p_i_v_user_id
            , p_i_v_vessel
            , p_i_v_eta
            , p_i_v_hdr_eta_tm
            , p_i_v_load_etd
            , p_i_v_hdr_etd_tm
            , p_i_v_hdr_port
            , l_v_date
            , p_o_v_err_cd
        );

        IF((p_o_v_err_cd IS NULL) OR (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD )) THEN
          RAISE l_excp_finish;
        END IF ;

        IF(p_i_v_load_list_status IS NOT NULL) THEN

            PRE_ELL_SAVE_LL_STATUS(
                  p_i_v_load_list_id
                , p_i_v_load_list_status
                , p_i_v_user_id
                , p_i_v_session_id  -- *19
                , l_v_date
                , p_o_v_err_cd
            );

            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RAISE l_excp_finish;
            END IF ;
        END IF;

        IF ((g_v_warning IS NOT NULL) AND (g_v_warning = 'ELL.SE0112')) THEN
            /* set the warning code to display warning message on screen */
            /*'Service, Vessel and Voyage information not match with present load list'*/
            p_o_v_err_cd := 'ELL.SE0112';
        END IF;

        /*
            *10 start
        */
        IF (p_o_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
            p_o_v_err_cd := G_V_DUPLICATE_STOW_ERR; -- *10
        END IF;

        IF p_o_v_err_cd = G_V_DUPLICATE_STOW_ERR
            AND G_V_DUPLICATE_STOW_ERR <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
            COMMIT;
            RAISE l_duplicate_stow_excption;
        END IF;
        /*
            *10 end
        */

    EXCEPTION
        /*
            *10 start
        */
        WHEN l_duplicate_stow_excption THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
        /*
            *10 end
        */

    WHEN l_excp_finish  THEN
        IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
        END IF ;
    WHEN OTHERS THEN
        p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END PRE_ELL_SAVE_TEMP_TO_MAIN;

    PROCEDURE PRE_ELL_SAVE_BOOKED_TAB_MAIN(
          p_i_v_session_id                IN VARCHAR2
        , p_i_v_user_id                   IN VARCHAR2
        , p_i_v_port_code                 IN VARCHAR2
        , p_i_v_load_etd                  IN VARCHAR2
        , p_i_v_hdr_etd_tm                IN VARCHAR2
        , p_i_v_vessel                    IN VARCHAR2
        , p_i_v_date                      IN VARCHAR2
        , p_o_v_err_cd                    OUT VARCHAR2
    ) AS
        l_v_booked_Load_id              NUMBER := 0;
        l_v_lock_data                   VARCHAR2(14);
        l_v_booked_row_num              NUMBER := 1;
        l_v_errors                      VARCHAR2(2000);
        l_v_rec_count                   NUMBER := 0;
        l_v_restow_row_num              NUMBER := 1;
        l_v_flag                        VARCHAR2(1);
        l_v_discharge_list_id           NUMBER;
        l_v_stowage_position            VARCHAR2(7);

        l_v_replacement_type            VARCHAR2(1) := '3';
        l_v_pk_cont_repl_id             NUMBER := 0;
        l_v_old_equipment_no            TOS_LL_BOOKED_LOADING_TMP.DN_EQUIPMENT_NO%TYPE;
        l_v_terminal                    TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE;

        l_v_equipment_no                TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE;
        l_v_booking_no                  TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE;
        l_v_bkg_equipm_dtl              TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE;
        l_v_bkg_voyage_routing_dtl      TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL%TYPE;
        l_v_dn_port                     TOS_LL_LOAD_LIST.DN_PORT%TYPE;     -- added 13.12.2011
        l_v_dn_terminal                 TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE; -- added 13.12.2011

        -- cursor to save booked tab data
        CURSOR l_cur_booked_data IS
        SELECT
             PK_BOOKED_LOADING_ID
            , FK_LOAD_LIST_ID
            , CONTAINER_SEQ_NO
            , FK_BOOKING_NO
            , FK_BKG_SIZE_TYPE_DTL
            , FK_BKG_SUPPLIER
            , FK_BKG_EQUIPM_DTL
            , DN_EQUIPMENT_NO
            , EQUPMENT_NO_SOURCE
            , FK_BKG_VOYAGE_ROUTING_DTL
            , DN_EQ_SIZE
            , DN_EQ_TYPE
            , DN_FULL_MT
            , DN_BKG_TYP
            , DN_SOC_COC
            , DN_SHIPMENT_TERM
            , DN_SHIPMENT_TYP
            , LOCAL_STATUS
            , LOCAL_TERMINAL_STATUS
            , MIDSTREAM_HANDLING_CODE
            , LOAD_CONDITION
            , LOADING_STATUS
            , STOWAGE_POSITION
            , ACTIVITY_DATE_TIME
            , CONTAINER_GROSS_WEIGHT
            , DAMAGED
            , VOID_SLOT
            , PREADVICE_FLAG
            , FK_SLOT_OPERATOR
            , FK_CONTAINER_OPERATOR
            , OUT_SLOT_OPERATOR
            , DN_SPECIAL_HNDL
            , SEAL_NO
            , DN_DISCHARGE_PORT
            , DN_DISCHARGE_TERMINAL
            , DN_NXT_POD1
            , DN_NXT_POD2
            , DN_NXT_POD3
            , DN_FINAL_POD
            , FINAL_DEST
            , DN_NXT_SRV
            , DN_NXT_VESSEL
            , DN_NXT_VOYAGE
            , DN_NXT_DIR
            , MLO_VESSEL
            , MLO_VOYAGE
            , MLO_VESSEL_ETA
            , MLO_POD1
            , MLO_POD2
            , MLO_POD3
            , MLO_DEL
            , EX_MLO_VESSEL
            , EX_MLO_VESSEL_ETA
            , EX_MLO_VOYAGE
            , FK_HANDLING_INSTRUCTION_1
            , FK_HANDLING_INSTRUCTION_2
            , FK_HANDLING_INSTRUCTION_3
            , CONTAINER_LOADING_REM_1
            , CONTAINER_LOADING_REM_2
            , FK_SPECIAL_CARGO
            , TIGHT_CONNECTION_FLAG1
            , TIGHT_CONNECTION_FLAG2
            , TIGHT_CONNECTION_FLAG3
            , FK_IMDG
            , FK_UNNO
            , FK_UN_VAR
            , FK_PORT_CLASS
            , FK_PORT_CLASS_TYP
            , FLASH_UNIT
            , FLASH_POINT
            , FUMIGATION_ONLY
            , RESIDUE_ONLY_FLAG
            , OVERHEIGHT_CM
            , OVERWIDTH_LEFT_CM
            , OVERWIDTH_RIGHT_CM
            , OVERLENGTH_FRONT_CM
            , OVERLENGTH_REAR_CM
            , REEFER_TMP
            , REEFER_TMP_UNIT
            , DN_HUMIDITY
            , DN_VENTILATION
            , PUBLIC_REMARK
            , OPN_STATUS
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE
            , SEQ_NO
            , DECODE(OPN_STATUS,PCE_EUT_COMMON.G_V_REC_DEL,'1') ORD_SEQ
             , CRANE_TYPE CRAN_DESCRIPTION    -- *8
        FROM  TOS_LL_BOOKED_LOADING_TMP
        WHERE SESSION_ID = p_i_v_session_id
        ORDER BY ORD_SEQ, SEQ_NO;

        CURSOR l_cur_duplicate_equip_no IS
            SELECT   DN_EQUIPMENT_NO
            FROM     TOS_LL_BOOKED_LOADING_TMP
            WHERE    SESSION_ID              = p_i_v_session_id
            GROUP BY DN_EQUIPMENT_NO
            HAVING   COUNT(DN_EQUIPMENT_NO) >1
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

        l_v_duplicate_error     VARCHAR2(4000) := NULL;
    BEGIN
        l_v_errors := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /*
            *1-Modification start by vikas, when cell location is changed and discharge status is discharged then
            check if cell location is null then update cell location otherewise not, k'chatgamol, 06.03.2012
        */

        /* ********** Duplicate Equipment# and Stowage position Validation Start ************** */
        /* Check duplicate equipment # */
        FOR l_cur_duplicate_equip_no_rec IN l_cur_duplicate_equip_no
        LOOP
            IF l_v_duplicate_error IS NULL THEN
                l_v_duplicate_error := l_cur_duplicate_equip_no_rec.DN_EQUIPMENT_NO;
            ELSE
                l_v_duplicate_error := l_v_duplicate_error || ', ' || l_cur_duplicate_equip_no_rec.DN_EQUIPMENT_NO;
            END IF;
        END LOOP;

        /* When duplicate # record found then show error
           Duplicate record present in booked tab */
        IF l_v_duplicate_error IS NOT NULL THEN
            p_o_v_err_cd := 'EDL.SE0167' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_duplicate_error ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        END IF;

        /* General Error Checking */
        IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
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
        PCE_EDL_DLMAINTENANCE.PRE_CHECK_DUP_CELL_LOCATION(
            P_I_V_SESSION_ID,
            LL_DL_FLAG,
            BLANK, /* session id must have value * */
            P_O_V_ERR_CD
        );
        /* *19 end * */

        /* General Error Checking */
        IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
            RETURN;
        END IF;
        /* ********** Duplicate Equipment# and Stowage position Validation End ************** */

        FOR l_cur_booked_data_rec IN l_cur_booked_data
        LOOP
        IF (l_cur_booked_data_rec.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_UPD) THEN

            -- call validation function for booked tab.
            PRE_ELL_BOOKED_VALIDATION(
                  p_i_v_session_id
                , l_v_restow_row_num
                , l_cur_booked_data_rec.FK_LOAD_LIST_ID
                , l_cur_booked_data_rec.DN_EQUIPMENT_NO
                , l_cur_booked_data_rec.PK_BOOKED_LOADING_ID
                , l_cur_booked_data_rec.CONTAINER_LOADING_REM_1
                , l_cur_booked_data_rec.CONTAINER_LOADING_REM_2
                , l_cur_booked_data_rec.FK_CONTAINER_OPERATOR
                , l_cur_booked_data_rec.FK_UNNO
                , p_i_v_port_code
                , l_cur_booked_data_rec.FK_UN_VAR
                , l_cur_booked_data_rec.FK_IMDG
                , l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_1
                , l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_2
                , l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_3
                , l_cur_booked_data_rec.FK_PORT_CLASS
                , l_cur_booked_data_rec.FK_PORT_CLASS_TYP
                , l_cur_booked_data_rec.FK_SLOT_OPERATOR
                , l_cur_booked_data_rec.OUT_SLOT_OPERATOR
                , l_cur_booked_data_rec.DN_SOC_COC
                , p_i_v_load_etd
                , p_i_v_hdr_etd_tm
                , p_o_v_err_cd
            );

            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;

            /* Check if stowage possition is changed, then update the stowage position in load list table. */
            /* BOOKED TAB STOWAGE POSITION CHANGED */
            SELECT STOWAGE_POSITION
            INTO   l_v_stowage_position
            FROM   TOS_LL_BOOKED_LOADING
            WHERE  PK_BOOKED_LOADING_ID   = l_cur_booked_data_rec.PK_BOOKED_LOADING_ID ;

            IF NVL(l_v_stowage_position,'~') != NVL(l_cur_booked_data_rec.STOWAGE_POSITION,'~') THEN
                /*  Get old equipment # */
                SELECT DN_EQUIPMENT_NO
                    , FK_BOOKING_NO
                    , FK_BKG_EQUIPM_DTL
                    , FK_BKG_VOYAGE_ROUTING_DTL
                INTO l_v_equipment_no
                    , l_v_booking_no
                    , l_v_bkg_equipm_dtl
                    , l_v_bkg_voyage_routing_dtl
                FROM TOS_LL_BOOKED_LOADING
                WHERE PK_BOOKED_LOADING_ID = l_cur_booked_data_rec.PK_BOOKED_LOADING_ID;

                /* Equipment no# is changed to any value. then update load list. */
                IF( ( (l_v_equipment_no IS NULL) AND (l_cur_booked_data_rec.DN_EQUIPMENT_NO IS NOT NULL) )
                   OR (l_v_equipment_no <> l_cur_booked_data_rec.DN_EQUIPMENT_NO) ) THEN

                    /* Update current discharge list */
                    UPDATE
                        TOS_DL_BOOKED_DISCHARGE
                    SET
                        STOWAGE_POSITION = l_cur_booked_data_rec.STOWAGE_POSITION
                        , CONTAINER_GROSS_WEIGHT = l_cur_booked_data_rec.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                        , RECORD_CHANGE_USER = p_i_v_user_id -- added 14.12.2011,  update by vikas as, chatgamol
                        , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS') -- added 14.12.2011,  update by vikas as, chatgamol
                    WHERE
                        FK_BOOKING_NO = l_v_booking_no
                        AND FK_BKG_EQUIPM_DTL = l_v_bkg_equipm_dtl
                        AND FK_BKG_VOYAGE_ROUTING_DTL = l_v_bkg_voyage_routing_dtl
                        AND DISCHARGE_STATUS <> 'DI'
                        AND RECORD_STATUS='A';

                ELSE
                    /* Normal Case Check equipment# in next discharge list and update stowage
                        possition in next discharge list. */
                    /*Start added by vikas as logic is changed, 22.11.2011*/
                    PCE_EDL_DLMAINTENANCE.PRE_NEXT_DISCHARGE_LIST_ID(
                          l_cur_booked_data_rec.FK_BOOKING_NO
                        , l_cur_booked_data_rec.DN_EQUIPMENT_NO
                        , l_cur_booked_data_rec.DN_DISCHARGE_TERMINAL
                        , l_cur_booked_data_rec.DN_DISCHARGE_PORT
                        , l_v_discharge_list_id
                        , l_v_flag
                        , p_o_v_err_cd
                    );
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

                    IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                        RETURN;
                    END IF;

                    IF(l_v_flag = 'D') THEN
                        /* GET LOCK ON TABLE*/
                        BEGIN
                            SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
                            INTO l_v_lock_data
                            FROM TOS_DL_BOOKED_DISCHARGE
                            WHERE PK_BOOKED_DISCHARGE_ID = l_v_discharge_list_id
                            -- AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012 -- *1
                            FOR UPDATE NOWAIT;

                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
                            RETURN;
                        WHEN OTHERS THEN
                            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                            RETURN;
                        END;
                        /* update record in booked discharge list table */
                        UPDATE
                            TOS_DL_BOOKED_DISCHARGE
                        SET
                            STOWAGE_POSITION   = l_cur_booked_data_rec.STOWAGE_POSITION
                            , CONTAINER_GROSS_WEIGHT = l_cur_booked_data_rec.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                            , RECORD_CHANGE_USER = p_i_v_user_id
                            , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                        WHERE
                            PK_BOOKED_DISCHARGE_ID = l_v_discharge_list_id
                            -- AND DISCHARGE_STATUS <> 'DI'; -- *1
                            AND (STOWAGE_POSITION IS NULL OR DISCHARGE_STATUS <> 'DI'); -- *1
                    END IF;
                END IF;
            END IF;

            IF(l_cur_booked_data_rec.DAMAGED = 'Y') THEN
                /* Check if equipment# is changed then update new equipment no# in container replacement table. */
                SELECT NVL(DN_EQUIPMENT_NO,'~')
                INTO l_v_old_equipment_no
                FROM tos_ll_booked_loading
                WHERE PK_BOOKED_LOADING_ID = l_cur_booked_data_rec.PK_BOOKED_LOADING_ID;

                IF(l_v_old_equipment_no != l_cur_booked_data_rec.DN_EQUIPMENT_NO) THEN
                    /* Eqipment# has changed. */

                    /* Get pk for BKG_CONTAINER_REPLACEMENT table. */
                    SELECT SE_CRZ01.NEXTVAL
                    INTO l_v_pk_cont_repl_id
                    FROM DUAL;

                    /* Get the terminal from Load list */
                    SELECT DN_TERMINAL
                    INTO l_v_terminal
                    FROM tos_ll_load_list
                    WHERE PK_LOAD_LIST_ID = l_cur_booked_data_rec.FK_LOAD_LIST_ID;

                    INSERT INTO BKG_CONTAINER_REPLACEMENT(
                          PK_CONTAINER_REPLACEMENT_ID
                        , DATE_OF_REPLACEMENT
                        , TERMINAL
                        , FK_BOOKING_NO
                        , OLD_EQUIPMENT_NO
                        , FK_BKG_SIZE_TYPE_DTL
                        , FK_BKG_SUPPLIER
                        , FK_BKG_EQUIPM_DTL
                        , NEW_EQUIPMENT_NO
                        , OLD_SEAL_NO
                        , NEW_SEAL_NO
                        , REPLACEMENT_TYPE
                        , REASON
                        , RECORD_STATUS
                        , RECORD_ADD_USER
                        , RECORD_ADD_DATE
                        , RECORD_CHANGE_USER
                        , RECORD_CHANGE_DATE
                    )VALUES(
                          l_v_pk_cont_repl_id
                        , TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                        , l_v_terminal
                        , l_cur_booked_data_rec.FK_BOOKING_NO
                        , l_v_old_equipment_no
                        , l_cur_booked_data_rec.FK_BKG_SIZE_TYPE_DTL
                        , l_cur_booked_data_rec.FK_BKG_SUPPLIER
                        , l_cur_booked_data_rec.FK_BKG_EQUIPM_DTL
                        , l_cur_booked_data_rec.DN_EQUIPMENT_NO
                        , ''
                        , ''
                        , l_v_replacement_type
                        , 'DAMAGED_CONTAINER'
                        , 'A'
                        , p_i_v_user_id
                        , TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                        , p_i_v_user_id
                        , TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                    );
                END IF;

            END IF;

            -- Call Synchronization with Booking
            PRE_ELL_SYNCH_BOOKING(
                  l_cur_booked_data_rec.PK_BOOKED_LOADING_ID
                , l_cur_booked_data_rec.FK_BKG_EQUIPM_DTL
                , l_cur_booked_data_rec.DN_EQUIPMENT_NO
                , l_cur_booked_data_rec.FK_BOOKING_NO
                , l_cur_booked_data_rec.OVERWIDTH_LEFT_CM
                , l_cur_booked_data_rec.OVERHEIGHT_CM
                , l_cur_booked_data_rec.OVERWIDTH_RIGHT_CM
                , l_cur_booked_data_rec.OVERLENGTH_FRONT_CM
                , l_cur_booked_data_rec.OVERLENGTH_REAR_CM
                , l_cur_booked_data_rec.FK_IMDG
                , l_cur_booked_data_rec.FK_UNNO
                , l_cur_booked_data_rec.FK_UN_VAR
                , l_cur_booked_data_rec.FLASH_POINT
                , l_cur_booked_data_rec.FLASH_UNIT
                , l_cur_booked_data_rec.REEFER_TMP_UNIT
                , l_cur_booked_data_rec.REEFER_TMP
                , l_cur_booked_data_rec.DN_HUMIDITY
                , l_cur_booked_data_rec.CONTAINER_GROSS_WEIGHT
                , l_cur_booked_data_rec.DN_VENTILATION
                , p_o_v_err_cd
            );

            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;

            SELECT COUNT(1)
            INTO   l_v_rec_count
            FROM   TOS_LL_BOOKED_LOADING
            WHERE  PK_BOOKED_LOADING_ID   = l_cur_booked_data_rec.PK_BOOKED_LOADING_ID
            AND    LOADING_STATUS         = l_cur_booked_data_rec.LOADING_STATUS
            AND    RECORD_STATUS = 'A'; -- modified 14.02.2012

            /* Loading status is changed then update in DL */
            IF(l_v_rec_count = 0) THEN

                /*
                    Start Changes by vikas, some time it is not updating
                    the correct discharge list, as k'chatgamol, 13.12.2011
                */

                /*
                    Get the load port and load termina from header table
                */
                SELECT
                    DN_PORT,
                    DN_TERMINAL
                INTO
                    l_v_dn_port
                    , l_v_dn_terminal
                FROM
                    VASAPPS.TOS_LL_LOAD_LIST
                WHERE
                    PK_LOAD_LIST_ID = l_cur_booked_data_rec.FK_LOAD_LIST_ID;

                /*
                    Get lock on the table.
                */
                BEGIN
                    SELECT
                        TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
                    INTO
                        l_v_lock_data
                    FROM
                        TOS_DL_BOOKED_DISCHARGE
                    WHERE
                        FK_BOOKING_NO  = l_cur_booked_data_rec.FK_BOOKING_NO
                        AND  DN_EQUIPMENT_NO = l_cur_booked_data_rec.DN_EQUIPMENT_NO
                        AND DN_POL = l_v_dn_port
                        AND DN_POL_TERMINAL = l_v_dn_terminal
                        AND RECORD_STATUS = 'A'    -- ADDED 06.02.2012
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
                    UPDATE
                        TOS_DL_BOOKED_DISCHARGE
                    SET
                          DN_LOADING_STATUS      = l_cur_booked_data_rec.LOADING_STATUS
                        , STOWAGE_POSITION       = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', l_cur_booked_data_rec.STOWAGE_POSITION, STOWAGE_POSITION)
                        , CONTAINER_GROSS_WEIGHT = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', l_cur_booked_data_rec.CONTAINER_GROSS_WEIGHT, CONTAINER_GROSS_WEIGHT)
                        -- block start by vikas, 20.02.2012
                        , MLO_VESSEL             = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', l_cur_booked_data_rec.MLO_VESSEL, MLO_VESSEL)
                        , MLO_VOYAGE             = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', l_cur_booked_data_rec.MLO_VOYAGE, MLO_VOYAGE)
                        , MLO_VESSEL_ETA         = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', TO_DATE(l_cur_booked_data_rec.MLO_VESSEL_ETA,'DD/MM/YYYY HH24:MI'), MLO_VESSEL_ETA)
                        , MLO_POD1               = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', l_cur_booked_data_rec.MLO_POD1, MLO_POD1)
                        , MLO_POD2               = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', l_cur_booked_data_rec.MLO_POD2, MLO_POD2)
                        , MLO_POD3               = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', l_cur_booked_data_rec.MLO_POD3, MLO_POD3)
                        , MLO_DEL                = DECODE(l_cur_booked_data_rec.LOADING_STATUS, 'LO', l_cur_booked_data_rec.MLO_DEL, MLO_DEL)
                        -- block end by vikas, 20.02.2012
                        , RECORD_CHANGE_USER     = p_i_v_user_id
                        , RECORD_CHANGE_DATE     = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                    WHERE
                        FK_BOOKING_NO  = l_cur_booked_data_rec.FK_BOOKING_NO
                        AND  DN_EQUIPMENT_NO = l_cur_booked_data_rec.DN_EQUIPMENT_NO
                        AND DN_POL = l_v_dn_port
                        AND DN_POL_TERMINAL = l_v_dn_terminal
                        AND RECORD_STATUS = 'A'
                        AND DISCHARGE_STATUS <> 'DI'; -- added by vikas, 17.02.2012
                EXCEPTION -- added 14.02.2012
                    WHEN OTHERS THEN
                        NULL;
                END ;

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
            PRE_EDL_POD_UPDATE(
                  l_cur_booked_data_rec.PK_BOOKED_LOADING_ID
                , l_cur_booked_data_rec.FK_BOOKING_NO
                ,  LL_DL_FLAG
                , l_cur_booked_data_rec.FK_BKG_VOYAGE_ROUTING_DTL
                , l_cur_booked_data_rec.LOAD_CONDITION
                , l_cur_booked_data_rec.CONTAINER_GROSS_WEIGHT
                , l_cur_booked_data_rec.DAMAGED
                , l_cur_booked_data_rec.FK_CONTAINER_OPERATOR
                , l_cur_booked_data_rec.OUT_SLOT_OPERATOR
                , l_cur_booked_data_rec.SEAL_NO
                , l_cur_booked_data_rec.MLO_VESSEL
                , l_cur_booked_data_rec.MLO_VOYAGE
                , to_date(l_cur_booked_data_rec.MLO_VESSEL_ETA,'dd/mm/yyyy hh24:mi')
                , l_cur_booked_data_rec.MLO_POD1
                , l_cur_booked_data_rec.MLO_POD2
                , l_cur_booked_data_rec.MLO_POD3
                , l_cur_booked_data_rec.MLO_DEL
                , l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_1
                , l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_2
                , l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_3
                , l_cur_booked_data_rec.CONTAINER_LOADING_REM_1
                , l_cur_booked_data_rec.CONTAINER_LOADING_REM_2
                , l_cur_booked_data_rec.TIGHT_CONNECTION_FLAG1
                , l_cur_booked_data_rec.TIGHT_CONNECTION_FLAG2
                , l_cur_booked_data_rec.TIGHT_CONNECTION_FLAG3
                , l_cur_booked_data_rec.FUMIGATION_ONLY
                , l_cur_booked_data_rec.RESIDUE_ONLY_FLAG
                , l_cur_booked_data_rec.FK_BKG_SIZE_TYPE_DTL
                , l_cur_booked_data_rec.FK_BKG_SUPPLIER
                , l_cur_booked_data_rec.FK_BKG_EQUIPM_DTL
                , p_o_v_err_cd
            );
            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;


            /* Get lock on the table. */
            PCV_ELL_RECORD_LOCK(  l_cur_booked_data_rec.PK_BOOKED_LOADING_ID
                                , TO_CHAR(l_cur_booked_data_rec.RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                                , 'BOOKED'
                                , p_o_v_err_cd);

            IF ((p_o_v_err_cd IS NULL) OR (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD )) THEN
                RETURN;
            END IF ;
			--*26 , *27 start
			--Log port class change
			PRE_LOG_PORTCLASS_CHANGE(l_cur_booked_data_rec.PK_BOOKED_LOADING_ID,
                               l_cur_booked_data_rec.FK_PORT_CLASS,
                               l_cur_booked_data_rec.FK_IMDG,
                               l_cur_booked_data_rec.FK_UNNO,
						                   l_cur_booked_data_rec.FK_UN_VAR,
						                   'L',
						                   P_I_V_USER_ID 
						                  );
			--*26 end 
            UPDATE TOS_LL_BOOKED_LOADING SET
                  DN_EQUIPMENT_NO = l_cur_booked_data_rec.DN_EQUIPMENT_NO
                , LOCAL_TERMINAL_STATUS = l_cur_booked_data_rec.LOCAL_TERMINAL_STATUS
                , MIDSTREAM_HANDLING_CODE = l_cur_booked_data_rec.MIDSTREAM_HANDLING_CODE
                , LOAD_CONDITION = l_cur_booked_data_rec.LOAD_CONDITION
                , LOADING_STATUS = l_cur_booked_data_rec.LOADING_STATUS
                , STOWAGE_POSITION = l_cur_booked_data_rec.STOWAGE_POSITION
                , ACTIVITY_DATE_TIME= TO_DATE(l_cur_booked_data_rec.ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
                , CONTAINER_GROSS_WEIGHT = l_cur_booked_data_rec.CONTAINER_GROSS_WEIGHT
                , DAMAGED = l_cur_booked_data_rec.DAMAGED
                , FK_CONTAINER_OPERATOR = l_cur_booked_data_rec.FK_CONTAINER_OPERATOR
                , OUT_SLOT_OPERATOR = l_cur_booked_data_rec.OUT_SLOT_OPERATOR
                , SEAL_NO = l_cur_booked_data_rec.SEAL_NO
                , MLO_VESSEL = l_cur_booked_data_rec.MLO_VESSEL
                , MLO_VOYAGE = l_cur_booked_data_rec.MLO_VOYAGE
                , MLO_VESSEL_ETA = TO_DATE(l_cur_booked_data_rec.MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
                , MLO_POD1 = l_cur_booked_data_rec.MLO_POD1
                , MLO_POD2 = l_cur_booked_data_rec.MLO_POD2
                , MLO_POD3 = l_cur_booked_data_rec.MLO_POD3
                , FK_HANDLING_INSTRUCTION_1 = l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_1
                , FK_HANDLING_INSTRUCTION_2 = l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_2
                , FK_HANDLING_INSTRUCTION_3 = l_cur_booked_data_rec.FK_HANDLING_INSTRUCTION_3
                , CONTAINER_LOADING_REM_1 = l_cur_booked_data_rec.CONTAINER_LOADING_REM_1
                , CONTAINER_LOADING_REM_2 = l_cur_booked_data_rec.CONTAINER_LOADING_REM_2
                , TIGHT_CONNECTION_FLAG1 = l_cur_booked_data_rec.TIGHT_CONNECTION_FLAG1
                , TIGHT_CONNECTION_FLAG2 = l_cur_booked_data_rec.TIGHT_CONNECTION_FLAG2
                , TIGHT_CONNECTION_FLAG3 = l_cur_booked_data_rec.TIGHT_CONNECTION_FLAG3
                , FK_IMDG = l_cur_booked_data_rec.FK_IMDG
                , FK_UNNO = l_cur_booked_data_rec.FK_UNNO
                , FK_UN_VAR = l_cur_booked_data_rec.FK_UN_VAR
                , FK_PORT_CLASS = l_cur_booked_data_rec.FK_PORT_CLASS
                , FK_PORT_CLASS_TYP = l_cur_booked_data_rec.FK_PORT_CLASS_TYP
                , FLASH_UNIT = l_cur_booked_data_rec.FLASH_UNIT
                , FLASH_POINT = l_cur_booked_data_rec.FLASH_POINT
                , FUMIGATION_ONLY = l_cur_booked_data_rec.FUMIGATION_ONLY
                , OVERHEIGHT_CM = l_cur_booked_data_rec.OVERHEIGHT_CM
                , OVERWIDTH_LEFT_CM = l_cur_booked_data_rec.OVERWIDTH_LEFT_CM
                , OVERWIDTH_RIGHT_CM = l_cur_booked_data_rec.OVERWIDTH_RIGHT_CM
                , OVERLENGTH_FRONT_CM = l_cur_booked_data_rec.OVERLENGTH_FRONT_CM
                , OVERLENGTH_REAR_CM = l_cur_booked_data_rec.OVERLENGTH_REAR_CM
                , REEFER_TMP = l_cur_booked_data_rec.REEFER_TMP
                , REEFER_TMP_UNIT = l_cur_booked_data_rec.REEFER_TMP_UNIT
                , DN_HUMIDITY = l_cur_booked_data_rec.DN_HUMIDITY
                , PUBLIC_REMARK = l_cur_booked_data_rec.PUBLIC_REMARK
                , RECORD_CHANGE_USER = p_i_v_user_id
                , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                , LOCAL_STATUS = l_cur_booked_data_rec.LOCAL_STATUS
                , EX_MLO_VESSEL = l_cur_booked_data_rec.EX_MLO_VESSEL
                , EX_MLO_VESSEL_ETA = TO_DATE(l_cur_booked_data_rec.EX_MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
                , EX_MLO_VOYAGE = l_cur_booked_data_rec.EX_MLO_VOYAGE
                , DN_VENTILATION = l_cur_booked_data_rec.DN_VENTILATION
                , MLO_DEL = l_cur_booked_data_rec.MLO_DEL
                , RESIDUE_ONLY_FLAG = l_cur_booked_data_rec.RESIDUE_ONLY_FLAG
                 , CRANE_TYPE = l_cur_booked_data_rec.CRAN_DESCRIPTION-- *8
            WHERE PK_BOOKED_LOADING_ID = l_cur_booked_data_rec.PK_BOOKED_LOADING_ID;
        END IF;

        /* update booking status count in tos_ll_load_list table */
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
            TO_NUMBER(l_cur_booked_data_rec.FK_LOAD_LIST_ID)
            , LL_DL_FLAG
            , p_o_v_err_cd
        );

        IF(p_o_v_err_cd = 0 ) THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        ELSE
          --  p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            /* Error in Sync Booking Status count */
            p_o_v_err_cd := 'EDL.SE0180';
            RETURN;
        END IF;




      -- Increment row number.
      IF (l_cur_booked_data_rec.OPN_STATUS IS NULL OR l_cur_booked_data_rec.OPN_STATUS <> PCE_EUT_COMMON.G_V_REC_DEL) THEN
        l_v_booked_row_num := l_v_booked_row_num + 1;
      END IF;
    END LOOP;

    IF (l_v_errors IS NOT NULL AND (l_v_errors != PCE_EUT_COMMON.G_V_SUCCESS_CD
        AND   p_o_v_err_cd != PCE_EUT_COMMON.G_V_GE0005
        AND  p_o_v_err_cd != PCE_EUT_COMMON.G_V_GE0002)) THEN
            p_o_v_err_cd := l_v_errors;
            RETURN;
    END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RETURN;
    END PRE_ELL_SAVE_BOOKED_TAB_MAIN;

    PROCEDURE PRE_ELL_BOOKED_VALIDATION(
          p_i_v_session_id          VARCHAR2
        , p_i_row_num               NUMBER
        , p_i_v_load_list_id        VARCHAR2
        , p_i_v_equipment_no        VARCHAR2
        , p_i_v_pk_load_list        VARCHAR2
        , p_i_v_clr_code1           VARCHAR2
        , p_i_v_clr_code2           VARCHAR2
        , p_i_v_oper_cd             VARCHAR2
        , p_i_v_unno                VARCHAR2
        , p_i_v_port_code           VARCHAR2
        , p_i_v_variant             VARCHAR2
        , p_i_v_imdg                VARCHAR2
        , p_i_v_shi_code1           VARCHAR2
        , p_i_v_shi_code2           VARCHAR2
        , p_i_v_shi_code3           VARCHAR2
        , p_i_v_port_class          VARCHAR2
        , p_i_v_port_class_type     VARCHAR2
        , p_i_v_SLOT_OPERATOR       VARCHAR2
        , p_i_v_OUT_SLOT_OPERATOR   VARCHAR2
        , p_i_v_DN_SOC_COC          VARCHAR2
        , p_i_v_load_etd            VARCHAR2
        , p_i_v_hdr_etd_tm          VARCHAR2
        , p_o_v_err_cd              OUT VARCHAR2
    ) AS

            l_v_errors         VARCHAR2(2000);
            l_v_record_count NUMBER := 0;
            l_v_shipment_typ            TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP%TYPE; -- *2

    BEGIN
            -- Set the error code to its default value (0000);
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

            SELECT COUNT(1)
            INTO   l_v_record_count
            FROM   TOS_LL_BOOKED_LOADING_TMP
            WHERE  FK_LOAD_LIST_ID       = p_i_v_load_list_id
            AND    DN_EQUIPMENT_NO       = p_i_v_equipment_no
            AND    PK_BOOKED_LOADING_ID != p_i_v_pk_load_list
            AND    SESSION_ID             = p_i_v_session_id;

            -- When count is more then zero means record is already availabe, show error
            IF(l_v_record_count > 0) THEN
                p_o_v_err_cd := 'ELL.SE0127' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;

                /*
                    *2 : Changes starts

                *
                    Get the shipment type for the booking#
                */
                BEGIN
                    l_v_shipment_typ := NULL;
                    SELECT
                        DN_SHIPMENT_TYP
                    INTO
                        l_v_shipment_typ
                    FROM
                        TOS_LL_BOOKED_LOADING
                    WHERE
                        PK_BOOKED_LOADING_ID = p_i_v_pk_load_list;

                EXCEPTION
                    WHEN OTHERS THEN
                        l_v_shipment_typ := NULL;
                END;
                /*
                    *2 : Changes end
                */

            /* Check if old container was COC container then changed container should also be COC container*/
            IF (p_i_v_DN_SOC_COC = 'C')  AND (NVL(l_v_shipment_typ, '*') <> 'UC' )THEN -- *2

                IF p_i_v_equipment_no IS NOT NULL THEN
                    /* Equipment Type should be COC */
                    IF(PCE_EUT_COMMON.FN_CHECK_COC_FLAG (
                              p_i_v_equipment_no
                            , p_i_v_port_code
                            , p_i_v_load_etd
                            , p_i_v_hdr_etd_tm
                            , p_o_v_err_cd
                        )                   = FALSE) THEN
                        p_o_v_err_cd := 'EDL.SE0132'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                        RETURN;
                    END IF;

                END IF;

            END IF;

        /* Check for the Container Loading Remark Code1 in dolphin master table. */
            PRE_ELL_OL_VAL_CLR_CODE(p_i_v_clr_code1, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

         /* Check for the Container Loading Remark Code2 in dolphin master table. */
            PRE_ELL_OL_VAL_CLR_CODE(p_i_v_clr_code2, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

            IF p_i_v_DN_SOC_COC = 'C' THEN
        /* Check for the Slot Operator in OPERATOR_CODE Master Table. */
            PRE_ELL_OL_VAL_OPERATOR_CODE( p_i_v_SLOT_OPERATOR , p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Check for the Container Operator in OPERATOR_CODE Master Table */
            PRE_ELL_OL_VAL_OPERATOR_CODE( p_i_v_oper_cd, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Check for the Out Slot Operator in OPERATOR_CODE Master Table.
            PRE_ELL_OL_VAL_OPERATOR_CODE( p_i_v_OUT_SLOT_OPERATOR, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;
        */

            END IF;
        /*    Handling Instruction Code1 validation */
            PRE_ELL_OL_VAL_HAND_CODE(p_i_v_shi_code1, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /*    Handling Instruction Code2 validation */
            PRE_ELL_OL_VAL_HAND_CODE(p_i_v_shi_code2, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /*    Handling Instruction Code3 validation */
            PRE_ELL_OL_VAL_HAND_CODE(p_i_v_shi_code3, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Check for the IMDG Code in IMDG Master Table. */
            PRE_ELL_OL_VAL_IMDG(p_i_v_unno, p_i_v_variant, p_i_v_imdg, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Validate UN Number and UN Number Variant */
            PRE_ELL_OL_VAL_UNNO(p_i_v_unno, p_i_v_variant, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            end if ;

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
            PRE_ELL_OL_VAL_PORT_CLASS_TYPE( p_i_v_port_code, p_i_v_port_class_type, p_i_v_equipment_no, p_o_v_err_cd);
             IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                return;
             END IF ;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN;

    END PRE_ELL_BOOKED_VALIDATION;

    PROCEDURE PRE_ELL_SYNCH_BOOKING(
          p_i_v_pk_booked_id           VARCHAR2
        , p_i_v_container_seq_no       VARCHAR2
        , p_i_v_dn_equipment_no        VARCHAR2
        , p_i_v_fk_booking_no          VARCHAR2
        , p_i_v_overwidth_left_cm      VARCHAR2
        , p_i_v_overheight_cm          VARCHAR2
        , p_i_v_overwidth_right_cm     VARCHAR2
        , p_i_v_overlength_front_cm    VARCHAR2
        , p_i_v_overlength_rear_cm     VARCHAR2
        , p_i_v_fk_imdg                VARCHAR2
        , p_i_v_fk_unno                VARCHAR2
        , p_i_v_fk_un_var              VARCHAR2
        , p_i_v_flash_point            VARCHAR2
        , p_i_v_flash_unit             VARCHAR2
        , p_i_v_reefer_tmp_unit        VARCHAR2
        , p_i_v_temperature            VARCHAR2
        , p_i_v_dn_humidity            VARCHAR2
        , p_i_v_weight                 VARCHAR2
        , p_i_v_dn_ventilation         VARCHAR2
        , p_o_v_err_cd                 OUT NOCOPY VARCHAR2
    )AS
        l_v_bookingNo                  VARCHAR2(17);
        l_n_equipmentSeqNo             NUMBER;
        l_v_equipNo                    VARCHAR2(12);
        l_n_overHeight                 NUMBER;
        l_n_overlengthRear             NUMBER;
        l_n_overlengthFront            NUMBER;
        l_n_overwidthLeft              NUMBER;
        l_n_overwidthRight             NUMBER;
        l_v_imdg                       VARCHAR2(4);
        l_v_unno                       VARCHAR2(6);
        l_v_unVar                      VARCHAR2(1);
        l_v_flashPoint                 VARCHAR2(7);
        l_v_flashUnit                  VARCHAR2(1);
        l_v_reeferTmp                  VARCHAR2(8);
        l_v_reeferTmpUnit              VARCHAR2(1);
        l_n_humidity                   NUMBER;
        l_n_GrossWt                    NUMBER;
        l_n_dn_ventilation             NUMBER;

    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        SELECT
              DN_EQUIPMENT_NO
            , OVERWIDTH_LEFT_CM
            , OVERHEIGHT_CM
            , OVERWIDTH_RIGHT_CM
            , OVERLENGTH_FRONT_CM
            , OVERLENGTH_REAR_CM
            , FK_IMDG
            , FK_UNNO
            , FK_UN_VAR
            , FLASH_POINT
            , FLASH_UNIT
            , REEFER_TMP_UNIT
            , REEFER_TMP
            , DN_HUMIDITY
            , CONTAINER_GROSS_WEIGHT
            , DN_VENTILATION
        INTO
              l_v_equipNo
            , l_n_overwidthLeft
            , l_n_overHeight
            , l_n_overwidthRight
            , l_n_overlengthFront
            , l_n_overlengthRear
            , l_v_imdg
            , l_v_unno
            , l_v_unVar
            , l_v_flashPoint
            , l_v_flashUnit
            , l_v_reeferTmpUnit
            , l_v_reeferTmp
            , l_n_humidity
            , l_n_GrossWt
            , l_n_dn_ventilation
        FROM  TOS_LL_BOOKED_LOADING
        WHERE PK_BOOKED_LOADING_ID = p_i_v_pk_booked_id;

        -- check the value of passed data from db value
        IF(NVL(p_i_v_dn_equipment_no,'~') <> NVL(l_v_equipNo,'~')) THEN
          l_v_equipNo := NVL(p_i_v_dn_equipment_no,'~');
        ELSE
          l_v_equipNo := NULL;
        END IF;

            IF(NVL(TO_NUMBER(p_i_v_overwidth_left_cm),0) <> NVL(l_n_overwidthLeft,0)) THEN
          l_n_overwidthLeft := NVL(p_i_v_overwidth_left_cm,0);
        ELSE
          l_n_overwidthLeft := NULL;
        END IF;

        IF(NVL(TO_NUMBER(p_i_v_overheight_cm),0) <> NVL(l_n_overHeight,0)) THEN
          l_n_overHeight := NVL(p_i_v_overheight_cm,0);
        ELSE
          l_n_overHeight := NULL;
        END IF;

            IF(NVL(TO_NUMBER(p_i_v_overwidth_right_cm),0) <> NVL(l_n_overwidthRight,0)) THEN
          l_n_overwidthRight := NVL(p_i_v_overwidth_right_cm,0);
        ELSE
          l_n_overwidthRight := NULL;
        END IF;

        IF(NVL(TO_NUMBER(p_i_v_overlength_front_cm),0) <> NVL(l_n_overlengthFront,0)) THEN
          l_n_overlengthFront := NVL(p_i_v_overlength_front_cm,0);
        ELSE
          l_n_overlengthFront := NULL;
        END IF;

            IF(NVL(TO_NUMBER(p_i_v_overlength_rear_cm),0) <> NVL(l_n_overlengthRear,0)) THEN
          l_n_overlengthRear := NVL(p_i_v_overlength_rear_cm,0);
        ELSE
          l_n_overlengthRear := NULL;
        END IF;

        IF(NVL(p_i_v_fk_imdg,'~') <> NVL(l_v_imdg,'~')) THEN
          l_v_imdg := NVL(p_i_v_fk_imdg,'~');
        ELSE
          l_v_imdg := NULL;
        END IF;

        IF(NVL(p_i_v_fk_unno,' ') <> NVL(l_v_unno,' ')) THEN
          l_v_unno := NVL(p_i_v_fk_unno,'~');
        ELSE
          l_v_unno := NULL;
        END IF;

        IF(NVL(p_i_v_fk_un_var,'~') <> NVL(l_v_unVar,'~')) THEN
          l_v_unVar := NVL(p_i_v_fk_un_var,'~');
        ELSE
          l_v_unVar := NULL;
        END IF;

        IF(NVL(TO_NUMBER(p_i_v_flash_point),0) <> NVL(TO_NUMBER(l_v_flashPoint),0)) THEN
            l_v_flashPoint := NVL(p_i_v_flash_point,'~');
        ELSE
            IF (p_i_v_flash_point IS NOT NULL AND l_v_flashPoint IS NULL) OR
                (p_i_v_flash_point IS NULL AND l_v_flashPoint IS NOT NULL) THEN
                -- Repalce with l_n_flashPoint := NULL if no need to trigger on change from Null to 0 and Vice Versa.
                l_v_flashPoint := NVL(p_i_v_flash_point,'~');
            ELSE
                l_v_flashPoint := NULL;
            END IF;
        END IF;

        IF(NVL(p_i_v_flash_unit,'~') <> NVL(l_v_flashUnit,'~')) THEN
          l_v_flashUnit := NVL(p_i_v_flash_unit,'~');
        ELSE
          l_v_flashUnit := NULL;
        END IF;

        IF(NVL(TO_NUMBER(p_i_v_temperature),0) <> NVL(TO_NUMBER(l_v_reeferTmp),0)) THEN
          l_v_reeferTmp := NVL(p_i_v_temperature,'~');
        ELSE

            IF (p_i_v_temperature IS NOT NULL AND l_v_reeferTmp IS NULL) OR
                (p_i_v_temperature IS NULL AND l_v_reeferTmp IS NOT NULL) THEN
                -- Repalce with l_n_flashPoint := NULL if no need to trigger on change from Null to 0 and Vice Versa.
                l_v_reeferTmp := NVL(p_i_v_temperature,'~');
            ELSE
              l_v_reeferTmp := NULL;
            END IF;

        END IF;

        IF(NVL(p_i_v_reefer_tmp_unit ,'~') <> NVL(l_v_reeferTmpUnit,'~')) THEN
          l_v_reeferTmpUnit := NVL(p_i_v_reefer_tmp_unit,'~');
        ELSE
          l_v_reeferTmpUnit := NULL;
        END IF;

        IF(NVL(TO_NUMBER(p_i_v_dn_humidity),0) <> NVL(l_n_humidity,0)) THEN
          l_n_humidity := NVL(p_i_v_dn_humidity,0);
        ELSE
            IF (p_i_v_dn_humidity IS NOT NULL AND l_n_humidity IS NULL) OR
                 (p_i_v_dn_humidity IS NULL AND l_n_humidity IS NOT NULL) THEN
                l_n_humidity := 0;
            ELSE
                l_n_humidity := NULL;
            END IF;

        END IF;

        IF(NVL(TO_NUMBER(p_i_v_dn_ventilation),0) <> NVL(l_n_dn_ventilation,0)) THEN
          l_n_dn_ventilation := NVL(p_i_v_dn_ventilation,0);
        ELSE

            IF (p_i_v_dn_ventilation IS NOT NULL AND l_n_dn_ventilation IS NULL) OR
                (p_i_v_dn_ventilation IS NULL AND l_n_dn_ventilation IS NOT NULL)
                THEN
                l_n_dn_ventilation := 0;
            ELSE
                l_n_dn_ventilation := NULL;
            END IF;

        END IF;

        IF(NVL(TO_NUMBER(p_i_v_weight),0) <> NVL(l_n_GrossWt,0)) THEN
          l_n_GrossWt := NVL(p_i_v_weight,0);
        ELSE
            IF (p_i_v_weight IS NOT NULL AND l_n_GrossWt IS NULL) OR
                (p_i_v_weight IS NULL AND l_n_GrossWt IS NOT NULL)
                THEN
                l_n_GrossWt := 0;
            ELSE
                l_n_GrossWt := NULL;
            END IF;
        END IF;

        PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_EQUIPMENT_UPDATE
        (
              p_i_v_fk_booking_no
            , p_i_v_container_seq_no
            , l_v_equipNo
            , l_n_overHeight
            , l_n_overlengthRear
            , l_n_overlengthFront
            , l_n_overwidthLeft
            , l_n_overwidthRight
            , l_v_imdg
            , l_v_unno
            , l_v_unVar
            , l_v_flashPoint
            , l_v_flashUnit
            , l_v_reeferTmp
            , l_v_reeferTmpUnit
            , l_n_humidity
            , l_n_GrossWt
            , l_n_dn_ventilation
            , p_o_v_err_cd
        );
        IF(p_o_v_err_cd = '0' ) THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        ELSE
            /* Error in Synchronization Equipment Update */
            p_o_v_err_cd := 'EDL.SE0179';
            RETURN;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_SYNCH_BOOKING;

    PROCEDURE PRE_ELL_SAVE_OVERSHIP_TAB_MAIN(
          p_i_v_session_id              IN VARCHAR2
        , p_i_v_user_id              IN VARCHAR2
        , p_i_v_vessel               IN VARCHAR2
        , p_i_v_eta                  IN VARCHAR2
        , p_i_v_hdr_eta_tm           IN VARCHAR2
        , p_i_v_port_code            IN VARCHAR2
        , p_i_v_date                 IN VARCHAR2
        , p_i_v_load_etd             IN VARCHAR2
        , p_i_v_hdr_etd_tm           IN VARCHAR2
        , p_o_v_err_cd               OUT VARCHAR2
    ) AS
        l_v_load_condition           VARCHAR2(1);
        l_v_lock_data                VARCHAR2(14);
        l_v_errors                   VARCHAR2(2000);
        l_v_overshipped_container_id NUMBER:= 0;
        l_n_restow_id                NUMBER:= 0;
        l_v_overshipped_row_num      NUMBER:= 1;
        l_v_fk_bkg_size_type_dtl     NUMBER;
        l_v_fk_bkg_supplier          NUMBER;
        l_v_fk_bkg_equipm_dtl        NUMBER;
        l_v_dn_shipment_term         VARCHAR2(4);
        l_v_dn_shipment_typ          VARCHAR2(3);
        l_v_discharge_list_id        NUMBER;
        l_v_load_list_id             NUMBER;
        l_v_flag                     VARCHAR2(1);
        exp_error_on_save            EXCEPTION;
        l_v_record_count             NUMBER := 0;
        l_v_container_operator       VARCHAR2(4);

    /* Cursor to save overshipped tab data */
    CURSOR l_cur_overshipped_data IS
        SELECT
          SEQ_NO                            ,
          PK_OVERSHIPPED_CONTAINER_ID       ,
          FK_LOAD_LIST_ID                   ,
          BOOKING_NO                        ,
          BOOKING_NO_SOURCE                 ,
          EQUIPMENT_NO                      ,
          EQUIPMENT_NO_QUESTIONABLE_FLAG    ,
          EQ_SIZE                           ,
          EQ_TYPE                           ,
          FULL_MT                           ,
          BKG_TYP                           ,
          FLAG_SOC_COC                      ,
          SHIPMENT_TERM                     ,
          SHIPMENT_TYPE                     ,
          LOCAL_STATUS                      ,
          LOCAL_TERMINAL_STATUS             ,
          MIDSTREAM_HANDLING_CODE           ,
          LOAD_CONDITION                    ,
          LOADING_STATUS                    ,
          STOWAGE_POSITION                  ,
          ACTIVITY_DATE_TIME                ,
          CONTAINER_GROSS_WEIGHT            ,
          DAMAGED                           ,
          VOID_SLOT                         ,
          PREADVICE_FLAG                    ,
          SLOT_OPERATOR                     ,
          CONTAINER_OPERATOR                ,
          OUT_SLOT_OPERATOR                 ,
          SPECIAL_HANDLING                  ,
          SEAL_NO                           ,
          DISCHARGE_PORT                    ,
          POD_TERMINAL                      ,
          NXT_POD1                          ,
          NXT_POD2                          ,
          NXT_POD3                          ,
          FINAL_POD                         ,
          FINAL_DEST                        ,
          NXT_SRV                           ,
          NXT_VESSEL                        ,
          NXT_VOYAGE                        ,
          NXT_DIR                           ,
          MLO_VESSEL                        ,
          MLO_VOYAGE                        ,
          MLO_VESSEL_ETA                    ,
          MLO_POD1                          ,
          MLO_POD2                          ,
          MLO_POD3                          ,
          MLO_DEL                           ,
          EX_MLO_VESSEL                     ,
          EX_MLO_VESSEL_ETA                 ,
          EX_MLO_VOYAGE                     ,
          HANDLING_INSTRUCTION_1            ,
          HANDLING_INSTRUCTION_2            ,
          HANDLING_INSTRUCTION_3            ,
          CONTAINER_LOADING_REM_1           ,
          CONTAINER_LOADING_REM_2           ,
          SPECIAL_CARGO                     ,
          IMDG_CLASS                        ,
          UN_NUMBER                         ,
          UN_NUMBER_VARIANT                 ,
          PORT_CLASS                        ,
          PORT_CLASS_TYPE                   ,
          FLASHPOINT_UNIT                   ,
          FLASHPOINT                        ,
          FUMIGATION_ONLY                   ,
          RESIDUE_ONLY_FLAG                 ,
          OVERHEIGHT_CM                     ,
          OVERWIDTH_LEFT_CM                 ,
          OVERWIDTH_RIGHT_CM                ,
          OVERLENGTH_FRONT_CM               ,
          OVERLENGTH_REAR_CM                ,
          REEFER_TEMPERATURE                ,
          REEFER_TMP_UNIT                   ,
          HUMIDITY                          ,
          VENTILATION                       ,
          DA_ERROR                          ,
          OPN_STATUS                        ,
          DECODE(OPN_STATUS,PCE_EUT_COMMON.G_V_REC_DEL,'1') ORD_SEQ,
          RECORD_CHANGE_USER                ,
          RECORD_CHANGE_DATE
        FROM   TOS_LL_OVERSHIPPED_CONT_TMP
        WHERE  SESSION_ID=p_i_v_session_id
        ORDER BY ORD_SEQ, SEQ_NO;

    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        FOR l_cur_overshipped_data_rec IN l_cur_overshipped_data
        LOOP
            IF (l_cur_overshipped_data_rec.FLAG_SOC_COC = 'C') THEN
                l_v_container_operator := 'RCL';
            ELSE
                l_v_container_operator := l_cur_overshipped_data_rec.CONTAINER_OPERATOR;
            END IF;

        IF(l_cur_overshipped_data_rec.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_ADD) THEN

            SELECT SE_OCZ02.NEXTVAL
            INTO l_v_overshipped_container_id
            FROM DUAL;

            /* Call validation function for overshipped tab. */
            PRE_ELL_OVERSHIPPED_VALIDATION(
                p_i_v_session_id
              , l_v_overshipped_row_num
              , l_cur_overshipped_data_rec.FK_LOAD_LIST_ID
              , l_cur_overshipped_data_rec.EQUIPMENT_NO
              , l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID
              , l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_1
              , l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_2
              , l_v_container_operator
              , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_1
              , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_2
              , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_3
              , l_cur_overshipped_data_rec.UN_NUMBER
              , l_cur_overshipped_data_rec.UN_NUMBER_VARIANT
              , l_cur_overshipped_data_rec.IMDG_CLASS
              , p_i_v_port_code
              , l_cur_overshipped_data_rec.PORT_CLASS
              , l_cur_overshipped_data_rec.PORT_CLASS_TYPE
              , l_cur_overshipped_data_rec.OUT_SLOT_OPERATOR
              , l_cur_overshipped_data_rec.SLOT_OPERATOR
              , l_cur_overshipped_data_rec.SHIPMENT_TERM
              , l_cur_overshipped_data_rec.FLAG_SOC_COC
                 , p_i_v_load_etd
              , p_i_v_hdr_etd_tm
              , l_cur_overshipped_data_rec.EQ_TYPE
              , l_cur_overshipped_data_rec.DISCHARGE_PORT
              , l_cur_overshipped_data_rec.POD_TERMINAL
              , p_o_v_err_cd);

            /* Move data from temp table to main table.
            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;
            */

            IF(l_cur_overshipped_data_rec.LOADING_STATUS NOT IN ('OS')) THEN
                  SELECT COUNT(1)
                  INTO   l_v_record_count
                  FROM   TOS_RESTOW
                  WHERE  FK_LOAD_LIST_ID = l_cur_overshipped_data_rec.FK_LOAD_LIST_ID
                  AND    DN_EQUIPMENT_NO = l_cur_overshipped_data_rec.EQUIPMENT_NO;

                  -- When count is more then zero means record is already availabe, show error
                  IF(l_v_record_count > 0) THEN
                      p_o_v_err_cd := 'ELL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_cur_overshipped_data_rec.EQUIPMENT_NO ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                      RETURN;
                  END IF;

                    /*Start added by vikas as logic is changed, 22.11.2011*/
                    PCE_EDL_DLMAINTENANCE.PRE_PREV_LOAD_LIST_ID(
                          l_cur_overshipped_data_rec.BOOKING_NO
                        , l_cur_overshipped_data_rec.EQUIPMENT_NO
                        , l_cur_overshipped_data_rec.POD_TERMINAL
                        , l_cur_overshipped_data_rec.DISCHARGE_PORT
                        , l_v_load_list_id
                        , l_v_flag
                        , p_o_v_err_cd
                    );
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

                    IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND p_o_v_err_cd <> 'ELL.SE0121') THEN
                        RETURN;
                    END IF;
                    IF (p_o_v_err_cd = 'ELL.SE0121') THEN
                        g_v_warning   := 'ELL.SE0112'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_cur_overshipped_data_rec.EQUIPMENT_NO ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                        RETURN;
                    END IF;


                    IF (p_o_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

                        SELECT
                              FK_BKG_SIZE_TYPE_DTL
                            , FK_BKG_SUPPLIER
                            , FK_BKG_EQUIPM_DTL
                            , LOAD_CONDITION
                            , DN_SHIPMENT_TERM
                            , DN_SHIPMENT_TYP
                        INTO
                              l_v_fk_bkg_size_type_dtl
                            , l_v_fk_bkg_supplier
                            , l_v_fk_bkg_equipm_dtl
                            , l_v_load_condition
                            , l_v_dn_shipment_term
                            , l_v_dn_shipment_typ

                        FROM  TOS_LL_BOOKED_LOADING
                        WHERE PK_BOOKED_LOADING_ID = l_v_load_list_id;

                        SELECT SE_OCZ01.NEXTVAL
                        INTO l_n_restow_id
                        FROM DUAL;

                        INSERT INTO TOS_RESTOW
                        (
                            PK_RESTOW_ID
                          ,    FK_LOAD_LIST_ID
                          ,    FK_BOOKING_NO
                          ,    FK_BKG_SIZE_TYPE_DTL
                          ,    FK_BKG_SUPPLIER
                          ,    FK_BKG_EQUIPM_DTL
                          ,    DN_EQUIPMENT_NO
                          ,    DN_EQ_SIZE
                          ,    DN_EQ_TYPE
                          ,    DN_SOC_COC
                          ,    DN_SHIPMENT_TERM
                          ,    DN_SHIPMENT_TYP
                          ,    MIDSTREAM_HANDLING_CODE
                          ,    LOAD_CONDITION
                          ,    RESTOW_STATUS
                          ,    STOWAGE_POSITION
                          ,    CONTAINER_GROSS_WEIGHT
                          ,    DAMAGED
                          ,    VOID_SLOT
                          ,    FK_SLOT_OPERATOR
                          ,    FK_CONTAINER_OPERATOR
                          ,    DN_SPECIAL_HNDL
                          ,    SEAL_NO
                          ,    FK_SPECIAL_CARGO
                          ,    RECORD_STATUS
                          ,    RECORD_ADD_USER
                          ,    RECORD_ADD_DATE
                          ,    RECORD_CHANGE_USER
                          ,    RECORD_CHANGE_DATE
                        )
                        VALUES
                        (
                               l_n_restow_id
                          ,    l_cur_overshipped_data_rec.FK_LOAD_LIST_ID
                          ,    l_cur_overshipped_data_rec.BOOKING_NO
                          ,    l_v_fk_bkg_size_type_dtl
                          ,    l_v_fk_bkg_supplier
                          ,    l_v_fk_bkg_equipm_dtl
                          ,    l_cur_overshipped_data_rec.EQUIPMENT_NO
                          ,    l_cur_overshipped_data_rec.EQ_SIZE
                          ,    l_cur_overshipped_data_rec.EQ_TYPE
                          ,    l_cur_overshipped_data_rec.FLAG_SOC_COC
                          ,    l_v_dn_shipment_term
                          ,    l_v_dn_shipment_typ
                          ,    l_cur_overshipped_data_rec.MIDSTREAM_HANDLING_CODE
                          ,    l_v_load_condition
                          ,    l_cur_overshipped_data_rec.LOADING_STATUS
                          ,    l_cur_overshipped_data_rec.STOWAGE_POSITION
                          ,    l_cur_overshipped_data_rec.CONTAINER_GROSS_WEIGHT
                          ,    l_cur_overshipped_data_rec.DAMAGED
                          ,    l_cur_overshipped_data_rec.VOID_SLOT
                          ,    l_cur_overshipped_data_rec.SLOT_OPERATOR
                          ,    l_v_container_operator
                          ,    l_cur_overshipped_data_rec.SPECIAL_HANDLING
                          ,    l_cur_overshipped_data_rec.SEAL_NO
                          ,    l_cur_overshipped_data_rec.SPECIAL_CARGO
                          ,    'A'
                          ,    p_i_v_user_id
                          ,    TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                          ,    p_i_v_user_id
                          ,    TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                        );

                    END IF;

            ELSE

                INSERT INTO TOS_LL_OVERSHIPPED_CONTAINER (
                  PK_OVERSHIPPED_CONTAINER_ID
                , FK_LOAD_LIST_ID
                , BOOKING_NO
                , BOOKING_NO_SOURCE
                , EQUIPMENT_NO
                , EQ_SIZE
                , EQ_TYPE
                , FULL_MT
                , BKG_TYP
                , FLAG_SOC_COC
                , LOCAL_STATUS
                , LOCAL_TERMINAL_STATUS
                , MIDSTREAM_HANDLING_CODE
                , LOAD_CONDITION
                , STOWAGE_POSITION
                , ACTIVITY_DATE_TIME
                , CONTAINER_GROSS_WEIGHT
                , DAMAGED
                , VOID_SLOT
                , SLOT_OPERATOR
                , CONTAINER_OPERATOR
                , OUT_SLOT_OPERATOR
                , SPECIAL_HANDLING
                , SEAL_NO
                , DISCHARGE_PORT
                , POD_TERMINAL
                , MLO_VESSEL
                , MLO_VOYAGE
                , MLO_VESSEL_ETA
                , MLO_POD1
                , MLO_POD2
                , MLO_POD3
                , MLO_DEL
                , EX_MLO_VESSEL
                , EX_MLO_VESSEL_ETA
                , EX_MLO_VOYAGE
                , HANDLING_INSTRUCTION_1
                , HANDLING_INSTRUCTION_2
                , HANDLING_INSTRUCTION_3
                , CONTAINER_LOADING_REM_1
                , CONTAINER_LOADING_REM_2
                , SPECIAL_CARGO
                , IMDG_CLASS
                , UN_NUMBER
                , UN_NUMBER_VARIANT
                , PORT_CLASS
                , PORT_CLASS_TYPE
                , FLASHPOINT_UNIT
                , FLASHPOINT
                , FUMIGATION_ONLY
                , RESIDUE_ONLY_FLAG
                , OVERHEIGHT_CM
                , OVERWIDTH_LEFT_CM
                , OVERWIDTH_RIGHT_CM
                , OVERLENGTH_FRONT_CM
                , OVERLENGTH_REAR_CM
                , REEFER_TEMPERATURE
                , REEFER_TMP_UNIT
                , HUMIDITY
                , VENTILATION
                , RECORD_STATUS
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
                , RECORD_CHANGE_USER
                , RECORD_CHANGE_DATE
                )
                VALUES (
                  l_v_overshipped_container_id
                , l_cur_overshipped_data_rec.FK_LOAD_LIST_ID
                , l_cur_overshipped_data_rec.BOOKING_NO
                , l_cur_overshipped_data_rec.BOOKING_NO_SOURCE
                , l_cur_overshipped_data_rec.EQUIPMENT_NO
                , l_cur_overshipped_data_rec.EQ_SIZE
                , l_cur_overshipped_data_rec.EQ_TYPE
                , l_cur_overshipped_data_rec.FULL_MT
                , l_cur_overshipped_data_rec.BKG_TYP
                , l_cur_overshipped_data_rec.FLAG_SOC_COC
                , l_cur_overshipped_data_rec.LOCAL_STATUS
                , l_cur_overshipped_data_rec.LOCAL_TERMINAL_STATUS
                , l_cur_overshipped_data_rec.MIDSTREAM_HANDLING_CODE
                , l_cur_overshipped_data_rec.LOAD_CONDITION
                , l_cur_overshipped_data_rec.STOWAGE_POSITION
                , TO_DATE(l_cur_overshipped_data_rec.ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
                , l_cur_overshipped_data_rec.CONTAINER_GROSS_WEIGHT
                , l_cur_overshipped_data_rec.DAMAGED
                , l_cur_overshipped_data_rec.VOID_SLOT
                , l_cur_overshipped_data_rec.SLOT_OPERATOR
                , l_v_container_operator
                , l_cur_overshipped_data_rec.OUT_SLOT_OPERATOR
                , l_cur_overshipped_data_rec.SPECIAL_HANDLING
                , l_cur_overshipped_data_rec.SEAL_NO
                , l_cur_overshipped_data_rec.DISCHARGE_PORT
                , l_cur_overshipped_data_rec.POD_TERMINAL
                , l_cur_overshipped_data_rec.MLO_VESSEL
                , l_cur_overshipped_data_rec.MLO_VOYAGE
                , TO_DATE(l_cur_overshipped_data_rec.MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
                , l_cur_overshipped_data_rec.MLO_POD1
                , l_cur_overshipped_data_rec.MLO_POD2
                , l_cur_overshipped_data_rec.MLO_POD3
                , l_cur_overshipped_data_rec.MLO_DEL
                , l_cur_overshipped_data_rec.EX_MLO_VESSEL
                , TO_DATE(l_cur_overshipped_data_rec.EX_MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
                , l_cur_overshipped_data_rec.EX_MLO_VOYAGE
                , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_1
                , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_2
                , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_3
                , l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_1
                , l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_2
                , l_cur_overshipped_data_rec.SPECIAL_CARGO
                , l_cur_overshipped_data_rec.IMDG_CLASS
                , l_cur_overshipped_data_rec.UN_NUMBER
                , l_cur_overshipped_data_rec.UN_NUMBER_VARIANT
                , l_cur_overshipped_data_rec.PORT_CLASS
                , l_cur_overshipped_data_rec.PORT_CLASS_TYPE
                , l_cur_overshipped_data_rec.FLASHPOINT_UNIT
                , l_cur_overshipped_data_rec.FLASHPOINT
                , l_cur_overshipped_data_rec.FUMIGATION_ONLY
                , l_cur_overshipped_data_rec.RESIDUE_ONLY_FLAG
                , l_cur_overshipped_data_rec.OVERHEIGHT_CM
                , l_cur_overshipped_data_rec.OVERWIDTH_LEFT_CM
                , l_cur_overshipped_data_rec.OVERWIDTH_RIGHT_CM
                , l_cur_overshipped_data_rec.OVERLENGTH_FRONT_CM
                , l_cur_overshipped_data_rec.OVERLENGTH_REAR_CM
                , l_cur_overshipped_data_rec.REEFER_TEMPERATURE
                , l_cur_overshipped_data_rec.REEFER_TMP_UNIT
                , l_cur_overshipped_data_rec.HUMIDITY
                , l_cur_overshipped_data_rec.VENTILATION
                , 'A'
                , p_i_v_user_id
                , TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                , p_i_v_user_id
                , TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                );
            END IF;

        ELSIF (l_cur_overshipped_data_rec.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_UPD) THEN
            /* Call validation function for overshipped tab*/
            PRE_ELL_OVERSHIPPED_VALIDATION(
                     p_i_v_session_id
                , l_v_overshipped_row_num
                , l_cur_overshipped_data_rec.FK_LOAD_LIST_ID
                , l_cur_overshipped_data_rec.EQUIPMENT_NO
                , l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID
                , l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_1
                , l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_2
                , l_v_container_operator
                , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_1
                , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_2
                , l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_3
                , l_cur_overshipped_data_rec.UN_NUMBER
                , l_cur_overshipped_data_rec.UN_NUMBER_VARIANT
                , l_cur_overshipped_data_rec.IMDG_CLASS
                , p_i_v_port_code
                , l_cur_overshipped_data_rec.PORT_CLASS
                , l_cur_overshipped_data_rec.PORT_CLASS_TYPE
                , l_cur_overshipped_data_rec.OUT_SLOT_OPERATOR
                , l_cur_overshipped_data_rec.SLOT_OPERATOR
                , l_cur_overshipped_data_rec.SHIPMENT_TERM
                , l_cur_overshipped_data_rec.FLAG_SOC_COC
                , p_i_v_load_etd
                , p_i_v_hdr_etd_tm
                , l_cur_overshipped_data_rec.EQ_TYPE
                , l_cur_overshipped_data_rec.DISCHARGE_PORT
                , l_cur_overshipped_data_rec.POD_TERMINAL
                , p_o_v_err_cd);


            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;

            PRE_TOS_REMOVE_ERROR(
                  l_cur_overshipped_data_rec.DA_ERROR
                , LL_DL_FLAG
                , l_cur_overshipped_data_rec.EQ_SIZE
                , l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_1
                , l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_2
                , l_cur_overshipped_data_rec.EQUIPMENT_NO
                , l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID
                , l_cur_overshipped_data_rec.FK_LOAD_LIST_ID
                , p_o_v_err_cd
            );

            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;

            IF(l_cur_overshipped_data_rec.LOADING_STATUS NOT IN ('OS')) THEN

                SELECT COUNT(1)
                INTO   l_v_record_count
                FROM   TOS_RESTOW
                WHERE  FK_LOAD_LIST_ID = l_cur_overshipped_data_rec.FK_LOAD_LIST_ID
                AND    DN_EQUIPMENT_NO      = l_cur_overshipped_data_rec.EQUIPMENT_NO;

                -- When count is more then zero means record is already availabe, show error
                IF(l_v_record_count > 0) THEN
                  p_o_v_err_cd := 'EDL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_cur_overshipped_data_rec.EQUIPMENT_NO ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                  RETURN;
                END IF;

                /* Get Lock on table. */
                PCV_ELL_RECORD_LOCK(l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID
                                   ,TO_CHAR(l_cur_overshipped_data_rec.RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                                   ,'OVERSHIPPED'
                                   ,p_o_v_err_cd);

                IF ((p_o_v_err_cd IS NULL) OR (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD )) THEN
                    RETURN;
                END IF ;

                /* Delete record from the overshipped table, and move to restow table.*/
                DELETE FROM TOS_LL_OVERSHIPPED_CONTAINER
                WHERE PK_OVERSHIPPED_CONTAINER_ID = l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID;

                /*
                    Start added by vikas, delete error message from tos_error_log table
                    for this overshipped container, k'chatgamol, 15.12.2011
                */
                DELETE FROM
                    TOS_ERROR_LOG
                WHERE
                    FK_OVERSHIPPED_ID = l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID;

                /*
                    End added by vikas, 15.12.2011
                */

                /*Start added by vikas as logic is changed, 22.11.2011*/
                PCE_EDL_DLMAINTENANCE.PRE_PREV_LOAD_LIST_ID(
                     l_cur_overshipped_data_rec.BOOKING_NO
                    , l_cur_overshipped_data_rec.EQUIPMENT_NO
                    , l_cur_overshipped_data_rec.POD_TERMINAL
                    , l_cur_overshipped_data_rec.DISCHARGE_PORT
                    , l_v_load_list_id
                    , l_v_flag
                    , p_o_v_err_cd
                );
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

                IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND p_o_v_err_cd <> 'ELL.SE0121') THEN
                    RETURN;
                END IF;
                IF (p_o_v_err_cd = 'ELL.SE0121') THEN
                    g_v_warning   := 'ELL.SE0112'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_cur_overshipped_data_rec.EQUIPMENT_NO ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                    RETURN;
                END IF;

                IF (p_o_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

                    SELECT
                          FK_BKG_SIZE_TYPE_DTL
                        , FK_BKG_SUPPLIER
                        , FK_BKG_EQUIPM_DTL
                        , LOAD_CONDITION
                        , DN_SHIPMENT_TERM
                        , DN_SHIPMENT_TYP
                    INTO
                          l_v_fk_bkg_size_type_dtl
                        , l_v_fk_bkg_supplier
                        , l_v_fk_bkg_equipm_dtl
                        , l_v_load_condition
                        , l_v_dn_shipment_term
                        , l_v_dn_shipment_typ

                    FROM  TOS_LL_BOOKED_LOADING
                    WHERE PK_BOOKED_LOADING_ID = l_v_load_list_id;

                    SELECT SE_OCZ01.NEXTVAL
                    INTO l_n_restow_id
                    FROM DUAL;

                    INSERT INTO TOS_RESTOW
                    (
                        PK_RESTOW_ID
                      ,    FK_LOAD_LIST_ID
                      ,    FK_BOOKING_NO
                      ,    FK_BKG_SIZE_TYPE_DTL
                      ,    FK_BKG_SUPPLIER
                      ,    FK_BKG_EQUIPM_DTL
                      ,    DN_EQUIPMENT_NO
                      ,    DN_EQ_SIZE
                      ,    DN_EQ_TYPE
                      ,    DN_SOC_COC
                      ,    DN_SHIPMENT_TERM
                      ,    DN_SHIPMENT_TYP
                      ,    MIDSTREAM_HANDLING_CODE
                      ,    LOAD_CONDITION
                      ,    RESTOW_STATUS
                      ,    STOWAGE_POSITION
                      ,    CONTAINER_GROSS_WEIGHT
                      ,    DAMAGED
                      ,    VOID_SLOT
                      ,    FK_SLOT_OPERATOR
                      ,    FK_CONTAINER_OPERATOR
                      ,    DN_SPECIAL_HNDL
                      ,    SEAL_NO
                      ,    FK_SPECIAL_CARGO
                      ,    RECORD_STATUS
                      ,    RECORD_ADD_USER
                      ,    RECORD_ADD_DATE
                      ,    RECORD_CHANGE_USER
                      ,    RECORD_CHANGE_DATE
                    )
                    VALUES
                    (
                        l_n_restow_id
                      ,    l_cur_overshipped_data_rec.FK_LOAD_LIST_ID
                      ,    l_cur_overshipped_data_rec.BOOKING_NO
                      ,    l_v_fk_bkg_size_type_dtl
                      ,    l_v_fk_bkg_supplier
                      ,    l_v_fk_bkg_equipm_dtl
                      ,    l_cur_overshipped_data_rec.EQUIPMENT_NO
                      ,    l_cur_overshipped_data_rec.EQ_SIZE
                      ,    l_cur_overshipped_data_rec.EQ_TYPE
                      ,    l_cur_overshipped_data_rec.FLAG_SOC_COC
                      , l_v_dn_shipment_term
                      , l_v_dn_shipment_typ
                      ,    l_cur_overshipped_data_rec.MIDSTREAM_HANDLING_CODE
                      ,    l_v_load_condition
                      ,    l_cur_overshipped_data_rec.LOADING_STATUS
                      ,    l_cur_overshipped_data_rec.STOWAGE_POSITION
                      ,    l_cur_overshipped_data_rec.CONTAINER_GROSS_WEIGHT
                      ,    l_cur_overshipped_data_rec.DAMAGED
                      ,    l_cur_overshipped_data_rec.VOID_SLOT
                      ,    l_cur_overshipped_data_rec.SLOT_OPERATOR
                      ,    l_v_container_operator
                      ,    l_cur_overshipped_data_rec.SPECIAL_HANDLING
                      ,    l_cur_overshipped_data_rec.SEAL_NO
                      ,    l_cur_overshipped_data_rec.SPECIAL_CARGO
                      ,    'A'
                      ,    p_i_v_user_id
                      ,    TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                      ,    p_i_v_user_id
                      ,    TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                    );

                END IF;

            ELSE
                /* Normal update case */
                PCV_ELL_RECORD_LOCK(l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID
                                    , TO_CHAR(l_cur_overshipped_data_rec.RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                                    , 'OVERSHIPPED'
                                    , p_o_v_err_cd);

                IF ((p_o_v_err_cd IS NULL) OR (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD )) THEN
                    RETURN;
                END IF ;

                UPDATE TOS_LL_OVERSHIPPED_CONTAINER SET
                    BOOKING_NO = l_cur_overshipped_data_rec.BOOKING_NO
                  , EQUIPMENT_NO = l_cur_overshipped_data_rec.EQUIPMENT_NO
                  , EQ_SIZE = l_cur_overshipped_data_rec.EQ_SIZE
                  , EQ_TYPE = l_cur_overshipped_data_rec.EQ_TYPE
                  , FULL_MT = l_cur_overshipped_data_rec.FULL_MT
                  , BKG_TYP = l_cur_overshipped_data_rec.BKG_TYP
                  , FLAG_SOC_COC = l_cur_overshipped_data_rec.FLAG_SOC_COC
                  , LOCAL_STATUS = l_cur_overshipped_data_rec.LOCAL_STATUS
                  , LOCAL_TERMINAL_STATUS = l_cur_overshipped_data_rec.LOCAL_TERMINAL_STATUS
                  , MIDSTREAM_HANDLING_CODE = l_cur_overshipped_data_rec.MIDSTREAM_HANDLING_CODE
                  , LOAD_CONDITION = l_cur_overshipped_data_rec.LOAD_CONDITION
                  , STOWAGE_POSITION = l_cur_overshipped_data_rec.STOWAGE_POSITION
                  , ACTIVITY_DATE_TIME= TO_DATE(l_cur_overshipped_data_rec.ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
                  , CONTAINER_GROSS_WEIGHT = l_cur_overshipped_data_rec.CONTAINER_GROSS_WEIGHT
                  , DAMAGED = l_cur_overshipped_data_rec.DAMAGED
                  , VOID_SLOT = l_cur_overshipped_data_rec.VOID_SLOT
                  , SLOT_OPERATOR = l_cur_overshipped_data_rec.SLOT_OPERATOR
                  , CONTAINER_OPERATOR = l_v_container_operator
                  , OUT_SLOT_OPERATOR = l_cur_overshipped_data_rec.OUT_SLOT_OPERATOR
                  , SPECIAL_HANDLING = l_cur_overshipped_data_rec.SPECIAL_HANDLING
                  , SEAL_NO = l_cur_overshipped_data_rec.SEAL_NO
                  , DISCHARGE_PORT = l_cur_overshipped_data_rec.DISCHARGE_PORT
                  , POD_TERMINAL = l_cur_overshipped_data_rec.POD_TERMINAL
                  , MLO_VESSEL = l_cur_overshipped_data_rec.MLO_VESSEL
                  , MLO_VOYAGE = l_cur_overshipped_data_rec.MLO_VOYAGE
                  , MLO_VESSEL_ETA = TO_DATE(l_cur_overshipped_data_rec.MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
                  , MLO_POD1 = l_cur_overshipped_data_rec.MLO_POD1
                  , MLO_POD2 = l_cur_overshipped_data_rec.MLO_POD2
                  , MLO_POD3 = l_cur_overshipped_data_rec.MLO_POD3
                  , MLO_DEL = l_cur_overshipped_data_rec.MLO_DEL
                  , EX_MLO_VESSEL = l_cur_overshipped_data_rec.EX_MLO_VESSEL
                  , EX_MLO_VESSEL_ETA = TO_DATE(l_cur_overshipped_data_rec.EX_MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI')
                  , EX_MLO_VOYAGE = l_cur_overshipped_data_rec.EX_MLO_VOYAGE
                  , HANDLING_INSTRUCTION_1 = l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_1
                  , HANDLING_INSTRUCTION_2 = l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_2
                  , HANDLING_INSTRUCTION_3 = l_cur_overshipped_data_rec.HANDLING_INSTRUCTION_3
                  , CONTAINER_LOADING_REM_1 = l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_1
                  , CONTAINER_LOADING_REM_2 = l_cur_overshipped_data_rec.CONTAINER_LOADING_REM_2
                  , SPECIAL_CARGO = l_cur_overshipped_data_rec.SPECIAL_CARGO
                  , IMDG_CLASS = l_cur_overshipped_data_rec.IMDG_CLASS
                  , UN_NUMBER = l_cur_overshipped_data_rec.UN_NUMBER
                  , UN_NUMBER_VARIANT = l_cur_overshipped_data_rec.UN_NUMBER_VARIANT
                  , PORT_CLASS = l_cur_overshipped_data_rec.PORT_CLASS
                  , PORT_CLASS_TYPE = l_cur_overshipped_data_rec.PORT_CLASS_TYPE
                  , FLASHPOINT_UNIT = l_cur_overshipped_data_rec.FLASHPOINT_UNIT
                  , FLASHPOINT = l_cur_overshipped_data_rec.FLASHPOINT
                  , FUMIGATION_ONLY = l_cur_overshipped_data_rec.FUMIGATION_ONLY
                  , RESIDUE_ONLY_FLAG = l_cur_overshipped_data_rec.RESIDUE_ONLY_FLAG
                  , OVERHEIGHT_CM = l_cur_overshipped_data_rec.OVERHEIGHT_CM
                  , OVERWIDTH_LEFT_CM = l_cur_overshipped_data_rec.OVERWIDTH_LEFT_CM
                  , OVERWIDTH_RIGHT_CM = l_cur_overshipped_data_rec.OVERWIDTH_RIGHT_CM
                  , OVERLENGTH_FRONT_CM = l_cur_overshipped_data_rec.OVERLENGTH_FRONT_CM
                  , OVERLENGTH_REAR_CM = l_cur_overshipped_data_rec.OVERLENGTH_REAR_CM
                  , REEFER_TEMPERATURE = l_cur_overshipped_data_rec.REEFER_TEMPERATURE
                  , REEFER_TMP_UNIT = l_cur_overshipped_data_rec.REEFER_TMP_UNIT
                  , HUMIDITY = l_cur_overshipped_data_rec.HUMIDITY
                  , VENTILATION = l_cur_overshipped_data_rec.VENTILATION
                     , DA_ERROR = 'N'
                  , RECORD_CHANGE_USER = p_i_v_user_id
                  , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                WHERE
                    PK_OVERSHIPPED_CONTAINER_ID = l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID;
                END IF;


        ELSIF (l_cur_overshipped_data_rec.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_DEL) THEN

            PCV_ELL_RECORD_LOCK(l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID
                                , TO_CHAR(l_cur_overshipped_data_rec.RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
                                , 'OVERSHIPPED'
                                , p_o_v_err_cd);

            IF ((p_o_v_err_cd IS NULL) OR (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD )) THEN
                RETURN;
            END IF ;

            -- Delete the record from table.
            DELETE FROM TOS_LL_OVERSHIPPED_CONTAINER
            WHERE PK_OVERSHIPPED_CONTAINER_ID = l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID;

            /*
                Start added by vikas, delete error message from tos_error_log table
                for this overshipped container, k'chatgamol, 15.12.2011
            */
            DELETE FROM
                TOS_ERROR_LOG
            WHERE
                FK_OVERSHIPPED_ID = l_cur_overshipped_data_rec.PK_OVERSHIPPED_CONTAINER_ID;

            /*
                End added by vikas, 15.12.2011
            */

        END IF;

        /* update booking status count in tos_ll_load_list table */
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
            TO_NUMBER(l_cur_overshipped_data_rec.FK_LOAD_LIST_ID)
            , LL_DL_FLAG
            , p_o_v_err_cd
        );

        IF(p_o_v_err_cd = 0 ) THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        ELSE
          --  p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            /* Error in Sync Booking Status count */
            p_o_v_err_cd := 'EDL.SE0180';
            RETURN;
        END IF;


        IF (l_cur_overshipped_data_rec.OPN_STATUS IS NULL OR
            l_cur_overshipped_data_rec.OPN_STATUS <> PCE_EUT_COMMON.G_V_REC_DEL) THEN
            l_v_overshipped_row_num := l_v_overshipped_row_num + 1;
        END IF;

        END LOOP;

        IF l_v_errors IS NOT NULL AND
            (l_v_errors   != PCE_EUT_COMMON.G_V_SUCCESS_CD AND
             p_o_v_err_cd != PCE_EUT_COMMON.G_V_GE0005     AND
             p_o_v_err_cd != PCE_EUT_COMMON.G_V_GE0002)    THEN
             p_o_v_err_cd := l_v_errors;
            RETURN;
        END IF;

    EXCEPTION
        WHEN exp_error_on_save THEN
            RETURN;
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        RETURN;
    END PRE_ELL_SAVE_OVERSHIP_TAB_MAIN;


     PROCEDURE PRE_ELL_OVERSHIPPED_VALIDATION (
          p_i_v_session_id          VARCHAR2
        , p_i_row_num               VARCHAR2
        , p_i_v_load_list_id        VARCHAR2
        , p_i_v_equipment_no        VARCHAR2
        , p_i_v_pk_cont_id          VARCHAR2
        , p_i_v_clr_code1           VARCHAR2
        , p_i_v_clr_code2           VARCHAR2
        , p_i_v_oper_cd             VARCHAR2
        , p_i_v_shi_code1           VARCHAR2
        , p_i_v_shi_code2           VARCHAR2
        , p_i_v_shi_code3           VARCHAR2
        , p_i_v_unno                VARCHAR2
        , p_i_v_variant             VARCHAR2
        , p_i_v_imdg                VARCHAR2
        , p_i_v_port_code           VARCHAR2
        , p_i_v_port_class          VARCHAR2
        , p_i_v_port_class_type     VARCHAR2
        , p_i_v_out_slot_operator   VARCHAR2
        , p_i_v_slot_operator       VARCHAR2
        , p_i_v_shipmnt_cd          VARCHAR2
        , p_i_v_SOC_COC             VARCHAR2
        , p_i_v_load_etd            VARCHAR2
        , p_i_v_hdr_etd_tm          VARCHAR2
        , p_i_v_equip_type          VARCHAR2
        , p_i_v_pod_code            VARCHAR2
        , p_i_v_pod_terminal_code   VARCHAR2
        , p_o_v_err_cd              OUT VARCHAR2
    ) AS
        l_v_record_count            NUMBER := 0;

        l_v_shipment_typ           TOS_LL_OVERSHIPPED_CONTAINER.SHIPMENT_TYPE%TYPE; -- *2
    BEGIN
        /* Set the error code to its default value (00000) */
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        SELECT COUNT(1)
        INTO   l_v_record_count
        FROM   TOS_LL_OVERSHIPPED_CONT_TMP
        WHERE  FK_LOAD_LIST_ID      = p_i_v_load_list_id
        AND    EQUIPMENT_NO         = p_i_v_equipment_no
        AND    PK_OVERSHIPPED_CONTAINER_ID != NVL(p_i_v_pk_cont_id,' ')
        AND    SESSION_ID            = p_i_v_session_id;

        -- When count is more then zero means record is already availabe, show error
        IF(l_v_record_count > 0) THEN
            p_o_v_err_cd := 'ELL.SE0122'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
        END IF;

        SELECT COUNT(1)
        INTO   l_v_record_count
        FROM   TOS_LL_BOOKED_LOADING        BD,
               TOS_LL_OVERSHIPPED_CONT_TMP  OS
        WHERE  OS.FK_LOAD_LIST_ID  =  BD.FK_LOAD_LIST_ID
        AND    OS.FK_LOAD_LIST_ID  =  p_i_v_load_list_id
        AND    OS.EQUIPMENT_NO     =  BD.DN_EQUIPMENT_NO
        AND    OS.EQUIPMENT_NO     =  p_i_v_equipment_no
        AND    OS.LOADING_STATUS  NOT IN ('OS')
        AND    BD.LOADING_STATUS != 'RB';


        -- Equipment# present in Booked tab with status other than 'ROB'
        IF(l_v_record_count > 0) THEN
            p_o_v_err_cd := 'ELL.SE0123' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
        END IF;


        /*
            *2 : Changes starts
        *
            Get the shipment type for the Overlanded table
        */
        BEGIN
            l_v_shipment_typ := NULL;

            SELECT
                SHIPMENT_TYPE
            INTO
                l_v_shipment_typ
            FROM
                TOS_LL_OVERSHIPPED_CONT_TMP -- In overshipped tab, shipment type is editable so need to get from temp table
            WHERE
                FK_LOAD_LIST_ID                 = p_i_v_load_list_id
                AND EQUIPMENT_NO                = p_i_v_equipment_no
                AND PK_OVERSHIPPED_CONTAINER_ID = p_i_v_pk_cont_id
                AND SESSION_ID                  = p_i_v_session_id;
        EXCEPTION
            WHEN OTHERS THEN
                l_v_shipment_typ := NULL;
        END;
        /*
            *2 : Changes end
        */

        IF(p_i_v_soc_coc = 'C') AND (NVL(l_v_shipment_typ, '*') <> 'UC' )THEN -- *2
                IF p_i_v_equipment_no IS NOT NULL THEN
                    /* Equipment Type should be COC */
                    IF(PCE_EUT_COMMON.FN_CHECK_COC_FLAG (
                              p_i_v_equipment_no
                            , p_i_v_port_code
                            , p_i_v_load_etd
                            , p_i_v_hdr_etd_tm
                            , p_o_v_err_cd
                        )                   = FALSE) THEN
                        p_o_v_err_cd := 'EDL.SE0132'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                        RETURN;
                    END IF;
                END IF;
            END IF;

            /* Check for the Equipment Type in dolphin master table. */
            PRE_ELL_VAL_EQUIPMENT_TYPE(p_i_v_equip_type , p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

            /* Check for the shipment term. */
            PRE_SHIPMENT_TERM_OL_CODE(p_i_v_shipmnt_cd, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

            IF p_i_v_SOC_COC = 'C' THEN
        /* Check for the Sloat Operator in OPERATOR_CODE Master Table. */
            PRE_ELL_OL_VAL_OPERATOR_CODE( p_i_v_slot_operator, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Check for the Container Operator in OPERATOR_CODE Master Table */
            PRE_ELL_OL_VAL_OPERATOR_CODE( p_i_v_oper_cd, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Check for the Out Slot Operator in OPERATOR_CODE Master Table.
            PRE_ELL_OL_VAL_OPERATOR_CODE( p_i_v_out_slot_operator, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;
        */
            END IF;

            /* Check for the POL Code in  Master Table. */
            PRE_ELL_VAL_PORT_CODE( p_i_v_pod_code, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

            /* Check for the POL Terminal Code in  Master Table. */
            PRE_ELL_VAL_PORT_TERMINAL_CODE( p_i_v_pod_terminal_code, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /*    Handling Instruction Code1 validation */
            PRE_ELL_OL_VAL_HAND_CODE(p_i_v_shi_code1, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /*    Handling Instruction Code2 validation */
            PRE_ELL_OL_VAL_HAND_CODE(p_i_v_shi_code2, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /*    Handling Instruction Code3 validation */
            PRE_ELL_OL_VAL_HAND_CODE(p_i_v_shi_code3, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Check for the Container Loading Remark Code1 in dolphin master table. */
            PRE_ELL_OL_VAL_CLR_CODE(p_i_v_clr_code1, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

         /* Check for the Container Loading Remark Code2 in dolphin master table. */
            PRE_ELL_OL_VAL_CLR_CODE(p_i_v_clr_code2, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Validate UN Number and UN Number Variant */
            PRE_ELL_OL_VAL_UNNO(p_i_v_unno, p_i_v_variant, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

        /* Check for the IMDG Code in IMDG Master Table. */
            PRE_ELL_OL_VAL_IMDG(p_i_v_unno, p_i_v_variant, p_i_v_imdg, p_i_v_equipment_no, p_o_v_err_cd);
            IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                RETURN;
            END IF ;

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
			
            PRE_ELL_OL_VAL_PORT_CLASS_TYPE( p_i_v_port_code, p_i_v_port_class_type, p_i_v_equipment_no, p_o_v_err_cd);
             IF(p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                return;
            end if ;
        -- *24 end
        EXCEPTION
            WHEN OTHERS THEN
                p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);

                RETURN;
    END PRE_ELL_OVERSHIPPED_VALIDATION;

    PROCEDURE PRE_ELL_SAVE_RESTOW_TAB_MAIN (
          p_i_v_session_id      VARCHAR2
        , p_i_v_user_id         VARCHAR2
        , p_i_v_vessel          VARCHAR2
        , p_i_v_eta             VARCHAR2
        , p_i_v_hdr_eta_tm      VARCHAR2
        , p_i_v_load_etd        VARCHAR2
        , p_i_v_hdr_etd_tm      VARCHAR2
        , p_i_v_hdr_port        VARCHAR2
        , p_i_v_date            VARCHAR2
        , p_o_v_err_cd          OUT VARCHAR2
    ) AS
        l_v_lock_data           VARCHAR2(14);
        l_v_errors              VARCHAR2(2000);
        l_v_fk_booking_no       VARCHAR2(17);
        l_v_restow_row_num      NUMBER := 1;
        l_n_restow_id           NUMBER := 0;

        exp_error_on_save       EXCEPTION;

        l_v_fk_bkg_size_typ_dtl     NUMBER;
        l_v_fk_bkg_supplier         NUMBER;
        l_v_fk_bkg_equip_dtl        NUMBER;
        l_v_dn_eq_size              NUMBER;
        l_v_dn_eq_type              VARCHAR2(2);
        l_v_dn_soc_coc              VARCHAR2(1);
        l_v_dn_shipment_term        VARCHAR2(4);
        l_v_dn_shipment_typ         VARCHAR2(3);
        l_v_cont_gross_weight       NUMBER;
        l_v_damaged                 VARCHAR2(1);
        l_v_void_slot               NUMBER;
        l_v_fk_slot_operator        VARCHAR2(4);
        l_v_fk_cont_operator        VARCHAR2(4);
        l_v_dn_special_hndl         VARCHAR2(3);
        l_v_seal_no                 VARCHAR2(20);
        l_v_fk_special_cargo        VARCHAR2(3);
        l_v_load_condition          VARCHAR2(1);
        l_v_rec_count               NUMBER;
        l_v_load_list_id            NUMBER;
        l_v_discharge_id            NUMBER;
        l_v_stowage_position        VARCHAR2(7);
        l_v_flag                    VARCHAR2(1);
        l_v_fk_port_sequence_no     TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO%TYPE;

        -- cursor to save restow tab data
        CURSOR l_cur_restowed_data IS
            SELECT  PK_RESTOW_ID, FK_LOAD_LIST_ID, FK_DISCHARGE_LIST_ID, FK_BOOKING_NO, FK_BKG_SIZE_TYPE_DTL
                  , FK_BKG_SUPPLIER, FK_BKG_EQUIPM_DTL, DN_EQUIPMENT_NO, DN_EQ_SIZE, DN_EQ_TYPE
                  , DN_SOC_COC, DN_SHIPMENT_TERM, DN_SHIPMENT_TYP, MIDSTREAM_HANDLING_CODE, LOAD_CONDITION
                  , RESTOW_STATUS, STOWAGE_POSITION, ACTIVITY_DATE_TIME, CONTAINER_GROSS_WEIGHT, DAMAGED, VOID_SLOT, FK_SLOT_OPERATOR
                  , FK_CONTAINER_OPERATOR, DN_SPECIAL_HNDL, SEAL_NO, FK_SPECIAL_CARGO, PUBLIC_REMARK
                  , RECORD_CHANGE_USER, RECORD_CHANGE_DATE, SEQ_NO, OPN_STATUS,
                    DECODE(OPN_STATUS,PCE_EUT_COMMON.G_V_REC_DEL,'1') ORD_SEQ
            FROM    TOS_RESTOW_TMP WHERE SESSION_ID = p_i_v_session_id
            ORDER BY ORD_SEQ, SEQ_NO;

    BEGIN
        l_v_errors   := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        FOR l_cur_restowed_data_rec IN l_cur_restowed_data
        LOOP

        /* Save(add) selected record*/
        IF(l_cur_restowed_data_rec.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_ADD) THEN


            SELECT SE_RZZ01.NEXTVAL
            INTO l_n_restow_id
            FROM DUAL;

            -- call validation function for restowed tab.

            PRE_ELL_RESTOW_VALIDATION (p_i_v_session_id, l_v_restow_row_num
              , l_cur_restowed_data_rec.FK_LOAD_LIST_ID, l_cur_restowed_data_rec.DN_EQUIPMENT_NO
              , l_cur_restowed_data_rec.PK_RESTOW_ID, l_cur_restowed_data_rec.DN_SOC_COC
              , p_i_v_hdr_port, p_i_v_load_etd, p_i_v_hdr_etd_tm, p_o_v_err_cd);

            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
               RETURN;
            END IF;

            /* get port sequence # for the current discharge list */
            SELECT FK_PORT_SEQUENCE_NO
            INTO l_v_fk_port_sequence_no
            FROM TOS_LL_LOAD_LIST
            WHERE PK_LOAD_LIST_ID = l_cur_restowed_data_rec.FK_LOAD_LIST_ID
            AND ROWNUM = 1;

            /* Get the load list id */

            -- PRE_ELL_PREV_LOAD_LIST_ID (
            PCE_EDL_DLMAINTENANCE.PRE_EDL_PREV_LOAD_LIST_ID (
                  p_i_v_vessel
                , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                , l_cur_restowed_data_rec.FK_BOOKING_NO
                , p_i_v_eta
                , p_i_v_hdr_eta_tm
                , p_i_v_hdr_port
                , l_v_fk_port_sequence_no
                , l_v_load_list_id
                , l_v_flag
                , p_o_v_err_cd
            );

            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND p_o_v_err_cd <> 'ELL.SE0121') THEN
                RETURN;
            END IF;
            IF (p_o_v_err_cd = 'ELL.SE0121') THEN
                g_v_warning   := 'ELL.SE0112'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_cur_restowed_data_rec.DN_EQUIPMENT_NO ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;

            IF (p_o_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                BEGIN -- * 16
                    SELECT
                        FK_BOOKING_NO
                        , FK_BKG_SIZE_TYPE_DTL
                        , FK_BKG_SUPPLIER
                        , FK_BKG_EQUIPM_DTL
                        , DN_EQ_SIZE
                        , DN_EQ_TYPE
                        , DN_SOC_COC
                        , DN_SHIPMENT_TERM
                        , DN_SHIPMENT_TYP
                        , CONTAINER_GROSS_WEIGHT
                        , DAMAGED
                        , VOID_SLOT
                        , FK_SLOT_OPERATOR
                        , FK_CONTAINER_OPERATOR
                        , DN_SPECIAL_HNDL
                        , SEAL_NO
                        , FK_SPECIAL_CARGO
                        , LOAD_CONDITION
                        , STOWAGE_POSITION
                    INTO
                            l_v_fk_booking_no
                        , l_v_fk_bkg_size_typ_dtl
                        , l_v_fk_bkg_supplier
                        , l_v_fk_bkg_equip_dtl
                        , l_v_dn_eq_size
                        , l_v_dn_eq_type
                        , l_v_dn_soc_coc
                        , l_v_dn_shipment_term
                        , l_v_dn_shipment_typ
                        , l_v_cont_gross_weight
                        , l_v_damaged
                        , l_v_void_slot
                        , l_v_fk_slot_operator
                        , l_v_fk_cont_operator
                        , l_v_dn_special_hndl
                        , l_v_seal_no
                        , l_v_fk_special_cargo
                        , l_v_load_condition
                        , l_v_stowage_position
                    FROM
                        TOS_LL_BOOKED_LOADING
                    WHERE
                        PK_BOOKED_LOADING_ID = l_v_load_list_id;

                /* *16 start * */
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        /* * Service, Vessel and Voyage information not match with
                             present load list for equipment# * */
                        g_v_warning   := 'ELL.SE0112'
                            || PCE_EUT_COMMON.G_V_ERR_DATA_SEP
                            || l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                            || PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                        RETURN;
                END;
                /* *16 end * */

                IF(l_cur_restowed_data_rec.RESTOW_STATUS = 'XX' AND
                   l_v_stowage_position != l_cur_restowed_data_rec.STOWAGE_POSITION ) THEN

                    BEGIN
                        SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
                        INTO   l_v_lock_data
                        FROM   TOS_LL_BOOKED_LOADING
                        WHERE  PK_BOOKED_LOADING_ID = l_v_load_list_id
                        FOR UPDATE NOWAIT;

                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
                        RETURN;
                    WHEN OTHERS THEN
                        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                        RETURN;
                    END;

                    /* update record in booked load list table */

                    UPDATE TOS_LL_BOOKED_LOADING
                    SET STOWAGE_POSITION   = l_cur_restowed_data_rec.STOWAGE_POSITION
                      , RECORD_CHANGE_USER = p_i_v_user_id
                      , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                    WHERE PK_BOOKED_LOADING_ID = l_v_load_list_id;
                END IF;

                IF(l_cur_restowed_data_rec.RESTOW_STATUS IN ('LR', 'RA', 'LC', 'RP', 'XX')) THEN

                    /* Start edited by vikas calling pre build sp
                    of dl_maintenance , 22.11.2011*/
                    /* get port sequence # for the current discharge list */
                    SELECT FK_PORT_SEQUENCE_NO
                    INTO l_v_fk_port_sequence_no
                    FROM TOS_LL_LOAD_LIST
                    WHERE PK_LOAD_LIST_ID = l_cur_restowed_data_rec.FK_LOAD_LIST_ID
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

                    PRE_FIND_DISCHARGE_LIST(
                        l_v_fk_booking_no,
                        p_i_v_vessel,
                        l_cur_restowed_data_rec.DN_EQUIPMENT_NO,
                        l_v_flag,
                        l_v_discharge_id,
                        p_o_v_err_cd
                    );

                    /* *23 end * */
                    IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                        RETURN;
                    END IF;

                    IF(l_v_flag = 'D') THEN

                        BEGIN

                            SELECT STOWAGE_POSITION
                            INTO   l_v_stowage_position
                            FROM   TOS_DL_BOOKED_DISCHARGE
                            WHERE  PK_BOOKED_DISCHARGE_ID = l_v_discharge_id
                            --AND    DISCHARGE_STATUS <> 'DI' -- Added by vikas, 17.02.2012 -- *1
                            FOR UPDATE NOWAIT;

                            EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
                            RETURN;
                        WHEN OTHERS THEN
                            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                            RETURN;
                        END;

                        -- IF(l_v_stowage_position != l_cur_restowed_data_rec.STOWAGE_POSITION) THEN -- *23
                        IF(NVL(l_v_stowage_position,'~') != NVL(l_cur_restowed_data_rec.STOWAGE_POSITION,'~')) THEN -- *23
                            /* update record in booked load list table */
                            UPDATE
                                TOS_DL_BOOKED_DISCHARGE
                            SET
                                  STOWAGE_POSITION = l_cur_restowed_data_rec.STOWAGE_POSITION
                                , CONTAINER_GROSS_WEIGHT = l_cur_restowed_data_rec.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                                , RECORD_CHANGE_USER = p_i_v_user_id
                                , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                            WHERE
                                PK_BOOKED_DISCHARGE_ID = l_v_discharge_id
                                -- AND DISCHARGE_STATUS <> 'DI';  -- *1
                                AND (STOWAGE_POSITION IS NULL OR DISCHARGE_STATUS <> 'DI'); -- *1

                        END IF;
                    END IF;

                END IF;

            END IF;

          -- Move data from temp table to main table.
          INSERT INTO TOS_RESTOW
          (
                PK_RESTOW_ID
              ,    FK_LOAD_LIST_ID
              ,    FK_BOOKING_NO
              ,    FK_BKG_SIZE_TYPE_DTL
              ,    FK_BKG_SUPPLIER
              ,    FK_BKG_EQUIPM_DTL
              ,    DN_EQUIPMENT_NO
              ,    DN_EQ_SIZE
              ,    DN_EQ_TYPE
              ,    DN_SOC_COC
              ,    DN_SHIPMENT_TERM
              ,    DN_SHIPMENT_TYP
              ,    MIDSTREAM_HANDLING_CODE
              ,    RESTOW_STATUS
              ,    STOWAGE_POSITION
              , ACTIVITY_DATE_TIME
              ,    CONTAINER_GROSS_WEIGHT
              ,    DAMAGED
              ,    VOID_SLOT
              ,    FK_SLOT_OPERATOR
              ,    FK_CONTAINER_OPERATOR
              ,    DN_SPECIAL_HNDL
              ,    SEAL_NO
              ,    FK_SPECIAL_CARGO
              , LOAD_CONDITION
              ,    PUBLIC_REMARK
              ,    RECORD_STATUS
              ,    RECORD_ADD_USER
              ,    RECORD_ADD_DATE
              ,    RECORD_CHANGE_USER
              ,    RECORD_CHANGE_DATE

          )
          VALUES
          (
              l_n_restow_id
            , l_cur_restowed_data_rec.FK_LOAD_LIST_ID
            , l_v_fk_booking_no
            , l_v_fk_bkg_size_typ_dtl
            , l_v_fk_bkg_supplier
            , l_v_fk_bkg_equip_dtl
            , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
            , l_v_dn_eq_size
            , l_v_dn_eq_type
            , l_v_dn_soc_coc
            , l_v_dn_shipment_term
            , l_v_dn_shipment_typ
            , l_cur_restowed_data_rec.MIDSTREAM_HANDLING_CODE
            , l_cur_restowed_data_rec.RESTOW_STATUS
            , l_cur_restowed_data_rec.STOWAGE_POSITION
             , TO_DATE(l_cur_restowed_data_rec.ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
            , l_cur_restowed_data_rec.CONTAINER_GROSS_WEIGHT
            , l_cur_restowed_data_rec.DAMAGED
            , l_v_void_slot
            , l_v_fk_slot_operator
            , l_v_fk_cont_operator
            , l_v_dn_special_hndl
            , l_cur_restowed_data_rec.SEAL_NO
            , l_v_fk_special_cargo
            , l_v_load_condition
            , l_cur_restowed_data_rec.PUBLIC_REMARK
            , 'A'
            , p_i_v_user_id
            , TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
            , p_i_v_user_id
            , TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
          );


        /* Update the selected record*/
        ELSIF (l_cur_restowed_data_rec.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_UPD) THEN

            -- call validation function for restowed tab.
            PRE_ELL_RESTOW_VALIDATION (p_i_v_session_id, l_v_restow_row_num
            , l_cur_restowed_data_rec.FK_LOAD_LIST_ID, l_cur_restowed_data_rec.DN_EQUIPMENT_NO
            , l_cur_restowed_data_rec.PK_RESTOW_ID, l_cur_restowed_data_rec.DN_SOC_COC
            , p_i_v_hdr_port, p_i_v_load_etd, p_i_v_hdr_etd_tm, p_o_v_err_cd);

            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;

            /*
                check if equipment number is changed or not
                if equipment number is changed then get data
                from master table.
            */

            SELECT COUNT(1) INTO l_v_rec_count
            FROM  TOS_RESTOW
            WHERE PK_RESTOW_ID    = l_cur_restowed_data_rec.PK_RESTOW_ID
            AND   DN_EQUIPMENT_NO = l_cur_restowed_data_rec.DN_EQUIPMENT_NO;

            /* No data found equipment no is changed */
            IF(l_v_rec_count < 1) THEN

                /* get port sequence # for the current discharge list */
                SELECT FK_PORT_SEQUENCE_NO
                INTO l_v_fk_port_sequence_no
                FROM TOS_LL_LOAD_LIST
                WHERE PK_LOAD_LIST_ID = l_cur_restowed_data_rec.FK_LOAD_LIST_ID
                AND ROWNUM = 1;

                /* Get the load list id */
                -- PRE_ELL_PREV_LOAD_LIST_ID (
                PCE_EDL_DLMAINTENANCE.PRE_EDL_PREV_LOAD_LIST_ID (
                      p_i_v_vessel
                    , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                    , l_cur_restowed_data_rec.FK_BOOKING_NO
                    , p_i_v_eta
                    , p_i_v_hdr_eta_tm
                    , p_i_v_hdr_port
                    , l_v_fk_port_sequence_no
                    , l_v_load_list_id
                    , l_v_flag
                    , p_o_v_err_cd
                );

                IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND p_o_v_err_cd <> 'ELL.SE0121') THEN
                    RETURN;
                END IF;
                IF (p_o_v_err_cd = 'ELL.SE0121') THEN
                    g_v_warning   := 'ELL.SE0112'|| PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_cur_restowed_data_rec.DN_EQUIPMENT_NO ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                    RETURN;
                END IF;

                IF (p_o_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

                    SELECT
                            DN_EQ_SIZE
                          , DN_EQ_TYPE
                          , DN_SOC_COC
                          , DN_SHIPMENT_TERM
                          , DN_SHIPMENT_TYP
                          , CONTAINER_GROSS_WEIGHT
                          , DAMAGED
                          , VOID_SLOT
                          , FK_SLOT_OPERATOR
                          , FK_CONTAINER_OPERATOR
                          , DN_SPECIAL_HNDL
                          , SEAL_NO
                          , FK_SPECIAL_CARGO
                          , LOAD_CONDITION
                          , STOWAGE_POSITION
                    INTO
                            l_v_dn_eq_size
                          , l_v_dn_eq_type
                          , l_v_dn_soc_coc
                          , l_v_dn_shipment_term
                          , l_v_dn_shipment_typ
                          , l_v_cont_gross_weight
                          , l_v_damaged
                          , l_v_void_slot
                          , l_v_fk_slot_operator
                          , l_v_fk_cont_operator
                          , l_v_dn_special_hndl
                          , l_v_seal_no
                          , l_v_fk_special_cargo
                          , l_v_load_condition
                          , l_v_stowage_position
                    FROM  TOS_LL_BOOKED_LOADING
                    WHERE PK_BOOKED_LOADING_ID = l_v_load_list_id;

                    IF(l_cur_restowed_data_rec.RESTOW_STATUS = 'XX' AND
                       l_v_stowage_position != l_cur_restowed_data_rec.STOWAGE_POSITION ) THEN

                        BEGIN
                            SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
                            INTO   l_v_lock_data
                            FROM   TOS_LL_BOOKED_LOADING
                            WHERE  PK_BOOKED_LOADING_ID = l_v_load_list_id
                            FOR UPDATE NOWAIT;

                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
                            RETURN;
                        WHEN OTHERS THEN
                            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                            RETURN;
                        END;

                        /* update record in booked load list table */
                        UPDATE TOS_LL_BOOKED_LOADING
                        SET STOWAGE_POSITION   = l_cur_restowed_data_rec.STOWAGE_POSITION
                          , RECORD_CHANGE_USER = p_i_v_user_id
                          , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                        WHERE PK_BOOKED_LOADING_ID = l_v_load_list_id;
                    END IF;

                    IF(l_cur_restowed_data_rec.RESTOW_STATUS IN ('LR', 'RA', 'LC', 'RP', 'XX')) THEN
                        /* Start edited by vikas calling pre build sp
                        of dl_maintenance , 22.11.2011*/
                        /* get port sequence # for the current discharge list */
                        SELECT FK_PORT_SEQUENCE_NO
                        INTO l_v_fk_port_sequence_no
                        FROM TOS_LL_LOAD_LIST
                        WHERE PK_LOAD_LIST_ID = l_cur_restowed_data_rec.FK_LOAD_LIST_ID
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

                        PRE_FIND_DISCHARGE_LIST(
                            l_cur_restowed_data_rec.FK_BOOKING_NO,
                            P_I_V_VESSEL,
                            l_cur_restowed_data_rec.DN_EQUIPMENT_NO,
                            l_v_flag,
                            l_v_discharge_id,
                            p_o_v_err_cd
                        );
                        /* *23 end * */

                        /* End edited by vikas, 22.11.2011*/

                        IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                            RETURN;
                        END IF;

                        IF(l_v_flag = 'D') THEN

                            BEGIN

                                SELECT STOWAGE_POSITION
                                INTO   l_v_stowage_position
                                FROM   TOS_DL_BOOKED_DISCHARGE
                                WHERE  PK_BOOKED_DISCHARGE_ID = l_v_discharge_id
                                --AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012 -- *1
                                FOR UPDATE NOWAIT;

                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
                                    RETURN;
                                WHEN OTHERS THEN
                                    p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                                    RETURN;
                            END;

                            -- IF(l_v_stowage_position != l_cur_restowed_data_rec.STOWAGE_POSITION) THEN -- *23
                            IF(NVL(l_v_stowage_position,'~') != NVL(l_cur_restowed_data_rec.STOWAGE_POSITION,'~')) THEN -- *23

                                /* update record in booked load list table */
                                UPDATE
                                    TOS_DL_BOOKED_DISCHARGE
                                SET
                                    STOWAGE_POSITION = l_cur_restowed_data_rec.STOWAGE_POSITION
                                    , CONTAINER_GROSS_WEIGHT = l_cur_restowed_data_rec.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                                    , RECORD_CHANGE_USER = p_i_v_user_id
                                    , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                                WHERE
                                    PK_BOOKED_DISCHARGE_ID = l_v_discharge_id
                                    -- AND DISCHARGE_STATUS <> 'DI'; -- *1
                                    AND (STOWAGE_POSITION IS NULL OR DISCHARGE_STATUS <> 'DI'); -- *1
                            END IF;
                        END IF;

                    END IF;

                END IF;

                UPDATE TOS_RESTOW SET
                    DN_EQUIPMENT_NO          = l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                  , DN_EQ_SIZE                  = l_v_dn_eq_size
                  , DN_EQ_TYPE                  = l_v_dn_eq_type
                  , DN_SOC_COC                  = l_v_dn_soc_coc
                  , DN_SHIPMENT_TERM         = l_v_dn_shipment_term
                  , DN_SHIPMENT_TYP         = l_v_dn_shipment_typ
                  , ACTIVITY_DATE_TIME         = TO_DATE(l_cur_restowed_data_rec.ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
                  , CONTAINER_GROSS_WEIGHT     = l_cur_restowed_data_rec.CONTAINER_GROSS_WEIGHT
                  , DAMAGED                 = l_cur_restowed_data_rec.DAMAGED
                  , VOID_SLOT                 = l_v_void_slot
                  , FK_SLOT_OPERATOR         = l_v_fk_slot_operator
                  , FK_CONTAINER_OPERATOR     = l_v_fk_cont_operator
                  , DN_SPECIAL_HNDL         = l_v_dn_special_hndl
                  , SEAL_NO                 = l_cur_restowed_data_rec.SEAL_NO
                  , FK_SPECIAL_CARGO         = l_v_fk_special_cargo
                  , MIDSTREAM_HANDLING_CODE    = l_cur_restowed_data_rec.MIDSTREAM_HANDLING_CODE
                  , LOAD_CONDITION            = l_v_load_condition
                  , RESTOW_STATUS            = l_cur_restowed_data_rec.RESTOW_STATUS
                  , STOWAGE_POSITION        = l_cur_restowed_data_rec.STOWAGE_POSITION
                  , PUBLIC_REMARK            = l_cur_restowed_data_rec.PUBLIC_REMARK
                  , RECORD_CHANGE_USER         = p_i_v_user_id
                  , RECORD_CHANGE_DATE         = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                WHERE
                  PK_RESTOW_ID = l_cur_restowed_data_rec.PK_RESTOW_ID;

            ELSE
                    /* Check if stowage position is changed */
                    SELECT STOWAGE_POSITION
                    INTO l_v_stowage_position
                    FROM   TOS_RESTOW
                    WHERE  PK_RESTOW_ID     = l_cur_restowed_data_rec.PK_RESTOW_ID ;

                IF NVL(l_v_stowage_position,'~') != NVL(l_cur_restowed_data_rec.STOWAGE_POSITION,'~') THEN

                    /* get port sequence # for the current discharge list */
                    SELECT FK_PORT_SEQUENCE_NO
                    INTO l_v_fk_port_sequence_no
                    FROM TOS_LL_LOAD_LIST
                    WHERE PK_LOAD_LIST_ID = l_cur_restowed_data_rec.FK_LOAD_LIST_ID
                    AND ROWNUM = 1;

                    /* Get the load list id */
                    -- PRE_ELL_PREV_LOAD_LIST_ID (
                    PCE_EDL_DLMAINTENANCE.PRE_EDL_PREV_LOAD_LIST_ID (
                          p_i_v_vessel
                        , l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                        , l_cur_restowed_data_rec.FK_BOOKING_NO
                        , p_i_v_eta
                        , p_i_v_hdr_eta_tm
                        , p_i_v_hdr_port
                        , l_v_fk_port_sequence_no
                        , l_v_load_list_id
                        , l_v_flag
                        , p_o_v_err_cd
                    );

                    IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD AND p_o_v_err_cd <> 'ELL.SE0121') THEN
                        RETURN;
                    END IF;
                    IF (p_o_v_err_cd = 'ELL.SE0121') THEN
                        g_v_warning   := 'ELL.SE0112' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_cur_restowed_data_rec.DN_EQUIPMENT_NO ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                        RETURN;
                    END IF;

                    IF (p_o_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

                        IF(l_cur_restowed_data_rec.RESTOW_STATUS = 'XX') THEN

                            BEGIN
                                SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
                                INTO   l_v_lock_data
                                FROM   TOS_LL_BOOKED_LOADING
                                WHERE  PK_BOOKED_LOADING_ID = l_v_load_list_id
                                FOR UPDATE NOWAIT;

                            EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
                                RETURN;
                            WHEN OTHERS THEN
                                p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                                RETURN;
                            END;

                            /* update record in booked load list table */

                            UPDATE TOS_LL_BOOKED_LOADING
                            SET STOWAGE_POSITION   = l_cur_restowed_data_rec.STOWAGE_POSITION
                              , RECORD_CHANGE_USER = p_i_v_user_id
                              , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                            WHERE PK_BOOKED_LOADING_ID = l_v_load_list_id;
                        END IF;

                        IF(l_cur_restowed_data_rec.RESTOW_STATUS IN ('LR', 'RA', 'LC', 'RP', 'XX')) THEN
                            /* Start edited by vikas calling pre build sp
                            of dl_maintenance , 22.11.2011*/
                            /* get port sequence # for the current discharge list */
                            SELECT FK_PORT_SEQUENCE_NO
                            INTO l_v_fk_port_sequence_no
                            FROM TOS_LL_LOAD_LIST
                            WHERE PK_LOAD_LIST_ID = l_cur_restowed_data_rec.FK_LOAD_LIST_ID
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

                            PRE_FIND_DISCHARGE_LIST(
                                l_cur_restowed_data_rec.FK_BOOKING_NO,
                                P_I_V_VESSEL,
                                l_cur_restowed_data_rec.DN_EQUIPMENT_NO,
                                l_v_flag,
                                l_v_discharge_id,
                                p_o_v_err_cd
                            );
                            /* *23 end * */


                            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                                RETURN;
                            END IF;

                            IF(l_v_flag = 'D') THEN

                                BEGIN

                                    SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
                                    INTO   l_v_lock_data
                                    FROM   TOS_DL_BOOKED_DISCHARGE
                                    WHERE  PK_BOOKED_DISCHARGE_ID = l_v_discharge_id
                                    --AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012 -- *1
                                    FOR UPDATE NOWAIT;

                                    EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
                                    RETURN;
                                WHEN OTHERS THEN
                                    p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                                    RETURN;
                                END;

                                /* update record in booked load list table */
                                UPDATE
                                    TOS_DL_BOOKED_DISCHARGE
                                SET
                                    STOWAGE_POSITION = l_cur_restowed_data_rec.STOWAGE_POSITION
                                    , CONTAINER_GROSS_WEIGHT = l_cur_restowed_data_rec.CONTAINER_GROSS_WEIGHT -- added 14.12.2011,  update by vikas as, chatgamol
                                    , RECORD_CHANGE_USER = p_i_v_user_id
                                    , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                                WHERE
                                    PK_BOOKED_DISCHARGE_ID = l_v_discharge_id
                                    -- AND DISCHARGE_STATUS <> 'DI'; -- *1
                                    AND (STOWAGE_POSITION IS NULL OR DISCHARGE_STATUS <> 'DI'); -- *1

                            END IF;

                        END IF;
                    END IF;
                END IF;

                UPDATE TOS_RESTOW SET
                      DN_EQUIPMENT_NO = l_cur_restowed_data_rec.DN_EQUIPMENT_NO
                    , MIDSTREAM_HANDLING_CODE =    l_cur_restowed_data_rec.MIDSTREAM_HANDLING_CODE
                    , LOAD_CONDITION = l_cur_restowed_data_rec.LOAD_CONDITION
                    , RESTOW_STATUS    = l_cur_restowed_data_rec.RESTOW_STATUS
                    , STOWAGE_POSITION = l_cur_restowed_data_rec.STOWAGE_POSITION
                    , ACTIVITY_DATE_TIME = TO_DATE(l_cur_restowed_data_rec.ACTIVITY_DATE_TIME, 'DD/MM/YYYY HH24:MI')
                    , CONTAINER_GROSS_WEIGHT = l_cur_restowed_data_rec.CONTAINER_GROSS_WEIGHT
                    , DAMAGED = l_cur_restowed_data_rec.DAMAGED
                    , SEAL_NO = l_cur_restowed_data_rec.SEAL_NO
                    , PUBLIC_REMARK    = l_cur_restowed_data_rec.PUBLIC_REMARK
                    , RECORD_CHANGE_USER = p_i_v_user_id
                    , RECORD_CHANGE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                WHERE
                PK_RESTOW_ID = l_cur_restowed_data_rec.PK_RESTOW_ID;
            END IF;

        /* Deleted the selected record*/
        ELSIF (l_cur_restowed_data_rec.OPN_STATUS = PCE_EUT_COMMON.G_V_REC_DEL) THEN

            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RAISE exp_error_on_save;
            END IF;


            /* get lock on restow table */
            PCV_ELL_RECORD_LOCK (l_cur_restowed_data_rec.PK_RESTOW_ID
              , TO_CHAR(l_cur_restowed_data_rec.RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
              ,'RESTOWED', p_o_v_err_cd);

            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;

            -- Delete the record from table.
            DELETE FROM TOS_RESTOW
            WHERE PK_RESTOW_ID = l_cur_restowed_data_rec.PK_RESTOW_ID;

        END IF;

        -- Increment row number.
        IF (l_cur_restowed_data_rec.OPN_STATUS IS NULL OR l_cur_restowed_data_rec.OPN_STATUS <> PCE_EUT_COMMON.G_V_REC_DEL) THEN
           l_v_restow_row_num := l_v_restow_row_num + 1;
        END IF;

        END LOOP;

        IF l_v_errors IS NOT NULL AND (l_v_errors != PCE_EUT_COMMON.G_V_SUCCESS_CD
              AND   p_o_v_err_cd != PCE_EUT_COMMON.G_V_GE0005
              AND  p_o_v_err_cd != PCE_EUT_COMMON.G_V_GE0002) THEN
            p_o_v_err_cd := l_v_errors;

            RETURN;
        END IF;

    EXCEPTION
        WHEN exp_error_on_save THEN
            RETURN;

        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RETURN;

    END PRE_ELL_SAVE_RESTOW_TAB_MAIN;

   PROCEDURE PRE_ELL_RESTOW_VALIDATION (
         p_i_v_session_id          VARCHAR2
        ,p_i_row_num               NUMBER
        ,p_i_v_load_list_id        VARCHAR2
        ,p_i_v_equipment_no        VARCHAR2
        ,p_i_v_restow_id           VARCHAR2
        ,p_i_v_soc_coc             VARCHAR2
        ,p_i_v_hdr_port            VARCHAR2
        ,p_i_v_discharge_etd       VARCHAR2
        ,p_i_v_hdr_etd_tm          VARCHAR2
        ,p_o_v_err_cd          OUT VARCHAR2
    ) AS

        l_v_errors         VARCHAR2(2000);
        l_v_record_count NUMBER := 0;
        l_v_shipment_typ   TOS_RESTOW.DN_SHIPMENT_TYP%TYPE; -- *2

    BEGIN
        -- Set the error code to its default value (0000);
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        l_v_errors   := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        SELECT COUNT(1)
        INTO   l_v_record_count
        FROM   TOS_RESTOW_TMP
        WHERE  FK_LOAD_LIST_ID = p_i_v_load_list_id
        AND    DN_EQUIPMENT_NO = p_i_v_equipment_no
        AND    PK_RESTOW_ID   != NVL(p_i_v_restow_id, ' ')
        AND    SESSION_ID      = p_i_v_session_id;

        -- When count is more then zero means record is already availabe, show error
        IF(l_v_record_count > 0) THEN
            p_o_v_err_cd := 'ELL.SE0126' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
        END IF;

        SELECT COUNT(1)
        INTO   l_v_record_count
        FROM   TOS_LL_BOOKED_LOADING     BD,
               TOS_RESTOW_TMP            RS
        WHERE  RS.FK_LOAD_LIST_ID  =  BD.FK_LOAD_LIST_ID
        AND    RS.FK_LOAD_LIST_ID  =  p_i_v_load_list_id
        AND    RS.DN_EQUIPMENT_NO  =  BD.DN_EQUIPMENT_NO
        AND    RS.DN_EQUIPMENT_NO  =  p_i_v_equipment_no
        --AND    RS.RESTOW_STATUS    IN ('LR','RA','RP')
        AND    BD.LOADING_STATUS != 'RB';

        -- Equipment# present in Booked tab with status other than 'ROB'
        IF(l_v_record_count > 0) THEN
              p_o_v_err_cd := 'ELL.SE0123' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
              RETURN;
        END IF;

        -- Equipment# present in overlanded tab
        SELECT COUNT(1)
        INTO   l_v_record_count
        FROM   TOS_LL_OVERSHIPPED_CONTAINER OL,
               TOS_RESTOW_TMP RS
        WHERE  OL.FK_LOAD_LIST_ID = RS.FK_LOAD_LIST_ID
        AND    RS.FK_LOAD_LIST_ID = p_i_v_load_list_id
        AND    OL.EQUIPMENT_NO    = RS.DN_EQUIPMENT_NO
        AND    RS.DN_EQUIPMENT_NO = p_i_v_equipment_no;

        IF(l_v_record_count > 0) THEN
              p_o_v_err_cd := 'ELL.SE0125' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
              RETURN;
        END IF;
        /*
            *2 : Changes starts

        *
            Get the shipment type for the restow tab#
        */
        BEGIN
            l_v_shipment_typ := NULL;
            SELECT
                DN_SHIPMENT_TYP
            INTO
                l_v_shipment_typ
            FROM
                TOS_RESTOW
            WHERE
                PK_RESTOW_ID = p_i_v_restow_id;

        EXCEPTION
            WHEN OTHERS THEN
                l_v_shipment_typ := NULL;
        END;
        /*
            *2 : Changes end
        */

          /* When OLD Equipment Type is COC then new equipment should be COC */
        IF(p_i_v_soc_coc = 'C') AND (NVL(l_v_shipment_typ, '*') <> 'UC' )THEN -- *2
            IF p_i_v_equipment_no IS NOT NULL THEN
                /* Equipment Type should be COC */
                IF(PCE_EUT_COMMON.FN_CHECK_COC_FLAG (
                          p_i_v_equipment_no
                        , p_i_v_hdr_port
                        , p_i_v_discharge_etd
                        , p_i_v_hdr_etd_tm
                        , p_o_v_err_cd
                    ) = FALSE) THEN
                    p_o_v_err_cd := 'EDL.SE0132' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                    RETURN;
                END IF;
            END IF;
        END IF;


    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RETURN;
    END PRE_ELL_RESTOW_VALIDATION;


    PROCEDURE PRE_ELL_OL_VAL_PORT_CLASS(
          p_i_v_port_code              VARCHAR2
        , p_i_v_unno                   VARCHAR2
        , p_i_v_variant                VARCHAR2
        , p_i_v_imdg_class             VARCHAR2
        , p_i_v_port_class             VARCHAR2
        , p_i_v_port_class_type        VARCHAR2
        , p_i_v_equipment_no           VARCHAR2
        , p_o_v_err_cd                 OUT VARCHAR2
    ) AS

    /*
        Start Added by Vikas, 16.12.2011
    */
    l_rec_count             NUMBER := 0;
    l_v_port_code           PORT_CLASS_TYPE.PORT_CODE%TYPE;
    l_v_unno                PORT_CLASS.UNNO%TYPE;
    l_v_variant             PORT_CLASS.VARIANT%TYPE;
    l_v_imdg_class          PORT_CLASS.IMDG_CLASS%TYPE;
    l_v_port_class          PORT_CLASS.PORT_CLASS_CODE%TYPE;
    l_v_port_class_type     PORT_CLASS.PORT_CLASS_TYPE%TYPE;
    /*
        End added by vikas, 16.12.2011
    */
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /*
            Start modified by vikas, because variant is not
            matching due to case, k'chatgamol,16.12.2011
        */
        l_v_port_code           := LOWER(p_i_v_port_code);
        l_v_unno                := LOWER(p_i_v_unno);
        l_v_variant             := LOWER(p_i_v_variant);
        l_v_imdg_class          := LOWER(p_i_v_imdg_class);
        l_v_port_class          := LOWER(p_i_v_port_class);
        l_v_port_class_type     := LOWER(p_i_v_port_class_type);

        IF p_i_v_unno IS NOT NULL AND
            -- p_i_v_variant IS NOT NULL AND
            p_i_v_imdg_class IS NOT NULL AND
            l_v_port_class IS NOT NULL THEN

            SELECT COUNT(1)
            INTO l_rec_count
            FROM PORT_CLASS_TYPE PCT, PORT_CLASS PC
            WHERE LOWER(PCT.PORT_CODE)=l_v_port_code
            AND LOWER(PC.PORT_CLASS_TYPE) = LOWER(PCT.PORT_CLASS_TYPE)
            AND LOWER(PC.UNNO) = l_v_unno
            AND LOWER(PC.VARIANT) = l_v_variant
            AND LOWER(PC.IMDG_CLASS) = l_v_imdg_class
            AND LOWER(PC.PORT_CLASS_CODE) = l_v_port_class
            AND LOWER(PC.PORT_CLASS_TYPE) = l_v_port_class_type;

            /*
                validataion fails then validate port class without variant, k'chatgamol,16.12.2011
            */
            IF ( (l_rec_count < 1) AND(NVL(l_v_variant, '-')  = '-') )THEN
                SELECT
                    COUNT(1)
                INTO
                    l_rec_count
                FROM
                    PORT_CLASS_TYPE PCT,
                    PORT_CLASS PC
                WHERE
                    LOWER(PCT.PORT_CODE) = l_v_port_code
                    AND LOWER(PC.PORT_CLASS_TYPE) = LOWER(PCT.PORT_CLASS_TYPE)
                    AND LOWER(PC.UNNO) = l_v_unno
                    AND LOWER(PC.IMDG_CLASS) = l_v_imdg_class
                    AND LOWER(PC.PORT_CLASS_CODE) = l_v_port_class
                    AND LOWER(PC.PORT_CLASS_TYPE) = l_v_port_class_type;
            END IF;

            IF(l_rec_count < 1) THEN
                p_o_v_err_cd := 'ELL.SE0113'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
        END IF;
        /*
            End modified by vikas, 16.12.2011
        */

    EXCEPTION
        WHEN OTHERS THEN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_OL_VAL_PORT_CLASS;

        /*    Check for the shipment term */
        PROCEDURE PRE_SHIPMENT_TERM_OL_CODE(
              p_i_v_shipmnt_cd       VARCHAR2
            , p_i_v_equipment_no     VARCHAR2
            , p_o_v_err_cd       OUT VARCHAR2
        ) AS
        l_rec_count             NUMBER := 0;
        BEGIN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

            IF p_i_v_shipmnt_cd IS NOT NULL THEN
                SELECT COUNT(1)
                INTO l_rec_count
                FROM ITP070
                WHERE MMMODE = p_i_v_shipmnt_cd;

                IF(l_rec_count < 1) THEN
                    p_o_v_err_cd := 'ELL.SE0128'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                    RETURN;
                END IF;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        END PRE_SHIPMENT_TERM_OL_CODE;

    PROCEDURE PRE_ELL_OL_VAL_IMDG(
          p_i_v_unno         IN  VARCHAR2
        , p_i_v_variant      IN  VARCHAR2
        , p_i_v_imdg         IN  VARCHAR2
        , p_i_v_equipment_no IN  VARCHAR2
        , p_o_v_err_cd       OUT VARCHAR2
    ) AS
        l_rec_count                NUMBER := 0;

        /*
            Start Added by Vikas, 16.12.2011
        */
        l_v_unno                PORT_CLASS.UNNO%TYPE;
        l_v_variant             PORT_CLASS.VARIANT%TYPE;
        l_v_imdg                PORT_CLASS.IMDG_CLASS%TYPE;
        l_v_equipment_no        TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE;
        /*
            End added by vikas, 16.12.2011
        */

    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /*
            Start modified by vikas, because variant is not
            matching due to case, k'chatgamol,16.12.2011
        */
        l_v_unno             := LOWER(p_i_v_unno);
        l_v_variant          := LOWER(p_i_v_variant);
        l_v_imdg             := LOWER(p_i_v_imdg);
        l_v_equipment_no     := LOWER(p_i_v_equipment_no);

        --IF l_v_unno IS NOT NULL AND l_v_variant IS NOT NULL AND l_v_imdg IS NOT NULL THEN --*24
        if L_V_UNNO is not null and L_V_IMDG is not null then
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
                l_rec_count := 0;
                SELECT
                    COUNT(1)
                INTO
                    l_rec_count
                FROM
                    DG_UNNO_CLASS_RESTRICTIONS
                WHERE
                    LOWER(UNNO)           = l_v_unno
                    and LOWER(IMDG_CLASS) = L_V_IMDG;
           -- END IF;

            IF(l_rec_count < 1) THEN
                p_o_v_err_cd := 'ELL.SE0114' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
        END IF;
        /*
            End modified by vikas, 16.12.2011
        */

    EXCEPTION
        WHEN OTHERS THEN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_OL_VAL_IMDG;

    PROCEDURE PRE_ELL_OL_VAL_HAND_CODE(
          p_i_v_shi_code     IN  VARCHAR2
         , p_i_v_equipment_no IN  VARCHAR2
        , p_o_v_err_cd       OUT VARCHAR2
    ) AS
        l_rec_count           NUMBER := 0;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF p_i_v_shi_code IS NOT NULL THEN

        SELECT COUNT(1)
        INTO l_rec_count
        FROM SHP007
        WHERE SHI_CODE = p_i_v_shi_code
        AND RECORD_STATUS = 'A';

        IF(l_rec_count < 1) THEN
            p_o_v_err_cd := 'ELL.SE0115'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
        END IF;
    END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_OL_VAL_HAND_CODE;

    PROCEDURE PRE_ELL_OL_VAL_OPERATOR_CODE(
          p_i_v_oper_cd      IN  VARCHAR2
        , p_i_v_equipment_no IN  VARCHAR2
        , p_o_v_err_cd       OUT VARCHAR2
    ) AS
        l_rec_count             NUMBER := 0;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF p_i_v_oper_cd IS NOT NULL THEN
            SELECT COUNT(1)
            INTO l_rec_count
            FROM OPERATOR_CODE_MASTER
            WHERE OPERATOR_CODE = p_i_v_oper_cd;

            IF(l_rec_count < 1) THEN
                p_o_v_err_cd := 'ELL.SE0117' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_OL_VAL_OPERATOR_CODE;

    PROCEDURE PRE_ELL_OL_VAL_CLR_CODE(
          p_i_v_clr_code    IN VARCHAR2
        , p_i_v_equipment_no IN  VARCHAR2
        , p_o_v_err_cd      OUT VARCHAR2
    ) AS
          l_rec_count       NUMBER := 0;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF p_i_v_clr_code IS NOT NULL THEN
            SELECT COUNT(1)
            INTO l_rec_count
            FROM SHP041
            WHERE CLR_CODE = p_i_v_clr_code
            AND RECORD_STATUS = 'A';

            IF(l_rec_count < 1) THEN
                /*Invalid Container Loading Remark code*/
                p_o_v_err_cd := 'ELL.SE0116' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_OL_VAL_CLR_CODE;

    PROCEDURE PRE_ELL_OL_VAL_UNNO(
          p_i_v_unno         IN VARCHAR2
        , p_i_v_variant      IN  VARCHAR2
        , p_i_v_equipment_no IN  VARCHAR2
        , p_o_v_err_cd      OUT VARCHAR2
    ) AS
        l_rec_count       NUMBER := 0;

        /*
            Start Added by Vikas, 16.12.2011
        */
        l_v_unno                PORT_CLASS.UNNO%TYPE;
        l_v_variant             PORT_CLASS.VARIANT%TYPE;
        /*
            End added by vikas, 16.12.2011
        */
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /*
            Start modified by vikas, because variant is not
            matching due to case, k'chatgamol,16.12.2011
        */
        l_v_unno     := LOWER(p_i_v_unno);
        L_V_VARIANT  := LOWER(P_I_V_VARIANT);

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
             If P_I_V_UNNO is not null then -- *24
                SELECT
                    COUNT(1)
                INTO
                    l_rec_count
                FROM
                    DG_UNNO_CLASS_RESTRICTIONS
                WHERE
                    LOWER(UNNO) = L_V_UNNO;
            

            IF(l_rec_count < 1) THEN
                p_o_v_err_cd := 'ELL.SE0118' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            end if;
        END IF; -- *24
        /*
            End modified by vikas, 16.12.2011
        */
    EXCEPTION
    WHEN OTHERS THEN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_OL_VAL_UNNO;

    /*    Check for the Equipment Type in Master Table. */
    PROCEDURE PRE_ELL_VAL_EQUIPMENT_TYPE(
          p_i_v_oper_cd      IN VARCHAR2
        , p_i_v_equipment_no IN  VARCHAR2
        , p_o_v_err_cd       OUT VARCHAR2
    ) AS
        l_rec_count             NUMBER := 0;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF p_i_v_oper_cd IS NOT NULL THEN

            SELECT COUNT(1)
            INTO   l_rec_count
            FROM   ITP075
            WHERE  TRTYPE = p_i_v_oper_cd
            AND    TRRCST = 'A';

            IF(l_rec_count < 1) THEN
                p_o_v_err_cd := 'EDL.SE0151' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
       END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_VAL_EQUIPMENT_TYPE;

    /*    Check for the Port Code Master Table. */
    PROCEDURE PRE_ELL_VAL_PORT_CODE(
          p_i_v_oper_cd     IN VARCHAR2
        , p_i_v_equipment_no IN  VARCHAR2
        , p_o_v_err_cd      OUT VARCHAR2
    ) AS
        l_rec_count             NUMBER := 0;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF p_i_v_oper_cd IS NOT NULL THEN
            SELECT COUNT(1)
            INTO   l_rec_count
            FROM   ITP040
            WHERE  PICODE = p_i_v_oper_cd
            AND    PIRCST = 'A';

            IF(l_rec_count < 1) THEN
                p_o_v_err_cd := 'EDL.SE0153' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_VAL_PORT_CODE;

    /*    Check for the Port Code Master Table. */
    PROCEDURE PRE_ELL_VAL_PORT_TERMINAL_CODE(
          p_i_v_oper_cd      IN  VARCHAR2
        , p_i_v_equipment_no IN  VARCHAR2
        , p_o_v_err_cd       OUT VARCHAR2
    ) AS
        l_rec_count             NUMBER := 0;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF p_i_v_oper_cd IS NOT NULL THEN
            SELECT COUNT(1)
            INTO   l_rec_count
            FROM   ITP130
            WHERE  TQTERM = p_i_v_oper_cd
            AND    TQRCST = 'A';

            IF(l_rec_count < 1) THEN
                p_o_v_err_cd := 'EDL.SE0158'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_ELL_VAL_PORT_TERMINAL_CODE;

    PROCEDURE PRE_LL_SPLIT
    (
          p_i_v_booked_loading_id                     NUMBER
        , p_o_v_err_cd                    OUT NOCOPY  VARCHAR2
    ) AS
        p_o_v_return_status  NUMBER;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        p_o_v_return_status := '';

        PRE_TOS_MOVE_TO_OVERSHIPPED (
              p_i_v_booked_loading_id
            , p_o_v_return_status
        );

        IF (p_o_v_return_status = 1 ) THEN
            p_o_v_err_cd:= 'ELL.SE0130';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END PRE_LL_SPLIT;

    PROCEDURE PRE_LL_COMMON_MATCHING
    (
          p_i_v_match_type                       VARCHAR2
        , p_i_v_load_list_id                     NUMBER
        , p_i_v_dl_container_seq                 NUMBER
        , p_i_v_overshipped_container_id         NUMBER
        , p_i_v_equipment_no                     VARCHAR2
        , p_o_v_err_cd               OUT NOCOPY  VARCHAR2
    ) AS
        p_o_v_return_status                   NUMBER;
        l_v_rec_count                        NUMBER := 0;
        l_exp_finish                         EXCEPTION;
        l_v_equipment_no                    TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        p_o_v_return_status := '';

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
            SELECT COUNT(1), dn_equipment_no
            INTO l_v_rec_count, l_v_equipment_no
            FROM TOS_LL_BOOKED_LOADING
            WHERE FK_LOAD_LIST_ID = p_i_v_load_list_id
            AND  RECORD_STATUS = 'A'
            AND DN_EQUIPMENT_NO = p_i_v_equipment_no
            GROUP BY dn_equipment_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_v_equipment_no := NULL;
                l_v_rec_count := 0;
        END;

        IF ( (l_v_rec_count > 0) AND (NVL(l_v_equipment_no,'*') <> p_i_v_equipment_no) ) THEN
            /* Overshipped Equipment no# is already available in booked tab,
             show error message. "Equipment alredy exists in booked tab.." */
            p_o_v_err_cd := 'EDL.SE0182';
            RAISE l_exp_finish;
        END IF;

        /* Call PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING for Automatch */
        IF(p_i_v_match_type = 'A') THEN
            PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING(
                  p_i_v_match_type
                , 'LL'
                , ''
                , ''
                , ''
                , p_i_v_load_list_id
                , p_i_v_dl_container_seq
                , p_i_v_overshipped_container_id
                , p_o_v_return_status
            );
        ELSE
            /* Call PCE_ECM_EDI.PRE_TOS_LLDL_MANUAL_MATCHING for Manual Match */
            PCE_ECM_EDI.PRE_TOS_LLDL_MANUAL_MATCHING(
                  p_i_v_match_type
                , 'LL'
                , ''
                , ''
                , ''
                , p_i_v_load_list_id
                , p_i_v_dl_container_seq
                , p_i_v_overshipped_container_id

                , p_o_v_return_status
            );


        END IF;

        IF (p_o_v_return_status = '1') THEN
            p_o_v_err_cd:= 'ELL.SE0129';
            RAISE l_exp_finish;
        END IF;

    EXCEPTION
        WHEN l_exp_finish THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END PRE_LL_COMMON_MATCHING;

    PROCEDURE PRE_TOS_MOVE_TO_OVERSHIPPED (
       p_i_n_booked_loading_id  IN          NUMBER
     , p_o_v_return_status      OUT  NOCOPY VARCHAR2
    ) AS

       l_v_sql_id         VARCHAR2(10);
       l_exce_main        EXCEPTION;
       l_d_time           TIMESTAMP;
       l_v_user           VARCHAR2(10) := 'EZLL';
       l_v_err_code       VARCHAR2(10);
       l_v_err_desc       VARCHAR2(100);
       CURSOR l_cur_booked_loading
       IS
          SELECT LOADING_STATUS, NVL(PREADVICE_FLAG,'N') PREADVICE_FLAG
               , FK_BOOKING_NO, EQUPMENT_NO_SOURCE, FK_BKG_EQUIPM_DTL
          FROM TOS_LL_BOOKED_LOADING
          WHERE PK_BOOKED_LOADING_ID  = p_i_n_booked_loading_id;
    BEGIN
       -- Insert data into overshipped container from booked loading based on passed parameters
       l_v_sql_id := 'SQL-00001';
       FOR l_cur_booked_data IN l_cur_booked_loading
       LOOP
          IF ((l_cur_booked_data.PREADVICE_FLAG ='Y' AND l_cur_booked_data.LOADING_STATUS = 'BK') OR (l_cur_booked_data.LOADING_STATUS = 'LO')) THEN
             l_d_time := CURRENT_TIMESTAMP;
             INSERT INTO TOS_LL_OVERSHIPPED_CONTAINER (
                        PK_OVERSHIPPED_CONTAINER_ID
                      , FK_LOAD_LIST_ID
                      , BOOKING_NO
                      , BKG_TYP
                      , BOOKING_NO_SOURCE
                      , EQUIPMENT_NO
                      , EQUIPMENT_NO_QUESTIONABLE_FLAG
                      , EQ_SIZE
                      , EQ_TYPE
                      , LOCAL_TERMINAL_STATUS
                      , LOAD_CONDITION
                      , SPECIAL_HANDLING
                      , FLAG_SOC_COC
                      , SHIPMENT_TERM
                      , SHIPMENT_TYPE
                      , CONTAINER_GROSS_WEIGHT
                      , DISCHARGE_PORT
                      , STOWAGE_POSITION
                      , MLO_VESSEL
                      , MLO_VOYAGE
                      , MLO_VESSEL_ETA
                      , HANDLING_INSTRUCTION_1
                      , HANDLING_INSTRUCTION_2
                      , HANDLING_INSTRUCTION_3
                      , CONTAINER_LOADING_REM_1
                      , CONTAINER_LOADING_REM_2
                      , ACTIVITY_DATE_TIME
                      , SLOT_OPERATOR
                      , CONTAINER_OPERATOR
                      , MIDSTREAM_HANDLING_CODE
                      , REEFER_TEMPERATURE
                      , REEFER_TMP_UNIT
                      , IMDG_CLASS
                      , UN_NUMBER
                      , UN_NUMBER_VARIANT
                      , PORT_CLASS_TYPE
                      , PORT_CLASS
                      , FLASHPOINT
                      , FLASHPOINT_UNIT
                      , RESIDUE_ONLY_FLAG
                      , OVERHEIGHT_CM
                      , OVERWIDTH_LEFT_CM
                      , OVERWIDTH_RIGHT_CM
                      , OVERLENGTH_FRONT_CM
                      , OVERLENGTH_REAR_CM
                      , VOID_SLOT
                      , POD_TERMINAL
                      , MLO_DEL
                      , DAMAGED
                      , FINAL_DEST
                      , FULL_MT
                      , FUMIGATION_ONLY
                      , MLO_POD1
                      , MLO_POD2
                      , MLO_POD3
                      , NXT_POD1
                      , NXT_POD2
                      , NXT_POD3
                      , FINAL_POD
                      , NXT_DIR
                      , NXT_SRV
                      , NXT_VESSEL
                      , NXT_VOYAGE
                      , OUT_SLOT_OPERATOR
                      , LOCAL_STATUS
                      , SEAL_NO
                      , SPECIAL_CARGO
                      , DA_ERROR
                      , HUMIDITY
                      , VENTILATION
                      , PREADVICE_FLAG
                      , EX_MLO_VESSEL
                      , EX_MLO_VESSEL_ETA
                      , EX_MLO_VOYAGE
                      , RECORD_STATUS
                      , RECORD_ADD_USER
                      , RECORD_ADD_DATE
                      , RECORD_CHANGE_USER
                      , RECORD_CHANGE_DATE
                      )
             SELECT     SE_OCZ02.NEXTVAL
                      , FK_LOAD_LIST_ID
                      , FK_BOOKING_NO
                      , DN_BKG_TYP
                      , 'S'
                      , DN_EQUIPMENT_NO
                      , 'N'
                      , DN_EQ_SIZE
                      , DN_EQ_TYPE
                      , LOCAL_TERMINAL_STATUS
                      , LOAD_CONDITION
                      , DN_SPECIAL_HNDL
                      , DN_SOC_COC
                      , DN_SHIPMENT_TERM
                      , DN_SHIPMENT_TYP
                      , CONTAINER_GROSS_WEIGHT
                      , DN_DISCHARGE_PORT
                      , STOWAGE_POSITION
                      , MLO_VESSEL
                      , MLO_VOYAGE
                      , MLO_VESSEL_ETA
                      , FK_HANDLING_INSTRUCTION_1
                      , FK_HANDLING_INSTRUCTION_2
                      , FK_HANDLING_INSTRUCTION_3
                      , CONTAINER_LOADING_REM_1
                      , CONTAINER_LOADING_REM_2
                      , ACTIVITY_DATE_TIME
                      , FK_SLOT_OPERATOR
                      , FK_CONTAINER_OPERATOR
                      , MIDSTREAM_HANDLING_CODE
                      , REEFER_TMP
                      , REEFER_TMP_UNIT
                      , FK_IMDG
                      , FK_UNNO
                      , FK_UN_VAR
                      , FK_PORT_CLASS_TYP
                      , FK_PORT_CLASS
                      , FLASH_POINT
                      , FLASH_UNIT
                      , RESIDUE_ONLY_FLAG
                      , OVERHEIGHT_CM
                      , OVERWIDTH_LEFT_CM
                      , OVERWIDTH_RIGHT_CM
                      , OVERLENGTH_FRONT_CM
                      , OVERLENGTH_REAR_CM
                      , VOID_SLOT
                      , DN_DISCHARGE_TERMINAL
                      , MLO_DEL
                      , DAMAGED
                      , FINAL_DEST
                      , DN_FULL_MT
                      , FUMIGATION_ONLY
                      , MLO_POD1
                      , MLO_POD2
                      , MLO_POD3
                      , DN_NXT_POD1
                      , DN_NXT_POD2
                      , DN_NXT_POD3
                      , DN_FINAL_POD
                      , DN_NXT_DIR
                      , DN_NXT_SRV
                      , DN_NXT_VESSEL
                      , DN_NXT_VOYAGE
                      , FK_SLOT_OPERATOR
                      , LOCAL_STATUS
                      , SEAL_NO
                      , FK_SPECIAL_CARGO
                      , 'N'
                      , DN_HUMIDITY
                      , DN_VENTILATION
                      , l_cur_booked_data.PREADVICE_FLAG
                      , EX_MLO_VESSEL
                      , EX_MLO_VESSEL_ETA
                      , EX_MLO_VOYAGE
                      , 'A'
                      , l_v_user
                      , l_d_time
                      , l_v_user
                      , l_d_time
             FROM  TOS_LL_BOOKED_LOADING
             WHERE PK_BOOKED_LOADING_ID  = p_i_n_booked_loading_id;

             IF SQL%NOTFOUND THEN
                l_v_err_code   := TO_CHAR(SQLCODE);
                l_v_err_desc   := SUBSTR(SQLERRM,1,100);
                RAISE l_exce_main;
             END IF;
          END IF;
          --Updating loading status in TOS_LL_BOOKED_LOADING table when loading status is 'LO'.
          l_v_sql_id := 'SQL-00002';
          IF l_cur_booked_data.LOADING_STATUS = 'LO' THEN
             UPDATE TOS_LL_BOOKED_LOADING
             SET    LOADING_STATUS = 'BK'
             WHERE  PK_BOOKED_LOADING_ID = p_i_n_booked_loading_id;
         ELSIF l_cur_booked_data.LOADING_STATUS = 'BK' THEN
             UPDATE TOS_LL_BOOKED_LOADING
             SET    LOADING_STATUS = 'BK'
                  , PREADVICE_FLAG  = 'N'
             WHERE  PK_BOOKED_LOADING_ID = p_i_n_booked_loading_id;
          END IF;
          IF SQL%NOTFOUND THEN
             l_v_err_code   := TO_CHAR(SQLCODE);
             l_v_err_desc   := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
          END IF;
          --Remove container no from BKP009 if equipment no from source is from booking.
          l_v_sql_id := 'SQL-00003';
          IF l_cur_booked_data.EQUPMENT_NO_SOURCE != 'B' THEN
             UPDATE BKP009
             SET    BICTRN = ''
             WHERE  BIBKNO = l_cur_booked_data.FK_BOOKING_NO
             AND    BISEQN = l_cur_booked_data.FK_BKG_EQUIPM_DTL;
          END IF;
          IF SQL%NOTFOUND THEN
               RAISE l_exce_main;
          END IF;
       END LOOP;
       p_o_v_return_status := '0';
    EXCEPTION
       WHEN l_exce_main THEN
          ROLLBACK;
          p_o_v_return_status := '1';
          PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(p_i_n_booked_loading_id
                                                         , '--'
                                                         , 'I'
                                                         , l_v_sql_id||'~'||l_v_err_code||'~'||l_v_err_desc
                                                         , 'A'
                                                         , l_v_user
                                                         , CURRENT_TIMESTAMP
                                                         , l_v_user
                                                         , CURRENT_TIMESTAMP
                                                          );
          COMMIT;
       WHEN OTHERS THEN
          ROLLBACK;
          p_o_v_return_status := '1';
          l_v_err_code   := TO_CHAR (SQLCODE);
          l_v_err_desc   := SUBSTR(SQLERRM,1,100);
          PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(p_i_n_booked_loading_id
                                                         , '--'
                                                         , 'I'
                                                         , l_v_sql_id||'~'||l_v_err_code||'~'||l_v_err_desc
                                                         , 'A'
                                                         , l_v_user
                                                         , CURRENT_TIMESTAMP
                                                         , l_v_user
                                                         , CURRENT_TIMESTAMP
                                                          );
          COMMIT;
    END PRE_TOS_MOVE_TO_OVERSHIPPED;

    PROCEDURE PCV_ELL_RECORD_LOCK(
        p_i_v_id            VARCHAR2
      , p_i_v_rec_dt        VARCHAR2
      , p_i_v_tab_name      VARCHAR2
      , p_o_v_err_cd        OUT VARCHAR2
    )

    AS
        l_v_lock_data           VARCHAR2(14);
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- get lock on the table.
        IF(p_i_v_tab_name = 'BOOKED') THEN

            SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
            INTO l_v_lock_data
            FROM TOS_LL_BOOKED_LOADING
            WHERE PK_BOOKED_LOADING_ID = p_i_v_id
            FOR UPDATE NOWAIT;

        ELSIF(p_i_v_tab_name = 'OVERSHIPPED') THEN

            SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
            INTO l_v_lock_data
            FROM TOS_LL_OVERSHIPPED_CONTAINER
            WHERE PK_OVERSHIPPED_CONTAINER_ID = p_i_v_id
            FOR UPDATE NOWAIT;

        ELSIF(p_i_v_tab_name = 'RESTOWED') THEN

            SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
            INTO l_v_lock_data
            FROM TOS_RESTOW
            WHERE PK_RESTOW_ID = p_i_v_id
            FOR UPDATE NOWAIT;

        ELSE

            p_o_v_err_cd := 'ILLEGAL ARGUMENT';
            RETURN;
        END IF;

        IF(p_i_v_rec_dt IS NOT NULL) THEN
            IF (l_v_lock_data <> p_i_v_rec_dt) THEN
                -- Record updated by another user.
                --p_o_v_err_cd :=  PCE_EUT_COMMON.G_V_GE0006 ; --*25
               -- RETURN;--*25
               NULL;--*25
            END IF;
        END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        --PCE_EUT_COMMON.G_V_GE0005 : Record Deleted by Another User
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
        RETURN;
      WHEN OTHERS THEN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
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
    FUNCTION FN_ELL_CONVERTDATE (
          p_i_v_date      VARCHAR2
        , p_i_v_time      VARCHAR2
        , p_i_v_port      VARCHAR2
        )
    RETURN DATE
    IS
        l_v_date     DATE   := null;
    BEGIN

        SELECT (TO_DATE(p_i_v_date,'RRRRMMDD')+(1/1440*(MOD(p_i_v_time, 100)+FLOOR(p_i_v_time/100)*60))-(1/1440*(MOD(P.PIVGMT, 100)+FLOOR(P.PIVGMT/100)*60)))
        INTO l_v_date
        FROM ITP040 P
        WHERE PICODE = p_i_v_port;

        RETURN l_v_date;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN l_v_date;
    END;

    PROCEDURE PRE_ELL_SAVE_LL_STATUS (
          p_i_v_load_list_id                VARCHAR2
        , p_i_v_load_list_status            VARCHAR2
        , p_i_v_user_id                     VARCHAR2
        , p_i_v_session_id                  VARCHAR2 -- *19
        , p_i_v_date                        VARCHAR2
        , p_o_v_err_cd                  OUT VARCHAR2
    )
    AS
        l_v_lock_data                   VARCHAR2(14);
        l_v_ll_status                   VARCHAR2(2);
        exp_error_on_save               EXCEPTION;
        l_o_v_booking                   VARCHAR2(4000) DEFAULT NULL; -- *14
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /* perform validations for load list status update */
        PRE_ELL_LL_STATUS_VALIDATION(p_i_v_load_list_id , p_i_v_load_list_status , p_o_v_err_cd);

        IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
           return;
        END IF;

        BEGIN
            SELECT LOAD_LIST_STATUS
            INTO   l_v_ll_status
            FROM   TOS_LL_LOAD_LIST
            WHERE  PK_LOAD_LIST_ID =  p_i_v_load_list_id
            FOR UPDATE NOWAIT;

        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                -- PCE_EUT_COMMON.G_V_GE0005 : Record Deleted by Another User
                p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0005;
                RETURN;
            WHEN OTHERS THEN
                p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RETURN;
        END;

        /* If Load List Status value is changed from a lower value to a higher value*/
        IF ((l_v_ll_status = C_OPEN) AND
            (p_i_v_load_list_status = LOADING_COMPLETE OR
             p_i_v_load_list_status = READY_FOR_INVOICE OR
             p_i_v_load_list_status = WORK_COMPLETE
            )) THEN

            /* *19 start * */
            /* * check duplicate cell location exists or not * */
            PCE_EDL_DLMAINTENANCE.PRE_CHECK_DUP_CELL_LOCATION(
                P_I_V_SESSION_ID,
                LL_DL_FLAG,
                P_I_V_LOAD_LIST_ID,
                P_O_V_ERR_CD
            );
            /* *19 end * */

            /* General Error Checking */
            IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                RETURN;
            END IF;

            /* *19 end * */

            /* *21 start * */
            L_O_V_BOOKING := NULL;
            PCE_EDL_DLMAINTENANCE.PRE_BUNDLE_UPDATE_VALIDATION(
                p_i_v_load_list_id,
                LL_DL_FLAG,
                l_o_v_booking
            );
            IF (L_O_V_BOOKING IS NOT NULL) THEN
                p_o_v_err_cd := 'EDL.SE0190' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_o_v_booking ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
            L_O_V_BOOKING := NULL;
            /* *21 end * */


            /* Call procedure PRE_BKG_CONDENSE */
            PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_CONDENSE(
                p_i_v_load_list_id
              , p_o_v_err_cd
            );

            IF(p_o_v_err_cd = '0' ) THEN
                p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
            ELSE
                /* Error in calling PRE_BKG_CONDENSE.*/
                p_o_v_err_cd := 'ELL.SE0133';
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
        BEGIN
            IF (p_i_v_load_list_status = LOADING_COMPLETE OR
                    p_i_v_load_list_status = READY_FOR_INVOICE OR
                    p_i_v_load_list_status = WORK_COMPLETE
                ) THEN

                     UPDATE
                        TOS_LL_LOAD_LIST
                    SET
                        FIRST_COMPLETE_USER   = p_i_v_user_id
                        , FIRST_COMPLETE_DATE = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
                    WHERE
                        PK_LOAD_LIST_ID  = p_i_v_load_list_id
                        AND FIRST_COMPLETE_USER IS NULL
                        AND FIRST_COMPLETE_DATE IS NULL;
                    /*
                    INSERT INTO TOS_LL_LOAD_LIST_HIS (
                        PK_LOAD_LIST_ID
                        , DN_SERVICE_GROUP_CODE
                        , FK_SERVICE
                        , FK_VESSEL
                        , FK_VOYAGE
                        , FK_DIRECTION
                        , FK_PORT_SEQUENCE_NO
                        , FK_VERSION
                        , DN_PORT
                        , DN_TERMINAL
                        , LOAD_LIST_STATUS
                        , RECORD_STATUS
                        , RECORD_ADD_USER
                        , RECORD_ADD_DATE
                        , RECORD_CHANGE_USER
                        , RECORD_CHANGE_DATE
                    ) SELECT
                        PK_LOAD_LIST_ID
                        , DN_SERVICE_GROUP_CODE
                        , FK_SERVICE
                        , FK_VESSEL
                        , FK_VOYAGE
                        , FK_DIRECTION
                        , FK_PORT_SEQUENCE_NO
                        , FK_VERSION
                        , DN_PORT
                        , DN_TERMINAL
                        , LOAD_LIST_STATUS
                        , RECORD_STATUS
                        , RECORD_ADD_USER
                        , RECORD_ADD_DATE
                        , RECORD_CHANGE_USER
                        , RECORD_CHANGE_DATE
                    FROM
                        TOS_LL_LOAD_LIST
                    WHERE
                        PK_LOAD_LIST_ID  = p_i_v_load_list_id;
                    */
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        /*
            *13: Changes end
            *14: Start
        */
        IF (p_i_v_load_list_status = READY_FOR_INVOICE OR
                p_i_v_load_list_status = WORK_COMPLETE
        )THEN
            PCE_EDL_DLMAINTENANCE.PRE_LIST_OPEN_BOOOKINGS  (
                p_i_v_load_list_id,
                LL_DL_FLAG,
                l_o_v_booking
            );

            IF (l_o_v_booking IS NOT NULL) THEN
                p_o_v_err_cd := 'EDL.SE0189' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_o_v_booking ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            END IF;
        END IF;
        /*
            *14: end
        */

        -- Update load list status in the database table.
        UPDATE TOS_LL_LOAD_LIST
        SET    LOAD_LIST_STATUS      = p_i_v_load_list_status
             , RECORD_CHANGE_USER    = p_i_v_user_id
             , RECORD_CHANGE_DATE    = TO_DATE(p_i_v_date, 'YYYYMMDDHH24MISS')
        WHERE  PK_LOAD_LIST_ID       = p_i_v_load_list_id;

        /* *17 start * */
        /* If Load List Status value is changed from a lower value to a higher value*/
        IF l_v_ll_status = C_OPEN
            AND (p_i_v_load_list_status = LOADING_COMPLETE OR
                    p_i_v_load_list_status = READY_FOR_INVOICE OR
                    p_i_v_load_list_status = WORK_COMPLETE
                ) THEN

            PRE_UPD_MLO_DETAIL (
                P_I_V_LOAD_LIST_ID,
                P_I_V_USER_ID,
                P_I_V_DATE    --  YYYYMMDDHH24MISS
            );

        END IF;
        /* *17 end * */

    EXCEPTION
        WHEN exp_error_on_save THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);


            RETURN;
        WHEN OTHERS THEN


            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RETURN;
    END PRE_ELL_SAVE_LL_STATUS ;

    PROCEDURE PRE_ELL_LL_STATUS_VALIDATION(
        p_i_v_load_list_id           VARCHAR2
      , p_i_v_load_list_status       VARCHAR2
      , p_o_v_err_cd             OUT VARCHAR2
    )  AS
        l_v_rec_count NUMBER := 0;
        l_v_errors    VARCHAR2(2000);
        l_v_service   TOS_LL_LOAD_LIST.FK_SERVICE%TYPE; -- *5

    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;


        IF((p_i_v_load_list_status = LOADING_COMPLETE) OR
           (p_i_v_load_list_status = READY_FOR_INVOICE) OR
           (p_i_v_load_list_status = WORK_COMPLETE)) THEN

            SELECT COUNT(1)
            INTO   l_v_rec_count
            FROM   TOS_LL_BOOKED_LOADING
            WHERE  LOADING_STATUS = 'BK'
            AND    FK_LOAD_LIST_ID = p_i_v_load_list_id
            AND    RECORD_STATUS = 'A'; -- added 20.12.2011
        END IF;


        IF(l_v_rec_count > 0) THEN
            --Then throw error message Container with discharge status Booked exists.
            p_o_v_err_cd := 'ELL.SE0124';
            RETURN;
        END IF;

        IF (p_i_v_load_list_status = WORK_COMPLETE) THEN
            SELECT COUNT(1)
            INTO   l_v_rec_count
            FROM   TOS_LL_BOOKED_LOADING
            WHERE  LOADING_STATUS IN ( 'SS')
            AND    FK_LOAD_LIST_ID = p_i_v_load_list_id
            AND    RECORD_STATUS = 'A'; -- added 20.12.2011

            IF(l_v_rec_count > 0) THEN
                /*Then throw error message Container with discharge status Short shipped  exists*/
                p_o_v_err_cd := 'ELL.SE0120';
                RETURN;
            END IF;

            SELECT COUNT(1)
            INTO   l_v_rec_count
            FROM   TOS_LL_OVERSHIPPED_CONTAINER
            WHERE  FK_LOAD_LIST_ID = p_i_v_load_list_id
            AND    RECORD_STATUS = 'A'; -- added 20.12.2011

            IF(l_v_rec_count > 0) THEN
                /*Then throw error message container with discharge status Overlanded exists*/
                p_o_v_err_cd := 'ELL.SE0119';
                RETURN;
            END IF;
        END IF;

        /*
            *5: Changes start
        */
        SELECT
            NVL(LOWER(FK_SERVICE), '*')
        INTO
            l_v_service
        FROM
            TOS_LL_LOAD_LIST
        WHERE
            PK_LOAD_LIST_ID = p_i_v_load_list_id;
        /*
            *5: Changes End
        */

        /*
            *3: changes start
        */
        IF l_v_service <> 'afs' AND l_v_service <> 'dfs' THEN -- *5
            IF(( p_i_v_load_list_status = LOADING_COMPLETE) OR
                (p_i_v_load_list_status = READY_FOR_INVOICE) OR
                (p_i_v_load_list_status = WORK_COMPLETE)) THEN

                SELECT
                    COUNT(1)
                INTO
                    l_v_rec_count
                FROM
                    TOS_LL_BOOKED_LOADING
                WHERE
                    FK_LOAD_LIST_ID = p_i_v_load_list_id
                    AND    RECORD_STATUS = 'A'
                    AND    STOWAGE_POSITION  IS NULL
                    AND    LOADING_STATUS <> 'SS'; -- *7

                IF(l_v_rec_count > 0) THEN
                    -- Then throw error message Blank stowage position exists.
                    p_o_v_err_cd := 'EDL.SE0186';
                    RETURN;
                END IF;
            END IF;
        END IF;  -- *5
        /*
            *3: Changes end
        */

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);

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
        PROCEDURE PRE_ELL_PREV_LOADED_EQUIP_ID (
              p_i_v_equip_no                   VARCHAR2
            , p_i_v_eta_date                   VARCHAR2
            , p_i_v_eta_tm                     VARCHAR2
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
                                AND       LLB.DN_EQUIPMENT_NO     = p_i_v_equip_no
                                AND     LLB.LOADING_STATUS      = 'LO'
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
                                                                          , LL.DN_PORT )
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
                                AND       TS.DN_EQUIPMENT_NO      = p_i_v_equip_no
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
                                                                         , LL.DN_PORT )
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

    PROCEDURE PRE_TOS_REMOVE_ERROR(
          p_i_v_da_error                       VARCHAR2
        , p_i_v_ll_dl_flag                     VARCHAR2
        , p_i_v_size                           VARCHAR2
        , p_i_v_clr1                           VARCHAR2
        , p_i_v_clr2                           VARCHAR2
        , p_i_v_equipment_no                   VARCHAR2
        , p_i_v_fk_overshipped_id              VARCHAR2
        , p_i_v_fk_load_list_id                VARCHAR2
        , p_o_v_err_cd              OUT        VARCHAR2
    )AS
        l_v_rec_count                          NUMBER := 0;
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /* Check the error status of record. */
        IF ((p_i_v_da_error = NULL) OR (p_i_v_da_error = 'N')) THEN
            RETURN;
        END IF;

        /* Check for Size mismatch error */
        SELECT COUNT(1)
        INTO l_v_rec_count
        FROM TOS_ERROR_LOG
        WHERE LL_DL_FLAG       = p_i_v_ll_dl_flag
        AND FK_OVERSHIPPED_ID  = p_i_v_fk_overshipped_id
        AND FK_LOAD_LIST_ID    = p_i_v_fk_load_list_id
        AND ERROR_CODE       = 'EC001';

        /* Check new Size should not be null */
        IF ((l_v_rec_count > 0) AND (p_i_v_size IS NULL)) THEN
            p_o_v_err_cd := 'EDL.SE0133' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
        END IF;

        /* Check for Container Loading Remark1 error */
        SELECT COUNT(1)
        INTO l_v_rec_count
        FROM TOS_ERROR_LOG
        WHERE LL_DL_FLAG       = p_i_v_ll_dl_flag
        AND FK_OVERSHIPPED_ID  = p_i_v_fk_overshipped_id
        AND FK_LOAD_LIST_ID    = p_i_v_fk_load_list_id
        AND ERROR_CODE     = 'EC013';

        /* Check new Container Loading Remark1 should not be null */
        IF ((l_v_rec_count > 0) AND (p_i_v_clr1 IS NULL)) THEN
            p_o_v_err_cd := 'EDL.SE0134' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
        END IF;

        /* Check for Container Loading Remark2 error */
        SELECT COUNT(1)
        INTO l_v_rec_count
        FROM TOS_ERROR_LOG
        WHERE LL_DL_FLAG       = p_i_v_ll_dl_flag
        AND FK_OVERSHIPPED_ID  = p_i_v_fk_overshipped_id
        AND FK_LOAD_LIST_ID    = p_i_v_fk_load_list_id
        AND ERROR_CODE     = 'EC014';

        /* Check new Container Loading Remark1 should not be null */
        IF ((l_v_rec_count > 0) AND (p_i_v_clr2 IS NULL)) THEN
            p_o_v_err_cd := 'EDL.SE0135' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RETURN;
        END IF;

        /* Delete the the logged data from table. */
        DELETE FROM TOS_ERROR_LOG
        WHERE LL_DL_FLAG       = p_i_v_ll_dl_flag
        AND FK_OVERSHIPPED_ID  = p_i_v_fk_overshipped_id
        AND FK_LOAD_LIST_ID    = p_i_v_fk_load_list_id;

    EXCEPTION
        WHEN OTHERS THEN
        p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_TOS_REMOVE_ERROR;

    PROCEDURE PRE_EDL_POD_UPDATE(
          p_i_v_pk_booked_id                  TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE
        , p_i_v_fk_booking_no                 TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE
        , p_i_v_lldl_flag                     VARCHAR2
        , p_i_v_fk_bkg_voyage_rout_dtl        TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
        , p_i_v_load_condition                TOS_LL_BOOKED_LOADING.LOAD_CONDITION%TYPE
        , p_i_v_container_gross_weight        TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE
        , p_i_v_damaged                       TOS_LL_BOOKED_LOADING.DAMAGED%TYPE
        , p_i_v_fk_container_operator         TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE
        , p_i_v_out_slot_operator             TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE
        , p_i_v_seal_no                       TOS_LL_BOOKED_LOADING.SEAL_NO%TYPE
        , p_i_v_mlo_vessel                    TOS_LL_BOOKED_LOADING.MLO_VESSEL%TYPE
        , p_i_v_mlo_voyage                    TOS_LL_BOOKED_LOADING.MLO_VOYAGE%TYPE
        , p_i_v_mlo_vessel_eta                date
        , p_i_v_mlo_pod1                      TOS_LL_BOOKED_LOADING.MLO_POD1%TYPE
        , p_i_v_mlo_pod2                      TOS_LL_BOOKED_LOADING.MLO_POD2%TYPE
        , p_i_v_mlo_pod3                      TOS_LL_BOOKED_LOADING.MLO_POD3%TYPE
        , p_i_v_mlo_del                       TOS_LL_BOOKED_LOADING.MLO_DEL%TYPE
        , p_i_v_fk_handl_instruction_1        TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1%TYPE
        , p_i_v_fk_handl_instruction_2        TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2%TYPE
        , p_i_v_fk_handl_instruction_3        TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3%TYPE
        , p_i_v_container_loading_rem_1       TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1%TYPE
        , p_i_v_container_loading_rem_2       TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2%TYPE
        , p_i_v_tight_connection_flag1        TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG1%TYPE
        , p_i_v_tight_connection_flag2        TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG2%TYPE
        , p_i_v_tight_connection_flag3        TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG3%TYPE
        , p_i_v_fumigation_only               TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY%TYPE
        , p_i_v_residue_only_flag             TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG%TYPE
        , p_i_v_fk_bkg_size_type_dtl          TOS_LL_BOOKED_LOADING.FK_BKG_SIZE_TYPE_DTL%TYPE
        , p_i_v_fk_bkg_supplier               TOS_LL_BOOKED_LOADING.FK_BKG_SUPPLIER%TYPE
        , p_i_v_fk_bkg_equipm_dtl             TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE
        , p_o_v_err_cd                        OUT VARCHAR2
    )AS
        l_v_load_condition                      TOS_LL_BOOKED_LOADING.LOAD_CONDITION%TYPE;
        l_v_container_gross_weight              TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE;
        l_v_damaged                             TOS_LL_BOOKED_LOADING.DAMAGED%TYPE;
        l_v_fk_container_operator               TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE;
        l_v_out_slot_operator                   TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE;
        l_v_seal_no                             TOS_LL_BOOKED_LOADING.SEAL_NO%TYPE;
        l_v_mlo_vessel                          TOS_LL_BOOKED_LOADING.MLO_VESSEL%TYPE;
        l_v_mlo_voyage                          TOS_LL_BOOKED_LOADING.MLO_VOYAGE%TYPE;
        l_v_mlo_vessel_eta                      TOS_LL_BOOKED_LOADING.MLO_VESSEL_ETA%TYPE;
        l_v_mlo_pod1                            TOS_LL_BOOKED_LOADING.MLO_POD1%TYPE;
        l_v_mlo_pod2                            TOS_LL_BOOKED_LOADING.MLO_POD2%TYPE;
        l_v_mlo_pod3                            TOS_LL_BOOKED_LOADING.MLO_POD3%TYPE;
        l_v_mlo_del                             TOS_LL_BOOKED_LOADING.MLO_DEL%TYPE;
        l_v_fk_handl_instruction_1              TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1%TYPE;
        l_v_fk_handl_instruction_2              TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2%TYPE;
        l_v_fk_handl_instruction_3              TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3%TYPE;
        l_v_container_loading_rem_1             TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1%TYPE;
        l_v_container_loading_rem_2             TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2%TYPE;
        l_v_tight_connection_flag1              TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG1%TYPE;
        l_v_tight_connection_flag2              TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG2%TYPE;
        l_v_tight_connection_flag3              TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG3%TYPE;
        l_v_fumigation_only                     TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY%TYPE;
        l_v_residue_only_flag                   TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG%TYPE;


    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        SELECT
            LOAD_CONDITION
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
        INTO
            l_v_load_condition
            ,l_v_container_gross_weight
            ,l_v_damaged
            ,l_v_fk_container_operator
            ,l_v_out_slot_operator
            ,l_v_seal_no
            ,l_v_mlo_vessel
            ,l_v_mlo_voyage
            ,l_v_mlo_vessel_eta
            ,l_v_mlo_pod1
            ,l_v_mlo_pod2
            ,l_v_mlo_pod3
            ,l_v_mlo_del
            ,l_v_fk_handl_instruction_1
            ,l_v_fk_handl_instruction_2
            ,l_v_fk_handl_instruction_3
            ,l_v_container_loading_rem_1
            ,l_v_container_loading_rem_2
            ,l_v_tight_connection_flag1
            ,l_v_tight_connection_flag2
            ,l_v_tight_connection_flag3
            ,l_v_fumigation_only
            ,l_v_residue_only_flag
        FROM  TOS_LL_BOOKED_LOADING
        WHERE PK_BOOKED_LOADING_ID = p_i_v_pk_booked_id;

        -- check the value of passed data from db value
        IF(NVL(p_i_v_load_condition,'~') <> NVL(l_v_load_condition,'~')) THEN
            l_v_load_condition:= NVL(p_i_v_load_condition,'~');
        ELSE
            l_v_load_condition := NULL;
        END IF;
        IF(NVL(TO_NUMBER(p_i_v_container_gross_weight),0) <> NVL(l_v_container_gross_weight,0)) THEN
          l_v_container_gross_weight := NVL(p_i_v_container_gross_weight,0);
        ELSE

          IF (p_i_v_container_gross_weight IS NOT NULL AND l_v_container_gross_weight IS NULL) OR
             (p_i_v_container_gross_weight IS NULL AND l_v_container_gross_weight IS NOT NULL)
          THEN
            l_v_container_gross_weight := 0;
          ELSE
            l_v_container_gross_weight := NULL;
          END IF;

        END IF;
        IF(NVL(p_i_v_damaged,'~') <> NVL(l_v_damaged,'~')) THEN
            l_v_damaged:= NVL(p_i_v_damaged,'~');
        ELSE
            l_v_damaged := NULL;
        END IF;

        IF(NVL(p_i_v_fk_container_operator,'~') <> NVL(l_v_fk_container_operator,'~')) THEN
            l_v_fk_container_operator:= NVL(p_i_v_fk_container_operator,'~');
        ELSE
            l_v_fk_container_operator := NULL;
        END IF;

        IF(NVL(p_i_v_out_slot_operator,'~') <> NVL(l_v_out_slot_operator,'~')) THEN
            l_v_out_slot_operator:= NVL(p_i_v_out_slot_operator,'~');
        ELSE
            l_v_out_slot_operator := NULL;
        END IF;

        IF(NVL(p_i_v_seal_no,'~') <> NVL(l_v_seal_no,'~')) THEN
            l_v_seal_no:= NVL(p_i_v_seal_no,'~');
        ELSE
            l_v_seal_no := NULL;
        END IF;

        IF(NVL(p_i_v_mlo_vessel,'~') <> NVL(l_v_mlo_vessel,'~')) THEN
            l_v_mlo_vessel:= NVL(p_i_v_mlo_vessel,'~');
        ELSE
            l_v_mlo_vessel := NULL;
        END IF;

        IF(NVL(p_i_v_mlo_voyage,'~') <> NVL(l_v_mlo_voyage,'~')) THEN
            l_v_mlo_voyage:= NVL(p_i_v_mlo_voyage,'~');
        ELSE
            l_v_mlo_voyage := NULL;
        END IF;

       IF(NVL(p_i_v_mlo_vessel_eta,to_date('01/01/1900', 'dd/mm/yyyy')) <> NVL(l_v_mlo_vessel_eta,to_date('01/01/1900', 'dd/mm/yyyy'))) THEN
              l_v_mlo_vessel_eta:= NVL(p_i_v_mlo_vessel_eta, to_date('01/01/1900', 'dd/mm/yyyy'));
        ELSE
            l_v_mlo_vessel_eta := NULL;
        END IF;

        IF(NVL(p_i_v_mlo_pod1,'~') <> NVL(l_v_mlo_pod1,'~')) THEN
            l_v_mlo_pod1:= NVL(p_i_v_mlo_pod1,'~');
        ELSE
            l_v_mlo_pod1 := NULL;
        END IF;

        IF(NVL(p_i_v_mlo_pod2,'~') <> NVL(l_v_mlo_pod2,'~')) THEN
            l_v_mlo_pod2:= NVL(p_i_v_mlo_pod2,'~');
        ELSE
            l_v_mlo_pod2 := NULL;
        END IF;

        IF(NVL(p_i_v_mlo_pod3,'~') <> NVL(l_v_mlo_pod3,'~')) THEN
            l_v_mlo_pod3:= NVL(p_i_v_mlo_pod3,'~');
        ELSE
            l_v_mlo_pod3 := NULL;
        END IF;

        IF(NVL(p_i_v_mlo_del,'~') <> NVL(l_v_mlo_del,'~')) THEN
            l_v_mlo_del:= NVL(p_i_v_mlo_del,'~');
        ELSE
            l_v_mlo_del := NULL;
        END IF;

        IF(NVL(p_i_v_fk_handl_instruction_1,'~') <> NVL(l_v_fk_handl_instruction_1,'~')) THEN
            l_v_fk_handl_instruction_1:= NVL(p_i_v_fk_handl_instruction_1,'~');
        ELSE
            l_v_fk_handl_instruction_1 := NULL;
        END IF;

        IF(NVL(p_i_v_fk_handl_instruction_2,'~') <> NVL(l_v_fk_handl_instruction_2,'~')) THEN
            l_v_fk_handl_instruction_2:= NVL(p_i_v_fk_handl_instruction_2,'~');
        ELSE
            l_v_fk_handl_instruction_2 := NULL;
        END IF;

        IF(NVL(p_i_v_fk_handl_instruction_3,'~') <> NVL(l_v_fk_handl_instruction_3,'~')) THEN
            l_v_fk_handl_instruction_3:= NVL(p_i_v_fk_handl_instruction_3,'~');
        ELSE
            l_v_fk_handl_instruction_3 := NULL;
        END IF;

        IF(NVL(p_i_v_container_loading_rem_1,'~') <> NVL(l_v_container_loading_rem_1,'~')) THEN
            l_v_container_loading_rem_1:= NVL(p_i_v_container_loading_rem_1,'~');
        ELSE
            l_v_container_loading_rem_1 := NULL;
        END IF;

        IF(NVL(p_i_v_container_loading_rem_2,'~') <> NVL(l_v_container_loading_rem_2,'~')) THEN
            l_v_container_loading_rem_2:= NVL(p_i_v_container_loading_rem_2,'~');
        ELSE
            l_v_container_loading_rem_2 := NULL;
        END IF;

        IF(NVL(p_i_v_tight_connection_flag1,'~') <> NVL(l_v_tight_connection_flag1,'~')) THEN
            l_v_tight_connection_flag1:= NVL(p_i_v_tight_connection_flag1,'~');
        ELSE
            l_v_tight_connection_flag1 := NULL;
        END IF;

        IF(NVL(p_i_v_tight_connection_flag2,'~') <> NVL(l_v_tight_connection_flag2,'~')) THEN
            l_v_tight_connection_flag2:= NVL(p_i_v_tight_connection_flag2,'~');
        ELSE
            l_v_tight_connection_flag2 := NULL;
        END IF;

        IF(NVL(p_i_v_tight_connection_flag3,'~') <> NVL(l_v_tight_connection_flag3,'~')) THEN
            l_v_tight_connection_flag3:= NVL(p_i_v_tight_connection_flag3,'~');
        ELSE
            l_v_tight_connection_flag3 := NULL;
        END IF;

        IF(NVL(p_i_v_fumigation_only,'~') <> NVL(l_v_fumigation_only,'~')) THEN
            l_v_fumigation_only:= NVL(p_i_v_fumigation_only,'~');
        ELSE
            l_v_fumigation_only := NULL;
        END IF;

        IF(NVL(p_i_v_residue_only_flag,'~') <> NVL(l_v_residue_only_flag,'~')) THEN
            l_v_residue_only_flag:= NVL(p_i_v_residue_only_flag,'~');
        ELSE
            l_v_residue_only_flag := NULL;
        END IF;

        PCE_EUT_COMMON.PRE_UPD_NEXT_POD
        (
              p_i_v_fk_booking_no
            , p_i_v_lldl_flag
            , p_i_v_fk_bkg_voyage_rout_dtl
            , l_v_load_condition
            , l_v_container_gross_weight
            , l_v_damaged
            , l_v_fk_container_operator
            , l_v_out_slot_operator
            , l_v_seal_no
            , l_v_mlo_vessel
            , l_v_mlo_voyage
            , l_v_mlo_vessel_eta
            , l_v_mlo_pod1
            , l_v_mlo_pod2
            , l_v_mlo_pod3
            , l_v_mlo_del
            , l_v_fk_handl_instruction_1
            , l_v_fk_handl_instruction_2
            , l_v_fk_handl_instruction_3
            , l_v_container_loading_rem_1
            , l_v_container_loading_rem_2
            , l_v_tight_connection_flag1
            , l_v_tight_connection_flag2
            , l_v_tight_connection_flag3
            , l_v_fumigation_only
            , l_v_residue_only_flag
            , p_i_v_fk_bkg_size_type_dtl
            , p_i_v_fk_bkg_supplier
            , p_i_v_fk_bkg_equipm_dtl
            , p_o_v_err_cd
        );

        IF (p_o_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
            RETURN;
        END IF ;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
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
    PROCEDURE PRE_UPD_MLO_DETAIL (
        P_I_V_LIST_ID VARCHAR2,
        P_I_V_USER_ID VARCHAR2,
        P_I_V_DATE    VARCHAR2 /* format YYYYMMDDHH24MISS */
    )
    AS
    C_LOAD_COMPLETE CONSTANT NUMBER DEFAULT 10;
    C_ACTIVE CONSTANT VARCHAR2(1) DEFAULT 'A';
    C_DISCHARGE CONSTANT VARCHAR2(2) DEFAULT 'DI';
    C_LOADED CONSTANT VARCHAR2(2) DEFAULT 'LO';
    C_DATE_FORMAT CONSTANT VARCHAR2(16) DEFAULT 'YYYYMMDDHH24MISS';
    SEP CONSTANT VARCHAR2(1) DEFAULT '~';

    CURSOR CURSOR_FOR_DISCHARGE IS
        WITH QR1 AS (
            SELECT
                BL.REEFER_TMP,
                BL.REEFER_TMP_UNIT,
                BL.FK_IMDG,
                BL.FK_UNNO,
                BL.FK_UN_VAR,
                BL.FLASH_POINT,
                BL.FLASH_UNIT,
                BL.FK_PORT_CLASS,
                BL.OVERHEIGHT_CM,
                BL.OVERLENGTH_FRONT_CM,
                BL.OVERLENGTH_REAR_CM,
                BL.OVERWIDTH_RIGHT_CM,
                BL.OVERWIDTH_LEFT_CM,
                BL.VOID_SLOT,
                BL.STOWAGE_POSITION,
                BL.FK_HANDLING_INSTRUCTION_1,
                BL.FK_HANDLING_INSTRUCTION_2,
                BL.FK_HANDLING_INSTRUCTION_3,
                BL.CONTAINER_LOADING_REM_1,
                BL.CONTAINER_LOADING_REM_2,
                BL.MLO_VESSEL,
                BL.MLO_VOYAGE,
                BL.MLO_POD1,
                BL.MLO_POD2,
                BL.MLO_POD3,
                BL.TIGHT_CONNECTION_FLAG1,
                BL.TIGHT_CONNECTION_FLAG2,
                BL.TIGHT_CONNECTION_FLAG3,
                BL.DN_EQUIPMENT_NO,
                BL.FK_BOOKING_NO,
                BL.LOADING_STATUS,
                BL.CONTAINER_GROSS_WEIGHT,
                BL.MLO_VESSEL_ETA,
                BL.MLO_DEL,
                LL.DN_PORT,
                LL.DN_TERMINAL
            FROM
                VASAPPS.TOS_LL_LOAD_LIST LL,
                VASAPPS.TOS_LL_BOOKED_LOADING BL
            WHERE
                LL.PK_LOAD_LIST_ID = P_I_V_LIST_ID
                AND  LL.LOAD_LIST_STATUS >= C_LOAD_COMPLETE
                AND LL.PK_LOAD_LIST_ID = BL.FK_LOAD_LIST_ID
                AND BL.RECORD_STATUS = C_ACTIVE
                AND LL.RECORD_STATUS = C_ACTIVE
        )
        SELECT
            BD.PK_BOOKED_DISCHARGE_ID,
            QR1.REEFER_TMP,
            QR1.REEFER_TMP_UNIT,
            QR1.FK_IMDG,
            QR1.FK_UNNO,
            QR1.FK_UN_VAR,
            QR1.FLASH_POINT,
            QR1.FLASH_UNIT,
            QR1.FK_PORT_CLASS,
            QR1.OVERHEIGHT_CM,
            QR1.OVERLENGTH_FRONT_CM,
            QR1.OVERLENGTH_REAR_CM,
            QR1.OVERWIDTH_RIGHT_CM,
            QR1.OVERWIDTH_LEFT_CM,
            QR1.VOID_SLOT,
            QR1.STOWAGE_POSITION,
            QR1.FK_HANDLING_INSTRUCTION_1,
            QR1.FK_HANDLING_INSTRUCTION_2,
            QR1.FK_HANDLING_INSTRUCTION_3,
            QR1.CONTAINER_LOADING_REM_1,
            QR1.CONTAINER_LOADING_REM_2,
            QR1.MLO_VESSEL,
            QR1.MLO_VOYAGE,
            QR1.MLO_POD1,
            QR1.MLO_POD2,
            QR1.MLO_POD3,
            QR1.TIGHT_CONNECTION_FLAG1,
            QR1.TIGHT_CONNECTION_FLAG2,
            QR1.TIGHT_CONNECTION_FLAG3,
            QR1.DN_EQUIPMENT_NO,
            QR1.FK_BOOKING_NO,
            QR1.LOADING_STATUS,
            QR1.DN_PORT,
            QR1.DN_TERMINAL,
            QR1.CONTAINER_GROSS_WEIGHT,
            QR1.MLO_VESSEL_ETA,
            QR1.MLO_DEL
        FROM
            VASAPPS.TOS_DL_BOOKED_DISCHARGE BD, QR1
        WHERE
            BD.FK_BOOKING_NO = QR1.FK_BOOKING_NO
            AND BD.DN_EQUIPMENT_NO = QR1.DN_EQUIPMENT_NO
            AND BD.DN_POL =  QR1.DN_PORT
            AND BD.DN_POL_TERMINAL = QR1.DN_TERMINAL
            AND BD.RECORD_STATUS = C_ACTIVE
            AND BD.DISCHARGE_STATUS <> C_DISCHARGE;
BEGIN

    /* * loop through each bookings in load list * */
    FOR L_V_CURSOR_LOAD_LIST_DATA IN CURSOR_FOR_DISCHARGE LOOP /* loop1 */

        DBMS_OUTPUT.PUT_LINE(
            L_V_CURSOR_LOAD_LIST_DATA.PK_BOOKED_DISCHARGE_ID
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.REEFER_TMP
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.REEFER_TMP_UNIT
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FK_IMDG
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FK_UNNO
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FK_UN_VAR
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FLASH_POINT
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FLASH_UNIT
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FK_PORT_CLASS
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.OVERHEIGHT_CM
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.OVERLENGTH_FRONT_CM
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.OVERLENGTH_REAR_CM
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.OVERWIDTH_RIGHT_CM
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.OVERWIDTH_LEFT_CM
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.VOID_SLOT
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.STOWAGE_POSITION
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_1
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_2
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_3
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_LOADING_REM_1
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_LOADING_REM_2
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.MLO_VESSEL
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.MLO_VOYAGE
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.MLO_POD1
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.MLO_POD2
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.MLO_POD3
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG1
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG2
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG3
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.DN_EQUIPMENT_NO
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.FK_BOOKING_NO
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.LOADING_STATUS
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.DN_PORT
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.DN_TERMINAL
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_GROSS_WEIGHT
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.MLO_VESSEL_ETA
                ||SEP|| L_V_CURSOR_LOAD_LIST_DATA.MLO_DEL
        );

        /* * update discharge list * */
        UPDATE
            VASAPPS.TOS_DL_BOOKED_DISCHARGE
        SET
            DN_LOADING_STATUS = L_V_CURSOR_LOAD_LIST_DATA.LOADING_STATUS,
            STOWAGE_POSITION = L_V_CURSOR_LOAD_LIST_DATA.STOWAGE_POSITION,
            CONTAINER_GROSS_WEIGHT = L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_GROSS_WEIGHT,
            MLO_VESSEL = L_V_CURSOR_LOAD_LIST_DATA.MLO_VESSEL,
            MLO_VOYAGE = L_V_CURSOR_LOAD_LIST_DATA.MLO_VOYAGE,
            MLO_VESSEL_ETA = TO_DATE(L_V_CURSOR_LOAD_LIST_DATA.MLO_VESSEL_ETA, 'DD/MM/YYYY HH24:MI'),
            MLO_POD1 = L_V_CURSOR_LOAD_LIST_DATA.MLO_POD1,
            MLO_POD2 = L_V_CURSOR_LOAD_LIST_DATA.MLO_POD2,
            MLO_POD3 = L_V_CURSOR_LOAD_LIST_DATA.MLO_POD3,
            MLO_DEL = L_V_CURSOR_LOAD_LIST_DATA.MLO_DEL,
            REEFER_TEMPERATURE = L_V_CURSOR_LOAD_LIST_DATA.REEFER_TMP,
            REEFER_TMP_UNIT = L_V_CURSOR_LOAD_LIST_DATA.REEFER_TMP_UNIT,
            FK_IMDG = L_V_CURSOR_LOAD_LIST_DATA.FK_IMDG,
            FK_UNNO = L_V_CURSOR_LOAD_LIST_DATA.FK_UNNO,
            FK_UN_VAR = L_V_CURSOR_LOAD_LIST_DATA.FK_UN_VAR,
            FLASH_POINT = L_V_CURSOR_LOAD_LIST_DATA.FLASH_POINT,
            FLASH_UNIT = L_V_CURSOR_LOAD_LIST_DATA.FLASH_UNIT,
            FK_PORT_CLASS = L_V_CURSOR_LOAD_LIST_DATA.FK_PORT_CLASS,
            OVERHEIGHT_CM = L_V_CURSOR_LOAD_LIST_DATA.OVERHEIGHT_CM,
            OVERLENGTH_FRONT_CM = L_V_CURSOR_LOAD_LIST_DATA.OVERLENGTH_FRONT_CM,
            OVERLENGTH_REAR_CM = L_V_CURSOR_LOAD_LIST_DATA.OVERLENGTH_REAR_CM,
            OVERWIDTH_RIGHT_CM = L_V_CURSOR_LOAD_LIST_DATA.OVERWIDTH_RIGHT_CM,
            OVERWIDTH_LEFT_CM = L_V_CURSOR_LOAD_LIST_DATA.OVERWIDTH_LEFT_CM,
            VOID_SLOT = L_V_CURSOR_LOAD_LIST_DATA.VOID_SLOT,
            FK_HANDLING_INSTRUCTION_1 = L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_1,
            FK_HANDLING_INSTRUCTION_2 = L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_2,
            FK_HANDLING_INSTRUCTION_3 = L_V_CURSOR_LOAD_LIST_DATA.FK_HANDLING_INSTRUCTION_3,
            CONTAINER_LOADING_REM_1 = L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_LOADING_REM_1,
            CONTAINER_LOADING_REM_2 = L_V_CURSOR_LOAD_LIST_DATA.CONTAINER_LOADING_REM_2,
            TIGHT_CONNECTION_FLAG1 = L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG1,
            TIGHT_CONNECTION_FLAG2 = L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG2,
            TIGHT_CONNECTION_FLAG3 = L_V_CURSOR_LOAD_LIST_DATA.TIGHT_CONNECTION_FLAG3,
            RECORD_CHANGE_USER = P_I_V_USER_ID,
            RECORD_CHANGE_DATE = TO_DATE(P_I_V_DATE, C_DATE_FORMAT)
        WHERE
            PK_BOOKED_DISCHARGE_ID = L_V_CURSOR_LOAD_LIST_DATA.PK_BOOKED_DISCHARGE_ID;
    END LOOP; /* loop1 */

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END PRE_UPD_MLO_DETAIL;
    /* *17 end * */

    /* *23 start * */
    PROCEDURE PRE_FIND_DISCHARGE_LIST (
        P_I_V_BOOKING       VARCHAR2,
        P_I_V_VESSEL        VARCHAR2,
        P_I_V_EQUIPMENT     VARCHAR2,
        P_O_V_FLAG          OUT NOCOPY VARCHAR2,
        P_O_V_BOOKED_DIS_ID OUT NOCOPY VARCHAR2,
        P_O_V_ERR_CD        OUT NOCOPY VARCHAR2)
    AS
        l_v_vessel            VARCHAR2(100);
        l_v_terminal          VARCHAR2(100);
        l_v_voyage            VARCHAR2(100);
        L_V_ITP_ETA           ITP063.VVARDT%TYPE;
        L_V_ITP_ETD           ITP063.VVDPDT%TYPE;
        L_V_ITP_ETA_TIME      ITP063.VVARTM%TYPE;
        l_dt_bayplan          DATE;
        l_v_port              VARCHAR2(100);
        L_V_PORT_SEQ          ITP063.VVPCSQ%TYPE;
        L_V_ITP_ETD_TIME      ITP063.VVDPTM%TYPE;
        L_V_ACT_VOYAGE_NUMBER BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER%TYPE;
        L_V_LAST_PORT         ITP063.VVPCAL%TYPE;
        L_V_LOAD_PORT         BOOKING_VOYAGE_ROUTING_DTL.LOAD_PORT%TYPE;
        L_V_MAX_PORT_SEQ      ITP063.VVPCSQ%TYPE;
        L_V_POL_PCSQ          BOOKING_VOYAGE_ROUTING_DTL.POL_PCSQ%TYPE;
        L_V_ERROR             VARCHAR2(4000);
        NEXT_VOYAGE_NOT_FOUND EXCEPTION;
        ORACLE_EXCEPTION      EXCEPTION;

        TRUE CONSTANT         VARCHAR2(5) DEFAULT 'true';
        FALSE CONSTANT        VARCHAR2(5) DEFAULT 'false';

        C PLS_INTEGER := 0;

        TYPE TableRecord IS RECORD (
            BOOKING_NO VASAPPS.TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE,
            DISCHARGE_LIST_ID VASAPPS.TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID%TYPE
        );

        TYPE CHECKED_BOOKING_TABLE
        IS
            TABLE OF TableRecord INDEX BY BINARY_INTEGER;

        I INTEGER := 0;
        L_V_CHECKED_BOOKING_TABLE CHECKED_BOOKING_TABLE;
        IS_NEED_NEXT_VOYAGE_CHECK VARCHAR2(5) := FALSE;
        IS_ACTVOY_NXT_VOY_SAME    VARCHAR2(5) := FALSE;
        IS_PORT_FOUND_IN_NXT_VOY  VARCHAR2(5) := FALSE;
        IS_BOOKING_ROB            VARCHAR2(5) := FALSE;
        L_V_DISCHARGE_LIST        VARCHAR2(15);


    BEGIN

        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        P_O_V_FLAG := 'D';

        IF (L_V_CHECKED_BOOKING_TABLE.COUNT <> 0) THEN

            ---------------- check booking already checked or not
            FOR I IN 1 .. L_V_CHECKED_BOOKING_TABLE.COUNT LOOP
                IF (P_I_V_BOOKING = L_V_CHECKED_BOOKING_TABLE(i).BOOKING_NO) THEN
                    DBMS_OUTPUT.PUT_LINE(L_V_CHECKED_BOOKING_TABLE(i).BOOKING_NO);
                    L_V_DISCHARGE_LIST := L_V_CHECKED_BOOKING_TABLE(i).BOOKING_NO;
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
            SELECT
                TRUE,
                VOYNO,
                ACT_VOYAGE_NUMBER,
                VESSEL,
                LOAD_PORT,
                POL_PCSQ
            INTO
                IS_NEED_NEXT_VOYAGE_CHECK,
                L_V_VOYAGE,
                L_V_ACT_VOYAGE_NUMBER,
                L_V_VESSEL,
                L_V_LOAD_PORT,
                L_V_POL_PCSQ
            FROM
                BOOKING_VOYAGE_ROUTING_DTL
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
                DBMS_OUTPUT.PUT_LINE('ERROR 2: '||SQLERRM);
        END;

        IF IS_NEED_NEXT_VOYAGE_CHECK = TRUE THEN

            L_V_LAST_PORT := L_V_LOAD_PORT;
            L_V_MAX_PORT_SEQ := L_V_POL_PCSQ;

            LOOP
                /* find the max port sequence */
                BEGIN
                    SELECT
                        MAX(VVPCSQ)
                    INTO
                        L_V_MAX_PORT_SEQ
                    FROM
                        ITP063
                    WHERE
                        VVVERS  = 99
                        AND VVVESS    = L_V_VESSEl
                        AND VOYAGE_ID = L_V_VOYAGE
                        /* AND VVPCAL    = L_V_LOAD_PORT */
                        AND VVPCAL    = L_V_LAST_PORT /* first time load port */
                        /* AND VVPCSQ    >= L_V_POL_PCSQ */
                        AND VVPCSQ    >= L_V_MAX_PORT_SEQ /* first time load port seq */
                        AND OMMISSION_FLAG IS NULL
                        AND VVFORL IS NOT NULL;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        L_V_ERROR := 'MAX PORT SEQ NOT FOUND';
                        RAISE NEXT_VOYAGE_NOT_FOUND;
                    WHEN OTHERS THEN
                        L_V_ERROR := SQLERRM;
                        DBMS_OUTPUT.PUT_LINE('ERROR 2: '||SQLERRM);
                        RAISE ORACLE_EXCEPTION;
                END;

                DBMS_OUTPUT.PUT_LINE('L_V_MAX_PORT_SEQ: '|| L_V_MAX_PORT_SEQ);

                /* find the last port using max port sequence */
                BEGIN
                    SELECT
                        VVARDT ETA,
                        VVDPDT ETD,
                        VVARTM,
                        VVDPTM,
                        VVPCAL
                    INTO
                        L_V_ITP_ETA,
                        L_V_ITP_ETD,
                        L_V_ITP_ETA_TIME,
                        L_V_ITP_ETD_TIME,
                        L_V_LAST_PORT
                    FROM
                        ITP063
                    WHERE
                        VVVERS  = 99
                        AND VVVESS    = L_V_VESSEl
                        AND VOYAGE_ID = L_V_VOYAGE
                        /* AND VVPCAL    = L_V_LOAD_PORT */
                        /* AND VVPCAL    = L_V_LAST_PORT */ /* first time load port */
                        AND VVPCSQ    = L_V_MAX_PORT_SEQ
                        AND OMMISSION_FLAG IS NULL
                        AND VVFORL IS NOT NULL;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        L_V_ERROR := 'LAST PORT NOT FOUND';
                        RAISE NEXT_VOYAGE_NOT_FOUND;
                    WHEN OTHERS THEN
                        L_V_ERROR := SQLERRM;
                        DBMS_OUTPUT.PUT_LINE('ERROR 3: '||SQLERRM);
                        RAISE ORACLE_EXCEPTION;

                END;

                DBMS_OUTPUT.PUT_LINE('last port of current voyage: '||L_V_LAST_PORT);

                /* find the next voyage using the last port */
                BEGIN
                    DBMS_OUTPUT.PUT_LINE(L_V_VESSEL ||'~'||
                        L_V_LAST_PORT ||'~'||
                        l_dt_bayplan ||'~'||
                        L_V_ITP_ETA || LPAD(L_V_ITP_ETA_TIME ,4, '0') ||'~'||
                        L_V_ITP_ETD || LPAD(L_V_ITP_ETD_TIME ,4, '0')
                        );

                    /* this sql gives first port of the voyage */
                    SELECT
                        VOYAGE_ID,
                        VVARDT ETA,
                        VVDPDT ETD,
                        VVARTM,
                        VVDPTM,
                        VVPCAL,
                        VVPCSQ
                    INTO
                        L_V_VOYAGE,
                        L_V_ITP_ETA,
                        L_V_ITP_ETD,
                        L_V_ITP_ETA_TIME,
                        L_V_ITP_ETD_TIME,
                        L_V_LAST_PORT,
                        L_V_MAX_PORT_SEQ
                        -- L_V_PORT,
                        -- L_V_PORT_SEQ
                    FROM
                    (
                        SELECT
                            ROW_NUMBER() OVER(ORDER BY TO_DATE(VVARDT||LPAD(VVARTM,4,'0'), 'YYYYMMDDHH24MI') ) R,
                            VOYAGE_ID,
                            VVARDT,
                            VVDPDT,
                            VVARTM,
                            VVDPTM,
                            VVPCAL,
                            VVPCSQ
                        FROM
                            ITP063
                        WHERE
                            VVVERS  = 99
                            AND VVVESS    = L_V_VESSEl
                            AND (TO_DATE(VVDPDT||LPAD(VVDPTM, 4,'0'), 'YYYYMMDDHH24MI')
                                >
                                TO_DATE(L_V_ITP_ETD||LPAD(L_V_ITP_ETD_TIME, 4,'0'), 'YYYYMMDDHH24MI'))
                                  -- 20130217
                            AND OMMISSION_FLAG IS NULL
                            AND VVFORL IS NOT NULL
                            )
                        WHERE R =1 ;

                        -- DBMS_OUTPUT.PUT_LINE('itp date');
                        -- DBMS_OUTPUT.PUT_LINE(VVDPDT||' '|| VVDPTM);

                        DBMS_OUTPUT.PUT_LINE('for voyage etd date');
                        DBMS_OUTPUT.PUT_LINE(L_V_ITP_ETD||' '|| L_V_ITP_ETD_TIME);

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        L_V_ERROR := 'NEXT VOYAGE NOT FOUND';

                        RAISE NEXT_VOYAGE_NOT_FOUND;
                    WHEN OTHERS THEN
                        L_V_ERROR := SQLERRM;
                        DBMS_OUTPUT.PUT_LINE('ERROR 5: '||SQLERRM);
                        RAISE ORACLE_EXCEPTION;

                END;

                DBMS_OUTPUT.PUT_LINE('next voyage: ' ||L_V_VOYAGE);

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
                    DBMS_OUTPUT.PUT_LINE(P_I_V_VESSEL
                        ||'~'|| L_V_LOAD_PORT
                        ||'~'|| L_V_VOYAGE
                        ||'~'|| P_I_V_BOOKING);

                    ----------- find next discharge list.
                    SELECT
                        BD.FK_DISCHARGE_LIST_ID
                    INTO
                        L_V_DISCHARGE_LIST
                    FROM
                        VASAPPS.TOS_DL_DISCHARGE_LIST DL,
                        VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
                    WHERE
                        DL.FK_VESSEL                = P_I_V_VESSEL
                        AND BD.DN_POL               = L_V_LOAD_PORT
                        AND DL.FK_VOYAGE            = L_V_VOYAGE
                        AND BD.FK_DISCHARGE_LIST_ID = DL.PK_DISCHARGE_LIST_ID
    --                    AND BD.FK_BOOKING_NO        = L_CUR_DETAIL.DL_FK_BOOKING_NO
                        AND BD.FK_BOOKING_NO        = P_I_V_BOOKING
                        AND BD.RECORD_STATUS        = 'A'
                        AND BD.RECORD_STATUS        = 'A'
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
            AND DN_EQUIPMENT_NO        = P_I_V_EQUIPMENT
            AND RECORD_STATUS          = 'A';
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
  PROCEDURE PRE_ELL_OL_VAL_PORT_CLASS_TYPE( 
        p_i_v_port_code          VARCHAR2
        , P_I_V_PORT_CLASS_TYPE  varchar2   
        , p_i_v_equipment_no     VARCHAR2
        , P_O_V_ERR_CD           OUT varchar2)
  AS
    l_rec_count             NUMBER := 0;
    l_v_port_code           PORT_CLASS_TYPE.PORT_CODE%TYPE;
    l_v_port_class_type     PORT_CLASS.PORT_CLASS_TYPE%TYPE;
    
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        l_v_port_code           := LOWER(p_i_v_port_code);
        l_v_port_class_type     := LOWER(p_i_v_port_class_type);

        IF l_v_port_class_type IS NOT NULL THEN

            SELECT COUNT(1)
            into L_REC_COUNT
            from PORT_CLASS_TYPE PCT
            where LOWER(PCT.PORT_CODE)=L_V_PORT_CODE
             AND LOWER(PCT.PORT_CLASS_TYPE) = L_V_PORT_CLASS_TYPE;
            
            if(L_REC_COUNT < 1) then
                p_o_v_err_cd := 'ELL.SE0134'  || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || p_i_v_equipment_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                RETURN;
            end if;
        END IF; 

    EXCEPTION
        WHEN OTHERS THEN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
   
  end;
  /* *24 end * */
  /* *26 start * */
  PROCEDURE PRE_LOG_PORTCLASS_CHANGE(
		P_I_V_BOOKED_LL_DL_ID 		NUMBER,
		P_I_V_PORT_CLASS		    	VARCHAR,
        P_I_V_IMDG					      VARCHAR,
        P_I_V_UNNO					      VARCHAR,
        P_I_V_UN_VAR				      VARCHAR,
		P_I_V_LOAD_DISCHARGE_FLAG VARCHAR,
		P_I_V_USER_ID 				VARCHAR)
  as
  l_imdg tos_ll_booked_loading.fk_imdg%type;
  l_unno tos_ll_booked_loading.fk_unno%type;
  l_un_var tos_ll_booked_loading.fk_un_var%type;
  l_PORT_CLASS_TYP  TOS_LL_BOOKED_LOADING.fk_port_class_typ%type;
  l_port_class varchar2(5);
  l_equipment_no varchar2(20);
  l_booking_no varchar2(20);
  
  BEGIN
	if (p_i_v_load_discharge_flag = 'L') then
		select fk_imdg, fk_unno, fk_un_var, fk_port_class, fk_port_class_typ, fk_booking_no, dn_equipment_no
		  INTO L_IMDG, L_UNNO, L_UN_VAR, L_PORT_CLASS, L_PORT_CLASS_TYP, L_BOOKING_NO, L_EQUIPMENT_NO 
		  FROM TOS_LL_BOOKED_LOADING
		 WHERE PK_BOOKED_LOADING_ID = P_I_V_BOOKED_LL_DL_ID;
	ELSE
		SELECT fk_imdg, fk_unno, fk_un_var, fk_port_class, fk_port_class_typ, fk_booking_no, dn_equipment_no
		  INTO L_IMDG, L_UNNO, L_UN_VAR, L_PORT_CLASS, L_PORT_CLASS_TYP, L_BOOKING_NO, L_EQUIPMENT_NO 
		  FROM TOS_DL_BOOKED_DISCHARGE
		 WHERE PK_BOOKED_DISCHARGE_ID = P_I_V_BOOKED_LL_DL_ID;
	END IF;
	IF((p_i_v_port_class <> L_PORT_CLASS) or (P_I_V_IMDG <> L_IMDG) or (P_I_V_UNNO <> L_UNNO) or (P_I_V_UN_VAR <> L_UN_VAR)) THEN
		PRE_LOG_INFO(
			'PCE_ELL_LLMAINTENANCE.PRE_LOG_PORTCLASS_CHANGE'
		   , 'PRE_LOG_PORTCLASS_CHANGE'
		   , NULL
		   , P_I_V_USER_ID
		   , sysdate
		   , 'Old Port Class value: ' || l_port_class || ' ' || 'New Port Class value: ' || p_i_v_port_class || ' '
		     || 'P_I_V_BOOKED_LL_DL_ID: '|| P_I_V_BOOKED_LL_DL_ID || ' '
			 || 'P_I_V_LOAD_DISCHARGE_FLAG: '|| P_I_V_LOAD_DISCHARGE_FLAG || ' '
       || 'EQUIPMENT NO: '|| L_EQUIPMENT_NO || ' '
       || 'BOOKING NO: '|| L_BOOKING_NO ||' '||'fk_imdg: '||L_IMDG||' '||'fk_unno: '||L_UNNO||' '||'fk_un_var: '||L_UN_VAR
		   , NULL
		   , NULL
		   , NULL);			
	 END IF;
  EXCEPTION
	WHEN OTHERS THEN
		NULL;
  END PRE_LOG_PORTCLASS_CHANGE;
  /* *26 end * */
end PCE_ELL_LLMAINTENANCE;