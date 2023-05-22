create or replace
PACKAGE BODY         PCE_ECM_SYNC_EZLL_BOOKING AS

   PROCEDURE PRE_BKG_EQUIPMENT_UPDATE
   ( p_i_v_booking_no         IN   VARCHAR2
   , p_i_n_equipment_seq_no   IN   NUMBER
   , p_i_v_equipment_no       IN   VARCHAR2
   , p_i_n_overheight         IN   NUMBER
   , p_i_n_overlength_rear    IN   NUMBER
   , p_i_n_overlength_front   IN   NUMBER
   , p_i_n_overwidth_left     IN   NUMBER
   , p_i_n_overwidth_right    IN   NUMBER
   , p_i_v_imdg               IN   VARCHAR2
   , p_i_v_unno               IN   VARCHAR2
   , p_i_v_un_var             IN   VARCHAR2
   , p_i_v_flash_point        IN   VARCHAR2
   , p_i_n_flash_unit         IN   VARCHAR2
   , p_i_v_reefer_tmp         IN   VARCHAR2
   , p_i_v_reefer_tmp_unit    IN   VARCHAR2
   , p_i_n_humidity           IN   NUMBER
   , p_i_n_gross_wt           IN   NUMBER
   , p_i_n_ventilation        IN   NUMBER
   , P_I_V_VGM_CATEGORY       IN   VARCHAR2 --*2
   , P_I_V_VGM                IN   NUMBER --*3
   , p_o_v_return_status      OUT NOCOPY  VARCHAR2
   ) IS
    /*********************************************************************************************
        Name           :  PRE_BKG_EQUIPMENT_UPDATE
        Module         :  EZLL
        Purpose        :  To Update data in BKP009 whenever above parameters are going to change.
                            This procedure is called by Screen
        Calls          :
        Returns        :  Null
        Author             Date               What
        ------             ----               ----
        Rajat              20/01/2010        INITIAL VERSION
        *1 Vikas Verma     30.03.2012        Update Record change user and date in BKP009
        *2 WACCHO1         08/08/2016        Sync Container_gross_weight/category back to BKP009
        *3 WACCHO1         16/08/2016        Sync VGM back to BKP009
    *********************************************************************************************/
        -- l_v_time              TIMESTAMP; -- *1
        l_v_user                 BKP009.BICUSR%TYPE := 'EZLL';  -- *1
        l_v_date                 BKP009.BICDAT%TYPE; -- *1
        l_v_time                 BKP009.BICTIM%TYPE; -- *1
        l_exce_main              EXCEPTION;
        l_v_param_string         VARCHAR2(500);
    BEGIN
        -- l_v_time := CURRENT_TIMESTAMP;

        /*
            *1: block Start
        */
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
        /*
            *1: block End
        */

        l_v_param_string := p_i_v_booking_no ||'~'||
                            p_i_n_equipment_seq_no ||'~'||
                            p_i_v_equipment_no ||'~'||
                            p_i_n_overheight ||'~'||
                            p_i_n_overlength_rear ||'~'||
                            p_i_n_overlength_front ||'~'||
                            p_i_n_overwidth_left ||'~'||
                            p_i_n_overwidth_right ||'~'||
                            p_i_v_imdg ||'~'||
                            p_i_v_unno ||'~'||
                            p_i_v_un_var ||'~'||
                            p_i_v_flash_point ||'~'||
                            p_i_n_flash_unit ||'~'||
                            p_i_v_reefer_tmp ||'~'||
                            p_i_v_reefer_tmp_unit ||'~'||
                            p_i_n_humidity ||'~'||
                            p_i_n_gross_wt ||'~'||
                            p_i_n_ventilation ||'~'||
                            P_I_V_VGM_CATEGORY ||'~'|| --*2
                            P_I_V_VGM --*3 
                            ;


        ------------ equipment number update ---------------


        g_v_sql_id := 'SQL-01001';
        BEGIN
            IF p_i_v_equipment_no IS NOT NULL THEN
                /*
                    Block Start by vikas, to take backup of BKP009 data, as suggested by k'myo and k'chatgamol, 17.02.2012
                */
                BEGIN
                    PRR_INS_TOS_BKG_CNTR (
                        p_i_v_booking_no,
                        p_i_n_equipment_seq_no,
                        l_v_user -- User Name
                    );
                END;
                /*
                    Block end by vikas, 17.02.2012
                */
                UPDATE BKP009
                SET BICTRN = DECODE(p_i_v_equipment_no,'~', NULL, p_i_v_equipment_no)
                , BICUSR = l_v_user -- *1
                , BICDAT = l_v_date -- *1
                , BICTIM = l_v_time -- *1
                WHERE  BIBKNO = p_i_v_booking_no
                AND    BISEQN = p_i_n_equipment_seq_no;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code := TO_CHAR(SQLCODE);
                g_v_err_desc := SUBSTR((g_v_sql_id||SQLERRM),1,100);
                RAISE l_exce_main;
        END;

        g_v_sql_id := 'SQL-01002';
        BEGIN
            IF (p_i_n_overheight IS NOT NULL
                OR p_i_n_overlength_rear    IS NOT NULL
                OR p_i_n_overlength_front   IS NOT NULL
                OR p_i_n_overwidth_left     IS NOT NULL
                OR p_i_n_overwidth_right    IS NOT NULL
                --DG check
                OR p_i_v_unno               IS NOT NULL
                OR p_i_v_un_var             IS NOT NULL
                OR p_i_v_flash_point        IS NOT NULL
                OR p_i_n_flash_unit         IS NOT NULL
                OR p_i_v_imdg               IS NOT NULL
                --REEFER CHECK
                OR p_i_v_reefer_tmp         IS NOT NULL
                OR p_i_v_reefer_tmp_unit    IS NOT NULL
                OR p_i_n_humidity           IS NOT NULL
                OR p_i_n_ventilation        IS NOT NULL
                --gROSS wT
                OR p_i_n_gross_wt           IS NOT NULL
                OR P_I_V_VGM_CATEGORY       IS NOT NULL --*2
                OR P_I_V_VGM                IS NOT NULL --*3 
                )  THEN

                UPDATE BKP009
                SET BIXHGT      = NVL2(p_i_n_overheight, p_i_n_overheight, BIXHGT)
                , BIXLNB        = NVL2(p_i_n_overlength_rear, p_i_n_overlength_rear, BIXLNB)
                , BIXLNF        = NVL2(p_i_n_overlength_front, p_i_n_overlength_front, BIXLNF)
                , BIXWDL        = NVL2(p_i_n_overwidth_left, p_i_n_overwidth_left, BIXWDL)
                , BIXWDR        = NVL2(p_i_n_overwidth_right, p_i_n_overwidth_right, BIXWDR)
                , BIUNN         = DECODE(p_i_v_unno,'~',NULL,NVL2(p_i_v_unno, p_i_v_unno, BIUNN))
                , UN_VARIANT    = DECODE(p_i_v_un_var,'~',NULL,NVL2(p_i_v_un_var, p_i_v_un_var, UN_VARIANT))
                , BIFLPT        = DECODE(p_i_v_flash_point,'~',NULL,NVL2(p_i_v_flash_point, p_i_v_flash_point, BIFLPT))
                , BIFLBS        = DECODE(p_i_n_flash_unit,'~',NULL,NVL2(p_i_n_flash_unit, p_i_n_flash_unit, BIFLBS))
                , BIIMCL        = DECODE(p_i_v_imdg,'~',NULL,NVL2(p_i_v_imdg, p_i_v_imdg, BIIMCL))
                , BIRFFM        = DECODE(p_i_v_reefer_tmp,'~',NULL,NVL2(p_i_v_reefer_tmp, p_i_v_reefer_tmp, BIRFFM))
                , BIRFBS        = DECODE(p_i_v_reefer_tmp_unit,'~',NULL,NVL2(p_i_v_reefer_tmp_unit, p_i_v_reefer_tmp_unit, BIRFBS))
                , HUMIDITY      = NVL2(p_i_n_humidity, p_i_n_humidity, HUMIDITY)
                , MET_WEIGHT    = NVL2(p_i_n_gross_wt, p_i_n_gross_wt, MET_WEIGHT)
                , AIR_PRESSURE  = NVL2(p_i_n_ventilation, p_i_n_ventilation, AIR_PRESSURE) --Added by Bindu on 14/03/12
                , BICUSR        = l_v_user -- *1
                , BICDAT        = l_v_date -- *1
                , BICTIM        = l_v_time -- *1
                , EQP_CATEGORY  = NVL2(P_I_V_VGM_CATEGORY,P_I_V_VGM_CATEGORY,EQP_CATEGORY) --*2
                , EQP_VGM       = NVL2(P_I_V_VGM,P_I_V_VGM,EQP_VGM) --*3
                WHERE  BIBKNO   = p_i_v_booking_no
                AND    BISEQN   = p_i_n_equipment_seq_no;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code := TO_CHAR(SQLCODE);
                g_v_err_desc := SUBSTR(SQLERRM,1,100);
                RAISE l_exce_main;
        END;

        --------- alert to be raised booking fsc for OOG change ---------------
        --------- alert to be raised booking fsc for DG change ---------------
        --------- alert to be raised booking fsc for reefer change ---------------

        p_o_v_return_status := '0';
