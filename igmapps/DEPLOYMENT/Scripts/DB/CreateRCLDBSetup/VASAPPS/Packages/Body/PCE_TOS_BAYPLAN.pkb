CREATE OR REPLACE PACKAGE BODY PCE_TOS_BAYPLAN AS

    PROCEDURE PRE_TOS_CREATE_BAYPLAN (
          p_i_v_port                    IN           VARCHAR2
        , p_i_v_service                 IN           VARCHAR2
        , p_i_v_vessel                  IN           VARCHAR2
        , p_i_v_terminal                IN           VARCHAR2
        , p_i_v_voyage                  IN           VARCHAR2
        , p_i_v_direction               IN           VARCHAR2
        , p_i_v_function_cd             IN           VARCHAR2
        , p_i_v_eme_uid                 IN           NUMBER
        , p_i_dt_dl_eta                 IN           VARCHAR2
        , p_i_dt_ll_etd                 IN           VARCHAR2
        , p_i_v_rob                     IN           VARCHAR2
        , p_i_v_cont_op_flag            IN           VARCHAR2
        , p_i_v_slot_op_flag            IN           VARCHAR2
        , p_i_v_cont_op                 IN           VARCHAR2
        , p_i_v_slot_op                 IN           VARCHAR2
        , p_i_v_ll_dl_flag              IN           VARCHAR2  -- *1
        , p_o_v_err_cd                  OUT          VARCHAR2
    )AS
    /*************************************************************************************
    * Name           : PRE_TOS_CREATE_BAYPLAN                                            *
    * Module         : EZLL                                                              *
    * Purpose        : This  Stored  Procedure is for BayPlan                            *
    * Calls          : None                                                              *
    * Returns        : NONE                                                              *
    * Steps Involved :                                                                   *
    * History        : None                                                              *
    * Author           Date               What                                           *
    * ---------------  ----------         ----                                           *
    * Arijeet          01/03/2011         1.0                                            *
    * *1 Vikas         10/04/2012         Bookings for the current port should not be    *
    *                                     included in bay plan.                          *
    * *2 Vikas         11/04/2012         No need to check voyage because some time      *
    *                                     in-voyage is different from out-voyage,        *
    *                                     suggested by k'nim.                            *
    * *3 Vikas         17/04/2012         Populate loc+147 data even if cell location    *
    *                                     is null suggested by k'chatgamol               *
    * *4 vikas         25.04.2012         For location 83 no need to check POD1,         *
    *                                     as k'chatgamol                                 *
    * *5 vikas         27.04.2012         ROB Exclude, for load list generate EDI only   *
    *                                     for the POL and, for discharge list generate   *
    *                                     EDI only for POD, as k'durai                   *
    * *6 vikas         30.04.2012         Exclude the port which is not rob or           *
    *                                     tranship or discharge at current port          *
    *                                     as k'chatgamol                                 *
    * *7 vikas         30.05.2012         No need to populate loc+11 for all voyage      *
    *                                     sequence,populate loc+11 only for the          *
    *                                     discharge port, k'chatgamol, 29.05.2012        *
    * *8 vikas         27.08.2012         Get PACKING_GROUP, HAZ_MAT_SUB_CLASS,          *
    *                                      MFAG_PAGE, EMS_PAGE, MARINE_POLLUTANT,         *
    *                                      LIMITED_QUANTITY, EXPLOSIVE_CONTENT from       *
    *                                      BL and if value not found then use blank value,*
    *                                      and continue update operation                  *
    *                                      in EDI_ST_DOC_HAZARD,                          *
    *                                      k'chatgamol, 29.05.2012                        *
    *9:  Modified by vikas, for loc+83, If MLO_DEL not blank populate MLO_DEL else MLO_POD3 not blank
         populate MLO_POD3 else MLO_POD2 not blank populate MLO_POD2 else MLO_POD1 not blank populate MLO_POD1
         else populate final_dest, as k'chatgamol n druai, 19.09.2012
    *10: Modified by vikas, for performance tunning, remove first loop from which populate
         edi_document_log, as k'chatgamol n k'myo, 02.10.2012
    *11: Modified by vikas, for performance tunning, remove logging, as k'chatgamol,
         04.10.2012                                                                      *
    *12: Modified by vikas, Remove service from the bayplan view query, as k'chatgamol,
         21.01.2013                                                                      *
    *14: Added by vikas, Added new logic to populate CLR code, as k'chatgamol,
         25.01.2013                                                                      *

    *15: Added by vikas, Added logic to check the booking exists in next voyage or not,
         as k'chatgamol, 26.02.2013
    *16: Modified by vikas, remove unused code, as k'chatgamol, 28.02.2013
    *17: Issue fix by vikas, When No need to check pod_pcsq and act_port_seq while
         checking booking is rob or not, in next voyage, as k'chatgamol, 27.05.2013
	*18: Modified by leena, download to excel throwing exceotion due to multiple 
		 records returned in subquery 
    **************************************************************************************/
    l_e_no_data_found                       EXCEPTION;
    l_v_sql_type                            VARCHAR2(1) := '1';
    l_v_parameter_str                       TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;

    l_dt_bayplan                            DATE;
    l_v_previous_port                       VARCHAR2(5);
    l_v_msg_ref                             VARCHAR2(17);
    l_n_edi_etd_seq                         NUMBER;
    l_n_edi_esdj_uid                        NUMBER;
    l_dt_arrival                            DATE;
    l_dt_sailing                            DATE;
    l_v_api_uid                             EDI_MESSAGE_EXCHANGE.API_UID%TYPE;

    l_n_arvl_code                           NUMBER;
    l_n_sail_code                           NUMBER;
    l_cnt_arvl_code1                        NUMBER := 178;
    l_cnt_arvl_code2                        NUMBER := 132;
    l_cnt_sail_code1                        NUMBER := 136;
    l_cnt_sail_code2                        NUMBER := 133;

    l_n_edi_esdl_uid                        NUMBER;
    l_n_edi_esde_uid                        NUMBER;
    l_v_hazardous                           VARCHAR2(1);
    l_v_restow_pos                          VARCHAR2(7);
    l_n_edi_esdp_uid                        NUMBER;
    l_n_edi_esdcn_uid                       NUMBER;
    l_v_hndl_inst_desc1                     SHP007.SHI_DESCRIPTION%TYPE;
    l_v_hndl_inst_desc2                     SHP007.SHI_DESCRIPTION%TYPE;
    l_v_hndl_inst_desc3                     SHP007.SHI_DESCRIPTION%TYPE;
    l_v_cont_ld_rem_desc1                   SHP041.CLR_DESC%TYPE;
    l_v_cont_ld_rem_desc2                   SHP041.CLR_DESC%TYPE;
    l_n_edi_esdco_uid                       NUMBER;
    l_n_cnt                                 NUMBER := 0;
    l_cnt_weight_uom                        VARCHAR2(3) := 'KGM';
    l_cnt_length_uom                        VARCHAR2(3) := 'CMT';
    l_cnt_volume_uom                        VARCHAR2(3) := 'MTQ';
    l_v_bill_of_landing                     IDP010.AYBLNO%TYPE;
    l_n_msg_ref_seq                         VARCHAR2(12);
    l_v_booking_no                          TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE;
    l_v_scf                                 VARCHAR2(2);
    l_v_module                              VARCHAR2(7) := 'EZLL';
    l_v_add_user                            VARCHAR2(3) := 'EDI';

    l_arr_var_name                          STRING_ARRAY ;
    l_arr_var_value                         STRING_ARRAY ;
    l_arr_var_io                            STRING_ARRAY ;
    l_t_log_info                            TIMESTAMP(6) ;
    l_v_obj_nm                              VARCHAR2(100);
    /* l_b_raise_exp                           BOOLEAN; */ -- *15
    l_b_raise_exp                           VARCHAR2(5); -- *15

    l_v_port                                VARCHAR2(100) := FE_TRANS_DATA(p_i_v_eme_uid,'PORT',p_i_v_port);
    l_v_service                             VARCHAR2(100) := FE_TRANS_DATA(p_i_v_eme_uid,'SERVICE',p_i_v_service);
    l_v_vessel                              VARCHAR2(100) := FE_TRANS_DATA(p_i_v_eme_uid,'VESSEL',p_i_v_vessel);
    l_v_terminal                            VARCHAR2(100) := FE_TRANS_DATA(p_i_v_eme_uid,'TERMINAL',p_i_v_terminal);
    l_v_voyage                              VARCHAR2(100) := FE_TRANS_DATA(p_i_v_eme_uid,'VOYAGE',p_i_v_voyage);
    l_v_direction                           VARCHAR2(100) := FE_TRANS_DATA(p_i_v_eme_uid,'DIRECTION',p_i_v_direction);
    l_v_function_cd                         VARCHAR2(1)   := FE_TRANS_DATA(p_i_v_eme_uid,'FUNCTION_CODE',p_i_v_function_cd);

    l_v_picode                              ITP040.PICODE%TYPE;
    l_v_piname                              ITP040.PINAME%TYPE;
    l_v_pist                                ITP040.PIST%TYPE;
    l_v_picncd                              ITP040.PICNCD%TYPE;

    l_v_tqtord                              ITP130.TQTORD%TYPE;
    l_v_tqtrnm                              ITP130.TQTRNM%TYPE;

    l_v_sizetype                            VARCHAR2(4);
    l_v_type_desc                           ITP076.ISDESC%TYPE;
    l_v_sl_no_sh                            IDP055.EYSSEL%TYPE;
    l_v_sl_no_ca                            IDP055.EYCRSL%TYPE;
    l_v_sl_no_cu                            IDP055.EYCSEL%TYPE;
    l_v_air_pressure                        IDP055.AIR_PRESSURE%TYPE;
    l_v_piece_count                         IDP055.EYPCKG%TYPE;
    l_v_package_type                        IDP055.EYKIND%TYPE;
    l_v_movement_type                       IDP055.EYDANG%TYPE;
    /* l_v_haulage_arrang                   IDP055.EYPCKG%TYPE; commented by vikas */
    l_v_haulage_arrang                      BKP001.ORIGIN_HAULAGE%TYPE;

    l_v_nature_of_cargo                     IDP055.EYKIND%TYPE;
    l_v_comm                                IDP050.BYCMCD%TYPE;
    l_v_descp                               IDP050.BYRMKS%TYPE;
    l_v_bpackage_type                       IDP050.BYKIND%TYPE;
    l_v_bpiece_count                        IDP050.BYPCKG%TYPE;
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
    l_v_marine_pollutant                    IDP051.MARINE_POLLUTANT%TYPE;
    l_v_limited_quantity                    IDP051.LIMITED_QUANTITY%TYPE;
    l_v_explosive_content                   VARCHAR2(1);
--    l_b_first_rec                           BOOLEAN := TRUE; -- *15
    l_v_location_type                       VARCHAR(3);
    l_v_rob                                 VARCHAR2(1);
    l_v_shipment_type                       VARCHAR2(10);
    l_v_full_mt                             VARCHAR2(10);
    l_cnt_weight_uom_t                      VARCHAR2(3);
    l_cnt_volume_uom_t                      VARCHAR2(3);
    l_v_temperature_uom                     VARCHAR2(3);
    l_v_temperature_uom_t                   VARCHAR2(3);
    l_v_movement_from                       ITP070.FROM_LOCATION_TYPE%TYPE;
    l_v_movement_to                         ITP070.TO_LOCATION_TYPE%TYPE;
    l_v_invoyageno                          VARCHAR2(100) ;
    /* ***************** Start added by vikas ********** */
    l_n_count_alias                         NUMBER;
    l_v_customer_alias                      ITP010.CUSTOMER_ALIAS%TYPE;
    l_v_place_of_delivery                   IDP010.FINAL_PLACE_OF_DELIVERY_CODE%TYPE;
    l_v_place_of_receipt                    BKP001.BAORGN%TYPE;
    v_previous_terminal                     ITP063.VVTRM1%TYPE;
    v_previous_port                         ITP063.VVPCAL%TYPE;
    /* ***************** End added by vikas ********** */

    l_v_edi_etd_uid                         EDI_ST_DOC_HEADER.EDI_ETD_UID%TYPE; --Added by Dhruv Parekh
    l_v_fcdesc                              ITP080.FCDESC%TYPE;            --Added by Dhruv Parekh
    l_v_bycmcd                              IDP050.BYCMCD%TYPE;            --Added by Dhruv Parekh

    L_V_SPACE                               VARCHAR2(5) DEFAULT '  ';    -- *3
    /*
        Start added by chatgamol, 15.12.2011
    */

    L_V_START_TIME TIMESTAMP := CURRENT_TIMESTAMP; -- *15

    TYPE varchar2_table IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
    /* *15 start */
    L_ARR_V_UNIQUE_BOOKING STRING_ARRAY;
    TRUE                     CONSTANT VARCHAR2(5) DEFAULT 'true';
    FALSE                    CONSTANT VARCHAR2(5) DEFAULT 'false';
    IS_BOOKING_CHECKED       VARCHAR2(5) DEFAULT  FALSE;
    IS_FIRST_TIME            VARCHAR2(5) DEFAULT  FALSE;
    IDX                      INTEGER;
    /* L_V_VOYAGE               BOOKING_VOYAGE_ROUTING_DTL.VOYNO%TYPE; */
    L_V_ACT_VOYAGE_NUMBER    BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER%TYPE;
    /* L_V_VESSEL               BOOKING_VOYAGE_ROUTING_DTL.VESSEL%TYPE; */
    L_V_VOYNO                BOOKING_VOYAGE_ROUTING_DTL.VOYNO%TYPE;
    L_V_LOAD_PORT            BOOKING_VOYAGE_ROUTING_DTL.LOAD_PORT%TYPE;
    L_V_POL_PCSQ             BOOKING_VOYAGE_ROUTING_DTL.POL_PCSQ%TYPE;
    L_V_MAX_PORT_SEQ         ITP063.VVPCSQ%TYPE;
    L_V_ITP_ETA              ITP063.VVARDT%TYPE;
    L_V_ITP_ETD              ITP063.VVDPDT%TYPE;
    L_V_ITP_ETA_TIME         ITP063.VVARTM%TYPE;
    L_V_ITP_ETD_TIME         ITP063.VVDPTM%TYPE;
    L_V_LAST_PORT            ITP063.VVPCAL%TYPE;
    L_V_NEXT_VOYAGE          ITP063.VVVOYN%TYPE;
    /* L_V_PORT                 ITP063.VVPCAL%TYPE; */
    L_V_PORT_SEQ             ITP063.VVPCSQ%TYPE;
    L_V_ERROR                VARCHAR2(4000);
    IS_ROB                   VARCHAR2(5) := FALSE;
    IS_NEED_MORE_ROB_CHECK   VARCHAR2(5) := FALSE;
    IS_ACTVOY_NXT_VOY_SAME   VARCHAR2(5) := FALSE;
    IS_PORT_FOUND_IN_NXT_VOY VARCHAR2(5) := FALSE;
    IS_BOOKING_ROB           VARCHAR2(5) := FALSE;

    NEXT_VOYAGE_NOT_FOUND    EXCEPTION;
    ORACLE_EXCEPTION         EXCEPTION;
    /* *15 end */

    var_list VARCHAR2(1000);
    arr_table dbms_utility.lname_array;
    arr_cnt BINARY_INTEGER;

    p_delim VARCHAR2(1) DEFAULT ',';
    v_nfields PLS_INTEGER := 1;
    v_table varchar2_table;
    v_delimpos PLS_INTEGER;
    v_delimlen PLS_INTEGER;
    v_string   TOS_LL_BOOKED_LOADING.PUBLIC_REMARK%TYPE;

    l_v_public_remark VASAPPS.TOS_DL_BOOKED_DISCHARGE.PUBLIC_REMARK%TYPE;
    /*
        End added by chatgamol, 15.12.2011
    */

    CURSOR l_cur_bayplan (p_v_date DATE, l_v_rob varchar2) IS
        SELECT DISTINCT DL_SERVICE -- Modified, 31.01.2012
              ,DL_VESSEL
              ,DL_VOYAGE
              ,DL_DIRECTION
              ,DL_PORT_SEQ
              ,DL_FK_BOOKING_NO
              ,DL_DN_EQUIPMENT_NO
              ,LL_POL
              ,DL_POD
              ,DL_ETA
              ,LL_ETD
              ,DL_DN_SHIPMENT_TYP
              ,DL_DN_SOC_COC
              ,DL_DN_FINAL_POD
              ,DL_DN_NXT_POD1
              ,DL_DN_NXT_POD2
              ,DL_DN_NXT_POD3
              ,DL_LOAD_CONDITION
              ,DL_CONTAINER_GROSS_WEIGHT
              ,DL_OVERLENGTH_FRONT_CM
              ,DL_OVERLENGTH_REAR_CM
              ,DL_OVERWIDTH_RIGHT_CM
              ,DL_OVERWIDTH_LEFT_CM
              ,DL_OVERHEIGHT_CM
              ,DL_REEFER_TEMPERATURE
              ,DL_REEFER_TMP_UNIT
              ,DL_DN_HUMIDITY
              ,DL_DN_VENTILATION
              ,DL_FLASH_POINT
              ,DL_FLASH_UNIT
              ,DL_FK_IMDG
              ,DL_FK_UNNO
              ,DL_STOWAGE_POSITION
              ,LL_STOWAGE_POSITION
              ,DL_FK_HANDLING_INSTRUCTION_1
              ,DL_FK_HANDLING_INSTRUCTION_2
              ,DL_FK_HANDLING_INSTRUCTION_3
              ,DL_CONTAINER_LOADING_REM_1
              ,DL_CONTAINER_LOADING_REM_2
              ,DL_RESIDUE_ONLY_FLAG
              ,DL_DN_EQ_SIZE
              ,DL_DN_EQ_TYPE
              ,DL_FK_PORT_CLASS
              ,LL_ACTIVITY_DATE_TIME
              ,DL_ACTIVITY_DATE_TIME
              ,LL_RECORD_STATUS
              ,LL_LL_RECORD_STATUS
              ,DL_RECORD_STATUS
              ,DL_DL_RECORD_STATUS
              ,LL_FK_LOAD_LIST_ID
              ,DL_FK_DISCHARGE_LIST_ID
              ,LL_LOAD_LIST_STATUS
              ,DL_DISCHARGE_LIST_STATUS
              ,LL_VESSEL
              ,LL_CONTAINER_SEQ_NO
              ,DL_CONTAINER_SEQ_NO
              ,LL_DN_DISCHARGE_TERMINAL
              ,DL_DN_POL_TERMINAL
              ,DL_FK_SLOT_OPERATOR  -- vikas
              ,DL_OUT_SLOT_OPERATOR -- vikas: NEED TO edit view v_tos_onboard_container
              ,DL_FK_BKG_VOYAGE_ROUTING_DTL -- vikas: NEED TO edit view v_tos_onboard_container
              ,DL_FINAL_DEST -- vikas: NEED TO edit view v_tos_onboard_container
              ,LL_DN_FULL_MT   -- vikas: NEED TO edit view v_tos_onboard_container
              ,LL_DN_DISCHARGE_PORT    -- vikas: NEED TO edit view v_tos_onboard_container
              ,BKP1.BAPOD BAPOD -- vikas
              ,BKP1.BAPOL BAPOL -- vikas
              ,DL_FK_CONTAINER_OPERATOR -- vikas
              ,DL_MLO_DEL     -- vikas , 09.11.2011
              ,DL_MLO_POD1    -- vikas , 09.11.2011
              ,DL_MLO_POD2 -- *9
              ,DL_MLO_POD3 -- *9
              ,DL_DN_SPECIAL_HNDL -- *14
              ,DL_LOCAL_TERMINAL_STATUS -- vikas, 14.12.2011
              ,FE_TRANS_DATA(p_i_v_eme_uid,'SERVICE',DL_SERVICE)                                       T_DL_SERVICE
              ,FE_TRANS_DATA(p_i_v_eme_uid,'VESSEL',DL_VESSEL)                                         T_DL_VESSEL
              ,FE_TRANS_DATA(p_i_v_eme_uid,'VOYAGE',DL_VOYAGE)                                         T_DL_VOYAGE
              ,FE_TRANS_DATA(p_i_v_eme_uid,'DIRECTION',DL_DIRECTION)                                   T_DL_DIRECTION
              ,FE_TRANS_DATA(p_i_v_eme_uid,'PORT_SEQ',DL_PORT_SEQ)                                     T_DL_PORT_SEQ
              ,FE_TRANS_DATA(p_i_v_eme_uid,'BOOKING_NO',DL_FK_BOOKING_NO)                              T_DL_FK_BOOKING_NO
              ,FE_TRANS_DATA(p_i_v_eme_uid,'EQUIPMENT_NO',DL_DN_EQUIPMENT_NO)                          T_DL_DN_EQUIPMENT_NO
              ,FE_TRANS_DATA(p_i_v_eme_uid,'POL',LL_POL)                                               T_LL_POL
              ,FE_TRANS_DATA(p_i_v_eme_uid,'POD',DL_POD)                                               T_DL_POD
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ETA',DL_ETA)                                               T_DL_ETA
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ETD',LL_ETD)                                               T_LL_ETD
              ,FE_TRANS_DATA(p_i_v_eme_uid,'SHIPMENT_TYP',DL_DN_SHIPMENT_TYP)                          T_DL_DN_SHIPMENT_TYP
              ,FE_TRANS_DATA(p_i_v_eme_uid,'SOC_COC',DL_DN_SOC_COC)                                    T_DL_DN_SOC_COC
              ,FE_TRANS_DATA(p_i_v_eme_uid,'FINAL_POD',DL_DN_FINAL_POD)                                T_DL_DN_FINAL_POD
              ,FE_TRANS_DATA(p_i_v_eme_uid,'NXT_POD1',DL_DN_NXT_POD1)                                  T_DL_DN_NXT_POD1
              ,FE_TRANS_DATA(p_i_v_eme_uid,'NXT_POD2',DL_DN_NXT_POD2)                                  T_DL_DN_NXT_POD2
              ,FE_TRANS_DATA(p_i_v_eme_uid,'NXT_POD3',DL_DN_NXT_POD3)                                  T_DL_DN_NXT_POD3
              ,FE_TRANS_DATA(p_i_v_eme_uid,'LOAD_CONDITION',DL_LOAD_CONDITION)                         T_DL_LOAD_CONDITION
              ,FE_TRANS_DATA(p_i_v_eme_uid,'CONTAINER_GROSS_WEIGHT',DL_CONTAINER_GROSS_WEIGHT)         T_DL_CONTAINER_GROSS_WEIGHT
              ,FE_TRANS_DATA(p_i_v_eme_uid,'OVERLENGTH_FRONT_CM',DL_OVERLENGTH_FRONT_CM)               T_DL_OVERLENGTH_FRONT_CM
              ,FE_TRANS_DATA(p_i_v_eme_uid,'OVERLENGTH_REAR_CM',DL_OVERLENGTH_REAR_CM)                 T_DL_OVERLENGTH_REAR_CM
              ,FE_TRANS_DATA(p_i_v_eme_uid,'OVERWIDTH_RIGHT_CM',DL_OVERWIDTH_RIGHT_CM)                 T_DL_OVERWIDTH_RIGHT_CM
              ,FE_TRANS_DATA(p_i_v_eme_uid,'OVERWIDTH_LEFT_CM',DL_OVERWIDTH_LEFT_CM)                   T_DL_OVERWIDTH_LEFT_CM
              ,FE_TRANS_DATA(p_i_v_eme_uid,'OVERHEIGHT_CM',DL_OVERHEIGHT_CM)                           T_DL_OVERHEIGHT_CM
              ,FE_TRANS_DATA(p_i_v_eme_uid,'REEFER_TEMPERATURE',DL_REEFER_TEMPERATURE)                 T_DL_REEFER_TEMPERATURE
              ,FE_TRANS_DATA(p_i_v_eme_uid,'REEFER_TMP_UNIT',DL_REEFER_TMP_UNIT)                       T_DL_REEFER_TMP_UNIT
              ,FE_TRANS_DATA(p_i_v_eme_uid,'HUMIDITY',DL_DN_HUMIDITY)                                  T_DL_DN_HUMIDITY
              ,FE_TRANS_DATA(p_i_v_eme_uid,'VENTILATION',DL_DN_VENTILATION)                            T_DL_DN_VENTILATION
              ,FE_TRANS_DATA(p_i_v_eme_uid,'FLASH_POINT',DL_FLASH_POINT)                               T_DL_FLASH_POINT
              ,FE_TRANS_DATA(p_i_v_eme_uid,'FLASH_UNIT',DL_FLASH_UNIT)                                 T_DL_FLASH_UNIT
              ,FE_TRANS_DATA(p_i_v_eme_uid,'IMDG',DL_FK_IMDG)                                          T_DL_FK_IMDG
              ,FE_TRANS_DATA(p_i_v_eme_uid,'UNNO',DL_FK_UNNO)                                          T_DL_FK_UNNO
              ,FE_TRANS_DATA(p_i_v_eme_uid,'STOWAGE_POSITION',DL_STOWAGE_POSITION)                     T_DL_STOWAGE_POSITION
              ,FE_TRANS_DATA(p_i_v_eme_uid,'STOWAGE_POSITION',LL_STOWAGE_POSITION)                     T_LL_STOWAGE_POSITION
              ,FE_TRANS_DATA(p_i_v_eme_uid,'HANDLING_INSTRUCTION_1',DL_FK_HANDLING_INSTRUCTION_1)      T_DL_FK_HANDLING_INSTRUCTION_1
              ,FE_TRANS_DATA(p_i_v_eme_uid,'HANDLING_INSTRUCTION_2',DL_FK_HANDLING_INSTRUCTION_2)      T_DL_FK_HANDLING_INSTRUCTION_2
              ,FE_TRANS_DATA(p_i_v_eme_uid,'HANDLING_INSTRUCTION_3',DL_FK_HANDLING_INSTRUCTION_3)      T_DL_FK_HANDLING_INSTRUCTION_3
              ,FE_TRANS_DATA(p_i_v_eme_uid,'CONTAINER_LOADING_REM_1',DL_CONTAINER_LOADING_REM_1)       T_DL_CONTAINER_LOADING_REM_1
              ,FE_TRANS_DATA(p_i_v_eme_uid,'CONTAINER_LOADING_REM_2',DL_CONTAINER_LOADING_REM_2)       T_DL_CONTAINER_LOADING_REM_2
              ,FE_TRANS_DATA(p_i_v_eme_uid,'RESIDUE_ONLY_FLAG',DL_RESIDUE_ONLY_FLAG)                   T_DL_RESIDUE_ONLY_FLAG
              ,FE_TRANS_DATA(p_i_v_eme_uid,'EQ_SIZE',DL_DN_EQ_SIZE)                                    T_DL_DN_EQ_SIZE
              ,FE_TRANS_DATA(p_i_v_eme_uid,'EQ_TYPE',DL_DN_EQ_TYPE)                                    T_DL_DN_EQ_TYPE
              ,FE_TRANS_DATA(p_i_v_eme_uid,'PORT_CLASS',DL_FK_PORT_CLASS)                              T_DL_FK_PORT_CLASS
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ACTIVITY_DATE_TIME',LL_ACTIVITY_DATE_TIME)                 T_LL_ACTIVITY_DATE_TIME
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ACTIVITY_DATE_TIME',DL_ACTIVITY_DATE_TIME)                 T_DL_ACTIVITY_DATE_TIME
              ,FE_TRANS_DATA(p_i_v_eme_uid,'RECORD_STATUS',LL_RECORD_STATUS)                           T_LL_RECORD_STATUS
              ,FE_TRANS_DATA(p_i_v_eme_uid,'RECORD_STATUS',LL_LL_RECORD_STATUS)                        T_LL_LL_RECORD_STATUS
              ,FE_TRANS_DATA(p_i_v_eme_uid,'RECORD_STATUS',DL_RECORD_STATUS)                           T_DL_RECORD_STATUS
              ,FE_TRANS_DATA(p_i_v_eme_uid,'RECORD_STATUS',DL_DL_RECORD_STATUS)                        T_DL_DL_RECORD_STATUS
              ,FE_TRANS_DATA(p_i_v_eme_uid,'LOAD_LIST_ID',LL_FK_LOAD_LIST_ID)                          T_LL_FK_LOAD_LIST_ID
              ,FE_TRANS_DATA(p_i_v_eme_uid,'DISCHARGE_LIST_ID',DL_FK_DISCHARGE_LIST_ID)                T_DL_FK_DISCHARGE_LIST_ID
              ,FE_TRANS_DATA(p_i_v_eme_uid,'LOAD_LIST_STATUS',LL_LOAD_LIST_STATUS)                     T_LL_LOAD_LIST_STATUS
              ,FE_TRANS_DATA(p_i_v_eme_uid,'DISCHARGE_LIST_STATUS',DL_DISCHARGE_LIST_STATUS)           T_DL_DISCHARGE_LIST_STATUS
              ,FE_TRANS_DATA(p_i_v_eme_uid,'VESSEL',LL_VESSEL)                                         T_LL_VESSEL
              ,FE_TRANS_DATA(p_i_v_eme_uid,'CONTAINER_SEQ_NO',LL_CONTAINER_SEQ_NO)                     T_LL_CONTAINER_SEQ_NO
              ,FE_TRANS_DATA(p_i_v_eme_uid,'CONTAINER_SEQ_NO',DL_CONTAINER_SEQ_NO)                     T_DL_CONTAINER_SEQ_NO
              ,FE_TRANS_DATA(p_i_v_eme_uid,'DISCHARGE_TERMINAL',LL_DN_DISCHARGE_TERMINAL)              T_LL_DN_DISCHARGE_TERMINAL
              ,FE_TRANS_DATA(p_i_v_eme_uid,'POL_TERMINAL',DL_DN_POL_TERMINAL)                          T_DL_DN_POL_TERMINAL
        FROM  V_TOS_ONBOARD_CONTAINER
            , BKP001                    BKP1      -- vikas
        WHERE BKP1.BABKNO      = DL_FK_BOOKING_NO -- vikas
        -- AND   DL_SERVICE       = p_i_v_service -- *12
        AND   LL_VESSEL        = p_i_v_vessel
        -- AND   DL_VOYAGE        = p_i_v_voyage -- *2
        AND    ( -- *1
                (p_i_v_ll_dl_flag = 'L' AND DL_POD <> p_i_v_port) -- *1
                OR -- *1
                (p_i_v_ll_dl_flag = 'D' AND LL_POL <> p_i_v_port)-- *1
            ) -- *1
        AND ( -- *5
                (l_v_rob = 'Y')  -- *5
                OR  -- *5
                (  -- *5
                    (l_v_rob = 'N')  -- *5
                    AND  -- *5
                    ( -- *5
                        (p_i_v_ll_dl_flag = 'L' AND LL_POL = p_i_v_port)  -- *5
                        OR  -- *5
                        (p_i_v_ll_dl_flag = 'D' AND DL_POD = p_i_v_port)  -- *5
                    )  -- *5
                )  -- *5
            ) -- *5


        /*
            Commented by vikas as k'myo suggest that bay plan may have different
            direction ports before turn port and after turn port, 30.01.2012
            AND   DL_DIRECTION     = p_i_v_direction
            End commented by vikas, 30.01.2012
        */
        AND   TRUNC(p_v_date) BETWEEN LL_ETD AND DL_ETA
        -- AND   (l_v_rob = 'Y' OR (DL_DISCHARGE_STATUS NOT IN ('RB') AND LL_LOADING_STATUS NOT IN ('RB'))) -- *5
        /* start added by vikas */
        AND ( (p_i_v_cont_op_flag  = 'E' AND INSTR(p_i_v_cont_op,DL_FK_CONTAINER_OPERATOR )=0)
            OR (p_i_v_cont_op_flag   = 'I' AND  INSTR(p_i_v_cont_op,DL_FK_CONTAINER_OPERATOR )>0)
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND ( (p_i_v_slot_op_flag  = 'E' AND INSTR(p_i_v_slot_op,DL_FK_SLOT_OPERATOR )=0)
            OR  (p_i_v_slot_op_flag   = 'I' AND  INSTR(p_i_v_slot_op,DL_FK_SLOT_OPERATOR )>0)
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) )
        ORDER BY DL_FK_BOOKING_NO; -- *17

        /* *15 start */

        /* AND EXISTS(  --*6 START
            SELECT 1
            FROM
                (SELECT BOOKING_NO
                FROM BOOKING_VOYAGE_ROUTING_DTL
                WHERE
                    VESSEL        = p_i_v_vessel
                    -- AND SERVICE       = p_i_v_service -- *12
                -- AND VOYNO           = p_i_v_voyage
                AND DISCHARGE_PORT <> p_i_v_port
                AND POL_PCSQ        < NVL(
                    (SELECT MIN(VVPCSQ)
                    FROM ITP063
                    WHERE VVVERS  =99
                    AND VVVESS    = VESSEL
                    AND VOYAGE_ID =
                    (SELECT VOYAGE_ID
                    FROM ITP063
                    WHERE VVVERS        =99
                    AND VVVESS          = VESSEL
                    AND VVVOYN          = VOYNO
                    AND OMMISSION_FLAG IS NULL
                    AND VVPCAL          = LOAD_PORT
                    AND ROWNUM          = 1
                    )
                    AND VVPCAL          = p_i_v_port
                    AND VVPCSQ          >POL_PCSQ
                    AND OMMISSION_FLAG IS NULL
                    ),0)
                AND POD_PCSQ > NVL(
                    (SELECT MIN(VVPCSQ)
                    FROM ITP063
                    WHERE VVVERS  =99
                    AND VVVESS    = VESSEL
                    AND VOYAGE_ID =
                    (SELECT VOYAGE_ID
                    FROM ITP063
                    WHERE VVVERS        =99
                    AND VVVESS          = VESSEL
                    AND VVVOYN          = VOYNO
                    AND OMMISSION_FLAG IS NULL
                    AND VVPCAL          = LOAD_PORT
                    AND ROWNUM          = 1
                    )
                    AND VVPCAL          = p_i_v_port
                    AND VVPCSQ          >POL_PCSQ
                    AND OMMISSION_FLAG IS NULL
                    ),0)
                UNION
                SELECT BOOKING_NO
                FROM BOOKING_VOYAGE_ROUTING_DTL
                WHERE VESSEL  = p_i_v_vessel
                -- AND VOYNO     = p_i_v_voyage
                -- AND SERVICE       = p_i_v_service -- *12
                AND LOAD_PORT = p_i_v_port
                UNION
                SELECT BOOKING_NO
                FROM BOOKING_VOYAGE_ROUTING_DTL
                WHERE VESSEL       = p_i_v_vessel
                -- AND SERVICE       =  p_i_v_service -- *12
                -- AND VOYNO          = p_i_v_voyage
                AND DISCHARGE_PORT = p_i_v_port
            )
            WHERE
            BOOKING_NO = DL_FK_BOOKING_NO ); --*6 END */

            /* *15 end */

    /* end added by vikas */
    CURSOR l_cur_party IS
        SELECT SDP050.YTFNME
              ,SDP050.YTDEPT
              ,BKP030.BNBKNO
              ,BKP030.BNCSTP
              ,BKP030.BNCSCD
              ,BKP030.BNLINE
              ,BKP030.BNTRAD
              ,BKP030.BNAGNT
              ,BKP030.BNNAME
              ,BKP030.EXP_DET_BILLTO
              ,BKP030.IMP_DET_DEM_BILLTO
              ,BKP030.BNADD1
              ,BKP030.BNADD2
              ,BKP030.BNADD3
              ,BKP030.BNADD4
              ,BKP030.CITY
              ,BKP030.STATE
              ,BKP030.BNCOUN
              ,BKP030.BNZIP
              ,BKP030.ADDRESS_POINT
              ,BKP030.BNTELN
              ,BKP030.BNFAX
              ,BKP030.BNEMAL
              ,BKP030.BNRCST
              ,BKP030.BNAUSR
              ,BKP030.BNADAT
              ,BKP030.BNATIM
              ,BKP030.BNCUSR
              ,BKP030.BNCDAT
              ,BKP030.BNCTIM
              ,BKP030.TMP_BNTELN
              ,BKP030.TMP_BNFAX
              ,FE_TRANS_DATA(p_i_v_eme_uid,'CONTACT_NM',SDP050.YTFNME)                                   T_YTFNME
              ,FE_TRANS_DATA(p_i_v_eme_uid,'CONTACT_DEPT',SDP050.YTDEPT)                                 T_YTDEPT
              ,BKP030.BNBKNO                                                                             T_BNBKNO
              ,BKP030.BNCSTP                                                                             T_BNCSTP
              ,FE_TRANS_DATA(p_i_v_eme_uid,'PARTY_CODE',BKP030.BNCSCD)                                   T_BNCSCD
              ,BKP030.BNLINE                                                                             T_BNLINE
              ,BKP030.BNTRAD                                                                             T_BNTRAD
              ,BKP030.BNAGNT                                                                             T_BNAGNT
              ,FE_TRANS_DATA(p_i_v_eme_uid,'PARTY_NAME',BKP030.BNNAME)                                   T_BNNAME
              ,BKP030.EXP_DET_BILLTO                                                                     T_EXP_DET_BILLTO
              ,BKP030.IMP_DET_DEM_BILLTO                                                                 T_IMP_DET_DEM_BILLTO
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ADDRESS_LINE_1',BKP030.BNADD1)                               T_BNADD1
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ADDRESS_LINE_2',BKP030.BNADD2)                               T_BNADD2
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ADDRESS_LINE_3',BKP030.BNADD3)                               T_BNADD3
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ADDRESS_LINE_4',BKP030.BNADD4)                               T_BNADD4
              ,FE_TRANS_DATA(p_i_v_eme_uid,'CITY',BKP030.CITY)                                           T_CITY
              ,FE_TRANS_DATA(p_i_v_eme_uid,'STATE',BKP030.STATE)                                         T_STATE
              ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_COUNTRY',BKP030.BNCOUN)                             T_BNCOUN
              ,FE_TRANS_DATA(p_i_v_eme_uid,'POSTAL_CODE',BKP030.BNZIP)                                   T_BNZIP
              ,FE_TRANS_DATA(p_i_v_eme_uid,'ADDRESS_POINT',BKP030.ADDRESS_POINT)                         T_ADDRESS_POINT
              ,FE_TRANS_DATA(p_i_v_eme_uid,'TELEPHONE_NO',BKP030.BNTELN)                                 T_BNTELN
              ,FE_TRANS_DATA(p_i_v_eme_uid,'FAX',BKP030.BNFAX)                                           T_BNFAX
              ,FE_TRANS_DATA(p_i_v_eme_uid,'EMAIL',BKP030.BNEMAL)                                        T_BNEMAL
              ,BKP030.BNRCST                                                                             T_BNRCST
              ,BKP030.BNAUSR                                                                             T_BNAUSR
              ,BKP030.BNADAT                                                                             T_BNADAT
              ,BKP030.BNATIM                                                                             T_BNATIM
              ,BKP030.BNCUSR                                                                             T_BNCUSR
              ,BKP030.BNCDAT                                                                             T_BNCDAT
              ,BKP030.BNCTIM                                                                             T_BNCTIM
              ,BKP030.TMP_BNTELN                                                                         T_TMP_BNTELN
              ,BKP030.TMP_BNFAX                                                                          T_TMP_BNFAX
        FROM   BKP030,
               SDP050
        WHERE  BKP030.BNCSCD = SDP050.YTCUST
        AND    BKP030.BNCSTP IN ('S','C','F')
        AND    BKP030.BNBKNO = l_v_booking_no;



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
                    -- AND    BVRD.VOYAGE_SEQNO < p_i_v_voyage_seq commented by vikas
                    AND    BVRD.VOYAGE_SEQNO > p_i_v_voyage_seq -- changed by vikas as per declare discharge list sql
                 ) WHERE SR_NO = 1;

