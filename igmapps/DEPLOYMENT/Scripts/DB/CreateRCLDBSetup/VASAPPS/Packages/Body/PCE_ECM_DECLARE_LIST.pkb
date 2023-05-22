CREATE OR REPLACE PACKAGE BODY PCE_ECM_DECLARE_LIST AS

g_v_sql_id                      ZND_DISPATCH_ERROR.USER_ERR_CD%TYPE; -- Which SQL is executing
g_v_sysdate                     DATE := SYSDATE;
g_v_declare_list_module         VARCHAR2(20) := 'EZLL';
g_v_upd_by_edi                  VARCHAR2(3)  := 'EDI';

g_v_parameter_string            TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;

/*
    *1:  Modified by vikas, When service is DFS then no need to check VVFORL flag
         in ITP063 table, as k'chatgamol, 04.04.2012
    *2:  Modified by vikas, when mlo_pod1 is not blank then populate location 11
         else populate for next_pod1, as k'chatgamol, 20.04.2012
    *3:  Modified by vikas, when mlo_pod2 is not blank then populate location 64
         else populate for next_pod2, as k'chatgamol, 20.04.2012
    *4:  Modified by vikas, when mlo_pod3 is not blank then populate location 68
         else populate for next_pod3, as k'chatgamol, 20.04.2012
    *5:  Modified by vikas, for location 83 no need to check POD1, as
         k'chatgamol, 25.04.2012
    *6:  Modified by vikas, no need to populate loc+11 for all voyage sequence,
         populate loc+11 only for the discharge port, k'chatgamol, 29.05.2012
    *7:  Modified by vikas, populate terminal also for loc+11,64, 83,
         k'chatgamol, 06.06.2012
    *8:  Modifed by vikas, Wrong mapping is there for container sequence no, 08.06.2012
    *9:  Modified by vikas, for loc+83, If MLO_DEL not blank populate MLO_DEL else MLO_POD3 not blank
         populate MLO_POD3 else MLO_POD2 not blank populate MLO_POD2 else MLO_POD1 not blank populate MLO_POD1
         else populate final_dest, as k'chatgamol n druai, 19.09.2012
    *10: Modified by vikas, IF mlo_pod1 is not blank, then populate location 11 elseif mlo_del is not blank, then populate location 11
         else populate port of discharge, as k'chatgamol n druai, 19.09.2012
    *11: Modified by vikas, IF mlo_pod2 is not blank then populate location 64 elseif mlo_pol1 is blank and mlo_del is blank,
         then populate next_pod2, as k'chatgamol n druai, 19.09.2012
    *12: Modified by vikas, IF mlo_pod3 is not blank then populate location 68 elseif mlo_pol1 is blank and mlo_del is blank,
         then populate next_pod3, as k'chatgamol n druai, 19.09.2012
    *13: Modified by vikas, Bug fix system generating coprar for suspended records also, 26.09.2012
    *14: Modified by vikas, Change logic to populate qualifier 64 and qualifier 68, as
         per duri and k'chatgamol, 28.09.2012.
    *15: Modified by vikas, for performance tunning, remove logging, as k'chatgamol,
         04.10.2012
    *16: Added by vikas, Add container loading remark, k'chatgamol, 25.01.2013
	*17: Added by leena, CLR, added condition for port of discharge for bugfix, 06.02.2013
  *18: Modified by Chatgamol ,Remove space after alphabet before inserting to avoid insert error
  *19: Modified by Watcharee C, Only special Handling <> 'N' will insert into DOC_HAZARD. on 22/09/2016
  *20: Modified by Watcharee C, As per K.Lim's confirmation need to populate DG info (IMDG/UNNO) in to staging table by container not by booking/bl. on 11/10/2017.

 */
PROCEDURE PRE_ECM_GENERATE_EDI (
      p_i_v_activity_code           VARCHAR2 -- Called For Decalare Load List Outbound  or Declare Discharge List Outbound
    , p_i_v_list_id                 VARCHAR2
    , p_i_v_function_cd             VARCHAR2 --(O-Original, M - Modification, C - Cancelleation)
    , p_i_v_terminal                VARCHAR2
    , p_i_v_message_recipient       VARCHAR2
    , p_i_v_message_set             VARCHAR2
    , p_i_v_all_ports_flag          VARCHAR2
    , p_i_v_specific_port_name      VARCHAR2
    , p_i_v_flat_rack_flag          VARCHAR2
    , p_i_v_fumigation_flag         VARCHAR2
    , p_i_n_eme_uid                 NUMBER
    , p_i_v_user_id                 VARCHAR2
    , p_i_v_cont_op_flag            VARCHAR2
    , p_i_v_slot_op_flag            VARCHAR2
    , p_i_v_cont_op                 VARCHAR2
    , p_i_v_slot_op                 VARCHAR2
    , p_o_v_err_cd           OUT    VARCHAR2
)
AS

    --l_io_message_reference                  EDI_TRANSACTION_DETAIL.MSG_REFERENCE%TYPE;
    l_v_api_uid                             EDI_MESSAGE_EXCHANGE.API_UID%TYPE;

    /* Sequence Id's Used in EDI Calls */
    l_n_edi_edl_uid                         NUMBER;
    l_n_msg_reference                       VARCHAR2(12);
    l_n_edi_esdl_uid                        NUMBER;
    l_v_edi_esdd_seq                        NUMBER;
    l_n_edi_esdp_seq                        NUMBER;
    l_n_edi_esdcn_seq                       NUMBER;
    l_n_esdj_uid                            NUMBER;
    l_n_edi_esde_seq                        NUMBER;
    l_n_edi_esdco_seq                       NUMBER;
    l_v_edi_esdh_seq                        NUMBER;
    l_v_edi_esdt_seq                        NUMBER;

    l_v_edi_etd_uid                         EDI_ST_DOC_HEADER.EDI_ETD_UID%TYPE;

    l_b_first_rec                           BOOLEAN := TRUE;

    l_v_vsopcd                              ITP060.VSOPCD%TYPE;
    l_v_loyd_no                             EDI_ST_DOC_JOURNEY.CONVEYANCE_CODE%TYPE;
    l_v_vslgnm                              ITP060.VSLGNM%TYPE;
    l_v_vscncd                              ITP060.VSCNCD%TYPE;

    l_v_port_qualifer                       VARCHAR2(2);
    l_v_picode                              ITP040.PICODE%TYPE;
    l_v_piname                              ITP040.PINAME%TYPE;
    l_v_pist                                ITP040.PIST%TYPE;
    l_v_picncd                              ITP040.PICNCD%TYPE;

    l_v_ayorig                              IDP010.AYORIG%TYPE;
    l_v_aympol                              IDP010.AYMPOL%TYPE;
    l_v_aympod                              IDP010.AYMPOD%TYPE;
    l_v_aydest                              IDP010.AYDEST%TYPE;

    l_v_tqtord                              ITP130.TQTORD%TYPE;
    l_v_tqtrnm                              ITP130.TQTRNM%TYPE;

    l_v_arrival_date                        DATE;
    l_v_sailing_date                        DATE;
    l_v_arrival_code                        VARCHAR2(4);
    l_v_sailing_code                        VARCHAR2(4);

    l_v_edi_partner_id                      ITPLVL.EDI_PARTNER_ID%TYPE;
    l_v_edi_party_name                      ITPLVL.LVCONM%TYPE;
    l_v_lvadd1                              ITPLVL.LVADD1%TYPE;
    l_v_lvadd2                              ITPLVL.LVADD2%TYPE;
    l_v_lvadd3                              ITPLVL.LVADD3%TYPE;
    l_v_lvadd4                              ITPLVL.LVADD4%TYPE;
    l_v_lvstat                              ITPLVL.LVSTAT%TYPE;
    l_v_lvcoun                              ITPLVL.LVCOUN%TYPE;
    l_v_lvzip                               ITPLVL.LVZIP%TYPE;
    l_v_lvconm                              ITPLVL.LVCONM%TYPE;
    l_v_lvphon                              ITPLVL.LVPHON%TYPE;
    l_v_lvfax                               ITPLVL.LVFAX%TYPE;
    l_v_lvemal                              ITPLVL.LVEMAL%TYPE;

    l_v_sizetype                            VARCHAR2(4);
    l_v_type_desc                           ITP076.ISDESC%TYPE;
    l_v_sl_no_sh                            IDP055.EYSSEL%TYPE;
    l_v_sl_no_ca                            IDP055.EYCRSL%TYPE;
    l_v_sl_no_cu                            IDP055.EYCSEL%TYPE;
    l_v_piece_count                         IDP055.EYPCKG%TYPE;
    l_v_package_type                        IDP055.EYKIND%TYPE;
    l_v_movement_from                       ITP070.FROM_LOCATION_TYPE%TYPE;
    l_v_movement_to                         ITP070.TO_LOCATION_TYPE%TYPE;
    l_v_movement_type                       VARCHAR(1);
    l_v_haulage_arrang                      BKP001.ORIGIN_HAULAGE%TYPE;
    l_v_nature_of_cargo                     BKP009.PACKAGE_KIND%TYPE;

    l_v_bl_no                               IDP055.EYBLNO%TYPE;
    l_v_commodity                           IDP050.BYCMCD%TYPE;
    l_v_description                         IDP050.BYRMKS%TYPE;
    l_v_package_type_comm                   IDP050.BYKIND%TYPE;
    l_v_piece_count_comm                    IDP050.BYPCKG%TYPE;
    l_v_gross_weight                        IDP050.BYMTWT%TYPE;
    l_v_volume                              IDP050.BYMTMS%TYPE;
    l_v_length                              IDP050.BYLENG%TYPE;
    l_v_width                               IDP050.BYWDTH%TYPE;
    l_v_height                              IDP050.BYHGHT%TYPE;

    l_v_packing_group                       IDP051.PACKAGE_GROUP_CODE%TYPE;
    l_v_haz_mat_code                        IDP051.IYIMCO%TYPE;
    l_v_haz_mat_sub_class                   IDP051.IYIMLB%TYPE;
    l_v_mfag_page                           IDP051.IYMFCD%TYPE;
    l_v_ems_page                            IDP051.IYEMNO%TYPE;

    l_v_explosive_content                   VARCHAR2(1);

    l_v_han_code                            SHP007.SHI_DESCRIPTION%TYPE;

    l_v_text_code                           IDP050.BYCMCD%TYPE;
    l_v_text_description                    IDP060.FYDSCR%TYPE;

    l_v_location_type                       VARCHAR(3);

    l_v_from_terminal                       BOOKING_VOYAGE_ROUTING_DTL.FROM_TERMINAL%TYPE;
    l_v_to_terminal                         BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;

    l_arr_var_name                          STRING_ARRAY;
    l_arr_var_value                         STRING_ARRAY;
    l_arr_var_io                            STRING_ARRAY;
    l_t_log_info                            TIMESTAMP(6);
    l_e_exception                           EXCEPTION;
    l_v_obj_nm                              VARCHAR2(100);
    l_b_raise_exp                           BOOLEAN;

    l_cnt_weight_uom                        VARCHAR2(3) := 'KGM';
    l_cnt_weight_uom_t                      VARCHAR2(3);
    l_cnt_length_uom                        VARCHAR2(3) := 'CMT';
    l_cnt_volume_uom                        VARCHAR2(3) := 'MTQ';
    l_cnt_volume_uom_t                      VARCHAR2(3);

    l_v_activity_code                       VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'ACTIVITY_CODE',p_i_v_activity_code);
    l_v_list_id                             VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'LIST_ID',p_i_v_list_id);
    l_v_function_cd                         VARCHAR2(1)   := FE_TRANS_DATA(p_i_n_eme_uid,'FUNCTION_CODE',p_i_v_function_cd);
    l_v_terminal                            VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'TERMINAL',p_i_v_terminal);
    l_v_message_recipient                   VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'MESSAGE_RECIPIENT',p_i_v_message_recipient);
    l_v_message_set                         VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'MESSAGE_SET',p_i_v_message_set);
    l_v_all_ports_flag                      VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'ALL_PORTS_FLAG',p_i_v_all_ports_flag);
    l_v_specific_port_name                  VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'SPECIFIC_PORT_NAME',p_i_v_specific_port_name);
    l_v_flat_rack_flag                      VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'FLAT_RACK_FLAG',p_i_v_flat_rack_flag);
    l_v_fumigation_flag                     VARCHAR2(100) := FE_TRANS_DATA(p_i_n_eme_uid,'FUMIGATION_FLAG',p_i_v_fumigation_flag);
    l_v_invoyageno                            VARCHAR2(100) ;
    l_v_activity_port                       VARCHAR2(100);
    l_v_activity_terminal                   VARCHAR2(100);
    l_v_shipment_type                       VARCHAR2(10);
    l_v_full_mt                             VARCHAR2(10);
    l_v_equipment_status                    VARCHAR2(1);
    l_v_temperature_uom                     VARCHAR2(3);
    l_v_temperature_uom_t                   VARCHAR2(3);
    l_v_hazardous                           EDI_ST_DOC_EQUIPMENT.HAZARDOUS%TYPE;
    l_v_ship_type                           VARCHAR2(1);
    l_v_bill_of_lading                      IDP010.AYBLNO%TYPE;
    l_v_sequence                            BKP009.BISEQN%TYPE;
    l_v_place_of_delivery_n                 IDP010.FINAL_PLACE_OF_DELIVERY_CODE%TYPE;
    l_v_place_of_delivery                   IDP010.FINAL_PLACE_OF_DELIVERY_CODE%TYPE;
    l_v_place_of_receipt                    BKP001.BAORGN%TYPE;
    l_v_fcdesc                              ITP080.FCDESC%TYPE;
    l_v_special_handling                    VARCHAR2(5);
    l_n_count_alias                         NUMBER;
    l_v_customer_alias                      ITP010.CUSTOMER_ALIAS%TYPE;
    l_v_birefr                              BKP009.BIREFR%TYPE;
    l_n_count                               NUMBER;
    l_v_temp_code                           VARCHAR2 (3);
    l_v_flashpoint                          BOOKING_DG_COMM_DETAIL.HZ_FLPT_FROM%TYPE;
    l_v_imo_class                           BOOKING_DG_COMM_DETAIL.IMO_CLASS%TYPE;
    l_v_tech_name                           BOOKING_DG_COMM_DETAIL.TECHNICAL_NAME%TYPE;
    l_v_exp_powder                          BOOKING_DG_COMM_DETAIL.EXP_WEIGHT_POWDER%TYPE;
    l_v_exp_gas                             BOOKING_DG_COMM_DETAIL.EXP_WEIGHT_GAS%TYPE;
    l_v_psn                                 BOOKING_DG_COMM_DETAIL.PROPER_SHIPPING_NAME%TYPE;
    l_v_contact_person                      BOOKING_DG_COMM_DETAIL.CONTACT_DESTINATON%TYPE;
    l_v_imo_no                              BOOKING_DG_COMM_DETAIL.IMO_NO%TYPE;
    l_v_undg_no                             BOOKING_DG_COMM_DETAIL.UN_NO%TYPE;
    l_v_contact_telno                       BOOKING_DG_COMM_DETAIL.CONTACT_TELNO%TYPE;
    l_v_package_grp_cd                      BOOKING_DG_COMM_DETAIL.PACKAGE_GROUP_CODE%TYPE;
    l_v_hz_description                      BOOKING_DG_COMM_DETAIL.HZ_DESCRIPTION%TYPE;
    l_v_imo_label                           BOOKING_DG_COMM_DETAIL.IMO_LABEL%TYPE;
    l_v_ems_no                              BOOKING_DG_COMM_DETAIL.EMS_NO%TYPE;
    l_v_mfag_no                             BOOKING_DG_COMM_DETAIL.MFAG_NO%TYPE;
    l_v_marine_pollutant                    BOOKING_DG_COMM_DETAIL.MARINE_POLLUTANT%TYPE;
    l_v_residue                             BOOKING_DG_COMM_DETAIL.RESIDUE%TYPE;
    l_v_limited_quantity                    BOOKING_DG_COMM_DETAIL.LIMITED_QUANTITY%TYPE;
    l_v_pod_term                            BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;

    TYPE varchar2_table IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;

    var_list VARCHAR2(1000);
    arr_table dbms_utility.lname_array;
    arr_cnt BINARY_INTEGER;

    p_delim VARCHAR2(1) DEFAULT ',';
    v_nfields PLS_INTEGER := 1;
    v_table varchar2_table;
    v_delimpos PLS_INTEGER;
    v_delimlen PLS_INTEGER;
    v_string   TOS_LL_BOOKED_LOADING.PUBLIC_REMARK%TYPE;

     /*
          *7 start
     */
     l_v_next_pod1_terminal             BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;
     l_v_next_pod2_terminal             BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;
     l_v_next_pod3_terminal             BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;
     l_v_final_pod_terminal             BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;
     l_v_next_service                   BOOKING_VOYAGE_ROUTING_DTL.SERVICE%TYPE;
     l_v_next_vessel                    BOOKING_VOYAGE_ROUTING_DTL.VESSEL%TYPE;
     l_v_next_voyno                     BOOKING_VOYAGE_ROUTING_DTL.VOYNO%TYPE;
     l_v_next_dir                       BOOKING_VOYAGE_ROUTING_DTL.DIRECTION%TYPE;
     /*
          *7 end
     */
    l_v_cont_ld_rem_desc1                   SHP041.CLR_DESC%TYPE; -- *16
    l_v_cont_ld_rem_desc2                   SHP041.CLR_DESC%TYPE; -- *16

    CURSOR l_cur_edi_data IS
        SELECT
              LL.FK_SERVICE                             as SERVICE
            , LL.FK_DIRECTION                           as DIRECTION
            , LL.FK_VOYAGE                              as VOYAGE_NUMBER
            , LL.FK_VESSEL                              as VESSEL
            , LL.FK_PORT_SEQUENCE_NO                    as PORT_SEQUENCE_NO
            , BL.FK_BOOKING_NO                          as BOOKING_NO
            , BL.DN_EQUIPMENT_NO                        as CONTAINER_NO
            , LL.DN_PORT                                as PORT_OF_LOADING
            , LL.DN_TERMINAL                            as LOAD_TERMINAL
            , BL.DN_DISCHARGE_PORT                      as PORT_OF_DISCHARGE
            , BL.DN_DISCHARGE_TERMINAL                  as DISCHARGE_TERMINAL
            , BL.DN_NXT_POD1                            as NEXT_POD1
            , BL.DN_NXT_POD2                            as NEXT_POD2
            , BL.DN_NXT_POD3                            as NEXT_POD3
            , BL.DN_SHIPMENT_TYP                        as SHIPMENT_TYPE
            , BL.DN_SOC_COC                             as SOC_COC
            , BL.DN_FULL_MT                             as FULL_MT
            , BL.CONTAINER_GROSS_WEIGHT                 as CONTAINER_GROSS_WEIGHT
            , BL.STOWAGE_POSITION                       as STOWAGE_POSITION
            , BL.FK_SLOT_OPERATOR                       as SLOT_OPERATOR
            , BL.OUT_SLOT_OPERATOR                      as OUT_SLOT_OPERATOR
            , BL.FK_CONTAINER_OPERATOR                  as CONTAINER_OPERATOR
            , BL.FK_HANDLING_INSTRUCTION_1              as HANDLING_INSTRUCTION_1
            , BL.FK_HANDLING_INSTRUCTION_2              as HANDLING_INSTRUCTION_2
            , BL.FK_HANDLING_INSTRUCTION_3              as HANDLING_INSTRUCTION_3
            , BL.OVERHEIGHT_CM                          as OOG_OH
            , BL.OVERWIDTH_LEFT_CM                      as OOG_OWL
            , BL.OVERWIDTH_RIGHT_CM                     as OOG_OWR
            , BL.OVERLENGTH_FRONT_CM                    as OOG_OLF
            , BL.OVERLENGTH_REAR_CM                     as OOG_OLB
            , BL.DN_HUMIDITY                            as HUMIDITY
            , BL.DN_VENTILATION                         as VENTILATION
            , BL.REEFER_TMP                             as TEMPERATURE
            , BL.REEFER_TMP_UNIT                        as TEMPERATURE_UOM
            , BL.CONTAINER_LOADING_REM_1                as CONTAINER_LOADING_REM_1 -- *16
            , BL.CONTAINER_LOADING_REM_2                as CONTAINER_LOADING_REM_2 -- *16
            , BL.DN_SPECIAL_HNDL                        as SPECIAL_HNDL -- *16
            , CASE WHEN (Bl.FK_IMDG     IS NOT NULL OR
                         Bl.FK_UNNO     IS NOT NULL OR
                         Bl.FLASH_UNIT  IS NOT NULL OR
                         Bl.FLASH_POINT IS NOT NULL
                        )
                   THEN 'Y'
                   ELSE ''
              END                                       as HAZARDOUS
            , BL.FK_IMDG                                as IMDG
            , BL.FK_UNNO                                as UNNO
            , BL.RESIDUE_ONLY_FLAG                      as RESIDUE
            , BL.FLASH_POINT                            as FLASH_POINT
            , LL.DN_PORT                                as ACTIVITY_PORT
            , BL.DN_NXT_POD1                            as NEXT_PORT
            , BL.DN_NXT_VOYAGE                          as NEXT_VOYAGE
            , BL.FINAL_DEST                             as PLACE_OF_DELIVERY
            , BL.DN_FINAL_POD                           as FINAL_DISCHARGE_PORT
            , BL.FK_BKG_VOYAGE_ROUTING_DTL              as VOYAGE_SEQNO
            , COUNT(1) OVER ()                          as TOT_EQ_REC
            , BL.DN_EQ_SIZE                             as EQ_SIZE
            , BL.DN_EQ_TYPE                             as EQ_TYPE
            , BL.DN_SHIPMENT_TERM                       as SHIPMENT_TERM
            -- , BL.CONTAINER_SEQ_NO                       as CONTAINER_SEQ_NO -- *8
            , BL.FK_BKG_EQUIPM_DTL                       as CONTAINER_SEQ_NO -- *8
            , BKP1.BAPOL                                as BAPOL
            , BKP1.BAPOD                                as BAPOD
            , BL.MLO_VESSEL                             as MLO_VESSEL     -- added by vikas for equipment status
            , BL.MLO_VOYAGE                             as MLO_VOYAGE     -- added by vikas for equipment status
            , BL.MLO_POD1                               as MLO_POD1       -- *2
            , BL.MLO_POD2                               as MLO_POD2       -- *3
            , BL.MLO_POD3                               as MLO_POD3       -- *4
            , BL.MLO_DEL                                as MLO_DEL        -- added by vikas for LOC 7 port, 01.11.2011
            , BL.PUBLIC_REMARK                          as PUBLIC_REMARK  -- added by vikas for insert vantilation text, 07.11.2011
            , BL.LOAD_CONDITION                         AS LOAD_CONDITION -- added by vikas for insert text, 11.11.2011
            , BL.LOCAL_TERMINAL_STATUS                  AS LOCAL_TERMINAL_STATUS -- added by vikas for insert text, 01.12.2011
            , FE_TRANS_DATA(p_i_n_eme_uid,'SERVICE',LL.FK_SERVICE)                                  as T_SERVICE
            , FE_TRANS_DATA(p_i_n_eme_uid,'DIRECTION',LL.FK_DIRECTION)                              as T_DIRECTION
            , FE_TRANS_DATA(p_i_n_eme_uid,'VOYAGE',LL.FK_VOYAGE)                                    as T_VOYAGE_NUMBER
            , FE_TRANS_DATA(p_i_n_eme_uid,'VESSEL',LL.FK_VESSEL)                                    as T_VESSEL
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT_SEQUENCE_NO',LL.FK_PORT_SEQUENCE_NO)                as T_PORT_SEQUENCE_NO
            , FE_TRANS_DATA(p_i_n_eme_uid,'BOOKING_NO',BL.FK_BOOKING_NO)                            as T_BOOKING_NO
            , FE_TRANS_DATA(p_i_n_eme_uid,'EQUIPMENT_NO',BL.DN_EQUIPMENT_NO)                        as T_CONTAINER_NO
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT',LL.DN_PORT)                                        as T_PORT_OF_LOADING
            , FE_TRANS_DATA(p_i_n_eme_uid,'DISCHARGE_PORT',BL.DN_DISCHARGE_PORT)                    as T_PORT_OF_DISCHARGE
            , FE_TRANS_DATA(p_i_n_eme_uid,'SHIPMENT_TYP',BL.DN_SHIPMENT_TYP)                        as T_SHIPMENT_TYPE
            , FE_TRANS_DATA(p_i_n_eme_uid,'SOC_COC',BL.DN_SOC_COC)                                  as T_SOC_COC
            , FE_TRANS_DATA(p_i_n_eme_uid,'FULL_MT',BL.DN_FULL_MT)                                  as T_FULL_MT
            , FE_TRANS_DATA(p_i_n_eme_uid,'CONTAINER_GROSS_WEIGHT',BL.CONTAINER_GROSS_WEIGHT)       as T_CONTAINER_GROSS_WEIGHT
            , FE_TRANS_DATA(p_i_n_eme_uid,'STOWAGE_POSITION',BL.STOWAGE_POSITION)                   as T_STOWAGE_POSITION
            , FE_TRANS_DATA(p_i_n_eme_uid,'SLOT_OPERATOR',BL.FK_SLOT_OPERATOR)                      as T_SLOT_OPERATOR
            , FE_TRANS_DATA(p_i_n_eme_uid,'CONTAINER_OPERATOR',BL.FK_CONTAINER_OPERATOR)            as T_CONTAINER_OPERATOR
            , FE_TRANS_DATA(p_i_n_eme_uid,'HANDLING_INSTRUCTION_1',BL.FK_HANDLING_INSTRUCTION_1)    as T_HANDLING_INSTRUCTION_1
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERHEIGHT_CM',BL.OVERHEIGHT_CM)                         as T_OOG_OH
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERWIDTH_LEFT_CM',BL.OVERWIDTH_LEFT_CM)                 as T_OOG_OWL
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERWIDTH_RIGHT_CM',BL.OVERWIDTH_RIGHT_CM)               as T_OOG_OWR
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERLENGTH_FRONT_CM',BL.OVERLENGTH_FRONT_CM)             as T_OOG_OLF
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERLENGTH_REAR_CM',BL.OVERLENGTH_REAR_CM)               as T_OOG_OLB
            , FE_TRANS_DATA(p_i_n_eme_uid,'HUMIDITY',BL.DN_HUMIDITY)                                as T_HUMIDITY
            , FE_TRANS_DATA(p_i_n_eme_uid,'VENTILATION',BL.DN_VENTILATION)                          as T_VENTILATION
            , FE_TRANS_DATA(p_i_n_eme_uid,'REEFER_TMP',BL.REEFER_TMP)                               as T_TEMPERATURE
            , FE_TRANS_DATA(p_i_n_eme_uid,'REEFER_TMP_UNIT',BL.REEFER_TMP_UNIT)                     as T_TEMPERATURE_UOM
            , FE_TRANS_DATA(p_i_n_eme_uid,'HAZARDOUS',CASE WHEN (Bl.FK_IMDG     IS NOT NULL OR
                         Bl.FK_UNNO     IS NOT NULL OR
                         Bl.FLASH_UNIT  IS NOT NULL OR
                         Bl.FLASH_POINT IS NOT NULL
                        )
                   THEN 'Y'
                   ELSE ''
              END)                                                                                    as T_HAZARDOUS
            , FE_TRANS_DATA(p_i_n_eme_uid,'IMDG',BL.FK_IMDG)                                        as T_IMDG
            , FE_TRANS_DATA(p_i_n_eme_uid,'UNNO',BL.FK_UNNO)                                        as T_UNNO
            , FE_TRANS_DATA(p_i_n_eme_uid,'RESIDUE_ONLY_FLAG',BL.RESIDUE_ONLY_FLAG)                 as T_RESIDUE
            , FE_TRANS_DATA(p_i_n_eme_uid,'FLASH_POINT',BL.FLASH_POINT)                             as T_FLASH_POINT
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT',LL.DN_PORT)                                        as T_ACTIVITY_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'NXT_POD1',BL.DN_NXT_POD1)                                as T_NEXT_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'NXT_VOYAGE',BL.DN_NXT_VOYAGE)                            as T_NEXT_VOYAGE
            , FE_TRANS_DATA(p_i_n_eme_uid,'FINAL_DEST',BL.FINAL_DEST)                               as T_PLACE_OF_DELIVERY
            , FE_TRANS_DATA(p_i_n_eme_uid,'FINAL_POD',BL.DN_FINAL_POD)                              as T_FINAL_DISCHARGE_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'BKG_VOYAGE_ROUTING_DTL',BL.FK_BKG_VOYAGE_ROUTING_DTL)    as T_VOYAGE_SEQNO
            , COUNT(1) OVER ()                                                                        as T_TOT_EQ_REC
            , FE_TRANS_DATA(p_i_n_eme_uid,'EQ_SIZE',BL.DN_EQ_SIZE)                                  as T_EQ_SIZE
            , FE_TRANS_DATA(p_i_n_eme_uid,'EQ_TYPE',BL.DN_EQ_TYPE)                                  as T_EQ_TYPE
            , FE_TRANS_DATA(p_i_n_eme_uid,'SHIPMENT_TERM',BL.DN_SHIPMENT_TERM)                      as T_SHIPMENT_TERM
            -- , FE_TRANS_DATA(p_i_n_eme_uid,'CONTAINER_SEQ_NO',BL.CONTAINER_SEQ_NO)                   as T_CONTAINER_SEQ_NO -- *8
            , FE_TRANS_DATA(p_i_n_eme_uid,'CONTAINER_SEQ_NO',BL.FK_BKG_EQUIPM_DTL)                   as T_CONTAINER_SEQ_NO -- *8

        FROM  TOS_LL_LOAD_LIST          LL
            , TOS_LL_BOOKED_LOADING     BL
            , BKP001                    BKP1
        WHERE BKP1.BABKNO            =     BL.FK_BOOKING_NO
        AND   LL.RECORD_STATUS = 'A' -- *13
        AND   BL.RECORD_STATUS = 'A' -- *13
        AND   LL.PK_LOAD_LIST_ID     =     BL.FK_LOAD_LIST_ID
        AND   LL.PK_LOAD_LIST_ID     =     p_i_v_list_id
        AND   BL.LOADING_STATUS     IN     ('BK','LO')
        /* commented by vikas specific port should be port of loading not port of loading */
        -- AND   (p_i_v_all_ports_flag  = 'A' OR LL.DN_PORT = p_i_v_specific_port_name)
        AND   (p_i_v_all_ports_flag  = 'A' OR BL.DN_DISCHARGE_PORT = p_i_v_specific_port_name) -- vikas
        AND   (p_i_v_flat_rack_flag  = 'Y' OR BL.LOAD_CONDITION  != 'P')
        AND   (p_i_v_fumigation_flag = 'Y' OR NVL(BL.FUMIGATION_ONLY,'N') != 'Y')
        AND   p_i_v_activity_code    = 'L'
        /* start added by vikas */
        AND ( (p_i_v_cont_op_flag  = 'E' AND INSTR(p_i_v_cont_op,FK_CONTAINER_OPERATOR )=0)
            OR (p_i_v_cont_op_flag   = 'I' AND  INSTR(p_i_v_cont_op,FK_CONTAINER_OPERATOR )>0)
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND ( (p_i_v_slot_op_flag  = 'E' AND INSTR(p_i_v_slot_op,FK_SLOT_OPERATOR )=0)
            OR  (p_i_v_slot_op_flag   = 'I' AND  INSTR(p_i_v_slot_op,FK_SLOT_OPERATOR )>0)
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) )
        /* end added by vikas */

      /* commented by vikas logic is not working correctly

        AND   ( (p_i_v_cont_op_flag  = 'E' AND FK_CONTAINER_OPERATOR NOT IN (p_i_v_cont_op))
            OR (p_i_v_cont_op_flag   = 'I' AND FK_CONTAINER_OPERATOR IN (p_i_v_cont_op))
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND   ( (p_i_v_slot_op_flag  = 'E' AND FK_SLOT_OPERATOR NOT IN (p_i_v_slot_op))
            OR (p_i_v_slot_op_flag   = 'I' AND FK_SLOT_OPERATOR IN (p_i_v_slot_op))
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) )
            */

        UNION ALL

        SELECT
              DL.FK_SERVICE                                 as SERVICE
            , DL.FK_DIRECTION                               as DIRECTION
            , DL.FK_VOYAGE                                  as VOYAGE_NUMBER
            , DL.FK_VESSEL                                  as VESSEL
            , DL.FK_PORT_SEQUENCE_NO                        as PORT_SEQUENCE_NO
            , BD.FK_BOOKING_NO                              as BOOKING_NO
            , BD.DN_EQUIPMENT_NO                            as CONTAINER_NO
            , BD.DN_POL                                     as PORT_OF_LOADING
            , BD.DN_POL_TERMINAL                            as LOAD_TERMINAL
            , DL.DN_PORT                                    as PORT_OF_DISCHARGE
            , DL.DN_TERMINAL                                as DISCHARGE_TERMINAL
            , BD.DN_NXT_POD1                                as NEXT_POD1
            , BD.DN_NXT_POD2                                as NEXT_POD2
            , BD.DN_NXT_POD3                                as NEXT_POD3
            , BD.DN_SHIPMENT_TYP                            as SHIPMENT_TYPE
            , BD.DN_SOC_COC                                 as SOC_COC
            , BD.DN_FULL_MT                                 as FULL_MT
            , BD.CONTAINER_GROSS_WEIGHT                     as CONTAINER_GROSS_WEIGHT
            , BD.STOWAGE_POSITION                           as STOWAGE_POSITION
            , BD.FK_SLOT_OPERATOR                           as SLOT_OPERATOR
            , BD.OUT_SLOT_OPERATOR                            as OUT_SLOT_OPERATOR
            , BD.FK_CONTAINER_OPERATOR                      as CONTAINER_OPERATOR
            , BD.FK_HANDLING_INSTRUCTION_1                  as HANDLING_INSTRUCTION_1
            , BD.FK_HANDLING_INSTRUCTION_2                  as HANDLING_INSTRUCTION_2
            , BD.FK_HANDLING_INSTRUCTION_3                  as HANDLING_INSTRUCTION_3
            , BD.OVERHEIGHT_CM                              as OOG_OH
            , BD.OVERWIDTH_LEFT_CM                          as OOG_OWL
            , BD.OVERWIDTH_RIGHT_CM                         as OOG_OWR
            , BD.OVERLENGTH_FRONT_CM                        as OOG_OLF
            , BD.OVERLENGTH_REAR_CM                         as OOG_OLB
            , BD.DN_HUMIDITY                                as HUMIDITY
            , BD.DN_VENTILATION                             as VENTILATION
            , BD.REEFER_TEMPERATURE                         as TEMPERATURE
            , BD.REEFER_TMP_UNIT                            as TEMPERATURE_UOM
            , BD.CONTAINER_LOADING_REM_1                    as CONTAINER_LOADING_REM_1 -- *16
            , BD.CONTAINER_LOADING_REM_2                    as CONTAINER_LOADING_REM_2 -- *16
            , BD.DN_SPECIAL_HNDL                            as SPECIAL_HNDL -- *16
            , CASE WHEN (BD.FK_IMDG     IS NOT NULL OR
                         BD.FK_UNNO     IS NOT NULL OR
                         BD.FLASH_UNIT  IS NOT NULL OR
                         BD.FLASH_POINT IS NOT NULL
                        )
                   THEN 'Y'
                   ELSE ''
              END                                           as HAZARDOUS
            , BD.FK_IMDG                                    as IMDG
            , BD.FK_UNNO                                    as UNNO
            , BD.RESIDUE_ONLY_FLAG                          as RESIDUE
            , BD.FLASH_POINT                                as FLASH_POINT
            , DL.DN_PORT                                    as ACTIVITY_PORT
            , BD.DN_NXT_POD1                                as NEXT_PORT
            , BD.DN_NXT_VOYAGE                              as NEXT_VOYAGE
            , BD.FINAL_DEST                                 as PLACE_OF_DELIVERY
            , BD.DN_FINAL_POD                               as FINAL_DISCHARGE_PORT
            , BD.FK_BKG_VOYAGE_ROUTING_DTL                  as VOYAGE_SEQNO
            , COUNT(1) OVER ()                              as TOT_EQ_REC
            , BD.DN_EQ_SIZE                                 as EQ_SIZE
            , BD.DN_EQ_TYPE                                 as EQ_TYPE
            , BD.DN_SHIPMENT_TERM                           as SHIPMENT_TERM
            -- , BD.CONTAINER_SEQ_NO                           as CONTAINER_SEQ_NO  -- *8
            , BD.FK_BKG_EQUIPM_DTL                           as CONTAINER_SEQ_NO -- *8
            , BKP1.BAPOL                                    as BAPOL
            , BKP1.BAPOD                                    as BAPOD
            , BD.MLO_VESSEL                                 as MLO_VESSEL -- added by vikas for equipment status
            , BD.MLO_VOYAGE                                 as MLO_VOYAGE -- added by vikas for equipment status
            , BD.MLO_POD1                                   as MLO_POD1   -- added by vikas for equipment status
            , BD.MLO_POD2                                   as MLO_POD2       -- *3
            , BD.MLO_POD3                                   as MLO_POD3       -- *4
            , BD.MLO_DEL                                    as MLO_DEL  -- added by vikas for LOC 7 port, 01.11.2011
            , BD.PUBLIC_REMARK                              as PUBLIC_REMARK  -- added by vikas for insert vantilation text, 07.11.2011
            , BD.LOAD_CONDITION                             AS LOAD_CONDITION -- added by vikas for insert text, 11.11.2011
            , BD.LOCAL_TERMINAL_STATUS                  AS LOCAL_TERMINAL_STATUS -- added by vikas for insert text, 01.12.2011
            , FE_TRANS_DATA(p_i_n_eme_uid,'SERVICE',DL.FK_SERVICE)                                  as T_SERVICE
            , FE_TRANS_DATA(p_i_n_eme_uid,'DIRECTION',DL.FK_DIRECTION)                              as T_DIRECTION
            , FE_TRANS_DATA(p_i_n_eme_uid,'VOYAGE',DL.FK_VOYAGE)                                    as T_VOYAGE_NUMBER
            , FE_TRANS_DATA(p_i_n_eme_uid,'VESSEL',DL.FK_VESSEL)                                    as T_VESSEL
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT_SEQUENCE_NO',DL.FK_PORT_SEQUENCE_NO)                as T_PORT_SEQUENCE_NO
            , FE_TRANS_DATA(p_i_n_eme_uid,'BOOKING_NO',BD.FK_BOOKING_NO)                            as T_BOOKING_NO
            , FE_TRANS_DATA(p_i_n_eme_uid,'EQUIPMENT_NO',BD.DN_EQUIPMENT_NO)                        as T_CONTAINER_NO
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT',BD.DN_POL)                                         as T_PORT_OF_LOADING
            , FE_TRANS_DATA(p_i_n_eme_uid,'DISCHARGE_PORT',DL.DN_PORT)                              as T_PORT_OF_DISCHARGE
            , FE_TRANS_DATA(p_i_n_eme_uid,'SHIPMENT_TYP',BD.DN_SHIPMENT_TYP)                        as T_SHIPMENT_TYPE
            , FE_TRANS_DATA(p_i_n_eme_uid,'SOC_COC',BD.DN_SOC_COC)                                  as T_SOC_COC
            , FE_TRANS_DATA(p_i_n_eme_uid,'FULL_MT',BD.DN_FULL_MT)                                  as T_FULL_MT
            , FE_TRANS_DATA(p_i_n_eme_uid,'CONTAINER_GROSS_WEIGHT',BD.CONTAINER_GROSS_WEIGHT)       as T_CONTAINER_GROSS_WEIGHT
            , FE_TRANS_DATA(p_i_n_eme_uid,'STOWAGE_POSITION',BD.STOWAGE_POSITION)                   as T_STOWAGE_POSITION
            , FE_TRANS_DATA(p_i_n_eme_uid,'SLOT_OPERATOR',BD.FK_SLOT_OPERATOR)                      as T_SLOT_OPERATOR
            , FE_TRANS_DATA(p_i_n_eme_uid,'CONTAINER_OPERATOR',BD.FK_CONTAINER_OPERATOR)            as T_CONTAINER_OPERATOR
            , FE_TRANS_DATA(p_i_n_eme_uid,'HANDLING_INSTRUCTION_1',BD.FK_HANDLING_INSTRUCTION_1)    as T_HANDLING_INSTRUCTION_1
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERHEIGHT_CM',BD.OVERHEIGHT_CM)                         as T_OOG_OH
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERWIDTH_LEFT_CM',BD.OVERWIDTH_LEFT_CM)                 as T_OOG_OWL
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERWIDTH_RIGHT_CM',BD.OVERWIDTH_RIGHT_CM)               as T_OOG_OWR
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERLENGTH_FRONT_CM',BD.OVERLENGTH_FRONT_CM)             as T_OOG_OLF
            , FE_TRANS_DATA(p_i_n_eme_uid,'OVERLENGTH_REAR_CM',BD.OVERLENGTH_REAR_CM)               as T_OOG_OLB
            , FE_TRANS_DATA(p_i_n_eme_uid,'HUMIDITY',BD.DN_HUMIDITY)                                as T_HUMIDITY
            , FE_TRANS_DATA(p_i_n_eme_uid,'VENTILATION',BD.DN_VENTILATION)                          as T_VENTILATION
            , FE_TRANS_DATA(p_i_n_eme_uid,'REEFER_TMP',BD.REEFER_TEMPERATURE)                       as T_TEMPERATURE
            , FE_TRANS_DATA(p_i_n_eme_uid,'REEFER_TMP_UNIT',BD.REEFER_TMP_UNIT)                  as T_TEMPERATURE_UOM
            , FE_TRANS_DATA(p_i_n_eme_uid,'HAZARDOUS',CASE WHEN (BD.FK_IMDG     IS NOT NULL OR
                         BD.FK_UNNO     IS NOT NULL OR
                         BD.FLASH_UNIT  IS NOT NULL OR
                         BD.FLASH_POINT IS NOT NULL
                        )
                   THEN 'Y'
                   ELSE ''
              END)                                                                                    as T_HAZARDOUS
            , FE_TRANS_DATA(p_i_n_eme_uid,'IMDG',BD.FK_IMDG)                                        as T_IMDG
            , FE_TRANS_DATA(p_i_n_eme_uid,'UNNO',BD.FK_UNNO)                                        as T_UNNO
            , FE_TRANS_DATA(p_i_n_eme_uid,'RESIDUE_ONLY_FLAG',BD.RESIDUE_ONLY_FLAG)                 as T_RESIDUE
            , FE_TRANS_DATA(p_i_n_eme_uid,'FLASH_POINT',BD.FLASH_POINT)                             as T_FLASH_POINT
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT',DL.DN_PORT)                                        as T_ACTIVITY_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'NXT_POD1',BD.DN_NXT_POD1)                                as T_NEXT_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'NXT_VOYAGE',BD.DN_NXT_VOYAGE)                            as T_NEXT_VOYAGE
            , FE_TRANS_DATA(p_i_n_eme_uid,'FINAL_DEST',BD.FINAL_DEST)                               as T_PLACE_OF_DELIVERY
            , FE_TRANS_DATA(p_i_n_eme_uid,'FINAL_POD',BD.DN_FINAL_POD)                              as T_FINAL_DISCHARGE_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'BKG_VOYAGE_ROUTING_DTL',BD.FK_BKG_VOYAGE_ROUTING_DTL)    as T_VOYAGE_SEQNO
            , COUNT(1) OVER ()                                                                        as T_TOT_EQ_REC
            , FE_TRANS_DATA(p_i_n_eme_uid,'EQ_SIZE',BD.DN_EQ_SIZE)                                  as T_EQ_SIZE
            , FE_TRANS_DATA(p_i_n_eme_uid,'EQ_TYPE',BD.DN_EQ_TYPE)                                  as T_EQ_TYPE
            , FE_TRANS_DATA(p_i_n_eme_uid,'SHIPMENT_TERM',BD.DN_SHIPMENT_TERM)                      as T_SHIPMENT_TERM
            -- , FE_TRANS_DATA(p_i_n_eme_uid,'CONTAINER_SEQ_NO',BD.CONTAINER_SEQ_NO)                   as T_CONTAINER_SEQ_NO -- *8
            , FE_TRANS_DATA(p_i_n_eme_uid,'CONTAINER_SEQ_NO',BD.FK_BKG_EQUIPM_DTL)                   as T_CONTAINER_SEQ_NO -- *8
        FROM TOS_DL_DISCHARGE_LIST           DL
           , TOS_DL_BOOKED_DISCHARGE         BD
           , BKP001                          BKP1
        WHERE BKP1.BABKNO             =   BD.FK_BOOKING_NO
        AND   DL.RECORD_STATUS = 'A' -- *13
        AND   BD.RECORD_STATUS = 'A' -- *13
        AND   DL.PK_DISCHARGE_LIST_ID =   BD.FK_DISCHARGE_LIST_ID
        AND   DL.PK_DISCHARGE_LIST_ID =   p_i_v_list_id
        AND   BD.DISCHARGE_STATUS     IN  ('BK', 'DI')
        /* commented by vikas specific port should be port of loading not port of discharge */
        -- AND   (p_i_v_all_ports_flag   = 'A' OR DL.DN_PORT = p_i_v_specific_port_name)
        AND   (p_i_v_all_ports_flag   = 'A' OR BD.DN_POL = p_i_v_specific_port_name) -- vikas
        AND   (p_i_v_flat_rack_flag   = 'Y' OR BD.LOAD_CONDITION  != 'P')
        AND   (p_i_v_fumigation_flag  = 'Y' OR NVL(BD.FUMIGATION_ONLY,'N') != 'Y')
        AND   p_i_v_activity_code     = 'D'
        /* start added by vikas */
        AND ( (p_i_v_cont_op_flag  = 'E' AND INSTR(p_i_v_cont_op,FK_CONTAINER_OPERATOR )=0)
            OR (p_i_v_cont_op_flag   = 'I' AND  INSTR(p_i_v_cont_op,FK_CONTAINER_OPERATOR )>0)
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND ( (p_i_v_slot_op_flag  = 'E' AND INSTR(p_i_v_slot_op,FK_SLOT_OPERATOR )=0)
            OR  (p_i_v_slot_op_flag   = 'I' AND  INSTR(p_i_v_slot_op,FK_SLOT_OPERATOR )>0)
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) );
        /* end added by vikas */
      /* commented by vikas logic is not working correctly

        AND   ( (p_i_v_cont_op_flag  = 'E' AND FK_CONTAINER_OPERATOR NOT IN (p_i_v_cont_op))
            OR (p_i_v_cont_op_flag   = 'I' AND FK_CONTAINER_OPERATOR IN (p_i_v_cont_op))
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND   ( (p_i_v_slot_op_flag  = 'E' AND FK_SLOT_OPERATOR NOT IN (p_i_v_slot_op))
            OR (p_i_v_slot_op_flag   = 'I' AND FK_SLOT_OPERATOR IN (p_i_v_slot_op))
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) );
                  */
      CURSOR l_cur_edi_location_data IS

        SELECT
              LL.DN_PORT                                                                          as PORT
             , LL.DN_TERMINAL                                                                as TERMINAL
            , LL.FK_DIRECTION                                                                     AS DIRECTION
            , '9'                                                                                 as ACTIVITY_TYPE
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT',LL.DN_PORT)                                    as T_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'DISCHARGE_TERMINAL',LL.DN_TERMINAL)                  as T_TERMINAL
        FROM TOS_LL_LOAD_LIST           LL
            , TOS_LL_BOOKED_LOADING     BL
        WHERE LL.PK_LOAD_LIST_ID     =     BL.FK_LOAD_LIST_ID
        AND   LL.PK_LOAD_LIST_ID     =     p_i_v_list_id
        AND   BL.LOADING_STATUS     IN     ('BK','LO')
        AND   (p_i_v_all_ports_flag  = 'A' OR LL.DN_PORT = p_i_v_specific_port_name)
        AND   (p_i_v_flat_rack_flag  = 'Y' OR BL.LOAD_CONDITION  != 'P')
        AND   (p_i_v_fumigation_flag = 'Y' OR NVL(BL.FUMIGATION_ONLY,'N') != 'Y')
        AND   p_i_v_activity_code    = 'L'

        UNION

        SELECT
               BL.DN_DISCHARGE_PORT                                                        as PORT
             , BL.DN_DISCHARGE_TERMINAL                                                           as TERMINAL
            , BVRD.DIRECTION                                                                AS DIRECTION
             , '11'                                                                       as ACTIVITY_TYPE
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT',BL.DN_DISCHARGE_PORT)                   as T_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'DISCHARGE_TERMINAL',BL.DN_DISCHARGE_TERMINAL)        as T_TERMINAL
        FROM  TOS_LL_LOAD_LIST           LL
            , TOS_LL_BOOKED_LOADING     BL
            , BOOKING_VOYAGE_ROUTING_DTL  BVRD
           /* , ( SELECT  BOOKING_NO
                      , DISCHARGE_PORT
                      , TO_TERMINAL
                FROM BOOKING_VOYAGE_ROUTING_DTL  BVRDO
                WHERE BVRDO.VOYAGE_SEQNO = ( SELECT MAX(BVRDI.VOYAGE_SEQNO)
                                             FROM BOOKING_VOYAGE_ROUTING_DTL  BVRDI
                                             WHERE  BVRDO.BOOKING_NO = BVRDI.BOOKING_NO)
              ) BVRD */
        WHERE BL.FK_BOOKING_NO       = BVRD.BOOKING_NO
        AND   BL.FK_BKG_VOYAGE_ROUTING_DTL=BVRD.VOYAGE_SEQNO
        AND   LL.PK_LOAD_LIST_ID     = BL.FK_LOAD_LIST_ID
        AND   LL.PK_LOAD_LIST_ID     = p_i_v_list_id
        AND   BL.LOADING_STATUS     IN ('BK','LO')
        AND   (p_i_v_all_ports_flag  = 'A' OR LL.DN_PORT = p_i_v_specific_port_name)
        AND   (p_i_v_flat_rack_flag  = 'Y' OR BL.LOAD_CONDITION  != 'P')
        AND   (p_i_v_fumigation_flag = 'Y' OR NVL(BL.FUMIGATION_ONLY,'N') != 'Y')
        AND   p_i_v_activity_code    = 'L'

        UNION

        SELECT
              DL.DN_PORT                                                                    as PORT
            , DL.DN_TERMINAL                                                                as TERMINAL
            , DL.FK_DIRECTION                                                               AS DIRECTION
            , '11'                                                                          as ACTIVITY_TYPE
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT',DL.DN_PORT)                                as T_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'DISCHARGE_TERMINAL',DL.DN_TERMINAL)          as T_TERMINAL
        FROM TOS_DL_DISCHARGE_LIST           DL
           , TOS_DL_BOOKED_DISCHARGE         BD
        WHERE DL.PK_DISCHARGE_LIST_ID =   BD.FK_DISCHARGE_LIST_ID
        AND   DL.PK_DISCHARGE_LIST_ID =   p_i_v_list_id
        AND   BD.DISCHARGE_STATUS     IN  ('BK', 'DI')
        AND   (p_i_v_all_ports_flag   = 'A' OR DL.DN_PORT = p_i_v_specific_port_name)
        AND   (p_i_v_flat_rack_flag   = 'Y' OR BD.LOAD_CONDITION  != 'P')
        AND   (p_i_v_fumigation_flag  = 'Y' OR NVL(BD.FUMIGATION_ONLY,'N') != 'Y')
        AND   p_i_v_activity_code     = 'D'

        UNION

        SELECT
               BD.DN_POL                                                                as PORT
            , BD.DN_POL_TERMINAL                                                            as TERMINAL
            , BVRD.DIRECTION                                                                AS DIRECTION
            , '9'                                                                           as ACTIVITY_TYPE
            , FE_TRANS_DATA(p_i_n_eme_uid,'PORT',BD.DN_POL)                          as T_PORT
            , FE_TRANS_DATA(p_i_n_eme_uid,'DISCHARGE_TERMINAL',BD.DN_POL_TERMINAL)        as T_TERMINAL
        FROM TOS_DL_DISCHARGE_LIST           DL
           , TOS_DL_BOOKED_DISCHARGE         BD
           , BOOKING_VOYAGE_ROUTING_DTL  BVRD
           /*, (  SELECT  BOOKING_NO
                      , LOAD_PORT
                      , FROM_TERMINAL
                FROM BOOKING_VOYAGE_ROUTING_DTL  BVRDO
                WHERE BVRDO.VOYAGE_SEQNO = ( SELECT MAX(BVRDI.VOYAGE_SEQNO)
                                             FROM BOOKING_VOYAGE_ROUTING_DTL  BVRDI
                                             WHERE  BVRDO.BOOKING_NO = BVRDI.BOOKING_NO)
              ) BVRD*/
        WHERE BD.FK_BOOKING_NO        = BVRD.BOOKING_NO
        AND   BD.FK_BKG_VOYAGE_ROUTING_DTL=BVRD.VOYAGE_SEQNO
        AND   DL.PK_DISCHARGE_LIST_ID =   BD.FK_DISCHARGE_LIST_ID
        AND   DL.PK_DISCHARGE_LIST_ID =   p_i_v_list_id
        AND   BD.DISCHARGE_STATUS     IN  ('BK', 'DI')
        AND   (p_i_v_all_ports_flag   = 'A' OR DL.DN_PORT = p_i_v_specific_port_name)
        AND   (p_i_v_flat_rack_flag   = 'Y' OR BD.LOAD_CONDITION  != 'P')
        AND   (p_i_v_fumigation_flag  = 'Y' OR NVL(BD.FUMIGATION_ONLY,'N') != 'Y')
        AND   p_i_v_activity_code     = 'D' ;


      CURSOR l_cur_edi_partner_header (
         p_eme_uid   edi_message_exchange.eme_uid%TYPE
      )
      IS
         SELECT eph.sender_id, eph.receiver_id
           FROM edi_partner_header eph, edi_message_exchange eme
          WHERE eme.eme_uid = p_eme_uid
            AND eme.etp_uid = eph.etp_uid
            AND ROWNUM = 1;

      -- Good item
      CURSOR l_cur_idp050 (
         p_byblno   IN   idp050.byblno%TYPE,
         p_bycmsq   IN   idp050.bycmsq%TYPE
      )
      IS
         SELECT *
           FROM idp050
          WHERE byblno = p_byblno AND bycmsq = p_bycmsq;

      -- Hazardous
      CURSOR l_cur_idp051 (
         p_byblno   IN   idp050.byblno%TYPE,
         p_bycmsq   IN   idp050.bycmsq%TYPE
      )
      IS
         SELECT *
           FROM idp051
          WHERE iyblno = p_byblno AND iycmsq = p_bycmsq;

      -- Good description
      CURSOR l_cur_idp060 (
         p_byblno   IN   IDP050.BYBLNO%TYPE,
         p_bycmsq   IN   IDP050.BYCMSQ%TYPE
      )
      IS
         SELECT FYDSCR
           FROM IDP060
          WHERE FYBLNO = p_byblno AND FYCMSQ = p_bycmsq;
      --commented by aks temporarily 7july
      /*CURSOR l_cur_quarantine_dtl (
         p_byblno   IN   IDP050.BYBLNO%TYPE,
         p_bycmsq   IN   IDP050.BYCMSQ%TYPE
      )
      IS
         SELECT FYDSCR
           FROM BL_QUARANTINE_DTL
          WHERE FYBLNO = p_byblno AND FYCMSQ = p_bycmsq;
        */
      CURSOR l_cur_idp030 (
         p_cyblno   IDP030.CYBLNO%TYPE,
         p_cyrctp   IDP030.CYRCTP%TYPE
      )
      IS
         SELECT *
           FROM IDP030
          WHERE CYBLNO = p_cyblno AND CYRCTP = p_cyrctp;

      CURSOR l_cur_bkp050 (
         p_booking_no         BKP050.BWBKNO%TYPE,
         p_special_handling   BKP009.SPECIAL_HANDLING%TYPE
      )
      IS
         SELECT *
           FROM bkp050
          WHERE bwbkno = p_booking_no
                AND special_handling = p_special_handling;

      CURSOR l_cur_bkp030 (
         p_bnbkno   IN   BKP030.BNBKNO%TYPE,
         p_bncstp        BKP030.BNCSTP%TYPE
      )
      IS
         SELECT *
           FROM BKP030
          WHERE BNBKNO = p_bnbkno AND BNCSTP = p_bncstp;

        CURSOR l_cur_sec_voyage (p_i_v_booking VARCHAR2,
                                 p_i_v_voyage_seq NUMBER)
        IS
            SELECT    SERVICE
                    , VESSEL
                    , VOYNO
                    , DIRECTION
                    , PORT
                    , TERMINAL
            FROM (
                    SELECT    BVRD.SERVICE
                            , BVRD.VESSEL
                            , BVRD.VOYNO
                            , BVRD.DIRECTION
                            --, BVRD.LOAD_PORT PORT
                            , BVRD.DISCHARGE_PORT PORT
                            , BVRD.TO_TERMINAL TERMINAL
                            , ROW_NUMBER() OVER(PARTITION BY BVRD.BOOKING_NO
                                                ORDER BY BVRD.VOYAGE_SEQNO ASC) SR_NO
                    FROM      BOOKING_VOYAGE_ROUTING_DTL   BVRD
                    WHERE  BVRD.BOOKING_NO   = p_i_v_booking
                    AND    BVRD.VOYAGE_SEQNO > p_i_v_voyage_seq
                 ) WHERE SR_NO = 1;

        CURSOR l_cur_prev_voyage (p_i_v_booking VARCHAR2,
                                 p_i_v_voyage_seq NUMBER)
        IS
            SELECT    SERVICE
                    , VESSEL
                    , VOYNO
                    , DIRECTION
                    , PORT
                    , TERMINAL
            FROM (
                    SELECT    BVRD.SERVICE
                            , BVRD.VESSEL
                            , BVRD.VOYNO
                            , BVRD.DIRECTION
                            , BVRD.LOAD_PORT PORT
                            , BVRD.FROM_TERMINAL TERMINAL
                            , ROW_NUMBER() OVER(PARTITION BY BVRD.BOOKING_NO
                                                ORDER BY BVRD.VOYAGE_SEQNO DESC) SR_NO
                    FROM      BOOKING_VOYAGE_ROUTING_DTL   BVRD
                    WHERE  BVRD.BOOKING_NO   = p_i_v_booking
                    AND    BVRD.VOYAGE_SEQNO < p_i_v_voyage_seq
                 ) WHERE SR_NO = 1;

