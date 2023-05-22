/* -----------------------------------------------------------------------------
System  : EZLL
Module  : Cutover View
Name    : V_TOS_LOADLIST_SL_VIEW.sql
Purpose : EZLL Onboar List is union with Sealiner's On board list
--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author		Date		    What
---------------	---------------	------------------------------------------------
Sukit	        19/03/2012	<Initial version>

--Change Log--------------------------------------------------------------------
##   DD/MM/YY     User-Task/CR No   -Short Description-
01   18/06/12	  Sukit		    Add column TDL.FIRST_COMPLETE_DATE,TDL.FIRST_COMPLETE_USER
02   18/05/2016   NATTAK1       PD_CR_20160317-EZLL[Restrict_EZLL_EZDL_Without_EMS_Activity ]  
--------------------------------------------------------------------------------
**/
--DROP INDEX MV_IDX_TOL;

--DROP MATERIALIZED VIEW V_TOS_LOADLIST_SL;

CREATE OR REPLACE VIEW V_TOS_LOADLIST_SL
AS 
SELECT
    (SELECT DECODE(TBL.RECORD_CHANGE_USER, 'EZLL', 'R', FSC.CRFLV1) FROM  SC_PRSN_LOG_INFO SPLI, ITP188 FSC WHERE SPLI.FSC_CODE = FSC.CRCNTR  AND TBL.RECORD_CHANGE_USER = SPLI.PRSN_LOG_ID)  as LINE
  , (SELECT DECODE(TBL.RECORD_CHANGE_USER, 'EZLL', '*', FSC.CRFLV2) FROM SC_PRSN_LOG_INFO SPLI, ITP188 FSC WHERE SPLI.FSC_CODE = FSC.CRCNTR  AND TBL.RECORD_CHANGE_USER = SPLI.PRSN_LOG_ID)   as TRAD
  , (SELECT DECODE(TBL.RECORD_CHANGE_USER, 'EZLL', '***', FSC.CRFLV3) FROM SC_PRSN_LOG_INFO SPLI, ITP188 FSC WHERE SPLI.FSC_CODE = FSC.CRCNTR  AND TBL.RECORD_CHANGE_USER = SPLI.PRSN_LOG_ID) as AGNT
  , TLL.FK_SERVICE                                as     POL_SERVICE
  , TLL.FK_VESSEL                                 as     POL_VESSEL
  , TLL.FK_VOYAGE                                 as     POL_VOYAGE
  , TLL.FK_DIRECTION                              as     POL_DIR
  , TLL.DN_PORT                                   as     POL
  , TLL.FK_PORT_SEQUENCE_NO                       as     POL_PCSQ
  , TBL.CONTAINER_SEQ_NO                          as     SEQ_NO
  , CASE WHEN TLL.LOAD_LIST_STATUS = 10   
  --##02 
         THEN 'P' -- Pre Loading
		 WHEN TLL.LOAD_LIST_STATUS = 30  THEN 'C'   -- Loading Completed.		 
         ELSE 'O'  -- Open
  -- End 02		 
    END                                           as     LIST_STATUS
  , ITP063.VVARDT                                 as     POL_DATE
  , ITP063.VVARTM                                 as     POL_TIME
  , TLL.DN_TERMINAL                               as     POL_TERMINAL
  , TBL.DN_DISCHARGE_PORT                         as     POD
  , BVRD.POD_PCSQ                                 as     POD_PCSQ
  , ITP063.VVARDT                                 as     POD_DATE
  , ITP063.VVARTM                                 as     POD_TIME
  , TBL.DN_DISCHARGE_TERMINAL                     as     POD_TERMINAL
  ,vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'SERVICE') AS SEC_SERVICE
  ,vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'VESSEL') AS SEC_VESSEL
  ,vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'VOYAGE') AS SEC_VOYAGE
  ,vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'PDIR') AS SEC_DIR
  ,vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'LOAD_PORT') AS POT_PORT
  ,to_number(vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'POL_PORT_SEQ')) AS POT_PCSQ
  ,to_number(vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'POL_ARRIVAL_DATE')) AS POT_DATE
  ,to_number(vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'POL_ARRIVAL_TIME')) AS POT_TIME
  ,vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'FROM_TERMINAL') AS POT_TERMINAL
  ,vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'DISCHARGE_PORT') AS POT_DIS_PORT
  ,to_number(vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'POD_PORT_SEQ')) AS POT_DIS_PCSQ
  ,vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL +1,'TO_TERMINAL') AS POT_DIS_TERMINAL
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
  , TBL.DN_SPECIAL_HNDL                          as     SPECIAL_CARGO       -- ##3
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
  , vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL -1,'SERVICE') AS PREV_SERVICE
  , vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL -1,'VESSEL') AS PREV_VESSEL
  , vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL -1,'VOYAGE') AS PREV_VOYAGE
  , vasapps.PCR_EZL_UTILITY.FR_GET_BOOKING_ROUTING_DATA(TBL.FK_BOOKING_NO,TBL.FK_BKG_VOYAGE_ROUTING_DTL -1,'PDIR') AS PREV_DIR
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
  ,(select BNCSCD from BKP030 where bncstp = 'O' and bnbkno = TBL.FK_BOOKING_NO) as cust_code
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
  , (SELECT HAN1.SHI_DESCRIPTION FROM SHP007 HAN1 WHERE TBL.FK_HANDLING_INSTRUCTION_1 = HAN1.SHI_CODE) as HAN1_DESC
  , (SELECT HAN2.SHI_DESCRIPTION FROM SHP007 HAN2 WHERE TBL.FK_HANDLING_INSTRUCTION_2 = HAN2.SHI_CODE) as HAN2_DESC
  , (SELECT HAN3.SHI_DESCRIPTION FROM SHP007 HAN3 WHERE TBL.FK_HANDLING_INSTRUCTION_3 = HAN3.SHI_CODE) as HAN3_DESC
  , (SELECT CLR1.CLR_DESC FROM SHP041 CLR1 WHERE TBL.CONTAINER_LOADING_REM_1 = CLR1.CLR_CODE) as CLR1_DESC
  , (SELECT CLR2.CLR_DESC FROM SHP041 CLR2 WHERE TBL.CONTAINER_LOADING_REM_2 = CLR2.CLR_CODE) as CLR2_DESC
  , cast( '' as varchar(1))                                            as     DG_APPROVAL_REF
  , cast( '' as varchar(1))                                            as     DG_STOWAGE_INS
  , (select vsopcd from itp060 where TLL.FK_VESSEL = ITP060.VSVESS) as     VESSEL_OPERATOR
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
  , TLL.RECORD_ADD_USER                           as     LL_RECORD_ADD_USER_HDR
  , TLL.RECORD_ADD_DATE                           as     LL_RECORD_ADD_DATE_HDR
  , TLL.RECORD_CHANGE_USER                        as     LL_RECORD_CHANGE_USER_HDR
  , TLL.RECORD_CHANGE_DATE                        as     LL_RECORD_CHANGE_DATE_HDR
  , TBL.RECORD_ADD_USER                           as     LL_RECORD_ADD_USER
  , TBL.RECORD_ADD_DATE                           as     LL_RECORD_ADD_DATE_DTL
