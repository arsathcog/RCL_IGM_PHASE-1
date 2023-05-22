CREATE OR REPLACE package body VASAPPS.PCR_TOS_SYNC_EZLLDL_BOOKING is

PROCEDURE PRR_TOS_UPD_EZLLDL_BOOKING AS

V_BOOKING_NO             BKP001.BABKNO%TYPE;
V_BOOKING_TYPE             BKP001.BOOKING_TYPE%TYPE;
V_OLD_BOOKING_STATUS    BKP001.BASTAT%TYPE;
V_NEW_BOOKING_STATUS    BKP001.BASTAT%TYPE;
V_RETURN_STATUS            VARCHAR2(50);

V_SEQ                          NUMBER(38);
TOS_LL_DL_BKG_PENDING       VASAPPS.TOS_LL_Dl_BOOKING%ROWTYPE;
V_USER_UPDATE_09 VARCHAR2(50 CHAR) DEFAULT 'TRGBKP009';
V_USER_UPDATE_01 VARCHAR2(50 CHAR) DEFAULT 'TRGBKP001';

V_USER_INSERT_09 VARCHAR2(50 CHAR) DEFAULT 'TRGBKP009';
V_USER_INSERT_01 VARCHAR2(50 CHAR) DEFAULT 'TRGBKP001';

V_DATE_UPDATE DATE DEFAULT SYSDATE;
V_CNT_ROW NUMBER(5);
V_CNT_ROW_LL NUMBER(5) DEFAULT 0;
V_CNT_ROW_DL NUMBER(5) DEFAULT 0;
V_CNT_ROW_P NUMBER(5);
V_USER_INSERT VARCHAR2(50 CHAR);

V_ERROR_MSG VARCHAR2(1000 CHAR);
V_ALL_MSG VARCHAR2(3000 CHAR);
l_n_load_id TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE;


CURSOR CUR_TOS_LL_DL_BOOKING IS
       SELECT * --FK_BOOKING_NO,BOOKING_TYPE,OLD_BOOKING_STATUS,NEW_BOOKING_STATUS,PK_TOS_LL_DL_BOOKING_SEQ
       from VASAPPS.TOS_LL_DL_BOOKING
       WHERE STATUS = 'L' -- 'P' SELECT LOCKED STATUS TO LOCK RECORD FOR PROCESSING.
       AND TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <=  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       and source='BKG'
       order by PK_TOS_LL_DL_BOOKING_SEQ asc;


