CREATE OR REPLACE PACKAGE BODY VASAPPS."PCR_TOS_SYNC_LL_DL_BOOKING" is

PROCEDURE PRR_TOS_LL_DL_BOOKING AS

V_BOOKING_NO     		BKP001.BABKNO%TYPE;
V_BOOKING_TYPE	 		BKP001.BOOKING_TYPE%TYPE;
V_OLD_BOOKING_STATUS	BKP001.BASTAT%TYPE;
V_NEW_BOOKING_STATUS	BKP001.BASTAT%TYPE;
V_RETURN_STATUS			VARCHAR2(50);
V_SEQ					      NUMBER(38);
TOS_LL_DL_BKG_PENDING       VASAPPS.TOS_LL_DL_BOOKING%ROWTYPE;
 


CURSOR CUR_TOS_LL_DL_BOOKING IS
       SELECT * --FK_BOOKING_NO,BOOKING_TYPE,OLD_BOOKING_STATUS,NEW_BOOKING_STATUS,PK_TOS_LL_DL_BOOKING_SEQ
       from VASAPPS.TOS_LL_DL_BOOKING
       WHERE STATUS = 'L' -- 'P' SELECT LOCKED STATUS TO LOCK RECORD FOR PROCESSING.
       AND TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       and source='BKG'
       order by TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS'))ASC ,PK_TOS_LL_DL_BOOKING_SEQ asc
       ;
     -- FOR UPDATE NOWAIT;
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
         EXIT WHEN CUR_TOS_LL_DL_BOOKING%NOTFOUND;
         FETCH CUR_TOS_LL_DL_BOOKING INTO TOS_LL_DL_BKG_PENDING;
         
         

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
            PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'C' -- STATUS 
                               ,'' -- ERR_DESC
                               ,'BKG' -- source 
                               );
			 -- COMMIT;

		  ELSE 
         PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'E' -- STATUS 
                               ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                               ,'BKG' -- source
                               );    
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
         PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'E' -- STATUS 
                               ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                               ,'BKG' -- source
                               );             
         --COMMIT;

         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BOOKING'
                                                    , '-'
                                                    , 'PROCESS TO GET PENDING BOOKING AFTER BOOKING STATUS CHANGED.'
                                                    , 'V_SEQ : ' || V_SEQ
                                                    , 'V_BOOKING_NO : '|| V_BOOKING_NO                                                    
                                                    , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                    );      
     
END PRR_TOS_LL_DL_BOOKING;

PROCEDURE PRR_TOS_LL_DL_BKP009 AS 

V_BOOKING_NO     		           BKP001.BABKNO%TYPE;
V_RETURN_STATUS			           VARCHAR2(50);
V_SEQ					                 NUMBER(38);
V_EQUIPMENT_SEQ                VASAPPS.TOS_LL_DL_CONTAINERS.FK_EQUIPMENT_SEQ%TYPE;
V_SIZE_TYPE_SEQ                VASAPPS.TOS_LL_DL_CONTAINERS.SIZE_TYPE_SEQ_NO%TYPE;
V_SUPPLIER_SEQ                 VASAPPS.TOS_LL_DL_CONTAINERS.SUPPLIER_SEQ_NO%TYPE;
V_OLD_EQUIPMENT_NO             VASAPPS.TOS_LL_DL_CONTAINERS.FK_OLD_EQUIPMENT_NO%TYPE;
V_NEW_EQUIPMENT_NO             VASAPPS.TOS_LL_DL_CONTAINERS.FK_NEW_EQUIPMENT_NO%TYPE; 
V_OVERH                        VASAPPS.TOS_LL_DL_CONTAINERS.OVERHEIGHT%TYPE;
V_OVERLR                       VASAPPS.TOS_LL_DL_CONTAINERS.OVERLENGTH_REAR%TYPE;
V_OVERLF                       VASAPPS.TOS_LL_DL_CONTAINERS.OVERLENGTH_FRONT%TYPE; 
V_OVERWL                       VASAPPS.TOS_LL_DL_CONTAINERS.OVERWIDTH_LEFT%TYPE;
V_OVERWR                       VASAPPS.TOS_LL_DL_CONTAINERS.OVERWIDTH_RIGHT%TYPE; 
V_UN_VAR                       VASAPPS.TOS_LL_DL_CONTAINERS.UN_VAR%TYPE;
V_FLASH_POINT                  VASAPPS.TOS_LL_DL_CONTAINERS.FLASH_POINT%TYPE;
V_FLASH_UNIT                   VASAPPS.TOS_LL_DL_CONTAINERS.FLASH_UNIT%TYPE; 
V_REEFER_TMP                   VASAPPS.TOS_LL_DL_CONTAINERS.REEFER_TMP%TYPE; 
V_REEFER_TMP_UNIT              VASAPPS.TOS_LL_DL_CONTAINERS.REEFER_TMP_UNIT%TYPE; 
V_IMDG                         VASAPPS.TOS_LL_DL_CONTAINERS.IMDG%TYPE; 
V_UNNO                         VASAPPS.TOS_LL_DL_CONTAINERS.UNNO%TYPE; 
V_HUMIDITY                     VASAPPS.TOS_LL_DL_CONTAINERS.HUMIDITY%TYPE; 
V_VENTILATION                  VASAPPS.TOS_LL_DL_CONTAINERS.VENTILATION%TYPE;
V_WEIGHT                       VASAPPS.TOS_LL_DL_CONTAINERS.WEIGHT%TYPE;
V_VGM                          VASAPPS.TOS_LL_DL_CONTAINERS.VGM%TYPE; 
V_VGM_CATEGORY                 VASAPPS.TOS_LL_DL_CONTAINERS.VGM_CATEGORY%TYPE; 
V_USER_ID                      VASAPPS.TOS_LL_DL_CONTAINERS.CREATED_USER%TYPE;
                                              
V_MODE_TYPE                    VARCHAR2(1);
V_EXEC_FLAG                    VARCHAR2(1);
TOS_LL_DL_BKP009_PENDING       VASAPPS.TOS_LL_DL_CONTAINERS%ROWTYPE;


