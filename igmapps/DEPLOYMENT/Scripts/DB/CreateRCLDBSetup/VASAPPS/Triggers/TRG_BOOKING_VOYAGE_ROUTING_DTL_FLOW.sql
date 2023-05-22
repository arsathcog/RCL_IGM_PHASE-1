CREATE OR REPLACE TRIGGER VASAPPS.TRG_BOOK_VOY_ROUTING_DTL_FLOW
AFTER INSERT OR UPDATE ON SEALINER.BOOKING_VOYAGE_ROUTING_DTL  
FOR EACH ROW
DECLARE

V_BOOKING_NO    varchar2(20); 
V_CNT           INTEGER; 
V_CNT2           INTEGER; 
  TYPE BKP009_RECORD IS RECORD (
            BIBKNO BKP009.BIBKNO%TYPE
            ,BICTRN BKP009.BICTRN%TYPE
            ,BISEQN BKP009.BISEQN%TYPE
            ,EQP_CATEGORY BKP009.EQP_CATEGORY%TYPE
            ,MET_WEIGHT BKP009.MET_WEIGHT%TYPE
        );
        CUR_009_ROW BKP009_RECORD;
CURSOR CUR_BKP009 IS
SELECT BIBKNO,BICTRN,BISEQN,EQP_CATEGORY,MET_WEIGHT 
FROM BKP009 
WHERE BIBKNO = :NEW.BOOKING_NO
 ORDER BY BISEQN;