BEGIN


     BEGIN
     UPDATE VASAPPS.TOS_LL_DL_BOOKING 
        SET STATUS='L'
       WHERE TO_NUMBER(TO_CHAR(RECORD_ADD_DATE,'YYYYMMDD')||TO_CHAR(RECORD_ADD_DATE,'HH24MISS')) <=  TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TO_CHAR(SYSDATE,'HH24MISS'))
       AND RECORD_STATUS='A'
       AND SOURCE='BKG'
       AND STATUS='P';
     COMMIT;  
     END;

     OPEN CUR_TOS_LL_DL_BOOKING;
     --FOR TOS_LL_DL_BKG_PENDING IN CUR_TOS_LL_DL_BOOKING
     LOOP
         FETCH CUR_TOS_LL_DL_BOOKING INTO TOS_LL_DL_BKG_PENDING;
         EXIT WHEN CUR_TOS_LL_DL_BOOKING%NOTFOUND;
  
                                              
           --Check existing data all leg
           IF TOS_LL_DL_BKG_PENDING.RECORD_ADD_USER IN( 'TRGBKP001' ,'TRGRT001') THEN
            --find  FK_LOAD_LIST_ID
                  IF TOS_LL_DL_BKG_PENDING.RECORD_ADD_USER = 'TRGBKP001' THEN
                        V_USER_UPDATE_01 := 'TRGBKP001';
                        V_USER_INSERT_01 := 'TRGBKP001';
                  ELSE
                         V_USER_UPDATE_01 := 'TRGRT001';
                         V_USER_INSERT_01 := 'TRGRT001';
                  END IF;
                  
                   
                  PRE_CHECK_EXISTING_DATA_BKP001(TOS_LL_DL_BKG_PENDING.SEA_LEG_PORT,
                                                       TOS_LL_DL_BKG_PENDING.FK_SERVICE ,
                                                      TOS_LL_DL_BKG_PENDING.FK_VESSEL ,
                                                      TOS_LL_DL_BKG_PENDING.FK_VOYAGE ,
                                                     TOS_LL_DL_BKG_PENDING.FK_DIRECTION ,
                                                     TOS_LL_DL_BKG_PENDING.FK_PORT_SEQ ,
                                                     TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO ,
                                                     V_CNT_ROW);
           ELSE
           
                      IF TOS_LL_DL_BKG_PENDING.RECORD_ADD_USER = 'TRGBKP009' THEN
                        V_USER_UPDATE_01 := 'TRGBKP009';
                        V_USER_INSERT_01 := 'TRGBKP009';
                  ELSE
                         V_USER_UPDATE_01 := 'TRGRT009';
                         V_USER_INSERT_01 := 'TRGRT009';
                  END IF;
                      
                    PRE_CHECK_EXISTING_DATA_EZLL(TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO ,
                                                                             TOS_LL_DL_BKG_PENDING.EQUIPMENT_NO ,
                                                                             TOS_LL_DL_BKG_PENDING.EQUIPMENT_SEQ,
                                                                             V_CNT_ROW_LL);
                       
                    PRE_CHECK_EXISTING_DATA_EZDL(TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO ,
                                                                             TOS_LL_DL_BKG_PENDING.EQUIPMENT_NO ,
                                                                             TOS_LL_DL_BKG_PENDING.EQUIPMENT_SEQ,
                                                                             V_CNT_ROW_DL);           
                                                                           
                                                                           
           END IF;

             IF  V_CNT_ROW > 0 OR V_CNT_ROW_LL > 0 OR V_CNT_ROW_DL > 0 THEN   --Has data and status is Booked
                IF TOS_LL_DL_BKG_PENDING.RECORD_ADD_USER IN( 'TRGBKP001' ,'TRGRT001') THEN

                  PRE_UPDATE_FLAG_EZLL( TOS_LL_DL_BKG_PENDING.SEA_LEG_PORT,
                                                   TOS_LL_DL_BKG_PENDING.FK_SERVICE ,
                                                  TOS_LL_DL_BKG_PENDING.FK_VESSEL ,
                                                  TOS_LL_DL_BKG_PENDING.FK_VOYAGE ,
                                                 TOS_LL_DL_BKG_PENDING.FK_DIRECTION ,
                                                 TOS_LL_DL_BKG_PENDING.FK_PORT_SEQ ,
                                                 TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO ,
                                                 TOS_LL_DL_BKG_PENDING.EQUIPMENT_NO ,
                                                 TOS_LL_DL_BKG_PENDING.EQUIPMENT_SEQ,
                                                 V_USER_UPDATE_01,
                                                 V_ERROR_MSG,
                                                 V_RETURN_STATUS
                                                 );
                                                 
                         PRE_UPDATE_STATUS_TEMP(V_USER_INSERT_01,
                                                         TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO,
                                                         TOS_LL_DL_BKG_PENDING.PK_TOS_LL_DL_BOOKING_SEQ,
                                                         V_RETURN_STATUS,
                                                         V_ERROR_MSG
                                                         );
                END IF;
                
                IF TOS_LL_DL_BKG_PENDING.RECORD_ADD_USER IN ( 'TRGBKP009','TRGRT009') THEN
                    IF V_CNT_ROW_LL > 0 THEN
                    -- Update vgm ann category at EZLL
                     PRE_UPDATE_EZLL_VGM(TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO,
                                                           TOS_LL_DL_BKG_PENDING.EQUIPMENT_NO,
                                                           TOS_LL_DL_BKG_PENDING.EQUIPMENT_SEQ,
                                                           TOS_LL_DL_BKG_PENDING.CATEGORY_CODE,
                                                           TOS_LL_DL_BKG_PENDING.VGM,
                                                           V_USER_UPDATE_09,
                                                            V_ERROR_MSG,
                                                            V_RETURN_STATUS
                                                         );
                   END IF;
                   
                   V_ALL_MSG := substr(V_ALL_MSG||','||V_ERROR_MSG, 1, 3000); --V_ALL_MSG||','||V_ERROR_MSG;
                   
                  IF V_CNT_ROW_DL > 0 THEN
                   -- Update vgm and category at EZDL
                   PRE_UPDATE_EZDL_VGM(TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO,
                                                           TOS_LL_DL_BKG_PENDING.EQUIPMENT_NO,
                                                           TOS_LL_DL_BKG_PENDING.EQUIPMENT_SEQ,
                                                           TOS_LL_DL_BKG_PENDING.CATEGORY_CODE,
                                                           TOS_LL_DL_BKG_PENDING.VGM,
                                                           V_USER_UPDATE_09,
                                                            V_ERROR_MSG,
                                                            V_RETURN_STATUS);
                  END IF;
                  
                  V_ALL_MSG := substr(V_ALL_MSG||','||V_ERROR_MSG, 1, 3000); --V_ALL_MSG||','||V_ERROR_MSG;
                  
                 -- Update flag at  TOS_LL_DL_BOOKING
                  PRE_UPDATE_STATUS_TEMP(V_USER_INSERT_01,
                                                             TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO,
                                                             TOS_LL_DL_BKG_PENDING.PK_TOS_LL_DL_BOOKING_SEQ,
                                                             V_RETURN_STATUS,
                                                             V_ALL_MSG
                                                             );
                END IF;
                
             ELSE --Not exists data
             
                 IF TOS_LL_DL_BKG_PENDING.RECORD_ADD_USER IN( 'TRGBKP001' ,'TRGRT001') THEN --for stamp flag
                 
                          V_ERROR_MSG := 'WAIT TO FLOW DATA AGAIN';
                          PRE_UPDATE_STATUS_TEMP(V_USER_INSERT,
                                                             TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO,
                                                             TOS_LL_DL_BKG_PENDING.PK_TOS_LL_DL_BOOKING_SEQ,
                                                             '4',
                                                             V_ERROR_MSG
                                                             ); -- WAIT TO FLOW DATA AGAIN
                 
                 ELSE -- for vgm and category
                 
                     BEGIN
                        SELECT COUNT(1) 
                        INTO V_CNT_ROW_P
                        FROM TOS_LL_BOOKED_LOADING TOS_LL
                        WHERE TOS_LL.FK_BOOKING_NO = TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO
                        AND NVL( TOS_LL.DN_EQUIPMENT_NO,'XXX') =  NVL(TOS_LL_DL_BKG_PENDING.EQUIPMENT_NO,'XXX')
                        AND TOS_LL.FK_BKG_EQUIPM_DTL = TOS_LL_DL_BKG_PENDING.EQUIPMENT_SEQ
                        AND TOS_LL.LOADING_STATUS <> 'BK'
                        AND TOS_LL.RECORD_STATUS = 'A';
                     END;
                     
                     IF V_CNT_ROW_P > 0 --Has data and status is NOT Booked
                     THEN
                        IF TOS_LL_DL_BKG_PENDING.RECORD_ADD_USER = 'TRGBKP001' THEN
                          V_USER_INSERT := V_USER_INSERT_01;
                        ELSE
                          V_USER_INSERT := V_USER_INSERT_09;
                        END IF;
                       V_ERROR_MSG := 'NO DATA FOUND';
                       PRE_UPDATE_STATUS_TEMP(V_USER_INSERT,
                                                             TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO,
                                                             TOS_LL_DL_BKG_PENDING.PK_TOS_LL_DL_BOOKING_SEQ,
                                                             '3',
                                                             V_ERROR_MSG
                                                             ); --NO DATA FOUND
                     ELSE
                          V_ERROR_MSG := 'WAIT TO FLOW DATA AGAIN';
                          PRE_UPDATE_STATUS_TEMP(V_USER_INSERT,
                                                             TOS_LL_DL_BKG_PENDING.FK_BOOKING_NO,
                                                             TOS_LL_DL_BKG_PENDING.PK_TOS_LL_DL_BOOKING_SEQ,
                                                             '4',
                                                             V_ERROR_MSG
                                                             ); -- WAIT TO FLOW DATA AGAIN
                     END IF;
                 
                 END IF;
             
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

 PROCEDURE PRE_UPDATE_EZLL_VGM (  P_I_BOOKING_NO TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE,
                                                         P_I_DN_EQUIPMENT_NO  TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE,
                                                         P_I_FK_BKG_EQUIPM_DTL TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE,     
                                                         P_I_CATECORY TOS_LL_BOOKED_LOADING.CATEGORY_CODE%TYPE,
                                                         P_I_VGM    TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE,
                                                         P_I_V_USER VARCHAR2,                                         
                                                         P_O_V_MSG OUT VARCHAR2,
                                                         P_O_V_RETURN_STATUS           OUT  NOCOPY     VARCHAR2 
                                                        )
