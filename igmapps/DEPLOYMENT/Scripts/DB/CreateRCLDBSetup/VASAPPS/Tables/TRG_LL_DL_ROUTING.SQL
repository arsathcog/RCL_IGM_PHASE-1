CREATE OR REPLACE TRIGGER TRG_LL_DL_BKP_ROUTING
  AFTER INSERT OR UPDATE OR DELETE ON SEALINER.BOOKING_VOYAGE_ROUTING_DTL
  FOR EACH ROW
DECLARE
  -- LOCAL VARIABLES HERE
  V_CNT                            INTEGER;



BEGIN

IF INSERTING THEN
   
   IF :NEW.ROUTING_TYPE = 'S' THEN 

   VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKG_ROUTING'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_ROUTING TABLE - INSERT'
                                              , 'BOOKING#: ' || :new.BOOKING_NO
                                              , 'FK_VOYAGE_SEQ_NO: ' || :NEW.VOYAGE_SEQNO
                                              , 'FK_NEW_SERVICE: ' || :NEW.SERVICE ||
                                              ', FK_NEW_VESSEL: ' || :NEW.VESSEL ||
                                              ', FK_NEW_VOYAGE: '|| :NEW.VOYNO ||
                                              ', FK_NEW_DIRECTION: '|| :NEW.DIRECTION ||
                                              ', FK_NEW_LOAD_PORT: '|| :NEW.LOAD_PORT||
                                              ', FK_NEW_PORT_SEQ: '|| :NEW.POL_PCSQ ||
                                              ', FK_NEW_DISCHARGE_PORT: '|| :NEW.DISCHARGE_PORT  
                                              , 'FK_NEW_ACT_SERVICE: '|| :NEW.ACT_SERVICE_CODE ||
                                              ', FK_NEW_ACT_VESSEL: '|| :NEW.ACT_VESSEL_CODE ||
                                              ', FK_NEW_ACT_VOYAGE: '|| :NEW.ACT_VOYAGE_NUMBER ||
                                              ', FK_NEW_ACT_PORT_DIR: '|| :NEW.ACT_PORT_DIRECTION ||
                                              ', FK_NEW_ACT_PORT_SEQ: '|| :NEW.ACT_PORT_SEQUENCE ||
                                              ', FK_NEW_TO_TERMINAL: '|| :NEW.TO_TERMINAL ||
                                              ', FK_NEW_FROM_TERMINAL: '|| :NEW.FROM_TERMINAL
                                              , 'MODE_TYPE: INSERTING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);

   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_ROUTING
	   WHERE FK_BOOKING_NO           = :NEW.BOOKING_NO
       AND FK_VOYAGE_SEQ_NO        = :NEW.VOYAGE_SEQNO
       AND FK_NEW_SERVICE          = :NEW.SERVICE
       AND FK_NEW_VESSEL           = :NEW.VESSEL
       AND FK_NEW_VOYAGE           = :NEW.VOYNO
       AND FK_NEW_DIRECTION        = :NEW.DIRECTION
       AND FK_NEW_LOAD_PORT        = :NEW.LOAD_PORT
       AND FK_NEW_PORT_SEQ         = :NEW.POL_PCSQ
       AND FK_NEW_DISCHARGE_PORT   = :NEW.DISCHARGE_PORT
       AND FK_NEW_ACT_SERVICE      = :NEW.ACT_SERVICE_CODE
       AND FK_NEW_ACT_VESSEL       = :NEW.ACT_VESSEL_CODE
       AND FK_NEW_ACT_VOYAGE       = :NEW.ACT_VOYAGE_NUMBER
       AND FK_NEW_ACT_PORT_DIR     = :NEW.ACT_PORT_DIRECTION
       AND FK_NEW_ACT_PORT_SEQ     = :NEW.ACT_PORT_SEQUENCE
       AND FK_NEW_TO_TERMINAL      = :NEW.TO_TERMINAL
       AND FK_NEW_FROM_TERMINAL    = :NEW.FROM_TERMINAL
       AND SOURCE                  = 'BKGROUT' 
       AND MODE_TYPE               = 'I'
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.	   
		   AND STATUS                  = 'P'
		   AND RECORD_STATUS           = 'A';

    IF V_CNT = 0 THEN

       INSERT INTO VASAPPS.TOS_LL_DL_ROUTING (PK_TOS_LL_DL_RT_SEQ
                                                ,FK_BOOKING_NO
                                                ,FK_VOYAGE_SEQ_NO
                                                ,FK_NEW_SERVICE
                                                ,FK_NEW_VESSEL
                                                ,FK_NEW_VOYAGE
                                                ,FK_NEW_DIRECTION
                                                ,FK_NEW_LOAD_PORT
                                                ,FK_NEW_PORT_SEQ
                                                ,FK_NEW_DISCHARGE_PORT
                                                ,FK_NEW_ACT_SERVICE
                                                ,FK_NEW_ACT_VESSEL
                                                ,FK_NEW_ACT_VOYAGE
                                                ,FK_NEW_ACT_PORT_DIR
                                                ,FK_NEW_ACT_PORT_SEQ
                                                ,FK_NEW_TO_TERMINAL
                                                ,FK_NEW_FROM_TERMINAL
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDR01.NEXTVAL
                                               ,:NEW.BOOKING_NO
                                               ,:NEW.VOYAGE_SEQNO
                                               ,:NEW.SERVICE
                                               ,:NEW.VESSEL
                                               ,:NEW.VOYNO
                                               ,:NEW.DIRECTION
                                               ,:NEW.LOAD_PORT
                                               ,:NEW.POL_PCSQ
                                               ,:NEW.DISCHARGE_PORT
                                               ,:NEW.ACT_SERVICE_CODE
                                               ,:NEW.ACT_VESSEL_CODE
                                               ,:NEW.ACT_VOYAGE_NUMBER
                                               ,:NEW.ACT_PORT_DIRECTION
                                               ,:NEW.ACT_PORT_SEQUENCE
                                               ,:NEW.TO_TERMINAL
                                               ,:NEW.FROM_TERMINAL
                                               ,'I'
                                               ,'BKGROUT'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKGRT'
                                              );

        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKG_ROUTING'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_ROUTING TABLE - INSERT'
                                                    , 'BOOKING#: ' || :new.BOOKING_NO
                                                    , 'FK_VOYAGE_SEQ_NO: ' || :NEW.VOYAGE_SEQNO
                                                    , 'FK_NEW_SERVICE: ' || :NEW.SERVICE ||
                                                    ', FK_NEW_VESSEL: ' || :NEW.VESSEL ||
                                                    ', FK_NEW_VOYAGE: '|| :NEW.VOYNO ||
                                                    ', FK_NEW_DIRECTION: '|| :NEW.DIRECTION ||
                                                    ', FK_NEW_LOAD_PORT: '|| :NEW.LOAD_PORT||
                                                    ', FK_NEW_PORT_SEQ: '|| :NEW.POL_PCSQ ||
                                                    ', FK_NEW_DISCHARGE_PORT: '|| :NEW.DISCHARGE_PORT  
                                                    , 'FK_NEW_ACT_SERVICE: '|| :NEW.ACT_SERVICE_CODE ||
                                                    ', FK_NEW_ACT_VESSEL: '|| :NEW.ACT_VESSEL_CODE ||
                                                    ', FK_NEW_ACT_VOYAGE: '|| :NEW.ACT_VOYAGE_NUMBER ||
                                                    ', FK_NEW_ACT_PORT_DIR: '|| :NEW.ACT_PORT_DIRECTION ||
                                                    ', FK_NEW_ACT_PORT_SEQ: '|| :NEW.ACT_PORT_SEQUENCE ||
                                                    ', FK_NEW_TO_TERMINAL: '|| :NEW.TO_TERMINAL ||
                                                    ', FK_NEW_FROM_TERMINAL: '|| :NEW.FROM_TERMINAL
                                                    , 'MODE_TYPE: INSERTING '
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);


    END IF ;
    END IF; -- CHECKING ROUTING_TYPE
