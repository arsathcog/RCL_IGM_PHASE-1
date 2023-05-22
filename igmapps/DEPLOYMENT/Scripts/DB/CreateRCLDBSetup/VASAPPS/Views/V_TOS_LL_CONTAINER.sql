CREATE OR REPLACE VIEW V_TOS_LL_CONTAINER AS
SELECT LL_SERVICE
      ,LL_VESSEL
      ,LL_VOYAGE
      ,LL_DIRECTION
      ,LL_PORT_SEQ
      ,LL_POL
      ,LL_ETD
      ,LL_PK_BOOKED_LOADING_ID
      ,LL_FK_LOAD_LIST_ID
      ,LL_CONTAINER_SEQ_NO
      ,LL_FK_BOOKING_NO
      ,LL_FK_BKG_SIZE_TYPE_DTL
      ,LL_FK_BKG_SUPPLIER
      ,LL_FK_BKG_EQUIPM_DTL
      ,LL_DN_EQUIPMENT_NO
      ,LL_EQUPMENT_NO_SOURCE
      ,LL_FK_BKG_VOYAGE_ROUTING_DTL
      ,LL_DN_EQ_SIZE
      ,LL_DN_EQ_TYPE
      ,LL_DN_FULL_MT
      ,LL_DN_BKG_TYP
      ,LL_DN_SOC_COC
      ,LL_DN_SHIPMENT_TERM
      ,LL_DN_SHIPMENT_TYP
      ,LL_LOCAL_STATUS
      ,LL_LOCAL_TERMINAL_STATUS
      ,LL_MIDSTREAM_HANDLING_CODE
      ,LL_LOAD_CONDITION
      ,LL_LOADING_STATUS
      ,LL_STOWAGE_POSITION
      ,TO_CHAR(LL_ACTIVITY_DATE_TIME,'DD/MM/YYYY') LL_ACTIVITY_DATE_TIME
      ,LL_CONTAINER_GROSS_WEIGHT
      ,LL_DAMAGED
      ,LL_VOID_SLOT
      ,LL_PREADVICE_FLAG
      ,LL_FK_SLOT_OPERATOR
      ,LL_FK_CONTAINER_OPERATOR
      ,LL_OUT_SLOT_OPERATOR
      ,LL_DN_SPECIAL_HNDL
      ,LL_SEAL_NO
      ,LL_DN_DISCHARGE_PORT
      ,LL_DN_DISCHARGE_TERMINAL
      ,LL_DN_NXT_POD1
      ,LL_DN_NXT_POD2
      ,LL_DN_NXT_POD3
      ,LL_DN_FINAL_POD
      ,LL_FINAL_DEST   
      ,LL_DN_NXT_SRV    
      ,LL_DN_NXT_VESSEL 
      ,LL_DN_NXT_VOYAGE 
      ,LL_DN_NXT_DIR   
      ,LL_MLO_VESSEL
      ,LL_MLO_VOYAGE
      ,LL_MLO_VESSEL_ETA
      ,LL_MLO_POD1
      ,LL_MLO_POD2
      ,LL_MLO_POD3
      ,LL_MLO_DEL
      ,LL_EX_MLO_VESSEL      
      ,LL_EX_MLO_VESSEL_ETA  
      ,LL_EX_MLO_VOYAGE
      ,LL_FK_HANDLING_INSTRUCTION_1
      ,LL_FK_HANDLING_INSTRUCTION_2
      ,LL_FK_HANDLING_INSTRUCTION_3
      ,LL_CONTAINER_LOADING_REM_1
      ,LL_CONTAINER_LOADING_REM_2
      ,LL_FK_SPECIAL_CARGO
      ,LL_TIGHT_CONNECTION_FLAG1
      ,LL_TIGHT_CONNECTION_FLAG2
      ,LL_TIGHT_CONNECTION_FLAG3
      ,LL_FK_IMDG           
      ,LL_FK_UNNO           
      ,LL_FK_UN_VAR         
      ,LL_FK_PORT_CLASS     
      ,LL_FK_PORT_CLASS_TYP 
      ,LL_FLASH_UNIT        
      ,LL_FLASH_POINT       
      ,LL_FUMIGATION_ONLY
      ,LL_RESIDUE_ONLY_FLAG
      ,LL_OVERHEIGHT_CM       
      ,LL_OVERLENGTH_FRONT_CM 
      ,LL_OVERLENGTH_REAR_CM  
      ,LL_OVERWIDTH_RIGHT_CM  
      ,LL_OVERWIDTH_LEFT_CM   
      ,LL_REEFER_TMP     
      ,LL_REEFER_TMP_UNIT
      ,LL_DN_HUMIDITY
      ,LL_DN_VENTILATION
      ,LL_PUBLIC_REMARKS
      ,LL_RECORD_STATUS
      ,LL_RECORD_ADD_USER 
      ,LL_RECORD_ADD_DATE 
      ,LL_RECORD_CHANGE_USER
      ,LL_RECORD_CHANGE_DATE
      ,LL_LL_RECORD_STATUS
      ,LL_LOAD_LIST_STATUS
      ,LL_PK_LOAD_LIST_ID
      ,LL_DN_SERVICE_GROUP_CODE
      ,LL_FK_VERSION
      ,LL_DN_TERMINAL      
      ,LL_DA_BOOKED_TOT
      ,LL_DA_LOADED_TOT
      ,LL_DA_ROB_TOT
      ,LL_DA_OVERSHIPPED_TOT       
      ,LL_DA_SHORTSHIPPED_TOT                     
      ,LL_LL_RECORD_ADD_USER       
      ,LL_LL_RECORD_ADD_DATE       
      ,LL_LL_RECORD_CHANGE_USER    
      ,LL_LL_RECORD_CHANGE_DATE   
      ,LL_BOOKING_NO
