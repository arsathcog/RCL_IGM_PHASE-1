create or replace
PACKAGE BODY         "PCE_ECM_SYNC_TOS_EZDL" AS

    PROCEDURE PRE_TOS_UPDATE_DISCH_STS (
          p_i_v_new_disch_status          TOS_ONBOARD_LIST.DISCH_STATUS%TYPE
        , p_i_v_old_disch_status          TOS_ONBOARD_LIST.DISCH_STATUS%TYPE
        , p_i_v_booking                   TOS_ONBOARD_LIST.BOOKING_NO%TYPE
        , p_i_v_equipment_no              TOS_ONBOARD_LIST.CONTAINER_NO%TYPE
        , p_i_v_voyage_routing_dtl        TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
        , p_i_v_fk_bkg_equipm_dtl         TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL%TYPE
        , p_i_v_pod                       TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE
        , p_i_v_pod_trm                   TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE
        , p_i_v_pol                       TOS_DL_BOOKED_DISCHARGE.DN_POL%TYPE
        , p_i_v_pol_trm                   TOS_DL_BOOKED_DISCHARGE.DN_POL_TERMINAL%TYPE
        , p_o_return_status               OUT VARCHAR2
    ) AS
       /*********************************************************************************************
          Name           :  PRE_TOS_UPDATE_DISCH_STS
          Module         :  EZLL
          Purpose        :  For TOS_ONBOARD_LIST table update
                            This procedure is called by PCE_EDL_DLMAINTENANCE package.
          Calls          :
          Returns        :  0: success
                            1: failuer

          Author          Date               What
          ------          ----               ----
          VIKAS          28/06/2011         INITIAL VERSION
       *********************************************************************************************/
        l_v_fk_service          TOS_LL_LOAD_LIST.FK_SERVICE%TYPE;
        l_v_fk_vessel           TOS_LL_LOAD_LIST.FK_VESSEL%TYPE;
        l_v_fk_voyage           TOS_LL_LOAD_LIST.FK_VOYAGE%TYPE;
        l_v_dn_port             TOS_LL_LOAD_LIST.DN_PORT%TYPE;
        l_v_dn_terminal         TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE;
        l_v_fk_direction        TOS_LL_LOAD_LIST.FK_DIRECTION%TYPE;
        l_v_parameter_str       TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;
        l_v_prog_type           TOS_SYNC_ERROR_LOG.PROG_TYPE%TYPE := 'EZDL_TOS';
        l_v_user_id             VARCHAR2(10) := 'EZLL';
    BEGIN

        /* set default value in return status. */
        p_o_return_status := '0';

        l_v_parameter_str := p_i_v_new_disch_status||'~'||
                        p_i_v_old_disch_status||'~'||
                        p_i_v_booking||'~'||
                        p_i_v_equipment_no||'~'||
                        p_i_v_voyage_routing_dtl ||'~'||
                        p_i_v_fk_bkg_equipm_dtl||'~'||
                        p_i_v_pod ||'~'||
                        p_i_v_pod_trm ||'~'||
                        p_i_v_pol ||'~'||
                        p_i_v_pol_trm ;

        g_v_sql_id := 'SQL-01001';

        /* Start Added by vikas, to get previous load list,as k'chatgamol 25.11.2011 */
        SELECT
              LL.FK_SERVICE
            , LL.FK_VESSEL
            , LL.FK_VOYAGE
            , LL.FK_DIRECTION
            , LL.DN_PORT
            , LL.DN_TERMINAL
        INTO
              l_v_fk_service
            , l_v_fk_vessel
            , l_v_fk_voyage
            , l_v_fk_direction
            , l_v_dn_port
            , l_v_dn_terminal
        FROM    VASAPPS.TOS_LL_BOOKED_LOADING BL ,
                VASAPPS.TOS_LL_LOAD_LIST LL
        WHERE   LL.PK_LOAD_LIST_ID = BL.FK_LOAD_LIST_ID
        AND     LL.DN_PORT         = p_i_v_pol
        AND     LL.DN_TERMINAL     = p_i_v_pol_trm
        AND     BL.FK_BOOKING_NO   = p_i_v_booking
        AND     BL.DN_EQUIPMENT_NO = p_i_v_equipment_no
        AND     ROWNUM             = 1;

        /*
        SELECT
            FK_SERVICE
            , FK_VESSEL
            , FK_VOYAGE
            , FK_DIRECTION
            , DN_PORT
            , DN_TERMINAL
        INTO
            l_v_fk_service
            , l_v_fk_vessel
            , l_v_fk_voyage
            , l_v_fk_direction
            , l_v_dn_port
            , l_v_dn_terminal
        FROM
            TOS_LL_LOAD_LIST,
            TOS_LL_BOOKED_LOADING
        WHERE
            PK_LOAD_LIST_ID = FK_LOAD_LIST_ID
            AND FK_BOOKING_NO = p_i_v_booking
            AND DN_EQUIPMENT_NO = p_i_v_equipment_no
            AND FK_BKG_EQUIPM_DTL = p_i_v_fk_bkg_equipm_dtl
            AND FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_routing_dtl
            AND TOS_LL_LOAD_LIST.RECORD_STATUS = 'A'
            AND TOS_LL_BOOKED_LOADING.RECORD_STATUS = 'A';

        /*    End added by vikas, 25.11.2011     */

        /* Check if discharge status (container level) is changed to
        "Discharge" then update
        TOS_ONBOARD_LIST table with
        SEND_TO_POD = 'M' ,DISCH_STATUS ='D', DISCHLIST_STATUS = 'C' */
        IF ( p_i_v_new_disch_status = 'DI') AND ( p_i_v_old_disch_status <> 'DI') THEN
            g_v_sql_id := 'SQL-01002';
            UPDATE TOS_ONBOARD_LIST SET
                  SEND_TO_POD          = 'M'
                , DISCH_STATUS         = 'D'
                , DISCHLIST_STATUS     = 'C'
            WHERE
                TOS_ONBOARD_LIST.POL_SERVICE = l_v_fk_service
                AND TOS_ONBOARD_LIST.POL_VESSEL =  l_v_fk_vessel
                AND TOS_ONBOARD_LIST.POL_VOYAGE = l_v_fk_voyage
                AND TOS_ONBOARD_LIST.POD =     p_i_v_pod
                AND TOS_ONBOARD_LIST.POD_TERMINAL = p_i_v_pod_trm
                AND TOS_ONBOARD_LIST.POL =     l_v_dn_port
                AND TOS_ONBOARD_LIST.POL_TERMINAL = l_v_dn_terminal
                AND TOS_ONBOARD_LIST.BOOKING_NO  = p_i_v_booking
                AND TOS_ONBOARD_LIST.CONTAINER_NO =p_i_v_equipment_no;
        END IF;

        /* Check if discharge status (container level) is change from
        "Discharge" to "Booked" then update
        TOS_ONBOARD_LIST table with
        SEND_TO_POD = null, DISCH_STATUS = null, DISCHLIST_STATUS = null */
        IF ( p_i_v_new_disch_status = 'BK') AND ( p_i_v_old_disch_status <> 'DI') THEN
            g_v_sql_id := 'SQL-01002';
            UPDATE TOS_ONBOARD_LIST SET
                  SEND_TO_POD          = BLANK
                , DISCH_STATUS         = BLANK
                , DISCHLIST_STATUS     = BLANK
            WHERE
                TOS_ONBOARD_LIST.POL_SERVICE        = l_v_fk_service
                AND TOS_ONBOARD_LIST.POL_VESSEL     = l_v_fk_vessel
                AND TOS_ONBOARD_LIST.POL_VOYAGE     = l_v_fk_voyage
                AND TOS_ONBOARD_LIST.POD            = p_i_v_pod
                AND TOS_ONBOARD_LIST.POD_TERMINAL   = p_i_v_pod_trm
                AND TOS_ONBOARD_LIST.POL            = l_v_dn_port
                AND TOS_ONBOARD_LIST.POL_TERMINAL   = l_v_dn_terminal
                AND TOS_ONBOARD_LIST.BOOKING_NO     = p_i_v_booking
                AND TOS_ONBOARD_LIST.CONTAINER_NO   = p_i_v_equipment_no;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_return_status := '1';
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                , l_v_prog_type
                , g_v_opr_type
                ,  g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , l_v_user_id
                , CURRENT_TIMESTAMP
                , l_v_user_id
                , CURRENT_TIMESTAMP
            );
            COMMIT;
            RETURN;

        WHEN OTHERS THEN
            p_o_return_status := '1';
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                , l_v_prog_type
                , g_v_opr_type
                ,  g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , l_v_user_id
                , CURRENT_TIMESTAMP
                , l_v_user_id
                , CURRENT_TIMESTAMP
            );
            COMMIT;
            RETURN;

    END PRE_TOS_UPDATE_DISCH_STS;

    PROCEDURE PRE_TOS_GET_TOS_ONBORD (
          p_i_v_weight                    TOS_ONBOARD_LIST.WEIGHT%TYPE
        , p_i_v_rftemp                    TOS_ONBOARD_LIST.RFTEMP%TYPE
        , p_i_v_unit                      TOS_ONBOARD_LIST.UNIT%TYPE
        , p_i_v_imdg                      TOS_ONBOARD_LIST.IMDG%TYPE
        , p_i_v_unno                      TOS_ONBOARD_LIST.UNNO%TYPE
        , p_i_v_variant                   TOS_ONBOARD_LIST.VARIANT%TYPE
        , p_i_v_flash_pt                  TOS_ONBOARD_LIST.FLASH_PT%TYPE
        , p_i_v_flash_pt_unit             TOS_ONBOARD_LIST.FLASH_PT_UNIT%TYPE
        , p_i_v_port_class                TOS_ONBOARD_LIST.PORT_CLASS%TYPE
        , p_i_v_oog_oh                    TOS_ONBOARD_LIST.OOG_OH%TYPE
        , p_i_v_oog_olf                   TOS_ONBOARD_LIST.OOG_OLF%TYPE
        , p_i_v_oog_olb                   TOS_ONBOARD_LIST.OOG_OLB%TYPE
        , p_i_v_oog_owr                   TOS_ONBOARD_LIST.OOG_OWR%TYPE
        , p_i_v_oog_owl                   TOS_ONBOARD_LIST.OOG_OWL%TYPE
        , p_i_v_stow_position             TOS_ONBOARD_LIST.STOW_POSITION%TYPE
        , p_i_v_container_operator        TOS_ONBOARD_LIST.CONTAINER_OPERATOR%TYPE
        , p_i_v_out_slot_operator         TOS_ONBOARD_LIST.OUT_SLOT_OPERATOR%TYPE
        , p_i_v_han1                      TOS_ONBOARD_LIST.HAN1%TYPE
        , p_i_v_han2                      TOS_ONBOARD_LIST.HAN2%TYPE
        , p_i_v_han3                      TOS_ONBOARD_LIST.HAN3%TYPE
        , p_i_v_clr1                      TOS_ONBOARD_LIST.CLR1%TYPE
        , p_i_v_clr2                      TOS_ONBOARD_LIST.CLR2%TYPE
        , p_i_v_connecting_vessel         TOS_ONBOARD_LIST.CONNECTING_VESSEL%TYPE
        , p_i_v_connecting_voyage_no      TOS_ONBOARD_LIST.CONNECTING_VOYAGE_NO%TYPE
        , p_i_v_next_pod1                 TOS_ONBOARD_LIST.NEXT_POD1%TYPE
        , p_i_v_next_pod2                 TOS_ONBOARD_LIST.NEXT_POD2%TYPE
        , p_i_v_next_pod3                 TOS_ONBOARD_LIST.NEXT_POD3%TYPE
        , p_i_v_tight_conn_flag           TOS_ONBOARD_LIST.TIGHT_CONN_FLAG%TYPE
        , p_i_v_void_slot                 TOS_ONBOARD_LIST.VOID_SLOT%TYPE
        , p_i_v_list_status               TOS_ONBOARD_LIST.LIST_STATUS%TYPE
        , p_i_v_soc_coc                   TOS_ONBOARD_LIST.SOC_COC%TYPE
        , p_i_v_service                   TOS_ONBOARD_LIST.POL_SERVICE%TYPE
        , p_i_v_vessel                    TOS_ONBOARD_LIST.POL_VESSEL%TYPE
        , p_i_v_voyage                    TOS_ONBOARD_LIST.POL_VOYAGE%TYPE
        , p_i_v_direction                 TOS_ONBOARD_LIST.POL_DIR%TYPE
        , p_i_v_pod                       TOS_ONBOARD_LIST.POD%TYPE
        , p_i_v_pod_trm                   TOS_ONBOARD_LIST.POD_TERMINAL%TYPE
        , p_i_v_pol                       TOS_ONBOARD_LIST.POL%TYPE
        , p_i_v_pol_trm                   TOS_ONBOARD_LIST.POL_TERMINAL%TYPE
        , p_i_v_booking                   TOS_ONBOARD_LIST.BOOKING_NO%TYPE
        , p_i_v_equipment_no              TOS_ONBOARD_LIST.CONTAINER_NO%TYPE
        , p_i_v_pot                       TOS_ONBOARD_LIST.POT_PORT%TYPE
        , p_i_v_eqsize                    TOS_ONBOARD_LIST.EQSIZE%TYPE
        , p_i_v_eqtype                    TOS_ONBOARD_LIST.EQTYPE%TYPE
        , p_i_v_full_mt                   TOS_ONBOARD_LIST.FULL_MT%TYPE
        , p_i_v_slot_operator             TOS_ONBOARD_LIST.SLOT_OPERATOR%TYPE
        , p_i_v_final_destination         TOS_ONBOARD_LIST.FINAL_DESTINATION%TYPE
        , p_i_v_local_ts                  TOS_ONBOARD_LIST.LOCAL_TS%TYPE
        , p_o_return_status               OUT VARCHAR2
    ) AS

       /*********************************************************************************************
          Name           :  PRE_TOS_GET_TOS_ONBORD
          Module         :  EZLL
          Purpose        :  For TOS_ONBOARD_LIST table update
                            This procedure is called by TOS_ONBOARD_LIST_HANDLER handler.
          Calls          :
          Returns        :  0: success
                            1: failuer

          Author          Date               What
          ------          ----               ----
          VIKAS          28/06/2011         INITIAL VERSION
       *********************************************************************************************/

        l_v_pk_booked_discharge_id        TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID%TYPE;
        l_v_old_stowage_position          TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION%TYPE;
        l_v_next_pod1                     TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD1%TYPE;
        l_v_next_pod2                     TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD2%TYPE;
        l_v_next_pod3                     TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD3%TYPE;
        l_v_tight_connec_flag1            TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1%TYPE;
        l_v_tight_connec_flag2            TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2%TYPE;
        l_v_tight_connec_flag3            TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3%TYPE;
        l_v_eta_date                      VARCHAR2(8);
        l_v_eta_tm                        VARCHAR2(4);
        l_i_v_invoyageno                  TOS_LL_LOAD_LIST.FK_VOYAGE%TYPE;
        l_v_load_list_id                  TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE;
        l_v_flag                          VARCHAR2(1);
        l_v_load_port                     BOOKING_VOYAGE_ROUTING_DTL.LOAD_PORT%TYPE;
        l_v_act_service_code              BOOKING_VOYAGE_ROUTING_DTL.ACT_SERVICE_CODE%TYPE;
        l_v_act_vessel_code               BOOKING_VOYAGE_ROUTING_DTL.ACT_VESSEL_CODE%TYPE;
        l_v_act_voyage_number             BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER%TYPE;
        l_v_act_port_direction            BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_DIRECTION%TYPE;
        l_v_from_terminal                 BOOKING_VOYAGE_ROUTING_DTL.FROM_TERMINAL%TYPE;
        l_v_discharge_port                BOOKING_VOYAGE_ROUTING_DTL.DISCHARGE_PORT%TYPE;
        l_v_to_terminal                   BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE;
        l_v_parameter_str                 TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;
        l_v_error_cd                      VARCHAR2(15);
        l_v_prog_type                     TOS_SYNC_ERROR_LOG.PROG_TYPE%TYPE := 'TOS_EZDL';
        l_v_fk_port_sequence_no           TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO%TYPE;
        l_v_voyage_seqno                  BOOKING_VOYAGE_ROUTING_DTL.VOYAGE_SEQNO%TYPE;
        l_v_equipment_seq_no              BKP009.BISEQN%TYPE;
        l_n_supplier_seq_no               BKP009.SUPPLIER_SQNO%TYPE;
        l_finish_except                   EXCEPTION;
        l_v_mlo_vessel                    SEALINER.TOS_ONBOARD_LIST.CONNECTING_VESSEL%TYPE;
        l_v_mlo_voyage                    SEALINER.TOS_ONBOARD_LIST.CONNECTING_VOYAGE_NO%TYPE;
        l_v_mlo_pod1                      SEALINER.TOS_ONBOARD_LIST.NEXT_POD1%TYPE;
        l_v_mlo_pod2                      SEALINER.TOS_ONBOARD_LIST.NEXT_POD1%TYPE;
        l_v_mlo_pod3                      SEALINER.TOS_ONBOARD_LIST.NEXT_POD1%TYPE;
        l_i_v_vvvoyn                      ITP063.VVVOYN%TYPE; /* Added by vikas on 18.10.2011, for afs service */
        L_V_TMP                                varchar2(4000);
        l_v_sysdate                       DATE;  -- added 05.01.2012
        l_v_record_add_user               TOS_DL_DISCHARGE_LIST.RECORD_ADD_USER%TYPE := 'TOS'; -- 'EZLL' modified 05.01.2012;

    BEGIN

        l_v_parameter_str :=    p_i_v_weight
                                ||'~'|| p_i_v_rftemp
                                ||'~'|| p_i_v_unit
                                ||'~'|| p_i_v_imdg
                                ||'~'|| p_i_v_unno
                                ||'~'|| p_i_v_variant
                                ||'~'|| p_i_v_flash_pt
                                ||'~'|| p_i_v_flash_pt_unit
                                ||'~'|| p_i_v_port_class
                                ||'~'|| p_i_v_oog_oh
                                ||'~'|| p_i_v_oog_olf
                                ||'~'|| p_i_v_oog_olb
                                ||'~'|| p_i_v_oog_owr
                                ||'~'|| p_i_v_oog_owl
                                ||'~'|| p_i_v_stow_position
                                ||'~'|| p_i_v_container_operator
                                ||'~'|| p_i_v_out_slot_operator
                                ||'~'|| p_i_v_han1
                                ||'~'|| p_i_v_han2
                                ||'~'|| p_i_v_han3
                                ||'~'|| p_i_v_clr1
                                ||'~'|| p_i_v_clr2
                                ||'~'|| p_i_v_connecting_vessel
                                ||'~'|| p_i_v_connecting_voyage_no
                                ||'~'|| p_i_v_next_pod1
                                ||'~'|| p_i_v_next_pod2
                                ||'~'|| p_i_v_next_pod3
                                ||'~'|| p_i_v_tight_conn_flag
                                ||'~'|| p_i_v_void_slot
                                ||'~'|| p_i_v_list_status
                                ||'~'|| p_i_v_soc_coc
                                ||'~'|| p_i_v_service
                                ||'~'|| p_i_v_vessel
                                ||'~'|| p_i_v_voyage
                                ||'~'|| p_i_v_direction
                                ||'~'|| p_i_v_pod
                                ||'~'|| p_i_v_pod_trm
                                ||'~'|| p_i_v_pol
                                ||'~'|| p_i_v_pol_trm
                                ||'~'|| p_i_v_booking
                                ||'~'|| p_i_v_equipment_no
                                ||'~'|| p_i_v_pot
                                ||'~'|| p_i_v_eqsize
                                ||'~'|| p_i_v_eqtype
                                ||'~'|| p_i_v_full_mt
                                ||'~'|| p_i_v_slot_operator
                                ||'~'|| p_i_v_final_destination
                                ||'~'|| p_i_v_local_ts;

        /* set default value in return status. */
        p_o_return_status := '0';

        /*
            Start added by vikas to get a common sysdate, 05.01.2012
        */
            SELECT
                SYSDATE
            INTO
                l_v_sysdate
            FROM
                DUAL;
        /*
            End added by vikas, 05.01.2012
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
            'T_Z'
            ,'called' ||'~' || l_v_parameter_str
            ,'A'
            ,'EZLL'
            ,SYSDATE
            ,'EZLL'
            ,SYSDATE

        );
        commit;
        */