/* vikas: Start added for add party in EDI_ST_DOC_PARTY */
        CURSOR l_cur_idp030 (
            p_cyblno   IDP030.CYBLNO%TYPE,
            p_cyrctp   IDP030.CYRCTP%TYPE
        )
        IS
            SELECT *
            FROM IDP030
            WHERE CYBLNO = p_cyblno AND CYRCTP = p_cyrctp;
/* vikas: End added for add party in EDI_ST_DOC_PARTY */

    BEGIN


       p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        IF p_i_v_rob = 'on' THEN
           l_v_rob := 'Y';
        ELSE
           l_v_rob := 'N';
        END IF;
       --SET THE BAYPLAN DATE AS PER PASSED PARAMETER
       IF p_i_dt_dl_eta IS NULL THEN
          l_dt_bayplan := TO_DATE(p_i_dt_ll_etd,'DD/MM/YYYY HH24:MI');
       ELSE
          l_dt_bayplan := TO_DATE(p_i_dt_dl_eta,'DD/MM/YYYY HH24:MI');
       END IF;

       --INITIALISE THE PARAMETER STRING WITH ALL PARAMETER VALUES
       l_v_parameter_str := p_i_v_port||'~'||
                            p_i_v_service ||'~'||
                            p_i_v_vessel ||'~'||
                            p_i_v_terminal ||'~'||
                            p_i_v_voyage ||'~'||
                            p_i_v_direction ||'~'||
                            p_i_v_function_cd ||'~'||
                            p_i_v_eme_uid ||'~'||
                            NVL(p_i_dt_dl_eta,'') ||'~'||
                            NVL(p_i_dt_ll_etd,'')  ||'~'||
                            p_i_v_rob ||'~'||
                            p_i_v_ll_dl_flag;
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
            'BP'
            ,'parameters' ||'~' || l_v_parameter_str
            ,'A'
            ,'EDI'
            ,SYSDATE
            ,'EDI'
            ,SYSDATE

        );
        commit;
*/
       l_t_log_info := CURRENT_TIMESTAMP;


          SELECT MSG_REFERENCE_SEQ.NEXTVAL
          INTO   l_n_msg_ref_seq
          FROM   DUAL;

          l_n_msg_ref_seq  := LPAD(l_n_msg_ref_seq,12,'0');

          l_v_parameter_str := p_i_v_port||'~'||
            p_i_v_service ||'~'||
            p_i_v_vessel ||'~'||
            p_i_v_terminal ||'~'||
            p_i_v_voyage ||'~'||
            p_i_v_direction ||'~'||
            p_i_v_function_cd ||'~'||
            p_i_v_eme_uid ||'~'||
            NVL(p_i_dt_dl_eta,'') ||'~'||
            NVL(p_i_dt_ll_etd,'')  ||'~'||
            p_i_v_rob ||'~'||
            l_dt_bayplan;

        /* ******  added by vikas for testing ********** */
--        l_arr_var_value := STRING_ARRAY(
--            p_i_v_port , p_i_v_service  , p_i_v_vessel  ,
--            p_i_v_terminal  , p_i_v_voyage  , p_i_v_direction  ,
--            p_i_v_function_cd  , p_i_v_eme_uid  , p_i_dt_dl_eta  ,
--            p_i_dt_ll_etd   , p_i_v_rob  , l_dt_bayplan
--        );
--
--        l_arr_var_name := STRING_ARRAY(
--            'p_i_v_port' , 'p_i_v_service ' , 'p_i_v_vessel ' ,
--            'p_i_v_terminal ' , 'p_i_v_voyage ' , 'p_i_v_direction ' ,
--            'p_i_v_function_cd ' , 'p_i_v_eme_uid ' , 'p_i_dt_dl_eta ' ,
--            'p_i_dt_ll_etd  ' , 'p_i_v_rob ' , 'l_dt_bayplan'
--        );
--
--        l_arr_var_io := STRING_ARRAY(
--              'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--        );
--
--        g_v_sql_id := '123';
--        l_v_obj_nm := 'PARAMETER LIST';
--        PRE_LOG_INFO(
--            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--        );
        /* ******  END added by vikas for testing ********** */

        /* * *10 start * *
       FOR l_cur_detail IN l_cur_bayplan (l_dt_bayplan, l_v_rob) LOOP

      /* Dhruv: Changes against issue 587 *
      SELECT  EDI_ETD_SEQ.NEXTVAL
          INTO    l_v_edi_etd_uid
          FROM    DUAL;
*/
/*    change by vikas as no need to put to populate for each equipment, as k'chatgamol, , 07.11.2011
      pkg_edi_document.prc_insert_reference ( l_n_edi_etd_seq -- l_v_edi_etd_uid
                                                , 'VON'
                                                , l_cur_detail.DL_VOYAGE
                                                , 'EDI'
                                                , NULL
                                                , NULL
                                                , NULL
                                                , NULL
                                                );

        /* Dhruv: Changes Ends */

        /*    change by vikas as need previous port, as k'chatgamol, 07.11.2011 */
        /* Get previous port value *
        l_v_previous_port :=  l_cur_detail.BAPOL;

          g_v_sql_id := 'SQL-01001';
          --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_DOCUMENT_LOG
          l_v_obj_nm := 'PKG_EDI_DOCUMENT.DOCUMENT_TRACKING_TRIGGER';
          PKG_EDI_DOCUMENT.DOCUMENT_TRACKING_TRIGGER
          (l_cur_detail.DL_VOYAGE
         , l_cur_detail.DL_SERVICE
         , l_cur_detail.DL_VESSEL
         , l_cur_detail.DL_DIRECTION
         , l_cur_detail.DL_DN_EQUIPMENT_NO
         , l_cur_detail.DL_PORT_SEQ
         , NULL
         , l_cur_detail.DL_FK_BOOKING_NO
         , NULL
         , NULL
         , p_i_v_function_cd
         , l_cur_detail.LL_POL
         , l_cur_detail.DL_POD
         , NULL
         , p_i_v_eme_uid
         , l_v_module
         , l_n_msg_ref_seq
         , l_v_add_user
         , NULL
           );

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
         (l_cur_detail.DL_VOYAGE      , l_cur_detail.DL_SERVICE          , l_cur_detail.DL_VESSEL
        , l_cur_detail.DL_DIRECTION   , l_cur_detail.DL_DN_EQUIPMENT_NO  , l_cur_detail.DL_PORT_SEQ
        , NULL                        , l_cur_detail.DL_FK_BOOKING_NO    , NULL
        , NULL                        , p_i_v_function_cd                , l_cur_detail.LL_POL
        , l_cur_detail.DL_POD         , NULL                             , p_i_v_eme_uid
        , l_v_module                  , l_n_msg_ref_seq                  , l_v_add_user
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
          ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
         , l_v_obj_nm
         , g_v_sql_id
         , g_v_user
         , l_t_log_info
         , NULL
         , l_arr_var_name
         , l_arr_var_value
         , l_arr_var_io
          );


        /* vikas: changes start *
        IF l_b_first_rec THEN
            l_b_first_rec := FALSE;
            /*
            ---start processing of create voyage details

            g_v_sql_id := 'SQL-01001-a';

            --EXECUTE PROCEDURE WITH PARAMETERS TO CREATE A RECORD FOR JOURNEY
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';

            PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE
           (to_char(p_i_v_eme_uid
          , l_n_edi_etd_seq
          , p_i_v_voyage
          , p_i_v_service
          , p_i_v_vessel
          , p_i_v_direction
          , p_i_v_port
          , 20
          , NULL
          , l_n_edi_esdj_uid
            );
*/

/*PKG_EDI_TOS_OUT.PRC_CREATE_VOYAGE
       (p_i_v_eme_uid
      , l_n_edi_etd_seq
      , p_i_v_voyage
      , p_i_v_service
      , p_i_v_vessel
      , p_i_v_direction
      , p_i_v_port
      , 20
      , NULL
      , l_n_edi_esdj_uid
        );
              l_arr_var_name := STRING_ARRAY
              ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'   , 'p_i_v_voyage'
             , 'p_i_v_service'      , 'p_i_v_vessel'      , 'p_i_v_direction'
             , 'p_i_v_port'         , 'p_i_v_20'          , 'p_i_v_activity_code'
             , 'l_n_edi_esde_uid'   , 'p_i_v_terminal'
              );

              l_arr_var_value := STRING_ARRAY
              (p_i_v_eme_uid                         , l_n_edi_etd_seq              , p_i_v_voyage
             , p_i_v_service                , p_i_v_vessel        , p_i_v_direction
             , p_i_v_port      , 20                           , NULL
             , NULL                                     , p_i_v_terminal
              );

              l_arr_var_io := STRING_ARRAY
              ('I'      , 'I'      , 'I'
             , 'I'      , 'I'      , 'I'
             , 'I'      , 'I'      , 'I'
             , 'O'
              );

              PRE_LOG_INFO
              ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
             , l_v_obj_nm
             , g_v_sql_id
             , l_v_add_user
             , l_t_log_info
             , NULL
             , l_arr_var_name
             , l_arr_var_value
             , l_arr_var_io
               );
               *
        END IF;

        /* vikas: changes start *
        l_n_cnt := l_n_cnt + 1;
       END LOOP;--l_cur_detail loop end


       IF l_n_cnt = 0 THEN
          --l_v_sql_type := 'A';
          l_b_raise_exp := TRUE;
       END IF;
      /* * *10 end **/
       BEGIN
          --RETREIVE DATA FROM TABLE
          g_v_sql_id := 'SQL-01002';
          SELECT API_UID
          INTO   l_v_api_uid
          FROM   EDI_MESSAGE_EXCHANGE
          WHERE  EME_UID = p_i_v_eme_uid;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
               l_v_api_uid    := NULL;
               g_v_err_code   := TO_CHAR (SQLCODE);
               g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               --l_v_sql_type   := 'A';
--                PRE_LOG_INFO
--                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--               , l_v_obj_nm
--               , g_v_sql_id
--               , g_v_user
--               , l_t_log_info
--               , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--               , NULL
--               , NULL
--               , NULL
--                );
               --l_b_raise_exp := TRUE;
       END;

       g_v_sql_id := 'SQL-01003';
       --EXECUTE PROCEDURE
       l_v_obj_nm := 'PKG_EDI_TOS_OUT.PRC_PROCESS_BAYPLAN';
       PKG_EDI_TOS_OUT.PRC_PROCESS_BAYPLAN (l_v_api_uid);

--       l_arr_var_name := STRING_ARRAY ('p_i_v_api_uid');
--
--       l_arr_var_value := STRING_ARRAY (l_v_api_uid);
--
--       l_arr_var_io := STRING_ARRAY ('I');
--
--       PRE_LOG_INFO
--       ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--      , l_v_obj_nm
--      , g_v_sql_id
--      , g_v_user
--      , l_t_log_info
--      , NULL
--      , l_arr_var_name
--      , l_arr_var_value
--      , l_arr_var_io
--       );
        l_v_msg_ref := l_n_msg_ref_seq;
       g_v_sql_id := 'SQL-01004';
       --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_TRANSACTION_HEADER
       l_v_obj_nm := 'PKG_EDI_DOCUMENT.INSERT_TRANSACTION_HEADER_OUT';
       PKG_EDI_DOCUMENT.INSERT_TRANSACTION_HEADER_OUT (p_i_v_eme_uid, l_v_msg_ref);

