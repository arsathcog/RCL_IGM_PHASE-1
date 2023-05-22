/*** SheetName = 31 ***/
/*** Table Creation script for Notice Request ***/
CREATE TABLE ZND_E_NOTICE_REQUEST (
PK_E_NOTICE_REQUEST_ID            INTEGER           NOT NULL, 
BUSINESS_KEY_ID                   INTEGER          , 
FK_E_NOTICE_TYPE_ID               INTEGER          , 
DATA_KEY                          VARCHAR2(4000)   , 
DATA_VALUE                        VARCHAR2(4000)   , 
FK_ORIGINATING_FSC                VARCHAR2(3)      , 
RECORD_ADD_USER                   VARCHAR2(10)     , 
RECORD_ADD_DATE                   TIMESTAMP        
)
/
 
comment on TABLE ZND_E_NOTICE_REQUEST is 'Notice Request - Notice Request' ;
comment on column ZND_E_NOTICE_REQUEST.PK_E_NOTICE_REQUEST_ID is '' ;
comment on column ZND_E_NOTICE_REQUEST.BUSINESS_KEY_ID is '' ;
comment on column ZND_E_NOTICE_REQUEST.FK_E_NOTICE_TYPE_ID is '' ;
comment on column ZND_E_NOTICE_REQUEST.DATA_KEY is '' ;
comment on column ZND_E_NOTICE_REQUEST.DATA_VALUE is '' ;
comment on column ZND_E_NOTICE_REQUEST.FK_ORIGINATING_FSC is '' ;
comment on column ZND_E_NOTICE_REQUEST.RECORD_ADD_USER is '' ;
comment on column ZND_E_NOTICE_REQUEST.RECORD_ADD_DATE is '' ;
/*** P.Key PKR_ZND_SEL01 Creation script for Notice Request ***/
ALTER TABLE ZND_E_NOTICE_REQUEST ADD CONSTRAINT PKR_ZND_SEL01 PRIMARY KEY ( 
PK_E_NOTICE_REQUEST_ID)
/
 
