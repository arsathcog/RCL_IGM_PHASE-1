/*** SheetName = 17 ***/
/*** Table Creation script for View Grid Details ***/
CREATE TABLE ZCV_VIEW_COLUMN (
PK_VIEW_COLUMN_ID                 INTEGER           NOT NULL, 
FK_VIEW_ID                        NUMBER(5)         NOT NULL, 
FK_SCREEN_COLUMN_ID               NUMBER(5)         NOT NULL, 
COLUMN_SEQ                        NUMBER(3)         NOT NULL, 
DISPLAY_FLAG                      CHAR(1)           NOT NULL, 
DISPLAY_WIDTH                     NUMBER(5)         NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZCV_VIEW_COLUMN is 'View Grid Details - View Grid Details' ;
comment on column ZCV_VIEW_COLUMN.PK_VIEW_COLUMN_ID is 'Primary Key' ;
comment on column ZCV_VIEW_COLUMN.FK_VIEW_ID is 'View Id' ;
comment on column ZCV_VIEW_COLUMN.FK_SCREEN_COLUMN_ID is 'Column ID' ;
comment on column ZCV_VIEW_COLUMN.COLUMN_SEQ is 'Column Sequence' ;
comment on column ZCV_VIEW_COLUMN.DISPLAY_FLAG is 'Display Flag' ;
comment on column ZCV_VIEW_COLUMN.DISPLAY_WIDTH is 'Display Width' ;
comment on column ZCV_VIEW_COLUMN.RECORD_STATUS is 'Record Status' ;
comment on column ZCV_VIEW_COLUMN.RECORD_ADD_USER is 'Create By' ;
comment on column ZCV_VIEW_COLUMN.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZCV_VIEW_COLUMN.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZCV_VIEW_COLUMN.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ZCV_VCZ01 Creation script for View Grid Details ***/
ALTER TABLE ZCV_VIEW_COLUMN ADD CONSTRAINT PKR_ZCV_VCZ01 PRIMARY KEY ( 
PK_VIEW_COLUMN_ID)
/
 
