/*** SheetName = 23 ***/
/*** Table Creation script for Org Receipent ***/
CREATE TABLE ZND_ORG_RECIPIENT (
PK_ORG_RECIPIENT_ID               INTEGER           NOT NULL, 
FK_RECEIVER_ORG_ID                INTEGER           NOT NULL, 
RECIPIENT_TYPE                    VARCHAR2(3)       NOT NULL, 
RECIPIENT_EMAIL                   VARCHAR2(50)      NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_ORG_RECIPIENT is 'Org Receipent - Org Receipent' ;
comment on column ZND_ORG_RECIPIENT.PK_ORG_RECIPIENT_ID is 'Recipient Id' ;
comment on column ZND_ORG_RECIPIENT.FK_RECEIVER_ORG_ID is 'Reciever Id' ;
comment on column ZND_ORG_RECIPIENT.RECIPIENT_TYPE is 'Recipient Type' ;
comment on column ZND_ORG_RECIPIENT.RECIPIENT_EMAIL is 'Recipient Email' ;
comment on column ZND_ORG_RECIPIENT.RECORD_STATUS is 'Record Status' ;
comment on column ZND_ORG_RECIPIENT.RECORD_ADD_USER is 'Create By' ;
comment on column ZND_ORG_RECIPIENT.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZND_ORG_RECIPIENT.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZND_ORG_RECIPIENT.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZND_ORZ01 Creation script for Org Receipent ***/
ALTER TABLE ZND_ORG_RECIPIENT ADD CONSTRAINT PKR_ZND_ORZ01 PRIMARY KEY ( 
PK_ORG_RECIPIENT_ID)
/
 
