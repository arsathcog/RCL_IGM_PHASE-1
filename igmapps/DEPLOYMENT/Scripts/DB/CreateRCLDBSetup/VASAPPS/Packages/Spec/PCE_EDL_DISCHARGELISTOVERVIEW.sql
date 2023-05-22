CREATE OR REPLACE PACKAGE "PCE_EDL_DISCHARGELISTOVERVIEW" AS
/* -----------------------------------------------------------------------------
System  : RCL-EZL
Module  : DischargeList
Prog ID : EDL001 - PCV_EDL_DischargeListOverview.sql
Name    : Discharge List Overview
Purpose : Allows to Search Discharge Lists
--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author        Date            What
---------------    ---------------    ------------------------------------------------
Roy      07/01/2011    <Initial version>
--Change Log--------------------------------------------------------------------
DD/MM/YY     User-Task/CR No -Short Description-
----------------------------------------------------------------------------- */


/**

 * @ PRV_EDL_DischargeListOverview
 * Purpose : Search for the List of Discharge Containers from EZLL Discharege table
 * @param  : p_o_refDischargeListOverview
 * @param  : p_i_v_service_grp_cd
 * @param  : p_i_v_service_cd
 * @param  : p_i_v_port_cd
 * @param  : p_i_v_terminal_cd
 * @param  : p_i_v_fsc_cd
 * @param  : p_i_v_vessel_cd
 * @param  : p_i_v_in_voyage_cd
 * @param  : p_i_v_from_eta_dt      (Format : DD/MM/YYYY)
 * @param  : p_i_v_to_eta_dt          (Format : DD/MM/YYYY)
 * @param  : p_i_v_from_ata_dt      (Format : DD/MM/YYYY)
 * @param  : p_i_v_to_ata_dt          (Format : DD/MM/YYYY)
 * @param  : p_i_v_status_cd
 * @param  : p_i_v_sort_by            (Sorting Column Name)
 * @param  : p_i_v_sort_order         (Asc:Asceding or Desc:Descending Order)
 * @param  : p_i_v_view
 * @param  : p_i_v_rec_status        (A:Active or S:Suspended)
 * @param  : p_i_v_curr_page
 * @param  : p_o_v_tot_rec            OutPut
 * @param  : p_i_v_user_id
 * @param  : p_o_v_error              OutPut
 * @return : List of contracts in Ref Cursor
 * @return : p_o_v_error (Output Error Code if Any, Error Code + Error Data)
 * @see    : None
 * @exception None
 * -----------------------------------------------------------------------------
 * Steps/Checks involved :
 * Check A : None
 * -----------------------------------------------------------------------------
*/
PROCEDURE PRE_EDL_DischargeListOverview
                (
                   p_o_refDischargeListOverview     OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                   ,p_i_v_service_grp_cd                 VARCHAR2
                   ,p_i_v_service_cd                     VARCHAR2
                   ,p_i_v_port_cd                          VARCHAR2
                   ,p_i_v_terminal_cd                     VARCHAR2
                   ,p_i_v_fsc_cd                          VARCHAR2
                   ,p_i_v_vessel_cd                        VARCHAR2
                   ,p_i_v_in_voyage_cd                   VARCHAR2
                   ,p_i_v_from_eta_dt                        VARCHAR2
                   ,p_i_v_to_eta_dt                            VARCHAR2
                   ,p_i_v_from_ata_dt                        VARCHAR2
                   ,p_i_v_to_ata_dt                            VARCHAR2
                   ,p_i_v_status_cd                        VARCHAR2
                   ,p_i_v_sort_by                         VARCHAR2
                   ,p_i_v_sort_order                     VARCHAR2
                   ,p_o_v_tot_rec                         OUT VARCHAR2
                   ,p_i_v_is_control_fsc            VARCHAR2
                   ,p_i_v_user_id                   VARCHAR2
                   ,p_o_v_error                           OUT VARCHAR2
                );

END PCE_EDL_DISCHARGELISTOVERVIEW;
/* End of Package Specification */
 