CURSOR CUR_TOS_LL_DL_BKP009 IS
       SELECT * --FK_BOOKING_NO,BOOKING_TYPE,OLD_BOOKING_STATUS,NEW_BOOKING_STATUS,PK_TOS_LL_DL_BOOKING_SEQ
       from VASAPPS.TOS_LL_DL_CONTAINERS
       WHERE STATUS IN ('P','L') --'L' -- 'P' SELECT LOCKED STATUS TO LOCK RECORD FOR PROCESSING.
       AND TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       and source='BKP009'
       order by TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS'))ASC, PK_TOS_LL_DL_CNTR_SEQ asc
       ;
      --FOR UPDATE NOWAIT;
      -- FOR UPDATE OF STATUS ;

BEGIN

	 /*-- COMMENT BY WACCHO1 ON 02/10/2016 
	 UPDATE VASAPPS.TOS_LL_DL_CONTAINERS 
		SET STATUS='L'
	 WHERE TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       AND SOURCE='BKP009'
	   AND STATUS='P';
	 COMMIT;  
	--*/

     OPEN CUR_TOS_LL_DL_BKP009;
     --FOR TOS_LL_DL_BKG_PENDING IN CUR_TOS_LL_DL_BOOKING
     LOOP
     
         V_SEQ:='';
         
         
         FETCH CUR_TOS_LL_DL_BKP009 INTO TOS_LL_DL_BKP009_PENDING;
         EXIT WHEN CUR_TOS_LL_DL_BKP009%NOTFOUND;

         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'FETCH CUR'
        													                          , 'V_BOOKING_NO : ' || TOS_LL_DL_BKP009_PENDING.FK_BOOKING_NO
        													                          , 'V_SEQ : ' || TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ
                                                            );	
         

         V_BOOKING_NO         := TOS_LL_DL_BKP009_PENDING.FK_BOOKING_NO;
		     V_SEQ                := TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ;
         V_MODE_TYPE          := TOS_LL_DL_BKP009_PENDING.MODE_TYPE;
         V_EQUIPMENT_SEQ      := TOS_LL_DL_BKP009_PENDING.FK_EQUIPMENT_SEQ;
         V_SIZE_TYPE_SEQ      := TOS_LL_DL_BKP009_PENDING.SIZE_TYPE_SEQ_NO ; 
         V_SUPPLIER_SEQ       := TOS_LL_DL_BKP009_PENDING.SUPPLIER_SEQ_NO;
         V_OLD_EQUIPMENT_NO   := TOS_LL_DL_BKP009_PENDING.FK_OLD_EQUIPMENT_NO;
         V_NEW_EQUIPMENT_NO   := TOS_LL_DL_BKP009_PENDING.FK_NEW_EQUIPMENT_NO; 
         V_OVERH              := TOS_LL_DL_BKP009_PENDING.OVERHEIGHT;
         V_OVERLR             := TOS_LL_DL_BKP009_PENDING.OVERLENGTH_REAR;
         V_OVERLF             := TOS_LL_DL_BKP009_PENDING.OVERLENGTH_FRONT; 
         V_OVERWL             := TOS_LL_DL_BKP009_PENDING.OVERWIDTH_LEFT;
         V_OVERWR             := TOS_LL_DL_BKP009_PENDING.OVERWIDTH_RIGHT; 
         V_UN_VAR             := TOS_LL_DL_BKP009_PENDING.UN_VAR;
         V_FLASH_POINT        := TOS_LL_DL_BKP009_PENDING.FLASH_POINT;
         V_FLASH_UNIT         := TOS_LL_DL_BKP009_PENDING.FLASH_UNIT; 
         V_REEFER_TMP         := TOS_LL_DL_BKP009_PENDING.REEFER_TMP; 
         V_REEFER_TMP_UNIT    := TOS_LL_DL_BKP009_PENDING.REEFER_TMP_UNIT; 
         V_IMDG               := TOS_LL_DL_BKP009_PENDING.IMDG; 
         V_UNNO               := TOS_LL_DL_BKP009_PENDING.UNNO; 
         V_HUMIDITY           := TOS_LL_DL_BKP009_PENDING.HUMIDITY; 
         V_VENTILATION        := TOS_LL_DL_BKP009_PENDING.VENTILATION;
         V_WEIGHT             := TOS_LL_DL_BKP009_PENDING.WEIGHT;
         V_VGM                := TOS_LL_DL_BKP009_PENDING.VGM; 
         V_VGM_CATEGORY       := TOS_LL_DL_BKP009_PENDING.VGM_CATEGORY; 
         V_USER_ID            := TOS_LL_DL_BKP009_PENDING.CREATED_USER; 
         
                 
         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'START PROCESS'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'V_SEQ_TBL: '|| TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ
                                                            );	
                                                            
          UPDATE VASAPPS.TOS_LL_DL_CONTAINERS 
            SET STATUS = 'C'
               ,ERR_DESC = ''
               ,RECORD_CHANGE_USER = 'JOBBKG'
               ,RECORD_CHANGE_DATE = SYSDATE
            WHERE FK_BOOKING_NO = V_BOOKING_NO 
              AND PK_TOS_LL_DL_CNTR_SEQ = TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ ;  
        	 COMMIT;                                                              
         
         VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_CHECK_CREATE_LL_DL(V_BOOKING_NO, V_RETURN_STATUS, V_EXEC_FLAG);         



         IF V_MODE_TYPE = 'I' THEN 
         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'B4 IN INSERTING EQUIPMENT'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );	

           IF V_EXEC_FLAG = 'N' THEN
              VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_ADD(V_BOOKING_NO,
                                                                      V_EQUIPMENT_SEQ,
                                                                      V_SIZE_TYPE_SEQ,
                                                                      V_SUPPLIER_SEQ ,
                                                                      V_RETURN_STATUS
                                                                      ) ;
    
           END IF ;
           /*--
           
         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'INSERTING - CHECK STATUS'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'V_RETURN_STATUS :' || V_RETURN_STATUS 
                                                            , ' V_EXEC_FLAG :' || V_EXEC_FLAG 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );	           
           
           IF V_RETURN_STATUS <> '1' AND V_EXEC_FLAG ='N' THEN
           /*--
      			 UPDATE VASAPPS.TOS_LL_DL_CONTAINERS
      			   SET STATUS='C'
      				  ,RECORD_CHANGE_DATE = SYSDATE
      				  ,RECORD_CHANGE_USER = 'JOBBKP009'
      			 WHERE FK_BOOKING_NO=V_BOOKING_NO 
                AND PK_TOS_LL_DL_BOOKING_SEQ = V_SEQ;
                 
                
            PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                               ,'C' -- STATUS 
                               ,'' -- ERR_DESC
                               ,'BKP009' -- source 
                               );
                                  
			 -- COMMIT;

    		  ELSE
            IF V_EXEC_FLAG <> 'N' THEN 
               PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                  ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                   ,'E' -- STATUS 
                                   ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                   ,'BKP009' -- source 
                                   );
            ELSE
            PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                               ,'E' -- STATUS 
                               ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                               ,'BKP009' -- source
                               );
      			 -- COMMIT;
        			VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'ERROR IN INSERTING EQUIPMENT'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
    			  END IF ; -- END IF V_EXEC_FLAG <> 'N' 
    		  END IF;  -- END IF CHECKING V_RETURN_STATUS  
          --*/                 
         END IF; -- END IF V_MODE_TYPE = INSERT .

         IF V_MODE_TYPE = 'D' THEN 
         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'B4 IN DELETE EQUIPMENT'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );	         

            IF V_EXEC_FLAG = 'N' THEN
                VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_REMOVE(V_BOOKING_NO,
                                                                   V_EQUIPMENT_SEQ,
                                                                   V_RETURN_STATUS
                                                                   ) ;
            ELSE -- ezll/ezdl have not created yet.
             PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                 ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                 ,'E' -- STATUS 
                                 ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                 ,'BKP009' -- source 
                                 );
            END IF; 
       /*--  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'DELETE - CHECK STATUS'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'V_RETURN_STATUS :' || V_RETURN_STATUS 
                                                            , ' V_EXEC_FLAG :' || V_EXEC_FLAG 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );	            
            
            IF V_RETURN_STATUS <> '1' AND V_EXEC_FLAG ='N' THEN
              PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                 ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                 ,'C' -- STATUS 
                                 ,'' -- ERR_DESC
                                 ,'BKP009' -- source 
                                 );

    		   ELSE 
            IF V_EXEC_FLAG <> 'N' THEN 
               PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                   ,'E' -- STATUS 
                                   ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                   ,'BKP009' -- source 
                                   );
            ELSE           
              PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                 ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                 ,'E' -- STATUS 
                                 ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                                 ,'BKP009' -- source
                                 );
        			VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'ERROR IN INSERTING EQUIPMENT'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
    			  END IF ; -- END IF CHECKING V_EXEC_FLAG <> 'N' 
    		   END IF;  -- END IF CHECKING V_RETURN_STATUS   
           --*/
         END IF; -- END IF V_MODE_TYPE = DELETE 
         
         IF V_MODE_TYPE = 'U' THEN 
         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'B4 IN UPDATE EQUIPMENT'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );	          
             IF V_EXEC_FLAG = 'N' THEN
                VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_UPDATE(V_BOOKING_NO,
                                                                    V_EQUIPMENT_SEQ,
                                                                    V_OLD_EQUIPMENT_NO,
                                                                    V_NEW_EQUIPMENT_NO,
                                                                    V_OVERH,
                                                                    V_OVERLR,
                                                                    V_OVERLF,
                                                                    V_OVERWL,
                                                                    V_OVERWR,
                                                                    V_IMDG,
                                                                    V_UNNO,
                                                                    V_UN_VAR,
                                                                    V_FLASH_POINT,
                                                                    V_FLASH_UNIT,
                                                                    V_REEFER_TMP,
                                                                    V_REEFER_TMP_UNIT,
                                                                    V_HUMIDITY,
                                                                    V_VENTILATION,
                                                                    V_USER_ID,  
                                                        			      V_WEIGHT, 
                                                        			      V_VGM_CATEGORY , 
                                                        			      V_VGM,
                                                                    V_RETURN_STATUS
                                                                    ) ;             
             ELSE -- ezll/ezdl have not created yet.
               PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                   ,'E' -- STATUS 
                                   ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                   ,'BKP009' -- source 
                                   );
             END IF ; -- END IF CHECKING EXEC_FLAG 
             /*--
         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'UPDATE - CHECK STATUS'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'V_SEQ_TBL :' || TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ
                                                            , 'V_RETURN_STATUS :' || V_RETURN_STATUS 
                                                            , ' V_EXEC_FLAG :' || V_EXEC_FLAG 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );	               
             
             IF V_RETURN_STATUS <> 1 AND V_EXEC_FLAG ='N' THEN 
                PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                   ,'C' -- STATUS 
                                   ,'' -- ERR_DESC
                                   ,'BKP009' -- source 
                                   );

    		     ELSE 
               IF V_EXEC_FLAG <> 'N' THEN 
                 PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                     ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                     ,'E' -- STATUS 
                                     ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                     ,'BKP009' -- source 
                                     );
               ELSE
                PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                   ,'E' -- STATUS 
                                   ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                                   ,'BKP009' -- source
                                   );
        			  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'ERROR IN INSERTING EQUIPMENT'
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
               END IF; -- END IF CHECKING FOR V_EXEC_FLAG <> 'N' 
             END IF; -- END CHECKING FOR V_RETURN_STATUS. 
             --*/
         END IF ; -- END IF V_MODE_TYPE = UPDATE
     
     
     END LOOP;
     COMMIT;
     CLOSE CUR_TOS_LL_DL_BKP009;
     
             			  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP009'
                                                            , '-'
                                                            , 'END PROCESS '
        													                          , 'V_BOOKING_NO : ' || V_BOOKING_NO
                                                            );		
     
     
