CREATE OR REPLACE PACKAGE BODY PCE_RETURN_SHIPMENT AS

PROCEDURE VALID_BOOKING_NUMBER (
    p_i_v_bkg_number       IN  VARCHAR2,
    p_o_v_return_status    OUT NOCOPY  VARCHAR2
) AS
    l_v_booking_no   BKP001.BABKNO%TYPE;
    BEGIN
       SELECT BABKNO
       INTO l_v_booking_no
       FROM BKP001
       WHERE BABKNO = p_i_v_bkg_number;
       p_o_v_return_status := '0';
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          p_o_v_return_status := '1';
       WHEN TOO_MANY_ROWS  THEN
          p_o_v_return_status := '0';
       WHEN OTHERS THEN
          p_o_v_return_status := '1';
    END VALID_BOOKING_NUMBER;


PROCEDURE VALID_BILL_NUMBER(
    p_i_v_bkg_list        IN VARCHAR2,
    p_o_v_return_status   OUT NOCOPY  VARCHAR2
) AS
    l_v_booking_list   IDP002.TYBLNO%TYPE;
    BEGIN
       SELECT TYBLNO
       INTO l_v_booking_list
       FROM IDP002
       WHERE TYBLNO = p_i_v_bkg_list;
       p_o_v_return_status := '0';
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          p_o_v_return_status := '1';
       WHEN TOO_MANY_ROWS  THEN
          p_o_v_return_status := '0';
       WHEN OTHERS THEN
          p_o_v_return_status := '1';
    END VALID_BILL_NUMBER;

PROCEDURE PRE_BKG_RETURN_CONT(
    p_i_v_usr_id              IN   VARCHAR2,
    p_i_v_bkg_number          IN   VARCHAR2,
    p_i_v_bkg_list            IN   VARCHAR2,
    p_i_v_rcrd_status         IN   VARCHAR2,
    p_i_v_resn_kind           IN   VARCHAR2,
    p_i_v_resn_desc           IN   VARCHAR2,
    p_o_v_error       OUT NOCOPY  VARCHAR2
) AS

/***********************************************************************************
       Name           :  PCE_RETURN_SHIPMENT
       Module         :
       Purpose        :  To Update and Insert record in LAOD LIST AND HEADER TABLES
                         For return shipment
                         This procedure is called by Screen
       Calls          :
       Returns        :  Null
       Author          Date               What
       ------          ----               ----
       Parivesh        03/03/2011        INITIAL VERSION
***********************************************************************************/
    l_v_sql_id                                 VARCHAR2(10);
    l_exce_main                                EXCEPTION;
    l_d_time                                   TIMESTAMP;
    l_v_date                                   NUMBER;
    l_v_time                                   NUMBER;
    l_v_user                                   VARCHAR2(10) := 'VASAPPS';
    l_v_err_code                               VARCHAR2(10);
    l_v_err_desc                               VARCHAR2(100);
    l_v_coc                                    TOS_DL_BOOKED_DISCHARGE.DN_SOC_COC%TYPE;
    l_v_load_cn                                TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION%TYPE;
    l_v_shpmnt_ty                              TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP%TYPE;
    l_v_bkg_list                               VARCHAR2(20) := NULL;
    l_v_stw_pos                                TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION%TYPE;
    i_v_return_status                          VARCHAR2(1);
    l_v_eqwght                                 NUMBER;
    l_v_biline                                 BKP001.BALINE%TYPE;
    l_v_batrad                                 BKP001.BATRAD%TYPE;
    l_v_baagnt                                 BKP001.BAAGNT%TYPE;
    l_n_wght                                   ECP010.EQWGHT%TYPE;
    l_v_stcmcd                                 ITP0TD.STCMCD%TYPE;
    l_v_fcdesc                                 ITP080.FCDESC%TYPE;
    l_v_com_grpcd                              ITP080.COMMODITY_GROUP_CODE%TYPE;
    l_n_bwcmsq                                 NUMBER := 0;
    l_n_returnid                               NUMBER;
    l_arr_var_name                             STRING_ARRAY;
    l_arr_var_value                            STRING_ARRAY;
    l_arr_var_io                               STRING_ARRAY;
    l_v_eqp_sizetype_seqno                     BKP032.EQP_SIZETYPE_SEQNO%TYPE; -- added by vikas
    l_v_parameter_string                       VARCHAR2(4000);

    CURSOR l_cur_bkg_num
    IS

        SELECT  DISTINCT IDP002.TYBKNO          ,
            IDP055.EYEQNO          ,
            IDP010.AYSTAT          ,
            IDP010.PART_OF_BL      ,
            IDP055.SPECIAL_HANDLING,
            IDP055.EYEQSZ          ,
            IDP055.EYEQTP
        FROM IDP055 IDP055,
            IDP002 IDP002      ,
            IDP010 IDP010
        WHERE IDP055.EYBLNO    = IDP002.TYBLNO
        AND IDP055.EYBLNO      = IDP010.AYBLNO
        AND IDP010.AYSTAT     >='1'
        AND IDP010.AYSTAT     <='6'
        AND IDP010.PART_OF_BL IS NULL
        AND IDP002.TYBLNO = p_i_v_bkg_list;

    CURSOR l_cur_update_qty(p_i_v_bkk varchar2)
    IS
        SELECT COUNT(1) BCQT,SUM(BCSIZE)/20 BCEUS,BCSIZE,BCTYPE
        FROM BKP032
        WHERE BCBKNO=p_i_v_bkk
        GROUP BY BCSIZE,BCTYPE;
    /*
    CURSOR l_cur_update_bkp9(p_i_v_bkq varchar2)
    IS
        SELECT COUNT(1) BBQT,BICSZE,BICNTP
        FROM BKP009
        WHERE BIBKNO=p_i_v_bkq
        GROUP BY BICSZE,BICNTP;
    */
    CURSOR l_cur_tos_dl_bk_discharge(p_i_v_bktos varchar2,p_i_v_dntos varchar2)
    IS
        SELECT FK_BOOKING_NO,DN_EQUIPMENT_NO, dn_eq_size, dn_eq_type, dn_special_hndl
        FROM TOS_DL_BOOKED_DISCHARGE
        WHERE FK_BOOKING_NO = p_i_v_bktos
        AND DN_EQUIPMENT_NO = p_i_v_dntos
        AND DISCHARGE_STATUS='RB';

    BEGIN
        l_v_parameter_string := p_i_v_usr_id                || '~' ||
                                p_i_v_bkg_number            || '~' ||
                                p_i_v_bkg_list              || '~' ||
                                p_i_v_rcrd_status           || '~' ||
                                p_i_v_resn_kind             || '~' ||
                                p_i_v_resn_desc;

        l_d_time  := CURRENT_TIMESTAMP;
        l_v_date  := TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'));
        l_v_time  := TO_NUMBER(TO_CHAR(SYSDATE,'HH24MI'));
        -- Update data into TOS_DL_BOOKED_DISCHARGE table
        l_v_sql_id := 'SQL-00001';
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
            'RET'
            ,'1'||'~'||l_v_parameter_string
            ,'A'
            ,'TEST'
            ,SYSDATE
            ,'TEST'
            ,SYSDATE

        );
        -- commit;
*/
        BEGIN  --For Inserting data in BKP050 in case of COC with BB
            SELECT STCMCD,FCDESC,COMMODITY_GROUP_CODE
            INTO l_v_stcmcd,l_v_fcdesc,l_v_com_grpcd
            FROM ITP0TD,ITP080
            WHERE SGLINE='R' AND SGTRAD='*'
            AND ITP0TD.STCMCD = ITP080.FCCODE;
        EXCEPTION
            WHEN OTHERS THEN
            --RAISE l_exce_main;
            p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        END;

        /* Delete new booking data for DG commodity,
        as suggest by k'myo on 03.11.2011 */
        DELETE FROM BKP050
        WHERE BWBKNO = p_i_v_bkg_number;

        DELETE FROM BOOKING_SUPPLIER_DETAIL
        WHERE BOOKING_NO = p_i_v_bkg_number;

        DELETE FROM BKP009
        WHERE BIBKNO = p_i_v_bkg_number;

        DELETE FROM BKP030
        WHERE BNBKNO = p_i_v_bkg_number
        AND BNCSTP IN ('C', 'S');

        FOR l_cur_bkg_data IN l_cur_bkg_num
        LOOP
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
                'RET'
                ,'2'||'~'||p_i_v_bkg_number
                ,'A'
                ,'TEST'
                ,SYSDATE
                ,'TEST'
                ,SYSDATE
            );
         --   commit;
          */
		  IF p_i_v_rcrd_status = 'A' THEN  --Select All Container
                l_v_sql_id := 'SQL-00002';
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
                    'RET'
                    ,'3'||'~'||p_i_v_bkg_number
                    ,'A'
                    ,'TEST'
                    ,SYSDATE
                    ,'TEST'
                    ,SYSDATE
                );
                --commit;