IS
BEGIN
                    UPDATE  TOS_LL_BOOKED_LOADING TOS_LL 
                        SET TOS_LL.CONTAINER_GROSS_WEIGHT = P_I_VGM
                        ,TOS_LL.CATEGORY_CODE = P_I_CATECORY
                        , TOS_LL.RECORD_CHANGE_USER = P_I_V_USER
                        , TOS_LL.RECORD_CHANGE_DATE = SYSDATE
                        WHERE TOS_LL.FK_BOOKING_NO = P_I_BOOKING_NO
                        AND NVL( TOS_LL.DN_EQUIPMENT_NO,'XXX') =  NVL(P_I_DN_EQUIPMENT_NO,'XXX')
                       AND TOS_LL.FK_BKG_EQUIPM_DTL = P_I_FK_BKG_EQUIPM_DTL
                        AND TOS_LL.LOADING_STATUS = 'BK'
                        AND TOS_LL.RECORD_STATUS = 'A'
                        ;
                        
                        P_O_V_RETURN_STATUS := '1';
                        P_O_V_MSG := 'UPD EZLL COMPLETE';
EXCEPTION WHEN OTHERS THEN
      P_O_V_RETURN_STATUS := '2';
       P_O_V_MSG := 'EZLL ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK;
END;                                                        
 PROCEDURE PRE_UPDATE_EZDL_VGM( P_I_BOOKING_NO TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE,
                                                         P_I_DN_EQUIPMENT_NO  TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE,
                                                         P_I_FK_BKG_EQUIPM_DTL TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE,     
                                                         P_I_CATECORY TOS_LL_BOOKED_LOADING.CATEGORY_CODE%TYPE,
                                                         P_I_VGM    TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE,
                                                         P_I_V_USER VARCHAR2,                                         
                                                         P_O_V_MSG OUT VARCHAR2,
                                                         P_O_V_RETURN_STATUS           OUT  NOCOPY     VARCHAR2 
                                                          ) 