BEGIN


    l_t_log_info := CURRENT_TIMESTAMP;

    g_v_parameter_string := p_i_v_activity_code         || '~' ||
                            p_i_v_list_id               || '~' ||
                            p_i_v_function_cd           || '~' ||
                            p_i_v_terminal              || '~' ||
                            p_i_v_message_recipient     || '~' ||
                            p_i_v_message_set           || '~' ||
                            p_i_v_all_ports_flag        || '~' ||
                            p_i_v_specific_port_name    || '~' ||
                            p_i_v_flat_rack_flag        || '~' ||
                            p_i_v_fumigation_flag       || '~' ||
                            p_i_n_eme_uid               || '~' ||
                            p_i_v_user_id               || '~' ||
                            p_i_v_cont_op_flag          || '~' ||
                            p_i_v_slot_op_flag          || '~' ||
                            p_i_v_cont_op                 || '~' ||
                            p_i_v_slot_op                 || '~' ||
                            p_o_v_err_cd;

    g_v_sql_id := '1';
    l_v_obj_nm := 'MSG_REFERENCE_SEQ.NEXTVAL';
    SELECT MSG_REFERENCE_SEQ.NEXTVAL
    INTO l_n_msg_reference
    FROM DUAL;

    l_n_msg_reference  := LPAD(l_n_msg_reference,12,'0');


    g_v_sql_id := '2';
    FOR l_rec_edi_data IN l_cur_edi_data
    LOOP
        /*
            *7 start
        */
        l_v_next_pod1_terminal:= NULL;
        l_v_next_pod2_terminal:= NULL;
        l_v_next_pod3_terminal:= NULL;
        l_v_final_pod_terminal:= NULL;
        l_v_next_service:= NULL;
        l_v_next_vessel:= NULL;
        l_v_next_voyno:= NULL;
        l_v_next_dir:= NULL;
        /*
            *7 end
        */

        g_v_sql_id := '3';
        l_v_obj_nm := 'EDI_EDL_SEQ.NEXTVAL';
        SELECT EDI_EDL_SEQ.NEXTVAL
        INTO   l_n_edi_edl_uid
        FROM   DUAL;

        -- Step 1 : Populate data in  PKG_EDI_DOCUMENT.DOCUMENT_TRACKING_TRIGGER
        g_v_sql_id := '4';
        PKG_EDI_DOCUMENT.DOCUMENT_TRACKING_TRIGGER
        (
              l_rec_edi_data.VOYAGE_NUMBER
            , l_rec_edi_data.SERVICE
            , l_rec_edi_data.VESSEL
            , l_rec_edi_data.DIRECTION
            , l_rec_edi_data.CONTAINER_NO
            , l_rec_edi_data.PORT_SEQUENCE_NO
            , NULL -- Invoice No.
            , l_rec_edi_data.BOOKING_NO
            , NULL --B/L No.
            ,p_i_v_activity_code --Activity Code
            , p_i_v_function_cd
            , l_rec_edi_data.PORT_OF_LOADING
            , l_rec_edi_data.PORT_OF_DISCHARGE
            , NULL -- Include Freight
            , p_i_n_eme_uid
            , g_v_declare_list_module
            , l_n_msg_reference
            , p_i_v_user_id -- Login User ID
            , NULL --Document Type : Not clear yet how to derive, need to change later, waiting for RCL Response.
        );
        --Uncommented by Leena 25 Apr 2014 for track issue start
         l_arr_var_name := STRING_ARRAY
         ('p_i_v_voyage'           , 'p_i_v_service'           , 'p_i_v_vessel'
        , 'p_i_v_direction'        , 'p_i_v_container_seq_no'  , 'p_i_v_port_seq_no'
        , 'p_i_v_invoice_no'       , 'p_i_v_booking_no'        , 'p_i_v_bl_no'
        , 'p_i_v_ems_activity_cd'  , 'p_i_v_function_cd'       , 'p_i_v_pol'
        , 'p_i_v_pod'              , 'p_i_v_include_freight'   , 'p_i_v_eme_uid'
        , 'p_i_v_module'           , 'p_i_v_msg_refernece'     , 'p_i_v_added_by'
        , 'p_i_v_document_type'
          );

          l_arr_var_value := STRING_ARRAY
         (l_rec_edi_data.VOYAGE_NUMBER         , l_rec_edi_data.SERVICE           , l_rec_edi_data.VESSEL
        , l_rec_edi_data.DIRECTION             , l_rec_edi_data.CONTAINER_NO      , l_rec_edi_data.PORT_SEQUENCE_NO
        , NULL                                 , l_rec_edi_data.BOOKING_NO        , NULL
        , NULL                                 , p_i_v_function_cd                   , l_rec_edi_data.PORT_OF_LOADING
        , l_rec_edi_data.PORT_OF_DISCHARGE     , NULL                              , p_i_n_eme_uid
        , g_v_declare_list_module              , l_n_msg_reference                 , p_i_v_user_id
        , NULL
          );

          l_arr_var_io := STRING_ARRAY
         ('I'      , 'I'      , 'I'
        , 'I'      , 'I'      , 'I'
        , 'I'      , 'I'      , 'I'
        , 'I'      , 'I'      , 'I'
        , 'I'      , 'I'      , 'I'
        , 'I'      , 'I'      , 'I'
        , 'I'
          );

         PRE_LOG_INFO
          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
         , 'PKG_EDI_DOCUMENT.DOCUMENT_TRACKING_TRIGGER'
         , g_v_sql_id
         , p_i_v_user_id
         , l_t_log_info
         , NULL
         , l_arr_var_name
         , l_arr_var_value
         , l_arr_var_io
          );
          --Uncommented by Leena 25 Apr 2014 for track issue end
    /*END LOOP;

    -- Step 2 : Populate data in  PKG_EDI_TOS_OUT.PRC_PROCESS_LIST
    BEGIN
        g_v_sql_id := '5';
        l_v_obj_nm := 'EDI_MESSAGE_EXCHANGE';
        SELECT API_UID
        INTO   l_v_api_uid
        FROM EDI_MESSAGE_EXCHANGE
        WHERE EME_UID = p_i_n_eme_uid;
        --Commented by aks on 2nd Jun as most of the process is done in further code
        --PKG_EDI_TOS_OUT.PRC_PROCESS_LIST (l_v_api_uid);

        l_arr_var_name := STRING_ARRAY ('p_i_v_api_uid');

        l_arr_var_value := STRING_ARRAY (l_v_api_uid);

        l_arr_var_io := STRING_ARRAY  ('I');

       PRE_LOG_INFO
        ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
       , 'PKG_EDI_TOS_OUT.PRC_PROCESS_LIST'
       , g_v_sql_id
       , p_i_v_user_id
       , l_t_log_info
       , NULL
       , l_arr_var_name
       , l_arr_var_value
       , l_arr_var_io
        );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
            p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
            l_b_raise_exp := TRUE;
            PRE_LOG_INFO
             ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
            , l_v_obj_nm
            , g_v_sql_id
            , p_i_v_user_id
            , l_t_log_info
            , 'Exception occured while executing sql :: ' || p_o_v_err_cd
            , NULL
            , NULL
            , NULL
             );
    END;

    g_v_sql_id := '6';
    FOR l_rec_edi_data IN l_cur_edi_data
    LOOP*/

        -- Eexcute only one time for all records.
        IF l_b_first_rec THEN

           l_b_first_rec := FALSE;

            -- Step 3 : Populate data in  PKG_EDI_DOCUMENT.INSERT_TRANSACTION_HEADER_OUT
            g_v_sql_id := '7';
            PKG_EDI_DOCUMENT.INSERT_TRANSACTION_HEADER_OUT (
                p_i_n_eme_uid
              , l_n_msg_reference
            );