*/
                BEGIN
                    UPDATE TOS_DL_BOOKED_DISCHARGE SET DISCHARGE_STATUS='RB',
                    RECORD_CHANGE_USER=l_v_user, RECORD_CHANGE_DATE =  l_d_time
                    WHERE FK_BOOKING_NO = l_cur_bkg_data.TYBKNO
                    AND DN_EQUIPMENT_NO = l_cur_bkg_data.EYEQNO;

                EXCEPTION
                    WHEN OTHERS THEN
                    i_v_return_status := '1';
                    --RAISE l_exce_main;
                    p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                    RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
                END;
            /* --Review 4
            ELSIF p_i_v_rcrd_status = 'R' THEN  --Select ROB Container
            l_v_sql_id := 'SQL-00003';
                BEGIN
                    SELECT DN_SOC_COC,LOAD_CONDITION,DN_SHIPMENT_TYP,STOWAGE_POSITION
                    INTO l_v_coc,l_v_load_cn,l_v_shpmnt_ty,l_v_stw_pos
                    FROM TOS_DL_BOOKED_DISCHARGE
                    WHERE FK_BOOKING_NO = l_cur_bkg_data.TYBKNO
                    AND DN_EQUIPMENT_NO = l_cur_bkg_data.EYEQNO
                    AND DISCHARGE_STATUS='RB';
                    i_v_return_status := '0';
                EXCEPTION
                    WHEN OTHERS THEN
                    i_v_return_status := '1';
                    --RAISE l_exce_main;
                    p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                    RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
                END;
            */
            END IF;
                --SELECT BILINE,BATRAD,BAAGNT FROM BKP001 AND USE THAT VALUE TO INSERT EVERYWHERE AS PER HEMLATA
            FOR l_cur_tos_dl IN l_cur_tos_dl_bk_discharge(l_cur_bkg_data.TYBKNO,l_cur_bkg_data.EYEQNO)
            LOOP

                l_v_sql_id := 'SQL-0001A';

                BEGIN
                        SELECT DN_SOC_COC,LOAD_CONDITION,DN_SHIPMENT_TYP,STOWAGE_POSITION
                        INTO l_v_coc,l_v_load_cn,l_v_shpmnt_ty,l_v_stw_pos
                        FROM TOS_DL_BOOKED_DISCHARGE
                        WHERE FK_BOOKING_NO = l_cur_bkg_data.TYBKNO
                        AND DN_EQUIPMENT_NO = l_cur_bkg_data.EYEQNO
                        AND DISCHARGE_STATUS='RB';

                        i_v_return_status := '0';
                EXCEPTION
                        WHEN OTHERS THEN
                        i_v_return_status := '1';
                        --RAISE l_exce_main;
                        p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
                END;
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
                    'RET'
                    ,'4'||'~'||p_i_v_bkg_number ||'~'||l_cur_tos_dl.FK_BOOKING_NO
                    ,'A'
                    ,'TEST'
                    ,SYSDATE
                    ,'TEST'
                    ,SYSDATE
                );
                --commit;
*/				
                BEGIN
                    SELECT BALINE,BATRAD,BAAGNT
                    INTO l_v_biline,l_v_batrad,l_v_baagnt
                    FROM BKP001
                    WHERE BABKNO = p_i_v_bkg_number;
                EXCEPTION
                    WHEN OTHERS THEN
                    --RAISE l_exce_main;
                    p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                    RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                END;

                IF i_v_return_status = '0' THEN  --INSERT RECORD ONLY WHEN DATA FOUND IN TOS_DL_BOOKED_DISCHARGE TABLE
                    SELECT SE_RSZ01.NEXTVAL INTO l_n_returnid FROM DUAL;
                    IF NVL(l_v_bkg_list,'N') != p_i_v_bkg_list THEN --FOR SINGLE INSERT OF RECORD
                    l_v_sql_id := 'SQL-00004';
                        BEGIN
                            INSERT INTO BKG_RETURN_SHIPMENT(
                            PK_RETURN_SHIPMENT_ID,
                            FK_RETURN_BOOKING,
                            FK_RETURN_BL,
                            RETURN_REASON_CODE,
                            RETURN_REASON_DESC,
                            RECORD_STATUS,
                            RECORD_ADD_USER,
                            RECORD_ADD_DATE,
                            RECORD_CHANGE_USER,
                            RECORD_CHANGE_DATE)
                            VALUES(
                            l_n_returnid,  --Review 2
                            p_i_v_bkg_number,
                            p_i_v_bkg_list,
                            p_i_v_resn_kind,
                            p_i_v_resn_desc,
                            'A',   --Review 1
                            l_v_user,
                            l_d_time,
                            l_v_user,
                            l_d_time);
                        EXCEPTION
                            WHEN OTHERS THEN
                            --RAISE l_exce_main;
                            p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                        END;
                    END IF;
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
                        'RET'
                        ,'5'||'~'||p_i_v_bkg_number
                        ,'A'
                        ,'TEST'
                        ,SYSDATE
                        ,'TEST'
                        ,SYSDATE
                    );
                    --commit;
*/
                    l_v_bkg_list := p_i_v_bkg_list;
                        BEGIN
                            INSERT INTO BKG_ROB_CONTAINER(
                            PK_ROB_CONTAINER_ID,
                            FK_RETURN_SHIPMENT_ID,
                            CONTAINER_NUMBER,
                            FK_ARRIVAL_BOOKING_NUMBER,
                            FK_DEPARTURE_BOOKING_NUMBER,
                            STOWAGE_POSITION,
                            RECORD_STATUS,
                            RECORD_ADD_USER,
                            RECORD_ADD_DATE,
                            RECORD_CHANGE_USER,
                            RECORD_CHANGE_DATE)
                            VALUES(
                            SE_RCZ01.NEXTVAL,
                            l_n_returnid,  --Review 2
                            l_cur_tos_dl.DN_EQUIPMENT_NO,
                            l_cur_tos_dl.FK_BOOKING_NO,
                            p_i_v_bkg_number,
                            l_v_stw_pos,
                            'A',     -- Review 5 p_i_v_rcrd_status,
                            l_v_user,
                            l_d_time,
                            l_v_user,
                            l_d_time);
                        EXCEPTION
                            WHEN OTHERS THEN
                            --RAISE l_exce_main;
                            p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                        END;
                        IF l_v_coc='C' AND l_v_load_cn='F' AND l_v_shpmnt_ty !='BB' THEN
                            l_v_sql_id := 'SQL
							-00005';
                            --1 check it
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
                                'RET'
                                ,'6'||'~'||p_i_v_bkg_number
                                ,'A'
                                ,'TEST'
                                ,SYSDATE
                                ,'TEST'
                                ,SYSDATE
                            );
                            --commit;
							*/
                            /*
                            BEGIN
                                INSERT INTO BKP030 (
                                BNBKNO,
                                BNCSTP,
                                BNCSCD,
                                BNLINE,
                                BNTRAD,
                                BNAGNT,
                                BNNAME,
                                EXP_DET_BILLTO,
                                IMP_DET_DEM_BILLTO,
                                BNADD1,
                                BNADD2,
                                BNADD3,
                                BNADD4,
                                CITY,
                                STATE,
                                BNCOUN,
                                BNZIP,
                                BNTELN,
                                BNFAX,
                                BNEMAL,
                                BNRCST,
                                BNAUSR,
                                BNADAT,
                                BNATIM,
                                BNCUSR,
                                BNCDAT,
                                BNCTIM
                                )
                                SELECT p_i_v_bkg_number,
                                'S',
                                CYCUST,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                CYNAME,
                                EXP_DET_BILLTO,
                                IMP_DET_DEM_BILLTO,
                                CYADD1,
                                CYADD2,
                                CYADD3,
                                CYADD4,
                                CITY,
                                STATE,
                                COUNTRY_CODE,
                                ZIP,
                                CYTELN,
                                CYFAXN,
                                EMAIL_ID,
                                CYRCST,
                                CYAUSR,
                                CYADAT,
                                CYATIM,
                                l_v_user,
                                l_v_date,
                                l_v_time
                                FROM IDP030
                                WHERE CYRCTP='C'
                                AND CYBLNO= p_i_v_bkg_list;          -- l_cur_bkg_data.TYBKNO; --Review 7  l_cur_tos_dl.FK_BOOKING_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            --FOR 'C' CONSIGNEE
                            BEGIN
                                INSERT INTO BKP030(
                                BNBKNO,
                                BNCSTP,
                                BNCSCD,
                                BNLINE,
                                BNTRAD,
                                BNAGNT,
                                BNNAME,
                                EXP_DET_BILLTO,
                                IMP_DET_DEM_BILLTO,
                                BNADD1,
                                BNADD2,
                                BNADD3,
                                BNADD4,
                                CITY,
                                STATE,
                                BNCOUN,
                                BNZIP,
                                BNTELN,
                                BNFAX,
                                BNEMAL,
                                BNRCST,
                                BNAUSR,
                                BNADAT,
                                BNATIM,
                                BNCUSR,
                                BNCDAT,
                                BNCTIM
                                )
                                SELECT p_i_v_bkg_number,
                                'C',
                                CYCUST,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                CYNAME,
                                EXP_DET_BILLTO,
                                IMP_DET_DEM_BILLTO,
                                CYADD1,
                                CYADD2,
                                CYADD3,
                                CYADD4,
                                CITY,
                                STATE,
                                COUNTRY_CODE,
                                ZIP,
                                CYTELN,
                                CYFAXN,
                                EMAIL_ID,
                                CYRCST,
                                CYAUSR,
                                CYADAT,
                                CYATIM,
                                l_v_user,
                                l_v_date,
                                l_v_time
                                FROM IDP030
                                WHERE CYRCTP='S'
                                AND CYBLNO= p_i_v_bkg_list;  --- l_cur_bkg_data.TYBKNO; --Review 7  l_cur_tos_dl.FK_BOOKING_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            */

                            BEGIN
                                l_v_sql_id := 'SQL-00051';
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
                                    'RET'
                                    ,l_v_sql_id||'~'||p_i_v_bkg_number
                                    ,'A'
                                    ,'TEST'
                                    ,SYSDATE
                                    ,'TEST'
                                    ,SYSDATE
                                );
                                --commit;
*/
                                /* vikas: change block start for bug# 562 as suggested by watcharee, on 17.10.2011 */
                                /* delete the new booking data. *
                                DELETE FROM BOOKING_SUPPLIER_DETAIL
                                WHERE BOOKING_NO       = p_i_v_bkg_number
                                AND   EQ_SIZE          = l_cur_tos_dl.dn_eq_size
                                AND   EQ_TYPE          = l_cur_tos_dl.dn_eq_type
                                AND   SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl;
                                */

                                /* vikas: change block end */

                                l_v_sql_id := 'SQL-00052';
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
                                    'RET'
                                    ,l_v_sql_id||'~'||p_i_v_bkg_number
                                    ,'A'
                                    ,'TEST'
                                    ,SYSDATE
                                    ,'TEST'
                                    ,SYSDATE
                                );
                                --commit;
