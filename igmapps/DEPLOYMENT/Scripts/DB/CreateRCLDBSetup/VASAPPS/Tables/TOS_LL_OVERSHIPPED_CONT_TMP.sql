  CREATE TABLE TOS_LL_OVERSHIPPED_CONT_TMP 
   (
    SEQ_NO                                                       VARCHAR2(5 ), 
	SESSION_ID                                                   VARCHAR2(250 ), 
	PK_OVERSHIPPED_CONTAINER_ID                                  VARCHAR2(100 ), 
	FK_LOAD_LIST_ID                                              VARCHAR2(100 ), 
	BOOKING_NO                                                   VARCHAR2(17 ), 
	BOOKING_NO_SOURCE                                            VARCHAR2(1 ), 
	EQUIPMENT_NO                                                 VARCHAR2(12 ), 
	EQUIPMENT_NO_QUESTIONABLE_FLAG                               VARCHAR2(1 ), 
	EQ_SIZE                                                      VARCHAR2(2 ), 
	EQ_TYPE                                                      VARCHAR2(2 ), 
	FULL_MT                                                      VARCHAR2(1 ), 
	BKG_TYP                                                      VARCHAR2(2 ), 
	FLAG_SOC_COC                                                 VARCHAR2(1 ), 
	SHIPMENT_TERM                                                VARCHAR2(4 ), 
	SHIPMENT_TYPE                                                VARCHAR2(3 ), 
	LOCAL_STATUS                                                 VARCHAR2(1 ), 
	LOCAL_TERMINAL_STATUS                                        VARCHAR2(10 ), 
	MIDSTREAM_HANDLING_CODE                                      VARCHAR2(2 ), 
	LOAD_CONDITION                                               VARCHAR2(1 ), 
	LOADING_STATUS                                               VARCHAR2(2 ), 
	STOWAGE_POSITION                                             VARCHAR2(7 ), 
	ACTIVITY_DATE_TIME                                           VARCHAR2(16 ), 
	CONTAINER_GROSS_WEIGHT                                       VARCHAR2(8 ), 
	DAMAGED                                                      VARCHAR2(1 ), 
	VOID_SLOT                                                    VARCHAR2(6 ), 
	PREADVICE_FLAG                                               VARCHAR2(1 ), 
	SLOT_OPERATOR                                                VARCHAR2(4 ), 
	CONTAINER_OPERATOR                                           VARCHAR2(4 ), 
	OUT_SLOT_OPERATOR                                            VARCHAR2(4 ), 
	SPECIAL_HANDLING                                             VARCHAR2(3 ), 
	SEAL_NO                                                      VARCHAR2(20 ), 
	DISCHARGE_PORT                                               VARCHAR2(5 ), 
	POD_TERMINAL                                                 VARCHAR2(5 ), 
	NXT_POD1                                                     VARCHAR2(5 ), 
	NXT_POD2                                                     VARCHAR2(5 ), 
	NXT_POD3                                                     VARCHAR2(5 ), 
	FINAL_POD                                                    VARCHAR2(5 ), 
	FINAL_DEST                                                   VARCHAR2(5 ), 
	NXT_SRV                                                      VARCHAR2(5 ), 
	NXT_VESSEL                                                   VARCHAR2(25 ), 
	NXT_VOYAGE                                                   VARCHAR2(10 ), 
	NXT_DIR                                                      VARCHAR2(2 ), 
	MLO_VESSEL                                                   VARCHAR2(35 ), 
	MLO_VOYAGE                                                   VARCHAR2(10 ), 
	MLO_VESSEL_ETA                                               VARCHAR2(16 ), 
	MLO_POD1                                                     VARCHAR2(5 ), 
	MLO_POD2                                                     VARCHAR2(5 ), 
	MLO_POD3                                                     VARCHAR2(5 ), 
	MLO_DEL                                                      VARCHAR2(5 ), 
	EX_MLO_VESSEL                                                VARCHAR2(5 ), 
	EX_MLO_VESSEL_ETA                                            VARCHAR2(16 ), 
	EX_MLO_VOYAGE                                                VARCHAR2(20 ), 
	HANDLING_INSTRUCTION_1                                       VARCHAR2(3 ), 
	HANDLING_INSTRUCTION_2                                       VARCHAR2(3 ), 
	HANDLING_INSTRUCTION_3                                       VARCHAR2(3 ), 
	CONTAINER_LOADING_REM_1                                      VARCHAR2(3 ), 
	CONTAINER_LOADING_REM_2                                      VARCHAR2(3 ), 
	SPECIAL_CARGO                                                VARCHAR2(3 ), 
	IMDG_CLASS                                                   VARCHAR2(4 ), 
	UN_NUMBER                                                    VARCHAR2(6 ), 
	UN_NUMBER_VARIANT                                            VARCHAR2(1 ), 
	PORT_CLASS                                                   VARCHAR2(5 ), 
	PORT_CLASS_TYPE                                              VARCHAR2(5 ), 
	FLASHPOINT_UNIT                                              VARCHAR2(1 ), 
	FLASHPOINT                                                   VARCHAR2(7 ), 
	FUMIGATION_ONLY                                              VARCHAR2(1 ), 
	RESIDUE_ONLY_FLAG                                            VARCHAR2(1 ), 
	OVERHEIGHT_CM                                                VARCHAR2(15 ), 
	OVERWIDTH_LEFT_CM                                            VARCHAR2(15 ), 
	OVERWIDTH_RIGHT_CM                                           VARCHAR2(15 ), 
	OVERLENGTH_FRONT_CM                                          VARCHAR2(15 ), 
	OVERLENGTH_REAR_CM                                           VARCHAR2(15 ), 
	REEFER_TEMPERATURE                                           VARCHAR2(8 ), 
	REEFER_TMP_UNIT                                              VARCHAR2(1 ), 
	HUMIDITY                                                     VARCHAR2(6 ), 
	VENTILATION                                                  VARCHAR2(6), 
	DA_ERROR                                                     VARCHAR2(1 ), 
	OPN_STATUS                                                   VARCHAR2(3 ), 
	RECORD_CHANGE_USER                                           VARCHAR2(10 ), 
	RECORD_CHANGE_DATE 											 TIMESTAMP (6)
   )  ;
 

   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.SESSION_ID IS 'Session Id';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.PK_OVERSHIPPED_CONTAINER_ID IS 'Overshipped List Detail PK';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.FK_LOAD_LIST_ID IS 'Load List FK';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.BOOKING_NO IS 'Seq. no';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.BOOKING_NO_SOURCE IS 'Booking# Source';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.EQUIPMENT_NO IS 'Equipment#';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.EQUIPMENT_NO_QUESTIONABLE_FLAG IS 'Equipment# Questionalble Flag';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.EQ_SIZE IS 'Size';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.EQ_TYPE IS 'Type';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.FULL_MT IS 'Full/MT';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.BKG_TYP IS 'Booking Type';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.FLAG_SOC_COC IS 'SOC/COC';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.SHIPMENT_TERM IS 'Shipment Trm';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.SHIPMENT_TYPE IS 'Shipment Type';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.LOCAL_STATUS IS 'POL Status';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.LOCAL_TERMINAL_STATUS IS 'Local Container Status';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.MIDSTREAM_HANDLING_CODE IS 'Midstream Handling';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.LOAD_CONDITION IS 'Load Condition';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.LOADING_STATUS IS 'Loading Status';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.STOWAGE_POSITION IS 'Stowage Position';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.ACTIVITY_DATE_TIME IS 'Activity Date/Time';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.CONTAINER_GROSS_WEIGHT IS 'Cont Gross Weight';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.DAMAGED IS 'Damaged';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.VOID_SLOT IS 'Void Slot';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.PREADVICE_FLAG IS 'Preadvice Flag';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.SLOT_OPERATOR IS 'Slot Oper.';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.CONTAINER_OPERATOR IS 'Cont.Oper.';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.OUT_SLOT_OPERATOR IS 'Out Slot Operator';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.SPECIAL_HANDLING IS 'Special Hndl';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.SEAL_NO IS 'Seal No';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.DISCHARGE_PORT IS 'Disharge Port';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.POD_TERMINAL IS 'Discharge Terminal';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.NXT_POD1 IS 'Next POD-1';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.NXT_POD2 IS 'Next POD-2';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.NXT_POD3 IS 'Next POD-3';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.FINAL_POD IS 'Final POD';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.FINAL_DEST IS 'Final Dest';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.NXT_SRV IS 'Nxt Srv.';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.NXT_VESSEL IS 'Nxt Ves.';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.NXT_VOYAGE IS 'Nxt Voy.';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.NXT_DIR IS 'Nxt Dir';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.MLO_VESSEL IS 'MLO vessel';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.MLO_VOYAGE IS 'MLO voyage';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.MLO_VESSEL_ETA IS 'MLO ETA Date';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.MLO_POD1 IS 'MLO POD1';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.MLO_POD2 IS 'MLO POD2';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.MLO_POD3 IS 'MLO POD3';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.MLO_DEL IS 'Connecting MLO_DEL(Place of Delivery)';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.EX_MLO_VESSEL IS 'Ex MLO vessel';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.EX_MLO_VESSEL_ETA IS 'Ex MLO Eta Date';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.EX_MLO_VOYAGE IS 'Ex MLO Voyage';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.HANDLING_INSTRUCTION_1 IS 'Handling 1 Code';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.HANDLING_INSTRUCTION_2 IS 'Handling 2 Code';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.HANDLING_INSTRUCTION_3 IS 'Handling 3 Code';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.CONTAINER_LOADING_REM_1 IS 'Container Loading Remark 1';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.CONTAINER_LOADING_REM_2 IS 'Container Loading Remark 2';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.SPECIAL_CARGO IS 'Special Cargo';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.IMDG_CLASS IS 'IMDG Class';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.UN_NUMBER IS 'UNNO';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.UN_NUMBER_VARIANT IS 'UN Var';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.PORT_CLASS IS 'Port Class';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.PORT_CLASS_TYPE IS 'Port Class Type.';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.FLASHPOINT_UNIT IS 'Flash Unit';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.FLASHPOINT IS 'Flashp';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.FUMIGATION_ONLY IS 'Fumigation Only';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.RESIDUE_ONLY_FLAG IS 'Residue Only Flag';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.OVERHEIGHT_CM IS 'Overheigt';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.OVERWIDTH_LEFT_CM IS 'OWL';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.OVERWIDTH_RIGHT_CM IS 'OWR';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.OVERLENGTH_FRONT_CM IS 'Overlength Front';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.OVERLENGTH_REAR_CM IS 'Overlength Aft';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.REEFER_TEMPERATURE IS 'Reefer Tmp';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.REEFER_TMP_UNIT IS 'Reefer Tmp Unit';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.HUMIDITY IS 'Humidity';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.VENTILATION IS 'Ventilation';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.DA_ERROR IS 'DA Error';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.OPN_STATUS IS 'Open Status';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.RECORD_CHANGE_USER IS 'Update By';
 
   COMMENT ON COLUMN TOS_LL_OVERSHIPPED_CONT_TMP.RECORD_CHANGE_DATE IS 'Update Date Time';
 
   COMMENT ON TABLE TOS_LL_OVERSHIPPED_CONT_TMP  IS 'Load List-  Overshipped Temp - Load List- Overshipped Temp';
 
