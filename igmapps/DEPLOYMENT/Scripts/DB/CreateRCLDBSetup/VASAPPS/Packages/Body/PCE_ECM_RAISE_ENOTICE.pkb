create or replace
PACKAGE BODY PCE_ECM_RAISE_ENOTICE AS

    /* *1:  modified by vikas, send alert to current fsc also, as k'chatgamol, 10/12/2012 * */
    /* *2:  modified by vikas, exception handling, as k'chatgamol, 28/12/201 * */
    /* *3:  Added by vikas, new enotice type for BL-SURRENDER, as k'chatgamol, 11.01.2013 * */
    /* *4:  Modified by vikas, While getting POD the routing type should be 'S'
            in BL SURRENDER, as k'myo, 28.01.2013 * */
    /* *5:  modified by leena, changed  the size of voyage variable from 10 to 50,
            commented exception raised due to pod not found, as its a valid business scenario,
            ,while finding first leg check for routing type 'S' as k'myo, 05/02/2013 * */
    /* *6:  modified by leena, removed the mapping with itp060 as k'myo, 05/02/2013 * */
    /* *7:  modified by watcharee, to insert in e_notice for 3rd location, 06/02/2013 * */
    /* *8:  modified by leena, bl surrender,commented exceptions to avoid mail from stop sending k'myo, 07/02/2013 * */
    /* *9:  Added by vikas, send enotice to every port of the booking, as k'chatgamol, 23.01.2013 * */
    /* *11: Added by vikas, to fix duplcate mail issue poupulate originating FSC as xyz
            so that system will not send mail for originating FSC. as k'myo, 26.02.2013 */
    /* *12: Modified by vikas, while getting FREIGHT PAYMENT value then if multiple records found
            then pick only record having value FREIGHT, as k'myo, 26.02.2012 */
    /* *13: Added by vikas, to improve error logging, as k'myo, 04.03.2013 */

PROCEDURE PRE_GET_ENOTICE_VARIABLES (
      p_i_v_notice_type_id                  VARCHAR2
    , p_tab_enotice_variables    OUT        ENOTICE_VARIABLES_TAB
)
IS
    l_n_curr_tab_index        NUMBER := 0;

    CURSOR l_cur_enotice_variable IS
        SELECT    VARIABLE_DESC
                , MULTIPLE_VALUES_FLAG
                , MAP_CODE
        FROM    ZND_E_NOTICE_VARIABLE_TYPE
        WHERE   FK_E_NOTICE_TYPE_ID  = p_i_v_notice_type_id;

    /* *13 start */
    L_V_VARIABLE_DESC         ZND_E_NOTICE_VARIABLE_TYPE.VARIABLE_DESC%TYPE;
    L_V_MULTIPLE_VALUES_FLAG  ZND_E_NOTICE_VARIABLE_TYPE.MULTIPLE_VALUES_FLAG%TYPE;
    L_V_MAP_CODE              ZND_E_NOTICE_VARIABLE_TYPE.MAP_CODE%TYPE;
    /* *13 end */
BEGIN
    dbms_output.put_line('PRE_GET_ENOTICE_VARIABLES called');

    For l_rec_enotice_variable IN l_cur_enotice_variable
    LOOP
        /* *13 start */
        L_V_VARIABLE_DESC := l_rec_enotice_variable.VARIABLE_DESC;
        L_V_MULTIPLE_VALUES_FLAG := l_rec_enotice_variable.MULTIPLE_VALUES_FLAG;
        L_V_MAP_CODE := l_rec_enotice_variable.MAP_CODE;
        /* *13 end */

        p_tab_enotice_variables(l_n_curr_tab_index).VARIABLE_DESC        := l_rec_enotice_variable.VARIABLE_DESC;
        p_tab_enotice_variables(l_n_curr_tab_index).MULTIPLE_VALUES_FLAG := l_rec_enotice_variable.MULTIPLE_VALUES_FLAG;
        p_tab_enotice_variables(l_n_curr_tab_index).MAP_CODE             := l_rec_enotice_variable.MAP_CODE;
        l_n_curr_tab_index := l_n_curr_tab_index + 1;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        g_v_ora_err_msg := SQLERRM; -- *13
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_GET_ENOTICE_VARIABLES ' );
        /* *13 start */
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
            p_i_v_notice_type_id,
            'MAIL_TRIG',
            'M',
            'Error in PRE_GET_ENOTICE_VARIABLES',
            'A',
            'ENOTICE',
            SYSDATE,
            'ENOTICE',
            SYSDATE,
            g_v_ora_err_cd||'~'||g_v_ora_err_msg,
            L_V_VARIABLE_DESC ||'~'|| L_V_MULTIPLE_VALUES_FLAG ||'~'|| L_V_MAP_CODE
       );
       /* *13 end */
END;

PROCEDURE PRE_GEN_INPUT_DATA (
      p_tab_enotice_variables               ENOTICE_VARIABLES_TAB
    , p_array_map_codes                     STRING_ARRAY
    , p_array_map_code_value                STRING_ARRAY
    , p_array_data_key_header    OUT        STRING_ARRAY
    , p_array_data_value_header  OUT        STRING_ARRAY
    , p_array_data_key_detail    OUT        STRING_ARRAY
    , p_array_data_value_detail  OUT        STRING_ARRAY
)
IS

    l_v_variable_desc               ZND_E_NOTICE_VARIABLE_TYPE.VARIABLE_DESC%TYPE;
    l_v_multiple_values_flag        ZND_E_NOTICE_VARIABLE_TYPE.MAP_CODE%TYPE;
    l_n_curr_tab_index_header       NUMBER := 1;
    l_n_curr_tab_index_detail       NUMBER := 1;

BEGIN

    p_array_data_key_header         := STRING_ARRAY();
    p_array_data_value_header       := STRING_ARRAY();
    p_array_data_key_detail         := STRING_ARRAY();
    p_array_data_value_detail       := STRING_ARRAY();

    FOR i in 1..p_array_map_codes.COUNT
    LOOP

        PRE_GET_VARIABLE_INFO (
              p_tab_enotice_variables
            , p_array_map_codes(i)
            , l_v_variable_desc
            , l_v_multiple_values_flag
        );

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
          RETURN;
        END IF;

        IF l_v_multiple_values_flag = 'N' THEN

            p_array_data_key_header.extend(1);
            p_array_data_value_header.extend(1);
            dbms_output.put_line('l_v_variable_desc:=>'|| l_v_variable_desc );
            dbms_output.put_line('value:=>'|| p_array_map_code_value(i) );
            p_array_data_key_header(l_n_curr_tab_index_header)     := l_v_variable_desc;
            p_array_data_value_header(l_n_curr_tab_index_header)   := p_array_map_code_value(i);
            l_n_curr_tab_index_header := l_n_curr_tab_index_header + 1;

        ELSIF l_v_multiple_values_flag = 'Y' THEN

            p_array_data_key_detail.extend(1);
            p_array_data_value_detail.extend(1);
            p_array_data_key_detail(l_n_curr_tab_index_detail)     := l_v_variable_desc;
            p_array_data_value_detail(l_n_curr_tab_index_detail)   := p_array_map_code_value(i);
            l_n_curr_tab_index_detail := l_n_curr_tab_index_detail + 1;

        END IF;

    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        g_v_ora_err_msg := SQLERRM; -- *13
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_GEN_INPUT_DATA');
END;

PROCEDURE PRE_GET_VARIABLE_INFO (
      p_tab_enotice_variables               ENOTICE_VARIABLES_TAB
    , p_i_v_map_code                        VARCHAR2
    , p_o_v_variable_desc        OUT NOCOPY VARCHAR2
    , p_o_v_multiple_values_flag OUT NOCOPY VARCHAR2
)
IS
BEGIN

    FOR i IN 0..p_tab_enotice_variables.COUNT -1
    LOOP
        IF p_i_v_map_code = p_tab_enotice_variables(i).MAP_CODE THEN
            p_o_v_variable_desc        := p_tab_enotice_variables(i).VARIABLE_DESC;
            p_o_v_multiple_values_flag := p_tab_enotice_variables(i).MULTIPLE_VALUES_FLAG;
            EXIT;
        END IF;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        g_v_ora_err_msg := SQLERRM; -- *13
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_GET_VARIABLE_INFO');
END;

