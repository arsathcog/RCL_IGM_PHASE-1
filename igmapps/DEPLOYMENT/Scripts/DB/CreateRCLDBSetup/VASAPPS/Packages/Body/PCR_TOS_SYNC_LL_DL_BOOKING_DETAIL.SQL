create or replace package body PCR_TOS_SYNC_LL_DL_BOOKING is

PROCEDURE PRR_TOS_LL_DL_BOOKING AS

V_BOOKING_NO     		BKP001.BABKNO%TYPE;
V_BOOKING_TYPE	 		BKP001.BOOKING_TYPE%TYPE;
V_OLD_BOOKING_STATUS	BKP001.BASTAT%TYPE;
V_NEW_BOOKING_STATUS	BKP001.BASTAT%TYPE;
V_RETURN_STATUS			VARCHAR2(50);
V_SEQ					      NUMBER(38);
TOS_LL_DL_BKG_PENDING       VASAPPS.TOS_LL_Dl_BOOKING%ROWTYPE;


CURSOR CUR_TOS_LL_DL_BOOKING IS
       SELECT * --FK_BOOKING_NO,BOOKING_TYPE,OLD_BOOKING_STATUS,NEW_BOOKING_STATUS,PK_TOS_LL_DL_BOOKING_SEQ
       from VASAPPS.TOS_LL_DL_BOOKING
       WHERE STATUS = 'L' -- 'P' SELECT LOCKED STATUS TO LOCK RECORD FOR PROCESSING.
       AND TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       and source='BKG'
       order by PK_TOS_LL_DL_BOOKING_SEQ asc
      FOR UPDATE NOWAIT;
      -- FOR UPDATE OF STATUS ;

BEGIN

	 
	 UPDATE VASAPPS.TOS_LL_DL_BOOKING 
		SET STATUS='L'
	 WHERE TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       AND SOURCE='BKG'
	   AND STATUS='P';
	 COMMIT;  
	

     OPEN CUR_TOS_LL_DL_BOOKING;
     --FOR TOS_LL_DL_BKG_PENDING IN CUR_TOS_LL_DL_BOOKING
     LOOP
         FETCH CUR_TOS_LL_DL_BOOKING INTO TOS_LL_DL_BKG_PENDING;
         EXIT WHEN CUR_TOS_LL_DL_BOOKING%NOTFOUND;
         

       V_BOOKING_NO := TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO;
  		 V_BOOKING_TYPE := TOS_LL_DL_BKG_PENDING.BOOKING_TYPE;
  		 V_OLD_BOOKING_STATUS := TOS_LL_DL_BKG_PENDING.OLD_BOOKING_STATUS;
  		 V_NEW_BOOKING_STATUS := TOS_LL_DL_BKG_PENDING.NEW_BOOKING_STATUS;
		   V_SEQ := TOS_LL_DL_BKG_PENDING.PK_TOS_LL_DL_BOOKING_SEQ;

       VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_CREATE_REMOVE_LL_DL(V_BOOKING_NO
																	  ,V_BOOKING_TYPE
																	  ,V_OLD_BOOKING_STATUS
																	  ,V_NEW_BOOKING_STATUS
																	  ,V_RETURN_STATUS); 

         IF V_RETURN_STATUS <> '1' THEN
    			 UPDATE VASAPPS.TOS_LL_DL_BOOKING
    			   SET STATUS='C'
    				  ,RECORD_CHANGE_DATE = SYSDATE
    				  ,RECORD_CHANGE_USER = 'SCHEDULE'
    			 WHERE FK_BOOKING_NO=V_BOOKING_NO 
              AND OLD_BOOKING_STATUS = V_OLD_BOOKING_STATUS
              AND NEW_BOOKING_STATUS = V_NEW_BOOKING_STATUS
              AND PK_TOS_LL_DL_BOOKING_SEQ = V_SEQ;
			 -- COMMIT;

		  ELSE 
			UPDATE VASAPPS.TOS_LL_DL_BOOKING
    			   SET STATUS='E'
    				  ,RECORD_CHANGE_DATE = SYSDATE
    				  ,RECORD_CHANGE_USER = 'SCHEDULE'
    	    WHERE FK_BOOKING_NO=V_BOOKING_NO 
              AND OLD_BOOKING_STATUS = V_OLD_BOOKING_STATUS
              AND NEW_BOOKING_STATUS = V_NEW_BOOKING_STATUS
              AND PK_TOS_LL_DL_BOOKING_SEQ = V_SEQ;
			 -- COMMIT;
			VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BOOKING'
                                                    , '-'
                                                    , 'ERROR AFTER PRE_TOS_CREATE_REMOVE_LL_DL'
													                          , 'V_BOOKING_NO : ' || V_RETURN_STATUS
													                          , 'V_SEQ : ' || V_SEQ 
                                                    , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                    );		  
			
		  END IF;
     
     END LOOP;
     COMMIT;
     CLOSE CUR_TOS_LL_DL_BOOKING;
     
EXCEPTION
    WHEN OTHERS THEN
         UPDATE VASAPPS.TOS_LL_DL_BOOKING
           SET STATUS='E'
              ,ERR_DESC = DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
         WHERE FK_BOOKING_NO=V_BOOKING_NO 
              AND OLD_BOOKING_STATUS = V_OLD_BOOKING_STATUS
              AND NEW_BOOKING_STATUS = V_NEW_BOOKING_STATUS
              AND PK_TOS_LL_DL_BOOKING_SEQ = V_SEQ;         
         --COMMIT;

         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BOOKING'
                                                    , '-'
                                                    , 'PROCESS TO GET PENDING BOOKING AFTER BOOKING STATUS CHANGED.'
                                                    , 'V_SEQ : ' || V_SEQ
                                                    , 'V_BOOKING_NO : '|| V_BOOKING_NO                                                    
                                                    , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                    );      
     
END ;
end PCR_TOS_SYNC_LL_DL_BOOKING;
