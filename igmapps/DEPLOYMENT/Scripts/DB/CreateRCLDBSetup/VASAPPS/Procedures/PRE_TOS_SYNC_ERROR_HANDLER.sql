create or replace PROCEDURE PRE_TOS_SYNC_ERROR_HANDLER AS
/********************************************************************************
* Name           : PRE_TOS_SYNC_ERROR_HANDLER                                   *
* Module         : EZLL                                                         *
* Purpose        : This  Stored  Procedure is used to call procedures which is  *
                   not successfully executed .
* Calls          : PRE_TOS_CREATE_REMOVE_LL_DL                                  *
*                : PRE_TOS_EQUIPMENT_REMOVE                                     *
*                : PRE_TOS_UPDATE_DG                                            *
*                : PRE_TOS_ROUTING_UPDATE                                       *
*                : PRE_TOS_EQUIPMENT_ADD                                        *
*                : PRE_TOS_EQUIPMENT_UPDATE                                     *
* Returns        : NONE                                                         *
* Steps Involved :                                                              *
* History        : None                                                         *
* Author           Date          What                                           *
* ---------------  ----------    ----                                           *
* Avdhesh          20/01/2011     1.0                                           *
* *1: vikas, pass user name also in equipment update procedure calling
*********************************************************************************/

  p_i_v_booking_no                                 BKP001.BABKNO%TYPE;
  p_i_v_imo_class                                  BOOKING_DG_COMM_DETail.IMO_CLASS%TYPE;
  p_i_v_un_no                                      BOOKING_DG_COMM_DETail.UN_NO%TYPE;
  p_i_v_fumigation_only                            BOOKING_DG_COMM_DETAIL.FUMIGATION_YN%TYPE;
  p_i_v_residue                                    BOOKING_DG_COMM_DETAIL.RESIDUE%TYPE;
  p_i_n_humidity                                   BOOKING_RFR_COMM_DEtail.HUMIDITY%TYPE;
  p_i_n_ventilation                                BOOKING_RFR_COMM_DEtail.VENTILATION%TYPE;
  p_i_n_voyage_seq_no                              BOOKING_VOYAGE_ROUTing_dtl.VOYAGE_SEQNO%TYPE;
  p_i_v_old_service                                BOOKING_VOYAGE_ROUTing_dtl.SERVICE%TYPE;
  p_i_v_new_service                                BOOKING_VOYAGE_ROUTing_dtl.SERVICE%TYPE;
  p_i_v_old_vessel                                 BOOKING_VOYAGE_ROUTing_dtl.VESSEL%TYPE;
  p_i_v_new_vessel                                 BOOKING_VOYAGE_ROUTing_dtl.VESSEL%TYPE;
  p_i_v_old_voyage                                 BOOKING_VOYAGE_ROUTing_dtl.VOYNO%TYPE;
  p_i_v_new_voyage                                 BOOKING_VOYAGE_ROUTing_dtl.VOYNO%TYPE;
  p_i_v_old_direction                              BOOKING_VOYAGE_ROUTing_dtl.DIRECTION%TYPE;
  p_i_v_new_direction                              BOOKING_VOYAGE_ROUTing_dtl.DIRECTION%TYPE;
  p_i_v_old_load_port                              BOOKING_VOYAGE_ROUTing_dtl.LOAD_PORT%TYPE;
  p_i_v_new_load_port                              BOOKING_VOYAGE_ROUTing_dtl.LOAD_PORT%TYPE;
  p_i_n_old_pol_pcsq                               BOOKING_VOYAGE_ROUTing_dtl.POL_PCSQ%TYPE;
  p_i_n_new_pol_pcsq                               BOOKING_VOYAGE_ROUTing_dtl.POL_PCSQ%TYPE;
  p_i_v_old_discharge_port                         BOOKING_VOYAGE_ROUTing_dtl.DISCHARGE_PORT%TYPE;
  p_i_v_new_discharge_port                         BOOKING_VOYAGE_ROUTing_dtl.DISCHARGE_PORT%TYPE;
  p_i_v_record_status                              BOOKING_VOYAGE_ROUTing_dtl.RECORD_STATUS%TYPE;
  p_i_n_equipment_seq_no                           BKP009.BISEQN%TYPE;
  p_i_v_old_equipment_no                           BKP009.BICTRN%TYPE;
  p_i_v_new_equipment_no                           BKP009.BICTRN%TYPE;
  p_i_n_overheight                                 BKP009.BIXHGT%TYPE;
  p_i_n_overlength_rear                            BKP009.BIXLNB%TYPE;
  p_i_n_overlength_front                           BKP009.BIXLNF%TYPE;
  p_i_n_overwidth_left                             BKP009.BIXWDL%TYPE;
  p_i_n_overwidth_right                            BKP009.BIXWDR%TYPE;
  p_i_v_un_var                                     BKP009.UN_VARIANT%TYPE;
  p_i_v_flash_point                                BKP009.BIFLPT%TYPE;
  p_i_n_flash_unit                                 BKP009.BIFLBS%TYPE;
  p_i_n_reefer_tmp                                 BKP009.BIRFFM%TYPE;
  p_i_v_reefer_tmp_unit                            BKP009.BIRFBS%TYPE;
  p_i_v_imdg                                       BKP009.BIIMCL%TYPE;
  p_i_v_unno                                       BKP009.BIUNN%TYPE;
  p_i_v_booking_type                               BKP001.BOOKING_TYPE%TYPE;
  p_i_v_old_booking_status                         BKP001.BASTAT%TYPE;
  p_i_v_new_booking_status                         BKP001.BASTAT%TYPE;
  p_i_v_ventilation                                BKP009.CONTROLLED_ATM%TYPE;
  p_i_n_size_type_seq_no                           BKP032.EQP_SIZETYPE_SEQNO%TYPE;
  p_i_n_supplier_seq_no                            BKP009.SUPPLIER_SQNO%TYPE;
  p_i_v_old_act_service                            BOOKING_VOYAGE_ROUTING_DTL.ACT_SERVICE_CODE%TYPE;
  p_i_v_new_act_service                            BOOKING_VOYAGE_ROUTING_DTL.ACT_SERVICE_CODE%TYPE;
  p_i_v_old_act_vessel                             BOOKING_VOYAGE_ROUTING_DTL.ACT_VESSEL_CODE%TYPE;
  p_i_v_new_act_vessel                             BOOKING_VOYAGE_ROUTING_DTL.ACT_VESSEL_CODE%TYPE;
  p_i_v_old_act_voyage                             BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER%TYPE;
  p_i_v_new_act_voyage                             BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER%TYPE;
  p_i_v_old_act_port_direction                     BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_DIRECTION%TYPE;
  p_i_v_new_act_port_direction                     BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_DIRECTION%TYPE;
  p_i_n_old_act_port_seq                           BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_SEQUENCE%TYPE;
  p_i_n_new_act_port_seq                           BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_SEQUENCE%TYPE;
  p_i_v_old_to_terminal                            BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;
  p_i_v_new_to_terminal                            BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;
    p_i_v_old_from_terminal                        BOOKING_VOYAGE_ROUTING_DTL.FROM_TERMINAL%TYPE;
    p_i_v_new_from_terminal                        BOOKING_VOYAGE_ROUTING_DTL.FROM_TERMINAL%TYPE;


  /* start added by vikas for tos_onboard_list */
  p_i_v_weight                                     TOS_ONBOARD_LIST.WEIGHT%TYPE;
  p_i_v_rftemp                                     TOS_ONBOARD_LIST.RFTEMP%TYPE;
  p_i_v_unit                                       TOS_ONBOARD_LIST.UNIT%TYPE;
  p_i_v_imdg_tos                                   TOS_ONBOARD_LIST.IMDG%TYPE;
  p_i_v_unno_tos                                   TOS_ONBOARD_LIST.UNNO%TYPE;
  p_i_v_variant                                    TOS_ONBOARD_LIST.VARIANT%TYPE;
  p_i_v_flash_pt                                   TOS_ONBOARD_LIST.FLASH_PT%TYPE;
  p_i_v_flash_pt_unit                              TOS_ONBOARD_LIST.FLASH_PT_UNIT%TYPE;
  p_i_v_port_class                                 TOS_ONBOARD_LIST.PORT_CLASS%TYPE;
  p_i_v_oog_oh                                     TOS_ONBOARD_LIST.OOG_OH%TYPE;
  p_i_v_oog_olf                                    TOS_ONBOARD_LIST.OOG_OLF%TYPE;
  p_i_v_oog_olb                                    TOS_ONBOARD_LIST.OOG_OLB%TYPE;
  p_i_v_oog_owr                                    TOS_ONBOARD_LIST.OOG_OWR%TYPE;
  p_i_v_oog_owl                                    TOS_ONBOARD_LIST.OOG_OWL%TYPE;
  p_i_v_stow_position                              TOS_ONBOARD_LIST.STOW_POSITION%TYPE;
  p_i_v_container_operator                         TOS_ONBOARD_LIST.CONTAINER_OPERATOR%TYPE;
  p_i_v_out_slot_operator                          TOS_ONBOARD_LIST.OUT_SLOT_OPERATOR%TYPE;
  p_i_v_han1                                       TOS_ONBOARD_LIST.HAN1%TYPE;
  p_i_v_han2                                       TOS_ONBOARD_LIST.HAN2%TYPE;
  p_i_v_han3                                       TOS_ONBOARD_LIST.HAN3%TYPE;
  p_i_v_clr1                                       TOS_ONBOARD_LIST.CLR1%TYPE;
  p_i_v_clr2                                       TOS_ONBOARD_LIST.CLR2%TYPE;
  p_i_v_connecting_vessel                          TOS_ONBOARD_LIST.CONNECTING_VESSEL%TYPE;
  p_i_v_connecting_voyage_no                       TOS_ONBOARD_LIST.CONNECTING_VOYAGE_NO%TYPE;
  p_i_v_next_pod1                                  TOS_ONBOARD_LIST.NEXT_POD1%TYPE;
  p_i_v_next_pod2                                  TOS_ONBOARD_LIST.NEXT_POD2%TYPE;
  p_i_v_next_pod3                                  TOS_ONBOARD_LIST.NEXT_POD3%TYPE;
  p_i_v_tight_conn_flag                            TOS_ONBOARD_LIST.TIGHT_CONN_FLAG%TYPE;
  p_i_v_void_slot                                  TOS_ONBOARD_LIST.VOID_SLOT%TYPE;
  p_i_v_list_status                                TOS_ONBOARD_LIST.LIST_STATUS%TYPE;
  p_i_v_soc_coc                                    TOS_ONBOARD_LIST.SOC_COC%TYPE;
  p_i_v_service                                    TOS_ONBOARD_LIST.POL_SERVICE%TYPE;
  p_i_v_vessel                                     TOS_ONBOARD_LIST.POL_VESSEL%TYPE;
  p_i_v_voyage                                     TOS_ONBOARD_LIST.POL_VOYAGE%TYPE;
  p_i_v_direction                                  TOS_ONBOARD_LIST.POL_DIR%TYPE;
  p_i_v_pod                                        TOS_ONBOARD_LIST.POD%TYPE;
  p_i_v_pod_trm                                    TOS_ONBOARD_LIST.POD_TERMINAL%TYPE;
  p_i_v_pol                                        TOS_ONBOARD_LIST.POL%TYPE;
  p_i_v_pol_trm                                    TOS_ONBOARD_LIST.POL_TERMINAL%TYPE;
  p_i_v_booking                                    TOS_ONBOARD_LIST.BOOKING_NO%TYPE;
  p_i_v_equipment_no                               TOS_ONBOARD_LIST.CONTAINER_NO%TYPE;
  p_i_v_pot                                        TOS_ONBOARD_LIST.POT_PORT%TYPE;

  p_i_v_eqsize                                     TOS_ONBOARD_LIST.EQSIZE%TYPE             ;
  p_i_v_eqtype                                     TOS_ONBOARD_LIST.EQTYPE%TYPE             ;
  p_i_v_full_mt                                    TOS_ONBOARD_LIST.FULL_MT%TYPE            ;
  p_i_v_slot_operator                              TOS_ONBOARD_LIST.SLOT_OPERATOR%TYPE      ;
  p_i_v_final_destination                          TOS_ONBOARD_LIST.FINAL_DESTINATION%TYPE  ;
  p_i_v_local_ts                                   TOS_ONBOARD_LIST.LOCAL_TS%TYPE           ;


  /* end  added by vikas for tos_onboard_list */
  p_o_v_return_status                              VARCHAR2(1);
  sql_id                                           VARCHAR2(200);
  p_l_start_pos                                    NUMBER;
  p_l_end_pos                                      NUMBER;
  p_l_str                                          VARCHAR2(2000);
  p_l_rem_str                                      VARCHAR2(2000);
  l_d_time                                         TIMESTAMP;