EXCEPTION
    WHEN OTHERS THEN
         PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                              ,TOS_LL_DL_BKP009_PENDING.PK_TOS_LL_DL_CNTR_SEQ-- ,V_SEQ
                               ,'E' -- STATUS 
                               ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                               ,'BKP009' -- source
                               );     
         --COMMIT;

         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_CONTAINERS'
                                                    , '-'
                                                    , 'EXEPTION ERROR !!'
                                                    , 'V_SEQ : ' || V_SEQ
                                                    , 'V_BOOKING_NO : '|| V_BOOKING_NO                                                    
                                                    , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                    );      


END PRR_TOS_LL_DL_BKP009;

PROCEDURE PRR_TOS_LL_DL_BKG_DG_DTL IS 

V_BOOKING_NO     		           VASAPPS.TOS_LL_DL_CONTAINERS.FK_BOOKING_NO%TYPE;
V_IMO_CLASS                    VASAPPS.TOS_LL_DL_CONTAINERS.IMO_CLASS%TYPE;
V_UNNO                         VASAPPS.TOS_LL_DL_CONTAINERS.UNNO%TYPE;
V_FUMIGATION_FLAG              VASAPPS.TOS_LL_DL_CONTAINERS.FUMIGATION_YN%TYPE;
V_RESIDUE                      VASAPPS.TOS_LL_DL_CONTAINERS.RESIDUE%TYPE;
V_RETURN_STATUS			           VARCHAR2(50);
V_SEQ					                 NUMBER(38);

