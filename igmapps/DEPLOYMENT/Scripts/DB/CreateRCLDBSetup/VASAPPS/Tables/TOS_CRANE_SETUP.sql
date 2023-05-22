-- Create table
create table TOS_CRANE_SETUP
(
  DN_PORT            VARCHAR2(5) not null,
  DN_TERMINAL        VARCHAR2(5) not null,
  CRANE_CODE         VARCHAR2(3) not null,
  CRANE_TYPE         VARCHAR2(1) not null,
  CRANE_NUMBER       NUMBER not null,
  FK_VENDOR_CODE     VARCHAR2(10),
  CRANE_DESCRIPTION  VARCHAR2(100),
  RECORD_STATUS      VARCHAR2(1) not null,
  RECORD_ADD_USER    VARCHAR2(10) not null,
  RECORD_ADD_DATE    DATE not null,
  RECORD_CHANGE_USER VARCHAR2(10) not null,
  RECORD_CHANGE_DATE DATE not null
)
tablespace VASDATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TOS_CRANE_SETUP.DN_PORT
  is 'Port code';
comment on column TOS_CRANE_SETUP.DN_TERMINAL
  is 'Terminal code';
comment on column TOS_CRANE_SETUP.CRANE_CODE
  is 'Unique crane code';
comment on column TOS_CRANE_SETUP.CRANE_TYPE
  is 'Crane Type Code';
comment on column TOS_CRANE_SETUP.CRANE_NUMBER
  is 'Number of crane';
comment on column TOS_CRANE_SETUP.FK_VENDOR_CODE
  is ' FK1 to ITP025 field VCVNCD';
comment on column TOS_CRANE_SETUP.CRANE_DESCRIPTION
  is 'Crane description';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TOS_CRANE_SETUP
  add constraint TOS_CRANE_SETUP_PK primary key (DN_PORT, DN_TERMINAL, CRANE_CODE)
  using index 
  tablespace VASDATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
