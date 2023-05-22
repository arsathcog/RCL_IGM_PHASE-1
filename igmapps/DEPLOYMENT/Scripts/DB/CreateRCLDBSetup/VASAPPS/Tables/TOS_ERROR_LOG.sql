/*** SheetName = 8 ***/
/*** Table Creation script for Error Log ***/
CREATE TABLE TOS_ERROR_LOG (
PK_ERROR_LOG_ID                   INTEGER           NOT NULL, 
LL_DL_FLAG                        VARCHAR2(1)       NOT NULL, 
FK_LOAD_LIST_ID                   INTEGER          , 
FK_OVERSHIPPED_ID                 INTEGER          , 
FK_DISCHARGE_LIST_ID              INTEGER          , 
FK_OVERLANDED_ID                  INTEGER          , 
BKG_NO                            VARCHAR2(17)     , 
EQUIPMENT_NO                      VARCHAR2(12)     , 
ERROR_CODE                        VARCHAR2(5)       NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE TOS_ERROR_LOG is 'Error Log - Error Log for Overshipped/Overlanded' ;
comment on column TOS_ERROR_LOG.PK_ERROR_LOG_ID is 'PK of Error Log' ;
comment on column TOS_ERROR_LOG.LL_DL_FLAG is 'Load List/Discharge List Flag' ;
comment on column TOS_ERROR_LOG.FK_LOAD_LIST_ID is 'Load List  ID' ;
comment on column TOS_ERROR_LOG.FK_OVERSHIPPED_ID is 'Overshipped ID' ;
comment on column TOS_ERROR_LOG.FK_DISCHARGE_LIST_ID is 'Discharge List ID' ;
comment on column TOS_ERROR_LOG.FK_OVERLANDED_ID is 'Overlanded ID' ;
comment on column TOS_ERROR_LOG.BKG_NO is 'Booking#' ;
comment on column TOS_ERROR_LOG.EQUIPMENT_NO is 'Equipment#' ;
comment on column TOS_ERROR_LOG.ERROR_CODE is 'Error code' ;
comment on column TOS_ERROR_LOG.RECORD_STATUS is 'Record Status' ;
comment on column TOS_ERROR_LOG.RECORD_ADD_USER is 'Create By' ;
comment on column TOS_ERROR_LOG.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column TOS_ERROR_LOG.RECORD_CHANGE_USER is 'Update By' ;
comment on column TOS_ERROR_LOG.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_TOS_ELZ01 Creation script for Error Log ***/
ALTER TABLE TOS_ERROR_LOG ADD CONSTRAINT PKR_TOS_ELZ01 PRIMARY KEY ( 
PK_ERROR_LOG_ID)
/
 
