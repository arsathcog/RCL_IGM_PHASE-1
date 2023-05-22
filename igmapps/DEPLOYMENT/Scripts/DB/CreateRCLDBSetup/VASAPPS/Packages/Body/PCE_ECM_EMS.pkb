create or replace
PACKAGE BODY PCE_ECM_EMS AS
    /*
        *1: modified by vikas, make booking no# optional when checking duplicate ems activity, as k'durai, 21.05.2012
        *2: Modified by vikas, Remove activity date validation from EMS_UPDATE, As k'chatgamol, 24.05.2012
        *3: Modified by vikas, Remove activity date validation from EMS_UPDATE, As k'chatgamol, 16.07.2012
        *4: Modified by vikas, get ata date from itp063 table, as k'chatgamol, 26.07.2012
        *5: Modified by vikas, populate ems only for non-edi locations, as k'chatgamol, 30.07.2012
        *6: Modified by vikas, In case of exception while calling ems package
            log the error in vasapps.tos_sync_error_log table, as k'chatgamol, 01.08.2012
        *7: Modified by vikas, bug fix if exception in calling tsi package than if log the error msg
            plsql size error is showing, 22.08.2012
        *8: Modified by vikas, bug fix, if ata time is less then 4 char and we pad zero then oracle exception
            is comming, 'ORA-01850: hour must be between 0 and 23'.
    */
    C_TRUE  VARCHAR2(5) default 'true';
    C_FALSE  VARCHAR2(5) default 'false';
    EDI_ERROR VARCHAR2(1) DEFAULT 'E'; -- *6
    L_EXP_TSI_PKG_EXCEPTION EXCEPTION ;-- *6

    PROCEDURE PRE_UPDATE_EMS_BKG
    (
        p_i_v_booking_no        VARCHAR2
        , p_i_v_container_no      ECP030.MQEQN%TYPE
        , p_o_v_return_status     OUT NOCOPY  VARCHAR2

    ) AS
    /*********************************************************************************************
        Name           :  PRE_UPDATE_EMS_BKG
        Module         :  EZLL
        Purpose        :  For EMS update
                            This procedure is called by Synchronization L106 Process.
        Calls          :
        Returns        :  Null
        Author          Date               What
        ------          ----               ----
        Sachin          07/03/2010         INITIAL VERSION
    *********************************************************************************************/
    CURSOR l_cur_updbkg(l_d_date DATE) IS
    SELECT MQSTA,MQMVDT,MQTRTM,PCE_ECM_SYNC_BOOKING_EZLL.FE_DATE_TIME(MQMVDT,MQTRTM) ACT_DATE,
            MQPORT,MQTERM,MQEQN,MQEORF,MQSIZE,MQTYPE,MQSIZE||MQTYPE EQ_SIZE_TYPE,
            MQLSOR,MQVESS,MQVOYN,MQBOLN,JOB_ORDER_ID,STOWAGE_POSITION,MQSEAL,DAMAGE_EXTENT,
            CONTAINER_GRADE,FOOD_GRADE,EIR_TIR_NO,MQRMKS,MQRPZN
    FROM   ECP030 A, ITP040 B
    WHERE  A.MQPORT = B.PICODE
    AND    A.MQEQN = p_i_v_container_no
    -- AND    FE_GMT_DATE_TIME(A.MQMVDT,A.MQTRTM,B.PIVGMT) > l_d_date  -- *2
    ORDER BY MQMVDT,MQTRTM DESC;

    l_v_exp_act       ITP115.SQEIT%TYPE;
    l_actdt_range     VCM_CONFIG_MST.CONFIG_VALUE%TYPE;
    l_v_param_string  VARCHAR2(100);
    l_v_func_cd       VARCHAR2(1);
    l_v_bkg_ref       VARCHAR2(100);
    l_v_ok_flg        VARCHAR2(1);
    l_v_ok_txt        VARCHAR2(512);
    l_exce_main       EXCEPTION;
    l_d_date_range    DATE;
    l_v_rec_count     NUMBER := 0;
    l_v_is_execute    BOOLEAN := TRUE;
    tmp               VARCHAR2(4000);
    tmp1              VARCHAR2(4000);

    BEGIN -- beg1
        l_v_param_string := p_i_v_container_no ||'~'|| p_i_v_booking_no;

        p_o_v_return_status := '0';

        g_v_sql_id := 'SQL-01001';

        /* *6 start * *
        * no use of l_actdt_range
        BEGIN
            SELECT  CONFIG_VALUE
            INTO    l_actdt_range
            FROM    VCM_CONFIG_MST
            WHERE   CONFIG_TYP = 'EMS_ACTIVITY_DATE'
            AND     CONFIG_CD  = 'ACTIVITY_DATE_RANGE';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_actdt_range := 0;
                WHEN OTHERS THEN
                g_v_err_code := TO_CHAR (SQLCODE);
                g_v_err_desc := SUBSTR(SQLERRM,1,100);
                RAISE l_exce_main;
        END;

        l_d_date_range := SYSDATE - l_actdt_range;
        */

        l_d_date_range := SYSDATE ;
        /* *6 end  * */

        /* change end by vikas as per req. by myo */
        /* change by vikas as per req. by myo */
        -- IF(l_v_rec_count > 0 ) THEN  -- ECP030 record found if

        FOR l_n_cur_updbkg IN l_cur_updbkg(l_d_date_range)
        LOOP
            BEGIN -- beg2
                g_v_sql_id := 'SQL-01001a';

                /* change start by vikas as per req. by myo */

                BEGIN -- beg3
                    SELECT COUNT(1)
                    INTO  l_v_rec_count
                    FROM  ECP030
                    WHERE MQEQN     = p_i_v_container_no
                    AND   MQBOOK    = p_i_v_booking_no
                    AND   MQRPZN    = l_n_cur_updbkg.MQRPZN
                    AND   MQSTA     = l_n_cur_updbkg.MQSTA;

                    /* if ems found then set  l_v_is_execute to false */
                    IF l_v_rec_count > 0 THEN
                        l_v_is_execute := FALSE;
                    ELSE
                        l_v_is_execute := TRUE;
                    END IF;

                EXCEPTION -- beg3
                    WHEN OTHERS THEN
                        l_v_is_execute := TRUE;
                END; -- beg3

                /* if l_v_is_execute false meanse ems activity is already available. */
                IF (l_v_is_execute = TRUE) THEN

                    g_v_sql_id := 'SQL-01002';

                    BEGIN -- beg4
                        SELECT   SQEIT
                        INTO     l_v_exp_act
                        FROM     ITP115
                        WHERE    SQCODE = l_n_cur_updbkg.MQSTA;
                    EXCEPTION -- beg4
                        WHEN NO_DATA_FOUND THEN
                            l_v_exp_act :='~';
                        WHEN OTHERS THEN
                            l_v_exp_act :='~';
                    END; -- beg4

                    IF l_v_exp_act = 'E' THEN

                        g_v_sql_id := 'SQL-01003';

                        l_v_bkg_ref := p_i_v_booking_no;
                        l_v_func_cd := 'M';

                        BEGIN -- beg5

                            /* * initialize local variable * */
                            l_v_ok_flg := NULL; -- *6
                            l_v_ok_txt := NULL; -- *6
                            BEGIN
                                /* * call tsi package to update equipment * */
                                PKG_EDI_EQUIPMENT_IN.PROCESS_WEB_EQUIPMENT
                                (
                                    l_v_func_cd,
                                    l_n_cur_updbkg.MQSTA,
                                    l_n_cur_updbkg.ACT_DATE,
                                    l_n_cur_updbkg.MQPORT,
                                    l_n_cur_updbkg.MQTERM,
                                    l_n_cur_updbkg.MQEQN,
                                    l_n_cur_updbkg.MQEORF,
                                    l_n_cur_updbkg.MQSTA,
                                    l_n_cur_updbkg.EQ_SIZE_TYPE,
                                    l_n_cur_updbkg.MQLSOR,
                                    l_n_cur_updbkg.MQVESS,
                                    l_n_cur_updbkg.MQVOYN,
                                    l_v_bkg_ref,
                                    l_n_cur_updbkg.MQBOLN,
                                    l_n_cur_updbkg.JOB_ORDER_ID,
                                    l_n_cur_updbkg.STOWAGE_POSITION,
                                    l_n_cur_updbkg.MQSEAL,
                                    l_n_cur_updbkg.DAMAGE_EXTENT,
                                    l_n_cur_updbkg.CONTAINER_GRADE,
                                    l_n_cur_updbkg.FOOD_GRADE,
                                    l_n_cur_updbkg.EIR_TIR_NO,
                                    l_n_cur_updbkg.MQRMKS,
                                    l_v_ok_flg,
                                    l_v_ok_txt
                                );


                                -- /* *6: start * */                 -- *7
                                -- IF (l_v_ok_flg = EDI_ERROR) THEN  -- *7
                                --     g_v_err_code := SQLCODE;         -- *7
                                --     g_v_err_desc := l_v_ok_txt;      -- *7
                                --                                   -- *7
                                --     RAISE L_EXP_TSI_PKG_EXCEPTION;   -- *7
                                -- END IF;                           -- *7
                                -- /* *6: end * */                   -- *7

                                /* *7 start * */
                                IF (l_v_ok_flg = EDI_ERROR) THEN
                                    RAISE L_EXP_TSI_PKG_EXCEPTION;
                                END IF;
                            EXCEPTION
                                WHEN L_EXP_TSI_PKG_EXCEPTION THEN
                                    BEGIN
                                       DBMS_OUTPUT.PUT_LINE('ERROR IN CALLING TSI PACKAGE');
                                        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                            substr(l_v_param_string, 1, 500),
                                            'EMS',
                                            'T',
                                            SUBSTR(SQLERRM, 1, 100),
                                            'A',
                                            'EZLL',
                                            SYSDATE,
                                            'EZLL',
                                            SYSDATE
                                        );
                                    EXCEPTION
                                        WHEN OTHERS THEN NULL;
                                    END;

                                WHEN OTHERS THEN
                                    BEGIN
                                       DBMS_OUTPUT.PUT_LINE('ERROR IN CALLING TSI PACKAGE');

                                        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                            substr(l_v_param_string, 1, 500),
                                            'EMS',
                                            'T',
                                            SUBSTR(SQLERRM, 1, 100),
                                            'A',
                                            'EZLL',
                                            SYSDATE,
                                            'EZLL',
                                            SYSDATE
                                        );
                                    EXCEPTION
                                        WHEN OTHERS THEN NULL;
                                    END;
                            END;
                            /* *7 start * */

                        EXCEPTION -- beg5
                            WHEN OTHERS THEN
                                /* *6: start * */
                                g_v_err_code := SQLCODE;
                                g_v_err_desc := substr(SQLERRM,1,100);

                                RAISE L_EXP_TSI_PKG_EXCEPTION;

                                -- g_v_err_code := TO_CHAR (SQLCODE);
                                -- g_v_err_desc := SUBSTR(SQLERRM,1,100);
                                /* *6: end * */

                        END; -- beg5
                    ELSE
                        EXIT; -- exit the loop
                    END IF;

                END IF; /* end if of 'if l_v_is_execute false meanse ems activity is already available.' */

            EXCEPTION -- beg2

                WHEN L_EXP_TSI_PKG_EXCEPTION THEN

                    /* log value of g_v_err_desc * */
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        substr(l_v_param_string, 1, 500),
                        'EMS',
                        'T',
                        substr(g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc, 1, 100),
                        'A',
                        'EZLL',
                        SYSDATE,  -- CURRENT_TIMESTAMP, -- *12
                        'EZLL',
                        SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                   );

                WHEN OTHERS THEN

                    IF ((G_V_ERR_CODE IS NULL) OR (G_V_ERR_DESC IS NULL)) THEN
                        G_V_ERR_CODE := SQLCODE;
                        G_V_ERR_DESC := SUBSTR(SQLERRM, 1, 100);
                    END IF;

                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        substr(l_v_param_string, 1, 500),
                        'EMS',
                        'T',
                        substr(g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc, 1, 100),
                        'A',
                        'EZLL',
                        SYSDATE,  -- CURRENT_TIMESTAMP, -- *12
                        'EZLL',
                        SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                   );
            END; -- beg2

            /* * initialize variables * */
            G_V_SQL_ID  := NULL;
            G_V_ERR_CODE := NULL;
            G_V_ERR_DESC := NULL;

        END LOOP;
            -- END IF; -- end iif of ECP030 record found if.
        p_o_v_return_status :='0';

    EXCEPTION -- beg1
        WHEN l_exce_main THEN
            --p_o_v_return_status := '1'; -- *6
            p_o_v_return_status := '0'; -- *6
        WHEN OTHERS THEN
            /* *6 start * */

            -- g_v_err_code   := TO_CHAR (SQLCODE);
            -- g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            -- tmp1 := SQLERRM;
            -- p_o_v_return_status := '1';

            IF ((G_V_ERR_CODE IS NULL) OR (G_V_ERR_DESC IS NULL)) THEN
                G_V_ERR_CODE := SQLCODE;
                G_V_ERR_DESC := SUBSTR(SQLERRM, 1, 100);
            END IF;

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                substr(l_v_param_string, 1, 500),
                'EMS',
                'T',
                substr(g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc, 1, 100),
                'A',
                'EZLL',
                SYSDATE,  -- CURRENT_TIMESTAMP, -- *12
                'EZLL',
                SYSDATE  -- CURRENT_TIMESTAMP, -- *12
            );
            p_o_v_return_status := '0';
            /* *6 end * */

    END PRE_UPDATE_EMS_BKG; -- beg1

   --procedure for EMS insert from Load list and Discharge list
   PROCEDURE PRE_INSERT_EMS_LL_DL
    (
        p_i_v_act_type         VARCHAR2
      , p_i_n_ll_id            TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE
      , p_i_n_dl_id            TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID%TYPE
      , p_o_v_return_status    OUT NOCOPY  VARCHAR2
    ) AS
   /**************************************************************************************
      Name           :  PRE_INSERT_EMS_LL_DL
      Module         :  EZLL
      Purpose        :  For EMS update
                        This procedure is called by Load List Discharge List Screen while List Status
                        changed from below 10 to 10 or above.
      Calls          :
      Returns        : Null

      Author          Date              What
      ------          ----              ----
      Sachin          07/03/2010        INITIAL VERSION
      *21 vikas       25/04/2012        Before calling TSI function to update EMS,
                                        we should have a check in EMS to see
                                        if same activity already exist, then no need
                                        to update/insert EMS.
   *************************************************************************************/
    l_v_func_cd           VARCHAR2(1);
    l_v_ok_flg            VARCHAR2(1);
    l_v_ok_txt            VARCHAR2(512);
    l_v_param_string      VARCHAR2(4000);
    l_exce_main           EXCEPTION;
    l_v_bl_no             IDP002.TYBLNO%TYPE;
    l_v_exp_act           ITP115.SQEIT%TYPE;
    l_v_sexstt            ITP0EC.SEXSTT%TYPE;
    l_v_semstt            ITP0EC.SEMSTT%TYPE;
    l_v_seldft            ITP0EC.SELDFT%TYPE;
    l_v_seldet            ITP0EC.SELDET%TYPE;
    l_v_sidstt            ITP0EC.SIDSTT%TYPE;
    l_v_sedcft            ITP0EC.SEDCFT%TYPE;
    l_v_sedcet            ITP0EC.SEDCET%TYPE;
    l_v_simstt            ITP0EC.SIMSTT%TYPE;
    l_v_eqp_flmt          BKP009.BIEORF%TYPE;
    l_actdt_diff          VCM_CONFIG_MST.CONFIG_VALUE%TYPE;
    l_act_code            VARCHAR2(100);
    l_v_dc                VARCHAR2(10);
    l_v_dr                VARCHAR2(10);
    l_v_lc                VARCHAR2(10);
    l_v_lr                VARCHAR2(10);
    l_v_ra                VARCHAR2(10);
    l_v_rp                VARCHAR2(10);
    l_v_xx                VARCHAR2(10);
    l_v_found_duplicate       VARCHAR2(10); -- *21

    L_V_FROMATADT         ITP063.VVAPDT%TYPE; -- *4
    L_V_FROMATATM         VARCHAR2(4); -- ITP063.VVAPTM%TYPE; -- *4, *8
    EDI_TERMNAL_EXCEPTION EXCEPTION ;-- *5;

    L_V_IS_EDI_TERMINAL VARCHAR2(5) DEFAULT C_TRUE; -- *5;
    SEP VARCHAR2(1) DEFAULT '~';      -- *5

    CURSOR  l_cur_load_list(p_actdt_diff VARCHAR2) IS
    SELECT  FK_LOAD_LIST_ID,FK_BOOKING_NO,DN_EQUIPMENT_NO,DN_EQ_SIZE||DN_EQ_TYPE EQ_SIZE_TYPE,
            DN_FULL_MT,LOCAL_STATUS,LOADING_STATUS,STOWAGE_POSITION,ACTIVITY_DATE_TIME,FK_CONTAINER_OPERATOR,
            SEAL_NO,FK_VESSEL,FK_VOYAGE,DN_PORT,DN_TERMINAL,A.DAMAGED
    FROM       TOS_LL_BOOKED_LOADING A, TOS_LL_LOAD_LIST B, ITP040 C
    WHERE     A.FK_LOAD_LIST_ID = B.PK_LOAD_LIST_ID
    AND     B.DN_PORT = C.PICODE
    AND     A.FK_LOAD_LIST_ID = p_i_n_ll_id
    AND     LOADING_STATUS = 'LO'
    -- AND     SYSDATE-(A.ACTIVITY_DATE_TIME-NVL((1/1440*(MOD(C.PIVGMT,100)+FLOOR(C.PIVGMT/100)*60)),0))<=p_actdt_diff  -- *2
    AND     A.DN_SOC_COC = 'C'
    UNION
    SELECT  FK_LOAD_LIST_ID,FK_BOOKING_NO,DN_EQUIPMENT_NO,DN_EQ_SIZE||DN_EQ_TYPE EQ_SIZE_TYPE,
            D.BIEORF DN_FULL_MT,NULL,RESTOW_STATUS LOADING_STATUS,STOWAGE_POSITION,ACTIVITY_DATE_TIME,FK_CONTAINER_OPERATOR,
            SEAL_NO,FK_VESSEL,FK_VOYAGE,DN_PORT,DN_TERMINAL,A.DAMAGED
    FROM       TOS_RESTOW A, TOS_LL_LOAD_LIST B, ITP040 C, BKP009 D
    WHERE   A.FK_LOAD_LIST_ID = B.PK_LOAD_LIST_ID
    AND     B.DN_PORT = C.PICODE
    AND     A.FK_BOOKING_NO = D.BIBKNO
    AND     A.FK_BKG_EQUIPM_DTL = D.BISEQN
    AND     A.FK_LOAD_LIST_ID = p_i_n_ll_id
    -- AND     SYSDATE-(A.ACTIVITY_DATE_TIME-NVL((1/1440*(MOD(C.PIVGMT,100)+FLOOR(C.PIVGMT/100)*60)),0))<=p_actdt_diff -- *2
    AND     A.DN_SOC_COC = 'C';

    CURSOR  l_cur_discharge_list(p_actdt_diff VARCHAR2) IS
    SELECT  FK_DISCHARGE_LIST_ID,FK_BOOKING_NO,DN_EQUIPMENT_NO,DN_EQ_SIZE||DN_EQ_TYPE EQ_SIZE_TYPE,
            DN_FULL_MT,LOCAL_STATUS,DISCHARGE_STATUS,STOWAGE_POSITION,ACTIVITY_DATE_TIME,FK_CONTAINER_OPERATOR,
            SEAL_NO,FK_VESSEL,FK_VOYAGE,DN_PORT,DN_TERMINAL,A.DAMAGED,
            B.FK_SERVICE, B.FK_PORT_SEQUENCE_NO, B.FK_DIRECTION
    FROM     TOS_DL_BOOKED_DISCHARGE A, TOS_DL_DISCHARGE_LIST B, ITP040 C
    WHERE    A.FK_DISCHARGE_LIST_ID = B.PK_DISCHARGE_LIST_ID
    AND     B.DN_PORT = C.PICODE
    AND     A.FK_DISCHARGE_LIST_ID = p_i_n_dl_id
    AND     DISCHARGE_STATUS = 'DI'
    -- AND     SYSDATE-(A.ACTIVITY_DATE_TIME-(1/1440*(MOD(C.PIVGMT,100)+FLOOR(C.PIVGMT/100)*60)))<=p_actdt_diff -- *3
    -- AND     SYSDATE-(A.ACTIVITY_DATE_TIME- NVL((1/1440*(MOD(C.PIVGMT,100)+FLOOR(C.PIVGMT/100)*60)),0))<=p_actdt_diff *2
    AND     A.DN_SOC_COC = 'C'
    UNION
    SELECT  FK_DISCHARGE_LIST_ID,FK_BOOKING_NO,DN_EQUIPMENT_NO,DN_EQ_SIZE||DN_EQ_TYPE EQ_SIZE_TYPE,
            D.BIEORF DN_FULL_MT,NULL,RESTOW_STATUS DISCHARGE_STATUS,STOWAGE_POSITION,ACTIVITY_DATE_TIME,FK_CONTAINER_OPERATOR,
            SEAL_NO,FK_VESSEL,FK_VOYAGE,DN_PORT,DN_TERMINAL,A.DAMAGED,
            B.FK_SERVICE, B.FK_PORT_SEQUENCE_NO, B.FK_DIRECTION
    FROM    TOS_RESTOW A, TOS_DL_DISCHARGE_LIST B, ITP040 C, BKP009 D
    WHERE   A.FK_DISCHARGE_LIST_ID = B.PK_DISCHARGE_LIST_ID
    AND     B.DN_PORT = C.PICODE
    AND     A.FK_BOOKING_NO = D.BIBKNO
    AND     A.FK_BKG_EQUIPM_DTL = D.BISEQN
    AND     A.FK_DISCHARGE_LIST_ID = p_i_n_dl_id
