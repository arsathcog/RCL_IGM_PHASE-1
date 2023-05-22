/*** SheetName = 16 ***/
/*** Table Creation script for View Search components ***/
CREATE TABLE ZCV_VIEW_SEARCH (
PK_VIEW_SEARCH_ID                 INTEGER           NOT NULL, 
FK_VIEW_ID                        INTEGER           NOT NULL, 
COMPONENT_ID                      VARCHAR2(30)      NOT NULL, 
COMPONENT_VALUE                   VARCHAR2(100)     , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE ZCV_VIEW_SEARCH is 'View Search components - View Search components' ;
comment on column ZCV_VIEW_SEARCH.PK_VIEW_SEARCH_ID is 'PK for Search Comp' ;
comment on column ZCV_VIEW_SEARCH.FK_VIEW_ID is 'View Id' ;
comment on column ZCV_VIEW_SEARCH.COMPONENT_ID is 'Component Id' ;
comment on column ZCV_VIEW_SEARCH.COMPONENT_VALUE is 'Component Value' ;
comment on column ZCV_VIEW_SEARCH.RECORD_STATUS is 'Record Status' ;
comment on column ZCV_VIEW_SEARCH.RECORD_ADD_USER is 'Create By' ;
comment on column ZCV_VIEW_SEARCH.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column ZCV_VIEW_SEARCH.RECORD_CHANGE_USER is 'Update By' ;
comment on column ZCV_VIEW_SEARCH.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_ ZC_VSZ01 Creation script for View Search components ***/
ALTER TABLE ZCV_VIEW_SEARCH ADD CONSTRAINT PKR_ZC_VSZ01 PRIMARY KEY ( 
PK_VIEW_SEARCH_ID)
/
 
