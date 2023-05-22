CREATE OR REPLACE TRIGGER TRG_LL_DL_BKP009
  AFTER INSERT OR UPDATE OR DELETE ON SEALINER.BKP009
  FOR EACH ROW
DECLARE
  -- LOCAL VARIABLES HERE
  V_SIZE_TYPE_SEQ_NO               SEALINER.BKP032.EQP_SIZETYPE_SEQNO%TYPE;
  V_CNT                            INTEGER;
  V_IMDG                           SEALINER.BKP009.BIIMCL%TYPE;
  V_UNNO                           SEALINER.BKP009.BIUNN%TYPE;
  V_UN_VAR                         SEALINER.BKP009.UN_VARIANT%TYPE;
  V_FLASH_POINT                    VARCHAR2(7);
  V_FLASH_UNIT                     SEALINER.BKP009.BIFLBS%TYPE;
  V_REEFER_TMP                     VARCHAR2(7);
  V_REEFER_TMP_UNIT                SEALINER.BKP009.BIRFBS%TYPE;
  V_VENTILATION                    SEALINER.BKP009.AIR_PRESSURE%TYPE;


BEGIN

IF INSERTING THEN

   BEGIN
        SELECT SEQ_NO.EQP_SIZETYPE_SEQNO
        INTO V_SIZE_TYPE_SEQ_NO
        FROM SEALINER.BKP009 CNTR,
            (SELECT BOOKING_NO,SUPPLIER_SQNO,EQP_SIZETYPE_SEQNO FROM SEALINER.BOOKING_SUPPLIER_DETAIL SP
             WHERE EXISTS (SELECT 'X' FROM SEALINER.BKP032 SZ
             WHERE SP.BOOKING_NO = SZ.BCBKNO
             AND SP.EQP_SIZETYPE_SEQNO = SZ.EQP_SIZETYPE_SEQNO
            )) SEQ_NO
        WHERE CNTR.BIBKNO = SEQ_NO.BOOKING_NO
          AND CNTR.SUPPLIER_SQNO = SEQ_NO.SUPPLIER_SQNO
          AND CNTR.BISEQN = :NEW.BISEQN
          AND CNTR.BIBKNO = :NEW.BIBKNO;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
            V_SIZE_TYPE_SEQ_NO :=NULL;
       WHEN OTHERS THEN
            V_SIZE_TYPE_SEQ_NO :=NULL;
   END ;
   VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_CONTAINERS TABLE - INSERT'
                                              , 'BOOKING#: ' || :new.BIBKNO
                                              , 'EQUIPMENT_SEQ: ' || :NEW.BISEQN
                                              , 'SIZE_TYPE_SEQ: ' || V_SIZE_TYPE_SEQ_NO
                                              , 'SUPPIER_SEQ: ' || :NEW.SUPPLIER_SQNO
                                              , 'MODE_TYPE: INSERTING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);

   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_CONTAINERS
	   WHERE FK_BOOKING_NO = :NEW.BIBKNO
	     AND FK_EQUIPMENT_SEQ = :NEW.BISEQN
		   AND SIZE_TYPE_SEQ_NO = V_SIZE_TYPE_SEQ_NO
       AND SUPPLIER_SEQ_NO = :NEW.SUPPLIER_SQNO
       AND SOURCE = 'BKP009' 
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.	   
       AND MODE_TYPE = 'I'
		   AND STATUS = 'P'
		   AND RECORD_STATUS= 'A';

    IF V_CNT = 0 THEN

       INSERT INTO VASAPPS.TOS_LL_DL_CONTAINERS (PK_TOS_LL_DL_CNTR_SEQ
                                                ,FK_BOOKING_NO
                                                ,FK_EQUIPMENT_SEQ
                                                ,SIZE_TYPE_SEQ_NO
                                                ,SUPPLIER_SEQ_NO
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDC01.NEXTVAL
                                               ,:NEW.BIBKNO
                                               ,:NEW.BISEQN
                                               ,V_SIZE_TYPE_SEQ_NO
                                               ,:NEW.SUPPLIER_SQNO
                                               ,'I'
                                               ,'BKP009'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKP009'
                                              );

        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_CONTAINERS TABLE - INSERT'
                                                    , 'BOOKING#: ' || :new.BIBKNO
                                                    , 'EQUIPMENT_SEQ: ' || :NEW.BISEQN
                                                    , 'SIZE_TYPE_SEQ: ' || V_SIZE_TYPE_SEQ_NO
                                                    , 'SUPPIER_SEQ: ' || :NEW.SUPPLIER_SQNO
                                                    , 'MODE_TYPE: INSERTING '
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);

    END IF ;

