  CREATE TABLE TOS_LL_BOOKED_LOADING_TMP 
   (
	SEQ_NO                                             VARCHAR2(5 ), 
	SESSION_ID                                         VARCHAR2(250 ), 
	PK_BOOKED_LOADING_ID                               VARCHAR2(100 ), 
	FK_LOAD_LIST_ID                                    VARCHAR2(100 ), 
	CONTAINER_SEQ_NO                                   VARCHAR2(4 ), 
	FK_BOOKING_NO                                      VARCHAR2(17 ), 
	FK_BKG_SIZE_TYPE_DTL                               VARCHAR2(12 ), 
	FK_BKG_SUPPLIER                                    VARCHAR2(12 ), 
	FK_BKG_EQUIPM_DTL                                  VARCHAR2(12 ), 
	DN_EQUIPMENT_NO                                    VARCHAR2(12 ), 
	EQUPMENT_NO_SOURCE                                 VARCHAR2(1 ), 
	FK_BKG_VOYAGE_ROUTING_DTL                          VARCHAR2(2 ), 
	DN_EQ_SIZE                                         VARCHAR2(2 ), 
	DN_EQ_TYPE                                         VARCHAR2(2 ), 
	DN_FULL_MT                                         VARCHAR2(1 ), 
	DN_BKG_TYP                                         VARCHAR2(2 ), 
	DN_SOC_COC                                         VARCHAR2(1 ), 
	DN_SHIPMENT_TERM                                   VARCHAR2(4 ), 
	DN_SHIPMENT_TYP                                    VARCHAR2(3 ), 
	LOCAL_STATUS                                       VARCHAR2(1 ), 
	LOCAL_TERMINAL_STATUS                              VARCHAR2(10 ), 
	MIDSTREAM_HANDLING_CODE                            VARCHAR2(2 ), 
	LOAD_CONDITION                                     VARCHAR2(1 ), 
	LOADING_STATUS                                     VARCHAR2(2 ), 
	STOWAGE_POSITION                                   VARCHAR2(7 ), 
	ACTIVITY_DATE_TIME                                 VARCHAR2(16 ), 
	CONTAINER_GROSS_WEIGHT                             VARCHAR2(8 ), 
	DAMAGED                                            VARCHAR2(1 ), 
	VOID_SLOT                                          VARCHAR2(6 ), 
	PREADVICE_FLAG                                     VARCHAR2(1 ), 
	FK_SLOT_OPERATOR                                   VARCHAR2(4 ), 
	FK_CONTAINER_OPERATOR                              VARCHAR2(4 ), 
	OUT_SLOT_OPERATOR                                  VARCHAR2(4 ), 
	DN_SPECIAL_HNDL                                    VARCHAR2(3 ), 
	SEAL_NO                                            VARCHAR2(20 ), 
	DN_DISCHARGE_PORT                                  VARCHAR2(5 ), 
	DN_DISCHARGE_TERMINAL                              VARCHAR2(5 ), 
	DN_NXT_POD1                                        VARCHAR2(5 ), 
	DN_NXT_POD2                                        VARCHAR2(5 ), 
	DN_NXT_POD3                                        VARCHAR2(5 ), 
	DN_FINAL_POD                                       VARCHAR2(5 ), 
	FINAL_DEST                                         VARCHAR2(5 ), 
	DN_NXT_SRV                                         VARCHAR2(5 ), 
	DN_NXT_VESSEL                                      VARCHAR2(25 ), 
	DN_NXT_VOYAGE                                      VARCHAR2(10 ), 
	DN_NXT_DIR                                         VARCHAR2(2 ), 
	MLO_VESSEL                                         VARCHAR2(35 ), 
	MLO_VOYAGE                                         VARCHAR2(10 ), 
	MLO_VESSEL_ETA                                     VARCHAR2(16 ), 
	MLO_POD1                                           VARCHAR2(5 ), 
	MLO_POD2                                           VARCHAR2(5 ), 
	MLO_POD3                                           VARCHAR2(5 ), 
	MLO_DEL                                            VARCHAR2(5 ), 
	EX_MLO_VESSEL                                      VARCHAR2(5 ), 
	EX_MLO_VESSEL_ETA                                  VARCHAR2(16 ), 
	EX_MLO_VOYAGE                                      VARCHAR2(20 ), 
	FK_HANDLING_INSTRUCTION_1                          VARCHAR2(3 ), 
	FK_HANDLING_INSTRUCTION_2                          VARCHAR2(3 ), 
	FK_HANDLING_INSTRUCTION_3                          VARCHAR2(3 ), 
	CONTAINER_LOADING_REM_1                            VARCHAR2(3 ), 
	CONTAINER_LOADING_REM_2                            VARCHAR2(3 ), 
	FK_SPECIAL_CARGO                                   VARCHAR2(3 ), 
	TIGHT_CONNECTION_FLAG1                             VARCHAR2(1 ), 
	TIGHT_CONNECTION_FLAG2                             VARCHAR2(1 ), 
	TIGHT_CONNECTION_FLAG3                             VARCHAR2(1 ), 
	FK_IMDG                                            VARCHAR2(4 ), 
	FK_UNNO                                            VARCHAR2(6 ), 
	FK_UN_VAR                                          VARCHAR2(1 ), 
	FK_PORT_CLASS                                      VARCHAR2(5 ), 
	FK_PORT_CLASS_TYP                                  VARCHAR2(5 ), 
	FLASH_UNIT                                         VARCHAR2(1 ), 
	FLASH_POINT                                        VARCHAR2(7 ), 
	FUMIGATION_ONLY                                    VARCHAR2(1 ), 
	RESIDUE_ONLY_FLAG                                  VARCHAR2(1 ), 
	OVERHEIGHT_CM                                      VARCHAR2(15 ), 
	OVERWIDTH_LEFT_CM                                  VARCHAR2(15 ), 
	OVERWIDTH_RIGHT_CM                                 VARCHAR2(15 ), 
	OVERLENGTH_FRONT_CM                                VARCHAR2(15 ), 
	OVERLENGTH_REAR_CM                                 VARCHAR2(15 ), 
	REEFER_TMP                                         VARCHAR2(8 ), 
	REEFER_TMP_UNIT                                    VARCHAR2(1 ), 
	DN_HUMIDITY                                        VARCHAR2(7 ), 
	DN_VENTILATION                                     VARCHAR2(6 ), 
	PUBLIC_REMARK                                      VARCHAR2(2000 ), 
	OPN_STATUS                                         VARCHAR2(3 ), 
	RECORD_CHANGE_USER                                 VARCHAR2(10 ), 
	RECORD_CHANGE_DATE 								   TIMESTAMP (6),
	CRANE_TYPE                                         VARCHAR2(3)

   )  ;
 

   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.SESSION_ID IS 'Session Id';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.PK_BOOKED_LOADING_ID IS 'Load List Detail PK';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_LOAD_LIST_ID IS 'Load List FK';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.CONTAINER_SEQ_NO IS 'Seq. no';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_BOOKING_NO IS 'Booking#';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_BKG_SIZE_TYPE_DTL IS 'Size Type Seq. No.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_BKG_SUPPLIER IS 'Supplier Seq No.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_BKG_EQUIPM_DTL IS 'Cont Seq.#';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_EQUIPMENT_NO IS 'Equipment#';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.EQUPMENT_NO_SOURCE IS 'Equipment# Source';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_BKG_VOYAGE_ROUTING_DTL IS 'Routing Seq. No.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_EQ_SIZE IS 'Size';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_EQ_TYPE IS 'Type';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_FULL_MT IS 'Full/MT';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_BKG_TYP IS 'Booking Type';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_SOC_COC IS 'SOC/COC';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_SHIPMENT_TERM IS 'Shipment Trm';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_SHIPMENT_TYP IS 'Shipment Type';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.LOCAL_STATUS IS 'POL Status';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.LOCAL_TERMINAL_STATUS IS 'Local Container Status';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.MIDSTREAM_HANDLING_CODE IS 'Midstream Handling';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.LOAD_CONDITION IS 'Load Condition';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.LOADING_STATUS IS 'Loading Status';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.STOWAGE_POSITION IS 'Stowage Position';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.ACTIVITY_DATE_TIME IS 'Activity Date/Time';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.CONTAINER_GROSS_WEIGHT IS 'Cont Gross Weight';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DAMAGED IS 'Damaged';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.VOID_SLOT IS 'Void Slot';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.PREADVICE_FLAG IS 'Preadvice Flag';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_SLOT_OPERATOR IS 'Slot Oper.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_CONTAINER_OPERATOR IS 'Cont.Oper.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.OUT_SLOT_OPERATOR IS 'Out Slot Operator';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_SPECIAL_HNDL IS 'Special Hndl';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.SEAL_NO IS 'Seal No';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_DISCHARGE_PORT IS 'Disharge Port';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_DISCHARGE_TERMINAL IS 'Discharge Terminal';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_NXT_POD1 IS 'Next POD-1';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_NXT_POD2 IS 'Next POD-2';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_NXT_POD3 IS 'Next POD-3';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_FINAL_POD IS 'Final POD';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FINAL_DEST IS 'Final Dest';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_NXT_SRV IS 'Nxt Srv.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_NXT_VESSEL IS 'Nxt Ves.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_NXT_VOYAGE IS 'Nxt Voy.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_NXT_DIR IS 'Nxt Dir';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.MLO_VESSEL IS 'MLO vessel';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.MLO_VOYAGE IS 'MLO voyage';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.MLO_VESSEL_ETA IS 'MLO ETA Date';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.MLO_POD1 IS 'MLO POD1';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.MLO_POD2 IS 'MLO POD2';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.MLO_POD3 IS 'MLO POD3';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.MLO_DEL IS 'Connecting MLO_DEL(Place of Delivery)';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.EX_MLO_VESSEL IS 'Ex MLO vessel';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.EX_MLO_VESSEL_ETA IS 'Ex MLO Eta Date';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.EX_MLO_VOYAGE IS 'Ex MLO Voyage';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_HANDLING_INSTRUCTION_1 IS 'Handling 1 Code';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_HANDLING_INSTRUCTION_2 IS 'Handling 2 Code';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_HANDLING_INSTRUCTION_3 IS 'Handling 3 Code';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.CONTAINER_LOADING_REM_1 IS 'Container Loading Remark 1';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.CONTAINER_LOADING_REM_2 IS 'Container Loading Remark 2';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_SPECIAL_CARGO IS 'Special Cargo';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.TIGHT_CONNECTION_FLAG1 IS 'TC POD1';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.TIGHT_CONNECTION_FLAG2 IS 'TC POD2';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.TIGHT_CONNECTION_FLAG3 IS 'TC POD3';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_IMDG IS 'IMDG Class';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_UNNO IS 'UNNO';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_UN_VAR IS 'UN Var';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_PORT_CLASS IS 'Port Class';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FK_PORT_CLASS_TYP IS 'Port Class Type.';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FLASH_UNIT IS 'Flash Unit';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FLASH_POINT IS 'Flashp';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.FUMIGATION_ONLY IS 'Fumigation Only';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.RESIDUE_ONLY_FLAG IS 'Residue Only Flag';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.OVERHEIGHT_CM IS 'Overheigt';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.OVERWIDTH_LEFT_CM IS 'OWL';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.OVERWIDTH_RIGHT_CM IS 'OWR';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.OVERLENGTH_FRONT_CM IS 'Overlength Front';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.OVERLENGTH_REAR_CM IS 'Overlength Aft';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.REEFER_TMP IS 'Reefer Tmp';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.REEFER_TMP_UNIT IS 'Reefer Tmp Unit';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_HUMIDITY IS 'Humidity';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.DN_VENTILATION IS 'Ventilation';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.PUBLIC_REMARK IS 'Remark';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.OPN_STATUS IS 'Open Status';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.RECORD_CHANGE_USER IS 'Update By';
 
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.RECORD_CHANGE_DATE IS 'Update Date Time';
   COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.CRANE_TYPE IS 'Crane Type';
 
   COMMENT ON TABLE TOS_LL_BOOKED_LOADING_TMP  IS 'Load List- Booked Temp - Load List- Booked Temp';
 
