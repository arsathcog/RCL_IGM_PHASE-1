--------------------------------------------------------
--  File created - Friday-September-23-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PCE_EUT_COMMON
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "VASAPPS"."PCE_EUT_COMMON" AS
/* -----------------------------------------------------------------------------
System  : RCL-VAS
Module  : Utility
Prog ID : PCE_EUT_COMMON.sql
Name    : Common Utility Package
Purpose : Utility Package to keep all common utility functions/procedures

--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author       Date        What

--------------------------------------------------------------------------------
NTL)AKS      30/10/2009  <Initial version>
--Change Log--------------------------------------------------------------------
DD/MM/YY     User-Task/CR No -Short Description-
16/02/10    NTL)Nihal - Added New Function FN_EUT_GET_USER_ORG_CODE
16/02/10    NTL)Nihal - Added New Function FN_EUT_GET_USER_ORG_TYPE
16/02/10    NTL)Nihal - Added New Function FN_COMMA_SPR
17/02/10    NTL)Nihal - Added New Function FN_WEEK_START_DT
17/02/10    NTL)Nihal - Added New Function FN_WEEK_END_DT
19/02/10    NTL)AKS   - Added New Procedure PRE_EUT_GET_CONFIG
22/02/10    NTL)Nihal - Added New Procedure FN_VESSEL_VOYAGE_FORMAT
25/02/10    NTL)Nihal - Added New Procedure FN_BKG_CUST_NAME
28/05/10    NTL)Guru  - Added New Function FN_EUT_GET_DOC_DUE_DT
03/06/16    RCL)SAISUDA - Add new Procedure PRE_POPULATE_CATEGORY_DESC
                                     - Add new parameter VGM&Category for update table  TOS_LL_BOOKED_LOADING (PRE_UPD_NEXT_POD) >> ref. *01
28/06/16    RCL)SAISUDA - Modify procedure PRE_POPULATE_CATEGORY_DESC for return CATEGORY_CODE is  CONFIG_VALUE and when TSI config to RCL standard, please uncomment in this procedure.   >> ref *02
14/09/16    RCL)THIWAT1 - Added new procedure PROCEDURE PRE_VAL_PLACE_DELIVERY
----------------------------------------------------------------------------- */

/* Company Code of RCL */
G_V_COMPANY_RCL VARCHAR2(4)           := 'RCLL';
/* Application ID of VAS */
G_V_APP_ID VARCHAR2(3)                := 'EZL';

/* SQL Success Code */
G_V_SUCCESS_CD VARCHAR2(10)       := '000000';
/* '-20000' User Error Code to raise app error */
G_V_USER_ERR_CD VARCHAR2(10)      := '-20000';
/* SEPARATOR-1 as '~' BETWEEN ERROR Codes */
G_V_ERR_CD_SEP VARCHAR2(1)        := '~';
/* SEPARATOR-2 as '#' BETWEEN ERROR Datas */
G_V_ERR_DATA_SEP VARCHAR2(1)      := '#';
/* General Data Separator  */
G_V_DATA_SEP VARCHAR2(1)          := '~';
/* Dummy Route Code */
G_V_DUMMY_ROUTE_CD VARCHAR2(1)    := '-';
/* VAS Date Format */
G_V_DATE_FORMAT VARCHAR2(10)      := 'DD/MM/YYYY';
/* VAS Update/Create Date-Time Format */
G_V_DATE_TIME_FORMAT VARCHAR2(20) := 'YYYYMMDDHH24MISS';
/* Screen Record Status - ADD */
G_V_REC_ADD VARCHAR2(3)           := 'ADD';
/* Screen Record Status - UPD */
G_V_REC_UPD VARCHAR2(3)           := 'UPD';
/* Screen Record Status - DEL */
G_V_REC_DEL VARCHAR2(3)           := 'DEL';
/* Total No. of Records per page */
G_V_TOT_REC_PER_PAGE NUMBER       := 10;
/* Total No. of Pages per Time */
G_V_TOT_PAGE_PER_SET NUMBER       := 10;
/* YES */
G_V_YES VARCHAR2(1)               := 'Y';
/* NO */
G_V_NO VARCHAR2(1)                := 'N';
/* Return Error Code/Desc Prefix */
G_V_SQL_ERR_PREFIX VARCHAR2(4)    := 'EZL~';
/* Return Error Code/Desc Postfix */
G_V_SQL_ERR_POSTFIX VARCHAR2(4)   := '~EZL';

/* Value for ACTIVE status combo from screen */
G_V_STATUS_ACTIVE VARCHAR2(1)       := 'A';
/* Value for SUSPENDED status combo from screen */
G_V_STATUS_SUSPEND VARCHAR2(1)      := 'S';
/* Value for ALL selected from status combo from screen */
G_V_STATUS_ALL VARCHAR2(1)          := '0';
/* Value for Entry status of combo from screen */
G_V_STATUS_ENTRY VARCHAR2(1)        := '1';
/* Value for pending approve status of combo from screen */
G_V_STATUS_PENDING_APRV VARCHAR2(1) := '2';
/* Value for Approved status of combo from screen */
G_V_STATUS_APPROVE VARCHAR2(1)      := '3';
/* Value for Confirm status of combo from screen */
G_V_STATUS_CONFIRM VARCHAR2(1)      := '4';
/* Value for Billing status of combo from screen */
G_V_STATUS_BILLING VARCHAR2(1)      := '5';
/* Value for Review status of combo from screen */
G_V_STATUS_REVIEW VARCHAR2(1)       := '6';
/* Value for Cancel status of combo from screen */
G_V_STATUS_CANCEL VARCHAR2(1)       := '7';
/* Value for Pending to Send status of combo from screen */
G_V_STATUS_PENDING_SEND VARCHAR2(1) := '8';
/* Value for Final/Close status of combo from screen */
G_V_STATUS_FINAL VARCHAR2(1)        := '9';
/* Value for reject status of combo from screen */
G_V_STATUS_REJECT VARCHAR2(1)       := 'R';

/* Default Total Record - A Dummy Value */
G_V_DEF_TOT_REC VARCHAR2(2)       := '-1';
/* Dummy Value for All Trade/Region Code */
G_V_ALL_TRADE VARCHAR2(1)         := '*';
/* Dummy Value for All FSC/Agent Code */
G_V_ALL_FSC VARCHAR2(3)           := '***';
/* Regional FSC Code */
G_V_REGIONAL_FSC VARCHAR2(3)      := 'R';

/* Service Category */
G_V_SERVICE_A VARCHAR2(1)         := 'A';
G_V_SERVICE_B VARCHAR2(1)         := 'B';
G_V_SERVICE_C VARCHAR2(1)         := 'C';
/* Service Type : Transport Flag Y=Dolphin , Transport Flag N=VAS*/
G_V_SERVICE_DOLPHIN VARCHAR2(1)   := 'Y';
G_V_SERVICE_VAS VARCHAR2(1)       := 'N';
/* Service Location-Route Type- All Route Type */
G_V_ROUTE_ALL VARCHAR2(1)         := '0';
/* Service Location-Route Type- Single Location */
G_V_ROUTE_1 VARCHAR2(1)           := '1';
/* Service Location-Route Type- Two Locations (From-To) */
G_V_ROUTE_2 VARCHAR2(1)           := '2';
/* Service Location-Route Type- Multi Locations (Via-Points) */
G_V_ROUTE_3 VARCHAR2(1)           := '3';