--          l_arr_var_name := STRING_ARRAY ('p_i_v_eme_uid', 'l_v_msg_ref');
--
--          l_arr_var_value := STRING_ARRAY (p_i_n_eme_uid , l_n_msg_reference);
--
--          l_arr_var_io := STRING_ARRAY  ('I', 'O');
--
--
--         PRE_LOG_INFO
--          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--         , 'PKG_EDI_DOCUMENT.INSERT_TRANSACTION_HEADER_OUT'
--         , g_v_sql_id
--         , p_i_v_user_id
--         , l_t_log_info
--         , NULL
--         , l_arr_var_name
--         , l_arr_var_value
--         , l_arr_var_io
--          );

            -- Step 4 : Populate data in  EDI_TRANSACTION_DETAIL
            g_v_sql_id := '8';
            l_v_obj_nm := 'EDI_ETD_SEQ.NEXTVAL';
            SELECT  EDI_ETD_SEQ.NEXTVAL
            INTO    l_v_edi_etd_uid
            FROM    DUAL;

            g_v_sql_id := '9';
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DETAIL';
            --aks 4july changed order
            PKG_EDI_DOCUMENT.PRC_CREATE_DETAIL
           (l_n_msg_reference
          , l_v_edi_etd_uid
          , l_rec_edi_data.ACTIVITY_PORT --need to change as per translation
          , p_i_v_activity_code
          , l_rec_edi_data.VOYAGE_NUMBER
          , l_rec_edi_data.VESSEL
           );

--           l_arr_var_name := STRING_ARRAY
--          ('l_v_msg_ref'      , 'l_v_edi_etd_uid'        , 'p_i_v_voyage'
--          ,'p_i_v_vessel'     , 'l_v_previous_port'    , 'p_i_v_port'
--          );
--
--           l_arr_var_value := STRING_ARRAY
--          (l_n_msg_reference        , l_v_edi_etd_uid                       , l_rec_edi_data.VOYAGE_NUMBER
--         , l_rec_edi_data.VESSEL         , l_rec_edi_data.ACTIVITY_PORT        , p_i_v_activity_code
--          );
--
--           l_arr_var_io := STRING_ARRAY
--          ('I'      , 'I'      , 'I'
--         , 'I'      , 'I'      , 'I'
--          );
--
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , NULL
--           , l_arr_var_name
--           , l_arr_var_value
--           , l_arr_var_io
--            );

            -- Step 5 : Populate data in  EDI_ST_DOC_HEADER
            g_v_sql_id := '10';
            INSERT INTO EDI_ST_DOC_HEADER (
                  EDI_ETD_UID
                , MSG_REFERENCE
                , DOCUMENT_ID
                , DOCUMENT_TYPE
                , FUNCTION_CODE
                , DOCUMENT_DATE
                , TOTAL_EQUIPMENT
                , RECORD_STATUS
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
            ) VALUES (
                  l_v_edi_etd_uid
                , l_n_msg_reference
                , l_v_edi_etd_uid   --aks 04july
                , FE_TRANS_DATA(p_i_n_eme_uid,'DOCUMENT_TYPE',DECODE(p_i_v_activity_code, 'D', 118, 'L' , 121))
                --, FE_TRANS_DATA(p_i_n_eme_uid,'FUNCTION_CODE',DECODE(p_i_v_function_cd, 'O', 9, 'M', 5, 'C', 1))
                , l_v_function_cd
                , g_v_sysdate
                , l_rec_edi_data.T_TOT_EQ_REC
                , 'A'
                , g_v_upd_by_edi
                , g_v_sysdate
            );
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , 'EDI_ST_DOC_HEADER'
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , 'INSERT CALLED'
--           , NULL
--           , NULL
--           , NULL
--            );

            --aks 04july add reference for ZZZ
             g_v_sql_id := '10.1';
            pkg_edi_document.prc_insert_reference ( l_v_edi_etd_uid
                                                  , 'ZZZ'
                                                  , l_n_msg_reference
                                                  , g_v_upd_by_edi
                                                  , NULL
                                                  , NULL
                                                  , NULL
                                                  , NULL
                                                  );
            -- Step 6  : Populate data in  EDI_ST_DOC_JOURNEY
            BEGIN
                /* comment open by vikas as it needed for arriaval date for LL, 21.10.2011 *
                g_v_sql_id := '11';
                l_v_obj_nm := 'ITP060';
                SELECT    VSOPCD
                        , NVL(TO_CHAR(LOYD_NO), l_rec_edi_data.VESSEL)
                        , VSLGNM
                        , VSCNCD
                INTO      l_v_vsopcd
                        , l_v_loyd_no
                        , l_v_vslgnm
                        , l_v_vscncd
                FROM ITP060
                WHERE VSVESS = l_rec_edi_data.VESSEL;
                */

              -- aks 04july add voyage no
             /* pkg_edi_document.prc_insert_reference (   l_v_edi_etd_uid
                                                      , 'VON'
                                                      , l_rec_edi_data.VOYAGE_NUMBER
                                                      , g_v_upd_by_edi
                                                      , NULL
                                                      , NULL
                                                      , NULL
                                                      , NULL
                                                    );*/
            --*************************************************
            --start processing of create carrier aks 4july
            ---create record for MR and MS
            FOR l_cur_edi_partner_header_data IN l_cur_edi_partner_header(p_i_n_eme_uid)
            LOOP
                /*  Start Commented by vikas as k'chatgamol say no need to
                    populate CF, 01.12.2011 *
                PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                 (p_i_n_eme_uid
                , l_v_edi_etd_uid
                , 'MR'
                , NULL
                , l_cur_edi_partner_header_data.RECEIVER_ID
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL    --l_n_edi_esde_seq
                , l_n_edi_esdp_seq
                  );
                *    End Commented by vikas, 01.12.2011 */
                g_v_sql_id := '22';
                PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                 (p_i_n_eme_uid
                , l_v_edi_etd_uid
                , 'MS'
                , NULL
                , l_cur_edi_partner_header_data.SENDER_ID
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL    --l_n_edi_esde_seq
                , l_n_edi_esdp_seq
                  );
            END LOOP;
            --end of MR and MS


            -- Step 10 : Populate data in  EDI_ST_DOC_PARTY
            BEGIN
                /*
                g_v_sql_id := '22';
                l_v_obj_nm := 'EDI_ESDE_SEQ.NEXTVAL';
                SELECT EDI_ESDE_SEQ.NEXTVAL
                INTO l_n_edi_esde_seq
                FROM DUAL;
                --l_v_obj_nm := 'EDI_ESDP_SEQ.NEXTVAL';
                --SELECT EDI_ESDP_SEQ.NEXTVAL
                --INTO l_n_edi_esdp_seq
                --FROM DUAL;-
*/
                g_v_sql_id := '23';
                SELECT    EDI_PARTNER_ID
                        , LVCONM
                        , LVADD1
                        , LVADD2
                        , LVADD3
                        , LVADD4
                        , LVSTAT
                        , LVCOUN
                        , LVZIP
                        , LVCONM
                        , LVPHON
                        , LVFAX
                        , LVEMAL
                INTO
                        l_v_edi_partner_id
                      , l_v_edi_party_name
                      , l_v_lvadd1
                      , l_v_lvadd2
                      , l_v_lvadd3
                      , l_v_lvadd4
                      , l_v_lvstat
                      , l_v_lvcoun
                      , l_v_lvzip
                      , l_v_lvconm
                      , l_v_lvphon
                      , l_v_lvfax
                      , l_v_lvemal
                FROM ITPLVL
                WHERE LVTRAD = '*'
                AND   LVAGNT = '***'
                AND   LVLINE = 'R';

                g_v_sql_id := '24';
                 --EXECUTE PROCEDURE WITH PARAMETERS TO INSERT DATA INTO EDI_ST_DOC_PARTY
                 l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';
                 PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                 (p_i_n_eme_uid
                , l_v_edi_etd_uid
                , 'CA'
                , l_v_edi_partner_id
                , l_v_edi_party_name
                , l_v_lvadd1
                , l_v_lvadd2
                , l_v_lvadd3
                , l_v_lvadd4
                , l_v_lvstat
                , l_v_lvcoun
                , l_v_lvzip
                , NULL    --l_n_edi_esde_seq
                , l_n_edi_esdp_seq
                  );

--                 l_arr_var_name := STRING_ARRAY
--                 ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'       , 'p_i_v_bncstp'
--                , 'p_i_v_bncscd'       , 'p_i_v_bnname'          , 'p_i_v_bnadd1'
--                , 'p_i_v_bnadd2'       , 'p_i_v_bnadd3'          , 'p_i_v_bnadd4'
--                , 'Location_County'    , 'p_i_v_bncoun'          , 'p_i_v_bnzip'
--                , 'l_n_edi_esde_seq'   , 'l_n_edi_esdp_uid'
--                  );
--
--                  l_arr_var_value := STRING_ARRAY
--                 (p_i_n_eme_uid            , l_v_edi_etd_uid          , 'CA'
--                , l_v_edi_partner_id       , l_v_edi_party_name       , l_v_lvadd1
--                , l_v_lvadd2               , l_v_lvadd3               , l_v_lvadd4
--                , l_v_lvstat               , l_v_lvcoun               , l_v_lvzip
--                , l_n_edi_esde_seq         , l_n_edi_esdp_seq
--                  );
--
--                  l_arr_var_io := STRING_ARRAY
--                 ('I'      , 'I'      , 'I'
--                , 'I'      , 'I'      , 'I'
--                , 'I'      , 'I'      , 'I'
--                , 'I'      , 'I'      , 'I'
--                , 'I'      , 'O'
--                  );
--
--               PRE_LOG_INFO
--                    ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                   , l_v_obj_nm
--                   , g_v_sql_id
--                   , p_i_v_user_id
--                   , l_t_log_info
--                   , NULL
--                   , l_arr_var_name
--                   , l_arr_var_value
--                   , l_arr_var_io
--                    );

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                    p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                    l_b_raise_exp := TRUE;

                    g_record_filter := 'LVTRAD:* LVAGNT = *** LVLINE:R';
                    g_record_table  := 'Record not found in ITPLVL table.';

--                    PRE_LOG_INFO
--                     ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , p_i_v_user_id
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                    , NULL
--                    , NULL
--                    , NULL
--                     );
            END;

            -- Step 11 : Populate data in  EDI_ST_DOC_CONTACT
            --g_v_sql_id := '25';
            --l_v_obj_nm := 'EDI_ESDCN_SEQ.NEXTVAL';
            --SELECT EDI_ESDCN_SEQ.NEXTVAL
            --INTO l_n_edi_esdcn_seq
            --FROM DUAL;

             g_v_sql_id := '26';
              --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_CONTACT
              l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_CONTACT';
              PKG_EDI_DOCUMENT.PRC_INSERT_CONTACT
              ( l_v_edi_etd_uid
              , l_n_edi_esdp_seq
              , NULL                --l_n_edi_esde_seq
              , 'IC'
              , l_v_lvconm
              , NULL
              , g_v_upd_by_edi
              , l_n_edi_esdcn_seq
              );

--             l_arr_var_name := STRING_ARRAY
--             ('l_n_edi_etd_uid'      , 'l_n_edi_esdp_uid'       , 'l_n_edi_esde_seq'
--            , 'p_i_v_ic'             , 'p_i_v_ytfnme'           , 'p_i_v_ytdept'
--            , 'p_i_v_edi'            , 'l_n_edi_esdcn_uid'
--              );
--
--              l_arr_var_value := STRING_ARRAY
--             (l_v_edi_etd_uid        , l_n_edi_esdp_seq              , NULL
--            , 'IC'                   , l_v_lvconm                    , NULL
--            , g_v_upd_by_edi         , l_n_edi_esdcn_seq
--              );
--
--              l_arr_var_io := STRING_ARRAY
--             ('I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'O'
--              );
--
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--            );

            -- Step 12 : Populate data in  EDI_ST_DOC_COMM (Telephone)
              --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_COMM FOR TELEPHONE
              L_V_OBJ_NM := 'PKG_EDI_DOCUMENT.PRC_INSERT_COMM';
              g_v_sql_id := '27';
              PKG_EDI_DOCUMENT.PRC_INSERT_COMM
              (l_n_edi_esdcn_seq
             , 'TE'
             , l_v_lvphon
             , g_v_upd_by_edi
              );

--             l_arr_var_name := STRING_ARRAY
--             ('l_n_edi_esdcn_uid'      , 'p_i_v_tfe'       , 'p_i_v_tfe_descp'
--            , 'p_i_v_edi'
--              );
--
--              l_arr_var_value := STRING_ARRAY
--             (l_n_edi_esdcn_seq        , 'TE'              , l_v_lvphon
--            , g_v_upd_by_edi
--              );
--
--              l_arr_var_io := STRING_ARRAY
--             ('I'      , 'I'      , 'I'
--            , 'I'
--              );
--
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , NULL
--           , l_arr_var_name
--           , l_arr_var_value
--           , l_arr_var_io
--            );

            -- Step 13 : Populate data in  EDI_ST_DOC_COMM (Fax)
            g_v_sql_id := '29';
              --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_COMM FOR FAX
              l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_COMM';
              PKG_EDI_DOCUMENT.PRC_INSERT_COMM
              (l_n_edi_esdcn_seq
             , 'FX'
             , l_v_lvfax
             , g_v_upd_by_edi
              );

--             l_arr_var_name := STRING_ARRAY
--             ('l_n_edi_esdcn_uid'      , 'p_i_v_tfe'       , 'p_i_v_tfe_descp'
--            , 'p_i_v_edi'
--              );
--
--              l_arr_var_value := STRING_ARRAY
--             (l_n_edi_esdcn_seq        , 'FX'              , l_v_lvfax
--            , g_v_upd_by_edi
--              );
--
--              l_arr_var_io := STRING_ARRAY
--             ('I'      , 'I'      , 'I'
--            , 'I'
--              );
--
--              PRE_LOG_INFO
--               ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--              , l_v_obj_nm
--              , g_v_sql_id
--              , p_i_v_user_id
--              , l_t_log_info
--              , NULL
--              , l_arr_var_name
--              , l_arr_var_value
--              , l_arr_var_io
--                );

              -- Step 14 : Populate data in  EDI_ST_DOC_COMM (EMAIL)
              g_v_sql_id := '31';
              --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_COMM FOR EMAIL
              l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_COMM';
              PKG_EDI_DOCUMENT.PRC_INSERT_COMM
              (l_n_edi_esdcn_seq
             , 'EM'
             , l_v_lvemal
             , g_v_upd_by_edi
              );

--             l_arr_var_name := STRING_ARRAY
--             ('l_n_edi_esdcn_uid'      , 'p_i_v_tfe'       , 'p_i_v_tfe_descp'
--            , 'p_i_v_edi'
--              );
--
--              l_arr_var_value := STRING_ARRAY
--             (l_n_edi_esdcn_seq        , 'EM'           , l_v_lvemal
--            , g_v_upd_by_edi
--              );
--
--              l_arr_var_io := STRING_ARRAY
--             ('I'      , 'I'      , 'I'
--            , 'I'
--              );
--
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , NULL
--           , l_arr_var_name
--           , l_arr_var_value
--           , l_arr_var_io
--            );
            --end processing of create carrier aks 4july

            --**************************************************************
            ---start processing of create voyage details
                g_v_sql_id := '12';
                --EXECUTE PROCEDURE WITH PARAMETERS TO CREATE A RECORD FOR JOURNEY
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';
                PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
                  (p_i_n_eme_uid,
                   l_v_edi_etd_uid
                 , l_rec_edi_data.VOYAGE_NUMBER
                 , l_rec_edi_data.SERVICE
                 , l_rec_edi_data.VESSEL
                 , l_rec_edi_data.DIRECTION
                 , l_rec_edi_data.PORT_OF_DISCHARGE        --aks 4july change from load to discharge
                 , 20
                 , p_i_v_activity_code                    --aks 4july change from null to activity code
                 , NULL--EDI_ESDE_UID is null             --aks 21july
                 , l_rec_edi_data.DISCHARGE_TERMINAL
                 , l_n_esdj_uid  --aks 21july
                );

               /*PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , l_rec_edi_data.VOYAGE_NUMBER
             , l_rec_edi_data.SERVICE
             , l_rec_edi_data.VESSEL
             , l_rec_edi_data.DIRECTION
             , l_rec_edi_data.PORT_OF_DISCHARGE
             , 20
             , p_i_v_activity_code
             , l_n_esdj_uid
              );*/


--                  l_arr_var_name := STRING_ARRAY
--                  ('p_i_v_eme_uid'      , 'l_v_edi_etd_uid'   , 'p_i_v_voyage'
--                 , 'p_i_v_service'      , 'p_i_v_vessel'      , 'p_i_v_direction'
--                 , 'p_i_v_port'         , 'p_i_v_20'          , 'Activity_Code'
--                 , 'l_n_edi_esdj_uid'
--                  );
--
--                  l_arr_var_value := STRING_ARRAY
--                  (p_i_n_eme_uid                         , l_v_edi_etd_uid              , l_rec_edi_data.VOYAGE_NUMBER
--                 , l_rec_edi_data.SERVICE                , l_rec_edi_data.VESSEL        , l_rec_edi_data.DIRECTION
--                 , l_rec_edi_data.PORT_OF_DISCHARGE      , 20                           , NULL
--                 , l_n_esdj_uid
--                  );
--
--                  l_arr_var_io := STRING_ARRAY
--                  ('I'      , 'I'      , 'I'
--                 , 'I'      , 'I'      , 'I'
--                 , 'I'      , 'I'      , 'I'
--                 , 'O'
--                  );
--
--                  PRE_LOG_INFO
--                  ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                 , l_v_obj_nm
--                 , g_v_sql_id
--                 , p_i_v_user_id
--                 , l_t_log_info
--                 , NULL
--                 , l_arr_var_name
--                 , l_arr_var_value
--                 , l_arr_var_io
--                   );

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue to next step...');
                    p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                    l_b_raise_exp := TRUE;

                    g_record_filter := NULL;
                    g_record_table  := 'Error in populating EDI_ST_DOC_COMM data.';

--                    PRE_LOG_INFO
--                     ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , p_i_v_user_id
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                    , NULL
--                    , NULL
--                    , NULL
--                     );
            END;

            --aks 04july add for reference IVN
            g_v_sql_id := '13';
              l_v_invoyageno :=
                 pkg_edi_document.get_in_voyage_no (  l_rec_edi_data.SERVICE
                                                    , l_rec_edi_data.VESSEL
                                                    , l_rec_edi_data.VOYAGE_NUMBER
                                                   );

             /* IF l_v_invoyageno IS NOT NULL
              THEN
                 pkg_edi_document.prc_insert_reference (  l_v_edi_etd_uid
                                                        , 'IVN'
                                                        , l_v_invoyageno
                                                        , g_v_upd_by_edi
                                                          , NULL
                                                        , NULL
                                                        , NULL
                                                        , NULL
                                                       );
              END IF;*/

            -- Step 7  : Populate data in  EDI_ST_DOC_LOCATION
            BEGIN

                /*g_v_sql_id := '13';
                l_v_obj_nm := 'EDI_ESDL_SEQ.NEXTVAL';
                SELECT EDI_ESDL_SEQ.NEXTVAL
                INTO l_n_edi_esdl_uid
                FROM DUAL;*/

                g_v_sql_id := '14';
                l_v_obj_nm := 'ITP040';
                SELECT
                      PICODE
                    , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_NAME',PINAME)
                    , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_COUNTY',PIST)
                    , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_COUNTRY',PICNCD)
                INTO
                      l_v_picode
                    , l_v_piname
                    , l_v_pist
                    , l_v_picncd
                FROM ITP040
                WHERE PICODE = l_rec_edi_data.ACTIVITY_PORT;

                g_v_sql_id := '15';
                l_v_obj_nm := 'ITP130';
                SELECT
                      TQTORD
                    , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_SUB_NAME',TQTRNM)
                INTO
                      l_v_tqtord
                    , l_v_tqtrnm
                FROM ITP130
                WHERE TQTERM = p_i_v_terminal;

                g_v_sql_id := '16';
                /* --commented 21 july for create voyage
                IF p_i_v_activity_code = 'D' THEN
                   l_v_port_qualifer := '11';
                ELSIF p_i_v_activity_code = 'L' THEN
                   l_v_port_qualifer := '9';
                END IF;

               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
               PKG_EDI_DOCUMENT.PRC_CREATE_PORT
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , l_n_esdj_uid   --NULL  --aks 4july change from null
             , NULL
             , l_v_picode
             , l_v_tqtord
             , l_v_port_qualifer
             , l_n_edi_esdl_uid
              );*/

--                 l_arr_var_name := STRING_ARRAY
--                ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
--               , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
--               , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--                 );
--
--                l_arr_var_value := STRING_ARRAY
--               (p_i_n_eme_uid                , l_v_edi_etd_uid     , NULL
--              , NULL                         , l_v_picode          , l_v_tqtord
--              , l_v_port_qualifer            , l_n_edi_esdl_uid
--               );
--
--               l_arr_var_io := STRING_ARRAY
--              ('I'      , 'I'      , 'I'
--             , 'I'      , 'I'      , 'I'
--             , 'I'      , 'O'
--              );
--
--               PRE_LOG_INFO
--              ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--             , l_v_obj_nm
--             , g_v_sql_id
--             , p_i_v_user_id
--             , l_t_log_info
--             , NULL
--             , l_arr_var_name
--             , l_arr_var_value
--             , l_arr_var_io
--              );


            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                    p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                    l_b_raise_exp := TRUE;

                    g_record_filter := 'PICODE:'|| l_rec_edi_data.ACTIVITY_PORT ||
                                       ' TQTERM:'|| p_i_v_terminal;
                    g_record_table  := 'Record not found in ITP130 or ITP040 table.';