--  , TO_NUMBER(TO_CHAR(TBL.RECORD_ADD_DATE,'YYYYMMDD')) AS LL_RECORD_ADD_DATE
  , TO_NUMBER(TO_CHAR(TBL.RECORD_ADD_DATE,'HH24MI'))   AS LL_RECORD_ADD_TIME
  , TBL.RECORD_CHANGE_USER                        as     LL_RECORD_CHANGE_USER
  , TO_NUMBER(TO_CHAR(TBL.RECORD_CHANGE_DATE,'YYYYMMDD')) AS LL_RECORD_CHANGE_DATE
  , TO_NUMBER(TO_CHAR(TBL.RECORD_CHANGE_DATE,'HH24MI')) AS LL_RECORD_CHANGE_TIME
--  , TBL.RECORD_CHANGE_DATE                        as     LL_RECORD_CHANGE_DATE_DTL
  , TLL.FIRST_COMPLETE_DATE
  , TLL.FIRST_COMPLETE_USER
FROM  vasapps.TOS_LL_LOAD_LIST            TLL
    , vasapps.TOS_LL_BOOKED_LOADING       TBL
	, MV_ITP063                   ITP063
    , BKP001                      BKP001
    , BOOKING_VOYAGE_ROUTING_DTL  BVRD
WHERE TLL.PK_LOAD_LIST_ID           = TBL.FK_LOAD_LIST_ID
AND   TLL.FK_SERVICE                = ITP063.VVSRVC
AND   TLL.FK_VESSEL                 = ITP063.VVVESS
AND   TLL.FK_VOYAGE                 = ITP063.VVVOYN
AND   TLL.FK_DIRECTION              = ITP063.VVPDIR
AND   TLL.FK_PORT_SEQUENCE_NO       = ITP063.VVPCSQ
AND   ITP063.VVVERS                 = '99'
AND   TBL.FK_BOOKING_NO             = BVRD.BOOKING_NO
AND   TBL.FK_BKG_VOYAGE_ROUTING_DTL = BVRD.VOYAGE_SEQNO
AND   TBL.FK_BOOKING_NO             = BKP001.BABKNO
AND TBL.LOADING_STATUS in ('LO','RB')
AND TBL.RECORD_STATUS = 'A'
AND ITP063.VVARDT >= NVL( (SELECT CONFIG_VALUE FROM vasapps.VCM_CONFIG_MST WHERE CONFIG_TYP = 'TABLE_FILTER' AND CONFIG_CD = 'VVARDT'), 0)
AND BVRD.ARRIVAL_DATE >= NVL( (SELECT CONFIG_VALUE FROM VASAPPS.VCM_CONFIG_MST WHERE CONFIG_TYP = 'TABLE_FILTER' AND CONFIG_CD = 'VVARDT'), 0)
/


grant select on V_TOS_LOADLIST_SL to rclapps;