/* Wild Card Option - None */
G_V_WILD_CARD_ALL VARCHAR2(1)     := '0';
/* Wild Card Option - Starts With */
G_V_WILD_CARD_STARTS VARCHAR2(1)  := '1';
/* Wild Card Option - Ends With */
G_V_WILD_CARD_ENDS VARCHAR2(1)    := '2';
/* Wild Card Option - Contains */
G_V_WILD_CARD_CONTAINS VARCHAR2(1):= '3';

/* Business Object Codes */
G_V_BUS_OBJ_CD_FSC VARCHAR2(3)        := 'FSC';
G_V_BUS_OBJ_CD_CONTRACT VARCHAR2(3)   := 'VCT';
G_V_BUS_OBJ_CD_QUOTATION VARCHAR2(3)  := 'VQT';
G_V_BUS_OBJ_CD_BOOKING VARCHAR2(3)    := 'VBK';
G_V_BUS_OBJ_CD_JOB_ORDER VARCHAR2(3)  := 'VJO';
G_V_BUS_OBJ_CD_TRACK_TRACE VARCHAR2(3):= 'VTT';
G_V_BUS_OBJ_CD_REPORTS VARCHAR2(3)    := 'VRP';

/* Document Types */
G_V_DOC_TYPE_ALL VARCHAR2(1)          := '0';
G_V_DOC_TYPE_EXPORT VARCHAR2(1)       := 'E';
G_V_DOC_TYPE_IMPORT VARCHAR2(1)       := 'I';
G_V_DOC_TYPE_DOMESTIC VARCHAR2(1)     := 'D';
G_V_DOC_TYPE_CROSS_BORDER VARCHAR2(1) := 'C';

/* Config Types */
G_V_REC_STATUS VARCHAR2(50)           := 'REC_STATUS';
G_V_DOC_STATUS VARCHAR2(50)           := 'DOC_STATUS';
G_V_DOC_TYPE VARCHAR2(50)             := 'DOC_TYPE';
G_V_WILD_CARD VARCHAR2(50)            := 'WILD_CARD';
G_V_LOC_TYPE VARCHAR2(50)             := 'LOC_TYPE';
G_V_TPT_MODE VARCHAR2(50)             := 'TPT_MODE';
G_V_SHIPPING_TERM VARCHAR2(50)        := 'SHIPPING_TERM';
G_V_PAYMENT_TERM VARCHAR2(50)         := 'PAYMENT_TERM';
G_V_INCO_TERM VARCHAR2(50)            := 'INCO_TERM';
G_V_CUSTOMER_TYPE VARCHAR2(50)        := 'CUSTOMER_TYPE';

/* Master IDs */
G_V_ID_CONTRACT VARCHAR2(50)          := 'CONTRACT';
G_V_ID_QUOTATION VARCHAR2(50)         := 'QUOTATION';
G_V_ID_BOOKING VARCHAR2(50)           := 'BOOKING';
G_V_ID_JOB_ORDER VARCHAR2(50)         := 'JOB_ORDER';
G_V_ID_VENDOR VARCHAR2(50)            := 'VENDOR';
G_V_ID_CUSTOMER VARCHAR2(50)          := 'CUSTOMER';
G_V_ID_FSC VARCHAR2(50)               := 'FSC';
G_V_ID_SERVICE VARCHAR2(50)           := 'SERVICE';
G_V_ID_SHIP_TERM VARCHAR2(50)         := 'SHIP_TERM';
G_V_ID_LOC_TYPE VARCHAR2(50)          := 'LOC_TYPE';
G_V_ID_LOCATION VARCHAR2(50)          := 'LOCATION';
G_V_ID_UOM VARCHAR2(50)               := 'UOM';
G_V_ID_CHRG_BASIS_TYPE VARCHAR2(50)   := 'CHRG_BASIS_TYPE';
G_V_ID_CURRENCY VARCHAR2(50)          := 'CURRENCY';
G_V_ID_COMODITY_GROUP VARCHAR2(50)    := 'COMODITY_GROUP';
G_V_ID_COMODITY VARCHAR2(50)          := 'COMODITY';
G_V_ID_PRINT_ID VARCHAR2(50)          := 'PRINT_ID';
G_V_ID_COUNTRY VARCHAR2(50)           := 'COUNTRY';
G_V_ID_CATEGORY VARCHAR2(50)          := 'CATEGORY';
G_V_ID_PRODUCT VARCHAR2(50)           := 'PRODUCT';
G_V_ID_DOC_TYPE VARCHAR2(50)          := 'DOC_TYPE';
G_V_ID_REASON VARCHAR2(50)            := 'REASON';
G_V_ID_PACK_TYPE VARCHAR2(50)         := 'PACK_TYPE';
G_V_ID_SHIPPING_TERM VARCHAR2(50)     := 'SHIPPING_TERM';
G_V_ID_PAYMENT_TERM VARCHAR2(50)      := 'PAYMENT_TERM';
G_V_ID_INCO_TERM VARCHAR2(50)         := 'INCO_TERM';
G_V_ID_EVENT VARCHAR2(50)             := 'EVENT';

/* Config Types */
G_V_DL_LCS_BOOK            VARCHAR2(50)    :=      'DL_LCS_BOOK';
G_V_DL_MS_OVLD             VARCHAR2(50)    :=      'DL_MS_OVLD';
G_V_DL_LC_BOOK             VARCHAR2(50)    :=      'DL_LC_BOOK';
G_V_DL_DMG_OVLD            VARCHAR2(50)    :=      'DL_DMG_OVLD';
G_V_DL_SW_BOOK             VARCHAR2(50)    :=      'DL_SW_BOOK';
G_V_DL_TCPOD_BOOK          VARCHAR2(50)    :=      'DL_TCPOD_BOOK';
G_V_DL_U_BOOK              VARCHAR2(50)    :=      'DL_U_BOOK';
G_V_DL_FUM_BOOK            VARCHAR2(50)    :=      'DL_FUM_BOOK';
G_V_DL_SZ_OVLD             VARCHAR2(50)    :=      'DL_SZ_OVLD';
G_V_DL_MT_OVLD             VARCHAR2(50)    :=      'DL_MT_OVLD';
G_V_DL_BTYP_OVLD           VARCHAR2(50)    :=      'DL_BTYP_OVLD';
G_V_DL_OC_OVLD             VARCHAR2(50)    :=      'DL_OC_OVLD';
G_V_DL_PODSTS_OVLD         VARCHAR2(50)    :=      'DL_PODSTS_OVLD';
G_V_DL_SPL_HAND_OVLD       VARCHAR2(50)    :=      'DL_SPL_HAND_OVLD';
G_V_DL_RS_OVLD             VARCHAR2(50)    :=      'DL_RS_OVLD';
G_V_DL_RESTS_RESTW         VARCHAR2(50)    :=      'DL_RESTS_RESTW';
G_V_DL_DIS_BOOK            VARCHAR2(50)    :=      'DL_DIS_BOOK';
G_V_DL_DISTS_OVLD          VARCHAR2(50)    :=      'DL_DISTS_OVLD';
G_V_DL_IN_BOOK             VARCHAR2(50)    :=      'DL_IN_BOOK';
G_V_DL_OR_BOOK             VARCHAR2(50)    :=      'DL_OR_BOOK';
G_V_DL_IN_OVLD             VARCHAR2(50)    :=      'DL_IN_OVLD';
G_V_DL_OR_OVLD             VARCHAR2(50)    :=      'DL_OR_OVLD';
G_V_DL_IN_RESTWD           VARCHAR2(50)    :=      'DL_IN_RESTWD';
G_V_DL_OR_RESTWD           VARCHAR2(50)    :=      'DL_OR_RESTWD';
G_V_DL_STS                 VARCHAR2(50)    :=      'DL_STS';

