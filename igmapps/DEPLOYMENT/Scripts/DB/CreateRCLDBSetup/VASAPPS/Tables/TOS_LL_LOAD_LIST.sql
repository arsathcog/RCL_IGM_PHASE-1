/*** SheetName = 5 ***/
/*** Table Creation script for Load List Header ***/
CREATE TABLE TOS_LL_LOAD_LIST (
PK_LOAD_LIST_ID                   INTEGER           NOT NULL, 
DN_SERVICE_GROUP_CODE             VARCHAR2(3)       , 
FK_SERVICE                        VARCHAR2(5)       NOT NULL, 
FK_VESSEL                         VARCHAR2(5)       NOT NULL, 
FK_VOYAGE                         VARCHAR2(10)      NOT NULL, 
FK_DIRECTION                      VARCHAR2(2)       NOT NULL, 
FK_PORT_SEQUENCE_NO               NUMBER(12)        NOT NULL, 
FK_VERSION                        VARCHAR2(5)       NOT NULL, 
DN_PORT                           VARCHAR2(5)       NOT NULL, 
DN_TERMINAL                       VARCHAR2(5)       NOT NULL, 
LOAD_LIST_STATUS                  VARCHAR2(2)       NOT NULL, 
DA_BOOKED_TOT                     NUMBER(5)         NOT NULL, 
DA_LOADED_TOT                     NUMBER(5)         NOT NULL, 
DA_ROB_TOT                        NUMBER(5)         NOT NULL, 
DA_OVERSHIPPED_TOT                NUMBER(5)         NOT NULL, 
DA_SHORTSHIPPED_TOT               NUMBER(5)         NOT NULL, 
FIRST_COMPLETE_USER               VARCHAR2(10),
FIRST_COMPLETE_DATE               TIMESTAMP(6),
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE TOS_LL_LOAD_LIST is 'Load List Header - Load List Header' ;
comment on column TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID is 'Unique Identification' ;
comment on column TOS_LL_LOAD_LIST.DN_SERVICE_GROUP_CODE is 'Service Group' ;
comment on column TOS_LL_LOAD_LIST.FK_SERVICE is 'Service' ;
comment on column TOS_LL_LOAD_LIST.FK_VESSEL is 'Vessel Code' ;
comment on column TOS_LL_LOAD_LIST.FK_VOYAGE is 'Voyage' ;
comment on column TOS_LL_LOAD_LIST.FK_DIRECTION is 'Direction' ;
comment on column TOS_LL_LOAD_LIST.FK_PORT_SEQUENCE_NO is 'Sequence' ;
comment on column TOS_LL_LOAD_LIST.FK_VERSION is 'Version' ;
comment on column TOS_LL_LOAD_LIST.DN_PORT is 'Port' ;
comment on column TOS_LL_LOAD_LIST.DN_TERMINAL is 'Terminal' ;
comment on column TOS_LL_LOAD_LIST.LOAD_LIST_STATUS is 'Load Status' ;
comment on column TOS_LL_LOAD_LIST.DA_BOOKED_TOT is 'Booked Total' ;
comment on column TOS_LL_LOAD_LIST.DA_LOADED_TOT is 'LoadedTotal' ;
comment on column TOS_LL_LOAD_LIST.DA_ROB_TOT is 'ROB Total' ;
comment on column TOS_LL_LOAD_LIST.DA_OVERSHIPPED_TOT is 'Overlanded Total' ;
comment on column TOS_LL_LOAD_LIST.DA_SHORTSHIPPED_TOT is 'Shortlanded Total' ;
comment on column TOS_LL_LOAD_LIST.RECORD_STATUS is 'Record Status' ;
comment on column TOS_LL_LOAD_LIST.RECORD_ADD_USER is 'Create By' ;
comment on column TOS_LL_LOAD_LIST.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column TOS_LL_LOAD_LIST.RECORD_CHANGE_USER is 'Update By' ;
comment on column TOS_LL_LOAD_LIST.RECORD_CHANGE_DATE is 'Update Date Time' ;
COMMENT ON COLUMN VASAPPS.TOS_DL_DISCHARGE_LIST.FIRST_COMPLETE_USER IS 'Name of user completed Discharge list fist time';
COMMENT ON COLUMN VASAPPS.TOS_DL_DISCHARGE_LIST.FIRST_COMPLETE_DATE IS 'First date when Discharge list completed.';


/*** P.Key PKR_TOS_LLZ01 Creation script for Load List Header ***/
ALTER TABLE TOS_LL_LOAD_LIST ADD CONSTRAINT PKR_TOS_LLZ01 PRIMARY KEY ( 
PK_LOAD_LIST_ID)
/
 
