/* -----------------------------------------------------------------------------
System  : EZLL
Module  : Cutover View
Name    : V_TOS_DISCHLIST_SL_VIEW.sql
Purpose : EZLL discharge List is union with Sealiner's discharge list
--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author		Date		    What
---------------	---------------	------------------------------------------------
Sukit	        19/03/2012	<Initial version>

--Change Log--------------------------------------------------------------------
##   DD/MM/YY     User-Task/CR No   -Short Description-
01   18/06/12	  Sukit		    Add column TDL.FIRST_COMPLETE_DATE,TDL.FIRST_COMPLETE_USER
--02   18/05/16	  NATTAK1       PD_CR_20160317-EZLL[Restrict_EZLL_EZDL_Without_EMS_Activity ]
--------------------------------------------------------------------------------
**/

--DROP MATERIALIZED VIEW V_TOS_DISCHLIST_SL;

CREATE OR REPLACE VIEW V_TOS_DISCHLIST_SL
AS 
SELECT
    (SELECT DECODE(TBD.RECORD_CHANGE_USER, 'EZLL', 'R', FSC.CRFLV1) FROM  SC_PRSN_LOG_INFO SPLI, ITP188 FSC WHERE SPLI.FSC_CODE = FSC.CRCNTR  AND TBD.RECORD_CHANGE_USER = SPLI.PRSN_LOG_ID)  as LINE
  , (SELECT DECODE(TBD.RECORD_CHANGE_USER, 'EZLL', '*', FSC.CRFLV2) FROM SC_PRSN_LOG_INFO SPLI, ITP188 FSC WHERE SPLI.FSC_CODE = FSC.CRCNTR  AND TBD.RECORD_CHANGE_USER = SPLI.PRSN_LOG_ID)   as TRAD
  , (SELECT DECODE(TBD.RECORD_CHANGE_USER, 'EZLL', '***', FSC.CRFLV3) FROM SC_PRSN_LOG_INFO SPLI, ITP188 FSC WHERE SPLI.FSC_CODE = FSC.CRCNTR  AND TBD.RECORD_CHANGE_USER = SPLI.PRSN_LOG_ID) as AGNT
  , TDL.FK_SERVICE                                                   AS POD_SERVICE ,
    TDL.FK_VESSEL                                                    AS POD_VESSEL ,
    TDL.FK_VOYAGE                                                    AS POD_VOYAGE ,
    TDL.FK_DIRECTION                                                 AS POD_DIR ,
    TDL.DN_PORT                                                      AS POD ,
    TDL.FK_PORT_SEQUENCE_NO                                          AS POD_PCSQ ,
    TBD.CONTAINER_SEQ_NO                                             AS SEQ_NO ,
    ITP063.VVARDT                                                    AS POD_DATE ,
    ITP063.VVARTM                                                    AS POD_TIME ,
    TDL.DN_TERMINAL                                                  AS POD_TERMINAL ,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL -1,'SERVICE') AS PREV_SERVICE,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL -1,'VESSEL') AS PREV_VESSEL,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL -1,'VOYAGE') AS PREV_VOYAGE,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL -1,'PDIR') AS PREV_DIR,
	--vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL -1,'LOAD_PORT') AS PREV_PORT,	-- ##21 add comment
    BVRD.LOAD_PORT						     AS PREV_POL,   -- ##21
    BVRD.POL_PCSQ                                                    AS POL_PCSQ ,
    BVRD.POL_ARRIVAL_DATE                                            AS POL_DATE ,
    BVRD.POL_ARRIVAL_TIME                                            AS POL_TIME ,
    TBD.DN_POL_TERMINAL                                              AS POL_TERMINAL ,
    cast( '' as varchar(1))                                          AS COD ,
    cast( '' as varchar(1))                                          AS COD_PCSQ ,
    cast( '' as varchar(1))                                          AS COD_DATE ,
    cast( '' as varchar(1))                                          AS COD_TIME ,
    cast( '' as varchar(1))                                          AS COD_TERMINAL ,
    vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'SERVICE') AS SEC_SERVICE,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'VESSEL') AS SEC_VESSEL,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'VOYAGE') AS SEC_VOYAGE,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'PDIR') AS SEC_DIR,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'LOAD_PORT') AS SEC_PORT,
	to_number(vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'POL_PORT_SEQ')) AS SEC_PCSQ,
	to_number(vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'POL_ARRIVAL_DATE')) AS SEC_DATE,
	to_number(vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'POL_ARRIVAL_TIME')) AS SEC_TIME,
	vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBD.FK_BOOKING_NO,TBD.FK_BKG_VOYAGE_ROUTING_DTL +1,'FROM_TERMINAL') AS SEC_TERMINAL,
	TBD.FK_BOOKING_NO                                                AS BOOKING_NO ,
    TBD.DN_EQUIPMENT_NO                                              AS CONTAINER_NO ,
    TBD.DN_EQ_SIZE                                                   AS EQSIZE ,
    TBD.DN_EQ_TYPE                                                   AS EQTYPE ,
    TBD.DN_FULL_MT                                                   AS FULL_MT ,
    TBD.CONTAINER_GROSS_WEIGHT                                       AS WEIGHT ,
    TBD.DN_SPECIAL_HNDL                                              AS SPECIAL_CARGO ,
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
    DECODE( TBD.DISCHARGE_STATUS , 'RB' , 'Y' , cast( '' as varchar(1)))                 AS ROB ,
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
  /*  CASE
      WHEN TDL.DISCHARGE_LIST_STATUS >=  10   
      THEN 'C'
      ELSE 'O'
    END           AS LIST_STATUS ,
*/	
	 CASE WHEN TDL.DISCHARGE_LIST_STATUS = 10    --##02 
         THEN 'P' -- Pre Discharging
		 WHEN TDL.DISCHARGE_LIST_STATUS = 30  THEN 'C'   -- Discharge Completed.		 
         ELSE 'O'  -- Open
  -- End 02		 
    END   AS LIST_STATUS ,                         
	BKP001.BASTAT AS BK_STATUS ,
    CASE
      WHEN TBD.DISCHARGE_STATUS = 'BK'
      THEN 'O'
      WHEN TBD.DISCHARGE_STATUS = 'DI' --##05
      THEN 'D'
      WHEN TBD.DISCHARGE_STATUS = 'SL'
      THEN 'H' --##05
      WHEN TBD.DISCHARGE_STATUS = 'RB'
      THEN 'O'
    END                                                 AS DISCHARGE_STATUS ,
    DECODE( BVRD.TRUNK_WAYPORT_FLAG , 'W' , 'Y' , 'N' ) AS WAYPORT_IND ,
    TBD.FK_UNNO                                         AS UNNO ,
    --ITP060.VSOPCD                                       AS VESSEL_OPERATOR ,
	(select vsopcd from itp060 where TDL.FK_VESSEL = ITP060.VSVESS) as     VESSEL_OPERATOR,
    TO_DATE(VVARDT
    ||LPAD(NVL(VVARTM,0),4,0) , 'YYYYMMDDHH24MI')                      AS POD_ETD ,
    TBD.FK_SLOT_OPERATOR                                               AS SLOT_OPERATOR ,
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
    NVL(TBD.OUT_SLOT_OPERATOR, cast( '' as varchar(1)))                AS OUT_SLOT_OPERATOR ,
    TBD.LOCAL_TERMINAL_STATUS                                          AS LOCAL_CONTAINER_STATUS ,
    BVRD.ACT_VESSEL_CODE                                               AS ACT_VESSEL_CODE ,
	/*  -- ##17 start add comments ********/
    BVRD.ACT_VOYAGE_NUMBER                                             AS ACT_VOYAGE_NUMBER ,
    BVRD.ACT_SERVICE_DIRECTION                                         AS ACT_SERVICE_DIRECTION ,
    BVRD.ACT_PORT_DIRECTION                                            AS ACT_PORT_DIRECTION ,
    BVRD.ACT_PORT_SEQUENCE                                             AS ACT_PORT_SEQUENCE ,
	/******* -- ##17 end add comments*/
	DECODE( BVRD.DISCHARGE_PORT , BKP001.BAPOD , BVRD.ACT_VOYAGE_NUMBER , cast( '' as varchar(1))) AS FROM_VOYAGE_NUMBER ,
    BVRD.ACT_PORT_DIRECTION                                            AS FROM_DIRECTION ,
    DECODE( BVRD.DISCHARGE_PORT , BKP001.BAPOD , BVRD.ACT_PORT_SEQUENCE , cast( '' as varchar(1))) AS FROM_PORT_SEQUENCE ,
    TBD.CONTAINER_LOADING_REM_1                                        AS CLR1 ,
    (SELECT CLR1.CLR_DESC FROM SHP041 CLR1 WHERE TBD.CONTAINER_LOADING_REM_1 = CLR1.CLR_CODE) as CLR1_DESC ,
    TBD.CONTAINER_LOADING_REM_2                                        AS CLR2 ,
    (SELECT CLR2.CLR_DESC FROM SHP041 CLR2 WHERE TBD.CONTAINER_LOADING_REM_2 = CLR2.CLR_CODE) as CLR2_DESC ,
    TBD.FK_HANDLING_INSTRUCTION_1                                      AS HAN1 ,
	(SELECT HAN1.SHI_DESCRIPTION FROM SHP007 HAN1 WHERE TBD.FK_HANDLING_INSTRUCTION_1 = HAN1.SHI_CODE) as HAN1_DESC,
    TBD.FK_HANDLING_INSTRUCTION_2                                      AS HAN2 ,
    (SELECT HAN2.SHI_DESCRIPTION FROM SHP007 HAN2 WHERE TBD.FK_HANDLING_INSTRUCTION_2 = HAN2.SHI_CODE) as HAN2_DESC ,
    TBD.FK_HANDLING_INSTRUCTION_3                                      AS HAN3 ,
    (SELECT HAN3.SHI_DESCRIPTION FROM SHP007 HAN3 WHERE TBD.FK_HANDLING_INSTRUCTION_3 = HAN3.SHI_CODE) as HAN3_DESC ,
    cast( '' as varchar(1))                                            AS DISCHARGE_UPDATED ,
    TBD.FK_UN_VAR                                                      AS VARIANT ,
    --BVRD.ACT_SERVICE_CODE                                              AS ACT_SERVICE_CODE ,	   --  ## 17 add comment
	/******* -- ##17 start **********/
	decode((select vvforl from itp063 where vvvers = 99
	and vvforl is not null
	and ommission_flag is null
	and vvsrvc = act_service_code
	and vvvess = act_vessel_code
	and vvvoyn = act_voyage_number
	and vvpcsq = act_port_sequence
	and vvpcal = discharge_port
	and vvtrm1 = to_terminal)
	,'L',(select vvsrvc from itp063 where vvvers = 99
	and vvforl is not null
	and ommission_flag is null
	and vvsrvc = act_service_code
	and vvvess = act_vessel_code
	and invoyageno = act_voyage_number
	and invoyageno <> vvvoyn
	and vvpcal = discharge_port
	and vvtrm1 = to_terminal)
	,BVRD.ACT_SERVICE_CODE)				       	  				   	   AS ACT_SERVICE_CODE ,
	/****** -- ##17  end ********/
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
    TDL.RECORD_ADD_USER                                                AS DL_RECORD_ADD_USER_HDR ,
    TDL.RECORD_ADD_DATE                                                AS DL_RECORD_ADD_DATE_HDR ,
    TDL.RECORD_CHANGE_USER                                             AS DL_RECORD_CHANGE_USER_HDR ,
    TDL.RECORD_CHANGE_DATE                                             AS DL_RECORD_CHANGE_DATE_HDR ,
    TBD.RECORD_ADD_USER                                                AS DL_RECORD_ADD_USER ,
    --TBD.RECORD_ADD_DATE                                                AS DL_RECORD_ADD_DATE_DTL ,
	to_number(to_char(TBD.RECORD_ADD_DATE,'YYYYMMDD')) 			   	   as DL_RECORD_ADD_DATE,
    to_number(to_char(TBD.RECORD_ADD_DATE,'HH24MI')) 			   	   as DL_RECORD_ADD_TIME,
    TBD.RECORD_CHANGE_USER                                             AS DL_RECORD_CHANGE_USER ,
    --TBD.RECORD_CHANGE_DATE                                             AS DL_RECORD_CHANGE_DATE_DTL ,
	to_number(to_char(TBD.RECORD_CHANGE_DATE,'YYYYMMDD')) 		   	   as DL_RECORD_CHANGE_DATE ,
    to_number(to_char(TBD.RECORD_CHANGE_DATE,'HH24MI')) 			   as DL_RECORD_CHANGE_TIME ,
    TBD.DISCHARGE_STATUS                                               AS DISCH_STATUS,
	TDL.FIRST_COMPLETE_DATE,
    TDL.FIRST_COMPLETE_USER
  FROM VASAPPS.TOS_DL_DISCHARGE_LIST TDL ,
    VASAPPS.TOS_DL_BOOKED_DISCHARGE TBD ,
    MV_ITP063 ITP063 ,
    BKP001 BKP001 ,
    BOOKING_VOYAGE_ROUTING_DTL BVRD
  WHERE TDL.PK_DISCHARGE_LIST_ID    = TBD.FK_DISCHARGE_LIST_ID
  AND TDL.FK_SERVICE                = ITP063.VVSRVC
  AND TDL.FK_VESSEL                 = ITP063.VVVESS
  AND TDL.FK_VOYAGE                 = DECODE(ITP063.VVSRVC,'AFS',ITP063.VVVOYN,'DFS',ITP063.VVVOYN,ITP063.INVOYAGENO) --##13
  AND TDL.FK_PORT_SEQUENCE_NO       = ITP063.VVPCSQ
  AND TDL.DN_PORT		    = ITP063.VVPCAL
  AND TDL.DN_TERMINAL 		    = ITP063.VVTRM1
  AND ITP063.VVVERS                 = '99'
  AND TBD.FK_BOOKING_NO             = BKP001.BABKNO
  AND TBD.FK_BOOKING_NO             = BVRD.BOOKING_NO
  AND TBD.FK_BKG_VOYAGE_ROUTING_DTL = BVRD.VOYAGE_SEQNO
  AND TBD.DISCHARGE_STATUS          in ('DI','RB')
  AND TBD.RECORD_STATUS	= 'A'
  AND (ITP063.VVFORL IS NOT NULL	OR ITP063.VVSRVC = 'DFS')
  AND ITP063.OMMISSION_FLAG IS NULL
  AND ITP063.VVARDT >= NVL( (SELECT CONFIG_VALUE FROM vasapps.VCM_CONFIG_MST WHERE CONFIG_TYP = 'TABLE_FILTER' AND CONFIG_CD = 'VVARDT'), 0)
  AND BVRD.ARRIVAL_DATE >= NVL( (SELECT CONFIG_VALUE FROM VASAPPS.VCM_CONFIG_MST WHERE CONFIG_TYP = 'TABLE_FILTER' AND CONFIG_CD = 'VVARDT'), 0)
/

grant select on V_TOS_DISCHLIST_SL to rclapps;