--    AND     SYSDATE-(A.ACTIVITY_DATE_TIME-    (1/1440*(MOD(C.PIVGMT,100)+FLOOR(C.PIVGMT/100)*60))   )<=p_actdt_diff; -- *3
    -- AND     SYSDATE-(A.ACTIVITY_DATE_TIME-NVL((1/1440*(MOD(C.PIVGMT,100)+FLOOR(C.PIVGMT/100)*60)),0))<=p_actdt_diff -- *2
    AND     A.DN_SOC_COC='C';

    BEGIN


        l_v_func_cd := 'O';
        g_v_sql_id := 'SQL-01001';
        l_act_code := g_v_dummy;
        l_v_param_string := p_i_v_act_type ||SEP|| p_i_n_ll_id ||SEP|| p_i_n_dl_id;

        BEGIN
            SELECT   SEXSTT
                    ,SEMSTT
                    ,SELDFT
                    ,SELDET
                    ,SIDSTT
                    ,SEDCFT
                    ,SEDCET
                    ,SIMSTT
            INTO     l_v_sexstt
                    ,l_v_semstt
                    ,l_v_seldft
                    ,l_v_seldet
                    ,l_v_sidstt
                    ,l_v_sedcft
                    ,l_v_sedcet
                    ,l_v_simstt
            FROM     ITP0EC
            WHERE    SGLINE='R';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_v_sexstt := g_v_dummy;
                l_v_semstt := g_v_dummy;
                l_v_seldft := g_v_dummy;
                l_v_seldet := g_v_dummy;
                l_v_sidstt := g_v_dummy;
                l_v_sedcft := g_v_dummy;
                l_v_sedcet := g_v_dummy;
                l_v_simstt := g_v_dummy;
            WHEN OTHERS THEN
               g_v_err_code := TO_CHAR (SQLCODE);
               g_v_err_desc := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
        END;
        g_v_sql_id := 'SQL-01002';
        BEGIN
            SELECT  CONFIG_VALUE
            INTO    l_actdt_diff
            FROM    VCM_CONFIG_MST
            WHERE   CONFIG_TYP = 'EMS_ACTIVITY_DATE'
            AND     CONFIG_CD  = 'ACTIVITY_DATE_DIFF';
        EXCEPTION
            WHEN NO_DATA_FOUND     THEN
                l_actdt_diff:=0;
            WHEN OTHERS THEN
               l_actdt_diff:=0;
        END;

        BEGIN
            SELECT  MAX(CASE WHEN  CONFIG_CD='DC' THEN CONFIG_VALUE END) DISCHARGE_CFS
                  , MAX(CASE WHEN  CONFIG_CD='DR' THEN CONFIG_VALUE END) DISCHARGE_RELOAD
                  , MAX(CASE WHEN  CONFIG_CD='LC' THEN CONFIG_VALUE END) RELOAD_CFS
                  , MAX(CASE WHEN  CONFIG_CD='LR' THEN CONFIG_VALUE END) RELOAD
                  , MAX(CASE WHEN  CONFIG_CD='RA' THEN CONFIG_VALUE END) RESTOW_ABOARD
                  , MAX(CASE WHEN  CONFIG_CD='RP' THEN CONFIG_VALUE END) RESTOW_PIER
                  , MAX(CASE WHEN  CONFIG_CD='XX' THEN CONFIG_VALUE END) RESTOW_CORRECTION
            INTO    l_v_dc ,  l_v_dr ,   l_v_lc ,   l_v_lr ,
                    l_v_ra ,  l_v_rp ,  l_v_xx
            FROM    VCM_CONFIG_MST
            WHERE   CONFIG_TYP = 'ACTIVITY_TYPE';
        EXCEPTION
            WHEN OTHERS THEN
               l_v_dc := g_v_dummy;
               l_v_dr := g_v_dummy;
               l_v_lc := g_v_dummy;
               l_v_lr := g_v_dummy;
               l_v_ra := g_v_dummy;
               l_v_rp := g_v_dummy;
               l_v_xx := g_v_dummy;
        END;

        IF p_i_v_act_type = 'L' THEN
            FOR l_n_cur_load_list IN l_cur_load_list(l_actdt_diff)
            LOOP
                IF l_n_cur_load_list.LOADING_STATUS='LO' THEN
                    IF l_n_cur_load_list.LOCAL_STATUS='L' THEN
                        IF l_n_cur_load_list.DN_FULL_MT='F' THEN
                            l_act_code := l_v_sexstt;
                        ELSIF l_n_cur_load_list.DN_FULL_MT='E' THEN
                            l_act_code := l_v_semstt;
                        END IF;
                    ELSIF l_n_cur_load_list.LOCAL_STATUS='T' THEN
                        IF l_n_cur_load_list.DN_FULL_MT='F' THEN
                            l_act_code := l_v_seldft;
                        ELSIF l_n_cur_load_list.DN_FULL_MT='E' THEN
                            l_act_code := l_v_seldet;
                        END IF;
                    END IF;
                ELSIF l_n_cur_load_list.LOADING_STATUS='LC' THEN
                    l_act_code := l_v_lc;
                ELSIF l_n_cur_load_list.LOADING_STATUS='LR' THEN
                    l_act_code := l_v_lr;
                ELSIF l_n_cur_load_list.LOADING_STATUS='RA' THEN
                    l_act_code := l_v_ra;
                ELSIF l_n_cur_load_list.LOADING_STATUS='RP' THEN
                    l_act_code := l_v_rp;
                ELSIF l_n_cur_load_list.LOADING_STATUS='XX' THEN
                    l_act_code := l_v_xx;
                END IF;
                g_v_sql_id := 'SQL-01003';
                BEGIN
                    SELECT  TYBLNO
                    INTO    l_v_bl_no
                    FROM    IDP002
                    WHERE   TYBKNO = l_n_cur_load_list.FK_BOOKING_NO;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       l_v_bl_no := NULL;
                    WHEN OTHERS THEN
                       l_v_bl_no := NULL;
                END;
                g_v_sql_id := 'SQL-01004';

                BEGIN

                    IF l_act_code <> g_v_dummy THEN
                        /*
                            *21: Changes start
                        */
                        PRE_DUPLICATE_EMS_CHECK(
                            l_n_cur_load_list.DN_EQUIPMENT_NO
                            , l_n_cur_load_list.FK_BOOKING_NO
                            , l_n_cur_load_list.FK_VESSEL
                            , l_n_cur_load_list.FK_VOYAGE
                            , l_n_cur_load_list.DN_PORT
                            , l_n_cur_load_list.DN_TERMINAL
                            , l_act_code
                            , l_v_found_duplicate
                        );
                        /*
                            *21: Changes End
                        */

                        IF l_v_found_duplicate = 'FALSE' THEN -- *21
                            BEGIN
                                PKG_EDI_EQUIPMENT_IN.PROCESS_WEB_EQUIPMENT
                                (
                                    l_v_func_cd
                                    ,l_act_code
                                    ,l_n_cur_load_list.ACTIVITY_DATE_TIME
                                    ,l_n_cur_load_list.DN_PORT
                                    ,l_n_cur_load_list.DN_TERMINAL
                                    ,l_n_cur_load_list.DN_EQUIPMENT_NO
                                    ,l_n_cur_load_list.DN_FULL_MT
                                    ,l_n_cur_load_list.LOCAL_STATUS
                                    ,l_n_cur_load_list.EQ_SIZE_TYPE
                                    ,l_n_cur_load_list.FK_CONTAINER_OPERATOR
                                    ,l_n_cur_load_list.FK_VESSEL
                                    ,l_n_cur_load_list.FK_VOYAGE
                                    ,l_n_cur_load_list.FK_BOOKING_NO
                                    ,l_v_bl_no
                                    ,NULL
                                    ,l_n_cur_load_list.STOWAGE_POSITION
                                    ,l_n_cur_load_list.SEAL_NO
                                    ,0                                  --l_n_cur_load_list.DAMAGED
                                    ,NULL
                                    ,NULL
                                    ,NULL
                                    ,NULL
                                    ,l_v_ok_flg
                                    ,l_v_ok_txt
                                );

                                IF (l_v_ok_flg = EDI_ERROR) THEN
                                    RAISE L_EXP_TSI_PKG_EXCEPTION;
                                END IF;
                            EXCEPTION
                                WHEN L_EXP_TSI_PKG_EXCEPTION THEN
                                    BEGIN
                                       DBMS_OUTPUT.PUT_LINE('ERROR IN CALLING TSI PACKAGE');
                                        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                            substr('TSI_PACKAGE_ERROR'
                                                ||'~'|| l_v_func_cd
                                                ||'~'|| l_act_code
                                                ||'~'|| l_n_cur_load_list.ACTIVITY_DATE_TIME
                                                ||'~'|| l_n_cur_load_list.DN_PORT
                                                ||'~'|| l_n_cur_load_list.DN_TERMINAL
                                                ||'~'|| l_n_cur_load_list.DN_EQUIPMENT_NO
                                                ||'~'|| l_n_cur_load_list.DN_FULL_MT
                                                ||'~'|| l_n_cur_load_list.LOCAL_STATUS
                                                ||'~'|| l_n_cur_load_list.EQ_SIZE_TYPE
                                                ||'~'|| l_n_cur_load_list.FK_CONTAINER_OPERATOR
                                                ||'~'|| l_n_cur_load_list.FK_VESSEL
                                                ||'~'|| l_n_cur_load_list.FK_VOYAGE
                                                ||'~'|| l_n_cur_load_list.FK_BOOKING_NO
                                                ||'~'|| l_v_bl_no
                                                ||'~'|| ''
                                                ||'~'|| l_n_cur_load_list.STOWAGE_POSITION
                                                ||'~'|| l_n_cur_load_list.SEAL_NO
                                                ||'~'|| '0'
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| l_v_ok_flg
                                                ||'~'|| l_v_ok_txt,1, 500),
                                            'EMS',
                                            'T',
                                            SUBSTR(SQLERRM, 1, 100),
                                            'A',
                                            'EZLL',
                                            SYSDATE,
                                            'EZLL',
                                            SYSDATE
                                        );
                                    EXCEPTION
                                        WHEN OTHERS THEN NULL;
                                    END;

                                WHEN OTHERS THEN
                                    BEGIN
                                       DBMS_OUTPUT.PUT_LINE('ERROR IN CALLING TSI PACKAGE');
                                        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                            substr('TSI_PACKAGE_ORACLE_ERROR'
                                                ||'~'|| l_v_func_cd
                                                ||'~'|| l_act_code
                                                ||'~'|| l_n_cur_load_list.ACTIVITY_DATE_TIME
                                                ||'~'|| l_n_cur_load_list.DN_PORT
                                                ||'~'|| l_n_cur_load_list.DN_TERMINAL
                                                ||'~'|| l_n_cur_load_list.DN_EQUIPMENT_NO
                                                ||'~'|| l_n_cur_load_list.DN_FULL_MT
                                                ||'~'|| l_n_cur_load_list.LOCAL_STATUS
                                                ||'~'|| l_n_cur_load_list.EQ_SIZE_TYPE
                                                ||'~'|| l_n_cur_load_list.FK_CONTAINER_OPERATOR
                                                ||'~'|| l_n_cur_load_list.FK_VESSEL
                                                ||'~'|| l_n_cur_load_list.FK_VOYAGE
                                                ||'~'|| l_n_cur_load_list.FK_BOOKING_NO
                                                ||'~'|| l_v_bl_no
                                                ||'~'|| ''
                                                ||'~'|| l_n_cur_load_list.STOWAGE_POSITION
                                                ||'~'|| l_n_cur_load_list.SEAL_NO
                                                ||'~'|| '0'
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| l_v_ok_flg
                                                ||'~'|| l_v_ok_txt, 1, 500),
                                            'EMS',
                                            'T',
                                            SUBSTR(SQLERRM, 1, 100),
                                            'A',
                                            'EZLL',
                                            SYSDATE,
                                            'EZLL',
                                            SYSDATE
                                        );
                                    EXCEPTION
                                        WHEN OTHERS THEN NULL;
                                    END;
                            END;
                        END IF; -- End of l_v_found_duplicate if condition  -- *21
                    END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                        -- g_v_err_code := TO_CHAR (SQLCODE);
                        -- g_v_err_desc := SUBSTR(SQLERRM,1,100);
                        g_v_err_code := SQLCODE;
                        g_v_err_desc := substr(g_v_sql_id ||'~'|| SUBSTR(SQLERRM,100),1, 100);
                        -- g_v_err_desc := substr(g_v_err_desc
                        l_v_param_string := substr(l_v_param_string
                            ||'~'||    l_v_func_cd
                            ||'~'|| l_act_code
                            ||'~'|| L_V_FROMATADT
                            ||'~'|| L_V_FROMATATM
                            ||'~'|| l_n_cur_load_list.DN_PORT
                            ||'~'|| l_n_cur_load_list.DN_TERMINAL
                            ||'~'|| l_n_cur_load_list.DN_EQUIPMENT_NO
                            ||'~'|| l_n_cur_load_list.DN_FULL_MT
                            ||'~'|| l_n_cur_load_list.LOCAL_STATUS
                            ||'~'|| l_n_cur_load_list.EQ_SIZE_TYPE
                            ||'~'|| l_n_cur_load_list.FK_CONTAINER_OPERATOR
                            ||'~'|| l_n_cur_load_list.FK_VESSEL
                            ||'~'|| l_n_cur_load_list.FK_VOYAGE
                            ||'~'|| l_n_cur_load_list.FK_BOOKING_NO
                            ||'~'|| l_v_bl_no
                            ||'~'|| l_n_cur_load_list.STOWAGE_POSITION
                            ||'~'|| l_n_cur_load_list.SEAL_NO
                            ||'~'|| '0'
                            ||'~'|| l_v_ok_flg
                            ||'~'|| l_v_ok_txt, 1, 500);
                        RAISE l_exce_main;
                END;
            END LOOP;
        ELSIF p_i_v_act_type = 'D' THEN
            L_V_FROMATADT := null; -- *4
            L_V_FROMATATM := null; -- *4

            /* * set default value * */
            L_V_IS_EDI_TERMINAL := C_TRUE;

            FOR l_n_cur_discharge_list IN l_cur_discharge_list(l_actdt_diff)
            LOOP
                /* * *5: start  * */

                /* * check only first time * */
                IF (L_V_IS_EDI_TERMINAL = C_TRUE) THEN -- *if1

                    /* * return true if location is edi terminal * */
                    PRE_CHECK_EDI_LOCATION(
                        l_n_cur_discharge_list.DN_TERMINAL,
                        L_V_IS_EDI_TERMINAL
                    );

                    /* * if true then location is edi no need to proceed * */
                    IF(L_V_IS_EDI_TERMINAL = C_TRUE) THEN
                        RAISE EDI_TERMNAL_EXCEPTION;
                    END IF;

                END IF; -- *if1
                /* * *5: end  * */

                /* *4 start * */

                /* * get activity date only once * */

                IF L_V_FROMATADT IS NULL AND L_V_FROMATATM IS NULL THEN
                    BEGIN

                        /* * get ata date and ata time from vessel schedule table * */

                        SELECT
                            NVL(ITP.VVAPDT, ITP.VVARDT) FROMATA,
                            LPAD(NVL(VVAPTM,'0'),4,'0')
                        INTO
                            L_V_FROMATADT,
                            L_V_FROMATATM
                        FROM
                            ITP063 ITP
                        WHERE
                            VVSRVC       = l_n_cur_discharge_list.FK_SERVICE
                            AND VVVESS   = l_n_cur_discharge_list.FK_VESSEL
                            AND (
                                (VVSRVC = 'AFS' AND VVVOYN = l_n_cur_discharge_list.FK_VOYAGE)
                                OR
                                (VVSRVC <> 'AFS' AND INVOYAGENO = l_n_cur_discharge_list.FK_VOYAGE)
                            )
                            AND VVPDIR   = l_n_cur_discharge_list.FK_DIRECTION
                            AND VVPCSQ   = l_n_cur_discharge_list.FK_PORT_SEQUENCE_NO
                            AND VVPCAL   = l_n_cur_discharge_list.DN_PORT
                            AND VVTRM1   = l_n_cur_discharge_list.DN_TERMINAL
                            AND VVVERS   = 99
                            AND ACT_DMY_FLG = 'A';
                    EXCEPTION
                        WHEN OTHERS THEN
                            DBMS_OUTPUT.PUT_LINE(SQLCODE||'~'||SQLERRM||'~'||'activity date not found in ITP063 table.');
                            g_v_err_code := SQLCODE;
                            g_v_err_desc := substr('activity date not found in ITP063 table'||'~'||SUBSTR(SQLERRM,100), 1, 100);
                            RAISE L_EXCE_MAIN;
                    END;
                END IF;

                /* * in case of afs service set default time to 1200 noon * */

                IF (l_n_cur_discharge_list.FK_SERVICE = 'AFS') THEN
                    L_V_FROMATATM := '1200';
                END IF;

                /* *4 end * */

                IF l_n_cur_discharge_list.DISCHARGE_STATUS='DI' THEN
                    IF l_n_cur_discharge_list.LOCAL_STATUS='L' THEN
                        IF l_n_cur_discharge_list.DN_FULL_MT='F' THEN
                            l_act_code := l_v_sidstt;
                        ELSIF l_n_cur_discharge_list.DN_FULL_MT='E' THEN
                            -- l_act_code := l_v_sedcft;
                            l_act_code := l_v_simstt;
                        END IF;
                    ELSIF l_n_cur_discharge_list.LOCAL_STATUS='T' THEN
                        IF l_n_cur_discharge_list.DN_FULL_MT='F' THEN
                            --l_act_code := l_v_sedcet;
                              l_act_code := l_v_sedcft;
                        ELSIF l_n_cur_discharge_list.DN_FULL_MT='E' THEN
                            -- l_act_code := l_v_simstt;
                            l_act_code := l_v_sedcet;
                        END IF;
                    END IF;
                ELSIF l_n_cur_discharge_list.DISCHARGE_STATUS='DC' THEN
                    l_act_code := l_v_dc;
                ELSIF l_n_cur_discharge_list.DISCHARGE_STATUS='DR' THEN
                    l_act_code := l_v_dr;
                END IF;
                g_v_sql_id := 'SQL-01005';
                BEGIN
                    SELECT     TYBLNO
                    INTO    l_v_bl_no
                    FROM     IDP002
                    WHERE     TYBKNO = l_n_cur_discharge_list.FK_BOOKING_NO;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      l_v_bl_no := NULL;
                    WHEN OTHERS THEN
                      l_v_bl_no := NULL;
                END;
                g_v_sql_id := 'SQL-01006';

                BEGIN
                    IF l_act_code <> g_v_dummy THEN
                        /*
                            *21: Changes start
                        */
                        PRE_DUPLICATE_EMS_CHECK(
                            l_n_cur_discharge_list.DN_EQUIPMENT_NO
                            , l_n_cur_discharge_list.FK_BOOKING_NO
                            , l_n_cur_discharge_list.FK_VESSEL
                            , l_n_cur_discharge_list.FK_VOYAGE
                            , l_n_cur_discharge_list.DN_PORT
                            , l_n_cur_discharge_list.DN_TERMINAL
                            , l_act_code
                            , l_v_found_duplicate
                        );
                        /*
                            *21: Changes End
                        */

                        IF l_v_found_duplicate = 'FALSE' THEN -- *21
                            BEGIN -- *7
                                PKG_EDI_EQUIPMENT_IN.PROCESS_WEB_EQUIPMENT
                                (
                                    l_v_func_cd
                                    ,l_act_code
                                    -- ,l_n_cur_discharge_list.ACTIVITY_DATE_TIME -- *4
                                    , TO_DATE(L_V_FROMATADT ||' '|| L_V_FROMATATM, 'yyyymmdd hh24mi') -- *4
                                    ,l_n_cur_discharge_list.DN_PORT
                                    ,l_n_cur_discharge_list.DN_TERMINAL
                                    ,l_n_cur_discharge_list.DN_EQUIPMENT_NO
                                    ,l_n_cur_discharge_list.DN_FULL_MT
                                    ,l_n_cur_discharge_list.LOCAL_STATUS
                                    ,l_n_cur_discharge_list.EQ_SIZE_TYPE
                                    ,l_n_cur_discharge_list.FK_CONTAINER_OPERATOR
                                    ,l_n_cur_discharge_list.FK_VESSEL
                                    ,l_n_cur_discharge_list.FK_VOYAGE
                                    ,l_n_cur_discharge_list.FK_BOOKING_NO
                                    ,l_v_bl_no
                                    ,NULL
                                    ,l_n_cur_discharge_list.STOWAGE_POSITION
                                    ,l_n_cur_discharge_list.SEAL_NO
                                    ,0                                     --l_n_cur_discharge_list.DAMAGED
                                    ,NULL
                                    ,NULL
                                    ,NULL
                                    ,NULL
                                    ,l_v_ok_flg
                                    ,l_v_ok_txt
                                );

                                -- IF (l_v_ok_flg = EDI_ERROR) THEN -- *7
                                --     g_v_err_code := SQLCODE;        -- *7
                                --     g_v_err_desc := l_v_ok_txt;     -- *7
                                --                                  -- *7
                                --     RAISE l_exce_main;              -- *7
                                -- END IF;                          -- *7

                            /* *7 start * */
                                IF (l_v_ok_flg = EDI_ERROR) THEN
                                    RAISE L_EXP_TSI_PKG_EXCEPTION;
                                END IF;
                            EXCEPTION
                                WHEN L_EXP_TSI_PKG_EXCEPTION THEN
                                    BEGIN
                                       DBMS_OUTPUT.PUT_LINE('ERROR IN CALLING TSI PACKAGE');
                                        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                            substr('TSI_PACKAGE_ERROR'
                                                ||'~'|| l_v_func_cd
                                                ||'~'|| l_act_code
                                                ||'~'|| l_n_cur_discharge_list.ACTIVITY_DATE_TIME
                                                ||'~'|| l_n_cur_discharge_list.DN_PORT
                                                ||'~'|| l_n_cur_discharge_list.DN_TERMINAL
                                                ||'~'|| l_n_cur_discharge_list.DN_EQUIPMENT_NO
                                                ||'~'|| l_n_cur_discharge_list.DN_FULL_MT
                                                ||'~'|| l_n_cur_discharge_list.LOCAL_STATUS
                                                ||'~'|| l_n_cur_discharge_list.EQ_SIZE_TYPE
                                                ||'~'|| l_n_cur_discharge_list.FK_CONTAINER_OPERATOR
                                                ||'~'|| l_n_cur_discharge_list.FK_VESSEL
                                                ||'~'|| l_n_cur_discharge_list.FK_VOYAGE
                                                ||'~'|| l_n_cur_discharge_list.FK_BOOKING_NO
                                                ||'~'|| l_v_bl_no
                                                ||'~'|| TO_CHAR(TO_DATE(L_V_FROMATADT ||' '|| L_V_FROMATATM, 'yyyymmdd hh24mi'), 'yyyymmdd hh24mi')
                                                ||'~'|| ''
                                                ||'~'|| l_n_cur_discharge_list.STOWAGE_POSITION
                                                ||'~'|| l_n_cur_discharge_list.SEAL_NO
                                                ||'~'|| '0'
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| l_v_ok_flg
                                                ||'~'|| l_v_ok_txt, 1, 500),
                                            'EMS',
                                            'T',
                                            SUBSTR(SQLERRM, 1, 100),
                                            'A',
                                            'EZLL',
                                            SYSDATE,
                                            'EZLL',
                                            SYSDATE
                                        );
                                    EXCEPTION
                                        WHEN OTHERS THEN NULL;
                                    END;

                                WHEN OTHERS THEN
                                    BEGIN
                                       DBMS_OUTPUT.PUT_LINE('ERROR IN CALLING TSI PACKAGE');
                                        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                                            substr('TSI_PACKAGE_ORACLE_ERROR'
                                                ||'~'|| l_v_func_cd
                                                ||'~'|| l_act_code
                                                ||'~'|| l_n_cur_discharge_list.ACTIVITY_DATE_TIME
                                                ||'~'|| l_n_cur_discharge_list.DN_PORT
                                                ||'~'|| l_n_cur_discharge_list.DN_TERMINAL
                                                ||'~'|| l_n_cur_discharge_list.DN_EQUIPMENT_NO
                                                ||'~'|| l_n_cur_discharge_list.DN_FULL_MT
                                                ||'~'|| l_n_cur_discharge_list.LOCAL_STATUS
                                                ||'~'|| l_n_cur_discharge_list.EQ_SIZE_TYPE
                                                ||'~'|| l_n_cur_discharge_list.FK_CONTAINER_OPERATOR
                                                ||'~'|| l_n_cur_discharge_list.FK_VESSEL
                                                ||'~'|| l_n_cur_discharge_list.FK_VOYAGE
                                                ||'~'|| l_n_cur_discharge_list.FK_BOOKING_NO
                                                ||'~'|| l_v_bl_no
                                                ||'~'|| ''
                                                ||'~'|| l_n_cur_discharge_list.STOWAGE_POSITION
                                                ||'~'|| l_n_cur_discharge_list.SEAL_NO
                                                ||'~'|| '0'
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| ''
                                                ||'~'|| l_v_ok_flg
                                                ||'~'|| l_v_ok_txt, 1, 500),
                                            'EMS',
                                            'T',
                                            SUBSTR(SQLERRM, 1, 100),
                                            'A',
                                            'EZLL',
                                            SYSDATE,
                                            'EZLL',
                                            SYSDATE
                                        );
                                    EXCEPTION
                                        WHEN OTHERS THEN NULL;
                                    END;
                            END;
                            /* *7 end * */

                        END IF; -- End of l_v_found_duplicate if condition  -- *21
                    END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                        -- g_v_err_code := TO_CHAR (SQLCODE);
                        -- g_v_err_desc := SUBSTR(SQLERRM,1,100);
                        -- DBMS_OUTPUT.PUT_LINE(SQLCODE||'~'||SQLERRM||'~'|| 'PKG_EDI_EQUIPMENT_IN.PROCESS_WEB_EQUIPMENT');
                        g_v_err_code := SQLCODE;
                        g_v_err_desc := g_v_sql_id||'~'|| SUBSTR(SQLERRM,100);
                        l_v_param_string := substr(l_v_param_string
                            ||'~'|| l_v_func_cd
                            ||'~'|| l_act_code
                            ||'~'|| L_V_FROMATADT
                            ||'~'|| L_V_FROMATATM
                            ||'~'|| l_n_cur_discharge_list.DN_PORT
                            ||'~'|| l_n_cur_discharge_list.DN_TERMINAL
                            ||'~'|| l_n_cur_discharge_list.DN_EQUIPMENT_NO
                            ||'~'|| l_n_cur_discharge_list.DN_FULL_MT
                            ||'~'|| l_n_cur_discharge_list.LOCAL_STATUS
                            ||'~'|| l_n_cur_discharge_list.EQ_SIZE_TYPE
                            ||'~'|| l_n_cur_discharge_list.FK_CONTAINER_OPERATOR
                            ||'~'|| l_n_cur_discharge_list.FK_VESSEL
                            ||'~'|| l_n_cur_discharge_list.FK_VOYAGE
                            ||'~'|| l_n_cur_discharge_list.FK_BOOKING_NO
                            ||'~'|| l_v_bl_no
                            ||'~'|| l_n_cur_discharge_list.STOWAGE_POSITION
                            ||'~'|| l_n_cur_discharge_list.SEAL_NO
                            ||'~'|| '0'
                            ||'~'|| l_v_ok_flg
                            ||'~'|| l_v_ok_txt, 500);

                        RAISE l_exce_main;
                END;
            END LOOP;
        END IF;
       p_o_v_return_status :='0';
    EXCEPTION

        /* *5 start * */
        WHEN EDI_TERMNAL_EXCEPTION THEN
            p_o_v_return_status :='0';
            DBMS_OUTPUT.PUT_LINE('EDI TERMINAL SHOULD NOT BE UPDATED');
            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                substr(l_v_param_string, 1, 500),
                'EMS',
                'T',
                'EMS CAN NOT UPDATE FOR EDI LOCATIONS',
                'A',
                'EZLL',
                SYSDATE,
                'EZLL',
                SYSDATE
            );
        /* *5 end * */

        WHEN l_exce_main THEN
            p_o_v_return_status :='0'; -- *7
            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                substr(l_v_param_string, 1, 500),
                'EMS',
                'T',
                substr(g_v_err_code||SEP||g_v_err_desc||SEP|| 'ERROR IN PROCESSING EMS', 1, 100),
                'A',
                'EZLL',
                SYSDATE,
                'EZLL',
                SYSDATE
            );

        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLCODE||'~'||SQLERRM||'~'|| 'PKG_EDI_EQUIPMENT_IN.PROCESS_WEB_EQUIPMENT');
            p_o_v_return_status :='1';
            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                substr(l_v_param_string, 1, 500),
                'EMS',
                'T',
                substr(SQLCODE||SEP||SQLERRM||SEP|| 'PKG_EDI_EQUIPMENT_IN.PROCESS_WEB_EQUIPMENT', 1, 100),
                'A',
                'EZLL',
                SYSDATE,
                'EZLL',
                SYSDATE
            );


    END PRE_INSERT_EMS_LL_DL;

    --procedure for EMS insert for container replacement
    PROCEDURE PRE_EMS_CONTAINER_REPLACEMENT
    (
        p_i_n_discharge_id        TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID%TYPE
        ,p_i_v_old_cont_no        TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE
        ,p_i_v_new_cont_no        TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE
        ,p_i_d_act_date            TOS_DL_BOOKED_DISCHARGE.ACTIVITY_DATE_TIME%TYPE
        ,p_o_v_return_status    OUT NOCOPY VARCHAR2
    ) AS
   /*********************************************************************************************
      Name           :  PRE_EMS_CONTAINER_REPLACEMENT
      Module         :  EZLL
      Purpose        :  For EMS update
                        This procedure is called by Container Replacement Screen .
      Calls          :
      Returns        :  Null
      Author          Date               What
      ------          ----               ----
      Sachin          07/03/2010         INITIAL VERSION
   *********************************************************************************************/
    l_v_func_cd            VARCHAR2(1);
    l_v_ok_flg            VARCHAR2(1);
    l_v_ok_txt            VARCHAR2(512);
    l_v_param_string     VARCHAR2(100);
    l_v_eqp_no            TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE;
    l_actdt_diff         VCM_CONFIG_MST.CONFIG_VALUE%TYPE;
    l_v_bl_no            IDP002.TYBLNO%TYPE;
    l_act_code            VARCHAR2(100);
    l_exce_main          EXCEPTION;
    l_v_damage_cd        VARCHAR2(10);
    l_v_rework_cd        VARCHAR2(10);

    CURSOR  l_cur_discharge_list(p_actdt_diff VARCHAR2) IS
    SELECT     DISCHARGE_STATUS, ACTIVITY_DATE_TIME, B.DN_PORT, B.DN_TERMINAL, DN_EQUIPMENT_NO,
            DN_FULL_MT, LOCAL_STATUS, DN_EQ_SIZE||DN_EQ_TYPE EQ_SIZE_TYPE, FK_CONTAINER_OPERATOR,
            B.FK_VESSEL, B.FK_VOYAGE, FK_BOOKING_NO, STOWAGE_POSITION, SEAL_NO
    FROM     TOS_DL_BOOKED_DISCHARGE A, TOS_DL_DISCHARGE_LIST B, ITP040 C
    WHERE     A.FK_DISCHARGE_LIST_ID = B.PK_DISCHARGE_LIST_ID
    AND     B.DN_PORT = C.PICODE
    AND       PK_BOOKED_DISCHARGE_ID = P_I_N_DISCHARGE_ID;
    --AND     SYSDATE-(A.ACTIVITY_DATE_TIME-(1/1440*(MOD(C.PIVGMT,100)+FLOOR(C.PIVGMT/100)*60)))<=p_actdt_diff;

    BEGIN
        l_v_func_cd := 'O';
        g_v_sql_id := 'SQL-01001';
        l_v_param_string := p_i_n_discharge_id||'~'||p_i_v_old_cont_no||'~'||p_i_v_new_cont_no||'~'||p_i_d_act_date;
        BEGIN
            SELECT  CONFIG_VALUE
            INTO    l_actdt_diff
            FROM    VCM_CONFIG_MST
            WHERE   CONFIG_TYP = 'EMS_ACTIVITY_DATE'
            AND     CONFIG_CD  = 'ACTIVITY_DATE_DIFF';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_actdt_diff :=0;
            WHEN OTHERS THEN
                l_actdt_diff :=0;
        END;

        BEGIN
            SELECT  MAX(CASE WHEN  config_cd='DM' THEN config_value END) DAMAGE,
                    MAX(CASE WHEN  config_cd='RW' THEN config_value END) REWORK
            INTO    l_v_damage_cd , l_v_rework_cd
            FROM    VCM_CONFIG_MST
            WHERE   CONFIG_TYP = 'ACTIVITY_TYPE'
            AND     CONFIG_CD IN ('DM','RW');
        EXCEPTION
            WHEN OTHERS THEN
               l_v_damage_cd := g_v_dummy;
               l_v_rework_cd := g_v_dummy;
        END;

        FOR l_n_cur_discharge_list IN l_cur_discharge_list(l_actdt_diff)
        LOOP
            g_v_sql_id := 'SQL-01002';

            BEGIN
                SELECT  MAX(TYBLNO)
                INTO    l_v_bl_no
                FROM     IDP002
                WHERE     TYBKNO = l_n_cur_discharge_list.FK_BOOKING_NO;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_v_bl_no := NULL;
                WHEN OTHERS THEN
                   l_v_bl_no := NULL;
            END;
            g_v_sql_id := 'SQL-01004';

            BEGIN
                IF l_v_damage_cd <> g_v_dummy THEN
                    PKG_EDI_EQUIPMENT_IN.PROCESS_WEB_EQUIPMENT
                    (
                        l_v_func_cd
                        ,l_v_damage_cd
                        ,p_i_d_act_date
                        ,l_n_cur_discharge_list.DN_PORT
                        ,l_n_cur_discharge_list.DN_TERMINAL
                        ,p_i_v_old_cont_no
                        ,l_n_cur_discharge_list.DN_FULL_MT
                        ,l_n_cur_discharge_list.LOCAL_STATUS
                        ,l_n_cur_discharge_list.EQ_SIZE_TYPE
                        ,l_n_cur_discharge_list.FK_CONTAINER_OPERATOR
                        ,l_n_cur_discharge_list.FK_VESSEL
                        ,l_n_cur_discharge_list.FK_VOYAGE
                        ,l_n_cur_discharge_list.FK_BOOKING_NO
                        ,l_v_bl_no
                        ,NULL
                        ,l_n_cur_discharge_list.STOWAGE_POSITION
                        ,l_n_cur_discharge_list.SEAL_NO
                        ,0                                       --l_n_cur_discharge_list.DAMAGED
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,l_v_ok_flg
                        ,l_v_ok_txt
                    );
                END IF;
                IF l_v_rework_cd <> g_v_dummy THEN
                    PKG_EDI_EQUIPMENT_IN.PROCESS_WEB_EQUIPMENT
                    (
                        l_v_func_cd
                        ,l_v_rework_cd
                        ,p_i_d_act_date
                        ,l_n_cur_discharge_list.DN_PORT
                        ,l_n_cur_discharge_list.DN_TERMINAL
                        ,p_i_v_new_cont_no
                        ,l_n_cur_discharge_list.DN_FULL_MT
                        ,l_n_cur_discharge_list.LOCAL_STATUS
                        ,l_n_cur_discharge_list.EQ_SIZE_TYPE
                        ,l_n_cur_discharge_list.FK_CONTAINER_OPERATOR
                        ,l_n_cur_discharge_list.FK_VESSEL
                        ,l_n_cur_discharge_list.FK_VOYAGE
                        ,l_n_cur_discharge_list.FK_BOOKING_NO
                        ,l_v_bl_no
                        ,NULL
                        ,l_n_cur_discharge_list.STOWAGE_POSITION
                        ,l_n_cur_discharge_list.SEAL_NO
                        ,0                                       --l_n_cur_discharge_list.DAMAGED
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,l_v_ok_flg
                        ,l_v_ok_txt
                    );
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    g_v_err_code := TO_CHAR (SQLCODE);
                    g_v_err_desc := SUBSTR(SQLERRM,1,100);
                    RAISE l_exce_main;
            END;
        END LOOP;
        p_o_v_return_status := '0';
    EXCEPTION
        WHEN l_exce_main THEN
            p_o_v_return_status := '1';
        WHEN OTHERS THEN
            p_o_v_return_status := '1';

    END PRE_EMS_CONTAINER_REPLACEMENT;

   FUNCTION FE_GMT_DATE_TIME
   (
   p_i_n_dt_value     NUMBER,
   p_i_n_tm_value     NUMBER,
   p_i_n_tm_value_gmt NUMBER
   ) RETURN DATE IS
   /*********************************************************************************************
      Name           :  FE_GMT_DATE_TIME
      Module         :  EZLL
      Purpose        :  For EMS update
                        This Function takes the numeric Date and Time also GMT offset and return date
      Calls          :
      Returns        :  Null
      Author          Date               What
      ------          ----               ----
      Sachin          07/03/2010         INITIAL VERSION
   *********************************************************************************************/
   l_d_date DATE;
   BEGIN
       l_d_date:=TO_DATE(p_i_n_dt_value,'RRRRMMDD')+(1/1440*(MOD(p_i_n_dt_value, 100)+
                 FLOOR(p_i_n_tm_value/100)*60))-(1/1440*(MOD(p_i_n_tm_value, 100)))
                 - (1/1440*(MOD(p_i_n_tm_value_gmt,100)+FLOOR(p_i_n_tm_value_gmt/100)*60));
       RETURN l_d_date;
   EXCEPTION
      WHEN OTHERS THEN
           l_d_date:=NULL;
           RETURN l_d_date;
   END;
