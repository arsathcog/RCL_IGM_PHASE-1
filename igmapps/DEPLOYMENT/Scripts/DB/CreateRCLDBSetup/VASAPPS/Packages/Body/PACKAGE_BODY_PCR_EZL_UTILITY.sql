CREATE OR REPLACE PACKAGE BODY "PCR_EZL_UTILITY" AS
  /*-----------------------------------------------------------------------------------------------------------
  PRR_DL_REMOVE_DUP_CONT.sql
  - Remove duplicate comtainer in Discharge list
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2008
  -------------------------------------------------------------------------------------------------------------
  Author Sukit Narinsakchai 11/01/2012
  - Change Log ------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------*/
  PROCEDURE PRR_DL_REMOVE_DUP_CONT(P_USERNAME IN VARCHAR2 DEFAULT NULL) IS
    V_RETURN NUMBER := 0;
  BEGIN
    DELETE FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE D
     WHERE EXISTS
     (SELECT PK_BOOKED_DISCHARGE_ID
              FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE BD,
                   (SELECT DN_EQUIPMENT_NO,
                           FK_DISCHARGE_LIST_ID,
                           FK_BOOKING_NO,
                           COUNT(1) TOTAL
                      FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE
                     WHERE DN_EQUIPMENT_NO IS NOT NULL
                     GROUP BY DN_EQUIPMENT_NO,
                              FK_DISCHARGE_LIST_ID,
                              FK_BOOKING_NO
                    HAVING COUNT(1) > 1) TAB
             WHERE BD.DN_EQUIPMENT_NO = TAB.DN_EQUIPMENT_NO
               AND BD.FK_DISCHARGE_LIST_ID = TAB.FK_DISCHARGE_LIST_ID
               AND BD.FK_BOOKING_NO = TAB.FK_BOOKING_NO
               AND PK_BOOKED_DISCHARGE_ID <>
                   (SELECT MAX(PK_BOOKED_DISCHARGE_ID)
                      FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE DL
                     WHERE DL.FK_BOOKING_NO = BD.FK_BOOKING_NO
                       AND DL.DN_EQUIPMENT_NO = BD.DN_EQUIPMENT_NO
                       AND DL.FK_DISCHARGE_LIST_ID = BD.FK_DISCHARGE_LIST_ID)
               AND BD.PK_BOOKED_DISCHARGE_ID = D.PK_BOOKED_DISCHARGE_ID);
  EXCEPTION
    WHEN OTHERS THEN
      V_RETURN := 0;
  END PRR_DL_REMOVE_DUP_CONT;

  /*-----------------------------------------------------------------------------------------------------------
  PRR_LL_REMOVE_DUP_CONT.sql
  - Remove duplicate comtainer in Load list
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2008
  -------------------------------------------------------------------------------------------------------------
  Author Sukit Narinsakchai 11/01/2012
  - Change Log ------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------*/
  PROCEDURE PRR_LL_REMOVE_DUP_CONT(P_USERNAME IN VARCHAR2 DEFAULT NULL) IS
    V_RETURN NUMBER := 0;
  BEGIN
    DELETE FROM VASAPPS.TOS_LL_BOOKED_LOADING B
     WHERE EXISTS
     (SELECT BL.PK_BOOKED_LOADING_ID
              FROM VASAPPS.TOS_LL_BOOKED_LOADING BL,
                   (SELECT DN_EQUIPMENT_NO, FK_LOAD_LIST_ID, FK_BOOKING_NO
                      FROM VASAPPS.TOS_LL_BOOKED_LOADING
                     WHERE DN_EQUIPMENT_NO IS NOT NULL
                     GROUP BY DN_EQUIPMENT_NO, FK_LOAD_LIST_ID, FK_BOOKING_NO
                    HAVING COUNT(1) > 1) TAB
             WHERE BL.DN_EQUIPMENT_NO = TAB.DN_EQUIPMENT_NO
               AND BL.FK_LOAD_LIST_ID = TAB.FK_LOAD_LIST_ID
               AND BL.FK_BOOKING_NO = TAB.FK_BOOKING_NO
               AND PK_BOOKED_LOADING_ID <>
                   (SELECT MAX(PK_BOOKED_LOADING_ID)
                      FROM VASAPPS.TOS_LL_BOOKED_LOADING LL
                     WHERE LL.FK_BOOKING_NO = BL.FK_BOOKING_NO
                       AND LL.DN_EQUIPMENT_NO = BL.DN_EQUIPMENT_NO
                       AND LL.FK_LOAD_LIST_ID = BL.FK_LOAD_LIST_ID)
               AND BL.PK_BOOKED_LOADING_ID = B.PK_BOOKED_LOADING_ID);
  EXCEPTION
    WHEN OTHERS THEN
      V_RETURN := 0;
  END PRR_LL_REMOVE_DUP_CONT;

  /*-----------------------------------------------------------------------------------------------------------
  PRR_EZDL_CREATE.sql
  - Remove duplicate comtainer in Load list
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2008
  -------------------------------------------------------------------------------------------------------------
  Author Sukit Narinsakchai 17/01/2012
  - Change Log ------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------*/
  PROCEDURE PRR_EZDL_CREATE(P_I_V_BOOKING_NO IN VARCHAR2) IS
    /*
        if invoyage not found then set this value
    */
    P_I_V_INVOYAGENO       VARCHAR2(17) := '';
    P_I_N_VOYSEQ           NUMBER := NULL;
    P_I_N_DISCHARGEID      NUMBER := NULL;
    P_I_N_EQUIPMENT_SEQ_NO NUMBER := NULL;
    P_I_N_SIZE_TYPE_SEQ_NO NUMBER := NULL;
    P_I_N_SUPPLIER_SEQ_NO  NUMBER := NULL;
    P_O_V_RETURN_STATUS    VARCHAR2(1) := '0';
    --no need to input value
    /*
        End of input variable.
    */

    /*
        DECLARATION OF GLOBAL VARIABLE
    */
    G_V_USER             VARCHAR2(10) := 'EZLL';
    G_V_SQL_ID           VARCHAR2(15);
    G_V_ERR_CODE         VARCHAR2(50);
    G_V_ERR_DESC         VARCHAR2(100);
    G_V_ERR_HANDLER_FLG  VARCHAR2(1) := 'N';
    G_V_PROG_NAME        VARCHAR2(100) := 'PCE_ECM_SYNC_BOOKING_EZLL';
    G_V_RECORD_FILTER    VARCHAR2(1000);
    G_V_RECORD_TABLE     VARCHAR2(500);
    L_V_NEXT_SERVICE     VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_SRV%TYPE;
    L_V_NEXT_VESSEL      VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_VESSEL%TYPE;
    L_V_NEXT_VOYNO       VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_VOYAGE%TYPE;
    L_V_NEXT_DIR         VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_DIR%TYPE;
    L_N_LOAD_ID          VASAPPS.TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID%TYPE;
    L_V_IMO_CLASS        VASAPPS.TOS_LL_BOOKED_LOADING.FK_IMDG%TYPE;
    L_V_VARIANT          VASAPPS.TOS_LL_BOOKED_LOADING.FK_UN_VAR%TYPE;
    L_V_UN_NO            VASAPPS.TOS_LL_BOOKED_LOADING.FK_UNNO%TYPE;
    L_V_HZ_BS            VASAPPS.TOS_LL_BOOKED_LOADING.FLASH_UNIT%TYPE;
    L_V_NEXT_POD1        VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_POD1%TYPE;
    L_V_NEXT_POD2        VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_POD2%TYPE;
    L_V_NEXT_POD3        VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_POD3%TYPE;
    L_V_PORTCLASS        VASAPPS.TOS_LL_BOOKED_LOADING.FK_PORT_CLASS%TYPE;
    L_V_PORTCLASSTYPE    VASAPPS.TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP%TYPE;
    L_V_OP_CODE          VASAPPS.TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE;
    L_V_SLOT_OP_CODE     VASAPPS.TOS_LL_BOOKED_LOADING.FK_SLOT_OPERATOR%TYPE;
    L_V_OUT_SLOT_OP_CODE VASAPPS.TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE;
    L_V_LOCAL_STATUS     VASAPPS.TOS_LL_BOOKED_LOADING.LOCAL_STATUS%TYPE;
    L_V_GRP_CD           VASAPPS.TOS_LL_LOAD_LIST.DN_SERVICE_GROUP_CODE%TYPE;
    L_V_USER             VARCHAR2(50) := 'SYSTEM';
    L_V_CONT_SEQ         VASAPPS.TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO%TYPE;
    L_V_ROB              VARCHAR2(5);
    L_V_ERRCD            VASAPPS.TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
    L_V_ERRMSG           VARCHAR2(200);
    L_EXC_USER EXCEPTION;
    L_V_SQL_ID          VARCHAR2(5);
    L_D_TIME            TIMESTAMP;
    L_V_VERSION         VASAPPS.TOS_LL_LOAD_LIST.FK_VERSION%TYPE;
    L_V_STATUS          VARCHAR2(5);
    L_V_LOAD_STATUS     VASAPPS.TOS_LL_LOAD_LIST.LOAD_LIST_STATUS%TYPE;
    L_N_DISCHARGE_ID    VASAPPS.TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE;
    L_V_CHECK_LISTID    VARCHAR2(1) := 'Y';
    L_N_CHECK           NUMBER := 0;
    L_N_INSERT          NUMBER := 0;
    L_V_REC_COUNT       NUMBER := 0;
    L_N_LIST_UPD_ID     NUMBER;
    L_V_STOW_POS_ROB    VASAPPS.TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION%TYPE;
    L_V_FUMIGATION_ONLY VASAPPS.TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY%TYPE;
    --Added by bindu on 31/03/2011
    L_V_RESIDUE VASAPPS.TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG%TYPE;
    --Added by bindu on 31/03/2011
    L_I_V_INVOYAGENO  VASAPPS.TOS_DL_DISCHARGE_LIST.FK_VOYAGE%TYPE;
    L_V_RECORD_STATUS VARCHAR2(1);
    -- added by vikas, 01.12.2011
    L_V_DN_PORT                VASAPPS.TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE;
    L_V_DN_TERMINAL            VASAPPS.TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE;
    L_V_PK_BOOKED_DISCHARGE_ID VASAPPS.TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID%TYPE;
    L_V_IS_DG                  VARCHAR2(1);
    -- added by vikas to identify dg booking, 30.11.2011
    L_N_DISCHARGE_LIST_STATUS VASAPPS.TOS_DL_DISCHARGE_LIST.DISCHARGE_LIST_STATUS%TYPE;
    --Added by Rajeev on 04/04/2011
    P_O_V_ERROR VARCHAR2(100);

    CURSOR L_CUR_VOYAGE IS
      SELECT ACT_SERVICE_CODE,
             ACT_VESSEL_CODE,
             ACT_VOYAGE_NUMBER,
             ACT_PORT_DIRECTION,
             ACT_PORT_SEQUENCE,
             LOAD_PORT,
             DISCHARGE_PORT,
             FROM_TERMINAL,
             TO_TERMINAL,
             BOOKING_NO,
             VOYAGE_SEQNO
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_I_V_BOOKING_NO
         AND ROUTING_TYPE = 'S'
         AND VOYAGE_SEQNO = NVL(P_I_N_VOYSEQ, VOYAGE_SEQNO)
         AND VESSEL IS NOT NULL
         AND VOYNO IS NOT NULL
       ORDER BY VOYAGE_SEQNO;

    CURSOR L_CUR_DETAIL IS
      SELECT T_032.EQP_SIZETYPE_SEQNO FK_BKG_SIZE_TYPE_DTL,
             T_032.POD_STAT LOCAL_STATUS,
             T_032.BUNDLE,
             T_032.OPR_VOID_SLOT VOID_SLOT,
             T_032.HANDLING_INS1 FK_HANDLING_INSTRUCTION_1,
             T_032.HANDLING_INS2 FK_HANDLING_INSTRUCTION_2,
             T_032.HANDLING_INS3 FK_HANDLING_INSTRUCTION_3,
             T_032.CLR_CODE1 CONTAINER_LOADING_REM_1,
             T_032.CLR_CODE2 CONTAINER_LOADING_REM_2,
             T_032.SPECIAL_CARGO_CODE FK_SPECIAL_CARGO,
             T_001.BOOKING_TYPE DN_BKG_TYP,
             T_001.BABKTP DN_SOC_COC,
             T_001.BAMODE DN_SHIPMENT_TERM,
             T_001.BASTP1 DN_SHIPMENT_TYP,
             T_001.BAOPCD SLOT_PARTNER_CODE,
             T_001.BADSTN FINAL_DEST,
             MLO_VESSEL EX_MLO_VESSEL,
             DECODE(T_001.BABKTP, 'C', 'RCL', L_V_OP_CODE) FK_CONTAINER_OPERATOR,
             T_009.HUMIDITY HUMIDITY,
             T_001.BAOPCD FK_SLOT_OPERATOR,
             VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.FE_DATE_TIME(MLO_ETA,
                                                            MLO_ETA_TIME) EX_MLO_VESSEL_ETA,
             T_001.BAPOD DN_FINAL_POD,
             MLO_VOYAGE EX_MLO_VOYAGE,
             BIBKNO FK_BOOKING_NO,
             BISEQN FK_BKG_EQUIPM_DTL,
             BICTRN DN_EQUIPMENT_NO,
             DECODE(BICTRN, NULL, NULL, 'B') EQUPMENT_NO_SOURCE,
             BICSZE DN_EQ_SIZE,
             BICNTP DN_EQ_TYPE,
             BIEORF DN_FULL_MT,
             (CASE
               WHEN T_009.SHIPMENT_TYPE = 'BBK' THEN
                'L'
               WHEN T_032.BUNDLE > 0 THEN
                'P'
               ELSE
                BIEORF
             END) LOAD_CONDITION,
             'BK' LOADING_STATUS,
             MET_WEIGHT CONTAINER_GROSS_WEIGHT,
             T_009.SPECIAL_HANDLING DN_SPECIAL_HNDL,
             BIXHGT OVERHEIGHT_CM,
             BIXWDL OVERWIDTH_LEFT_CM,
             BIXWDR OVERWIDTH_RIGHT_CM,
             BIXLNF OVERLENGTH_FRONT_CM,
             BIXLNB OVERLENGTH_REAR_CM,
             BIRFFM REEFER_TMP,
             BIRFBS REEFER_TMP_UNIT,
             T_009.SUPPLIER_SQNO FK_BKG_SUPPLIER,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_FUMIGATION_ONLY
               ELSE
                NULL
             END) FUMIGATION_ONLY,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_RESIDUE
               ELSE
                NULL
             END) RESIDUE_ONLY_FLAG,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_IMO_CLASS
               ELSE
                NULL
             END) FK_IMDG,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_UN_NO
               ELSE
                NULL
             END) FK_UNNO,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_VARIANT
               ELSE
                NULL
             END) FK_UN_VAR,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_PORTCLASS
               ELSE
                NULL
             END) FK_PORT_CLASS,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_PORTCLASSTYPE
               ELSE
                NULL
             END) FK_PORT_CLASS_TYP,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_HZ_BS
               ELSE
                NULL
             END) FLASH_UNIT,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                BIFLPT
               ELSE
                NULL
             END) FLASH_POINT,
             T_009.AIR_PRESSURE DN_VENTILATION
        FROM BKP032                  T_032,
             BKP001                  T_001,
             BKP009                  T_009,
             BOOKING_SUPPLIER_DETAIL BSD
       WHERE T_032.EQP_SIZETYPE_SEQNO = BSD.EQP_SIZETYPE_SEQNO
         AND T_032.BCBKNO = BSD.BOOKING_NO
         AND T_032.BCBKNO = T_001.BABKNO
         AND T_009.BIBKNO = T_001.BABKNO
         AND T_009.SUPPLIER_SQNO = BSD.SUPPLIER_SQNO
         AND T_001.BABKNO = P_I_V_BOOKING_NO
         AND T_009.BISEQN = NVL(P_I_N_EQUIPMENT_SEQ_NO, T_009.BISEQN)
         AND T_032.EQP_SIZETYPE_SEQNO =
             NVL(P_I_N_SIZE_TYPE_SEQ_NO, T_032.EQP_SIZETYPE_SEQNO)
         AND T_009.SUPPLIER_SQNO =
             NVL(P_I_N_SUPPLIER_SEQ_NO, T_009.SUPPLIER_SQNO);
  BEGIN
    L_D_TIME    := CURRENT_TIMESTAMP;
    L_V_STATUS  := 'BK';
    L_V_VERSION := '99';

    --Select operator code
    BEGIN
      G_V_SQL_ID := 'SQL-04001';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      SELECT NVL(MAX(CASE
                       WHEN BKP.BNCSTP = 'O' THEN
                        OPERATOR_CODE
                       ELSE
                        NULL
                     END),
                 '****') OPERATOR_CODE
        INTO L_V_OP_CODE --,l_v_slot_op_code
        FROM ITP010 ITP, BKP030 BKP
       WHERE ITP.CUCUST = BKP.BNCSCD
         AND BKP.BNCSTP IN ('O')
         AND BNBKNO = P_I_V_BOOKING_NO;
    EXCEPTION
      WHEN OTHERS THEN
        G_V_RECORD_FILTER := 'BNBKNO:' || P_I_V_BOOKING_NO;
        G_V_RECORD_TABLE  := 'Operator Code Not found in ITP010,BKP030';
    END;

    --Imo class,un no etc from dg_comm_detail
    BEGIN
      G_V_SQL_ID := 'SQL-04002';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      SELECT '1',
             IMO_CLASS,
             UN_NO,
             HZ_BS,
             NVL(UN_VARIANT, '-'),
             FUMIGATION_YN,
             RESIDUE
        INTO L_V_IS_DG,
             L_V_IMO_CLASS,
             L_V_UN_NO,
             L_V_HZ_BS,
             L_V_VARIANT,
             L_V_FUMIGATION_ONLY,
             L_V_RESIDUE
        FROM BOOKING_DG_COMM_DETAIL
       WHERE BOOKING_NO = P_I_V_BOOKING_NO
         AND IMO_CLASS = (SELECT MIN(IMO_CLASS)
                            FROM BOOKING_DG_COMM_DETAIL
                           WHERE BOOKING_NO = P_I_V_BOOKING_NO)
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        L_V_IMO_CLASS       := NULL;
        L_V_UN_NO           := NULL;
        L_V_HZ_BS           := NULL;
        L_V_VARIANT         := NULL;
        L_V_FUMIGATION_ONLY := NULL;
        L_V_RESIDUE         := NULL;
        G_V_RECORD_FILTER   := 'BOOKING_NO:' || P_I_V_BOOKING_NO;
        G_V_RECORD_TABLE    := 'IMO_CLASS Not found in BOOKING_DG_COMM_DETAIL';
    END;

    --Main cursor from routing table
    G_V_SQL_ID := 'SQL-04003';
    DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

    FOR L_CUR_VOYAGE_REC IN L_CUR_VOYAGE LOOP
      G_V_SQL_ID := 'SQL-04004';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      BEGIN
        /*
            Get next pod values
        */
        VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_GET_NEXT_POD(L_CUR_VOYAGE_REC.BOOKING_NO,
                                                           L_CUR_VOYAGE_REC.VOYAGE_SEQNO,
                                                           L_V_NEXT_POD1,
                                                           L_V_NEXT_POD2,
                                                           L_V_NEXT_POD3,
                                                           L_V_NEXT_SERVICE,
                                                           L_V_NEXT_VESSEL,
                                                           L_V_NEXT_VOYNO,
                                                           L_V_NEXT_DIR);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      L_I_V_INVOYAGENO := NULL;

      IF L_CUR_VOYAGE_REC.ACT_SERVICE_CODE = 'AFS' THEN
        -- do for DFS
        L_I_V_INVOYAGENO := L_CUR_VOYAGE_REC.ACT_VOYAGE_NUMBER;
      ELSIF L_CUR_VOYAGE_REC.ACT_SERVICE_CODE = 'DFS' THEN
        -- do for DFS
        L_I_V_INVOYAGENO := L_CUR_VOYAGE_REC.ACT_VOYAGE_NUMBER;
      ELSE
        --Get INVOYAGENO from ITP063
        BEGIN
          SELECT INVOYAGENO
            INTO L_I_V_INVOYAGENO
            FROM ITP063
           WHERE VVSRVC = L_CUR_VOYAGE_REC.ACT_SERVICE_CODE
             AND VVVESS = L_CUR_VOYAGE_REC.ACT_VESSEL_CODE
             AND VVVOYN = L_CUR_VOYAGE_REC.ACT_VOYAGE_NUMBER
             AND VVPDIR = L_CUR_VOYAGE_REC.ACT_PORT_DIRECTION
             AND VVPCSQ = L_CUR_VOYAGE_REC.ACT_PORT_SEQUENCE
             AND VVPCAL = L_CUR_VOYAGE_REC.DISCHARGE_PORT
             AND VVTRM1 = L_CUR_VOYAGE_REC.TO_TERMINAL
             AND VVVERS = 99;
        EXCEPTION
          WHEN OTHERS THEN
            L_I_V_INVOYAGENO := P_I_V_INVOYAGENO;
            DBMS_OUTPUT.PUT_LINE(L_CUR_VOYAGE_REC.ACT_SERVICE_CODE || '~' ||
                                 L_CUR_VOYAGE_REC.ACT_VESSEL_CODE || '~' ||
                                 L_CUR_VOYAGE_REC.ACT_VOYAGE_NUMBER || '~' ||
                                 L_CUR_VOYAGE_REC.ACT_PORT_DIRECTION || '~' ||
                                 L_CUR_VOYAGE_REC.ACT_PORT_SEQUENCE || '~' ||
                                 L_CUR_VOYAGE_REC.DISCHARGE_PORT || '~' ||
                                 L_CUR_VOYAGE_REC.TO_TERMINAL);
        END;
      END IF;

      --Check discharge list exist or not
      G_V_SQL_ID := 'SQL-04005';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      IF P_I_N_DISCHARGEID IS NULL THEN
        BEGIN
          G_V_SQL_ID := 'SQL-04006';
          DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);
          L_V_CHECK_LISTID := 'N';

          /* if invoyage found in ITP063 Table.*/
          IF L_I_V_INVOYAGENO IS NOT NULL THEN
            SELECT DISTINCT PK_DISCHARGE_LIST_ID
              INTO L_N_DISCHARGE_ID
              FROM VASAPPS.TOS_DL_DISCHARGE_LIST
             WHERE FK_SERVICE = L_CUR_VOYAGE_REC.ACT_SERVICE_CODE
               AND FK_VESSEL = L_CUR_VOYAGE_REC.ACT_VESSEL_CODE
               AND FK_VOYAGE = L_I_V_INVOYAGENO
               AND FK_DIRECTION = L_CUR_VOYAGE_REC.ACT_PORT_DIRECTION
               AND DN_PORT = L_CUR_VOYAGE_REC.DISCHARGE_PORT
               AND DN_TERMINAL = L_CUR_VOYAGE_REC.TO_TERMINAL
               AND RECORD_STATUS = 'A'
               AND ROWNUM = 1; -- Added by vikas, 08.12.2011
          ELSE
            /* if invoyage details is already deleted from ITP063 Table.*/
            SELECT DISTINCT DL.PK_DISCHARGE_LIST_ID
              INTO L_N_DISCHARGE_ID
              FROM VASAPPS.TOS_DL_DISCHARGE_LIST   DL,
                   VASAPPS.TOS_DL_BOOKED_DISCHARGE BKD
             WHERE DL.FK_SERVICE = L_CUR_VOYAGE_REC.ACT_SERVICE_CODE
               AND DL.FK_VESSEL = L_CUR_VOYAGE_REC.ACT_VESSEL_CODE
               AND DL.FK_DIRECTION = L_CUR_VOYAGE_REC.ACT_PORT_DIRECTION
               AND DL.DN_PORT = L_CUR_VOYAGE_REC.DISCHARGE_PORT
               AND DL.DN_TERMINAL = L_CUR_VOYAGE_REC.TO_TERMINAL
               AND DL.RECORD_STATUS = 'A'
               AND DL.PK_DISCHARGE_LIST_ID = BKD.FK_DISCHARGE_LIST_ID
               AND BKD.FK_BOOKING_NO = P_I_V_BOOKING_NO
               AND ROWNUM = 1; -- Added by vikas, 08.12.2011
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            L_N_DISCHARGE_ID := NULL;
        END;
      ELSE
        L_N_DISCHARGE_ID := P_I_N_DISCHARGEID;
      END IF; -- end if of dischargeid

      --Port class type
      BEGIN
        G_V_SQL_ID := 'SQL-04007';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        /*    Modified by vikas if normal booking then no need to
        validate port class and port code, as k'chatgamol, 30.11.2011    */
        IF L_V_IS_DG = '1' THEN
          SELECT PORT_CLASS_TYPE
            INTO L_V_PORTCLASSTYPE
            FROM PORT_CLASS_TYPE
           WHERE PORT_CODE = L_CUR_VOYAGE_REC.LOAD_PORT;
        END IF;
        /*    End Modified vikas, 30.11.2011    */
      EXCEPTION
        WHEN OTHERS THEN
          L_V_PORTCLASS := NULL;
      END;

      --Port code
      BEGIN
        G_V_SQL_ID := 'SQL-04008';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        /*
            Modified by vikas if normal booking then no need to
            validate port class and port code, as k'chatgamol, 30.11.2011
        */
        IF L_V_IS_DG = '1' THEN
          SELECT PORT_CLASS_CODE
            INTO L_V_PORTCLASS
            FROM PORT_CLASS
           WHERE UNNO = L_V_UN_NO
             AND VARIANT = NVL(L_V_VARIANT, '-')
                -- Change by vikas, varint can not null, 18.11.2011
             AND IMDG_CLASS = L_V_IMO_CLASS
             AND PORT_CLASS_TYPE = L_V_PORTCLASSTYPE;
        END IF;
        /*
            End Modified vikas, 30.11.2011
        */
      EXCEPTION
        WHEN OTHERS THEN
          L_V_PORTCLASS := NULL;
      END;

      --Service group code
      BEGIN
        G_V_SQL_ID := 'SQL-04009';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        SELECT SERVICE_GROUP_CODE
          INTO L_V_GRP_CD
          FROM ITP085
         WHERE SWSRVC = L_CUR_VOYAGE_REC.ACT_SERVICE_CODE;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      --If load list not exists then make and insert in load list table
      IF L_N_DISCHARGE_ID IS NULL THEN
        G_V_SQL_ID := 'SQL-04010';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        SELECT VASAPPS.SE_DLZ01.NEXTVAL INTO L_N_DISCHARGE_ID FROM DUAL;

        INSERT INTO VASAPPS.TOS_DL_DISCHARGE_LIST
          (PK_DISCHARGE_LIST_ID,
           DN_SERVICE_GROUP_CODE,
           FK_SERVICE,
           FK_VESSEL,
           FK_VOYAGE,
           FK_DIRECTION,
           FK_PORT_SEQUENCE_NO,
           FK_VERSION,
           DN_PORT,
           DN_TERMINAL,
           DISCHARGE_LIST_STATUS,
           DA_DISCHARGED_TOT,
           DA_BOOKED_TOT,
           DA_ROB_TOT,
           DA_OVERLANDED_TOT,
           DA_SHORTLANDED_TOT,
           RECORD_STATUS,
           RECORD_ADD_USER,
           RECORD_ADD_DATE,
           RECORD_CHANGE_USER,
           RECORD_CHANGE_DATE)
        VALUES
          (L_N_DISCHARGE_ID,
           L_V_GRP_CD,
           L_CUR_VOYAGE_REC.ACT_SERVICE_CODE,
           L_CUR_VOYAGE_REC.ACT_VESSEL_CODE,
           L_I_V_INVOYAGENO,
           L_CUR_VOYAGE_REC.ACT_PORT_DIRECTION,
           L_CUR_VOYAGE_REC.ACT_PORT_SEQUENCE,
           L_V_VERSION,
           L_CUR_VOYAGE_REC.DISCHARGE_PORT,
           L_CUR_VOYAGE_REC.TO_TERMINAL,
           '0',
           0,
           0,
           0,
           0,
           0,
           'A',
           G_V_USER,
           L_D_TIME,
           G_V_USER,
           L_D_TIME);
      END IF;

      G_V_SQL_ID := 'SQL-04011';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      --Deatail cursor from BKP009,BKP032,BKP001
      FOR L_CUR_DETAIL_REC IN L_CUR_DETAIL LOOP
        BEGIN
          G_V_SQL_ID := 'SQL-04012';
          DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

          SELECT STOWAGE_POSITION
            INTO L_V_STOW_POS_ROB
            FROM VASAPPS.BKG_ROB_CONTAINER
           WHERE FK_DEPARTURE_BOOKING_NUMBER = L_CUR_VOYAGE_REC.BOOKING_NO
             AND CONTAINER_NUMBER = L_CUR_DETAIL_REC.DN_EQUIPMENT_NO;
        EXCEPTION
          WHEN OTHERS THEN
            L_V_STOW_POS_ROB  := NULL;
            G_V_RECORD_FILTER := 'FK_DEPARTURE_BOOKING_NUMBER:' ||
                                 L_CUR_VOYAGE_REC.BOOKING_NO ||
                                 ' CONTAINER_NUMBER:' ||
                                 L_CUR_DETAIL_REC.DN_EQUIPMENT_NO;
            G_V_RECORD_TABLE  := 'Error occured.Contact System administrator';
        END;

        --For loading status
        G_V_SQL_ID := 'SQL-04012';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        BEGIN
          SELECT LOADING_STATUS
            INTO L_V_LOAD_STATUS
            FROM VASAPPS.TOS_LL_BOOKED_LOADING
           WHERE FK_BOOKING_NO = L_CUR_VOYAGE_REC.BOOKING_NO
             AND FK_BKG_EQUIPM_DTL = L_CUR_DETAIL_REC.FK_BKG_EQUIPM_DTL
             AND FK_BKG_VOYAGE_ROUTING_DTL = L_CUR_VOYAGE_REC.VOYAGE_SEQNO
             AND DN_DISCHARGE_PORT = L_CUR_VOYAGE_REC.DISCHARGE_PORT
             AND DN_DISCHARGE_TERMINAL = L_CUR_VOYAGE_REC.TO_TERMINAL
                -- added, 09.12.2011
             AND RECORD_STATUS = 'A';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_V_LOAD_STATUS := 'X';
          WHEN OTHERS THEN
            L_V_LOAD_STATUS := 'BK';
        END;

        IF L_CUR_VOYAGE_REC.DISCHARGE_PORT = L_CUR_DETAIL_REC.DN_FINAL_POD THEN
          L_V_LOCAL_STATUS := L_CUR_DETAIL_REC.LOCAL_STATUS;
        ELSE
          L_V_LOCAL_STATUS := 'T';
        END IF;

        G_V_SQL_ID := 'SQL-04013';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        --Get Slot Operator
        IF L_V_LOCAL_STATUS = 'T' THEN
          L_V_OUT_SLOT_OP_CODE := 'RCL';
        ELSIF L_CUR_DETAIL_REC.DN_SOC_COC = 'S' THEN
          IF L_CUR_DETAIL_REC.DN_BKG_TYP IN ('N', 'ER') THEN
            L_V_OUT_SLOT_OP_CODE := L_V_OP_CODE;
          ELSE
            L_V_OUT_SLOT_OP_CODE := L_CUR_DETAIL_REC.SLOT_PARTNER_CODE;
          END IF;
        END IF;

        L_N_INSERT := 0;
        G_V_SQL_ID := 'SQL-04015';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        IF L_CUR_DETAIL_REC.DN_EQUIPMENT_NO IS NOT NULL THEN
          BEGIN
            G_V_SQL_ID := 'SQL-04016';
            DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

            /*    Start Added by vikas 26.11.2011    */
            SELECT 1, PK_BOOKED_DISCHARGE_ID, RECORD_STATUS
              INTO L_N_CHECK, L_N_LIST_UPD_ID, L_V_RECORD_STATUS
              FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE
             WHERE DN_EQUIPMENT_NO = L_CUR_DETAIL_REC.DN_EQUIPMENT_NO
               AND (RECORD_STATUS = 'S' OR
                   FK_DISCHARGE_LIST_ID = L_N_DISCHARGE_ID)
               AND ROWNUM = 1;

            /*    End Added by vikas 26.11.2011    */
            IF (L_V_RECORD_STATUS = 'S') THEN
              G_V_SQL_ID := 'SQL-04014';
              DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

              SELECT NVL(MAX(CONTAINER_SEQ_NO), 0)
                INTO L_V_CONT_SEQ
                FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE
               WHERE FK_DISCHARGE_LIST_ID = L_N_DISCHARGE_ID;

              L_V_CONT_SEQ := L_V_CONT_SEQ + 1;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              L_N_CHECK         := 0;
              G_V_RECORD_FILTER := 'DN_EQUIPMENT_NO:' ||
                                   L_CUR_DETAIL_REC.DN_EQUIPMENT_NO ||
                                   ' RECORD_STATUS =A';
              G_V_RECORD_TABLE  := 'Booking Discharge ID Not found in TOS_DL_BOOKED_DISCHARGE';
          END;

          IF L_N_CHECK = 1 THEN
            G_V_SQL_ID := 'SQL-04017';
            DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

            UPDATE VASAPPS.TOS_DL_BOOKED_DISCHARGE
               SET RECORD_STATUS             = 'A',
                   FK_DISCHARGE_LIST_ID      = L_N_DISCHARGE_ID,
                   CONTAINER_SEQ_NO          = CASE WHEN(L_V_RECORD_STATUS = 'S') THEN L_V_CONT_SEQ ELSE CONTAINER_SEQ_NO END,
                   FK_BOOKING_NO             = L_CUR_DETAIL_REC.FK_BOOKING_NO,
                   FK_BKG_SIZE_TYPE_DTL      = L_CUR_DETAIL_REC.FK_BKG_SIZE_TYPE_DTL,
                   FK_BKG_SUPPLIER           = L_CUR_DETAIL_REC.FK_BKG_SUPPLIER,
                   FK_BKG_EQUIPM_DTL         = L_CUR_DETAIL_REC.FK_BKG_EQUIPM_DTL,
                   FK_BKG_VOYAGE_ROUTING_DTL = L_CUR_VOYAGE_REC.VOYAGE_SEQNO,
                   DN_EQ_SIZE                = L_CUR_DETAIL_REC.DN_EQ_SIZE,
                   DN_EQ_TYPE                = L_CUR_DETAIL_REC.DN_EQ_TYPE,
                   DN_FULL_MT                = L_CUR_DETAIL_REC.DN_FULL_MT,
                   DN_BKG_TYP                = L_CUR_DETAIL_REC.DN_BKG_TYP,
                   DN_SOC_COC                = L_CUR_DETAIL_REC.DN_SOC_COC,
                   DN_SHIPMENT_TERM          = L_CUR_DETAIL_REC.DN_SHIPMENT_TERM,
                   DN_SHIPMENT_TYP           = L_CUR_DETAIL_REC.DN_SHIPMENT_TYP,
                   LOCAL_STATUS              = L_V_LOCAL_STATUS,
                   DN_LOADING_STATUS         = L_V_LOAD_STATUS,
                   VOID_SLOT                 = L_CUR_DETAIL_REC.VOID_SLOT,
                   FK_SLOT_OPERATOR          = L_CUR_DETAIL_REC.FK_SLOT_OPERATOR,
                   DN_SPECIAL_HNDL           = L_CUR_DETAIL_REC.DN_SPECIAL_HNDL,
                   DN_POL                    = L_CUR_VOYAGE_REC.LOAD_PORT,
                   DN_POL_TERMINAL           = L_CUR_VOYAGE_REC.FROM_TERMINAL,
                   DN_NXT_POD1               = L_V_NEXT_POD1,
                   DN_NXT_POD2               = L_V_NEXT_POD2,
                   DN_NXT_POD3               = L_V_NEXT_POD3,
                   DN_FINAL_POD              = L_CUR_DETAIL_REC.DN_FINAL_POD,
                   FINAL_DEST                = L_CUR_DETAIL_REC.FINAL_DEST,
                   DN_NXT_SRV                = L_V_NEXT_SERVICE,
                   DN_NXT_VESSEL             = L_V_NEXT_VESSEL,
                   DN_NXT_VOYAGE             = L_V_NEXT_VOYNO,
                   DN_NXT_DIR                = L_V_NEXT_DIR,
                   RECORD_CHANGE_USER        = G_V_USER,
                   RECORD_CHANGE_DATE        = L_D_TIME
             WHERE DN_EQUIPMENT_NO = L_CUR_DETAIL_REC.DN_EQUIPMENT_NO
               AND (RECORD_STATUS = 'S' OR
                   FK_DISCHARGE_LIST_ID = L_N_DISCHARGE_ID)
               AND PK_BOOKED_DISCHARGE_ID = L_N_LIST_UPD_ID;

            L_N_INSERT := 1;
          END IF;

          IF L_N_INSERT = 0 THEN
            G_V_SQL_ID := 'SQL-0401A';
            DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

            SELECT NVL(MAX(CONTAINER_SEQ_NO), 0)
              INTO L_V_CONT_SEQ
              FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE
             WHERE FK_DISCHARGE_LIST_ID = L_N_DISCHARGE_ID;

            L_V_CONT_SEQ := L_V_CONT_SEQ + 1;
            G_V_SQL_ID   := 'SQL-0408';
            DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

            IF (L_CUR_DETAIL_REC.DN_EQUIPMENT_NO IS NOT NULL) THEN
              IF P_I_N_EQUIPMENT_SEQ_NO IS NOT NULL AND
                 P_I_N_SIZE_TYPE_SEQ_NO IS NOT NULL AND
                 P_I_N_SUPPLIER_SEQ_NO IS NOT NULL THEN
                BEGIN
                  SELECT DISCHARGE_LIST_STATUS
                    INTO L_N_DISCHARGE_LIST_STATUS
                    FROM VASAPPS.TOS_DL_DISCHARGE_LIST
                   WHERE PK_DISCHARGE_LIST_ID = L_N_DISCHARGE_ID;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    L_N_DISCHARGE_LIST_STATUS := 0;
                    G_V_RECORD_FILTER         := 'PK_DISCHARGE_LIST_ID:' ||
                                                 L_N_DISCHARGE_ID;
                    G_V_RECORD_TABLE          := 'Discharge List Status Not found in TOS_DL_DISCHARGE_LIST';
                END;
              END IF; -- end if of discharge list status

              INSERT INTO VASAPPS.TOS_DL_BOOKED_DISCHARGE
                (PK_BOOKED_DISCHARGE_ID,
                 FK_DISCHARGE_LIST_ID,
                 CONTAINER_SEQ_NO,
                 FK_BOOKING_NO,
                 FK_BKG_SIZE_TYPE_DTL,
                 FK_BKG_SUPPLIER,
                 FK_BKG_EQUIPM_DTL,
                 DN_EQUIPMENT_NO,
                 FK_BKG_VOYAGE_ROUTING_DTL,
                 DN_EQ_SIZE,
                 DN_EQ_TYPE,
                 DN_FULL_MT,
                 DN_BKG_TYP,
                 DN_SOC_COC,
                 DN_SHIPMENT_TERM,
                 DN_SHIPMENT_TYP,
                 LOCAL_STATUS,
                 DISCHARGE_STATUS,
                 LOAD_CONDITION,
                 DN_LOADING_STATUS,
                 CONTAINER_GROSS_WEIGHT,
                 VOID_SLOT,
                 FK_SLOT_OPERATOR,
                 FK_CONTAINER_OPERATOR,
                 OUT_SLOT_OPERATOR,
                 DN_SPECIAL_HNDL,
                 DN_POL,
                 DN_POL_TERMINAL,
                 DN_NXT_POD1,
                 DN_NXT_POD2,
                 DN_NXT_POD3,
                 DN_FINAL_POD,
                 FINAL_DEST,
                 DN_NXT_SRV,
                 DN_NXT_VESSEL,
                 DN_NXT_VOYAGE,
                 DN_NXT_DIR,
                 FK_HANDLING_INSTRUCTION_1,
                 FK_HANDLING_INSTRUCTION_2,
                 FK_HANDLING_INSTRUCTION_3,
                 CONTAINER_LOADING_REM_1,
                 CONTAINER_LOADING_REM_2,
                 FK_SPECIAL_CARGO,
                 FK_IMDG,
                 FK_UNNO,
                 FK_UN_VAR,
                 FK_PORT_CLASS,
                 FK_PORT_CLASS_TYP,
                 FLASH_UNIT,
                 FLASH_POINT,
                 FUMIGATION_ONLY,
                 RESIDUE_ONLY_FLAG,
                 OVERHEIGHT_CM,
                 OVERWIDTH_LEFT_CM,
                 OVERWIDTH_RIGHT_CM,
                 OVERLENGTH_FRONT_CM,
                 OVERLENGTH_REAR_CM,
                 REEFER_TEMPERATURE,
                 REEFER_TMP_UNIT,
                 DN_HUMIDITY,
                 DN_VENTILATION,
                 STOWAGE_POSITION,
                 RECORD_STATUS,
                 RECORD_ADD_USER,
                 RECORD_ADD_DATE,
                 RECORD_CHANGE_USER,
                 RECORD_CHANGE_DATE,
                 LOCAL_TERMINAL_STATUS --ADDED ON 29/04/2011.
                 )
              VALUES
                (VASAPPS.SE_BLZ01.NEXTVAL,
                 L_N_DISCHARGE_ID,
                 L_V_CONT_SEQ,
                 L_CUR_DETAIL_REC.FK_BOOKING_NO,
                 L_CUR_DETAIL_REC.FK_BKG_SIZE_TYPE_DTL,
                 L_CUR_DETAIL_REC.FK_BKG_SUPPLIER,
                 L_CUR_DETAIL_REC.FK_BKG_EQUIPM_DTL,
                 L_CUR_DETAIL_REC.DN_EQUIPMENT_NO,
                 L_CUR_VOYAGE_REC.VOYAGE_SEQNO,
                 L_CUR_DETAIL_REC.DN_EQ_SIZE,
                 L_CUR_DETAIL_REC.DN_EQ_TYPE,
                 L_CUR_DETAIL_REC.DN_FULL_MT,
                 L_CUR_DETAIL_REC.DN_BKG_TYP,
                 L_CUR_DETAIL_REC.DN_SOC_COC,
                 L_CUR_DETAIL_REC.DN_SHIPMENT_TERM,
                 L_CUR_DETAIL_REC.DN_SHIPMENT_TYP,
                 L_V_LOCAL_STATUS,
                 L_V_STATUS,
                 L_CUR_DETAIL_REC.LOAD_CONDITION,
                 L_V_LOAD_STATUS,
                 L_CUR_DETAIL_REC.CONTAINER_GROSS_WEIGHT,
                 L_CUR_DETAIL_REC.VOID_SLOT,
                 L_CUR_DETAIL_REC.FK_SLOT_OPERATOR,
                 L_CUR_DETAIL_REC.FK_CONTAINER_OPERATOR,
                 L_V_OUT_SLOT_OP_CODE,
                 L_CUR_DETAIL_REC.DN_SPECIAL_HNDL,
                 L_CUR_VOYAGE_REC.LOAD_PORT,
                 L_CUR_VOYAGE_REC.FROM_TERMINAL,
                 L_V_NEXT_POD1,
                 L_V_NEXT_POD2,
                 L_V_NEXT_POD3,
                 L_CUR_DETAIL_REC.DN_FINAL_POD,
                 L_CUR_DETAIL_REC.FINAL_DEST,
                 L_V_NEXT_SERVICE,
                 L_V_NEXT_VESSEL,
                 L_V_NEXT_VOYNO,
                 L_V_NEXT_DIR,
                 L_CUR_DETAIL_REC.FK_HANDLING_INSTRUCTION_1,
                 L_CUR_DETAIL_REC.FK_HANDLING_INSTRUCTION_2,
                 L_CUR_DETAIL_REC.FK_HANDLING_INSTRUCTION_3,
                 L_CUR_DETAIL_REC.CONTAINER_LOADING_REM_1,
                 L_CUR_DETAIL_REC.CONTAINER_LOADING_REM_2,
                 L_CUR_DETAIL_REC.FK_SPECIAL_CARGO,
                 L_CUR_DETAIL_REC.FK_IMDG,
                 L_CUR_DETAIL_REC.FK_UNNO,
                 L_CUR_DETAIL_REC.FK_UN_VAR,
                 L_CUR_DETAIL_REC.FK_PORT_CLASS,
                 L_CUR_DETAIL_REC.FK_PORT_CLASS_TYP,
                 L_CUR_DETAIL_REC.FLASH_UNIT,
                 L_CUR_DETAIL_REC.FLASH_POINT,
                 L_CUR_DETAIL_REC.FUMIGATION_ONLY,
                 L_CUR_DETAIL_REC.RESIDUE_ONLY_FLAG,
                 L_CUR_DETAIL_REC.OVERHEIGHT_CM,
                 L_CUR_DETAIL_REC.OVERWIDTH_LEFT_CM,
                 L_CUR_DETAIL_REC.OVERWIDTH_RIGHT_CM,
                 L_CUR_DETAIL_REC.OVERLENGTH_FRONT_CM,
                 L_CUR_DETAIL_REC.OVERLENGTH_REAR_CM,
                 L_CUR_DETAIL_REC.REEFER_TMP,
                 L_CUR_DETAIL_REC.REEFER_TMP_UNIT,
                 L_CUR_DETAIL_REC.HUMIDITY,
                 L_CUR_DETAIL_REC.DN_VENTILATION,
                 L_V_STOW_POS_ROB,
                 'A',
                 G_V_USER,
                 L_D_TIME,
                 G_V_USER,
                 L_D_TIME,
                 (CASE WHEN L_V_LOCAL_STATUS = 'L' THEN 'Local' WHEN
                  L_V_LOCAL_STATUS = 'T' THEN 'TS' ELSE NULL END));
            END IF;
          END IF;
        END IF;
      END LOOP; -- end of detail loop

      G_V_SQL_ID := 'SQL-04019';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);
      --Update Discharge List Status count
      VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(L_N_DISCHARGE_ID,
                                                             'D',
                                                             P_O_V_RETURN_STATUS);

      IF P_O_V_RETURN_STATUS = '1' THEN
        RAISE L_EXC_USER;
      END IF;

      L_N_DISCHARGE_ID := NULL;
      L_V_CHECK_LISTID := 'Y';
      L_N_CHECK        := 0;
      L_N_INSERT       := 0;
    END LOOP; -- End of header loop

    G_V_SQL_ID := 'SQL-04020';
    DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);
    L_V_NEXT_POD1       := NULL;
    L_V_NEXT_POD2       := NULL;
    L_V_NEXT_POD3       := NULL;
    P_O_V_RETURN_STATUS := '0';
    L_V_CHECK_LISTID    := 'Y';
    L_N_CHECK           := 0;
    L_N_INSERT          := 0;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SUCCESS');
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_RETURN_STATUS := '1';
      G_V_ERR_CODE        := TO_CHAR(SQLCODE);
      G_V_ERR_DESC        := SUBSTR(SQLERRM, 1, 100);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END PRR_EZDL_CREATE;

  /*-----------------------------------------------------------------------------------------------------------
  PRR_EZLL_CREATE.sql
  - Remove duplicate comtainer in Load list
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2008
  -------------------------------------------------------------------------------------------------------------
  Author Sukit Narinsakchai 17/01/2012
  - Change Log ------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------*/
  PROCEDURE PRR_EZLL_CREATE(P_I_V_BOOKING_NO IN VARCHAR2) IS
    P_I_N_VOYSEQ           NUMBER := NULL;
    P_I_N_LOADID           NUMBER := NULL;
    P_I_N_EQUIPMENT_SEQ_NO NUMBER := NULL;
    P_I_N_SIZE_TYPE_SEQ_NO NUMBER := NULL;
    P_I_N_SUPPLIER_SEQ_NO  NUMBER := NULL;
    P_O_V_RETURN_STATUS    VARCHAR2(1) := '0';
    --no need to input value
    /*
        End of input variable.
    */

    /*
        DECLARATION OF GLOBAL VARIABLE
    */
    G_V_USER             VARCHAR2(10) := 'EZLL';
    G_V_SQL_ID           VARCHAR2(15);
    G_V_ERR_CODE         VARCHAR2(50);
    G_V_ERR_DESC         VARCHAR2(100);
    G_V_ERR_HANDLER_FLG  VARCHAR2(1) := 'N';
    G_V_PROG_NAME        VARCHAR2(100) := 'PCE_ECM_SYNC_BOOKING_EZLL';
    G_V_RECORD_FILTER    VARCHAR2(1000);
    G_V_RECORD_TABLE     VARCHAR2(500);
    L_V_NEXT_SERVICE     VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_SRV%TYPE;
    L_V_NEXT_VESSEL      VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_VESSEL%TYPE;
    L_V_NEXT_VOYNO       VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_VOYAGE%TYPE;
    L_V_NEXT_DIR         VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_DIR%TYPE;
    L_N_LOAD_ID          VASAPPS.TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID%TYPE;
    L_V_IMO_CLASS        VASAPPS.TOS_LL_BOOKED_LOADING.FK_IMDG%TYPE;
    L_V_VARIANT          VASAPPS.TOS_LL_BOOKED_LOADING.FK_UN_VAR%TYPE;
    L_V_UN_NO            VASAPPS.TOS_LL_BOOKED_LOADING.FK_UNNO%TYPE;
    L_V_HZ_BS            VASAPPS.TOS_LL_BOOKED_LOADING.FLASH_UNIT%TYPE;
    L_V_NEXT_POD1        VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_POD1%TYPE;
    L_V_NEXT_POD2        VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_POD2%TYPE;
    L_V_NEXT_POD3        VASAPPS.TOS_LL_BOOKED_LOADING.DN_NXT_POD3%TYPE;
    L_V_PORTCLASS        VASAPPS.TOS_LL_BOOKED_LOADING.FK_PORT_CLASS%TYPE;
    L_V_PORTCLASSTYPE    VASAPPS.TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP%TYPE;
    L_V_OP_CODE          VASAPPS.TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE;
    L_V_SLOT_OP_CODE     VASAPPS.TOS_LL_BOOKED_LOADING.FK_SLOT_OPERATOR%TYPE;
    L_V_OUT_SLOT_OP_CODE VASAPPS.TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE;
    L_V_LOCAL_STATUS     VASAPPS.TOS_LL_BOOKED_LOADING.LOCAL_STATUS%TYPE;
    L_V_GRP_CD           VASAPPS.TOS_LL_LOAD_LIST.DN_SERVICE_GROUP_CODE%TYPE;
    L_V_USER             VARCHAR2(50) := 'SYSTEM';
    L_V_CONT_SEQ         VASAPPS.TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO%TYPE;
    L_V_ROB              VARCHAR2(5);
    L_V_ERRCD            VASAPPS.TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
    L_V_ERRMSG           VARCHAR2(200);
    L_EXC_USER EXCEPTION;
    L_V_SQL_ID          VARCHAR2(5);
    L_D_TIME            TIMESTAMP;
    L_V_VERSION         VASAPPS.TOS_LL_LOAD_LIST.FK_VERSION%TYPE;
    L_V_STATUS          VARCHAR2(5);
    L_V_LOAD_STATUS     VASAPPS.TOS_LL_LOAD_LIST.LOAD_LIST_STATUS%TYPE;
    L_V_CHECK_LISTID    VARCHAR2(1) := 'Y';
    L_N_CHECK           NUMBER := 0;
    L_N_INSERT          NUMBER := 0;
    L_V_REC_COUNT       NUMBER := 0;
    L_N_LIST_UPD_ID     NUMBER;
    L_V_STOW_POS_ROB    VASAPPS.TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION%TYPE;
    L_V_FUMIGATION_ONLY VASAPPS.TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY%TYPE;
    --Added by bindu on 31/03/2011
    L_V_RESIDUE VASAPPS.TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG%TYPE;
    --Added by bindu on 31/03/2011
    L_I_V_INVOYAGENO  VASAPPS.TOS_DL_DISCHARGE_LIST.FK_VOYAGE%TYPE;
    L_V_RECORD_STATUS VARCHAR2(1); -- added by vikas, 01.12.2011
    L_V_DN_PORT       VASAPPS.TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE;
    L_V_DN_TERMINAL   VASAPPS.TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE;
    L_V_IS_DG         VARCHAR2(1);
    -- added by vikas to identify dg booking, 30.11.2011
    L_N_DISCHARGE_LIST_STATUS VASAPPS.TOS_DL_DISCHARGE_LIST.DISCHARGE_LIST_STATUS%TYPE;
    --Added by Rajeev on 04/04/2011
    P_O_V_ERROR VARCHAR2(100);

    CURSOR L_CUR_VOYAGE IS
      SELECT SERVICE,
             VESSEL,
             VOYNO,
             DIRECTION,
             LOAD_PORT,
             DISCHARGE_PORT,
             TO_TERMINAL,
             POL_PCSQ,
             BOOKING_NO,
             VOYAGE_SEQNO,
             FROM_TERMINAL
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_I_V_BOOKING_NO
         AND ROUTING_TYPE = 'S'
         AND VOYAGE_SEQNO = NVL(P_I_N_VOYSEQ, VOYAGE_SEQNO)
         AND VESSEL IS NOT NULL
         AND VOYNO IS NOT NULL
       ORDER BY VOYAGE_SEQNO;

    CURSOR L_CUR_DETAIL IS
      SELECT T_032.EQP_SIZETYPE_SEQNO FK_BKG_SIZE_TYPE_DTL,
             T_032.POD_STAT LOCAL_STATUS,
             T_032.BUNDLE,
             T_032.OPR_VOID_SLOT VOID_SLOT,
             T_032.HANDLING_INS1 FK_HANDLING_INSTRUCTION_1,
             T_032.HANDLING_INS2 FK_HANDLING_INSTRUCTION_2,
             T_032.HANDLING_INS3 FK_HANDLING_INSTRUCTION_3,
             T_032.CLR_CODE1 CONTAINER_LOADING_REM_1,
             T_032.CLR_CODE2 CONTAINER_LOADING_REM_2,
             T_032.SPECIAL_CARGO_CODE FK_SPECIAL_CARGO,
             T_001.BOOKING_TYPE DN_BKG_TYP,
             T_001.BABKTP DN_SOC_COC,
             T_001.BAMODE DN_SHIPMENT_TERM,
             T_001.BASTP1 DN_SHIPMENT_TYP,
             T_001.BAOPCD SLOT_PARTNER_CODE,
             T_001.BADSTN FINAL_DEST,
             MLO_VESSEL EX_MLO_VESSEL,
             DECODE(T_001.BABKTP, 'C', 'RCL', L_V_OP_CODE) FK_CONTAINER_OPERATOR,
             T_009.HUMIDITY HUMIDITY,
             T_001.BAOPCD FK_SLOT_OPERATOR,
             VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.FE_DATE_TIME(MLO_ETA,
                                                            MLO_ETA_TIME) EX_MLO_VESSEL_ETA,
             T_001.BAPOD DN_FINAL_POD,
             MLO_VOYAGE EX_MLO_VOYAGE,
             BIBKNO FK_BOOKING_NO,
             BISEQN FK_BKG_EQUIPM_DTL,
             BICTRN DN_EQUIPMENT_NO,
             DECODE(BICTRN, NULL, NULL, 'B') EQUPMENT_NO_SOURCE,
             BICSZE DN_EQ_SIZE,
             BICNTP DN_EQ_TYPE,
             BIEORF DN_FULL_MT,
             (CASE
               WHEN T_009.SHIPMENT_TYPE = 'BBK' THEN
                'L'
               WHEN T_032.BUNDLE > 0 THEN
                'P'
               ELSE
                BIEORF
             END) LOAD_CONDITION,
             'BK' LOADING_STATUS,
             MET_WEIGHT CONTAINER_GROSS_WEIGHT,
             T_009.SPECIAL_HANDLING DN_SPECIAL_HNDL,
             BIXHGT OVERHEIGHT_CM,
             BIXWDL OVERWIDTH_LEFT_CM,
             BIXWDR OVERWIDTH_RIGHT_CM,
             BIXLNF OVERLENGTH_FRONT_CM,
             BIXLNB OVERLENGTH_REAR_CM,
             BIRFFM REEFER_TMP,
             BIRFBS REEFER_TMP_UNIT,
             T_009.SUPPLIER_SQNO FK_BKG_SUPPLIER,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_FUMIGATION_ONLY
               ELSE
                NULL
             END) FUMIGATION_ONLY,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_RESIDUE
               ELSE
                NULL
             END) RESIDUE_ONLY_FLAG,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_IMO_CLASS
               ELSE
                NULL
             END) FK_IMDG,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_UN_NO
               ELSE
                NULL
             END) FK_UNNO,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_VARIANT
               ELSE
                NULL
             END) FK_UN_VAR,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_PORTCLASS
               ELSE
                NULL
             END) FK_PORT_CLASS,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_PORTCLASSTYPE
               ELSE
                NULL
             END) FK_PORT_CLASS_TYP,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                L_V_HZ_BS
               ELSE
                NULL
             END) FLASH_UNIT,
             (CASE
               WHEN (T_009.SPECIAL_HANDLING = 'D1') THEN
                BIFLPT
               ELSE
                NULL
             END) FLASH_POINT,
             T_009.AIR_PRESSURE DN_VENTILATION
        FROM BKP032                  T_032,
             BKP001                  T_001,
             BKP009                  T_009,
             BOOKING_SUPPLIER_DETAIL BSD
       WHERE T_032.EQP_SIZETYPE_SEQNO = BSD.EQP_SIZETYPE_SEQNO
         AND T_032.BCBKNO = BSD.BOOKING_NO
         AND T_032.BCBKNO = T_001.BABKNO
         AND T_009.BIBKNO = T_001.BABKNO
         AND T_009.SUPPLIER_SQNO = BSD.SUPPLIER_SQNO
         AND T_001.BABKNO = P_I_V_BOOKING_NO
         AND T_009.BISEQN = NVL(P_I_N_EQUIPMENT_SEQ_NO, T_009.BISEQN)
         AND T_032.EQP_SIZETYPE_SEQNO =
             NVL(P_I_N_SIZE_TYPE_SEQ_NO, T_032.EQP_SIZETYPE_SEQNO)
         AND T_009.SUPPLIER_SQNO =
             NVL(P_I_N_SUPPLIER_SEQ_NO, T_009.SUPPLIER_SQNO);
  BEGIN
    L_D_TIME    := CURRENT_TIMESTAMP;
    L_V_STATUS  := 'BK';
    L_V_VERSION := '99';

    --Select operator code
    BEGIN
      G_V_SQL_ID := 'SQL-04001';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      SELECT NVL(MAX(CASE
                       WHEN BKP.BNCSTP = 'O' THEN
                        OPERATOR_CODE
                       ELSE
                        NULL
                     END),
                 '****') OPERATOR_CODE
        INTO L_V_OP_CODE --,l_v_slot_op_code
        FROM ITP010 ITP, BKP030 BKP
       WHERE ITP.CUCUST = BKP.BNCSCD
         AND BKP.BNCSTP IN ('O')
         AND BNBKNO = P_I_V_BOOKING_NO;
    EXCEPTION
      WHEN OTHERS THEN
        G_V_RECORD_FILTER := 'BNBKNO:' || P_I_V_BOOKING_NO;
        G_V_RECORD_TABLE  := 'Operator Code Not found in ITP010,BKP030';
    END;

    --Imo class,un no etc from dg_comm_detail
    BEGIN
      G_V_SQL_ID := 'SQL-04002';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      SELECT '1',
             IMO_CLASS,
             UN_NO,
             HZ_BS,
             NVL(UN_VARIANT, '-'),
             FUMIGATION_YN,
             RESIDUE
        INTO L_V_IS_DG,
             L_V_IMO_CLASS,
             L_V_UN_NO,
             L_V_HZ_BS,
             L_V_VARIANT,
             L_V_FUMIGATION_ONLY,
             L_V_RESIDUE
        FROM BOOKING_DG_COMM_DETAIL
       WHERE BOOKING_NO = P_I_V_BOOKING_NO
         AND IMO_CLASS = (SELECT MIN(IMO_CLASS)
                            FROM BOOKING_DG_COMM_DETAIL
                           WHERE BOOKING_NO = P_I_V_BOOKING_NO)
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        L_V_IMO_CLASS       := NULL;
        L_V_UN_NO           := NULL;
        L_V_HZ_BS           := NULL;
        L_V_VARIANT         := NULL;
        L_V_FUMIGATION_ONLY := NULL;
        L_V_RESIDUE         := NULL;
        G_V_RECORD_FILTER   := 'BOOKING_NO:' || P_I_V_BOOKING_NO;
        G_V_RECORD_TABLE    := 'IMO_CLASS Not found in BOOKING_DG_COMM_DETAIL';
    END;

    --Main cursor from routing table
    G_V_SQL_ID := 'SQL-04003';
    DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

    FOR L_CUR_VOYAGE_REC IN L_CUR_VOYAGE LOOP
      G_V_SQL_ID := 'SQL-04004';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      BEGIN
        /*
            Get next pod values
        */
        VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_GET_NEXT_POD(L_CUR_VOYAGE_REC.BOOKING_NO,
                                                           L_CUR_VOYAGE_REC.VOYAGE_SEQNO,
                                                           L_V_NEXT_POD1,
                                                           L_V_NEXT_POD2,
                                                           L_V_NEXT_POD3,
                                                           L_V_NEXT_SERVICE,
                                                           L_V_NEXT_VESSEL,
                                                           L_V_NEXT_VOYNO,
                                                           L_V_NEXT_DIR);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      --Check load list exist or not
      G_V_SQL_ID := 'SQL-04005';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      IF P_I_N_LOADID IS NULL THEN
        BEGIN
          G_V_SQL_ID := 'SQL-04006';
          DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);
          L_V_CHECK_LISTID := 'N';

          SELECT PK_LOAD_LIST_ID
            INTO L_N_LOAD_ID
            FROM VASAPPS.TOS_LL_LOAD_LIST
           WHERE FK_SERVICE = L_CUR_VOYAGE_REC.SERVICE
             AND FK_VESSEL = L_CUR_VOYAGE_REC.VESSEL
             AND FK_VOYAGE = L_CUR_VOYAGE_REC.VOYNO
             AND FK_DIRECTION = L_CUR_VOYAGE_REC.DIRECTION
             AND DN_PORT = L_CUR_VOYAGE_REC.LOAD_PORT
             AND DN_TERMINAL = L_CUR_VOYAGE_REC.FROM_TERMINAL
                -- Added by vikas, 24.11.2011 to remove duplicate booking
             AND RECORD_STATUS = 'A'
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            L_N_LOAD_ID := NULL;
        END;
      ELSE
        L_N_LOAD_ID := P_I_N_LOADID;
      END IF; -- end if of loadid

      --Port class type
      BEGIN
        G_V_SQL_ID := 'SQL-04007';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        /*    Modified by vikas if normal booking then no need to
        validate port class and port code, as k'chatgamol, 30.11.2011    */
        IF L_V_IS_DG = '1' THEN
          SELECT PORT_CLASS_TYPE
            INTO L_V_PORTCLASSTYPE
            FROM PORT_CLASS_TYPE
           WHERE PORT_CODE = L_CUR_VOYAGE_REC.LOAD_PORT;
        END IF;
        /*    End Modified vikas, 30.11.2011    */
      EXCEPTION
        WHEN OTHERS THEN
          L_V_PORTCLASS := NULL;
      END;

      --Port code
      BEGIN
        G_V_SQL_ID := 'SQL-04008';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        /*
            Modified by vikas if normal booking then no need to
            validate port class and port code, as k'chatgamol, 30.11.2011
        */
        IF L_V_IS_DG = '1' THEN
          SELECT PORT_CLASS_CODE
            INTO L_V_PORTCLASS
            FROM PORT_CLASS
           WHERE UNNO = L_V_UN_NO
             AND VARIANT = NVL(L_V_VARIANT, '-')
                -- Change by vikas, varint can not null, 18.11.2011
             AND IMDG_CLASS = L_V_IMO_CLASS
             AND PORT_CLASS_TYPE = L_V_PORTCLASSTYPE;
        END IF;
        /*
            End Modified vikas, 30.11.2011
        */
      EXCEPTION
        WHEN OTHERS THEN
          L_V_PORTCLASS := NULL;
      END;

      --Service group code
      BEGIN
        G_V_SQL_ID := 'SQL-04009';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        SELECT SERVICE_GROUP_CODE
          INTO L_V_GRP_CD
          FROM ITP085
         WHERE SWSRVC = L_CUR_VOYAGE_REC.SERVICE;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      --If load list not exists then make and insert in load list table
      IF L_N_LOAD_ID IS NULL THEN
        G_V_SQL_ID := 'SQL-04010';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        SELECT VASAPPS.SE_DLZ01.NEXTVAL INTO L_N_LOAD_ID FROM DUAL;

        INSERT INTO VASAPPS.TOS_LL_LOAD_LIST
          (PK_LOAD_LIST_ID,
           DN_SERVICE_GROUP_CODE,
           FK_SERVICE,
           FK_VESSEL,
           FK_VOYAGE,
           FK_DIRECTION,
           FK_PORT_SEQUENCE_NO,
           FK_VERSION,
           DN_PORT,
           DN_TERMINAL,
           LOAD_LIST_STATUS,
           DA_BOOKED_TOT,
           DA_LOADED_TOT,
           DA_ROB_TOT,
           DA_OVERSHIPPED_TOT,
           DA_SHORTSHIPPED_TOT,
           RECORD_STATUS,
           RECORD_ADD_USER,
           RECORD_ADD_DATE,
           RECORD_CHANGE_USER,
           RECORD_CHANGE_DATE)
        VALUES
          (L_N_LOAD_ID,
           L_V_GRP_CD,
           L_CUR_VOYAGE_REC.SERVICE,
           L_CUR_VOYAGE_REC.VESSEL,
           L_CUR_VOYAGE_REC.VOYNO,
           L_CUR_VOYAGE_REC.DIRECTION,
           L_CUR_VOYAGE_REC.POL_PCSQ,
           L_V_VERSION,
           L_CUR_VOYAGE_REC.LOAD_PORT,
           L_CUR_VOYAGE_REC.FROM_TERMINAL,
           '0',
           0,
           0,
           0,
           0,
           0,
           'A',
           G_V_USER,
           L_D_TIME,
           G_V_USER,
           L_D_TIME);
      END IF;

      G_V_SQL_ID := 'SQL-04011';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

      --Deatail cursor from BKP009,BKP032,BKP001
      FOR L_CUR_DETAIL_REC IN L_CUR_DETAIL LOOP
        BEGIN
          G_V_SQL_ID := 'SQL-04012';
          DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

          SELECT 'RB', STOWAGE_POSITION
            INTO L_V_ROB, L_V_STOW_POS_ROB
            FROM VASAPPS.BKG_ROB_CONTAINER
           WHERE FK_DEPARTURE_BOOKING_NUMBER = L_CUR_VOYAGE_REC.BOOKING_NO
             AND CONTAINER_NUMBER = L_CUR_DETAIL_REC.DN_EQUIPMENT_NO;
        EXCEPTION
          WHEN OTHERS THEN
            L_V_STOW_POS_ROB  := NULL;
            L_V_ROB           := NVL(L_V_ROB, 'BK');
            G_V_RECORD_FILTER := 'FK_DEPARTURE_BOOKING_NUMBER:' ||
                                 L_CUR_VOYAGE_REC.BOOKING_NO ||
                                 ' CONTAINER_NUMBER:' ||
                                 L_CUR_DETAIL_REC.DN_EQUIPMENT_NO;
            G_V_RECORD_TABLE  := 'Error occured.Contact System administrator';
        END;

        IF L_CUR_VOYAGE_REC.VOYAGE_SEQNO = 1 THEN
          L_V_LOCAL_STATUS := L_CUR_DETAIL_REC.LOCAL_STATUS;
        ELSE
          L_V_LOCAL_STATUS := 'T';
        END IF;

        G_V_SQL_ID := 'SQL-04013';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        --Get Slot Operator
        IF L_V_LOCAL_STATUS = 'T' THEN
          L_V_OUT_SLOT_OP_CODE := 'RCL';
        ELSIF L_CUR_DETAIL_REC.DN_SOC_COC = 'S' THEN
          IF L_CUR_DETAIL_REC.DN_BKG_TYP IN ('N', 'ER') THEN
            L_V_OUT_SLOT_OP_CODE := L_V_OP_CODE;
          ELSE
            L_V_OUT_SLOT_OP_CODE := L_CUR_DETAIL_REC.SLOT_PARTNER_CODE;
          END IF;
        END IF;

        L_N_INSERT := 0;
        G_V_SQL_ID := 'SQL-04015';
        DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

        IF L_CUR_DETAIL_REC.DN_EQUIPMENT_NO IS NOT NULL THEN
          BEGIN
            G_V_SQL_ID := 'SQL-04016';
            DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

            /*    Start Added by vikas 26.11.2011    */
            SELECT 1, PK_BOOKED_LOADING_ID, RECORD_STATUS
              INTO L_N_CHECK, L_N_LIST_UPD_ID, L_V_RECORD_STATUS
              FROM VASAPPS.TOS_LL_BOOKED_LOADING
             WHERE DN_EQUIPMENT_NO = L_CUR_DETAIL_REC.DN_EQUIPMENT_NO
               AND (RECORD_STATUS = 'S' OR FK_LOAD_LIST_ID = L_N_LOAD_ID)
               AND ROWNUM = 1;

            IF (L_V_RECORD_STATUS = 'S') THEN
              G_V_SQL_ID := 'SQL-04014';
              DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

              SELECT NVL(MAX(CONTAINER_SEQ_NO), 0)
                INTO L_V_CONT_SEQ
                FROM VASAPPS.TOS_LL_BOOKED_LOADING
               WHERE FK_LOAD_LIST_ID = L_N_LOAD_ID;

              L_V_CONT_SEQ := L_V_CONT_SEQ + 1;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              L_N_CHECK         := 0;
              G_V_RECORD_FILTER := 'DN_EQUIPMENT_NO:' ||
                                   L_CUR_DETAIL_REC.DN_EQUIPMENT_NO ||
                                   ' RECORD_STATUS =A';
              G_V_RECORD_TABLE  := 'Booking load ID Not found in TOS_LL_BOOKED_LOADING';
          END;

          IF L_N_CHECK = 1 THEN
            G_V_SQL_ID := 'SQL-04017';
            DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

            UPDATE VASAPPS.TOS_LL_BOOKED_LOADING
               SET RECORD_STATUS             = 'A',
                   FK_LOAD_LIST_ID           = L_N_LOAD_ID,
                   CONTAINER_SEQ_NO          = CASE WHEN(L_V_RECORD_STATUS = 'S') THEN L_V_CONT_SEQ ELSE CONTAINER_SEQ_NO END,
                   FK_BOOKING_NO             = L_CUR_DETAIL_REC.FK_BOOKING_NO,
                   FK_BKG_SIZE_TYPE_DTL      = L_CUR_DETAIL_REC.FK_BKG_SIZE_TYPE_DTL,
                   FK_BKG_SUPPLIER           = L_CUR_DETAIL_REC.FK_BKG_SUPPLIER,
                   FK_BKG_EQUIPM_DTL         = L_CUR_DETAIL_REC.FK_BKG_EQUIPM_DTL,
                   EQUPMENT_NO_SOURCE        = L_CUR_DETAIL_REC.EQUPMENT_NO_SOURCE,
                   FK_BKG_VOYAGE_ROUTING_DTL = L_CUR_VOYAGE_REC.VOYAGE_SEQNO,
                   DN_EQ_SIZE                = L_CUR_DETAIL_REC.DN_EQ_SIZE,
                   DN_EQ_TYPE                = L_CUR_DETAIL_REC.DN_EQ_TYPE,
                   DN_FULL_MT                = L_CUR_DETAIL_REC.DN_FULL_MT,
                   DN_BKG_TYP                = L_CUR_DETAIL_REC.DN_BKG_TYP,
                   DN_SOC_COC                = L_CUR_DETAIL_REC.DN_SOC_COC,
                   DN_SHIPMENT_TERM          = L_CUR_DETAIL_REC.DN_SHIPMENT_TERM,
                   DN_SHIPMENT_TYP           = L_CUR_DETAIL_REC.DN_SHIPMENT_TYP,
                   LOCAL_STATUS              = L_V_LOCAL_STATUS,
                   VOID_SLOT                 = L_CUR_DETAIL_REC.VOID_SLOT,
                   FK_SLOT_OPERATOR          = L_CUR_DETAIL_REC.FK_SLOT_OPERATOR,
                   DN_SPECIAL_HNDL           = L_CUR_DETAIL_REC.DN_SPECIAL_HNDL,
                   DN_DISCHARGE_PORT         = L_CUR_VOYAGE_REC.DISCHARGE_PORT,
                   DN_DISCHARGE_TERMINAL     = L_CUR_VOYAGE_REC.TO_TERMINAL,
                   DN_NXT_POD1               = L_V_NEXT_POD1,
                   DN_NXT_POD2               = L_V_NEXT_POD2,
                   DN_NXT_POD3               = L_V_NEXT_POD3,
                   DN_FINAL_POD              = L_CUR_DETAIL_REC.DN_FINAL_POD,
                   FINAL_DEST                = L_CUR_DETAIL_REC.FINAL_DEST,
                   DN_NXT_SRV                = L_V_NEXT_SERVICE,
                   DN_NXT_VESSEL             = L_V_NEXT_VESSEL,
                   DN_NXT_VOYAGE             = L_V_NEXT_VOYNO,
                   DN_NXT_DIR                = L_V_NEXT_DIR,
                   EX_MLO_VESSEL             = L_CUR_DETAIL_REC.EX_MLO_VESSEL,
                   EX_MLO_VESSEL_ETA         = L_CUR_DETAIL_REC.EX_MLO_VESSEL_ETA,
                   EX_MLO_VOYAGE             = L_CUR_DETAIL_REC.EX_MLO_VOYAGE,
                   RECORD_CHANGE_USER        = G_V_USER,
                   RECORD_CHANGE_DATE        = L_D_TIME
             WHERE DN_EQUIPMENT_NO = L_CUR_DETAIL_REC.DN_EQUIPMENT_NO
               AND (RECORD_STATUS = 'S' OR FK_LOAD_LIST_ID = L_N_LOAD_ID)
               AND PK_BOOKED_LOADING_ID = L_N_LIST_UPD_ID;

            L_N_INSERT := 1;
          END IF;

          IF L_N_INSERT = 0 THEN
            G_V_SQL_ID := 'SQL-0401A';
            DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

            SELECT NVL(MAX(CONTAINER_SEQ_NO), 0)
              INTO L_V_CONT_SEQ
              FROM VASAPPS.TOS_LL_BOOKED_LOADING
             WHERE FK_LOAD_LIST_ID = L_N_LOAD_ID;

            L_V_CONT_SEQ := L_V_CONT_SEQ + 1;
            G_V_SQL_ID   := 'SQL-0408';
            DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);

            IF (L_CUR_DETAIL_REC.DN_EQUIPMENT_NO IS NOT NULL) THEN
              INSERT INTO VASAPPS.TOS_LL_BOOKED_LOADING
                (PK_BOOKED_LOADING_ID,
                 FK_LOAD_LIST_ID,
                 CONTAINER_SEQ_NO,
                 FK_BOOKING_NO,
                 FK_BKG_SIZE_TYPE_DTL,
                 FK_BKG_SUPPLIER,
                 FK_BKG_EQUIPM_DTL,
                 DN_EQUIPMENT_NO,
                 EQUPMENT_NO_SOURCE,
                 FK_BKG_VOYAGE_ROUTING_DTL,
                 DN_EQ_SIZE,
                 DN_EQ_TYPE,
                 DN_FULL_MT,
                 DN_BKG_TYP,
                 DN_SOC_COC,
                 DN_SHIPMENT_TERM,
                 DN_SHIPMENT_TYP,
                 LOCAL_STATUS,
                 LOADING_STATUS,
                 LOAD_CONDITION,
                 CONTAINER_GROSS_WEIGHT,
                 VOID_SLOT,
                 FK_SLOT_OPERATOR,
                 FK_CONTAINER_OPERATOR,
                 OUT_SLOT_OPERATOR,
                 DN_SPECIAL_HNDL,
                 DN_DISCHARGE_PORT,
                 DN_DISCHARGE_TERMINAL,
                 DN_NXT_POD1,
                 DN_NXT_POD2,
                 DN_NXT_POD3,
                 DN_FINAL_POD,
                 FINAL_DEST,
                 DN_NXT_SRV,
                 DN_NXT_VESSEL,
                 DN_NXT_VOYAGE,
                 DN_NXT_DIR,
                 EX_MLO_VESSEL,
                 EX_MLO_VESSEL_ETA,
                 EX_MLO_VOYAGE,
                 FK_HANDLING_INSTRUCTION_1,
                 FK_HANDLING_INSTRUCTION_2,
                 FK_HANDLING_INSTRUCTION_3,
                 CONTAINER_LOADING_REM_1,
                 CONTAINER_LOADING_REM_2,
                 FK_SPECIAL_CARGO,
                 FK_IMDG,
                 FK_UNNO,
                 FK_UN_VAR,
                 FK_PORT_CLASS,
                 FK_PORT_CLASS_TYP,
                 FLASH_UNIT,
                 FLASH_POINT,
                 FUMIGATION_ONLY,
                 RESIDUE_ONLY_FLAG,
                 OVERHEIGHT_CM,
                 OVERWIDTH_LEFT_CM,
                 OVERWIDTH_RIGHT_CM,
                 OVERLENGTH_FRONT_CM,
                 OVERLENGTH_REAR_CM,
                 REEFER_TMP,
                 REEFER_TMP_UNIT,
                 DN_HUMIDITY,
                 DN_VENTILATION,
                 STOWAGE_POSITION,
                 RECORD_STATUS,
                 RECORD_ADD_USER,
                 RECORD_ADD_DATE,
                 RECORD_CHANGE_USER,
                 RECORD_CHANGE_DATE,
                 LOCAL_TERMINAL_STATUS --ADDED ON 29/04/2011.
                 )
              VALUES
                (VASAPPS.SE_BLZ01.NEXTVAL,
                 L_N_LOAD_ID,
                 L_V_CONT_SEQ,
                 L_CUR_DETAIL_REC.FK_BOOKING_NO,
                 L_CUR_DETAIL_REC.FK_BKG_SIZE_TYPE_DTL,
                 L_CUR_DETAIL_REC.FK_BKG_SUPPLIER,
                 L_CUR_DETAIL_REC.FK_BKG_EQUIPM_DTL,
                 L_CUR_DETAIL_REC.DN_EQUIPMENT_NO,
                 L_CUR_DETAIL_REC.EQUPMENT_NO_SOURCE,
                 L_CUR_VOYAGE_REC.VOYAGE_SEQNO,
                 L_CUR_DETAIL_REC.DN_EQ_SIZE,
                 L_CUR_DETAIL_REC.DN_EQ_TYPE,
                 L_CUR_DETAIL_REC.DN_FULL_MT,
                 L_CUR_DETAIL_REC.DN_BKG_TYP,
                 L_CUR_DETAIL_REC.DN_SOC_COC,
                 L_CUR_DETAIL_REC.DN_SHIPMENT_TERM,
                 L_CUR_DETAIL_REC.DN_SHIPMENT_TYP,
                 L_V_LOCAL_STATUS,
                 L_V_ROB,
                 L_CUR_DETAIL_REC.LOAD_CONDITION,
                 L_CUR_DETAIL_REC.CONTAINER_GROSS_WEIGHT,
                 L_CUR_DETAIL_REC.VOID_SLOT,
                 L_CUR_DETAIL_REC.FK_SLOT_OPERATOR,
                 L_CUR_DETAIL_REC.FK_CONTAINER_OPERATOR,
                 L_V_OUT_SLOT_OP_CODE,
                 L_CUR_DETAIL_REC.DN_SPECIAL_HNDL,
                 L_CUR_VOYAGE_REC.DISCHARGE_PORT,
                 L_CUR_VOYAGE_REC.TO_TERMINAL,
                 L_V_NEXT_POD1,
                 L_V_NEXT_POD2,
                 L_V_NEXT_POD3,
                 L_CUR_DETAIL_REC.DN_FINAL_POD,
                 L_CUR_DETAIL_REC.FINAL_DEST,
                 L_V_NEXT_SERVICE,
                 L_V_NEXT_VESSEL,
                 L_V_NEXT_VOYNO,
                 L_V_NEXT_DIR,
                 L_CUR_DETAIL_REC.EX_MLO_VESSEL,
                 L_CUR_DETAIL_REC.EX_MLO_VESSEL_ETA,
                 L_CUR_DETAIL_REC.EX_MLO_VOYAGE,
                 L_CUR_DETAIL_REC.FK_HANDLING_INSTRUCTION_1,
                 L_CUR_DETAIL_REC.FK_HANDLING_INSTRUCTION_2,
                 L_CUR_DETAIL_REC.FK_HANDLING_INSTRUCTION_3,
                 L_CUR_DETAIL_REC.CONTAINER_LOADING_REM_1,
                 L_CUR_DETAIL_REC.CONTAINER_LOADING_REM_2,
                 L_CUR_DETAIL_REC.FK_SPECIAL_CARGO,
                 L_CUR_DETAIL_REC.FK_IMDG,
                 L_CUR_DETAIL_REC.FK_UNNO,
                 L_CUR_DETAIL_REC.FK_UN_VAR,
                 L_CUR_DETAIL_REC.FK_PORT_CLASS,
                 L_CUR_DETAIL_REC.FK_PORT_CLASS_TYP,
                 L_CUR_DETAIL_REC.FLASH_UNIT,
                 L_CUR_DETAIL_REC.FLASH_POINT,
                 L_CUR_DETAIL_REC.FUMIGATION_ONLY,
                 L_CUR_DETAIL_REC.RESIDUE_ONLY_FLAG,
                 L_CUR_DETAIL_REC.OVERHEIGHT_CM,
                 L_CUR_DETAIL_REC.OVERWIDTH_LEFT_CM,
                 L_CUR_DETAIL_REC.OVERWIDTH_RIGHT_CM,
                 L_CUR_DETAIL_REC.OVERLENGTH_FRONT_CM,
                 L_CUR_DETAIL_REC.OVERLENGTH_REAR_CM,
                 L_CUR_DETAIL_REC.REEFER_TMP,
                 L_CUR_DETAIL_REC.REEFER_TMP_UNIT,
                 L_CUR_DETAIL_REC.HUMIDITY,
                 L_CUR_DETAIL_REC.DN_VENTILATION,
                 L_V_STOW_POS_ROB,
                 'A',
                 G_V_USER,
                 L_D_TIME,
                 G_V_USER,
                 L_D_TIME,
                 (CASE WHEN L_V_LOCAL_STATUS = 'L' THEN 'Local' WHEN
                  L_V_LOCAL_STATUS = 'T' THEN 'TS' ELSE NULL END));
            END IF;
          END IF;
        END IF;
      END LOOP; -- end of detail loop

      G_V_SQL_ID := 'SQL-04019';
      DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);
      --Update load List Status count
      VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(L_N_LOAD_ID,
                                                             'L',
                                                             P_O_V_RETURN_STATUS);

      IF P_O_V_RETURN_STATUS = '1' THEN
        RAISE L_EXC_USER;
      END IF;

      L_N_LOAD_ID      := NULL;
      L_V_CHECK_LISTID := 'Y';
      L_N_CHECK        := 0;
      L_N_INSERT       := 0;
    END LOOP; -- End of header loop

    G_V_SQL_ID := 'SQL-04020';
    DBMS_OUTPUT.PUT_LINE('g_v_sql_id: ' || G_V_SQL_ID);
    L_V_NEXT_POD1       := NULL;
    L_V_NEXT_POD2       := NULL;
    L_V_NEXT_POD3       := NULL;
    P_O_V_RETURN_STATUS := '0';
    L_V_CHECK_LISTID    := 'Y';
    L_N_CHECK           := 0;
    L_N_INSERT          := 0;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SUCCESS');
  EXCEPTION
    WHEN OTHERS THEN
      P_O_V_RETURN_STATUS := '1';
      G_V_ERR_CODE        := TO_CHAR(SQLCODE);
      G_V_ERR_DESC        := SUBSTR(SQLERRM, 1, 100);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END PRR_EZLL_CREATE;

  /*-----------------------------------------------------------------------------------------------------------
  FR_get_booking_routing_data.sql
  - get data of booking_voyage_routing_dtl
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2008
  -------------------------------------------------------------------------------------------------------------
  Author Sukit Narinsakchai 06/02/2012
  - Change Log ------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------*/
  FUNCTION FR_GET_BOOKING_ROUTING_DATA(P_BOOKING_NO    IN VARCHAR2,
                                       P_VOYAGE_SEQ_NO IN NUMBER,
                                       P_TYPE          IN VARCHAR2)
    RETURN VARCHAR2 AS
    V_SERVICE     ITP063.VVSRVC%TYPE;
    V_VESSEL      ITP063.VVVESS%TYPE;
    V_VOYAGE      ITP063.VVVOYN%TYPE;
    V_SERVICE_DIR ITP063.VVSDIR%TYPE;
    V_PORT_DIR    ITP063.VVPDIR%TYPE;
    V_PCSQ        ITP063.VVPCSQ%TYPE;
    V_PORT        ITP063.VVPCAL%TYPE;
    V_TERMINAL    ITP063.VVTRM1%TYPE;
    V_DATE        ITP063.VVARDT%TYPE;
    V_TIME        ITP063.VVARTM%TYPE;
  BEGIN
    IF (P_TYPE = 'SERVICE') THEN
      SELECT SERVICE
        INTO V_SERVICE
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN V_SERVICE;
    ELSIF (P_TYPE = 'VESSEL') THEN
      SELECT VESSEL
        INTO V_VESSEL
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN V_VESSEL;
    ELSIF (P_TYPE = 'VOYAGE') THEN
      SELECT VOYNO
        INTO V_VOYAGE
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN V_VOYAGE;
    ELSIF (P_TYPE = 'PDIR') THEN
      SELECT DIRECTION
        INTO V_PORT_DIR
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN V_PORT_DIR;
    ELSIF (P_TYPE = 'POL_PORT_SEQ') THEN
      SELECT POL_PCSQ
        INTO V_PCSQ
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN TO_CHAR(V_PCSQ);
    ELSIF (P_TYPE = 'LOAD_PORT') THEN
      SELECT LOAD_PORT
        INTO V_PORT
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN V_PORT;
    ELSIF (P_TYPE = 'FROM_TERMINAL') THEN
      SELECT FROM_TERMINAL
        INTO V_TERMINAL
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN V_TERMINAL;
    ELSIF (P_TYPE = 'POD_PORT_SEQ') THEN
      SELECT POD_PCSQ
        INTO V_PCSQ
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN TO_CHAR(V_PCSQ);
    ELSIF (P_TYPE = 'DISCHARGE_PORT') THEN
      SELECT DISCHARGE_PORT
        INTO V_PORT
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN V_PORT;
    ELSIF (P_TYPE = 'TO_TERMINAL') THEN
      SELECT TO_TERMINAL
        INTO V_TERMINAL
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN V_TERMINAL;
    ELSIF (P_TYPE = 'POL_ARRIVAL_DATE') THEN
      SELECT POL_ARRIVAL_DATE
        INTO V_DATE
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN TO_CHAR(V_DATE);
    ELSIF (P_TYPE = 'POL_ARRIVAL_TIME') THEN
      SELECT POL_ARRIVAL_TIME
        INTO V_TIME
        FROM BOOKING_VOYAGE_ROUTING_DTL
       WHERE BOOKING_NO = P_BOOKING_NO
         AND VOYAGE_SEQNO = P_VOYAGE_SEQ_NO;

      RETURN TO_CHAR(V_TIME);
    END IF;

    RETURN ' ';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN '';
    WHEN OTHERS THEN
      RETURN '';
  END FR_GET_BOOKING_ROUTING_DATA;

  /*-----------------------------------------------------------------------------------------------------------
  prr_ezdl_update_all
  - Update EZDL in case cell location missing
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2008
  -------------------------------------------------------------------------------------------------------------
  Author Wutiporn Kittitammarak 08/02/2012
  - Change Log
    10/02/2012 Add query get duplicate stowage positions to process re-trigger
    21/02/2012 Updated query get record containing missing cell location and change solution to update directly on EZDL
  ------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------*/
  /* Formatted on 2012/02/21 09:51 (Formatter Plus v4.8.7) */
  PROCEDURE PRR_EZDL_UPDATE_ALL IS
    CURSOR C1 IS
      SELECT DISTINCT DLBKG.PK_BOOKED_DISCHARGE_ID,
                      DLBKG.FK_DISCHARGE_LIST_ID,
                      OB.STOW_POSITION,
                      OB.WEIGHT
        FROM VASAPPS.TOS_DL_DISCHARGE_LIST   DL,
             VASAPPS.TOS_DL_BOOKED_DISCHARGE DLBKG,
             TOS_ONBOARD_LIST                OB
       WHERE DL.PK_DISCHARGE_LIST_ID = DLBKG.FK_DISCHARGE_LIST_ID
         AND DLBKG.RECORD_CHANGE_DATE >= (SYSDATE - 30)
         AND DLBKG.RECORD_STATUS = 'A'
         AND DLBKG.DISCHARGE_STATUS IN ('BK', 'DI')
         AND DLBKG.STOWAGE_POSITION IS NULL
         AND DL.DN_PORT = OB.POD
         AND DL.DN_TERMINAL = OB.POD_TERMINAL
         AND DLBKG.DN_POL = OB.POL
         AND DLBKG.DN_POL_TERMINAL = OB.POL_TERMINAL
         AND DLBKG.FK_BOOKING_NO = OB.BOOKING_NO
         AND DLBKG.DN_EQUIPMENT_NO = OB.CONTAINER_NO
         AND OB.STOW_POSITION IS NOT NULL
         AND OB.LIST_STATUS = 'C';
  BEGIN
    BEGIN
      FOR DLREC IN C1 LOOP
        UPDATE VASAPPS.TOS_DL_BOOKED_DISCHARGE
           SET DISCHARGE_STATUS       = 'DI',
               STOWAGE_POSITION       = DLREC.STOW_POSITION,
               CONTAINER_GROSS_WEIGHT = DLREC.WEIGHT
         WHERE PK_BOOKED_DISCHARGE_ID = DLREC.PK_BOOKED_DISCHARGE_ID
           AND FK_DISCHARGE_LIST_ID = DLREC.FK_DISCHARGE_LIST_ID;

        COMMIT;
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Some Error: ' || SQLCODE || ' - ' || SQLERRM);
    END;
  END PRR_EZDL_UPDATE_ALL;

  /*-----------------------------------------------------------------------------------------------------------
  PRR_EZL_AUTO_INSERT_CUTOVER.sql
  - Auto Sync schedule from itp063 to cutover table
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2008
  -------------------------------------------------------------------------------------------------------------
  Author Sukit Narinsakchai 13/02/2012
  - Change Log ------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------*/
  PROCEDURE PRR_EZL_AUTO_INSERT_CUTOVER IS

  BEGIN

    INSERT INTO VASAPPS.TOS_LL_DL_CUTOVER
      (LOAD_DISCH_INDICATOR,
       SINGLE_VOYAGE_INDICATOR,
       PORT,
       TERMINAL,
       SERVICE,
       VESSEL,
       VOYAGE,
       DIRECTION,
       RECORD_STATUS,
       RECORD_ADD_USER,
       RECORD_ADD_DATE,
       RECORD_CHANGE_USER,
       RECORD_CHANGE_DATE,
       PORT_SEQ,
       INVOYAGE_NO)
      SELECT 'L',
             1,
             VSS_REC.VVPCAL,
             VSS_REC.VVTRM1,
             VSS_REC.VVSRVC,
             VSS_REC.VVVESS,
             VSS_REC.VVVOYN,
             VSS_REC.VVPDIR,
             'A',
             'JOB_SCHDL',
             SYSDATE,
             'JOB_SCHDL',
             SYSDATE,
             VSS_REC.VVPCSQ,
             NVL(VSS_REC.INVOYAGENO, VSS_REC.VVVOYN)
        FROM ITP063 VSS_REC, VASAPPS.VCM_CONFIG_MST
       WHERE VVVERS = 99
         AND OMMISSION_FLAG IS NULL
         AND VVFORL IN ('F', 'O')
         AND CONFIG_TYP = 'CUTOVER_INS'
         AND VVPCAL = CONFIG_CD
         AND VVARDT >= TO_NUMBER(CONFIG_VALUE)
         AND NOT EXISTS (SELECT *
                FROM VASAPPS.TOS_LL_DL_CUTOVER
               WHERE SERVICE = VVSRVC
                 AND VESSEL = VVVESS
                 AND VOYAGE = VVVOYN
                 AND PORT_SEQ = VVPCSQ
                 AND PORT = VVPCAL
                 AND TERMINAL = VVTRM1
                 AND LOAD_DISCH_INDICATOR = 'L');

    INSERT INTO VASAPPS.TOS_LL_DL_CUTOVER
      (LOAD_DISCH_INDICATOR,
       SINGLE_VOYAGE_INDICATOR,
       PORT,
       TERMINAL,
       SERVICE,
       VESSEL,
       VOYAGE,
       DIRECTION,
       RECORD_STATUS,
       RECORD_ADD_USER,
       RECORD_ADD_DATE,
       RECORD_CHANGE_USER,
       RECORD_CHANGE_DATE,
       PORT_SEQ,
       INVOYAGE_NO)
      SELECT 'D',
             1,
             VSS_REC.VVPCAL,
             VSS_REC.VVTRM1,
             VSS_REC.VVSRVC,
             VSS_REC.VVVESS,
             VSS_REC.VVVOYN,
             VSS_REC.VVPDIR,
             'A',
             'JOB_SCHDL',
             SYSDATE,
             'JOB_SCHDL',
             SYSDATE,
             VSS_REC.VVPCSQ,
             NVL(VSS_REC.INVOYAGENO, VSS_REC.VVVOYN)
        FROM ITP063 VSS_REC, VASAPPS.VCM_CONFIG_MST
       WHERE VVVERS = 99
         AND OMMISSION_FLAG IS NULL
         AND VVFORL IN ('L', 'O')
         AND CONFIG_TYP = 'CUTOVER_INS'
         AND VVPCAL = CONFIG_CD
         AND VVARDT >= TO_NUMBER(CONFIG_VALUE)
         AND NOT EXISTS (SELECT *
                FROM VASAPPS.TOS_LL_DL_CUTOVER
               WHERE SERVICE = VVSRVC
                 AND VESSEL = VVVESS
                 AND VOYAGE = VVVOYN
                 AND PORT_SEQ = VVPCSQ
                 AND PORT = VVPCAL
                 AND TERMINAL = VVTRM1
                 AND LOAD_DISCH_INDICATOR = 'D');
    --DBMS_OUTPUT.PUT_LINE(vss_rec.vvpcal||'-'||vss_rec.vvtrm1||'-'||vss_rec.vvsrvc||'-'||vss_rec.vvvess||'-'||vss_rec.vvvoyn||'-'||vss_rec.vvpdir||'-'||'A'||'-'|| 'JOB_SCHDL'||'-'||sysdate||'-'||'JOB_SCHDL'||'-'||'JOB_SCHDL'||'-'||vss_rec.vvpcsq||'-'||nvl(vss_rec.invoyageno,vss_rec.vvvoyn)||'-'||SQL%ROWCOUNT);
    COMMIT;
  END PRR_EZL_AUTO_INSERT_CUTOVER;

