create or replace PACKAGE BODY RCL_IGM_INFO 
IS 
  PROCEDURE RCL_IGM_GET_DATA(P_O_REFIGMTABFIND  OUT SYS_REFCURSOR, 
                             P_I_V_POD          VARCHAR2, 
                             P_I_V_BL           VARCHAR2 DEFAULT NULL, 
                             P_I_V_SERVICE      VARCHAR2 DEFAULT NULL, 
                             P_I_V_VESSEL       VARCHAR2 DEFAULT NULL,     
                             P_I_V_VOYAGE       VARCHAR2 DEFAULT NULL, 
                             P_I_V_POD_TERMINAL VARCHAR2 DEFAULT NULL,  
                             P_I_V_FROM_DATE    VARCHAR2 DEFAULT NULL,     
                             P_I_V_TO_DATE      VARCHAR2 DEFAULT NULL, 
                             P_I_V_BL_STATUS    VARCHAR2 DEFAULT NULL, 
                             P_I_V_POL          VARCHAR2 DEFAULT NULL, 
                             P_I_V_DEL           VARCHAR2 DEFAULT NULL,
                             P_I_V_DEPOT         VARCHAR2 DEFAULT NULL,
                             P_I_V_POL_TERMINAL VARCHAR2 DEFAULT NULL, 
                             P_I_V_DIRECTION    VARCHAR2 DEFAULT NULL, 
                             P_O_V_ERROR        OUT VARCHAR2) 
  IS 
    BL_COUNT NUMBER(20); 
    SERVISE_COUNT NUMBER(20); 
    TEMP_POD_COUNT_PRIVIOUS NUMBER(2);
    TEMP_POD_COUNT_NEXT NUMBER(4);
    TEMP_LAST_PORT_1  VARCHAR2(20);     --LAST_PORT_1
    TEMP_LAST_PORT_TER_1  VARCHAR2(20);
    TEMP_LAST_PORT_2  VARCHAR2(20);     --LAST_PORT_2
    TEMP_LAST_PORT_TER_2  VARCHAR2(20);
    TEMP_LAST_PORT_3  VARCHAR2(20);     --LAST_PORT_3
    TEMP_LAST_PORT_TER_3 VARCHAR2(20); 
    TEMP_NEXT_PORT_1  VARCHAR2(20);     -- FOR 1ST NEXT PORT  NEXT_PORT_4
    TEMP_NEXT_PORT_2  VARCHAR2(20);     -- FOR 2ND NEXT PORT  NEXT_PORT_5
    TEMP_NEXT_PORT_3  VARCHAR2(20);     -- FOR 3RD NEXT PORT  NEXT_PORT_6
    TEMP_SERVICE VARCHAR2(20);
    TEMP_POD_TERMINAL VARCHAR2(20);
  BEGIN   
      
    
     
     SELECT COUNT(ACT_SERVICE_CODE) INTO SERVISE_COUNT FROM IDP005 WHERE ACT_VESSEL_CODE=P_I_V_VESSEL
                    AND ACT_VOYAGE_NUMBER=P_I_V_VOYAGE AND DISCHARGE_PORT=P_I_V_POD AND ROWNUM=1;
     
     IF SERVISE_COUNT=1 THEN
     SELECT ACT_SERVICE_CODE INTO TEMP_SERVICE FROM IDP005 WHERE ACT_VESSEL_CODE=P_I_V_VESSEL
                    AND ACT_VOYAGE_NUMBER=P_I_V_VOYAGE AND DISCHARGE_PORT=P_I_V_POD AND ROWNUM=1;
     
     FOR TEMP_POD_COUNT_PRIVIOUS in 1 .. 3 LOOP
                   
      IF(TEMP_POD_COUNT_PRIVIOUS=1) THEN
            
        BEGIN
            SELECT TO_TERMINAL INTO TEMP_POD_TERMINAL FROM IDP005 WHERE ACT_VESSEL_CODE=P_I_V_VESSEL
            AND ACT_VOYAGE_NUMBER=P_I_V_VOYAGE AND DISCHARGE_PORT=P_I_V_POD AND ACT_SERVICE_CODE=TEMP_SERVICE AND ROWNUM=1;
      
    --  INSERT INTO SUSHILTEST VALUES('54 '||TEMP_POD_TERMINAL);
      
            SELECT VVPCAL,VVTRM1 INTO TEMP_LAST_PORT_3,TEMP_LAST_PORT_TER_3 FROM (
            SELECT VVPCAL,VVTRM1  FROM SEALINER.ITP063 WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99 AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))<=(
            SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') AS ETADATE FROM SEALINER.ITP063 WHERE
            VVSRVC=TEMP_SERVICE AND
            VVPCAL=P_I_V_POD AND
            VVVESS=P_I_V_VESSEL AND
            VVVOYN=P_I_V_VOYAGE AND
            VVTRM1=TEMP_POD_TERMINAL AND 
           -- VVPCSQ=PORTSEQUENCE' AND
            VVVERS=99 AND
            OMMISSION_FLAG IS NULL AND
            VVFORL IS NOT NULL )
            AND OMMISSION_FLAG IS NULL
            AND VVFORL IS NOT NULL
            AND (VVPCAL ,VVTRM1) NOT IN
            (SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
            VVSRVC= TEMP_SERVICE AND
            VVPCAL=P_I_V_POD AND
            VVVESS=P_I_V_VESSEL AND
            VVVOYN=P_I_V_VOYAGE AND
            VVTRM1=TEMP_POD_TERMINAL AND 
            --VVPCSQ=PORTSEQUENCE' AND
            VVVERS=99 AND
            OMMISSION_FLAG IS NULL AND
            VVFORL IS NOT NULL)   
            ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000') DESC,VVPCSQ DESC)WHERE ROWNUM=1;
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!'); 
        
        END;   
            
         ELSIF(TEMP_POD_COUNT_PRIVIOUS=2 AND TEMP_LAST_PORT_3 IS NOT NULL ) THEN
            
        BEGIN
            SELECT VVPCAL,VVTRM1 INTO TEMP_LAST_PORT_2,TEMP_LAST_PORT_TER_2 FROM (
            SELECT VVPCAL,VVTRM1  FROM SEALINER.ITP063 WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99 AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))<=(
            SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') AS ETADATE FROM SEALINER.ITP063 WHERE
            VVSRVC=TEMP_SERVICE AND
            VVPCAL=TEMP_LAST_PORT_3 AND
            VVVESS=P_I_V_VESSEL AND
            VVVOYN=P_I_V_VOYAGE AND
            VVTRM1=TEMP_LAST_PORT_TER_3 AND 
            --VVPCSQ=PORTSEQUENCE' AND
            VVVERS=99 AND
            OMMISSION_FLAG IS NULL AND
            VVFORL IS NOT NULL )
            AND OMMISSION_FLAG IS NULL
            AND VVFORL IS NOT NULL
            AND (VVPCAL ,VVTRM1) NOT IN
            (SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
            VVSRVC=TEMP_SERVICE AND
            VVPCAL=TEMP_LAST_PORT_3 AND
            VVVESS=P_I_V_VESSEL AND
            VVVOYN=P_I_V_VOYAGE AND
            VVTRM1=TEMP_LAST_PORT_TER_3 AND 
            --VVPCSQ=PORTSEQUENCE' AND
            VVVERS=99 AND
            OMMISSION_FLAG IS NULL AND
            VVFORL IS NOT NULL)
            ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000') DESC,VVPCSQ DESC)WHERE ROWNUM=1;
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!'); 
        
        END;   
           
         ELSIF(TEMP_POD_COUNT_PRIVIOUS=3 AND TEMP_LAST_PORT_2 IS NOT NULL) THEN
           
        BEGIN
            SELECT VVPCAL INTO TEMP_LAST_PORT_1 FROM (
            SELECT VVPCAL FROM SEALINER.ITP063 WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99 AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))<=(
            SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') AS ETADATE FROM SEALINER.ITP063 WHERE
            VVSRVC=TEMP_SERVICE AND
            VVPCAL=TEMP_LAST_PORT_2 AND
            VVVESS=P_I_V_VESSEL AND
            VVVOYN=P_I_V_VOYAGE AND
            VVTRM1=TEMP_LAST_PORT_TER_2 AND 
            --VVPCSQ=PORTSEQUENCE' AND
            VVVERS=99 AND
            OMMISSION_FLAG IS NULL AND
            VVFORL IS NOT NULL )
            AND OMMISSION_FLAG IS NULL
            AND VVFORL IS NOT NULL
            AND (VVPCAL ,VVTRM1) NOT IN
            (SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
            VVSRVC=TEMP_SERVICE AND
            VVPCAL=TEMP_LAST_PORT_2 AND
            VVVESS=P_I_V_VESSEL AND
            VVVOYN=P_I_V_VOYAGE AND
            VVTRM1=TEMP_LAST_PORT_TER_2 AND 
            --VVPCSQ=PORTSEQUENCE' AND
            VVVERS=99 AND
            OMMISSION_FLAG IS NULL AND
            VVFORL IS NOT NULL)
            ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000') DESC,VVPCSQ DESC)WHERE ROWNUM=1;
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!'); 
        
        END;   
            
         END IF;
      END LOOP;

     FOR TEMP_POD_COUNT_PRIVIOUS in 1 .. 3 LOOP
                   
      IF(TEMP_POD_COUNT_PRIVIOUS=1) THEN
           
            SELECT TO_TERMINAL INTO TEMP_POD_TERMINAL FROM IDP005 WHERE ACT_VESSEL_CODE=P_I_V_VESSEL
            AND ACT_VOYAGE_NUMBER=P_I_V_VOYAGE AND DISCHARGE_PORT=P_I_V_POD AND TEMP_SERVICE=TEMP_SERVICE AND ROWNUM=1;
            
        BEGIN 
            SELECT VVPCAL,VVTRM1 into TEMP_NEXT_PORT_1,TEMP_LAST_PORT_TER_1 FROM (
			SELECT VVPCAL,VVTRM1 FROM SEALINER.ITP063 WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99 AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))>=(
			SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') AS ETADATE FROM SEALINER.ITP063 WHERE
			VVSRVC=TEMP_SERVICE AND
			VVPCAL=P_I_V_POD AND
			VVVESS=P_I_V_VESSEL AND
			VVVOYN=P_I_V_VOYAGE AND
			VVTRM1=TEMP_POD_TERMINAL AND
			--VVPCSQ=PORTSEQUENCE' AND
			VVVERS=99 AND
			OMMISSION_FLAG IS NULL AND
			VVFORL IS NOT NULL )
			AND OMMISSION_FLAG IS NULL
			AND VVFORL IS NOT NULL
			AND (VVPCAL ,VVTRM1) NOT IN
			( SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
			VVSRVC =TEMP_SERVICE AND
			VVPCAL =P_I_V_POD AND
			VVVESS =P_I_V_VESSEL AND
			VVVOYN =P_I_V_VOYAGE AND
			VVTRM1=TEMP_POD_TERMINAL AND
			--VVPCSQ =PORTSEQUENCE' AND
			VVVERS =99 AND
			OMMISSION_FLAG IS NULL AND
			VVFORL IS NOT NULL)
			ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000'),VVPCSQ)WHERE ROWNUM=1;
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!'); 
        
        END;    
           
         ELSIF(TEMP_POD_COUNT_PRIVIOUS=2 AND TEMP_NEXT_PORT_1 IS NOT NULL ) THEN
            
		BEGIN	
            SELECT VVPCAL,VVTRM1 INTO TEMP_NEXT_PORT_2,TEMP_LAST_PORT_TER_2 FROM (
			SELECT VVPCAL,VVTRM1 FROM SEALINER.ITP063 WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99 AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))>=(
			SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') AS ETADATE FROM SEALINER.ITP063 WHERE
			VVSRVC=TEMP_SERVICE AND
			VVPCAL=TEMP_NEXT_PORT_1 AND
			VVVESS=P_I_V_VESSEL AND
			VVVOYN=P_I_V_VOYAGE AND
			VVTRM1=TEMP_LAST_PORT_TER_1 AND
			--VVPCSQ=PORTSEQUENCE' AND
			VVVERS=99 AND
			OMMISSION_FLAG IS NULL AND
			VVFORL IS NOT NULL )
			AND OMMISSION_FLAG IS NULL
			AND VVFORL IS NOT NULL
			AND (VVPCAL ,VVTRM1) NOT IN
			( SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
			VVSRVC =TEMP_SERVICE AND
			VVPCAL =TEMP_NEXT_PORT_1 AND
			VVVESS =P_I_V_VESSEL AND
			VVVOYN =P_I_V_VOYAGE AND
			VVTRM1=TEMP_LAST_PORT_TER_1 AND
			--VVPCSQ =PORTSEQUENCE' AND
			VVVERS =99 AND
			OMMISSION_FLAG IS NULL AND
			VVFORL IS NOT NULL)
			ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000'),VVPCSQ)WHERE ROWNUM=1;
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!'); 
        
        END;    
           
         ELSIF(TEMP_POD_COUNT_PRIVIOUS=3 AND TEMP_NEXT_PORT_2 IS NOT NULL) THEN
            
         BEGIN 
            SELECT VVPCAL INTO TEMP_NEXT_PORT_3 FROM (
			SELECT VVPCAL FROM SEALINER.ITP063 WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99 AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))>=(
			SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') AS ETADATE FROM SEALINER.ITP063 WHERE
			VVSRVC=TEMP_SERVICE AND
			VVPCAL=TEMP_NEXT_PORT_2 AND
			VVVESS=P_I_V_VESSEL AND
			VVVOYN=P_I_V_VOYAGE AND
			VVTRM1=TEMP_LAST_PORT_TER_2 AND
			--VVPCSQ=PORTSEQUENCE' AND
			VVVERS=99 AND
			OMMISSION_FLAG IS NULL AND
			VVFORL IS NOT NULL )
			AND OMMISSION_FLAG IS NULL
			AND VVFORL IS NOT NULL
			AND (VVPCAL ,VVTRM1) NOT IN
			( SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
			VVSRVC =TEMP_SERVICE AND
			VVPCAL =TEMP_NEXT_PORT_2 AND
			VVVESS =P_I_V_VESSEL AND
			VVVOYN =P_I_V_VOYAGE AND
			VVTRM1=TEMP_LAST_PORT_TER_2 AND
			--VVPCSQ =PORTSEQUENCE' AND
			VVVERS =99 AND
			OMMISSION_FLAG IS NULL AND
			VVFORL IS NOT NULL)
			ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000'),VVPCSQ)WHERE ROWNUM=1;
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!'); 
        
        END;    
      
         END IF;
      END LOOP;
     END IF;  
    
      P_O_V_ERROR := '000000';    
      
      BL_COUNT := 0; 
    --  INSERT INTO SUSHILTEST VALUES('278 '||TEMP_POD_TERMINAL);  
      SELECT COUNT(*) 
      INTO   BL_COUNT 
      FROM   RCL_IGM_DETAILS rid 
      WHERE  rid.PORT = P_I_V_POD 
             AND ( P_I_V_SERVICE IS NULL 
                    OR rid.SERVICE = P_I_V_SERVICE ) 
             AND ( P_I_V_VESSEL IS NULL 
                    OR rid.VESSEL = P_I_V_VESSEL ) 
             AND ( P_I_V_VOYAGE IS NULL 
                    OR rid.VOYAGE = P_I_V_VOYAGE ) 
             AND ( P_I_V_POD_TERMINAL IS NULL 
                    OR rid.TERMINAL = P_I_V_POD_TERMINAL ) 
             AND ( P_I_V_FROM_DATE IS NULL 
                    OR rid.BL_DATE >= P_I_V_FROM_DATE ) 
             AND ( P_I_V_TO_DATE IS NULL 
                    OR rid.BL_DATE <= P_I_V_TO_DATE )   
             AND ( P_I_V_POL IS NULL 
                    OR rid.POL = P_I_V_POL ) 
             AND ( P_I_V_BL_STATUS IS NULL 
                    OR rid.BL_STATUS = P_I_V_BL_STATUS ) 
             AND ( P_I_V_POL_TERMINAL IS NULL 
                    OR rid.POL_TERMINAL = P_I_V_POL_TERMINAL )  
             AND ( P_I_V_DIRECTION IS NULL 
                    OR rid.DEPOT = P_I_V_DEPOT )
             AND ( P_I_V_DEL IS NULL 
                    OR rid.DEL = P_I_V_DEL );
                  

      IF BL_COUNT = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!');   

        OPEN P_O_REFIGMTABFIND FOR 
          SELECT SYBLNO                              BL_NO, 
                 IDP10.AYIMST                        BL_STATUS, 
                 IDP10.AYISDT                        BL_DATE, 
                 ACT_SERVICE_CODE                    SERVICE, 
                 ACT_VESSEL_CODE                     VESSEL, 
                 ACT_VOYAGE_NUMBER                   VOYAGE, 
                 ACT_PORT_DIRECTION                  DIRECTION, 
                 LOAD_PORT                           POL, 
                 FROM_TERMINAL                       POL_TERMINAL,
                 IDP10.AYDEST                        DEL_VLS,
                 TO_TERMINAL                         DEPOT_VLS,
                 DISCHARGE_PORT                      POD, 
                 TO_TERMINAL                         POD_TERMINAL, 
                 TO_TERMINAL                         TERMINAL, 
                 (SELECT A.PARTNER_VALUE 
                  FROM   EDI_TRANSLATION_DETAIL A 
                  WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                       FROM   EDI_TRANSLATION_HEADER ETH 
                                       WHERE  ETH.STANDARD = 'EDIFACT' 
                                              AND ETH.CODE_SET = 'IGMTML') 
                         AND A.SEALINER_VALUE = TO_TERMINAL 
                         AND ROWNUM < 2)             CUST_CODE, 
                 (SELECT A.VSCLSN 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = P_I_V_VESSEL 
                         AND ROWNUM < 2)             CALL_SIGN, 
                 (SELECT LOYD_NO 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = P_I_V_VESSEL 
                         AND ROWNUM < 2)             IMO_CODE, 
                 (SELECT A.PARTNER_VALUE 
                  FROM   EDI_TRANSLATION_DETAIL A 
                  WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                       FROM   EDI_TRANSLATION_HEADER ETH 
                                       WHERE  ETH.STANDARD = 'EDIFACT' 
                                              AND ETH.CODE_SET = 'AGENT_CODE') 
                         AND A.SEALINER_VALUE =P_I_V_POD)        AGENT_CODE, 
                 (SELECT A.PARTNER_VALUE 
                  FROM   EDI_TRANSLATION_DETAIL A 
                  WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                       FROM   EDI_TRANSLATION_HEADER ETH 
                                       WHERE  ETH.STANDARD = 'EDIFACT' 
                                              AND ETH.CODE_SET = 'IGMLINECD') 
                         AND A.SEALINER_VALUE = TO_TERMINAL 
                         AND ROWNUM < 2)             LINE_CODE, 
                 (SELECT VVPCAL 
                  FROM   (SELECT VVPCAL 
                          FROM   SEALINER.ITP063 
                          WHERE  VVVESS = P_I_V_VESSEL 
                                 AND VVVERS = 99 
                                 AND ( VVARDT 
                                       ||NVL(LPAD(VVARTM, 4, 0), '0000') ) <= 
                                     (SELECT 
                                     VVARDT 
                                     ||NVL( 
                                       LPAD(VVARTM, 4, 0), 
                                                 '0000') 
                                     AS 
                                     ETADATE 
                                     FROM 
                                     SEALINER.ITP063 
                                     WHERE 
                                     VVPCAL = P_I_V_POD
                                            AND (P_I_V_SERVICE IS NULL
                                                    or VVSRVC =P_I_V_SERVICE)
                                     AND VVVESS = P_I_V_VESSEL 
                                     AND VVVOYN = P_I_V_VOYAGE 
                                     AND ( 
                                         P_I_V_POD_TERMINAL IS 
                                         NULL 
                                          OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                                                 AND VVVERS = 99 
                                                 AND OMMISSION_FLAG IS NULL 
                                                 AND VVFORL IS NOT NULL) 
                                 AND OMMISSION_FLAG IS NULL 
                                 AND VVFORL IS NOT NULL 
                                 AND ( VVPCAL, VVTRM1 ) NOT IN 
                                     (SELECT VVPCAL, 
                                             VVTRM1 
                                      FROM   SEALINER.ITP063 
                                      WHERE  VVPCAL = P_I_V_POD
                                             AND (P_I_V_SERVICE IS NULL
                                                     or VVSRVC =P_I_V_SERVICE)
                                             AND VVVESS = P_I_V_VESSEL 
                                             AND VVVOYN = P_I_V_VOYAGE 
                                             AND ( 
                                     P_I_V_POD_TERMINAL IS NULL 
                                      OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                                             AND VVVERS = 99 
                                             AND OMMISSION_FLAG IS NULL 
                                             AND VVFORL IS NOT NULL) 
                          ORDER  BY VVARDT 
                                    ||NVL(LPAD(VVARTM, 4, 0), '0000') DESC, 
                                    VVPCSQ DESC) 
                  WHERE  ROWNUM = 1)                 PORT_ORIGIN, 
                 ''                                  PORT_ARRIVAL, 
                 TEMP_LAST_PORT_1                              LAST_PORT_1,     --  -3
                 TEMP_LAST_PORT_2                              LAST_PORT_2,     --  -2
                 TEMP_LAST_PORT_3                              LAST_PORT_3,     --  -1
                 --new field
                 TEMP_NEXT_PORT_1                                       NEXT_PORT_4,     --  -1
                 TEMP_NEXT_PORT_2                                       NEXT_PORT_5,     --  -2
                 TEMP_NEXT_PORT_3                                       NEXT_PORT_6,     --  -3
                 -- end
                 'Containerised'                     VESSEL_TYPE, 
                 'containers'                        GEN_DESC, 
                 ''                                  MASTER_NAME, 
                 (SELECT VSCNCD 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = P_I_V_VESSEL 
                         AND ROWNUM < 2)             VESSEL_NATION, 
                 ''                                  IGM_NUMBER, 
                 ''                                  IGM_DATE, 
                 (SELECT VVAPDT 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD
                         AND (P_I_V_SERVICE IS NULL
                                or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2)             ARRIVAL_DATE, 
                 (SELECT VVAPTM 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD 
                         AND (P_I_V_SERVICE IS NULL
                              or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2)             ARRIVAL_TIME,
                  ''                             ARRIVAL_DATE_ATA,
                  ''                             ARRIVAL_TIME_ATA,
                  --NEW MANIFENT FILE CR 14/111/2019
                  ''                        DEP_MANIF_NO,
                  ''                        DEP_MANIFEST_DATE,
                  ''                        SUBMITTER_TYPE,
                    (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMSUBMITC'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)  -- fsc 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                     SUBMITTER_CODE,
                    (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMAUTHREP'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)  -- fsc 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                    AUTHORIZ_REP_CODE,
                  ''                        SHIPPING_LINE_BOND_NO_R,
                  ''                        MODE_OF_TRANSPORT,
                  ''                        SHIP_TYPE,
                  ''                        CONVEYANCE_REFERENCE_NO,
                  ''                        TOL_NO_OF_TRANS_EQU_MANIF,
                  ''                        CARGO_DESCRIPTION,
                  ''                        BRIEF_CARGO_DES,
                  (SELECT vvdpdt 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD
                         AND (P_I_V_SERVICE IS NULL
                                or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2)                        EXPECTED_DATE,
                  (SELECT vvdptm 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD 
                         AND (P_I_V_SERVICE IS NULL
                              or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2)                        TIME_OF_DEPT,      
                  
                  ''                        TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
                  ''                        MESSAGE_TYPE,
                  'UD'                      VESSEL_TYPE_MOVEMENT,
                    (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMAUTHSEA'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)   -- fsc from port 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                 AUTHORIZED_SEA_CARRIER_CODE,
                  (SELECT PORT_OF_REGISTRY 
                  FROM SEALINER.ITP060 
                  WHERE VSRCST='A' AND 
                  VSVESS= P_I_V_VESSEL)     PORT_OF_REGISTRY,
                  (select FLAG_EFF_DATE
                  from sealiner.ITP060
                  where VSRCST='A' 
                  AND VSVESS= P_I_V_VESSEL)        REGISTRY_DATE,
                  'R D'                     VOYAGE_DETAILS,
                  'R D'                     SHIP_ITINERARY_SEQUENCE,
                  'R D'                     SHIP_ITINERARY,
                  (select PINAME from itp040 
                  where PIRCST='A' 
                  AND PICODE=P_I_V_POD )                    PORT_OF_CALL_NAME,
                  'D R'                     ARRIVAL_DEPARTURE_DETAILS,
                  'Q R'                     TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                  
                  --END MANIFENT FILE CR 14/111/2019
                  ''                             NEW_VOYAGE,
                  ''                             NEW_VESSEL,
                  (SELECT PARTNER_VALUE
                  FROM EDI_TRANSLATION_DETAIL 
                  WHERE ETH_UID IN (
                  SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                  WHERE CODE_SET='IGMTML'
                  ) AND SEALINER_VALUE=TEMP_POD_TERMINAL AND ROWNUM=1)            CUSTOM_TERMINAL_CODE, 
                 (SELECT GROSS_TON_INTER 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = P_I_V_VESSEL 
                         AND ROWNUM < 2)             GROSS_WEIGHT, 
                 (SELECT NET_TON_INTER 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = IDP5.ACT_VESSEL_CODE 
                         AND ROWNUM < 2)             NET_WEIGHT, 
                 '0'                                 TOTAL_BLS, 
                 ''                                  LIGHT_DUE, 
                 'N'                                 SM_BT_CARGO, 
                 'N'                                 SHIP_STR_DECL, 
                 ''                                 CREW_LST_DECL, 
                 'N'                                 CARGO_DECL, 
                 'N'                                 PASSNGR_LIST, 
                 'N'                                 CREW_EFFECT, 
                 'N'                                 MARITIME_DECL, 
                 ''                                  ITEM_NUMBER, 
                 'C'                                 CARGO_NATURE, 
                 CASE 
                   WHEN AYMPOD = AYDEST THEN 'LC' 
                   ELSE 'TI' 
                 END                                 CARGO_MOVMNT, 
                 'OT'                                ITEM_TYPE, 
                 'FCL'                               CARGO_MOVMNT_TYPE, 
                 (SELECT 
                        CASE
                           WHEN BT.TRANSPORT_MODE='T' THEN 'R'
                           WHEN BT.TRANSPORT_MODE='R' THEN 'T'
                        END   
                  FROM   IDP005 BT 
                  WHERE  BT.SYBLNO = IDP5.SYBLNO 
                         AND BT.VOYAGE_SEQ <> 1 
                         AND BT.TRANSPORT_MODE IN ( 'T', 'R' ) 
                         AND ROWNUM < 2)             TRANSPORT_MODE, 
                 ''                                  ROAD_CARR_CODE, 
                 ''                                  ROAD_TP_BOND_NO, 
                 ''                                  SUBMIT_DATE_TIME, 
                 ''                           DPD_MOVEMENT,
                 ''                           DPD_CODE,
                 (SELECT MA_SEQ_NO 
                  FROM   RCLTBLS.DEX_BL_HEADER A 
                  WHERE  DN_POD = P_I_V_POD
                         AND DISCHARGE_VESSEL = P_I_V_VESSEL 
                         AND DISCHARGE_VOYAGE = P_I_V_VOYAGE 
                         AND PK_BL_NO = IDP5.SYBLNO    
                         AND ROWNUM < 2)             BL_VERSION,
                (SELECT ADDRESS_LINE_1 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =SYBLNO
                 and customer_type='C' AND ROWNUM=1)                                 CUSTOMERS_ADDRESS_1,
                 (SELECT ADDRESS_LINE_2 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =SYBLNO
                 and customer_type='C' AND ROWNUM=1)                                  CUSTOMERS_ADDRESS_2,
                (SELECT ADDRESS_LINE_3 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =SYBLNO
                 and customer_type='C' AND ROWNUM=1)                                 CUSTOMERS_ADDRESS_3,
                (SELECT ADDRESS_LINE_4 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =SYBLNO
                 and customer_type='C' AND ROWNUM=1)                                  CUSTOMERS_ADDRESS_4,  
                 ''                                                      COLOR_FLAG,
                (SELECT   
                SUM(EYMTWT)  
                FROM IDP055 i
                WHERE 
                EYBLNO =SYBLNO )                                    NET_WEIGHT_METRIC,
                 (SELECT sum (EYPCKG) 
                 from IDP055 WHERE 
                 EYBLNO=SYBLNO )                                          NET_PACKAGE,
                 --new bl section fielsd 
                ''															    CONSOLIDATED_INDICATOR,
                ''															    PREVIOUS_DECLARATION,	
                ''															    CONSOLIDATOR_PAN,
                ''															    CIN_TYPE,
                'UD'															    MCIN,
                ''															    CSN_SUBMITTED_TYPE,
                ''															    CSN_SUBMITTED_BY,
                ''                                                              CSN_REPORTING_TYPE,
                ''															    CSN_SITE_ID,
                ''															    CSN_NUMBER,
                ''                                                              CSN_DATE,
                ''                                                              PREVIOUS_MCIN,
                ''                                                              SPLIT_INDICATOR,
                (SELECT sum (EYPCKG) 
                 from IDP055 WHERE 
                 EYBLNO=SYBLNO AND ROWNUM=1)                                                 NUMBER_OF_PACKAGES, --need to discuss
                (select PARTNER_VALUE 
                from sealiner.EDI_TRANSLATION_HEADER hdr,
                sealiner.EDI_TRANSLATION_DETAIL dtl,
                RCLTBLS.DEX_BL_COMMODITY bl 
                where  hdr.CODE_SET='IGMPKGKIND' 
                and hdr.ETH_UID=dtl.ETH_UID
                and DN_PACKAGE_KIND=SEALINER_VALUE 
                and bl.FK_BL_NO= SYBLNO  AND ROWNUM=1)                          TYPE_OF_PACKAGE,
                (select PARTNER_VALUE from sealiner.EDI_TRANSLATION_HEADER hdr
                ,sealiner.EDI_TRANSLATION_DETAIL dtl  
                where  hdr.CODE_SET='IGMPORT' and hdr.ETH_UID=dtl.ETH_UID
                and  SEALINER_VALUE=P_I_V_POD AND ROWNUM=1)                                  FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
                ''                                                              TYPE_OF_CARGO,
                ''                                                              SPLIT_INDICATOR_LIST,
                (select  DN_POL     from RCLTBLS.DEX_BL_HEADER 
                where PK_BL_NO=SYBLNO AND ROWNUM=1)                                          PORT_OF_ACCEPTANCE,
               (SELECT PARTNER_VALUE            
                  FROM EDI_TRANSLATION_DETAIL 
                WHERE ETH_UID IN (               
                SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                                  WHERE CODE_SET='IGMDEL'
                  ) AND SEALINER_VALUE= TO_TERMINAL  AND ROWNUM=1 and RECORD_STATUS='A')                                        PORT_OF_RECEIPT,
                ''                                                              UCR_TYPE,
                ''                                                              UCR_CODE,
                
              --  ''                                                              EQUIPMENT_SEAL_TYPE,
               
                ''                                                              PORT_OF_ACCEPTANCE_NAME,
                (select TQTRNM DEPOT_NAME 
                from ITP130 where TQTERM=TO_TERMINAL-- del FROM bl 
                AND    TQRCST='A')                                                PORT_OF_RECEIPT_NAME,
                (select FEDERAL_TAX_ID PAN from sealiner.ITP010
                WHERE  CURCST='A' 
                AND CUCUST=(select FK_CUSTOMER_CODE 
                from RCLTBLS.DEX_BL_CUSTOMERS 
                WHERE CUSTOMER_TYPE IN('N','1','2','3') 
                AND FK_BL_NO =SYBLNO)AND ROWNUM=1 )                                             PAN_OF_NOTIFIED_PARTY,
                (select STMTWT from sealiner.ITP0TD where SGTRAD='*')               UNIT_OF_WEIGHT,
                'GV'                                                                GROSS_VOLUME,
                'UOV'                                                               UNIT_OF_VOLUME,
                'CISN'                                                              CARGO_ITEM_SEQUENCE_NO,
                (select BYRMKS from IDP050 where BYBLNO=SYBLNO AND ROWNUM=1)                     CARGO_ITEM_DESCRIPTION,
                'noph'                                                              NUMBER_OF_PACKAGES_HID,
                (select PARTNER_VALUE 
                from sealiner.EDI_TRANSLATION_HEADER hdr,
                sealiner.EDI_TRANSLATION_DETAIL dtl,
                RCLTBLS.DEX_BL_COMMODITY bl 
                where  hdr.CODE_SET='IGMPKGKIND' 
                and hdr.ETH_UID=dtl.ETH_UID
                and DN_PACKAGE_KIND=SEALINER_VALUE 
                and bl.FK_BL_NO= SYBLNO AND ROWNUM=1)                              TYPE_OF_PACKAGES_HID,
                'portocsn'                                                          PORT_OF_CALL_SEQUENCE_NUMBER,
                (SELECT VVPCAL FROM (
                SELECT VVPCAL FROM SEALINER.ITP063
                WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99
                AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))<=(
                SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') 
                AS ETADATE FROM SEALINER.ITP063 WHERE
                VVSRVC=ACT_SERVICE_CODE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL )
                AND OMMISSION_FLAG IS NULL
                AND VVFORL IS NOT NULL
                AND (VVPCAL ,VVTRM1) NOT IN
                (SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
                VVSRVC=ACT_SERVICE_CODE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                VVTRM1=TO_TERMINAL AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL)
                ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000')
                DESC,VVPCSQ DESC)WHERE ROWNUM=1)                            PORT_OF_CALL_CODED,
                (SELECT VVPCAL FROM (
                SELECT VVPCAL FROM SEALINER.ITP063 WHERE 
                VVVESS = P_I_V_VESSEL AND VVVERS= 99 
                AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))>=(
                SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000')
                AS ETADATE FROM SEALINER.ITP063 WHERE
                VVSRVC=ACT_SERVICE_CODE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL )
                AND OMMISSION_FLAG IS NULL
                AND VVFORL IS NOT NULL
                AND (VVPCAL ,VVTRM1) NOT IN
                ( SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
                VVSRVC =ACT_SERVICE_CODE AND
                VVPCAL =P_I_V_POD AND
                VVVESS =P_I_V_VESSEL AND
                VVVOYN =P_I_V_VOYAGE AND
                VVTRM1=TO_TERMINAL AND
                --VVPCSQ =PORTSEQUENCE' AND
                VVVERS =99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL)
                ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000'),VVPCSQ)
                WHERE ROWNUM=1)                                                   NEXT_PORT_OF_CALL_CODED,
                'mclc'                                                              MC_LOCATION_CUSTOMS,
                (select  FK_UNNO  from  RCLTBLS.DEX_BL_SPECIAL_CARGO_DTL sp 
                , RCLTBLS.DEX_BL_COMMODITY cm where cm.DN_SPECIAL_HNDL='D1'
                and cm.FK_BL_NO=sp.FK_BL_NO 
                and cm.COMMODITY_SEQ=sp.COMMODITY_SEQ 
                and rownum=1  and cm.FK_BL_NO=SYBLNO AND ROWNUM=1)                               UNO_CODE,
                (select  FK_IMO_CLASS  from  RCLTBLS.DEX_BL_SPECIAL_CARGO_DTL sp
                , RCLTBLS.DEX_BL_COMMODITY cm where cm.DN_SPECIAL_HNDL='D1'
                and cm.FK_BL_NO=sp.FK_BL_NO 
                and cm.COMMODITY_SEQ=sp.COMMODITY_SEQ
                and rownum=1 and cm.FK_BL_NO= SYBLNO AND ROWNUM=1)                               IMDG_CODE,
                ''                                                                  CONTAINER_WEIGHT,
                 --end
                 ''                                  NHAVA_SHEVA_ETA, 
                 FINAL_PLACE_OF_DELIVERY_NAME        FINAL_PLACE_DELIVERY, 
                 ''                                  PACKAGES, 
                 ''                                  CFS_NAME, 
                 ''                                  MBL_NO, 
                 (select FK_HOUSE_BL_NO  from rcltbls.DEX_BL_header 
                 where FK_BOOKING_NO in (
                 SELECT FK_BOOKING_NO FROM    
                 rcltbls.DEX_BL_header where PK_BL_NO= SYBLNO
                 ) and FK_HOUSE_BL_NO IS NOT NULL)                                  HBL_NO, 
                 ''                                  FROM_ITEM_NO, 
                 ''                                  TO_ITEM_NO,
                 ''                                  SRL_NO
          FROM   IDP005 IDP5 
                 INNER JOIN IDP010 IDP10 
                         ON IDP5.SYBLNO = IDP10.AYBLNO 
          WHERE  IDP5.DISCHARGE_PORT = P_I_V_POD 
                 AND ( P_I_V_SERVICE IS NULL 
                        OR IDP5.ACT_SERVICE_CODE = P_I_V_SERVICE ) 
                 AND ( P_I_V_VESSEL IS NULL 
                        OR IDP5.ACT_VESSEL_CODE = P_I_V_VESSEL ) 
                 AND ( P_I_V_VOYAGE IS NULL 
                        OR IDP5.ACT_VOYAGE_NUMBER = P_I_V_VOYAGE ) 
                 AND ( P_I_V_POD_TERMINAL IS NULL 
                        OR IDP5.TO_TERMINAL = P_I_V_POD_TERMINAL ) 
                 AND ( P_I_V_FROM_DATE IS NULL 
                        OR IDP10.AYISDT >= P_I_V_FROM_DATE ) 
                 AND ( P_I_V_TO_DATE IS NULL 
                        OR IDP10.AYISDT <= P_I_V_TO_DATE ) 
                 AND ( IDP10.AYIMST <> 9)   
                 AND ( P_I_V_BL_STATUS IS NULL 
                        OR IDP10.AYIMST = P_I_V_BL_STATUS)        
                 AND ( P_I_V_POL IS NULL 
                        OR IDP5.LOAD_PORT = P_I_V_POL ) 
                 AND ( P_I_V_POL_TERMINAL IS NULL 
                        OR IDP5.FROM_TERMINAL = P_I_V_POL_TERMINAL )   
                 AND ( P_I_V_DEL IS NULL 
                        OR IDP10.AYDEST = P_I_V_DEL ) 
                 AND ( P_I_V_DEPOT IS NULL 
                        OR IDP5.TO_TERMINAL = P_I_V_DEPOT )          
                 
                 AND IDP10.AYSORC = 'C' 
          --AND IDP5.VOYAGE_SEQ<>1    
          --AND IDP5.TRANSPORT_MODE in ('T','R')   
          ; 
      ELSE 
        DBMS_OUTPUT.PUT_LINE('OLD RECORDS FOUND IN SEARCH : ' 
                             || BL_COUNT); 

        OPEN P_O_REFIGMTABFIND FOR 
          SELECT NS.BL_NO                BL_NO, 
                 NS.BL_STATUS            BL_STATUS, 
                 NS.BL_DATE              BL_DATE, 
                 OS.SERVICE              SERVICE, 
                 OS.VESSEL               VESSEL, 
                 OS.VOYAGE               VOYAGE, 
                 OS.DIRECTION            DIRECTION, 
                 OS.POL                  POL, 
                 OS.POL_TERMINAL         POL_TERMINAL,
                 OS.DEL_VLS                        DEL_VLS,
                 OS.DEPOT_VLS                         DEPOT_VLS,
                 OS.POD                  POD, 
                 OS.POD_TERMINAL         POD_TERMINAL, 
                 OS.TERMINAL             TERMINAL, 
                 OS.CUST_CODE            CUST_CODE, 
                 OS.CALL_SIGN            CALL_SIGN, 
                 OS.IMO_CODE             IMO_CODE, 
                 OS.AGENT_CODE           AGENT_CODE, 
                 OS.LINE_CODE            LINE_CODE, 
                 OS.PORT_ORIGIN          PORT_ORIGIN, 
                 OS.PORT_ARRIVAL         PORT_ARRIVAL, 
                 TEMP_LAST_PORT_1                                  LAST_PORT_1, 
                 TEMP_LAST_PORT_2                                  LAST_PORT_2, 
                 TEMP_LAST_PORT_3                                  LAST_PORT_3, 
                 --new field        
                 TEMP_NEXT_PORT_1                                  NEXT_PORT_4,
                 TEMP_NEXT_PORT_2                                  NEXT_PORT_5,
                 TEMP_NEXT_PORT_3                                  NEXT_PORT_6,
                 -- end
                 OS.VESSEL_TYPE          VESSEL_TYPE, 
                 OS.GEN_DESC             GEN_DESC, 
                 OS.MASTER_NAME          MASTER_NAME, 
                 OS.VESSEL_NATION        VESSEL_NATION, 
                 OS.IGM_NUMBER           IGM_NUMBER, 
                 OS.IGM_DATE             IGM_DATE, 
                 OS.ARRIVAL_DATE         ARRIVAL_DATE, 
                 OS.ARRIVAL_TIME         ARRIVAL_TIME,
                 OS.ARRIVAL_DATE_ATA     ARRIVAL_DATE_ATA,
                 OS.ARRIVAL_TIME_ATA     ARRIVAL_TIME_ATA,
                --new added field vessel section
                  ''                        DEP_MANIF_NO,
                  ''                        DEP_MANIFEST_DATE,
                  ''                        SUBMITTER_TYPE,
                    (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMSUBMITC'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)  -- fsc 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                     SUBMITTER_CODE,
                  (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMAUTHREP'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)  -- fsc 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                     AUTHORIZ_REP_CODE,
                  ''                        SHIPPING_LINE_BOND_NO_R,
                  ''                        MODE_OF_TRANSPORT,
                  ''                        SHIP_TYPE,
                  ''                        CONVEYANCE_REFERENCE_NO,
                  ''                        TOL_NO_OF_TRANS_EQU_MANIF,
                  ''                        CARGO_DESCRIPTION,
                  ''                        BRIEF_CARGO_DES,
                 TO_CHAR((SELECT VVDPDT 
                  FROM   ITP063 A     
                  WHERE  VVPCAL = P_I_V_POD
                         AND (P_I_V_SERVICE IS NULL
                                or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2))                         EXPECTED_DATE,
                 TO_CHAR ((SELECT vvdptm 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD 
                         AND (P_I_V_SERVICE IS NULL
                              or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2))                        TIME_OF_DEPT,      
                  
                  (SELECT VVPCAL FROM (
                    SELECT VVPCAL FROM SEALINER.ITP063 WHERE 
                    VVVESS = P_I_V_VESSEL AND VVVERS= 99 AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))<=(
                    SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000')
                    AS ETADATE FROM SEALINER.ITP063 WHERE
                    VVSRVC=OS.SERVICE  AND
                    VVPCAL=P_I_V_POD AND
                    VVVESS=P_I_V_VESSEL AND
                    VVVOYN=P_I_V_VOYAGE AND
                    
                    VVVERS=99 AND
                    OMMISSION_FLAG IS NULL AND
                    VVFORL IS NOT NULL )
                    AND OMMISSION_FLAG IS NULL
                    AND VVFORL IS NOT NULL
                    AND (VVPCAL ,VVTRM1) NOT IN
                    (SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
                    VVSRVC=OS.SERVICE  AND
                    VVPCAL=P_I_V_POD AND
                    VVVESS=P_I_V_VESSEL AND
                    VVVOYN=P_I_V_VOYAGE AND
                    
                    VVVERS=99 AND
                    OMMISSION_FLAG IS NULL AND
                    VVFORL IS NOT NULL)
                    ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000')
                    DESC,VVPCSQ DESC)WHERE ROWNUM=1)                PORT_OF_CALL_COD,
                  ''                        TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
                  ''                        MESSAGE_TYPE,
                  'UD'                      VESSEL_TYPE_MOVEMENT,
                  (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMAUTHSEA'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)   -- fsc from port 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                 AUTHORIZED_SEA_CARRIER_CODE,
                  (SELECT PORT_OF_REGISTRY 
                  FROM SEALINER.ITP060 
                  WHERE VSRCST='A' AND 
                  VSVESS= P_I_V_VESSEL)     PORT_OF_REGISTRY,
                  TO_CHAR((select FLAG_EFF_DATE
                  from sealiner.ITP060
                  where VSRCST='A' 
                  AND VSVESS= P_I_V_VESSEL))        REGISTRY_DATE,
                  'R D'                     VOYAGE_DETAILS,
                  'R D'                     SHIP_ITINERARY_SEQUENCE,
                  'R D'                     SHIP_ITINERARY,
                  (select PINAME from itp040 
                  where PIRCST='A' 
                  AND PICODE=P_I_V_POD)                      PORT_OF_CALL_NAME,
                  'D R'                     ARRIVAL_DEPARTURE_DETAILS,
                  'Q R'                     TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                  --END MANIFENT FILE CR 14/111/2019
                 OS.NEW_VOYAGE           NEW_VOYAGE,
                 OS.NEW_VESSEL           NEW_VESSEL,
                 OS.GROSS_WEIGHT         GROSS_WEIGHT, 
                 OS.NET_WEIGHT           NET_WEIGHT, 
                 OS.TOTAL_BLS            TOTAL_BLS, 
                 OS.LIGHT_DUE            LIGHT_DUE, 
                 OS.SM_BT_CARGO          SM_BT_CARGO, 
                 OS.SHIP_STR_DECL        SHIP_STR_DECL, 
                 ''                      CREW_LST_DECL, 
                 OS.CARGO_DECL           CARGO_DECL, 
                 OS.PASSNGR_LIST         PASSNGR_LIST, 
                 OS.CREW_EFFECT          CREW_EFFECT, 
                 OS.MARITIME_DECL        MARITIME_DECL, 
                 NS.ITEM_NUMBER          ITEM_NUMBER, 
                 NS.CARGO_NATURE         CARGO_NATURE, 
                 NS.CARGO_MOVMNT         CARGO_MOVMNT, 
                 NS.ITEM_TYPE            ITEM_TYPE, 
                 NS.CARGO_MOVMNT_TYPE    CARGO_MOVMNT_TYPE, 
                 NS.TRANSPORT_MODE       TRANSPORT_MODE, 
                 NS.ROAD_CARR_CODE       ROAD_CARR_CODE, 
                 NS.ROAD_TP_BOND_NO      ROAD_TP_BOND_NO, 
                 NS.SUBMIT_DATE_TIME     SUBMIT_DATE_TIME, 
                 
                 OS.NHAVA_SHEVA_ETA      NHAVA_SHEVA_ETA, 
                 OS.FINAL_PLACE_DELIVERY FINAL_PLACE_DELIVERY, 
                 OS.PACKAGES             PACKAGES, 
                 ''                      CFS_NAME, 
                 OS.MBL_NO               MBL_NO, 
                 OS.HBL_NO               HBL_NO, 
                 OS.FROM_ITEM_NO         FROM_ITEM_NO, 
                 OS.TO_ITEM_NO           TO_ITEM_NO,
                 OS.SRL_NO               SRL_NO,
                 ''                           DPD_MOVEMENT,
                 ''                           DPD_CODE,                         
                                 
                 ( SELECT TO_CHAR(MA_SEQ_NO) 
                  FROM   RCLTBLS.DEX_BL_HEADER A 
                  WHERE  DN_POD = P_I_V_POD  
                         AND DISCHARGE_VESSEL = P_I_V_VESSEL 
                         AND DISCHARGE_VOYAGE = P_I_V_VOYAGE 
                         AND PK_BL_NO =NS.BL_NO    
                         AND ROWNUM < 2)                                BL_VERSION,
                (SELECT PARTNER_VALUE
                  FROM EDI_TRANSLATION_DETAIL 
                  WHERE ETH_UID IN (
                  SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                  WHERE CODE_SET='IGMTML'
                  ) AND SEALINER_VALUE= TEMP_POD_TERMINAL AND ROWNUM=1)                    CUSTOM_TERMINAL_CODE,
                 (SELECT ADDRESS_LINE_1 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =NS.BL_NO 
                 and customer_type='C')                                  CUSTOMERS_ADDRESS_1,
                 (SELECT ADDRESS_LINE_2 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =NS.BL_NO 
                 and customer_type='C')                                  CUSTOMERS_ADDRESS_2,
                 (SELECT ADDRESS_LINE_3 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =NS.BL_NO 
                 and customer_type='C')                                 CUSTOMERS_ADDRESS_3,
                 (SELECT ADDRESS_LINE_4 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =NS.BL_NO 
                 and customer_type='C')                                  CUSTOMERS_ADDRESS_4,
                 ''                                  COLOR_FLAG,
                 (SELECT   
                 SUM(EYMTWT)  
                 FROM IDP055 i
                 WHERE 
                 EYBLNO=NS.BL_NO)                                    NET_WEIGHT_METRIC,
                 (SELECT sum (EYPCKG) 
                 from IDP055 WHERE 
                 EYBLNO=NS.BL_NO)                                          NET_PACKAGE,
                  --new bl section fielsd 
          
                ''															    CONSOLIDATED_INDICATOR,
                ''															    PREVIOUS_DECLARATION,	
                ''															    CONSOLIDATOR_PAN,
                ''															    CIN_TYPE,
                'UD'															    MCIN,
                ''															    CSN_SUBMITTED_TYPE,
                ''															    CSN_SUBMITTED_BY,
                ''                                                              CSN_REPORTING_TYPE,
                ''															    CSN_SITE_ID,
                ''															    CSN_NUMBER,
                ''                                                              CSN_DATE,
                ''                                                              PREVIOUS_MCIN,
                ''                                                              SPLIT_INDICATOR,
                TO_CHAR((SELECT sum (EYPCKG) 
                 from IDP055 WHERE 
                 EYBLNO=NS.BL_NO))                                                 NUMBER_OF_PACKAGES, --need to discuss
                (select PARTNER_VALUE 
                from sealiner.EDI_TRANSLATION_HEADER hdr,
                sealiner.EDI_TRANSLATION_DETAIL dtl,
                RCLTBLS.DEX_BL_COMMODITY bl 
                where  hdr.CODE_SET='IGMPKGKIND' 
                and hdr.ETH_UID=dtl.ETH_UID
                and DN_PACKAGE_KIND=SEALINER_VALUE 
                and bl.FK_BL_NO= NS.BL_NO  and rownum=1)                          TYPE_OF_PACKAGE,
                (select PARTNER_VALUE from sealiner.EDI_TRANSLATION_HEADER hdr
                ,sealiner.EDI_TRANSLATION_DETAIL dtl  
                where  hdr.CODE_SET='IGMPORT' and hdr.ETH_UID=dtl.ETH_UID
                and  SEALINER_VALUE=P_I_V_POD)                                  FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
                ''                                                              TYPE_OF_CARGO,
                ''                                                              SPLIT_INDICATOR_LIST,
                (select  DN_POL     from RCLTBLS.DEX_BL_HEADER 
                where PK_BL_NO=NS.BL_NO)                                          PORT_OF_ACCEPTANCE,
                 (SELECT PARTNER_VALUE            
                  FROM EDI_TRANSLATION_DETAIL 
                WHERE ETH_UID IN (               
                SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                                  WHERE CODE_SET='IGMDEL'
                  ) AND SEALINER_VALUE= OS.POD_TERMINAL  AND ROWNUM=1 and RECORD_STATUS='A')                                        PORT_OF_RECEIPT,
                ''                                                              UCR_TYPE,
                ''                                                              UCR_CODE,
                
              --  ''                                                              EQUIPMENT_SEAL_TYPE,
                
                ''                                                              PORT_OF_ACCEPTANCE_NAME,
                 (select TQTRNM DEPOT_NAME 
                from ITP130 where TQTERM=OS.POD_TERMINAL-- del FROM bl 
                AND    TQRCST='A')                                                        PORT_OF_RECEIPT_NAME,
                (select FEDERAL_TAX_ID PAN from sealiner.ITP010
                WHERE  CURCST='A' 
                AND CUCUST=(select FK_CUSTOMER_CODE 
                from RCLTBLS.DEX_BL_CUSTOMERS 
                WHERE CUSTOMER_TYPE IN('N','1','2','3') 
                AND FK_BL_NO =NS.BL_NO) AND ROWNUM=1 )                                             PAN_OF_NOTIFIED_PARTY,
                (select STMTWT from sealiner.ITP0TD where SGTRAD='*')               UNIT_OF_WEIGHT,
                'GV'                                                                GROSS_VOLUME,
                'UOV'                                                               UNIT_OF_VOLUME,
                'CISN'                                                              CARGO_ITEM_SEQUENCE_NO,
                (select BYRMKS from IDP050 where BYBLNO=NS.BL_NO)                     CARGO_ITEM_DESCRIPTION,
                'noph'                                                              NUMBER_OF_PACKAGES_HID,
                (select PARTNER_VALUE 
                from sealiner.EDI_TRANSLATION_HEADER hdr,
                sealiner.EDI_TRANSLATION_DETAIL dtl,
                RCLTBLS.DEX_BL_COMMODITY bl 
                where  hdr.CODE_SET='IGMPKGKIND' 
                and hdr.ETH_UID=dtl.ETH_UID
                and DN_PACKAGE_KIND=SEALINER_VALUE 
                and bl.FK_BL_NO= NS.BL_NO  and rownum=1)                              TYPE_OF_PACKAGES_HID,
                'portocsn'                                                          PORT_OF_CALL_SEQUENCE_NUMBER,
                 (SELECT VVPCAL FROM (
                SELECT VVPCAL FROM SEALINER.ITP063
                WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99
                AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))<=(
                SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') 
                AS ETADATE FROM SEALINER.ITP063 WHERE
                VVSRVC=OS.SERVICE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL )
                AND OMMISSION_FLAG IS NULL
                AND VVFORL IS NOT NULL
                AND (VVPCAL ,VVTRM1) NOT IN
                (SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
                VVSRVC=OS.SERVICE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                VVTRM1=OS.POD_TERMINAL AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL)
                ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000')
                DESC,VVPCSQ DESC)WHERE ROWNUM=1)                            PORT_OF_CALL_CODED,
                (SELECT VVPCAL FROM (
                SELECT VVPCAL FROM SEALINER.ITP063 WHERE 
                VVVESS = P_I_V_VESSEL AND VVVERS= 99 
                AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))>=(
                SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000')
                AS ETADATE FROM SEALINER.ITP063 WHERE
                VVSRVC=OS.SERVICE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL )
                AND OMMISSION_FLAG IS NULL
                AND VVFORL IS NOT NULL
                AND (VVPCAL ,VVTRM1) NOT IN
                ( SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
                VVSRVC =OS.SERVICE AND
                VVPCAL =P_I_V_POD AND
                VVVESS =P_I_V_VESSEL AND
                VVVOYN =P_I_V_VOYAGE AND
                VVTRM1=OS.POD_TERMINAL AND
                --VVPCSQ =PORTSEQUENCE' AND
                VVVERS =99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL)
                ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000'),VVPCSQ)
                WHERE ROWNUM=1)                                                   NEXT_PORT_OF_CALL_CODED,
                'mclc'                                                              MC_LOCATION_CUSTOMS,
                (select  FK_UNNO  from  RCLTBLS.DEX_BL_SPECIAL_CARGO_DTL sp 
                , RCLTBLS.DEX_BL_COMMODITY cm where cm.DN_SPECIAL_HNDL='D1'
                and cm.FK_BL_NO=sp.FK_BL_NO 
                and cm.COMMODITY_SEQ=sp.COMMODITY_SEQ 
                and rownum=1  and cm.FK_BL_NO=NS.BL_NO)                               UNO_CODE,
                (select  FK_IMO_CLASS  from  RCLTBLS.DEX_BL_SPECIAL_CARGO_DTL sp
                , RCLTBLS.DEX_BL_COMMODITY cm where cm.DN_SPECIAL_HNDL='D1'
                and cm.FK_BL_NO=sp.FK_BL_NO 
                and cm.COMMODITY_SEQ=sp.COMMODITY_SEQ
                and rownum=1 and cm.FK_BL_NO= NS.BL_NO)                               IMDG_CODE,
                ''                                                                  CONTAINER_WEIGHT
                 --end
                 
          FROM   (SELECT SYBLNO                              BL_NO, 
                         IDP10.AYIMST                        BL_STATUS, 
                         IDP10.AYISDT                        BL_DATE, 
                         ACT_SERVICE_CODE                    SERVICE, 
                         ACT_VESSEL_CODE                     VESSEL, 
                         ACT_VOYAGE_NUMBER                   VOYAGE, 
                         ACT_PORT_DIRECTION                  DIRECTION, 
                         LOAD_PORT                           POL, 
                         FROM_TERMINAL                       POL_TERMINAL,
                         IDP10.AYDEST                        DEL_VLS,
                         TO_TERMINAL                         DEPOT_VLS,
                         DISCHARGE_PORT                      POD, 
                         TO_TERMINAL                         POD_TERMINAL, 
                         TO_TERMINAL                         TERMINAL, 
                         (SELECT A.PARTNER_VALUE 
                          FROM   EDI_TRANSLATION_DETAIL A 
                          WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                               FROM   EDI_TRANSLATION_HEADER ETH 
                                               WHERE  ETH.STANDARD = 'EDIFACT' 
                                                      AND ETH.CODE_SET = 
                                                          'IGMTML' 
                                              ) 
                                 AND A.SEALINER_VALUE = TO_TERMINAL 
                                 AND ROWNUM < 2)             CUST_CODE, 
                         (SELECT A.VSCLSN 
                          FROM   ITP060 A 
                          WHERE  A.VSVESS = P_I_V_VESSEL 
                                 AND ROWNUM < 2)             CALL_SIGN, 
                         (SELECT LOYD_NO 
                          FROM   ITP060 A 
                          WHERE  A.VSVESS = P_I_V_VESSEL 
                                 AND ROWNUM < 2)             IMO_CODE, 
                         (SELECT A.PARTNER_VALUE 
                  FROM   EDI_TRANSLATION_DETAIL A 
                  WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                       FROM   EDI_TRANSLATION_HEADER ETH 
                                       WHERE  ETH.STANDARD = 'EDIFACT' 
                                              AND ETH.CODE_SET = 'AGENT_CODE') 
                         AND A.SEALINER_VALUE =P_I_V_POD)        AGENT_CODE, 
                         (SELECT A.PARTNER_VALUE 
                          FROM   EDI_TRANSLATION_DETAIL A 
                          WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                               FROM   EDI_TRANSLATION_HEADER ETH 
                                               WHERE  ETH.STANDARD = 'EDIFACT' 
                                                      AND ETH.CODE_SET = 
                                                          'IGMLINECD') 
                                 AND A.SEALINER_VALUE = P_I_V_POD_TERMINAL 
                                 AND ROWNUM < 2)             LINE_CODE, 
                         (SELECT VVPCAL 
                          FROM 
                 (SELECT VVPCAL 
                  FROM   SEALINER.ITP063 
                  WHERE  VVVESS = P_I_V_VESSEL 
                         AND VVVERS = 99 
                         AND ( VVARDT 
                               ||NVL(LPAD(VVARTM, 4, 0), '0000') ) 
                             <= 
                             (SELECT 
                             VVARDT 
                             ||NVL( 
                               LPAD(VVARTM, 4, 0), 
                                         '0000') 
                             AS 
                             ETADATE 
                             FROM 
                             SEALINER.ITP063 
                             WHERE 
                             VVSRVC = P_I_V_SERVICE 
                             AND VVPCAL = P_I_V_POD 
                             AND VVVESS = P_I_V_VESSEL 
                             AND VVVOYN = P_I_V_VOYAGE 
                             AND ( 
                                 P_I_V_POD_TERMINAL IS 
                                 NULL 
                                  OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                                         AND VVVERS = 99 
                                         AND OMMISSION_FLAG IS 
                                             NULL 
                                         AND VVFORL IS NOT NULL) 
                         AND OMMISSION_FLAG IS NULL 
                         AND VVFORL IS NOT NULL 
                         AND ( VVPCAL, VVTRM1 ) NOT IN 
                             (SELECT VVPCAL, 
                                     VVTRM1 
                              FROM   SEALINER.ITP063 
                              WHERE  VVSRVC = P_I_V_SERVICE 
                                     AND VVPCAL = P_I_V_POD 
                                     AND VVVESS = P_I_V_VESSEL 
                                     AND VVVOYN = P_I_V_VOYAGE 
                                     AND ( 
                             P_I_V_POD_TERMINAL IS NULL 
                              OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                                     AND VVVERS = 99 
                                     AND OMMISSION_FLAG IS NULL 
                                     AND VVFORL IS NOT NULL) 
                  ORDER  BY VVARDT 
                            ||NVL(LPAD(VVARTM, 4, 0), '0000') DESC 
                            , 
                            VVPCSQ DESC) 
                          WHERE  ROWNUM = 1)                 PORT_ORIGIN, 
                         ''                                  PORT_ARRIVAL, 
                         ''                                  LAST_PORT_1, 
                         ''                                  LAST_PORT_2, 
                         ''                                  LAST_PORT_3, 
                         'Containerised'                     VESSEL_TYPE, 
                         'containers'                        GEN_DESC, 
                         ''                                  MASTER_NAME, 
                         (SELECT VSCNCD 
                          FROM   ITP060 A 
                          WHERE  A.VSVESS = P_I_V_VESSEL 
                                 AND ROWNUM < 2)             VESSEL_NATION, 
                         ''                                  IGM_NUMBER, 
                         ''                                  IGM_DATE, 
                         (SELECT VVAPDT 
                          FROM   ITP063 A 
                          WHERE  VVSRVC = P_I_V_SERVICE 
                                 AND VVPCAL = P_I_V_POD 
                                 AND VVVESS = P_I_V_VESSEL 
                                 AND VVVOYN = P_I_V_VOYAGE 
                                 AND ( P_I_V_POD_TERMINAL IS NULL 
                                        OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                                 AND A.VVVERS = 99 
                                 AND A.VVFORL IS NOT NULL 
                                 AND A.OMMISSION_FLAG IS NULL 
                                 AND ROWNUM < 2)             ARRIVAL_DATE, 
                         (SELECT VVAPTM 
                          FROM   ITP063 A 
                          WHERE  VVSRVC = P_I_V_SERVICE 
                                 AND VVPCAL = P_I_V_POD 
                                 AND VVVESS = P_I_V_VESSEL 
                                 AND VVVOYN = P_I_V_VOYAGE 
                                 AND ( P_I_V_POD_TERMINAL IS NULL 
                                        OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                                 AND A.VVVERS = 99 
                                 AND A.VVFORL IS NOT NULL 
                                 AND A.OMMISSION_FLAG IS NULL 
                                 AND ROWNUM < 2)             ARRIVAL_TIME, 
                          '' ARRIVAL_DATE_ATA,
                          '' ARRIVAL_TIME_ATA,
                          '' NEW_VOYAGE,
                          '' NEW_VESSEL,
                         (SELECT GROSS_TON_INTER 
                          FROM   ITP060 A 
                          WHERE  A.VSVESS = P_I_V_VESSEL 
                                 AND ROWNUM < 2)             GROSS_WEIGHT, 
                         (SELECT NET_TON_INTER 
                          FROM   ITP060 A 
                          WHERE  A.VSVESS = IDP5.ACT_VESSEL_CODE 
                                 AND ROWNUM < 2)             NET_WEIGHT, 
                         '0'                                 TOTAL_BLS, 
                         ''                                  LIGHT_DUE, 
                         'N'                                 SM_BT_CARGO, 
                         'N'                                 SHIP_STR_DECL, 
                         'N'                                 CREW_LST_DECL, 
                         'N'                                 CARGO_DECL, 
                         'N'                                 PASSNGR_LIST, 
                         'N'                                 CREW_EFFECT, 
                         'N'                                 MARITIME_DECL, 
                         ''                                  ITEM_NUMBER, 
                         'C'                                 CARGO_NATURE, 
                         CASE 
                           WHEN AYMPOD = AYDEST THEN 'LC' 
                           ELSE 'TI' 
                         END                                 CARGO_MOVMNT, 
                         'OT'                                ITEM_TYPE, 
                         'FCL'                               CARGO_MOVMNT_TYPE, 
                         (SELECT 
								CASE
									WHEN BT.TRANSPORT_MODE='T' THEN 'R'
									WHEN BT.TRANSPORT_MODE='R' THEN 'T'
								END  
                          FROM   IDP005 BT 
                          WHERE  BT.SYBLNO = IDP5.SYBLNO 
                                 AND BT.VOYAGE_SEQ <> 1 
                                 AND BT.TRANSPORT_MODE IN ( 'T', 'R' ) 
                                 AND ROWNUM < 2)             TRANSPORT_MODE, 
                         ''                                  ROAD_CARR_CODE, 
                         ''                                  ROAD_TP_BOND_NO, 
                         ''                                  SUBMIT_DATE_TIME, 
                         ''                                  NHAVA_SHEVA_ETA, 
                         
                         FINAL_PLACE_OF_DELIVERY_NAME 
                         FINAL_PLACE_DELIVERY, 
                         ''                                  PACKAGES,
                         ''                                  MBL_NO, 
                         (select FK_HOUSE_BL_NO  from rcltbls.DEX_BL_header 
                         where FK_BOOKING_NO in (
                        SELECT FK_BOOKING_NO FROM    
                        rcltbls.DEX_BL_header where PK_BL_NO= SYBLNO
                        ) and FK_HOUSE_BL_NO IS NOT NULL)                                  HBL_NO, 
                         ''                                  FROM_ITEM_NO, 
                         ''                                  TO_ITEM_NO 
                  FROM   IDP005 IDP5 
                         INNER JOIN IDP010 IDP10 
                                 ON IDP5.SYBLNO = IDP10.AYBLNO 
                  WHERE  IDP5.DISCHARGE_PORT = P_I_V_POD 
                         AND ( P_I_V_SERVICE IS NULL 
                                OR IDP5.ACT_SERVICE_CODE = P_I_V_SERVICE ) 
                         AND ( P_I_V_VESSEL IS NULL 
                                OR IDP5.ACT_VESSEL_CODE = P_I_V_VESSEL ) 
                         AND ( P_I_V_VOYAGE IS NULL 
                                OR IDP5.ACT_VOYAGE_NUMBER = P_I_V_VOYAGE ) 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR IDP5.TO_TERMINAL = P_I_V_POD_TERMINAL ) 
                         AND ( P_I_V_FROM_DATE IS NULL 
                                OR IDP10.AYISDT >= P_I_V_FROM_DATE ) 
                         AND ( P_I_V_TO_DATE IS NULL 
                                OR IDP10.AYISDT <= P_I_V_TO_DATE ) 
                         AND ( IDP10.AYIMST <> 9)   
                         AND ( P_I_V_BL_STATUS IS NULL 
                                OR IDP10.AYIMST = P_I_V_BL_STATUS)  
                         AND ( P_I_V_POL IS NULL 
                                OR IDP5.LOAD_PORT = P_I_V_POL ) 
                         AND ( P_I_V_POL_TERMINAL IS NULL 
                                OR IDP5.FROM_TERMINAL = P_I_V_POL_TERMINAL )
                         AND ( P_I_V_DEL IS NULL 
                                OR IDP5.DISCHARGE_PORT = P_I_V_DEL ) 
                        AND ( P_I_V_DEPOT IS NULL 
                                OR IDP5.TO_TERMINAL = P_I_V_DEPOT )         
                         
                         AND IDP10.AYSORC = 'C' 
                         --AND IDP5.VOYAGE_SEQ<>1    
                         --AND IDP5.TRANSPORT_MODE in ('T','R')   
                         AND IDP5.SYBLNO NOT IN (SELECT BL_NO 
                                                 FROM   RCL_IGM_DETAILS rid 
                                                 WHERE 
                             rid.PORT = P_I_V_POD 
                             AND ( P_I_V_SERVICE IS 
                                   NULL 
                                    OR rid.SERVICE = 
                                       P_I_V_SERVICE ) 
                             AND ( P_I_V_VESSEL IS NULL 
                                    OR rid.VESSEL = 
                                       P_I_V_VESSEL ) 
                             AND ( P_I_V_VOYAGE IS NULL 
                                    OR rid.VOYAGE = 
                                       P_I_V_VOYAGE ) 
                             AND ( P_I_V_POD_TERMINAL 
                                   IS 
                                   NULL 
                                    OR rid.TERMINAL = 
                                       P_I_V_POD_TERMINAL ) 
                             AND ( P_I_V_FROM_DATE IS NULL 
                                    OR rid.BL_DATE >= 
                                       P_I_V_FROM_DATE 
                                 ) 
                             AND ( P_I_V_TO_DATE IS NULL 
                                    OR rid.BL_DATE <= 
                                       P_I_V_TO_DATE ) 
                             AND ( P_I_V_POL IS NULL 
                                    OR rid.POL = P_I_V_POL 
                                 ) 
                             AND ( P_I_V_BL_STATUS IS NULL 
                                    OR rid.BL_STATUS = 
                                       P_I_V_BL_STATUS 
                                 ) 
                             AND ( P_I_V_POL_TERMINAL IS 
                                   NULL 
                                    OR rid.POL_TERMINAL = 
                                       P_I_V_POL_TERMINAL ) 
                             AND ( P_I_V_DIRECTION IS 
                                  NULL 
                                    OR rid.DEPOT = P_I_V_DEPOT )
                             AND ( P_I_V_DEL IS 
                                  NULL 
                                    OR rid.DEL = P_I_V_DEL )          
                                                )) NS, 
                 (SELECT BL_NO, 
                         BL_STATUS, 
                         TO_NUMBER(BL_DATE)          BL_DATE, 
                         SERVICE, 
                         VESSEL, 
                         VOYAGE, 
                         ''                          DIRECTION, 
                         POL, 
                         POL_TERMINAL, 
                         DEL                         DEL_VLS   ,
                         DEPOT                       DEPOT_VLS   ,
                         PORT                        POD, 
                         TERMINAL                    POD_TERMINAL, 
                         TERMINAL, 
                         CUST_CODE, 
                         CALL_SIGN, 
                         IMO_CODE, 
                         AGENT_CODE, 
                         LINE_CODE, 
                         PORT_ORIGIN, 
                         PORT_ARRIVAL, 
                         LAST_PORT_1, 
                         LAST_PORT_2, 
                         LAST_PORT_3, 
                         VESSEL_TYPE, 
                         GEN_DESC, 
                         MASTER_NAME, 
                         VESSEL_NATION, 
                         IGM_NUMBER, 
                         IGM_DATE, 
                         TO_NUMBER(ARRIVAL_DATE_ETA) ARRIVAL_DATE, 
                         TO_NUMBER(ARRIVAL_TIME_ETA) ARRIVAL_TIME, 
                         ARRIVAL_DATE_ATA,
                         ARRIVAL_TIME_ATA,
                         NEW_VOYAGE,
                         NEW_VESSEL,   
                         GROSS_WEIGHT, 
                         NET_WEIGHT, 
                         TOTAL_BLS, 
                         LIGHT_DUE, 
                         SM_BT_CARGO, 
                         SHIP_STR_DECL, 
                         CREW_LST_DECL, 
                         CARGO_DECL, 
                         PASSNGR_LIST, 
                         CREW_EFFECT, 
                         MARITIME_DECL, 
                         ITEM_NUMBER, 
                         CARGO_NATURE, 
                         CARGO_MOVMNT, 
                         ITEM_TYPE, 
                         CARGO_MOVMNT_TYPE, 
                         TRANSPORT_MODE, 
                         ROAD_CARR_CODE, 
                         ROAD_TP_BOND_NO,             
                         SUBMIT_DATE_TIME, 
                         NHAVA_SHEVA_ETA, 
                          
                         FINAL_PLACE_DELIVERY, 
                         PACKAGES, 
                         CFS_NAME, 
                         MBL_NO, 
                         HBL_NO, 
                         FROM_ITEM_NO, 
                         TO_ITEM_NO,
                         SRL_NO
                  FROM   RCL_IGM_DETAILS rids 
                  WHERE  rids.PORT = P_I_V_POD 
                         AND ( P_I_V_SERVICE IS NULL 
                                OR rids.SERVICE = P_I_V_SERVICE ) 
                         AND ( P_I_V_VESSEL IS NULL 
                                OR rids.VESSEL = P_I_V_VESSEL ) 
                         AND ( P_I_V_VOYAGE IS NULL 
                                OR rids.VOYAGE = P_I_V_VOYAGE ) 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR rids.TERMINAL = P_I_V_POD_TERMINAL ) 
                         AND ( P_I_V_FROM_DATE IS NULL 
                                OR rids.BL_DATE >= P_I_V_FROM_DATE ) 
                         AND ( P_I_V_TO_DATE IS NULL 
                                OR rids.BL_DATE <= P_I_V_TO_DATE ) 
                         AND ( P_I_V_POL IS NULL 
                                OR rids.POL = P_I_V_POL ) 
                         AND ( P_I_V_BL_STATUS IS NULL 
                                OR rids.BL_STATUS = P_I_V_BL_STATUS ) 
                         AND ( P_I_V_POL_TERMINAL IS NULL 
                                OR rids.POL_TERMINAL = P_I_V_POL_TERMINAL )
                         AND ( P_I_V_DIRECTION IS NULL 
                                OR rids.DEPOT = P_I_V_DEPOT )
                         AND ( P_I_V_DEL IS NULL 
                                OR rids.DEL = P_I_V_DEL )       
                         AND ROWNUM < 2) OS 
          WHERE  NS.SERVICE = OS.SERVICE 
                 AND NS.VESSEL = OS.VESSEL 
                 AND NS.VOYAGE = OS.VOYAGE 
                 AND NS.POD = OS.POD 
                 AND NS.TERMINAL = OS.TERMINAL 
          UNION 
          SELECT BL_NO, 
                 BL_STATUS, 
                 TO_NUMBER(BL_DATE)          BL_DATE, 
                 SERVICE, 
                 VESSEL, 
                 VOYAGE, 
                 ''                          DIRECTION, 
                 POL, 
                 POL_TERMINAL, 
                 DEL                          DEL_VLS,
                 DEPOT                         DEPOT_VLS,
                 PORT                        POD, 
                 TERMINAL                    POD_TERMINAL, 
                 TERMINAL, 
                 CUST_CODE, 
                 CALL_SIGN, 
                 IMO_CODE, 
                 AGENT_CODE, 
                 LINE_CODE, 
                 PORT_ORIGIN, 
                 PORT_ARRIVAL, 
                 LAST_PORT_1, 
                 LAST_PORT_2, 
                 LAST_PORT_3, 
                --new field
                 NEXT_PORT_4,
                 NEXT_PORT_5,
                 NEXT_PORT_6,
                 -- end
                 VESSEL_TYPE, 
                 GEN_DESC, 
                 MASTER_NAME, 
                 VESSEL_NATION, 
                 IGM_NUMBER, 
                 IGM_DATE, 
                 TO_NUMBER(ARRIVAL_DATE_ETA) ARRIVAL_DATE, 
                 TO_NUMBER(ARRIVAL_TIME_ETA) ARRIVAL_TIME,
                 ARRIVAL_DATE_ATA,
                 ARRIVAL_TIME_ATA,
                 --new added vessel voyage
                DEP_MANIF_NO,     										
                DEP_MANIFEST_DATE,
                SUBMITTER_TYPE,
                SUBMITTER_CODE,
                AUTHORIZ_REP_CODE,
                SHIPPING_LINE_BOND_NO_R,
                MODE_OF_TRANSPORT,
                SHIP_TYPE,
                CONVEYANCE_REFERENCE_NO,
                TOL_NO_OF_TRANS_EQU_MANIF,
                CARGO_DESCRIPTION,
                BRIEF_CARGO_DES,
                EXPECTED_DATE,
                TIME_OF_DEPT,
                PORT_OF_CALL_COD,
                TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
                MESSAGE_TYPE,
                VESSEL_TYPE_MOVEMENT,
                AUTHORIZED_SEA_CARRIER_CODE,
                PORT_OF_REGISTRY,  
                REGISTRY_DATE,
                VOYAGE_DETAILS,
                SHIP_ITINERARY_SEQUENCE,
                SHIP_ITINERARY,
                PORT_OF_CALL_NAME,
                ARRIVAL_DEPARTURE_DETAILS,
                TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                 --end
                 NEW_VOYAGE,
                 NEW_VESSEL,
                 GROSS_WEIGHT, 
                 NET_WEIGHT, 
                 TOTAL_BLS, 
                 LIGHT_DUE, 
                 SM_BT_CARGO, 
                 SHIP_STR_DECL, 
                 CREW_LST_DECL, 
                 CARGO_DECL, 
                 PASSNGR_LIST, 
                 CREW_EFFECT, 
                 MARITIME_DECL, 
                 ITEM_NUMBER, 
                 CARGO_NATURE, 
                 CARGO_MOVMNT, 
                 ITEM_TYPE, 
                 CARGO_MOVMNT_TYPE, 
                 TRANSPORT_MODE, 
                 ROAD_CARR_CODE, 
                 ROAD_TP_BOND_NO, 
                 SUBMIT_DATE_TIME, 
                 NHAVA_SHEVA_ETA, 
                 FINAL_PLACE_DELIVERY, 
                 PACKAGES, 
                 CFS_NAME, 
                 MBL_NO,    
                 HBL_NO, 
                 FROM_ITEM_NO, 
                 TO_ITEM_NO ,
                 SRL_NO,
                 DPD_MOVEMENT,  
                 DPD_CODE,
                 BL_VERSION,
				 CUSTOM_TERMINAL_CODE,
                 CUSTOMERS_ADDRESS_1,
                 CUSTOMERS_ADDRESS_2,
                 CUSTOMERS_ADDRESS_3,   
                 CUSTOMERS_ADDRESS_4,
                 COLOR_FLAG,
                 NET_WEIGHT_METRIC,
                 NET_PACKAGE,
                 --new field bl section 
                CONSOLIDATED_INDICATOR,
                PREVIOUS_DECLARATION,   
                CONSOLIDATOR_PAN,
                CIN_TYPE,
                MCIN,
                CSN_SUBMITTED_TYPE,
                CSN_SUBMITTED_BY,
                CSN_REPORTING_TYPE,
                CSN_SITE_ID,
                CSN_NUMBER,
                CSN_DATE,
                PREVIOUS_MCIN,
                SPLIT_INDICATOR,
                NUMBER_OF_PACKAGES,
                TYPE_OF_PACKAGE,
                FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
                TYPE_OF_CARGO,
                SPLIT_INDICATOR_LIST,
                PORT_OF_ACCEPTANCE,
                PORT_OF_RECEIPT,
                UCR_TYPE ,
                UCR_CODE ,
               
              --  EQUIPMENT_SEAL_TYPE ,
               
                PORT_OF_ACCEPTANCE_NAME ,
                PORT_OF_RECEIPT_NAME ,
                PAN_OF_NOTIFIED_PARTY ,
                UNIT_OF_WEIGHT ,
                GROSS_VOLUME ,
                UNIT_OF_VOLUME ,
                CARGO_ITEM_SEQUENCE_NO ,
				CARGO_ITEM_DESCRIPTION,
                NUMBER_OF_PACKAGES_HID ,
                TYPE_OF_PACKAGES_HID ,
                PORT_OF_CALL_SEQUENCE_NUMBER ,
                PORT_OF_CALL_CODED ,
                NEXT_PORT_OF_CALL_CODED ,
                MC_LOCATION_CUSTOMS ,
                UNO_CODE ,
                IMDG_CODE,
                CONTAINER_WEIGHT   
                 --end
          FROM   RCL_IGM_DETAILS rid 
          WHERE  rid.PORT = P_I_V_POD 
                 AND ( P_I_V_SERVICE IS NULL 
                        OR rid.SERVICE = P_I_V_SERVICE ) 
                 AND ( P_I_V_VESSEL IS NULL 
                        OR rid.VESSEL = P_I_V_VESSEL ) 
                 AND ( P_I_V_VOYAGE IS NULL 
                        OR rid.VOYAGE = P_I_V_VOYAGE ) 
                 AND ( P_I_V_POD_TERMINAL IS NULL 
                        OR rid.TERMINAL = P_I_V_POD_TERMINAL ) 
                 AND ( P_I_V_FROM_DATE IS NULL 
                        OR rid.BL_DATE >= P_I_V_FROM_DATE ) 
                 AND ( P_I_V_TO_DATE IS NULL 
                        OR rid.BL_DATE <= P_I_V_TO_DATE ) 
                 AND ( P_I_V_POL IS NULL 
                        OR rid.POL = P_I_V_POL ) 
                 AND ( P_I_V_BL_STATUS IS NULL 
                        OR rid.BL_STATUS = P_I_V_BL_STATUS ) 
                 AND ( P_I_V_POL_TERMINAL IS NULL 
                        OR rid.POL_TERMINAL = P_I_V_POL_TERMINAL )
                 AND ( P_I_V_DIRECTION IS NULL 
                        OR rid.DEPOT = P_I_V_DEPOT )
                 AND ( P_I_V_DEL IS NULL 
                        OR rid.DEL = P_I_V_DEL ); 
      END IF; 
 -- EXCEPTION 
 --   WHEN NO_DATA_FOUND THEN 
              -- P_O_V_ERROR := '1111'; WHEN OTHERS THEN 
       --        P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) 
              --                || ':' 
                --              || SUBSTR(SQLERRM, 1, 100); 
  END RCL_IGM_GET_DATA; 
    
 PROCEDURE RCL_IGM_SAVE_DATA (  P_I_V_SERVICE              VARCHAR2 DEFAULT NULL, 
                                P_I_V_VESSEL               VARCHAR2 DEFAULT NULL, 
                                P_I_V_VOYAGE               VARCHAR2 DEFAULT NULL, 
                                P_I_V_PORT                 VARCHAR2 DEFAULT NULL, 
                                P_I_V_TERMINAL             VARCHAR2 DEFAULT NULL, 
                                P_I_V_NEW_VESSEL           VARCHAR2 DEFAULT NULL, 
                                P_I_V_NEW_VOYAGE           VARCHAR2 DEFAULT NULL, 
                                P_I_V_FROM_ITEM_NO         VARCHAR2 DEFAULT NULL, 
                                P_I_V_TO_ITEM_NO           VARCHAR2 DEFAULT NULL, 
                                P_I_V_ROAD_CARR_CODE       VARCHAR2 DEFAULT NULL, 
                                P_I_V_ROAD_TP_BOND_NO      VARCHAR2 DEFAULT NULL, 
                                P_I_V_CUST_CODE            VARCHAR2 DEFAULT NULL, 
                                P_I_V_CALL_SIGN            VARCHAR2 DEFAULT NULL, 
                                P_I_V_IMO_CODE             VARCHAR2 DEFAULT NULL, 
                                P_I_V_AGENT_CODE           VARCHAR2 DEFAULT NULL, 
                                P_I_V_LINE_CODE            VARCHAR2 DEFAULT NULL, 
                                P_I_V_PORT_ORIGIN          VARCHAR2 DEFAULT NULL, 
                                P_I_V_PORT_ARRIVAL         VARCHAR2 DEFAULT NULL, 
                                P_I_V_LAST_PORT_1          VARCHAR2 DEFAULT NULL, 
                                P_I_V_LAST_PORT_2          VARCHAR2 DEFAULT NULL, 
                                P_I_V_LAST_PORT_3          VARCHAR2 DEFAULT NULL, 
                                P_I_V_VESSEL_TYPE          VARCHAR2 DEFAULT NULL, 
                                P_I_V_GEN_DESC             VARCHAR2 DEFAULT NULL, 
                                P_I_V_MASTER_NAME          VARCHAR2 DEFAULT NULL, 
                                P_I_V_IGM_NUMBER           VARCHAR2 DEFAULT NULL, 
                                P_I_V_IGM_DATE             VARCHAR2 DEFAULT NULL, 
                                P_I_V_VESSEL_NATION        VARCHAR2 DEFAULT NULL, 
                                P_I_V_ARRIVAL_DATE_ETA     VARCHAR2 DEFAULT NULL, 
                                P_I_V_ARRIVAL_TIME_ETA     VARCHAR2 DEFAULT NULL, 
                                P_I_V_ARRIVAL_DATE_ATA     VARCHAR2 DEFAULT NULL, 
                                P_I_V_ARRIVAL_TIME_ATA     VARCHAR2 DEFAULT NULL, 
                                P_I_V_TOTAL_BLS            VARCHAR2 DEFAULT NULL, 
                                P_I_V_LIGHT_DUE            VARCHAR2 DEFAULT NULL, 
                                P_I_V_GROSS_WEIGHT         VARCHAR2 DEFAULT NULL, 
                                P_I_V_NET_WEIGHT           VARCHAR2 DEFAULT NULL, 
                                P_I_V_SM_BT_CARGO          VARCHAR2 DEFAULT NULL, 
                                P_I_V_SHIP_STR_DECL        VARCHAR2 DEFAULT NULL, 
                                P_I_V_CREW_LST_DECL        VARCHAR2 DEFAULT NULL, 
                                P_I_V_CARGO_DECL           VARCHAR2 DEFAULT NULL, 
                                P_I_V_PASSNGR_LIST         VARCHAR2 DEFAULT NULL, 
                                P_I_V_CREW_EFFECT          VARCHAR2 DEFAULT NULL, 
                                P_I_V_MARITIME_DECL        VARCHAR2 DEFAULT NULL, 
                                P_I_V_ITEM_NUMBER          VARCHAR2 DEFAULT NULL, 
                                P_I_V_BL_NO                VARCHAR2 DEFAULT NULL, 
                                P_I_V_CFS_NAME             VARCHAR2 DEFAULT NULL, 
                                P_I_V_CARGO_NATURE         VARCHAR2 DEFAULT NULL, 
                                P_I_V_CARGO_MOVMNT         VARCHAR2 DEFAULT NULL, 
                                P_I_V_ITEM_TYPE            VARCHAR2 DEFAULT NULL, 
                                P_I_V_CARGO_MOVMNT_TYPE    VARCHAR2 DEFAULT NULL, 
                                P_I_V_TRANSPORT_MODE       VARCHAR2 DEFAULT NULL, 
                                P_I_V_SUBMIT_DATE_TIME     VARCHAR2 DEFAULT NULL, 
                                P_I_V_DIRECTION            VARCHAR2 DEFAULT NULL, 
                                P_I_V_BL_DATE              VARCHAR2 DEFAULT NULL, 
                                P_I_V_MBL_NO               VARCHAR2 DEFAULT NULL, 
                                P_I_V_HBL_NO               VARCHAR2 DEFAULT NULL, 
                                P_I_V_PACKAGES             VARCHAR2 DEFAULT NULL, 
                                P_I_V_NHAVA_SHEVA_ETA      VARCHAR2 DEFAULT NULL, 
                                P_I_V_FINAL_PLACE_DELIVERY VARCHAR2 DEFAULT NULL, 
                                P_I_V_POL                  VARCHAR2 DEFAULT NULL, 
                                P_I_V_POL_TERMINAL         VARCHAR2 DEFAULT NULL,
                                P_I_V_DEL                  VARCHAR2 DEFAULT NULL,
                                P_I_V_DEPOT                VARCHAR2 DEFAULT NULL,
                                P_I_V_BL_STATUS            VARCHAR2 DEFAULT NULL, 
                                P_I_V_ADD_USER             VARCHAR2 DEFAULT NULL, 
                                P_I_V_ADD_DATE             VARCHAR2 DEFAULT NULL, 
                                P_I_V_CHANGE_USER          VARCHAR2 DEFAULT NULL, 
                                P_I_V_CHANGE_DATE          VARCHAR2 DEFAULT NULL,
                                P_I_V_DPD_CODE             VARCHAR2 DEFAULT NULL,
                                P_I_V_DPD_MOVEMENT         VARCHAR2 DEFAULT NULL,
                                P_I_V_BL_VEERSION          VARCHAR2 DEFAULT NULL,
                                P_I_V_CUSTOM_TERMINAL_CODE VARCHAR2 DEFAULT NULL,
                                P_I_V_CUSTOM_ADD1          VARCHAR2 DEFAULT NULL,
                                P_I_V_CUSTOM_ADD2          VARCHAR2 DEFAULT NULL,
                                P_I_V_CUSTOM_ADD3          VARCHAR2 DEFAULT NULL,
                                P_I_V_CUSTOM_ADD4          VARCHAR2 DEFAULT NULL,
                                P_I_V_IS_PRESENT_IN_DB     VARCHAR2 DEFAULT NULL,
                                P_I_V_IS_SELECTED          VARCHAR2 DEFAULT NULL, 
                                P_I_V_COLOR_FLAG            VARCHAR2 DEFAULT NULL,
                                P_I_V_PACKAGE_BL_LEVEL      VARCHAR2 DEFAULT NULL,
                                P_I_V_GROSS_CARGO_WEIGHT_BL_LEVEL   VARCHAR2 DEFAULT NULL,
                                
                                --  P_I_V_CONTAINER_DTLS          VARCHAR2 DEFAULT NULL, 
                                
                                P_I_V_CONSIGNEE_ADD1        VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNEE_ADD2        VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNEE_ADD3        VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNEE_ADD4        VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNEE_COUNTRYCODE     VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNEE_CODE        VARCHAR2 DEFAULT NULL, 
                                P_I_V_CONSIGNEE_NAME        VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNEE_STATE       VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNEE_ZIP         VARCHAR2 DEFAULT NULL, 
                                P_I_V_CONSIGNEE_CITY        VARCHAR2 DEFAULT NULL,
                                
                                P_I_V_MARKSNUMBER_DESCRIPTION     VARCHAR2 DEFAULT NULL, 
                                P_I_V_MARKSNUMBER_MARKS        VARCHAR2 DEFAULT NULL, 
                                
                                P_I_V_NOTIFYPARTY_ADD1        VARCHAR2 DEFAULT NULL,
                                P_I_V_NOTIFYPARTY_ADD2        VARCHAR2 DEFAULT NULL,
                                P_I_V_NOTIFYPARTY_ADD3        VARCHAR2 DEFAULT NULL,
                                P_I_V_NOTIFYPARTY_ADD4        VARCHAR2 DEFAULT NULL,  
                                P_I_V_NOTIFYPARTY_CITY        VARCHAR2 DEFAULT NULL,
                                P_I_V_NOTIFYPARTY_COUNTRYCODE        VARCHAR2 DEFAULT NULL, 
                                P_I_V_NOTIFYPARTY_CODE        VARCHAR2 DEFAULT NULL,
                                P_I_V_NOTIFYPARTY_NAME        VARCHAR2 DEFAULT NULL,
                                P_I_V_NOTIFYPARTY_STATE       VARCHAR2 DEFAULT NULL, 
                                P_I_V_NOTIFYPARTY_ZIP         VARCHAR2 DEFAULT NULL,
                                
                                P_I_V_CONSIGNER_ADD1		VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_ADD2		VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_ADD3		VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_ADD4		VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_COUNTRYCODE		VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_CODE		VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_NAME		VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_STATE		VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_ZIP			VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSIGNER_CITY		VARCHAR2 DEFAULT NULL,
                                --NEW VESSEL/VOYAGE SECTION 10-12-19 
                                  
                                P_I_V_NEXT_PORT_1            VARCHAR2 DEFAULT NULL,     
                                P_I_V_NEXT_PORT_2        VARCHAR2 DEFAULT NULL,
                                P_I_V_NEXT_PORT_3        VARCHAR2 DEFAULT NULL,
                                
                                P_I_V_DEP_MANIF_NO        VARCHAR2 DEFAULT NULL,
                                P_I_V_DEP_MANIFEST_DATE        VARCHAR2 DEFAULT NULL,
                                P_I_V_SUBMITTER_TYPE        VARCHAR2 DEFAULT NULL,
                                P_I_V_SUBMITTER_CODE        VARCHAR2 DEFAULT NULL,
                                P_I_V_AUTHORIZ_REP_CODE        VARCHAR2 DEFAULT NULL,
                                P_I_V_SHIPPING_LINE_BOND_NO_R        VARCHAR2 DEFAULT NULL, 
                                P_I_V_MODE_OF_TRANSPORT        VARCHAR2 DEFAULT NULL,
                                P_I_V_SHIP_TYPE        VARCHAR2 DEFAULT NULL,
                                P_I_V_CONVEYANCE_REFERENCE_NO       VARCHAR2 DEFAULT NULL, 
                                P_I_V_CARGO_DESCRIPTION         VARCHAR2 DEFAULT NULL,
                                P_I_V_TOL_NO_OF_TRANS_EQU_MANIF        VARCHAR2 DEFAULT NULL,
                                P_I_V_BRIEF_CARGO_DES        VARCHAR2 DEFAULT NULL,
                                P_I_V_EXPECTED_DATE        VARCHAR2 DEFAULT NULL,
                                P_I_V_TIME_OF_DEPT        VARCHAR2 DEFAULT NULL,
                                P_I_V_PORT_OF_CALL_COD        VARCHAR2 DEFAULT NULL,
                                P_I_V_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP        VARCHAR2 DEFAULT NULL, 
                                P_I_V_MESSAGE_TYPE        VARCHAR2 DEFAULT NULL,
                                P_I_V_VESSEL_TYPE_MOVEMENT        VARCHAR2 DEFAULT NULL,
                                P_I_V_AUTHORIZED_SEA_CARRIER_CODE       VARCHAR2 DEFAULT NULL, 
                                P_I_V_PORT_OF_REGISTRY         VARCHAR2 DEFAULT NULL,
                                P_I_V_REGISTRY_DATE        VARCHAR2 DEFAULT NULL,
                                P_I_V_VOYAGE_DETAILS        VARCHAR2 DEFAULT NULL,
                                P_I_V_SHIP_ITINERARY_SEQUENCE        VARCHAR2 DEFAULT NULL,
                                P_I_V_SHIP_ITINERARY        VARCHAR2 DEFAULT NULL,
                                P_I_V_PORT_OF_CALL_NAME        VARCHAR2 DEFAULT NULL,
                                P_I_V_ARRIVAL_DEPARTURE_DETAILS        VARCHAR2 DEFAULT NULL, 
                                P_I_V_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE        VARCHAR2 DEFAULT NULL, 
                                
                                --VESSEL/VOYAGE SECTION END
                                --NEW BL SECTION 10-12-19 
                                
                                P_I_V_CONSOLIDATED_INDICATOR        VARCHAR2 DEFAULT NULL,
                                P_I_V_PREVIOUS_DECLARATION        VARCHAR2 DEFAULT NULL,
                                P_I_V_CONSOLIDATOR_PAN        VARCHAR2 DEFAULT NULL,
                                P_I_V_CIN_TYPE        VARCHAR2 DEFAULT NULL,
                                P_I_V_MCIN        VARCHAR2 DEFAULT NULL,
                                P_I_V_CSN_SUBMITTED_TYPE        VARCHAR2 DEFAULT NULL, 
                                P_I_V_CSN_SUBMITTED_BY        VARCHAR2 DEFAULT NULL,
                                P_I_V_CSN_REPORTING_TYPE        VARCHAR2 DEFAULT NULL,
                                P_I_V_CSN_SITE_ID       VARCHAR2 DEFAULT NULL, 
                                P_I_V_CSN_NUMBER         VARCHAR2 DEFAULT NULL,
                                P_I_V_CSN_DATE        VARCHAR2 DEFAULT NULL,
                                P_I_V_PREVIOUS_MCIN        VARCHAR2 DEFAULT NULL,
                                P_I_V_SPLIT_INDICATOR        VARCHAR2 DEFAULT NULL,
                                P_I_V_NUMBER_OF_PACKAGES        VARCHAR2 DEFAULT NULL,
                                P_I_V_TYPE_OF_PACKAGE        VARCHAR2 DEFAULT NULL,
                                P_I_V_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE        VARCHAR2 DEFAULT NULL, 
                                P_I_V_TYPE_OF_CARGO        VARCHAR2 DEFAULT NULL,
                                P_I_V_SPLIT_INDICATOR_LIST        VARCHAR2 DEFAULT NULL,
                                P_I_V_PORT_OF_ACCEPTANCE       VARCHAR2 DEFAULT NULL, 
                                P_I_V_PORT_OF_RECEIPT         VARCHAR2 DEFAULT NULL,
                                P_I_V_UCR_TYPE        VARCHAR2 DEFAULT NULL,  
                                P_I_V_UCR_CODE        VARCHAR2 DEFAULT NULL,
                                
                                -- P_I_V_EQUIPMENT_SEAL_TYPE        VARCHAR2 DEFAULT NULL,
                                
                                P_I_V_PORT_OF_ACCEPTANCE_NAME        VARCHAR2 DEFAULT NULL, 
                                P_I_V_PORT_OF_RECEIPT_NAME        VARCHAR2 DEFAULT NULL,
                                P_I_V_PAN_OF_NOTIFIED_PARTY        VARCHAR2 DEFAULT NULL,
                                P_I_V_UNIT_OF_WEIGHT        VARCHAR2 DEFAULT NULL,
                                P_I_V_GROSS_VOLUME        VARCHAR2 DEFAULT NULL,
                                P_I_V_UNIT_OF_VOLUME        VARCHAR2 DEFAULT NULL, 
                                P_I_V_CARGO_ITEM_SEQUENCE_NO        VARCHAR2 DEFAULT NULL,
                                P_I_V_CARGO_ITEM_DESCRIPTION        VARCHAR2 DEFAULT NULL,
                                P_I_V_CONTAINER_WEIGHT       VARCHAR2 DEFAULT NULL, 
                                P_I_V_NUMBER_OF_PACKAGES_HID         VARCHAR2 DEFAULT NULL,
                                P_I_V_TYPE_OF_PACKAGES_HID        VARCHAR2 DEFAULT NULL,
                                P_I_V_PORT_OF_CALL_SEQUENCE_NUMBER        VARCHAR2 DEFAULT NULL,
                                P_I_V_PORT_OF_CALL_CODED        VARCHAR2 DEFAULT NULL,
                                P_I_V_NEXT_PORT_OF_CALL_CODED        VARCHAR2 DEFAULT NULL,
                                P_I_V_MC_LOCATION_CUSTOMS        VARCHAR2 DEFAULT NULL,
                                P_I_V_UNO_CODE        VARCHAR2 DEFAULT NULL, 
                                P_I_V_IMDG_CODE        VARCHAR2 DEFAULT NULL,
                                
                                --BL SECTION END 
                                
                                P_O_V_ERROR                OUT VARCHAR2)    
  IS 
    v_srl_no NUMBER;
   
    v_cnt NUMBER;
   
  
  BEGIN   
  --INSERT INTO SUSHILTEST VALUES('18511111111114 ..');
  commit;
      P_O_V_ERROR := '000000';
     
        IF P_I_V_IS_PRESENT_IN_DB IN ( 'TRUE' ) 
         AND P_I_V_IS_SELECTED IN ( 'FALSE' ) THEN 
        DELETE FROM RCL_IGM_DETAILS 
        WHERE  SERVICE = P_I_V_SERVICE 
               AND VESSEL = P_I_V_VESSEL 
               AND VOYAGE = P_I_V_VOYAGE 
               AND PORT = P_I_V_PORT 
               AND TERMINAL = P_I_V_TERMINAL 
               AND BL_NO = P_I_V_BL_NO; 
      ELSE 
      
SELECT COUNT(*) INTO v_cnt FROM RCL_IGM_DETAILS 
        WHERE  SERVICE = P_I_V_SERVICE 
               AND VESSEL = P_I_V_VESSEL 
               AND VOYAGE = P_I_V_VOYAGE 
               AND PORT = P_I_V_PORT 
               AND TERMINAL = P_I_V_TERMINAL;
    IF v_cnt > 0 THEN
        SELECT srl_no INTO v_srl_no  FROM RCL_IGM_DETAILS 
        WHERE  SERVICE = P_I_V_SERVICE 
               AND VESSEL = P_I_V_VESSEL 
               AND VOYAGE = P_I_V_VOYAGE 
               AND PORT = P_I_V_PORT 
               AND TERMINAL = P_I_V_TERMINAL
               AND rownum<2;
      
        UPDATE RCL_IGM_DETAILS 
        SET    NEW_VESSEL = P_I_V_NEW_VESSEL, 
               NEW_VOYAGE = P_I_V_NEW_VOYAGE, 
               FROM_ITEM_NO = P_I_V_FROM_ITEM_NO, 
               TO_ITEM_NO = P_I_V_TO_ITEM_NO, 
               ROAD_CARR_CODE = P_I_V_ROAD_CARR_CODE, 
               ROAD_TP_BOND_NO = P_I_V_ROAD_TP_BOND_NO, 
               CUST_CODE = P_I_V_CUST_CODE, 
               CALL_SIGN = P_I_V_CALL_SIGN, 
               IMO_CODE = P_I_V_IMO_CODE, 
               AGENT_CODE = P_I_V_AGENT_CODE, 
               LINE_CODE = P_I_V_LINE_CODE, 
               PORT_ORIGIN = P_I_V_PORT_ORIGIN, 
               PORT_ARRIVAL = P_I_V_PORT_ARRIVAL, 
               LAST_PORT_1 = P_I_V_LAST_PORT_1, 
               LAST_PORT_2 = P_I_V_LAST_PORT_2, 
               LAST_PORT_3 = P_I_V_LAST_PORT_3,
               NEXT_PORT_4=P_I_V_NEXT_PORT_1,
               NEXT_PORT_5=P_I_V_NEXT_PORT_2,
               NEXT_PORT_6=P_I_V_NEXT_PORT_3,
               VESSEL_TYPE = P_I_V_VESSEL_TYPE, 
               GEN_DESC = P_I_V_GEN_DESC, 
               MASTER_NAME = P_I_V_MASTER_NAME, 
               IGM_NUMBER = P_I_V_IGM_NUMBER, 
               IGM_DATE = P_I_V_IGM_DATE, 
               VESSEL_NATION = P_I_V_VESSEL_NATION, 
               ARRIVAL_DATE_ETA = P_I_V_ARRIVAL_DATE_ETA, 
               ARRIVAL_TIME_ETA = P_I_V_ARRIVAL_TIME_ETA, 
               ARRIVAL_DATE_ATA = P_I_V_ARRIVAL_DATE_ATA, 
               ARRIVAL_TIME_ATA = P_I_V_ARRIVAL_TIME_ATA, 
               TOTAL_BLS = P_I_V_TOTAL_BLS, 
               LIGHT_DUE = P_I_V_LIGHT_DUE, 
               GROSS_WEIGHT = TO_NUMBER(P_I_V_GROSS_WEIGHT), 
               NET_WEIGHT = TO_NUMBER(P_I_V_NET_WEIGHT), 
               SM_BT_CARGO = P_I_V_SM_BT_CARGO, 
               SHIP_STR_DECL = P_I_V_SHIP_STR_DECL, 
               CREW_LST_DECL = P_I_V_CREW_LST_DECL, 
               CARGO_DECL = P_I_V_CARGO_DECL, 
               PASSNGR_LIST = P_I_V_PASSNGR_LIST, 
               CREW_EFFECT = P_I_V_CREW_EFFECT, 
               MARITIME_DECL = P_I_V_MARITIME_DECL, 
               ITEM_NUMBER = P_I_V_ITEM_NUMBER, 
               CFS_NAME = P_I_V_CFS_NAME, 
               CARGO_NATURE = P_I_V_CARGO_NATURE, 
               CARGO_MOVMNT = P_I_V_CARGO_MOVMNT, 
               ITEM_TYPE = P_I_V_ITEM_TYPE, 
               CARGO_MOVMNT_TYPE = P_I_V_CARGO_MOVMNT_TYPE, 
               TRANSPORT_MODE = P_I_V_TRANSPORT_MODE, 
               SUBMIT_DATE_TIME = P_I_V_SUBMIT_DATE_TIME, 
               DIRECTION = P_I_V_DIRECTION, 
               BL_DATE = P_I_V_BL_DATE, 
               MBL_NO = P_I_V_MBL_NO, 
               HBL_NO = P_I_V_HBL_NO, 
               PACKAGES = P_I_V_PACKAGES, 
               NHAVA_SHEVA_ETA = P_I_V_NHAVA_SHEVA_ETA, 
               FINAL_PLACE_DELIVERY = P_I_V_FINAL_PLACE_DELIVERY, 
               BL_STATUS = P_I_V_BL_STATUS, 
               POL = P_I_V_POL, 
               POL_TERMINAL = P_I_V_POL_TERMINAL ,
               DEL=P_I_V_DEL,
               DEPOT=P_I_V_DEPOT,
               BL_VERSION=P_I_V_BL_VEERSION,
               CUSTOM_TERMINAL_CODE=P_I_V_CUSTOM_TERMINAL_CODE,
               DPD_MOVEMENT=P_I_V_DPD_MOVEMENT,
               DPD_CODE=P_I_V_DPD_CODE,
               CUSTOMERS_ADDRESS_1=P_I_V_CUSTOM_ADD1,
               CUSTOMERS_ADDRESS_2=P_I_V_CUSTOM_ADD2,
               CUSTOMERS_ADDRESS_3=P_I_V_CUSTOM_ADD3,
               CUSTOMERS_ADDRESS_4=P_I_V_CUSTOM_ADD4,
               COLOR_FLAG=P_I_V_COLOR_FLAG,
               NET_WEIGHT_METRIC=P_I_V_GROSS_CARGO_WEIGHT_BL_LEVEL,
               NET_PACKAGE=P_I_V_PACKAGE_BL_LEVEL,
               
               CONSIGNEE_ADDRESS_1 = P_I_V_CONSIGNEE_ADD1,      
               CONSIGNEE_ADDRESS_2 = P_I_V_CONSIGNEE_ADD2,      
               CONSIGNEE_ADDRESS_3 = P_I_V_CONSIGNEE_ADD3,       
               CONSIGNEE_ADDRESS_4 =  P_I_V_CONSIGNEE_ADD4,
               CONSIGNEE_COUNTRY_CODE = P_I_V_CONSIGNEE_COUNTRYCODE,
               CONSIGNEE_CODE  =  P_I_V_CONSIGNEE_CODE,   
               CONSIGNEE_NAME  =  P_I_V_CONSIGNEE_NAME,           
               CONSIGNEE_STATE = P_I_V_CONSIGNEE_STATE, 
               CONSIGNEE_ZIP  = P_I_V_CONSIGNEE_ZIP,  
               CONSIGNEE_CITY = P_I_V_CONSIGNEE_CITY,            
                            
               DESCRIPTION  = P_I_V_MARKSNUMBER_DESCRIPTION,
               MARKS_AND_NUMBER = P_I_V_MARKSNUMBER_MARKS,  
              
               NOTIFY_ADDRESS_1=P_I_V_NOTIFYPARTY_ADD1,
               NOTIFY_ADDRESS_2=P_I_V_NOTIFYPARTY_ADD2,
               NOTIFY_ADDRESS_3=P_I_V_NOTIFYPARTY_ADD3,
               NOTIFY_ADDRESS_4=P_I_V_NOTIFYPARTY_ADD4,
               NOTIFY_CITY=P_I_V_NOTIFYPARTY_CITY,
               NOTIFY_COUNTRY_CODE=P_I_V_NOTIFYPARTY_COUNTRYCODE,
               NOTIFY_CODE=P_I_V_NOTIFYPARTY_CODE,
               NOTIFY_NAME=P_I_V_NOTIFYPARTY_NAME,
               NOTIFY_STATE=P_I_V_NOTIFYPARTY_STATE,
               NOTIFY_ZIP=P_I_V_NOTIFYPARTY_ZIP,
               
               CONSIGNER_ADDRESS_1=P_I_V_CONSIGNER_ADD1,
                CONSIGNER_ADDRESS_2=P_I_V_CONSIGNER_ADD2,
                CONSIGNER_ADDRESS_3=P_I_V_CONSIGNER_ADD3,
                CONSIGNER_ADDRESS_4=P_I_V_CONSIGNER_ADD4,
                CONSIGNER_COUNTRY_CODE=P_I_V_CONSIGNER_COUNTRYCODE		,
                CONSIGNER_CODE=P_I_V_CONSIGNER_CODE,
                CONSIGNER_NAME=P_I_V_CONSIGNER_NAME,
                CONSIGNER_STATE=	P_I_V_CONSIGNER_STATE,
                CONSIGNER_ZIP=P_I_V_CONSIGNER_ZIP,
                CONSIGNER_CITY=P_I_V_CONSIGNER_CITY,
               --NEW VESSEL/VOYAGE SECTION 10-12-19 

                DEP_MANIF_NO=P_I_V_DEP_MANIF_NO,
                DEP_MANIFEST_DATE=P_I_V_DEP_MANIFEST_DATE,
                SUBMITTER_TYPE=P_I_V_SUBMITTER_TYPE,
                SUBMITTER_CODE=P_I_V_SUBMITTER_CODE,
                AUTHORIZ_REP_CODE=P_I_V_AUTHORIZ_REP_CODE,
                SHIPPING_LINE_BOND_NO_R=P_I_V_SHIPPING_LINE_BOND_NO_R, 
                MODE_OF_TRANSPORT=P_I_V_MODE_OF_TRANSPORT,
                SHIP_TYPE=P_I_V_SHIP_TYPE,
                CONVEYANCE_REFERENCE_NO=P_I_V_CONVEYANCE_REFERENCE_NO       , 
                TOL_NO_OF_TRANS_EQU_MANIF=P_I_V_CARGO_DESCRIPTION ,
                CARGO_DESCRIPTION=P_I_V_TOL_NO_OF_TRANS_EQU_MANIF,
                BRIEF_CARGO_DES=P_I_V_BRIEF_CARGO_DES,
                EXPECTED_DATE=P_I_V_EXPECTED_DATE,
                TIME_OF_DEPT=P_I_V_TIME_OF_DEPT,
                PORT_OF_CALL_COD=P_I_V_PORT_OF_CALL_COD,
                TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP=P_I_V_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP, 
                MESSAGE_TYPE=P_I_V_MESSAGE_TYPE,
                VESSEL_TYPE_MOVEMENT=P_I_V_VESSEL_TYPE_MOVEMENT,
                AUTHORIZED_SEA_CARRIER_CODE=P_I_V_AUTHORIZED_SEA_CARRIER_CODE       , 
                PORT_OF_REGISTRY=P_I_V_PORT_OF_REGISTRY ,
                REGISTRY_DATE=P_I_V_REGISTRY_DATE,
                VOYAGE_DETAILS=P_I_V_VOYAGE_DETAILS,
                SHIP_ITINERARY_SEQUENCE=P_I_V_SHIP_ITINERARY_SEQUENCE,
                SHIP_ITINERARY=P_I_V_SHIP_ITINERARY,
                PORT_OF_CALL_NAME=P_I_V_PORT_OF_CALL_NAME,
                ARRIVAL_DEPARTURE_DETAILS=P_I_V_ARRIVAL_DEPARTURE_DETAILS, 
                TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE=P_I_V_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                
                --VESSEL/VOYAGE SECTION END
                --NEW BL SECTION 10-12-19 
                
                CONSOLIDATED_INDICATOR=P_I_V_CONSOLIDATED_INDICATOR,
                PREVIOUS_DECLARATION=P_I_V_PREVIOUS_DECLARATION,
                CONSOLIDATOR_PAN=P_I_V_CONSOLIDATOR_PAN,
                CIN_TYPE=P_I_V_CIN_TYPE,
                MCIN=P_I_V_MCIN,
                CSN_SUBMITTED_TYPE=P_I_V_CSN_SUBMITTED_TYPE, 
                CSN_SUBMITTED_BY=P_I_V_CSN_SUBMITTED_BY,
                CSN_REPORTING_TYPE=P_I_V_CSN_REPORTING_TYPE,
                CSN_SITE_ID=P_I_V_CSN_SITE_ID       , 
                CSN_NUMBER=P_I_V_CSN_NUMBER ,
                CSN_DATE=P_I_V_CSN_DATE,
                PREVIOUS_MCIN=P_I_V_PREVIOUS_MCIN,
                SPLIT_INDICATOR=P_I_V_SPLIT_INDICATOR,
                NUMBER_OF_PACKAGES=P_I_V_NUMBER_OF_PACKAGES,
                TYPE_OF_PACKAGE=P_I_V_TYPE_OF_PACKAGE,
                FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE=P_I_V_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE, 
                TYPE_OF_CARGO=P_I_V_TYPE_OF_CARGO,
                SPLIT_INDICATOR_LIST=P_I_V_SPLIT_INDICATOR_LIST,
                PORT_OF_ACCEPTANCE=P_I_V_PORT_OF_ACCEPTANCE       , 
                PORT_OF_RECEIPT=P_I_V_PORT_OF_RECEIPT ,
                UCR_TYPE=P_I_V_UCR_TYPE,
                UCR_CODE=P_I_V_UCR_CODE,
                
               -- EQUIPMENT_SEAL_TYPE=P_I_V_EQUIPMENT_SEAL_TYPE,
               
                PORT_OF_ACCEPTANCE_NAME=P_I_V_PORT_OF_ACCEPTANCE_NAME, 
                PORT_OF_RECEIPT_NAME=P_I_V_PORT_OF_RECEIPT_NAME,
                PAN_OF_NOTIFIED_PARTY=P_I_V_PAN_OF_NOTIFIED_PARTY,
                UNIT_OF_WEIGHT=P_I_V_UNIT_OF_WEIGHT,
                GROSS_VOLUME=P_I_V_GROSS_VOLUME,
                UNIT_OF_VOLUME=P_I_V_UNIT_OF_VOLUME, 
                CARGO_ITEM_SEQUENCE_NO=P_I_V_CARGO_ITEM_SEQUENCE_NO,
                CARGO_ITEM_DESCRIPTION=P_I_V_CARGO_ITEM_DESCRIPTION,
                CONTAINER_WEIGHT=P_I_V_CONTAINER_WEIGHT       , 
                NUMBER_OF_PACKAGES_HID=P_I_V_NUMBER_OF_PACKAGES_HID ,
                TYPE_OF_PACKAGES_HID=P_I_V_TYPE_OF_PACKAGES_HID,
                PORT_OF_CALL_SEQUENCE_NUMBER=P_I_V_PORT_OF_CALL_SEQUENCE_NUMBER,
                PORT_OF_CALL_CODED=P_I_V_PORT_OF_CALL_CODED,
                NEXT_PORT_OF_CALL_CODED=P_I_V_NEXT_PORT_OF_CALL_CODED,
                MC_LOCATION_CUSTOMS=P_I_V_MC_LOCATION_CUSTOMS,
                UNO_CODE=P_I_V_UNO_CODE, 
                IMDG_CODE=P_I_V_IMDG_CODE
               
                          
        WHERE  SERVICE = P_I_V_SERVICE 
               AND VESSEL = P_I_V_VESSEL 
               AND VOYAGE = P_I_V_VOYAGE 
               AND PORT = P_I_V_PORT 
               AND TERMINAL = P_I_V_TERMINAL 
               AND BL_NO = P_I_V_BL_NO; 

        IF SQL%ROWCOUNT = 0 THEN 
          DBMS_OUTPUT.PUT_LINE('Record inserted..!!'); 

          INSERT INTO RCL_IGM_DETAILS 
                      (SERVICE, 
                       VESSEL, 
                       VOYAGE, 
                       PORT, 
                       TERMINAL, 
                       NEW_VESSEL, 
                       NEW_VOYAGE, 
                       FROM_ITEM_NO, 
                       TO_ITEM_NO, 
                       ROAD_CARR_CODE, 
                       ROAD_TP_BOND_NO, 
                       CUST_CODE, 
                       CALL_SIGN, 
                       IMO_CODE, 
                       AGENT_CODE, 
                       LINE_CODE, 
                       PORT_ORIGIN, 
                       PORT_ARRIVAL, 
                       LAST_PORT_1, 
                       LAST_PORT_2, 
                       LAST_PORT_3,
                       NEXT_PORT_4,
                       NEXT_PORT_5,
                       NEXT_PORT_6,
                       VESSEL_TYPE, 
                       GEN_DESC, 
                       MASTER_NAME, 
                       IGM_NUMBER, 
                       IGM_DATE, 
                       VESSEL_NATION, 
                       ARRIVAL_DATE_ETA, 
                       ARRIVAL_TIME_ETA, 
                       ARRIVAL_DATE_ATA, 
                       ARRIVAL_TIME_ATA, 
                       TOTAL_BLS, 
                       LIGHT_DUE, 
                       GROSS_WEIGHT, 
                       NET_WEIGHT, 
                       SM_BT_CARGO, 
                       SHIP_STR_DECL, 
                       CREW_LST_DECL, 
                       CARGO_DECL, 
                       PASSNGR_LIST, 
                       CREW_EFFECT, 
                       MARITIME_DECL, 
                       ITEM_NUMBER, 
                       BL_NO, 
                       CFS_NAME, 
                       CARGO_NATURE, 
                       CARGO_MOVMNT, 
                       ITEM_TYPE, 
                       CARGO_MOVMNT_TYPE, 
                       TRANSPORT_MODE, 
                       SUBMIT_DATE_TIME, 
                       DIRECTION, 
                       BL_DATE, 
                       MBL_NO, 
                       HBL_NO, 
                       PACKAGES, 
                       NHAVA_SHEVA_ETA, 
                       FINAL_PLACE_DELIVERY, 
                       POL, 
                       POL_TERMINAL, 
                       DEL,
                       DEPOT,
                       BL_STATUS,
                       BL_VERSION,
                       CUSTOM_TERMINAL_CODE,
                       DPD_MOVEMENT,
                       DPD_CODE,
                       CUSTOMERS_ADDRESS_1,
                       CUSTOMERS_ADDRESS_2,
                       CUSTOMERS_ADDRESS_3,
                       CUSTOMERS_ADDRESS_4,
                       CONSIGNEE_ADDRESS_1 ,
                       CONSIGNEE_ADDRESS_2  ,  
                       CONSIGNEE_ADDRESS_3  ,  
                       CONSIGNEE_ADDRESS_4  ,
                       CONSIGNEE_COUNTRY_CODE,  
                       CONSIGNEE_CODE ,    
                       CONSIGNEE_NAME ,            
                       CONSIGNEE_STATE ,
                       CONSIGNEE_ZIP  ,
                       CONSIGNEE_CITY ,
                       DESCRIPTION,
                       MARKS_AND_NUMBER,
                       NOTIFY_ADDRESS_1,
                       NOTIFY_ADDRESS_2,
                       NOTIFY_ADDRESS_3,
                       NOTIFY_ADDRESS_4,
                       NOTIFY_CITY,
                       NOTIFY_COUNTRY_CODE,
                       NOTIFY_CODE,
                       NOTIFY_NAME,
                       NOTIFY_STATE,
                       NOTIFY_ZIP,
                       CONSIGNER_ADDRESS_1,                                                   
                        CONSIGNER_ADDRESS_2,                                                   
                        CONSIGNER_ADDRESS_3,                                                   
                        CONSIGNER_ADDRESS_4, 
                        CONSIGNER_COUNTRY_CODE,
                        CONSIGNER_CODE,                                                       
                        CONSIGNER_NAME,                                                          
                        CONSIGNER_STATE,   
                        CONSIGNER_ZIP,     
                        CONSIGNER_CITY, 
                       COLOR_FLAG,
                       NET_WEIGHT_METRIC,
                       NET_PACKAGE,
                       DEP_MANIF_NO,
                        DEP_MANIFEST_DATE,
                        SUBMITTER_TYPE,
                        SUBMITTER_CODE,
                        AUTHORIZ_REP_CODE,
                        SHIPPING_LINE_BOND_NO_R,
                        MODE_OF_TRANSPORT,
                        SHIP_TYPE,
                        CONVEYANCE_REFERENCE_NO,
                        TOL_NO_OF_TRANS_EQU_MANIF,
                        CARGO_DESCRIPTION,
                        BRIEF_CARGO_DES,
                        EXPECTED_DATE,
                        TIME_OF_DEPT,
                        PORT_OF_CALL_COD,
                        TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
                        MESSAGE_TYPE,
                        VESSEL_TYPE_MOVEMENT,
                        AUTHORIZED_SEA_CARRIER_CODE,
                        PORT_OF_REGISTRY,
                        REGISTRY_DATE,
                        VOYAGE_DETAILS,
                        SHIP_ITINERARY_SEQUENCE,
                        SHIP_ITINERARY,
                        PORT_OF_CALL_NAME,
                        ARRIVAL_DEPARTURE_DETAILS,
                        TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                        CONSOLIDATED_INDICATOR,
                        PREVIOUS_DECLARATION,
                        CONSOLIDATOR_PAN,
                        CIN_TYPE,
                        MCIN,
                        CSN_SUBMITTED_TYPE,
                        CSN_SUBMITTED_BY,
                        CSN_REPORTING_TYPE,
                        CSN_SITE_ID,
                        CSN_NUMBER,
                        CSN_DATE,
                        PREVIOUS_MCIN,
                        SPLIT_INDICATOR,
                        NUMBER_OF_PACKAGES,
                        TYPE_OF_PACKAGE,
                        FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
                        TYPE_OF_CARGO,
                        SPLIT_INDICATOR_LIST,
                        PORT_OF_ACCEPTANCE,
                        PORT_OF_RECEIPT,
                        UCR_TYPE,
                        UCR_CODE,
                       
                       -- EQUIPMENT_SEAL_TYPE,
                        
                        PORT_OF_ACCEPTANCE_NAME,
                        PORT_OF_RECEIPT_NAME,
                        PAN_OF_NOTIFIED_PARTY,
                        UNIT_OF_WEIGHT,
                        GROSS_VOLUME,
                        UNIT_OF_VOLUME,
                        CARGO_ITEM_SEQUENCE_NO,
                        CARGO_ITEM_DESCRIPTION,
                        CONTAINER_WEIGHT,
                        NUMBER_OF_PACKAGES_HID,
                        TYPE_OF_PACKAGES_HID,
                        PORT_OF_CALL_SEQUENCE_NUMBER,
                        PORT_OF_CALL_CODED,
                        NEXT_PORT_OF_CALL_CODED,
                        MC_LOCATION_CUSTOMS,
                        UNO_CODE,
                        IMDG_CODE) 
          VALUES      ( P_I_V_SERVICE, 
                       P_I_V_VESSEL, 
                       P_I_V_VOYAGE, 
                       P_I_V_PORT, 
                       P_I_V_TERMINAL, 
                       P_I_V_NEW_VESSEL, 
                       P_I_V_NEW_VOYAGE, 
                       P_I_V_FROM_ITEM_NO, 
                       P_I_V_TO_ITEM_NO, 
                       P_I_V_ROAD_CARR_CODE, 
                       P_I_V_ROAD_TP_BOND_NO, 
                       P_I_V_CUST_CODE, 
                       P_I_V_CALL_SIGN, 
                       P_I_V_IMO_CODE, 
                       P_I_V_AGENT_CODE, 
                       P_I_V_LINE_CODE,    
                       P_I_V_PORT_ORIGIN, 
                       P_I_V_PORT_ARRIVAL, 
                       P_I_V_LAST_PORT_1, 
                       P_I_V_LAST_PORT_2, 
                       P_I_V_LAST_PORT_3,
                       P_I_V_NEXT_PORT_1,
                       P_I_V_NEXT_PORT_2,
                       P_I_V_NEXT_PORT_3,
                       P_I_V_VESSEL_TYPE, 
                       P_I_V_GEN_DESC, 
                       P_I_V_MASTER_NAME, 
                       P_I_V_IGM_NUMBER, 
                       P_I_V_IGM_DATE, 
                       P_I_V_VESSEL_NATION, 
                       P_I_V_ARRIVAL_DATE_ETA, 
                       P_I_V_ARRIVAL_TIME_ETA, 
                       P_I_V_ARRIVAL_DATE_ATA, 
                       P_I_V_ARRIVAL_TIME_ATA, 
                       P_I_V_TOTAL_BLS, 
                       P_I_V_LIGHT_DUE, 
                       TO_NUMBER(P_I_V_GROSS_WEIGHT), 
                       TO_NUMBER(P_I_V_NET_WEIGHT), 
                       P_I_V_SM_BT_CARGO, 
                       P_I_V_SHIP_STR_DECL, 
                       P_I_V_CREW_LST_DECL, 
                       P_I_V_CARGO_DECL, 
                       P_I_V_PASSNGR_LIST, 
                       P_I_V_CREW_EFFECT, 
                       P_I_V_MARITIME_DECL, 
                       P_I_V_ITEM_NUMBER, 
                       P_I_V_BL_NO, 
                       P_I_V_CFS_NAME, 
                       P_I_V_CARGO_NATURE, 
                       P_I_V_CARGO_MOVMNT, 
                       P_I_V_ITEM_TYPE, 
                       P_I_V_CARGO_MOVMNT_TYPE, 
                       P_I_V_TRANSPORT_MODE, 
                       P_I_V_SUBMIT_DATE_TIME, 
                       P_I_V_DIRECTION, 
                       P_I_V_BL_DATE, 
                       P_I_V_MBL_NO, 
                       P_I_V_HBL_NO, 
                       P_I_V_PACKAGES, 
                       P_I_V_NHAVA_SHEVA_ETA, 
                       P_I_V_FINAL_PLACE_DELIVERY, 
                       P_I_V_POL, 
                       P_I_V_POL_TERMINAL,
                       P_I_V_DEL,
                       P_I_V_DEPOT,
                       P_I_V_BL_STATUS,
                       P_I_V_BL_VEERSION,
                       P_I_V_CUSTOM_TERMINAL_CODE,
                       P_I_V_DPD_MOVEMENT,
                       P_I_V_DPD_CODE,
                       P_I_V_CUSTOM_ADD1,
                       P_I_V_CUSTOM_ADD2,
                       P_I_V_CUSTOM_ADD3,
                       P_I_V_CUSTOM_ADD4,
                       P_I_V_CONSIGNEE_ADD1, 
                       P_I_V_CONSIGNEE_ADD2,    
                       P_I_V_CONSIGNEE_ADD3,     
                       P_I_V_CONSIGNEE_ADD4,
                       P_I_V_CONSIGNEE_COUNTRYCODE,
                       P_I_V_CONSIGNEE_CODE,
                       P_I_V_CONSIGNEE_NAME,  
                       P_I_V_CONSIGNEE_STATE, 
                       P_I_V_CONSIGNEE_ZIP,  
                       P_I_V_CONSIGNEE_CITY,
                       P_I_V_MARKSNUMBER_DESCRIPTION,
                       P_I_V_MARKSNUMBER_MARKS,
                       P_I_V_NOTIFYPARTY_ADD1,
                       P_I_V_NOTIFYPARTY_ADD2,
                       P_I_V_NOTIFYPARTY_ADD3,
                       P_I_V_NOTIFYPARTY_ADD4,
                       P_I_V_NOTIFYPARTY_CITY,
                       P_I_V_NOTIFYPARTY_COUNTRYCODE,
                       P_I_V_NOTIFYPARTY_CODE,
                       P_I_V_NOTIFYPARTY_NAME,
			           P_I_V_NOTIFYPARTY_STATE,
                       P_I_V_NOTIFYPARTY_ZIP,
                       P_I_V_CONSIGNER_ADD1,
                        P_I_V_CONSIGNER_ADD2,
                        P_I_V_CONSIGNER_ADD3,
                        P_I_V_CONSIGNER_ADD4,
                        P_I_V_CONSIGNER_COUNTRYCODE,
                        P_I_V_CONSIGNER_CODE,
                        P_I_V_CONSIGNER_NAME,
                        P_I_V_CONSIGNER_STATE,
                        P_I_V_CONSIGNER_ZIP,
                        P_I_V_CONSIGNER_CITY,
                       P_I_V_COLOR_FLAG,
                       P_I_V_GROSS_CARGO_WEIGHT_BL_LEVEL,
                       P_I_V_PACKAGE_BL_LEVEL,
                       P_I_V_DEP_MANIF_NO,
                        P_I_V_DEP_MANIFEST_DATE,
                        P_I_V_SUBMITTER_TYPE,
                        P_I_V_SUBMITTER_CODE,
                        P_I_V_AUTHORIZ_REP_CODE,
                        P_I_V_SHIPPING_LINE_BOND_NO_R,
                        P_I_V_MODE_OF_TRANSPORT,
                        P_I_V_SHIP_TYPE,
                        P_I_V_CONVEYANCE_REFERENCE_NO,
                        P_I_V_CARGO_DESCRIPTION,
                        P_I_V_TOL_NO_OF_TRANS_EQU_MANIF,
                        P_I_V_BRIEF_CARGO_DES,
                        P_I_V_EXPECTED_DATE,
                        P_I_V_TIME_OF_DEPT,
                        P_I_V_PORT_OF_CALL_COD,
                        P_I_V_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
                        P_I_V_MESSAGE_TYPE,
                        P_I_V_VESSEL_TYPE_MOVEMENT,
                        P_I_V_AUTHORIZED_SEA_CARRIER_CODE,
                        P_I_V_PORT_OF_REGISTRY,
                        P_I_V_REGISTRY_DATE,
                        P_I_V_VOYAGE_DETAILS,
                        P_I_V_SHIP_ITINERARY_SEQUENCE,
                        P_I_V_SHIP_ITINERARY,
                        P_I_V_PORT_OF_CALL_NAME,
                        P_I_V_ARRIVAL_DEPARTURE_DETAILS,
                        P_I_V_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                        P_I_V_CONSOLIDATED_INDICATOR,
                        P_I_V_PREVIOUS_DECLARATION,
                        P_I_V_CONSOLIDATOR_PAN,
                        P_I_V_CIN_TYPE,
                        P_I_V_MCIN,
                        P_I_V_CSN_SUBMITTED_TYPE,
                        P_I_V_CSN_SUBMITTED_BY,
                        P_I_V_CSN_REPORTING_TYPE,
                        P_I_V_CSN_SITE_ID,
                        P_I_V_CSN_NUMBER,
                        P_I_V_CSN_DATE,
                        P_I_V_PREVIOUS_MCIN,
                        P_I_V_SPLIT_INDICATOR,
                        P_I_V_NUMBER_OF_PACKAGES,
                        P_I_V_TYPE_OF_PACKAGE,
                        P_I_V_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
                        P_I_V_TYPE_OF_CARGO,
                        P_I_V_SPLIT_INDICATOR_LIST,
                        P_I_V_PORT_OF_ACCEPTANCE,
                        P_I_V_PORT_OF_RECEIPT,
                        P_I_V_UCR_TYPE,
                        P_I_V_UCR_CODE,
                       
                     --   P_I_V_EQUIPMENT_SEAL_TYPE,
                        
                        P_I_V_PORT_OF_ACCEPTANCE_NAME,
                        P_I_V_PORT_OF_RECEIPT_NAME,
                        P_I_V_PAN_OF_NOTIFIED_PARTY,
                        P_I_V_UNIT_OF_WEIGHT,
                        P_I_V_GROSS_VOLUME,
                        P_I_V_UNIT_OF_VOLUME,
                        P_I_V_CARGO_ITEM_SEQUENCE_NO,
                        P_I_V_CARGO_ITEM_DESCRIPTION,
                        P_I_V_CONTAINER_WEIGHT,
                        P_I_V_NUMBER_OF_PACKAGES_HID,
                        P_I_V_TYPE_OF_PACKAGES_HID,
                        P_I_V_PORT_OF_CALL_SEQUENCE_NUMBER,
                        P_I_V_PORT_OF_CALL_CODED,
                        P_I_V_NEXT_PORT_OF_CALL_CODED,
                        P_I_V_MC_LOCATION_CUSTOMS,
                        P_I_V_UNO_CODE,
                        P_I_V_IMDG_CODE); 
        ELSE 
          DBMS_OUTPUT.PUT_LINE('Record updated..!!'); 
        END IF; 

        UPDATE RCL_IGM_DETAILS 
        SET    NEW_VESSEL = P_I_V_NEW_VESSEL, 
               NEW_VOYAGE = P_I_V_NEW_VOYAGE, 
               FROM_ITEM_NO = P_I_V_FROM_ITEM_NO, 
               TO_ITEM_NO = P_I_V_TO_ITEM_NO, 
               CUST_CODE = P_I_V_CUST_CODE, 
               CALL_SIGN = P_I_V_CALL_SIGN, 
               IMO_CODE = P_I_V_IMO_CODE, 
               AGENT_CODE = P_I_V_AGENT_CODE, 
               LINE_CODE = P_I_V_LINE_CODE, 
               PORT_ORIGIN = P_I_V_PORT_ORIGIN, 
               PORT_ARRIVAL = P_I_V_PORT_ARRIVAL, 
               LAST_PORT_1 = P_I_V_LAST_PORT_1, 
               LAST_PORT_2 = P_I_V_LAST_PORT_2, 
               LAST_PORT_3 = P_I_V_LAST_PORT_3, 
               NEXT_PORT_4=P_I_V_NEXT_PORT_1,
               NEXT_PORT_5=P_I_V_NEXT_PORT_2,
               NEXT_PORT_6=P_I_V_NEXT_PORT_3,
               VESSEL_TYPE = P_I_V_VESSEL_TYPE, 
               GEN_DESC = P_I_V_GEN_DESC, 
               MASTER_NAME = P_I_V_MASTER_NAME, 
               IGM_NUMBER = P_I_V_IGM_NUMBER, 
               IGM_DATE = P_I_V_IGM_DATE, 
               VESSEL_NATION = P_I_V_VESSEL_NATION, 
               ARRIVAL_DATE_ETA = P_I_V_ARRIVAL_DATE_ETA, 
               ARRIVAL_TIME_ETA = P_I_V_ARRIVAL_TIME_ETA, 
               ARRIVAL_DATE_ATA = P_I_V_ARRIVAL_DATE_ATA, 
               ARRIVAL_TIME_ATA = P_I_V_ARRIVAL_TIME_ATA, 
               TOTAL_BLS = P_I_V_TOTAL_BLS, 
               LIGHT_DUE = P_I_V_LIGHT_DUE, 
               GROSS_WEIGHT = TO_NUMBER(P_I_V_GROSS_WEIGHT), 
               NET_WEIGHT = TO_NUMBER(P_I_V_NET_WEIGHT), 
               SM_BT_CARGO = P_I_V_SM_BT_CARGO, 
               SHIP_STR_DECL = P_I_V_SHIP_STR_DECL, 
               CREW_LST_DECL = P_I_V_CREW_LST_DECL, 
               CARGO_DECL = P_I_V_CARGO_DECL, 
               PASSNGR_LIST = P_I_V_PASSNGR_LIST, 
               CREW_EFFECT = P_I_V_CREW_EFFECT, 
               MARITIME_DECL = P_I_V_MARITIME_DECL,
               CUSTOM_TERMINAL_CODE=P_I_V_CUSTOM_TERMINAL_CODE,
               DEP_MANIF_NO=P_I_V_DEP_MANIF_NO,
                DEP_MANIFEST_DATE=P_I_V_DEP_MANIFEST_DATE,
                SUBMITTER_TYPE=P_I_V_SUBMITTER_TYPE,
                SUBMITTER_CODE=P_I_V_SUBMITTER_CODE,
                AUTHORIZ_REP_CODE=P_I_V_AUTHORIZ_REP_CODE,
                SHIPPING_LINE_BOND_NO_R=P_I_V_SHIPPING_LINE_BOND_NO_R, 
                MODE_OF_TRANSPORT=P_I_V_MODE_OF_TRANSPORT,
                SHIP_TYPE=P_I_V_SHIP_TYPE,
                CONVEYANCE_REFERENCE_NO=P_I_V_CONVEYANCE_REFERENCE_NO       , 
                TOL_NO_OF_TRANS_EQU_MANIF=P_I_V_CARGO_DESCRIPTION ,
                CARGO_DESCRIPTION=P_I_V_TOL_NO_OF_TRANS_EQU_MANIF,
                BRIEF_CARGO_DES=P_I_V_BRIEF_CARGO_DES,
                EXPECTED_DATE=P_I_V_EXPECTED_DATE,
                TIME_OF_DEPT=P_I_V_TIME_OF_DEPT,
                PORT_OF_CALL_COD=P_I_V_PORT_OF_CALL_COD,
                TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP=P_I_V_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP, 
                MESSAGE_TYPE=P_I_V_MESSAGE_TYPE,
                VESSEL_TYPE_MOVEMENT=P_I_V_VESSEL_TYPE_MOVEMENT,
                AUTHORIZED_SEA_CARRIER_CODE=P_I_V_AUTHORIZED_SEA_CARRIER_CODE       , 
                PORT_OF_REGISTRY=P_I_V_PORT_OF_REGISTRY ,
                REGISTRY_DATE=P_I_V_REGISTRY_DATE,
                VOYAGE_DETAILS=P_I_V_VOYAGE_DETAILS,
                SHIP_ITINERARY_SEQUENCE=P_I_V_SHIP_ITINERARY_SEQUENCE,
                SHIP_ITINERARY=P_I_V_SHIP_ITINERARY,
                PORT_OF_CALL_NAME=P_I_V_PORT_OF_CALL_NAME,
                ARRIVAL_DEPARTURE_DETAILS=P_I_V_ARRIVAL_DEPARTURE_DETAILS, 
                TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE=P_I_V_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE
               
        WHERE  SERVICE = P_I_V_SERVICE 
               AND VESSEL = P_I_V_VESSEL 
               AND VOYAGE = P_I_V_VOYAGE 
               AND PORT = P_I_V_PORT 
               AND TERMINAL = P_I_V_TERMINAL; 
               
    ELSE
    
        UPDATE RCL_IGM_DETAILS 
        SET    NEW_VESSEL = P_I_V_NEW_VESSEL, 
               NEW_VOYAGE = P_I_V_NEW_VOYAGE, 
               FROM_ITEM_NO = P_I_V_FROM_ITEM_NO, 
               TO_ITEM_NO = P_I_V_TO_ITEM_NO, 
               ROAD_CARR_CODE = P_I_V_ROAD_CARR_CODE, 
               ROAD_TP_BOND_NO = P_I_V_ROAD_TP_BOND_NO, 
               CUST_CODE = P_I_V_CUST_CODE, 
               CALL_SIGN = P_I_V_CALL_SIGN, 
               IMO_CODE = P_I_V_IMO_CODE, 
               AGENT_CODE = P_I_V_AGENT_CODE, 
               LINE_CODE = P_I_V_LINE_CODE, 
               PORT_ORIGIN = P_I_V_PORT_ORIGIN, 
               PORT_ARRIVAL = P_I_V_PORT_ARRIVAL, 
               LAST_PORT_1 = P_I_V_LAST_PORT_1, 
               LAST_PORT_2 = P_I_V_LAST_PORT_2, 
               LAST_PORT_3 = P_I_V_LAST_PORT_3,
               NEXT_PORT_4=P_I_V_NEXT_PORT_1,
               NEXT_PORT_5=P_I_V_NEXT_PORT_2,
               NEXT_PORT_6=P_I_V_NEXT_PORT_3,
               VESSEL_TYPE = P_I_V_VESSEL_TYPE, 
               GEN_DESC = P_I_V_GEN_DESC, 
               MASTER_NAME = P_I_V_MASTER_NAME, 
               IGM_NUMBER = P_I_V_IGM_NUMBER, 
               IGM_DATE = P_I_V_IGM_DATE, 
               VESSEL_NATION = P_I_V_VESSEL_NATION, 
               ARRIVAL_DATE_ETA = P_I_V_ARRIVAL_DATE_ETA, 
               ARRIVAL_TIME_ETA = P_I_V_ARRIVAL_TIME_ETA, 
               ARRIVAL_DATE_ATA = P_I_V_ARRIVAL_DATE_ATA, 
               ARRIVAL_TIME_ATA = P_I_V_ARRIVAL_TIME_ATA, 
               TOTAL_BLS = P_I_V_TOTAL_BLS, 
               LIGHT_DUE = P_I_V_LIGHT_DUE, 
               GROSS_WEIGHT = TO_NUMBER(P_I_V_GROSS_WEIGHT), 
               NET_WEIGHT = TO_NUMBER(P_I_V_NET_WEIGHT), 
               SM_BT_CARGO = P_I_V_SM_BT_CARGO, 
               SHIP_STR_DECL = P_I_V_SHIP_STR_DECL, 
               CREW_LST_DECL = P_I_V_CREW_LST_DECL, 
               CARGO_DECL = P_I_V_CARGO_DECL, 
               PASSNGR_LIST = P_I_V_PASSNGR_LIST, 
               CREW_EFFECT = P_I_V_CREW_EFFECT, 
               MARITIME_DECL = P_I_V_MARITIME_DECL, 
               ITEM_NUMBER = P_I_V_ITEM_NUMBER, 
               CFS_NAME = P_I_V_CFS_NAME, 
               CARGO_NATURE = P_I_V_CARGO_NATURE, 
               CARGO_MOVMNT = P_I_V_CARGO_MOVMNT, 
               ITEM_TYPE = P_I_V_ITEM_TYPE, 
               CARGO_MOVMNT_TYPE = P_I_V_CARGO_MOVMNT_TYPE, 
               TRANSPORT_MODE = P_I_V_TRANSPORT_MODE, 
               SUBMIT_DATE_TIME = P_I_V_SUBMIT_DATE_TIME, 
               DIRECTION = P_I_V_DIRECTION, 
               BL_DATE = P_I_V_BL_DATE, 
               MBL_NO = P_I_V_MBL_NO, 
               HBL_NO = P_I_V_HBL_NO, 
               PACKAGES = P_I_V_PACKAGES, 
               NHAVA_SHEVA_ETA = P_I_V_NHAVA_SHEVA_ETA, 
               FINAL_PLACE_DELIVERY = P_I_V_FINAL_PLACE_DELIVERY, 
               BL_STATUS = P_I_V_BL_STATUS, 
               POL = P_I_V_POL, 
               POL_TERMINAL = P_I_V_POL_TERMINAL,
               DEL=P_I_V_DEL,
               DEPOT=P_I_V_DEPOT,
               BL_VERSION=P_I_V_BL_VEERSION,
               CUSTOM_TERMINAL_CODE=P_I_V_CUSTOM_TERMINAL_CODE,
               DPD_MOVEMENT=P_I_V_DPD_MOVEMENT,
               DPD_CODE=P_I_V_DPD_CODE,
               CUSTOMERS_ADDRESS_1=P_I_V_CUSTOM_ADD1,
               CUSTOMERS_ADDRESS_2=P_I_V_CUSTOM_ADD2,
               CUSTOMERS_ADDRESS_3=P_I_V_CUSTOM_ADD3,
               CUSTOMERS_ADDRESS_4=P_I_V_CUSTOM_ADD4,
               COLOR_FLAG=P_I_V_COLOR_FLAG,
               NET_WEIGHT_METRIC=P_I_V_GROSS_CARGO_WEIGHT_BL_LEVEL,
               NET_PACKAGE=P_I_V_PACKAGE_BL_LEVEL,
               
               CONSIGNEE_ADDRESS_1 = P_I_V_CONSIGNEE_ADD1,      
               CONSIGNEE_ADDRESS_2 = P_I_V_CONSIGNEE_ADD2,      
               CONSIGNEE_ADDRESS_3 = P_I_V_CONSIGNEE_ADD3,       
               CONSIGNEE_ADDRESS_4 =  P_I_V_CONSIGNEE_ADD4,
               CONSIGNEE_COUNTRY_CODE = P_I_V_CONSIGNEE_COUNTRYCODE,
               CONSIGNEE_CODE  =  P_I_V_CONSIGNEE_CODE,   
               CONSIGNEE_NAME  =  P_I_V_CONSIGNEE_NAME,           
               CONSIGNEE_STATE = P_I_V_CONSIGNEE_STATE, 
               CONSIGNEE_ZIP  = P_I_V_CONSIGNEE_ZIP,  
               CONSIGNEE_CITY = P_I_V_CONSIGNEE_CITY,            
                            
               DESCRIPTION  = P_I_V_MARKSNUMBER_DESCRIPTION,
               MARKS_AND_NUMBER = P_I_V_MARKSNUMBER_MARKS,  
              
               NOTIFY_ADDRESS_1=P_I_V_NOTIFYPARTY_ADD1,
               NOTIFY_ADDRESS_2=P_I_V_NOTIFYPARTY_ADD2,
               NOTIFY_ADDRESS_3=P_I_V_NOTIFYPARTY_ADD3,
               NOTIFY_ADDRESS_4=P_I_V_NOTIFYPARTY_ADD4,
               NOTIFY_CITY=P_I_V_NOTIFYPARTY_CITY,
               NOTIFY_COUNTRY_CODE=P_I_V_NOTIFYPARTY_COUNTRYCODE,
               NOTIFY_CODE=P_I_V_NOTIFYPARTY_CODE,
               NOTIFY_NAME=P_I_V_NOTIFYPARTY_NAME,
               NOTIFY_STATE=P_I_V_NOTIFYPARTY_STATE,
               NOTIFY_ZIP=P_I_V_NOTIFYPARTY_ZIP,
               
               CONSIGNER_ADDRESS_1=P_I_V_CONSIGNER_ADD1,
                CONSIGNER_ADDRESS_2=P_I_V_CONSIGNER_ADD2,
                CONSIGNER_ADDRESS_3=P_I_V_CONSIGNER_ADD3,
                CONSIGNER_ADDRESS_4=P_I_V_CONSIGNER_ADD4,
                CONSIGNER_COUNTRY_CODE=P_I_V_CONSIGNER_COUNTRYCODE		,
                CONSIGNER_CODE=P_I_V_CONSIGNER_CODE,
                CONSIGNER_NAME=P_I_V_CONSIGNER_NAME,
                CONSIGNER_STATE=	P_I_V_CONSIGNER_STATE,
                CONSIGNER_ZIP=P_I_V_CONSIGNER_ZIP,
                CONSIGNER_CITY=P_I_V_CONSIGNER_CITY,
               --NEW VESSEL/VOYAGE SECTION 10-12-19 
                DEP_MANIF_NO=P_I_V_DEP_MANIF_NO,
                DEP_MANIFEST_DATE=P_I_V_DEP_MANIFEST_DATE,
                SUBMITTER_TYPE=P_I_V_SUBMITTER_TYPE,
                SUBMITTER_CODE=P_I_V_SUBMITTER_CODE,
                AUTHORIZ_REP_CODE=P_I_V_AUTHORIZ_REP_CODE,
                SHIPPING_LINE_BOND_NO_R=P_I_V_SHIPPING_LINE_BOND_NO_R, 
                MODE_OF_TRANSPORT=P_I_V_MODE_OF_TRANSPORT,
                SHIP_TYPE=P_I_V_SHIP_TYPE,
                CONVEYANCE_REFERENCE_NO=P_I_V_CONVEYANCE_REFERENCE_NO       , 
                TOL_NO_OF_TRANS_EQU_MANIF=P_I_V_CARGO_DESCRIPTION ,
                CARGO_DESCRIPTION=P_I_V_TOL_NO_OF_TRANS_EQU_MANIF,
                BRIEF_CARGO_DES=P_I_V_BRIEF_CARGO_DES,
                EXPECTED_DATE=P_I_V_EXPECTED_DATE,
                TIME_OF_DEPT=P_I_V_TIME_OF_DEPT,
                PORT_OF_CALL_COD=P_I_V_PORT_OF_CALL_COD,
                TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP=P_I_V_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP, 
                MESSAGE_TYPE=P_I_V_MESSAGE_TYPE,
                VESSEL_TYPE_MOVEMENT=P_I_V_VESSEL_TYPE_MOVEMENT,
                AUTHORIZED_SEA_CARRIER_CODE=P_I_V_AUTHORIZED_SEA_CARRIER_CODE       , 
                PORT_OF_REGISTRY=P_I_V_PORT_OF_REGISTRY ,
                REGISTRY_DATE=P_I_V_REGISTRY_DATE,
                VOYAGE_DETAILS=P_I_V_VOYAGE_DETAILS,
                SHIP_ITINERARY_SEQUENCE=P_I_V_SHIP_ITINERARY_SEQUENCE,
                SHIP_ITINERARY=P_I_V_SHIP_ITINERARY,
                PORT_OF_CALL_NAME=P_I_V_PORT_OF_CALL_NAME,
                ARRIVAL_DEPARTURE_DETAILS=P_I_V_ARRIVAL_DEPARTURE_DETAILS, 
                TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE=P_I_V_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,  
                --VESSEL/VOYAGE SECTION END
                --NEW BL SECTION 10-12-19 
                CONSOLIDATED_INDICATOR=P_I_V_CONSOLIDATED_INDICATOR,
                PREVIOUS_DECLARATION=P_I_V_PREVIOUS_DECLARATION,
                CONSOLIDATOR_PAN=P_I_V_CONSOLIDATOR_PAN,
                CIN_TYPE=P_I_V_CIN_TYPE,
                MCIN=P_I_V_MCIN,
                CSN_SUBMITTED_TYPE=P_I_V_CSN_SUBMITTED_TYPE, 
                CSN_SUBMITTED_BY=P_I_V_CSN_SUBMITTED_BY,
                CSN_REPORTING_TYPE=P_I_V_CSN_REPORTING_TYPE,
                CSN_SITE_ID=P_I_V_CSN_SITE_ID       , 
                CSN_NUMBER=P_I_V_CSN_NUMBER ,
                CSN_DATE=P_I_V_CSN_DATE,
                PREVIOUS_MCIN=P_I_V_PREVIOUS_MCIN,
                SPLIT_INDICATOR=P_I_V_SPLIT_INDICATOR,
                NUMBER_OF_PACKAGES=P_I_V_NUMBER_OF_PACKAGES,
                TYPE_OF_PACKAGE=P_I_V_TYPE_OF_PACKAGE,
                FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE=P_I_V_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE, 
                TYPE_OF_CARGO=P_I_V_TYPE_OF_CARGO,
                SPLIT_INDICATOR_LIST=P_I_V_SPLIT_INDICATOR_LIST,
                PORT_OF_ACCEPTANCE=P_I_V_PORT_OF_ACCEPTANCE       , 
                PORT_OF_RECEIPT=P_I_V_PORT_OF_RECEIPT ,
                UCR_TYPE=P_I_V_UCR_TYPE,
                UCR_CODE=P_I_V_UCR_CODE,
                
               -- EQUIPMENT_SEAL_TYPE=P_I_V_EQUIPMENT_SEAL_TYPE,
                
                PORT_OF_ACCEPTANCE_NAME=P_I_V_PORT_OF_ACCEPTANCE_NAME, 
                PORT_OF_RECEIPT_NAME=P_I_V_PORT_OF_RECEIPT_NAME,
                PAN_OF_NOTIFIED_PARTY=P_I_V_PAN_OF_NOTIFIED_PARTY,
                UNIT_OF_WEIGHT=P_I_V_UNIT_OF_WEIGHT,
                GROSS_VOLUME=P_I_V_GROSS_VOLUME,
                UNIT_OF_VOLUME=P_I_V_UNIT_OF_VOLUME, 
                CARGO_ITEM_SEQUENCE_NO=P_I_V_CARGO_ITEM_SEQUENCE_NO,
                CARGO_ITEM_DESCRIPTION=P_I_V_CARGO_ITEM_DESCRIPTION,
                CONTAINER_WEIGHT=P_I_V_CONTAINER_WEIGHT       , 
                NUMBER_OF_PACKAGES_HID=P_I_V_NUMBER_OF_PACKAGES_HID ,
                TYPE_OF_PACKAGES_HID=P_I_V_TYPE_OF_PACKAGES_HID,
                PORT_OF_CALL_SEQUENCE_NUMBER=P_I_V_PORT_OF_CALL_SEQUENCE_NUMBER,
                PORT_OF_CALL_CODED=P_I_V_PORT_OF_CALL_CODED,
                NEXT_PORT_OF_CALL_CODED=P_I_V_NEXT_PORT_OF_CALL_CODED,
                MC_LOCATION_CUSTOMS=P_I_V_MC_LOCATION_CUSTOMS,
                UNO_CODE=P_I_V_UNO_CODE, 
                IMDG_CODE=P_I_V_IMDG_CODE
               
        WHERE  SERVICE = P_I_V_SERVICE 
               AND VESSEL = P_I_V_VESSEL 
               AND VOYAGE = P_I_V_VOYAGE 
               AND PORT = P_I_V_PORT 
               AND TERMINAL = P_I_V_TERMINAL 
               AND BL_NO = P_I_V_BL_NO; 

        IF SQL%ROWCOUNT = 0 THEN 
          DBMS_OUTPUT.PUT_LINE('Record inserted..!!'); 

          INSERT INTO RCL_IGM_DETAILS 
                      (SERVICE, 
                       VESSEL, 
                       VOYAGE, 
                       PORT, 
                       TERMINAL, 
                       NEW_VESSEL, 
                       NEW_VOYAGE, 
                       FROM_ITEM_NO, 
                       TO_ITEM_NO, 
                       ROAD_CARR_CODE, 
                       ROAD_TP_BOND_NO, 
                       CUST_CODE, 
                       CALL_SIGN, 
                       IMO_CODE, 
                       AGENT_CODE, 
                       LINE_CODE, 
                       PORT_ORIGIN, 
                       PORT_ARRIVAL, 
                       LAST_PORT_1, 
                       LAST_PORT_2, 
                       LAST_PORT_3,
                       NEXT_PORT_4,
                       NEXT_PORT_5,
                       NEXT_PORT_6,
                       VESSEL_TYPE, 
                       GEN_DESC, 
                       MASTER_NAME, 
                       IGM_NUMBER, 
                       IGM_DATE, 
                       VESSEL_NATION, 
                       ARRIVAL_DATE_ETA, 
                       ARRIVAL_TIME_ETA, 
                       ARRIVAL_DATE_ATA, 
                       ARRIVAL_TIME_ATA, 
                       TOTAL_BLS, 
                       LIGHT_DUE, 
                       GROSS_WEIGHT, 
                       NET_WEIGHT, 
                       SM_BT_CARGO, 
                       SHIP_STR_DECL, 
                       CREW_LST_DECL, 
                       CARGO_DECL, 
                       PASSNGR_LIST, 
                       CREW_EFFECT, 
                       MARITIME_DECL, 
                       ITEM_NUMBER, 
                       BL_NO, 
                       CFS_NAME, 
                       CARGO_NATURE, 
                       CARGO_MOVMNT, 
                       ITEM_TYPE, 
                       CARGO_MOVMNT_TYPE, 
                       TRANSPORT_MODE, 
                       SUBMIT_DATE_TIME, 
                       DIRECTION, 
                       BL_DATE, 
                       MBL_NO, 
                       HBL_NO, 
                       PACKAGES, 
                       NHAVA_SHEVA_ETA, 
                       FINAL_PLACE_DELIVERY, 
                       POL, 
                       POL_TERMINAL, 
                       DEL,
                       DEPOT,
                       BL_STATUS,
                       BL_VERSION,
                       CUSTOM_TERMINAL_CODE,
                       DPD_MOVEMENT,
                       DPD_CODE,
                       CUSTOMERS_ADDRESS_1,
                       CUSTOMERS_ADDRESS_2,
                       CUSTOMERS_ADDRESS_3,
                       CUSTOMERS_ADDRESS_4,
                       CONSIGNEE_ADDRESS_1 ,
                       CONSIGNEE_ADDRESS_2  ,  
                       CONSIGNEE_ADDRESS_3  ,  
                       CONSIGNEE_ADDRESS_4  ,
                       CONSIGNEE_COUNTRY_CODE,  
                       CONSIGNEE_CODE ,    
                       CONSIGNEE_NAME ,            
                       CONSIGNEE_STATE ,
                       CONSIGNEE_ZIP  ,
                       CONSIGNEE_CITY ,
                       DESCRIPTION,
                       MARKS_AND_NUMBER,
                       NOTIFY_ADDRESS_1,
                       NOTIFY_ADDRESS_2,
                       NOTIFY_ADDRESS_3,
                       NOTIFY_ADDRESS_4,
                       NOTIFY_CITY,
                       NOTIFY_COUNTRY_CODE,
                       NOTIFY_CODE,
                       NOTIFY_NAME,
                       NOTIFY_STATE,
                       NOTIFY_ZIP,
                       CONSIGNER_ADDRESS_1,                                                   
                        CONSIGNER_ADDRESS_2,                                                   
                        CONSIGNER_ADDRESS_3,                                                   
                        CONSIGNER_ADDRESS_4, 
                        CONSIGNER_COUNTRY_CODE,
                        CONSIGNER_CODE,                                                       
                        CONSIGNER_NAME,                                                          
                        CONSIGNER_STATE,   
                        CONSIGNER_ZIP,     
                        CONSIGNER_CITY, 
                       COLOR_FLAG,
                       NET_WEIGHT_METRIC,
                       NET_PACKAGE,
                       DEP_MANIF_NO,
                        DEP_MANIFEST_DATE,
                        SUBMITTER_TYPE,
                        SUBMITTER_CODE,
                        AUTHORIZ_REP_CODE,
                        SHIPPING_LINE_BOND_NO_R,
                        MODE_OF_TRANSPORT,
                        SHIP_TYPE,
                        CONVEYANCE_REFERENCE_NO,
                        TOL_NO_OF_TRANS_EQU_MANIF,
                        CARGO_DESCRIPTION,
                        BRIEF_CARGO_DES,
                        EXPECTED_DATE,
                        TIME_OF_DEPT,
                        PORT_OF_CALL_COD,
                        TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
                        MESSAGE_TYPE,
                        VESSEL_TYPE_MOVEMENT,
                        AUTHORIZED_SEA_CARRIER_CODE,
                        PORT_OF_REGISTRY,
                        REGISTRY_DATE,
                        VOYAGE_DETAILS,
                        SHIP_ITINERARY_SEQUENCE,
                        SHIP_ITINERARY,
                        PORT_OF_CALL_NAME,
                        ARRIVAL_DEPARTURE_DETAILS,
                        TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                        CONSOLIDATED_INDICATOR,
                        PREVIOUS_DECLARATION,
                        CONSOLIDATOR_PAN,
                        CIN_TYPE,
                        MCIN,
                        CSN_SUBMITTED_TYPE,
                        CSN_SUBMITTED_BY,
                        CSN_REPORTING_TYPE,
                        CSN_SITE_ID,
                        CSN_NUMBER,
                        CSN_DATE,
                        PREVIOUS_MCIN,
                        SPLIT_INDICATOR,
                        NUMBER_OF_PACKAGES,
                        TYPE_OF_PACKAGE,
                        FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
                        TYPE_OF_CARGO,
                        SPLIT_INDICATOR_LIST,
                        PORT_OF_ACCEPTANCE,
                        PORT_OF_RECEIPT,
                        UCR_TYPE,
                        UCR_CODE,
                        
                      --  EQUIPMENT_SEAL_TYPE,
                        
                        PORT_OF_ACCEPTANCE_NAME,
                        PORT_OF_RECEIPT_NAME,
                        PAN_OF_NOTIFIED_PARTY,
                        UNIT_OF_WEIGHT,
                        GROSS_VOLUME,
                        UNIT_OF_VOLUME,
                        CARGO_ITEM_SEQUENCE_NO,
                        CARGO_ITEM_DESCRIPTION,
                        CONTAINER_WEIGHT,
                        NUMBER_OF_PACKAGES_HID,
                        TYPE_OF_PACKAGES_HID,
                        PORT_OF_CALL_SEQUENCE_NUMBER,
                        PORT_OF_CALL_CODED,
                        NEXT_PORT_OF_CALL_CODED,
                        MC_LOCATION_CUSTOMS,
                        UNO_CODE,
                        IMDG_CODE) 
          VALUES      ( P_I_V_SERVICE, 
                       P_I_V_VESSEL, 
                       P_I_V_VOYAGE, 
                       P_I_V_PORT, 
                       P_I_V_TERMINAL, 
                       P_I_V_NEW_VESSEL, 
                       P_I_V_NEW_VOYAGE, 
                       P_I_V_FROM_ITEM_NO, 
                       P_I_V_TO_ITEM_NO, 
                       P_I_V_ROAD_CARR_CODE, 
                       P_I_V_ROAD_TP_BOND_NO, 
                       P_I_V_CUST_CODE, 
                       P_I_V_CALL_SIGN, 
                       P_I_V_IMO_CODE, 
                       P_I_V_AGENT_CODE, 
                       P_I_V_LINE_CODE, 
                       P_I_V_PORT_ORIGIN, 
                       P_I_V_PORT_ARRIVAL, 
                       P_I_V_LAST_PORT_1, 
                       P_I_V_LAST_PORT_2, 
                       P_I_V_LAST_PORT_3,
                       P_I_V_NEXT_PORT_1,
                       P_I_V_NEXT_PORT_2,
                       P_I_V_NEXT_PORT_3,
                       P_I_V_VESSEL_TYPE, 
                       P_I_V_GEN_DESC, 
                       P_I_V_MASTER_NAME, 
                       P_I_V_IGM_NUMBER, 
                       P_I_V_IGM_DATE, 
                       P_I_V_VESSEL_NATION, 
                       P_I_V_ARRIVAL_DATE_ETA, 
                       P_I_V_ARRIVAL_TIME_ETA, 
                       P_I_V_ARRIVAL_DATE_ATA, 
                       P_I_V_ARRIVAL_TIME_ATA, 
                       P_I_V_TOTAL_BLS, 
                       P_I_V_LIGHT_DUE, 
                       TO_NUMBER(P_I_V_GROSS_WEIGHT), 
                       TO_NUMBER(P_I_V_NET_WEIGHT), 
                       P_I_V_SM_BT_CARGO, 
                       P_I_V_SHIP_STR_DECL, 
                       P_I_V_CREW_LST_DECL, 
                       P_I_V_CARGO_DECL, 
                       P_I_V_PASSNGR_LIST, 
                       P_I_V_CREW_EFFECT, 
                       P_I_V_MARITIME_DECL, 
                       P_I_V_ITEM_NUMBER, 
                       P_I_V_BL_NO, 
                       P_I_V_CFS_NAME, 
                       P_I_V_CARGO_NATURE, 
                       P_I_V_CARGO_MOVMNT, 
                       P_I_V_ITEM_TYPE, 
                       P_I_V_CARGO_MOVMNT_TYPE, 
                       P_I_V_TRANSPORT_MODE, 
                       P_I_V_SUBMIT_DATE_TIME, 
                       P_I_V_DIRECTION, 
                       P_I_V_BL_DATE, 
                       P_I_V_MBL_NO, 
                       P_I_V_HBL_NO, 
                       P_I_V_PACKAGES, 
                       P_I_V_NHAVA_SHEVA_ETA, 
                       P_I_V_FINAL_PLACE_DELIVERY, 
                       P_I_V_POL, 
                       P_I_V_POL_TERMINAL,
                       P_I_V_DEL,
                       P_I_V_DEPOT,
                       P_I_V_BL_STATUS,
                       P_I_V_BL_VEERSION,
                       P_I_V_CUSTOM_TERMINAL_CODE,
                       P_I_V_DPD_MOVEMENT,
                       P_I_V_DPD_CODE,
                       P_I_V_CUSTOM_ADD1,
                       P_I_V_CUSTOM_ADD2,
                       P_I_V_CUSTOM_ADD3,
                       P_I_V_CUSTOM_ADD4,
                       P_I_V_CONSIGNEE_ADD1, 
                       P_I_V_CONSIGNEE_ADD2,    
                       P_I_V_CONSIGNEE_ADD3,     
                       P_I_V_CONSIGNEE_ADD4,
                       P_I_V_CONSIGNEE_COUNTRYCODE,
                       P_I_V_CONSIGNEE_CODE,
                       P_I_V_CONSIGNEE_NAME,  
                       P_I_V_CONSIGNEE_STATE, 
                       P_I_V_CONSIGNEE_ZIP,  
                       P_I_V_CONSIGNEE_CITY,
                       P_I_V_MARKSNUMBER_DESCRIPTION,
                       P_I_V_MARKSNUMBER_MARKS,
                       P_I_V_NOTIFYPARTY_ADD1,
                       P_I_V_NOTIFYPARTY_ADD2,
                       P_I_V_NOTIFYPARTY_ADD3,
                       P_I_V_NOTIFYPARTY_ADD4,
                       P_I_V_NOTIFYPARTY_CITY,
                       P_I_V_NOTIFYPARTY_COUNTRYCODE,
                       P_I_V_NOTIFYPARTY_CODE,
                       P_I_V_NOTIFYPARTY_NAME,
			           P_I_V_NOTIFYPARTY_STATE,
                       P_I_V_NOTIFYPARTY_ZIP,
                       P_I_V_CONSIGNER_ADD1,
                        P_I_V_CONSIGNER_ADD2,
                        P_I_V_CONSIGNER_ADD3,
                        P_I_V_CONSIGNER_ADD4,
                        P_I_V_CONSIGNER_COUNTRYCODE,
                        P_I_V_CONSIGNER_CODE,
                        P_I_V_CONSIGNER_NAME,
                        P_I_V_CONSIGNER_STATE,
                        P_I_V_CONSIGNER_ZIP,
                        P_I_V_CONSIGNER_CITY,
                       P_I_V_COLOR_FLAG,
                       P_I_V_GROSS_CARGO_WEIGHT_BL_LEVEL,
                       P_I_V_PACKAGE_BL_LEVEL,
                       P_I_V_DEP_MANIF_NO,
                       P_I_V_DEP_MANIFEST_DATE,
                       P_I_V_SUBMITTER_TYPE,
                       P_I_V_SUBMITTER_CODE,
                        P_I_V_AUTHORIZ_REP_CODE,
                        P_I_V_SHIPPING_LINE_BOND_NO_R,
                        P_I_V_MODE_OF_TRANSPORT,
                        P_I_V_SHIP_TYPE,
                        P_I_V_CONVEYANCE_REFERENCE_NO,
                        P_I_V_CARGO_DESCRIPTION,
                        P_I_V_TOL_NO_OF_TRANS_EQU_MANIF,
                        P_I_V_BRIEF_CARGO_DES,
                        P_I_V_EXPECTED_DATE,
                        P_I_V_TIME_OF_DEPT,
                        P_I_V_PORT_OF_CALL_COD,
                        P_I_V_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
                        P_I_V_MESSAGE_TYPE,
                        P_I_V_VESSEL_TYPE_MOVEMENT,
                        P_I_V_AUTHORIZED_SEA_CARRIER_CODE,
                        P_I_V_PORT_OF_REGISTRY,
                        P_I_V_REGISTRY_DATE,
                        P_I_V_VOYAGE_DETAILS,
                        P_I_V_SHIP_ITINERARY_SEQUENCE,
                        P_I_V_SHIP_ITINERARY,
                        P_I_V_PORT_OF_CALL_NAME,
                        P_I_V_ARRIVAL_DEPARTURE_DETAILS,
                        P_I_V_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                        P_I_V_CONSOLIDATED_INDICATOR,
                        P_I_V_PREVIOUS_DECLARATION,
                        P_I_V_CONSOLIDATOR_PAN,
                        P_I_V_CIN_TYPE,
                        P_I_V_MCIN,
                        P_I_V_CSN_SUBMITTED_TYPE,
                        P_I_V_CSN_SUBMITTED_BY,
                        P_I_V_CSN_REPORTING_TYPE,
                        P_I_V_CSN_SITE_ID,
                        P_I_V_CSN_NUMBER,
                        P_I_V_CSN_DATE,
                        P_I_V_PREVIOUS_MCIN,
                        P_I_V_SPLIT_INDICATOR,
                        P_I_V_NUMBER_OF_PACKAGES,
                        P_I_V_TYPE_OF_PACKAGE,
                        P_I_V_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
                        P_I_V_TYPE_OF_CARGO,
                        P_I_V_SPLIT_INDICATOR_LIST,
                        P_I_V_PORT_OF_ACCEPTANCE,
                        P_I_V_PORT_OF_RECEIPT,
                        P_I_V_UCR_TYPE,
                        P_I_V_UCR_CODE,
                       
                       --P_I_V_EQUIPMENT_SEAL_TYPE,
                        
                        P_I_V_PORT_OF_ACCEPTANCE_NAME,
                        P_I_V_PORT_OF_RECEIPT_NAME,
                        P_I_V_PAN_OF_NOTIFIED_PARTY,
                        P_I_V_UNIT_OF_WEIGHT,
                        P_I_V_GROSS_VOLUME,
                        P_I_V_UNIT_OF_VOLUME,
                        P_I_V_CARGO_ITEM_SEQUENCE_NO,
                        P_I_V_CARGO_ITEM_DESCRIPTION,
                        P_I_V_CONTAINER_WEIGHT,
                        P_I_V_NUMBER_OF_PACKAGES_HID,
                        P_I_V_TYPE_OF_PACKAGES_HID,
                        P_I_V_PORT_OF_CALL_SEQUENCE_NUMBER,
                        P_I_V_PORT_OF_CALL_CODED,
                        P_I_V_NEXT_PORT_OF_CALL_CODED,
                        P_I_V_MC_LOCATION_CUSTOMS,
                        P_I_V_UNO_CODE,
                        P_I_V_IMDG_CODE); 
        ELSE 
          DBMS_OUTPUT.PUT_LINE('Record updated..!!'); 
        END IF; 

        UPDATE RCL_IGM_DETAILS 
        SET    NEW_VESSEL = P_I_V_NEW_VESSEL, 
               NEW_VOYAGE = P_I_V_NEW_VOYAGE, 
               FROM_ITEM_NO = P_I_V_FROM_ITEM_NO, 
               TO_ITEM_NO = P_I_V_TO_ITEM_NO, 
               CUST_CODE = P_I_V_CUST_CODE, 
               CALL_SIGN = P_I_V_CALL_SIGN, 
               IMO_CODE = P_I_V_IMO_CODE, 
               AGENT_CODE = P_I_V_AGENT_CODE, 
               LINE_CODE = P_I_V_LINE_CODE, 
               PORT_ORIGIN = P_I_V_PORT_ORIGIN, 
               PORT_ARRIVAL = P_I_V_PORT_ARRIVAL, 
               LAST_PORT_1 = P_I_V_LAST_PORT_1, 
               LAST_PORT_2 = P_I_V_LAST_PORT_2, 
               LAST_PORT_3 = P_I_V_LAST_PORT_3,
               NEXT_PORT_4=P_I_V_NEXT_PORT_1,
               NEXT_PORT_5=P_I_V_NEXT_PORT_2,
               NEXT_PORT_6=P_I_V_NEXT_PORT_3,
               VESSEL_TYPE = P_I_V_VESSEL_TYPE, 
               GEN_DESC = P_I_V_GEN_DESC, 
               MASTER_NAME = P_I_V_MASTER_NAME, 
               IGM_NUMBER = P_I_V_IGM_NUMBER, 
               IGM_DATE = P_I_V_IGM_DATE, 
               VESSEL_NATION = P_I_V_VESSEL_NATION, 
               ARRIVAL_DATE_ETA = P_I_V_ARRIVAL_DATE_ETA, 
               ARRIVAL_TIME_ETA = P_I_V_ARRIVAL_TIME_ETA, 
               ARRIVAL_DATE_ATA = P_I_V_ARRIVAL_DATE_ATA, 
               ARRIVAL_TIME_ATA = P_I_V_ARRIVAL_TIME_ATA, 
               TOTAL_BLS = P_I_V_TOTAL_BLS, 
               LIGHT_DUE = P_I_V_LIGHT_DUE, 
               GROSS_WEIGHT = TO_NUMBER(P_I_V_GROSS_WEIGHT), 
               NET_WEIGHT = TO_NUMBER(P_I_V_NET_WEIGHT), 
               SM_BT_CARGO = P_I_V_SM_BT_CARGO, 
               SHIP_STR_DECL = P_I_V_SHIP_STR_DECL, 
               CREW_LST_DECL = P_I_V_CREW_LST_DECL, 
               CARGO_DECL = P_I_V_CARGO_DECL, 
               PASSNGR_LIST = P_I_V_PASSNGR_LIST, 
               CREW_EFFECT = P_I_V_CREW_EFFECT, 
               MARITIME_DECL = P_I_V_MARITIME_DECL,
			   CUSTOM_TERMINAL_CODE=P_I_V_CUSTOM_TERMINAL_CODE,  
               DEP_MANIF_NO=P_I_V_DEP_MANIF_NO,
                DEP_MANIFEST_DATE=P_I_V_DEP_MANIFEST_DATE,
                SUBMITTER_TYPE=P_I_V_SUBMITTER_TYPE,
                SUBMITTER_CODE=P_I_V_SUBMITTER_CODE,
                AUTHORIZ_REP_CODE=P_I_V_AUTHORIZ_REP_CODE,
                SHIPPING_LINE_BOND_NO_R=P_I_V_SHIPPING_LINE_BOND_NO_R, 
                MODE_OF_TRANSPORT=P_I_V_MODE_OF_TRANSPORT,
                SHIP_TYPE=P_I_V_SHIP_TYPE,
                CONVEYANCE_REFERENCE_NO=P_I_V_CONVEYANCE_REFERENCE_NO       , 
                TOL_NO_OF_TRANS_EQU_MANIF=P_I_V_CARGO_DESCRIPTION ,  
                CARGO_DESCRIPTION=P_I_V_TOL_NO_OF_TRANS_EQU_MANIF,
                BRIEF_CARGO_DES=P_I_V_BRIEF_CARGO_DES,
                EXPECTED_DATE=P_I_V_EXPECTED_DATE,
                TIME_OF_DEPT=P_I_V_TIME_OF_DEPT,
                PORT_OF_CALL_COD=P_I_V_PORT_OF_CALL_COD,
                TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP=P_I_V_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP, 
                MESSAGE_TYPE=P_I_V_MESSAGE_TYPE,
                VESSEL_TYPE_MOVEMENT=P_I_V_VESSEL_TYPE_MOVEMENT,
                AUTHORIZED_SEA_CARRIER_CODE=P_I_V_AUTHORIZED_SEA_CARRIER_CODE       , 
                PORT_OF_REGISTRY=P_I_V_PORT_OF_REGISTRY ,
                REGISTRY_DATE=P_I_V_REGISTRY_DATE,
                VOYAGE_DETAILS=P_I_V_VOYAGE_DETAILS,
                SHIP_ITINERARY_SEQUENCE=P_I_V_SHIP_ITINERARY_SEQUENCE,
                SHIP_ITINERARY=P_I_V_SHIP_ITINERARY,
                PORT_OF_CALL_NAME=P_I_V_PORT_OF_CALL_NAME,
                ARRIVAL_DEPARTURE_DETAILS=P_I_V_ARRIVAL_DEPARTURE_DETAILS, 
                TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE=P_I_V_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE
              
        WHERE  SERVICE = P_I_V_SERVICE 
               AND VESSEL = P_I_V_VESSEL 
               AND VOYAGE = P_I_V_VOYAGE 
               AND PORT = P_I_V_PORT 
               AND TERMINAL = P_I_V_TERMINAL; 
       END IF;       
      END IF; 
 -- EXCEPTION 
 --   WHEN NO_DATA_FOUND THEN 
    --           P_O_V_ERROR := '1111'; WHEN OTHERS THEN 
      --         P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) 
                --              || ':' 
           --                   || SUBSTR(SQLERRM, 1, 100); 
  END RCL_IGM_SAVE_DATA; 
  
  
  
  PROCEDURE RCL_IGM_GET_SRL_NO(P_O_REFIGMTABFIND          OUT VARCHAR2,
                                P_O_REFIGMTABFIND_JOB          OUT VARCHAR2,
                               P_I_V_SRL_NO               VARCHAR2 DEFAULT NULL, 
                               P_O_V_ERROR                OUT VARCHAR2) 
    IS
     SL_NO_COUNTS NUMBER(20);  
     JOB_NO_COUNT  NUMBER(20);   
   BEGIN
  -- SL_NO_COUNTS :=0;
   
   SELECT MAX(NVL(SRL_NO,0)) INTO SL_NO_COUNTS FROM rcl_igm_details;
   DBMS_OUTPUT.PUT_LINE('<<<<<<<>>>>>>>> '||SL_NO_COUNTS || '');    
   IF SL_NO_COUNTS = 0 OR SL_NO_COUNTS IS NULL THEN 
   
   UPDATE RCL_IGM_DETAILS 
   
        SET SRL_NO = P_I_V_SRL_NO || '000001';
    P_O_REFIGMTABFIND:=P_I_V_SRL_NO || '000001';
     
   ELSE
   DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!');  
     
     SELECT COUNT(srl_no) INTO SL_NO_COUNTS FROM rcl_igm_details WHERE srl_no LIKE '%'||P_I_V_SRL_NO||'%';
     IF SL_NO_COUNTS =0 THEN
       
        UPDATE RCL_IGM_DETAILS 
        SET SRL_NO = P_I_V_SRL_NO || '000001';
        P_O_REFIGMTABFIND := P_I_V_SRL_NO || '000001';
     ELSE 
        SELECT MAX(NVL(srl_no,0))+1 into P_O_REFIGMTABFIND  FROM rcl_igm_details;
       UPDATE RCL_IGM_DETAILS 
            SET SRL_NO = P_O_REFIGMTABFIND;
    END IF;    
  -- insert into sushiltest values(P_I_V_SRL_NO|| ' '||P_O_REFIGMTABFIND);
  END IF; 
  
       SELECT MAX(NVL(JOBNO,0)) INTO JOB_NO_COUNT FROM rcl_igm_details;
  
   IF JOB_NO_COUNT = 0 OR JOB_NO_COUNT IS NULL THEN 
   
   UPDATE RCL_IGM_DETAILS 
   
        SET JOBNO = P_I_V_SRL_NO || '00001';
    P_O_REFIGMTABFIND_JOB:=P_I_V_SRL_NO || '00001';
     
   ELSE
   DBMS_OUTPUT.PUT_LINE('FRESH SEARCH..!!');  
     
     SELECT COUNT(JOBNO) INTO JOB_NO_COUNT FROM rcl_igm_details WHERE JOBNO LIKE '%'||P_I_V_SRL_NO||'%';
     IF JOB_NO_COUNT =0 THEN
       
        UPDATE RCL_IGM_DETAILS 
        SET JOBNO = P_I_V_SRL_NO || '00001';
        P_O_REFIGMTABFIND_JOB := P_I_V_SRL_NO || '00001';
     ELSE 
        SELECT MAX(NVL(JOBNO,0))+1 into P_O_REFIGMTABFIND_JOB  FROM rcl_igm_details;
       UPDATE RCL_IGM_DETAILS 
            SET JOBNO = P_O_REFIGMTABFIND_JOB;
    END IF; 
   END IF;
     
   P_O_V_ERROR:='000000'   ;
   EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
               P_O_V_ERROR := '1111'; WHEN OTHERS THEN 
               P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) 
                              || ':' 
                              || SUBSTR(SQLERRM, 1, 100); 
    
   END RCL_IGM_GET_SRL_NO;
   
   PROCEDURE RCL_IGM_GET_REFRESH_DATA(P_O_REFIGMTABFIND  OUT SYS_REFCURSOR, 
                                     P_I_V_POD          VARCHAR2, 
                                     P_I_V_BL           VARCHAR2 DEFAULT NULL, 
                                     P_I_V_SERVICE      VARCHAR2 DEFAULT NULL, 
                                     P_I_V_VESSEL       VARCHAR2 DEFAULT NULL, 
                                     P_I_V_VOYAGE       VARCHAR2 DEFAULT NULL, 
                                     P_I_V_POD_TERMINAL VARCHAR2 DEFAULT NULL, 
                                     P_I_V_FROM_DATE    VARCHAR2 DEFAULT NULL, 
                                     P_I_V_TO_DATE      VARCHAR2 DEFAULT NULL, 
                                     P_I_V_BL_STATUS    VARCHAR2 DEFAULT NULL, 
                                     P_I_V_POL          VARCHAR2 DEFAULT NULL, 
                                     P_I_V_POL_TERMINAL VARCHAR2 DEFAULT NULL, 
                                     P_I_V_DIRECTION    VARCHAR2 DEFAULT NULL, 
                                     P_I_V_DEL           VARCHAR2 DEFAULT NULL,
                                     P_I_V_DEPOT         VARCHAR2 DEFAULT NULL,
                                     P_O_V_ERROR        OUT VARCHAR2) 
  IS 
    BL_COUNT NUMBER(20);   
  BEGIN 
     
          
    OPEN P_O_REFIGMTABFIND FOR 
          SELECT SYBLNO                              BL_NO, 
                 IDP10.AYIMST                        BL_STATUS, 
                 IDP10.AYISDT                        BL_DATE, 
                 ACT_SERVICE_CODE                    SERVICE, 
                 ACT_VESSEL_CODE                     VESSEL, 
                 ACT_VOYAGE_NUMBER                   VOYAGE, 
                 ACT_PORT_DIRECTION                  DIRECTION, 
                 LOAD_PORT                           POL, 
                 FROM_TERMINAL                       POL_TERMINAL, 
                 DISCHARGE_PORT                      POD, 
                 TO_TERMINAL                         POD_TERMINAL, 
                 TO_TERMINAL                         TERMINAL, 
                 IDP10.AYDEST                        DEL_VLS,
                 TO_TERMINAL                         DEPOT_VLS,
                 (SELECT A.PARTNER_VALUE 
                  FROM   EDI_TRANSLATION_DETAIL A 
                  WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                       FROM   EDI_TRANSLATION_HEADER ETH 
                                       WHERE  ETH.STANDARD = 'EDIFACT' 
                                              AND ETH.CODE_SET = 'IGMTML') 
                         AND A.SEALINER_VALUE = TO_TERMINAL 
                         AND ROWNUM < 2)             CUST_CODE, 
                 (SELECT A.VSCLSN 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = P_I_V_VESSEL 
                         AND ROWNUM < 2)             CALL_SIGN, 
                 (SELECT LOYD_NO 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = P_I_V_VESSEL  
                         AND ROWNUM < 2)             IMO_CODE, 
                 (SELECT A.PARTNER_VALUE 
                  FROM   EDI_TRANSLATION_DETAIL A 
                  WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                       FROM   EDI_TRANSLATION_HEADER ETH 
                                        WHERE  ETH.STANDARD = 'EDIFACT' 
                                              AND ETH.CODE_SET = 'AGENT_CODE') 
                         AND A.SEALINER_VALUE =P_I_V_POD)        AGENT_CODE, 
                 (SELECT A.PARTNER_VALUE     
                  FROM   EDI_TRANSLATION_DETAIL A 
                  WHERE  A.ETH_UID IN (SELECT ETH.ETH_UID 
                                       FROM   EDI_TRANSLATION_HEADER ETH 
                                       WHERE  ETH.STANDARD = 'EDIFACT' 
                                              AND ETH.CODE_SET = 'IGMLINECD') 
                         AND A.SEALINER_VALUE = TO_TERMINAL 
                         AND ROWNUM < 2)             LINE_CODE, 
                 (SELECT VVPCAL 
                  FROM   (SELECT VVPCAL 
                          FROM   SEALINER.ITP063 
                          WHERE  VVVESS = P_I_V_VESSEL 
                                 AND VVVERS = 99 
                                 AND ( VVARDT 
                                       ||NVL(LPAD(VVARTM, 4, 0), '0000') ) <= 
                                     (SELECT 
                                     VVARDT 
                                     ||NVL( 
                                       LPAD(VVARTM, 4, 0), 
                                                 '0000') 
                                     AS 
                                     ETADATE 
                                     FROM 
                                     SEALINER.ITP063 
                                     WHERE 
                                     VVPCAL = P_I_V_POD
                                            AND (P_I_V_SERVICE IS NULL
                                                    or VVSRVC =P_I_V_SERVICE)
                                     AND VVVESS = P_I_V_VESSEL 
                                     AND VVVOYN = P_I_V_VOYAGE 
                                     AND ( 
                                         P_I_V_POD_TERMINAL IS 
                                         NULL 
                                          OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                                                 AND VVVERS = 99 
                                                 AND OMMISSION_FLAG IS NULL 
                                                 AND VVFORL IS NOT NULL) 
                                 AND OMMISSION_FLAG IS NULL 
                                 AND VVFORL IS NOT NULL 
                                 AND ( VVPCAL, VVTRM1 ) NOT IN 
                                     (SELECT VVPCAL, 
                                             VVTRM1 
                                      FROM   SEALINER.ITP063 
                                      WHERE  VVPCAL = P_I_V_POD
                                             AND (P_I_V_SERVICE IS NULL
                                                     or VVSRVC =P_I_V_SERVICE)
                                             AND VVVESS = P_I_V_VESSEL 
                                             AND VVVOYN = P_I_V_VOYAGE 
                                             AND ( 
                                     P_I_V_POD_TERMINAL IS NULL 
                                      OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                                             AND VVVERS = 99 
                                             AND OMMISSION_FLAG IS NULL 
                                             AND VVFORL IS NOT NULL) 
                          ORDER  BY VVARDT 
                                    ||NVL(LPAD(VVARTM, 4, 0), '0000') DESC, 
                                    VVPCSQ DESC) 
                  WHERE  ROWNUM = 1)                 PORT_ORIGIN, 
                 ''                                  PORT_ARRIVAL, 
                 ''                              LAST_PORT_1,     --  -3
                 ''                              LAST_PORT_2,     --  -2
                 ''                              LAST_PORT_3,     --  -1
                 --new field
                 ''                                       NEXT_PORT_4,     --  -1
                 ''                                       NEXT_PORT_5,     --  -2
                 ''                                       NEXT_PORT_6,     --  -3
                 -- end
                 'Containerised'                     VESSEL_TYPE, 
                 'containers'                        GEN_DESC, 
                 ''                                  MASTER_NAME, 
                 (SELECT VSCNCD 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = P_I_V_VESSEL 
                         AND ROWNUM < 2)             VESSEL_NATION, 
                 ''                                  IGM_NUMBER, 
                 ''                                  IGM_DATE, 
                 (SELECT VVAPDT 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD
                         AND (P_I_V_SERVICE IS NULL
                                or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2)             ARRIVAL_DATE, 
                 (SELECT VVAPTM 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD 
                         AND (P_I_V_SERVICE IS NULL
                              or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2)             ARRIVAL_TIME,
                  ''                             ARRIVAL_DATE_ATA,
                  ''                             ARRIVAL_TIME_ATA,
                  --NEW MANIFENT FILE CR 14/111/2019
                  ''                        DEP_MANIF_NO,
                  ''                        DEP_MANIFEST_DATE,
                  ''                        SUBMITTER_TYPE,
                  (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMSUBMITC'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)  -- fsc 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                     SUBMITTER_CODE,
                  (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMAUTHREP'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)  -- fsc 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                     AUTHORIZ_REP_CODE,
                  ''                        SHIPPING_LINE_BOND_NO_R,
                  ''                        MODE_OF_TRANSPORT,
                  ''                        SHIP_TYPE,
                  ''                        CONVEYANCE_REFERENCE_NO,
                  ''                        TOL_NO_OF_TRANS_EQU_MANIF,
                  ''                        CARGO_DESCRIPTION,
                  ''                        BRIEF_CARGO_DES,
                  (SELECT vvdpdt 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD
                         AND (P_I_V_SERVICE IS NULL
                                or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2)                        EXPECTED_DATE,
                  (SELECT vvdptm 
                  FROM   ITP063 A 
                  WHERE  VVPCAL = P_I_V_POD 
                         AND (P_I_V_SERVICE IS NULL
                              or VVSRVC =P_I_V_SERVICE)
                         AND VVVESS = P_I_V_VESSEL 
                         AND VVVOYN = P_I_V_VOYAGE 
                         AND ( P_I_V_POD_TERMINAL IS NULL 
                                OR VVTRM1 = P_I_V_POD_TERMINAL ) 
                         AND A.VVVERS = 99 
                         AND A.VVFORL IS NOT NULL 
                         AND A.OMMISSION_FLAG IS NULL 
                         AND ROWNUM < 2)                        TIME_OF_DEPT,      
                  
                  ''                        TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
                  ''                        MESSAGE_TYPE,
                  'UD'                      VESSEL_TYPE_MOVEMENT,
                  (SELECT PARTNER_VALUE
                    FROM EDI_TRANSLATION_DETAIL 
                    
                    WHERE ETH_UID IN (
                    
                    SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                    WHERE CODE_SET='IGMAUTHSEA'
                    
                    ) AND SEALINER_VALUE=(select PIOFFC from itp040 WHERE PICODE=P_I_V_POD)   -- fsc from port 
                    AND ROWNUM=1 AND RECORD_STATUS='A')                 AUTHORIZED_SEA_CARRIER_CODE,
                  (SELECT PORT_OF_REGISTRY 
                  FROM SEALINER.ITP060 
                  WHERE VSRCST='A' AND 
                  VSVESS= P_I_V_VESSEL)     PORT_OF_REGISTRY,
                  (select FLAG_EFF_DATE
                  from sealiner.ITP060
                  where VSRCST='A' 
                  AND VSVESS= P_I_V_VESSEL)        REGISTRY_DATE,
                  'R D'                     VOYAGE_DETAILS,
                  'R D'                     SHIP_ITINERARY_SEQUENCE,
                  'R D'                     SHIP_ITINERARY,
                  (select PINAME from itp040 
                  where PIRCST='A' 
                  AND PICODE=P_I_V_POD )                    PORT_OF_CALL_NAME,
                  'D R'                     ARRIVAL_DEPARTURE_DETAILS,
                  'Q R'                     TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
                  
                  --END MANIFENT FILE CR 14/111/2019
                  ''                             NEW_VOYAGE,
                  ''                             NEW_VESSEL,
                  (SELECT PARTNER_VALUE
                  FROM EDI_TRANSLATION_DETAIL 
                  WHERE ETH_UID IN (
                  SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                  WHERE CODE_SET='IGMTML'
                  ) AND SEALINER_VALUE=TO_TERMINAL AND ROWNUM=1)              CUSTOM_TERMINAL_CODE, 
                 (SELECT GROSS_TON_INTER 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = P_I_V_VESSEL 
                         AND ROWNUM < 2)             GROSS_WEIGHT, 
                 (SELECT NET_TON_INTER 
                  FROM   ITP060 A 
                  WHERE  A.VSVESS = IDP5.ACT_VESSEL_CODE 
                         AND ROWNUM < 2)             NET_WEIGHT, 
                 '0'                                 TOTAL_BLS, 
                 ''                                  LIGHT_DUE, 
                 'N'                                 SM_BT_CARGO, 
                 'N'                                 SHIP_STR_DECL, 
                 ''                                 CREW_LST_DECL, 
                 'N'                                 CARGO_DECL, 
                 'N'                                 PASSNGR_LIST, 
                 'N'                                 CREW_EFFECT, 
                 'N'                                 MARITIME_DECL, 
                 ''                                  ITEM_NUMBER, 
                 'C'                                 CARGO_NATURE, 
                 CASE 
                   WHEN AYMPOD = AYDEST THEN 'LC' 
                   ELSE 'TI' 
                 END                                 CARGO_MOVMNT, 
                 'OT'                                ITEM_TYPE, 
                 'FCL'                               CARGO_MOVMNT_TYPE, 
                 (SELECT 
                        CASE
                           WHEN BT.TRANSPORT_MODE='T' THEN 'R'
                           WHEN BT.TRANSPORT_MODE='R' THEN 'T'
                        END   
                  FROM   IDP005 BT 
                  WHERE  BT.SYBLNO = IDP5.SYBLNO 
                         AND BT.VOYAGE_SEQ <> 1 
                         AND BT.TRANSPORT_MODE IN ( 'T', 'R' ) 
                         AND ROWNUM < 2)             TRANSPORT_MODE, 
                 ''                                  ROAD_CARR_CODE, 
                 ''                                  ROAD_TP_BOND_NO, 
                 ''                                  SUBMIT_DATE_TIME, 
                 ''                           DPD_MOVEMENT,
                 ''                           DPD_CODE,
                 (SELECT MA_SEQ_NO 
                  FROM   RCLTBLS.DEX_BL_HEADER A 
                  WHERE  DN_POD = P_I_V_POD
                         AND DISCHARGE_VESSEL = P_I_V_VESSEL 
                         AND DISCHARGE_VOYAGE = P_I_V_VOYAGE 
                         AND PK_BL_NO = IDP5.SYBLNO    
                         AND ROWNUM < 2)             BL_VERSION,
                (SELECT ADDRESS_LINE_1 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =SYBLNO
                 and customer_type='C' AND ROWNUM=1)                                 CUSTOMERS_ADDRESS_1,
                 (SELECT ADDRESS_LINE_2 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =SYBLNO
                 and customer_type='C' AND ROWNUM=1)                                  CUSTOMERS_ADDRESS_2,
                (SELECT ADDRESS_LINE_3 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =SYBLNO
                 and customer_type='C' AND ROWNUM=1)                                 CUSTOMERS_ADDRESS_3,
                (SELECT ADDRESS_LINE_4 
                 FROM RCLTBLS.DEX_BL_CUSTOMERS
                 WHERE FK_BL_NO =SYBLNO
                 and customer_type='C' AND ROWNUM=1)                                  CUSTOMERS_ADDRESS_4,  
                 ''                                                      COLOR_FLAG,
                (SELECT   
                SUM(EYMTWT)  
                FROM IDP055 i
                WHERE 
                EYBLNO =SYBLNO )                                    NET_WEIGHT_METRIC,
                 (SELECT sum (EYPCKG) 
                 from IDP055 WHERE 
                 EYBLNO=SYBLNO )                                          NET_PACKAGE,
                 --new bl section fielsd 
                ''															    CONSOLIDATED_INDICATOR,
                ''															    PREVIOUS_DECLARATION,	
                ''															    CONSOLIDATOR_PAN,
                ''															    CIN_TYPE,
                'UD'															    MCIN,
                ''															    CSN_SUBMITTED_TYPE,
                ''															    CSN_SUBMITTED_BY,
                ''                                                              CSN_REPORTING_TYPE,
                ''															    CSN_SITE_ID,
                ''															    CSN_NUMBER,
                ''                                                              CSN_DATE,
                ''                                                              PREVIOUS_MCIN,
                ''                                                              SPLIT_INDICATOR,
                (SELECT sum (EYPCKG) 
                 from IDP055 WHERE 
                 EYBLNO=SYBLNO AND ROWNUM=1)                                                 NUMBER_OF_PACKAGES, --need to discuss
                (select PARTNER_VALUE 
                from sealiner.EDI_TRANSLATION_HEADER hdr,
                sealiner.EDI_TRANSLATION_DETAIL dtl,
                RCLTBLS.DEX_BL_COMMODITY bl 
                where  hdr.CODE_SET='IGMPKGKIND' 
                and hdr.ETH_UID=dtl.ETH_UID
                and DN_PACKAGE_KIND=SEALINER_VALUE 
                and bl.FK_BL_NO= SYBLNO  AND ROWNUM=1)                          TYPE_OF_PACKAGE,
                (select PARTNER_VALUE from sealiner.EDI_TRANSLATION_HEADER hdr
                ,sealiner.EDI_TRANSLATION_DETAIL dtl  
                where  hdr.CODE_SET='IGMPORT' and hdr.ETH_UID=dtl.ETH_UID
                and  SEALINER_VALUE=P_I_V_POD AND ROWNUM=1)                                  FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
                ''                                                              TYPE_OF_CARGO,
                ''                                                              SPLIT_INDICATOR_LIST,
                (select  DN_POL     from RCLTBLS.DEX_BL_HEADER 
                where PK_BL_NO=SYBLNO AND ROWNUM=1)                                          PORT_OF_ACCEPTANCE,
                  (SELECT PARTNER_VALUE            
                  FROM EDI_TRANSLATION_DETAIL 
                WHERE ETH_UID IN (               
                SELECT ETH_UID FROM EDI_TRANSLATION_HEADER
                                  WHERE CODE_SET='IGMDEL'
                  ) AND SEALINER_VALUE= TO_TERMINAL  AND ROWNUM=1 and RECORD_STATUS='A')                                     PORT_OF_RECEIPT,
                ''                                                              UCR_TYPE,
                ''                                                              UCR_CODE,
                
               -- ''                                                              EQUIPMENT_SEAL_TYPE,
                
                ''                                                              PORT_OF_ACCEPTANCE_NAME,
                (select TQTRNM DEPOT_NAME 
                from ITP130 where TQTERM=TO_TERMINAL-- del FROM bl 
                AND    TQRCST='A')                     PORT_OF_RECEIPT_NAME,
                (select FEDERAL_TAX_ID PAN from sealiner.ITP010
                WHERE  CURCST='A' 
                AND CUCUST=(select FK_CUSTOMER_CODE 
                from RCLTBLS.DEX_BL_CUSTOMERS 
                WHERE CUSTOMER_TYPE IN('N','1','2','3') 
                AND FK_BL_NO =SYBLNO)AND ROWNUM=1 )                                             PAN_OF_NOTIFIED_PARTY,
                (select STMTWT from sealiner.ITP0TD where SGTRAD='*')               UNIT_OF_WEIGHT,
                'GV'                                                                GROSS_VOLUME,
                'UOV'                                                               UNIT_OF_VOLUME,
                'CISN'                                                              CARGO_ITEM_SEQUENCE_NO,
                (select BYRMKS from IDP050 where BYBLNO=SYBLNO AND ROWNUM=1)                     CARGO_ITEM_DESCRIPTION,
                'noph'                                                              NUMBER_OF_PACKAGES_HID,
                (select PARTNER_VALUE 
                from sealiner.EDI_TRANSLATION_HEADER hdr,
                sealiner.EDI_TRANSLATION_DETAIL dtl,
                RCLTBLS.DEX_BL_COMMODITY bl 
                where  hdr.CODE_SET='IGMPKGKIND' 
                and hdr.ETH_UID=dtl.ETH_UID
                and DN_PACKAGE_KIND=SEALINER_VALUE 
                and bl.FK_BL_NO= SYBLNO AND ROWNUM=1)                              TYPE_OF_PACKAGES_HID,
                'portocsn'                                                          PORT_OF_CALL_SEQUENCE_NUMBER,
                (SELECT VVPCAL FROM (
                SELECT VVPCAL FROM SEALINER.ITP063
                WHERE VVVESS = P_I_V_VESSEL AND VVVERS= 99
                AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))<=(
                SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000') 
                AS ETADATE FROM SEALINER.ITP063 WHERE
                VVSRVC=ACT_SERVICE_CODE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL )
                AND OMMISSION_FLAG IS NULL    
                AND VVFORL IS NOT NULL
                AND (VVPCAL ,VVTRM1) NOT IN
                (SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
                VVSRVC=ACT_SERVICE_CODE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                VVTRM1=TO_TERMINAL AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL)
                ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000')
                DESC,VVPCSQ DESC)WHERE ROWNUM=1)                            PORT_OF_CALL_CODED,
                (SELECT VVPCAL FROM (
                SELECT VVPCAL FROM SEALINER.ITP063 WHERE 
                VVVESS = P_I_V_VESSEL AND VVVERS= 99 
                AND(VVARDT||NVL(LPAD(VVARTM,4,0),'0000'))>=(
                SELECT VVARDT||NVL(LPAD(VVARTM,4,0),'0000')
                AS ETADATE FROM SEALINER.ITP063 WHERE
                VVSRVC=ACT_SERVICE_CODE AND
                VVPCAL=P_I_V_POD AND
                VVVESS=P_I_V_VESSEL AND
                VVVOYN=P_I_V_VOYAGE AND
                --VVPCSQ=PORTSEQUENCE' AND
                VVVERS=99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL )
                AND OMMISSION_FLAG IS NULL
                AND VVFORL IS NOT NULL
                AND (VVPCAL ,VVTRM1) NOT IN
                ( SELECT VVPCAL ,VVTRM1 FROM SEALINER.ITP063 WHERE
                VVSRVC =ACT_SERVICE_CODE AND
                VVPCAL =P_I_V_POD AND
                VVVESS =P_I_V_VESSEL AND
                VVVOYN =P_I_V_VOYAGE AND
                VVTRM1=TO_TERMINAL AND
                --VVPCSQ =PORTSEQUENCE' AND
                VVVERS =99 AND
                OMMISSION_FLAG IS NULL AND
                VVFORL IS NOT NULL)
                ORDER BY VVARDT||NVL(LPAD(VVARTM,4,0),'0000'),VVPCSQ)
                WHERE ROWNUM=1)                                                   NEXT_PORT_OF_CALL_CODED,
                'mclc'                                                              MC_LOCATION_CUSTOMS,
                (select  FK_UNNO  from  RCLTBLS.DEX_BL_SPECIAL_CARGO_DTL sp 
                , RCLTBLS.DEX_BL_COMMODITY cm where cm.DN_SPECIAL_HNDL='D1'
                and cm.FK_BL_NO=sp.FK_BL_NO 
                and cm.COMMODITY_SEQ=sp.COMMODITY_SEQ 
                and rownum=1  and cm.FK_BL_NO=SYBLNO AND ROWNUM=1)                               UNO_CODE,
                (select  FK_IMO_CLASS  from  RCLTBLS.DEX_BL_SPECIAL_CARGO_DTL sp
                , RCLTBLS.DEX_BL_COMMODITY cm where cm.DN_SPECIAL_HNDL='D1'
                and cm.FK_BL_NO=sp.FK_BL_NO 
                and cm.COMMODITY_SEQ=sp.COMMODITY_SEQ
                and rownum=1 and cm.FK_BL_NO= SYBLNO AND ROWNUM=1)                               IMDG_CODE,
                ''                                                                  CONTAINER_WEIGHT,
                 --end
                 ''                                  NHAVA_SHEVA_ETA, 
                 FINAL_PLACE_OF_DELIVERY_NAME        FINAL_PLACE_DELIVERY, 
                 ''                                  PACKAGES, 
                 ''                                  CFS_NAME, 
                 ''                                  MBL_NO, 
                 (select FK_HOUSE_BL_NO  from rcltbls.DEX_BL_header 
                 where FK_BOOKING_NO in (
                 SELECT FK_BOOKING_NO FROM    
                 rcltbls.DEX_BL_header where PK_BL_NO= SYBLNO
                 ) and FK_HOUSE_BL_NO IS NOT NULL)                                  HBL_NO, 
                 ''                                  FROM_ITEM_NO, 
                 ''                                  TO_ITEM_NO,
                 ''                                  SRL_NO
          FROM   IDP005 IDP5 
                 INNER JOIN IDP010 IDP10 
                         ON IDP5.SYBLNO = IDP10.AYBLNO 
          WHERE  IDP5.DISCHARGE_PORT = P_I_V_POD 
                 AND ( P_I_V_SERVICE IS NULL 
                        OR IDP5.ACT_SERVICE_CODE = P_I_V_SERVICE ) 
                 AND ( P_I_V_VESSEL IS NULL 
                        OR IDP5.ACT_VESSEL_CODE = P_I_V_VESSEL ) 
                 AND ( P_I_V_VOYAGE IS NULL 
                        OR IDP5.ACT_VOYAGE_NUMBER = P_I_V_VOYAGE ) 
                 AND ( P_I_V_POD_TERMINAL IS NULL 
                        OR IDP5.TO_TERMINAL = P_I_V_POD_TERMINAL ) 
                 AND ( P_I_V_FROM_DATE IS NULL 
                        OR IDP10.AYISDT >= P_I_V_FROM_DATE ) 
                 AND ( P_I_V_TO_DATE IS NULL 
                        OR IDP10.AYISDT <= P_I_V_TO_DATE ) 
                 AND ( IDP10.AYIMST <> 9)   
                 AND ( P_I_V_BL_STATUS IS NULL 
                        OR IDP10.AYIMST = P_I_V_BL_STATUS)        
                 AND ( P_I_V_POL IS NULL 
                        OR IDP5.LOAD_PORT = P_I_V_POL ) 
                 AND ( P_I_V_POL_TERMINAL IS NULL    
                        OR IDP5.FROM_TERMINAL = P_I_V_POL_TERMINAL )   
                 AND ( P_I_V_DEL IS NULL 
                        OR IDP10.AYDEST = P_I_V_DEL ) 
                 AND ( P_I_V_DEPOT IS NULL 
                        OR IDP5.TO_TERMINAL = P_I_V_DEPOT )          
                 
                 AND IDP10.AYSORC = 'C'; 
       
   P_O_V_ERROR:='000000'   ;
   EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
               P_O_V_ERROR := '1111'; WHEN OTHERS THEN 
               P_O_V_ERROR := SUBSTR(SQLCODE, 1, 10) 
                              || ':' 
                              || SUBSTR(SQLERRM, 1, 100); 
       
        END  RCL_IGM_GET_REFRESH_DATA ;
        
        
        PROCEDURE RCL_IGM_SAVE_CONTAINOR(   
                        P_I_V_POD		    VARCHAR2,
                        P_I_V_VESSEL        VARCHAR2 DEFAULT NULL,
                        P_I_V_VOYAGE        VARCHAR2 DEFAULT NULL,
                        P_I_C_CONT_LST   IN      CLOB
        ) 
        IS
    
        BEGIN
       
       -- insert into IGM_DATA_SET_JSON values(P_I_C_CONT_LST);
     
     DELETE FROM RCL_IGM_CONTAINERDTLS 
     WHERE CONTAINER_VESSEL= P_I_V_VESSEL AND CONTAINER_VOYAGE= P_I_V_VOYAGE AND CONTAINER_POD= P_I_V_POD;  
     COMMIT; 
     DELETE FROM IGM_DATA_SET_JSON;
       
     INSERT INTO IGM_DATA_SET_JSON VALUES (P_I_C_CONT_LST); COMMIT;                      
        
     UPDATE IGM_DATA_SET_JSON SET DATA_SET = '[' || REPLACE(REPLACE(DATA_SET, '[', ''), ']', '') || ']';
        
    
     
     INSERT INTO rcl_igm_containerdtls
     SELECT BL_NO
           , CONTAINER_NO
           , CONTAINER_SEAL_NO 
           , CONTAINER_STATUS    
           , TOTAL_NO_OF_PACKAGES
           , CONTAINER_WEIGHT
           , CONTAINER_AGENT_CODE
           , CONTAINER_VESSEL
           , CONTAINER_VOYAGE
           , CONTAINER_POD
           , CONTAINERSIZE
           , CONTAINERTYPE
           , EQUIPMENT_LOAD_STATUS
           ,SOC_FLAG
           ,EQUIPMENT_SEAL_TYPE
           
     FROM  JSON_TABLE
           (
            (SELECT DATA_SET FROM IGM_DATA_SET_JSON), '$[*]'
                COLUMNS ( BL_NO PATH '$.blNO'
                         , CONTAINER_NO PATH '$.containerNumber'
                         , CONTAINER_SEAL_NO PATH '$.containerSealNumber'
                         , CONTAINER_STATUS PATH '$.status'
                         , TOTAL_NO_OF_PACKAGES PATH '$.totalNumberOfPackagesInContainer'
                         , CONTAINER_WEIGHT PATH '$.containerWeight'
                         , CONTAINER_AGENT_CODE PATH '$.containerAgentCode' 
                         ,CONTAINER_VESSEL PATH '$.container_vessel'
                         ,CONTAINER_VOYAGE PATH '$.container_voyage'
                         ,CONTAINER_POD PATH '$.container_pod'
                         ,CONTAINERSIZE PATH '$.containerSize'
                         ,CONTAINERTYPE PATH '$.containerType'
                         ,EQUIPMENT_LOAD_STATUS PATH '$.equipmentLoadStatus' 
                         ,SOC_FLAG PATH '$.soc_flag'
                         ,EQUIPMENT_SEAL_TYPE PATH '$.equipment_seal_type'     
                        )
           );
      --  COMMIT;
        
        END RCL_IGM_SAVE_CONTAINOR;
END RCL_IGM_INFO;