IS
--         l_v_dn_port              TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE;
--        l_v_dn_terminal          TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE;
--        TYPE EZLL_RECORD IS RECORD (
--            FK_BOOKING_NO TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE
--            ,FK_LOAD_LIST_ID TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE
--            ,CONTAINER_GROSS_WEIGHT TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT%TYPE
--            ,CATEGORY_CODE TOS_LL_BOOKED_LOADING.CATEGORY_CODE%TYPE
--            ,FK_BKG_EQUIPM_DTL TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE
--            ,FK_BKG_VOYAGE_ROUTING_DTL TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
--        );
 --       CUR_EZLL_ROW      EZLL_RECORD;
--CURSOR CUR_EZLL_BEAN IS
--              SELECT
--                LL.FK_BOOKING_NO
--               ,LL.FK_LOAD_LIST_ID
--               ,LL.CONTAINER_GROSS_WEIGHT
--               ,LL.CATEGORY_CODE
--               ,LL.FK_BKG_EQUIPM_DTL
--               ,LL.FK_BKG_VOYAGE_ROUTING_DTL
--            FROM
--                TOS_LL_BOOKED_LOADING LL
--                WHERE LL.RECORD_CHANGE_USER = p_i_v_user_upd
--                AND LL.FK_BOOKING_NO = p_i_v_booking_no
--                FOR UPDATE NOWAIT;
--BEGIN
--     p_o_v_return_status := '1';
--     
--      OPEN CUR_EZLL_BEAN;
--     LOOP 
--         FETCH CUR_EZLL_BEAN INTO CUR_EZLL_ROW;
--         EXIT WHEN CUR_EZLL_BEAN%NOTFOUND;
--         
--         --Find port and terminal
--          BEGIN
--         
--           SELECT
--            LOL.DN_PORT , LOL.DN_TERMINAL
--          INTO
--            l_v_dn_port  , l_v_dn_terminal
--           FROM
--            TOS_LL_LOAD_LIST LOL
--           WHERE
--            LOL.PK_LOAD_LIST_ID = CUR_EZLL_ROW.FK_LOAD_LIST_ID;
--         END;
--         -- Update ezdl
--         BEGIN
--               UPDATE
--                    TOS_DL_BOOKED_DISCHARGE DL
--                SET
--                     DL.CONTAINER_GROSS_WEIGHT = CUR_EZLL_ROW.CONTAINER_GROSS_WEIGHT
--                    , DL.CATEGORY_CODE =  CUR_EZLL_ROW.CATEGORY_CODE
--                    , DL.RECORD_CHANGE_USER     = p_i_v_user_upd
--                    , DL.RECORD_CHANGE_DATE     = SYSDATE
--                WHERE DL.FK_BOOKING_NO =  CUR_EZLL_ROW.FK_BOOKING_NO
--                    AND DL.FK_BKG_EQUIPM_DTL = CUR_EZLL_ROW.FK_BKG_EQUIPM_DTL 
--                    AND DL.DN_POL = l_v_dn_port
--                    AND DL.DN_POL_TERMINAL = l_v_dn_terminal
--                    AND DL.FK_BKG_VOYAGE_ROUTING_DTL = CUR_EZLL_ROW.FK_BKG_VOYAGE_ROUTING_DTL
--                    AND DL.DISCHARGE_STATUS <> 'DI' 
--                    AND DL.RECORD_STATUS = 'A';
--         END;
--      END LOOP;
   BEGIN   
      
      BEGIN
        UPDATE TOS_DL_BOOKED_DISCHARGE TOS_DL
                SET
                     TOS_DL.CONTAINER_GROSS_WEIGHT = P_I_VGM
                    , TOS_DL.CATEGORY_CODE =  P_I_CATECORY
                    , TOS_DL.RECORD_CHANGE_USER     = P_I_V_USER
                    , TOS_DL.RECORD_CHANGE_DATE     = SYSDATE
                   WHERE TOS_DL.FK_BOOKING_NO = P_I_BOOKING_NO
                       AND NVL( TOS_DL.DN_EQUIPMENT_NO,'XXX') =  NVL(P_I_DN_EQUIPMENT_NO,'XXX')
                       AND TOS_DL.FK_BKG_EQUIPM_DTL = P_I_FK_BKG_EQUIPM_DTL
                       AND TOS_DL.DISCHARGE_STATUS = 'BK' 
                       AND TOS_DL.RECORD_STATUS = 'A';
      END;
      COMMIT;
    P_O_V_RETURN_STATUS := '1';
   --   CLOSE CUR_EZLL_BEAN;
     P_O_V_MSG := 'UPD EZDLCOMPLETE';
      
