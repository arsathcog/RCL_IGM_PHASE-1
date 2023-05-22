DROP VIEW V_TOS_ONBOARD_LIST;

CREATE MATERIALIZED VIEW "V_TOS_ONBOARD_LIST"
("LINE","TRAD","AGNT","POL_SERVICE","POL_VESSEL","POL_VOYAGE","POL_DIR","POL","POL_PCSQ","SEQ_NO","LIST_STATUS","POL_DATE","POL_TIME","POL_TERMINAL","POD","POD_PCSQ","POD_DATE","POD_TIME","POD_TERMINAL","SEC_SERVICE","SEC_VESSEL","SEC_VOYAGE","SEC_DIR","POT_PORT","POT_PCSQ","POT_DATE","POT_TIME","POT_TERMINAL","POT_DIS_PORT","POT_DIS_PCSQ","POT_DIS_TERMINAL","BOOKING_NO","CONTAINER_NO","EQSIZE","EQTYPE","SURVEY_REQ","LDSURVEY_NO","LDSURVEY_DT","DG_APPROVAL_NO","FULL_MT","WEIGHT","SPECIAL_CARGO","CARGO_FLAG","RFTEMP","UNIT","IMDG","FLASH_PT","OOG_OH",
"OOG_OLF","OOG_OLB","OOG_OWR","OOG_OWL","OOG_OL","OOG_OW","SOC_COC","DELV_MODE","GATE_IN","ARRIVED","STOW_POSITION","BBK_NO_OF_CONT","BBK_NO_OF_PACKAGES","BBK_PACKAGE_KIND","BBK_WEIGHT","BBK_LENGTH","BBK_BREADTH","BBK_WIDTH","BBK_DIAMETER","KILLED_SLOT","OPS_COD","OPS_COD_APPNO","OPS_COD_DATE","NEW_POD","REMARKS","SEND_TO_POD","LL_RECORD_STATUS","CONT_STATUS","DISCH_STATUS","LOADING_TYPE","RECORD_ADD_USER","RECORD_ADD_DATE","RECORD_ADD_TIME","RECORD_CHANGE_USER","RECORD_CHANGE_DATE","RECORD_CHANGE_TIME","XXRCST","FLASH_PT_UNIT","NEW_POD_DATE","NEW_POD_PCSQ",
"DG_FLAG","OOG_FLAG","RF_FLAG","CONT_OPERATOR","VENDOR_CODE","PREV_SERVICE","PREV_VESSEL","PREV_VOYAGE","PREV_DIR","POL_COST","SHIP_TYPE","SHIP_TERM","POT_DISH_DATE","ROB","OVERLANDED","DISCH_REMARKS","DISCHLIST_STATUS","UNNO","VARIANT","PSN","OPR_CODE","CUST_CODE","QUANTITY","VOID_SLOT","TOT_TEUS","BISEQN","BK_POL_TERMINAL","POD_VOYAGE","BK_STATUS","WAYPORT_IND","SPCARGO_REQ","SP_APPROVAL_REF","HAN1","HAN2","HAN3","CLR1","CLR2","HAN1_DESC","HAN2_DESC","HAN3_DESC","CLR1_DESC","CLR2_DESC","DG_APPROVAL_REF","DG_STOWAGE_INS","VESSEL_OPERATOR","SLOT_OPERATOR",
"CONTAINER_OPERATOR","LOCAL_TS","CONNECTING_VESSEL","CONNECTING_VOYAGE_NO","NEXT_POD1","NEXT_POD2","NEXT_POD3","EX_CARRIER_VESSEL","EX_CARRIER_VOYAGE_NO","FINAL_DESTINATION","PORT_CLASS","SHORT_SHIPPED","ACTIVITY_CODE","OPERATION_TYPE","CATEGORY","DEL_FLAG","TIGHT_CONN_FLAG","TIGHT_CONN_FLAG2","TIGHT_CONN_FLAG3","OUT_SLOT_OPERATOR","ERROR_STATUS","ACT_VESSEL_CODE","ACT_VOYAGE_NUMBER","ACT_SERVICE_DIRECTION","ACT_PORT_DIRECTION","ACT_PORT_SEQUENCE","ACT_SERVICE_CODE","FK_LOAD_LIST_ID","ACTIVITY_DATE_TIME","RECORD_STATUS","FK_BKG_SIZE_TYPE_DTL",
"FK_BKG_SUPPLIER","FK_BKG_EQUIPM_DTL","FK_BKG_VOYAGE_ROUTING_DTL","LOADING_STATUS","DN_DISCHARGE_TERMINAL","PK_BOOKED_LOADING_ID","EQUPMENT_NO_SOURCE","DN_BKG_TYP","LOCAL_TERMINAL_STATUS","MIDSTREAM_HANDLING_CODE","LOAD_CONDITION","DAMAGED","PREADVICE_FLAG","DN_SPECIAL_HNDL","SEAL_NO","DN_FINAL_POD","DN_NXT_SRV","DN_NXT_VESSEL","DN_NXT_VOYAGE","DN_NXT_DIR","MLO_VESSEL_ETA","MLO_POD1","MLO_POD2","MLO_POD3","MLO_DEL","EX_MLO_VESSEL","EX_MLO_VESSEL_ETA","EX_MLO_VOYAGE","FK_PORT_CLASS_TYP","FUMIGATION_ONLY","RESIDUE_ONLY_FLAG","DN_HUMIDITY","DN_VENTILATION",
"PK_LOAD_LIST_ID","DN_SERVICE_GROUP_CODE","FK_VERSION","DA_BOOKED_TOT","DA_LOADED_TOT","DA_ROB_TOT","DA_OVERSHIPPED_TOT","DA_SHORTSHIPPED_TOT","LL_RECORD_ADD_USER","LL_RECORD_ADD_DATE","LL_RECORD_CHANGE_USER","LL_RECORD_CHANGE_DATE")
REFRESH COMPLETE ON DEMAND 
USING DEFAULT LOCAL ROLLBACK SEGMENT
 DISABLE QUERY REWRITE 