--       l_arr_var_name := STRING_ARRAY ('p_i_v_eme_uid', 'l_v_msg_ref');
--
--       l_arr_var_value := STRING_ARRAY (p_i_v_eme_uid, l_v_msg_ref);
--
--       l_arr_var_io := STRING_ARRAY ('I', 'O');
--
--       PRE_LOG_INFO
--       ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--      , l_v_obj_nm
--      , g_v_sql_id
--      , g_v_user
--      , l_t_log_info
--      , NULL
--      , l_arr_var_name
--      , l_arr_var_value
--      , l_arr_var_io
--       );

       --GET UNIQUE SEQUENCE ID'S NEXT VALUE INTO VARIABLE
       SELECT EDI_ETD_SEQ.NEXTVAL
       INTO   l_n_edi_etd_seq
       FROM   DUAL;

/*    change by vikas as no need to get previous port , as k'chatgamol, 07.11.2011 */
/*

       g_v_sql_id := 'SQL-01005';
       --EXECUTE PROCEDURE WITH PARAMETERS TO RETREIVE PREVIOUS PORT
       l_v_obj_nm := 'PCE_EDL_DLMAINTENANCE.PRV_EDL_GET_PREV_PORT_VAL';

       PCE_EDL_DLMAINTENANCE.PRV_EDL_GET_PREV_PORT_VAL
       (l_v_previous_port
      , p_i_v_port
      , p_i_v_service
      , p_i_v_vessel
      , p_i_v_voyage
      , TO_CHAR(l_dt_bayplan,'YYYYMMDD')
      , TO_CHAR(l_dt_bayplan,'HH24MI')
      , g_v_err_code
       );

       l_arr_var_name := STRING_ARRAY
       ('p_o_v_hdrPrevPort'      , 'p_i_v_hdr_port'        , 'p_i_v_hdr_service'
      , 'p_i_v_hdr_Vessel'       , 'p_i_v_hdr_voyage'      , 'p_i_v_hdr_eta'
      , 'p_i_v_hdr_eta_tm'       , 'p_o_v_err_cd'
        );

        l_arr_var_value := STRING_ARRAY
       (l_v_previous_port                , p_i_v_port          , p_i_v_service
      , p_i_v_vessel                     , p_i_v_voyage        , TO_CHAR(l_dt_bayplan,'YYYYMMDD')
      , TO_CHAR(l_dt_bayplan,'HH24MI')   , g_v_err_code
        );

        l_arr_var_io := STRING_ARRAY
       ('O'      , 'I'      , 'I'
      , 'I'      , 'I'      , 'I'
      , 'I'      , 'O'
        );

       PRE_LOG_INFO
       ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
      , l_v_obj_nm
      , g_v_sql_id
      , g_v_user
      , l_t_log_info
      , NULL
      , l_arr_var_name
      , l_arr_var_value
      , l_arr_var_io
       );
*/
       g_v_sql_id := 'SQL-01006';
       --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_TRANSACTION_DETAIL
       l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DETAIL';
       PKG_EDI_DOCUMENT.PRC_CREATE_DETAIL(
              l_v_msg_ref
            , l_n_edi_etd_seq
            , p_i_v_port  -- , l_v_previous_port  Changed by vikas as per outbound suggested by chatgamol
            , NULL
            , p_i_v_voyage
            , p_i_v_vessel
        );

--       l_arr_var_name := STRING_ARRAY
--       ('l_v_msg_ref'      , 'p_i_v_eme_uid'        , 'p_i_v_voyage'
--      , 'p_i_v_vessel'     , 'p_i_v_port'    , 'p_i_v_port'
--        );
--
--        l_arr_var_value := STRING_ARRAY
--       (l_v_msg_ref        , p_i_v_eme_uid            , p_i_v_voyage
--      , p_i_v_vessel       , p_i_v_port        , p_i_v_port
--        );
--
--        l_arr_var_io := STRING_ARRAY
--       ('I'      , 'I'      , 'I'
--      , 'I'      , 'I'      , 'I'
--        );
--
--       PRE_LOG_INFO
--       ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--      , l_v_obj_nm
--      , g_v_sql_id
--      , g_v_user
--      , l_t_log_info
--      , NULL
--      , l_arr_var_name
--      , l_arr_var_value
--      , l_arr_var_io
--       );

       g_v_sql_id := 'SQL-01007';
       --INSERT RECORD INTO TABLE
       l_v_obj_nm := 'EDI_ST_DOC_HEADER';
       INSERT INTO EDI_ST_DOC_HEADER
          (EDI_ETD_UID
          ,MSG_REFERENCE
          ,DOCUMENT_ID
          ,DOCUMENT_TYPE
          ,DOCUMENT_STATUS
          ,DOCUMENT_DATE
          ,FUNCTION_CODE
          ,SERVICE_ORIGIN
          ,SERVICE_DESTINATION
          ,TARIFF_SERVICE_CODE
          ,NUMBER_COPIES
          ,NUMBER_ORIGINALS
          ,TOTAL_GROSS_WEIGHT
          ,GROSS_WEIGHT_UOM
          ,TOTAL_VOLUME
          ,VOLUME_UOM
          ,TOTAL_EQUIPMENT
          ,EQUIPMENT_TYPE
          ,TOTAL_PACKAGES
          ,PACKAGE_TYPE
          ,PAYMENT_TERMS
          ,PREPAID_TOTAL
          ,PREPAID_CCY
          ,COLLECT_TOTAL
          ,COLLECT_CCY
          ,SHIPMENT_VALUE
          ,INSURED_VALUE
          ,CUSTOMS_VALUE
          ,VALUE_CCY
          ,AGENT
          ,RECORD_STATUS
          ,RECORD_ADD_USER
          ,RECORD_ADD_DATE
          ,RECORD_CHANGE_USER
          ,RECORD_CHANGE_DATE)
       VALUES
          (l_n_edi_etd_seq
          ,l_v_msg_ref
          ,l_n_edi_etd_seq
          ,NULL
          ,NULL
          ,SYSDATE
          /* ,p_i_v_function_cd  vikas 27 July */
          ,l_v_function_cd
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,l_n_cnt
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,NULL
          ,'A'
          ,l_v_add_user
          ,SYSDATE
          ,NULL
          ,NULL);

--           PRE_LOG_INFO
--            ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , g_v_user
--           , l_t_log_info
--           , 'INSERT CALLED'
--           , NULL
--           , NULL
--           , NULL
--            );

       g_v_sql_id := 'SQL-01008';
       --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_PARTY
       l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_CARRIER';
       PKG_EDI_DOCUMENT.PRC_CREATE_CARRIER
       (l_n_edi_etd_seq
       ,NULL
       ,p_i_v_eme_uid);

--       l_arr_var_name := STRING_ARRAY
--       ('l_n_edi_etd_seq'      , 'EDI_ESDE_UID'    , 'p_i_v_eme_uid'
--        );
--
--        l_arr_var_value := STRING_ARRAY
--       (l_n_edi_etd_seq          , NULL            , p_i_v_eme_uid
--        );
--
--        l_arr_var_io := STRING_ARRAY
--       ('I'      , 'I'      , 'I'
--        );
--
--       PRE_LOG_INFO
--       ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--      , l_v_obj_nm
--      , g_v_sql_id
--      , g_v_user
--      , l_t_log_info
--      , NULL
--      , l_arr_var_name
--      , l_arr_var_value
--      , l_arr_var_io
--       );

       g_v_sql_id := 'SQL-01009';
       --EXECUTE PROCEDURE WITH PARAMETERS TO CREATE A RECORD FOR JOURNEY
       l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';
        /* vikas: changes start */
       /*
        PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE(
            TO_NUMBER(p_i_v_eme_uid)
          , l_n_edi_etd_seq
          , p_i_v_voyage
          , p_i_v_service
          , p_i_v_vessel
          , p_i_v_direction
          , p_i_v_port
          , 30        /* , 20 vikas *
          , NULL /* vikas *
          , NULL /* vikas *
          , p_i_v_terminal /* vikas *
        );
        */
      /* PKG_EDI_TOS_OUT.PRC_CREATE_VOYAGE
       (p_i_v_eme_uid
      , l_n_edi_etd_seq
      , p_i_v_voyage
      , p_i_v_service
      , p_i_v_vessel
      , p_i_v_direction
      , p_i_v_port
      , 20
      , NULL
      , l_n_edi_esdj_uid
        );

        l_arr_var_name := STRING_ARRAY
        ('p_i_v_eme_uid'           , 'l_n_edi_etd_seq'   , 'p_i_v_voyage'
        , 'p_i_v_service'          , 'p_i_v_vessel'      , 'p_i_v_direction'
        , 'p_i_v_port'             , 'p_i_v_20'          , 'p_i_v_activity_code'
        , 'l_n_edi_esde_uid'       , 'p_i_v_terminal'
        );

        l_arr_var_value := STRING_ARRAY
        (p_i_v_eme_uid                          , l_n_edi_etd_seq            , p_i_v_voyage
        , p_i_v_service                         , p_i_v_vessel               , p_i_v_direction
        , p_i_v_port                            , 20                         , NULL
        , NULL                                  , p_i_v_terminal
        );


        l_arr_var_io := STRING_ARRAY
       ('I'      , 'I'      , 'I'
      , 'I'      , 'I'      , 'I'
      , 'I'      , 'I'      , 'I'
      , 'O'
        );

       PRE_LOG_INFO
       ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
      , l_v_obj_nm
      , g_v_sql_id
      , g_v_user
      , l_t_log_info
      , NULL
      , l_arr_var_name
      , l_arr_var_value
      , l_arr_var_io
       );
        /* vikas: changes end */
       /*--GET UNIQUE SEQUENCE ID'S NEXT VALUE INTO VARIABLE
       SELECT EDI_ESDL_SEQ.NEXTVAL
       INTO   l_n_edi_esdl_uid
       FROM   DUAL;*/
       /*

       BEGIN
          g_v_sql_id := 'SQL-01110';
          --SELECT VALUES INTO VARIABLES
                   l_v_obj_nm := 'ITP040,ITP130';
                   SELECT ITP040.PICODE
                         ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_NAME',ITP040.PINAME)
                         ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_COUNTY',ITP040.PIST)
                         ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_COUNTRY',ITP040.PICNCD)
                         ,ITP130.TQTORD
                         ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_SUB_NAME',ITP130.TQTRNM)
                   INTO  l_v_picode
                       , l_v_piname
                       , l_v_pist
                       , l_v_picncd
                       , l_v_tqtord
                       , l_v_tqtrnm
                   FROM ITP040
                       ,ITP130
                   WHERE ITP040.PICODE = p_i_v_port
                   AND   ITP130.TQTERM = p_i_v_terminal;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
               g_v_err_code   := TO_CHAR (SQLCODE);
               g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               --l_v_sql_type := 'A';
                PRE_LOG_INFO
                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
               , l_v_obj_nm
               , g_v_sql_id
               , g_v_user
               , l_t_log_info
               , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
               , NULL
               , NULL
               , NULL
                );
               --l_b_raise_exp := TRUE;
               l_v_picode := NULL;
               l_v_piname := NULL;
               l_v_pist := NULL;
               l_v_picncd := NULL;
               l_v_tqtord := NULL;
               l_v_tqtrnm := NULL;
       END;
*/

       /* vikas: Comment Start
       g_v_sql_id := 'SQL-01010';
       --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
       l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
       PKG_EDI_DOCUMENT.PRC_CREATE_PORT
       (p_i_v_eme_uid
      , l_n_edi_etd_seq
      , NULL
      , NULL
      , l_v_picode
      , l_v_tqtord
      , '61'
      , l_n_edi_esdl_uid
        );


       l_arr_var_name := STRING_ARRAY
       ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
      , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
      , 'p_port_qualifer'     , 'p_edi_esdl_uid'
        );

        l_arr_var_value := STRING_ARRAY
       (p_i_v_eme_uid                , l_n_edi_etd_seq     , NULL
      , NULL                         , l_v_picode          , l_v_tqtord
      , '61'                         , l_n_edi_esdl_uid
        );

        l_arr_var_io := STRING_ARRAY
       ('I'      , 'I'      , 'I'
      , 'I'      , 'I'      , 'I'
      , 'I'      , 'O'
        );

       PRE_LOG_INFO
       ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
      , l_v_obj_nm
      , g_v_sql_id
      , g_v_user
      , l_t_log_info
      , NULL
      , l_arr_var_name
      , l_arr_var_value
      , l_arr_var_io
       );

        vikas: Comment End */
/*
       BEGIN
          g_v_sql_id := 'SQL-01011';
          --SELECT VALUES INTO VARIABLES
          l_v_obj_nm := 'ITP063';
          SELECT TO_DATE(VVARDT || LPAD(NVL(VVARTM, 1200), 4, 0), 'YYYYMMDDHH24MI'),
                 TO_DATE(VVSLDT || LPAD(NVL(VVSLTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
          INTO   l_dt_arrival,
                 l_dt_sailing
          FROM   ITP063
          WHERE  VOYAGE_ID = p_i_v_voyage
          AND    VVSRVC    = p_i_v_service
          AND    VVVESS    = p_i_v_vessel
          AND    VVPDIR    = p_i_v_direction
          AND    VVVERS    = 99
          AND    VVRCST    = 'A'
          AND    VVFORL IS NOT NULL
          AND    VVPCAL    = p_i_v_port
          AND    ROWNUM    = 1;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
               l_dt_arrival := NULL;
               l_dt_sailing := NULL;
               g_v_err_code   := TO_CHAR (SQLCODE);
               g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               --l_v_sql_type := 'A';
                PRE_LOG_INFO
                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
               , l_v_obj_nm
               , g_v_sql_id
               , g_v_user
               , l_t_log_info
               , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
               , NULL
               , NULL
               , NULL
                );
               --l_b_raise_exp := TRUE;
       END;

       IF l_dt_arrival IS NOT NULL THEN
--        Commneted by Dhruv Parekh
--          IF l_dt_arrival > SYSDATE THEN
--             l_n_arvl_code := l_cnt_arvl_code1;
--          ELSE
--             l_n_arvl_code := l_cnt_arvl_code2;
--          END IF;
          g_v_sql_id := 'SQL-01012';
         --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
         l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
         PKG_EDI_DOCUMENT.PRC_CREATE_DATE
         (l_n_edi_etd_seq
        , l_n_edi_esdl_uid
        , l_dt_arrival
        , l_cnt_arvl_code2 -- Changed by Dhruv Parekh
          );

         l_arr_var_name := STRING_ARRAY
         ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
        , 'p_date_type'
          );

          l_arr_var_value := STRING_ARRAY
         (l_n_edi_etd_seq                , l_n_edi_esdl_uid     , l_dt_arrival
        , l_n_arvl_code
          );

          l_arr_var_io := STRING_ARRAY
         ('I'      , 'I'      , 'I'
        , 'I'
          );

         PRE_LOG_INFO
         ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
        , l_v_obj_nm
        , g_v_sql_id
        , g_v_user
        , l_t_log_info
        , NULL
        , l_arr_var_name
        , l_arr_var_value
        , l_arr_var_io
         );
       END IF;

       IF l_dt_sailing IS NOT NULL THEN
--        Commneted by Dhruv Parekh
--          IF l_dt_sailing > SYSDATE THEN
--             l_n_sail_code := l_cnt_sail_code1;
--          ELSE
--             l_n_sail_code := l_cnt_sail_code2;
--          END IF;
          g_v_sql_id := 'SQL-01013';
         --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
         l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
         PKG_EDI_DOCUMENT.PRC_CREATE_DATE
         (l_n_edi_etd_seq
        , l_n_edi_esdl_uid
        , l_dt_sailing
        , l_cnt_sail_code2
          );

         l_arr_var_name := STRING_ARRAY
         ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
        , 'p_date_type'
          );

          l_arr_var_value := STRING_ARRAY
         (l_n_edi_etd_seq                , l_n_edi_esdl_uid     , l_dt_sailing
        , l_n_sail_code
          );

          l_arr_var_io := STRING_ARRAY
         ('I'      , 'I'      , 'I'
        , 'I'
          );

         PRE_LOG_INFO
         ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
        , l_v_obj_nm
        , g_v_sql_id
        , g_v_user
        , l_t_log_info
        , NULL
        , l_arr_var_name
        , l_arr_var_value
        , l_arr_var_io
         );
       END IF;
      */

/*
        Change start by vikas, as k'chatgamol say on, 07.11.2011
*/
        g_v_sql_id := 'SQL-01018a';

        --EXECUTE PROCEDURE WITH PARAMETERS TO CREATE A RECORD FOR JOURNEY

        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';

        PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE(
              p_i_v_eme_uid
            , l_n_edi_etd_seq
            , p_i_v_voyage
            , p_i_v_service
            , p_i_v_vessel
            , p_i_v_direction
            , p_i_v_port
            , 20
            , NULL
            , l_n_edi_esde_uid
            , p_i_v_terminal
            , l_n_edi_esdj_uid
        );

--        l_arr_var_name := STRING_ARRAY
--            ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'   , 'p_i_v_voyage'
--            , 'p_i_v_service'      , 'p_i_v_vessel'      , 'p_i_v_direction'
--            , 'p_i_v_port'         , 'p_i_v_20'          , 'p_discharge_terminal'
--            , 'l_n_edi_esdj_uid'
--            );
--
--        l_arr_var_value := STRING_ARRAY
--            (p_i_v_eme_uid                 , l_n_edi_etd_seq              , p_i_v_voyage
--            , p_i_v_service                , p_i_v_vessel                 , p_i_v_direction
--            , p_i_v_port                   , 20                           , p_i_v_terminal
--            , l_n_edi_esdj_uid
--            );
--
--        l_arr_var_io := STRING_ARRAY
--            ('I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'O'
--            );
--
--        PRE_LOG_INFO(
--            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--        );

        g_v_sql_id := 'SQL-01016';

        /* Get l_n_edi_esde_uid from sequence */
        SELECT EDI_ESDE_SEQ.NEXTVAL
        INTO   l_n_edi_esde_uid
        FROM   DUAL;

        BEGIN
            g_v_sql_id := 'SQL-01110';
            l_v_obj_nm := 'ITP040,ITP130';
            SELECT ITP040.PICODE
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_NAME',ITP040.PINAME)
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_COUNTY',ITP040.PIST)
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_COUNTRY',ITP040.PICNCD)
                    ,ITP130.TQTORD
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'LOCATION_SUB_NAME',ITP130.TQTRNM)
            INTO  l_v_picode
                , l_v_piname
                , l_v_pist
                , l_v_picncd
                , l_v_tqtord
                , l_v_tqtrnm
            FROM ITP040
                ,ITP130
            WHERE ITP040.PICODE = p_i_v_port
            AND   ITP130.TQTERM = p_i_v_terminal;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_err_code   := TO_CHAR (SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                --l_v_sql_type := 'A';
--                PRE_LOG_INFO
--                    ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , g_v_user
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                    , NULL
--                    , NULL
--                    , NULL
--                );
                     --l_b_raise_exp := TRUE;
                l_v_picode := NULL;
                l_v_piname := NULL;
                l_v_pist := NULL;
                l_v_picncd := NULL;
                l_v_tqtord := NULL;
                l_v_tqtrnm := NULL;
        END;
        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
        PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
            p_i_v_eme_uid
            , l_n_edi_etd_seq
            , l_n_edi_esdj_uid
            , NULL -- l_n_edi_esde_uid
            , l_v_picode
            , NULL -- l_v_tqtord AS SUGGESTED BY K'CHATGAMOL 07.11.2011
            , '61'
            , l_n_edi_esdl_uid
        );

--        l_arr_var_name := STRING_ARRAY
--        ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
--        , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
--        , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--        );
--
--        l_arr_var_value := STRING_ARRAY
--        (p_i_v_eme_uid                , l_n_edi_etd_seq     , NULL
--        , NULL                         , l_v_picode          , l_v_tqtord
--        , '61'                         , l_n_edi_esdl_uid
--        );
--
--        l_arr_var_io := STRING_ARRAY
--        ('I'      , 'I'      , 'I'
--        , 'I'      , 'I'      , 'I'
--        , 'I'      , 'O'
--        );
--
--        PRE_LOG_INFO(
--            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--        );


        BEGIN
            g_v_sql_id := 'SQL-01011';
            --SELECT VALUES INTO VARIABLES
            l_v_obj_nm := 'ITP063';
            SELECT TO_DATE(VVARDT || LPAD(NVL(VVARTM, 1200), 4, 0), 'YYYYMMDDHH24MI'),
                    TO_DATE(VVSLDT || LPAD(NVL(VVSLTM, 1200), 4, 0), 'YYYYMMDDHH24MI')
            INTO   l_dt_arrival,
                    l_dt_sailing
            FROM   ITP063
            WHERE  VOYAGE_ID = p_i_v_voyage
            AND    VVSRVC    = p_i_v_service
            AND    VVVESS    = p_i_v_vessel
            AND    VVPDIR    = p_i_v_direction
            AND    VVVERS    = 99
            AND    VVRCST    = 'A'
            AND    VVFORL IS NOT NULL
            AND    VVPCAL    = p_i_v_port
            AND    ROWNUM    = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_dt_arrival := NULL;
                l_dt_sailing := NULL;
                g_v_err_code   := TO_CHAR (SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                --l_v_sql_type := 'A';
--                    PRE_LOG_INFO
--                    ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , g_v_user
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                , NULL
--                , NULL
--                , NULL
--                    );
                                    --l_b_raise_exp := TRUE;
        END;

        IF l_dt_arrival IS NOT NULL THEN
            g_v_sql_id := 'SQL-01012';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
            PKG_EDI_DOCUMENT.PRC_CREATE_DATE(
                l_n_edi_etd_seq
                , l_n_edi_esdl_uid
                , l_dt_arrival
                , l_cnt_arvl_code2 -- Changed by Dhruv Parekh
            );

--            l_arr_var_name := STRING_ARRAY
--            ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
--            , 'p_date_type'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--            (l_n_edi_etd_seq                , l_n_edi_esdl_uid     , l_dt_arrival
--            , l_n_arvl_code
--            );
--
--            l_arr_var_io := STRING_ARRAY
--            ('I'      , 'I'      , 'I'
--            , 'I'
--            );
--
--            PRE_LOG_INFO
--            ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--            );
        END IF;

        IF l_dt_sailing IS NOT NULL THEN
            g_v_sql_id := 'SQL-01013';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_DATE
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_DATE';
            PKG_EDI_DOCUMENT.PRC_CREATE_DATE(
                l_n_edi_etd_seq
                , l_n_edi_esdl_uid
                , l_dt_sailing
                , l_cnt_sail_code2
            );

