/*** SheetName = 3 ***/
/*** Table Creation script for Overlanded Detail ***/
CREATE TABLE TOS_DL_OVERLANDED_CONTAINER (
PK_OVERLANDED_CONTAINER_ID        INTEGER           NOT NULL, 
FK_DISCHARGE_LIST_ID              INTEGER           NOT NULL, 
BOOKING_NO                        VARCHAR2(17)     , 
EQUIPMENT_NO                      VARCHAR2(12)     , 
EQ_SIZE                           NUMBER(2)        , 
EQ_TYPE                           VARCHAR2(2)      , 
FULL_MT                           VARCHAR2(1)      , 
BKG_TYP                           VARCHAR2(2)      , 
FLAG_SOC_COC                      VARCHAR2(1)      , 
SHIPMENT_TERM                     VARCHAR2(4)      , 
SHIPMENT_TYP                      VARCHAR2(3)      , 
LOCAL_STATUS                      VARCHAR2(1)      , 
LOCAL_TERMINAL_STATUS             VARCHAR2(10)     , 
MIDSTREAM_HANDLING_CODE           VARCHAR2(2)      , 
LOAD_CONDITION                    VARCHAR2(1)      , 
STOWAGE_POSITION                  VARCHAR2(7)      , 
ACTIVITY_DATE_TIME                TIMESTAMP(6)     , 
CONTAINER_GROSS_WEIGHT            NUMBER(7, 2)     , 
DAMAGED                           VARCHAR2(1)      , 
VOID_SLOT                         NUMBER(6)        , 
SLOT_OPERATOR                     VARCHAR2(4)      , 
CONTAINER_OPERATOR                VARCHAR2(4)      , 
OUT_SLOT_OPERATOR                 VARCHAR2(4)      , 
SPECIAL_HANDLING                  VARCHAR2(3)      , 
SEAL_NO                           VARCHAR2(20)     , 
POL                               VARCHAR2(5)      , 
POL_TERMINAL                      VARCHAR2(5)      , 
NXT_POD1                          VARCHAR2(5)      , 
NXT_POD2                          VARCHAR2(5)      , 
NXT_POD3                          VARCHAR2(5)      , 
FINAL_POD                         VARCHAR2(5)      , 
FINAL_DEST                        VARCHAR2(5)      , 
NXT_SRV                           VARCHAR2(5)      , 
NXT_VESSEL                        VARCHAR2(25)     , 
NXT_VOYAGE                        VARCHAR2(10)     , 
NXT_DIR                           VARCHAR2(2)      , 
MLO_VESSEL                        VARCHAR2(35)     , 
MLO_VOYAGE                        VARCHAR2(10)     , 
MLO_VESSEL_ETA                    DATE             , 
MLO_POD1                          VARCHAR2(5)      , 
MLO_POD2                          VARCHAR2(5)      , 
MLO_POD3                          VARCHAR2(5)      , 
MLO_DEL                           VARCHAR2(5)      , 
HANDLING_INSTRUCTION_1            VARCHAR2(3)      , 
HANDLING_INSTRUCTION_2            VARCHAR2(3)      , 
HANDLING_INSTRUCTION_3            VARCHAR2(3)      , 
CONTAINER_LOADING_REM_1           VARCHAR2(3)      , 
CONTAINER_LOADING_REM_2           VARCHAR2(3)      , 
SPECIAL_CARGO                     VARCHAR2(3)      , 
IMDG_CLASS                        VARCHAR2(4)      , 
UN_NUMBER                         VARCHAR2(6)      , 
UN_NUMBER_VARIANT                 VARCHAR2(1)      , 
PORT_CLASS                        VARCHAR2(5)      , 
PORT_CLASS_TYP                    VARCHAR2(5)      , 
FLASHPOINT_UNIT                   VARCHAR2(1)      , 
FLASHPOINT                        NUMBER(6, 3)     , 
FUMIGATION_ONLY                   VARCHAR2(1)      , 
RESIDUE_ONLY_FLAG                 VARCHAR2(1)      , 
OVERHEIGHT_CM                     NUMBER(14, 4)    , 
OVERWIDTH_LEFT_CM                 NUMBER(14, 4)    , 
OVERWIDTH_RIGHT_CM                NUMBER(14, 4)    , 
OVERLENGTH_FRONT_CM               NUMBER(14, 4)    , 
OVERLENGTH_REAR_CM                NUMBER(14, 4)    , 
REEFER_TEMPERATURE                NUMBER(6, 3)     , 
REEFER_TMP_UNIT                   VARCHAR2(1)      , 
HUMIDITY                          NUMBER(5, 2)     , 
VENTILATION                       NUMBER(5,2)      , 
DA_ERROR                          VARCHAR2(1)      , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE TOS_DL_OVERLANDED_CONTAINER is 'Overlanded Detail - Discharge List - Overlanded Detail' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.PK_OVERLANDED_CONTAINER_ID is 'Discharge List Detail PK' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.FK_DISCHARGE_LIST_ID is 'Discharge List FK' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.BOOKING_NO is 'Booking#' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO is 'Equipment#' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.EQ_SIZE is 'Size' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.EQ_TYPE is 'Type' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.FULL_MT is 'Full/MT' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.BKG_TYP is 'Booking Type' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.FLAG_SOC_COC is 'SOC/COC' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.SHIPMENT_TERM is 'Shpm Trm' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.SHIPMENT_TYP is 'Shpm Typ' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.LOCAL_STATUS is 'POD Status' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.LOCAL_TERMINAL_STATUS is 'Local Container Status' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.MIDSTREAM_HANDLING_CODE is 'Midstream Handling' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.LOAD_CONDITION is 'Load Condition' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.STOWAGE_POSITION is 'Stowage Position' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.ACTIVITY_DATE_TIME is 'Activity Date/Time' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.CONTAINER_GROSS_WEIGHT is 'Cont Gross Weight' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.DAMAGED is 'Damaged' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.VOID_SLOT is 'Void Slot' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.SLOT_OPERATOR is 'Slot Oper.' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.CONTAINER_OPERATOR is 'Cont.Oper.' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.OUT_SLOT_OPERATOR is 'Out Slot Operator' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.SPECIAL_HANDLING is 'Special Hndl' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.SEAL_NO is 'Seal No' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.POL is 'Load Port' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.POL_TERMINAL is 'Load Terminal' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.NXT_POD1 is 'Next POD-1' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.NXT_POD2 is 'Next POD-2' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.NXT_POD3 is 'Next POD-3' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.FINAL_POD is 'Final POD' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.FINAL_DEST is 'Final Dest' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.NXT_SRV is 'Nxt Srv.' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.NXT_VESSEL is 'Nxt Ves.' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.NXT_VOYAGE is 'Nxt Voy.' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.NXT_DIR is 'Nxt Dir' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.MLO_VESSEL is 'MLO vessel' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.MLO_VOYAGE is 'MLO voyage' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.MLO_VESSEL_ETA is 'MLO ETA Dt' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.MLO_POD1 is 'MLO POD1' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.MLO_POD2 is 'MLO POD2' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.MLO_POD3 is 'MLO POD3' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.MLO_DEL is 'Connecting MLO_DEL(Place of Delivery)' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_1 is 'Handling 1 Code' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_2 is 'Handling 2 Code' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_3 is 'Handling 3 Code' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.CONTAINER_LOADING_REM_1 is 'Container Loading Remark 1' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.CONTAINER_LOADING_REM_2 is 'Container Loading Remark 2' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.SPECIAL_CARGO is 'Special Cargo' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.IMDG_CLASS is 'IMDG Class' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.UN_NUMBER is 'UNNO' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.UN_NUMBER_VARIANT is 'UN Var' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.PORT_CLASS is 'Port Class' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.PORT_CLASS_TYP is 'Port Class Type.' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.FLASHPOINT_UNIT is 'Flash Unit' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.FLASHPOINT is 'Flashp' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.FUMIGATION_ONLY is 'Fumigation Only' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.RESIDUE_ONLY_FLAG is 'Residue Only Flag' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.OVERHEIGHT_CM is 'Overheigt' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.OVERWIDTH_LEFT_CM is 'OWL' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.OVERWIDTH_RIGHT_CM is 'OWR' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.OVERLENGTH_FRONT_CM is 'Overlength Front' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.OVERLENGTH_REAR_CM is 'Overlength Aft' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.REEFER_TEMPERATURE is 'Reefer Tmp' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.REEFER_TMP_UNIT is 'Reefer Tmp Unit' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.HUMIDITY is 'Humidity' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.VENTILATION is 'Ventilation' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.DA_ERROR is 'ERROR ' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.RECORD_STATUS is 'Record Status' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.RECORD_ADD_USER is 'Create By' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.RECORD_CHANGE_USER is 'Update By' ;
comment on column TOS_DL_OVERLANDED_CONTAINER.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_TOS_OCZ01 Creation script for Overlanded Detail ***/
ALTER TABLE TOS_DL_OVERLANDED_CONTAINER ADD CONSTRAINT PKR_TOS_OCZ01 PRIMARY KEY ( 
PK_OVERLANDED_CONTAINER_ID)
/
 
