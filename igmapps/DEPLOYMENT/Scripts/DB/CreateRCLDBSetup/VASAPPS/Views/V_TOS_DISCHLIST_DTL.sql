CREATE MATERIALIZED VIEW "V_TOS_DISCHLIST_DTL" 
("LINE", "TRAD", "AGNT", "POD_SERVICE", "POD_VESSEL", "POD_VOYAGE", "POD_DIR", "POD", "POD_PCSQ", "SEQ_NO", "POD_DATE", "POD_TIME", "POD_TERMINAL", "PREV_SERVICE", "PREV_VESSEL", "PREV_VOYAGE", "PREV_DIR", "PREV_POL", "POL_PCSQ", "POL_DATE", "POL_TIME", "POL_TERMINAL", "COD", "COD_PCSQ", "COD_DATE", "COD_TIME", "COD_TERMINAL", "SEC_SERVICE", "SEC_VESSEL", "SEC_VOYAGE", "SEC_DIR", "SEC_PORT", "SEC_PCSQ", "SEC_DATE", "SEC_TIME", "SEC_TERMINAL", "BOOKING_NO", "CONTAINER_NO", "EQSIZE", "EQTYPE", "FULL_MT", "WEIGHT", "SPECIAL_CARGO", "CARGO_FLAG", "RFTEMP", "UNIT", "IMDG", "FLASH_PT", "OOG_OH", "OOG_OLF", "OOG_OLB", "OOG_OWR", "OOG_OWL", "OOG_OW", "OOG_OL", "SOC_COC", "ROB", "OVERLANDED", "REMARKS", "BBK_NO_OF_CONT", "BBK_NO_OF_PACKAGES", "BBK_PACKAGE_KIND", "BBK_WEIGHT", "BBK_LENGTH", "BBK_BREADTH", "BBK_WIDTH", "BBK_DIAMETER", "KILLED_SLOT", "STOW_POSITION", "RECORD_ADD_USER", "RECORD_ADD_DATE", "RECORD_ADD_TIME", 
 "RECORD_CHANGE_USER", "RECORD_CHANGE_DATE", "RECORD_CHANGE_TIME", "XXRCST", "FLASH_PT_UNIT", "DG_FLAG", "OOG_FLAG", "RF_FLAG", "REASON_FLAG", "SHIP_TERM", "SHIP_TYPE", "LIST_STATUS", "BK_STATUS", "DISCHARGE_STATUS", "WAYPORT_IND", "UNNO", "VESSEL_OPERATOR", "POD_ETD", "SLOT_OPERATOR", "CONTAINER_OPERATOR", "LOCAL_TS", "CONNECTING_VESSEL", "CONNECTING_VOYAGE_NO", "NEXT_POD1", "NEXT_POD2", "NEXT_POD3", "FINAL_DESTINATION", "PORT_CLASS", "SHORT_LANDED", "ACTIVITY_CODE", "OPERATION_TYPE", "CATEGORY", "TIGHT_CONN_FLAG", "TIGHT_CONN_FLAG2", "TIGHT_CONN_FLAG3", "OUT_SLOT_OPERATOR", "LOCAL_CONTAINER_STATUS", "ACT_VESSEL_CODE", "ACT_VOYAGE_NUMBER", "ACT_SERVICE_DIRECTION", "ACT_PORT_DIRECTION", "ACT_PORT_SEQUENCE", "FROM_VOYAGE_NUMBER", "FROM_DIRECTION", "FROM_PORT_SEQUENCE", "CLR1", "CLR1_DESC", "CLR2", "CLR2_DESC", "HAN1", "HAN1_DESC", "HAN2", "HAN2_DESC", "HAN3", "HAN3_DESC", "DISCHARGE_UPDATED", "VARIANT", "ACT_SERVICE_CODE", "FK_DISCHARGE_LIST_ID", "FINAL_POD", "LOAD_CONDITION",
 "CONTAINER_GROSS_WEIGHT", "DN_HUMIDITY", "DN_VENTILATION", "RESIDUE_ONLY_FLAG", "ACTIVITY_DATE_TIME", "RECORD_STATUS", "DL_RECORD_STATUS", "FK_BKG_SIZE_TYPE_DTL", "FK_BKG_SUPPLIER", "FK_BKG_EQUIPM_DTL", "FK_BKG_VOYAGE_ROUTING_DTL", "PK_BOOKED_DISCHARGE_ID", "DN_BKG_TYP", "MIDSTREAM_HANDLING_CODE", "DN_LOADING_STATUS", "DAMAGED", "FK_SLOT_OPERATOR", "DN_SPECIAL_HNDL", "SEAL_NO", "DN_POL", "DN_NXT_SRV", "DN_NXT_VESSEL", "DN_NXT_VOYAGE", "DN_NXT_DIR", "MLO_VESSEL_ETA", "MLO_POD1", "MLO_POD2", "MLO_POD3", "MLO_DEL", "SWAP_CONNECTION_ALLOWED", "FK_PORT_CLASS_TYP", "FUMIGATION_ONLY", "PK_DISCHARGE_LIST_ID", "DN_SERVICE_GROUP_CODE", "FK_VERSION", "DA_BOOKED_TOT", "DA_DISCHARGED_TOT", "DA_ROB_TOT", "DA_OVERLANDED_TOT", "DA_SHORTLANDED_TOT", "DL_RECORD_ADD_USER", "DL_RECORD_ADD_DATE", "DL_RECORD_CHANGE_USER", "DL_RECORD_CHANGE_DATE", "DISCH_STATUS")
