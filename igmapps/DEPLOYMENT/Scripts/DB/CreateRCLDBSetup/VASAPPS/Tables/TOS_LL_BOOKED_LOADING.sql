/*** SheetName = 6 ***/
/*** Table Creation script for Load List Detail ***/
CREATE TABLE TOS_LL_BOOKED_LOADING (
PK_BOOKED_LOADING_ID              INTEGER           NOT NULL, 
FK_LOAD_LIST_ID                   INTEGER           NOT NULL, 
CONTAINER_SEQ_NO                  NUMBER(5)         NOT NULL, 
FK_BOOKING_NO                     VARCHAR2(17)      NOT NULL, 
FK_BKG_SIZE_TYPE_DTL              NUMBER(12)        NOT NULL, 
FK_BKG_SUPPLIER                   NUMBER(12)        NOT NULL, 
FK_BKG_EQUIPM_DTL                 NUMBER(12)        NOT NULL, 
DN_EQUIPMENT_NO                   VARCHAR2(12)     , 
EQUPMENT_NO_SOURCE                VARCHAR2(1)       NOT NULL, 
FK_BKG_VOYAGE_ROUTING_DTL         NUMBER(2)         NOT NULL, 
DN_EQ_SIZE                        NUMBER(2)         NOT NULL, 
DN_EQ_TYPE                        VARCHAR2(2)       NOT NULL, 
DN_FULL_MT                        VARCHAR2(1)       NOT NULL, 
DN_BKG_TYP                        VARCHAR2(2)       NOT NULL, 
DN_SOC_COC                        VARCHAR2(1)       NOT NULL, 
DN_SHIPMENT_TERM                  VARCHAR2(4)       NOT NULL, 
DN_SHIPMENT_TYP                   VARCHAR2(3)       NOT NULL, 
LOCAL_STATUS                      VARCHAR2(1)      , 
LOCAL_TERMINAL_STATUS             VARCHAR2(10)     , 
MIDSTREAM_HANDLING_CODE           VARCHAR2(2)      , 
LOAD_CONDITION                    VARCHAR2(1)       NOT NULL, 
LOADING_STATUS                    VARCHAR2(2)       NOT NULL, 
STOWAGE_POSITION                  VARCHAR2(7)      , 
ACTIVITY_DATE_TIME                TIMESTAMP(6), 
CONTAINER_GROSS_WEIGHT            NUMBER(7, 2)     , 
DAMAGED                           VARCHAR2(1)      , 
VOID_SLOT                         NUMBER(6)        , 
PREADVICE_FLAG                    VARCHAR2(1)      , 
FK_SLOT_OPERATOR                  VARCHAR2(4)       NOT NULL, 
FK_CONTAINER_OPERATOR             VARCHAR2(4)       NOT NULL, 
OUT_SLOT_OPERATOR                 VARCHAR2(4)      , 
DN_SPECIAL_HNDL                   VARCHAR2(3)      , 
SEAL_NO                           VARCHAR2(20)     , 
DN_DISCHARGE_PORT                 VARCHAR2(5)       NOT NULL, 
DN_DISCHARGE_TERMINAL             VARCHAR2(5)       NOT NULL, 
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
EX_MLO_VESSEL                     VARCHAR2(5)      , 
EX_MLO_VESSEL_ETA                 DATE             , 
EX_MLO_VOYAGE                     VARCHAR2(20)     , 
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
REEFER_TMP                        NUMBER(6, 3)     , 
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
 
comment on TABLE TOS_LL_BOOKED_LOADING is 'Load List Detail - Load List Detail' ;
comment on column TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID is 'Booked Load List PK' ;
comment on column TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID is 'Unique Identification' ;
comment on column TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO is 'Seq. no' ;
comment on column TOS_LL_BOOKED_LOADING.FK_BOOKING_NO is 'Booking#' ;
comment on column TOS_LL_BOOKED_LOADING.FK_BKG_SIZE_TYPE_DTL is 'Size Type Seq. No.' ;
comment on column TOS_LL_BOOKED_LOADING.FK_BKG_SUPPLIER is 'Supplier Seq. No.' ;
comment on column TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL is 'Cont Seq.#' ;
comment on column TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO is 'Equipment#' ;
comment on column TOS_LL_BOOKED_LOADING.EQUPMENT_NO_SOURCE  is 'Booking# Source' ;
comment on column TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL is 'Routing Seq. No.' ;
comment on column TOS_LL_BOOKED_LOADING.DN_EQ_SIZE is 'Size' ;
comment on column TOS_LL_BOOKED_LOADING.DN_EQ_TYPE is 'Type' ;
comment on column TOS_LL_BOOKED_LOADING.DN_FULL_MT is 'Full/MT' ;
comment on column TOS_LL_BOOKED_LOADING.DN_BKG_TYP is 'Booking Type' ;
comment on column TOS_LL_BOOKED_LOADING.DN_SOC_COC is 'SOC/COC' ;
comment on column TOS_LL_BOOKED_LOADING.DN_SHIPMENT_TERM is 'Shipment Trm' ;
comment on column TOS_LL_BOOKED_LOADING.DN_SHIPMENT_TYP is 'Shipment Type' ;
comment on column TOS_LL_BOOKED_LOADING.LOCAL_STATUS is 'POL Status' ;
comment on column TOS_LL_BOOKED_LOADING.LOCAL_TERMINAL_STATUS is 'Local Container Status' ;
comment on column TOS_LL_BOOKED_LOADING.MIDSTREAM_HANDLING_CODE is 'Midstream Handling' ;
comment on column TOS_LL_BOOKED_LOADING.LOAD_CONDITION is 'Load Condition' ;
comment on column TOS_LL_BOOKED_LOADING.LOADING_STATUS is 'Loading Status' ;
comment on column TOS_LL_BOOKED_LOADING.STOWAGE_POSITION is 'Stowage Position' ;
comment on column TOS_LL_BOOKED_LOADING.ACTIVITY_DATE_TIME is 'Activity Date/Time' ;
comment on column TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT is 'Cont Gross Weight' ;
comment on column TOS_LL_BOOKED_LOADING.DAMAGED is 'Damaged' ;
comment on column TOS_LL_BOOKED_LOADING.VOID_SLOT is 'Void Slot' ;
comment on column TOS_LL_BOOKED_LOADING.PREADVICE_FLAG is 'Preadvice Flag' ;
comment on column TOS_LL_BOOKED_LOADING.FK_SLOT_OPERATOR is 'Slot Oper.' ;
comment on column TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR is 'Cont.Oper.' ;
comment on column TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR is 'Out Slot Operator' ;
comment on column TOS_LL_BOOKED_LOADING.DN_SPECIAL_HNDL is 'Special Hndl' ;
comment on column TOS_LL_BOOKED_LOADING.SEAL_NO is 'Seal No' ;
comment on column TOS_LL_BOOKED_LOADING.DN_DISCHARGE_PORT is 'Discharge Port' ;
comment on column TOS_LL_BOOKED_LOADING.DN_DISCHARGE_TERMINAL is 'Discharge Terminal' ;
comment on column TOS_LL_BOOKED_LOADING.DN_NXT_POD1 is 'Next POD-1' ;
comment on column TOS_LL_BOOKED_LOADING.DN_NXT_POD2 is 'Next POD-2' ;
comment on column TOS_LL_BOOKED_LOADING.DN_NXT_POD3 is 'Next POD-3' ;
comment on column TOS_LL_BOOKED_LOADING.DN_FINAL_POD is 'Final POD' ;
comment on column TOS_LL_BOOKED_LOADING.FINAL_DEST is 'Final Dest' ;
comment on column TOS_LL_BOOKED_LOADING.DN_NXT_SRV is 'Nxt Srv.' ;
comment on column TOS_LL_BOOKED_LOADING.DN_NXT_VESSEL is 'Nxt Ves.' ;
comment on column TOS_LL_BOOKED_LOADING.DN_NXT_VOYAGE is 'Nxt Voy.' ;
comment on column TOS_LL_BOOKED_LOADING.DN_NXT_DIR is 'Nxt Dir' ;
comment on column TOS_LL_BOOKED_LOADING.MLO_VESSEL is 'MLO vessel' ;
comment on column TOS_LL_BOOKED_LOADING.MLO_VOYAGE is 'MLO voyage' ;
comment on column TOS_LL_BOOKED_LOADING.MLO_VESSEL_ETA is 'MLO ETA Dt' ;
comment on column TOS_LL_BOOKED_LOADING.MLO_POD1 is 'MLO POD1' ;
comment on column TOS_LL_BOOKED_LOADING.MLO_POD2 is 'MLO POD2' ;
comment on column TOS_LL_BOOKED_LOADING.MLO_POD3 is 'MLO POD3' ;
comment on column TOS_LL_BOOKED_LOADING.MLO_DEL is 'Con MLO DEL' ;
comment on column TOS_LL_BOOKED_LOADING.EX_MLO_VESSEL is 'Ex MLO Vessel' ;
comment on column TOS_LL_BOOKED_LOADING.EX_MLO_VESSEL_ETA is 'Ex MLO Vessel ETA Date and time' ;
comment on column TOS_LL_BOOKED_LOADING.EX_MLO_VOYAGE is 'Ex MLO Voyage' ;
comment on column TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1 is 'Handling 1 Code' ;
comment on column TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2 is 'Handling 2 Code' ;
comment on column TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3 is 'Handling 3 Code' ;
comment on column TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1 is 'CLR 1' ;
comment on column TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2 is 'CLR 2' ;
comment on column TOS_LL_BOOKED_LOADING.FK_SPECIAL_CARGO is 'Special Cargo' ;
comment on column TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG1 is 'TC POD1' ;
comment on column TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG2 is 'TC POD2' ;
comment on column TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG3 is 'TC POD3' ;
comment on column TOS_LL_BOOKED_LOADING.FK_IMDG is 'IMDG' ;
comment on column TOS_LL_BOOKED_LOADING.FK_UNNO is 'UNNO' ;
comment on column TOS_LL_BOOKED_LOADING.FK_UN_VAR is 'UN Var' ;
comment on column TOS_LL_BOOKED_LOADING.FK_PORT_CLASS is 'Port Class' ;
comment on column TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP is 'Port Class Type.' ;
comment on column TOS_LL_BOOKED_LOADING.FLASH_UNIT is 'Flash Unit' ;
comment on column TOS_LL_BOOKED_LOADING.FLASH_POINT is 'Flashp' ;
comment on column TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY is 'Fumigation Only' ;
comment on column TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG is 'Residue' ;
comment on column TOS_LL_BOOKED_LOADING.OVERHEIGHT_CM is 'OH' ;
comment on column TOS_LL_BOOKED_LOADING.OVERWIDTH_LEFT_CM is 'OWL' ;
comment on column TOS_LL_BOOKED_LOADING.OVERWIDTH_RIGHT_CM is 'OWR' ;
comment on column TOS_LL_BOOKED_LOADING.OVERLENGTH_FRONT_CM is 'OLF' ;
comment on column TOS_LL_BOOKED_LOADING.OVERLENGTH_REAR_CM is 'OLA' ;
comment on column TOS_LL_BOOKED_LOADING.REEFER_TMP is 'Reefer Tmp' ;
comment on column TOS_LL_BOOKED_LOADING.REEFER_TMP_UNIT is 'Reefer Tmp Unit' ;
comment on column TOS_LL_BOOKED_LOADING.DN_HUMIDITY is 'Humidity' ;
comment on column TOS_LL_BOOKED_LOADING.DN_VENTILATION is 'Ventilation' ;
comment on column TOS_LL_BOOKED_LOADING.PUBLIC_REMARK is 'Remark' ;
comment on column TOS_LL_BOOKED_LOADING.RECORD_STATUS is 'Record Status' ;
comment on column TOS_LL_BOOKED_LOADING.RECORD_ADD_USER is 'Create By' ;
comment on column TOS_LL_BOOKED_LOADING.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column TOS_LL_BOOKED_LOADING.RECORD_CHANGE_USER is 'Update By' ;
comment on column TOS_LL_BOOKED_LOADING.RECORD_CHANGE_DATE is 'Update Date Time' ;
COMMENT ON COLUMN TOS_LL_BOOKED_LOADING_TMP.CRANE_TYPE IS 'Crane Type';
/*** P.Key PKR_TOS_BLZ01 Creation script for Load List Detail ***/
ALTER TABLE TOS_LL_BOOKED_LOADING ADD CONSTRAINT PKR_TOS_BLZ01 PRIMARY KEY ( 
PK_BOOKED_LOADING_ID)
/
 
