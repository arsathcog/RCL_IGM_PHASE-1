/*** SheetName = 24 ***/
/*** Table Creation script for E Notice parameters ***/
CREATE TABLE ZND_E_NOTICE_PARAM (
PK_E_NOTICE_PARAM_ID              INTEGER           NOT NULL, 
FK_E_NOTICE_REQUEST_ID            INTEGER           NOT NULL, 
DATA_KEY                          VARCHAR2(4000)    NOT NULL, 
DATA_VALUE                        VARCHAR2(4000)    NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_E_NOTICE_PARAM is 'E Notice parameters - E Notice parameters' ;
comment on column ZND_E_NOTICE_PARAM.PK_E_NOTICE_PARAM_ID is 'Record Id' ;
comment on column ZND_E_NOTICE_PARAM.FK_E_NOTICE_REQUEST_ID is 'E Request id' ;
comment on column ZND_E_NOTICE_PARAM.DATA_KEY is 'Data Key' ;
comment on column ZND_E_NOTICE_PARAM.DATA_VALUE is 'Data Value' ;
comment on column ZND_E_NOTICE_PARAM.RECORD_ADD_USER is 'Created By' ;
comment on column ZND_E_NOTICE_PARAM.RECORD_ADD_DATE is 'Created Date' ;
/*** P.Key PKR_ZND_ENP01 Creation script for E Notice parameters ***/
ALTER TABLE ZND_E_NOTICE_PARAM ADD CONSTRAINT PKR_ZND_ENP01 PRIMARY KEY ( 
PK_E_NOTICE_PARAM_ID)
/
 
