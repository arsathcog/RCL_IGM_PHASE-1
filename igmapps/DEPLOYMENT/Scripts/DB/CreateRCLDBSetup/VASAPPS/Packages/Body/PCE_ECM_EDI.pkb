CREATE OR REPLACE PACKAGE BODY VASAPPS."PCE_ECM_EDI" AS
 /*
        *9: Modified by vikas, Only active record should be process for matching, as k'chatgamol, 17.02.2012
        *10: Modified by vikas, to update handling_ins1,2,3 also in matching,
             as k'chatgamol, 09.03.2012
        *11: Modified by vikas, when getting service/dir/port in edi, user vvvoyn as voyage in for load
             list, as k'chatgamol, 13.03.2012
        *12: Added by vikas, when length of vessel code is 5, then get actual
             vessel code from ITP060 table. , as k'chatgamol, 13.03.2012
        *13: Added by vikas, when vessel code is barge, then no need to get actual
             vessel code from ITP060 table, as k'chatgamol, 19.03.2012
        *14: Modified by vikas, When handling instruction code is wrong then no need to log error,
             update null handling instruction code in overshipped/overlanded table, as k'chatgamol, 21.03.2012
        *15: Modified by vikas, When service is DFS then no need to check VVFORL flag in ITP063 table,
             as k'chatgamol, 04.04.2012
        *16: Added by vikas: initialize local variable midstream, 03.05.2012
        *17: Added by vikas: remove validation to check activity date should be less then current date,
             as k'chatgamol, 14.05.2012
        *18: under process
        *19: Modified by vikas, on booked table if loading status is loaded and record is
             active then delete the equipment from overshipped/overlanded table,
             as k'chatgamol, 16.05.2012
        *20: Modified by vikas, for transhipment port the port can be load and discharge, so
             edit the logic to get service, port sequence and, direction, as k'chatgamol, 18.06.2012
        *21: Modified by Leena, for barge the invoyage will be null, so need to use the VVVOYN for
             getting service dir and seq, as k'chatgamol, 20.06.2012
        *22: Modified by Leena, while matching, add the main condition for SOC_COC and empty container
            at the inner else condition also.To avoid SOC record getting matched with COC.
        *23: Modified by vikas, when edi_st_equipment.equipment_status having value more then one
             char then system show pl sql error, as k'nim, 10.07.2012
        *24: Modified by vikas, change time stamp to sysdate because sysdate give the server time
             and current time stamp give the local BKK time, 11.07.2012
        *25: Modified by vikas, if port class porvied by edi and port class after validate is same
             then update port class, without checking ezll_corrai, as k'chatgamol, 22.08.2012
        *27: Modified by vikas, in matching if container operator is 'MAE' and booking type is not 'FC'
             then check EX-MLO-VESSEL also becuase in this case EX-MLO-VOYAGE is same but
             EX-MLO-VESSEL is different,as k'chatgamol, 28.08.2012
        *28: Modified by vikas, on singapore port (SGSIN), SOC booking, check port class also for matching in LL/DL,
             as k'chatgamol, 14.09.2012
        *29: Modified by Vikas, When data come from terminal EDI then update activity date
             from overshipped/overlanded container to booked table, no need to update activity
             date for excel upload EDI, as k'chatgamol, 05.11.2012
        *30: Modified by vikas, When updating cell location after matching from load list to discharge list
             or vice-versa the container must not be Discharge/Loaded, as K'chatgamol, 26.12.2012
        *31: Issue Fix by vikas, Invalid date format system can not convert varchar to date for year
             2013, as k'chatgmol, 02.01.2013.
        *32: Modified by vikas, When booking is blank and slot oeprator is 'OOL' then
             container operator should also be matched as k'chatgamol, 24.01.2013
        *33: Added by vikas, Check special handling also for matching for
             SOC containers, as k'chatgamol, 28.01.2013
        *34: Modified by vikas,When DG inforamtion is comming from EDI then update special handling
             as DG., as k'chatgamol, 02.04.2013
        *35: Modified by vikas, for match process, get bookings in ascending order of booking
             and slot operator, due to booking seq issue, to match fully correct or fully wrong,
             as k'chatgamol, 20.06.2013
        *36: Modified by Leena, update EX MLO VESSEl and EX MLO VOYAGE to EZLL
             as per K Chatgamol, 16.04.2014
        *37: Modified by Leena, comment logging statments as a lot of logging is
             done during edi-ezll data update, 16.04.2014
        *38: Modified by Thitikul, modify program assign EX MLO VOYAGE is null from EX MLO VESSEL to EX MLO VOYAGE , 07.05.2014
        *39: Modified by Thitikul, modify program for update EDI Status each record to 1 time before commit , 09.05.2014
        *40: Modified by Thitikul, add logic when start update EDI to EZLL, system will lock status = 'P'
             and if have error system can roll back to previous status', 23.05.2014
        *41: Modified by Thitikul, cancel function AUTOEXPAND , 30.05.2014
        *42: Modified by Thitikul, rollback program to *38
             modify program add logic when start update EDI to EZLL, system will lock status = 'P' version 2, 10.06.2014
        *43: Modified by Thitikul, cancel function AUTOEXPAND version 2, 16.06.2014
        *44: Modified by Thitikul, update RECORD_ADD_DATE when start and RECORD_CHANGE_DATE when finished each Voyage, 26.06.2014
        *45: Modified by Chatgamol, not error if port class found multi row
        *46: Modified by Chatgamol, Support Preload to update Port class
        *47: Validate VGM and Category  must be save if first_leg_flag is "Y" and Loading status is "Booked"
        *48: Remove checking 1st leg as per K.Lim & K.Chatgamol advise .
        *49: Add VGM Column by Pongkeit .
        *50: If Trading Partner is VERMAS, need to match only Equipment# at LL only. by WACCHO1 on 01/09/2016 as per K.Chatgamol suggesstion.
             and remove logging.
        *51: Remove unnessary loggin in TOS_ERROR_LOG & RCM_ERROR_LOG by WACCHO1 on 17/10/2016
        *52: Support Preload to update IMDG_Class & UNNO only EDI provide booking no both of COC & SOC applied only for Sgsin as per K.Chatgamol adviced on 03/01/2017         
    */
    g_v_delete_flag            VARCHAR2(1) ; -- added by vikas, 06.12.2011
    g_v_record_filter          TOS_SYNC_ERROR_LOG.RECORD_FILTER%TYPE; -- added 13.12.2011
    g_v_record_table           TOS_SYNC_ERROR_LOG.RECORD_TABLE%TYPE;  -- added 13.12.2011
    g_v_load_act_code          VARCHAR2(2) DEFAULT '46'; -- *20
    g_v_discharge_act_code     VARCHAR2(2) DEFAULT '44'; -- *20
    SEP                        CONSTANT VARCHAR2(1) DEFAULT '~';
    G_V_TRADING_PARTNER        VARCHAR2(17) := 'VERMAS'; -- *50

PROCEDURE PRE_TOS_LLDL_COMMON_MATCHING
(   p_i_v_match_type                            VARCHAR2
    , p_i_v_list_type                             VARCHAR2
    , p_i_n_discharge_list_id                     NUMBER
    , p_i_n_dl_container_seq                      NUMBER
    , p_i_n_overlanded_container_id               NUMBER
    , p_i_n_load_list_id                          NUMBER
    , p_i_n_ll_container_seq                      NUMBER
    , p_i_n_overshipped_container_id              NUMBER
    , p_o_v_return_status             OUT NOCOPY  VARCHAR2
)  AS


    CURSOR CUR_COINTAINER_NO_LL IS
        SELECT
            PK_OVERSHIPPED_CONTAINER_ID,
            EQUIPMENT_NO,
            PREADVICE_FLAG,
            IMDG_CLASS,
            UN_NUMBER,
            UN_NUMBER_VARIANT,
            PORT_CLASS,
            PORT_CLASS_TYPE,
            FLASHPOINT_UNIT,
            FLASHPOINT,
            OVERHEIGHT_CM,
            OVERWIDTH_LEFT_CM,
            OVERWIDTH_RIGHT_CM,
            OVERLENGTH_FRONT_CM,
            OVERLENGTH_REAR_CM,
            LOCAL_STATUS,
            BOOKING_NO,
            DISCHARGE_PORT,
            REEFER_TEMPERATURE,
            REEFER_TMP_UNIT,
            HUMIDITY,
            VENTILATION,
            EQ_SIZE,
            EQ_TYPE,
            FULL_MT,
            FLAG_SOC_COC,
            SLOT_OPERATOR,
            CONTAINER_OPERATOR,
            POD_TERMINAL,
            SPECIAL_HANDLING,
            BKG_TYP,
            FK_LOAD_LIST_ID,
            EX_MLO_VOYAGE,
            EX_MLO_VESSEL,
            NVL(
            (
                SELECT
                    TRREFR
                FROM
                    ITP075 B
                WHERE
                    TRTYPE=A.EQ_TYPE
            )
            ,'N') REEFER_FLG,
            CONTAINER_GROSS_WEIGHT,
            VGM,    --*49
            STOWAGE_POSITION,
            MIDSTREAM_HANDLING_CODE ,
            HANDLING_INSTRUCTION_1 /*-- *10*/
            ,
            HANDLING_INSTRUCTION_2 /*-- *10*/
            ,
            HANDLING_INSTRUCTION_3 /*-- *10*/
            ,
            ACTIVITY_DATE_TIME /*-- *29*/
            ,TRADING_PARTNER --*50
        FROM
            TOS_LL_OVERSHIPPED_CONTAINER A
        WHERE
            (
                (
                    p_i_v_match_type                           ='A'
                    AND NVL(EQUIPMENT_NO_QUESTIONABLE_FLAG,'N')='N'
                )
                OR p_i_v_match_type IN ('E','M')
            )
            AND PK_OVERSHIPPED_CONTAINER_ID = NVL(p_i_n_overshipped_container_id,
            PK_OVERSHIPPED_CONTAINER_ID)
            AND FK_LOAD_LIST_ID   = p_i_n_load_list_id
            AND NVL(DA_ERROR,'N') = 'N'
            AND p_i_v_list_type   = 'LL';

    CURSOR CUR_BOOKED_LOADING (p_i_v_container_no  VARCHAR2,p_i_n_ll_id NUMBER) IS
        SELECT
            PK_BOOKED_LOADING_ID,
            DN_EQUIPMENT_NO,
            DN_SOC_COC,
            DN_FULL_MT,
            DN_EQ_SIZE ,
            DN_EQ_TYPE,
            LOCAL_STATUS,
            LOADING_STATUS,
            FK_BOOKING_NO,
            FK_SLOT_OPERATOR,
            OVERHEIGHT_CM ,
            OVERLENGTH_REAR_CM,
            OVERLENGTH_FRONT_CM ,
            OVERWIDTH_LEFT_CM ,
            OVERWIDTH_RIGHT_CM ,
            FK_UNNO,
            FK_UN_VAR,
            DN_DISCHARGE_PORT,
            FLASH_POINT,
            FLASH_UNIT,
            FK_IMDG,
            REEFER_TMP,
            REEFER_TMP_UNIT,
            DN_HUMIDITY,
            DN_VENTILATION,
            FK_PORT_CLASS,
            FK_PORT_CLASS_TYP,
            FK_CONTAINER_OPERATOR ,
            DN_DISCHARGE_TERMINAL ,
            DN_BKG_TYP,
            DN_SPECIAL_HNDL,
            EX_MLO_VOYAGE,
            EX_MLO_VESSEL,
            FK_BKG_EQUIPM_DTL EQUIPMENT_SEQ_NO
        FROM
            TOS_LL_BOOKED_LOADING
        WHERE
            FK_LOAD_LIST_ID    = NVL(p_i_n_ll_id, FK_LOAD_LIST_ID)
            AND LOADING_STATUS = NVL2(p_i_v_container_no,'BK', LOADING_STATUS)
            AND
            (
                p_i_v_container_no IS NULL
                OR DN_EQUIPMENT_NO  = p_i_v_container_no
            )
            AND CONTAINER_SEQ_NO = NVL(p_i_n_ll_container_seq, CONTAINER_SEQ_NO)
            AND RECORD_STATUS    = 'A' /*-- *9*/
        ORDER BY                  /* *35 */
            FK_BOOKING_NO ASC,    /* *35 */
            FK_SLOT_OPERATOR ASC; /* *35 */

        ----------------------when matched container to container then take booked status from TOS_LL_BOOKED_LOADING container only
        --------for rest cases we need to comsider all status because of autoexpand
    CURSOR CUR_COINTAINER_NO_DL IS
        SELECT
            PK_OVERLANDED_CONTAINER_ID,
            EQUIPMENT_NO,
            IMDG_CLASS,
            UN_NUMBER,
            UN_NUMBER_VARIANT,
            PORT_CLASS,
            PORT_CLASS_TYP,
            FLASHPOINT_UNIT,
            POL_TERMINAL,
            FLASHPOINT,
            OVERHEIGHT_CM,
            OVERWIDTH_LEFT_CM,
            OVERWIDTH_RIGHT_CM,
            OVERLENGTH_FRONT_CM,
            OVERLENGTH_REAR_CM,
            LOCAL_STATUS,
            BOOKING_NO,
            POL,
            REEFER_TEMPERATURE,
            REEFER_TMP_UNIT,
            HUMIDITY,
            VENTILATION,
            BKG_TYP,
            EQ_SIZE,
            EQ_TYPE,
            FULL_MT,
            FLAG_SOC_COC,
            SLOT_OPERATOR,
            CONTAINER_OPERATOR,
            FK_DISCHARGE_LIST_ID,
            SPECIAL_HANDLING,
            NVL(
            (
                SELECT
                    TRREFR
                FROM
                    ITP075 B
                WHERE
                    TRTYPE=A.EQ_TYPE
            )
            ,'N') REEFER_FLG,
            CONTAINER_GROSS_WEIGHT,
            VGM, --*49
            STOWAGE_POSITION,
            MIDSTREAM_HANDLING_CODE ,
            HANDLING_INSTRUCTION_1 /*-- *10*/
            ,
            HANDLING_INSTRUCTION_2 /*-- *10*/
            ,
            HANDLING_INSTRUCTION_3 /*-- *10*/
            ,
            ACTIVITY_DATE_TIME /*-- *29*/
        FROM
            TOS_DL_OVERLANDED_CONTAINER A
        WHERE
            NVL(DA_ERROR,'N')              = 'N'
            AND PK_OVERLANDED_CONTAINER_ID = NVL(p_i_n_overlanded_container_id,
            PK_OVERLANDED_CONTAINER_ID)
            AND FK_DISCHARGE_LIST_ID = p_i_n_discharge_list_id
            AND p_i_v_list_type      = 'DL';

    CURSOR CUR_BOOKED_DISCHARGE (p_i_v_container_no  VARCHAR2,p_i_n_dl_id NUMBER) IS
        SELECT
            PK_BOOKED_DISCHARGE_ID,
            DN_EQUIPMENT_NO,
            DN_SOC_COC,
            DN_FULL_MT,
            DN_EQ_SIZE ,
            DN_EQ_TYPE,
            LOCAL_STATUS,
            DISCHARGE_STATUS ,
            FK_BOOKING_NO,
            OVERHEIGHT_CM ,
            OVERLENGTH_REAR_CM,
            OVERLENGTH_FRONT_CM ,
            OVERWIDTH_LEFT_CM ,
            OVERWIDTH_RIGHT_CM ,
            FK_UNNO,
            FK_UN_VAR,
            DN_FINAL_POD,
            DN_POL,
            FK_SLOT_OPERATOR,
            FLASH_POINT,
            FLASH_UNIT,
            FK_IMDG,
            REEFER_TEMPERATURE,
            REEFER_TMP_UNIT,
            DN_HUMIDITY,
            DN_VENTILATION,
            FK_PORT_CLASS,
            FK_PORT_CLASS_TYP,
            FK_CONTAINER_OPERATOR,
            DN_BKG_TYP,
            DN_SPECIAL_HNDL,
            DN_POL_TERMINAL,
            FK_BKG_EQUIPM_DTL EQUIPMENT_SEQ_NO
        FROM
            TOS_DL_BOOKED_DISCHARGE
        WHERE
            FK_DISCHARGE_LIST_ID = NVL(p_i_n_dl_id,FK_DISCHARGE_LIST_ID)
            AND DISCHARGE_STATUS = NVL2(p_i_v_container_no ,'BK',DISCHARGE_STATUS)
            AND
            (
                p_i_v_container_no IS NULL
                OR DN_EQUIPMENT_NO  = p_i_v_container_no
            )
            AND CONTAINER_SEQ_NO = NVL(p_i_n_dl_container_seq,CONTAINER_SEQ_NO)
            AND RECORD_STATUS    = 'A' /* *9 */
        ORDER BY                  /* *35 */
            FK_BOOKING_NO ASC,    /* *35 */
            FK_SLOT_OPERATOR ASC; /* *35 */


    /*********************************************************************************
       Name           :  PRE_TOS_LLDL_COMMON_MATCHING
       Module         :
       Purpose        :  To Update data LAOD LIST AND DISCHARGE LIST  TABLES
       Calls          :  PRE_TOS_LLDL_MATCH_UPDATE
       Returns        :  Null
       Author          Date               What
       ------          ----               ----
       Rajat           06/02/2010        INITIAL VERSION
    ***********************************************************************************/
    l_v_cont_exst               VARCHAR2(1);
    l_v_coc_ful                 VARCHAR2(1);
    l_v_coc_empty               VARCHAR2(1);
    l_v_coc_emp_llstat          VARCHAR2(1);
    l_v_soc_rcl                 VARCHAR2(1);
    l_v_booking_no              VARCHAR2(12);
    l_v_booked_lldl_id          NUMBER;
    l_v_sococ_fe                VARCHAR2(1);
    l_v_time                    TIMESTAMP;
    l_v_parameter_str           VARCHAR2(200);
    l_exce_main                 EXCEPTION;
    l_v_rec_found               VARCHAR2(1);
    l_n_rec_count               NUMBER;

    l_arr_var_name              STRING_ARRAY ;
    l_arr_var_value             STRING_ARRAY ;
    l_arr_var_io                STRING_ARRAY ;
    l_t_log_info                TIMESTAMP(6) ;
    l_v_err_code                TOS_ERROR_MST.ERROR_CODE%TYPE;

    l_v_list_type               VARCHAR2(1);
    L_V_BOOKED_LOADING_ID       TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE; --Leena 16.01.2012
    L_V_CONTAINER_SEQ_NO        TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO%TYPE; --Leena 16.01.2012
    L_V_BOOKED_DISCHARGE_ID     TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID%TYPE; --Leena 16.01.2012
    L_V_SZE_TYP_EQPNO_CORECT_FLAG VARCHAR2(1):= 'N'; --Leena 17.01.2012

    l_parameter_str1            VARCHAR2(200);
    l_parameter_str2            VARCHAR2(200);
    l_parameter_str3            VARCHAR2(200);

    l_v_port                    VASAPPS.TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE; -- *28
    C_SGSIN                     CONSTANT VASAPPS.TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE DEFAULT 'SGSIN'; -- *28
BEGIN
    l_v_time  := SYSDATE; -- CURRENT_TIMESTAMP; --*24

    l_v_parameter_str := p_i_v_match_type||SEP||
                        p_i_v_list_type||SEP||
                        p_i_n_discharge_list_id||SEP||
                        p_i_n_dl_container_seq||SEP||
                        p_i_n_overlanded_container_id ||SEP||
                        p_i_n_load_list_id||SEP||
                        p_i_n_ll_container_seq ||SEP||
                        p_i_n_overshipped_container_id ;


    IF p_i_v_list_type = 'LL' THEN
        l_v_list_type := 'L';

        DELETE from tos_error_log
        where error_code like 'M%'
        AND FK_LOAD_LIST_ID = p_i_n_load_list_id;

        /* *28 start * */
        SELECT
            DN_PORT
        INTO
            L_V_PORT
        FROM
            VASAPPS.TOS_LL_LOAD_LIST
        WHERE
            PK_LOAD_LIST_ID = p_i_n_load_list_id;
        /* *28 end * */
    ELSE
        l_v_list_type := 'D';

        DELETE from tos_error_log
        where error_code like 'M%'
        AND FK_DISCHARGE_LIST_ID= p_i_n_discharge_list_id;

        /* *28 start * */
        SELECT
            DN_PORT
        INTO
            L_V_PORT
        FROM
            VASAPPS.TOS_DL_DISCHARGE_LIST
        WHERE
            PK_DISCHARGE_LIST_ID = p_i_n_discharge_list_id;
        /* *28 end * */

    END IF;

    FOR CUR_COINTAINER_NO_DATA IN CUR_COINTAINER_NO_LL
    LOOP

        g_v_sql_id := 'SQL-01001';

        BEGIN
            SELECT COUNT(1)
            INTO l_n_rec_count
            FROM TOS_LL_BOOKED_LOADING
            WHERE NVL(DN_EQUIPMENT_NO,'*') = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
            AND FK_LOAD_LIST_ID = p_i_n_load_list_id
            AND LOADING_STATUS = 'LO'
            AND RECORD_STATUS = 'A'; -- *19

            IF l_n_rec_count > 0 THEN
                l_v_rec_found := 'Y';
            ELSE
                l_v_rec_found := 'N';
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            RAISE l_exce_main;
        END;
        l_t_log_info := SYSDATE; -- CURRENT_TIMESTAMP; --*24

        /* Start added by vikas on 29/08/2011 to delete data from overshipped tab for status loaded*/

        g_v_sql_id := 'SQL-01001a';
        BEGIN
            IF l_v_rec_found = 'Y' THEN
                /* vikas: start adding against bug* 588, on 19.10.2011 */
                /*Booking is already available in overshipped tab with loaded status.*/
             /*-- #start #51
                l_v_err_code := 'MC001';
                PRE_TOS_ERROR_LOG(
                    l_v_list_type
                    , p_i_n_load_list_id
                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                    , NULL
                    , NULL
                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                    , l_v_err_code
                    , g_v_user
                    , g_v_user
                );
                /* vikas: end adding against bug* 588, on 19.10.2011 */
            -- end #51*/
                DELETE FROM TOS_LL_OVERSHIPPED_CONTAINER
                WHERE NVL(EQUIPMENT_NO,'*') = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                AND   FK_LOAD_LIST_ID = p_i_n_load_list_id;
          /*-- start #51
            ELSE
                l_v_err_code := 'MCP01';
                PRE_TOS_ERROR_LOG(
                    l_v_list_type
                    , p_i_n_load_list_id
                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                    , NULL
                    , NULL
                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                    , l_v_err_code
                    , g_v_user
                    , g_v_user
                );
          --end #51 */
            END IF;

        EXCEPTION
        WHEN OTHERS THEN
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            RAISE l_exce_main;
        END;
        /* End added by vikas on 29/08/2011 to delete data from overshipped tab for status loaded*/

        IF l_v_rec_found = 'N' THEN
            l_v_cont_exst := 'N';
            /*
            Commented by vikas, no need this loop because in next loop check equipmnet no* null or not, k'sukit, 16.02.2012
            *

              FOR CUR_BOOKED_LOADING_DATA IN CUR_BOOKED_LOADING(CUR_COINTAINER_NO_DATA.EQUIPMENT_NO,NVL(p_i_n_load_list_id,CUR_COINTAINER_NO_DATA.FK_LOAD_LIST_ID))
                 LOOP
                    l_v_cont_exst := 'Y';  ------------ for matching done by container by container
                    g_v_sql_id := 'SQL-01002';

                    PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_EDI (
                          p_i_v_list_type
                        , CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID
                        , p_i_n_overshipped_container_id
                        , g_v_user
                        , TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDDHH24MISS')
                        , p_o_v_return_status
                    );
                  l_arr_var_name := STRING_ARRAY
                 ('p_i_v_load_dischage_list_flag'           , 'p_i_v_booked_id'           , 'p_i_v_osol_id'
                , 'p_i_v_add_user'                          , 'p_i_v_add_date'            , 'p_o_v_error'
                  );

                  l_arr_var_value := STRING_ARRAY
                 (p_i_v_list_type      , CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID          , p_i_n_overshipped_container_id
                , g_v_user             , TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDDHH24MISS')        , p_o_v_return_status
                  );

                  l_arr_var_io := STRING_ARRAY
                 ('I'      , 'I'      , 'I'
                , 'I'      , 'I'      , 'O'
                  );

                  PRE_LOG_INFO
                  ('PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING'
                 , 'PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_EDI'
                 , g_v_sql_id
                 , g_v_user
                 , l_t_log_info
                 , NULL
                 , l_arr_var_name
                 , l_arr_var_value
                 , l_arr_var_io
                  );

                IF (p_o_v_return_status = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                    p_o_v_return_status := '0';
                ELSE
                    p_o_v_return_status := '1';
                    /* vikas: start adding against bug* 588, on 19.10.2011 *
                    /* Error occurred in raise enotice edi package.*

                        l_v_err_code := 'MC003';
                        PRE_TOS_ERROR_LOG(
                              l_v_list_type
                            , p_i_n_load_list_id
                            , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                            , NULL
                            , NULL
                            , CUR_COINTAINER_NO_DATA.BOOKING_NO
                            , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                        );
                    /* vikas: end adding against bug* 588, on 19.10.2011 *

                        RAISE l_exce_main;
                    END IF;

                    BEGIN
                       PRE_LOG_INFO
                       ('PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING'
                        , 'CHECK'
                        , '1'
                        , g_v_user
                        , l_t_log_info
                        , 'STEP EXECUTED'
                        , NULL
                        , NULL
                        , NULL
                        );
                        g_v_sql_id := 'SQL-01003';
                        g_v_delete_flag := 'Y' ;  -- added by vikas, 06.12.2011

                        PRE_TOS_LLDL_MATCH_UPDATE('LL'
                                                , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                                , CUR_COINTAINER_NO_DATA.OVERHEIGHT_CM
                                                , CUR_COINTAINER_NO_DATA.OVERLENGTH_REAR_CM
                                                , CUR_COINTAINER_NO_DATA.OVERLENGTH_FRONT_CM
                                                , CUR_COINTAINER_NO_DATA.OVERWIDTH_LEFT_CM
                                                , CUR_COINTAINER_NO_DATA.OVERWIDTH_RIGHT_CM
                                                , CUR_COINTAINER_NO_DATA.UN_NUMBER
                                                , CUR_COINTAINER_NO_DATA.UN_NUMBER_VARIANT
                                                , CUR_COINTAINER_NO_DATA.FLASHPOINT
                                                , CUR_COINTAINER_NO_DATA.FLASHPOINT_UNIT
                                                , CUR_COINTAINER_NO_DATA.IMDG_CLASS
                                                , CUR_COINTAINER_NO_DATA.REEFER_TEMPERATURE
                                                , CUR_COINTAINER_NO_DATA.REEFER_TMP_UNIT
                                                , CUR_COINTAINER_NO_DATA.HUMIDITY
                                                , CUR_COINTAINER_NO_DATA.VENTILATION
                                                , CUR_COINTAINER_NO_DATA.PORT_CLASS
                                                , CUR_COINTAINER_NO_DATA.PORT_CLASS_TYPE
                                                , NULL
                                                , NULL
                                                , CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID
                                                , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                                , CUR_BOOKED_LOADING_DATA.EQUIPMENT_SEQ_NO
                                                , CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO
                                                , CUR_COINTAINER_NO_DATA.CONTAINER_GROSS_WEIGHT
                                                , CUR_COINTAINER_NO_DATA.STOWAGE_POSITION
                                                , CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR
                                                , CUR_COINTAINER_NO_DATA.PREADVICE_FLAG
                                                , p_i_n_load_list_id
                                                , CUR_COINTAINER_NO_DATA.MIDSTREAM_HANDLING_CODE
                                                , p_o_v_return_status );

                            l_arr_var_name := STRING_ARRAY
                           ('p_i_n_list_type'                , 'p_i_v_equipment_no'              , 'p_i_n_overheight'
                          , 'p_i_n_overlength_rear'          , 'p_i_n_overlength_front'          , 'p_i_n_overwidth_left'
                          , 'p_i_n_overwidth_right'          , 'p_i_v_unno'                      , 'p_i_v_un_var'
                          , 'p_i_v_flash_point'              , 'p_i_n_flash_unit'                , 'p_i_v_imdg'
                          , 'p_i_n_reefer_tmp'               , 'p_i_v_reefer_tmp_unit'           , 'p_i_n_humidity'
                          , 'p_i_n_ventilation'              , 'p_i_v_port_class'                , 'p_i_v_portclass_type'
                          , 'p_i_n_discharge_id'             , 'p_i_n_overlanded_container_id'   , 'p_i_n_booked_load_id'
                          , 'p_i_n_overshipped_container_id' , 'p_i_n_equipment_seq_no'          , 'p_i_v_booking_no'
                          , 'p_i_n_gross_wt'                 , 'p_i_v_stowage_position'          , 'p_i_v_container_operator'
                          , 'p_i_v_preadvice_flg'
                          , 'p_o_v_return_status'
                            );

                            l_arr_var_value := STRING_ARRAY
                           ('LL'                                        , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO          , CUR_COINTAINER_NO_DATA.OVERHEIGHT_CM
                          , CUR_COINTAINER_NO_DATA.OVERLENGTH_REAR_CM   , CUR_COINTAINER_NO_DATA.OVERLENGTH_FRONT_CM   , CUR_COINTAINER_NO_DATA.OVERWIDTH_LEFT_CM
                          , CUR_COINTAINER_NO_DATA.OVERWIDTH_RIGHT_CM   , CUR_COINTAINER_NO_DATA.UN_NUMBER             , CUR_COINTAINER_NO_DATA.UN_NUMBER_VARIANT
                          , CUR_COINTAINER_NO_DATA.FLASHPOINT           , CUR_COINTAINER_NO_DATA.FLASHPOINT_UNIT       , CUR_COINTAINER_NO_DATA.IMDG_CLASS
                          , CUR_COINTAINER_NO_DATA.REEFER_TEMPERATURE   , CUR_COINTAINER_NO_DATA.REEFER_TMP_UNIT       , CUR_COINTAINER_NO_DATA.HUMIDITY
                          , CUR_COINTAINER_NO_DATA.VENTILATION          , CUR_COINTAINER_NO_DATA.PORT_CLASS            , CUR_COINTAINER_NO_DATA.PORT_CLASS_TYPE
                          , NULL                                        , NULL                                         , l_v_booked_lldl_id
                          , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID  , CUR_BOOKED_LOADING_DATA.EQUIPMENT_SEQ_NO   , CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO
                          , CUR_COINTAINER_NO_DATA.CONTAINER_GROSS_WEIGHT       , CUR_COINTAINER_NO_DATA.STOWAGE_POSITION    , CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR
                          , CUR_COINTAINER_NO_DATA.PREADVICE_FLAG
                          , p_o_v_return_status
                            );

                            l_arr_var_io := STRING_ARRAY
                           ('I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'
                          , 'O'
                            );

                            PRE_LOG_INFO
                            ('PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING'
                           , 'PRE_TOS_LLDL_MATCH_UPDATE'
                           , g_v_sql_id
                           , g_v_user
                           , l_t_log_info
                           , NULL
                           , l_arr_var_name
                           , l_arr_var_value
                           , l_arr_var_io
                            );

                       IF p_o_v_return_status = '1' THEN
                            /* vikas: start adding against bug* 588, on 19.10.2011 *
                            /*Error occurred in LL-DL matching update.*
                            l_v_err_code := 'MC011';
                            PRE_TOS_ERROR_LOG(
                                  l_v_list_type
                                , p_i_n_load_list_id
                                , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                , NULL
                                , NULL
                                , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );
                            /* vikas: end adding against bug* 588, on 19.10.2011 *
                           g_v_err_code   := TO_CHAR(SQLCODE);
                           g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                           RAISE l_exce_main;
                       END IF;

                    EXCEPTION
                       WHEN OTHERS THEN
                          g_v_err_code   := TO_CHAR(SQLCODE);
                          g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                          RAISE l_exce_main;
                    END;

                      ----------SYNCHRONIZATION BATCH  CALLED TO UPDATE IN BKP009---------------------
                       --Added by bindu on 03/03/2011 to delete from Automatch lunch temp table.
                       g_v_sql_id := 'SQL-01005';
                       IF p_i_v_match_type = 'E' THEN
                          BEGIN

                             DELETE FROM TOS_TMP_AUTOMATCH_LAUNCH
                             WHERE FK_LOAD_LIST_ID           = p_i_n_load_list_id
                             AND FK_OVERSHIPPED_CONTAINER_ID = cur_cointainer_no_data.PK_OVERSHIPPED_CONTAINER_ID
                             AND FK_BOOKING_NO               = cur_cointainer_no_data.BOOKING_NO
                             AND DN_EQUIPMENT_NO             = cur_cointainer_no_data.EQUIPMENT_NO;
                          EXCEPTION
                             WHEN OTHERS THEN
                                /* vikas: start adding against bug* 588, on 19.10.2011 */
                                /* Error occurred in deleting record from TOS_TMP_AUTOMATCH_LAUNCH. *

                                l_v_err_code := 'MC012';
                                PRE_TOS_ERROR_LOG(
                                      l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                                /* vikas: end adding against bug* 588, on 19.10.2011 *
                                g_v_err_code   := TO_CHAR(SQLCODE);
                                g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                                RAISE l_exce_main;
                          END;
                       END IF;
                       --Added by bindu on 03/03/2011 to delete from Automatch lunch temp table.
                END LOOP;
                /*
                    Commented by vikas, as suggested by k'sukit, 16.02.2012
                */


            IF l_v_cont_exst = 'N' THEN ---MATCHING NOT DONE CONTAINER BY CONTAINER

                FOR CUR_BOOKED_LOADING_DATA IN CUR_BOOKED_LOADING('',p_i_n_load_list_id)----PASSING NULL BECAUSE NEED TO TAKE ALL CONTAINER FROM BOOKED LOADING
                LOOP
                    l_v_booked_lldl_id  := NULL;
                    l_v_soc_rcl := NULL;
                    l_v_coc_ful := NULL;
                    l_v_coc_empty := NULL;

                    /*
                    Start added by vikas, for matching use only five characters
                    of ex_mlo_vessel, with booked tab, as k'chatgamol, 20.12.2011
                    *
                    l_v_ex_mlo_vessel := NULL;

                    IF CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL IS NOT NULL THEN
                        SELECT
                            SUBSTR(CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL,1, 5)
                        INTO
                            l_v_ex_mlo_vessel
                        FROM
                            DUAL;
                    END IF;

                    *
                        end added by vikas, 20.12.2011
                    */

                    /*
                        *3 Modified by vikas, to check if booking no* comming from edi then no need
                        to match with terminal, as k'myo, 21.02.2012
                    */

                    /*
                        *4: Modified by vikas, to remove white space between EX-MLO vessel before matching, k'chatgamol, 05.03.2012
                    */

                    -- START *50

                    IF NVL(CUR_COINTAINER_NO_DATA.TRADING_PARTNER,'-') = G_V_TRADING_PARTNER THEN
                       IF CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO THEN
                       l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;

                               PRE_TOS_LLDL_MATCH_UPDATE('LL'
                                                        , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                                        , CUR_COINTAINER_NO_DATA.OVERHEIGHT_CM
                                                        , CUR_COINTAINER_NO_DATA.OVERLENGTH_REAR_CM
                                                        , CUR_COINTAINER_NO_DATA.OVERLENGTH_FRONT_CM
                                                        , CUR_COINTAINER_NO_DATA.OVERWIDTH_LEFT_CM
                                                        , CUR_COINTAINER_NO_DATA.OVERWIDTH_RIGHT_CM
                                                        , CUR_COINTAINER_NO_DATA.UN_NUMBER
                                                        , CUR_COINTAINER_NO_DATA.UN_NUMBER_VARIANT
                                                        , CUR_COINTAINER_NO_DATA.FLASHPOINT
                                                        , CUR_COINTAINER_NO_DATA.FLASHPOINT_UNIT
                                                        , CUR_COINTAINER_NO_DATA.IMDG_CLASS
                                                        , CUR_COINTAINER_NO_DATA.REEFER_TEMPERATURE
                                                        , CUR_COINTAINER_NO_DATA.REEFER_TMP_UNIT
                                                        , CUR_COINTAINER_NO_DATA.HUMIDITY
                                                        , CUR_COINTAINER_NO_DATA.VENTILATION
                                                        , CUR_COINTAINER_NO_DATA.PORT_CLASS
                                                        , CUR_COINTAINER_NO_DATA.PORT_CLASS_TYPE
                                                        , NULL
                                                        , NULL
                                                        , l_v_booked_lldl_id --CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID
                                                        , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                                        , CUR_BOOKED_LOADING_DATA.EQUIPMENT_SEQ_NO
                                                        , CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO
                                                        , CUR_COINTAINER_NO_DATA.CONTAINER_GROSS_WEIGHT
                                                        , CUR_COINTAINER_NO_DATA.VGM    --*49
                                                        , CUR_COINTAINER_NO_DATA.STOWAGE_POSITION
                                                        , CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR
                                                        , CUR_COINTAINER_NO_DATA.PREADVICE_FLAG
                                                        , p_i_n_load_list_id
                                                        , CUR_COINTAINER_NO_DATA.MIDSTREAM_HANDLING_CODE
                                                        , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_1 -- *10
                                                        , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_2 -- *10
                                                        , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_3 -- *10
                                                        , CUR_COINTAINER_NO_DATA.ACTIVITY_DATE_TIME -- *29
                                                        , CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL -- *36
                                                        , CUR_COINTAINER_NO_DATA.EX_MLO_VOYAGE -- *36
                                                        , p_o_v_return_status );
                     /*-- start #51
                       ELSE
                            --String x = EQUIPMENT_NO NOT MATCH FOR VERMAS
                            l_v_err_code := 'MCV01';
                            PRE_TOS_ERROR_LOG(
                                              l_v_list_type
                                              , p_i_n_load_list_id
                                              , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                              , NULL
                                              , NULL
                                              , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                              , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                              , l_v_err_code
                                              , g_v_user
                                              , g_v_user
                                              );

                            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_err_code||SEP||l_v_list_type||SEP||CUR_COINTAINER_NO_DATA.BOOKING_NO||SEP||CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                          , 'MCV01'
                                          , null
                                          , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                            ||' '||CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE
                                          ,g_v_user
                                          , SYSDATE
                                            );
                    --end #51 */
                       END IF;

                    END IF;
                    -- END *50

                    IF NVL(CUR_COINTAINER_NO_DATA.TRADING_PARTNER,'-') <> G_V_TRADING_PARTNER THEN  -- *50 IF NOT VERMAS WILL USE ORIGINAL MATCHING LOGIC.

                    IF CUR_COINTAINER_NO_DATA.FLAG_SOC_COC = 'C' AND  CUR_COINTAINER_NO_DATA.FULL_MT = 'F'   THEN -----COC OR SOC
                        IF  CUR_BOOKED_LOADING_DATA.DN_EQ_SIZE                   = CUR_COINTAINER_NO_DATA.EQ_SIZE
                            AND CUR_BOOKED_LOADING_DATA.DN_EQ_TYPE               = CUR_COINTAINER_NO_DATA.EQ_TYPE
                            AND CUR_BOOKED_LOADING_DATA.LOCAL_STATUS             = CUR_COINTAINER_NO_DATA.LOCAL_STATUS
                            AND CUR_BOOKED_LOADING_DATA.DN_FULL_MT               = CUR_COINTAINER_NO_DATA.FULL_MT
                            AND CUR_BOOKED_LOADING_DATA.DN_DISCHARGE_PORT        = CUR_COINTAINER_NO_DATA.DISCHARGE_PORT
                            -- AND CUR_BOOKED_LOADING_DATA.DN_DISCHARGE_TERMINAL    = CUR_COINTAINER_NO_DATA.POD_TERMINAL -- *3
                            AND CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL          =  CUR_COINTAINER_NO_DATA.SPECIAL_HANDLING
                            AND CUR_BOOKED_LOADING_DATA.DN_SOC_COC               =  CUR_COINTAINER_NO_DATA.FLAG_SOC_COC
                            AND CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO  IS NOT NULL -- Added 17.02.2012
                            AND (CUR_COINTAINER_NO_DATA.REEFER_FLG = 'N' OR
                               (CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL = 'NR' AND CUR_COINTAINER_NO_DATA.REEFER_FLG = 'Y'))
                            AND CUR_BOOKED_LOADING_DATA.LOADING_STATUS           = 'BK'     THEN

                                /*
                                    Block Start by vikas, Join booking* also if booking number provided from EDI,  16.02.2012
                                */
                                IF CUR_COINTAINER_NO_DATA.BOOKING_NO IS NULL THEN
                                    -- IF CUR_BOOKED_LOADING_DATA.DN_DISCHARGE_TERMINAL    = CUR_COINTAINER_NO_DATA.POD_TERMINAL THEN -- *3
                                        l_v_coc_ful := 'Y';
                                        l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                    -- END IF; -- *3
                                ELSIF NVL(CUR_COINTAINER_NO_DATA.BOOKING_NO,'*') = NVL(CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO,'*') THEN
                                    l_v_coc_ful := 'Y';
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                    -- start *52 
                                    
                                    IF CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL ='D1' THEN
                                       IF (L_V_PORT = C_SGSIN AND 
                                        CUR_COINTAINER_NO_DATA.IMDG_CLASS = CUR_BOOKED_LOADING_DATA.FK_IMDG AND 
                                        CUR_COINTAINER_NO_DATA.UN_NUMBER = CUR_BOOKED_LOADING_DATA.FK_UNNO) 
                                       THEN 
                                          l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                       ELSE 
                                          l_v_booked_lldl_id  := NULL;
                                       END IF;
                                       
                                    END IF ; 
                                    -- end *52                                     
                                END IF;

                                /*
                                    * old logic *
                                l_v_coc_ful := 'Y';
                                l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                */

    /*
                                    Block end by vikas, 16.02.2012
                                */
                        /*-- start #51
                        ELSE
                            -- error
                            --String x = EQUIPMENT_NO~DN_EQ_SIZE~DN_EQ_TYPE
                            l_v_err_code := 'MC015';
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , p_i_n_load_list_id
                                , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                , NULL
                                , NULL
                                , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );

                            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_err_code||SEP||l_v_list_type||SEP||CUR_COINTAINER_NO_DATA.BOOKING_NO||SEP||CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                          , 'MC015'
                                          , null
                                          , CUR_COINTAINER_NO_DATA.FLAG_SOC_COC
                                            ||' '||CUR_BOOKED_LOADING_DATA.DN_EQ_SIZE
                                            ||'<>'||CUR_COINTAINER_NO_DATA.EQ_SIZE
                                            ||' '||CUR_BOOKED_LOADING_DATA.DN_EQ_TYPE
                                            ||'<>'||CUR_COINTAINER_NO_DATA.EQ_TYPE
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE
                                          ,g_v_user
                                          , SYSDATE
                                            );
                        -- end #51*/

                        END IF;
                    ELSIF CUR_COINTAINER_NO_DATA.FLAG_SOC_COC = 'C' AND  CUR_COINTAINER_NO_DATA.FULL_MT = 'E' THEN
                        IF  CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO   = CUR_COINTAINER_NO_DATA.BOOKING_NO
                            AND CUR_BOOKED_LOADING_DATA.DN_EQ_SIZE  = CUR_COINTAINER_NO_DATA.EQ_SIZE
                            AND CUR_BOOKED_LOADING_DATA.DN_EQ_TYPE  = CUR_COINTAINER_NO_DATA.EQ_TYPE THEN
                                l_v_coc_empty := 'Y' ;
                                IF CUR_BOOKED_LOADING_DATA.LOADING_STATUS = 'BK' AND  -- Modified by vikas, equipment* should be null or same as edi equipment*, as k'chatgamol, 14.02.2012
                                    --CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL THEN
                                     ((CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL) OR
                                     (CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO)) THEN
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                END IF;
                        ELSIF CUR_BOOKED_LOADING_DATA.DN_DISCHARGE_PORT       = CUR_COINTAINER_NO_DATA.DISCHARGE_PORT
                             AND CUR_BOOKED_LOADING_DATA.DN_EQ_SIZE            = CUR_COINTAINER_NO_DATA.EQ_SIZE
                             AND CUR_BOOKED_LOADING_DATA.DN_EQ_TYPE            = CUR_COINTAINER_NO_DATA.EQ_TYPE
                             AND CUR_BOOKED_LOADING_DATA.DN_DISCHARGE_TERMINAL = CUR_COINTAINER_NO_DATA.POD_TERMINAL
                             AND CUR_BOOKED_LOADING_DATA.LOCAL_STATUS          = CUR_COINTAINER_NO_DATA.LOCAL_STATUS
                             AND CUR_BOOKED_LOADING_DATA.DN_SOC_COC               = CUR_COINTAINER_NO_DATA.FLAG_SOC_COC  -- *22
                             AND CUR_BOOKED_LOADING_DATA.DN_FULL_MT               = CUR_COINTAINER_NO_DATA.FULL_MT THEN--*22
                                l_v_coc_empty := 'Y' ;
                                IF CUR_BOOKED_LOADING_DATA.LOADING_STATUS = 'BK' AND   -- Modified by vikas, equipment* should be null or same as edi equipment*, as k'chatgamol, 14.02.2012
                                    --CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL THEN
                                    ((CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL) OR
                                    (CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO)) THEN
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                END IF;
                        /*-- start #51
                        ELSE
                            -- error
                            --String x = EQUIPMENT_NO~DN_EQ_SIZE~DN_EQ_TYPE
                            l_v_err_code := 'MC016';
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , p_i_n_load_list_id
                                , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                , NULL
                                , NULL
                                , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );
                        --end #51 */
                        END IF;------------------------------------------------IF OF TWO CASES OF COC AND EMPTY
                    ELSIF CUR_COINTAINER_NO_DATA.FLAG_SOC_COC = 'S' THEN
                        IF  CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO           = CUR_COINTAINER_NO_DATA.BOOKING_NO
                            AND CUR_BOOKED_LOADING_DATA.DN_EQ_SIZE          = CUR_COINTAINER_NO_DATA.EQ_SIZE
                            AND CUR_BOOKED_LOADING_DATA.DN_EQ_TYPE          = CUR_COINTAINER_NO_DATA.EQ_TYPE THEN
                                l_v_soc_rcl := 'Y' ;
                                IF CUR_BOOKED_LOADING_DATA.LOADING_STATUS = 'BK' AND  -- Modified by vikas, equipment* should be null or same as edi equipment*, as k'chatgamol, 14.02.2012
                                    --CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL THEN
                                     ((CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL) OR
                                    (CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO))
                                THEN

                                     /* *33 start * */
                                    IF  ((CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL = 'N') OR
                                        (CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL = 'D1') OR
                                        (CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL = 'O0') )
                                    THEN
                                        IF (CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL = CUR_COINTAINER_NO_DATA.SPECIAL_HANDLING) then
                                            l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                            -- start *52 
                                            
                                            IF CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL ='D1' THEN
                                               IF (L_V_PORT = C_SGSIN AND 
                                                NVL(CUR_COINTAINER_NO_DATA.IMDG_CLASS,SEP) = NVL(CUR_BOOKED_LOADING_DATA.FK_IMDG,SEP) AND 
                                                NVL(CUR_COINTAINER_NO_DATA.UN_NUMBER,SEP) = NVL(CUR_BOOKED_LOADING_DATA.FK_UNNO,SEP)) 
                                               THEN 
                                                  l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                               ELSE 
                                                  l_v_booked_lldl_id  := NULL;
                                               END IF;
                                               
                                            END IF ;   
 
                                            -- end *52                                              
                                        END IF;
                                    ELSE
                                        L_V_BOOKED_LLDL_ID  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                    END IF;
                                    /* *33 end * */

                                    -- l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID; -- *33

                                END IF;


                        ELSIF CUR_BOOKED_LOADING_DATA.DN_EQ_SIZE                 = CUR_COINTAINER_NO_DATA.EQ_SIZE
                            AND CUR_BOOKED_LOADING_DATA.DN_EQ_TYPE               = CUR_COINTAINER_NO_DATA.EQ_TYPE
                            AND CUR_BOOKED_LOADING_DATA.DN_FULL_MT               = CUR_COINTAINER_NO_DATA.FULL_MT
                            AND CUR_BOOKED_LOADING_DATA.LOCAL_STATUS             = CUR_COINTAINER_NO_DATA.LOCAL_STATUS
                            -- AND CUR_BOOKED_LOADING_DATA.FK_SLOT_OPERATOR         = CUR_COINTAINER_NO_DATA.SLOT_OPERATOR -- logic moved, 20.02.2012
                            AND CUR_BOOKED_LOADING_DATA.DN_SPECIAL_HNDL          = CUR_COINTAINER_NO_DATA.SPECIAL_HANDLING
                            AND CUR_BOOKED_LOADING_DATA.DN_DISCHARGE_TERMINAL    = CUR_COINTAINER_NO_DATA.POD_TERMINAL
                            AND CUR_BOOKED_LOADING_DATA.DN_DISCHARGE_PORT        = CUR_COINTAINER_NO_DATA.DISCHARGE_PORT
                            /* *28 start * */
                            AND ((L_V_PORT = C_SGSIN
                                    AND (NVL(CUR_BOOKED_LOADING_DATA.FK_PORT_CLASS, SEP) = NVL(CUR_COINTAINER_NO_DATA.PORT_CLASS, SEP)))
                                OR L_V_PORT <> C_SGSIN)
                            /* *28 end * */

                            -- AND CUR_BOOKED_LOADING_DATA.FK_CONTAINER_OPERATOR    = CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR -- logic moved, 20.02.2012

                            /*
                                Start modifiy by vikas, for ex_mlo_vessel match, 21.12.2011
                                * Modified, 22.12.2011 if booking is feeder cargo
                                no need to check ex-mlo vessel voyage
                            */

                            /*
                                *5: Modify by vikas, When Equipment* is not null and same as overlanded table container then
                                no need to check ex-mlo_vessel and ex_mlo_voyage, as k'chatgamol, 05.03.2012
                            */

                            /*
                                *9: Modify by vikas, No need to check ex-mlo-vessel, as k'chatgamol, 08.03.2012
                            */
                            AND (
                                (
                                    (
                                        (CUR_BOOKED_LOADING_DATA.DN_BKG_TYP = 'FC')
                                            OR  -- *5
                                        ((CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NOT NULL) AND  -- *5
                                         (CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO))
                                         -- *5
                                    )
                                )
                                OR (
                                        (
                                            -- CUR_COINTAINER_NO_DATA.EX_MLO_VOYAGE || CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL IS NULL -- *9
                                            (
                                                (CUR_COINTAINER_NO_DATA.EX_MLO_VOYAGE IS NULL) -- *9
                                                AND                                                  -- * 27
                                                ( CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR <> 'MAE' -- * 27
                                                    OR CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL IS NULL) -- * 27
                                            )
                                        )
                                        OR (
                                                (
                                                    (CUR_COINTAINER_NO_DATA.EX_MLO_VOYAGE =  CUR_BOOKED_LOADING_DATA.EX_MLO_VOYAGE)
                                                    AND                                                         -- * 27
                                                    (CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR <> 'MAE'         -- * 27
                                                        OR                                                      -- * 27
                                                        INSTR(REPLACE(CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL, ' ', ''), CUR_BOOKED_LOADING_DATA.EX_MLO_VESSEL) > 0 -- *27
                                                    ) -- *27
                                                )
                                            -- AND (  -- *9
                                            --    INSTR(REPLACE(CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL, ' ', ''), CUR_BOOKED_LOADING_DATA.EX_MLO_VESSEL) > 0  -- *4  -- *9
                                            -- ) -- *9
                                        )
                                    )
                                )
                            THEN
                            /*
                                End modified by vikas, 21.12.2011
                            */

                            /*
                                Block start by vikas to check if booking no* came from EDI
                                then check if the booking * is exists in booked table
                                then match that booking*, only for soc case, k'chatgamol, 01.02.2012
                            */
                                l_v_soc_rcl := 'Y' ;

                            IF CUR_COINTAINER_NO_DATA.BOOKING_NO IS NULL THEN
                                IF CUR_BOOKED_LOADING_DATA.LOADING_STATUS = 'BK'
                                 -- AND  -- Modified by vikas, equipment* should be null or same as edi equipment*, as k'chatgamol, 14.02.2012
                                    -- ((CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL) OR
                                    -- (CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO))
                                    THEN
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                END IF;
                            ELSE
                                IF (CUR_BOOKED_LOADING_DATA.LOADING_STATUS = 'BK'
                                    AND (NVL(CUR_COINTAINER_NO_DATA.BOOKING_NO,'*') = NVL(CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO,'*') )
                                    )
                                    THEN
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID;
                                END IF;
                            END IF;

                            /*
                                Block end by vikas, 01.02.2012
                            */

                            /*
                                Block started by vikas to check if booked table slot operator is not 'RCL' or 'BLANK' then
                                check with slot operator otherwise match with contaienr operator, k'chatgamol, 20.02.2012
                            */
                            IF CUR_BOOKED_LOADING_DATA.FK_SLOT_OPERATOR != 'RCL' AND CUR_BOOKED_LOADING_DATA.FK_SLOT_OPERATOR IS NOT NULL THEN

                                /* *32 start * */
                                IF CUR_BOOKED_LOADING_DATA.FK_SLOT_OPERATOR = 'OOL' THEN

                                    IF ((CUR_BOOKED_LOADING_DATA.FK_SLOT_OPERATOR != CUR_COINTAINER_NO_DATA.SLOT_OPERATOR) OR
                                        (CUR_BOOKED_LOADING_DATA.FK_CONTAINER_OPERATOR != CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR))
                                    THEN
                                        l_v_booked_lldl_id  :=  NULL; -- matching failed
                                    END IF;

                                ELSE
                                    IF CUR_BOOKED_LOADING_DATA.FK_SLOT_OPERATOR         != CUR_COINTAINER_NO_DATA.SLOT_OPERATOR THEN
                                        l_v_booked_lldl_id  :=  NULL; -- matching failed
                                    END IF;
                                END IF;

                                -- IF CUR_BOOKED_LOADING_DATA.FK_SLOT_OPERATOR         != CUR_COINTAINER_NO_DATA.SLOT_OPERATOR THEN
                                --     l_v_booked_lldl_id  :=  NULL; -- matching failed
                                -- END IF;

                                /* *32 end * */

                            ELSE
                                IF CUR_BOOKED_LOADING_DATA.FK_CONTAINER_OPERATOR    != CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR THEN
                                    l_v_booked_lldl_id  :=  NULL; -- matching failed
                                END IF;
                            END IF;
                            /*
                                Block ended by vikas , 20.02.2012
                            */
                        /*-- start #51
                        ELSE
                            -- error
                            --String x = EQUIPMENT_NO~DN_EQ_SIZE~DN_EQ_TYPE
                            l_v_err_code := 'MC017';
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , p_i_n_load_list_id
                                , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                , NULL
                                , NULL
                                , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                , l_v_err_code
                                , g_v_user
                                , 'MC017_01'
                            );

                            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_err_code||SEP||l_v_list_type||SEP||CUR_COINTAINER_NO_DATA.BOOKING_NO||SEP||CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                          , 'MC017_01'
                                          , null
                                          , CUR_COINTAINER_NO_DATA.FLAG_SOC_COC
                                            ||' '||CUR_BOOKED_LOADING_DATA.DN_EQ_SIZE
                                            ||'<>'||CUR_COINTAINER_NO_DATA.EQ_SIZE
                                            ||' '||CUR_BOOKED_LOADING_DATA.DN_EQ_TYPE
                                            ||'<>'||CUR_COINTAINER_NO_DATA.EQ_TYPE
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE
                                          ,g_v_user
                                          , SYSDATE
                                            );
                          -- end #51*/
                        END IF;-----------------------------------IF OF CONDITIONS IN SOC-RCL
                   /*-- start #51
                    ELSE
                            -- error
                            --String x = EQUIPMENT_NO~DN_EQ_SIZE~DN_EQ_TYPE
                            l_v_err_code := 'MC018';
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , p_i_n_load_list_id
                                , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                , NULL
                                , NULL
                                , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );
                     -- end #51*/
                    END IF;--------------------- IF OF COC AND SOC

                    IF l_v_booked_lldl_id IS NOT NULL THEN
                        --Means we got the excat booking in matching. So update the details
                        g_v_sql_id := 'SQL-01006';
                        /*Leena 17.01.2012: If size type matches, check whether there the equipment no already exists in the booked tab
                        If exists do not go for match update - Begin 1*/
                        IF  CUR_BOOKED_LOADING_DATA.DN_EQ_SIZE = CUR_COINTAINER_NO_DATA.EQ_SIZE
                            AND CUR_BOOKED_LOADING_DATA.DN_EQ_TYPE = CUR_COINTAINER_NO_DATA.EQ_TYPE
                             -- AND CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL  THEN
                             AND (CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO IS NULL OR
                                 CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DATA.EQUIPMENT_NO) THEN
                                L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'Y';
                        ELSE
                                L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'N';
                        END IF;


                        /*Leena 17.01.2012: If size type matches, check whether there the equipment no already exists in the booked tab
                        If exists do not go for match update - End 1*/
                        IF(L_V_SZE_TYP_EQPNO_CORECT_FLAG = 'Y') THEN -- Leena 17.01.2012
                            G_V_DELETE_FLAG := 'Y'; -- added by vikas, 06.12.2011
                            L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'N';
                            /*
                            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                l_parameter_str1
                                , 'Match Log 1'
                                , g_v_opr_type
                                , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                , 'A'
                                ,g_v_user
                                , SYSDATE
                                ,g_v_user
                                , SYSDATE
                            );

                            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                l_parameter_str2
                                , 'Match Log 2'
                                , g_v_opr_type
                                , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                , 'A'
                                ,g_v_user
                                , SYSDATE
                                ,g_v_user
                                , SYSDATE
                            );

                            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                l_parameter_str3
                                , 'Match Log 3'
                                , g_v_opr_type
                                , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                , 'A'
                                ,g_v_user
                                , SYSDATE
                                ,g_v_user
                                , SYSDATE
                            );
                            */

                            /*
                                *2: Block added by vikas, 02.03.2012,
                                To check duplicate equipment
                            */

                            PRE_CHECK_DUPLICATE_CONTAINER (
                                  CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                , p_i_n_load_list_id
                                , 'L'
                                , l_v_booked_lldl_id
                                , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DATA.EQ_SIZE
                                , CUR_COINTAINER_NO_DATA.EQ_TYPE
                                , CUR_BOOKED_LOADING_DATA.DN_EQUIPMENT_NO
                                , l_v_booked_lldl_id   -- output load list id
                                , p_o_v_return_status
                            );

                            /*
                                Old logic

                                Return '1' when duplicate container found.
                            *
                            PRE_CHECK_DUPLICATE_CONTAINER (
                                  CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                , p_i_n_load_list_id
                                , 'L'
                                , l_v_booked_lldl_id
                                , p_o_v_return_status
                            );

                            /*
                                Block ended by vikas, 02.03.2012
                            */

                            IF (p_o_v_return_status = '2' ) THEN -- *2
                                /*
                                    Duplicate container found in booked table.
                                */
                                p_o_v_return_status := '0';
                                /*-- start #51
                                l_v_err_code := 'MC023';
                                PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );

                                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_err_code||SEP||l_v_list_type||SEP||CUR_COINTAINER_NO_DATA.BOOKING_NO||SEP||CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                          , 'EXIT'
                                          , null
                                          , 'EXIT from PRE_CHECK_DUPLICATE_CONTAINER'
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE
                                          ,g_v_user
                                          , SYSDATE
                                            );
                               -- end #51 */
                                EXIT; -- duplicate container found no need to check this equipment
                            ELSIF (p_o_v_return_status = '1' ) THEN-- *2

                                p_o_v_return_status := '0';
                               /*-- start #51
                                l_v_err_code := 'MC017';
                                PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , 'MC017_02'
                                );
                            -- end #51*/
                            END IF; -- End of Error status if block
                            p_o_v_return_status := '0';

                            BEGIN
                            /*-- start #51
                                l_v_err_code := 'MCP02';
                                PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );

	 /*-- VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 CALING LLDL_MATCH_UDATE FOR LOADLIST IN COMMON_MATCHING'
                                                   ,'START : ' || SYSDATE
                                                   ); --*/
                                   -- end #51 */
                               PRE_TOS_LLDL_MATCH_UPDATE('LL'
                                                        , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                                        , CUR_COINTAINER_NO_DATA.OVERHEIGHT_CM
                                                        , CUR_COINTAINER_NO_DATA.OVERLENGTH_REAR_CM
                                                        , CUR_COINTAINER_NO_DATA.OVERLENGTH_FRONT_CM
                                                        , CUR_COINTAINER_NO_DATA.OVERWIDTH_LEFT_CM
                                                        , CUR_COINTAINER_NO_DATA.OVERWIDTH_RIGHT_CM
                                                        , CUR_COINTAINER_NO_DATA.UN_NUMBER
                                                        , CUR_COINTAINER_NO_DATA.UN_NUMBER_VARIANT
                                                        , CUR_COINTAINER_NO_DATA.FLASHPOINT
                                                        , CUR_COINTAINER_NO_DATA.FLASHPOINT_UNIT
                                                        , CUR_COINTAINER_NO_DATA.IMDG_CLASS
                                                        , CUR_COINTAINER_NO_DATA.REEFER_TEMPERATURE
                                                        , CUR_COINTAINER_NO_DATA.REEFER_TMP_UNIT
                                                        , CUR_COINTAINER_NO_DATA.HUMIDITY
                                                        , CUR_COINTAINER_NO_DATA.VENTILATION
                                                        , CUR_COINTAINER_NO_DATA.PORT_CLASS
                                                        , CUR_COINTAINER_NO_DATA.PORT_CLASS_TYPE
                                                        , NULL
                                                        , NULL
                                                        , l_v_booked_lldl_id --CUR_BOOKED_LOADING_DATA.PK_BOOKED_LOADING_ID
                                                        , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                                        , CUR_BOOKED_LOADING_DATA.EQUIPMENT_SEQ_NO
                                                        , CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO
                                                        , CUR_COINTAINER_NO_DATA.CONTAINER_GROSS_WEIGHT
                                                        , CUR_COINTAINER_NO_DATA.VGM    --*49
                                                        , CUR_COINTAINER_NO_DATA.STOWAGE_POSITION
                                                        , CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR
                                                        , CUR_COINTAINER_NO_DATA.PREADVICE_FLAG
                                                        , p_i_n_load_list_id
                                                        , CUR_COINTAINER_NO_DATA.MIDSTREAM_HANDLING_CODE
                                                        , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_1 -- *10
                                                        , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_2 -- *10
                                                        , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_3 -- *10
                                                        , CUR_COINTAINER_NO_DATA.ACTIVITY_DATE_TIME -- *29
                                                        , CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL -- *36
                                                        , CUR_COINTAINER_NO_DATA.EX_MLO_VOYAGE -- *36
                                                        , p_o_v_return_status );

	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER  CALING LLDL_MATCH_UDATE FOR LOADLIST IN COMMON_MATCHING'
                                                   ,'END : ' || SYSDATE
                                                   ); --*/

                            l_arr_var_name := STRING_ARRAY
                           ('p_i_n_list_type'                , 'p_i_v_equipment_no'              , 'p_i_n_overheight'
                          , 'p_i_n_overlength_rear'          , 'p_i_n_overlength_front'          , 'p_i_n_overwidth_left'
                          , 'p_i_n_overwidth_right'          , 'p_i_v_unno'                      , 'p_i_v_un_var'
                          , 'p_i_v_flash_point'              , 'p_i_n_flash_unit'                , 'p_i_v_imdg'
                          , 'p_i_n_reefer_tmp'               , 'p_i_v_reefer_tmp_unit'           , 'p_i_n_humidity'
                          , 'p_i_n_ventilation'              , 'p_i_v_port_class'                , 'p_i_v_portclass_type'
                          , 'p_i_n_discharge_id'             , 'p_i_n_overlanded_container_id'   , 'p_i_n_booked_load_id'
                          , 'p_i_n_overshipped_container_id' , 'p_i_n_equipment_seq_no'          , 'p_i_v_booking_no'
                          , 'p_i_n_gross_wt'                 , 'p_i_v_stowage_position'          , 'p_i_v_container_operator'
                          , 'p_i_v_preadvice_flg'
                          , 'p_o_v_return_status'
                            );

                            l_arr_var_value := STRING_ARRAY
                           ('LL'                                        , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO          , CUR_COINTAINER_NO_DATA.OVERHEIGHT_CM
                          , CUR_COINTAINER_NO_DATA.OVERLENGTH_REAR_CM   , CUR_COINTAINER_NO_DATA.OVERLENGTH_FRONT_CM   , CUR_COINTAINER_NO_DATA.OVERWIDTH_LEFT_CM
                          , CUR_COINTAINER_NO_DATA.OVERWIDTH_RIGHT_CM   , CUR_COINTAINER_NO_DATA.UN_NUMBER             , CUR_COINTAINER_NO_DATA.UN_NUMBER_VARIANT
                          , CUR_COINTAINER_NO_DATA.FLASHPOINT           , CUR_COINTAINER_NO_DATA.FLASHPOINT_UNIT       , CUR_COINTAINER_NO_DATA.IMDG_CLASS
                          , CUR_COINTAINER_NO_DATA.REEFER_TEMPERATURE   , CUR_COINTAINER_NO_DATA.REEFER_TMP_UNIT       , CUR_COINTAINER_NO_DATA.HUMIDITY
                          , CUR_COINTAINER_NO_DATA.VENTILATION          , CUR_COINTAINER_NO_DATA.PORT_CLASS            , CUR_COINTAINER_NO_DATA.PORT_CLASS_TYPE
                          , NULL                                        , NULL                                         , l_v_booked_lldl_id
                          , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID  , CUR_BOOKED_LOADING_DATA.EQUIPMENT_SEQ_NO   , CUR_BOOKED_LOADING_DATA.FK_BOOKING_NO
                          , CUR_COINTAINER_NO_DATA.CONTAINER_GROSS_WEIGHT       , CUR_COINTAINER_NO_DATA.STOWAGE_POSITION    , CUR_COINTAINER_NO_DATA.CONTAINER_OPERATOR
                          , CUR_COINTAINER_NO_DATA.PREADVICE_FLAG
                          , p_o_v_return_status
                            );

                            l_arr_var_io := STRING_ARRAY
                           ('I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'
                          , 'O'
                            );
/*-- *50 remove logging
                            PRE_LOG_INFO
                            ('PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING'
                           , 'PRE_TOS_LLDL_MATCH_UPDATE'
                           , g_v_sql_id
                           , g_v_user
                           , l_t_log_info
                           , NULL
                           , l_arr_var_name
                           , l_arr_var_value
                           , l_arr_var_io
                            ); --*/

                                IF p_o_v_return_status = '1' THEN

                                    /* vikas: start adding against bug* 588, on 19.10.2011 */
                                    /*Error occurred in LL-DL matching update.*/

                                 /*-- start #51
                                    l_v_err_code := 'MC011';
                                    PRE_TOS_ERROR_LOG(
                                          l_v_list_type
                                        , p_i_n_load_list_id
                                        , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                        , NULL
                                        , NULL
                                        , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                        , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                        , l_v_err_code
                                        , g_v_user
                                        , g_v_user
                                    );
                                    -- #51 */
                                    /* vikas: end adding against bug* 588, on 19.10.2011 */
                                    g_v_err_code   := TO_CHAR(SQLCODE);
                                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                                    RAISE l_exce_main;
                                /*-- start #31
                                ELSE
                                    l_v_err_code := 'MCP03';
                                    PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                                -- end #51*/
                                END IF;
                                /*
                                    Start added loop should exit after successful match, 14.02.2012
                                */

                                /*
                                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_err_code||SEP||l_v_list_type||SEP||CUR_COINTAINER_NO_DATA.BOOKING_NO||SEP||CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                          , 'EXIT'
                                          , null
                                          , 'EXIT from PRE_TOS_LLDL_MATCH_UPDATE'
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE
                                          ,g_v_user
                                          , SYSDATE
                                            );
                                */
                                EXIT;

                                /*
                                    End added by vikas, 14.02.2012
                                */

                            EXCEPTION
                                WHEN OTHERS THEN
                                    g_v_err_code   := TO_CHAR(SQLCODE);
                                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                                    RAISE l_exce_main;
                            END;
                        END IF; --Leena 17.01.2012
                        -- EXIT ; -- commented by vikas, loop should not exist after getting load list id.
                                -- loop should exit after the matching successfully done, vikas, 14.02.2012
                    END IF;-----------------------END IF OF l_v_booked_lldl_id IS NOT NULL
                    END IF; -- END IF OF CUR_COINTAINER_NO_DATA.TRADING_PARTNER <> 'VERMAS'
                END LOOP;

                L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'N'; --Leena 17.01.2012
                ----------- ----------------CALL AUTOEXPAND-----------------------
                IF (l_v_booked_lldl_id IS NULL) AND (l_v_coc_empty  = 'Y' OR l_v_soc_rcl = 'Y' ) THEN
                    --Means matching is done  but not with booked status.In this case call autoexpand

                    g_v_sql_id := 'SQL-01007';

                    --Added by Bindu on 02/03/2010 for calling autoexpand and insert data into Autoexpand lunch table.
                    BEGIN
                    /*-- start #51
                        l_v_err_code := 'MCP04';
                        PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                     -- end #51 */

                        PCE_TOS_TEMP_AUTOMATCH(cur_cointainer_no_data.FK_LOAD_LIST_ID
                                    , cur_cointainer_no_data.PK_OVERSHIPPED_CONTAINER_ID
                                    , cur_cointainer_no_data.BOOKING_NO
                                    , cur_cointainer_no_data.EQUIPMENT_NO
                                    , p_o_v_return_status
                                     );

                        l_arr_var_name := STRING_ARRAY
                        ('p_i_n_load_list_id'                , 'p_i_n_overshipped_contained_id'
                        , 'p_i_n_bk_no'                       , 'p_i_n_equip_no'
                        , 'p_o_v_return_status'
                        );

                        l_arr_var_value := STRING_ARRAY
                        ( cur_cointainer_no_data.FK_LOAD_LIST_ID             , cur_cointainer_no_data.PK_OVERSHIPPED_CONTAINER_ID
                        , cur_cointainer_no_data.BOOKING_NO                  , cur_cointainer_no_data.EQUIPMENT_NO
                        , p_o_v_return_status
                        );

                        l_arr_var_io := STRING_ARRAY
                        ('I'      , 'I'
                        , 'I'      , 'I'
                        , 'O'
                        );
/*--*50 remove logging
                        PRE_LOG_INFO
                        ('PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING'
                        , 'PCE_TOS_TEMP_AUTOMATCH'
                        , g_v_sql_id
                        , g_v_user
                        , l_t_log_info
                        , NULL
                        , l_arr_var_name
                        , l_arr_var_value
                        , l_arr_var_io
                        ); --*/

                        IF p_o_v_return_status = '1' THEN
                            /* vikas: start adding against bug* 588, on 19.10.2011 */
                            /* Error occurred in automatch. */

                         /*--start #51
                            l_v_err_code := 'MC013';
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , p_i_n_load_list_id
                                , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                , NULL
                                , NULL
                                , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );
                            /* vikas: end adding against bug* 588, on 19.10.2011 */
                            --end #51 */
                            g_v_err_code   := TO_CHAR(SQLCODE);
                            g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                            -- RAISE l_exce_main; vikas 06.12.2011 continue execution next record
                        /*-- start #51
                        ELSE
                            l_v_err_code := 'MCP05';
                            PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                         -- end #51*/
                        END IF;
                    EXCEPTION
                    WHEN OTHERS THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        -- RAISE l_exce_main;
                    END;



                    g_v_sql_id := 'SQL-01008';
                    BEGIN
                    /*-- start #51
                        l_v_err_code := 'MCP06';
                        PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                         -- end #51*/

                        PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_AUTOEXPAND(cur_cointainer_no_data.PK_OVERSHIPPED_CONTAINER_ID
                                                         , cur_cointainer_no_data.BOOKING_NO
                                                         , cur_cointainer_no_data.EQUIPMENT_NO
                                                         , cur_cointainer_no_data.EQ_SIZE
                                                         , cur_cointainer_no_data.EQ_TYPE
                                                         , p_o_v_return_status
                                                          );

                        l_arr_var_name := STRING_ARRAY
                        ('p_i_n_over_shipped_id'                , 'p_i_v_booking_no'
                        , 'p_i_v_equipment_no'                   , 'p_i_v_equipment_size'
                        , 'p_i_v_equipment_type'                 , 'p_o_v_return_status'
                        );

                        l_arr_var_value := STRING_ARRAY
                        ( cur_cointainer_no_data.PK_OVERSHIPPED_CONTAINER_ID   , cur_cointainer_no_data.BOOKING_NO
                        , cur_cointainer_no_data.EQUIPMENT_NO                  , cur_cointainer_no_data.EQ_SIZE
                        , cur_cointainer_no_data.EQ_TYPE                       , p_o_v_return_status
                        );

                        l_arr_var_io := STRING_ARRAY
                        ('I'      , 'I'      , 'I'
                        , 'I'      , 'I'      , 'O'
                        );
/*-- *50 remove logging
                        PRE_LOG_INFO
                        ('PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING'
                        , 'PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_AUTOEXPAND'
                        , g_v_sql_id
                        , g_v_user
                        , l_t_log_info
                        , NULL
                        , l_arr_var_name
                        , l_arr_var_value
                        , l_arr_var_io
                        ); --*/

                        IF p_o_v_return_status = '1' THEN

                            -- vikas: start adding against bug* 588, on 19.10.2011
                            -- Error occurred in autoexpand.
                            /*-- start #51
                            l_v_err_code := 'MC014';
                            PRE_TOS_ERROR_LOG(
                            l_v_list_type
                            , p_i_n_load_list_id
                            , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                            , NULL
                            , NULL
                            , CUR_COINTAINER_NO_DATA.BOOKING_NO
                            , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                            );
                            -- end #51 */
                            -- vikas: end adding against bug* 588, on 19.10.2011
                            g_v_err_code   := TO_CHAR(SQLCODE);
                            g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                            -- RAISE l_exce_main; continue execution when autoexpand fails., 06.12.2011
                       /*-- start #51
                        ELSE -- else of error status

                            --Auto expand called for this equipment no*
                            --The booking found for coc empty or soc container in booked table,
                            --but the equipment number is not blank

                            l_v_err_code := 'MC019';

                            PRE_TOS_ERROR_LOG(
                            l_v_list_type
                            , p_i_n_load_list_id
                            , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                            , NULL
                            , NULL
                            , CUR_COINTAINER_NO_DATA.BOOKING_NO
                            , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                            );
                            -- vikas: end adding, on 06.12.2011

                            l_v_err_code := 'MCP07';
                            PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_load_list_id
                                    , CUR_COINTAINER_NO_DATA.PK_OVERSHIPPED_CONTAINER_ID
                                    , NULL
                                    , NULL
                                    , CUR_COINTAINER_NO_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                         -- end #51 */
                        END IF; -- end of error code if.
                    EXCEPTION
                    WHEN OTHERS THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        -- RAISE l_exce_main;  -- commented by vikas, 06.12.2011
                    END;



                END IF;
              --END IF;-- END IF CHECKING FOR TRADING_PARTNER <> VERMAS
                --End by Bindu on 02/03/2010 for calling autoexpand and insert data into Autoexpand lunch table.
            END IF;--------------END IF OF MATCHING NOT DONE CONTAINER BY CONTAINER
        END IF;

        l_v_booked_lldl_id := NULL;
        l_v_cont_exst := 'N';
        l_v_coc_empty := 'N';
        l_v_soc_rcl   := 'N';
        L_V_COC_FUL   := 'N';
        L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'N'; -- Leena 17.01.2012
    END LOOP;--End of main loop CUR_COINTAINER_NO_LL

    l_v_booked_lldl_id := NULL;
    l_v_cont_exst := 'N';
    l_v_coc_empty := 'N';
    l_v_soc_rcl   := 'N';
    l_v_coc_ful   := 'N';

    FOR CUR_COINTAINER_NO_DL_DATA IN CUR_COINTAINER_NO_DL
    LOOP
        /* Start added by vikas on 29/08/2011 to delete data from overshipped tab for status loaded*/
        g_v_sql_id := 'SQL-01008A';

        BEGIN
            SELECT COUNT(1)
            INTO l_n_rec_count
            FROM TOS_DL_BOOKED_DISCHARGE
            WHERE NVL(DN_EQUIPMENT_NO,'*') = CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
            AND FK_DISCHARGE_LIST_ID = p_i_n_discharge_list_id
            AND DISCHARGE_STATUS = 'DI'
            AND RECORD_STATUS = 'A'; -- *19

            IF l_n_rec_count > 0 THEN
               l_v_rec_found := 'Y';
            ELSE
               l_v_rec_found := 'N';
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            RAISE l_exce_main;
        END;

        l_t_log_info := SYSDATE; -- CURRENT_TIMESTAMP; --*24

        g_v_sql_id := 'SQL-01008B';
        BEGIN

            IF(l_v_rec_found = 'Y') THEN
                /* vikas: start adding against bug* 588, on 19.10.2011 */
                /* Booking is already available in overlanded tab with discharge status.*/
                /*-- start #51
                l_v_err_code := 'MC002';
                PRE_TOS_ERROR_LOG(
                      l_v_list_type
                    , NULL
                    , NULL
                    , p_i_n_discharge_list_id
                    , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                    , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                    , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                    , l_v_err_code
                    , g_v_user
                    , g_v_user
                );
                /* vikas: end adding against bug* 588, on 19.10.2011 */
                -- end #51  */
                DELETE FROM TOS_DL_OVERLANDED_CONTAINER
                WHERE NVL(EQUIPMENT_NO,'*') = CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                AND FK_DISCHARGE_LIST_ID = p_i_n_discharge_list_id;

            END IF;

        EXCEPTION
        WHEN OTHERS THEN
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            RAISE l_exce_main;
        END;
        /* End added by vikas on 29/08/2011 to delete data from overshipped tab for status loaded*/

        IF l_v_rec_found = 'N' THEN -- added by vikas
            l_v_cont_exst := 'N';
            /*
                Commented by vikas, no need this loop because in next loop check equipmnet no* null or not, k'sukit, 16.02.2012
            *
           FOR CUR_BOOKED_DISCHARGE_DATA IN CUR_BOOKED_DISCHARGE(CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO,NVL(p_i_n_discharge_list_id,CUR_COINTAINER_NO_DL_DATA.FK_DISCHARGE_LIST_ID))

                 LOOP
                 l_v_cont_exst := 'Y';
                      g_v_sql_id := 'SQL-01009';

                       BEGIN
                        g_v_delete_flag := 'Y'; -- added by vikas, 06.12.2011
                          PRE_TOS_LLDL_MATCH_UPDATE('DL'
                                                  , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                                  , CUR_COINTAINER_NO_DL_DATA.OVERHEIGHT_CM
                                                  , CUR_COINTAINER_NO_DL_DATA.OVERLENGTH_REAR_CM
                                                  , CUR_COINTAINER_NO_DL_DATA.OVERLENGTH_FRONT_CM
                                                  , CUR_COINTAINER_NO_DL_DATA.OVERWIDTH_LEFT_CM
                                                  , CUR_COINTAINER_NO_DL_DATA.OVERWIDTH_RIGHT_CM
                                                  , CUR_COINTAINER_NO_DL_DATA.UN_NUMBER
                                                  , CUR_COINTAINER_NO_DL_DATA.UN_NUMBER_VARIANT
                                                  , CUR_COINTAINER_NO_DL_DATA.FLASHPOINT
                                                  , CUR_COINTAINER_NO_DL_DATA.FLASHPOINT_UNIT
                                                  , CUR_COINTAINER_NO_DL_DATA.IMDG_CLASS
                                                  , CUR_COINTAINER_NO_DL_DATA. REEFER_TEMPERATURE
                                                  , CUR_COINTAINER_NO_DL_DATA.REEFER_TMP_UNIT
                                                  , CUR_COINTAINER_NO_DL_DATA.HUMIDITY
                                                  , CUR_COINTAINER_NO_DL_DATA.VENTILATION
                                                  , CUR_COINTAINER_NO_DL_DATA.PORT_CLASS
                                                  , CUR_COINTAINER_NO_DL_DATA.PORT_CLASS_TYP
                                                  , CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID
                                                  , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                                                  , NULL
                                                  , NULL
                                                  , CUR_BOOKED_DISCHARGE_DATA.EQUIPMENT_SEQ_NO
                                                  , CUR_BOOKED_DISCHARGE_DATA.FK_BOOKING_NO
                                                  , CUR_COINTAINER_NO_DL_DATA.CONTAINER_GROSS_WEIGHT
                                                  , CUR_COINTAINER_NO_DL_DATA.STOWAGE_POSITION
                                                  , CUR_COINTAINER_NO_DL_DATA.CONTAINER_OPERATOR
                                                  , NULL
                                                  , p_i_n_discharge_list_id
                                                  , CUR_COINTAINER_NO_DL_DATA.MIDSTREAM_HANDLING_CODE
                                                  , p_o_v_return_status );

                            l_arr_var_name := STRING_ARRAY
                           ('p_i_n_list_type'                , 'p_i_v_equipment_no'              , 'p_i_n_overheight'
                          , 'p_i_n_overlength_rear'          , 'p_i_n_overlength_front'          , 'p_i_n_overwidth_left'
                          , 'p_i_n_overwidth_right'          , 'p_i_v_unno'                      , 'p_i_v_un_var'
                          , 'p_i_v_flash_point'              , 'p_i_n_flash_unit'                , 'p_i_v_imdg'
                          , 'p_i_n_reefer_tmp'               , 'p_i_v_reefer_tmp_unit'           , 'p_i_n_humidity'
                          , 'p_i_n_ventilation'              , 'p_i_v_port_class'                , 'p_i_v_portclass_type'
                          , 'p_i_n_discharge_id'             , 'p_i_n_overlanded_container_id'   , 'p_i_n_booked_load_id'
                          , 'p_i_n_overshipped_container_id' , 'p_i_n_equipment_seq_no'          , 'p_i_v_booking_no'
                          , 'p_i_n_gross_wt'                 , 'p_i_v_stowage_position'          , 'p_i_v_container_operator'
                          , 'p_i_v_preadvice_flg'
                          , 'p_o_v_return_status'
                            );

                            l_arr_var_value := STRING_ARRAY
                           ('DL'                  ,  CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO            , CUR_COINTAINER_NO_DL_DATA.OVERHEIGHT_CM
                           , CUR_COINTAINER_NO_DL_DATA.OVERLENGTH_REAR_CM                              , CUR_COINTAINER_NO_DL_DATA.OVERLENGTH_FRONT_CM
                           , CUR_COINTAINER_NO_DL_DATA.OVERWIDTH_LEFT_CM                               , CUR_COINTAINER_NO_DL_DATA.OVERWIDTH_RIGHT_CM
                           , CUR_COINTAINER_NO_DL_DATA.UN_NUMBER                                       , CUR_COINTAINER_NO_DL_DATA.UN_NUMBER_VARIANT
                           , CUR_COINTAINER_NO_DL_DATA.FLASHPOINT                                      , CUR_COINTAINER_NO_DL_DATA.FLASHPOINT_UNIT
                           , CUR_COINTAINER_NO_DL_DATA.IMDG_CLASS                                      , CUR_COINTAINER_NO_DL_DATA. REEFER_TEMPERATURE
                           , CUR_COINTAINER_NO_DL_DATA.REEFER_TMP_UNIT                                 , CUR_COINTAINER_NO_DL_DATA.HUMIDITY
                           , CUR_COINTAINER_NO_DL_DATA.VENTILATION                                     , CUR_COINTAINER_NO_DL_DATA.PORT_CLASS
                           , CUR_COINTAINER_NO_DL_DATA.PORT_CLASS_TYP                                  , CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID
                           , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID                      , NULL
                           , NULL                                                                      , CUR_BOOKED_DISCHARGE_DATA.EQUIPMENT_SEQ_NO
                           , CUR_BOOKED_DISCHARGE_DATA.FK_BOOKING_NO                                   , CUR_COINTAINER_NO_DL_DATA.CONTAINER_GROSS_WEIGHT
                           , CUR_COINTAINER_NO_DL_DATA.STOWAGE_POSITION                                , CUR_COINTAINER_NO_DL_DATA.CONTAINER_OPERATOR
                           , NULL
                           , p_o_v_return_status
                            );

                            l_arr_var_io := STRING_ARRAY
                           ('I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'      , 'I'      , 'I'
                          , 'I'
                          , 'O'
                            );

                            PRE_LOG_INFO
                            ('PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING'
                           , 'PRE_TOS_LLDL_MATCH_UPDATE'
                           , g_v_sql_id
                           , g_v_user
                           , l_t_log_info
                           , NULL
                           , l_arr_var_name
                           , l_arr_var_value
                           , l_arr_var_io
                            );

                       IF p_o_v_return_status = '1' THEN
                            /* vikas: start adding against bug* 588, on 19.10.2011 */
                            /*Error occurred in LL-DL matching update.*

                            l_v_err_code := 'MC011';
                            PRE_TOS_ERROR_LOG(
                                  l_v_list_type
                                , NULL
                                , NULL
                                , p_i_n_discharge_list_id
                                , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                                , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );
                            /* vikas: end adding against bug* 588, on 19.10.2011 *

                          g_v_err_code   := TO_CHAR(SQLCODE);
                          g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                          RAISE l_exce_main;
                       END IF;
                       EXCEPTION
                          WHEN OTHERS THEN
                             g_v_err_code   := TO_CHAR(SQLCODE);
                             g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                             RAISE l_exce_main;
                       END;
                 END LOOP;
                *
                    End commented by vikas, as suggested by k'sukit and k'chatgamol, 17.02.2012
                */


            IF L_V_CONT_EXST = 'N' THEN ---MATCHING NOT DONE CONTAINER BY CONTAINER
                L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'N';--Leena 17.01.2012
                FOR CUR_BOOKED_DISCHARGE_DATA IN CUR_BOOKED_DISCHARGE('',p_i_n_discharge_list_id)
                LOOP
                    l_v_booked_lldl_id  := NULL;
                    l_v_coc_empty  := NULL ;
                    l_v_soc_rcl := NULL;
                    l_v_coc_ful := NULL;

                    /*
                        *3 Modified by vikas, to check if booking no* comming from edi then no need
                        to match with terminal, as k'myo, 21.02.2012
                    */
                    IF CUR_COINTAINER_NO_DL_DATA.FLAG_SOC_COC = 'C' AND  CUR_COINTAINER_NO_DL_DATA.FULL_MT = 'F' THEN-----COC OR SOC
                        IF  CUR_BOOKED_DISCHARGE_DATA.DN_EQ_SIZE               = CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                        AND CUR_BOOKED_DISCHARGE_DATA.DN_EQ_TYPE               = CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                        AND CUR_BOOKED_DISCHARGE_DATA.LOCAL_STATUS             = CUR_COINTAINER_NO_DL_DATA.LOCAL_STATUS
                        AND CUR_BOOKED_DISCHARGE_DATA.DN_SPECIAL_HNDL          = CUR_COINTAINER_NO_DL_DATA.SPECIAL_HANDLING
                        AND CUR_BOOKED_DISCHARGE_DATA.DN_POL                   = CUR_COINTAINER_NO_DL_DATA.POL
                        -- AND CUR_BOOKED_DISCHARGE_DATA.DN_POL_TERMINAL          = CUR_COINTAINER_NO_DL_DATA.POL_TERMINAL -- *3
                        AND CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO  IS NOT NULL -- Added 17.02.2012
                        AND CUR_BOOKED_DISCHARGE_DATA.DN_FULL_MT               = CUR_COINTAINER_NO_DL_DATA.FULL_MT
                        AND CUR_BOOKED_DISCHARGE_DATA.DN_SOC_COC               = CUR_COINTAINER_NO_DL_DATA.FLAG_SOC_COC
                        AND (CUR_COINTAINER_NO_DL_DATA.REEFER_FLG = 'N' OR
                        (CUR_BOOKED_DISCHARGE_DATA.DN_SPECIAL_HNDL = 'NR' AND CUR_COINTAINER_NO_DL_DATA.REEFER_FLG = 'Y'))
                        AND CUR_BOOKED_DISCHARGE_DATA.DISCHARGE_STATUS         = 'BK'     THEN

                            /*
                                Block Start by vikas, Join booking* also if booking number provided from EDI,  16.02.2012
                            */
                            IF CUR_COINTAINER_NO_DL_DATA.BOOKING_NO IS NULL THEN
                                -- IF CUR_BOOKED_DISCHARGE_DATA.DN_POL_TERMINAL          = CUR_COINTAINER_NO_DL_DATA.POL_TERMINAL  THEN -- *3
                                    l_v_coc_ful := 'Y';
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                                -- END IF; -- *3

                            ELSIF NVL(CUR_COINTAINER_NO_DL_DATA.BOOKING_NO,'*') = NVL(CUR_BOOKED_DISCHARGE_DATA.FK_BOOKING_NO,'*') THEN
                                l_v_coc_ful := 'Y';
                                l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                            END IF;
                            /*
                                * old logic *
                            l_v_coc_ful := 'Y';
                            l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                            */
                            /*-- start #51
                        ELSE
                            -- error
                            --String x = EQUIPMENT_NO~DN_EQ_SIZE~DN_EQ_TYPE
                            l_v_err_code := 'MC015';
                            PRE_TOS_ERROR_LOG(
                            l_v_list_type
                            , NULL
                            , NULL
                            , p_i_n_discharge_list_id
                            , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                            , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                            , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                            );

                            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_err_code||SEP||l_v_list_type||SEP||CUR_COINTAINER_NO_DL_DATA.BOOKING_NO||SEP||CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                          , 'MC015'
                                          , null
                                          , CUR_COINTAINER_NO_DL_DATA.FLAG_SOC_COC
                                            ||' '||CUR_BOOKED_DISCHARGE_DATA.DN_EQ_SIZE
                                            ||'<>'||CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                                            ||' '||CUR_BOOKED_DISCHARGE_DATA.DN_EQ_TYPE
                                            ||'<>'||CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE
                                          ,g_v_user
                                          , SYSDATE
                                            );
                        --end #51 */
                        END IF;------OF COC AND LADEN
                    ELSIF CUR_COINTAINER_NO_DL_DATA.FLAG_SOC_COC = 'C' AND  CUR_COINTAINER_NO_DL_DATA.FULL_MT = 'E' THEN
                        IF  CUR_BOOKED_DISCHARGE_DATA.FK_BOOKING_NO       = CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                        AND CUR_BOOKED_DISCHARGE_DATA.DN_EQ_SIZE          = CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                        AND CUR_BOOKED_DISCHARGE_DATA.DN_EQ_TYPE          = CUR_COINTAINER_NO_DL_DATA.EQ_TYPE THEN
                            l_v_coc_empty := 'Y' ;
                            IF CUR_BOOKED_DISCHARGE_DATA.DISCHARGE_STATUS = 'BK' AND   -- Modified by vikas, equipment* should be null or same as edi equipment*, as k'chatgamol, 14.02.2012
                                -- CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL THEN
                                ((CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL) OR
                                (CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO)) THEN

                                l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                            END IF;
                        ELSIF CUR_BOOKED_DISCHARGE_DATA.DN_POL          = CUR_COINTAINER_NO_DL_DATA.POL
                            AND CUR_BOOKED_DISCHARGE_DATA.DN_POL_TERMINAL   = CUR_COINTAINER_NO_DL_DATA.POL_TERMINAL
                            AND  CUR_BOOKED_DISCHARGE_DATA.DN_EQ_SIZE       = CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                            AND  CUR_BOOKED_DISCHARGE_DATA.DN_EQ_TYPE       = CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                            AND  CUR_BOOKED_DISCHARGE_DATA.LOCAL_STATUS     = CUR_COINTAINER_NO_DL_DATA.LOCAL_STATUS
                            AND  CUR_BOOKED_DISCHARGE_DATA.DN_SOC_COC       = CUR_COINTAINER_NO_DL_DATA.FLAG_SOC_COC  --*22
                            AND  CUR_BOOKED_DISCHARGE_DATA.DN_FULL_MT       = CUR_COINTAINER_NO_DL_DATA.FULL_MT  THEN --*22
                                l_v_coc_empty := 'Y' ;
                                IF CUR_BOOKED_DISCHARGE_DATA.DISCHARGE_STATUS = 'BK'  AND   -- Modified by vikas, equipment* should be null or same as edi equipment*, as k'chatgamol, 14.02.2012
                                    -- CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL THEN
                                    ((CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL) OR
                                    (CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO)) THEN

                                    l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                                END IF;
                        /*-- start #51
                        ELSE
                            -- error
                            --String x = EQUIPMENT_NO~DN_EQ_SIZE~DN_EQ_TYPE
                            l_v_err_code := 'MC016';
                            PRE_TOS_ERROR_LOG(
                            l_v_list_type
                            , NULL
                            , NULL
                            , p_i_n_discharge_list_id
                            , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                            , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                            , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                            );
                         --- end #51  */
                        END IF;------------------------------END IF OF 2 CONDITIONS OF COC AND EMPTY
                    ELSIF CUR_COINTAINER_NO_DL_DATA.FLAG_SOC_COC = 'S' THEN
                        IF    CUR_BOOKED_DISCHARGE_DATA.FK_BOOKING_NO       = CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                            AND CUR_BOOKED_DISCHARGE_DATA.DN_EQ_SIZE          = CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                            AND CUR_BOOKED_DISCHARGE_DATA.DN_EQ_TYPE          = CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                        THEN

                            l_v_soc_rcl := 'Y' ;
                            IF CUR_BOOKED_DISCHARGE_DATA.DISCHARGE_STATUS = 'BK'  AND   -- Modified by vikas, equipment* should be null or same as edi equipment*, as k'chatgamol, 14.02.2012
                                -- CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL THEN
                                ((CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL) OR
                                (CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO))
                            THEN

                             /* *33 start * */
                            IF  ((CUR_BOOKED_DISCHARGE_DATA.DN_SPECIAL_HNDL = 'N') OR
                                (CUR_BOOKED_DISCHARGE_DATA.DN_SPECIAL_HNDL = 'D1') OR
                                (CUR_BOOKED_DISCHARGE_DATA.DN_SPECIAL_HNDL = 'O0') )
                            THEN
                                IF (CUR_BOOKED_DISCHARGE_DATA.DN_SPECIAL_HNDL = CUR_COINTAINER_NO_DL_DATA.SPECIAL_HANDLING) then
                                    L_V_BOOKED_LLDL_ID  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                                END IF;
                            ELSE
                                L_V_BOOKED_LLDL_ID  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                            END IF;
                            /* *33 end * */
                            --l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID; -- *33

                            END IF;

                        ELSIF CUR_BOOKED_DISCHARGE_DATA.DN_EQ_SIZE             = CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                            AND CUR_BOOKED_DISCHARGE_DATA.DN_EQ_TYPE               = CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                            AND CUR_BOOKED_DISCHARGE_DATA.LOCAL_STATUS             = CUR_COINTAINER_NO_DL_DATA.LOCAL_STATUS
                            AND CUR_BOOKED_DISCHARGE_DATA.DN_FULL_MT               = CUR_COINTAINER_NO_DL_DATA.FULL_MT
                            -- AND CUR_BOOKED_DISCHARGE_DATA.FK_CONTAINER_OPERATOR    = CUR_COINTAINER_NO_DL_DATA.CONTAINER_OPERATOR -- Logic Moved, 20.02.2012
                            -- AND CUR_BOOKED_DISCHARGE_DATA.FK_SLOT_OPERATOR         = CUR_COINTAINER_NO_DL_DATA.SLOT_OPERATOR -- Logic Moved, 20.02.2012
                            AND CUR_BOOKED_DISCHARGE_DATA.DN_POL                   = CUR_COINTAINER_NO_DL_DATA.POL
                            AND CUR_BOOKED_DISCHARGE_DATA.DN_POL_TERMINAL          = CUR_COINTAINER_NO_DL_DATA.POL_TERMINAL
                            /* *28 start * */
                            AND ((L_V_PORT = C_SGSIN
                                    AND (NVL(CUR_BOOKED_DISCHARGE_DATA.FK_PORT_CLASS, SEP) = NVL(CUR_COINTAINER_NO_DL_DATA.PORT_CLASS, SEP)))
                                OR L_V_PORT <> C_SGSIN)
                            /* *28 end * */
                        THEN
                            /*
                                Block start by vikas to check if booking no* came from EDI
                                then check if the booking * is exists in booked table
                                then match that booking*, only for soc case, k'chatgamol, 01.02.2012
                            */
                            l_v_soc_rcl := 'Y' ;
                            IF CUR_COINTAINER_NO_DL_DATA.BOOKING_NO IS NULL THEN
                                IF CUR_BOOKED_DISCHARGE_DATA.DISCHARGE_STATUS = 'BK'
                                    -- AND CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL THEN
                                    AND ((CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL) OR
                                    (CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO)) THEN
                                -- THEN
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                                END IF;
                            ELSE
                                IF (CUR_BOOKED_DISCHARGE_DATA.DISCHARGE_STATUS = 'BK'
                                    AND (NVL(CUR_COINTAINER_NO_DL_DATA.BOOKING_NO,'*') = NVL(CUR_BOOKED_DISCHARGE_DATA.FK_BOOKING_NO,'*') )
                                    )
                                    THEN
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                                END IF;
                                -- END IF;

                                /*
                                    Block end by vikas, 01.02.2012
                                */
                                /*
                                BEGIN
                                SELECT
                                    PK_BOOKED_DISCHARGE_ID
                                INTO
                                    l_v_booked_lldl_id
                                FROM (
                                    SELECT
                                        PK_BOOKED_DISCHARGE_ID
                                    FROM
                                        VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
                                    WHERE
                                        BD.FK_DISCHARGE_LIST_ID = p_i_n_discharge_list_id
                                        AND CUR_COINTAINER_NO_DL_DATA.FLAG_SOC_COC = 'S'
                                        AND BD.DISCHARGE_STATUS = 'BK'
                                        AND (
                                                BD.DN_EQ_SIZE                   = CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                                                AND BD.DN_EQ_TYPE               = CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                                                AND BD.LOCAL_STATUS             = CUR_COINTAINER_NO_DL_DATA.LOCAL_STATUS
                                                AND BD.DN_FULL_MT               = CUR_COINTAINER_NO_DL_DATA.FULL_MT
                                                AND BD.FK_CONTAINER_OPERATOR    = CUR_COINTAINER_NO_DL_DATA.CONTAINER_OPERATOR
                                                AND BD.FK_SLOT_OPERATOR         = CUR_COINTAINER_NO_DL_DATA.SLOT_OPERATOR
                                                AND BD.DN_POL                   = CUR_COINTAINER_NO_DL_DATA.POL
                                                AND BD.DN_POL_TERMINAL          = CUR_COINTAINER_NO_DL_DATA.POL_TERMINAL
                                                -- AND BD.DN_EQUIPMENT_NO IS NULL  -- Modified by vikas, equipment* should be null or same as edi equipment*, as k'chatgamol, 14.02.2012
                                                AND ((BD.DN_EQUIPMENT_NO IS NULL) OR
                                                    (BD.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO))
                                                AND CUR_COINTAINER_NO_DL_DATA.BOOKING_NO = BD.FK_BOOKING_NO (+)
                                            )
                                        )
                                    WHERE
                                        ROWNUM = 1;
                                   /*
                                        Start Added by vikas for exception handling , 13.02.2012
                                    *
                                    EXCEPTION
                                        WHEN OTHERS THEN
                                            l_v_booked_lldl_id := NULL;
                                    END;
                                    /*
                                        End Added by vikas, 13.02.2012
                                    */


                            END IF; -- End if of null booking *
                            /*
                                *Old Logic *
                                l_v_soc_rcl := 'Y' ;
                                IF CUR_BOOKED_DISCHARGE_DATA.DISCHARGE_STATUS = 'BK'  AND CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL THEN
                                    l_v_booked_lldl_id  :=  CUR_BOOKED_DISCHARGE_DATA.PK_BOOKED_DISCHARGE_ID;
                                END IF;
                            */

                            /*
                                Block end by vikas, 01.02.2012
                            */

                            /*
                                Block started by vikas to check if booked table slot operator is NULL OR 'RCL' then check with
                                container operator else match with slot operator, k'chatgamol, 20.02.2012
                            */
                            IF CUR_BOOKED_DISCHARGE_DATA.FK_SLOT_OPERATOR != 'RCL' AND CUR_BOOKED_DISCHARGE_DATA.FK_SLOT_OPERATOR IS NOT NULL THEN
                                /* *32 start * */
                                IF CUR_BOOKED_DISCHARGE_DATA.FK_SLOT_OPERATOR = 'OOL' THEN

                                    IF ((CUR_BOOKED_DISCHARGE_DATA.FK_SLOT_OPERATOR != CUR_COINTAINER_NO_DL_DATA.SLOT_OPERATOR) OR
                                        (CUR_BOOKED_DISCHARGE_DATA.FK_CONTAINER_OPERATOR != CUR_COINTAINER_NO_DL_DATA.CONTAINER_OPERATOR))
                                    THEN
                                        l_v_booked_lldl_id  :=  NULL; -- matching failed
                                    END IF;

                                ELSE
                                    IF CUR_BOOKED_DISCHARGE_DATA.FK_SLOT_OPERATOR         != CUR_COINTAINER_NO_DL_DATA.SLOT_OPERATOR THEN
                                        l_v_booked_lldl_id  :=  NULL; -- matching failed
                                    END IF;
                                END IF;


                                -- IF CUR_BOOKED_DISCHARGE_DATA.FK_SLOT_OPERATOR         != CUR_COINTAINER_NO_DL_DATA.SLOT_OPERATOR THEN
                                --     l_v_booked_lldl_id  :=  NULL; -- matching failed
                                -- END IF;
                                /* *32 end * */

                            ELSE
                                IF CUR_BOOKED_DISCHARGE_DATA.FK_CONTAINER_OPERATOR    != CUR_COINTAINER_NO_DL_DATA.CONTAINER_OPERATOR THEN
                                    l_v_booked_lldl_id  :=  NULL; -- matching failed
                                END IF;
                            END IF;
                            /*
                                Block ended by vikas , 20.02.2012
                            */
                          /*--start #51
                        ELSE
                            --error
                            --String x = EQUIPMENT_NO~DN_EQ_SIZE~DN_EQ_TYPE

                            l_v_err_code := 'MC017';
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , NULL
                                , NULL
                                , p_i_n_discharge_list_id
                                , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                                , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                , l_v_err_code
                                , g_v_user
                                , 'MC017_03'
                                );

                           PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_err_code||SEP||l_v_list_type||SEP||CUR_COINTAINER_NO_DL_DATA.BOOKING_NO||SEP||CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                          , 'MC017_03'
                                          , null
                                          , CUR_COINTAINER_NO_DL_DATA.FLAG_SOC_COC
                                            ||' '||CUR_BOOKED_DISCHARGE_DATA.DN_EQ_SIZE
                                            ||'<>'||CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                                            ||' '||CUR_BOOKED_DISCHARGE_DATA.DN_EQ_TYPE
                                            ||'<>'||CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE
                                          ,g_v_user
                                          , SYSDATE
                                            );
                        -- #51 end */
                        END IF ; ----------------END IF OF 2 CONDITIONS OF SOC AND RCL
                   /*-- start #51
                    ELSE
                        -- error
                        --String x = EQUIPMENT_NO~DN_EQ_SIZE~DN_EQ_TYPE
                        l_v_err_code := 'MC018';
                        PRE_TOS_ERROR_LOG(
                        l_v_list_type
                        , NULL
                        , NULL
                        , p_i_n_discharge_list_id
                        , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                        , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                        , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                        , l_v_err_code
                        , g_v_user
                        , g_v_user
                        );
                        -- end #51 */
                    END IF;-----------------------------------OF COC AN SOC

                    IF L_V_BOOKED_LLDL_ID IS NOT NULL THEN
                        /*Added by Leena 17.01.2012: Check whether the equipment number is different, if
                        different do not update BEGIN*/
                        IF  (CUR_BOOKED_DISCHARGE_DATA.DN_EQ_SIZE = CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                                    AND CUR_BOOKED_DISCHARGE_DATA.DN_EQ_TYPE = CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                                    AND (CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO IS NULL OR
                                         CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO = CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO)) THEN
                            L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'Y';
                        ELSE
                            L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'N';
                        END IF;

                        IF(L_V_SZE_TYP_EQPNO_CORECT_FLAG = 'Y') THEN
                            /*Added by Leena 17.01.2012: Check whether the equipment number is different, if
                            different do not update BEGIN*/

                            g_v_sql_id := 'SQL-01010';
                            BEGIN
                                g_v_delete_flag := 'Y'; -- added by vikas, 06.12.2011

                                /*
                                    *2: Block added by vikas, 02.03.2012,
                                    To check duplicate equipment
                                */

                                PRE_CHECK_DUPLICATE_CONTAINER (
                                  CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                , p_i_n_load_list_id
                                , 'L'
                                , l_v_booked_lldl_id
                                , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                                , CUR_COINTAINER_NO_DL_DATA.EQ_SIZE
                                , CUR_COINTAINER_NO_DL_DATA.EQ_TYPE
                                , CUR_BOOKED_DISCHARGE_DATA.DN_EQUIPMENT_NO
                                , l_v_booked_lldl_id   -- output load list id
                                , p_o_v_return_status
                                );

                                /*
                                    Old logic

                                    Return '1' when duplicate container found.
                                *
                                PRE_CHECK_DUPLICATE_CONTAINER (
                                      CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                    , p_i_n_discharge_list_id
                                    , 'D'
                                    , l_v_booked_lldl_id
                                    , p_o_v_return_status
                                );

                                /*
                                    Block ended by vikas, 02.03.2012
                                */


                                IF (p_o_v_return_status = '2' ) THEN -- *2
                                    /*
                                        Duplicate container found in booked table.
                                    */
                                    p_o_v_return_status := '0';
                                    /*-- start #51
                                    l_v_err_code := 'MC023';
                                    PRE_TOS_ERROR_LOG(
                                        l_v_list_type
                                        , NULL
                                        , NULL
                                        , p_i_n_discharge_list_id
                                        , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                                        , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                                        , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                        , l_v_err_code
                                        , g_v_user
                                        , g_v_user
                                    );
                                    -- end #51 */
                                    EXIT; -- duplicate container found no need to check this equipment
                                ELSIF  (p_o_v_return_status = '1' ) THEN  -- *2
                                    p_o_v_return_status := '0';
                                    /*-- start #51
                                    l_v_err_code := 'MC017';
                                    PRE_TOS_ERROR_LOG(
                                        l_v_list_type
                                        , NULL
                                        , NULL
                                        , p_i_n_discharge_list_id
                                        , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                                        , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                                        , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                        , l_v_err_code
                                        , g_v_user
                                        , 'MC017_04'
                                    );
                                    -- end #51 */
                                    EXIT;
                                END IF; -- End of Error status if block -- *2
                                p_o_v_return_status := '0';

                                PRE_TOS_LLDL_MATCH_UPDATE ('DL'
                                                    , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                                    , CUR_COINTAINER_NO_DL_DATA.OVERHEIGHT_CM
                                                    , CUR_COINTAINER_NO_DL_DATA.OVERLENGTH_REAR_CM
                                                    , CUR_COINTAINER_NO_DL_DATA.OVERLENGTH_FRONT_CM
                                                    , CUR_COINTAINER_NO_DL_DATA.OVERWIDTH_LEFT_CM
                                                    , CUR_COINTAINER_NO_DL_DATA.OVERWIDTH_RIGHT_CM
                                                    , CUR_COINTAINER_NO_DL_DATA.UN_NUMBER
                                                    , CUR_COINTAINER_NO_DL_DATA.UN_NUMBER_VARIANT
                                                    , CUR_COINTAINER_NO_DL_DATA.FLASHPOINT
                                                    , CUR_COINTAINER_NO_DL_DATA.FLASHPOINT_UNIT
                                                    , CUR_COINTAINER_NO_DL_DATA.IMDG_CLASS
                                                    , CUR_COINTAINER_NO_DL_DATA.REEFER_TEMPERATURE
                                                    , CUR_COINTAINER_NO_DL_DATA.REEFER_TMP_UNIT
                                                    , CUR_COINTAINER_NO_DL_DATA.HUMIDITY
                                                    , CUR_COINTAINER_NO_DL_DATA.VENTILATION
                                                    , CUR_COINTAINER_NO_DL_DATA.PORT_CLASS
                                                    , CUR_COINTAINER_NO_DL_DATA.PORT_CLASS_TYP
                                                    , l_v_booked_lldl_id
                                                    , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                                                    , NULL
                                                    , NULL
                                                    , CUR_BOOKED_DISCHARGE_DATA.EQUIPMENT_SEQ_NO
                                                    , CUR_BOOKED_DISCHARGE_DATA.FK_BOOKING_NO
                                                    , CUR_COINTAINER_NO_DL_DATA.CONTAINER_GROSS_WEIGHT
                                                    , CUR_COINTAINER_NO_DL_DATA.VGM
                                                    , CUR_COINTAINER_NO_DL_DATA.STOWAGE_POSITION
                                                    , CUR_COINTAINER_NO_DL_DATA.CONTAINER_OPERATOR
                                                    , NULL
                                                    , p_i_n_discharge_list_id
                                                    , CUR_COINTAINER_NO_DL_DATA.MIDSTREAM_HANDLING_CODE
                                                    , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_1 -- *10
                                                    , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_2 -- *10
                                                    , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_3 -- *10
                                                    , CUR_COINTAINER_NO_DL_DATA.ACTIVITY_DATE_TIME -- *29
                                                    , NULL --*36
                                                    , NULL --*36
                                                    , p_o_v_return_status );

                                l_arr_var_name := STRING_ARRAY
                                ('p_i_n_list_type'                , 'p_i_v_equipment_no'              , 'p_i_n_overheight'
                                , 'p_i_n_overlength_rear'          , 'p_i_n_overlength_front'          , 'p_i_n_overwidth_left'
                                , 'p_i_n_overwidth_right'          , 'p_i_v_unno'                      , 'p_i_v_un_var'
                                , 'p_i_v_flash_point'              , 'p_i_n_flash_unit'                , 'p_i_v_imdg'
                                , 'p_i_n_reefer_tmp'               , 'p_i_v_reefer_tmp_unit'           , 'p_i_n_humidity'
                                , 'p_i_n_ventilation'              , 'p_i_v_port_class'                , 'p_i_v_portclass_type'
                                , 'p_i_n_discharge_id'             , 'p_i_n_overlanded_container_id'   , 'p_i_n_booked_load_id'
                                , 'p_i_n_overshipped_container_id' , 'p_i_n_equipment_seq_no'          , 'p_i_v_booking_no'
                                , 'p_i_n_gross_wt'                 , 'p_i_v_stowage_position'          , 'p_i_v_container_operator'
                                , 'p_i_v_preadvice_flg'
                                , 'p_o_v_return_status'
                                );

                                l_arr_var_value := STRING_ARRAY
                                ('DL'                  ,  CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO            , CUR_COINTAINER_NO_DL_DATA.OVERHEIGHT_CM
                                , CUR_COINTAINER_NO_DL_DATA.OVERLENGTH_REAR_CM                              , CUR_COINTAINER_NO_DL_DATA.OVERLENGTH_FRONT_CM
                                , CUR_COINTAINER_NO_DL_DATA.OVERWIDTH_LEFT_CM                               , CUR_COINTAINER_NO_DL_DATA.OVERWIDTH_RIGHT_CM
                                , CUR_COINTAINER_NO_DL_DATA.UN_NUMBER                                       , CUR_COINTAINER_NO_DL_DATA.UN_NUMBER_VARIANT
                                , CUR_COINTAINER_NO_DL_DATA.FLASHPOINT                                      , CUR_COINTAINER_NO_DL_DATA.FLASHPOINT_UNIT
                                , CUR_COINTAINER_NO_DL_DATA.IMDG_CLASS                                      , CUR_COINTAINER_NO_DL_DATA. REEFER_TEMPERATURE
                                , CUR_COINTAINER_NO_DL_DATA.REEFER_TMP_UNIT                                 , CUR_COINTAINER_NO_DL_DATA.HUMIDITY
                                , CUR_COINTAINER_NO_DL_DATA.VENTILATION                                     , CUR_COINTAINER_NO_DL_DATA.PORT_CLASS
                                , CUR_COINTAINER_NO_DL_DATA.PORT_CLASS_TYP                                  , l_v_booked_lldl_id
                                , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID                      , NULL
                                , NULL                                                                      , CUR_BOOKED_DISCHARGE_DATA.EQUIPMENT_SEQ_NO
                                , CUR_BOOKED_DISCHARGE_DATA.FK_BOOKING_NO                                   , CUR_COINTAINER_NO_DL_DATA.CONTAINER_GROSS_WEIGHT
                                , CUR_COINTAINER_NO_DL_DATA.STOWAGE_POSITION                                , CUR_COINTAINER_NO_DL_DATA.CONTAINER_OPERATOR
                                , NULL
                                , p_o_v_return_status
                                );

                                l_arr_var_io := STRING_ARRAY
                                ('I'      , 'I'      , 'I'
                                , 'I'      , 'I'      , 'I'
                                , 'I'      , 'I'      , 'I'
                                , 'I'      , 'I'      , 'I'
                                , 'I'      , 'I'      , 'I'
                                , 'I'      , 'I'      , 'I'
                                , 'I'      , 'I'      , 'I'
                                , 'I'      , 'I'      , 'I'
                                , 'I'      , 'I'      , 'I'
                                , 'I'
                                , 'O'
                                );
/*-- *50 remove logging
                                PRE_LOG_INFO
                                ('PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING'
                                , 'PRE_TOS_LLDL_MATCH_UPDATE'
                                , g_v_sql_id
                                , g_v_user
                                , l_t_log_info
                                , NULL
                                , l_arr_var_name
                                , l_arr_var_value
                                , l_arr_var_io
                                ); --*/

                                IF p_o_v_return_status = '1' THEN
                                    /* vikas: start adding against bug* 588, on 19.10.2011 */
                                    /* Error occurred in LL-DL matching update. */
                                    /* -- start #51
                                    l_v_err_code := 'MC011';

                                    PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , NULL
                                    , NULL
                                    , p_i_n_discharge_list_id
                                    , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                                    , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                                    , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                    );
                                    /* vikas: end adding against bug* 588, on 19.10.2011 */
                                    -- end #51 */
                                    g_v_err_code   := TO_CHAR(SQLCODE);
                                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                                    RAISE l_exce_main;
                                END IF;
                                /*
                                Start added loop should exit after successful match, 14.02.2012
                                */
                                EXIT;
                                /*
                                End added by vikas, 14.02.2012
                                */

                            EXCEPTION
                            WHEN OTHERS THEN
                                g_v_err_code   := TO_CHAR(SQLCODE);
                                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                                RAISE l_exce_main;
                            END;
                        END IF; --Leena 17.01.2012
                        -- EXIT;     -- commented by vikas, loop should not exist after getting load list id.
                                     -- loop should exit after the matching successfully done, vikas, 14.02.2012

                    END IF;
                END LOOP;

                L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'N';
                IF (l_v_booked_lldl_id IS NULL) AND (l_v_coc_empty  = 'Y' OR l_v_soc_rcl = 'Y' ) THEN
                    --Means matching is done  but not with booked status.In this case call autoexpand
                    -- DBMS_OUTPUT.PUT_LINE('Means matching is done  but not with booked status.In this case call autoexpand');

                    /* vikas: start adding to log reason of failed matching, on 06.12.2011 */

                    /* Error occurred in LL-DL matching
                        The booking found for coc empty or soc container in booked table,
                        but the equipment is not blank */
                    l_v_err_code := 'MC019';

                    PRE_TOS_ERROR_LOG(
                    l_v_list_type
                    , NULL
                    , NULL
                    , p_i_n_discharge_list_id
                    , CUR_COINTAINER_NO_DL_DATA.PK_OVERLANDED_CONTAINER_ID
                    , CUR_COINTAINER_NO_DL_DATA.BOOKING_NO
                    , CUR_COINTAINER_NO_DL_DATA.EQUIPMENT_NO
                    , l_v_err_code
                    , g_v_user
                    , g_v_user
                    );
                    /* vikas: end adding, on 06.12.2011 */
                    -- NULL; ----------- ----------------CALL AUTOEXPAND-----------------------
                END IF;
            END IF;

        END IF; -- END IF OF l_v_rec_found = 'N'

        l_v_booked_lldl_id := NULL;
        l_v_cont_exst := 'N';
        l_v_coc_empty := 'N';
        l_v_soc_rcl   := 'N';
        L_V_COC_FUL   := 'N';
        L_V_SZE_TYP_EQPNO_CORECT_FLAG := 'N'; --Leena 17.01.2012
    END LOOP;  --end of main loop CUR_COINTAINER_NO_DL

    /*
        Block start by vikas, to update status count into hader table, after matching, 05.03.2012
    */
    IF p_i_v_list_type = 'LL' THEN
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
            p_i_n_load_list_id
            , 'L'
            , g_v_err_code
        );
    ELSE
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
            p_i_n_discharge_list_id
            , 'D'
            , g_v_err_code
        );
    END IF;
    /*
        Block ended by vikas, 05.03.2012
    */

    COMMIT;
    p_o_v_return_status := '0';

EXCEPTION
WHEN l_exce_main THEN
    p_o_v_return_status := '1';
    ROLLBACK;

    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                                          , 'Matching'
                                          , g_v_opr_type
                                          , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE -- CURRENT_TIMESTAMP --*24
                                          ,g_v_user
                                          , SYSDATE -- CURRENT_TIMESTAMP --*24
                                            );

    COMMIT;
WHEN OTHERS THEN
    p_o_v_return_status := '1';
    ROLLBACK;
    g_v_err_code   := TO_CHAR(SQLCODE);
    g_v_err_desc   := SUBSTR(SQLERRM,1,100);

    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                                          , 'Matching'
                                          , g_v_opr_type
                                          , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                          , 'A'
                                          ,g_v_user
                                          , SYSDATE -- CURRENT_TIMESTAMP --*24
                                          ,g_v_user
                                          , SYSDATE -- CURRENT_TIMESTAMP --*24
                                            );
    COMMIT;

END PRE_TOS_LLDL_COMMON_MATCHING;

    PROCEDURE PRE_TOS_LLDL_MATCH_UPDATE(
          p_i_n_list_type                    IN   VARCHAR2
        , p_i_v_equipment_no                 IN   VARCHAR2
        , p_i_n_overheight                   IN   NUMBER
        , p_i_n_overlength_rear              IN   NUMBER
        , p_i_n_overlength_front             IN   NUMBER
        , p_i_n_overwidth_left               IN   NUMBER
        , p_i_n_overwidth_right              IN   NUMBER
        , p_i_v_unno                         IN   VARCHAR2
        , p_i_v_un_var                       IN   VARCHAR2
        , p_i_v_flash_point                  IN   NUMBER
        , p_i_n_flash_unit                   IN   VARCHAR2
        , p_i_v_imdg                         IN   VARCHAR2
        , p_i_n_reefer_tmp                   IN   NUMBER
        , p_i_v_reefer_tmp_unit              IN   VARCHAR2
        , p_i_n_humidity                     IN   NUMBER
        , p_i_n_ventilation                  IN   NUMBER
        , p_i_v_port_class                   IN   VARCHAR2
        , p_i_v_portclass_type               IN   VARCHAR2
        , p_i_n_discharge_id                 IN   NUMBER
        , p_i_n_overlanded_container_id      IN   NUMBER
        , p_i_n_booked_load_id               IN   NUMBER
        , p_i_n_overshipped_container_id     IN   NUMBER
        , p_i_n_equipment_seq_no             IN   NUMBER
        , p_i_v_booking_no                   IN   VARCHAR2
        , p_i_v_gross_wt                     IN   NUMBER
        , p_i_v_vgm                          IN   NUMBER  --*49
        , p_i_v_stowage_position             IN   VARCHAR2
        , p_i_v_container_operator           IN   VARCHAR2
        , p_i_v_preadvice_flg                IN   VARCHAR2
        , p_i_n_list_id                      IN   NUMBER
        , p_i_v_mid_stream                   IN   VARCHAR2
        , p_i_v_handling_ins_1               IN   TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_1%TYPE -- *10
        , p_i_v_handling_ins_2               IN   TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_2%TYPE -- *10
        , p_i_v_handling_ins_3               IN   TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_3%TYPE -- *10
        , p_i_v_activity_date                in   TOS_LL_OVERSHIPPED_CONTAINER.ACTIVITY_DATE_TIME%TYPE -- *29
        , p_i_v_ex_mlo_vessel                in   TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VESSEL%TYPE -- *36
        , p_i_v_ex_mlo_voyage                in   TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VOYAGE%TYPE -- *36
        , p_o_v_return_status                OUT  NOCOPY  VARCHAR2
    )  AS
    /*********************************************************************************
           Name           :  PRE_TOS_LLDL_MATCH_UPDATE
           Module         :
           Purpose        :  To Update data LAOD LIST AND DISCHARGE LIST HEADER TABLES
                             This procedure is called by Screen
           Calls          :
           Returns        :  Null
           Author          Date               What
           ------          ----               ----
           Rajat           10/02/2010        INITIAL VERSION

01  17/08/16    PONAPR1     #01     Add VGM coulmn
    ***********************************************************************************/
        l_v_time                   TIMESTAMP;
        l_v_parameter_str          VARCHAR2(1000);
        l_exce_main                EXCEPTION;
        l_v_service                TOS_LL_LOAD_LIST.FK_SERVICE%TYPE;
        l_v_vessel                 TOS_LL_LOAD_LIST.FK_VESSEL%TYPE;
        l_v_voyage                 TOS_LL_LOAD_LIST.FK_VOYAGE%TYPE;
        l_v_direction              TOS_LL_LOAD_LIST.FK_DIRECTION%TYPE;
        l_n_port_seqno             TOS_LL_LOAD_LIST.FK_PORT_SEQUENCE_NO%TYPE;
        l_v_port                   TOS_LL_LOAD_LIST.DN_PORT%TYPE;
        l_v_terminal               TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE;
        l_v_etd_date               VARCHAR2(10);
        l_v_etd_time               VARCHAR2(6);
        l_v_eta_date               VARCHAR2(10);
        l_v_eta_time               VARCHAR2(6);
        l_v_discharge_list_id      VARCHAR2(50);
        l_v_load_list_id           VARCHAR2(50);
        l_v_flag                   VARCHAR2(1);
        l_v_err_cd                 VARCHAR2(200):=PCE_EUT_COMMON.G_V_SUCCESS_CD;
        l_v_equipment_no           TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE;
        l_v_booking_no             TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE;
        l_v_bkg_equipm_dtl         TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE;
        l_v_bkg_voyage_routing_dtl TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL%TYPE;
        l_v_stowage_position       TOS_LL_BOOKED_LOADING.STOWAGE_POSITION%TYPE;
        l_n_load_list_id           TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE;
        l_n_discharge_list_id      TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID%TYPE;

        l_arr_var_name             STRING_ARRAY ;
        l_arr_var_value            STRING_ARRAY ;
        l_arr_var_io               STRING_ARRAY ;
        l_t_log_info               TIMESTAMP(6) ;
        l_n_overshipped_id         TOS_LL_OVERSHIPPED_CONTAINER.PK_OVERSHIPPED_CONTAINER_ID%TYPE;
        l_n_overlanded_id          TOS_DL_OVERLANDED_CONTAINER.PK_OVERLANDED_CONTAINER_ID%TYPE;
        l_v_err_code               TOS_ERROR_MST.ERROR_CODE%TYPE;
        l_v_list_type              VARCHAR2(1);
        l_v_change_user            TOS_LL_OVERSHIPPED_CONTAINER.RECORD_CHANGE_USER%TYPE;  -- added 19.12.2011
        l_v_dn_port                VASAPPS.TOS_LL_LOAD_LIST.DN_PORT%TYPE; -- ADDED 13.02.2012
        l_v_dn_terminal            VASAPPS.TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE; -- ADDED 13.02.2012

        l_v_first_leg TOS_LL_BOOKED_LOADING.FIRST_LEG_FLAG%TYPE; --*47
        l_v_ll_book_no TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE; --*47
        l_v_ll_eq_seq  TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE; --*47
        V_LL_VGM       TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE; --*47
        p_i_n_gross_wt TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE; --*47
        p_i_n_vgm      TOS_LL_BOOKED_LOADING.VGM%TYPE; --*49
           l_v_user                 BKP009.BICUSR%TYPE  ;   --*47
                l_v_date                 BKP009.BICDAT%TYPE; --*47
                l_v_time_bkp                 BKP009.BICTIM%TYPE;  --*47

     BEGIN

       --*47 BEGIN
         BEGIN
                         SELECT
                                    'EZLL'
                                    , TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD'))
                                    , TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI'))
                                INTO
                                    l_v_user
                                    , l_v_date
                                    , l_v_time_bkp
                                FROM
                                    DUAL;
                     END;
       --*47 END
        l_v_time := SYSDATE; -- CURRENT_TIMESTAMP; --*24
        p_i_n_gross_wt := p_i_v_gross_wt; --#47
        p_i_n_vgm := p_i_v_vgm; --*49

        l_v_parameter_str :=
            p_i_n_list_type                     ||SEP||
            p_i_v_equipment_no                  ||SEP||
            p_i_n_overheight                    ||SEP||
            p_i_n_overlength_rear               ||SEP||
            p_i_n_overlength_front              ||SEP||
            p_i_n_overwidth_left                ||SEP||
            p_i_n_overwidth_right               ||SEP||
            p_i_v_imdg                          ||SEP||
            p_i_v_unno                          ||SEP||
            p_i_v_un_var                        ||SEP||
            p_i_v_flash_point                   ||SEP||
            p_i_n_flash_unit                    ||SEP||
            p_i_n_reefer_tmp                    ||SEP||
            p_i_v_reefer_tmp_unit               ||SEP||
            p_i_n_humidity                      ||SEP||
            p_i_n_ventilation                   ||SEP||
            p_i_v_port_class                    ||SEP||
            p_i_v_portclass_type                ||SEP||
            p_i_n_discharge_id                  ||SEP||
            p_i_n_overlanded_container_id       ||SEP||
            p_i_n_booked_load_id                ||SEP||
            p_i_n_overshipped_container_id      ||SEP||
            p_i_n_equipment_seq_no              ||SEP||
            p_i_v_booking_no                    ||SEP||
            p_i_n_gross_wt                      ||SEP||
            p_i_n_vgm                           ||SEP|| --*49
            p_i_v_stowage_position              ||SEP||
            p_i_v_container_operator            ||SEP||
            p_i_v_mid_stream                    ||SEP||
            p_i_v_handling_ins_1                ||SEP||
            p_i_v_handling_ins_2                ||SEP||
            p_i_v_handling_ins_3                ||SEP||
            p_i_v_handling_ins_3                ||SEP||
            TO_CHAR(p_i_v_activity_date,'YYYYMMDDHH24MI') ||SEP||
            p_i_v_preadvice_flg;

        l_t_log_info := SYSDATE; -- CURRENT_TIMESTAMP; --*24


        /*
            INSERT INTO ECM_LOG_TRACE(
                PROG_ID
                , PROG_SQL
                , RECORD_STATUS
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
                , RECORD_CHANGE_USER
                , RECORD_CHANGE_DATE)
            VALUES
            (
                'EDI'
                ,l_v_parameter_str
                ,'A'
                ,'TEST'
                ,SYSDATE
                ,'TEST'
                ,SYSDATE
            );
        */

        IF p_i_n_list_type = 'LL' THEN
            l_v_list_type := 'L';
            /*
                Start added by vikas to get the
                updated user name from overshipped table.
                as k'chatgamol, 19.12.2011
            */
            BEGIN
                SELECT
                    RECORD_CHANGE_USER
                INTO
                    l_v_change_user
                FROM
                    TOS_LL_OVERSHIPPED_CONTAINER
                WHERE
                    PK_OVERSHIPPED_CONTAINER_ID    = p_i_n_overshipped_container_id;
            EXCEPTION
                WHEN OTHERS THEN
                    l_v_change_user := 'EDIT';
            END;
            /*
                End added by vikas, 19.12.2011
            */

        ELSE
            l_v_list_type := 'D';

            /*
                Start added by vikas to get the
                updated user name from overshipped table.
                as k'chatgamol, 19.12.2011
            */
            BEGIN
                SELECT
                    RECORD_CHANGE_USER
                INTO
                    l_v_change_user
                FROM
                    TOS_DL_OVERLANDED_CONTAINER
                WHERE
                    PK_OVERLANDED_CONTAINER_ID    = p_i_n_overlanded_container_id;
            EXCEPTION
                WHEN OTHERS THEN
                    l_v_change_user := 'EDIT';
            END;
            /*
                End added by vikas, 19.12.2011
            */
        END IF;

        IF p_i_n_list_type ='LL' THEN
            g_v_sql_id := 'SQL-03001';

            /*    PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_EDI (
                p_i_n_list_type
                , p_i_n_booked_load_id
                , p_i_n_overshipped_container_id
                , g_v_user
                , CURRENT_TIMESTAMP
                , p_o_v_return_status
            );

            l_arr_var_name := STRING_ARRAY
            ('p_i_v_load_dischage_list_flag'           , 'p_i_v_booked_id'           , 'p_i_v_osol_id'
            , 'p_i_v_add_user'                          , 'p_i_v_add_date'            , 'p_o_v_error'
            );

            l_arr_var_value := STRING_ARRAY
            (p_i_n_list_type      , p_i_n_booked_load_id           , p_i_n_overshipped_container_id
            , g_v_user             , CURRENT_TIMESTAMP              , p_o_v_return_status
            );

            l_arr_var_io := STRING_ARRAY
            ('I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'O'
            );

            PRE_LOG_INFO
            ('PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
            , 'PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_EDI'
            , g_v_sql_id
            , g_v_user
            , l_t_log_info
            , NULL
            , l_arr_var_name
            , l_arr_var_value
            , l_arr_var_io
            );


            IF (p_o_v_return_status = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                p_o_v_return_status := '0';
            ELSE
                p_o_v_return_status := '1';
                g_v_err_code   := TO_CHAR(SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                RAISE l_exce_main;
            END IF;  */
            g_v_sql_id := 'SQL-03002';
            /*  Get old equipment and stowage postion*/
            BEGIN
                SELECT DN_EQUIPMENT_NO
                    , FK_BOOKING_NO
                    , FK_BKG_EQUIPM_DTL
                    , FK_BKG_VOYAGE_ROUTING_DTL
                    , STOWAGE_POSITION
                    , FK_LOAD_LIST_ID
                INTO l_v_equipment_no
                    , l_v_booking_no
                    , l_v_bkg_equipm_dtl
                    , l_v_bkg_voyage_routing_dtl
                    , l_v_stowage_position
                    , l_n_load_list_id
                FROM TOS_LL_BOOKED_LOADING
                WHERE PK_BOOKED_LOADING_ID = p_i_n_booked_load_id;

            EXCEPTION
                WHEN OTHERS THEN
                /* vikas: start adding against bug* 588, on 19.10.2011 */
                    /* Booking not found in Booked tab.*/
                    l_v_err_code := 'MC004';
                    IF p_i_n_list_type = 'LL' THEN
                        PRE_TOS_ERROR_LOG(
                            l_v_list_type
                            , p_i_n_list_id
                            , p_i_n_overshipped_container_id
                            , NULL
                            , NULL
                            , p_i_v_booking_no
                            , p_i_v_equipment_no
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                        );
                    ELSE
                        PRE_TOS_ERROR_LOG(
                            l_v_list_type
                            , NULL
                            , NULL
                            , p_i_n_list_id
                            , p_i_n_overlanded_container_id
                            , p_i_v_booking_no
                            , p_i_v_equipment_no
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                        );
                    END IF;

                    /* vikas: end adding against bug* 588, on 19.10.2011 */
                    g_v_err_code   := TO_CHAR(SQLCODE);
                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                    RAISE l_exce_main;
            END;

            IF G_V_DELETE_FLAG is null THEN -- added by vikas, 06.12.2011
                DELETE from tos_error_log
                where error_code like 'M%'
                AND FK_LOAD_LIST_ID = l_n_load_list_id;
            END IF;  -- added by vikas, 06.12.2011

            IF NVL(l_v_stowage_position, '*') <> NVL(p_i_v_stowage_position, NVL(l_v_stowage_position, '*')) THEN
               /* Equipment no is changed from null to any value. then update load list. */

                IF (((l_v_equipment_no IS NULL) AND (p_i_v_equipment_no IS NOT NULL)) OR (nvl(l_v_equipment_no,'*')    <> NVL(p_i_v_equipment_no,'*')))THEN
                    /*
                        Start modification by vikas the condition that if new equipment is not null, then only update
                        cell location into discharge list, as suggested by k'chatgamol, 14.02.2012
                    */
                    IF (p_i_v_equipment_no  IS NOT NULL ) THEN -- START ADDED 13.02.2012
                        g_v_sql_id := 'SQL-0303A';
                        SELECT
                            DN_PORT
                            , DN_TERMINAL
                        INTO
                            l_v_dn_port
                            , l_v_dn_terminal
                        FROM
                            VASAPPS.TOS_LL_LOAD_LIST
                        WHERE
                            PK_LOAD_LIST_ID = l_n_load_list_id;


                        /* Update current discharge list */
                        g_v_sql_id := 'SQL-03003';
                        UPDATE TOS_DL_BOOKED_DISCHARGE
                            SET STOWAGE_POSITION   = p_i_v_stowage_position
                            , RECORD_CHANGE_USER = g_v_user
                            , RECORD_CHANGE_DATE = l_v_time
                        WHERE FK_BOOKING_NO   = l_v_booking_no
                        AND FK_BKG_EQUIPM_DTL = l_v_bkg_equipm_dtl
                        -- AND FK_BKG_VOYAGE_ROUTING_DTL = l_v_bkg_voyage_routing_dtl -- commented 13.02.2012
                        AND DN_POL = l_v_dn_port -- ADDED 13.02.2012
                        AND DN_POL_TERMINAL = l_v_dn_terminal -- ADDED 13.02.2012
                        AND RECORD_STATUS = 'A'
                        AND DISCHARGE_STATUS <> 'DI'; -- ADDED 21.02.2012

                    END IF; -- ADDED 13.02.2012
                    /*
                        End of modification, 13.02.2012
                    */
                ELSE
                    BEGIN
                        g_v_sql_id := 'SQL-03004';
                        SELECT FK_SERVICE, FK_VESSEL, FK_VOYAGE, FK_DIRECTION, FK_PORT_SEQUENCE_NO, DN_PORT, DN_TERMINAL
                        INTO l_v_service, l_v_vessel, l_v_voyage, l_v_direction, l_n_port_seqno, l_v_port, l_v_terminal
                        FROM TOS_LL_LOAD_LIST
                        WHERE PK_LOAD_LIST_ID = l_n_load_list_id
                        AND   FK_VERSION      = '99';
                    EXCEPTION
                        WHEN OTHERS THEN
                            /* vikas: start adding against bug* 588, on 19.10.2011 */
                            /* Load list not found in load list header table.*/
                            l_v_err_code := 'MC005';
                            IF p_i_n_list_type = 'LL' THEN
                                PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_list_id
                                    , p_i_n_overshipped_container_id
                                    , NULL
                                    , NULL
                                    , p_i_v_booking_no
                                    , p_i_v_equipment_no
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                            ELSE
                                PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , NULL
                                    , NULL
                                    , p_i_n_list_id
                                    , p_i_n_overlanded_container_id
                                    , p_i_v_booking_no
                                    , p_i_v_equipment_no
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                            END IF;

                            /* vikas: end adding against bug* 588, on 19.10.2011 */

                            g_v_err_code   := TO_CHAR(SQLCODE);
                            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                            RAISE l_exce_main;
                    END;
                    BEGIN
                        g_v_sql_id := 'SQL-03005';
                        SELECT TO_CHAR(TO_DATE(VVDPDT,'YYYYMMDD'),'DD/MM/YYYY'), TO_CHAR(VVDPTM)
                        INTO l_v_etd_date, l_v_etd_time
                        FROM ITP063
                        WHERE VVSRVC  = l_v_service
                        AND   VVVESS  = l_v_vessel
                        AND   VVVOYN  = l_v_voyage
                        AND   VVPDIR  = l_v_direction
                        AND   VVPCSQ  = l_n_port_seqno
                        AND   VVPCAL  = l_v_port
                        AND   VVTRM1  = l_v_terminal
                        AND   OMMISSION_FLAG IS NULL
                        AND   VVVERS  = 99;
                    EXCEPTION
                        WHEN OTHERS THEN
                            /* vikas: start adding against bug* 588, on 19.10.2011 */
                            /* Service,vessel,voyage not found in ITP063 table.*/
                            l_v_err_code := 'MC006';
                            IF p_i_n_list_type = 'LL' THEN
                                PRE_TOS_ERROR_LOG(
                                      l_v_list_type
                                    , p_i_n_list_id
                                    , p_i_n_overshipped_container_id
                                    , NULL
                                    , NULL
                                    , p_i_v_booking_no
                                    , p_i_v_equipment_no
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                            ELSE
                                PRE_TOS_ERROR_LOG(
                                      l_v_list_type
                                    , NULL
                                    , NULL
                                    , p_i_n_list_id
                                    , p_i_n_overlanded_container_id
                                    , p_i_v_booking_no
                                    , p_i_v_equipment_no
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                            END IF;

                            /* vikas: end adding against bug* 588, on 19.10.2011 */
                            g_v_err_code   := TO_CHAR(SQLCODE);
                            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                            RAISE l_exce_main;
                    END;

                    /* Get the discharge list id */
                    l_v_discharge_list_id := NULL;
                    l_v_flag              := NULL;
                    l_v_err_cd            := PCE_EUT_COMMON.G_V_SUCCESS_CD;
                    g_v_sql_id := 'SQL-03006';

                    -- PCE_ELL_LLMAINTENANCE.PRE_ELL_NEXT_DISCHARGE_LIST_ID (
                    PCE_EDL_DLMAINTENANCE.PRE_EDL_NEXT_DISCHARGE_LIST_ID  ( -- added by vikas, 21.11.2011
                        l_v_vessel
                        , l_v_equipment_no
                        , l_v_booking_no
                        , l_v_etd_date
                        , l_v_etd_time
                        , l_v_port
                        , l_n_port_seqno
                        , l_v_discharge_list_id
                        , l_v_flag
                        , l_v_err_cd
                    );

                    /* vikas: start adding against bug* 588, on 19.10.2011 */
                    IF(l_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                        /* Next discharge list not found for this load list.*/
                        l_v_err_code := 'MC007';
                        IF p_i_n_list_type = 'LL' THEN
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , p_i_n_list_id
                                , p_i_n_overshipped_container_id
                                , NULL
                                , NULL
                                , p_i_v_booking_no
                                , p_i_v_equipment_no
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );
                        ELSE
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , NULL
                                , NULL
                                , p_i_n_list_id
                                , p_i_n_overlanded_container_id
                                , p_i_v_booking_no
                                , p_i_v_equipment_no
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );
                        END IF;

                    END IF;
                    /* vikas: end adding against bug* 588, on 19.10.2011 */

                    IF(l_v_flag = 'D' AND l_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN

                        g_v_sql_id := 'SQL-03007';
                        /* update record in booked discharge list table */
                        UPDATE TOS_DL_BOOKED_DISCHARGE
                        SET STOWAGE_POSITION   = p_i_v_stowage_position
                            , RECORD_CHANGE_USER = g_v_user
                            , RECORD_CHANGE_DATE = l_v_time
                        WHERE PK_BOOKED_DISCHARGE_ID = l_v_discharge_list_id
                        AND RECORD_STATUS = 'A'       -- *30
                        AND DISCHARGE_STATUS <> 'DI'; -- *30
                    END IF;

                    l_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD; -- added by vikas, 06.12.2011
                END IF;
            END IF;

            IF l_v_err_cd =  PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
                -- *2: Modified by vikas to-Keep loading status as booked so that user will change from screen, to prevent
                --     duplicate cell location problem, as k'chatgamol , 14.02.2012
                -- start: Added fro DG log
            PCE_ELL_LLMAINTENANCE.PRE_LOG_PORTCLASS_CHANGE(p_i_n_booked_load_id,
                                                           p_i_v_port_class,
                                                           p_i_v_imdg,
                                                           p_i_v_unno,
                                                                       p_i_v_un_var,
                                                                       'L',
                                                                       l_v_change_user
                                                                      );
               -- end

                --*47 BEGIN
                /*-- start *48
                BEGIN
--

                    l_v_first_leg := 'N';
                    SELECT NVL(FIRST_LEG_FLAG,'N'),CONTAINER_GROSS_WEIGHT--,FK_BOOKING_NO,FK_BKG_EQUIPM_DTL
                    INTO l_v_first_leg,V_LL_VGM--,l_v_ll_book_no,l_v_ll_eq_seq
                    FROM TOS_LL_BOOKED_LOADING
                    WHERE  PK_BOOKED_LOADING_ID = p_i_n_booked_load_id;

                    IF L_V_FIRST_LEG <> 'Y' THEN
                       p_i_n_gross_wt := V_LL_VGM ;
                    END IF;
                     -- AND LOADING_STATUS = 'BK'
--                EXCEPTION WHEN NO_DATA_FOUND THEN
--                     l_v_first_leg := 'N';
--                     l_v_ll_book_no := NULL;
--                     l_v_ll_eq_seq := NULL;
                END;
                -- end *48*/
--
--                IF l_v_first_leg = 'Y' THEN
--
--                     BEGIN UPDATE TOS_LL_BOOKED_LOADING
--                     SET CONTAINER_GROSS_WEIGHT      = NVL( p_i_n_gross_wt, CONTAINER_GROSS_WEIGHT)
--                       , RECORD_CHANGE_USER          = l_v_change_user -- g_v_user -- modified by 19.12.2011
--                        , RECORD_CHANGE_DATE          = l_v_time
--                    WHERE PK_BOOKED_LOADING_ID    = p_i_n_booked_load_id ;
--                    END;
--
--
--                     BEGIN
--                     UPDATE BKP009
--                           SET MET_WEIGHT =  NVL( p_i_n_gross_wt, MET_WEIGHT) ,
--                             BICUSR        = l_v_user ,
--                              BICDAT        = l_v_date ,
--                             BICTIM        = l_v_time_bkp
--                           WHERE  BIBKNO   = l_v_ll_book_no
--                            AND    BISEQN   = l_v_ll_eq_seq;
--                   END;
--                 commit;
--                END IF;

                --*47 END

	 /*--- VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 UPDATE LL_BOOKED_LOADING IN MATCH_UPDATE'
                                                   ,'START : ' || SYSDATE
                                                   );
--*/
                BEGIN
                UPDATE TOS_LL_BOOKED_LOADING
                SET
                    -- LOADING_STATUS            = DECODE(p_i_v_preadvice_flg, NULL, 'LO', 'N', 'LO', LOADING_STATUS) -- *2
                    LOADING_STATUS                = 'BK' -- *2
                    , DN_EQUIPMENT_NO             = p_i_v_equipment_no
                    , OVERHEIGHT_CM               = NVL(p_i_n_overheight, OVERHEIGHT_CM)
                    , OVERLENGTH_REAR_CM          = NVL(p_i_n_overlength_rear, OVERLENGTH_REAR_CM)
                    , OVERLENGTH_FRONT_CM         = NVL(p_i_n_overlength_front, OVERLENGTH_FRONT_CM)
                    , OVERWIDTH_LEFT_CM           = NVL(p_i_n_overwidth_left, OVERWIDTH_LEFT_CM)
                    , OVERWIDTH_RIGHT_CM          = NVL(p_i_n_overwidth_right, OVERWIDTH_RIGHT_CM)
                    , FK_UNNO                     = NVL(p_i_v_unno, FK_UNNO)
                    , FK_UN_VAR                   = NVL(p_i_v_un_var, FK_UN_VAR)
                    , FLASH_POINT                 = NVL(p_i_v_flash_point, FLASH_POINT)
                    , FLASH_UNIT                  = NVL(p_i_n_flash_unit, FLASH_UNIT)
                    , FK_IMDG                     = NVL(p_i_v_imdg, FK_IMDG)
                    , REEFER_TMP                  = NVL(p_i_n_reefer_tmp, REEFER_TMP)
                    , REEFER_TMP_UNIT             = NVL(p_i_v_reefer_tmp_unit, REEFER_TMP_UNIT)
                    , DN_HUMIDITY                 = NVL(p_i_n_humidity, DN_HUMIDITY)
                    , DN_VENTILATION              = NVL(p_i_n_ventilation, DN_VENTILATION)
                    , FK_PORT_CLASS               = NVL(p_i_v_port_class, FK_PORT_CLASS)
                    , FK_PORT_CLASS_TYP           = NVL(p_i_v_portclass_type, FK_PORT_CLASS_TYP)
                    --, PREADVICE_FLAG              = NVL(p_i_v_preadvice_flg, PREADVICE_FLAG)
                    , STOWAGE_POSITION            = NVL(p_i_v_stowage_position, STOWAGE_POSITION)
                    , FK_CONTAINER_OPERATOR       = NVL(p_i_v_container_operator, FK_CONTAINER_OPERATOR)
                    , CONTAINER_GROSS_WEIGHT      =  NVL(p_i_n_gross_wt, CONTAINER_GROSS_WEIGHT)-- *48 DECODE(l_v_first_leg,'Y',NVL(p_i_n_gross_wt, CONTAINER_GROSS_WEIGHT),CONTAINER_GROSS_WEIGHT) -- *47
                    , VGM                         =  NVL(p_i_n_vgm, VGM)  --*49
                    , MIDSTREAM_HANDLING_CODE     = NVL(p_i_v_mid_stream,MIDSTREAM_HANDLING_CODE) -- Modified by vikas, 13.01.2012
                    , FK_HANDLING_INSTRUCTION_1   = NVL(p_i_v_handling_ins_1, FK_HANDLING_INSTRUCTION_1) -- *10
                    , FK_HANDLING_INSTRUCTION_2   = NVL(p_i_v_handling_ins_2, FK_HANDLING_INSTRUCTION_2) -- *10
                    , FK_HANDLING_INSTRUCTION_3   = NVL(p_i_v_handling_ins_3, FK_HANDLING_INSTRUCTION_3) -- *10
                    , ACTIVITY_DATE_TIME          = DECODE(l_v_change_user, 'EDIU', ACTIVITY_DATE_TIME, p_i_v_activity_date) -- *29
                    , EX_MLO_VESSEL               = NVL(p_i_v_ex_mlo_vessel, EX_MLO_VESSEL) -- *36
                    --, EX_MLO_VOYAGE               = NVL(p_i_v_ex_mlo_voyage, EX_MLO_VESSEL) -- *36
                    , EX_MLO_VOYAGE               = NVL(p_i_v_ex_mlo_voyage, EX_MLO_VOYAGE) -- *38
                    , RECORD_CHANGE_USER          = l_v_change_user -- g_v_user -- modified by 19.12.2011
                    , RECORD_CHANGE_DATE          = l_v_time
                WHERE PK_BOOKED_LOADING_ID    = p_i_n_booked_load_id ;
               END;

	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER UPDATE LL_BOOKED_LOADING IN MATCH_UPDATE'
                                                   ,'END  : ' || SYSDATE
                                                   );
--*/
                /*
                    Block start by vikas, to update stowage position and weight in
                    booked discharge list, as suggested by k'chatgamol, 30.01.2012
                */

                PRE_UPDATE_STOW_WEIGHT_DL (
                    p_i_n_booked_load_id
                );
                /*
                    Block End by vikas, 30.01.2012
                */
/*-- *50 remove logging
                PRE_LOG_INFO(
                    'PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
                    , 'TOS_LL_BOOKED_LOADING FLAG : '||l_v_first_leg
                    , g_v_sql_id
                    , g_v_user
                    , l_t_log_info
                    , 'UPDATE CALLED'
                    , NULL
                    , NULL
                    , NULL
                ); --*/
             ----------SYNCHRONIZATION BATCH TO BE CALLED---------------------
             --------------DELETION  OF  CONTAINER IN OVERSHIPPED---
                DELETE FROM TOS_LL_OVERSHIPPED_CONTAINER
                WHERE PK_OVERSHIPPED_CONTAINER_ID = p_i_n_overshipped_container_id;

                /*
                    Block start by vikas, Delete the matched container details, from TOS_ERROR_LOG table, 24.02.2012
                *
                * commented by vikas, 27.02.2012

                    DELETE FROM
                        TOS_ERROR_LOG
                    WHERE
                        LL_DL_FLAG = 'L'
                        AND FK_LOAD_LIST_ID = p_i_n_list_id
                        AND EQUIPMENT_NO = p_i_v_equipment_no;

                *
                    Block End by vikas, , 24.02.2012
                */
            END IF;
        ELSE
            g_v_sql_id := 'SQL-03008';
            /*    PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_EDI (
                      l_v_list_type
                    , p_i_n_booked_load_id
                    , p_i_n_overlanded_container_id
                    , g_v_user
                    , CURRENT_TIMESTAMP
                    , p_o_v_return_status
                );

                l_arr_var_name := STRING_ARRAY
                 ('p_i_v_load_dischage_list_flag'           , 'p_i_v_booked_id'           , 'p_i_v_osol_id'
                , 'p_i_v_add_user'                          , 'p_i_v_add_date'            , 'p_o_v_error'
                  );

                  l_arr_var_value := STRING_ARRAY
                 (p_i_n_list_type      , p_i_n_booked_load_id           , p_i_n_overshipped_container_id
                , g_v_user             , CURRENT_TIMESTAMP              , p_o_v_return_status
                  );

                  l_arr_var_io := STRING_ARRAY
                 ('I'      , 'I'      , 'I'
                , 'I'      , 'I'      , 'O'
                  );

                PRE_LOG_INFO
                ('PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
               , 'PCE_ECM_RAISE_ENOTICE.PRE_RAISE_ENOTICE_EDI'
               , g_v_sql_id
               , g_v_user
               , l_t_log_info
               , NULL
               , l_arr_var_name
               , l_arr_var_value
               , l_arr_var_io
                );

                IF (p_o_v_return_status = PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                    p_o_v_return_status := '0';
                ELSE
                    p_o_v_return_status := '1';
                    g_v_err_code   := TO_CHAR(SQLCODE);
                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                    RAISE l_exce_main;
                END IF;  */

            G_V_SQL_ID := 'SQL-0309a';
            /*  Get old equipment and stowage postion*/
            BEGIN
                SELECT DN_EQUIPMENT_NO
                        , FK_BOOKING_NO
                        , FK_BKG_EQUIPM_DTL
                        , FK_BKG_VOYAGE_ROUTING_DTL
                        , STOWAGE_POSITION
                        , FK_DISCHARGE_LIST_ID
                INTO l_v_equipment_no
                    , l_v_booking_no
                    , l_v_bkg_equipm_dtl
                    , l_v_bkg_voyage_routing_dtl
                    , l_v_stowage_position
                    , l_n_discharge_list_id
                FROM TOS_DL_BOOKED_DISCHARGE
                WHERE PK_BOOKED_DISCHARGE_ID = p_i_n_discharge_id;
/*-- *50 remove logging
                PRE_LOG_INFO(
                    'PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
                    , g_v_sql_id
                    , '1.1'
                    , g_v_user
                    , l_t_log_info
                    , l_v_equipment_no||SEP||l_v_booking_no||SEP||l_v_bkg_equipm_dtl||SEP||l_v_bkg_voyage_routing_dtl||SEP||l_v_stowage_position||SEP||l_n_discharge_list_id||SEP||p_i_n_discharge_id
                    , NULL
                    , NULL
                    , NULL
                ); --*/

            EXCEPTION
                WHEN OTHERS THEN
                    /* vikas: start adding against bug* 588, on 19.10.2011 */
                    /* Booking not found in Booked tab.*/
                    l_v_err_code := 'MC004';
                    /* vikas: end adding against bug* 588, on 19.10.2011 */
                    IF p_i_n_list_type = 'LL' THEN
                        PRE_TOS_ERROR_LOG(
                            l_v_list_type
                            , p_i_n_list_id
                            , p_i_n_overshipped_container_id
                            , NULL
                            , NULL
                            , p_i_v_booking_no
                            , p_i_v_equipment_no
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                        );
                    ELSE
                        PRE_TOS_ERROR_LOG(
                            l_v_list_type
                            , NULL
                            , NULL
                            , p_i_n_list_id
                            , p_i_n_overlanded_container_id
                            , p_i_v_booking_no
                            , p_i_v_equipment_no
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                        );
                    END IF;

                    g_v_err_code   := TO_CHAR(SQLCODE);
                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                    RAISE l_exce_main;
            END;

            IF G_V_DELETE_FLAG is null THEN -- added by vikas, 06.12.2011
                DELETE from tos_error_log
                where error_code like 'M%'
                AND FK_DISCHARGE_LIST_ID= l_n_discharge_list_id;
            END IF; -- added by vikas, 06.12.2011
/*-- *50 remove logging
            PRE_LOG_INFO(
                'PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
                , g_v_sql_id
                , '1.2'
                , g_v_user
                , l_t_log_info
                , l_v_booking_no||SEP||l_v_bkg_equipm_dtl||SEP||l_v_bkg_voyage_routing_dtl
                , NULL
                , NULL
                , NULL
            ); --*/

            IF NVL(l_v_stowage_position, '*') <> NVL(p_i_v_stowage_position, NVL(l_v_stowage_position, '*')) THEN
                /* Equipment no is changed from null to any value. then update load list. */
                IF (((l_v_equipment_no IS NULL) AND (p_i_v_equipment_no IS NOT NULL)) OR (l_v_equipment_no <> p_i_v_equipment_no))THEN
                    /*
                        Start modification by vikas the condition that if new equipment is not null, then only update
                        cell location into load list, as suggested by k'chatgamol, 21.02.2012
                    */
                    IF (p_i_v_equipment_no  IS NOT NULL ) THEN -- START ADDED 21.02.2012

                        SELECT
                            DN_PORT
                            , DN_TERMINAL
                        INTO
                            l_v_dn_port
                            , l_v_dn_terminal
                        FROM
                            VASAPPS.TOS_DL_DISCHARGE_LIST
                        WHERE
                            PK_DISCHARGE_LIST_ID = l_n_discharge_list_id;


                        /* Update current discharge list */
                        g_v_sql_id := 'SQL-03010';
                        UPDATE TOS_LL_BOOKED_LOADING
                        SET STOWAGE_POSITION   = p_i_v_stowage_position
                            , RECORD_CHANGE_USER = g_v_user
                            , RECORD_CHANGE_DATE = l_v_time
                        WHERE FK_BOOKING_NO   = l_v_booking_no
                        AND FK_BKG_EQUIPM_DTL = l_v_bkg_equipm_dtl
                        -- AND FK_BKG_VOYAGE_ROUTING_DTL = l_v_bkg_voyage_routing_dtl -- commented 21.02.2012
                        AND DN_DISCHARGE_PORT = l_v_dn_port -- ADDED 21.02.2012
                        AND DN_DISCHARGE_TERMINAL = l_v_dn_terminal -- ADDED 21.02.2012
                        AND RECORD_STATUS = 'A'
                        AND LOADING_STATUS <> 'LO'; -- ADDED 21.02.2012

                    END IF;
                ELSE
                    BEGIN
                        g_v_sql_id := 'SQL-03011';
                        SELECT FK_SERVICE, FK_VESSEL, FK_VOYAGE, FK_DIRECTION, FK_PORT_SEQUENCE_NO, DN_PORT, DN_TERMINAL
                        INTO l_v_service, l_v_vessel, l_v_voyage, l_v_direction, l_n_port_seqno, l_v_port, l_v_terminal
                        FROM TOS_DL_DISCHARGE_LIST
                        WHERE PK_DISCHARGE_LIST_ID = l_n_discharge_list_id
                        AND   FK_VERSION           = '99';

                    EXCEPTION
                        WHEN OTHERS THEN
                            /* vikas: start adding against bug* 588, on 19.10.2011 */
                            /* Discharge list not found in discharge list header table */
                            l_v_err_code := 'MC008';
                            IF p_i_n_list_type = 'LL' THEN
                                PRE_TOS_ERROR_LOG(
                                        l_v_list_type
                                    , p_i_n_list_id
                                    , p_i_n_overshipped_container_id
                                    , NULL
                                    , NULL
                                    , p_i_v_booking_no
                                    , p_i_v_equipment_no
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                            ELSE
                                PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , NULL
                                    , NULL
                                    , p_i_n_list_id
                                    , p_i_n_overlanded_container_id
                                    , p_i_v_booking_no
                                    , p_i_v_equipment_no
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                            END IF;
                            /* vikas: end adding against bug* 588, on 19.10.2011 */
                            g_v_err_code   := TO_CHAR(SQLCODE);
                            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                            RAISE l_exce_main;
                    END;

                    BEGIN
                        g_v_sql_id := 'SQL-03012';
/*-- *50 remove logging
                        PRE_LOG_INFO(
                            'PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
                            , g_v_sql_id
                            , '1.3'
                            , g_v_user
                            , l_t_log_info
                            , l_v_service||SEP||l_v_vessel||SEP||l_v_voyage||SEP||l_v_direction||SEP||l_n_port_seqno||SEP||l_v_port||SEP||l_v_terminal
                            , NULL
                            , NULL
                            , NULL
                        ); --*/

                        /* SELECT TO_CHAR(TO_DATE(VVARDT,'YYYYMMDD'),'DD/MM/YYYY'), TO_CHAR(VVARTM)
                        INTO l_v_eta_date, l_v_eta_time
                        FROM ITP063
                        WHERE VVSRVC  = l_v_service
                        AND   VVVESS  = l_v_vessel
                        AND   VVVOYN  = l_v_voyage
                        AND   VVPDIR  = l_v_direction
                        AND   VVPCSQ  = l_n_port_seqno
                        AND   VVPCAL  = l_v_port
                        AND   VVTRM1  = l_v_terminal
                        AND   OMMISSION_FLAG IS NULL
                        AND   VVVERS  = 99;     */
                    EXCEPTION
                        WHEN OTHERS THEN
                            -- vikas: start adding against bug* 588, on 19.10.2011
                            -- Service,vessel,voyage not found in ITP063 table.
                            l_v_err_code := 'MC006';
                            IF p_i_n_list_type = 'LL' THEN
                                PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , p_i_n_list_id
                                    , p_i_n_overshipped_container_id
                                    , NULL
                                    , NULL
                                    , p_i_v_booking_no
                                    , p_i_v_equipment_no
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                            ELSE
                                PRE_TOS_ERROR_LOG(
                                    l_v_list_type
                                    , NULL
                                    , NULL
                                    , p_i_n_list_id
                                    , p_i_n_overlanded_container_id
                                    , p_i_v_booking_no
                                    , p_i_v_equipment_no
                                    , l_v_err_code
                                    , g_v_user
                                    , g_v_user
                                );
                            END IF;

                            -- vikas: end adding against bug* 588, on 19.10.2011
                            g_v_err_code   := TO_CHAR(SQLCODE);
                            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                            RAISE l_exce_main;
                    END;

                    /* Get the discharge list id */
                    l_v_load_list_id := NULL;
                    l_v_flag         := NULL;
                    l_v_err_cd       := PCE_EUT_COMMON.G_V_SUCCESS_CD;
                    g_v_sql_id := 'SQL-03013';

                    PCE_EDL_DLMAINTENANCE.PRE_EDL_PREV_LOAD_LIST_ID(
                        l_v_vessel
                        , l_v_equipment_no
                        , l_v_booking_no
                        , l_v_eta_date
                        , l_v_eta_time
                        , l_v_port
                        , l_n_port_seqno
                        , l_v_load_list_id
                        , l_v_flag
                        , l_v_err_cd
                    );

                    /* vikas: start adding against bug* 588, on 19.10.2011 */
                    IF(l_v_err_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                        /* Previous load list not found for this discharge list. */
                        l_v_err_code := 'MC009';
                        IF p_i_n_list_type = 'LL' THEN
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , p_i_n_list_id
                                , p_i_n_overshipped_container_id
                                , NULL
                                , NULL
                                , p_i_v_booking_no
                                , p_i_v_equipment_no
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                                );
                        ELSE
                            PRE_TOS_ERROR_LOG(
                                l_v_list_type
                                , NULL
                                , NULL
                                , p_i_n_list_id
                                , p_i_n_overlanded_container_id
                                , p_i_v_booking_no
                                , p_i_v_equipment_no
                                , l_v_err_code
                                , g_v_user
                                , g_v_user
                            );
                        END IF;

                    END IF;

                    /* vikas: end adding against bug* 588, on 19.10.2011 */
                    IF(l_v_flag = 'D' AND l_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                        g_v_sql_id := 'SQL-03014';
                        /* update record in booked discharge list table */
                        UPDATE TOS_LL_BOOKED_LOADING
                        SET STOWAGE_POSITION   = p_i_v_stowage_position
                            , RECORD_CHANGE_USER = g_v_user
                            , RECORD_CHANGE_DATE = l_v_time
                        WHERE PK_BOOKED_LOADING_ID = l_v_load_list_id
                        AND RECORD_STATUS = 'A'       -- *30
                        AND LOADING_STATUS <> 'LO'; -- *30

                    END IF;

                    IF(l_v_flag = 'R' AND l_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD ) THEN
                        UPDATE TOS_RESTOW
                        SET STOWAGE_POSITION   = p_i_v_stowage_position
                            , RECORD_CHANGE_USER = g_v_user
                            , RECORD_CHANGE_DATE = l_v_time
                        WHERE PK_RESTOW_ID = l_v_load_list_id
                        AND RECORD_STATUS = 'A'; -- *30
                    END IF;

                    l_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD; -- added by vikas, 06.12.2011
                END IF;

            END IF;

            IF l_v_err_cd = PCE_EUT_COMMON.G_V_SUCCESS_CD THEN

            PCE_ELL_LLMAINTENANCE.PRE_LOG_PORTCLASS_CHANGE(p_i_n_discharge_id,
                                                           p_i_v_port_class,
                                                           p_i_v_imdg,
                                                           p_i_v_unno,
                                                                       p_i_v_un_var,
                                                                       'D',
                                                                       l_v_change_user
                                                                      );

                --*47 BEGIN
--                 BEGIN
--
--                    SELECT NVL(FIRST_LEG_FLAG,'N')
--                    INTO l_v_first_leg
--                    FROM TOS_LL_BOOKED_LOADING
--                    WHERE PK_BOOKED_LOADING_ID = p_i_n_booked_load_id;
--                EXCEPTION WHEN NO_DATA_FOUND THEN
--                     l_v_first_leg := 'N';
--                END;
--
--                IF l_v_first_leg = 'Y' THEN
--
--                 UPDATE TOS_DL_BOOKED_DISCHARGE
--                 SET CONTAINER_GROSS_WEIGHT      = NVL( p_i_n_gross_wt, CONTAINER_GROSS_WEIGHT)
--                   , RECORD_CHANGE_USER          = l_v_change_user -- g_v_user -- modified by 19.12.2011
--                    , RECORD_CHANGE_DATE          = l_v_time
--                WHERE PK_BOOKED_DISCHARGE_ID      = p_i_n_discharge_id;
--                END IF;
--
                --*47 END
	 /*-- VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 UPDATE DL_BOOKED_LOADING IN MATCH_UPDATE'
                                                   ,'START : ' || SYSDATE
                                                   ); --*/
             BEGIN
                UPDATE TOS_DL_BOOKED_DISCHARGE
                SET DISCHARGE_STATUS              = DECODE(NVL(p_i_v_stowage_position, STOWAGE_POSITION), NULL, DISCHARGE_STATUS, 'DI')
                    , DN_EQUIPMENT_NO             = p_i_v_equipment_no
                    , OVERHEIGHT_CM               = NVL(p_i_n_overheight, OVERHEIGHT_CM)
                    , OVERLENGTH_REAR_CM          = NVL(p_i_n_overlength_rear, OVERLENGTH_REAR_CM)
                    , OVERLENGTH_FRONT_CM         = NVL(p_i_n_overlength_front, OVERLENGTH_FRONT_CM)
                    , OVERWIDTH_LEFT_CM           = NVL(p_i_n_overwidth_left, OVERWIDTH_LEFT_CM)
                    , OVERWIDTH_RIGHT_CM          = NVL(p_i_n_overwidth_right, OVERWIDTH_RIGHT_CM)
                    , FK_UNNO                     = NVL(p_i_v_unno, FK_UNNO)
                    , FK_UN_VAR                   = NVL(p_i_v_un_var, FK_UN_VAR)
                    , FLASH_POINT                 = NVL(p_i_v_flash_point, FLASH_POINT)
                    , FLASH_UNIT                  = NVL(p_i_n_flash_unit, FLASH_UNIT)
                    , FK_IMDG                     = NVL(p_i_v_imdg, FK_IMDG)
                    , REEFER_TEMPERATURE          = NVL(p_i_n_reefer_tmp, REEFER_TEMPERATURE)
                    , REEFER_TMP_UNIT             = NVL(p_i_v_reefer_tmp_unit, REEFER_TMP_UNIT)
                    , DN_HUMIDITY                 = NVL(p_i_n_humidity, DN_HUMIDITY)
                    , DN_VENTILATION              = NVL(p_i_n_ventilation, DN_VENTILATION)
                    , FK_PORT_CLASS               = NVL(p_i_v_port_class, FK_PORT_CLASS)
                    , FK_PORT_CLASS_TYP           = NVL(p_i_v_portclass_type, FK_PORT_CLASS_TYP)
                    , STOWAGE_POSITION            = NVL(p_i_v_stowage_position, STOWAGE_POSITION)
                    , FK_CONTAINER_OPERATOR       = NVL(p_i_v_container_operator, FK_CONTAINER_OPERATOR)
                    , CONTAINER_GROSS_WEIGHT      = NVL(p_i_n_gross_wt, CONTAINER_GROSS_WEIGHT) --*47
                    , VGM                         = NVL(p_i_n_vgm, VGM) --*49
                    , MIDSTREAM_HANDLING_CODE     = NVL(p_i_v_mid_stream, MIDSTREAM_HANDLING_CODE) -- modified by vikas, 13.01.2012
                    , FK_HANDLING_INSTRUCTION_1   = NVL(p_i_v_handling_ins_1, FK_HANDLING_INSTRUCTION_1) -- *10
                    , FK_HANDLING_INSTRUCTION_2   = NVL(p_i_v_handling_ins_2, FK_HANDLING_INSTRUCTION_2) -- *10
                    , FK_HANDLING_INSTRUCTION_3   = NVL(p_i_v_handling_ins_3, FK_HANDLING_INSTRUCTION_3) -- *10
                    , ACTIVITY_DATE_TIME          = DECODE(l_v_change_user, 'EDIU', ACTIVITY_DATE_TIME, p_i_v_activity_date) -- *29
                    , RECORD_CHANGE_USER          = l_v_change_user -- g_v_user -- modified 19.12.2011
                    , RECORD_CHANGE_DATE          = l_v_time
                WHERE PK_BOOKED_DISCHARGE_ID      = p_i_n_discharge_id;
               END;

	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER UPDATE DL_BOOKED_LOADING IN MATCH_UPDATE'
                                                   ,'END : ' || SYSDATE
                                                   ); --*/
    /*-- *50 remove logging
                PRE_LOG_INFO(
                    'PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
                    , 'TOS_DL_BOOKED_DISCHARGE FLAG : '||l_v_first_leg
                    , g_v_sql_id
                    , g_v_user
                    , l_t_log_info
                    , 'UPDATE CALLED'
                    , NULL
                    , NULL
                    , NULL
                ); --*/
                --------------DELETION  OF  CONTAINER IN OVERSHIPPED---
                DELETE FROM TOS_DL_OVERLANDED_CONTAINER
                WHERE PK_OVERLANDED_CONTAINER_ID = p_i_n_overlanded_container_id ;

                /*
                    Block start by vikas, Delete the matched container from TOS_ERROR_LOG table, 24.02.2012
                *

                * commented by vikas, 27.02.2012
                    DELETE FROM
                        TOS_ERROR_LOG
                    WHERE
                        LL_DL_FLAG = 'D'
                        AND FK_DISCHARGE_LIST_ID = p_i_n_list_id
                        AND EQUIPMENT_NO = p_i_v_equipment_no;

                *
                    Block End by vikas, , 24.02.2012
                */

                /*PRE_LOG_INFO(
                    'PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
                    , 'TOS_DL_OVERLANDED_CONTAINER'
                    , g_v_sql_id
                    , g_v_user
                    , l_t_log_info
                    , 'DELETE CALLED'
                    , NULL
                    , NULL
                    , NULL
                );*/ -- *37
            END IF;
        END IF;

        ----------SYNCHRONIZATION BATCH TO UPDATE IN BKP009---------------------
        G_V_SQL_ID := 'SQL-03015';

	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 CALLING SNCY_EZLL_BOOKING'
                                                   ,'START : ' || SYSDATE
                                                   ); --*/
        PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_EQUIPMENT_UPDATE(
            p_i_v_booking_no
            , p_i_n_equipment_seq_no
            , p_i_v_equipment_no
            , p_i_n_overheight
            , p_i_n_overlength_rear
            , p_i_n_overlength_front
            , p_i_n_overwidth_left
            , p_i_n_overwidth_right
            , p_i_v_imdg
            , p_i_v_unno
            , p_i_v_un_var
            , p_i_v_flash_point
            , p_i_n_flash_unit
            , p_i_n_reefer_tmp
            , p_i_v_reefer_tmp_unit
            , p_i_n_humidity
            , p_i_n_gross_wt
            , p_i_n_ventilation
            , NULL --CR SOLAS effect parameter (VGM_CATEGORY)--*48
           -- ,'Y' --CR SOLAS  parameter first_leg_flag
            , p_i_n_vgm   --*49
            , p_o_v_return_status
        );
	 /*-- VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER CALLING SNCY_EZLL_BOOKING'
                                                   ,'END : ' || SYSDATE
                                                   ); --*/

        l_arr_var_name := STRING_ARRAY
             ('p_i_v_booking_no'           , 'p_i_n_equipment_seq_no'           , 'p_i_v_equipment_no'
            , 'p_i_n_overheight'           , 'p_i_n_overlength_rear'            , 'p_i_n_overlength_front'
            , 'p_i_n_overwidth_left'       , 'p_i_n_overwidth_right'            , 'p_i_v_imdg'
            , 'p_i_v_unno'                 , 'p_i_v_un_var'                     , 'p_i_v_flash_point'
            , 'p_i_n_flash_unit'           , 'p_i_v_reefer_tmp'                 , 'p_i_v_reefer_tmp_unit'
            , 'p_i_n_humidity'             , 'p_i_n_gross_wt'                   , 'p_i_n_ventilation'
            , 'P_I_V_VGM_CATEGORY'   --*48 VGM_CATEGORY
            , 'p_i_n_vgm' --*49
            , 'p_o_v_return_status'
        );

        l_arr_var_value := STRING_ARRAY
            (p_i_v_booking_no          , p_i_n_equipment_seq_no              , p_i_v_equipment_no
            , p_i_n_overheight          , p_i_n_overlength_rear               , p_i_n_overlength_front
            , p_i_n_overwidth_left      , p_i_n_overwidth_right               , p_i_v_imdg
            , p_i_v_unno                , p_i_v_un_var                        , p_i_v_flash_point
            , p_i_n_flash_unit          , p_i_n_reefer_tmp                    , p_i_v_reefer_tmp_unit
            , p_i_n_humidity            , p_i_n_gross_wt                      , p_i_n_ventilation
            , NULL  --*48 VGM_CATGORY
            , p_i_n_vgm --*49
            , p_o_v_return_status
        );

        l_arr_var_io := STRING_ARRAY
            ('I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'I'
            , 'I'    --*48 VGM_CATEGORY
            ,'I' --*49
            , 'O'
        );
/*-- *50 remove logging
        PRE_LOG_INFO(
            'PCE_ECM_EDI.PRE_TOS_LLDL_MATCH_UPDATE'
            , 'PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_EQUIPMENT_UPDATE'
            , g_v_sql_id
            , g_v_user
            , l_t_log_info
            , NULL
            , l_arr_var_name
            , l_arr_var_value
            , l_arr_var_io
        ); --*/

        IF p_o_v_return_status = '1' THEN
            /* vikas: start adding against bug* 588, on 19.10.2011 */
            /*Synchronization equipment update failed.*/

            IF p_i_n_list_type = 'LL' THEN
                PRE_TOS_ERROR_LOG(
                    l_v_list_type
                    , p_i_n_list_id
                    , p_i_n_overshipped_container_id
                    , NULL
                    , NULL
                    , p_i_v_booking_no
                    , p_i_v_equipment_no
                    , l_v_err_code
                    , g_v_user
                    , g_v_user
                );
            ELSE
                PRE_TOS_ERROR_LOG(
                    l_v_list_type
                   , NULL
                   , NULL
                   , p_i_n_list_id
                   , p_i_n_overlanded_container_id
                   , p_i_v_booking_no
                   , p_i_v_equipment_no
                   , l_v_err_code
                   , g_v_user
                   , g_v_user
                );
            END IF;

            /* vikas: end adding against bug* 588, on 19.10.2011 */

            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            /* start added by vikas verma*/

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                l_v_parameter_str
                , 'Matching'
                , g_v_opr_type
                , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                , 'A'
                , g_v_user
                , SYSDATE -- CURRENT_TIMESTAMP --*24
                , g_v_user
                , SYSDATE -- CURRENT_TIMESTAMP --*24
            );
            commit;
    /*        RAISE l_exce_main; */
            /* end added by vikas verma*/
        END IF;

        ----------SYNCHRONIZATION BATCH TO UPDATE IN BKP009---------------------

        p_o_v_return_status := '0';

    EXCEPTION
        WHEN l_exce_main THEN
            p_o_v_return_status := '1';
            ROLLBACK;
        WHEN OTHERS THEN
            p_o_v_return_status := '1';
            ROLLBACK;
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
    END PRE_TOS_LLDL_MATCH_UPDATE;


 PROCEDURE TOS_EZLL_EDI_INBOUND
( p_i_v_api_uid       IN         VARCHAR2
, p_i_v_ezl           IN         VARCHAR2
, p_i_v_new_old       IN         VARCHAR2
--, p_o_v_return_status OUT NOCOPY VARCHAR2
) AS
/******************************************************************************************
* Name           : TOS_EZLL_EDI_INBOUND                                                   *
* Module         : EZLL                                                                   *
* Purpose        : This batch is basically monitor the EDI tables and fetch the data which
                   is coming from port(or uploaded using excel files containing load and
                   discharge information of container. Batch will process the data from
                   EDI tables and populate to overshipped and overlanded tables           *
* Calls          :                                                                        *
* Returns        :                                                                        *
* Steps Involved :                                                                        *
* History        :                                                                        *
* Author           Date          What                                                     *
* ---------------  ----------    ----                                                     *
* Bindu sekhar     15/02/2011     1.0                                                     *

01  17/08/16        PONAPR1       #01     Add VGM COLUMN for insert into overship & overland  tab
******************************************************************************************/
   l_exce_main                EXCEPTION;
   l_exce_matching            EXCEPTION;
   l_n_load_list_id           TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID%TYPE;
   l_n_overshipped_id         TOS_LL_OVERSHIPPED_CONTAINER.PK_OVERSHIPPED_CONTAINER_ID%TYPE;
   l_n_rec_count              NUMBER := 0;
   l_n_discharge_list_id      TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE;
   l_n_overlanded_id          TOS_DL_OVERLANDED_CONTAINER.PK_OVERLANDED_CONTAINER_ID%TYPE;
   l_d_sail_date_time         DATE;
   l_n_check                  NUMBER := 0;
   l_n_booking_type           BKP001.BABKTP%TYPE;
   l_v_preadvice_flg          VARCHAR2(1);
   l_v_da_error_status        VARCHAR2(1);
   l_v_handling_instruction1  TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_1%TYPE;
   l_v_handling_instruction2  TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_2%TYPE;
   l_v_handling_instruction3  TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_3%TYPE;
   l_v_container_loading_rem1 TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_LOADING_REM_1%TYPE;
   l_v_container_loading_rem2 TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_LOADING_REM_2%TYPE;
   l_n_record_found           NUMBER := 0;
   l_v_pod_terminal           EDI_ST_DOC_LOCATION.LOCATION_CODE%TYPE;
   l_v_pol_terminal           EDI_ST_DOC_LOCATION.LOCATION_CODE%TYPE;
   l_v_stowage_positon        VARCHAR2(10);
   l_n_edi_esdl_uid           EDI_ST_DOC_LOCATION.EDI_ESDL_UID%TYPE;
   l_d_time                   TIMESTAMP;
   l_d_date                   DATE;
   l_v_port_class_type        PORT_CLASS_TYPE.PORT_CLASS_TYPE%TYPE;
   l_v_port_class_code        PORT_CLASS.PORT_CLASS_CODE%TYPE;
   l_v_port_class_code_Pre    PORT_CLASS.PORT_CLASS_CODE%TYPE;  --- Add 23.07.2015 *46
   l_port_class               PORT_CLASS.PORT_CLASS_CODE%TYPE; -- ADDED 14.12.2011
   l_d_eqcumd                 DATE;
   l_v_parameter_str          VARCHAR2(200);
   l_d_activity_date_time     EDI_ST_DOC_DATE.ACTIVITY_DATE%TYPE;
   l_v_slot_operator          EDI_ST_DOC_PARTY.PARTY_CODE%TYPE;
   l_v_container_operator     EDI_ST_DOC_PARTY.PARTY_CODE%TYPE;
   l_v_out_slot_operator      EDI_ST_DOC_PARTY.PARTY_CODE%TYPE;
   l_n_edi_esdh_uid           EDI_ST_DOC_HAZARD.EDI_ESDH_UID%TYPE;
   l_n_edi_esdco_uid          EDI_ST_DOC_HAZARD.EDI_ESDCO_UID%TYPE;
   l_v_haz_mat_class          EDI_ST_DOC_HAZARD.HAZ_MAT_CLASS%TYPE;
   l_v_undg_number            EDI_ST_DOC_HAZARD.UNDG_NUMBER%TYPE;
   l_v_temperature_uom        EDI_ST_DOC_HAZARD.TEMPERATURE_UOM%TYPE;
   l_n_flashpoint             EDI_ST_DOC_HAZARD.FLASHPOINT%TYPE;
   l_v_residue                EDI_ST_DOC_HAZARD.RESIDUE%TYPE;
   l_v_err_code               TOS_ERROR_MST.ERROR_CODE%TYPE;
   l_v_variant                VARCHAR2(1):='-';
   l_v_var_validation         VARCHAR2(1);   -- ADDED 14.12.2011
   l_v_error_flag             VARCHAR2(1):= 0; -- ADDED 14.12.2011
   l_v_special_handling       VARCHAR2(10);
   l_n_port_class_val_err     NUMBER := 1; -- ADDED 14.12.2011
   l_n_imdg_val_err           NUMBER := 1; -- ADDED 14.12.2011
   v_pod_terminal_cd          VARCHAR2(2):='11';
   v_pol_terminal_cd          VARCHAR2(2):='9';
   v_container_terminal       VARCHAR2(2):='72';
   v_actual_arrival_date      VARCHAR2(4):='178';
   v_estimated_arrival_date   VARCHAR2(4):='132';
   v_slot_operator            VARCHAR2(4):='SL';
   v_out_slot_operator        VARCHAR2(4):='OSL';
   v_container_operator       VARCHAR2(4):='OP';
   v_special_handling_dg      VARCHAR2(4):= 'D1';   -- 'DG';  -- Modified, 19.12.2011
   v_special_handling_oog     VARCHAR2(4):= 'O0';   -- 'OOG'; -- Modified, 19.12.2011
   v_location_type_stowage    VARCHAR2(4):='147';
   l_v_lldl_flg               VARCHAR2(1);
   l_v_send_id                NUMBER := 0; -- added by vikas, 22.11.2011
   l_v_send_id_Preload        Number := 0; -- add by Chatgamol 23.07.2015 *46


   l_v_vessel                 EDI_ST_EQUIPMENT.VESSEL_CODE%TYPE;
   l_v_serv                   TOS_LL_LOAD_LIST.FK_SERVICE%TYPE;
   l_v_dir                    TOS_LL_LOAD_LIST.FK_DIRECTION%TYPE;
   l_v_seq_no                 TOS_LL_LOAD_LIST.FK_PORT_SEQUENCE_NO%TYPE;
   l_v_ret                    VARCHAR(1);

   l_v_bkg_no                  TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO%TYPE;
   l_v_eqp_no                  TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO%TYPE;
   l_v_eq_size_type            EDI_ST_EQUIPMENT.EQUIPMENT_SIZE_TYPE%TYPE;
   l_v_eq_size                 TOS_LL_OVERSHIPPED_CONTAINER.EQ_SIZE%TYPE;
   l_v_eq_type                 TOS_LL_OVERSHIPPED_CONTAINER.EQ_TYPE%TYPE;
   l_v_full_mt                 TOS_LL_OVERSHIPPED_CONTAINER.FULL_MT%TYPE;
   l_v_flag_soc_coc            TOS_LL_OVERSHIPPED_CONTAINER.FLAG_SOC_COC%TYPE;
   -- l_v_local_sts               TOS_LL_OVERSHIPPED_CONTAINER.LOCAL_STATUS%TYPE; -- *23
   l_v_local_sts               EDI_ST_EQUIPMENT.EQUIPMENT_STATUS%TYPE; -- *23
   l_v_local_term_sts          TOS_LL_OVERSHIPPED_CONTAINER.LOCAL_TERMINAL_STATUS%TYPE;
   l_v_cont_gross_wt           TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_GROSS_WEIGHT%TYPE;
   l_v_vgm                     TOS_LL_OVERSHIPPED_CONTAINER.VGM%TYPE;
   l_v_seal_no                 TOS_LL_OVERSHIPPED_CONTAINER.SEAL_NO%TYPE;
   l_v_pod                     TOS_LL_OVERSHIPPED_CONTAINER.DISCHARGE_PORT%TYPE;

   l_v_ovr_hg                  TOS_LL_OVERSHIPPED_CONTAINER.OVERHEIGHT_CM%TYPE;
   l_v_ovr_lf                  TOS_LL_OVERSHIPPED_CONTAINER.OVERWIDTH_LEFT_CM%TYPE;
   l_v_ovr_rt                  TOS_LL_OVERSHIPPED_CONTAINER.OVERWIDTH_RIGHT_CM%TYPE;
   l_v_ovr_ft                  TOS_LL_OVERSHIPPED_CONTAINER.OVERLENGTH_FRONT_CM%TYPE;
   l_v_ovr_rr                  TOS_LL_OVERSHIPPED_CONTAINER.OVERLENGTH_REAR_CM%TYPE;
   l_v_rfr_temp                TOS_LL_OVERSHIPPED_CONTAINER.REEFER_TEMPERATURE%TYPE;
   l_v_rfr_temp_ut             TOS_LL_OVERSHIPPED_CONTAINER.REEFER_TMP_UNIT%TYPE;
   l_v_hmdt                    TOS_LL_OVERSHIPPED_CONTAINER.HUMIDITY%TYPE;
   l_v_vent                    TOS_LL_OVERSHIPPED_CONTAINER.VENTILATION%TYPE;
   l_v_act_cd                  EDI_ST_EQUIPMENT.ACTIVITY_CODE%TYPE;
   l_v_act_loc                 EDI_ST_EQUIPMENT.ACTIVITY_LOCATION%TYPE;
   l_v_pol                     TOS_LL_OVERSHIPPED_CONTAINER.DISCHARGE_PORT%TYPE;
   v_count                     NUMBER;

   l_v_hd_sts                  VARCHAR2(1);
   l_v_tr_sts                  VARCHAR2(1);
   l_v_dt_sts                  VARCHAR2(1);

   l_arr_var_name              STRING_ARRAY ;
   l_arr_var_value             STRING_ARRAY ;
   l_arr_var_io                STRING_ARRAY ;
   l_t_log_info                TIMESTAMP(6) ;

   l_v_final_pod               TOS_LL_OVERSHIPPED_CONTAINER.DISCHARGE_PORT%TYPE;
   l_v_dl_pol_terminal         EDI_ST_DOC_LOCATION.LOCATION_CODE%TYPE;
   l_v_dl_pol                  TOS_LL_OVERSHIPPED_CONTAINER.DISCHARGE_PORT%TYPE;
   l_v_ll_pod_terminal         EDI_ST_DOC_LOCATION.LOCATION_CODE%TYPE;
   l_v_ll_pod                  TOS_LL_OVERSHIPPED_CONTAINER.DISCHARGE_PORT%TYPE;
   l_v_dl_booking_ref          EDI_ST_EQUIPMENT.BOOKING_REFERENCE%TYPE;

   v_info                      VARCHAR2 (400);
   l_v_return_status           VARCHAR2 (6);
   l_v_error_status           VARCHAR2 (4000); -- *31

    l_v_midstream               VARCHAR2(2);
    l_v_change_user            TOS_LL_OVERSHIPPED_CONTAINER.RECORD_CHANGE_USER%TYPE; -- added by vikas, 19.12.2011
    l_v_handling_code              EDI_ST_EQUIPMENT.TEXT_DESCRIPTION%TYPE; -- added by vikas, 09.03.2012

   TYPE l_rec_load_list_typ IS RECORD
      (load_list_id TOS_LL_OVERSHIPPED_CONTAINER.FK_LOAD_LIST_ID%TYPE);
   TYPE l_tb_typ_load_list IS TABLE OF l_rec_load_list_typ
      INDEX BY BINARY_INTEGER;
   l_tb_load_list    l_tb_typ_load_list;

   TYPE l_rec_discharge_list_typ IS RECORD
      (discharge_list_id TOS_DL_OVERLANDED_CONTAINER.FK_DISCHARGE_LIST_ID%TYPE);
   TYPE l_tb_typ_discharge_list IS TABLE OF l_rec_discharge_list_typ
      INDEX BY BINARY_INTEGER;
   l_tb_discharge_list         l_tb_typ_discharge_list;
   l_n_load_list_count         NUMBER := 0;
   l_n_discharge_list_count    NUMBER := 0;
   load_list                   TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID%TYPE := 0;
   discharge_list              TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE := 0;

   l_v_ex_mlo_vessel           TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VESSEL%TYPE; -- modified 12.01.2011
   l_v_ex_mlo_voyage           TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VOYAGE%TYPE; -- modified 12.01.2011

   l_v_vol_unmatch             NUMBER; -- modified 11.06.2014

--Cursor to retive EDI Transaction Header
CURSOR l_cur_edi_tran_header
IS
   SELECT MSG_REFERENCE,EME_UID
   FROM   EDI_TRANSACTION_HEADER
   WHERE  --API_CODE       = p_i_v_api_uid  --commenetd by aks on 06jun11 as discussed with durai
   --AND
          MODULE         = p_i_v_ezl
   AND    DIRECTION      = 'IN'
   AND    RECORD_STATUS  = 'A'
   AND    STATUS         = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E')
   --AND    MSG_REFERENCE  = '000017386376' --'000018184816' --
   ;

--Cursor to retive EDI Transaction Detail
CURSOR l_cur_edi_tran_detail (p_i_v_msg_ref  VARCHAR2)
IS
   SELECT EDI_ETD_UID,KEY_ELEMENT3
   FROM   EDI_TRANSACTION_DETAIL
   WHERE  MSG_REFERENCE = p_i_v_msg_ref
   AND    RECORD_STATUS = 'A'
   AND    STATUS        = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E');

--Cursor to retive EDI detail data.
CURSOR l_cur_edi_detail( l_n_etd_uid NUMBER)
IS
   SELECT ''                               SERVICE
        , ''                               DIRECTION
        , ''                               SEQUENCE_NUMBER
        , ''                               LOCAL_TERMINAL_STATUS
        , ''                               HUMIDITY
        , ''                               VENTILATION
        , VESSEL_CODE                      VESSEL_CODE
        , VESSEL_NAME                      VESSEL_NAME
        , VOYAGE_NUMBER                    VOYAGE_NUMBER
        , PORT_OF_LOADING                  PORT_OF_LOADING
        , EQUIPMENT_NO                     EQUIPMENT_NO
        , PORT_OF_DISCHARGE                PORT_OF_DISCHARGE
        , PORT_OF_DESTINATION              PORT_OF_DESTINATION
        , BOOKING_REFERENCE                BOOKING_NUMBER
        , ACTIVITY_DATE                    RECORD_PROCESSED_DATE
        , EDI_ETD_UID                      EDI_ETD_UID
        , SUBSTR(EQUIPMENT_SIZE_TYPE,1,2)
                                           EQ_SIZE
        , SUBSTR(EQUIPMENT_SIZE_TYPE, -2)  EQ_TYPE
        , EQUIPMENT_SIZE_TYPE              EQUIPMENT_SIZE_TYPE
        , EQUIPMENT_FULL_EMPTY             FULL_MT
        , EQUIPMENT_STATUS                 LOCAL_STATUS
        , GROSS_WEIGHT                     CONTAINER_GROSS_WEIGHT
        , SEAL_NUMBER_SH                   SEAL_NO
        , NVL(OVERHEIGHT,0)                OVERHEIGHT_CM
        , NVL(OVERWIDTH_LEFT,0)            OVERWIDTH_LEFT_CM
        , NVL(OVERWIDTH_RIGHT,0)           OVERWIDTH_RIGHT_CM
        , NVL(OVERLENGTH_FRONT,0)          OVERLENGTH_FRONT_CM
        , NVL(OVERLENGTH_BACK,0)           OVERLENGTH_REAR_CM
        , TEMPERATURE                      REEFER_TEMPERATURE
        , DECODE(TEMPERATURE_UOM,
                    'CEL','C',
                    'FAH','F')             REEFER_TMP_UNIT
        , CELL_LOCATION                    STOWAGE_POSITION
        , ACTIVITY_PLACE                   ACTIVITY_PLACE
        , SLOT_OWNER                       SLOT_OWNER
        , EQUIPMENT_OPERATOR               EQUIPMENT_OPERATOR
        , TEXT_ID                          TEXT_ID
        , TEXT_DESCRIPTION                 TEXT_DESCRIPTION
        , HAZ_MAT_CLASS                    HAZ_MAT_CLASS
        , UNDG_NUMBER                      UNDG_NUMBER
        , HAZ_MAT_CODE                     HAZ_MAT_CODE
        , TEMPERATURE_UOM                  TEMPERATURE_UOM
        , ACTIVITY_CODE                    ACTIVITY_CODE
        , ACTIVITY_LOCATION                ACTIVITY_LOCATION
        , ACTIVITY_DATE                    ACTIVITY_DATE
        , TEXT_CODE                        TEXT_CODE
        , CONVEYANCE_CODE                  EX_MLO_VESSEL -- added, 20.12.2011
        , CONVEYANCE_REFERENCE             EX_MLO_VOYAGE -- added, 20.12.2011
        , ATTACHED_EQPT4                   VGM  --#01
        , TRADING_PARTNER                  TRADING_PARTNER --*50
   FROM  EDI_ST_EQUIPMENT
   WHERE EDI_ETD_UID   = l_n_etd_uid;
   --AND   RECORD_STATUS = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'A');

BEGIN
   l_t_log_info := SYSDATE; -- CURRENT_TIMESTAMP; --*24

   g_v_user :='EDI';
   g_v_sql_id := 'SQL-02000';
   l_d_time := SYSDATE; -- CURRENT_TIMESTAMP; --*24
   l_d_date := SYSDATE;
   l_v_parameter_str := p_i_v_ezl ||SEP|| p_i_v_new_old;

   --##42
   --DBMS_OUTPUT.PUT_LINE('Delete temp Start: '|| TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI:SS') );
   DELETE EDI_TRANSACTION_HEADER_TMP;
   DELETE EDI_TRANSACTION_DETAIL_TMP;
   DELETE EDI_ST_EQUIPMENT_TMP;

   COMMIT;

   --DBMS_OUTPUT.PUT_LINE('Delete temp End  : '|| TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI:SS') );
   --##42

    /*PRE_LOG_INFO
     ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
    , 'CHECK'
    , '1'
    , g_v_user
    , l_t_log_info
    , 'STEP EXECUTED'
    , NULL
    , NULL
    , NULL
     );*/ --*37

   --Opening EDI Transaction Header
   FOR K IN l_cur_edi_tran_header
   LOOP
      --##42 BEGIN
      UPDATE EDI_TRANSACTION_HEADER
      SET    STATUS             = 'P'
           --, RECORD_CHANGE_USER = 'EZLL'                  --##44
           --, RECORD_CHANGE_DATE = l_d_date                --##44
           , RECORD_ADD_DATE = sysdate
      WHERE  RECORD_STATUS = 'A'
      AND    MSG_REFERENCE = K.MSG_REFERENCE
      ;


      --DBMS_OUTPUT.PUT_LINE(K.MSG_REFERENCE || ' -> ' || 'P');
      --##42 END

       /*PRE_LOG_INFO
         ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
        , 'HEADER'
        , '1.4'
        , g_v_user
        , l_t_log_info
        , K.MSG_REFERENCE||SEP||K.EME_UID
        , NULL
        , NULL
        , NULL
        );*/ -- *37
      --DBMS_OUTPUT.PUT_LINE('MSG_REFERENCE: '||K.MSG_REFERENCE);

      --Opening EDI Transaction Detail
      FOR J IN l_cur_edi_tran_detail(K.MSG_REFERENCE)
      LOOP
         /*PRE_LOG_INFO
         ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
         , 'HEADER'
         , '1.2'
         , g_v_user
         , l_t_log_info
         , J.EDI_ETD_UID||SEP||J.KEY_ELEMENT3
         , NULL
         , NULL
         , NULL
         );*/ --37

         --DBMS_OUTPUT.PUT_LINE('EDI_ETD_UID: '||J.EDI_ETD_UID);

         --Opening EDI Equipment Detail
         FOR I IN l_cur_edi_detail(J.EDI_ETD_UID)
         LOOP

            --DBMS_OUTPUT.PUT_LINE('EQUIPMENT_NO: '||I.EQUIPMENT_NO);

            /*
                Start added by vikas, to reinitialize the local variables, 16.12.2011
            */
            l_v_special_handling := NULL;
            l_n_check := 0;
            l_v_flag_soc_coc := NULL;
            l_v_slot_operator := NULL;
            /*
                End added by vikas, 16.12.2011
            */

            BEGIN
               /*PRE_LOG_INFO
               ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
               , 'CHECK'
               , '2'
               , g_v_user
               , l_t_log_info
               , 'STEP EXECUTED'
               , NULL
               , NULL
               , NULL
               );*/ --*37

               IF p_i_v_new_old = 'OLD' THEN
                  DELETE FROM EDI_TRANSACTION_ERROR WHERE EDI_ETD_UID = I.EDI_ETD_UID;
               END IF;
/*-- *50 remove logging
               PRE_LOG_INFO
               ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
               , 'CHECK'
               , '2.1'
               , g_v_user
               , l_t_log_info
               , I.EDI_ETD_UID || SEP || v_info || SEP || I.EQUIPMENT_NO || SEP || I.ACTIVITY_PLACE || SEP || I.ACTIVITY_LOCATION || SEP || I.ACTIVITY_CODE || SEP || I.RECORD_PROCESSED_DATE
               , NULL
               , NULL
               , NULL
               ); --*/

               g_v_sql_id := 'SQL-02001';

               --Call Process with parameters to check field validations
               v_info := 'PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ';

               --DBMS_OUTPUT.PUT_LINE('VALIDATE_INBOUND_FIELD');

               IF VALIDATE_INBOUND_FIELD ( I.EDI_ETD_UID
                                         , v_info
                                         , I.EQUIPMENT_NO
                                         , I.ACTIVITY_PLACE
                                         , I.ACTIVITY_LOCATION
                                         , I.ACTIVITY_CODE
                                         , I.RECORD_PROCESSED_DATE) = 1 THEN
                  g_v_err_code   := '01';
                  g_v_err_desc   := 'ERROR LOGGED FOR VALIDATE_INBOUND_FIELD';
                  g_v_record_filter := null;
                  g_v_record_table  := I.EDI_ETD_UID
                                       ||SEP||  v_info
                                       ||SEP||  I.EQUIPMENT_NO
                                       ||SEP||  I.ACTIVITY_PLACE
                                       ||SEP||  I.ACTIVITY_LOCATION
                                       ||SEP||  I.ACTIVITY_CODE
                                       ||SEP||  I.RECORD_PROCESSED_DATE;

                  --DBMS_OUTPUT.PUT_LINE(  g_v_err_desc||' '||g_v_record_table);

                  RAISE l_exce_main;

               END IF;

               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '3'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                );*/  --*37
               g_v_sql_id := 'SQL-02090';

               --DBMS_OUTPUT.PUT_LINE('BOOKING_NUMBER '||I.BOOKING_NUMBER);

               IF I.BOOKING_NUMBER IS NOT NULL THEN
                  SELECT BABKTP INTO l_v_flag_soc_coc FROM BKP001 WHERE BABKNO =I.BOOKING_NUMBER;
               ELSE
                  --SOC-COC LOGIC BASED ON EQUIPMENT NO ACTIVE IN EQUIPMENT MASTER
                  g_v_sql_id := 'SQL-02091';
                  IF I.EQUIPMENT_OPERATOR IS NULL OR I.EQUIPMENT_OPERATOR = 'RCL' THEN
                     BEGIN
                        SELECT 1
                           INTO   l_n_check
                        FROM   ECP010
                        WHERE  EQEQTN        = I.EQUIPMENT_NO
                        AND    EQCUST IN ('DOLC','SELO','DIOT','SLOT');

                        l_v_flag_soc_coc := 'S';
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           l_v_flag_soc_coc := 'C';
                        WHEN OTHERS THEN
                           l_v_flag_soc_coc := 'S';
                     END;
                  ELSE
                     l_v_flag_soc_coc := 'S';
                  END IF;
               END IF;

               /*PRE_LOG_INFO
               ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
               , 'CHECK'
               , '4'
               , g_v_user
               , l_t_log_info
               , 'STEP EXECUTED'
               , NULL
               , NULL
               , NULL
               );*/  --*37

               l_n_check := 0;
               g_v_sql_id := 'SQL-02092';
                ------------------------------------------------------------------------
               PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'EQUIPMENT_OPERATOR',I.EQUIPMENT_OPERATOR,v_count,l_v_container_operator);
               PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'FULL_MT',I.FULL_MT,v_count,l_v_full_mt);

               IF l_v_full_mt ='4' THEN
                  l_v_full_mt := 'E';
               ELSIF l_v_full_mt ='5' THEN
                  l_v_full_mt := 'F';
               END IF;

               g_v_sql_id := 'SQL-02093';

               IF I.SLOT_OWNER = 'RCL' THEN
                  l_v_slot_operator:= 'RCL';
               ELSE
                  PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'SLOT_OWNER',I.SLOT_OWNER,v_count,l_v_slot_operator);
                  IF(l_v_slot_operator IS NULL) THEN
                     l_v_slot_operator :=I.SLOT_OWNER;
                  END IF;
               END IF;

               -- For discharge list
               -- GET DATA FROM PORT MASTER
               l_v_dl_pol:= I.PORT_OF_LOADING;
               g_v_sql_id := 'SQL-02094';
               BEGIN
                  SELECT NVL(TQPORT, I.PORT_OF_LOADING)     -- Modify by vikas, 24.02.2012 to fix blank pol issue, 24.02.2012
                     INTO l_v_dl_pol
                  FROM
                        ITP130
                    WHERE
                        TQTERM=l_v_dl_pol;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                     l_v_dl_pol:= I.PORT_OF_LOADING;
                  END;

                PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'PORT_OF_LOADING',I.PORT_OF_LOADING,v_count,l_v_dl_pol_terminal);


                l_v_dl_booking_ref :=I.BOOKING_NUMBER;

                g_v_sql_id := 'SQL-02994';
                IF l_v_dl_booking_ref IS NOT NULL  THEN
                    SELECT BAPOD INTO l_v_final_pod FROM BKP001 WHERE BABKNO=l_v_dl_booking_ref;
                ELSIF I.PORT_OF_DESTINATION IS NULL  THEN
                    l_v_final_pod := I.PORT_OF_DISCHARGE;
                ELSE
                    PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'PORT_OF_DESTINATION',I.PORT_OF_DESTINATION,v_count,l_v_final_pod);
                END IF;

                -- For Load list
                -- GET DATA FROM PORT MASTER
                l_v_ll_pod:=I.PORT_OF_DISCHARGE;
                g_v_sql_id := 'SQL-02095';
                BEGIN
                    SELECT
                        NVL(TQPORT, I.PORT_OF_DISCHARGE) -- Modified by vikas, to solve null discharge port issue, 24.02.2012
                    INTO
                        l_v_ll_pod
                    FROM
                        ITP130
                    WHERE
                        TQTERM=l_v_ll_pod;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                       l_v_ll_pod:=I.PORT_OF_DISCHARGE;
                  END;
                PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'PORT_OF_DISCHARGE',I.PORT_OF_DISCHARGE,v_count,l_v_ll_pod_terminal);

                PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'ACTIVITY_LOCATION',I.ACTIVITY_LOCATION,v_count,l_v_act_loc);
                PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'VESSEL_CODE',I.VESSEL_CODE,v_count,l_v_vessel);
                -- if vessel code is null use the below translation
                PKG_EDI_TRANSACTION.VESSEL_CODE_TRANSLATION(l_v_vessel,I.VESSEL_NAME,l_v_vessel);

                g_v_sql_id := 'SQL-02096';
                BEGIN
                    PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'EQUIPMENT_SIZE_TYPE',I.EQUIPMENT_SIZE_TYPE,v_count,l_v_eq_size_type);
                    IF(l_v_eq_size_type IS NOT NULL) THEN
                        l_v_eq_size := SUBSTR(l_v_eq_size_type,1,2);
                        l_v_eq_type := SUBSTR(l_v_eq_size_type,-2);
                    ELSE
                        l_v_eq_size := NULL;
                        l_v_eq_type := NULL;
                    END IF;
                    --PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'EQ_TYPE',I.EQ_TYPE,v_count,l_v_eq_type);
                    --PKG_EDI_TRANSACTION.PRO_DATA_TRANSLATION (I.EDI_ETD_UID,K.EME_UID,'EQ_SIZE',I.EQ_SIZE,v_count,l_v_eq_size);
                EXCEPTION
                    WHEN OTHERS THEN
                        l_v_eq_type := NULL;
                        l_v_eq_size := NULL;
                END;
/*-- *50 remove logging
               PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'ACTIVITY_LOCATION'
                , '4.1'
                , g_v_user
                , l_t_log_info
                , l_v_act_loc
                , NULL
                , NULL
                , NULL
                );

               PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'VESSEL_CODE'
                , '4.2'
                , g_v_user
                , l_t_log_info
                , l_v_vessel
                , NULL
                , NULL
                , NULL
                ); --*/


               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '5'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                );*/  --*37
                g_v_sql_id := 'SQL-02097';

               l_v_act_cd:=I.ACTIVITY_CODE;
               l_v_bkg_no:=I.BOOKING_NUMBER;
               l_v_eqp_no:=I.EQUIPMENT_NO;
               l_v_local_sts:=I.LOCAL_STATUS;
               l_v_local_term_sts:=I.LOCAL_TERMINAL_STATUS;
               l_v_cont_gross_wt:=I.CONTAINER_GROSS_WEIGHT;
               l_v_vgm := I.VGM;
               l_v_seal_no:=I.SEAL_NO;
               l_v_ovr_hg:=I.OVERHEIGHT_CM;
               l_v_ovr_lf:=I.OVERWIDTH_LEFT_CM;
               l_v_ovr_rt:=I.OVERWIDTH_RIGHT_CM;
               l_v_ovr_ft:=I.OVERLENGTH_FRONT_CM;
               l_v_ovr_rr:=I.OVERLENGTH_REAR_CM;
               l_v_rfr_temp:=I.REEFER_TEMPERATURE;
               l_v_rfr_temp_ut:=I.REEFER_TMP_UNIT;
               l_v_hmdt:=I.HUMIDITY;
               l_v_vent:=I.VENTILATION;
               l_v_stowage_positon:=I.STOWAGE_POSITION;
               l_d_activity_date_time:=I.ACTIVITY_DATE;
/*
        INSERT INTO ECM_LOG_TRACE(
            PROG_ID
            , PROG_SQL
            , RECORD_STATUS
            , RECORD_ADD_USER
            , RECORD_ADD_DATE
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE)
        VALUES
        (
            'EDI'
            ,'1'||SEP||I.EQUIPMENT_NO ||SEP||I.BOOKING_NUMBER
                ||SEP|| TRIM(I.EX_MLO_VESSEL)||SEP||TRIM(I.EX_MLO_VOYAGE)
            ,'A'
            ,'TEST'
            ,SYSDATE
            ,'TEST'
            ,SYSDATE
        );
*/
                g_v_sql_id := 'SQL-02098';
               l_v_ex_mlo_vessel := TRIM(I.EX_MLO_VESSEL);
               l_v_ex_mlo_voyage := TRIM(I.EX_MLO_VOYAGE);

                -- *1 Modified by vikas as suggested by k'chatgamol. 20.02.2012
               IF l_v_local_sts = '6' OR l_v_local_sts = '7' or l_v_local_sts ='T' THEN  -- *1
                  l_v_local_sts :='T';
               else
                  l_v_local_sts :='L';
               end if;

                /*
                    *7 - Modified by vikas, edi should update only handling instruction 1, as k'chatgamol, 08.03.2012
                */
                l_v_handling_instruction1:= NULL; -- *7
                l_v_handling_instruction2:= NULL; -- *7
                l_v_handling_instruction3:= NULL; -- *7

                /*
                    Block started by vikas, Seprate TEXT_DESCRIPTION by '-' and then get handling ins1,2,3,
                    as k'chatgamol, 09.03.2012
                */

                IF I.TEXT_ID = 'HAN' THEN

                    SELECT
                        SUBSTR(I.TEXT_DESCRIPTION, 1, INSTR(I.TEXT_DESCRIPTION, '-')-1)
                    INTO
                        l_v_handling_code
                    FROM
                        DUAL;

                    l_v_handling_instruction1 :=  TRIM(SUBSTR(l_v_handling_code, 1, 2));
                    l_v_handling_code := SUBSTR(l_v_handling_code, 3, LENGTH(l_v_handling_code));

                    l_v_handling_instruction2 := TRIM(SUBSTR(l_v_handling_code, 1, 2));
                    l_v_handling_code := SUBSTR(l_v_handling_code, 3, LENGTH(l_v_handling_code));

                    l_v_handling_instruction3 := TRIM(SUBSTR(l_v_handling_code, 1, 2));
                ELSE
                    l_v_handling_instruction1:= NULL;
                    l_v_handling_instruction2:= NULL;
                    l_v_handling_instruction3:= NULL;
                END IF;

                /*

                * Old logic *
                IF I.TEXT_ID = 'HAN' THEN
                    l_v_handling_instruction1:=SUBSTR(I.TEXT_DESCRIPTION,1,2);
                    -- l_v_handling_instruction2:=SUBSTR(I.TEXT_DESCRIPTION,3,2); -- *7
                    -- l_v_handling_instruction3:=SUBSTR(I.TEXT_DESCRIPTION,5,2); -- *7
                ELSE
                    l_v_handling_instruction1:='';
                    l_v_handling_instruction2:='';
                    l_v_handling_instruction3:='';
                END IF;

                *
                    Block Ended by vikas, 09.03.2012
                */
               IF I.TEXT_ID = 'CLR' THEN
                  l_v_container_loading_rem1:=SUBSTR(I.TEXT_DESCRIPTION,1,17);
                  l_v_container_loading_rem2:=SUBSTR(I.TEXT_DESCRIPTION,18,17);
               ELSE
                  l_v_container_loading_rem1:='';
                  l_v_container_loading_rem2:='';
               END IF;
                g_v_sql_id := 'SQL-02099';
               l_v_haz_mat_class:=I.HAZ_MAT_CLASS;
               l_v_undg_number:=I.UNDG_NUMBER;
               l_v_port_class_code:=I.HAZ_MAT_CODE;
               l_v_port_class_code_Pre:=I.HAZ_MAT_CODE; --*46
              -- l_v_temperature_uom:=I.TEMPERATURE_UOM;

               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '6'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                );*/  --*37

               -- Variable is assigned value of cursor and the same value is used to check for records in tables in ITP063 or Booking_voyage_routing_dtl
               --and if no data found in those tables with this vessel then this variable is assigned value from ITP060.
               --l_v_vessel := I.VESSEL_CODE;
                g_v_sql_id := 'SQL-0201A';
               GET_SVRDIRSEQ
               ( l_v_bkg_no
               , I.VOYAGE_NUMBER
               , I.ACTIVITY_PLACE
               , l_v_act_loc
               , l_v_act_cd
               , l_v_vessel
               , I.VESSEL_NAME
               , p_i_v_ezl   -- added 09.01.2012
               , p_i_v_new_old -- added 09.01.2012
               , l_v_serv
               , l_v_dir
               , l_v_seq_no
               , l_v_ret
               );

               IF l_v_ret = '1' THEN
                  g_v_err_code   := '00';
                  g_v_err_desc   := 'No Data Found in ITP063';
                  v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || g_v_err_code || ' ~ ' || g_v_err_desc, 1, 400);
                  RAISE l_exce_main;
               END IF;

               --DBMS_OUTPUT.PUT_LINE('l_v_act_cd '||l_v_act_cd);

               IF l_v_act_cd = g_v_load_act_code THEN
                  l_v_lldl_flg := 'L';
                  l_n_discharge_list_id := NULL;
                  l_n_overlanded_id :=NULL;
                  g_v_sql_id := 'SQL-02002';
                  --Finding load list id from TOS_LL_LOAD_LIST table.
                  BEGIN
                     SELECT PK_LOAD_LIST_ID
                     INTO l_n_load_list_id
                     FROM TOS_LL_LOAD_LIST
                     WHERE FK_SERVICE        = l_v_serv
                     AND FK_VESSEL           = l_v_vessel
                     AND FK_VOYAGE           = I.VOYAGE_NUMBER
                     AND FK_DIRECTION        = l_v_dir
                     AND FK_PORT_SEQUENCE_NO = l_v_seq_no
                     AND DN_PORT             = I.ACTIVITY_PLACE; -- we can not use terminal here
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        g_v_sql_id := 'SQL-02901';

                        GET_LLDL_ID (I.VOYAGE_NUMBER,l_v_vessel,I.ACTIVITY_PLACE,l_v_act_loc,l_v_serv,l_v_dir,l_v_seq_no,'99','L',l_n_load_list_id);
                        IF l_n_load_list_id = 0 THEN
                           v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                           g_v_err_code   := TO_CHAR(SQLCODE);
                           g_v_err_desc   := 'No Data Found in Load List';
                           RAISE l_exce_main;
                        END IF;
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                  END;
                 /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '9'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                );*/  --*37

                  l_n_load_list_count := l_n_load_list_count + 1;
                  l_tb_load_list(l_n_load_list_count).load_list_id := l_n_load_list_id;
                  g_v_sql_id := 'SQL-02003';
                  --Finding overshipped id from TOS_LL_OVERSHIPPED_CONTAINER table.
                  BEGIN
                     SELECT 1
                          , PK_OVERSHIPPED_CONTAINER_ID
                     INTO   l_n_check
                          , l_n_overshipped_id
                     FROM   TOS_LL_OVERSHIPPED_CONTAINER
                     WHERE  EQUIPMENT_NO    = I.EQUIPMENT_NO
                     AND    FK_LOAD_LIST_ID = l_n_load_list_id;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        SELECT SE_OCZ02.NEXTVAL
                        INTO l_n_overshipped_id
                        FROM DUAL;
                        l_n_check := 0;
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                  END;
                /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '10'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */  --*37

                  g_v_sql_id := 'SQL-02004';
                  --Finding Pre-advice flag from ITP063 and ITP040 tables.
                  BEGIN
                     SELECT TO_DATE(VVSLDT,'RRRRMMDD')+(1/1440*(MOD(VVSLTM, 100)+
                            FLOOR(VVSLTM/100)*60))-(1/1440*(MOD(PIVGMT, 100)+
                             FLOOR(PIVGMT/100)*60)) ARV_DT
                     INTO l_d_sail_date_time
                     FROM ITP063, ITP040
                     WHERE VVPCAL = PICODE
                     AND   VVSRVC = l_v_serv
                     AND   VVVESS = l_v_vessel
                     AND   VVVOYN = I.VOYAGE_NUMBER
                     AND   VVPDIR = l_v_dir
                     AND   VVPCSQ = l_v_seq_no
                     AND   VVVERS = 99;
                  EXCEPTION
                     WHEN OTHERS THEN
                        l_d_sail_date_time := NULL;
                  END;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '11'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                );*/ --*37

                  g_v_sql_id := 'SQL-02005';
                  IF I.RECORD_PROCESSED_DATE > l_d_sail_date_time THEN
                    l_v_preadvice_flg := 'N';
                  ELSE
                     l_v_preadvice_flg := 'Y';
                  END IF;

                  g_v_sql_id := 'SQL-02006';
                  --To calculate error status, Check the existence of record in TOS_LL_BOOKED_LOADING table.
                  BEGIN
                     SELECT COUNT(1)
                     INTO l_n_rec_count
                     FROM TOS_LL_BOOKED_LOADING
                     WHERE DN_EQUIPMENT_NO = I.EQUIPMENT_NO
                     AND FK_LOAD_LIST_ID   = l_n_load_list_id
                     AND LOADING_STATUS    = 'LO';
                  EXCEPTION
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/
                  END;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '12'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

                  g_v_sql_id := 'SQL-02007';
                  IF l_n_rec_count > 0 THEN
                    l_v_da_error_status := 'N';
                  /*

                     l_v_da_error_status := 'Y';
                     l_v_err_code := 'EC004';
                     --g_v_err_desc := 'Container already Loaded in Booked Tab';
                     PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                     , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                     */
                  ElSE
                     l_v_da_error_status := 'N';
                  END IF;
               ELSIF l_v_act_cd = g_v_discharge_act_code THEN
                  l_n_overshipped_id := NULL;
                  l_n_load_list_id := NULL;
                  l_v_lldl_flg := 'D';
                  g_v_sql_id := 'SQL-02008';
                  --Finding discharge list id from TOS_DL_DISCHARGE_LIST table.
                  BEGIN
                     SELECT PK_DISCHARGE_LIST_ID
                     INTO   l_n_discharge_list_id
                     FROM   TOS_DL_DISCHARGE_LIST
                     WHERE  FK_SERVICE          = l_v_serv
                     AND    FK_VESSEL           = l_v_vessel
                     AND    FK_VOYAGE           = I.VOYAGE_NUMBER
                     AND    FK_DIRECTION        = l_v_dir
                     AND    FK_PORT_SEQUENCE_NO = l_v_seq_no
                     AND     DN_PORT             = I.ACTIVITY_PLACE;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        GET_LLDL_ID (I.VOYAGE_NUMBER,l_v_vessel,I.ACTIVITY_PLACE,l_v_act_loc,l_v_serv,l_v_dir,l_v_seq_no,'99','D',l_n_discharge_list_id);
                        IF l_n_discharge_list_id = 0 THEN
                           v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                           g_v_err_code   := TO_CHAR(SQLCODE);
                           g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                           RAISE l_exce_main;
                        END IF;
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                  END;
                 /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '13'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

                  l_n_discharge_list_count := l_n_discharge_list_count + 1;
                  l_tb_discharge_list(l_n_discharge_list_count).discharge_list_id := l_n_discharge_list_id;
                  g_v_sql_id := 'SQL-02009';
                  --Finding overlanded id from TOS_DL_OVERLANDED_CONTAINER table.
                  BEGIN
                     SELECT 1
                          , PK_OVERLANDED_CONTAINER_ID
                     INTO   l_n_check
                          , l_n_overlanded_id
                     FROM   TOS_DL_OVERLANDED_CONTAINER
                     WHERE  EQUIPMENT_NO         = I.EQUIPMENT_NO
                     AND    FK_DISCHARGE_LIST_ID = l_n_discharge_list_id;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        SELECT SE_OCZ01.NEXTVAL
                        INTO l_n_overlanded_id
                        FROM DUAL;
                        l_n_check := 0;
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                  END;
                /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '14'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

                  g_v_sql_id := 'SQL-02010';
                  --Check the existence of record in TOS_DL_BOOKED_DISCHARGE table.
                  BEGIN
                     SELECT COUNT(1)
                     INTO  l_n_rec_count
                     FROM  TOS_DL_BOOKED_DISCHARGE
                     WHERE DN_EQUIPMENT_NO      = I.EQUIPMENT_NO
                     AND   FK_DISCHARGE_LIST_ID = l_n_discharge_list_id
                     AND   DISCHARGE_STATUS     = 'DI';
                  EXCEPTION
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);

                  END;
                  IF l_n_rec_count > 0 THEN
                    l_v_da_error_status := 'N';
                  ElSE
                     l_v_da_error_status := 'N';
                  END IF;
               END IF;

               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '15'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

               --Finding port class type.
               g_v_sql_id := 'SQL-02011';
               BEGIN
                  SELECT PORT_CLASS_TYPE
                  INTO   l_v_port_class_type
                  FROM   PORT_CLASS_TYPE
                  WHERE  PORT_CODE = DECODE(l_v_lldl_flg,'L',I.PORT_OF_LOADING,'D',I.PORT_OF_DISCHARGE)
                  AND    ROWNUM = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_v_port_class_type := 'MPA';
                  WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                     g_v_err_code   := TO_CHAR(SQLCODE);
                     g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                     RAISE l_exce_main;*/
               END;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '16'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

               --Opening EDI detail cursor.

                g_v_sql_id := 'SQL-02017';
                /*
                    Block Start by vikas, Check If booking* is not null then, get special handling from
                    bookings, k'chatgamol, 08.03.2012
                */
                IF I.BOOKING_NUMBER IS NOT NULL THEN
                    BEGIN
                        SELECT
                            SPECIAL_HANDLING
                        INTO
                            L_V_SPECIAL_HANDLING
                        FROM
                            BKP009
                        WHERE
                            BIBKNO = I.BOOKING_NUMBER
                            AND BICTRN = I.EQUIPMENT_NO;

                    EXCEPTION
                        WHEN OTHERS THEN
                            l_v_special_handling := NULL;
                    END ;
                END IF; -- End of null booking* if block

                g_v_sql_id := 'SQL-0217a';

                /*
                    when special_handling is null then use old logic to get special handling.
                */
                IF l_v_special_handling IS NULL THEN

                    IF (l_v_haz_mat_class IS NOT NULL OR l_v_undg_number IS NOT NULL) THEN
                        l_v_special_handling := v_special_handling_dg;

                    ELSIF (I.OVERLENGTH_FRONT_CM <> 0 OR
                        I.OVERLENGTH_REAR_CM  <> 0 OR
                        I.OVERWIDTH_RIGHT_CM  <> 0 OR
                        I.OVERWIDTH_LEFT_CM   <> 0 OR
                        I.OVERHEIGHT_CM       <> 0) THEN

                        l_v_special_handling := v_special_handling_oog;

                    ELSE
                        l_v_special_handling := 'N';

                    END IF;

                END IF; -- End of null special handling if block

                /* *34 start */
                IF (L_V_HAZ_MAT_CLASS IS NOT NULL OR L_V_UNDG_NUMBER IS NOT NULL) THEN
                    L_V_SPECIAL_HANDLING := V_SPECIAL_HANDLING_DG;
                END IF;
                /* *34 end */

                /*
                    * old logic *

                -- special handlimg.
                IF (l_v_haz_mat_class IS NOT NULL OR l_v_undg_number IS NOT NULL) THEN
                    l_v_special_handling := v_special_handling_dg;

                ELSIF (I.OVERLENGTH_FRONT_CM <> 0 OR
                    I.OVERLENGTH_REAR_CM  <> 0 OR
                    I.OVERWIDTH_RIGHT_CM  <> 0 OR
                    I.OVERWIDTH_LEFT_CM   <> 0 OR
                    I.OVERHEIGHT_CM       <> 0) THEN

                    l_v_special_handling := v_special_handling_oog;

                /*
                    Start modified by vikas, when booking is not OOG
                    and not DG then save booking as Normal booking,
                    k'chatgamol, 18.12.2011
                *

                ELSE
                    l_v_special_handling := 'N'; -- normal booking
                /*
                    End modified by vikas, 18.12.2011
                *

                END IF;

                /*
                    Block End by vikas, 08.03.2012
                */

                /*PRE_LOG_INFO
                    ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                    , 'CHECK'
                    , '17'
                    , g_v_user
                    , l_t_log_info
                    , 'STEP EXECUTED'
                    , NULL
                    , NULL
                    , NULL
                    ); */ --*37

                /*
                    Start added by vikas, to reinitialize local variables, 14.12.2011
                */
                l_v_var_validation         := NULL;
                l_v_error_flag             := '0';
                l_n_port_class_val_err     := 1;
                l_n_imdg_val_err           := 1;

                l_v_variant:='-';
                l_v_var_validation := l_v_variant;
                l_port_class := l_v_port_class_code;
                /*
                    End added by vikas, to reinitialize local variables, 14.12.2011
                */

                /*
                    Start Change by vikas, skip validation if sender id is
                    'EZLL_COARRI_CSV', k'chatgamol, 19.12.2011
                */
                BEGIN
                    SELECT COUNT(1)
                    INTO   l_v_send_id
                    FROM   EDI_TRANSACTION_HEADER
                    WHERE  MODULE        = p_i_v_ezl
                    AND    DIRECTION     = 'IN'
                    AND    RECORD_STATUS = 'A'
                    AND    MSG_REFERENCE = K.MSG_REFERENCE
                    AND    STATUS        = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E')
                    AND    SENDER_ID     = ('EZLL_COARRI_CSV');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_send_id := 0;
                    WHEN OTHERS THEN
                        l_v_send_id := 0;
                END;

                /*
                    End added by vikas, 19.12.2011
                */
              /*  *46 */
              BEGIN
                    SELECT COUNT(1)
                    INTO   l_v_send_id_preload
                    FROM   EDI_TRANSACTION_HEADER
                    WHERE  MODULE        = p_i_v_ezl
                    AND    DIRECTION     = 'IN'
                    AND    RECORD_STATUS = 'A'
                    AND    MSG_REFERENCE = K.MSG_REFERENCE
                    AND    STATUS        = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E')
                    AND    SENDER_ID     = ('PSA_PRELOAD');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_send_id_preload := 0;
                    WHEN OTHERS THEN
                        l_v_send_id_preload := 0;
                END;

                If l_v_send_id_preload = 1 then
                    l_v_send_id := 1;
                end if;

              /*  *46 */

               --Finding port class
               g_v_sql_id := 'SQL-02019';
                IF  l_v_undg_number     IS NOT NULL
                    AND l_v_haz_mat_class   IS NOT NULL
                    AND l_v_port_class_type IS NOT NULL THEN

                    l_v_var_validation := NVL (l_v_var_validation, '-');

                    -- Sender is EZLL_COARRI_CSV no need to validate

                    IF l_v_send_id = 0 THEN -- open comment 19.12.2011
                        /*
                            Start Addded by vikas to validate the port class and
                            varient, as K'Chatgamol, 02.12.2011
                        */
                        IF l_port_class IS NOT NULL
                            /*
                                Get variant from available DG details
                            */
                        THEN
                            BEGIN
                                SELECT DISTINCT VARIANT
                                INTO   l_v_var_validation
                                FROM   PORT_CLASS
                                WHERE  IMDG_CLASS      = l_v_haz_mat_class
                                AND    UNNO            = l_v_undg_number
                                AND    PORT_CLASS_TYPE = l_v_port_class_type
                                AND    PORT_CLASS_CODE = l_port_class;

                                l_n_port_class_val_err := 0;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    l_v_error_flag := 1;

                                    l_v_err_code := 'EC019';
                                    l_v_da_error_status := 'Y';

                                    PRE_TOS_ERROR_LOG(
                                        l_v_lldl_flg
                                        , l_n_load_list_id
                                        , l_n_overshipped_id
                                        , l_n_discharge_list_id
                                        , l_n_overlanded_id
                                        , I.BOOKING_NUMBER
                                        , I.EQUIPMENT_NO
                                        , l_v_err_code
                                        , g_v_user
                                        , g_v_user
                                    );

                                    l_port_class := NULL;

                                WHEN OTHERS THEN
                                    l_v_error_flag := 1;
                                    /* Modified by vikas, as no need to show error, k'chatgamol, 13.12.2011 */
                                    NULL;
                                    /*
                                    v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE)
                                        || ' ~ ' || SQLERRM, 1, 400);
                                    */
                            END;
                        /*  When port class is NULL */
                        ELSIF (l_v_haz_mat_class IS NOT NULL OR l_v_undg_number IS NOT NULL) THEN
                            /*
                                Get port class code from available DG details
                                including variant
                            */
                            BEGIN

                                SELECT DISTINCT PORT_CLASS_CODE
                                INTO   l_port_class
                                FROM   PORT_CLASS
                                WHERE  IMDG_CLASS      = l_v_haz_mat_class
                                AND    UNNO            = l_v_undg_number
                                AND    VARIANT         = l_v_var_validation
                                AND    PORT_CLASS_TYPE = l_v_port_class_type;

                                l_n_port_class_val_err := 0;

                            EXCEPTION

                                WHEN NO_DATA_FOUND THEN
                                    /*
                                        Get port class code and variant
                                        from available DG details
                                        without variant
                                    */
                                    BEGIN

                                        SELECT DISTINCT PORT_CLASS_CODE
                                               , VARIANT
                                        INTO   l_port_class
                                                , l_v_var_validation
                                        FROM   PORT_CLASS
                                        WHERE  IMDG_CLASS      = l_v_haz_mat_class
                                        AND    UNNO            = l_v_undg_number
                                        AND    PORT_CLASS_TYPE = l_v_port_class_type;

                                          l_n_port_class_val_err := 0;

                                    EXCEPTION

                                        /*
                                            Port class still not found log error
                                            message
                                        */
                                        WHEN NO_DATA_FOUND THEN
                                            l_v_err_code := 'EC019';
                                            l_v_da_error_status := 'Y';
                                            l_v_error_flag := 1;
                                            PRE_TOS_ERROR_LOG(
                                                l_v_lldl_flg
                                                , l_n_load_list_id
                                                , l_n_overshipped_id
                                                , l_n_discharge_list_id
                                                , l_n_overlanded_id
                                                , I.BOOKING_NUMBER
                                                , I.EQUIPMENT_NO
                                                , l_v_err_code
                                                , g_v_user
                                                , g_v_user
                                            );

                                            l_port_class := NULL;

                                        /*    More then one, port class found,
                                            log error message    */
                                        WHEN TOO_MANY_ROWS THEN

                                             l_port_class := NULL; --*45

                                           /*45  l_v_error_flag := 1; -- if too many error occured then set error flag to 1, 14.12.2011
                                            l_v_err_code := 'EC022';
                                            l_v_da_error_status := 'Y'; */

                                         /*45   PRE_TOS_ERROR_LOG(
                                                l_v_lldl_flg
                                                , l_n_load_list_id
                                                , l_n_overshipped_id
                                                , l_n_discharge_list_id
                                                , l_n_overlanded_id
                                                , I.BOOKING_NUMBER
                                                , I.EQUIPMENT_NO
                                                , l_v_err_code
                                                , g_v_user
                                                , g_v_user
                                            ); */

                                            -- l_v_port_class_code := NULL;
                                        /*    Oracle Error Found    */

                                        WHEN OTHERS THEN
                                        /* Modified by vikas, as no need to show error, k'chatgamol, 13.12.2011 */
                                            l_v_error_flag := 1;
                                            NULL;
                                            /*
                                                v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' ||
                                                    TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                                            */
                                    END; /* End of inner block  */

                                WHEN OTHERS THEN /* for outer block */
                                    /* Modified by vikas, as no need to show error, k'chatgamol, 13.12.2011 */
                                    l_v_error_flag := 1;
                                    NULL;
                                    /*
                                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' ||
                                            TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                                    */
                            END; /* End of outer block    */

                        END IF;
                    END IF; -- end of ezll corarri check, 19.12.2011

                    /*PRE_LOG_INFO
                        ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                        , 'CHECK'
                        , '18'
                        , g_v_user
                        , l_t_log_info
                        , 'STEP EXECUTED'
                        , NULL
                        , NULL
                        , NULL
                        ); */ --*37
/********************** Fields Validations. **************************/
               --Check Equipment Size and Type.
               g_v_sql_id := 'SQL-02020';
               IF I.EQUIPMENT_SIZE_TYPE IS NOT NULL THEN
                  IF l_v_eq_size NOT IN (20, 40, 45) THEN
                     l_v_err_code := 'EC001';
                     --'Equipment Size is incorrect.';
                     l_v_da_error_status := 'Y';
                     PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                     , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                  END IF;
                  g_v_sql_id := 'SQL-02021';
                  BEGIN

                     SELECT 1
                     INTO   l_n_record_found
                     FROM   ITP075
                     WHERE  TRTYPE = l_v_eq_type
                       AND  TRRCST = 'A';
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN

                        l_v_err_code := 'EC002';
                        --'Equipment Type is incorrect.';
                        l_v_da_error_status := 'Y';
                        PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                        , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/
                  END;
               END IF;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '19'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
            /*
                Start commented by vikas, logic is moved 29.12.2011
            *
            --Chech Stowage Position.
            g_v_sql_id := 'SQL-02022';
            IF l_v_stowage_positon IS NOT NULL THEN
            IF MOD(SUBSTR(l_v_stowage_positon, 1, 3), 2) = 1 THEN
                --if first 3 char of stow pos is odd then size type should be 20
                IF l_v_eq_size != 20 THEN
                    l_v_err_code := 'EC003';
                    --g_v_err_desc := 'Size does not match bay number.';
                    l_v_da_error_status := 'Y';
                    PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                    , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                END IF;
            ELSE
                --if first 3 char of stow pos is not odd then size type should be 40 or 45
                IF l_v_eq_size NOT IN (40, 45) THEN
                    l_v_err_code := 'EC003';
                    --g_v_err_desc := 'Size does not match bay number.';
                    l_v_da_error_status := 'Y';
                    PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                    , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                END IF;
            END IF;
            END IF;
            PRE_LOG_INFO
                ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '20'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                );
            g_v_sql_id := 'SQL-02023';
            IF MOD(SUBSTR(l_v_stowage_positon, -2), 2) = 1 THEN
                l_v_err_code := 'EC005';
                --g_v_err_desc := 'Odd tier numbers are reserved for half height containers.';
                l_v_da_error_status := 'Y';
                PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
            END IF;
            PRE_LOG_INFO
                ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '21'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                );

                *
                    End commented by vikas, 29.12.2011
                */
               --Check Shipment Term.
               g_v_sql_id := 'SQL-02024';
               l_n_record_found := 0;
               --Chech Slot Operator.
               g_v_sql_id := 'SQL-02025';
               l_n_record_found := 0;
               IF l_v_slot_operator IS NOT NULL THEN
                  BEGIN
                     SELECT 1
                     INTO   l_n_record_found
                     FROM   OPERATOR_CODE_MASTER
                     WHERE  OPERATOR_CODE = l_v_slot_operator;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        l_v_err_code := 'EC007';
                        --g_v_err_desc := 'Slot Operator is incorrect.';
                        l_v_da_error_status := 'Y';
                        PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                        , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/
                  END;
               END IF;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '22'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
               --Chech Container Operator.
               g_v_sql_id := 'SQL-02026';
               l_n_record_found := 0;
               IF l_v_container_operator IS NOT NULL and l_v_flag_soc_coc='C' THEN
                  BEGIN
                     SELECT 1
                     INTO   l_n_record_found
                     FROM   OPERATOR_CODE_MASTER
                     WHERE  OPERATOR_CODE = l_v_container_operator;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        l_v_err_code := 'EC008';
                        --g_v_err_desc := 'Container Operator is incorrect.';
                        l_v_da_error_status := 'Y';
                        PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                        , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/
                  END;
               END IF;

               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '23'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

                /*
                    *14: Changes start
                */
                /*
                    Block Commented by vikas, when handling instruction code wrong then no to to show error msg.
                    as k'chatgamol, 08.03.2012
                */ -- *14

               --Chech Handling Instruction.
            g_v_sql_id := 'SQL-02027';
            l_n_record_found := 0;
            IF l_v_handling_instruction1 IS NOT NULL THEN
                BEGIN
                    SELECT 1
                    INTO   l_n_record_found
                    FROM   SHP007
                    WHERE  SHI_CODE = l_v_handling_instruction1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_handling_instruction1 := NULL; -- *14

                        -- l_v_err_code := 'EC010';  -- *14
                        -- --g_v_err_desc := 'Handling Instruction1 is incorrect.';  -- *14
                        -- l_v_da_error_status := 'Y';  -- *14
                        -- PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                        --                 , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user); -- *14
                    WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/
                END;
            END IF;
            /*PRE_LOG_INFO
                ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '24'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
            g_v_sql_id := 'SQL-02028';
            l_n_record_found := 0;
            IF l_v_handling_instruction2 IS NOT NULL THEN
                BEGIN
                    SELECT 1
                    INTO   l_n_record_found
                    FROM   SHP007
                    WHERE  SHI_CODE = l_v_handling_instruction2;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_handling_instruction2 := NULL; -- *14

                    --     l_v_err_code := 'EC011';  -- *14
                    --     --g_v_err_desc := 'Handling Instruction2 is incorrect.'; -- *14
                    --     l_v_da_error_status := 'Y'; -- *14
                    --     PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                    --                     , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user); -- *14
                    WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/ -- *14
                END;
            END IF;
            /*PRE_LOG_INFO
                ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '25'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
            g_v_sql_id := 'SQL-02029';
            l_n_record_found := 0;
            IF l_v_handling_instruction3 IS NOT NULL THEN
                BEGIN
                    SELECT 1
                    INTO   l_n_record_found
                    FROM   SHP007
                    WHERE  SHI_CODE = l_v_handling_instruction3;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_handling_instruction3 := NULL; -- *14

                        -- l_v_err_code := 'EC012'; -- *14
                        -- --g_v_err_desc := 'Handling Instruction3 is incorrect.'; -- *14
                        -- l_v_da_error_status := 'Y'; -- *14
                        -- PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                        --                 , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user); -- *14
                    WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/ -- *14
                END;
            END IF;
            /*PRE_LOG_INFO
                ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '26'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

                /* -- *14
                    Block Commented end, 08.03.2012
                */
            --Check Container Loading Remarks.
            g_v_sql_id := 'SQL-02030';
            l_n_record_found := 0;
            IF l_v_container_loading_rem1 IS NOT NULL THEN
                BEGIN
                    SELECT 1
                    INTO   l_n_record_found
                    FROM   SHP041
                    WHERE  CLR_CODE = l_v_container_loading_rem1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_err_code := 'EC013';
                        --g_v_err_desc := 'Container Loading remark1 is incorrect.';
                        l_v_da_error_status := 'Y';
                        PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                        , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                    WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/
                END;
            END IF;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '27'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
               g_v_sql_id := 'SQL-02031';
               l_n_record_found := 0;
               IF l_v_container_loading_rem2 IS NOT NULL THEN
                  BEGIN
                     SELECT 1
                     INTO   l_n_record_found
                     FROM   SHP041
                     WHERE  CLR_CODE = l_v_container_loading_rem2;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        l_v_err_code := 'EC014';
                        --g_v_err_desc := 'Container Loading remark2 is incorrect.';
                        l_v_da_error_status := 'Y';
                        PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                        , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                     WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*/
                  END;
               END IF;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '28'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

                --Check for UNNO
                g_v_sql_id := 'SQL-02032';
                l_n_record_found := 0;
                IF l_v_undg_number IS NOT NULL THEN
                    BEGIN
                    /*-- *50 remove logging
                        PRE_LOG_INFO
                        ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                        , 'CHECK1'
                        , '29.2'
                        , g_v_user
                        , l_t_log_info
                        , l_v_undg_number
                        , NULL
                        , NULL
                        , NULL
                        ); --*/


                        -- Sender is EZLL_COARRI_CSV no need to validate
                        -- IF l_v_send_id = 0 THEN   vikas, 02.12.2011
                        /* End change by vikas, 22.11.2011*/
                            SELECT 1
                            INTO   l_n_record_found
                            FROM   DG_UNNO_CLASS_RESTRICTIONS
                            WHERE  UNNO = l_v_undg_number;
                        -- END IF;                   vikas, 02.12.2011

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            l_v_err_code := 'EC015';
                            --g_v_err_desc := 'UN Number is incorrect.';
                            l_v_da_error_status := 'Y';
                            PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                            , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                        WHEN OTHERS THEN
                            v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
    /*                        g_v_err_code   := TO_CHAR(SQLCODE);
                            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                            RAISE l_exce_main;*/
                    END;
               END IF;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '29'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
            --Check for IMDG

            g_v_sql_id := 'SQL-02034';
            l_n_record_found := 0;
            /*
                IMDG validation

                Modified by vikas, 14.12.2011
            */

            IF (((l_port_class IS NOT NULL AND L_N_PORT_CLASS_VAL_ERR = 1)
                OR (l_port_class IS NULL) )
                AND ( (l_v_haz_mat_class IS NOT NULL) AND
                    (l_v_undg_number IS NOT NULL)
                ))THEN

                /*  Start Added by vikas, validate IMDG, and if IMDG not found then
                    search IMDG without variant detail, chatgamol, 13.12.2011 */
                BEGIN

                    l_v_var_validation := NVL (l_v_var_validation, '-');

                    SELECT 1
                    INTO   l_n_record_found
                    FROM   DG_UNNO_CLASS_RESTRICTIONS
                    WHERE  IMDG_CLASS = l_v_haz_mat_class
                    AND    VARIANT      = l_v_var_validation
                    AND    UNNO         = l_v_undg_number;
                    l_n_imdg_val_err := 0;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        /*  IMDG not found search it without variant and get the
                            actual value of variant    */
                        BEGIN  -- inner block start

                            SELECT DISTINCT VARIANT, 1
                            INTO   l_v_var_validation, l_n_record_found
                            FROM   DG_UNNO_CLASS_RESTRICTIONS
                            WHERE  IMDG_CLASS = l_v_haz_mat_class
                            AND    UNNO         = l_v_undg_number
                            AND    ROWNUM = 1; -- multiple variant not the problem, k'chatgamol, 15.12.2011
                            l_n_imdg_val_err := 0;

                        EXCEPTION
                            /* When imdg and variant not found */
                            WHEN NO_DATA_FOUND THEN
                                l_v_err_code := 'EC017';
                                l_v_error_flag := 1; -- don't update variant
                                --g_v_err_desc := 'IMDG is incorrect.';
                                l_v_da_error_status := 'Y';
                                PRE_TOS_ERROR_LOG(
                                    l_v_lldl_flg,
                                    l_n_load_list_id,
                                    l_n_overshipped_id,
                                    l_n_discharge_list_id,
                                    l_n_overlanded_id,
                                    I.BOOKING_NUMBER,
                                    I.EQUIPMENT_NO,
                                    l_v_err_code,
                                    g_v_user,
                                    g_v_user
                                );
                            /* When other exception found */
                            WHEN OTHERS THEN
                                /* Modified by vikas, as no need to show error, k'chatgamol, 13.12.2011 */
                                l_v_error_flag := 1; -- don't update variant

                                NULL;
                                /*
                                    v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                                */
                        END; -- End of inner block

                    WHEN OTHERS THEN
                        /* Modified by vikas, as no need to show error, k'chatgamol, 13.12.2011 */
                        l_v_error_flag := 1; -- don't update variant
                        NULL;
                        /*
                            v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
                        */
                END; -- End of outer block

            END IF; -- end of imdg if

            /*
                Start added vikas, if port class or imdg validation
                in either case if multiple record found then
                don't update variant, 14.12.2011
            */
            IF l_v_error_flag = 0 THEN
                l_v_variant  := l_v_var_validation;
            END IF;

            /*
                port class is null, get port class from port class table
            */

            IF l_port_class IS NULL    and
                l_n_imdg_val_err = 0 then

                BEGIN
                    SELECT DISTINCT PORT_CLASS_CODE
                    INTO   l_port_class
                    FROM   PORT_CLASS
                    WHERE  IMDG_CLASS      = l_v_haz_mat_class
                    AND    UNNO            = l_v_undg_number
                    AND    PORT_CLASS_TYPE = l_v_port_class_type
                    AND    VARIANT         = l_v_var_validation;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        /*
                            Port class not found
                        */
                        l_v_err_code := 'EC021';
                        l_v_da_error_status := 'Y';

                        PRE_TOS_ERROR_LOG(
                            l_v_lldl_flg
                            , l_n_load_list_id
                            , l_n_overshipped_id
                            , l_n_discharge_list_id
                            , l_n_overlanded_id
                            , I.BOOKING_NUMBER
                            , I.EQUIPMENT_NO
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                        );
                    WHEN TOO_MANY_ROWS THEN
                        /*
                            Multiple port class found.
                        */
                         l_port_class := NULL; --*45
                  /*45       l_v_err_code := 'EC022';
                        l_v_da_error_status := 'Y'; */

                   /*45     PRE_TOS_ERROR_LOG(
                            l_v_lldl_flg
                            , l_n_load_list_id
                            , l_n_overshipped_id
                            , l_n_discharge_list_id
                            , l_n_overlanded_id
                            , I.BOOKING_NUMBER
                            , I.EQUIPMENT_NO
                            , l_v_err_code
                            , g_v_user
                            , g_v_user
                        ); */
                    WHEN OTHERS THEN
                        NULL;
                END;
            END IF;

            /*
                if port class is successfuly validated then show the port class
                else show null
            */
            /*
                Modify condition if sender is EZLL_CORRAI then no need to update
                port class, as k'chatgamol, 19.12.2011
            */
            IF l_n_port_class_val_err = 0 AND l_v_error_flag = 0  AND  l_v_send_id = 1 THEN
               if l_v_send_id_preload = 1 then  -- *46
                 l_v_port_class_code := l_v_port_class_code_PRE;  --*46
               Else  -- *46
                l_v_port_class_code := l_port_class;
               End if; -- *46

            -- ELSE -- *25
            ELSIF (NVL(l_v_port_class_code, SEP) <> NVL(l_port_class, SEP) ) THEN -- *25
                l_v_port_class_code := NULL;
            END IF;

            /*
                End added by vikas, 14.12.2011
            */

                /* comment start
                BEGIN
                    PRE_LOG_INFO
                        ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                        , 'CHECK1'
                        , '29.1'
                        , g_v_user
                        , l_t_log_info
                        , l_v_haz_mat_class||SEP||l_v_variant||SEP||l_v_undg_number
                        , NULL
                        , NULL
                        , NULL
                    );


                /* Start Change by vikas, skip validation if sender id is
                'EZLL_COARRI_CSV', k'chatgamol, 22.11.2011 *
                    BEGIN
                        SELECT COUNT(1)
                        INTO   l_v_send_id
                        FROM   EDI_TRANSACTION_HEADER
                        WHERE  MODULE        = p_i_v_ezl
                        AND    DIRECTION     = 'IN'
                        AND    RECORD_STATUS = 'A'
                        AND    MSG_REFERENCE = K.MSG_REFERENCE
                        AND    STATUS        = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E')
                        AND    SENDER_ID     = 'EZLL_COARRI_CSV';
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            l_v_send_id := 0;
                        WHEN OTHERS THEN
                            l_v_send_id := 0;
                    END;

                    -- Sender is EZLL_COARRI_CSV no need to validate
                    -- IF l_v_send_id = 0 THEN         vikas, 02.12.2011
                    /* End change by vikas, 22.11.2011*
                        SELECT 1
                        INTO   l_n_record_found
                        FROM   DG_UNNO_CLASS_RESTRICTIONS
                        WHERE  IMDG_CLASS = l_v_haz_mat_class
                        AND    VARIANT      = l_v_variant
                        AND    UNNO         = l_v_undg_number;
                    -- END IF;  vikas, 02.12.2011

                    PRE_LOG_INFO
                        ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                        , 'CHECK'
                        , '29.1'
                        , g_v_user
                        , l_t_log_info
                        , l_v_haz_mat_class||SEP||l_v_variant||SEP||l_v_undg_number
                        , NULL
                        , NULL
                        , NULL
                    );
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_err_code := 'EC017';
                        --g_v_err_desc := 'IMDG is incorrect.';
                        l_v_da_error_status := 'Y';
                        PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                        , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                    WHEN OTHERS THEN
                        v_info := SUBSTR ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND: ' || TO_CHAR (SQLCODE) || ' ~ ' || SQLERRM, 1, 400);
/*                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;*
                END;


                *  End Added by vikas, k'chatgamol, 13.12.2011 */
            ELSE  -- aks 10Jun1 1  IF DG Info is not present then Port Class Type and Variant should be null
                    l_v_port_class_type := NULL;
                    l_v_variant         := NULL;
            END IF;
            /*PRE_LOG_INFO
                ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '30'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

            --Check for SOC/COC
            g_v_sql_id := 'SQL-02035';
--               l_n_record_found := 0;
            IF l_v_flag_soc_coc = 'C' THEN
                g_v_sql_id := 'SQL02035A';
                IF PCE_EUT_COMMON.FN_CHECK_COC_FLAG(
                        I.EQUIPMENT_NO
                        , I.PORT_OF_LOADING
                        -- , TO_CHAR(l_d_sail_date_time,'YYYYMMDD') -- *31
                        , TO_CHAR(l_d_sail_date_time,'DD/MM/YYYY') -- *31
                        , TO_CHAR(l_d_sail_date_time,'HH24MM')
                        -- , l_v_return_status -- *31
                        , l_v_error_status -- *31
                ) = FALSE THEN
                    g_v_sql_id := 'SQL02035B';
                    l_v_err_code := 'EC020';
                    --g_v_err_desc := 'Equipment type should not be COC.';
                    l_v_da_error_status := 'Y';
                    PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                    , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                    g_v_sql_id := 'SQL02035C';
                END IF;

                g_v_sql_id := 'SQL02035D';
                IF PCE_EUT_COMMON.FN_CHECK_COC_FLAG(
                        I.EQUIPMENT_NO
                        , I.PORT_OF_LOADING
                        -- , TO_CHAR(l_d_sail_date_time,'YYYYMMDD') -- *31
                        , TO_CHAR(l_d_sail_date_time,'DD/MM/YYYY') -- *31
                        , TO_CHAR(l_d_sail_date_time,'HH24MM')
                        -- , l_v_return_status -- *31
                        , l_v_error_status -- *31
                ) = TRUE THEN
                    g_v_sql_id := 'SQL02035E';
                    l_v_container_operator:='RCL';
                END IF;

                g_v_sql_id := 'SQL02035F';
            END IF;
            g_v_sql_id := 'SQL02035G';
            l_v_return_status := NULL;

            /*PRE_LOG_INFO
                ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '31'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37

                /*
                    initialize local variable
                */
                g_v_sql_id := 'SQL02035H';
                l_v_midstream := NULL; --*16

                g_v_sql_id := 'SQL02035I';

                /* ADDED FOR CR, PD_CR_13102011-01_Hong Kong Midstream Operation*/
                IF I.TEXT_ID = 'AAI' THEN
                    IF I.TEXT_CODE = 'CY' THEN
                        l_v_midstream  := 'CY';-- Local Yard
                    ELSIF I.TEXT_CODE = 'T2' THEN
                        l_v_midstream  := 'T2'; -- LONG STAY TRANSHIPMENT
                    ELSIF I.TEXT_CODE = 'T3' THEN
                        l_v_midstream  :=  'T3'; -- STAY TRANSHIPMENT
                    ELSIF I.TEXT_CODE = 'T4' THEN
                        l_v_midstream  := 'T4'; --  (WITHIN 2 DAYS) TRANSHIPMENT
                    ELSIF I.TEXT_CODE = 'T5' THEN
                        l_v_midstream  := 'T5'; --OVERFLOW-RIVER CRAFT  (FLOATING YARD)
                    ELSIF I.TEXT_CODE = 'T6' THEN
                        l_v_midstream  := 'T6'; -- KWAI CHUNG TERMINAL   (BLOCK TRANSFER TO/FM TERMINAL)
                    ELSIF I.TEXT_CODE = 'T7' THEN
                        l_v_midstream  := 'T7';  -- TACKLE
                    END IF;
                END IF;
                g_v_sql_id := 'SQL02035J';
                /*
                    Start added by vikas, to get user id
                    if sender is EZLL_CORRAI (upload) then
                    save record change user as EDIU otherwise EDIT,
                    k'chatgamol, 19.12.2011
                */
                BEGIN
                    SELECT
                        DECODE(l_v_send_id, 0,'EDIT', 'EDIU')
                    INTO
                        l_v_change_user
                    FROM
                        DUAL;
                EXCEPTION
                    WHEN OTHERS THEN
                        l_v_change_user := 'EDIT';
                END;

                g_v_sql_id := 'SQL02035K';
                /*
                    End added by vikas, 19.12.2011
                */

                /* END ADDED FOR CR */

            /*
                Start added by vikas to check stowage pos. validate
                for discharge list, 29.12.2011
            */
               IF l_v_stowage_positon IS NOT NULL THEN
                    g_v_sql_id := 'SQL02035L';
                   IF MOD(SUBSTR(l_v_stowage_positon, 1, 3), 2) = 1 THEN
                      --if first 3 char of stow pos is odd then size type should be 20

                        g_v_sql_id := 'SQL02035M';
                      IF l_v_eq_size != 20 THEN
                        g_v_sql_id := 'SQL02035N';
                         l_v_err_code := 'EC003';
                         --g_v_err_desc := 'Size does not match bay number.';
                         l_v_da_error_status := 'Y';
                         PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                         , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                      END IF;
                   ELSE
                    g_v_sql_id := 'SQL02035O';
                      --if first 3 char of stow pos is not odd then size type should be 40 or 45
                      IF l_v_eq_size NOT IN (40, 45) THEN
                         l_v_err_code := 'EC003';
                         --g_v_err_desc := 'Size does not match bay number.';
                         l_v_da_error_status := 'Y';
                         PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                         , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
                      END IF;
                   END IF;
               END IF;

               g_v_sql_id := 'SQL02035P';
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '20'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
               g_v_sql_id := 'SQL-02023';
               IF MOD(SUBSTR(l_v_stowage_positon, -2), 2) = 1 THEN
                  l_v_err_code := 'EC005';
                  --g_v_err_desc := 'Odd tier numbers are reserved for half height containers.';
                  l_v_da_error_status := 'Y';
                  PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
                                  , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);
               END IF;
               /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '21'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
                /*
                    End added by vikas, 29.12.2011
                */
               IF l_v_lldl_flg = 'L' THEN

                  --DBMS_OUTPUT.PUT_LINE('l_v_lldl_flg: '||l_v_lldl_flg);

                  g_v_sql_id := 'SQL-02036';

                  IF l_n_check = 1 THEN
                    /*PRE_LOG_INFO
                     ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                    , 'CHECK'
                    , '31.1'
                    , g_v_user
                    , l_t_log_info
                    , 'STEP EXECUTED'
                    , NULL
                    , NULL
                    , NULL
                    ); */ --*37

                /*  Start Added by vikas, midstream should be null if
                    it has value '-', k'chatgamol, 24.11.2011 */
                    SELECT DECODE (l_v_midstream, '-', NULL, l_v_midstream)
                    INTO l_v_midstream
                    FROM DUAL;
                /*     End Added by vikas24.11.2011 */

  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 UPDATE LL_OVERSHIP TAB'
                                                   ,'START : ' || SYSDATE
                                                   ); --*/

                     UPDATE TOS_LL_OVERSHIPPED_CONTAINER
                     SET  FK_LOAD_LIST_ID                = l_n_load_list_id
                        , BOOKING_NO                     = l_v_bkg_no
                        , BOOKING_NO_SOURCE              = 'E'
                        , EQUIPMENT_NO                   = l_v_eqp_no
                        --, EQUIPMENT_NO_QUESTIONABLE_FLAG =
                        , EQ_SIZE                        = l_v_eq_size
                        , EQ_TYPE                        = l_v_eq_type
                        , FULL_MT                        = l_v_full_mt
                        --, BKG_TYP                        =
                        , FLAG_SOC_COC                   = l_v_flag_soc_coc
                        --, SHIPMENT_TERM                  =
                        --, SHIPMENT_TYPE                  =
                        , LOCAL_STATUS                   = l_v_local_sts
                        , LOCAL_TERMINAL_STATUS          = l_v_local_term_sts
                         , MIDSTREAM_HANDLING_CODE        =  l_v_midstream
                        --, LOAD_CONDITION                 =
                        , STOWAGE_POSITION               = l_v_stowage_positon
                        , ACTIVITY_DATE_TIME             = l_d_activity_date_time
                        , CONTAINER_GROSS_WEIGHT         = l_v_cont_gross_wt
                        , VGM                            = l_v_vgm
                        --, DAMAGED                        =
                        --, VOID_SLOT                      =
                        , PREADVICE_FLAG                 = l_v_preadvice_flg
                        , SLOT_OPERATOR                  = l_v_slot_operator
                        , CONTAINER_OPERATOR             = l_v_container_operator
                        , OUT_SLOT_OPERATOR              = l_v_out_slot_operator
                        , SPECIAL_HANDLING               = l_v_special_handling
                        , SEAL_NO                        = l_v_seal_no
                        , DISCHARGE_PORT                 = l_v_ll_pod
                        , POD_TERMINAL                   = l_v_ll_pod_terminal
                        --, NXT_POD1                     =
                        --, NXT_POD2                     =
                        --, NXT_POD3                     =
                        , FINAL_POD                      = l_v_final_pod
                        --, FINAL_DEST                     =
                        --, NXT_SRV                        =
                        --, NXT_VESSEL                     =
                        --, NXT_VOYAGE                     =
                        --, NXT_DIR                        =
                        --, MLO_VESSEL                     =
                        --, MLO_VOYAGE                     =
                        --, MLO_VESSEL_ETA                 =
                        --, MLO_POD1                       =
                        --, MLO_POD2                       =
                        --, MLO_POD3                       =
                        --, MLO_DEL                        =
                          , EX_MLO_VESSEL                  =  trim(l_v_ex_mlo_vessel)  -- uncommented, 22.12.2011
                        --, EX_MLO_VESSEL_ETA              =
                          , EX_MLO_VOYAGE                  =  trim(l_v_ex_mlo_voyage)  -- uncommented, 22.12.2011
                        , HANDLING_INSTRUCTION_1         = l_v_handling_instruction1
                        , HANDLING_INSTRUCTION_2         = l_v_handling_instruction2
                        , HANDLING_INSTRUCTION_3         = l_v_handling_instruction3
                        , CONTAINER_LOADING_REM_1        = l_v_container_loading_rem1
                        , CONTAINER_LOADING_REM_2        = l_v_container_loading_rem2
                        --, SPECIAL_CARGO                  =
                        , IMDG_CLASS                     = l_v_haz_mat_class
                        , UN_NUMBER                      = l_v_undg_number
                        , UN_NUMBER_VARIANT              = l_v_variant
                        , PORT_CLASS                     = l_v_port_class_code
                        , PORT_CLASS_TYPE                = l_v_port_class_type
                        --, FLASHPOINT_UNIT                = l_v_temperature_uom
                        --, FLASHPOINT                     = l_n_flashpoint
                        --, FUMIGATION_ONLY                =
                        --, RESIDUE_ONLY_FLAG              = l_v_residue
                        , OVERHEIGHT_CM                  = l_v_ovr_hg
                        , OVERWIDTH_LEFT_CM              = l_v_ovr_lf
                        , OVERWIDTH_RIGHT_CM             = l_v_ovr_rt
                        , OVERLENGTH_FRONT_CM            = l_v_ovr_ft
                        , OVERLENGTH_REAR_CM             = l_v_ovr_rr
                        , REEFER_TEMPERATURE             = l_v_rfr_temp
                        , REEFER_TMP_UNIT                = l_v_rfr_temp_ut
                        --, HUMIDITY                       = l_v_hmdt
                        --, VENTILATION                    = l_v_vent
                        , DA_ERROR                       = l_v_da_error_status
                        , RECORD_STATUS                  = 'A'
                        , RECORD_ADD_USER                = l_v_change_user -- g_v_user -- modified, 19.12.2011
                        , RECORD_ADD_DATE                = l_d_time
                        , RECORD_CHANGE_USER             =  l_v_change_user -- g_v_user -- modified, 19.12.2011
                        , RECORD_CHANGE_DATE             = l_d_time
                        , TRADING_PARTNER                = I.TRADING_PARTNER --*50
                     WHERE PK_OVERSHIPPED_CONTAINER_ID   = l_n_overshipped_id;
                  /*--*50 remove logging
                     PRE_LOG_INFO
                        ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                       , 'TOS_LL_OVERSHIPPED_CONTAINER'
                       , g_v_sql_id
                       , g_v_user
                       , l_t_log_info
                       , 'UPDATE CALLED'
                       , NULL
                       , NULL
                       , NULL
                        ); --*/

  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER UPDATE LL_OVERSHIP TAB'
                                                   ,'END : ' || SYSDATE
                                                   ); --*/
                  ELSE
                     g_v_sql_id := 'SQL-02037';
                   /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '31.2'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
                /*
                    Start Added by vikas, midstream should be null if
                    it has value '-', k'chatgamol, 24.11.2011 */
                    SELECT DECODE (l_v_midstream, '-', NULL, l_v_midstream)
                    INTO l_v_midstream
                    FROM DUAL;
                /*     End Added by vikas24.11.2011 */
	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 INSERT INTO OVERSHIPPED TAB '
                                                   ,'START : ' || SYSDATE
                                                   ); --*/

                     INSERT INTO TOS_LL_OVERSHIPPED_CONTAINER
                            (PK_OVERSHIPPED_CONTAINER_ID, FK_LOAD_LIST_ID, BOOKING_NO, BOOKING_NO_SOURCE, EQUIPMENT_NO
                           , EQ_SIZE, EQ_TYPE, FULL_MT, FLAG_SOC_COC, LOCAL_STATUS, LOCAL_TERMINAL_STATUS
                           , STOWAGE_POSITION, ACTIVITY_DATE_TIME, CONTAINER_GROSS_WEIGHT
                           , VGM --#01
                           , PREADVICE_FLAG, SLOT_OPERATOR, CONTAINER_OPERATOR, OUT_SLOT_OPERATOR
                           , SPECIAL_HANDLING, SEAL_NO, DISCHARGE_PORT, POD_TERMINAL, FINAL_POD
                           , HANDLING_INSTRUCTION_1, HANDLING_INSTRUCTION_2, HANDLING_INSTRUCTION_3
                           , CONTAINER_LOADING_REM_1, CONTAINER_LOADING_REM_2, IMDG_CLASS, UN_NUMBER, UN_NUMBER_VARIANT
                           , PORT_CLASS, PORT_CLASS_TYPE, FLASHPOINT_UNIT, FLASHPOINT
                           , RESIDUE_ONLY_FLAG, OVERHEIGHT_CM, OVERWIDTH_LEFT_CM, OVERWIDTH_RIGHT_CM
                           , OVERLENGTH_FRONT_CM, OVERLENGTH_REAR_CM, REEFER_TEMPERATURE, REEFER_TMP_UNIT
                           , HUMIDITY, VENTILATION, DA_ERROR, RECORD_STATUS, RECORD_ADD_USER, RECORD_ADD_DATE
                           , RECORD_CHANGE_USER, RECORD_CHANGE_DATE
                            , MIDSTREAM_HANDLING_CODE
                          , EX_MLO_VESSEL  -- added 20.12.2011
                          , EX_MLO_VOYAGE  -- added 20.12.2011
                          , TRADING_PARTNER --*50


                           )
                      VALUES (l_n_overshipped_id, l_n_load_list_id, l_v_bkg_no, 'E', l_v_eqp_no
                            , l_v_eq_size, l_v_eq_type, l_v_full_mt, l_v_flag_soc_coc, l_v_local_sts, l_v_local_term_sts
                            , l_v_stowage_positon, l_d_activity_date_time, l_v_cont_gross_wt
                            , l_v_vgm --#01
                            , l_v_preadvice_flg, l_v_slot_operator, l_v_container_operator, l_v_out_slot_operator
                            , l_v_special_handling, l_v_seal_no, l_v_ll_pod, l_v_ll_pod_terminal , l_v_final_pod
                            , l_v_handling_instruction1, l_v_handling_instruction2, l_v_handling_instruction3
                            , l_v_container_loading_rem1, l_v_container_loading_rem2, l_v_haz_mat_class, l_v_undg_number, l_v_variant
                            , l_v_port_class_code, l_v_port_class_type, l_v_temperature_uom, l_n_flashpoint
                            , l_v_residue, l_v_ovr_hg, l_v_ovr_lf, l_v_ovr_rt
                            , l_v_ovr_ft, l_v_ovr_rr, l_v_rfr_temp, l_v_rfr_temp_ut
                            , l_v_hmdt, l_v_vent, l_v_da_error_status, 'A'
                            , DECODE(l_v_send_id,0,'EDIT', 'EDIU')  -- g_v_user -- modified, 19.12.2011
                            , l_d_time
                            , DECODE(l_v_send_id, 0, 'EDIT', 'EDIU') -- g_v_user -- modified, 19.12.2011
                            , l_d_time
                            , l_v_midstream
                            , trim(l_v_ex_mlo_vessel)  -- added, 22.12.2011
                            , trim(l_v_ex_mlo_voyage)  -- added, 22.12.2011
                            , I.TRADING_PARTNER --*50
                            );
                         /*PRE_LOG_INFO
                            ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                           , 'TOS_LL_OVERSHIPPED_CONTAINER'
                           , g_v_sql_id
                           , g_v_user
                           , l_t_log_info
                           , 'INSERT CALLED'
                           , NULL
                           , NULL
                           , NULL
                            ); */ --*37
	/*--  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER INSERT INTO OVERSHIPPED TAB '
                                                   ,'END : ' || SYSDATE
                                                   ); --*/
                  END IF;
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
                        l_n_load_list_id
                        , 'L'
                        , g_v_err_code
                    );
               ELSIF l_v_lldl_flg = 'D' THEN

                  --DBMS_OUTPUT.PUT_LINE('l_v_lldl_flg: '||l_v_lldl_flg);

                  g_v_sql_id := 'SQL-02038';

                -- For discharge list
                  IF l_n_check = 1 THEN
                    /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '31.3'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
                /*     Start Added by vikas, midstream should be null if
                    it has value '-', k'chatgamol, 24.11.2011 */
                    SELECT DECODE (l_v_midstream, '-', NULL, l_v_midstream)
                    INTO l_v_midstream
                    FROM DUAL;
                /*     End Added by vikas24.11.2011 */
	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 UPDATE INTO OVERLANDDED_CONTAINER '
                                                   ,'START : ' || SYSDATE
                                                   );--*/

                UPDATE TOS_DL_OVERLANDED_CONTAINER
                     SET FK_DISCHARGE_LIST_ID       = l_n_discharge_list_id
                       , BOOKING_NO                 = l_v_bkg_no
                       , EQUIPMENT_NO               = l_v_eqp_no
                       , EQ_SIZE                    = l_v_eq_size
                       , EQ_TYPE                    = l_v_eq_type
                       , FULL_MT                    = l_v_full_mt
                       --, BKG_TYP                    =
                       , FLAG_SOC_COC               = l_v_flag_soc_coc
                       --, SHIPMENT_TERM              =
                       --, SHIPMENT_TYP               =
                       , LOCAL_STATUS               = l_v_local_sts
                       , LOCAL_TERMINAL_STATUS      = l_v_local_term_sts
                       , MIDSTREAM_HANDLING_CODE    = l_v_midstream
                       --, LOAD_CONDITION             =
                       , STOWAGE_POSITION           = l_v_stowage_positon
                       , ACTIVITY_DATE_TIME         = l_d_activity_date_time
                       , CONTAINER_GROSS_WEIGHT     = l_v_cont_gross_wt
                       , VGM                        = l_v_vgm   --#01
                       --, DAMAGED                    =
                       --, VOID_SLOT                  =
                       , SLOT_OPERATOR              = l_v_slot_operator
                       , CONTAINER_OPERATOR         = l_v_container_operator
                       , OUT_SLOT_OPERATOR          = l_v_out_slot_operator
                       , SPECIAL_HANDLING           = l_v_special_handling
                       , SEAL_NO                    = l_v_seal_no
                       , POL                        = l_v_dl_pol
                       , POL_TERMINAL               = l_v_dl_pol_terminal
                       --, NXT_POD1                   =
                       --, NXT_POD2                   =
                       --, NXT_POD3                   =
                       , FINAL_POD                  = l_v_final_pod
                       --, FINAL_DEST                 =
                       --, NXT_SRV                    =
                       --, NXT_VESSEL                 =
                       --, NXT_VOYAGE                 =
                       --, NXT_DIR                    =
                       --, MLO_VESSEL                 =
                       --, MLO_VOYAGE                 =
                       --, MLO_VESSEL_ETA             =
                       --, MLO_POD1                   =
                       --, MLO_POD2                   =
                       --, MLO_POD3                   =
                       --, MLO_DEL                    =
                       , HANDLING_INSTRUCTION_1     = l_v_handling_instruction1
                       , HANDLING_INSTRUCTION_2     = l_v_handling_instruction2
                       , HANDLING_INSTRUCTION_3     = l_v_handling_instruction3
                       , CONTAINER_LOADING_REM_1    = l_v_container_loading_rem1
                       , CONTAINER_LOADING_REM_2    = l_v_container_loading_rem2
                       --, SPECIAL_CARGO              =
                       , IMDG_CLASS                 = l_v_haz_mat_class
                       , UN_NUMBER                  = l_v_undg_number
                       , UN_NUMBER_VARIANT          = l_v_variant
                       , PORT_CLASS                 = l_v_port_class_code
                       , PORT_CLASS_TYP             = l_v_port_class_type
                       --, FLASHPOINT_UNIT            = l_v_temperature_uom
                       --, FLASHPOINT                 = l_n_flashpoint
                       --, FUMIGATION_ONLY            =
                       --, RESIDUE_ONLY_FLAG          = l_v_residue
                       , OVERHEIGHT_CM              = l_v_ovr_hg
                       , OVERWIDTH_LEFT_CM          = l_v_ovr_lf
                       , OVERWIDTH_RIGHT_CM         = l_v_ovr_rt
                       , OVERLENGTH_FRONT_CM        = l_v_ovr_ft
                       , OVERLENGTH_REAR_CM         = l_v_ovr_rr
                       , REEFER_TEMPERATURE         = l_v_rfr_temp
                       , REEFER_TMP_UNIT            = l_v_rfr_temp_ut
                       --, HUMIDITY                   = l_v_hmdt
                       --, VENTILATION                = l_v_vent
                       , DA_ERROR                   = l_v_da_error_status
                       , RECORD_STATUS              = 'A'
                       , RECORD_ADD_USER            = l_v_change_user -- g_v_user -- modified, 19.12.2011
                       , RECORD_ADD_DATE            = l_d_time
                       , RECORD_CHANGE_USER         = l_v_change_user -- g_v_user -- modified, 19.12.2011
                       , RECORD_CHANGE_DATE         = l_d_time
                     WHERE PK_OVERLANDED_CONTAINER_ID = l_n_overlanded_id;
                     /*PRE_LOG_INFO
                      ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                     , 'TOS_DL_OVERLANDED_CONTAINER'
                     , g_v_sql_id
                     , g_v_user
                     , l_t_log_info
                     , 'UPDATE CALLED'
                     , NULL
                     , NULL
                     , NULL
                      ); */ --*37

	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER UPDATE INTO OVERLANDDED_CONTAINER '
                                                   ,'END : ' || SYSDATE
                                                   ); --*/
                  ELSE
                             /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '31.4'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
                /*     Start Added by vikas, midstream should be null if
                    it has value '-', k'chatgamol, 24.11.2011 */
                    SELECT DECODE (l_v_midstream, '-', NULL, l_v_midstream)
                    INTO l_v_midstream
                    FROM DUAL;
                /*     End Added by vikas24.11.2011 */

                /*
                    INSERT INTO ECM_LOG_TRACE(
                        PROG_ID
                        , PROG_SQL
                        , RECORD_STATUS
                        , RECORD_ADD_USER
                        , RECORD_ADD_DATE
                        , RECORD_CHANGE_USER
                        , RECORD_CHANGE_DATE)
                    VALUES
                    (
                        'EDI'
                        ,'OVERLANDED~'||l_n_discharge_list_id
                            ||'~'||l_v_eqp_no
                            ||'~'||TO_CHAR(l_d_activity_date_time, 'YYYYMMDD HH24MI')
                        ,'A'
                        ,'TEST'
                        ,SYSDATE
                        ,'TEST'
                        ,SYSDATE
                    );

                */
                    g_v_sql_id := 'SQL-02039';
	 /*- VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 INSERT INTO OVERLANDDED_CONTAINER '
                                                   ,'START : ' || SYSDATE
                                                   ); --*/
                     INSERT INTO TOS_DL_OVERLANDED_CONTAINER
                            (PK_OVERLANDED_CONTAINER_ID, FK_DISCHARGE_LIST_ID, BOOKING_NO, EQUIPMENT_NO
                           , EQ_SIZE, EQ_TYPE, FULL_MT, FLAG_SOC_COC, LOCAL_STATUS, LOCAL_TERMINAL_STATUS
                           , STOWAGE_POSITION, ACTIVITY_DATE_TIME, CONTAINER_GROSS_WEIGHT
                           , VGM    --#01
                           , SLOT_OPERATOR
                           , CONTAINER_OPERATOR, OUT_SLOT_OPERATOR, SPECIAL_HANDLING, SEAL_NO, POL, POL_TERMINAL
                           , FINAL_POD, HANDLING_INSTRUCTION_1, HANDLING_INSTRUCTION_2, HANDLING_INSTRUCTION_3
                           , CONTAINER_LOADING_REM_1, CONTAINER_LOADING_REM_2, IMDG_CLASS, UN_NUMBER, UN_NUMBER_VARIANT
                           , PORT_CLASS, PORT_CLASS_TYP, FLASHPOINT_UNIT, FLASHPOINT, RESIDUE_ONLY_FLAG, OVERHEIGHT_CM
                           , OVERWIDTH_LEFT_CM, OVERWIDTH_RIGHT_CM, OVERLENGTH_FRONT_CM, OVERLENGTH_REAR_CM
                           , REEFER_TEMPERATURE, REEFER_TMP_UNIT, HUMIDITY, VENTILATION, DA_ERROR, RECORD_STATUS
                           , RECORD_ADD_USER, RECORD_ADD_DATE, RECORD_CHANGE_USER, RECORD_CHANGE_DATE
                            , MIDSTREAM_HANDLING_CODE
                           )
                      VALUES(l_n_overlanded_id, l_n_discharge_list_id, l_v_bkg_no, l_v_eqp_no
                           , l_v_eq_size, l_v_eq_type, l_v_full_mt, l_v_flag_soc_coc, l_v_local_sts, l_v_local_term_sts
                           , l_v_stowage_positon, l_d_activity_date_time, l_v_cont_gross_wt
                           , l_v_vgm    --#01
                           , l_v_slot_operator
                           , l_v_container_operator, l_v_out_slot_operator, l_v_special_handling, l_v_seal_no, l_v_dl_pol
                           , l_v_dl_pol_terminal
                           , l_v_final_pod, l_v_handling_instruction1, l_v_handling_instruction2, l_v_handling_instruction3
                           , l_v_container_loading_rem1, l_v_container_loading_rem2, l_v_haz_mat_class, l_v_undg_number, l_v_variant
                           , l_v_port_class_code, l_v_port_class_type, l_v_temperature_uom, l_n_flashpoint , l_v_residue, l_v_ovr_hg
                           , l_v_ovr_lf, l_v_ovr_rt, l_v_ovr_ft, l_v_ovr_rr
                           , l_v_rfr_temp, l_v_rfr_temp_ut, l_v_hmdt, l_v_vent, l_v_da_error_status, 'A'
                           , DECODE(l_v_send_id,0, 'EDIT', 'EDIU') -- g_v_user modified by vikas, 19.12.2011
                           , l_d_time
                           , DECODE(l_v_send_id,0, 'EDIT', 'EDIU') -- g_v_user modified by vikas, 19.12.2011
                           , l_d_time
                           , l_v_midstream
                            );
                     /*PRE_LOG_INFO
                     ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                    , 'TOS_DL_OVERLANDED_CONTAINER'
                    , g_v_sql_id
                    , g_v_user
                    , l_t_log_info
                    , 'INSERT CALLED'
                    , NULL
                    , NULL
                    , NULL
                     ); */ --*37
	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER INSERT INTO OVERLANDDED_CONTAINER '
                                                   ,'END : ' || SYSDATE
                                                   ); --*/
                  END IF;
                             /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '31.5'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
                    l_n_discharge_list_id
                    , 'D'
                    , g_v_err_code
                );
                             /*PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , 'CHECK'
                , '31.6'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                ); */ --*37
                END IF;
                    /*PRE_LOG_INFO
                    ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                   , 'CHECK'
                   , '32'
                   , g_v_user
                   , l_t_log_info
                   , 'STEP EXECUTED'
                   , NULL
                   , NULL
                   , NULL
                   ); */ --*37

                    /*PRE_LOG_INFO
                    ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                   , 'CHECK'
                   , '33'
                   , g_v_user
                   , l_t_log_info
                   , 'STEP EXECUTED'
                   , NULL
                   , NULL
                   , NULL
                   ); */ --*37

               l_v_dt_sts := 'S';
               l_v_tr_sts  := l_v_dt_sts;
               g_v_sql_id := 'SQL-02040';

               --##42 BEGIN
               /*
               UPDATE EDI_ST_EQUIPMENT
               SET    RECORD_STATUS      = l_v_dt_sts
                    , RECORD_CHANGE_USER = 'EZLL' --g_v_user
                    , RECORD_CHANGE_DATE = l_d_date
               WHERE  EDI_ETD_UID    = I.EDI_ETD_UID;
               */
               INSERT INTO EDI_ST_EQUIPMENT_TMP
               ( EDI_ETD_UID
               , RECORD_STATUS
               , RECORD_CHANGE_USER
               , RECORD_CHANGE_DATE
               ) VALUES
               ( I.EDI_ETD_UID
               , l_v_dt_sts
               , 'EZLL'
               , l_d_date
               );
               --##42 END

               /*PRE_LOG_INFO
               ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
              , 'EDI_ST_EQUIPMENT'
              , g_v_sql_id
              , g_v_user
              , l_t_log_info
              , 'UPDATE CALLED'
              , NULL
              , NULL
              , NULL
               ); */ --*37

            EXCEPTION
               WHEN l_exce_main THEN
                  --ROLLBACK;

                  --l_v_dt_sts := 'A';
                  l_v_tr_sts  := 'E';
                  /*UPDATE EDI_ST_EQUIPMENT
                  SET    RECORD_STATUS      = l_v_dt_sts
                       , RECORD_CHANGE_USER = 'EZLL' --g_v_user
                       , RECORD_CHANGE_DATE = l_d_date
                  WHERE  EDI_ETD_UID    = I.EDI_ETD_UID;*/

/*-- *50 remove logging
               PRE_LOG_INFO
               ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
               , 'EDI_ST_EQUIPMENT'
               , '33.1'
               , g_v_user
               , l_t_log_info
               , 'UPDATE CALLED'
               , NULL
               , NULL
               , NULL
               ); --*/
                  --p_o_v_return_status := '1';

                  /*PKG_EDI_TRANSACTION.ADD_TO_ERROR (I.EDI_ETD_UID
                                                   ,'E0000'
                                                   ,'H'
                                                   , NULL
                                                   , v_info
                                                     );*/

                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                    l_v_parameter_str
                        ||SEP|| I.BOOKING_NUMBER   -- added, 11.01.2012
                        ||SEP|| I.EQUIPMENT_NO
                        ||SEP|| K.MSG_REFERENCE
                        ||SEP|| I.EDI_ETD_UID
                    , 'EDI'
                    , '1'
                    , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                    , 'A'
                    , g_v_user
                    , SYSDATE -- CURRENT_TIMESTAMP --*24
                    , g_v_user
                    , SYSDATE -- CURRENT_TIMESTAMP --*24
                    , g_v_record_filter -- added by vikas, 13.12.2011
                    , g_v_record_table  -- added by vikas, 13.12.2011
                );

                  --COMMIT;
               WHEN OTHERS THEN
                  --ROLLBACK;

                  --l_v_dt_sts := 'A';
                  l_v_tr_sts  := 'E';
                  /*UPDATE EDI_ST_EQUIPMENT
                  SET    RECORD_STATUS      = l_v_dt_sts
                       , RECORD_CHANGE_USER = 'EZLL' --g_v_user
                       , RECORD_CHANGE_DATE = l_d_date
                  WHERE  EDI_ETD_UID    = I.EDI_ETD_UID;*/

                  --p_o_v_return_status := '1';

                  PKG_EDI_TRANSACTION.ADD_TO_ERROR (I.EDI_ETD_UID
                                                   ,'E0000'
                                                   ,'H'
                                                   , NULL
                                                   , v_info
                                                     );

                  g_v_err_code   := TO_CHAR (SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                  PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                                                l_v_parameter_str
                                                                    ||SEP|| I.BOOKING_NUMBER  -- added, 11.01.2012
                                                                    ||SEP|| I.EQUIPMENT_NO
                                                                    ||SEP|| K.MSG_REFERENCE
                                                                    ||SEP|| I.EDI_ETD_UID
                                                                 , 'EDI'
                                                                 , '1'
                                                                 , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                                                 , 'A'
                                                                 , g_v_user
                                                                 , SYSDATE -- CURRENT_TIMESTAMP --*24
                                                                 , g_v_user
                                                                 , SYSDATE -- CURRENT_TIMESTAMP --*24
                                                                   );
      /*-- *50 remove logging
                PRE_LOG_INFO
                 ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                , g_v_err_code
                , g_v_sql_id
                , g_v_user
                , l_t_log_info
                , g_v_err_desc
                , NULL
                , NULL
                , NULL
                ); --*/

                   --COMMIT;
            END;
         END LOOP;
         --Closing EDI Equipment Detail
                    /*PRE_LOG_INFO
                    ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                   , 'CHECK'
                   , '34'
                   , g_v_user
                   , l_t_log_info
                   , 'STEP EXECUTED'
                   , NULL
                   , NULL
                   , NULL
                   ); */ --*37

         IF l_v_tr_sts IS NULL THEN
            l_v_tr_sts := 'E';
         END IF;


         IF l_v_hd_sts IS NULL OR l_v_hd_sts = 'S' THEN
            l_v_hd_sts  := l_v_tr_sts;
         END IF;

        /*
            Start added by vikas, if error code is '01' then
            only neet to update error status, as k'chatgamol, 20.12.2011
        */
        IF g_v_err_code <> '01' THEN
            l_v_tr_sts := 'S';
        END IF;
        /*
            End added by vikas, 20.12.2011
        */
         g_v_sql_id := 'SQL-02041';
         --##42 BEGIN
         /*
         UPDATE EDI_TRANSACTION_DETAIL
         SET    STATUS             = l_v_tr_sts
              , RECORD_CHANGE_USER = 'EZLL' --g_v_user
              , RECORD_CHANGE_DATE = l_d_date
         WHERE  MSG_REFERENCE = K.MSG_REFERENCE
         AND    EDI_ETD_UID   = J.EDI_ETD_UID
         AND    RECORD_STATUS = 'A'
         AND    STATUS        = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E');
         */
         INSERT INTO EDI_TRANSACTION_DETAIL_TMP
         ( MSG_REFERENCE
         , EDI_ETD_UID
         , OLD_STATUS
         , NEW_STATUS
         , RECORD_STATUS
         , RECORD_CHANGE_USER
         , RECORD_CHANGE_DATE
         ) VALUES
         ( K.MSG_REFERENCE
         , J.EDI_ETD_UID
         , DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E')
         , l_v_tr_sts
         , 'A'
         , 'EZLL'
         , l_d_date
         );
         --##42 END
         /*PRE_LOG_INFO
         ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
        , 'EDI_TRANSACTION_DETAIL'
        , g_v_sql_id
        , g_v_user
        , l_t_log_info
        , 'UPDATE CALLED'
        , NULL
        , NULL
        , NULL
         ); */ --*37

      END LOOP;
      --Closing EDI Transaction Detail
      IF l_v_hd_sts IS NULL THEN
         l_v_hd_sts  := 'E';
      END IF;
      g_v_sql_id := 'SQL-02042';

      --##42 BEGIN
      /*
      UPDATE EDI_TRANSACTION_HEADER
      SET    STATUS             = l_v_hd_sts
           , RECORD_CHANGE_USER = 'EZLL' --g_v_user
           , RECORD_CHANGE_DATE = l_d_date
      WHERE  MODULE        = p_i_v_ezl
      AND    DIRECTION     = 'IN'
      AND    RECORD_STATUS = 'A'
      AND    MSG_REFERENCE = K.MSG_REFERENCE
      AND    STATUS        = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E');
      */

      INSERT INTO EDI_TRANSACTION_HEADER_TMP
      ( MODULE
      , DIRECTION
      , MSG_REFERENCE
      , OLD_STATUS
      , NEW_STATUS
      , RECORD_STATUS
      , RECORD_CHANGE_USER
      , RECORD_CHANGE_DATE
      ) VALUES
      ( p_i_v_ezl
      , 'IN'
      , K.MSG_REFERENCE
      , DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E')
      , l_v_hd_sts
      , 'A'
      , 'EZLL'
      , l_d_date
      );
      --##42 END

      l_v_hd_sts := NULL;
      l_v_tr_sts := NULL;
      l_v_dt_sts := NULL;

      /*PRE_LOG_INFO
      ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
     , 'EDI_TRANSACTION_HEADER'
     , g_v_sql_id
     , g_v_user
     , l_t_log_info
     , 'UPDATE CALLED'
     , NULL
     , NULL
     , NULL
      ); */ --*37

      UPDATE EDI_TRANSACTION_HEADER                       --##44
      SET    RECORD_CHANGE_DATE = sysdate                 --##44
           , RECORD_CHANGE_USER = 'EZLL'                  --##44
      WHERE  RECORD_STATUS = 'A'                          --##44
      AND    MSG_REFERENCE = K.MSG_REFERENCE              --##44
      ;

      --##42
      --DBMS_OUTPUT.PUT_LINE('Update status EDI Start: '|| TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI:SS') );
      FOR rec_st IN (
         SELECT ezll.*
         FROM EDI_ST_EQUIPMENT_TMP ezll
         WHERE ezll.EDI_ETD_UID IN (
            SELECT ezll.EDI_ETD_UID
            FROM EDI_TRANSACTION_DETAIL_TMP ezll
            WHERE ezll.MSG_REFERENCE = K.MSG_REFERENCE
         )
      )
      LOOP

         --DBMS_OUTPUT.PUT_LINE('ST ' || rec_st.EDI_ETD_UID||' '||rec_st.RECORD_STATUS );

         UPDATE EDI_ST_EQUIPMENT edi
         SET edi.RECORD_STATUS = rec_st.RECORD_STATUS
         , edi.RECORD_CHANGE_USER = rec_st.RECORD_CHANGE_USER
         , edi.RECORD_CHANGE_DATE = rec_st.RECORD_CHANGE_DATE
         WHERE edi.EDI_ETD_UID = rec_st.EDI_ETD_UID
         ;
      END LOOP;

      FOR rec_detail IN (
         SELECT ezll.*
         FROM EDI_TRANSACTION_DETAIL_TMP ezll
         WHERE ezll.MSG_REFERENCE = K.MSG_REFERENCE
      )
      LOOP

         --DBMS_OUTPUT.PUT_LINE('DT ' || rec_detail.EDI_ETD_UID||' '||rec_detail.MSG_REFERENCE||' '||rec_detail.NEW_STATUS );

         UPDATE EDI_TRANSACTION_DETAIL edi
         SET edi.STATUS = rec_detail.NEW_STATUS
         , edi.RECORD_CHANGE_USER = rec_detail.RECORD_CHANGE_USER
         , edi.RECORD_CHANGE_DATE = rec_detail.RECORD_CHANGE_DATE
         WHERE edi.EDI_ETD_UID = rec_detail.EDI_ETD_UID
         AND edi.MSG_REFERENCE = rec_detail.MSG_REFERENCE
         AND edi.RECORD_STATUS = rec_detail.RECORD_STATUS
         ;
      END LOOP;

      FOR rec_header IN (
         SELECT ezll.*
         FROM EDI_TRANSACTION_HEADER_TMP ezll
         WHERE ezll.MSG_REFERENCE = K.MSG_REFERENCE
      )
      LOOP

         --DBMS_OUTPUT.PUT_LINE('HD ' || rec_header.MSG_REFERENCE||' '||rec_header.NEW_STATUS );

         SELECT COUNT(*) TOTAL_UNMATCH
            INTO l_v_vol_unmatch
         FROM edi_st_equipment
         WHERE msg_reference = rec_header.MSG_REFERENCE
         AND RECORD_STATUS <> 'S'
         ;

         IF l_v_vol_unmatch > 0 THEN
            UPDATE EDI_TRANSACTION_HEADER
            SET    STATUS             = 'E'
            WHERE  MSG_REFERENCE = rec_header.MSG_REFERENCE
            ;

            --DBMS_OUTPUT.PUT_LINE( rec_header.MSG_REFERENCE || ' -> ' || 'E' || ' unmatch -> ' || l_v_vol_unmatch );
         ELSE
            UPDATE EDI_TRANSACTION_HEADER edi
            SET edi.STATUS = rec_header.NEW_STATUS
            WHERE edi.MSG_REFERENCE = rec_header.MSG_REFERENCE
            AND edi.RECORD_STATUS = rec_header.RECORD_STATUS
            ;

            --DBMS_OUTPUT.PUT_LINE( rec_header.MSG_REFERENCE || ' -> ' || rec_header.NEW_STATUS || ' unmatch -> ' || l_v_vol_unmatch );
         END IF;

      END LOOP;

   END LOOP;



   --DBMS_OUTPUT.PUT_LINE('Update status EDI End  : '|| TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI:SS') );
   --##42

                       /*PRE_LOG_INFO
                    ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                   , 'CHECK'
                   , '35'
                   , g_v_user
                   , l_t_log_info
                   , 'STEP EXECUTED'
                   , NULL
                   , NULL
                   , NULL
                   ); */ --*37


   PKG_EDI_TRANSACTION.WRITE_ERROR;

--Closing EDI Transaction Header
   COMMIT;

                    /*PRE_LOG_INFO
                    ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                   , 'CHECK'
                   , '36'
                   , g_v_user
                   , l_t_log_info
                   , 'STEP EXECUTED'
                   , NULL
                   , NULL
                   , NULL
                   ); */ --*37

--Calling automatch for the selected loadlist.
   FOR load_list_seq IN 1..l_tb_load_list.COUNT
   LOOP
      IF l_tb_load_list(load_list_seq).load_list_id <> load_list THEN
         load_list := l_tb_load_list(load_list_seq).load_list_id;
         g_v_sql_id := 'SQL-02043';
         BEGIN
	 /*-- VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 CALLING LLDL_COMMON_MATCHING FOR LOADLIST '
                                                   ,'START : ' || SYSDATE
                                                   ); --*/

            PRE_TOS_LLDL_COMMON_MATCHING('A', 'LL', '', '', ''
                                       , l_tb_load_list(load_list_seq).load_list_id
                                       , '', '', l_v_return_status);
/*--
	  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER CALLING LLDL_COMMON_MATCHING '
                                                   ,'END : ' || SYSDATE
                                                   ); --*/

            --PRE_TOS_ERROR_LOG(l_v_lldl_flg, l_n_load_list_id, l_n_overshipped_id, l_n_discharge_list_id, l_n_overlanded_id
            --                          , I.BOOKING_NUMBER, I.EQUIPMENT_NO, l_v_err_code, g_v_user, g_v_user);

            l_arr_var_name := STRING_ARRAY
            ( 'p_i_v_match_type'           , 'p_i_v_list_type'                   , 'p_i_n_discharge_list_id'
            , 'p_i_n_dl_container_seq'     , 'p_i_n_overlanded_container_id'     , 'p_i_n_load_list_id'
            , 'p_i_n_ll_container_seq'     , 'p_i_n_overshipped_container_id'    , 'p_o_v_return_status'
            );

            l_arr_var_value := STRING_ARRAY
            ( 'A'                , 'LL'             , ''
            , ''                 , ''               , l_tb_load_list(load_list_seq).load_list_id
            , ''                 , ''               , l_v_return_status
            );

            l_arr_var_io := STRING_ARRAY
            ( 'I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'O'
            );
/*-- *50 remove logging
            PRE_LOG_INFO
            ( 'PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
            , 'PRE_TOS_LLDL_COMMON_MATCHING'
            , g_v_sql_id
            , g_v_user
            , l_t_log_info
            , null
            , l_arr_var_name
            , l_arr_var_value
            , l_arr_var_io
            );
--*/
            IF l_v_return_status = '1' THEN
               g_v_err_code   := '000000';
               g_v_err_desc   := 'Unable to process PRE_TOS_LLDL_COMMON_MATCHING for Load List';
               RAISE l_exce_matching;
            END IF;

         EXCEPTION
            WHEN l_exce_matching THEN
               --p_o_v_return_status := '1';
               g_v_err_desc   := SUBSTR(g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc,1,100);
               PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                                                              , 'EDI'
                                                              , '1'
                                                              , g_v_err_desc
                                                              , 'A'
                                                              , g_v_user
                                                              , SYSDATE -- CURRENT_TIMESTAMP --*24
                                                              , g_v_user
                                                              , SYSDATE -- CURRENT_TIMESTAMP --*24
                                                               );
            /*WHEN OTHERS THEN
               g_v_err_code   := TO_CHAR(SQLCODE);
               g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_matching;*/
         END;
      END IF;
   END LOOP;
                       /*PRE_LOG_INFO
                    ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                   , 'CHECK'
                   , '37'
                   , g_v_user
                   , l_t_log_info
                   , 'STEP EXECUTED'
                   , NULL
                   , NULL
                   , NULL
                   );*/

   --Calling automatch for the selected dischargelist.
   FOR discharge_list_seq IN 1..l_tb_discharge_list.COUNT
   LOOP
      IF l_tb_discharge_list(discharge_list_seq).discharge_list_id <> discharge_list THEN
         discharge_list := l_tb_discharge_list(discharge_list_seq).discharge_list_id;
         g_v_sql_id := 'SQL-02044';
         BEGIN
	  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 CALLING LLDL_COMMON_MATCHING FOR DISCHARGELIST '
                                                   ,'START : ' || SYSDATE
                                                   );--*/

            PRE_TOS_LLDL_COMMON_MATCHING('A', 'DL', l_tb_discharge_list(discharge_list_seq).discharge_list_id
                                       , '', '', ''
                                       , '', '', l_v_return_status);
/*--
	  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER CALLING LLDL_COMMON_MATCHING FOR LOADLIST '
                                                   ,'END : ' || SYSDATE
                                                   ); --*/

          l_arr_var_name := STRING_ARRAY
         ('p_i_v_match_type'           , 'p_i_v_list_type'                   , 'p_i_n_discharge_list_id'
        , 'p_i_n_dl_container_seq'     , 'p_i_n_overlanded_container_id'     , 'p_i_n_load_list_id'
        , 'p_i_n_ll_container_seq'     , 'p_i_n_overshipped_container_id'    , 'p_o_v_return_status'
          );

          l_arr_var_value := STRING_ARRAY
         ('A'                , 'DL'             , ''
        , ''                 , ''               , l_tb_discharge_list(discharge_list_seq).discharge_list_id
        , ''                 , ''               , l_v_return_status
          );

          l_arr_var_io := STRING_ARRAY
         ('I'      , 'I'      , 'I'
        , 'I'      , 'I'      , 'I'
        , 'I'      , 'I'      , 'O'
          );

/*-- *50 remove logging
          PRE_LOG_INFO
          ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
         , 'PRE_TOS_LLDL_COMMON_MATCHING'
         , g_v_sql_id
         , g_v_user
         , l_t_log_info
         , NULL
         , l_arr_var_name
         , l_arr_var_value
         , l_arr_var_io
          ); --*/

            IF l_v_return_status = '1' THEN
               g_v_err_code   := '000000';
               g_v_err_desc   := 'Unable to process PRE_TOS_LLDL_COMMON_MATCHING for Discharge List';
               RAISE l_exce_matching;
            END IF;
         EXCEPTION
            WHEN l_exce_matching THEN
               --p_o_v_return_status := '1';
               g_v_err_desc   := SUBSTR(g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc,1,100);
               PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                                                              , 'EDI'
                                                              , '1'
                                                              , g_v_err_desc
                                                              , 'A'
                                                              , g_v_user
                                                              , SYSDATE -- CURRENT_TIMESTAMP --*24
                                                              , g_v_user
                                                              , SYSDATE -- CURRENT_TIMESTAMP --*24
                                                               );
            /*WHEN OTHERS THEN
               g_v_err_code   := TO_CHAR(SQLCODE);
               g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_matching;*/
         END;
      END IF;
   END LOOP;
/*                       PRE_LOG_INFO
                    ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
                   , 'CHECK'
                   , '38'
                   , g_v_user
                   , l_t_log_info
                   , 'STEP EXECUTED'
                   , NULL
                   , NULL
                   , NULL
                   );*/

   --p_o_v_return_status := '0';

  /* PRE_LOG_INFO
   ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
  , 'FINALLY'
  , '9999'
  , g_v_user
  , l_t_log_info
  , 'All Process Completed'
  , NULL
  , NULL
  , NULL
   ); */ --*37

   --DBMS_OUTPUT.PUT_LINE('VASAPPS.PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND, Success.');

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      PKG_EDI_TRANSACTION.WRITE_ERROR;
      --p_o_v_return_status := '1';
      g_v_err_code   := TO_CHAR (SQLCODE);
      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                                                     , 'EDI'
                                                     , '1'
                                                     , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                                     , 'A'
                                                     , g_v_user
                                                     , SYSDATE -- CURRENT_TIMESTAMP --*24
                                                     , g_v_user
                                                     , SYSDATE -- CURRENT_TIMESTAMP --*24
                                                      );
      /*--*50 remove logging
        PRE_LOG_INFO
         ('PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND'
        , g_v_err_code
        , g_v_sql_id
        , g_v_user
        , l_t_log_info
        -- , g_v_err_desc -- *31
        , SUBSTR(g_v_err_desc ,1, 1000)  -- *31
        , NULL
        , NULL
        , NULL
        ); --*/
      COMMIT;

    --DBMS_OUTPUT.PUT_LINE('VASAPPS.PCE_ECM_EDI.TOS_EZLL_EDI_INBOUND, Failed!');

END TOS_EZLL_EDI_INBOUND;

PROCEDURE PRE_GET_NEXT_VALUE
( p_i_n_etd_uid   IN NUMBER
, p_i_n_esdh_uid  IN NUMBER
, p_i_n_esdco_uid IN NUMBER
, p_i_n_esde_uid  IN NUMBER
, p_o_v_handling_instruction1  OUT NOCOPY VARCHAR2
, p_o_v_handling_instruction2  OUT NOCOPY VARCHAR2
, p_o_v_handling_instruction3  OUT NOCOPY VARCHAR2
, p_o_v_container_loading_rem1 OUT NOCOPY VARCHAR2
, p_o_v_container_loading_rem2 OUT NOCOPY VARCHAR2
, p_o_v_return_status          OUT NOCOPY VARCHAR2
) AS
l_n_count     NUMBER := 0;
CURSOR l_cur_han_date
IS
SELECT TEXT_CODE
FROM EDI_ST_DOC_TEXT
WHERE EDI_ETD_UID   = p_i_n_etd_uid
AND   EDI_ESDH_UID  = NVL(p_i_n_esdh_uid,EDI_ESDH_UID)
AND   EDI_ESDCO_UID = NVL(p_i_n_esdco_uid,EDI_ESDCO_UID)
AND   EDI_ESDE_UID  = p_i_n_esde_uid
AND   TEXT_TYPE     = 'HAN'
AND   RECORD_STATUS = 'A';

CURSOR l_cur_clr_date
IS
SELECT TEXT_CODE
FROM EDI_ST_DOC_TEXT
WHERE EDI_ETD_UID   = p_i_n_etd_uid
AND   EDI_ESDH_UID  = NVL(p_i_n_esdh_uid,EDI_ESDH_UID)
AND   EDI_ESDCO_UID = NVL(p_i_n_esdco_uid,EDI_ESDCO_UID)
AND   EDI_ESDE_UID  = p_i_n_esde_uid
AND   TEXT_TYPE     = 'CLR'
AND   RECORD_STATUS = 'A';

BEGIN
   FOR I IN l_cur_han_date
   LOOP
      l_n_count := l_n_count + 1;
      IF l_n_count = 1 THEN
         p_o_v_handling_instruction1 := I.TEXT_CODE;
      ELSIF l_n_count = 2 THEN
         p_o_v_handling_instruction2 := I.TEXT_CODE;
      ELSIF l_n_count = 3 THEN
         p_o_v_handling_instruction3 := I.TEXT_CODE;
      END IF;
   END LOOP;

   l_n_count := 0;
   FOR J IN l_cur_clr_date
   LOOP
      l_n_count := l_n_count + 1;
      IF l_n_count = 1 THEN
         p_o_v_container_loading_rem1 := J.TEXT_CODE;
      ELSIF l_n_count = 2 THEN
         p_o_v_container_loading_rem2 := J.TEXT_CODE;
      END IF;
   END LOOP;
   l_n_count := 0;
   p_o_v_return_status := '0';
EXCEPTION
   WHEN OTHERS THEN
      p_o_v_return_status := '1';
      g_v_err_code   := TO_CHAR(SQLCODE);
      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
END PRE_GET_NEXT_VALUE;

PROCEDURE PRE_TOS_ERROR_LOG
 (p_i_v_ll_dl_flg          IN VARCHAR2
, p_i_n_load_list_id       IN NUMBER
, p_i_n_overshipped_id     IN NUMBER
, p_i_n_discharge_list_id  IN NUMBER
, p_i_n_overlanded_id      IN NUMBER
, p_i_v_bkg_no             IN VARCHAR2
, p_i_v_equipment_no       IN VARCHAR2
, p_i_v_error_code         IN VARCHAR2
, p_i_v_record_add_user    IN VARCHAR2
, p_i_v_record_change_user IN VARCHAR2
) AS
l_d_time                   TIMESTAMP;
l_v_list_type              VARCHAR2(1) := SUBSTR(p_i_v_ll_dl_flg,1,1);
BEGIN
   l_d_time := SYSDATE; -- CURRENT_TIMESTAMP; --*24
   INSERT INTO TOS_ERROR_LOG
          (PK_ERROR_LOG_ID
         , LL_DL_FLAG
         , FK_LOAD_LIST_ID
         , FK_OVERSHIPPED_ID
         , FK_DISCHARGE_LIST_ID
         , FK_OVERLANDED_ID
         , BKG_NO
         , EQUIPMENT_NO
         , ERROR_CODE
         , RECORD_STATUS
         , RECORD_ADD_USER
         , RECORD_ADD_DATE
         , RECORD_CHANGE_USER
         , RECORD_CHANGE_DATE
          )
       VALUES
          (SE_ELZ01.NEXTVAL
         , l_v_list_type
         , p_i_n_load_list_id
         , p_i_n_overshipped_id
         , p_i_n_discharge_list_id
         , p_i_n_overlanded_id
         , p_i_v_bkg_no
         , p_i_v_equipment_no
         , p_i_v_error_code
         , 'A'
         , p_i_v_record_add_user
         , l_d_time
         , p_i_v_record_change_user
         , l_d_time
          );
   COMMIT;
END PRE_TOS_ERROR_LOG;

PROCEDURE PCE_TOS_TEMP_AUTOMATCH
( p_i_n_load_list_id              IN NUMBER
, p_i_n_overshipped_contained_id  IN NUMBER
, p_i_v_booking_no                IN VARCHAR2
, p_i_v_equipment_no              IN VARCHAR2
, p_o_v_return_status             OUT NOCOPY VARCHAR2
) AS
/******************************************************************************************
* Name           : PCE_TOS_TEMP_AUTOMATCH                                                 *
* Module         : EZLL                                                                   *
* Purpose        : Insert data into TOS_TMP_AUTOMATCH_LAUNCH Table                        *
* Calls          :                                                                        *
* Returns        : '0' --Success
                   '1' --Fail                                                             *
* Steps Involved :                                                                        *
* History        :                                                                        *
* Author           Date          What                                                     *
* ---------------  ----------    ----                                                     *
* Bindu sekhar     02/03/2011     1.0                                                     *
******************************************************************************************/
   l_d_time          TIMESTAMP;
   l_v_parameter_str VARCHAR2(500);

BEGIN
   g_v_sql_id := 'SQL-03001';
   l_d_time := SYSDATE; -- CURRENT_TIMESTAMP; --*24
   l_v_parameter_str := p_i_n_load_list_id ||SEP||
                        p_i_n_overshipped_contained_id ||SEP||
                        p_i_v_booking_no ||SEP||
                        p_i_v_equipment_no;
   INSERT INTO TOS_TMP_AUTOMATCH_LAUNCH
          (PK_AUTOMATCH_LAUNCH_ID
         , FK_LOAD_LIST_ID
         , FK_OVERSHIPPED_CONTAINER_ID
         , FK_BOOKING_NO
         , DN_EQUIPMENT_NO
         , RECORD_STATUS
         , RECORD_ADD_USER
         , RECORD_ADD_DATE
         , RECORD_CHANGE_USER
         , RECORD_CHANGE_DATE
          )
   VALUES( SE_ALL01.NEXTVAL
         , p_i_n_load_list_id
         , p_i_n_overshipped_contained_id
         , p_i_v_booking_no
         , p_i_v_equipment_no
         , 'A'
         , g_v_user
         , l_d_time
         , g_v_user
         , l_d_time
          );
  /*-- *50 remove logging
   PRE_LOG_INFO
    ('PCE_ECM_EDI.PCE_TOS_TEMP_AUTOMATCH'
   , 'TOS_TMP_AUTOMATCH_LAUNCH'
   , g_v_sql_id
   , g_v_user
   , l_d_time
   , 'INSERT CALLED'
   , NULL
   , NULL
   , NULL
    ); --*/
   --COMMIT;
   p_o_v_return_status := '0';
EXCEPTION
   WHEN OTHERS THEN
      p_o_v_return_status := '1';
      g_v_err_code   := TO_CHAR(SQLCODE);
      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
END PCE_TOS_TEMP_AUTOMATCH;

PROCEDURE PRE_TOS_LLDL_MOVE
( p_i_n_booked_loading_id   IN NUMBER
, p_i_n_booked_discharge_id IN NUMBER
, p_i_v_lldl_flg            IN VARCHAR2
, p_o_v_return_status       OUT  NOCOPY VARCHAR2
) AS
/********************************************************************************
* Name           : PRE_TOS_LLDL_MOVE                                            *
* Module         : EZLL                                                         *
* Purpose        : This  SP is used for to insert data into Overlanded Container
                   table and overshipped container table                        *
* Calls          : None                                                         *
* Returns        : NONE                                                         *
* Steps Involved :                                                              *
* History        : None                                                         *
* Author           Date          What                                           *
* ---------------  ----------    ----                                           *
* Bindu            29/04/2011     1.0                                           *
*********************************************************************************/
   l_d_time           TIMESTAMP;
   l_exce_main        EXCEPTION;
   l_v_parameter_str  VARCHAR2(200);
BEGIN
   l_v_parameter_str := p_i_n_booked_loading_id||SEP||
                        p_i_n_booked_discharge_id||SEP||
                        p_i_v_lldl_flg;
   IF p_i_v_lldl_flg = 'LL' THEN
      l_d_time := SYSDATE; -- CURRENT_TIMESTAMP; --*24
      BEGIN
         g_v_sql_id := 'SQL-05001';
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
         SELECT  SE_OCZ02.NEXTVAL
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
               , NVL(PREADVICE_FLAG,'N')
               , EX_MLO_VESSEL
               , EX_MLO_VESSEL_ETA
               , EX_MLO_VOYAGE
               , 'A'
               , g_v_user
               , l_d_time
               , g_v_user
               , l_d_time
         FROM  TOS_LL_BOOKED_LOADING
         WHERE PK_BOOKED_LOADING_ID  = p_i_n_booked_loading_id;
      EXCEPTION
        WHEN OTHERS THEN
           g_v_err_code   := TO_CHAR(SQLCODE);
           g_v_err_desc   := SUBSTR(SQLERRM,1,100);
           RAISE l_exce_main;
      END;
   ELSIF p_i_v_lldl_flg = 'DL' THEN
      l_d_time := SYSDATE; -- CURRENT_TIMESTAMP; --*24
      BEGIN
         g_v_sql_id := 'SQL-05002';
         INSERT INTO TOS_DL_OVERLANDED_CONTAINER (
                  PK_OVERLANDED_CONTAINER_ID
                , FK_DISCHARGE_LIST_ID
                , BOOKING_NO
                , BKG_TYP
                , EQUIPMENT_NO
                , EQ_SIZE
                , EQ_TYPE
                , LOCAL_STATUS
                , LOCAL_TERMINAL_STATUS
                , LOAD_CONDITION
                , SPECIAL_HANDLING
                , FLAG_SOC_COC
                , SHIPMENT_TERM
                , SHIPMENT_TYP
                , CONTAINER_GROSS_WEIGHT
                , STOWAGE_POSITION
                , POL
                , MLO_VESSEL
                , MLO_VOYAGE
                , MLO_VESSEL_ETA
                , MLO_POD1
                , MLO_POD2
                , MLO_POD3
                , MLO_DEL
                , NXT_SRV
                , NXT_VESSEL
                , NXT_VOYAGE
                , NXT_DIR
                , NXT_POD1
                , NXT_POD2
                , NXT_POD3
                , FINAL_POD
                , HANDLING_INSTRUCTION_1
                , HANDLING_INSTRUCTION_2
                , HANDLING_INSTRUCTION_3
                , CONTAINER_LOADING_REM_1
                , CONTAINER_LOADING_REM_2
                , ACTIVITY_DATE_TIME
                , SLOT_OPERATOR
                , CONTAINER_OPERATOR
                , OUT_SLOT_OPERATOR
                , MIDSTREAM_HANDLING_CODE
                , REEFER_TEMPERATURE
                , REEFER_TMP_UNIT
                , IMDG_CLASS
                , UN_NUMBER
                , UN_NUMBER_VARIANT
                , PORT_CLASS_TYP
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
                , DAMAGED
                , POL_TERMINAL
                , FINAL_DEST
                , FULL_MT
                , FUMIGATION_ONLY
                , SEAL_NO
                , SPECIAL_CARGO
                , DA_ERROR
                , HUMIDITY
                , VENTILATION
                , RECORD_STATUS
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
                , RECORD_CHANGE_USER
                , RECORD_CHANGE_DATE
               )
         SELECT SE_OCZ01.NEXTVAL
                , FK_DISCHARGE_LIST_ID
                , FK_BOOKING_NO
                , DN_BKG_TYP
                , DN_EQUIPMENT_NO
                , DN_EQ_SIZE
                , DN_EQ_TYPE
                , LOCAL_STATUS
                , LOCAL_TERMINAL_STATUS
                , LOAD_CONDITION
                , DN_SPECIAL_HNDL
                , DN_SOC_COC
                , DN_SHIPMENT_TERM
                , DN_SHIPMENT_TYP
                , CONTAINER_GROSS_WEIGHT
                , STOWAGE_POSITION
                , DN_POL
                , MLO_VESSEL
                , MLO_VOYAGE
                , MLO_VESSEL_ETA
                , MLO_POD1
                , MLO_POD2
                , MLO_POD3
                , MLO_DEL
                , DN_NXT_SRV
                , DN_NXT_VESSEL
                , DN_NXT_VOYAGE
                , DN_NXT_DIR
                , DN_NXT_POD1
                , DN_NXT_POD2
                , DN_NXT_POD3
                , DN_FINAL_POD
                , FK_HANDLING_INSTRUCTION_1
                , FK_HANDLING_INSTRUCTION_2
                , FK_HANDLING_INSTRUCTION_3
                , CONTAINER_LOADING_REM_1
                , CONTAINER_LOADING_REM_2
                , ACTIVITY_DATE_TIME
                , FK_SLOT_OPERATOR
                , FK_CONTAINER_OPERATOR
                , OUT_SLOT_OPERATOR
                , MIDSTREAM_HANDLING_CODE
                , REEFER_TEMPERATURE
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
                , DAMAGED
                , DN_POL_TERMINAL
                , FINAL_DEST
                , DN_FULL_MT
                , FUMIGATION_ONLY
                , SEAL_NO
                , FK_SPECIAL_CARGO
                , 'N'
                , DN_HUMIDITY
                , DN_VENTILATION
                , 'A'
                , g_v_user
                , l_d_time
                , g_v_user
                , l_d_time
         FROM  TOS_DL_BOOKED_DISCHARGE
         WHERE PK_BOOKED_DISCHARGE_ID = p_i_n_booked_discharge_id;
      EXCEPTION
        WHEN OTHERS THEN
           g_v_err_code   := TO_CHAR(SQLCODE);
           g_v_err_desc   := SUBSTR(SQLERRM,1,100);
           RAISE l_exce_main;
      END;
   END IF;
   p_o_v_return_status := '0';
EXCEPTION
   WHEN l_exce_main THEN
      p_o_v_return_status := '1';
      ROLLBACK;
   WHEN OTHERS THEN
      p_o_v_return_status := '1';
      g_v_err_code   := TO_CHAR(SQLCODE);
      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
      ROLLBACK;
END PRE_TOS_LLDL_MOVE;

PROCEDURE PRE_TOS_LLDL_MANUAL_MATCHING
(  p_i_v_match_type                IN          VARCHAR2
 , p_i_v_list_type                 IN          VARCHAR2
 , p_i_n_discharge_list_id         IN          NUMBER
 , p_i_n_dl_container_seq          IN          NUMBER
 , p_i_n_overlanded_container_id   IN          NUMBER
 , p_i_n_load_list_id              IN          NUMBER
 , p_i_n_ll_container_seq          IN          NUMBER
 , p_i_n_overshipped_container_id  IN          NUMBER
 , p_o_v_return_status             OUT NOCOPY  VARCHAR2
 ) AS
 CURSOR cur_cointainer_no_ll IS
    SELECT PK_OVERSHIPPED_CONTAINER_ID, EQUIPMENT_NO, PREADVICE_FLAG, IMDG_CLASS, UN_NUMBER, UN_NUMBER_VARIANT, PORT_CLASS,
           PORT_CLASS_TYPE, FLASHPOINT_UNIT, FLASHPOINT, OVERHEIGHT_CM, OVERWIDTH_LEFT_CM, OVERWIDTH_RIGHT_CM,
           OVERLENGTH_FRONT_CM, OVERLENGTH_REAR_CM, LOCAL_STATUS, BOOKING_NO, DISCHARGE_PORT, REEFER_TEMPERATURE,
           REEFER_TMP_UNIT, HUMIDITY, VENTILATION, EQ_SIZE, EQ_TYPE, FULL_MT, FLAG_SOC_COC, SLOT_OPERATOR,
           CONTAINER_OPERATOR, POD_TERMINAL, SPECIAL_HANDLING, BKG_TYP, FK_LOAD_LIST_ID, EX_MLO_VOYAGE, EX_MLO_VESSEL,
           NVL((SELECT TRREFR FROM ITP075 B WHERE TRTYPE = A.EQ_TYPE),'N') REEFER_FLG, CONTAINER_GROSS_WEIGHT, STOWAGE_POSITION,
            MIDSTREAM_HANDLING_CODE
            , HANDLING_INSTRUCTION_1 -- *10
            , HANDLING_INSTRUCTION_2 -- *10
            , HANDLING_INSTRUCTION_3 -- *10
            , ACTIVITY_DATE_TIME -- *29
            , VGM --*49
    FROM  TOS_LL_OVERSHIPPED_CONTAINER A
    WHERE PK_OVERSHIPPED_CONTAINER_ID = p_i_n_overshipped_container_id
    AND   FK_LOAD_LIST_ID             = p_i_n_load_list_id
    AND   NVL(DA_ERROR,'N')           = 'N'
    AND   p_i_v_list_type             = 'LL'
    AND   p_i_v_match_type            = 'M'
    AND   EQUIPMENT_NO IS NOT NULL;

 CURSOR cur_booked_loading  IS
    SELECT PK_BOOKED_LOADING_ID, DN_EQUIPMENT_NO, DN_SOC_COC, DN_FULL_MT, DN_EQ_SIZE, DN_EQ_TYPE, LOCAL_STATUS, LOADING_STATUS,
           FK_BOOKING_NO, FK_SLOT_OPERATOR, OVERHEIGHT_CM, OVERLENGTH_REAR_CM, OVERLENGTH_FRONT_CM, OVERWIDTH_LEFT_CM,
           OVERWIDTH_RIGHT_CM, FK_UNNO, FK_UN_VAR, DN_DISCHARGE_PORT, FLASH_POINT, FLASH_UNIT, FK_IMDG, REEFER_TMP, REEFER_TMP_UNIT,
           DN_HUMIDITY, DN_VENTILATION, FK_PORT_CLASS, FK_PORT_CLASS_TYP, FK_CONTAINER_OPERATOR, DN_DISCHARGE_TERMINAL,
           DN_BKG_TYP, DN_SPECIAL_HNDL, EX_MLO_VOYAGE, EX_MLO_VESSEL, FK_BKG_EQUIPM_DTL EQUIPMENT_SEQ_NO
    FROM   TOS_LL_BOOKED_LOADING
    WHERE  FK_LOAD_LIST_ID  = p_i_n_load_list_id
    AND    LOADING_STATUS NOT IN ('LO', 'RB')
    AND    CONTAINER_SEQ_NO = p_i_n_ll_container_seq;

 CURSOR cur_cointainer_no_dl IS
    SELECT PK_OVERLANDED_CONTAINER_ID, EQUIPMENT_NO, IMDG_CLASS, UN_NUMBER, UN_NUMBER_VARIANT, PORT_CLASS, PORT_CLASS_TYP,
           FLASHPOINT_UNIT, POL_TERMINAL, FLASHPOINT, OVERHEIGHT_CM, OVERWIDTH_LEFT_CM, OVERWIDTH_RIGHT_CM, OVERLENGTH_FRONT_CM,
           OVERLENGTH_REAR_CM, LOCAL_STATUS, BOOKING_NO, POL, REEFER_TEMPERATURE, REEFER_TMP_UNIT, HUMIDITY, VENTILATION, BKG_TYP,
           EQ_SIZE, EQ_TYPE, FULL_MT, FLAG_SOC_COC, SLOT_OPERATOR, CONTAINER_OPERATOR, FK_DISCHARGE_LIST_ID, SPECIAL_HANDLING,
           NVL((SELECT TRREFR FROM ITP075 B WHERE TRTYPE = A.EQ_TYPE),'N') REEFER_FLG, CONTAINER_GROSS_WEIGHT, STOWAGE_POSITION,
           MIDSTREAM_HANDLING_CODE
            , HANDLING_INSTRUCTION_1 -- *10
            , HANDLING_INSTRUCTION_2 -- *10
            , HANDLING_INSTRUCTION_3 -- *10
            , ACTIVITY_DATE_TIME -- *29
            , VGM   --*49
    FROM  TOS_DL_OVERLANDED_CONTAINER A
    WHERE NVL(DA_ERROR,'N')          = 'N'
    AND   PK_OVERLANDED_CONTAINER_ID = p_i_n_overlanded_container_id
    AND   FK_DISCHARGE_LIST_ID       = p_i_n_discharge_list_id
    AND   p_i_v_list_type            = 'DL'
    AND   p_i_v_match_type           = 'M'
    AND   EQUIPMENT_NO IS NOT NULL;

 CURSOR cur_booked_discharge  IS
    SELECT PK_BOOKED_DISCHARGE_ID, DN_EQUIPMENT_NO, DN_SOC_COC, DN_FULL_MT, DN_EQ_SIZE, DN_EQ_TYPE, LOCAL_STATUS,
           DISCHARGE_STATUS, FK_BOOKING_NO, OVERHEIGHT_CM, OVERLENGTH_REAR_CM, OVERLENGTH_FRONT_CM, OVERWIDTH_LEFT_CM,
           OVERWIDTH_RIGHT_CM, FK_UNNO, FK_UN_VAR, DN_FINAL_POD, DN_POL, FK_SLOT_OPERATOR, FLASH_POINT, FLASH_UNIT,
           FK_IMDG, REEFER_TEMPERATURE, REEFER_TMP_UNIT, DN_HUMIDITY, DN_VENTILATION, FK_PORT_CLASS,
           FK_PORT_CLASS_TYP, FK_CONTAINER_OPERATOR, DN_BKG_TYP,DN_SPECIAL_HNDL,DN_POL_TERMINAL,
           FK_BKG_EQUIPM_DTL EQUIPMENT_SEQ_NO

    FROM TOS_DL_BOOKED_DISCHARGE
    WHERE  FK_DISCHARGE_LIST_ID = p_i_n_discharge_list_id
    AND    DISCHARGE_STATUS NOT IN ('DI', 'RB')
    AND    CONTAINER_SEQ_NO     = p_i_n_dl_container_seq;

/*********************************************************************************
    Name           :PRE_TOS_LLDL_MANUAL_MATCHING
    Module         :
    Purpose        :To Update data in LAOD LIST and DISCHARGE LIST tables.
    Calls          :
    Returns        :Null
    Author          Date               What
    ------          ----               ----
    Bindu          29/04/2011          1.0(manual matching)
***********************************************************************************/
   l_v_time                    TIMESTAMP;
   l_v_parameter_str           VARCHAR2(200);
   l_exce_main                 EXCEPTION;
BEGIN
   l_v_time  := SYSDATE; -- CURRENT_TIMESTAMP; --*24
   l_v_parameter_str := p_i_v_match_type||SEP||
                        p_i_v_list_type||SEP||
                        p_i_n_discharge_list_id||SEP||
                        p_i_n_dl_container_seq||SEP||
                        p_i_n_overlanded_container_id ||SEP||
                        p_i_n_load_list_id||SEP||
                        p_i_n_ll_container_seq ||SEP||
                        p_i_n_overshipped_container_id ;

FOR cur_cointainer_no_data IN cur_cointainer_no_ll
   LOOP
      FOR cur_booked_loading_data IN cur_booked_loading
         LOOP
            IF (NVL( cur_cointainer_no_data.EQ_SIZE, cur_booked_loading_data.DN_EQ_SIZE) = cur_booked_loading_data.DN_EQ_SIZE AND
                NVL( cur_cointainer_no_data.EQ_TYPE, cur_booked_loading_data.DN_EQ_TYPE) = cur_booked_loading_data.DN_EQ_TYPE AND
                NVL( cur_cointainer_no_data.SPECIAL_HANDLING, cur_booked_loading_data.DN_SPECIAL_HNDL) = cur_booked_loading_data.DN_SPECIAL_HNDL) THEN
               IF (cur_booked_loading_data.DN_EQUIPMENT_NO = cur_cointainer_no_data.EQUIPMENT_NO  OR cur_booked_loading_data.DN_EQUIPMENT_NO IS NULL) THEN
                      -------- updation of booked loading --------
                   g_v_sql_id := 'SQL-04001';
                   BEGIN
/*--
	  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 CALLING LLDL_MATHC_UPDATE FOR LL IN MANUAL MATCHING'
                                                   ,'START : ' || SYSDATE
                                                   ); --*/
                    PRE_TOS_LLDL_MATCH_UPDATE('LL'
                                            , cur_cointainer_no_data.EQUIPMENT_NO
                                            , cur_cointainer_no_data.OVERHEIGHT_CM
                                            , cur_cointainer_no_data.OVERLENGTH_REAR_CM
                                            , cur_cointainer_no_data.OVERLENGTH_FRONT_CM
                                            , cur_cointainer_no_data.OVERWIDTH_LEFT_CM
                                            , cur_cointainer_no_data.OVERWIDTH_RIGHT_CM
                                            , cur_cointainer_no_data.UN_NUMBER
                                            , cur_cointainer_no_data.UN_NUMBER_VARIANT
                                            , cur_cointainer_no_data.FLASHPOINT
                                            , cur_cointainer_no_data.FLASHPOINT_UNIT
                                            , cur_cointainer_no_data.IMDG_CLASS
                                            , cur_cointainer_no_data. REEFER_TEMPERATURE
                                            , cur_cointainer_no_data.REEFER_TMP_UNIT
                                            , cur_cointainer_no_data.HUMIDITY
                                            , cur_cointainer_no_data.VENTILATION
                                            , cur_cointainer_no_data.PORT_CLASS
                                            , cur_cointainer_no_data.PORT_CLASS_TYPE
                                            , NULL
                                            , NULL
                                            , cur_booked_loading_data.PK_BOOKED_LOADING_ID
                                            , cur_cointainer_no_data.PK_OVERSHIPPED_CONTAINER_ID
                                            , cur_booked_loading_data.EQUIPMENT_SEQ_NO
                                            , cur_booked_loading_data.FK_BOOKING_NO
                                            , cur_cointainer_no_data.CONTAINER_GROSS_WEIGHT
                                            , cur_cointainer_no_data.VGM    --*49
                                            , cur_cointainer_no_data.STOWAGE_POSITION
                                            , cur_cointainer_no_data.CONTAINER_OPERATOR
                                            , cur_cointainer_no_data.PREADVICE_FLAG
                                            , p_i_n_load_list_id
                                            , cur_cointainer_no_data.MIDSTREAM_HANDLING_CODE
                                            , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_1 -- *10
                                            , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_2 -- *10
                                            , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_3 -- *10
                                            , CUR_COINTAINER_NO_DATA.ACTIVITY_DATE_TIME -- *29
                                            , CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL -- *36
                                            , CUR_COINTAINER_NO_DATA.EX_MLO_VOYAGE -- *36
                                            , p_o_v_return_status );
/*--
  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER CALLING LLDL_MATHC_UPDATE FOR LL IN MANUAL MATCHING'
                                                   ,'END : ' || SYSDATE
                                                   ); --*/

                   IF p_o_v_return_status = '1' THEN
                       g_v_err_code   := TO_CHAR(SQLCODE);
                       g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                       RAISE l_exce_main;
                   END IF;
                EXCEPTION
                   WHEN OTHERS THEN
                      g_v_err_code   := TO_CHAR(SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                      RAISE l_exce_main;
                END;

               ELSIF cur_booked_loading_data.DN_EQUIPMENT_NO <> cur_cointainer_no_data.EQUIPMENT_NO THEN
                   g_v_sql_id := 'SQL-04003';
                   BEGIN
                      PRE_TOS_LLDL_MOVE(cur_booked_loading_data.PK_BOOKED_LOADING_ID, NULL, 'LL', p_o_v_return_status);
                         IF p_o_v_return_status = '1' THEN
                                RAISE l_exce_main;
                         END IF;
                   EXCEPTION
                      WHEN OTHERS THEN
                         g_v_err_code   := TO_CHAR(SQLCODE);
                         g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                         RAISE l_exce_main;
                   END;
                      -------- updation of booked loading --------
                     g_v_sql_id := 'SQL-04004';
                   BEGIN
  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 CALLING LLDL_MATHC_UPDATE FOR LL IN MANUAL MATCHING'
                                                   ,'START : ' || SYSDATE
                                                   ); --*/
                    PRE_TOS_LLDL_MATCH_UPDATE('LL'
                                            , cur_cointainer_no_data.EQUIPMENT_NO
                                            , cur_cointainer_no_data.OVERHEIGHT_CM
                                            , cur_cointainer_no_data.OVERLENGTH_REAR_CM
                                            , cur_cointainer_no_data.OVERLENGTH_FRONT_CM
                                            , cur_cointainer_no_data.OVERWIDTH_LEFT_CM
                                            , cur_cointainer_no_data.OVERWIDTH_RIGHT_CM
                                            , cur_cointainer_no_data.UN_NUMBER
                                            , cur_cointainer_no_data.UN_NUMBER_VARIANT
                                            , cur_cointainer_no_data.FLASHPOINT
                                            , cur_cointainer_no_data.FLASHPOINT_UNIT
                                            , cur_cointainer_no_data.IMDG_CLASS
                                            , cur_cointainer_no_data. REEFER_TEMPERATURE
                                            , cur_cointainer_no_data.REEFER_TMP_UNIT
                                            , cur_cointainer_no_data.HUMIDITY
                                            , cur_cointainer_no_data.VENTILATION
                                            , cur_cointainer_no_data.PORT_CLASS
                                            , cur_cointainer_no_data.PORT_CLASS_TYPE
                                            , NULL
                                            , NULL
                                            , cur_booked_loading_data.PK_BOOKED_LOADING_ID
                                            , cur_cointainer_no_data.PK_OVERSHIPPED_CONTAINER_ID
                                            , cur_booked_loading_data.EQUIPMENT_SEQ_NO
                                            , cur_booked_loading_data.FK_BOOKING_NO
                                            , cur_cointainer_no_data.CONTAINER_GROSS_WEIGHT
                                            , cur_cointainer_no_data.VGM    --*49
                                            , cur_cointainer_no_data.STOWAGE_POSITION
                                            , cur_cointainer_no_data.CONTAINER_OPERATOR
                                            , cur_cointainer_no_data.PREADVICE_FLAG
                                            , p_i_n_load_list_id
                                            , cur_cointainer_no_data.MIDSTREAM_HANDLING_CODE
                                            , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_1 -- *10
                                            , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_2 -- *10
                                            , CUR_COINTAINER_NO_DATA.HANDLING_INSTRUCTION_3 -- *10
                                            , CUR_COINTAINER_NO_DATA.ACTIVITY_DATE_TIME -- *29
                                            , CUR_COINTAINER_NO_DATA.EX_MLO_VESSEL -- *36
                                            , CUR_COINTAINER_NO_DATA.EX_MLO_VOYAGE -- *36
                                            , p_o_v_return_status );
  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER CALLING LLDL_MATHC_UPDATE FOR DL IN MANUAL MATCHING'
                                                   ,'END : ' || SYSDATE
                                                   );--*/
                   IF p_o_v_return_status = '1' THEN
                       g_v_err_code   := TO_CHAR(SQLCODE);
                       g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                       RAISE l_exce_main;
                   END IF;
                EXCEPTION
                   WHEN OTHERS THEN
                      g_v_err_code   := TO_CHAR(SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                      RAISE l_exce_main;
                END;
               END IF;
            END IF;
        END LOOP;
  END LOOP;   --End of main loop cur_cointainer_no_ll
FOR cur_cointainer_no_dl_data IN cur_cointainer_no_dl
   LOOP
      FOR cur_booked_discharge_data IN cur_booked_discharge
         LOOP
            IF (NVL( cur_cointainer_no_dl_data.EQ_SIZE, cur_booked_discharge_data.DN_EQ_SIZE) = cur_booked_discharge_data.DN_EQ_SIZE AND
                NVL( cur_cointainer_no_dl_data.EQ_TYPE, cur_booked_discharge_data.DN_EQ_TYPE) = cur_booked_discharge_data.DN_EQ_TYPE AND
                NVL( cur_cointainer_no_dl_data.SPECIAL_HANDLING, cur_booked_discharge_data.DN_SPECIAL_HNDL) = cur_booked_discharge_data.DN_SPECIAL_HNDL) THEN
               IF (cur_booked_discharge_data.DN_EQUIPMENT_NO = cur_cointainer_no_dl_data.EQUIPMENT_NO  OR cur_booked_discharge_data.DN_EQUIPMENT_NO IS NULL) THEN
                  g_v_sql_id := 'SQL-04006';
                  BEGIN
  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 CALLING LLDL_MATHC_UPDATE FOR DL IN MANUAL MATCHING'
                                                   ,'START : ' || SYSDATE
                                                   ); --*/
                     PRE_TOS_LLDL_MATCH_UPDATE('DL'
                                            , cur_cointainer_no_dl_data.EQUIPMENT_NO
                                            , cur_cointainer_no_dl_data.OVERHEIGHT_CM
                                            , cur_cointainer_no_dl_data.OVERLENGTH_REAR_CM
                                            , cur_cointainer_no_dl_data.OVERLENGTH_FRONT_CM
                                            , cur_cointainer_no_dl_data.OVERWIDTH_LEFT_CM
                                            , cur_cointainer_no_dl_data.OVERWIDTH_RIGHT_CM
                                            , cur_cointainer_no_dl_data.UN_NUMBER
                                            , cur_cointainer_no_dl_data.UN_NUMBER_VARIANT
                                            , cur_cointainer_no_dl_data.FLASHPOINT
                                            , cur_cointainer_no_dl_data.FLASHPOINT_UNIT
                                            , cur_cointainer_no_dl_data.IMDG_CLASS
                                            , cur_cointainer_no_dl_data. REEFER_TEMPERATURE
                                            , cur_cointainer_no_dl_data.REEFER_TMP_UNIT
                                            , cur_cointainer_no_dl_data.HUMIDITY
                                            , cur_cointainer_no_dl_data.VENTILATION
                                            , cur_cointainer_no_dl_data.PORT_CLASS
                                            , cur_cointainer_no_dl_data.PORT_CLASS_TYP
                                            , cur_booked_discharge_data.PK_BOOKED_DISCHARGE_ID
                                            , cur_cointainer_no_dl_data.PK_OVERLANDED_CONTAINER_ID
                                            , NULL
                                            , NULL
                                            , cur_booked_discharge_data.EQUIPMENT_SEQ_NO
                                            , cur_booked_discharge_data.FK_BOOKING_NO
                                            , cur_cointainer_no_dl_data.CONTAINER_GROSS_WEIGHT
                                            , cur_cointainer_no_dl_data.VGM    --*49
                                            , cur_cointainer_no_dl_data.STOWAGE_POSITION
                                            , cur_cointainer_no_dl_data.CONTAINER_OPERATOR
                                            , NULL
                                            , p_i_n_discharge_list_id
                                            , cur_cointainer_no_dl_data.MIDSTREAM_HANDLING_CODE
                                            , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_1 -- *10
                                            , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_2 -- *10
                                            , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_3 -- *10
                                            , CUR_COINTAINER_NO_DL_DATA.ACTIVITY_DATE_TIME -- *29
                                            , NULL --*36
                                            , NULL --*36
                                            , p_o_v_return_status );
  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER CALLING LLDL_MATHC_UPDATE FOR DL IN MANUAL MATCHING'
                                                   ,'END : ' || SYSDATE
                                                   ); --*/
                  IF p_o_v_return_status = '1' THEN
                     g_v_err_code   := TO_CHAR(SQLCODE);
                     g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                     RAISE l_exce_main;
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     g_v_err_code   := TO_CHAR(SQLCODE);
                     g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                     RAISE l_exce_main;
               END;
               ELSIF cur_booked_discharge_data.DN_EQUIPMENT_NO <> cur_cointainer_no_dl_data.EQUIPMENT_NO THEN
                  g_v_sql_id := 'SQL-04007';
                  BEGIN
                     PRE_TOS_LLDL_MOVE(NULL, cur_booked_discharge_data.PK_BOOKED_DISCHARGE_ID, 'DL', p_o_v_return_status);
                        IF p_o_v_return_status = '1' THEN
                               RAISE l_exce_main;
                        END IF;
                  EXCEPTION
                     WHEN OTHERS THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                  END;
                  BEGIN
                     g_v_sql_id := 'SQL-04008';
  /*--VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'B4 CALLING LLDL_MATHC_UPDATE FOR DL IN MANUAL MATCHING'
                                                   ,'START : ' || SYSDATE
                                                   ); --*/
                     PRE_TOS_LLDL_MATCH_UPDATE('DL'
                                            , cur_cointainer_no_dl_data.EQUIPMENT_NO
                                            , cur_cointainer_no_dl_data.OVERHEIGHT_CM
                                            , cur_cointainer_no_dl_data.OVERLENGTH_REAR_CM
                                            , cur_cointainer_no_dl_data.OVERLENGTH_FRONT_CM
                                            , cur_cointainer_no_dl_data.OVERWIDTH_LEFT_CM
                                            , cur_cointainer_no_dl_data.OVERWIDTH_RIGHT_CM
                                            , cur_cointainer_no_dl_data.UN_NUMBER
                                            , cur_cointainer_no_dl_data.UN_NUMBER_VARIANT
                                            , cur_cointainer_no_dl_data.FLASHPOINT
                                            , cur_cointainer_no_dl_data.FLASHPOINT_UNIT
                                            , cur_cointainer_no_dl_data.IMDG_CLASS
                                            , cur_cointainer_no_dl_data. REEFER_TEMPERATURE
                                            , cur_cointainer_no_dl_data.REEFER_TMP_UNIT
                                            , cur_cointainer_no_dl_data.HUMIDITY
                                            , cur_cointainer_no_dl_data.VENTILATION
                                            , cur_cointainer_no_dl_data.PORT_CLASS
                                            , cur_cointainer_no_dl_data.PORT_CLASS_TYP
                                            , cur_booked_discharge_data.PK_BOOKED_DISCHARGE_ID
                                            , cur_cointainer_no_dl_data.PK_OVERLANDED_CONTAINER_ID
                                            , NULL
                                            , NULL
                                            , cur_booked_discharge_data.EQUIPMENT_SEQ_NO
                                            , cur_booked_discharge_data.FK_BOOKING_NO
                                            , cur_cointainer_no_dl_data.CONTAINER_GROSS_WEIGHT
                                            , cur_cointainer_no_dl_data.VGM
                                            , cur_cointainer_no_dl_data.STOWAGE_POSITION
                                            , cur_cointainer_no_dl_data.CONTAINER_OPERATOR
                                            , NULL
                                            , p_i_n_discharge_list_id
                                            , cur_cointainer_no_dl_data.MIDSTREAM_HANDLING_CODE
                                            , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_1 -- *10
                                            , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_2 -- *10
                                            , CUR_COINTAINER_NO_DL_DATA.HANDLING_INSTRUCTION_3 -- *10
                                            , CUR_COINTAINER_NO_DL_DATA.ACTIVITY_DATE_TIME -- *29
                                            , NULL --*36
                                            , NULL --*36
                                            , p_o_v_return_status );
/*--
  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PCE_ECM_EDI_'
                                                   ,'-'
                                                   ,'AFTER CALLING LLDL_MATHC_UPDATE FOR DL IN MANUAL MATCHING'
                                                   ,'END : ' || SYSDATE
                                                   ); --*/

                     IF p_o_v_return_status = '1' THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                     END IF;
                  EXCEPTION
                     WHEN OTHERS THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                  END;
               END IF;
            END IF;
         END LOOP;
END LOOP;  --end of main loop cur_cointainer_no_dl

    /*
        Block start by vikas, to update status count into header table, after matching, 05.03.2012
    */
    IF p_i_v_list_type = 'LL' THEN
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
            p_i_n_load_list_id
            , 'L'
            , g_v_err_code
        );
    ELSE
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
            p_i_n_discharge_list_id
            , 'D'
            , g_v_err_code
        );
    END IF;
    /*
        Block ended by vikas, 05.03.2012
    */

 COMMIT;
 p_o_v_return_status := '0';
EXCEPTION
   WHEN l_exce_main THEN
      p_o_v_return_status := '1';
      ROLLBACK;
 PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                                          , 'Manual Match'
                                          , g_v_opr_type
                                          , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                          , 'A'
                                          , g_v_user
                                          , SYSDATE -- CURRENT_TIMESTAMP --*24
                                          , g_v_user
                                          , SYSDATE -- CURRENT_TIMESTAMP --*24
                                            );
          COMMIT;
   WHEN OTHERS THEN
      p_o_v_return_status := '1';
      ROLLBACK;
 PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                                          , 'Manual Match'
                                          , g_v_opr_type
                                          , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                                          , 'A'
                                          , g_v_user
                                          , SYSDATE -- CURRENT_TIMESTAMP --*24
                                          , g_v_user
                                          , SYSDATE -- CURRENT_TIMESTAMP --*24
                                            );
       COMMIT;
END PRE_TOS_LLDL_MANUAL_MATCHING;

FUNCTION VALIDATE_INBOUND_FIELD
( p_i_n_edi_etd_uid            IN         NUMBER
, p_i_v_info                   IN         VARCHAR2
, p_i_v_equ_no                 IN         VARCHAR2
, p_i_v_act_plc                IN         VARCHAR2
, p_i_v_act_term               IN         VARCHAR2
, p_i_v_act_cd                 IN         VARCHAR2
, p_i_v_act_dt                 IN         DATE
) RETURN NUMBER
IS

l_v_err                        VARCHAR2(1) := '0';

BEGIN

   --DBMS_OUTPUT.PUT_LINE('  p_i_v_equ_no: '||p_i_v_equ_no);
   --DBMS_OUTPUT.PUT_LINE('  p_i_v_act_plc: '||p_i_v_act_plc);
   --DBMS_OUTPUT.PUT_LINE('  p_i_v_act_term: '||p_i_v_act_term);
   --DBMS_OUTPUT.PUT_LINE('  p_i_v_act_cd: '||p_i_v_act_dt);

   IF p_i_v_equ_no IS NULL THEN
      PKG_EDI_TRANSACTION.ADD_TO_ERROR (p_i_n_edi_etd_uid
                                      ,'E0004'
                                      ,'H'
                                      , NULL
                                      , p_i_v_info
                                       );
      l_v_err := '1';
   ELSIF p_i_v_act_plc IS NULL THEN
      PKG_EDI_TRANSACTION.ADD_TO_ERROR (p_i_n_edi_etd_uid
                                      ,'E0010'
                                      ,'H'
                                      , NULL
                                      , p_i_v_info
                                       );
      l_v_err := '1';
   ELSIF p_i_v_act_term IS NULL THEN
      PKG_EDI_TRANSACTION.ADD_TO_ERROR (p_i_n_edi_etd_uid
                                      ,'E0010'
                                      ,'H'
                                      , NULL
                                      , p_i_v_info
                                       );
      l_v_err := '1';
   ELSIF p_i_v_act_cd IS NULL THEN
      PKG_EDI_TRANSACTION.ADD_TO_ERROR (p_i_n_edi_etd_uid
                                      ,'E0012'
                                      ,'H'
                                      , NULL
                                      , p_i_v_info
                                       );
      l_v_err := '1';
   ELSIF p_i_v_act_cd NOT IN (g_v_discharge_act_code,g_v_load_act_code) THEN
      PKG_EDI_TRANSACTION.ADD_TO_ERROR (p_i_n_edi_etd_uid
                                      ,'E0013'
                                      ,'H'
                                      , NULL
                                      , p_i_v_info
                                       );
      l_v_err := '1';
   ELSIF p_i_v_act_dt IS NULL THEN
      PKG_EDI_TRANSACTION.ADD_TO_ERROR (p_i_n_edi_etd_uid
                                      ,'E0016'
                                      ,'H'
                                      , NULL
                                      , p_i_v_info
                                       );
      l_v_err := '1';

    /*
        *17: Start
    *
    ELSIF p_i_v_act_dt > SYSDATE THEN
        PKG_EDI_TRANSACTION.ADD_TO_ERROR (p_i_n_edi_etd_uid
                                        ,'E0008'
                                        ,'H'
                                        , NULL
                                        , p_i_v_info
                                        );
        l_v_err := '1';
    *
        *17: End
    */

   END IF;

   IF l_v_err = '1' THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;

END VALIDATE_INBOUND_FIELD;

PROCEDURE GET_LLDL_ID
    ( p_i_v_voy                 IN  VARCHAR2
    , p_i_v_ves                 IN  VARCHAR2
    , p_i_v_loc                 IN  VARCHAR2
    , p_i_v_term                IN  VARCHAR2
    , p_i_v_serv                IN  VARCHAR2
    , p_i_v_dir                 IN  VARCHAR2
    , p_i_v_seq                 IN  VARCHAR2
    , p_i_v_ver                 IN  VARCHAR2
    , p_i_v_lldl_fl             IN  VARCHAR2
    , p_o_v_lldl_id             OUT NUMBER
) AS

l_v_serv_grp         ITP085.SERVICE_GROUP_CODE%TYPE;
l_n_rec_found        NUMBER := 0;
l_t_log_info         TIMESTAMP(6) ;

BEGIN

    l_t_log_info := SYSDATE; -- CURRENT_TIMESTAMP; --*24
/*-- *50 remove logging
    PRE_LOG_INFO
     ('PCE_ECM_EDI.GET_LLDL_ID'
    , 'PARAMETERS'
    , '1'
    , g_v_user
    , l_t_log_info
    , p_i_v_voy     || SEP ||
      p_i_v_ves     || SEP ||
      p_i_v_loc     || SEP ||
      p_i_v_term    || SEP ||
      p_i_v_serv    || SEP ||
      p_i_v_dir     || SEP ||
      p_i_v_seq     || SEP ||
      p_i_v_ver     || SEP ||
      p_i_v_lldl_fl
    , NULL
    , NULL
    , NULL
    ); --*/
    g_v_sql_id := 'SQL-09001';

   SELECT 1
   INTO   l_n_rec_found
   FROM   ITP063
   WHERE
          ((VVVOYN    = p_i_v_voy
           AND  p_i_v_lldl_fl = 'L'
          )
          OR
          (DECODE(p_i_v_serv, 'AFS', VVVOYN, INVOYAGENO) = p_i_v_voy
           AND  p_i_v_lldl_fl = 'D'
          ))
   AND    VVVESS    = p_i_v_ves
   AND    VVPCAL    = p_i_v_loc
   AND    VVTRM1    = p_i_v_term
   AND    VVLDDS    <> 'D'
   AND    VVVERS    = 99
   AND    OMMISSION_FLAG IS NULL
   AND    ROWNUM    = 1;
/*--*50 remove logging
    PRE_LOG_INFO
     ('PCE_ECM_EDI.GET_LLDL_ID'
    , 'PARAMETERS'
    , '2'
    , g_v_user
    , l_t_log_info
    , l_n_rec_found
    , NULL
    , NULL
    , NULL
    ); --*/

    g_v_sql_id := 'SQL-09002';
   BEGIN
      SELECT SERVICE_GROUP_CODE
      INTO   l_v_serv_grp
      FROM   ITP085
      WHERE  SWSRVC = p_i_v_serv;
   EXCEPTION
      WHEN OTHERS THEN
         l_v_serv_grp := NULL;
   END;
/*-- *50 remove logging
   PRE_LOG_INFO
     ('PCE_ECM_EDI.GET_LLDL_ID'
    , 'PARAMETERS'
    , '3'
    , g_v_user
    , l_t_log_info
    , l_v_serv_grp
    , NULL
    , NULL
    , NULL
    ); --*/

    g_v_sql_id := 'SQL-09003';
   IF l_n_rec_found = 1 THEN
      IF p_i_v_lldl_fl = 'L' THEN
          SELECT SE_LLZ01.NEXTVAL
          INTO   p_o_v_lldl_id
          FROM   DUAL;

/*--*50 remove logging
          PRE_LOG_INFO
             ('PCE_ECM_EDI.GET_LLDL_ID'
            , 'PARAMETERS'
            , '4'
            , g_v_user
            , l_t_log_info
            , p_o_v_lldl_id
            , NULL
            , NULL
            , NULL
            ); --*/

          g_v_sql_id := 'SQL-03009';
          INSERT INTO TOS_LL_LOAD_LIST
          (
               PK_LOAD_LIST_ID,DN_SERVICE_GROUP_CODE,FK_SERVICE,FK_VESSEL,
               FK_VOYAGE,FK_DIRECTION,FK_PORT_SEQUENCE_NO,FK_VERSION,
               DN_PORT,DN_TERMINAL,LOAD_LIST_STATUS,DA_BOOKED_TOT,
               DA_LOADED_TOT,DA_ROB_TOT,DA_OVERSHIPPED_TOT,DA_SHORTSHIPPED_TOT,
               RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,
               RECORD_CHANGE_DATE
          )
          VALUES
          (
               p_o_v_lldl_id,l_v_serv_grp,p_i_v_serv,
               p_i_v_ves,p_i_v_voy,
               p_i_v_dir, p_i_v_seq,p_i_v_ver,
               p_i_v_loc,p_i_v_term,'0',0,
               0,0,0,0,'A',g_v_user
               ,SYSDATE -- CURRENT_TIMESTAMP --*24
               ,g_v_user
               ,SYSDATE -- CURRENT_TIMESTAMP --*24
          );

      ELSE
          SELECT SE_DLZ01.NEXTVAL
          INTO   p_o_v_lldl_id
          FROM   DUAL;
/*-- *50 remove logging
          PRE_LOG_INFO
             ('PCE_ECM_EDI.GET_LLDL_ID'
            , 'PARAMETERS'
            , '5'
            , g_v_user
            , l_t_log_info
            , p_o_v_lldl_id
            , NULL
            , NULL
            , NULL
            ); --*/

    g_v_sql_id := 'SQL-09004';
          INSERT INTO TOS_DL_DISCHARGE_LIST
          (
               PK_DISCHARGE_LIST_ID,DN_SERVICE_GROUP_CODE,FK_SERVICE,FK_VESSEL,
               FK_VOYAGE,FK_DIRECTION,FK_PORT_SEQUENCE_NO,FK_VERSION,
               DN_PORT,DN_TERMINAL,DISCHARGE_LIST_STATUS,DA_DISCHARGED_TOT,
               DA_BOOKED_TOT,DA_ROB_TOT,DA_OVERLANDED_TOT,DA_SHORTLANDED_TOT,
               RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,
               RECORD_CHANGE_DATE
          )
          VALUES
          (
               p_o_v_lldl_id,l_v_serv_grp,p_i_v_serv,
               p_i_v_ves,p_i_v_voy,
               p_i_v_dir,p_i_v_seq,p_i_v_ver,
               p_i_v_loc,p_i_v_term,'0',0,
               0,0,0,0,'A',g_v_user
               ,SYSDATE -- CURRENT_TIMESTAMP --*24
               ,g_v_user
               ,SYSDATE -- CURRENT_TIMESTAMP --*24
          );

      END IF;
   ELSE
      p_o_v_lldl_id := 0;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      p_o_v_lldl_id := 0;
   WHEN OTHERS THEN
      p_o_v_lldl_id := 0;
END GET_LLDL_ID;

PROCEDURE GET_SVRDIRSEQ
    ( p_i_v_bkg_no              IN     VARCHAR2
    , p_i_v_voy                 IN     VARCHAR2
    , p_i_v_loc                 IN     VARCHAR2  -- activetiy place
    , p_i_v_term                IN     VARCHAR2  -- translated activity location
    , p_i_v_act_cd              IN     VARCHAR2
    , p_i_o_v_ves               IN OUT VARCHAR2
    , p_i_v_ves_nm              IN     VARCHAR2
    , p_i_v_ezl                 IN     VARCHAR2 -- added 09.01.2012
    , p_i_v_new_old             IN     VARCHAR2 -- added 09.01.2012
    , p_o_v_serv                OUT    VARCHAR2
    , p_o_v_dir                 OUT    VARCHAR2
    , p_o_v_seq                 OUT    VARCHAR2
    , p_o_v_ret                 OUT    VARCHAR2
) AS

l_t_log_info           TIMESTAMP(6);
l_exce_main            EXCEPTION;
l_n_check              NUMBER := 0;
l_b_check_bkp001       BOOLEAN := FALSE;

C_BOTH                 VARCHAR2(1) DEFAULT 'B'; -- *20
C_LOAD                 VARCHAR2(1) DEFAULT 'L'; -- *20
C_DISCHARGE            VARCHAR2(1) DEFAULT 'D'; -- *20


BEGIN
    l_t_log_info := SYSDATE; -- CURRENT_TIMESTAMP; --*24
/*-- *50 remove logging
    PRE_LOG_INFO(
        'PCE_ECM_EDI.GET_SVRDIRSEQ'
        , 'PARAMETERS'
        , '1'
        , g_v_user
        , l_t_log_info
        , p_i_v_bkg_no  || SEP ||
          p_i_v_voy     || SEP ||
          p_i_v_loc     || SEP ||
          p_i_v_term    || SEP ||
          p_i_v_act_cd  || SEP ||
          p_i_v_ezl  || SEP ||
          p_i_o_v_ves
        , NULL
        , NULL
        , NULL
    ); --*/

    /*
        Start Added by vikas, to get vessel code value
        when vessel code is null from edi, as k'chatgamol, 09.01.2012
    */
    IF p_i_o_v_ves IS NULL  THEN
        BEGIN
            SELECT DISTINCT vsl.vsvess
            INTO p_i_o_v_ves
            FROM EDI_ST_EQUIPMENT EQP,
                EDI_TRANSACTION_HEADER HDR,
                ITP060 VSL
            WHERE HDR.RECORD_ADD_DATE > SYSDATE-2
            AND hdr.MODULE          = p_i_v_ezl
            AND hdr.DIRECTION       = 'IN'
            AND hdr.RECORD_STATUS   = 'A'
            AND hdr.STATUS          = DECODE(p_i_v_new_old, 'NEW', 'R', 'OLD', 'E')
            AND eqp.msg_reference    = hdr.msg_reference
            AND (vsl.vslgnm         = eqp.vessel_name OR EQP.VESSEL_CODE IN(VSL.VSVESS, TO_CHAR(VSL.LOYD_NO), TO_CHAR(VSL.VSCLSN)) )
            AND vessel_name         = p_i_v_ves_nm;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                /*
                    Get barge vessel
                */
                BEGIN
                    SELECT
                        vessel
                    INTO
                        p_i_o_v_ves
                    FROM
                        AFS_VOYAGE_SCHEDULE
                    WHERE
                        ACTUAL_BARGE_NAME = TRIM(p_i_v_ves_nm) -- RCL-21361 /Change vessel code to vessel name
                        AND ACTUAL_BARGE_VOYAGE = p_i_v_voy
                        AND VERSION             ='99'
                        AND ROWNUM              = 1;
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END; -- end of inner block

            WHEN OTHERS THEN
                NULL;
        END; -- end of outer block
    END IF;
    /*
        End Added by vikas 09.01.2012
    */

    /*
        *12: Changes start
    */
    IF ((LENGTH(TRIM(p_i_o_v_ves)) = 5 )AND (NVL(p_i_o_v_ves, '*') <> 'BARGE') )THEN  -- *13
        BEGIN

            /*PRE_LOG_INFO
                ('PCE_ECM_EDI.GET_SVRDIRSEQ'
                , 'CHECK'
                , '1.1'
                , g_v_user
                , l_t_log_info
                , 'STEP EXECUTED'
                , NULL
                , NULL
                , NULL
                );*/ --*37

            SELECT
                VSVESS
            INTO
                p_i_o_v_ves
            FROM
                ITP060
            WHERE
                VSCLSN =  p_i_o_v_ves;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_err_code   := TO_CHAR(SQLCODE);
                g_v_err_desc   := 'No Data Found in ITP060';
                RAISE l_exce_main;

            WHEN OTHERS THEN
                g_v_err_code   := TO_CHAR(SQLCODE);
                g_v_err_desc   := 'No Data Found in ITP060';
                RAISE l_exce_main;
        END;
    END IF;

    /*
        *12: Changes End
    */

    IF p_i_v_bkg_no IS NULL THEN
        BEGIN
            SELECT  VVSRVC
                    ,VVPDIR
                    ,VVPCSQ
            INTO    p_o_v_serv
                    ,p_o_v_dir
                    ,p_o_v_seq
            FROM   ITP063
            WHERE
                -- VOYAGE_ID = p_i_v_voy -- *11
                -- AND     -- *11
                    VVVESS    = p_i_o_v_ves
            AND    VVPCAL    = p_i_v_loc
            AND    VVTRM1    = p_i_v_term
            -- AND    VVLDDS <> DECODE(p_i_v_act_cd, '46','D' , 'L') -- *20
            AND    (((p_i_v_act_cd = g_v_load_act_code) AND (VVLDDS = C_BOTH OR VVLDDS = C_LOAD )) -- *20
            OR     ((p_i_v_act_cd = g_v_discharge_act_code) AND (VVLDDS = C_BOTH OR VVLDDS = C_DISCHARGE ))) -- *20
            AND    VVVERS    = 99
            AND    OMMISSION_FLAG IS NULL
            -- AND    VVFORL IS NOT NULL -- Added as suggested by k'chatgamol and k'sukit, 28.02.2012  -- *15
            AND    (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) -- *15
            AND    ROWNUM    = 1
            AND    ( -- *11
                        (p_i_v_act_cd = g_v_load_act_code AND VVVOYN = p_i_v_voy) -- for load list -- *11
                        OR -- *11
                       -- (p_i_v_act_cd <> g_v_load_act_code AND INVOYAGENO = p_i_v_voy) -- for discharge list -- *11 -- Commented for *21
                        (p_i_v_act_cd <> g_v_load_act_code AND DECODE( p_i_o_v_ves, 'BARGE', VVVOYN, INVOYAGENO) = p_i_v_voy) --  for discharge list --*21
                   ); -- *11

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                BEGIN
                /*-- *50 remove logging
                PRE_LOG_INFO
                    ('PCE_ECM_EDI.GET_SVRDIRSEQ'
                    , 'CHECK'
                    , '2'
                    , g_v_user
                    , l_t_log_info
                    , 'STEP EXECUTED'
                    , NULL
                    , NULL
                    , NULL
                    ); --*/

                /*SELECT VSVESS
                INTO   p_i_o_v_ves
                FROM   ITP060
                WHERE  VSCLSN = p_i_o_v_ves;*/
                    pkg_edi_transaction.vessel_code_translation (p_i_o_v_ves,p_i_v_ves_nm,p_i_o_v_ves);
                        PRE_LOG_INFO
                        ('PCE_ECM_EDI.GET_SVRDIRSEQ'
                        , 'CHECK'
                        , '100.3'
                        , g_v_user
                        , l_t_log_info
                        , 'STEP EXECUTED'
                        , NULL
                        , NULL
                        , NULL
                        );
                SELECT  VVSRVC
                        ,VVPDIR
                        ,VVPCSQ
                INTO    p_o_v_serv
                        ,p_o_v_dir
                        ,p_o_v_seq
                FROM   ITP063
                WHERE
                --        VOYAGE_ID = p_i_v_voy       -- *11
                -- AND     -- *11
                VVVESS    = p_i_o_v_ves
                AND    VVPCAL    = p_i_v_loc
                AND    VVTRM1    = p_i_v_term
                -- AND    VVLDDS    <> DECODE(p_i_v_act_cd, g_v_load_act_code,'D' , 'L') -- *20
                AND    ((p_i_v_act_cd = g_v_load_act_code AND (VVLDDS = C_BOTH OR VVLDDS = C_LOAD )) -- *20
                OR     (p_i_v_act_cd = g_v_discharge_act_code AND (VVLDDS = C_BOTH OR VVLDDS = C_DISCHARGE ))) -- *20
                AND    VVVERS    = 99
                AND    OMMISSION_FLAG IS NULL
                -- AND    VVFORL IS NOT NULL -- Added as suggested by k'chatgamol and k'sukit, 28.02.2012 -- *15
                AND    (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) -- *15
                AND    ROWNUM    = 1
                AND    ( -- *11
                            (p_i_v_act_cd = g_v_load_act_code AND VVVOYN = p_i_v_voy)      -- for load list -- *11
                            OR -- *11
                          --  (p_i_v_act_cd <> g_v_load_act_code AND INVOYAGENO = p_i_v_voy) -- for discharge list -- *11 -- Commented for *21
                            (p_i_v_act_cd <> g_v_load_act_code AND DECODE (p_i_o_v_ves, 'BARGE', VVVOYN, INVOYAGENO) = p_i_v_voy) -- for discharge list  --  *21
                       ); -- *11
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := 'No Data Found in ITP063';
                        RAISE l_exce_main;
                    WHEN OTHERS THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                    END;
            WHEN OTHERS THEN
                g_v_err_code   := TO_CHAR(SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                RAISE l_exce_main;
        END;
    /*PRE_LOG_INFO
    ('PCE_ECM_EDI.GET_SVRDIRSEQ'
    , 'CHECK'
    , '3'
    , g_v_user
    , l_t_log_info
    , 'STEP EXECUTED'
    , NULL
    , NULL
    , NULL
    );*/ --37

   ELSE
      BEGIN
         SELECT 1
         INTO   l_n_check
         FROM   BKP001
         WHERE  BABKNO = p_i_v_bkg_no;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT  VVSRVC
                        ,VVPDIR
                        ,VVPCSQ
                INTO    p_o_v_serv
                        ,p_o_v_dir
                        ,p_o_v_seq
                FROM   ITP063
                WHERE
                    -- VOYAGE_ID = p_i_v_voy  -- *11
                -- AND      -- *11
                       VVVESS    = p_i_o_v_ves
                AND    VVPCAL    = p_i_v_loc
                AND    VVTRM1    = p_i_v_term
                -- AND    VVLDDS    <> DECODE(p_i_v_act_cd, g_v_load_act_code,'D' , 'L') -- *20
                AND    ((p_i_v_act_cd = g_v_load_act_code AND (VVLDDS = C_BOTH OR VVLDDS = C_LOAD )) -- *20
                OR     (p_i_v_act_cd = g_v_discharge_act_code AND (VVLDDS = C_BOTH OR VVLDDS = C_DISCHARGE ))) -- *20
                AND    VVVERS    = 99
                AND    OMMISSION_FLAG IS NULL
                -- AND    VVFORL IS NOT NULL -- Added as suggested by k'chatgamol and k'sukit, 28.02.2012 -- *15
                AND    (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) -- *15
                AND    ROWNUM    = 1
                AND    ( -- *11
                            (p_i_v_act_cd = g_v_load_act_code AND VVVOYN = p_i_v_voy)      -- for load list -- *11
                            OR -- *11
                           -- (p_i_v_act_cd <> g_v_load_act_code AND INVOYAGENO = p_i_v_voy) -- for discharge list -- *11 --Commented for *21
                            (p_i_v_act_cd <> g_v_load_act_code AND DECODE(p_i_o_v_ves, 'BARGE', VVVOYN, INVOYAGENO) = p_i_v_voy) -- for discharge list --*21
                       ); -- *11
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  BEGIN
                  /*--*50 remove logging
                     PRE_LOG_INFO
                       ('PCE_ECM_EDI.GET_SVRDIRSEQ'
                      , 'CHECK'
                      , '3.1'
                      , g_v_user
                      , l_t_log_info
                      , 'STEP EXECUTED'
                      , NULL
                      , NULL
                      , NULL
                      ); --*/

                     l_b_check_bkp001 := TRUE;

                     /*SELECT VSVESS
                     INTO   p_i_o_v_ves
                     FROM   ITP060
                     WHERE  VSCLSN = p_i_o_v_ves;*/
                     pkg_edi_transaction.vessel_code_translation (p_i_o_v_ves,p_i_v_ves_nm,p_i_o_v_ves);
                     /*-- *50 remove logging
                     PRE_LOG_INFO
                       ('PCE_ECM_EDI.GET_SVRDIRSEQ'
                      , 'CHECK'
                      , '100.1'
                      , g_v_user
                      , l_t_log_info
                      , 'STEP EXECUTED'
                      , NULL
                      , NULL
                      , NULL
                      ); --*/

                    SELECT  VVSRVC
                            ,VVPDIR
                            ,VVPCSQ
                    INTO    p_o_v_serv
                            ,p_o_v_dir
                            ,p_o_v_seq
                    FROM   ITP063
                    WHERE
                        -- VOYAGE_ID = p_i_v_voy -- *11
                    -- AND      -- *11
                    VVVESS    = p_i_o_v_ves
                    AND    VVPCAL    = p_i_v_loc
                    AND    VVTRM1    = p_i_v_term
                    -- AND    VVLDDS    <> DECODE(p_i_v_act_cd, g_v_load_act_code,'D' , 'L') -- *20
                    AND    ((p_i_v_act_cd = g_v_load_act_code AND (VVLDDS = C_BOTH OR VVLDDS = C_LOAD )) -- *20
                    OR     (p_i_v_act_cd = g_v_discharge_act_code AND (VVLDDS = C_BOTH OR VVLDDS = C_DISCHARGE ))) -- *20

                    AND    VVVERS    = 99
                    AND    OMMISSION_FLAG IS NULL
                    -- AND    VVFORL IS NOT NULL -- Added as suggested by k'chatgamol and k'sukit, 28.02.2012 -- *15
                    AND    (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) -- *15
                    AND    ROWNUM    = 1
                    AND    ( -- *11
                                (p_i_v_act_cd = g_v_load_act_code AND VVVOYN = p_i_v_voy)      -- for load list -- *11
                                OR -- *11
                              --  (p_i_v_act_cd <> g_v_load_act_code AND INVOYAGENO = p_i_v_voy) -- for discharge list -- *11 --Commented for *21
                                (p_i_v_act_cd <> g_v_load_act_code AND DECODE(p_i_o_v_ves, 'BARGE', VVVOYN, INVOYAGENO) = p_i_v_voy) -- for discharge list  --*21
                            ); -- *11
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := 'No Data Found in BKP001/ITP063';
                        RAISE l_exce_main;
                     WHEN OTHERS THEN
                        g_v_err_code   := TO_CHAR(SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exce_main;
                   END;
               WHEN OTHERS THEN
                  g_v_err_code   := TO_CHAR(SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                  RAISE l_exce_main;
             END;
--            g_v_err_code   := TO_CHAR(SQLCODE);
--            g_v_err_desc   := 'No Data Found in BKP001';
--            RAISE l_exce_main;
         WHEN OTHERS THEN
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            RAISE l_exce_main;
      END;
      l_n_check := 0;
     /*PRE_LOG_INFO
     ('PCE_ECM_EDI.GET_SVRDIRSEQ'
    , 'CHECK'
    , '4'
    , g_v_user
    , l_t_log_info
    , 'STEP EXECUTED'
    , NULL
    , NULL
    , NULL
    ); */ --*37
    /*
        *6 -Modified By vikas, if booking no is comming from EDI, then no need to check terminal
        to get service, direction, port from booking_voyage_routing_dtl table, as k'chatgamol, 08.03.2012
    */
    IF l_b_check_bkp001 = FALSE THEN
      BEGIN
         IF p_i_v_act_cd = g_v_load_act_code THEN
            SELECT  SERVICE
                   ,DIRECTION
                   ,POL_PCSQ
            INTO    p_o_v_serv
                   ,p_o_v_dir
                   ,p_o_v_seq
            FROM   BOOKING_VOYAGE_ROUTING_DTL
            WHERE  BOOKING_NO        = p_i_v_bkg_no
            AND    VESSEL            = p_i_o_v_ves
            AND    VOYNO             = p_i_v_voy
            AND    LOAD_PORT         = p_i_v_loc;
            -- AND    FROM_TERMINAL     = p_i_v_term; -- *6
         ELSE
            SELECT  ACT_SERVICE_CODE
                   ,ACT_PORT_DIRECTION
                   ,ACT_PORT_SEQUENCE
            INTO    p_o_v_serv
                   ,p_o_v_dir
                   ,p_o_v_seq
            FROM   BOOKING_VOYAGE_ROUTING_DTL
            WHERE  BOOKING_NO          = p_i_v_bkg_no
            AND    ACT_VESSEL_CODE     = p_i_o_v_ves
/*            AND    ACT_VOYAGE_NUMBER   = p_i_v_voy    -- fixed against bug 588, 29.10.2011
              AND    ACT_VOYAGE_NUMBER   =
                (SELECT VVVOYN
                FROM ITP063
                WHERE VVVERS    =99
                AND VVVESS      = p_i_o_v_ves
                AND INVOYAGENO  = p_i_v_voy
                AND ACT_DMY_FLG = 'A'
                AND VVPCAL      =p_i_v_loc)*/
                AND DISCHARGE_PORT = p_i_v_loc;
          --   AND TO_TERMINAL    = p_i_v_term; -- *6

         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
            /*-- *50 remove logging
               PRE_LOG_INFO
              ('PCE_ECM_EDI.GET_SVRDIRSEQ'
             , 'CHECK'
             , '5'
             , g_v_user
             , l_t_log_info
             , 'STEP EXECUTED'
             , NULL
             , NULL
             , NULL
               ); --*/

               /*SELECT VSVESS
               INTO   p_i_o_v_ves
               FROM   ITP060
               WHERE  VSCLSN = p_i_o_v_ves;*/
               pkg_edi_transaction.vessel_code_translation (p_i_o_v_ves,p_i_v_ves_nm,p_i_o_v_ves);
                  /*--*50 remove logging
                  PRE_LOG_INFO
                  ('PCE_ECM_EDI.GET_SVRDIRSEQ'
                      , 'CHECK'
                      , '100.2'
                      , g_v_user
                      , l_t_log_info
                      , 'STEP EXECUTED'
                      , NULL
                      , NULL
                      , NULL
                      ); --*/
                IF p_i_v_act_cd = g_v_load_act_code THEN
                    SELECT  SERVICE
                            ,DIRECTION
                            ,POL_PCSQ
                    INTO    p_o_v_serv
                            ,p_o_v_dir
                            ,p_o_v_seq
                    FROM   BOOKING_VOYAGE_ROUTING_DTL
                    WHERE  BOOKING_NO        = p_i_v_bkg_no
                    AND    VESSEL            = p_i_o_v_ves
                    AND    VOYNO             = p_i_v_voy
                    AND    LOAD_PORT         = p_i_v_loc;
                  --   AND    FROM_TERMINAL     = p_i_v_term; -- *6
                ELSE
                    SELECT  ACT_SERVICE_CODE
                            ,ACT_PORT_DIRECTION
                            ,ACT_PORT_SEQUENCE
                    INTO    p_o_v_serv
                            ,p_o_v_dir
                            ,p_o_v_seq
                    FROM   BOOKING_VOYAGE_ROUTING_DTL
                    WHERE  BOOKING_NO          = p_i_v_bkg_no
                    AND    ACT_VESSEL_CODE     = p_i_o_v_ves
        --            AND    ACT_VOYAGE_NUMBER   = p_i_v_voy  -- fixed against bug 588, 29.10.2011
          /*          AND    ACT_VOYAGE_NUMBER   =
                        (SELECT VVVOYN
                        FROM ITP063
                        WHERE VVVERS    =99
                        AND VVVESS      = p_i_o_v_ves
                        AND INVOYAGENO  = p_i_v_voy
                        AND ACT_DMY_FLG = 'A'
                        AND VVPCAL      =p_i_v_loc)*/
                        AND DISCHARGE_PORT = p_i_v_loc;
                 --   AND TO_TERMINAL    = p_i_v_term; -- *6
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  g_v_err_code   := TO_CHAR(SQLCODE);
                  g_v_err_desc   := 'No Data Found in BOOKING_VOYAGE_ROUTING_DTL';
                  RAISE l_exce_main;
               WHEN OTHERS THEN
                  g_v_err_code   := TO_CHAR(SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                  RAISE l_exce_main;
            END;
         WHEN OTHERS THEN
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            RAISE l_exce_main;
      END;
    END IF;
    /*PRE_LOG_INFO
     ('PCE_ECM_EDI.GET_SVRDIRSEQ'
    , 'CHECK'
    , '6'
    , g_v_user
    , l_t_log_info
    , 'STEP EXECUTED'
    , NULL
    , NULL
    , NULL
    );*/ --37

   END IF;
   p_o_v_ret := '0';
EXCEPTION
   WHEN l_exce_main THEN
      p_o_v_ret := '1';
      /*--*50 remove logging
      PRE_LOG_INFO
      ('PCE_ECM_EDI.GET_SVRDIRSEQ'
     , g_v_err_code
     , g_v_sql_id
     , g_v_user
     , l_t_log_info
     , g_v_err_desc
     , NULL
     , NULL
     , NULL
     ); --*/


   WHEN OTHERS THEN
      p_o_v_ret := '1';
      g_v_err_code   := TO_CHAR (SQLCODE);
      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
     /*-- *50 remove logging
      PRE_LOG_INFO
      ('PCE_ECM_EDI.GET_SVRDIRSEQ'
     , g_v_err_code
     , g_v_sql_id
     , g_v_user
     , l_t_log_info
     , g_v_err_desc
     , NULL
     , NULL
     , NULL
     ); --*/
END GET_SVRDIRSEQ;

    /*
        This procedure is used to update weight and stowagw position
        into the booked discharge table whenever this two fields
        change in the booked loading table.

        Parameters
        ===========
        p_i_v_booked_id    => booked loading id
        Created by Vikas on 28.01.2012
    */

    PROCEDURE PRE_UPDATE_STOW_WEIGHT_DL(
          p_i_v_booked_id               VARCHAR2
    ) AS
        l_v_booking_no                  TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE;
        l_v_equipment_no                TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE;
        l_v_terminal                    TOS_LL_BOOKED_LOADING.DN_DISCHARGE_TERMINAL%TYPE;
        l_v_port                        TOS_LL_BOOKED_LOADING.DN_DISCHARGE_PORT%TYPE;
        l_v_dl_booked_id                TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE;
        l_v_flag                        VARCHAR2(1);
        l_v_weight                      TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE;
        l_v_stowage                     TOS_LL_BOOKED_LOADING.STOWAGE_POSITION%TYPE;
        l_v_error_cd                    VARCHAR2(10);

    BEGIN
    --    p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /*
            Get terminal, port, and booking detail of booked loading
        */
        SELECT
              FK_BOOKING_NO
            , DN_EQUIPMENT_NO
            , DN_DISCHARGE_TERMINAL
            , DN_DISCHARGE_PORT
            , CONTAINER_GROSS_WEIGHT
            , STOWAGE_POSITION
        INTO
              l_v_booking_no
            , l_v_equipment_no
            , l_v_terminal
            , l_v_port
            , l_v_weight
            , l_v_stowage
        FROM
            TOS_LL_BOOKED_LOADING
        WHERE
            PK_BOOKED_LOADING_ID = p_i_v_booked_id;

        /*
            Get Corresponding booked discharge list
        */
        PCE_EDL_DLMAINTENANCE.PRE_NEXT_DISCHARGE_LIST_ID (
              l_v_booking_no
            , l_v_equipment_no
            , l_v_terminal
            , l_v_port
            , l_v_dl_booked_id
            , l_v_flag
            , l_v_error_cd
        );

        IF l_v_error_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
            /* ERROR CASE */
            NULL;
        END IF;

        /*
            Update stowage position and weight to the booked discharge list
        */
        IF l_v_flag = 'D' THEN
            UPDATE
                TOS_DL_BOOKED_DISCHARGE
            SET
                STOWAGE_POSITION         =  NVL(l_v_stowage, STOWAGE_POSITION)
                , CONTAINER_GROSS_WEIGHT =  NVL(l_v_weight,  CONTAINER_GROSS_WEIGHT)
            WHERE
                PK_BOOKED_DISCHARGE_ID = l_v_dl_booked_id
                AND RECORD_STATUS = 'A'       -- *30
                AND DISCHARGE_STATUS <> 'DI'; -- *30

        ELSIF l_v_flag = 'R' THEN
            UPDATE
                TOS_RESTOW
            SET
                STOWAGE_POSITION         =  NVL(l_v_stowage, STOWAGE_POSITION)
                , CONTAINER_GROSS_WEIGHT =  NVL(l_v_weight,  CONTAINER_GROSS_WEIGHT)
            WHERE
                PK_RESTOW_ID = l_v_dl_booked_id
                AND RECORD_STATUS = 'A';       -- *30
        END IF;

    --    p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- p_o_v_err_cd := SQLCODE;
            NULL;
        WHEN OTHERS THEN
            --  p_o_v_err_cd := SQLCODE;
            NULL;
    END PRE_UPDATE_STOW_WEIGHT_DL;
    /*
        End of procedure PRE_UPDATE_STOW_WEIGHT_DL
    */

    /*
        This procedure is used to check duplicate container exists in booked table or not
        Date: 15.02.2012

        Parameters
        ===========
        All parateters should have EDI values (value of overlanded/overshipped table).

    */
    PROCEDURE PRE_CHECK_DUPLICATE_CONTAINER (
          P_I_OL_EQUIPMENT_NO                 VASAPPS.TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE
        , P_I_N_LIST_ID                       VASAPPS.TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE
        , P_I_LLDL_FLAG                       VARCHAR2 -- 'L/D'
        , P_I_BOOKED_LLDL_ID                  VASAPPS.TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE -- ADDED 17.02.2012
        , P_V_OL_BOOKING_NO                   VASAPPS.TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE -- ADDED 02.03.2012
        , P_V_OL_EQ_SIZE                      VASAPPS.TOS_LL_OVERSHIPPED_CONTAINER.EQ_SIZE%TYPE -- ADDED 02.03.2012
        , P_V_OL_EQ_TYPE                      VASAPPS.TOS_LL_OVERSHIPPED_CONTAINER.EQ_TYPE%TYPE -- ADDED 02.03.2012
        , P_I_BK_EQUPIMENT_NO                 VASAPPS.TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE -- ADDED 02.03.2012
        , P_O_V_DUP_PK_BOOKED_ID              OUT VASAPPS.TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE -- ADDED 02.03.2012
        , P_O_V_RETURN_STATUS                 OUT VARCHAR2 -- ADDED 02.03.2012
    ) AS
        L_V_COUNT                             NUMBER;
        L_V_DUP_PK_BOOKED_ID                  VASAPPS.TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE;-- ADDED 02.03.2012
    BEGIN

        L_V_COUNT := 0;
        p_o_v_return_status := '0';

        P_O_V_DUP_PK_BOOKED_ID := P_I_BOOKED_LLDL_ID;

        /*
            Block Added by vikas, 02.03.2012

        *
            Check the duplicate container in EZLL/EZDL.
        */
        BEGIN
            SELECT
                PK_BOOKED_LOADING_ID
            INTO
                L_V_DUP_PK_BOOKED_ID
            FROM
            (
                SELECT
                    PK_BOOKED_LOADING_ID
                FROM
                    VASAPPS.TOS_LL_BOOKED_LOADING
                WHERE
                    FK_LOAD_LIST_ID = P_I_N_LIST_ID
                    AND DN_EQUIPMENT_NO = P_I_OL_EQUIPMENT_NO
                    AND RECORD_STATUS = 'A'
                    AND PK_BOOKED_LOADING_ID != P_I_BOOKED_LLDL_ID
                    AND P_I_LLDL_FLAG = 'L'

                UNION ALL

                SELECT
                    PK_BOOKED_DISCHARGE_ID
                FROM
                    VASAPPS.TOS_DL_BOOKED_DISCHARGE
                WHERE
                    FK_DISCHARGE_LIST_ID = P_I_N_LIST_ID
                    AND DN_EQUIPMENT_NO = P_I_OL_EQUIPMENT_NO
                    AND RECORD_STATUS = 'A'
                    AND PK_BOOKED_DISCHARGE_ID != P_I_BOOKED_LLDL_ID
                    AND P_I_LLDL_FLAG = 'D'
            );

            p_o_v_return_status := '2';  -- ERROR MSG MC023
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                /*
                    No duplicate found
                */
                P_O_V_DUP_PK_BOOKED_ID := P_I_BOOKED_LLDL_ID;
                p_o_v_return_status := '0';
                RETURN;
            WHEN TOO_MANY_ROWS THEN
                /*
                    Incorrect data in booked table, show MC017 error msg.
                */
                p_o_v_return_status := '1';
                RETURN;
            WHEN OTHERS THEN
                /*
                    Oracle Exception, show MC017 error msg.
                */
                p_o_v_return_status := '1';
                RETURN;
        END;

        /*
            Duplicate container found then, check Booking*, Size and, Type.
            if all are same then match with new book loading id
        */
        IF p_o_v_return_status = '2' AND L_V_DUP_PK_BOOKED_ID IS NOT NULL AND P_V_OL_BOOKING_NO IS NOT NULL THEN
            IF (P_I_BK_EQUPIMENT_NO IS NULL) THEN
                /*
                    check Booking*, Size and, Type.
                */
                BEGIN
                    SELECT
                        PK_BOOKED_LOADING_ID
                    INTO
                        P_O_V_DUP_PK_BOOKED_ID
                    FROM
                        VASAPPS.TOS_LL_BOOKED_LOADING
                    WHERE
                        PK_BOOKED_LOADING_ID = L_V_DUP_PK_BOOKED_ID
                        AND FK_BOOKING_NO    = P_V_OL_BOOKING_NO
                        AND DN_EQ_SIZE       = P_V_OL_EQ_SIZE
                        AND DN_EQ_TYPE       = P_V_OL_EQ_TYPE;

                    p_o_v_return_status := '0';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        /*
                            booking*, size and type is mis matching show error msg MC017
                        */
                        L_V_DUP_PK_BOOKED_ID := NULL;
                        p_o_v_return_status := '1';
                        -- exception mc017
                    WHEN OTHERS THEN
                        L_V_DUP_PK_BOOKED_ID := NULL;
                        p_o_v_return_status := '1';
                        -- exception mc017
                END;

            END IF;
        END IF;

        /*
            Old Logic

        *
        IF (P_I_LLDL_FLAG = 'L') THEN
            /*
                Check duplicate container for load list
            *
            SELECT
                COUNT(1)
            INTO
                L_V_COUNT
            FROM
                VASAPPS.TOS_LL_BOOKED_LOADING
            WHERE
                FK_LOAD_LIST_ID = P_I_N_LIST_ID
                AND DN_EQUIPMENT_NO = P_I_OL_EQUIPMENT_NO
                AND RECORD_STATUS = 'A'
                AND PK_BOOKED_LOADING_ID != P_I_BOOKED_LLDL_ID;

        ELSE
            /*
                Check duplicate container for discharge list
            *
            SELECT
                COUNT(1)
            INTO
                L_V_COUNT
            FROM
                VASAPPS.TOS_DL_BOOKED_DISCHARGE
            WHERE
                FK_DISCHARGE_LIST_ID = P_I_N_LIST_ID
                AND DN_EQUIPMENT_NO = P_I_OL_EQUIPMENT_NO
                AND RECORD_STATUS = 'A'
                AND PK_BOOKED_DISCHARGE_ID != P_I_BOOKED_LLDL_ID;
        END IF;

        /*
            When record found then send return status to '1'
        *
        IF L_V_COUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('DUPLICATE CONTAINER FOUND');
            p_o_v_return_status := '1';
        END IF;

        *
            Block Ended by vikas, 02.03.2012
        */
    EXCEPTION
        WHEN OTHERS THEN
            g_v_err_code := SQLCODE;
            g_v_err_desc := SUBSTR(SQLERRM, 1, 100);

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                'PRE_CHECK_DUPLICATE_CONTAINER'
                    ||SEP|| P_I_OL_EQUIPMENT_NO
                    ||SEP|| P_I_N_LIST_ID
                    ||SEP|| P_I_LLDL_FLAG
                    ||SEP|| P_I_BOOKED_LLDL_ID
                    ||SEP|| P_V_OL_BOOKING_NO
                    ||SEP|| P_V_OL_EQ_SIZE
                    ||SEP|| P_V_OL_EQ_TYPE
                    ||SEP|| P_I_BK_EQUPIMENT_NO
                    ||SEP|| P_O_V_DUP_PK_BOOKED_ID
                    ||SEP|| P_O_V_RETURN_STATUS
                , 'Matching'
                , g_v_opr_type
                , g_v_sql_id||SEP||g_v_err_code||SEP||g_v_err_desc
                , 'A'
                ,g_v_user
                , sysdate
                ,g_v_user
                , sysdate
            );
           p_o_v_return_status := '1';

    END PRE_CHECK_DUPLICATE_CONTAINER;

    /*
        End of procedure PRE_CHECK_DUPLICATE_CONTAINER
    */
END PCE_ECM_EDI;
/
