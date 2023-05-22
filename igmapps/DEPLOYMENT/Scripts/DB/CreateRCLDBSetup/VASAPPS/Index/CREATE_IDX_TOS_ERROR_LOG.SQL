-- Create/Recreate indexes 
create index IDX_TOS_TEL01 on TOS_ERROR_LOG (fk_discharge_list_id, error_code)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
create index IDX_TOS_TEL02 on TOS_ERROR_LOG (fk_load_list_id, error_code)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
