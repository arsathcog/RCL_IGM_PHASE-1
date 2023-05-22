/*** SheetName = 2 ***/
/*** Table Creation script for Booked Discharge Detail ***/
CREATE TABLE TOS_DL_BOOKED_DISCHARGE (
PK_BOOKED_DISCHARGE_ID            INTEGER           NOT NULL, 
FK_DISCHARGE_LIST_ID              INTEGER           NOT NULL, 
CONTAINER_SEQ_NO                  NUMBER(5)         NOT NULL, 
FK_BOOKING_NO                     VARCHAR2(17)      NOT NULL, 
FK_BKG_SIZE_TYPE_DTL              NUMBER(12)        NOT NULL, 
FK_BKG_SUPPLIER                   NUMBER(12)        NOT NULL, 
FK_BKG_EQUIPM_DTL                 NUMBER(12)        NOT NULL, 
DN_EQUIPMENT_NO                   VARCHAR2(12)     , 
FK_BKG_VOYAGE_ROUTING_DTL         NUMBER(2)         NOT NULL, 
DN_EQ_SIZE                        NUMBER(2)         NOT NULL, 
DN_EQ_TYPE                        VARCHAR2(2)       NOT NULL, 
DN_FULL_MT                        VARCHAR2(1)       NOT NULL, 
DN_BKG_TYP                        VARCHAR2(2)       NOT NULL, 
DN_SOC_COC                        VARCHAR2(1)       NOT NULL, 
DN_SHIPMENT_TERM                  VARCHAR2(4)       NOT NULL, 
DN_SHIPMENT_TYP                   VARCHAR2(3)       NOT NULL, 
LOCAL_STATUS                      VARCHAR2(1)       NOT NULL, 
LOCAL_TERMINAL_STATUS             VARCHAR2(10)     , 
MIDSTREAM_HANDLING_CODE           VARCHAR2(2)      , 
LOAD_CONDITION                    VARCHAR2(1)       NOT NULL, 
DN_LOADING_STATUS                 VARCHAR2(2)       NOT NULL, 
DISCHARGE_STATUS                  VARCHAR2(2)       NOT NULL, 
STOWAGE_POSITION                  VARCHAR2(7)      , 
ACTIVITY_DATE_TIME                TIMESTAMP(6)             , 
CONTAINER_GROSS_WEIGHT            NUMBER(7, 2)     , 
DAMAGED                           VARCHAR2(1)      , 
VOID_SLOT                         NUMBER(6)        , 
FK_SLOT_OPERATOR                  VARCHAR2(4)       NOT NULL, 
FK_CONTAINER_OPERATOR             VARCHAR2(4)       NOT NULL, 
OUT_SLOT_OPERATOR                 VARCHAR2(4)      , 
DN_SPECIAL_HNDL                   VARCHAR2(3)      , 
SEAL_NO                           VARCHAR2(20)     , 
DN_POL                            VARCHAR2(5)       NOT NULL, 
DN_POL_TERMINAL                   VARCHAR2(5)       NOT NULL, 
DN_NXT_POD1                       VARCHAR2(5)      , 
DN_NXT_POD2                       VARCHAR2(5)      , 
DN_NXT_POD3                       VARCHAR2(5)      , 
DN_FINAL_POD                      VARCHAR2(5)       NOT NULL, 
FINAL_DEST                        VARCHAR2(5)      , 
DN_NXT_SRV                        VARCHAR2(5)      , 
DN_NXT_VESSEL                     VARCHAR2(25)     , 
DN_NXT_VOYAGE                     VARCHAR2(10)     , 
DN_NXT_DIR                        VARCHAR2(2)      , 
MLO_VESSEL                        VARCHAR2(35)     , 
MLO_VOYAGE                        VARCHAR2(10)     , 
MLO_VESSEL_ETA                    DATE             , 
MLO_POD1                          VARCHAR2(5)      , 
MLO_POD2                          VARCHAR2(5)      , 
MLO_POD3                          VARCHAR2(5)      , 
MLO_DEL                           VARCHAR2(5)      , 
SWAP_CONNECTION_ALLOWED           CHAR(1)          , 
FK_HANDLING_INSTRUCTION_1         VARCHAR2(3)      , 
FK_HANDLING_INSTRUCTION_2         VARCHAR2(3)      , 
FK_HANDLING_INSTRUCTION_3         VARCHAR2(3)      , 
CONTAINER_LOADING_REM_1           VARCHAR2(3)      , 
CONTAINER_LOADING_REM_2           VARCHAR2(3)      , 
FK_SPECIAL_CARGO                  VARCHAR2(3)      , 
TIGHT_CONNECTION_FLAG1            VARCHAR2(1)      , 
TIGHT_CONNECTION_FLAG2            VARCHAR2(1)      , 
TIGHT_CONNECTION_FLAG3            VARCHAR2(1)      , 
FK_IMDG                           VARCHAR2(4)      , 
FK_UNNO                           VARCHAR2(6)      , 
FK_UN_VAR                         VARCHAR2(1)      , 
FK_PORT_CLASS                     VARCHAR2(5)      , 
FK_PORT_CLASS_TYP                 VARCHAR2(5)      , 
FLASH_UNIT                        VARCHAR2(1)      , 
FLASH_POINT                       NUMBER(6, 3)     , 
FUMIGATION_ONLY                   VARCHAR2(1)      , 
RESIDUE_ONLY_FLAG                 VARCHAR2(1)      , 
OVERHEIGHT_CM                     NUMBER(14, 4)    , 
OVERWIDTH_LEFT_CM                 NUMBER(14, 4)    , 
OVERWIDTH_RIGHT_CM                NUMBER(14, 4)    , 
OVERLENGTH_FRONT_CM               NUMBER(14, 4)    , 
OVERLENGTH_REAR_CM                NUMBER(14, 4)    , 
REEFER_TEMPERATURE                NUMBER(6, 3)     , 
REEFER_TMP_UNIT                   VARCHAR2(1)      , 
DN_HUMIDITY                       NUMBER(5, 2)     , 
DN_VENTILATION                    NUMBER(5,2)      , 
PUBLIC_REMARK                     VARCHAR2(2000)   , 
CRANE_TYPE                        VARCHAR2(3)      ,
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE TOS_DL_BOOKED_DISCHARGE is 'Booked Discharge Detail - Discharge List -Booked Detail' ;
comment on column TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID is 'Discharge List Detail PK' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID is 'Discharge List FK' ;
comment on column TOS_DL_BOOKED_DISCHARGE.CONTAINER_SEQ_NO is 'Seq. no' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO is 'Booking#' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_BKG_SIZE_TYPE_DTL is 'Size Type Seq. No.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_BKG_SUPPLIER is 'Supplier Seq No.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL is 'Cont Seq.#' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO is 'Equipment#' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL is 'Routing Seq. No.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_EQ_SIZE is 'Size' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_EQ_TYPE is 'Type' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_FULL_MT is 'Full/MT' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_BKG_TYP is 'Booking Type' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_SOC_COC is 'SOC/COC' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TERM is 'Shipment Trm' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP is 'Shipment Type' ;
comment on column TOS_DL_BOOKED_DISCHARGE.LOCAL_STATUS is 'POD Status' ;
comment on column TOS_DL_BOOKED_DISCHARGE.LOCAL_TERMINAL_STATUS is 'Local Container Status' ;
comment on column TOS_DL_BOOKED_DISCHARGE.MIDSTREAM_HANDLING_CODE is 'Midstream Handling' ;
comment on column TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION is 'Load Condition' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_LOADING_STATUS is 'Loading Status' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS is 'Discharge Status' ;
comment on column TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION is 'Stowage Position' ;
comment on column TOS_DL_BOOKED_DISCHARGE.ACTIVITY_DATE_TIME is 'Activity Date/Time' ;
comment on column TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT is 'Cont Gross Weight' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DAMAGED is 'Damaged' ;
comment on column TOS_DL_BOOKED_DISCHARGE.VOID_SLOT is 'Void Slot' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_SLOT_OPERATOR is 'Slot Oper.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR is 'Cont.Oper.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.OUT_SLOT_OPERATOR is 'Out Slot Operator' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_SPECIAL_HNDL is 'Special Hndl' ;
comment on column TOS_DL_BOOKED_DISCHARGE.SEAL_NO is 'Seal No' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_POL is 'Load Port' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_POL_TERMINAL is 'Load Terminal' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD1 is 'Next POD-1' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD2 is 'Next POD-2' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD3 is 'Next POD-3' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_FINAL_POD is 'Final POD' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FINAL_DEST is 'Final Dest' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_NXT_SRV is 'Nxt Srv.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_NXT_VESSEL is 'Nxt Ves.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_NXT_VOYAGE is 'Nxt Voy.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_NXT_DIR is 'Nxt Dir' ;
comment on column TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL is 'MLO vessel' ;
comment on column TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE is 'MLO voyage' ;
comment on column TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL_ETA is 'MLO ETA Date' ;
comment on column TOS_DL_BOOKED_DISCHARGE.MLO_POD1 is 'MLO POD1' ;
comment on column TOS_DL_BOOKED_DISCHARGE.MLO_POD2 is 'MLO POD2' ;
comment on column TOS_DL_BOOKED_DISCHARGE.MLO_POD3 is 'MLO POD3' ;
comment on column TOS_DL_BOOKED_DISCHARGE.MLO_DEL is 'Connecting MLO_DEL(Place of Delivery)' ;
comment on column TOS_DL_BOOKED_DISCHARGE.SWAP_CONNECTION_ALLOWED is 'Swap Connection' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1 is 'Handling 1 Code' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2 is 'Handling 2 Code' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3 is 'Handling 3 Code' ;
comment on column TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1 is 'Container Loading Remark 1' ;
comment on column TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2 is 'Container Loading Remark 2' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_SPECIAL_CARGO is 'Special Cargo' ;
comment on column TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1 is 'TC POD1' ;
comment on column TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2 is 'TC POD2' ;
comment on column TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3 is 'TC POD3' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_IMDG is 'IMDG Class' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_UNNO is 'UNNO' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_UN_VAR is 'UN Var' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_PORT_CLASS is 'Port Class' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FK_PORT_CLASS_TYP is 'Port Class Type.' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FLASH_UNIT is 'Flash Unit' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FLASH_POINT is 'Flashp' ;
comment on column TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY is 'Fumigation Only' ;
comment on column TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG is 'Residue Only Flag' ;
comment on column TOS_DL_BOOKED_DISCHARGE.OVERHEIGHT_CM is 'Overheigt' ;
comment on column TOS_DL_BOOKED_DISCHARGE.OVERWIDTH_LEFT_CM is 'OWL' ;
comment on column TOS_DL_BOOKED_DISCHARGE.OVERWIDTH_RIGHT_CM is 'OWR' ;
comment on column TOS_DL_BOOKED_DISCHARGE.OVERLENGTH_FRONT_CM is 'Overlength Front' ;
comment on column TOS_DL_BOOKED_DISCHARGE.OVERLENGTH_REAR_CM is 'Overlength Aft' ;
comment on column TOS_DL_BOOKED_DISCHARGE.REEFER_TEMPERATURE is 'Reefer Tmp' ;
comment on column TOS_DL_BOOKED_DISCHARGE.REEFER_TMP_UNIT is 'Reefer Tmp Unit' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_HUMIDITY is 'Humidity' ;
comment on column TOS_DL_BOOKED_DISCHARGE.DN_VENTILATION is 'Ventilation' ;
comment on column TOS_DL_BOOKED_DISCHARGE.PUBLIC_REMARK is 'Remark' ;
comment on column TOS_DL_BOOKED_DISCHARGE.RECORD_STATUS is 'Record Status' ;
comment on column TOS_DL_BOOKED_DISCHARGE.RECORD_ADD_USER is 'Create By' ;
comment on column TOS_DL_BOOKED_DISCHARGE.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column TOS_DL_BOOKED_DISCHARGE.RECORD_CHANGE_USER is 'Update By' ;
comment on column TOS_DL_BOOKED_DISCHARGE.RECORD_CHANGE_DATE is 'Update Date Time' ;
comment on column TOS_DL_BOOKED_DISCHARGE.CRANE_TYPE is 'Crane Type' ;

/*** P.Key PKR_TOS_BDZ01 Creation script for Booked Discharge Detail ***/
ALTER TABLE TOS_DL_BOOKED_DISCHARGE ADD CONSTRAINT PKR_TOS_BDZ01 PRIMARY KEY ( 
PK_BOOKED_DISCHARGE_ID)
/
 
