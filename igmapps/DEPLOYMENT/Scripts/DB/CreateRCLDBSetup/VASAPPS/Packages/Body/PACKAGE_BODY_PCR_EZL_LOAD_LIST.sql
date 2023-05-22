CREATE OR REPLACE PACKAGE BODY VASAPPS."PCR_EZL_LOAD_LIST" 
as
/*-----------------------------------------------------------------------------------------------------------
PRR_UPD_BOOKED_LOAD.sql
- update data from excel
-------------------------------------------------------------------------------------------------------------
Copyright RCL Public Co., Ltd. 2008
-------------------------------------------------------------------------------------------------------------
Author Nipun Sutes 29/11/2011
- Change Log ------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------*/
/**
 * @param p_local_container
 * @param seal_no
 * @param p_con_mlo_ves
 * @param p_con_mlo_voy
 * @param p_mlo_pod1
 * @param p_mlo_pod2
 * @param p_mlo_pod3
 * @param p_place_of_del
 * @param p_tight_con_flag1
 * @param p_tight_con_flag2
 * @param p_tight_con_flag3
 * @param p_EX_MLO_VESSEL
 * @param p_EX_MLO_VOYAGE
 * @param p_crane_type
 * @param p_container_no
 * @param p_booking_no
 * @param p_pol_pod
 * @param p_terminal
 * @param p_update_to_table
 */
procedure PRR_UPD_BOOKED_LOAD(
p_local_container in varchar2
,p_seal_no in varchar2
,p_con_mlo_ves in varchar2
,p_con_mlo_voy in varchar2
,p_mlo_pod1 in varchar2
,p_mlo_pod2 in varchar2
,p_mlo_pod3 in varchar2
,p_place_of_del in varchar2
,p_tight_con_flag1 in varchar2
,p_tight_con_flag2 in varchar2
,p_tight_con_flag3 in varchar2
,p_EX_MLO_VESSEL in varchar2
,p_EX_MLO_VOYAGE in varchar2
,p_crane_type in varchar2
,p_container_no in varchar2
,p_booking_no in varchar2
,p_pol_pod in varchar2
,p_terminal in varchar2
,p_update_to_table in varchar2
)
is
sql_select varchar2(4000);
sql_where varchar2(4000);
sql_update varchar2(4000);

cnt_row number;
column_over_size varchar2(4000):='';
table_name varchar2(50);

