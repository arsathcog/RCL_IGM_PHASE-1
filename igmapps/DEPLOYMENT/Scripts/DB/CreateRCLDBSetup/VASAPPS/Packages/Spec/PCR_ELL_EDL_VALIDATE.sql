create or replace
PACKAGE           "PCR_ELL_EDL_VALIDATE" IS

  -- Author  : Wutiporn Kittitammarak
  -- Created : 04/04/2016 15:28:54
  -- Purpose : EZLL and EZDL validation

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
  004 13/06/17 NIIT               PD_CR_20170609_EZLL_BOOKING_STATUS_VALIDATION
  -----------------------------------------------------------------------------------------------------------*/
  /**
  * @param P_O_ERROR_CODE           Error code mapping with Java Propert File.
  * @param P_I_LOAD_LIST_ID         FK to TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID.
  * @param P_I_USER_ID              Login user ID
  */
  PROCEDURE PRR_ELL_EMS_VALIDATE(P_O_ERROR_CODE   OUT VARCHAR2
                                ,P_I_LOAD_LIST_ID INTEGER
                                ,P_I_USER_ID      VARCHAR2);

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
                                ,P_I_USER_ID           VARCHAR2);

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
  * @param P_I_PCSQ
  * @param P_I_PORT
  * @param P_I_TERMINAL
  */
  PROCEDURE PRR_ELL_ARR_DEP_VALIDATE(P_O_ERROR_CODE OUT VARCHAR2
                                    ,P_I_SERVICE    VARCHAR2
                                    ,P_I_VESSEL     VARCHAR2
                                    ,P_I_VOYAGE     VARCHAR2
                                    ,P_I_PCSQ       NUMBER
                                    ,P_I_PORT       VARCHAR2
                                    ,P_I_TERMINAL   VARCHAR2);

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
  * @param P_I_PCSQ
  * @param P_I_PORT
  * @param P_I_TERMINAL
  */
  PROCEDURE PRR_EDL_ARR_DEP_VALIDATE(P_O_ERROR_CODE OUT VARCHAR2
                                    ,P_I_SERVICE    VARCHAR2
                                    ,P_I_VESSEL     VARCHAR2
                                    ,P_I_VOYAGE     VARCHAR2
                                    ,P_I_PCSQ       NUMBER
                                    ,P_I_PORT       VARCHAR2
                                    ,P_I_TERMINAL   VARCHAR2);

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
                              ,P_I_PCSQ       NUMBER);

 /**
   this procedure will validate if any booking has status as open or waitlisted that have 
   POL service/vesse/voyage/port/terminal  same as  EZLL service/vesse/voyage/port/terminal
  * @param P_SERVICE           
  * @param P_VESSEL               
  * @param P_VOYAGE
  * @param P_PORT
  * @param P_TERMINAL
  * @param P_O_V_ERR_CD        Return error code
  */
  
  PROCEDURE PRE_ELL_STATUS_BKG_VALIDATION(P_SERVICE	   VARCHAR2
                                         ,P_VESSEL	   VARCHAR2
                                         ,P_VOYAGE	   VARCHAR2
                                         ,P_PORT		   VARCHAR2
                                         ,P_TERMINAL	   VARCHAR2
                                         ,P_O_V_ERR_CD  OUT VARCHAR2);
END PCR_ELL_EDL_VALIDATE;
 