--CREATE OR REPLACE VIEW V_TOS_ONBOARD_LIST AS
AS
SELECT
    DECODE(   TBL.RECORD_CHANGE_USER
            , 'EZLL'
            , 'R'
            , UAB.CRFLV1)                         as     LINE
  , DECODE(   TBL.RECORD_CHANGE_USER
            , 'EZLL'
            , '*'
            , UAB.CRFLV2)                         as     TRAD
  , DECODE(   TBL.RECORD_CHANGE_USER
            , 'EZLL'
            , '***'
            , UAB.CRFLV3)                         as     AGNT
  , TLL.FK_SERVICE                                as     POL_SERVICE
  , TLL.FK_VESSEL                                 as     POL_VESSEL
  , TLL.FK_VOYAGE                                 as     POL_VOYAGE
  , TLL.FK_DIRECTION                              as     POL_DIR
  , TLL.DN_PORT                                   as     POL
  , TLL.FK_PORT_SEQUENCE_NO                       as     POL_PCSQ
  , TBL.CONTAINER_SEQ_NO                          as     SEQ_NO
  , CASE WHEN TLL.LOAD_LIST_STATUS >= 10
         THEN 'C'
         ELSE 'O'
    END                                           as     LIST_STATUS
  , ITP063.VVARDT                                 as     POL_DATE
  , ITP063.VVARTM                                 as     POL_TIME
  , TLL.DN_TERMINAL                               as     POL_TERMINAL
  , TBL.DN_DISCHARGE_PORT                         as     POD
  , BVRD.POD_PCSQ                                 as     POD_PCSQ
  , ITP063.VVARDT                                 as     POD_DATE
  , ITP063.VVARTM                                 as     POD_TIME
  , TBL.DN_DISCHARGE_TERMINAL                     as     POD_TERMINAL
  , NBVRD.SERVICE                                 as     SEC_SERVICE
  , NBVRD.VESSEL                                  as     SEC_VESSEL
  , NBVRD.VOYNO                                   as     SEC_VOYAGE
  , NBVRD.DIRECTION                               as     SEC_DIR
  , NBVRD.LOAD_PORT                               as     POT_PORT
  , NBVRD.POL_PCSQ                                as     POT_PCSQ
  , NBVRD.POL_ARRIVAL_DATE                        as     POT_DATE
  , NBVRD.POL_ARRIVAL_TIME                        as     POT_TIME
  , NBVRD.FROM_TERMINAL                           as     POT_TERMINAL
  , NBVRD.DISCHARGE_PORT                          as     POT_DIS_PORT
  , NBVRD.POD_PCSQ                                as     POT_DIS_PCSQ
  , NBVRD.TO_TERMINAL                             as     POT_DIS_TERMINAL
  , TBL.FK_BOOKING_NO                             as     BOOKING_NO
  , TBL.DN_EQUIPMENT_NO                           as     CONTAINER_NO
  , TBL.DN_EQ_SIZE                                as     EQSIZE
  , TBL.DN_EQ_TYPE                                as     EQTYPE
  , cast( '' as varchar(1))                                            as     SURVEY_REQ
  , cast( '' as varchar(1))                                            as     LDSURVEY_NO
  , cast( '' as varchar(1))                                            as     LDSURVEY_DT
  , cast( '' as varchar(1))                                            as     DG_APPROVAL_NO
  , TBL.DN_FULL_MT                                as     FULL_MT
  , TBL.CONTAINER_GROSS_WEIGHT                    as     WEIGHT
  , TBL.FK_SPECIAL_CARGO                          as     SPECIAL_CARGO
  , cast( '' as varchar(1))                                            as     CARGO_FLAG
  , TBL.REEFER_TMP                                as     RFTEMP
  , TBL.REEFER_TMP_UNIT                           as     UNIT
  , TBL.FK_IMDG                                   as     IMDG
  , TBL.FLASH_POINT                               as     FLASH_PT
  , TBL.OVERHEIGHT_CM                             as     OOG_OH
  , TBL.OVERLENGTH_FRONT_CM                       as     OOG_OLF
  , TBL.OVERLENGTH_REAR_CM                        as     OOG_OLB
  , TBL.OVERWIDTH_RIGHT_CM                        as     OOG_OWR
  , TBL.OVERWIDTH_LEFT_CM                         as     OOG_OWL
  , cast( '' as varchar(1))                                            as     OOG_OL
  , cast( '' as varchar(1))                                            as     OOG_OW
  , TBL.DN_SOC_COC                                as     SOC_COC
  , cast( '' as varchar(1))                                            as     DELV_MODE
  , cast( '' as varchar(1))                                            as     GATE_IN
  , cast( '' as varchar(1))                                            as     ARRIVED
  , TBL.STOWAGE_POSITION                          as     STOW_POSITION
  , cast( '' as varchar(1))                                            as     BBK_NO_OF_CONT
  , cast( '' as varchar(1))                                            as     BBK_NO_OF_PACKAGES
  , cast( '' as varchar(1))                                            as     BBK_PACKAGE_KIND
  , cast( '' as varchar(1))                                            as     BBK_WEIGHT
  , cast( '' as varchar(1))                                            as     BBK_LENGTH
  , cast( '' as varchar(1))                                            as     BBK_BREADTH
  , cast( '' as varchar(1))                                            as     BBK_WIDTH
  , cast( '' as varchar(1))                                            as     BBK_DIAMETER
  , TBL.VOID_SLOT                                 as     KILLED_SLOT
  , cast( '' as varchar(1))                                            as     OPS_COD
  , cast( '' as varchar(1))                                            as     OPS_COD_APPNO
  , cast( '' as varchar(1))                                            as     OPS_COD_DATE
  , cast( '' as varchar(1))                                            as     NEW_POD
  , TBL.PUBLIC_REMARK                             as     REMARKS
  , 'M'                                           as     SEND_TO_POD
  , TLL.RECORD_STATUS                             as     LL_RECORD_STATUS
  , CASE WHEN TBL.LOADING_STATUS = 'LO'
         THEN 'L'
         WHEN TBL.LOADING_STATUS = 'SS'
         THEN 'N'
         ELSE cast( '' as varchar(1))
    END                                           as     CONT_STATUS
  , cast( '' as varchar(1))                                            as     DISCH_STATUS
  , TBL.LOCAL_STATUS                              as     LOADING_TYPE
  , TBL.RECORD_ADD_USER                           as     RECORD_ADD_USER
  , TO_CHAR(TBL.RECORD_ADD_DATE, 'YYYYMMDD')      as     RECORD_ADD_DATE
  , TO_CHAR(TBL.RECORD_ADD_DATE, 'HH24MI')        as     RECORD_ADD_TIME
  , TBL.RECORD_CHANGE_USER                        as     RECORD_CHANGE_USER
  , TO_CHAR(TBL.RECORD_CHANGE_DATE, 'YYYYMMDD')   as     RECORD_CHANGE_DATE
  , TO_CHAR(TBL.RECORD_CHANGE_DATE, 'HH24MI')     as     RECORD_CHANGE_TIME
  , cast( '' as varchar(1))                                            as     XXRCST
  , TBL.FLASH_UNIT                                as     FLASH_PT_UNIT
  , cast( '' as varchar(1))                                            as     NEW_POD_DATE
  , cast( '' as varchar(1))                                            as     NEW_POD_PCSQ
  , cast( '' as varchar(1))                                            as     DG_FLAG
  , cast( '' as varchar(1))                                            as     OOG_FLAG
  , cast( '' as varchar(1))                                            as     RF_FLAG
  , TBL.FK_CONTAINER_OPERATOR                     as     CONT_OPERATOR
  , cast( '' as varchar(1))                                            as     VENDOR_CODE
  , PBVRD.SERVICE                                 as     PREV_SERVICE
  , PBVRD.VESSEL                                  as     PREV_VESSEL
  , PBVRD.VOYNO                                   as     PREV_VOYAGE
  , PBVRD.DIRECTION                               as     PREV_DIR
  , cast( '' as varchar(1))                                            as     POL_COST
  , TBL.DN_SHIPMENT_TYP                           as     SHIP_TYPE
  , TBL.DN_SHIPMENT_TERM                          as     SHIP_TERM
  , cast( '' as varchar(1))                                            as     POT_DISH_DATE
  , DECODE(   TBL.LOADING_STATUS
            , 'ROB'
            , 'Y'
            , cast( '' as varchar(1)))                                 as     ROB
  , cast( '' as varchar(1))                                            as     OVERLANDED
  , cast( '' as varchar(1))                                            as     DISCH_REMARKS
  , cast( '' as varchar(1))                                            as     DISCHLIST_STATUS
  , TBL.FK_UNNO                                   as     UNNO
  , TBL.FK_UN_VAR                                 as     VARIANT
  , cast( '' as varchar(1))                                            as     PSN
  , cast( '' as varchar(1))                                            as     OPR_CODE
  , BKP030.BNCSCD                                 as     CUST_CODE
  , cast( '' as varchar(1))                                            as     QUANTITY
  , TBL.VOID_SLOT                                 as     VOID_SLOT
  , cast( '' as varchar(1))                                            as     TOT_TEUS
  , TBL.FK_BKG_EQUIPM_DTL                         as     BISEQN
  , TLL.DN_TERMINAL                               as     BK_POL_TERMINAL
  , cast( '' as varchar(1))                                            as     POD_VOYAGE
  , BKP001.BASTAT                                 as     BK_STATUS
  , DECODE(   BVRD.TRUNK_WAYPORT_FLAG
            , 'W'
            , 'Y'
            , 'N'
           )                                      as     WAYPORT_IND
  , cast( '' as varchar(1))                                            as     SPCARGO_REQ
  , cast( '' as varchar(1))                                            as     SP_APPROVAL_REF
  , TBL.FK_HANDLING_INSTRUCTION_1                 as     HAN1
  , TBL.FK_HANDLING_INSTRUCTION_2                 as     HAN2
  , TBL.FK_HANDLING_INSTRUCTION_3                 as     HAN3
  , TBL.CONTAINER_LOADING_REM_1                   as     CLR1
  , TBL.CONTAINER_LOADING_REM_2                   as     CLR2
  , HAN1.SHI_DESCRIPTION                          as     HAN1_DESC
  , HAN2.SHI_DESCRIPTION                          as     HAN2_DESC
  , HAN3.SHI_DESCRIPTION                          as     HAN3_DESC
  , CLR1.CLR_DESC                                 as     CLR1_DESC
  , CLR2.CLR_DESC                                 as     CLR2_DESC
  , cast( '' as varchar(1))                                            as     DG_APPROVAL_REF
  , cast( '' as varchar(1))                                            as     DG_STOWAGE_INS
  , ITP060.VSOPCD                                 as     VESSEL_OPERATOR
  , TBL.FK_SLOT_OPERATOR                          as     SLOT_OPERATOR
  , TBL.FK_CONTAINER_OPERATOR                     as     CONTAINER_OPERATOR
  , TBL.LOCAL_STATUS                              as     LOCAL_TS
  , TBL.MLO_VESSEL                                as     CONNECTING_VESSEL
  , TBL.MLO_VOYAGE                                as     CONNECTING_VOYAGE_NO
  , TBL.DN_NXT_POD1                               as     NEXT_POD1
  , TBL.DN_NXT_POD2                               as     NEXT_POD2
  , TBL.DN_NXT_POD3                               as     NEXT_POD3
  , TBL.EX_MLO_VESSEL                             as     EX_CARRIER_VESSEL
  , TBL.EX_MLO_VOYAGE                             as     EX_CARRIER_VOYAGE_NO
  , TBL.FINAL_DEST                                as     FINAL_DESTINATION
  , TBL.FK_PORT_CLASS                             as     PORT_CLASS
  , cast( '' as varchar(1))                                            as     SHORT_SHIPPED
  , cast( '' as varchar(1))                                            as     ACTIVITY_CODE
  , cast( '' as varchar(1))                                            as     OPERATION_TYPE
  , cast( '' as varchar(1))                                            as     CATEGORY
  , cast( '' as varchar(1))                                            as     DEL_FLAG
  , TBL.TIGHT_CONNECTION_FLAG1                    as     TIGHT_CONN_FLAG
  , TBL.TIGHT_CONNECTION_FLAG2                    as     TIGHT_CONN_FLAG2
  , TBL.TIGHT_CONNECTION_FLAG3                    as     TIGHT_CONN_FLAG3
  , TBL.OUT_SLOT_OPERATOR                         as     OUT_SLOT_OPERATOR
  , '2'                                           as     ERROR_STATUS
  , BVRD.ACT_VESSEL_CODE                          as     ACT_VESSEL_CODE
  , BVRD.ACT_VOYAGE_NUMBER                        as     ACT_VOYAGE_NUMBER
  , BVRD.ACT_SERVICE_DIRECTION                    as     ACT_SERVICE_DIRECTION
  , BVRD.ACT_PORT_DIRECTION                       as     ACT_PORT_DIRECTION
  , BVRD.ACT_PORT_SEQUENCE                        as     ACT_PORT_SEQUENCE
  , BVRD.ACT_SERVICE_CODE                         as     ACT_SERVICE_CODE
  , TBL.FK_LOAD_LIST_ID				  as     FK_LOAD_LIST_ID
  , TBL.ACTIVITY_DATE_TIME                        as     ACTIVITY_DATE_TIME
  , TBL.RECORD_STATUS                             as     RECORD_STATUS
  , TBL.FK_BKG_SIZE_TYPE_DTL                      as     FK_BKG_SIZE_TYPE_DTL
  , TBL.FK_BKG_SUPPLIER                           as     FK_BKG_SUPPLIER
  , TBL.FK_BKG_EQUIPM_DTL                         as     FK_BKG_EQUIPM_DTL
  , TBL.FK_BKG_VOYAGE_ROUTING_DTL                 as     FK_BKG_VOYAGE_ROUTING_DTL
  , TBL.LOADING_STATUS                            as     LOADING_STATUS
  , TBL.DN_DISCHARGE_TERMINAL                     as     DN_DISCHARGE_TERMINAL
  , TBL.PK_BOOKED_LOADING_ID                      as     PK_BOOKED_LOADING_ID
  , TBL.EQUPMENT_NO_SOURCE                        as     EQUPMENT_NO_SOURCE
  , TBL.DN_BKG_TYP                                as     DN_BKG_TYP
  , TBL.LOCAL_TERMINAL_STATUS                     as     LOCAL_TERMINAL_STATUS
  , TBL.MIDSTREAM_HANDLING_CODE                   as     MIDSTREAM_HANDLING_CODE
  , TBL.LOAD_CONDITION                            as     LOAD_CONDITION
  , TBL.DAMAGED                                   as     DAMAGED
  , TBL.PREADVICE_FLAG                            as     PREADVICE_FLAG
  , TBL.DN_SPECIAL_HNDL                           as     DN_SPECIAL_HNDL
  , TBL.SEAL_NO                                   as     SEAL_NO
  , TBL.DN_FINAL_POD                              as     DN_FINAL_POD
  , TBL.DN_NXT_SRV                                as     DN_NXT_SRV
  , TBL.DN_NXT_VESSEL                             as     DN_NXT_VESSEL
  , TBL.DN_NXT_VOYAGE                             as     DN_NXT_VOYAGE
  , TBL.DN_NXT_DIR                                as     DN_NXT_DIR
  , TBL.MLO_VESSEL_ETA                            as     MLO_VESSEL_ETA
  , TBL.MLO_POD1                                  as     MLO_POD1
  , TBL.MLO_POD2                                  as     MLO_POD2
  , TBL.MLO_POD3                                  as     MLO_POD3
  , TBL.MLO_DEL                                   as     MLO_DEL
  , TBL.EX_MLO_VESSEL                             as     EX_MLO_VESSEL
  , TBL.EX_MLO_VESSEL_ETA                         as     EX_MLO_VESSEL_ETA
  , TBL.EX_MLO_VOYAGE                             as     EX_MLO_VOYAGE
  , TBL.FK_PORT_CLASS_TYP                         as     FK_PORT_CLASS_TYP
  , TBL.FUMIGATION_ONLY                           as     FUMIGATION_ONLY
  , TBL.RESIDUE_ONLY_FLAG                         as     RESIDUE_ONLY_FLAG
  , TBL.DN_HUMIDITY                               as     DN_HUMIDITY
  , TBL.DN_VENTILATION                            as     DN_VENTILATION
  , TLL.PK_LOAD_LIST_ID                           as     PK_LOAD_LIST_ID
  , TLL.DN_SERVICE_GROUP_CODE                     as     DN_SERVICE_GROUP_CODE
  , TLL.FK_VERSION                                as     FK_VERSION
  , TLL.DA_BOOKED_TOT                             as     DA_BOOKED_TOT
  , TLL.DA_LOADED_TOT                             as     DA_LOADED_TOT
  , TLL.DA_ROB_TOT                                as     DA_ROB_TOT
  , TLL.DA_OVERSHIPPED_TOT                        as     DA_OVERSHIPPED_TOT
  , TLL.DA_SHORTSHIPPED_TOT                       as     DA_SHORTSHIPPED_TOT
  , TLL.RECORD_ADD_USER                           as     LL_RECORD_ADD_USER
  , TLL.RECORD_ADD_DATE                           as     LL_RECORD_ADD_DATE
  , TLL.RECORD_CHANGE_USER                        as     LL_RECORD_CHANGE_USER
  , TLL.RECORD_CHANGE_DATE                        as     LL_RECORD_CHANGE_DATE
