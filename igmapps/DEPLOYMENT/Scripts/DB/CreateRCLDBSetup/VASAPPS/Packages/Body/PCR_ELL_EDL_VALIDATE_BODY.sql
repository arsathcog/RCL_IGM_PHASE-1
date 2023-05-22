create or replace
PACKAGE BODY           "PCR_ELL_EDL_VALIDATE" IS

  G_MEZLL VARCHAR2(5) DEFAULT 'MEZLL'; -- EZLL Activity Group
  G_MEZDL VARCHAR2(5) DEFAULT 'MEZDL'; -- EZDL Activity Group

  -- Excepion Code mapping with Java property file (ApplicationResources)
  G_EXCP_ELL_EMS_CODE     VARCHAR2(10) DEFAULT 'ELL.SE0135';
  G_EXCP_ELL_ARR_DEP_CODE VARCHAR2(10) DEFAULT 'ELL.SE0136';
  G_EXCP_ELL_BKG_STA_CODE VARCHAR2(10) DEFAULT 'ELL.SE0137';--@PD_CR_20170609_EZLL_BOOKING_STATUS_VALIDATION
  G_EXCP_EDL_EMS_CODE     VARCHAR2(10) DEFAULT 'EDL.SE0191';
  G_EXCP_EDL_ARR_DEP_CODE VARCHAR2(10) DEFAULT 'EDL.SE0192';

  /*-----------------------------------------------------------------------------------------------------------
  PRR_ELL_EMS_VALIDATE
  - Validate EMS activity in EZLL.
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2015
  -------------------------------------------------------------------------------------------------------------
  Author Wutiporn Kittitammarak 04/04/2016
  - Change Log ------------------------------------------------------------------------------------------------
  Ver DD/MM/YY -User-             -Short Description
  001 16/05/16 Wutiporn K.        Add service/vessel/voyage for EZLL validation
  002 18/05/16 Wutiporn K.        Changed output param to error code
  003 16/08/2016, Watcharee C.    Add field VGM back & allow to complete EZLL if shipment type is UC and loading status = SS
                                  as per K.Chatgamol advise.
  -----------------------------------------------------------------------------------------------------------*/
  /**
  * @param P_O_ERROR_CODE           Error code mapping with Java Propert File.
  * @param P_I_LOAD_LIST_ID         FK to TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID.
  * @param P_I_USER_ID              Login user ID
  */
  PROCEDURE PRR_ELL_EMS_VALIDATE(P_O_ERROR_CODE   OUT VARCHAR2
                                ,P_I_LOAD_LIST_ID INTEGER
                                ,P_I_USER_ID      VARCHAR2) IS
    V_COUNT NUMBER DEFAULT 0;
  BEGIN
    P_O_ERROR_CODE := VASAPPS.PCE_EUT_COMMON.G_V_SUCCESS_CD;
    -- Remove Previous Error Items
    DELETE FROM VASAPPS.TOS_LL_DL_ERROR_LOG
     WHERE FK_LL_DL_LIST_ID = P_I_LOAD_LIST_ID
       AND EXPORT_IMPORT = 'E';
    -- Validate EMS Activity
    INSERT INTO VASAPPS.TOS_LL_DL_ERROR_LOG
      (PK_LOG_SEQ
      ,EXPORT_IMPORT
      ,FK_LL_DL_LIST_ID
      ,FK_BOOKING_NO
      ,FK_EQUIPMENT_NO
      ,ERROR_MSG
      ,RECORD_ADD_USER
      ,RECORD_ADD_DATE)
      SELECT VASAPPS.SR_TOS_TLD01.NEXTVAL
            ,'E'
            ,LL.PK_LOAD_LIST_ID
            ,LLBKG.FK_BOOKING_NO
            ,LLBKG.DN_EQUIPMENT_NO
            ,'Missing Load activity check in EMS.'
            ,P_I_USER_ID
            ,SYSTIMESTAMP
        FROM VASAPPS.TOS_LL_LOAD_LIST      LL
            ,VASAPPS.TOS_LL_BOOKED_LOADING LLBKG
       WHERE LL.PK_LOAD_LIST_ID = LLBKG.FK_LOAD_LIST_ID
         AND LL.RECORD_STATUS = 'A'
         AND LLBKG.RECORD_STATUS = 'A'
         AND LLBKG.DN_SOC_COC = 'C'
         AND LL.PK_LOAD_LIST_ID = P_I_LOAD_LIST_ID
         --start *003
         AND LLBKG.DN_EQ_SIZE <> 0
         AND LLBKG.DN_EQ_TYPE <> '**'
         -- end *003
         AND NOT EXISTS
       (SELECT 'Y'
                FROM SEALINER.ECP030         MQ
                    ,SEALINER.STATUS_GRP     SG
                    ,SEALINER.STATUS_GRP_DTL SGD
               WHERE MQ.MQSTA = SGD.STATUS_CODE
                 AND SG.STATUS_GRP = SGD.STATUS_GRP
                 AND SG.GRPRCST = 'A'
                 AND SGD.RECORD_STATUS = 'A'
                 AND SGD.STATUS_GRP = G_MEZLL
                 AND MQ.MQPORT = NVL(LLBKG.DN_DISCHARGE_PORT, LL.DN_PORT)
                 AND MQ.MQSVCE = LL.FK_SERVICE
                 AND MQ.MQVESS = LL.FK_VESSEL
                 AND MQ.MQVOYN = LL.FK_VOYAGE
                 AND MQ.MQBOOK = LLBKG.FK_BOOKING_NO
                 AND MQ.MQEQN = LLBKG.DN_EQUIPMENT_NO)
         AND NOT EXISTS
       (SELECT 'Y'
                FROM VASAPPS.TOS_LL_LOAD_LIST      TLL
                    ,VASAPPS.TOS_LL_BOOKED_LOADING TLLBKG
                    ,SEALINER.ECP030               TMQ
                    ,SEALINER.STATUS_GRP           TSG
                    ,SEALINER.STATUS_GRP_DTL       TSGD
               WHERE TLL.PK_LOAD_LIST_ID = TLLBKG.FK_LOAD_LIST_ID
                 AND TLL.RECORD_STATUS = 'A'
                 AND TLLBKG.RECORD_STATUS = 'A'
                 AND TLLBKG.DN_SOC_COC = 'C'
                 AND TLL.PK_LOAD_LIST_ID = P_I_LOAD_LIST_ID
                 AND TMQ.MQSTA = TSGD.STATUS_CODE
                 AND TSG.STATUS_GRP = TSGD.STATUS_GRP
                 AND TSG.GRPRCST = 'A'
                 AND TSGD.RECORD_STATUS = 'A'
                 AND TSGD.STATUS_GRP = G_MEZLL
                 AND TMQ.MQPORT = NVL(TLLBKG.DN_DISCHARGE_PORT, TLL.DN_PORT)
                 AND TMQ.MQTERM =
                     NVL(TLLBKG.DN_DISCHARGE_TERMINAL, TLL.DN_TERMINAL)
                 AND TMQ.MQSVCE = TLL.FK_SERVICE
                 AND TMQ.MQVESS <> TLL.FK_VESSEL
                 AND TMQ.MQVOYN = TLL.FK_VOYAGE
                 AND TMQ.MQBOOK = TLLBKG.FK_BOOKING_NO
                 AND TMQ.MQEQN = TLLBKG.DN_EQUIPMENT_NO
                 AND TLLBKG.FK_BOOKING_NO = LLBKG.FK_BOOKING_NO
                 AND TLLBKG.DN_EQUIPMENT_NO = LLBKG.DN_EQUIPMENT_NO);

    -- Validate Terminal Code
    INSERT INTO VASAPPS.TOS_LL_DL_ERROR_LOG
      (PK_LOG_SEQ
      ,EXPORT_IMPORT
      ,FK_LL_DL_LIST_ID
      ,FK_BOOKING_NO
      ,FK_EQUIPMENT_NO
      ,ERROR_MSG
      ,RECORD_ADD_USER
      ,RECORD_ADD_DATE
      ,EMS_ACTIVITY_CODE
      ,EMS_ACTIVITY_DATE
      ,EMS_TERMINAL_CODE
      ,EMS_SERVICE
      ,EMS_VESSEL
      ,EMS_VOYAGE)
      SELECT VASAPPS.SR_TOS_TLD01.NEXTVAL
            ,'E'
            ,LL.PK_LOAD_LIST_ID
            ,LLBKG.FK_BOOKING_NO
            ,LLBKG.DN_EQUIPMENT_NO
            ,'Invalid Terminal code'
            ,P_I_USER_ID
            ,SYSTIMESTAMP
            ,MQ.MQSTA
            ,MQ.MQMVDT
            ,MQ.MQTERM
            ,MQ.MQSVCE
            ,MQ.MQVESS
            ,MQ.MQVOYN
        FROM VASAPPS.TOS_LL_LOAD_LIST      LL
            ,VASAPPS.TOS_LL_BOOKED_LOADING LLBKG
            ,SEALINER.ECP030               MQ
            ,SEALINER.STATUS_GRP           SG
            ,SEALINER.STATUS_GRP_DTL       SGD
       WHERE LL.PK_LOAD_LIST_ID = LLBKG.FK_LOAD_LIST_ID
         AND LL.RECORD_STATUS = 'A'
         AND LLBKG.RECORD_STATUS = 'A'
         AND LLBKG.DN_SOC_COC = 'C'
         AND LL.PK_LOAD_LIST_ID = P_I_LOAD_LIST_ID
         AND MQ.MQSTA = SGD.STATUS_CODE
         AND SG.STATUS_GRP = SGD.STATUS_GRP
         AND SG.GRPRCST = 'A'
         AND SGD.RECORD_STATUS = 'A'
         AND SGD.STATUS_GRP = G_MEZLL
         AND MQ.MQPORT = NVL(LLBKG.DN_DISCHARGE_PORT, LL.DN_PORT)
         AND MQ.MQTERM IS NOT NULL
         AND MQ.MQTERM <> NVL(LLBKG.DN_DISCHARGE_TERMINAL, LL.DN_TERMINAL)
         AND MQ.MQSVCE = LL.FK_SERVICE
         AND MQ.MQVESS = LL.FK_VESSEL
         AND MQ.MQVOYN = LL.FK_VOYAGE
         AND MQ.MQBOOK = LLBKG.FK_BOOKING_NO
         AND MQ.MQEQN = LLBKG.DN_EQUIPMENT_NO;

    -- Validate Vessel Code
    INSERT INTO VASAPPS.TOS_LL_DL_ERROR_LOG
      (PK_LOG_SEQ
      ,EXPORT_IMPORT
      ,FK_LL_DL_LIST_ID
      ,FK_BOOKING_NO
      ,FK_EQUIPMENT_NO
      ,ERROR_MSG
      ,RECORD_ADD_USER
      ,RECORD_ADD_DATE
      ,EMS_ACTIVITY_CODE
      ,EMS_ACTIVITY_DATE
      ,EMS_TERMINAL_CODE
      ,EMS_SERVICE
      ,EMS_VESSEL
      ,EMS_VOYAGE)
      SELECT VASAPPS.SR_TOS_TLD01.NEXTVAL
            ,'E'
            ,LL.PK_LOAD_LIST_ID
            ,LLBKG.FK_BOOKING_NO
            ,LLBKG.DN_EQUIPMENT_NO
            ,'Wrong Vessel code in EMS for Load activity.  Please check EMS.'
            ,P_I_USER_ID
            ,SYSTIMESTAMP
            ,MQ.MQSTA
            ,MQ.MQMVDT
            ,MQ.MQTERM
            ,MQ.MQSVCE
            ,MQ.MQVESS
            ,MQ.MQVOYN
        FROM VASAPPS.TOS_LL_LOAD_LIST      LL
            ,VASAPPS.TOS_LL_BOOKED_LOADING LLBKG
            ,SEALINER.ECP030               MQ
            ,SEALINER.STATUS_GRP           SG
            ,SEALINER.STATUS_GRP_DTL       SGD
       WHERE LL.PK_LOAD_LIST_ID = LLBKG.FK_LOAD_LIST_ID
         AND LL.RECORD_STATUS = 'A'
         AND LLBKG.RECORD_STATUS = 'A'
         AND LLBKG.DN_SOC_COC = 'C'
         AND LL.PK_LOAD_LIST_ID = P_I_LOAD_LIST_ID
         AND MQ.MQSTA = SGD.STATUS_CODE
         AND SG.STATUS_GRP = SGD.STATUS_GRP
         AND SG.GRPRCST = 'A'
         AND SGD.RECORD_STATUS = 'A'
         AND SGD.STATUS_GRP = G_MEZLL
         AND MQ.MQPORT = NVL(LLBKG.DN_DISCHARGE_PORT, LL.DN_PORT)
         AND MQ.MQTERM = NVL(LLBKG.DN_DISCHARGE_TERMINAL, LL.DN_TERMINAL)
         AND MQ.MQSVCE = LL.FK_SERVICE
         AND MQ.MQVESS <> LL.FK_VESSEL
         AND MQ.MQVOYN = LL.FK_VOYAGE
         AND MQ.MQBOOK = LLBKG.FK_BOOKING_NO
         AND MQ.MQEQN = LLBKG.DN_EQUIPMENT_NO;

    -- 001, 16/05/2016, Wutiporn, Add service/vessel/voyage for EZLL validation
    -- Validate Service/Vessel/Voyage
    INSERT INTO VASAPPS.TOS_LL_DL_ERROR_LOG
      (PK_LOG_SEQ
      ,EXPORT_IMPORT
      ,FK_LL_DL_LIST_ID
      ,FK_BOOKING_NO
      ,FK_EQUIPMENT_NO
      ,ERROR_MSG
      ,RECORD_ADD_USER
      ,RECORD_ADD_DATE
      ,EMS_ACTIVITY_CODE
      ,EMS_ACTIVITY_DATE
      ,EMS_TERMINAL_CODE
      ,EMS_SERVICE
      ,EMS_VESSEL
      ,EMS_VOYAGE)
      SELECT VASAPPS.SR_TOS_TLD01.NEXTVAL
            ,'E'
            ,LL.PK_LOAD_LIST_ID
            ,LLBKG.FK_BOOKING_NO
            ,LLBKG.DN_EQUIPMENT_NO
            ,'Invalid Service/Vessel/Voyage code in EMS for Load activity.  Please check in EMS.'
            ,P_I_USER_ID
            ,SYSTIMESTAMP
            ,MQ.MQSTA
            ,MQ.MQMVDT
            ,MQ.MQTERM
            ,MQ.MQSVCE
            ,MQ.MQVESS
            ,MQ.MQVOYN
        FROM VASAPPS.TOS_LL_LOAD_LIST      LL
            ,VASAPPS.TOS_LL_BOOKED_LOADING LLBKG
            ,SEALINER.ECP030               MQ
            ,SEALINER.STATUS_GRP           SG
            ,SEALINER.STATUS_GRP_DTL       SGD
       WHERE LL.PK_LOAD_LIST_ID = LLBKG.FK_LOAD_LIST_ID
         AND LL.RECORD_STATUS = 'A'
         AND LLBKG.RECORD_STATUS = 'A'
         AND LLBKG.DN_SOC_COC = 'C'
         AND LL.PK_LOAD_LIST_ID = P_I_LOAD_LIST_ID
         AND MQ.MQSTA = SGD.STATUS_CODE
         AND SG.STATUS_GRP = SGD.STATUS_GRP
         AND SG.GRPRCST = 'A'
         AND SGD.RECORD_STATUS = 'A'
         AND SGD.STATUS_GRP = G_MEZLL
         AND MQ.MQPORT = NVL(LLBKG.DN_DISCHARGE_PORT, LL.DN_PORT)
         AND MQ.MQTERM = NVL(LLBKG.DN_DISCHARGE_TERMINAL, LL.DN_TERMINAL)
         AND (MQ.MQVESS <> LL.FK_VESSEL OR MQ.MQSVCE <> LL.FK_SERVICE OR
             MQ.MQVOYN <> LL.FK_VOYAGE)
         AND MQ.MQBOOK = LLBKG.FK_BOOKING_NO
         AND MQ.MQEQN = LLBKG.DN_EQUIPMENT_NO;
    COMMIT;
    -- Count Error Items
    SELECT COUNT(*)
      INTO V_COUNT
      FROM VASAPPS.TOS_LL_DL_ERROR_LOG
     WHERE FK_LL_DL_LIST_ID = P_I_LOAD_LIST_ID
       AND EXPORT_IMPORT = 'E';
    IF V_COUNT > 0 THEN
      P_O_ERROR_CODE := G_EXCP_ELL_EMS_CODE;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END PRR_ELL_EMS_VALIDATE;

  /*-----------------------------------------------------------------------------------------------------------
  PRR_EDL_EMS_VALIDATE
  - Validate EMS activity in EZLL.
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2015
  -------------------------------------------------------------------------------------------------------------
  Author Wutiporn Kittitammarak 04/04/2016
  - Change Log ------------------------------------------------------------------------------------------------
  Ver DD/MM/YY -User-             -Short Description
  001 18/05/16 Wutiporn K.        Changed output param to error code
  -----------------------------------------------------------------------------------------------------------*/
  /**
  * @param P_O_ERROR_CODE           Error code mapping with Java Property File.
  * @param P_I_DISCHARGE_LIST_ID    FK to TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID.
  * @param P_I_USER_ID              Login user ID
  */
  PROCEDURE PRR_EDL_EMS_VALIDATE(P_O_ERROR_CODE        OUT VARCHAR2
                                ,P_I_DISCHARGE_LIST_ID INTEGER
                                ,P_I_USER_ID           VARCHAR2) IS
    V_COUNT NUMBER DEFAULT 0;
  BEGIN
    P_O_ERROR_CODE := VASAPPS.PCE_EUT_COMMON.G_V_SUCCESS_CD;
    -- Remove Previous Error Items
    DELETE FROM VASAPPS.TOS_LL_DL_ERROR_LOG
     WHERE FK_LL_DL_LIST_ID = P_I_DISCHARGE_LIST_ID
       AND EXPORT_IMPORT = 'I';
    -- Validate EMS Activity
    INSERT INTO VASAPPS.TOS_LL_DL_ERROR_LOG
      (PK_LOG_SEQ
      ,EXPORT_IMPORT
      ,FK_LL_DL_LIST_ID
      ,FK_BOOKING_NO
      ,FK_EQUIPMENT_NO
      ,ERROR_MSG
      ,RECORD_ADD_USER
      ,RECORD_ADD_DATE)
      SELECT VASAPPS.SR_TOS_TLD01.NEXTVAL
            ,'I'
            ,DL.PK_DISCHARGE_LIST_ID
            ,DLBKG.FK_BOOKING_NO
            ,DLBKG.DN_EQUIPMENT_NO
            ,'Missing Discharge activity check in EMS.'
            ,P_I_USER_ID
            ,SYSTIMESTAMP
        FROM VASAPPS.TOS_DL_DISCHARGE_LIST   DL
            ,VASAPPS.TOS_DL_BOOKED_DISCHARGE DLBKG
       WHERE DL.PK_DISCHARGE_LIST_ID = DLBKG.FK_DISCHARGE_LIST_ID
         AND DL.RECORD_STATUS = 'A'
         AND DLBKG.RECORD_STATUS = 'A'
         AND DLBKG.DN_SOC_COC = 'C'
         AND DL.PK_DISCHARGE_LIST_ID = P_I_DISCHARGE_LIST_ID
         --start *003
         AND DLBKG.DN_EQ_SIZE <> 0
         AND DLBKG.DN_EQ_TYPE <> '**'
         -- end *003
         AND NOT EXISTS
       (SELECT 'Y'
                FROM SEALINER.ECP030         MQ
                    ,SEALINER.STATUS_GRP     SG
                    ,SEALINER.STATUS_GRP_DTL SGD
               WHERE MQ.MQSTA = SGD.STATUS_CODE
                 AND SG.STATUS_GRP = SGD.STATUS_GRP
                 AND SG.GRPRCST = 'A'
                 AND SGD.RECORD_STATUS = 'A'
                 AND SGD.STATUS_GRP = G_MEZDL
                 AND MQ.MQPORT = DL.DN_PORT
                 AND MQ.MQBOOK = DLBKG.FK_BOOKING_NO
                 AND MQ.MQEQN = DLBKG.DN_EQUIPMENT_NO);

    -- Validate Terminal Code
    INSERT INTO VASAPPS.TOS_LL_DL_ERROR_LOG
      (PK_LOG_SEQ
      ,EXPORT_IMPORT
      ,FK_LL_DL_LIST_ID
      ,FK_BOOKING_NO
      ,FK_EQUIPMENT_NO
      ,ERROR_MSG
      ,RECORD_ADD_USER
      ,RECORD_ADD_DATE
      ,EMS_ACTIVITY_CODE
      ,EMS_ACTIVITY_DATE
      ,EMS_TERMINAL_CODE
      ,EMS_SERVICE
      ,EMS_VESSEL
      ,EMS_VOYAGE)
      SELECT VASAPPS.SR_TOS_TLD01.NEXTVAL
            ,'I'
            ,DL.PK_DISCHARGE_LIST_ID
            ,DLBKG.FK_BOOKING_NO
            ,DLBKG.DN_EQUIPMENT_NO
            ,'Invalid Terminal code'
            ,P_I_USER_ID
            ,SYSTIMESTAMP
            ,MQ.MQSTA AS ACTIVITY_CODE
            ,MQ.MQMVDT AS ACTIVITY_DATE
            ,MQ.MQTERM AS INVALID_TERMINAL
            ,MQ.MQSVCE
            ,MQ.MQVESS
            ,MQ.MQVOYN
        FROM VASAPPS.TOS_DL_DISCHARGE_LIST   DL
            ,VASAPPS.TOS_DL_BOOKED_DISCHARGE DLBKG
            ,SEALINER.ECP030                 MQ
            ,SEALINER.STATUS_GRP             SG
            ,SEALINER.STATUS_GRP_DTL         SGD
       WHERE DL.PK_DISCHARGE_LIST_ID = DLBKG.FK_DISCHARGE_LIST_ID
         AND DL.RECORD_STATUS = 'A'
         AND DLBKG.RECORD_STATUS = 'A'
         AND DLBKG.DN_SOC_COC = 'C'
         AND DL.PK_DISCHARGE_LIST_ID = P_I_DISCHARGE_LIST_ID
         AND MQ.MQSTA = SGD.STATUS_CODE
         AND SG.STATUS_GRP = SGD.STATUS_GRP
         AND SG.GRPRCST = 'A'
         AND SGD.RECORD_STATUS = 'A'
         AND SGD.STATUS_GRP = G_MEZDL
         AND MQ.MQPORT = DL.DN_PORT
         AND NVL(MQ.MQTERM, ' ') <> DL.DN_TERMINAL
         AND MQ.MQBOOK = DLBKG.FK_BOOKING_NO
         AND MQ.MQEQN = DLBKG.DN_EQUIPMENT_NO;

    -- Validate Service/Vessel/Voyage
    SELECT COUNT(*)
      INTO V_COUNT
      FROM VCM_CONFIG_MST
     WHERE CONFIG_TYP = 'EZDL_EMS_VAL'
       AND CONFIG_CD = 'EZDL_VSL_CHECK'
       AND CONFIG_VALUE = 'Y';
    IF V_COUNT > 0 THEN
      INSERT INTO VASAPPS.TOS_LL_DL_ERROR_LOG
        (PK_LOG_SEQ
        ,EXPORT_IMPORT
        ,FK_LL_DL_LIST_ID
        ,FK_BOOKING_NO
        ,FK_EQUIPMENT_NO
        ,ERROR_MSG
        ,RECORD_ADD_USER
        ,RECORD_ADD_DATE
        ,EMS_ACTIVITY_CODE
        ,EMS_ACTIVITY_DATE
        ,EMS_TERMINAL_CODE
        ,EMS_SERVICE
        ,EMS_VESSEL
        ,EMS_VOYAGE)
        SELECT VASAPPS.SR_TOS_TLD01.NEXTVAL
              ,'I'
              ,DL.PK_DISCHARGE_LIST_ID
              ,DLBKG.FK_BOOKING_NO
              ,DLBKG.DN_EQUIPMENT_NO
              ,'Wrong Vessel code in EMS for Discharge activity.  Please check in EMS.'
              ,P_I_USER_ID
              ,SYSTIMESTAMP
              ,MQ.MQSTA AS ACTIVITY_CODE
              ,MQ.MQMVDT AS ACTIVITY_DATE
              ,MQ.MQTERM AS INVALID_TERMINAL
              ,MQ.MQSVCE
              ,MQ.MQVESS
              ,MQ.MQVOYN
          FROM VASAPPS.TOS_DL_DISCHARGE_LIST   DL
              ,VASAPPS.TOS_DL_BOOKED_DISCHARGE DLBKG
              ,SEALINER.ECP030                 MQ
              ,SEALINER.STATUS_GRP             SG
              ,SEALINER.STATUS_GRP_DTL         SGD
         WHERE DL.PK_DISCHARGE_LIST_ID = DLBKG.FK_DISCHARGE_LIST_ID
           AND DL.RECORD_STATUS = 'A'
           AND DLBKG.RECORD_STATUS = 'A'
           AND DLBKG.DN_SOC_COC = 'C'
           AND DL.PK_DISCHARGE_LIST_ID = P_I_DISCHARGE_LIST_ID
           AND MQ.MQSTA = SGD.STATUS_CODE
           AND SG.STATUS_GRP = SGD.STATUS_GRP
           AND SG.GRPRCST = 'A'
           AND SGD.RECORD_STATUS = 'A'
           AND SGD.STATUS_GRP = G_MEZDL
           AND MQ.MQPORT = DL.DN_PORT
           AND NVL(MQ.MQTERM, ' ') = DL.DN_TERMINAL
           AND MQ.MQVESS <> DL.FK_VESSEL
           AND MQ.MQBOOK = DLBKG.FK_BOOKING_NO
           AND MQ.MQEQN = DLBKG.DN_EQUIPMENT_NO;
    ELSE
      INSERT INTO VASAPPS.TOS_LL_DL_ERROR_LOG
        (PK_LOG_SEQ
        ,EXPORT_IMPORT
        ,FK_LL_DL_LIST_ID
        ,FK_BOOKING_NO
        ,FK_EQUIPMENT_NO
        ,ERROR_MSG
        ,RECORD_ADD_USER
        ,RECORD_ADD_DATE
        ,EMS_ACTIVITY_CODE
        ,EMS_ACTIVITY_DATE
        ,EMS_TERMINAL_CODE
        ,EMS_SERVICE
        ,EMS_VESSEL
        ,EMS_VOYAGE)
        SELECT VASAPPS.SR_TOS_TLD01.NEXTVAL
              ,'I'
              ,DL.PK_DISCHARGE_LIST_ID
              ,DLBKG.FK_BOOKING_NO
              ,DLBKG.DN_EQUIPMENT_NO
              ,'Invalid Service/Vessel/Voyage code in EMS for Discharge activity.  Please check in EMS.'
              ,P_I_USER_ID
              ,SYSTIMESTAMP
              ,MQ.MQSTA AS ACTIVITY_CODE
              ,MQ.MQMVDT AS ACTIVITY_DATE
              ,MQ.MQTERM AS INVALID_TERMINAL
              ,MQ.MQSVCE
              ,MQ.MQVESS
              ,MQ.MQVOYN
          FROM VASAPPS.TOS_DL_DISCHARGE_LIST   DL
              ,VASAPPS.TOS_DL_BOOKED_DISCHARGE DLBKG
              ,SEALINER.ECP030                 MQ
              ,SEALINER.STATUS_GRP             SG
              ,SEALINER.STATUS_GRP_DTL         SGD
         WHERE DL.PK_DISCHARGE_LIST_ID = DLBKG.FK_DISCHARGE_LIST_ID
           AND DL.RECORD_STATUS = 'A'
           AND DLBKG.RECORD_STATUS = 'A'
           AND DLBKG.DN_SOC_COC = 'C'
           AND DL.PK_DISCHARGE_LIST_ID = P_I_DISCHARGE_LIST_ID
           AND MQ.MQSTA = SGD.STATUS_CODE
           AND SG.STATUS_GRP = SGD.STATUS_GRP
           AND SG.GRPRCST = 'A'
           AND SGD.RECORD_STATUS = 'A'
           AND SGD.STATUS_GRP = G_MEZDL
           AND MQ.MQPORT = DL.DN_PORT
           AND NVL(MQ.MQTERM, ' ') = DL.DN_TERMINAL
           AND (MQ.MQVESS <> DL.FK_VESSEL OR MQ.MQSVCE <> DL.FK_SERVICE OR
               MQ.MQVOYN <> DL.FK_VOYAGE)
           AND MQ.MQBOOK = DLBKG.FK_BOOKING_NO
           AND MQ.MQEQN = DLBKG.DN_EQUIPMENT_NO;
    END IF;
    COMMIT;
    -- Count Error Items
    SELECT COUNT(*)
      INTO V_COUNT
      FROM VASAPPS.TOS_LL_DL_ERROR_LOG
     WHERE FK_LL_DL_LIST_ID = P_I_DISCHARGE_LIST_ID
       AND EXPORT_IMPORT = 'I';
    IF V_COUNT > 0 THEN
      P_O_ERROR_CODE := G_EXCP_EDL_EMS_CODE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END PRR_EDL_EMS_VALIDATE;

  /*-----------------------------------------------------------------------------------------------------------
  PRR_ELL_ARR_DEP_VALIDATE
  - Validate Arrival/Departure be complete, EZLL status cannot change from Loading Complete
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2015
  -------------------------------------------------------------------------------------------------------------
  Author Wutiporn Kittitammarak 04/04/2016
  - Change Log ------------------------------------------------------------------------------------------------
  Ver DD/MM/YY -User-               -Short Description
  001 07/06/16 Wutiporn K.          Fixed Arr/Dep complete status
  -----------------------------------------------------------------------------------------------------------*/
  /**
  * @param P_O_ERROR_CODE           Error code mapping with Java Property file
  * @param P_I_SERVICE
  * @param P_I_VESSEL
  * @param P_I_VOYAGE
  * @param P_I_DIR
  * @param P_I_DIR
  * @param P_I_PORT
  * @param P_I_TERMINAL
  */
  PROCEDURE PRR_ELL_ARR_DEP_VALIDATE(P_O_ERROR_CODE OUT VARCHAR2
                                    ,P_I_SERVICE    VARCHAR2
                                    ,P_I_VESSEL     VARCHAR2
                                    ,P_I_VOYAGE     VARCHAR2
                                    ,P_I_PCSQ       NUMBER
                                    ,P_I_PORT       VARCHAR2
                                    ,P_I_TERMINAL   VARCHAR2) IS
    V_TOS_STATUS VARCHAR2(1);
  BEGIN
    P_O_ERROR_CODE := VASAPPS.PCE_EUT_COMMON.G_V_SUCCESS_CD;
    BEGIN
      SELECT NVL(TOS_PROFORMA_STATUS, 'N')
        INTO V_TOS_STATUS
        FROM SEALINER.ITP063
       WHERE VVSRVC = P_I_SERVICE
         AND VVVESS = P_I_VESSEL
         AND VVVOYN = P_I_VOYAGE
         AND VVPCAL = P_I_PORT
         AND VVTRM1 = P_I_TERMINAL
         AND VVPCSQ = P_I_PCSQ
         AND OMMISSION_FLAG IS NULL
         AND VVVERS = 99
         AND ROWNUM = 1;

      IF V_TOS_STATUS = 'Y' THEN
        -- 001,07/06/2016,Wutiporn K.,Fixed Arr/Dep Complete status
        P_O_ERROR_CODE := G_EXCP_ELL_ARR_DEP_CODE;
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END PRR_ELL_ARR_DEP_VALIDATE;

  /*-----------------------------------------------------------------------------------------------------------
  PRR_EDL_ARR_DEP_VALIDATE
  - Validate Arrival/Departure be complete, EZDL status cannot change from Discharge Complete
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2015
  -------------------------------------------------------------------------------------------------------------
  Author Wutiporn Kittitammarak 04/04/2016
  - Change Log ------------------------------------------------------------------------------------------------
  Ver DD/MM/YY -User-               -Short Description
  001 07/06/16 Wutiporn K.          Fixed Arr/Dep complete status
  -----------------------------------------------------------------------------------------------------------*/
  /**
  * @param P_O_ERROR_CODE           Error code mapping with Java Property file
  * @param P_I_SERVICE
  * @param P_I_VESSEL
  * @param P_I_VOYAGE
  * @param P_I_DIR
  * @param P_I_DIR
  * @param P_I_PORT
  * @param P_I_TERMINAL
  */
  PROCEDURE PRR_EDL_ARR_DEP_VALIDATE(P_O_ERROR_CODE OUT VARCHAR2
                                    ,P_I_SERVICE    VARCHAR2
                                    ,P_I_VESSEL     VARCHAR2
                                    ,P_I_VOYAGE     VARCHAR2
                                    ,P_I_PCSQ       NUMBER
                                    ,P_I_PORT       VARCHAR2
                                    ,P_I_TERMINAL   VARCHAR2) IS
    V_OUTVOYAGE_EXIST BOOLEAN DEFAULT FALSE;
    V_OUTVOYAGE       SEALINER.ITP063%ROWTYPE;
  BEGIN
    P_O_ERROR_CODE := VASAPPS.PCE_EUT_COMMON.G_V_SUCCESS_CD;
    -- Get out voyage from in voayge
    PRR_OUT_VOYAGE_GET(V_OUTVOYAGE,
                       V_OUTVOYAGE_EXIST,
                       P_I_SERVICE,
                       P_I_VESSEL,
                       P_I_VOYAGE,
                       P_I_PORT,
                       P_I_TERMINAL,
                       P_I_PCSQ);

    IF V_OUTVOYAGE_EXIST = TRUE THEN
      IF NVL(V_OUTVOYAGE.TOS_PROFORMA_STATUS, 'N') = 'Y' THEN
        -- 001,07/06/2016,Wutiporn K.,Fixed Arr/Dep Complete status
        P_O_ERROR_CODE := G_EXCP_EDL_ARR_DEP_CODE;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END PRR_EDL_ARR_DEP_VALIDATE;

  /*-----------------------------------------------------------------------------------------------------------
  PRR_OUT_VOYAGE_GET
  - Get out voyage by in voyafe from EZDL.
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2015
  -------------------------------------------------------------------------------------------------------------
  Author Wutiporn Kittitammarak 04/04/2016
  - Change Log ------------------------------------------------------------------------------------------------
  Ver DD/MM/YY -User-               -Short Description
  001 07/06/16 Wutiporn K.          Fixed voyage in case
  -----------------------------------------------------------------------------------------------------------*/
  /**
  * @param P_O_OUT_VOYAGE           Return out voyage
  * @param P_O_EXISTS               True=Existing:otherwise False
  * @param P_I_SERVICE
  * @param P_I_VESSEL
  * @param P_I_VOYAGE
  * @param P_I_PORT
  * @param P_I_TERMINAL
  * @param P_I_PCSQ
  */
  PROCEDURE PRR_OUT_VOYAGE_GET(P_O_OUT_VOYAGE OUT SEALINER.ITP063%ROWTYPE
                              ,P_O_EXISTS     OUT BOOLEAN
                              ,P_I_SERVICE    VARCHAR2
                              ,P_I_VESSEL     VARCHAR2
                              ,P_I_VOYAGE     VARCHAR2
                              ,P_I_PORT       VARCHAR2
                              ,P_I_TERMINAL   VARCHAR2
                              ,P_I_PCSQ       NUMBER) IS

    V_FORL       VARCHAR2(1);
    V_ETA        NUMBER(8);
    V_ETD        NUMBER(8);
    V_INVOYAGENO VARCHAR2(10);
    V_COUNT      INTEGER;
    V_VOYAGE_ID  VARCHAR2(10 BYTE);

    CURSOR CR_OUT_VOYAGE IS

      SELECT *
        FROM ITP063
       WHERE VVVESS = P_I_VESSEL
         AND VVPCAL = P_I_PORT
         AND VVTRM1 = P_I_TERMINAL
         AND VVARDT = V_ETA
         AND VVDPDT = V_ETD
         AND VVSRVC <> 'AFS'
         AND VVFORL IN ('F', 'O')
         AND VVVERS = 99
         AND OMMISSION_FLAG IS NULL
         AND ROWNUM = 1;

  BEGIN
    P_O_EXISTS := FALSE;

    SELECT VVFORL
          ,VVARDT
          ,VVDPDT
          ,NVL(INVOYAGENO, P_I_VOYAGE)
          ,VOYAGE_ID
      INTO V_FORL
          ,V_ETA
          ,V_ETD
          ,V_INVOYAGENO
          ,V_VOYAGE_ID
      FROM SEALINER.ITP063
     WHERE VVSRVC = P_I_SERVICE
       AND VVVESS = P_I_VESSEL
       AND VVVOYN = P_I_VOYAGE
       AND VVPCAL = P_I_PORT
       AND VVTRM1 = P_I_TERMINAL
       AND VVPCSQ = P_I_PCSQ
       AND OMMISSION_FLAG IS NULL
       AND VVVERS = 99
       AND ROWNUM = 1;

    -- Check linkage for last port ,if linkage system will not allow to generate TOS proforma
    IF NVL(V_FORL, ' ') = 'L' THEN
      IF P_I_SERVICE <> 'AFS' THEN
        SELECT COUNT(*)
          INTO V_COUNT
          FROM ITP063 F
              ,ITP063 D
         WHERE F.VVVESS = P_I_VESSEL
           AND F.VVPCAL = P_I_PORT
           AND F.VVTRM1 = P_I_TERMINAL
           AND F.VVARDT = V_ETA
           AND F.VVDPDT = V_ETD
           AND F.VVSRVC <> 'AFS' -- #3 ADD BY WACCHO1 ON 08/10/2014 SUPPORT CASE DFS AND NEXT VOYAGE WILL BE AFS WILL ALLOW TO GENERATE
           AND F.VVFORL IN ('F', 'O')
           AND D.ACT_DMY_FLG = 'D' --#2.6
              --AND P_I_V_VOYAGE = D.VVVOYN --#2.6
           AND V_VOYAGE_ID = D.VOYAGE_ID --#2.6
           AND P_I_VESSEL = D.VVVESS --#2.6
           AND P_I_SERVICE = D.VVSRVC --#2.6
              --AND P_I_V_DIR=D.VVSDIR --#2.6
           AND F.VVVERS = 99
           AND F.OMMISSION_FLAG IS NULL
           AND D.VVVERS = 99; -- #2.6

        IF V_COUNT > 0 THEN
          BEGIN
            OPEN CR_OUT_VOYAGE;
            FETCH CR_OUT_VOYAGE
              INTO P_O_OUT_VOYAGE;
            IF CR_OUT_VOYAGE%NOTFOUND THEN
              P_O_EXISTS := FALSE;
            ELSE
              P_O_EXISTS := TRUE;
            END IF;
            CLOSE CR_OUT_VOYAGE;
          EXCEPTION
            WHEN OTHERS THEN
              P_O_EXISTS := FALSE;
              CLOSE CR_OUT_VOYAGE;
          END;
        END IF;

      END IF;
    ELSE
      SELECT *
        INTO P_O_OUT_VOYAGE
        FROM SEALINER.ITP063
       WHERE VVSRVC = P_I_SERVICE
         AND VVVESS = P_I_VESSEL
         AND VVVOYN = P_I_VOYAGE
         AND VVPCAL = P_I_PORT
         AND VVTRM1 = P_I_TERMINAL
         AND VVPCSQ = P_I_PCSQ
         AND OMMISSION_FLAG IS NULL
         AND VVVERS = 99
         AND ROWNUM = 1;
      P_O_EXISTS := TRUE;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_O_EXISTS := FALSE;
  END PRR_OUT_VOYAGE_GET;

 /*-----------------------------------------------------------------------------------------------------------
   /*-----------------------------------------------------------------------------------------------------------
  PRE_ELL_STATUS_BKG_VALIDATION
  - Validate EMS activity in EZLL.
  -------------------------------------------------------------------------------------------------------------
  Copyright RCL Public Co., Ltd. 2015
  -------------------------------------------------------------------------------------------------------------
  Author Wutiporn Kittitammarak 04/04/2016
  - Change Log ------------------------------------------------------------------------------------------------
  Ver DD/MM/YY -User-             -Short Description
  001 20/06/2017  NIIT            PD_CR_20170609_EZLL_BOOKING_STATUS_VALIDATION
  -----------------------------------------------------------------------------------------------------------*/
  /**
  * @param P_SERVICE        TOS_LL_LOAD_LIST.FK_SERVICE.
  * @param P_VESSEL         TOS_LL_LOAD_LIST.FK_VESSEL.
  * @param P_VOYAGE         TOS_LL_LOAD_LIST.FK_VOYAGE.
  * @param P_PORT           TOS_LL_LOAD_LIST.DN_PORT.
  * @param P_TERMINAL       TOS_LL_LOAD_LIST.DN_TERMINAL.
  * @param P_O_ERROR_CODE   Error code mapping with Java Property File.
  */
  PROCEDURE PRE_ELL_STATUS_BKG_VALIDATION(P_SERVICE		VARCHAR2
                                         ,P_VESSEL		VARCHAR2
										 ,P_VOYAGE		VARCHAR2
										 ,P_PORT		VARCHAR2
										 ,P_TERMINAL	VARCHAR2
                                         ,P_O_V_ERR_CD  OUT VARCHAR2) AS

  L_REC_COUNT   NUMBER := 0;
  BEGIN
     SELECT COUNT(bkg.BABKNO)
       INTO L_REC_COUNT
	   FROM sealiner.booking_voyage_routing_dtl bkg_dtl,BKP001 bkg
	   WHERE bkg.BABKNO=bkg_dtl.BOOKING_NO and bkg.BASTAT IN('O','W')
       AND bkg_dtl.SERVICE =P_SERVICE AND bkg_dtl.VESSEL=P_VESSEL AND bkg_dtl.VOYNO=P_VOYAGE
	   AND bkg_dtl.FROM_TERMINAL=P_TERMINAL AND bkg_dtl.LOAD_PORT=P_PORT
       AND bkg_dtl.SERVICE=bkg.BASRVC AND bkg_dtl.VESSEL=bkg.BAVESS AND bkg_dtl.VOYNO=bkg.BAVOY  
       AND bkg_dtl.LOAD_PORT =bkg.BAPOL;
	 IF (L_REC_COUNT > 0) THEN
	   P_O_V_ERR_CD := G_EXCP_ELL_BKG_STA_CODE;
       RETURN;
	 END IF;

  EXCEPTION
     WHEN OTHERS THEN
        P_O_V_ERR_CD := PCE_EUT_COMMON.G_V_GE0001 ||
				        PCE_EUT_COMMON.G_V_ERR_DATA_SEP ||
				        SUBSTR(SQLCODE, 1, 10) || ':' ||
				        SUBSTR(SQLERRM, 1, 100);
  END PRE_ELL_STATUS_BKG_VALIDATION;
END PCR_ELL_EDL_VALIDATE;