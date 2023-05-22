/* -----------------------------------------------------------------------------
System  : EZLL
Module  : BAYPLAN
Name    : V_TOS_LL_CONTAINER_SL.sql
Purpose : A join on TOS_ONBOARD_LIST + ITP063 showing eta, etd from ITP063
--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author		Date		    What
---------------	---------------	------------------------------------------------
Dhruv 	        06/07/2011	<Initial version>
Dhruv           07/07/2011      v0.2
Dhruv           12/07/2011      v0.3
Dhruv           20/09/2011      v0.31
WACCHO1		04/10/2011	v0.32
Dhruv           09/11/2011      v0.33
--Change Log--------------------------------------------------------------------
##   DD/MM/YY     User-Task/CR No   -Short Description-
01   07/07/11     Dhruv             VVSDIR is replaced by VVPDIR.
02   12/07/11     Dhruv             Normal view changed to Materialized view.
                                    And Renamed to MV_TOS_LL_CONTAINER_SL.
03   20/09/11     Dhruv             Added Parallel hints for MV_ITP063 and 
                                    TOS_ONBOARD_LIST for better prformance.
04   04/10/11	  WACCHO1	    Remove Dir checking, some cntr missing due to Direction <> vvpdir
05   09/11/11     Dhruv             WEIGHT column is added as CONTAINER_GROSS_WEIGHT to fetch correct weight.
--------------------------------------------------------------------------------
**/

--DROP MATERIALIZED VIEW V_TOS_LL_CONTAINER_SL; --##02
DROP MATERIALIZED VIEW MV_TOS_LL_CONTAINER_SL; --##04