V_MODE_TYPE                    VARCHAR2(1);
V_EXEC_FLAG                    VARCHAR2(1);
TOS_LL_DL_BKG_DG_PENDING       VASAPPS.TOS_LL_DL_CONTAINERS%ROWTYPE;

CURSOR CUR_TOS_LL_DL_BKG_DG IS
       SELECT * --FK_BOOKING_NO,BOOKING_TYPE,OLD_BOOKING_STATUS,NEW_BOOKING_STATUS,PK_TOS_LL_DL_BOOKING_SEQ
       from VASAPPS.TOS_LL_DL_CONTAINERS
       WHERE STATUS IN ('P', 'L') --'L' -- 'P' SELECT LOCKED STATUS TO LOCK RECORD FOR PROCESSING.
       AND TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       and source='BKGDGDTL'
       order by TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS'))ASC, PK_TOS_LL_DL_CNTR_SEQ asc
      ;
      --FOR UPDATE NOWAIT;
      -- FOR UPDATE OF STATUS ;

BEGIN 
/*--
UPDATE VASAPPS.TOS_LL_DL_CONTAINERS 
		SET STATUS='L'
	 WHERE TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       AND SOURCE='BKGDGDTL'
	   AND STATUS='P';
	 COMMIT;  
	--*/

     OPEN CUR_TOS_LL_DL_BKG_DG;
     --FOR TOS_LL_DL_BKG_PENDING IN CUR_TOS_LL_DL_BOOKING
     LOOP
         
          
         FETCH CUR_TOS_LL_DL_BKG_DG INTO TOS_LL_DL_BKG_DG_PENDING;
         EXIT WHEN CUR_TOS_LL_DL_BKG_DG%NOTFOUND; 

         
          V_BOOKING_NO  :=  TOS_LL_DL_BKG_DG_PENDING.FK_BOOKING_NO;
          V_IMO_CLASS   :=  TOS_LL_DL_BKG_DG_PENDING.IMO_CLASS;
          V_UNNO        :=  TOS_LL_DL_BKG_DG_PENDING.UNNO;
          V_FUMIGATION_FLAG := TOS_LL_DL_BKG_DG_PENDING.FUMIGATION_YN;
          V_RESIDUE     :=  TOS_LL_DL_BKG_DG_PENDING.RESIDUE;
		      V_SEQ                := TOS_LL_DL_BKG_DG_PENDING.PK_TOS_LL_DL_CNTR_SEQ;
          V_MODE_TYPE          := TOS_LL_DL_BKG_DG_PENDING.MODE_TYPE;          
       
           PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,TOS_LL_DL_BKG_DG_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                               ,'C' -- STATUS 
                               ,'' -- ERR_DESC
                               ,'BKGDGDTL' -- source 
                               );
           commit;
         
         VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_CHECK_CREATE_LL_DL(V_BOOKING_NO, V_RETURN_STATUS, V_EXEC_FLAG);         

         IF V_MODE_TYPE = 'I' THEN 



           IF V_EXEC_FLAG = 'N' THEN
             VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_UPDATE_DG( V_BOOKING_NO,
                                                                  V_IMO_CLASS ,
                                                                  V_UNNO ,
                                                                  V_FUMIGATION_FLAG ,
                                                                  V_RESIDUE ,
                                                                  V_RETURN_STATUS);           
    
           END IF ;
           /*--
           
           IF V_RETURN_STATUS <> '1' AND V_EXEC_FLAG ='N' THEN
                
            PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'C' -- STATUS 
                               ,'' -- ERR_DESC
                               ,'BKGDGDTL' -- source 
                               );
                                  
			 -- COMMIT;

    		  ELSE
            IF V_EXEC_FLAG <> 'N' THEN 
               PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,V_SEQ
                                   ,'E' -- STATUS 
                                   ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                   ,'BKGDGDTL' -- source 
                                   );
            ELSE
            PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'E' -- STATUS 
                               ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                               ,'BKGDGDTL' -- source
                               );
      			 -- COMMIT;
        			VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKG_DG_DTL'
                                                            , '-'
                                                            , 'ERROR IN UPDAING DG INFO'
        													                          , 'V_BOOKING_NO : ' || V_RETURN_STATUS
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
    			  END IF ; -- END IF V_EXEC_FLAG <> 'N' 
    		  END IF;  -- END IF CHECKING V_RETURN_STATUS      
          --*/             
         END IF; -- END IF V_MODE_TYPE = INSERT .

         IF V_MODE_TYPE = 'D' THEN 
         
            
            IF V_EXEC_FLAG = 'N' THEN
             VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_UPDATE_DG( V_BOOKING_NO,
                                                                  V_IMO_CLASS ,
                                                                  V_UNNO ,
                                                                  V_FUMIGATION_FLAG ,
                                                                  V_RESIDUE ,
                                                                  V_RETURN_STATUS);  
            ELSE -- ezll/ezdl have not created yet.
             PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                 ,TOS_LL_DL_BKG_DG_PENDING.PK_TOS_LL_DL_CNTR_SEQ--,V_SEQ
                                 ,'E' -- STATUS 
                                 ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                 ,'BKGDGDTL' -- source 
                                 );
            END IF; 
            /*--
            
            IF V_RETURN_STATUS <> '1' AND V_EXEC_FLAG ='N' THEN
              PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                 ,V_SEQ
                                 ,'C' -- STATUS 
                                 ,'' -- ERR_DESC
                                 ,'BKGDGDTL' -- source 
                                 );

    		   ELSE 
            IF V_EXEC_FLAG <> 'N' THEN 
               PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,V_SEQ
                                   ,'E' -- STATUS 
                                   ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                   ,'BKGDGDTL' -- source 
                                   );
            ELSE           
              PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                 ,V_SEQ
                                 ,'E' -- STATUS 
                                 ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                                 ,'BKGDGDTL' -- source
                                 );
        			VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKG_DG_DTL'
                                                            , '-'
                                                            , 'ERROR IN UPDATING DG INFO'
        													                          , 'V_BOOKING_NO : ' || V_RETURN_STATUS
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
    			  END IF ; -- END IF CHECKING V_EXEC_FLAG <> 'N' 
    		   END IF;  -- END IF CHECKING V_RETURN_STATUS   
           --*/
         END IF; -- END IF V_MODE_TYPE = DELETE 
         
         IF V_MODE_TYPE = 'U' THEN 

                     
             IF V_EXEC_FLAG = 'N' THEN
               VASAPPS.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_UPDATE_DG( V_BOOKING_NO,
                                                                    V_IMO_CLASS ,
                                                                    V_UNNO ,
                                                                    V_FUMIGATION_FLAG ,
                                                                    V_RESIDUE ,
                                                                    V_RETURN_STATUS);           
             ELSE -- ezll/ezdl have not created yet.
               PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,V_SEQ
                                   ,'E' -- STATUS 
                                   ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                   ,'BKGDGDTL' -- source 
                                   );
             END IF ; -- END IF CHECKING EXEC_FLAG 
             /*--
             IF V_RETURN_STATUS <> 1 AND V_EXEC_FLAG ='N' THEN 
                PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,V_SEQ
                                   ,'C' -- STATUS 
                                   ,'' -- ERR_DESC
                                   ,'BKGDGDTL' -- source 
                                   );

    		     ELSE 
               IF V_EXEC_FLAG <> 'N' THEN 
                 PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                     ,V_SEQ
                                     ,'E' -- STATUS 
                                     ,'CAN NOT FIND EZLL/EZDL' -- ERR_DESC
                                     ,'BKGDGDTL' -- source 
                                     );
               ELSE
                PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,V_SEQ
                                   ,'E' -- STATUS 
                                   ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                                   ,'BKGDGDTL' -- source
                                   );
        			  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKG_DG_DTL'
                                                            , '-'
                                                            , 'ERROR IN UPDATING DG INFO'
        													                          , 'V_BOOKING_NO : ' || V_RETURN_STATUS
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
               END IF; -- END IF CHECKING FOR V_EXEC_FLAG <> 'N' 
             END IF; -- END CHECKING FOR V_RETURN_STATUS. 
             --*/
         END IF ; -- END IF V_MODE_TYPE = UPDATE
     
     END LOOP;
     COMMIT;
     CLOSE CUR_TOS_LL_DL_BKG_DG;
     
