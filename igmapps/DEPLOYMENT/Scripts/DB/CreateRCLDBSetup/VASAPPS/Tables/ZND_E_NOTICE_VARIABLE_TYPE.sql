/*** SheetName = 20 ***/
/*** Table Creation script for E Notive Variable ***/
CREATE TABLE ZND_E_NOTICE_VARIABLE_TYPE (
PK_E_NOTICE_VARIABLE_ID           INTEGER           NOT NULL, 
FK_E_NOTICE_TYPE_ID               INTEGER           NOT NULL, 
VARIABLE_DESC                     VARCHAR2(50)      NOT NULL, 
MAP_CODE                          VARCHAR2(30)      NOT NULL, 
MULTIPLE_VALUES_FLAG              VARCHAR2(1)      , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_E_NOTICE_VARIABLE_TYPE is 'E Notive Variable - E Notive Variable' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.PK_E_NOTICE_VARIABLE_ID is 'Variable Id' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.FK_E_NOTICE_TYPE_ID is 'Notice Id' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.VARIABLE_DESC is 'Variable Description' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.MAP_CODE is 'Map Code' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.MULTIPLE_VALUES_FLAG is 'Multiple Value Flag' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.RECORD_STATUS is 'Record Status' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.RECORD_ADD_USER is 'Create By' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZND_E_NOTICE_VARIABLE_TYPE.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZND_ENV01 Creation script for E Notive Variable ***/
ALTER TABLE ZND_E_NOTICE_VARIABLE_TYPE ADD CONSTRAINT PKR_ZND_ENV01 PRIMARY KEY ( 
PK_E_NOTICE_VARIABLE_ID)
/
 
