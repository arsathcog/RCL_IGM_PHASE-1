/* -----------------------------------------------------------------------------
System  : EZLL
Module  : BAYPLAN
Name    : V_TOS_LL_CONTAINER_EZLL.sql
Purpose : A join of TOS_LL_LOAD_LIST + TOS_LL_BOOKED_LOADING + ITP063 showing 
          eta etd from ITP063, no shortshipped containers.
--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author		Date		    What
---------------	---------------	------------------------------------------------
Dhruv 	        06/07/2011	<Initial version>
Dhruv           07/07/2011      v0.2
Dhruv           22/09/2011      v0.21
WACCHO1		04/10/2011	v0.22
--Change Log--------------------------------------------------------------------
##   DD/MM/YY     User-Task/CR No   -Short Description-
01   07/07/11     Dhruv             VVSDIR is replaced by VVPDIR.
02   22/09/11     Dhruv             PARALLEL hints with DEFAULT degree added for query optimization.
03   04/10/11	  WACCHO1	    Some container is missing due to direction <> vvpdir
--------------------------------------------------------------------------------
**/

CREATE OR REPLACE VIEW V_TOS_LL_CONTAINER_EZLL 
AS
SELECT /*+ PARALLEL(IT,DEFAULT) PARALLEL(BL,DEFAULT) PARALLEL(LL,DEFAULT) */
       LL.FK_SERVICE                 LL_SERVICE
      ,LL.FK_VESSEL                  LL_VESSEL
      ,LL.FK_VOYAGE                  LL_VOYAGE
      ,LL.FK_DIRECTION               LL_DIRECTION
      ,LL.FK_PORT_SEQUENCE_NO        LL_PORT_SEQ
      ,LL.DN_TERMINAL                LL_DN_TERMINAL
      ,LL.DN_PORT                    LL_POL
      ,TO_CHAR(TO_DATE(IT.VVARDT,'YYYY/MM/DD'),'DD/MM/YYYY') LL_ETA
      ,TO_CHAR(TO_DATE(IT.VVDPDT,'YYYY/MM/DD'),'DD/MM/YYYY') LL_ETD
      ,BL.STOW_POSITION		     LL_STOWAGE_POSITION
      ,BL.ACTIVITY_DATE_TIME         LL_ACTIVITY_DATE_TIME
      ,BL.LL_RECORD_STATUS           LL_LL_RECORD_STATUS
      ,BL.RECORD_STATUS              LL_RECORD_STATUS
      ,BL.FK_LOAD_LIST_ID            LL_FK_LOAD_LIST_ID
      ,BL.LIST_STATUS		     LL_LOAD_LIST_STATUS
      ,BL.BOOKING_NO		     LL_FK_BOOKING_NO
      ,BL.FK_BKG_SIZE_TYPE_DTL       LL_FK_BKG_SIZE_TYPE_DTL
      ,BL.FK_BKG_SUPPLIER            LL_FK_BKG_SUPPLIER
      ,BL.FK_BKG_EQUIPM_DTL          LL_FK_BKG_EQUIPM_DTL
      ,BL.FK_BKG_VOYAGE_ROUTING_DTL  LL_FK_BKG_VOYAGE_ROUTING_DTL
      ,BL.LOADING_STATUS             LL_LOADING_STATUS
      ,BL.POD_TERMINAL               LL_POD_TERMINAL
      ,BL.SEQ_NO		     LL_CONTAINER_SEQ_NO
      ,BL.DN_DISCHARGE_TERMINAL      LL_DN_DISCHARGE_TERMINAL
      ,BL.POL_TERMINAL               LL_DN_POL_TERMINAL
      ,BL.PK_BOOKED_LOADING_ID       LL_PK_BOOKED_LOADING_ID
      ,BL.EQUPMENT_NO_SOURCE         LL_EQUPMENT_NO_SOURCE
      ,BL.CONTAINER_NO               LL_DN_EQUIPMENT_NO
      ,BL.EQSIZE                     LL_DN_EQ_SIZE
      ,BL.EQTYPE                     LL_DN_EQ_TYPE
      ,BL.FULL_MT                    LL_DN_FULL_MT
      ,BL.DN_BKG_TYP                 LL_DN_BKG_TYP
      ,BL.SOC_COC                    LL_DN_SOC_COC
      ,BL.SHIP_TERM                  LL_DN_SHIPMENT_TERM
      ,BL.SHIP_TYPE                  LL_DN_SHIPMENT_TYP
      ,BL.LOCAL_TS                   LL_LOCAL_STATUS
      ,BL.LOCAL_TERMINAL_STATUS      LL_LOCAL_TERMINAL_STATUS
      ,BL.MIDSTREAM_HANDLING_CODE    LL_MIDSTREAM_HANDLING_CODE
      ,BL.LOAD_CONDITION             LL_LOAD_CONDITION
      ,BL.WEIGHT                     LL_CONTAINER_GROSS_WEIGHT
      ,BL.DAMAGED                    LL_DAMAGED
      ,BL.KILLED_SLOT                LL_VOID_SLOT
      ,BL.PREADVICE_FLAG             LL_PREADVICE_FLAG
      ,BL.SLOT_OPERATOR              LL_FK_SLOT_OPERATOR
      ,BL.CONTAINER_OPERATOR         LL_FK_CONTAINER_OPERATOR
      ,BL.OUT_SLOT_OPERATOR          LL_OUT_SLOT_OPERATOR
      ,BL.DN_SPECIAL_HNDL            LL_DN_SPECIAL_HNDL
      ,BL.SEAL_NO                    LL_SEAL_NO
      ,BL.POD                        LL_DN_DISCHARGE_PORT
      ,BL.NEXT_POD1                  LL_DN_NXT_POD1
      ,BL.NEXT_POD2                  LL_DN_NXT_POD2
      ,BL.NEXT_POD3                  LL_DN_NXT_POD3
      ,BL.DN_FINAL_POD               LL_DN_FINAL_POD
      ,BL.FINAL_DESTINATION          LL_FINAL_DEST
      ,BL.DN_NXT_SRV                 LL_DN_NXT_SRV
      ,BL.DN_NXT_VESSEL              LL_DN_NXT_VESSEL
      ,BL.DN_NXT_VOYAGE              LL_DN_NXT_VOYAGE
      ,BL.DN_NXT_DIR                 LL_DN_NXT_DIR
      ,BL.CONNECTING_VESSEL          LL_MLO_VESSEL
      ,BL.CONNECTING_VOYAGE_NO       LL_MLO_VOYAGE
      ,BL.MLO_VESSEL_ETA             LL_MLO_VESSEL_ETA
      ,BL.MLO_POD1                   LL_MLO_POD1
      ,BL.MLO_POD2                   LL_MLO_POD2
      ,BL.MLO_POD3                   LL_MLO_POD3
      ,BL.MLO_DEL                    LL_MLO_DEL
      ,BL.EX_MLO_VESSEL              LL_EX_MLO_VESSEL
      ,BL.EX_MLO_VESSEL_ETA          LL_EX_MLO_VESSEL_ETA
      ,BL.EX_MLO_VOYAGE              LL_EX_MLO_VOYAGE
      ,BL.HAN1                       LL_FK_HANDLING_INSTRUCTION_1
      ,BL.HAN2                       LL_FK_HANDLING_INSTRUCTION_2
      ,BL.HAN3                       LL_FK_HANDLING_INSTRUCTION_3
      ,BL.CLR1                       LL_CONTAINER_LOADING_REM_1
      ,BL.CLR2                       LL_CONTAINER_LOADING_REM_2
      ,BL.SPECIAL_CARGO              LL_FK_SPECIAL_CARGO
      ,BL.TIGHT_CONN_FLAG            LL_TIGHT_CONNECTION_FLAG1
      ,BL.TIGHT_CONN_FLAG2           LL_TIGHT_CONNECTION_FLAG2
      ,BL.TIGHT_CONN_FLAG3           LL_TIGHT_CONNECTION_FLAG3
      ,BL.IMDG                       LL_FK_IMDG
      ,BL.UNNO                       LL_FK_UNNO
      ,BL.VARIANT                    LL_FK_UN_VAR
      ,BL.PORT_CLASS                 LL_FK_PORT_CLASS
      ,BL.FK_PORT_CLASS_TYP          LL_FK_PORT_CLASS_TYP
      ,BL.FLASH_PT_UNIT              LL_FLASH_UNIT
      ,BL.FLASH_PT                   LL_FLASH_POINT
      ,BL.FUMIGATION_ONLY            LL_FUMIGATION_ONLY
      ,BL.RESIDUE_ONLY_FLAG          LL_RESIDUE_ONLY_FLAG
      ,BL.OOG_OH                     LL_OVERHEIGHT_CM
      ,BL.OOG_OLF                    LL_OVERLENGTH_FRONT_CM 
      ,BL.OOG_OLB                    LL_OVERLENGTH_REAR_CM
      ,BL.OOG_OWR                    LL_OVERWIDTH_RIGHT_CM
      ,BL.OOG_OWL                    LL_OVERWIDTH_LEFT_CM     
      ,BL.RFTEMP                     LL_REEFER_TMP
      ,BL.UNIT                       LL_REEFER_TMP_UNIT
      ,BL.DN_HUMIDITY                LL_DN_HUMIDITY
      ,BL.DN_VENTILATION             LL_DN_VENTILATION
      ,BL.REMARKS                    LL_PUBLIC_REMARKS
      ,BL.RECORD_ADD_USER            LL_RECORD_ADD_USER
      ,BL.RECORD_ADD_DATE            LL_RECORD_ADD_DATE
      ,BL.RECORD_CHANGE_USER         LL_RECORD_CHANGE_USER
      ,BL.RECORD_CHANGE_DATE         LL_RECORD_CHANGE_DATE
      ,BL.PK_LOAD_LIST_ID            LL_PK_LOAD_LIST_ID
      ,BL.DN_SERVICE_GROUP_CODE      LL_DN_SERVICE_GROUP_CODE
      ,BL.FK_VERSION                 LL_FK_VERSION
      ,BL.DA_BOOKED_TOT              LL_DA_BOOKED_TOT
      ,BL.DA_LOADED_TOT              LL_DA_LOADED_TOT
      ,BL.DA_ROB_TOT                 LL_DA_ROB_TOT
      ,BL.DA_OVERSHIPPED_TOT         LL_DA_OVERSHIPPED_TOT
      ,BL.DA_SHORTSHIPPED_TOT        LL_DA_SHORTSHIPPED_TOT
      ,BL.LL_RECORD_ADD_USER         LL_LL_RECORD_ADD_USER
      ,BL.LL_RECORD_ADD_DATE         LL_LL_RECORD_ADD_DATE
      ,BL.LL_RECORD_CHANGE_USER      LL_LL_RECORD_CHANGE_USER
      ,BL.LL_RECORD_CHANGE_DATE      LL_LL_RECORD_CHANGE_DATE
      ,BL.BOOKING_NO                 LL_BOOKING_NO
FROM   MV_ITP063 IT,
       V_TOS_ONBOARD_LIST BL,
       TOS_LL_LOAD_LIST LL
WHERE  IT.VVSRVC          = LL.FK_SERVICE
AND    IT.VVVESS          = LL.FK_VESSEL
AND    IT.VVVOYN          = LL.FK_VOYAGE
--AND    IT.VVPDIR          = LL.FK_DIRECTION   --##01,--#03
AND    IT.VVPCSQ          = LL.FK_PORT_SEQUENCE_NO
AND    IT.VVPCAL          = LL.DN_PORT
AND    IT.VVTRM1          = LL.DN_TERMINAL
AND    BL.FK_LOAD_LIST_ID = LL.PK_LOAD_LIST_ID
AND    LL.LOAD_LIST_STATUS <> 'SS'
AND    IT.VVVERS          = '99'
AND    IT.VVARDT >= NVL( (SELECT CONFIG_VALUE FROM VCM_CONFIG_MST WHERE CONFIG_TYP = 'TABLE_FILTER' AND CONFIG_CD = 'VVARDT'), 0);