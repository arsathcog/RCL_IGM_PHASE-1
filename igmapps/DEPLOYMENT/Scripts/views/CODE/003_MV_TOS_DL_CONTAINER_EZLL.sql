/* -----------------------------------------------------------------------------
System  : EZLL
Module  : BAYPLAN
Name    : V_TOS_DL_CONTAINER_EZLL.sql
Purpose : A join of TOS_DL_DISCHARGE_LIST + TOS_DL_BOOKED_DISCHARGE + ITP063 showing 
          eta etd from ITP063 but no shortlanded containers.
--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author		Date		    What
---------------	---------------	------------------------------------------------
Dhruv 	        06/07/2011	<Initial version>
Dhruv           07/07/2011      v0.2
Dhruv           14/07/2011      v0.3
Dhruv           20/09/2011      v0.31
WACCHO1		04/10/2011	v0.32
--Change Log--------------------------------------------------------------------
##    DD/MM/YY     User-Task/CR No   -Short Description-
01    14/07/11                       Normal view converted to materialized view.
                                     And renamed to MV_TOS_DL_CONTAINER_EZLL
02    20/09/11     Dhruv             Added parallel hints for MV_ITP063, V_TOS_DISCHLIST_DTL
                                     And TOS_DL_DISCHARGE_LIST for better performance.
03    04/10/11	   WACCHO1	     Remove Dir Checking, some cntr missing due to directon <> vvpdir
----------------------------------------------------------------------------- 
**/
--DROP VIEW MV_TOS_DL_CONTAINER_EZLL; --##01

DROP MATERIALIZED  VIEW MV_TOS_DL_CONTAINER_EZLL; --##03