/*-----------------------------------------------------------------------------------------------------------
PRR_VSS_AUTO_UPD_INVOYNO_DFS.sql
- Auto update invoyageno  for DFS service in table ITP063
-------------------------------------------------------------------------------------------------------------
Copyright RCL Public Co., Ltd. 2008
-------------------------------------------------------------------------------------------------------------
Author Sukit Narinsakchai 27/02/2012
- Change Log ------------------------------------------------------------------------------------------------
-- #1      NATTAK1     07/10/2015    Raise ticket to PROD due of from PRD it missed to update invoy on AFS .
-- #2      NATTAK1     14/06/2016    Add condition to update Invoyageno once Arrival/Departure was complted.
-------------------------------------------------------------------------------------------------------------*/
PROCEDURE PRR_VSS_AUTO_UPD_INVOYNO_DFS IS

BEGIN

	  --UPDATE ITP063 set invoyageno = vvvoyn where vvsrvc = 'DFS' and invoyageno is null and ommission_flag is null;
         UPDATE ITP063 set invoyageno = vvvoyn where vvsrvc in ( 'DFS','AFS' ) and invoyageno is null and ommission_flag is null
         and vvvers= 99 and  NVL(TOS_PROFORMA_STATUS,' ') <> 'Y'    --  #2
          ;
		  --DBMS_OUTPUT.PUT_LINE(vss_rec.vvpcal||'-'||vss_rec.vvtrm1||'-'||vss_rec.vvsrvc||'-'||vss_rec.vvvess||'-'||vss_rec.vvvoyn||'-'||vss_rec.vvpdir||'-'||'A'||'-'|| 'JOB_SCHDL'||'-'||sysdate||'-'||'JOB_SCHDL'||'-'||'JOB_SCHDL'||'-'||vss_rec.vvpcsq||'-'||nvl(vss_rec.invoyageno,vss_rec.vvvoyn)||'-'||SQL%ROWCOUNT);
	 COMMIT;