PROCEDURE PRE_RAISE_ENOTICE_DL_LL_MNTN (
      p_i_v_load_dischage_list_flag         VARCHAR2
    , p_i_v_session_id                      VARCHAR2
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN
    PRE_GEN_ENOTICE_DG_OOG_REF_CNG(
          p_i_v_load_dischage_list_flag
        , p_i_v_session_id
        , null
        , null
        , 'MNTN'
        , p_i_v_add_user
        , p_i_v_add_date
        , p_o_v_error
    );
/* *2 start * */
EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := 'ECM.GE0004';
/* *2 end  * */
END;


PROCEDURE PRE_RAISE_ENOTICE_EDI (
      p_i_v_load_dischage_list_flag         VARCHAR2
    , p_i_v_booked_id                       VARCHAR2
    , p_i_v_osol_id                         VARCHAR2   -- Overshipped / Overlanded Id
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN

    PRE_GEN_ENOTICE_DG_OOG_REF_CNG(
          p_i_v_load_dischage_list_flag
        , null
        , p_i_v_booked_id
        , p_i_v_osol_id
        , 'EDI'
        , p_i_v_add_user
        , p_i_v_add_date
        , p_o_v_error
    );
    /* *2 start * */
    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := 'ECM.GE0004';
    /* *2 end  * */

END;

PROCEDURE PRE_GEN_ENOTICE_DG_OOG_REF_CNG (
      p_i_v_load_dischage_list_flag         VARCHAR2
    , p_i_v_session_id                      VARCHAR2
    , p_i_v_booked_id                       VARCHAR2
    , p_i_v_osol_id                         VARCHAR2
    , p_i_v_called_from                     VARCHAR2
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

    l_excp_finish             EXCEPTION;

    l_n_enotice_request_id          ZND_E_NOTICE_REQUEST.PK_E_NOTICE_REQUEST_ID%TYPE;
    l_n_bussiness_key               ZND_E_NOTICE_REQUEST.BUSINESS_KEY_ID%TYPE;

    l_tab_variables_dg_chng         ENOTICE_VARIABLES_TAB;
    l_tab_variables_oog_chng        ENOTICE_VARIABLES_TAB;
    l_tab_variables_rfr_chng        ENOTICE_VARIABLES_TAB;

    l_arr_data_key_header           STRING_ARRAY ;
    l_arr_data_value_header         STRING_ARRAY ;
    l_arr_data_key_detail           STRING_ARRAY ;
    l_arr_data_value_detail         STRING_ARRAY ;

    l_arr_dg_chng_map_codes         STRING_ARRAY ;
    l_arr_dg_chng_map_code_value    STRING_ARRAY ;

    l_arr_oog_chng_map_codes        STRING_ARRAY ;
    l_arr_oog_chng_map_code_value   STRING_ARRAY ;

    l_arr_rfr_chng_map_codes        STRING_ARRAY ;
    l_arr_rfr_chng_map_code_value   STRING_ARRAY ;

    L_V_DISCHARGE_LIST_ID           TOS_DL_BOOKED_DISCHARGE_TMP.FK_DISCHARGE_LIST_ID%TYPE;  -- *1

    CURSOR l_cur_booking_data IS
        SELECT
              'L'                               AS "LOAD_DIS_LST"
            , LL.FK_SERVICE                     AS "SERVICE"
            , LL.FK_VESSEL                      AS "VESSEL"
            , ITP060.VSLGNM                     AS "VSL_NAME"
            , LL.FK_VOYAGE                      AS "VOYAGE"
            , ''                                AS "PORT_VOYAGE"
            , LL.FK_DIRECTION                   AS "DIRECTION"
            , LL.DN_PORT                        AS "PORT"
            , LL.FK_PORT_SEQUENCE_NO            AS "PORT_SEQUENCE_NO"
            , BKP001.BAOFFC                     AS "BOOKING_FSC"
            , BKP001.ORIGIN_FSC                 AS "ORIGIN_FSC"
            , BEF_CHG.DN_EQUIPMENT_NO           AS "EQUIPMENT_NO"
            , BEF_CHG.FK_BOOKING_NO             AS "BOOKING_NO"
            , BEF_CHG.DN_EQ_SIZE                AS "EQ_SIZE"
            , BEF_CHG.DN_EQ_TYPE                AS "EQ_TYPE"
            , BEF_CHG.DN_SOC_COC                AS "SOC_COC"
            , BEF_CHG.DN_FULL_MT                AS "FULL_MT"
            , BEF_CHG.LOAD_CONDITION            AS "LOAD_CONDITION"
            , BEF_CHG.FK_IMDG                   AS "IMDG_CLASS_OLD"
            , BEF_CHG.FK_UNNO                   AS "UN_NUMBER_OLD"
            , BEF_CHG.FK_UN_VAR                 AS "UN_NUMBER_VARIANT_OLD"
            , BEF_CHG.FK_PORT_CLASS             AS "PORT_CLASS_OLD"
            , BEF_CHG.FK_PORT_CLASS_TYP         AS "PORT_CLASS_TYPE_OLD"
            , BEF_CHG.FLASH_POINT               AS "FLASHPOINT_OLD"
            , BEF_CHG.FLASH_UNIT                AS "FLASHPOINT_UNIT_OLD"
            , BEF_CHG.FUMIGATION_ONLY           AS "FUMIGATION_ONLY_OLD"
            , BEF_CHG.RESIDUE_ONLY_FLAG         AS "RESIDUE_ONLY_FLAG_OLD"
            , BEF_CHG.OVERHEIGHT_CM             AS "OVERHEIGHT_CM_OLD"
            , BEF_CHG.OVERWIDTH_LEFT_CM         AS "OVERWIDTH_LEFT_CM_OLD"
            , BEF_CHG.OVERWIDTH_RIGHT_CM        AS "OVERWIDTH_RIGHT_CM_OLD"
            , BEF_CHG.OVERLENGTH_FRONT_CM       AS "OVERLENGTH_FRONT_CM_OLD"
            , BEF_CHG.OVERLENGTH_REAR_CM        AS "OVERLENGTH_REAR_CM_OLD"
            , BEF_CHG.VOID_SLOT                 AS "VOID_SLOT_OLD"
            , BEF_CHG.REEFER_TMP                AS "REEFER_TEMPERATURE_OLD"
            , BEF_CHG.REEFER_TMP_UNIT           AS "REEFER_TMP_UNIT_OLD"
            , BEF_CHG.DN_HUMIDITY               AS "HUMIDITY_OLD"
            , BEF_CHG.DN_VENTILATION            AS "VENTILATION_OLD"
            , AFT_CHG.FK_IMDG                   AS "IMDG_CLASS_NEW"
            , AFT_CHG.FK_UNNO                   AS "UN_NUMBER_NEW"
            , AFT_CHG.FK_UN_VAR                 AS "UN_NUMBER_VARIANT_NEW"
            , AFT_CHG.FK_PORT_CLASS             AS "PORT_CLASS_NEW"
            , AFT_CHG.FK_PORT_CLASS_TYP         AS "PORT_CLASS_TYPE_NEW"
            , AFT_CHG.FLASH_POINT               AS "FLASHPOINT_NEW"
            , AFT_CHG.FLASH_UNIT                AS "FLASHPOINT_UNIT_NEW"
            , AFT_CHG.FUMIGATION_ONLY           AS "FUMIGATION_ONLY_NEW"
            , AFT_CHG.RESIDUE_ONLY_FLAG         AS "RESIDUE_ONLY_FLAG_NEW"
            , AFT_CHG.OVERHEIGHT_CM             AS "OVERHEIGHT_CM_NEW"
            , AFT_CHG.OVERWIDTH_LEFT_CM         AS "OVERWIDTH_LEFT_CM_NEW"
            , AFT_CHG.OVERWIDTH_RIGHT_CM        AS "OVERWIDTH_RIGHT_CM_NEW"
            , AFT_CHG.OVERLENGTH_FRONT_CM       AS "OVERLENGTH_FRONT_CM_NEW"
            , AFT_CHG.OVERLENGTH_REAR_CM        AS "OVERLENGTH_REAR_CM_NEW"
            , AFT_CHG.VOID_SLOT                 AS "VOID_SLOT_NEW"
            , AFT_CHG.REEFER_TMP                AS "REEFER_TEMPERATURE_NEW"
            , AFT_CHG.REEFER_TMP_UNIT           AS "REEFER_TMP_UNIT_NEW"
            , AFT_CHG.DN_HUMIDITY               AS "HUMIDITY_NEW"
            , TO_NUMBER(AFT_CHG.DN_VENTILATION) AS "VENTILATION_NEW"
        FROM
               TOS_LL_LOAD_LIST                 LL
            ,  TOS_LL_BOOKED_LOADING            BEF_CHG
            , TOS_LL_BOOKED_LOADING_TMP         AFT_CHG
            , BKP001                            BKP001
            , ITP060                            ITP060
        WHERE LL.PK_LOAD_LIST_ID            = BEF_CHG.FK_LOAD_LIST_ID
        AND   BEF_CHG.PK_BOOKED_LOADING_ID  = AFT_CHG.PK_BOOKED_LOADING_ID
        AND   BKP001.BABKNO                 = BEF_CHG.FK_BOOKING_NO
        AND   ITP060.VSVESS                 = LL.FK_VESSEL
        AND   AFT_CHG.SESSION_ID            = p_i_v_session_id
        AND   AFT_CHG.OPN_STATUS            = 'UPD'
        AND   p_i_v_load_dischage_list_flag = 'L'
        AND   p_i_v_called_from                = 'MNTN'

        UNION ALL

        SELECT
              'D'                               AS "LOAD_DIS_LST"
            , DL.FK_SERVICE                     AS "SERVICE"
            , DL.FK_VESSEL                      AS "VESSEL"
            , ITP060.VSLGNM                     AS "VSL_NAME"
            , DL.FK_VOYAGE                      AS "VOYAGE"
            , ''                                AS "PORT_VOYAGE"
            , DL.FK_DIRECTION                   AS "DIRECTION"
            , DL.DN_PORT                        AS "PORT"
            , DL.FK_PORT_SEQUENCE_NO            AS "PORT_SEQUENCE_NO"
            , BKP001.BAOFFC                     AS "BOOKING_FSC"
            , BKP001.ORIGIN_FSC                 AS "ORIGIN_FSC"
            , BEF_CHG.DN_EQUIPMENT_NO           AS "EQUIPMENT_NO"
            , BEF_CHG.FK_BOOKING_NO             AS "BOOKING_NO"
            , BEF_CHG.DN_EQ_SIZE                AS "EQ_SIZE"
            , BEF_CHG.DN_EQ_TYPE                AS "EQ_TYPE"
            , BEF_CHG.DN_SOC_COC                AS "SOC_COC"
            , BEF_CHG.DN_FULL_MT                AS "FULL_MT"
            , BEF_CHG.LOAD_CONDITION            AS "LOAD_CONDITION"
            , BEF_CHG.FK_IMDG                   AS "IMDG_CLASS_OLD"
            , BEF_CHG.FK_UNNO                   AS "UN_NUMBER_OLD"
            , BEF_CHG.FK_UN_VAR                 AS "UN_NUMBER_VARIANT_OLD"
            , BEF_CHG.FK_PORT_CLASS             AS "PORT_CLASS_OLD"
            , BEF_CHG.FK_PORT_CLASS_TYP         AS "PORT_CLASS_TYPE_OLD"
            , BEF_CHG.FLASH_POINT               AS "FLASHPOINT_OLD"
            , BEF_CHG.FLASH_UNIT                AS "FLASHPOINT_UNIT_OLD"
            , BEF_CHG.FUMIGATION_ONLY           AS "FUMIGATION_ONLY_OLD"
            , BEF_CHG.RESIDUE_ONLY_FLAG         AS "RESIDUE_ONLY_FLAG_OLD"
            , BEF_CHG.OVERHEIGHT_CM             AS "OVERHEIGHT_CM_OLD"
            , BEF_CHG.OVERWIDTH_LEFT_CM         AS "OVERWIDTH_LEFT_CM_OLD"
            , BEF_CHG.OVERWIDTH_RIGHT_CM        AS "OVERWIDTH_RIGHT_CM_OLD"
            , BEF_CHG.OVERLENGTH_FRONT_CM       AS "OVERLENGTH_FRONT_CM_OLD"
            , BEF_CHG.OVERLENGTH_REAR_CM        AS "OVERLENGTH_REAR_CM_OLD"
            , BEF_CHG.VOID_SLOT                 AS "VOID_SLOT_OLD"
            , BEF_CHG.REEFER_TEMPERATURE        AS "REEFER_TEMPERATURE_OLD"
            , BEF_CHG.REEFER_TMP_UNIT           AS "REEFER_TMP_UNIT_OLD"
            , BEF_CHG.DN_HUMIDITY               AS "HUMIDITY_OLD"
            , BEF_CHG.DN_VENTILATION            AS "VENTILATION_OLD"
            , AFT_CHG.FK_IMDG                   AS "IMDG_CLASS_NEW"
            , AFT_CHG.FK_UNNO                   AS "UN_NUMBER_NEW"
            , AFT_CHG.FK_UN_VAR                 AS "UN_NUMBER_VARIANT_NEW"
            , AFT_CHG.FK_PORT_CLASS             AS "PORT_CLASS_NEW"
            , AFT_CHG.FK_PORT_CLASS_TYP         AS "PORT_CLASS_TYPE_NEW"
            , AFT_CHG.FLASH_POINT               AS "FLASHPOINT_NEW"
            , AFT_CHG.FLASH_UNIT                AS "FLASHPOINT_UNIT_NEW"
            , AFT_CHG.FUMIGATION_ONLY           AS "FUMIGATION_ONLY_NEW"
            , AFT_CHG.RESIDUE_ONLY_FLAG         AS "RESIDUE_ONLY_FLAG_NEW"
            , AFT_CHG.OVERHEIGHT_CM             AS "OVERHEIGHT_CM_NEW"
            , AFT_CHG.OVERWIDTH_LEFT_CM         AS "OVERWIDTH_LEFT_CM_NEW"
            , AFT_CHG.OVERWIDTH_RIGHT_CM        AS "OVERWIDTH_RIGHT_CM_NEW"
            , AFT_CHG.OVERLENGTH_FRONT_CM       AS "OVERLENGTH_FRONT_CM_NEW"
            , AFT_CHG.OVERLENGTH_REAR_CM        AS "OVERLENGTH_REAR_CM_NEW"
            , AFT_CHG.VOID_SLOT                 AS "VOID_SLOT_NEW"
            , AFT_CHG.REEFER_TEMPERATURE        AS "REEFER_TEMPERATURE_NEW"
            , AFT_CHG.REEFER_TMP_UNIT           AS "REEFER_TMP_UNIT_NEW"
            , AFT_CHG.DN_HUMIDITY               AS "HUMIDITY_NEW"
            , TO_NUMBER(AFT_CHG.DN_VENTILATION) AS "VENTILATION_NEW"
        FROM
               TOS_DL_DISCHARGE_LIST                DL
            ,  TOS_DL_BOOKED_DISCHARGE              BEF_CHG
            , TOS_DL_BOOKED_DISCHARGE_TMP           AFT_CHG
            , BKP001                                BKP001
            , ITP060                                ITP060
        WHERE DL.PK_DISCHARGE_LIST_ID         = BEF_CHG.FK_DISCHARGE_LIST_ID
        AND   BEF_CHG.PK_BOOKED_DISCHARGE_ID  = AFT_CHG.PK_BOOKED_DISCHARGE_ID
        AND   BKP001.BABKNO                   = BEF_CHG.FK_BOOKING_NO
        AND   ITP060.VSVESS                   = DL.FK_VESSEL
        AND   AFT_CHG.OPN_STATUS              = 'UPD'
        AND   AFT_CHG.SESSION_ID              = p_i_v_session_id
        AND   p_i_v_load_dischage_list_flag   = 'D'
        AND   p_i_v_called_from               = 'MNTN'

        UNION ALL

        SELECT
              'L'                                        AS "LOAD_DIS_LST"
            , LL.FK_SERVICE                              AS "SERVICE"
            , LL.FK_VESSEL                               AS "VESSEL"
            , ITP060.VSLGNM                              AS "VSL_NAME"
            , LL.FK_VOYAGE                               AS "VOYAGE"
            , ''                                         AS "PORT_VOYAGE"
            , LL.FK_DIRECTION                            AS "DIRECTION"
            , LL.DN_PORT                                 AS "PORT"
            , LL.FK_PORT_SEQUENCE_NO                     AS "PORT_SEQUENCE_NO"
            , BKP001.BAOFFC                              AS "BOOKING_FSC"
            , BKP001.ORIGIN_FSC                          AS "ORIGIN_FSC"
            , BEF_CHG.DN_EQUIPMENT_NO                    AS "EQUIPMENT_NO"
            , BEF_CHG.FK_BOOKING_NO                      AS "BOOKING_NO"
            , BEF_CHG.DN_EQ_SIZE                         AS "EQ_SIZE"
            , BEF_CHG.DN_EQ_TYPE                         AS "EQ_TYPE"
            , BEF_CHG.DN_SOC_COC                         AS "SOC_COC"
            , BEF_CHG.DN_FULL_MT                         AS "FULL_MT"
            , BEF_CHG.LOAD_CONDITION                     AS "LOAD_CONDITION"
            , BEF_CHG.FK_IMDG                            AS "IMDG_CLASS_OLD"
            , BEF_CHG.FK_UNNO                            AS "UN_NUMBER_OLD"
            , BEF_CHG.FK_UN_VAR                          AS "UN_NUMBER_VARIANT_OLD"
            , BEF_CHG.FK_PORT_CLASS                      AS "PORT_CLASS_OLD"
            , BEF_CHG.FK_PORT_CLASS_TYP                  AS "PORT_CLASS_TYPE_OLD"
            , BEF_CHG.FLASH_POINT                        AS "FLASHPOINT_OLD"
            , BEF_CHG.FLASH_UNIT                         AS "FLASHPOINT_UNIT_OLD"
            , BEF_CHG.FUMIGATION_ONLY                    AS "FUMIGATION_ONLY_OLD"
            , BEF_CHG.RESIDUE_ONLY_FLAG                  AS "RESIDUE_ONLY_FLAG_OLD"
            , BEF_CHG.OVERHEIGHT_CM                      AS "OVERHEIGHT_CM_OLD"
            , BEF_CHG.OVERWIDTH_LEFT_CM                  AS "OVERWIDTH_LEFT_CM_OLD"
            , BEF_CHG.OVERWIDTH_RIGHT_CM                 AS "OVERWIDTH_RIGHT_CM_OLD"
            , BEF_CHG.OVERLENGTH_FRONT_CM                AS "OVERLENGTH_FRONT_CM_OLD"
            , BEF_CHG.OVERLENGTH_REAR_CM                 AS "OVERLENGTH_REAR_CM_OLD"
            , BEF_CHG.VOID_SLOT                          AS "VOID_SLOT_OLD"
            , BEF_CHG.REEFER_TMP                         AS "REEFER_TEMPERATURE_OLD"
            , BEF_CHG.REEFER_TMP_UNIT                    AS "REEFER_TMP_UNIT_OLD"
            , BEF_CHG.DN_HUMIDITY                        AS "HUMIDITY_OLD"
            , BEF_CHG.DN_VENTILATION                     AS "VENTILATION_OLD"
            , AFT_CHG.IMDG_CLASS                         AS "IMDG_CLASS_NEW"
            , AFT_CHG.UN_NUMBER                          AS "UN_NUMBER_NEW"
            , AFT_CHG.UN_NUMBER_VARIANT                  AS "UN_NUMBER_VARIANT_NEW"
            , AFT_CHG.PORT_CLASS                         AS "PORT_CLASS_NEW"
            , AFT_CHG.PORT_CLASS_TYPE                    AS "PORT_CLASS_TYPE_NEW"
            , TO_CHAR(AFT_CHG.FLASHPOINT)                AS "FLASHPOINT_NEW"
            , AFT_CHG.FLASHPOINT_UNIT                    AS "FLASHPOINT_UNIT_NEW"
            , AFT_CHG.FUMIGATION_ONLY                    AS "FUMIGATION_ONLY_NEW"
            , AFT_CHG.RESIDUE_ONLY_FLAG                  AS "RESIDUE_ONLY_FLAG_NEW"
            , TO_CHAR(AFT_CHG.OVERHEIGHT_CM)             AS "OVERHEIGHT_CM_NEW"
            , TO_CHAR(AFT_CHG.OVERWIDTH_LEFT_CM)         AS "OVERWIDTH_LEFT_CM_NEW"
            , TO_CHAR(AFT_CHG.OVERWIDTH_RIGHT_CM)        AS "OVERWIDTH_RIGHT_CM_NEW"
            , TO_CHAR(AFT_CHG.OVERLENGTH_FRONT_CM)       AS "OVERLENGTH_FRONT_CM_NEW"
            , TO_CHAR(AFT_CHG.OVERLENGTH_REAR_CM)        AS "OVERLENGTH_REAR_CM_NEW"
            , TO_CHAR(AFT_CHG.VOID_SLOT)                 AS "VOID_SLOT_NEW"
            , TO_CHAR(AFT_CHG.REEFER_TEMPERATURE)        AS "REEFER_TEMPERATURE_NEW"
            , AFT_CHG.REEFER_TMP_UNIT                    AS "REEFER_TMP_UNIT_NEW"
            , TO_CHAR(AFT_CHG.HUMIDITY)                  AS "HUMIDITY_NEW"
            , AFT_CHG.VENTILATION                        AS "VENTILATION_NEW"
        FROM
               TOS_LL_LOAD_LIST                     LL
            ,  TOS_LL_BOOKED_LOADING                BEF_CHG
            , TOS_LL_OVERSHIPPED_CONTAINER          AFT_CHG
            , BKP001                                BKP001
            , ITP060                                ITP060
        WHERE LL.PK_LOAD_LIST_ID                    = BEF_CHG.FK_LOAD_LIST_ID
        AND   BEF_CHG.PK_BOOKED_LOADING_ID          = p_i_v_booked_id
        AND   AFT_CHG.PK_OVERSHIPPED_CONTAINER_ID   = p_i_v_osol_id
        AND   BKP001.BABKNO                         = BEF_CHG.FK_BOOKING_NO
        AND   ITP060.VSVESS                         = LL.FK_VESSEL
        AND   p_i_v_load_dischage_list_flag         = 'LL'
        AND   p_i_v_called_from                     = 'EDI'

        UNION ALL

        SELECT
              'D'                                   AS "LOAD_DIS_LST"
            , DL.FK_SERVICE                         AS "SERVICE"
            , DL.FK_VESSEL                          AS "VESSEL"
            , ITP060.VSLGNM                         AS "VSL_NAME"
            , DL.FK_VOYAGE                          AS "VOYAGE"
            , ''                                    AS "PORT_VOYAGE"
            , DL.FK_DIRECTION                       AS "DIRECTION"
            , DL.DN_PORT                            AS "PORT"
            , DL.FK_PORT_SEQUENCE_NO                AS "PORT_SEQUENCE_NO"
            , BKP001.BAOFFC                         AS "BOOKING_FSC"
            , BKP001.ORIGIN_FSC                     AS "ORIGIN_FSC"
            , BEF_CHG.DN_EQUIPMENT_NO               AS "EQUIPMENT_NO"
            , BEF_CHG.FK_BOOKING_NO                 AS "BOOKING_NO"
            , BEF_CHG.DN_EQ_SIZE                    AS "EQ_SIZE"
            , BEF_CHG.DN_EQ_TYPE                    AS "EQ_TYPE"
            , BEF_CHG.DN_SOC_COC                    AS "SOC_COC"
            , BEF_CHG.DN_FULL_MT                    AS "FULL_MT"
            , BEF_CHG.LOAD_CONDITION                AS "LOAD_CONDITION"
            , BEF_CHG.FK_IMDG                       AS "IMDG_CLASS_OLD"
            , BEF_CHG.FK_UNNO                       AS "UN_NUMBER_OLD"
            , BEF_CHG.FK_UN_VAR                     AS "UN_NUMBER_VARIANT_OLD"
            , BEF_CHG.FK_PORT_CLASS                 AS "PORT_CLASS_OLD"
            , BEF_CHG.FK_PORT_CLASS_TYP             AS "PORT_CLASS_TYPE_OLD"
            , BEF_CHG.FLASH_POINT                   AS "FLASHPOINT_OLD"
            , BEF_CHG.FLASH_UNIT                    AS "FLASHPOINT_UNIT_OLD"
            , BEF_CHG.FUMIGATION_ONLY               AS "FUMIGATION_ONLY_OLD"
            , BEF_CHG.RESIDUE_ONLY_FLAG             AS "RESIDUE_ONLY_FLAG_OLD"
            , BEF_CHG.OVERHEIGHT_CM                 AS "OVERHEIGHT_CM_OLD"
            , BEF_CHG.OVERWIDTH_LEFT_CM             AS "OVERWIDTH_LEFT_CM_OLD"
            , BEF_CHG.OVERWIDTH_RIGHT_CM            AS "OVERWIDTH_RIGHT_CM_OLD"
            , BEF_CHG.OVERLENGTH_FRONT_CM           AS "OVERLENGTH_FRONT_CM_OLD"
            , BEF_CHG.OVERLENGTH_REAR_CM            AS "OVERLENGTH_REAR_CM_OLD"
            , BEF_CHG.VOID_SLOT                     AS "VOID_SLOT_OLD"
            , BEF_CHG.REEFER_TEMPERATURE            AS "REEFER_TEMPERATURE_OLD"
            , BEF_CHG.REEFER_TMP_UNIT               AS "REEFER_TMP_UNIT_OLD"
            , BEF_CHG.DN_HUMIDITY                   AS "HUMIDITY_OLD"
            , BEF_CHG.DN_VENTILATION                AS "VENTILATION_OLD"
            , AFT_CHG.IMDG_CLASS                    AS "IMDG_CLASS_NEW"
            , AFT_CHG.UN_NUMBER                     AS "UN_NUMBER_NEW"
            , AFT_CHG.UN_NUMBER_VARIANT             AS "UN_NUMBER_VARIANT_NEW"
            , AFT_CHG.PORT_CLASS                    AS "PORT_CLASS_NEW"
            , AFT_CHG.PORT_CLASS_TYP                AS "PORT_CLASS_TYPE_NEW"
            , TO_CHAR(AFT_CHG.FLASHPOINT)           AS "FLASHPOINT_NEW"
            , AFT_CHG.FLASHPOINT_UNIT               AS "FLASHPOINT_UNIT_NEW"
            , AFT_CHG.FUMIGATION_ONLY               AS "FUMIGATION_ONLY_NEW"
            , AFT_CHG.RESIDUE_ONLY_FLAG             AS "RESIDUE_ONLY_FLAG_NEW"
            , TO_CHAR(AFT_CHG.OVERHEIGHT_CM)        AS "OVERHEIGHT_CM_NEW"
            , TO_CHAR(AFT_CHG.OVERWIDTH_LEFT_CM)    AS "OVERWIDTH_LEFT_CM_NEW"
            , TO_CHAR(AFT_CHG.OVERWIDTH_RIGHT_CM)   AS "OVERWIDTH_RIGHT_CM_NEW"
            , TO_CHAR(AFT_CHG.OVERLENGTH_FRONT_CM)  AS "OVERLENGTH_FRONT_CM_NEW"
            , TO_CHAR(AFT_CHG.OVERLENGTH_REAR_CM)   AS "OVERLENGTH_REAR_CM_NEW"
            , TO_CHAR(AFT_CHG.VOID_SLOT)            AS "VOID_SLOT_NEW"
            , TO_CHAR(AFT_CHG.REEFER_TEMPERATURE)   AS "REEFER_TEMPERATURE_NEW"
            , AFT_CHG.REEFER_TMP_UNIT               AS "REEFER_TMP_UNIT_NEW"
            , TO_CHAR(AFT_CHG.HUMIDITY)             AS "HUMIDITY_NEW"
            , AFT_CHG.VENTILATION                   AS "VENTILATION_NEW"
        FROM
               TOS_DL_DISCHARGE_LIST                DL
            ,  TOS_DL_BOOKED_DISCHARGE              BEF_CHG
            , TOS_DL_OVERLANDED_CONTAINER           AFT_CHG
            , BKP001                                BKP001
            , ITP060                                ITP060
        WHERE DL.PK_DISCHARGE_LIST_ID            = BEF_CHG.FK_DISCHARGE_LIST_ID
        AND   BEF_CHG.PK_BOOKED_DISCHARGE_ID     = p_i_v_booked_id
        AND   AFT_CHG.PK_OVERLANDED_CONTAINER_ID = p_i_v_osol_id
        AND   BKP001.BABKNO                      = BEF_CHG.FK_BOOKING_NO
        AND   ITP060.VSVESS                      = DL.FK_VESSEL
        AND   p_i_v_load_dischage_list_flag      = 'DL'
        AND   p_i_v_called_from                  = 'EDI';

BEGIN

    p_o_v_error := g_v_success;

    -- Get Variables data for ENotice Tyoe :: DG Change
    g_v_sql_id := '1';
    PRE_GET_ENOTICE_VARIABLES(g_n_notice_type_dg_change, l_tab_variables_dg_chng);
    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RAISE l_excp_finish;
    END IF;

    g_v_sql_id := '2';
    PRE_GET_ENOTICE_VARIABLES(g_n_notice_type_oog_change, l_tab_variables_oog_chng);
    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RAISE l_excp_finish;
    END IF;

    g_v_sql_id := '3';
    PRE_GET_ENOTICE_VARIABLES(g_n_notice_type_rfr_change, l_tab_variables_rfr_chng);
    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RAISE l_excp_finish;
    END IF;

    g_v_sql_id := '4';
    l_arr_dg_chng_map_codes := STRING_ARRAY (
          'LOAD_DIS_LST'         , 'SERVICE'              , 'VESSEL'               , 'VSL_NAME'             , 'VOYAGE'
        , 'PORT_VOYAGE'          , 'DIRECTION'            , 'PORT'                 , 'PORT_SEQUENCE_NO'     , 'EQUIPMENT_NO'
        , 'BOOKING_NO'           , 'EQ_SIZE'              , 'EQ_TYPE'              , 'SOC_COC'              , 'FULL_MT'
        , 'LOAD_CONDITION'       , 'IMDG_CLASS_OLD'       , 'IMDG_CLASS_NEW'       , 'UN_NUMBER_OLD'        , 'UN_NUMBER_NEW'
        , 'UN_NUMBER_VARIANT_OLD', 'UN_NUMBER_VARIANT_NEW', 'PORT_CLASS_OLD'       , 'PORT_CLASS_NEW'       , 'PORT_CLASS_TYPE_OLD'
        , 'PORT_CLASS_TYPE_NEW'  , 'FLASHPOINT_OLD'       , 'FLASHPOINT_NEW'       , 'FLASHPOINT_UNIT_OLD'  , 'FLASHPOINT_UNIT_NEW'
        , 'FUMIGATION_ONLY_OLD'  , 'FUMIGATION_ONLY_NEW'  , 'RESIDUE_ONLY_FLAG_OLD', 'RESIDUE_ONLY_FLAG_NEW'
    );

    g_v_sql_id := '5';
    l_arr_oog_chng_map_codes := STRING_ARRAY (
          'LOAD_DIS_LST'           , 'SERVICE'                , 'VESSEL'                 , 'VSL_NAME'               , 'VOYAGE'
        , 'PORT_VOYAGE'            , 'DIRECTION'              , 'PORT'                   , 'PORT_SEQUENCE_NO'       , 'EQUIPMENT_NO'
        , 'BOOKING_NO'             , 'EQ_SIZE'                , 'EQ_TYPE'                , 'SOC_COC'                , 'FULL_MT'
        , 'LOAD_CONDITION'         , 'OVERHEIGHT_CM_OLD'      , 'OVERHEIGHT_CM_NEW'      , 'OVERWIDTH_LEFT_CM_OLD'  , 'OVERWIDTH_LEFT_CM_NEW'
        , 'OVERWIDTH_RIGHT_CM_OLD' , 'OVERWIDTH_RIGHT_CM_NEW' , 'OVERLENGTH_FRONT_CM_OLD', 'OVERLENGTH_FRONT_CM_NEW', 'OVERLENGTH_REAR_CM_OLD'
        , 'OVERLENGTH_REAR_CM_NEW' , 'VOID_SLOT_OLD'          , 'VOID_SLOT_NEW'
    );

    g_v_sql_id := '6';
    l_arr_rfr_chng_map_codes := STRING_ARRAY (
          'LOAD_DIS_LST'          , 'SERVICE'               , 'VESSEL'                , 'VSL_NAME'           , 'VOYAGE'
        , 'PORT_VOYAGE'           , 'DIRECTION'             , 'PORT'                  , 'PORT_SEQUENCE_NO'   , 'EQUIPMENT_NO'
        , 'BOOKING_NO'            , 'EQ_SIZE'               , 'EQ_TYPE'               , 'SOC_COC'            , 'FULL_MT'
        , 'LOAD_CONDITION'        , 'REEFER_TEMPERATURE_OLD', 'REEFER_TEMPERATURE_NEW', 'REEFER_TMP_UNIT_OLD', 'REEFER_TMP_UNIT_NEW'
        , 'HUMIDITY_OLD'          , 'HUMIDITY_NEW'          , 'VENTILATION_OLD'       , 'VENTILATION_NEW'
    );

    g_v_sql_id := '7';
    For l_rec_booking_data IN l_cur_booking_data
    LOOP

        IF l_rec_booking_data.LOAD_DIS_LST = 'L' THEN
            l_n_bussiness_key := g_n_bussiness_key_ll_maintain;
        ELSIF l_rec_booking_data.LOAD_DIS_LST = 'D' THEN
            l_n_bussiness_key := g_n_bussiness_key_dl_maintain;
        ELSE
            l_n_bussiness_key := g_n_bussiness_key_dl_edi;
        END IF;

        g_v_sql_id := '8';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
        -- Predate data for DG Chagne Scinerio
        IF  NVL(l_rec_booking_data.IMDG_CLASS_OLD, ' ')           !=  NVL(l_rec_booking_data.IMDG_CLASS_NEW, ' ')           OR
            NVL(l_rec_booking_data.UN_NUMBER_OLD, ' ')            !=  NVL(l_rec_booking_data.UN_NUMBER_NEW , ' ')           OR
            NVL(l_rec_booking_data.UN_NUMBER_VARIANT_OLD, ' ')    !=  NVL(l_rec_booking_data.UN_NUMBER_VARIANT_NEW, ' ')    OR
            NVL(l_rec_booking_data.PORT_CLASS_OLD, ' ')           !=  NVL(l_rec_booking_data.PORT_CLASS_NEW, ' ')           OR
            NVL(l_rec_booking_data.PORT_CLASS_TYPE_OLD, ' ')      !=  NVL(l_rec_booking_data.PORT_CLASS_TYPE_NEW, ' ')      OR
            NVL(l_rec_booking_data.FLASHPOINT_OLD, 0)             !=  NVL(TO_NUMBER(l_rec_booking_data.FLASHPOINT_NEW), 0)  OR
            NVL(l_rec_booking_data.FLASHPOINT_UNIT_OLD, ' ')      !=  NVL(l_rec_booking_data.FLASHPOINT_UNIT_NEW, ' ')      OR
            NVL(l_rec_booking_data.FUMIGATION_ONLY_OLD, ' ')      !=  NVL(l_rec_booking_data.FUMIGATION_ONLY_NEW, ' ')      OR
            NVL(l_rec_booking_data.RESIDUE_ONLY_FLAG_OLD, ' ')    !=  NVL(l_rec_booking_data.RESIDUE_ONLY_FLAG_NEW, ' ')
        THEN

            g_v_sql_id := '9';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            l_arr_dg_chng_map_code_value := STRING_ARRAY (
                  l_rec_booking_data.LOAD_DIS_LST             , l_rec_booking_data.SERVICE
                , l_rec_booking_data.VESSEL                   , l_rec_booking_data.VSL_NAME
                , l_rec_booking_data.VOYAGE                   , l_rec_booking_data.PORT_VOYAGE
                , l_rec_booking_data.DIRECTION                , l_rec_booking_data.PORT
                , l_rec_booking_data.PORT_SEQUENCE_NO         , l_rec_booking_data.EQUIPMENT_NO
                , l_rec_booking_data.BOOKING_NO               , l_rec_booking_data.EQ_SIZE
                , l_rec_booking_data.EQ_TYPE                  , l_rec_booking_data.SOC_COC
                , l_rec_booking_data.FULL_MT                  , l_rec_booking_data.LOAD_CONDITION
                , l_rec_booking_data.IMDG_CLASS_OLD           , l_rec_booking_data.IMDG_CLASS_NEW
                , l_rec_booking_data.UN_NUMBER_OLD            , l_rec_booking_data.UN_NUMBER_NEW
                , l_rec_booking_data.UN_NUMBER_VARIANT_OLD    , l_rec_booking_data.UN_NUMBER_VARIANT_NEW
                , l_rec_booking_data.PORT_CLASS_OLD           , l_rec_booking_data.PORT_CLASS_NEW
                , l_rec_booking_data.PORT_CLASS_TYPE_OLD      , l_rec_booking_data.PORT_CLASS_TYPE_NEW
                , l_rec_booking_data.FLASHPOINT_OLD           , l_rec_booking_data.FLASHPOINT_NEW
                , l_rec_booking_data.FLASHPOINT_UNIT_OLD      , l_rec_booking_data.FLASHPOINT_UNIT_NEW
                , l_rec_booking_data.FUMIGATION_ONLY_OLD      , l_rec_booking_data.FUMIGATION_ONLY_NEW
                , l_rec_booking_data.RESIDUE_ONLY_FLAG_OLD    , l_rec_booking_data.RESIDUE_ONLY_FLAG_NEW
            );

            g_v_sql_id := '10';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PRE_GEN_INPUT_DATA (
                  l_tab_variables_dg_chng
                , l_arr_dg_chng_map_codes
                , l_arr_dg_chng_map_code_value
                , l_arr_data_key_header
                , l_arr_data_value_header
                , l_arr_data_key_detail
                , l_arr_data_value_detail
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '11';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_REQUEST (
                  l_n_enotice_request_id
                , l_n_bussiness_key
                , g_n_notice_type_dg_change
                , l_arr_data_key_header
                , l_arr_data_value_header
                , l_rec_booking_data.ORIGIN_FSC
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '12';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            DBMS_OUTPUT.PUT_LINE('8297492:'||l_rec_booking_data.BOOKING_FSC ||'~'||l_rec_booking_data.booking_no);

            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
                  l_n_enotice_request_id
                , 'F'
                , l_rec_booking_data.BOOKING_FSC
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , 'N'
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '48';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS (
                  l_n_enotice_request_id
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

        END IF;


        -- Predate data for OOG Chagne Scinerio
        g_v_sql_id := '13';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
        IF   NVL(l_rec_booking_data.OVERHEIGHT_CM_OLD, 0)         !=   NVL(TO_NUMBER(l_rec_booking_data.OVERHEIGHT_CM_NEW),0 )         OR
             NVL(l_rec_booking_data.OVERWIDTH_LEFT_CM_OLD, 0)     !=   NVL(TO_NUMBER(l_rec_booking_data.OVERWIDTH_LEFT_CM_NEW),0 )     OR
             NVL(l_rec_booking_data.OVERWIDTH_RIGHT_CM_OLD, 0)    !=   NVL(TO_NUMBER(l_rec_booking_data.OVERWIDTH_RIGHT_CM_NEW),0 )    OR
             NVL(l_rec_booking_data.OVERLENGTH_FRONT_CM_OLD, 0)   !=   NVL(TO_NUMBER(l_rec_booking_data.OVERLENGTH_FRONT_CM_NEW),0 )   OR
             NVL(l_rec_booking_data.OVERLENGTH_REAR_CM_OLD, 0)    !=   NVL(TO_NUMBER(l_rec_booking_data.OVERLENGTH_REAR_CM_NEW ),0 )   OR
             NVL(l_rec_booking_data.VOID_SLOT_OLD, 0)             !=   NVL(TO_NUMBER(l_rec_booking_data.VOID_SLOT_NEW),0 )
        THEN

            g_v_sql_id := '14';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            l_arr_oog_chng_map_code_value := STRING_ARRAY (
                  l_rec_booking_data.LOAD_DIS_LST             , l_rec_booking_data.SERVICE
                , l_rec_booking_data.VESSEL                   , l_rec_booking_data.VSL_NAME
                , l_rec_booking_data.VOYAGE                   , l_rec_booking_data.PORT_VOYAGE
                , l_rec_booking_data.DIRECTION                , l_rec_booking_data.PORT
                , l_rec_booking_data.PORT_SEQUENCE_NO         , l_rec_booking_data.EQUIPMENT_NO
                , l_rec_booking_data.BOOKING_NO               , l_rec_booking_data.EQ_SIZE
                , l_rec_booking_data.EQ_TYPE                  , l_rec_booking_data.SOC_COC
                , l_rec_booking_data.FULL_MT                  , l_rec_booking_data.LOAD_CONDITION
                , l_rec_booking_data.OVERHEIGHT_CM_OLD        , l_rec_booking_data.OVERHEIGHT_CM_NEW
                , l_rec_booking_data.OVERWIDTH_LEFT_CM_OLD    , l_rec_booking_data.OVERWIDTH_LEFT_CM_NEW
                , l_rec_booking_data.OVERWIDTH_RIGHT_CM_OLD   , l_rec_booking_data.OVERWIDTH_RIGHT_CM_NEW
                , l_rec_booking_data.OVERLENGTH_FRONT_CM_OLD  , l_rec_booking_data.OVERLENGTH_FRONT_CM_NEW
                , l_rec_booking_data.OVERLENGTH_REAR_CM_OLD   , l_rec_booking_data.OVERLENGTH_REAR_CM_NEW
                , l_rec_booking_data.VOID_SLOT_OLD            , l_rec_booking_data.VOID_SLOT_NEW
            );

            g_v_sql_id := '15';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PRE_GEN_INPUT_DATA (
                  l_tab_variables_oog_chng
                , l_arr_oog_chng_map_codes
                , l_arr_oog_chng_map_code_value
                , l_arr_data_key_header
                , l_arr_data_value_header
                , l_arr_data_key_detail
                , l_arr_data_value_detail
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '16';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_REQUEST (
                  l_n_enotice_request_id
                , l_n_bussiness_key
                , g_n_notice_type_oog_change
                , l_arr_data_key_header
                , l_arr_data_value_header
                , l_rec_booking_data.ORIGIN_FSC
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '17';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            DBMS_OUTPUT.PUT_LINE('8297492:'||l_rec_booking_data.BOOKING_FSC ||'~'||l_rec_booking_data.booking_no);
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
                  l_n_enotice_request_id
                , 'F'
                , l_rec_booking_data.BOOKING_FSC
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , 'N'
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '49';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS (
                  l_n_enotice_request_id
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

        END IF;

        g_v_sql_id := '18';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
        -- Predate data for Reefer Chagne Scinerio
        IF  NVL(l_rec_booking_data.REEFER_TEMPERATURE_OLD, 0)    !=  NVL(TO_NUMBER(l_rec_booking_data.REEFER_TEMPERATURE_NEW), 0) OR
            NVL(l_rec_booking_data.REEFER_TMP_UNIT_OLD, ' ')     !=  NVL(l_rec_booking_data.REEFER_TMP_UNIT_NEW, ' ')             OR
            NVL(l_rec_booking_data.HUMIDITY_OLD, 0)              !=  NVL(TO_NUMBER(l_rec_booking_data.HUMIDITY_NEW), 0)           OR
            NVL(l_rec_booking_data.VENTILATION_OLD,0)            !=  NVL(l_rec_booking_data.VENTILATION_NEW, 0)
        THEN

            g_v_sql_id := '19';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            l_arr_rfr_chng_map_code_value := STRING_ARRAY (
                  l_rec_booking_data.LOAD_DIS_LST             , l_rec_booking_data.SERVICE
                , l_rec_booking_data.VESSEL                   , l_rec_booking_data.VSL_NAME
                , l_rec_booking_data.VOYAGE                   , l_rec_booking_data.PORT_VOYAGE
                , l_rec_booking_data.DIRECTION                , l_rec_booking_data.PORT
                , l_rec_booking_data.PORT_SEQUENCE_NO         , l_rec_booking_data.EQUIPMENT_NO
                , l_rec_booking_data.BOOKING_NO               , l_rec_booking_data.EQ_SIZE
                , l_rec_booking_data.EQ_TYPE                  , l_rec_booking_data.SOC_COC
                , l_rec_booking_data.FULL_MT                  , l_rec_booking_data.LOAD_CONDITION
                , l_rec_booking_data.REEFER_TEMPERATURE_OLD   , l_rec_booking_data.REEFER_TEMPERATURE_NEW
                , l_rec_booking_data.REEFER_TMP_UNIT_OLD      , l_rec_booking_data.REEFER_TMP_UNIT_NEW
                , l_rec_booking_data.HUMIDITY_OLD             , l_rec_booking_data.HUMIDITY_NEW
                , l_rec_booking_data.VENTILATION_OLD          , l_rec_booking_data.VENTILATION_NEW
            );

            g_v_sql_id := '20';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PRE_GEN_INPUT_DATA (
                  l_tab_variables_rfr_chng
                , l_arr_rfr_chng_map_codes
                , l_arr_rfr_chng_map_code_value
                , l_arr_data_key_header
                , l_arr_data_value_header
                , l_arr_data_key_detail
                , l_arr_data_value_detail
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '21';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_REQUEST (
                  l_n_enotice_request_id
                , l_n_bussiness_key
                , g_n_notice_type_rfr_change
                , l_arr_data_key_header
                , l_arr_data_value_header
                , l_rec_booking_data.ORIGIN_FSC
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '22';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            DBMS_OUTPUT.PUT_LINE('8297492:'||l_rec_booking_data.BOOKING_FSC ||'~'||l_rec_booking_data.booking_no);
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
                  l_n_enotice_request_id
                , 'F'
                , l_rec_booking_data.BOOKING_FSC
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , 'N'
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

            g_v_sql_id := '50';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
            PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS (
                  l_n_enotice_request_id
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

        END IF;

    END LOOP;

    g_v_sql_id := '23';
    DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
    IF p_i_v_load_dischage_list_flag = 'D' THEN

        /* *1 start * */
        /* * find the discharge list id * */

        SELECT
            FK_DISCHARGE_LIST_ID
        INTO
            L_V_DISCHARGE_LIST_ID
        FROM
            TOS_DL_BOOKED_DISCHARGE_TMP
        WHERE
            SESSION_ID =  p_i_v_session_id
            AND ROWNUM=1;

        /* *1 end * */
        g_v_sql_id := '24';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
        PRE_RAISE_ENOTICE_DL_WRK_SRT (
              'DLM_SCREEN'
            , p_i_v_session_id
            , g_n_bussiness_key_dl_maintain
            , L_V_DISCHARGE_LIST_ID -- *1
            , NULL
            , NULL
            , p_i_v_add_user
            , p_i_v_add_date
            , g_v_ora_err_cd
        );

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_excp_finish;
        END IF;

    END IF;

    g_v_sql_id := '25';
    DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
    IF p_i_v_load_dischage_list_flag = 'L' THEN

        g_v_sql_id := '26';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_DL_LL_MNTN:'||g_v_sql_id);
        PRE_RAISE_ENOTICE_OB_DTL_CHNG (
              p_i_v_session_id
            , p_i_v_add_user
            , p_i_v_add_date
            , g_v_ora_err_cd
        );

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_excp_finish;
        END IF;

    END IF;

    /* Completed Successfully */
    g_v_sql_id := '';
    g_v_usr_err_msg := 'Program finished successfully.';
    p_o_v_error := g_v_success ;

EXCEPTION
    WHEN l_excp_finish THEN

        DBMS_OUTPUT.PUT_LINE('In exception block l_excp_finish >>>');
        DBMS_OUTPUT.PUT_LINE('g_v_ora_err_cd >>> '|| g_v_ora_err_cd);
        DBMS_OUTPUT.PUT_LINE('g_v_usr_err_cd >>> '|| g_v_usr_err_cd);
        DBMS_OUTPUT.PUT_LINE('ERROR >>> '         || g_v_sql_id || ' ' || SQLERRM);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            IF (g_v_usr_err_cd <> g_v_success ) THEN
                p_o_v_error := g_v_usr_err_cd;
            ELSE
                p_o_v_error := g_v_ora_err_cd;
            END IF;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        END IF ;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('In exception block Others >>>' || g_v_sql_id);
        DBMS_OUTPUT.PUT_LINE('ERROR >>> '         || g_v_sql_id || ' ' || SQLERRM);
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_RAISE_ENOTICE_OB_DTL_CHNG (
      p_i_v_session_id                      VARCHAR2
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

    l_tab_variables_ob_dtl_chng     ENOTICE_VARIABLES_TAB;
    l_n_enotice_request_id          ZND_E_NOTICE_REQUEST.PK_E_NOTICE_REQUEST_ID%TYPE;

    l_arr_data_key_header           STRING_ARRAY ;
    l_arr_data_value_header         STRING_ARRAY ;
    l_arr_data_key_detail           STRING_ARRAY ;
    l_arr_data_value_detail         STRING_ARRAY ;

    l_arr_ob_dtl_chng_hmap_codes    STRING_ARRAY ;
    l_arr_ob_dtl_chng_hmap_cd_val   STRING_ARRAY ;

    l_arr_ob_dtl_chng_dmap_codes    STRING_ARRAY ;
    l_arr_ob_dtl_chng_dmap_cd_val   STRING_ARRAY ;

    L_V_CURENT_FSC ITP040.PIOFFC%TYPE; -- *1

    CURSOR l_cur_load_list_data IS
        SELECT DISTINCT
              LL.PK_LOAD_LIST_ID                AS "LOAD_LIST_ID"
            , LL.FK_SERVICE                     AS "SERVICE"
            , LL.FK_VESSEL                      AS "VESSEL"
            , ITP060.VSLGNM                     AS "VSL_NAME"
            , LL.FK_VOYAGE                      AS "VOYAGE"
            , ''                                AS "PORT_VOYAGE"
            , LL.FK_DIRECTION                   AS "DIRECTION"
            , LL.DN_PORT                        AS "PORT"
            , LL.FK_PORT_SEQUENCE_NO            AS "PORT_SEQUENCE_NO"
            , ITP040.PIOFFC                     AS "ORIGIN_FSC"
        FROM
               TOS_LL_LOAD_LIST                 LL
            , TOS_LL_BOOKED_LOADING_TMP         BLT
            , ITP040                            ITP040
            , ITP060                            ITP060
        WHERE LL.PK_LOAD_LIST_ID = BLT.FK_LOAD_LIST_ID
        AND   ITP040.PICODE      = LL.DN_PORT
        AND   ITP060.VSVESS      = LL.FK_VESSEL
        AND   BLT.SESSION_ID     = p_i_v_session_id
        AND   BLT.OPN_STATUS     = 'UPD';

    CURSOR l_cur_ll_booking_fsc_data (p_i_n_load_list_id VARCHAR2) IS
        SELECT DISTINCT
              BLT.FK_BOOKING_NO                 AS "BOOKING_NO"
            , BLT.DN_DISCHARGE_PORT             AS "DISCHARGE_PORT"
            , ITP040.PIOFFC                     AS "NEXT_PORT_FSC"
        FROM  TOS_LL_BOOKED_LOADING_TMP         BLT
            , ITP040                            ITP040
        WHERE ITP040.PICODE       = BLT.DN_DISCHARGE_PORT
        AND   BLT.FK_LOAD_LIST_ID = p_i_n_load_list_id
        AND   BLT.SESSION_ID      = p_i_v_session_id
        AND   BLT.OPN_STATUS      = 'UPD';

    CURSOR l_cur_ll_booking_data (p_i_n_load_list_id    VARCHAR2) IS
        SELECT
              BEF_CHG.DN_EQUIPMENT_NO                   AS "EQUIPMENT_NO"
            , BEF_CHG.FK_BOOKING_NO                     AS "BOOKING_NO"
            , BEF_CHG.DN_EQ_SIZE                        AS "EQ_SIZE"
            , BEF_CHG.DN_EQ_TYPE                        AS "EQ_TYPE"
            , BEF_CHG.DN_SOC_COC                        AS "SOC_COC"
            , BEF_CHG.DN_FULL_MT                        AS "FULL_MT"
            , BEF_CHG.LOAD_CONDITION                    AS "LOAD_CONDITION"
            , BEF_CHG.LOCAL_STATUS                      AS "LOCAL_STATUS"
            , ''                                        AS "CONT_ACTION_FLAG"
            , BEF_CHG.LOADING_STATUS                    AS "LOADING_STATUS_OLD"
            , BEF_CHG.STOWAGE_POSITION                  AS "STOWAGE_POSITION_OLD"
            , BEF_CHG.DAMAGED                           AS "DAMAGED_OLD"
            , BEF_CHG.FK_HANDLING_INSTRUCTION_1         AS "HANDLING_INSTRUCTION_1_OLD"
            , BEF_CHG.FK_HANDLING_INSTRUCTION_2         AS "HANDLING_INSTRUCTION_2_OLD"
            , BEF_CHG.FK_HANDLING_INSTRUCTION_3         AS "HANDLING_INSTRUCTION_3_OLD"
            , BEF_CHG.CONTAINER_LOADING_REM_1           AS "CONTAINER_LOADING_REM_1_OLD"
            , BEF_CHG.CONTAINER_LOADING_REM_2           AS "CONTAINER_LOADING_REM_2_OLD"
            , BEF_CHG.FK_SPECIAL_CARGO                  AS "SPECIAL_CARGO_OLD"
            , AFT_CHG.LOADING_STATUS                    AS "LOADING_STATUS_NEW"
            , AFT_CHG.STOWAGE_POSITION                  AS "STOWAGE_POSITION_NEW"
            , AFT_CHG.DAMAGED                           AS "DAMAGED_NEW"
            , AFT_CHG.FK_HANDLING_INSTRUCTION_1         AS "HANDLING_INSTRUCTION_1_NEW"
            , AFT_CHG.FK_HANDLING_INSTRUCTION_2         AS "HANDLING_INSTRUCTION_2_NEW"
            , AFT_CHG.FK_HANDLING_INSTRUCTION_3         AS "HANDLING_INSTRUCTION_3_NEW"
            , AFT_CHG.CONTAINER_LOADING_REM_1           AS "CONTAINER_LOADING_REM_1_NEW"
            , AFT_CHG.CONTAINER_LOADING_REM_2           AS "CONTAINER_LOADING_REM_2_NEW"
            , AFT_CHG.FK_SPECIAL_CARGO                  AS "SPECIAL_CARGO_NEW"
        FROM  TOS_LL_BOOKED_LOADING_TMP       AFT_CHG
            , TOS_LL_BOOKED_LOADING           BEF_CHG
        WHERE BEF_CHG.PK_BOOKED_LOADING_ID = AFT_CHG.PK_BOOKED_LOADING_ID
        AND   AFT_CHG.FK_LOAD_LIST_ID = p_i_n_load_list_id
        AND   AFT_CHG.SESSION_ID      = p_i_v_session_id
        AND   AFT_CHG.OPN_STATUS      = 'UPD';

BEGIN

    p_o_v_error := g_v_success;

    -- Get Variables data for ENotice Tyoe :: On Board Detail Change
    g_v_sql_id := '27';
    dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
    PRE_GET_ENOTICE_VARIABLES(g_n_notice_type_ob_dtl_change, l_tab_variables_ob_dtl_chng);
    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RETURN;
    END IF;

    g_v_sql_id := '28';
    dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
    l_arr_ob_dtl_chng_hmap_codes := STRING_ARRAY (
          'LOAD_DIS_LST'         , 'SERVICE'            , 'VESSEL'           ,
          'VSL_NAME'             , 'VOYAGE'             , 'PORT_VOYAGE'      ,
          'DIRECTION'            , 'PORT'               , 'PORT_SEQUENCE_NO'
    );

    g_v_sql_id := '29';
    dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
    l_arr_ob_dtl_chng_dmap_codes := STRING_ARRAY (
        'EQUIPMENT_NO'               , 'BOOKING_NO'                 , 'EQ_SIZE'                    ,
        'EQ_TYPE'                    , 'SOC_COC'                    , 'FULL_MT'                    ,
        'LOAD_CONDITION'             , 'LOCAL_STATUS'               , 'CONT_ACTION_FLAG'           ,
        'LOADING_STATUS_OLD'         , 'LOADING_STATUS_NEW'         , 'STOWAGE_POSITION_OLD'       ,
        'STOWAGE_POSITION_NEW'       , 'DAMAGED_OLD'                , 'DAMAGED_NEW'                ,
        'HANDLING_INSTRUCTION_1_OLD' , 'HANDLING_INSTRUCTION_1_NEW' , 'HANDLING_INSTRUCTION_2_OLD' ,
        'HANDLING_INSTRUCTION_2_NEW' , 'HANDLING_INSTRUCTION_3_OLD' , 'HANDLING_INSTRUCTION_3_NEW' ,
        'CONTAINER_LOADING_REM_1_OLD', 'CONTAINER_LOADING_REM_1_NEW', 'CONTAINER_LOADING_REM_2_OLD',
        'CONTAINER_LOADING_REM_2_NEW', 'SPECIAL_CARGO_OLD'          , 'SPECIAL_CARGO_NEW'
    );

    g_v_sql_id := '30';
    dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
    For l_rec_load_list_data IN l_cur_load_list_data
    LOOP

        g_v_sql_id := '31';
        dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
        l_arr_ob_dtl_chng_hmap_cd_val := STRING_ARRAY (
              'L'                                        , l_rec_load_list_data.SERVICE
            , l_rec_load_list_data.VESSEL                , l_rec_load_list_data.VSL_NAME
            , l_rec_load_list_data.VOYAGE                , l_rec_load_list_data.PORT_VOYAGE
            , l_rec_load_list_data.DIRECTION             , l_rec_load_list_data.PORT
            , l_rec_load_list_data.PORT_SEQUENCE_NO
        );

        g_v_sql_id := '32';
        dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
        PRE_GEN_INPUT_DATA (
              l_tab_variables_ob_dtl_chng
            , l_arr_ob_dtl_chng_hmap_codes
            , l_arr_ob_dtl_chng_hmap_cd_val
            , l_arr_data_key_header
            , l_arr_data_value_header
            , l_arr_data_key_detail
            , l_arr_data_value_detail
        );

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RETURN;
        END IF;

        g_v_sql_id := '33';
        dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
        PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_REQUEST (
              l_n_enotice_request_id
            , g_n_bussiness_key_ll_maintain
            , g_n_notice_type_ob_dtl_change
            , l_arr_data_key_header
            , l_arr_data_value_header
            , l_rec_load_list_data.ORIGIN_FSC
            , p_i_v_add_user
            , p_i_v_add_date
            , g_v_ora_err_cd
        );

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RETURN;
        END IF;

        g_v_sql_id := '34';
        dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
        /* *1 start * */
        /* * find the currect fsc * */
        SELECT
            I40.PIOFFC AS "CURRENT_PORT_FSC"
        INTO
            L_V_CURENT_FSC
        FROM
            TOS_LL_LOAD_LIST LL,
            ITP040 I40
        WHERE
            I40.PICODE = LL.DN_PORT
            AND LL.PK_LOAD_LIST_ID = l_rec_load_list_data.LOAD_LIST_ID;
        /* *1 end * */

        FOR l_rec_ll_booking_fsc_data IN l_cur_ll_booking_fsc_data(l_rec_load_list_data.LOAD_LIST_ID)
        LOOP
            g_v_sql_id := '35';
            dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);

            DBMS_OUTPUT.PUT_LINE('NEXT PORT FSC=>'||l_rec_ll_booking_fsc_data.NEXT_PORT_FSC);
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
                  l_n_enotice_request_id
                , 'F'
                , l_rec_ll_booking_fsc_data.NEXT_PORT_FSC
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , 'N'
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RETURN;
            END IF;

            /* *1 start * */
            /* * set reciepient of the mail * */
            DBMS_OUTPUT.PUT_LINE('CURRENT PORT FSC=>'||L_V_CURENT_FSC);
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
                  l_n_enotice_request_id
                , 'F'
                , L_V_CURENT_FSC
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , 'N'
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RETURN;
            END IF;
            /* *1 end  * */

        END LOOP;

        g_v_sql_id := '36';
        dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
        FOR l_rec_ll_booking_data IN l_cur_ll_booking_data(l_rec_load_list_data.LOAD_LIST_ID)
        LOOP

            g_v_sql_id := '37';
            dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
            l_arr_ob_dtl_chng_dmap_cd_val := STRING_ARRAY (
                l_rec_ll_booking_data.EQUIPMENT_NO                  ,
                l_rec_ll_booking_data.BOOKING_NO                    ,
                l_rec_ll_booking_data.EQ_SIZE                       ,
                l_rec_ll_booking_data.EQ_TYPE                       ,
                l_rec_ll_booking_data.SOC_COC                       ,
                l_rec_ll_booking_data.FULL_MT                       ,
                l_rec_ll_booking_data.LOAD_CONDITION                ,
                l_rec_ll_booking_data.LOCAL_STATUS                  ,
                l_rec_ll_booking_data.CONT_ACTION_FLAG              ,
                l_rec_ll_booking_data.LOADING_STATUS_OLD            ,
                l_rec_ll_booking_data.LOADING_STATUS_NEW            ,
                l_rec_ll_booking_data.STOWAGE_POSITION_OLD          ,
                l_rec_ll_booking_data.STOWAGE_POSITION_NEW          ,
                l_rec_ll_booking_data.DAMAGED_OLD                   ,
                l_rec_ll_booking_data.DAMAGED_NEW                   ,
                l_rec_ll_booking_data.HANDLING_INSTRUCTION_1_OLD    ,
                l_rec_ll_booking_data.HANDLING_INSTRUCTION_1_NEW    ,
                l_rec_ll_booking_data.HANDLING_INSTRUCTION_2_OLD    ,
                l_rec_ll_booking_data.HANDLING_INSTRUCTION_2_NEW    ,
                l_rec_ll_booking_data.HANDLING_INSTRUCTION_3_OLD    ,
                l_rec_ll_booking_data.HANDLING_INSTRUCTION_3_NEW    ,
                l_rec_ll_booking_data.CONTAINER_LOADING_REM_1_OLD   ,
                l_rec_ll_booking_data.CONTAINER_LOADING_REM_1_NEW   ,
                l_rec_ll_booking_data.CONTAINER_LOADING_REM_2_OLD   ,
                l_rec_ll_booking_data.CONTAINER_LOADING_REM_2_NEW   ,
                l_rec_ll_booking_data.SPECIAL_CARGO_OLD             ,
                l_rec_ll_booking_data.SPECIAL_CARGO_NEW
            );

            g_v_sql_id := '38';
            dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
            PRE_GEN_INPUT_DATA (
                  l_tab_variables_ob_dtl_chng
                , l_arr_ob_dtl_chng_dmap_codes
                , l_arr_ob_dtl_chng_dmap_cd_val
                , l_arr_data_key_header
                , l_arr_data_value_header
                , l_arr_data_key_detail
                , l_arr_data_value_detail
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RETURN;
            END IF;

            g_v_sql_id := '39';
            dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_DETAIL_LINE (
                  l_n_enotice_request_id
                , l_arr_data_key_detail
                , l_arr_data_value_detail
                , p_i_v_add_user
                , p_i_v_add_date
                , g_v_ora_err_cd
            );

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RETURN;
            END IF;

        END LOOP;

        g_v_sql_id := '51';
        dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_sql_id);
        PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS (
              l_n_enotice_request_id
            , g_v_ora_err_cd
        );
        dbms_output.put_line('PRE_RAISE_ENOTICE_OB_DTL_CHNG~'||g_v_ora_err_cd);
        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RETURN;
        END IF;

    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_RAISE_ENOTICE_OB_DTL_CHNG');

END;

PROCEDURE PRE_DL_WRK_SRT_SYNC (
      p_i_v_discharge_list_id               VARCHAR2
    , p_i_v_equipment_seq_no                VARCHAR2
    , p_i_v_booking_id                      VARCHAR2
    , p_i_n_bussiness_key                   VARCHAR2
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

    l_excp_finish             EXCEPTION;

BEGIN

    p_o_v_error := g_v_success;

    g_v_sql_id := '40';
    PRE_RAISE_ENOTICE_DL_WRK_SRT (
          'SYNC_BATCH'
        , NULL
        , p_i_n_bussiness_key
        , p_i_v_discharge_list_id
        , p_i_v_equipment_seq_no
        , p_i_v_booking_id
        , p_i_v_add_user
        , p_i_v_add_date
        , p_o_v_error
    );

    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RAISE l_excp_finish;
    END IF;

    /* Completed Successfully */
    g_v_sql_id := '';
    g_v_usr_err_msg := 'Program finished successfully.';
    p_o_v_error := g_v_success ;

EXCEPTION
    WHEN l_excp_finish THEN

        DBMS_OUTPUT.PUT_LINE('In exception block l_excp_finish >>>');
        DBMS_OUTPUT.PUT_LINE('g_v_ora_err_cd >>> '|| g_v_ora_err_cd);
        DBMS_OUTPUT.PUT_LINE('g_v_usr_err_cd >>> '|| g_v_usr_err_cd);
        DBMS_OUTPUT.PUT_LINE('ERROR >>> '         || g_v_sql_id || ' ' || SQLERRM);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            IF (g_v_usr_err_cd <> g_v_success ) THEN
                p_o_v_error := g_v_usr_err_cd;
            ELSE
                p_o_v_error := g_v_ora_err_cd;
            END IF;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        END IF ;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('In exception block Others >>>' || g_v_sql_id);
        DBMS_OUTPUT.PUT_LINE('PRE_DL_WRK_SRT_SYNC: '|| sqlerrm);
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

END;

PROCEDURE PRE_RAISE_ENOTICE_DL_WRK_SRT (
      p_i_v_called_from                     VARCHAR2
    , p_i_v_session_id                      VARCHAR2
    , p_i_n_bussiness_key                   VARCHAR2
    , p_i_v_discharge_list_id               VARCHAR2
    , p_i_v_equipment_seq_no                VARCHAR2
    , p_i_v_booking_id                      VARCHAR2
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

    l_tab_variables_dl_wrk_start    ENOTICE_VARIABLES_TAB;

    l_n_enotice_request_id          ZND_E_NOTICE_REQUEST.PK_E_NOTICE_REQUEST_ID%TYPE;
    l_arr_dl_wrk_start_map_codes    STRING_ARRAY ;
    l_arr_dl_wrk_strt_map_cd_val    STRING_ARRAY ;

    l_arr_data_key_header           STRING_ARRAY ;
    l_arr_data_value_header         STRING_ARRAY ;
    l_arr_data_key_detail           STRING_ARRAY ;
    l_arr_data_value_detail         STRING_ARRAY ;
    L_V_CURENT_FSC ITP040.PIOFFC%TYPE; -- *1

    CURSOR l_cur_booking_data IS
        SELECT DISTINCT
              DL.FK_SERVICE                     AS "SERVICE"
            , DL.FK_VESSEL                      AS "VESSEL"
            , ITP060.VSLGNM                     AS "VSL_NAME"
            , DL.FK_VOYAGE                      AS "VOYAGE"
            , ''                                AS "PORT_VOYAGE"
            , DL.FK_DIRECTION                   AS "DIRECTION"
            , DL.DN_PORT                        AS "PORT"
            , DL.FK_PORT_SEQUENCE_NO            AS "PORT_SEQUENCE_NO"
            , BKP001.ORIGIN_FSC                 AS "ORIGIN_FSC"
            , ITP040.PIOFFC                     AS "PREVIOUS_PORT_FSC"
        FROM
               TOS_DL_DISCHARGE_LIST                DL
            ,  TOS_DL_BOOKED_DISCHARGE_TMP           BD
            , BKP001                                BKP001
            , ITP060                                ITP060
            , ITP040                                ITP040
        WHERE DL.PK_DISCHARGE_LIST_ID         = BD.FK_DISCHARGE_LIST_ID
        AND   BKP001.BABKNO                   = BD.FK_BOOKING_NO
        AND   ITP060.VSVESS                   = DL.FK_VESSEL
        AND   ITP040.PICODE                   = BD.DN_POL
        AND   BD.OPN_STATUS                   = 'UPD'
        AND   BD.SESSION_ID                   = p_i_v_session_id
        AND   p_i_v_called_from               = 'DLM_SCREEN'      -- Discharge List Maintenance Screen.
        UNION ALL
        SELECT
              DL.FK_SERVICE                     AS "SERVICE"
            , DL.FK_VESSEL                      AS "VESSEL"
            , ITP060.VSLGNM                     AS "VSL_NAME"
            , DL.FK_VOYAGE                      AS "VOYAGE"
            , ''                                AS "PORT_VOYAGE"
            , DL.FK_DIRECTION                   AS "DIRECTION"
            , DL.DN_PORT                        AS "PORT"
            , DL.FK_PORT_SEQUENCE_NO            AS "PORT_SEQUENCE_NO"
            , BKP001.ORIGIN_FSC                 AS "ORIGIN_FSC"
            , ITP040.PIOFFC                     AS "PREVIOUS_PORT_FSC"
        FROM
               TOS_DL_DISCHARGE_LIST                DL
            ,  TOS_DL_BOOKED_DISCHARGE              BD
            , BKP001                                BKP001
            , ITP060                                ITP060
            , ITP040                                ITP040
        WHERE DL.PK_DISCHARGE_LIST_ID         = BD.FK_DISCHARGE_LIST_ID
        AND   BKP001.BABKNO                   = BD.FK_BOOKING_NO
        AND   ITP060.VSVESS                   = DL.FK_VESSEL
        AND   ITP040.PICODE                   = BD.DN_POL
        AND   BD.FK_DISCHARGE_LIST_ID         = p_i_v_discharge_list_id
        AND   BD.FK_BOOKING_NO                = p_i_v_booking_id
        AND   BD.FK_BKG_EQUIPM_DTL            = p_i_v_equipment_seq_no
        AND   p_i_v_called_from               = 'SYNC_BATCH';   -- Syncronization Batch.
        L_V_EXCPEITON EXCEPTION; -- *t
        L_V_PARAMETER VARCHAR2(4000);-- *t
        L_V_ERR_MSG VARCHAR2(4000); -- *t


BEGIN
    L_V_PARAMETER := 'PRE_RAISE_ENOTICE_DL_WRK_SRT_PARAMETER~'
        ||'~'|| p_i_v_called_from
        ||'~'|| p_i_v_session_id
        ||'~'|| p_i_n_bussiness_key
        ||'~'|| p_i_v_discharge_list_id
        ||'~'|| p_i_v_equipment_seq_no
        ||'~'|| p_i_v_booking_id
        ||'~'|| p_i_v_add_user
        ||'~'|| p_i_v_add_date;

    p_o_v_error := g_v_success;

    -- Get Variables data for ENotice Tyoe :: DG Change
    g_v_sql_id := '41';
    dbms_output.put_line('PRE_RAISE_ENOTICE_DL_WRK_SRT~'||g_v_sql_id);

    PRE_GET_ENOTICE_VARIABLES(g_n_notice_type_dl_wrk_start, l_tab_variables_dl_wrk_start);

    L_V_PARAMETER := 'PRE_RAISE_ENOTICE_DL_WRK_SRT~'
        ||'~'|| g_v_sql_id
        ||'~'|| g_n_notice_type_dl_wrk_start;

    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RAISE L_V_EXCPEITON;
        RETURN;
    END IF;

    g_v_sql_id := '42';
    dbms_output.put_line('PRE_RAISE_ENOTICE_DL_WRK_SRT~'||g_v_sql_id);
    l_arr_dl_wrk_start_map_codes := STRING_ARRAY (
          'LOAD_DIS_LST'         , 'SERVICE'           , 'VESSEL'             ,
          'VSL_NAME'             , 'VOYAGE'            , 'PORT_VOYAGE'        ,
          'DIRECTION'            , 'PORT'              , 'PORT_SEQUENCE_NO'
    );

    g_v_sql_id := '43';
    dbms_output.put_line('PRE_RAISE_ENOTICE_DL_WRK_SRT~'||g_v_sql_id);
    /* *1 start * */
    /* * find the currect fsc * */
        SELECT
            I40.PIOFFC AS "CURRENT_PORT_FSC"
        INTO
            L_V_CURENT_FSC
        FROM
            TOS_DL_DISCHARGE_LIST DL,
            ITP040 I40
        WHERE
            I40.PICODE = DL.DN_PORT
            AND DL.PK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID;
    /* *1 end * */

    For l_rec_booking_data IN l_cur_booking_data
    LOOP

        g_v_sql_id := '44';
        dbms_output.put_line('PRE_RAISE_ENOTICE_DL_WRK_SRT~'||g_v_sql_id);
        l_arr_dl_wrk_strt_map_cd_val := STRING_ARRAY (
              'D'                                      , l_rec_booking_data.SERVICE
            , l_rec_booking_data.VESSEL                , l_rec_booking_data.VSL_NAME
            , l_rec_booking_data.VOYAGE                , l_rec_booking_data.PORT_VOYAGE
            , l_rec_booking_data.DIRECTION             , l_rec_booking_data.PORT
            , l_rec_booking_data.PORT_SEQUENCE_NO
        );

        g_v_sql_id := '45';
        PRE_GEN_INPUT_DATA (
              l_tab_variables_dl_wrk_start
            , l_arr_dl_wrk_start_map_codes
            , l_arr_dl_wrk_strt_map_cd_val
            , l_arr_data_key_header
            , l_arr_data_value_header
            , l_arr_data_key_detail
            , l_arr_data_value_detail
        );

        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_DL_WRK_SRT~'
            ||'~'|| g_v_sql_id;

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE L_V_EXCPEITON;RAISE L_V_EXCPEITON;
            RETURN;
        END IF;

        g_v_sql_id := '46';
        dbms_output.put_line('PRE_RAISE_ENOTICE_DL_WRK_SRT~'||g_v_sql_id);
        PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_REQUEST (
              l_n_enotice_request_id
            , p_i_n_bussiness_key
            , g_n_notice_type_dl_wrk_start
            , l_arr_data_key_header
            , l_arr_data_value_header
            , l_rec_booking_data.ORIGIN_FSC
            , p_i_v_add_user
            , p_i_v_add_date
            , g_v_ora_err_cd
        );
        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_DL_WRK_SRT~'
            ||'~'|| g_v_sql_id;

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE L_V_EXCPEITON;
            RETURN;
        END IF;

        g_v_sql_id := '47';
        dbms_output.put_line('PRE_RAISE_ENOTICE_DL_WRK_SRT~'||g_v_sql_id);

        PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
              l_n_enotice_request_id
            , 'F'
            , l_rec_booking_data.PREVIOUS_PORT_FSC
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , 'N'
            , p_i_v_add_user
            , p_i_v_add_date
            , g_v_ora_err_cd
        );
        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_DL_WRK_SRT~'
            ||'~'|| g_v_sql_id
            ||'~'|| l_n_enotice_request_id
            ||'~'|| l_rec_booking_data.PREVIOUS_PORT_FSC
            ||'~'|| p_i_v_add_user;


        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE L_V_EXCPEITON;
            RETURN;
        END IF;

        /* *1 start * */
        /* * set reciepient of the mail * */
        PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
              l_n_enotice_request_id
            , 'F'
            , L_V_CURENT_FSC
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , 'N'
            , p_i_v_add_user
            , p_i_v_add_date
            , g_v_ora_err_cd
        );

        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_DL_WRK_SRT~'
            ||'~'|| g_v_sql_id
            ||'~'|| L_V_CURENT_FSC;

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE L_V_EXCPEITON;
            RETURN;
        END IF;
        /* *1 end  * */

        g_v_sql_id := '52';
        dbms_output.put_line('PRE_RAISE_ENOTICE_DL_WRK_SRT~'||g_v_sql_id);
        PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS (
              l_n_enotice_request_id
            , g_v_ora_err_cd
        );

        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_DL_WRK_SRT~'
            ||'~'|| g_v_sql_id;

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE L_V_EXCPEITON;
            RETURN;
        END IF;

    END LOOP;

EXCEPTION
    WHEN L_V_EXCPEITON THEN
        NULL;
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        L_V_ERR_MSG := SQLERRM;
        dbms_output.put_line('123~~~'|| g_v_sql_id ||'~'|| L_V_ERR_MSG);
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_RAISE_ENOTICE_DL_WRK_SRT');
END;

PROCEDURE PRE_CONT_CHNG_SYNC (
      p_i_v_discharge_list_id               VARCHAR2
    , p_i_v_equipment_seq_no                VARCHAR2
    , p_i_v_booking_id                      VARCHAR2
    , p_i_n_bussiness_key                   VARCHAR2
    , p_i_v_old_equipment_no                VARCHAR2
    , p_i_v_new_equipment_no                VARCHAR2
    , p_i_v_cont_action_flag                VARCHAR2
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
) IS

    l_tab_variables_cont_chng       ENOTICE_VARIABLES_TAB;

    l_n_enotice_request_id          ZND_E_NOTICE_REQUEST.PK_E_NOTICE_REQUEST_ID%TYPE;
    l_arr_cont_chng_map_codes       STRING_ARRAY ;
    l_arr_cont_chng_map_cd_val      STRING_ARRAY ;

    l_arr_data_key_header           STRING_ARRAY ;
    l_arr_data_value_header         STRING_ARRAY ;
    l_arr_data_key_detail           STRING_ARRAY ;
    l_arr_data_value_detail         STRING_ARRAY ;

    L_V_EXCPEITON EXCEPTION; -- *t
    L_V_PARAMETER VARCHAR2(4000);-- *t

    CURSOR l_cur_booking_data IS
        SELECT
              DL.FK_SERVICE                     AS "SERVICE"
            , DL.FK_VESSEL                      AS "VESSEL"
            , ITP060.VSLGNM                     AS "VSL_NAME"
            , DL.FK_VOYAGE                      AS "VOYAGE"
            , ''                                AS "PORT_VOYAGE"
            , DL.FK_DIRECTION                   AS "DIRECTION"
            , DL.DN_PORT                        AS "PORT"
            , DL.FK_PORT_SEQUENCE_NO            AS "PORT_SEQUENCE_NO"
            , DECODE(   p_i_v_cont_action_flag
                      , 'A'
                      , NULL
                      , 'D'
                      , BD.DN_EQUIPMENT_NO
                      , p_i_v_old_equipment_no) AS "EQUIPMENT_NO_OLD"
            , DECODE(   p_i_v_cont_action_flag
                      , 'A'
                      , BD.DN_EQUIPMENT_NO
                      , 'D'
                      , NULL
                      , p_i_v_new_equipment_no) AS "EQUIPMENT_NO_NEW"
            , BD.FK_BOOKING_NO                  AS "BOOKING_NO"
            , BD.DN_EQ_SIZE                     AS "EQ_SIZE"
            , BD.DN_EQ_TYPE                     AS "EQ_TYPE"
            , BD.DN_SOC_COC                     AS "SOC_COC"
            , BD.DN_FULL_MT                     AS "FULL_MT"
            , BD.LOAD_CONDITION                 AS "LOAD_CONDITION"
            , DECODE (  p_i_v_cont_action_flag
                      , 'A'
                      , 'Added'
                      , 'U'
                      , 'Updated'
                      , 'D'
                      , 'Removed'
                      )                         AS "CONT_ACTION_FLAG"
            , BKP001.ORIGIN_FSC                 AS "ORIGIN_FSC"
            , BKP001.BAOFFC                     AS "BOOKING_FSC"
        FROM
               TOS_DL_DISCHARGE_LIST                DL
            ,  TOS_DL_BOOKED_DISCHARGE              BD
            , BKP001                                BKP001
            , ITP060                                ITP060
        WHERE DL.PK_DISCHARGE_LIST_ID         = BD.FK_DISCHARGE_LIST_ID
        AND   BKP001.BABKNO                   = BD.FK_BOOKING_NO
        AND   ITP060.VSVESS                   = DL.FK_VESSEL
        AND   BD.FK_DISCHARGE_LIST_ID         = p_i_v_discharge_list_id
        AND   BD.FK_BOOKING_NO                = p_i_v_booking_id
        AND   BD.FK_BKG_EQUIPM_DTL            = p_i_v_equipment_seq_no;   -- Syncronization Batch.

    /* *9 start * */

    /* * cursor to get receipient FSC * */
    CURSOR L_CUR_FSC_DATE IS
        SELECT
            DISTINCT PIOFFC AS "FSC"
        FROM
            ITP040 I, (
                SELECT
                    LL.DN_PORT AS "PORT"
                FROM
                    VASAPPS.TOS_LL_LOAD_LIST LL,
                    VASAPPS.TOS_LL_BOOKED_LOADING BL
                WHERE
                    BL.FK_LOAD_LIST_ID        = LL.PK_LOAD_LIST_ID
                    AND BL.FK_BOOKING_NO      = P_I_V_BOOKING_ID
                    AND BL.RECORD_STATUS      = LL.RECORD_STATUS
                    AND BL.RECORD_STATUS      = 'A'
                    AND ((LL.LOAD_LIST_STATUS = '10') OR
                        (LL.LOAD_LIST_STATUS  = '20') OR
                        (LL.LOAD_LIST_STATUS  = '30'))

                UNION

                SELECT
                    DL.DN_PORT AS "PORT"
                FROM
                    VASAPPS.TOS_DL_DISCHARGE_LIST DL,
                    VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
                WHERE
                    BD.FK_DISCHARGE_LIST_ID        = DL.PK_DISCHARGE_LIST_ID
                    AND BD.FK_BOOKING_NO           = P_I_V_BOOKING_ID
                    AND BD.RECORD_STATUS           = DL.RECORD_STATUS
                    AND BD.RECORD_STATUS           = 'A'
                    AND ((DL.DISCHARGE_LIST_STATUS = '10') OR
                        (DL.DISCHARGE_LIST_STATUS  = '20') OR
                        (DL.DISCHARGE_LIST_STATUS  = '30'))
            ) TAB
        WHERE
            TAB.PORT = I.PICODE;

--    L_V_FSC VARCHAR2(5);
    /* *9 end * */
BEGIN

    p_o_v_error := g_v_success;

    -- Get Variables data for ENotice Tyoe :: DG Change
    g_v_sql_id := '53';
    dbms_output.put_line(g_v_sql_id);
    PRE_GET_ENOTICE_VARIABLES(g_n_notice_type_cont_chng, l_tab_variables_cont_chng);
    L_V_PARAMETER := g_v_ora_err_cd;

    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RAISE l_v_excpeiton; --* t
        RETURN;
    END IF;

    g_v_sql_id := '54';
    dbms_output.put_line(g_v_sql_id);
    l_arr_cont_chng_map_codes := STRING_ARRAY (
        'LOAD_DIS_LST'         , 'SERVICE'           , 'VESSEL'             ,
        'VSL_NAME'             , 'VOYAGE'            , 'PORT_VOYAGE'        ,
        'DIRECTION'            , 'PORT'              , 'PORT_SEQUENCE_NO'   ,
        'EQUIPMENT_NO'         , 'EQUIPMENT_NO_OLD'  , 'BOOKING_NO'         ,
        'EQ_SIZE'              , 'EQ_TYPE'           , 'SOC_COC'            ,
        'FULL_MT'              , 'LOAD_CONDITION'    , 'CONT_ACTION_FLAG'
    );

    g_v_sql_id := '55';
    dbms_output.put_line(g_v_sql_id);
    For l_rec_booking_data IN l_cur_booking_data
    LOOP
        g_v_sql_id := '56';
        dbms_output.put_line(g_v_sql_id);

        l_arr_cont_chng_map_cd_val := STRING_ARRAY (
              'D'                                      , l_rec_booking_data.SERVICE
            , l_rec_booking_data.VESSEL                , l_rec_booking_data.VSL_NAME
            , l_rec_booking_data.VOYAGE                , l_rec_booking_data.PORT_VOYAGE
            , l_rec_booking_data.DIRECTION             , l_rec_booking_data.PORT
            , l_rec_booking_data.PORT_SEQUENCE_NO      , l_rec_booking_data.EQUIPMENT_NO_NEW
            , l_rec_booking_data.EQUIPMENT_NO_OLD      , l_rec_booking_data.BOOKING_NO
            , l_rec_booking_data.EQ_SIZE               , l_rec_booking_data.EQ_TYPE
            , l_rec_booking_data.SOC_COC               , l_rec_booking_data.FULL_MT
            , l_rec_booking_data.LOAD_CONDITION        , l_rec_booking_data.CONT_ACTION_FLAG
        );

        g_v_sql_id := '57';
        dbms_output.put_line(g_v_sql_id);
        PRE_GEN_INPUT_DATA (
              l_tab_variables_cont_chng
            , l_arr_cont_chng_map_codes
            , l_arr_cont_chng_map_cd_val
            , l_arr_data_key_header
            , l_arr_data_value_header
            , l_arr_data_key_detail
            , l_arr_data_value_detail
        );

        L_V_PARAMETER := g_v_ora_err_cd;

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_v_excpeiton; --* t
            RETURN;
        END IF;

        g_v_sql_id := '58';
        dbms_output.put_line(g_v_sql_id);
        PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_REQUEST (
              l_n_enotice_request_id
            , p_i_n_bussiness_key
            , g_n_notice_type_cont_chng
            , l_arr_data_key_header
            , l_arr_data_value_header
            , l_rec_booking_data.ORIGIN_FSC
            , p_i_v_add_user
            , p_i_v_add_date
            , g_v_ora_err_cd
        );
        L_V_PARAMETER := l_n_enotice_request_id
            ||'~'|| g_v_ora_err_cd;

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_v_excpeiton; --* t
            RETURN;
        END IF;

        DBMS_OUTPUT.PUT_LINE('POPULATING FSC');

--        BEGIN
--            SELECT
--                DISTINCT PIOFFC AS "FSC"
--            INTO
--                L_V_FSC
--            FROM
--                ITP040 I, (
--                    SELECT
--                        LL.DN_PORT AS "PORT"
--                    FROM
--                        VASAPPS.TOS_LL_LOAD_LIST LL,
--                        VASAPPS.TOS_LL_BOOKED_LOADING BL
--                    WHERE
--                        BL.FK_LOAD_LIST_ID        = LL.PK_LOAD_LIST_ID
--                        AND BL.FK_BOOKING_NO      = P_I_V_BOOKING_ID
--                        AND BL.RECORD_STATUS      = LL.RECORD_STATUS
--                        AND BL.RECORD_STATUS      = 'A'
--                        AND ((LL.LOAD_LIST_STATUS = '10') OR
--                            (LL.LOAD_LIST_STATUS  = '20') OR
--                            (LL.LOAD_LIST_STATUS  = '30'))
--
--                    UNION
--
--                    SELECT
--                        DL.DN_PORT AS "PORT"
--                    FROM
--                        VASAPPS.TOS_DL_DISCHARGE_LIST DL,
--                        VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
--                    WHERE
--                        BD.FK_DISCHARGE_LIST_ID        = DL.PK_DISCHARGE_LIST_ID
--                        AND BD.FK_BOOKING_NO           = P_I_V_BOOKING_ID
--                        AND BD.RECORD_STATUS           = DL.RECORD_STATUS
--                        AND BD.RECORD_STATUS           = 'A'
--                        AND ((DL.DISCHARGE_LIST_STATUS = '10') OR
--                            (DL.DISCHARGE_LIST_STATUS  = '20') OR
--                            (DL.DISCHARGE_LIST_STATUS  = '30'))
--                ) TAB
--            WHERE
--                TAB.PORT = I.PICODE;
--        EXCEPTION
--            WHEN OTHERS THEN
--                DBMS_OUTPUT.PUT_LINE('BOOKING: ' || P_I_V_BOOKING_ID);
--                DBMS_OUTPUT.PUT_LINE(SQLERRM);
--        END;
--        DBMS_OUTPUT.PUT_LINE(L_V_FSC);
--

        /* *9 start * */
        FOR L_VAR_CUR_FSC_DATE IN L_CUR_FSC_DATE LOOP
        g_v_sql_id := '59';
            dbms_output.put_line(g_v_sql_id);

        PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
              l_n_enotice_request_id
            , 'F'
                , L_VAR_CUR_FSC_DATE.FSC
            , NULL
            , NULL
            , NULL
            , NULL
            , NULL
            , 'N'
            , p_i_v_add_user
            , p_i_v_add_date
            , g_v_ora_err_cd
        );
        L_V_PARAMETER := l_n_enotice_request_id
            ||'~'|| 'F'
                ||'~'|| L_VAR_CUR_FSC_DATE.FSC
            ||'~'|| ''
            ||'~'|| ''
            ||'~'|| ''
            ||'~'|| ''
            ||'~'|| ''
            ||'~'|| 'N'
            ||'~'|| p_i_v_add_user
            ||'~'|| p_i_v_add_date
            ||'~'|| g_v_ora_err_cd;

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_v_excpeiton; --* t
            RETURN;
        END IF;

        END LOOP;

--        g_v_sql_id := '59';

--
--        PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
--              l_n_enotice_request_id
--            , 'F'
--            , l_rec_booking_data.BOOKING_FSC
--            , NULL
--            , NULL
--            , NULL
--            , NULL
--            , NULL
--            , 'N'
--            , p_i_v_add_user
--            , p_i_v_add_date
--            , g_v_ora_err_cd
--        );
--        L_V_PARAMETER := l_n_enotice_request_id
--            ||'~'|| 'F'
--            ||'~'|| l_rec_booking_data.BOOKING_FSC
--            ||'~'|| ''
--            ||'~'|| ''
--            ||'~'|| ''
--            ||'~'|| ''
--            ||'~'|| ''
--            ||'~'|| 'N'
--            ||'~'|| p_i_v_add_user
--            ||'~'|| p_i_v_add_date
--            ||'~'|| g_v_ora_err_cd;
--
--        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
--            RAISE l_v_excpeiton; --* t
--            RETURN;
--        END IF;
        /* *9 end * */

        g_v_sql_id := '60';
        dbms_output.put_line(g_v_sql_id);

        PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS (
              l_n_enotice_request_id
            , g_v_ora_err_cd
        );
        L_V_PARAMETER := l_n_enotice_request_id
            ||'~'|| g_v_ora_err_cd;

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_v_excpeiton; --* t
            RETURN;
        END IF;

    END LOOP;
EXCEPTION
    WHEN l_v_excpeiton THEN
        NULL;
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_RAISE_ENOTICE_DL_WRK_SRT');
END;

    /* *3 start * */
    PROCEDURE PRE_ENOTICE_BL_SURRENDER (
          P_I_V_BL_NUMBER        VARCHAR2
        , P_I_V_CHANGE_USER      VARCHAR2
        , P_I_V_BL_SURRENDER_FSC VARCHAR2
        , P_I_V_CHANGE_DATE      VARCHAR2
        , P_O_V_ERROR            OUT NOCOPY VARCHAR2
    )
    IS

        L_TAB_VARIABLES_BL_SURRENDER ENOTICE_VARIABLES_TAB;
        L_N_ENOTICE_REQUEST_ID       ZND_E_NOTICE_REQUEST.PK_E_NOTICE_REQUEST_ID%TYPE;
        L_ARR_BL_SURRENDER_MAP_CODES STRING_ARRAY ;
        L_ARR_BL_SUR_STRT_MAP_CD_VAL STRING_ARRAY ;
        L_ARR_DATA_KEY_HEADER        STRING_ARRAY ;
        L_ARR_DATA_VALUE_HEADER      STRING_ARRAY ;
        L_ARR_DATA_KEY_DETAIL        STRING_ARRAY ;
        L_ARR_DATA_VALUE_DETAIL      STRING_ARRAY ;
        L_V_CURENT_FSC               ITP040.PIOFFC%TYPE; -- *1
        L_V_FIRST_LEG_VESSEL         ITP060.VSLGNM%TYPE;
        L_V_FIRST_LEG_VOYAGE         varchar2(50);--IDP005.VOYAGE%TYPE; --*5
        L_V_POL                      IDP005.LOAD_PORT%TYPE;
        L_V_POD                      IDP005.DISCHARGE_PORT%TYPE;
        L_V_SECOND_LEG_VESSEL        ITP060.VSLGNM%TYPE;
        L_V_SECOND_LEG_VOYAGE        IDP005.VOYAGE%TYPE;
        L_V_THIRD_LEG_VESSEL         ITP060.VSLGNM%TYPE;
        L_V_THIRD_LEG_VOYAGE         IDP005.VOYAGE%TYPE;
        L_V_SHIPPER_NAME             IDP030.CYNAME%TYPE;
        L_V_CNEE_NAME                IDP030.CYNAME%TYPE;
        L_V_NTFY_NAME                IDP030.CYNAME%TYPE;
        L_V_SURRENDER_LOCATION       ITP188.CRDESC%TYPE;
        L_V_TO_EXPORT_IMPORT         VARCHAR2(10);
        L_V_TO_FSC                   ITP040.PIOFFC%TYPE;
        L_V_FRM_FSC                  ITP040.PIOFFC%TYPE;
        L_V_FRM_EXPORT_IMPORT        VARCHAR2(10);
        L_V_CC_EXPORT_IMPORT         VARCHAR2(10);
        L_V_CC_INFORMATION           VARCHAR2(200);
        L_V_CC_FSC                   ITP040.PIOFFC%TYPE;
        -- L_V_FREIGHT_TERM             ITP188.CRDESC%TYPE;
        L_V_FREIGHT_TERM             VARCHAR2(200);
        L_V_POL_fSC                  ITP040.PIOFFC%TYPE;
        L_V_POD_fSC                  ITP040.PIOFFC%TYPE;
        L_V_LOGIN_USER_FSC           ITP040.PIOFFC%TYPE;
        L_V_ERROR                    VARCHAR2(4000);
        L_V_PARAMETER                VARCHAR2(4000);
        L_V_ERR_MSG                  VARCHAR2(4000);
        L_V_EXCPEITON                EXCEPTION;


    BEGIN
        G_V_SQL_ID := 'SQL-A-01';

        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_BL_SUR_SRT~'
            ||'~'|| P_I_V_BL_NUMBER
            ||'~'|| P_I_V_CHANGE_USER
            ||'~'|| P_I_V_BL_SURRENDER_FSC
            ||'~'|| P_I_V_CHANGE_DATE;

        G_V_SQL_ID := 'SQL-A-02';

        P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        G_V_ORA_ERR_CD := g_v_success; -- *13
        G_V_USR_ERR_CD := g_v_success; -- *13

        dbms_output.put_line('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||g_v_sql_id);

        G_V_SQL_ID := 'SQL-A-03';
        dbms_output.put_line('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||g_v_sql_id);

        /* * get variable details * */
        PRE_GET_ENOTICE_VARIABLES(g_n_notice_type_bl_surrender, l_tab_variables_bl_surrender);

        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_BL_SUR_SRT~'
            ||'~'|| g_v_sql_id
            ||'~'|| g_n_notice_type_bl_surrender;

        G_V_SQL_ID := 'SQL-A-04';

        dbms_output.put_line('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||g_v_sql_id);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            P_O_V_ERROR := 'Exception in calling PRE_GET_ENOTICE_VARIABLES: ';
            -- P_O_V_ERROR := sqlerrm;

            RAISE L_V_EXCPEITON;
        END IF;

        G_V_SQL_ID := 'SQL-A-05';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        /* * get veriable details from the BL table * */
        PRE_GET_BL_MAIL_DETAILS(
            P_I_V_BL_NUMBER,
            P_I_V_CHANGE_USER,
            P_I_V_BL_SURRENDER_FSC,
            L_V_FIRST_LEG_VESSEL,
            L_V_FIRST_LEG_VOYAGE,
            L_V_POL,
            L_V_POD,
            L_V_SECOND_LEG_VESSEL,
            L_V_SECOND_LEG_VOYAGE,
            L_V_THIRD_LEG_VESSEL,
            L_V_THIRD_LEG_VOYAGE,
            L_V_SHIPPER_NAME,
            L_V_CNEE_NAME,
            L_V_NTFY_NAME,
            L_V_SURRENDER_LOCATION,
            L_V_TO_EXPORT_IMPORT,
            L_V_TO_FSC,
            L_V_FRM_FSC,
            L_V_FRM_EXPORT_IMPORT,
            L_V_CC_INFORMATION,
            L_V_FREIGHT_TERM,
            L_V_POL_fSC,
            L_V_POD_fSC,
            L_V_LOGIN_USER_FSC,
            P_O_V_ERROR
        );

        IF P_O_V_ERROR <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
            RAISE L_V_EXCPEITON;
        END IF;

        G_V_SQL_ID := 'SQL-A-06';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        /* * set header key values * */
        L_ARR_BL_SURRENDER_MAP_CODES := STRING_ARRAY (
            'FIRST_LEG_VESSEL',
            'FIRST_LEG_VOYAGE',
            'POL',
            'POD',
            'SECOND_LEG_VESSEL',
            'SECOND_LEG_VOYAGE',
            'THIRD_LEG_VESSEL',
            'THIRD_LEG_VOYAGE',
            'SHIPPER_NAME',
            'CNEE_NAME',
            'NTFY_NAME',
            'SURRENDER_LOCATION',
            'TO_EXPORT_IMPORT',
            'TO_FSC',
            'FRM_FSC',
            'FRM_EXPORT_IMPORT',
            'CC_INFORMATION',
            'FREIGHT_TERM',
            'POL_FSC',
            'POD_FSC',
            'LOGIN_USER_FSC',
            'BL_NUMBER'
        );

        G_V_SQL_ID := 'SQL-A-07';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        /* * set value for the header key * */
        L_ARR_BL_SUR_STRT_MAP_CD_VAL := STRING_ARRAY (
            L_V_FIRST_LEG_VESSEL,
            L_V_FIRST_LEG_VOYAGE,
            L_V_POL,
            L_V_POD,
            L_V_SECOND_LEG_VESSEL,
            L_V_SECOND_LEG_VOYAGE,
            L_V_THIRD_LEG_VESSEL,
            L_V_THIRD_LEG_VOYAGE,
            L_V_SHIPPER_NAME,
            L_V_CNEE_NAME,
            L_V_NTFY_NAME,
            L_V_SURRENDER_LOCATION,
            L_V_TO_EXPORT_IMPORT,
            L_V_TO_FSC,
            L_V_FRM_FSC,
            L_V_FRM_EXPORT_IMPORT,
            L_V_CC_INFORMATION,
            L_V_FREIGHT_TERM,
            L_V_POL_FSC,
            L_V_POD_FSC,
            L_V_LOGIN_USER_FSC,
            P_I_V_BL_NUMBER
        );

        DBMS_OUTPUT.PUT_LINE('VARIABLE VALUE'
            ||'~'|| P_I_V_BL_NUMBER
            ||'~'|| P_I_V_CHANGE_USER
            ||'~'|| P_I_V_BL_SURRENDER_FSC
            ||'~'|| L_V_FIRST_LEG_VESSEL
            ||'~'|| L_V_FIRST_LEG_VOYAGE
            ||'~'|| L_V_POL
            ||'~'|| L_V_POD
            ||'~'|| L_V_SECOND_LEG_VESSEL
            ||'~'|| L_V_SECOND_LEG_VOYAGE
            ||'~'|| L_V_THIRD_LEG_VESSEL
            ||'~'|| L_V_THIRD_LEG_VOYAGE
            ||'~'|| L_V_SHIPPER_NAME
            ||'~'|| L_V_CNEE_NAME
            ||'~'|| L_V_NTFY_NAME
            ||'~'|| L_V_SURRENDER_LOCATION
            ||'~'|| L_V_TO_EXPORT_IMPORT
            ||'~'|| L_V_TO_FSC
            ||'~'|| L_V_FRM_FSC
            ||'~'|| L_V_FRM_EXPORT_IMPORT
            ||'~'|| L_V_CC_INFORMATION
            ||'~'|| L_V_FREIGHT_TERM
            ||'~'|| L_V_POL_fSC
            ||'~'|| L_V_POD_fSC
            ||'~'|| L_V_LOGIN_USER_FSC
            ||'~'|| P_O_V_ERROR);

        G_V_SQL_ID := 'SQL-A-08';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        /* * get input data into key-value pair * */
        PRE_GEN_INPUT_DATA (
              L_TAB_VARIABLES_BL_SURRENDER
            , L_ARR_BL_SURRENDER_MAP_CODES
            , L_ARR_BL_SUR_STRT_MAP_CD_VAL
            , L_ARR_DATA_KEY_HEADER
            , L_ARR_DATA_VALUE_HEADER
            , L_ARR_DATA_KEY_DETAIL
            , L_ARR_DATA_VALUE_DETAIL
        );

        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_BL_SUR_SRT~'
            ||'~'|| g_v_sql_id;

        G_V_SQL_ID := 'SQL-A-09';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            P_O_V_ERROR := 'Error in getting variable input data';
            RAISE L_V_EXCPEITON;
        END IF;

        G_V_SQL_ID := 'SQL-A-10';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        /* * generate request for enotice * */
        PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_REQUEST (
              L_N_ENOTICE_REQUEST_ID
            , 11 -- not used
            , G_N_NOTICE_TYPE_BL_SURRENDER
            , L_ARR_DATA_KEY_HEADER
            , L_ARR_DATA_VALUE_HEADER
            /* , L_V_LOGIN_USER_FSC */ /* *11 */
            , 'xyz' /* *11 */ /* no need to populate originating fsc */
            , P_I_V_CHANGE_USER
            , P_I_V_CHANGE_DATE
            , G_V_ORA_ERR_CD
        );
        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_BL_SUR_SRT~'
            ||'~'|| g_v_sql_id;

        G_V_SQL_ID := 'SQL-A-11';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            P_O_V_ERROR := 'Error in generating enotice request';
            RAISE L_V_EXCPEITON;
        END IF;

        G_V_SQL_ID := 'SQL-A-12';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);


        /* IF L_V_POL_FSC <> L_V_LOGIN_USER_FSC THEN /* *11 *
        */

            /* * set receipient for POL */
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
                  L_N_ENOTICE_REQUEST_ID
                , 'F'
                , L_V_POL_FSC
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , 'N'
                , P_I_V_CHANGE_USER
                , P_I_V_CHANGE_DATE
                , G_V_ORA_ERR_CD
            );
            L_V_PARAMETER := 'PRE_RAISE_ENOTICE_BL_SUR_SRT~'
                ||'~'|| g_v_sql_id
                ||'~'|| l_n_enotice_request_id
                ||'~'|| L_V_POL_FSC
                ||'~'|| P_I_V_CHANGE_USER;
        /* END IF; /* *11 * */

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            P_O_V_ERROR := 'Exception in getting mail receipient details';
            RAISE L_V_EXCPEITON;
        END IF;

        G_V_SQL_ID := 'SQL-A-13';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        /* IF L_V_POD_FSC <> L_V_LOGIN_USER_FSC THEN /* *11 * */
            /* * set receipient for POD */
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
                  L_N_ENOTICE_REQUEST_ID
                , 'F'
                , L_V_POD_FSC
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , 'N'
                , P_I_V_CHANGE_USER
                , P_I_V_CHANGE_DATE
                , G_V_ORA_ERR_CD
            );

            L_V_PARAMETER := 'PRE_RAISE_ENOTICE_BL_SUR_SRT~'
                ||'~'|| g_v_sql_id
                ||'~'|| L_V_POD_FSC;
        /* END IF; /* *11 * */

        G_V_SQL_ID := 'SQL-A-14';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            P_O_V_ERROR := 'Exception in getting mail receipient details';
            RAISE L_V_EXCPEITON;
        END IF;


        /*-- **7 for 3rd Location by WACCHO1 --*/
        IF (L_V_LOGIN_USER_FSC <> L_V_POD_FSC) AND (L_V_LOGIN_USER_FSC <> L_V_POL_FSC) THEN
            G_V_SQL_ID := 'SQL-A-14-1';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

            /* * set receipient for 3rd location */
            PCE_ECM_ENOTICE.PRE_GEN_ENOTICE_RCV_ORG (
                  L_N_ENOTICE_REQUEST_ID
                , 'F'
                , L_V_LOGIN_USER_FSC
                , NULL
                , NULL
                , NULL
                , NULL
                , NULL
                , 'N'
                , P_I_V_CHANGE_USER
                , P_I_V_CHANGE_DATE
                , G_V_ORA_ERR_CD
            );

            L_V_PARAMETER := 'PRE_RAISE_ENOTICE_BL_SUR_SRT~'
                ||'~'|| g_v_sql_id
                ||'~'|| L_V_LOGIN_USER_FSC;

            G_V_SQL_ID := 'SQL-A-14-2';
            DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                P_O_V_ERROR := 'Exception in getting mail receipient details';
                RAISE L_V_EXCPEITON;
            END IF;
        END IF ;
        /*-- **7 for 3rd Location by WACCHO1 --*/



        G_V_SQL_ID := 'SQL-A-15';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        dbms_output.put_line('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||g_v_sql_id);

        -- Myo Trace BL Surrender Error : START 20130204
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG('BLS Trace',
                'ERAISER',
                'M',
                P_I_V_BL_NUMBER || '-ENOTICE_REQUEST_ID: ' || L_N_ENOTICE_REQUEST_ID,
                'A',
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_I_V_CHANGE_USER,
                SYSDATE,
                'MYO',
                NULL
           );
        COMMIT;
        -- Myo Trace BL Surrender Error : END 20130204

        /* * populate mail data in ZND_E_NOTICE table * */
        PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS (
              L_N_ENOTICE_REQUEST_ID
            , G_V_ORA_ERR_CD
        );

        L_V_PARAMETER := 'PRE_RAISE_ENOTICE_BL_SUR_SRT~'
            ||'~'|| g_v_sql_id;

        G_V_SQL_ID := 'SQL-A-16';
        DBMS_OUTPUT.PUT_LINE('PRE_RAISE_ENOTICE_BL_SUR_SRT~'||G_V_SQL_ID);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            P_O_V_ERROR := 'Exception in preparing mail content';
            RAISE L_V_EXCPEITON;
        END IF;

    EXCEPTION
        WHEN L_V_EXCPEITON THEN
            DBMS_OUTPUT.PUT_LINE('EXCEPTION IN PCE_ECM_RAISE_ENOTICE.PRE_ENOTICE_BL_SURRENDER');
            DBMS_OUTPUT.PUT_LINE('G_V_SQL_ID~'||G_V_SQL_ID);
            DBMS_OUTPUT.PUT_LINE('L_V_PARAMETER~'||L_V_PARAMETER);
            DBMS_OUTPUT.PUT_LINE('P_O_V_ERROR~'||P_O_V_ERROR);

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                L_V_PARAMETER,
                'MAIL_TRIG-1',
                'M',
                P_O_V_ERROR,
                'A',
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_I_V_CHANGE_USER,
                SYSDATE,
                /* g_v_ora_err_cd */ /* *13 */
                G_V_SQL_ID||'~'||g_v_ora_err_cd||'~'||g_v_ora_err_msg, /* *13 */
                P_O_V_ERROR
           );
           COMMIT;


        WHEN OTHERS THEN
            G_V_ORA_ERR_CD  := SQLCODE;
            L_V_ERR_MSG := SQLERRM;
            g_v_ora_err_msg := SQLERRM; -- *13
            P_O_V_ERROR := G_V_SQL_ID||'~'||SQLERRM;

            DBMS_OUTPUT.PUT_LINE('EXCEPTION IN PCE_ECM_RAISE_ENOTICE.PRE_ENOTICE_BL_SURRENDER');
            DBMS_OUTPUT.PUT_LINE('G_V_SQL_ID~'||G_V_SQL_ID);
            DBMS_OUTPUT.PUT_LINE('L_V_PARAMETER~'||L_V_PARAMETER);
            DBMS_OUTPUT.PUT_LINE('G_V_ORA_ERR_CD~'||g_v_ora_err_cd);
            DBMS_OUTPUT.PUT_LINE('L_V_ERR_MSG~'||L_V_ERR_MSG);
            DBMS_OUTPUT.PUT_LINE('P_O_V_ERROR~'||P_O_V_ERROR);

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                'MAIL_TRIG-2',
                'M',
                P_O_V_ERROR,
                'A',
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_I_V_CHANGE_USER,
                SYSDATE,
                /* g_v_ora_err_cd */ /* *13 */
                G_V_SQL_ID||'~'||g_v_ora_err_cd||'~'||g_v_ora_err_msg, /* *13 */
                P_O_V_ERROR
           );
           COMMIT;


    END PRE_ENOTICE_BL_SURRENDER;

    PROCEDURE PRE_GET_BL_MAIL_DETAILS(
        P_I_V_BL_NUMBER          VARCHAR2,
        P_I_V_CHANGE_USER        VARCHAR2,
        P_I_V_BL_SURRENDER_FSC   VARCHAR2,
        P_O_V_FIRST_LEG_VESSEL   OUT NOCOPY VARCHAR2,
        P_O_V_FIRST_LEG_VOYAGE   OUT NOCOPY VARCHAR2,
        P_O_V_POL                OUT NOCOPY VARCHAR2,
        P_O_V_POD                OUT NOCOPY VARCHAR2,
        P_O_V_SECOND_LEG_VESSEL  OUT NOCOPY VARCHAR2,
        P_O_V_SECOND_LEG_VOYAGE  OUT NOCOPY VARCHAR2,
        P_O_V_THIRD_LEG_VESSEL   OUT NOCOPY VARCHAR2,
        P_O_V_THIRD_LEG_VOYAGE   OUT NOCOPY VARCHAR2,
        P_O_V_SHIPPER_NAME       OUT NOCOPY VARCHAR2,
        P_O_V_CNEE_NAME          OUT NOCOPY VARCHAR2,
        P_O_V_NTFY_NAME          OUT NOCOPY VARCHAR2,
        P_O_V_SURRENDER_LOCATION OUT NOCOPY VARCHAR2,
        P_O_V_TO_EXPORT_IMPORT   OUT NOCOPY VARCHAR2,
        P_O_V_TO_FSC             OUT NOCOPY VARCHAR2,
        P_O_V_FRM_FSC            OUT NOCOPY VARCHAR2,
        P_O_V_FRM_EXPORT_IMPORT  OUT NOCOPY VARCHAR2,
        P_O_V_CC_INFORMATION     OUT NOCOPY VARCHAR2,
        P_O_V_FREIGHT_TERM       OUT NOCOPY VARCHAR2,
        P_O_V_POL_FSC            OUT NOCOPY VARCHAR2,
        P_O_V_POD_FSC            OUT NOCOPY VARCHAR2,
        P_O_V_LOGIN_USER_FSC     OUT NOCOPY VARCHAR2,
        P_O_V_ERROR              OUT NOCOPY VARCHAR2
    )AS
        EXPORT                     CONSTANT VARCHAR2(10) DEFAULT 'Export';
        IMPORT                     CONSTANT VARCHAR2(10) DEFAULT 'Import';
        FIRST                      CONSTANT NUMBER DEFAULT 1;
        SECOND                     CONSTANT NUMBER DEFAULT 2;
        THIRD                      CONSTANT NUMBER DEFAULT 3;
        SHIPPER                    CONSTANT VARCHAR2(1) DEFAULT 'S';
        CNEE                       CONSTANT VARCHAR2(1) DEFAULT 'C';
        NTFY                       CONSTANT VARCHAR2(1) DEFAULT '1';
        FREIGHT_TERM               CONSTANT VARCHAR2(1) DEFAULT 'F';
        SEP                        CONSTANT VARCHAR2(1) DEFAULT '~';
        SPACE                      CONSTANT VARCHAR2(1) DEFAULT ' ';
        L_V_PARAMETER              VARCHAR2(4000);
        L_V_POL_fSC                ITP040.PIOFFC%TYPE;
        L_V_POD_fSC                ITP040.PIOFFC%TYPE;
        L_V_LOGIN_USER_FSC         ITP040.PIOFFC%TYPE;
        L_V_CC_EXPORT_IMPORT       VARCHAR2(10);
        L_V_CC_FSC                 ITP040.PIOFFC%TYPE;
        L_V_FREIGHT_PAYMENT        VARCHAR2(200);
        FIST_LEG_NOT_FOUND_EXP     EXCEPTION;
        POD_NOT_FOUND_EXP          EXCEPTION;
        SHIPPER_NOT_FOUND_EXP      EXCEPTION;
        CNEEE_NOT_FOUND_EXP        EXCEPTION;
        NTFY_NOT_FOUND_EXP         EXCEPTION;
        FREIGHT_TERM_NOT_FOUND_EXP EXCEPTION;
        SUR_LOCATION_NOT_FOUND_EXP EXCEPTION;
        FSC_NOT_FOUND_EXP          EXCEPTION;

    BEGIN

        P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        L_V_PARAMETER := P_I_V_BL_NUMBER
            ||SEP|| P_I_V_CHANGE_USER
            ||SEP|| P_I_V_BL_SURRENDER_FSC;

        G_V_SQL_ID := 'SQL-01';

        BEGIN
            SELECT
                ITP060.VSLGNM,
                NVL2(IDP005.VOYAGE, 'V.'||IDP005.VOYAGE, IDP005.VOYAGE),
                IDP005.LOAD_PORT
            INTO
                P_O_V_FIRST_LEG_VESSEL,
                P_O_V_FIRST_LEG_VOYAGE,
                P_O_V_POL
            FROM
                IDP005,
                IDP010,
                ITP060
            WHERE
                AYBLNO                = P_I_V_BL_NUMBER
               -- AND IDP005.VOYAGE_SEQ = FIRST --*5
                AND  IDP005.VOYAGE_SEQ =     (SELECT MIN(VOYAGE_SEQ)
                    FROM IDP005
                    WHERE SYBLNO = AYBLNO
                    AND ROUTING_TYPE='S'
                )
                AND IDP005.SYBLNO     = AYBLNO
                AND ITP060.VSVESS     = IDP005.VESSEL ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --*8 start
                --RAISE FIST_LEG_NOT_FOUND_EXP;
                P_O_V_FIRST_LEG_VESSEL := '';
                P_O_V_FIRST_LEG_VOYAGE := '';
                P_O_V_POL := '';
                P_O_V_ERROR := P_I_V_BL_NUMBER || '~' || 'First leg not found';

                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                    'MAIL_TRIG',
                    'M',
                    P_O_V_ERROR,
                    'A',
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_O_V_ERROR,
                    NULL
                );
           --*8 end
        END;

        G_V_SQL_ID := 'SQL-02';

        BEGIN
            SELECT
                ITP060.VSLGNM,
                NVL2(IDP005.VOYAGE, 'V.'||IDP005.VOYAGE, IDP005.VOYAGE)
            INTO
                P_O_V_SECOND_LEG_VESSEL,
                P_O_V_SECOND_LEG_VOYAGE
            FROM
                IDP005,
                IDP010,
                ITP060
            WHERE
                AYBLNO                = P_I_V_BL_NUMBER
                AND IDP005.VOYAGE_SEQ = SECOND
                AND IDP005.SYBLNO     = AYBLNO
                AND ITP060.VSVESS     = IDP005.VESSEL ;

        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        G_V_SQL_ID := 'SQL-03';

        BEGIN
            SELECT
                ITP060.VSLGNM,
                NVL2(IDP005.VOYAGE, 'V.'||IDP005.VOYAGE, IDP005.VOYAGE)
            INTO
                P_O_V_THIRD_LEG_VESSEL,
                P_O_V_THIRD_LEG_VOYAGE
            FROM
                IDP005,
                IDP010,
                ITP060
            WHERE
                AYBLNO                = P_I_V_BL_NUMBER
                AND IDP005.VOYAGE_SEQ = THIRD
                AND IDP005.SYBLNO     = AYBLNO
                AND ITP060.VSVESS     = IDP005.VESSEL ;

        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        G_V_SQL_ID := 'SQL-04';

        BEGIN
            SELECT
                IDP005.DISCHARGE_PORT
            INTO
                P_O_V_POD
            FROM
                IDP005,
                IDP010
               -- ITP060 --*6
            WHERE
                AYBLNO                = P_I_V_BL_NUMBER
                AND IDP005.VOYAGE_SEQ IN (SELECT MAX(VOYAGE_SEQ)
                    FROM IDP005
                    WHERE SYBLNO = AYBLNO
                    AND ROUTING_TYPE='S' -- *4
                )
                AND IDP005.SYBLNO     = AYBLNO;
               -- AND ITP060.VSVESS     = IDP005.VESSEL ; --*6

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --*5 starts
                --RAISE POD_NOT_FOUND_EXP;
                P_O_V_POD := '';
                P_O_V_ERROR := P_I_V_BL_NUMBER || '~' || 'POD not found';

                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                    'MAIL_TRIG',
                    'M',
                    P_O_V_ERROR,
                    'A',
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_O_V_ERROR,
                    NULL
                );
                --*5 ends
        END;

        G_V_SQL_ID := 'SQL-05';

        BEGIN
            SELECT
                IDP030.CYNAME
            INTO
                P_O_V_SHIPPER_NAME
            FROM
                IDP030 IDP030
            WHERE
                IDP030.CYBLNO     = P_I_V_BL_NUMBER
                AND IDP030.CYRCTP = SHIPPER;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --*8 start
                --RAISE SHIPPER_NOT_FOUND_EXP;
                P_O_V_SHIPPER_NAME := '';
                P_O_V_ERROR := P_I_V_BL_NUMBER || '~' || 'Shipper not found';

                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                    'MAIL_TRIG',
                    'M',
                    P_O_V_ERROR,
                    'A',
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_O_V_ERROR,
                    NULL
                );
                --*8 end
        END;

        G_V_SQL_ID := 'SQL-06';

        BEGIN
            SELECT
                IDP030.CYNAME
            INTO
                P_O_V_CNEE_NAME
            FROM
                IDP030 IDP030
            WHERE
                IDP030.CYBLNO     = P_I_V_BL_NUMBER
                AND IDP030.CYRCTP = CNEE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --*8 start
                --RAISE CNEEE_NOT_FOUND_EXP;
                P_O_V_CNEE_NAME := '';
                P_O_V_ERROR := P_I_V_BL_NUMBER || '~' || 'CNEEE not found';

                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                    'MAIL_TRIG',
                    'M',
                    P_O_V_ERROR,
                    'A',
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_O_V_ERROR,
                    NULL
                );
                --*8 end
        END;

        G_V_SQL_ID := 'SQL-07';

        BEGIN
            SELECT
                IDP030.CYNAME
            INTO
                P_O_V_NTFY_NAME
            FROM
                IDP030 IDP030
            WHERE
                IDP030.CYBLNO     = P_I_V_BL_NUMBER
                AND IDP030.CYRCTP = NTFY;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            P_O_V_NTFY_NAME := ''; -- MYO 2013-Jan-30 to handle the missing Notify Party
                --RAISE NTFY_NOT_FOUND_EXP;
        END;

        G_V_SQL_ID := 'SQL-08';

        BEGIN
            /* prefer to find reocrd having FREIGHT word in the description */
            SELECT
                SUBSTR(FYDSCR, INSTR(FYDSCR, 'FREIGHT', 1,1), 15)  FREIGHT_PAYMENT
            INTO
                L_V_FREIGHT_PAYMENT
            FROM
                IDP060
            WHERE
                FYBLNO = P_I_V_BL_NUMBER
                AND LENGTH(FYDSCR) > 0  /* *12 */
                AND FYDSCR LIKE '%FREIGHT%' /* *12 */
                AND ROWNUM = 1 ; /* *12 */

        EXCEPTION
            /* *12 start */
            WHEN NO_DATA_FOUND THEN
                /* when FREIGHT word not found then search by BL number */
                BEGIN
                    SELECT
                        SUBSTR(FYDSCR, INSTR(FYDSCR, 'FREIGHT', 1,1), 15)  FREIGHT_PAYMENT
                    INTO
                        L_V_FREIGHT_PAYMENT
                    FROM
                        IDP060
                    WHERE
                        FYBLNO = P_I_V_BL_NUMBER
                        AND LENGTH(FYDSCR) > 0;
                EXCEPTION
                    WHEN OTHERS THEN
                        L_V_FREIGHT_PAYMENT := NULL;
                END;
            /* *12 end */

            WHEN OTHERS THEN
                L_V_FREIGHT_PAYMENT := NULL;
        END;

        G_V_SQL_ID := 'SQL-08A';

        BEGIN
            SELECT
                ITP188.CRDESC
            INTO
                P_O_V_FREIGHT_TERM
            FROM
                ITP188 ITP188
            WHERE
                EXISTS(
                    SELECT
                        1
                    FROM
                        IDP070 IDP070
                    WHERE
                        IDP070.GYBLNO     = P_I_V_BL_NUMBER
                        AND IDP070.GYFORS = FREIGHT_TERM
                        AND IDP070.GYCFSC = ITP188.CRCNTR
                );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --*8 start
                --RAISE FREIGHT_TERM_NOT_FOUND_EXP;
                P_O_V_FREIGHT_TERM := '';
                P_O_V_ERROR := P_I_V_BL_NUMBER || '~' || 'Freight Term not found';

                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                    'MAIL_TRIG',
                    'M',
                    P_O_V_ERROR,
                    'A',
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_I_V_CHANGE_USER,
                    SYSDATE,
                    P_O_V_ERROR,
                    NULL
                );
                --*8 end
        END;

        G_V_SQL_ID := 'SQL-08B';

        P_O_V_FREIGHT_TERM := TRIM(L_V_FREIGHT_PAYMENT ||' AT '|| P_O_V_FREIGHT_TERM);

        G_V_SQL_ID := 'SQL-09';

        BEGIN

            SELECT
                ITP188.CRDESC
            INTO
                P_O_V_SURRENDER_LOCATION
            FROM
                ITP188,
                SC_PRSN_LOG_INFO SPLI
            WHERE
                ITP188.CRCNTR        = SPLI.FSC_CODE
                AND SPLI.PRSN_LOG_ID = P_I_V_CHANGE_USER;

        EXCEPTION
            WHEN OTHERS THEN
                P_O_V_SURRENDER_LOCATION := 'HQ';
        END;

        G_V_SQL_ID := 'SQL-10';

        /* * get load port fsc * */
        PRE_GET_FSC(
            P_O_V_POL,
            P_O_V_POL_FSC,
            P_O_V_ERROR
        );

        IF P_O_V_ERROR <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
            --*8 start
            --RAISE FSC_NOT_FOUND_EXP;
            P_O_V_POL_FSC := '';
            P_O_V_ERROR := P_I_V_BL_NUMBER || '~' || P_O_V_POL || '~' ||'FSC NOT FOUUND';

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                'MAIL_TRIG',
                'M',
                P_O_V_ERROR,
                'A',
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_O_V_ERROR,
                NULL
            );
            --*8 end

        END IF;

        G_V_SQL_ID := 'SQL-11';

        /* * get discharge port fsc * */
        PRE_GET_FSC(
            P_O_V_POD,
            P_O_V_POD_FSC,
            P_O_V_ERROR
        );

        IF P_O_V_ERROR <> PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
            --*8 start
            --RAISE FSC_NOT_FOUND_EXP;
            P_O_V_POD_FSC := '';
            P_O_V_ERROR := P_I_V_BL_NUMBER || '~' || P_O_V_POD || '~' ||'FSC NOT FOUUND';

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                'MAIL_TRIG',
                'M',
                P_O_V_ERROR,
                'A',
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_O_V_ERROR,
                NULL
            );
            --*8 end
        END IF;

        /* * get login user FSC * */

        G_V_SQL_ID := 'SQL-12';

        BEGIN
            SELECT
                FSC_CODE
            INTO
                P_O_V_LOGIN_USER_FSC
            FROM
                SEALINER.SC_PRSN_LOG_INFO
            WHERE
                PRSN_LOG_ID = P_I_V_CHANGE_USER;

        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        G_V_SQL_ID := 'SQL-13';

--        IF P_O_V_LOGIN_USER_FSC = P_O_V_POD_FSC THEN
--            P_O_V_TO_EXPORT_IMPORT := EXPORT;
--        ELSIF    P_O_V_LOGIN_USER_FSC = P_O_V_POL_FSC THEN
--            P_O_V_TO_EXPORT_IMPORT := IMPORT;
--        ELSE
--            P_O_V_TO_EXPORT_IMPORT := EXPORT; -- import
--        END IF;
--
--        G_V_SQL_ID := 'SQL-14';
--
--        IF P_O_V_LOGIN_USER_FSC = P_O_V_POD_FSC THEN
--            P_O_V_TO_FSC := P_O_V_POL_FSC;
--        ELSIF P_O_V_LOGIN_USER_FSC = P_O_V_POL_FSC THEN
--            P_O_V_TO_FSC := P_O_V_POD_FSC;
--        ELSE
--            P_O_V_TO_FSC := P_O_V_POL_FSC; -- P_O_V_POD_FSC
--        END IF;
--
--        G_V_SQL_ID := 'SQL-15';
--
--        IF P_O_V_LOGIN_USER_FSC = P_O_V_POD_FSC THEN
--            P_O_V_FRM_EXPORT_IMPORT := IMPORT;
--        ELSIF P_O_V_LOGIN_USER_FSC = P_O_V_POL_FSC THEN
--            P_O_V_FRM_EXPORT_IMPORT := EXPORT;
--        ELSE
--            P_O_V_FRM_EXPORT_IMPORT := IMPORT;
--        END IF;
--
--
--        G_V_SQL_ID := 'SQL-16';
--
--        IF P_O_V_LOGIN_USER_FSC = P_O_V_POD_FSC THEN
--            P_O_V_FRM_FSC := P_O_V_POD_FSC;
--        ELSIF P_O_V_LOGIN_USER_FSC = P_O_V_POL_FSC THEN
--            P_O_V_FRM_FSC := P_O_V_POL_FSC;
--        ELSE
--            P_O_V_FRM_FSC := P_O_V_LOGIN_USER_FSC;
--        END IF;


        IF P_O_V_LOGIN_USER_FSC = P_O_V_POD_FSC THEN
            P_O_V_TO_EXPORT_IMPORT := EXPORT;
            P_O_V_FRM_EXPORT_IMPORT := IMPORT;

            P_O_V_TO_FSC := P_O_V_POL_FSC;
            P_O_V_FRM_FSC := P_O_V_POD_FSC;
        ELSIF P_O_V_LOGIN_USER_FSC = P_O_V_POL_FSC THEN
            P_O_V_TO_EXPORT_IMPORT := IMPORT;
            P_O_V_FRM_EXPORT_IMPORT := EXPORT;

            P_O_V_TO_FSC := P_O_V_POD_FSC;
            P_O_V_FRM_FSC := P_O_V_POL_FSC;
        ELSE
            P_O_V_TO_EXPORT_IMPORT := IMPORT ;
            P_O_V_FRM_EXPORT_IMPORT := IMPORT;
            L_V_CC_EXPORT_IMPORT := EXPORT;

            P_O_V_TO_FSC := P_O_V_POD_FSC;
            P_O_V_FRM_FSC := P_O_V_LOGIN_USER_FSC;
            L_V_CC_FSC := P_O_V_POL_FSC;

            P_O_V_CC_INFORMATION := 'CC : Documentation '|| L_V_CC_EXPORT_IMPORT
                ||' Team - '|| L_V_CC_FSC;
        END IF;

        DBMS_OUTPUT.PUT_LINE('PRE_GET_BL_MAIL_DETAILS COMPLETE');

    EXCEPTION
        WHEN FIST_LEG_NOT_FOUND_EXP THEN
            P_O_V_ERROR := 'First leg not found';
            DBMS_OUTPUT.PUT_LINE('RAISED FIST_LEG_NOT_FOUND_EXP');

        WHEN POD_NOT_FOUND_EXP THEN
            P_O_V_ERROR := 'POD not found';
            DBMS_OUTPUT.PUT_LINE('RAISED POD_NOT_FOUND_EXP');

        WHEN SHIPPER_NOT_FOUND_EXP THEN
            P_O_V_ERROR := 'Shipper not found';
            DBMS_OUTPUT.PUT_LINE('RAISED SHIPPER_NOT_FOUND_EXP');

        WHEN CNEEE_NOT_FOUND_EXP THEN
            P_O_V_ERROR := 'CNEEE not found';
            DBMS_OUTPUT.PUT_LINE('RAISED CNEEE_NOT_FOUND_EXP');

        WHEN NTFY_NOT_FOUND_EXP THEN
            --P_O_V_ERROR := 'NTFY not found';    -- MYO: 30/01/2013
            DBMS_OUTPUT.PUT_LINE('RAISED NTFY_NOT_FOUND_EXP');

        WHEN FREIGHT_TERM_NOT_FOUND_EXP THEN
            P_O_V_ERROR := 'Freight Term not found';
            DBMS_OUTPUT.PUT_LINE('RAISED FREIGHT_TERM_NOT_FOUND_EXP');

        WHEN SUR_LOCATION_NOT_FOUND_EXP THEN
            P_O_V_ERROR := 'Surender location not found';
            DBMS_OUTPUT.PUT_LINE('RAISED SUR_LOCATION_NOT_FOUND_EXP');

        WHEN FSC_NOT_FOUND_EXP THEN
            DBMS_OUTPUT.PUT_LINE('RAISED FSC NOT FOUUND');

        WHEN OTHERS THEN
            P_O_V_ERROR := G_V_SQL_ID||SEP|| SQLERRM;
            DBMS_OUTPUT.PUT_LINE('ORA EXCEPTION~'||SQLERRM);

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER,
                'MAIL_TRIG-3',
                'M',
                P_O_V_ERROR,
                'A',
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_I_V_CHANGE_USER,
                SYSDATE,
                P_O_V_ERROR,
                NULL
           );
           COMMIT;
    END PRE_GET_BL_MAIL_DETAILS;

    PROCEDURE PRE_GET_FSC (
        P_I_V_PORT  VARCHAR2,
        P_O_V_FSC   OUT NOCOPY VARCHAR2,
        P_O_V_ERROR OUT NOCOPY VARCHAR2
    )
    AS
    BEGIN

        P_O_V_ERROR := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        SELECT
            PIOFFC
        INTO
            P_O_V_FSC
        FROM
            ITP040
        WHERE
            PICODE = P_I_V_PORT;
    EXCEPTION
        WHEN OTHERS THEN
            P_O_V_ERROR := 'FSC not found for the port '|| P_I_V_PORT;

    END PRE_GET_FSC;

    /* *3 end * */

END PCE_ECM_RAISE_ENOTICE;
/