--                    PRE_LOG_INFO
--                     ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , p_i_v_user_id
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                    , NULL
--                    , NULL
--                    , NULL
--                     );
            END;

            -- Step 8 : Populate data in  EDI_ST_DOC_DATE (Arrival Date)
            BEGIN

                /*g_v_sql_id := '17';
                l_v_obj_nm := 'EDI_ESDD_SEQ.NEXTVAL';
                SELECT EDI_ESDD_SEQ.NEXTVAL
                INTO l_v_edi_esdd_seq
                FROM DUAL;*/

                g_v_sql_id := '18';
                l_v_obj_nm := 'ITP063';
                dbms_output.put_line (l_rec_edi_data.VESSEL
                ||'~'|| l_rec_edi_data.VOYAGE_NUMBER
                ||'~'|| l_rec_edi_data.ACTIVITY_PORT
                ||'~'|| l_rec_edi_data.PORT_SEQUENCE_NO
                ||'~'|| l_rec_edi_data.SERVICE
                ||'~'|| l_rec_edi_data.VESSEL
                ||'~'|| l_rec_edi_data.DIRECTION
                ||'~'|| l_rec_edi_data.ACTIVITY_PORT
                );

              IF p_i_v_activity_code = 'D' THEN
                SELECT  TO_DATE(VVARDT || LPAD(NVL(VVARTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
                        , TO_DATE(VVSLDT || LPAD(NVL(VVSLTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
                INTO
                        l_v_arrival_date
                        , l_v_sailing_date
                FROM ITP063
                WHERE VOYAGE_ID =
                    (SELECT DISTINCT VOYAGE_ID FROM ITP063 I
                    WHERE VVVERS   = 99
                    AND VVVESS     = l_rec_edi_data.VESSEL
                    AND INVOYAGENO = l_rec_edi_data.VOYAGE_NUMBER
                    -- AND    VVFORL IS NOT NULL -- *1
                    AND    (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) -- *1
                    AND VVPCAL     = l_rec_edi_data.ACTIVITY_PORT
                    AND VVPCSQ     = l_rec_edi_data.PORT_SEQUENCE_NO) -- added by vikas as suggested by watcharee, on 20.10.2011
                AND VVSRVC         = l_rec_edi_data.SERVICE
                AND VVVESS         = l_rec_edi_data.VESSEL
                AND VVPDIR         = l_rec_edi_data.DIRECTION
                AND VVVERS         = 99
                AND VVRCST         = 'A'
                -- AND    VVFORL IS NOT NULL -- *1
                AND    (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) -- *1
                AND VVPCAL         = l_rec_edi_data.ACTIVITY_PORT
                AND VVPCSQ         = l_rec_edi_data.PORT_SEQUENCE_NO;
            END IF;

            /*vikas: change block start to get arrival date and sailing date for load list, 21.10.2011 */
            IF p_i_v_activity_code = 'L' THEN
                SELECT    TO_DATE(VVARDT || LPAD(NVL(VVARTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
                        , TO_DATE(VVSLDT || LPAD(NVL(VVSLTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
                INTO
                          l_v_arrival_date
                        , l_v_sailing_date
                FROM ITP063
                WHERE VOYAGE_ID =
                    (SELECT DISTINCT VOYAGE_ID FROM ITP063 I
                    WHERE VVVERS   = 99
                    AND VVVESS     = l_rec_edi_data.VESSEL
                    AND VVVOYN = l_rec_edi_data.VOYAGE_NUMBER
                    -- AND    VVFORL IS NOT NULL -- *1
                    AND    (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) -- *1
                    AND VVPCAL     = l_rec_edi_data.ACTIVITY_PORT
                    AND VVPCSQ     = l_rec_edi_data.PORT_SEQUENCE_NO) -- added by vikas as suggested by watcharee, on 20.10.2011
                AND VVSRVC         = l_rec_edi_data.SERVICE
                AND VVVESS         = l_rec_edi_data.VESSEL
                AND VVPDIR         = l_rec_edi_data.DIRECTION
                AND VVVERS         = 99
                AND VVRCST         = 'A'
                -- AND    VVFORL IS NOT NULL -- *1
                AND    (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) -- *1
                AND VVPCAL         = l_rec_edi_data.ACTIVITY_PORT
                AND VVPCSQ         = l_rec_edi_data.PORT_SEQUENCE_NO;
            END IF;

            /*vikas: change block start to get arrival date and sailing date for load list, 21.10.2011 */
                --aks 4july commented
                /*IF (l_v_arrival_date > SYSDATE) THEN
                    l_v_arrival_code := '178';
                ELSE
                    l_v_arrival_code := '132';
                END IF;

                IF (l_v_sailing_date > SYSDATE) THEN
                    l_v_sailing_code := '136';
                ELSE
                    l_v_sailing_code := '133';
                END IF;*/

                l_v_arrival_code := '132';
                l_v_sailing_code := '133';

                g_v_sql_id := '19';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
               PKG_EDI_DOCUMENT.PRC_CREATE_DATE
               (l_v_edi_etd_uid
              , l_n_edi_esdl_uid
              , l_v_arrival_date
              , l_v_arrival_code
                );

--                l_arr_var_name := STRING_ARRAY
--               ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
--              , 'p_date_type'
--                );
--
--               l_arr_var_value := STRING_ARRAY
--              (l_v_edi_etd_uid                , l_n_edi_esdl_uid     , l_v_arrival_date
--             , l_v_arrival_code
--               );
--
--               l_arr_var_io := STRING_ARRAY
--              ('I'      , 'I'      , 'I'
--             , 'I'
--               );
--
--              PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , NULL
--                , l_arr_var_name
--                , l_arr_var_value
--                , l_arr_var_io
--                 );

                -- Step 9 : Populate data in  EDI_ST_DOC_DATE (Sailing Date)
                /*g_v_sql_id := '20';
                l_v_obj_nm := 'EDI_ESDD_SEQ.NEXTVAL';
                SELECT EDI_ESDD_SEQ.NEXTVAL
                INTO l_v_edi_esdd_seq
                FROM DUAL;*/

                g_v_sql_id := '21';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
               PKG_EDI_DOCUMENT.PRC_CREATE_DATE
               (l_v_edi_etd_uid
              , l_n_edi_esdl_uid
              , l_v_sailing_date
              , l_v_sailing_code
                );

--                l_arr_var_name := STRING_ARRAY
--               ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
--              , 'p_date_type'
--                );
--
--               l_arr_var_value := STRING_ARRAY
--              (l_v_edi_etd_uid                , l_n_edi_esdl_uid     , l_v_sailing_date
--             , l_v_sailing_code
--               );
--
--               l_arr_var_io := STRING_ARRAY
--              ('I'      , 'I'      , 'I'
--             , 'I'
--               );
--
--              PRE_LOG_INFO
--             ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , p_i_v_user_id
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--             );


            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                    p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                    l_b_raise_exp := TRUE;

                    g_record_filter := 'VOYAGE_ID:' || l_rec_edi_data.VOYAGE_NUMBER ||
                                        'VVSRVC:' || l_rec_edi_data.SERVICE ||
                                        'VVVESS:' || l_rec_edi_data.VESSEL ||
                                        'VVPDIR:' || l_rec_edi_data.DIRECTION ||
                                        'VVVERS:' || '99' ||
                                        'VVRCST:' || 'A' ||
                                        'VVFORL IS NOT null' ||
                                        'VVPCAL:' || l_rec_edi_data.ACTIVITY_PORT ;
                    g_record_table  := 'Arrival date and sailing date not found in ITP063 table.';

--                    PRE_LOG_INFO
--                     ('PCE_ECM_
--
--                     _LIST.PRE_ECM_GENERATE_EDI'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , p_i_v_user_id
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                    , NULL
--                    , NULL
--                    , NULL
--                     );
            END;
         --commented 22 july aks
         -- aks 4july added
         /** If Port of Loading  */
         /*IF p_i_v_activity_code = 'L'
         THEN
            BEGIN
               SELECT vvpcal, vvtrm1,
                      TO_DATE (vvardt || LPAD (NVL (vvartm, 1200), 4, 0),
                               'YYYYMMDDHH24MI'
                              ),
                      TO_DATE (vvsldt || LPAD (NVL (vvsltm, 1200), 4, 0),
                               'YYYYMMDDHH24MI'
                              )
                 INTO l_v_activity_port, l_v_activity_terminal,
                      l_v_arrival_date,
                      l_v_sailing_date
                 FROM itp063
                WHERE voyage_id = l_rec_edi_data.VOYAGE_NUMBER
                  AND vvsrvc = l_rec_edi_data.SERVICE
                  AND vvvess = l_rec_edi_data.VESSEL
                  AND vvsdir = l_rec_edi_data.DIRECTION
                  AND vvvers = 99
                  AND vvrcst = 'A'
                  AND vvforl = 'F'
                  AND ROWNUM = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_v_activity_port := NULL;
                  l_v_arrival_date  := NULL;
                  l_v_sailing_date  := NULL;
            END;

            IF l_v_activity_port IS NOT NULL
            THEN

                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                              (p_i_n_eme_uid
                             , l_v_edi_etd_uid
                             , l_n_esdj_uid  --NULL  --aks 4july change from null
                             , NULL
                             , l_v_activity_port
                             , l_v_activity_terminal
                             , '9'
                             , l_n_edi_esdl_uid
                              );

                IF l_n_edi_esdl_uid IS NOT NULL
                THEN
                   l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE-';
                   PKG_EDI_DOCUMENT.PRC_CREATE_DATE
                                   (l_v_edi_etd_uid
                                  , l_n_edi_esdl_uid
                                  , l_v_arrival_date
                                  , '132'
                                    );

                   l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
                   PKG_EDI_DOCUMENT.PRC_CREATE_DATE
                                   (l_v_edi_etd_uid
                                  , l_n_edi_esdl_uid
                                  , l_v_sailing_date
                                  , '133'
                                    );
                END IF;
            END IF;
         END IF; --end if of Port of Loading
         */
         --commented 22 july aks
         /** If Port of Discharge  */
         --AKS 13JULY this code is alredy happening in prc_create_voyage
         /*IF p_i_v_activity_code = 'D'
         THEN
            BEGIN
               SELECT vvpcal, vvtrm1,
                      TO_DATE (vvardt || LPAD (NVL (vvartm, 1200), 4, 0),
                               'YYYYMMDDHH24MI'
                              ),
                      TO_DATE (vvsldt || LPAD (NVL (vvsltm, 1200), 4, 0),
                               'YYYYMMDDHH24MI'
                              )
                 INTO l_v_activity_port, l_v_activity_terminal,
                      l_v_arrival_date,
                      l_v_sailing_date
                 FROM itp063
                WHERE voyage_id = l_rec_edi_data.VOYAGE_NUMBER
                  AND vvsrvc = l_rec_edi_data.SERVICE
                  AND vvvess = l_rec_edi_data.VESSEL
                  AND vvsdir = l_rec_edi_data.DIRECTION
                  AND vvvers = 99
                  AND vvrcst = 'A'
                  AND vvforl = 'L'
                  AND ROWNUM = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_v_activity_port := NULL;
                  l_v_arrival_date  := NULL;
                  l_v_sailing_date  := NULL;
            END;

            IF l_v_activity_port IS NOT NULL
            THEN

                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                              (p_i_n_eme_uid
                             , l_v_edi_etd_uid
                             , l_n_esdj_uid  --NULL  --aks 4july change from null
                             , NULL
                             , l_v_activity_port
                             , l_v_activity_terminal
                             , '11'
                             , l_n_edi_esdl_uid
                              );

                IF l_n_edi_esdl_uid IS NOT NULL
                THEN
                   l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE-';
                   PKG_EDI_DOCUMENT.PRC_CREATE_DATE
                                   (l_v_edi_etd_uid
                                  , l_n_edi_esdl_uid
                                  , l_v_arrival_date
                                  , '132'
                                    );

                   l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
                   PKG_EDI_DOCUMENT.PRC_CREATE_DATE
                                   (l_v_edi_etd_uid
                                  , l_n_edi_esdl_uid
                                  , l_v_sailing_date
                                  , '133'
                                    );
                END IF;
            END IF;
         END IF; --end if of Port of Discharge*/
         ---end processing of create voyage details
         --**************************************************************
         --aks 4july move processing of create carrier above
/*--commented by aks 4july  LOCATION LOOP IS NOT REQUIRED
            -- Step 15 : Populate data for Each Port of Loading / Discharge
            g_v_sql_id := '33';
            FOR l_rec_edi_location_data IN l_cur_edi_location_data
            LOOP

                BEGIN

                    -- Step 15.1 : Populate data for EDI_ST_DOC_LOCATION
                    g_v_sql_id := '35';
                    l_v_obj_nm := 'ITP040';
                    SELECT
                          PICODE
                        , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_NAME',PINAME)
                        , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_COUNTY',PIST)
                        , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_COUNTRY',PICNCD)
                    INTO
                          l_v_picode
                        , l_v_piname
                        , l_v_pist
                        , l_v_picncd
                    FROM ITP040
                    WHERE PICODE = l_rec_edi_location_data.PORT;

                   g_v_sql_id := '36';
                    l_v_obj_nm := 'ITP130';
                    SELECT
                          TQTORD
                        , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_SUB_NAME',TQTRNM)
                    INTO
                          l_v_tqtord
                        , l_v_tqtrnm
                    FROM ITP130
                    WHERE TQTERM = l_rec_edi_location_data.TERMINAL;

                    g_v_sql_id := '37';
                    --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
                   l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
                   PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                  (p_i_n_eme_uid
                 , l_v_edi_etd_uid
                 , NULL
                 , NULL
                 , l_v_picode
                 , l_v_tqtord
                 , '72'
                 , l_n_edi_esdl_uid
                  );

                     l_arr_var_name := STRING_ARRAY
                    ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
                   , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
                   , 'p_port_qualifer'     , 'p_edi_esdl_uid'
                     );

                    l_arr_var_value := STRING_ARRAY
                   (p_i_n_eme_uid                , l_v_edi_etd_uid     , NULL
                  , NULL                         , l_v_picode          , l_v_tqtord
                  , '72'                         , l_n_edi_esdl_uid
                   );

                   l_arr_var_io := STRING_ARRAY
                  ('I'      , 'I'      , 'I'
                 , 'I'      , 'I'      , 'I'
                 , 'I'      , 'O'
                  );

                   PRE_LOG_INFO
                  ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                 , l_v_obj_nm
                 , g_v_sql_id
                 , p_i_v_user_id
                 , l_t_log_info
                 , NULL
                 , l_arr_var_name
                 , l_arr_var_value
                 , l_arr_var_io
                  );


                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                        p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                        l_b_raise_exp := TRUE;
                        PRE_LOG_INFO
                         ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                        , l_v_obj_nm
                        , g_v_sql_id
                        , p_i_v_user_id
                        , l_t_log_info
                        , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                        , NULL
                        , NULL
                        , NULL
                         );
                END;

                BEGIN

                    -- Step 15.2 : Populate data for EDI_ST_DOC_DATE (Arrival Date)


                    g_v_sql_id := '39';
                    l_v_obj_nm := 'ITP063';
                    SELECT
                          TO_DATE(VVARDT || LPAD(NVL(VVARTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
                        , TO_DATE(VVSLDT || LPAD(NVL(VVSLTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
                    INTO
                          l_v_arrival_date
                        , l_v_sailing_date
                    FROM ITP063
                    WHERE VOYAGE_ID = l_rec_edi_data.VOYAGE_NUMBER
                    AND VVSRVC      = l_rec_edi_data.SERVICE
                    AND VVVESS      = l_rec_edi_data.VESSEL
                    AND VVPDIR      = l_rec_edi_location_data.DIRECTION
                    AND VVVERS      = 99
                    AND VVRCST      = 'A'
                    AND VVFORL IS NOT null
                    AND VVPCAL      = l_rec_edi_location_data.PORT;

                    IF (l_v_arrival_date > SYSDATE) THEN
                        l_v_arrival_code := '178';
                    ELSE
                        l_v_arrival_code := '132';
                    END IF;

                    IF (l_v_sailing_date > SYSDATE) THEN
                        l_v_sailing_code := '136';
                    ELSE
                        l_v_sailing_code := '133';
                    END IF;

                    g_v_sql_id := '40';
                   --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
                   l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
                   PKG_EDI_DOCUMENT.PRC_CREATE_DATE
                   (l_v_edi_etd_uid
                  , l_n_edi_esdl_uid
                  , l_v_arrival_date
                  , l_v_arrival_code
                    );

                    l_arr_var_name := STRING_ARRAY
                   ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
                  , 'p_date_type'
                    );

                   l_arr_var_value := STRING_ARRAY
                  (l_v_edi_etd_uid                , l_n_edi_esdl_uid     , l_v_arrival_date
                 , l_v_arrival_code
                   );

                   l_arr_var_io := STRING_ARRAY
                  ('I'      , 'I'      , 'I'
                 , 'I'
                  );

                  PRE_LOG_INFO
                  ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                 , l_v_obj_nm
                 , g_v_sql_id
                 , p_i_v_user_id
                 , l_t_log_info
                 , NULL
                 , l_arr_var_name
                 , l_arr_var_value
                 , l_arr_var_io
                 );



                    -- Step 15.3 : Populate data for EDI_ST_DOC_DATE (Sailing Date)
                    g_v_sql_id := '42';
                   --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
                   l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
                   PKG_EDI_DOCUMENT.PRC_CREATE_DATE
                   (l_v_edi_etd_uid
                  , l_n_edi_esdl_uid
                  , l_v_sailing_date
                  , l_v_sailing_code
                    );

                    l_arr_var_name := STRING_ARRAY
                   ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
                  , 'p_date_type'
                    );

                   l_arr_var_value := STRING_ARRAY
                  (l_v_edi_etd_uid                , l_n_edi_esdl_uid     , l_v_sailing_date
                 , l_v_sailing_code
                   );

                   l_arr_var_io := STRING_ARRAY
                  ('I'      , 'I'      , 'I'
                 , 'I'
                  );

                  PRE_LOG_INFO
                  ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                 , l_v_obj_nm
                 , g_v_sql_id
                 , p_i_v_user_id
                 , l_t_log_info
                 , NULL
                 , l_arr_var_name
                 , l_arr_var_value
                 , l_arr_var_io
                 );

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                        p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                        l_b_raise_exp := TRUE;
                        PRE_LOG_INFO
                         ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                        , l_v_obj_nm
                        , g_v_sql_id
                        , p_i_v_user_id
                        , l_t_log_info
                        , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                        , NULL
                        , NULL
                        , NULL
                         );
                END;

            END LOOP;
            */--commented by aks 4july
           --added aks 13 july--commented
           --get terminal FOR POD
         /*  BEGIN
                SELECT TO_TERMINAL
                INTO l_v_pod_term
                FROM BOOKING_VOYAGE_ROUTING_DTL
                WHERE DISCHARGE_PORT  = l_rec_edi_data.BAPOD
                  AND BOOKING_NO      = l_rec_edi_data.BOOKING_NO
                  AND ROWNUM =1;
           EXCEPTION
               l_v_pod_term :=  l_rec_edi_data.BAPOD;
           END;*/

        END IF; --end if of l_b_first_rec

        --start processing for all equipment aks 4july

        --Equipment Status
        /*
        IF p_i_v_activity_code = 'L' AND l_rec_edi_data.PORT_OF_LOADING = l_rec_edi_data.BAPOL THEN
            l_v_equipment_status := '2'; --Export
        ELSIF p_i_v_activity_code = 'D' AND l_rec_edi_data.PORT_OF_DISCHARGE = l_rec_edi_data.BAPOD THEN
            l_v_equipment_status := '3'; --Import
        ELSE
            l_v_equipment_status := '6'; --Transhipment
        END IF;

        */

        -- Shipment Type
        IF    l_rec_edi_data.SHIPMENT_TYPE = 'FCL'
           OR l_rec_edi_data.SHIPMENT_TYPE = 'LCL'
        THEN
           l_v_shipment_type := 'CN';
           l_v_full_mt       := l_rec_edi_data.FULL_MT;
        ELSIF l_rec_edi_data.SHIPMENT_TYPE = 'BBK'
        THEN
           l_v_shipment_type := 'AI'; --BB  change by vikas as req. by k'chatgamol, 21.11.2011
           l_v_full_mt := 'UC';
        ELSIF l_rec_edi_data.SHIPMENT_TYPE = 'UC'
        THEN
           l_v_shipment_type := 'BB';
           l_v_full_mt := 'UC';
        ELSE
           l_v_shipment_type := 'CN';
           l_v_full_mt := l_rec_edi_data.FULL_MT;
        END IF;

         -- Set standard values
         g_v_sql_id := '36';
        BEGIN
           SELECT STMTWT, UOM_MEASURE_METRIC
             INTO l_cnt_weight_uom, l_cnt_volume_uom
             FROM ITP0TD
            WHERE ROWNUM = 1;
        EXCEPTION
           WHEN OTHERS
           THEN
              l_cnt_weight_uom := NULL;
              l_cnt_volume_uom := NULL;
        END;

            IF l_cnt_weight_uom IS NOT NULL
            THEN
              g_v_sql_id := '37';
               pkg_edi_transaction.pro_data_translation_out
                                                         (p_i_n_eme_uid,
                                                          'GROSS_WEIGHT_UOM',
                                                          l_cnt_weight_uom,
                                                          l_cnt_weight_uom_t
                                                         );
            ELSE
               l_cnt_weight_uom_t := 'KGM';
            END IF;

            IF l_cnt_volume_uom IS NOT NULL
            THEN
              g_v_sql_id := '38';
               pkg_edi_transaction.pro_data_translation_out (p_i_n_eme_uid,
                                                             'VOLUME_UOM',
                                                             l_cnt_volume_uom,
                                                             l_cnt_volume_uom_t
                                                            );
            ELSE
               l_cnt_volume_uom_t := 'MTQ';
            END IF;
            g_v_sql_id := '39';
            pkg_edi_transaction.pro_data_translation_out (p_i_n_eme_uid,
                                                          'LENGTH_UOM',
                                                          'CMT',
                                                          l_cnt_length_uom
                                                         );
            --Get Temperature UOM
            IF l_rec_edi_data.TEMPERATURE_UOM = 'F'
            THEN
               l_v_temperature_uom := 'FAH';
            ELSE
               l_v_temperature_uom := 'CEL';
            END IF;
            g_v_sql_id := '40';
            IF l_v_temperature_uom IS NOT NULL
            THEN
               pkg_edi_transaction.pro_data_translation_out
                                                          (p_i_n_eme_uid,
                                                           'TEMPERATURE_UOM',
                                                           l_v_temperature_uom,
                                                           l_v_temperature_uom_t
                                                          );
            END IF;
            --GET BL DETAILS
            g_v_sql_id := '41';
            BEGIN
               SELECT AYBLNO, EYCMSQ, FINAL_PLACE_OF_DELIVERY_CODE
                 INTO l_v_bill_of_lading, l_v_sequence, l_v_place_of_delivery_n
                 FROM IDP010 BL, IDP055 BLEQP
                WHERE BL.AYBKNO = l_rec_edi_data.BOOKING_NO
                  AND BL.AYBLNO = BLEQP.EYBLNO
                  AND BLEQP.EYEQNO = l_rec_edi_data.CONTAINER_NO;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_v_bill_of_lading       := NULL;
                  l_v_sequence               := NULL;
                  l_v_place_of_delivery_n := NULL;
            END;
            g_v_sql_id := '42';
            BEGIN
               -- Bill of Lading not created, use the booking
               SELECT BIHAZD,
                      BADSTN, BAORGN,
                      SPECIAL_HANDLING, BIREFR,
                      PACKAGE_KIND
                 INTO l_v_hazardous,
                      l_v_place_of_delivery, l_v_place_of_receipt,
                      l_v_special_handling, l_v_birefr,
                      l_v_package_type
                 FROM BKP001 BK, BKP009 BKEQP
                WHERE BKEQP.BIBKNO = l_rec_edi_data.BOOKING_NO
                  AND BKEQP.BICTRN = l_rec_edi_data.CONTAINER_NO
                  AND BKEQP.BIBKNO = BK.BABKNO;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;


        BEGIN
            -- Step 16 : Fetch data
            g_v_sql_id := '43';
            l_v_obj_nm := 'IDP055,IDP002,IDP010';
            DBMS_OUTPUT.PUT_LINE(p_i_n_eme_uid
                ||'~'||l_rec_edi_data.BOOKING_NO
                ||'~'|| l_rec_edi_data.CONTAINER_NO);


            SELECT    FE_TRANS_DATA(p_i_n_eme_uid,'SEAL_NUMBER_SH',IDP055.EYSSEL)
                    , FE_TRANS_DATA(p_i_n_eme_uid,'SEAL_NUMBER_CA',IDP055.EYCRSL)
                    , FE_TRANS_DATA(p_i_n_eme_uid,'SEAL_NUMBER_CU',IDP055.EYCSEL)
                    , FE_TRANS_DATA(p_i_n_eme_uid,'PIECE_COUNT',IDP055.EYPCKG)
                    , FE_TRANS_DATA(p_i_n_eme_uid,'PACKAGE_TYPE',IDP055.EYKIND)
                    --, FE_TRANS_DATA(p_i_n_eme_uid,'MOVEMENT_TYPE',IDP055.EYDANG)
                    --, FE_TRANS_DATA(p_i_n_eme_uid,'HAULAGE_ARRANGEMENT',DECODE(IDP055.EYPCKG,1,1,2,2))
                    --, FE_TRANS_DATA(p_i_n_eme_uid,'NATURE_OF_CARGO',IDP055.EYKIND)
                    , IDP055.EYBLNO
            INTO
                      l_v_sl_no_sh
                    , l_v_sl_no_ca
                    , l_v_sl_no_cu
                    , l_v_piece_count
                    , l_v_package_type
                    --, l_v_movement_type
                    --, l_v_haulage_arrang
                    --, l_v_nature_of_cargo
                    , l_v_bl_no
            FROM  IDP055 IDP055
                , IDP002 IDP002
                , IDP010 IDP010
            WHERE IDP055.EYBLNO    = IDP002.TYBLNO
            AND IDP055.EYBLNO      = IDP010.AYBLNO
            AND IDP002.TYBLNO      = IDP010.AYBLNO
            AND IDP010.AYSTAT     >= 1
            AND IDP010.AYSTAT     <= 6
            AND IDP010.PART_OF_BL IS NULL
            AND IDP002.TYBKNO      = l_rec_edi_data.BOOKING_NO
            AND IDP055.EYEQNO      = l_rec_edi_data.CONTAINER_NO
            AND ROWNUM             = 1;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := substr(SQLCODE || '~' || SQLERRM, 1, 10);
--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
                l_v_sl_no_sh        := NULL;
                l_v_sl_no_ca        := NULL;
                l_v_sl_no_cu        := NULL;
                l_v_piece_count     := NULL;
                l_v_package_type    := NULL;
                --l_v_movement_type   := NULL;
                --l_v_haulage_arrang  := NULL;
                --l_v_nature_of_cargo := NULL;
                l_v_bl_no           := NULL;
        END;

        BEGIN
            -- Step 16 : Fetch data
            g_v_sql_id := '243';
            l_v_obj_nm := 'ITP070';
            SELECT    FROM_LOCATION_TYPE
                    , TO_LOCATION_TYPE
            INTO
                      l_v_movement_from
                    , l_v_movement_to
            FROM  ITP070
            WHERE MMMODE   =  l_rec_edi_data.SHIPMENT_TERM
            AND ROWNUM     =  1;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
                l_v_movement_from   := NULL;
                l_v_movement_to     := NULL;
        END;

        IF l_v_movement_from <> 'D'
        THEN
           l_v_movement_from := 'P';
        END IF;

        IF l_v_movement_to <> 'D'
        THEN
           l_v_movement_to := 'P';
        END IF;

        l_v_movement_type := NULL;
        IF l_v_movement_from IS NOT NULL AND l_v_movement_to IS NOT NULL THEN
           IF l_v_movement_from = 'P' AND l_v_movement_to = 'P' THEN
              l_v_movement_type := '2';
           ELSIF l_v_movement_from = 'D' AND l_v_movement_to = 'D' THEN
              l_v_movement_type := '3';
           ELSIF l_v_movement_from = 'D' AND l_v_movement_to = 'P' THEN
              l_v_movement_type := '4';
           ELSIF l_v_movement_from = 'P' AND l_v_movement_to = 'D' THEN
              l_v_movement_type := '5';
           END IF;
        END IF;

        BEGIN
            -- Step 16 : Fetch data
            g_v_sql_id := '244';
            l_v_obj_nm := 'BKP001';
            SELECT    ORIGIN_HAULAGE
            INTO
                      l_v_haulage_arrang
            FROM  BKP001
            WHERE BABKNO   =  l_rec_edi_data.BOOKING_NO;

            IF l_v_haulage_arrang = 'M'
            THEN
               l_v_haulage_arrang := '2';
               --Merchant (Haulage arranged by merchant (shipper, consignee,or their agent).)
            ELSE
               l_v_haulage_arrang := '1';
               --Carrier( Haulage arranged by carrier.)
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
                l_v_haulage_arrang   := NULL;
        END;

        BEGIN
            -- Step 16 : Fetch data
            g_v_sql_id := '245';
            l_v_obj_nm := 'BKP009';
            SELECT    PACKAGE_KIND
            INTO
                      l_v_nature_of_cargo
            FROM  BKP009
            WHERE BIBKNO   =  l_rec_edi_data.BOOKING_NO
            AND   BISEQN   =  l_rec_edi_data.CONTAINER_SEQ_NO;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := substr(SQLCODE || '~' || SQLERRM, 1, 10);
--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
                l_v_nature_of_cargo   := NULL;
        END;

        BEGIN
            -- Step 16 : Populate data for EDI_ST_DOC_EQUIPMENT

            g_v_sql_id := '143';
            dbms_output.put_line(p_i_n_eme_uid
                ||'~'|| l_rec_edi_data.EQ_SIZE
                ||'~'|| l_rec_edi_data.EQ_TYPE);
            l_v_obj_nm := 'ITP076';
            SELECT    FE_TRANS_DATA(p_i_n_eme_uid,'EQUIPMENT_SIZE_TYPE',ITP076.ISSIZE
                    ||ITP076.ISTYPE)
                    , FE_TRANS_DATA(p_i_n_eme_uid,'TYPE_DESCRIPTION',ITP076.ISDESC)
            INTO
                      l_v_sizetype
                    , l_v_type_desc
            FROM  ITP076 ITP076
            WHERE ITP076.ISSIZE = l_rec_edi_data.EQ_SIZE
            AND   ITP076.ISTYPE = l_rec_edi_data.EQ_TYPE
            AND   ROWNUM        = 1;

            g_v_sql_id := '44';
            l_v_obj_nm := 'EDI_ESDE_SEQ.NEXTVAL';
            SELECT EDI_ESDE_SEQ.NEXTVAL
            INTO l_n_edi_esde_seq
            FROM DUAL;
/*
            INSERT INTO ECM_LOG_TRACE(
                  PROG_ID
                , PROG_SQL
                , RECORD_STATUS
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
                , RECORD_CHANGE_USER
                , RECORD_CHANGE_DATE)
            VALUES
            (
                'DDL'
                ,l_n_msg_reference
                    ||'~'|| l_n_edi_esde_seq
                    ||'~'|| l_v_edi_etd_uid
                    ||'~'|| l_rec_edi_data.T_CONTAINER_NO
                ,'A'
                ,g_v_upd_by_edi
                ,SYSDATE
                ,g_v_upd_by_edi
                ,SYSDATE

            );
            -- commit;
        */

            g_v_sql_id := '45';
            INSERT INTO EDI_ST_DOC_EQUIPMENT (
                  EDI_ESDE_UID
                , EDI_ETD_UID
                , EQUIPMENT_TYPE
                , EQUIPMENT_NO
                , EQUIPMENT_SIZE_TYPE
                , TYPE_DESCRIPTION
                , EQUIPMENT_SUPPLIER
                , EQUIPMENT_STATUS
                , EQUIPMENT_FULL_EMPTY
                , GROSS_WEIGHT
                , GROSS_WEIGHT_UOM
                , LENGTH_UOM
                , OVERLENGTH_FRONT
                , OVERLENGTH_BACK
                , OVERWIDTH_RIGHT
                , OVERWIDTH_LEFT
                , OVERHEIGHT
                , TEMPERATURE
                , TEMPERATURE_MIN
                , TEMPERATURE_MAX
                , TEMPERATURE_UOM
                , SEAL_NUMBER_SH
                , SEAL_NUMBER_CA
                , SEAL_NUMBER_CU
                , HUMIDITY
                , AIR_EXCHANGE
                , HAZARDOUS
                , PIECE_COUNT
                , PACKAGE_TYPE
                , MOVEMENT_TYPE
                , HAULAGE_ARRANGEMENT
                , NATURE_OF_CARGO
                , RECORD_STATUS
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
            ) VALUES (
                  l_n_edi_esde_seq
                , l_v_edi_etd_uid
                , l_v_shipment_type
                , l_rec_edi_data.T_CONTAINER_NO
                , l_v_sizetype
                , l_v_type_desc
                , l_rec_edi_data.T_SOC_COC
                , l_v_equipment_status
                , l_v_full_mt
                , l_rec_edi_data.T_CONTAINER_GROSS_WEIGHT
                , l_cnt_weight_uom_t
                , l_cnt_length_uom
                , NVL(l_rec_edi_data.T_OOG_OLF,0)
                , NVL(l_rec_edi_data.T_OOG_OLB,0)
                , NVL(l_rec_edi_data.T_OOG_OWR,0)
                , NVL(l_rec_edi_data.T_OOG_OWL,0)
                , NVL(l_rec_edi_data.T_OOG_OH,0)
                , l_rec_edi_data.T_TEMPERATURE
                , l_rec_edi_data.T_TEMPERATURE
                , l_rec_edi_data.T_TEMPERATURE
                , l_v_temperature_uom
                 , regexp_replace(SUBSTR(l_v_sl_no_sh,1,17),'[^-a-zA-Z0-9]', '')  -- *28
                , regexp_replace(SUBSTR(l_v_sl_no_ca,1,17),'[^-a-zA-Z0-9]', '')  -- *28
                , regexp_replace(SUBSTR(l_v_sl_no_cu,1,17),'[^-a-zA-Z0-9]', '')   -- *28
            /* *28   , SUBSTR(trim(l_v_sl_no_sh),1,17)
                , SUBSTR(l_v_sl_no_ca,1,17)
                , SUBSTR(l_v_sl_no_cu,1,17)   *28 */
                , NVL(l_rec_edi_data.T_HUMIDITY,0)
                , NVL(l_rec_edi_data.T_VENTILATION,0)
                , l_v_hazardous
                , l_v_piece_count
              --*28 , SUBSTR(l_v_package_type,1,4)
                 , regexp_replace(SUBSTR(l_v_package_type,1,4),'[^-a-zA-Z0-9]', '') -- *28
                , pkg_edi_transaction.checkforouttrans(p_i_n_eme_uid,
                                                       'MOVEMENT_TYPE',
                                                       l_v_movement_type
                                                       )
                , l_v_haulage_arrang
                , l_v_nature_of_cargo
                , 'A'
                , g_v_upd_by_edi
                , g_v_sysdate
            );
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , 'EDI_ST_DOC_EQUIPMENT'
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , 'INSERT CALLED'
--           , NULL
--           , NULL
--           , NULL
--            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;

                g_record_filter :=  'EQ_SIZE:' || l_rec_edi_data.EQ_SIZE ||
                                    'EQ_TYPE:' || l_rec_edi_data.EQ_TYPE ;
                g_record_table  := 'Translated Size and type not found in ITP076 table.';

--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

        g_v_sql_id := '45A';


        /* Start add by Chatgamol*/
        IF (l_rec_edi_data.LOAD_CONDITION = 'B') and (l_rec_edi_data.PUBLIC_REMARK is not null) THEN
            g_v_sql_id := '45B';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                l_v_edi_etd_uid
                , NULL
                , NULL -- l_n_edi_esdco_seq
                , 'HAN'
                , NULL
                , 'BD'
                , g_v_upd_by_edi
                , l_n_edi_esde_seq
            );

          /* Modified by Dhruv Parekh on 09/11/2011
           * To convert comma sepearated PUBLIC_REMARK into array
           * BLOCK START
           */

            g_v_sql_id := '45c';
            v_string   := l_rec_edi_data.PUBLIC_REMARK;
            v_delimpos := INSTR(l_rec_edi_data.PUBLIC_REMARK, p_delim);
            v_delimlen := LENGTH(p_delim);

            g_v_sql_id := '45d';

            WHILE v_delimpos > 0
            LOOP
                v_table(v_nfields) := SUBSTR(v_string,1,v_delimpos-1);
                v_string := SUBSTR(v_string,v_delimpos+v_delimlen);
                v_nfields := v_nfields+1;
                v_delimpos := INSTR(v_string, p_delim);
            END LOOP;

            v_table(v_nfields) := v_string;
            g_v_sql_id := '45e';

            FOR i IN 1..v_nfields
            loop
                PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                                l_v_edi_etd_uid
                                , NULL
                                , NULL -- l_n_edi_esdco_seq
                                , 'AAA'
                                , v_table(i)
                                , NULL
                                , g_v_upd_by_edi
                                , l_n_edi_esde_seq
                                );
            END LOOP;
            /* BLOCK END*/
        END IF;

     /* End add by Chatgamol*/

        g_v_sql_id := '45f';

        /* Start added by Vikas, As requested by K' Chatgamol, on 07.11.2011 */
        IF (l_rec_edi_data.VENTILATION <> 0) THEN
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                l_v_edi_etd_uid
                , NULL
                , NULL -- l_n_edi_esdco_seq
                , 'OSI'
                , l_rec_edi_data.VENTILATION || NVL(SUBSTR(l_rec_edi_data.PUBLIC_REMARK, 1, 3), 'M')
                , NULL
                , g_v_upd_by_edi
                , l_n_edi_esde_seq
            );
        END IF;

        /* Start added by vikas, 01.12.2011 */
        g_v_sql_id := '45g';
        PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
            l_v_edi_etd_uid
            , NULL
            , NULL -- l_n_edi_esdco_seq
            , 'CON'
            , l_rec_edi_data.LOCAL_TERMINAL_STATUS
            , NULL
            , g_v_upd_by_edi
            , l_n_edi_esde_seq
        );
        /* End added by vikas, 01.12.2011 */

        /* End added by Vikas, As requested by K' Chatgamol, on 07.11.2011 */
         g_v_sql_id := '45h';
         SELECT DECODE (l_rec_edi_data.SHIPMENT_TYPE,
                           'LCL', '2',
                           'FCL', '3',
                           '3'
                          )
                INTO  l_v_ship_type
         FROM DUAL;

          g_v_sql_id := '45h';
         l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE-TMD';
         PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE
         (l_v_edi_etd_uid
        , 'TMD'
        , l_v_ship_type
        , g_v_upd_by_edi
        , l_n_edi_esde_seq
        , NULL
        , NULL
        , NULL
         );
/* testing block start */
        /* changes start by vikas 14/10/2011 as suggested by k'chatgamol for equipment status for issue# 575*/

        IF l_rec_edi_data.SOC_COC = 'C' THEN
            IF l_rec_edi_data.ACTIVITY_PORT = l_rec_edi_data.PLACE_OF_DELIVERY then
                l_v_equipment_status := '3'; --Import - it is  import

            ELSE
                l_v_equipment_status := '6';
                /* It is transhipment and transhipment data need to get from next vsl/voyage */
                FOR l_cur_sec_voyage_data IN l_cur_sec_voyage (l_rec_edi_data.BOOKING_NO
                                                             , l_rec_edi_data.VOYAGE_SEQNO)
                LOOP
                    IF l_rec_edi_data.ACTIVITY_PORT = l_rec_edi_data.FINAL_DISCHARGE_PORT THEN
                        l_v_location_type := '170';
                    ELSE
                        l_v_location_type := '13';
                    END IF;

/*
                INSERT INTO ECM_LOG_TRACE(
                      PROG_ID
                    , PROG_SQL
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE)
                VALUES
                (
                    'DDL'
                    ,'3'||'~'||l_rec_edi_data.SOC_COC||'~'||l_rec_edi_data.ACTIVITY_PORT||'~'||l_rec_edi_data.FINAL_DISCHARGE_PORT||'~'|| l_rec_edi_data.CONTAINER_NO
                    ,'A'
                    ,g_v_upd_by_edi
                    ,SYSDATE
                    ,g_v_upd_by_edi
                    ,SYSDATE

                );
                commit;
*/                   g_v_sql_id := '45i';
                    l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';
                    PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
                      (p_i_n_eme_uid,
                       l_v_edi_etd_uid
                     , l_cur_sec_voyage_data.VOYNO
                     , l_cur_sec_voyage_data.SERVICE
                     , l_cur_sec_voyage_data.VESSEL
                     , l_cur_sec_voyage_data.DIRECTION
                     , l_cur_sec_voyage_data.PORT
                     , 30
                     , p_i_v_activity_code
                     , l_n_edi_esde_seq
                     , l_cur_sec_voyage_data.TERMINAL
                     , l_n_esdj_uid
                      );


                END LOOP;

            END IF;
        END IF;

        IF l_rec_edi_data.SOC_COC = 'S' THEN
            IF (
                (l_rec_edi_data.FINAL_DISCHARGE_PORT = l_rec_edi_data.PLACE_OF_DELIVERY)
                AND (l_rec_edi_data.FINAL_DISCHARGE_PORT = l_rec_edi_data.ACTIVITY_PORT)
                AND l_rec_edi_data.NEXT_POD2 IS NULL
                AND l_rec_edi_data.MLO_VESSEL IS not NULL) THEN

                l_v_equipment_status := '6';

/*
                INSERT INTO ECM_LOG_TRACE(
                      PROG_ID
                    , PROG_SQL
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE)
                VALUES
                (
                    'DDL'
                    ,'4'||'~'||l_rec_edi_data.SOC_COC||'~'||l_rec_edi_data.ACTIVITY_PORT||'~'||l_rec_edi_data.PLACE_OF_DELIVERY||'~'|| l_rec_edi_data.FINAL_DISCHARGE_PORT ||'~'|| l_rec_edi_data.NEXT_POD2 ||'~'|| l_rec_edi_data.MLO_VESSEL||'~'|| l_rec_edi_data.CONTAINER_NO ||'~'|| l_v_equipment_status
                    ,'A'
                    ,g_v_upd_by_edi
                    ,SYSDATE
                    ,g_v_upd_by_edi
                    ,SYSDATE

                );
                commit;
  */
                /* added by vikas as when mlo_vessel is not null then need to direct insert
                on table rather then calling PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE,as chatgamol say 21.10.2011 */

                /* comment open by vikas as it needed for arriaval date for LL, 21.10.2011 */
                g_v_sql_id := '99';
                l_v_obj_nm := 'ITP060';
                BEGIN
                    SELECT    VSOPCD
                            , NVL(TO_CHAR(LOYD_NO), l_rec_edi_data.VESSEL)
                            , VSLGNM
                            , VSCNCD
                    INTO      l_v_vsopcd
                            , l_v_loyd_no
                            , l_v_vslgnm
                            , l_v_vscncd
                    FROM ITP060
                    WHERE VSVESS = l_rec_edi_data.MLO_VESSEL; -- l_rec_edi_data.MLO_VESSEL vikas, 24.10.2011
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_vsopcd   := NULL;
                        l_v_loyd_no  := NULL;
                        l_v_vslgnm   := NULL;
                        l_v_vscncd   := NULL;
                END;
                 g_v_sql_id := '99a';
                INSERT INTO EDI_ST_DOC_JOURNEY (
                      EDI_ESDJ_UID
                    , EDI_ETD_UID
                    , TRANSPORT_STAGE
                    , CONVEYANCE_REFERENCE
                    , TRANSPORT_MODE
                    , CARRIER_CODE
                    , CONVEYANCE_CODE
                    , CONVEYANCE_NAME
                    , CONVEYANCE_NATIONALITY
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE
                    , EDI_ESDE_UID
                    , TRANSPORT_MEANS
                ) VALUES (
                      EDI_ESDJ_SEQ.nextval
                    , l_v_edi_etd_uid
                    , '30'
                    , l_rec_edi_data.MLO_VOYAGE
                    , '1'
                    , NULL
                    , NULL
                    , l_rec_edi_data.MLO_VESSEL
                    , NULL
                    , 'A'
                    , g_v_upd_by_edi
                    , SYSDATE
                    , g_v_upd_by_edi
                    , SYSDATE
                    , l_n_edi_esde_seq
                    , '13'
                );

                /* Transhipment data need to get from MLO info *
                PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE(
                    p_i_n_eme_uid,
                    l_v_edi_etd_uid
                    , l_rec_edi_data.MLO_VOYAGE
                    , l_rec_edi_data.SERVICE
                    , l_rec_edi_data.MLO_VESSEL
                    , l_rec_edi_data.DIRECTION
                    , l_rec_edi_data.MLO_POD1
                    , 30
                    , p_i_v_activity_code
                    , NULL
                    , l_rec_edi_data.MLO_POD1
                    , l_n_esdj_uid
                );
                */
            ELSIF (
                (l_rec_edi_data.FINAL_DISCHARGE_PORT = l_rec_edi_data.PLACE_OF_DELIVERY)
                AND (l_rec_edi_data.FINAL_DISCHARGE_PORT = l_rec_edi_data.ACTIVITY_PORT)
                AND l_rec_edi_data.NEXT_POD2 IS NULL
                AND l_rec_edi_data.MLO_VESSEL IS NULL)  THEN

                l_v_equipment_status := '3'; --It is  import
/*
                INSERT INTO ECM_LOG_TRACE(
                      PROG_ID
                    , PROG_SQL
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE)
                VALUES
                (
                    'DDL'
                    ,'5'||'~'||l_rec_edi_data.SOC_COC||'~'||l_rec_edi_data.ACTIVITY_PORT||'~'||l_rec_edi_data.PLACE_OF_DELIVERY||'~'|| l_rec_edi_data.FINAL_DISCHARGE_PORT ||'~'|| l_rec_edi_data.NEXT_POD2 ||'~'|| l_rec_edi_data.MLO_VESSEL ||'~'|| l_rec_edi_data.CONTAINER_NO||'~'|| l_v_equipment_status
                    ,'A'
                    ,g_v_upd_by_edi
                    ,SYSDATE
                    ,g_v_upd_by_edi
                    ,SYSDATE

                );
                commit;

*/
            ELSIF l_rec_edi_data.NEXT_POD2 IS NOT NULL  THEN
                l_v_equipment_status := '6';

                /* Transhipment data need to get from next vsl/voyage */
                /*
                INSERT INTO ECM_LOG_TRACE(
                      PROG_ID
                    , PROG_SQL
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE)
                VALUES
                (
                    'DDL'
                    ,'6'||'~'||l_rec_edi_data.SOC_COC||'~'|| l_rec_edi_data.NEXT_POD2 ||'~'|| l_rec_edi_data.CONTAINER_NO||'~'|| l_v_equipment_status
                    ,'A'
                    ,g_v_upd_by_edi
                    ,SYSDATE
                    ,g_v_upd_by_edi
                    ,SYSDATE

                );
                commit;
*/
                FOR l_cur_sec_voyage_data IN l_cur_sec_voyage (l_rec_edi_data.BOOKING_NO
                                                             , l_rec_edi_data.VOYAGE_SEQNO)
                LOOP
                    IF l_rec_edi_data.ACTIVITY_PORT = l_rec_edi_data.FINAL_DISCHARGE_PORT THEN
                        l_v_location_type := '170';
                    ELSE
                        l_v_location_type := '13';
                    END IF;
/*
                INSERT INTO ECM_LOG_TRACE(
                      PROG_ID
                    , PROG_SQL
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE)
                VALUES
                (
                    'DDL'
                    ,'7'||'~'||l_rec_edi_data.SOC_COC||'~'||l_rec_edi_data.ACTIVITY_PORT||'~'||l_rec_edi_data.PLACE_OF_DELIVERY||'~'|| l_rec_edi_data.FINAL_DISCHARGE_PORT ||'~'|| l_rec_edi_data.NEXT_POD2 ||'~'|| l_rec_edi_data.MLO_VESSEL||'~'|| l_rec_edi_data.CONTAINER_NO ||'~'|| l_v_equipment_status
                    ,'A'
                    ,g_v_upd_by_edi
                    ,SYSDATE
                    ,g_v_upd_by_edi
                    ,SYSDATE

                );
                commit;
*/
                 g_v_sql_id := '99b';
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';
                    PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
                    (p_i_n_eme_uid,
                    l_v_edi_etd_uid
                    , l_cur_sec_voyage_data.VOYNO
                    , l_cur_sec_voyage_data.SERVICE
                    , l_cur_sec_voyage_data.VESSEL
                    , l_cur_sec_voyage_data.DIRECTION
                    , l_cur_sec_voyage_data.PORT
                    , 30
                    , p_i_v_activity_code
                    , l_n_edi_esde_seq
                    , l_cur_sec_voyage_data.TERMINAL
                    , l_n_esdj_uid
                    );

                END LOOP;

            END IF;
        END IF;
         g_v_sql_id := '99c';
        UPDATE EDI_ST_DOC_EQUIPMENT SET EQUIPMENT_STATUS = l_v_equipment_status
        WHERE EDI_ESDE_UID = l_n_edi_esde_seq
        AND EDI_ETD_UID = l_v_edi_etd_uid;

        /* changes end by vikas 14/10/2011 for equipment status */
/* testing block end  */
        -- Step 17 : Populate data for EDI_ST_DOC_LOCATION (Stowage Position)
        BEGIN

            /*g_v_sql_id := '46';
            l_v_obj_nm := 'EDI_ESDL_SEQ.NEXTVAL';
            SELECT EDI_ESDL_SEQ.NEXTVAL
            INTO l_n_edi_esdl_uid
            FROM DUAL;*/

               g_v_sql_id := '47';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';

            IF l_rec_edi_data.STOWAGE_POSITION IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                  (p_i_n_eme_uid
                 , l_v_edi_etd_uid
                 , NULL
                 , l_n_edi_esde_seq
                 , l_rec_edi_data.STOWAGE_POSITION
                 , NULL
                 , '147'
                 , l_n_edi_esdl_uid
                  );
            END IF;
--             l_arr_var_name := STRING_ARRAY
--            ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
--           , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
--           , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--             );
--
--            l_arr_var_value := STRING_ARRAY
--           (p_i_n_eme_uid                , l_v_edi_etd_uid                            , NULL
--          , NULL                         , l_rec_edi_data.STOWAGE_POSITION          , NULL
--          , '147'                        , l_n_edi_esdl_uid
--           );
--
--           l_arr_var_io := STRING_ARRAY
--          ('I'      , 'I'      , 'I'
--         , 'I'      , 'I'      , 'I'
--         , 'I'      , 'O'
--          );
--
--           PRE_LOG_INFO
--          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--         , l_v_obj_nm
--         , g_v_sql_id
--         , p_i_v_user_id
--         , l_t_log_info
--         , NULL
--         , l_arr_var_name
--         , l_arr_var_value
--         , l_arr_var_io
--          );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;
                g_record_filter :=  NULL;
                g_record_table  := 'Error occured when during creating voyage.';

--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

        -- Step 18 : Populate data for EDI_ST_DOC_REFERENCE (BM)
        BEGIN

         --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_REFERENCE FOR BM
          g_v_sql_id := '47a';
         l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE-BM';
         IF l_v_bl_no IS NOT NULL THEN
             PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE
             (l_v_edi_etd_uid
            , 'BM'
            , l_v_bl_no
            , g_v_upd_by_edi
            , l_n_edi_esde_seq
            , NULL
            , NULL
            , NULL
             );
         END IF;
--       l_arr_var_name := STRING_ARRAY
--       ('l_v_edi_etd_uid'      , 'p_i_v_bm_bl'           , 'p_i_v_bm_bl_descp'
--      , 'p_i_v_edi'            , 'l_n_edi_esde_uid'      , 'EDI_ESDL_UID'
--      , 'EDI_ESDJ_UID'         , 'EDI_ESDP_UID'
--        );
--
--        l_arr_var_value := STRING_ARRAY
--       (l_v_edi_etd_uid            , 'BM'                    , l_v_bl_no
--      , g_v_upd_by_edi             , l_n_edi_esde_seq        , NULL
--      , NULL                       , NULL
--        );
--
--        l_arr_var_io := STRING_ARRAY
--       ('I'      , 'I'      , 'I'
--      , 'I'      , 'I'      , 'I'
--      , 'I'      , 'I'
--        );
--
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , NULL
--           , l_arr_var_name
--           , l_arr_var_value
--           , l_arr_var_io
--            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;
                g_record_filter :=  NULL;
                g_record_table  := 'Error occured during insert reference.';

--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

        -- Step 19 : Populate data for EDI_ST_DOC_REFERENCE (BN)
        BEGIN

            g_v_sql_id := '50';
         --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_REFERENCE FOR BN
         l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE';
         PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE
         (l_v_edi_etd_uid
        , 'BN'
        , l_rec_edi_data.BOOKING_NO --aks 4july
        , g_v_upd_by_edi
        , l_n_edi_esde_seq
        , NULL
        , NULL
        , NULL
         );

--       l_arr_var_name := STRING_ARRAY
--       ('l_n_edi_etd_seq'      , 'p_i_v_bm_bl'           , 'p_i_v_bm_bl_descp'
--      , 'p_i_v_edi'            , 'l_n_edi_esde_uid'      , 'EDI_ESDL_UID'
--      , 'EDI_ESDJ_UID'         , 'EDI_ESDP_UID'
--        );
--
--        l_arr_var_value := STRING_ARRAY
--       (l_v_edi_etd_uid            , 'BN'                    , l_rec_edi_data.BOOKING_NO
--      , g_v_upd_by_edi             , l_n_edi_esde_seq        , NULL
--      , NULL                       , NULL
--        );
--
--        l_arr_var_io := STRING_ARRAY
--       ('I'      , 'I'      , 'I'
--      , 'I'      , 'I'      , 'I'
--      , 'I'      , 'I'
--        );
--
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , NULL
--           , l_arr_var_name
--           , l_arr_var_value
--           , l_arr_var_io
--            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;

                g_record_filter :=  NULL;
                g_record_table  := 'Error occured during insert reference.';

--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL.
--                , NULL
--                , NULL
--                 );
        END;

       -- Step 27 : Populate data for EDI_ST_DOC_TEXT (Handling)
        BEGIN
            --commented by aks 4july
            /*g_v_sql_id := '77';
            l_v_obj_nm := 'SHP007';
            SELECT SHI_DESCRIPTION
            INTO l_v_han_code
            FROM SHP007
            WHERE SHI_CODE = l_rec_edi_data.HANDLING_INSTRUCTION_1
            AND RECORD_STATUS = 'A';*/
            g_v_sql_id := '78';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR HANDLING_INSTRUCTION_1
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            --Insert handling instructions
            IF LENGTH (   l_rec_edi_data.HANDLING_INSTRUCTION_1
                       || l_rec_edi_data.HANDLING_INSTRUCTION_2
                       || l_rec_edi_data.HANDLING_INSTRUCTION_3
                      ) > 0 THEN

                PKG_EDI_DOCUMENT.PRC_INSERT_TEXT
                (l_v_edi_etd_uid
               , NULL
               , NULL
               , 'HAN'
               , l_v_han_code
               , l_rec_edi_data.HANDLING_INSTRUCTION_1
                  || l_rec_edi_data.HANDLING_INSTRUCTION_2
                  || l_rec_edi_data.HANDLING_INSTRUCTION_3
               , g_v_upd_by_edi
               , l_n_edi_esde_seq
                );
            END IF;
--             l_arr_var_name := STRING_ARRAY
--           ('l_n_edi_etd_seq'      , 'EDI_ESDH_UID'           , 'EDI_ESDCO_UID'
--          , 'p_i_v_hn_cr_flg'      , 'p_i_v_hn_cr_descp'      , 'p_i_v_hn_cr_code'
--          , 'p_i_v_edi'            , 'l_n_edi_esde_uid'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--           (l_v_edi_etd_uid         , NULL                       , NULL
--          , 'HAN'                   , l_v_han_code               , l_rec_edi_data.HANDLING_INSTRUCTION_1
--          , g_v_upd_by_edi          , l_n_edi_esde_seq
--            );
--
--            l_arr_var_io := STRING_ARRAY
--           ('I'      , 'I'      , 'I'
--          , 'I'      , 'I'      , 'I'
--          , 'I'      , 'I'
--            );
--
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , NULL
--           , l_arr_var_name
--           , l_arr_var_value
--           , l_arr_var_io
--            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

        /* *16 start * */
        IF l_rec_edi_data.CONTAINER_LOADING_REM_1 IS NOT NULL THEN
            BEGIN
                g_v_sql_id := 'SQL-01028';

                l_v_obj_nm := 'SHP041';

                SELECT CLR_DESC
                INTO   l_v_cont_ld_rem_desc1
                FROM   SHP041
                WHERE  CLR_CODE = l_rec_edi_data.CONTAINER_LOADING_REM_1;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_v_cont_ld_rem_desc1 := NULL;
            END;
        END IF;

        IF l_rec_edi_data.CONTAINER_LOADING_REM_2 IS NOT NULL THEN
            BEGIN
                g_v_sql_id := 'SQL-01029';

                l_v_obj_nm := 'SHP041';

                SELECT CLR_DESC
                INTO   l_v_cont_ld_rem_desc2
                FROM   SHP041
                WHERE  CLR_CODE = l_rec_edi_data.CONTAINER_LOADING_REM_2;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_v_cont_ld_rem_desc2 := NULL;
            END;
        END IF;


        g_v_sql_id := 'SQL-01033';
        IF l_v_cont_ld_rem_desc1 IS NOT NULL THEN
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR CONTAINER_LOADING_REM_1
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                l_v_edi_etd_uid
                ,  NULL
                , NULL
                , 'CLR'
                , l_v_cont_ld_rem_desc1
                , l_rec_edi_data.CONTAINER_LOADING_REM_1
                , g_v_upd_by_edi
                , l_n_edi_esde_seq
            );

        END IF;

        g_v_sql_id := 'SQL-01034';
        IF l_v_cont_ld_rem_desc2 IS NOT NULL THEN
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR CONTAINER_LOADING_REM_2
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                l_v_edi_etd_uid
                , NULL
                , NULL
                , 'CLR'
                , l_v_cont_ld_rem_desc2
                , l_rec_edi_data.CONTAINER_LOADING_REM_2
                , g_v_upd_by_edi
                , l_n_edi_esde_seq
            );
        END IF;

        G_V_SQL_ID := 'SQLa01034';
        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR CONTAINER_LOADING_REM_1
        IF ((L_REC_EDI_DATA.SPECIAL_HNDL = 'DA' OR L_REC_EDI_DATA.SPECIAL_HNDL = 'OD') AND
            ((l_rec_edi_data.PORT_OF_LOADING = 'SGSIN') or (l_rec_edi_data.PORT_OF_DISCHARGE = 'SGSIN'))) THEN --*17

            L_V_OBJ_NM := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                l_v_edi_etd_uid
                , NULL
                , NULL
                , 'CLR'
                , NULL -- description would be blank
                , 'DO'
                , g_v_upd_by_edi
                , l_n_edi_esde_seq
            );

        END IF;

        /* *16 end * */

        -- Step 20 : Populate data for EDI_ST_DOC_LOCATION (Next Port Of Call)
        BEGIN

            /*g_v_sql_id := '52';
            l_v_obj_nm := 'EDI_ESDL_SEQ.NEXTVAL';
            SELECT EDI_ESDL_SEQ.NEXTVAL
            INTO l_n_edi_esdl_uid
            FROM DUAL;*/

            --aks 4july commented
           /* g_v_sql_id := '53';
            l_v_obj_nm := 'ITP040';
            SELECT
                  PICODE
                , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_NAME',PINAME)
                , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_COUNTY',PIST)
                , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_COUNTRY',PICNCD)
            INTO
                  l_v_picode
                , l_v_piname
                , l_v_pist
                , l_v_picncd
            FROM ITP040
            WHERE PICODE = l_rec_edi_data.NEXT_PORT;

            g_v_sql_id := '54';
            l_v_obj_nm := 'ITP130';
            SELECT
                  TQTORD
                , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_SUB_NAME',TQTRNM)
            INTO
                  l_v_tqtord
                , l_v_tqtrnm
            FROM ITP130
            WHERE TQTERM = p_i_v_terminal;
            */
            g_v_sql_id := '55';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-9';
               PKG_EDI_DOCUMENT.PRC_CREATE_PORT
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , NULL
             , l_n_edi_esde_seq
             , l_rec_edi_data.PORT_OF_LOADING
             , l_rec_edi_data.LOAD_TERMINAL
             , '9'
             , l_n_edi_esdl_uid
              );
