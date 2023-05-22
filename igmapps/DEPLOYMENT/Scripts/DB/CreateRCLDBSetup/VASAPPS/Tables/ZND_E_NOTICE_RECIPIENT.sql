/*** SheetName = 27 ***/
/*** Table Creation script for E Notice Recitient ***/
CREATE TABLE ZND_E_NOTICE_RECIPIENT (
PK_E_NOTICE_RECIPIENT_ID          INTEGER           NOT NULL, 
FK_E_NOTICE_ID                    INTEGER           NOT NULL, 
RECIPIENT_TYPE                    VARCHAR2(3)       NOT NULL, 
RECIPIENT_EMAIL                   VARCHAR2(50)      NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_E_NOTICE_RECIPIENT is 'E Notice Recitient - E Notice Recitient' ;
comment on column ZND_E_NOTICE_RECIPIENT.PK_E_NOTICE_RECIPIENT_ID is 'Recipient Id' ;
comment on column ZND_E_NOTICE_RECIPIENT.FK_E_NOTICE_ID is 'Notice Id' ;
comment on column ZND_E_NOTICE_RECIPIENT.RECIPIENT_TYPE is 'Recipient Type' ;
comment on column ZND_E_NOTICE_RECIPIENT.RECIPIENT_EMAIL is 'Recipient Email' ;
comment on column ZND_E_NOTICE_RECIPIENT.RECORD_STATUS is 'Record Status' ;
comment on column ZND_E_NOTICE_RECIPIENT.RECORD_ADD_USER is 'Create By' ;
comment on column ZND_E_NOTICE_RECIPIENT.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZND_E_NOTICE_RECIPIENT.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZND_E_NOTICE_RECIPIENT.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZND_EMR01 Creation script for E Notice Recitient ***/
ALTER TABLE ZND_E_NOTICE_RECIPIENT ADD CONSTRAINT PKR_ZND_EMR01 PRIMARY KEY ( 
PK_E_NOTICE_RECIPIENT_ID)
/
 