CREATE MATERIALIZED VIEW "MV_TOS_DL_CONTAINER_EZLL" --##01
("DL_SERVICE",
"DL_VESSEL",
"DL_VOYAGE",
"DL_DIRECTION",
"DL_PORT_SEQ",
"DL_POD",
"DL_ETA",
"DL_ETD",
"DL_PK_BOOKED_DISCHARGE_ID",
"DL_FK_BOOKING_NO",
"DL_CONTAINER_SEQ_NO",
"DL_POD_DATE",
"DL_POD_TIME",
"DL_POD_TERMINAL",
"DL_DN_FINAL_POD",
"DL_CONTAINER_GROSS_WEIGHT",
"DL_DN_HUMIDITY",
"DL_DN_VENTILATION",
"DL_DN_EQUIPMENT_NO",
"DL_REEFER_TEMPERATURE",
"DL_REEFER_TMP_UNIT",
"DL_OVERHEIGHT_CM",
"DL_OVERLENGTH_FRONT_CM",
"DL_OVERLENGTH_REAR_CM",
"DL_OVERWIDTH_RIGHT_CM",
"DL_OVERWIDTH_LEFT_CM",
"DL_OOG_OW",
"DL_OOG_OL",
"DL_DN_SOC_COC",
"DL_STOWAGE_POSITION",
"DL_DN_SHIPMENT_TERM",
"DL_DN_SHIPMENT_TYP",
"DL_DISCHARGE_LIST_STATUS",
"DL_DN_NXT_POD1",
"DL_DN_NXT_POD2",
"DL_DN_NXT_POD3",
"DL_FINAL_DEST",
"DL_FLASH_POINT",
"DL_FLASH_UNIT",
"DL_FK_IMDG",
"DL_FK_UNNO",
"DL_RESIDUE_ONLY_FLAG",
"DL_DN_EQ_SIZE",
"DL_DN_EQ_TYPE",
"DL_FK_PORT_CLASS",
"DL_ACTIVITY_DATE_TIME",
"DL_RECORD_STATUS",
"DL_DL_RECORD_STATUS",
"DL_FK_DISCHARGE_LIST_ID",
"DL_FK_BKG_SIZE_TYPE_DTL",
"DL_FK_BKG_SUPPLIER",
"DL_FK_BKG_VOYAGE_ROUTING_DTL",
"DL_FK_BKG_EQUIPM_DTL",
"DL_CONTAINER_LOADING_REM_1",
"DL_CONTAINER_LOADING_REM_2",
"DL_FK_HANDLING_INSTRUCTION_1",
"DL_FK_HANDLING_INSTRUCTION_2",
"DL_FK_HANDLING_INSTRUCTION_3",
"DL_LOAD_CONDITION",
"DL_DN_POL_TERMINAL",
"DL_DN_TERMINAL",
"DL_DN_FULL_MT",
"DL_DN_BKG_TYP",
"DL_LOCAL_STATUS",
"DL_LOCAL_TERMINAL_STATUS",
"DL_MIDSTREAM_HANDLING_CODE",
"DL_DN_LOADING_STATUS",
"DL_DISCHARGE_STATUS",
"DL_DAMAGED",
"DL_VOID_SLOT",
"DL_OUT_SLOT_OPERATOR",
"DL_FK_SLOT_OPERATOR",
"DL_FK_CONTAINER_OPERATOR",
"DL_DN_SPECIAL_HNDL",
"DL_SEAL_NO",
"DL_DN_POL",
"DL_DN_NXT_SRV",
"DL_DN_NXT_VESSEL",
"DL_DN_NXT_VOYAGE",
"DL_DN_NXT_DIR",
"DL_MLO_VESSEL",
"DL_MLO_VOYAGE",
"DL_MLO_VESSEL_ETA",
"DL_MLO_POD1",
"DL_MLO_POD2",
"DL_MLO_POD3",
"DL_MLO_DEL",
"DL_SWAP_CONNECTION_ALLOWED",
"DL_FK_SPECIAL_CARGO",
"DL_TIGHT_CONNECTION_FLAG1",
"DL_TIGHT_CONNECTION_FLAG2",
"DL_TIGHT_CONNECTION_FLAG3",
"DL_FK_UN_VAR",
"DL_FK_PORT_CLASS_TYP",
"DL_FUMIGATION_ONLY",
"DL_PUBLIC_REMARK",
"DL_RECORD_ADD_USER",
"DL_RECORD_ADD_DATE",
"DL_RECORD_CHANGE_USER",
"DL_RECORD_CHANGE_DATE",
"DL_PK_DISCHARGE_LIST_ID",
"DL_DN_SERVICE_GROUP_CODE",
"DL_FK_VERSION",
"DL_DA_BOOKED_TOT",
"DL_DA_DISCHARGED_TOT",
"DL_DA_ROB_TOT",
"DL_DA_OVERLANDED_TOT",
"DL_DA_SHORTLANDED_TOT",
"DL_DL_RECORD_ADD_USER",
"DL_DL_RECORD_ADD_DATE",
"DL_DL_RECORD_CHANGE_USER",
"DL_DL_RECORD_CHANGE_DATE")
REFRESH COMPLETE ON DEMAND 
USING DEFAULT LOCAL ROLLBACK SEGMENT
DISABLE QUERY REWRITE
--CREATE OR REPLACE VIEW V_TOS_DL_CONTAINER_EZLL
AS
  SELECT  /*+ PARALLEL(IT,4) PARALLEL(BD,4) PARALLEL(DL,4)*/ --##02
       DL.FK_SERVICE                  DL_SERVICE
      ,DL.FK_VESSEL                   DL_VESSEL
      ,DL.FK_VOYAGE                   DL_VOYAGE
      ,DL.FK_DIRECTION                DL_DIRECTION      
      ,DL.FK_PORT_SEQUENCE_NO         DL_PORT_SEQ 
      ,DL.DN_PORT                     DL_POD       
      ,TO_CHAR(TO_DATE(IT.VVARDT,'YYYY/MM/DD'),'DD/MM/YYYY') DL_ETA
      ,TO_CHAR(TO_DATE(IT.VVDPDT,'YYYY/MM/DD'),'DD/MM/YYYY') DL_ETD
      ,BD.PK_BOOKED_DISCHARGE_ID      DL_PK_BOOKED_DISCHARGE_ID
      ,BD.BOOKING_NO		      DL_FK_BOOKING_NO
      ,BD.SEQ_NO		      DL_CONTAINER_SEQ_NO
      ,BD.POD_DATE		      DL_POD_DATE	
      ,BD.POD_TIME		      DL_POD_TIME
      ,BD.POD_TERMINAL		      DL_POD_TERMINAL	
      ,BD.FINAL_POD                   DL_DN_FINAL_POD
      ,BD.CONTAINER_GROSS_WEIGHT      DL_CONTAINER_GROSS_WEIGHT
      ,BD.DN_HUMIDITY		      DL_DN_HUMIDITY
      ,BD.DN_VENTILATION              DL_DN_VENTILATION 
      ,BD.CONTAINER_NO                DL_DN_EQUIPMENT_NO
      ,BD.RFTEMP                      DL_REEFER_TEMPERATURE
      ,BD.UNIT			      DL_REEFER_TMP_UNIT
      ,BD.OOG_OH                      DL_OVERHEIGHT_CM
      ,BD.OOG_OLF                     DL_OVERLENGTH_FRONT_CM
      ,BD.OOG_OLB                     DL_OVERLENGTH_REAR_CM
      ,BD.OOG_OWR                     DL_OVERWIDTH_RIGHT_CM
      ,BD.OOG_OWL                     DL_OVERWIDTH_LEFT_CM
      ,BD.OOG_OW                      DL_OOG_OW
      ,BD.OOG_OL                      DL_OOG_OL
      ,BD.SOC_COC                     DL_DN_SOC_COC
      ,BD.STOW_POSITION               DL_STOWAGE_POSITION
      ,BD.SHIP_TERM		      DL_DN_SHIPMENT_TERM
      ,BD.SHIP_TYPE                   DL_DN_SHIPMENT_TYP
      ,BD.LIST_STATUS                 DL_DISCHARGE_LIST_STATUS
      ,BD.NEXT_POD1		      DL_DN_NXT_POD1
      ,BD.NEXT_POD2		      DL_DN_NXT_POD2
      ,BD.NEXT_POD3		      DL_DN_NXT_POD3
      ,BD.FINAL_DESTINATION           DL_FINAL_DEST
      ,BD.FLASH_PT                    DL_FLASH_POINT
      ,BD.FLASH_PT_UNIT               DL_FLASH_UNIT
      ,BD.IMDG                        DL_FK_IMDG
      ,BD.UNNO                        DL_FK_UNNO
      ,BD.RESIDUE_ONLY_FLAG           DL_RESIDUE_ONLY_FLAG
      ,BD.EQSIZE                      DL_DN_EQ_SIZE
      ,BD.EQTYPE                      DL_DN_EQ_TYPE
      ,BD.PORT_CLASS                  DL_FK_PORT_CLASS
      ,BD.ACTIVITY_DATE_TIME          DL_ACTIVITY_DATE_TIME
      ,BD.RECORD_STATUS               DL_RECORD_STATUS
      ,BD.DL_RECORD_STATUS            DL_DL_RECORD_STATUS
      ,BD.FK_DISCHARGE_LIST_ID        DL_FK_DISCHARGE_LIST_ID
      ,BD.FK_BKG_SIZE_TYPE_DTL        DL_FK_BKG_SIZE_TYPE_DTL
      ,BD.FK_BKG_SUPPLIER             DL_FK_BKG_SUPPLIER
      ,BD.FK_BKG_VOYAGE_ROUTING_DTL   DL_FK_BKG_VOYAGE_ROUTING_DTL
      ,BD.FK_BKG_EQUIPM_DTL           DL_FK_BKG_EQUIPM_DTL
      ,BD.CLR1			      DL_CONTAINER_LOADING_REM_1
      ,BD.CLR2			      DL_CONTAINER_LOADING_REM_2
      ,BD.HAN1			      DL_FK_HANDLING_INSTRUCTION_1
      ,BD.HAN2			      DL_FK_HANDLING_INSTRUCTION_2
      ,BD.HAN3			      DL_FK_HANDLING_INSTRUCTION_3
      ,BD.LOAD_CONDITION              DL_LOAD_CONDITION
      ,BD.POL_TERMINAL                DL_DN_POL_TERMINAL
      ,DL.DN_TERMINAL                 DL_DN_TERMINAL
      ,BD.FULL_MT                     DL_DN_FULL_MT
      ,BD.DN_BKG_TYP                  DL_DN_BKG_TYP
      ,BD.LOCAL_TS                    DL_LOCAL_STATUS
      ,BD.LOCAL_CONTAINER_STATUS      DL_LOCAL_TERMINAL_STATUS
      ,BD.MIDSTREAM_HANDLING_CODE     DL_MIDSTREAM_HANDLING_CODE
      ,BD.DN_LOADING_STATUS           DL_DN_LOADING_STATUS
      ,BD.ROB                         DL_DISCHARGE_STATUS
      ,BD.DAMAGED                     DL_DAMAGED
      ,BD.KILLED_SLOT                 DL_VOID_SLOT
      ,BD.SLOT_OPERATOR               DL_OUT_SLOT_OPERATOR
      ,BD.FK_SLOT_OPERATOR            DL_FK_SLOT_OPERATOR
      ,BD.CONTAINER_OPERATOR          DL_FK_CONTAINER_OPERATOR
      ,BD.DN_SPECIAL_HNDL             DL_DN_SPECIAL_HNDL
      ,BD.SEAL_NO                     DL_SEAL_NO
      ,BD.DN_POL                      DL_DN_POL
      ,BD.DN_NXT_SRV                  DL_DN_NXT_SRV
      ,BD.DN_NXT_VESSEL               DL_DN_NXT_VESSEL
      ,BD.DN_NXT_VOYAGE               DL_DN_NXT_VOYAGE
      ,BD.DN_NXT_DIR                  DL_DN_NXT_DIR
      ,BD.CONNECTING_VESSEL           DL_MLO_VESSEL
      ,BD.CONNECTING_VOYAGE_NO        DL_MLO_VOYAGE
      ,BD.MLO_VESSEL_ETA              DL_MLO_VESSEL_ETA
      ,BD.MLO_POD1                    DL_MLO_POD1
      ,BD.MLO_POD2                    DL_MLO_POD2
      ,BD.MLO_POD3                    DL_MLO_POD3
      ,BD.MLO_DEL                     DL_MLO_DEL
      ,BD.SWAP_CONNECTION_ALLOWED     DL_SWAP_CONNECTION_ALLOWED
      ,BD.SPECIAL_CARGO               DL_FK_SPECIAL_CARGO
      ,BD.TIGHT_CONN_FLAG             DL_TIGHT_CONNECTION_FLAG1
      ,BD.TIGHT_CONN_FLAG2            DL_TIGHT_CONNECTION_FLAG2
      ,BD.TIGHT_CONN_FLAG3            DL_TIGHT_CONNECTION_FLAG3
      ,BD.VARIANT                     DL_FK_UN_VAR
      ,BD.FK_PORT_CLASS_TYP           DL_FK_PORT_CLASS_TYP
      ,BD.FUMIGATION_ONLY             DL_FUMIGATION_ONLY
      ,BD.REMARKS                     DL_PUBLIC_REMARK
      ,BD.RECORD_ADD_USER             DL_RECORD_ADD_USER
      ,BD.RECORD_ADD_DATE             DL_RECORD_ADD_DATE
      ,BD.RECORD_CHANGE_USER          DL_RECORD_CHANGE_USER
      ,BD.RECORD_CHANGE_DATE          DL_RECORD_CHANGE_DATE
      ,BD.PK_DISCHARGE_LIST_ID        DL_PK_DISCHARGE_LIST_ID
      ,BD.DN_SERVICE_GROUP_CODE       DL_DN_SERVICE_GROUP_CODE
      ,BD.FK_VERSION                  DL_FK_VERSION
      ,BD.DA_BOOKED_TOT               DL_DA_BOOKED_TOT          
      ,BD.DA_DISCHARGED_TOT    	      DL_DA_DISCHARGED_TOT    
      ,BD.DA_ROB_TOT           	      DL_DA_ROB_TOT           
      ,BD.DA_OVERLANDED_TOT    	      DL_DA_OVERLANDED_TOT    
      ,BD.DA_SHORTLANDED_TOT   	      DL_DA_SHORTLANDED_TOT   
      ,BD.DL_RECORD_ADD_USER   	      DL_DL_RECORD_ADD_USER   
      ,BD.DL_RECORD_ADD_DATE   	      DL_DL_RECORD_ADD_DATE   
      ,BD.DL_RECORD_CHANGE_USER	      DL_DL_RECORD_CHANGE_USER
      ,BD.DL_RECORD_CHANGE_DATE	      DL_DL_RECORD_CHANGE_DATE
FROM   MV_ITP063 IT,
       V_TOS_DISCHLIST_DTL BD,
       TOS_DL_DISCHARGE_LIST DL
WHERE  DECODE(DL.FK_SERVICE, 'AFS' , IT.VVVOYN, IT.INVOYAGENO ) = DL.FK_VOYAGE
AND    IT.VVVESS               = DL.FK_VESSEL
AND    IT.VVPCAL               = DL.DN_PORT
AND    IT.VVPCSQ               = DL.FK_PORT_SEQUENCE_NO
--AND    IT.VVPDIR               = DL.FK_DIRECTION --##03
AND    IT.VVTRM1               = DL.DN_TERMINAL
AND    BD.FK_DISCHARGE_LIST_ID = DL.PK_DISCHARGE_LIST_ID
AND    DL.DISCHARGE_LIST_STATUS <> 'SL'
AND    IT.VVVERS               = '99'
AND    IT.VVARDT >= NVL( (SELECT CONFIG_VALUE FROM VCM_CONFIG_MST WHERE CONFIG_TYP = 'TABLE_FILTER' AND CONFIG_CD = 'VVARDT'), 0);