/*
                INSERT INTO ECM_LOG_TRACE(
                      PROG_ID
                    , PROG_SQL
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE)
                VALUES
                (
                    'DDL'
                    ,'LOC-11'||'~'||l_rec_edi_data.BOOKING_NO||'~'||l_rec_edi_data.VOYAGE_SEQNO
                    ,'A'
                    ,g_v_upd_by_edi
                    ,SYSDATE
                    ,g_v_upd_by_edi
                    ,SYSDATE

                );
                commit;
  */

    /*
        *6: start
    *

              FOR l_cur_sec_voyage_data IN l_cur_sec_voyage (l_rec_edi_data.BOOKING_NO
                                                           , l_rec_edi_data.VOYAGE_SEQNO)
              LOOP
                  --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
    /*
                INSERT INTO ECM_LOG_TRACE(
                      PROG_ID
                    , PROG_SQL
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE)
                VALUES
                (
                    'DDL'
                    ,'LOC-11-LOOP'||'~'||l_cur_sec_voyage_data.PORT||'~'||l_cur_sec_voyage_data.TERMINAL
                    ,'A'
                    ,g_v_upd_by_edi
                    ,SYSDATE
                    ,g_v_upd_by_edi
                    ,SYSDATE

                );
                commit;
    *
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-11';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                (p_i_n_eme_uid
                , l_v_edi_etd_uid
                , NULL
                , l_n_edi_esde_seq
                , l_cur_sec_voyage_data.PORT--l_rec_edi_data.PORT_OF_DISCHARGE
                , l_cur_sec_voyage_data.TERMINAL--l_rec_edi_data.DISCHARGE_TERMINAL
                , '11'
                , l_n_edi_esdl_uid
                );
            END LOOP;

            *
                *6: start
            */
            /*
                 *7 start
            */
            -- Get the next terminal value
             g_v_sql_id := '55a';
            PRE_GET_NEXT_POD_TERMINAL (
                 l_rec_edi_data.BOOKING_NO,
                 l_rec_edi_data.VOYAGE_SEQNO,
                 l_v_next_pod1_terminal,
                 l_v_next_pod2_terminal,
                 l_v_next_pod3_terminal,
                 l_v_final_pod_terminal,
                 l_v_next_service,
                 l_v_next_vessel,
                 l_v_next_voyno,
                 l_v_next_dir
            );
            /*
                 *7 end
            */


            /*
                *2: Changes Start
            */
            IF L_REC_EDI_DATA.MLO_POD1 IS NOT NULL THEN
             g_v_sql_id := '55b';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                      p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD1
                    , NULL                       -- l_rec_edi_data.DISCHARGE_TERMINAL
                    , '11'
                    , l_n_edi_esdl_uid
                );
            /* *10 start */
            ELSIF L_REC_EDI_DATA.MLO_DEL IS NOT NULL THEN
                g_v_sql_id := '55c';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                      p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_DEL
                    , NULL                       -- l_rec_edi_data.DISCHARGE_TERMINAL
                    , '11'
                    , l_n_edi_esdl_uid
                );
            /* *10 end */
            ELSE
                g_v_sql_id := '55d';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                      p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.PORT_OF_DISCHARGE
                    , l_rec_edi_data.DISCHARGE_TERMINAL
                    , '11'
                    , l_n_edi_esdl_uid
                );
            END IF;
            /*
                * old logic *

                /*
                    Changes start by vikas, to populate loc-11 data for each equipment,
                    as k'chatgamol say, on 03.11.2011
                *
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                      p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.PORT_OF_DISCHARGE
                    , l_rec_edi_data.DISCHARGE_TERMINAL
                    , '11'
                    , l_n_edi_esdl_uid
                );
                *
                    Changes end by vikas on 03.11.2011
                *
            *
                *2: Changes End
            */
              --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-88';
             IF L_V_PLACE_OF_RECEIPT IS NOT NULL THEN
                  g_v_sql_id := '55e';
                   PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                  (p_i_n_eme_uid
                 , l_v_edi_etd_uid
                 , NULL
                 , l_n_edi_esde_seq
                 , l_v_place_of_receipt
                 , NULL
                 , '88'
                 , l_n_edi_esdl_uid
                  );
             END IF;

             --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
             l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-7';
             IF L_V_PLACE_OF_DELIVERY IS NOT NULL THEN
                   g_v_sql_id := '55f';
                   PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                  (p_i_n_eme_uid
                 , l_v_edi_etd_uid
                 , NULL
                 , l_n_edi_esde_seq
                 , l_v_place_of_delivery
                 , NULL
                 , '7'
                 , l_n_edi_esdl_uid
                  );
             END IF;
             --aks 13 july
            IF L_REC_EDI_DATA.ACTIVITY_PORT = L_REC_EDI_DATA.FINAL_DISCHARGE_PORT THEN
                g_v_sql_id := '55g';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                (p_i_n_eme_uid
                , l_v_edi_etd_uid
                , NULL
                , l_n_edi_esde_seq
                , l_rec_edi_data.ACTIVITY_PORT
                , NULL
                , '13'
                , l_n_edi_esdl_uid
                );

            END IF;

            /*
                *2: No need to populate becuase we already populating pod,
                and in EZLL pod and next_pod1 is same, as k'chatgamol

            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-64';
            IF l_rec_edi_data.NEXT_POD1 IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                (p_i_n_eme_uid
                , l_v_edi_etd_uid
                , NULL
                , l_n_edi_esde_seq
                , l_rec_edi_data.NEXT_POD1
                , NULL
                , '64'
                , l_n_edi_esdl_uid
                );
            END IF;

            *
                *2: end comment
            */

            /* *14 start */
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-64';
            IF L_REC_EDI_DATA.MLO_POD2 IS NOT NULL THEN
                  g_v_sql_id := '55h';
                 PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD2
                    , NULL
                    , '64'
                    , l_n_edi_esdl_uid
                );
            ELSIF L_REC_EDI_DATA.MLO_POD1 IS NULL
                AND L_REC_EDI_DATA.MLO_DEL IS NULL
                AND L_REC_EDI_DATA.NEXT_POD2 IS NOT NULL THEN
                g_v_sql_id := '55i';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                    p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.NEXT_POD2
                    , l_v_next_pod2_terminal
                    , '64'
                    , l_n_edi_esdl_uid
                );
            END IF;

            /* *3: Changes start *
            IF l_rec_edi_data.MLO_POD2 IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD2
                    , NULL
                    , '64'
                    , l_n_edi_esdl_uid
                );

            /* *11 start *
            ELSIF l_rec_edi_data.MLO_POD1 IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD1
                    , NULL
                    , '64'
                    , l_n_edi_esdl_uid
                );

            ELSIF l_rec_edi_data.MLO_DEL IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_DEL
                    , NULL
                    , '64'
                    , l_n_edi_esdl_uid
                );

            /* *11 end *

            ELSIF l_rec_edi_data.NEXT_POD2 IS NOT NULL THEN

                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                    p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.NEXT_POD2
                    , l_v_next_pod2_terminal --  NULL -- *7
                    , '64'
                    , l_n_edi_esdl_uid
                );
            END IF;
            /* *14 end * */

            /*
                * old logic *
            *
                IF l_rec_edi_data.NEXT_POD2 IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                    (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.NEXT_POD2
                    , NULL
                    , '68'
                    , l_n_edi_esdl_uid
                    );
                END IF;
            *
                *3: Changes end
            */

            /* *14 start * */
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-68';

            IF L_REC_EDI_DATA.MLO_POD3 IS NOT NULL THEN
                g_v_sql_id := '55j';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (P_I_N_EME_UID
                    , L_V_EDI_ETD_UID
                    , NULL
                    , L_N_EDI_ESDE_SEQ
                    , L_REC_EDI_DATA.MLO_POD3
                    , NULL
                    , '68'
                    , L_N_EDI_ESDL_UID
                );

            ELSIF L_REC_EDI_DATA.MLO_POD1 IS NULL
                AND L_REC_EDI_DATA.MLO_DEL IS NULL
                AND L_REC_EDI_DATA.NEXT_POD3 IS NOT NULL THEN
                g_v_sql_id := '55k';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                    P_I_N_EME_UID
                    , L_V_EDI_ETD_UID
                    , NULL
                    , L_N_EDI_ESDE_SEQ
                    , L_REC_EDI_DATA.NEXT_POD3
                    , NULL
                    , '68'
                    , L_N_EDI_ESDL_UID
                );

            END IF;

            /* *4: Changes Start *
            IF l_rec_edi_data.MLO_POD3 IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD3
                    , NULL
                    , '68'
                    , l_n_edi_esdl_uid
                );
            /* *12 start *
            ELSIF l_rec_edi_data.MLO_POD1 IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD1
                    , NULL
                    , '68'
                    , l_n_edi_esdl_uid
                );
            ELSIF l_rec_edi_data.MLO_DEL IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_DEL
                    , NULL
                    , '68'
                    , l_n_edi_esdl_uid
                );


            /* *12 end *

            ELSIF l_rec_edi_data.NEXT_POD3 IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                    p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.NEXT_POD3
                    , NULL
                    , '68'
                    , l_n_edi_esdl_uid
                );
            END IF;
            *
            /* *14 end * */
            /*
                * old logic *
            *
                -- IF l_rec_edi_data.NEXT_POD1 IS NOT NULL THEN
                IF l_rec_edi_data.NEXT_POD3 IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                    (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.NEXT_POD3
                    , NULL
                    , '70'
                    , l_n_edi_esdl_uid
                    );
                END IF;
            *
                *3: Changes End
            */

             l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-83';
             /* Changes start by vikas as need to populate mlo_del as port for LOC-83, suggested by K'chatgamol,
             03.11.2011 */

            --  IF ((l_rec_edi_data.MLO_DEL IS NOT NULL)  -- *5
            --      AND (l_rec_edi_data.MLO_POD1 IS NOT NULL) ) THEN -- *5

            IF L_REC_EDI_DATA.MLO_DEL IS NOT NULL THEN  -- *5
                g_v_sql_id := '55l';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_DEL
                    , NULL
                    , '83'
                    , l_n_edi_esdl_uid
                );
            /* Changes end by vikas 03.11.2011 */

            /* *9 start * */
            ELSIF L_REC_EDI_DATA.MLO_POD3 IS NOT NULL THEN
                g_v_sql_id := '55m';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD3
                    , NULL
                    , '83'
                    , l_n_edi_esdl_uid
                );

            ELSIF L_REC_EDI_DATA.MLO_POD2 IS NOT NULL THEN
                 g_v_sql_id := '55n';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD2
                    , NULL
                    , '83'
                    , l_n_edi_esdl_uid
                );

            ELSIF L_REC_EDI_DATA.MLO_POD1 IS NOT NULL THEN
                g_v_sql_id := '55o';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                     (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.MLO_POD1
                    , NULL
                    , '83'
                    , l_n_edi_esdl_uid
                );
            /* *9 end * */
            ELSIF L_REC_EDI_DATA.PLACE_OF_DELIVERY IS NOT NULL THEN
                g_v_sql_id := '55p';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                    (p_i_n_eme_uid
                    , l_v_edi_etd_uid
                    , NULL
                    , l_n_edi_esde_seq
                    , l_rec_edi_data.PLACE_OF_DELIVERY  --final destination
                    , l_v_final_pod_terminal -- *7
                    , '83'
                    , l_n_edi_esdl_uid
                );
            END IF;