EXCEPTION
    WHEN OTHERS THEN
         PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'E' -- STATUS 
                               ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                               ,'BKP009' -- source
                               );     
         --COMMIT;

         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKG_DG_DTL'
                                                    , '-'
                                                    , 'EXEPTION ERROR !!'
                                                    , 'V_SEQ : ' || V_SEQ
                                                    , 'V_BOOKING_NO : '|| V_BOOKING_NO                                                    
                                                    , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                    );      

END PRR_TOS_LL_DL_BKG_DG_DTL ;

PROCEDURE PRR_TOS_LL_DL_ROUTING IS 

V_BOOKING_NO     		           VASAPPS.TOS_LL_DL_ROUTING.FK_BOOKING_NO%TYPE;
V_VOYAGE_SEQ_NO                VASAPPS.TOS_LL_DL_ROUTING.FK_VOYAGE_SEQ_NO%TYPE;
V_NEW_SERVICE                  VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_SERVICE%TYPE;                       
V_NEW_VESSEL                   VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_VESSEL%TYPE;
V_NEW_VOYAGE                   VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_VOYAGE%TYPE;
V_NEW_DIRECTION                VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_DIRECTION%TYPE;
V_NEW_LOAD_PORT                VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_LOAD_PORT%TYPE;
V_NEW_PORT_SEQ                 VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_PORT_SEQ%TYPE;
V_NEW_DISCHARGE_PORT           VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_DISCHARGE_PORT%TYPE;
V_NEW_ACT_SERVICE              VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_ACT_SERVICE%TYPE;
V_NEW_ACT_VESSEL               VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_ACT_VESSEL%TYPE;
V_NEW_ACT_VOYAGE               VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_ACT_VOYAGE%TYPE;
V_NEW_ACT_PORT_DIR             VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_ACT_PORT_DIR%TYPE;
V_NEW_ACT_PORT_SEQ             VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_ACT_PORT_SEQ%TYPE;
V_NEW_TO_TERMINAL              VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_TO_TERMINAL%TYPE;
V_NEW_FROM_TERMINAL            VASAPPS.TOS_LL_DL_ROUTING.FK_NEW_FROM_TERMINAL%TYPE;
V_OLD_SERVICE                  VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_SERVICE%TYPE;
V_OLD_VESSEL                   VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_VESSEL%TYPE;
V_OLD_VOYAGE                   VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_VOYAGE%TYPE;
V_OLD_DIRECTION                VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_DIRECTION%TYPE;
V_OLD_LOAD_PORT                VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_LOAD_PORT%TYPE;
V_OLD_PORT_SEQ                 VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_PORT_SEQ%TYPE;
V_OLD_DISCHARGE_PORT           VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_DISCHARGE_PORT%TYPE;
V_OLD_ACT_SERVICE              VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_ACT_SERVICE%TYPE;
V_OLD_ACT_VESSEL               VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_ACT_VESSEL%TYPE;
V_OLD_ACT_VOYAGE               VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_ACT_VOYAGE%TYPE;
V_OLD_ACT_PORT_DIR             VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_ACT_PORT_DIR%TYPE;
V_OLD_ACT_PORT_SEQ             VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_ACT_PORT_SEQ%TYPE;
V_OLD_TO_TERMINAL              VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_TO_TERMINAL%TYPE;
V_OLD_FROM_TERMINAL            VASAPPS.TOS_LL_DL_ROUTING.FK_OLD_FROM_TERMINAL%TYPE;