EXCEPTION WHEN OTHERS THEN
  p_o_v_return_status :='2';      
  P_O_V_MSG := 'EZDL ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK;
END;                                                                                                          
PROCEDURE PRE_UPDATE_STATUS_TEMP(p_i_v_user_ins VARCHAR2,
                                                              p_i_v_booking_no VARCHAR2,     
                                                               p_i_ll_dl_seq INTEGER,
                                                              p_i_v_return_status VARCHAR2,
                                                              p_i_v_return_msg VARCHAR2
                                                              )
IS
    V_RETURN_STATUS VARCHAR2(1 CHAR) := p_i_v_return_status;
BEGIN
      IF V_RETURN_STATUS = '1' THEN
                 UPDATE VASAPPS.TOS_LL_DL_BOOKING
                   SET STATUS='C' --COMPLETE
                    ,ERR_DESC = substr(p_i_v_return_msg, 1, 1000) --p_i_v_return_msg
                      ,RECORD_CHANGE_DATE = SYSDATE
                      ,RECORD_CHANGE_USER = 'SCHEDULE'
                 WHERE FK_BOOKING_NO=p_i_v_booking_no 
              AND PK_TOS_LL_DL_BOOKING_SEQ = p_i_ll_dl_seq;

      ELSIF V_RETURN_STATUS = '2' THEN --Has oracle error
            UPDATE VASAPPS.TOS_LL_DL_BOOKING
                   SET STATUS='E' --ERROR
                      ,ERR_DESC = substr(p_i_v_return_msg, 1, 1000) --p_i_v_return_msg
                      ,RECORD_CHANGE_DATE = SYSDATE
                      ,RECORD_CHANGE_USER = 'SCHEDULE'
              WHERE FK_BOOKING_NO=p_i_v_booking_no 
              AND PK_TOS_LL_DL_BOOKING_SEQ = p_i_ll_dl_seq;
      ELSIF  V_RETURN_STATUS = '3' THEN
            UPDATE VASAPPS.TOS_LL_DL_BOOKING
                   SET STATUS='N' --NO DATA FOUND
                    ,ERR_DESC = substr(p_i_v_return_msg, 1, 1000) --p_i_v_return_msg
                      ,RECORD_CHANGE_DATE = SYSDATE
                      ,RECORD_CHANGE_USER = 'SCHEDULE'
              WHERE FK_BOOKING_NO=p_i_v_booking_no 
              AND PK_TOS_LL_DL_BOOKING_SEQ = p_i_ll_dl_seq;

      ELSE
               UPDATE VASAPPS.TOS_LL_DL_BOOKING
                   SET STATUS='P' --WAIT FOR FLOW DATA AGAIN
                    ,ERR_DESC = substr(p_i_v_return_msg, 1, 1000) --p_i_v_return_msg
                      ,RECORD_CHANGE_DATE = SYSDATE
                      ,RECORD_CHANGE_USER = 'SCHEDULE'
              WHERE FK_BOOKING_NO=p_i_v_booking_no 
              AND PK_TOS_LL_DL_BOOKING_SEQ = p_i_ll_dl_seq;
          VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('PRR_TOS_LL_DL_BOOKING'
                                                    , '-'
                                                    , 'ERROR AFTER PRE_TOS_CREATE_REMOVE_LL_DL'
                                                                              , 'V_BOOKING_NO : ' || V_RETURN_STATUS
                                                                              , 'V_SEQ : ' || p_i_ll_dl_seq 
                                                    , 'ERROR BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    , 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK
                                                    );          
            
          END IF;
          
      COMMIT;
