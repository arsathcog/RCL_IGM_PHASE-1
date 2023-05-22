create or replace
PROCEDURE         "PRR_TOS_INS_OB_LIST" (
    p_i_v_fk_load_list_id INTEGER ,
    p_i_v_user_id         VARCHAR2 ,
    p_i_v_fk_bkg_no       VARCHAR2 ,
    p_i_v_dn_eqp_no       VARCHAR2 ,
    p_i_v_seq_no          NUMBER ,
    p_i_v_service         VARCHAR2 ,
    p_i_v_vessel          VARCHAR2 ,
    p_i_v_voyage          VARCHAR2 ,
    p_i_v_dir             VARCHAR2 ,
    p_i_v_port_seq        NUMBER ,
    p_i_v_port            VARCHAR2 ,
    P_I_V_Term            Varchar2 )

/*------------------------------------------------------------------------------------------------------------------------------------------------
PRR_TOS_INS_OB_LIST.SQL
--------------------------------------------------------------------------------------------------------------------------------------------------
Copyright RCL Public Co., Ltd. 2007
--------------------------------------------------------------------------------------------------------------------------------------------------
- Change Log -------------------------------------------------------------------------------------------------------------------------------------
##  DD/MM/YY    –User-    -TaskRef-       -ShortDescription-
01  22/03/15    NUTTHA1   451533          DCS: jobschedulerSCHD_TOS_OB_LIST_INS_PROCESSon DCS was failed.
                                          As we discussed with K. Chatgamol, please help to trim the value to 25 chars when updating SEALINER.TOS_ONBOARD_LIST.CONNECTING_VESSEL.
------------------------------------------------------------------------------------------------------------------------------------------------*/

    
AS
  l_v_service               VARCHAR2(5 BYTE);
  l_v_vessel                VARCHAR2(5 BYTE);
  l_v_voyage                VARCHAR2(10 BYTE);
  l_v_direction             VARCHAR2(2 BYTE);
  l_v_port_seq              NUMBER(12);
  l_v_dn_port               VARCHAR2(5 BYTE);
  l_v_dn_terminal           VARCHAR2(5 BYTE);
  l_v_user_line             VARCHAR2(5 BYTE);
  l_v_user_agent            VARCHAR2(5 BYTE);
  l_v_user_trade            VARCHAR2(5 BYTE);
  l_v_pol_date              NUMBER(8);
  l_v_poL_time              NUMBER(4);
  l_v_pod_date              NUMBER(8);
  l_v_pod_time              NUMBER(4);
  l_v_pod_pcsq              NUMBER(5);
  l_v_wayport_ind           VARCHAR2(1 BYTE);
  l_v_act_vessel_code       VARCHAR2(5 BYTE);
  l_v_act_voyage_number     VARCHAR2(10 BYTE);
  l_v_act_service_direction VARCHAR2(2 BYTE);
  l_v_act_port_direction    VARCHAR2(2 BYTE);
  l_v_act_port_sequence     NUMBER(5);
  l_v_act_service_code      VARCHAR2(5 BYTE);
  l_v_sec_service           VARCHAR2(5 BYTE);
  l_v_sec_vessel            VARCHAR2(5 BYTE);
  l_v_sec_voyage            VARCHAR2(10 BYTE);
  l_v_sec_dir               VARCHAR2(2 BYTE);
  l_v_pot_port              VARCHAR2(5 BYTE);
  l_v_pot_pcsq              NUMBER(5);
  l_v_pot_date              NUMBER(8);
  l_v_pot_time              NUMBER(4);
  l_v_pot_terminal          VARCHAR2(5 BYTE);
  l_v_pot_dis_port          VARCHAR2(5 BYTE);
  l_v_pot_dis_pcsq          NUMBER(5);
  l_v_pot_dis_terminal      VARCHAR2(5 BYTE);
  l_v_prev_service          VARCHAR2(5 BYTE);
  l_v_prev_vessel           VARCHAR2(5 BYTE);
  l_v_prev_voyage           VARCHAR2(10 BYTE);
  l_v_prev_dir              VARCHAR2(2 BYTE);
  l_v_clr1_desc             VARCHAR2(100 BYTE);
  l_v_clr2_desc             VARCHAR2(100 BYTE);
  l_v_vessel_operator       VARCHAR2(4 BYTE);
  l_v_bncscd                VARCHAR2(10 BYTE);
  l_v_han1_desc             VARCHAR2(60 BYTE);
  l_v_han2_desc             VARCHAR2(60 BYTE);
  l_v_han3_desc             VARCHAR2(60 BYTE);
  l_v_bastat                VARCHAR2(1 BYTE);
  l_v_connecting_vessel     VARCHAR2(5 BYTE);  --##01
  l_v_connecting_voyno      VARCHAR2(10 BYTE); --##01
  l_error                   VARCHAR2(100);
  l_v_fsc_cd                VARCHAR2(5 BYTE);