--            l_arr_var_name := STRING_ARRAY
--            ('p_edi_etd_uid'           , 'p_edi_esdl_uid'       , 'p_date'
--            , 'p_date_type'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--            (l_n_edi_etd_seq                , l_n_edi_esdl_uid     , l_dt_sailing
--            , l_n_sail_code
--            );
--
--            l_arr_var_io := STRING_ARRAY
--            ('I'      , 'I'      , 'I'
--            , 'I'
--            );
--
--            PRE_LOG_INFO(
--                'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , g_v_user
--                , l_t_log_info
--                , NULL
--                , l_arr_var_name
--                , l_arr_var_value
--                , l_arr_var_io
--            );
        END IF;

        pkg_edi_document.prc_insert_reference (
            l_n_edi_etd_seq
            , 'VON'
            , p_i_v_voyage -- l_cur_detail.DL_VOYAGE
            , 'EDI'
            , NULL
            , NULL
            , NULL
            , NULL
        );

        g_v_sql_id := 'SQL-01037a';
/* commented by as suggested by k'chatgamol
        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-9';
        PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
              p_i_v_eme_uid
            , l_n_edi_etd_seq
            , NULL
            , l_n_edi_esde_uid
            , l_v_previous_port
            , NULL
            , '9'
            , l_n_edi_esdl_uid
        );
*/
/*
    Changes end, by vikas on 07.11.2011
*/
        IS_FIRST_TIME := TRUE; --*15

       FOR L_CUR_DETAIL IN l_cur_bayplan(l_dt_bayplan, l_v_rob) LOOP
            /* *15 start */

            /* check the booking is already checked for rob or
            not if already checked then no need to check again */
            L_V_START_TIME := CURRENT_TIMESTAMP; -- *t

            IS_BOOKING_CHECKED := FALSE;
            g_v_sql_id := 'SQL-01037B';
            DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
            IF IS_FIRST_TIME = TRUE THEN

                g_v_sql_id := 'SQL-01037C';
                DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

                L_ARR_V_UNIQUE_BOOKING := STRING_ARRAY(L_CUR_DETAIL.DL_FK_BOOKING_NO);
                IS_FIRST_TIME := FALSE;
            ELSE

            FOR I IN 1 .. L_ARR_V_UNIQUE_BOOKING.COUNT LOOP
               IF (L_CUR_DETAIL.DL_FK_BOOKING_NO = L_ARR_V_UNIQUE_BOOKING(I)) THEN
                    IS_BOOKING_CHECKED := TRUE;
                    EXIT;
                END IF;
            END LOOP;
            END IF;

            DBMS_OUTPUT.PUT_LINE('IS_BOOKING_CHECKED: ' || IS_BOOKING_CHECKED);
            /* booking is not checked add the booking in
            the checked booking list */
            IF IS_BOOKING_CHECKED = FALSE THEN

                g_v_sql_id := 'SQL-01037D';
                DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

                IDX := L_ARR_V_UNIQUE_BOOKING.COUNT + 1;
                L_ARR_V_UNIQUE_BOOKING.EXTEND(1);
                L_ARR_V_UNIQUE_BOOKING(IDX) := L_CUR_DETAIL.DL_FK_BOOKING_NO;
                DBMS_OUTPUT.PUT_LINE(L_CUR_DETAIL.DL_FK_BOOKING_NO);
                IS_BOOKING_ROB := FALSE; -- *17
            END IF;

            -- IS_BOOKING_ROB           := TRUE; -- *17

            /* check booking is rob or not  */
            IF IS_BOOKING_CHECKED = FALSE THEN
                /* check the booking is rob or not */
                /* reset flag variables */
                g_v_sql_id := 'SQL-01037E';
                DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                IS_ROB                   := FALSE;
                IS_NEED_MORE_ROB_CHECK   := FALSE;
                IS_ACTVOY_NXT_VOY_SAME   := FALSE;
                IS_PORT_FOUND_IN_NXT_VOY := FALSE;
                IS_BOOKING_ROB           := FALSE;

                /* existing logic to check rob */
                BEGIN
                    SELECT
                        TRUE
                    INTO
                        IS_ROB
                    FROM
                        (SELECT BOOKING_NO
                        FROM BOOKING_VOYAGE_ROUTING_DTL
                        WHERE
                            VESSEL        =   P_I_V_VESSEL
                        AND DISCHARGE_PORT <> P_I_V_PORT
                        AND POL_PCSQ        < NVL(
                            (SELECT MIN(VVPCSQ)
                            FROM ITP063
                            WHERE VVVERS  =99
                            AND VVVESS    = VESSEL
                            AND VOYAGE_ID =
                            (SELECT VOYAGE_ID
                            FROM ITP063
                            WHERE VVVERS        =99
                            AND VVVESS          = VESSEL
                            AND VVVOYN          = VOYNO
                            AND OMMISSION_FLAG IS NULL
                            AND VVPCAL          = LOAD_PORT
                            AND ROWNUM          = 1
                            )
                            AND VVPCAL          = P_I_V_PORT
                            AND VVPCSQ          > POL_PCSQ
                            AND OMMISSION_FLAG IS NULL
                            ),0)
                        AND POD_PCSQ > NVL(
                            (SELECT MIN(VVPCSQ)
                            FROM ITP063
                            WHERE VVVERS  =99
                            AND VVVESS    = VESSEL
                            AND VOYAGE_ID =
                            (SELECT VOYAGE_ID
                            FROM ITP063
                            WHERE VVVERS        =99
                            AND VVVESS          = VESSEL
                            AND VVVOYN          = VOYNO
                            AND OMMISSION_FLAG IS NULL
                            AND VVPCAL          = LOAD_PORT
                            AND ROWNUM          = 1
                            )
                            AND VVPCAL          = P_I_V_PORT
                            AND VVPCSQ          > POL_PCSQ
                            AND OMMISSION_FLAG IS NULL
                            ),0)

                        UNION
                        SELECT BOOKING_NO
                        FROM BOOKING_VOYAGE_ROUTING_DTL
                        WHERE VESSEL  = P_I_V_VESSEL
                        AND LOAD_PORT = P_I_V_PORT
                        UNION
                        SELECT BOOKING_NO
                        FROM BOOKING_VOYAGE_ROUTING_DTL
                        WHERE VESSEL       = P_I_V_VESSEL
                        AND DISCHARGE_PORT = P_I_V_PORT
                    )
                    WHERE
                    BOOKING_NO = L_CUR_DETAIL.DL_FK_BOOKING_NO ;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        IS_ROB := FALSE;

                    WHEN OTHERS THEN
                        IS_ROB := FALSE;
                        DBMS_OUTPUT.PUT_LINE('ERROR 1: '||SQLERRM);
                END;

                g_v_sql_id := 'SQL-01037F';
                DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

                /* check only when existing validation fail */

                IF IS_ROB = TRUE THEN
                  IS_BOOKING_ROB := TRUE;
                ELSE

                    /* check pod pcsq and actual port seq is same or not  */
                    g_v_sql_id := 'SQL-01037G';
                    DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                    BEGIN
                        SELECT
                            TRUE,
                            VOYNO,
                            ACT_VOYAGE_NUMBER,
                            VESSEL,
                            LOAD_PORT,
                            POL_PCSQ
                        INTO
                            IS_NEED_MORE_ROB_CHECK,
                            L_V_VOYAGE,
                            L_V_ACT_VOYAGE_NUMBER,
                            L_V_VESSEL,
                            L_V_LOAD_PORT,
                            L_V_POL_PCSQ
                        FROM
                            BOOKING_VOYAGE_ROUTING_DTL
                        WHERE
                            BOOKING_NO = L_CUR_DETAIL.DL_FK_BOOKING_NO
                            AND VESSEL = P_I_V_VESSEL
                            -- AND POD_PCSQ = ACT_PORT_SEQUENCE -- *17
                            AND VOYNO <> ACT_VOYAGE_NUMBER;

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                        WHEN OTHERS THEN
                            DBMS_OUTPUT.PUT_LINE('ERROR 2: '||SQLERRM);
                    END;

                    g_v_sql_id := 'SQL-01037H';
                    DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                    DBMS_OUTPUT.PUT_LINE('IS_NEED_MORE_ROB_CHECK: '|| IS_NEED_MORE_ROB_CHECK);
                    /* check new validation for rob */
                    IF IS_NEED_MORE_ROB_CHECK = TRUE THEN

                        /* Find last port (max port seq) of that voyage
                        which is not ommited and VVFORL is not null. */

                        g_v_sql_id := 'SQL-01037I';
                        DBMS_OUTPUT.PUT_LINE(g_v_sql_id);
                        DBMS_OUTPUT.PUT_LINE(L_V_VESSEl||'~'||
                            L_V_VOYAGE||'~'||
                            L_V_LOAD_PORT||'~'||
                            L_V_POL_PCSQ);

                        /* for first time the last port should be load port */
                        L_V_LAST_PORT := L_V_LOAD_PORT;
                        L_V_MAX_PORT_SEQ := L_V_POL_PCSQ;

                        g_v_sql_id := 'SQL-01037J';
                        DBMS_OUTPUT.PUT_LINE(g_v_sql_id);

                        LOOP
                            /* start loop to find next voyage for the booking */
                            BEGIN
                                /* find the max port sequence */
                                BEGIN
                                    SELECT
                                        MAX(VVPCSQ)
                                    INTO
                                        L_V_MAX_PORT_SEQ
                                    FROM
                                        ITP063
                                    WHERE
                                        VVVERS  = 99
                                        AND VVVESS    = L_V_VESSEl
                                        AND VOYAGE_ID = L_V_VOYAGE
                                        /* AND VVPCAL    = L_V_LOAD_PORT */
                                        AND VVPCAL    = L_V_LAST_PORT /* first time load port */
                                        /* AND VVPCSQ    >= L_V_POL_PCSQ */
                                        AND VVPCSQ    >= L_V_MAX_PORT_SEQ /* first time load port seq */
                                        AND OMMISSION_FLAG IS NULL
                                        AND VVFORL IS NOT NULL;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        L_V_ERROR := 'MAX PORT SEQ NOT FOUND';
                                        RAISE NEXT_VOYAGE_NOT_FOUND;
                                    WHEN OTHERS THEN
                                        L_V_ERROR := SQLERRM;
                                        DBMS_OUTPUT.PUT_LINE('ERROR 2: '||SQLERRM);
                                        RAISE ORACLE_EXCEPTION;
                                END;

                                /* find the last port using max port sequence */
                                BEGIN
                                    SELECT
                                        VVARDT ETA,
                                        VVDPDT ETD,
                                        VVARTM,
                                        VVDPTM,
                                        VVPCAL
                                    INTO
                                        L_V_ITP_ETA,
                                        L_V_ITP_ETD,
                                        L_V_ITP_ETA_TIME,
                                        L_V_ITP_ETD_TIME,
                                        L_V_LAST_PORT
                                    FROM
                                        ITP063
                                    WHERE
                                        VVVERS  = 99
                                        AND VVVESS    = L_V_VESSEl
                                        AND VOYAGE_ID = L_V_VOYAGE
                                        /* AND VVPCAL    = L_V_LOAD_PORT */
                                        /* AND VVPCAL    = L_V_LAST_PORT */ /* first time load port */
                                        AND VVPCSQ    = L_V_MAX_PORT_SEQ
                                        AND OMMISSION_FLAG IS NULL
                                        AND VVFORL IS NOT NULL;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        L_V_ERROR := 'LAST PORT NOT FOUND';
                                        RAISE NEXT_VOYAGE_NOT_FOUND;
                                    WHEN OTHERS THEN
                                        L_V_ERROR := SQLERRM;
                                        DBMS_OUTPUT.PUT_LINE('ERROR 3: '||SQLERRM);
                                        RAISE ORACLE_EXCEPTION;

                                END;

                                /* find the next voyage using the last port */
                                BEGIN
                                    DBMS_OUTPUT.PUT_LINE(L_V_VESSEL ||'~'||
                                        L_V_LAST_PORT ||'~'||
                                        l_dt_bayplan ||'~'||
                                        L_V_ITP_ETA || LPAD(L_V_ITP_ETA_TIME ,4, '0') ||'~'||
                                        L_V_ITP_ETD || LPAD(L_V_ITP_ETD_TIME ,4, '0')
                                        );

                                    /* this sql gives first port of the voyage */
                                    SELECT
                                        VOYAGE_ID,
                                        VVARDT ETA,
                                        VVDPDT ETD,
                                        VVARTM,
                                        VVDPTM,
                                        VVPCAL,
                                        VVPCSQ
                                    INTO
                                        L_V_VOYAGE,
                                        L_V_ITP_ETA,
                                        L_V_ITP_ETD,
                                        L_V_ITP_ETA_TIME,
                                        L_V_ITP_ETD_TIME,
                                        L_V_PORT,
                                        L_V_PORT_SEQ
                                    FROM
                                    (
                                        SELECT
                                            ROW_NUMBER() OVER(ORDER BY TO_DATE(VVARDT||LPAD(VVARTM,4,'0'), 'YYYYMMDDHH24MI') ) R,
                                            VOYAGE_ID,
                                            VVARDT,
                                            VVDPDT,
                                            VVARTM,
                                            VVDPTM,
                                            VVPCAL,
                                            VVPCSQ
                                        FROM
                                            ITP063
                                        WHERE
                                            VVVERS  = 99
                                            AND VVVESS    = L_V_VESSEl
                                            AND (TO_DATE(VVDPDT||LPAD(VVDPTM, 4,'0'), 'YYYYMMDDHH24MI')
                                                >
                                                TO_DATE(L_V_ITP_ETD||LPAD(L_V_ITP_ETD_TIME, 4,'0'), 'YYYYMMDDHH24MI'))
                                                  -- 20130217
                                            AND OMMISSION_FLAG IS NULL
                                            AND VVFORL IS NOT NULL
                                            )
                                        WHERE R =1 ;

                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        L_V_ERROR := 'NEXT VOYAGE NOT FOUND';
                                        RAISE NEXT_VOYAGE_NOT_FOUND;
                                    WHEN OTHERS THEN
                                        L_V_ERROR := SQLERRM;
                                        DBMS_OUTPUT.PUT_LINE('ERROR 5: '||SQLERRM);
                                        RAISE ORACLE_EXCEPTION;

                                END;

                                /* check the next voyage and actual voyage of the booking
                                is same or not */

                                IF L_V_ACT_VOYAGE_NUMBER = L_V_VOYAGE THEN
                                    IS_ACTVOY_NXT_VOY_SAME := TRUE;
                                ELSE
                                    IS_ACTVOY_NXT_VOY_SAME := FALSE;
                                END IF;

                                IS_PORT_FOUND_IN_NXT_VOY := FALSE;
                                /* check port available in next voyage or not */
                                BEGIN
                                    SELECT
                                        TRUE
                                    INTO
                                        IS_PORT_FOUND_IN_NXT_VOY
                                    FROM
                                        ITP063
                                    WHERE
                                        VVVERS  = 99
                                        AND VVVESS    = L_V_VESSEl
                                        AND (TO_DATE(VVDPDT||LPAD(VVDPTM, 4,'0'), 'YYYYMMDDHH24MI')
                                            >
                                            TO_DATE(L_V_ITP_ETD||LPAD(L_V_ITP_ETD_TIME, 4,'0'), 'YYYYMMDDHH24MI'))
                                        AND OMMISSION_FLAG IS NULL
                                        AND VVFORL IS NOT NULL
                                        AND VVPCAL = P_I_V_PORT;
                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        NULL;

                                    WHEN TOO_MANY_ROWS THEN
                                        IS_PORT_FOUND_IN_NXT_VOY := TRUE;

                                    WHEN OTHERS THEN
                                        DBMS_OUTPUT.PUT_LINE('ERROR 6: '||SQLERRM);
                                        RAISE ORACLE_EXCEPTION;
                                END;

                                /* check if port found in next voyage
                                then generate bayplan for that
                                booking and exit the inner loop */
                                IS_BOOKING_ROB := FALSE;
                                IF IS_PORT_FOUND_IN_NXT_VOY = TRUE THEN
                                    IS_BOOKING_ROB := TRUE;
                                    EXIT;
                                END IF;
                            EXCEPTION
                                WHEN NEXT_VOYAGE_NOT_FOUND THEN
                                    DBMS_OUTPUT.PUT_LINE(L_V_ERROR);
                                    EXIT;

                                WHEN ORACLE_EXCEPTION THEN
                                    /* DBMS_OUTPUT.PUT_LINE(L_V_ERROR); */
                                    NULL;

                                WHEN OTHERS THEN
                                    DBMS_OUTPUT.PUT_LINE('ERROR 7: '||SQLERRM);
                            END;

                            /* when actual voyage and last port voyage is same
                            means it is the last voyage so no need to find
                            the next voyage */
                            IF IS_ACTVOY_NXT_VOY_SAME = TRUE THEN
                                EXIT; /* exit from inner loop */
                            END IF;

                        END LOOP; /* INNER LOOP */

                    END IF;
                END IF;
            END IF;
            /* *15 end */
              DBMS_OUTPUT.PUT_LINE('IS_ROB: '|| IS_ROB);
              DBMS_OUTPUT.PUT_LINE('IS_BOOKING_ROB: '|| IS_BOOKING_ROB);

            IF IS_BOOKING_ROB = TRUE THEN --*15
                /* populate booking for bayplan */

            --GET UNIQUE SEQUENCE ID'S NEXT VALUE INTO VARIABLE
            /* *10 start * */

            /* * populate data in edi_st_document_log * */
            g_v_sql_id := 'SQL-01037k';
            /* * EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_DOCUMENT_LOG * */

            l_v_obj_nm := 'PKG_EDI_DOCUMENT.DOCUMENT_TRACKING_TRIGGER';
            PKG_EDI_DOCUMENT.DOCUMENT_TRACKING_TRIGGER(
                l_cur_detail.DL_VOYAGE
                , l_cur_detail.DL_SERVICE
                , l_cur_detail.DL_VESSEL
                , l_cur_detail.DL_DIRECTION
                , l_cur_detail.DL_DN_EQUIPMENT_NO
                , l_cur_detail.DL_PORT_SEQ
                , NULL
                , l_cur_detail.DL_FK_BOOKING_NO
                , NULL
                , NULL
                , p_i_v_function_cd
                , l_cur_detail.LL_POL
                , l_cur_detail.DL_POD
                , NULL
                , p_i_v_eme_uid
                , l_v_module
                , l_n_msg_ref_seq
                , l_v_add_user
                , NULL
            );


            /* update number of container count */
            l_n_cnt := l_n_cnt + 1;

            /* *10 end * */

        SELECT EDI_ESDE_SEQ.NEXTVAL
        INTO   l_n_edi_esde_uid
        FROM   DUAL;

        --IF ANY OF THE FIELD IS FILLED THEN 'Y' ELSE 'N'
          IF   l_cur_detail.DL_FLASH_POINT IS NOT NULL
            OR l_cur_detail.DL_FLASH_UNIT  IS NOT NULL
            OR l_cur_detail.DL_FK_IMDG     IS NOT NULL
            OR l_cur_detail.DL_FK_UNNO     IS NOT NULL
          THEN
             l_v_hazardous := 'Y';
          ELSE
             l_v_hazardous := 'N';
          END IF;
/* ***************************** Added by Vikas Verma *****************************/
/* vikas: start for testing */
          /*PRE_LOG_INFO
            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
            , 'test'
            , '1'
            , 'vikas'
            , l_t_log_info
            , 'blank'
            , NULL
            , NULL
            , NULL
            );*/

/* vikas: end for testing */
        -- Shipment Type
        IF    l_cur_detail.DL_DN_SHIPMENT_TYP = 'FCL'
           OR l_cur_detail.DL_DN_SHIPMENT_TYP = 'LCL'
        THEN
           l_v_shipment_type := 'CN';
           l_v_full_mt       := l_cur_detail.LL_DN_FULL_MT;
        ELSIF l_cur_detail.DL_DN_SHIPMENT_TYP = 'BBK'
        THEN
           l_v_shipment_type := 'BB';
           l_v_full_mt := 'UC';
        ELSIF l_cur_detail.DL_DN_SHIPMENT_TYP = 'UC'
        THEN
           l_v_shipment_type := 'BB';
           l_v_full_mt := 'UC';
        ELSE
           l_v_shipment_type := 'CN';
           l_v_full_mt := l_cur_detail.LL_DN_FULL_MT;
        END IF;

/* vikas: start for testing */
       /* PRE_LOG_INFO
            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
            , 'test'
            , '2'
            , 'vikas'
            , l_t_log_info
            , l_cnt_weight_uom ||'~'||l_cnt_weight_uom_t
            , NULL
            , NULL
            , NULL
            );*/
/* vikas: end for testing */
         -- Set standard values
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
/* vikas: start for testing *
            PRE_LOG_INFO
            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
            , 'test'
            , '3'
            , 'vikas'
            , l_t_log_info
            , l_cnt_weight_uom ||'~'||l_cnt_weight_uom_t
            , NULL
            , NULL
            , NULL
            );
/* vikas: end for testing */
        IF l_cnt_weight_uom IS NOT NULL
        THEN
           pkg_edi_transaction.pro_data_translation_out
                                                     (p_i_v_eme_uid,
                                                      'GROSS_WEIGHT_UOM',
                                                      l_cnt_weight_uom,
                                                      l_cnt_weight_uom_t
                                                     );
        ELSE
           l_cnt_weight_uom_t := 'KGM';
        END IF;
/* vikas: start for testing *
        PRE_LOG_INFO
            ('PCE_ECM_DECLARE_LIST.PRE_ECM_GENERATE_EDI'
            , 'test'
            , '4'
            , 'vikas'
            , l_t_log_info
            , l_cnt_weight_uom ||'~'||l_cnt_weight_uom_t
            , NULL
            , NULL
            , NULL
            );
/* vikas: end for testing */
        IF l_cnt_volume_uom IS NOT NULL
        THEN
           pkg_edi_transaction.pro_data_translation_out (p_i_v_eme_uid,
                                                         'VOLUME_UOM',
                                                         l_cnt_volume_uom,
                                                         l_cnt_volume_uom_t
                                                        );
        ELSE
           l_cnt_volume_uom_t := 'MTQ';
        END IF;


        pkg_edi_transaction.pro_data_translation_out (p_i_v_eme_uid,
                                                      'LENGTH_UOM',
                                                      'CMT',
                                                      l_cnt_length_uom
                                                     );
        --Get Temperature UOM
        IF l_cur_detail.DL_REEFER_TMP_UNIT = 'F'
        THEN
           l_v_temperature_uom := 'FAH';
        ELSE
           l_v_temperature_uom := 'CEL';
        END IF;


        IF l_v_temperature_uom IS NOT NULL
        THEN
           pkg_edi_transaction.pro_data_translation_out
                                                      (p_i_v_eme_uid,
                                                       'DL_REEFER_TMP_UNIT',
                                                       l_v_temperature_uom,
                                                       l_v_temperature_uom_t
                                                      );
        END IF;


        /* vikas: temporary commented as SHIPMENT_TERM is not comming from view v_tos_onboad_list

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
            WHERE MMMODE   =  l_cur_detail.SHIPMENT_TERM
            AND ROWNUM     =  1;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN

                ('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                PRE_LOG_INFO
                 ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
                , l_v_obj_nm
                , g_v_sql_id
                , g_v_user
                , l_t_log_info
                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
                , NULL
                , NULL
                , NULL
                 );
                l_v_movement_from   := NULL;
                l_v_movement_to     := NULL;
        END;
        vikas: comment end ********************** */


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
            SELECT ORIGIN_HAULAGE
            INTO
                  l_v_haulage_arrang
            FROM  BKP001
            WHERE BABKNO   =  l_cur_detail.DL_FK_BOOKING_NO;

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
--                 ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , g_v_user
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
            WHERE BIBKNO   =  l_cur_detail.DL_FK_BOOKING_NO
            AND   BISEQN   =  l_cur_detail.LL_CONTAINER_SEQ_NO;


        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
               -- p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
--                PRE_LOG_INFO
--                 ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , g_v_user
--                , l_t_log_info
--                , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                , NULL
--                , NULL
--                , NULL
--                 );
                l_v_nature_of_cargo   := NULL;
        END;



/* ***************************** END Added by Vikas Verma *****************************/

       BEGIN
          g_v_sql_id := 'SQL-1011a';
          --SELECT VALUES INTO VARIABLES
            l_v_obj_nm := 'IDP055,IDP002,IDP010';
            SELECT    FE_TRANS_DATA(p_i_v_eme_uid,'SEAL_NUMBER_SH',IDP055.EYSSEL)
                    , FE_TRANS_DATA(p_i_v_eme_uid,'SEAL_NUMBER_CA',IDP055.EYCRSL)
                    , FE_TRANS_DATA(p_i_v_eme_uid,'SEAL_NUMBER_CU',IDP055.EYCSEL)
                    , FE_TRANS_DATA(p_i_v_eme_uid,'AIR_PRESSURE',IDP055.AIR_PRESSURE)
                    , FE_TRANS_DATA(p_i_v_eme_uid,'PIECE_COUNT',IDP055.EYPCKG)
                    , FE_TRANS_DATA(p_i_v_eme_uid,'PACKAGE_TYPE',IDP055.EYKIND)
                    /* VIKAS
                    , FE_TRANS_DATA(p_i_v_eme_uid,'MOVEMENT_TYPE',IDP055.EYDANG)
                    , FE_TRANS_DATA(p_i_v_eme_uid,'HAULAGE_ARRANGEMENT',DECODE(IDP055.EYPCKG,1,1,2,2))
                    , FE_TRANS_DATA(p_i_v_eme_uid,'NATURE_OF_CARGO',IDP055.EYKIND)
                    */
            INTO
                      l_v_sl_no_sh
                    , l_v_sl_no_ca
                    , l_v_sl_no_cu
                    , l_v_air_pressure
                    , l_v_piece_count
                    , l_v_package_type
                    /* VIKAS
                    , l_v_movement_type
                    , l_v_haulage_arrang
                    , l_v_nature_of_cargo
                    */
            FROM  IDP055 IDP055
                , IDP002 IDP002
                , IDP010 IDP010
            WHERE IDP055.EYBLNO      = IDP002.TYBLNO
            AND   IDP055.EYBLNO      = IDP010.AYBLNO
            AND   IDP002.TYBLNO      = IDP010.AYBLNO
            AND   IDP010.AYSTAT     >= 1
            AND   IDP010.AYSTAT     <= 6
            AND   IDP010.PART_OF_BL IS NULL
            AND   IDP002.TYBKNO      = l_cur_detail.DL_FK_BOOKING_NO
            AND   IDP055.EYEQNO      = l_cur_detail.DL_DN_EQUIPMENT_NO
            AND   ROWNUM             = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_err_code   := TO_CHAR (SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                --l_v_sql_type := 'A';
--                    PRE_LOG_INFO(
--                        'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , g_v_user
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                    , NULL
--                    , NULL
--                    , NULL
--                    );
                        l_v_sl_no_sh := NULL;
                    l_v_sl_no_ca := NULL;
                    l_v_sl_no_cu := NULL;
                    l_v_air_pressure := NULL;
                    l_v_piece_count := NULL;
                    l_v_package_type := NULL;
                    l_v_movement_type := NULL;
                    l_v_haulage_arrang := NULL;
                    l_dt_arrival := NULL;
        END;

        g_v_sql_id := 'SQL-01114';
        l_v_obj_nm := 'ITP076';
        BEGIN
            SELECT    FE_TRANS_DATA(p_i_v_eme_uid,'EQUIPMENT_SIZE_TYPE',ITP076.ISSIZE
                    ||ITP076.ISTYPE)
                    , FE_TRANS_DATA(p_i_v_eme_uid,'TYPE_DESCRIPTION',ITP076.ISDESC)
            INTO
                      l_v_sizetype
                    , l_v_type_desc
            FROM  ITP076 ITP076
            WHERE ITP076.ISSIZE = l_cur_detail.DL_DN_EQ_SIZE
            AND   ITP076.ISTYPE = l_cur_detail.DL_DN_EQ_TYPE
            AND   ROWNUM        = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
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
            'BP'
            ,'NO_DATA_FOUND' ||'~' || l_cur_detail.DL_DN_EQ_SIZE ||'~' || l_cur_detail.DL_DN_EQ_TYPE
            ,'A'
            ,'EDI'
            ,SYSDATE
            ,'EDI'
            ,SYSDATE

        );
         commit;
         */

            RAISE NO_DATA_FOUND;

        END;


        g_v_sql_id := 'SQL-01014';
        -- Step 16 : Populate data for EDI_ST_DOC_EQUIPMENT
        --INSERT RECORD INTO TABLE
        l_v_obj_nm := 'EDI_ST_DOC_EQUIPMENT';
        INSERT INTO EDI_ST_DOC_EQUIPMENT
            (EDI_ESDE_UID
            ,EDI_ETD_UID
            ,EQUIPMENT_TYPE
            ,EQUIPMENT_NO
            ,EQUIPMENT_SIZE_TYPE
            ,TYPE_DESCRIPTION
            ,EQUIPMENT_SUPPLIER
            ,EQUIPMENT_STATUS
            ,EQUIPMENT_FULL_EMPTY
            ,GROSS_WEIGHT
            ,GROSS_WEIGHT_UOM
            ,VOLUME
            ,VOLUME_UOM
            ,LENGTH_UOM
            ,OVERLENGTH_FRONT
            ,OVERLENGTH_BACK
            ,OVERWIDTH_RIGHT
            ,OVERWIDTH_LEFT
            ,OVERHEIGHT
            ,TEMPERATURE
            ,TEMPERATURE_MIN
            ,TEMPERATURE_MAX
            ,TEMPERATURE_UOM
            ,SEAL_NUMBER_SH
            ,SEAL_NUMBER_TO
            ,SEAL_NUMBER_CA
            ,SEAL_NUMBER_CU
            ,VENT_SETTING
            ,HUMIDITY
            ,AIR_EXCHANGE
            ,HAZARDOUS
            ,PIECE_COUNT
            ,PACKAGE_TYPE
            ,RECORD_STATUS
            ,RECORD_ADD_USER
            ,RECORD_ADD_DATE
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE
            ,MOVEMENT_TYPE
            ,HAULAGE_ARRANGEMENT
            ,NATURE_OF_CARGO)
        VALUES(
             l_n_edi_esde_uid
            ,l_n_edi_etd_seq
            ,l_v_shipment_type
            --,l_cur_detail.T_DL_DN_SHIPMENT_TYP /* vikas */
            ,l_cur_detail.T_DL_DN_EQUIPMENT_NO
            ,l_v_sizetype
            ,l_v_type_desc
            ,l_cur_detail.T_DL_DN_SOC_COC
            ,DECODE(p_i_v_port
                   ,l_cur_detail.DL_DN_FINAL_POD,'3'
                   ,l_cur_detail.DL_DN_NXT_POD1,'6'
                   ,l_cur_detail.DL_DN_NXT_POD2,'6'
                   ,l_cur_detail.DL_DN_NXT_POD3,'6'
                   ,'4')
            ,DECODE(l_cur_detail.DL_LOAD_CONDITION,'F','F','E')
            ,l_cur_detail.T_DL_CONTAINER_GROSS_WEIGHT
            --,l_cnt_weight_uom /* vikas */
            ,l_cnt_weight_uom_t
            ,NULL
            ,NULL
            ,l_cnt_length_uom
            ,l_cur_detail.T_DL_OVERLENGTH_FRONT_CM
            ,l_cur_detail.T_DL_OVERLENGTH_REAR_CM
            ,l_cur_detail.T_DL_OVERWIDTH_RIGHT_CM
            ,l_cur_detail.T_DL_OVERWIDTH_LEFT_CM
            ,l_cur_detail.T_DL_OVERHEIGHT_CM
            ,l_cur_detail.T_DL_REEFER_TEMPERATURE
            ,l_cur_detail.T_DL_REEFER_TEMPERATURE
            ,l_cur_detail.T_DL_REEFER_TEMPERATURE
            -- ,l_cur_detail.T_DL_REEFER_TMP_UNIT /*vikas*/
            ,l_v_temperature_uom
            ,SUBSTR(l_v_sl_no_sh,1,17)
            ,NULL
            ,SUBSTR(l_v_sl_no_ca,1,17)
            ,SUBSTR(l_v_sl_no_cu,1,17)
            ,NULL
            ,l_cur_detail.T_DL_DN_HUMIDITY
            ,l_v_air_pressure
            ,l_v_hazardous
            ,l_v_piece_count
            ,SUBSTR(l_v_package_type,1,4)
            ,'A'
            ,l_v_add_user
            ,SYSDATE
            ,NULL
            ,NULL
            ,l_v_movement_type
            ,l_v_haulage_arrang
            ,l_v_nature_of_cargo
           );