END;                                                              
PROCEDURE PRE_UPDATE_FLAG_EZLL( P_I_FK_PORT TOS_LL_LOAD_LIST.DN_PORT%TYPE,
                                                         P_I_FK_SERVICE TOS_LL_LOAD_LIST.FK_SERVICE%TYPE,
                                                         P_I_FK_VESSEL TOS_LL_LOAD_LIST.FK_VESSEL%TYPE,
                                                         P_I_FK_VOYAGE TOS_LL_LOAD_LIST.FK_VOYAGE%TYPE,
                                                         P_I_FK_DIRECTION TOS_LL_LOAD_LIST.FK_DIRECTION%TYPE,
                                                         P_I_FK_PORT_SEQUENCE_NO TOS_LL_LOAD_LIST.FK_PORT_SEQUENCE_NO%TYPE,
                                                         P_I_BOOKING_NO TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE,
                                                         P_I_DN_EQUIPMENT_NO  TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE,
                                                         P_I_FK_BKG_EQUIPM_DTL TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE,               
                                                         P_I_V_USER VARCHAR2,                                         
                                                         P_O_V_MSG OUT VARCHAR2,
                                                         P_O_V_RETURN_STATUS           OUT  NOCOPY     VARCHAR2 
                                                         )
IS
V_CNT_REC INTEGER;
V_FLAG VARCHAR2(1 CHAR);
pk_n_load_id TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID%TYPE;
V_SEA_LEG_PORT TOS_LL_LOAD_LIST.DN_PORT%TYPE;
BEGIN

    IF P_I_V_USER = 'TRGRT001' THEN
        BEGIN
            SELECT B01.BAPOL
            INTO V_SEA_LEG_PORT
            FROM BKP001 B01
            WHERE B01.BABKNO = P_I_BOOKING_NO;
        END;
    ELSE
        V_SEA_LEG_PORT := P_I_FK_PORT;
    END IF;
   
    BEGIN
       SELECT LL.PK_LOAD_LIST_ID
         INTO pk_n_load_id
        FROM TOS_LL_LOAD_LIST LL,
        BOOKING_VOYAGE_ROUTING_DTL BV --SEA LEG
        WHERE LL.DN_PORT = V_SEA_LEG_PORT
        AND LL.FK_SERVICE = P_I_FK_SERVICE
        AND LL.FK_VESSEL = P_I_FK_VESSEL
        AND LL.FK_VOYAGE=P_I_FK_VOYAGE
        AND LL.FK_DIRECTION =P_I_FK_DIRECTION
        AND LL.FK_PORT_SEQUENCE_NO = P_I_FK_PORT_SEQUENCE_NO
        --AND BV.VOYAGE_SEQNO = 1
        AND BV.BOOKING_NO = P_I_BOOKING_NO
        AND LL.FK_SERVICE = BV.SERVICE
        AND LL.FK_VESSEL =BV.VESSEL 
        AND LL.FK_VOYAGE =BV.VOYNO 
        AND LL.FK_DIRECTION =BV.DIRECTION 
        AND LL.FK_PORT_SEQUENCE_NO = BV.POL_PCSQ 
        AND LL.DN_PORT = BV.LOAD_PORT 
        AND LL.DN_TERMINAL =BV.FROM_TERMINAL 
        AND ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      pk_n_load_id := NULL;
     END;

      IF pk_n_load_id IS NOT NULL THEN
        V_FLAG := 'Y';
      ELSE 
        V_FLAG := 'N';
      END IF;

        BEGIN
                    UPDATE  TOS_LL_BOOKED_LOADING TOS_LL 
                    SET TOS_LL.FIRST_LEG_FLAG = V_FLAG
                    , TOS_LL.RECORD_CHANGE_USER = P_I_V_USER
                    , TOS_LL.RECORD_CHANGE_DATE = SYSDATE
                    WHERE TOS_LL.FK_BOOKING_NO = P_I_BOOKING_NO
                    and TOS_LL.FK_LOAD_LIST_ID           = pk_n_load_id
                    AND TOS_LL.LOADING_STATUS = 'BK'
                    AND TOS_LL.RECORD_STATUS = 'A'
                    ;
                        
                    P_O_V_RETURN_STATUS := '1';
                    P_O_V_MSG := 'COMPLETE';
         EXCEPTION WHEN NO_DATA_FOUND THEN
           P_O_V_RETURN_STATUS := '2';
            P_O_V_MSG := 'NO DATA FOUND';
         END;
