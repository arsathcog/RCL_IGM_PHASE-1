/*** SheetName = 1 ***/
/*** Table Creation script for Discharge List Header ***/
CREATE TABLE TOS_DL_DISCHARGE_LIST (
PK_DISCHARGE_LIST_ID              INTEGER           NOT NULL, 
DN_SERVICE_GROUP_CODE             VARCHAR2(3)       , 
FK_SERVICE                        VARCHAR2(5)       NOT NULL, 
FK_VESSEL                         VARCHAR2(5)       NOT NULL, 
FK_VOYAGE                         VARCHAR2(10)      NOT NULL, 
FK_DIRECTION                      VARCHAR2(2)       NOT NULL, 
FK_PORT_SEQUENCE_NO               NUMBER(12)        NOT NULL, 
FK_VERSION                        VARCHAR2(5)       NOT NULL, 
DN_PORT                           VARCHAR2(5)       NOT NULL, 
DN_TERMINAL                       VARCHAR2(5)       NOT NULL, 
DISCHARGE_LIST_STATUS             VARCHAR2(2)       NOT NULL, 
DA_BOOKED_TOT                     NUMBER(5)         NOT NULL, 
DA_DISCHARGED_TOT                 NUMBER(5)         NOT NULL, 
DA_ROB_TOT                        NUMBER(5)         NOT NULL, 
DA_OVERLANDED_TOT                 NUMBER(5)         NOT NULL, 
DA_SHORTLANDED_TOT                NUMBER(5)         NOT NULL, 
FIRST_COMPLETE_USER               VARCHAR2(10),
FIRST_COMPLETE_DATE               TIMESTAMP(6),
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE TOS_DL_DISCHARGE_LIST is 'Discharge List Header - Discharge List Header' ;
comment on column TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID is 'Unique Identification' ;
comment on column TOS_DL_DISCHARGE_LIST.DN_SERVICE_GROUP_CODE is 'Service Group' ;
comment on column TOS_DL_DISCHARGE_LIST.FK_SERVICE is 'Service' ;
comment on column TOS_DL_DISCHARGE_LIST.FK_VESSEL is 'Vessel Code' ;
comment on column TOS_DL_DISCHARGE_LIST.FK_VOYAGE is 'Voyage' ;
comment on column TOS_DL_DISCHARGE_LIST.FK_DIRECTION is 'Direction' ;
comment on column TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO is 'Sequence' ;
comment on column TOS_DL_DISCHARGE_LIST.FK_VERSION is 'Version' ;
comment on column TOS_DL_DISCHARGE_LIST.DN_PORT is 'Port' ;
comment on column TOS_DL_DISCHARGE_LIST.DN_TERMINAL is 'Terminal' ;
comment on column TOS_DL_DISCHARGE_LIST.DISCHARGE_LIST_STATUS is 'Discharged Status' ;
comment on column TOS_DL_DISCHARGE_LIST.DA_BOOKED_TOT is 'Booked Total' ;
comment on column TOS_DL_DISCHARGE_LIST.DA_DISCHARGED_TOT is 'Discharged Total' ;
comment on column TOS_DL_DISCHARGE_LIST.DA_ROB_TOT is 'ROB Total' ;
comment on column TOS_DL_DISCHARGE_LIST.DA_OVERLANDED_TOT is 'Overlanded Total' ;
comment on column TOS_DL_DISCHARGE_LIST.DA_SHORTLANDED_TOT is 'Shortlanded Total' ;
comment on column TOS_DL_DISCHARGE_LIST.RECORD_STATUS is 'Record Status' ;
comment on column TOS_DL_DISCHARGE_LIST.RECORD_ADD_USER is 'Create By' ;
comment on column TOS_DL_DISCHARGE_LIST.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column TOS_DL_DISCHARGE_LIST.RECORD_CHANGE_USER is 'Update By' ;
comment on column TOS_DL_DISCHARGE_LIST.RECORD_CHANGE_DATE is 'Update Date Time' ;
COMMENT ON COLUMN VASAPPS.TOS_DL_DISCHARGE_LIST.FIRST_COMPLETE_USER IS 'Name of user completed Discharge list fist time';
COMMENT ON COLUMN VASAPPS.TOS_DL_DISCHARGE_LIST.FIRST_COMPLETE_DATE IS 'First date when Discharge list completed.';


/*** P.Key PKR_TOS_DLZ01 Creation script for Discharge List Header ***/
ALTER TABLE TOS_DL_DISCHARGE_LIST ADD CONSTRAINT PKR_TOS_DLZ01 PRIMARY KEY ( 
PK_DISCHARGE_LIST_ID)
/
 