--           PRE_LOG_INFO
--            ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--           , l_v_obj_nm
--           , g_v_sql_id
--           , g_v_user
--           , l_t_log_info
--           , 'INSERT CALLED'
--           , NULL
--           , NULL
--           , NULL
--            );

        /*
            Start added by chatgamol, to populate bundled, 15.12.2011

            Get public remark from discharge table
        */

        SELECT
            PUBLIC_REMARK
        INTO
            l_v_public_remark
        FROM
            VASAPPS.TOS_DL_DISCHARGE_LIST DL
            , VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
        WHERE
            BD.FK_DISCHARGE_LIST_ID = DL.PK_DISCHARGE_LIST_ID
            AND BD.FK_BOOKING_NO = l_cur_detail.DL_FK_BOOKING_NO
            AND BD.DN_EQUIPMENT_NO = l_cur_detail.DL_DN_EQUIPMENT_NO
            AND DL.DN_PORT = l_cur_detail.LL_DN_DISCHARGE_PORT
            AND DL.DN_TERMINAL = l_cur_detail.LL_DN_DISCHARGE_TERMINAL
            and BD.RECORD_STATUS = 'A';  -- ADDED 28.03.2012

        IF (l_cur_detail.DL_LOAD_CONDITION = 'B') and (l_v_public_remark is not null) THEN
            g_v_sql_id := '45B';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                l_n_edi_etd_seq
                , NULL
                , NULL -- l_n_edi_esdco_seq
                , 'HAN'
                , NULL
                , 'BD'
                , l_v_add_user
                , l_n_edi_esde_uid
            );

          /* Modified by Dhruv Parekh on 09/11/2011
           * To convert comma sepearated PUBLIC_REMARK into array
           * BLOCK START
           */

            g_v_sql_id := '45c';
            v_string   := l_v_public_remark; -- need to get from dl table.
            v_delimpos := INSTR(l_v_public_remark, p_delim);
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
                PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE(
                    l_n_edi_etd_seq
                    , 'BD'
                    , v_table(i)
                    , 'EDI'
                    , l_n_edi_esde_uid
                    , NULL
                    , NULL
                    , NULL
                );
            END LOOP;
            /* BLOCK END*/
        END IF;

        /*
            End added by chatgamol, 15.12.2011
        */

        /*
            Start added by Vikas, As requested by K' nim, on 28.12.2011
        */
        IF (l_cur_detail.DL_DN_VENTILATION <> 0) THEN
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                l_n_edi_etd_seq
                , NULL
                , NULL -- l_n_edi_esdco_seq
                , 'OSI'
                , l_cur_detail.DL_DN_VENTILATION || NVL(SUBSTR(l_v_public_remark, 1, 3), 'M')
                , NULL
                , l_v_add_user
                , l_n_edi_esde_uid
            );
        END IF;
        /*
            End added by Vikas, 28.12.2011
        */

        /* Start added by vikas, 14.12.2011 */
        PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
            l_n_edi_etd_seq
            , NULL
            , NULL -- l_n_edi_esdco_seq
            , 'CON'
            , l_cur_detail.DL_LOCAL_TERMINAL_STATUS
            , NULL
            , l_v_add_user
            , l_n_edi_esde_uid
        );
        /* End added by vikas, 14.12.2011 */

        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-9';
        PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
              p_i_v_eme_uid
            , l_n_edi_etd_seq
            , NULL
            , l_n_edi_esde_uid
            , l_cur_detail.LL_POL  --l_v_previous_port
            , l_cur_detail.DL_DN_POL_TERMINAL  -- NULL
            , '9'
            , l_n_edi_esdl_uid
        );

        /* Start added by vikas, as per requested by k'chatgamol, 09.11.2011 */

        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
        PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
            p_i_v_eme_uid
            , l_n_edi_etd_seq
            , null -- l_n_edi_esdj_uid
            , l_n_edi_esde_uid
            , l_v_picode
            , NULL -- l_v_tqtord AS SUGGESTED BY K'CHATGAMOL 07.11.2011
            , '61'
            , l_n_edi_esdl_uid
        );

--        l_arr_var_name := STRING_ARRAY
--        ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
--        , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
--        , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--        );
--
--        l_arr_var_value := STRING_ARRAY
--        (p_i_v_eme_uid                , l_n_edi_etd_seq     , NULL
--        , NULL                         , l_v_picode          , l_v_tqtord
--        , '61'                         , l_n_edi_esdl_uid
--        );
--
--        l_arr_var_io := STRING_ARRAY
--        ('I'      , 'I'      , 'I'
--        , 'I'      , 'I'      , 'I'
--        , 'I'      , 'O'
--        );
--
--        PRE_LOG_INFO(
--            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--        );

        /* End added by vikas, as per requested by k'chatgamol, 09.11.2011 */

      /* vikas: Start Populate data for EDI_ST_DOC_LOCATION for Stowage Position */
      -- Populate data for EDI_ST_DOC_LOCATION (Stowage Position)
        BEGIN
            g_v_sql_id := 'SQL-01014a';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';

            -- IF l_cur_detail.DL_STOWAGE_POSITION IS NOT NULL THEN -- *3
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT
                  (p_i_v_eme_uid
                 , l_n_edi_etd_seq
                 , NULL
                 , l_n_edi_esde_uid
                 , NVL(l_cur_detail.DL_STOWAGE_POSITION, L_V_SPACE)
                 , NULL
                 , '147'
                 , l_n_edi_esdl_uid
                  );
            -- END IF;    -- *3

--            l_arr_var_name := STRING_ARRAY
--                ('p_i_v_eme_uid'       , 'l_n_edi_etd_seq'     , 'p_edi_esdj_uid'
--                , 'l_n_edi_esde_uid'    , 'p_stowage_position'  , 'p_terminal'
--                , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--                );
--
--            l_arr_var_value := STRING_ARRAY
--                (p_i_v_eme_uid                , l_n_edi_etd_seq                           , NULL
--                , NULL                        , l_cur_detail.DL_STOWAGE_POSITION          , NULL
--                , '147'                       , l_n_edi_esdl_uid
--                );
--
--            l_arr_var_io := STRING_ARRAY
--                ('I'      , 'I'      , 'I'
--                , 'I'      , 'I'      , 'I'
--                , 'I'      , 'O'
--                );
--
--        PRE_LOG_INFO(
--            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--        );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;
--                PRE_LOG_INFO(
--                    'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , g_v_user
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                    , NULL
--                    , NULL
--                    , NULL
--                );
        END;
/* vikas: End Populate data for EDI_ST_DOC_LOCATION for Stowage Position */


          g_v_sql_id := 'SQL-01015';
          --ASSIGN VALUE FOR STOWAGE POSITION

        /* *16 start *

          IF l_cur_detail.DL_STOWAGE_POSITION  = l_cur_detail.LL_STOWAGE_POSITION THEN
             l_v_restow_pos := l_cur_detail.DL_STOWAGE_POSITION;
          ELSE
             BEGIN
                IF p_i_dt_ll_etd IS NULL THEN
                    --WHEN CALLED FROM DISCHARGE LIST
                    l_v_obj_nm := 'STOWAGE_POSITION';
                    SELECT STOWAGE_POSITION
                    INTO   l_v_restow_pos
                    FROM
                       (SELECT ROW_NUMBER() OVER (ORDER BY ACTIVITY_DATE_TIME DESC) SRNO
                             , STOWAGE_POSITION
                        FROM
                           (SELECT TS.STOWAGE_POSITION
                                 , TS.ACTIVITY_DATE_TIME ACTIVITY_DATE_TIME
                            FROM   TOS_RESTOW TS,
                                   ITP040 P
                            WHERE  l_cur_detail.LL_LL_RECORD_STATUS = 'A'
                            AND    TS.RECORD_STATUS                 = 'A'
                            AND    l_cur_detail.LL_FK_LOAD_LIST_ID  = TS.FK_LOAD_LIST_ID
                            AND    l_cur_detail.DL_VESSEL           = p_i_v_vessel
                            AND    TS.DN_EQUIPMENT_NO               = l_cur_detail.DL_DN_EQUIPMENT_NO
                            AND    ((l_cur_detail.DL_FK_BOOKING_NO IS NULL) OR
                                    (TS.FK_BOOKING_NO               = l_cur_detail.DL_FK_BOOKING_NO))
                            --AND    l_cur_detail.LL_LOAD_LIST_STATUS = 0
                            AND    P.PICODE                         = l_cur_detail.LL_POL
                            AND    (TO_DATE(TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'), 'RRRRMMDD')+(1/1440*(MOD(TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'), 100)+FLOOR(TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI')/100)*60))-(1/1440*(MOD(P.PIVGMT, 100)+FLOOR(P.PIVGMT/100)*60)))
                                    <
                                   (TO_DATE(TO_CHAR(TO_DATE(p_i_dt_dl_eta,'DD/MM/YYYY HH24:MI'), 'YYYYMMDD'),'RRRRMMDD')+(1/1440*(MOD(TO_CHAR(TO_DATE(p_i_dt_dl_eta,'DD/MM/YYYY HH24:MI'),'HH24MI'), 100)+FLOOR(TO_CHAR(TO_DATE(p_i_dt_dl_eta,'DD/MM/YYYY HH24:MI'),'HH24MI')/100)*60))-(1/1440*(MOD(P.PIVGMT, 100)+FLOOR(P.PIVGMT/100)*60)))
                           )
                        ORDER BY ACTIVITY_DATE_TIME DESC
                       )
                    WHERE SRNO = 1;
                ELSE
                    --WHEN CALLED FROM LOAD LIST
                    SELECT STOWAGE_POSITION
                    INTO   l_v_restow_pos
                    FROM
                       (SELECT ROW_NUMBER() OVER (ORDER BY ACTIVITY_DATE_TIME DESC) SRNO
                             , STOWAGE_POSITION
                        FROM
                           (SELECT TS.STOWAGE_POSITION
                                 , TS.ACTIVITY_DATE_TIME ACTIVITY_DATE_TIME
                            FROM   TOS_RESTOW TS,
                                   ITP040 P
                            WHERE  l_cur_detail.DL_DL_RECORD_STATUS      = 'A'
                            AND    TS.RECORD_STATUS                      = 'A'
                            AND    l_cur_detail.DL_FK_DISCHARGE_LIST_ID  = TS.FK_DISCHARGE_LIST_ID
                            AND    l_cur_detail.DL_VESSEL                = p_i_v_vessel
                            AND    TS.DN_EQUIPMENT_NO                    = l_cur_detail.DL_DN_EQUIPMENT_NO
                            AND    ((l_cur_detail.DL_FK_BOOKING_NO IS NULL) OR
                                    (TS.FK_BOOKING_NO                    = l_cur_detail.DL_FK_BOOKING_NO))
                            --AND    l_cur_detail.DL_DISCHARGE_LIST_STATUS = 0
                            AND    TS.RESTOW_STATUS                      = 'LO'
                            AND    P.PICODE                              = l_cur_detail.DL_POD
                            AND    (TO_DATE(TO_CHAR(TS.ACTIVITY_DATE_TIME,'YYYYMMDD'), 'RRRRMMDD')+(1/1440*(MOD(TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI'), 100)+FLOOR(TO_CHAR(TS.ACTIVITY_DATE_TIME,'HH24MI')/100)*60))-(1/1440*(MOD(P.PIVGMT, 100)+FLOOR(P.PIVGMT/100)*60)))
                                    >
                                   (TO_DATE(TO_CHAR(TO_DATE(p_i_dt_ll_etd,'DD/MM/YYYY HH24:MI'), 'YYYYMMDD'),'RRRRMMDD')+(1/1440*(MOD(TO_CHAR(TO_DATE(p_i_dt_ll_etd,'DD/MM/YYYY HH24:MI'),'HH24MI'), 100)+FLOOR(TO_CHAR(TO_DATE(p_i_dt_ll_etd,'DD/MM/YYYY HH24:MI'),'HH24MI')/100)*60))-(1/1440*(MOD(P.PIVGMT, 100)+FLOOR(P.PIVGMT/100)*60)))
                           )
                        ORDER BY ACTIVITY_DATE_TIME DESC
                       )
                    WHERE SRNO = 1;
                END IF;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     l_v_restow_pos := NULL;
                     g_v_err_code   := TO_CHAR (SQLCODE);
                     g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                     --l_v_sql_type := 'A';
--                       PRE_LOG_INFO
--                        ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                       , l_v_obj_nm
--                       , g_v_sql_id
--                       , g_v_user
--                       , l_t_log_info
--                       , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                       , NULL
--                       , NULL
--                       , NULL
--                        );
                            --l_b_raise_exp := TRUE;
             END;
          END IF;

        * *16 end */

        /*  Commented by Vikas, as suggested by k'chatgamol, no need to populate for each equipment,  on 07.11.2011

        g_v_sql_id := 'SQL-01016';
        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
        PKG_EDI_DOCUMENT.PRC_CREATE_PORT
        (p_i_v_eme_uid
        , l_n_edi_etd_seq
        , NULL
        , l_n_edi_esde_uid
        , l_v_picode
        , l_v_tqtord
        , '61'
        , l_n_edi_esdl_uid
        );

        l_arr_var_name := STRING_ARRAY
        ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
        , 'p_edi_esde_uid'      , 'p_port'              , 'p_terminal'
        , 'p_port_qualifer'     , 'p_edi_esdl_uid'
        );

        l_arr_var_value := STRING_ARRAY
        (p_i_v_eme_uid                , l_n_edi_etd_seq     , NULL
        , NULL                         , l_v_picode          , l_v_tqtord
        , '61'                         , l_n_edi_esdl_uid
        );

        l_arr_var_io := STRING_ARRAY
        ('I'      , 'I'      , 'I'
        , 'I'      , 'I'      , 'I'
        , 'I'      , 'O'
        );

        PRE_LOG_INFO
        ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
        , l_v_obj_nm
        , g_v_sql_id
        , g_v_user
        , l_t_log_info
        , NULL
        , l_arr_var_name
        , l_arr_var_value
        , l_arr_var_io
        );
*/
        l_v_booking_no := l_cur_detail.DL_FK_BOOKING_NO;
        FOR l_cur_party_det IN l_cur_party LOOP
            IF l_cur_party_det.BNCSTP = 'S' THEN
                l_v_scf := 'SH';
            END IF;
            IF l_cur_party_det.BNCSTP = 'C' THEN
                l_v_scf := 'CN';
            END IF;
            IF l_cur_party_det.BNCSTP = 'F' THEN
                l_v_scf := 'FW';
            END IF;

            g_v_sql_id := 'SQL-01017';
            --EXECUTE PROCEDURE WITH PARAMETERS TO INSERT DATA INTO EDI_ST_DOC_PARTY
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';
            PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
            (p_i_v_eme_uid
            , l_n_edi_etd_seq
            , l_v_scf
            , l_cur_party_det.BNCSCD
            , l_cur_party_det.BNNAME
            , l_cur_party_det.BNADD1
            , l_cur_party_det.BNADD2
            , l_cur_party_det.BNADD3
            , l_cur_party_det.BNADD4
            , NULL
            , l_cur_party_det.BNCOUN
            , l_cur_party_det.BNZIP
            , l_n_edi_esde_uid
            , l_n_edi_esdp_uid
            );

--            l_arr_var_name := STRING_ARRAY
--            ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'       , 'p_i_v_bncstp'
--            , 'p_i_v_bncscd'       , 'p_i_v_bnname'          , 'p_i_v_bnadd1'
--            , 'p_i_v_bnadd2'       , 'p_i_v_bnadd3'          , 'p_i_v_bnadd4'
--            , 'Location_County'    , 'p_i_v_bncoun'          , 'p_i_v_bnzip'
--            , 'l_n_edi_esde_uid'   , 'l_n_edi_esdp_uid'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--            (p_i_v_eme_uid                , l_n_edi_etd_seq                 , l_v_scf
--            , l_cur_party_det.BNCSCD       , l_cur_party_det.BNNAME          , l_cur_party_det.BNADD1
--            , l_cur_party_det.BNADD2       , l_cur_party_det.BNADD3          , l_cur_party_det.BNADD4
--            , NULL                         , l_cur_party_det.BNCOUN          , l_cur_party_det.BNZIP
--            , l_n_edi_esde_uid             , l_n_edi_esdp_uid
--            );
--
--            l_arr_var_io := STRING_ARRAY
--            ('I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'O'
--            );
--
--            PRE_LOG_INFO
--            ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--            );

            g_v_sql_id := 'SQL-01018';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_CONTACT
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_CONTACT';
            PKG_EDI_DOCUMENT.PRC_INSERT_CONTACT
            ( l_n_edi_etd_seq
            , l_n_edi_esdp_uid
            , NULL                                --l_n_edi_esde_uid
            , 'IC'
            , l_cur_party_det.YTFNME
            , l_cur_party_det.YTDEPT
            , l_v_add_user
            , l_n_edi_esdcn_uid
            );

--            l_arr_var_name := STRING_ARRAY
--            ('l_n_edi_etd_uid'      , 'l_n_edi_esdp_uid'       , 'l_n_edi_esde_uid'
--            , 'p_i_v_ic'             , 'p_i_v_ytfnme'           , 'p_i_v_ytdept'
--            , 'p_i_v_edi'            , 'l_n_edi_esdcn_uid'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--            (l_n_edi_etd_seq        , l_n_edi_esdp_uid              , l_n_edi_esde_uid
--            , 'IC'                   , l_cur_party_det.YTFNME        , l_cur_party_det.YTDEPT
--            , l_v_add_user           , l_n_edi_esdcn_uid
--            );
--
--            l_arr_var_io := STRING_ARRAY
--            ('I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'O'
--            );
--
--            PRE_LOG_INFO
--            ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--            );

            g_v_sql_id := 'SQL-01019';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_COMM FOR TELEPHONE
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_COMM';
            PKG_EDI_DOCUMENT.PRC_INSERT_COMM
                (l_n_edi_esdcn_uid
                , 'TE'
                , l_cur_party_det.BNTELN
                , l_v_add_user
            );

--            l_arr_var_name := STRING_ARRAY
--                ('l_n_edi_esdcn_uid'      , 'p_i_v_tfe'       , 'p_i_v_tfe_descp'
--                , 'p_i_v_edi'
--                );
--
--            l_arr_var_value := STRING_ARRAY
--                (l_n_edi_esdcn_uid        , 'TE'              , l_cur_party_det.BNTELN
--                , l_v_add_user
--                );
--
--            l_arr_var_io := STRING_ARRAY
--                ('I'      , 'I'      , 'I'
--                , 'I'
--                );
--
--            PRE_LOG_INFO
--                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , g_v_user
--                , l_t_log_info
--                , NULL
--                , l_arr_var_name
--                , l_arr_var_value
--                , l_arr_var_io
--                );

            g_v_sql_id := 'SQL-01020';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_COMM FOR FAX
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_COMM';
            PKG_EDI_DOCUMENT.PRC_INSERT_COMM
                (l_n_edi_esdcn_uid
                , 'FX'
                , l_cur_party_det.BNFAX
                , l_v_add_user
                );

--            l_arr_var_name := STRING_ARRAY
--                ('l_n_edi_esdcn_uid'      , 'p_i_v_tfe'       , 'p_i_v_tfe_descp'
--                , 'p_i_v_edi'
--                );
--
--            l_arr_var_value := STRING_ARRAY
--                (l_n_edi_esdcn_uid        , 'FX'              , l_cur_party_det.BNFAX
--                , l_v_add_user
--                );
--
--            l_arr_var_io := STRING_ARRAY
--                ('I'      , 'I'      , 'I'
--                , 'I'
--                );
--
--            PRE_LOG_INFO
--                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , g_v_user
--                , l_t_log_info
--                , NULL
--                , l_arr_var_name
--                , l_arr_var_value
--                , l_arr_var_io
--                );

            g_v_sql_id := 'SQL-01021';
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_COMM FOR EMAIL
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_COMM';
            PKG_EDI_DOCUMENT.PRC_INSERT_COMM
                (l_n_edi_esdcn_uid
                , 'EM'
                , l_cur_party_det.BNEMAL
                , l_v_add_user
                );

--            l_arr_var_name := STRING_ARRAY
--                ('l_n_edi_esdcn_uid'      , 'p_i_v_tfe'       , 'p_i_v_tfe_descp'
--                , 'p_i_v_edi'
--                );
--
--            l_arr_var_value := STRING_ARRAY
--                (l_n_edi_esdcn_uid        , 'EM'              , l_cur_party_det.BNEMAL
--                , l_v_add_user
--                );
--
--            l_arr_var_io := STRING_ARRAY
--                ('I'      , 'I'      , 'I'
--                , 'I'
--                );
--
--            PRE_LOG_INFO
--                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , g_v_user
--                , l_t_log_info
--                , NULL
--                , l_arr_var_name
--                , l_arr_var_value
--                , l_arr_var_io
--            );

        END LOOP;--end of loop

        /*  Changes start by vikas, as no need to generate for each equipment
        create only for general * /

        -- start processing of create voyage details

        g_v_sql_id := 'SQL-01018a';

        --EXECUTE PROCEDURE WITH PARAMETERS TO CREATE A RECORD FOR JOURNEY

        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE';


        PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE(
            p_i_v_eme_uid
            , l_n_edi_etd_seq
            , l_cur_detail.DL_VOYAGE
            , l_cur_detail.DL_SERVICE
            , l_cur_detail.DL_VESSEL
            , l_cur_detail.DL_DIRECTION
            , l_cur_detail.LL_DN_DISCHARGE_PORT
            , 20
            , NULL     /* activity code *
            , l_n_edi_esde_uid --EDI_ESDE_UID is null   --aks 21july
            , l_cur_detail.LL_DN_DISCHARGE_TERMINAL --l_n_esdj_uid  --aks 21july
            , l_n_edi_esdj_uid
        );

        l_arr_var_name := STRING_ARRAY
            ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'   , 'p_i_v_voyage'
            , 'p_i_v_service'      , 'p_i_v_vessel'      , 'p_i_v_direction'
            , 'p_i_v_port'         , 'p_i_v_20'          , 'p_discharge_terminal'
            , 'l_n_edi_esdj_uid'
            );

        l_arr_var_value := STRING_ARRAY
            (p_i_v_eme_uid                         , l_n_edi_etd_seq              , l_cur_detail.DL_VOYAGE
            , l_cur_detail.DL_SERVICE                , l_cur_detail.DL_VESSEL        , l_cur_detail.DL_DIRECTION
            , l_cur_detail.LL_DN_DISCHARGE_PORT      , 20                           , l_cur_detail.LL_DN_DISCHARGE_TERMINAL
            , l_n_edi_esdj_uid
            );

        l_arr_var_io := STRING_ARRAY
            ('I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'I'
            , 'I'      , 'I'      , 'I'
            , 'O'
            );

        PRE_LOG_INFO(
            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
            , l_v_obj_nm
            , g_v_sql_id
            , g_v_user
            , l_t_log_info
            , NULL
            , l_arr_var_name
            , l_arr_var_value
            , l_arr_var_io
        );

        /* vikas: End start processing of create voyage details        *
        */

        BEGIN
           g_v_sql_id := 'SQL-01022';
           --RETREIVE BILL OF LANDING NO FROM TABLE
           l_v_obj_nm := 'IDP055,IDP002,IDP010';
           SELECT IDP010.AYBLNO
           INTO   l_v_bill_of_landing
           FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
           WHERE  IDP055.EYBLNO = IDP002.TYBLNO
           AND    IDP055.EYBLNO = IDP010.AYBLNO
           AND    IDP002.TYBLNO = IDP010.AYBLNO
           AND    IDP010.AYSTAT >=1
           AND    IDP010.AYSTAT <=6
           AND    IDP010.PART_OF_BL IS NULL
           AND    IDP002.TYBKNO = l_cur_detail.DL_FK_BOOKING_NO
           AND    IDP055.EYEQNO = l_cur_detail.DL_DN_EQUIPMENT_NO
           AND    ROWNUM=1;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
                l_v_bill_of_landing := NULL;
                g_v_err_code   := TO_CHAR (SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                --l_v_sql_type := 'A';
--               PRE_LOG_INFO
--                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--               , l_v_obj_nm
--               , g_v_sql_id
--               , g_v_user
--               , l_t_log_info
--               , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--               , NULL
--               , NULL
--               , NULL
--                );
                --l_b_raise_exp := TRUE;
        END;

        g_v_sql_id := 'SQL-01023';
        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_REFERENCE FOR BL
        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE';
        PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE
        (l_n_edi_etd_seq
        , 'BM'
        , l_v_bill_of_landing
        , l_v_add_user
        , l_n_edi_esde_uid
        , NULL
        , NULL
        , NULL
        );

