CREATE OR REPLACE PACKAGE BODY VASAPPS."PCE_EDL_BULKUPDATE" AS
    /* Variable Declarations */
    g_v_sql                                                     VARCHAR2(5000);
    g_v_upd_cat_sql                                        VARCHAR2(5000); --*15
    l_v_data                                                    VARCHAR2(100);
    m_v_data                                                    VARCHAR2(100);
    n_v_data                                                    VARCHAR2(100);
    o_v_data                                                    VARCHAR2(100);
    p_v_data                                                    VARCHAR2(100);
    q_v_data                                                    VARCHAR2(100);
    d_v_data                                                    VARCHAR2(100);
    g_v_validation_sql                                          VARCHAR2(5000);
    g_v_validation_soc_sql                                      VARCHAR2(5000);
    g_v_where_cond                                              VARCHAR2(2000);
    g_v_err_code                                                VARCHAR2(50);    -- AAdded by vikas, 05.03.2012

    /* Constants Declaration */
    BOOKED_TAB                                                  VARCHAR2(1) := '2';
    OVERLAND_OVERSHIP_TAB                                       VARCHAR2(1) := '1';
    DISCHARGE_LIST                                              VARCHAR2(1) := 'D';
    LOAD_LIST                                                  VARCHAR2(1) := 'L';
    g_v_sql_id                                                  VARCHAR2(10);
    l_v_parameter_str                                           TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;
    l_v_error                                                   VARCHAR2(4000);


    /* Begin of PRE_EDL_BULKUPDATE */
    PROCEDURE PRE_EDL_BULKUPDATE(
          p_i_v_flag                                            VARCHAR2
        , p_i_v_find1                                           VARCHAR2
        , p_i_v_in1                                             VARCHAR2
        , p_i_v_find2                                           VARCHAR2
        , p_i_v_in2                                             VARCHAR2
        , p_i_v_container_op                                    VARCHAR2
        , p_i_v_slot_op                                         VARCHAR2
        , p_i_v_out_slot_op                                     VARCHAR2
        , p_i_v_pod                                             VARCHAR2
        , p_i_v_pol                                             VARCHAR2
        , p_i_v_equip_type                                      VARCHAR2
        , p_i_v_midstream_handling                              VARCHAR2
        , p_i_v_mlo_vessel                                      VARCHAR2
        , p_i_v_mlo_voyage                                      VARCHAR2
        , p_i_v_soc_coc                                         VARCHAR2
        , p_i_v_con_mlo_vessel                                  VARCHAR2
        , p_i_v_con_mlo_voyage                                  VARCHAR2
        , p_i_v_con_mlo_pod1                                    VARCHAR2
        , p_i_v_con_mlo_pod2                                    VARCHAR2
        , p_i_v_con_mlo_pod3                                    VARCHAR2
        , p_i_v_con_mlo_del                                     VARCHAR2
        , p_i_v_con_handl_code1                                 VARCHAR2
        , p_i_v_con_handl_code2                                 VARCHAR2
        , p_i_v_con_handl_code3                                 VARCHAR2
        , p_i_v_load_disch_status                               VARCHAR2
        , p_i_v_tab_flag                                        VARCHAR2
        , p_i_v_id                                              VARCHAR2
        , p_i_v_local_containr_sts                              VARCHAR2
        , p_i_v_ata_date                                        VARCHAR2 /* *2 * */
        , p_i_v_ex_mlo_vessel                                   VARCHAR2 /* *7 * */
        , p_i_v_ex_mlo_voyage                                   VARCHAR2 /* *7 * */
        , p_i_v_terminal                                        VARCHAR2 /* *7 * */
        , p_i_v_user_id                                         VARCHAR2
        , p_i_v_activity_date                                   VARCHAR2 /* *12 * */
        , p_i_v_category_code                                VARCHAR2 --*15
        , p_o_v_error                                           OUT VARCHAR2
    )  AS

        l_v_error_count                                         VARCHAR2(5);
        l_v_invalid_equipment                                   VARCHAR2(4000);
        l_v_error_count_coc                                     VARCHAR2(5);
        l_v_preadvice_err_count                                 VARCHAR2(5);
        l_v_preadvice_err_eq_no                                 VARCHAR2(4000);
        l_v_invalid_equipment_coc                               VARCHAR2(4000);
        l_v_rowcount                                            VARCHAR2(10);
        l_v_rowcount_cat                                       VARCHAR2(10); --*15
        l_v_rowcount_not_upd_cat                          VARCHAR2(10); --*15
        l_v_operator_found                                      VARCHAR2(5);
        l_v_sql                                                 VARCHAR2(5000);
        l_n_pos_var                                             NUMBER := 0; -- added 19.12.2011
        l_v_service                                             VASAPPS.TOS_DL_DISCHARGE_LIST.FK_SERVICE%TYPE; -- added by vikas, 26.01.2012
        l_o_v_dup_present                                       VARCHAR2(5); --*1
        L_ATA_DATE                                               VARCHAR2(50);
        INVALID_DATE_EXCEPTION EXCEPTION; /* *10 * */
        L_V_DATE TIMESTAMP; /* *10 * */
        --*15 begin
        l_i_instr integer;
        l_v_substr varchar2(4000 char);
        l_v_flage_upd_category varchar2(1 char) default 'N';
        d_v_flag_upd_category  varchar2(1 char) default 'N';
        V_SQL                                                       VARCHAR2(4000); -- *15.1
        --*15.1 begin
        l_v_user                 BKP009.BICUSR%TYPE := 'EZLL';
        l_v_date_1                BKP009.BICDAT%TYPE;        
        l_v_time                 BKP009.BICTIM%TYPE;
        --*15.1 end        

        TYPE dyn_cursor_type IS REF CURSOR;

        /*
            Create a cursor variable
        */
        dyn_cursor            dyn_cursor_type;

        /*
            Create a record to hold cursor value
        */
        TYPE dyn_record IS RECORD (
            FK_BOOKING_NO                    TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE
            , DN_EQUIPMENT_NO                TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE
            , LOADING_STATUS                 TOS_LL_BOOKED_LOADING.LOADING_STATUS%TYPE            
            , FK_BKG_EQUIPM_DTL              TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE 
            , CATEGORY_CODE                  TOS_LL_BOOKED_LOADING.CATEGORY_CODE%TYPE --*15            
         );

        dyn_rec                  dyn_record;
        --*15 end
    BEGIN

    p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    l_v_parameter_str := p_i_v_flag
        ||'~'|| p_i_v_find1
        ||'~'|| p_i_v_in1
        ||'~'|| p_i_v_find2
        ||'~'|| p_i_v_in2
        ||'~'|| p_i_v_container_op
        ||'~'|| p_i_v_slot_op
        ||'~'|| p_i_v_out_slot_op
        ||'~'|| p_i_v_pod
        ||'~'|| p_i_v_pol
        ||'~'|| p_i_v_equip_type
        ||'~'|| p_i_v_midstream_handling
        ||'~'|| p_i_v_mlo_vessel
        ||'~'|| p_i_v_mlo_voyage
        ||'~'|| p_i_v_soc_coc
        ||'~'|| p_i_v_con_mlo_vessel
        ||'~'|| p_i_v_con_mlo_voyage
        ||'~'|| p_i_v_con_mlo_pod1
        ||'~'|| p_i_v_con_mlo_pod2
        ||'~'|| p_i_v_con_mlo_pod3
        ||'~'|| p_i_v_con_mlo_del
        ||'~'|| p_i_v_con_handl_code1
        ||'~'|| p_i_v_con_handl_code2
        ||'~'|| p_i_v_con_handl_code3
        ||'~'|| p_i_v_load_disch_status
        ||'~'|| p_i_v_tab_flag
        ||'~'|| p_i_v_id
        ||'~'|| p_i_v_local_containr_sts
        ||'~'|| p_i_v_ata_date
        ||'~'|| p_i_v_ex_mlo_vessel
        ||'~'|| p_i_v_ex_mlo_voyage
        ||'~'|| p_i_v_terminal
        ||'~'|| p_i_v_user_id
        ||'~'|| p_i_v_activity_date
        ||'~'||p_i_v_category_code;

         -- INSERT INTO ECM_LOG_TRACE(
             -- PROG_ID
             -- , PROG_SQL
             -- , RECORD_STATUS
             -- , RECORD_ADD_USER
             -- , RECORD_ADD_DATE
             -- , RECORD_CHANGE_USER
             -- , RECORD_CHANGE_DATE)
         -- VALUES
         -- (
             -- 'BU'
             -- ,l_v_parameter_str
             -- ,'A'
             -- ,'TEST'
             -- ,SYSDATE
             -- ,'TEST'
             -- ,SYSDATE

         -- );
         -- commit;


    g_v_sql := '';
    g_v_validation_sql := '';

    l_v_error_count_coc         := NULL;
    l_v_invalid_equipment_coc   := NULL;
    l_v_preadvice_err_count     := NULL;
    l_v_preadvice_err_eq_no     := NULL;

    g_v_sql_id := 'SQL1001';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
    /* When container operator is not null the check
       Equipment# should not be COC.*/
      IF(p_i_v_container_op IS NOT NULL) THEN
        /* Get equipment# */
        IF (p_i_v_flag = DISCHARGE_LIST) THEN
            IF (p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                g_v_validation_soc_sql :=   'SELECT SUBSTR(SUBSTR (EQUIPMENTLIST, 2), 1, 2000) EQUIPMENTLIST
                  FROM (SELECT   SYS_CONNECT_BY_PATH ( EQUIPMENT_NO, '','') EQUIPMENTLIST, r
                      FROM (SELECT   ROWNUM ID, EQUIPMENT_NO,
                         RANK () OVER (ORDER BY ROWID DESC) r';
                g_v_validation_soc_sql := g_v_validation_soc_sql || ' FROM TOS_DL_OVERLANDED_CONTAINER WHERE ';
            ELSIF (p_i_v_tab_flag = BOOKED_TAB) THEN
                g_v_validation_soc_sql :=   'SELECT SUBSTR(SUBSTR (EQUIPMENTLIST, 2),1,2000) EQUIPMENTLIST
                        FROM (SELECT   SYS_CONNECT_BY_PATH ( DN_EQUIPMENT_NO, '','') EQUIPMENTLIST, r
                            FROM (SELECT   ROWNUM ID, DN_EQUIPMENT_NO,
                                     RANK () OVER (ORDER BY ROWID DESC) r';
                g_v_validation_soc_sql := g_v_validation_soc_sql || ' FROM TOS_DL_BOOKED_DISCHARGE WHERE ';

                -- DBMS_OUTPUT.put_line('g_v_validation_soc_sql: ' || g_v_validation_soc_sql);
            END IF;
        ELSIF (p_i_v_flag = LOAD_LIST) THEN
            IF (p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                g_v_validation_soc_sql :=   'SELECT SUBSTR(SUBSTR (EQUIPMENTLIST, 2), 1, 2000) EQUIPMENTLIST
                  FROM (SELECT   SYS_CONNECT_BY_PATH ( EQUIPMENT_NO, '','') EQUIPMENTLIST, r
                      FROM (SELECT   ROWNUM ID, EQUIPMENT_NO,
                         RANK () OVER (ORDER BY ROWID DESC) r';
                g_v_validation_soc_sql := g_v_validation_soc_sql || ' FROM TOS_LL_OVERSHIPPED_CONTAINER WHERE ';
            ELSIF (p_i_v_tab_flag = BOOKED_TAB) THEN
                g_v_validation_soc_sql :=   'SELECT SUBSTR(SUBSTR (EQUIPMENTLIST, 2),1,2000) EQUIPMENTLIST
                        FROM (SELECT   SYS_CONNECT_BY_PATH ( DN_EQUIPMENT_NO, '','') EQUIPMENTLIST, r
                            FROM (SELECT   ROWNUM ID, DN_EQUIPMENT_NO,
                                     RANK () OVER (ORDER BY ROWID DESC) r';
                g_v_validation_soc_sql := g_v_validation_soc_sql || ' FROM TOS_LL_BOOKED_LOADING WHERE ';
            END IF;
        END IF;

        g_v_validation_sql := g_v_validation_soc_sql;
        /*  Add additional where conditions into  g_v_validation_sql */
        g_v_sql_id := 'SQL1002';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
        GET_WHERE_COND_FOR_VALID(p_i_v_in1, p_i_v_find1,p_i_v_in2, p_i_v_find2, p_i_v_id, l_v_operator_found, p_i_v_flag, p_i_v_tab_flag, 'true');
        -- DBMS_OUTPUT.put_line('g_v_validation_soc_sql: ' || g_v_validation_soc_sql);
        /* Procedure to get comma seprated equipment no# with blank container operator. */
        g_v_sql_id := 'SQL1003';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
        GET_INVALID_RECORDS(
              p_i_v_flag
            , p_i_v_tab_flag
            , l_v_error_count_coc
            , l_v_invalid_equipment_coc
            , l_v_preadvice_err_count
            , l_v_preadvice_err_eq_no
            , p_o_v_error
        );


      END IF;
    g_v_sql_id := 'SQL1004';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

    /* If screen opens from Discharge list. */
      IF(p_i_v_flag = DISCHARGE_LIST) THEN

        /* 1 Screen Opens from Discharge List Overlanded Tab */
        IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
            g_v_sql := 'UPDATE  TOS_DL_OVERLANDED_CONTAINER SET ';
        END IF;

        /* 1 Screen Opens from Discharge List Booked Tab */
        IF (p_i_v_tab_flag = BOOKED_TAB) THEN
            g_v_sql := 'UPDATE  TOS_DL_BOOKED_DISCHARGE SET ';

            /* Sql to get equipment# with container operator code is "****" */
            g_v_validation_sql :=
                'SELECT SUBSTR(SUBSTR (EQUIPMENTLIST, 2), 1, 2000) EQUIPMENTLIST
                FROM (SELECT   SYS_CONNECT_BY_PATH ( DN_EQUIPMENT_NO, '','') EQUIPMENTLIST, r
                    FROM (SELECT   ROWNUM ID, DN_EQUIPMENT_NO,
                             RANK () OVER (ORDER BY ROWID DESC) r
                        FROM TOS_DL_BOOKED_DISCHARGE WHERE ';

            /*  Add additional where conditions into  g_v_validation_sql */
            /* validation for blank equipment#, blank stowage position and container with ****. */
            g_v_sql_id := 'SQL1005';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            GET_WHERE_COND_FOR_VALID(p_i_v_in1, p_i_v_find1, p_i_v_in2, p_i_v_find2, p_i_v_id, l_v_operator_found, p_i_v_flag, p_i_v_tab_flag, 'false');

            /* Procedure to get comma seprated equipment no# with blank container operator. */
            g_v_sql_id := 'SQL1006';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            GET_INVALID_RECORDS(
                  p_i_v_flag
                , p_i_v_tab_flag
                , l_v_error_count
                , l_v_invalid_equipment
                , l_v_preadvice_err_count
                , l_v_preadvice_err_eq_no
                , p_o_v_error
            );

        END IF;

        g_v_sql_id := 'SQL1007';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

        IF(p_i_v_container_op IS NOT NULL) THEN
            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN /* 1 For Overlanded Tab */
                g_v_sql :=g_v_sql ||', CONTAINER_OPERATOR     =    '''||p_i_v_container_op ||'''';
            END IF;

            g_v_sql_id := 'SQL1008';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            IF(p_i_v_tab_flag = BOOKED_TAB) THEN /* 2 For Booked Tab */
                g_v_sql :=g_v_sql ||', FK_CONTAINER_OPERATOR     =    '''||p_i_v_container_op ||'''';
            END IF;

        END IF;

        IF(p_i_v_slot_op IS NOT NULL) THEN
            g_v_sql_id := 'SQL1009';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

            SELECT COUNT(1)
            INTO m_v_data
            FROM OPERATOR_CODE_MASTER
            WHERE operator_code = p_i_v_slot_op  ;

            IF(m_v_data = 0) THEN
                p_o_v_error := 'EDL.SE0150';
                RAISE g_exp_invalid_slot_op;
            END IF;

            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN /* 1 For Overlanded Tab */
                g_v_sql :=g_v_sql ||', SLOT_OPERATOR  =    '''||p_i_v_slot_op ||'''';
            END IF;
            IF(p_i_v_tab_flag = BOOKED_TAB) THEN /* 2 For Booked Tab */
                g_v_sql :=g_v_sql ||', FK_SLOT_OPERATOR  =    '''||p_i_v_slot_op ||'''';
            END IF;

        END IF;

        IF(p_i_v_out_slot_op  IS NOT NULL) THEN
            g_v_sql_id := 'SQL1010';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

            /* Start Commented by vikas, no need to validate out slot operator, 23.11.2011 *
            SELECT COUNT(1)
            INTO o_v_data
            FROM OPERATOR_CODE_MASTER
            WHERE operator_code = p_i_v_out_slot_op   ;

            IF(o_v_data = 0) THEN
                p_o_v_error := 'EDL.SE0152';
                RAISE g_exp_invalid_out_slot_op;
            END IF;
            * End Commented by vikas, no need to validate out slot operator, 23.11.2011 */
            g_v_sql :=g_v_sql ||', OUT_SLOT_OPERATOR = '''||p_i_v_out_slot_op ||'''';
        END IF;

        IF(p_i_v_pol  IS NOT NULL) THEN
            g_v_sql_id := 'SQL1011';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

            SELECT COUNT(1)
                INTO p_v_data
                FROM ITP040
            WHERE PICODE = p_i_v_pol ;

            IF(p_v_data = 0) THEN
                p_o_v_error := 'EDL.SE0162';
                RAISE g_exp_invalid_pol;
            END IF;
            g_v_sql :=g_v_sql ||', POL =    '''||p_i_v_pol||''''; /* Not required for Booked Tab */
        END IF;

        IF(p_i_v_equip_type IS NOT NULL) THEN
            g_v_sql_id := 'SQL1012';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

            SELECT COUNT(1)
            INTO n_v_data
            FROM ITP075
            WHERE TRTYPE = p_i_v_equip_type;

            IF(n_v_data = 0) THEN
                p_o_v_error := 'EDL.SE0163';
                RAISE g_exp_invalid_equipment_type;
            END IF;
            g_v_sql :=g_v_sql ||', EQ_TYPE    =    '''||p_i_v_equip_type||''''; /* Not required for Booked Tab */
        END IF;

        IF(p_i_v_midstream_handling  IS NOT NULL) THEN
            g_v_sql :=g_v_sql ||', MIDSTREAM_HANDLING_CODE    =    '''||p_i_v_midstream_handling ||'''';
        END IF;

        IF(p_i_v_mlo_vessel  IS NOT NULL) THEN
            g_v_sql :=g_v_sql ||', MLO_VESSEL = '''||p_i_v_mlo_vessel ||'''';
        END IF;

        IF(p_i_v_mlo_voyage  IS NOT NULL) THEN
            g_v_sql :=g_v_sql ||', MLO_VOYAGE = '''||p_i_v_mlo_voyage ||'''';
        END IF;

        IF(p_i_v_soc_coc  IS NOT NULL) THEN
            g_v_sql :=g_v_sql ||', FLAG_SOC_COC = '''||p_i_v_soc_coc ||''''; /* Not required for Booked Tab */
        END IF;

        /* *12 start * */
        IF p_i_v_activity_date IS NOT NULL THEN
            g_v_sql_id := 'SQL1014A';
            /* *do date validation * */
            BEGIN
                SELECT
                    to_date(p_i_v_activity_date, 'DD/MM/YYYY HH24:MI')
                INTO
                    L_V_DATE
                FROM
                    DUAL;

            EXCEPTION
                WHEN OTHERS THEN
                    p_o_v_error := 'ECM.GE0008';
                    RAISE INVALID_DATE_EXCEPTION;
            END;


--             g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''|| L_V_DATE ||'''';
            -- g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''||TO_DATE(p_i_v_activity_date, '''DD/MM/YYYY HH24:MI''') ||'''';
            -- g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''|| TO_CHAR(L_V_DATE, 'DD-MON-yyyy HH:MI:SS am') ||'''';
            g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''|| TO_CHAR(L_V_DATE, 'DD-MON-RRRR HH:MI:SS am') ||'''';

        END IF;

        /* *12 end * */

        /* *7 start * */

        IF(P_I_V_TAB_FLAG = OVERLAND_OVERSHIP_TAB) THEN
            IF(P_I_V_TERMINAL  IS NOT NULL) THEN
                G_V_SQL :=G_V_SQL ||', POL_TERMINAL = '''||P_I_V_TERMINAL ||'''';
            END IF;
        END IF;
        /* *7 end * */

        /* when screen open from booked tab then check more fields. */
        g_v_sql_id := 'SQL1013';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
        IF(p_i_v_tab_flag = BOOKED_TAB) THEN
            IF(p_i_v_con_mlo_pod1  IS NOT NULL) THEN
                g_v_sql :=g_v_sql ||', MLO_POD1 = '''||p_i_v_con_mlo_pod1 ||'''';
            END IF;

            IF(p_i_v_con_mlo_pod2  IS NOT NULL) THEN
                g_v_sql :=g_v_sql ||', MLO_POD2 = '''||p_i_v_con_mlo_pod2 ||'''';
            END IF;

            IF(p_i_v_con_mlo_pod3  IS NOT NULL) THEN
                g_v_sql :=g_v_sql ||', MLO_POD3 = '''||p_i_v_con_mlo_pod3 ||'''';
            END IF;

            IF(p_i_v_con_mlo_del  IS NOT NULL) THEN
                g_v_sql :=g_v_sql ||', MLO_DEL = '''||p_i_v_con_mlo_del ||'''';
            END IF;

            IF(p_i_v_con_handl_code1  IS NOT NULL) THEN
            g_v_sql_id := 'SQL1014';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                SELECT COUNT(1)
                INTO m_v_data
                FROM SHP007
                WHERE SHI_CODE = p_i_v_con_handl_code1  ;

                IF(m_v_data = 0) THEN
                  p_o_v_error := 'EDL.SE0169';
                  RAISE g_exp_invalid_handling_code;
                END IF;

                g_v_sql :=g_v_sql ||', FK_HANDLING_INSTRUCTION_1 = '''||p_i_v_con_handl_code1 ||'''';

            END IF;




            IF(p_i_v_con_handl_code2  IS NOT NULL) THEN
            g_v_sql_id := 'SQL1015';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                SELECT COUNT(1)
                INTO m_v_data
                FROM SHP007
                WHERE SHI_CODE = p_i_v_con_handl_code2  ;

                IF(m_v_data = 0) THEN
                  p_o_v_error := 'EDL.SE0169';
                  RAISE g_exp_invalid_handling_code;
                END IF;
                g_v_sql :=g_v_sql ||', FK_HANDLING_INSTRUCTION_2 = '''||p_i_v_con_handl_code2 ||'''';
            END IF;

            IF(p_i_v_con_handl_code3  IS NOT NULL) THEN
            g_v_sql_id := 'SQL1016';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                SELECT COUNT(1)
                INTO m_v_data
                FROM SHP007
                WHERE SHI_CODE = p_i_v_con_handl_code3  ;

                IF(m_v_data = 0) THEN
                  p_o_v_error := 'EDL.SE0169';
                  RAISE g_exp_invalid_handling_code;
                END IF;
                g_v_sql :=g_v_sql ||', FK_HANDLING_INSTRUCTION_3 = '''||p_i_v_con_handl_code3 ||'''';
            END IF;
            g_v_sql_id := 'SQL1017';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

            IF(p_i_v_load_disch_status  IS NOT NULL) THEN
                --*1 Begin
                --Check if duplicate stowage position exists
                PRE_CHECK_DUP_STOW_POS_PRESENT(p_i_v_id, p_i_v_tab_flag, p_i_v_flag, l_o_v_dup_present);
                IF(l_o_v_dup_present = 'TRUE') THEN
                        p_o_v_error := 'EDL.SE0187';
                        RAISE g_exp_duplicate_stowage_pos;
                END IF;
                --*1  End
                g_v_sql := g_v_sql ||',     DISCHARGE_STATUS = '''||p_i_v_load_disch_status ||'''';
            END IF;

            IF(p_i_v_local_containr_sts  IS NOT NULL) THEN
                g_v_sql := g_v_sql ||',     LOCAL_TERMINAL_STATUS = '''||p_i_v_local_containr_sts ||'''';
            END IF;

            /* *12
            only eta date will be used no need to update ata date, as k'chatgamol

            L_ATA_DATE := p_i_v_ata_date; -- *6
            IF (LENGTH(p_i_v_ata_date) = 21 )THEN -- *6
                SELECT SUBSTR(p_i_v_ata_date, 12) || ' 12:00' -- *6
                INTO L_ATA_DATE -- *6
                FROM DUAL; -- *6
            END IF; -- *6

            /*
                *2: Changes start
            *
            IF(LENGTH(L_ATA_DATE) >= 10) THEN --*11
                g_v_sql := g_v_sql ||',     ACTIVITY_DATE_TIME  = '''||TO_CHAR(TO_DATE(L_ATA_DATE, '''DD/MM/YYYY HH24:MI'''), 'DD-MON-RRRR HH:MI:SS am') ||''''; -- *4
            END IF; --*11
            /*
                *2: Changes End
            *
                *12 end
            */

        END IF;

      END IF;

    /* Check if screen opens from LL maintenance */
      IF(p_i_v_flag = LOAD_LIST) THEN

        /* 1 Screen Opens from Load List Overshipped Tab */
        IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
            g_v_sql_id := 'SQL1018';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            g_v_sql := 'UPDATE  TOS_LL_OVERSHIPPED_CONTAINER SET ';

            /* Sql to get equipment# with container operator code is "****" */
            g_v_sql_id := 'SQL1019';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            g_v_validation_sql :=
                'SELECT SUBSTR(SUBSTR (EQUIPMENTLIST, 2), 1,2000) EQUIPMENTLIST
                FROM (SELECT   SYS_CONNECT_BY_PATH ( EQUIPMENT_NO, '','') EQUIPMENTLIST, r
                    FROM (SELECT   ROWNUM ID, EQUIPMENT_NO,
                             RANK () OVER (ORDER BY ROWID DESC) r
                        FROM TOS_LL_OVERSHIPPED_CONTAINER WHERE ';

            /*  Add additional where conditions into  g_v_validation_sql */
            /* validation for blank equipment#, blank stowage position and container with ****. */
            g_v_sql_id := 'SQL1020';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            GET_WHERE_COND_FOR_VALID(p_i_v_in1, p_i_v_find1, p_i_v_in2, p_i_v_find2, p_i_v_id, l_v_operator_found, p_i_v_flag, p_i_v_tab_flag, 'false');

            /* Procedure to get comma seprated equipment no# with blank container operator. */
            g_v_sql_id := 'SQL1021';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            GET_INVALID_RECORDS(
                  p_i_v_flag
                , p_i_v_tab_flag
                , l_v_error_count
                , l_v_invalid_equipment
                , l_v_preadvice_err_count
                , l_v_preadvice_err_eq_no
                , p_o_v_error
            );

        END IF;

        /* 1 Screen Opens from Load List Booked Tab */
        IF (p_i_v_tab_flag = BOOKED_TAB) THEN
            g_v_sql_id := 'SQL1022';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            g_v_sql := 'UPDATE  TOS_LL_BOOKED_LOADING SET ';

            /* Sql to get equipment# with container operator code is "****" */
            g_v_sql_id := 'SQL1023';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            g_v_validation_sql :=
                'SELECT SUBSTR(SUBSTR (EQUIPMENTLIST, 2), 1, 2000) EQUIPMENTLIST
                FROM (SELECT   SYS_CONNECT_BY_PATH ( DN_EQUIPMENT_NO, '','') EQUIPMENTLIST, r
                    FROM (SELECT   ROWNUM ID, DN_EQUIPMENT_NO,
                             RANK () OVER (ORDER BY ROWID DESC) r
                        FROM TOS_LL_BOOKED_LOADING WHERE ';

            /*  Add additional where conditions into  g_v_validation_sql */
            /* validation for blank equipment#, blank stowage position and container with ****. */
            g_v_sql_id := 'SQL1024';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            GET_WHERE_COND_FOR_VALID(p_i_v_in1, p_i_v_find1, p_i_v_in2, p_i_v_find2, p_i_v_id, l_v_operator_found, p_i_v_flag, p_i_v_tab_flag, 'false');

            /* Procedure to get comma seprated equipment no# with blank container operator. */
            g_v_sql_id := 'SQL1025';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            GET_INVALID_RECORDS(
                  p_i_v_flag
                , p_i_v_tab_flag
                , l_v_error_count
                , l_v_invalid_equipment
                , l_v_preadvice_err_count
                , l_v_preadvice_err_eq_no
                , p_o_v_error
            );
            --*15 begin
            IF p_i_v_category_code IS NOT NULL THEN
             l_v_flage_upd_category := 'Y';
            END IF;
            --*15 end

        END IF;


        /* Update container operator */
        IF(p_i_v_container_op IS NOT NULL) THEN
            g_v_sql_id := 'SQL1026';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                g_v_sql := g_v_sql ||', CONTAINER_OPERATOR     =    '''||p_i_v_container_op ||'''';
            END IF;

            IF(p_i_v_tab_flag = BOOKED_TAB) THEN
                g_v_sql := g_v_sql ||', FK_CONTAINER_OPERATOR     =    '''||p_i_v_container_op ||'''';
            END IF;
        END IF;

        /* Update slot operator */
        IF(p_i_v_slot_op IS NOT NULL) THEN
            g_v_sql_id := 'SQL1027';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            SELECT COUNT(1)
            INTO m_v_data
            FROM OPERATOR_CODE_MASTER
            WHERE operator_code = p_i_v_slot_op  ;

            IF(m_v_data = 0) THEN
                p_o_v_error := 'EDL.SE0150';
                RAISE g_exp_invalid_slot_op;
            END IF;

            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                g_v_sql :=g_v_sql ||', SLOT_OPERATOR  =    '''||p_i_v_slot_op ||'''';
            END IF;
            IF(p_i_v_tab_flag = BOOKED_TAB) THEN
                g_v_sql :=g_v_sql ||', FK_SLOT_OPERATOR  =    '''||p_i_v_slot_op ||'''';
            END IF;
        END IF;

        /* Update out slot operator */
        IF(p_i_v_out_slot_op  IS NOT NULL) THEN
            g_v_sql_id := 'SQL1028';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            /* Start Commented by vikas, no need to validate out slot operator, 23.11.2011 *

            SELECT COUNT(1)
            INTO o_v_data
            FROM OPERATOR_CODE_MASTER
            WHERE operator_code = p_i_v_out_slot_op   ;

            IF(o_v_data = 0) THEN
                p_o_v_error := 'EDL.SE0152';
                RAISE g_exp_invalid_out_slot_op;
            END IF;

            * End Commented by vikas, no need to validate out slot operator, 23.11.2011 */
            g_v_sql := g_v_sql ||', OUT_SLOT_OPERATOR    =    '''||p_i_v_out_slot_op ||'''';
        END IF;

        /* Update pod */
        IF(p_i_v_pod   IS NOT NULL) THEN
            g_v_sql_id := 'SQL1029';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            SELECT COUNT(1)
            INTO q_v_data
            FROM ITP040
            WHERE PICODE = p_i_v_pod ;

            IF(q_v_data = 0) THEN
                p_o_v_error := 'EDL.SE0154';
                RAISE g_exp_invalid_pod;
            END IF;

            /* POD_TERMINAL field available only in overshipped tab*/
            /* g_v_sql :=g_v_sql ||', POD_TERMINAL =    '''||p_i_v_pod||'''';  *15  */
           -- g_v_sql :=g_v_sql ||', DISCHARGE_PORT = '''||p_i_v_pod||''''; -- *15

            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                g_v_sql :=g_v_sql ||', DISCHARGE_PORT = '''||p_i_v_pod||''''; -- *15
            END IF;
            IF(p_i_v_tab_flag = BOOKED_TAB) THEN
                  G_V_SQL :=G_V_SQL ||', DN_DISCHARGE_PORT = '''||P_I_V_POD||''''; -- *15
            END IF;

        END IF;

        /* Update equipment type */
        IF(p_i_v_equip_type IS NOT NULL) THEN
            g_v_sql_id := 'SQL1030';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            SELECT COUNT(1)
            INTO n_v_data
            FROM ITP075
            WHERE TRTYPE = p_i_v_equip_type;

            IF(n_v_data = 0) THEN
                p_o_v_error := 'EDL.SE0163';
                RAISE g_exp_invalid_equipment_type;
            END IF;
            g_v_sql :=g_v_sql ||', EQ_TYPE    =    '''||p_i_v_equip_type||'''';
        END IF;

        IF(p_i_v_midstream_handling  IS NOT NULL) THEN
            g_v_sql :=g_v_sql ||', MIDSTREAM_HANDLING_CODE    =    '''||p_i_v_midstream_handling ||'''';
        END IF;

        IF(p_i_v_mlo_vessel  IS NOT NULL) THEN
            g_v_sql :=g_v_sql ||', MLO_VESSEL = '''||p_i_v_mlo_vessel ||'''';
        END IF;

        IF(p_i_v_mlo_voyage  IS NOT NULL) THEN
            g_v_sql :=g_v_sql ||', MLO_VOYAGE = '''||p_i_v_mlo_voyage ||'''';
        END IF;

        IF(p_i_v_soc_coc  IS NOT NULL) THEN
            g_v_sql :=g_v_sql ||', FLAG_SOC_COC = '''||p_i_v_soc_coc ||'''';
        END IF;

        /* *12 start * */
        IF p_i_v_activity_date IS NOT NULL THEN
            g_v_sql_id := 'SQL1014A';
            /* *do date validation * */
            BEGIN
                SELECT
                    TO_TIMESTAMP(p_i_v_activity_date, 'DD/MM/YYYY HH24:MI')
                INTO
                    L_V_DATE
                FROM
                    DUAL;

            EXCEPTION
                WHEN OTHERS THEN
                    p_o_v_error := 'ECM.GE0008';
                    RAISE INVALID_DATE_EXCEPTION;
            END;

            -- g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''||TO_DATE(p_i_v_activity_date, '''DD/MM/YYYY HH24:MI''') ||'''';
            -- g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''|| TO_CHAR(L_V_DATE, 'DD-MON-RRRR HH24:MI:SS') ||'''';
            -- g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''|| TO_char(L_V_DATE, 'DD-MON-yyyy HH24:MI') ||'''';
            -- g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''|| L_V_DATE ||'''';
            g_v_sql := g_v_sql ||', ACTIVITY_DATE_TIME = '''|| TO_CHAR(L_V_DATE, 'DD-MON-RRRR HH:MI:SS am') ||'''';
        END IF;
        /* *12 end * */

        /* *7 start * */

        IF(P_I_V_TAB_FLAG = OVERLAND_OVERSHIP_TAB) THEN
            IF(P_I_V_EX_MLO_VESSEL  IS NOT NULL) THEN
                G_V_SQL :=G_V_SQL ||', EX_MLO_VESSEL = '''||P_I_V_EX_MLO_VESSEL ||'''';
            END IF;
            IF(P_I_V_EX_MLO_VOYAGE  IS NOT NULL) THEN
                G_V_SQL :=G_V_SQL ||', EX_MLO_VOYAGE = '''||P_I_V_EX_MLO_VOYAGE ||'''';
            END IF;

            IF(P_I_V_TERMINAL  IS NOT NULL) THEN
                G_V_SQL :=G_V_SQL ||', POD_TERMINAL = '''||P_I_V_TERMINAL ||'''';
            END IF;
        END IF;
        /* *7 end * */

        /* when called from booked tab */
        IF(p_i_v_tab_flag = BOOKED_TAB) THEN
            IF(p_i_v_con_mlo_pod1  IS NOT NULL) THEN
                g_v_sql :=g_v_sql ||', MLO_POD1 = '''||p_i_v_con_mlo_pod1 ||'''';
            END IF;

            IF(p_i_v_con_mlo_pod2  IS NOT NULL) THEN
                g_v_sql :=g_v_sql ||', MLO_POD2 = '''||p_i_v_con_mlo_pod2 ||'''';
            END IF;

            IF(p_i_v_con_mlo_pod3  IS NOT NULL) THEN
                g_v_sql :=g_v_sql ||', MLO_POD3 = '''||p_i_v_con_mlo_pod3 ||'''';
            END IF;

            IF(p_i_v_con_mlo_del  IS NOT NULL) THEN
                g_v_sql :=g_v_sql ||', MLO_DEL = '''||p_i_v_con_mlo_del ||'''';
            END IF;

            IF(p_i_v_con_handl_code1  IS NOT NULL) THEN
                g_v_sql_id := 'SQL1031';
                -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                SELECT COUNT(1)
                INTO m_v_data
                FROM SHP007
                WHERE SHI_CODE = p_i_v_con_handl_code1  ;

                IF(m_v_data = 0) THEN
                  p_o_v_error := 'EDL.SE0169';
                  RAISE g_exp_invalid_handling_code;
                END IF;

                g_v_sql :=g_v_sql ||', FK_HANDLING_INSTRUCTION_1 = '''||p_i_v_con_handl_code1 ||'''';

            END IF;

            IF(p_i_v_con_handl_code2  IS NOT NULL) THEN
                g_v_sql_id := 'SQL1032';
                -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                SELECT COUNT(1)
                INTO m_v_data
                FROM SHP007
                WHERE SHI_CODE = p_i_v_con_handl_code2  ;

                IF(m_v_data = 0) THEN
                  p_o_v_error := 'EDL.SE0169';
                  RAISE g_exp_invalid_handling_code;
                END IF;
                g_v_sql :=g_v_sql ||', FK_HANDLING_INSTRUCTION_2 = '''||p_i_v_con_handl_code2 ||'''';
            END IF;

            IF(p_i_v_con_handl_code3  IS NOT NULL) THEN
                g_v_sql_id := 'SQL1033';
                -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                SELECT COUNT(1)
                INTO m_v_data
                FROM SHP007
                WHERE SHI_CODE = p_i_v_con_handl_code3  ;

                IF(m_v_data = 0) THEN
                  p_o_v_error := 'EDL.SE0169';
                  RAISE g_exp_invalid_handling_code;
                END IF;
                g_v_sql :=g_v_sql ||', FK_HANDLING_INSTRUCTION_3 = '''||p_i_v_con_handl_code3 ||'''';
            END IF;

            IF(p_i_v_load_disch_status  IS NOT NULL) THEN
                --*1 Begin
                -- Check if duplicate stowage position exists
                PRE_CHECK_DUP_STOW_POS_PRESENT(p_i_v_id, p_i_v_tab_flag, p_i_v_flag, l_o_v_dup_present);
                IF(l_o_v_dup_present = 'TRUE') THEN
                        p_o_v_error := 'EDL.SE0187';
                        RAISE g_exp_duplicate_stowage_pos;
                END IF;--*1 End

                g_v_sql :=g_v_sql ||',     LOADING_STATUS = '''||p_i_v_load_disch_status ||'''';
            END IF;

            IF(p_i_v_local_containr_sts  IS NOT NULL) THEN
                g_v_sql := g_v_sql ||',     LOCAL_TERMINAL_STATUS = '''||p_i_v_local_containr_sts ||'''';
            END IF;

        END IF;
        /* booked tab update sql end */

      END IF;

    /* update record change user and record change date information */
    g_v_sql := g_v_sql ||', RECORD_CHANGE_USER = '''|| p_i_v_user_id ||'''';
    g_v_sql := g_v_sql ||', RECORD_CHANGE_DATE = '''|| TO_CHAR(SYSDATE, 'DD-MON-RRRR HH:MI:SS am') ||'''';

    --Where clause conditions.
    g_v_sql_id := 'SQL1034';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
     IF(p_i_v_in1 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
        /* Check if screen opens from LL maintenance */
        IF(p_i_v_flag = LOAD_LIST) THEN
            g_v_sql :=g_v_sql || ' WHERE FK_LOAD_LIST_ID = ''' || p_i_v_id || ''' AND ';
        END IF;
        /* Check if screen opens from LL maintenance */
        IF(p_i_v_flag = DISCHARGE_LIST) THEN
            g_v_sql := g_v_sql || ' WHERE FK_DISCHARGE_LIST_ID = ''' || p_i_v_id || ''' AND ';
        END IF;

        g_v_sql_id := 'SQL1035';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
         -- DBMS_OUTPUT.put_line ('l_v_sql: ' ||l_v_sql);

        ADDITION_WHERE_CONDTIONS(p_i_v_in1, p_i_v_find1,p_i_v_flag,p_i_v_tab_flag, p_i_v_load_disch_status, l_v_sql);

        -- DBMS_OUTPUT.put_line ('l_v_sql: ' ||l_v_sql);

        g_v_sql := g_v_sql || l_v_sql;
        -- DBMS_OUTPUT.put_line ('g_v_sql: ' ||g_v_sql);

      END IF;

      IF(p_i_v_in2 IS NOT NULL) THEN
        -- this function add the additional where clauss condtions in
        -- dynamic sql according to the passed parameter.
        g_v_sql_id := 'SQL1036';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

        IF(p_i_v_in1 IS NOT NULL) THEN
            g_v_sql := g_v_sql ||' AND ';
        ELSE
            /* Check if screen opens from LL maintenance */
            IF(p_i_v_flag = LOAD_LIST) THEN
               g_v_sql :=g_v_sql || ' WHERE FK_LOAD_LIST_ID = ''' || p_i_v_id || ''' AND ';
            END IF;
            /* Check if screen opens from LL maintenance */
            IF(p_i_v_flag = DISCHARGE_LIST) THEN
               g_v_sql :=g_v_sql || ' WHERE FK_DISCHARGE_LIST_ID = ''' || p_i_v_id || ''' AND ';
            END IF;
        END IF;

        g_v_sql_id := 'SQL1037';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
        ADDITION_WHERE_CONDTIONS(p_i_v_in2, p_i_v_find2,p_i_v_flag, p_i_v_tab_flag, p_i_v_load_disch_status, l_v_sql);
        g_v_sql_id := 'SQL1038';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
        g_v_sql := g_v_sql || l_v_sql;
      END IF;

    /* Remove unwanted (,) FROM G_V_SQL*/

    g_v_sql := REPLACE (g_v_sql,'SET , ','SET ');
    g_v_sql_id := 'SQL0381';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

    /*
        Block start by vikas, to check if service is afs or
        dfs then no need to check blank stowage position on
        booked tab, k'chatgamol, 26.01.2012

        Need to check if service is afs or dfs then no need to check blank stowage position
    */
      BEGIN
        l_v_service := NULL;

        SELECT
            FK_SERVICE
        INTO
            l_v_service
        FROM (
            SELECT
                FK_SERVICE
            FROM
                TOS_DL_DISCHARGE_LIST
            WHERE
                PK_DISCHARGE_LIST_ID = p_i_v_id
                AND p_i_v_flag      = DISCHARGE_LIST

            UNION ALL

            SELECT
                FK_SERVICE
            FROM
                TOS_LL_LOAD_LIST
            WHERE
                PK_LOAD_LIST_ID = p_i_v_id
                AND p_i_v_flag      = LOAD_LIST
        );

            -- DBMS_OUTPUT.PUT_LINE('L_V_SERVICE: ' || L_V_SERVICE );
      L_V_SERVICE := LOWER(L_V_SERVICE);
      EXCEPTION
        WHEN OTHERS THEN
          -- DBMS_OUTPUT.PUT_LINE(SQLERRM);
            l_v_service := NULL;
      END ;

    /*
        Block end by vikas, 26.01.2012
    */

    /*equipment # and stowage position should not be null. */
      IF ((p_i_v_in1 IS NULL) AND (p_i_v_in2 IS NULL)) THEN
        /*
            This if block will never executed becuase as per new
            CR there at least one search criteria is mandatory
            vikas, 26.01.2012
        */

        g_v_sql_id := 'SQL0382';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

        /* if no search criteria not specified */
        IF(p_i_v_load_disch_status = 'RB' OR p_i_v_load_disch_status = 'DI') THEN
            g_v_sql_id := 'SQL0383';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            g_v_sql := g_v_sql || ' WHERE DN_EQUIPMENT_NO IS NOT NULL AND STOWAGE_POSITION IS NOT NULL  AND FK_CONTAINER_OPERATOR <> ''****'' ';
            IF(p_i_v_flag = LOAD_LIST) THEN
                g_v_sql :=g_v_sql || ' AND FK_LOAD_LIST_ID = ''' || p_i_v_id || '''';
            END IF;
            /* Check if screen opens from LL maintenance */
            IF(p_i_v_flag = DISCHARGE_LIST) THEN
                g_v_sql_id := 'SQL0384';
                -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                g_v_sql :=g_v_sql || ' AND FK_DISCHARGE_LIST_ID = ''' || p_i_v_id || '''';
            END IF;
        ELSE
           /* Check if screen opens from LL maintenance */
            IF(p_i_v_flag = LOAD_LIST) THEN
                g_v_sql :=g_v_sql || ' WHERE FK_LOAD_LIST_ID = ''' || p_i_v_id || '''';
            END IF;
             /* Check if screen opens from DL maintenance */
            IF(p_i_v_flag = DISCHARGE_LIST) THEN
                g_v_sql_id := 'SQL0385';
                -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                g_v_sql :=g_v_sql || ' WHERE FK_DISCHARGE_LIST_ID = ''' || p_i_v_id || '''';
             END IF;
        END IF;
      ELSE
        /* Check if screen opens from DL maintenance */
        IF (p_i_v_flag = DISCHARGE_LIST) THEN
              g_v_sql_id := 'SQL0385';
              -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

            /* When Discharge Status "ROB","Discharge and
               Stowage Position and Equipment No. should be
               mandatory. Also for SOC container if Container Operator should not be **** " */

            IF(p_i_v_load_disch_status = 'RB') OR (p_i_v_load_disch_status = 'DI') THEN
                g_v_sql_id := 'SQL0386';
                -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

                /*
                    Block start by vikas, to check if service is afs or
                    dfs then no need to check blank stowage position on
                    booked tab, k'chatgamol, 26.01.2012
                */

                IF (p_i_v_tab_flag = BOOKED_TAB) THEN
                    IF ((L_V_SERVICE IS NOT NULL) AND ((L_V_SERVICE = 'afs') OR (L_V_SERVICE = 'dfs'))) THEN
                        /*
                            Service is AFS/DFS, no need to check stowage position
                        */
                        g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO IS NOT NULL AND FK_CONTAINER_OPERATOR <> ''****'' ';
                    ELSE
                        /*
                            Service is not AFS/DFS, need to check stowage position.
                        */
                         g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO IS NOT NULL AND STOWAGE_POSITION IS NOT NULL AND FK_CONTAINER_OPERATOR <> ''****'' ';
                    END IF;
                END IF;

/*
                * old logic *
                g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO IS NOT NULL AND STOWAGE_POSITION IS NOT NULL AND FK_CONTAINER_OPERATOR <> ''****'' ';
*/
            /*
                Block end by vikas, 26.12.2012
            */
            END IF;
        ELSIF (p_i_v_flag = LOAD_LIST) THEN
            IF(p_i_v_load_disch_status = 'RB') OR (p_i_v_load_disch_status = 'LO') THEN
                /*
                    Block start by vikas, to check if service is afs or
                    dfs then no need to check blank stowage position on
                    booked tab, k'chatgamol, 26.01.2012
                */
                IF (p_i_v_tab_flag = BOOKED_TAB) THEN
                    IF ((L_V_SERVICE IS NOT NULL) AND ((L_V_SERVICE = 'afs') OR (L_V_SERVICE = 'dfs'))) THEN
                        /*
                            Service is AFS/DFS, no need to check stowage position
                        */
                        g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO IS NOT NULL AND FK_CONTAINER_OPERATOR <> ''****'' ';
                    ELSE
                        /*
                            Service is not AFS/DFS, need to check stowage position.
                        */
                        g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO IS NOT NULL AND STOWAGE_POSITION IS NOT NULL AND FK_CONTAINER_OPERATOR <> ''****'' ';                    END IF;
                END IF;
                g_v_sql_id := 'SQL0387';
                -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
/*
                * old logic *
                g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO IS NOT NULL AND STOWAGE_POSITION IS NOT NULL AND FK_CONTAINER_OPERATOR <> ''****'' ';
*/

                /*
                    Block end by vikas, 26.12.2012
                */
            END IF;
        END IF;
      END IF;

    /* show Specific Equipment no# not updated due to blank eq# or blank stowage possion */
    g_v_sql_id := 'SQL0388';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
    -- DBMS_OUTPUT.put_line ('l_v_invalid_equipment_coc: ' ||l_v_invalid_equipment_coc);

    IF(l_v_invalid_equipment_coc IS NOT NULL) THEN
        p_o_v_error := 'EDL.SE0174' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_invalid_equipment_coc ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RAISE g_exp_finished_with_exception ;
        /* some Equipment no# not updated */
    ELSIF(l_v_error_count_coc IS NOT NULL) THEN
        p_o_v_error := 'EDL.SE0175';
        RAISE g_exp_equipment_null ;
    END IF;

    g_v_sql_id := 'SQL0389';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

    /* Validation for load list preadvice flag */
    IF (p_i_v_tab_flag = BOOKED_TAB) THEN
        g_v_sql_id := 'SQL0391';
        -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
        IF(l_v_preadvice_err_eq_no IS NOT NULL) THEN
            /* Preadvice Record not updated for equipment# */
            p_o_v_error := 'EDL.SE0183' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_preadvice_err_eq_no ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            RAISE g_exp_finished_with_exception ;
            /* Preadvice Record not updated. */
        ELSIF(l_v_preadvice_err_count IS NOT NULL) THEN
            p_o_v_error := 'EDL.SE0185';
            RAISE g_exp_equipment_null ;
        END IF;
    END IF;
    g_v_sql_id := 'SQL0392';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

    /* When screen open from booked tab */
    IF (p_i_v_tab_flag = BOOKED_TAB) THEN
        /* When screen open from discharge list booked tab then if discharge
        status is 'ROB' OR 'DISCHARGE' then check for blank eq# and stowage possion */
        IF(p_i_v_flag = DISCHARGE_LIST)  THEN
            g_v_sql_id := 'SQL0393';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

            IF ((p_i_v_load_disch_status = 'RB') OR (p_i_v_load_disch_status = 'DI')) THEN
                /* when defaulter equipment # list is not null */
                IF(l_v_invalid_equipment IS NOT NULL) THEN
                    p_o_v_error := 'EDL.SE0170' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_invalid_equipment ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                    RAISE g_exp_finished_with_exception ;
                ELSIF(l_v_error_count IS NOT NULL) THEN
                    p_o_v_error := 'EDL.SE0171';
                    RAISE g_exp_equipment_null ;
                END IF;
            END IF;

        ELSIF (p_i_v_flag = LOAD_LIST)  THEN
            g_v_sql_id := 'SQL0394';
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

            /* When screen open from load list booked tab then if loading
            status is 'ROB' OR 'LOADED' then check for blank eq# and stowage possion */
            IF ((p_i_v_load_disch_status = 'RB') OR (p_i_v_load_disch_status = 'LO')) THEN
                /* when defaulter equipment # list is not null */
                IF(l_v_invalid_equipment IS NOT NULL) THEN
                    p_o_v_error := 'EDL.SE0170' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_invalid_equipment ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
                    RAISE g_exp_finished_with_exception ;
                ELSIF(l_v_error_count IS NOT NULL) THEN
                    p_o_v_error := 'EDL.SE0171';
                    RAISE g_exp_equipment_null ;
                END IF;
            END IF;
        END IF;
    END IF;

    g_v_sql := g_v_sql || ' AND RECORD_STATUS = ''' || 'A' || ''''; -- added by vikas, 08.12.2011

    DBMS_OUTPUT.put_line (g_v_sql);

    g_v_sql_id := 'SQL0395';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

    /*Execute final update sql. */



     --*15 begin
     IF (p_i_v_tab_flag = BOOKED_TAB AND p_i_v_flag = LOAD_LIST and l_v_flage_upd_category = 'Y') THEN
        BEGIN
         select INSTR(LOWER(g_v_sql),'where')
           into l_i_instr
           from dual;
        END;

        BEGIN
         select substr(g_v_sql,l_i_instr)
          into l_v_substr
          from dual;
        END;
       -- l_v_substr := l_v_substr||' AND LOADING_STATUS = ''BK'' AND FIRST_LEG_FLAG = ''Y'' ';
    --l_v_substr := l_v_substr||' AND LOADING_STATUS = ''BK''  ';
     ---   g_v_upd_cat_sql := ' UPDATE  TOS_LL_BOOKED_LOADING SET CATEGORY_CODE = '||''''||p_i_v_category_code||''''||'  '||l_v_substr;
       -- insert into TEMP_20150424_STMT_TEST values (sysdate,'l_v_substr : '||l_v_substr,'',''); commit;
            IF(p_i_v_flag = LOAD_LIST) THEN
--                   l_v_substr := l_v_substr||' AND LOADING_STATUS = ''BK'' AND FIRST_LEG_FLAG = ''Y''  ';
                   l_v_substr := l_v_substr||' AND LOADING_STATUS = ''BK'''; -- REMOVE CHECKING 1ST LEG FLAG BY WACCHO1.
            g_v_upd_cat_sql := ' UPDATE  TOS_LL_BOOKED_LOADING SET CATEGORY_CODE = '||''''||p_i_v_category_code||''''||'  '||l_v_substr;
            END IF;

            IF(p_i_v_flag = DISCHARGE_LIST) THEN
                --   l_v_substr := l_v_substr||' AND LOADING_STATUS = ''BK''  ';
                l_v_substr := l_v_substr||' AND DISCHARG_STATUS = ''BK''  ';
            g_v_upd_cat_sql := ' UPDATE  TOS_DL_BOOKED_DISCHARGE SET CATEGORY_CODE = '||''''||p_i_v_category_code||''''||'  '||l_v_substr;
            END IF;


         EXECUTE IMMEDIATE g_v_upd_cat_sql;

            IF(SQL%ROWCOUNT = 0) THEN
                l_v_rowcount_cat := '0';
            ELSE
                l_v_rowcount_cat := TO_CHAR(SQL%ROWCOUNT);
            END IF;



     END IF;
     --* 15 end


    EXECUTE IMMEDIATE g_v_sql;

    --*15 begin



    --*15 end

    g_v_sql_id := 'SQL0396';
    -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
    l_v_rowcount := NULL;

    -- DBMS_OUTPUT.PUT_LINE('ROW COUNT:' || SQL%ROWCOUNT );

    /* Check how many records are updated.*/
    IF(SQL%ROWCOUNT = 0) THEN
        -- No Record Updated.
        p_o_v_error := 'EDL.SE0172';
        -- DBMS_OUTPUT.PUT_LINE('ZERO RECORD_UPDATE');
    ELSE
        l_v_rowcount := TO_CHAR(SQL%ROWCOUNT);
    END IF;

    /* *13 start *
    IF l_v_rowcount IS NOT NULL THEN
        p_o_v_error := 'EDL.SE0173' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_rowcount ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RAISE g_exp_finish;
    END IF;
    * *13 end */

    /*
        Check if loading status is changed then
        update loading status in discharge table.
    */

    -- DBMS_OUTPUT.put_line('p_i_v_flag: ' || p_i_v_flag);
    -- DBMS_OUTPUT.put_line('LOAD_LIST: ' || LOAD_LIST);
    -- DBMS_OUTPUT.put_line(INSTR(LOWER(g_v_sql), 'loading_status'));



    /*
        Start Added by vikas, to update loading status in booked disscharge table
        as k'chatgamol, 20.12.2011.
    */

        IF l_v_rowcount_cat <> '0' AND p_i_v_tab_flag = BOOKED_TAB THEN
              d_v_flag_upd_category := 'Y';
              
               
              
        V_SQL :='SELECT
                FK_BOOKING_NO
                , DN_EQUIPMENT_NO
                , LOADING_STATUS
                , FK_BKG_EQUIPM_DTL
                , CATEGORY_CODE
                
            FROM
                TOS_LL_BOOKED_LOADING ' ||  ' ' || l_v_substr   ; 
 
 
        OPEN dyn_cursor FOR V_SQL;
        LOOP
            FETCH dyn_cursor INTO dyn_rec;
            /*
                Loop exit when no data found condition
            */
            EXIT WHEN dyn_cursor%NOTFOUND;
            
             BEGIN
               SELECT 'EZLL'
                     , TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD'))
                     , TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI'))
               INTO  l_v_user
                   , l_v_date_1
                   , l_v_time
                FROM DUAL;
              END;

              UPDATE BKP009
               SET EQP_CATEGORY =  dyn_rec.CATEGORY_CODE,
                   BICUSR        = l_v_user ,
                   BICDAT        = l_v_date_1 ,
                   BICTIM        = l_v_time
               WHERE  BIBKNO   = dyn_rec.FK_BOOKING_NO
                       AND    BISEQN   = dyn_rec.FK_BKG_EQUIPM_DTL;            

                 
          END LOOP;      
                      
        END IF;



    PRE_UPDATE_LLDL_STATUS (
        p_i_v_flag
        , p_i_v_id
        , p_i_v_user_id -- added 30.01.2012
        /* *8 start * */
        , P_I_V_IN1
        , P_I_V_FIND1
        , P_I_V_IN2
        , P_I_V_FIND2
        , P_I_V_FLAG
        , P_I_V_TAB_FLAG
        , P_I_V_LOAD_DISCH_STATUS
        /* *8 end * */
        ,d_v_flag_upd_category --IF 'y' update EDL too.
    );

    /*
        Block start by vikas, to update status count into hader table
    */
    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
          p_i_v_id
        , p_i_v_flag
        , g_v_err_code
    );

    /*
        Block ended by vikas, 05.03.2012
    */
    /* * this body of code should be at the end of the package
         becuase after this finish exception will call
         so the code below this block will not execute
    * */


    IF l_v_rowcount IS NOT NULL THEN
        --p_o_v_error := 'EDL.SE0173' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_rowcount ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        l_v_rowcount_not_upd_cat  := TO_CHAR(TO_NUMBER(l_v_rowcount) - TO_NUMBER(l_v_rowcount_cat));

        IF NVL(l_v_flage_upd_category,'N') = 'N'  THEN

             p_o_v_error := 'EDL.SE0173' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_rowcount||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        ELSE

          IF  TO_NUMBER(l_v_rowcount_cat) = 0 THEN
           p_o_v_error := 'EDL.SE0173' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_rowcount||PCE_EUT_COMMON.G_V_ERR_CD_SEP||'EDL.SE0137'||PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_rowcount_not_upd_cat||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
          ELSE
            if   ( to_number(l_v_rowcount_cat) < to_number(l_v_rowcount)) THEN
              p_o_v_error := 'EDL.SE0173' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_rowcount||PCE_EUT_COMMON.G_V_ERR_CD_SEP||'EDL.SE0137'||PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_rowcount_not_upd_cat||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            ELSE
             p_o_v_error := 'EDL.SE0173' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_rowcount||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
            END IF;

          END IF;
        END IF;


            RAISE g_exp_finish;
    END IF;

    /*
        End added by vikas, 20.12.2011
    */


    EXCEPTION
        WHEN g_exp_finish THEN
            /* Package executed successfuly . commit all changes. */
            COMMIT;
               RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        WHEN INVALID_DATE_EXCEPTION THEN -- *13
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_equipment_null THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_finished_with_exception THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_invalid_container_op THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_invalid_slot_op THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_invalid_out_slot_op THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_invalid_equipment_type THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_invalid_pol THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_invalid_pod THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_invalid_handling_code THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN g_exp_duplicate_stowage_pos THEN
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN INVALID_NUMBER THEN
            p_o_v_error := 'ECM.GE0012'; /*Please enter a valid number*/
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        WHEN OTHERS THEN

            -- DBMS_OUTPUT.PUT_LINE ('g_v_sql_id: ' ||g_v_sql_id);
            -- DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            -- DBMS_OUTPUT.PUT_LINE ('ERROR : ' ||SQLERRM);

            /*
                Oracle databae exception occured.
            */
--            p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);  -- *5
            p_o_v_error := 'EDL.SE0188'||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||g_v_sql_id || ':' ||  SUBSTR(SQLCODE,1,10) || ':' ||
            SUBSTR(SQLERRM,1,100); -- *5
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    END PRE_EDL_BULKUPDATE;
    /* End of PRE_EDL_BULKUPDATE*/


    PROCEDURE ADDITION_WHERE_CONDTIONS(
          p_i_v_in                  IN  VARCHAR2
        , p_i_v_find                IN  VARCHAR2
        , p_i_v_flag                IN  VARCHAR2
        , p_i_v_tab_flag            IN  VARCHAR2
        , p_i_v_load_disch_status   IN  VARCHAR2
        , p_o_v_sql                 OUT VARCHAR2
    )AS

    l_v_status     varchar2(2);
    l_v_in VARCHAR(200);
    BEGIN

        /* If screen opens fromDL maintenance */
        IF (p_i_v_flag = DISCHARGE_LIST) THEN
            /* Check if screen opens from DL maintenance Overlanded TAB*/
            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                IF(p_i_v_in = 'BOOKING_NO') THEN
                  p_o_v_sql := p_o_v_sql || 'BOOKING_NO = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'BKG_TYP') THEN
                  p_o_v_sql := p_o_v_sql || 'BKG_TYP = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'CONTAINER_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQUIPMENT_NO') THEN
                  p_o_v_sql := p_o_v_sql || 'EQUIPMENT_NO = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'LOAD_CONDITION') THEN
                  p_o_v_sql := p_o_v_sql || 'LOAD_CONDITION= ''' || p_i_v_find || '''';
                END IF;

                IF(p_i_v_in = 'LOADING_STATUS') THEN
                    /* loading status is not available in overlanded tab */
                    p_o_v_sql := p_o_v_sql || '1 = 1';
                END IF;
                /*
                    Start added by vikas, to handle discharge status
                    from discharge list, as k'chatgamol, 10.01.2012
                */
                IF(p_i_v_in = 'DISCHARGE_STATUS') THEN
                    /* *14 start * */
                    PRE_GET_CONTAINER_STATUS(p_i_v_find, l_v_status);
                    /*
                    SELECT
                        DECODE(LOWER(p_i_v_find),
                        'booked','BK'
                        , 'loaded', 'LO'
                        , 'discharged', 'DI'
                        , 'rob', 'RB'
                        , 'short landed', 'SL'
                        , 'short shipped', 'SS'
             --            ,p_i_v_find -- *10
                        )
                    INTO
                        l_v_status
                    FROM
                        DUAL;
                    */
                    /* *14 end * */
                    p_o_v_sql := p_o_v_sql || 'DISCHARGE_STATUS= ''' || l_v_status || '''';
                END IF;
                /*
                    End Added by vikas, 10.01.2012
                */

                IF(p_i_v_in = 'LOCAL_STATUS') THEN
                  p_o_v_sql := p_o_v_sql || 'LOCAL_STATUS = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_VESSEL') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_VESSEL= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_VOYAGE') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_VOYAGE= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_POD1') THEN
                  p_o_v_sql := p_o_v_sql || 'NXT_POD1= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_SRV') THEN
                  p_o_v_sql := p_o_v_sql || 'NXT_SRV= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_VESSEL') THEN
                  p_o_v_sql := p_o_v_sql || 'NXT_VESSEL = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_VOYAGE') THEN
                  p_o_v_sql := p_o_v_sql || 'NXT_VOYAGE= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD1') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD1 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD2') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD2 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD3') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD3 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'POL') THEN
                  p_o_v_sql := p_o_v_sql || 'POL = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SHIPMENT_TYP') THEN
                  p_o_v_sql := p_o_v_sql || 'SHIPMENT_TYP = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQ_SIZE') THEN
                  p_o_v_sql := p_o_v_sql || 'EQ_SIZE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SLOT_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'SLOT_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'FLAG_SOC_COC') THEN
                  p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SPECIAL_HANDLING') THEN
                  p_o_v_sql := p_o_v_sql || 'SPECIAL_HANDLING = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQ_TYPE') THEN
                  p_o_v_sql := p_o_v_sql || 'EQ_TYPE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'L3EQPNUM') THEN
                  l_v_in := '%' || p_i_v_find;
                  p_o_v_sql := p_o_v_sql || 'EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
                END IF;
                --  when BB Cargo is selectd
                IF(p_i_v_in = 'BBCARGO') THEN
                p_o_v_sql := p_o_v_sql || 'SHIPMENT_TERM = ''BBK''' ;
                END IF;
                --  when COC Customer is selectd
                IF(p_i_v_in = 'COCCUST') THEN
                p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''N''' ;
                END IF;
                --  when COC Empty is selectd
                IF(p_i_v_in = 'COCEMPTY') THEN
                p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''ER''' ;
                END IF;
                --  when COC Transshipped is selectd
                IF(p_i_v_in = 'COCTRANS') THEN
                   p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
                END IF;
                --  when DG Cargo is selectd
                IF(p_i_v_in = 'DGCARGO') THEN
                  -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                  p_o_v_sql := p_o_v_sql || '(SPECIAL_HANDLING = ''DG'' OR UN_NUMBER IS NOT NULL  OR UN_NUMBER_VARIANT IS NOT NULL OR FLASHPOINT_UNIT IS NOT NULL OR FLASHPOINT IS NOT NULL)' ; -- IMO class NOT FOUND.
                END IF;
                --  when OOG Cargo is selectd
                IF(p_i_v_in = 'OOGCARGO') THEN
                  -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                  p_o_v_sql := p_o_v_sql || '(SPECIAL_HANDLING = ''OOG''OR OVERHEIGHT_CM IS NOT NULL  OR OVERLENGTH_FRONT_CM IS NOT NULL OR OVERWIDTH_RIGHT_CM IS NOT NULL OR OVERWIDTH_LEFT_CM IS NOT NULL)' ; -- Over Length in Back  NOT FOUND.
                END IF;
                --  when Reefer Cargo is selectd
                IF(p_i_v_in = 'REEFERCARGO') THEN
                  -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
                p_o_v_sql := p_o_v_sql || '(SPECIAL_HANDLING != ''NOR''OR REEFER_TEMPERATURE IS NOT NULL  OR REEFER_TMP_UNIT IS NOT NULL OR HUMIDITY IS NOT NULL OR VENTILATION IS NOT NULL)' ;
                END IF;
                --  when SOC all is selectd
                IF(p_i_v_in = 'SOCALL') THEN
                p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''S''' ;
                END IF;
                --  when SOC is selectd
                IF(p_i_v_in = 'SOCDIRECT') THEN
                p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''N''' ;
                END IF;
                --  when SOC Partner is selectd
                IF(p_i_v_in = 'SOCPARTNER') THEN
                p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''FC''' ;
                END IF;
                --  when SOC transshipped is selectd
                IF(p_i_v_in = 'SOCTRANS') THEN
                  p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
                END IF;
                --  when transshipped is selectd
                IF(p_i_v_in = 'TRANSSHPD') THEN
                  p_o_v_sql := p_o_v_sql || 'LOCAL_STATUS = ''T''';
                END IF;
            END IF;

            /* Check if screen opens from DL maintenance Booked TAB*/
            IF(p_i_v_tab_flag = BOOKED_TAB) THEN
                IF(p_i_v_in = 'BOOKING_NO') THEN
                  p_o_v_sql := p_o_v_sql || 'FK_BOOKING_NO = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'FLAG_SOC_COC') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_SOC_COC = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'BKG_TYP') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_BKG_TYP = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'CONTAINER_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'FK_CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQUIPMENT_NO') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_EQUIPMENT_NO = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'LOAD_CONDITION') THEN
                  p_o_v_sql := p_o_v_sql || 'LOAD_CONDITION= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'LOADING_STATUS') THEN
                    /* *14 start * */
                    /*
                        Start added by vikas, 16.12.2011
                    */
                    PRE_GET_CONTAINER_STATUS(p_i_v_find, l_v_status);
                    /*
                    SELECT
                        DECODE(LOWER(p_i_v_find),
                        'booked','BK'
                        , 'loaded', 'LO'
                        , 'discharged', 'DI'
                        , 'rob', 'RB'
                        , 'short landed', 'SL'
                        , 'short shipped', 'SS'
                        -- ,p_i_v_find -- *10
                        )
                    INTO
                        l_v_status
                    FROM
                        DUAL;
                    */
                    /*
                        End added by vikas, 16.12.2011
                    */
                    /* *14 end * */

                    p_o_v_sql := p_o_v_sql || 'DN_LOADING_STATUS= ''' || l_v_status || '''';
                END IF;
                /*
                    Start added by vikas, to handle discharge status
                    from discharge list, as k'chatgamol, 10.01.2012
                */
                IF(p_i_v_in = 'DISCHARGE_STATUS') THEN
                    /* *14 start * */
                    PRE_GET_CONTAINER_STATUS(p_i_v_find, l_v_status);

                    /*
                    SELECT
                        DECODE(LOWER(p_i_v_find),
                        'booked','BK'
                        , 'loaded', 'LO'
                        , 'discharged', 'DI'
                        , 'short shipped', 'SS'
                        , 'rob', 'RB'
                        , 'short landed', 'SL'
                        -- ,p_i_v_find -- *10
                        )
                    INTO
                        l_v_status
                    FROM
                        DUAL;
                    */
                    /* *14 end * */

                    p_o_v_sql := p_o_v_sql || 'DISCHARGE_STATUS= ''' || l_v_status || '''';
                END IF;
                /*
                    End Added by vikas, 10.01.2012
                */

                IF(p_i_v_in = 'LOCAL_STATUS') THEN
                  p_o_v_sql := p_o_v_sql || 'LOCAL_STATUS = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_VESSEL') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_VESSEL= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_VOYAGE') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_VOYAGE= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_POD1') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_NXT_POD1= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_SRV') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_NXT_SRV= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_VESSEL') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_NXT_VESSEL = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_VOYAGE') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_NXT_VOYAGE= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD1') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD1 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD2') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD2 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD3') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD3 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'POL') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_POL = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SHIPMENT_TYP') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_SHIPMENT_TYP = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQ_SIZE') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_EQ_SIZE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SLOT_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'FK_SLOT_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SPECIAL_HANDLING') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_SPECIAL_HNDL = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQ_TYPE') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_EQ_TYPE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'L3EQPNUM') THEN
                  l_v_in := '%' || p_i_v_find;
                  p_o_v_sql := p_o_v_sql || 'DN_EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
                END IF;
                --  when BB Cargo is selectd
                IF(p_i_v_in = 'BBCARGO') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SHIPMENT_TERM = ''BBK''' ;
                END IF;
                --  when COC Customer is selectd
                IF(p_i_v_in = 'COCCUST') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''N''' ;
                END IF;
                --  when COC Empty is selectd
                IF(p_i_v_in = 'COCEMPTY') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''ER''' ;
                END IF;
                --  when COC Transshipped is selectd
                IF(p_i_v_in = 'COCTRANS') THEN
                   p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
                END IF;
                --  when DG Cargo is selectd
                IF(p_i_v_in = 'DGCARGO') THEN
                  -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                  p_o_v_sql := p_o_v_sql || '(DN_SPECIAL_HNDL = ''DG'' OR FK_UNNO IS NOT NULL  OR FK_UN_VAR IS NOT NULL OR FLASH_UNIT IS NOT NULL OR FLASH_POINT IS NOT NULL)' ; -- IMO class NOT FOUND.
                END IF;
                --  when OOG Cargo is selectd
                IF(p_i_v_in = 'OOGCARGO') THEN
                  -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                  p_o_v_sql := p_o_v_sql || '(DN_SPECIAL_HNDL = ''OOG''OR OVERHEIGHT_CM IS NOT NULL  OR OVERLENGTH_FRONT_CM IS NOT NULL OR OVERWIDTH_RIGHT_CM IS NOT NULL OR OVERWIDTH_LEFT_CM IS NOT NULL)' ; -- Over Length in Back  NOT FOUND.
                END IF;
                --  when Reefer Cargo is selectd
                IF(p_i_v_in = 'REEFERCARGO') THEN
                  -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
                p_o_v_sql := p_o_v_sql || '(DN_SPECIAL_HNDL != ''NOR''OR REEFER_TEMPERATURE IS NOT NULL  OR REEFER_TMP_UNIT IS NOT NULL OR DN_HUMIDITY IS NOT NULL OR DN_VENTILATION IS NOT NULL)' ;
                END IF;
                --  when SOC all is selectd
                IF(p_i_v_in = 'SOCALL') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''S''' ;
                END IF;
                --  when SOC is selectd
                IF(p_i_v_in = 'SOCDIRECT') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''N''' ;
                END IF;
                --  when SOC Partner is selectd
                IF(p_i_v_in = 'SOCPARTNER') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''FC''' ;
                END IF;
                --  when SOC transshipped is selectd
                IF(p_i_v_in = 'SOCTRANS') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
                END IF;
                --  when transshipped is selectd
                IF(p_i_v_in = 'TRANSSHPD') THEN
                  p_o_v_sql := p_o_v_sql || 'LOCAL_STATUS = ''T''';
                END IF;
            END IF;
        END IF;

        /* Screen open from LL Maintenance */
        IF (p_i_v_flag = LOAD_LIST) THEN
            /* Check if screen opens from LL maintenance Booked TAB*/
            IF(p_i_v_tab_flag = BOOKED_TAB) THEN
                IF(p_i_v_in = 'BOOKING_NO') THEN
                  p_o_v_sql := p_o_v_sql || 'FK_BOOKING_NO = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'FLAG_SOC_COC') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_SOC_COC = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'BKG_TYP') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_BKG_TYP = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'CONTAINER_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'FK_CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQUIPMENT_NO') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_EQUIPMENT_NO = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'LOAD_CONDITION') THEN
                  p_o_v_sql := p_o_v_sql || 'LOAD_CONDITION= ''' || p_i_v_find || '''';
                END IF;

                /*
                    Start added by vikas, to handle discharge status
                    from overlanded container, 10.01.2012
                */
                IF(p_i_v_in = 'DISCHARGE_STATUS') THEN
                    /* discharge status is not available in overlanded tab */
                    p_o_v_sql := p_o_v_sql || '1 = 1';
                END IF;
                /*
                    End added by vikas, 10.01.2012
                */

                IF(p_i_v_in = 'LOADING_STATUS') THEN

                    /* *14 start * */
                    PRE_GET_CONTAINER_STATUS(p_i_v_find, l_v_status);

                    /*
                        Start added by vikas, 16.12.2011
                    */
                    /*
                    SELECT
                        DECODE(LOWER(p_i_v_find),
                        'booked','BK'
                        , 'loaded', 'LO'
                        , 'discharged', 'DI'
                        , 'short shipped', 'SS'
                        , 'rob', 'RB'
                        , 'short landed', 'SL'
                        -- , p_i_v_find -- *10
                        )
                    INTO
                        l_v_status
                    FROM
                        DUAL;
                    */
                    /*
                        End added by vikas, 16.12.2011
                    */
                    /* *14 end * */

                    p_o_v_sql := p_o_v_sql || 'LOADING_STATUS= ''' || l_v_status || '''';
                END IF;
                IF(p_i_v_in = 'LOCAL_STATUS') THEN
                  p_o_v_sql := p_o_v_sql || 'LOCAL_STATUS = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_VESSEL') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_VESSEL= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_VOYAGE') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_VOYAGE= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_POD1') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_NXT_POD1= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_SRV') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_NXT_SRV= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_VESSEL') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_NXT_VESSEL = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_VOYAGE') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_NXT_VOYAGE= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD1') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD1 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD2') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD2 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD3') THEN
                  p_o_v_sql := p_o_v_sql || 'MLO_POD3 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                /* *9 start */
                /*
                IF(p_i_v_in = 'POL') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_DISCHARGE_PORT = ''' || p_i_v_find || '''';
                END IF;
                */
                IF(p_i_v_in = 'POD') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_DISCHARGE_PORT = ''' || p_i_v_find || '''';
                END IF;
                /* *9 end * */
                IF(p_i_v_in = 'SHIPMENT_TYP') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_SHIPMENT_TYP = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQ_SIZE') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_EQ_SIZE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SLOT_OPERATOR') THEN
                  p_o_v_sql := p_o_v_sql || 'FK_SLOT_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SPECIAL_HANDLING') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_SPECIAL_HNDL = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQ_TYPE') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_EQ_TYPE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'L3EQPNUM') THEN
                  l_v_in := '%' || p_i_v_find;
                  p_o_v_sql := p_o_v_sql || 'DN_EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
                END IF;
                --  when BB Cargo is selectd
                IF(p_i_v_in = 'BBCARGO') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SHIPMENT_TERM = ''BBK''' ;
                END IF;
                --  when COC Customer is selectd
                IF(p_i_v_in = 'COCCUST') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''N''' ;
                END IF;
                --  when COC Empty is selectd
                IF(p_i_v_in = 'COCEMPTY') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''ER''' ;
                END IF;
                --  when COC Transshipped is selectd
                IF(p_i_v_in = 'COCTRANS') THEN
                   p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
                END IF;
                --  when DG Cargo is selectd
                IF(p_i_v_in = 'DGCARGO') THEN
                  -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                  p_o_v_sql := p_o_v_sql || '(DN_SPECIAL_HNDL = ''DG'' OR FK_UNNO IS NOT NULL  OR FK_UN_VAR IS NOT NULL OR FLASH_UNIT IS NOT NULL OR FLASH_POINT IS NOT NULL)' ; -- IMO class NOT FOUND.
                END IF;
                --  when OOG Cargo is selectd
                IF(p_i_v_in = 'OOGCARGO') THEN
                  -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                  p_o_v_sql := p_o_v_sql || '(DN_SPECIAL_HNDL = ''OOG''OR OVERHEIGHT_CM IS NOT NULL  OR OVERLENGTH_FRONT_CM IS NOT NULL OR OVERWIDTH_RIGHT_CM IS NOT NULL OR OVERWIDTH_LEFT_CM IS NOT NULL)' ; -- Over Length in Back  NOT FOUND.
                END IF;
                --  when Reefer Cargo is selectd
                IF(p_i_v_in = 'REEFERCARGO') THEN
                  -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
                p_o_v_sql := p_o_v_sql || '(DN_SPECIAL_HNDL != ''NOR''OR REEFER_TMP IS NOT NULL  OR REEFER_TMP_UNIT IS NOT NULL OR DN_HUMIDITY IS NOT NULL OR DN_VENTILATION IS NOT NULL)' ;
                END IF;
                --  when SOC all is selectd
                IF(p_i_v_in = 'SOCALL') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''S''' ;
                END IF;
                --  when SOC is selectd
                IF(p_i_v_in = 'SOCDIRECT') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''N''' ;
                END IF;
                --  when SOC Partner is selectd
                IF(p_i_v_in = 'SOCPARTNER') THEN
                p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''FC''' ;
                END IF;
                --  when SOC transshipped is selectd
                IF(p_i_v_in = 'SOCTRANS') THEN
                  p_o_v_sql := p_o_v_sql || 'DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
                END IF;
                --  when transshipped is selectd
                IF(p_i_v_in = 'TRANSSHPD') THEN
                  p_o_v_sql := p_o_v_sql || 'LOCAL_STATUS = ''T''';
                END IF;
            END IF;

            /* Check if screen opens from LL maintenance Overshipped TAB*/
            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                IF(p_i_v_in = 'BOOKING_NO') THEN
                    p_o_v_sql := p_o_v_sql || 'BOOKING_NO = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'BKG_TYP') THEN
                    p_o_v_sql := p_o_v_sql || 'BKG_TYP = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'CONTAINER_OPERATOR') THEN
                    p_o_v_sql := p_o_v_sql || 'CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQUIPMENT_NO') THEN
                    p_o_v_sql := p_o_v_sql || 'EQUIPMENT_NO = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'LOAD_CONDITION') THEN
                    p_o_v_sql := p_o_v_sql || 'LOAD_CONDITION= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'LOADING_STATUS') THEN
                    p_o_v_sql := p_o_v_sql || '1 = 1';
                END IF;
                IF(p_i_v_in = 'LOCAL_STATUS') THEN
                    p_o_v_sql := p_o_v_sql || 'LOCAL_STATUS = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_VESSEL') THEN
                    p_o_v_sql := p_o_v_sql || 'MLO_VESSEL= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_VOYAGE') THEN
                    p_o_v_sql := p_o_v_sql || 'MLO_VOYAGE= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_POD1') THEN
                    p_o_v_sql := p_o_v_sql || 'NXT_POD1= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_SRV') THEN
                    p_o_v_sql := p_o_v_sql || 'NXT_SRV= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_VESSEL') THEN
                    p_o_v_sql := p_o_v_sql || 'NXT_VESSEL = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'NXT_VOYAGE') THEN
                    p_o_v_sql := p_o_v_sql || 'NXT_VOYAGE= ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD1') THEN
                    p_o_v_sql := p_o_v_sql || 'MLO_POD1 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD2') THEN
                    p_o_v_sql := p_o_v_sql || 'MLO_POD2 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'MLO_POD3') THEN
                    p_o_v_sql := p_o_v_sql || 'MLO_POD3 = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                    p_o_v_sql := p_o_v_sql || 'OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                /* *9 start * */
                /*
                IF(p_i_v_in = 'POL') THEN
                    p_o_v_sql := p_o_v_sql || 'POD_TERMINAL = ''' || p_i_v_find || '''';
                END IF;
                */
                IF(p_i_v_in = 'POD') THEN
                    p_o_v_sql := p_o_v_sql || 'DISCHARGE_PORT = ''' || p_i_v_find || '''';
                END IF;
                /* *9 end * */
                IF(p_i_v_in = 'SHIPMENT_TYP') THEN
                    p_o_v_sql := p_o_v_sql || 'SHIPMENT_TYPE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQ_SIZE') THEN
                    p_o_v_sql := p_o_v_sql || 'EQ_SIZE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SLOT_OPERATOR') THEN
                    p_o_v_sql := p_o_v_sql || 'SLOT_OPERATOR = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'FLAG_SOC_COC') THEN
                    p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'SPECIAL_HANDLING') THEN
                    p_o_v_sql := p_o_v_sql || 'SPECIAL_HANDLING = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'EQ_TYPE') THEN
                    p_o_v_sql := p_o_v_sql || 'EQ_TYPE = ''' || p_i_v_find || '''';
                END IF;
                IF(p_i_v_in = 'L3EQPNUM') THEN
                    l_v_in := '%' || p_i_v_find;
                    p_o_v_sql := p_o_v_sql || 'EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
                END IF;
                --  when BB Cargo is selectd
                IF(p_i_v_in = 'BBCARGO') THEN
                    p_o_v_sql := p_o_v_sql || 'SHIPMENT_TERM = ''BBK''' ;
                END IF;
                --  when COC Customer is selectd
                IF(p_i_v_in = 'COCCUST') THEN
                    p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''N''' ;
                END IF;
                --  when COC Empty is selectd
                IF(p_i_v_in = 'COCEMPTY') THEN
                    p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''ER''' ;
                END IF;
                --  when COC Transshipped is selectd
                IF(p_i_v_in = 'COCTRANS') THEN
                    p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
                END IF;
                --  when DG Cargo is selectd
                IF(p_i_v_in = 'DGCARGO') THEN
                -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                    p_o_v_sql := p_o_v_sql || '(SPECIAL_HANDLING = ''DG'' OR UN_NUMBER IS NOT NULL  OR UN_NUMBER_VARIANT IS NOT NULL OR FLASHPOINT_UNIT IS NOT NULL OR FLASHPOINT IS NOT NULL)' ; -- IMO class NOT FOUND.
                END IF;
                --  when OOG Cargo is selectd
                IF(p_i_v_in = 'OOGCARGO') THEN
                -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                    p_o_v_sql := p_o_v_sql || '(SPECIAL_HANDLING = ''OOG''OR OVERHEIGHT_CM IS NOT NULL  OR OVERLENGTH_FRONT_CM IS NOT NULL OR OVERWIDTH_RIGHT_CM IS NOT NULL OR OVERWIDTH_LEFT_CM IS NOT NULL)' ; -- Over Length in Back  NOT FOUND.
                END IF;
                --  when Reefer Cargo is selectd
                IF(p_i_v_in = 'REEFERCARGO') THEN
                -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
                    p_o_v_sql := p_o_v_sql || '(SPECIAL_HANDLING != ''NOR''OR REEFER_TEMPERATURE IS NOT NULL  OR REEFER_TMP_UNIT IS NOT NULL OR HUMIDITY IS NOT NULL OR VENTILATION IS NOT NULL)' ;
                END IF;
                --  when SOC all is selectd
                IF(p_i_v_in = 'SOCALL') THEN
                    p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''S''' ;
                END IF;
                --  when SOC is selectd
                IF(p_i_v_in = 'SOCDIRECT') THEN
                    p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''N''' ;
                END IF;
                --  when SOC Partner is selectd
                IF(p_i_v_in = 'SOCPARTNER') THEN
                    p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''FC''' ;
                END IF;
                --  when SOC transshipped is selectd
                IF(p_i_v_in = 'SOCTRANS') THEN
                    p_o_v_sql := p_o_v_sql || 'FLAG_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
                END IF;
                --  when transshipped is selectd
                IF(p_i_v_in = 'TRANSSHPD') THEN
                    p_o_v_sql := p_o_v_sql || 'LOCAL_STATUS = ''T''';
                END IF;
            END IF;
        END IF;

    END ADDITION_WHERE_CONDTIONS;


    /* Create addition where condition for in1 and in2 */
    PROCEDURE GET_WHERE_COND_FOR_VALID(
          p_i_v_in1                     IN  VARCHAR2
        , p_i_v_find1                   IN  VARCHAR2
        , p_i_v_in2                     IN  VARCHAR2
        , p_i_v_find2                   IN  VARCHAR2
        , p_i_v_id                      IN  VARCHAR2
        , p_i_v_containerFlag           IN  VARCHAR2
        , p_i_v_flag                    IN  VARCHAR2
        , p_i_v_tab_flag                IN  VARCHAR2
        , p_i_v_validate_soc            IN  VARCHAR2
    )AS
        l_v_sql                     VARCHAR2(5000);
        len                         number;
        l_v_service                  VASAPPS.TOS_DL_DISCHARGE_LIST.FK_SERVICE%TYPE;
    BEGIN
        /* Create where condition for in1 */
        IF(p_i_v_in1 IS NOT NULL) THEN
            ADDITION_WHERE_CONDTIONS (p_i_v_in1, p_i_v_find1, p_i_v_flag, p_i_v_tab_flag, p_i_v_flag, l_v_sql);
            g_v_validation_sql := g_v_validation_sql || l_v_sql;
        END IF;
        /* Create where condition for in2 */
        IF ( (p_i_v_in2 IS NOT NULL) and (p_i_v_in1 IS NOT NULL) ) THEN
            g_v_validation_sql := g_v_validation_sql ||' AND ';
            ADDITION_WHERE_CONDTIONS (p_i_v_in2, p_i_v_find2, p_i_v_flag, p_i_v_tab_flag, p_i_v_flag, l_v_sql);
            g_v_validation_sql := g_v_validation_sql || l_v_sql;
        ELSE
            ADDITION_WHERE_CONDTIONS (p_i_v_in2, p_i_v_find2, p_i_v_flag,p_i_v_tab_flag, p_i_v_flag, l_v_sql);
            g_v_validation_sql := g_v_validation_sql || l_v_sql;
        END IF;

        IF ( (p_i_v_in2 IS NOT NULL) or (p_i_v_in1 IS NOT NULL) ) THEN
          g_v_validation_sql := g_v_validation_sql ||' AND ';
        END IF;

        IF (p_i_v_flag = DISCHARGE_LIST) THEN
            g_v_validation_sql := g_v_validation_sql || ' FK_DISCHARGE_LIST_ID = ''' || p_i_v_id || '''';
        ELSIF (p_i_v_flag = LOAD_LIST) THEN
            g_v_validation_sql := g_v_validation_sql || ' FK_LOAD_LIST_ID = ''' || p_i_v_id || '''';
        END IF;

        /* Check for soc - coc flage for container operator */
        IF(p_i_v_validate_soc = 'true') THEN
            /* When p_i_v_containerFlag is false means container operator is not available in master table.*/
            IF ((p_i_v_in1 IS NOT NULL) OR (p_i_v_in2 IS NOT NULL))  THEN
                g_v_validation_sql := g_v_validation_sql || ' AND ';
            END IF;

            /* soc-coc fields are same for discharge list and load list. */
                IF (p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                    g_v_validation_sql := g_v_validation_sql || ' FLAG_SOC_COC = ''C'' ';
                ELSIF (p_i_v_tab_flag = BOOKED_TAB) THEN
                    g_v_validation_sql := g_v_validation_sql || ' DN_SOC_COC = ''C'' ';
                END IF;
        ELSE
            /* When p_i_v_validate_soc is false for validation
            blank equipment#, blank Stowage_possion and container operator. */
            IF ((p_i_v_in1 IS NOT NULL) OR (p_i_v_in2 IS NOT NULL))  THEN
              g_v_validation_sql := g_v_validation_sql || ' AND ';
            END IF;

            /* Check that Container should not be **** and
               equipment # should not be null and stowage possion should not be null */
            IF (p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                g_v_validation_sql := g_v_validation_sql || ' (EQUIPMENT_NO IS NULL OR STOWAGE_POSITION IS NULL OR CONTAINER_OPERATOR = ''****'' ) ';
            ELSIF (p_i_v_tab_flag = BOOKED_TAB) THEN
                /*
                    Block start by vikas, to check if service is afs or
                    dfs then no need to check blank stowage position on
                    booked tab, k'chatgamol, 26.01.2012

                    Need to check if service is afs or dfs then no need to check blank stowage position
                */
                BEGIN
                    l_v_service := NULL;

                    SELECT
                        FK_SERVICE
                    INTO
                        l_v_service
                    FROM (
                        SELECT
                            FK_SERVICE
                        FROM
                            TOS_DL_DISCHARGE_LIST
                        WHERE
                            PK_DISCHARGE_LIST_ID = p_i_v_id
                            AND p_i_v_flag      = DISCHARGE_LIST

                        UNION ALL

                        SELECT
                            FK_SERVICE
                        FROM
                            TOS_LL_LOAD_LIST
                        WHERE
                            PK_LOAD_LIST_ID = p_i_v_id
                            AND p_i_v_flag      = LOAD_LIST
                    );

                        -- DBMS_OUTPUT.PUT_LINE('L_V_SERVICE: ' || L_V_SERVICE );
                    L_V_SERVICE := LOWER(L_V_SERVICE);
                EXCEPTION
                    WHEN OTHERS THEN
                      -- DBMS_OUTPUT.PUT_LINE(SQLERRM);
                        l_v_service := NULL;
                END ;


                -- DBMS_OUTPUT.put_line('L_V_SERVICE: ' || L_V_SERVICE);
                IF ((L_V_SERVICE IS NOT NULL) AND ((L_V_SERVICE = 'afs') OR (L_V_SERVICE = 'dfs'))) THEN
                  -- DBMS_OUTPUT.PUT_LINE('L_V_SERVICE: ' || L_V_SERVICE);
                  -- DBMS_OUTPUT.PUT_LINE('Service is AFS/DFS');

                    /*
                        Service is AFS/DFS, no need to check stowage position
                    */
                    g_v_validation_sql := g_v_validation_sql || ' (DN_EQUIPMENT_NO IS NULL OR FK_CONTAINER_OPERATOR = ''****'' ) ';
                ELSE
                    /*
                        Service is not AFS/DFS, need to check stowage position.
                    */
                  -- DBMS_OUTPUT.PUT_LINE('Service is not AFS/DFS: '||P_I_V_ID||'~'|| p_i_v_flag||'~'|| DISCHARGE_LIST||'~'|| LOAD_LIST);
                g_v_validation_sql := g_v_validation_sql || ' (DN_EQUIPMENT_NO IS NULL OR STOWAGE_POSITION IS NULL OR FK_CONTAINER_OPERATOR = ''****'' ) ';
                END IF;
/*
    *old logic*
                g_v_validation_sql := g_v_validation_sql || ' (DN_EQUIPMENT_NO IS NULL OR STOWAGE_POSITION IS NULL OR FK_CONTAINER_OPERATOR = ''****'' ) ';
*/
/*
    Block end by vikas, 26.01.2012
*/
            END IF;

            /* FOR PREADVICE */
           len := instr(g_v_validation_sql, 'WHERE');
           g_v_where_cond := SUBSTR( g_v_validation_sql, len, length(g_v_validation_sql) );

          -- DBMS_OUTPUT.put_line ('g_v_where_cond: ' || g_v_where_cond);
        END IF;
    END;

    PROCEDURE GET_INVALID_RECORDS(
          p_i_v_flag                    VARCHAR2
        , p_i_v_tab_flag                VARCHAR2
        , p_o_v_error_count             OUT VARCHAR2
        , p_o_v_equipment_no            OUT VARCHAR2
        , p_o_v_preadvice_err_count     OUT VARCHAR2
        , p_o_v_preadvice_err_eq_no     OUT VARCHAR2
        , p_o_v_error                   OUT VARCHAR2
    )
    AS
        l_v_sql                         VARCHAR2(4000);
    BEGIN
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /*
            Start added by vikas, to update only active records, 23.12.2011
        */
        g_v_validation_sql := g_v_validation_sql || 'AND RECORD_STATUS = ''A''' ;
        /*
            End added by vikas, 23.12.2011
        */

        -- DBMS_OUTPUT.put_line('PREV_g_v_validation_sql: ' || g_v_validation_soc_sql);

        g_v_validation_sql    := g_v_validation_sql    || ' )
            START WITH ID = 1
            CONNECT BY PRIOR ID = ID - 1)
            WHERE r = 1';


            -- DBMS_OUTPUT.put_line('AFTER_g_v_validation_sql: ' || g_v_validation_sql);
        BEGIN
            EXECUTE IMMEDIATE g_v_validation_sql INTO p_o_v_equipment_no;
            /* Set error count to one  when g_v_validation_sql give any record */
            p_o_v_error_count := 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_equipment_no := NULL;
                p_o_v_error_count  := NULL;
            WHEN OTHERS THEN
                NULL;
                ---- DBMS_OUTPUT.put_line('ERROR: ' || SQLERRM);

        END;

        /* When screen open from load list then where preadvice flag
            is set to 'Y' then stowage possion should not be null; */
        IF ( (p_i_v_flag = LOAD_LIST) ) THEN
                IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                    l_v_sql := 'SELECT EQUIPMENT_NO FROM TOS_LL_OVERSHIPPED_CONTAINER '
                                          || g_v_where_cond
                                          || ' AND PREADVICE_FLAG=''Y'' AND RECORD_STATUS = ''A'' ' ; -- modified, 23.12.2011
                ELSE
                    l_v_sql := 'SELECT DN_EQUIPMENT_NO FROM TOS_LL_BOOKED_LOADING '
                                          || g_v_where_cond
                                          || ' AND PREADVICE_FLAG=''Y'' AND RECORD_STATUS = ''A'' ' ; -- modified, 23.12.2011
                END IF;

            BEGIN
                -- DBMS_OUTPUT.PUT_LINE('1.l_v_sql: ' || l_v_sql);
                EXECUTE IMMEDIATE l_v_sql INTO p_o_v_preadvice_err_eq_no;
                /* Set error count to one  when l_v_sql give any record */
                p_o_v_preadvice_err_count := 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_o_v_preadvice_err_count := NULL;
                    p_o_v_preadvice_err_eq_no := NULL;

                WHEN OTHERS THEN
                    p_o_v_error := SQLCODE;
            END;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            PRE_LOG_INFO(
                  'PCE_EDL_BULKUPDATE.PRE_EDL_BULKUPDATE'
                , 'BU'
                , g_v_sql_id
                , 'EZLL'
                , SYSDATE
                , SUBSTR(l_v_parameter_str, 1, 999)
                , NULL
                , NULL
                , NULL
            );
            p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
    END GET_INVALID_RECORDS;


