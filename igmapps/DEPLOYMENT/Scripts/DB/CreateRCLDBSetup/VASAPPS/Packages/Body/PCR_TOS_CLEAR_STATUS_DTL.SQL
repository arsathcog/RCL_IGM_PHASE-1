create or replace package body PCR_TOS_CLEAR_STATUS is

PROCEDURE PRR_TOS_CLEAR_STATUS IS 

V_CONFIG_TIME          VARCHAR2(20); 
V_SQL                  VARCHAR2(1000); 


BEGIN 
      
     SELECT D.CONFIG_VALUE INTO V_CONFIG_TIME
     FROM ZCC_CONFIG_VALUE_HDR H ,ZCC_CONFIG_VALUE_DTL D
     WHERE H.PK_SEQ=D.FK_CONFIG_HDR_SEQ
      AND MODULE='EZLL' 
      AND CONFIG_CODE='TIME' 
      AND H.RECORD_STATUS='A' 
      AND D.RECORD_STATUS='A'  ;
    /*--  
     DELETE FROM VASAPPS.TOS_LL_DL_CONTAINERS 
     WHERE STATUS='C'; 
     --*/
      V_SQL := 'DELETE FROM VASAPPS.TOS_LL_DL_CONTAINERS
                WHERE (SYSDATE - TO_DSINTERVAL('''||V_CONFIG_TIME||''') >= RECORD_ADD_DATE)
                AND STATUS = ''C''' ;  
       EXECUTE IMMEDIATE (V_SQL); 
            dbms_output.put_line ('v_sql:' || v_sql ); 
                     
      V_SQL :=  'DELETE FROM VASAPPS.TOS_LL_DL_BOOKING
                WHERE (SYSDATE - TO_DSINTERVAL('''||V_CONFIG_TIME||''') >= RECORD_ADD_DATE)
                AND STATUS = ''C''' ;
      EXECUTE IMMEDIATE (V_SQL);  
           dbms_output.put_line ('v_sql:' || v_sql ); 
                     
      V_SQL :=  'DELETE FROM VASAPPS.TOS_LL_DL_ROUTING
                WHERE (SYSDATE - TO_DSINTERVAL('''||V_CONFIG_TIME||''') >= RECORD_ADD_DATE)
                AND STATUS = ''C''';
     dbms_output.put_line ('v_sql:' || v_sql ); 
     
     EXECUTE IMMEDIATE (V_SQL);   
     COMMIT;    

END PRR_TOS_CLEAR_STATUS;

end PCR_TOS_CLEAR_STATUS;