/* for load list combos */
G_V_LL_LLS                 VARCHAR2(50)    :=      'LL_LLS';
G_V_LL_LDS_BOOK            VARCHAR2(50)    :=      'LL_LDS_BOOK';
G_V_LL_IN_BOOK             VARCHAR2(50)    :=      'LL_IN_BOOK';
G_V_LL_OR_BOOK             VARCHAR2(50)    :=      'LL_OR_BOOK';
G_V_LL_SOR_BOOK            VARCHAR2(50)    :=      'LL_SOR_BOOK';
G_V_LL_IN_OVLD             VARCHAR2(50)    :=      'LL_IN_OVLD';
G_V_LL_LDSTS_OVSP          VARCHAR2(50)    :=      'LL_LDSTS_OVSP';
G_V_LL_OR_OVSP             VARCHAR2(50)    :=      'LL_OR_OVSP';
G_V_LL_IN_RESTWD           VARCHAR2(50)    :=      'LL_IN_RESTWD';
G_V_LL_OR_RESTWD           VARCHAR2(50)    :=      'LL_OR_RESTWD';


/* Dummy Gargin Percentage for Operator */
G_N_DUMMY_MARGIN_PERC NUMBER          := 99999;
/* ROE CODE PATTERN */
G_V_DAILYROE_PATTERN  VARCHAR2(20)    := 'DAILYROE';

/* Laden/Empty Values*/
G_V_TYPE_EMPTY VARCHAR2(1)            := ' ';
G_V_TYPE_LADEN VARCHAR2(1)            := 'L';

/* LCL/FCL Values*/
G_V_TYPE_LCL VARCHAR2(3)              := 'LCL';
G_V_TYPE_FCL VARCHAR2(3)              := 'FCL';

/* Document/Service Status*/
G_V_STS_HIT        VARCHAR2(1)        := 'H';
G_V_STS_MISS       VARCHAR2(1)        := 'M';
G_V_STS_INCOMPLETE VARCHAR2(1)        := 'I';
G_V_STS_NA         VARCHAR2(1)        := 'N';

/* Internal User Organization Type Value */
G_V_ORG_TYP_INTERNAL VARCHAR2(2)      := 'I';

/* Report Display Date Format */
G_V_DISPLAY_DATE_FORMAT VARCHAR2(10)  := 'DD/MM/YYYY';
/* Report Display Time Format */
G_V_DISPLAY_TIME_FORMAT VARCHAR2(7)   := 'HH24:MI';
/* Report Display Week Format */
G_V_DISPLAY_WEEK_FORMAT VARCHAR2(2)   := 'W';

/* View Default Flag Active*/
G_V_DEFAULT_YES VARCHAR2(1)           := 'Y';
G_V_DEFAULT_NO  VARCHAR2(1)           := 'N';

/* View Type Global*/
G_V_GLOBAL_VIEW VARCHAR2(1)           := 'G';
G_V_DEFAULT_VIEW VARCHAR2(1)          := 'D';
G_V_USER_VIEW    VARCHAR2(1)          := 'U';
G_V_FSC_VIEW     VARCHAR2(1)          := 'F';

/* Start - Common Error Codes */
/* Database error occurred */
G_V_GE0001 VARCHAR2(10)           := 'ECM.GE0001';
/* Record locked by another user */
G_V_GE0002 VARCHAR2(10)           := 'ECM.GE0002';
/* Divide by zero occurred */
G_V_GE0003 VARCHAR2(10)           := 'ECM.GE0003';
/* No Record Found */
G_V_GE0004 VARCHAR2(10)           := 'ECM.GE0004';
/* Record delete by another user */
G_V_GE0005 VARCHAR2(10)           := 'ECM.GE0005';
/* Record updated by another user */
G_V_GE0006 VARCHAR2(10)           := 'ECM.GE0006';
/* Please select a row */
G_V_GE0007 VARCHAR2(10)           := 'ECM.GE0007';
/* View Name already exists*/
G_V_GE0024 VARCHAR2(10)           := 'ECM.GE0024';
/* Record already exists*/
G_V_GE0025 VARCHAR2(10)           := 'ECM.GE0025';
/* End - Common Error Codes */

/**
 * @ FN_EUT_GEN_VAS_ERROR
 * Purpose : Generates VAS SQL Error by prefixing 'VAS~' and postfixing '~VAS'
 *           to the original error message
 * @param  : p_i_v_error (Original Error)
 * @return Returns the Error message surrouded with VAS tags
 * @see   None
 * @exception None
 * -----------------------------------------------------------------------------
 * Steps/Checks involved :
 * Check A : None
 * -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GEN_VAS_ERROR(p_i_v_error VARCHAR2)
RETURN VARCHAR2;

FUNCTION FN_CHECK_COC_FLAG ( p_i_v_equ_no        VARCHAR2
                            , p_i_v_port          VARCHAR2
                            , p_i_v_etd_date      VARCHAR2
                            , p_i_v_etd_time      VARCHAR2
                            , p_o_v_err_cd        OUT VARCHAR2
                            )
RETURN BOOLEAN;

/**
 * @ FN_EUT_GET_EXCH_RATE
 * Purpose : Calculates the Exchange Rate from Exchange Rate Master
 *           based on passed parameter (FSC and Currency-From-To)
 * @param  : p_i_fsc_cd
 * @param  : p_i_business_object_cd (VCT/VQT/VBK/VJO)
 * @param  : p_i_refeence_no        (Contract/Quotation/Booking/JobOrder No)
 * @param  : p_i_from_curr
 * @param  : p_i_to_curr
 * @param  : p_i_exch_dt
 * @return Returns the calcualted Exchange Rate. '0' Incase of No Exchange Rate
 * @see   None
 * @exception None
 * -----------------------------------------------------------------------------
 * Steps/Checks involved :
 * Step A : Get the Exchange Rate Rule based on fsc and p_i_business_object_cd
 * Step B : Get the Date for Exchange Rate based on rule and reference No
 *           from Respective HDR Table.
 * Step C : Get ROE Code based on FSC
 * Step D : Get Exchange Rate finally from RATE_OF_EXCHANGE Table
 * -----------------------------------------------------------------------------
*/
/* Rajeev
FUNCTION FN_EUT_GET_EXCH_RATE(
                   p_i_fsc_cd               VARCHAR2
                  ,p_i_business_object_cd   VARCHAR2
                  ,p_i_refeence_no          VARCHAR2
                  ,p_i_from_curr            VARCHAR2
                  ,p_i_to_curr              VARCHAR2
                  ,p_i_exch_dt              VARCHAR2
                )
RETURN NUMBER;
*/
/**
 * @ FN_EUT_GET_FSC_ADDRESS
 * Purpose : Gets FSC Address based on FSC Code
* @param  : p_i_business_object_cd (FSC/VCT/VQT/VBK/VJO)
* @param  : p_i_refeence_no        (FSC_CD/Contract/Quotation/Booking/JobOrder No)
* @return Returns the FSC Address In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_FSC_ADDRESS(
                   p_i_business_object_cd   VARCHAR2
                  ,p_i_refeence_no          VARCHAR2
                )
RETURN PCE_ECM_REF_CUR.FSC_REF_CUR;

/**
* @ PRE_EUT_GET_SERVICES
* Purpose : Retrieves Service Master List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Services Master List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_SERVICES(
                              p_o_refServieList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                              ,p_o_v_error      OUT VARCHAR2
                              );
*/

