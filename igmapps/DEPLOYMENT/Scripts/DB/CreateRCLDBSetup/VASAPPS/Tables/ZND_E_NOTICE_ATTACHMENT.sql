/*** SheetName = 28 ***/
/*** Table Creation script for Attachment details ***/
CREATE TABLE ZND_E_NOTICE_ATTACHMENT (
PK_MAIL_ATTACHMENT_ID             INTEGER           NOT NULL, 
FK_E_NOTICE_REQUEST_ID            INTEGER           NOT NULL, 
FILE_NAME                         VARCHAR2(200)     NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_E_NOTICE_ATTACHMENT is 'Attachment details - Attachment details' ;
comment on column ZND_E_NOTICE_ATTACHMENT.PK_MAIL_ATTACHMENT_ID is 'Record Id' ;
comment on column ZND_E_NOTICE_ATTACHMENT.FK_E_NOTICE_REQUEST_ID is 'E Request Id' ;
comment on column ZND_E_NOTICE_ATTACHMENT.FILE_NAME is 'File Name' ;
comment on column ZND_E_NOTICE_ATTACHMENT.RECORD_STATUS is 'Record Status' ;
comment on column ZND_E_NOTICE_ATTACHMENT.RECORD_ADD_USER is 'Create By' ;
comment on column ZND_E_NOTICE_ATTACHMENT.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZND_E_NOTICE_ATTACHMENT.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZND_E_NOTICE_ATTACHMENT.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZND_ENA01 Creation script for Attachment details ***/
ALTER TABLE ZND_E_NOTICE_ATTACHMENT ADD CONSTRAINT PKR_ZND_ENA01 PRIMARY KEY ( 
PK_MAIL_ATTACHMENT_ID)
/
 