BEGIN
  IF p_i_v_port IS NOT NULL THEN
    l_v_fsc_cd  := PKG_COMMON_LINE_TRADE_AGENT.FN_GET_PORT_FSC(p_i_v_port);
  END IF;
  IF l_v_fsc_cd   IS NOT NULL THEN
    l_v_user_line := PKG_COMMON_LINE_TRADE_AGENT.FN_GET_FSC_LINE(l_v_fsc_cd);
    l_v_user_agent:= PKG_COMMON_LINE_TRADE_AGENT.FN_GET_FSC_AGENT(l_v_fsc_cd);
    l_v_user_trade:= PKG_COMMON_LINE_TRADE_AGENT.FN_GET_FSC_TRADE(l_v_fsc_cd);
  END IF;
  l_v_service     := p_i_v_service;
  l_v_vessel      := p_i_v_vessel;
  l_v_voyage      := p_i_v_voyage;
  l_v_direction   := p_i_v_dir;
  l_v_port_seq    := p_i_v_port_seq;
  l_v_dn_port     := p_i_v_port;
  l_v_dn_terminal := p_i_v_term;
  BEGIN
    INSERT
    INTO TOS_ONBOARD_LIST
      (
        LINE ,
        TRAD ,
        AGNT ,
        POL_SERVICE ,
        POL_VESSEL ,
        POL_VOYAGE ,
        POL_DIR ,
        POL ,
        POL_PCSQ ,
        SEQ_NO ,
        LIST_STATUS ,
        POL_TERMINAL ,
        POD ,
        POD_TERMINAL ,
        BOOKING_NO ,
        CONTAINER_NO ,
        EQSIZE ,
        EQTYPE ,
        SURVEY_REQ ,
        LDSURVEY_NO ,
        LDSURVEY_DT ,
        DG_APPROVAL_NO ,
        FULL_MT ,
        WEIGHT ,
        SPECIAL_CARGO ,
        CARGO_FLAG ,
        RFTEMP ,
        UNIT ,
        IMDG ,
        FLASH_PT ,
        OOG_OH ,
        OOG_OLF ,
        OOG_OLB ,
        OOG_OWR ,
        OOG_OWL ,
        OOG_OL ,
        OOG_OW ,
        SOC_COC ,
        DELV_MODE ,
        GATE_IN ,
        ARRIVED ,
        STOW_POSITION ,
        BBK_NO_OF_CONT ,
        BBK_NO_OF_PACKAGES ,
        BBK_PACKAGE_KIND ,
        BBK_WEIGHT ,
        BBK_LENGTH ,
        BBK_BREADTH ,
        BBK_WIDTH ,
        BBK_DIAMETER ,
        KILLED_SLOT ,
        OPS_COD ,
        OPS_COD_APPNO ,
        OPS_COD_DATE ,
        NEW_POD ,
        REMARKS ,
        SEND_TO_POD ,
        CONT_STATUS ,
        DISCH_STATUS ,
        LOADING_TYPE ,
        RECORD_ADD_USER ,
        RECORD_ADD_DATE ,
        RECORD_ADD_TIME ,
        RECORD_CHANGE_USER ,
        RECORD_CHANGE_DATE ,
        RECORD_CHANGE_TIME ,
        XXRCST ,
        FLASH_PT_UNIT ,
        NEW_POD_DATE ,
        NEW_POD_PCSQ ,
        DG_FLAG ,
        OOG_FLAG ,
        RF_FLAG ,
        CONT_OPERATOR ,
        VENDOR_CODE ,
        POL_COST ,
        SHIP_TYPE ,
        SHIP_TERM ,
        POT_DISH_DATE ,
        ROB ,
        OVERLANDED ,
        DISCH_REMARKS ,
        DISCHLIST_STATUS ,
        UNNO ,
        VARIANT ,
        PSN ,
        OPR_CODE ,
        QUANTITY ,
        VOID_SLOT ,
        TOT_TEUS ,
        BISEQN ,
        BK_POL_TERMINAL ,
        POD_VOYAGE ,
        SPCARGO_REQ ,
        SP_APPROVAL_REF ,
        HAN1 ,
        HAN2 ,
        HAN3 ,
        CLR1 ,
        CLR2 ,
        SLOT_OPERATOR ,
        container_operator ,
        LOCAL_TS ,
        CONNECTING_VESSEL ,
        CONNECTING_VOYAGE_NO ,
        NEXT_POD1 ,
        NEXT_POD2 ,
        NEXT_POD3 ,
        EX_CARRIER_VESSEL ,
        EX_CARRIER_VOYAGE_NO ,
        FINAL_DESTINATION ,
        PORT_CLASS ,
        SHORT_SHIPPED ,
        ACTIVITY_CODE ,
        OPERATION_TYPE ,
        CATEGORY ,
        DEL_FLAG ,
        TIGHT_CONN_FLAG ,
        OUT_SLOT_OPERATOR,
        ERROR_STATUS ,
        DG_APPROVAL_REF ,
        DG_STOWAGE_INS
      )
    SELECT l_v_user_line     AS LINE ,
      l_v_user_trade         AS TRADE ,
      l_v_user_agent         AS AGENT ,
      l_v_service            AS POL_SERVICE ,
      l_v_vessel             AS POL_VESSEL ,
      l_v_voyage             AS POL_VOYAGE ,
      l_v_direction          AS POL_DIR ,
      l_v_dn_port            AS POL ,
      l_v_port_seq           AS pol_pcsq ,
      p_i_v_seq_no           AS SEQ_NO ,
      'C'                    AS LIST_STATUS ,
      l_v_dn_terminal        AS POL_TERMINAL ,
      DN_DISCHARGE_PORT      AS POD ,
      DN_DISCHARGE_TERMINAL  AS POD_TERMINAL ,
      FK_BOOKING_NO          AS BOOKING_NO ,
      DN_EQUIPMENT_NO        AS CONTAINER_NO ,
      DN_EQ_SIZE             AS EQSIZE ,
      DN_EQ_TYPE             AS EQTYPE ,
      NULL                   AS SURVEY_REQ ,
      NULL                   AS LDSURVEY_NO ,
      NULL                   AS LDSURVEY_DT ,
      NULL                   AS DG_APPROVAL_NO ,
      DN_FULL_MT             AS FULL_MT ,
      CONTAINER_GROSS_WEIGHT AS WEIGHT
      --, FK_SPECIAL_CARGO                          as  SPECIAL_CARGO
      ,
      DN_SPECIAL_HNDL AS SPECIAL_CARGO --##05
      ,
      NULL                AS CARGO_FLAG ,
      REEFER_TMP          AS RFTEMP ,
      REEFER_TMP_UNIT     AS UNIT ,
      FK_IMDG             AS IMDG ,
      FLASH_POINT         AS FLASH_PT ,
      OVERHEIGHT_CM       AS OOG_OH ,
      OVERLENGTH_FRONT_CM AS OOG_OLF ,
      OVERLENGTH_REAR_CM  AS OOG_OLB ,
      OVERWIDTH_RIGHT_CM  AS OOG_OWR ,
      OVERWIDTH_LEFT_CM   AS OOG_OWL ,
      NULL                AS OOG_OL ,
      NULL                AS OOG_OW ,
      DN_SOC_COC          AS SOC_COC ,
      NULL                AS DELV_MODE ,
      NULL                AS GATE_IN ,
      NULL                AS ARRIVED ,
      STOWAGE_POSITION    AS STOW_POSITION ,
      NULL                AS BBK_NO_OF_CONT ,
      NULL                AS BBK_NO_OF_PACKAGES ,
      NULL                AS BBK_PACKAGE_KIND ,
      NULL                AS BBK_WEIGHT ,
      NULL                AS BBK_LENGTH ,
      NULL                AS BBK_BREADTH ,
      NULL                AS BBK_WIDTH ,
      NULL                AS BBK_DIAMETER ,
      VOID_SLOT           AS KILLED_SLOT ,
      NULL                AS OPS_COD ,
      NULL                AS OPS_COD_APPNO ,
      NULL                AS OPS_COD_DATE ,
      NULL                AS NEW_POD ,
      PUBLIC_REMARK       AS REMARKS ,
      NULL                AS SEND_TO_POD ,
      CASE
        WHEN LOADING_STATUS = 'LO'
        THEN 'L'
        WHEN LOADING_STATUS = 'SS'
        THEN 'N'
        ELSE NULL
      END                                                                                                                                                                                                                                    AS CONT_STATUS ,
      NULL                                                                                                                                                                                                                                   AS DISCH_STATUS ,
      LOCAL_STATUS                                                                                                                                                                                                                           AS LOADING_TYPE ,
      RECORD_ADD_USER                                                                                                                                                                                                                        AS RECORD_ADD_USER ,
      TO_CHAR(SYSDATE, 'YYYYMMDD')                                                                                                                                                                                                           AS RECORD_ADD_DATE ,
      TO_CHAR(SYSDATE, 'HH24MI')                                                                                                                                                                                                             AS RECORD_ADD_TIME ,
      RECORD_CHANGE_USER                                                                                                                                                                                                                     AS RECORD_CHANGE_USER ,
      TO_CHAR(SYSDATE, 'YYYYMMDD')                                                                                                                                                                                                           AS RECORD_CHANGE_DATE ,
      TO_CHAR(SYSDATE, 'HH24MI')                                                                                                                                                                                                             AS RECORD_CHANGE_TIME ,
      NULL                                                                                                                                                                                                                                   AS XXRCST ,
      FLASH_UNIT                                                                                                                                                                                                                             AS FLASH_PT_UNIT ,
      NULL                                                                                                                                                                                                                                   AS NEW_POD_DATE ,
      NULL                                                                                                                                                                                                                                   AS NEW_POD_PCSQ ,
      NULL                                                                                                                                                                                                                                   AS DG_FLAG ,
      NULL                                                                                                                                                                                                                                   AS OOG_FLAG ,
      NULL                                                                                                                                                                                                                                   AS RF_FLAG ,
      FK_CONTAINER_OPERATOR                                                                                                                                                                                                                  AS CONT_OPERATOR ,
      NULL                                                                                                                                                                                                                                   AS VENDOR_CODE ,
      NULL                                                                                                                                                                                                                                   AS POL_COST ,
      DN_SHIPMENT_TYP                                                                                                                                                                                                                        AS SHIP_TYPE ,
      DN_SHIPMENT_TERM                                                                                                                                                                                                                       AS SHIP_TERM ,
      NULL                                                                                                                                                                                                                                   AS POT_DISH_DATE ,
      DECODE(LOADING_STATUS, 'ROB', 'Y', NULL)                                                                                                                                                                                               AS ROB ,
      NULL                                                                                                                                                                                                                                   AS OVERLANDED ,
      NULL                                                                                                                                                                                                                                   AS DISCH_REMARKS ,
      NULL                                                                                                                                                                                                                                   AS DISCHLIST_STATUS ,
      FK_UNNO                                                                                                                                                                                                                                AS UNNO ,
      FK_UN_VAR                                                                                                                                                                                                                              AS VARIANT ,
      NULL                                                                                                                                                                                                                                   AS PSN ,
      NULL                                                                                                                                                                                                                                   AS OPR_CODE ,
      NULL                                                                                                                                                                                                                                   AS QUANTITY ,
      VOID_SLOT                                                                                                                                                                                                                              AS VOID_SLOT ,
      NULL                                                                                                                                                                                                                                   AS TOT_TEUS ,
      FK_BKG_EQUIPM_DTL                                                                                                                                                                                                                      AS BISEQN ,
      l_v_dn_terminal                                                                                                                                                                                                                        AS BK_POL_TERMINAL ,
      NULL                                                                                                                                                                                                                                   AS POD_VOYAGE ,
      NULL                                                                                                                                                                                                                                   AS SPCARGO_REQ ,
      NULL                                                                                                                                                                                                                                   AS SP_APPROVAL_REF ,
      FK_HANDLING_INSTRUCTION_1                                                                                                                                                                                                              AS HAN1 ,
      FK_HANDLING_INSTRUCTION_2                                                                                                                                                                                                              AS HAN2 ,
      FK_HANDLING_INSTRUCTION_3                                                                                                                                                                                                              AS HAN3 ,
      CONTAINER_LOADING_REM_1                                                                                                                                                                                                                AS CLR1 ,
      CONTAINER_LOADING_REM_2                                                                                                                                                                                                                AS CLR2 ,
      FK_SLOT_OPERATOR                                                                                                                                                                                                                       AS SLOT_OPERATOR ,
      FK_CONTAINER_OPERATOR                                                                                                                                                                                                                  AS CONTAINER_OPERATOR ,
      LOCAL_STATUS                                                                                                                                                                                                                           AS LOCAL_TS ,
      
      --#01 BEGIN
      --Decode(Mlo_Vessel, Null, (Decode(Mlo_Voyage,Null,(Decode(Mlo_Pod1,Null,(Decode(Mlo_Pod2,Null,(Decode(Mlo_Pod3,Null,(Decode(Mlo_Del,Null,Tbl.Dn_Nxt_Vessel,Mlo_Vessel)),Mlo_Vessel)),Mlo_Vessel)),Mlo_Vessel)),Mlo_Vessel)),Mlo_Vessel) As Connecting_Vessel --##02
      SUBSTR(DECODE(Mlo_Vessel, Null, (Decode(Mlo_Voyage,Null,(Decode(Mlo_Pod1,Null,(Decode(Mlo_Pod2,Null,(Decode(Mlo_Pod3,Null,(Decode(Mlo_Del,Null,Tbl.Dn_Nxt_Vessel,Mlo_Vessel)),Mlo_Vessel)),Mlo_Vessel)),Mlo_Vessel)),Mlo_Vessel)),Mlo_Vessel),1,25) As Connecting_Vessel --##02
      --#01 END
      ,
      DECODE(MLO_VESSEL, NULL, (DECODE(MLO_VOYAGE,NULL,(DECODE(MLO_POD1,NULL,(DECODE(MLO_POD2,NULL,(DECODE(MLO_POD3,NULL,(DECODE(MLO_DEL,NULL,TBL.DN_NXT_VOYAGE,MLO_VOYAGE)),MLO_VOYAGE)),MLO_VOYAGE)),MLO_VOYAGE)),MLO_VOYAGE)),MLO_VOYAGE) AS CONNECTING_VOYAGE_NO --##02
      ,
      DECODE(MLO_VESSEL, NULL, (DECODE(MLO_VOYAGE,NULL,(DECODE(MLO_POD1,NULL,(DECODE(MLO_POD2,NULL,(DECODE(MLO_POD3,NULL,(DECODE(MLO_DEL,NULL,TBL.DN_NXT_POD1,MLO_POD1)),MLO_POD1)),MLO_POD1)),MLO_POD1)),MLO_POD1)),MLO_POD1) AS NEXT_POD1 --##02
      ,
      DECODE(MLO_VESSEL, NULL, (DECODE(MLO_VOYAGE,NULL,(DECODE(MLO_POD1,NULL,(DECODE(MLO_POD2,NULL,(DECODE(MLO_POD3,NULL,(DECODE(MLO_DEL,NULL,TBL.DN_NXT_POD2,MLO_POD2)),MLO_POD2)),MLO_POD2)),MLO_POD2)),MLO_POD2)),MLO_POD2) AS NEXT_POD2 --##02
      ,
      DECODE(MLO_VESSEL, NULL, (DECODE(MLO_VOYAGE,NULL,(DECODE(MLO_POD1,NULL,(DECODE(MLO_POD2,NULL,(DECODE(MLO_POD3,NULL,(DECODE(MLO_DEL,NULL,TBL.DN_NXT_POD3,MLO_POD3)),MLO_POD3)),MLO_POD3)),MLO_POD3)),MLO_POD3)),MLO_POD3) AS NEXT_POD3 --##02
      ,
      EX_MLO_VESSEL                                                                                                                                                                                                       AS EX_CARRIER_VESSEL ,
      SUBSTR(EX_MLO_VOYAGE,1,10)                                                                                                                                                                                                       AS EX_CARRIER_VOYAGE_NO , -- ADDED BY WACCHO ON 25/02/2015 SUBSTR(EX_MLO_VOYAGE,1,10) DUE TO EX_CARRIER_VOYAGE_NO MAX LENGTH IS 10  
      DECODE(MLO_VESSEL, NULL, (DECODE(MLO_VOYAGE,NULL,(DECODE(MLO_POD1,NULL,(DECODE(MLO_POD2,NULL,(DECODE(MLO_POD3,NULL,(DECODE(MLO_DEL,NULL,TBL.DN_FINAL_POD,MLO_DEL)),MLO_DEL)),MLO_DEL)),MLO_DEL)),MLO_DEL)),MLO_DEL) AS FINAL_DESTINATION --##02
      ,
      FK_PORT_CLASS          AS PORT_CLASS ,
      NULL                   AS SHORT_SHIPPED ,
      NULL                   AS ACTIVITY_CODE ,
      NULL                   AS OPERATION_TYPE ,
      NULL                   AS CATEGORY ,
      NULL                   AS DEL_FLAG ,
      TIGHT_CONNECTION_FLAG1 AS TIGHT_CONN_FLAG ,
      OUT_SLOT_OPERATOR      AS OUT_SLOT_OPERATOR ,
      '2'                    AS ERROR_STATUS ,
      NULL                   AS DG_APPROVAL_REF ,
      NULL                   AS DG_STOWAGE_INS
    FROM TOS_LL_BOOKED_LOADING TBL
    WHERE FK_BOOKING_NO = p_i_v_fk_bkg_no
    AND DN_EQUIPMENT_NO = p_i_v_dn_eqp_no
    AND FK_LOAD_LIST_ID = p_i_v_fk_load_list_id
    AND RECORD_STATUS   = 'A'; --#06
    COMMIT;
  EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Duplicate value found');
  WHEN TOO_MANY_ROWS THEN
   DBMS_OUTPUT.PUT_LINE('Too many records');
  END;

  BEGIN
    SELECT BVRD.POD_PCSQ                             AS POD_PCSQ ,
      DECODE(BVRD.TRUNK_WAYPORT_FLAG, 'W', 'Y', 'N') AS WAYPORT_IND ,
      BVRD.ACT_VESSEL_CODE                           AS ACT_VESSEL_CODE ,
      BVRD.ACT_VOYAGE_NUMBER                         AS ACT_VOYAGE_NUMBER ,
      BVRD.ACT_SERVICE_DIRECTION                     AS ACT_SERVICE_DIRECTION ,
      BVRD.ACT_PORT_DIRECTION                        AS ACT_PORT_DIRECTION ,
      BVRD.ACT_PORT_SEQUENCE                         AS ACT_PORT_SEQUENCE ,
      BVRD.ACT_SERVICE_CODE                          AS ACT_SERVICE_CODE
    INTO l_v_pod_pcsq ,
      l_v_wayport_ind ,
      l_v_act_vessel_code ,
      l_v_act_voyage_number ,
      l_v_act_service_direction ,
      l_v_act_port_direction ,
      l_v_act_port_sequence ,
      l_v_act_service_code
    FROM VASAPPS.TOS_LL_BOOKED_LOADING TBL ,
      BOOKING_VOYAGE_ROUTING_DTL BVRD
    WHERE TBL.FK_BOOKING_NO           = BVRD.BOOKING_NO
    AND TBL.FK_BKG_VOYAGE_ROUTING_DTL = BVRD.VOYAGE_SEQNO
    AND TBL.FK_LOAD_LIST_ID           = p_i_v_fk_load_list_id
    AND TBL.FK_BOOKING_NO             = p_i_v_fk_bkg_no
    AND TBL.DN_EQUIPMENT_NO           = p_i_v_dn_eqp_no
    AND TBL.RECORD_STATUS             = 'A' ;--#06
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No data found');
  WHEN TOO_MANY_ROWS THEN
   DBMS_OUTPUT.PUT_LINE('TOO MANY ROWS');
  END;

  BEGIN
    SELECT ITP063.VVARDT AS POL_DATE ,
      ITP063.VVARTM      AS POL_TIME
    INTO l_v_pol_date ,
      l_v_poL_time
    FROM MV_ITP063 ITP063 ,
      TOS_LL_LOAD_LIST TLL
    WHERE TLL.FK_SERVICE = ITP063.VVSRVC
    AND TLL.FK_VESSEL    = ITP063.VVVESS
    AND TLL.FK_VOYAGE    = ITP063.VVVOYN
    AND TLL.FK_PORT_SEQUENCE_NO = ITP063.VVPCSQ
    AND ITP063.VVVERS           = '99'
    AND TLL.FK_SERVICE          = l_v_service
    AND TLL.FK_VESSEL           = l_v_vessel
    AND TLL.FK_VOYAGE           = l_v_voyage
    AND TLL.FK_PORT_SEQUENCE_NO = l_v_port_seq
    AND TLL.DN_PORT             = l_v_dn_port
    AND TLL.DN_TERMINAL         = l_v_dn_terminal
    AND ITP063.VVARDT          >= NVL(
      (SELECT CONFIG_VALUE
      FROM VASAPPS.VCM_CONFIG_MST
      WHERE CONFIG_TYP = 'TABLE_FILTER'
      AND CONFIG_CD    = 'VVARDT'
      ), 0)
    AND TLL.RECORD_STATUS = 'A'; --#06
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_pol_date := NULL;
    l_v_poL_time := NULL;
  WHEN TOO_MANY_ROWS THEN
    l_v_pol_date := NULL;
    l_v_poL_time := NULL;
  END;

  BEGIN
    SELECT VVARDT AS POL_DATE ,
      VVARTM      AS POL_TIME
    INTO l_v_pod_date ,
      l_v_pod_time
    FROM MV_ITP063
    WHERE VVVERS = '99'
    AND VVSRVC   = l_v_act_service_code
    AND VVVESS   = l_v_act_vessel_code
    AND VVVOYN   = l_v_act_voyage_number
    AND VVPDIR   = l_v_act_port_direction
    AND VVPCSQ   = l_v_act_port_sequence
    AND VVARDT  >= NVL(
      (SELECT CONFIG_VALUE
      FROM VCM_CONFIG_MST
      WHERE CONFIG_TYP = 'TABLE_FILTER'
      AND CONFIG_CD    = 'VVARDT'
      ), 0);
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_pod_date := NULL;
    l_v_pod_time := NULL;
  WHEN TOO_MANY_ROWS THEN
    l_v_pod_date := NULL;
    l_v_pod_time := NULL;
  END;

  BEGIN
    SELECT NBVRD.SERVICE     AS SEC_SERVICE ,
      NBVRD.VESSEL           AS SEC_VESSEL ,
      NBVRD.VOYNO            AS SEC_VOYAGE ,
      NBVRD.DIRECTION        AS SEC_DIR ,
      NBVRD.LOAD_PORT        AS POT_PORT ,
      NBVRD.POL_PCSQ         AS POT_PCSQ ,
      NBVRD.POL_ARRIVAL_DATE AS POT_DATE ,
      NBVRD.POL_ARRIVAL_TIME AS POT_TIME ,
      NBVRD.FROM_TERMINAL    AS POT_TERMINAL ,
      NBVRD.DISCHARGE_PORT   AS POT_DIS_PORT ,
      NBVRD.POD_PCSQ         AS POT_DIS_PCSQ ,
      NBVRD.TO_TERMINAL      AS POT_DIS_TERMINAL
    INTO l_v_sec_service ,
      l_v_sec_vessel ,
      l_v_sec_voyage ,
      l_v_sec_dir ,
      l_v_pot_port ,
      l_v_pot_pcsq ,
      l_v_pot_date ,
      l_v_pot_time ,
      l_v_pot_terminal ,
      l_v_pot_dis_port ,
      l_v_pot_dis_pcsq ,
      l_v_pot_dis_terminal
    FROM
      (SELECT BVRD.SERVICE ,
        BVRD.VESSEL ,
        BVRD.VOYNO ,
        BVRD.DIRECTION ,
        BVRD.LOAD_PORT ,
        BVRD.POL_PCSQ ,
        BVRD.POL_ARRIVAL_DATE ,
        BVRD.POL_ARRIVAL_TIME ,
        BVRD.FROM_TERMINAL ,
        BVRD.DISCHARGE_PORT ,
        BVRD.POD_PCSQ ,
        BVRD.TO_TERMINAL
      FROM BOOKING_VOYAGE_ROUTING_DTL BVRD ,
        TOS_LL_BOOKED_LOADING TBL
      WHERE BVRD.BOOKING_NO   = TBL.FK_BOOKING_NO                --##03
      AND BVRD.VOYAGE_SEQNO   = TBL.FK_BKG_VOYAGE_ROUTING_DTL +1 --##03
      AND TBL.FK_LOAD_LIST_ID = p_i_v_fk_load_list_id            --##03
      AND TBL.FK_BOOKING_NO   = p_i_v_fk_bkg_no                  --##03
      AND TBL.DN_EQUIPMENT_NO = p_i_v_dn_eqp_no                  --##03
      AND TBL.RECORD_STATUS             = 'A'                    --#06
      )NBVRD;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_sec_service     :=NULL;
    l_v_sec_vessel      :=NULL;
    l_v_sec_voyage      :=NULL;
    l_v_sec_dir         :=NULL;
    l_v_pot_port        :=NULL;
    l_v_pot_pcsq        :=NULL;
    l_v_pot_date        :=NULL;
    l_v_pot_time        :=NULL;
    l_v_pot_terminal    :=NULL;
    l_v_pot_dis_port    :=NULL;
    l_v_pot_dis_pcsq    :=NULL;
    l_v_pot_dis_terminal:=NULL;
  WHEN TOO_MANY_ROWS THEN
    l_v_sec_service     :=NULL;
    l_v_sec_vessel      :=NULL;
    l_v_sec_voyage      :=NULL;
    l_v_sec_dir         :=NULL;
    l_v_pot_port        :=NULL;
    l_v_pot_pcsq        :=NULL;
    l_v_pot_date        :=NULL;
    l_v_pot_time        :=NULL;
    l_v_pot_terminal    :=NULL;
    l_v_pot_dis_port    :=NULL;
    l_v_pot_dis_pcsq    :=NULL;
    l_v_pot_dis_terminal:=NULL;

    END;
  BEGIN
    SELECT BNCSCD
    INTO l_v_bncscd
    FROM BKP030
    WHERE BNBKNO = p_i_v_fk_bkg_no
    AND BNCSTP   = 'O';
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_bncscd:=NULL;
  WHEN TOO_MANY_ROWS THEN
   l_v_bncscd:=NULL;
  END;

  BEGIN
    SELECT CLR_DESC
    INTO l_v_clr1_desc
    FROM SHP041
    WHERE CLR_CODE IN
      (SELECT CONTAINER_LOADING_REM_1
      FROM VASAPPS.TOS_LL_BOOKED_LOADING
      WHERE FK_BOOKING_NO = p_i_v_fk_bkg_no
      AND FK_LOAD_LIST_ID = p_i_v_fk_load_list_id
      AND DN_EQUIPMENT_NO = p_i_v_dn_eqp_no
       AND RECORD_STATUS             = 'A'                    --#06
      );
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_clr1_desc:=NULL;
   WHEN TOO_MANY_ROWS THEN
      l_v_clr1_desc:=NULL;
  END;
  BEGIN
    SELECT CLR_DESC
    INTO l_v_clr2_desc
    FROM SHP041
    WHERE CLR_CODE IN
      (SELECT CONTAINER_LOADING_REM_2
      FROM VASAPPS.TOS_LL_BOOKED_LOADING
      WHERE FK_BOOKING_NO = p_i_v_fk_bkg_no
      AND FK_LOAD_LIST_ID = p_i_v_fk_load_list_id
      AND DN_EQUIPMENT_NO = p_i_v_dn_eqp_no
      AND RECORD_STATUS             = 'A'                    --#06
      );
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_clr2_desc:=NULL;
  WHEN TOO_MANY_ROWS THEN
    l_v_clr2_desc:=NULL;
  END;
  BEGIN
    SELECT SHI_DESCRIPTION
    INTO l_v_han1_desc
    FROM SHP007
    WHERE SHI_CODE =
      (SELECT FK_HANDLING_INSTRUCTION_1
      FROM VASAPPS.TOS_LL_BOOKED_LOADING
      WHERE FK_BOOKING_NO = p_i_v_fk_bkg_no
      AND FK_LOAD_LIST_ID = p_i_v_fk_load_list_id
      AND DN_EQUIPMENT_NO = p_i_v_dn_eqp_no
      AND RECORD_STATUS             = 'A'                    --#06
      AND ROWNUM=1
      );
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_han1_desc:=NULL;
  WHEN TOO_MANY_ROWS THEN
     l_v_han1_desc:=NULL;
  END;
  BEGIN
    SELECT SHI_DESCRIPTION
    INTO l_v_han2_desc
    FROM SHP007
    WHERE SHI_CODE =
      (SELECT FK_HANDLING_INSTRUCTION_2
      FROM VASAPPS.TOS_LL_BOOKED_LOADING
      WHERE FK_BOOKING_NO = p_i_v_fk_bkg_no
      AND FK_LOAD_LIST_ID = p_i_v_fk_load_list_id
      AND DN_EQUIPMENT_NO = p_i_v_dn_eqp_no
       AND RECORD_STATUS             = 'A'                    --#06
       AND ROWNUM=1
      );
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_han2_desc:=NULL;
  WHEN TOO_MANY_ROWS THEN
    l_v_han2_desc:=NULL;
  END;
  BEGIN
    SELECT SHI_DESCRIPTION
    INTO l_v_han3_desc
    FROM SHP007
    WHERE SHI_CODE =
      (SELECT FK_HANDLING_INSTRUCTION_3
      FROM VASAPPS.TOS_LL_BOOKED_LOADING
      WHERE FK_BOOKING_NO = p_i_v_fk_bkg_no
      AND FK_LOAD_LIST_ID = p_i_v_fk_load_list_id
      AND DN_EQUIPMENT_NO = p_i_v_dn_eqp_no
      AND RECORD_STATUS             = 'A'                    --#06
      AND ROWNUM=1
      );

  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_han3_desc:=NULL;
   WHEN TOO_MANY_ROWS THEN
    l_v_han3_desc:=NULL;
  END;
  BEGIN
    SELECT BASTAT INTO l_v_bastat FROM BKP001 WHERE BABKNO = p_i_v_fk_bkg_no;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_bastat:=NULL;
   WHEN TOO_MANY_ROWS THEN
   l_v_bastat:=NULL;
  END;
  BEGIN
    SELECT VSOPCD INTO l_v_vessel_operator FROM ITP060 WHERE VSVESS = l_v_vessel;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_vessel:=NULL;
  WHEN TOO_MANY_ROWS THEN
     l_v_vessel:=NULL;
  END;
  BEGIN
    SELECT PBVRD.SERVICE AS PREV_SERVICE ,
      PBVRD.VESSEL       AS PREV_VESSEL ,
      PBVRD.VOYNO        AS PREV_VOYAGE ,
      PBVRD.DIRECTION    AS PREV_DIR
    INTO l_v_prev_service ,
      l_v_prev_vessel ,
      l_v_prev_voyage ,
      l_v_prev_dir
    FROM
      (SELECT BVRD.SERVICE ,
        BVRD.VESSEL ,
        BVRD.VOYNO ,
        BVRD.DIRECTION
      FROM BOOKING_VOYAGE_ROUTING_DTL BVRD ,
        VASAPPS.TOS_LL_BOOKED_LOADING TBL
      WHERE BVRD.BOOKING_NO   = TBL.FK_BOOKING_NO              --##03
      AND BVRD.VOYAGE_SEQNO   =TBL.FK_BKG_VOYAGE_ROUTING_DTL-1 --##03
      AND TBL.FK_LOAD_LIST_ID = p_i_v_fk_load_list_id          --##03
      AND TBL.FK_BOOKING_NO   = p_i_v_fk_bkg_no                --##03
      AND TBL.DN_EQUIPMENT_NO = p_i_v_dn_eqp_no                --##03
      AND TBL.RECORD_STATUS             = 'A'                   --#06
      )PBVRD;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_v_prev_service:=NULL;
    l_v_prev_vessel :=NULL;
    l_v_prev_voyage :=NULL;
    l_v_prev_dir    :=NULL;
  WHEN TOO_MANY_ROWS THEN
    l_v_prev_service:=NULL;
    l_v_prev_vessel :=NULL;
    l_v_prev_voyage :=NULL;
    l_v_prev_dir    :=NULL;
  END;

  BEGIN
  UPDATE TOS_ONBOARD_LIST
  SET POL_DATE            = l_v_pol_date ,
    POL_TIME              = l_v_poL_time ,
    POD_DATE              = l_v_pod_date ,
    POD_TIME              = l_v_pod_time ,
    POD_PCSQ              = l_v_pod_pcsq ,
    WAYPORT_IND           = l_v_wayport_ind ,
    ACT_VESSEL_CODE       = l_v_act_vessel_code ,
    ACT_VOYAGE_NUMBER     = l_v_act_voyage_number ,
    ACT_SERVICE_DIRECTION = l_v_act_service_direction ,
    ACT_PORT_DIRECTION    = l_v_act_port_direction ,
    ACT_PORT_SEQUENCE     = l_v_act_port_sequence ,
    ACT_SERVICE_CODE      = l_v_act_service_code ,
    SEC_SERVICE           = l_v_sec_service ,
    SEC_VESSEL            = l_v_sec_vessel ,
    SEC_VOYAGE            = l_v_sec_voyage ,
    SEC_DIR               = l_v_sec_dir ,
    POT_PORT              = l_v_pot_port ,
    POT_PCSQ              = l_v_pot_pcsq ,
    POT_DATE              = l_v_pot_date ,
    POT_TIME              = l_v_pot_time ,
    POT_TERMINAL          = l_v_pot_terminal ,
    POT_DIS_PORT          = l_v_pot_dis_port ,
    POT_DIS_PCSQ          = l_v_pot_dis_pcsq ,
    POT_DIS_TERMINAL      = l_v_pot_dis_terminal ,
    CUST_CODE             = l_v_bncscd ,
    HAN1_DESC             = l_v_han1_desc ,
    HAN2_DESC             = l_v_han2_desc ,
    HAN3_DESC             = l_v_han3_desc ,
    BK_STATUS             = l_v_bastat ,
    PREV_SERVICE          = l_v_prev_service ,
    PREV_VESSEL           = l_v_prev_vessel ,
    PREV_VOYAGE           = l_v_prev_voyage ,
    PREV_DIR              = l_v_prev_dir ,
    VESSEL_OPERATOR       = l_v_vessel_operator
  WHERE POL_SERVICE       = l_v_service
  AND POL_VESSEL          = l_v_vessel
  AND POL_VOYAGE          = l_v_voyage
  AND POL_PCSQ            = l_v_port_seq
  AND POL                 = l_v_dn_port
  AND POL_TERMINAL        = l_v_dn_terminal
  AND BOOKING_NO          = p_i_v_fk_bkg_no
  AND CONTAINER_NO        = p_i_v_dn_eqp_no;
  COMMIT;
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
  DBMS_OUTPUT.PUT_LINE('Duplicate value found');
WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
  DBMS_OUTPUT.PUT_LINE('Duplicate value found');
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('NO DATA FOUND ERR');
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE('TOO MANY ROWS ERR');
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20000, SQLERRM);

END;