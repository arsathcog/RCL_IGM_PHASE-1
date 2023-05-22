/*** SheetName = 22 ***/
/*** Table Creation script for Receiver Organization ***/
CREATE TABLE ZND_RECEIVER_ORG (
PK_RECEIVER_ORG_ID                INTEGER           NOT NULL, 
FK_MAIL_TEMPLATE_ID               INTEGER           NOT NULL, 
ORG_TYPE                          VARCHAR2(1)       NOT NULL, 
FK_FSC_ID                         VARCHAR2(3)       , 
FK_SYSTEM_LEVEL_LINE              VARCHAR2(1)       , 
FK_SYSTEM_LEVEL_TRADE             VARCHAR2(1)       , 
FK_SYSTEM_LEVEL_AGENT             VARCHAR2(3)       , 
FK_CUSTOMER_ID                    VARCHAR2(10)      , 
FK_VENDOR_ID                      VARCHAR2(10)      , 
PRIORITY                          VARCHAR2(1)      , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZND_RECEIVER_ORG is 'Receiver Organization - Receiver Organization' ;
comment on column ZND_RECEIVER_ORG.PK_RECEIVER_ORG_ID is 'Receiver Id' ;
comment on column ZND_RECEIVER_ORG.FK_MAIL_TEMPLATE_ID is 'Template Id' ;
comment on column ZND_RECEIVER_ORG.ORG_TYPE is 'Organisation Type' ;
comment on column ZND_RECEIVER_ORG.FK_FSC_ID is 'Fsc Id' ;
comment on column ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_LINE is 'System Level' ;
comment on column ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_TRADE is 'System Level' ;
comment on column ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_AGENT is 'System Level' ;
comment on column ZND_RECEIVER_ORG.FK_CUSTOMER_ID is 'Customer Id' ;
comment on column ZND_RECEIVER_ORG.FK_VENDOR_ID is 'Vendor Id' ;
comment on column ZND_RECEIVER_ORG.PRIORITY is 'Priority' ;
comment on column ZND_RECEIVER_ORG.RECORD_STATUS is 'Record Status' ;
comment on column ZND_RECEIVER_ORG.RECORD_ADD_USER is 'Create By' ;
comment on column ZND_RECEIVER_ORG.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZND_RECEIVER_ORG.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZND_RECEIVER_ORG.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZND_EMZ01 Creation script for Receiver Organization ***/
ALTER TABLE ZND_RECEIVER_ORG ADD CONSTRAINT PKR_ZND_EMZ01 PRIMARY KEY ( 
PK_RECEIVER_ORG_ID)
/
 