EXCEPTION WHEN OTHERS THEN
  P_O_V_RETURN_STATUS := '2';
   P_O_V_MSG := 'ERROR: ' ||  DBMS_UTILITY.FORMAT_ERROR_STACK;
END;
PROCEDURE PRE_CHECK_EXISTING_DATA_BKP001( P_I_FK_PORT TOS_LL_LOAD_LIST.DN_PORT%TYPE,
                                                                 P_I_FK_SERVICE TOS_LL_LOAD_LIST.FK_SERVICE%TYPE,
                                                                 P_I_FK_VESSEL TOS_LL_LOAD_LIST.FK_VESSEL%TYPE,
                                                                 P_I_FK_VOYAGE TOS_LL_LOAD_LIST.FK_VOYAGE%TYPE,
                                                                 P_I_FK_DIRECTION TOS_LL_LOAD_LIST.FK_DIRECTION%TYPE,
                                                                 P_I_FK_PORT_SEQUENCE_NO TOS_LL_LOAD_LIST.FK_PORT_SEQUENCE_NO%TYPE,
                                                                 P_I_BOOKING_NO TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE,
                                                                P_O_CNT_ROW  OUT INTEGER
                                                             )
IS
fk_n_load_id TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE;

BEGIN
 -- 1) FIND load list id
    BEGIN
    SELECT LL.PK_LOAD_LIST_ID
    INTO fk_n_load_id
     FROM TOS_LL_LOAD_LIST LL
        WHERE LL.DN_PORT = P_I_FK_PORT
        AND LL.FK_SERVICE = P_I_FK_SERVICE
        AND LL.FK_VESSEL = P_I_FK_VESSEL
        AND LL.FK_VOYAGE=P_I_FK_VOYAGE
        AND LL.FK_DIRECTION =P_I_FK_DIRECTION
        AND LL.FK_PORT_SEQUENCE_NO = P_I_FK_PORT_SEQUENCE_NO;
    END;
    

   -- Check existing data
   BEGIN
        SELECT COUNT(1)
        INTO  P_O_CNT_ROW
        FROM  TOS_LL_BOOKED_LOADING
        WHERE FK_LOAD_LIST_ID           = fk_n_load_id
        AND   FK_BOOKING_NO             = P_I_BOOKING_NO;
        

   END;