EXCEPTION
    WHEN l_exce_main THEN
        p_o_v_return_status := '1';
        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
            l_v_param_string
            , 'SYNC'
            , 'T'
            , g_v_sql_id ||'~'|| g_v_err_code||'~'||g_v_err_desc
            , 'A'
            , 'EZLL'
            , CURRENT_TIMESTAMP
            , 'EZLL'
            , CURRENT_TIMESTAMP
        );
        COMMIT;
    WHEN OTHERS THEN
        p_o_v_return_status := '1';
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                l_v_param_string
                , 'SYNC'
                , 'T'
                , g_v_sql_id ||'~'|| g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , 'EZLL'
                , CURRENT_TIMESTAMP
                , 'EZLL'
                , CURRENT_TIMESTAMP
            );
            COMMIT;
   END;

   PROCEDURE PRE_BKG_CONDENSE
   ( p_i_n_load_list_id       IN  NUMBER
   , p_o_v_return_status      OUT NOCOPY  VARCHAR2
   ) IS
   /***************************************************************************************************
     Name           :  PRE_BKG_CONDENSE
     Module         :
     Purpose        : Remove the container from booking whenever load list status is set from below
                      loading completed(10) to loading completed(10) or higher.This will remove only
                      the record from load list which is not having container no and container
                      should be SOC or COC empty and booking status is not closed.
     Calls          : None
     Returns        : '0' --Success
                      '1' --Fail
     Author          Date               What
     ------          ----               ----
     Sumeet Dwivedi  10/02/2010        INITIAL VERSION
   ****************************************************************************************************/
      l_exce_main     EXCEPTION;
   CURSOR l_cur_tos_booked_load
     IS
        SELECT FK_BOOKING_NO, CONTAINER_SEQ_NO
        FROM TOS_LL_BOOKED_LOADING
           , BKP001
        WHERE FK_LOAD_LIST_ID = p_i_n_load_list_id
          AND BABKNO             = FK_BOOKING_NO
          AND TRIM(DN_EQUIPMENT_NO) IS NULL
          AND (DN_SOC_COC        = 'S'
                OR (DN_SOC_COC   = 'C' AND DN_FULL_MT = 'E')
              )
        AND BASTAT NOT IN('L'); --BASTAT=L=BOOKING  STATUS CLOSED
   BEGIN
      FOR cur_tos_booked_load_data IN l_cur_tos_booked_load
      LOOP
         BEGIN
            g_v_sql_id := 'SQL-02001';
            DELETE FROM BKP009
            WHERE BIBKNO = cur_tos_booked_load_data.FK_BOOKING_NO
            AND   BISEQN = cur_tos_booked_load_data.CONTAINER_SEQ_NO;
         EXCEPTION
            WHEN OTHERS THEN
               g_v_err_code := TO_CHAR(SQLCODE);
               g_v_err_desc := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
          END;
        --Call the procedure for every booking(only once)and will update all the required data in booking and also calculate charges in BKP070.
         BEGIN
            g_v_sql_id := 'SQL-02002';
            PRE_BKG_RECALCULATE_DATA('L'
                                   , cur_tos_booked_load_data.FK_BOOKING_NO
                                   , p_o_v_return_status
                                    );
            IF p_o_v_return_status = '1' THEN
               g_v_err_code := TO_CHAR (SQLCODE);
               g_v_err_desc := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               g_v_err_code   := TO_CHAR (SQLCODE);
               g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
         END;
      END LOOP;
      p_o_v_return_status := '0';
   EXCEPTION
      WHEN l_exce_main THEN
         p_o_v_return_status := '1';
      WHEN OTHERS THEN
         p_o_v_return_status := '1';
   END PRE_BKG_CONDENSE;

   PROCEDURE PRE_BKG_RECALCULATE_DATA
   ( p_i_v_ll_flg        IN         VARCHAR2
   , p_i_v_booking_no    IN         VARCHAR2
   , p_o_v_return_status OUT NOCOPY VARCHAR2
   ) AS
   /********************************************************************************
   * Name           : PRE_BKG_RECALCULATE_DATA                                     *
   * Module         : EZLL                                                         *
   * Purpose        : To recalculate the Booking data whenever container is added
                      or removed from Booking Equipment Table(BKP009) using EZLL.  *
   * Calls          : None                                                         *
   * Returns        : '0' --Success
                      '1' --Fail                                                   *
   * Steps Involved :                                                              *
   * History        : None                                                         *
   * Author           Date          What                                           *
   * ---------------  ----------    ----                                           *
   * Bindu sekhar     10/02/2011     1.0                                           *
   *********************************************************************************/
      l_n_charge_amount IDP070.CONV_RATE_INV%TYPE;
      l_exce_main       EXCEPTION;
   --Cursor to retrive count of containers and sum of TUE from BKP009.
   CURSOR l_cur_booking_equipment
   IS
      SELECT BIBKNO
          , BICSZE
          , BICNTP
          , COUNT_OF_CONTAINER
          , TOTAL_TUE
          , SUM(TOTAL_TUE) OVER() TOTAL_TUE_ALL
      FROM(SELECT BIBKNO
                , BICSZE
                , BICNTP
                , COUNT(1)        COUNT_OF_CONTAINER
                , SUM(BICSZE/20)  TOTAL_TUE
           FROM BKP009
           WHERE BIBKNO = p_i_v_booking_no
           GROUP BY BIBKNO, BICSZE, BICNTP);
   --Cursor to get Size, Type from TOS_LL_BOOKED_LOADING, BKP050 and BKP001.
   CURSOR l_cur_size_type_detail
   IS
      SELECT IDP055.EYEQSZ, IDP055.EYEQTP, IDP055.SPECIAL_HANDLING, DECODE(p_i_v_ll_flg, 'L', IDP055.POL_STAT, IDP055.POD_STAT) LOCAL_STATUS
           , IDP051.PORT_CLASS_CODE, IDP010.AYMODE, IDP055.EYSHTP, IDP050.BYCMCD
           , COUNT(1) COUNT_OF_CONTAINERS
      FROM IDP055 IDP055
      LEFT OUTER JOIN IDP051 IDP051
           ON(  IDP055.EYBLNO = IDP051.IYBLNO
                AND IDP055.EYCMSQ =IDP051.IYCMSQ
             ),
      IDP050 IDP050, IDP010 IDP010
       WHERE EYBLNO in (select TYBLNO from IDP002 where TYBKNO = p_i_v_booking_no)
        AND IDP055.EYBLNO  = IDP010.AYBLNO AND   IDP010.AYSTAT  >=1 AND   IDP010.AYSTAT  <=6
        AND IDP010.PART_OF_BL IS NULL AND IDP055.EYBLNO    = IDP050.BYBLNO
        AND IDP055.EYCMSQ    = IDP050.BYCMSQ
        GROUP BY IDP055.EYEQSZ, IDP055.EYEQTP, IDP055.SPECIAL_HANDLING,
         DECODE(p_i_v_ll_flg, 'L', IDP055.POL_STAT, IDP055.POD_STAT)
         , IDP055.EYSHTP, IDP051.PORT_CLASS_CODE, IDP010.AYMODE, IDP050.BYCMCD;

      /*SELECT A.BICSZE , A.BICNTP, A.SPECIAL_HANDLING, DECODE(p_i_v_ll_flg, 'L', A.POL_STAT, A.POD_STAT) LOCAL_STATUS
           , D.PORT_CLASS_CODE, B.BAMODE, B.BASTP1, C.BWCMCD
           , COUNT(1) COUNT_OF_CONTAINERS
      FROM BKP009                A
         , BKP001                B
         , BKP050                C
           LEFT OUTER JOIN BOOKING_DG_COMM_DETAIL D
           ON(    D.BOOKING_NO     = C.BWBKNO
              AND D.SHIPMENT_TYPE  = C.BWSHTP
              AND D.COMMODITY_SQNO = C.BWCMSQ
             )
      WHERE A.BIBKNO          = B.BABKNO
      AND   B.BABKNO          = C.BWBKNO
      AND   B.BABKNO          = p_i_v_booking_no
      GROUP BY A.BICSZE , A.BICNTP, A.SPECIAL_HANDLING, DECODE(p_i_v_ll_flg, 'L', A.POL_STAT, A.POD_STAT)
           , D.PORT_CLASS_CODE, B.BAMODE, B.BASTP1, C.BWCMCD;*/


   CURSOR l_cur_upd_supplier
   IS
      SELECT BIBKNO
           , BICSZE
           , BICNTP
           , SPECIAL_HANDLING
           , SUM(DECODE(BIEORF, 'F', 1, 0))             FULL_QTY
           , SUM(DECODE(BIEORF, 'E', 1, 0))             EMPTY_QTY
           , SUM(CASE WHEN (BIUNN IS NOT NULL OR
                            UN_VARIANT IS NOT NULL OR
                            BIFLPT IS NOT NULL OR
                            BIFLBS IS NOT NULL OR
                            BIIMCL IS NOT NULL)
                      THEN 1 ELSE 0 END)                DG_QTY
           , SUM(CASE WHEN (BIRFFM IS NOT NULL OR
                            BIRFBS IS NOT NULL OR
                            NVL(HUMIDITY,0) != 0 OR
                            NVL(AIR_PRESSURE,0) != 0)
                      THEN 1 ELSE 0 END)                RF_QTY
           , SUM(CASE WHEN (NVL(BIXHGT, 0) <> 0 OR
                            NVL(BIXLNB, 0) <> 0 OR
                            NVL(BIXLNF, 0) <> 0 OR
                            NVL(BIXWDL, 0) <> 0 OR
                            NVL(BIXWDR, 0) <> 0)
                      THEN 1 ELSE 0 END)                OG_QTY
      FROM BKP009
      WHERE BIBKNO = p_i_v_booking_no
      GROUP BY BIBKNO, BICSZE, BICNTP, SPECIAL_HANDLING;

    CURSOR l_cur_sel_charge_amt(
        l_v_eyeqsz                    IDP055.EYEQSZ%TYPE
        ,l_v_eyeqtp                    IDP055.EYEQTP%TYPE
        ,l_v_special_handling          IDP055.SPECIAL_HANDLING%TYPE
        ,l_v_local_status              IDP055.POL_STAT%TYPE
        ,l_v_port_class_code           IDP051.PORT_CLASS_CODE%TYPE
        ,l_v_eyshtp                    IDP055.EYSHTP%TYPE
        ,l_v_aymode                    IDP010.AYMODE%TYPE
    )
    IS
        SELECT A.GYFRRT GYFRRT,A.GYFRCD GYFRCD
        FROM IDP070 A
          , IDP010 B
        WHERE A.GYBLNO = B.AYBLNO
        AND A.GYEQSZ                         = l_v_eyeqsz
        AND A.GYEQTP                         = l_v_eyeqtp
        AND A.GYRETP                         = l_v_special_handling
        --AND NVL(A.TS_LOCAL_FLAG, '*')      = NVL(J.LOCAL_STATUS, '*')
        AND (NVL(A.TS_LOCAL_FLAG, '*')       = NVL(l_v_local_status, '*') or A.GYFORS='F')
        --AND NVL(A.COMMODITY_GROUP_CODE, '*') = NVL(J.BYCMCD, '*')
        AND NVL(A.PORT_CLASS_CODE, '*')      = NVL(l_v_port_class_code, '*')
        AND A.GYSHTP                         = l_v_eyshtp
        AND B.AYMODE                         = l_v_aymode
        AND B.AYBKNO                         = p_i_v_booking_no;

   BEGIN
      FOR I IN l_cur_booking_equipment
      LOOP
         g_v_sql_id := 'SQL-03001';
         --Update size type datail(BKP032).
         BEGIN
            UPDATE BKP032
            SET BCFQTY = I.COUNT_OF_CONTAINER
              , BCTEUS = I.TOTAL_TUE
            WHERE BCSIZE = I.BICSZE
            AND   BCTYPE = I.BICNTP
            AND   BCBKNO = I.BIBKNO;
         EXCEPTION
            WHEN OTHERS THEN
               g_v_err_code := TO_CHAR (SQLCODE);
               g_v_err_desc := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
         END;
         g_v_sql_id := 'SQL-03002';
        --Update Booking Header(BKP001).
         BEGIN
            UPDATE BKP001
            SET BATEU1 = I.TOTAL_TUE_ALL
            WHERE BABKNO = I.BIBKNO;
         EXCEPTION
            WHEN OTHERS THEN
               g_v_err_code := TO_CHAR (SQLCODE);
               g_v_err_desc := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
         END;
      END LOOP;
      --Re-Calculating Charges(BKP070).
      FOR J IN l_cur_size_type_detail
      LOOP
         g_v_sql_id := 'SQL-03003';
         --Finding Charge amount from IDP070 and IDP010.
         BEGIN
             FOR l_cur_sel_charge_dtl in l_cur_sel_charge_amt(J.EYEQSZ, J.EYEQTP,
                    J.SPECIAL_HANDLING, J.LOCAL_STATUS,
                    J.PORT_CLASS_CODE, J.EYSHTP, J.AYMODE)
             LOOP
                 BEGIN
                    UPDATE BKP070
                    SET BQLAMT = NVL2(l_cur_sel_charge_dtl.GYFRRT, (l_cur_sel_charge_dtl.GYFRRT*J.COUNT_OF_CONTAINERS), (BQRATE*J.COUNT_OF_CONTAINERS))
                      , BQFRUN = J.COUNT_OF_CONTAINERS
                      , BQAMTM = NVL2(l_cur_sel_charge_dtl.GYFRRT, (l_cur_sel_charge_dtl.GYFRRT*J.COUNT_OF_CONTAINERS*BQCNVM), (BQRATE*J.COUNT_OF_CONTAINERS*BQCNVM))
                    WHERE BQCSZE                         = J.EYEQSZ
                    AND   BQCNTP                         = J.EYEQTP
                    AND   BQRETP                         = J.SPECIAL_HANDLING
                    --AND   NVL(TS_LOCAL_FLAG, '*')                          = NVL(J.LOCAL_STATUS, '*')
                    AND (NVL(TS_LOCAL_FLAG, '*')                        = NVL(J.LOCAL_STATUS, '*') or BQFORS='F')
                    --AND ((NVL(TS_LOCAL_FLAG, '*')        = NVL(J.LOCAL_STATUS, '*') )  )
                   -- AND   NVL(COMMODITY_GROUP_CODE, '*')         = NVL(J.BYCMCD, '*')
                    AND   NVL(PORT_CLASS_CODE, '*')      = NVL(J.PORT_CLASS_CODE, '*')
                    AND   BQSHPT                         = J.EYSHTP
                    AND   BQCHCD                         = l_cur_sel_charge_dtl.GYFRCD
                    AND   BQBKNO                         = p_i_v_booking_no;
                 END;
             END LOOP;
         EXCEPTION
            WHEN OTHERS THEN
               g_v_err_code := TO_CHAR (SQLCODE);
               g_v_err_desc := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
         END;
         g_v_sql_id := 'SQL-03004';
         --Updating Charges and Container in BKP070.
      END LOOP;



      g_v_sql_id := 'SQL-03005';
      FOR l_cur_upd_supplier_detail IN l_cur_upd_supplier
      LOOP
         BEGIN
            UPDATE BOOKING_SUPPLIER_DETAIL
            SET FULL_QTY   = l_cur_upd_supplier_detail.FULL_QTY
              , EMPTY_QTY  = l_cur_upd_supplier_detail.EMPTY_QTY
              , DG_QTY     = l_cur_upd_supplier_detail.DG_QTY
              , RF_QTY     = l_cur_upd_supplier_detail.RF_QTY
              , OG_QTY     = l_cur_upd_supplier_detail.OG_QTY
            WHERE BOOKING_NO     = l_cur_upd_supplier_detail.BIBKNO
            AND EQ_SIZE          = l_cur_upd_supplier_detail.BICSZE
            AND EQ_TYPE          = l_cur_upd_supplier_detail.BICNTP
            AND SPECIAL_HANDLING = l_cur_upd_supplier_detail.SPECIAL_HANDLING;
         EXCEPTION
            WHEN OTHERS THEN
               g_v_err_code := TO_CHAR (SQLCODE);
               g_v_err_desc := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
         END;
      END LOOP;
      p_o_v_return_status := '0';
      --COMMIT;
   EXCEPTION
      WHEN l_exce_main THEN
         p_o_v_return_status := '1';
      WHEN OTHERS THEN
         p_o_v_return_status := '1';
         g_v_err_code   := TO_CHAR (SQLCODE);
         g_v_err_desc   := SUBSTR(SQLERRM,1,100);
   END PRE_BKG_RECALCULATE_DATA;

   PROCEDURE PRE_BKG_AUTOEXPAND
   ( p_i_n_over_shipped_id   IN         NUMBER
   , p_i_v_booking_no        IN         VARCHAR2
   , p_i_v_equipment_no      IN         VARCHAR2
   , p_i_v_equipment_size    IN         NUMBER
   , p_i_v_equipment_type    IN         VARCHAR2
   , p_o_v_return_status     OUT NOCOPY VARCHAR2
    )
    AS
    /********************************************************************************
    * Name           : PRE_BKG_AUTOEXPAND                                           *
    * Module         : EZLL                                                         *
    * Purpose        : To add container to booking whenever auto expand
                       (for COC Empty and SOC container) is required during matching*
    * Calls          : None                                                         *
    * Returns        : '0' --Success
                       '1' --Fail                                                   *
    * Steps Involved :                                                              *
    * History        : None                                                         *
    * Author           Date          What                                           *
    * ---------------  ----------    ----                                           *
    * Sachin Jaiswal   24/02/2011     1.0                                           *
    *********************************************************************************/
      l_v_max_seq      BKP009.BISEQN%TYPE;
      l_v_bline        BKP001.BALINE%TYPE;
      l_v_btrad        BKP001.BATRAD%TYPE;
      l_v_bagnt        BKP001.BAAGNT%TYPE;
      l_v_styp         BKP001.BASTP1%TYPE;
      l_n_sup_sqno     BOOKING_SUPPLIER_DETAIL.SUPPLIER_SQNO%TYPE;
      l_v_spl_hdl      TOS_LL_OVERSHIPPED_CONTAINER.SPECIAL_HANDLING%TYPE;
      l_n_grs_wght     TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_GROSS_WEIGHT%TYPE;
      l_v_local_status TOS_LL_OVERSHIPPED_CONTAINER.LOCAL_STATUS%TYPE;
      l_v_full_mt      TOS_LL_OVERSHIPPED_CONTAINER.FULL_MT%TYPE;
      l_exce_main    EXCEPTION;
      l_v_param_string VARCHAR2(500);
      l_n_num_date     NUMBER(8,0);
      l_n_num_time     NUMBER(4,0);
    BEGIN
       g_v_sql_id := 'SQL-04001';
       l_v_param_string := p_i_n_over_shipped_id ||'~'||
                           p_i_v_booking_no ||'~'||
                           p_i_v_equipment_no ||'~'||
                           p_i_v_equipment_size ||'~'||
                           p_i_v_equipment_type;
       BEGIN
          SELECT MAX(BISEQN)
          INTO l_v_max_seq
          FROM BKP009
          WHERE BIBKNO = p_i_v_booking_no;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             g_v_err_code := TO_CHAR (SQLCODE);
             g_v_err_desc := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
          WHEN OTHERS THEN
             g_v_err_code := TO_CHAR (SQLCODE);
             g_v_err_desc := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
       END;
       g_v_sql_id := 'SQL-04002';
       BEGIN
          SELECT BALINE, BATRAD, BAAGNT, BASTP1
          INTO l_v_bline, l_v_btrad, l_v_bagnt, l_v_styp
          FROM BKP001
          WHERE BABKNO = p_i_v_booking_no;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             g_v_err_code := TO_CHAR (SQLCODE);
             g_v_err_desc := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
          WHEN OTHERS THEN
             g_v_err_code := TO_CHAR (SQLCODE);
             g_v_err_desc := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
       END;

        g_v_sql_id := 'SQL-04003';
        BEGIN

            /* commented by vikas regarding bug# 557
            SELECT SPECIAL_HANDLING, CONTAINER_GROSS_WEIGHT , LOCAL_STATUS, FULL_MT
            INTO l_v_spl_hdl, l_n_grs_wght, l_v_local_status, l_v_full_mt
            FROM TOS_LL_OVERSHIPPED_CONTAINER
            WHERE PK_OVERSHIPPED_CONTAINER_ID = p_i_n_over_shipped_id;
            */

            /* Vikas: change block start against bug# 557 on 17.10.2011 */
            SELECT
                CASE
                    WHEN (IMDG_CLASS IS NOT NULL
                    OR UN_NUMBER     IS NOT NULL)
                    THEN 'D1'
                ELSE
                    CASE
                        WHEN (OVERLENGTH_FRONT_CM  IS NOT NULL
                        OR OVERLENGTH_REAR_CM      IS NOT NULL
                        OR OVERWIDTH_RIGHT_CM      IS NOT NULL
                        OR OVERWIDTH_LEFT_CM       IS NOT NULL
                        OR OVERHEIGHT_CM           IS NOT NULL)
                    THEN 'O0'
                    ELSE 'N'
                    END
                END SPECIAL_HANDLING   ,
                CONTAINER_GROSS_WEIGHT ,
                LOCAL_STATUS           ,
                FULL_MT
            INTO
                l_v_spl_hdl,
                l_n_grs_wght     ,
                l_v_local_status ,
                l_v_full_mt
            FROM TOS_LL_OVERSHIPPED_CONTAINER
            WHERE PK_OVERSHIPPED_CONTAINER_ID = p_i_n_over_shipped_id;
           /* Vikas: change block end against bug# 557 on 17.10.2011 */

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_err_code := TO_CHAR (SQLCODE);
                g_v_err_desc := SUBSTR(SQLERRM,1,100);
                RAISE l_exce_main;
            WHEN OTHERS THEN
                g_v_err_code := TO_CHAR (SQLCODE);
                g_v_err_desc := SUBSTR(SQLERRM,1,100);
                RAISE l_exce_main;
        END;
       g_v_sql_id := 'SQL-04004';
       --Add by bindu on 15/03/2011.
       BEGIN
          SELECT SUPPLIER_SQNO
          INTO l_n_sup_sqno
          FROM BOOKING_SUPPLIER_DETAIL
          WHERE EQ_SIZE  = p_i_v_equipment_size
          AND EQ_TYPE    = p_i_v_equipment_type
          AND BOOKING_NO = p_i_v_booking_no
          AND EQP_SIZETYPE_SEQNO = (SELECT A.EQP_SIZETYPE_SEQNO
                                    FROM BKP032 A
                                    WHERE A.BCSIZE         = p_i_v_equipment_size
                                    AND A.BCTYPE           = p_i_v_equipment_type
                                    AND A.SPECIAL_HANDLING = l_v_spl_hdl
                                    AND A.BCBKNO           = p_i_v_booking_no
                                    AND A.POL_STAT         = DECODE(l_v_local_status, '6', 'T', 'L'));
       --End by bindu on 15/03/2011.

       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             g_v_err_code := TO_CHAR (SQLCODE);
             g_v_err_desc := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
          WHEN OTHERS THEN
             g_v_err_code := TO_CHAR (SQLCODE);
             g_v_err_desc := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
       END;
       g_v_sql_id := 'SQL-04005';
       BEGIN
          l_n_num_date := TO_NUMBER(TO_CHAR(SYSDATE,'RRRRMMDD'));
          l_n_num_time :=TO_NUMBER(TO_CHAR(SYSDATE,'HH24MI'));
          INSERT INTO BKP009
              ( BILINE
              , BITRAD
              , BIAGNT
              , BIBKNO
              , BISEQN
              , BICTRN
              , BICSZE
              , BICNTP
              , SUPPLIER_SQNO
              , POD_STAT
              , POL_STAT
              , SHIPMENT_TYPE
              , SPECIAL_HANDLING
              , MET_WEIGHT
              , BIEORF
              , BIRCST
              , BIAUSR
              , BIADAT
              , BIATIM
              , BICUSR
              , BICDAT
              , BICTIM
              )
          VALUES
              ( l_v_bline
              , l_v_btrad
              , l_v_bagnt
              , p_i_v_booking_no
              , l_v_max_seq + 1
              , p_i_v_equipment_no
              , p_i_v_equipment_size
              , p_i_v_equipment_type
              , l_n_sup_sqno
              , 'L'
              , l_v_local_status
              , l_v_styp
              , l_v_spl_hdl
              , l_n_grs_wght
              , l_v_full_mt
              , 'A'
              , g_v_user
              , l_n_num_date
              , l_n_num_time
              , g_v_user
              , l_n_num_date
              , l_n_num_time
             );
       EXCEPTION
          WHEN OTHERS THEN
             g_v_err_code := TO_CHAR (SQLCODE);
             g_v_err_desc := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
       END;
       g_v_sql_id := 'SQL-04006';
       BEGIN
          PRE_BKG_RECALCULATE_DATA('L', p_i_v_booking_no, p_o_v_return_status);
            IF p_o_v_return_status = '1' THEN
               g_v_err_code := TO_CHAR (SQLCODE);
               g_v_err_desc := SUBSTR(SQLERRM,1,100);
               RAISE l_exce_main;
            END IF;
       EXCEPTION
          WHEN OTHERS THEN
             g_v_err_code := TO_CHAR (SQLCODE);
             g_v_err_desc := SUBSTR(SQLERRM,1,100);
             RAISE l_exce_main;
       END;
       p_o_v_return_status := '0';
       --COMMIT;
    EXCEPTION
        WHEN l_exce_main THEN
            p_o_v_return_status := '1';
         WHEN OTHERS THEN
            p_o_v_return_status := '1';
             g_v_err_code   := TO_CHAR (SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
    END PRE_BKG_AUTOEXPAND;

/*
    Block started by vikas to take backup before updating BKP009, 20.02.2012
*/

/*-----------------------------------------------------------------------------------------------------------
PRR_INS_TOS_BKG_CNTR.SQL
-------------------------------------------------------------------------------------------------------------
Copyright RCL Public Co., Ltd. 2008
-------------------------------------------------------------------------------------------------------------
Author Sukit Narinsakchai 17/02/2012
- Change Log ------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------*/
/*
 */
PROCEDURE PRR_INS_TOS_BKG_CNTR(P_BKG_NO IN VARCHAR2
                                  ,P_CONT_SEQNO IN NUMBER
                                  ,P_USERNAME IN VARCHAR2) IS

    V_PK_BKG_CONT_ID            NUMBER := 0;
    V_SUPLIER_SEQNO                NUMBER := 0;
    V_BKG_SIZE_TYPE_DTL          NUMBER := 0;
    V_EQUIPMENT_NO                 VARCHAR2(12);
    V_EQP_VERSION                NUMBER := 0;
BEGIN

    INSERT INTO TOS_BKG_CNTR (PK_BKG_CNTR_ID,FK_BOOKING_NO,FK_BKG_SIZE_TYPE_DTL,FK_BKG_SUPPLIER,FK_BKG_EQUIPM_DTL,EQP_VER,DN_EQUIPMENT_NO
        ,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE)
    SELECT  SR_TOS_BCZ01.NEXTVAL
                ,P_BKG_NO
            ,(SELECT EQP_SIZETYPE_SEQNO FROM BOOKING_SUPPLIER_DETAIL BS WHERE BOOKING_NO = BIBKNO AND BS.SUPPLIER_SQNO = B.SUPPLIER_SQNO) AS FK_BKG_SIZE_TYPE_DTL
            ,SUPPLIER_SQNO
            ,BISEQN
            ,(SELECT NVL(MAX(EQP_VER),0)+1 FROM TOS_BKG_CNTR WHERE FK_BOOKING_NO = BIBKNO AND FK_BKG_EQUIPM_DTL = BISEQN) AS EQP_VER
            ,BICTRN
            ,'A'
            ,P_USERNAME
            ,SYSDATE
            ,P_USERNAME
            ,SYSDATE
    FROM BKP009 B
    WHERE BIBKNO = P_BKG_NO AND BISEQN = P_CONT_SEQNO;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    V_EQP_VERSION := 0;

END PRR_INS_TOS_BKG_CNTR;
/*
    Block ended by vikas to take backup before updating BKP009, 20.02.2012
*/

END PCE_ECM_SYNC_EZLL_BOOKING;
