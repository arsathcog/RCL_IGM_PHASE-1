/*** SheetName = 25 ***/
/*** Table Creation script for Dispatch Error ***/
CREATE TABLE ZND_DISPATCH_ERROR (
PK_DISPATCH_ERROR_ID              INTEGER           NOT NULL, 
FK_DISPATCH_ID                    INTEGER          , 
USER_ERR_CD                       VARCHAR2(20)     , 
USER_ERR_MSG                      VARCHAR2(100)    , 
ORA_ERR_CD                        VARCHAR2(20)     , 
ORA_ERR_MSG                       VARCHAR2(100)    , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_DISPATCH_ERROR is 'Dispatch Error - Dispatch Error' ;
comment on column ZND_DISPATCH_ERROR.PK_DISPATCH_ERROR_ID is 'Dispatch Error Id' ;
comment on column ZND_DISPATCH_ERROR.FK_DISPATCH_ID is 'Dispatch Id' ;
comment on column ZND_DISPATCH_ERROR.USER_ERR_CD is 'User Error Code' ;
comment on column ZND_DISPATCH_ERROR.USER_ERR_MSG is 'User Error Message' ;
comment on column ZND_DISPATCH_ERROR.ORA_ERR_CD is 'Oracle Error Code' ;
comment on column ZND_DISPATCH_ERROR.ORA_ERR_MSG is 'Oracle Error Message' ;
comment on column ZND_DISPATCH_ERROR.RECORD_STATUS is 'Record Status' ;
comment on column ZND_DISPATCH_ERROR.RECORD_ADD_USER is 'Create By' ;
comment on column ZND_DISPATCH_ERROR.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZND_DISPATCH_ERROR.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZND_DISPATCH_ERROR.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZND_DEZ01 Creation script for Dispatch Error ***/
ALTER TABLE ZND_DISPATCH_ERROR ADD CONSTRAINT PKR_ZND_DEZ01 PRIMARY KEY ( 
PK_DISPATCH_ERROR_ID)
/
 