/*
        BEGIN
            /* get old values from tos_dl_booked_discharge table *
            g_v_sql_id := 'SQL-02001';
           SELECT
                     ITP063.VVVOYN
                   , ITP063.INVOYAGENO
                   , BOOKING_VOYAGE_ROUTING_DTL.LOAD_PORT
                   , BOOKING_VOYAGE_ROUTING_DTL.ACT_SERVICE_CODE
                   , BOOKING_VOYAGE_ROUTING_DTL.ACT_VESSEL_CODE
                   , BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER
                   , BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_DIRECTION
                   , BOOKING_VOYAGE_ROUTING_DTL.FROM_TERMINAL
                   , BOOKING_VOYAGE_ROUTING_DTL.DISCHARGE_PORT
                   , BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL
                   , BOOKING_VOYAGE_ROUTING_DTL.VOYAGE_SEQNO
            INTO     l_i_v_vvvoyn                /* Added by vikas on 18.10.2011, for afs service *
                   , l_i_v_invoyageno
                   , l_v_load_port
                   , l_v_act_service_code
                   , l_v_act_vessel_code
                   , l_v_act_voyage_number
                   , l_v_act_port_direction
                   , l_v_from_terminal
                   , l_v_discharge_port
                   , l_v_to_terminal
                   , l_v_voyage_seqno
            FROM ITP063 ITP063,BOOKING_VOYAGE_ROUTING_DTL BOOKING_VOYAGE_ROUTING_DTL
            WHERE ITP063.VVSRVC = BOOKING_VOYAGE_ROUTING_DTL.ACT_SERVICE_CODE
            AND ITP063.VVVESS   = BOOKING_VOYAGE_ROUTING_DTL.ACT_VESSEL_CODE
            AND ITP063.VVVOYN   = BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER
            AND ITP063.VVPDIR   = BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_DIRECTION
            AND ITP063.VVPCSQ   = BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_SEQUENCE
            AND ITP063.VVPCAL   = BOOKING_VOYAGE_ROUTING_DTL.DISCHARGE_PORT
            AND ITP063.VVTRM1   = BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL
            AND ITP063.VVVERS   = 99
            AND ITP063.OMMISSION_FLAG IS NULL
            AND BOOKING_VOYAGE_ROUTING_DTL.SERVICE         = p_i_v_service
            AND BOOKING_VOYAGE_ROUTING_DTL.VESSEL          = p_i_v_vessel
            AND BOOKING_VOYAGE_ROUTING_DTL.VOYNO           = p_i_v_voyage
            AND BOOKING_VOYAGE_ROUTING_DTL.DIRECTION       = p_i_v_direction
            AND BOOKING_VOYAGE_ROUTING_DTL.LOAD_PORT       = p_i_v_pol
            AND BOOKING_VOYAGE_ROUTING_DTL.BOOKING_NO      = p_i_v_booking;


            dbms_output.put_line('l_i_v_vvvoyn ' || l_i_v_vvvoyn);
            dbms_output.put_line('l_i_v_invoyageno ' || l_i_v_invoyageno);
            dbms_output.put_line('l_v_load_port ' || l_v_load_port);
            dbms_output.put_line('l_v_act_service_code ' || l_v_act_service_code);
            dbms_output.put_line('l_v_act_vessel_code ' || l_v_act_vessel_code);
            dbms_output.put_line('l_v_act_voyage_number ' || l_v_act_voyage_number);
            dbms_output.put_line('l_v_act_port_direction ' || l_v_act_port_direction);
            dbms_output.put_line('l_v_from_terminal ' || l_v_from_terminal);
            dbms_output.put_line('l_v_discharge_port ' || l_v_discharge_port);
            dbms_output.put_line('l_v_to_terminal ' || l_v_to_terminal);
            dbms_output.put_line('l_v_voyage_seqno ' || l_v_voyage_seqno);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := 'Booking route not found in BOOKING_VOYAGE_ROUTING_DTL';
                RAISE g_exception;
                /* No need to handler other excepton because it is already handled in outer end block *
        END;
*/
        /* get equipment sequence number from BKP009 */
        BEGIN
            g_v_sql_id := 'SQL-0202A';

            SELECT BISEQN
                    , SUPPLIER_SQNO
            INTO   l_v_equipment_seq_no
                   , l_n_supplier_seq_no
            FROM   BKP009
            WHERE  BIBKNO = p_i_v_booking
            AND    BICTRN = p_i_v_equipment_no;

            dbms_output.put_line('l_v_equipment_seq_no ' || l_v_equipment_seq_no);
            dbms_output.put_line('l_n_supplier_seq_no ' || l_n_supplier_seq_no);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                /*  Start Change by vikas, no need to raise error when
                    equipment not found  in BKP009, as k'chatgamol, 13.12.2011 *
                    The error will be handlend when equipment not found in EZDL system */
                NULL;
                /*
                g_v_err_code   := NULL;
                g_v_err_desc   := 'Equipment# not found in BKP009';
                RAISE g_exception;
                /* No need to handler other excepton because it is already handled in outer end block *
                 * End Change by vikas, 13.12.2011 */
        END;

        /* Get booking details from EZDL table. */
        BEGIN
            g_v_sql_id := 'SQL-02002';
  /*          SELECT
                  PK_BOOKED_DISCHARGE_ID
                , STOWAGE_POSITION
                , DN_NXT_POD1
                , DN_NXT_POD2
                , DN_NXT_POD3
                , TIGHT_CONNECTION_FLAG1
                , TIGHT_CONNECTION_FLAG2
                , TIGHT_CONNECTION_FLAG3
                , ITP.VVARDT
                , ITP.VVARTM
                , TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO
                , MLO_VESSEL
                , MLO_VOYAGE
            INTO
                  l_v_pk_booked_discharge_id
                , l_v_old_stowage_position
                , l_v_next_pod1
                , l_v_next_pod2
                , l_v_next_pod3
                , l_v_tight_connec_flag1
                , l_v_tight_connec_flag2
                , l_v_tight_connec_flag3
                , l_v_eta_date
                , l_v_eta_tm
                , l_v_fk_port_sequence_no
                , l_v_mlo_vessel
                , l_v_mlo_voyage
            FROM  TOS_DL_BOOKED_DISCHARGE,
            TOS_DL_DISCHARGE_LIST,
            ITP063 ITP
            WHERE TOS_DL_DISCHARGE_LIST.FK_SERVICE              = l_v_act_service_code
            AND TOS_DL_DISCHARGE_LIST.FK_VESSEL                 = l_v_act_vessel_code
            AND TOS_DL_DISCHARGE_LIST.FK_VOYAGE                 = DECODE(TOS_DL_DISCHARGE_LIST.FK_SERVICE,'AFS', l_i_v_vvvoyn, l_i_v_invoyageno) /* Added by vikas on 18.10.2011, for afs service *
            AND TOS_DL_DISCHARGE_LIST.DN_PORT                   = l_v_discharge_port
            AND TOS_DL_DISCHARGE_LIST.DN_TERMINAL               = l_v_to_terminal
            AND TOS_DL_BOOKED_DISCHARGE.DN_POL                  = l_v_load_port
            AND TOS_DL_BOOKED_DISCHARGE.DN_POL_TERMINAL         = l_v_from_terminal
            AND TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO           = p_i_v_booking
            AND TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL       = l_v_equipment_seq_no
            AND TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS        = 'BK'
            AND TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID    = TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID
            AND TOS_DL_DISCHARGE_LIST.FK_SERVICE                = ITP.VVSRVC
            AND TOS_DL_DISCHARGE_LIST.FK_VESSEL                 = ITP.VVVESS
            AND TOS_DL_DISCHARGE_LIST.FK_VOYAGE                 = DECODE(TOS_DL_DISCHARGE_LIST.FK_SERVICE,'AFS', ITP.VVVOYN, ITP.INVOYAGENO)
            AND TOS_DL_DISCHARGE_LIST.DN_PORT                   = ITP.VVPCAL
            AND TOS_DL_DISCHARGE_LIST.DN_TERMINAL               = ITP.VVTRM1
            AND ITP.OMMISSION_FLAG IS NULL
            AND TOS_DL_DISCHARGE_LIST.FK_DIRECTION              = ITP.VVPDIR
            AND TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO       = ITP.VVPCSQ
            AND ITP.VVVERS                                      = 99
            AND TOS_DL_DISCHARGE_LIST.FK_VERSION                = 99
            AND TOS_DL_DISCHARGE_LIST.RECORD_STATUS             = 'A'
            AND TOS_DL_BOOKED_DISCHARGE.RECORD_STATUS           = 'A'
            AND ROWNUM                                          = 1;

            dbms_output.put_line('l_v_pk_booked_discharge_id ' || l_v_pk_booked_discharge_id);
            dbms_output.put_line('l_v_old_stowage_position ' || l_v_old_stowage_position);
            dbms_output.put_line('l_v_next_pod1 ' || l_v_next_pod1);
            dbms_output.put_line('l_v_next_pod2 ' || l_v_next_pod2);
            dbms_output.put_line('l_v_next_pod3 ' || l_v_next_pod3);
            dbms_output.put_line('l_v_tight_connec_flag1 ' || l_v_tight_connec_flag1);
            dbms_output.put_line('l_v_tight_connec_flag2 ' || l_v_tight_connec_flag2);
            dbms_output.put_line('l_v_tight_connec_flag3 ' || l_v_tight_connec_flag3);
            dbms_output.put_line('l_v_eta_date ' || l_v_eta_date);
            dbms_output.put_line('l_v_eta_tm ' || l_v_eta_tm);
            dbms_output.put_line('l_v_fk_port_sequence_no ' || l_v_fk_port_sequence_no);
            dbms_output.put_line('l_v_mlo_vessel ' || l_v_mlo_vessel);
            dbms_output.put_line('l_v_mlo_voyage ' || l_v_mlo_voyage);
*/

            /* Start added by vikas, as per suggested by K'Chatgamol, 14.11.2011*/

              SELECT
                  PK_BOOKED_DISCHARGE_ID
                , STOWAGE_POSITION
                , DN_NXT_POD1
                , DN_NXT_POD2
                , DN_NXT_POD3
                , TIGHT_CONNECTION_FLAG1
                , TIGHT_CONNECTION_FLAG2
                , TIGHT_CONNECTION_FLAG3
                , dl.FK_PORT_SEQUENCE_NO
                , MLO_VESSEL
                , MLO_VOYAGE
            INTO
                  l_v_pk_booked_discharge_id
                , l_v_old_stowage_position
                , l_v_next_pod1
                , l_v_next_pod2
                , l_v_next_pod3
                , l_v_tight_connec_flag1
                , l_v_tight_connec_flag2
                , l_v_tight_connec_flag3
                , l_v_fk_port_sequence_no
                , l_v_mlo_vessel
                , l_v_mlo_voyage
            FROM    VASAPPS.TOS_DL_DISCHARGE_LIST   DL
                  , VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
            WHERE DL.PK_DISCHARGE_LIST_ID = BD.FK_DISCHARGE_LIST_ID
            AND   BD.FK_BOOKING_NO        = p_i_v_booking
            AND   DL.DN_PORT              = p_i_v_pod
            AND   DL.DN_TERMINAL          = p_i_v_pod_trm
            -- AND   BD.DN_EQUIPMENT_NO      = p_i_v_equipment_no
            AND (   -- added by vikas, When equipment no# is null then check on the basis
                    ( -- equipment sequence no# and supplier sequence no#.,as k'chatgamol, 07.12.2011
                        (p_i_v_equipment_no IS NOT NULL)
                        AND (BD.DN_EQUIPMENT_NO = p_i_v_equipment_no)
                    )
                    OR (
                        (BD.FK_BKG_EQUIPM_DTL   = l_v_equipment_seq_no)
                        AND (BD.FK_BKG_SUPPLIER = l_n_supplier_seq_no)
                    )
                ); -- end added by vikas 07.12.2011

            dbms_output.put_line('l_v_pk_booked_discharge_id ' || l_v_pk_booked_discharge_id);
            dbms_output.put_line('l_v_old_stowage_position ' || l_v_old_stowage_position);
            dbms_output.put_line('l_v_next_pod1 ' || l_v_next_pod1);
            dbms_output.put_line('l_v_next_pod2 ' || l_v_next_pod2);
            dbms_output.put_line('l_v_next_pod3 ' || l_v_next_pod3);
            dbms_output.put_line('l_v_tight_connec_flag1 ' || l_v_tight_connec_flag1);
            dbms_output.put_line('l_v_tight_connec_flag2 ' || l_v_tight_connec_flag2);
            dbms_output.put_line('l_v_tight_connec_flag3 ' || l_v_tight_connec_flag3);
            dbms_output.put_line('l_v_fk_port_sequence_no ' || l_v_fk_port_sequence_no);
            dbms_output.put_line('l_v_mlo_vessel ' || l_v_mlo_vessel);
            dbms_output.put_line('l_v_mlo_voyage ' || l_v_mlo_voyage);

            /* End added by vikas, as per suggested by K'Chatgamol, 14.11.2011*/
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- p_o_return_status := '1';
                g_v_err_code   := TO_CHAR(SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                /* call sp to crete new record */
                BEGIN
                    g_v_sql_id := 'SQL-0202B';

                    PRE_TOS_NEW_EQUIPMENT_ADD(
                        l_v_prog_type
                        , l_i_v_invoyageno
                        , l_v_load_list_id
                        , l_v_flag
                        , l_v_load_port
                        , l_v_act_service_code
                        , l_v_act_vessel_code
                        , l_v_act_voyage_number
                        , l_v_act_port_direction
                        , l_v_from_terminal
                        , l_v_discharge_port
                        , l_v_to_terminal
                        , p_i_v_weight
                        , p_i_v_rftemp
                        , p_i_v_unit
                        , p_i_v_imdg
                        , p_i_v_unno
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
                        , l_v_voyage_seqno
                        , l_v_equipment_seq_no
                        , l_n_supplier_seq_no
                        , l_v_fk_port_sequence_no
                        , l_i_v_vvvoyn       /* Added by vikas on 18.10.2011, for afs service */
                        , p_o_return_status
                    );
                    RETURN;
                END;
            WHEN OTHERS THEN
                p_o_return_status := '1';
                g_v_err_code   := TO_CHAR(SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                -- ROLLBACK;

                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                      l_v_parameter_str
                    , l_v_prog_type
                    , g_v_opr_type
                    ,  g_v_sql_id ||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;

                RETURN; -- RETURN, because can not process rest of the stepes if execution is failed.
        END;
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
            'T_Z'
            ,'BOOKED_ID' ||'~' || l_v_pk_booked_discharge_id
            ,'A'
            ,'EZLL'
            ,SYSDATE
            ,'EZLL'
            ,SYSDATE

        );
        commit;
  */
 /* Leena 20.01.2012: Moved the update of TOS_DL_BOOKED_DISCHARGE from the
 end of the procedure to here Begin */
         /* Process tight connection values */
        BEGIN
            g_v_sql_id := 'SQL-0207A';

            IF( (l_v_next_pod3 IS NOT NULL) AND (l_v_next_pod3 = p_i_v_pod) ) THEN
                l_v_tight_connec_flag3 := p_i_v_tight_conn_flag;
            ELSIF ( (l_v_next_pod2 IS NOT NULL) AND (l_v_next_pod2 = p_i_v_pod) ) THEN
                l_v_tight_connec_flag2 := p_i_v_tight_conn_flag;
            ELSE
                l_v_tight_connec_flag1 := p_i_v_tight_conn_flag;
            END IF;

            /* No need to update MLO_VESSEL, MLO_VOYAGE when soc-coc is 'c' */
            IF ((p_i_v_soc_coc = 'S') AND ( l_v_next_pod2 IS NULL)) THEN
                /* update mlo_vessel details */
                l_v_mlo_vessel     :=  p_i_v_connecting_vessel;
                l_v_mlo_voyage     :=  p_i_v_connecting_voyage_no;
                l_v_mlo_pod1       :=  p_i_v_next_pod1;
                l_v_mlo_pod2       :=  p_i_v_next_pod2;
                l_v_mlo_pod3       :=  p_i_v_next_pod3;

            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                    l_v_parameter_str
                    , l_v_prog_type
                    , g_v_opr_type
                    , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
        END ;

        /* Update Booked Discharge table. */

        BEGIN
            g_v_sql_id := 'SQL-02008';

            UPDATE TOS_DL_BOOKED_DISCHARGE SET
                  DN_EQUIPMENT_NO               =  p_i_v_equipment_no
                , CONTAINER_GROSS_WEIGHT        =  p_i_v_weight
                , REEFER_TEMPERATURE            =  p_i_v_rftemp
                , REEFER_TMP_UNIT               =  p_i_v_unit
                , FK_IMDG                       =  p_i_v_imdg
                , FK_UNNO                       =  p_i_v_unno
                , FK_UN_VAR                     =  p_i_v_variant
                , FLASH_POINT                   =  p_i_v_flash_pt
                , FLASH_UNIT                    =  p_i_v_flash_pt_unit
                , FK_PORT_CLASS                 =  p_i_v_port_class
                , OVERHEIGHT_CM                 =  p_i_v_oog_oh
                , OVERLENGTH_FRONT_CM           =  p_i_v_oog_olf
                , OVERLENGTH_REAR_CM            =  p_i_v_oog_olb
                , OVERWIDTH_RIGHT_CM            =  p_i_v_oog_owr
                , OVERWIDTH_LEFT_CM             =  p_i_v_oog_owl
                , STOWAGE_POSITION              =  p_i_v_stow_position
                , FK_CONTAINER_OPERATOR         =  p_i_v_container_operator
                , OUT_SLOT_OPERATOR             =  p_i_v_out_slot_operator
                , FK_HANDLING_INSTRUCTION_1     =  p_i_v_han1
                , FK_HANDLING_INSTRUCTION_2     =  p_i_v_han2
                , FK_HANDLING_INSTRUCTION_3     =  p_i_v_han3
                , CONTAINER_LOADING_REM_1       =  p_i_v_clr1
                , CONTAINER_LOADING_REM_2       =  p_i_v_clr2
                , MLO_VESSEL                    =  l_v_mlo_vessel -- p_i_v_connecting_vessel
                , MLO_VOYAGE                    =  l_v_mlo_voyage -- p_i_v_connecting_voyage_no
                , MLO_POD1                      =  l_v_mlo_pod1
                , MLO_POD2                      =  l_v_mlo_pod2
                , MLO_POD3                      =  l_v_mlo_pod3
                , TIGHT_CONNECTION_FLAG1        =  l_v_tight_connec_flag1
                , TIGHT_CONNECTION_FLAG2        =  l_v_tight_connec_flag2
                , TIGHT_CONNECTION_FLAG3        =  l_v_tight_connec_flag3
                , VOID_SLOT                     =  p_i_v_void_slot
                , RECORD_CHANGE_USER            =  l_v_record_add_user  -- added, 05.01.2012
                , RECORD_CHANGE_DATE            =  l_v_sysdate  -- added, 05.01.2012

            WHERE
                PK_BOOKED_DISCHARGE_ID          =  L_V_PK_BOOKED_DISCHARGE_ID;
                commit;
        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                    l_v_parameter_str
                    , l_v_prog_type
                    , g_v_opr_type
                    , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
        END ;
 /* Leena 20.01.2012: Moved the update of TOS_DL_BOOKED_DISCHARGE from the
 end of the procedure to here End */


  /*Compare old stowage position value with new stowage position value.
        When stowage pos changed then update previous load list*/

        dbms_output.put_line('l_v_old_stowage_position ' || l_v_old_stowage_position);
        dbms_output.put_line('p_i_v_stow_position ' || p_i_v_stow_position);

        IF(NVL(l_v_old_stowage_position, '~') <> NVL(p_i_v_stow_position, '~')) THEN
            /* Get previous load list id */
            BEGIN
                g_v_sql_id := 'SQL-02003';
                dbms_output.put_line('stowage pos is changed ');

                /* Start commented by vikas on, 11.11.2011 *
                PRE_EDL_PREV_LOAD_LIST_ID(
                      l_v_act_vessel_code
                    , l_v_equipment_seq_no
                    , p_i_v_booking
                    , p_i_v_pod
                    , l_v_fk_port_sequence_no
                    , l_v_load_list_id
                    , l_v_flag
                    , l_v_error_cd
                );
                * End commented by vikas on, 11.11.2011 */

                /* Start added by Vikas as suggested by k'chatgamol, 11.11.2011 */
                PRE_EDL_PREV_LOAD_LIST_ID(
                      p_i_v_service
                    , p_i_v_vessel
                    , p_i_v_voyage
                    , p_i_v_pol
                    , p_i_v_booking
                    , p_i_v_equipment_no
                    , l_v_load_list_id
                    , l_v_error_cd
                );
                /* End added by Vikas as suggested by k'chatgamol, 11.11.2011 */

                dbms_output.put_line('l_v_load_list_id ' || l_v_load_list_id);
                dbms_output.put_line('l_v_flag ' || l_v_flag);
                dbms_output.put_line('l_v_error_cd ' || l_v_error_cd);

                IF (l_v_error_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                    RAISE g_exception_ll;
                ELSE
                    p_o_return_status := '0';
                END IF;

                /* update record in booked load list table */
--                IF(l_v_flag = 'D') THEN
                    g_v_sql_id := 'SQL-02004';
                    UPDATE TOS_LL_BOOKED_LOADING
                    SET STOWAGE_POSITION   = p_i_v_stow_position
                      , DN_EQUIPMENT_NO    = p_i_v_equipment_no
                      , RECORD_CHANGE_USER = l_v_record_add_user -- g_v_userId modified, 05.01.2012
                      , RECORD_CHANGE_DATE = l_v_sysdate -- SYSDATE modified, 05.01.2012
                    WHERE PK_BOOKED_LOADING_ID = l_v_load_list_id;
                   dbms_output.put_line('loadlist updated with stow pos. ' || p_i_v_stow_position);

--              END IF;

                /* update record in restow table */
                IF(l_v_flag = 'R') THEN
                    g_v_sql_id := 'SQL-02005';
                    UPDATE TOS_RESTOW
                    SET STOWAGE_POSITION   = p_i_v_stow_position
                      , DN_EQUIPMENT_NO    = p_i_v_equipment_no
                      , RECORD_CHANGE_USER = l_v_record_add_user -- g_v_userId modified, 05.01.2012
                      , RECORD_CHANGE_DATE = l_v_sysdate -- SYSDATE modified, 05.01.2012
                    WHERE PK_RESTOW_ID     = l_v_load_list_id;
                END IF;
            EXCEPTION
                WHEN g_exception_ll THEN
                    g_v_err_code   := NULL;
                    g_v_err_desc    := g_error_msg_1;
                    dbms_output.put_line(g_v_sql_id);
                    dbms_output.put_line(SQLERRM);
                    l_v_tmp := SQLERRM;
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
                        'T_Z'
                        ,'g_v_sql_id '|| g_v_sql_id||'~' || L_V_TMP
                        ,'A'
                        ,'EZLL'
                        ,SYSDATE
                        ,'EZLL'
                        ,SYSDATE

                    );
                    commit;
    */
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                          l_v_parameter_str
                        , l_v_prog_type
                        , g_v_opr_type
                        , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                        , 'A'
                        , l_v_record_add_user
                        , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                        , l_v_record_add_user
                        , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    );
                    COMMIT;
                WHEN OTHERS THEN
                    g_v_err_code   := NULL;
                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        l_v_parameter_str
                        , l_v_prog_type
                        , g_v_opr_type
                        , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                        , 'A'
                        , l_v_record_add_user
                        , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                        , l_v_record_add_user
                        , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    );
                    COMMIT;

            END;

            /* Call Synchronization batch */
            /*    Start commented by vikas as k'chatgamol, 01.12.2011    *
            BEGIN
                g_v_sql_id := 'SQL-02006';

                PCE_EDL_DLMAINTENANCE.PRE_EDL_SYNCH_BOOKING (
                      l_v_pk_booked_discharge_id
                    , BLANK
                    , p_i_v_equipment_no
                    , p_i_v_booking
                    , p_i_v_oog_owl
                    , p_i_v_oog_oh
                    , p_i_v_oog_owr
                    , p_i_v_oog_olf
                    , p_i_v_oog_olb
                    , p_i_v_imdg
                    , p_i_v_unno
                    , p_i_v_variant
                    , p_i_v_flash_pt
                    , p_i_v_flash_pt_unit
                    , p_i_v_unit
                    , p_i_v_rftemp
                    , BLANK
                    , p_i_v_weight
                    , BLANK
                    , l_v_error_cd
                );

                IF(l_v_error_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                    RAISE g_exception_ll;
                ELSE
                    p_o_return_status := '0';
                END IF;

            EXCEPTION
                WHEN g_exception_ll THEN
                    g_v_err_code   := NULL;
                    g_v_err_desc   := 'Booking synchronization Fail';
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        l_v_parameter_str
                        , l_v_prog_type
                        , g_v_opr_type
                        , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                        , 'A'
                        , g_v_userId
                        , CURRENT_TIMESTAMP
                        , g_v_userId
                        , CURRENT_TIMESTAMP
                    );
                    COMMIT;

                WHEN OTHERS THEN
                    g_v_err_code   := NULL;
                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        l_v_parameter_str
                        , l_v_prog_type
                        , g_v_opr_type
                        , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                        , 'A'
                        , g_v_userId
                        , CURRENT_TIMESTAMP
                        , g_v_userId
                        , CURRENT_TIMESTAMP
                    );
                    COMMIT;
            END;
            *    End commented by vikas, 01.12.2011    */
            /* Next POD Synchronization */
            BEGIN
                g_v_sql_id := 'SQL-02007';
                PCE_EDL_DLMAINTENANCE.PRE_EDL_POD_UPDATE (
                      l_v_pk_booked_discharge_id
                    , p_i_v_booking
                    , 'D'
                    , BLANK
                    , BLANK
                    , p_i_v_weight
                    ,BLANK  --Add VGM
                     ,BLANK  /* Saisuda, 21/06/2016 for CR SOLAR*/
                    , BLANK
                    , p_i_v_container_operator
                    , p_i_v_out_slot_operator
                    , BLANK
                    , p_i_v_connecting_vessel
                    , p_i_v_connecting_voyage_no
                    , BLANK
                    , p_i_v_next_pod1
                    , p_i_v_next_pod2
                    , p_i_v_next_pod3
                    , BLANK
                    , p_i_v_han1
                    , p_i_v_han2
                    , p_i_v_han3
                    , p_i_v_clr1
                    , p_i_v_clr2
                    , BLANK
                    , BLANK
                    , BLANK
                    , BLANK
                    , BLANK
                    , BLANK
                    , BLANK
                    , BLANK
                    , l_v_error_cd
                );

                IF(l_v_error_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                    RAISE g_exception_ll;
                ELSE
                    p_o_return_status := '0';
                END IF;
            EXCEPTION
                WHEN g_exception_ll THEN
                    g_v_err_code   := NULL;
                    g_v_err_desc   := 'Next POD synchronization Fail';
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        l_v_parameter_str
                        , l_v_prog_type
                        , g_v_opr_type
                        , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                        , 'A'
                        , l_v_record_add_user
                        , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                        , l_v_record_add_user
                        , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    );
                    COMMIT;

                WHEN OTHERS THEN
                    g_v_err_code   := NULL;
                    g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        l_v_parameter_str
                        , l_v_prog_type
                        , g_v_opr_type
                        , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                        , 'A'
                        , l_v_record_add_user
                        , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                        , l_v_record_add_user
                        , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    );
                    COMMIT;
            END;

        END IF;
 -- Leena 20.01.2012 Commented and moved after PRE_TOS_NEW_EQUIPMENT_ADD call - Begin
        /* Process tight connection values */
        /*BEGIN
            g_v_sql_id := 'SQL-0207A';

            IF( (l_v_next_pod3 IS NOT NULL) AND (l_v_next_pod3 = p_i_v_pod) ) THEN
                l_v_tight_connec_flag3 := p_i_v_tight_conn_flag;
            ELSIF ( (l_v_next_pod2 IS NOT NULL) AND (l_v_next_pod2 = p_i_v_pod) ) THEN
                l_v_tight_connec_flag2 := p_i_v_tight_conn_flag;
            ELSE
                l_v_tight_connec_flag1 := p_i_v_tight_conn_flag;
            END IF;

            /* No need to update MLO_VESSEL, MLO_VOYAGE when soc-coc is 'c' */
           /* IF ((p_i_v_soc_coc = 'S') AND ( l_v_next_pod2 IS NULL)) THEN
                /* update mlo_vessel details */
              /*  l_v_mlo_vessel     :=  p_i_v_connecting_vessel;
                l_v_mlo_voyage     :=  p_i_v_connecting_voyage_no;
                l_v_mlo_pod1       :=  p_i_v_next_pod1;
                l_v_mlo_pod2       :=  p_i_v_next_pod2;
                l_v_mlo_pod3       :=  p_i_v_next_pod3;

            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                    l_v_parameter_str
                    , l_v_prog_type
                    , g_v_opr_type
                    , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
        END ;

        /* Update Booked Discharge table. */

       /* BEGIN
            g_v_sql_id := 'SQL-02008';

            UPDATE TOS_DL_BOOKED_DISCHARGE SET
                  DN_EQUIPMENT_NO               =  p_i_v_equipment_no
                , CONTAINER_GROSS_WEIGHT        =  p_i_v_weight
                , REEFER_TEMPERATURE            =  p_i_v_rftemp
                , REEFER_TMP_UNIT               =  p_i_v_unit
                , FK_IMDG                       =  p_i_v_imdg
                , FK_UNNO                       =  p_i_v_unno
                , FK_UN_VAR                     =  p_i_v_variant
                , FLASH_POINT                   =  p_i_v_flash_pt
                , FLASH_UNIT                    =  p_i_v_flash_pt_unit
                , FK_PORT_CLASS                 =  p_i_v_port_class
                , OVERHEIGHT_CM                 =  p_i_v_oog_oh
                , OVERLENGTH_FRONT_CM           =  p_i_v_oog_olf
                , OVERLENGTH_REAR_CM            =  p_i_v_oog_olb
                , OVERWIDTH_RIGHT_CM            =  p_i_v_oog_owr
                , OVERWIDTH_LEFT_CM             =  p_i_v_oog_owl
                , STOWAGE_POSITION              =  p_i_v_stow_position
                , FK_CONTAINER_OPERATOR         =  p_i_v_container_operator
                , OUT_SLOT_OPERATOR             =  p_i_v_out_slot_operator
                , FK_HANDLING_INSTRUCTION_1     =  p_i_v_han1
                , FK_HANDLING_INSTRUCTION_2     =  p_i_v_han2
                , FK_HANDLING_INSTRUCTION_3     =  p_i_v_han3
                , CONTAINER_LOADING_REM_1       =  p_i_v_clr1
                , CONTAINER_LOADING_REM_2       =  p_i_v_clr2
                , MLO_VESSEL                    =  l_v_mlo_vessel -- p_i_v_connecting_vessel
                , MLO_VOYAGE                    =  l_v_mlo_voyage -- p_i_v_connecting_voyage_no
                , MLO_POD1                      =  l_v_mlo_pod1
                , MLO_POD2                      =  l_v_mlo_pod2
                , MLO_POD3                      =  l_v_mlo_pod3
                , TIGHT_CONNECTION_FLAG1        =  l_v_tight_connec_flag1
                , TIGHT_CONNECTION_FLAG2        =  l_v_tight_connec_flag2
                , TIGHT_CONNECTION_FLAG3        =  l_v_tight_connec_flag3
                , VOID_SLOT                     =  p_i_v_void_slot
                , RECORD_CHANGE_USER            =  l_v_record_add_user  -- added, 05.01.2012
                , RECORD_CHANGE_DATE            =  l_v_sysdate  -- added, 05.01.2012

            WHERE
                PK_BOOKED_DISCHARGE_ID          =  l_v_pk_booked_discharge_id;
        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                    l_v_parameter_str
                    , l_v_prog_type
                    , g_v_opr_type
                    , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
        END ;*/ -- Leena 20.01.2012 Commented and moved after PRE_TOS_NEW_EQUIPMENT_ADD call End

        /* Return successful */
        p_o_return_status := '0';
    EXCEPTION
        WHEN l_finish_except THEN
            p_o_return_status := 0;
            RETURN;

        WHEN g_exception THEN
            p_o_return_status := '1';
            -- ROLLBACK;

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                  l_v_parameter_str
                , l_v_prog_type
                , g_v_opr_type
                , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
            );
            COMMIT;
            RETURN;

        WHEN NO_DATA_FOUND THEN
            p_o_return_status := '1';

            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            -- ROLLBACK;

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                  l_v_parameter_str
                , l_v_prog_type
                , g_v_opr_type
                , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
            );
            COMMIT;
            RETURN;


        WHEN OTHERS THEN
            p_o_return_status := '1';

            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            -- ROLLBACK;
            dbms_output.put_line('g_v_sql_id ' || g_v_sql_id);
            dbms_output.put_line('SQLERRM ' || SQLERRM);

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                  l_v_parameter_str
                , l_v_prog_type
                , g_v_opr_type
                , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
            );
            COMMIT;
            RETURN;

    END PRE_TOS_GET_TOS_ONBORD;


    PROCEDURE PRE_TOS_NEW_EQUIPMENT_ADD(
          p_i_v_prog_type                 TOS_SYNC_ERROR_LOG.PROG_TYPE%TYPE
        , p_i_v_invoyageno                TOS_LL_LOAD_LIST.FK_VOYAGE%TYPE
        , p_i_v_load_list_id              TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE
        , p_i_v_flag                      VARCHAR2
        , p_i_v_load_port                 BOOKING_VOYAGE_ROUTING_DTL.LOAD_PORT%TYPE
        , p_i_v_act_service_code          BOOKING_VOYAGE_ROUTING_DTL.ACT_SERVICE_CODE%TYPE
        , p_i_v_act_vessel_code           BOOKING_VOYAGE_ROUTING_DTL.ACT_VESSEL_CODE%TYPE
        , p_i_v_act_voyage_number         BOOKING_VOYAGE_ROUTING_DTL.ACT_VOYAGE_NUMBER%TYPE
        , p_i_v_act_port_direction        BOOKING_VOYAGE_ROUTING_DTL.ACT_PORT_DIRECTION%TYPE
        , p_i_v_from_terminal             BOOKING_VOYAGE_ROUTING_DTL.FROM_TERMINAL%TYPE
        , p_i_v_discharge_port            BOOKING_VOYAGE_ROUTING_DTL.DISCHARGE_PORT%TYPE
        , p_i_v_to_terminal               BOOKING_VOYAGE_ROUTING_DTL.TO_TERMINAL%TYPE
        , p_i_v_weight                    TOS_ONBOARD_LIST.WEIGHT%TYPE
        , p_i_v_rftemp                    TOS_ONBOARD_LIST.RFTEMP%TYPE
        , p_i_v_unit                      TOS_ONBOARD_LIST.UNIT%TYPE
        , p_i_v_imdg                      TOS_ONBOARD_LIST.IMDG%TYPE
        , p_i_v_unno                      TOS_ONBOARD_LIST.UNNO%TYPE
        , p_i_v_variant                   TOS_ONBOARD_LIST.VARIANT%TYPE
        , p_i_v_flash_pt                  TOS_ONBOARD_LIST.FLASH_PT%TYPE
        , p_i_v_flash_pt_unit             TOS_ONBOARD_LIST.FLASH_PT_UNIT%TYPE
        , p_i_v_port_class                TOS_ONBOARD_LIST.PORT_CLASS%TYPE
        , p_i_v_oog_oh                    TOS_ONBOARD_LIST.OOG_OH%TYPE
        , p_i_v_oog_olf                   TOS_ONBOARD_LIST.OOG_OLF%TYPE
        , p_i_v_oog_olb                   TOS_ONBOARD_LIST.OOG_OLB%TYPE
        , p_i_v_oog_owr                   TOS_ONBOARD_LIST.OOG_OWR%TYPE
        , p_i_v_oog_owl                   TOS_ONBOARD_LIST.OOG_OWL%TYPE
        , p_i_v_stow_position             TOS_ONBOARD_LIST.STOW_POSITION%TYPE
        , p_i_v_container_operator        TOS_ONBOARD_LIST.CONTAINER_OPERATOR%TYPE
        , p_i_v_out_slot_operator         TOS_ONBOARD_LIST.OUT_SLOT_OPERATOR%TYPE
        , p_i_v_han1                      TOS_ONBOARD_LIST.HAN1%TYPE
        , p_i_v_han2                      TOS_ONBOARD_LIST.HAN2%TYPE
        , p_i_v_han3                      TOS_ONBOARD_LIST.HAN3%TYPE
        , p_i_v_clr1                      TOS_ONBOARD_LIST.CLR1%TYPE
        , p_i_v_clr2                      TOS_ONBOARD_LIST.CLR2%TYPE
        , p_i_v_connecting_vessel         TOS_ONBOARD_LIST.CONNECTING_VESSEL%TYPE
        , p_i_v_connecting_voyage_no      TOS_ONBOARD_LIST.CONNECTING_VOYAGE_NO%TYPE
        , p_i_v_next_pod1                 TOS_ONBOARD_LIST.NEXT_POD1%TYPE
        , p_i_v_next_pod2                 TOS_ONBOARD_LIST.NEXT_POD2%TYPE
        , p_i_v_next_pod3                 TOS_ONBOARD_LIST.NEXT_POD3%TYPE
        , p_i_v_tight_conn_flag           TOS_ONBOARD_LIST.TIGHT_CONN_FLAG%TYPE
        , p_i_v_void_slot                 TOS_ONBOARD_LIST.VOID_SLOT%TYPE
        , p_i_v_list_status               TOS_ONBOARD_LIST.LIST_STATUS%TYPE
        , p_i_v_soc_coc                   TOS_ONBOARD_LIST.SOC_COC%TYPE
        , p_i_v_service                   TOS_ONBOARD_LIST.POL_SERVICE%TYPE
        , p_i_v_vessel                    TOS_ONBOARD_LIST.POL_VESSEL%TYPE
        , p_i_v_voyage                    TOS_ONBOARD_LIST.POL_VOYAGE%TYPE
        , p_i_v_direction                 TOS_ONBOARD_LIST.POL_DIR%TYPE
        , p_i_v_pod                       TOS_ONBOARD_LIST.POD%TYPE
        , p_i_v_pod_trm                   TOS_ONBOARD_LIST.POD_TERMINAL%TYPE
        , p_i_v_pol                       TOS_ONBOARD_LIST.POL%TYPE
        , p_i_v_pol_trm                   TOS_ONBOARD_LIST.POL_TERMINAL%TYPE
        , p_i_v_booking                   TOS_ONBOARD_LIST.BOOKING_NO%TYPE
        , p_i_v_equipment_no              TOS_ONBOARD_LIST.CONTAINER_NO%TYPE
        , p_i_v_pot                       TOS_ONBOARD_LIST.POT_PORT%TYPE
        , p_i_v_eqsize                    TOS_ONBOARD_LIST.EQSIZE%TYPE
        , p_i_v_eqtype                    TOS_ONBOARD_LIST.EQTYPE%TYPE
        , p_i_v_full_mt                   TOS_ONBOARD_LIST.FULL_MT%TYPE
        , p_i_v_slot_operator             TOS_ONBOARD_LIST.SLOT_OPERATOR%TYPE
        , p_i_v_final_destination         TOS_ONBOARD_LIST.FINAL_DESTINATION%TYPE
        , p_i_v_local_ts                  TOS_ONBOARD_LIST.LOCAL_TS%TYPE
        , p_i_v_voyage_seqno              BOOKING_VOYAGE_ROUTING_DTL.VOYAGE_SEQNO%TYPE
        , p_i_v_equipment_seq_no          sealiner.BKP009.BISEQN%TYPE
        , p_i_v_supplier_seq_no           sealiner.BKP009.SUPPLIER_SQNO%TYPE
        , p_i_v_fk_port_sequence_no       TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO%TYPE
        , p_i_v_vvvoyn                    ITP063.VVVOYN%TYPE      /* Added by vikas on 18.10.2011, for afs service */
        , p_o_return_status               OUT VARCHAR2
    ) AS
        l_v_exception                     EXCEPTION;
        l_v_parameter_str                 VARCHAR2(4000);
        l_v_booking_no                    sealiner.BKP009.BIBKNO%TYPE;
        l_n_size_type_seq_no              sealiner.BKP032.EQP_SIZETYPE_SEQNO%TYPE;
        l_n_fk_bkg_voyage_routing_dtl     TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL%TYPE;
        l_n_discharge_list                TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID%TYPE;
        l_v_cont_seq                      TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO%TYPE;
        l_v_tight_connec_flag1            TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1%TYPE;
        l_v_tight_connec_flag2            TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2%TYPE;
        l_v_tight_connec_flag3            TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3%TYPE;
        l_v_dn_shipment_term              TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TERM%TYPE;
        l_v_dn_shipment_typ               TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP%TYPE;
        l_v_dn_bkg_typ                    TOS_DL_BOOKED_DISCHARGE.DN_BKG_TYP%TYPE;
        l_v_local_status                  TOS_LL_BOOKED_LOADING.LOCAL_STATUS%TYPE;
        l_v_record_add_user               TOS_DL_DISCHARGE_LIST.RECORD_ADD_USER%TYPE := 'TOS'; -- 'EZLL' modified 05.01.2012;
        l_v_load_list_id                  TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE;
        l_v_flag                          VARCHAR2(1);
        l_v_error_cd                      VARCHAR2(15);
        l_v_fk_load_list_id               TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE;
        l_v_fk_port_sequence_no           TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO%TYPE;
        l_v_dn_nxt_pod2                   TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD2%TYPE := NULL;
        l_v_mlo_vessel                    SEALINER.TOS_ONBOARD_LIST.CONNECTING_VESSEL%TYPE;
        l_v_mlo_voyage                    SEALINER.TOS_ONBOARD_LIST.CONNECTING_VOYAGE_NO%TYPE;
        l_v_mlo_pod1                      SEALINER.TOS_ONBOARD_LIST.NEXT_POD1%TYPE;
        l_v_mlo_pod2                      SEALINER.TOS_ONBOARD_LIST.NEXT_POD1%TYPE;
        l_v_mlo_pod3                      SEALINER.TOS_ONBOARD_LIST.NEXT_POD1%TYPE;
        l_v_sysdate                       DATE;  -- added 05.01.2012
    BEGIN

        l_v_parameter_str :=     p_i_v_prog_type
                                ||'~'|| p_i_v_invoyageno
                                ||'~'|| p_i_v_load_list_id
                                ||'~'|| p_i_v_flag
                                ||'~'|| p_i_v_load_port
                                ||'~'|| p_i_v_act_service_code
                                ||'~'|| p_i_v_act_vessel_code
                                ||'~'|| p_i_v_act_voyage_number
                                ||'~'|| p_i_v_act_port_direction
                                ||'~'|| p_i_v_from_terminal
                                ||'~'|| p_i_v_discharge_port
                                ||'~'|| p_i_v_to_terminal
                                ||'~'|| p_i_v_weight
                                ||'~'|| p_i_v_rftemp
                                ||'~'|| p_i_v_unit
                                ||'~'|| p_i_v_imdg
                                ||'~'|| p_i_v_unno
                                ||'~'|| p_i_v_variant
                                ||'~'|| p_i_v_flash_pt
                                ||'~'|| p_i_v_flash_pt_unit
                                ||'~'|| p_i_v_port_class
                                ||'~'|| p_i_v_oog_oh
                                ||'~'|| p_i_v_oog_olf
                                ||'~'|| p_i_v_oog_olb
                                ||'~'|| p_i_v_oog_owr
                                ||'~'|| p_i_v_oog_owl
                                ||'~'|| p_i_v_stow_position
                                ||'~'|| p_i_v_container_operator
                                ||'~'|| p_i_v_out_slot_operator
                                ||'~'|| p_i_v_han1
                                ||'~'|| p_i_v_han2
                                ||'~'|| p_i_v_han3
                                ||'~'|| p_i_v_clr1
                                ||'~'|| p_i_v_clr2
                                ||'~'|| p_i_v_connecting_vessel
                                ||'~'|| p_i_v_connecting_voyage_no
                                ||'~'|| p_i_v_next_pod1
                                ||'~'|| p_i_v_next_pod2
                                ||'~'|| p_i_v_next_pod3
                                ||'~'|| p_i_v_tight_conn_flag
                                ||'~'|| p_i_v_void_slot
                                ||'~'|| p_i_v_list_status
                                ||'~'|| p_i_v_soc_coc
                                ||'~'|| p_i_v_service
                                ||'~'|| p_i_v_vessel
                                ||'~'|| p_i_v_voyage
                                ||'~'|| p_i_v_direction
                                ||'~'|| p_i_v_pod
                                ||'~'|| p_i_v_pod_trm
                                ||'~'|| p_i_v_pol
                                ||'~'|| p_i_v_pol_trm
                                ||'~'|| p_i_v_booking
                                ||'~'|| p_i_v_equipment_no
                                ||'~'|| p_i_v_pot
                                ||'~'|| p_i_v_eqsize
                                ||'~'|| p_i_v_eqtype
                                ||'~'|| p_i_v_full_mt
                                ||'~'|| p_i_v_slot_operator
                                ||'~'|| p_i_v_final_destination
                                ||'~'|| p_i_v_voyage_seqno
                                ||'~'|| p_i_v_equipment_seq_no
                                ||'~'|| p_i_v_supplier_seq_no
                                ||'~'|| p_i_v_vvvoyn                 /* Added by vikas on 18.10.2011, for afs service */
                                ||'~'|| p_i_v_fk_port_sequence_no;

        p_o_return_status := '0';

        /*
            Start added by vikas to get a common sysdate, 05.01.2012
        */
            SELECT
                SYSDATE
            INTO
                l_v_sysdate
            FROM
                DUAL;
        /*
            End added by vikas, 05.01.2012
        */
        g_v_sql_id := 'SQL-03001';
        /*
            Check if any container found for the passed booking in TOS_DL_BOOKED_DISCHARGE table
            if no container found then throw error message.
        */

        BEGIN
            /*  Start added by vikas, equipment_seq_no and supplier_seq_no is null
                means equipment not found in BKP009 table.
                throw error, k'chatgamol, 13.12.2011
            */
            IF (p_i_v_equipment_seq_no IS NULL
                OR p_i_v_supplier_seq_no IS NULL) THEN

                g_v_err_code   := NULL;
                g_v_err_desc   := 'Equipment# not found in BKP009';
                RAISE l_v_exception;

            END IF;

            /* End added by vikas,13.12.2011*/

