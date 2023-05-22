CREATE OR REPLACE PACKAGE VASAPPS."PCR_EZL_LOAD_LIST" 
as
/*-----------------------------------------------------------------------------------------------------------
  Declare variables
  -----------------------------------------------------------------------------------------------------------*/
table1 varchar2(50):='VASAPPS.tos_ll_booked_loading';
table2 varchar2(50):='vasapps.tos_ll_overshipped_container';
/*-----------------------------------------------------------------------------------------------------------

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
);

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
function fr_check_over_size(p_column in varchar2,p_data in varchar2,p_table_name in varchar2)return varchar2;

end PCR_EZL_LOAD_LIST;
/
