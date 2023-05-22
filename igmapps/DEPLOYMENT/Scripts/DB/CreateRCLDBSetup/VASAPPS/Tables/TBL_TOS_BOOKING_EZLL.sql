-- Create table
create table TOS_LL_DL_BOOKING
(
  PK_TOS_LL_DL_BOOKING_SEQ INTEGER not null,
  FK_BOOKING_NO           VARCHAR2(20) not null,
  BOOKING_TYPE            VARCHAR2(5) not null,
  OLD_BOOKING_STATUS      VARCHAR2(1) not null,
  NEW_BOOKING_STATUS      VARCHAR2(1) not null,
  SOURCE                  VARCHAR2(5) not null,
  STATUS	          VARCHAR2(1) NOT NULL,
  ERR_DESC		  VARCHAR2(1000) NULL,
  RECORD_STATUS           VARCHAR2(1) not null,
  RECORD_ADD_USER         VARCHAR2(10) not null,
  RECORD_ADD_DATE         TIMESTAMP(6) not null,
  RECORD_CHANGE_USER      VARCHAR2(10),
  RECORD_CHANGE_DATE      TIMESTAMP(6)
)
tablespace VASDATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 10M
    next 10M
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
-- Add comments to the table 
comment on table TOS_LL_DL_BOOKING
  is 'KEEP BOOKING THAT NEED TO FLOW DATA TO EZLL/EZDL ';
-- Add comments to the columns 
comment on column TOS_LL_DL_BOOKING.PK_TOS_LL_DL_BOOKING_SEQ
  is 'MANDATORY BOOKING TO EZLL SEQ, PRIMARY KEY  AUTO INCREASEMENT : SR_TOS_LDB01';
comment on column TOS_LL_DL_BOOKING.FK_BOOKING_NO
  is 'Mandatory, Booking No, FK to BKP001.BABKNO';
comment on column TOS_LL_DL_BOOKING.BOOKING_TYPE
  is 'Mandatory, Booking Type';
comment on column TOS_LL_DL_BOOKING.OLD_BOOKING_STATUS
  is 'Mandatory, Old Booking Status ';
comment on column TOS_LL_DL_BOOKING.NEW_BOOKING_STATUS
  is 'Mandatory, New Booking Status ';
comment on column TOS_LL_DL_BOOKING.SOURCE
  is 'Mandatory, Source  Vlaues : BKG - Data will flow to EZLL/EZDL, LLDL - Datat will flow back to Booking. ';
comment on column TOS_LL_DL_BOOKING.STATUS
  is 'Mandatory, STATUS Vlaues : P - PENDING, E - ERROR , C - COMPLETE  ';  
comment on column TOS_LL_DL_BOOKING.ERR_DESC 
  is 'Mandatory, ERROR DESCRIPTION';
comment on column TOS_LL_DL_BOOKING.RECORD_STATUS
  is 'Mandatory, Record Status, Values : A - Active , S - Suspened';
comment on column TOS_LL_DL_BOOKING.RECORD_ADD_USER
  is 'Mandatory, Record Add user ';
comment on column TOS_LL_DL_BOOKING.RECORD_ADD_DATE
  is 'Mandatory, Record Add Date ';
comment on column TOS_LL_DL_BOOKING.RECORD_CHANGE_USER
  is 'Optional, Record Change User ';
comment on column TOS_LL_DL_BOOKING.RECORD_CHANGE_DATE
  is 'Optional, Record Change Date ';