CREATE MATERIALIZED VIEW "MV_TOS_LL_CONTAINER_SL" --##02
("LL_SERVICE",
"LL_VESSEL",
"LL_VOYAGE",
"LL_DIRECTION",
"LL_PORT_SEQ",
"LL_POL_TERMINAL",
"LL_POL",
"LL_ETA",
"LL_ETD",
"LL_STOWAGE_POSITION",
"LL_LOAD_LIST_STATUS",
"LL_FK_BOOKING_NO",
"LL_DN_EQUIPMENT_NO",
"LL_DN_EQ_SIZE",
"LL_DN_EQ_TYPE",
"LL_DN_FULL_MT",
"LL_DN_SOC_COC",
"LL_DN_SHIPMENT_TERM",
"LL_DN_SHIPMENT_TYP",
"LL_LOCAL_STATUS",
"LL_VOID_SLOT",
"LL_FK_SLOT_OPERATOR",
"LL_FK_CONTAINER_OPERATOR",
"LL_DN_DISCHARGE_PORT",
"LL_DN_DISCHARGE_TERMINAL",
"LL_DN_NXT_POD1",
"LL_DN_NXT_POD2",
"LL_DN_NXT_POD3",
"LL_FINAL_DEST",
"LL_MLO_VESSEL",
"LL_MLO_VOYAGE",
"LL_FK_HANDLING_INSTRUCTION_1",
"LL_FK_HANDLING_INSTRUCTION_2",
"LL_FK_HANDLING_INSTRUCTION_3",
"LL_CONTAINER_LOADING_REM_1",
"LL_CONTAINER_LOADING_REM_2",
"LL_FK_SPECIAL_CARGO",
"LL_TIGHT_CONNECTION_FLAG1",
"LL_FK_IMDG",
"LL_FK_UNNO",
"LL_FK_UN_VAR",
"LL_FK_PORT_CLASS",
"LL_FLASH_UNIT",
"LL_FLASH_POINT",
"LL_OVERHEIGHT_CM",
"LL_OVERLENGTH_FRONT_CM",
"LL_OVERLENGTH_REAR_CM",
"LL_OVERWIDTH_RIGHT_CM",
"LL_OVERWIDTH_LEFT_CM",
"LL_REEFER_TMP",
"LL_REEFER_TMP_UNIT",
"LL_BOOKING_NO",
"LL_FK_BKG_EQUIPM_DTL",
"LL_CONTAINER_GROSS_WEIGHT")
REFRESH COMPLETE ON DEMAND 
USING DEFAULT LOCAL ROLLBACK SEGMENT
DISABLE QUERY REWRITE
--CREATE OR REPLACE VIEW V_TOS_LL_CONTAINER_SL
AS
SELECT  /*+ PARALLEL(IT,DEFAULT) PARALLEL(TOL,DEFAULT) */ --##03
      TOL.POL_SERVICE		LL_SERVICE
     , TOL.POL_VESSEL		LL_VESSEL
     , TOL.POL_VOYAGE		LL_VOYAGE
     , TOL.POL_DIR		LL_DIRECTION
     , TOL.POL_PCSQ		LL_PORT_SEQ
     , TOL.POL_TERMINAL		LL_POL_TERMINAL         
     , TOL.POL			LL_POL
     ,TO_CHAR(TO_DATE(IT.VVARDT,'YYYY/MM/DD'),'DD/MM/YYYY') LL_ETA
     ,TO_CHAR(TO_DATE(IT.VVDPDT,'YYYY/MM/DD'),'DD/MM/YYYY') LL_ETD
     , TOL.STOW_POSITION	LL_STOWAGE_POSITION
     , TOL.LIST_STATUS		LL_LOAD_LIST_STATUS
     , TOL.BOOKING_NO		LL_FK_BOOKING_NO
     , TOL.CONTAINER_NO         LL_DN_EQUIPMENT_NO
     , TOL.EQSIZE               LL_DN_EQ_SIZE
     , TOL.EQTYPE               LL_DN_EQ_TYPE
     , TOL.FULL_MT              LL_DN_FULL_MT
     , TOL.SOC_COC              LL_DN_SOC_COC
     , TOL.SHIP_TERM            LL_DN_SHIPMENT_TERM
     , TOL.SHIP_TYPE            LL_DN_SHIPMENT_TYP
     , TOL.LOCAL_TS             LL_LOCAL_STATUS
     , TOL.KILLED_SLOT          LL_VOID_SLOT
     , TOL.SLOT_OPERATOR        LL_FK_SLOT_OPERATOR
     , TOL.CONTAINER_OPERATOR   LL_FK_CONTAINER_OPERATOR
     , TOL.POD                  LL_DN_DISCHARGE_PORT
     , TOL.POD_TERMINAL         LL_DN_DISCHARGE_TERMINAL
     , TOL.NEXT_POD1            LL_DN_NXT_POD1
     , TOL.NEXT_POD2            LL_DN_NXT_POD2
     , TOL.NEXT_POD3            LL_DN_NXT_POD3
     , TOL.FINAL_DESTINATION    LL_FINAL_DEST
     , TOL.CONNECTING_VESSEL    LL_MLO_VESSEL
     , TOL.CONNECTING_VOYAGE_NO LL_MLO_VOYAGE
     , TOL.HAN1                 LL_FK_HANDLING_INSTRUCTION_1
     , TOL.HAN2                 LL_FK_HANDLING_INSTRUCTION_2
     , TOL.HAN3                 LL_FK_HANDLING_INSTRUCTION_3
     , TOL.CLR1                 LL_CONTAINER_LOADING_REM_1
     , TOL.CLR2                 LL_CONTAINER_LOADING_REM_2
     , TOL.SPECIAL_CARGO        LL_FK_SPECIAL_CARGO
     , TOL.TIGHT_CONN_FLAG      LL_TIGHT_CONNECTION_FLAG1
     , TOL.IMDG                 LL_FK_IMDG
     , TOL.UNNO                 LL_FK_UNNO
     , TOL.VARIANT              LL_FK_UN_VAR
     , TOL.PORT_CLASS           LL_FK_PORT_CLASS
     , TOL.FLASH_PT_UNIT        LL_FLASH_UNIT
     , TOL.FLASH_PT             LL_FLASH_POINT
     , TOL.OOG_OH               LL_OVERHEIGHT_CM
     , TOL.OOG_OLF              LL_OVERLENGTH_FRONT_CM 
     , TOL.OOG_OLB              LL_OVERLENGTH_REAR_CM
     , TOL.OOG_OWR              LL_OVERWIDTH_RIGHT_CM
     , TOL.OOG_OWL              LL_OVERWIDTH_LEFT_CM
     , TOL.RFTEMP               LL_REEFER_TMP      
     , TOL.UNIT			LL_REEFER_TMP_UNIT 
     , TOL.BOOKING_NO           LL_BOOKING_NO
     , TOL.BISEQN               LL_FK_BKG_EQUIPM_DTL
     , TOL.WEIGHT		LL_CONTAINER_GROSS_WEIGHT --##05
FROM MV_ITP063 IT
    ,TOS_ONBOARD_LIST TOL
WHERE VVVERS = 99
  AND VVARDT >= NVL( (SELECT CONFIG_VALUE FROM VCM_CONFIG_MST WHERE CONFIG_TYP = 'TABLE_FILTER' AND CONFIG_CD = 'VVARDT'), 0)
  AND IT.VVPCAL = TOL.POL
  AND IT.VVSRVC = TOL.POL_SERVICE
  AND IT.VVVESS = TOL.POL_VESSEL  
  AND IT.VVVOYN = TOL.POL_VOYAGE 
  --AND IT.VVPDIR = TOL.POL_DIR   --##01,##04
  AND IT.VVPCSQ = TOL.POL_PCSQ
  AND IT.VVTRM1 = TOL.POL_TERMINAL;