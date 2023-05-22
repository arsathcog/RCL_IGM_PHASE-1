/*** SheetName = 19 ***/
/*** Table Creation script for E- Notice Type ***/
CREATE TABLE ZND_E_NOTICE_TYPE (
PK_E_NOTICE_TYPE_ID               INTEGER           NOT NULL, 
E_NOTICE_CODE                     VARCHAR2(10)      NOT NULL, 
E_NOTICE_DESC                     VARCHAR2(50)      NOT NULL, 
MODULE                            VARCHAR2(3)      , 
NOTICE_RECIPIENT_TYPE             VARCHAR2(1)       NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_E_NOTICE_TYPE is 'E- Notice Type - E- Nitice Type' ;
comment on column ZND_E_NOTICE_TYPE.PK_E_NOTICE_TYPE_ID is 'E-Notice Type' ;
comment on column ZND_E_NOTICE_TYPE.E_NOTICE_CODE is 'E-Notice Code' ;
comment on column ZND_E_NOTICE_TYPE.E_NOTICE_DESC is 'E-Notice Description' ;
comment on column ZND_E_NOTICE_TYPE.MODULE is 'Module' ;
comment on column ZND_E_NOTICE_TYPE.NOTICE_RECIPIENT_TYPE is 'Notice Recipient Type' ;
comment on column ZND_E_NOTICE_TYPE.RECORD_STATUS is 'Record Status' ;
comment on column ZND_E_NOTICE_TYPE.RECORD_ADD_USER is 'Create By' ;
comment on column ZND_E_NOTICE_TYPE.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZND_E_NOTICE_TYPE.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZND_E_NOTICE_TYPE.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZND_ENZ01 Creation script for E- Notice Type ***/
ALTER TABLE ZND_E_NOTICE_TYPE ADD CONSTRAINT PKR_ZND_ENZ01 PRIMARY KEY ( 
PK_E_NOTICE_TYPE_ID)
/
 
