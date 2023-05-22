BEGIN
  DBMS_SCHEDULER.DROP_JOB(job_name         => 'JOB_TOS_LL_DL_BOOKING');
END;

-- Create Job
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>  'JOB_TOS_LL_DL_BOOKING', 
   job_type                 =>  'PLSQL_BLOCK',
   job_action               =>  'BEGIN  VASAPPS.PCR_TOS_SYNC_LL_DL_BOOKING.PRR_TOS_LL_DL_BOOKING ; END;', 
   start_date               =>  sysdate-1,
   repeat_interval          =>  'FREQ=MINUTELY;INTERVAL=1',
   enabled                  =>  true,
   auto_drop                =>  false,
   comments                 =>  'SCHEDULE TO GET BOOKING NO TO FLOW DATA FROM BOOKING TO EZLL/EZDL' 
);
end;