not_found_data_ex EXCEPTION;
column_over_size_ex EXCEPTION;
EQ_MORE_THEN_ONE_ex EXCEPTION;
begin
    --dbms_output.put_line('RCLAPPS.PCR_EZL_LOAD_LIST.PRR_UPD_BOOKED_LOAD: Start');
    
    -- update to table
    if p_update_to_table='T1'then
        table_name:=table1;
    elsif p_update_to_table='T2'then
        table_name:=table2;
    end if;
    
    ---------- check size data must not over -------------
    column_over_size:=column_over_size||fr_check_over_size('LOCAL_TERMINAL_STATUS',p_local_container,table_name);
    column_over_size:=column_over_size||fr_check_over_size('MLO_VESSEL',p_con_mlo_ves,table_name);
    column_over_size:=column_over_size||fr_check_over_size('MLO_VOYAGE',p_con_mlo_voy,table_name);
    column_over_size:=column_over_size||fr_check_over_size('MLO_POD1',p_mlo_pod1,table_name);
    column_over_size:=column_over_size||fr_check_over_size('MLO_POD2',p_mlo_pod2,table_name);
    column_over_size:=column_over_size||fr_check_over_size('MLO_POD3',p_mlo_pod3,table_name);
    column_over_size:=column_over_size||fr_check_over_size('MLO_DEL',p_place_of_del,table_name);
    column_over_size:=column_over_size||fr_check_over_size('TIGHT_CONNECTION_FLAG1',p_tight_con_flag1,table_name);
    column_over_size:=column_over_size||fr_check_over_size('TIGHT_CONNECTION_FLAG2',p_tight_con_flag2,table_name);
    column_over_size:=column_over_size||fr_check_over_size('TIGHT_CONNECTION_FLAG3',p_tight_con_flag3,table_name);
    column_over_size:=column_over_size||fr_check_over_size('EX_MLO_VESSEL',p_EX_MLO_VESSEL,table_name);
    column_over_size:=column_over_size||fr_check_over_size('EX_MLO_VOYAGE',p_EX_MLO_VOYAGE,table_name);
    column_over_size:=column_over_size||fr_check_over_size('SEAL_NO',p_SEAL_NO,table_name);
    column_over_size:=column_over_size||fr_check_over_size('CRANE_TYPE',p_crane_type,table_name);
    column_over_size:=column_over_size||fr_check_over_size('TERMINAL',p_terminal,table_name);
    if(nvl(column_over_size,' ')<>' ')then
        column_over_size:=substr(column_over_size,2,length(column_over_size)-1);
    end if;

    if(nvl(column_over_size,' ')<>' ')then
        RAISE column_over_size_ex;
    end if;
    ---------- end check size data must not over -------------

    -- where must have all condition
    if(table_name=table1)then
        sql_where := ' where dn_equipment_NO='''||p_container_no||'''/*container no*/
                        and fk_booking_no='''||p_booking_no||'''/*booking no*/
                        and dn_discharge_port='''||p_pol_pod||'''/*discharge*/
                        and dn_discharge_terminal='''||p_terminal||'''/*discharge terminal*/
                        and rownum=1
                    ';
    elsif(table_name=table2)then
        sql_where := ' where EQUIPMENT_NO='''||p_container_no||'''/*container no*/
        ';
    end if;

   sql_select := 'select count(*) from '||table_name;
   --dbms_output.put_line ('sql select: '|| sql_select||sql_where);
   EXECUTE IMMEDIATE sql_select||sql_where into cnt_row;

   if(cnt_row>0)then
       ---------- update ---------
       if(table_name=table1)then
           sql_update := 'update '||table_name||'
                            set
                            LOCAL_TERMINAL_STATUS=upper('''|| p_local_container ||''')/*Local Container*/,
                            MLO_VESSEL=upper(nvl('''|| p_con_mlo_ves ||''',MLO_Vessel))/*Connecting MLO vessel*/,
                            MLO_VOYAGE=upper(nvl('''|| p_con_mlo_voy || ''',MLO_VOYAGE))/*Connecting MLO voyage*/,
                            MLO_POD1=upper(nvl('''|| p_mlo_pod1 || ''',MLO_POD1))/*MLO POD1*/,
                            MLO_POD2=upper(nvl('''|| p_mlo_pod2 || ''',MLO_POD2))/*MLO POD2*/,
                            MLO_POD3=upper(nvl('''|| p_mlo_pod3 || ''',MLO_POD3))/*MLO POD3*/,
                            MLO_DEL=upper(nvl('''|| p_place_of_del || ''',MLO_DEL))/*Place of delivery*/,
                            TIGHT_CONNECTION_FLAG1=upper(nvl('''|| p_tight_con_flag1 || ''',TIGHT_CONNECTION_FLAG1))/*Tight Connection Flag1*/,
                            TIGHT_CONNECTION_FLAG2=upper(nvl('''|| p_tight_con_flag2 || ''',TIGHT_CONNECTION_FLAG2))/*Tight Connection Flag2*/,
                            TIGHT_CONNECTION_FLAG3=upper(nvl('''|| p_tight_con_flag3 || ''',TIGHT_CONNECTION_FLAG3))/*Tight Connection Flag3*/,
                            EX_MLO_VESSEL=upper(nvl('''|| p_EX_MLO_VESSEL || ''',EX_MLO_VESSEL))/*EX MLO VESSEL*/,
                            EX_MLO_VOYAGE=upper(nvl('''|| p_EX_MLO_VOYAGE || ''',EX_MLO_VOYAGE))/*EX MLO VOYAGE*/,
                            SEAL_NO=upper(nvl('''|| p_SEAL_NO || ''',SEAL_NO))/*SEAL NO*/,
                            CRANE_TYPE=upper(nvl('''||p_CRANE_TYPE||''',CRANE_TYPE))/*CRANE TYPE*/
                        ';
       elsif(table_name=table2 and cnt_row=1)then
             sql_update := 'update '||table_name||'
                            set
                            POD_Terminal=upper(nvl('''|| p_terminal ||''',POD_Terminal))/*terminal*/
                         ';
       elsif table_name=table2 and cnt_row>1 then
            RAISE EQ_MORE_THEN_ONE_ex;
       end if;

       dbms_output.put_line ('sql update: '|| sql_update||sql_where);
       EXECUTE IMMEDIATE sql_update||sql_where;
       ---------- end update ---------

       commit;
    else
       RAISE not_found_data_ex;
    end if;

    --dbms_output.put_line('RCLAPPS.PCR_EZL_LOAD_LIST.PRR_UPD_BOOKED_LOAD: Complete');
    exception
        -- user-defined error messages along with the error number whose range is in between -20000 and -20999.
        when column_over_size_ex then
             raise_application_error(-20001, '###'||column_over_size||' Data over size'||'###');-- '###' is scope for get data
        when not_found_data_ex then
            raise_application_error(-20002, 'Not found data');
        when EQ_MORE_THEN_ONE_ex then
            raise_application_error(-20003, 'Cannot update data because EQUIPMENT_NO have more than one');
        when others then
            RAISE;
end;

/*-----------------------------------------------------------------------------------------------------------
fr_check_over_size.sql
- check over size of data (all if is over size)
-------------------------------------------------------------------------------------------------------------
Copyright RCL Public Co., Ltd. 2008
-------------------------------------------------------------------------------------------------------------
Author Nipun Sutes 29/11/2011
- Change Log ------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------*/
/**
 * @param p_column
 * @param p_data
 * @param p_table_name
 */
function fr_check_over_size(p_column in varchar2,p_data in varchar2,p_table_name in varchar2)return varchar2
is
begin
    if(p_table_name=table1)then
        if(p_column='LOCAL_TERMINAL_STATUS' and length(p_data)>10)then
            return ',LOCAL CONTAINER STATUS';
        elsif(p_column='MLO_VESSEL' and length(p_data)>35)then
            return ',MLO VESSEL';
        elsif(p_column='MLO_VOYAGE' and length(p_data)>10)then
            return ',MLO VOYAGE';
        elsif(p_column='MLO_POD1' and length(p_data)>5)then
            return ',MLO POD1';
        elsif(p_column='MLO_POD2' and length(p_data)>5)then
            return ',MLO POD2';
        elsif(p_column='MLO_POD3' and length(p_data)>5)then
            return ',MLO POD3';
        elsif(p_column='MLO_DEL' and length(p_data)>5)then
            return ',MLO DEL';
        elsif(p_column='TIGHT_CONNECTION_FLAG1' and length(p_data)>1)then
            return ',TIGHT CONNECTION FLAG1';
        elsif(p_column='TIGHT_CONNECTION_FLAG2' and length(p_data)>1)then
            return ',TIGHT CONNECTION FLAG2';
        elsif(p_column='TIGHT_CONNECTION_FLAG3' and length(p_data)>1)then
            return ',TIGHT CONNECTION FLAG3';
        elsif(p_column='EX_MLO_VESSEL' and length(p_data)>5)then
            return ',EX MLO VESSEL';
        elsif(p_column='EX_MLO_VOYAGE' and length(p_data)>20)then
            return ',EX MLO VOYAGE';
        elsif(p_column='SEAL_NO' and length(p_data)>20)then
            return ',SEAL NO';
        elsif(p_column='CRANE_TYPE' and length(p_data)>3)then
            return ',CRANE TYPE';
        end if;
    elsif p_table_name=table2 then
        if(p_column='TERMINAL' and length(p_data)<>5)then
            return ',TERMINAL';
        end if;
    end if;

    return '';
end;

end PCR_EZL_LOAD_LIST;
/
