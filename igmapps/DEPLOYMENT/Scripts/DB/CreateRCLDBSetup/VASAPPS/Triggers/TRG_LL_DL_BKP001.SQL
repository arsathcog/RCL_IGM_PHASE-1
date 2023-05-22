create or replace trigger VASAPPS.TRG_LL_DL_BKP001
  AFTER INSERT OR UPDATE ON SEALINER.BKP001  
  FOR EACH ROW
DECLARE

V_BOOKING_NO    varchar2(20); 
V_CNT           INTEGER; 
BEGIN

    if  (:old.BASTAT IN ('L','P','C') AND :new.BASTAT  NOT IN ('L','P','C')) OR 
		(:old.BASTAT NOT IN ('L','P','C') AND :new.BASTAT  IN ('L','P','C')) then 
       
       V_BOOKING_NO := :NEW.BABKNO;

       
       VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP001'
                                                    , '-'
                                                    , '1.B4 INSERT TO TOS_LL_DL_BOOKING TABLE'
                                                    , :new.BABKNO
                                                    ,'OLD BOOKING STATUS ' || :old.BASTAT
                                                    ,'NEW BOOKING STATUS ' || :new.BASTAT                                                    
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
                                                    
       --VASAPPS.PRR_COD_CHECK(V_BLNO);
	   
	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   select COUNT(*) into V_CNT
	   FROM VASAPPS.TOS_LL_DL_BOOKING 
	   WHERE FK_BOOKING_NO = V_BOOKING_NO  
	     AND OLD_BOOKING_STATUS = :old.BASTAT
		 AND NEW_BOOKING_STATUS = :new.BASTAT
		 AND STATUS = 'P'
		 AND RECORD_STATUS= 'A';
	   
	   IF V_CNT = 0 THEN  
	   
	      INSERT INTO VASAPPS.TOS_LL_DL_BOOKING (PK_TOS_LL_DL_BOOKING_SEQ
                                              ,FK_BOOKING_NO
                                              ,BOOKING_TYPE
                                              ,OLD_BOOKING_STATUS
                                              ,NEW_BOOKING_STATUS
                                              ,SOURCE
                                              ,STATUS
                                              ,RECORD_STATUS
                                              ,RECORD_ADD_DATE
                                              ,RECORD_ADD_USER)
                                        values(SR_TOS_LDB01.NEXTVAL
                                              ,V_BOOKING_NO
                                              ,:new.BOOKING_TYPE
                                              ,:old.BASTAT
                                              ,:new.BASTAT
                                              ,'BKG'
                                              ,'P'
                                              ,'A'
                                              ,sysdate
                                              ,'LL_DL');
								   
       
        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP001'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_BOOKING TABLE'
                                                    , V_BOOKING_NO
                                                    ,'OLD BOOKING STATUS ' || :old.BASTAT
                                                    ,'NEW BOOKING STATUS ' || :new.BASTAT
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
		END IF; 
   
    END IF;  
EXCEPTION
    WHEN OTHERS THEN
        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP001'
                                                    , '-'
                                                    , 'ERROR TRG_LL_DL_BKP001'
                                                    , V_BOOKING_NO
                                                    ,'OLD BOOKING STATUS ' || :old.BASTAT
                                                    ,'NEW BOOKING STATUS ' || :new.BASTAT                                                    
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
END TRG_LL_DL_BKP001;
/

