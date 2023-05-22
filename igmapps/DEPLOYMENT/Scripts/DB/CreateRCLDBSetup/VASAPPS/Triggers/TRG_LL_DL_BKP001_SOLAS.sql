create or replace trigger VASAPPS.TRG_LL_DL_BKP001
  AFTER INSERT OR UPDATE ON SEALINER.BKP001  
  FOR EACH ROW
DECLARE

V_BOOKING_NO    varchar2(20); 
V_CNT           INTEGER; 
BEGIN

    if     :old.BASTAT NOT IN ('L','P','C') AND :new.BASTAT  IN ('L','P','C') then 
       
       V_BOOKING_NO := :NEW.BABKNO;

       
       VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGBKP001'
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
         AND SEA_LEG_PORT = :new.BAPOL
         AND FK_SERVICE = :new.BASRVC
         AND FK_VESSEL = :new.BAVESS
         AND FK_VOYAGE = :new.BAVOY
         AND FK_DIRECTION = :new.DIRECTION
         AND FK_PORT_SEQ = :new.POL_PCSQ
         AND STATUS = 'P'
         AND RECORD_STATUS= 'A';
       
       IF V_CNT = 0 THEN  
       
          INSERT INTO VASAPPS.TOS_LL_DL_BOOKING (PK_TOS_LL_DL_BOOKING_SEQ
                                              ,FK_BOOKING_NO
                                              ,BOOKING_TYPE
                                              ,OLD_BOOKING_STATUS
                                              ,NEW_BOOKING_STATUS
                                               --for stamp first leg begin
                                              ,SEA_LEG_PORT
                                              ,FK_SERVICE
                                              ,FK_VESSEL
                                              ,FK_VOYAGE
                                              ,FK_DIRECTION
                                              ,FK_PORT_SEQ
                                              -- for stamp first leg end
                                              ,SOURCE
                                              ,STATUS
                                              ,RECORD_STATUS
                                              ,RECORD_ADD_DATE
                                              ,RECORD_ADD_USER
                                             
                                              )
                                        values(SR_TOS_LDB01.NEXTVAL 
                                              ,V_BOOKING_NO
                                              ,:new.BOOKING_TYPE
                                              ,:old.BASTAT
                                              ,:new.BASTAT
                                              --for stamp first leg begin
                                              ,:new.BAPOL
                                              ,:new.BASRVC
                                              ,:new.BAVESS
                                              ,:new.BAVOY
                                              ,:new.DIRECTION
                                              ,:new.POL_PCSQ
                                              -- for stamp first leg end
                                              ,'BKG'
                                              ,'P'
                                              ,'A'
                                              ,sysdate
                                              ,'TRGBKP001');
                                   
       
        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGBKP001'
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
        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGBKP001'
                                                    , '-'
                                                    , 'ERROR TRG_LL_DL_BKP001'
                                                    , V_BOOKING_NO
                                                    ,'OLD BOOKING STATUS ' || :old.BASTAT
                                                    ,'NEW BOOKING STATUS ' || :new.BASTAT                                                    
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
END TRG_LL_DL_BKP001;
/