*/
                                /* Block Start to get supplier sequence# for new booking from bkp032 as suggested by K'Myo, 26.10.2011 by vikas*/
                                BEGIN
                                    l_v_sql_id := 'SQL-0052A';
                                    SELECT EQP_SIZETYPE_SEQNO
                                    INTO   l_v_eqp_sizetype_seqno
                                    FROM   BKP032
                                    WHERE  BCBKNO           = p_i_v_bkg_number       -- AS suggest by k'myo 02.11.2011
                                    AND    BCSIZE           = l_cur_tos_dl.dn_eq_size -- AS suggest by k'myo 03.11.2011
                                    AND    BCTYPE           = l_cur_tos_dl.dn_eq_type  -- AS suggest by k'myo 03.11.2011
                                    AND    SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl -- AS suggest by k'myo 03.11.2011
                                    AND    ROWNUM = 1;
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
                                END;
                                /* Block End to get supplier sequence# for new booking from bkp032 as suggested by K'Myo, 26.10.2011 by vikas*
                                DELETE FROM BOOKING_SUPPLIER_DETAIL
                                WHERE BOOKING_NO       = p_i_v_bkg_number
                                AND   EQ_SIZE          = l_cur_tos_dl.dn_eq_size
                                AND   EQ_TYPE          = l_cur_tos_dl.dn_eq_type
                                AND   SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl;
*/

                                /* clone the old booking data */
                                l_v_sql_id := 'SQL-0052B';
                                INSERT INTO BOOKING_SUPPLIER_DETAIL(
                                    BOOKING_NO,
                                    SUPPLIER_SQNO,  --SEQUENCE
                                    SELVL1,
                                    SELVL2,
                                    SELVL3,
                                    EQ_SIZE,
                                    EQ_TYPE,
                                    SPECIAL_HANDLING,
                                    SUPPLIER_CODE,
                                    SUPPLIER_LOCATION,
                                    POSITIONING_TERMINAL,
                                    POSITIONING_DATE,
                                    POSITIONING_TIME,
                                    FULL_QTY,
                                    EMPTY_QTY,
                                    DG_QTY,
                                    RF_QTY,
                                    OG_QTY,
                                    EQP_RESERVED,
                                    FORWARDING_AGENT,
                                    SERCST,
                                    SEAUSR,
                                    SEADAT,
                                    RECORD_ADD_TIME,
                                    SECUSR,
                                    SECDAT,
                                    RECORD_CHANGE_TIME,
                                    SHIPMENT_TYPE,
                                    SUPPLIER_NAME,
                                    FORWARDING_AGENT_NAME,
                                    HAUL_FROM_SHPR_LOC_YN,
                                    LOCATION_CODE,
                                    EQP_SIZETYPE_SEQNO)
                                SELECT p_i_v_bkg_number,
                                    SUPPLIER_SQNO,
                                    SELVL1,
                                    SELVL2,
                                    SELVL3,
                                    EQ_SIZE,
                                    EQ_TYPE,
                                    SPECIAL_HANDLING,
                                    SUPPLIER_CODE,
                                    SUPPLIER_LOCATION,
                                    POSITIONING_TERMINAL,
                                    POSITIONING_DATE,
                                    POSITIONING_TIME,
                                    FULL_QTY,
                                    EMPTY_QTY,
                                    DG_QTY,
                                    RF_QTY,
                                    OG_QTY,
                                    EQP_RESERVED,
                                    FORWARDING_AGENT,
                                    SERCST,
                                    SEAUSR,
                                    SEADAT,
                                    RECORD_ADD_TIME,
                                    l_v_user,
                                    l_v_date,
                                    l_v_time,
                                    SHIPMENT_TYPE,
                                    SUPPLIER_NAME,
                                    FORWARDING_AGENT_NAME,
                                    HAUL_FROM_SHPR_LOC_YN,
                                    LOCATION_CODE,
                                    l_v_eqp_sizetype_seqno  --- EQP_SIZETYPE_SEQNO
                                    FROM BOOKING_SUPPLIER_DETAIL
                                    WHERE BOOKING_NO       = l_cur_tos_dl.FK_BOOKING_NO
                                    AND   EQ_SIZE          = l_cur_tos_dl.dn_eq_size
                                    AND   EQ_TYPE          = l_cur_tos_dl.dn_eq_type
                                    AND   SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl;

                            EXCEPTION
                            WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
                            END;
                            --2
                            BEGIN
                                l_v_sql_id := 'SQL-00053';

                                /* vikas: change block start for bug# 562 as suggested by watcharee, on 17.10.2011 */
                                /* delete the new booking data. */
                                /* delete the old booking data *
                                DELETE FROM BKP009
                                WHERE BIBKNO = p_i_v_bkg_number;
                                /* vikas: change block end */

                                l_v_sql_id := 'SQL-00006';
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
                                    'RET'
                                    ,l_v_sql_id||'~'||p_i_v_bkg_number
                                    ,'A'
                                    ,'TEST'
                                    ,SYSDATE
                                    ,'TEST'
                                    ,SYSDATE
                                );
                                --commit;
*/
                                INSERT INTO BKP009 (
                                BICTRN,
                                MET_WEIGHT,
                                BIBKNO,
                                BISEQN,  --SEQUENCE
                                BILINE,
                                BITRAD,
                                BIAGNT,
                                SHIPMENT_TYPE,
                                SUPPLIER_SQNO,
                                POL_STAT,
                                POD_STAT,
                                BICUSR,
                                BICDAT,
                                BICTIM,
                                BIEORF,            -- added by vikas as requested by nim, 26.10.2011
                                SPECIAL_HANDLING,  -- added by vikas as requested by nim, 02.11.2011
                                SUPPLIER_CODE,     -- added by vikas as requested by nim, 02.11.2011
                                BICSZE,            -- added by vikas as requested by nim, 03.11.2011
                                BICNTP,            -- added by vikas as requested by nim, 03.11.2011
                                SUPPLIER_LOCATION, -- added by vikas as requested by nim, 03.11.2011
                                EQ_MAKE,           -- added by vikas as requested by nim, 03.11.2011
                                EQ_MODEL,          -- added by vikas as requested by nim, 03.11.2011
                                EQP_STATUS         -- added by vikas as requested by nim, 03.11.2011

                                )
                                SELECT  BICTRN,
                                MET_WEIGHT,
                                p_i_v_bkg_number,
                                BISEQN,
                                BILINE,
                                BITRAD,
                                BIAGNT,
                                SHIPMENT_TYPE,
                                SUPPLIER_SQNO,
                                POL_STAT,
                                POD_STAT,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                BIEORF,            -- added by vikas as requested by nim, 26.10.2011
                                SPECIAL_HANDLING,  -- added by vikas as requested by nim, 02.11.2011
                                SUPPLIER_CODE,       -- added by vikas as requested by nim, 02.11.2011
                                BICSZE,               -- added by vikas as requested by nim, 03.11.2011
                                BICNTP,             -- added by vikas as requested by nim, 03.11.2011
                                SUPPLIER_LOCATION, -- added by vikas as requested by nim, 03.11.2011
                                EQ_MAKE,           -- added by vikas as requested by nim, 03.11.2011
                                EQ_MODEL,          -- added by vikas as requested by nim, 03.11.2011
                                EQP_STATUS         -- added by vikas as requested by nim, 03.11.2011
                                FROM BKP009
                                WHERE BIBKNO=l_cur_tos_dl.FK_BOOKING_NO
                                and bicsze = l_cur_tos_dl.dn_eq_size
                                and bicntp =  l_cur_tos_dl.dn_eq_type
                                and special_handling =  l_cur_tos_dl.dn_special_hndl;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            --3
                            l_v_sql_id := 'SQL-00007';

                            /* START FOR TESTING ONLY */
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
                                'RET'
                                ,l_v_sql_id||'~'||p_i_v_bkg_number||'~'||l_cur_tos_dl.FK_BOOKING_NO
                                ,'A'
                                ,'TEST'
                                ,SYSDATE
                                ,'TEST'
                                ,SYSDATE
                            );
                            --commit;
							*/
                            /* END FOR TESTING ONLY */


                            BEGIN
                                INSERT INTO BKP050 (
                                BWCMCD,
                                COMMODITY_VALUE,
                                BWBKNO,
                                BWSHTP,
                                BWCMSQ,  --SEQUENCE
                                BWLINE,
                                BWTRAD,
                                BWAGNT,
                                BDCUSR,
                                BDCDAT,
                                BDCTIM,
                                SPECIAL_HANDLING)
                                SELECT BWCMCD,
                                COMMODITY_VALUE,
                                p_i_v_bkg_number,
                                BWSHTP,
                                BWCMSQ,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                SPECIAL_HANDLING
                                FROM BKP050
                                WHERE BWBKNO=l_cur_tos_dl.FK_BOOKING_NO
                                AND   SPECIAL_HANDLING = l_cur_bkg_data.SPECIAL_HANDLING;

                            EXCEPTION
                                WHEN DUP_VAL_ON_INDEX THEN
                                    NULL;
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            --4
                            l_v_sql_id := 'SQL-00008';
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
                                'RET'
                                ,l_v_sql_id||'~'||p_i_v_bkg_number||'~'||l_cur_tos_dl.FK_BOOKING_NO
                                ,'A'
                                ,'TEST'
                                ,SYSDATE
                                ,'TEST'
                                ,SYSDATE
                            );
                            --commit;