END IF;
IF DELETING THEN
   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_CONTAINERS
	   WHERE FK_BOOKING_NO = :NEW.BIBKNO
	     AND FK_EQUIPMENT_SEQ = :NEW.BISEQN
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.		 
       AND MODE_TYPE = 'D'
		   AND STATUS = 'P'
       AND SOURCE = 'BKP009'
		   AND RECORD_STATUS= 'A';

       VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_CONTAINERS TABLE - DELETE'
                                              , 'BOOKING#: ' || :OLD.BIBKNO
                                              , 'EQUIPMENT_SEQ: ' || :OLD.BISEQN
                                              , 'MODE_TYPE: DELETING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);

    IF V_CNT = 0 THEN

              INSERT INTO VASAPPS.TOS_LL_DL_CONTAINERS (PK_TOS_LL_DL_CNTR_SEQ
                                                ,FK_BOOKING_NO
                                                ,FK_EQUIPMENT_SEQ
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDC01.NEXTVAL
                                               ,:OLD.BIBKNO
                                               ,:OLD.BISEQN
                                               ,'D'
                                               ,'BKP009'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKP009'
                                              );

        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                                    , '-'
                                                    , '2.AFTER INSERT INTO TOS_LL_DL_CONTAINERS TABLE - DELETE'
                                                    , 'BOOKING#: ' || :OLD.BIBKNO
                                                    , 'EQUIPMENT_SEQ: ' || :OLD.BISEQN
                                                    , 'MODE_TYPE: DELETING '
                                                    , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
   END IF;

