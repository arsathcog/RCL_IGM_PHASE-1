create or replace
PACKAGE         "PCE_ELL_LLMAINTENANCE" AS
  /* -----------------------------------------------------------------------------
  System  : RCL-EZLL
  Module  : Load List
  Prog ID : ELL002 - PCE_ELL_LLMAINTENANCE.sql
  Name    : Load List Maintenance
  Purpose : Allows to maintain Load List
  --------------------------------------------------------------------------------
  History : None
  --------------------------------------------------------------------------------
  Author                Date                      What
  --------------- --------------- ------------------------------------------------
  NTL)Vikas Verma    25/02/2011        <Initial version>
  --Change Log--------------------------------------------------------------------
  DD/MM/YY     User-Task/CR No -Short Description-
  *8: Added by vikas, to get cran value in booked tab, as k'chatamol, 27.03.2012
  *17: Modified by vikas, When load list status changed from open to load complete
    (10 or more then 10) than, update load list status in discharge list booked table.
     and update Copy DG, OOG, REEFER details from load list to discharge list detail tablelist,
     as k'chatgamol, 08.10.2012
  *18: Modified by vikas, When changing list status from open to load complete or higher,
     check duplicate cell location, as k'chatgamol, 27.12.2012
  *23: Modified by vikas, modify logic to get next discharge list, as k'chatgamol,
     11.06.2013
   *29 02/06/16  Saisuda CR new VGM and Category   -Add new column VGM and Category at Booking tab.
                                                                         -Add new procedcure for compare VGM and weight.
    *30  07/07/2016  Saisuda ,      As per Guru's request (on 5.07.2016), to stamp first complete dtae/user whenever LL/DL status changed to Loading complete
   ----------------------------------------------------------------------------- */

  G_EXP_UPD_ANOTHER_USR EXCEPTION;

  PROCEDURE PRV_ELL_SET_BOOKING_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                       ,P_I_V_LOAD_LIST_ID IN VARCHAR2
                                       ,P_I_V_USER_ID      IN VARCHAR2
                                       ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRV_ELL_SET_OVERSHIP_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                        ,P_I_V_LOAD_LIST_ID IN VARCHAR2
                                        ,P_I_V_USER_ID      IN VARCHAR2
                                        ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRV_ELL_SET_RESTOW_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                      ,P_I_V_LOAD_LIST_ID IN VARCHAR2
                                      ,P_I_V_USER_ID      IN VARCHAR2
                                      ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRV_ELL_CLR_TMP(P_I_V_SESSION_ID IN VARCHAR2
                           ,P_I_V_USER_ID    IN VARCHAR2
                           ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRE_ELL_BOOKED_TAB_FIND(P_O_REFBOOKEDTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                   ,P_I_V_SESSION_ID     IN VARCHAR2
                                   ,P_I_V_FIND1          IN VARCHAR2
                                   ,P_I_V_IN1            IN VARCHAR2
                                   ,P_I_V_FIND2          IN VARCHAR2
                                   ,P_I_V_IN2            IN VARCHAR2
                                   ,P_I_V_ORDER1         IN VARCHAR2
                                   ,P_I_V_ORDER1ORDER    IN VARCHAR2
                                   ,P_I_V_ORDER2         IN VARCHAR2
                                   ,P_I_V_ORDER2ORDER    IN VARCHAR2
                                   ,P_I_V_LOAD_LIST_ID   IN VARCHAR2
                                   ,P_O_V_TOT_REC        OUT VARCHAR2
                                   ,P_O_V_ERROR          OUT VARCHAR2);

  PROCEDURE PRE_ELL_OVERSHIPPED_TAB_FIND(P_O_REFOVERSHIPPEDTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                        ,P_I_V_SESSION_ID          IN VARCHAR2
                                        ,P_I_V_FIND1               IN VARCHAR2
                                        ,P_I_V_IN1                 IN VARCHAR2
                                        ,P_I_V_FIND2               IN VARCHAR2
                                        ,P_I_V_IN2                 IN VARCHAR2
                                        ,P_I_V_ORDER1              IN VARCHAR2
                                        ,P_I_V_ORDER1ORDER         IN VARCHAR2
                                        ,P_I_V_ORDER2              IN VARCHAR2
                                        ,P_I_V_ORDER2ORDER         IN VARCHAR2
                                        ,P_I_V_LOAD_LIST_ID        IN VARCHAR2
                                        ,P_O_V_TOT_REC             OUT VARCHAR2
                                        ,P_O_V_ERROR               OUT VARCHAR2);

  PROCEDURE PRE_ELL_RESTOWED_TAB_FIND(P_O_REFRESTOWEDTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                     ,P_I_V_SESSION_ID       IN VARCHAR2
                                     ,P_I_V_FIND1            IN VARCHAR2
                                     ,P_I_V_IN1              IN VARCHAR2
                                     ,P_I_V_FIND2            IN VARCHAR2
                                     ,P_I_V_IN2              IN VARCHAR2
                                     ,P_I_V_ORDER1           IN VARCHAR2
                                     ,P_I_V_ORDER1ORDER      IN VARCHAR2
                                     ,P_I_V_ORDER2           IN VARCHAR2
                                     ,P_I_V_ORDER2ORDER      IN VARCHAR2
                                     ,P_I_V_LOAD_LIST_ID     IN VARCHAR2
                                     ,P_O_V_TOT_REC          OUT VARCHAR2
                                     ,P_O_V_ERROR            OUT VARCHAR2);

  PROCEDURE PRE_ELL_SUMMARY_TAB_FIND(P_O_REFSUMMARYTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,P_I_V_LOAD_LIST_ID    VARCHAR2
                                    ,P_O_V_TOT_REC         OUT VARCHAR2
                                    ,P_O_V_ERROR           OUT VARCHAR2);

  PROCEDURE ADDITION_WHERE_CONDTIONS(P_I_V_IN   IN VARCHAR2
                                    ,P_I_V_FIND IN VARCHAR2
                                    ,P_I_V_TAB  IN VARCHAR2);

  PROCEDURE PRE_ELL_SAVE_BOOKED_TAB_DATA(P_I_V_SESSION_ID              VARCHAR2
                                        ,P_I_V_SEQ_NO                  VARCHAR2
                                        ,P_I_V_LOAD_LIST_ID            VARCHAR2
                                        ,P_I_V_DN_EQUIPMENT_NO         VARCHAR2
                                        ,P_I_V_LOCAL_TERMINAL_STATUS   VARCHAR2
                                        ,P_I_V_MIDSTREAM_HANDLING_CODE VARCHAR2
                                        ,P_I_V_LOAD_CONDITION          VARCHAR2
                                        ,P_I_V_LOADING_STATUS          VARCHAR2
                                        ,P_I_V_STOWAGE_POSITION        VARCHAR2
                                        ,P_I_V_ACTIVITY_DATE_TIME      VARCHAR2
                                        ,P_I_V_CONTAINER_GROSS_WEIGHT  VARCHAR2
                                           --*29 begin
                                        ,P_I_V_VGM VARCHAR2
                                        ,P_I_V_CATEGORY VARCHAR2
                                        --*29 end
                                        ,P_I_V_DAMAGED                 VARCHAR2
                                        ,P_I_V_FK_CONTAINER_OPERATOR   VARCHAR2
                                        ,P_I_V_SLOT_OPERATOR           VARCHAR2
                                        ,P_I_V_SEAL_NO                 VARCHAR2
                                        ,P_I_V_MLO_VESSEL              VARCHAR2
                                        ,P_I_V_MLO_VOYAGE              VARCHAR2
                                        ,P_I_V_MLO_VESSEL_ETA          VARCHAR2
                                        ,P_I_V_MLO_POD1                VARCHAR2
                                        ,P_I_V_MLO_POD2                VARCHAR2
                                        ,P_I_V_MLO_POD3                VARCHAR2
                                        ,P_I_V_MLO_DEL                 VARCHAR2
                                        ,P_I_V_HUMIDITY                VARCHAR2
                                        ,P_I_V_HANDLING_INST1          VARCHAR2
                                        ,P_I_V_HANDLING_INST2          VARCHAR2
                                        ,P_I_V_HANDLING_INST3          VARCHAR2
                                        ,P_I_V_CONTAINER_LOADING_REM_1 VARCHAR2
                                        ,P_I_V_CONTAINER_LOADING_REM_2 VARCHAR2
                                        ,P_I_V_TIGHT_CONNECTION_FLAG1  VARCHAR2
                                        ,P_I_V_TIGHT_CONNECTION_FLAG2  VARCHAR2
                                        ,P_I_V_TIGHT_CONNECTION_FLAG3  VARCHAR2
                                        ,P_I_V_FK_IMDG                 VARCHAR2
                                        ,P_I_V_FK_UNNO                 VARCHAR2
                                        ,P_I_V_FK_UN_VAR               VARCHAR2
                                        ,P_I_V_FK_PORT_CLASS           VARCHAR2
                                        ,P_I_V_FK_PORT_CLASS_TYP       VARCHAR2
                                        ,P_I_V_FLASH_UNIT              VARCHAR2
                                        ,P_I_V_FLASH_POINT             VARCHAR2
                                        ,P_I_V_FUMIGATION_ONLY         VARCHAR2
                                        ,P_I_V_OVERHEIGHT_CM           VARCHAR2
                                        ,P_I_V_OVERWIDTH_LEFT_CM       VARCHAR2
                                        ,P_I_V_OVERWIDTH_RIGHT_CM      VARCHAR2
                                        ,P_I_V_OVERLENGTH_FRONT_CM     VARCHAR2
                                        ,P_I_V_OVERLENGTH_REAR_CM      VARCHAR2
                                        ,P_I_V_REEFER_TEMPERATURE      VARCHAR2
                                        ,P_I_V_REEFER_TMP_UNIT         VARCHAR2
                                        ,P_I_V_PUBLIC_REMARK           VARCHAR2
                                        ,P_I_V_OUT_SLOT_OPERATOR       VARCHAR2
                                        ,P_I_V_USER_ID                 VARCHAR2
                                        ,P_I_V_OPN_STS                 VARCHAR2
                                        ,P_I_V_LOCAL_STATUS            VARCHAR2
                                        ,P_I_V_EX_MLO_VESSEL           VARCHAR2
                                        ,P_I_V_EX_MLO_VESSEL_ETA       VARCHAR2
                                        ,P_I_V_EX_MLO_VOYAGE           VARCHAR2
                                        ,P_I_V_VENTILATION             VARCHAR2
                                        ,P_I_V_RESIDUE_ONLY_FLAG       VARCHAR2
                                        ,P_I_V_CRAN_DESCRIPTION        VARCHAR2 -- *8
                                        ,P_O_V_ERROR                   OUT VARCHAR2);

  PROCEDURE PRE_ELL_SAVE_OVERSHIP_TAB_DATA(P_I_V_SESSION_ID               VARCHAR2
                                          ,P_I_V_SEQ_NO                   IN OUT VARCHAR2
                                          ,P_I_V_OVERSHIPPED_CONTAINER_ID VARCHAR2
                                          ,P_I_V_LOAD_LIST_ID             VARCHAR2
                                          ,P_I_V_BOOKING_NO               VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO             VARCHAR2
                                          ,P_I_V_EQ_SIZE                  VARCHAR2
                                          ,P_I_V_EQ_TYPE                  VARCHAR2
                                          ,P_I_V_FULL_MT                  VARCHAR2
                                          ,P_I_V_BKG_TYP                  VARCHAR2
                                          ,P_I_V_FLAG_SOC_COC             VARCHAR2
                                          ,P_I_V_SHIPMENT_TERM            VARCHAR2
                                          ,P_I_V_SHIPMENT_TYP             VARCHAR2
                                          ,P_I_V_LOCAL_STATUS             VARCHAR2
                                          ,P_I_V_LOCAL_TERMINAL_STATUS    VARCHAR2
                                          ,P_I_V_MIDSTREAM_HANDLING_CODE  VARCHAR2
                                          ,P_I_V_LOAD_CONDITION           VARCHAR2
                                          ,P_I_V_STOWAGE_POSITION         VARCHAR2
                                          ,P_I_V_ACTIVITY_DATE_TIME       VARCHAR2
                                          ,P_I_V_CONTAINER_GROSS_WEIGHT   VARCHAR2
                                          ,P_I_V_DAMAGED                  VARCHAR2
                                          ,P_I_V_SLOT_OPERATOR            VARCHAR2
                                          ,P_I_V_CONTAINER_OPERATOR       VARCHAR2
                                          ,P_I_V_OUT_SLOT_OPERATOR        VARCHAR2
                                          ,P_I_V_SPECIAL_HANDLING         VARCHAR2
                                          ,P_I_V_SEAL_NO                  VARCHAR2
                                          ,P_I_V_POD                      VARCHAR2
                                          ,P_I_V_POD_TERMINAL             VARCHAR2
                                          ,P_I_V_NXT_SRV                  VARCHAR2
                                          ,P_I_V_NXT_VESSEL               VARCHAR2
                                          ,P_I_V_NXT_VOYAGE               VARCHAR2
                                          ,P_I_V_NXT_DIR                  VARCHAR2
                                          ,P_I_V_MLO_VESSEL               VARCHAR2
                                          ,P_I_V_MLO_VOYAGE               VARCHAR2
                                          ,P_I_V_MLO_VESSEL_ETA           VARCHAR2
                                          ,P_I_V_MLO_POD1                 VARCHAR2
                                          ,P_I_V_MLO_POD2                 VARCHAR2
                                          ,P_I_V_MLO_POD3                 VARCHAR2
                                          ,P_I_V_MLO_DEL                  VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_1   VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_2   VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_3   VARCHAR2
                                          ,P_I_V_CONTAINER_LOADING_REM_1  VARCHAR2
                                          ,P_I_V_CONTAINER_LOADING_REM_2  VARCHAR2
                                          ,P_I_V_SPECIAL_CARGO            VARCHAR2
                                          ,P_I_V_IMDG_CLASS               VARCHAR2
                                          ,P_I_V_UN_NUMBER                VARCHAR2
                                          ,P_I_V_UN_VAR                   VARCHAR2
                                          ,P_I_V_PORT_CLASS               VARCHAR2
                                          ,P_I_V_PORT_CLASS_TYP           VARCHAR2
                                          ,P_I_V_FLASHPOINT_UNIT          VARCHAR2
                                          ,P_I_V_FLASHPOINT               VARCHAR2
                                          ,P_I_V_FUMIGATION_ONLY          VARCHAR2
                                          ,P_I_V_RESIDUE_ONLY_FLAG        VARCHAR2
                                          ,P_I_V_OVERHEIGHT_CM            VARCHAR2
                                          ,P_I_V_OVERWIDTH_LEFT_CM        VARCHAR2
                                          ,P_I_V_OVERWIDTH_RIGHT_CM       VARCHAR2
                                          ,P_I_V_OVERLENGTH_FRONT_CM      VARCHAR2
                                          ,P_I_V_OVERLENGTH_REAR_CM       VARCHAR2
                                          ,P_I_V_REEFER_TEMPERATURE       VARCHAR2
                                          ,P_I_V_REEFER_TMP_UNIT          VARCHAR2
                                          ,P_I_V_HUMIDITY                 VARCHAR2
                                          ,P_I_V_VENTILATION              VARCHAR2
                                          ,P_I_V_LOADING_STATUS           VARCHAR2
                                          ,P_I_V_USER_ID                  VARCHAR2
                                          ,P_I_V_OPN_STS                  VARCHAR2
                                          ,P_I_V_VOID_SLOT                VARCHAR2
                                          ,P_I_V_EX_MLO_VESSEL            VARCHAR2
                                          ,P_I_V_EX_MLO_VESSEL_ETA        VARCHAR2
                                          ,P_I_V_EX_MLO_VOYAGE            VARCHAR2
                                          ,P_I_V_VGM                      VARCHAR2 --*34                                          
                                          ,P_O_V_ERROR                    OUT VARCHAR2);

  PROCEDURE PRE_ELL_DEL_OVERSHIPPED_DATA(P_I_V_SESSION_ID IN VARCHAR2
                                        ,P_I_V_SEQ_NO     IN VARCHAR2
                                        ,P_I_V_OPN_STS    IN VARCHAR2
                                        ,P_I_V_USER_ID    IN VARCHAR2
                                        ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRE_ELL_SAVE_RESTOW_TAB_DATA(P_I_V_SESSION_ID             IN VARCHAR2
                                        ,P_I_V_SEQ_NO                 IN OUT VARCHAR2
                                        ,P_I_V_PK_RESTOW_ID           IN VARCHAR2
                                        ,P_I_V_EQUIPMENT_NO           IN VARCHAR2
                                        ,P_I_V_MIDSTREAM              IN VARCHAR2
                                        ,P_I_V_LOAD_CONDITION         IN VARCHAR2
                                        ,P_I_V_RESTOW_STATUS          IN VARCHAR2
                                        ,P_I_V_STOWAGE_POSITION       IN VARCHAR2
                                        ,P_I_V_ACTIVITY_DATE_TIME     IN VARCHAR2
                                        ,P_I_V_PUBLIC_REMARK          IN VARCHAR2
                                        ,P_I_V_USER_ID                IN VARCHAR2
                                        ,P_I_V_LOAD_LIST_ID           IN VARCHAR2
                                        ,P_I_V_OPN_STS                IN VARCHAR2
                                        ,P_I_V_CONTAINER_GROSS_WEIGHT IN VARCHAR2
                                        ,P_I_V_DAMAGED                IN VARCHAR2
                                        ,P_I_V_SEAL_NO                IN VARCHAR2
                                        ,P_O_V_ERROR                  OUT VARCHAR2);

  PROCEDURE PRE_ELL_DEL_RESTOWED_TAB_DATA(P_I_V_SESSION_ID IN VARCHAR2
                                         ,P_I_V_SEQ_NO     IN VARCHAR2
                                         ,P_I_V_OPN_STS    IN VARCHAR2
                                         ,P_I_V_USER_ID    IN VARCHAR2
                                         ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRE_ELL_SAVE_TEMP_TO_MAIN(P_I_V_SESSION_ID       IN VARCHAR2
                                     ,P_I_V_USER_ID          IN VARCHAR2
                                     ,P_I_V_LOAD_LIST_STATUS IN VARCHAR2
                                     ,P_I_V_LOAD_LIST_ID     IN VARCHAR2
                                     ,P_I_V_ETA              IN VARCHAR2
                                     ,P_I_V_VESSEL           IN VARCHAR2
                                     ,P_I_V_HDR_ETA_TM       IN VARCHAR2
                                     ,P_I_V_HDR_PORT         IN VARCHAR2
                                     ,P_I_V_LOAD_ETD         IN VARCHAR2
                                     ,P_I_V_HDR_ETD_TM       IN VARCHAR2
                                     ,P_O_V_ERR_CD           OUT VARCHAR2);

  PROCEDURE PRE_ELL_SAVE_BOOKED_TAB_MAIN(P_I_V_SESSION_ID IN VARCHAR2
                                        ,P_I_V_USER_ID    IN VARCHAR2
                                        ,P_I_V_PORT_CODE  IN VARCHAR2
                                        ,P_I_V_LOAD_ETD   IN VARCHAR2
                                        ,P_I_V_HDR_ETD_TM IN VARCHAR2
                                        ,P_I_V_VESSEL     IN VARCHAR2
                                        ,P_I_V_DATE       IN VARCHAR2
                                        ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRE_ELL_BOOKED_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                     ,P_I_ROW_NUM             NUMBER
                                     ,P_I_V_LOAD_LIST_ID      VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                     ,P_I_V_PK_LOAD_LIST      VARCHAR2
                                     ,P_I_V_CLR_CODE1         VARCHAR2
                                     ,P_I_V_CLR_CODE2         VARCHAR2
                                     ,P_I_V_OPER_CD           VARCHAR2
                                     ,P_I_V_UNNO              VARCHAR2
                                     ,P_I_V_PORT_CODE         VARCHAR2
                                     ,P_I_V_VARIANT           VARCHAR2
                                     ,P_I_V_IMDG              VARCHAR2
                                     ,P_I_V_SHI_CODE1         VARCHAR2
                                     ,P_I_V_SHI_CODE2         VARCHAR2
                                     ,P_I_V_SHI_CODE3         VARCHAR2
                                     ,P_I_V_PORT_CLASS        VARCHAR2
                                     ,P_I_V_PORT_CLASS_TYPE   VARCHAR2
                                     ,P_I_V_SLOT_OPERATOR     VARCHAR2
                                     ,P_I_V_OUT_SLOT_OPERATOR VARCHAR2
                                     ,P_I_V_DN_SOC_COC        VARCHAR2
                                     ,P_I_V_LOAD_ETD          VARCHAR2
                                     ,P_I_V_HDR_ETD_TM        VARCHAR2
                                     ,P_O_V_ERR_CD            OUT VARCHAR2);

  PROCEDURE PRE_ELL_SAVE_OVERSHIP_TAB_MAIN(P_I_V_SESSION_ID IN VARCHAR2
                                          ,P_I_V_USER_ID    IN VARCHAR2
                                          ,P_I_V_VESSEL     IN VARCHAR2
                                          ,P_I_V_ETA        IN VARCHAR2
                                          ,P_I_V_HDR_ETA_TM IN VARCHAR2
                                          ,P_I_V_PORT_CODE  IN VARCHAR2
                                          ,P_I_V_DATE       IN VARCHAR2
                                          ,P_I_V_LOAD_ETD   IN VARCHAR2
                                          ,P_I_V_HDR_ETD_TM IN VARCHAR2
                                          ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRE_ELL_OVERSHIPPED_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                          ,P_I_ROW_NUM             VARCHAR2
                                          ,P_I_V_LOAD_LIST_ID      VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                          ,P_I_V_PK_CONT_ID        VARCHAR2
                                          ,P_I_V_CLR_CODE1         VARCHAR2
                                          ,P_I_V_CLR_CODE2         VARCHAR2
                                          ,P_I_V_OPER_CD           VARCHAR2
                                          ,P_I_V_SHI_CODE1         VARCHAR2
                                          ,P_I_V_SHI_CODE2         VARCHAR2
                                          ,P_I_V_SHI_CODE3         VARCHAR2
                                          ,P_I_V_UNNO              VARCHAR2
                                          ,P_I_V_VARIANT           VARCHAR2
                                          ,P_I_V_IMDG              VARCHAR2
                                          ,P_I_V_PORT_CODE         VARCHAR2
                                          ,P_I_V_PORT_CLASS        VARCHAR2
                                          ,P_I_V_PORT_CLASS_TYPE   VARCHAR2
                                          ,P_I_V_OUT_SLOT_OPERATOR VARCHAR2
                                          ,P_I_V_SLOT_OPERATOR     VARCHAR2
                                          ,P_I_V_SHIPMNT_CD        VARCHAR2
                                          ,P_I_V_SOC_COC           VARCHAR2
                                          ,P_I_V_LOAD_ETD          VARCHAR2
                                          ,P_I_V_HDR_ETD_TM        VARCHAR2
                                          ,P_I_V_EQUIP_TYPE        VARCHAR2
                                          ,P_I_V_POD_CODE          VARCHAR2
                                          ,P_I_V_POD_TERMINAL_CODE VARCHAR2
                                          ,P_O_V_ERR_CD            OUT VARCHAR2);

  PROCEDURE PRE_ELL_SAVE_RESTOW_TAB_MAIN(P_I_V_SESSION_ID VARCHAR2
                                        ,P_I_V_USER_ID    VARCHAR2
                                        ,P_I_V_VESSEL     VARCHAR2
                                        ,P_I_V_ETA        VARCHAR2
                                        ,P_I_V_HDR_ETA_TM VARCHAR2
                                        ,P_I_V_LOAD_ETD   VARCHAR2
                                        ,P_I_V_HDR_ETD_TM VARCHAR2
                                        ,P_I_V_HDR_PORT   VARCHAR2
                                        ,P_I_V_DATE       VARCHAR2
                                        ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRE_ELL_RESTOW_VALIDATION(P_I_V_SESSION_ID    VARCHAR2
                                     ,P_I_ROW_NUM         NUMBER
                                     ,P_I_V_LOAD_LIST_ID  VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO  VARCHAR2
                                     ,P_I_V_RESTOW_ID     VARCHAR2
                                     ,P_I_V_SOC_COC       VARCHAR2
                                     ,P_I_V_HDR_PORT      VARCHAR2
                                     ,P_I_V_DISCHARGE_ETD VARCHAR2
                                     ,P_I_V_HDR_ETD_TM    VARCHAR2
                                     ,P_O_V_ERR_CD        OUT VARCHAR2);

  PROCEDURE PCV_ELL_RECORD_LOCK(P_I_V_ID       VARCHAR2
                               ,P_I_V_REC_DT   VARCHAR2
                               ,P_I_V_TAB_NAME VARCHAR2
                               ,P_O_V_ERR_CD   OUT VARCHAR2);

  PROCEDURE PRE_ELL_SYNCH_BOOKING(P_I_V_PK_BOOKED_ID        VARCHAR2
                                 ,P_I_V_CONTAINER_SEQ_NO    VARCHAR2
                                 ,P_I_V_DN_EQUIPMENT_NO     VARCHAR2
                                 ,P_I_V_FK_BOOKING_NO       VARCHAR2
                                 ,P_I_V_OVERWIDTH_LEFT_CM   VARCHAR2
                                 ,P_I_V_OVERHEIGHT_CM       VARCHAR2
                                 ,P_I_V_OVERWIDTH_RIGHT_CM  VARCHAR2
                                 ,P_I_V_OVERLENGTH_FRONT_CM VARCHAR2
                                 ,P_I_V_OVERLENGTH_REAR_CM  VARCHAR2
                                 ,P_I_V_FK_IMDG             VARCHAR2
                                 ,P_I_V_FK_UNNO             VARCHAR2
                                 ,P_I_V_FK_UN_VAR           VARCHAR2
                                 ,P_I_V_FLASH_POINT         VARCHAR2
                                 ,P_I_V_FLASH_UNIT          VARCHAR2
                                 ,P_I_V_REEFER_TMP_UNIT     VARCHAR2
                                 ,P_I_V_TEMPERATURE         VARCHAR2
                                 ,P_I_V_DN_HUMIDITY         VARCHAR2
                                 ,P_I_V_WEIGHT              VARCHAR2
                                 ,P_I_V_DN_VENTILATION      VARCHAR2
                                 ,P_I_V_CATEGORY            VARCHAR2 --*29
                                 ,P_I_V_VGM                 VARCHAR2 --*34 
                                 ,P_O_V_ERR_CD              OUT VARCHAR2);

  PROCEDURE PRE_ELL_LL_STATUS_VALIDATION(P_I_V_LOAD_LIST_ID     VARCHAR2
                                        ,P_I_V_LOAD_LIST_STATUS VARCHAR2
                                        ,P_O_V_ERR_CD           OUT VARCHAR2);

  PROCEDURE PRE_ELL_SAVE_LL_STATUS(P_I_V_LOAD_LIST_ID     VARCHAR2
                                  ,P_I_V_LOAD_LIST_STATUS VARCHAR2
                                  ,P_I_V_USER_ID          VARCHAR2
                                  ,P_I_V_SESSION_ID       VARCHAR2 -- *18
                                  ,P_I_V_DATE             VARCHAR2
                                  ,P_O_V_ERR_CD           OUT VARCHAR2);
  PROCEDURE GET_VESSEL_OWNER_DTL(P_I_V_HDR_VESSEL VARCHAR2
                                ,P_I_V_OWNER_DTL  OUT VARCHAR2
                                ,P_I_V_VESSEL_NM  OUT VARCHAR2
                                ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRE_ELL_OL_VAL_PORT_CLASS(P_I_V_PORT_CODE       VARCHAR2
                                     ,P_I_V_UNNO            VARCHAR2
                                     ,P_I_V_VARIANT         VARCHAR2
                                     ,P_I_V_IMDG_CLASS      VARCHAR2
                                     ,P_I_V_PORT_CLASS      VARCHAR2
                                     ,P_I_V_PORT_CLASS_TYPE VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO    VARCHAR2
                                     ,P_O_V_ERR_CD          OUT VARCHAR2);

  PROCEDURE PRE_ELL_OL_VAL_IMDG(P_I_V_UNNO         IN VARCHAR2
                               ,P_I_V_VARIANT      IN VARCHAR2
                               ,P_I_V_IMDG         IN VARCHAR2
                               ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                               ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_ELL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE     IN VARCHAR2
                                    ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                    ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_ELL_OL_VAL_OPERATOR_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                        ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                        ,P_O_V_ERR_CD       OUT VARCHAR2);
  PROCEDURE PRE_ELL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE     IN VARCHAR2
                                   ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                   ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_ELL_VAL_EQUIPMENT_TYPE(P_I_V_OPER_CD      IN VARCHAR2
                                      ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                      ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_ELL_VAL_PORT_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                 ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                 ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_ELL_VAL_PORT_TERMINAL_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                          ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_ELL_OL_VAL_UNNO(P_I_V_UNNO         IN VARCHAR2
                               ,P_I_V_VARIANT      IN VARCHAR2
                               ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                               ,P_O_V_ERR_CD       OUT VARCHAR2);

  /*    Check for the shipment term */
  PROCEDURE PRE_SHIPMENT_TERM_OL_CODE(P_I_V_SHIPMNT_CD   VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO VARCHAR2
                                     ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_LL_SPLIT(P_I_V_BOOKED_LOADING_ID NUMBER
                        ,P_O_V_ERR_CD            OUT NOCOPY VARCHAR2);

  PROCEDURE PRE_LL_COMMON_MATCHING(P_I_V_MATCH_TYPE               VARCHAR2
                                  ,P_I_V_LOAD_LIST_ID             NUMBER
                                  ,P_I_V_DL_CONTAINER_SEQ         NUMBER
                                  ,P_I_V_OVERSHIPPED_CONTAINER_ID NUMBER
                                  ,P_I_V_EQUIPMENT_NO             VARCHAR2
                                  ,P_O_V_ERR_CD                   OUT NOCOPY VARCHAR2);

  PROCEDURE PRE_TOS_MOVE_TO_OVERSHIPPED(P_I_N_BOOKED_LOADING_ID IN NUMBER
                                       ,P_O_V_RETURN_STATUS     OUT NOCOPY VARCHAR2);

  FUNCTION FN_ELL_CONVERTDATE(P_I_V_DATE VARCHAR2
                             ,P_I_V_TIME VARCHAR2
                             ,P_I_V_PORT VARCHAR2) RETURN DATE;

  /* Start commented by vikas, this logic is already available in
  pce_edl_dlmaintenance package, 22.11.2011*
  PROCEDURE PRE_ELL_PREV_LOAD_LIST_ID (
      p_i_v_vessel                     VARCHAR2
      , p_i_v_equip_no                   VARCHAR2
      , p_i_v_booking_no              VARCHAR2
      , p_i_v_eta_date                   VARCHAR2
      , p_i_v_eta_tm                     VARCHAR2
      , p_i_port_code                    VARCHAR2
      , p_o_v_pk_loading_id          OUT VARCHAR2
      , p_o_v_flag                   OUT VARCHAR2
      , p_o_v_err_cd                 OUT VARCHAR2
  );

  PROCEDURE PRE_ELL_NEXT_DISCHARGE_LIST_ID (
      p_i_v_vessel                     VARCHAR2
      , p_i_v_equip_no                   VARCHAR2
      , p_i_v_booking_no              VARCHAR2
      , p_i_v_etd_date                   VARCHAR2
      , p_i_v_etd_tm                     VARCHAR2
      , p_i_port_code                    VARCHAR2
      , p_o_v_pk_discharge_id     OUT VARCHAR2
      , p_o_v_flag                   OUT VARCHAR2
      , p_o_v_err_cd                 OUT VARCHAR2
  );
  *  End commented by vikas, this logic is already available in
  pce_edl_dlmaintenance package, 22.11.2011 */

  PROCEDURE PRE_ELL_PREV_LOADED_EQUIP_ID(P_I_V_EQUIP_NO      VARCHAR2
                                        ,P_I_V_ETA_DATE      VARCHAR2
                                        ,P_I_V_ETA_TM        VARCHAR2
                                        ,P_O_V_PK_LOADING_ID OUT VARCHAR2
                                        ,P_O_V_FLAG          OUT VARCHAR2
                                        ,P_O_V_ERR_CD        OUT VARCHAR2);

  PROCEDURE PRE_TOS_REMOVE_ERROR(P_I_V_DA_ERROR          VARCHAR2
                                ,P_I_V_LL_DL_FLAG        VARCHAR2
                                ,P_I_V_SIZE              VARCHAR2
                                ,P_I_V_CLR1              VARCHAR2
                                ,P_I_V_CLR2              VARCHAR2
                                ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                ,P_I_V_FK_OVERSHIPPED_ID VARCHAR2
                                ,P_I_V_FK_LOAD_LIST_ID   VARCHAR2
                                ,P_O_V_ERR_CD            OUT VARCHAR2);

  PROCEDURE PRE_EDL_POD_UPDATE( P_I_V_PK_BOOKED_ID            TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE
                              ,P_I_V_FK_BOOKING_NO           TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE
                              ,P_I_V_LLDL_FLAG               VARCHAR2
                              ,P_I_V_FK_BKG_VOYAGE_ROUT_DTL  TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
                              ,P_I_V_LOAD_CONDITION          TOS_LL_BOOKED_LOADING.LOAD_CONDITION%TYPE
                              ,P_I_V_CONTAINER_GROSS_WEIGHT  TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE
                                  --*29 begin
                              ,P_I_V_VGM TOS_LL_BOOKED_LOADING.VGM%TYPE --*34
                              ,P_I_V_CATEGORY TOS_LL_BOOKED_LOADING.CATEGORY_CODE%TYPE
                              --*29 end
                              ,P_I_V_DAMAGED                 TOS_LL_BOOKED_LOADING.DAMAGED%TYPE
                              ,P_I_V_FK_CONTAINER_OPERATOR   TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE
                              ,P_I_V_OUT_SLOT_OPERATOR       TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE
                              ,P_I_V_SEAL_NO                 TOS_LL_BOOKED_LOADING.SEAL_NO%TYPE
                              ,P_I_V_MLO_VESSEL              TOS_LL_BOOKED_LOADING.MLO_VESSEL%TYPE
                              ,P_I_V_MLO_VOYAGE              TOS_LL_BOOKED_LOADING.MLO_VOYAGE%TYPE
                              ,P_I_V_MLO_VESSEL_ETA          DATE
                              ,P_I_V_MLO_POD1                TOS_LL_BOOKED_LOADING.MLO_POD1%TYPE
                              ,P_I_V_MLO_POD2                TOS_LL_BOOKED_LOADING.MLO_POD2%TYPE
                              ,P_I_V_MLO_POD3                TOS_LL_BOOKED_LOADING.MLO_POD3%TYPE
                              ,P_I_V_MLO_DEL                 TOS_LL_BOOKED_LOADING.MLO_DEL%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_1  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_2  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_3  TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3%TYPE
                              ,P_I_V_CONTAINER_LOADING_REM_1 TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1%TYPE
                              ,P_I_V_CONTAINER_LOADING_REM_2 TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG1  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG1%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG2  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG2%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG3  TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG3%TYPE
                              ,P_I_V_FUMIGATION_ONLY         TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY%TYPE
                              ,P_I_V_RESIDUE_ONLY_FLAG       TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG%TYPE
                              ,P_I_V_FK_BKG_SIZE_TYPE_DTL    TOS_LL_BOOKED_LOADING.FK_BKG_SIZE_TYPE_DTL%TYPE
                              ,P_I_V_FK_BKG_SUPPLIER         TOS_LL_BOOKED_LOADING.FK_BKG_SUPPLIER%TYPE
                              ,P_I_V_FK_BKG_EQUIPM_DTL       TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE
                              ,P_O_V_ERR_CD                  OUT VARCHAR2);
  /* *17 start * */
  PROCEDURE PRE_UPD_MLO_DETAIL(P_I_V_LIST_ID VARCHAR2
                              ,P_I_V_USER_ID VARCHAR2
                              ,P_I_V_DATE    VARCHAR2 /* format YYYYMMDDHH24MISS */);
  /* *17 end * */
  /* *23 start * */
  PROCEDURE PRE_FIND_DISCHARGE_LIST(P_I_V_BOOKING       VARCHAR2
                                   ,P_I_V_VESSEL        VARCHAR2
                                   ,P_I_V_EQUIPMENT     VARCHAR2
                                   ,P_O_V_FLAG          OUT NOCOPY VARCHAR2
                                   ,P_O_V_BOOKED_DIS_ID OUT NOCOPY VARCHAR2
                                   ,P_O_V_ERR_CD        OUT NOCOPY VARCHAR2);

  /* *23 end * */

  /* *24 end * */
  PROCEDURE PRE_ELL_OL_VAL_PORT_CLASS_TYPE(P_I_V_PORT_CODE       VARCHAR2
                                          ,P_I_V_PORT_CLASS_TYPE VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO    VARCHAR2
                                          ,P_O_V_ERR_CD          OUT VARCHAR2);
  /* *24 end * */

  /* *26, *27 start * */
  PROCEDURE PRE_LOG_PORTCLASS_CHANGE(P_I_V_BOOKED_LL_DL_ID     NUMBER
                                    ,P_I_V_PORT_CLASS          VARCHAR
                                    ,P_I_V_IMDG                VARCHAR
                                    ,P_I_V_UNNO                VARCHAR
                                    ,P_I_V_UN_VAR              VARCHAR
                                    ,P_I_V_LOAD_DISCHARGE_FLAG VARCHAR
                                    ,P_I_V_USER_ID             VARCHAR);
  /* *26 end * */
  PROCEDURE PRE_ELL_BOOKED_SUMMARY(P_O_REFBOOKEDTABSUMMARY OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                  ,P_I_V_LOAD_LIST_ID      IN VARCHAR2
                                  ,P_O_V_ERROR             OUT VARCHAR2);
--*29 begin

--*29 end

END PCE_ELL_LLMAINTENANCE;
