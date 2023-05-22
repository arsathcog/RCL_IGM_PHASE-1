-- Create table
create table TOS_LL_DL_ROUTING
(
  PK_TOS_LL_DL_RT_SEQ   inteGER not null,
  SOURCE                varchar2(20) not null,
  FK_BOOKING_NO         varchar2(20) not null,
  FK_VOYAGE_SEQ_NO      number(2),
  FK_OLD_SERVICE        varchar2(5),
  FK_NEW_SERVICE        varchar2(5),
  FK_OLD_VESSEL         varchar2(5),
  FK_NEW_VESSEL         varchar2(5),
  FK_OLD_VOYAGE         varchar2(10),
  FK_NEW_VOYAGE         varchar2(10),
  FK_OLD_DIRECTION      varchar2(2),
  FK_NEW_DIRECTION      varchar2(2),
  FK_OLD_LOAD_PORT      varchar2(5),
  FK_NEW_LOAD_PORT      varchar2(5),
  FK_OLD_PORT_SEQ       number(5),
  FK_NEW_PORT_SEQ       number(5),
  FK_OLD_DISCHARGE_PORT varchar2(5),
  FK_NEW_DISCHARGE_PORT varchar2(5),
  FK_OLD_ACT_SERVICE    varchar2(5),
  FK_NEW_ACT_SERVICE    varchar2(5),
  FK_OLD_ACT_VESSEL     varchar2(5),
  FK_NEW_ACT_VESSEL     varchar2(5),
  FK_OLD_ACT_VOYAGE     varchar2(10),
  FK_NEW_ACT_VOYAGE     varchar2(10),
  FK_OLD_ACT_PORT_DIR   varchar2(2),
  FK_NEW_ACT_PORT_DIR   varchar2(2),
  FK_OLD_ACT_PORT_SEQ   number(5),
  FK_NEW_ACT_PORT_SEQ   number(5),
  FK_OLD_TO_TERMINAL    varchar2(5),
  FK_NEW_TO_TERMINAL    varchar2(5),
  FK_OLD_FROM_TERMINAL  varchar2(5),
  FK_NEW_FROM_TERMINAL  varchar2(5),
  MODE_TYPE             varchar2(1),
  STATUS                varchar2(1) not null,
  ERR_DESC              varchar2(1000),
  RECORD_STATUS         varchar2(1) not null,
  RECORD_ADD_USER       varchar2(10) not null,
  RECORD_ADD_DATE       timestamp not null,
  RECORD_CHANGE_USER    varchar2(10),
  RECORD_CHANGE_DATE    timestamp
)
tablespace VASDATA
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table TOS_LL_DL_ROUTING
  is 'TO KEEP BOOKING ROUTING DATA TO FLOW TO EZLL/EZDL ';
-- Add comments to the columns 
comment on column TOS_LL_DL_ROUTING.PK_TOS_LL_DL_RT_SEQ
  is 'MANDATORY BOOKING TO EZLL SEQ, PRIMARY KEY  AUTO INCREASEMENT : SR_TOS_LDR01';
comment on column TOS_LL_DL_ROUTING.SOURCE
  is 'Mandatory, Source  Vlaues : ROUTING - Data will flow to EZLL/EZDL';
comment on column TOS_LL_DL_ROUTING.FK_BOOKING_NO
  is 'Mandatory, STATUS Vlaues : P - PENDING, E - ERROR , C - COMPLETE';
comment on column TOS_LL_DL_ROUTING.FK_VOYAGE_SEQ_NO
  is 'Optional, Voyage Seq FK to Booking_voyage_routing_dtl.VOYAGE_SEQNO';
comment on column TOS_LL_DL_ROUTING.FK_OLD_SERVICE
  is 'Optional, Service FK to booking_voyage_routing_dtl.service ';
comment on column TOS_LL_DL_ROUTING.FK_NEW_SERVICE
  is 'Optional, Service FK to booking_voyage_routing_dtl.service ';
comment on column TOS_LL_DL_ROUTING.FK_OLD_VESSEL
  is 'Optional, Vessel , FK to booking_voyage_routing_dtl.vessel';
comment on column TOS_LL_DL_ROUTING.FK_NEW_VESSEL
  is 'Optional, Vessel , FK to booking_voyage_routing_dtl.vessel';
comment on column TOS_LL_DL_ROUTING.FK_OLD_VOYAGE
  is 'Optional, Voyage, FK to booking_voyage_routing_dtl.voyage';
comment on column TOS_LL_DL_ROUTING.FK_NEW_VOYAGE
  is 'Optional, Voyage, FK to booking_voyage_routing_dtl.voyage';
comment on column TOS_LL_DL_ROUTING.FK_OLD_DIRECTION
  is 'Optional, Direction, FK to booking_voyage_routing_dtl.direction';
comment on column TOS_LL_DL_ROUTING.FK_NEW_DIRECTION
  is 'Optional, Direction, FK to booking_voyage_routing_dtl.direction';
comment on column TOS_LL_DL_ROUTING.FK_OLD_LOAD_PORT
  is 'Optional, Load Port, FK to booking_voyage_routing_dtl.LOAD_PORT';
comment on column TOS_LL_DL_ROUTING.FK_NEW_LOAD_PORT
  is 'Optional, Load Port, FK to booking_voyage_routing_dtl.LOAD_PORT';
