-- Add/modify columns 
alter table TOS_DL_BOOKED_DISCHARGE add VGM number(14,2);
-- Add comments to the columns 
comment on column TOS_DL_BOOKED_DISCHARGE.VGM
  is 'VGM, FK TO BKP009.EQP_VGM';

  -- Add/modify columns 
alter table TOS_DL_BOOKED_DISCHARGE_TMP add VGM varchar2(14);
-- Add comments to the columns 
comment on column TOS_DL_BOOKED_DISCHARGE_TMP.VGM
  is 'VGM, FK TO BKP009.EQP_VGM';

  -- Add/modify columns 
alter table TOS_DL_OVERLANDED_CONTAINER add VGM number(14,2);
-- Add comments to the columns 
comment on column TOS_DL_OVERLANDED_CONTAINER.VGM
  is 'VGM, FK TO BKP009.EQP_VGM';

  -- Add/modify columns 
alter table TOS_DL_OVERLANDED_CONT_TMP add VGM varchar2(14);
-- Add comments to the columns 
comment on column TOS_DL_OVERLANDED_CONT_TMP.VGM
  is 'VGM, FK TO BKP009.EQP_VGM';
  
  -- Add/modify columns 
alter table TOS_LL_BOOKED_LOADING add VGM number(14,2);
-- Add comments to the columns 
comment on column TOS_LL_BOOKED_LOADING.VGM
  is 'VGM, FK TO BKP009.EQP_VGM';
  
  -- Add/modify columns 
alter table TOS_LL_BOOKED_LOADING_TMP add VGM varchar2(14);
-- Add comments to the columns 
comment on column TOS_LL_BOOKED_LOADING_TMP.VGM
  is 'VGM, FK TO BKP009.EQP_VGM';

-- Add/modify columns 
alter table TOS_LL_OVERSHIPPED_CONTAINER add VGM number(14,2);
-- Add comments to the columns 
comment on column TOS_LL_OVERSHIPPED_CONTAINER.VGM
  is 'VGM, FK TO BKP009.EQP_VGM';
  
    -- Add/modify columns 
alter table TOS_LL_OVERSHIPPED_CONT_TMP add VGM varchar2(14);
-- Add comments to the columns 
comment on column TOS_LL_OVERSHIPPED_CONT_TMP.VGM
  is 'VGM, FK TO BKP009.EQP_VGM';

