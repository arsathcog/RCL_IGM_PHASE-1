alter trigger VASAPPS.TRG_LL_DL_BKP001 disable;
alter trigger VASAPPS.TRG_LL_DL_BKP009 disable; 
EXEC DBMS_SCHEDULER.disable(name=>'VASAPPS.JOB_TOS_EZLLDL_BOOKING');
exec dbms_scheduler.disable(name=>'VASAPPS.JOB_TOS_REPROC_LLDL_BOOKING');