FROM V_TOS_LL_CONTAINER_EZLL  TLCE
   , V_LL_PORT_CALL_EZLL      LPCE
WHERE LPCE.PORT      = TLCE.LL_POL
  AND LPCE.TERMINAL  = TLCE.LL_DN_TERMINAL
  AND LPCE.SERVICE   = TLCE.LL_SERVICE
  AND LPCE.VESSEL    = TLCE.LL_VESSEL
  AND LPCE.VOYAGE    = TLCE.LL_VOYAGE
  AND LPCE.DIRECTION = TLCE.LL_DIRECTION
  AND LPCE.PORT_SEQ  = TLCE.LL_PORT_SEQ
UNION ALL
SELECT LL_SERVICE
      ,LL_VESSEL
      ,LL_VOYAGE
      ,LL_DIRECTION
      ,LL_PORT_SEQ
      ,LL_POL
      ,LL_ETD
      ,NULL LL_PK_BOOKED_LOADING_ID
      ,NULL LL_FK_LOAD_LIST_ID
      ,NULL LL_CONTAINER_SEQ_NO
      ,LL_FK_BOOKING_NO
      ,NULL LL_FK_BKG_SIZE_TYPE_DTL
      ,NULL LL_FK_BKG_SUPPLIER
      ,NULL LL_FK_BKG_EQUIPM_DTL
      ,LL_DN_EQUIPMENT_NO
      ,NULL LL_EQUPMENT_NO_SOURCE      
      ,NULL LL_FK_BKG_VOYAGE_ROUTING_DTL
      ,LL_DN_EQ_SIZE
      ,LL_DN_EQ_TYPE
      ,LL_DN_FULL_MT
      ,NULL LL_DN_BKG_TYP
      ,LL_DN_SOC_COC
      ,LL_DN_SHIPMENT_TERM
      ,LL_DN_SHIPMENT_TYP
      ,LL_LOCAL_STATUS
      ,NULL LL_LOCAL_TERMINAL_STATUS
      ,NULL LL_MIDSTREAM_HANDLING_CODE
      ,NULL LL_LOAD_CONDITION
      ,NULL LL_LOADING_STATUS
      ,LL_STOWAGE_POSITION
      ,NULL LL_ACTIVITY_DATE_TIME
      ,NULL LL_CONTAINER_GROSS_WEIGHT
      ,NULL LL_DAMAGED
      ,LL_VOID_SLOT
      ,NULL LL_PREADVICE_FLAG
      ,LL_FK_SLOT_OPERATOR
      ,LL_FK_CONTAINER_OPERATOR
      ,NULL LL_OUT_SLOT_OPERATOR
      ,NULL LL_DN_SPECIAL_HNDL
      ,NULL LL_SEAL_NO
      ,LL_DN_DISCHARGE_PORT
      ,LL_DN_DISCHARGE_TERMINAL
      ,LL_DN_NXT_POD1
      ,LL_DN_NXT_POD2
      ,LL_DN_NXT_POD3
      ,NULL LL_DN_FINAL_POD
      ,LL_FINAL_DEST
      ,NULL LL_DN_NXT_SRV   
      ,NULL LL_DN_NXT_VESSEL
      ,NULL LL_DN_NXT_VOYAGE
      ,NULL LL_DN_NXT_DIR 
      ,LL_MLO_VESSEL 
      ,LL_MLO_VOYAGE 
      ,NULL LL_MLO_VESSEL_ETA
      ,NULL LL_MLO_POD1
      ,NULL LL_MLO_POD2
      ,NULL LL_MLO_POD3
      ,NULL LL_MLO_DEL
      ,NULL LL_EX_MLO_VESSEL     
      ,NULL LL_EX_MLO_VESSEL_ETA 
      ,NULL LL_EX_MLO_VOYAGE     
      ,LL_FK_HANDLING_INSTRUCTION_1
      ,LL_FK_HANDLING_INSTRUCTION_2
      ,LL_FK_HANDLING_INSTRUCTION_3
      ,LL_CONTAINER_LOADING_REM_1
      ,LL_CONTAINER_LOADING_REM_2
      ,LL_FK_SPECIAL_CARGO
      ,LL_TIGHT_CONNECTION_FLAG1
      ,NULL LL_TIGHT_CONNECTION_FLAG2
      ,NULL LL_TIGHT_CONNECTION_FLAG3
      ,LL_FK_IMDG           
      ,LL_FK_UNNO           
      ,LL_FK_UN_VAR         
      ,LL_FK_PORT_CLASS     
      ,NULL LL_FK_PORT_CLASS_TYP 
      ,LL_FLASH_UNIT        
      ,LL_FLASH_POINT   
      ,NULL LL_FUMIGATION_ONLY
      ,NULL LL_RESIDUE_ONLY_FLAG
      ,LL_OVERHEIGHT_CM
      ,LL_OVERLENGTH_FRONT_CM
      ,LL_OVERLENGTH_REAR_CM 
      ,LL_OVERWIDTH_RIGHT_CM 
      ,LL_OVERWIDTH_LEFT_CM  
      ,LL_REEFER_TMP      
      ,LL_REEFER_TMP_UNIT 
      ,NULL LL_DN_HUMIDITY
      ,NULL LL_DN_VENTILATION
      ,NULL LL_PUBLIC_REMARKS
      ,NULL LL_RECORD_STATUS
      ,NULL LL_RECORD_ADD_USER 
      ,NULL LL_RECORD_ADD_DATE
      ,NULL LL_RECORD_CHANGE_USER
      ,NULL LL_RECORD_CHANGE_DATE
      ,NULL LL_LL_RECORD_STATUS
      ,LL_LOAD_LIST_STATUS 
      ,NULL LL_PK_LOAD_LIST_ID
      ,NULL LL_DN_SERVICE_GROUP_CODE
      ,NULL LL_FK_VERSION
      ,NULL LL_DN_TERMINAL      
      ,NULL LL_DA_BOOKED_TOT
      ,NULL LL_DA_LOADED_TOT
      ,NULL LL_DA_ROB_TOT
      ,NULL LL_DA_OVERSHIPPED_TOT     
      ,NULL LL_DA_SHORTSHIPPED_TOT               
      ,NULL LL_LL_RECORD_ADD_USER    
      ,NULL LL_LL_RECORD_ADD_DATE    
      ,NULL LL_LL_RECORD_CHANGE_USER 
      ,NULL LL_LL_RECORD_CHANGE_DATE 
      ,LL_BOOKING_NO
FROM V_TOS_LL_CONTAINER_SL     TLCS
   , VASAPPS.V_LL_PORTCALL_SL  LPS
WHERE LPS.PORT       = TLCS.LL_POL 
  AND LPS.TERMINAL   = TLCS.LL_POL_TERMINAL
  AND LPS.SERVICE    = TLCS.LL_SERVICE
  AND LPS.VESSEL     = TLCS.LL_VESSEL
  AND LPS.VOYAGE     = TLCS.LL_VOYAGE
  AND LPS.DIRECTION  = TLCS.LL_DIRECTION
  AND LPS.PORT_SEQ   = TLCS.LL_PORT_SEQ;