/**
* @ PRE_EUT_GET_LOC_TYPES
* Purpose : Retrieves Location Type List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Location Type List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_LOC_TYPES(
                                p_o_refLocTypeList  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_o_v_error        OUT VARCHAR2
                               );
*/
/**
* @ PRE_EUT_GET_CHRG_BASIS_TYPE
* Purpose : Retrieves Charge Basis Type List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Charge Basis Type List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_CHRG_BASIS_TYPE(
                                      p_o_refChrgbasisTypeList  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                      ,p_o_v_error              OUT VARCHAR2
                                     );
*/
/**
* @ PRE_EUT_GET_UOM
* Purpose : Retrieves UOM List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the UOM List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_UOM(
                          p_o_refUomList  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                          ,p_o_v_error    OUT VARCHAR2
                         );
*/
/**
* @ PRE_EUT_GET_CURRENCY
* Purpose : Retrieves Currency List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Currency List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_CURRENCY (
                                p_o_refCurrencyList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_o_v_error        OUT VARCHAR2
                               );
*/
/**
* @ FN_STR_2_TBL
* Purpose : Converts a String of values separated by a seperator to Array
* @param  : Original String value
* @param  : Separator
* @return Returns the Array of values in Table Data Type
* @see   Usage:
  v_tabContractId PCE_ECM_REF_CUR.TAB_STR_2_ARR;
  v_tabContractId := PCE_EUT_COMMON.FN_STR_2_TBL(p_i_v_contract_id, '~');
  FOR l_n_row IN 1 .. v_tabContractId.count LOOP
    ' ACCESS VALUE USING v_tabContractId(l_n_row)...
  END LOOP;
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_STR_2_TBL (
                         p_i_v_str VARCHAR2
                        ,p_i_v_separator VARCHAR2
                      )
RETURN PCE_ECM_REF_CUR.TAB_STR_2_ARR;

/**
* @ FN_STR_2_TBL
* Purpose : Converts a String of values separated by a seperator to TABLE
* @param  : Original String value
* @param  : Separator
* @param  : Type - A Dummy, can pass anything here
* @return Returns the values in Table Data Type
* @see   Usage:
  CURSOR CUR_1 IS
      SELECT DATA_VAL
      FROM THE (
                SELECT CAST( PCE_EUT_COMMON.FN_STR_2_TBL(p_string, '~',NULL) AS GEN_STR_TBL_TAB )
                FROM   DUAL
                );
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_STR_2_TBL (
                         p_i_v_str VARCHAR2
                        ,p_i_v_separator VARCHAR2
                        ,p_i_v_type VARCHAR2
                      )
RETURN GEN_STR_TBL_TAB;

/**
* @ FN_EUT_GET_USER_FSC
* Purpose : Retrieves User FSc Code for User Master
* @param  : p_i_v_user_id
* @return string : User Fsc Code
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_USER_FSC (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2;

/**
* @ FN_EUT_GET_USER_NM
* Purpose : Retrieves User Name for User Master
* @param  : p_i_v_user_id
* @return string : User Name
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_USER_NM (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2;

/**
* @ FN_EUT_GET_FSC_LEVEL_ACCESS
* Purpose : Retrieves User FSC Data Access Levels (Line/Trade/Agent)
* @param  : p_i_v_user_id
* @return string :  Line, Trade and Agent separated by '/' separator
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_FSC_LEVEL_ACCESS (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2;

/**
* @ FN_EUT_GET_ACCESS_LEVEL_LINE
* Purpose : Retrieves Line code from FSC Data Access Levels (Line/Trade/Agent)
* @param  : p_i_v_user_id
* @return string :  Line Code
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_ACCESS_LEVEL_LINE (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2;

/**
* @ FN_EUT_GET_ACCESS_LEVEL_TRADE
* Purpose : Retrieves Trade code from FSC Data Access Levels (Line/Trade/Agent)
* @param  : p_i_v_user_id
* @return string :  Trade Code
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_ACCESS_LEVEL_TRADE (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2;


/**
* @ FN_EUT_GET_ACCESS_LEVEL_AGENT
* Purpose : Retrieves Agent code from FSC Data Access Levels (Line/Trade/Agent)
* @param  : p_i_v_user_id
* @return string :  Agent Code
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_ACCESS_LEVEL_AGENT (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2;

/**
* @ FN_EUT_GET_USER_ORG_CODE
* Purpose : Retrieves User Organization Code for User Master
* @param  : p_i_v_user_id
* @return string : User ORG Code
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_USER_ORG_CODE (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2;

/**
* @ FN_EUT_GET_USER_ORG_TYPE
* Purpose : Retrieves User Organization Type for User Master
* @param  : p_i_v_user_id
* @return string : User Org Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_USER_ORG_TYPE (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2;

/**
* @ PRE_EUT_GET_UAB
* Purpose : Retrieves User Profile from Dolphin User master
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_i_v_user_id
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the UAB DETAILS In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
PROCEDURE PRE_EUT_GET_UAB(
                          p_o_refUAB      OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                          ,p_i_v_user_id  IN  VARCHAR2
                          ,p_o_v_error    OUT VARCHAR2
                         );
/**
* @ PRE_EUT_GET_AUTH_LIST
* Purpose : Retrieves User's Authorization Matrix from Dolphin Role-prog master
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_i_v_user_id
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the User's Authorization Matrix In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
PROCEDURE PRE_EUT_GET_AUTH_LIST(
                                p_o_refAuthList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_i_v_user_id  IN  VARCHAR2
                                ,p_o_v_error    OUT VARCHAR2
                               );

/**
 * @ FN_EUT_GET_FSC_CURRENCY
 * Purpose : Gets FSC Currency on FSC Code
* @param  : p_i_fsc_cd
* @return Returns the FSC Currency
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_FSC_CURRENCY(
                   p_i_fsc_cd VARCHAR2
                )
RETURN VARCHAR2;


/**
* @ PRE_EUT_GET_MASTER_DTL
* Purpose : Retrieves Master Code Details
* @param  : p_i_mst_id - Master ID
* @param  : p_i_mst_cd - Master Code
* @param  : p_o_mst_values - Values of the Master Code separated by tilde
* @param  : p_o_v_error RETURN ERROR CODE
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_MASTER_DTL(
                                  p_i_mst_id      IN VARCHAR2
                                  ,p_i_mst_code   IN VARCHAR2
                                  ,p_o_mst_values OUT VARCHAR2
                                  ,p_o_v_error    OUT VARCHAR2
                                );
*/
/**
 * @ FN_EUT_GET_WEEK_NO
 * Purpose : Gets Weekk No of the Year
* @param  : p_i_d_date
* @return Returns the Week No of year from 1-52
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_WEEK_NO(
                            p_i_d_date DATE
                           )
RETURN NUMBER;

/**
* @ FN_WEEK_START_DT
* Purpose : Gets First Date of Week
* @param  : p_i_n_week_no
*           p_i_n_year
* @return Returns the first date of Passed week and year
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_WEEK_START_DT(
                            p_i_n_week_no NUMBER
                           ,p_i_n_year    NUMBER
                          )
RETURN DATE;

/**
* @ FN_WEEK_END_DT
* Purpose : Gets Last Date of Week
* @param  : p_i_n_week_no
*           p_i_n_year
* @return Returns the Last date of Passed week and year
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_WEEK_END_DT(
                           p_i_n_week_no NUMBER
                          ,p_i_n_year    NUMBER
                        )
RETURN DATE;



/**
 * @ FN_EUT_GET_TEU
 * Purpose : calculates total TEU
* @param  : p_i_v_equipment_size
* @return Returns total TEUs
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_TEU(
                        p_i_v_equipment_size VARCHAR2
                       )
RETURN NUMBER;

/**
 * @ FN_EUT_GET_ATTCHMENT_DIR
 * Purpose : Returns Common Attachment Dir Base Path
* @param  : None
* @return Returns Common Attachment Dir Base Path
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_ATTCHMENT_DIR
RETURN VARCHAR2;

/**
 * @ FN_EUT_GET_CODA_DIR
 * Purpose : Returns CODA FILE Dir Base Path
* @param  : None
* @return Returns CODA FILE Dir Base Path
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
FUNCTION FN_EUT_GET_CODA_DIR
RETURN VARCHAR2;
*/
/**
 * @ FN_EUT_GET_DOWNLOAD_DIR
 * Purpose : Returns TEMP DOWNLOAD Dir Base Path
* @param  : None
* @return Returns TEMP DOWNLOAD Dir Base Path
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_DOWNLOAD_DIR
RETURN VARCHAR2;

/**
 * @ FN_EUT_GET_UPLOAD_DIR
 * Purpose : Returns TEMP UPLOAD Dir Base Path
* @param  : None
* @return Returns TEMP UPLOAD Dir Base Path
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_UPLOAD_DIR
RETURN VARCHAR2;


/**
 * @ FN_EUT_IS_NUMBER
 * Purpose : Checks if the value passed is a number or not
* @param  : p_i_v_value
* @return boolean (true:Number  false:Non-Numeric)
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_IS_NUMBER (p_i_v_value VARCHAR2)
RETURN BOOLEAN;

/**
 * @ FN_EUT_IS_VALID_DT_TM
 * Purpose : Checks if the value passed is a valid date or time
* @param  : p_i_v_value (date/time value to be checked)
* @param  : p_i_v_format (date/time format to be checked)
* @return boolean (true:valid  false:invalid)
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_IS_VALID_DT_TM (p_i_v_value VARCHAR2, p_i_v_format VARCHAR2)
RETURN BOOLEAN;

/**
 * @ FN_EUT_GET_QUOTATION_MARGIN
 * Purpose : Fetches Quotation Margin from vas margin master
* @param  : p_i_v_user_id
* @param  : p_i_v_service_cd
* @return number (margin in %)
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
FUNCTION FN_EUT_GET_QUOTATION_MARGIN (
                                        p_i_v_user_id VARCHAR2
                                        ,p_i_v_service_cd VARCHAR2
                                     )
RETURN NUMBER;
*/
/**
 * @ PRE_EUT_NOTIFY_USER
 * Purpose : Calls RCL/Dolphin Notification Function
* @param  :  p_i_v_prog_id
* @param  : p_i_v_user_id
* @param  : p_i_v_notify_cat :Folloing 3 values
            Submit = G_V_STATUS_PENDING_APRV
            Approved=G_V_STATUS_APPROVE
            Rejected=G_V_STATUS_REJECT
* @param  : p_i_business_object_cd
* @param  : p_i_refeence_no
* @oaram  : p_o_v_error
* @return none
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
PROCEDURE PRE_EUT_NOTIFY_USER (
                                 p_i_v_prog_id VARCHAR2
                                ,p_i_v_user_id VARCHAR2
                                ,p_i_v_notify_cat VARCHAR2
                                ,p_i_business_object_cd VARCHAR2
                                ,p_i_refeence_no VARCHAR2
                                ,p_o_v_error OUT VARCHAR2
                              );

/**
* @ PRE_EUT_GET_SHIPPING_TERM
* Purpose : Retrieves Shipping Term List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Shipping Term List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
PROCEDURE PRE_EUT_GET_SHIPPING_TERM (
                                    p_o_refShippingTermList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_error            OUT VARCHAR2
                                   );

/**
* @ PRE_EUT_GET_PAYMENT_TERM
* Purpose : Retrieves Payment Term List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Payment Term List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_PAYMENT_TERM (
                                    p_o_refPaymentTermList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_error            OUT VARCHAR2
                                   );
*/
/**
* @ PRE_EUT_GET_INCO_TERM
* Purpose : Retrieves Inco Term List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Inco Term List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_INCO_TERM (
                                    p_o_refIncoTermList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_error            OUT VARCHAR2
                                   );
*/
/**
* @ PRE_EUT_GET_CUST_TYPE
* Purpose : Retrieves Customer Type List for combo box
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Customer Type List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
PROCEDURE PRE_EUT_GET_CUST_TYPE (
                                    p_o_refCustTypeList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_error            OUT VARCHAR2
                                   );
*/
/**
* @ FN_COMMA_SPR
* Purpose : This Function returns the one long string with the values
*           seprated by given seprator parameter, from the given
*           table and field name on the given where parameters.
* @param  : p_i_v_tab_nm
            p_i_v_fld_nm
            p_i_v_whr
            p_i_v_separator
* @return : Returns long string comma seprated
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/

FUNCTION  FN_COMMA_SPR (
                          p_i_v_tab_nm    VARCHAR2
                         ,p_i_v_fld_nm    VARCHAR2
                         ,p_i_v_whr       VARCHAR2
                         ,p_i_v_separator VARCHAR2
                         )
RETURN VARCHAR2 ;

/**
* @ PRE_EUT_GET_CONFIG
* Purpose : Retrieves Config Master Details
* @param  : PCE_ECM_REF_CUR.ECM_REF_CUR
* @param  : p_o_v_error RETURN ERROR CODE
* @return Returns the Config Master List In Oracle Ref User Data Type
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
PROCEDURE PRE_EUT_GET_CONFIG (
                                 p_o_refConfigList   OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_o_v_error         OUT VARCHAR2
                              );

/**
* @ FN_VESSEL_VOYAGE_FORMAT
* Purpose : This Function returns the one string with the values
*           seprated by " "(space) between Vessel and Voyage fields
*           and use "/"(slash) between Vessel+Voyage 1  and Vessel+Voyage 2
* @param  : p_i_v_vessel_1
            p_i_v_voyage_1
            p_i_v_vessel_2
            p_i_v_voyage_2
* @return : Returns long string
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION  FN_VESSEL_VOYAGE_FORMAT (
                                     p_i_v_vessel_1 VARCHAR2
                                    ,p_i_v_voyage_1 VARCHAR2
                                    ,p_i_v_vessel_2 VARCHAR2
                                    ,p_i_v_voyage_2 VARCHAR2
                                   )
RETURN VARCHAR2 ;

/**
 * @ FN_EUT_CHECK_MASTER
 * Purpose : Checks if the master code is valid or not
* @param  : p_i_mst_id
* @param  : p_i_mst_code
* @param  : p_i_rec_status
* @return boolean (true:Present in Master false:Invalid Code)
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_CHECK_MASTER(
                              p_i_mst_id      IN VARCHAR2
                              ,p_i_mst_code   IN VARCHAR2
                              ,p_i_rec_status IN VARCHAR2
                            )
RETURN BOOLEAN;

/**
 * @ FN_EUT_CHECK_PRODUCT_CD
 * Purpose : Checks if the product code is valid or not
* @param  : p_i_product_cd
* @param  : p_i_cust_cd
* @return boolean (true:Present in Master false:Invalid Code)
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
FUNCTION FN_EUT_CHECK_PRODUCT_CD(
                                  p_i_product_cd IN VARCHAR2
                                  ,p_i_cust_cd   IN VARCHAR2
                                )
RETURN BOOLEAN;
*/
/**
 * @ FN_EUT_CHECK_COMODITY
 * Purpose : Checks if the comodity code is valid or not
* @param  : p_i_comodity_grp
* @param  : p_i_comodity
* @param  : p_i_rec_status
* @return boolean (true:Present in Master false:Invalid Code)
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
FUNCTION FN_EUT_CHECK_COMODITY(
                                p_i_comodity_grp IN VARCHAR2
                                ,p_i_comodity    IN VARCHAR2
                                ,p_i_rec_status  IN VARCHAR2
                              )
RETURN BOOLEAN;
*/
/**
* @ FN_BKG_CUST_NAME
* Purpose : to return the customer name
* @param  : p_i_v_bkg_id
* @param  : p_i_v_cust_typ
* @return customer name
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
FUNCTION FN_BKG_CUST_NAME(
                            p_i_v_bkg_id      IN VARCHAR2
                           ,p_i_v_cust_typ    IN VARCHAR2
                         )
RETURN VARCHAR2;
*/
/**
* @ FN_EUT_VALID_WEEK
* Purpose : Checks valid week no for a year
* @param  : p_i_n_year
* @param  : p_i_n_wk_no
* @return true/false
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_VALID_WEEK (p_i_n_year NUMBER, p_i_n_wk_no NUMBER)
RETURN BOOLEAN;

/**
* @ FN_EUT_LOC_NAME
* Purpose : to return the location name
* @param  : p_i_v_loc_type
* @param  : p_i_v_loc_cd
* @return location name
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
FUNCTION FN_EUT_LOC_NAME(
                            p_i_v_loc_type      IN VARCHAR2
                           ,p_i_v_loc_cd        IN VARCHAR2
                         )
RETURN VARCHAR2;
*/
/**
* @ FN_EUT_GET_ORG_NM
* Purpose : to return the Organization name
* @param  : p_i_v_org_code
* @return Organization Name
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
FUNCTION FN_EUT_GET_ORG_NM(p_i_v_org_code IN VARCHAR2)
RETURN VARCHAR2;

FUNCTION FN_GET_PORT_LIST (p_i_v_user_id  VARCHAR2,p_i_v_is_control_fsc VARCHAR2,p_i_port_id VARCHAR2)
RETURN VARCHAR2;

PROCEDURE PRE_EUT_IS_CONTROL_FSC(
                                p_o_v_is_control_fsc OUT VARCHAR2
                                ,p_i_v_user_fsc      IN  VARCHAR2
                                ,p_o_v_error         OUT VARCHAR2
                               );

/**
* @ PRE_EUT_GET_ORG_NM
* Purpose : Retrieves Organization Name
* @param  : p_i_v_org_code
* @param  : p_o_v_org_name
* @return Returns the Organization Name
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
PROCEDURE PRE_EUT_GET_ORG_NM (
                               p_i_v_org_code   IN VARCHAR2
                              ,p_o_v_org_name   OUT VARCHAR2
                              );


/**
* @ FN_EUT_GET_DOC_DUE_DT
* Purpose : to return the Documnet due date
* @param  : p_i_v_doc_type
* @param  : p_i_v_bk_party_cd
* @param  : p_i_v_org_cntry_cd
* @param  : p_i_v_ETD1
* @return Documnet due date
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
/* Rajeev
FUNCTION FN_EUT_GET_DOC_DUE_DT(
                            p_i_v_doc_type      IN VARCHAR2
                           ,p_i_v_bk_party_cd   IN VARCHAR2
                           ,p_i_v_org_cntry_cd  IN VARCHAR2
                           ,p_i_v_ETD1          IN VARCHAR2
                         )
RETURN VARCHAR2;
*/

