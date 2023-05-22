/*** SheetName = 32 ***/
/*** Table Creation script for Sync Error Handler ***/
CREATE TABLE TOS_SYNC_ERROR_LOG (
PK_SYNC_ERR_LOG_ID                INTEGER           NOT NULL, 
PARAMETER_STRING                  VARCHAR2(500)    , 
PROG_TYPE                         VARCHAR2(20)     , 
OPEARTION_TYPE                    VARCHAR2(1)      , 
ERROR_MSG                         VARCHAR2(100)    , 
RERUN_STATUS                      NUMBER(1)        , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_FILTER                     VARCHAR2(1000);
RECORD_TABLE                      VARCHAR2(500);
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE TOS_SYNC_ERROR_LOG is 'Sync Error Handler - Sync Error Handler' ;
comment on column TOS_SYNC_ERROR_LOG.PK_SYNC_ERR_LOG_ID is 'Auto Generated PK' ;
comment on column TOS_SYNC_ERROR_LOG.PARAMETER_STRING  is 'Parameter String' ;
comment on column TOS_SYNC_ERROR_LOG.PROG_TYPE  is 'Program Type' ;
comment on column TOS_SYNC_ERROR_LOG.OPEARTION_TYPE is 'Operation Type' ;
comment on column TOS_SYNC_ERROR_LOG.ERROR_MSG is 'Error Msg' ;
comment on column TOS_SYNC_ERROR_LOG.RERUN_STATUS is 'Rerun Status' ;
comment on column TOS_SYNC_ERROR_LOG.RECORD_FILTER is 'Record filter' ;
comment on column TOS_SYNC_ERROR_LOG.RECORD_TABLE is 'Record table' ;
comment on column TOS_SYNC_ERROR_LOG.RECORD_STATUS is 'Record Status' ;
comment on column TOS_SYNC_ERROR_LOG.RECORD_ADD_USER is 'Create By' ;
comment on column TOS_SYNC_ERROR_LOG.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column TOS_SYNC_ERROR_LOG.RECORD_CHANGE_USER is 'Update By' ;
comment on column TOS_SYNC_ERROR_LOG.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_TOS_SEL01 Creation script for Sync Error Handler ***/
ALTER TABLE TOS_SYNC_ERROR_LOG ADD CONSTRAINT PKR_TOS_SEL01 PRIMARY KEY ( 
PK_SYNC_ERR_LOG_ID)
/
 