FROM  TOS_LL_LOAD_LIST            TLL
    , TOS_LL_BOOKED_LOADING       TBL
    , ITP060                      ITP060
    , MV_ITP063                   ITP063
    , BKP001                      BKP001
    , SHP041                      CLR1
    , SHP041                      CLR2
    , SHP007                      HAN1
    , SHP007                      HAN2
    , SHP007                      HAN3
    , BOOKING_VOYAGE_ROUTING_DTL  BVRD
    , (
        SELECT    PK_BOOKED_LOADING_ID
                , SERVICE
                , VESSEL
                , VOYNO
                , DIRECTION
                , LOAD_PORT
                , POL_PCSQ
                , POL_ARRIVAL_DATE
                , POL_ARRIVAL_TIME
                , FROM_TERMINAL
                , DISCHARGE_PORT
                , POD_PCSQ
                , TO_TERMINAL
        FROM (  SELECT    TBL.PK_BOOKED_LOADING_ID
                        , BVRD.SERVICE
                        , BVRD.VESSEL
                        , BVRD.VOYNO
                        , BVRD.DIRECTION
                        , BVRD.LOAD_PORT
                        , BVRD.POL_PCSQ
                        , BVRD.POL_ARRIVAL_DATE
                        , BVRD.POL_ARRIVAL_TIME
                        , BVRD.FROM_TERMINAL
                        , BVRD.DISCHARGE_PORT
                        , BVRD.POD_PCSQ
                        , BVRD.TO_TERMINAL
                        , ROW_NUMBER() OVER(PARTITION BY BVRD.BOOKING_NO
                                            ORDER BY BVRD.VOYAGE_SEQNO ASC) SR_NO
                FROM  BOOKING_VOYAGE_ROUTING_DTL    BVRD
                    , TOS_LL_BOOKED_LOADING         TBL
                WHERE  BVRD.BOOKING_NO   = TBL.FK_BOOKING_NO
                AND    BVRD.VOYAGE_SEQNO > TBL.FK_BKG_VOYAGE_ROUTING_DTL
             ) WHERE SR_NO = 1
      ) NBVRD
    , (
        SELECT    PK_BOOKED_LOADING_ID
                , SERVICE
                , VESSEL
                , VOYNO
                , DIRECTION
        FROM (
                SELECT    TBL.PK_BOOKED_LOADING_ID
                        , BVRD.SERVICE
                        , BVRD.VESSEL
                        , BVRD.VOYNO
                        , BVRD.DIRECTION
                        , ROW_NUMBER() OVER(PARTITION BY BVRD.BOOKING_NO
                                            ORDER BY BVRD.VOYAGE_SEQNO DESC) SR_NO
                FROM  BOOKING_VOYAGE_ROUTING_DTL    BVRD
                    , TOS_LL_BOOKED_LOADING         TBL
                WHERE  BVRD.BOOKING_NO   = TBL.FK_BOOKING_NO
                AND    BVRD.VOYAGE_SEQNO < TBL.FK_BKG_VOYAGE_ROUTING_DTL
             ) WHERE SR_NO = 1
      ) PBVRD
    , (
        SELECT    TBL.PK_BOOKED_LOADING_ID
                , BKP030.BNCSCD
        FROM   BKP030                   BKP030
             , TOS_LL_BOOKED_LOADING    TBL
        WHERE BKP030.BNCSTP = 'O'
        AND   BKP030.BNBKNO = TBL.FK_BOOKING_NO
      ) BKP030
    , (
        SELECT    SPLI.PRSN_LOG_ID
                , FSC.CRFLV1
                , FSC.CRFLV2
                , FSC.CRFLV3
          FROM SC_PRSN_LOG_INFO SPLI
             , ITP188           FSC
          WHERE SPLI.FSC_CODE    = FSC.CRCNTR
        ) UAB
