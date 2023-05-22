BEGIN

-- Create Job
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>  'JOB_TOS_EZLLDL_BOOKING', 
   job_type                 =>  'PLSQL_BLOCK',
   job_action               =>  'BEGIN  VASAPPS.PCR_TOS_SYNC_EZLLDL_BOOKING.PRR_TOS_UPD_EZLLDL_BOOKING ; END;', 
   start_date               =>  sysdate,
   repeat_interval          =>  'FREQ=SECONDLY;INTERVAL=30',
   enabled                  =>  true,
   auto_drop                =>  false,
   comments                 =>  'SCHEDULE TO GET BOOKING NO TO FLOW DATA FROM BOOKING TO EZLL/EZDL'
);
END;
/