--        l_arr_var_name := STRING_ARRAY
--        ('l_n_edi_etd_seq'      , 'p_i_v_bm_bl'           , 'p_i_v_bm_bl_descp'
--        , 'p_i_v_edi'            , 'l_n_edi_esde_uid'      , 'EDI_ESDL_UID'
--        , 'EDI_ESDJ_UID'         , 'EDI_ESDP_UID'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--        (l_n_edi_etd_seq            , 'BM'                    , l_v_bill_of_landing
--        , l_v_add_user               , l_n_edi_esde_uid        , NULL
--        , NULL                       , NULL
--            );
--
--            l_arr_var_io := STRING_ARRAY
--        ('I'      , 'I'      , 'I'
--        , 'I'      , 'I'      , 'I'
--        , 'I'      , 'I'
--            );
--
--        PRE_LOG_INFO
--        ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--        , l_v_obj_nm
--        , g_v_sql_id
--        , g_v_user
--        , l_t_log_info
--        , NULL
--        , l_arr_var_name
--        , l_arr_var_value
--        , l_arr_var_io
--        );

        g_v_sql_id := 'SQL-01024';
        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_REFERENCE FOR BOOKING NO.
        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE';
        PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE
        (l_n_edi_etd_seq
        , 'BN'
        , l_cur_detail.DL_FK_BOOKING_NO
        , l_v_add_user
        , l_n_edi_esde_uid
        , NULL
        , NULL
        , NULL
        );

--    l_arr_var_name := STRING_ARRAY
--    ('l_n_edi_etd_seq'      , 'p_i_v_bm_bl'           , 'p_i_v_bm_bl_descp'
--    , 'p_i_v_edi'            , 'l_n_edi_esde_uid'      , 'EDI_ESDL_UID'
--    , 'EDI_ESDJ_UID'         , 'EDI_ESDP_UID'
--        );
--
--        l_arr_var_value := STRING_ARRAY
--    (l_n_edi_etd_seq            , 'BN'                    , l_cur_detail.DL_FK_BOOKING_NO
--    , l_v_add_user               , l_n_edi_esde_uid        , NULL
--    , NULL                       , NULL
--        );
--
--        l_arr_var_io := STRING_ARRAY
--    ('I'      , 'I'      , 'I'
--    , 'I'      , 'I'      , 'I'
--    , 'I'      , 'I'
--        );
--
--    PRE_LOG_INFO
--    ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--    , l_v_obj_nm
--    , g_v_sql_id
--    , g_v_user
--    , l_t_log_info
--    , NULL
--    , l_arr_var_name
--    , l_arr_var_value
--    , l_arr_var_io
--    );

        /* vikas: added for add party to EDI_ST_DOC_PARTY */
        BEGIN
            g_v_sql_id := 'SQL-01024a';

            IF l_cur_detail.DL_FK_CONTAINER_OPERATOR IS NOT NULL THEN
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';
                PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                    (p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , 'CF'
                    , l_cur_detail.DL_FK_CONTAINER_OPERATOR
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , l_n_edi_esde_uid
                    , l_n_edi_esdp_uid
                );
            END IF;
            /* start added by vikas verma */
            g_v_sql_id := 'SQL-01024b';
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';

            IF l_cur_detail.DL_OUT_SLOT_OPERATOR IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                     (p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , 'OSL'
                    , l_cur_detail.DL_OUT_SLOT_OPERATOR
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , l_n_edi_esde_uid
                    , l_n_edi_esdp_uid
                );
            END IF;
            /* end added by vikas verma */

            g_v_sql_id := 'SQL-01024c';
            --EXECUTE PROCEDURE WITH PARAMETERS TO INSERT DATA INTO EDI_ST_DOC_PARTY
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';

            IF l_cur_detail.DL_FK_SLOT_OPERATOR IS NOT NULL THEN
                PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                     (p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , 'CA'
                    , l_cur_detail.DL_FK_SLOT_OPERATOR
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , l_n_edi_esde_uid
                    , l_n_edi_esdp_uid
                );
            END IF;

--                 l_arr_var_name := STRING_ARRAY
--                 ('p_i_v_eme_uid'      , 'l_n_edi_etd_seq'       , 'p_i_v_bncstp'
--                , 'p_i_v_bncscd'       , 'p_i_v_bnname'          , 'p_i_v_bnadd1'
--                , 'p_i_v_bnadd2'       , 'p_i_v_bnadd3'          , 'p_i_v_bnadd4'
--                , 'Location_County'    , 'p_i_v_bncoun'          , 'p_i_v_bnzip'
--                , 'l_n_edi_esde_uid'   , 'l_n_edi_esdp_uid'
--                  );
--
--                  l_arr_var_value := STRING_ARRAY
--                 (p_i_v_eme_uid                      , l_n_edi_etd_seq          , 'SL'
--                , l_cur_detail.DL_FK_SLOT_OPERATOR   , NULL                     , NULL
--                , NULL                               , NULL                     , NULL
--                , NULL                               , NULL                     , NULL
--                , l_n_edi_esde_uid                   , l_n_edi_esdp_uid
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
--                PRE_LOG_INFO(
--                    'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                   , l_v_obj_nm
--                   , g_v_sql_id
--                   , g_v_user
--                   , l_t_log_info
--                   , NULL
--                   , l_arr_var_name
--                   , l_arr_var_value
--                   , l_arr_var_io
--                );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                l_b_raise_exp := TRUE;
--                PRE_LOG_INFO(
--                    'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , g_v_user
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                    , NULL
--                    , NULL
--                    , NULL
--                 );
        END;

        /* vikas: end  for add party to EDI_ST_DOC_PARTY */

        l_v_hndl_inst_desc1   := NULL;
        l_v_hndl_inst_desc2   := NULL;
        l_v_hndl_inst_desc3   := NULL;
        l_v_cont_ld_rem_desc1 := NULL;
        l_v_cont_ld_rem_desc2 := NULL;

         --Check Handling Instruction.
        IF l_cur_detail.DL_FK_HANDLING_INSTRUCTION_1 IS NOT NULL THEN
            BEGIN
               g_v_sql_id := 'SQL-01025';
               l_v_obj_nm := 'SHP007';
               SELECT SHI_DESCRIPTION
               INTO   l_v_hndl_inst_desc1
               FROM   SHP007
               WHERE  SHI_CODE = l_cur_detail.DL_FK_HANDLING_INSTRUCTION_1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  l_v_hndl_inst_desc1 := NULL;
                  g_v_err_code   := TO_CHAR (SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                  --l_v_sql_type := 'A';
--                   PRE_LOG_INFO
--                    ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                   , l_v_obj_nm
--                   , g_v_sql_id
--                   , g_v_user
--                   , l_t_log_info
--                   , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                   , NULL
--                   , NULL
--                   , NULL
--                    );
                     --l_b_raise_exp := TRUE;
            END;
         END IF;
         IF l_cur_detail.DL_FK_HANDLING_INSTRUCTION_2 IS NOT NULL THEN
            BEGIN
               g_v_sql_id := 'SQL-01026';
               l_v_obj_nm := 'SHP007';
               SELECT SHI_DESCRIPTION
               INTO   l_v_hndl_inst_desc2
               FROM   SHP007
               WHERE  SHI_CODE = l_cur_detail.DL_FK_HANDLING_INSTRUCTION_2;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  l_v_hndl_inst_desc2 := NULL;
                  g_v_err_code   := TO_CHAR (SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                  --l_v_sql_type := 'A';
--                   PRE_LOG_INFO
--                    ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                   , l_v_obj_nm
--                   , g_v_sql_id
--                   , g_v_user
--                   , l_t_log_info
--                   , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                   , NULL
--                   , NULL
--                   , NULL
--                    );
                  --l_b_raise_exp := TRUE;
            END;
         END IF;
         IF l_cur_detail.DL_FK_HANDLING_INSTRUCTION_3 IS NOT NULL THEN
            BEGIN
               g_v_sql_id := 'SQL-01027';
               l_v_obj_nm := 'SHP007';
               SELECT SHI_DESCRIPTION
               INTO   l_v_hndl_inst_desc3
               FROM   SHP007
               WHERE  SHI_CODE = l_cur_detail.DL_FK_HANDLING_INSTRUCTION_3;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  l_v_hndl_inst_desc3 := NULL;
                  g_v_err_code   := TO_CHAR (SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                  --l_v_sql_type := 'A';
--                   PRE_LOG_INFO
--                    ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                   , l_v_obj_nm
--                   , g_v_sql_id
--                   , g_v_user
--                   , l_t_log_info
--                   , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                   , NULL
--                   , NULL
--                   , NULL                    );
                  --l_b_raise_exp := TRUE;
            END;
         END IF;
         --Check Container Loading Remarks.
         IF l_cur_detail.DL_CONTAINER_LOADING_REM_1 IS NOT NULL THEN
            BEGIN
               g_v_sql_id := 'SQL-01028';
               l_v_obj_nm := 'SHP041';
               SELECT CLR_DESC
               INTO   l_v_cont_ld_rem_desc1
               FROM   SHP041
               WHERE  CLR_CODE = l_cur_detail.DL_CONTAINER_LOADING_REM_1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  l_v_cont_ld_rem_desc1 := NULL;
                  g_v_err_code   := TO_CHAR (SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                  --l_v_sql_type := 'A';
--                   PRE_LOG_INFO
--                    ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                   , l_v_obj_nm
--                   , g_v_sql_id
--                   , g_v_user
--                   , l_t_log_info
--                   , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                   , NULL
--                   , NULL
--                   , NULL
--                    );
                  --l_b_raise_exp := TRUE;
            END;
         END IF;
         IF l_cur_detail.DL_CONTAINER_LOADING_REM_2 IS NOT NULL THEN
            BEGIN
               g_v_sql_id := 'SQL-01029';
               l_v_obj_nm := 'SHP041';
               SELECT CLR_DESC
               INTO   l_v_cont_ld_rem_desc2
               FROM   SHP041
               WHERE  CLR_CODE = l_cur_detail.DL_CONTAINER_LOADING_REM_2;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  l_v_cont_ld_rem_desc2 := NULL;
                  g_v_err_code   := TO_CHAR (SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                  --l_v_sql_type := 'A';
--                   PRE_LOG_INFO
--                    ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                   , l_v_obj_nm
--                   , g_v_sql_id
--                   , g_v_user
--                   , l_t_log_info
--                   , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                   , NULL
--                   , NULL
--                   , NULL
--                    );
                  --l_b_raise_exp := TRUE;
            END;
         END IF;

         g_v_sql_id := 'SQL-01030';
        /*
            Start added by vikas, populate handling instruction
            concatenated, not seprate entry in edi_st_doc_text
            for handling ins1,2,3 as k'chatgamol, 29.12.2011
        */
        IF LENGTH (   l_cur_detail.DL_FK_HANDLING_INSTRUCTION_1
                   || l_cur_detail.DL_FK_HANDLING_INSTRUCTION_2
                   || l_cur_detail.DL_FK_HANDLING_INSTRUCTION_3
                  ) > 0 THEN

            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                l_n_edi_etd_seq
               , NULL
               , NULL
               , 'HAN'
               , NULL
               , l_cur_detail.DL_FK_HANDLING_INSTRUCTION_1
                    || l_cur_detail.DL_FK_HANDLING_INSTRUCTION_2
                    || l_cur_detail.DL_FK_HANDLING_INSTRUCTION_3
               , l_v_add_user
               , l_n_edi_esde_uid
            );
--            l_arr_var_name := STRING_ARRAY(
--                'l_n_edi_etd_seq'      , 'EDI_ESDH_UID'           , 'EDI_ESDCO_UID'
--                , 'p_i_v_hn_cr_flg'      , 'p_i_v_hn_cr_descp'      , 'p_i_v_hn_cr_code'
--                , 'p_i_v_edi'            , 'l_n_edi_esde_uid'
--            );
--
--            l_arr_var_value := STRING_ARRAY(
--                l_n_edi_etd_seq         , NULL                       , NULL
--                , 'HAN'                 ,l_cur_detail.DL_FK_HANDLING_INSTRUCTION_1
--                || l_cur_detail.DL_FK_HANDLING_INSTRUCTION_2
--                || l_cur_detail.DL_FK_HANDLING_INSTRUCTION_3
--                , null   , l_v_add_user            , l_n_edi_esde_uid
--            );
--
--            l_arr_var_io := STRING_ARRAY(
--                'I'      , 'I'      , 'I'
--                , 'I'      , 'I'      , 'I'
--                , 'I'      , 'I'
--            );
--
--            PRE_LOG_INFO(
--                'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                , l_v_obj_nm
--                , g_v_sql_id
--                , g_v_user
--                , l_t_log_info
--                , NULL
--                , l_arr_var_name
--                , l_arr_var_value
--                , l_arr_var_io
--            );

        END IF;

        /*
            Old Logic

         IF l_v_hndl_inst_desc1 IS NOT NULL THEN
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR HANDLING_INSTRUCTION_1
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT
            (l_n_edi_etd_seq
           , NULL
           , NULL
           , 'HAN'
           , l_v_hndl_inst_desc1
           , l_cur_detail.DL_FK_HANDLING_INSTRUCTION_1
           , l_v_add_user
           , l_n_edi_esde_uid
            );

             l_arr_var_name := STRING_ARRAY
           ('l_n_edi_etd_seq'      , 'EDI_ESDH_UID'           , 'EDI_ESDCO_UID'
          , 'p_i_v_hn_cr_flg'      , 'p_i_v_hn_cr_descp'      , 'p_i_v_hn_cr_code'
          , 'p_i_v_edi'            , 'l_n_edi_esde_uid'
            );

            l_arr_var_value := STRING_ARRAY
           (l_n_edi_etd_seq         , NULL                       , NULL
          , 'HAN'                   , l_v_hndl_inst_desc1        , l_cur_detail.DL_FK_HANDLING_INSTRUCTION_1
          , l_v_add_user            , l_n_edi_esde_uid
            );

            l_arr_var_io := STRING_ARRAY
           ('I'      , 'I'      , 'I'
          , 'I'      , 'I'      , 'I'
          , 'I'      , 'I'
            );

           PRE_LOG_INFO
           ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
          , l_v_obj_nm
          , g_v_sql_id
          , g_v_user
          , l_t_log_info
          , NULL
          , l_arr_var_name
          , l_arr_var_value
          , l_arr_var_io
           );
        END IF;

         g_v_sql_id := 'SQL-01031';
         IF l_v_hndl_inst_desc2 IS NOT NULL THEN
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR HANDLING_INSTRUCTION_2
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT
            (l_n_edi_etd_seq
           , NULL
           , NULL
           , 'HAN'
           , l_v_hndl_inst_desc2
           , l_cur_detail.DL_FK_HANDLING_INSTRUCTION_2
           , l_v_add_user
           , l_n_edi_esde_uid
            );

            l_arr_var_name := STRING_ARRAY
           ('l_n_edi_etd_seq'      , 'EDI_ESDH_UID'           , 'EDI_ESDCO_UID'
          , 'p_i_v_hn_cr_flg'      , 'p_i_v_hn_cr_descp'      , 'p_i_v_hn_cr_code'
          , 'p_i_v_edi'            , 'l_n_edi_esde_uid'
            );

            l_arr_var_value := STRING_ARRAY
           (l_n_edi_etd_seq         , NULL                       , NULL
          , 'HAN'                   , l_v_hndl_inst_desc2        , l_cur_detail.DL_FK_HANDLING_INSTRUCTION_2
          , l_v_add_user            , l_n_edi_esde_uid
            );

            l_arr_var_io := STRING_ARRAY
           ('I'      , 'I'      , 'I'
          , 'I'      , 'I'      , 'I'
          , 'I'      , 'I'
            );

           PRE_LOG_INFO
           ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
          , l_v_obj_nm
          , g_v_sql_id
          , g_v_user
          , l_t_log_info
          , NULL
          , l_arr_var_name
          , l_arr_var_value
          , l_arr_var_io
           );
         END IF;

         g_v_sql_id := 'SQL-01032';
         IF l_v_hndl_inst_desc3 IS NOT NULL THEN
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR HANDLING_INSTRUCTION_3
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT
            (l_n_edi_etd_seq
           , NULL
           , NULL
           , 'HAN'
           , l_v_hndl_inst_desc3
           , l_cur_detail.DL_FK_HANDLING_INSTRUCTION_3
           , l_v_add_user
           , l_n_edi_esde_uid
            );

            l_arr_var_name := STRING_ARRAY
           ('l_n_edi_etd_seq'      , 'EDI_ESDH_UID'           , 'EDI_ESDCO_UID'
          , 'p_i_v_hn_cr_flg'      , 'p_i_v_hn_cr_descp'      , 'p_i_v_hn_cr_code'
          , 'p_i_v_edi'            , 'l_n_edi_esde_uid'
            );

            l_arr_var_value := STRING_ARRAY
           (l_n_edi_etd_seq         , NULL                       , NULL
          , 'HAN'                   , l_v_hndl_inst_desc3        , l_cur_detail.DL_FK_HANDLING_INSTRUCTION_3
          , l_v_add_user            , l_n_edi_esde_uid
            );

            l_arr_var_io := STRING_ARRAY
           ('I'      , 'I'      , 'I'
          , 'I'      , 'I'      , 'I'
          , 'I'      , 'I'
            );

           PRE_LOG_INFO
           ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
          , l_v_obj_nm
          , g_v_sql_id
          , g_v_user
          , l_t_log_info
          , NULL
          , l_arr_var_name
          , l_arr_var_value
          , l_arr_var_io
           );
         END IF;

        *
            End Added by vikas, 29.12.2011
        */
         g_v_sql_id := 'SQL-01033';
         IF l_v_cont_ld_rem_desc1 IS NOT NULL THEN
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR CONTAINER_LOADING_REM_1
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT
            (l_n_edi_etd_seq
           ,  NULL
           , NULL
           , 'CLR'
           , l_v_cont_ld_rem_desc1
           , l_cur_detail.DL_CONTAINER_LOADING_REM_1
           , l_v_add_user
           , l_n_edi_esde_uid
            );

--            l_arr_var_name := STRING_ARRAY
--           ('l_n_edi_etd_seq'      , 'EDI_ESDH_UID'           , 'EDI_ESDCO_UID'
--          , 'p_i_v_hn_cr_flg'      , 'p_i_v_hn_cr_descp'      , 'p_i_v_hn_cr_code'
--          , 'p_i_v_edi'            , 'l_n_edi_esde_uid'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--           (l_n_edi_etd_seq         , NULL                       , NULL
--          , 'CLR'                   , l_v_cont_ld_rem_desc1        , l_cur_detail.DL_CONTAINER_LOADING_REM_1
--          , l_v_add_user            , l_n_edi_esde_uid
--            );
--
--            l_arr_var_io := STRING_ARRAY
--           ('I'      , 'I'      , 'I'
--          , 'I'      , 'I'      , 'I'
--          , 'I'      , 'I'
--            );
--
--           PRE_LOG_INFO
--           ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--          , l_v_obj_nm
--          , g_v_sql_id
--          , g_v_user
--          , l_t_log_info
--          , NULL
--          , l_arr_var_name
--          , l_arr_var_value
--          , l_arr_var_io
--           );
         END IF;

         g_v_sql_id := 'SQL-01034';
         IF l_v_cont_ld_rem_desc2 IS NOT NULL THEN
            --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR CONTAINER_LOADING_REM_2
            l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT
            (l_n_edi_etd_seq
           , NULL
           , NULL
           , 'CLR'
           , l_v_cont_ld_rem_desc2
           , l_cur_detail.DL_CONTAINER_LOADING_REM_2
           , l_v_add_user
           , l_n_edi_esde_uid
            );