*/
                            /* delete new booking data from BOOKING_DG_COMM_DETAIL and
                            clone old booking data with new booking # asn suggested by nim , myo 01.11.2011*/

                            DELETE FROM BOOKING_DG_COMM_DETAIL
                            WHERE BOOKING_NO = p_i_v_bkg_number;

                            BEGIN
                                INSERT INTO BOOKING_DG_COMM_DETAIL(
                                UN_NO,
                                UN_VARIANT,
                                BOOKING_NO,
                                SHIPMENT_TYPE,
                                COMMODITY_SQNO,  --SEQUENCE
                                BBLVL1,
                                BBLVL2,
                                BBLVL3,
                                BBCUSR,
                                BBCDAT,
                                RECORD_CHANGE_TIME,
                                imo_class)
                                SELECT UN_NO,
                                UN_VARIANT,
                                p_i_v_bkg_number,
                                SHIPMENT_TYPE,
                                COMMODITY_SQNO,
                                BBLVL1,
                                BBLVL2,
                                BBLVL3,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                imo_class
                                FROM BOOKING_DG_COMM_DETAIL BOOKDG,BKP050
                                WHERE BWBKNO=l_cur_tos_dl.FK_BOOKING_NO
                                AND BKP050.BWBKNO = BOOKDG.BOOKING_NO
                                AND BKP050.BWSHTP = BOOKDG.SHIPMENT_TYPE
                                AND BKP050.BWCMSQ = BOOKDG.COMMODITY_SQNO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            --5
                            l_v_sql_id := 'SQL-00009';
                            BEGIN
                                INSERT INTO BOOKING_OG_COMM_DETAIL(
                                BOOKING_NO,
                                COMMODITY_SQNO, --SEQUENCE
                                SHIPMENT_TYPE,
                                BBLVL1,
                                BBLVL2,
                                BBLVL3,
                                OG_LENGTH,
                                OG_WIDTH,
                                OG_HEIGHT,
                                RECORD_CHANGE_USER,
                                RECORD_CHANGE_DATE,
                                RECORD_CHANGE_TIME)
                                SELECT p_i_v_bkg_number,
                                COMMODITY_SQNO,
                                SHIPMENT_TYPE,
                                BBLVL1,
                                BBLVL2,
                                BBLVL3,
                                OG_LENGTH,
                                OG_WIDTH,
                                OG_HEIGHT,
                                l_v_user,
                                l_v_date,
                                l_v_time
                                FROM BOOKING_OG_COMM_DETAIL BOOKOG,BKP050
                                WHERE BWBKNO=l_cur_tos_dl.FK_BOOKING_NO
                                AND BKP050.BWBKNO = BOOKOG.BOOKING_NO
                                AND BKP050.BWSHTP = BOOKOG.SHIPMENT_TYPE
                                AND BKP050.BWCMSQ = BOOKOG.COMMODITY_SQNO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            --6
                            l_v_sql_id := 'SQL-00010';
                            BEGIN
                                INSERT INTO BOOKING_RFR_COMM_DETAIL(
                                BOOKING_NO,
                                SHIPMENT_TYPE,
                                COMMODITY_SQNO,  --SEQUENCE
                                BBLVL1,
                                BBLVL2,
                                BBLVL3,
                                REEFER_FROM,
                                REEFER_BS,
                                VENTILATION,
                                HUMIDITY,
                                RECORD_CHANGE_USER,
                                RECORD_CHANGE_DATE,
                                RECORD_CHANGE_TIME)
                                SELECT p_i_v_bkg_number,
                                SHIPMENT_TYPE,
                                COMMODITY_SQNO,
                                BBLVL1,
                                BBLVL2,
                                BBLVL3,
                                REEFER_FROM,
                                REEFER_BS,
                                VENTILATION,
                                HUMIDITY,
                                l_v_user,
                                l_v_date,
                                l_v_time
                                FROM BOOKING_RFR_COMM_DETAIL BOOKRFR,BKP050
                                WHERE BWBKNO=l_cur_tos_dl.FK_BOOKING_NO
                                AND BKP050.BWBKNO = BOOKRFR.BOOKING_NO
                                AND BKP050.BWSHTP = BOOKRFR.SHIPMENT_TYPE
                                AND BKP050.BWCMSQ = BOOKRFR.COMMODITY_SQNO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            --7
                            l_v_sql_id := 'SQL-00011';
                            BEGIN
                                UPDATE BKP001
                                SET BACUSR = l_v_user,
                                BACDAT = l_v_date
                                WHERE BABKNO = p_i_v_bkg_number;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            -- INSERT RECORD IN BKP032 AND BOOKING_SUPPLIER_DETAIL ALSO AS PER HEMLATA
                            --INSERT INTO BKP032


                            l_v_sql_id := 'SQL-00012';
                            /*
                            BEGIN
                                INSERT INTO BKP032(
                                BCBKNO,
                                EQP_SIZETYPE_SEQNO,  --SEQUENCE
                                BCLINE,
                                BCTRAD,
                                BCAGNT,
                                BCSIZE,
                                BCTYPE,
                                SPECIAL_HANDLING,
                                BCTEUS,
                                BCFQTY,
                                BCDQTY,
                                BCRQTY,
                                REEFER_POINTS,
                                BCOQTY,
                                BCEQTY,
                                BCSTAT,
                                DEMURRAGE_FREEDAYS,
                                EXP_DETENTION_FREEDAYS,
                                IMP_DETENTION_FREEDAYS,
                                BCRCST,
                                BCAUSR,
                                BCADAT,
                                BCATIM,
                                BCCUSR,
                                BCCDAT,
                                BCCTIM,
                                KILLED_SLOTS,
                                SHIPMENT_TYPE,
                                SPECIAL_CARGO_CODE,
                                HANDLING_INS1,
                                HANDLING_INS2,
                                HANDLING_INS3,
                                CLR_CODE1,
                                CLR_CODE2,
                                CHASSIS_REQUIRED_YN,
                                BUNDLE,
                                POL_STAT,
                                POD_STAT,
                                OPR_VOID_SLOT)
                                SELECT p_i_v_bkg_number,
                                EQP_SIZETYPE_SEQNO,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                BCSIZE,
                                BCTYPE,
                                SPECIAL_HANDLING,
                                BCTEUS,
                                BCFQTY,
                                BCDQTY,
                                BCRQTY,
                                REEFER_POINTS,
                                BCOQTY,
                                BCEQTY,
                                BCSTAT,
                                DEMURRAGE_FREEDAYS,
                                EXP_DETENTION_FREEDAYS,
                                IMP_DETENTION_FREEDAYS,
                                BCRCST,
                                BCAUSR,
                                BCADAT,
                                BCATIM,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                KILLED_SLOTS,
                                SHIPMENT_TYPE,
                                SPECIAL_CARGO_CODE,
                                HANDLING_INS1,
                                HANDLING_INS2,
                                HANDLING_INS3,
                                CLR_CODE1,
                                CLR_CODE2,
                                CHASSIS_REQUIRED_YN,
                                BUNDLE,
                                POL_STAT,
                                POD_STAT,
                                OPR_VOID_SLOT
                                FROM BKP032
                                WHERE BCBKNO=l_cur_tos_dl.FK_BOOKING_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            */
                            /* not to update bkp032 as suggest by k'myo and k'watcharee, on 02.11.2011 *
                            FOR i_cur_update_qty in l_cur_update_qty(l_cur_bkg_data.TYBKNO)  --Review 9
                            LOOP
                                UPDATE BKP032
                                SET BCEQTY=i_cur_update_qty.BCQT, BCTEUS=i_cur_update_qty.BCEUS
                                WHERE BCSIZE=i_cur_update_qty.BCSIZE
                                AND BCTYPE = i_cur_update_qty.BCTYPE
                                AND BCBKNO = p_i_v_bkg_number; --Review 12
                            END LOOP;
                            */
                            l_v_sql_id := 'SQL-00013';
                            --INSERT INTO BOOKING_SUPPLIER_DETAILS

                                /*

                            BEGIN
                                IF p_i_v_rcrd_status <> 'R' THEN
                                    INSERT INTO BOOKING_SUPPLIER_DETAIL(
                                    BOOKING_NO,
                                    SUPPLIER_SQNO,  --SEQUENCE
                                    SELVL1,
                                    SELVL2,
                                    SELVL3,
                                    EQ_SIZE,
                                    EQ_TYPE,
                                    SPECIAL_HANDLING,
                                    SUPPLIER_CODE,
                                    SUPPLIER_LOCATION,
                                    POSITIONING_TERMINAL,
                                    POSITIONING_DATE,
                                    POSITIONING_TIME,
                                    FULL_QTY,
                                    EMPTY_QTY,
                                    DG_QTY,
                                    RF_QTY,
                                    OG_QTY,
                                    EQP_RESERVED,
                                    FORWARDING_AGENT,
                                    SERCST,
                                    SEAUSR,
                                    SEADAT,
                                    RECORD_ADD_TIME,
                                    SECUSR,
                                    SECDAT,
                                    RECORD_CHANGE_TIME,
                                    SHIPMENT_TYPE,
                                    SUPPLIER_NAME,
                                    FORWARDING_AGENT_NAME,
                                    HAUL_FROM_SHPR_LOC_YN,
                                    LOCATION_CODE,
                                    EQP_SIZETYPE_SEQNO)
                                    SELECT p_i_v_bkg_number,
                                    SUPPLIER_SQNO,
                                    SELVL1,
                                    SELVL2,
                                    SELVL3,
                                    EQ_SIZE,
                                    EQ_TYPE,
                                    SPECIAL_HANDLING,
                                    SUPPLIER_CODE,
                                    SUPPLIER_LOCATION,
                                    POSITIONING_TERMINAL,
                                    POSITIONING_DATE,
                                    POSITIONING_TIME,
                                    FULL_QTY,
                                    EMPTY_QTY,
                                    DG_QTY,
                                    RF_QTY,
                                    OG_QTY,
                                    EQP_RESERVED,
                                    FORWARDING_AGENT,
                                    SERCST,
                                    SEAUSR,
                                    SEADAT,
                                    RECORD_ADD_TIME,
                                    l_v_user,
                                    l_v_date,
                                    l_v_time,
                                    SHIPMENT_TYPE,
                                    SUPPLIER_NAME,
                                    FORWARDING_AGENT_NAME,
                                    HAUL_FROM_SHPR_LOC_YN,
                                    LOCATION_CODE,
                                    EQP_SIZETYPE_SEQNO
                                    FROM BOOKING_SUPPLIER_DETAIL
                                    WHERE BOOKING_NO = l_cur_tos_dl.FK_BOOKING_NO;

                                END IF;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            */
                        ELSIF l_v_coc='C' AND l_v_load_cn='F' AND l_v_shpmnt_ty ='BB' THEN
                            --1
                            /*
                            l_v_sql_id := 'SQL-00014';

                            BEGIN
                                INSERT INTO BKP030 (
                                BNBKNO,
                                BNCSTP,
                                BNCSCD,
                                BNLINE,
                                BNTRAD,
                                BNAGNT,
                                BNNAME,
                                BNADD1,
                                BNADD2,
                                BNADD3,
                                BNADD4,
                                CITY,
                                STATE,
                                BNCOUN,
                                BNZIP,
                                BNTELN,
                                BNFAX,
                                BNEMAL,
                                BNRCST,
                                BNAUSR,
                                BNADAT,
                                BNATIM,
                                BNCUSR,
                                BNCDAT,
                                BNCTIM
                                )
                                SELECT p_i_v_bkg_number,
                                'S',
                                CUCUST,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                CUNAME,
                                CUADD1,
                                CUADD2,
                                CUADD3,
                                CUADD4,
                                CUCITY,
                                CUSTAT,
                                CUCOUN,
                                CUZIP,
                                CUTELE,
                                CUFAX,
                                CUEMAIL,
                                CURCST,
                                CUAUSR,
                                CUADAT,
                                CUATIM,
                                l_v_user,
                                l_v_date,
                                l_v_time
                                FROM ITP0TD, ITP010
                                WHERE SGTRAD='*'
                                AND SGLINE='R'
                                AND LINER_CUSTOMER_CODE = CUCUST;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            --FOR 'C' CONSIGNEE
                            BEGIN
                                INSERT INTO BKP030 (
                                BNBKNO,
                                BNCSTP,
                                BNCSCD,
                                BNLINE,
                                BNTRAD,
                                BNAGNT,
                                BNNAME,
                                BNADD1,
                                BNADD2,
                                BNADD3,
                                BNADD4,
                                CITY,
                                STATE,
                                BNCOUN,
                                BNZIP,
                                BNTELN,
                                BNFAX,
                                BNEMAL,
                                BNRCST,
                                BNAUSR,
                                BNADAT,
                                BNATIM,
                                BNCUSR,
                                BNCDAT,
                                BNCTIM
                                )
                                SELECT p_i_v_bkg_number,
                                'C',
                                CUCUST,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                CUNAME,
                                CUADD1,
                                CUADD2,
                                CUADD3,
                                CUADD4,
                                CUCITY,
                                CUSTAT,
                                CUCOUN,
                                CUZIP,
                                CUTELE,
                                CUFAX,
                                CUEMAIL,
                                CURCST,
                                CUAUSR,
                                CUADAT,
                                CUATIM,
                                l_v_user,
                                l_v_date,
                                l_v_time
                                FROM ITP0TD, ITP010
                                WHERE SGTRAD='*'
                                AND SGLINE='R'
                                AND LINER_CUSTOMER_CODE = CUCUST;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            */
                            --2
                            --INSERT INTO BKP032
                            l_v_sql_id := 'SQL-00015';
                            BEGIN
                                INSERT INTO BKP032(
                                BCBKNO,
                                EQP_SIZETYPE_SEQNO,  --SEQUENCE
                                BCLINE,
                                BCTRAD,
                                BCAGNT,
                                BCSIZE,
                                BCTYPE,
                                SPECIAL_HANDLING,
                                BCTEUS,
                                BCFQTY,
                                BCDQTY,
                                BCRQTY,
                                REEFER_POINTS,
                                BCOQTY,
                                BCEQTY,
                                BCSTAT,
                                DEMURRAGE_FREEDAYS,
                                EXP_DETENTION_FREEDAYS,
                                IMP_DETENTION_FREEDAYS,
                                BCRCST,
                                BCAUSR,
                                BCADAT,
                                BCATIM,
                                BCCUSR,
                                BCCDAT,
                                BCCTIM,
                                KILLED_SLOTS,
                                SHIPMENT_TYPE,
                                SPECIAL_CARGO_CODE,
                                HANDLING_INS1,
                                HANDLING_INS2,
                                HANDLING_INS3,
                                CLR_CODE1,
                                CLR_CODE2,
                                CHASSIS_REQUIRED_YN,
                                BUNDLE,
                                POL_STAT,
                                POD_STAT,
                                OPR_VOID_SLOT)
                                SELECT p_i_v_bkg_number,
                                EQP_SIZETYPE_SEQNO,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                BCSIZE,
                                BCTYPE,
                                SPECIAL_HANDLING,
                                BCTEUS,
                                BCFQTY,
                                BCDQTY,
                                BCRQTY,
                                REEFER_POINTS,
                                BCOQTY,
                                BCEQTY,
                                BCSTAT,
                                DEMURRAGE_FREEDAYS,
                                EXP_DETENTION_FREEDAYS,
                                IMP_DETENTION_FREEDAYS,
                                BCRCST,
                                BCAUSR,
                                BCADAT,
                                BCATIM,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                KILLED_SLOTS,
                                SHIPMENT_TYPE,
                                SPECIAL_CARGO_CODE,
                                HANDLING_INS1,
                                HANDLING_INS2,
                                HANDLING_INS3,
                                CLR_CODE1,
                                CLR_CODE2,
                                CHASSIS_REQUIRED_YN,
                                BUNDLE,
                                POL_STAT,
                                POD_STAT,
                                OPR_VOID_SLOT
                                FROM BKP032
                                WHERE BCBKNO=l_cur_tos_dl.FK_BOOKING_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            /* not to update bkp032 as suggest by k'myo and k'watcharee, on 02.11.2011 *
                            FOR i_cur_update_qty in l_cur_update_qty(l_cur_bkg_data.TYBKNO)
                            LOOP
                                UPDATE BKP032
                                SET BCEQTY  =i_cur_update_qty.BCQT
                                    , BCTEUS=i_cur_update_qty.BCEUS
                                WHERE BCSIZE=i_cur_update_qty.BCSIZE
                                AND BCTYPE = i_cur_update_qty.BCTYPE
                                AND BCBKNO = p_i_v_bkg_number; --Review 12
                            END LOOP;
*/
                            l_v_sql_id := 'SQL-0016A';
                            --INSERT INTO BOOKING_SUPPLIER_DETAILS
                            /* Commented by vikas as it cause data is already insreted into
                                BOOKING_SUPPLIER_DETAIL table. */

                            /* Block Start to get supplier sequence# for new booking from bkp032 as suggested by K'Myo, 26.10.2011 by vikas*/
                            BEGIN
                                SELECT EQP_SIZETYPE_SEQNO
                                INTO   l_v_eqp_sizetype_seqno
                                FROM   BKP032
                                WHERE  BCBKNO           = p_i_v_bkg_number      -- AS suggest by k'myo 03.11.2011
                                AND    BCSIZE           = l_cur_tos_dl.dn_eq_size -- AS suggest by k'myo 03.11.2011
                                AND    BCTYPE           = l_cur_tos_dl.dn_eq_type  -- AS suggest by k'myo 03.11.2011
                                AND    SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl -- AS suggest by k'myo 03.11.2011
                                AND    ROWNUM = 1;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                    RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
                            END;
                            /* Block End to get supplier sequence# for new booking from bkp032 as suggested by K'Myo, 26.10.2011 by vikas*/