--             l_arr_var_name := STRING_ARRAY
--            ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
--           , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
--           , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--             );
--
--            l_arr_var_value := STRING_ARRAY
--           (p_i_n_eme_uid                , l_v_edi_etd_uid     , NULL
--          , NULL                         , l_v_picode          , l_v_tqtord
--          , '72'                         , l_n_edi_esdl_uid
--           );
--
--           l_arr_var_io := STRING_ARRAY
--          ('I'      , 'I'      , 'I'
--         , 'I'      , 'I'      , 'I'
--         , 'I'      , 'O'
--          );
--
--           PRE_LOG_INFO
--          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--         , l_v_obj_nm
--         , g_v_sql_id
--         , p_i_v_user_id
--         , l_t_log_info
--         , NULL
--         , l_arr_var_name
--         , l_arr_var_value
--         , l_arr_var_io
--          );


        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;

                g_record_filter :=  NULL;
                g_record_table  := 'Error occured during populating data in EDI_ST_DOC_LOCATION.';

--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

        -- Step 21 : Populate data for EDI_ST_DOC_LOCATION (Next Port Of Call)
        -- Step 21.1 : Populate data for EDI_ST_DOC_LOCATION (Place of Acceptance)
        BEGIN

            -- RAJEEV : SQL Need to Revise
            g_v_sql_id := '56';
            l_v_obj_nm := 'IDP010';
            SELECT
                  AYORIG
                , AYMPOL
                , AYMPOD
                , AYDEST
            INTO
                  l_v_ayorig
                , l_v_aympol
                , l_v_aympod
                , l_v_aydest
            FROM IDP010
            WHERE ROWNUM = 1;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                --l_b_raise_exp := TRUE;
--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
               l_v_ayorig := NULL;
               l_v_aympol := NULL;
               l_v_aympod := NULL;
               l_v_aydest := NULL;
       END;

       BEGIN


            g_v_sql_id := '58';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               --aks 13 july not reqd
           /*    l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
               PKG_EDI_DOCUMENT.PRC_CREATE_PORT
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , NULL
             , l_n_edi_esde_seq
             , l_v_ayorig
             , NULL
             , '88'
             , l_n_edi_esdl_uid
              );

             l_arr_var_name := STRING_ARRAY
            ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
           , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
           , 'p_port_qualifer'     , 'p_edi_esdl_uid'
             );

            l_arr_var_value := STRING_ARRAY
           (p_i_n_eme_uid                , l_v_edi_etd_uid     , NULL
          , NULL                         , l_v_ayorig          , NULL
          , '88'                         , l_n_edi_esdl_uid
           );

           l_arr_var_io := STRING_ARRAY
          ('I'      , 'I'      , 'I'
         , 'I'      , 'I'      , 'I'
         , 'I'      , 'O'
          );

           PRE_LOG_INFO
          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
         , l_v_obj_nm
         , g_v_sql_id
         , p_i_v_user_id
         , l_t_log_info
         , NULL
         , l_arr_var_name
         , l_arr_var_value
         , l_arr_var_io
          );*/

            -- Step 21.2 : Populate data for EDI_ST_DOC_LOCATION (Original Port of Loading)
            /*g_v_sql_id := '59';
            l_v_obj_nm := 'EDI_ESDL_SEQ.NEXTVAL';
            SELECT EDI_ESDL_SEQ.NEXTVAL
            INTO l_n_edi_esdl_uid
            FROM DUAL;*/

            g_v_sql_id := '60';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
               PKG_EDI_DOCUMENT.PRC_CREATE_PORT
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , NULL
             , l_n_edi_esde_seq
             , l_rec_edi_data.BAPOL--l_v_aympol
             , NULL
             , '76'
             , l_n_edi_esdl_uid
              );

--             l_arr_var_name := STRING_ARRAY
--            ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
--           , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
--           , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--             );
--
--            l_arr_var_value := STRING_ARRAY
--           (p_i_n_eme_uid                , l_v_edi_etd_uid     , NULL
--          , NULL                         , l_v_aympol          , NULL
--          , '76'                         , l_n_edi_esdl_uid
--           );
--
--           l_arr_var_io := STRING_ARRAY
--          ('I'      , 'I'      , 'I'
--         , 'I'      , 'I'      , 'I'
--         , 'I'      , 'O'
--          );
--
--           PRE_LOG_INFO
--          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--         , l_v_obj_nm
--         , g_v_sql_id
--         , p_i_v_user_id
--         , l_t_log_info
--         , NULL
--         , l_arr_var_name
--         , l_arr_var_value
--         , l_arr_var_io
--          );

            -- Step 21.3 : Populate data for EDI_ST_DOC_LOCATION (Final Port of Discharge)
            /*g_v_sql_id := '61';
            l_v_obj_nm := 'EDI_ESDL_SEQ.NEXTVAL';
            SELECT EDI_ESDL_SEQ.NEXTVAL
            INTO l_n_edi_esdl_uid
            FROM DUAL;*/

            g_v_sql_id := '62';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
               PKG_EDI_DOCUMENT.PRC_CREATE_PORT
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , NULL
             , l_n_edi_esde_seq
             , l_rec_edi_data.BAPOD--l_v_aympod
             , NULL
             , '65'
             , l_n_edi_esdl_uid
              );

--             l_arr_var_name := STRING_ARRAY
--            ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
--           , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
--           , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--             );
--
--            l_arr_var_value := STRING_ARRAY
--           (p_i_n_eme_uid                , l_v_edi_etd_uid     , NULL
--          , NULL                         , l_v_aympod          , NULL
--          , '65'                         , l_n_edi_esdl_uid
--           );
--
--           l_arr_var_io := STRING_ARRAY
--          ('I'      , 'I'      , 'I'
--         , 'I'      , 'I'      , 'I'
--         , 'I'      , 'O'
--          );
--
--           PRE_LOG_INFO
--          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--         , l_v_obj_nm
--         , g_v_sql_id
--         , p_i_v_user_id
--         , l_t_log_info
--         , NULL
--         , l_arr_var_name
--         , l_arr_var_value
--         , l_arr_var_io
--          );

            -- Step 21.4 : Populate data for EDI_ST_DOC_LOCATION (Place of Delivery)
            /*g_v_sql_id := '63';
            l_v_obj_nm := 'EDI_ESDL_SEQ.NEXTVAL';
            SELECT EDI_ESDL_SEQ.NEXTVAL
            INTO l_n_edi_esdl_uid
            FROM DUAL;*/
        --commented this by aks 13july this location type 7 not required
        /*
            g_v_sql_id := '64';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
               PKG_EDI_DOCUMENT.PRC_CREATE_PORT
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , NULL
             , l_n_edi_esde_seq
             , l_v_aydest
             , NULL
             , '7'
             , l_n_edi_esdl_uid
              );

             l_arr_var_name := STRING_ARRAY
            ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
           , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
           , 'p_port_qualifer'     , 'p_edi_esdl_uid'
             );

            l_arr_var_value := STRING_ARRAY
           (p_i_n_eme_uid                , l_v_edi_etd_uid     , NULL
          , NULL                         , l_v_aydest          , NULL
          , '7'                          , l_n_edi_esdl_uid
           );

           l_arr_var_io := STRING_ARRAY
          ('I'      , 'I'      , 'I'
         , 'I'      , 'I'      , 'I'
         , 'I'      , 'O'
          );

           PRE_LOG_INFO
          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
         , l_v_obj_nm
         , g_v_sql_id
         , p_i_v_user_id
         , l_t_log_info
         , NULL
         , l_arr_var_name
         , l_arr_var_value
         , l_arr_var_io
          );*/

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;

                g_record_filter :=  NULL;
                g_record_table  := 'Error occured during populating data in EDI_ST_DOC_LOCATION.';

--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

        -- Step 22 : Populate data for EDI_ST_DOC_PARTY (Slot Operator)
        BEGIN

            --g_v_sql_id := '65';
            --l_v_obj_nm := 'EDI_ESDP_SEQ.NEXTVAL';
            --SELECT EDI_ESDP_SEQ.NEXTVAL
            --INTO l_n_edi_esdp_seq
            --FROM DUAL;

            g_v_sql_id := '66';
             --EXECUTE PROCEDURE WITH PARAMETERS TO INSERT DATA INTO EDI_ST_DOC_PARTY
             l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';
             PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
             (p_i_n_eme_uid
            , l_v_edi_etd_uid
            , 'SL'
            , l_rec_edi_data.SLOT_OPERATOR
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , l_n_edi_esde_seq
            , l_n_edi_esdp_seq
              );

            g_v_sql_id := '66';
             --EXECUTE PROCEDURE WITH PARAMETERS TO INSERT DATA INTO EDI_ST_DOC_PARTY
             l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';

             IF l_rec_edi_data.OUT_SLOT_OPERATOR IS NOT NULL THEN
                 PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                 (p_i_n_eme_uid
                , l_v_edi_etd_uid
                , 'OSL'
                , l_rec_edi_data.OUT_SLOT_OPERATOR
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , l_n_edi_esde_seq
                , l_n_edi_esdp_seq
                  );
             END IF;

--             l_arr_var_name := STRING_ARRAY
--             ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'       , 'p_i_v_bncstp'
--            , 'p_i_v_bncscd'       , 'p_i_v_bnname'          , 'p_i_v_bnadd1'
--            , 'p_i_v_bnadd2'       , 'p_i_v_bnadd3'          , 'p_i_v_bnadd4'
--            , 'Location_County'    , 'p_i_v_bncoun'          , 'p_i_v_bnzip'
--            , 'l_n_edi_esde_uid'   , 'l_n_edi_esdp_uid'
--              );
--
--              l_arr_var_value := STRING_ARRAY
--             (p_i_n_eme_uid                      , l_v_edi_etd_uid          , 'SL'
--            , l_rec_edi_data.SLOT_OPERATOR       , NULL                     , NULL
--            , NULL                               , NULL                     , NULL
--            , NULL                               , NULL                     , NULL
--            , l_n_edi_esde_seq                   , l_n_edi_esdp_seq
--              );
--
--              l_arr_var_io := STRING_ARRAY
--             ('I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'O'
--              );
--
--       PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , NULL
--           , l_arr_var_name
--           , l_arr_var_value
--           , l_arr_var_io
--            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;

                g_record_filter :=  NULL;
                g_record_table  := 'Error occured during populating data in EDI_ST_DOC_PARTY.';

--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

        -- Step 23 : Populate data for EDI_ST_DOC_PARTY (Container Operator)
        BEGIN

            --g_v_sql_id := '67';
            --l_v_obj_nm := 'EDI_ESDP_SEQ.NEXTVAL';
            --SELECT EDI_ESDP_SEQ.NEXTVAL
            --INTO l_n_edi_esdp_seq
            --FROM DUAL;

            g_v_sql_id := '68';
             --EXECUTE PROCEDURE WITH PARAMETERS TO INSERT DATA INTO EDI_ST_DOC_PARTY
             l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';
             PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
             (p_i_n_eme_uid
            , l_v_edi_etd_uid
            , 'OP'
            , l_rec_edi_data.CONTAINER_OPERATOR
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , l_n_edi_esde_seq
            , l_n_edi_esdp_seq
              );

--             l_arr_var_name := STRING_ARRAY
--             ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'       , 'p_i_v_bncstp'
--            , 'p_i_v_bncscd'       , 'p_i_v_bnname'          , 'p_i_v_bnadd1'
--            , 'p_i_v_bnadd2'       , 'p_i_v_bnadd3'          , 'p_i_v_bnadd4'
--            , 'Location_County'    , 'p_i_v_bncoun'          , 'p_i_v_bnzip'
--            , 'l_n_edi_esde_uid'   , 'l_n_edi_esdp_uid'
--              );
--
--              l_arr_var_value := STRING_ARRAY
--             (p_i_n_eme_uid                      , l_v_edi_etd_uid          , 'OP'
--            , l_rec_edi_data.CONTAINER_OPERATOR  , NULL                     , NULL
--            , NULL                               , NULL                     , NULL
--            , NULL                               , NULL                     , NULL
--            , l_n_edi_esde_seq                   , l_n_edi_esdp_seq
--              );
--
--              l_arr_var_io := STRING_ARRAY
--             ('I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'O'
--              );
--
--           PRE_LOG_INFO
--            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , p_i_v_user_id
--           , l_t_log_info
--           , NULL
--           , l_arr_var_name
--           , l_arr_var_value
--           , l_arr_var_io
--            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;

                g_record_filter :=  NULL;
                g_record_table  := 'Error occured during populating data in EDI_ST_DOC_PARTY.';

