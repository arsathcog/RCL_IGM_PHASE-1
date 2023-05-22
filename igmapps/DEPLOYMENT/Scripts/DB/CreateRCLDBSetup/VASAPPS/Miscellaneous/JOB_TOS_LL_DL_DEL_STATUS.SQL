-- Create Job
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>  'JOB_TOS_LL_DL_DEL_STATUS', 
   job_type                 =>  'PLSQL_BLOCK',
   JOB_ACTION               =>  'BEGIN  VASAPPS.PCR_TOS_CLEAR_STATUS.PRR_TOS_CLEAR_STATUS ; END;', 
   START_DATE               =>  sysdate-1 ,
   repeat_interval          =>  'FREQ=DAILY; BYHOUR=05',
   enabled                  =>  true,
   AUTO_DROP                =>  false,
   comments                 =>  'SCHEDULE TO DELETE L AND C STATUS IN TOS_LL_DL_CONTAINERS' 
);
end;