REFRESH COMPLETE ON DEMAND 
USING DEFAULT LOCAL ROLLBACK SEGMENT
 DISABLE QUERY REWRITE
--  CREATE OR REPLACE FORCE VIEW "VASAPPS"."V_TOS_DISCHLIST_DTL" 
                                                                     AS
SELECT DECODE( TBD.RECORD_CHANGE_USER , 'EZLL' , 'R' , UAB.CRFLV1)   AS LINE ,
    DECODE( TBD.RECORD_CHANGE_USER , 'EZLL' , '*' , UAB.CRFLV2)      AS TRAD ,
    DECODE( TBD.RECORD_CHANGE_USER , 'EZLL' , '***' , UAB.CRFLV3)    AS AGNT ,
    TDL.FK_SERVICE                                                   AS POD_SERVICE ,
    TDL.FK_VESSEL                                                    AS POD_VESSEL ,
    TDL.FK_VOYAGE                                                    AS POD_VOYAGE ,
    TDL.FK_DIRECTION                                                 AS POD_DIR ,
    TDL.DN_PORT                                                      AS POD ,
    TDL.FK_PORT_SEQUENCE_NO                                          AS POD_PCSQ ,
    TBD.CONTAINER_SEQ_NO                                             AS SEQ_NO ,
    ITP063.VVARDT                                                    AS POD_DATE ,
    ITP063.VVARTM                                                    AS POD_TIME ,
    TDL.DN_TERMINAL                                                  AS POD_TERMINAL ,
    PBVRD.SERVICE                                                    AS PREV_SERVICE ,
    PBVRD.VESSEL                                                     AS PREV_VESSEL ,
    PBVRD.VOYNO                                                      AS PREV_VOYAGE ,
    PBVRD.DIRECTION                                                  AS PREV_DIR ,
    PBVRD.LOAD_PORT                                                  AS PREV_POL ,
    BVRD.POL_PCSQ                                                    AS POL_PCSQ ,
    BVRD.POL_ARRIVAL_DATE                                            AS POL_DATE ,
    BVRD.POL_ARRIVAL_TIME                                            AS POL_TIME ,
    TBD.DN_POL_TERMINAL                                              AS POL_TERMINAL ,
    cast( '' as varchar(1))                                          AS COD ,
    cast( '' as varchar(1))                                          AS COD_PCSQ ,
    cast( '' as varchar(1))                                          AS COD_DATE ,
    cast( '' as varchar(1))                                          AS COD_TIME ,
    cast( '' as varchar(1))                                          AS COD_TERMINAL ,
    NBVRD.SERVICE                                                    AS SEC_SERVICE ,
    NBVRD.VESSEL                                                     AS SEC_VESSEL ,
    NBVRD.VOYNO                                                      AS SEC_VOYAGE ,
    NBVRD.DIRECTION                                                  AS SEC_DIR ,
    NBVRD.LOAD_PORT                                                  AS SEC_PORT ,
    NBVRD.POL_PCSQ                                                   AS SEC_PCSQ ,
    NBVRD.POL_ARRIVAL_DATE                                           AS SEC_DATE ,
    NBVRD.POL_ARRIVAL_TIME                                           AS SEC_TIME ,
    NBVRD.FROM_TERMINAL                                              AS SEC_TERMINAL ,
    TBD.FK_BOOKING_NO                                                AS BOOKING_NO ,
    TBD.DN_EQUIPMENT_NO                                              AS CONTAINER_NO ,
    TBD.DN_EQ_SIZE                                                   AS EQSIZE ,
    TBD.DN_EQ_TYPE                                                   AS EQTYPE ,
    TBD.DN_FULL_MT                                                   AS FULL_MT ,
    TBD.CONTAINER_GROSS_WEIGHT                                       AS WEIGHT ,
    TBD.FK_SPECIAL_CARGO                                             AS SPECIAL_CARGO ,
    cast( '' as varchar(1))                                          AS CARGO_FLAG ,
    TBD.REEFER_TEMPERATURE                                           AS RFTEMP ,
    TBD.REEFER_TMP_UNIT                                              AS UNIT ,
    TBD.FK_IMDG                                                      AS IMDG ,
    TBD.FLASH_POINT                                                  AS FLASH_PT ,
    TBD.OVERHEIGHT_CM                                                AS OOG_OH ,
    TBD.OVERLENGTH_FRONT_CM                                          AS OOG_OLF ,
    TBD.OVERLENGTH_REAR_CM                                           AS OOG_OLB ,
    TBD.OVERWIDTH_RIGHT_CM                                           AS OOG_OWR ,
    TBD.OVERWIDTH_LEFT_CM                                            AS OOG_OWL ,
    cast( '' as varchar(1))                                          AS OOG_OW ,
    cast( '' as varchar(1))                                          AS OOG_OL ,
    TBD.DN_SOC_COC                                                   AS SOC_COC ,
    DECODE( TBD.DISCHARGE_STATUS , 'ROB' , 'Y' , cast( '' as varchar(1)))                 AS ROB ,
    cast( '' as varchar(1))                                          AS OVERLANDED ,
    TBD.PUBLIC_REMARK                                                AS REMARKS ,
    cast( '' as varchar(1))                                          AS BBK_NO_OF_CONT ,
    cast( '' as varchar(1))                                          AS BBK_NO_OF_PACKAGES ,
    cast( '' as varchar(1))                                          AS BBK_PACKAGE_KIND ,
    cast( '' as varchar(1))                                          AS BBK_WEIGHT ,
    cast( '' as varchar(1))                                          AS BBK_LENGTH ,
    cast( '' as varchar(1))                                          AS BBK_BREADTH ,
    cast( '' as varchar(1))                                          AS BBK_WIDTH ,
    cast( '' as varchar(1))                                          AS BBK_DIAMETER ,
    TBD.VOID_SLOT                                                    AS KILLED_SLOT ,
    TBD.STOWAGE_POSITION                                             AS STOW_POSITION ,
    TBD.RECORD_ADD_USER                                              AS RECORD_ADD_USER ,
    TO_CHAR(TBD.RECORD_ADD_DATE, 'YYYYMMDD')                         AS RECORD_ADD_DATE ,
    TO_CHAR(TBD.RECORD_ADD_DATE, 'HH24MI')                           AS RECORD_ADD_TIME ,
    TBD.RECORD_CHANGE_USER                                           AS RECORD_CHANGE_USER ,
    TO_CHAR(TBD.RECORD_CHANGE_DATE, 'YYYYMMDD')                      AS RECORD_CHANGE_DATE ,
    TO_CHAR(TBD.RECORD_CHANGE_DATE, 'HH24MI')                        AS RECORD_CHANGE_TIME ,
    cast( '' as varchar(1))                                          AS XXRCST ,
    TBD.FLASH_UNIT                                                   AS FLASH_PT_UNIT ,
    cast( '' as varchar(1))                                          AS DG_FLAG ,
    cast( '' as varchar(1))                                          AS OOG_FLAG ,
    cast( '' as varchar(1))                                          AS RF_FLAG ,
    cast( '' as varchar(1))                                          AS REASON_FLAG ,
    TBD.DN_SHIPMENT_TERM                                             AS SHIP_TERM ,
    TBD.DN_SHIPMENT_TYP                                              AS SHIP_TYPE ,
    CASE
      WHEN TDL.DISCHARGE_LIST_STATUS >= 10
      THEN 'C'
      ELSE 'O'
    END           AS LIST_STATUS ,
    BKP001.BASTAT AS BK_STATUS ,
    CASE
      WHEN TBD.DISCHARGE_STATUS = 'BK'
      THEN 'O'
      WHEN TBD.DISCHARGE_STATUS = 'DL'
      THEN 'D'
      WHEN TBD.DISCHARGE_STATUS = 'SL'
      THEN 'O'
      WHEN TBD.DISCHARGE_STATUS = 'RB'
      THEN 'O'
    END                                                 AS DISCHARGE_STATUS ,
    DECODE( BVRD.TRUNK_WAYPORT_FLAG , 'W' , 'Y' , 'N' ) AS WAYPORT_IND ,
    TBD.FK_UNNO                                         AS UNNO ,
    ITP060.VSOPCD                                       AS VESSEL_OPERATOR ,
    TO_DATE(VVARDT
    ||LPAD(NVL(VVARTM,0),4,0) , 'YYYYMMDDHH24MI')                      AS POD_ETD ,
    TBD.OUT_SLOT_OPERATOR                                              AS SLOT_OPERATOR ,
    TBD.FK_CONTAINER_OPERATOR                                          AS CONTAINER_OPERATOR ,
    TBD.LOCAL_STATUS                                                   AS LOCAL_TS ,
    TBD.MLO_VESSEL                                                     AS CONNECTING_VESSEL ,
    TBD.MLO_VOYAGE                                                     AS CONNECTING_VOYAGE_NO ,
    TBD.DN_NXT_POD1                                                    AS NEXT_POD1 ,
    TBD.DN_NXT_POD2                                                    AS NEXT_POD2 ,
    TBD.DN_NXT_POD3                                                    AS NEXT_POD3 ,
    TBD.FINAL_DEST                                                     AS FINAL_DESTINATION ,
    TBD.FK_PORT_CLASS                                                  AS PORT_CLASS ,
    cast( '' as varchar(1))                                            AS SHORT_LANDED ,
    cast( '' as varchar(1))                                            AS ACTIVITY_CODE ,
    cast( '' as varchar(1))                                            AS OPERATION_TYPE ,
    cast( '' as varchar(1))                                            AS CATEGORY ,
    TBD.TIGHT_CONNECTION_FLAG1                                         AS TIGHT_CONN_FLAG ,
    TBD.TIGHT_CONNECTION_FLAG2                                         AS TIGHT_CONN_FLAG2 ,
    TBD.TIGHT_CONNECTION_FLAG3                                         AS TIGHT_CONN_FLAG3 ,
    TBD.FK_SLOT_OPERATOR                                               AS OUT_SLOT_OPERATOR ,
    TBD.LOCAL_TERMINAL_STATUS                                          AS LOCAL_CONTAINER_STATUS ,
    BVRD.ACT_VESSEL_CODE                                               AS ACT_VESSEL_CODE ,
    BVRD.ACT_VOYAGE_NUMBER                                             AS ACT_VOYAGE_NUMBER ,
    BVRD.ACT_SERVICE_DIRECTION                                         AS ACT_SERVICE_DIRECTION ,
    BVRD.ACT_PORT_DIRECTION                                            AS ACT_PORT_DIRECTION ,
    BVRD.ACT_PORT_SEQUENCE                                             AS ACT_PORT_SEQUENCE ,
    DECODE( BVRD.DISCHARGE_PORT , 'POD' , BVRD.ACT_VOYAGE_NUMBER , cast( '' as varchar(1))) AS FROM_VOYAGE_NUMBER ,
    BVRD.ACT_PORT_DIRECTION                                            AS FROM_DIRECTION ,
    DECODE( BVRD.DISCHARGE_PORT , 'POD' , BVRD.ACT_PORT_SEQUENCE , cast( '' as varchar(1))) AS FROM_PORT_SEQUENCE ,
    TBD.CONTAINER_LOADING_REM_1                                        AS CLR1 ,
    CLR1.CLR_DESC                                                      AS CLR1_DESC ,
    TBD.CONTAINER_LOADING_REM_2                                        AS CLR2 ,
    CLR2.CLR_DESC                                                      AS CLR2_DESC ,
    TBD.FK_HANDLING_INSTRUCTION_1                                      AS HAN1 ,
    HAN1.SHI_DESCRIPTION                                               AS HAN1_DESC ,
    TBD.FK_HANDLING_INSTRUCTION_2                                      AS HAN2 ,
    HAN2.SHI_DESCRIPTION                                               AS HAN2_DESC ,
    TBD.FK_HANDLING_INSTRUCTION_3                                      AS HAN3 ,
    HAN3.SHI_DESCRIPTION                                               AS HAN3_DESC ,
    cast( '' as varchar(1))                                            AS DISCHARGE_UPDATED ,
    TBD.FK_UN_VAR                                                      AS VARIANT ,
    BVRD.ACT_SERVICE_CODE                                              AS ACT_SERVICE_CODE ,
    TBD.FK_DISCHARGE_LIST_ID                                           AS FK_DISCHARGE_LIST_ID ,
    TBD.DN_FINAL_POD                                                   AS FINAL_POD ,
    TBD.LOAD_CONDITION                                                 AS LOAD_CONDITION ,
    TBD.CONTAINER_GROSS_WEIGHT                                         AS CONTAINER_GROSS_WEIGHT ,
    TBD.DN_HUMIDITY                                                    AS DN_HUMIDITY ,
    TBD.DN_VENTILATION                                                 AS DN_VENTILATION ,
    TBD.RESIDUE_ONLY_FLAG                                              AS RESIDUE_ONLY_FLAG ,
    TBD.ACTIVITY_DATE_TIME                                             AS ACTIVITY_DATE_TIME ,
    TBD.RECORD_STATUS                                                  AS RECORD_STATUS ,
    TDL.RECORD_STATUS                                                  AS DL_RECORD_STATUS ,
    TBD.FK_BKG_SIZE_TYPE_DTL                                           AS FK_BKG_SIZE_TYPE_DTL ,
    TBD.FK_BKG_SUPPLIER                                                AS FK_BKG_SUPPLIER ,
    TBD.FK_BKG_EQUIPM_DTL                                              AS FK_BKG_EQUIPM_DTL ,
    TBD.FK_BKG_VOYAGE_ROUTING_DTL                                      AS FK_BKG_VOYAGE_ROUTING_DTL ,
    TBD.PK_BOOKED_DISCHARGE_ID                                         AS PK_BOOKED_DISCHARGE_ID ,
    TBD.DN_BKG_TYP                                                     AS DN_BKG_TYP ,
    TBD.MIDSTREAM_HANDLING_CODE                                        AS MIDSTREAM_HANDLING_CODE ,
    TBD.DN_LOADING_STATUS                                              AS DN_LOADING_STATUS ,
    TBD.DAMAGED                                                        AS DAMAGED ,
    TBD.FK_SLOT_OPERATOR                                               AS FK_SLOT_OPERATOR ,
    TBD.DN_SPECIAL_HNDL                                                AS DN_SPECIAL_HNDL ,
    TBD.SEAL_NO                                                        AS SEAL_NO ,
    TBD.DN_POL                                                         AS DN_POL ,
    TBD.DN_NXT_SRV                                                     AS DN_NXT_SRV ,
    TBD.DN_NXT_VESSEL                                                  AS DN_NXT_VESSEL ,
    TBD.DN_NXT_VOYAGE                                                  AS DN_NXT_VOYAGE ,
    TBD.DN_NXT_DIR                                                     AS DN_NXT_DIR ,
    TBD.MLO_VESSEL_ETA                                                 AS MLO_VESSEL_ETA ,
    TBD.MLO_POD1                                                       AS MLO_POD1 ,
    TBD.MLO_POD2                                                       AS MLO_POD2 ,
    TBD.MLO_POD3                                                       AS MLO_POD3 ,
    TBD.MLO_DEL                                                        AS MLO_DEL ,
    TBD.SWAP_CONNECTION_ALLOWED                                        AS SWAP_CONNECTION_ALLOWED ,
    TBD.FK_PORT_CLASS_TYP                                              AS FK_PORT_CLASS_TYP ,
    TBD.FUMIGATION_ONLY                                                AS FUMIGATION_ONLY ,
    TDL.PK_DISCHARGE_LIST_ID                                           AS PK_DISCHARGE_LIST_ID ,
    TDL.DN_SERVICE_GROUP_CODE                                          AS DN_SERVICE_GROUP_CODE ,
    TDL.FK_VERSION                                                     AS FK_VERSION ,
    TDL.DA_BOOKED_TOT                                                  AS DA_BOOKED_TOT ,
    TDL.DA_DISCHARGED_TOT                                              AS DA_DISCHARGED_TOT ,
    TDL.DA_ROB_TOT                                                     AS DA_ROB_TOT ,
    TDL.DA_OVERLANDED_TOT                                              AS DA_OVERLANDED_TOT ,
    TDL.DA_SHORTLANDED_TOT                                             AS DA_SHORTLANDED_TOT ,
    TDL.RECORD_ADD_USER                                                AS DL_RECORD_ADD_USER ,
    TDL.RECORD_ADD_DATE                                                AS DL_RECORD_ADD_DATE ,
    TDL.RECORD_CHANGE_USER                                             AS DL_RECORD_CHANGE_USER ,
    TDL.RECORD_CHANGE_DATE                                             AS DL_RECORD_CHANGE_DATE ,
    TBD.DISCHARGE_STATUS                                               AS DISCH_STATUS
  FROM TOS_DL_DISCHARGE_LIST TDL ,
    TOS_DL_BOOKED_DISCHARGE TBD ,
    ITP060 ITP060 ,
    MV_ITP063 ITP063 ,
    BKP001 BKP001 ,
    BOOKING_VOYAGE_ROUTING_DTL BVRD ,
    SHP041 CLR1 ,
    SHP041 CLR2 ,
    SHP007 HAN1 ,
    SHP007 HAN2 ,
    SHP007 HAN3 ,
    (SELECT PK_BOOKED_DISCHARGE_ID ,
      SERVICE ,
      VESSEL ,
      VOYNO ,
      DIRECTION ,
      LOAD_PORT
    FROM
      (SELECT TBD.PK_BOOKED_DISCHARGE_ID ,
        BVRD.SERVICE ,
        BVRD.VESSEL ,
        BVRD.VOYNO ,
        BVRD.DIRECTION ,
        BVRD.LOAD_PORT ,
        ROW_NUMBER() OVER(PARTITION BY BVRD.BOOKING_NO ORDER BY BVRD.VOYAGE_SEQNO DESC) SR_NO
      FROM BOOKING_VOYAGE_ROUTING_DTL BVRD ,
        TOS_DL_BOOKED_DISCHARGE TBD
      WHERE BVRD.BOOKING_NO = TBD.FK_BOOKING_NO
      AND BVRD.VOYAGE_SEQNO < TBD.FK_BKG_VOYAGE_ROUTING_DTL
      )
    WHERE SR_NO = 1
    ) PBVRD -- To Get Data for Previous Service Vessel Voyage
    ,
    (SELECT PK_BOOKED_DISCHARGE_ID ,
      SERVICE ,
      VESSEL ,
      VOYNO ,
      DIRECTION ,
      LOAD_PORT ,
      POL_PCSQ ,
      POL_ARRIVAL_DATE ,
      POL_ARRIVAL_TIME ,
      FROM_TERMINAL
    FROM
      (SELECT TBD.PK_BOOKED_DISCHARGE_ID ,
        BVRD.SERVICE ,
        BVRD.VESSEL ,
        BVRD.VOYNO ,
        BVRD.DIRECTION ,
        BVRD.LOAD_PORT ,
        BVRD.POL_PCSQ ,
        BVRD.POL_ARRIVAL_DATE ,
        BVRD.POL_ARRIVAL_TIME ,
        BVRD.FROM_TERMINAL ,
        ROW_NUMBER() OVER(PARTITION BY BVRD.BOOKING_NO ORDER BY BVRD.VOYAGE_SEQNO ASC) SR_NO
      FROM BOOKING_VOYAGE_ROUTING_DTL BVRD ,
        TOS_DL_BOOKED_DISCHARGE TBD
      WHERE BVRD.BOOKING_NO = TBD.FK_BOOKING_NO
      AND BVRD.VOYAGE_SEQNO > TBD.FK_BKG_VOYAGE_ROUTING_DTL
      )
    WHERE SR_NO = 1
    ) NBVRD -- To Get Data for Next Service Vessel Voyage
    ,
    (SELECT SPLI.PRSN_LOG_ID ,
      FSC.CRFLV1 ,
      FSC.CRFLV2 ,
      FSC.CRFLV3
    FROM SC_PRSN_LOG_INFO SPLI ,
      ITP188 FSC
    WHERE SPLI.FSC_CODE = FSC.CRCNTR
    ) UAB
  WHERE TDL.PK_DISCHARGE_LIST_ID    = TBD.FK_DISCHARGE_LIST_ID
  AND TDL.FK_SERVICE                = ITP063.VVSRVC
  AND TDL.FK_VESSEL                 = ITP063.VVVESS
  AND TDL.FK_VOYAGE                 = ITP063.VVVOYN
  AND TDL.FK_DIRECTION              = ITP063.VVPDIR
  AND TDL.FK_PORT_SEQUENCE_NO       = ITP063.VVPCSQ
  AND ITP063.VVVERS                 = '99'
  AND TBD.FK_BOOKING_NO             = BKP001.BABKNO
  AND TBD.FK_BOOKING_NO             = BVRD.BOOKING_NO
  AND TBD.FK_BKG_VOYAGE_ROUTING_DTL = BVRD.VOYAGE_SEQNO
  AND TBD.PK_BOOKED_DISCHARGE_ID    = PBVRD.PK_BOOKED_DISCHARGE_ID (+)
  AND TBD.PK_BOOKED_DISCHARGE_ID    = NBVRD.PK_BOOKED_DISCHARGE_ID(+)
  AND TDL.FK_VESSEL                 = ITP060.VSVESS
  AND TBD.CONTAINER_LOADING_REM_1   = CLR1.CLR_CODE (+)
  AND TBD.CONTAINER_LOADING_REM_2   = CLR2.CLR_CODE (+)
  AND TBD.FK_HANDLING_INSTRUCTION_1 = HAN1.SHI_CODE (+)
  AND TBD.FK_HANDLING_INSTRUCTION_2 = HAN2.SHI_CODE (+)
  AND TBD.FK_HANDLING_INSTRUCTION_3 = HAN3.SHI_CODE (+)
  AND TBD.RECORD_CHANGE_USER        = UAB.PRSN_LOG_ID (+);