--                PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

        -- Step 24 : Populate data for EDI_ST_DOC_COMMODITY

        BEGIN
            IF l_v_bill_of_lading IS NOT NULL  THEN
                /* Vikas: as suggested by hemlata san, if container is empty then no need to insert weight. bloack start */
                IF l_rec_edi_data.FULL_MT = 'E' THEN
                    l_cnt_weight_uom := NULL;
                END IF;
                /* Vikas: changes end */
                FOR l_cur_idp050_data IN l_cur_idp050 (l_v_bill_of_lading, l_v_sequence)
                LOOP
                        -- Commodity details in the equipment, including hazardous
                         g_v_sql_id := '68a';
                    BEGIN
                       SELECT SUBSTR (PKDESC, 1, 70)
                         INTO l_v_description
                         FROM ITP170
                        WHERE PKCODE = l_cur_idp050_data.BYKIND AND PKRCST = 'A';
                    EXCEPTION
                       WHEN OTHERS
                       THEN
                          l_v_description := 'Pieces';
                    END;

                    g_v_sql_id := '70';
                    l_v_obj_nm := 'EDI_ESDCO_SEQ.NEXTVAL';
                    SELECT EDI_ESDCO_SEQ.NEXTVAL
                    INTO l_n_edi_esdco_seq
                    FROM DUAL;

                    g_v_sql_id := '71';
                    INSERT INTO EDI_ST_DOC_COMMODITY(
                        EDI_ESDCO_UID
                        , EDI_ETD_UID
                        , COMMODITY
                        , DESCRIPTION
                        , PACKAGE_TYPE
                        , PIECE_COUNT
                        , GROSS_WEIGHT
                        , WEIGHT_UOM
                        , VOLUME
                        , VOLUME_UOM
                        , LENGTH
                        , WIDTH
                        , HEIGHT
                        , RECORD_STATUS
                        , RECORD_ADD_USER
                        , RECORD_ADD_DATE
                    )VALUES(
                          l_n_edi_esdco_seq
                        , l_v_edi_etd_uid
                        , pkg_edi_transaction.checkforouttrans
                                                              (p_i_n_eme_uid,
                                                               'COMMODITY',
                                                               l_cur_idp050_data.BYCMCD
                                                              )
                        , l_v_description
                        , pkg_edi_transaction.checkforouttrans
                                                        (p_i_n_eme_uid,
                                                         'PACKAGE_TYPE',
                                                         NVL (l_cur_idp050_data.BYKIND,
                                                              'PCS'
                                                             )
                                                        )
                        , NVL (l_cur_idp050_data.BYPCKG, 0)
                        , ROUND (l_cur_idp050_data.BYMTWT, 4)--l_v_gross_weight
                        , l_cnt_weight_uom
                        , l_cur_idp050_data.BYMTMS--l_v_volume
                        , l_cnt_volume_uom
                        , l_cur_idp050_data.BYLENG--l_v_length
                        , l_cur_idp050_data.BYWDTH
                        , l_cur_idp050_data.BYHGHT--l_v_height
                        , 'A'
                        , g_v_upd_by_edi
                        , g_v_sysdate
                    );

                    g_v_sql_id := '72';
                    INSERT INTO EDI_ST_DOC_EQP_LINK (
                          EDI_ESDCO_UID
                        , EDI_ESDE_UID
                    )VALUES(
                          l_n_edi_esdco_seq
                        , l_n_edi_esde_seq
                    );


                      BEGIN
                        g_v_sql_id := '72a';
                         SELECT FCDESC
                           INTO l_v_fcdesc
                           FROM ITP080
                          WHERE FCCODE = l_cur_idp050_data.BYCMCD AND FCRCST = 'A';

                          g_v_sql_id := '72b';
                         pkg_edi_document.prc_insert_text (l_v_edi_etd_uid,
                                                           NULL,
                                                           l_n_edi_esdco_seq,
                                                           'AAA',
                                                           l_v_fcdesc,
                                                           l_cur_idp050_data.BYCMCD,
                                                           g_v_upd_by_edi,
                                                            NULL -- l_n_edi_esde_seq modified by vikas, as k'chatgamol say no need, 29.11.2011
                                                          );
                      EXCEPTION
                         WHEN OTHERS
                         THEN
                            l_v_fcdesc := NULL;
                      END;

                      g_v_sql_id := '72c';
                     PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE
                     (l_v_edi_etd_uid
                    , 'HS'
                    , l_cur_idp050_data.bycmcd
                    , g_v_upd_by_edi
                    , l_n_edi_esde_seq
                    , NULL
                    , NULL
                    , NULL
                     );

                      FOR l_cur_idp060_data IN l_cur_idp060 (l_v_bill_of_lading, l_v_sequence)
                      LOOP
                         -- insert goods description
                         g_v_sql_id := '72d';
                         pkg_edi_document.prc_insert_text (l_v_edi_etd_uid,
                                                           NULL,
                                                           l_n_edi_esdco_seq,
                                                           'AAI',
                                                           l_cur_idp060_data.FYDSCR,
                                                           l_cur_idp050_data.BYCMCD,
                                                           g_v_upd_by_edi,
                                                           l_n_edi_esde_seq
                                                          );
                      END LOOP;
                      --commented by aks temporarily 7july
                      /*FOR l_cur_quarantine_dtl_data IN
                         l_cur_quarantine_dtl (l_v_bill_of_lading, l_v_sequence)
                      LOOP
                         -- insert goods description
                         pkg_edi_document.prc_insert_text
                                                      (l_v_edi_etd_uid,
                                                       NULL,
                                                       l_n_edi_esdco_seq,
                                                       'AAI',
                                                       l_cur_quarantine_dtl_data.FYDSCR,
                                                       l_cur_idp050_data.BYCMCD,
                                                       g_v_upd_by_edi,
                                                       l_n_edi_esde_seq
                                                      );
                      END LOOP;*/

                     FOR l_cur_idp051_data in l_cur_idp051 (l_v_bill_of_lading, l_v_sequence)
                     LOOP
                        IF           l_cur_idp051_data.PACKAGE_GROUP_CODE = 'I'
                                OR l_cur_idp051_data.PACKAGE_GROUP_CODE = '1'
                        THEN
                                l_v_packing_group := '1';
                        ELSIF    l_cur_idp051_data.PACKAGE_GROUP_CODE = 'II'
                              OR l_cur_idp051_data.PACKAGE_GROUP_CODE = '2'
                        THEN
                                l_v_packing_group := '2';
                        ELSIF    l_cur_idp051_data.PACKAGE_GROUP_CODE = 'III'
                              OR l_cur_idp051_data.PACKAGE_GROUP_CODE = '3'
                        THEN
                                l_v_packing_group := '3';
                        ELSE
                                l_v_packing_group := NULL;
                        END IF;

                        -- check if there is any explosive content
                        IF    l_cur_idp051_data.EXP_WEIGHT_POWDER > 0
                           OR l_cur_idp051_data.EXP_WEIGHT_GAS > 0
                        THEN
                           l_v_explosive_content := 'Y';
                        ELSE
                           l_v_explosive_content := 'N';
                        END IF;
                          g_v_sql_id := '72e';
                        SELECT SPECIAL_HANDLING
                           INTO l_v_special_handling
                           FROM IDP055
                        WHERE EYBLNO = l_v_bill_of_lading
                          AND EYEQNO = l_rec_edi_data.CONTAINER_NO
                          AND EYCMSQ = l_v_sequence;

                         IF    l_v_special_handling IS NOT NULL
                            AND l_v_special_handling <> 'N' -- *19 OR l_v_special_handling <> 'N'
                         THEN

                                g_v_sql_id := '74';
                                l_v_obj_nm := 'EDI_ESDH_SEQ.NEXTVAL';
                                SELECT EDI_ESDH_SEQ.NEXTVAL
                                INTO l_v_edi_esdh_seq
                                FROM DUAL;

                                g_v_sql_id := '75';
                                INSERT INTO EDI_ST_DOC_HAZARD (
                                      EDI_ESDCO_UID
                                    , EDI_ESDH_UID
                                    , PACKING_GROUP
                                    , HAZ_MAT_CODE
                                    , HAZ_MAT_CLASS
                                    --, HAZ_MAT_SUB_CLASS
                                    , UNDG_NUMBER
                                    , MFAG_PAGE
                                    , EMS_PAGE
                                    , MARINE_POLLUTANT
                                    , RESIDUE
                                    , LIMITED_QUANTITY
                                    , FLASHPOINT
                                    , TEMPERATURE_UOM
                                    , EXPLOSIVE_CONTENT
                                    , RECORD_STATUS
                                    , RECORD_ADD_USER
                                    , RECORD_ADD_DATE
                                )VALUES(
                                      l_n_edi_esdco_seq
                                    , l_v_edi_esdh_seq
                                    , l_v_packing_group
                                    , l_cur_idp051_data.IYIMCO--l_v_haz_mat_code
                                    , TRIM (l_rec_edi_data.T_IMDG)--*20 TRIM (l_cur_idp051_data.IYMPRO)--l_rec_edi_data.T_IMDG
                                    --, l_v_haz_mat_sub_class
                                    , LPAD (l_rec_edi_data.T_UNNO, 4, '0') --*20 LPAD (l_cur_idp051_data.IYIUNO, 4, '0')--SUBSTR(l_rec_edi_data.T_UNNO,1,4)
                                    , l_cur_idp051_data.IYMFCD--l_v_mfag_page
                                    , l_cur_idp051_data.IYEMNO--l_v_ems_page
                                    , l_cur_idp051_data.MARINE_POLLUTANT--l_v_marine_pollutant
                                    , l_cur_idp051_data.RESIDUE--l_rec_edi_data.T_RESIDUE
                                    , l_cur_idp051_data.LIMITED_QUANTITY--l_v_limited_quantity
                                    , l_cur_idp051_data.IYFPFM--l_rec_edi_data.T_FLASH_POINT
                                    , DECODE (l_cur_idp051_data.IYFPFM,
                                                         NULL, NULL,
                                                         l_v_temperature_uom_t
                                                        )--l_rec_edi_data.T_TEMPERATURE_UOM
                                    , l_v_explosive_content
                                    , 'A'
                                    , g_v_upd_by_edi
                                    , g_v_sysdate
                                );

                            IF l_cur_idp051_data.IYHZDS IS NOT NULL
                            THEN
                               -- insert goods description
                               g_v_sql_id := '75a';
                               pkg_edi_document.prc_insert_text (l_v_edi_etd_uid,
                                                                 l_v_edi_esdh_seq,
                                                                 l_n_edi_esdco_seq,
                                                                 'AAC',
                                                                 l_cur_idp051_data.IYHZDS,
                                                                 NULL,
                                                                 g_v_upd_by_edi,
                                                                 l_n_edi_esde_seq
                                                                );
                            END IF;

                            IF l_cur_idp051_data.PROPER_SHIPPING_NAME IS NOT NULL
                            THEN
                               -- insert goods description
                               g_v_sql_id := '75b';
                               pkg_edi_document.prc_insert_text
                                                  (l_v_edi_etd_uid,
                                                   l_v_edi_esdh_seq,
                                                   l_n_edi_esdco_seq,
                                                   'AAD',
                                                   l_cur_idp051_data.PROPER_SHIPPING_NAME,
                                                   NULL,
                                                   g_v_upd_by_edi,
                                                   l_n_edi_esde_seq
                                                  );
                            END IF;

                            IF l_cur_idp051_data.CONTACT_DESTINATON IS NOT NULL
                            THEN
                               -- Contact info for Hazard Goods
                               g_v_sql_id := '75c';
                               pkg_edi_document.prc_insert_contact
                                                    (l_v_edi_etd_uid,
                                                     NULL,
                                                     l_v_edi_esdh_seq,
                                                     'HG',
                                                     l_cur_idp051_data.CONTACT_DESTINATON,
                                                     NULL,
                                                     g_v_upd_by_edi,
                                                     l_n_edi_esdcn_seq
                                                    );

                               IF l_cur_idp051_data.CONTACT_TELNO IS NOT NULL
                               THEN
                               g_v_sql_id := '75d';
                                  pkg_edi_document.prc_insert_comm
                                                         (l_n_edi_esdcn_seq,
                                                          'TE',
                                                          l_cur_idp051_data.CONTACT_TELNO,
                                                          g_v_upd_by_edi
                                                         );
                               END IF;
                            END IF;
                        END IF; --end if of special handling
                     END LOOP; --end loop of l_cur_idp051
                END LOOP; --END LOOP OF l_cur_idp050

                FOR l_cur_idp030_data IN l_cur_idp030(l_v_bill_of_lading, 'C')
                LOOP
                g_v_sql_id := '75f';
                    IF l_cur_idp030_data.CYCUST =
                        pkg_edi_transaction.checkforouttrans
                                                           (p_i_n_eme_uid,
                                                            'PARTY_CODE',
                                                            l_cur_idp030_data.CYCUST
                                                           )
                    THEN
                        BEGIN
                            SELECT COUNT (1)
                              INTO l_n_count_alias
                              FROM EDI_MESSAGE_TRANSLATION EMT,
                                   EDI_TRANSLATION_HEADER ETH
                             WHERE EMT.EME_UID = p_i_n_eme_uid
                               AND EMT.FIELD_CODE = 'PARTY_CODE'
                               AND EMT.ETH_UID = ETH.ETH_UID
                               AND ETH.RECORD_STATUS = 'A'
                               AND EMT.RECORD_STATUS = 'A';
                         EXCEPTION
                            WHEN OTHERS
                            THEN
                               l_n_count_alias := 0;
                         END;

                         IF l_n_count_alias > 0
                         THEN
                            BEGIN
                               SELECT CUSTOMER_ALIAS
                                 INTO l_v_customer_alias
                                 FROM ITP010
                                WHERE CUCUST = l_cur_idp030_data.CYCUST;
                            EXCEPTION
                               WHEN NO_DATA_FOUND
                               THEN
                                  l_v_customer_alias := l_cur_idp030_data.CYCUST;
                            END;
                         ELSE
                            l_v_customer_alias := l_cur_idp030_data.CYCUST;
                         END IF;
                    ELSE
                         l_v_customer_alias := l_cur_idp030_data.CYCUST;
                    END IF;
                    g_v_sql_id := '75g';
                    -- Insert Booking Parties
                     l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';
                     PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                                     (p_i_n_eme_uid
                                    , l_v_edi_etd_uid
                                    , pkg_edi_transaction.checkforouttrans(p_i_n_eme_uid,
                                                                           'PARTY_TYPE',
                                                                           'CN'
                                                                          )
                                    , pkg_edi_transaction.checkforouttrans
                                                                          (p_i_n_eme_uid,
                                                                           'PARTY_CODE',
                                                                           l_v_customer_alias
                                                                          )
                                    , l_cur_idp030_data.CYNAME
                                    , l_cur_idp030_data.CYADD1
                                    , l_cur_idp030_data.CYADD2
                                    , l_cur_idp030_data.CYADD3
                                    , l_cur_idp030_data.CYADD4
                                    , l_cur_idp030_data.STATE
                                    , l_cur_idp030_data.COUNTRY_CODE
                                    , l_cur_idp030_data.ZIP
                                    , l_n_edi_esde_seq
                                    , l_n_edi_esdp_seq
                                      );

                     -- Contact info for Booking Parties
                     g_v_sql_id := '75h';
                     pkg_edi_document.prc_insert_contact (l_v_edi_etd_uid,
                                                       l_n_edi_esdp_seq,
                                                       NULL,
                                                       'IC',
                                                       l_cur_idp030_data.CYNAME,
                                                       NULL,
                                                       g_v_upd_by_edi,
                                                       l_n_edi_esdcn_seq
                                                      );
                      g_v_sql_id := '75i';
                      IF l_cur_idp030_data.CYTELN IS NOT NULL
                      THEN
                         pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_seq,
                                                           'TE',
                                                           l_cur_idp030_data.CYTELN,
                                                           g_v_upd_by_edi
                                                          );
                      END IF;
                      g_v_sql_id := '75j';
                      IF l_cur_idp030_data.CYFAXN IS NOT NULL
                      THEN
                         pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_seq,
                                                           'FX',
                                                           l_cur_idp030_data.CYFAXN,
                                                           g_v_upd_by_edi
                                                          );
                      END IF;
                      g_v_sql_id := '75k';
                      IF l_cur_idp030_data.EMAIL_ID IS NOT NULL
                      THEN
                         pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_seq,
                                                           'EM',
                                                           l_cur_idp030_data.EMAIL_ID,
                                                           g_v_upd_by_edi
                                                          );
                      END IF;

                END LOOP;--end loop of l_cur_idp030
            ELSE  --ELSE of l_v_bill_of_lading
                IF l_v_birefr = 'Y'
                THEN
                  l_v_special_handling := 'RF';
                END IF;

                FOR l_cur_bkp050_data IN l_cur_bkp050 (l_rec_edi_data.BOOKING_NO,
                                                       l_v_special_handling
                                                       )
                LOOP
                      g_v_sql_id := '75l';
                      BEGIN
                         SELECT SUBSTR (PKDESC, 1, 70)
                           INTO l_v_description
                           FROM ITP170
                          WHERE PKCODE = l_cur_bkp050_data.BWPKND AND PKRCST = 'A';
                      EXCEPTION
                         WHEN OTHERS
                         THEN
                            l_v_description := 'Pieces';
                      END;

                      SELECT edi_esdco_seq.NEXTVAL
                      INTO l_n_edi_esdco_seq
                      FROM DUAL;
                      g_v_sql_id := '75m';
                      INSERT INTO EDI_ST_DOC_COMMODITY(
                          EDI_ESDCO_UID
                        , EDI_ETD_UID
                        , COMMODITY
                        , DESCRIPTION
                        , PACKAGE_TYPE
                        , PIECE_COUNT
                        , GROSS_WEIGHT
                        , WEIGHT_UOM
                        , VOLUME
                        , VOLUME_UOM
                        , LENGTH
                        , WIDTH
                        , HEIGHT
                        , LENGTH_UOM
                        , MOVEMENT_TYPE
                        , RECORD_STATUS
                        , RECORD_ADD_USER
                        , RECORD_ADD_DATE
                        )
                        VALUES(
                          l_n_edi_esdco_seq
                        , l_v_edi_etd_uid
                        , l_cur_bkp050_data.BWCMCD
                        , l_v_description
                        , NVL (l_cur_bkp050_data.BWPKND, 'PCS')
                        , NVL (l_cur_bkp050_data.BWPCKG, 0)
                        , ROUND (DECODE (l_cur_bkp050_data.BWMTWT,
                                              0, NULL,
                                              l_cur_bkp050_data.BWMTWT
                                             ),
                                      4
                                     )
                        , DECODE (l_cur_bkp050_data.BWMTWT,
                                       NULL, NULL,
                                       0, NULL,
                                       l_cnt_weight_uom_t
                                      )--l_cnt_weight_uom
                        , DECODE (l_cur_bkp050_data.BWMTMS,
                                       0, NULL,
                                       l_cur_bkp050_data.BWMTMS
                                      )
                        , DECODE (l_cur_bkp050_data.BWMTMS,
                                       NULL, NULL,
                                       0, NULL,
                                       l_cnt_volume_uom_t
                                      )--l_cnt_volume_uom
                        , DECODE (l_cur_bkp050_data.BBK_LENGTH,
                                       0, NULL,
                                       l_cur_bkp050_data.BBK_LENGTH
                                      )
                        , DECODE (l_cur_bkp050_data.BBK_WIDTH,
                                       0, NULL,
                                       l_cur_bkp050_data.BBK_WIDTH
                                      )
                        , DECODE (l_cur_bkp050_data.BBK_HEIGHT,
                                       0, NULL,
                                       l_cur_bkp050_data.BBK_HEIGHT
                                      )
                        , l_cnt_length_uom
                        , l_cur_bkp050_data.BWSHTP
                        , 'A'
                        , g_v_upd_by_edi
                        , g_v_sysdate
                        );
                        g_v_sql_id := '75n';
                        INSERT INTO EDI_ST_DOC_EQP_LINK
                              (EDI_ESDCO_UID, EDI_ESDE_UID
                              )
                        VALUES (l_n_edi_esdco_seq, l_n_edi_esde_seq
                              );
                          g_v_sql_id := '75o';
                         PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE(l_v_edi_etd_uid
                                                                , 'HS'
                                                                , l_cur_bkp050_data.BWCMCD
                                                                , g_v_upd_by_edi
                                                                , l_n_edi_esde_seq
                                                                , NULL
                                                                , NULL
                                                                , NULL
                                                                 );
                          g_v_sql_id := '75p';
                         PKG_EDI_DOCUMENT.PRC_INSERT_TEXT (l_v_edi_etd_uid,
                                                           NULL,
                                                           l_n_edi_esdco_seq,
                                                           'AAA',
                                                           l_cur_bkp050_data.COMM_DESC,
                                                           l_cur_bkp050_data.BWCMCD,
                                                           g_v_upd_by_edi,
                                                           NULL -- l_n_edi_esde_seq modified by vikas, as k'chatgamol say no need, 29.11.2011
                                                          );

                         -- DGS (Dangerous Goods)
                          BEGIN
                             SELECT COUNT (1)
                               INTO l_n_count
                               FROM BOOKING_DG_COMM_DETAIL
                              WHERE BOOKING_NO     = l_rec_edi_data.BOOKING_NO
                                AND SHIPMENT_TYPE  = l_cur_bkp050_data.BWSHTP
                                AND COMMODITY_SQNO = l_cur_bkp050_data.BWCMSQ;
                          EXCEPTION
                             WHEN OTHERS
                             THEN
                                l_n_count := 0;
                          END;
                          IF l_n_count = 1
                              THEN
                                g_v_sql_id := '75q';
                                 SELECT HZ_FLPT_FROM, HZ_BS, IMO_NO,
                                        IMO_CLASS, IMO_LABEL, LPAD (UN_NO, 4, '0'),
                                        CONTACT_DESTINATON, CONTACT_TELNO,
                                        PACKAGE_GROUP_CODE, EMS_NO, MFAG_NO,
                                        MARINE_POLLUTANT, RESIDUE,
                                        LIMITED_QUANTITY, PROPER_SHIPPING_NAME,
                                        TECHNICAL_NAME, HZ_DESCRIPTION,
                                        EXP_WEIGHT_POWDER, EXP_WEIGHT_GAS
                                   INTO l_v_flashpoint, l_v_temp_code, l_v_imo_no,
                                        l_v_imo_class, l_v_imo_label, l_v_undg_no,
                                        l_v_contact_person, l_v_contact_telno,
                                        l_v_package_grp_cd, l_v_ems_no, l_v_mfag_no,
                                        l_v_marine_pollutant, l_v_residue,
                                        l_v_limited_quantity, l_v_psn,
                                        l_v_tech_name, l_v_hz_description,
                                        l_v_exp_powder, l_v_exp_gas
                                   FROM BOOKING_DG_COMM_DETAIL
                                  WHERE BOOKING_NO     = l_rec_edi_data.BOOKING_NO
                                    AND SHIPMENT_TYPE  = l_cur_bkp050_data.BWSHTP
                                    AND COMMODITY_SQNO = l_cur_bkp050_data.BWCMSQ;

                                 BEGIN
                                    l_v_undg_no := TO_NUMBER (l_v_undg_no);
                                 EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                       l_v_undg_no := NULL;
                                 END;

                                 IF l_v_temp_code = 'C'
                                 THEN
                                    l_v_temp_code := 'CEL';
                                 ELSE
                                    l_v_temp_code := 'FAH';
                                 END IF;

                                 IF l_v_package_grp_cd = 'I' OR l_v_package_grp_cd = '1'
                                 THEN
                                    l_v_package_grp_cd := '1';
                                 ELSIF l_v_package_grp_cd = 'II' OR l_v_package_grp_cd = '2'
                                 THEN
                                    l_v_package_grp_cd := '2';
                                 ELSIF l_v_package_grp_cd = 'III' OR l_v_package_grp_cd = '3'
                                 THEN
                                    l_v_package_grp_cd := '3';
                                 ELSE
                                    l_v_package_grp_cd := NULL;
                                 END IF;

                                 -- check if there is any explosive content
                                 IF l_v_exp_powder > 0 OR l_v_exp_gas > 0
                                 THEN
                                    l_v_explosive_content := 'Y';
                                 ELSE
                                    l_v_explosive_content := 'N';
                                 END IF;

                                 SELECT edi_esdh_seq.NEXTVAL
                                   INTO l_v_edi_esdh_seq
                                   FROM DUAL;
                                  g_v_sql_id := '75r';
                                 INSERT INTO EDI_ST_DOC_HAZARD
                                             (EDI_ESDCO_UID, EDI_ESDH_UID,
                                              PACKING_GROUP, HAZ_MAT_CODE,
                                              HAZ_MAT_CLASS, HAZ_MAT_SUB_CLASS,
                                              UNDG_NUMBER, MFAG_PAGE, EMS_PAGE,
                                              MARINE_POLLUTANT, RESIDUE,
                                              LIMITED_QUANTITY,
                                                               -- REPORT_QUANTITY,
                                                               FLASHPOINT,
                                              TEMPERATURE_UOM,
                                              EXPLOSIVE_CONTENT, RECORD_STATUS,
                                              RECORD_ADD_USER, RECORD_ADD_DATE
                                             )
                                      VALUES (l_n_edi_esdco_seq, l_v_edi_esdh_seq,
                                              l_v_package_grp_cd, l_v_imo_no,
                                              TRIM (l_v_imo_class)
                                              , l_v_imo_label,
                                              l_v_undg_no
                                              , l_v_mfag_no, l_v_ems_no,
                                              l_v_marine_pollutant, l_v_residue,
                                              l_v_limited_quantity, l_v_flashpoint,
                                              DECODE (l_v_flashpoint,
                                                      NULL, NULL,
                                                      l_v_temp_code
                                                     ),
                                              l_v_explosive_content, 'A',
                                              g_v_upd_by_edi, SYSDATE
                                             );

                                 IF l_v_hz_description IS NOT NULL
                                 THEN
                                    -- insert goods description
                                    g_v_sql_id := '75s';
                                    pkg_edi_document.prc_insert_text (l_v_edi_etd_uid,
                                                                      l_v_edi_esdh_seq,
                                                                      l_n_edi_esdco_seq,
                                                                      'AAC',
                                                                      l_v_hz_description,
                                                                      NULL,
                                                                      g_v_upd_by_edi,
                                                                      l_n_edi_esde_seq
                                                                     );
                                 END IF;

                                 IF l_v_psn IS NOT NULL
                                 THEN
                                    -- insert goods description
                                    g_v_sql_id := '75t';
                                    pkg_edi_document.prc_insert_text (l_v_edi_etd_uid,
                                                                      l_v_edi_esdh_seq,
                                                                      l_n_edi_esdco_seq,
                                                                      'AAD',
                                                                      l_v_psn,
                                                                      NULL,
                                                                      g_v_upd_by_edi,
                                                                      l_n_edi_esde_seq
                                                                     );
                                 END IF;

                                 IF l_v_contact_person IS NOT NULL
                                 THEN
                                    -- Contact info for Hazard Goods
                                    g_v_sql_id := '75u';
                                    pkg_edi_document.prc_insert_contact
                                                                       (l_v_edi_etd_uid,
                                                                        NULL,
                                                                        l_v_edi_esdh_seq,
                                                                        'HG',
                                                                        l_v_contact_person,
                                                                        NULL,
                                                                        g_v_upd_by_edi,
                                                                        l_n_edi_esdcn_seq
                                                                       );

                                    IF l_v_contact_telno IS NOT NULL
                                    THEN
                                       g_v_sql_id := '75v';
                                       pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_seq,
                                                                         'TE',
                                                                         l_v_contact_telno,
                                                                         g_v_upd_by_edi
                                                                        );
                                    END IF;
                                 END IF;
                              END IF;--end if of l_n_count

                END LOOP;--end loop of bkp050

                FOR l_cur_bkp030_data IN l_cur_bkp030 (l_rec_edi_data.BOOKING_NO, 'C')
                LOOP
                    g_v_sql_id := '75w';
                    IF l_cur_bkp030_data.BNCSCD =
                        pkg_edi_transaction.checkforouttrans
                                                           (p_i_n_eme_uid,
                                                            'PARTY_CODE',
                                                            l_cur_bkp030_data.BNCSCD
                                                           )
                    THEN
                        BEGIN
                        SELECT COUNT (1)
                          INTO l_n_count_alias
                          FROM EDI_MESSAGE_TRANSLATION EMT,
                               EDI_TRANSLATION_HEADER ETH
                         WHERE EMT.EME_UID = p_i_n_eme_uid
                           AND EMT.FIELD_CODE = 'PARTY_CODE'
                           AND EMT.ETH_UID = ETH.ETH_UID
                           AND ETH.RECORD_STATUS = 'A'
                           AND EMT.RECORD_STATUS = 'A';
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                               l_n_count_alias := 0;
                        END;
                          g_v_sql_id := '75x';
                         IF l_n_count_alias > 0
                         THEN
                            BEGIN
                               SELECT CUSTOMER_ALIAS
                                 INTO l_v_customer_alias
                                 FROM ITP010
                                WHERE CUCUST = l_cur_bkp030_data.BNCSCD;
                            EXCEPTION
                               WHEN NO_DATA_FOUND
                               THEN
                                  l_v_customer_alias := l_cur_bkp030_data.BNCSCD;
                            END;
                         ELSE
                            l_v_customer_alias := l_cur_bkp030_data.BNCSCD;
                         END IF;
                    ELSE                                             -- add else
                     l_v_customer_alias := l_cur_bkp030_data.BNCSCD;
                    END IF;

                    -- Insert Booking Parties
                     L_V_OBJ_NM := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';
                     g_v_sql_id := '75y';
                     PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                                     (p_i_n_eme_uid
                                    , l_v_edi_etd_uid
                                    , pkg_edi_transaction.checkforouttrans(p_i_n_eme_uid,
                                                                           'PARTY_TYPE',
                                                                           'CN'
                                                                          )
                                    , pkg_edi_transaction.checkforouttrans
                                                                          (p_i_n_eme_uid,
                                                                           'PARTY_CODE',
                                                                           l_v_customer_alias
                                                                          )
                                    , l_cur_bkp030_data.BNNAME
                                    , l_cur_bkp030_data.BNADD1
                                    , l_cur_bkp030_data.BNADD2
                                    , l_cur_bkp030_data.BNADD3
                                    , l_cur_bkp030_data.BNADD4
                                    , l_cur_bkp030_data.STATE
                                    , l_cur_bkp030_data.BNCOUN
                                    , l_cur_bkp030_data.BNZIP
                                    , l_n_edi_esde_seq
                                    , l_n_edi_esdp_seq
                                      );

                     -- Contact info for Booking Parties
                     g_v_sql_id := '75z';
                     pkg_edi_document.prc_insert_contact ( l_v_edi_etd_uid,
                                                           l_n_edi_esdp_seq,
                                                           NULL,
                                                           'IC',
                                                           l_cur_bkp030_data.BNNAME,
                                                           NULL,
                                                           g_v_upd_by_edi,
                                                           l_n_edi_esdcn_seq
                                                          );
                      IF l_cur_bkp030_data.BNTELN IS NOT NULL
                      THEN
                         pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_seq,
                                                           'TE',
                                                           l_cur_bkp030_data.BNTELN,
                                                           g_v_upd_by_edi
                                                          );
                      END IF;
                      g_v_sql_id := '75aa';
                      IF l_cur_bkp030_data.BNFAX IS NOT NULL
                      THEN
                         pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_seq,
                                                           'FX',
                                                           l_cur_bkp030_data.BNFAX,
                                                           g_v_upd_by_edi
                                                          );
                      END IF;
                       g_v_sql_id := '75ab';
                      IF l_cur_bkp030_data.BNEMAL IS NOT NULL
                      THEN
                         pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_seq,
                                                           'EM',
                                                           l_cur_bkp030_data.BNEMAL,
                                                           g_v_upd_by_edi
                                                          );
                      END IF;

                END LOOP;--end loop of l_cur_bkp030

            END IF;--End if of l_v_bill_of_lading

            IF p_i_v_activity_code = 'D' THEN
            /*
                FOR l_cur_sec_voyage_data IN l_cur_sec_voyage (l_rec_edi_data.BOOKING_NO
                                                             , l_rec_edi_data.VOYAGE_SEQNO)
                LOOP
                    IF l_rec_edi_data.ACTIVITY_PORT = l_rec_edi_data.FINAL_DISCHARGE_PORT THEN
                        l_v_location_type := '170';
                    ELSE
                        l_v_location_type := '13';
                    END IF;

                    l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';
                    PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
                      (p_i_n_eme_uid,
                       l_v_edi_etd_uid
                     , l_cur_sec_voyage_data.VOYNO
                     , l_cur_sec_voyage_data.SERVICE
                     , l_cur_sec_voyage_data.VESSEL
                     , l_cur_sec_voyage_data.DIRECTION
                     , l_cur_sec_voyage_data.PORT
                     , 30
                     , p_i_v_activity_code
                     --, l_n_esdj_uid  --COMMENTED 21JULY
                     , l_n_edi_esde_seq
                     , l_cur_sec_voyage_data.TERMINAL
                     , l_n_esdj_uid
                      );

                END LOOP;
*/
                FOR l_cur_prev_voyage_data IN l_cur_prev_voyage (l_rec_edi_data.BOOKING_NO
                                                             , l_rec_edi_data.VOYAGE_SEQNO)
                LOOP
                    L_V_LOCATION_TYPE := '76';
                     g_v_sql_id := '75ac';
                    PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
                      (p_i_n_eme_uid,
                       l_v_edi_etd_uid
                     , l_cur_prev_voyage_data.VOYNO
                     , l_cur_prev_voyage_data.SERVICE
                     , l_cur_prev_voyage_data.VESSEL
                     , l_cur_prev_voyage_data.DIRECTION
                     , l_cur_prev_voyage_data.PORT
                     , 10
                     , p_i_v_activity_code
                     --, l_n_esdj_uid  --COMMENTED 21JULY
                     , l_n_edi_esde_seq
                     , l_cur_prev_voyage_data.TERMINAL
                     , l_n_esdj_uid
                      );

                    /*PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
                        (p_i_n_eme_uid
                        , l_v_edi_etd_uid
                        , l_cur_prev_voyage_data.VOYNO
                        , l_cur_prev_voyage_data.SERVICE
                        , l_cur_prev_voyage_data.VESSEL
                        , l_cur_prev_voyage_data.DIRECTION
                        , l_cur_prev_voyage_data.PORT
                        , 10
                        , p_i_v_activity_code
                        , l_n_esdj_uid
                        );*/


                END LOOP;
            END IF;

--            PRE_LOG_INFO(
--                'PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , 'EDI_ST_DOC_COMMODITY'
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'INSERT CALLED'
--                , NULL
--                , NULL
--                , NULL
--            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                --p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                p_o_v_err_cd := l_cnt_volume_uom || '~' || SQLERRM;
                l_b_raise_exp := TRUE;

                g_record_filter :=  NULL;
                g_record_table  := 'Error occured during populating data in EDI_ST_DOC_COMMODITY.';

--                 PRE_LOG_INFO
--                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , p_i_v_user_id
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
        END;

--commented by aks 4july
/*
        -- Step 25 : Populate data for EDI_ST_DOC_EQP_LINK

        -- Step 26 : Populate data for EDI_ST_DOC_HAZARD
        BEGIN

            g_v_sql_id := '73';
            l_v_obj_nm := 'IDP055,IDP002,IDP010,IDP051';
            SELECT
                  FE_TRANS_DATA(p_i_n_eme_uid,'PACKING_GROUP',IDP051.PACKAGE_GROUP_CODE)
                , FE_TRANS_DATA(p_i_n_eme_uid,'HAZ_MAT_CODE',IDP051.IYIMCO)
                , FE_TRANS_DATA(p_i_n_eme_uid,'HAZ_MAT_SUB_CLASS',IDP051.IYIMLB)
                , FE_TRANS_DATA(p_i_n_eme_uid,'MFAG_PAGE',IDP051.IYMFCD)
                , FE_TRANS_DATA(p_i_n_eme_uid,'EMS_PAGE',IDP051.IYEMNO)
                , FE_TRANS_DATA(p_i_n_eme_uid,'MARINE_POLLUTANT',IDP051.MARINE_POLLUTANT)
                , FE_TRANS_DATA(p_i_n_eme_uid,'LIMITED_QUANTITY',IDP051.LIMITED_QUANTITY)
                , FE_TRANS_DATA(p_i_n_eme_uid,'EXPLOSIVE_CONTENT',CASE WHEN IDP051.EXP_WEIGHT_POWDER > 0 OR
                            EXP_WEIGHT_GAS > 0
                       THEN 'Y'
                       ELSE ''
                  END) V_EXPLOSIVE_CONTENT
            INTO
                  l_v_packing_group
                , l_v_haz_mat_code
                , l_v_haz_mat_sub_class
                , l_v_mfag_page
                , l_v_ems_page
                , l_v_marine_pollutant
                , l_v_limited_quantity
                , l_v_explosive_content
            FROM IDP055 IDP055,
                 IDP002 IDP002,
                 IDP010 IDP010,
                 IDP051 IDP051
            WHERE IDP055.EYBLNO  = IDP002.TYBLNO
            AND   IDP055.EYBLNO  = IDP010.AYBLNO
            AND   IDP002.TYBLNO  = IDP010.AYBLNO
            AND   IDP055.EYBLNO  = IDP051.IYBLNO
            AND   IDP055.EYCMSQ  = IDP051.IYCMSQ
            AND   IDP010.AYSTAT  >=1
            AND   IDP010.AYSTAT  <=6
            AND   IDP010.PART_OF_BL IS NULL
            AND   IDP002.TYBKNO  = l_rec_edi_data.BOOKING_NO
            AND   IDP055.EYEQNO  = l_rec_edi_data.CONTAINER_NO
            AND ROWNUM           = 1;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                PRE_LOG_INFO
                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                , l_v_obj_nm
                , g_v_sql_id
                , p_i_v_user_id
                , l_t_log_info
                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                , NULL
                , NULL
                , NULL
                 );
                l_v_packing_group      := NULL;
                l_v_haz_mat_code       := NULL;
                l_v_haz_mat_sub_class  := NULL;
                l_v_mfag_page          := NULL;
                l_v_ems_page           := NULL;
                l_v_marine_pollutant   := NULL;
                l_v_limited_quantity   := NULL;
                l_v_explosive_content  := NULL;
        END;

        BEGIN

            g_v_sql_id := '74';
            l_v_obj_nm := 'EDI_ESDH_SEQ.NEXTVAL';
            SELECT EDI_ESDH_SEQ.NEXTVAL
            INTO l_v_edi_esdh_seq
            FROM DUAL;

            g_v_sql_id := '75';
            INSERT INTO EDI_ST_DOC_HAZARD (
                  EDI_ESDCO_UID
                , EDI_ESDH_UID
                , PACKING_GROUP
                , HAZ_MAT_CODE
                , HAZ_MAT_CLASS
                , HAZ_MAT_SUB_CLASS
                , UNDG_NUMBER
                , MFAG_PAGE
                , EMS_PAGE
                , MARINE_POLLUTANT
                , RESIDUE
                , LIMITED_QUANTITY
                , FLASHPOINT
                , TEMPERATURE_UOM
                , EXPLOSIVE_CONTENT
                , RECORD_STATUS
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
            )VALUES(
                  l_n_edi_esdco_seq
                , l_v_edi_esdh_seq
                , SUBSTR(l_v_packing_group,1,3)
                , l_v_haz_mat_code
                , l_rec_edi_data.T_IMDG
                , l_v_haz_mat_sub_class
                , SUBSTR(l_rec_edi_data.T_UNNO,1,4)
                , l_v_mfag_page
                , l_v_ems_page
                , l_v_marine_pollutant
                , l_rec_edi_data.T_RESIDUE
                , l_v_limited_quantity
                , l_rec_edi_data.T_FLASH_POINT
                , l_rec_edi_data.T_TEMPERATURE_UOM
                , l_v_explosive_content
                , 'A'
                , g_v_upd_by_edi
                , g_v_sysdate
            );
           PRE_LOG_INFO
            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
           , 'EDI_ST_DOC_HAZARD'
           , g_v_sql_id
           , p_i_v_user_id
           , l_t_log_info
           , 'INSERT CALLED'
           , NULL
           , NULL
           , NULL
            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                PRE_LOG_INFO
                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                , l_v_obj_nm
                , g_v_sql_id
                , p_i_v_user_id
                , l_t_log_info
                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                , NULL
                , NULL
                , NULL
                 );
        END;

*/--COMMENTED BY aks 4july
/*--COMMENTED BY aks 4july
        -- Step 28 : Populate data for EDI_ST_DOC_TEXT (AAA)
        BEGIN

            g_v_sql_id := '79';
            l_v_obj_nm := 'IDP055,IDP002,IDP010,IDP050,IDP060';
            SELECT
                  IDP050.BYCMCD
                , IDP060.FYDSCR
            INTO
                  l_v_text_code
                , l_v_description
            FROM  IDP055 IDP055
                , IDP002 IDP002
                , IDP010 IDP010
                , IDP050 IDP050
                , IDP060 IDP060
            WHERE IDP055.EYBLNO  = IDP002.TYBLNO
            AND IDP055.EYBLNO    = IDP010.AYBLNO
            AND IDP002.TYBLNO    = IDP010.AYBLNO
            AND IDP055.EYBLNO    = IDP050.BYBLNO
            AND IDP055.EYCMSQ    = IDP050.BYCMSQ
            AND IDP060.FYBLNO    = IDP010.AYBLNO
            AND IDP010.AYSTAT    >= 1
            AND IDP010.AYSTAT    <= 6
            AND IDP010.PART_OF_BL IS NULL
            AND IDP002.TYBKNO    = l_rec_edi_data.BOOKING_NO
            AND IDP055.EYEQNO    = l_rec_edi_data.CONTAINER_NO
            AND ROWNUM=1;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                PRE_LOG_INFO
                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                , l_v_obj_nm
                , g_v_sql_id
                , p_i_v_user_id
                , l_t_log_info
                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                , NULL
                , NULL
                , NULL
                 );
                l_v_text_code          := NULL;
                l_v_description        := NULL;
        END;

        BEGIN

            g_v_sql_id := '81';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT
            (l_v_edi_etd_uid
           , NULL
           , NULL
           , 'AAA'
           , l_v_text_description
           , l_v_text_code
           , g_v_upd_by_edi
           , l_n_edi_esde_seq
            );

             l_arr_var_name := STRING_ARRAY
           ('l_n_edi_etd_seq'      , 'EDI_ESDH_UID'           , 'EDI_ESDCO_UID'
          , 'p_i_v_hn_cr_flg'      , 'p_i_v_hn_cr_descp'      , 'p_i_v_hn_cr_code'
          , 'p_i_v_edi'            , 'l_n_edi_esde_uid'
            );

            l_arr_var_value := STRING_ARRAY
           (l_v_edi_etd_uid         , NULL                       , NULL
          , 'AAA'                   , l_v_text_description       , l_v_text_code
          , g_v_upd_by_edi          , l_n_edi_esde_seq
            );

            l_arr_var_io := STRING_ARRAY
           ('I'      , 'I'      , 'I'
          , 'I'      , 'I'      , 'I'
          , 'I'      , 'I'
            );

           PRE_LOG_INFO
            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
           , l_v_obj_nm
           , g_v_sql_id
           , p_i_v_user_id
           , l_t_log_info
           , NULL
           , l_arr_var_name
           , l_arr_var_value
           , l_arr_var_io
            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;
                PRE_LOG_INFO
                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                , l_v_obj_nm
                , g_v_sql_id
                , p_i_v_user_id
                , l_t_log_info
                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                , NULL
                , NULL
                , NULL
                 );
        END;

        -- Step 29 : Populate data for EDI_ST_DOC_JOURNEY
        BEGIN

            IF l_rec_edi_data.ACTIVITY_PORT  != l_rec_edi_data.PORT_OF_LOADING AND
                l_rec_edi_data.ACTIVITY_PORT != l_rec_edi_data.FINAL_DISCHARGE_PORT
            THEN

              g_v_sql_id := '83';
                --EXECUTE PROCEDURE WITH PARAMETERS TO CREATE A RECORD FOR JOURNEY
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';
               PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , l_rec_edi_data.NEXT_VOYAGE
             , l_rec_edi_data.SERVICE
             , l_rec_edi_data.VESSEL
             , l_rec_edi_data.DIRECTION
             , l_rec_edi_data.PORT_OF_LOADING
             , 20
             , NULL
             , l_n_esdj_uid
              );


              l_arr_var_name := STRING_ARRAY
              ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'   , 'p_i_v_voyage'
             , 'p_i_v_service'      , 'p_i_v_vessel'      , 'p_i_v_direction'
             , 'p_i_v_port'         , 'p_i_v_20'          , 'Activity_Code'
             , 'l_n_edi_esdj_uid'
              );

              l_arr_var_value := STRING_ARRAY
             (p_i_n_eme_uid                      , l_v_edi_etd_uid              , l_rec_edi_data.NEXT_VOYAGE
            , l_rec_edi_data.SERVICE             , l_rec_edi_data.VESSEL        , l_rec_edi_data.DIRECTION
            , l_rec_edi_data.PORT_OF_LOADING     , 20                           , NULL
            , l_n_esdj_uid
             );

             l_arr_var_io := STRING_ARRAY
            ('I'      , 'I'      , 'I'
           , 'I'      , 'I'      , 'I'
           , 'I'      , 'I'      , 'I'
           , 'O'
            );

               PRE_LOG_INFO
                ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
               , l_v_obj_nm
               , g_v_sql_id
               , p_i_v_user_id
               , l_t_log_info
               , NULL
               , l_arr_var_name
               , l_arr_var_value
               , l_arr_var_io
                );

            END IF;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;
                PRE_LOG_INFO
                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                , l_v_obj_nm
                , g_v_sql_id
                , p_i_v_user_id
                , l_t_log_info
                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                , NULL
                , NULL
                , NULL
                 );
        END;

        -- Step 30 : Populate data for EDI_ST_DOC_LOCATION
        BEGIN

            IF l_rec_edi_data.ACTIVITY_PORT = l_rec_edi_data.PLACE_OF_DELIVERY THEN
                l_v_location_type := 7;
            ELSIF l_rec_edi_data.ACTIVITY_PORT = l_rec_edi_data.FINAL_DISCHARGE_PORT THEN
                l_v_location_type := 170;
            ELSE
                l_v_location_type := 13;
            END IF;

            g_v_sql_id := '84';
            l_v_obj_nm := 'EDI_ESDL_SEQ.NEXTVAL';
            SELECT EDI_ESDL_SEQ.NEXTVAL
            INTO l_n_edi_esdl_uid
            FROM DUAL;

            g_v_sql_id := '85';
            l_v_obj_nm := 'ITP040';
            SELECT
                  PICODE
                , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_NAME',PINAME)
                , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_COUNTY',PIST)
                , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_COUNTRY',PICNCD)
            INTO
                  l_v_picode
                , l_v_piname
                , l_v_pist
                , l_v_picncd
            FROM ITP040
            WHERE PICODE = l_rec_edi_data.ACTIVITY_PORT;

            l_v_obj_nm := 'BOOKING_VOYAGE_ROUTING_DTL';
            SELECT   FROM_TERMINAL
                   , TO_TERMINAL
            INTO     l_v_from_terminal
                   , l_v_to_terminal
            FROM    BOOKING_VOYAGE_ROUTING_DTL
            WHERE   BOOKING_NO   = l_rec_edi_data.BOOKING_NO
            AND     VOYAGE_SEQNO = l_rec_edi_data.VOYAGE_SEQNO;


            g_v_sql_id := '86';
            l_v_obj_nm := 'ITP130';
            SELECT
                  TQTORD
                , FE_TRANS_DATA(p_i_n_eme_uid,'LOCATION_SUB_NAME',TQTRNM)
            INTO
                  l_v_tqtord
                , l_v_tqtrnm
            FROM ITP130
            WHERE TQTERM = DECODE(l_v_location_type, 13, l_v_from_terminal, l_v_to_terminal);

            g_v_sql_id := '87';
               --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
               l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
               PKG_EDI_DOCUMENT.PRC_CREATE_PORT
              (p_i_n_eme_uid
             , l_v_edi_etd_uid
             , NULL
             , NULL
             , l_v_picode
             , l_v_tqtord
             , '72'
             , l_n_edi_esdl_uid
              );

             l_arr_var_name := STRING_ARRAY
            ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
           , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
           , 'p_port_qualifer'     , 'p_edi_esdl_uid'
             );

            l_arr_var_value := STRING_ARRAY
           (p_i_n_eme_uid                , l_v_edi_etd_uid     , NULL
          , NULL                         , l_v_picode          , l_v_tqtord
          , '72'                         , l_n_edi_esdl_uid
           );

           l_arr_var_io := STRING_ARRAY
          ('I'      , 'I'      , 'I'
         , 'I'      , 'I'      , 'I'
         , 'I'      , 'O'
          );

           PRE_LOG_INFO
          ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
         , l_v_obj_nm
         , g_v_sql_id
         , p_i_v_user_id
         , l_t_log_info
         , NULL
         , l_arr_var_name
         , l_arr_var_value
         , l_arr_var_io
          );


        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;
                PRE_LOG_INFO
                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                , l_v_obj_nm
                , g_v_sql_id
                , p_i_v_user_id
                , l_t_log_info
                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                , NULL
                , NULL
                , NULL
                 );
        END;

        -- Step 31 : Populate data for EDI_ST_DOC_DATE (Arrival Date)
        BEGIN


            g_v_sql_id := '89';
            l_v_obj_nm := 'ITP063';
            SELECT
                  TO_DATE(VVARDT || LPAD(NVL(VVARTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
                , TO_DATE(VVSLDT || LPAD(NVL(VVSLTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
            INTO
                  l_v_arrival_date
                , l_v_sailing_date
            FROM ITP063
            WHERE VOYAGE_ID = l_rec_edi_data.VOYAGE_NUMBER
            AND VVSRVC      = l_rec_edi_data.SERVICE
            AND VVVESS      = l_rec_edi_data.VESSEL
            AND VVPDIR      = l_rec_edi_data.DIRECTION
            AND VVVERS      = 99
            AND VVRCST      = 'A'
            AND VVFORL IS NOT null
            AND VVPCAL      = l_rec_edi_data.ACTIVITY_PORT;

            IF (l_v_arrival_date > SYSDATE) THEN
                l_v_arrival_code := '178';
            ELSE
                l_v_arrival_code := '132';
            END IF;

            IF (l_v_sailing_date > SYSDATE) THEN
                l_v_sailing_code := '136';
            ELSE
                l_v_sailing_code := '133';
            END IF;

            g_v_sql_id := '90';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
            PKG_EDI_DOCUMENT.PRC_CREATE_DATE
           (l_v_edi_etd_uid
          , l_n_edi_esdl_uid
          , l_v_arrival_date
          , l_v_arrival_code
            );

            l_arr_var_name := STRING_ARRAY
           ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
          , 'p_date_type'
            );

           l_arr_var_value := STRING_ARRAY
          (l_v_edi_etd_uid                , l_n_edi_esdl_uid     , l_v_arrival_date
         , l_v_arrival_code
           );

           l_arr_var_io := STRING_ARRAY
          ('I'      , 'I'      , 'I'
         , 'I'
           );

          PRE_LOG_INFO
         ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
        , l_v_obj_nm
        , g_v_sql_id
        , p_i_v_user_id
        , l_t_log_info
        , NULL
        , l_arr_var_name
        , l_arr_var_value
        , l_arr_var_io
         );

            -- Step 32 : Populate data for EDI_ST_DOC_DATE (Sailing Date)

            g_v_sql_id := '92';
            g_v_sql_id := '90';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
            PKG_EDI_DOCUMENT.PRC_CREATE_DATE
           (l_v_edi_etd_uid
          , l_n_edi_esdl_uid
          , l_v_sailing_date
          , l_v_sailing_code
            );

            l_arr_var_name := STRING_ARRAY
           ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
          , 'p_date_type'
            );

           l_arr_var_value := STRING_ARRAY
          (l_v_edi_etd_uid                , l_n_edi_esdl_uid     , l_v_sailing_date
         , l_v_sailing_code
           );

           l_arr_var_io := STRING_ARRAY
          ('I'      , 'I'      , 'I'
         , 'I'
           );

          PRE_LOG_INFO
         ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
        , l_v_obj_nm
        , g_v_sql_id
        , p_i_v_user_id
        , l_t_log_info
        , NULL
        , l_arr_var_name
        , l_arr_var_value
        , l_arr_var_io
         );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;
                PRE_LOG_INFO
                 ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
                , l_v_obj_nm
                , g_v_sql_id
                , p_i_v_user_id
                , l_t_log_info
                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                , NULL
                , NULL
                , NULL
                 );
        END;
*/
        -- Step 33 : Update EDI_DOCUMENT_LOG Status
        g_v_sql_id := '93';
        UPDATE EDI_DOCUMENT_LOG
        SET    STATUS = 'S',
               EDI_ETD_UID = l_v_edi_etd_uid,
               RECORD_PROCESSED_DATE = SYSDATE
        WHERE
               SERVICE                = l_rec_edi_data.SERVICE
        AND    VESSEL_CODE            = l_rec_edi_data.VESSEL
        AND    VOYAGE_NUMBER          = l_rec_edi_data.VOYAGE_NUMBER
        AND    DIRECTION              = l_rec_edi_data.DIRECTION
        AND    BOOKING_NUMBER         = l_rec_edi_data.BOOKING_NO
        AND    EQUIPMENT_NO           = l_rec_edi_data.CONTAINER_NO
        AND    EME_UID                = p_i_n_eme_uid
        AND    MSG_REFERENCE          = l_n_msg_reference;

--        PRE_LOG_INFO
--        ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--       , 'EDI_DOCUMENT_LOG'
--       , g_v_sql_id
--       , p_i_v_user_id
--       , l_t_log_info
--       , 'UPDATE CALLED'
--       , NULL
--       , NULL
--       , NULL
--        );

    END LOOP;

    -- Step 34 : Update EDI_TRANSACTION_HEADER Status
    g_v_sql_id := '94';
    UPDATE EDI_TRANSACTION_HEADER
    SET    STATUS  = 'R'
    WHERE  MSG_REFERENCE = l_n_msg_reference;