/*
                            DELETE FROM BOOKING_SUPPLIER_DETAIL
                            WHERE BOOKING_NO       = p_i_v_bkg_number
                            AND   EQ_SIZE          = l_cur_tos_dl.dn_eq_size
                            AND   EQ_TYPE          = l_cur_tos_dl.dn_eq_type
                            AND   SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl;
*/
                            l_v_sql_id := 'SQL-0016B';
                            BEGIN
                                INSERT INTO BOOKING_SUPPLIER_DETAIL(
                                BOOKING_NO,
                                SUPPLIER_SQNO,  --SEQUENCE
                                SELVL1,
                                SELVL2,
                                SELVL3,
                                EQ_SIZE,
                                EQ_TYPE,
                                SPECIAL_HANDLING,
                                SUPPLIER_CODE,
                                SUPPLIER_LOCATION,
                                POSITIONING_TERMINAL,
                                POSITIONING_DATE,
                                POSITIONING_TIME,
                                FULL_QTY,
                                EMPTY_QTY,
                                DG_QTY,
                                RF_QTY,
                                OG_QTY,
                                EQP_RESERVED,
                                FORWARDING_AGENT,
                                SERCST,
                                SEAUSR,
                                SEADAT,
                                RECORD_ADD_TIME,
                                SECUSR,
                                SECDAT,
                                RECORD_CHANGE_TIME,
                                SHIPMENT_TYPE,
                                SUPPLIER_NAME,
                                FORWARDING_AGENT_NAME,
                                HAUL_FROM_SHPR_LOC_YN,
                                LOCATION_CODE,
                                EQP_SIZETYPE_SEQNO)
                                SELECT p_i_v_bkg_number,
                                SUPPLIER_SQNO,
                                SELVL1,
                                SELVL2,
                                SELVL3,
                                EQ_SIZE,
                                EQ_TYPE,
                                SPECIAL_HANDLING,
                                SUPPLIER_CODE,
                                SUPPLIER_LOCATION,
                                POSITIONING_TERMINAL,
                                POSITIONING_DATE,
                                POSITIONING_TIME,
                                FULL_QTY,
                                EMPTY_QTY,
                                DG_QTY,
                                RF_QTY,
                                OG_QTY,
                                EQP_RESERVED,
                                FORWARDING_AGENT,
                                SERCST,
                                SEAUSR,
                                SEADAT,
                                RECORD_ADD_TIME,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                SHIPMENT_TYPE,
                                SUPPLIER_NAME,
                                FORWARDING_AGENT_NAME,
                                HAUL_FROM_SHPR_LOC_YN,
                                LOCATION_CODE,
                                l_v_eqp_sizetype_seqno -- EQP_SIZETYPE_SEQNO
                                FROM BOOKING_SUPPLIER_DETAIL
                                WHERE BOOKING_NO       = l_cur_tos_dl.FK_BOOKING_NO
                                AND   EQ_SIZE          = l_cur_tos_dl.dn_eq_size
                                AND   EQ_TYPE          = l_cur_tos_dl.dn_eq_type
                                AND   SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl;

                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            BEGIN    --Review 15.1
                                SELECT EQWGHT
                                INTO l_n_wght
                                FROM ECP010
                                WHERE EQEQTN = l_cur_tos_dl.DN_EQUIPMENT_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
                            END;

                            /* vikas: change block start for bug# 562 as suggested by watcharee, on 17.10.2011 */
                            /* delete the new booking data. */
                            /* delete the old booking data *
                            DELETE FROM BKP009
                            WHERE BIBKNO = p_i_v_bkg_number;
                            /* vikas: change block end */

                            --INSERT INTO BKP009
                            BEGIN
                                INSERT INTO BKP009(
                                BIBKNO,
                                BISEQN,  --SEQUENCE
                                BILINE,
                                BITRAD,
                                BIAGNT,
                                SHIPMENT_TYPE,
                                BICTRN,
                                BICSZE,
                                BICNTP,
                                SPECIAL_HANDLING,
                                SUPPLIER_CODE,
                                POSITIONING_TERMINAL,
                                POSITIONING_DATE,
                                EQP_STATUS,
                                SUPPLIER_LOCATION,
                                BIEORF,
                                DEMURRAGE_FREEDAYS,
                                SHIPPER_SEAL,
                                IMP_WEIGHT,
                                MET_WEIGHT,
                                IMP_MEASUREMENT,
                                MET_MEASUREMENT,
                                PACKAGE_KIND,
                                JOB_ORDER_ID,
                                ROUTING_REF,
                                DISPATCH_DATE,
                                DISPATCH_TIME,
                                EXP_DETENTION_FREEDAYS,
                                IMP_DETENTION_FREEDAYS,
                                OPEN_DOOR,
                                EQ_MAKE,
                                EQ_MODEL,
                                YEAR_BUILD,
                                EQ_COLOR,
                                POSITIONING_TIME,
                                DOOR_AJAR,
                                NON_REEFER_CARGO,
                                NO_OF_AXLES,
                                BIRCST,
                                BIAUSR,
                                BIADAT,
                                BIATIM,
                                BICUSR,
                                BICDAT,
                                BICTIM,
                                SUPPLIER_SQNO,
                                POL_STAT,
                                POD_STAT
                                )
                                SELECT p_i_v_bkg_number,
                                BISEQN,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                SHIPMENT_TYPE,
                                BICTRN,
                                BICSZE,
                                BICNTP,
                                SPECIAL_HANDLING,
                                SUPPLIER_CODE,
                                POSITIONING_TERMINAL,
                                POSITIONING_DATE,
                                EQP_STATUS,
                                SUPPLIER_LOCATION,
                                'E',
                                DEMURRAGE_FREEDAYS,
                                SHIPPER_SEAL,
                                IMP_WEIGHT,
                                l_n_wght,
                                IMP_MEASUREMENT,
                                MET_MEASUREMENT,
                                PACKAGE_KIND,
                                JOB_ORDER_ID,
                                ROUTING_REF,
                                DISPATCH_DATE,
                                DISPATCH_TIME,
                                EXP_DETENTION_FREEDAYS,
                                IMP_DETENTION_FREEDAYS,
                                OPEN_DOOR,
                                EQ_MAKE,
                                EQ_MODEL,
                                YEAR_BUILD,
                                EQ_COLOR,
                                POSITIONING_TIME,
                                DOOR_AJAR,
                                NON_REEFER_CARGO,
                                NO_OF_AXLES,
                                BIRCST,
                                BIAUSR,
                                BIADAT,
                                BIATIM,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                SUPPLIER_SQNO,
                                POL_STAT,
                                POD_STAT
                                FROM BKP009
                                WHERE BIBKNO=l_cur_tos_dl.FK_BOOKING_NO
                                and bicsze = l_cur_tos_dl.dn_eq_size
                                and bicntp =  l_cur_tos_dl.dn_eq_type
                                and special_handling =  l_cur_tos_dl.dn_special_hndl;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            --3
                            l_v_sql_id := 'SQL-00017';
                            --INSERT INTO BKP050 TABLE
                            l_n_bwcmsq := l_n_bwcmsq+1;

                            l_v_sql_id := 'SQL-0007a';

                            /* START FOR TESTING ONLY */
                             l_arr_var_name := STRING_ARRAY
                             ('p_i_v_bkg_number', 'FK_BOOKING_NO', 'l_n_bwcmsq'
                              );

                              l_arr_var_value := STRING_ARRAY
                             (p_i_v_bkg_number         , l_cur_tos_dl.FK_BOOKING_NO , l_n_bwcmsq);

                              l_arr_var_io := STRING_ARRAY
                             ('I'      , 'I'    , 'I');

                             PRE_LOG_INFO
                              ('RETURN '
                             , 'BKP050'
                             , l_v_sql_id
                             , l_v_user
                             , SYSDATE
                             , NULL
                             , l_arr_var_name
                             , l_arr_var_value
                             , l_arr_var_io
                              );
                            /* END FOR TESTING ONLY */

                            /* Delete new booking data for DG commodity, as suggest by k'myo , k'nim on 02.11.2011 */
                            DELETE FROM BKP050
                            WHERE BWBKNO = p_i_v_bkg_number;

                            BEGIN

                                INSERT INTO BKP050(
                                BWBKNO,
                                BWSHTP,
                                BWCMSQ,  --SEQUENCE
                                BWLINE,
                                BWTRAD,
                                BWAGNT,
                                BWCMCD,
                                --BWIMWT,BWIMMS,BWMTWT,BWMTMS,BWFARA,BWCATG,BWPKND,KILLED_SLOTS,BWREFR,BWDANG,
                                --BWOGFL,COMMODITY_VALUE,COMMODITY_VALUE_CURR,BWPORM,BWPCKG,NET_WEIGHT,NET_MSMT,BWRCST
                                BWAUSR,
                                BWADAT,
                                BWATIM,
                                BDCUSR,
                                BDCDAT,
                                BDCTIM,
                                COMM_DESC,
                                --SPECIAL_HANDLING
                                COMMODITY_GROUP_CODE
                                --TARIFF_EXISTS,DG_TYPE,OG_TYPE,OPEN_DOOR,DOOR_AJAR
                                --BBK_LENGTH,BBK_HEIGHT,BBK_WIDTH,BBK_DIAMETER
                                )
                                VALUES(
                                p_i_v_bkg_number,
                                'BCL',
                                l_n_bwcmsq,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                l_v_stcmcd,
                                --BWIMWT,BWIMMS,BWMTWT,BWMTMS,BWFARA,BWCATG,BWPKND,KILLED_SLOTS,BWREFR,BWDANG,
                                --BWOGFL,COMMODITY_VALUE,COMMODITY_VALUE_CURR,BWPORM,BWPCKG,NET_WEIGHT,NET_MSMT,BWRCST
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                l_v_fcdesc,
                                --SPECIAL_HANDLING
                                l_v_com_grpcd
                                --TARIFF_EXISTS,DG_TYPE,OG_TYPE,OPEN_DOOR,DOOR_AJAR
                                --BBK_LENGTH,BBK_HEIGHT,BBK_WIDTH,BBK_DIAMETER
                                );
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                        ELSIF l_v_coc='C' AND l_v_load_cn='E' THEN
                            --1
                            /*
                            l_v_sql_id := 'SQL-00018';
                            BEGIN
                                INSERT INTO BKP030 (
                                BNBKNO,
                                BNCSTP,
                                BNCSCD,
                                BNLINE,
                                BNTRAD,
                                BNAGNT,
                                BNNAME,
                                BNADD1,
                                BNADD2,
                                BNADD3,
                                BNADD4,
                                CITY,
                                STATE,
                                BNCOUN,
                                BNZIP,
                                BNTELN,
                                BNFAX,
                                BNEMAL,
                                BNRCST,
                                BNAUSR,
                                BNADAT,
                                BNATIM,
                                BNCUSR,
                                BNCDAT,
                                BNCTIM
                                )
                                SELECT p_i_v_bkg_number,
                                CYRCTP,
                                CYCUST,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                CYNAME,
                                CYADD1,
                                CYADD2,
                                CYADD3,
                                CYADD4,
                                CITY,
                                STATE,
                                COUNTRY_CODE,
                                ZIP,
                                CYTELN,
                                CYFAXN,
                                EMAIL_ID,
                                CYRCST,
                                CYAUSR,
                                CYADAT,
                                CYATIM,
                                CYCUSR,
                                CYCDAT,
                                CYCTIM
                                FROM IDP030,ITP0TD
                                WHERE SGTRAD='*'
                                AND SGLINE='R'
                                AND LINER_CUSTOMER_CODE = CYCUST
                                AND CYRCTP='C'
                                AND CYBLNO=l_cur_bkg_data.TYBKNO; --Review 7  l_cur_tos_dl.FK_BOOKING_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            --For Shipment
                            BEGIN
                                INSERT INTO BKP030 (
                                BNBKNO,
                                BNCSTP,
                                BNCSCD,
                                BNLINE,
                                BNTRAD,
                                BNAGNT,
                                BNNAME,
                                BNADD1,
                                BNADD2,
                                BNADD3,
                                BNADD4,
                                CITY,
                                STATE,
                                BNCOUN,
                                BNZIP,
                                BNTELN,
                                BNFAX,
                                BNEMAL,
                                BNRCST,
                                BNAUSR,
                                BNADAT,
                                BNATIM,
                                BNCUSR,
                                BNCDAT,
                                BNCTIM
                                )
                                SELECT p_i_v_bkg_number,
                                CYRCTP,
                                CYCUST,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                CYNAME,
                                CYADD1,
                                CYADD2,
                                CYADD3,
                                CYADD4,
                                CITY,
                                STATE,
                                COUNTRY_CODE,
                                ZIP,
                                CYTELN,
                                CYFAXN,
                                EMAIL_ID,
                                CYRCST,
                                CYAUSR,
                                CYADAT,
                                CYATIM,
                                CYCUSR,
                                CYCDAT,
                                CYCTIM
                                FROM IDP030,ITP0TD
                                WHERE SGTRAD='*'
                                AND SGLINE='R'
                                AND LINER_CUSTOMER_CODE = CYCUST
                                AND CYRCTP='S'
                                AND CYBLNO=l_cur_bkg_data.TYBKNO; --Review 7  l_cur_tos_dl.FK_BOOKING_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            */

                            --2
                            l_v_sql_id := 'SQL-00019';
                            BEGIN
                                SELECT EQWGHT INTO l_v_eqwght
                                FROM ECP010
                                WHERE EQEQTN = l_cur_tos_dl.DN_EQUIPMENT_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            BEGIN

                                /* vikas: change block start for bug# 562 as suggested by watcharee, on 17.10.2011 */
                                /* delete the new booking data. */
                                /* delete the old booking data *
                                DELETE FROM BKP009
                                WHERE BIBKNO = p_i_v_bkg_number;
                                    /* vikas: change block end */

                                INSERT INTO BKP009 (
                                    BICTRN,
                                    MET_WEIGHT,  --check
                                    BIBKNO,
                                    BISEQN,  --SEQUENCE
                                    BILINE,
                                    BITRAD,
                                    BIAGNT,
                                    SHIPMENT_TYPE,
                                    SUPPLIER_SQNO,
                                    POL_STAT,
                                    POD_STAT,
                                    BIEORF,            -- added by vikas as requested by nim, 26.10.2011
                                    SPECIAL_HANDLING,  -- added by vikas as requested by nim, 02.11.2011
                                    SUPPLIER_CODE,     -- added by vikas as requested by nim, 02.11.2011
                                    BICSZE,            -- added by vikas as requested by nim, 03.11.2011
                                    BICNTP,            -- added by vikas as requested by nim, 03.11.2011
                                    SUPPLIER_LOCATION,  -- added by vikas as requested by nim, 03.11.2011
                                    EQ_MAKE,            -- added by vikas as requested by nim, 03.11.2011
                                    EQ_MODEL,           -- added by vikas as requested by nim, 03.11.2011
                                    EQP_STATUS          -- added by vikas as requested by nim, 03.11.2011

                                    )

                                SELECT  BICTRN,
                                    l_v_eqwght,
                                    p_i_v_bkg_number,
                                    BISEQN,
                                    l_v_biline,
                                    l_v_batrad,
                                    l_v_baagnt,
                                    SHIPMENT_TYPE,
                                    SUPPLIER_SQNO,
                                    POL_STAT,
                                    POD_STAT,
                                    BIEORF,            -- added by vikas as requested by nim, 26.10.2011
                                    SPECIAL_HANDLING,  -- added by vikas as requested by nim, 02.11.2011
                                    SUPPLIER_CODE,     -- added by vikas as requested by nim, 02.11.2011
                                    BICSZE,            -- added by vikas as requested by nim, 03.11.2011
                                    BICNTP,            -- added by vikas as requested by nim, 03.11.2011
                                    SUPPLIER_LOCATION, -- added by vikas as requested by nim, 03.11.2011
                                    EQ_MAKE,           -- added by vikas as requested by nim, 03.11.2011
                                    EQ_MODEL,          -- added by vikas as requested by nim, 03.11.2011
                                    EQP_STATUS         -- added by vikas as requested by nim, 03.11.2011

                                FROM BKP009
                                WHERE BIBKNO=l_cur_tos_dl.FK_BOOKING_NO
                                and bicsze = l_cur_tos_dl.dn_eq_size
                                and bicntp =  l_cur_tos_dl.dn_eq_type
                                and special_handling =  l_cur_tos_dl.dn_special_hndl;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            --3
                            l_v_sql_id := 'SQL-00017';

                            /* Delete new booking data for DG commodity, as suggest by k'myo , k'nim on 02.11.2011 */
                            DELETE FROM BKP050
                            WHERE BWBKNO = p_i_v_bkg_number;

                            BEGIN
                                INSERT INTO BKP050 (
                                BWCMCD,
                                COMMODITY_VALUE,
                                BWBKNO,
                                BWSHTP,
                                BWCMSQ,  --SEQUENCE
                                BWLINE,
                                BWTRAD,
                                BWAGNT,
                                SPECIAL_HANDLING)
                                SELECT
                                BWCMCD,
                                NULL,
                                p_i_v_bkg_number,
                                BWSHTP,
                                BWCMSQ,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                SPECIAL_HANDLING
                                FROM BKP050
                                WHERE BWBKNO=l_cur_tos_dl.FK_BOOKING_NO
                                AND   SPECIAL_HANDLING = l_cur_bkg_data.SPECIAL_HANDLING;

                            EXCEPTION
                                WHEN DUP_VAL_ON_INDEX THEN
                                    NULL;
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;

                            --4
                            l_v_sql_id := 'SQL-00020';
                            BEGIN
                                UPDATE BKP001
                                SET BACUSR = l_v_user,
                                BACDAT = l_v_date
                                WHERE BABKNO = p_i_v_bkg_number;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            -- INSERT RECORD IN BKP032 AND BOOKING_SUPPLIER_DETAIL ALSO AS PER HEMLATA
                            l_v_sql_id := 'SQL-00021';
                            /*
                            BEGIN
                                INSERT INTO BKP032(
                                BCBKNO,
                                EQP_SIZETYPE_SEQNO,  --SEQUENCE
                                BCLINE,
                                BCTRAD,
                                BCAGNT,
                                BCSIZE,
                                BCTYPE,
                                SPECIAL_HANDLING,
                                BCTEUS,
                                BCFQTY,
                                BCDQTY,
                                BCRQTY,
                                REEFER_POINTS,
                                BCOQTY,
                                BCEQTY,
                                BCSTAT,
                                DEMURRAGE_FREEDAYS,
                                EXP_DETENTION_FREEDAYS,
                                IMP_DETENTION_FREEDAYS,
                                BCRCST,
                                BCAUSR,
                                BCADAT,
                                BCATIM,
                                BCCUSR,
                                BCCDAT,
                                BCCTIM,
                                KILLED_SLOTS,
                                SHIPMENT_TYPE,
                                SPECIAL_CARGO_CODE,
                                HANDLING_INS1,
                                HANDLING_INS2,
                                HANDLING_INS3,
                                CLR_CODE1,
                                CLR_CODE2,
                                CHASSIS_REQUIRED_YN,
                                BUNDLE,
                                POL_STAT,
                                POD_STAT,
                                OPR_VOID_SLOT)
                                SELECT p_i_v_bkg_number,
                                EQP_SIZETYPE_SEQNO,
                                l_v_biline,
                                l_v_batrad,
                                l_v_baagnt,
                                BCSIZE,
                                BCTYPE,
                                SPECIAL_HANDLING,
                                BCTEUS,
                                BCFQTY,
                                BCDQTY,
                                BCRQTY,
                                REEFER_POINTS,
                                BCOQTY,
                                BCEQTY,
                                BCSTAT,
                                DEMURRAGE_FREEDAYS,
                                EXP_DETENTION_FREEDAYS,
                                IMP_DETENTION_FREEDAYS,
                                BCRCST,
                                BCAUSR,
                                BCADAT,
                                BCATIM,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                KILLED_SLOTS,
                                SHIPMENT_TYPE,
                                SPECIAL_CARGO_CODE,
                                HANDLING_INS1,
                                HANDLING_INS2,
                                HANDLING_INS3,
                                CLR_CODE1,
                                CLR_CODE2,
                                CHASSIS_REQUIRED_YN,
                                BUNDLE,
                                POL_STAT,
                                POD_STAT,
                                OPR_VOID_SLOT
                                FROM BKP032
                                WHERE BCBKNO=l_cur_tos_dl.FK_BOOKING_NO;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;
                            */
                            --INSERT INTO BOOKING_SUPPLIER_DETAILS

                            /* Block Start to get supplier sequence# for new booking from bkp032 as suggested by K'Myo, 26.10.2011 by vikas*/
                            BEGIN
                                l_v_sql_id := 'SQL-0022A';
                                SELECT EQP_SIZETYPE_SEQNO
                                INTO   l_v_eqp_sizetype_seqno
                                FROM   BKP032
                                WHERE  BCBKNO           = p_i_v_bkg_number      -- AS suggest by k'myo 03.11.2011
                                AND    BCSIZE           = l_cur_tos_dl.dn_eq_size -- AS suggest by k'myo 03.11.2011
                                AND    BCTYPE           = l_cur_tos_dl.dn_eq_type  -- AS suggest by k'myo 03.11.2011
                                AND    SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl -- AS suggest by k'myo 03.11.2011
                                AND    ROWNUM = 1;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                    RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
                            END;
                            /* Block End to get supplier sequence# for new booking from bkp032 as suggested by K'Myo, 26.10.2011 by vikas*/