END IF;

IF DELETING THEN

     IF :OLD.ROUTING_TYPE = 'S' THEN 
   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_ROUTING
	   WHERE FK_BOOKING_NO           = :OLD.BOOKING_NO
       AND FK_VOYAGE_SEQ_NO        = :OLD.VOYAGE_SEQNO
       AND FK_OLD_SERVICE          = :OLD.SERVICE
       AND FK_OLD_VESSEL           = :OLD.VESSEL
       AND FK_OLD_VOYAGE           = :OLD.VOYNO
       AND FK_OLD_DIRECTION        = :OLD.DIRECTION
       AND FK_OLD_LOAD_PORT        = :OLD.LOAD_PORT
       AND FK_OLD_PORT_SEQ         = :OLD.POL_PCSQ
       AND FK_OLD_DISCHARGE_PORT   = :OLD.DISCHARGE_PORT
       AND FK_OLD_ACT_SERVICE      = :OLD.ACT_SERVICE_CODE
       AND FK_OLD_ACT_VESSEL       = :OLD.ACT_VESSEL_CODE
       AND FK_OLD_ACT_VOYAGE       = :OLD.ACT_VOYAGE_NUMBER
       AND FK_OLD_ACT_PORT_DIR     = :OLD.ACT_PORT_DIRECTION
       AND FK_OLD_ACT_PORT_SEQ     = :OLD.ACT_PORT_SEQUENCE
       AND FK_OLD_TO_TERMINAL      = :OLD.TO_TERMINAL
       AND FK_OLD_FROM_TERMINAL    = :OLD.FROM_TERMINAL
       AND SOURCE                  = 'BKGROUT' 
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.	   
       AND MODE_TYPE               = 'D'
		   AND STATUS                  = 'P'
		   AND RECORD_STATUS           = 'A';


   VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKG_ROUTING'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_ROUTING TABLE - INSERT'
                                              , 'BOOKING#: ' || :OLD.BOOKING_NO
                                              , 'FK_VOYAGE_SEQ_NO: ' || :OLD.VOYAGE_SEQNO
                                              , 'FK_OLD_SERVICE: ' || :OLD.SERVICE || 
                                              ', FK_OLD_VESSEL: ' || :OLD.VESSEL || 
                                              ', FK_OLD_VOYAGE: '|| :OLD.VOYNO || 
                                              ', FK_OLD_DIRECTION: '|| :OLD.DIRECTION || 
                                              ', FK_OLD_LOAD_PORT: '|| :OLD.LOAD_PORT || 
                                              ', FK_OLD_PORT_SEQ: '|| :OLD.POL_PCSQ || 
                                              ', FK_OLD_DISCHARGE_PORT: '|| :OLD.DISCHARGE_PORT 
                                              , 'FK_OLD_ACT_SERVICE: '|| :OLD.ACT_SERVICE_CODE || 
                                              ', FK_OLD_ACT_VESSEL: '|| :OLD.ACT_VESSEL_CODE ||
                                              ', FK_OLD_ACT_VOYAGE: '|| :OLD.ACT_VOYAGE_NUMBER || 
                                              ', FK_OLD_ACT_PORT_DIR: '|| :OLD.ACT_PORT_DIRECTION ||
                                              ', FK_OLD_ACT_PORT_SEQ: '|| :OLD.ACT_PORT_SEQUENCE ||
                                              ', FK_OLD_TO_TERMINAL: '|| :OLD.TO_TERMINAL || 
                                              ', FK_OLD_FROM_TERMINAL: '|| :OLD.FROM_TERMINAL 
                                              , 'MODE_TYPE: INSERTING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
    IF V_CNT = 0 THEN

       INSERT INTO VASAPPS.TOS_LL_DL_ROUTING (PK_TOS_LL_DL_RT_SEQ
                                                ,FK_BOOKING_NO
                                                ,FK_VOYAGE_SEQ_NO
                                                ,FK_OLD_SERVICE
                                                ,FK_OLD_VESSEL
                                                ,FK_OLD_VOYAGE
                                                ,FK_OLD_DIRECTION
                                                ,FK_OLD_LOAD_PORT
                                                ,FK_OLD_PORT_SEQ
                                                ,FK_OLD_DISCHARGE_PORT
                                                ,FK_OLD_ACT_SERVICE
                                                ,FK_OLD_ACT_VESSEL
                                                ,FK_OLD_ACT_VOYAGE
                                                ,FK_OLD_ACT_PORT_DIR
                                                ,FK_OLD_ACT_PORT_SEQ
                                                ,FK_OLD_TO_TERMINAL
                                                ,FK_OLD_FROM_TERMINAL
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDR01.NEXTVAL
                                               ,:OLD.BOOKING_NO
                                               ,:OLD.VOYAGE_SEQNO
                                               ,:OLD.SERVICE
                                               ,:OLD.VESSEL
                                               ,:OLD.VOYNO
                                               ,:OLD.DIRECTION
                                               ,:OLD.LOAD_PORT
                                               ,:OLD.POL_PCSQ
                                               ,:OLD.DISCHARGE_PORT
                                               ,:OLD.ACT_SERVICE_CODE
                                               ,:OLD.ACT_VESSEL_CODE
                                               ,:OLD.ACT_VOYAGE_NUMBER
                                               ,:OLD.ACT_PORT_DIRECTION
                                               ,:OLD.ACT_PORT_SEQUENCE
                                               ,:OLD.TO_TERMINAL
                                               ,:OLD.FROM_TERMINAL
                                               ,'D'
                                               ,'BKGROUT'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKGRT'
                                              );


        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKG_ROUTING'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_ROUTING TABLE - INSERT'
                                                    , 'BOOKING#: ' || :OLD.BOOKING_NO
                                                    , 'FK_VOYAGE_SEQ_NO: ' || :OLD.VOYAGE_SEQNO
                                                    , 'FK_OLD_SERVICE: ' || :OLD.SERVICE || 
                                                    ', FK_OLD_VESSEL: ' || :OLD.VESSEL || 
                                                    ', FK_OLD_VOYAGE: '|| :OLD.VOYNO || 
                                                    ', FK_OLD_DIRECTION: '|| :OLD.DIRECTION || 
                                                    ', FK_OLD_LOAD_PORT: '|| :OLD.LOAD_PORT || 
                                                    ', FK_OLD_PORT_SEQ: '|| :OLD.POL_PCSQ || 
                                                    ', FK_OLD_DISCHARGE_PORT: '|| :OLD.DISCHARGE_PORT 
                                                    , 'FK_OLD_ACT_SERVICE: '|| :OLD.ACT_SERVICE_CODE || 
                                                    ', FK_OLD_ACT_VESSEL: '|| :OLD.ACT_VESSEL_CODE ||
                                                    ', FK_OLD_ACT_VOYAGE: '|| :OLD.ACT_VOYAGE_NUMBER || 
                                                    ', FK_OLD_ACT_PORT_DIR: '|| :OLD.ACT_PORT_DIRECTION ||
                                                    ', FK_OLD_ACT_PORT_SEQ: '|| :OLD.ACT_PORT_SEQUENCE ||
                                                    ', FK_OLD_TO_TERMINAL: '|| :OLD.TO_TERMINAL || 
                                                    ', FK_OLD_FROM_TERMINAL: '|| :OLD.FROM_TERMINAL 
                                                    , 'MODE_TYPE: INSERTING '
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
         END IF;
   END IF ; -- END CHECKING FOR ROUTING_TYPE 

