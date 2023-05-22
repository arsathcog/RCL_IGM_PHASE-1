/*** SheetName = 15 ***/
/*** Table Creation script for View Master ***/
CREATE TABLE ZCV_VIEW (
PK_VIEW_ID                        INTEGER           NOT NULL, 
VIEW_NAME                         VARCHAR2(100)     NOT NULL, 
FK_SCREEN_ID                      INTEGER           NOT NULL, 
VIEW_TYPE                         CHAR(1)           NOT NULL, 
FK_USER_ID                        VARCHAR2(10)              , 
FK_FSC_ID                         VARCHAR2(3)               , 
DEFAULT_FLAG                      CHAR(1)           NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZCV_VIEW is 'View Master - View Master' ;
comment on column ZCV_VIEW.PK_VIEW_ID is 'View Id' ;
comment on column ZCV_VIEW. VIEW_NAME is 'View Name' ;
comment on column ZCV_VIEW.FK_SCREEN_ID is 'Screen Id' ;
comment on column ZCV_VIEW.VIEW_TYPE is 'View Type' ;
comment on column ZCV_VIEW.FK_USER_ID is 'User Id' ;
comment on column ZCV_VIEW.FK_FSC_ID is 'Fsc Id' ;
comment on column ZCV_VIEW.DEFAULT_FLAG is 'Default Flag' ;
comment on column ZCV_VIEW.RECORD_STATUS is 'Record Status' ;
comment on column ZCV_VIEW.RECORD_ADD_USER is 'Create By' ;
comment on column ZCV_VIEW.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZCV_VIEW.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZCV_VIEW.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZCV_VZZ01 Creation script for View Master ***/
ALTER TABLE ZCV_VIEW ADD CONSTRAINT PKR_ZCV_VZZ01 PRIMARY KEY ( 
PK_VIEW_ID)
/
 