END IF ;
IF UPDATING THEN

   IF :NEW.UN_VARIANT IS NOT NULL THEN
      V_UN_VAR := :NEW.UN_VARIANT ;
   ELSIF :OLD.UN_VARIANT IS NOT NULL THEN
      V_UN_VAR := '~';
   ELSE
      V_UN_VAR := NULL;
   END IF ;

   IF :NEW.BIUNN IS NOT NULL THEN
      V_UNNO := :NEW.BIUNN;
   ELSIF :OLD.BIUNN IS NOT NULL THEN
      V_UNNO := '~';
   ELSE
      V_UNNO := NULL;
   END IF ;

   IF :NEW.BIIMCL IS NOT NULL THEN
      V_IMDG := :NEW.BIIMCL;
   ELSIF :OLD.BIIMCL IS NOT NULL THEN
      V_IMDG := '~';
   ELSE
      V_IMDG := NULL;
   END IF ;

   IF :NEW.BIFLPT IS NOT NULL THEN
      V_FLASH_POINT := :NEW.BIFLPT;
   ELSIF :OLD.BIFLPT IS NOT NULL THEN
      V_FLASH_POINT := '~' ;
   ELSE
      V_FLASH_POINT := NULL;
   END IF ;

   IF :NEW.BIFLBS IS NOT NULL THEN
      V_FLASH_UNIT := :new.BIFLBS ;
   ELSIF :OLD.BIFLBS IS NOT NULL THEN
      V_FLASH_UNIT := '~' ;
   ELSE
      V_FLASH_UNIT := NULL;
   END IF;

   IF :NEW.BIRFFM IS NOT NULL THEN
      V_REEFER_TMP := :NEW.BIRFFM ;
   ELSIF :OLD.BIRFFM IS NOT NULL THEN
      V_REEFER_TMP := '~' ;
   ELSE
      V_REEFER_TMP := NULL;
   END IF ;

   IF :NEW.BIRFBS IS NOT NULL THEN
      V_REEFER_TMP_UNIT := :NEW.BIRFBS ;
   ELSIF :OLD.BIRFBS IS NOT NULL THEN
      V_REEFER_TMP_UNIT := '~' ;
   ELSE
      V_REEFER_TMP_UNIT := NULL;
   END IF ;

   IF :NEW.AIR_PRESSURE IS NOT NULL THEN
      V_VENTILATION := :NEW.AIR_PRESSURE;
   ELSIF :OLD.AIR_PRESSURE IS NOT NULL THEN
      V_VENTILATION := 0;
   ELSE
      V_VENTILATION := NULL;
   END IF ;

   	   -- check if already in cod_bl with pending status, then no need to insert into table q.
	   SELECT COUNT(*) INTO V_CNT
	   FROM VASAPPS.TOS_LL_DL_CONTAINERS
	   WHERE FK_BOOKING_NO = :NEW.BIBKNO
	     AND FK_EQUIPMENT_SEQ = :NEW.BISEQN
       AND (FK_OLD_EQUIPMENT_NO IS NULL OR FK_OLD_EQUIPMENT_NO = :OLD.BICTRN)
       AND (FK_NEW_EQUIPMENT_NO IS NULL OR FK_NEW_EQUIPMENT_NO = :NEW.BICTRN)
       AND OVERHEIGHT = :NEW.BIXHGT
       AND OVERLENGTH_REAR = :NEW.BIXLNB
       AND OVERLENGTH_FRONT = :NEW.BIXLNF
       AND OVERWIDTH_LEFT = :NEW.BIXWDL
       AND OVERWIDTH_RIGHT = :NEW.BIXWDR
       AND NVL(IMDG,'0')=NVL(V_IMDG,'0')--(IMDG IS NULL OR IMDG = V_IMDG)
       AND NVL(UNNO,'0')=NVL(V_UNNO,'0')--(UNNO IS NULL OR UNNO = V_UNNO)
       AND NVL(UN_VAR,'-')=NVL(V_UN_VAR,'-')--(UN_VAR IS NULL OR UN_VAR = V_UN_VAR)
       AND NVL(FLASH_POINT,'-')=NVL(V_FLASH_POINT,'-')--(FLASH_POINT IS NULL OR FLASH_POINT = V_FLASH_POINT)
       AND NVL(FLASH_UNIT,'-')=NVL(V_FLASH_UNIT,'-')--(FLASH_UNIT IS NULL OR FLASH_UNIT = V_FLASH_UNIT)
       AND NVL(REEFER_TMP,'0')=NVL(V_REEFER_TMP,'0')--(REEFER_TMP IS NULL OR REEFER_TMP = V_REEFER_TMP)
       AND NVL(REEFER_TMP_UNIT,'-')=NVL(V_REEFER_TMP_UNIT,'-')--(REEFER_TMP_UNIT IS NULL OR REEFER_TMP_UNIT = V_REEFER_TMP_UNIT)
       AND HUMIDITY = :NEW.HUMIDITY
       AND NVL(VENTILATION,0)=NVL(V_VENTILATION,0)--(VENTILATION IS NULL OR VENTILATION = V_VENTILATION)
       AND NVL(WEIGHT,0) = NVL(:NEW.MET_WEIGHT,0)
       AND NVL(VGM,0) = NVL(:NEW.EQP_VGM,0)
       AND NVL(VGM_CATEGORY,'-') = NVL(:NEW.EQP_CATEGORY,'-')
	   AND CREATED_USER = :NEW.BICUSR
	   AND ROUND(TO_NUMBER(SYSDATE - TO_DATE(TO_CHAR(RECORD_ADD_DATE,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*24*60,2) < 1  -- WILL INSERT IF MORE THAN 1 MINUTES.	   
       AND MODE_TYPE = 'U'
		   AND STATUS = 'P'
       AND SOURCE = 'BKP009'
		   AND RECORD_STATUS= 'A';

       VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                              , '-'
                                              , '1.B4 INSERT TO TOS_LL_DL_CONTAINERS TABLE - UPDATE'
                                              , 'BOOKING#: ' || :new.BIBKNO
                                              , 'EQUIPMENT_SEQ: ' || :NEW.BISEQN ||
                                              ',' || 'FK_OLD_EQUIPMENT_NO: '|| :OLD.BICTRN ||
                                              ',' || 'FK_NEW_EQUIPMENT_NO: ' || :NEW.BICTRN
                                              , 'OOG INFO : OVERHEIGHT: '|| :NEW.BIXHGT ||
                                              ',' || 'OVERLENGTH_REAR: ' || :NEW.BIXLNB ||
                                              ',' || 'OVERLENGTH_FRONT: '|| :NEW.BIXLNF ||
                                              ',' || 'OVERWIDTH_LEFT: '|| :NEW.BIXWDL ||
                                              ',' || 'OVERWIDTH_RIGHT: '|| :NEW.BIXWDR 
                                              , 'DG INFO : IMDG: '||  V_IMDG ||
                                              ',' || 'UNNO: '|| V_UNNO ||
                                              ',' || 'UN_VAR: '|| V_UN_VAR ||
                                              ',' || 'FLASH_POINT: '|| V_FLASH_POINT ||
                                              ',' || 'FLASH_UNIT: '|| V_FLASH_UNIT 
                                              , 'REEFER INFO : REEFER_TMP: '|| V_REEFER_TMP ||
                                              ',' || 'REEFER_TMP_UNIT :'|| V_REEFER_TMP_UNIT ||
                                              ',' || 'HUMIDITY :'|| :NEW.HUMIDITY ||
                                              ',' || 'VENTILATION :' ||V_VENTILATION 
                                              , 'WEIGHT :' || :NEW.MET_WEIGHT ||
                                              ',' ||  'VGM :' || :NEW.EQP_VGM ||
                                              ',' || 'VGM_CATEGORY :' || :NEW.EQP_CATEGORY
                                              , 'MODE_TYPE: UPDATING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
   IF V_CNT = 0 THEN

       INSERT INTO VASAPPS.TOS_LL_DL_CONTAINERS (PK_TOS_LL_DL_CNTR_SEQ
                                                ,FK_BOOKING_NO
                                                ,FK_EQUIPMENT_SEQ
                                                ,FK_OLD_EQUIPMENT_NO
                                                ,FK_NEW_EQUIPMENT_NO
                                                ,OVERHEIGHT
                                                ,OVERLENGTH_REAR
                                                ,OVERLENGTH_FRONT
                                                ,OVERWIDTH_LEFT
                                                ,OVERWIDTH_RIGHT
                                                ,IMDG
                                                ,UNNO
                                                ,UN_VAR
                                                ,FLASH_POINT
                                                ,FLASH_UNIT
                                                ,REEFER_TMP
                                                ,REEFER_TMP_UNIT
                                                ,HUMIDITY
                                                ,VENTILATION
                                                ,WEIGHT
                                                ,VGM
                                                ,VGM_CATEGORY
											    ,CREATED_USER
                                                ,MODE_TYPE
                                                ,SOURCE
                                                ,STATUS
                                                ,RECORD_STATUS
                                                ,RECORD_ADD_DATE
                                                ,RECORD_ADD_USER)
                                        VALUES (SR_TOS_LDC01.NEXTVAL
                                               ,:NEW.BIBKNO
                                               ,:NEW.BISEQN
                                               ,:OLD.BICTRN
                                               ,:NEW.BICTRN
                                               ,:NEW.BIXHGT
                                               ,:NEW.BIXLNB
                                               ,:NEW.BIXLNF
                                               ,:NEW.BIXWDL
                                               ,:NEW.BIXWDR
                                               ,V_IMDG
                                               ,V_UNNO
                                               ,V_UN_VAR
                                               ,V_FLASH_POINT
                                               ,V_FLASH_UNIT
                                               ,V_REEFER_TMP
                                               ,V_REEFER_TMP_UNIT
                                               ,:NEW.HUMIDITY
                                               ,V_VENTILATION
                                               ,:NEW.MET_WEIGHT
                                               ,:NEW.EQP_VGM
                                               ,:NEW.EQP_CATEGORY
											                         ,:NEW.BICUSR
                                               ,'U'
                                               ,'BKP009'
                                               ,'P'
                                               ,'A'
                                               ,SYSDATE
                                               ,'LD_BKP009'
                                              );

       VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('TRG_LL_DL_BKP009'
                                              , '-'
                                              , '2.AFTER INSERT TO TOS_LL_DL_CONTAINERS TABLE - UPDATE'
                                              , 'BOOKING#: ' || :new.BIBKNO
                                              , 'EQUIPMENT_SEQ: ' || :NEW.BISEQN ||
                                              ',' || 'FK_OLD_EQUIPMENT_NO: '|| :OLD.BICTRN ||
                                              ',' || 'FK_NEW_EQUIPMENT_NO: ' || :NEW.BICTRN
                                              , 'OOG INFO : OVERHEIGHT: '|| :NEW.BIXHGT ||
                                              ',' || 'OVERLENGTH_REAR: ' || :NEW.BIXLNB ||
                                              ',' || 'OVERLENGTH_FRONT: '|| :NEW.BIXLNF ||
                                              ',' || 'OVERWIDTH_LEFT: '|| :NEW.BIXWDL ||
                                              ',' || 'OVERWIDTH_RIGHT: '|| :NEW.BIXWDR 
                                              , 'DG INFO : IMDG: '||  V_IMDG ||
                                              ',' || 'UNNO: '|| V_UNNO ||
                                              ',' || 'UN_VAR: '|| V_UN_VAR ||
                                              ',' || 'FLASH_POINT: '|| V_FLASH_POINT ||
                                              ',' || 'FLASH_UNIT: '|| V_FLASH_UNIT 
                                              , 'REEFER INFO : REEFER_TMP: '|| V_REEFER_TMP ||
                                              ',' || 'REEFER_TMP_UNIT :'|| V_REEFER_TMP_UNIT ||
                                              ',' || 'HUMIDITY :'|| :NEW.HUMIDITY ||
                                              ',' || 'VENTILATION :' ||V_VENTILATION 
                                              , 'WEIGHT :' || :NEW.MET_WEIGHT ||
                                              ',' ||  'VGM :' || :NEW.EQP_VGM ||
                                              ',' || 'VGM_CATEGORY :' || :NEW.EQP_CATEGORY
                                              , 'MODE_TYPE: UPDATING '
                                              , 'FORMAT_ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                              , 'FORMAT_ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);

   END IF;


END IF;

END TRG_LL_DL_BKP009;