/* Start Addition for Save Settings */

     PROCEDURE PRE_GET_USER_APPLICABLE_VIEWS( p_o_ref_screen_views OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
                                             ,p_i_v_screen_id                  VARCHAR2
                                             ,p_i_v_user_id                    VARCHAR2
                                             ,p_i_v_fsc_id                     VARCHAR2
                                             ,p_o_v_error          OUT  NOCOPY VARCHAR2
                                            );


    PROCEDURE PRE_GET_SELECTED_VIEW(  p_i_v_screen_id              VARCHAR2
                                    , p_i_v_user_id                VARCHAR2
                                    , p_i_v_fsc_id                 VARCHAR2
                                    , p_o_v_view_id     OUT NOCOPY VARCHAR2
                                    , p_o_v_error       OUT NOCOPY VARCHAR2
                                   );


    PROCEDURE PRE_GET_SEARCH_VALUES(  p_o_ref_search_on OUT        PCE_ECM_REF_CUR.ECM_REF_CUR
                                    , p_i_v_view_id                VARCHAR2
                                    , p_o_v_error       OUT NOCOPY VARCHAR2
                                   );


    PROCEDURE PRE_GET_GRID_COLUMN_DEFINATION(  p_o_ref_col_def OUT        PCE_ECM_REF_CUR.ECM_REF_CUR
                                             , p_i_v_view_id              VARCHAR2
                                             , p_o_v_error     OUT NOCOPY VARCHAR2
                                            );


    PROCEDURE PRE_GET_SYSDATE(  p_o_v_sysdate    OUT NOCOPY    VARCHAR2
                              , p_o_v_error      OUT NOCOPY    VARCHAR2
                              );


    PROCEDURE PRE_INS_USER_VIEW_SETTINGS(  p_i_v_view_name                  VARCHAR2
                                         , p_i_v_screen_id                  VARCHAR2
                                         , p_i_v_view_type                  VARCHAR2
                                         , p_i_v_user_id                    VARCHAR2
                                         , p_i_v_fsc_id                     VARCHAR2
                                         , p_i_v_default_flag               VARCHAR2
                                         , p_i_v_record_status              VARCHAR2
                                         , p_i_v_record_add_user            VARCHAR2
                                         , p_i_v_record_add_date            VARCHAR2
                                         , p_o_v_view_id        OUT NOCOPY  VARCHAR2
                                         , p_o_v_error          OUT NOCOPY  VARCHAR2
                                        );


    PROCEDURE PRE_INS_GRID_COLUMN_DEFINATION(  p_i_v_view_id                        VARCHAR2
                                             , p_i_v_screen_id                      VARCHAR2
                                             , p_i_v_column_id                      VARCHAR2
                                             , p_i_v_column_seq                     VARCHAR2
                                             , p_i_v_display_flag                   VARCHAR2
                                             , p_i_v_display_width                  VARCHAR2
                                             , p_i_v_record_status                  VARCHAR2
                                             , p_i_v_record_add_user                VARCHAR2
                                             , p_i_v_record_add_date                VARCHAR2
                                             , p_o_v_error              OUT NOCOPY  VARCHAR2
                                            );


    PROCEDURE PRE_INS_SEARCH_CRITERIA(  p_i_v_view_id                       VARCHAR2
                                      , p_i_v_component_id                  VARCHAR2
                                      , p_i_v_component_value               VARCHAR2
                                      , p_i_v_record_status                 VARCHAR2
                                      , p_i_v_record_add_user               VARCHAR2
                                      , p_i_v_record_add_date               VARCHAR2
                                      , p_o_v_error            OUT NOCOPY   VARCHAR2
                                   );


    PROCEDURE PRE_UPD_GRID_COLUMN_DEFINATION(  p_i_v_view_id                        VARCHAR2
                                             , p_i_v_screen_id                      VARCHAR2
                                             , p_i_v_column_id                      VARCHAR2
                                             , p_i_v_column_seq                     VARCHAR2
                                             , p_i_v_display_flag                   VARCHAR2
                                             , p_i_v_display_width                  VARCHAR2
                                             , p_i_v_record_change_user             VARCHAR2
                                             , p_i_v_record_change_date             VARCHAR2
                                             , p_o_v_error               OUT NOCOPY VARCHAR2
                                            );


    PROCEDURE PRE_UPD_USER_VIEW_SETTINGS(  p_i_v_view_id                            VARCHAR2
                                         , p_i_v_view_type                          VARCHAR2
                                         , p_i_v_screen_id                          VARCHAR2
                                         , p_i_v_fsc_id                             VARCHAR2
                                         , p_i_v_record_change_user                 VARCHAR2
                                         , p_i_v_record_change_date                 VARCHAR2
                                         , p_o_v_error              OUT NOCOPY      VARCHAR2
                                        );


    PROCEDURE PRE_UPD_SEARCH_CRITERIA(  p_i_v_view_id                           VARCHAR2
                                      , p_i_v_component_id                      VARCHAR2
                                      , p_i_v_component_value                   VARCHAR2
                                      , p_i_v_record_change_user                VARCHAR2
                                      , p_i_v_record_change_date                VARCHAR2
                                      , p_o_v_error                OUT NOCOPY   VARCHAR2
                               );

  PROCEDURE PRE_EUT_GET_SHARE_FSC_LIST(
                                p_o_refFSCList  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_i_v_user_id  IN  VARCHAR2
                                ,p_i_v_is_control_fsc IN VARCHAR2
                                ,p_o_v_error    OUT VARCHAR2
                               );

