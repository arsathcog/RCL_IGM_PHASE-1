/*** SheetName = 14 ***/
/*** Table Creation script for Screen Column Info ***/
CREATE TABLE ZCV_SCREEN_COLUMN (
PK_SCREEN_COLUMN_ID               INTEGER           NOT NULL, 
FK_SCREEN_ID                      INTEGER           NOT NULL, 
COLUMN_ID                         VARCHAR2(30)      NOT NULL, 
COLUMN_DESC                       VARCHAR2(100)     NOT NULL, 
HIDEABLE                          CHAR(1)           NOT NULL, 
EDITABLE                          CHAR(1)           NOT NULL, 
DATA_TYPE                         CHAR(1)           NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
DEFAULT_POSITION                  NUMBER(3)        
)
/
 
comment on TABLE ZCV_SCREEN_COLUMN is 'Screen Column Info - Screen Column Info' ;
comment on column ZCV_SCREEN_COLUMN.PK_SCREEN_COLUMN_ID is 'Primary Key' ;
comment on column ZCV_SCREEN_COLUMN.FK_SCREEN_ID is 'Screen Id' ;
comment on column ZCV_SCREEN_COLUMN.COLUMN_ID is 'Column ID' ;
comment on column ZCV_SCREEN_COLUMN.COLUMN_DESC is 'Column Description' ;
comment on column ZCV_SCREEN_COLUMN.HIDEABLE is '' ;
comment on column ZCV_SCREEN_COLUMN.EDITABLE is '' ;
comment on column ZCV_SCREEN_COLUMN.DATA_TYPE is '' ;
comment on column ZCV_SCREEN_COLUMN.RECORD_ADD_USER is '' ;
comment on column ZCV_SCREEN_COLUMN.RECORD_ADD_DATE is '' ;
comment on column ZCV_SCREEN_COLUMN.DEFAULT_POSITION is '' ;
/*** P.Key PKR_ZCV_SCZ01 Creation script for Screen Column Info ***/
ALTER TABLE ZCV_SCREEN_COLUMN ADD CONSTRAINT PKR_ZCV_SCZ01 PRIMARY KEY ( 
PK_SCREEN_COLUMN_ID)
/
 