BEGIN
  l_d_time := CURRENT_TIMESTAMP;

  FOR i in (SELECT  DISTINCT
                    PARAMETER_STRING
                  , PROG_TYPE
                  , OPEARTION_TYPE
                  , ERROR_MSG
            FROM TOS_SYNC_ERROR_LOG
            WHERE RECORD_STATUS = 'A'
              AND RERUN_STATUS  = 0
              AND NVL(OPEARTION_TYPE,'1') != '1'  -- 1 Means non Syncronization Error Operation Type
            )
  LOOP
  --  sql_id := 1;
  -- Added by Bindu on 04/02/2011.
    IF i.PROG_TYPE='BKP001' THEN
       p_l_rem_str      := i.PARAMETER_STRING;

       p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
       p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
       p_i_v_booking_no := p_l_str;

       p_l_str             := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
       p_l_rem_str         := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
       p_i_v_booking_type  := p_l_str;

       p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
       p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
       p_i_v_old_booking_status      := p_l_str;

       p_i_v_new_booking_status      := p_l_rem_str;

       PCE_ECM_SYNC_BOOKING_EZLL.g_v_err_handler_flg := 'Y';
       PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_CREATE_REMOVE_LL_DL(p_i_v_booking_no
                                                           , p_i_v_booking_type
                                                           , p_i_v_old_booking_status
                                                           , p_i_v_new_booking_status
                                                           , p_o_v_return_status
                                                            );
       end if;

 --   sql_id := 3;
    if i.PROG_TYPE='DG' THEN
      p_l_rem_str      := i.PARAMETER_STRING;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_booking_no := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_imo_class  := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_un_no      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_fumigation_only  := p_l_str;

      p_i_v_residue    := p_l_rem_str;

      PCE_ECM_SYNC_BOOKING_EZLL.g_v_err_handler_flg := 'Y';
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_UPDATE_DG( p_i_v_booking_no ,
                                                   p_i_v_imo_class ,
                                                   p_i_v_un_no ,
                                                   p_i_v_fumigation_only ,
                                                   p_i_v_residue ,
                                                   p_o_v_return_status
                                                   );
    end if;

 --   sql_id := 5;
    if i.PROG_TYPE='L102' THEN
      p_l_rem_str      := i.PARAMETER_STRING;
      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_booking_no := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_voyage_seq_no  := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_service      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_service      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_vessel      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_vessel      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_voyage      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_voyage      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_direction      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_direction      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_load_port      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_load_port      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_old_pol_pcsq      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_new_pol_pcsq      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_discharge_port      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_discharge_port      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_act_service    := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_act_service      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_act_vessel      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_act_vessel      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_act_voyage      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_act_voyage      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_act_port_direction      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_act_port_direction      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_old_act_port_seq      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_new_act_port_seq      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_to_terminal      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_to_terminal      := p_l_str;

      p_i_v_record_status      := p_l_rem_str;
      PCE_ECM_SYNC_BOOKING_EZLL.g_v_err_handler_flg := 'Y';
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_ROUTING_UPDATE( p_i_v_booking_no,
                                                        p_i_n_voyage_seq_no,
                                                        p_i_v_old_service,
                                                        p_i_v_new_service,
                                                        p_i_v_old_vessel,
                                                        p_i_v_new_vessel,
                                                        p_i_v_old_voyage,
                                                        p_i_v_new_voyage,
                                                        p_i_v_old_direction,
                                                        p_i_v_new_direction,
                                                        p_i_v_old_load_port,
                                                        p_i_v_new_load_port ,
                                                        p_i_n_old_pol_pcsq,
                                                        p_i_n_new_pol_pcsq,
                                                        p_i_v_old_discharge_port,
                                                        p_i_v_new_discharge_port,
                                                        p_i_v_old_act_service,
                                                        p_i_v_new_act_service,
                                                        p_i_v_old_act_vessel,
                                                        p_i_v_new_act_vessel,
                                                        p_i_v_old_act_voyage,
                                                        p_i_v_new_act_voyage,
                                                        p_i_v_old_act_port_direction,
                                                        p_i_v_new_act_port_direction,
                                                        p_i_n_old_act_port_seq,
                                                        p_i_n_new_act_port_seq,
                                                        p_i_v_old_to_terminal,
                                                        p_i_v_new_to_terminal,
                                                        p_i_v_old_from_terminal,
                                                        p_i_v_new_from_terminal,
                                                        p_i_v_record_status,
                                                        p_o_v_return_status
                                                        );
    end if;

  --  sql_id := 6;
    if i.PROG_TYPE='L103' THEN
      p_l_rem_str      := i.PARAMETER_STRING;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_booking_no := p_l_str;

      p_i_n_equipment_seq_no := p_l_rem_str;


      PCE_ECM_SYNC_BOOKING_EZLL.g_v_err_handler_flg := 'Y';
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_REMOVE(p_i_v_booking_no,
                                                         p_i_n_equipment_seq_no,
                                                         p_o_v_return_status
                                                         );
    end if;

   -- sql_id := 7;
    if i.PROG_TYPE='L105' THEN
      p_l_rem_str      := i.PARAMETER_STRING;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_booking_no := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_equipment_seq_no := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_size_type_seq_no := p_l_str;

      p_i_n_supplier_seq_no  := p_l_rem_str;

      PCE_ECM_SYNC_BOOKING_EZLL.g_v_err_handler_flg := 'Y';
      PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_ADD(p_i_v_booking_no,
                                                      p_i_n_equipment_seq_no,
                                                      p_i_n_size_type_seq_no,
                                                      p_i_n_supplier_seq_no,
                                                      p_o_v_return_status
                                                      );
    end if;

 --   sql_id := 8;
    if i.PROG_TYPE='L106' THEN
      p_l_rem_str      := i.PARAMETER_STRING;
      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_booking_no := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_equipment_seq_no  := p_l_str;


      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_old_equipment_no      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_new_equipment_no      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_overheight      := p_l_str;


      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_overlength_rear      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_overlength_front      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_overwidth_left      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_imdg       := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_unno       := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_overwidth_right      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_un_var      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_flash_point      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_flash_unit      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_reefer_tmp      := p_l_str;

      p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_v_reefer_tmp_unit      := p_l_str;

      p_l_str             := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
      p_l_rem_str         := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
      p_i_n_humidity      := p_l_str;

      p_i_v_ventilation      := p_l_rem_str;

           PCE_ECM_SYNC_BOOKING_EZLL.g_v_err_handler_flg := 'Y';
           PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_UPDATE(p_i_v_booking_no,
                                                              p_i_n_equipment_seq_no,
                                                              p_i_v_old_equipment_no,
                                                              p_i_v_new_equipment_no,
                                                              p_i_n_overheight,
                                                              p_i_n_overlength_rear,
                                                              p_i_n_overlength_front,
                                                              p_i_n_overwidth_left   ,
                                                              p_i_n_overwidth_right  ,
                                                              p_i_v_imdg,
                                                              p_i_v_unno,
                                                              p_i_v_un_var           ,
                                                              p_i_v_flash_point      ,
                                                              p_i_n_flash_unit       ,
                                                              p_i_n_reefer_tmp       ,
                                                              p_i_v_reefer_tmp_unit  ,
                                                              p_i_n_humidity,
                                                              p_i_v_ventilation,
                                                              'EZLL', -- *1
                                                              p_o_v_return_status
                                                            ) ;

    END IF;