/**
 * @ PRV_VUT_INS_ERR_LOG
 * Purpose : Insert into Error Log Table
* @param  : program ID
* @param  : File Name
* @param  : Line No
* @param  : Column No
* @param  : Column Name
* @param  : Column Data
* @param  : User Error Code
* @param  : User Error Desc
* @param  : Oracle Error Code
* @param  : Oracle Error Desc
* @param  : User ID
* @param  : Update/Error Date
* @return Insert into Error Log Table
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
PROCEDURE PRE_EUT_INS_ERR_LOG (
                                 p_i_v_prog_id       VARCHAR2
                                ,p_i_v_file_nm       VARCHAR2
                                ,p_i_v_line_no       NUMBER
                                ,p_i_v_col_no        NUMBER
                                ,p_i_v_col_nm        VARCHAR2
                                ,p_i_v_col_val       VARCHAR2
                                ,p_i_v_user_err_cd   VARCHAR2
                                ,p_i_v_user_err_desc VARCHAR2
                                ,p_i_v_ora_err_cd    VARCHAR2
                                ,p_i_v_ora_err_desc  VARCHAR2
                                ,p_i_v_user_id       VARCHAR2
                                ,p_i_v_err_dt        DATE
                              );

    /*    Handling Instruction Code validation */
    PROCEDURE PRE_EDL_VAL_HAND_CODE(
                                  p_i_v_shi_code    IN VARCHAR2
                                , p_o_v_flag        OUT VARCHAR2
                                , p_o_v_err_cd      OUT VARCHAR2
                                );
    PROCEDURE PRE_EUT_GET_CLR
    (
          p_o_refClr                OUT PCE_ECM_REF_CUR.ECM_REF_CUR
      , p_o_v_err_cd              OUT NOCOPY  VARCHAR2
    ) ;

  PROCEDURE PRE_VAL_OPERATOR_CODE( p_i_v_oper_cd                VARCHAR2
                                 , p_o_v_flag        OUT        VARCHAR2
                                 , p_o_v_err_cd      OUT NOCOPY VARCHAR2
                                 );

    PROCEDURE PRE_VAL_SHIPMENT_TERM_CODE( p_i_v_shipmnt_cd                VARCHAR2
                                        , p_o_v_flag        OUT        VARCHAR2
                                        , p_o_v_err_cd      OUT NOCOPY VARCHAR2
                                        );

    PROCEDURE PRE_VAL_EQUIPMENT_TYPE( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) ;

        PROCEDURE PRE_VAL_PORT_CODE( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) ;

    PROCEDURE PRE_VAL_PORT_TERMINAL( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) ;