/*            SELECT    FK_DISCHARGE_LIST_ID
                    , FK_BKG_VOYAGE_ROUTING_DTL
                    , DN_SHIPMENT_TERM
                    , DN_SHIPMENT_TYP
                    , DN_BKG_TYP
                    , fk_port_sequence_no
            INTO      l_n_discharge_list
                    , l_n_fk_bkg_voyage_routing_dtl
                    , l_v_dn_shipment_term
                    , l_v_dn_shipment_typ
                    , l_v_dn_bkg_typ
                    , l_v_fk_port_sequence_no
            FROM  TOS_DL_BOOKED_DISCHARGE,
                  TOS_DL_DISCHARGE_LIST,
                  ITP063 ITP
            WHERE TOS_DL_DISCHARGE_LIST.FK_SERVICE                = p_i_v_act_service_code
            AND   TOS_DL_DISCHARGE_LIST.FK_VESSEL                 = p_i_v_act_vessel_code
            AND   TOS_DL_DISCHARGE_LIST.FK_VOYAGE                 = DECODE(TOS_DL_DISCHARGE_LIST.FK_SERVICE,'AFS', p_i_v_vvvoyn, p_i_v_invoyageno) /* Added by vikas on 18.10.2011, for afs service *
            AND   TOS_DL_DISCHARGE_LIST.DN_PORT                   = p_i_v_discharge_port
            AND   TOS_DL_DISCHARGE_LIST.DN_TERMINAL               = p_i_v_to_terminal
            AND   TOS_DL_BOOKED_DISCHARGE.DN_POL                  = p_i_v_load_port
            AND   TOS_DL_BOOKED_DISCHARGE.DN_POL_TERMINAL         = p_i_v_from_terminal
            AND   TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO           = p_i_v_booking
            AND   TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS        = 'BK'
            AND   TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID    = TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID
            AND   TOS_DL_DISCHARGE_LIST.FK_SERVICE                = ITP.VVSRVC
            AND   TOS_DL_DISCHARGE_LIST.FK_VESSEL                 = ITP.VVVESS
            AND   TOS_DL_DISCHARGE_LIST.FK_VOYAGE                 = DECODE(TOS_DL_DISCHARGE_LIST.FK_SERVICE,'AFS', ITP.VVVOYN, ITP.INVOYAGENO)
            AND   TOS_DL_DISCHARGE_LIST.DN_PORT                   = ITP.VVPCAL
            AND   TOS_DL_DISCHARGE_LIST.DN_TERMINAL               = ITP.VVTRM1
            AND   ITP.OMMISSION_FLAG IS NULL
            AND   TOS_DL_DISCHARGE_LIST.FK_DIRECTION               = ITP.VVPDIR
            AND   TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO       = ITP.VVPCSQ
            AND   ITP.VVVERS                                       = 99
            AND   TOS_DL_DISCHARGE_LIST.FK_VERSION                = 99
            AND   TOS_DL_DISCHARGE_LIST.RECORD_STATUS             = 'A'
            AND   TOS_DL_BOOKED_DISCHARGE.RECORD_STATUS           = 'A'
            AND   ROWNUM                                          = 1;
*/
            SELECT    DISTINCT BD.FK_DISCHARGE_LIST_ID
                    , BD.FK_BKG_VOYAGE_ROUTING_DTL
                    , BD.DN_SHIPMENT_TERM
                    , BD.DN_SHIPMENT_TYP
                    , BD.DN_BKG_TYP
                    , DL.FK_PORT_SEQUENCE_NO
            INTO      l_n_discharge_list
                    , l_n_fk_bkg_voyage_routing_dtl
                    , l_v_dn_shipment_term
                    , l_v_dn_shipment_typ
                    , l_v_dn_bkg_typ
                    , l_v_fk_port_sequence_no
            FROM    VASAPPS.TOS_DL_DISCHARGE_LIST   DL
                  , VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
            WHERE DL.PK_DISCHARGE_LIST_ID = BD.FK_DISCHARGE_LIST_ID
            AND   BD.FK_BOOKING_NO        = p_i_v_booking
            AND   DL.DN_PORT              = p_i_v_pod
            AND   DL.DN_TERMINAL          = p_i_v_pod_trm;


        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := p_i_v_booking || ' do not exists in ezll system';
                RAISE l_v_exception;
        END;

        g_v_sql_id := 'SQL-03003';
        BEGIN

            SELECT SEQ_NO.EQP_SIZETYPE_SEQNO
            INTO l_n_size_type_seq_no
            FROM SEALINER.BKP009 CNTR,
                (SELECT BOOKING_NO,SUPPLIER_SQNO,EQP_SIZETYPE_SEQNO FROM SEALINER.BOOKING_SUPPLIER_DETAIL SP
                WHERE EXISTS (SELECT 'X' FROM SEALINER.BKP032 SZ
                WHERE SP.BOOKING_NO = SZ.BCBKNO
                AND SP.EQP_SIZETYPE_SEQNO = SZ.EQP_SIZETYPE_SEQNO
                )) SEQ_NO
            WHERE CNTR.BIBKNO        = SEQ_NO.BOOKING_NO
            AND   CNTR.SUPPLIER_SQNO = SEQ_NO.SUPPLIER_SQNO
            AND   CNTR.BISEQN        = p_i_v_equipment_seq_no
            AND   CNTR.BIBKNO        = p_i_v_booking;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := 'Container not found in BKP009';
                RAISE l_v_exception;
        END;

        /* get container sequence no#*/
        BEGIN
            g_v_sql_id := 'SQL-03004';
            SELECT NVL(MAX(CONTAINER_SEQ_NO),0)
            INTO   l_v_cont_seq
            FROM   TOS_DL_BOOKED_DISCHARGE
            WHERE  FK_DISCHARGE_LIST_ID = l_n_discharge_list;

            l_v_cont_seq :=l_v_cont_seq + 1;

        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := 'Error in geting Container seq no.';
                RAISE l_v_exception;
        END;

        /* get tight connection values */
        BEGIN
            g_v_sql_id := 'SQL-03005';
            IF( (p_i_v_next_pod3 IS NOT NULL) AND (p_i_v_next_pod3 = p_i_v_pod) ) THEN
                l_v_tight_connec_flag3 := p_i_v_tight_conn_flag;
            ELSIF ( (p_i_v_next_pod2 IS NOT NULL) AND (p_i_v_next_pod2 = p_i_v_pod) ) THEN
                l_v_tight_connec_flag2 := p_i_v_tight_conn_flag;
            ELSE
                l_v_tight_connec_flag1 := p_i_v_tight_conn_flag;
            END IF;

            /* get local container status */
            IF p_i_v_voyage_seqno = 1 THEN -- it should be voyage sequence no#.
                l_v_local_status := p_i_v_local_ts;
            ELSE
                l_v_local_status := 'T';
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                    l_v_parameter_str
                    , p_i_v_prog_type
                    , g_v_opr_type
                    , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
        END ;

        /* get next pod2 values from booked discharge table. */
        BEGIN
            g_v_sql_id := 'SQL-0305A';
            SELECT DN_NXT_POD2
            INTO   l_v_dn_nxt_pod2
            FROM   TOS_DL_BOOKED_DISCHARGE
            WHERE  FK_BOOKING_NO    = p_i_v_booking
            AND    CONTAINER_SEQ_NO = p_i_v_equipment_seq_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_v_dn_nxt_pod2 := NULL;
            WHEN OTHERS THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                    l_v_parameter_str
                    , p_i_v_prog_type
                    , g_v_opr_type
                    , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
        END;

        /* No need to update MLO_VESSEL, MLO_VOYAGE when soc-coc is 'c' */
        IF ((p_i_v_soc_coc = 'S') AND ( l_v_dn_nxt_pod2 IS NULL)) THEN
            /* update mlo_vessel details */
            l_v_mlo_vessel     :=  p_i_v_connecting_vessel;
            l_v_mlo_voyage     :=  p_i_v_connecting_voyage_no;
            l_v_mlo_pod1       :=  p_i_v_next_pod1;
            l_v_mlo_pod2       :=  p_i_v_next_pod2;
            l_v_mlo_pod3       :=  p_i_v_next_pod3;
        END IF;

        /* insert new record into TOS_DL_BOOKED_DISCHARGE table */
        BEGIN
            g_v_sql_id := 'SQL-03006';
            INSERT INTO TOS_DL_BOOKED_DISCHARGE (
                  PK_BOOKED_DISCHARGE_ID
                , FK_DISCHARGE_LIST_ID
                , CONTAINER_SEQ_NO
                , FK_BOOKING_NO
                , FK_BKG_SIZE_TYPE_DTL
                , FK_BKG_SUPPLIER
                , FK_BKG_EQUIPM_DTL
                , DN_EQUIPMENT_NO
                , FK_BKG_VOYAGE_ROUTING_DTL
                , DN_EQ_SIZE
                , DN_EQ_TYPE
                , DN_FULL_MT
                , DN_BKG_TYP
                , DN_SOC_COC
                , DN_SHIPMENT_TERM
                , DN_SHIPMENT_TYP
                , LOCAL_STATUS
                , LOCAL_TERMINAL_STATUS
                , MIDSTREAM_HANDLING_CODE
                , LOAD_CONDITION
                , DN_LOADING_STATUS
                , DISCHARGE_STATUS
                , STOWAGE_POSITION
                , ACTIVITY_DATE_TIME
                , CONTAINER_GROSS_WEIGHT
                , DAMAGED
                , VOID_SLOT
                , FK_SLOT_OPERATOR
                , FK_CONTAINER_OPERATOR
                , OUT_SLOT_OPERATOR
                , DN_SPECIAL_HNDL
                , SEAL_NO
                , DN_POL
                , DN_POL_TERMINAL
                , DN_NXT_POD1
                , DN_NXT_POD2
                , DN_NXT_POD3
                , DN_FINAL_POD
                , FINAL_DEST
                , DN_NXT_SRV
                , DN_NXT_VESSEL
                , DN_NXT_VOYAGE
                , DN_NXT_DIR
                , MLO_VESSEL
                , MLO_VOYAGE
                , MLO_VESSEL_ETA
                , MLO_POD1
                , MLO_POD2
                , MLO_POD3
                , MLO_DEL
                , SWAP_CONNECTION_ALLOWED
                , FK_HANDLING_INSTRUCTION_1
                , FK_HANDLING_INSTRUCTION_2
                , FK_HANDLING_INSTRUCTION_3
                , CONTAINER_LOADING_REM_1
                , CONTAINER_LOADING_REM_2
                , FK_SPECIAL_CARGO
                , TIGHT_CONNECTION_FLAG1
                , TIGHT_CONNECTION_FLAG2
                , TIGHT_CONNECTION_FLAG3
                , FK_IMDG
                , FK_UNNO
                , FK_UN_VAR
                , FK_PORT_CLASS
                , FK_PORT_CLASS_TYP
                , FLASH_UNIT
                , FLASH_POINT
                , FUMIGATION_ONLY
                , RESIDUE_ONLY_FLAG
                , OVERHEIGHT_CM
                , OVERWIDTH_LEFT_CM
                , OVERWIDTH_RIGHT_CM
                , OVERLENGTH_FRONT_CM
                , OVERLENGTH_REAR_CM
                , REEFER_TEMPERATURE
                , REEFER_TMP_UNIT
                , DN_HUMIDITY
                , DN_VENTILATION
                , PUBLIC_REMARK
                , RECORD_STATUS
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
                , RECORD_CHANGE_USER
                , RECORD_CHANGE_DATE
            ) VALUES (
                 SE_BLZ01.NEXTVAL
                , l_n_discharge_list
                , l_v_cont_seq
                , p_i_v_booking
                , l_n_size_type_seq_no
                , p_i_v_supplier_seq_no
                , p_i_v_equipment_seq_no
                , p_i_v_equipment_no
                , l_n_fk_bkg_voyage_routing_dtl
                , p_i_v_eqsize
                , p_i_v_eqtype
                , p_i_v_full_mt
                , l_v_dn_bkg_typ
                , p_i_v_soc_coc
                , l_v_dn_shipment_term
                , l_v_dn_shipment_typ
                , l_v_local_status
                , ( CASE  WHEN l_v_local_status = 'L' THEN 'Local'  WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END)
                , NULL
                , 'L' --load_condition
                , 'LO'
                , 'BK'
                , p_i_v_stow_position
                , NULL
                , p_i_v_weight
                , NULL
                , p_i_v_void_slot
                , p_i_v_slot_operator
                , p_i_v_container_operator
                , p_i_v_out_slot_operator
                , NULL
                , NULL
                , p_i_v_pol
                , p_i_v_pol_trm
                , NULL
                , NULL
                , NULL
                , p_i_v_final_destination
                , p_i_v_final_destination
                , NULL
                , NULL
                , NULL
                , NULL
                , l_v_mlo_vessel -- p_i_v_connecting_vessel
                , l_v_mlo_voyage -- p_i_v_connecting_voyage_no
                , NULL
                , l_v_mlo_pod1
                , l_v_mlo_pod2
                , l_v_mlo_pod3
                , NULL
                , NULL
                , p_i_v_han1
                , p_i_v_han2
                , p_i_v_han3
                , p_i_v_clr1
                , p_i_v_clr2
                , NULL
                , NULL
                , NULL
                , NULL
                , p_i_v_imdg
                , p_i_v_unno
                , p_i_v_variant
                , p_i_v_port_class
                , NULL
                , p_i_v_flash_pt_unit
                , p_i_v_flash_pt
                , NULL
                , NULL
                , p_i_v_oog_oh
                , p_i_v_oog_owl
                , p_i_v_oog_owr
                , p_i_v_oog_olf
                , p_i_v_oog_olb
                , p_i_v_rftemp
                , p_i_v_unit
                , NULL
                , NULL
                , NULL
                , 'A'
                , l_v_record_add_user
                , l_v_sysdate -- SYSDATE modified, 11.01.2012
                , l_v_record_add_user
                , l_v_sysdate -- SYSDATE  modified, 11.01.2012
            );
        EXCEPTION
            WHEN OTHERS THEN
                g_v_err_code   := NULL;
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                    l_v_parameter_str
                    , p_i_v_prog_type
                    , g_v_opr_type
                    , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
        END;
        /* update load list for discharge list */
        BEGIN
            g_v_sql_id := 'SQL-03007';
            /* Start commented by vikas on, 11.11.2011 *
            PRE_EDL_PREV_LOAD_LIST_ID(
                  p_i_v_act_vessel_code
                , null
                , p_i_v_booking
                , p_i_v_pod
                , l_v_fk_port_sequence_no -- p_i_v_fk_port_sequence_no
                , l_v_load_list_id
                , l_v_flag
                , l_v_error_cd
            );
            * End commented by vikas on, 11.11.2011 */
            /* Start added by Vikas as suggested by k'chatgamol, 11.11.2011 */
            PRE_EDL_PREV_LOAD_LIST_ID(
                  p_i_v_service
                , p_i_v_vessel
                , p_i_v_voyage
                , p_i_v_pol
                , p_i_v_booking
                , NULL            /* New equipment, equipment sequence# would be null */
                , l_v_load_list_id
                , l_v_error_cd
            );
            /* End added by Vikas as suggested by k'chatgamol, 11.11.2011 */

            IF (l_v_error_cd <> PCE_EUT_COMMON.G_V_SUCCESS_CD) THEN
                g_v_err_code   := NULL;