--            l_arr_var_name := STRING_ARRAY
--           ('l_n_edi_etd_seq'      , 'EDI_ESDH_UID'           , 'EDI_ESDCO_UID'
--          , 'p_i_v_hn_cr_flg'      , 'p_i_v_hn_cr_descp'      , 'p_i_v_hn_cr_code'
--          , 'p_i_v_edi'            , 'l_n_edi_esde_uid'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--           (l_n_edi_etd_seq         , NULL                       , NULL
--          , 'CLR'                   , l_v_cont_ld_rem_desc2        , l_cur_detail.DL_CONTAINER_LOADING_REM_2
--          , l_v_add_user            , l_n_edi_esde_uid
--            );
--
--            l_arr_var_io := STRING_ARRAY
--           ('I'      , 'I'      , 'I'
--          , 'I'      , 'I'      , 'I'
--          , 'I'      , 'I'
--            );
--
--           PRE_LOG_INFO
--           ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--          , l_v_obj_nm
--          , g_v_sql_id
--          , g_v_user
--          , l_t_log_info
--          , NULL
--          , l_arr_var_name
--          , l_arr_var_value
--          , l_arr_var_io
--           );
         END IF;

        /* *14 start * */
        G_V_SQL_ID := 'SQLa01034';
        --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_TEXT FOR CONTAINER_LOADING_REM_1
        IF ((l_cur_detail.DL_DN_SPECIAL_HNDL = 'DA' OR l_cur_detail.DL_DN_SPECIAL_HNDL = 'OD') AND
            (P_I_V_PORT = 'SGSIN')) THEN

            L_V_OBJ_NM := 'PKG_EDI_DOCUMENT.PRC_INSERT_TEXT';
            PKG_EDI_DOCUMENT.PRC_INSERT_TEXT(
                L_N_EDI_ETD_SEQ
                , NULL
                , NULL
                , 'CLR'
                , NULL -- description would be blank
                , 'DO'
                , L_V_ADD_USER
                , L_N_EDI_ESDE_UID
            );

        END IF;
        /* *14 end * */

         --GET UNIQUE SEQUENCE ID'S NEXT VALUE INTO VARIABLE
        SELECT EDI_ESDCO_SEQ.NEXTVAL
        INTO   l_n_edi_esdco_uid
        FROM   DUAL;

        BEGIN
            g_v_sql_id := 'SQL-1011b';
            --SELECT VALUES INTO VARIABLES
            l_v_obj_nm := 'IDP055,IDP002,IDP010,IDP050';
            SELECT
                FE_TRANS_DATA(p_i_v_eme_uid,'COMMODITY',IDP050.BYCMCD)
                ,FE_TRANS_DATA(p_i_v_eme_uid,'DESCRIPTION',IDP050.BYRMKS)
                ,FE_TRANS_DATA(p_i_v_eme_uid,'PACKAGE_TYPE',NVL(IDP050.BYKIND,'PCS'))
                ,FE_TRANS_DATA(p_i_v_eme_uid,'PIECE_COUNT',IDP050.BYPCKG)
                ,FE_TRANS_DATA(p_i_v_eme_uid,'GROSS_WEIGHT',IDP050.BYMTWT)
                ,FE_TRANS_DATA(p_i_v_eme_uid,'VOLUME',IDP050.BYMTMS)
                ,FE_TRANS_DATA(p_i_v_eme_uid,'LENGTH',IDP050.BYLENG)
                ,FE_TRANS_DATA(p_i_v_eme_uid,'WIDTH',IDP050.BYWDTH)
                ,FE_TRANS_DATA(p_i_v_eme_uid,'HEIGHT',IDP050.BYHGHT)
                ,IDP050.BYCMCD -- Added by Dhruv Parekh
            INTO
                l_v_comm
                ,l_v_descp
                ,l_v_bpackage_type
                ,l_v_bpiece_count
                ,l_v_gross_weight
                ,l_v_volume
                ,l_v_length
                ,l_v_width
                ,l_v_height
            ,l_v_bycmcd -- Added by Dhruv Parekh
            FROM  IDP055 IDP055
                , IDP002 IDP002
                , IDP010 IDP010
                , IDP050 IDP050
            WHERE IDP055.EYBLNO  = IDP002.TYBLNO
            AND   IDP055.EYBLNO    = IDP010.AYBLNO
            AND   IDP002.TYBLNO    = IDP010.AYBLNO
            AND   IDP055.EYBLNO    = IDP050.BYBLNO
            AND   IDP055.EYCMSQ    = IDP050.BYCMSQ
            AND   IDP010.AYSTAT    >=1
            AND   IDP010.AYSTAT    <=6
            AND   IDP010.PART_OF_BL IS NULL
            AND   IDP002.TYBKNO    = l_cur_detail.DL_FK_BOOKING_NO
            AND   IDP055.EYEQNO    = l_cur_detail.DL_DN_EQUIPMENT_NO
            AND   ROWNUM=1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_err_code   := TO_CHAR (SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                --l_v_sql_type := 'A';
--                PRE_LOG_INFO
--                        ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , g_v_user
--                    , l_t_log_info
--                    , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--                    , NULL
--                    , NULL
--                    , NULL
--                    );
                l_v_comm          := NULL;
                l_v_descp         := NULL;
                l_v_bpackage_type  := NULL;
                l_v_bpiece_count   := NULL;
                l_v_gross_weight  := NULL;
                l_v_volume        := NULL;
                l_v_length        := NULL;
                l_v_width         := NULL;
                l_v_height        := NULL;
        END;

        g_v_sql_id := 'SQL-1011c';
        /* *Added by vikas verma for insert data in EDI_ST_DOC_REFERENCE */
        SELECT DECODE (l_cur_detail.DL_DN_SHIPMENT_TYP,
            'LCL', '2',
            'FCL', '3',
            '3'
        )
        INTO  l_v_shipment_type
        FROM DUAL;

        g_v_sql_id := 'SQL-1011D';
        l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE-TMD';
        PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE(
            l_n_edi_etd_seq
            , 'TMD'
            , l_v_shipment_type
            , g_v_user
            , l_n_edi_esde_uid
            , NULL
            , NULL
            , NULL
         );
        /* *End Added by vikas verma for insert data in EDI_ST_DOC_REFERENCE */

        /* Vikas: as suggested by hemlata san, if container is empty then no need to insert weight. bloack start */
        IF l_cur_detail.LL_DN_FULL_MT = 'E' THEN
            l_cnt_weight_uom := NULL;
        END IF;
        /* Vikas: changes end */

         g_v_sql_id := 'SQL-01035';
         --INSERT RECORD INTO TABLE
         l_v_obj_nm := 'EDI_ST_DOC_COMMODITY';
         INSERT INTO EDI_ST_DOC_COMMODITY
            (EDI_ESDCO_UID
            ,EDI_ETD_UID
            ,COMMODITY
            ,DESCRIPTION
            ,PACKAGE_TYPE
            ,PIECE_COUNT
            ,GROSS_WEIGHT
            ,WEIGHT_UOM
            ,VOLUME
            ,VOLUME_UOM
            ,LENGTH
            ,WIDTH
            ,HEIGHT
            ,LENGTH_UOM
            ,MOVEMENT_TYPE
            ,HAULAGE_ARRANGEMENTS
            ,RECORD_STATUS
            ,RECORD_ADD_USER
            ,RECORD_ADD_DATE
            ,RECORD_CHANGE_USER
            ,RECORD_CHANGE_DATE)
        VALUES( l_n_edi_esdco_uid
               ,l_n_edi_etd_seq             -- Because the filed is not nullable but as per doc value passed should be null NULL
               ,l_v_comm
               ,SUBSTR(l_v_descp,1,70)
               ,SUBSTR(l_v_bpackage_type,1,4)
               ,l_v_bpiece_count
               ,l_v_gross_weight
               ,l_cnt_weight_uom
               ,l_v_volume
               ,l_cnt_volume_uom
               ,l_v_length
               ,l_v_width
               ,l_v_height
               ,NULL
               ,NULL
               ,NULL
               ,'A'
               ,l_v_add_user
               ,SYSDATE
               ,NULL
               ,NULL
              );

--       PRE_LOG_INFO
--        ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--       , l_v_obj_nm
--       , g_v_sql_id
--       , g_v_user
--       , l_t_log_info
--       , 'INSERT CALLED'
--       , NULL
--       , NULL
--       , NULL
--        );

         g_v_sql_id := 'SQL-01036';
         --INSERT RECORD INTO TABLE
         l_v_obj_nm := 'EDI_ST_DOC_EQP_LINK';
         INSERT INTO EDI_ST_DOC_EQP_LINK
            (EDI_ESDCO_UID
            ,EDI_ESDE_UID)
         VALUES
            (l_n_edi_esdco_uid
            ,l_n_edi_esde_uid);

--        PRE_LOG_INFO(
--            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , 'INSERT CALLED'
--            , NULL
--            , NULL
--            , NULL
--        );

    /* Dhruv Parekh: Below code added against issue 587. Block Starts */
    BEGIN
     SELECT FCDESC
     INTO l_v_fcdesc
     FROM ITP080
     WHERE FCCODE = l_v_bycmcd
     AND FCRCST = 'A'
     AND ROWNUM = 1;
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
        'BP'
        ,'CALLING AAA' ||'~' || l_v_fcdesc ||'~' || l_v_bycmcd
        ,'A'
        ,'EDI'
        ,SYSDATE
        ,'EDI'
        ,SYSDATE

    );
    --commit;
*/
     pkg_edi_document.prc_insert_text (
     l_n_edi_etd_seq,
      NULL,
      l_n_edi_esdco_uid,
      'AAA',
      l_v_fcdesc,
      l_v_bycmcd,
      'EDI',
      NULL       -- l_n_edi_esde_uid
     );
    EXCEPTION
     WHEN OTHERS
     THEN
      l_v_fcdesc := NULL;
    END;
    /* Block Ends */

        /* *Added by vikas verma for insert data in EDI_ST_DOC_REFERENCE */
        PKG_EDI_DOCUMENT.PRC_INSERT_REFERENCE(
            l_n_edi_etd_seq
            , 'HS'
            , l_v_comm -- , l_v_shipment_type -- , l_cur_idp050_data.bycmcd
            , g_v_user
            , l_n_edi_esde_uid
            , NULL
            , NULL
            , NULL
        );
        /* * End  added by vikas verma for insert data in EDI_ST_DOC_REFERENCE */
    BEGIN
        g_v_sql_id := 'SQL-01137';
        --SELECT VALUES INTO VARIABLES
            l_v_obj_nm := 'IDP055,IDP002,IDP010,IDP051';
            BEGIN -- *8
                SELECT FE_TRANS_DATA(p_i_v_eme_uid,'PACKING_GROUP',DECODE(IDP051.PACKAGE_GROUP_CODE,'I','1'
                                                        ,'II','2'
                                                        ,'III','3'))
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'HAZ_MAT_CODE',IDP051.IYIMCO)
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'HAZ_MAT_SUB_CLASS',IDP051.IYIMLB)
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'MFAG_PAGE',IDP051.IYMFCD)
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'EMS_PAGE',IDP051.IYEMNO)
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'MARINE_POLLUTANT',IDP051.MARINE_POLLUTANT)
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'LIMITED_QUANTITY',IDP051.LIMITED_QUANTITY)
                    ,FE_TRANS_DATA(p_i_v_eme_uid,'EXPLOSIVE_CONTENT',DECODE(NVL(IDP051.EXP_WEIGHT_POWDER,0)+NVL(IDP051.EXP_WEIGHT_GAS,0),0,'N','Y'))
                INTO
                    l_v_packing_group
                    ,l_v_haz_mat_code
                    ,l_v_haz_mat_sub_class
                    ,l_v_mfag_page
                    ,l_v_ems_page
                    ,l_v_marine_pollutant
                    ,l_v_limited_quantity
                    ,l_v_explosive_content
                FROM  IDP055 IDP055
                    , IDP002 IDP002
                    , IDP010 IDP010
                    , IDP051 IDP051
                WHERE IDP055.EYBLNO    = IDP002.TYBLNO
                AND   IDP055.EYBLNO    = IDP010.AYBLNO
                AND   IDP002.TYBLNO    = IDP010.AYBLNO
                AND   IDP055.EYBLNO    = IDP051.IYBLNO
                AND   IDP055.EYCMSQ    = IDP051.IYCMSQ
                AND   IDP010.AYSTAT    >=1
                AND   IDP010.AYSTAT    <=6
                AND   IDP010.PART_OF_BL IS NULL
                AND   IDP002.TYBKNO    = l_cur_detail.DL_FK_BOOKING_NO
                AND   IDP055.EYEQNO    = l_cur_detail.DL_DN_EQUIPMENT_NO
                AND   ROWNUM=1;
            /* * *8 start * */
            EXCEPTION
                WHEN OTHERS THEN
                    l_v_packing_group     := NULL;
                    l_v_haz_mat_code      := NULL;
                    l_v_haz_mat_sub_class := NULL;
                    l_v_mfag_page         := NULL;
                    l_v_ems_page          := NULL;
                    l_v_marine_pollutant  := NULL;
                    l_v_limited_quantity  := NULL;
                    l_v_explosive_content := NULL;
            END;
            /* * *8 end * */

/* commented by vikas
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
              -- g_v_err_code   := TO_CHAR (SQLCODE);
              -- g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               --l_v_sql_type := 'A';
               PRE_LOG_INFO
                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
               , l_v_obj_nm
               , g_v_sql_id
               , g_v_user
               , l_t_log_info
               , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
               , NULL
               , NULL
               , NULL
                );
               l_v_packing_group     := NULL;
               l_v_haz_mat_code      := NULL;
               l_v_haz_mat_sub_class := NULL;
               l_v_mfag_page         := NULL;
               l_v_ems_page          := NULL;
               l_v_marine_pollutant  := NULL;
               l_v_limited_quantity  := NULL;
               l_v_explosive_content := NULL;
       END;
 end commented by vikas  */

        g_v_sql_id := 'SQL-01037L';
        --INSERT RECORD INTO TABLE
        l_v_obj_nm := 'EDI_ST_DOC_HAZARD';
        IF ((l_cur_detail.T_DL_FK_IMDG IS NOT NULL) AND   -- *8
            (l_cur_detail.T_DL_FK_UNNO IS NOT NULL)) THEN -- *8

            INSERT INTO EDI_ST_DOC_HAZARD(
                EDI_ESDCO_UID
                ,EDI_ESDH_UID
                ,PACKING_GROUP
                ,HAZ_MAT_CODE
                ,HAZ_MAT_CLASS
                ,HAZ_MAT_SUB_CLASS
                ,UNDG_NUMBER
                ,MFAG_PAGE
                ,EMS_PAGE
                ,MARINE_POLLUTANT
                ,RESIDUE
                ,LIMITED_QUANTITY
                ,REPORT_QUANTITY
                ,FLASHPOINT
                ,TEMPERATURE_UOM
                ,EXPLOSIVE_CONTENT
                ,RECORD_STATUS
                ,RECORD_ADD_USER
                ,RECORD_ADD_DATE
                ,RECORD_CHANGE_USER
                ,RECORD_CHANGE_DATE
            )VALUES(
                l_n_edi_esdco_uid
                ,EDI_ESDH_SEQ.NEXTVAL
                ,SUBSTR(l_v_packing_group,1,3)
                -- ,l_v_haz_mat_code -- *8
                , l_cur_detail.DL_FK_PORT_CLASS -- *8
                ,l_cur_detail.T_DL_FK_IMDG
                ,l_v_haz_mat_sub_class
                ,SUBSTR(l_cur_detail.T_DL_FK_UNNO,1,4)
                ,l_v_mfag_page
                ,l_v_ems_page
                ,l_v_marine_pollutant
                ,l_cur_detail.T_DL_RESIDUE_ONLY_FLAG
                ,l_v_limited_quantity
                ,NULL
                ,l_cur_detail.T_DL_FLASH_POINT
                ,DECODE(NVL(l_cur_detail.T_DL_FLASH_UNIT,''),'C','CEL'
                                                            ,'F','FAH'
                                                            ,'')
                ,l_v_explosive_content
                ,'A'
                ,l_v_add_user
                ,SYSDATE
                ,NULL
                ,NULL
            );
        END IF; -- *8

--        PRE_LOG_INFO(
--            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , 'INSERT CALLED'
--            , NULL
--            , NULL
--            , NULL
--        );


/* vikas: modify start*/
EXCEPTION
          WHEN NO_DATA_FOUND THEN
              -- g_v_err_code   := TO_CHAR (SQLCODE);
              -- g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               --l_v_sql_type := 'A';
--               PRE_LOG_INFO
--                ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--               , l_v_obj_nm
--               , g_v_sql_id
--               , g_v_user
--               , l_t_log_info
--               , 'Exception occured while executing sql :: ' || g_v_err_code || '~'  || g_v_err_desc
--               , NULL
--               , NULL
--               , NULL
--                );
               l_v_packing_group     := NULL;
               l_v_haz_mat_code      := NULL;
               l_v_haz_mat_sub_class := NULL;
               l_v_mfag_page         := NULL;
               l_v_ems_page          := NULL;
               l_v_marine_pollutant  := NULL;
               l_v_limited_quantity  := NULL;
               l_v_explosive_content := NULL;
       END;
    /* vikas: modify end*/


    /* ******************* Start Added by vikas ******************* *
        BEGIN
            SELECT vvtrm1,
                vvpcal
            INTO v_previous_terminal,
                v_previous_port
            FROM itp063
            WHERE vvvoyn = p_i_v_voyage
            AND vvsrvc = p_i_v_service
            AND vvvess = p_i_v_vessel
            AND vvsdir = p_i_v_direction
            AND vvvers = 99
            AND vvrcst = 'A'
            AND vvpcsq =
                (SELECT MAX (vvpcsq)
                FROM itp063
                WHERE vvvoyn = p_i_v_voyage
                  AND vvsrvc = p_i_v_service
                  AND vvvess = p_i_v_vessel
                  AND vvsdir = p_i_v_direction
                  AND vvvers = 99
                  AND vvpcsq <
                     (SELECT MAX (vvpcsq)
                        FROM itp063
                       WHERE vvvoyn = p_i_v_voyage
                         AND vvsrvc = p_i_v_service
                         AND vvvess = p_i_v_vessel
                         AND vvsdir = p_i_v_direction
                         AND vvtrm1 = p_i_v_terminal
                         AND vvvers = 99
                         AND vvpcal = p_i_v_port));
            EXCEPTION
                WHEN OTHERS
                THEN
                   v_previous_terminal := NULL;
                   v_previous_port := NULL;
        END;  */

            PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                  p_i_v_eme_uid
                , l_n_edi_etd_seq
                , NULL
                , l_n_edi_esde_uid
                , p_i_v_port
                , p_i_v_terminal
                , '5'
                , l_n_edi_esdl_uid
            );



    /* *******************  End  Added by vikas ******************* */


            /* vikas: Start Populate data for EDI_ST_DOC_LOCATION*/
            BEGIN
                /* g_v_sql_id := 'SQL-01037a';
                --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-9';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                      p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , NULL
                    , l_n_edi_esde_uid
                    , l_cur_detail.BAPOL -- p_i_v_port
                    , NULL -- p_i_v_terminal
                    , '9'
                    , l_n_edi_esdl_uid
                );
*/

                /*
                    *7 Start
                *
                FOR l_cur_sec_voyage_data IN l_cur_sec_voyage (l_cur_detail.DL_FK_BOOKING_NO
                                                               , l_cur_detail.DL_FK_BKG_VOYAGE_ROUTING_DTL)
                LOOP
                    --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
                     l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-11';
                     PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                          p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_cur_sec_voyage_data.PORT
                        , l_cur_sec_voyage_data.TERMINAL
                        , '11'
                        , l_n_edi_esdl_uid
                    );
                END LOOP;
                /*
                    *7 end
                */

                /* Changes start by vikas, to populate loc-11 data for each equipment,
                    as k'chatgamol say, on 07.11.2011 */
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                      p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , NULL
                    , l_n_edi_esde_uid
                    , l_cur_detail.LL_DN_DISCHARGE_PORT
                    , l_cur_detail.LL_DN_DISCHARGE_TERMINAL
                    , '11'
                    , l_n_edi_esdl_uid
                );
                /* Changes end by vikas on 07.11.2011 */


                /* get place of delevery and place of receipient details */
                BEGIN
                    -- Bill of Lading not created, use the booking
                    SELECT BADSTN, BAORGN
                    INTO l_v_place_of_delivery, l_v_place_of_receipt
                    FROM BKP001 BK, BKP009 BKEQP
                    WHERE BKEQP.BIBKNO = l_cur_detail.DL_FK_BOOKING_NO
                    AND   BKEQP.BICTRN = l_cur_detail.DL_DN_EQUIPMENT_NO
                    AND   BKEQP.BIBKNO = BK.BABKNO;
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END;

                --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-88';
                IF l_v_place_of_receipt IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                          p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_v_place_of_receipt
                        , NULL
                        , '88'
                        , l_n_edi_esdl_uid
                    );
                END IF;

                --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-7';
                IF l_v_place_of_delivery IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                          p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_v_place_of_delivery
                        , NULL
                        , '7'
                        , l_n_edi_esdl_uid
                    );
                END IF;
/*  commented by vikas  because 170 and 13 can not be save at same time.
                -- IF p_i_v_port = l_cur_detail.DL_DN_FINAL_POD THEN change by vikas verma as per PKG_EDI_TOS_OUT
                IF p_i_v_port IS NOT NULL THEN /* added by vikas *
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                        p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , p_i_v_port
                        , NULL
                        , '13'
                        , l_n_edi_esdl_uid
                    );
                END IF;
*/

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
                    'BP'
                    ,'LOC83' ||'~' || l_cur_detail.DL_FK_BOOKING_NO||'~' || l_cur_detail.DL_DN_EQUIPMENT_NO
                    ||'~' || l_cur_detail.DL_MLO_DEL||'~' ||  l_cur_detail.DL_MLO_POD1
                    ||'~' || l_cur_detail.DL_FINAL_DEST
                    ,'A'
                    ,'EDI'
                    ,SYSDATE
                    ,'EDI'
                    ,SYSDATE

                );
*/
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT-83';
                -- IF ((l_cur_detail.DL_MLO_DEL IS NOT NULL) -- *4
                --     AND (l_cur_detail.DL_MLO_POD1 IS NOT NULL) ) THEN -- *4

                IF l_cur_detail.DL_MLO_DEL IS NOT NULL THEN -- *4
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                        p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_cur_detail.DL_MLO_DEL
                        , NULL
                        , '83'
                        , l_n_edi_esdl_uid
                    );
                /* *9 start * */
                ELSIF l_cur_detail.DL_MLO_POD3 IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                        p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_cur_detail.DL_MLO_POD3
                        , NULL
                        , '83'
                        , l_n_edi_esdl_uid
                    );
                ELSIF l_cur_detail.DL_MLO_POD2 IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                        p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_cur_detail.DL_MLO_POD2
                        , NULL
                        , '83'
                        , l_n_edi_esdl_uid
                    );
                ELSIF l_cur_detail.DL_MLO_POD1 IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                        p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_cur_detail.DL_MLO_POD1
                        , NULL
                        , '83'
                        , l_n_edi_esdl_uid
                    );
                /* *9 end * */
                ELSIF l_cur_detail.DL_FINAL_DEST IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                        p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_cur_detail.DL_FINAL_DEST  /* final destination (place of delevery) */
                        , NULL
                        , '83'
                        , l_n_edi_esdl_uid
                    );
                END IF;

                /* start commented by vikas as, 09.11.2011 *
                IF l_cur_detail.DL_FINAL_DEST IS NOT NULL THEN
                    PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                        p_i_v_eme_uid
                        , l_n_edi_etd_seq
                        , NULL
                        , l_n_edi_esde_uid
                        , l_cur_detail.DL_FINAL_DEST  /* final destination (place of delevery) *
                        , NULL
                        , '83'
                        , l_n_edi_esdl_uid
                    );
                END IF;
                * end commented by vikas as, 09.11.2011 */

                -- Populate data for EDI_ST_DOC_LOCATION (Original Port of Loading)

                --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                    p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , NULL
                    , l_n_edi_esde_uid
                    , l_cur_detail.BAPOL
                    , NULL
                    , '76'
                    , l_n_edi_esdl_uid
                );


                -- Populate data for EDI_ST_DOC_LOCATION (Final Port of Discharge)

                --EXECUTE PROCEDURE WITH PARAMETERS TO POPULATE EDI_ST_DOC_LOCATION
                l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PORT';
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                    p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , NULL
                    , l_n_edi_esde_uid
                    , l_cur_detail.BAPOD
                    , NULL
                    , '65'
                    , l_n_edi_esdl_uid
                );

--                l_arr_var_name := STRING_ARRAY
--                    ('p_eme_uid'           , 'p_edi_etd_uid'       , 'p_edi_esdj_uid'
--                    , 'p_edi_esde_uid'      , 'p_port'              , 'p_place_of_receipt'
--                    , 'p_port_qualifer'     , 'p_edi_esdl_uid'
--                    );
--
--                l_arr_var_value := STRING_ARRAY
--                    (p_i_v_eme_uid                , l_n_edi_etd_seq     , NULL
--                    , NULL                         , p_i_v_port          , l_v_place_of_receipt
--                    , '88'                         , l_n_edi_esdl_uid
--                    );
--
--                l_arr_var_io := STRING_ARRAY
--                    ('I'      , 'I'      , 'I'
--                    , 'I'      , 'I'      , 'I'
--                    , 'I'      , 'O'
--                    );
--
--                PRE_LOG_INFO(
--                    'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                    , l_v_obj_nm
--                    , g_v_sql_id
--                    , g_v_user
--                    , l_t_log_info
--                    , NULL
--                    , l_arr_var_name
--                    , l_arr_var_value
--                    , l_arr_var_io
--                );

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('No data found for g_v_sql_id :: ' || g_v_sql_id || ' , Ignore Error and Continue...');
                    p_o_v_err_cd := SQLCODE || '~' || SQLERRM;
                    l_b_raise_exp := TRUE;
--                    PRE_LOG_INFO(
--                        'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--                        , l_v_obj_nm
--                        , g_v_sql_id
--                        , g_v_user
--                        , l_t_log_info
--                        , 'Exception occured while executing sql :: ' || p_o_v_err_cd
--                        , NULL
--                        , NULL
--                        , NULL
--                    );
            END; -- end to populate populate edi_st_doc_location;

            /* ***** start added by vikas for Create on-carriage details for transhipments ***** */
            /* Changes start by vikas, as per suggest by k'chatgamol, 09.11.2011 */
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
                'BP'
                ,'POD' ||'~' || l_cur_detail.DL_DN_NXT_POD2||'~' ||p_i_v_port||'~' ||l_cur_detail.DL_DN_FINAL_POD
                ,'A'
                ,'EDI'
                ,SYSDATE
                ,'EDI'
                ,SYSDATE

            );
            -- commit;
*/
            /* Start Modified by vikas, 28.11.2011 */
            -- IF(l_cur_detail.DL_DN_NXT_POD2 IS NOT NULL) THEN
            IF(l_cur_detail.DL_DN_NXT_POD1 IS NOT NULL) THEN

                IF p_i_v_port = l_cur_detail.DL_DN_FINAL_POD THEN
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
                    'BP'
                    ,'POD If' ||'~' || l_cur_detail.DL_DN_NXT_POD2||'~' ||p_i_v_port||'~' ||l_cur_detail.DL_DN_FINAL_POD
                    ,'A'
                    ,'EDI'
                    ,SYSDATE
                    ,'EDI'
                    ,SYSDATE

                );
                --commit;
  */
                PKG_EDI_DOCUMENT.PRC_CREATE_PORT(
                    p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , NULL
                    , l_n_edi_esde_uid
                    , l_cur_detail.DL_POD    --  DL_DN_NXT_POD1, 28.11.2011
                    , NULL                   -- p_i_v_terminal
                    , l_v_location_type
                    , l_n_edi_esdl_uid
                );
                /* End Modified by vikas, 28.11.2011 */
            END IF;

            /* Changes end by vikas, 09.11.2011 */

        /* ******  added by vikas for testing ********** */
        l_arr_var_value := STRING_ARRAY(
            p_i_v_eme_uid, l_n_edi_etd_seq, l_cur_detail.DL_DN_FINAL_POD
            , l_n_edi_esde_uid, p_i_v_port, p_i_v_terminal
            , l_v_location_type, l_n_edi_esdl_uid, l_cur_detail.DL_FINAL_DEST
        );

--        l_arr_var_name := STRING_ARRAY(
--            'p_i_v_eme_uid', 'l_n_edi_etd_seq', 'l_cur_detail.DL_DN_FINAL_POD'
--            , 'l_n_edi_esde_uid', 'p_i_v_port', 'p_i_v_terminal'
--            , 'l_v_location_type', 'l_n_edi_esdl_uid', 'l_cur_detail.DL_FINAL_DEST'
--        );
--
--        l_arr_var_io := STRING_ARRAY(
--              'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--            , 'I'      , 'I'      , 'I'
--        );
--
--        g_v_sql_id := 'SQL-010a-1';
--        l_v_obj_nm := 'PARAMETER FOR CREATE PORT ';
--        PRE_LOG_INFO(
--            'PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , NULL
--            , l_arr_var_name
--            , l_arr_var_value
--            , l_arr_var_io
--        );

