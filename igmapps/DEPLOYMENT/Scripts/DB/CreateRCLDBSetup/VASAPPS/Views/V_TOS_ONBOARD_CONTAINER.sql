CREATE OR REPLACE VIEW V_TOS_ONBOARD_CONTAINER
AS
SELECT DL.DL_SERVICE
      ,DL.DL_VESSEL
      ,DL.DL_VOYAGE
      ,DL.DL_DIRECTION
      ,DL.DL_PORT_SEQ
      ,DL.DL_FK_BOOKING_NO
      ,DL.DL_DN_EQUIPMENT_NO
      ,LL.LL_POL
      ,DL.DL_POD
      ,TO_DATE(DL.DL_ETA,'DD/MM/YYYY HH24:MI') DL_ETA
      ,TO_DATE(LL.LL_ETD,'DD/MM/YYYY HH24:MI') LL_ETD
      ,DL.DL_DN_SHIPMENT_TYP
      ,DL.DL_DN_SOC_COC
      ,DL.DL_DN_FINAL_POD
      ,DL.DL_DN_NXT_POD1
      ,DL.DL_DN_NXT_POD2
      ,DL.DL_DN_NXT_POD3
      ,DL.DL_LOAD_CONDITION
      ,DL.DL_CONTAINER_GROSS_WEIGHT
      ,DL.DL_OVERLENGTH_FRONT_CM
      ,DL.DL_OVERLENGTH_REAR_CM
      ,DL.DL_OVERWIDTH_RIGHT_CM
      ,DL.DL_OVERWIDTH_LEFT_CM
      ,DL.DL_OVERHEIGHT_CM
      ,DL.DL_REEFER_TEMPERATURE
      ,DL.DL_REEFER_TMP_UNIT
      ,DL.DL_DN_HUMIDITY
      ,DL.DL_DN_VENTILATION
      ,DL.DL_FLASH_POINT
      ,DL.DL_FLASH_UNIT
      ,DL.DL_FK_IMDG
      ,DL.DL_FK_UNNO
      ,DL.DL_STOWAGE_POSITION
      ,LL.LL_STOWAGE_POSITION
      ,DL.DL_FK_HANDLING_INSTRUCTION_1
      ,DL.DL_FK_HANDLING_INSTRUCTION_2
      ,DL.DL_FK_HANDLING_INSTRUCTION_3
      ,DL.DL_CONTAINER_LOADING_REM_1
      ,DL.DL_CONTAINER_LOADING_REM_2
      ,DL.DL_RESIDUE_ONLY_FLAG
      ,DL.DL_DN_EQ_SIZE
      ,DL.DL_DN_EQ_TYPE
      ,DL.DL_FK_PORT_CLASS
      ,LL.LL_ACTIVITY_DATE_TIME
      ,DL.DL_ACTIVITY_DATE_TIME
      ,LL.LL_RECORD_STATUS
      ,LL.LL_LL_RECORD_STATUS
      ,DL.DL_RECORD_STATUS
      ,DL.DL_DL_RECORD_STATUS
      ,LL.LL_FK_LOAD_LIST_ID
      ,DL.DL_FK_DISCHARGE_LIST_ID
      ,LL.LL_LOAD_LIST_STATUS
      ,DL.DL_DISCHARGE_LIST_STATUS 
      ,LL.LL_VESSEL       
      ,DL.DL_DN_TERMINAL
      ,LL.LL_DN_TERMINAL
      ,DL.DL_POD_TERMINAL
      ,DL.DL_DN_POL_TERMINAL
      ,LL.LL_DN_DISCHARGE_TERMINAL
      ,DL.DL_CONTAINER_SEQ_NO
      ,LL.LL_CONTAINER_SEQ_NO
      ,DL.DL_FK_SLOT_OPERATOR
      ,DL.DL_FK_CONTAINER_OPERATOR
      ,LL.LL_FK_SLOT_OPERATOR
      ,LL.LL_FK_CONTAINER_OPERATOR
      ,DL.DL_DISCHARGE_STATUS
      ,LL.LL_LOADING_STATUS
FROM   V_TOS_DL_CONTAINER DL,
       V_TOS_LL_CONTAINER LL
WHERE  DL.DL_VESSEL                    = LL.LL_VESSEL
AND    DL.DL_FK_BOOKING_NO             = LL.LL_BOOKING_NO
AND    DL.DL_FK_BKG_SIZE_TYPE_DTL      = LL.LL_FK_BKG_SIZE_TYPE_DTL
AND    DL.DL_FK_BKG_SUPPLIER           = LL.LL_FK_BKG_SUPPLIER
AND    DL.DL_FK_BKG_EQUIPM_DTL         = LL.LL_FK_BKG_EQUIPM_DTL
AND    DL.DL_FK_BKG_VOYAGE_ROUTING_DTL = LL.LL_FK_BKG_VOYAGE_ROUTING_DTL
AND    LL.LL_LOADING_STATUS IN ('LO','RB');