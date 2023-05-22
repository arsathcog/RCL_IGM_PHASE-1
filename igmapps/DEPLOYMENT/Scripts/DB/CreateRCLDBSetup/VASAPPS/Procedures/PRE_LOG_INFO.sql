CREATE OR REPLACE PROCEDURE PRE_LOG_INFO
    ( 
         p_cal_from   IN   VARCHAR2
       , p_calling    IN   VARCHAR2
       , p_seq_id     IN   VARCHAR2
       , p_cal_by     IN   VARCHAR2
       , p_cal_time   IN   TIMESTAMP
       , p_remarks    IN   VARCHAR2
       , p_var_name   IN   STRING_ARRAY
       , p_var_value  IN   STRING_ARRAY
       , p_var_io     IN   STRING_ARRAY
    ) AS
    
    l_n_header_id       NUMBER;
    
    PRAGMA AUTONOMOUS_TRANSACTION;
    
    BEGIN
           SELECT SE_LOG_HED.NEXTVAL
           INTO   l_n_header_id
           FROM   DUAL;

           INSERT INTO TOS_LOG_INFO_HEADER 
             (  PK_LOG_INFO_HEADER_ID
              , CALLED_FROM
              , CALLING
              , SEQ_ID
              , REMARKS
              , RECORD_ADD_USER
              , RECORD_ADD_DATE
             )
           VALUES 
             (  l_n_header_id
              , p_cal_from
              , p_calling
              , p_seq_id
              , p_remarks
              , p_cal_by
              , p_cal_time
              );

           IF p_var_name IS NOT NULL THEN
               FOR i in 1..p_var_name.COUNT
               LOOP

                  INSERT INTO TOS_LOG_INFO_DETAIL 
                    (  PK_LOG_INFO_DETAIL_ID
                     , FK_LOG_INFO_HEADER_ID
                     , VARIABLE_NAME
                     , VARIABLE_VALUE
                     , VARIABLE_IO
                    )
                  VALUES 
                    (  SE_LOG_DET.NEXTVAL
                     , l_n_header_id
                     , p_var_name(i)
                     , p_var_value(i)
                     , DECODE(p_var_io(1),NULL,NULL,p_var_io(i))
                     );

               END LOOP;
           END IF;
               
           COMMIT;            
    END PRE_LOG_INFO;
/
