/*** SheetName = 4 ***/
/*** Table Creation script for Restow Detail ***/
CREATE TABLE TOS_RESTOW (
PK_RESTOW_ID                      INTEGER           NOT NULL, 
FK_LOAD_LIST_ID                   INTEGER          , 
FK_DISCHARGE_LIST_ID              INTEGER          , 
FK_BOOKING_NO                     VARCHAR2(17)      NOT NULL, 
FK_BKG_SIZE_TYPE_DTL              NUMBER(12)        NOT NULL, 
FK_BKG_SUPPLIER                   NUMBER(12)        NOT NULL, 
FK_BKG_EQUIPM_DTL                 NUMBER(12)        NOT NULL, 
DN_EQUIPMENT_NO                   VARCHAR2(12)      NOT NULL, 
DN_EQ_SIZE                        NUMBER(2)         NOT NULL, 
DN_EQ_TYPE                        VARCHAR2(2)       NOT NULL, 
DN_SOC_COC                        VARCHAR2(1)       NOT NULL, 
DN_SHIPMENT_TERM                  VARCHAR2(4)       NOT NULL, 
DN_SHIPMENT_TYP                   VARCHAR2(3)       NOT NULL, 
MIDSTREAM_HANDLING_CODE           VARCHAR2(2)      , 
LOAD_CONDITION                    VARCHAR2(1)       NOT NULL, 
RESTOW_STATUS                     VARCHAR2(2)       NOT NULL, 
STOWAGE_POSITION                  VARCHAR2(7)       NOT NULL, 
ACTIVITY_DATE_TIME                DATE             , 
CONTAINER_GROSS_WEIGHT            NUMBER(7, 2)     , 
DAMAGED                           VARCHAR2(1)      , 
VOID_SLOT                         NUMBER(6)        , 
FK_SLOT_OPERATOR                  VARCHAR2(4)       NOT NULL, 
FK_CONTAINER_OPERATOR             VARCHAR2(4)       NOT NULL, 
DN_SPECIAL_HNDL                   VARCHAR2(3)      , 
SEAL_NO                           VARCHAR2(20)     , 
FK_SPECIAL_CARGO                  VARCHAR2(3)      , 
PUBLIC_REMARK                     VARCHAR2(2000)   , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE TOS_RESTOW is 'Restow Detail - Restow Load/Discharge List ' ;
comment on column TOS_RESTOW.PK_RESTOW_ID is 'Discharge List Detail PK' ;
comment on column TOS_RESTOW.FK_LOAD_LIST_ID is 'Load List FK' ;
comment on column TOS_RESTOW.FK_DISCHARGE_LIST_ID is 'Discharge List FK' ;
comment on column TOS_RESTOW.FK_BOOKING_NO is 'Booking#' ;
comment on column TOS_RESTOW.FK_BKG_SIZE_TYPE_DTL is 'Size Type Seq. No.' ;
comment on column TOS_RESTOW.FK_BKG_SUPPLIER is 'Supplier Seq. No.' ;
comment on column TOS_RESTOW.FK_BKG_EQUIPM_DTL is 'Cont Seq.#' ;
comment on column TOS_RESTOW.DN_EQUIPMENT_NO is 'Equipment#' ;
comment on column TOS_RESTOW.DN_EQ_SIZE is 'Size' ;
comment on column TOS_RESTOW.DN_EQ_TYPE is 'Type' ;
comment on column TOS_RESTOW.DN_SOC_COC is 'SOC/COC' ;
comment on column TOS_RESTOW.DN_SHIPMENT_TERM is 'Shipment  Term' ;
comment on column TOS_RESTOW.DN_SHIPMENT_TYP is 'Shipment Type' ;
comment on column TOS_RESTOW.MIDSTREAM_HANDLING_CODE is 'Midstream Handling' ;
comment on column TOS_RESTOW.LOAD_CONDITION is 'Load Condition' ;
comment on column TOS_RESTOW.RESTOW_STATUS is 'Restow Status' ;
comment on column TOS_RESTOW.STOWAGE_POSITION is 'Stowage Position' ;
comment on column TOS_RESTOW.ACTIVITY_DATE_TIME is 'Activity Date/Time' ;
comment on column TOS_RESTOW.CONTAINER_GROSS_WEIGHT is 'Cont Gross Weight' ;
comment on column TOS_RESTOW.DAMAGED is 'Damaged' ;
comment on column TOS_RESTOW.VOID_SLOT is 'Void Slot' ;
comment on column TOS_RESTOW.FK_SLOT_OPERATOR is 'Slot Oper.' ;
comment on column TOS_RESTOW.FK_CONTAINER_OPERATOR is 'Cont.Oper.' ;
comment on column TOS_RESTOW.DN_SPECIAL_HNDL is 'Special Hndl' ;
comment on column TOS_RESTOW.SEAL_NO is 'Seal No' ;
comment on column TOS_RESTOW.FK_SPECIAL_CARGO is 'Special Cargo' ;
comment on column TOS_RESTOW.PUBLIC_REMARK is 'Remark' ;
comment on column TOS_RESTOW.RECORD_STATUS is 'Record Status' ;
comment on column TOS_RESTOW.RECORD_ADD_USER is 'Create By' ;
comment on column TOS_RESTOW.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column TOS_RESTOW.RECORD_CHANGE_USER is 'Update By' ;
comment on column TOS_RESTOW.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_TOS_RZZ01 Creation script for Restow Detail ***/
ALTER TABLE TOS_RESTOW ADD CONSTRAINT PKR_TOS_RZZ01 PRIMARY KEY ( 
PK_RESTOW_ID)
/
 
