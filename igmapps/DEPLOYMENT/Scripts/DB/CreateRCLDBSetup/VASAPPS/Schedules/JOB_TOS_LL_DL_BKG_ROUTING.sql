-- Create Job
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>  'JOB_TOS_LL_DL_BKG_ROUTING', 
   job_type                 =>  'PLSQL_BLOCK',
   job_action               =>  'BEGIN  VASAPPS.PCR_TOS_SYNC_LL_DL_BOOKING.PRR_TOS_LL_DL_ROUTING ; END;', 
   start_date               =>  sysdate-1,
   repeat_interval          =>  'FREQ=MINUTELY;INTERVAL=1',
   enabled                  =>  true,
   auto_drop                =>  false,
   comments                 =>  'SCHEDULE TO RE FLOW BOOKING DATA TO EZLL/EZDL AFTER CHANGE ROUTING' 
);
end;