/**
* @ FN_EUT_GET_GMT_VAL
* Purpose : Retrieves GMT value for given port
* @param  : p_i_v_date Format: RRRRDDMM
* @param  : p_i_v_time Format: HH24MI (e.g 430 , 1430)
* @param  : p_i_v_port
* @return string : GMT Date value
* @see   None
* @exception None
* -----------------------------------------------------------------------------
* Steps/Checks involved :
* Step A : None
* -----------------------------------------------------------------------------
*/
    FUNCTION FN_EUT_GET_GMT_VAL
    (
          p_i_v_date           VARCHAR2
        , p_i_v_time                 VARCHAR2
        , p_i_v_port           VARCHAR2
    )
    RETURN DATE;

    /**
    * @ PRE_POPULATE_CONT_STATUS
    * Purpose : populate Container Status Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_CONT_STATUS (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_MIDSTREAM
    * Purpose : populate Midstream Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_MIDSTREAM(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) ;

    /**
    * @ PRE_POPULATE_LOAD_COND
    * Purpose : populate Load Condition Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_LOAD_COND(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_DAMAGED
    * Purpose : populate damaged Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_DAMAGED(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_SWAP_CONECTION
    * Purpose : populate swap connection Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_SWAP_CONECTION(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_TIGHT_CON
    * Purpose : Populate Tight Connection Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_TIGHT_CON(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_FLASH_UNIT
    * Purpose : Populate Flash Unit Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_FLASH_UNIT(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_FUMIGATION
    * Purpose : Populate Fumigation Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_FUMIGATION(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_SIZE
    * Purpose : Populate Size Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_SIZE(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_FULL_MT
    * Purpose : Populate Full MT Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_FULL_MT(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_BOOKING_TYP
    * Purpose : Populate Booking Type Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_BOOKING_TYP(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) ;

    /**
    * @ PRE_POPULATE_SOC_COC
    * Purpose : Populate SOC - COC Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_SOC_COC(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_POD_STATUS
    * Purpose : Populate POD Status Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_POD_STATUS(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) ;

    /**
    * @ PRE_POPULATE_SPECIAL_HEANDLING
    * Purpose : Populate Special Heandling Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_SPECIAL_HEANDLING(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_RESIDUE
    * Purpose : Populate Residue Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_RESIDUE(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_RESTOW_STATUS
    * Purpose : Populate Restow Status Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_RESTOW_STATUS(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_DISCHARGE_ST_BOOK
    * Purpose : Populate Discharge Status For Booking Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_DISCHARGE_ST_BOOK(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_DISCHARGE_ST_OL
    * Purpose : Populate Discharge Status For Overlanded Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_DISCHARGE_ST_OL(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_BOOKED_IN
    * Purpose : Populate Booked Search In Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_BOOKED_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) ;

    /**
    * @ PRE_POPULATE_BOOKED_ORDER
    * Purpose : Populate Booked Search Order Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_BOOKED_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) ;

    /**
    * @ PRE_POPULATE_OL_IN
    * Purpose : Populate Overlanded Search In Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_OL_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_OL_ORDER
    * Purpose : Populate Overlanded Search Order Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_OL_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) ;

    /**
    * @ PRE_POPULATE_RESTOW_IN
    * Purpose : Populate Restow Search In Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_RESTOW_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_RESTOW_ORDER
    * Purpose : Populate Restow Search Order Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_RESTOW_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_DISCHARGE_LIST_ST
    * Purpose : Populate Discharge List Status Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_DISCHARGE_LIST_ST(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

/********************************************************************************/
    /**
    * @ PRE_POPULATE_LOAD_LIST_STATUS
    * Purpose : populate Load List Status Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_LOAD_LIST_STATUS (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );


    /**
    * @ PRE_POP_LOADING_LIST_STATUS
    * Purpose : populate Load List Status Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POP_LOADING_LIST_STATUS (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_LL_BOOKED_IN
    * Purpose : populate Load list Booking Search Fields Status Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_LL_BOOKED_IN (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );
    /**
    * @ PRE_POPULATE_LL_BOOKED_ORDER
    * Purpose : populate Load list Booking order Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_LL_BOOKED_ORDER (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POP_LL_BOOK_SORT_ORDER
    * Purpose : populate Load list Booking sort order Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POP_LL_BOOK_SORT_ORDER (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_OVERSHIPPED_IN
    * Purpose : populate Load list Overshipped search fields Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_OVERSHIPPED_IN (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POP_OVERSHIPPED_LOADING
    * Purpose : populate Load list Overshipped loading Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POP_OVERSHIPPED_LOADING (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POP_OVERSHIPPED_ORDER
    * Purpose : populate Load list Overshipped order Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POP_OVERSHIPPED_ORDER (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_LL_RESTOW_IN
    * Purpose : populate Load list Restowed search fields Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_LL_RESTOW_IN (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );

    /**
    * @ PRE_POPULATE_RESTOW_ORD
    * Purpose : populate Load list Restowed order Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_RESTOW_ORD (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   );



    PROCEDURE PRE_UPD_NEXT_POD (
          p_i_v_fk_booking_no                 TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE
        , p_i_v_lldl_flag                     VARCHAR2
        , p_i_v_fk_bkg_voyage_rout_dtl        TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
        , p_i_v_load_condition                TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION%TYPE
        , p_i_v_container_gross_weight        TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT%TYPE
        --*01 begin
        , p_i_v_vgm  TOS_DL_BOOKED_DISCHARGE.VGM%TYPE
        , p_i_v_category TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE%TYPE
        --*01 end
        , p_i_v_damaged                       TOS_DL_BOOKED_DISCHARGE.DAMAGED%TYPE
        , p_i_v_fk_container_operator         TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR%TYPE
        , p_i_v_out_slot_operator             TOS_DL_BOOKED_DISCHARGE.OUT_SLOT_OPERATOR%TYPE
        , p_i_v_seal_no                       TOS_DL_BOOKED_DISCHARGE.SEAL_NO%TYPE
        , p_i_v_mlo_vessel                    TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL%TYPE
        , p_i_v_mlo_voyage                    TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE%TYPE
        , p_i_v_mlo_vessel_eta                TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL_ETA%TYPE
        , p_i_v_mlo_pod1                      TOS_DL_BOOKED_DISCHARGE.MLO_POD1%TYPE
        , p_i_v_mlo_pod2                      TOS_DL_BOOKED_DISCHARGE.MLO_POD2%TYPE
        , p_i_v_mlo_pod3                      TOS_DL_BOOKED_DISCHARGE.MLO_POD3%TYPE
        , p_i_v_mlo_del                       TOS_DL_BOOKED_DISCHARGE.MLO_DEL%TYPE
        , p_i_v_fk_handl_instruction_1        TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1%TYPE
        , p_i_v_fk_handl_instruction_2        TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2%TYPE
        , p_i_v_fk_handl_instruction_3        TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3%TYPE
        , p_i_v_container_loading_rem_1       TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1%TYPE
        , p_i_v_container_loading_rem_2       TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2%TYPE
        , p_i_v_tight_connection_flag1        TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1%TYPE
        , p_i_v_tight_connection_flag2        TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2%TYPE
        , p_i_v_tight_connection_flag3        TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3%TYPE
        , p_i_v_fumigation_only               TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY%TYPE
        , p_i_v_residue_only_flag             TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG%TYPE
        , p_i_v_fk_bkg_size_type_dtl          TOS_DL_BOOKED_DISCHARGE.FK_BKG_SIZE_TYPE_DTL%TYPE
        , p_i_v_fk_bkg_supplier               TOS_DL_BOOKED_DISCHARGE.FK_BKG_SUPPLIER%TYPE
        , p_i_v_fk_bkg_equipm_dtl             TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL%TYPE
        , p_o_v_err_cd                        OUT VARCHAR2
    );

    /**
    * @ PRE_POPULATE_CRANE_DESC
    * Purpose : populate Midstream Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_CRANE_DESC(
                                        p_i_port                 TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE
                                        ,p_i_terminal            TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE
                                        ,p_o_ref_cur             OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                        ,p_o_v_err_cd            OUT VARCHAR2
                                    ) ;
/**
    * @ PRE_POPULATE_CATEGORY_DESC
    * Purpose : populate Category Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
 PROCEDURE PRE_POPULATE_CATEGORY_DESC(
                                        p_o_ref_cur             OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                        ,p_o_v_err_cd            OUT VARCHAR2
    )             ;
    
    
 PROCEDURE PRE_VAL_PLACE_DELIVERY( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , P_O_V_Err_Cd      Out Nocopy Varchar2
    ) ;

END PCE_EUT_COMMON;

/