/*
    Start added by vikas, to updated loading status in
    booked loading table, as k'chatgamol, 20.12.2011
*/

    PROCEDURE PRE_UPDATE_LLDL_STATUS (
        p_i_v_ll_dl_flag              VARCHAR2
        , p_i_v_id                    VARCHAR2
        , p_i_v_user_id               VARCHAR2 -- added 30.01.2012
        /* *8 start* */
        , P_I_V_IN1                   VARCHAR2
        , P_I_V_FIND1                 VARCHAR2
        , P_I_V_IN2                   VARCHAR2
        , P_I_V_FIND2                 VARCHAR2
        , P_I_V_FLAG                  VARCHAR2
        , P_I_V_TAB_FLAG              VARCHAR2
        , P_I_V_LOAD_DISCH_STATUS     VARCHAR2
        /* *8 end * */
         , P_I_V_CATEGORY_FLAG VARCHAR --*15
    )
    AS
        LOAD                     VARCHAR2(1) := 'L';
        l_n_pos_var              NUMBER := 0; -- added 19.12.2011
        l_v_sql                  VARCHAR2(4000); /* *8 * */
     BEGIN



        l_n_pos_var := INSTR(LOWER(g_v_sql), 'where');

        /*
            Check which logic need to call
        */
        dbms_output.put_line('g_v_sql ~'||g_v_sql);
        /* Call only when loading status is changed to loaded */
        --IF  ( INSTR(LOWER(g_v_sql), 'loading_status') > 0 ) *15
      --  insert into TEMP_20150424_STMT_TESt values (sysdate,'P_I_V_CATEGORY_FLAG : '||P_I_V_CATEGORY_FLAG,'','g_v_sql : '||g_v_sql); commit;
        IF  ( INSTR(LOWER(g_v_sql), 'loading_status') > 0 ) THEN          
        
        /*-- REMOVE BY WACCHO1 ON 07/08/2016 BACK TO ORIGINAL 
          IF  ( (INSTR(LOWER(g_v_sql), 'loading_status') > 0)  AND P_I_V_CATEGORY_FLAG = 'N' ) --not update category
            --AND p_i_v_ll_dl_flag = LOAD 
            THEN --*/
            /* *8 start * */
            /* get updated where condition from the loading status * */
            SELECT
                SUBSTR(G_V_SQL, L_N_POS_VAR)
            INTO
                L_V_SQL
            FROM
                DUAL;

            PRE_GET_UPDATED_WHERE_COND(
                  P_I_V_IN1
                , P_I_V_FIND1
                , P_I_V_IN2
                , P_I_V_FIND2
                , P_I_V_FLAG
                , P_I_V_TAB_FLAG
                , P_I_V_LOAD_DISCH_STATUS
                , L_V_SQL
            );

            /* *8 end  * */

            /*
                call from load list
            */
            dbms_output.put_line('calling PRE_UPDATE_LL_STATUS ~'||substr(g_v_sql, l_n_pos_var));
            PRE_UPDATE_LL_STATUS (
                p_i_v_id
                -- , SUBSTR(G_V_SQL, L_N_POS_VAR) /* *8 * */
                , L_V_SQL /* *8 * */
                , p_i_v_user_id -- added 30.01.2012
                , 'N'
            );
                    /*-- REMOVE BY WACCHO1 ON 07/08/2016 BACK TO ORIGINAL 
          ELSIF  (INSTR(LOWER(g_v_sql), 'loading_status') > 0)  AND P_I_V_CATEGORY_FLAG = 'Y' THEN --Update Category and the others.
              SELECT
                  SUBSTR(G_V_SQL, L_N_POS_VAR)
              INTO
                  L_V_SQL
              FROM
                  DUAL;
  
              PRE_GET_UPDATED_WHERE_COND(
                    P_I_V_IN1
                  , P_I_V_FIND1
                  , P_I_V_IN2
                  , P_I_V_FIND2
                  , P_I_V_FLAG
                  , P_I_V_TAB_FLAG
                  , P_I_V_LOAD_DISCH_STATUS
                  , L_V_SQL
              );             
               PRE_UPDATE_LL_STATUS (
                  p_i_v_id
                  -- , SUBSTR(G_V_SQL, L_N_POS_VAR) /* *8 * */
                --  , L_V_SQL /* *8 * */
               --   , p_i_v_user_id -- added 30.01.2012
               --   , 'A'
             -- );
                      /*-- REMOVE BY WACCHO1 ON 07/08/2016 BACK TO ORIGINAL 
          ELSIF  (INSTR(LOWER(g_v_sql), 'loading_status') = 0)  AND P_I_V_CATEGORY_FLAG = 'Y' THEN --Update category only
                  PRE_UPDATE_LL_STATUS (
                  p_i_v_id
                  , SUBSTR(G_V_SQL, L_N_POS_VAR) 
                  , p_i_v_user_id -- added 30.01.2012
                  , 'Y'
              );
          END IF ; --*/
        ELSE
            /*
                call from discharge list
            */
            PRE_UPDATE_DL_STATUS (
                p_i_v_id
                , substr(g_v_sql, l_n_pos_var)
            );
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
            -- DBMS_OUTPUT.put_line('no data found: ' ||sqlerrm);
        WHEN OTHERS THEN
            NULL;
            -- DBMS_OUTPUT.put_line('other: ' ||sqlerrm);
    END PRE_UPDATE_LLDL_STATUS;

    /*
        logic to update loading status in discharge list
    */
    PROCEDURE PRE_UPDATE_LL_STATUS (
        p_i_v_id                      VARCHAR2
        , p_i_v_where_condition       VARCHAR2
        , p_i_v_user_id               VARCHAR2 -- added 30.01.2012
         , p_i_v_category_flag varchar2 --*15
    )
    AS
            --*15 begin
                 l_v_user                 BKP009.BICUSR%TYPE := 'EZLL';
                l_v_date                 BKP009.BICDAT%TYPE;
                l_v_time                 BKP009.BICTIM%TYPE;
            --*15 end
        v_row_count varchar2(100 char);
        /*
            Create a cursor type
        */
        TYPE dyn_cursor_type IS REF CURSOR;

        /*
            Create a cursor variable
        */
        dyn_cursor            dyn_cursor_type;

        /*
            Create a record to hold cursor value
        */
        TYPE dyn_record IS RECORD (
            FK_BOOKING_NO                    TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE
            , DN_EQUIPMENT_NO                TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE
            , LOADING_STATUS                 TOS_DL_BOOKED_DISCHARGE.DN_LOADING_STATUS%TYPE
            , STOWAGE_POSITION               TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION%TYPE
            , CONTAINER_GROSS_WEIGHT         TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT%TYPE
            -- Block added by vikas, 20.02.2012
            , MLO_VESSEL                     TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL%TYPE
            , MLO_VOYAGE                     TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE%TYPE
            , MLO_VESSEL_ETA                 TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL_ETA%TYPE
            , MLO_POD1                       TOS_DL_BOOKED_DISCHARGE.MLO_POD1%TYPE
            , MLO_POD2                       TOS_DL_BOOKED_DISCHARGE.MLO_POD2%TYPE
            , MLO_POD3                       TOS_DL_BOOKED_DISCHARGE.MLO_POD3%TYPE
            , MLO_DEL                        TOS_DL_BOOKED_DISCHARGE.MLO_DEL%TYPE
            , FK_BKG_EQUIPM_DTL              TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL%TYPE -- *16
            , CATEGORY_CODE   TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE%TYPE --*15
            , FK_BKG_VOYAGE_ROUTING_DTL TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL%TYPE --*15
            , FIRST_LEG_FLAG TOS_DL_BOOKED_DISCHARGE.FIRST_LEG_FLAG%TYPE --*15
            -- Block end by vikas, 20.02.2012
        );

        dyn_rec                  dyn_record;
        dynamic_select_stmt      VARCHAR2(4000);
        l_v_space                VARCHAR2(1) := ' ';
        l_v_dn_port              TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE;
        l_v_dn_terminal          TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE;

        l_v_discharge_list       TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE; -- added, 05.03.2012

    BEGIN
       -- insert into TEMP_20150424_STMT_TEST values (sysdate,'PRE_UPDATE_LL_STATUS','p_i_v_category_flag : '||p_i_v_category_flag,''); commit;
        --*15 Add query FK_BKG_VOYAGE_ROUTING_DTL for update category_code

        dynamic_select_stmt :=
            'SELECT
                FK_BOOKING_NO
                , DN_EQUIPMENT_NO
                , LOADING_STATUS
                , STOWAGE_POSITION
                , CONTAINER_GROSS_WEIGHT
                , MLO_VESSEL
                , MLO_VOYAGE
                , MLO_VESSEL_ETA
                , MLO_POD1
                , MLO_POD2
                , MLO_POD3
                , MLO_DEL
                , FK_BKG_EQUIPM_DTL
                , CATEGORY_CODE
                , FK_BKG_VOYAGE_ROUTING_DTL
                , FIRST_LEG_FLAG
            FROM
                TOS_LL_BOOKED_LOADING';


        /*
            Add where condition in dynamic sql
        */

        -- dynamic_select_stmt := dynamic_select_stmt || l_v_space || p_i_v_where_condition; -- *16

        dynamic_select_stmt := dynamic_select_stmt || l_v_space || ' WHERE RECORD_STATUS=''A'' '; -- *16
        dynamic_select_stmt := dynamic_select_stmt || l_v_space || ' AND RECORD_CHANGE_USER = ''' || p_i_v_user_id || ''''; -- *16




        /*
            get the load port and terminal
        */
       BEGIN

        SELECT
            DN_PORT
            , DN_TERMINAL
        INTO
            l_v_dn_port
            , l_v_dn_terminal
        FROM
            TOS_LL_LOAD_LIST
        WHERE
            PK_LOAD_LIST_ID = p_i_v_id;
     END;
        l_v_discharge_list := null; -- added 05.03.2012



        /*
            Open cursor for dynamic sql
        */

         OPEN dyn_cursor FOR dynamic_select_stmt;
        LOOP
            FETCH dyn_cursor INTO dyn_rec;
            /*
                Loop exit when no data found condition
            */
            EXIT WHEN dyn_cursor%NOTFOUND;
            UPDATE
                        TOS_DL_BOOKED_DISCHARGE
                    SET
                        DN_LOADING_STATUS        = dyn_rec.LOADING_STATUS
                        , CONTAINER_GROSS_WEIGHT = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.CONTAINER_GROSS_WEIGHT, CONTAINER_GROSS_WEIGHT) --CH#1
                        , STOWAGE_POSITION       = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.STOWAGE_POSITION, STOWAGE_POSITION) -- CH#1
                        , MLO_VESSEL             = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VESSEL, MLO_VESSEL) -- CH#2
                        , MLO_VOYAGE             = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VOYAGE, MLO_VOYAGE) -- CH#2
                        , MLO_VESSEL_ETA         = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VESSEL_ETA, MLO_VESSEL_ETA) -- CH#2
                        , MLO_POD1               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD1, MLO_POD1) -- CH#2
                        , MLO_POD2               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD2, MLO_POD2) -- CH#2
                        , MLO_POD3               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD3, MLO_POD3) -- CH#2
                        , MLO_DEL                = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_DEL, MLO_DEL) -- CH#2
                        , RECORD_CHANGE_USER     = p_i_v_user_id
                        , RECORD_CHANGE_DATE     = SYSDATE
                    WHERE
                        FK_BOOKING_NO =  dyn_rec.FK_BOOKING_NO
                        -- AND DN_EQUIPMENT_NO = dyn_rec.DN_EQUIPMENT_NO -- *16
                        AND FK_BKG_EQUIPM_DTL = dyn_rec.FK_BKG_EQUIPM_DTL -- *16
                        AND DN_POL = l_v_dn_port
                        AND DN_POL_TERMINAL = l_v_dn_terminal
                        AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012
                        AND RECORD_STATUS = 'A';

           /*-- REMOVE BY WACCHO1 ON 07/08/2016 BACK TO ORIGINAL. 
            IF p_i_v_category_flag = 'N' THEN
                  UPDATE
                        TOS_DL_BOOKED_DISCHARGE
                    SET
                        DN_LOADING_STATUS        = dyn_rec.LOADING_STATUS
                        , CONTAINER_GROSS_WEIGHT = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.CONTAINER_GROSS_WEIGHT, CONTAINER_GROSS_WEIGHT) --CH#1
                        , STOWAGE_POSITION       = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.STOWAGE_POSITION, STOWAGE_POSITION) -- CH#1
                        , MLO_VESSEL             = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VESSEL, MLO_VESSEL) -- CH#2
                        , MLO_VOYAGE             = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VOYAGE, MLO_VOYAGE) -- CH#2
                        , MLO_VESSEL_ETA         = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VESSEL_ETA, MLO_VESSEL_ETA) -- CH#2
                        , MLO_POD1               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD1, MLO_POD1) -- CH#2
                        , MLO_POD2               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD2, MLO_POD2) -- CH#2
                        , MLO_POD3               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD3, MLO_POD3) -- CH#2
                        , MLO_DEL                = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_DEL, MLO_DEL) -- CH#2
                        , RECORD_CHANGE_USER     = p_i_v_user_id
                        , RECORD_CHANGE_DATE     = SYSDATE
                    WHERE
                        FK_BOOKING_NO =  dyn_rec.FK_BOOKING_NO
                        -- AND DN_EQUIPMENT_NO = dyn_rec.DN_EQUIPMENT_NO -- *16
                        AND FK_BKG_EQUIPM_DTL = dyn_rec.FK_BKG_EQUIPM_DTL -- *16
                        AND DN_POL = l_v_dn_port
                        AND DN_POL_TERMINAL = l_v_dn_terminal
                        AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012
                        AND RECORD_STATUS = 'A';
                    -- DBMS_OUTPUT.PUT_LINE(dyn_rec.FK_BOOKING_NO || ' ' || dyn_rec.DN_EQUIPMENT_NO);
             END IF;

              IF p_i_v_category_flag = 'Y' THEN
               UPDATE
                    TOS_DL_BOOKED_DISCHARGE
                SET
                    CATEGORY_CODE = dyn_rec.CATEGORY_CODE
                    , RECORD_CHANGE_USER     = p_i_v_user_id
                    , RECORD_CHANGE_DATE     = SYSDATE
                WHERE
                    FK_BOOKING_NO =  dyn_rec.FK_BOOKING_NO
                    -- AND DN_EQUIPMENT_NO = dyn_rec.DN_EQUIPMENT_NO -- *16
                    AND FK_BKG_EQUIPM_DTL = dyn_rec.FK_BKG_EQUIPM_DTL -- *16
                    AND DN_POL = l_v_dn_port
                    AND DN_POL_TERMINAL = l_v_dn_terminal
                    AND FK_BKG_VOYAGE_ROUTING_DTL = dyn_rec.FK_BKG_VOYAGE_ROUTING_DTL
                    AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012
                    AND RECORD_STATUS = 'A';

                      IF  dyn_rec.FIRST_LEG_FLAG = 'Y' AND dyn_rec.LOADING_STATUS = 'BK' THEN
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

                            UPDATE BKP009
                           SET EQP_CATEGORY =  dyn_rec.CATEGORY_CODE,
                             BICUSR        = l_v_user ,
                              BICDAT        = l_v_date ,
                             BICTIM        = l_v_time
                           WHERE  BIBKNO   = dyn_rec.FK_BOOKING_NO
                            AND    BISEQN   = dyn_rec.FK_BKG_EQUIPM_DTL;

                  END IF;
              END IF;

             IF p_i_v_category_flag = 'A' THEN
               BEGIN
                UPDATE
                    TOS_DL_BOOKED_DISCHARGE
                SET
                    CATEGORY_CODE = dyn_rec.CATEGORY_CODE
                    , RECORD_CHANGE_USER     = p_i_v_user_id
                    , RECORD_CHANGE_DATE     = SYSDATE
                WHERE
                    FK_BOOKING_NO =  dyn_rec.FK_BOOKING_NO
                    -- AND DN_EQUIPMENT_NO = dyn_rec.DN_EQUIPMENT_NO -- *16
                    AND FK_BKG_EQUIPM_DTL = dyn_rec.FK_BKG_EQUIPM_DTL -- *16
                    AND DN_POL = l_v_dn_port
                    AND DN_POL_TERMINAL = l_v_dn_terminal
                    AND FK_BKG_VOYAGE_ROUTING_DTL = dyn_rec.FK_BKG_VOYAGE_ROUTING_DTL
                    AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012
                    AND RECORD_STATUS = 'A';
               END;

                 BEGIN
                    UPDATE
                        TOS_DL_BOOKED_DISCHARGE
                    SET
                        DN_LOADING_STATUS        = dyn_rec.LOADING_STATUS
                        , CONTAINER_GROSS_WEIGHT = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.CONTAINER_GROSS_WEIGHT, CONTAINER_GROSS_WEIGHT) --CH#1
                        , STOWAGE_POSITION       = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.STOWAGE_POSITION, STOWAGE_POSITION) -- CH#1
                        , MLO_VESSEL             = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VESSEL, MLO_VESSEL) -- CH#2
                        , MLO_VOYAGE             = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VOYAGE, MLO_VOYAGE) -- CH#2
                        , MLO_VESSEL_ETA         = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_VESSEL_ETA, MLO_VESSEL_ETA) -- CH#2
                        , MLO_POD1               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD1, MLO_POD1) -- CH#2
                        , MLO_POD2               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD2, MLO_POD2) -- CH#2
                        , MLO_POD3               = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_POD3, MLO_POD3) -- CH#2
                        , MLO_DEL                = DECODE(dyn_rec.LOADING_STATUS, 'LO', dyn_rec.MLO_DEL, MLO_DEL) -- CH#2
                        , RECORD_CHANGE_USER     = p_i_v_user_id
                        , RECORD_CHANGE_DATE     = SYSDATE
                    WHERE
                        FK_BOOKING_NO =  dyn_rec.FK_BOOKING_NO
                        -- AND DN_EQUIPMENT_NO = dyn_rec.DN_EQUIPMENT_NO -- *16
                        AND FK_BKG_EQUIPM_DTL = dyn_rec.FK_BKG_EQUIPM_DTL -- *16
                        AND DN_POL = l_v_dn_port
                        AND DN_POL_TERMINAL = l_v_dn_terminal
                        AND DISCHARGE_STATUS <> 'DI' -- added by vikas, 17.02.2012
                        AND RECORD_STATUS = 'A';
               END;

                  IF  dyn_rec.FIRST_LEG_FLAG = 'Y' AND dyn_rec.LOADING_STATUS = 'BK' THEN
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

                            UPDATE BKP009
                           SET EQP_CATEGORY =  dyn_rec.CATEGORY_CODE,
                             BICUSR        = l_v_user ,
                              BICDAT        = l_v_date ,
                             BICTIM        = l_v_time
                           WHERE  BIBKNO   = dyn_rec.FK_BOOKING_NO
                            AND    BISEQN   = dyn_rec.FK_BKG_EQUIPM_DTL;

                  END IF;
             END IF;
             --*/
        END LOOP;

        CLOSE dyn_cursor;
        COMMIT;
      --*15 END
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
            -- DBMS_OUTPUT.put_line('no data found: ' ||sqlerrm);
        WHEN OTHERS THEN
            NULL;
            -- DBMS_OUTPUT.put_line('other: ' ||sqlerrm);
    END PRE_UPDATE_LL_STATUS;

    /*
        logic to update tos_onboard_list
    */
    PROCEDURE PRE_UPDATE_DL_STATUS (
        p_i_v_id                      VARCHAR2
        , p_i_v_where_condition       VARCHAR2
    )
    AS
        /*
            Create a cursor type
        */
        TYPE dyn_cursor_type IS REF CURSOR;

        /*
            Create a cursor variable
        */
        dyn_cursor            dyn_cursor_type;

        /*
            Create a record to hold cursor value
        */
        TYPE dyn_record IS RECORD (
            FK_BOOKING_NO       TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE
            , DN_EQUIPMENT_NO   TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE
            , DISCHARGE_STATUS  TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS%TYPE
            , DN_POL             TOS_DL_BOOKED_DISCHARGE.DN_POL%TYPE
            , DN_POL_TERMINAL     TOS_DL_BOOKED_DISCHARGE.DN_POL_TERMINAL%TYPE
            );

        dyn_rec                  dyn_record;
        dynamic_dl_select_stmt   VARCHAR2(4000);
        l_v_space                VARCHAR2(1) := ' ';

        l_v_fk_service           TOS_LL_LOAD_LIST.FK_SERVICE%TYPE;
        l_v_fk_vessel            TOS_LL_LOAD_LIST.FK_VESSEL%TYPE;
        l_v_fk_voyage            TOS_LL_LOAD_LIST.FK_VOYAGE%TYPE;
        l_v_dn_port              TOS_LL_LOAD_LIST.DN_PORT%TYPE;
        l_v_dn_terminal          TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE;
        l_v_dn_ll_port           TOS_LL_LOAD_LIST.DN_PORT%TYPE;
        l_v_dn_ll_terminal       TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE;
        l_v_fk_direction         TOS_LL_LOAD_LIST.FK_DIRECTION%TYPE;
        BLANK                    VARCHAR2(1) := '';

    BEGIN


        -- DBMS_OUTPUT.put_line('2: '|| p_i_v_where_condition );

        dynamic_dl_select_stmt :=
            'SELECT
                FK_BOOKING_NO
                , DN_EQUIPMENT_NO
                , DISCHARGE_STATUS
                , DN_POL
                , DN_POL_TERMINAL
            FROM
                TOS_DL_BOOKED_DISCHARGE';

        /*
            Add where condition in dynamic sql
        */

        dynamic_dl_select_stmt := dynamic_dl_select_stmt || l_v_space || p_i_v_where_condition;

        -- DBMS_OUTPUT.put_line(dynamic_dl_select_stmt);

        /*
            get discharge port from discharge list header table.
        */

        SELECT
            DN_PORT
            , DN_TERMINAL
        INTO
            l_v_dn_port
            ,l_v_dn_terminal
        FROM
            TOS_DL_DISCHARGE_LIST
        WHERE
            PK_DISCHARGE_LIST_ID = p_i_v_id;


        /*
            Open cursor for dynamic sql
        */

        OPEN dyn_cursor FOR dynamic_dl_select_stmt;
        LOOP
            FETCH dyn_cursor INTO dyn_rec;
            /*
                Loop exit when no data found condition
            */
            EXIT WHEN dyn_cursor%NOTFOUND;

            /*
                Get service vessel voyage for this booking from load list
            */

            SELECT
                  LL.FK_SERVICE
                , LL.FK_VESSEL
                , LL.FK_VOYAGE
                , LL.FK_DIRECTION
                , LL.DN_PORT
                , LL.DN_TERMINAL
            INTO
                  l_v_fk_service
                , l_v_fk_vessel
                , l_v_fk_voyage
                , l_v_fk_direction
                , l_v_dn_ll_port
                , l_v_dn_ll_terminal
            FROM    VASAPPS.TOS_LL_BOOKED_LOADING BL ,
                    VASAPPS.TOS_LL_LOAD_LIST LL
            WHERE   LL.PK_LOAD_LIST_ID = BL.FK_LOAD_LIST_ID
            AND     LL.DN_PORT         = dyn_rec.DN_POL
            AND     LL.DN_TERMINAL     = dyn_rec.DN_POL_terminal
            AND     BL.FK_BOOKING_NO   = dyn_rec.FK_BOOKING_NO
            AND     BL.DN_EQUIPMENT_NO = dyn_rec.DN_EQUIPMENT_NO
            AND     ROWNUM             = 1;

            /*
                Update loading status from booked loading table
            */

            IF (dyn_rec.DISCHARGE_STATUS = 'DI') THEN

                UPDATE TOS_ONBOARD_LIST SET
                      SEND_TO_POD          = 'M'
                    , DISCH_STATUS         = 'D'
                    , DISCHLIST_STATUS     = 'C'
                WHERE
                    TOS_ONBOARD_LIST.POL_SERVICE        = l_v_fk_service
                    AND TOS_ONBOARD_LIST.POL_VESSEL     = l_v_fk_vessel
                    AND TOS_ONBOARD_LIST.POL_VOYAGE     = l_v_fk_voyage
                    AND TOS_ONBOARD_LIST.POD            = l_v_dn_port
                    AND TOS_ONBOARD_LIST.POD_TERMINAL   = l_v_dn_terminal
                    AND TOS_ONBOARD_LIST.POL            = l_v_dn_ll_port
                    AND TOS_ONBOARD_LIST.POL_TERMINAL   = l_v_dn_ll_terminal
                    AND TOS_ONBOARD_LIST.BOOKING_NO     = dyn_rec.FK_BOOKING_NO
                    AND TOS_ONBOARD_LIST.CONTAINER_NO   = DYN_REC.DN_EQUIPMENT_NO;

            ELSIF (dyn_rec.DISCHARGE_STATUS = 'BK') THEN

                UPDATE TOS_ONBOARD_LIST SET
                      SEND_TO_POD          = BLANK
                    , DISCH_STATUS         = BLANK
                    , DISCHLIST_STATUS     = BLANK
                WHERE
                    TOS_ONBOARD_LIST.POL_SERVICE        = l_v_fk_service
                    AND TOS_ONBOARD_LIST.POL_VESSEL     = l_v_fk_vessel
                    AND TOS_ONBOARD_LIST.POL_VOYAGE     = l_v_fk_voyage
                    AND TOS_ONBOARD_LIST.POD            = l_v_dn_port
                    AND TOS_ONBOARD_LIST.POD_TERMINAL   = l_v_dn_terminal
                    AND TOS_ONBOARD_LIST.POL            = l_v_dn_ll_port
                    AND TOS_ONBOARD_LIST.POL_TERMINAL   = l_v_dn_ll_terminal
                    AND TOS_ONBOARD_LIST.BOOKING_NO     = dyn_rec.FK_BOOKING_NO
                    AND TOS_ONBOARD_LIST.CONTAINER_NO   = DYN_REC.DN_EQUIPMENT_NO;
            END IF;

            -- DBMS_OUTPUT.PUT_LINE(dyn_rec.FK_BOOKING_NO || ' ' || dyn_rec.DN_EQUIPMENT_NO);
        END LOOP;

        CLOSE dyn_cursor;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
            -- DBMS_OUTPUT.put_line('no data found: ' ||sqlerrm);
        WHEN OTHERS THEN
            NULL;
            -- DBMS_OUTPUT.put_line('other: ' ||sqlerrm);
    END PRE_UPDATE_DL_STATUS;

/*
    End added by vikas, 20.12.2011
*/

--*1 Begin
    /**
        Checks if duplicate stowage position exists in load list/ discharge list tables
        according to parameters passed
        If exists return true else false
    */
    PROCEDURE PRE_CHECK_DUP_STOW_POS_PRESENT(
        p_i_v_id               VARCHAR2,
        p_i_v_tab_flag         VARCHAR2,
        p_i_v_flag             VARCHAR2,
        p_o_v_dup_present      OUT VARCHAR2
    )
    AS
        l_v_table_name               VARCHAR2(50);
        l_v_load_discharge_column    VARCHAR2(20);
        l_v_sql                      VARCHAR2(1000);
        L_STOWAGE_POSITION           VARCHAR2(10);
        L_V_TEST                     VARCHAR2(4000);
    BEGIN
        p_o_v_dup_present := 'TRUE' ;

        /*
            Get the table name
        */
        IF (p_i_v_flag = DISCHARGE_LIST) THEN
            l_v_load_discharge_column := 'FK_DISCHARGE_LIST_ID';

            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                    l_v_table_name := 'TOS_DL_OVERLANDED_CONTAINER';
            ELSIF (p_i_v_tab_flag = BOOKED_TAB) THEN
                    l_v_table_name := 'TOS_DL_BOOKED_DISCHARGE';
            END IF;

        ELSIF (p_i_v_flag = LOAD_LIST ) THEN
            l_v_load_discharge_column := 'FK_LOAD_LIST_ID';

            IF(p_i_v_tab_flag = OVERLAND_OVERSHIP_TAB) THEN
                    l_v_table_name := 'TOS_LL_OVERSHIPPED_CONTAINER';
            ELSIF (p_i_v_tab_flag = BOOKED_TAB) THEN
                    l_v_table_name := 'TOS_LL_BOOKED_LOADING';
            END IF;

        END IF;
        /*
            l_v_sql := 'SELECT STOWAGE_POSITION FROM ' || l_v_table_name ||
            ' WHERE STOWAGE_POSITION IS NOT NULL AND ' ||
            l_v_load_discharge_column || ' = ''' || p_i_v_id || ''' AND ' ||
            ' RECORD_STATUS = ''A'' '||
            ' GROUP BY STOWAGE_POSITION ' ||
            ' HAVING COUNT(1) > 1 ' ;
        */

        /*
            Check duplicate cell location is exists or not.
        */
        SELECT SUBSTR(G_V_WHERE_COND, 1, INSTR(G_V_WHERE_COND, 'AND  (DN_EQUIPMENT_NO') - 1 )
        INTO L_V_TEST
        FROM DUAL;

        L_V_TEST := L_V_TEST || ' AND STOWAGE_POSITION IS NOT NULL AND RECORD_STATUS = ''A''  ' ;  -- *3

        l_v_sql := 'SELECT STOWAGE_POSITION FROM '|| l_v_table_name
            ||' ' || L_V_TEST || ' GROUP BY STOWAGE_POSITION HAVING COUNT(1) > 1';


        EXECUTE IMMEDIATE l_v_sql into L_STOWAGE_POSITION;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_dup_present := 'FALSE';
        WHEN OTHERS THEN -- *6
            p_o_v_dup_present := 'TRUE'; -- *6

    END PRE_CHECK_DUP_STOW_POS_PRESENT;
--*1 End

    /* *8 start * */
    PROCEDURE PRE_GET_UPDATED_WHERE_COND(
        P_I_V_IN1                VARCHAR2,
        P_I_V_FIND1              VARCHAR2,
        P_I_V_IN2                VARCHAR2,
        P_I_V_FIND2              VARCHAR2,
        P_I_V_FLAG               VARCHAR2,
        P_I_V_TAB_FLAG           VARCHAR2,
        P_I_V_LOAD_DISCH_STATUS  VARCHAR2,
        P_I_O_V_SQL              IN OUT NOCOPY VARCHAR2
    )
    AS
        OLD_VALUE VARCHAR2(4000);
        NEW_VALUE VARCHAR2(4000);

    BEGIN

        IF (p_i_v_in1 = 'LOADING_STATUS') THEN

            PCE_EDL_BULKUPDATE.ADDITION_WHERE_CONDTIONS(p_i_v_in1, p_i_v_find1,p_i_v_flag, p_i_v_tab_flag, p_i_v_load_disch_status, OLD_VALUE);
            dbms_output.put_line('OLD_VALUE:=>'||OLD_VALUE);

            PCE_EDL_BULKUPDATE.ADDITION_WHERE_CONDTIONS(p_i_v_in1, p_i_v_load_disch_status, p_i_v_flag, p_i_v_tab_flag, p_i_v_load_disch_status, NEW_VALUE);
            dbms_output.put_line('NEW_VALUE:=>'||NEW_VALUE);

        ELSIF (p_i_v_in2 = 'LOADING_STATUS') THEN
            PCE_EDL_BULKUPDATE.ADDITION_WHERE_CONDTIONS(p_i_v_in2, p_i_v_find2,p_i_v_flag, p_i_v_tab_flag, p_i_v_load_disch_status, OLD_VALUE);
            dbms_output.put_line('OLD_VALUE:=>'||OLD_VALUE);

            PCE_EDL_BULKUPDATE.ADDITION_WHERE_CONDTIONS(p_i_v_in2, p_i_v_load_disch_status, p_i_v_flag, p_i_v_tab_flag, p_i_v_load_disch_status, NEW_VALUE);
            dbms_output.put_line('NEW_VALUE:=>'||NEW_VALUE);

        END IF;

        /* * replace old value from new value * */
        SELECT
            REPLACE (P_I_O_V_SQL, OLD_VALUE, NEW_VALUE)
        INTO
            P_I_O_V_SQL
        FROM
            DUAL;

        DBMS_OUTPUT.PUT_LINE(P_I_O_V_SQL);
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END PRE_GET_UPDATED_WHERE_COND;
    /* *8 end * */

    /* *14 start * */
    PROCEDURE PRE_GET_CONTAINER_STATUS(
        P_I_V_FIND VARCHAR2,
        P_O_V_STATUS  OUT NOCOPY VARCHAR2
    )AS

    BLANK VARCHAR2(2) DEFAULT NULL;
    L_V_STATUS VARCHAR2(4000);

    BEGIN
        SELECT
            DECODE(LOWER(p_i_v_find),
              'booked','BK'
            , 'loaded', 'LO'
            , 'discharged', 'DI'
            , 'short shipped', 'SS'
            , 'rob', 'RB'
            , 'short landed', 'SL'
            , p_i_v_find
            )
        INTO
            L_V_STATUS
        FROM
            DUAL;

        SELECT
            CASE WHEN (LENGTH(L_V_STATUS) > 2) THEN BLANK ELSE L_V_STATUS END
        INTO
            P_O_V_STATUS
        FROM
            DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);

    END PRE_GET_CONTAINER_STATUS;
    /* *14 end * */

END PCE_EDL_BULKUPDATE;

/* End of Package Body */
