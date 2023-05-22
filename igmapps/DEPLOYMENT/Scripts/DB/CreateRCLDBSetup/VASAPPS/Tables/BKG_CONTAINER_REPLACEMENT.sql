/*** SheetName = 9 ***/
/*** Table Creation script for Container replacement ***/
CREATE TABLE BKG_CONTAINER_REPLACEMENT (
PK_CONTAINER_REPLACEMENT_ID       INTEGER           NOT NULL, 
DATE_OF_REPLACEMENT               DATE              NOT NULL, 
TERMINAL                          VARCHAR2(17)      NOT NULL, 
FK_BOOKING_NO                     VARCHAR2(17)      NOT NULL, 
OLD_EQUIPMENT_NO                  VARCHAR2(12)      NOT NULL, 
FK_BKG_SIZE_TYPE_DTL              NUMBER(12)        NOT NULL, 
FK_BKG_SUPPLIER                   NUMBER(12)        NOT NULL, 
FK_BKG_EQUIPM_DTL                 NUMBER(12)        NOT NULL, 
NEW_EQUIPMENT_NO                  VARCHAR2(12)      NOT NULL, 
OLD_SEAL_NO                       VARCHAR2(20)     , 
NEW_SEAL_NO                       VARCHAR2(20)     , 
REPLACEMENT_TYPE                  VARCHAR2(1)       NOT NULL, 
REASON                            VARCHAR2(50)      NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE BKG_CONTAINER_REPLACEMENT is 'Container replacement - Container replacement' ;
comment on column BKG_CONTAINER_REPLACEMENT.PK_CONTAINER_REPLACEMENT_ID is 'Booked Load List PK' ;
comment on column BKG_CONTAINER_REPLACEMENT.DATE_OF_REPLACEMENT is 'Date of Replacement Date' ;
comment on column BKG_CONTAINER_REPLACEMENT.TERMINAL is 'TerminalCode' ;
comment on column BKG_CONTAINER_REPLACEMENT.FK_BOOKING_NO is 'Booking No' ;
comment on column BKG_CONTAINER_REPLACEMENT.OLD_EQUIPMENT_NO is 'Old Container No' ;
comment on column BKG_CONTAINER_REPLACEMENT.FK_BKG_SIZE_TYPE_DTL is '' ;
comment on column BKG_CONTAINER_REPLACEMENT.FK_BKG_SUPPLIER is '' ;
comment on column BKG_CONTAINER_REPLACEMENT.FK_BKG_EQUIPM_DTL is 'Cont Seq.#' ;
comment on column BKG_CONTAINER_REPLACEMENT.NEW_EQUIPMENT_NO is 'New Container No' ;
comment on column BKG_CONTAINER_REPLACEMENT.OLD_SEAL_NO is 'Old Shipper seal' ;
comment on column BKG_CONTAINER_REPLACEMENT.NEW_SEAL_NO is 'New Shipper seal' ;
comment on column BKG_CONTAINER_REPLACEMENT.REPLACEMENT_TYPE is 'Replacement Type' ;
comment on column BKG_CONTAINER_REPLACEMENT.REASON is 'Reason' ;
comment on column BKG_CONTAINER_REPLACEMENT.RECORD_STATUS is 'Record Status' ;
comment on column BKG_CONTAINER_REPLACEMENT.RECORD_ADD_USER is 'Create By' ;
comment on column BKG_CONTAINER_REPLACEMENT.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column BKG_CONTAINER_REPLACEMENT.RECORD_CHANGE_USER is 'Update By' ;
comment on column BKG_CONTAINER_REPLACEMENT.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_BKG_CRZ01 Creation script for Container replacement ***/
ALTER TABLE BKG_CONTAINER_REPLACEMENT ADD CONSTRAINT PKR_BKG_CRZ01 PRIMARY KEY ( 
PK_CONTAINER_REPLACEMENT_ID)
/
 
