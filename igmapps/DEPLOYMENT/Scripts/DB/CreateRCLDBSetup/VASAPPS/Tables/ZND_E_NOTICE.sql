/*** SheetName = 26 ***/
/*** Table Creation script for E Notice ***/
CREATE TABLE ZND_E_NOTICE (
PK_E_NOTICE_ID                    INTEGER           NOT NULL, 
FK_E_NOTICE_REQUEST_ID            INTEGER          , 
ORG_TYPE                          VARCHAR2(1)      , 
FK_FSC_ID                         VARCHAR2(3)      , 
FK_SYSTEM_LEVEL_LINE              VARCHAR2(1)      , 
FK_SYSTEM_LEVEL_TRADE             VARCHAR2(1)      , 
FK_SYSTEM_LEVEL_AGENT             VARCHAR2(3)      , 
FK_CUSTOMER_ID                    VARCHAR2(10)     , 
FK_VENDOR_ID                      VARCHAR2(10)     , 
SUBMIT_TS                         TIMESTAMP         NOT NULL, 
START_TS                          TIMESTAMP        , 
END_TS                            TIMESTAMP        , 
STATUS                            VARCHAR2(1)       NOT NULL, 
PARAMETER                         VARCHAR2(200)    , 
DAEMON_FLG                        VARCHAR2(1)      , 
PRIORITY                          VARCHAR2(1)      , 
MAIL_SUBJECT                      VARCHAR2(1000)   , 
MAIL_BODY_HEADER                  VARCHAR2(4000)   , 
MAIL_BODY_DETAIL                  VARCHAR2(4000)   , 
MAIL_BODY_FOOTER                  VARCHAR2(4000)   , 
ATTACHMENT_FLG                    VARCHAR2(1)      , 
RECORD_STATUS                     VARCHAR2(1)      , 
RECORD_ADD_USER                   VARCHAR2(10)     , 
RECORD_ADD_DATE                   TIMESTAMP        , 
RECORD_CHANGE_USER                VARCHAR2(10)     , 
RECORD_CHANGE_DATE                TIMESTAMP        
)
/
 
comment on TABLE ZND_E_NOTICE is 'E Notice  - E Notice ' ;
comment on column ZND_E_NOTICE.PK_E_NOTICE_ID is 'Notice Id' ;
comment on column ZND_E_NOTICE.FK_E_NOTICE_REQUEST_ID is '' ;
comment on column ZND_E_NOTICE.ORG_TYPE is '' ;
comment on column ZND_E_NOTICE.FK_FSC_ID is '' ;
comment on column ZND_E_NOTICE.FK_SYSTEM_LEVEL_LINE is '' ;
comment on column ZND_E_NOTICE.FK_SYSTEM_LEVEL_TRADE is '' ;
comment on column ZND_E_NOTICE.FK_SYSTEM_LEVEL_AGENT is '' ;
comment on column ZND_E_NOTICE.FK_CUSTOMER_ID is '' ;
comment on column ZND_E_NOTICE.FK_VENDOR_ID is '' ;
comment on column ZND_E_NOTICE.SUBMIT_TS is '' ;
comment on column ZND_E_NOTICE.START_TS is '' ;
comment on column ZND_E_NOTICE.END_TS is '' ;
comment on column ZND_E_NOTICE.STATUS is '' ;
comment on column ZND_E_NOTICE.PARAMETER is '' ;
comment on column ZND_E_NOTICE.DAEMON_FLG is '' ;
comment on column ZND_E_NOTICE.PRIORITY is '' ;
comment on column ZND_E_NOTICE.MAIL_SUBJECT is '' ;
comment on column ZND_E_NOTICE.MAIL_BODY_HEADER is '' ;
comment on column ZND_E_NOTICE.MAIL_BODY_DETAIL is '' ;
comment on column ZND_E_NOTICE.MAIL_BODY_FOOTER is '' ;
comment on column ZND_E_NOTICE.ATTACHMENT_FLG is '' ;
comment on column ZND_E_NOTICE.RECORD_STATUS is '' ;
comment on column ZND_E_NOTICE.RECORD_ADD_USER is '' ;
comment on column ZND_E_NOTICE.RECORD_ADD_DATE is '' ;
comment on column ZND_E_NOTICE.RECORD_CHANGE_USER is '' ;
comment on column ZND_E_NOTICE.RECORD_CHANGE_DATE is '' ;
/*** P.Key PKR_ZND_ENZ01 Creation script for E Notice ***/
ALTER TABLE ZND_E_NOTICE ADD CONSTRAINT PKR_ZND_ENZ02 PRIMARY KEY ( 
PK_E_NOTICE_ID)
/
 
