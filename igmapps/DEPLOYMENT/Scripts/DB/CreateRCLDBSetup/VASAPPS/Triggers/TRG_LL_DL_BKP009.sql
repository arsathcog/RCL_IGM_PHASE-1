create or replace
trigger VASAPPS.TRG_LL_DL_BKP009
  AFTER INSERT OR UPDATE ON SEALINER.BKP009 
  FOR EACH ROW
  DECLARE

V_BOOKING_NO    varchar2(20); 
V_CNT           INTEGER; 
V_BKP001_STATUS VARCHAR2(1 CHAR);
BEGIN
   
   
     VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGBKP009'
                                                    , '-'
                                                    , 'START'
                                                    , 'OLD MET_WEIGHT|CATEGORY = '||:old.MET_WEIGHT||'|'||:old.EQP_CATEGORY
                                                    ,'EQUIPMENT_NO|bk no. ' || :new.BICTRN||'|'||V_BOOKING_NO
                                                    ,'EQUIPMENT_SEQ ' || :new.BISEQN                                                      
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
   V_BOOKING_NO := :new.BIBKNO;

    
    if (( NVL(:old.MET_WEIGHT,-1) <> NVL(:new.MET_WEIGHT,-1) )
       OR
       ( NVL(:old.EQP_CATEGORY,'X') <> NVL(:new.EQP_CATEGORY,'X')))
        then 

       VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGBKP009'
                                                    , '-'
                                                    , '1.B4 INSERT TO TOS_LL_DL_BOOKING TABLE'
                                                   , 'NEW MET_WEIGHT|CATEGORY = '||:new.MET_WEIGHT||'|'||:new.EQP_CATEGORY
                                                    ,'EQUIPMENT_NO|bk no. ' || :new.BICTRN||'|'||V_BOOKING_NO
                                                    ,'EQUIPMENT_SEQ ' || :new.BISEQN                                                      
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
 
       -- check if already in cod_bl with pending status, then no need to insert into table q.
       select COUNT(*) into V_CNT
       FROM VASAPPS.TOS_LL_DL_BOOKING 
       WHERE FK_BOOKING_NO = V_BOOKING_NO  
         AND NVL(EQUIPMENT_NO,'XXX') = NVL(:new.BICTRN,'XXX')
         AND EQUIPMENT_SEQ = :new.BISEQN
         AND VGM = :new.MET_WEIGHT
         AND CATEGORY_CODE = :new.EQP_CATEGORY
         AND STATUS = 'P'
         AND RECORD_STATUS= 'A';
       
       IF V_CNT = 0 THEN  
       
          INSERT INTO VASAPPS.TOS_LL_DL_BOOKING (PK_TOS_LL_DL_BOOKING_SEQ
                                              ,FK_BOOKING_NO
                                              ,EQUIPMENT_NO
                                              ,EQUIPMENT_SEQ
                                              ,CATEGORY_CODE
                                              ,VGM
                                              ,SOURCE
                                              ,STATUS
                                              ,RECORD_STATUS
                                              ,RECORD_ADD_DATE
                                              ,RECORD_ADD_USER)
                                        values(SR_TOS_LDB01.NEXTVAL
                                              ,V_BOOKING_NO
                                              ,:new.BICTRN
                                              ,:new.BISEQN
                                              ,:new.EQP_CATEGORY
                                              ,:new.MET_WEIGHT
                                              ,'BKG'
                                              ,'P'
                                              ,'A'
                                              ,sysdate
                                              ,'TRGBKP009');
                                   
       
        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGBKP009'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_BOOKING TABLE'
                                                     , 'NEW MET_WEIGHT|CATEGORY = '||:new.MET_WEIGHT||'|'||:new.EQP_CATEGORY
                                                    ,'EQUIPMENT_NO|bk no. ' || :new.BICTRN||'|'||V_BOOKING_NO
                                                    ,'EQUIPMENT_SEQ ' || :new.BISEQN      
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
        END IF; 
   
    END IF;  
EXCEPTION
    WHEN OTHERS THEN
       VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGBKP009'
                                                    , '-'
                                                    , 'INSERT TO TOS_LL_DL_BOOKING TABLE'
                                                     , 'NEW MET_WEIGHT|CATEGORY = '||:new.MET_WEIGHT||'|'||:new.EQP_CATEGORY
                                                    ,'EQUIPMENT_NO|bk no. ' || :new.BICTRN||'|'||V_BOOKING_NO
                                                    ,'EQUIPMENT_SEQ ' || :new.BISEQN                                                      
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
END TRG_LL_DL_BKP009;