BEGIN

     VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('ROUTING'
                                                    , 'START'
                                                    , 'NEW >>: '||:new.SERVICE||'/'||:new.VESSEL||'/'||:new.VOYNO||'/'||:new.DIRECTION||'/'||:new.LOAD_PORT||'/'||:new.POL_PCSQ||'/'
                                                                      ||:new.DISCHARGE_PORT||'/'||:new.ACT_SERVICE_CODE||'/'||:new.ACT_VESSEL_CODE||'/'||:new.ACT_VOYAGE_NUMBER||'/'
                                                                      ||:new.ACT_PORT_DIRECTION||'/'||:new.ACT_PORT_SEQUENCE||'/'||:new.TO_TERMINAL||'/'||:new.ROUTING_TYPE||'/'||:new.FROM_TERMINAL
                                                    ,' OLD >> :' ||:old.SERVICE||'/'||:old.VESSEL||'/'||:old.VOYNO||'/'||:old.DIRECTION||'/'||:old.LOAD_PORT||'/'||:old.POL_PCSQ||'/'
                                                                      ||:old.DISCHARGE_PORT||'/'||:old.ACT_SERVICE_CODE||'/'||:old.ACT_VESSEL_CODE||'/'||:old.ACT_VOYAGE_NUMBER||'/'
                                                                      ||:old.ACT_PORT_DIRECTION||'/'||:old.ACT_PORT_SEQUENCE||'/'||:old.TO_TERMINAL||'/'||:old.ROUTING_TYPE||'/'||:old.FROM_TERMINAL
                                                    ,''   
                                                     , 'BK NO: '||:NEW.BOOKING_NO                                 
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);

    if   ( NVL(:new.SERVICE,'X') <> NVL(:old.SERVICE,'X') OR
        NVL(:new.VESSEL,'X') <> NVL(:old.VESSEL,'X') OR
        NVL(:new.VOYNO,'X') <>  NVL(:old.VOYNO,'X') OR
        NVL(:new.DIRECTION,'Z') <>  NVL(:old.DIRECTION,'Z') OR
        NVL(:new.LOAD_PORT,'X') <>  NVL(:old.LOAD_PORT,'X') OR
        NVL(:new.POL_PCSQ,-1) <> NVL(:old.POL_PCSQ,-1) OR
        NVL(:new.DISCHARGE_PORT,'X') <>  NVL(:old.DISCHARGE_PORT,'X') OR
        NVL(:new.ACT_SERVICE_CODE,'X') <>  NVL(:old.ACT_SERVICE_CODE,'X') OR
        NVL(:new.ACT_VESSEL_CODE,'X') <> NVL(:old.ACT_VESSEL_CODE,'X') OR
        NVL(:new.ACT_VOYAGE_NUMBER,'X') <> NVL(:old.ACT_VOYAGE_NUMBER,'X') OR
        NVL(:new.ACT_PORT_DIRECTION,'X') <>  NVL(:old.ACT_PORT_DIRECTION,'X') OR
        NVL(:new.ACT_PORT_SEQUENCE,-1) <>  NVL(:old.ACT_PORT_SEQUENCE,-1) OR
        NVL(:new.TO_TERMINAL,'X') <> NVL(:old.TO_TERMINAL,'X') OR
        NVL(:new.ROUTING_TYPE,'X') <>  NVL(:old.ROUTING_TYPE,'X') OR
        NVL(:new.FROM_TERMINAL,'X') <> NVL(:old.FROM_TERMINAL,'X')  )
    
    then 
       
       V_BOOKING_NO := :NEW.BOOKING_NO;

       
       VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGRT001'
                                                    , '-'
                                                    , '1.B4 INSERT TO TOS_LL_DL_BOOKING TABLE'
                                                    , V_BOOKING_NO
                                                   ,'',''                                                    
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);

       -- check if already in cod_bl with pending status, then no need to insert into table q.
       select COUNT(*) into V_CNT
       FROM VASAPPS.TOS_LL_DL_BOOKING 
       WHERE FK_BOOKING_NO = V_BOOKING_NO  
              AND SEA_LEG_PORT = :new.LOAD_PORT
         AND FK_SERVICE = :new.SERVICE
         AND FK_VESSEL = :new.VESSEL
         AND FK_VOYAGE = :new.VOYNO
         AND FK_DIRECTION = :new.DIRECTION
         AND FK_PORT_SEQ = :new.POL_PCSQ
         AND STATUS = 'P'
         AND RECORD_STATUS= 'A';
       
       IF V_CNT = 0 THEN  
          --1) For stamp First leg flag 
          BEGIN
          INSERT INTO VASAPPS.TOS_LL_DL_BOOKING (PK_TOS_LL_DL_BOOKING_SEQ
                                              ,FK_BOOKING_NO
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
                                              --for stamp first leg begin
                                              ,:new.LOAD_PORT
                                             , :new.SERVICE
                                             , :new.VESSEL
                                             , :new.VOYNO
                                            , :new.DIRECTION
                                            ,:new.POL_PCSQ
                                              -- for stamp first leg end
                                              ,'BKG'
                                              ,'P'
                                              ,'A'
                                              ,sysdate
                                              ,'TRGRT001');
                                   
          END;
        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGRT001'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_BOOKING TABLE (STAMP FLAG)'
                                                    , V_BOOKING_NO
                                                    ,''
                                                    ,''
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
          --2) For flow data (vgm and category) from booking to ezll/ezdl
          
          OPEN CUR_BKP009;
           LOOP
             FETCH CUR_BKP009 INTO CUR_009_ROW;
             EXIT WHEN CUR_BKP009%NOTFOUND;
             
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
                                              SELECT SR_TOS_LDB01.NEXTVAL ,
                                              CUR_009_ROW.BIBKNO,
                                              CUR_009_ROW.BICTRN,
                                              CUR_009_ROW.BISEQN,
                                              CUR_009_ROW.EQP_CATEGORY,
                                              CUR_009_ROW.MET_WEIGHT,
                                              'BKG',
                                              'P',
                                              'A',
                                              sysdate,
                                              'TRGRT009'
                                              FROM DUAL;
             
          END LOOP;
          CLOSE CUR_BKP009;
          
          VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRGRT009'
                                                    , '-'
                                                    , '3.AFTER INSERT INTO TOS_LL_DL_BOOKING TABLE (STAMP VGM AND CATEGORY)'
                                                    , V_BOOKING_NO
                                                    ,''
                                                    ,''
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
          
        END IF; 
   
      
       
    END IF;  
EXCEPTION
    WHEN OTHERS THEN
        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('ROUTING'
                                                    , '-'
                                                    , 'ERROR TRG_LL_DL_BKP001'
                                                    , V_BOOKING_NO
                                                    ,''
                                                    ,''                                    
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
END TRG_BOOK_VOY_ROUTING_DTL_FLOW;
/