EXCEPTION WHEN OTHERS THEN

    P_O_CNT_ROW := 0;
END;
PROCEDURE  PRE_CHECK_EXISTING_DATA_EZLL( P_I_BOOKING_NO TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE,
                                                                            P_I_DN_EQUIPMENT_NO  TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE,
                                                                             P_I_FK_BKG_EQUIPM_DTL TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE,
                                                                             P_O_CNT_ROW  OUT INTEGER
                                                                         )
IS
BEGIN
               SELECT COUNT(1) 
                INTO P_O_CNT_ROW
                FROM TOS_LL_BOOKED_LOADING TOS_LL
                WHERE TOS_LL.FK_BOOKING_NO = P_I_BOOKING_NO
                AND NVL( TOS_LL.DN_EQUIPMENT_NO,'XXX') =  NVL(P_I_DN_EQUIPMENT_NO,'XXX')
                AND TOS_LL.FK_BKG_EQUIPM_DTL = P_I_FK_BKG_EQUIPM_DTL
                AND TOS_LL.LOADING_STATUS = 'BK'
                AND TOS_LL.RECORD_STATUS = 'A';
EXCEPTION WHEN OTHERS THEN
   P_O_CNT_ROW := 0;              
END;
PROCEDURE  PRE_CHECK_EXISTING_DATA_EZDL( P_I_BOOKING_NO TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE,
                                                                            P_I_DN_EQUIPMENT_NO  TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE,
                                                                             P_I_FK_BKG_EQUIPM_DTL TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE,
                                                                             P_O_CNT_ROW  OUT INTEGER
                                                                         )
IS
BEGIN
               SELECT COUNT(1) 
                INTO P_O_CNT_ROW
                FROM TOS_DL_BOOKED_DISCHARGE TOS_DL
                WHERE TOS_DL.FK_BOOKING_NO = P_I_BOOKING_NO
                AND NVL( TOS_DL.DN_EQUIPMENT_NO,'XXX') =  NVL(P_I_DN_EQUIPMENT_NO,'XXX')
                AND TOS_DL.FK_BKG_EQUIPM_DTL = P_I_FK_BKG_EQUIPM_DTL
                AND TOS_DL.DISCHARGE_STATUS = 'BK'
                AND TOS_DL.RECORD_STATUS = 'A';
EXCEPTION WHEN OTHERS THEN
   P_O_CNT_ROW := 0;              
END;
end PCR_TOS_SYNC_EZLLDL_BOOKING;
/