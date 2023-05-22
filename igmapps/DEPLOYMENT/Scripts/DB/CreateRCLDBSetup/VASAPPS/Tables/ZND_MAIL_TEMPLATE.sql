/*** SheetName = 21 ***/
/*** Table Creation script for Mail Template ***/
CREATE TABLE ZND_MAIL_TEMPLATE (
PK_MAIL_TEMPLATE_ID               INTEGER           NOT NULL, 
MAIL_TEMPLATE_DESCRIPTION         VARCHAR2(100)     NOT NULL, 
FK_E_NOTICE_TYPE_ID               INTEGER           NOT NULL, 
FK_LOCAL_LANGUAGE                 VARCHAR2(4)      , 
SUBJECT_TEMPLATE                  VARCHAR2(1000)   , 
BODY_HEADER_TEMPLATE              VARCHAR2(4000)   , 
BODY_DETAIL_TEMPLATE              VARCHAR2(4000)   , 
BODY_FOOTER_TEMPLATE              VARCHAR2(4000)   , 
ATTACHMENT_FLG                    VARCHAR2(1)      , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_MAIL_TEMPLATE is 'Mail Template - Mail Template' ;
comment on column ZND_MAIL_TEMPLATE.PK_MAIL_TEMPLATE_ID is 'Template Id' ;
comment on column ZND_MAIL_TEMPLATE.MAIL_TEMPLATE_DESCRIPTION is 'Template Description' ;
comment on column ZND_MAIL_TEMPLATE.FK_E_NOTICE_TYPE_ID is 'Notice Type' ;
comment on column ZND_MAIL_TEMPLATE.FK_LOCAL_LANGUAGE is 'Local Language' ;
comment on column ZND_MAIL_TEMPLATE.SUBJECT_TEMPLATE is 'Subject Template' ;
comment on column ZND_MAIL_TEMPLATE.BODY_HEADER_TEMPLATE is 'Header Template' ;
comment on column ZND_MAIL_TEMPLATE.BODY_DETAIL_TEMPLATE is 'Detail Template' ;
comment on column ZND_MAIL_TEMPLATE.BODY_FOOTER_TEMPLATE is 'Footer Template' ;
comment on column ZND_MAIL_TEMPLATE.ATTACHMENT_FLG is 'Attachment Flag' ;
comment on column ZND_MAIL_TEMPLATE.RECORD_STATUS is 'Record Status' ;
comment on column ZND_MAIL_TEMPLATE.RECORD_ADD_USER is 'Create By' ;
comment on column ZND_MAIL_TEMPLATE.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZND_MAIL_TEMPLATE.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZND_MAIL_TEMPLATE.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZND_MTZ01 Creation script for Mail Template ***/
ALTER TABLE ZND_MAIL_TEMPLATE ADD CONSTRAINT PKR_ZND_MTZ01 PRIMARY KEY ( 
PK_MAIL_TEMPLATE_ID)
/
 