END PRR_VSS_AUTO_UPD_INVOYNO_DFS;

/*-----------------------------------------------------------------------------------------------------------
PRR_DL_UPD_MISSING_EQ.sql
- TO AUTO UPDATE MISSING EUIPMENT NO IN EZDL 
-------------------------------------------------------------------------------------------------------------
Copyright RCL Public Co., Ltd. 2008
-------------------------------------------------------------------------------------------------------------
Author Watcharee Choknakawaro 14/03/2018
- Change Log ------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------*/


PROCEDURE PRR_DL_UPD_MISSING_EQ IS 


V_RETURN_STATUS			    VARCHAR2(50);
V_EXEC_FLAG             VARCHAR2(1);
L_N_FOUND               NUMBER:=0;     
L_V_PARAMETER_STR     VARCHAR2(500);
VRUNNINGDATETIME VARCHAR2(30) := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');

BEGIN
    FOR CUR_MISSING_DL IN (
    SELECT L.*,D.FK_DISCHARGE_LIST_ID,D.PK_BOOKED_DISCHARGE_ID,D.DN_EQUIPMENT_NO AS DL_EQUIPMENT_NO,D.DISCHARGE_STATUS 
    FROM TOS_LL_BOOKED_LOADING L LEFT OUTER JOIN TOS_DL_BOOKED_DISCHARGE D
    ON (L.FK_BOOKING_NO = D.FK_BOOKING_NO
    AND L.FK_BKG_SIZE_TYPE_DTL = D.FK_BKG_SIZE_TYPE_DTL 
    AND L.FK_BKG_SUPPLIER = D.FK_BKG_SUPPLIER
    AND L.FK_BKG_EQUIPM_DTL = D.FK_BKG_EQUIPM_DTL
    AND L.FK_BKG_VOYAGE_ROUTING_DTL = D.FK_BKG_VOYAGE_ROUTING_DTL
    --AND NVL(L.DN_EQUIPMENT_NO,'-')= NVL(D.DN_EQUIPMENT_NO,'-')
    AND D.RECORD_STATUS='A'
    
    )
    WHERE L.RECORD_STATUS= 'A'
    --AND L.FK_BOOKING_NO='BLCHC11010211'
    AND D.DN_EQUIPMENT_NO IS NULL 
    AND L.DN_EQUIPMENT_NO IS NOT NULL 
    AND D.DISCHARGE_STATUS ='BK'
    AND TRUNC(L.RECORD_ADD_DATE) >= '01-MAR-2018'
    ORDER BY L.RECORD_ADD_DATE DESC 
    
    )
    LOOP

          
       SELECT COUNT(1)  INTO L_N_FOUND FROM TOS_DL_DISCHARGE_LIST WHERE DN_PORT='HKHKG' AND PK_DISCHARGE_LIST_ID =CUR_MISSING_DL.FK_DISCHARGE_LIST_ID; 

       L_V_PARAMETER_STR := CUR_MISSING_DL.FK_BOOKING_NO       ||'~'||
                            CUR_MISSING_DL.FK_BKG_EQUIPM_DTL ||'~'||
                            CUR_MISSING_DL.DL_EQUIPMENT_NO ||'~'|| -- old DL EQ 
                            CUR_MISSING_DL.DN_EQUIPMENT_NO ||'~'|| -- new LL EQ 
                            CUR_MISSING_DL.OVERHEIGHT_CM       ||'~'||
                            CUR_MISSING_DL.OVERLENGTH_REAR_CM  ||'~'||
                            CUR_MISSING_DL.OVERLENGTH_FRONT_CM ||'~'||
                            CUR_MISSING_DL.OVERWIDTH_LEFT_CM   ||'~'||
                            CUR_MISSING_DL.OVERWIDTH_RIGHT_CM  ||'~'||
                            CUR_MISSING_DL.FK_IMDG             ||'~'||
                            CUR_MISSING_DL.FK_UNNO             ||'~'||
                            CUR_MISSING_DL.FK_UN_VAR           ||'~'||
                            CUR_MISSING_DL.FLASH_POINT      ||'~'||
                            CUR_MISSING_DL.FLASH_UNIT       ||'~'||
                            CUR_MISSING_DL.REEFER_TMP       ||'~'||
                            CUR_MISSING_DL.REEFER_TMP_UNIT  ||'~'||
                            CUR_MISSING_DL.DN_HUMIDITY         ||'~'||
                            CUR_MISSING_DL.DN_VENTILATION      ||'~'||
                            CUR_MISSING_DL.CONTAINER_GROSS_WEIGHT           ||'~'|| --*30
                            CUR_MISSING_DL.CATEGORY_CODE     ||'~'||--*30
                            CUR_MISSING_DL.VGM ||'~'||             --*31
							CUR_MISSING_DL.PK_BOOKED_LOADING_ID ||'~'|| 
							CUR_MISSING_DL.PK_BOOKED_DISCHARGE_ID ||'~'|| 
                            CUR_MISSING_DL.STOWAGE_POSITION
                            ;

      VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG
        ( 'EZDL - JOB UPDATE MISSING EQ EZDL'
         , 'JOBEZDL'
         , 'B4 UPDATE BOOKED DL'
         , 'VASAPPS.PCR_EZL_UTILITY.PRR_DL_UPD_MISSING_EQ'
         , VRUNNINGDATETIME
         , L_V_PARAMETER_STR
        );

			BEGIN 
                    UPDATE TOS_DL_BOOKED_DISCHARGE
                    SET DN_EQUIPMENT_NO = CUR_MISSING_DL.DN_EQUIPMENT_NO
                        ,OVERHEIGHT_CM            = NVL2(CUR_MISSING_DL.OVERHEIGHT_CM,CUR_MISSING_DL.OVERHEIGHT_CM,OVERHEIGHT_CM)
                        , OVERLENGTH_REAR_CM       = NVL2(CUR_MISSING_DL.OVERLENGTH_REAR_CM,CUR_MISSING_DL.OVERLENGTH_REAR_CM,OVERLENGTH_REAR_CM)
                        , OVERLENGTH_FRONT_CM      = NVL2(CUR_MISSING_DL.OVERLENGTH_FRONT_CM,CUR_MISSING_DL.OVERLENGTH_FRONT_CM,OVERLENGTH_FRONT_CM)
                        , OVERWIDTH_LEFT_CM        = NVL2(CUR_MISSING_DL.OVERWIDTH_LEFT_CM, CUR_MISSING_DL.OVERWIDTH_LEFT_CM,OVERWIDTH_LEFT_CM)
                        , OVERWIDTH_RIGHT_CM       = NVL2(CUR_MISSING_DL.OVERWIDTH_RIGHT_CM,CUR_MISSING_DL.OVERWIDTH_RIGHT_CM,OVERWIDTH_RIGHT_CM)
                        ,FK_UNNO = CASE WHEN L_N_FOUND=0 THEN DECODE(CUR_MISSING_DL.FK_UNNO,'~',NULL,NVL2(CUR_MISSING_DL.FK_UNNO,CUR_MISSING_DL.FK_UNNO,FK_UNNO)) ELSE FK_UNNO END -- *28
                        , FK_IMDG = CASE WHEN L_N_FOUND=0 THEN DECODE(CUR_MISSING_DL.FK_IMDG,'~',NULL,NVL2(CUR_MISSING_DL.FK_IMDG,CUR_MISSING_DL.FK_IMDG,FK_IMDG))ELSE FK_IMDG END -- *28
                        , FK_UN_VAR = CASE WHEN L_N_FOUND=0 THEN DECODE(CUR_MISSING_DL.FK_UN_VAR,'~',NULL,NVL2(CUR_MISSING_DL.FK_UN_VAR,CUR_MISSING_DL.FK_UN_VAR,FK_UN_VAR)) ELSE FK_UN_VAR END -- *28

                        -- *28 , FK_UNNO                  = DECODE(p_i_v_unno,'~',NULL,NVL2(p_i_v_unno,p_i_v_unno,FK_UNNO))
                        -- *28 , FK_UN_VAR                = DECODE(p_i_v_un_var,'~',NULL,NVL2(p_i_v_un_var,p_i_v_un_var,FK_UN_VAR))
                        -- *28 , FK_IMDG                  = DECODE(p_i_v_imdg,'~',NULL,NVL2(p_i_v_imdg,p_i_v_imdg,FK_IMDG))

                        , FLASH_POINT              = DECODE(CUR_MISSING_DL.FLASH_POINT,'~',NULL,NVL2(CUR_MISSING_DL.FLASH_POINT,CUR_MISSING_DL.FLASH_POINT,FLASH_POINT))
                        , FLASH_UNIT               = DECODE(CUR_MISSING_DL.FLASH_UNIT,'~',NULL,NVL2(CUR_MISSING_DL.FLASH_UNIT,CUR_MISSING_DL.FLASH_UNIT,FLASH_UNIT))
                        , REEFER_TEMPERATURE       = DECODE(CUR_MISSING_DL.REEFER_TMP,'~',NULL,NVL2(CUR_MISSING_DL.REEFER_TMP,CUR_MISSING_DL.REEFER_TMP,REEFER_TEMPERATURE))
                        , REEFER_TMP_UNIT          = DECODE(CUR_MISSING_DL.REEFER_TMP_UNIT,'~',NULL,NVL2(CUR_MISSING_DL.REEFER_TMP_UNIT,CUR_MISSING_DL.REEFER_TMP_UNIT,REEFER_TMP_UNIT))
                        , DN_HUMIDITY              = NVL2(CUR_MISSING_DL.DN_HUMIDITY,CUR_MISSING_DL.DN_HUMIDITY,DN_HUMIDITY)
                        , DN_VENTILATION           = NVL2(CUR_MISSING_DL.DN_VENTILATION,CUR_MISSING_DL.DN_VENTILATION,DN_VENTILATION)
                      --  , FK_PORT_CLASS            = NVL2(l_v_portclass,l_v_portclass,FK_PORT_CLASS) --*26
                        , FK_PORT_CLASS_TYP        = NVL2(CUR_MISSING_DL.FK_PORT_CLASS_TYP,CUR_MISSING_DL.FK_PORT_CLASS_TYP,FK_PORT_CLASS_TYP)
                        , RECORD_CHANGE_USER       = 'UDMISDLEQ'
                        , RECORD_CHANGE_DATE       = SYSDATE
                        -- START *30
                        , CONTAINER_GROSS_WEIGHT = NVL2(CUR_MISSING_DL.CONTAINER_GROSS_WEIGHT,CUR_MISSING_DL.CONTAINER_GROSS_WEIGHT,CONTAINER_GROSS_WEIGHT)
                        ,CATEGORY_CODE = NVL2(CUR_MISSING_DL.CATEGORY_CODE,CUR_MISSING_DL.CATEGORY_CODE,CATEGORY_CODE)
                        -- END *30
                        , VGM = NVL2(CUR_MISSING_DL.VGM,CUR_MISSING_DL.VGM,VGM) --*31
                        ,STOWAGE_POSITION = NVL2(CUR_MISSING_DL.STOWAGE_POSITION,CUR_MISSING_DL.STOWAGE_POSITION,STOWAGE_POSITION)						
                    WHERE FK_BOOKING_NO          = CUR_MISSING_DL.FK_BOOKING_NO
                    AND   FK_BKG_EQUIPM_DTL      = CUR_MISSING_DL.FK_BKG_EQUIPM_DTL
                    AND   PK_BOOKED_DISCHARGE_ID = CUR_MISSING_DL.PK_BOOKED_DISCHARGE_ID
                    AND   DISCHARGE_STATUS       = 'BK'
                    AND   RECORD_STATUS          = 'A';
			EXCEPTION WHEN OTHERS THEN 
				      VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG
						( 'EZDL - JOB UPDATE MISSING EQ EZDL'
						 , 'JOBEZDL'
						 , 'ERROR IN UPDATE PROCESS'
						 , 'VASAPPS.PCR_EZL_UTILITY.PRR_DL_UPD_MISSING_EQ'
						 , SQLERRM
						 , vRunningDateTime
						 , l_v_parameter_str
						 , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK
						);
		    END; 


    END LOOP;
    COMMIT;


END ;


END PCR_EZL_UTILITY;