/* start added by vikas for tos_onboard_list */
    IF I.PROG_TYPE='TOS_EZDL' THEN
        p_l_rem_str      := i.PARAMETER_STRING;

        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_weight := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_rftemp := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_unit := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_imdg_tos := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_unno_tos := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_variant := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_flash_pt := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_flash_pt_unit := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_port_class := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_oog_oh := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_oog_olf := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_oog_olb := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_oog_owr := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_oog_owl := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_stow_position := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_container_operator := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_out_slot_operator := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_han1 := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_han2 := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_han3 := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_clr1 := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_clr2 := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_connecting_vessel := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_connecting_voyage_no := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_next_pod1 := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_next_pod2 := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_next_pod3 := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_tight_conn_flag := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_void_slot := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_list_status := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_soc_coc := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_service := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_vessel := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_voyage := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_direction := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_pod := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_pod_trm := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_pol := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_pol_trm := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_booking := p_l_str;


        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_equipment_no := p_l_str;

        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_pot := p_l_str;

        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_eqsize := p_l_str;

        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_eqtype := p_l_str;

        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_full_mt := p_l_str;

        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_slot_operator := p_l_str;

        p_l_str          := SUBSTR(p_l_rem_str,1,INSTR(p_l_rem_str,'~')-1);
        p_l_rem_str      := SUBSTR(p_l_rem_str,INSTR(p_l_rem_str,'~')+1);
        p_i_v_local_ts := p_l_str;

        p_i_v_final_destination := p_l_rem_str;

        PCE_ECM_SYNC_TOS_EZDL.g_v_err_handler_flg := 'Y';

        /* update EZDL table */
        PCE_ECM_SYNC_TOS_EZDL.PRE_TOS_GET_TOS_ONBORD(
              p_i_v_weight
            , p_i_v_rftemp
            , p_i_v_unit
            , p_i_v_imdg_tos
            , p_i_v_unno_tos
            , p_i_v_variant
            , p_i_v_flash_pt
            , p_i_v_flash_pt_unit
            , p_i_v_port_class
            , p_i_v_oog_oh
            , p_i_v_oog_olf
            , p_i_v_oog_olb
            , p_i_v_oog_owr
            , p_i_v_oog_owl
            , p_i_v_stow_position
            , p_i_v_container_operator
            , p_i_v_out_slot_operator
            , p_i_v_han1
            , p_i_v_han2
            , p_i_v_han3
            , p_i_v_clr1
            , p_i_v_clr2
            , p_i_v_connecting_vessel
            , p_i_v_connecting_voyage_no
            , p_i_v_next_pod1
            , p_i_v_next_pod2
            , p_i_v_next_pod3
            , p_i_v_tight_conn_flag
            , p_i_v_void_slot
            , p_i_v_list_status
            , p_i_v_soc_coc
            , p_i_v_service
            , p_i_v_vessel
            , p_i_v_voyage
            , p_i_v_direction
            , p_i_v_pod
            , p_i_v_pod_trm
            , p_i_v_pol
            , p_i_v_pol_trm
            , p_i_v_booking
            , p_i_v_equipment_no
            , p_i_v_pot
            , p_i_v_eqsize
            , p_i_v_eqtype
            , p_i_v_full_mt
            , p_i_v_slot_operator
            , p_i_v_final_destination
            , p_i_v_local_ts
            , p_o_v_return_status
        );
    END IF; -- end if of TOS_EZDL_SYNC;

/* end added by vikas for tos_onboard_list */


    --IF error handler executed successfully then mark this error as suspended
    IF p_o_v_return_status = '0' THEN
        UPDATE TOS_SYNC_ERROR_LOG
        SET RECORD_STATUS = 'S'
          , RECORD_CHANGE_USER = PCE_ECM_SYNC_BOOKING_EZLL.g_v_user
          , RECORD_CHANGE_DATE = l_d_time
        WHERE PARAMETER_STRING = i.PARAMETER_STRING
        AND   PROG_TYPE        = i.PROG_TYPE
        AND   OPEARTION_TYPE   = i.OPEARTION_TYPE
        AND   ERROR_MSG        = i.ERROR_MSG
        AND   RECORD_STATUS    = 'A'
        AND   RERUN_STATUS     = 0;
    END IF;
  END LOOP;

end PRE_TOS_SYNC_ERROR_HANDLER;
/
