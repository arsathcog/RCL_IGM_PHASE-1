CREATE OR REPLACE TRIGGER TRG_LL_DL_BKP_DG_DTL
  AFTER INSERT OR UPDATE OR DELETE ON SEALINER.BOOKING_DG_COMM_DETAIL
  FOR EACH ROW
DECLARE
  -- LOCAL VARIABLES HERE
  V_CNT                            INTEGER;



BEGIN

IF INSERTING THEN


   VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP_DG_DTL'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_CONTAINERS TABLE - INSERT'
                                              , 'BOOKING#: ' || :new.BOOKING_NO
                                              , 'IMO_CLASS: ' || :NEW.IMO_CLASS
                                              , 'UN_NO: ' || :NEW.UN_NO
                                              , 'FUMIGATION_YN: ' || :NEW.FUMIGATION_YN
                                              , 'RESIDUE: '|| :NEW.RESIDUE
                                              , 'MODE_TYPE: INSERTING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);

   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_CONTAINERS
	   WHERE FK_BOOKING_NO = :NEW.BOOKING_NO
	     AND IMO_CLASS = :NEW.IMO_CLASS
		   AND UNNO = :NEW.UN_NO
       AND FUMIGATION_YN = :NEW.FUMIGATION_YN
       AND RESIDUE = :NEW.RESIDUE
       AND SOURCE = 'BKGDGDTL'
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.	   
       AND MODE_TYPE = 'I'
		   AND STATUS = 'P'
		   AND RECORD_STATUS= 'A';

    IF V_CNT = 0 THEN

       INSERT INTO VASAPPS.TOS_LL_DL_CONTAINERS (PK_TOS_LL_DL_CNTR_SEQ
                                                ,FK_BOOKING_NO
                                                ,IMO_CLASS
                                                ,UNNO
                                                ,FUMIGATION_YN
                                                ,RESIDUE
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDC01.NEXTVAL
                                               ,:NEW.BOOKING_NO
                                               ,:NEW.IMO_CLASS
                                               ,:NEW.UN_NO
                                               ,:NEW.FUMIGATION_YN
                                               ,:NEW.RESIDUE
                                               ,'I'
                                               ,'BKGDGDTL'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKGDG'
                                              );

        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_CONTAINERS TABLE - INSERT'
                                                    , 'BOOKING#: ' || :new.BOOKING_NO
                                                    , 'IMO_CLASS: ' || :NEW.IMO_CLASS
                                                    , 'UN_NO: ' || :NEW.UN_NO
                                                    , 'FUMIGATION_YN: ' || :NEW.FUMIGATION_YN
                                                    , 'RESIDUE: '|| :NEW.RESIDUE
                                                    , 'MODE_TYPE: INSERTING '
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);


    END IF ;

END IF;
IF DELETING THEN
   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_CONTAINERS
	   WHERE FK_BOOKING_NO = :OLD.BOOKING_NO
	     AND IMO_CLASS = :OLD.IMO_CLASS
		   AND UNNO = :OLD.UN_NO
       AND FUMIGATION_YN = :OLD.FUMIGATION_YN
       AND RESIDUE = :OLD.RESIDUE
       AND SOURCE = 'BKGDGDTL'
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.	   
       AND MODE_TYPE = 'D'
		   AND STATUS = 'P'
		   AND RECORD_STATUS= 'A';


   VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP_DG_DTL'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_CONTAINERS TABLE - INSERT'
                                              , 'BOOKING#: ' || :OLD.BOOKING_NO
                                              , 'IMO_CLASS: ' || :OLD.IMO_CLASS
                                              , 'UN_NO: ' || :OLD.UN_NO
                                              , 'FUMIGATION_YN: ' || :OLD.FUMIGATION_YN
                                              , 'RESIDUE: '|| :OLD.RESIDUE
                                              , 'MODE_TYPE: INSERTING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
    IF V_CNT = 0 THEN

       INSERT INTO VASAPPS.TOS_LL_DL_CONTAINERS (PK_TOS_LL_DL_CNTR_SEQ
                                                ,FK_BOOKING_NO
                                                ,IMO_CLASS
                                                ,UNNO
                                                ,FUMIGATION_YN
                                                ,RESIDUE
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDC01.NEXTVAL
                                               ,:OLD.BOOKING_NO
                                               ,:OLD.IMO_CLASS
                                               ,:OLD.UN_NO
                                               ,:OLD.FUMIGATION_YN
                                               ,:OLD.RESIDUE
                                               ,'D'
                                               ,'BKGDGDTL'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKGDG'
                                              );


        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_CONTAINERS TABLE - INSERT'
                                                    , 'BOOKING#: ' || :OLD.BOOKING_NO
                                                    , 'IMO_CLASS: ' || :OLD.IMO_CLASS
                                                    , 'UN_NO: ' || :OLD.UN_NO
                                                    , 'FUMIGATION_YN: ' || :OLD.FUMIGATION_YN
                                                    , 'RESIDUE: '|| :OLD.RESIDUE
                                                    , 'MODE_TYPE: INSERTING '
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
   END IF;

END IF ;
IF UPDATING THEN


   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_CONTAINERS
	   WHERE FK_BOOKING_NO = :OLD.BOOKING_NO
	     AND IMO_CLASS = :OLD.IMO_CLASS
		   AND UNNO = :OLD.UN_NO
       AND FUMIGATION_YN = :OLD.FUMIGATION_YN
       AND RESIDUE = :OLD.RESIDUE
       AND SOURCE = 'BKGDGDTL'
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.	   
       AND MODE_TYPE = 'U'
		   AND STATUS = 'P'
		   AND RECORD_STATUS= 'A';

   VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP_DG_DTL'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_CONTAINERS TABLE - INSERT'
                                              , 'BOOKING#: ' || :new.BOOKING_NO
                                              , 'IMO_CLASS: ' || :NEW.IMO_CLASS
                                              , 'UN_NO: ' || :NEW.UN_NO
                                              , 'FUMIGATION_YN: ' || :NEW.FUMIGATION_YN
                                              , 'RESIDUE: '|| :NEW.RESIDUE
                                              , 'MODE_TYPE: INSERTING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
   IF V_CNT = 0 THEN

       INSERT INTO VASAPPS.TOS_LL_DL_CONTAINERS (PK_TOS_LL_DL_CNTR_SEQ
                                                ,FK_BOOKING_NO
                                                ,IMO_CLASS
                                                ,UNNO
                                                ,FUMIGATION_YN
                                                ,RESIDUE
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDC01.NEXTVAL
                                               ,:NEW.BOOKING_NO
                                               ,:NEW.IMO_CLASS
                                               ,:NEW.UN_NO
                                               ,:NEW.FUMIGATION_YN
                                               ,:NEW.RESIDUE
                                               ,'U'
                                               ,'BKGDGDTL'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKGDG'
                                              );

        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_CONTAINERS TABLE - INSERT'
                                                    , 'BOOKING#: ' || :new.BOOKING_NO
                                                    , 'IMO_CLASS: ' || :NEW.IMO_CLASS
                                                    , 'UN_NO: ' || :NEW.UN_NO
                                                    , 'FUMIGATION_YN: ' || :NEW.FUMIGATION_YN
                                                    , 'RESIDUE: '|| :NEW.RESIDUE
                                                    , 'MODE_TYPE: INSERTING '
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);


   END IF;


END IF;

END TRG_LL_DL_BKP009;
/
