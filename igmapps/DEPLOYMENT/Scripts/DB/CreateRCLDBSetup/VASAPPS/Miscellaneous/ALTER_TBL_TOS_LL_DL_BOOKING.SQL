DELETE FROM TOS_LL_DL_BOOKING ;

-- Drop columns 
alter table TOS_LL_DL_BOOKING drop column EQUIPMENT_NO;
alter table TOS_LL_DL_BOOKING drop column EQUIPMENT_SEQ;
alter table TOS_LL_DL_BOOKING drop column CATEGORY_CODE;
alter table TOS_LL_DL_BOOKING drop column VGM;
alter table TOS_LL_DL_BOOKING drop column SEA_LEG_PORT;
alter table TOS_LL_DL_BOOKING drop column FK_SERVICE;
alter table TOS_LL_DL_BOOKING drop column FK_VESSEL;
alter table TOS_LL_DL_BOOKING drop column FK_VOYAGE;
alter table TOS_LL_DL_BOOKING drop column FK_DIRECTION;
alter table TOS_LL_DL_BOOKING drop column FK_PORT_SEQ;

-- Add comments to the columns 
comment on column TOS_LL_DL_BOOKING.PK_TOS_LL_DL_BOOKING_SEQ
  is 'MANDATORY BOOKING TO EZLL SEQ, PRIMARY KEY  AUTO INCREASEMENT : SR_TOS_LDB01';
  
drop index IDX_TOS_LDB01;
create index IDX_TOS_LDB01 on TOS_LL_DL_BOOKING (record_add_date, source, status, record_status)
  tablespace VASINDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
  
  -- Create/Recreate indexes 
create index vasapps.IDX_TOS_LDB03 on VASAPPS.TOS_LL_DL_BOOKING (fk_booking_no, pk_tos_ll_dl_booking_seq)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );

 /*-- 
  create unique index PK_TOS_LL_DL_BKG_SEQ on TOS_LL_DL_BOOKING (pk_tos_ll_dl_booking_seq)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );

  -- Create/Recreate indexes 
create index IDX_TOS_LDB01 on TOS_LL_DL_BOOKING (record_add_date, source, STATUS)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
  
  -- Create/Recreate indexes 
create index IDX_TOS_LDB02 on TOS_LL_DL_BOOKING (pk_tos_ll_dl_booking_seq, fk_booking_no)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
--*/

