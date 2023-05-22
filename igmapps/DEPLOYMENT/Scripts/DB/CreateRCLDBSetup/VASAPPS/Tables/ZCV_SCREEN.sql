/*** SheetName = 13 ***/
/*** Table Creation script for Save setting view master ***/
CREATE TABLE ZCV_SCREEN (
PK_SCREEN_ID                      INTEGER           NOT NULL, 
SCREEN_NAME                       VARCHAR2(50)      NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZCV_SCREEN is 'Save setting view master - Save setting view master' ;
comment on column ZCV_SCREEN.PK_SCREEN_ID is 'Screen Id PK' ;
comment on column ZCV_SCREEN.SCREEN_NAME is 'Screen Name' ;
comment on column ZCV_SCREEN.RECORD_ADD_USER is '' ;
comment on column ZCV_SCREEN.RECORD_ADD_DATE is '' ;
/*** P.Key PKR_ZCV_SZZ01 Creation script for Save setting view master ***/
ALTER TABLE ZCV_SCREEN ADD CONSTRAINT PKR_ZCV_SZZ01 PRIMARY KEY ( 
PK_SCREEN_ID)
/
 
