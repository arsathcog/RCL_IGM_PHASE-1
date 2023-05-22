-- Create Job
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>  'JOB_TOS_DL_MISSING_EQ', 
   job_type                 =>  'PLSQL_BLOCK',
   job_action               =>  'BEGIN  VASAPPS.PCR_EZL_UTILITY.PRR_DL_UPD_MISSING_EQ ; END;', 
   start_date               =>  sysdate-1,
   repeat_interval          =>  'FREQ=DAILY;BYHOUR=12,18;BYMINUTE=0',
   enabled                  =>  true,
   auto_drop                =>  false,
   comments                 =>  'SCHEDULE TO UPDATE MISSING EQ IN EZDL' 
);
end;