V_RETURN_STATUS			           VARCHAR2(50);
V_SEQ					                 NUMBER(38);

V_MODE_TYPE                    VARCHAR2(1);
TOS_LL_DL_BKG_RT_PENDING       VASAPPS.TOS_LL_DL_ROUTING%ROWTYPE;

CURSOR CUR_TOS_LL_DL_BKG_ROUTING IS
       SELECT * --FK_BOOKING_NO,BOOKING_TYPE,OLD_BOOKING_STATUS,NEW_BOOKING_STATUS,PK_TOS_LL_DL_BOOKING_SEQ
       from VASAPPS.TOS_LL_DL_ROUTING
       WHERE STATUS IN ('P','L')-- 'L' -- 'P' SELECT LOCKED STATUS TO LOCK RECORD FOR PROCESSING.
       AND TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       and source='BKGROUT'
       order by TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS'))ASC, PK_TOS_LL_DL_RT_SEQ asc
      ;
      --FOR UPDATE NOWAIT;
      -- FOR UPDATE OF STATUS ;

BEGIN 
/*--
UPDATE VASAPPS.TOS_LL_DL_ROUTING 
		SET STATUS='L'
	 WHERE TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       AND SOURCE='BKGROUT'
	   AND STATUS='P';
	 COMMIT;  
	--*/

     OPEN CUR_TOS_LL_DL_BKG_ROUTING;
     --FOR TOS_LL_DL_BKG_PENDING IN CUR_TOS_LL_DL_BOOKING
     LOOP
     
                 
         FETCH CUR_TOS_LL_DL_BKG_ROUTING INTO TOS_LL_DL_BKG_RT_PENDING;
         EXIT WHEN CUR_TOS_LL_DL_BKG_ROUTING%NOTFOUND;

         
            V_BOOKING_NO     		   := TOS_LL_DL_BKG_RT_PENDING.FK_BOOKING_NO;
            V_VOYAGE_SEQ_NO        := TOS_LL_DL_BKG_RT_PENDING.FK_VOYAGE_SEQ_NO;
            V_NEW_SERVICE          := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_SERVICE;                       
            V_NEW_VESSEL           := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_VESSEL;
            V_NEW_VOYAGE           := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_VOYAGE;
            V_NEW_DIRECTION        := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_DIRECTION;
            V_NEW_LOAD_PORT        := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_LOAD_PORT;
            V_NEW_PORT_SEQ         := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_PORT_SEQ;
            V_NEW_DISCHARGE_PORT   := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_DISCHARGE_PORT;
            V_NEW_ACT_SERVICE      := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_ACT_SERVICE;
            V_NEW_ACT_VESSEL       := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_ACT_VESSEL;
            V_NEW_ACT_VOYAGE       := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_ACT_VOYAGE;
            V_NEW_ACT_PORT_DIR     := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_ACT_PORT_DIR;
            V_NEW_ACT_PORT_SEQ     := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_ACT_PORT_SEQ;
            V_NEW_TO_TERMINAL      := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_TO_TERMINAL;
            V_NEW_FROM_TERMINAL    := TOS_LL_DL_BKG_RT_PENDING.FK_NEW_FROM_TERMINAL;
            V_OLD_SERVICE          := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_SERVICE;
            V_OLD_VESSEL           := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_VESSEL;
            V_OLD_VOYAGE           := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_VOYAGE;
            V_OLD_DIRECTION        := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_DIRECTION;
            V_OLD_LOAD_PORT        := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_LOAD_PORT;
            V_OLD_PORT_SEQ         := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_PORT_SEQ;
            V_OLD_DISCHARGE_PORT   := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_DISCHARGE_PORT;
            V_OLD_ACT_SERVICE      := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_ACT_SERVICE;
            V_OLD_ACT_VESSEL       := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_ACT_VESSEL;
            V_OLD_ACT_VOYAGE       := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_ACT_VOYAGE;
            V_OLD_ACT_PORT_DIR     := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_ACT_PORT_DIR;
            V_OLD_ACT_PORT_SEQ     := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_ACT_PORT_SEQ;
            V_OLD_TO_TERMINAL      := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_TO_TERMINAL;
            V_OLD_FROM_TERMINAL    := TOS_LL_DL_BKG_RT_PENDING.FK_OLD_FROM_TERMINAL;      
		        V_SEQ                  := TOS_LL_DL_BKG_RT_PENDING.PK_TOS_LL_DL_RT_SEQ;
            V_MODE_TYPE            := TOS_LL_DL_BKG_RT_PENDING.MODE_TYPE;               
       
              
           PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,TOS_LL_DL_BKG_RT_PENDING.PK_TOS_LL_DL_RT_SEQ--,V_SEQ
                               ,'C' -- STATUS 
                               ,'' -- ERR_DESC
                               ,'BKGROUT' -- source 
                               );
           COMMIT;

         IF V_MODE_TYPE = 'I' THEN 


             PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_ROUTING_UPDATE(
                                                              V_BOOKING_NO ,
                                                              V_VOYAGE_SEQ_NO,
                                                              V_OLD_SERVICE,
                                                              V_NEW_SERVICE,
                                                              V_OLD_VESSEL,
                                                              V_NEW_VESSEL,
                                                              V_OLD_VOYAGE,
                                                              V_NEW_VOYAGE,
                                                              V_OLD_DIRECTION,
                                                              V_NEW_DIRECTION,
                                                              V_OLD_LOAD_PORT,
                                                              V_NEW_LOAD_PORT,
                                                              V_OLD_PORT_SEQ,
                                                              V_NEW_PORT_SEQ,
                                                              V_OLD_DISCHARGE_PORT,
                                                              V_NEW_DISCHARGE_PORT,
                                                              V_OLD_ACT_SERVICE,
                                                              V_NEW_ACT_SERVICE,
                                                              V_OLD_ACT_VESSEL,
                                                              V_NEW_ACT_VESSEL,
                                                              V_OLD_ACT_VOYAGE,
                                                              V_NEW_ACT_VOYAGE,
                                                              V_OLD_ACT_PORT_DIR,
                                                              V_NEW_ACT_PORT_DIR,
                                                              V_OLD_ACT_PORT_SEQ,
                                                              V_NEW_ACT_PORT_SEQ,
                                                              V_OLD_TO_TERMINAL,
                                                              V_NEW_TO_TERMINAL,
                                                              V_OLD_FROM_TERMINAL,  
                                                              V_NEW_FROM_TERMINAL,  
                                                              'A',
                                                              V_RETURN_STATUS
                                                               );
                      
    /*--
           
           IF V_RETURN_STATUS <> '1' THEN
                
            PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'C' -- STATUS 
                               ,'' -- ERR_DESC
                               ,'BKGROUT' -- source 
                               );
                                  
			 -- COMMIT;

           ELSE
            PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'E' -- STATUS 
                               ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                               ,'BKGROUT' -- source
                               );
      			 -- COMMIT;
        			VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKG_ROUTING'
                                                            , '-'
                                                            , 'ERROR IN UPDATING ROUTING'
        													                          , 'V_BOOKING_NO : ' || V_RETURN_STATUS
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
    			  END IF ; -- END IF V_RETURN_STATUS
            --*/ 
         END IF; -- END IF V_MODE_TYPE = INSERT .

         IF V_MODE_TYPE = 'D' THEN 
  

             PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_ROUTING_UPDATE(
                                                              V_BOOKING_NO ,
                                                              V_VOYAGE_SEQ_NO,
                                                              V_OLD_SERVICE,
                                                              V_NEW_SERVICE,
                                                              V_OLD_VESSEL,
                                                              V_NEW_VESSEL,
                                                              V_OLD_VOYAGE,
                                                              V_NEW_VOYAGE,
                                                              V_OLD_DIRECTION,
                                                              V_NEW_DIRECTION,
                                                              V_OLD_LOAD_PORT,
                                                              V_NEW_LOAD_PORT,
                                                              V_OLD_PORT_SEQ,
                                                              V_NEW_PORT_SEQ,
                                                              V_OLD_DISCHARGE_PORT,
                                                              V_NEW_DISCHARGE_PORT,
                                                              V_OLD_ACT_SERVICE,
                                                              V_NEW_ACT_SERVICE,
                                                              V_OLD_ACT_VESSEL,
                                                              V_NEW_ACT_VESSEL,
                                                              V_OLD_ACT_VOYAGE,
                                                              V_NEW_ACT_VOYAGE,
                                                              V_OLD_ACT_PORT_DIR,
                                                              V_NEW_ACT_PORT_DIR,
                                                              V_OLD_ACT_PORT_SEQ,
                                                              V_NEW_ACT_PORT_SEQ,
                                                              V_OLD_TO_TERMINAL,
                                                              V_NEW_TO_TERMINAL,
                                                              V_OLD_FROM_TERMINAL,  
                                                              V_NEW_FROM_TERMINAL,  
                                                              'D',
                                                              V_RETURN_STATUS
                                                               );
                      
            /*--
            IF V_RETURN_STATUS <> '1' THEN
              PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                 ,V_SEQ
                                 ,'C' -- STATUS 
                                 ,'' -- ERR_DESC
                                 ,'BKGROUT' -- source 
                                 );

            ELSE           
              PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                 ,V_SEQ
                                 ,'E' -- STATUS 
                                 ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                                 ,'BKGROUT' -- source
                                 );
        			VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKG_ROUTING'
                                                            , '-'
                                                            , 'ERROR IN UPDATING ROUTING'
        													                          , 'V_BOOKING_NO : ' || V_RETURN_STATUS
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
    		   END IF;  -- END IF CHECKING V_RETURN_STATUS   
           --*/
         END IF; -- END IF V_MODE_TYPE = DELETE 
         
         IF V_MODE_TYPE = 'U' THEN 
 

             PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_ROUTING_UPDATE(
                                                              V_BOOKING_NO ,
                                                              V_VOYAGE_SEQ_NO,
                                                              V_OLD_SERVICE,
                                                              V_NEW_SERVICE,
                                                              V_OLD_VESSEL,
                                                              V_NEW_VESSEL,
                                                              V_OLD_VOYAGE,
                                                              V_NEW_VOYAGE,
                                                              V_OLD_DIRECTION,
                                                              V_NEW_DIRECTION,
                                                              V_OLD_LOAD_PORT,
                                                              V_NEW_LOAD_PORT,
                                                              V_OLD_PORT_SEQ,
                                                              V_NEW_PORT_SEQ,
                                                              V_OLD_DISCHARGE_PORT,
                                                              V_NEW_DISCHARGE_PORT,
                                                              V_OLD_ACT_SERVICE,
                                                              V_NEW_ACT_SERVICE,
                                                              V_OLD_ACT_VESSEL,
                                                              V_NEW_ACT_VESSEL,
                                                              V_OLD_ACT_VOYAGE,
                                                              V_NEW_ACT_VOYAGE,
                                                              V_OLD_ACT_PORT_DIR,
                                                              V_NEW_ACT_PORT_DIR,
                                                              V_OLD_ACT_PORT_SEQ,
                                                              V_NEW_ACT_PORT_SEQ,
                                                              V_OLD_TO_TERMINAL,
                                                              V_NEW_TO_TERMINAL,
                                                              V_OLD_FROM_TERMINAL,  
                                                              V_NEW_FROM_TERMINAL,  
                                                              'U',
                                                              V_RETURN_STATUS
                                                               );      