--    PRE_LOG_INFO
--    ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
--   , 'EDI_TRANSACTION_HEADER'
--   , g_v_sql_id
--   , p_i_v_user_id
--   , l_t_log_info
--   , 'UPDATE CALLED'
--   , NULL
--   , NULL
--   , NULL
--    );

    IF l_b_raise_exp = TRUE THEN
       RAISE l_e_exception;
    END IF;

    p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    DBMS_OUTPUT.PUT_LINE('Finished Sucessfully');

EXCEPTION
    WHEN l_e_exception THEN
        DBMS_OUTPUT.PUT_LINE('Exception Occurred For g_v_sql_id :: ' || g_v_sql_id);
        DBMS_OUTPUT.PUT_LINE(p_o_v_err_cd);

        IF g_v_sql_id <> '71' THEN

            -- p_o_v_err_cd := g_v_sql_id || '~' ||SQLCODE || '~' || SQLERRM; commented by vikas on 19.10.2011
            p_o_v_err_cd := g_v_sql_id || '~' ||'Error Occured during EDI generation1.';

        END IF;

        ROLLBACK;

        PRE_TOS_COMMON_ERROR_LOG (
            g_v_parameter_string
            , 'DECLARE_LST_OUTBOUND'
            , '1'  -- To identify record as non synchronization error
            , p_o_v_err_cd
            , 'A'
            , g_record_filter
            , g_record_table
            , p_i_v_user_id
            , SYSDATE
            , p_i_v_user_id
            , SYSDATE
        );

        COMMIT;

        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception Occurred For g_v_sql_id :: ' || g_v_sql_id);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);

        -- p_o_v_err_cd := g_v_sql_id || '~' ||SQLCODE || '~' || SQLERRM;

        p_o_v_err_cd := 'Error Occured during EDI generation2.';  -- added by vikas, to show error message on screen, 20.10.2011
        ROLLBACK;

        PRE_TOS_COMMON_ERROR_LOG (
            g_v_parameter_string
            , 'DECLARE_LST_OUTBOUND'
            , '1'  -- To identify record as non synchronization error
            , p_o_v_err_cd
            , 'A'
            , g_record_filter || g_v_sql_id || '~' ||SQLCODE || '~' || SQLERRM
            , g_record_table
            , p_i_v_user_id
            , SYSDATE
            , p_i_v_user_id
            , SYSDATE
        );

        COMMIT;

        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

END PRE_ECM_GENERATE_EDI;


PROCEDURE PRE_ECM_DOWNLOAD (
      p_o_refListData        OUT    PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_activity_code           VARCHAR2 -- Called For Decalare Load List Outbound  or Declare Discharge List Outbound
    , p_i_v_list_id                 VARCHAR2
    , p_i_v_all_ports_flag          VARCHAR2
    , p_i_v_specific_port_name      VARCHAR2
    , p_i_v_flat_rack_flag          VARCHAR2
    , p_i_v_fumigation_flag         VARCHAR2
    , p_i_v_cont_op_flag            VARCHAR2
    , p_i_v_slot_op_flag            VARCHAR2
    , p_i_v_cont_op                 VARCHAR2
    , p_i_v_slot_op                 VARCHAR2
    , p_o_v_err_cd           OUT    VARCHAR2
) AS
BEGIN

    p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    g_v_parameter_string := p_i_v_activity_code           || '~' ||
                            p_i_v_list_id                 || '~' ||
                            p_i_v_all_ports_flag          || '~' ||
                            p_i_v_specific_port_name      || '~' ||
                            p_i_v_flat_rack_flag          || '~' ||
                            p_i_v_fumigation_flag         || '~' ||
                            p_i_v_cont_op_flag            || '~' ||
                            p_i_v_slot_op_flag            || '~' ||
                            p_i_v_cont_op                 || '~' ||
                            p_i_v_slot_op                 || '~' ||
                            p_o_v_err_cd;

    IF p_i_v_activity_code = 'L' THEN

        OPEN p_o_refListData FOR
        SELECT LL.FK_SERVICE                as SERVICE
            , LL.FK_VESSEL                  as VESSEL
            , LL.FK_VOYAGE                  as VOYAGE_NUMBER
            , LL.FK_DIRECTION               as DIRECTION
            , BL.FK_BOOKING_NO              as BOOKING_NUMBER
            , LL.DN_PORT                    as PORT_OF_LOADING
            , BL.DN_DISCHARGE_PORT          as PORT_OF_DISCHARGE
            , BL.DN_EQUIPMENT_NO            as EQUIPMENT_NO
            , BL.DN_EQ_SIZE                 as EQUIPMENT_SIZE
            , BL.DN_EQ_TYPE                 as EQUIPMENT_TYPE
            , BL.CONTAINER_GROSS_WEIGHT     as GROSS_WEIGHT
            , 'KGS'                         as GROSS_WEIGHT_UOM
            , BL.OVERLENGTH_FRONT_CM        as OVERLENGTH_TFRONT
            , BL.OVERLENGTH_REAR_CM         as OVERLENGTH_BACK
            , BL.OVERHEIGHT_CM              as OVERHEIGHT
            , BL.OVERWIDTH_LEFT_CM          as OVERWIDTH_LEFT
            , BL.OVERWIDTH_RIGHT_CM         as OVERWIDTH_RIGHT
            , BL.REEFER_TMP                 as TEMPERATURE
            , BL.REEFER_TMP_UNIT            as TEMPERATURE_UOM
            , BL.DN_HUMIDITY                as HUMIDITY
            , BK.BWDANG                     as HAZADOUS_FLAG
            , BL.FK_UNNO                    as UNNO
            , BL.FK_IMDG                    as IMDG
            , BL.FK_PORT_CLASS              as PORT_CLASS
            , BK.BWPKND                     as PACKAGE_TYPE
            , BK.BWCMCD                     as COMMODITY_CD
            , BK.COMM_DESC                  as DESCRIPTION
            , BK.BWMTWT                     as COMM_GROSS_WEIGHT
            , BK.BWMTMS                     as COMM_GROSS_WEIGHT_UOM
        FROM
              TOS_LL_LOAD_LIST                  LL
            , TOS_LL_BOOKED_LOADING             BL
            , BKP050                            BK
            , BKP009                            B9 --Added by Bindu on 08/06/2011
            , ITP075                            IP --Added by Bindu on 08/06/2011
        WHERE BK. BWBKNO             =     BL.FK_BOOKING_NO
        AND   LL.PK_LOAD_LIST_ID     =     BL.FK_LOAD_LIST_ID
        --Added by Bindu on 08/06/2011 start.
        AND   BL.FK_BOOKING_NO       =     B9.BIBKNO
        AND   BL.FK_BKG_EQUIPM_DTL   =     B9.BISEQN
        AND   IP.TRTYPE              =     B9.BICNTP
        AND   ((IP.TRREFR = 'Y' AND BK.SPECIAL_HANDLING = NVL((SELECT B5.SPECIAL_HANDLING FROM BKP050 B5
                                                          WHERE B5.BWBKNO= B9.BIBKNO AND B5.SPECIAL_HANDLING = 'RF'), B9.SPECIAL_HANDLING))
              OR (IP.TRREFR <> 'Y' and BK.SPECIAL_HANDLING = B9.SPECIAL_HANDLING))
        --Added by Bindu on 08/06/2011 end.
        AND   LL.PK_LOAD_LIST_ID     =     p_i_v_list_id
        AND   BL.LOADING_STATUS     IN     ('BK','LO')
        /* commented by vikas specific port should be port of loading not port of loading */
        -- AND   (p_i_v_all_ports_flag  = 'A' OR LL.DN_PORT = p_i_v_specific_port_name)
        AND   (p_i_v_all_ports_flag  = 'A' OR BL.DN_DISCHARGE_PORT = p_i_v_specific_port_name) -- vikas
        AND   (p_i_v_flat_rack_flag  = 'Y' OR BL.LOAD_CONDITION  != 'P')
        AND   (p_i_v_fumigation_flag = 'Y' OR NVL(BL.FUMIGATION_ONLY,'N') != 'Y')

        /* start added by vikas */
        AND ( (p_i_v_cont_op_flag  = 'E' AND INSTR(p_i_v_cont_op,FK_CONTAINER_OPERATOR )=0)
            OR (p_i_v_cont_op_flag   = 'I' AND  INSTR(p_i_v_cont_op,FK_CONTAINER_OPERATOR )>0)
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND ( (p_i_v_slot_op_flag  = 'E' AND INSTR(p_i_v_slot_op,FK_SLOT_OPERATOR )=0)
            OR  (p_i_v_slot_op_flag   = 'I' AND  INSTR(p_i_v_slot_op,FK_SLOT_OPERATOR )>0)
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) );
        /* end added by vikas */

      /* commented by vikas logic is not working correctly

        AND   ( (p_i_v_cont_op_flag  = 'E' AND FK_CONTAINER_OPERATOR NOT IN (p_i_v_cont_op))
            OR (p_i_v_cont_op_flag   = 'I' AND FK_CONTAINER_OPERATOR IN (p_i_v_cont_op))
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND   ( (p_i_v_slot_op_flag  = 'E' AND FK_SLOT_OPERATOR NOT IN (p_i_v_slot_op))
            OR (p_i_v_slot_op_flag   = 'I' AND FK_SLOT_OPERATOR IN (p_i_v_slot_op))
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) );
            */
    ELSE

        OPEN p_o_refListData FOR
       SELECT DL.FK_SERVICE                as SERVICE
            ,DL.FK_VESSEL                   as VESSEL
            ,DL.FK_VOYAGE                   as VOYAGE_NUMBER
            ,DL.FK_DIRECTION                as DIRECTION
            ,BD.FK_BOOKING_NO               as BOOKING_NUMBER
            ,BD.DN_POL                      as PORT_OF_LOADING
            ,DL.DN_PORT                     as PORT_OF_DISCHARGE
            ,BD.DN_EQUIPMENT_NO             as EQUIPMENT_NO
            ,BD.DN_EQ_SIZE                  as EQUIPMENT_SIZE
            ,BD.DN_EQ_TYPE                  as EQUIPMENT_TYPE
            ,BD.CONTAINER_GROSS_WEIGHT      as GROSS_WEIGHT
            ,'KGS'                          as GROSS_WEIGHT_UOM
            ,BD.OVERLENGTH_FRONT_CM         as OVERLENGTH_TFRONT
            ,BD.OVERLENGTH_REAR_CM          as OVERLENGTH_BACK
            ,BD.OVERHEIGHT_CM               as OVERHEIGHT
            ,BD.OVERWIDTH_LEFT_CM           as OVERWIDTH_LEFT
            ,BD.OVERWIDTH_RIGHT_CM          as OVERWIDTH_RIGHT
            ,BD.REEFER_TEMPERATURE          as TEMPERATURE
            ,BD.REEFER_TMP_UNIT             as TEMPERATURE_UOM
            ,BD.DN_HUMIDITY                 as HUMIDITY
            ,BK.BWDANG                      as HAZADOUS_FLAG
            ,BD.FK_UNNO                     as UNNO
            ,BD.FK_IMDG                     as IMDG
            ,BD.FK_PORT_CLASS               as PORT_CLASS
            ,BK.BWPKND                      as PACKAGE_TYPE
            ,BK.BWCMCD                      as COMMODITY_CD
            ,BK.COMM_DESC                   as DESCRIPTION
            ,BK.BWMTWT                      as COMM_GROSS_WEIGHT
            ,BK.BWMTMS                      as COMM_GROSS_WEIGHT_UOM
        FROM TOS_DL_DISCHARGE_LIST             DL
           , TOS_DL_BOOKED_DISCHARGE           BD
           , BKP050                            BK
           , BKP009                            B9 --Added by Bindu on 08/06/2011
           , ITP075                            IP --Added by Bindu on 08/06/2011
        WHERE BK. BWBKNO              = BD.FK_BOOKING_NO
        AND   DL.PK_DISCHARGE_LIST_ID = BD.FK_DISCHARGE_LIST_ID
        --Added by Bindu on 08/06/2011 start.
        AND   BD.FK_BOOKING_NO        = B9.BIBKNO
        AND   BD.FK_BKG_EQUIPM_DTL    = B9.BISEQN
        AND   IP.TRTYPE               = B9.BICNTP
        AND   ((IP.TRREFR = 'Y' AND BK.SPECIAL_HANDLING = NVL((SELECT B5.SPECIAL_HANDLING FROM BKP050 B5
                                                          WHERE B5.BWBKNO= B9.BIBKNO AND B5.SPECIAL_HANDLING = 'RF'), B9.SPECIAL_HANDLING))
              OR (IP.TRREFR <> 'Y' and BK.SPECIAL_HANDLING = B9.SPECIAL_HANDLING))
        --Added by Bindu on 08/06/2011 end.
        AND   DL.PK_DISCHARGE_LIST_ID = p_i_v_list_id
        AND   BD.DISCHARGE_STATUS     IN  ('BK', 'DI')
        /* commented by vikas specific port should be port of loading not port of discharge */
        -- AND   (p_i_v_all_ports_flag   = 'A' OR DL.DN_PORT = p_i_v_specific_port_name)
        AND   (p_i_v_all_ports_flag   = 'A' OR BD.DN_POL = p_i_v_specific_port_name) -- vikas
        AND   (p_i_v_flat_rack_flag   = 'Y' OR BD.LOAD_CONDITION  != 'P')
        AND   (p_i_v_fumigation_flag  = 'Y' OR NVL(BD.FUMIGATION_ONLY,'N') != 'Y')
        /* start added by vikas */
        AND ( (p_i_v_cont_op_flag  = 'E' AND INSTR(p_i_v_cont_op,FK_CONTAINER_OPERATOR )=0)
            OR (p_i_v_cont_op_flag   = 'I' AND  INSTR(p_i_v_cont_op,FK_CONTAINER_OPERATOR )>0)
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND ( (p_i_v_slot_op_flag  = 'E' AND INSTR(p_i_v_slot_op,FK_SLOT_OPERATOR )=0)
            OR  (p_i_v_slot_op_flag   = 'I' AND  INSTR(p_i_v_slot_op,FK_SLOT_OPERATOR )>0)
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) );
        /* end added by vikas */

      /* commented by vikas logic is not working correctly
        AND   ( (p_i_v_cont_op_flag  = 'E' AND FK_CONTAINER_OPERATOR NOT IN (p_i_v_cont_op))
            OR (p_i_v_cont_op_flag   = 'I' AND FK_CONTAINER_OPERATOR IN (p_i_v_cont_op))
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND   ( (p_i_v_slot_op_flag  = 'E' AND FK_SLOT_OPERATOR NOT IN (p_i_v_slot_op))
            OR (p_i_v_slot_op_flag   = 'I' AND FK_SLOT_OPERATOR IN (p_i_v_slot_op))
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) );
            */


    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception Occurred For g_v_sql_id :: ' || g_v_sql_id);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);

        p_o_v_err_cd := SQLCODE || '~' || SQLERRM;

        ROLLBACK;

        PRE_TOS_COMMON_ERROR_LOG (
            g_v_parameter_string
            , 'DECLARE_LST_OUTBOUND'
            , '1'
            , p_o_v_err_cd
            , 'A'
            , g_record_filter
            , g_record_table
            , g_v_upd_by_edi
            , SYSDATE
            , g_v_upd_by_edi
            , SYSDATE
        );

        COMMIT;

        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

END PRE_ECM_DOWNLOAD;

PROCEDURE PRV_EDL_GET_MSG_RCPNT_SET_VAL(
      p_i_v_terminal                 IN  VARCHAR2
    , p_o_v_msg_recp                 OUT VARCHAR2
    , p_o_v_msg_set                  OUT VARCHAR2
    , p_o_v_eme_uid                  OUT VARCHAR2
    , p_o_v_err_cd                   OUT VARCHAR2
) AS

BEGIN

   p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    g_v_parameter_string := p_i_v_terminal         || '~' ||
                            p_o_v_msg_recp         || '~' ||
                            p_o_v_msg_set          || '~' ||
                            p_o_v_eme_uid          || '~' ||
                            p_o_v_err_cd;


   SELECT DECODE(ROWCOUNT,1,RECEIVER_ID,'') RECEIVER_ID
        , DECODE(ROWCOUNT,1,MSG_SET,'')     MSG_SET
        , DECODE(ROWCOUNT,1,EME_UID,'')     EME_UID
   INTO   p_o_v_msg_recp
        , p_o_v_msg_set
        , p_o_v_eme_uid
   FROM   (
            SELECT COUNT(1) OVER()              ROWCOUNT
                , ROWNUM                        SL_NO
                , EPH.TRADING_PARTNER           RECEIVER_ID
                , EMS.MESSAGE_CODE              MSG_SET
                , EME.EME_UID                   EME_UID
            FROM   EDI_MESSAGE_EXCHANGE         EME
                , EDI_MESSAGE_SET               EMS
                , EDI_PARTNER_HEADER            EPH
                , EDI_API_HEADER                EAH
                , ITP025                        ITP
                , EDI_PARTNER_LOCATION          EPL
                , ITP130                        TERM
            WHERE  EME.EMS_UID         = EMS.EMS_UID
            AND    EME.ETP_UID         = EPH.ETP_UID
            AND    EME.API_UID         = EAH.API_UID
            AND    EPH.TRADING_PARTNER = ITP.VCVNCD
            AND    EPH.ETP_UID         = EPL.ETP_UID
            AND    EPL.LOCATION_CODE   = TERM.TQTERM
            AND    EME.DIRECTION       = 'OUT'
            AND    EME.MODULE          = g_v_declare_list_module
            AND    EME.RECORD_STATUS   = 'A'
            AND    EPL.RECORD_STATUS   = 'A'
            AND    EMS.RECORD_STATUS   = 'A'
            AND    EPH.RECORD_STATUS   = 'A'
            AND    EAH.RECORD_STATUS   = 'A'
            AND    EPL.LOCATION_CODE   = p_i_v_terminal
          )
  WHERE SL_NO=1;

  EXCEPTION

  WHEN NO_DATA_FOUND THEN
        p_o_v_err_cd:= PCE_EUT_COMMON.G_V_GE0004;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

  WHEN OTHERS THEN
        p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);

        ROLLBACK;

        PRE_TOS_COMMON_ERROR_LOG (
            g_v_parameter_string
            , 'DECLARE_LST_OUTBOUND'
            , '1'
            , p_o_v_err_cd
            , 'A'
            , g_record_filter
            , g_record_table
            , g_v_upd_by_edi
            , SYSDATE
            , g_v_upd_by_edi
            , SYSDATE
        );

        COMMIT;

        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

     END PRV_EDL_GET_MSG_RCPNT_SET_VAL;

     /*
          Procecure to get the terminal for pod1, pod2, pod3, 06.06.2012 by vikas
     */
    PROCEDURE PRE_GET_NEXT_POD_TERMINAL (
        p_i_v_booking_no                 VARCHAR2,
        p_i_n_voyno_seq                  NUMBER,
        p_o_v_next_pod1_terminal         OUT NOCOPY VARCHAR2,
        p_o_v_next_pod2_terminal         OUT NOCOPY VARCHAR2,
        p_o_v_next_pod3_terminal         OUT NOCOPY VARCHAR2,
        p_o_v_final_pod_terminal         OUT NOCOPY VARCHAR2,
        p_o_v_next_service               OUT NOCOPY VARCHAR2,
        p_o_v_next_vessel                OUT NOCOPY VARCHAR2,
        p_o_v_next_voyno                 OUT NOCOPY VARCHAR2,
        p_o_v_next_dir                   OUT NOCOPY VARCHAR2
    ) IS

    SHIP                 VARCHAR2(1) DEFAULT 'S';
    l_n_count            NUMBER:=0;
    l_v_discharge_port   BOOKING_VOYAGE_ROUTING_DTL.DISCHARGE_PORT%TYPE;
    l_v_to_terminal      BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;
    l_v_routing_type     BOOKING_VOYAGE_ROUTING_DTL.ROUTING_TYPE%TYPE;

    CURSOR l_cur_fun IS
        SELECT
            SERVICE,
            VESSEL,
            VOYNO,
            DIRECTION,
            DISCHARGE_PORT,
            TO_TERMINAL,
            BOOKING_NO
        FROM
            BOOKING_VOYAGE_ROUTING_DTL
        WHERE
            BOOKING_NO=p_i_v_booking_no
            AND ROUTING_TYPE=SHIP
            AND VOYAGE_SEQNO >= p_i_n_voyno_seq
            AND    VESSEL IS NOT NULL
            AND    VOYNO IS NOT NULL
        ORDER BY
            VOYAGE_SEQNO;
    BEGIN

          /*
               Get pod1, pod2, pod3 termina value from BVRD table.
          */
        FOR I IN l_cur_fun
        LOOP
            l_n_count:= l_n_count+1;

            IF l_n_count=1 THEN
                p_o_v_next_pod1_terminal:=I.TO_TERMINAL;

            ELSIF  l_n_count=2 THEN
                    p_o_v_next_pod2_terminal:=I.TO_TERMINAL;
                    p_o_v_next_service :=I.SERVICE;
                    p_o_v_next_vessel  :=I.VESSEL;
                    p_o_v_next_voyno   :=I.VOYNO;
                    p_o_v_next_dir     :=I.DIRECTION;

            ELSIF  l_n_count=3 THEN
                    p_o_v_next_pod3_terminal:=I.TO_TERMINAL;

            END IF;

        END LOOP;

        l_n_count:=0;

        /*
            Get final pod
        */
          BEGIN
            /* Get the last leg information */
            SELECT
                DISCHARGE_PORT,
                TO_TERMINAL,
                ROUTING_TYPE
            INTO
                l_v_discharge_port,
                l_v_to_terminal,
                l_v_routing_type
            FROM
                BOOKING_VOYAGE_ROUTING_DTL
            WHERE
                BOOKING_NO = p_i_v_booking_no
                AND VOYAGE_SEQNO =
                    (SELECT
                        MAX(VOYAGE_SEQNO)
                    FROM
                        BOOKING_VOYAGE_ROUTING_DTL
                    WHERE
                        BOOKING_NO = p_i_v_booking_no
                );

            /* When last leg is not sea, then use discharge port as final destination */
            IF l_v_routing_type != SHIP THEN
                p_o_v_final_pod_terminal := l_v_discharge_port;
            ELSE
                p_o_v_final_pod_terminal := l_v_to_terminal;
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line(sqlerrm);
                p_o_v_final_pod_terminal := NULL;

        END; -- end final pod if block

        DBMS_OUTPUT.PUT_LINE(
            p_i_v_booking_no
            ||'~'|| p_i_n_voyno_seq
            ||'~'|| p_o_v_next_pod1_terminal
            ||'~'|| p_o_v_next_pod2_terminal
            ||'~'|| p_o_v_next_pod3_terminal
            ||'~'|| p_o_v_final_pod_terminal
            ||'~'|| p_o_v_next_service
            ||'~'|| p_o_v_next_vessel
            ||'~'|| p_o_v_next_voyno
            ||'~'|| p_o_v_next_dir
        );

        EXCEPTION
            WHEN OTHERS THEN
                p_o_v_next_pod1_terminal        :=NULL;
                p_o_v_next_pod2_terminal        :=NULL;
                p_o_v_next_pod3_terminal        :=NULL;
                p_o_v_final_pod_terminal        :=NULL;
                p_o_v_next_service              :=NULL;
                p_o_v_next_vessel               :=NULL;
                p_o_v_next_voyno                :=NULL;
                p_o_v_next_dir                  :=NULL;

    END PRE_GET_NEXT_POD_TERMINAL;

END PCE_ECM_DECLARE_LIST;
