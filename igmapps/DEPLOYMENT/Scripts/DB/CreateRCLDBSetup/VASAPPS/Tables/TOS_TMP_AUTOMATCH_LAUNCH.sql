/*** SheetName = 30 ***/
/*** Table Creation script for Automatch Temporary Table ***/
CREATE TABLE TOS_TMP_AUTOMATCH_LAUNCH (
PK_AUTOMATCH_LAUNCH_ID            INTEGER           NOT NULL, 
FK_LOAD_LIST_ID                   INTEGER           NOT NULL, 
FK_OVERSHIPPED_CONTAINER_ID       INTEGER           NOT NULL, 
FK_BOOKING_NO                     VARCHAR2(17)      NOT NULL, 
DN_EQUIPMENT_NO                   VARCHAR2(12)      NOT NULL, 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP        
)
/
 
comment on TABLE TOS_TMP_AUTOMATCH_LAUNCH is 'Automatch Temporary Table - Automatch Temporary Table' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.PK_AUTOMATCH_LAUNCH_ID is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.FK_LOAD_LIST_ID is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.FK_OVERSHIPPED_CONTAINER_ID is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.FK_BOOKING_NO is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.DN_EQUIPMENT_NO is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.RECORD_STATUS is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.RECORD_ADD_USER is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.RECORD_ADD_DATE is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.RECORD_CHANGE_USER is '' ;
comment on column TOS_TMP_AUTOMATCH_LAUNCH.RECORD_CHANGE_DATE is '' ;
/*** P.Key PKR_TOS_SEL01 Creation script for Automatch Temporary Table ***/
ALTER TABLE TOS_TMP_AUTOMATCH_LAUNCH ADD CONSTRAINT PKR_TOS_SEL02 PRIMARY KEY ( 
PK_AUTOMATCH_LAUNCH_ID)
/
 