comment on column TOS_LL_DL_ROUTING.FK_OLD_PORT_SEQ
  is 'Optional, Port Sequence, FK to booking_voyage_routing_dtl.Port Seq';
comment on column TOS_LL_DL_ROUTING.FK_NEW_PORT_SEQ
  is 'Optional, Port Sequence, FK to booking_voyage_routing_dtl.Port Seq';
comment on column TOS_LL_DL_ROUTING.FK_OLD_DISCHARGE_PORT
  is 'Optional, Discharge Port , FK to booking_voyage_routing_dtl.discharge port ';
comment on column TOS_LL_DL_ROUTING.FK_NEW_DISCHARGE_PORT
  is 'Optional, Discharge Port , FK to booking_voyage_routing_dtl.discharge port ';
comment on column TOS_LL_DL_ROUTING.FK_OLD_ACT_SERVICE
  is 'Optional, Act Service , FK to booking_voyage_routing_dtl.ACT_SERVICE_CODE';
comment on column TOS_LL_DL_ROUTING.FK_NEW_ACT_SERVICE
  is 'Optional, Act Service , FK to booking_voyage_routing_dtl.ACT_SERVICE_CODE';
comment on column TOS_LL_DL_ROUTING.FK_OLD_ACT_VESSEL
  is 'Optional, Act Vessel, FK to booking_voyage_routing_dtl.ACT_VESSEL_CODE';
comment on column TOS_LL_DL_ROUTING.FK_NEW_ACT_VESSEL
  is 'Optional, Act Vessel, FK to booking_voyage_routing_dtl.ACT_VESSEL_CODE';
comment on column TOS_LL_DL_ROUTING.FK_OLD_ACT_VOYAGE
  is 'Optional, Act Voyage, FK to booking_voyage_routing_dtl.ACT_VOYAGE_NUMBER';
comment on column TOS_LL_DL_ROUTING.FK_NEW_ACT_VOYAGE
  is 'Optional, Act Voyage, FK to booking_voyage_routing_dtl.ACT_VOYAGE_NUMBER';
comment on column TOS_LL_DL_ROUTING.FK_OLD_ACT_PORT_DIR
  is 'Optional, ACT_PORT_DIRECTION, FK to booking_voyage_routing_dtl.ACT_PORT_DIRECTION';
comment on column TOS_LL_DL_ROUTING.FK_NEW_ACT_PORT_DIR
  is 'Optional, ACT_PORT_DIRECTION, FK to booking_voyage_routing_dtl.ACT_PORT_DIRECTION';
comment on column TOS_LL_DL_ROUTING.FK_OLD_ACT_PORT_SEQ
  is 'Optional, ACT_PORT_SEQUENCE, FK to booking_voyage_routing_dtl.ACT_PORT_SEQUENCE';
comment on column TOS_LL_DL_ROUTING.FK_NEW_ACT_PORT_SEQ
  is 'Optional, ACT_PORT_SEQUENCE, FK to booking_voyage_routing_dtl.ACT_PORT_SEQUENCE';
comment on column TOS_LL_DL_ROUTING.FK_OLD_TO_TERMINAL
  is 'Optional, TO_TERMINAL, FK to booking_voyage_routing_dtl.TO_TERMINAL';
comment on column TOS_LL_DL_ROUTING.FK_NEW_TO_TERMINAL
  is 'Optional, TO_TERMINAL, FK to booking_voyage_routing_dtl.TO_TERMINAL';
comment on column TOS_LL_DL_ROUTING.FK_OLD_FROM_TERMINAL
  is 'Optional, FROM_TERMINAL, FK to booking_voyage_routing_dtl.FROM_TERMINAL';
comment on column TOS_LL_DL_ROUTING.FK_NEW_FROM_TERMINAL
  is 'Optional, FROM_TERMINAL, FK to booking_voyage_routing_dtl.FROM_TERMINAL';
comment on column TOS_LL_DL_ROUTING.MODE_TYPE
  is 'Mandatory, MODE TYPE ,VALUE : I - INSERTING, U - UPDATING , D - DELETING';
comment on column TOS_LL_DL_ROUTING.STATUS
  is 'Mandatory, STATUS Vlaues : P - PENDING, E - ERROR , C - COMPLETE ';
comment on column TOS_LL_DL_ROUTING.ERR_DESC
  is 'Mandatory, ERROR DESCRIPTION';
comment on column TOS_LL_DL_ROUTING.RECORD_STATUS
  is 'Mandatory, Record status , value : A - Active , S - Suspend';
comment on column TOS_LL_DL_ROUTING.RECORD_ADD_USER
  is 'Mandatory, Record add user';
comment on column TOS_LL_DL_ROUTING.RECORD_ADD_DATE
  is 'Mandatory, Record Add Date ';
comment on column TOS_LL_DL_ROUTING.RECORD_CHANGE_USER
  is 'Optional, Record Change User';
comment on column TOS_LL_DL_ROUTING.RECORD_CHANGE_DATE
  is 'Optional, Record Change Date ';
-- Create/Recreate indexes 
create unique index PK_TOS_LDR01 on TOS_LL_DL_ROUTING (pk_tos_ll_dl_rt_seq)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
create index IDX_TOS_LDR02 on TOS_LL_DL_ROUTING (source, record_add_date, status, record_status);

-- Create/Recreate indexes 
create index vasapps.IDX_TOS_LDR03 on VASAPPS.TOS_LL_DL_ROUTING (fk_booking_no, pk_tos_ll_dl_rt_seq)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