/*--
             
             IF V_RETURN_STATUS <> 1 THEN 
                PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,V_SEQ
                                   ,'C' -- STATUS 
                                   ,'' -- ERR_DESC
                                   ,'BKGROUT' -- source 
                                   );

             ELSE
                PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                                   ,V_SEQ
                                   ,'E' -- STATUS 
                                   ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                                   ,'BKGROUT' -- source
                                   );
        			  VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKG_ROUTING'
                                                            , '-'
                                                            , 'ERROR IN UPDATING ROUTING'
        													                          , 'V_BOOKING_NO : ' || V_RETURN_STATUS
        													                          , 'V_SEQ : ' || V_SEQ 
                                                            , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                            , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                            );		  
             END IF; -- END CHECKING FOR V_RETURN_STATUS. 
             --*/
         END IF ; -- END IF V_MODE_TYPE = UPDATE
     
     END LOOP;
     COMMIT;
     CLOSE CUR_TOS_LL_DL_BKG_ROUTING;
     
EXCEPTION
    WHEN OTHERS THEN
         PRR_TOS_UPD_STATUS (V_BOOKING_NO 
                               ,V_SEQ
                               ,'E' -- STATUS 
                               ,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||  DBMS_UTILITY.FORMAT_ERROR_STACK,1,1000) -- ERR_DESC
                               ,'BKGROUT' -- source
                               );     
         --COMMIT;

         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BKP_ROUTING'
                                                    , '-'
                                                    , 'EXEPTION ERROR !!'
                                                    , 'V_SEQ : ' || V_SEQ
                                                    , 'V_BOOKING_NO : '|| V_BOOKING_NO                                                    
                                                    , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                    );     

