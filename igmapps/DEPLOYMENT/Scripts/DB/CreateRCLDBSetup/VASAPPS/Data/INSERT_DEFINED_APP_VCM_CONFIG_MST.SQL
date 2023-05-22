declare
v_max_SORT_ORDER number(2); 
begin
    select nvl(max(vcm_in.SORT_ORDER), 0) into v_max_SORT_ORDER from vasapps.VCM_CONFIG_MST vcm_in WHERE CONFIG_TYP = 'DEFINED_APP_SERVER';
    
    /********************* LOCAL MACHINE ********************/
    insert into vasapps.VCM_CONFIG_MST(
        SORT_ORDER
        ,CONFIG_TYP
        ,CONFIG_CD
        ,CONFIG_VALUE
        ,CONFIG_DESC
        ,MAX_SIZE_CONFIG_VALUE
        ,FIX_LENGTH
        ,DISPLAY_FLAG    
        ,STATUS
        ,CREATE_BY    
        ,CREATE_DT
        ,UPD_BY    
        ,UPD_DT
        ,MODULE
        ,USAGE_REMARK
        )
    values(
        v_max_SORT_ORDER+1
        ,'DEFINED_APP_SERVER'
        ,'DEFINED_APP_SERVER_LOCAL'
        ,'10.2.5.42'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER LOCAL MACHINE'
        ,99999
        ,'N'
        ,'N'    
        ,'A'
        ,'EZLL'    
        ,sysdate
        ,'NUTTHA1'    
        ,sysdate
        ,'EZLL'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER LOCAL MACHINE'
    );
    /********************* LOCAL MACHINE ********************/
    
    /********************* DEV SERVER ********************/    
    insert into vasapps.VCM_CONFIG_MST(
        SORT_ORDER
        ,CONFIG_TYP
        ,CONFIG_CD
        ,CONFIG_VALUE
        ,CONFIG_DESC
        ,MAX_SIZE_CONFIG_VALUE
        ,FIX_LENGTH
        ,DISPLAY_FLAG    
        ,STATUS
        ,CREATE_BY    
        ,CREATE_DT
        ,UPD_BY    
        ,UPD_DT
        ,MODULE
        ,USAGE_REMARK
        )
    values(
        v_max_SORT_ORDER+2
         ,'DEFINED_APP_SERVER'
        ,'DEFINED_APP_SERVER_DEV'
        ,'10.0.3.47'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER DEV MACHINE'
        ,99999
        ,'N'
        ,'N'    
        ,'A'
        ,'EZLL'    
        ,sysdate
        ,'NUTTHA1'    
        ,sysdate
        ,'EZLL'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER DEV MACHINE'
    );
    /********************* DEV SERVER ********************/ 
    
    /********************* UAT SERVER ********************/ 
    insert into vasapps.VCM_CONFIG_MST(
        SORT_ORDER
        ,CONFIG_TYP
        ,CONFIG_CD
        ,CONFIG_VALUE
        ,CONFIG_DESC
        ,MAX_SIZE_CONFIG_VALUE
        ,FIX_LENGTH
        ,DISPLAY_FLAG    
        ,STATUS
        ,CREATE_BY    
        ,CREATE_DT
        ,UPD_BY    
        ,UPD_DT
        ,MODULE
        ,USAGE_REMARK
        )
    values(
        v_max_SORT_ORDER+3
        ,'DEFINED_APP_SERVER'
        ,'DEFINED_APP_SERVER_UAT'
        ,'10.0.3.35'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER UAT MACHINE'
        ,99999
        ,'N'
        ,'N'    
        ,'A'
        ,'EZLL'    
        ,sysdate
        ,'NUTTHA1'    
        ,sysdate
        ,'EZLL'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER UAT MACHINE'
    );
    /********************* UAT SERVER ********************/ 
    
    /********************* STG SERVER ********************/ 
    insert into vasapps.VCM_CONFIG_MST(
        SORT_ORDER
        ,CONFIG_TYP
        ,CONFIG_CD
        ,CONFIG_VALUE
        ,CONFIG_DESC
        ,MAX_SIZE_CONFIG_VALUE
        ,FIX_LENGTH
        ,DISPLAY_FLAG    
        ,STATUS
        ,CREATE_BY    
        ,CREATE_DT
        ,UPD_BY    
        ,UPD_DT
        ,MODULE
        ,USAGE_REMARK
        )
    values(
        v_max_SORT_ORDER+4
         ,'DEFINED_APP_SERVER'
        ,'DEFINED_APP_SERVER_STG'
        ,'10.0.5.22'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER STG MACHINE'
        ,99999
        ,'N'
        ,'N'    
        ,'A'
        ,'EZLL'    
        ,sysdate
        ,'NUTTHA1'    
        ,sysdate
        ,'EZLL'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER STG MACHINE'
    );
    /********************* STG SERVER ********************/ 
    
    /********************* PROD SERVER ********************/ 
    insert into vasapps.VCM_CONFIG_MST(
        SORT_ORDER
        ,CONFIG_TYP
        ,CONFIG_CD
        ,CONFIG_VALUE
        ,CONFIG_DESC
        ,MAX_SIZE_CONFIG_VALUE
        ,FIX_LENGTH
        ,DISPLAY_FLAG    
        ,STATUS
        ,CREATE_BY    
        ,CREATE_DT
        ,UPD_BY    
        ,UPD_DT
        ,MODULE
        ,USAGE_REMARK
        )
    values(
        v_max_SORT_ORDER+5
         ,'DEFINED_APP_SERVER'
        ,'DEFINED_APP_SERVER_PROD'
        ,'10.0.5.25'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER PROD MACHINE'
        ,99999
        ,'N'
        ,'N'    
        ,'A'
        ,'EZLL'    
        ,sysdate
        ,'NUTTHA1'    
        ,sysdate
        ,'EZLL'
        ,'IP SERVER FOR DEFINED APPLICATION SERVER PROD MACHINE'
    );    
    /********************* PROD SERVER ********************/ 
    
    commit;
end;