/*
                            DELETE FROM BOOKING_SUPPLIER_DETAIL
                            WHERE BOOKING_NO       = p_i_v_bkg_number
                            AND   EQ_SIZE          = l_cur_tos_dl.dn_eq_size
                            AND   EQ_TYPE          = l_cur_tos_dl.dn_eq_type
                            AND   SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl;
*/

                            l_v_sql_id := 'SQL-0022B';
                            BEGIN
                                INSERT INTO BOOKING_SUPPLIER_DETAIL(
                                BOOKING_NO,
                                SUPPLIER_SQNO,  --SEQUENCE
                                SELVL1,
                                SELVL2,
                                SELVL3,
                                EQ_SIZE,
                                EQ_TYPE,
                                SPECIAL_HANDLING,
                                SUPPLIER_CODE,
                                SUPPLIER_LOCATION,
                                POSITIONING_TERMINAL,
                                POSITIONING_DATE,
                                POSITIONING_TIME,
                                FULL_QTY,
                                EMPTY_QTY,
                                DG_QTY,
                                RF_QTY,
                                OG_QTY,
                                EQP_RESERVED,
                                FORWARDING_AGENT,
                                SERCST,
                                SEAUSR,
                                SEADAT,
                                RECORD_ADD_TIME,
                                SECUSR,
                                SECDAT,
                                RECORD_CHANGE_TIME,
                                SHIPMENT_TYPE,
                                SUPPLIER_NAME,
                                FORWARDING_AGENT_NAME,
                                HAUL_FROM_SHPR_LOC_YN,
                                LOCATION_CODE,
                                EQP_SIZETYPE_SEQNO)
                                SELECT p_i_v_bkg_number,
                                SUPPLIER_SQNO,
                                SELVL1,
                                SELVL2,
                                SELVL3,
                                EQ_SIZE,
                                EQ_TYPE,
                                SPECIAL_HANDLING,
                                SUPPLIER_CODE,
                                SUPPLIER_LOCATION,
                                POSITIONING_TERMINAL,
                                POSITIONING_DATE,
                                POSITIONING_TIME,
                                FULL_QTY,
                                EMPTY_QTY,
                                DG_QTY,
                                RF_QTY,
                                OG_QTY,
                                EQP_RESERVED,
                                FORWARDING_AGENT,
                                SERCST,
                                SEAUSR,
                                SEADAT,
                                RECORD_ADD_TIME,
                                l_v_user,
                                l_v_date,
                                l_v_time,
                                SHIPMENT_TYPE,
                                SUPPLIER_NAME,
                                FORWARDING_AGENT_NAME,
                                HAUL_FROM_SHPR_LOC_YN,
                                LOCATION_CODE,
                                l_v_eqp_sizetype_seqno  -- EQP_SIZETYPE_SEQNO
                                FROM BOOKING_SUPPLIER_DETAIL
                                WHERE BOOKING_NO       = l_cur_tos_dl.FK_BOOKING_NO
                                AND   EQ_SIZE          = l_cur_tos_dl.dn_eq_size
                                AND   EQ_TYPE          = l_cur_tos_dl.dn_eq_type
                                AND   SPECIAL_HANDLING = l_cur_tos_dl.dn_special_hndl;
                            EXCEPTION
                                WHEN OTHERS THEN
                                --RAISE l_exce_main;
                                p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
                                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

                            END;


                        END IF;
                END IF;

                --Refresh Variable
                l_v_coc            := NULL;
                l_v_load_cn        := NULL;
                l_v_shpmnt_ty      := NULL;
                l_v_bkg_list       := NULL;
                l_v_stw_pos        := NULL;
                i_v_return_status  := NULL;
                l_v_eqwght         := 0;
                l_v_biline           := NULL;
                l_v_batrad         := NULL;
                l_v_baagnt         := NULL;
                l_n_wght           := 0;
                l_v_stcmcd           := NULL;
                l_v_fcdesc           := NULL;
                l_v_com_grpcd      := NULL;
            END LOOP;
        END LOOP;

        --commit;
        l_v_sql_id := 'SQL-9001A';
        BEGIN
            SELECT BALINE,BATRAD,BAAGNT
            INTO l_v_biline,l_v_batrad,l_v_baagnt
            FROM BKP001
            WHERE BABKNO = p_i_v_bkg_number;
        EXCEPTION
            WHEN OTHERS THEN
            --RAISE l_exce_main;
            p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        END;


        l_v_sql_id := 'SQL-9001B';
        BEGIN
            INSERT INTO BKP030 (
            BNBKNO,
            BNCSTP,
            BNCSCD,
            BNLINE,
            BNTRAD,
            BNAGNT,
            BNNAME,
            EXP_DET_BILLTO,
            IMP_DET_DEM_BILLTO,
            BNADD1,
            BNADD2,
            BNADD3,
            BNADD4,
            CITY,
            STATE,
            BNCOUN,
            BNZIP,
            BNTELN,
            BNFAX,
            BNEMAL,
            BNRCST,
            BNAUSR,
            BNADAT,
            BNATIM,
            BNCUSR,
            BNCDAT,
            BNCTIM
            )
            SELECT p_i_v_bkg_number,
            'S',
            CYCUST,
            l_v_biline,
            l_v_batrad,
            l_v_baagnt,
            CYNAME,
            EXP_DET_BILLTO,
            IMP_DET_DEM_BILLTO,
            CYADD1,
            CYADD2,
            CYADD3,
            CYADD4,
            CITY,
            STATE,
            COUNTRY_CODE,
            ZIP,
            CYTELN,
            CYFAXN,
            EMAIL_ID,
            CYRCST,
            CYAUSR,
            CYADAT,
            CYATIM,
            l_v_user,
            l_v_date,
            l_v_time
            FROM IDP030
            WHERE CYRCTP='C'
            AND CYBLNO= p_i_v_bkg_list;          -- l_cur_bkg_data.TYBKNO; --Review 7  l_cur_tos_dl.FK_BOOKING_NO;
        EXCEPTION
            WHEN OTHERS THEN
            --RAISE l_exce_main;
            p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        END;

        l_v_sql_id := 'SQL-90002';
        --FOR 'C' CONSIGNEE
        BEGIN
            INSERT INTO BKP030(
            BNBKNO,
            BNCSTP,
            BNCSCD,
            BNLINE,
            BNTRAD,
            BNAGNT,
            BNNAME,
            EXP_DET_BILLTO,
            IMP_DET_DEM_BILLTO,
            BNADD1,
            BNADD2,
            BNADD3,
            BNADD4,
            CITY,
            STATE,
            BNCOUN,
            BNZIP,
            BNTELN,
            BNFAX,
            BNEMAL,
            BNRCST,
            BNAUSR,
            BNADAT,
            BNATIM,
            BNCUSR,
            BNCDAT,
            BNCTIM
            )
            SELECT p_i_v_bkg_number,
            'C',
            CYCUST,
            l_v_biline,
            l_v_batrad,
            l_v_baagnt,
            CYNAME,
            EXP_DET_BILLTO,
            IMP_DET_DEM_BILLTO,
            CYADD1,
            CYADD2,
            CYADD3,
            CYADD4,
            CITY,
            STATE,
            COUNTRY_CODE,
            ZIP,
            CYTELN,
            CYFAXN,
            EMAIL_ID,
            CYRCST,
            CYAUSR,
            CYADAT,
            CYATIM,
            l_v_user,
            l_v_date,
            l_v_time
            FROM IDP030
            WHERE CYRCTP='S'
            AND CYBLNO= p_i_v_bkg_list;  --- l_cur_bkg_data.TYBKNO; --Review 7  l_cur_tos_dl.FK_BOOKING_NO;
        EXCEPTION
            WHEN OTHERS THEN
            --RAISE l_exce_main;
            p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(l_v_sql_id||SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        END;

        l_v_err_code   := '0';

            l_v_err_desc   := 'Batch Completed Successfully.';

        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        l_v_parameter_string,
                       'RET',
                       'I',
                       l_v_sql_id||'~'||l_v_err_code||'~'||l_v_err_desc,
                       'A',
                       l_v_user,
                       CURRENT_TIMESTAMP,
                       l_v_user,
                       CURRENT_TIMESTAMP
                       );
        COMMIT;
        --p_o_v_return_status := '0';
        p_o_v_error := l_v_err_desc;
    EXCEPTION
        WHEN l_exce_main THEN
        ROLLBACK;
        --p_o_v_return_status := '1';

        l_v_err_code   := TO_CHAR (SQLCODE);
        l_v_err_desc   := SUBSTR(SQLERRM,1,100);
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_string
                                                         , 'RET'
                                                         , 'I'
                                                         , l_v_sql_id||'~'||l_v_err_code||'~'||l_v_err_desc
                                                         , 'A'
                                                         , l_v_user
                                                         , CURRENT_TIMESTAMP
                                                         , l_v_user
                                                         , CURRENT_TIMESTAMP
                                                          );
          COMMIT;
        p_o_v_error := l_v_err_desc;
        WHEN OTHERS THEN
        ROLLBACK;
        --p_o_v_return_status := '1';

        l_v_err_code   := TO_CHAR (SQLCODE);
        l_v_err_desc   := SUBSTR(SQLERRM,1,100);


        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_string,
                          'RET',
                          'I',
                          l_v_sql_id||'~'||l_v_err_code||'~'||l_v_err_desc,
                          'A',
                          l_v_user,
                          CURRENT_TIMESTAMP,
                          l_v_user,
                          CURRENT_TIMESTAMP
                          );
        COMMIT;
        p_o_v_error := l_v_err_desc;
    END PRE_BKG_RETURN_CONT;
END PCE_RETURN_SHIPMENT;

/
