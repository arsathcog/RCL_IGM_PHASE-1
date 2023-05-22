CREATE OR REPLACE PACKAGE BODY                 PCE_ECM_MasterLookup AS
 
  /* Begin of PRE_ECM_MasterConfig */
  PROCEDURE PRE_ECM_MasterConfig (
                                   p_i_v_master_cd                   VARCHAR2
                                   ,p_o_v_master_name            OUT VARCHAR2
                                   ,p_o_v_list_name              OUT VARCHAR2
                                   ,p_o_findin_field_cd          OUT VARCHAR2
                                   ,p_o_findin_field_desc        OUT VARCHAR2
                                   ,p_o_sortby_field_cd          OUT VARCHAR2
                                   ,p_o_sortby_field_desc        OUT VARCHAR2
                                   ,p_o_no_column                OUT NUMBER
                                   ,p_o_column_name              OUT VARCHAR2
                                   ,p_o_v_error                  OUT VARCHAR2
                                 )
  IS
  BEGIN
      p_o_v_error := '000000';
      
      /* Construct the SQL */
      SELECT  MASTER_NAME
             ,LIST_NAME     
             ,FINDIN_FIELD_CD
             ,FINDIN_FIELD_DESC
             ,SORTBY_FIELD_CD
             ,SORTBY_FIELD_DESC
             ,NO_OF_COLUMN             
             ,COLUMN_NAME 
    
      INTO    p_o_v_master_name
              ,p_o_v_list_name
              ,p_o_findin_field_cd
              ,p_o_findin_field_desc
              ,p_o_sortby_field_cd
              ,p_o_sortby_field_desc
              ,p_o_no_column
              ,p_o_column_name
      FROM    ECM_LOOKUP_CONFIG_MST
      WHERE   MASTER_CD = p_i_v_master_cd                       ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN                
          p_o_v_error                   := 'ECM.GE0004'         ;
      WHEN OTHERS THEN                
          p_o_v_error                   := SUBSTR(SQLCODE,1,10) ;
  END PRE_ECM_MasterConfig;
  /* End of PRV_VCM_MasterConfig */
  
  /* Begin of PRE_ECM_MasterResultList */
  PROCEDURE PRE_ECM_MasterResultList (
                                      p_o_ref_MasterResultData       OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                      ,p_i_v_master_cd               VARCHAR2
                                      ,p_i_v_pre_criteria_val        VARCHAR2
                                      ,p_i_v_find_val                VARCHAR2
                                      ,p_i_v_find_in                 VARCHAR2
                                      ,p_i_v_wild_card               VARCHAR2
                                      ,p_i_v_sort_by                 VARCHAR2
                                      ,p_i_v_sort_in                 VARCHAR2     
                                      ,p_i_v_status                  VARCHAR2      
                                      ,p_i_v_curr_page               VARCHAR2
                                      ,p_i_v_order_by                VARCHAR2
                                      ,p_i_v_asc_desc                VARCHAR2
                                      ,p_o_v_tot_rec                 OUT VARCHAR2
                                      ,p_o_v_error                   OUT VARCHAR2
                                    )
  IS
        /*Variable to store SQL*/
        l_mst_sql_select     VARCHAR2(32000)         ;
        l_sql_select_status  VARCHAR2(30000)         ;
        l_sql_final          VARCHAR2(10000)         ;
        l_sql_select_find    VARCHAR2(10000)         ; 
        l_sql_sort           VARCHAR2(10000)         ;
        l_v_pre_sql          VARCHAR2(10000)         ;
        l_v_pre_condition    VARCHAR2(100)           ;
        l_v_pre_criteria_val VARCHAR2(100)           ; 
        l_n_count_param      NUMBER                  ;
        l_v_param_col        VARCHAR2(100)           ; 
        l_n_count_param_val  NUMBER                  ;
        l_v_param_val        VARCHAR2(100)           ;
        l_v_single_quote     VARCHAR2(1) := CHR(39)  ;
        l_v_single_space     VARCHAR2(1) := ' '      ;
        l_v_seperator        VARCHAR2(1) := '~'      ;
        l_v_blank            VARCHAR2(2) := ''       ;        
        l_v_find_val         VARCHAR2(50)            ; 
        l_v_sort_by          VARCHAR2(50)            ;
        l_v_wild_card_opr    VARCHAR2(10)            ;
        
 
        
  BEGIN   
 
      p_o_v_error := '000000';
      p_o_v_tot_rec := '-1'  ;
      
      /* SQL to fetch the master SQL and the precondition val.*/
      BEGIN 
         
             
          SELECT MASTER_SQL          ,
                 PRE_CONDITION 
          INTO   l_mst_sql_select    ,
                 l_v_pre_condition
          FROM   ECM_LOOKUP_CONFIG_MST
          WHERE  MASTER_CD = p_i_v_master_cd ;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN                
              p_o_v_error   := 'ECM.GE0004'          ;
              RETURN;
          WHEN OTHERS THEN                
              p_o_v_error  := SUBSTR(SQLCODE,1,10)   ;
        RETURN                                       ;
      END;
      
         /* Construct the SQL */ 
         
         IF SUBSTR(l_mst_sql_select,LENGTH(l_mst_sql_select),1) <> '=' THEN 
             l_sql_select_status:=l_mst_sql_select;
         ELSE
             
         IF p_i_v_status <> PCE_EUT_COMMON.G_V_STATUS_ALL THEN 
             l_sql_select_status := l_mst_sql_select || l_v_single_quote ||p_i_v_status || l_v_single_quote;
         ELSE 
           
             l_sql_select_status := l_mst_sql_select || SUBSTR(l_mst_sql_select,INSTR(l_mst_sql_select,' ', -1)+1,
                                           LENGTH(SUBSTR(l_mst_sql_select, INSTR(l_mst_sql_select,' ', -1)+1))-1);
         END IF;
         END IF;
         
         l_v_pre_criteria_val := p_i_v_pre_criteria_val || l_v_seperator ;
         l_v_pre_condition    := l_v_pre_condition      || l_v_seperator ;
         l_v_find_val         := p_i_v_find_val                          ; 
         l_v_sort_by          := p_i_v_sort_by                           ;
         
          IF (p_i_v_master_cd = PCE_EUT_COMMON.G_V_ID_PRINT_ID) THEN
              l_sql_final := l_sql_select_status || ' AND (FSC IS NULL OR FSC =' || l_v_single_quote ||  PCE_EUT_COMMON.FN_EUT_GET_USER_FSC(p_i_v_pre_criteria_val) || l_v_single_quote ||' )'  ;
          ELSE     
               /*Fetch the precondition column and its value seperated by '~' */
               WHILE INSTR (l_v_pre_condition, l_v_seperator) <> 0 
               LOOP
                   l_n_count_param      := INSTR(l_v_pre_condition,l_v_seperator)               ;
                   l_v_param_col        := SUBSTR(l_v_pre_condition,1,l_n_count_param-1)        ;
                   l_v_pre_condition    := SUBSTR(l_v_pre_condition,l_n_count_param+1)          ;
                   l_n_count_param_val  := INSTR(l_v_pre_criteria_val,l_v_seperator)            ;
                   l_v_param_val        := SUBSTR(l_v_pre_criteria_val,1,l_n_count_param_val-1) ;
                   l_v_pre_criteria_val := SUBSTR(l_v_pre_criteria_val,l_n_count_param_val+1)   ;

                   IF l_v_param_val IS NOT NULL THEN
                      l_v_pre_sql := l_v_pre_sql || ' AND '|| l_v_param_col || ' = NVL(' || l_v_single_quote || l_v_param_val || l_v_single_quote || ', ' || l_v_param_col || ')';
                   END IF;
               END LOOP; 

               l_sql_final := l_sql_select_status || l_v_pre_sql ;

               IF (p_i_v_master_cd = PCE_EUT_COMMON.G_V_ID_CONTRACT) THEN
                  l_sql_final := l_sql_final || ' ) ' ;
              END IF ;
         END IF ;
        
     /* Wild Card checks
        0 (all)   --> Same as Contains ex. Like '%Debasis%'
        1 (exact) --> No Like Operator
        2 (front) --> Same as Starts with ex. Like 'Debasis%'
        3 (back)  --> Same as Ends with ex. Like '%Debasis'  
      */
      
      IF p_i_v_wild_card = '0' THEN
          l_v_wild_card_opr := ' LIKE ' ;
          l_v_find_val      := '%'||l_v_find_val||'%'  ;

      ELSIF p_i_v_wild_card = '1' THEN
          l_v_wild_card_opr := ' = '  ;
          l_v_find_val      := l_v_find_val ;

      ELSIF p_i_v_wild_card = '2' THEN
          l_v_wild_card_opr := ' LIKE ' ;
          l_v_find_val      := l_v_find_val||'%'  ;

      ELSIF p_i_v_wild_card = '3' THEN
          l_v_wild_card_opr := ' LIKE ' ;
          l_v_find_val      := '%'||l_v_find_val  ;
      END IF;

      IF p_i_v_find_in IS NOT NULL THEN
          IF (p_i_v_master_cd = PCE_EUT_COMMON.G_V_ID_CONTRACT) THEN
              l_sql_select_find := l_sql_final || ' WHERE UPPER( '|| p_i_v_find_in ||' )' 
                               || l_v_wild_card_opr || ' UPPER(' || l_v_single_quote || l_v_find_val || l_v_single_quote || ')';
          ELSE
              l_sql_select_find := l_sql_final || ' AND UPPER( '|| p_i_v_find_in ||' )' 
                               || l_v_wild_card_opr || ' UPPER(' || l_v_single_quote || l_v_find_val || l_v_single_quote || ')';
          END IF ;
      ELSE
          l_sql_select_find := l_sql_final  ;
      END IF ;
        
      IF p_i_v_order_by IS NOT NULL THEN
          l_sql_sort  := l_sql_select_find || ' ORDER BY ' || p_i_v_order_by ||' '|| p_i_v_asc_desc ;
      ELSIF l_v_sort_by IS NULL THEN         
          l_sql_sort  := l_sql_select_find || ' ORDER BY 1' ;
      ELSE
          l_sql_sort  := l_sql_select_find || ' ORDER BY ' || p_i_v_sort_by || ' ' || p_i_v_sort_in ;
      END IF;

    
    IF instr(l_sql_sort,' WHERE ') = 0 THEN
        IF instr(l_sql_sort,' AND ') > 0 THEN
           l_sql_sort := REGEXP_REPLACE(l_sql_sort,' AND ',' WHERE ',1,1) ; 
        END IF;
    END IF;
     
     
      /* Execute the SQL */
      OPEN p_o_ref_MasterResultData FOR l_sql_sort ;
  EXCEPTION
      WHEN OTHERS THEN
          p_o_v_error  := SUBSTR(SQLCODE,1,10)     ;
          INSERT INTO ecm_log_trace VALUES('ECM',p_o_v_error,'A','ECM',SYSDATE,'ECM',SYSDATE);
        RETURN;

  END PRE_ECM_MasterResultList;
  /* End of PRE_ECM_MasterResultList */

END PCE_ECM_MasterLookup;

/