WHERE TLL.PK_LOAD_LIST_ID           = TBL.FK_LOAD_LIST_ID
AND   TLL.FK_SERVICE                = ITP063.VVSRVC
AND   TLL.FK_VESSEL                 = ITP063.VVVESS
AND   TLL.FK_VOYAGE                 = ITP063.VVVOYN
AND   TLL.FK_DIRECTION              = ITP063.VVPDIR
AND   TLL.FK_PORT_SEQUENCE_NO       = ITP063.VVPCSQ
AND   ITP063.VVVERS                 = '99'
AND   TBL.FK_BOOKING_NO             = BVRD.BOOKING_NO
AND   TBL.FK_BKG_VOYAGE_ROUTING_DTL = BVRD.VOYAGE_SEQNO
AND   TBL.PK_BOOKED_LOADING_ID      = NBVRD.PK_BOOKED_LOADING_ID  (+)
AND   TBL.PK_BOOKED_LOADING_ID      = PBVRD.PK_BOOKED_LOADING_ID  (+)
AND   TBL.PK_BOOKED_LOADING_ID      = BKP030.PK_BOOKED_LOADING_ID (+)
AND   TBL.FK_BOOKING_NO             = BKP001.BABKNO
AND   TBL.CONTAINER_LOADING_REM_1   = CLR1.CLR_CODE (+)
AND   TBL.CONTAINER_LOADING_REM_2   = CLR2.CLR_CODE (+)
AND   TBL.FK_HANDLING_INSTRUCTION_1 = HAN1.SHI_CODE (+)
AND   TBL.FK_HANDLING_INSTRUCTION_2 = HAN2.SHI_CODE (+)
AND   TBL.FK_HANDLING_INSTRUCTION_3 = HAN3.SHI_CODE (+)
AND   TLL.FK_VESSEL                 = ITP060.VSVESS
AND   TBL.RECORD_CHANGE_USER        = UAB.PRSN_LOG_ID (+);
/