END IF ;
IF UPDATING THEN


   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_ROUTING
	   WHERE FK_BOOKING_NO           = :NEW.BOOKING_NO
       AND FK_VOYAGE_SEQ_NO        = :NEW.VOYAGE_SEQNO
       AND FK_NEW_SERVICE          = :NEW.SERVICE
       AND FK_NEW_VESSEL           = :NEW.VESSEL
       AND FK_NEW_VOYAGE           = :NEW.VOYNO
       AND FK_NEW_DIRECTION        = :NEW.DIRECTION
       AND FK_NEW_LOAD_PORT        = :NEW.LOAD_PORT
       AND FK_NEW_PORT_SEQ         = :NEW.POL_PCSQ
       AND FK_NEW_DISCHARGE_PORT   = :NEW.DISCHARGE_PORT
       AND FK_NEW_ACT_SERVICE      = :NEW.ACT_SERVICE_CODE
       AND FK_NEW_ACT_VESSEL       = :NEW.ACT_VESSEL_CODE
       AND FK_NEW_ACT_VOYAGE       = :NEW.ACT_VOYAGE_NUMBER
       AND FK_NEW_ACT_PORT_DIR     = :NEW.ACT_PORT_DIRECTION
       AND FK_NEW_ACT_PORT_SEQ     = :NEW.ACT_PORT_SEQUENCE
       AND FK_NEW_TO_TERMINAL      = :NEW.TO_TERMINAL
       AND FK_NEW_FROM_TERMINAL    = :NEW.FROM_TERMINAL
       AND FK_OLD_SERVICE          = :OLD.SERVICE
       AND FK_OLD_VESSEL           = :OLD.VESSEL
       AND FK_OLD_VOYAGE           = :OLD.VOYNO
       AND FK_OLD_DIRECTION        = :OLD.DIRECTION
       AND FK_OLD_LOAD_PORT        = :OLD.LOAD_PORT
       AND FK_OLD_PORT_SEQ         = :OLD.POL_PCSQ
       AND FK_OLD_DISCHARGE_PORT   = :OLD.DISCHARGE_PORT
       AND FK_OLD_ACT_SERVICE      = :OLD.ACT_SERVICE_CODE
       AND FK_OLD_ACT_VESSEL       = :OLD.ACT_VESSEL_CODE
       AND FK_OLD_ACT_VOYAGE       = :OLD.ACT_VOYAGE_NUMBER
       AND FK_OLD_ACT_PORT_DIR     = :OLD.ACT_PORT_DIRECTION
       AND FK_OLD_ACT_PORT_SEQ     = :OLD.ACT_PORT_SEQUENCE
       AND FK_OLD_TO_TERMINAL      = :OLD.TO_TERMINAL
       AND FK_OLD_FROM_TERMINAL    = :OLD.FROM_TERMINAL       
       AND SOURCE                  = 'BKGROUT' 
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.	   
       AND MODE_TYPE               = 'U'
		   AND STATUS                  = 'P'
		   AND RECORD_STATUS           = 'A';

   VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP_ROUTING'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_ROUTING TABLE - INSERT'
                                              , 'BOOKING#: ' || :new.BOOKING_NO
                                              , 'FK_VOYAGE_SEQ_NO: ' || :NEW.VOYAGE_SEQNO
                                              , 'FK_NEW_SERVICE: ' || :NEW.SERVICE ||
                                              ', FK_NEW_VESSEL: ' || :NEW.VESSEL ||
                                              ', FK_NEW_VOYAGE: '|| :NEW.VOYNO ||
                                              ', FK_NEW_DIRECTION: '|| :NEW.DIRECTION ||
                                              ', FK_NEW_LOAD_PORT: '|| :NEW.LOAD_PORT||
                                              ', FK_NEW_PORT_SEQ: '|| :NEW.POL_PCSQ ||
                                              ', FK_NEW_DISCHARGE_PORT: '|| :NEW.DISCHARGE_PORT || 
                                              ', FK_NEW_ACT_SERVICE: '|| :NEW.ACT_SERVICE_CODE ||
                                              ', FK_NEW_ACT_VESSEL: '|| :NEW.ACT_VESSEL_CODE ||
                                              ', FK_NEW_ACT_VOYAGE: '|| :NEW.ACT_VOYAGE_NUMBER ||
                                              ', FK_NEW_ACT_PORT_DIR: '|| :NEW.ACT_PORT_DIRECTION ||
                                              ', FK_NEW_ACT_PORT_SEQ: '|| :NEW.ACT_PORT_SEQUENCE ||
                                              ', FK_NEW_TO_TERMINAL: '|| :NEW.TO_TERMINAL ||
                                              ', FK_NEW_FROM_TERMINAL: '|| :NEW.FROM_TERMINAL
                                              , 'FK_OLD_SERVICE: ' || :OLD.SERVICE || 
                                              ', FK_OLD_VESSEL: ' || :OLD.VESSEL || 
                                              ', FK_OLD_VOYAGE: '|| :OLD.VOYNO || 
                                              ', FK_OLD_DIRECTION: '|| :OLD.DIRECTION || 
                                              ', FK_OLD_LOAD_PORT: '|| :OLD.LOAD_PORT || 
                                              ', FK_OLD_PORT_SEQ: '|| :OLD.POL_PCSQ || 
                                              ', FK_OLD_DISCHARGE_PORT: '|| :OLD.DISCHARGE_PORT ||
                                              ', FK_OLD_ACT_SERVICE: '|| :OLD.ACT_SERVICE_CODE || 
                                              ', FK_OLD_ACT_VESSEL: '|| :OLD.ACT_VESSEL_CODE ||
                                              ', FK_OLD_ACT_VOYAGE: '|| :OLD.ACT_VOYAGE_NUMBER || 
                                              ', FK_OLD_ACT_PORT_DIR: '|| :OLD.ACT_PORT_DIRECTION ||
                                              ', FK_OLD_ACT_PORT_SEQ: '|| :OLD.ACT_PORT_SEQUENCE ||
                                              ', FK_OLD_TO_TERMINAL: '|| :OLD.TO_TERMINAL || 
                                              ', FK_OLD_FROM_TERMINAL: '|| :OLD.FROM_TERMINAL 
                                              , 'MODE_TYPE: INSERTING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);                                              
   IF V_CNT = 0 THEN

       INSERT INTO VASAPPS.TOS_LL_DL_ROUTING (PK_TOS_LL_DL_RT_SEQ
                                                ,FK_BOOKING_NO
                                                ,FK_VOYAGE_SEQ_NO
                                                ,FK_NEW_SERVICE
                                                ,FK_NEW_VESSEL
                                                ,FK_NEW_VOYAGE
                                                ,FK_NEW_DIRECTION
                                                ,FK_NEW_LOAD_PORT
                                                ,FK_NEW_PORT_SEQ
                                                ,FK_NEW_DISCHARGE_PORT
                                                ,FK_NEW_ACT_SERVICE
                                                ,FK_NEW_ACT_VESSEL
                                                ,FK_NEW_ACT_VOYAGE
                                                ,FK_NEW_ACT_PORT_DIR
                                                ,FK_NEW_ACT_PORT_SEQ
                                                ,FK_NEW_TO_TERMINAL
                                                ,FK_NEW_FROM_TERMINAL
                                                ,FK_OLD_SERVICE
                                                ,FK_OLD_VESSEL
                                                ,FK_OLD_VOYAGE
                                                ,FK_OLD_DIRECTION
                                                ,FK_OLD_LOAD_PORT
                                                ,FK_OLD_PORT_SEQ
                                                ,FK_OLD_DISCHARGE_PORT
                                                ,FK_OLD_ACT_SERVICE
                                                ,FK_OLD_ACT_VESSEL
                                                ,FK_OLD_ACT_VOYAGE
                                                ,FK_OLD_ACT_PORT_DIR
                                                ,FK_OLD_ACT_PORT_SEQ
                                                ,FK_OLD_TO_TERMINAL
                                                ,FK_OLD_FROM_TERMINAL                                                
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDR01.NEXTVAL
                                               ,:NEW.BOOKING_NO
                                               ,:NEW.VOYAGE_SEQNO
                                               ,:NEW.SERVICE
                                               ,:NEW.VESSEL
                                               ,:NEW.VOYNO
                                               ,:NEW.DIRECTION
                                               ,:NEW.LOAD_PORT
                                               ,:NEW.POL_PCSQ
                                               ,:NEW.DISCHARGE_PORT
                                               ,:NEW.ACT_SERVICE_CODE
                                               ,:NEW.ACT_VESSEL_CODE
                                               ,:NEW.ACT_VOYAGE_NUMBER
                                               ,:NEW.ACT_PORT_DIRECTION
                                               ,:NEW.ACT_PORT_SEQUENCE
                                               ,:NEW.TO_TERMINAL
                                               ,:NEW.FROM_TERMINAL
                                               ,:OLD.SERVICE
                                               ,:OLD.VESSEL
                                               ,:OLD.VOYNO
                                               ,:OLD.DIRECTION
                                               ,:OLD.LOAD_PORT
                                               ,:OLD.POL_PCSQ
                                               ,:OLD.DISCHARGE_PORT
                                               ,:OLD.ACT_SERVICE_CODE
                                               ,:OLD.ACT_VESSEL_CODE
                                               ,:OLD.ACT_VOYAGE_NUMBER
                                               ,:OLD.ACT_PORT_DIRECTION
                                               ,:OLD.ACT_PORT_SEQUENCE
                                               ,:OLD.TO_TERMINAL
                                               ,:OLD.FROM_TERMINAL                                               
                                               ,'U'
                                               ,'BKGROUT'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKGRT'
                                              );
                                              
   VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP_ROUTING'
                                              , '-'
                                              , '2.AFTER INSERT TO TOS_LL_DL_ROUTING TABLE - INSERT'
                                              , 'BOOKING#: ' || :new.BOOKING_NO
                                              , 'FK_VOYAGE_SEQ_NO: ' || :NEW.VOYAGE_SEQNO
                                              , 'FK_NEW_SERVICE: ' || :NEW.SERVICE ||
                                              ', FK_NEW_VESSEL: ' || :NEW.VESSEL ||
                                              ', FK_NEW_VOYAGE: '|| :NEW.VOYNO ||
                                              ', FK_NEW_DIRECTION: '|| :NEW.DIRECTION ||
                                              ', FK_NEW_LOAD_PORT: '|| :NEW.LOAD_PORT||
                                              ', FK_NEW_PORT_SEQ: '|| :NEW.POL_PCSQ ||
                                              ', FK_NEW_DISCHARGE_PORT: '|| :NEW.DISCHARGE_PORT || 
                                              ', FK_NEW_ACT_SERVICE: '|| :NEW.ACT_SERVICE_CODE ||
                                              ', FK_NEW_ACT_VESSEL: '|| :NEW.ACT_VESSEL_CODE ||
                                              ', FK_NEW_ACT_VOYAGE: '|| :NEW.ACT_VOYAGE_NUMBER ||
                                              ', FK_NEW_ACT_PORT_DIR: '|| :NEW.ACT_PORT_DIRECTION ||
                                              ', FK_NEW_ACT_PORT_SEQ: '|| :NEW.ACT_PORT_SEQUENCE ||
                                              ', FK_NEW_TO_TERMINAL: '|| :NEW.TO_TERMINAL ||
                                              ', FK_NEW_FROM_TERMINAL: '|| :NEW.FROM_TERMINAL
                                              , 'FK_OLD_SERVICE: ' || :OLD.SERVICE || 
                                              ', FK_OLD_VESSEL: ' || :OLD.VESSEL || 
                                              ', FK_OLD_VOYAGE: '|| :OLD.VOYNO || 
                                              ', FK_OLD_DIRECTION: '|| :OLD.DIRECTION || 
                                              ', FK_OLD_LOAD_PORT: '|| :OLD.LOAD_PORT || 
                                              ', FK_OLD_PORT_SEQ: '|| :OLD.POL_PCSQ || 
                                              ', FK_OLD_DISCHARGE_PORT: '|| :OLD.DISCHARGE_PORT ||
                                              ', FK_OLD_ACT_SERVICE: '|| :OLD.ACT_SERVICE_CODE || 
                                              ', FK_OLD_ACT_VESSEL: '|| :OLD.ACT_VESSEL_CODE ||
                                              ', FK_OLD_ACT_VOYAGE: '|| :OLD.ACT_VOYAGE_NUMBER || 
                                              ', FK_OLD_ACT_PORT_DIR: '|| :OLD.ACT_PORT_DIRECTION ||
                                              ', FK_OLD_ACT_PORT_SEQ: '|| :OLD.ACT_PORT_SEQUENCE ||
                                              ', FK_OLD_TO_TERMINAL: '|| :OLD.TO_TERMINAL || 
                                              ', FK_OLD_FROM_TERMINAL: '|| :OLD.FROM_TERMINAL 
                                              , 'MODE_TYPE: INSERTING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);   

   END IF;


END IF;

END TRG_LL_DL_BKP_ROUTING;
