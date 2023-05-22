CREATE OR REPLACE VIEW V_TOS_DL_CONTAINER_SL
AS
SELECT DL.POD_SERVICE		DL_SERVICE
   ,DL.POD_VESSEL		DL_VESSEL
   ,DL.POD_VOYAGE		DL_VOYAGE
   ,DL.POD_DIR			DL_DIRECTION
   ,DL.POD_PCSQ		        DL_PORT_SEQ
   ,DL.POD			DL_POD
   ,DL.POD_TERMINAL             DL_POD_ERMINAL
   ,TO_CHAR(TO_DATE(IT.VVARDT,'YYYY/MM/DD'),'DD/MM/YYYY') DL_ETA
   ,TO_CHAR(TO_DATE(IT.VVDPDT,'YYYY/MM/DD'),'DD/MM/YYYY') DL_ETD
   ,DL.BOOKING_NO		DL_FK_BOOKING_NO
   ,DL.SEQ_NO			DL_CONTAINER_SEQ_NO
   ,DL.POD_DATE			DL_POD_DATE	
   ,DL.POD_TIME			DL_POD_TIME
   ,DL.POD_TERMINAL		DL_POD_TERMINAL
   ,DL.CONTAINER_NO		DL_DN_EQUIPMENT_NO
   ,DL.RFTEMP			DL_REEFER_TEMPERATURE
   ,DL.UNIT			DL_REEFER_TMP_UNIT
   ,DL.OOG_OH			DL_OVERHEIGHT_CM
   ,DL.OOG_OLF			DL_OVERLENGTH_FRONT_CM
   ,DL.OOG_OLB			DL_OVERLENGTH_REAR_CM
   ,DL.OOG_OWR			DL_OVERWIDTH_RIGHT_CM
   ,DL.OOG_OWL			DL_OVERWIDTH_LEFT_CM
   ,DL.OOG_OW			DL_OOG_OW
   ,DL.OOG_OL			DL_OOG_OL
   ,DL.SOC_COC			DL_DN_SOC_COC     
   ,DL.STOW_POSITION		DL_STOWAGE_POSITION  
   ,DL.SHIP_TERM		DL_DN_SHIPMENT_TERM
   ,DL.SHIP_TYPE		DL_DN_SHIPMENT_TYP
   ,DL.LIST_STATUS		DL_DISCHARGE_LIST_STATUS
   ,DL.NEXT_POD1		DL_DN_NXT_POD1
   ,DL.NEXT_POD2		DL_DN_NXT_POD2
   ,DL.NEXT_POD3		DL_DN_NXT_POD3
   ,DL.FINAL_DESTINATION	DL_FINAL_DEST
   ,DL.FLASH_PT			DL_FLASH_POINT
   ,DL.FLASH_PT_UNIT		DL_FLASH_UNIT
   ,DL.IMDG			DL_FK_IMDG
   ,DL.UNNO			DL_FK_UNNO
   ,DL.EQSIZE			DL_DN_EQ_SIZE
   ,DL.EQTYPE			DL_DN_EQ_TYPE
   ,DL.PORT_CLASS		DL_FK_PORT_CLASS
   ,DL.CLR1			DL_CONTAINER_LOADING_REM_1
   ,DL.CLR2    		        DL_CONTAINER_LOADING_REM_2
   ,DL.HAN1			DL_FK_HANDLING_INSTRUCTION_1
   ,DL.HAN2			DL_FK_HANDLING_INSTRUCTION_2
   ,DL.HAN3			DL_FK_HANDLING_INSTRUCTION_3
   ,DL.POL_TERMINAL		DL_DN_POL_TERMINAL
   ,DL.FULL_MT                  DL_DN_FULL_MT
   ,DL.LOCAL_TS                 DL_LOCAL_STATUS
   ,DL.LOCAL_CONTAINER_STATUS   DL_LOCAL_TERMINAL_STATUS
   ,DL.DISCHARGE_STATUS         DL_DISCHARGE_STATUS
   ,DL.KILLED_SLOT              DL_VOID_SLOT
   ,DL.SLOT_OPERATOR            DL_FK_SLOT_OPERATOR
   ,DL.CONTAINER_OPERATOR       DL_FK_CONTAINER_OPERATOR
   ,DL.OUT_SLOT_OPERATOR        DL_OUT_SLOT_OPERATOR
   ,DL.SPECIAL_CARGO            DL_FK_SPECIAL_CARGO
   ,DL.TIGHT_CONN_FLAG          DL_TIGHT_CONNECTION_FLAG1
   ,DL.VARIANT                  DL_FK_UN_VAR
FROM MV_ITP063	       IT
    ,TOS_DISCHLIST_DTL DL
WHERE VVVERS = 99
  AND VVARDT >= NVL( (SELECT CONFIG_VALUE FROM VCM_CONFIG_MST WHERE CONFIG_TYP = 'TABLE_FILTER' AND CONFIG_CD = 'VVARDT'), 0)
  AND IT.VVPCAL = DL.POD
  AND IT.VVTRM1 = DL.POD_TERMINAL
  AND IT.VVSRVC = DL.POD_SERVICE
  AND IT.VVVESS = DL.POD_VESSEL  
  AND IT.VVVOYN = DL.POD_VOYAGE 
  AND IT.VVPDIR = DL.POD_DIR 
  AND IT.VVPCSQ = DL.POD_PCSQ;