/* ***** end added by vikas for Create on-carriage details for transhipments ***** */

            /* vikas: Start processing of create voyage details            */
            g_v_sql_id := 'SQL-01037M';
            FOR l_cur_prev_voyage_data IN l_cur_prev_voyage (l_cur_detail.DL_FK_BOOKING_NO
                , l_cur_detail.DL_FK_BKG_VOYAGE_ROUTING_DTL)
            LOOP
                /* l_v_location_type := '76'; */

                PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE(
                    p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , l_cur_prev_voyage_data.VOYNO
                    , l_cur_prev_voyage_data.SERVICE
                    , l_cur_prev_voyage_data.VESSEL
                    , l_cur_prev_voyage_data.DIRECTION
                    , l_cur_prev_voyage_data.PORT
                    , 10
                    , NULL     /* activity code */
                    , l_n_edi_esde_uid--EDI_ESDE_UID is null   --aks 21july
                    , l_cur_prev_voyage_data.TERMINAL
                    , l_n_edi_esdj_uid
                );

                /* for qualifier 30 */
                PKG_EDI_DOCUMENT.PRC_CREATE_VOYAGE(
                    p_i_v_eme_uid
                    , l_n_edi_etd_seq
                    , l_cur_prev_voyage_data.VOYNO
                    , l_cur_prev_voyage_data.SERVICE
                    , l_cur_prev_voyage_data.VESSEL
                    , l_cur_prev_voyage_data.DIRECTION
                    , l_cur_prev_voyage_data.PORT
                    , 30
                    , NULL     /* activity code */
                    , l_n_edi_esde_uid--EDI_ESDE_UID is null   --aks 21july
                    , l_cur_prev_voyage_data.TERMINAL
                    , l_n_edi_esdj_uid
                );
            END LOOP;
            /* vikas: End start processing of create voyage details        */

              g_v_sql_id := 'SQL-01038';
              --UPDATE TABLE
             l_v_obj_nm := 'EDI_DOCUMENT_LOG';
             UPDATE EDI_DOCUMENT_LOG
             SET    STATUS = 'S',                  -- vikas 27 july
               EDI_ETD_UID = l_n_edi_etd_seq,
               RECORD_PROCESSED_DATE = SYSDATE
             WHERE  MSG_REFERENCE          = l_n_msg_ref_seq
             AND    SERVICE                = l_cur_detail.DL_SERVICE
             AND    VESSEL_CODE            = l_cur_detail.DL_VESSEL
             AND    VOYAGE_NUMBER          = l_cur_detail.DL_VOYAGE
             AND    DIRECTION              = l_cur_detail.DL_DIRECTION
             AND    BOOKING_NUMBER         = l_cur_detail.DL_FK_BOOKING_NO
             AND    EQUIPMENT_NO           = l_cur_detail.DL_DN_EQUIPMENT_NO
             AND    EME_UID                = p_i_v_eme_uid;

/***********/
--            l_arr_var_name := STRING_ARRAY
--           ('l_n_msg_ref_seq'      , 'DL_SERVICE'        , 'DL_VESSEL'
--          , 'DL_VOYAGE'            , 'DL_DIRECTION'      , 'DL_FK_BOOKING_NO'
--          , 'DL_DN_EQUIPMENT_NO'   , 'p_i_v_eme_uid'
--            );
--
--            l_arr_var_value := STRING_ARRAY
--           (l_n_msg_ref_seq                        , l_cur_detail.DL_SERVICE          , l_cur_detail.DL_VESSEL
--          ,l_cur_detail.DL_VOYAGE                  , l_cur_detail.DL_DIRECTION        , l_cur_detail.DL_FK_BOOKING_NO
--          , l_cur_detail.DL_DN_EQUIPMENT_NO        , p_i_v_eme_uid
--            );
--
--            l_arr_var_io := STRING_ARRAY
--           ('I'      , 'I'      , 'I'
--          , 'I'      , 'I'      , 'I'
--          , 'I'      , 'I'
--            );
--
--/************/
--
--             PRE_LOG_INFO
--            ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--            , l_v_obj_nm
--            , g_v_sql_id
--            , g_v_user
--            , l_t_log_info
--            , 'UPDATE CALLED'
--            , l_arr_var_name
--          , l_arr_var_value
--          , l_arr_var_io
--             );


            /* vikas: Start added for add party in EDI_ST_DOC_PARTY */
                FOR l_cur_idp030_data IN l_cur_idp030(l_v_bill_of_landing, 'C')
                LOOP
                    IF l_cur_idp030_data.CYCUST =
                        pkg_edi_transaction.checkforouttrans
                                                           (p_i_v_eme_uid,
                                                            'PARTY_CODE',
                                                            l_cur_idp030_data.CYCUST
                                                           )
                    THEN
                        BEGIN
                            SELECT COUNT (1)
                              INTO l_n_count_alias
                              FROM EDI_MESSAGE_TRANSLATION EMT,
                                   EDI_TRANSLATION_HEADER ETH
                             WHERE EMT.EME_UID = p_i_v_eme_uid
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

                    -- Insert Booking Parties
                    l_v_obj_nm := 'PKG_EDI_DOCUMENT.PRC_CREATE_PARTY';
                    PKG_EDI_DOCUMENT.PRC_CREATE_PARTY
                                     (p_i_v_eme_uid
                                    , l_n_edi_etd_seq
                                    , PKG_EDI_TRANSACTION.CHECKFOROUTTRANS(p_i_v_eme_uid,
                                                                           'PARTY_TYPE',
                                                                           'CN'
                                                                          )
                                    , PKG_EDI_TRANSACTION.CHECKFOROUTTRANS(p_i_v_eme_uid,
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
                                    , l_n_edi_esde_uid
                                    , l_n_edi_esdp_uid
                                      );

                     -- Contact info for Booking Parties
                     PKG_EDI_DOCUMENT.PRC_INSERT_CONTACT (l_n_edi_etd_seq,
                                                       l_n_edi_esdp_uid,
                                                       NULL,
                                                       'IC',
                                                       l_cur_idp030_data.CYNAME,
                                                       NULL,
                                                       'EDI',
                                                       l_n_edi_esdcn_uid
                                                      );
                      IF l_cur_idp030_data.CYTELN IS NOT NULL
                      THEN
                         PKG_EDI_DOCUMENT.PRC_INSERT_COMM (l_n_edi_esdcn_uid,
                                                           'TE',
                                                           l_cur_idp030_data.CYTELN,
                                                           'EDI'
                                                          );
                      END IF;

                      IF l_cur_idp030_data.CYFAXN IS NOT NULL
                      THEN
                         pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_uid,
                                                           'FX',
                                                           l_cur_idp030_data.CYFAXN,
                                                           'EDI'
                                                          );
                      END IF;

                      IF l_cur_idp030_data.EMAIL_ID IS NOT NULL
                      THEN
                         pkg_edi_document.prc_insert_comm (l_n_edi_esdcn_uid,
                                                           'EM',
                                                           l_cur_idp030_data.EMAIL_ID,
                                                           'EDI'
                                                          );
                      END IF;

                END LOOP;--end loop of l_cur_idp030

            /* vikas: End added for add party in EDI_ST_DOC_PARTY */

            END IF; --*15

        END LOOP;--end of loop main loop


        /* *10 start * */

        /* * update container count in EDI_ST_DOC_HEADER table. * */
        IF l_n_cnt IS NOT NULL
            AND l_n_cnt <> 0 THEN

            UPDATE
                EDI_ST_DOC_HEADER
            SET
                TOTAL_EQUIPMENT = l_n_cnt
            WHERE
                EDI_ETD_UID = l_n_edi_etd_seq;
        END IF;
        /* *10 end * */

       g_v_sql_id := 'SQL-01039';
       --UPDATE TABLE
       l_v_obj_nm := 'EDI_TRANSACTION_HEADER';
       UPDATE EDI_TRANSACTION_HEADER
       SET    STATUS  = 'R'
       WHERE  MSG_REFERENCE = l_v_msg_ref;

--       PRE_LOG_INFO
--        ('PCE_TOS_BAYPLAN.PRE_TOS_CREATE_BAYPLAN'
--       , l_v_obj_nm
--       , g_v_sql_id
--       , g_v_user
--       , l_t_log_info
--       , 'UPDATE CALLED'
--       , NULL
--       , NULL
--       , NULL
--        );

    IF l_b_raise_exp = TRUE THEN
       RAISE l_e_no_data_found;
    END IF;

    EXCEPTION
       WHEN l_e_no_data_found THEN
            ROLLBACK;
            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG( l_v_parameter_str
                                ,'BP'
                                ,l_v_sql_type
                                , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                                ,'A'
                                ,g_v_user
                                ,CURRENT_TIMESTAMP
                                ,g_v_user
                                ,CURRENT_TIMESTAMP
                               );
            COMMIT;

            p_o_v_err_cd:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

       WHEN OTHERS THEN
          g_v_err_code   := NVL(g_v_err_code,TO_CHAR (SQLCODE));
          g_v_err_desc   := SUBSTR(NVL(g_v_err_desc,SQLERRM),1,100);
          ROLLBACK;
          PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG( l_v_parameter_str
                                 ,'BP'
                                 ,l_v_sql_type
                                 , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                                 ,'A'
                                 ,g_v_user
                                 ,CURRENT_TIMESTAMP
                                 ,g_v_user
                                 ,CURRENT_TIMESTAMP
                                );
          COMMIT;

         --  p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
          p_o_v_err_cd := 'Error Occured during EDI generation.';  -- added by vikas, to show error message on screen, 20.10.2011

          RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END PRE_TOS_CREATE_BAYPLAN;

    PROCEDURE PRV_EDL_GET_NEXT_PORT_VAL(
        p_i_v_voyage                  IN          VARCHAR2
      , p_i_v_vessel                  IN          VARCHAR2
      , p_i_v_seq                     IN          VARCHAR2
      , p_i_v_etd                     IN          VARCHAR2
      , p_o_v_service                 OUT         VARCHAR2
      , p_o_v_vessel                  OUT         VARCHAR2
      , p_o_v_etd                     OUT         VARCHAR2
      , p_o_v_port                    OUT         VARCHAR2
      , p_o_v_voyage_no               OUT         VARCHAR2
      , p_o_v_port_seq                OUT         VARCHAR2
      , p_o_v_terminal                OUT         VARCHAR2
      , p_o_v_err_cd                  OUT         VARCHAR2
    ) AS
    BEGIN
       p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

       SELECT TO_CHAR(TO_DATE(p_i_v_etd,'DD/MM/YYYY HH24:MI'),'YYYYMMDDHHMI')
       INTO   p_o_v_etd
       FROM   DUAL;

       SELECT SERVICE,
              VESSEL,
              ETD,
              PORT,
              VOYAGE_NO,
              PORT_SEQ,
              TERMINAL
       INTO   p_o_v_service,
              p_o_v_vessel,
              p_o_v_etd,
              p_o_v_port,
              p_o_v_voyage_no,
              p_o_v_port_seq,
              p_o_v_terminal
       FROM
          (
           SELECT SERVICE,
                  VVVESS VESSEL,
                  ETD,
                  VVPCAL PORT,
                  VVVOYN VOYAGE_NO,
                  VVPCSQ PORT_SEQ,
                  VVTRM1 TERMINAL
           FROM
              (
                SELECT VVSRVC SERVICE,
                    VVVESS              ,
                    TO_CHAR(TO_DATE(VVSLDT,'YYYYMMDD'),'YYYY/MM/DD')
                    ||TO_CHAR(VVSLTM,'0000') ETD,
                    VVPCAL                      ,
                    VVVOYN                      ,
                    VVPCSQ                      ,
                    VVTRM1                      ,
                    VVSLDT
                    ||TRIM(TO_CHAR(VVSLTM,'0000')) ODR_BY_COL,
                    VVVERS
                FROM ITP063
                WHERE VOYAGE_ID =
                    (SELECT VOYAGE_ID
                     FROM ITP063
                    WHERE VVVOYN      = p_i_v_voyage
                        AND VVVESS          =p_i_v_vessel
                        AND VVPCSQ          = p_i_v_seq
                        AND VVFORL         IS NOT NULL
                        AND OMMISSION_FLAG IS NULL
                        AND VVVERS          = '99'
                    )
                AND VVVESS = p_i_v_vessel
                AND VVPCSQ =
                    (SELECT MIN(VVPCSQ)
                     FROM ITP063
                    WHERE VOYAGE_ID =
                        (SELECT VOYAGE_ID
                           FROM ITP063
                          WHERE VVVOYN      = p_i_v_voyage
                            AND VVVESS          =p_i_v_vessel
                            AND VVPCSQ          = p_i_v_seq
                            AND VVFORL         IS NOT NULL
                            AND OMMISSION_FLAG IS NULL
                            AND VVVERS          = '99'
                        )
                    AND VVVESS          = p_i_v_vessel
                    AND VVPCSQ          > p_i_v_seq
                    AND OMMISSION_FLAG IS NULL
                    AND VVVERS          = '99'
                    )
                AND VVVERS = '99'
                ORDER BY VVARDT
              )
          )
      WHERE ROWNUM='1';

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_err_cd:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
      WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));


    END PRV_EDL_GET_NEXT_PORT_VAL;

    PROCEDURE PRV_EDL_GET_MSG_RCPNT_SET_VAL(
        p_i_v_terminal                 IN          VARCHAR2
      , p_o_v_msg_recp                 OUT         VARCHAR2
      , p_o_v_msg_set                  OUT         VARCHAR2
      , p_o_v_eme_uid                  OUT         VARCHAR2
      , p_o_v_err_cd                   OUT         VARCHAR2
    ) AS
    l_v_module                  VARCHAR2(7) := 'EZLL';
    BEGIN
       p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

       SELECT DECODE(ROWCOUNT,1,RECEIVER_ID,'') RECEIVER_ID,
              DECODE(ROWCOUNT,1,MESSAGE_CODE,'') MESSAGE_CODE,
              DECODE(ROWCOUNT,1,EME_UID,'') EME_UID
       INTO   p_o_v_msg_recp,
             p_o_v_msg_set,
             p_o_v_eme_uid
        FROM
            (SELECT COUNT(1) OVER() ROWCOUNT ,
                      ROWNUM SL_NO,
                      EPH.TRADING_PARTNER RECEIVER_ID,
                        EMS.MESSAGE_CODE MESSAGE_CODE,
                        EME.EME_UID EME_UID
               FROM   EDI_MESSAGE_EXCHANGE EME,
                      EDI_MESSAGE_SET EMS,
                      EDI_PARTNER_HEADER EPH,
                      EDI_API_HEADER EAH,
                      ITP025 ITP,
                      EDI_PARTNER_LOCATION EPL,
                      ITP130 TERM
               WHERE  EME.EMS_UID         = EMS.EMS_UID
               AND    EME.ETP_UID         = EPH.ETP_UID
               AND    EME.API_UID         = EAH.API_UID
               AND    EPH.TRADING_PARTNER = ITP.VCVNCD
               AND    EPH.ETP_UID         = EPL.ETP_UID
               AND    EPL.LOCATION_CODE   = TERM.TQTERM
               AND    EME.DIRECTION       = 'OUT'
               AND    EME.MODULE          = l_v_module
               AND    EME.RECORD_STATUS   = 'A'
               AND    EPL.LOCATION_CODE   = p_i_v_terminal
               AND    EPL.RECORD_STATUS   = 'A'
               AND    EMS.RECORD_STATUS   = 'A'
               AND    EPH.RECORD_STATUS   = 'A'
               AND    EAH.RECORD_STATUS   = 'A'
              )
      WHERE SL_NO=1;

    EXCEPTION

      WHEN NO_DATA_FOUND THEN
             NULL;
            --p_o_v_err_cd:= PCE_EUT_COMMON.G_V_GE0004;
            --RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
      WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));

    END PRV_EDL_GET_MSG_RCPNT_SET_VAL;

    PROCEDURE PRE_EDL_BAYPLANREPORT(
          p_o_refCreateArrivalBayPlan   OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_port                    IN           VARCHAR2
        , p_i_v_service                 IN           VARCHAR2
        , p_i_v_vessel                  IN           VARCHAR2
        , p_i_v_terminal                IN           VARCHAR2
        , p_i_v_voyage                  IN           VARCHAR2
        , p_i_v_direction               IN           VARCHAR2
        , p_i_dt_dl_eta                 IN           VARCHAR2
        , p_i_dt_ll_etd                 IN           VARCHAR2
        , p_i_v_rob                     IN           VARCHAR2
        , p_i_v_cont_op_flag            IN           VARCHAR2
        , p_i_v_slot_op_flag            IN           VARCHAR2
        , p_i_v_cont_op                 IN           VARCHAR2
        , p_i_v_slot_op                 IN           VARCHAR2
        , p_i_v_ll_dl_flag              IN           VARCHAR2  -- *1
        , p_o_v_err_cd                  OUT NOCOPY   VARCHAR2
    )  AS


    l_dt_bayplan                DATE;
    l_v_rob                        VARCHAR2(1);

BEGIN

    IF p_i_dt_dl_eta IS NULL THEN
          l_dt_bayplan := TRUNC(TO_DATE(p_i_dt_ll_etd,'DD/MM/YYYY HH24:MI'));
    ELSE
          l_dt_bayplan := TRUNC(TO_DATE(p_i_dt_dl_eta,'DD/MM/YYYY HH24:MI'));
    END IF;

    IF p_i_v_rob = 'on' THEN
        l_v_rob := 'Y';
    ELSE
        l_v_rob := 'N';
    END IF;

    OPEN p_o_refCreateArrivalBayPlan FOR
        SELECT A.dl_service SERVICE,
               A.DL_VESSEL VESSEL,
               A.DL_VOYAGE VOYAGE,
               A.DL_DIRECTION DIRECTION,
               A.DL_FK_BOOKING_NO BOOKING_NO,
               A.LL_POL POL,
               A.DL_POD POD,
               A.DL_DN_EQUIPMENT_NO EQUIP_NO,
               A.DL_DN_EQ_SIZE EQUIP_SIZE,
               A.DL_DN_EQ_TYPE EQUIP_TYPE,
               A.DL_CONTAINER_GROSS_WEIGHT GROSS_WT,
               'KGS' GROSS_WT_UOM,
               A.DL_OVERLENGTH_FRONT_CM OVERLENGTH_FRONT,
               A.DL_OVERLENGTH_REAR_CM OVERLENGTH_BACK,
               A.DL_OVERHEIGHT_CM OVERHEIGHT,
               A.DL_OVERWIDTH_LEFT_CM OVERWIDTH_LEFT,
               A.DL_OVERWIDTH_RIGHT_CM OVERWIDTH_RIGHT,
               A.DL_REEFER_TEMPERATURE TEMPERATURE,
               A.DL_REEFER_TMP_UNIT TEMP_UOM,
               A.DL_DN_HUMIDITY HUMIDITY,
               B.BWDANG HAZADOUS_FLAG,
               A.DL_FK_UNNO UNNO,
               A.DL_FK_IMDG IMDG,
               A.DL_FK_PORT_CLASS PORT_CLASS,
               B.BWPKND PACKAGE_TYPE,
               B.BWCMCD  COMMODITY_CD,
               B.COMM_DESC DESCRIPTION,
               B.BWMTWT COMM_GROSS_WT,
               B.BWMTMS COMM_GROSS_WT_UOM,
               A.LL_STOWAGE_POSITION STOWAGE_POSITION
        FROM V_TOS_ONBOARD_CONTAINER A
           , BKP050 B
           , BKP009 B9 --Added by Bindu on 08/06/2011
           , ITP075 IP --Added by Bindu on 08/06/2011
        WHERE A.DL_FK_BOOKING_NO   = B.BWBKNO
        --Added by Bindu on 08/06/2011 start.
        AND   B.BWBKNO             = B9.BIBKNO
        AND   A.DL_DN_EQUIPMENT_NO = B9.BICTRN
        AND   IP.TRTYPE            = B9.BICNTP
        AND   ((IP.TRREFR = 'Y' AND B.SPECIAL_HANDLING = NVL((SELECT B5.SPECIAL_HANDLING FROM BKP050 B5
                                                         WHERE B5.BWBKNO= B9.BIBKNO AND B5.SPECIAL_HANDLING = 'RF' and rownum =1), B9.SPECIAL_HANDLING))--*18 
              OR (IP.TRREFR <> 'Y' and B.SPECIAL_HANDLING = B9.SPECIAL_HANDLING))
        --Added by Bindu on 08/06/2011 end.
        -- AND   A.dl_service     = p_i_v_service -- *12
        AND   A.LL_VESSEL      = p_i_v_vessel
        --AND   A.DL_VOYAGE      = p_i_v_voyage
        --AND   A.DL_DIRECTION   = p_i_v_direction
        --AND   A.DL_POD         = p_i_v_port
        --AND   A.DL_DN_TERMINAL = p_i_v_terminal
        AND   l_dt_bayplan BETWEEN LL_ETD AND DL_ETA
--         AND   (l_v_rob = 'Y' OR (DL_DISCHARGE_STATUS NOT IN ('RB') AND LL_LOADING_STATUS NOT IN ('RB'))) -- *5
        AND    ( -- *1
                (p_i_v_ll_dl_flag = 'L' AND A.DL_POD <> p_i_v_port) -- *1
                OR -- *1
                (p_i_v_ll_dl_flag = 'D' AND A.LL_POL <> p_i_v_port)-- *1
            ) -- *1
        AND ( -- *5
                (l_v_rob = 'Y')  -- *5
                OR  -- *5
                (  -- *5
                    (l_v_rob = 'N')  -- *5
                    AND  -- *5
                    ( -- *5
                        (p_i_v_ll_dl_flag = 'L' AND A.LL_POL = p_i_v_port)  -- *5
                        OR  -- *5
                        (p_i_v_ll_dl_flag = 'D' AND A.DL_POD = p_i_v_port)  -- *5
                    )  -- *5
                )  -- *5
            ) -- *5

        /* start added by vikas */
        AND ( (p_i_v_cont_op_flag  = 'E' AND INSTR(p_i_v_cont_op,DL_FK_CONTAINER_OPERATOR )=0)
            OR (p_i_v_cont_op_flag   = 'I' AND  INSTR(p_i_v_cont_op,DL_FK_CONTAINER_OPERATOR )>0)
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND ( (p_i_v_slot_op_flag  = 'E' AND INSTR(p_i_v_slot_op,DL_FK_SLOT_OPERATOR )=0)
            OR  (p_i_v_slot_op_flag   = 'I' AND  INSTR(p_i_v_slot_op,DL_FK_SLOT_OPERATOR )>0)
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) )
        AND EXISTS(  --*6 START
            SELECT 1
            FROM
                (SELECT BOOKING_NO
                FROM BOOKING_VOYAGE_ROUTING_DTL
                WHERE
                    VESSEL        = p_i_v_vessel
                    --AND SERVICE       = p_i_v_service -- *12
                -- AND VOYNO           = p_i_v_voyage
                AND DISCHARGE_PORT <> p_i_v_port
                AND POL_PCSQ        < NVL(
                    (SELECT MIN(VVPCSQ)
                    FROM ITP063
                    WHERE VVVERS  =99
                    AND VVVESS    = VESSEL
                    AND VOYAGE_ID =
                    (SELECT VOYAGE_ID
                    FROM ITP063
                    WHERE VVVERS        =99
                    AND VVVESS          = VESSEL
                    AND VVVOYN          = VOYNO
                    AND OMMISSION_FLAG IS NULL
                    AND VVPCAL          = LOAD_PORT
                    AND ROWNUM          = 1
                    )
                    AND VVPCAL          = p_i_v_port
                    AND VVPCSQ          >POL_PCSQ
                    AND OMMISSION_FLAG IS NULL
                    ),0)
                AND POD_PCSQ > NVL(
                    (SELECT MIN(VVPCSQ)
                    FROM ITP063
                    WHERE VVVERS  =99
                    AND VVVESS    = VESSEL
                    AND VOYAGE_ID =
                    (SELECT VOYAGE_ID
                    FROM ITP063
                    WHERE VVVERS        =99
                    AND VVVESS          = VESSEL
                    AND VVVOYN          = VOYNO
                    AND OMMISSION_FLAG IS NULL
                    AND VVPCAL          = LOAD_PORT
                    AND ROWNUM          = 1
                    )
                    AND VVPCAL          = p_i_v_port
                    AND VVPCSQ          >POL_PCSQ
                    AND OMMISSION_FLAG IS NULL
                    ),0)
                UNION
                SELECT BOOKING_NO
                FROM BOOKING_VOYAGE_ROUTING_DTL
                WHERE VESSEL  = p_i_v_vessel
                -- AND VOYNO     = p_i_v_voyage
                -- AND SERVICE       = p_i_v_service -- *12
                AND LOAD_PORT = p_i_v_port
                UNION
                SELECT BOOKING_NO
                FROM BOOKING_VOYAGE_ROUTING_DTL
                WHERE VESSEL       = p_i_v_vessel
                -- AND SERVICE       =  p_i_v_service -- *12
                -- AND VOYNO          = p_i_v_voyage
                AND DISCHARGE_PORT = p_i_v_port
            )
            WHERE
            BOOKING_NO = DL_FK_BOOKING_NO ); --*6 END

        /* end added by vikas */
      /* commented by vikas logic is not working correctly

        AND   ( (p_i_v_cont_op_flag  = 'E' AND DL_FK_CONTAINER_OPERATOR NOT IN (p_i_v_cont_op))
            OR (p_i_v_cont_op_flag   = 'I' AND DL_FK_CONTAINER_OPERATOR IN (p_i_v_cont_op))
            OR (NVL(p_i_v_cont_op_flag,'~') IN ('~')) )
        AND   ( (p_i_v_slot_op_flag  = 'E' AND DL_FK_SLOT_OPERATOR NOT IN (p_i_v_slot_op))
            OR (p_i_v_slot_op_flag   = 'I' AND DL_FK_SLOT_OPERATOR IN (p_i_v_slot_op))
            OR (NVL(p_i_v_slot_op_flag,'~') IN ('~')) );
*/

EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_err_cd:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
      WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
END PRE_EDL_BAYPLANREPORT;

END PCE_TOS_BAYPLAN;

/