/******************************************************************************
 *  Name           :  PRE_DUPLICATE_EMS_CHECK                                 *
 *  Module         :  VASAPPS                                                 *
 *  Purpose        :  To check the duplicate EMS activity exists or not.      *
 *  Calls          :                                                          *
 *  Returns        :  TRUE: found duplicate                                   *
 *                    FALSE: no duplicate exists                              *
 *                                                                            *
 *  Author          Date               What                                   *
 *  ------          ----               ----                                   *
 *  vikas         26/04/2012           INITIAL VERSION                        *
*******************************************************************************/

PROCEDURE PRE_DUPLICATE_EMS_CHECK(
    P_I_V_EQUIPMENT_NO                  TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE
    , P_I_V_BOOKING_NO                  TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE
    , P_I_V_VESSEL                      TOS_DL_DISCHARGE_LIST.FK_VESSEL%TYPE
    , P_I_V_VOYAGE                      TOS_DL_DISCHARGE_LIST.FK_VOYAGE%TYPE
    , P_I_V_PORT                        TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE
    , P_I_V_TERMINAL                    TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE
    , P_I_V_ACT_CODE                    VARCHAR2
    , P_O_DUPLICATE                     OUT VARCHAR2
)
AS
    l_v_dup_check                       VARCHAR2(1);
