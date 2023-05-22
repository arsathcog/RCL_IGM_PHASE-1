CREATE OR REPLACE PACKAGE VASAPPS.PCE_EDL_DLMAINTENANCE AS
  /* -----------------------------------------------------------------------------
  System  : RCL-EZLL
  Module  : Discharge List
  Prog ID : EDL002 - PCE_EDL_DLMAINTENANCE.sql
  Name    : Discharge List Maintenance
  Purpose : Allows to maintain Discharge List
  --------------------------------------------------------------------------------
  History : None
  --------------------------------------------------------------------------------
  Author                Date                      What
  --------------- --------------- ------------------------------------------------
  NTL)Vikas Verma     07/01/2011        <Initial version>
  --Change Log--------------------------------------------------------------------
  DD/MM/YY     User-Task/CR No -Short Description-
  *9: Added by vikas, When matching fails then download an excel shows the booked and overlanded
      container details, as k'chatgamol, 15.03.2012
  *10: Added by vikas, to get cran value in booked tab, as k'chatamol, 27.03.2012
  *17: Modified by vikas, All bookings in the DL/LL must be closed if status is changed to
      'Ready for Invoice' and 'Work Complete', as k'chatgamol, 12.06.2012
  *24: Modified by vikas, When changing list status from open to load completer or higher,
     check duplicate cell location, as k'chatgamol, 27.12.2012
  *26: Added by vikas, When update the load/Discharge list status  > Loading Complete
       System need to check if there�s the bundle booking then, Check the
       configuration table to check the type of bundle calculation/terminal,
       If no terminal found or it�s not = "EBP" then sytem need to check that
       for one booking there must be at least one container update the
       Load_Status as "Base", as k'chatgamol, 15.01.2013
    *27 Add new paramter for CR add VGM and Category. 06/06/2016 by Saisuda
   
  
  ----------------------------------------------------------------------------- */

  G_EXP_UPD_ANOTHER_USR EXCEPTION;

  PROCEDURE PRV_EDL_SET_BOOKING_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                       ,P_I_V_DISCHARGE_ID IN VARCHAR2
                                       ,P_I_V_USER_ID      IN VARCHAR2
                                       ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRV_EDL_SET_OVERLANDED_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                          ,P_I_V_DISCHARGE_ID IN VARCHAR2
                                          ,P_I_V_USER_ID      IN VARCHAR2
                                          ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRV_EDL_SET_RESTOW_TO_TEMP(P_I_V_SESSION_ID   IN VARCHAR2
                                      ,P_I_V_DISCHARGE_ID IN VARCHAR2
                                      ,P_I_V_USER_ID      IN VARCHAR2
                                      ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRV_EDL_CLR_TMP(P_I_V_SESSION_ID IN VARCHAR2
                           ,P_I_V_USER_ID    IN VARCHAR2
                           ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRV_EDL_GET_PREV_PORT_VAL(P_O_V_HDRPREVPORT OUT VARCHAR2
                                     ,P_I_V_HDR_PORT    IN VARCHAR2
                                     ,P_I_V_HDR_SERVICE IN VARCHAR2
                                     ,P_I_V_HDR_VESSEL  IN VARCHAR2
                                     ,P_I_V_HDR_VOYAGE  IN VARCHAR2
                                     ,P_I_V_HDR_ETA     IN VARCHAR2
                                     ,P_I_V_HDR_ETA_TM  IN VARCHAR2
                                      
                                     ,P_O_V_ERR_CD OUT VARCHAR2);

  PROCEDURE PRE_EDL_BOOKED_TAB_FIND(P_O_REFBOOKEDTABFIND    OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                   ,P_I_V_SESSION_ID        IN VARCHAR2
                                   ,P_I_V_FIND1             IN VARCHAR2
                                   ,P_I_V_IN1               IN VARCHAR2
                                   ,P_I_V_FIND2             IN VARCHAR2
                                   ,P_I_V_IN2               IN VARCHAR2
                                   ,P_I_V_ORDER1            IN VARCHAR2
                                   ,P_I_V_ORDER1ORDER       IN VARCHAR2
                                   ,P_I_V_ORDER2            IN VARCHAR2
                                   ,P_I_V_ORDER2ORDER       IN VARCHAR2
                                   ,P_I_V_DISCHARGE_LIST_ID IN VARCHAR2
                                   ,P_O_V_TOT_REC           OUT VARCHAR2
                                   ,P_O_V_ERROR             OUT VARCHAR2);

  PROCEDURE PRE_EDL_OVERLANDED_TAB_FIND(P_O_REFOVERLANDEDTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                       ,P_I_V_SESSION_ID         IN VARCHAR2
                                       ,P_I_V_FIND1              IN VARCHAR2
                                       ,P_I_V_IN1                IN VARCHAR2
                                       ,P_I_V_FIND2              IN VARCHAR2
                                       ,P_I_V_IN2                IN VARCHAR2
                                       ,P_I_V_ORDER1             IN VARCHAR2
                                       ,P_I_V_ORDER1ORDER        IN VARCHAR2
                                       ,P_I_V_ORDER2             IN VARCHAR2
                                       ,P_I_V_ORDER2ORDER        IN VARCHAR2
                                       ,P_I_V_DISCHARGE_LIST_ID  IN VARCHAR2
                                       ,P_O_V_TOT_REC            OUT VARCHAR2
                                       ,P_O_V_ERROR              OUT VARCHAR2);

  PROCEDURE PRE_EDL_RESTOWED_TAB_FIND(P_O_REFRESTOWEDTABFIND  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                     ,P_I_V_SESSION_ID        IN VARCHAR2
                                     ,P_I_V_FIND1             IN VARCHAR2
                                     ,P_I_V_IN1               IN VARCHAR2
                                     ,P_I_V_FIND2             IN VARCHAR2
                                     ,P_I_V_IN2               IN VARCHAR2
                                     ,P_I_V_ORDER1            IN VARCHAR2
                                     ,P_I_V_ORDER1ORDER       IN VARCHAR2
                                     ,P_I_V_ORDER2            IN VARCHAR2
                                     ,P_I_V_ORDER2ORDER       IN VARCHAR2
                                     ,P_I_V_DISCHARGE_LIST_ID IN VARCHAR2
                                     ,P_O_V_TOT_REC           OUT VARCHAR2
                                     ,P_O_V_ERROR             OUT VARCHAR2);

  PROCEDURE PRE_EDL_SUMMARY_TAB_FIND(P_O_REFSUMMARYTABFIND OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,P_I_V_DISCHARGE_ID    VARCHAR2
                                    ,P_O_V_TOT_REC         OUT VARCHAR2
                                    ,P_O_V_ERROR           OUT VARCHAR2);

  PROCEDURE ADDITION_WHERE_CONDTIONS(P_I_V_IN   IN VARCHAR2
                                    ,P_I_V_FIND IN VARCHAR2
                                    ,P_I_V_TAB  IN VARCHAR2);

  PROCEDURE PRE_EDL_SAVE_RESTOW_TAB_DATA(P_I_V_SESSION_ID             IN VARCHAR2
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
                                        ,P_I_V_DISCHARGE_LIST_ID      IN VARCHAR2
                                        ,P_I_V_OPN_STS                IN VARCHAR2
                                        ,P_I_V_CONTAINER_GROSS_WEIGHT IN VARCHAR2
                                        ,P_I_V_DAMAGED                IN VARCHAR2
                                        ,P_I_V_SEAL_NO                IN VARCHAR2
                                        ,P_O_V_ERROR                  OUT VARCHAR2);

  PROCEDURE PRE_EDL_SAVE_OVERLAND_TAB_DATA(P_I_V_SESSION_ID              VARCHAR2
                                          ,P_I_V_SEQ_NO                  IN OUT VARCHAR2
                                          ,P_I_V_OVERLANDED_CONTAINER_ID VARCHAR2
                                          ,P_I_V_DISCHARGE_LIST_ID       VARCHAR2
                                          ,P_I_V_BOOKING_NO              VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO            VARCHAR2
                                          ,P_I_V_EQ_SIZE                 VARCHAR2
                                          ,P_I_V_EQ_TYPE                 VARCHAR2
                                          ,P_I_V_FULL_MT                 VARCHAR2
                                          ,P_I_V_BKG_TYP                 VARCHAR2
                                          ,P_I_V_FLAG_SOC_COC            VARCHAR2
                                          ,P_I_V_SHIPMENT_TERM           VARCHAR2
                                          ,P_I_V_SHIPMENT_TYP            VARCHAR2
                                          ,P_I_V_LOCAL_STATUS            VARCHAR2
                                          ,P_I_V_LOCAL_TERMINAL_STATUS   VARCHAR2
                                          ,P_I_V_MIDSTREAM_HANDLING_CODE VARCHAR2
                                          ,P_I_V_LOAD_CONDITION          VARCHAR2
                                          ,P_I_V_STOWAGE_POSITION        VARCHAR2
                                          ,P_I_V_ACTIVITY_DATE_TIME      VARCHAR2
                                          ,P_I_V_CONTAINER_GROSS_WEIGHT  VARCHAR2
                                          ,P_I_V_DAMAGED                 VARCHAR2
                                          ,P_I_V_SLOT_OPERATOR           VARCHAR2
                                          ,P_I_V_CONTAINER_OPERATOR      VARCHAR2
                                          ,P_I_V_OUT_SLOT_OPERATOR       VARCHAR2
                                          ,P_I_V_SPECIAL_HANDLING        VARCHAR2
                                          ,P_I_V_SEAL_NO                 VARCHAR2
                                          ,P_I_V_POL                     VARCHAR2
                                          ,P_I_V_POL_TERMINAL            VARCHAR2
                                          ,P_I_V_NXT_SRV                 VARCHAR2
                                          ,P_I_V_NXT_VESSEL              VARCHAR2
                                          ,P_I_V_NXT_VOYAGE              VARCHAR2
                                          ,P_I_V_NXT_DIR                 VARCHAR2
                                          ,P_I_V_MLO_VESSEL              VARCHAR2
                                          ,P_I_V_MLO_VOYAGE              VARCHAR2
                                          ,P_I_V_MLO_VESSEL_ETA          VARCHAR2
                                          ,P_I_V_MLO_POD1                VARCHAR2
                                          ,P_I_V_MLO_POD2                VARCHAR2
                                          ,P_I_V_MLO_POD3                VARCHAR2
                                          ,P_I_V_MLO_DEL                 VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_1  VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_2  VARCHAR2
                                          ,P_I_V_HANDLING_INSTRUCTION_3  VARCHAR2
                                          ,P_I_V_CONTAINER_LOADING_REM_1 VARCHAR2
                                          ,P_I_V_CONTAINER_LOADING_REM_2 VARCHAR2
                                          ,P_I_V_SPECIAL_CARGO           VARCHAR2
                                          ,P_I_V_IMDG_CLASS              VARCHAR2
                                          ,P_I_V_UN_NUMBER               VARCHAR2
                                          ,P_I_V_UN_VAR                  VARCHAR2
                                          ,P_I_V_PORT_CLASS              VARCHAR2
                                          ,P_I_V_PORT_CLASS_TYP          VARCHAR2
                                          ,P_I_V_FLASHPOINT_UNIT         VARCHAR2
                                          ,P_I_V_FLASHPOINT              VARCHAR2
                                          ,P_I_V_FUMIGATION_ONLY         VARCHAR2
                                          ,P_I_V_RESIDUE_ONLY_FLAG       VARCHAR2
                                          ,P_I_V_OVERHEIGHT_CM           VARCHAR2
                                          ,P_I_V_OVERWIDTH_LEFT_CM       VARCHAR2
                                          ,P_I_V_OVERWIDTH_RIGHT_CM      VARCHAR2
                                          ,P_I_V_OVERLENGTH_FRONT_CM     VARCHAR2
                                          ,P_I_V_OVERLENGTH_REAR_CM      VARCHAR2
                                          ,P_I_V_REEFER_TEMPERATURE      VARCHAR2
                                          ,P_I_V_REEFER_TMP_UNIT         VARCHAR2
                                          ,P_I_V_HUMIDITY                VARCHAR2
                                          ,P_I_V_VENTILATION             VARCHAR2
                                          ,P_I_V_DISCHARGE_STATUS        VARCHAR2
                                          ,P_I_V_USER_ID                 VARCHAR2
                                          ,P_I_V_OPN_STS                 VARCHAR2
                                          ,P_O_V_ERROR                   OUT VARCHAR2);

  PROCEDURE PRE_EDL_SAVE_BOOKED_TAB_DATA(P_I_V_SESSION_ID              VARCHAR2
                                        ,P_I_V_SEQ_NO                  VARCHAR2
                                        ,P_I_V_DISCHARGE_LIST_ID       VARCHAR2
                                        ,P_I_V_DN_EQUIPMENT_NO         VARCHAR2
                                        ,P_I_V_LOCAL_TERMINAL_STATUS   VARCHAR2
                                        ,P_I_V_MIDSTREAM_HANDLING_CODE VARCHAR2
                                        ,P_I_V_LOAD_CONDITION          VARCHAR2
                                        ,P_I_V_DISCHARGE_STATUS        VARCHAR2
                                        ,P_I_V_STOWAGE_POSITION        VARCHAR2
                                        ,P_I_V_ACTIVITY_DATE_TIME      VARCHAR2
                                        ,P_I_V_CONTAINER_GROSS_WEIGHT  VARCHAR2
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
                                        ,P_I_V_SWAP_CONNECTION_ALLOWED VARCHAR2
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
                                        ,P_I_V_RESIDUE_ONLY_FLAG       VARCHAR2
                                        ,P_I_V_HUMIDITY                VARCHAR2
                                        ,P_I_V_VENTILATION             VARCHAR2
                                        ,P_I_V_CRAN_DESCRIPTION        VARCHAR2 -- #10
                                        ,P_O_V_ERROR                   OUT VARCHAR2);

  PROCEDURE PRE_EDL_DEL_OVERLANDED_DATA(P_I_V_SESSION_ID IN VARCHAR2
                                       ,P_I_V_SEQ_NO     IN VARCHAR2
                                       ,P_I_V_OPN_STS    IN VARCHAR2
                                       ,P_I_V_USER_ID    IN VARCHAR2
                                       ,P_O_V_ERR_CD     OUT VARCHAR2);

  PROCEDURE PRE_EDL_DEL_RESTOWED_TAB_DATA(P_I_V_SESSION_ID IN VARCHAR2
                                         ,P_I_V_SEQ_NO     IN VARCHAR2
                                         ,P_I_V_OPN_STS    IN VARCHAR2
                                         ,P_I_V_USER_ID    IN VARCHAR2
                                         ,P_O_V_ERR_CD     OUT VARCHAR2);

  -- Save data from temp to main.
  PROCEDURE PRE_EDL_SAVE_TEMP_TO_MAIN(P_I_V_SESSION_ID            IN VARCHAR2
                                     ,P_I_V_USER_ID               IN VARCHAR2
                                     ,P_I_V_DISCHARGE_LIST_STATUS IN VARCHAR2
                                     ,P_I_V_DISCHARGE_LIST_ID     IN VARCHAR2
                                     ,P_I_V_DISCHARGE_ETA         IN VARCHAR2
                                     ,P_I_V_VESSEL                IN VARCHAR2
                                     ,P_I_V_HDR_ETA_TM            IN VARCHAR2
                                     ,P_I_V_HDR_PORT              IN VARCHAR2
                                     ,P_I_V_DISCHARGE_ETD         IN VARCHAR2
                                     ,P_I_V_HDR_ETD_TM            IN VARCHAR2
                                     ,P_O_V_ERR_CD                OUT VARCHAR2);

  PROCEDURE PRE_EDL_SAVE_BOOKED_TAB_MAIN(P_I_V_SESSION_ID    IN VARCHAR2
                                        ,P_I_V_USER_ID       IN VARCHAR2
                                        ,P_I_V_PORT_CODE     IN VARCHAR2
                                        ,P_I_V_DISCHARGE_ETD IN VARCHAR2
                                        ,P_I_V_HDR_ETD_TM    IN VARCHAR2
                                        ,P_I_V_VESSEL        IN VARCHAR2
                                        ,P_I_V_DATE          IN VARCHAR2
                                        ,P_I_V_DISCHARGE_ETA IN VARCHAR2
                                        ,P_I_V_HDR_ETA_TM    IN VARCHAR2
                                        ,P_O_V_ERR_CD        OUT VARCHAR2);

  PROCEDURE PRE_EDL_SAVE_OVERLAND_TAB_MAIN(P_I_V_SESSION_ID    IN VARCHAR2
                                          ,P_I_V_USER_ID       IN VARCHAR2
                                          ,P_I_V_VESSEL        IN VARCHAR2
                                          ,P_I_V_DISCHARGE_ETD IN VARCHAR2
                                          ,P_I_V_HDR_ETD_TM    IN VARCHAR2
                                          ,P_I_V_PORT_CODE     IN VARCHAR2
                                          ,P_I_V_DATE          IN VARCHAR2
                                          ,P_I_V_DISCHARGE_ETA IN VARCHAR2
                                          ,P_I_V_HDR_ETA_TM    IN VARCHAR2
                                          ,P_O_V_ERR_CD        OUT VARCHAR2);

  PROCEDURE PRE_EDL_SAVE_RESTOW_TAB_MAIN(P_I_V_SESSION_ID    VARCHAR2
                                        ,P_I_V_USER_ID       VARCHAR2
                                        ,P_I_V_VESSEL        VARCHAR2
                                        ,P_I_V_DISCHARGE_ETA VARCHAR2
                                        ,P_I_V_HDR_ETA_TM    VARCHAR2
                                        ,P_I_V_HDR_PORT      VARCHAR2
                                        ,P_I_V_DISCHARGE_ETD VARCHAR2
                                        ,P_I_V_HDR_ETD_TM    VARCHAR2
                                        ,P_I_V_DATE          VARCHAR2
                                        ,P_O_V_ERR_CD        OUT VARCHAR2);

  PROCEDURE PRE_EDL_BOOKED_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                     ,P_I_ROW_NUM             NUMBER
                                     ,P_I_V_DISCHARGE_LIST_ID VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                     ,P_I_V_PK_DISCHARGE_LIST VARCHAR2
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
                                     ,P_I_V_DN_FULL_MT        VARCHAR2
                                     ,P_I_V_DISCHARGE_ETD     VARCHAR2
                                     ,P_I_V_HDR_ETD_TM        VARCHAR2
                                     ,P_O_V_ERR_CD            OUT VARCHAR2);

  PROCEDURE PRE_EDL_OVERLANDED_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                         ,P_I_ROW_NUM             VARCHAR2
                                         ,P_I_V_DISCHARGE_LIST_ID VARCHAR2
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
                                         ,P_I_V_DISCHARGE_ETD     VARCHAR2
                                         ,P_I_V_HDR_ETD_TM        VARCHAR2
                                         ,P_I_V_EQUIP_TYPE        VARCHAR2
                                         ,P_I_V_POL_CODE          VARCHAR2
                                         ,P_I_V_POL_TERMINAL_CODE VARCHAR2
                                         ,P_O_V_ERR_CD            OUT VARCHAR2);

  PROCEDURE PRE_EDL_RESTOW_VALIDATION(P_I_V_SESSION_ID        VARCHAR2
                                     ,P_I_ROW_NUM             NUMBER
                                     ,P_I_V_DISCHARGE_LIST_ID VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO      VARCHAR2
                                     ,P_I_V_RESTOW_ID         VARCHAR2
                                     ,P_I_V_DISCHARGE_ETD     VARCHAR2
                                     ,P_I_V_HDR_ETD_TM        VARCHAR2
                                     ,P_I_V_HDR_PORT          VARCHAR2
                                     ,P_I_V_SOC_COC           VARCHAR2
                                     ,P_O_V_ERR_CD            OUT VARCHAR2);

  PROCEDURE PRE_EDL_SYNCH_BOOKING(P_I_V_PK_BOOKED_ID        VARCHAR2
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
                                 ,P_O_V_ERR_CD              OUT VARCHAR2);

  PROCEDURE PRE_EDL_DL_STATUS_VALIDATION(P_I_V_DISCHARGE_LIST_ID     VARCHAR2
                                        ,P_I_V_DISCHARGE_LIST_STATUS VARCHAR2
                                        ,P_O_V_ERR_CD                OUT VARCHAR2);

  PROCEDURE PRE_EDL_SAVE_DL_STATUS(P_I_V_DISCHARGE_LIST_ID     VARCHAR2
                                  ,P_I_V_DISCHARGE_LIST_STATUS VARCHAR2
                                  ,P_I_V_USER_ID               VARCHAR2
                                  ,P_I_V_DATE                  VARCHAR2
                                  ,P_I_V_SESSION_ID            VARCHAR2 -- *24
                                  ,P_O_V_ERR_CD                OUT VARCHAR2);

  PROCEDURE PCV_EDL_RECORD_LOCK(P_I_V_ID       VARCHAR2
                               ,P_I_V_REC_DT   VARCHAR2
                               ,P_I_V_TAB_NAME VARCHAR2
                               ,P_O_V_ERR_CD   OUT VARCHAR2);

  /*
     PROCEDURE PRE_EDL_OL_VAL_UNNO(
            p_i_v_unno          IN VARCHAR2
          , p_i_v_variant       IN VARCHAR2
          , p_i_v_equipment_no IN  VARCHAR2
          , p_o_v_err_cd       OUT VARCHAR2
      );
  */
  PROCEDURE GET_VESSEL_OWNER_DTL(P_I_V_HDR_VESSEL VARCHAR2
                                ,P_I_V_OWNER_DTL  OUT VARCHAR2
                                ,P_I_V_VESSEL_NM  OUT VARCHAR2
                                ,P_O_V_ERR_CD     OUT VARCHAR2);

  /*
      PROCEDURE PRE_EDL_OL_VAL_PORT_CLASS(
            p_i_v_port_code        VARCHAR2
          , p_i_v_unno            VARCHAR2
          , p_i_v_variant          VARCHAR2
          , p_i_v_imdg_class       VARCHAR2
          , p_i_v_port_class      VARCHAR2
          , p_i_v_port_class_type VARCHAR2
          , p_i_v_equipment_no IN  VARCHAR2
          , p_o_v_err_cd            OUT VARCHAR2
      );
      PROCEDURE PRE_EDL_OL_VAL_IMDG(
            p_i_v_unno        IN VARCHAR2
          , p_i_v_variant     IN  VARCHAR2
          , p_i_v_imdg        IN  VARCHAR2
          , p_i_v_equipment_no IN  VARCHAR2
          , p_o_v_err_cd      OUT VARCHAR2
      ) ;
  */

  PROCEDURE PRE_EDL_OL_VAL_HAND_CODE(P_I_V_SHI_CODE     IN VARCHAR2
                                    ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                    ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_EDL_OL_VAL_OPERATOR_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                        ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                        ,P_O_V_ERR_CD       OUT VARCHAR2);
  PROCEDURE PRE_EDL_OL_VAL_CLR_CODE(P_I_V_CLR_CODE     IN VARCHAR2
                                   ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                   ,P_O_V_ERR_CD       OUT VARCHAR2);
  PROCEDURE PRE_EDL_VAL_EQUIPMENT_TYPE(P_I_V_OPER_CD      IN VARCHAR2
                                      ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                      ,P_O_V_ERR_CD       OUT VARCHAR2);
  PROCEDURE PRE_EDL_VAL_PORT_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                 ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                 ,P_O_V_ERR_CD       OUT VARCHAR2);
  PROCEDURE PRE_EDL_VAL_PORT_TERMINAL_CODE(P_I_V_OPER_CD      IN VARCHAR2
                                          ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                          ,P_O_V_ERR_CD       OUT VARCHAR2);

  PROCEDURE PRE_DL_COMMON_MATCHING(P_I_V_MATCH_TYPE              VARCHAR2
                                  ,P_I_V_DISCHARGE_LIST_ID       NUMBER
                                  ,P_I_V_DL_CONTAINER_SEQ        NUMBER
                                  ,P_I_V_OVERLANDED_CONTAINER_ID NUMBER
                                  ,P_I_V_EQUIPMENT_NO            VARCHAR2
                                  ,P_O_V_ERR_CD                  OUT NOCOPY VARCHAR2);

  PROCEDURE PRE_DL_CONT_REMARK_COMBO(P_O_REFCOMBODATA OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,P_O_V_ERR_CD     OUT NOCOPY VARCHAR2);

  /*    Check for the shipment term */
  PROCEDURE PRE_SHIPMENT_TERM_OL_CODE(P_I_V_SHIPMNT_CD   VARCHAR2
                                     ,P_I_V_EQUIPMENT_NO IN VARCHAR2
                                     ,P_O_V_ERR_CD       OUT VARCHAR2);

  FUNCTION FN_EDL_DATE_COMPARE(P_I_V_DATE1 VARCHAR2
                              ,P_I_V_TIME1 VARCHAR2
                              ,P_I_V_DATE2 VARCHAR2
                              ,P_I_V_TIME2 VARCHAR2
                              ,P_I_V_PORT  VARCHAR2) RETURN NUMBER;

  FUNCTION FN_EDL_CONVERTDATE(P_I_V_DATE VARCHAR2
                             ,P_I_V_TIME VARCHAR2
                             ,P_I_V_PORT VARCHAR2) RETURN DATE;

  PROCEDURE PRE_EDL_PREV_LOAD_LIST_ID(P_I_V_VESSEL        VARCHAR2
                                     ,P_I_V_EQUIP_NO      VARCHAR2
                                     ,P_I_V_BOOKING_NO    VARCHAR2
                                     ,P_I_V_ETA_DATE      VARCHAR2
                                     ,P_I_V_ETA_TM        VARCHAR2
                                     ,P_I_PORT_CODE       VARCHAR2
                                     ,P_I_V_PORT_SEQ      VARCHAR2
                                     ,P_O_V_PK_LOADING_ID OUT VARCHAR2
                                     ,P_O_V_FLAG          OUT VARCHAR2
                                     ,P_O_V_ERR_CD        OUT VARCHAR2);

  PROCEDURE PRE_EDL_NEXT_DISCHARGE_LIST_ID(P_I_V_VESSEL              VARCHAR2
                                          ,P_I_V_EQUIP_NO            VARCHAR2
                                          ,P_I_V_BOOKING_NO          VARCHAR2
                                          ,P_I_V_ETD_DATE            VARCHAR2
                                          ,P_I_V_ETD_TM              VARCHAR2
                                          ,P_I_PORT_CODE             VARCHAR2
                                          ,P_I_V_FK_PORT_SEQUENCE_NO VARCHAR2
                                          ,P_O_V_PK_DISCHARGE_ID     OUT VARCHAR2
                                          ,P_O_V_FLAG                OUT VARCHAR2
                                          ,P_O_V_ERR_CD              OUT VARCHAR2);

  /*Start added by vikas as logic is changed, 22.11.2011*/
  PROCEDURE PRE_NEXT_DISCHARGE_LIST_ID(P_I_V_BOOKING_NO    VARCHAR2
                                      ,P_I_V_EQUIP_NO      VARCHAR2
                                      ,P_I_V_TERMINAL      VARCHAR2 -- dn_discharge_terminal
                                      ,P_I_V_PORT          VARCHAR2 -- dn_discharge_port
                                      ,P_O_V_BOOKED_DIS_ID OUT VARCHAR2
                                      ,P_O_V_FLAG          OUT VARCHAR2
                                      ,P_O_V_ERR_CD        OUT VARCHAR2);

  /* Start added by vikas, new logic give by k'Chatgamol, 22.11.2011 */
  PROCEDURE PRE_PREV_LOAD_LIST_ID(P_I_V_BOOKING_NO    VARCHAR2
                                 ,P_I_V_EQUIP_NO      VARCHAR2
                                 ,P_I_V_TERMINAL      VARCHAR2 -- dn_pol_terminal
                                 ,P_I_V_PORT          VARCHAR2 -- dn_pol
                                 ,P_O_V_BOOKED_DIS_ID OUT VARCHAR2
                                 ,P_O_V_FLAG          OUT VARCHAR2
                                 ,P_O_V_ERR_CD        OUT VARCHAR2);

  PROCEDURE PRE_EDL_PREV_LOADED_EQUIP_ID(P_I_V_EQUIP_NO      VARCHAR2
                                        ,P_I_V_ETA_DATE      VARCHAR2
                                        ,P_I_V_ETA_TM        VARCHAR2
                                        ,P_O_V_PK_LOADING_ID OUT VARCHAR2
                                        ,P_O_V_FLAG          OUT VARCHAR2
                                        ,P_O_V_ERR_CD        OUT VARCHAR2);

  PROCEDURE PRE_TOS_REMOVE_ERROR(P_I_V_DA_ERROR             VARCHAR2
                                ,P_I_V_LL_DL_FLAG           VARCHAR2
                                ,P_I_V_SIZE                 VARCHAR2
                                ,P_I_V_CLR1                 VARCHAR2
                                ,P_I_V_CLR2                 VARCHAR2
                                ,P_I_V_EQUIPMENT_NO         VARCHAR2
                                ,P_I_V_PK_OVERLANDED_ID     VARCHAR2
                                ,P_I_V_FK_DISCHARGE_LIST_ID VARCHAR2
                                ,P_O_V_ERR_CD               OUT VARCHAR2);

  PROCEDURE PRE_EDL_POD_UPDATE(P_I_V_PK_BOOKED_ID            TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID%TYPE
                              ,P_I_V_FK_BOOKING_NO           TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE
                              ,P_I_V_LLDL_FLAG               VARCHAR2
                              ,P_I_V_FK_BKG_VOYAGE_ROUT_DTL  TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
                              ,P_I_V_LOAD_CONDITION          TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION%TYPE
                              ,P_I_V_CONTAINER_GROSS_WEIGHT  TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT%TYPE
                              --*27 begin
                             -- ,P_I_V_VGM TOS_DL_BOOKED_DISCHARGE.VGM%TYPE
                              ,P_I_V_CATEGORY TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE%TYPE
                              --*27 end
                              ,P_I_V_DAMAGED                 TOS_DL_BOOKED_DISCHARGE.DAMAGED%TYPE
                              ,P_I_V_FK_CONTAINER_OPERATOR   TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR%TYPE
                              ,P_I_V_OUT_SLOT_OPERATOR       TOS_DL_BOOKED_DISCHARGE.OUT_SLOT_OPERATOR%TYPE
                              ,P_I_V_SEAL_NO                 TOS_DL_BOOKED_DISCHARGE.SEAL_NO%TYPE
                              ,P_I_V_MLO_VESSEL              TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL%TYPE
                              ,P_I_V_MLO_VOYAGE              TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE%TYPE
                              ,P_I_V_MLO_VESSEL_ETA          DATE
                              ,P_I_V_MLO_POD1                TOS_DL_BOOKED_DISCHARGE.MLO_POD1%TYPE
                              ,P_I_V_MLO_POD2                TOS_DL_BOOKED_DISCHARGE.MLO_POD2%TYPE
                              ,P_I_V_MLO_POD3                TOS_DL_BOOKED_DISCHARGE.MLO_POD3%TYPE
                              ,P_I_V_MLO_DEL                 TOS_DL_BOOKED_DISCHARGE.MLO_DEL%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_1  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_2  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2%TYPE
                              ,P_I_V_FK_HANDL_INSTRUCTION_3  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3%TYPE
                              ,P_I_V_CONTAINER_LOADING_REM_1 TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1%TYPE
                              ,P_I_V_CONTAINER_LOADING_REM_2 TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG1  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG2  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2%TYPE
                              ,P_I_V_TIGHT_CONNECTION_FLAG3  TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3%TYPE
                              ,P_I_V_FUMIGATION_ONLY         TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY%TYPE
                              ,P_I_V_RESIDUE_ONLY_FLAG       TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG%TYPE
                              ,P_I_V_FK_BKG_SIZE_TYPE_DTL    TOS_DL_BOOKED_DISCHARGE.FK_BKG_SIZE_TYPE_DTL%TYPE
                              ,P_I_V_FK_BKG_SUPPLIER         TOS_DL_BOOKED_DISCHARGE.FK_BKG_SUPPLIER%TYPE
                              ,P_I_V_FK_BKG_EQUIPM_DTL       TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL%TYPE
                              ,P_O_V_ERR_CD                  OUT VARCHAR2);

  /*
      *9: changes start
  */
  PROCEDURE PRE_EDI_ERRRO_MSG(P_O_REFEDI    OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                             ,P_I_V_LIST_ID VARCHAR2
                             ,P_I_V_FLAG    VARCHAR2
                             ,P_O_V_ERR_CD  OUT VARCHAR2);
  /*
      *9: Changes end
      *17: Changes start
  */
  PROCEDURE PRE_LIST_OPEN_BOOOKINGS(P_I_V_LIST_ID    VARCHAR2
                                   ,P_I_V_LL_DL_FLAG VARCHAR2
                                   ,P_O_V_BOOKING    OUT NOCOPY VARCHAR2);
  /*
      *17: changes end
  */

  /* *24 start * */
  PROCEDURE PRE_CHECK_DUP_CELL_LOCATION(P_I_V_SESSION_ID VARCHAR2
                                       ,P_I_V_FLAG       VARCHAR2
                                       ,P_I_V_LIST_ID    VARCHAR2
                                       ,P_O_V_ERR_CD     OUT VARCHAR2);
  /* *24 end * */

  /* *26 start * */
  PROCEDURE PRE_BUNDLE_UPDATE_VALIDATION(P_I_V_LIST_ID  VARCHAR2
                                        ,P_I_V_FLAG     VARCHAR2
                                        ,P_O_V_BOOKINGS OUT VARCHAR2);
  /* *26 end * */
END PCE_EDL_DLMAINTENANCE;
/