END PRR_TOS_LL_DL_ROUTING;

PROCEDURE PRR_TOS_UPD_STATUS (P_I_V_BOOKING_NO       VARCHAR2
                               ,P_I_V_SEQ            INTEGER
                               ,P_I_V_STATUS         VARCHAR2 
                               ,P_I_V_ERR_DESC       VARCHAR2 
                               ,P_I_V_SOURCE         VARCHAR2  ) AS 
                               
V_REC_CHANGE_USER              VARCHAR2(10);                               
BEGIN

IF  P_I_V_SOURCE = 'BKP009' THEN 
   V_REC_CHANGE_USER := 'JOBBKG';
ELSIF P_I_V_SOURCE = 'BKPDGDTL' THEN 
   V_REC_CHANGE_USER := 'JOBBKGDG';

END IF; 

     IF P_I_V_SOURCE = 'BKG' THEN 
        UPDATE VASAPPS.TOS_LL_DL_BOOKING 
        SET STATUS = P_I_V_STATUS
           ,ERR_DESC = P_I_V_ERR_DESC
           ,RECORD_CHANGE_USER = 'JOBBKG'
           ,RECORD_CHANGE_DATE = SYSDATE
        WHERE FK_BOOKING_NO = P_I_V_BOOKING_NO 
          AND PK_TOS_LL_DL_BOOKING_SEQ = P_I_V_SEQ ; 
     END IF ;
     
     IF P_I_V_SOURCE IN ('BKP009','BKGDGDTL') THEN 
        UPDATE VASAPPS.TOS_LL_DL_CONTAINERS 
        SET STATUS = P_I_V_STATUS
           ,ERR_DESC = P_I_V_ERR_DESC
           ,RECORD_CHANGE_USER = V_REC_CHANGE_USER
           ,RECORD_CHANGE_DATE = SYSDATE
        WHERE FK_BOOKING_NO = P_I_V_BOOKING_NO 
          AND PK_TOS_LL_DL_CNTR_SEQ = P_I_V_SEQ ;      
     END IF;
     
     IF P_I_V_SOURCE = 'BKGROUT' THEN 
        UPDATE VASAPPS.TOS_LL_DL_ROUTING 
        SET STATUS = P_I_V_STATUS
           ,ERR_DESC = P_I_V_ERR_DESC
           ,RECORD_CHANGE_USER = 'JOBROUT'
           ,RECORD_CHANGE_DATE = SYSDATE
        WHERE FK_BOOKING_NO = P_I_V_BOOKING_NO 
          AND PK_TOS_LL_DL_RT_SEQ = P_I_V_SEQ ;      
     END IF; 
     
    -- COMMIT; 
  EXCEPTION
    WHEN OTHERS THEN

         VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_UPD_STATUS'
                                                    , '-'
                                                    , 'ERROR IN UPDATE STATUS.'
                                                    , 'V_SEQ : ' || P_I_V_SEQ
                                                    , 'V_BOOKING_NO : '|| P_I_V_BOOKING_NO                                                    
                                                    , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                    );      
     
                               
                               
END PRR_TOS_UPD_STATUS;                           


end PCR_TOS_SYNC_LL_DL_BOOKING;