BEGIN
    /*
        Check the activity exists or not.
    */
    SELECT
        '1'
    INTO
        l_v_dup_check
    FROM
        ECP030
    WHERE
        MQEQN      = P_I_V_EQUIPMENT_NO
        AND MQBOOK = nvl(P_I_V_BOOKING_NO, MQBOOK)  -- *1
        AND MQVESS = P_I_V_VESSEL
        AND MQVOYN = P_I_V_VOYAGE
        AND MQPORT = P_I_V_PORT
        AND MQTERM = P_I_V_TERMINAL
        AND MQSTA  = P_I_V_ACT_CODE;

    /*
        Activity found, no need to call ems logic
    */
    P_O_DUPLICATE := 'TRUE';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        /*
            Activity not found, call ems logic.
        */
        P_O_DUPLICATE := 'FALSE';

    WHEN OTHERS THEN
        P_O_DUPLICATE := 'TRUE';
END;
/*
    end of function PRE_DUPLICATE_EMS_CHECK.
*/

    /* *5 start * */
    /* * procedure to check the terminal is non-edi or edi location
        return true if edi location, otherwise false, vikas, 30.07.2012
    * */
    PROCEDURE PRE_CHECK_EDI_LOCATION(
        P_I_TERMINAL       VARCHAR2,
        P_O_TERMINAL_FOUND OUT VARCHAR2
    )
    AS

    /* * declare constants * */
    C_CONFIG_TYP VARCHAR2(10) DEFAULT 'EMS_EDI';
    C_CONFIG_CD VARCHAR2(10) DEFAULT 'TERMINAL';

    BEGIN
        /* * set default value * */
        p_o_terminal_found := C_FALSE;

        BEGIN
            SELECT
                C_TRUE
            INTO
                p_o_terminal_found
            FROM
                VASAPPS.VCM_CONFIG_MST
            WHERE
                CONFIG_TYP = C_CONFIG_TYP
                AND CONFIG_CD = P_I_TERMINAL
                AND CONFIG_VALUE = P_I_TERMINAL
                AND STATUS = 'A';

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                /* * terminal is non - edi, return false * */
                p_o_terminal_found := C_FALSE;
        END;
        DBMS_OUTPUT.PUT_LINE(p_o_terminal_found);

    EXCEPTION

        WHEN OTHERS THEN
            p_o_terminal_found := C_FALSE;

    END PRE_CHECK_EDI_LOCATION;
    /* * end of procedure * */

END PCE_ECM_EMS;
/