--                g_v_err_desc   := 'container information not found.';
                g_v_err_desc    := g_error_msg_1;
                RAISE g_exception_ll;
            END IF;

            g_v_sql_id := 'SQL-0307a';
            BEGIN

                SELECT FK_LOAD_LIST_ID
                INTO   l_v_fk_load_list_id
                FROM   TOS_LL_BOOKED_LOADING
                WHERE  PK_BOOKED_LOADING_ID = l_v_load_list_id;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    g_v_err_code   := NULL;
                    g_v_err_desc   := 'Load list id not found.';
                    RAISE l_v_exception;
            END;


            IF l_v_flag = 'D' THEN
                /* Insert new record into load list table */
                g_v_sql_id := 'SQL-03008';
                INSERT INTO TOS_LL_BOOKED_LOADING (
                      PK_BOOKED_LOADING_ID
                    , FK_LOAD_LIST_ID
                    , CONTAINER_SEQ_NO
                    , FK_BOOKING_NO
                    , FK_BKG_SIZE_TYPE_DTL
                    , FK_BKG_SUPPLIER
                    , FK_BKG_EQUIPM_DTL
                    , DN_EQUIPMENT_NO
                    , EQUPMENT_NO_SOURCE
                    , FK_BKG_VOYAGE_ROUTING_DTL
                    , DN_EQ_SIZE
                    , DN_EQ_TYPE
                    , DN_FULL_MT
                    , DN_BKG_TYP
                    , DN_SOC_COC
                    , DN_SHIPMENT_TERM
                    , DN_SHIPMENT_TYP
                    , LOCAL_STATUS
                    , LOCAL_TERMINAL_STATUS
                    , MIDSTREAM_HANDLING_CODE
                    , LOAD_CONDITION
                    , LOADING_STATUS
                    , STOWAGE_POSITION
                    , ACTIVITY_DATE_TIME
                    , CONTAINER_GROSS_WEIGHT
                    , DAMAGED
                    , VOID_SLOT
                    , PREADVICE_FLAG
                    , FK_SLOT_OPERATOR
                    , FK_CONTAINER_OPERATOR
                    , OUT_SLOT_OPERATOR
                    , DN_SPECIAL_HNDL
                    , SEAL_NO
                    , DN_DISCHARGE_PORT
                    , DN_DISCHARGE_TERMINAL
                    , DN_NXT_POD1
                    , DN_NXT_POD2
                    , DN_NXT_POD3
                    , DN_FINAL_POD
                    , FINAL_DEST
                    , DN_NXT_SRV
                    , DN_NXT_VESSEL
                    , DN_NXT_VOYAGE
                    , DN_NXT_DIR
                    , MLO_VESSEL
                    , MLO_VOYAGE
                    , MLO_VESSEL_ETA
                    , MLO_POD1
                    , MLO_POD2
                    , MLO_POD3
                    , MLO_DEL
                    , EX_MLO_VESSEL
                    , EX_MLO_VESSEL_ETA
                    , EX_MLO_VOYAGE
                    , FK_HANDLING_INSTRUCTION_1
                    , FK_HANDLING_INSTRUCTION_2
                    , FK_HANDLING_INSTRUCTION_3
                    , CONTAINER_LOADING_REM_1
                    , CONTAINER_LOADING_REM_2
                    , FK_SPECIAL_CARGO
                    , TIGHT_CONNECTION_FLAG1
                    , TIGHT_CONNECTION_FLAG2
                    , TIGHT_CONNECTION_FLAG3
                    , FK_IMDG
                    , FK_UNNO
                    , FK_UN_VAR
                    , FK_PORT_CLASS
                    , FK_PORT_CLASS_TYP
                    , FLASH_UNIT
                    , FLASH_POINT
                    , FUMIGATION_ONLY
                    , RESIDUE_ONLY_FLAG
                    , OVERHEIGHT_CM
                    , OVERWIDTH_LEFT_CM
                    , OVERWIDTH_RIGHT_CM
                    , OVERLENGTH_FRONT_CM
                    , OVERLENGTH_REAR_CM
                    , REEFER_TMP
                    , REEFER_TMP_UNIT
                    , DN_HUMIDITY
                    , DN_VENTILATION
                    , PUBLIC_REMARK
                    , RECORD_STATUS
                    , RECORD_ADD_USER
                    , RECORD_ADD_DATE
                    , RECORD_CHANGE_USER
                    , RECORD_CHANGE_DATE
                ) VALUES (
                      SE_BLZ01.NEXTVAL
                    , l_v_fk_load_list_id
                    , l_v_cont_seq
                    , p_i_v_booking
                    , l_n_size_type_seq_no
                    , p_i_v_supplier_seq_no
                    , p_i_v_equipment_seq_no
                    , p_i_v_equipment_no
                    ,  'B'
                    , l_n_fk_bkg_voyage_routing_dtl
                    , p_i_v_eqsize
                    , p_i_v_eqtype
                    , p_i_v_full_mt
                    , l_v_dn_bkg_typ
                    , p_i_v_soc_coc
                    , l_v_dn_shipment_term
                    , l_v_dn_shipment_typ
                    , l_v_local_status
                    , ( CASE  WHEN l_v_local_status = 'L' THEN 'Local'  WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END)
                    , NULL
                    , 'L'
                    , 'BK'
                    , p_i_v_stow_position
                    , NULL
                    , p_i_v_weight
                    , NULL
                    , p_i_v_void_slot
                    , NULL
                    , p_i_v_slot_operator
                    , p_i_v_container_operator
                    , p_i_v_out_slot_operator
                    , NULL
                    , NULL
                    , p_i_v_pol
                    , p_i_v_pol_trm
                    , NULL
                    , NULL
                    , NULL
                    , p_i_v_final_destination
                    , p_i_v_final_destination
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , p_i_v_connecting_vessel
                    , p_i_v_connecting_voyage_no
                    , NULL
                    , l_v_mlo_pod1
                    , l_v_mlo_pod2
                    , l_v_mlo_pod3
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , p_i_v_han1
                    , p_i_v_han2
                    , p_i_v_han3
                    , p_i_v_clr1
                    , p_i_v_clr2
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , p_i_v_imdg
                    , p_i_v_unno
                    , p_i_v_variant
                    , p_i_v_port_class
                    , NULL
                    , p_i_v_flash_pt_unit
                    , p_i_v_flash_pt
                    , NULL
                    , NULL
                    , p_i_v_oog_oh
                    , p_i_v_oog_owl
                    , p_i_v_oog_owr
                    , p_i_v_oog_olf
                    , p_i_v_oog_olb
                    , p_i_v_rftemp
                    , p_i_v_unit
                    , NULL
                    , NULL
                    , NULL
                    , 'A'
                    , l_v_record_add_user -- 'EZLL' modified, 11.01.2012SYSDATE
                    , l_v_sysdate -- SYSDATE modified, 11.01.2012SYSDATE
                    , l_v_record_add_user  -- 'EZLL' modified, 11.01.2012SYSDATE
                    , l_v_sysdate -- SYSDATE  modified, 11.01.2012SYSDATE
                );
            END IF;
        EXCEPTION
            WHEN  g_exception_ll THEN
                p_o_return_status := '1';
                g_v_err_desc := 'Error in updating previous load list.';
                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                      l_v_parameter_str
                    , p_i_v_prog_type
                    , g_v_opr_type
                    ,  g_v_sql_id ||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
            WHEN OTHERS THEN
                g_v_err_code   := TO_CHAR(SQLCODE);
                g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                    , p_i_v_prog_type
                    , g_v_opr_type
                    ,  g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                    , 'A'
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                    , l_v_record_add_user
                    , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                );
                COMMIT;
        END;

    EXCEPTION
        WHEN  l_v_exception THEN
            p_o_return_status := '1';
            ROLLBACK;
            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                  l_v_parameter_str
                , p_i_v_prog_type
                , g_v_opr_type
                ,  g_v_sql_id ||'~'||g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
            );
            COMMIT;

        WHEN NO_DATA_FOUND THEN
            p_o_return_status := '1';
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            ROLLBACK;

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                  l_v_parameter_str
                , p_i_v_prog_type
                , g_v_opr_type
                , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
            );
            COMMIT;
        WHEN OTHERS THEN
            p_o_return_status := '1';
            g_v_err_code   := TO_CHAR(SQLCODE);
            g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            -- ROLLBACK;

            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                  l_v_parameter_str
                , p_i_v_prog_type
                , g_v_opr_type
                ,  g_v_sql_id ||'~'||g_v_err_code||'~'||g_v_err_desc
                , 'A'
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
                , l_v_record_add_user
                , l_v_sysdate -- CURRENT_TIMESTAMP  modified, 11.01.2012
            );
            COMMIT;

            RETURN;
    END PRE_TOS_NEW_EQUIPMENT_ADD;

    PROCEDURE PRE_EDL_PREV_LOAD_LIST_ID (
          p_i_v_service                VARCHAR2
        , p_i_v_vessel                 VARCHAR2
        , p_i_v_voyage                 VARCHAR2
        , p_i_v_pol                    VARCHAR2
        , p_i_v_booking                VARCHAR2
        , p_i_v_equipment_no           VARCHAR2
        , p_o_v_pk_loading_id          OUT VARCHAR2
        , p_o_v_err_cd                 OUT VARCHAR2
    )
    AS

    BEGIN
        p_o_v_err_cd    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    /*    Start Commented by vikas AS suggested by k'chatgamol, 11.11.2011 *

        SELECT  PK_LOADING_ID
                , FLAG
        INTO     p_o_v_pk_loading_id
                , p_o_v_flag
        FROM (
                SELECT    PK_LOADING_ID
                        , FLAG
                        , ROW_NUMBER() OVER (ORDER BY ACTIVITY_DATE_TIME DESC) SRNO
                FROM    (
                            SELECT     LLB.PK_BOOKED_LOADING_ID PK_LOADING_ID
                                    ,'D' FLAG
                                    , ACTIVITY_DATE_TIME
                            FROM      TOS_LL_LOAD_LIST LL ,
                                    TOS_LL_BOOKED_LOADING LLB,
                                    ITP063 ITP,
                                    ITP040 P
                            WHERE     LL.RECORD_STATUS        = 'A'
                            AND       LLB.RECORD_STATUS       = 'A'
                            AND       LL.PK_LOAD_LIST_ID      = LLB.FK_LOAD_LIST_ID
                            AND       LL.FK_VESSEL             = p_i_v_vessel
                            AND       (p_i_v_equip_seq_no IS NULL or LLB.FK_BKG_EQUIPM_DTL     = p_i_v_equip_seq_no)
                            AND       (
                                    (p_i_v_booking_no is NULL) OR
                                    (LLB.FK_BOOKING_NO        = p_i_v_booking_no)
                                    )
                            AND       P.PICODE                = LL.DN_PORT
                            AND       LL.FK_SERVICE           = ITP.VVSRVC
                            AND       LL.FK_VESSEL            = ITP.VVVESS
                            AND       LL.FK_VOYAGE            = ITP.VVVOYN
                            AND       LL.FK_DIRECTION         = ITP.VVPDIR
                            AND       LL.FK_PORT_SEQUENCE_NO  = ITP.VVPCSQ
                            AND       ITP.OMMISSION_FLAG IS NULL
                            AND       ITP.VVVERS              = 99
                            AND       LL.FK_VERSION           = 99
                            AND       LL.FK_PORT_SEQUENCE_NO  < p_i_v_port_seq
                        )
                        ORDER BY ACTIVITY_DATE_TIME DESC
                )
        WHERE SRNO = 1;

        * End commented by vikas AS suggested by k'chatgamol, 11.11.2011 */

        /* Start added by vikas as per suggested by k'chatgamol, 11.11.2011 */


        SELECT  BL.PK_BOOKED_LOADING_ID
        INTO    p_o_v_pk_loading_id
        FROM    VASAPPS.TOS_LL_LOAD_LIST LL,
                VASAPPS.TOS_LL_BOOKED_LOADING BL
        WHERE   LL.fk_service            = p_i_v_service
        AND     LL.fk_vessel             = p_i_v_vessel
        AND     LL.fk_voyage             = p_i_v_voyage
        AND     LL.DN_PORT               = p_i_v_pol
        AND     LL.PK_LOAD_LIST_ID       = bl.fk_load_list_id
        And     Bl.Fk_Booking_No         = p_i_v_booking
        AND     ((p_i_v_equipment_no IS NULL ) OR
                (BL.DN_EQUIPMENT_NO       = p_i_v_equipment_no))
        and rownum = 1;
        /*
        AND     BL.FK_BOOKING_NO IN
                    (SELECT     DISTINCT FK_BOOKING_NO
                    FROM        VASAPPS.TOS_LL_BOOKED_LOADING
                    WHERE       FK_BOOKING_NO = p_i_v_booking);

        AND     ((p_i_v_equip_seq_no IS NULL)
                OR (BL.FK_BKG_EQUIPM_DTL =  p_i_v_equip_seq_no ));
        */
dbms_output.put_line('p_o_v_pk_loading_id ' || p_o_v_pk_loading_id);
        /* End added by vikas as per suggested by k'chatgamol, 11.11.2011 */

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         p_o_v_pk_loading_id       :=  NULL;
         -- p_o_v_flag                :=  NULL;
         p_o_v_err_cd              :=  'EDL.SE0121';
         RETURN;

      WHEN OTHERS THEN
        dbms_output.put_line('Error in previous load list: ' || SQLERRM);

        p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        RETURN;

    END PRE_EDL_PREV_LOAD_LIST_ID;

END PCE_ECM_SYNC_TOS_EZDL;