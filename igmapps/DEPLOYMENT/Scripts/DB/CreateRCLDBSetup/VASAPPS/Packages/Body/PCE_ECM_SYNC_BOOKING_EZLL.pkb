CREATE OR REPLACE PACKAGE BODY PCE_ECM_SYNC_BOOKING_EZLL AS
/*
    *1:  Modified by vikas, for DFS service use actual voyage as invoyage, 06.02.2012
    *2:  Modified by vikas, after remove booking logic commit the changes, as k'chatgamol, 12.03.2012
    *3:  Modified by vikas, Modify the logic of change *2 , as k'chatgamol, 29.03.2012
    *4:  Modified by vikas, Check if booking is Normal then update blank DG details in
         booking, as k'chatgamol,30.03.2012
    *5:  Modified by vikas, When previous leg is truck / rail then the current leg would be local
         as suggested by k'chatgamol and guru, 02.04.2012
    *6:  Modified by vikas, When service is DFS then no need to
         check VVFORL flag in ITP063 table, as k'chatgamol, 04.04.2012
    *7:  Modified by vikas, Activate EMS operations, as k'chatgamol, 20.04.2012
    *8:  Modified by Leena, Add from-terminal in delete logic of renom, 23.04.2012
    *9:  Modified by vikas, update local_terminal_status also when update local_status
         from bookings, as k'chatgamol, 09.05.2012
    *10: Modified by vikas, update crane_type also when added new record in booked table,
         as k'chatgamol, 31.05.2012
    *11: Modified by vikas, update load condition also when updating tos information to booking
        as k'chatgamol, 05.06.2012
    *12: Modified by vikas, change time stamp to sysdate because sysdate give the server time
         and current time stamp give the local time, 04.07.2012
    *13: Modified by vikas, while updating container in ezll/ezdl, if discharge list status
         is more or equal to 10 and cell location not blank, then update
         loading /discharge status to loaded/discharge, as k'chatgamol, 06.07.2012
    *14: Modified by vikas, in case of excptione in calling ems logic no need to
         terminate the process, as k'chatgamol, 01.08.2012
    *15: Modified by vikas, in case of exception in getting service group
         no need to terminate the process, as k'chatgamol, 06.08.2012
    *18: Modified by vikas, Change calling of default crane type function from
         PKG_TOS_RCL.PRC_TOS_GET_DEFAULT_CRANE to PKG_TOS_RCL_EZLL.PRC_TOS_GET_DEFAULT_CRANE
         as per k'chatgamol, 27.08.2012.
    *19: Modified by vikas,In booking synchronization check booking(BKP009) updated by user (not EZLL)
        then no need to update DG information into EZLL/EZDL, if booking(or DG information) updated by EZLL
        (EZLL/EZDL maintenance screen) then update DG information back to EZLL/EZDL, as k'chatgamol, 11.09.2012
    *20: Modified by vikas, When Create EZDL/EZLL, update/insert eta date as
         activity date, as k'chatgamol, 01.11/2012
    *21: Modified by vikas, In booking synch check if special handling is normal then no need
         to update DG information into booking, as k'chatgamol, 29.11.2012
    *22: Modified by vikas, Raise e-notice when equipment updated from BKP001
         synchronization, as k'chatgamol, 14.12.2012
    *23: Modified by vikas, raise enotice only for the discharge/load list which is
         complete or higher then discahrge complete/load complete, 17.01.2013.
    *24: Modified by vikas, for synchronization e-notice call from first leg only,
         as k'chatgamol, 24.01.2013
    *25: Modified by vikas, When status is ROB then no need to automaticly change
         load/discharge status while creating load/discharge list, k'chatgamol, 07.03.2013
    *26: Modified by Leena, When the dg details are updated from LL screen,
         or thru EDI, do not sync port class and vice versa.
	*27: Modified by Leena, If both Flash point and Flash unit is available in bkg DG table,
         then use them during creation of LL and DL
  *28: Block not to update any DG from LL or DL to HK except it update from booking directly
  *29 : Refresh DG and temparature data from booking if reactive suspend record
  *30  SYNC WEIGHT/CATEGORY FROM BOOKING TO EZLL/EZDL BY WACCHO1 ON 08/08/2016.
  *31  SYNC VGM FROM BOOKING TO EZLL/EZDL BY WACCHO1 ON 16/08/2016
  *32  REMOVE LOGGING INTO TOS_SYNC_ERROR_LOG BY WATCHARE ON 13/10/2016
  *33  remove PCE_ECM_EMS.PRE_UPDATE_EMS_BKG for ezdl as per K.Chatgamol advise on 20/03/2018, sometime update with wrong booking the remove.  
*/
    LOAD_LIST          CONSTANT VARCHAR2(1) DEFAULT 'L';  /* *23 * */
    DISCHARGE_LIST     CONSTANT VARCHAR2(1) DEFAULT 'D';  /* *23 * */
    ACTIVE             CONSTANT VARCHAR2(1) DEFAULT 'A';  /* *23 * */
    ALERT_REQUIRED     CONSTANT VARCHAR2(2) DEFAULT '5';  /* *23 * */
    DISCHARGE_COMPLETE CONSTANT VARCHAR2(2) DEFAULT '10'; /* *23 * */
    READY_FOR_INVOICE  CONSTANT VARCHAR2(2) DEFAULT '20'; /* *23 * */
    WORK_COMPLETE      CONSTANT VARCHAR2(2) DEFAULT '30'; /* *23 * */

    PROCEDURE PRE_TOS_CREATE_REMOVE_LL_DL (
       p_i_v_booking_no              IN           VARCHAR2,
       p_i_v_booking_type            IN           VARCHAR2,
       p_i_v_old_booking_status      IN           VARCHAR2,
       p_i_v_new_booking_status      IN           VARCHAR2,
       p_o_v_return_status           OUT NOCOPY   VARCHAR2
    ) AS
    /********************************************************************************
    * Name           : PRE_TOS_CREATE_REMOVE_LL_DL                                  *
    * Module         : EZLL                                                         *
    * Purpose        : This  Stored  Procedure is for Creation or Removal of        *
    *                : Booking from Load / Discharge List                           *
    * Calls          : None                                                         *
    * Returns        : NONE                                                         *
    * Steps Involved :                                                              *
    * History        : None                                                         *
    * Author           Date          What                                           *
    * ---------------  ----------    ----                                           *
    * Arijeet Palt     17/01/2011     1.0                                           *
    *********************************************************************************/
    l_e_error_found                            EXCEPTION;
    l_v_errcd                                  VARCHAR2(50);
    l_v_errmsg                                 TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
    l_v_sql_type                               VARCHAR2(1);
    l_v_parameter_str                          TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;

    PRAGMA AUTONOMOUS_TRANSACTION;

    BEGIN
        l_v_parameter_str := p_i_v_booking_no||'~'||
                             p_i_v_booking_type||'~'||
                             p_i_v_old_booking_status||'~'||
                             p_i_v_new_booking_status;
        -- RAISE EXCEPTION AND RETURN FAILED WHEN OLD BOOKING STATUS IS NULL OR NEW BOOKING STATUS IS NULL
        g_v_sql_id := 'SQL-01001';
        IF     p_i_v_old_booking_status IS NULL AND p_i_v_new_booking_status IS NULL THEN
            p_o_v_return_status := '0';
        ELSE

            IF p_i_v_booking_type IN ('N','ER','FC') THEN
                -- CALL PROCEDURE REMOVE BOOKING WHEN OLD BOOKING STATUS IS (c'L'osed,'P'artial,'C'onfirm) AND NEW BOOKING STATUS IS NOT (c'L'osed,'P'artial,'C'onfirm)
                g_v_sql_id := 'SQL-01002';
                IF     p_i_v_old_booking_status IN ('L','P','C') AND p_i_v_new_booking_status NOT IN ('L','P','C') THEN
                    l_v_sql_type := 'D';
                    dbms_output.put_line('delete logic called');
                    PRE_TOS_REMOVE_BKG (p_i_v_booking_no, p_o_v_return_status);
                END IF;

                IF p_o_v_return_status = '1' THEN
                   RAISE l_e_error_found;
                END IF;

                g_v_sql_id := 'SQL-01003';
                -- CALL PROCEDURE CREATE BOOKING WHEN OLD BOOKING STATUS IS NOT (c'L'osed,'P'artial,'C'onfirm) AND NEW BOOKING STATUS IS (c'L'osed,'P'artial,'C'onfirm)
                IF  p_i_v_old_booking_status NOT IN ('L','P','C') AND p_i_v_new_booking_status IN ('L','P','C') THEN
                    l_v_sql_type := 'A';

                    PRE_TOS_CREATE_LL_DL (p_i_v_booking_no,p_o_v_return_status);
                END IF;

                IF p_o_v_return_status = '1' THEN
                   RAISE l_e_error_found;
                END IF;
            ELSE
                p_o_v_return_status := '0';
            END IF;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN l_e_error_found THEN
            g_v_err_code   := NVL(g_v_err_code,TO_CHAR (SQLCODE));
            g_v_err_desc   := SUBSTR(NVL(g_v_err_desc,SQLERRM),1,100);
            ROLLBACK;
            PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str,
                                'BKP001_M',
                                l_v_sql_type,
                                g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc,
                                'A',
                                g_v_user,
                                SYSDATE,  -- CURRENT_TIMESTAMP, -- *12
                                g_v_user,
                                SYSDATE,  -- CURRENT_TIMESTAMP, -- *12
                                g_v_record_filter,
                                g_v_record_table
                               );
            COMMIT;
        WHEN OTHERS THEN
            p_o_v_return_status := '1';
            g_v_err_code   := NVL(g_v_err_code,TO_CHAR (SQLCODE));
            g_v_err_desc   := SUBSTR(NVL(g_v_err_desc,SQLERRM),1,100);
            ROLLBACK;
            PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str,
                                'BKP001_O',
                                l_v_sql_type,
                                g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc,
                                'A',
                                g_v_user,
                                SYSDATE,  -- CURRENT_TIMESTAMP, -- *12
                                g_v_user,
                                SYSDATE,  -- CURRENT_TIMESTAMP, -- *12
                                g_v_record_filter,
                                g_v_record_table
                               );
            COMMIT;
    END;


    PROCEDURE PRE_TOS_CREATE_LL_DL (
       p_i_v_booking_no              IN              VARCHAR2,
       p_o_v_return_status           OUT  NOCOPY     VARCHAR2
    ) AS
    /********************************************************************************
    * Name           : PRE_TOS_CREATE_LL_DL                                         *
    * Module         : EZLL                                                         *
    * Purpose        : This  Stored  Procedure is for create load list
                        and discharge_list                                          *
    * Calls          : None                                                         *
    * Returns        : NONE                                                         *
    * Steps Involved :                                                              *
    * History        : None                                                         *
    * Author           Date          What                                           *
    * ---------------  ----------    ----                                           *
    * Devendra Kumar 14/01/2011     1.0                                             *
    *********************************************************************************/
    BEGIN
        g_v_sql_id := 'SQL-02001';
    --For create load list

       PRE_TOS_CREATE_LOAD_LIST ( p_i_v_booking_no , '', '', '', '', '', p_o_v_return_status );

    IF p_o_v_return_status = 0 THEN
        g_v_sql_id := 'SQL-02002';
    --For create discharge list
       PRE_TOS_CREATE_DISCHARGE_LIST ( p_i_v_booking_no , '', '', '', '', '', p_o_v_return_status );
    END IF;

    END;


PROCEDURE PRE_TOS_CREATE_LOAD_LIST (
    p_i_v_booking_no              IN              VARCHAR2,
    p_i_n_voyseq                  IN              NUMBER,
    p_i_n_loadid                  IN              NUMBER,
    p_i_n_equipment_seq_no        IN              NUMBER,
    p_i_n_size_type_seq_no        IN              NUMBER,
    p_i_n_supplier_seq_no         IN              NUMBER,
    p_o_v_return_status           OUT  NOCOPY     VARCHAR2
                                    ) AS

    --p_o_v_return_status VARCHAR2(1);
    l_v_next_service    TOS_LL_BOOKED_LOADING.DN_NXT_SRV%TYPE;
    l_v_next_vessel     TOS_LL_BOOKED_LOADING.DN_NXT_VESSEL%TYPE;
    l_v_next_voyno      TOS_LL_BOOKED_LOADING.DN_NXT_VOYAGE%TYPE;
    l_v_next_dir        TOS_LL_BOOKED_LOADING.DN_NXT_DIR%TYPE;
    l_n_load_id         TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID%TYPE;
    l_v_imo_class       TOS_LL_BOOKED_LOADING.FK_IMDG%TYPE;
    l_v_variant         TOS_LL_BOOKED_LOADING.FK_UN_VAR%TYPE;
    l_v_un_no           TOS_LL_BOOKED_LOADING.FK_UNNO%TYPE;
    l_v_hz_bs           TOS_LL_BOOKED_LOADING.FLASH_UNIT%TYPE;
    l_v_next_pod1       TOS_LL_BOOKED_LOADING.DN_NXT_POD1%TYPE;
    l_v_next_pod2       TOS_LL_BOOKED_LOADING.DN_NXT_POD2%TYPE;
    l_v_next_pod3       TOS_LL_BOOKED_LOADING.DN_NXT_POD3%TYPE;
    l_v_portclass       TOS_LL_BOOKED_LOADING.FK_PORT_CLASS%TYPE;
    l_v_portclasstype   TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP%TYPE;
    l_v_op_code         TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE;
    l_v_slot_op_code    TOS_LL_BOOKED_LOADING.FK_SLOT_OPERATOR%TYPE;
    l_v_out_slot_op_code TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE;
    l_v_local_status    TOS_LL_BOOKED_LOADING.LOCAL_STATUS%TYPE;
    l_v_grp_cd          TOS_LL_LOAD_LIST.DN_SERVICE_GROUP_CODE%TYPE;
    --l_v_cont_seq        TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO%TYPE;
    l_v_cont_seq        NUMBER;
    l_v_rob             VARCHAR2(5);
    l_v_errcd           TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
    l_v_errmsg          VARCHAR2(200);
    l_exc_user          EXCEPTION;
    l_v_sql_id          VARCHAR2(5);
    l_d_time            TIMESTAMP;
    l_v_version         TOS_LL_LOAD_LIST.FK_VERSION%TYPE;
    l_v_status          VARCHAR2(5);
    l_v_load_status     TOS_LL_LOAD_LIST.LOAD_LIST_STATUS%TYPE;
    l_n_discharge_id    TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE;
    l_v_check_listid    VARCHAR2(1):='Y';
    l_n_check           NUMBER:=0;
    l_n_insert          NUMBER:=0;
    l_v_rec_count       NUMBER DEFAULT 0;
    l_n_list_upd_id     NUMBER;
    l_v_stow_pos_rob    TOS_LL_BOOKED_LOADING.STOWAGE_POSITION%TYPE;
    l_v_fumigation_only TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY%TYPE; --Added by bindu on 31/03/3011
    l_v_residue         TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG%TYPE; --Added by bindu on 31/03/3011
    l_v_pk_booked_loading_id TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE;
    l_v_dn_port         TOS_LL_LOAD_LIST.DN_PORT%TYPE;
    l_v_dn_terminal     TOS_LL_LOAD_LIST.DN_TERMINAL%TYPE;
    l_v_is_dg            VARCHAR2(1) ; -- added by vikas to identify dg booking, 30.11.2011
    l_v_record_status    VARCHAR2(1); -- added by vikas, 01.12.2011
    L_V_CRANE_TYPE      TOS_LL_BOOKED_LOADING.CRANE_TYPE%TYPE; -- *10
    L_V_ETA_DATE DATE; /* *20 */
	L_V_FLASH_POINT     NUMBER; -- *27
  l_n_found           NUMBER:=0; -- *28
  l_v_bookingno      VARCHAR2(13); -- *29

    CURSOR l_cur_voyage IS
    SELECT SERVICE, VESSEL, VOYNO, DIRECTION, LOAD_PORT, DISCHARGE_PORT ,
        TO_TERMINAL ,POL_PCSQ, BOOKING_NO,VOYAGE_SEQNO,FROM_TERMINAL
    FROM   BOOKING_VOYAGE_ROUTING_DTL
    WHERE  BOOKING_NO=p_i_v_booking_no
    AND    ROUTING_TYPE='S'
    AND    VOYAGE_SEQNO=NVL(p_i_n_voyseq,VOYAGE_SEQNO)
    AND    VESSEL IS NOT NULL
    AND    VOYNO IS NOT NULL
    ORDER BY VOYAGE_SEQNO;

    CURSOR l_cur_detail IS
    SELECT T_032.EQP_SIZETYPE_SEQNO FK_BKG_SIZE_TYPE_DTL,
        T_032.POL_STAT LOCAL_STATUS,
        T_032.BUNDLE,T_032.OPR_VOID_SLOT VOID_SLOT,
        T_032.HANDLING_INS1 FK_HANDLING_INSTRUCTION_1,
        T_032.HANDLING_INS2 FK_HANDLING_INSTRUCTION_2,
        T_032.HANDLING_INS3 FK_HANDLING_INSTRUCTION_3,
        T_032.CLR_CODE1 CONTAINER_LOADING_REM_1,
        T_032.CLR_CODE2 CONTAINER_LOADING_REM_2,
        T_032.SPECIAL_CARGO_CODE FK_SPECIAL_CARGO ,T_001.BOOKING_TYPE DN_BKG_TYP,
        T_001.BABKTP DN_SOC_COC,T_001.BAMODE DN_SHIPMENT_TERM,
        T_001.BASTP1 DN_SHIPMENT_TYP,
        --SUBSTR(T_001.SLOT_PARTNER_CODE, 1, 4) SLOT_PARTNER_CODE,
        T_001.BAOPCD SLOT_PARTNER_CODE,
        T_001.BADSTN FINAL_DEST,MLO_VESSEL EX_MLO_VESSEL,
        DECODE(T_001.BABKTP,'C','RCL',l_v_op_code) FK_CONTAINER_OPERATOR,
        T_009.HUMIDITY HUMIDITY,
        --DECODE(BABKTP,'C','RCL','S',DECODE(BOOKING_TYPE,'N','RCL','FC',
        --l_v_slot_op_code)) FK_SLOT_OPERATOR,
        T_001.BAOPCD FK_SLOT_OPERATOR, --modified by Bindu on 01/04/2011.
        FE_DATE_TIME(MLO_ETA,MLO_ETA_TIME) EX_MLO_VESSEL_ETA,
        MLO_VOYAGE EX_MLO_VOYAGE, BIBKNO FK_BOOKING_NO,BISEQN FK_BKG_EQUIPM_DTL,
        BICTRN DN_EQUIPMENT_NO, 'B' EQUPMENT_NO_SOURCE,
        T_009.BICSZE DN_EQ_SIZE,BICNTP DN_EQ_TYPE,BIEORF DN_FULL_MT,
        (
        CASE  WHEN T_009.SHIPMENT_TYPE = 'BBK' THEN 'L'
                WHEN T_032.BUNDLE > 0 THEN 'P'
        ELSE BIEORF
        END
        )
        LOAD_CONDITION,'BK' LOADING_STATUS,MET_WEIGHT CONTAINER_GROSS_WEIGHT,
        T_009.SPECIAL_HANDLING DN_SPECIAL_HNDL,
        --UN_VARIANT FK_UN_VAR,
        BIXHGT OVERHEIGHT_CM,
        BIXWDL OVERWIDTH_LEFT_CM,BIXWDR OVERWIDTH_RIGHT_CM,
        BIXLNF OVERLENGTH_FRONT_CM,BIXLNB OVERLENGTH_REAR_CM,T_001.BAPOD DN_FINAL_POD,
        BIRFFM REEFER_TMP,BIRFBS REEFER_TMP_UNIT,T_009.SUPPLIER_SQNO FK_BKG_SUPPLIER,
        --T_032.FUMIGATION FUMIGATION_ONLY,T_032.RESIDUE RESIDUE_ONLY_FLAG,
        --Modification start by bindu on 31/03/3011
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                l_v_fumigation_only ELSE NULL END) FUMIGATION_ONLY,
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                l_v_residue ELSE NULL END)          RESIDUE_ONLY_FLAG,
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                l_v_imo_class ELSE NULL END)         FK_IMDG,
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                l_v_un_no ELSE NULL END)             FK_UNNO,
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                l_v_variant ELSE NULL END)         FK_UN_VAR,
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                l_v_portclass ELSE NULL END)         FK_PORT_CLASS,
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                l_v_portclasstype ELSE NULL END)   FK_PORT_CLASS_TYP,
        --*27 start
        /*(CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                l_v_hz_bs ELSE NULL END)             FLASH_UNIT,
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                BIFLPT ELSE NULL END)                 FLASH_POINT,*/
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' AND  L_V_HZ_BS IS NOT NULL AND L_V_FLASH_POINT IS NOT NULL) THEN
                  L_V_HZ_BS ELSE NULL END) FLASH_UNIT,
        (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1'  AND  L_V_HZ_BS IS NOT NULL AND L_V_FLASH_POINT IS NOT NULL) THEN
                L_V_FLASH_POINT ELSE NULL END) FLASH_POINT,
        --*27 end
        T_009.AIR_PRESSURE DN_VENTILATION
        -- START *30
        ,T_009.EQP_CATEGORY AS VGM_CATEGORY
        -- END *30
        -- START *31
        ,T_009.EQP_VGM AS VGM 
        -- END *31
    FROM   BKP032 T_032, BKP001 T_001, BKP009 T_009, BOOKING_SUPPLIER_DETAIL BSD
    WHERE  T_032.EQP_SIZETYPE_SEQNO = BSD.EQP_SIZETYPE_SEQNO
    AND    T_032.BCBKNO             = BSD.BOOKING_NO
    AND    T_032.BCBKNO             = T_001.BABKNO
    AND    T_009.BIBKNO             = T_001.BABKNO
    --AND    T_032.BCSIZE=T_009.BICSZE
    --AND    T_032.BCTYPE=T_009.BICNTP
    AND    T_009.SUPPLIER_SQNO      = BSD.SUPPLIER_SQNO
    AND    T_001.BABKNO             = p_i_v_booking_no
    AND    T_009.BISEQN             = NVL(p_i_n_equipment_seq_no, T_009.BISEQN)
    AND    T_032.EQP_SIZETYPE_SEQNO = NVL(p_i_n_size_type_seq_no, T_032.EQP_SIZETYPE_SEQNO)
    AND    T_009.SUPPLIER_SQNO      = NVL(p_i_n_supplier_seq_no, T_009.SUPPLIER_SQNO);
    --Modification end by bindu on 31/03/3011
    BEGIN
    l_v_version:='99';
    l_d_time:= SYSDATE ; -- CURRENT_TIMESTAMP; --*12



    --Select operator code
    BEGIN
        g_v_sql_id := 'SQL-03001';
        SELECT NVL(MAX(CASE WHEN  BKP.BNCSTP='O' THEN OPERATOR_CODE ELSE NULL END), '****') OPERATOR_CODE
                --MAX(CASE WHEN  BKP.BNCSTP='S' THEN OPERATOR_CODE ELSE NULL END) SLOT_OPERATOR_CODE --modified by Bindu on 01/04/2011.
        INTO l_v_op_code --,l_v_slot_op_code
        FROM ITP010 ITP, BKP030 BKP
        WHERE ITP.CUCUST = BKP.BNCSCD AND BKP.BNCSTP IN ('O')
        AND BNBKNO = p_i_v_booking_no;
    EXCEPTION
        WHEN OTHERS THEN
            --l_v_op_code:='';
            --l_v_slot_op_code := '';

            /*
                block added to improve logging, vikas, 06.02.2012
            */
            g_v_err_code := TO_CHAR (SQLCODE);
            g_v_err_desc := SUBSTR(SQLERRM,1,100);
            g_v_record_filter := 'BNBKNO:'|| p_i_v_booking_no  ;
            g_v_record_table  := 'operator code not match in ITP010 and BKP030' ;
            /*
                block ended to improve logging, vikas, 06.02.2012
            */

            RAISE l_exc_user ;
    END;

    --Imo class, un no etc from dg_comm_detail
        BEGIN
            g_v_sql_id := 'SQL-03002';
            SELECT '1', IMO_CLASS, UN_NO, HZ_BS, nvl(UN_VARIANT,'-'), FUMIGATION_YN, RESIDUE  --Modified by bindu on 31/03/3011
				,HZ_FLPT_FROM  --*27
            INTO l_v_is_dg, l_v_imo_class, l_v_un_no, l_v_hz_bs, l_v_variant, l_v_fumigation_only, l_v_residue --Modified by bindu on 31/03/3011
				,L_V_FLASH_POINT --*27
            FROM BOOKING_DG_COMM_DETAIL
            WHERE BOOKING_NO = p_i_v_booking_no
            AND IMO_CLASS    = (SELECT MIN(IMO_CLASS)
                                FROM BOOKING_DG_COMM_DETAIL
                                WHERE BOOKING_NO = p_i_v_booking_no)
            AND ROWNUM=1;
        EXCEPTION
            WHEN OTHERS THEN
                l_v_imo_class       := NULL;
                l_v_un_no           := NULL;
                l_v_hz_bs           := NULL;
                l_v_variant         := NULL;
                l_v_fumigation_only := NULL; --Added by bindu on 31/03/3011
                l_v_residue         := NULL; --Added by bindu on 31/03/3011

                g_v_record_filter := 'BOOKING_NO:'|| p_i_v_booking_no  ;
                g_v_record_table  := 'IMO_CLASS Not found in BOOKING_DG_COMM_DETAIL' ;

        END;
    --Main cursor from routing table
    g_v_sql_id := 'SQL-03003';
    FOR l_cur_voyage_rec IN l_cur_voyage LOOP

    --Procedure for return next pod1,pod2,pod3,vessel,service etc
                BEGIN
                    PRE_GET_NEXT_POD
                    (
                    l_cur_voyage_rec.BOOKING_NO,l_cur_voyage_rec.VOYAGE_SEQNO,l_v_next_pod1 ,
                    l_v_next_pod2 ,l_v_next_pod3 ,l_v_next_service ,l_v_next_vessel ,l_v_next_voyno ,l_v_next_dir
                    );
                END;
    --For local status
    g_v_sql_id := 'SQL-03004';

    --Check load list exist or not
    IF p_i_n_loadid IS NULL THEN
        BEGIN
            SELECT PK_LOAD_LIST_ID
            INTO l_n_load_id
            FROM TOS_LL_LOAD_LIST
            WHERE FK_SERVICE          = l_cur_voyage_rec.SERVICE
            AND FK_VESSEL             = l_cur_voyage_rec.VESSEL
            AND FK_VOYAGE             = l_cur_voyage_rec.VOYNO
            AND FK_DIRECTION          = l_cur_voyage_rec.DIRECTION
            AND DN_PORT               = l_cur_voyage_rec.LOAD_PORT
            AND DN_TERMINAL           = l_cur_voyage_rec.FROM_TERMINAL  -- Added by vikas, 24.11.2011 to remove duplicate booking
            AND RECORD_STATUS         = 'A'
            AND ROWNUM                = 1;

            /* Commented by vikas, as k'chatgamol say port sequence# may change
                so should not join port sequience, 16.11.2011
                AND FK_PORT_SEQUENCE_NO   = l_cur_voyage_rec.POL_PCSQ
            */
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_n_load_id:=NULL;

                g_v_record_filter := 'FK_SERVICE:'   || l_cur_voyage_rec.SERVICE   ||
                                    ' FK_VESSEL:'    || l_cur_voyage_rec.VESSEL    ||
                                    ' FK_VOYAGE:'    || l_cur_voyage_rec.VOYNO     ||
                                    ' FK_DIRECTION:' || l_cur_voyage_rec.DIRECTION ||
                                    ' DN_PORT:'      || l_cur_voyage_rec.LOAD_PORT ||
                                    ' RECORD_STATUS= A';
                g_v_record_table  := 'Load list not exist in TOS_LL_LOAD_LIST' ;

            WHEN OTHERS THEN
                l_n_load_id:=NULL;
                l_n_load_id:=NULL;

                g_v_record_filter := 'FK_SERVICE:'   || l_cur_voyage_rec.SERVICE   ||
                                    ' FK_VESSEL:'    || l_cur_voyage_rec.VESSEL    ||
                                    ' FK_VOYAGE:'    || l_cur_voyage_rec.VOYNO     ||
                                    ' FK_DIRECTION:' || l_cur_voyage_rec.DIRECTION ||
                                    ' DN_PORT:'      || l_cur_voyage_rec.LOAD_PORT ||
                                    ' RECORD_STATUS= A';
                g_v_record_table  := 'Error occured.Contact System administrator' ;

        END;
    ELSE
        l_n_load_id:=p_i_n_loadid;
    END IF;
    g_v_sql_id := 'SQL-03005';
    --Port class type
        BEGIN
            /*    Modified by vikas if normal booking then no need to
                validate port class and port code, as k'chatgamol, 30.11.2011    */
            IF l_v_is_dg = '1' THEN
                SELECT PORT_CLASS_TYPE
                INTO l_v_portclasstype
                FROM PORT_CLASS_TYPE
                WHERE PORT_CODE = l_cur_voyage_rec.LOAD_PORT;
            END IF;
            /*    End Modified vikas, 30.11.2011    */
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_v_portclass:=NULL;

                g_v_record_filter := 'PORT_CODE:'|| l_cur_voyage_rec.LOAD_PORT;
                g_v_record_table  := 'Port Class Type not found in PORT_CLASS_TYPE' ;

            WHEN OTHERS THEN
                l_v_portclass:=NULL;

                g_v_record_filter := 'PORT_CODE:'|| l_cur_voyage_rec.LOAD_PORT;
                g_v_record_table  := 'Error occured.Contact System administrator' ;

        END;
    g_v_sql_id := 'SQL-03006';
    --Port code
        BEGIN
            /*    Modified by vikas if normal booking then no need to
                validate port class and port code, as k'chatgamol, 30.11.2011    */
            IF l_v_is_dg = '1' THEN
                SELECT PORT_CLASS_CODE INTO l_v_portclass
                FROM PORT_CLASS
                WHERE UNNO=l_v_un_no
                AND VARIANT= NVL(l_v_variant, '-') -- Change by vikas, varint can not null, 18.11.2011
                AND IMDG_CLASS= l_v_imo_class
                AND PORT_CLASS_TYPE=l_v_portclasstype;
            END IF;
            /*    End modified vikas, 30.11.2011    */

        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_v_portclass:=NULL;

                g_v_record_filter := 'UNNO:'            || l_v_un_no     ||
                                        ' VARIANT:'         || l_v_variant   ||
                                        ' IMDG_CLASS:'      || l_v_imo_class ||
                                        ' PORT_CLASS_TYPE:' || l_v_portclasstype;
                g_v_record_table  := 'Port Class Code not found in PORT_CLASS' ;

                WHEN OTHERS THEN
                    l_v_portclass:=NULL;

                    g_v_record_filter := 'UNNO:'            || l_v_un_no     ||
                                        ' VARIANT:'         || l_v_variant   ||
                                        ' IMDG_CLASS:'      || l_v_imo_class ||
                                        ' PORT_CLASS_TYPE:' || l_v_portclasstype;
                    g_v_record_table  := 'Error occured.Contact System administrator' ;

        END;
    g_v_sql_id := 'SQL-03007';
    --Service group code
    BEGIN
        l_v_sql_id:='SQL2';
        SELECT SERVICE_GROUP_CODE
        INTO l_v_grp_cd
        FROM ITP085
        WHERE SWSRVC = l_cur_voyage_rec.SERVICE;
    EXCEPTION
        --added by aks for non mandatory
        WHEN NO_DATA_FOUND THEN
            l_v_grp_cd := NULL;

            /* Start Commented by vikas as no need to log the message for
            service group code , 21.11.2011
        g_v_record_filter := 'SWSRVC:'|| l_cur_voyage_rec.SERVICE;
            g_v_record_table  := 'Service group code not found in ITP085' ;

            End commented by vikas, 21.11.2011*/
        WHEN OTHERS THEN

            /* * *15 start * *

            g_v_record_filter := 'SWSRVC:'|| l_cur_voyage_rec.SERVICE;
            g_v_record_table  := 'Service group code not found in ITP085' ;

            RAISE l_exc_user ;
            */

            l_v_grp_cd := NULL;
            /* * *15 end * */
    END;

    g_v_sql_id := 'SQL-03008';
    --If load list not exists then make and insert in load list table

    IF l_n_load_id IS NULL THEN
        l_v_check_listid:='N';
        SELECT SE_LLZ01.NEXTVAL INTO l_n_load_id from dual;
        g_v_sql_id := 'SQL-03009';
        INSERT INTO TOS_LL_LOAD_LIST
        (
            PK_LOAD_LIST_ID,DN_SERVICE_GROUP_CODE,FK_SERVICE,FK_VESSEL,
            FK_VOYAGE,FK_DIRECTION,FK_PORT_SEQUENCE_NO,FK_VERSION,
            DN_PORT,DN_TERMINAL,LOAD_LIST_STATUS,DA_BOOKED_TOT,
            DA_LOADED_TOT,DA_ROB_TOT,DA_OVERSHIPPED_TOT,DA_SHORTSHIPPED_TOT,
            RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,
            RECORD_CHANGE_DATE
        )
        VALUES
        (
            l_n_load_id,l_v_grp_cd,l_cur_voyage_rec.SERVICE,
            l_cur_voyage_rec.VESSEL,l_cur_voyage_rec.VOYNO,
            l_cur_voyage_rec.DIRECTION, l_cur_voyage_rec.POL_PCSQ,l_v_version,
            l_cur_voyage_rec.LOAD_PORT,l_cur_voyage_rec.FROM_TERMINAL,'0',0,
            0,0,0,0,'A',g_v_user,l_d_time,g_v_user,l_d_time
        );

    END IF;

    /* *20 start * */
    BEGIN
        SELECT
            TO_DATE(ITP.VVARDT || LPAD(ITP.VVARTM, 4, '0'), 'YYYYMMDDHH24MI') ETA_DATE
        INTO
            L_V_ETA_DATE
        FROM
            TOS_LL_LOAD_LIST TLL,
            ITP063 ITP
        WHERE
            TLL.FK_SERVICE = ITP.VVSRVC
            AND TLL.FK_VESSEL = ITP.VVVESS
            AND TLL.FK_VOYAGE = ITP.VVVOYN
            AND TLL.FK_DIRECTION = ITP.VVPDIR
            AND TLL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ
            AND TLL.DN_PORT = ITP.VVPCAL
            AND TLL.DN_TERMINAL = ITP.VVTRM1
            AND ITP.OMMISSION_FLAG IS NULL
            AND ITP.VVVERS = 99
            AND TLL.PK_LOAD_LIST_ID = L_N_LOAD_ID;
    EXCEPTION
        WHEN OTHERS THEN
            L_V_ETA_DATE := NULL;
    END;

    /* *20 end * */

    g_v_sql_id := 'SQL-03010';
    --Deatail cursor from BKP009,BKP032,BKP001
    FOR l_cur_detail_rec IN l_cur_detail LOOP
        --Check booking is of 'ROB' type or not
                BEGIN
                g_v_sql_id := 'SQL-03011';
                SELECT 'RB', STOWAGE_POSITION
                INTO  l_v_rob, l_v_stow_pos_rob
                FROM  BKG_ROB_CONTAINER
                WHERE FK_DEPARTURE_BOOKING_NUMBER = l_cur_voyage_rec.BOOKING_NO
                AND   CONTAINER_NUMBER            = l_cur_detail_rec.DN_EQUIPMENT_NO;
                EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                        l_v_rob:=NULL;
                        l_v_stow_pos_rob := NULL;

                            /* Start Commented by vikas as no need to log the message for
                                service group code , 21.11.2011
                            g_v_record_filter := 'SWSRVC:'|| l_cur_voyage_rec.SERVICE;
                            g_v_record_table  := 'Service group code not found in ITP085' ;

                            End commented by vikas, 21.11.2011*/
                        WHEN OTHERS THEN
                        l_v_rob:=NULL;
                        l_v_stow_pos_rob := NULL;

                        g_v_record_filter := 'SWSRVC:'|| l_cur_voyage_rec.SERVICE;
                        g_v_record_table  := 'Error occured.Contact System administrator' ;

                END;
                        l_v_rob:=NVL(l_v_rob,'BK');
                IF l_cur_voyage_rec.VOYAGE_SEQNO=1 THEN
                    l_v_local_status:=l_cur_detail_rec.LOCAL_STATUS;
                ELSE
                    /*
                        *5: Changes start
                    */
                    BEGIN
                        /* Check in previous leg is it truck or leg */
                        SELECT 1
                        INTO   L_V_REC_COUNT
                        FROM   BOOKING_VOYAGE_ROUTING_DTL
                        WHERE  BOOKING_NO = p_i_v_booking_no
                        AND    transport_mode in ('R', 'T')
                        AND    VOYAGE_SEQNO = (l_cur_voyage_rec.VOYAGE_SEQNO - 1);

                        /* Previous leg is Truck or Rail, local status should be local */
                        l_v_local_status:='L';
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            /* Previous leg is not Truck or Rail, local status should be transhipment */
                            l_v_local_status:='T';
                        WHEN OTHERS THEN
                            l_v_local_status:='L';
                    END;
                    /*
                        * old logic *
                        l_v_local_status:    ='T';
                    *
                        *5: Changes end
                    */

                END IF;
                g_v_sql_id := 'SQL-03012';
                --Get Slot Operator
                IF l_v_local_status = 'T' THEN
                    l_v_out_slot_op_code := 'RCL';
                ELSIF l_cur_detail_rec.DN_SOC_COC = 'S' THEN
                        IF l_cur_detail_rec.DN_BKG_TYP IN ('N','ER') THEN
                            l_v_out_slot_op_code := l_v_op_code;
                        ELSE
                            l_v_out_slot_op_code := l_cur_detail_rec.SLOT_PARTNER_CODE;
                        END IF;
                END IF;
                /* Start Commented by vikas, k'chatgamol, 01.12.2011 *
                g_v_sql_id := 'SQL-03013';
                SELECT NVL(MAX(CONTAINER_SEQ_NO),0)
                INTO l_v_cont_seq
                FROM TOS_LL_BOOKED_LOADING
                WHERE FK_LOAD_LIST_ID=l_n_load_id;

                l_v_cont_seq :=l_v_cont_seq +1;
                * end Commented by vikas, k'chatgamol, 01.12.2011 */

                l_n_insert:=0;
                g_v_sql_id := 'SQL-03014';

            IF l_cur_detail_rec.DN_EQUIPMENT_NO IS NOT NULL THEN

                    BEGIN

                        /*  Start modified by vikas, to Check if equipment exixts
                            with record status 'A' with same load list
                            then update that equipment and not to insert
                            new equipment, as k'chatgamol, 24.11.2011*/
                        /*
                        SELECT 1, PK_BOOKED_LOADING_ID
                        INTO   l_n_check, l_n_list_upd_id
                        FROM   TOS_LL_BOOKED_LOADING
                        WHERE  DN_EQUIPMENT_NO  = l_cur_detail_rec.DN_EQUIPMENT_NO
                        AND    RECORD_STATUS    = 'S'
                        AND    ROWNUM = 1;
                        */

                        /* Commented by vikas to tune the performance, 26.11.2011
                        SELECT 1, PK_BOOKED_LOADING_ID
                        INTO   l_n_check, l_n_list_upd_id
                        FROM (
                            SELECT PK_BOOKED_LOADING_ID
                            FROM   TOS_LL_BOOKED_LOADING
                            WHERE  DN_EQUIPMENT_NO  = l_cur_detail_rec.DN_EQUIPMENT_NO
                            AND    RECORD_STATUS    = 'S'

                            UNION ALL

                            SELECT PK_BOOKED_LOADING_ID
                            FROM   TOS_LL_BOOKED_LOADING
                            WHERE  DN_EQUIPMENT_NO  = l_cur_detail_rec.DN_EQUIPMENT_NO
                            AND    FK_LOAD_LIST_ID  = l_n_load_id
                        )
                        WHERE ROWNUM = 1;
                        /*     End comment 26.11.2011*/
                        /*  End added by vikas, 24.11.2011  */

                        /*    Start Added by vikas 26.11.2011    */
                     --   SELECT 1, PK_BOOKED_LOADING_ID, RECORD_STATUS     -- modified by vikas, 01.12.2011  *29
                         SELECT 1, PK_BOOKED_LOADING_ID, RECORD_STATUS,FK_Booking_no     -- *29
                     --    INTO   l_n_check, l_n_list_upd_id, l_v_record_status  --*29
                        INTO   l_n_check, l_n_list_upd_id, l_v_record_status,l_v_bookingno -- *29
                        FROM   TOS_LL_BOOKED_LOADING
                        WHERE  DN_EQUIPMENT_NO  = l_cur_detail_rec.DN_EQUIPMENT_NO
                        AND    (RECORD_STATUS    = 'S'
                                    OR FK_LOAD_LIST_ID  = l_n_load_id)
                        AND    ROWNUM = 1;
                        /*    End Added by vikas 26.11.2011    */

                        /*Start Added by vikas get cont. seq no when record is suspended, 01.12.2011*/
                        IF l_v_record_status = 'S' THEN
                            g_v_sql_id := 'SQL-03013';
                            SELECT NVL(MAX(CONTAINER_SEQ_NO),0)
                            INTO l_v_cont_seq
                            FROM TOS_LL_BOOKED_LOADING
                            WHERE FK_LOAD_LIST_ID=l_n_load_id;

                            l_v_cont_seq :=l_v_cont_seq +1;
                        END IF;
                        /*    End added by vikas, 01.12.2011*/
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN

                                g_v_record_filter := 'RECORD_STATUS:'|| l_cur_detail_rec.DN_EQUIPMENT_NO;
                                g_v_record_table  := 'Booking Load ID not found in TOS_LL_BOOKED_LOADING' ;

                                l_n_check:=0;
                            WHEN OTHERS THEN
                                l_n_check:=0;

                                g_v_record_filter := 'RECORD_STATUS:'|| l_cur_detail_rec.DN_EQUIPMENT_NO;
                                g_v_record_table  := 'Error occured.Contact System administrator' ;

                        END;
                        g_v_sql_id := 'SQL-03015';
                        IF l_n_check = 1 THEN
                            /*
                                *13: start
                            */
                            PRE_GET_LL_DL_STATUS (
                                l_n_load_id,
                                l_cur_detail_rec.DN_EQUIPMENT_NO,
                                'LL',
                                l_v_rob
                            );
                            /*
                                *13: end
                            */
                         /*
                              *29 : Start
                         */
                         if l_v_record_status    = 'S' Then -- *29
                          If p_i_v_booking_no = l_v_bookingno Then  --*29
                            UPDATE TOS_LL_BOOKED_LOADING
                                SET  RECORD_STATUS              = 'A'
                                , FK_LOAD_LIST_ID            = l_n_load_id
                                , CONTAINER_SEQ_NO           = CASE WHEN(l_v_record_status = 'S')
                                    THEN l_v_cont_seq ELSE CONTAINER_SEQ_NO END
                                , FK_BOOKING_NO              = l_cur_detail_rec.FK_BOOKING_NO
                                , FK_BKG_SIZE_TYPE_DTL       = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                                , FK_BKG_SUPPLIER            = l_cur_detail_rec.FK_BKG_SUPPLIER
                                , FK_BKG_EQUIPM_DTL          = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                , EQUPMENT_NO_SOURCE         = l_cur_detail_rec.EQUPMENT_NO_SOURCE
                                , FK_BKG_VOYAGE_ROUTING_DTL  = l_cur_voyage_rec.VOYAGE_SEQNO
                                , DN_EQ_SIZE                 = l_cur_detail_rec.DN_EQ_SIZE
                                , DN_EQ_TYPE                 = l_cur_detail_rec.DN_EQ_TYPE
                                , DN_FULL_MT                 = l_cur_detail_rec.DN_FULL_MT
                                , DN_BKG_TYP                 = l_cur_detail_rec.DN_BKG_TYP
                                , DN_SOC_COC                 = l_cur_detail_rec.DN_SOC_COC
                                , DN_SHIPMENT_TERM           = l_cur_detail_rec.DN_SHIPMENT_TERM
                                , DN_SHIPMENT_TYP            = l_cur_detail_rec.DN_SHIPMENT_TYP
                                , LOCAL_STATUS               = l_v_local_status
                                , LOCAL_TERMINAL_STATUS       = (CASE  WHEN l_v_local_status = 'L'THEN 'Local' WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END) -- *9
                                --, LOADING_STATUS             = l_v_rob
                                , LOADING_STATUS             = DECODE(LOADING_STATUS, 'LO', LOADING_STATUS, l_v_rob) -- *13
                                , LOAD_CONDITION             = l_cur_detail_rec.LOAD_CONDITION -- *11
                                --, CONTAINER_GROSS_WEIGHT     = l_cur_detail_rec.CONTAINER_GROSS_WEIGHT
                                , VOID_SLOT                  = l_cur_detail_rec.VOID_SLOT
                                , FK_SLOT_OPERATOR           = l_cur_detail_rec.FK_SLOT_OPERATOR
                                --, FK_CONTAINER_OPERATOR      = l_cur_detail_rec.FK_CONTAINER_OPERATOR
                                --, OUT_SLOT_OPERATOR          = l_v_out_slot_op_code
                                , DN_SPECIAL_HNDL            = l_cur_detail_rec.DN_SPECIAL_HNDL
                                , DN_DISCHARGE_PORT          = l_cur_voyage_rec.DISCHARGE_PORT
                                , DN_DISCHARGE_TERMINAL      = l_cur_voyage_rec.TO_TERMINAL
                                , DN_NXT_POD1                = l_v_next_pod1
                                , DN_NXT_POD2                = l_v_next_pod2
                                , DN_NXT_POD3                = l_v_next_pod3
                                , DN_FINAL_POD               = l_cur_detail_rec.DN_FINAL_POD
                                , FINAL_DEST                 = l_cur_detail_rec.FINAL_DEST
                                , DN_NXT_SRV                 = l_v_next_service
                                , DN_NXT_VESSEL              = l_v_next_vessel
                                , DN_NXT_VOYAGE              = l_v_next_voyno
                                , DN_NXT_DIR                 = l_v_next_dir
                                , EX_MLO_VESSEL              = l_cur_detail_rec.EX_MLO_VESSEL
                                , EX_MLO_VESSEL_ETA          = l_cur_detail_rec.EX_MLO_VESSEL_ETA
                                , EX_MLO_VOYAGE              = l_cur_detail_rec.EX_MLO_VOYAGE
                                --, FK_HANDLING_INSTRUCTION_1  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_1
                                --, FK_HANDLING_INSTRUCTION_2  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_2
                                --, FK_HANDLING_INSTRUCTION_3  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_3
                                --, CONTAINER_LOADING_REM_1    = l_cur_detail_rec.CONTAINER_LOADING_REM_1
                                --, CONTAINER_LOADING_REM_2    = l_cur_detail_rec.CONTAINER_LOADING_REM_2
                                --, FK_SPECIAL_CARGO           = l_cur_detail_rec.FK_SPECIAL_CARGO
                                --, FK_IMDG                    = l_v_imo_class
                                --, FK_UNNO                    = l_v_un_no
                                --, FK_UN_VAR                  = l_v_variant
                                --, FK_PORT_CLASS              = l_v_portclass
                                --, FK_PORT_CLASS_TYP          = l_v_portclasstype
                               , FK_IMDG                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_IMDG)
                                , FK_UNNO                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_UNNO)
                                , FK_UN_VAR                      = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_UN_VAR)
                                , FK_PORT_CLASS                  = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_PORT_CLASS)
                                , FK_PORT_CLASS_TYP              = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_PORT_CLASS_TYP)
                                --, FLASH_UNIT                 = l_v_hz_bs
                                --, FLASH_POINT                = l_cur_detail_rec.FLASH_POINT
                                --, FUMIGATION_ONLY            = l_cur_detail_rec.FUMIGATION_ONLY
                                --, RESIDUE_ONLY_FLAG          = l_cur_detail_rec.RESIDUE_ONLY_FLAG
                                --, OVERWIDTH_LEFT_CM          = l_cur_detail_rec.OVERHEIGHT_CM
                                --, OVERWIDTH_RIGHT_CM         = l_cur_detail_rec.OVERWIDTH_RIGHT_CM
                                --, OVERLENGTH_FRONT_CM        = l_cur_detail_rec.OVERLENGTH_FRONT_CM
                                --, OVERLENGTH_REAR_CM         = l_cur_detail_rec.OVERLENGTH_REAR_CM
                                --, REEFER_TMP                 = l_cur_detail_rec.REEFER_TMP
                                --, REEFER_TMP_UNIT            = l_cur_detail_rec.REEFER_TMP_UNIT
                                --, DN_HUMIDITY                = l_cur_detail_rec.HUMIDITY
                                --, DN_VENTILATION             = l_cur_detail_rec.DN_VENTILATION
                                 , RECORD_CHANGE_USER         = g_v_user
                                , RECORD_CHANGE_DATE         = l_d_time
                                , ACTIVITY_DATE_TIME         = L_V_ETA_DATE /* *20 * */
                                ,CONTAINER_GROSS_WEIGHT      =  l_cur_detail_rec.CONTAINER_GROSS_WEIGHT --*30
                                ,CATEGORY_CODE               = l_cur_detail_rec.VGM_CATEGORY--*30
                                ,VGM      =  l_cur_detail_rec.VGM --*31
                            WHERE   DN_EQUIPMENT_NO            = l_cur_detail_rec.DN_EQUIPMENT_NO
                            -- AND     RECORD_STATUS              = 'S'
                            AND    (RECORD_STATUS    = 'S' )
                            AND     PK_BOOKED_LOADING_ID       = l_n_list_upd_id;
                            l_n_insert:=1;
                          Else
                            UPDATE TOS_LL_BOOKED_LOADING
                                SET  RECORD_STATUS              = 'A'
                                , FK_LOAD_LIST_ID            = l_n_load_id
                                , CONTAINER_SEQ_NO           = CASE WHEN(l_v_record_status = 'S')
                                    THEN l_v_cont_seq ELSE CONTAINER_SEQ_NO END
                                , FK_BOOKING_NO              = l_cur_detail_rec.FK_BOOKING_NO
                                , FK_BKG_SIZE_TYPE_DTL       = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                                , FK_BKG_SUPPLIER            = l_cur_detail_rec.FK_BKG_SUPPLIER
                                , FK_BKG_EQUIPM_DTL          = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                , EQUPMENT_NO_SOURCE         = l_cur_detail_rec.EQUPMENT_NO_SOURCE
                                , FK_BKG_VOYAGE_ROUTING_DTL  = l_cur_voyage_rec.VOYAGE_SEQNO
                                , DN_EQ_SIZE                 = l_cur_detail_rec.DN_EQ_SIZE
                                , DN_EQ_TYPE                 = l_cur_detail_rec.DN_EQ_TYPE
                                , DN_FULL_MT                 = l_cur_detail_rec.DN_FULL_MT
                                , DN_BKG_TYP                 = l_cur_detail_rec.DN_BKG_TYP
                                , DN_SOC_COC                 = l_cur_detail_rec.DN_SOC_COC
                                , DN_SHIPMENT_TERM           = l_cur_detail_rec.DN_SHIPMENT_TERM
                                , DN_SHIPMENT_TYP            = l_cur_detail_rec.DN_SHIPMENT_TYP
                                , LOCAL_STATUS               = l_v_local_status
                                , LOCAL_TERMINAL_STATUS       = (CASE  WHEN l_v_local_status = 'L'THEN 'Local' WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END) -- *9
                                --, LOADING_STATUS             = l_v_rob
                                , LOADING_STATUS             = DECODE(LOADING_STATUS, 'LO', LOADING_STATUS, l_v_rob) -- *13
                                , LOAD_CONDITION             = l_cur_detail_rec.LOAD_CONDITION -- *11
                                --, CONTAINER_GROSS_WEIGHT     = l_cur_detail_rec.CONTAINER_GROSS_WEIGHT
                                , VOID_SLOT                  = l_cur_detail_rec.VOID_SLOT
                                , FK_SLOT_OPERATOR           = l_cur_detail_rec.FK_SLOT_OPERATOR
                                --, FK_CONTAINER_OPERATOR      = l_cur_detail_rec.FK_CONTAINER_OPERATOR
                                --, OUT_SLOT_OPERATOR          = l_v_out_slot_op_code
                                , DN_SPECIAL_HNDL            = l_cur_detail_rec.DN_SPECIAL_HNDL
                                , DN_DISCHARGE_PORT          = l_cur_voyage_rec.DISCHARGE_PORT
                                , DN_DISCHARGE_TERMINAL      = l_cur_voyage_rec.TO_TERMINAL
                                , DN_NXT_POD1                = l_v_next_pod1
                                , DN_NXT_POD2                = l_v_next_pod2
                                , DN_NXT_POD3                = l_v_next_pod3
                                , DN_FINAL_POD               = l_cur_detail_rec.DN_FINAL_POD
                                , FINAL_DEST                 = l_cur_detail_rec.FINAL_DEST
                                , DN_NXT_SRV                 = l_v_next_service
                                , DN_NXT_VESSEL              = l_v_next_vessel
                                , DN_NXT_VOYAGE              = l_v_next_voyno
                                , DN_NXT_DIR                 = l_v_next_dir
                                , EX_MLO_VESSEL              = l_cur_detail_rec.EX_MLO_VESSEL
                                , EX_MLO_VESSEL_ETA          = l_cur_detail_rec.EX_MLO_VESSEL_ETA
                                , EX_MLO_VOYAGE              = l_cur_detail_rec.EX_MLO_VOYAGE
                                --, FK_HANDLING_INSTRUCTION_1  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_1
                                --, FK_HANDLING_INSTRUCTION_2  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_2
                                --, FK_HANDLING_INSTRUCTION_3  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_3
                                --, CONTAINER_LOADING_REM_1    = l_cur_detail_rec.CONTAINER_LOADING_REM_1
                                --, CONTAINER_LOADING_REM_2    = l_cur_detail_rec.CONTAINER_LOADING_REM_2
                                --, FK_SPECIAL_CARGO           = l_cur_detail_rec.FK_SPECIAL_CARGO
                                --, FK_IMDG                    = l_v_imo_class
                                --, FK_UNNO                    = l_v_un_no
                                --, FK_UN_VAR                  = l_v_variant
                                --, FK_PORT_CLASS              = l_v_portclass
                                --, FK_PORT_CLASS_TYP          = l_v_portclasstype
                                , FK_IMDG                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_imo_class)
                                , FK_UNNO                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_un_no)
                                , FK_UN_VAR                      = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_variant)
                                , FK_PORT_CLASS                  = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_portclass)
                                , FK_PORT_CLASS_TYP              = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_portclasstype)
                                , FLASH_UNIT                 = l_v_hz_bs
                                , FLASH_POINT                = l_cur_detail_rec.FLASH_POINT
                                , FUMIGATION_ONLY            = l_cur_detail_rec.FUMIGATION_ONLY
                                , RESIDUE_ONLY_FLAG          = l_cur_detail_rec.RESIDUE_ONLY_FLAG
                                , OVERWIDTH_LEFT_CM          = l_cur_detail_rec.OVERHEIGHT_CM
                                , OVERWIDTH_RIGHT_CM         = l_cur_detail_rec.OVERWIDTH_RIGHT_CM
                                , OVERLENGTH_FRONT_CM        = l_cur_detail_rec.OVERLENGTH_FRONT_CM
                                , OVERLENGTH_REAR_CM         = l_cur_detail_rec.OVERLENGTH_REAR_CM
                                , REEFER_TMP                 = l_cur_detail_rec.REEFER_TMP
                                , REEFER_TMP_UNIT            = l_cur_detail_rec.REEFER_TMP_UNIT
                                , DN_HUMIDITY                = l_cur_detail_rec.HUMIDITY
                                , DN_VENTILATION             = l_cur_detail_rec.DN_VENTILATION
                                , RECORD_CHANGE_USER         = g_v_user
                                , RECORD_CHANGE_DATE         = l_d_time
                                , ACTIVITY_DATE_TIME         = L_V_ETA_DATE /* *20 * */
                                ,CONTAINER_GROSS_WEIGHT      =  DECODE(LOADING_STATUS,'LO',CONTAINER_GROSS_WEIGHT,l_cur_detail_rec.CONTAINER_GROSS_WEIGHT) --*30
                                ,CATEGORY_CODE               = DECODE(LOADING_STATUS,'LO',CATEGORY_CODE,l_cur_detail_rec.VGM_CATEGORY)--*30
                                ,VGM      =  DECODE(LOADING_STATUS,'LO',VGM,l_cur_detail_rec.VGM) --*31
                            WHERE   DN_EQUIPMENT_NO            = l_cur_detail_rec.DN_EQUIPMENT_NO
                            -- AND     RECORD_STATUS              = 'S'
                            AND    (RECORD_STATUS    = 'S' )
                            AND     PK_BOOKED_LOADING_ID       = l_n_list_upd_id;
                            l_n_insert:=1;

                          End if;

                        Else
                        /* 29
                            *29 := End

                        */

                            UPDATE TOS_LL_BOOKED_LOADING
                                SET  RECORD_STATUS              = 'A'
                                , FK_LOAD_LIST_ID            = l_n_load_id
                                , CONTAINER_SEQ_NO           = CASE WHEN(l_v_record_status = 'S')
                                    THEN l_v_cont_seq ELSE CONTAINER_SEQ_NO END
                                , FK_BOOKING_NO              = l_cur_detail_rec.FK_BOOKING_NO
                                , FK_BKG_SIZE_TYPE_DTL       = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                                , FK_BKG_SUPPLIER            = l_cur_detail_rec.FK_BKG_SUPPLIER
                                , FK_BKG_EQUIPM_DTL          = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                , EQUPMENT_NO_SOURCE         = l_cur_detail_rec.EQUPMENT_NO_SOURCE
                                , FK_BKG_VOYAGE_ROUTING_DTL  = l_cur_voyage_rec.VOYAGE_SEQNO
                                , DN_EQ_SIZE                 = l_cur_detail_rec.DN_EQ_SIZE
                                , DN_EQ_TYPE                 = l_cur_detail_rec.DN_EQ_TYPE
                                , DN_FULL_MT                 = l_cur_detail_rec.DN_FULL_MT
                                , DN_BKG_TYP                 = l_cur_detail_rec.DN_BKG_TYP
                                , DN_SOC_COC                 = l_cur_detail_rec.DN_SOC_COC
                                , DN_SHIPMENT_TERM           = l_cur_detail_rec.DN_SHIPMENT_TERM
                                , DN_SHIPMENT_TYP            = l_cur_detail_rec.DN_SHIPMENT_TYP
                                , LOCAL_STATUS               = l_v_local_status
                                , LOCAL_TERMINAL_STATUS       = (CASE  WHEN l_v_local_status = 'L'THEN 'Local' WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END) -- *9
                                --, LOADING_STATUS             = l_v_rob
                                , LOADING_STATUS             = DECODE(LOADING_STATUS, 'LO', LOADING_STATUS, l_v_rob) -- *13
                                , LOAD_CONDITION             = l_cur_detail_rec.LOAD_CONDITION -- *11
                                --, CONTAINER_GROSS_WEIGHT     = l_cur_detail_rec.CONTAINER_GROSS_WEIGHT
                                , VOID_SLOT                  = l_cur_detail_rec.VOID_SLOT
                                , FK_SLOT_OPERATOR           = l_cur_detail_rec.FK_SLOT_OPERATOR
                                --, FK_CONTAINER_OPERATOR      = l_cur_detail_rec.FK_CONTAINER_OPERATOR
                                --, OUT_SLOT_OPERATOR          = l_v_out_slot_op_code
                                , DN_SPECIAL_HNDL            = l_cur_detail_rec.DN_SPECIAL_HNDL
                                , DN_DISCHARGE_PORT          = l_cur_voyage_rec.DISCHARGE_PORT
                                , DN_DISCHARGE_TERMINAL      = l_cur_voyage_rec.TO_TERMINAL
                                , DN_NXT_POD1                = l_v_next_pod1
                                , DN_NXT_POD2                = l_v_next_pod2
                                , DN_NXT_POD3                = l_v_next_pod3
                                , DN_FINAL_POD               = l_cur_detail_rec.DN_FINAL_POD
                                , FINAL_DEST                 = l_cur_detail_rec.FINAL_DEST
                                , DN_NXT_SRV                 = l_v_next_service
                                , DN_NXT_VESSEL              = l_v_next_vessel
                                , DN_NXT_VOYAGE              = l_v_next_voyno
                                , DN_NXT_DIR                 = l_v_next_dir
                                , EX_MLO_VESSEL              = l_cur_detail_rec.EX_MLO_VESSEL
                                , EX_MLO_VESSEL_ETA          = l_cur_detail_rec.EX_MLO_VESSEL_ETA
                                , EX_MLO_VOYAGE              = l_cur_detail_rec.EX_MLO_VOYAGE
                                --, FK_HANDLING_INSTRUCTION_1  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_1
                                --, FK_HANDLING_INSTRUCTION_2  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_2
                                --, FK_HANDLING_INSTRUCTION_3  = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_3
                                --, CONTAINER_LOADING_REM_1    = l_cur_detail_rec.CONTAINER_LOADING_REM_1
                                --, CONTAINER_LOADING_REM_2    = l_cur_detail_rec.CONTAINER_LOADING_REM_2
                                --, FK_SPECIAL_CARGO           = l_cur_detail_rec.FK_SPECIAL_CARGO
                                --, FK_IMDG                    = l_v_imo_class
                                --, FK_UNNO                    = l_v_un_no
                                --, FK_UN_VAR                  = l_v_variant
                                --, FK_PORT_CLASS              = l_v_portclass
                                --, FK_PORT_CLASS_TYP          = l_v_portclasstype
                                , FK_IMDG                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_IMDG) -- *4
                                , FK_UNNO                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_UNNO) -- *4
                                , FK_UN_VAR                      = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_UN_VAR) -- *4
                                , FK_PORT_CLASS                  = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_PORT_CLASS) -- *4
                                , FK_PORT_CLASS_TYP              = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_PORT_CLASS_TYP) -- *4
                                --, FLASH_UNIT                 = l_v_hz_bs
                                --, FLASH_POINT                = l_cur_detail_rec.FLASH_POINT
                                --, FUMIGATION_ONLY            = l_cur_detail_rec.FUMIGATION_ONLY
                                --, RESIDUE_ONLY_FLAG          = l_cur_detail_rec.RESIDUE_ONLY_FLAG
                                --, OVERWIDTH_LEFT_CM          = l_cur_detail_rec.OVERHEIGHT_CM
                                --, OVERWIDTH_RIGHT_CM         = l_cur_detail_rec.OVERWIDTH_RIGHT_CM
                                --, OVERLENGTH_FRONT_CM        = l_cur_detail_rec.OVERLENGTH_FRONT_CM
                                --, OVERLENGTH_REAR_CM         = l_cur_detail_rec.OVERLENGTH_REAR_CM
                                --, REEFER_TMP                 = l_cur_detail_rec.REEFER_TMP
                                --, REEFER_TMP_UNIT            = l_cur_detail_rec.REEFER_TMP_UNIT
                                --, DN_HUMIDITY                = l_cur_detail_rec.HUMIDITY
                                --, DN_VENTILATION             = l_cur_detail_rec.DN_VENTILATION
                                , RECORD_CHANGE_USER         = g_v_user
                                , RECORD_CHANGE_DATE         = l_d_time
                                , ACTIVITY_DATE_TIME         = L_V_ETA_DATE /* *20 * */
                                ,CONTAINER_GROSS_WEIGHT      =  DECODE(LOADING_STATUS,'LO',CONTAINER_GROSS_WEIGHT,l_cur_detail_rec.CONTAINER_GROSS_WEIGHT) --*30
                                ,CATEGORY_CODE               = DECODE(LOADING_STATUS,'LO',CATEGORY_CODE,l_cur_detail_rec.VGM_CATEGORY)--*30
                                ,VGM     =  DECODE(LOADING_STATUS,'LO',VGM,l_cur_detail_rec.VGM) --*31                                
                            WHERE   DN_EQUIPMENT_NO            = l_cur_detail_rec.DN_EQUIPMENT_NO
                            -- AND     RECORD_STATUS              = 'S'
                           --  AND    (RECORD_STATUS    = 'S' OR FK_LOAD_LIST_ID  = l_n_load_id)
                            AND    FK_LOAD_LIST_ID  = l_n_load_id
                            AND     PK_BOOKED_LOADING_ID       = l_n_list_upd_id;
                            l_n_insert:=1;


                        END IF;  -- *29
                        END IF;
                END IF;
            g_v_sql_id := 'SQL-03016';
        IF l_n_insert = 0 THEN
            g_v_sql_id := 'SQL-0301a';
            SELECT NVL(MAX(CONTAINER_SEQ_NO),0)
            INTO l_v_cont_seq
            FROM TOS_LL_BOOKED_LOADING
            WHERE FK_LOAD_LIST_ID=l_n_load_id;

            l_v_cont_seq :=l_v_cont_seq +1;

            g_v_sql_id := 'SQL-03017';
            /* Start changes by vikas as K'chatgamol say, because it is to confusing,
                to check the existing record using update query, 17.11.2011 */

        /*
        UPDATE TOS_LL_BOOKED_LOADING
        SET FK_BOOKING_NO     = l_cur_detail_rec.FK_BOOKING_NO
        WHERE FK_LOAD_LIST_ID                  = l_n_load_id
                AND FK_BOOKING_NO             = l_cur_detail_rec.FK_BOOKING_NO
                AND FK_BKG_SIZE_TYPE_DTL      = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                AND FK_BKG_SUPPLIER           = l_cur_detail_rec.FK_BKG_SUPPLIER
                AND FK_BKG_EQUIPM_DTL         = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                AND FK_BKG_VOYAGE_ROUTING_DTL = l_cur_voyage_rec.VOYAGE_SEQNO
                AND RECORD_STATUS = 'A';
            */
            IF(l_cur_detail_rec.DN_EQUIPMENT_NO IS NOT NULL ) THEN
                /* Check record on the basis of equipment#*/
                SELECT COUNT(1)
                INTO  l_v_rec_count
                FROM  TOS_LL_BOOKED_LOADING
                WHERE FK_LOAD_LIST_ID           = l_n_load_id
                AND   FK_BOOKING_NO             = l_cur_detail_rec.FK_BOOKING_NO
                AND   FK_BKG_SIZE_TYPE_DTL      = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                AND   FK_BKG_SUPPLIER           = l_cur_detail_rec.FK_BKG_SUPPLIER
                AND   DN_EQUIPMENT_NO           = l_cur_detail_rec.DN_EQUIPMENT_NO
                AND   FK_BKG_VOYAGE_ROUTING_DTL = l_cur_voyage_rec.VOYAGE_SEQNO
                AND   RECORD_STATUS             = 'A';
            ELSE

                /* Check record on the basis of equipment sequence no# */
                SELECT COUNT(1)
                INTO  l_v_rec_count
                FROM  TOS_LL_BOOKED_LOADING
                WHERE FK_LOAD_LIST_ID           = l_n_load_id
                AND   FK_BOOKING_NO             = l_cur_detail_rec.FK_BOOKING_NO
                AND   FK_BKG_SIZE_TYPE_DTL      = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                AND   FK_BKG_SUPPLIER           = l_cur_detail_rec.FK_BKG_SUPPLIER
                AND   FK_BKG_EQUIPM_DTL         = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                AND   FK_BKG_VOYAGE_ROUTING_DTL = l_cur_voyage_rec.VOYAGE_SEQNO
                AND   RECORD_STATUS             = 'A';

            END IF; -- end of blank equipment if block

            -- IF SQL%ROWCOUNT = 0 THEN
            IF l_v_rec_count = 0 THEN
                /* End changes by vikas 17.11.2011 */

                /* Start Added by vikas, check booking# again and if exist then delete from the
                ezll table, K'Chatgamol, 16.11.2011 *
                BEGIN
                    IF l_cur_detail_rec.DN_EQUIPMENT_NO IS NOT NULL THEN
                        /* Get port and terminal *
                        SELECT DN_PORT, DN_TERMINAL
                        INTO l_v_dn_port, l_v_dn_terminal
                        FROM TOS_LL_LOAD_LIST
                        WHERE PK_LOAD_LIST_ID = l_n_load_id;

                        /* Delete the duplicate container from booking detail table */
                        /*DELETE FROM TOS_LL_BOOKED_LOADING
                        WHERE PK_BOOKED_LOADING_ID IN (
                            SELECT BL.PK_BOOKED_LOADING_ID
                            FROM TOS_LL_BOOKED_LOADING BL ,
                                TOS_LL_LOAD_LIST DL
                            WHERE BL.FK_BOOKING_NO = l_cur_detail_rec.FK_BOOKING_NO
                            AND BL.DN_EQUIPMENT_NO = l_cur_detail_rec.DN_EQUIPMENT_NO
                            AND DL.RECORD_STATUS   = 'A'
                            AND BL.RECORD_STATUS   = 'A'
                            AND DL.DN_PORT         = l_v_dn_port
                            AND DL.DN_TERMINAL     = l_v_dn_terminal
                            AND BL.FK_LOAD_LIST_ID = DL.PK_LOAD_LIST_ID);*/ --Leena 19.01.2012 comment duplicate container removal

                        /*
                            Start Added by vikas to log the deleted records, 30.11.2011
                        *
                        IF SQL%ROWCOUNT >= 1 THEN
                            PRE_TOS_SYNC_ERROR_LOG(
                                'LOAD~' || l_cur_detail_rec.FK_BOOKING_NO||'~'||
                                    l_cur_detail_rec.DN_EQUIPMENT_NO ||'~'||
                                    l_v_dn_port ||'~'||
                                    l_v_dn_terminal
                                , 'SYNC'
                                , 'D'
                                , 'Delete duplicate booking from load list'
                                , 'A'
                                , g_v_user
                                , CURRENT_TIMESTAMP
                                , g_v_user
                                , CURRENT_TIMESTAMP
                            );
                        END IF;
                        *
                            End Added by vikas to log the deleted records, 30.11.2011
                        *

                    END IF;
                EXCEPTION
                WHEN OTHERS THEN
                    NULL;
                END;
                * End added by vikas, 16.11.2011*/

                /*
                    Block added by vikas, to improve logging, 01.02.2012
                */
                SELECT
                    SE_BLZ01.nextval
                INTO
                    l_v_pk_booked_loading_id
                FROM DUAL;
                /*
                    Block Ended by vikas, 01.02.2012
                */

                /*
                    *10: start
                */
                BEGIN -- Start of crane type begin block
                    l_v_crane_type := NULL;
                    -- VASAPPS.PKG_TOS_RCL.PRC_TOS_GET_DEFAULT_CRANE( -- *18
                    VASAPPS.PKG_TOS_RCL_EZLL.PRC_TOS_GET_DEFAULT_CRANE( -- *18
                        l_v_crane_type
                        , l_cur_voyage_rec.LOAD_PORT
                        , l_cur_voyage_rec.FROM_TERMINAL
                    );
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END; -- end of crane type begin block
                /*
                    *10: End
                */
                /*
                    *13: start
                */
                PRE_GET_LL_DL_STATUS (
                    l_n_load_id,
                    -- null, -- *25
                    l_cur_detail_rec.DN_EQUIPMENT_NO, -- *25
                    'LL',
                    l_v_rob
                );
                /*
                    *13: end
                */
                BEGIN
                    INSERT INTO TOS_LL_BOOKED_LOADING
                    (
                    PK_BOOKED_LOADING_ID,FK_LOAD_LIST_ID,CONTAINER_SEQ_NO,FK_BOOKING_NO,
                    FK_BKG_SIZE_TYPE_DTL,FK_BKG_SUPPLIER,FK_BKG_EQUIPM_DTL,DN_EQUIPMENT_NO,
                    EQUPMENT_NO_SOURCE ,FK_BKG_VOYAGE_ROUTING_DTL,DN_EQ_SIZE,DN_EQ_TYPE,
                    DN_FULL_MT,DN_BKG_TYP,DN_SOC_COC,DN_SHIPMENT_TERM,DN_SHIPMENT_TYP,LOCAL_STATUS,
                    LOADING_STATUS,LOAD_CONDITION,CONTAINER_GROSS_WEIGHT,VOID_SLOT,FK_SLOT_OPERATOR,
                    FK_CONTAINER_OPERATOR,OUT_SLOT_OPERATOR,DN_SPECIAL_HNDL,DN_DISCHARGE_PORT,
                    DN_DISCHARGE_TERMINAL,DN_NXT_POD1,DN_NXT_POD2,DN_NXT_POD3,DN_FINAL_POD,
                    FINAL_DEST,DN_NXT_SRV,DN_NXT_VESSEL,DN_NXT_VOYAGE,DN_NXT_DIR,EX_MLO_VESSEL,
                    EX_MLO_VESSEL_ETA,EX_MLO_VOYAGE,FK_HANDLING_INSTRUCTION_1,
                    FK_HANDLING_INSTRUCTION_2,FK_HANDLING_INSTRUCTION_3,CONTAINER_LOADING_REM_1,
                    CONTAINER_LOADING_REM_2,FK_SPECIAL_CARGO,FK_IMDG,FK_UNNO,FK_UN_VAR,FK_PORT_CLASS,
                    FK_PORT_CLASS_TYP,FLASH_UNIT,FLASH_POINT,FUMIGATION_ONLY,RESIDUE_ONLY_FLAG,OVERHEIGHT_CM,
                    OVERWIDTH_LEFT_CM,OVERWIDTH_RIGHT_CM,OVERLENGTH_FRONT_CM,OVERLENGTH_REAR_CM,
                    REEFER_TMP, REEFER_TMP_UNIT,DN_HUMIDITY,DN_VENTILATION,STOWAGE_POSITION,RECORD_STATUS,
                    RECORD_ADD_USER, RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE
                    , LOCAL_TERMINAL_STATUS --ADDED ON 29/04/2011.
                    , CRANE_TYPE -- *10
                    , ACTIVITY_DATE_TIME
                    , CATEGORY_CODE --*30
                    ,VGM--*31
                    )
                VALUES
                    (
                        l_v_pk_booked_loading_id,l_n_load_id ,l_v_cont_seq,l_cur_detail_rec.FK_BOOKING_NO,
                        l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL,l_cur_detail_rec.FK_BKG_SUPPLIER,
                        l_cur_detail_rec.FK_BKG_EQUIPM_DTL,l_cur_detail_rec.DN_EQUIPMENT_NO,
                        l_cur_detail_rec.EQUPMENT_NO_SOURCE,
                        l_cur_voyage_rec.VOYAGE_SEQNO ,l_cur_detail_rec.DN_EQ_SIZE,
                        l_cur_detail_rec.DN_EQ_TYPE,l_cur_detail_rec.DN_FULL_MT,
                        l_cur_detail_rec.DN_BKG_TYP,l_cur_detail_rec.DN_SOC_COC,
                        l_cur_detail_rec.DN_SHIPMENT_TERM,l_cur_detail_rec.DN_SHIPMENT_TYP,
                        l_v_local_status,
                        -- l_v_rob, --*13
                        NVL2(l_v_stow_pos_rob, l_v_rob, 'BK'), --*13
                        l_cur_detail_rec.LOAD_CONDITION,
                        l_cur_detail_rec.CONTAINER_GROSS_WEIGHT,l_cur_detail_rec.VOID_SLOT,
                        l_cur_detail_rec.FK_SLOT_OPERATOR,l_cur_detail_rec.FK_CONTAINER_OPERATOR,
                        l_v_out_slot_op_code,l_cur_detail_rec.DN_SPECIAL_HNDL,
                        l_cur_voyage_rec.DISCHARGE_PORT,l_cur_voyage_rec.TO_TERMINAL,l_v_next_pod1,
                        l_v_next_pod2,l_v_next_pod3,l_cur_detail_rec.DN_FINAL_POD,l_cur_detail_rec.FINAL_DEST,l_v_next_service ,l_v_next_vessel,
                        l_v_next_voyno,l_v_next_dir,l_cur_detail_rec.EX_MLO_VESSEL,
                        l_cur_detail_rec.EX_MLO_VESSEL_ETA,l_cur_detail_rec.EX_MLO_VOYAGE,
                        l_cur_detail_rec.FK_HANDLING_INSTRUCTION_1,
                        l_cur_detail_rec.FK_HANDLING_INSTRUCTION_2,
                        l_cur_detail_rec.FK_HANDLING_INSTRUCTION_3,
                        l_cur_detail_rec.CONTAINER_LOADING_REM_1,
                        l_cur_detail_rec.CONTAINER_LOADING_REM_2,l_cur_detail_rec.FK_SPECIAL_CARGO,
                    -- l_v_imo_class,l_v_un_no,l_v_variant,l_v_portclass,l_v_portclasstype,
                        l_cur_detail_rec.FK_IMDG,l_cur_detail_rec.FK_UNNO,l_cur_detail_rec.FK_UN_VAR,
                        l_cur_detail_rec.FK_PORT_CLASS,l_cur_detail_rec.FK_PORT_CLASS_TYP,
                        l_cur_detail_rec.FLASH_UNIT,l_cur_detail_rec.FLASH_POINT,
                        l_cur_detail_rec.FUMIGATION_ONLY,
                        l_cur_detail_rec.RESIDUE_ONLY_FLAG,
                        l_cur_detail_rec.OVERHEIGHT_CM,
                        l_cur_detail_rec.OVERWIDTH_LEFT_CM,l_cur_detail_rec.OVERWIDTH_RIGHT_CM,
                        l_cur_detail_rec.OVERLENGTH_FRONT_CM,
                        l_cur_detail_rec.OVERLENGTH_REAR_CM,l_cur_detail_rec.REEFER_TMP,
                        l_cur_detail_rec.REEFER_TMP_UNIT,
                        l_cur_detail_rec.HUMIDITY,l_cur_detail_rec.DN_VENTILATION,l_v_stow_pos_rob,
                        'A',g_v_user,l_d_time,g_v_user,l_d_time,
                        ( CASE  WHEN l_v_local_status = 'L' THEN 'Local'  WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END) --ADDED ON 29/04/2011.
                        , L_V_CRANE_TYPE -- *10
                        , L_V_ETA_DATE
                        ,l_cur_detail_rec.VGM_CATEGORY --*30
                        ,l_cur_detail_rec.VGM --*31
                    )  ;
                /*
                    Begin block added by vikas to improve logging, 01.02.2012
                */
                EXCEPTION
                    WHEN OTHERS THEN
                        g_v_err_desc := SQLERRM;
                        PRE_TOS_SYNC_ERROR_LOG(
                            'EXCETION IN LL BOOKED DETAILS INSERT'||'~'||l_n_load_id
                                ||'~'||g_v_err_desc
                                ||'~'||l_cur_detail_rec.DN_EQUIPMENT_NO
                                ||'~'||l_v_pk_booked_loading_id,
                            'SYNC',
                            'D',
                            'SYNC',
                            'A',
                            g_v_user,
                            SYSDATE,
                            g_v_user,
                            SYSDATE
                    );
                        g_v_err_desc := null;
                END;
                /*
                    Begin block end added by vikas to improve logging, 01.02.2012
                */

            END IF;--ROWCOUNT END IF
    END IF;
    END LOOP;--end of container loop
            g_v_sql_id := 'SQL-03018';

            --Update Load List Status count
            PRE_TOS_STATUS_COUNT(l_n_load_id,'L',p_o_v_return_status);
            IF p_o_v_return_status = '1' THEN
                /*
                    Block added by vikas, to log error,  06.02.2012
                */
                    g_v_err_code := TO_CHAR (SQLCODE);
                    g_v_err_desc := SUBSTR(SQLERRM,1,100);
                    g_v_record_filter := 'load list id  :'|| l_n_load_id  ;
                    g_v_record_table  := 'Error in updating status count in header table' ;
                /*
                    Block Ended by vikas, to log error,  06.02.2012
                */
                RAISE l_exc_user;
            END IF;

            g_v_sql_id := 'SQL-03019';
            l_n_load_id:=null;
            l_v_check_listid :='Y';
            l_n_check :=0;
            l_n_insert :=0;

    END LOOP;  --end of routing loop
        g_v_sql_id := 'SQL-03020';
        l_v_next_pod1       := null;
        l_v_next_pod2       := null;
        l_v_next_pod3       := null;
        p_o_v_return_status := '0';
        l_n_load_id         := null;
        l_v_check_listid    := 'Y';
        l_n_check           := 0;
        l_n_insert          := 0;
        EXCEPTION
        WHEN l_exc_user THEN
        p_o_v_return_status := '1';
        ROLLBACK;
            /*
                Block Added by vikas to log error, 06.02.2012
            */
            PRE_TOS_SYNC_ERROR_LOG('Create load list exception',
                'EZLL',
                'A',
                g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc,
                'A',
                g_v_user,
                SYSDATE,
                g_v_user,
                SYSDATE,
                g_v_record_filter,
                g_v_record_table
            );
            /*
                * old logic *
          g_v_err_code := TO_CHAR (SQLCODE);
          g_v_err_desc := SUBSTR(SQLERRM,1,100);

                Block end by vikas, 06.02.2012
            */
        WHEN OTHERS THEN
        p_o_v_return_status := '1';
        ROLLBACK;
        g_v_err_code := TO_CHAR (SQLCODE);
        g_v_err_desc := SUBSTR(SQLERRM,1,100);
            /*
                Block Added by vikas to log error, 06.02.2012
            */
            PRE_TOS_SYNC_ERROR_LOG('Create load list oracle exception',
                'EZLL',
                'A',
                g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc,
                'A',
                g_v_user,
                SYSDATE,
                g_v_user,
                SYSDATE
            );
            /*
                Block end by vikas, 06.02.2012
            */

    END PRE_TOS_CREATE_LOAD_LIST;

    PROCEDURE PRE_TOS_CREATE_DISCHARGE_LIST  (
        p_i_v_booking_no              IN              VARCHAR2,
        p_i_n_voyseq                  IN              NUMBER,
        p_i_n_dischargeid             IN              NUMBER,
        p_i_n_equipment_seq_no        IN              NUMBER,
        p_i_n_size_type_seq_no        IN              NUMBER,
        p_i_n_supplier_seq_no         IN              NUMBER,
        p_o_v_return_status           OUT  NOCOPY     VARCHAR2
    ) AS

    --p_o_v_return_status VARCHAR2(1);
    l_v_next_service           TOS_LL_BOOKED_LOADING.DN_NXT_SRV%TYPE;
    l_v_next_vessel            TOS_LL_BOOKED_LOADING.DN_NXT_VESSEL%TYPE;
    l_v_next_voyno             TOS_LL_BOOKED_LOADING.DN_NXT_VOYAGE%TYPE;
    l_v_next_dir               TOS_LL_BOOKED_LOADING.DN_NXT_DIR%TYPE;
    l_n_load_id                TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID%TYPE;
    l_v_imo_class              TOS_LL_BOOKED_LOADING.FK_IMDG%TYPE;
    l_v_variant                TOS_LL_BOOKED_LOADING.FK_UN_VAR%TYPE;
    l_v_un_no                  TOS_LL_BOOKED_LOADING.FK_UNNO%TYPE;
    l_v_hz_bs                  TOS_LL_BOOKED_LOADING.FLASH_UNIT%TYPE;
    l_v_next_pod1              TOS_LL_BOOKED_LOADING.DN_NXT_POD1%TYPE;
    l_v_next_pod2              TOS_LL_BOOKED_LOADING.DN_NXT_POD2%TYPE;
    l_v_next_pod3              TOS_LL_BOOKED_LOADING.DN_NXT_POD3%TYPE;
    l_v_portclass              TOS_LL_BOOKED_LOADING.FK_PORT_CLASS%TYPE;
    l_v_portclasstype          TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP%TYPE;
    l_v_op_code                TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR%TYPE;
    l_v_slot_op_code           TOS_LL_BOOKED_LOADING.FK_SLOT_OPERATOR%TYPE;
    l_v_out_slot_op_code       TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR%TYPE;
    l_v_local_status           TOS_LL_BOOKED_LOADING.LOCAL_STATUS%TYPE;
    l_v_grp_cd                 TOS_LL_LOAD_LIST.DN_SERVICE_GROUP_CODE%TYPE;
    l_v_user                   VARCHAR2(50):='SYSTEM';
    l_v_cont_seq               TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO%TYPE;
    l_v_rob                    VARCHAR2(5);
    l_v_errcd                  TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
    l_v_errmsg                 VARCHAR2(200);
    l_exc_user                 EXCEPTION;
    l_v_sql_id                 VARCHAR2(5);
    l_d_time                   TIMESTAMP;
    l_v_version                TOS_LL_LOAD_LIST.FK_VERSION%TYPE;
    l_v_status                 VARCHAR2(5);
    l_v_load_status            TOS_LL_LOAD_LIST.LOAD_LIST_STATUS%TYPE;
    l_n_discharge_id           TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE;
    l_v_check_listid           VARCHAR2(1):='Y';
    l_n_check                  NUMBER:=0;
    l_n_insert                 NUMBER:=0;
    l_v_rec_count              NUMBER := 0;
    l_n_list_upd_id            NUMBER;
    l_v_stow_pos_rob           TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION%TYPE;
    l_v_fumigation_only        TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY%TYPE; --Added by bindu on 31/03/2011
    l_v_residue                TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG%TYPE; --Added by bindu on 31/03/2011
    l_i_v_invoyageno           TOS_DL_DISCHARGE_LIST.FK_VOYAGE%TYPE;
    l_v_record_status          VARCHAR2(1); -- added by vikas, 01.12.2011
    l_n_discharge_list_status  TOS_DL_DISCHARGE_LIST.DISCHARGE_LIST_STATUS%TYPE; --Added by Rajeev on 04/04/2011
    l_v_dn_port                TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE;
    l_v_dn_terminal            TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE;
    L_V_PK_BOOKED_DISCHARGE_ID TOS_DL_BOOKED_DISCHARGE.PK_BOOKED_DISCHARGE_ID%TYPE;
    L_V_IS_DG                  VARCHAR2(1) ; -- added by vikas to identify dg booking, 30.11.2011
    l_v_weight                 TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT%TYPE;
    p_o_v_error                VARCHAR2(100);
    L_V_CRANE_TYPE             TOS_DL_BOOKED_DISCHARGE.CRANE_TYPE%TYPE; -- *10
    L_V_ETA_DATE               DATE; /* *20 */
    l_v_parameter_string       VARCHAR2(4000);
    L_V_LIST_STATUS VARCHAR2(2); /* *23 * */
    IS_ALREADY_SEND            VARCHAR2(5) := FALSE; /* *24 start */
  	L_V_FLASH_POINT            NUMBER; --*27
    l_n_found           NUMBER:=0; --*28
    l_v_bookingno           VARCHAR2(13); --*29
    V_VGM_CATEGORY          BKP009.EQP_CATEGORY%TYPE; --*30
    V_VGM                   TOS_DL_BOOKED_DISCHARGE.VGM%TYPE; --*31


    CURSOR l_cur_voyage IS
        SELECT ACT_SERVICE_CODE, ACT_VESSEL_CODE, ACT_VOYAGE_NUMBER, ACT_PORT_DIRECTION, ACT_PORT_SEQUENCE
             , LOAD_PORT, DISCHARGE_PORT, FROM_TERMINAL, TO_TERMINAL, BOOKING_NO, VOYAGE_SEQNO
        FROM   BOOKING_VOYAGE_ROUTING_DTL
        WHERE  BOOKING_NO   = p_i_v_booking_no
        AND    ROUTING_TYPE = 'S'
        AND    VOYAGE_SEQNO = NVL(p_i_n_voyseq,VOYAGE_SEQNO)
        AND    VESSEL IS NOT NULL
        AND    VOYNO IS NOT NULL
        ORDER BY VOYAGE_SEQNO;

    CURSOR l_cur_detail IS
        SELECT T_032.EQP_SIZETYPE_SEQNO FK_BKG_SIZE_TYPE_DTL,T_032.POD_STAT LOCAL_STATUS,
               T_032.BUNDLE,T_032.OPR_VOID_SLOT VOID_SLOT,
               T_032.HANDLING_INS1 FK_HANDLING_INSTRUCTION_1,
               T_032.HANDLING_INS2 FK_HANDLING_INSTRUCTION_2,
               T_032.HANDLING_INS3 FK_HANDLING_INSTRUCTION_3,
               T_032.CLR_CODE1 CONTAINER_LOADING_REM_1,T_032.CLR_CODE2 CONTAINER_LOADING_REM_2,
               T_032.SPECIAL_CARGO_CODE FK_SPECIAL_CARGO ,T_001.BOOKING_TYPE DN_BKG_TYP,
               T_001.BABKTP DN_SOC_COC,T_001.BAMODE DN_SHIPMENT_TERM,
               T_001.BASTP1 DN_SHIPMENT_TYP,
               --SUBSTR(T_001.SLOT_PARTNER_CODE, 1, 4) SLOT_PARTNER_CODE,
               T_001.BAOPCD SLOT_PARTNER_CODE,
               T_001.BADSTN FINAL_DEST,
               MLO_VESSEL EX_MLO_VESSEL,DECODE(T_001.BABKTP,'C','RCL',l_v_op_code) FK_CONTAINER_OPERATOR,
               T_009.HUMIDITY HUMIDITY, --DECODE(BABKTP,'C','RCL','S',
               --DECODE(BOOKING_TYPE,'N','RCL','FC',l_v_slot_op_code)) FK_SLOT_OPERATOR,
                T_001.BAOPCD FK_SLOT_OPERATOR, --modified by Bindu on 01/04/2011.
               FE_DATE_TIME(MLO_ETA,MLO_ETA_TIME) EX_MLO_VESSEL_ETA,T_001.BAPOD DN_FINAL_POD,
               MLO_VOYAGE EX_MLO_VOYAGE,BIBKNO FK_BOOKING_NO,BISEQN FK_BKG_EQUIPM_DTL,
               BICTRN DN_EQUIPMENT_NO,DECODE(BICTRN,NULL,NULL,'B') EQUPMENT_NO_SOURCE,
               BICSZE DN_EQ_SIZE,BICNTP DN_EQ_TYPE,BIEORF DN_FULL_MT,
               (
               CASE  WHEN T_009.SHIPMENT_TYPE = 'BBK' THEN 'L'
                     WHEN T_032.BUNDLE > 0 THEN 'P'
               ELSE BIEORF
               END
               )
               LOAD_CONDITION,'BK' LOADING_STATUS,MET_WEIGHT CONTAINER_GROSS_WEIGHT,
               T_009.SPECIAL_HANDLING DN_SPECIAL_HNDL,--UN_VARIANT FK_UN_VAR,
               BIXHGT OVERHEIGHT_CM,BIXWDL OVERWIDTH_LEFT_CM,BIXWDR OVERWIDTH_RIGHT_CM,
               BIXLNF OVERLENGTH_FRONT_CM,BIXLNB OVERLENGTH_REAR_CM,
               BIRFFM REEFER_TMP,BIRFBS REEFER_TMP_UNIT,T_009.SUPPLIER_SQNO FK_BKG_SUPPLIER,
               --T_032.FUMIGATION FUMIGATION_ONLY,T_032.RESIDUE RESIDUE_ONLY_FLAG,
               --Modification start by bindu on 31/03/3011
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     l_v_fumigation_only ELSE NULL END) FUMIGATION_ONLY,
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     l_v_residue ELSE NULL END)          RESIDUE_ONLY_FLAG,
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     l_v_imo_class ELSE NULL END)         FK_IMDG,
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     l_v_un_no ELSE NULL END)             FK_UNNO,
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     l_v_variant ELSE NULL END)         FK_UN_VAR,
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     l_v_portclass ELSE NULL END)         FK_PORT_CLASS,
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     l_v_portclasstype ELSE NULL END)   FK_PORT_CLASS_TYP,
			   --*27   start
                /*
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     l_v_hz_bs ELSE NULL END)             FLASH_UNIT,
               (CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' ) THEN
                     BIFLPT else null end)                 FLASH_POINT,*/
              CASE WHEN (T_009.SPECIAL_HANDLING = 'D1' AND  L_V_HZ_BS IS NOT NULL AND L_V_FLASH_POINT IS NOT NULL) THEN
                   L_V_HZ_BS ELSE NULL END FLASH_UNIT,
              CASE WHEN(T_009.SPECIAL_HANDLING = 'D1' AND L_V_HZ_BS IS NOT NULL AND L_V_FLASH_POINT IS NOT NULL) THEN
                        L_V_FLASH_POINT ELSE NULL END FLASH_POINT,
              --*27 end
               T_009.AIR_PRESSURE DN_VENTILATION
               ,T_009.EQP_CATEGORY  VGM_CATEGORY--*30
               ,T_009.EQP_VGM  VGM --*31
               
        FROM   BKP032 T_032, BKP001 T_001, BKP009 T_009, BOOKING_SUPPLIER_DETAIL BSD
        WHERE  T_032.EQP_SIZETYPE_SEQNO = BSD.EQP_SIZETYPE_SEQNO
        AND    T_032.BCBKNO             = BSD.BOOKING_NO
        AND    T_032.BCBKNO             = T_001.BABKNO
        AND    T_009.BIBKNO             = T_001.BABKNO
        --AND    T_032.BCSIZE=T_009.BICSZE
        --AND    T_032.BCTYPE=T_009.BICNTP
        AND    T_009.SUPPLIER_SQNO      = BSD.SUPPLIER_SQNO
        AND    T_001.BABKNO             = p_i_v_booking_no
        AND    T_009.BISEQN             = NVL(p_i_n_equipment_seq_no, T_009.BISEQN)
        AND    T_032.EQP_SIZETYPE_SEQNO = NVL(p_i_n_size_type_seq_no, T_032.EQP_SIZETYPE_SEQNO)
        AND    T_009.SUPPLIER_SQNO      = NVL(p_i_n_supplier_seq_no, T_009.SUPPLIER_SQNO);

     --Modification end by bindu on 31/03/3011

    BEGIN
        l_v_parameter_string := p_i_v_booking_no
            ||'~'|| p_i_n_voyseq
            ||'~'|| p_i_n_dischargeid
            ||'~'|| p_i_n_equipment_seq_no
            ||'~'|| p_i_n_size_type_seq_no
            ||'~'|| p_i_n_supplier_seq_no;


        g_v_sql_id := 'SQL-04001';

        l_d_time:= SYSDATE ; -- CURRENT_TIMESTAMP; --*12
        l_v_status:='BK';
        l_v_version:='99';

        --Select operator code

        g_v_sql_id := 'SQL-04002';

        BEGIN
            SELECT NVL(MAX(CASE WHEN  BKP.BNCSTP='O' THEN OPERATOR_CODE ELSE NULL END), '****') OPERATOR_CODE
                    --MAX(CASE WHEN  BKP.BNCSTP='S' THEN OPERATOR_CODE ELSE NULL END) SLOT_OPERATOR_CODE
            INTO l_v_op_code --,l_v_slot_op_code
            FROM ITP010 ITP, BKP030 BKP
            WHERE ITP.CUCUST = BKP.BNCSCD AND BKP.BNCSTP IN ('O')
            AND BNBKNO = p_i_v_booking_no;
        EXCEPTION
            WHEN OTHERS THEN
                --l_v_op_code:='';
                --l_v_slot_op_code := '';
                /*
                    Block Added by vikas to log error, 06.02.2012
                */
                g_v_err_code := TO_CHAR (SQLCODE);
                g_v_err_desc := SUBSTR(SQLERRM,1,100);
                /*
                    Block Ended by vikas to log error, 06.02.2012
                */

                g_v_record_filter := 'BNBKNO:'|| p_i_v_booking_no  ;
                g_v_record_table  := 'Operator Code Not found in ITP010,BKP030' ;
                RAISE l_exc_user;
        END;

        g_v_sql_id := 'SQL-04003';

    --Imo class,un no etc from dg_comm_detail
        BEGIN
            SELECT '1', IMO_CLASS, UN_NO, HZ_BS, nvl(UN_VARIANT,'-'), FUMIGATION_YN, RESIDUE --Modified by bindu on 31/03/2011
					, HZ_FLPT_FROM --*27
            INTO l_v_is_dg, l_v_imo_class, l_v_un_no, l_v_hz_bs, l_v_variant, l_v_fumigation_only, l_v_residue --Modified by bindu on 31/03/2011
				, L_V_FLASH_POINT -- *27
            FROM BOOKING_DG_COMM_DETAIL
            WHERE BOOKING_NO = p_i_v_booking_no
            AND IMO_CLASS    = (SELECT MIN(IMO_CLASS)
                                FROM BOOKING_DG_COMM_DETAIL
                                WHERE BOOKING_NO=p_i_v_booking_no)
            AND ROWNUM=1;
        EXCEPTION
            WHEN OTHERS THEN
                l_v_imo_class       := NULL;
                l_v_un_no           := NULL;
                l_v_hz_bs           := NULL;
                l_v_variant         := NULL;
                l_v_fumigation_only := NULL; --Added by bindu on 31/03/3011
                l_v_residue         := NULL; --Added by bindu on 31/03/3011

                /*
                g_v_record_filter := 'BOOKING_NO:'|| p_i_v_booking_no  ;
                g_v_record_table  := 'IMO_CLASS Not found in BOOKING_DG_COMM_DETAIL' ;
                */
        END;

        g_v_sql_id := 'SQL-04004';

        --Main cursor from routing table
        FOR l_cur_voyage_rec IN l_cur_voyage LOOP

            g_v_sql_id := 'SQL-04005';

            BEGIN
                PRE_GET_NEXT_POD(
                    l_cur_voyage_rec.BOOKING_NO
                    ,l_cur_voyage_rec.VOYAGE_SEQNO
                    ,l_v_next_pod1
                    ,l_v_next_pod2
                    ,l_v_next_pod3
                    ,l_v_next_service
                    ,l_v_next_vessel
                    ,l_v_next_voyno
                    ,l_v_next_dir
                );
            END;

            g_v_sql_id := 'SQL-04006';

            l_i_v_invoyageno := NULL;

            /*
                *1: Modified by vikas for DFS service, 06.02.2012
            */
            IF ((l_cur_voyage_rec.ACT_SERVICE_CODE = 'AFS') OR
                (l_cur_voyage_rec.ACT_SERVICE_CODE = 'DFS')) THEN  -- *1

                g_v_sql_id := 'SQL-04007';

                l_i_v_invoyageno := l_cur_voyage_rec.ACT_VOYAGE_NUMBER;

            ELSE

                g_v_sql_id := 'SQL-04008';

                --Get INVOYAGENO from ITP063
                BEGIN
                    SELECT INVOYAGENO
                    INTO l_i_v_invoyageno
                    FROM ITP063
                    WHERE
                    -- VVSRVC = l_cur_voyage_rec.ACT_SERVICE_CODE  -- commented by vikas, service not updated in BVRD, as k'sukit, 10.02.2012
                    -- AND  -- commented by vikas, service not updated in BVRD, as k'sukit, 10.02.2012
                    VVVESS   = l_cur_voyage_rec.ACT_VESSEL_CODE
                    AND VVVOYN   = l_cur_voyage_rec.ACT_VOYAGE_NUMBER
                    AND VVPDIR   = l_cur_voyage_rec.ACT_PORT_DIRECTION
                    AND VVPCSQ   = l_cur_voyage_rec.ACT_PORT_SEQUENCE
                    AND VVPCAL   = l_cur_voyage_rec.DISCHARGE_PORT
                    AND VVTRM1   = l_cur_voyage_rec.TO_TERMINAL
                    AND VVVERS   = 99
                    -- AND VVFORL IS NOT NULL; -- Added as suggested by k'chatgamol and k'sukit, 28.02.2012 -- *6
                    AND (VVSRVC = 'DFS' OR VVFORL IS NOT NULL) ; -- *6


                    -- AND OMMISSION_FLAG IS NULL; -- commented by vikas as k'chatgamol and k'myo suggestion, 21.11.2011
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        /* When invoyage not found then do not throw any exception and continue the execution *

                        g_v_err_code := TO_CHAR (SQLCODE);
                        g_v_err_desc := SUBSTR(SQLERRM,1,100);

                        g_v_record_filter := 'VVSRVC:' || l_cur_voyage_rec.ACT_SERVICE_CODE    ||
                                            ' VVVESS:' || l_cur_voyage_rec.ACT_VESSEL_CODE     ||
                                            ' VVVOYN'  || l_cur_voyage_rec.ACT_VOYAGE_NUMBER   ||
                                            ' VVPDIR:' || l_cur_voyage_rec.ACT_PORT_DIRECTION  ||
                                            ' VVPCSQ:' || l_cur_voyage_rec.ACT_PORT_SEQUENCE   ||
                                            ' VVPCAL:' || l_cur_voyage_rec.DISCHARGE_PORT      ||
                                            ' VVTRM1:' || l_cur_voyage_rec.TO_TERMINAL         ||
                                            ' VVVERS:' || 99                                   ||
                                            ' OMMISSION_FLAG: IS NULL';
                        g_v_record_table  := 'INVOYAGENO Not found in ITP063' ;

                        RAISE l_exc_user;
                        */
                        NULL;

                    WHEN OTHERS THEN
                        g_v_record_filter := 'VVSRVC:' || l_cur_voyage_rec.ACT_SERVICE_CODE    ||
                                            'VVVESS:' || l_cur_voyage_rec.ACT_VESSEL_CODE     ||
                                            'VVVOYN'  || l_cur_voyage_rec.ACT_VOYAGE_NUMBER   ||
                                            'VVPDIR:' || l_cur_voyage_rec.ACT_PORT_DIRECTION  ||
                                            'VVPCSQ:' || l_cur_voyage_rec.ACT_PORT_SEQUENCE   ||
                                            'VVPCAL:' || l_cur_voyage_rec.DISCHARGE_PORT      ||
                                            'VVTRM1:' || l_cur_voyage_rec.TO_TERMINAL         ||
                                            'VVVERS:' || 99                                   ||
                                            'OMMISSION_FLAG: IS NULL';
                        g_v_record_table  := 'Error occured.Contact System administrator' ;
                        g_v_err_code   := TO_CHAR (SQLCODE);
                        g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                        RAISE l_exc_user;
                END;
                g_v_sql_id := 'SQL-04009';

            END IF;

            --Check discharge list exist or not
            g_v_sql_id := 'SQL-04010';

            IF p_i_n_dischargeid IS NULL THEN

                g_v_sql_id := 'SQL-04011';

                BEGIN
                    l_v_check_listid:='N';
                    /* if invoyage found in ITP063 Table.*/

                    IF l_i_v_invoyageno IS NOT NULL THEN
                        g_v_sql_id := 'SQL-04012';

                        SELECT DISTINCT PK_DISCHARGE_LIST_ID
                        INTO l_n_discharge_id
                        FROM TOS_DL_DISCHARGE_LIST
                        WHERE FK_SERVICE          = l_cur_voyage_rec.ACT_SERVICE_CODE
                        AND FK_VESSEL             = l_cur_voyage_rec.ACT_VESSEL_CODE
                        AND FK_VOYAGE             = l_i_v_invoyageno
                        AND FK_DIRECTION          = l_cur_voyage_rec.ACT_PORT_DIRECTION
                        AND DN_PORT               = l_cur_voyage_rec.DISCHARGE_PORT
                        AND DN_TERMINAL           = l_cur_voyage_rec.TO_TERMINAL
                        AND RECORD_STATUS         = 'A'
                        AND ROWNUM = 1;  -- Added by vikas, 08.12.2011

                        /* Commented by vikas, as k'chatgamol say port sequence# may change
                            so should not join port sequience, 16.11.2011
                        AND FK_PORT_SEQUENCE_NO   = l_cur_voyage_rec.ACT_PORT_SEQUENCE
                        */
                    ELSE

                        g_v_sql_id := 'SQL-04013';

                        /* if invoyage details is already deleted from ITP063 Table.*/
                        SELECT DISTINCT DL.PK_DISCHARGE_LIST_ID
                        INTO l_n_discharge_id
                        FROM TOS_DL_DISCHARGE_LIST DL,
                            TOS_DL_BOOKED_DISCHARGE BKD
                        WHERE DL.FK_SERVICE         = l_cur_voyage_rec.ACT_SERVICE_CODE
                        AND DL.FK_VESSEL            = l_cur_voyage_rec.ACT_VESSEL_CODE
                        AND DL.FK_DIRECTION         = l_cur_voyage_rec.ACT_PORT_DIRECTION
                        AND DL.DN_PORT              = l_cur_voyage_rec.DISCHARGE_PORT
                        AND DL.DN_TERMINAL          = l_cur_voyage_rec.TO_TERMINAL
                        AND DL.RECORD_STATUS        = 'A'
                        AND DL.PK_DISCHARGE_LIST_ID = BKD.FK_DISCHARGE_LIST_ID
                        AND BKD.FK_BOOKING_NO       = p_i_v_booking_no
                        AND ROWNUM = 1;  -- Added by vikas, 08.12.2011

                        /* Commented by vikas, as k'chatgamol say port sequence# may change
                            so should not join port sequience, 16.11.2011
                        AND DL.FK_PORT_SEQUENCE_NO  = l_cur_voyage_rec.ACT_PORT_SEQUENCE
                        */
                    END IF;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_n_discharge_id:=NULL;
                        /* g_v_record_filter := 'FK_SERVICE:'          || l_cur_voyage_rec.ACT_SERVICE_CODE   ||
                                            'FK_VESSEL:'           || l_cur_voyage_rec.ACT_VESSEL_CODE    ||
                                            'FK_VOYAGE:'           || l_i_v_invoyageno                    ||
                                            'FK_DIRECTION:'        || l_cur_voyage_rec.ACT_PORT_DIRECTION ||
                                            'DN_PORT:'             || l_cur_voyage_rec.DISCHARGE_PORT     ||
                                            'FK_PORT_SEQUENCE_NO:' || l_cur_voyage_rec.ACT_PORT_SEQUENCE  ||
                                            'RECORD_STATUS =A';
                        g_v_record_table  := 'Discharge list Not found in TOS_DL_DISCHARGE_LIST' ; */
                    WHEN OTHERS THEN
                        l_n_discharge_id:=NULL;
                END;

            ELSE
                g_v_sql_id := 'SQL-04014';

                l_n_discharge_id := p_i_n_dischargeid;
            END IF;  -- end if of dischargeid

            g_v_sql_id := 'SQL-04015';

            --Port class type
            BEGIN

                /*    Modified by vikas if normal booking then no need to
                    validate port class and port code, as k'chatgamol, 30.11.2011    */
                IF l_v_is_dg = '1' THEN

                    g_v_sql_id := 'SQL-04016';

                    SELECT PORT_CLASS_TYPE
                    INTO l_v_portclasstype
                    FROM PORT_CLASS_TYPE
                    WHERE PORT_CODE=l_cur_voyage_rec.LOAD_PORT;
                END IF;
                /*    End Modified vikas, 30.11.2011    */
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_v_portclass:=NULL;

                    /* g_v_record_filter := 'PORT_CODE:'|| l_cur_voyage_rec.LOAD_PORT  ;
                    g_v_record_table  := 'Port Class type Not found in PORT_CLASS_TYPE' ; */

                WHEN OTHERS THEN
                    l_v_portclass:=NULL;

                    /* g_v_record_filter := 'PORT_CODE:'|| l_cur_voyage_rec.LOAD_PORT  ;
                    g_v_record_table  := 'Error occured.Contact System administrator' ; */

            END;

            g_v_sql_id := 'SQL-04017';

            --Port code
            BEGIN
                /*    Modified by vikas if normal booking then no need to
                    validate port class and port code, as k'chatgamol, 30.11.2011    */
                IF l_v_is_dg = '1' THEN

                    g_v_sql_id := 'SQL-04018';

                    SELECT PORT_CLASS_CODE
                    INTO l_v_portclass
                    FROM PORT_CLASS
                    WHERE UNNO            = l_v_un_no
                    AND VARIANT           = NVL(l_v_variant, '-')  -- Change by vikas, varint can not null, 18.11.2011
                    AND IMDG_CLASS        = l_v_imo_class
                    AND PORT_CLASS_TYPE   = l_v_portclasstype;
                END IF;
                /*    End Modified vikas, 30.11.2011    */

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_v_portclass := NULL;

                    /* g_v_record_filter := 'UNNO:'           || l_v_un_no            ||
                    ' VARIANT:'        || l_v_variant        ||
                    ' IMDG_CLASS:'     || l_v_imo_class      ||
                    ' PORT_CLASS_TYPE:'|| l_v_portclasstype;
                    g_v_record_table  := 'Port Code Not found in PORT_CLASS' ; */

                WHEN OTHERS THEN
                    l_v_portclass := NULL;

                    /* g_v_record_filter := 'UNNO:'           || l_v_un_no            ||
                    ' VARIANT:'        || l_v_variant        ||
                    ' IMDG_CLASS:'     || l_v_imo_class      ||
                    ' PORT_CLASS_TYPE:'|| l_v_portclasstype;
                    g_v_record_table  := 'Error occured.Contact System administrator' ; */

            END;

            g_v_sql_id := 'SQL-04019';

            --Service group code
            BEGIN
                SELECT SERVICE_GROUP_CODE
                INTO l_v_grp_cd
                FROM ITP085
                WHERE SWSRVC = l_cur_voyage_rec.ACT_SERVICE_CODE;
            EXCEPTION
                --added by aks for non mandatory
                WHEN NO_DATA_FOUND THEN
                    l_v_grp_cd:=NULL;
                    /* Start Commented by vikas as no need to log the message for
                    service group code , 21.11.2011

                    g_v_record_filter := 'SWSRVC:'|| l_cur_voyage_rec.ACT_SERVICE_CODE;
                    g_v_record_table  := 'Service group code Not found in ITP085' ;

                    End commented by vikas, 21.11.2011*/
                WHEN OTHERS THEN
                    l_v_grp_cd:=NULL;
                    -- RAISE l_exc_user ; Commented no need to raise exception
                    /* g_v_record_filter := 'SWSRVC:'|| l_cur_voyage_rec.ACT_SERVICE_CODE;
                    g_v_record_table  := '*Deepak' ; */
            END;

            g_v_sql_id := 'SQL-04020';


            --If load list not exists then make and insert in load list table
            IF l_n_discharge_id IS NULL THEN

                g_v_sql_id := 'SQL-04021';

                SELECT SE_DLZ01.NEXTVAL INTO l_n_discharge_id from dual;

                g_v_sql_id := 'SQL-04022';

                INSERT INTO TOS_DL_DISCHARGE_LIST
                (
                    PK_DISCHARGE_LIST_ID,DN_SERVICE_GROUP_CODE,FK_SERVICE,FK_VESSEL,
                    FK_VOYAGE,FK_DIRECTION,FK_PORT_SEQUENCE_NO,FK_VERSION,
                    DN_PORT,DN_TERMINAL,DISCHARGE_LIST_STATUS,DA_DISCHARGED_TOT,
                    DA_BOOKED_TOT,DA_ROB_TOT,DA_OVERLANDED_TOT,DA_SHORTLANDED_TOT,
                    RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,
                    RECORD_CHANGE_DATE
                )
                VALUES
                (
                    l_n_discharge_id,l_v_grp_cd,l_cur_voyage_rec.ACT_SERVICE_CODE,
                    l_cur_voyage_rec.ACT_VESSEL_CODE, l_i_v_invoyageno,
                    l_cur_voyage_rec.ACT_PORT_DIRECTION, l_cur_voyage_rec.ACT_PORT_SEQUENCE, l_v_version,
                    l_cur_voyage_rec.DISCHARGE_PORT,l_cur_voyage_rec.TO_TERMINAL,'0',0,
                    0,0,0,0,'A',g_v_user,l_d_time,g_v_user,l_d_time
                );

            END IF;

            g_v_sql_id := 'SQL-04023';

            /* *20 start * */
            BEGIN
                SELECT
                    TO_DATE(ITP.VVARDT || LPAD(ITP.VVARTM, 4, '0'), 'YYYYMMDDHH24MI') ETA_DATE
                INTO
                    L_V_ETA_DATE
                FROM
                    TOS_DL_DISCHARGE_LIST TDL,
                    ITP063 ITP
                WHERE
                    TDL.FK_SERVICE = ITP.VVSRVC AND
                    TDL.FK_VESSEL = ITP.VVVESS AND
                    TDL.FK_VOYAGE = DECODE(TDL.FK_SERVICE, 'AFS', ITP.VVVOYN, ITP.INVOYAGENO) AND
                    TDL.DN_PORT = ITP.VVPCAL AND
                    TDL.DN_TERMINAL = ITP.VVTRM1 AND
                    ITP.OMMISSION_FLAG IS NULL AND
                    TDL.FK_DIRECTION = ITP.VVPDIR AND
                    TDL.FK_PORT_SEQUENCE_NO = ITP.VVPCSQ AND
                    ITP.VVVERS = 99 AND
                    TDL.FK_VERSION = 99 AND
                    TDL.PK_DISCHARGE_LIST_ID = L_N_DISCHARGE_ID;
            EXCEPTION
                WHEN OTHERS THEN
                    L_V_ETA_DATE := NULL;
            END;
            /* *20 end * */

            g_v_sql_id := 'SQL-04024';

            --Deatail cursor from BKP009,BKP032,BKP001
            FOR l_cur_detail_rec IN l_cur_detail LOOP
                /*
                    Block Start by vikas to reinitialize
                    the variable, 06.02.2012
                */

                g_v_sql_id := 'SQL-04025';

                g_v_record_filter := NULL;
                g_v_record_table := NULL;

                /*
                    Block End by vikas, 06.02.2012
                */

                /*
                    Logic moved to get stowage position, 30.01.2012
                */
                --For loading status
                BEGIN
                    /*
                        Modified by vikas, to get stowage position and weight from
                        the load list, k'chatgamol, 30.01.2012
                    */
                    l_v_stow_pos_rob := NULL;
                    l_v_weight := NULL;
                    V_VGM := NULL; --*31

                    g_v_sql_id := 'SQL-04026';

                    SELECT
                        LOADING_STATUS
                        , STOWAGE_POSITION
                        , CONTAINER_GROSS_WEIGHT
                        , CATEGORY_CODE --*30
                        , VGM --*31
                    INTO
                        l_v_load_status
                        , l_v_stow_pos_rob
                        , l_v_weight
                        ,V_VGM_CATEGORY --*30
                        ,V_VGM --*31
                    FROM
                        TOS_LL_BOOKED_LOADING
                    WHERE
                        FK_BOOKING_NO                    = l_cur_voyage_rec.BOOKING_NO
                        AND    FK_BKG_EQUIPM_DTL         = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                        AND    FK_BKG_VOYAGE_ROUTING_DTL = l_cur_voyage_rec.VOYAGE_SEQNO
                        AND    DN_DISCHARGE_PORT         = l_cur_voyage_rec.DISCHARGE_PORT
                        AND    DN_DISCHARGE_TERMINAL     = l_cur_voyage_rec.TO_TERMINAL -- added, 09.12.2011
                        AND    RECORD_STATUS             = 'A';
                    /*
                        Modification end by vikas, 30.01.2012
                    */

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_v_load_status:='X';


                        /* g_v_record_filter := 'FK_BOOKING_NO:'            || l_cur_voyage_rec.BOOKING_NO        ||
                                            ' FK_BKG_EQUIPM_DTL:'        || l_cur_detail_rec.FK_BKG_EQUIPM_DTL ||
                                            ' FK_BKG_VOYAGE_ROUTING_DTL:'|| l_cur_voyage_rec.VOYAGE_SEQNO      ||
                                            ' DN_DISCHARGE_PORT:'        || l_cur_voyage_rec.DISCHARGE_PORT    ||
                                            ' RECORD_STATUS =A';
                        g_v_record_table  := 'Loading Status Not found in TOS_LL_BOOKED_LOADING' ; */

                    /*
                        Block started by vikas to log error msg properly, 10.02.2012
                    */
                    WHEN OTHERS THEN
                        l_v_load_status:='X';

                        /* g_v_record_filter := 'FK_BOOKING_NO:'            || l_cur_voyage_rec.BOOKING_NO        ||
                                            ' FK_BKG_EQUIPM_DTL:'        || l_cur_detail_rec.FK_BKG_EQUIPM_DTL ||
                                            ' FK_BKG_VOYAGE_ROUTING_DTL:'|| l_cur_voyage_rec.VOYAGE_SEQNO      ||
                                            ' DN_DISCHARGE_PORT:'        || l_cur_voyage_rec.DISCHARGE_PORT    ||
                                            ' RECORD_STATUS =A';
                        g_v_record_table  := 'Loading Status Not found in TOS_LL_BOOKED_LOADING' ; */
                        -- l_v_load_status:='X';

                    /*
                        Block ended by vikas, 10.02.2012
                    */

                    --WHEN OTHERS THEN -- Commented to remove teh duplicate container removal 19.01.2012

                        /*    Start Added By Vikas, duplicate container is inserted with
                            DN_LOADING_STATUS load, as k'chatgamol, 29.11.2011*/

                        /*
                        l_v_load_status:='Y';


                        g_v_record_filter := 'FK_BOOKING_NO:'            || l_cur_voyage_rec.BOOKING_NO        ||
                                            ' FK_BKG_EQUIPM_DTL:'        || l_cur_detail_rec.FK_BKG_EQUIPM_DTL ||
                                            ' FK_BKG_VOYAGE_ROUTING_DTL:'|| l_cur_voyage_rec.VOYAGE_SEQNO      ||
                                            ' DN_DISCHARGE_PORT:'        || l_cur_voyage_rec.DISCHARGE_PORT    ||
                                            ' RECORD_STATUS =A';
                        g_v_record_table  := 'Error occured.Contact System administrator' ;

                        */

                        /*    Call to remove duplicate entries from detail table
                            for load list and discharge list    */
                    /* PRE_REMOVE_DUPLICATE_LLDL (
                            l_cur_voyage_rec.BOOKING_NO
                            , l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                            , l_cur_voyage_rec.VOYAGE_SEQNO
                            , l_cur_voyage_rec.DISCHARGE_PORT
                            , l_cur_voyage_rec.TO_TERMINAL
                            , l_cur_detail_rec.DN_EQUIPMENT_NO  -- ADDED, 21.12.2011
                            , l_v_load_status        -- out parameter
                        );*/ --Leena 19.01.2012 Commented duplicate container removal

                        /*    End Added By Vikas, 29.11.2011    */

                END;
                /*
                    Logic moved to get stowage position, 30.01.2012
                */

                g_v_sql_id := 'SQL-04027';

                IF(l_v_stow_pos_rob IS NULL) THEN -- already get stwoage position from booked loading table.

                    g_v_sql_id := 'SQL-04028';

                    BEGIN
                        SELECT STOWAGE_POSITION
                        INTO   l_v_stow_pos_rob
                        FROM   BKG_ROB_CONTAINER
                        WHERE  FK_DEPARTURE_BOOKING_NUMBER = l_cur_voyage_rec.BOOKING_NO
                        AND    CONTAINER_NUMBER            = l_cur_detail_rec.DN_EQUIPMENT_NO;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                                null;
            --                 l_v_stow_pos_rob := NULL;

                            /* g_v_record_filter := 'FK_DEPARTURE_BOOKING_NUMBER:'|| l_cur_voyage_rec.BOOKING_NO ||
                                                ' CONTAINER_NUMBER:'           || l_cur_detail_rec.DN_EQUIPMENT_NO;
                            g_v_record_table  := 'Stowage position Not found in BKG_ROB_CONTAINER' ; */

                        WHEN OTHERS THEN
                                null;
            --                 l_v_stow_pos_rob := NULL;

 /*                            g_v_record_filter := 'FK_DEPARTURE_BOOKING_NUMBER:'|| l_cur_voyage_rec.BOOKING_NO ||
                                                ' CONTAINER_NUMBER:'           || l_cur_detail_rec.DN_EQUIPMENT_NO;
                            g_v_record_table  := 'Error occured.Contact System administrator' ;
 */
                    END;
                END IF; -- already get stwoage position from booked loading table.


                g_v_sql_id := 'SQL-04029';

                IF l_cur_voyage_rec.DISCHARGE_PORT=l_cur_detail_rec.DN_FINAL_POD THEN
                    g_v_sql_id := 'SQL-04030';

                    l_v_local_status:=l_cur_detail_rec.LOCAL_STATUS;
                ELSE
                    g_v_sql_id := 'SQL-04031';

                    l_v_local_status:='T';
                END IF;
                --Get Slot Operator

                g_v_sql_id := 'SQL-04032';

                IF l_v_local_status = 'T' THEN
                    g_v_sql_id := 'SQL-04033';

                    l_v_out_slot_op_code := 'RCL';
                ELSIF l_cur_detail_rec.DN_SOC_COC = 'S' THEN
                    g_v_sql_id := 'SQL-04034';

                        IF l_cur_detail_rec.DN_BKG_TYP IN ('N','ER') THEN
                            g_v_sql_id := 'SQL-04035';

                            l_v_out_slot_op_code := l_v_op_code;
                        ELSE
                            g_v_sql_id := 'SQL-04036';

                            l_v_out_slot_op_code := l_cur_detail_rec.SLOT_PARTNER_CODE;
                        END IF;
                END IF;
                /*
                        SELECT NVL(MAX(CONTAINER_SEQ_NO),0)
                        INTO l_v_cont_seq
                        FROM TOS_DL_BOOKED_DISCHARGE
                        WHERE FK_DISCHARGE_LIST_ID = l_n_discharge_id;

                        l_v_cont_seq :=l_v_cont_seq +1;
                */
                l_n_insert:=0;

                g_v_sql_id := 'SQL-04037';

                IF l_cur_detail_rec.DN_EQUIPMENT_NO IS NOT NULL THEN
                    g_v_sql_id := 'SQL-04038';

                    BEGIN

                        /*  Start modified by vikas, to Check if equipment exixts
                            with record status 'A' with same load list
                            then update that equipment and not to insert
                            new equipment, as k'chatgamol, 24.11.2011*/
                        /*
                        SELECT 1, PK_BOOKED_DISCHARGE_ID
                        INTO   l_n_check, l_n_list_upd_id
                        FROM   TOS_DL_BOOKED_DISCHARGE
                        WHERE  DN_EQUIPMENT_NO = l_cur_detail_rec.DN_EQUIPMENT_NO
                        AND    RECORD_STATUS   = 'S'
                        AND    ROWNUM = 1;
                        */

                        /* Commented by vikas to tune the performance, 26.11.2011

                        SELECT 1, PK_BOOKED_DISCHARGE_ID
                        INTO   l_n_check, l_n_list_upd_id
                        FROM (
                            SELECT PK_BOOKED_DISCHARGE_ID
                            FROM   TOS_DL_BOOKED_DISCHARGE
                            WHERE  DN_EQUIPMENT_NO = l_cur_detail_rec.DN_EQUIPMENT_NO
                            AND    RECORD_STATUS   = 'S'

                            UNION ALL

                            SELECT PK_BOOKED_DISCHARGE_ID
                            FROM   TOS_DL_BOOKED_DISCHARGE
                            WHERE  DN_EQUIPMENT_NO  = l_cur_detail_rec.DN_EQUIPMENT_NO
                            AND    FK_DISCHARGE_LIST_ID  = l_n_discharge_id
                        )
                        WHERE ROWNUM = 1;
                        /*  End modified by vikas, 24.11.2011     */
                        /*  End added by vikas, 24.11.2011  */

                        /*    Start Added by vikas 26.11.2011    */
                        SELECT 1, PK_BOOKED_DISCHARGE_ID, record_status,FK_Booking_no
                        INTO   l_n_check, l_n_list_upd_id, l_v_record_status,l_v_bookingno
                        FROM   TOS_DL_BOOKED_DISCHARGE
                        WHERE  DN_EQUIPMENT_NO = l_cur_detail_rec.DN_EQUIPMENT_NO
                        AND    (RECORD_STATUS   = 'S'
                                    OR FK_DISCHARGE_LIST_ID  = l_n_discharge_id)
                        AND    ROWNUM = 1;
                        /*    End Added by vikas 26.11.2011    */


                        g_v_sql_id := 'SQL-04039';

                        if (l_v_record_status = 'S') THEN
                            g_v_sql_id := 'SQL-04040';

                            SELECT NVL(MAX(CONTAINER_SEQ_NO),0)
                            INTO l_v_cont_seq
                            FROM TOS_DL_BOOKED_DISCHARGE
                            WHERE FK_DISCHARGE_LIST_ID = l_n_discharge_id;

                            l_v_cont_seq :=l_v_cont_seq +1;

                        END IF;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            l_n_check:=0;

                            /* g_v_record_filter := 'DN_EQUIPMENT_NO:'|| l_cur_detail_rec.DN_EQUIPMENT_NO||
                                                    ' RECORD_STATUS =A';
                            g_v_record_table  := 'Booking Discharge ID Not found in TOS_DL_BOOKED_DISCHARGE' ; */

                        WHEN OTHERS THEN
                            l_n_check:=0;

                            /* g_v_record_filter := 'DN_EQUIPMENT_NO:'|| l_cur_detail_rec.DN_EQUIPMENT_NO||
                                                    ' RECORD_STATUS =A';
                            g_v_record_table  := 'Booking Discharge ID Not found in TOS_DL_BOOKED_DISCHARGE' ; */

                    END;
                    g_v_sql_id := 'SQL-04041';

                    IF l_n_check = 1 THEN
                        /*
                            *13: start
                        */
                        PRE_GET_LL_DL_STATUS (
                            l_n_discharge_id,
                            l_cur_detail_rec.DN_EQUIPMENT_NO,
                            'DL',
                            l_v_status
                        );
                        /*
                            *13: end
                        */
                        g_v_sql_id := 'SQL-04042';
                        /* * *23 start * */
                        PRE_GET_LIST_STATUS (
                            L_N_DISCHARGE_ID,
                            DISCHARGE_LIST,
                            L_V_LIST_STATUS
                        );

                        g_v_sql_id := 'SQLa04042';

                        /* * *23 end * */
                        IF ((L_V_LIST_STATUS = DISCHARGE_COMPLETE) OR
                            (L_V_LIST_STATUS = READY_FOR_INVOICE) OR
                            (L_V_LIST_STATUS = WORK_COMPLETE)) THEN  -- *23

                            /* *22 start * */
                            g_v_sql_id := 'SQLb04042';

                            BEGIN
                                PCE_ECM_RAISE_ENOTICE.PRE_DL_WRK_SRT_SYNC (
                                      l_n_discharge_id
                                    , l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                    , l_cur_detail_rec.FK_BOOKING_NO
                                    , g_n_bussiness_key_sync_dws_add
                                    , g_v_user
                                    , TO_CHAR(l_d_time,'YYYYMMDDHH24MISS')
                                    , p_o_v_error
                                );

                                /* *24 start * */
                                -- g_v_sql_id := 'SQL-04017b';
                                -- PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                                --       l_n_discharge_id
                                --     , l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                --     , l_cur_detail_rec.FK_BOOKING_NO
                                --     , g_n_bussiness_key_sync_cch_add
                                --     , null -- Old Equipment No.
                                --     , null -- New Equipment No.
                                --     , 'A'
                                --     , g_v_user
                                --     , TO_CHAR(l_d_time,'YYYYMMDDHH24MISS')
                                --     , p_o_v_error
                                -- );
                                /* *24 end  * */

                            exception
                                when others then
                                    PRE_TOS_SYNC_ERROR_LOG(
                                        'EXCETION in calling mail '
                                            ||'~'|| l_n_discharge_id
                                            ||'~'|| g_v_sql_id
                                            ||'~'|| l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                            ||'~'|| l_cur_detail_rec.FK_BOOKING_NO,
                                        'SYNC',
                                        'D',
                                        'SYNC',
                                        'A',
                                        g_v_user,
                                        SYSDATE,
                                        g_v_user,
                                        SYSDATE
                                    );
                            end ;
                        END IF; -- *23
                        /* *22 end * */

                        /* *24 start * */
                        BEGIN
                                g_v_sql_id := 'SQL-04017b';
                            /* * check if mail is already send for this vessel voyage then
                                no need to send mail * */
                            IF IS_ALREADY_SEND = FALSE THEN
                                PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                                      l_n_discharge_id
                                    , l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                    , l_cur_detail_rec.FK_BOOKING_NO
                                    , g_n_bussiness_key_sync_cch_add
                                    , NULL -- OLD EQUIPMENT NO.
                                    , NULL -- NEW EQUIPMENT NO.
                                    , 'A'
                                    , g_v_user
                                    , TO_CHAR(l_d_time,'YYYYMMDDHH24MISS')
                                    , p_o_v_error
                                );
                            END IF;
                        EXCEPTION
                            WHEN OTHERS THEN
                                    PRE_TOS_SYNC_ERROR_LOG(
                                        'EXCETION in calling mail '
                                            ||'~'|| l_n_discharge_id
                                            ||'~'|| g_v_sql_id
                                            ||'~'|| l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                            ||'~'|| l_cur_detail_rec.FK_BOOKING_NO,
                                        'SYNC',
                                        'D',
                                        'SYNC',
                                        'A',
                                        g_v_user,
                                        SYSDATE,
                                        g_v_user,
                                        SYSDATE
                                    );
                        END ;

                        /* *24 end  * */
                      /*
                         *29 -- *29
                          Start

                      */
                       if l_v_record_status    = 'S' Then -- *29
                          If p_i_v_booking_no = l_v_bookingno Then  --*29
                        UPDATE TOS_DL_BOOKED_DISCHARGE
                        SET    RECORD_STATUS                = 'A'
                            , FK_DISCHARGE_LIST_ID         = l_n_discharge_id
                            , CONTAINER_SEQ_NO             = CASE WHEN(l_v_record_status = 'S') THEN l_v_cont_seq ELSE CONTAINER_SEQ_NO END
                            , FK_BOOKING_NO                = l_cur_detail_rec.FK_BOOKING_NO
                            , FK_BKG_SIZE_TYPE_DTL         = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                            , FK_BKG_SUPPLIER              = l_cur_detail_rec.FK_BKG_SUPPLIER
                            , FK_BKG_EQUIPM_DTL            = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                            , FK_BKG_VOYAGE_ROUTING_DTL    = l_cur_voyage_rec.VOYAGE_SEQNO
                            , DN_EQ_SIZE                   = l_cur_detail_rec.DN_EQ_SIZE
                            , DN_EQ_TYPE                   = l_cur_detail_rec.DN_EQ_TYPE
                            , DN_FULL_MT                   = l_cur_detail_rec.DN_FULL_MT
                            , DN_BKG_TYP                   = l_cur_detail_rec.DN_BKG_TYP
                            , DN_SOC_COC                   = l_cur_detail_rec.DN_SOC_COC
                            , DN_SHIPMENT_TERM             = l_cur_detail_rec.DN_SHIPMENT_TERM
                            , DN_SHIPMENT_TYP              = l_cur_detail_rec.DN_SHIPMENT_TYP
                            , LOCAL_STATUS                 = l_v_local_status
                            , LOCAL_TERMINAL_STATUS       = (CASE  WHEN l_v_local_status = 'L'THEN 'Local' WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END) -- *9
                            --, DISCHARGE_STATUS             = l_v_status
                            , DISCHARGE_STATUS             = DECODE(DISCHARGE_STATUS, 'DI', DISCHARGE_STATUS, l_v_status) -- *13
                            , LOAD_CONDITION               = l_cur_detail_rec.LOAD_CONDITION -- *11
                            , DN_LOADING_STATUS            = l_v_load_status
                            , CONTAINER_GROSS_WEIGHT       = NVL(l_v_weight, l_cur_detail_rec.CONTAINER_GROSS_WEIGHT) -- added, 30.01.2012
                            , STOWAGE_POSITION             = NVL(l_v_stow_pos_rob, STOWAGE_POSITION) -- added, 30.01.2012
                            , VOID_SLOT                    = l_cur_detail_rec.VOID_SLOT
                            , FK_SLOT_OPERATOR             = l_cur_detail_rec.FK_SLOT_OPERATOR
                            --, FK_CONTAINER_OPERATOR        = l_cur_detail_rec.FK_CONTAINER_OPERATOR
                            --, OUT_SLOT_OPERATOR            = l_v_out_slot_op_code
                            , DN_SPECIAL_HNDL              = l_cur_detail_rec.DN_SPECIAL_HNDL
                            , DN_POL                       = l_cur_voyage_rec.LOAD_PORT
                            , DN_POL_TERMINAL              = l_cur_voyage_rec.FROM_TERMINAL
                            , DN_NXT_POD1                  = l_v_next_pod1
                            , DN_NXT_POD2                  = l_v_next_pod2
                            , DN_NXT_POD3                  = l_v_next_pod3
                            , DN_FINAL_POD                 = l_cur_detail_rec.DN_FINAL_POD
                            , FINAL_DEST                   = l_cur_detail_rec.FINAL_DEST
                            , DN_NXT_SRV                   = l_v_next_service
                            , DN_NXT_VESSEL                = l_v_next_vessel
                            , DN_NXT_VOYAGE                = l_v_next_voyno
                            , DN_NXT_DIR                   = l_v_next_dir
                            --, FK_HANDLING_INSTRUCTION_1    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_1
                            --, FK_HANDLING_INSTRUCTION_2    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_2
                            --, FK_HANDLING_INSTRUCTION_3    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_3
                            --, CONTAINER_LOADING_REM_1      = l_cur_detail_rec.CONTAINER_LOADING_REM_1
                            --, CONTAINER_LOADING_REM_2      = l_cur_detail_rec.CONTAINER_LOADING_REM_2
                            --, FK_SPECIAL_CARGO             = l_cur_detail_rec.FK_SPECIAL_CARGO
                            --, FK_IMDG                      = l_v_imo_class
                            --, FK_UNNO                      = l_v_un_no
                            --, FK_UN_VAR                    = l_v_variant
                            --, FK_PORT_CLASS                = l_v_portclass
                            --, FK_PORT_CLASS_TYP            = l_cur_detail_rec.FK_PORT_CLASS_TYP
                            , FK_IMDG                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_IMDG)
                            , FK_UNNO                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_UNNO)
                            , FK_UN_VAR                      = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_UN_VAR)
                            , FK_PORT_CLASS                  = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_PORT_CLASS)
                            , FK_PORT_CLASS_TYP              = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_PORT_CLASS_TYP)
                            --, FLASH_UNIT                   = l_v_hz_bs
                            --, FLASH_POINT                  = l_cur_detail_rec.FLASH_POINT
                            --, FUMIGATION_ONLY              = l_cur_detail_rec.FUMIGATION_ONLY
                            --, RESIDUE_ONLY_FLAG            = l_cur_detail_rec.RESIDUE_ONLY_FLAG
                            --, OVERWIDTH_LEFT_CM            = l_cur_detail_rec.OVERHEIGHT_CM
                            --, OVERWIDTH_RIGHT_CM           = l_cur_detail_rec.OVERWIDTH_RIGHT_CM
                            --, OVERLENGTH_FRONT_CM          = l_cur_detail_rec.OVERLENGTH_FRONT_CM
                            --, OVERLENGTH_REAR_CM           = l_cur_detail_rec.OVERLENGTH_REAR_CM
                            --, REEFER_TEMPERATURE           = l_cur_detail_rec.REEFER_TMP
                            --, REEFER_TMP_UNIT              = l_cur_detail_rec.REEFER_TMP_UNIT
                            --, DN_HUMIDITY                  = l_cur_detail_rec.HUMIDITY
                            --, DN_VENTILATION               = l_cur_detail_rec.DN_VENTILATION
                            , RECORD_CHANGE_USER           = g_v_user
                            , RECORD_CHANGE_DATE           = l_d_time
                            , ACTIVITY_DATE_TIME           = L_V_ETA_DATE /* *20 */
                            ,CATEGORY_CODE               =  NVL(V_VGM_CATEGORY,l_cur_detail_rec.VGM_CATEGORY) --*30
                            ,VGM                         = NVL(V_VGM, l_cur_detail_rec.VGM)--*31
                        WHERE   DN_EQUIPMENT_NO              = l_cur_detail_rec.DN_EQUIPMENT_NO
                            AND     RECORD_STATUS                = 'S'
                          --  AND    (RECORD_STATUS    = 'S' OR FK_DISCHARGE_LIST_ID = l_n_discharge_id)  -- *29
                           AND     PK_BOOKED_DISCHARGE_ID       = l_n_list_upd_id;
                                  g_v_sql_id := 'SQL-04043';
                                l_n_insert:=1;
                       Else
                                                  UPDATE TOS_DL_BOOKED_DISCHARGE
                        SET    RECORD_STATUS                = 'A'
                            , FK_DISCHARGE_LIST_ID         = l_n_discharge_id
                            , CONTAINER_SEQ_NO             = CASE WHEN(l_v_record_status = 'S') THEN l_v_cont_seq ELSE CONTAINER_SEQ_NO END
                            , FK_BOOKING_NO                = l_cur_detail_rec.FK_BOOKING_NO
                            , FK_BKG_SIZE_TYPE_DTL         = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                            , FK_BKG_SUPPLIER              = l_cur_detail_rec.FK_BKG_SUPPLIER
                            , FK_BKG_EQUIPM_DTL            = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                            , FK_BKG_VOYAGE_ROUTING_DTL    = l_cur_voyage_rec.VOYAGE_SEQNO
                            , DN_EQ_SIZE                   = l_cur_detail_rec.DN_EQ_SIZE
                            , DN_EQ_TYPE                   = l_cur_detail_rec.DN_EQ_TYPE
                            , DN_FULL_MT                   = l_cur_detail_rec.DN_FULL_MT
                            , DN_BKG_TYP                   = l_cur_detail_rec.DN_BKG_TYP
                            , DN_SOC_COC                   = l_cur_detail_rec.DN_SOC_COC
                            , DN_SHIPMENT_TERM             = l_cur_detail_rec.DN_SHIPMENT_TERM
                            , DN_SHIPMENT_TYP              = l_cur_detail_rec.DN_SHIPMENT_TYP
                            , LOCAL_STATUS                 = l_v_local_status
                            , LOCAL_TERMINAL_STATUS       = (CASE  WHEN l_v_local_status = 'L'THEN 'Local' WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END) -- *9
                            --, DISCHARGE_STATUS             = l_v_status
                            , DISCHARGE_STATUS             = DECODE(DISCHARGE_STATUS, 'DI', DISCHARGE_STATUS, l_v_status) -- *13
                            , LOAD_CONDITION               = l_cur_detail_rec.LOAD_CONDITION -- *11
                            , DN_LOADING_STATUS            = l_v_load_status
                            , CONTAINER_GROSS_WEIGHT       = NVL(l_v_weight, l_cur_detail_rec.CONTAINER_GROSS_WEIGHT) -- added, 30.01.2012
                            , STOWAGE_POSITION             = NVL(l_v_stow_pos_rob, STOWAGE_POSITION) -- added, 30.01.2012
                            , VOID_SLOT                    = l_cur_detail_rec.VOID_SLOT
                            , FK_SLOT_OPERATOR             = l_cur_detail_rec.FK_SLOT_OPERATOR
                            --, FK_CONTAINER_OPERATOR        = l_cur_detail_rec.FK_CONTAINER_OPERATOR
                            --, OUT_SLOT_OPERATOR            = l_v_out_slot_op_code
                            , DN_SPECIAL_HNDL              = l_cur_detail_rec.DN_SPECIAL_HNDL
                            , DN_POL                       = l_cur_voyage_rec.LOAD_PORT
                            , DN_POL_TERMINAL              = l_cur_voyage_rec.FROM_TERMINAL
                            , DN_NXT_POD1                  = l_v_next_pod1
                            , DN_NXT_POD2                  = l_v_next_pod2
                            , DN_NXT_POD3                  = l_v_next_pod3
                            , DN_FINAL_POD                 = l_cur_detail_rec.DN_FINAL_POD
                            , FINAL_DEST                   = l_cur_detail_rec.FINAL_DEST
                            , DN_NXT_SRV                   = l_v_next_service
                            , DN_NXT_VESSEL                = l_v_next_vessel
                            , DN_NXT_VOYAGE                = l_v_next_voyno
                            , DN_NXT_DIR                   = l_v_next_dir
                            --, FK_HANDLING_INSTRUCTION_1    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_1
                            --, FK_HANDLING_INSTRUCTION_2    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_2
                            --, FK_HANDLING_INSTRUCTION_3    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_3
                            --, CONTAINER_LOADING_REM_1      = l_cur_detail_rec.CONTAINER_LOADING_REM_1
                            --, CONTAINER_LOADING_REM_2      = l_cur_detail_rec.CONTAINER_LOADING_REM_2
                            --, FK_SPECIAL_CARGO             = l_cur_detail_rec.FK_SPECIAL_CARGO
                            --, FK_IMDG                      = l_v_imo_class
                            --, FK_UNNO                      = l_v_un_no
                            --, FK_UN_VAR                    = l_v_variant
                            --, FK_PORT_CLASS                = l_v_portclass
                            --, FK_PORT_CLASS_TYP            = l_cur_detail_rec.FK_PORT_CLASS_TYP
                            , FK_IMDG                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_imo_class)
                            , FK_UNNO                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_un_no)
                            , FK_UN_VAR                      = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_variant)
                            , FK_PORT_CLASS                  = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_v_portclass)
                            , FK_PORT_CLASS_TYP              = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', l_cur_detail_rec.FK_PORT_CLASS_TYP)
                            , FLASH_UNIT                   = l_v_hz_bs
                             , FLASH_POINT                  = l_cur_detail_rec.FLASH_POINT
                            , FUMIGATION_ONLY              = l_cur_detail_rec.FUMIGATION_ONLY
                            , RESIDUE_ONLY_FLAG            = l_cur_detail_rec.RESIDUE_ONLY_FLAG
                            , OVERWIDTH_LEFT_CM            = l_cur_detail_rec.OVERHEIGHT_CM
                            , OVERWIDTH_RIGHT_CM           = l_cur_detail_rec.OVERWIDTH_RIGHT_CM
                            , OVERLENGTH_FRONT_CM          = l_cur_detail_rec.OVERLENGTH_FRONT_CM
                            , OVERLENGTH_REAR_CM           = l_cur_detail_rec.OVERLENGTH_REAR_CM
                            , REEFER_TEMPERATURE           = l_cur_detail_rec.REEFER_TMP
                            , REEFER_TMP_UNIT              = l_cur_detail_rec.REEFER_TMP_UNIT
                            , DN_HUMIDITY                  = l_cur_detail_rec.HUMIDITY
                            , DN_VENTILATION               = l_cur_detail_rec.DN_VENTILATION
                            , RECORD_CHANGE_USER           = g_v_user
                            , RECORD_CHANGE_DATE           = l_d_time
                            , ACTIVITY_DATE_TIME           = L_V_ETA_DATE /* *20 */
                            ,CATEGORY_CODE               =  NVL(V_VGM_CATEGORY,l_cur_detail_rec.VGM_CATEGORY) --*30
                            , VGM       = NVL(V_VGM, l_cur_detail_rec.VGM) --*31
                        WHERE   DN_EQUIPMENT_NO              = l_cur_detail_rec.DN_EQUIPMENT_NO
                               AND     RECORD_STATUS                = 'S'
                          --  AND    (RECORD_STATUS    = 'S' OR FK_DISCHARGE_LIST_ID = l_n_discharge_id)  -- *29
                            -- AND    (FK_DISCHARGE_LIST_ID = l_n_discharge_id)  -- *29
                           AND     PK_BOOKED_DISCHARGE_ID       = l_n_list_upd_id;
                                  g_v_sql_id := 'SQL-04043';
                                l_n_insert:=1;


                       END IF;
                       Else
                       /*
                         *29 -- *29
                            End
                      */

                        UPDATE TOS_DL_BOOKED_DISCHARGE
                        SET    RECORD_STATUS                = 'A'
                            , FK_DISCHARGE_LIST_ID         = l_n_discharge_id
                            , CONTAINER_SEQ_NO             = CASE WHEN(l_v_record_status = 'S') THEN l_v_cont_seq ELSE CONTAINER_SEQ_NO END
                            , FK_BOOKING_NO                = l_cur_detail_rec.FK_BOOKING_NO
                            , FK_BKG_SIZE_TYPE_DTL         = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                            , FK_BKG_SUPPLIER              = l_cur_detail_rec.FK_BKG_SUPPLIER
                            , FK_BKG_EQUIPM_DTL            = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                            , FK_BKG_VOYAGE_ROUTING_DTL    = l_cur_voyage_rec.VOYAGE_SEQNO
                            , DN_EQ_SIZE                   = l_cur_detail_rec.DN_EQ_SIZE
                            , DN_EQ_TYPE                   = l_cur_detail_rec.DN_EQ_TYPE
                            , DN_FULL_MT                   = l_cur_detail_rec.DN_FULL_MT
                            , DN_BKG_TYP                   = l_cur_detail_rec.DN_BKG_TYP
                            , DN_SOC_COC                   = l_cur_detail_rec.DN_SOC_COC
                            , DN_SHIPMENT_TERM             = l_cur_detail_rec.DN_SHIPMENT_TERM
                            , DN_SHIPMENT_TYP              = l_cur_detail_rec.DN_SHIPMENT_TYP
                            , LOCAL_STATUS                 = l_v_local_status
                            , LOCAL_TERMINAL_STATUS       = (CASE  WHEN l_v_local_status = 'L'THEN 'Local' WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END) -- *9
                            --, DISCHARGE_STATUS             = l_v_status
                            , DISCHARGE_STATUS             = DECODE(DISCHARGE_STATUS, 'DI', DISCHARGE_STATUS, l_v_status) -- *13
                            , LOAD_CONDITION               = l_cur_detail_rec.LOAD_CONDITION -- *11
                            , DN_LOADING_STATUS            = l_v_load_status
                            , CONTAINER_GROSS_WEIGHT       = NVL(l_v_weight, l_cur_detail_rec.CONTAINER_GROSS_WEIGHT) -- added, 30.01.2012
                            , STOWAGE_POSITION             = NVL(l_v_stow_pos_rob, STOWAGE_POSITION) -- added, 30.01.2012
                            , VOID_SLOT                    = l_cur_detail_rec.VOID_SLOT
                            , FK_SLOT_OPERATOR             = l_cur_detail_rec.FK_SLOT_OPERATOR
                            --, FK_CONTAINER_OPERATOR        = l_cur_detail_rec.FK_CONTAINER_OPERATOR
                            --, OUT_SLOT_OPERATOR            = l_v_out_slot_op_code
                            , DN_SPECIAL_HNDL              = l_cur_detail_rec.DN_SPECIAL_HNDL
                            , DN_POL                       = l_cur_voyage_rec.LOAD_PORT
                            , DN_POL_TERMINAL              = l_cur_voyage_rec.FROM_TERMINAL
                            , DN_NXT_POD1                  = l_v_next_pod1
                            , DN_NXT_POD2                  = l_v_next_pod2
                            , DN_NXT_POD3                  = l_v_next_pod3
                            , DN_FINAL_POD                 = l_cur_detail_rec.DN_FINAL_POD
                            , FINAL_DEST                   = l_cur_detail_rec.FINAL_DEST
                            , DN_NXT_SRV                   = l_v_next_service
                            , DN_NXT_VESSEL                = l_v_next_vessel
                            , DN_NXT_VOYAGE                = l_v_next_voyno
                            , DN_NXT_DIR                   = l_v_next_dir
                            --, FK_HANDLING_INSTRUCTION_1    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_1
                            --, FK_HANDLING_INSTRUCTION_2    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_2
                            --, FK_HANDLING_INSTRUCTION_3    = l_cur_detail_rec.FK_HANDLING_INSTRUCTION_3
                            --, CONTAINER_LOADING_REM_1      = l_cur_detail_rec.CONTAINER_LOADING_REM_1
                            --, CONTAINER_LOADING_REM_2      = l_cur_detail_rec.CONTAINER_LOADING_REM_2
                            --, FK_SPECIAL_CARGO             = l_cur_detail_rec.FK_SPECIAL_CARGO
                            --, FK_IMDG                      = l_v_imo_class
                            --, FK_UNNO                      = l_v_un_no
                            --, FK_UN_VAR                    = l_v_variant
                            --, FK_PORT_CLASS                = l_v_portclass
                            --, FK_PORT_CLASS_TYP            = l_cur_detail_rec.FK_PORT_CLASS_TYP
                            , FK_IMDG                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_IMDG) -- *4
                            , FK_UNNO                        = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_UNNO) -- *4
                            , FK_UN_VAR                      = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_UN_VAR) -- *4
                            , FK_PORT_CLASS                  = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_PORT_CLASS) -- *4
                            , FK_PORT_CLASS_TYP              = DECODE(l_cur_detail_rec.DN_SPECIAL_HNDL, 'N', '', FK_PORT_CLASS_TYP) -- *4
                            --, FLASH_UNIT                   = l_v_hz_bs
                            --, FLASH_POINT                  = l_cur_detail_rec.FLASH_POINT
                            --, FUMIGATION_ONLY              = l_cur_detail_rec.FUMIGATION_ONLY
                            --, RESIDUE_ONLY_FLAG            = l_cur_detail_rec.RESIDUE_ONLY_FLAG
                            --, OVERWIDTH_LEFT_CM            = l_cur_detail_rec.OVERHEIGHT_CM
                            --, OVERWIDTH_RIGHT_CM           = l_cur_detail_rec.OVERWIDTH_RIGHT_CM
                            --, OVERLENGTH_FRONT_CM          = l_cur_detail_rec.OVERLENGTH_FRONT_CM
                            --, OVERLENGTH_REAR_CM           = l_cur_detail_rec.OVERLENGTH_REAR_CM
                            --, REEFER_TEMPERATURE           = l_cur_detail_rec.REEFER_TMP
                            --, REEFER_TMP_UNIT              = l_cur_detail_rec.REEFER_TMP_UNIT
                            --, DN_HUMIDITY                  = l_cur_detail_rec.HUMIDITY
                            --, DN_VENTILATION               = l_cur_detail_rec.DN_VENTILATION
                            , RECORD_CHANGE_USER           = g_v_user
                            , RECORD_CHANGE_DATE           = l_d_time
                            , ACTIVITY_DATE_TIME           = L_V_ETA_DATE /* *20 */
                            ,CATEGORY_CODE               =  NVL(V_VGM_CATEGORY,l_cur_detail_rec.VGM_CATEGORY) --*30
                            ,VGM                          = NVL(V_VGM, l_cur_detail_rec.VGM) --*31
                        WHERE   DN_EQUIPMENT_NO              = l_cur_detail_rec.DN_EQUIPMENT_NO
                        -- AND     RECORD_STATUS                = 'S'
                          --  AND    (RECORD_STATUS    = 'S' OR FK_DISCHARGE_LIST_ID = l_n_discharge_id)  -- *29
                           AND    (FK_DISCHARGE_LIST_ID = l_n_discharge_id)  -- *29

                    AND     PK_BOOKED_DISCHARGE_ID       = l_n_list_upd_id;

                        g_v_sql_id := 'SQL-04043';
                        l_n_insert:=1;
                      End if; --*29
                    END IF;
                END IF;

                g_v_sql_id := 'SQL-04044';
                IF l_n_insert=0 THEN

                    g_v_sql_id := 'SQL-04045';

                    SELECT NVL(MAX(CONTAINER_SEQ_NO),0)
                    INTO l_v_cont_seq
                    FROM TOS_DL_BOOKED_DISCHARGE
                    WHERE FK_DISCHARGE_LIST_ID = l_n_discharge_id;

                    l_v_cont_seq :=l_v_cont_seq +1;
                    /* Start changes by vikas as K'chatgamol say, because it is to confusing,
                    to check the existing record using update query, 17.11.2011 */

                    /*
                        UPDATE TOS_DL_BOOKED_DISCHARGE
                        SET FK_BOOKING_NO=l_cur_detail_rec.FK_BOOKING_NO
                        WHERE FK_DISCHARGE_LIST_ID    = l_n_discharge_id
                                AND FK_BOOKING_NO           = l_cur_detail_rec.FK_BOOKING_NO
                                AND FK_BKG_SIZE_TYPE_DTL    = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                                AND FK_BKG_SUPPLIER         = l_cur_detail_rec.FK_BKG_SUPPLIER
                                AND FK_BKG_EQUIPM_DTL       = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                AND FK_BKG_VOYAGE_ROUTING_DTL = l_cur_voyage_rec.VOYAGE_SEQNO
                                AND RECORD_STATUS = 'A';
                    */

                    g_v_sql_id := 'SQL-04046';

                    IF(l_cur_detail_rec.DN_EQUIPMENT_NO IS NOT NULL ) THEN

                        g_v_sql_id := 'SQL-04047';

                        /* Check record on the basis of equipment#*/
                        SELECT COUNT(1)
                        INTO  l_v_rec_count
                        FROM  TOS_DL_BOOKED_DISCHARGE
                        WHERE FK_DISCHARGE_LIST_ID      = l_n_discharge_id
                        AND   FK_BOOKING_NO             = l_cur_detail_rec.FK_BOOKING_NO
                        AND   FK_BKG_SIZE_TYPE_DTL      = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                        AND   FK_BKG_SUPPLIER           = l_cur_detail_rec.FK_BKG_SUPPLIER
                        AND   DN_EQUIPMENT_NO           = l_cur_detail_rec.DN_EQUIPMENT_NO
                        AND   FK_BKG_VOYAGE_ROUTING_DTL = l_cur_voyage_rec.VOYAGE_SEQNO
                        AND   RECORD_STATUS             = 'A';
                    ELSE

                        g_v_sql_id := 'SQL-04048';

                        /* Check record on the basis of equipment sequence no# */
                        SELECT COUNT(1)
                        INTO  l_v_rec_count
                        FROM  TOS_DL_BOOKED_DISCHARGE
                        WHERE FK_DISCHARGE_LIST_ID      = l_n_discharge_id
                        AND   FK_BOOKING_NO             = l_cur_detail_rec.FK_BOOKING_NO
                        AND   FK_BKG_SIZE_TYPE_DTL      = l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL
                        AND   FK_BKG_SUPPLIER           = l_cur_detail_rec.FK_BKG_SUPPLIER
                        AND   FK_BKG_EQUIPM_DTL         = l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                        AND   FK_BKG_VOYAGE_ROUTING_DTL = l_cur_voyage_rec.VOYAGE_SEQNO
                        AND   RECORD_STATUS             = 'A';

                    END IF;

                    /*IF SQL%ROWCOUNT = 0 THEN */

                    g_v_sql_id := 'SQL-04049';

                    IF l_v_rec_count = 0 THEN

                        g_v_sql_id := 'SQL-04050';

                    /* End changes by vikas 17.11.2011 */

                        IF p_i_n_equipment_seq_no IS NOT NULL AND
                            p_i_n_size_type_seq_no IS NOT NULL AND
                            p_i_n_supplier_seq_no  IS NOT NULL
                        THEN

                            g_v_sql_id := 'SQL-04051';

                            BEGIN
                                SELECT DISCHARGE_LIST_STATUS
                                INTO   l_n_discharge_list_status
                                FROM   TOS_DL_DISCHARGE_LIST
                                WHERE  PK_DISCHARGE_LIST_ID = l_n_discharge_id;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    l_n_discharge_list_status := 0;

                                    /* g_v_record_filter := 'PK_DISCHARGE_LIST_ID:'|| l_n_discharge_id  ;
                                    g_v_record_table  := 'Discharge List Status Not found in TOS_DL_DISCHARGE_LIST' ; */

                                /*
                                    Block started by vikas to log error msg properly, 10.02.2012
                                */
                                WHEN OTHERS THEN
                                    l_n_discharge_list_status := 0;
                                    /* g_v_record_filter := 'PK_DISCHARGE_LIST_ID:'|| l_n_discharge_id  ;
                                    g_v_record_table  := 'Discharge List Status Not found in TOS_DL_DISCHARGE_LIST' ; */
                                /*
                                    Block ended by vikas to log error msg properly, 10.02.2012
                                */

                            END;

                            g_v_sql_id := 'SQL-04052';

                            IF l_n_discharge_list_status != 0 THEN

                                g_v_sql_id := 'SQL-04053';

                                /* * *23 start * */
                                PRE_GET_LIST_STATUS (
                                    L_N_DISCHARGE_ID,
                                    DISCHARGE_LIST,
                                    L_V_LIST_STATUS
                                );

                                g_v_sql_id := 'SQLa04053';

                                /* * *23 end * */
                                IF ((L_V_LIST_STATUS = DISCHARGE_COMPLETE) OR
                                    (L_V_LIST_STATUS = READY_FOR_INVOICE) OR
                                    (L_V_LIST_STATUS = WORK_COMPLETE)) THEN  -- *23

                                    g_v_sql_id := 'SQLb04053';
                                    BEGIN
                                            PCE_ECM_RAISE_ENOTICE.PRE_DL_WRK_SRT_SYNC (
                                                l_n_discharge_id
                                                , p_i_n_equipment_seq_no
                                                , p_i_v_booking_no
                                                , g_n_bussiness_key_sync_dws_add
                                                , g_v_user
                                                , TO_CHAR(l_d_time,'YYYYMMDDHH24MISS')
                                                , p_o_v_error
                                            );
                                            --g_v_sql_id := 'SQL-04054';
                                            --
                                            --PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                                            --    l_n_discharge_id
                                            --    , p_i_n_equipment_seq_no
                                            --    , p_i_v_booking_no
                                            --    , g_n_bussiness_key_sync_cch_add
                                            --    , null -- Old Equipment No.
                                            --    , null -- New Equipment No.
                                            --    , 'A'
                                            --    , g_v_user
                                            --    , TO_CHAR(l_d_time,'YYYYMMDDHH24MISS')
                                            --    , p_o_v_error
                                            --);
                                    EXCEPTION
                                        WHEN OTHERS THEN
                                            PRE_TOS_SYNC_ERROR_LOG(
                                                'EXCETION in calling mail '
                                                    ||'~'|| l_n_discharge_id
                                                    ||'~'|| g_v_sql_id
                                                    ||'~'|| p_i_n_equipment_seq_no
                                                    ||'~'|| p_i_v_booking_no,
                                                'SYNC',
                                                'D',
                                                'SYNC',
                                                'A',
                                                g_v_user,
                                                SYSDATE,
                                                g_v_user,
                                                SYSDATE
                                            );
                                    END ;
                                END IF; -- *23

                            END IF;

                            /* *24 start * */
                            BEGIN
                                g_v_sql_id := 'SQL-04054';
                                /* * check if mail is already send for this vessel voyage then
                                    no need to send mail * */
                                IF IS_ALREADY_SEND = FALSE THEN
                                            PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                                                l_n_discharge_id
                                                , p_i_n_equipment_seq_no
                                                , p_i_v_booking_no
                                                , g_n_bussiness_key_sync_cch_add
                                                , null -- Old Equipment No.
                                                , null -- New Equipment No.
                                                , 'A'
                                                , g_v_user
                                                , TO_CHAR(l_d_time,'YYYYMMDDHH24MISS')
                                                , p_o_v_error
                                            );
                                END IF;
                                    EXCEPTION
                                        WHEN OTHERS THEN
                                            PRE_TOS_SYNC_ERROR_LOG(
                                                'EXCETION in calling mail '
                                                    ||'~'|| l_n_discharge_id
                                                    ||'~'|| g_v_sql_id
                                            ||'~'|| l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                                            ||'~'|| l_cur_detail_rec.FK_BOOKING_NO,
                                                'SYNC',
                                                'D',
                                                'SYNC',
                                                'A',
                                                g_v_user,
                                                SYSDATE,
                                                g_v_user,
                                                SYSDATE
                                            );
                                    END ;
                            /* *24 end  * */

                            END IF;


                        g_v_sql_id := 'SQL-04055';

                        /* Start Added by vikas, check booking# again and if exist then delete from the
                        ezll table, K'Chatgamol, 16.11.2011 */
                        BEGIN
                            IF l_cur_detail_rec.DN_EQUIPMENT_NO IS NOT NULL THEN

                            g_v_sql_id := 'SQL-04056';

                                /* Get port and terminal */
                                SELECT DN_PORT, DN_TERMINAL
                                INTO l_v_dn_port, l_v_dn_terminal
                                FROM TOS_DL_DISCHARGE_LIST
                                WHERE PK_DISCHARGE_LIST_ID  = l_n_discharge_id;

                            /* Delete the duplicate container from booking detail table */
                            /*   DELETE FROM TOS_DL_BOOKED_DISCHARGE
                            WHERE PK_BOOKED_DISCHARGE_ID IN (
                                SELECT BL.PK_BOOKED_DISCHARGE_ID
                                FROM TOS_DL_BOOKED_DISCHARGE BL ,
                                    TOS_DL_DISCHARGE_LIST DL
                                WHERE BL.FK_BOOKING_NO      = l_cur_detail_rec.FK_BOOKING_NO
                                AND BL.DN_EQUIPMENT_NO      = l_cur_detail_rec.DN_EQUIPMENT_NO
                                AND DL.RECORD_STATUS        = 'A'
                                AND BL.RECORD_STATUS        = 'A'
                                AND DL.DN_PORT              = l_v_dn_port
                                AND DL.DN_TERMINAL          = l_v_dn_terminal
                                AND BL.FK_DISCHARGE_LIST_ID = DL.PK_DISCHARGE_LIST_ID);
                            */ --Leena 17.01.2012 to comment duplicate record deletion for DL
                            /*
                                Start Added by vikas to log the deleted records, 30.11.2011
                            *
                            IF SQL%ROWCOUNT >= 1 THEN
                                PRE_TOS_SYNC_ERROR_LOG(
                                    'DISCHARGE~' || l_cur_detail_rec.FK_BOOKING_NO||'~'||
                                        l_cur_detail_rec.DN_EQUIPMENT_NO ||'~'||
                                        l_v_dn_port ||'~'||
                                        l_v_dn_terminal
                                    , 'SYNC'
                                    , 'D'
                                    , 'Delete duplicate booking from discharge list'
                                    , 'A'
                                    , g_v_user
                                    , CURRENT_TIMESTAMP
                                    , g_v_user
                                    , CURRENT_TIMESTAMP
                                );
                            END IF;
                            *
                                End Added by vikas to log the deleted records, 30.11.2011
                            */

                            END IF;
                        EXCEPTION
                            WHEN OTHERS THEN
                            NULL;
                        END;

                        /* End added by vikas, 16.11.2011*/

                        /*
                            Block added by vikas, to improve logging, 01.02.2012
                        */

                        g_v_sql_id := 'SQL-04057';

                        SELECT SE_BLZ01.nextval
                        INTO
                            l_v_pk_booked_discharge_id
                        FROM DUAL;
                        /*
                            Block Ended by vikas, 01.02.2012
                        */


                        /*
                            *10: start
                        */

                        g_v_sql_id := 'SQL-04058';

                        BEGIN
                            l_v_crane_type := NULL;
                            -- VASAPPS.PKG_TOS_RCL.PRC_TOS_GET_DEFAULT_CRANE( -- *18
                            VASAPPS.PKG_TOS_RCL_EZLL.PRC_TOS_GET_DEFAULT_CRANE( -- *18
                                l_v_crane_type
                                , l_cur_voyage_rec.DISCHARGE_PORT
                                , l_cur_voyage_rec.TO_TERMINAL
                            );
                        EXCEPTION
                            WHEN OTHERS THEN
                                NULL;
                        END;

                        g_v_sql_id := 'SQL-04059';

                        /*
                            *10: End
                        */

                        BEGIN
                            /*
                                *13: start
                            */

                            g_v_sql_id := 'SQL-04060';
                            PRE_GET_LL_DL_STATUS (
                                l_n_discharge_id,
                                -- null, -- *25
                                l_cur_detail_rec.DN_EQUIPMENT_NO, -- *25
                                'DL',
                                l_v_status
                            );
                            /*
                                *13: end
                            */

                            g_v_sql_id := 'SQL-04061';

                            INSERT INTO TOS_DL_BOOKED_DISCHARGE
                                (
                                PK_BOOKED_DISCHARGE_ID,FK_DISCHARGE_LIST_ID,CONTAINER_SEQ_NO,FK_BOOKING_NO,
                                FK_BKG_SIZE_TYPE_DTL,FK_BKG_SUPPLIER,FK_BKG_EQUIPM_DTL,DN_EQUIPMENT_NO,
                                FK_BKG_VOYAGE_ROUTING_DTL,DN_EQ_SIZE,DN_EQ_TYPE,
                                DN_FULL_MT,DN_BKG_TYP,DN_SOC_COC,DN_SHIPMENT_TERM,DN_SHIPMENT_TYP,LOCAL_STATUS,
                                DISCHARGE_STATUS,LOAD_CONDITION,DN_LOADING_STATUS,CONTAINER_GROSS_WEIGHT,
                                VOID_SLOT,FK_SLOT_OPERATOR, FK_CONTAINER_OPERATOR,OUT_SLOT_OPERATOR,
                                DN_SPECIAL_HNDL,DN_POL,DN_POL_TERMINAL,DN_NXT_POD1,DN_NXT_POD2,DN_NXT_POD3,
                                DN_FINAL_POD,FINAL_DEST,DN_NXT_SRV,DN_NXT_VESSEL,DN_NXT_VOYAGE,DN_NXT_DIR,
                                FK_HANDLING_INSTRUCTION_1,FK_HANDLING_INSTRUCTION_2,
                                FK_HANDLING_INSTRUCTION_3,CONTAINER_LOADING_REM_1,CONTAINER_LOADING_REM_2,
                                FK_SPECIAL_CARGO,FK_IMDG,FK_UNNO,FK_UN_VAR,FK_PORT_CLASS,FK_PORT_CLASS_TYP,
                                FLASH_UNIT,FLASH_POINT,FUMIGATION_ONLY,RESIDUE_ONLY_FLAG,OVERHEIGHT_CM,
                                OVERWIDTH_LEFT_CM,OVERWIDTH_RIGHT_CM,OVERLENGTH_FRONT_CM,OVERLENGTH_REAR_CM,
                                REEFER_TEMPERATURE,REEFER_TMP_UNIT,DN_HUMIDITY,DN_VENTILATION,STOWAGE_POSITION,
                                RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE
                                , LOCAL_TERMINAL_STATUS --ADDED ON 29/04/2011.
                                , CRANE_TYPE  -- *10
                                , ACTIVITY_DATE_TIME  /* *20 */
                                , CATEGORY_CODE --*30
                                , VGM --*31
                                )
                            VALUES
                                (
                                        l_v_pk_booked_discharge_id,l_n_discharge_id ,l_v_cont_seq,l_cur_detail_rec.FK_BOOKING_NO,
                                    l_cur_detail_rec.FK_BKG_SIZE_TYPE_DTL,l_cur_detail_rec.FK_BKG_SUPPLIER,
                                    l_cur_detail_rec.FK_BKG_EQUIPM_DTL,l_cur_detail_rec.DN_EQUIPMENT_NO,
                                    l_cur_voyage_rec.VOYAGE_SEQNO ,
                                    l_cur_detail_rec.DN_EQ_SIZE,l_cur_detail_rec.DN_EQ_TYPE,
                                    l_cur_detail_rec.DN_FULL_MT,l_cur_detail_rec.DN_BKG_TYP,
                                    l_cur_detail_rec.DN_SOC_COC,l_cur_detail_rec.DN_SHIPMENT_TERM,
                                    l_cur_detail_rec.DN_SHIPMENT_TYP,l_v_local_status,
                                    -- l_v_status, --*13
                                    NVL2(l_v_stow_pos_rob, l_v_status, 'BK'), --*13
                                    l_cur_detail_rec.LOAD_CONDITION,l_v_load_status,
                                    -- l_cur_detail_rec.CONTAINER_GROSS_WEIGHT,
                                    NVL(l_v_weight, l_cur_detail_rec.CONTAINER_GROSS_WEIGHT), -- added, 30.01.2012
                                    l_cur_detail_rec.VOID_SLOT,l_cur_detail_rec.FK_SLOT_OPERATOR,l_cur_detail_rec.FK_CONTAINER_OPERATOR,
                                    l_v_out_slot_op_code,l_cur_detail_rec.DN_SPECIAL_HNDL,
                                    l_cur_voyage_rec.LOAD_PORT,l_cur_voyage_rec.FROM_TERMINAL,
                                    l_v_next_pod1,l_v_next_pod2,l_v_next_pod3,l_cur_detail_rec.DN_FINAL_POD,
                                    l_cur_detail_rec.FINAL_DEST,l_v_next_service ,l_v_next_vessel,
                                    l_v_next_voyno,l_v_next_dir,l_cur_detail_rec.FK_HANDLING_INSTRUCTION_1,
                                    l_cur_detail_rec.FK_HANDLING_INSTRUCTION_2,
                                    l_cur_detail_rec.FK_HANDLING_INSTRUCTION_3,
                                    l_cur_detail_rec.CONTAINER_LOADING_REM_1,
                                    l_cur_detail_rec.CONTAINER_LOADING_REM_2,l_cur_detail_rec.FK_SPECIAL_CARGO,
                                    --l_v_imo_class,l_v_un_no,
                                    --l_v_variant,l_v_portclass,l_v_portclasstype, l_v_hz_bs ,
                                    l_cur_detail_rec.FK_IMDG,l_cur_detail_rec.FK_UNNO,l_cur_detail_rec.FK_UN_VAR,
                                    l_cur_detail_rec.FK_PORT_CLASS,l_cur_detail_rec.FK_PORT_CLASS_TYP,
                                    l_cur_detail_rec.FLASH_UNIT,
                                    l_cur_detail_rec.FLASH_POINT,
                                    l_cur_detail_rec.FUMIGATION_ONLY,
                                    l_cur_detail_rec.RESIDUE_ONLY_FLAG,
                                    l_cur_detail_rec.OVERHEIGHT_CM,
                                    l_cur_detail_rec.OVERWIDTH_LEFT_CM,l_cur_detail_rec.OVERWIDTH_RIGHT_CM,
                                    l_cur_detail_rec.OVERLENGTH_FRONT_CM,l_cur_detail_rec.OVERLENGTH_REAR_CM,
                                    l_cur_detail_rec.REEFER_TMP,l_cur_detail_rec.REEFER_TMP_UNIT,
                                    l_cur_detail_rec.HUMIDITY,l_cur_detail_rec.DN_VENTILATION,l_v_stow_pos_rob,
                                    'A',g_v_user,l_d_time,g_v_user,l_d_time ,
                                    ( CASE  WHEN l_v_local_status = 'L' THEN 'Local'  WHEN l_v_local_status = 'T' THEN 'TS' ELSE NULL END) --ADDED ON 29/04/2011.
                                    , L_V_CRANE_TYPE -- *10
                                    , L_V_ETA_DATE /* *20 */
                                    ,NVL(V_VGM_CATEGORY,l_cur_detail_rec.VGM_CATEGORY) --*30
                                    , NVL(V_VGM, l_cur_detail_rec.VGM) --*31
                            ) ;

                            /*
                                Begin block added by vikas to improve logging, 01.02.2012
                            */
                        EXCEPTION
                            WHEN OTHERS THEN
                                g_v_err_desc := SQLERRM;
                                PRE_TOS_SYNC_ERROR_LOG(
                                    'EXCETION IN DL BOOKED DETAILS INSERT '||'~'||l_n_load_id
                                        ||'~'||g_v_err_desc
                                        ||'~'||l_cur_detail_rec.DN_EQUIPMENT_NO
                                        ||'~'||l_v_pk_booked_discharge_id,
                                    'SYNC',
                                    'D',
                                    'SYNC',
                                    'A',
                                    g_v_user,
                                    SYSDATE,
                                    g_v_user,
                                    SYSDATE
                                );
                                g_v_err_desc := null;
                        END;
                        /*
                            Begin block end added by vikas to improve logging, 01.02.2012
                        */
                    END IF;--END OF ROWCOUNT
                    g_v_sql_id := 'SQL-04062';

                END IF;
                g_v_sql_id := 'SQL-04063';

            END LOOP;-- end of
            --Update Discharge List Status count
            /* * mail is already send for this vessel voyage * */
            IS_ALREADY_SEND := TRUE; -- *24

            g_v_sql_id := 'SQL-04064';

            PRE_TOS_STATUS_COUNT(l_n_discharge_id,'D',p_o_v_return_status);

            IF p_o_v_return_status = '1' THEN
                g_v_sql_id := 'SQL-04065';

                /*
                    Block added by vikas, to log error,  06.02.2012
                */
                    g_v_err_code := TO_CHAR (SQLCODE);
                    g_v_err_desc := SUBSTR(SQLERRM,1,100);
                    g_v_record_filter := 'Discharge List id :'|| l_n_discharge_id  ;
                    g_v_record_table  := 'Error in updating status count in header table' ;
                /*
                    Block Ended by vikas, to log error,  06.02.2012
                */
                RAISE l_exc_user;
            END IF;

            g_v_sql_id := 'SQL-04066';

            l_n_discharge_id:=null;
            l_v_check_listid :='Y';
            l_n_check :=0;
            l_n_insert :=0;
            g_v_sql_id := 'SQL-04067';

        END LOOP;

        g_v_sql_id := 'SQL-04068';
        l_v_next_pod1:=null;
        l_v_next_pod2:=null;
        l_v_next_pod3:=null;
        p_o_v_return_status:='0';
        l_v_check_listid :='Y';
        l_n_check :=0;
        l_n_insert :=0;

        g_v_sql_id := 'SQL-04069';

    EXCEPTION
        WHEN l_exc_user THEN
            p_o_v_return_status := '1';
            ROLLBACK;
            /*
                Block Added by vikas to log error, 06.02.2012
            */
            PRE_TOS_SYNC_ERROR_LOG('Create Discharge List Exception~'
                || l_v_parameter_string,
                'EZLL',
                'A',
                g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc,
                'A',
                g_v_user,
                SYSDATE,
                g_v_user,
                SYSDATE,
                g_v_record_filter,
                g_v_record_table
            );
            /*
                * old logic *
                g_v_err_code := TO_CHAR (SQLCODE);
                g_v_err_desc := SUBSTR(SQLERRM,1,100);

                Block end by vikas, 06.02.2012
            */

    WHEN OTHERS THEN
        p_o_v_return_status := '1';
        ROLLBACK;
        g_v_err_code := TO_CHAR (SQLCODE);
        g_v_err_desc := SUBSTR(SQLERRM,1,100);
        /*
            Block Added by vikas to log error, 06.02.2012
        */
        PRE_TOS_SYNC_ERROR_LOG('Create Discharge List Exception Oracle Exception~'
            || l_v_parameter_string,
            'EZLL',
            'A',
            g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc,
            'A',
            g_v_user,
            SYSDATE,
            g_v_user,
            SYSDATE
        );
        /*
            Block end by vikas, 06.02.2012
        */
    END PRE_TOS_CREATE_DISCHARGE_LIST;


    PROCEDURE PRE_GET_NEXT_POD
    (
      p_i_v_booking_no VARCHAR2,p_i_n_voyno_seq NUMBER,p_o_v_next_pod1 OUT NOCOPY VARCHAR2,
      p_o_v_next_pod2 OUT NOCOPY VARCHAR2,p_o_v_next_pod3 OUT NOCOPY VARCHAR2,p_o_v_next_service OUT NOCOPY VARCHAR2,
      p_o_v_next_vessel OUT NOCOPY VARCHAR2,p_o_v_next_voyno OUT NOCOPY VARCHAR2,p_o_v_next_dir OUT NOCOPY VARCHAR2
    )
    IS
    CURSOR l_cur_fun IS
    SELECT SERVICE, VESSEL, VOYNO, DIRECTION, DISCHARGE_PORT,BOOKING_NO
    FROM   BOOKING_VOYAGE_ROUTING_DTL
    WHERE  BOOKING_NO=p_i_v_booking_no AND ROUTING_TYPE='S' AND VOYAGE_SEQNO >= p_i_n_voyno_seq
   -- AND    VESSEL IS NOT NULL
   -- AND    VOYNO IS NOT NULL
    ORDER BY VOYAGE_SEQNO;
    l_n_count NUMBER:=0;
    l_v_sql_id VARCHAR2(5);
    l_v_errcd      TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
    l_v_errmsg     VARCHAR2(200);
    l_exc_user     EXCEPTION;
    BEGIN

    FOR I IN l_cur_fun LOOP
         l_n_count:= l_n_count+1;
         IF l_n_count=1 THEN
            p_o_v_next_pod1      :=I.DISCHARGE_PORT;
         ELSIF  l_n_count=2 THEN
                p_o_v_next_pod2:=I.DISCHARGE_PORT;
                p_o_v_next_service :=I.SERVICE;
                p_o_v_next_vessel  :=I.VESSEL;
                p_o_v_next_voyno   :=I.VOYNO;
                p_o_v_next_dir     :=I.DIRECTION;
         ELSIF  l_n_count=3 THEN
                p_o_v_next_pod3:=I.DISCHARGE_PORT;
         END IF;
    END LOOP;
               l_n_count:=0;

                 EXCEPTION     WHEN OTHERS THEN
                               p_o_v_next_pod1        :=NULL;
                               p_o_v_next_pod2        :=NULL;
                               p_o_v_next_pod3        :=NULL;
                               p_o_v_next_service :=NULL;
                               p_o_v_next_vessel  :=NULL;
                               p_o_v_next_voyno   :=NULL;
                               p_o_v_next_dir     :=NULL;
    END;

    FUNCTION FE_GET_VOYAGE_NO(p_i_v_service VARCHAR2, p_i_v_vessel VARCHAR2, p_i_v_voyage VARCHAR2,
    p_i_v_direction VARCHAR2, p_i_v_pol_pcsq NUMBER,p_i_v_port_loading VARCHAR2,
    p_i_v_discharge_port VARCHAR2,p_i_v_pod_pcsq VARCHAR2)
    RETURN VARCHAR2
    AS
     p_o_v_VOYAGE_NO_NEW VARCHAR2(200);
     L_V_VVSRVC VARCHAR2(5);
     L_V_VVVESS VARCHAR2(5);
     L_V_VVVOYN VARCHAR2(10);
     L_V_VVSDIR VARCHAR2(2);
     L_N_VVPCSQ VARCHAR2(10);
     L_V_VVPCAL VARCHAR2(5);
     L_N_VVARDT NUMBER;
     L_N_VVARTM NUMBER;
     L_V_INVOYAGENO VARCHAR2(10);
     L_V_DISCHARGE_FLAG VARCHAR2(1):='F';

    CURSOR  INVOYAGENO
    IS
     SELECT VVSRVC,VVVESS,VVVOYN,VVPDIR,VVPCSQ,VVPCAL,VVARDT,VVARTM,INVOYAGENO
     FROM(
          SELECT P.PICODE,P.PIVGMT,PREV_NEXT_VVSRVC,PREV_NEXT_VOYAGE,PREV_NEXT_VESSEL,VVSRVC,VVVESS,VVVOYN,VVPDIR,VVPCSQ,VVPCAL,VVFORL,VVLDDS,VVARDT,VVARTM,VVSLDT,VVSLTM,TURN_PORT_FLAG,
             PREV_NEXT_SEQ,INVOYAGENO,IN_VOYAGE,
             TO_DATE(i.vvardt,'RRRRMMDD')+(1/1440*(MOD(i.vvartm, 100)+FLOOR(i.vvartm/100)*60))-(1/1440*(MOD(p.pivgmt, 100)+FLOOR(p.pivgmt/100)*60)) ARV_DT
          FROM itp063 i,ITP040 P
          WHERE I.VVPCAL= p.picode
            AND vvvers = 99
            AND vvvess = p_i_v_vessel
            AND ((voyage_id = (select distinct voyage_id
                                from itp063
                                where vvvers = 99
                                and vvsrvc = p_i_v_service
                                and vvvess = p_i_v_vessel
                                and vvvoyn =  p_i_v_voyage
                                -- AND VVFORL IS NOT NULL -- *6
                                AND (VVSRVC = 'DFS' OR VVFORL IS NOT NULL)  -- *6
                                )
            AND vvsrvc = p_i_v_service) OR
                 (     voyage_id = (SELECT DISTINCT prev_next_voyage
                                   FROM itp063
                                   where vvvers = 99
                                    AND vvvess    = p_i_v_vessel
                                    and voyage_id = (select distinct voyage_id
                                    from itp063
                                    where vvvers = 99
                                    and vvsrvc = p_i_v_service
                                    and vvvess = p_i_v_vessel
                                    and vvvoyn =  p_i_v_voyage
                                    -- AND VVFORL IS NOT NULL -- *6
                                    AND (VVSRVC = 'DFS' OR VVFORL IS NOT NULL)  -- *6
                                    )

                                    AND vvsrvc    = p_i_v_service
                                    AND vvforl is null
                                    AND vvsrvc = (SELECT DISTINCT prev_next_vvsrvc
                                                    FROM itp063
                                                    WHERE vvvers  = 99
                                                    AND vvvess    = p_i_v_vessel
                                                    and voyage_id = (select distinct voyage_id
                                                    from itp063
                                                    where vvvers = 99
                                                    and vvsrvc = p_i_v_service
                                                    and vvvess = p_i_v_vessel
                                                    and vvvoyn =  p_i_v_voyage
                                                    -- AND VVFORL IS NOT NULL -- *6
                                                    AND (VVSRVC = 'DFS' OR VVFORL IS NOT NULL)  -- *6
                                                    )
                                                    AND vvsrvc    = p_i_v_service
                                                    AND vvforl is null
                                                  )
                                    AND vvpcsq = (SELECT MAX(vvpcsq)
                                                    FROM itp063
                                                    WHERE vvvers  = 99
                                                    AND vvvess    = p_i_v_vessel
                                                    AND voyage_id = (select distinct voyage_id
                                                    from itp063
                                                    where vvvers = 99
                                                    and vvsrvc = p_i_v_service
                                                    and vvvess = p_i_v_vessel
                                                    and vvvoyn =  p_i_v_voyage
                                                    -- AND VVFORL IS NOT NULL -- *6
                                                    AND (VVSRVC = 'DFS' OR VVFORL IS NOT NULL)  -- *6
                                                    )
                                                    AND vvsrvc    = p_i_v_service
                                                  )
                                 )
                 )
                )
         )
     WHERE -- vvforl IS NOT NULL
        (VVSRVC = 'DFS' OR VVFORL IS NOT NULL)  -- *6
     ORDER BY arv_dt,vvldds;

       /*SELECT VVSRVC,VVVESS,VVVOYN,VVSDIR,VVPCSQ,VVPCAL,VVARDT,VVARTM,INVOYAGENO
         FROM(
              SELECT P.PICODE,P.PIVGMT,PREV_NEXT_VVSRVC,PREV_NEXT_VOYAGE,PREV_NEXT_VESSEL,VVSRVC,VVVESS,VVVOYN,VVSDIR,VVPCSQ,VVPCAL,VVFORL,VVLDDS,VVARDT,VVARTM,VVSLDT,VVSLTM,TURN_PORT_FLAG,
                 PREV_NEXT_SEQ,INVOYAGENO,IN_VOYAGE,
                 TO_DATE(i.vvardt,'RRRRMMDD')+(1/1440*(MOD(i.vvartm, 100)+FLOOR(i.vvartm/100)*60))-(1/1440*(MOD(p.pivgmt, 100)+FLOOR(p.pivgmt/100)*60)) ARV_DT
              FROM itp063 i,ITP040 P
              WHERE I.VVPCAL= p.picode
                AND vvvers = 99 AND vvvess = p_i_v_vessel AND ((voyage_id = p_i_v_voyage AND vvsrvc = p_i_v_service)
                OR
                (voyage_id = (SELECT DISTINCT prev_next_voyage FROM itp063 where vvvers = 99 AND vvvess = p_i_v_vessel and voyage_id = p_i_v_voyage AND vvsrvc = p_i_v_service AND vvforl is null
                AND vvsrvc = (SELECT DISTINCT prev_next_vvsrvc FROM itp063 WHERE vvvers = 99 AND vvvess = p_i_v_vessel and voyage_id = p_i_v_voyage AND vvsrvc = p_i_v_service AND vvforl is null)
                AND vvpcsq = (SELECT MAX(vvpcsq) FROM itp063 WHERE vvvers = 99 AND vvvess = p_i_v_vessel AND voyage_id = p_i_v_voyage AND vvsrvc = p_i_v_service))
                 ))
             )
         WHERE vvforl IS NOT NULL
         ORDER BY arv_dt,vvldds;
     */
    BEGIN
       FOR I IN INVOYAGENO LOOP
           L_V_VVSRVC:=I.VVSRVC;
           L_V_VVVESS:=I.VVVESS;
           L_V_VVVOYN:=I.VVVOYN;
           L_V_VVSDIR :=I.VVPDIR;
           L_N_VVPCSQ :=I.VVPCSQ;
           L_V_VVPCAL :=I.VVPCAL;
           L_N_VVARDT :=I.VVARDT;
           L_N_VVARTM :=I.VVARTM;
           L_V_INVOYAGENO:=I.INVOYAGENO;
           --First get the load port record in result provided by above query
           IF L_V_VVSRVC=p_i_v_service AND L_V_VVVESS=p_i_v_vessel AND L_V_VVVOYN=p_i_v_voyage AND L_V_VVSDIR=p_i_v_direction AND L_N_VVPCSQ=p_i_v_pol_pcsq AND L_V_VVPCAL=p_i_v_port_loading THEN
              L_V_DISCHARGE_FLAG :='T';
           END IF;
           --When Load Port record found then check  discharge port record and get the invoyage no.
           IF L_V_DISCHARGE_FLAG ='T' THEN
              IF L_N_VVPCSQ = p_i_v_pod_pcsq AND L_V_VVPCAL = p_i_v_discharge_port THEN
                 p_o_v_VOYAGE_NO_NEW:=L_V_INVOYAGENO;
                 EXIT;
              END IF;
           END IF;
       END LOOP;
     RETURN p_o_v_VOYAGE_NO_NEW;
     END;


     FUNCTION FE_DATE_TIME(p_i_n_date NUMBER,
                           p_i_n_time NUMBER)
     RETURN DATE IS
     l_d_date DATE;
     BEGIN
       BEGIN
           l_d_date:=TO_DATE(p_i_n_date,'RRRRMMDD')+(1/1440*(MOD(p_i_n_date, 100)+
                     FLOOR(p_i_n_time/100)*60))-(1/1440*(MOD(p_i_n_time, 100)));
           RETURN l_d_date;
           EXCEPTION
           WHEN OTHERS THEN
                l_d_date:=NULL;
                RETURN l_d_date;
       END;
     END;


    PROCEDURE PRE_TOS_STATUS_COUNT
    (p_i_n_id     IN   NUMBER,
     p_i_n_flg    IN   VARCHAR2,
     p_o_v_return_status      OUT NOCOPY  VARCHAR2) IS

    /*********************************************************************************
       Name           :  PRE_TOS_STATUS_COUNT
       Module         :
       Purpose        :  To Update data LAOD LIST AND DISCHARGE LIST HEADER TABLES
                         This procedure is called by Screen
       Calls          :
       Returns        :  Null
       Author          Date               What
       ------          ----               ----
       Rajat           20/01/2010        INITIAL VERSION
    ***********************************************************************************/
       l_n_cnt_bk                  NUMBER;
       l_n_cnt_lo                  NUMBER;
       l_n_cnt_rb                  NUMBER;
       l_n_cnt_ss                  NUMBER;
       l_n_cnt_os                  NUMBER;
       l_n_cnt_di                  NUMBER;
       l_n_cnt_sl                  NUMBER;
       l_n_cnt_ol                  NUMBER;
       l_v_sql_id                  VARCHAR2(10);
       l_v_user                    VARCHAR2(50):='SYSTEM';
       l_v_time                    TIMESTAMP;
       l_v_errcd TOS_ERROR_LOG.ERROR_CODE%TYPE:='00000';
       l_v_errmsg                  VARCHAR2(200);
       l_exce_main                 EXCEPTION;

    BEGIN
       IF  p_i_n_flg  = 'L' THEN
       ---------------------------UPDATION OF LOAD LIST HEADER STARTS------------------
          l_v_sql_id := 'SQL-001';
             BEGIN
                SELECT NVL(SUM(1),0)                                               CNT_BOOKED,
                       NVL(SUM(CASE WHEN LOADING_STATUS='LO' THEN 1 ELSE 0 END),0) CNT_LOADED,
                       NVL(SUM(CASE WHEN LOADING_STATUS='RB' THEN 1 ELSE 0 END),0) CNT_ROB,
                       NVL(SUM(CASE WHEN LOADING_STATUS='SS' THEN 1 ELSE 0 END),0) CNT_SHORT_SHIPPED
                  INTO l_n_cnt_bk, l_n_cnt_lo, l_n_cnt_rb, l_n_cnt_ss
                FROM TOS_LL_BOOKED_LOADING
                WHERE RECORD_STATUS   = 'A'
                  AND FK_LOAD_LIST_ID = p_i_n_id;
             EXCEPTION
                WHEN OTHERS THEN

                   g_v_record_filter := 'FK_LOAD_LIST_ID:'|| p_i_n_id  ;
                   g_v_record_table  := 'Load List not found in TOS_LL_BOOKED_LOADING' ;

                   RAISE l_exce_main;
             END;
            l_v_sql_id := 'SQL-005';
             BEGIN
                SELECT COUNT(1)
                INTO l_n_cnt_os
                FROM TOS_LL_OVERSHIPPED_CONTAINER
                WHERE RECORD_STATUS   = 'A'
                  AND FK_LOAD_LIST_ID = p_i_n_id;

             EXCEPTION
                WHEN OTHERS THEN

                   g_v_record_filter := 'FK_LOAD_LIST_ID:'|| p_i_n_id  ;
                   g_v_record_table  := 'Over Shipped Data not found in TOS_LL_OVERSHIPPED_CONTAINER' ;

                   RAISE l_exce_main;
             END;

             UPDATE TOS_LL_LOAD_LIST SET
                    DA_BOOKED_TOT       = l_n_cnt_bk,
                    DA_LOADED_TOT       = l_n_cnt_lo,
                    DA_ROB_TOT          = l_n_cnt_rb,
                    DA_OVERSHIPPED_TOT  = l_n_cnt_os,
                    DA_SHORTSHIPPED_TOT = l_n_cnt_ss,
                    RECORD_CHANGE_USER  = g_v_user,
                    RECORD_CHANGE_DATE  = SYSDATE
                WHERE RECORD_STATUS   = 'A'
                  AND PK_LOAD_LIST_ID   = p_i_n_id ;
    ---------------------------UPDATION OF LOAD LIST HEADER ENDS------------------
       ELSE
       ---------------------------UPDATION OF LOAD DISCHARGE HEADER STARTS------------------
          l_v_sql_id := 'SQL-001';
             BEGIN
                SELECT NVL(SUM(1),0)                                                 CNT_BOOKED,
                       NVL(SUM(CASE WHEN DISCHARGE_STATUS IN ('DI','BD') THEN 1 ELSE 0 END),0) CNT_DISCHARGED,
                       NVL(SUM(CASE WHEN DISCHARGE_STATUS='RB' THEN 1 ELSE 0 END),0) CNT_ROB,
                       NVL(SUM(CASE WHEN DISCHARGE_STATUS='SL' THEN 1 ELSE 0 END),0) CNT_SHORT_LANDED
                  INTO l_n_cnt_bk, l_n_cnt_di, l_n_cnt_rb, l_n_cnt_sl
                FROM TOS_DL_BOOKED_DISCHARGE
                WHERE RECORD_STATUS        = 'A'
                  AND FK_DISCHARGE_LIST_ID = p_i_n_id;
             EXCEPTION
                WHEN OTHERS THEN

                   g_v_record_filter := 'FK_DISCHARGE_LIST_ID:'|| p_i_n_id  ;
                   g_v_record_table  := 'Load Discharge data Not found in TOS_DL_BOOKED_DISCHARGE' ;

                   RAISE l_exce_main;
             END;
            l_v_sql_id := 'SQL-005';
             BEGIN
                SELECT COUNT(1)
                INTO l_n_cnt_ol
                FROM TOS_DL_OVERLANDED_CONTAINER
                WHERE RECORD_STATUS        = 'A'
                  AND FK_DISCHARGE_LIST_ID = p_i_n_id;

             EXCEPTION
                WHEN OTHERS THEN

                   g_v_record_filter := 'FK_DISCHARGE_LIST_ID:'|| p_i_n_id  ;
                   g_v_record_table  := 'Over Landed data Not found in TOS_DL_OVERLANDED_CONTAINER' ;

                   RAISE l_exce_main;
             END;

             UPDATE TOS_DL_DISCHARGE_LIST SET
                    DA_BOOKED_TOT       = l_n_cnt_bk,
                    DA_DISCHARGED_TOT   = l_n_cnt_di,
                    DA_ROB_TOT          = l_n_cnt_rb,
                    DA_OVERLANDED_TOT   = l_n_cnt_ol,
                    DA_SHORTLANDED_TOT  = l_n_cnt_sl,
                    RECORD_CHANGE_USER  = g_v_user,
                    RECORD_CHANGE_DATE  = SYSDATE
                WHERE RECORD_STATUS         = 'A'
                  AND PK_DISCHARGE_LIST_ID  = p_i_n_id ;
    END IF;
       ---------------------------UPDATION OF LOAD DISCHARGE HEADER ends------------------

    ----------inserting Batch status into TOS_ERROR_MST table.
       p_o_v_return_status := '0';

    EXCEPTION
       WHEN l_exce_main THEN
          p_o_v_return_status := '1';
          ROLLBACK;
        WHEN OTHERS THEN
           p_o_v_return_status := '1';
           ROLLBACK;
    END;


    PROCEDURE PRE_TOS_EQUIPMENT_ADD
    (
         p_i_v_booking_no       IN VARCHAR2
       , p_i_n_equipment_seq_no IN NUMBER
       , p_i_n_size_type_seq_no IN NUMBER
       , p_i_n_supplier_seq_no  IN NUMBER
       , p_o_v_return_status    OUT NOCOPY VARCHAR2
    ) AS
    /*********************************************************************************************
    Name    : PRE_TOS_EQUIPMENT_ADD
    Module  : EZLL
    Purpose : Whenever new row inserted into Booking equipment detail(BKP009) for a booking whose
              status is confirmed or closed, populate affected load list and discharge list with
              new equipment details.
    Calls   : PRE_TOS_CREATE_LOAD_LIST, PRE_TOS_CREATE_DISCHARGE_LIST.
    Returns : 0   --Success
              1   --Fail
    Steps involved :
    History:
    Author              Date       What
    ------              ----       ----
    Bindu             20/01/2011   Initial Version 1.0
    **********************************************************************************************/
    l_v_booking_status   VARCHAR2(1);
    l_exce_main          EXCEPTION;
    l_n_rec_found        NUMBER(5) := 0;
    l_n_temp_count         NUMBER(5):= 0;
    l_n_load_count         NUMBER(5):= 0;
    l_n_overshipped_id  TOS_TMP_AUTOMATCH_LAUNCH.FK_OVERSHIPPED_CONTAINER_ID%TYPE;

    --Cursor to retrive all the records from booked loading for single booking.
    CURSOR l_cur_booked_loading
    IS
       SELECT  DISTINCT TLL.PK_LOAD_LIST_ID FK_LOAD_LIST_ID
             , BVR.VOYAGE_SEQNO             FK_BKG_VOYAGE_ROUTING_DTL
        FROM TOS_LL_LOAD_LIST TLL
           , BOOKING_VOYAGE_ROUTING_DTL BVR
        WHERE TLL.FK_SERVICE          = BVR.SERVICE
          AND TLL.FK_VESSEL           = BVR.VESSEL
          AND TLL.FK_VOYAGE           = BVR.VOYNO
          AND TLL.FK_DIRECTION        = BVR.DIRECTION
          AND TLL.DN_PORT             = BVR.LOAD_PORT
          AND TLL.FK_PORT_SEQUENCE_NO = BVR.POL_PCSQ
          AND TLL.RECORD_STATUS       = 'A'
          AND BVR.VESSEL IS NOT NULL
          AND BVR.VOYNO  IS NOT NULL
          AND BVR.ROUTING_TYPE        = 'S'
          AND BVR.BOOKING_NO          = p_i_v_booking_no;

    --Cursor to retrive all the records from booked discharge for single booking.
    CURSOR l_cur_booked_discharge
    IS
       SELECT DISTINCT TDD.PK_DISCHARGE_LIST_ID FK_DISCHARGE_LIST_ID
            , BVR.VOYAGE_SEQNO                  FK_BKG_VOYAGE_ROUTING_DTL
        FROM TOS_DL_DISCHARGE_LIST TDD
           , BOOKING_VOYAGE_ROUTING_DTL BVR
        WHERE TDD.FK_SERVICE        = BVR.ACT_SERVICE_CODE
        AND TDD.FK_VESSEL           = BVR.ACT_VESSEL_CODE
        -- AND TDD.FK_VOYAGE           = DECODE(BVR.ACT_SERVICE_CODE, 'AFS', BVR.ACT_VOYAGE_NUMBER,(SELECT INVOYAGENO  -- *1: Modified for DFS service
        AND TDD.FK_VOYAGE           = DECODE(BVR.ACT_SERVICE_CODE, 'AFS', BVR.ACT_VOYAGE_NUMBER, -- *1: Modified for DFS service
                                     'DFS', BVR.ACT_VOYAGE_NUMBER,(SELECT INVOYAGENO   -- *1: Modified for DFS service
                                       FROM ITP063
                                       WHERE VVSRVC = ACT_SERVICE_CODE
                                       AND VVVESS   = ACT_VESSEL_CODE
                                       AND VVVOYN   = ACT_VOYAGE_NUMBER
                                       AND VVPDIR   = ACT_PORT_DIRECTION
                                       AND VVPCSQ   = ACT_PORT_SEQUENCE
                                       AND VVPCAL   = DISCHARGE_PORT
                                       AND VVTRM1   = TO_TERMINAL
                                       AND VVVERS   = 99
                                       AND OMMISSION_FLAG IS NULL))
        AND TDD.FK_DIRECTION        = BVR.ACT_PORT_DIRECTION
        AND TDD.DN_PORT             = BVR.DISCHARGE_PORT
        AND TDD.FK_PORT_SEQUENCE_NO = BVR.ACT_PORT_SEQUENCE
        AND TDD.RECORD_STATUS       = 'A'
        AND BVR.VESSEL IS NOT NULL
        AND BVR.VOYNO  IS NOT NULL
        AND BVR.ROUTING_TYPE        = 'S'
        AND BVR.BOOKING_NO          = p_i_v_booking_no;
     --Cursor data for colling matching sp.
    CURSOR l_cur_booked_load_list
    IS
       SELECT DISTINCT FK_LOAD_LIST_ID
       FROM TOS_LL_BOOKED_LOADING A
       WHERE EXISTS ( SELECT 1 FROM TOS_TMP_AUTOMATCH_LAUNCH B
                      WHERE A.FK_BOOKING_NO     = B.FK_BOOKING_NO
                      AND A.DN_EQUIPMENT_NO     = B.DN_EQUIPMENT_NO
                      AND A.FK_LOAD_LIST_ID     = B.FK_LOAD_LIST_ID )
       AND A.FK_BOOKING_NO = p_i_v_booking_no;
    BEGIN
       --finding booking status.
       BEGIN
          g_v_sql_id := 'SQL-08001';
          SELECT BK1.BASTAT
          INTO l_v_booking_status
          FROM BKP001 BK1
          WHERE BK1.BABKNO = p_i_v_booking_no;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
            l_v_booking_status := '*';

            g_v_record_filter := 'BABKNO:'|| p_i_v_booking_no  ;
            g_v_record_table  := 'Booking status Not found in BKP001' ;

          WHEN OTHERS THEN
             l_v_booking_status := '*';

            g_v_record_filter := 'BABKNO:'|| p_i_v_booking_no  ;
            g_v_record_table  := 'Error occured.Contact System administrator' ;

       END;
       --Checking booking staus.
       IF l_v_booking_status IN ('L','P','C') THEN
          --Inserting new equipment detail into booked loading.
          FOR I IN l_cur_booked_loading
          LOOP
             g_v_sql_id := 'SQL-08002';
             BEGIN
                PRE_TOS_CREATE_LOAD_LIST(p_i_v_booking_no
                                       , I.FK_BKG_VOYAGE_ROUTING_DTL
                                       , I.FK_LOAD_LIST_ID
                                       , p_i_n_equipment_seq_no
                                       , p_i_n_size_type_seq_no
                                       , p_i_n_supplier_seq_no
                                       , p_o_v_return_status
                                        );
                IF p_o_v_return_status = 1 THEN
                   RAISE l_exce_main;
                END IF;
             EXCEPTION
                WHEN OTHERS THEN
                   RAISE l_exce_main;
             END;
          END LOOP;
          --Inserting new equipment detail into booked discharge table.
          FOR J IN l_cur_booked_discharge
          LOOP
             g_v_sql_id := 'SQL-08003';
             BEGIN
                PRE_TOS_CREATE_DISCHARGE_LIST(p_i_v_booking_no
                                            , J.FK_BKG_VOYAGE_ROUTING_DTL
                                            , J.FK_DISCHARGE_LIST_ID
                                            , p_i_n_equipment_seq_no
                                            , p_i_n_size_type_seq_no
                                            , p_i_n_supplier_seq_no
                                            , p_o_v_return_status
                                             );
                IF p_o_v_return_status = 1 THEN
                   RAISE l_exce_main;
                END IF;
             EXCEPTION
                WHEN OTHERS THEN
                   RAISE l_exce_main;
             END;
          END LOOP;
          COMMIT;
          --Add by Bindu on 05/03/2011 for calling Automatch sp, if record found in TOS_TMP_AUTOMATCH_LAUNCH table.
          FOR l_cur_booked_load IN l_cur_booked_load_list
          LOOP
             g_v_sql_id := 'SQL-08004';
             BEGIN
                 SELECT COUNT(1)
                 INTO l_n_temp_count
                 FROM TOS_TMP_AUTOMATCH_LAUNCH
                 WHERE FK_LOAD_LIST_ID = l_cur_booked_load.FK_LOAD_LIST_ID;
             EXCEPTION
                WHEN OTHERS THEN
                   g_v_err_code   := TO_CHAR (SQLCODE);
                   g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                   g_v_record_filter := 'FK_LOAD_LIST_ID:'|| l_cur_booked_load.FK_LOAD_LIST_ID;
                   g_v_record_table  := 'Load List Not found in TOS_TMP_AUTOMATCH_LAUNCH' ;

                   RAISE l_exce_main;
             END;
             g_v_sql_id := 'SQL-08005';
             BEGIN
                SELECT COUNT(1)
                INTO l_n_load_count
                FROM TOS_LL_BOOKED_LOADING A
                   , TOS_TMP_AUTOMATCH_LAUNCH B
                WHERE A.FK_BOOKING_NO = B.FK_BOOKING_NO
                AND A.DN_EQUIPMENT_NO = B.DN_EQUIPMENT_NO
                AND A.FK_LOAD_LIST_ID = B.FK_LOAD_LIST_ID
                AND A.FK_LOAD_LIST_ID = l_cur_booked_load.FK_LOAD_LIST_ID;
             EXCEPTION
                WHEN OTHERS THEN
                   g_v_err_code   := TO_CHAR (SQLCODE);
                   g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                   g_v_record_filter := 'FK_LOAD_LIST_ID:'|| l_cur_booked_load.FK_LOAD_LIST_ID;
                   g_v_record_table  := 'Load List Not found in TOS_TMP_AUTOMATCH_LAUNCH,TOS_LL_BOOKED_LOADING' ;

                   RAISE l_exce_main;
             END;
             IF l_n_temp_count = l_n_load_count THEN
                g_v_sql_id := 'SQL-08006';
                BEGIN
                   PCE_ECM_EDI.PRE_TOS_LLDL_COMMON_MATCHING('E', 'LL', '', '', ''
                                                          , l_cur_booked_load.FK_LOAD_LIST_ID
                                                          , ''
                                                          , ''
                                                          , p_o_v_return_status
                                                           );
                   IF p_o_v_return_status = '1' THEN
                      g_v_err_code   := TO_CHAR (SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                      RAISE l_exce_main;
                   END IF;
                EXCEPTION
                   WHEN OTHERS THEN
                      g_v_err_code   := TO_CHAR (SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                      RAISE l_exce_main;
                END;
             END IF;
          END LOOP;
          --End by Bindu on 05/03/2011 for calling Automatch sp, if record found in TOS_TMP_AUTOMATCH_LAUNCH table.
          p_o_v_return_status := '0';
       ELSE
          p_o_v_return_status := '0';
       END IF;
    EXCEPTION
       WHEN l_exce_main THEN
          p_o_v_return_status := '1';
          ROLLBACK;
          PRE_TOS_SYNC_ERROR_LOG(p_i_v_booking_no||'~'||p_i_n_equipment_seq_no||'~'||p_i_n_size_type_seq_no||'~'||p_i_n_supplier_seq_no
                            , 'L105_M'
                            , 'I'
                            , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                            , 'A'
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_record_filter
                            , g_v_record_table
                              );
          COMMIT;
       WHEN OTHERS THEN
           p_o_v_return_status := '1';
           ROLLBACK;
           g_v_err_code   := TO_CHAR (SQLCODE);
           g_v_err_desc   := SUBSTR(SQLERRM,1,100);
           PRE_TOS_SYNC_ERROR_LOG(p_i_v_booking_no||'~'||p_i_n_equipment_seq_no||'~'||p_i_n_size_type_seq_no||'~'||p_i_n_supplier_seq_no
                            , 'L105_O'
                            , 'I'
                            , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                            , 'A'
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_record_filter
                            ,  g_v_record_table
                              );
           COMMIT;
    END PRE_TOS_EQUIPMENT_ADD;

      PROCEDURE PRE_TOS_EQUIPMENT_REMOVE
    (
         p_i_v_booking_no       IN VARCHAR2
       , p_i_n_equipment_seq_no IN NUMBER
       , p_o_v_return_status    OUT NOCOPY VARCHAR2
    ) AS
    /*********************************************************************************************
    Name    : PRE_TOS_EQUIPMENT_REMOVE
    Module  : EZLL
    Purpose : To remove the containers from booked loading and booked discharge whenever
    container is removed from booking equipment detail(BKP009).
    Calls   : PRE_TOS_REMOVE_BKG_LL, PRE_TOS_REMOVE_BKG_DL.
    Returns : 0   --Success
              1   --Fail
    Steps involved :
    History:
    Author              Date       What
    ------              ----       ----
    Bindu             14/01/2011   Initial Version 1.0
    **********************************************************************************************/
       l_v_booking_status VARCHAR2(1);
       l_exce_main        EXCEPTION;

    BEGIN
        --Check booking status from BKP001.
        BEGIN
            g_v_sql_id := 'SQL-09001';
            g_v_record_filter := 'BABKNO:'|| p_i_v_booking_no  ;
            SELECT BK1.BASTAT
            INTO l_v_booking_status
            FROM BKP001 BK1
            WHERE BK1.BABKNO = p_i_v_booking_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_v_booking_status := '*';

                g_v_record_table  := 'Booking Status Not found in BKP001' ;

            WHEN OTHERS THEN
                l_v_booking_status := '*';

                g_v_record_table  := 'Error occured.Contact System administrator' ;

        END;

        IF l_v_booking_status IN ('L','P','C') THEN
            BEGIN
                g_v_sql_id := 'SQL-09002';
                --Calling delete Containers from booked list.
                PRE_TOS_REMOVE_BKG_LL(p_i_v_booking_no
                                    , p_i_n_equipment_seq_no
                                    , NULL
                                    , p_o_v_return_status
                                    );
                IF p_o_v_return_status = 1 THEN
                    RAISE l_exce_main;
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    dbms_output.put_line('load list status: '|| sqlerrm);
                    RAISE l_exce_main;
            END;

            BEGIN
                g_v_sql_id := 'SQL-09003';
                --Calling delete Containers from booked discharge.
                dbms_output.put_line('discharge list delete called');



                PRE_TOS_REMOVE_BKG_DL(p_i_v_booking_no
                                    , p_i_n_equipment_seq_no
                                    , NULL
                                    , p_o_v_return_status
                                    );
                IF p_o_v_return_status = 1 THEN
                    RAISE l_exce_main;
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    RAISE l_exce_main;
            END;
            p_o_v_return_status := '0';
        ELSE
            p_o_v_return_status := '0';
        END IF;
        COMMIT;
        --inserting Batch status into error log table.
    EXCEPTION
       WHEN l_exce_main THEN
          p_o_v_return_status := '1';
          ROLLBACK;
          PRE_TOS_SYNC_ERROR_LOG(p_i_v_booking_no||'~'||p_i_n_equipment_seq_no
                            , 'L103_M'
                            , 'D'
                            , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                            , 'A'
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_record_filter
                            , g_v_record_table
                             );
          COMMIT;
       WHEN OTHERS THEN
          p_o_v_return_status := '1';
          g_v_err_code   := NVL(g_v_err_code,TO_CHAR (SQLCODE));
          g_v_err_desc   := NVL(g_v_err_desc,SUBSTR(SQLERRM,1,100));
          ROLLBACK;
          PRE_TOS_SYNC_ERROR_LOG(p_i_v_booking_no||'~'||p_i_n_equipment_seq_no
                            , 'L103_O'
                            , 'D'
                            , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                            , 'A'
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_record_filter
                            ,  g_v_record_table
                             );
          COMMIT;
    END PRE_TOS_EQUIPMENT_REMOVE;

    PROCEDURE PRE_TOS_REMOVE_BKG(
       p_i_v_booking_no        IN  VARCHAR2,
       p_o_v_return_status     OUT NOCOPY VARCHAR2
    ) AS
    /***********************************************************************************
       Name    : PRE_TOS_REMOVE_BKG
       Module  : EZLL
       Purpose : To remove the containers from booked loading and booked discharge.
       Calls   : PRE_TOS_REMOVE_BKG_LL, PRE_TOS_REMOVE_BKG_DL.
       Returns : 0   --Success
                 1   --Fail
       Steps involved :
       History:
       Author              Date       What
       ------              ----       ----
       Bindu             14/01/2011   Initial Version 1.0
    ************************************************************************************/
    l_v_user              VARCHAR2(50):='SYSTEM';
    l_v_errcd             TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
    l_v_errmsg            VARCHAR2(200);
    l_v_sql_id            VARCHAR2(10);
    l_exce_main           EXCEPTION;

    BEGIN
        g_v_sql_id := 'SQL-05001';

        --Calling delete Containers from booked loading.
        PRE_TOS_REMOVE_BKG_LL(p_i_v_booking_no, NULL, NULL, p_o_v_return_status);
        dbms_output.put_line('load list status: '|| p_o_v_return_status);

        IF p_o_v_return_status = 0 THEN
            g_v_sql_id := 'SQL-05002';
            --Calling delete Containers from booked discharge.
            PRE_TOS_REMOVE_BKG_DL(p_i_v_booking_no, NULL, NULL, p_o_v_return_status);
        END IF;

    END PRE_TOS_REMOVE_BKG;

PROCEDURE PRE_TOS_REMOVE_BKG_DL
    (
       p_i_v_booking_no        IN  VARCHAR2,
       p_i_n_equipment_seq_no  IN  NUMBER,
       p_i_n_discharge_list_id IN  NUMBER,
       p_o_v_return_status     OUT NOCOPY VARCHAR2
    ) AS
    /***********************************************************************************
       Name    : PRE_TOS_REMOVE_BKG_DL
       Module  : EZLL
       Purpose : To remove the containers from booked discharge.
       Calls   : PRE_TOS_MOVE_TO_OVERLANDED.
       Returns : 0   --Success
                 1   --Fail
       Steps involved :
       History:
       Author              Date       What
       ------              ----       ----
       Bindu             20/01/2011   Initial Version 1.0
    ************************************************************************************/
        l_v_booking_status    VARCHAR2(1);
        l_v_sql_id            VARCHAR2(10);
        l_n_count             NUMBER:=0;
        l_v_user              VARCHAR2(50):='SYSTEM';
        l_v_errcd             TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
        l_v_errmsg            VARCHAR2(200);
        l_exce_main           EXCEPTION;

        l_v_time              TIMESTAMP;
        l_n_discharge_list_status TOS_DL_DISCHARGE_LIST.DISCHARGE_LIST_STATUS%TYPE; --Added by Rajeev on 04/04/2011
        p_o_v_error           VARCHAR2(100);
        L_V_LIST_STATUS       VARCHAR2(2) ; -- *23
        IS_ALREADY_SEND       VARCHAR2(5) := FALSE; /* *24 start */

    --Cursor to retrive all the records from booked discharge for single booking.
    cursor l_cur_booked_discharge
    IS
       SELECT FK_BOOKING_NO,
              FK_DISCHARGE_LIST_ID,
              PK_BOOKED_DISCHARGE_ID,
              DISCHARGE_STATUS,
              FK_BKG_EQUIPM_DTL -- *24
        FROM TOS_DL_BOOKED_DISCHARGE
        WHERE FK_BOOKING_NO        = p_i_v_booking_no
          AND FK_BKG_EQUIPM_DTL    = NVL(p_i_n_equipment_seq_no , FK_BKG_EQUIPM_DTL)
          AND FK_DISCHARGE_LIST_ID = NVL(p_i_n_discharge_list_id, FK_DISCHARGE_LIST_ID)
          AND RECORD_STATUS        = 'A';

    BEGIN

       l_v_time := SYSDATE; -- CURRENT_TIMESTAMP; -- *12

       g_v_sql_id := 'SQL-07001';

    --Remove containers from booked discharge.
        l_n_count :=0;
        FOR J IN l_cur_booked_discharge
        LOOP

            l_n_count := l_n_count + 1;
            g_v_sql_id := 'SQL-07002';
            IF J.DISCHARGE_STATUS IN ('DI','BD','RB') THEN
                dbms_output.put_line('true');
                BEGIN
                    g_v_sql_id := 'SQL-07003';
                    PRE_TOS_TEMP_CONT_REMOVAL(J.FK_BOOKING_NO,
                                            J.FK_DISCHARGE_LIST_ID,
                                            J.PK_BOOKED_DISCHARGE_ID,
                                            NULL,
                                            'D',
                                            p_o_v_return_status
                                            );

                    IF p_o_v_return_status = '1' THEN
                        RAISE l_exce_main;
                    END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                        RAISE l_exce_main;
                END;

            ELSE -- else of J.DISCHARGE_STATUS if
                dbms_output.put_line('false');
                BEGIN
                    g_v_sql_id := 'SQL-07004';
                -- Eq. Seq. No should not be null.
                    BEGIN
                        SELECT DISCHARGE_LIST_STATUS
                        INTO   l_n_discharge_list_status
                        FROM   TOS_DL_DISCHARGE_LIST
                        WHERE  PK_DISCHARGE_LIST_ID = J.FK_DISCHARGE_LIST_ID;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            l_n_discharge_list_status := 0;

                            g_v_record_filter := 'PK_DISCHARGE_LIST_ID:'|| J.FK_DISCHARGE_LIST_ID;
                            g_v_record_table  := 'Discharge List Status Not found in TOS_DL_DISCHARGE_LIST' ;

                    END;

                    g_v_sql_id := 'SQL-07005';
                    IF l_n_discharge_list_status != 0 THEN

                        g_v_sql_id := 'SQL-07006';
                        /* * *23 start * */
                        PRE_GET_LIST_STATUS (
                            J.FK_DISCHARGE_LIST_ID,
                            DISCHARGE_LIST,
                            L_V_LIST_STATUS
                        );

                        g_v_sql_id := 'SQL-07007';

                        /* * *23 end * */
                        IF ((L_V_LIST_STATUS = DISCHARGE_COMPLETE) OR
                            (L_V_LIST_STATUS = READY_FOR_INVOICE) OR
                            (L_V_LIST_STATUS = WORK_COMPLETE)) THEN  -- *23
                            BEGIN
                                g_v_sql_id := 'SQL-07008';

                                PCE_ECM_RAISE_ENOTICE.PRE_DL_WRK_SRT_SYNC (
                                      J.FK_DISCHARGE_LIST_ID
                                    , j.FK_BKG_EQUIPM_DTL -- *16
                                    , J.FK_BOOKING_NO
                                    , g_n_bussiness_key_sync_dws_del
                                    , g_v_user
                                    , TO_CHAR(l_v_time,'YYYYMMDDHH24MISS')
                                    , p_o_v_error
                                );

                                /* *24 start * */
                                /* *can not send mail because container is removed previously
                                logic is moved to procedre PRE_TOS_REMOVE_BKG. * */

                                --PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                                --      J.FK_DISCHARGE_LIST_ID
                                --    , p_i_n_equipment_seq_no
                                --    , J.FK_BOOKING_NO
                                --    , g_n_bussiness_key_sync_cch_del
                                --    , null -- Old Equipment No.
                                --    , null -- New Equipment No.
                                --    , 'U'
                                --    , g_v_user
                                --    , TO_CHAR(l_v_time,'YYYYMMDDHH24MISS')
                                --    , p_o_v_error
                                --);
                                /* *24 end * */
                            EXCEPTION
                                WHEN OTHERS THEN
                                    PRE_TOS_SYNC_ERROR_LOG(
                                        'EXCETION in calling mail '
                                            ||'~'|| J.FK_DISCHARGE_LIST_ID
                                            ||'~'|| g_v_sql_id
                                            ||'~'|| J.FK_DISCHARGE_LIST_ID
                                            ||'~'|| J.FK_BKG_EQUIPM_DTL
                                            ||'~'|| J.FK_BOOKING_NO,
                                        'SYNC',
                                        'D',
                                        'SYNC',
                                        'A',
                                        g_v_user,
                                        SYSDATE,
                                        g_v_user,
                                        SYSDATE
                                    );
                            END ;
                        END IF; -- *23

                    END IF; -- end if of l_n_discharge_list_status


                    g_v_sql_id := 'SQL-07004';
                    dbms_output.put_line('record deleted~'||
                        J.FK_DISCHARGE_LIST_ID);

                    DELETE FROM TOS_DL_BOOKED_DISCHARGE
                    WHERE FK_BOOKING_NO          = J.FK_BOOKING_NO
                    AND FK_DISCHARGE_LIST_ID   = J.FK_DISCHARGE_LIST_ID
                    AND PK_BOOKED_DISCHARGE_ID = J.PK_BOOKED_DISCHARGE_ID
                    AND DISCHARGE_STATUS       = J.DISCHARGE_STATUS;
                EXCEPTION
                    WHEN OTHERS THEN
                       RAISE l_exce_main;
                END;
            END IF; -- end if of J.DISCHARGE_STATUS

            g_v_sql_id := 'SQL-07005';

            --Update Discharge List Status count
            PRE_TOS_STATUS_COUNT(J.FK_DISCHARGE_LIST_ID,'D',p_o_v_return_status);
            IF p_o_v_return_status = '1' THEN
               RAISE l_exce_main;
            END IF;

            IS_ALREADY_SEND := TRUE; -- *24

        END LOOP;

        ---Create a load list late change alert IF Load list status is load complete(10) or higher.

        p_o_v_return_status := '0';
        --inserting Batch status into TOS_ERROR_MST table.

        dbms_output.put_line('delete done for discharge list');

        -- COMMIT; -- *2
    EXCEPTION
       WHEN l_exce_main THEN
            COMMIT; -- *3
          p_o_v_return_status := '1';
          g_v_err_code := TO_CHAR (SQLCODE);
          g_v_err_desc := SUBSTR(SQLERRM,1,100);
          dbms_output.put_line('error: '||g_v_sql_id);

          -- ROLLBACK;
       WHEN OTHERS THEN
            COMMIT; -- *3
          p_o_v_return_status := '1';
          g_v_err_code := TO_CHAR (SQLCODE);
          g_v_err_desc := SUBSTR(SQLERRM,1,100);
          dbms_output.put_line('error: '||g_v_sql_id);
          -- ROLLBACK;
    END PRE_TOS_REMOVE_BKG_DL;

    PROCEDURE PRE_TOS_REMOVE_BKG_LL
    (
       p_i_v_booking_no        IN  VARCHAR2,
       p_i_n_equipment_seq_no  IN  NUMBER,
       p_i_n_load_list_id      IN  NUMBER,
       p_o_v_return_status     OUT NOCOPY VARCHAR2
    ) AS
    /***********************************************************************************
       Name    : PRE_TOS_REMOVE_BKG_LL
       Module  : EZLL
       Purpose : To remove the containers from booked loading.
       Calls   : PRE_TOS_MOVE_TO_OVERSHIPPED.
       Returns : 0   --Success
                 1   --Fail
       Steps involved :
       History:
       Author              Date       What
       ------              ----       ----
       Bindu             20/01/2011   Initial Version 1.0
    ************************************************************************************/
       l_v_booking_status    VARCHAR2(1);
       l_v_sql_id            VARCHAR2(10);
       l_n_count             NUMBER:=0;
       l_v_user              VARCHAR2(50):='SYSTEM';
       l_v_errcd             TOS_SYNC_ERROR_LOG.ERROR_MSG%TYPE;
       l_v_errmsg            VARCHAR2(200);
       l_exce_main           EXCEPTION;

    --Cursor to retrive all the records from booked loading for single booking.
    cursor l_cur_booked_loading
    IS
       SELECT FK_LOAD_LIST_ID,
              FK_BOOKING_NO,
              PK_BOOKED_LOADING_ID,
              PREADVICE_FLAG,
              LOADING_STATUS,
              FK_BKG_EQUIPM_DTL
       FROM TOS_LL_BOOKED_LOADING
       WHERE FK_BOOKING_NO        = p_i_v_booking_no
       AND   FK_BKG_EQUIPM_DTL    = NVL(p_i_n_equipment_seq_no, FK_BKG_EQUIPM_DTL)
       AND   FK_LOAD_LIST_ID      = NVL(p_i_n_load_list_id, FK_LOAD_LIST_ID)
       AND   RECORD_STATUS        = 'A';

    BEGIN
       g_v_sql_id := 'SQL-06001';
       --Remove containers from booked loading.
       l_n_count :=0;
        /* 24 start * */
        /* * no need to send multiple times * */
        -- IF IS_ALREADY_SEND = TRUE THEN
            PRE_EQ_REMOVE_SYNC_MAIL(
                p_i_v_booking_no,
                p_i_n_equipment_seq_no
            );
        -- END IF;
        /* 24 end * */

       FOR I IN l_cur_booked_loading
       LOOP
            l_n_count := l_n_count + 1;
            g_v_sql_id := 'SQL-06002';
            IF ((I.LOADING_STATUS IN ('LO','RB')) OR (I.LOADING_STATUS = 'BK' AND I.PREADVICE_FLAG = 'Y' ))  THEN
                BEGIN
                    g_v_sql_id := 'SQL-06003';
                    PRE_TOS_TEMP_CONT_REMOVAL(I.FK_BOOKING_NO,
                                            I.FK_LOAD_LIST_ID,
                                            I.PK_BOOKED_LOADING_ID,
                                            I.PREADVICE_FLAG,
                                            'L',
                                            p_o_v_return_status
                                                            );
                        IF p_o_v_return_status = '1' THEN
                            RAISE l_exce_main;
                        END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                        RAISE l_exce_main;
                END;
            ELSE
                BEGIN
                    g_v_sql_id := 'SQL-06004';
                    DELETE FROM TOS_LL_BOOKED_LOADING
                    WHERE FK_BOOKING_NO        = I.FK_BOOKING_NO
                    AND   FK_LOAD_LIST_ID      = I.FK_LOAD_LIST_ID
                    AND   PK_BOOKED_LOADING_ID = I.PK_BOOKED_LOADING_ID
                    AND   LOADING_STATUS       = I.LOADING_STATUS
                    AND   RECORD_STATUS        = 'A';
                EXCEPTION
                    WHEN OTHERS THEN
                    RAISE l_exce_main;
                END;
            END IF;

            g_v_sql_id := 'SQL-06005';
            --Update Load List Status count
            PRE_TOS_STATUS_COUNT(I.FK_LOAD_LIST_ID,'L',p_o_v_return_status);
            IF p_o_v_return_status = '1' THEN
               RAISE l_exce_main;
            END IF;

        END LOOP;

        ---Create a load list late change alert IF Load list status is load complete(10) or higher.

        p_o_v_return_status := '0';
        --inserting Batch status into TOS_ERROR_MST table.

        dbms_output.put_line('load list deleted');
        dbms_output.put_line('load list deleted 2');

        -- COMMIT; -- *2
    EXCEPTION
       WHEN l_exce_main THEN
            COMMIT; -- *3
          p_o_v_return_status := '1';
          g_v_err_code := TO_CHAR (SQLCODE);
          g_v_err_desc := SUBSTR(SQLERRM,1,100);
          -- ROLLBACK;
       WHEN OTHERS THEN
            COMMIT; -- *3
          p_o_v_return_status := '1';
          g_v_err_code := TO_CHAR (SQLCODE);
          g_v_err_desc := SUBSTR(SQLERRM,1,100);
          -- ROLLBACK; -- *3
    END PRE_TOS_REMOVE_BKG_LL;

    /*
        Called by BOOKING_VOUAGE_ROUTING_DTL handler for routing update
    */
    PROCEDURE PRE_TOS_ROUTING_UPDATE(
         p_i_v_booking_no         IN    VARCHAR2
       , p_i_n_voyage_seq_no      IN    NUMBER
       , p_i_v_old_service        IN    VARCHAR2
       , p_i_v_new_service        IN    VARCHAR2
       , p_i_v_old_vessel         IN    VARCHAR2
       , p_i_v_new_vessel         IN    VARCHAR2
       , p_i_v_old_voyage         IN    VARCHAR2
       , p_i_v_new_voyage         IN    VARCHAR2
       , p_i_v_old_direction      IN    VARCHAR2
       , p_i_v_new_direction      IN    VARCHAR2
       , p_i_v_old_load_port      IN    VARCHAR2
       , p_i_v_new_load_port      IN    VARCHAR2
       , p_i_n_old_pol_pcsq       IN    NUMBER
       , p_i_n_new_pol_pcsq       IN    NUMBER
       , p_i_v_old_discharge_port IN    VARCHAR2
       , p_i_v_new_discharge_port IN    VARCHAR2
       , p_i_v_old_act_service    IN    VARCHAR2
       , p_i_v_new_act_service    IN    VARCHAR2
       , p_i_v_old_act_vessel     IN    VARCHAR2
       , p_i_v_new_act_vessel     IN    VARCHAR2
       , p_i_v_old_act_voyage     IN    VARCHAR2
       , p_i_v_new_act_voyage     IN    VARCHAR2
       , p_i_v_old_act_port_direction   IN    VARCHAR2
       , p_i_v_new_act_port_direction   IN    VARCHAR2
       , p_i_n_old_act_port_seq   IN    NUMBER
       , p_i_n_new_act_port_seq   IN    NUMBER
       , p_i_v_old_to_terminal    IN    VARCHAR2
       , p_i_v_new_to_terminal    IN    VARCHAR2
       , p_i_v_old_from_terminal  IN    VARCHAR2 -- *8
       , p_i_v_new_from_terminal  IN    VARCHAR2 -- *8
       , p_i_v_record_status      IN    VARCHAR2
       , p_o_v_return_status      OUT NOCOPY  VARCHAR2

    ) IS
    /****************************************************************************
       Name           :  PRE_TOS_ROUTING_UPDATE
       Module         :
       Purpose        :  To Update data in load list and discharge list
       Calls          :
       Returns        :  Null
       Author          Date               What
       ------          ----               ----
       Sumeet Dwivedi  13/01/2010        INITIAL VERSION
    *****************************************************************************/

    l_v_sql_id               VARCHAR2(80);
    l_v_errcd                tos_sync_error_log .ERROR_MSG%TYPE := '00000';
    l_v_errmsg               VARCHAR2(200);
    l_exce_main              EXCEPTION;
    l_v_booking_stat         VARCHAR2(1);
    l_n_load_list_id         NUMBER;
    l_n_discharge_list_id    NUMBER;
    l_v_fk_booking_no        VARCHAR2(17);
    l_n_fk_load_list_id      NUMBER;
    l_n_pk_booked_loading_id NUMBER;
    l_v_preadvice_flag       VARCHAR2(1);
    l_v_loading_status       VARCHAR2(2);
    l_n_container_seq_no     NUMBER;
    l_v_dn_equipment_no      VARCHAR2(12);
    l_v_strt_time            VARCHAR2(20);
    l_v_end_time             VARCHAR2(20);
    l_i_v_voyage_no          VARCHAR2(200);
    l_v_update_flg           VARCHAR2(1):='F';
    l_v_parameter_str        TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;
    l_i_v_invoyageno         TOS_DL_DISCHARGE_LIST.FK_VOYAGE%TYPE;
    BEGIN
    l_v_parameter_str:=p_i_v_booking_no||'~'||
                       p_i_n_voyage_seq_no||'~'||
                       p_i_v_old_service||'~'||
                       p_i_v_new_service||'~'||
                       p_i_v_old_vessel||'~'||
                       p_i_v_new_vessel||'~'||
                       p_i_v_old_voyage||'~'||
                       p_i_v_new_voyage||'~'||
                       p_i_v_old_direction||'~'||
                       p_i_v_new_direction||'~'||
                       p_i_v_old_load_port||'~'||
                       p_i_v_new_load_port||'~'||
                       p_i_n_old_pol_pcsq||'~'||
                       p_i_n_new_pol_pcsq||'~'||
                       p_i_v_old_discharge_port||'~'||
                       p_i_v_new_discharge_port||'~'||
                       p_i_v_old_act_service||'~'||
                       p_i_v_new_act_service||'~'||
                       p_i_v_old_act_vessel||'~'||
                       p_i_v_new_act_vessel||'~'||
                       p_i_v_old_act_voyage||'~'||
                       p_i_v_new_act_voyage||'~'||
                       p_i_v_old_act_port_direction||'~'||
                       p_i_v_new_act_port_direction||'~'||
                       p_i_n_old_act_port_seq||'~'||
                       p_i_n_new_act_port_seq||'~'||
                       p_i_v_old_to_terminal||'~'||
                       p_i_v_new_to_terminal||'~'||
                       p_i_v_old_from_terminal||'~'|| -- *8
                       p_i_v_new_from_terminal||'~'|| -- *8
                       p_i_v_record_status;
       BEGIN
          g_v_sql_id := 'SQL-11001';
          SELECT BASTAT
          INTO l_v_booking_stat
          FROM BKP001
          WHERE BABKNO = p_i_v_booking_no;
       EXCEPTION
          WHEN OTHERS THEN
             RAISE l_exce_main;

             g_v_record_filter := 'BABKNO:'|| p_i_v_booking_no  ;
             g_v_record_table  := 'BASTAT Not found in BKP001' ;

       END;

       IF l_v_booking_stat IN ('L', 'P', 'C') THEN
          IF p_i_v_record_status = 'U' THEN
             --FOR update case just log the error as per Ascan/Jrw this case dosen't happen
             IF (p_i_v_old_vessel <> p_i_v_new_vessel OR p_i_v_old_voyage <> p_i_v_new_voyage
                 OR p_i_v_old_act_vessel <> p_i_v_new_act_vessel OR p_i_v_old_act_voyage <> p_i_v_new_act_voyage) THEN
                l_v_update_flg := 'T';
             ELSIF p_i_v_old_load_port <> p_i_v_new_load_port AND p_i_v_old_discharge_port = p_i_v_new_discharge_port THEN
                l_v_update_flg := 'T';
             ELSIF p_i_v_old_load_port = p_i_v_new_load_port AND p_i_v_old_discharge_port <> p_i_v_new_discharge_port THEN
                l_v_update_flg := 'T';
             ELSIF p_i_v_old_load_port <> p_i_v_new_load_port AND p_i_v_old_discharge_port <> p_i_v_new_discharge_port THEN
                l_v_update_flg := 'T';
             END IF;
             /*-- START #32 
             IF l_v_update_flg = 'T' THEN
                PRE_TOS_SYNC_ERROR_LOG(p_i_v_booking_no||'~'||p_i_n_voyage_seq_no
                     , 'L102_M'
                     , 'U'
                     , 'Routing updation done for Renomination!'
                     , 'A'
                     , g_v_user
                     , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                     , g_v_user
                     , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                     , g_v_record_filter
                     , g_v_record_table
                      );
             END IF;
            -- END #32 */
          END IF;
          --for routing leg delete
          IF p_i_v_record_status = 'D' THEN
             BEGIN
                --remove record from load list
                g_v_sql_id := 'SQL-11027';
                g_v_record_filter := 'FK_SERVICE:'           || p_i_v_old_service       ||
                                     'FK_VESSEL:'            || p_i_v_old_vessel        ||
                                     'FK_VOYAGE:'            || p_i_v_old_voyage        ||
                                     'FK_DIRECTION:'         || p_i_v_old_direction     ||
                                     'DN_PORT:'              || p_i_v_old_load_port     ||
                                     'FK_PORT_SEQUENCE_NO :' || p_i_n_old_pol_pcsq      ||
                                     'DN_TERMINAL :'         || P_i_v_old_from_terminal ||
                                     'RECORD_STATUS A';
                BEGIN
                    SELECT PK_LOAD_LIST_ID
                    INTO l_n_load_list_id
                    FROM TOS_LL_LOAD_LIST
                    WHERE FK_SERVICE        = p_i_v_old_service
                    AND FK_VESSEL           = p_i_v_old_vessel
                    AND FK_VOYAGE           = p_i_v_old_voyage
                    AND FK_DIRECTION        = p_i_v_old_direction
                    AND DN_PORT             = p_i_v_old_load_port
                    AND DN_TERMINAL         = P_i_v_old_from_terminal -- *8
                    AND RECORD_STATUS       = 'A'
                    AND ROWNUM = 1 ; -- Added by vikas, 07.12.2011

                      /* Commented by vikas, as k'chatgamol say port sequence# may change
                        so should not join port sequience, 16.11.2011
                        AND FK_PORT_SEQUENCE_NO = p_i_n_old_pol_pcsq
                    */
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      g_v_err_code   := TO_CHAR (SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                      g_v_record_table  := 'Load list Not found in TOS_LL_LOAD_LIST' ;

                      RAISE l_exce_main;
                   WHEN OTHERS THEN
                      g_v_err_code   := TO_CHAR (SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                      g_v_record_table  := 'Error occured.Contact System administrator' ;

                     RAISE l_exce_main;
                END;
                --remove record from load list
                g_v_sql_id := 'SQL-11028';
                PRE_TOS_REMOVE_BKG_LL(p_i_v_booking_no
                                    , NULL
                                    , l_n_load_list_id
                                    , p_o_v_return_status
                                     );
                   IF p_o_v_return_status = '1' THEN
                      g_v_err_code   := TO_CHAR (SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                   RAISE l_exce_main;
                END IF;
             EXCEPTION
                WHEN OTHERS THEN
                   g_v_err_code   := TO_CHAR (SQLCODE);
                   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                   RAISE l_exce_main;
             END;
             BEGIN
                g_v_sql_id := 'SQL-11029';
                g_v_record_filter := 'VVSRVC:' || p_i_v_old_act_service  ||
                                 ' VVVESS:' || p_i_v_old_act_vessel                ||
                                 ' VVVOYN'  || p_i_v_old_act_voyage                ||
                                 ' VVPDIR:' || p_i_v_old_act_port_direction        ||
                                 ' VVPCSQ:' || p_i_n_old_act_port_seq              ||
                                 ' VVPCAL:' || p_i_v_old_discharge_port            ||
                                 ' VVTRM1:' || p_i_v_old_to_terminal               ||
                                 ' VVVERS:' || 99                                  ||
                                 ' OMMISSION_FLAG: IS NULL';
                l_i_v_invoyageno := NULL;
                IF ((p_i_v_old_act_service = 'AFS') OR
                    (p_i_v_old_act_service = 'DFS')) THEN  -- *1
                   l_i_v_invoyageno := p_i_v_old_act_voyage;
                ELSE
                   --get invoyage number from ITP063.
                    BEGIN
                        SELECT INVOYAGENO
                        INTO l_i_v_invoyageno
                        FROM ITP063
                        WHERE VVSRVC = p_i_v_old_act_service
                        AND VVVESS   = p_i_v_old_act_vessel
                        AND VVVOYN   = p_i_v_old_act_voyage
                        AND VVPDIR   = p_i_v_old_act_port_direction
                        AND VVPCSQ   = p_i_n_old_act_port_seq
                        AND VVPCAL   = p_i_v_old_discharge_port
                        AND VVTRM1   = p_i_v_old_to_terminal
                        AND VVVERS   = 99
                        -- AND VVFORL IS NOT NULL; -- Added as suggested by k'chatgamol and k'sukit, 28.02.2012 -- *6
                        AND (VVSRVC = 'DFS' OR VVFORL IS NOT NULL)  -- *6
                        AND ACT_DMY_FLG = 'A'; -- Added by vikas, as suggested by k'sukit and k'chatgamol, 16.1.2011
                        --AND OMMISSION_FLAG IS NULL;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        /* When invoyage not found then do not throw any exception and continue the execution *
                         g_v_err_code   := TO_CHAR (SQLCODE);
                         g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                         g_v_record_table  := 'INVOYAGENO Not found in ITP063' ;

                         RAISE l_exce_main;
                        */
                        NULL;
                      WHEN OTHERS THEN
                         g_v_err_code   := TO_CHAR (SQLCODE);
                         g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                         g_v_record_table  := 'Error occured.Contact System administrator' ;

                         RAISE l_exce_main;
                   END;
                END IF;
                BEGIN
                    g_v_sql_id := 'SQL-11030';
                    g_v_record_filter :=    'FK_SERVICE:'           || p_i_v_old_act_service            ||
                                            'FK_VESSEL:'            || p_i_v_old_act_vessel            ||
                                            'FK_VOYAGE:'            || l_i_v_invoyageno                ||
                                            'FK_DIRECTION:'         || p_i_v_old_act_port_direction    ||
                                            'DN_PORT:'              || p_i_v_old_discharge_port        ||
                                            'FK_PORT_SEQUENCE_NO :' || p_i_n_old_act_port_seq          ||
                                            'DN_TERMINAL :'         || p_i_v_old_to_terminal           ||
                                            'RECORD_STATUS:A';
                    /* if invoyage found in ITP063 Table.*/
                    IF l_i_v_invoyageno IS NOT NULL THEN
                        SELECT PK_DISCHARGE_LIST_ID
                        INTO l_n_DISCHARGE_LIST_ID
                        FROM TOS_DL_DISCHARGE_LIST
                        WHERE FK_SERVICE        = p_i_v_old_act_service
                        AND FK_VESSEL           = p_i_v_old_act_vessel
                        AND FK_VOYAGE           = l_i_v_invoyageno
                        AND FK_DIRECTION        = p_i_v_old_act_port_direction
                        AND DN_PORT             = p_i_v_old_discharge_port
                        AND DN_TERMINAL         = p_i_v_old_to_terminal   -- added by vikas, 28.11.2011
                        AND RECORD_STATUS       = 'A'
                        AND ROWNUM = 1 ; -- Added by vikas, 07.12.2011

                        /* Commented by vikas, as k'chatgamol say port sequence# may change
                            so should not join port sequience, 16.11.2011
                                AND FK_PORT_SEQUENCE_NO = p_i_n_old_act_port_seq
                        */

                    ELSE
                        /* if invoyage details is already deleted from ITP063 Table.*/
                        SELECT DISTINCT DL.PK_DISCHARGE_LIST_ID
                        INTO l_n_DISCHARGE_LIST_ID
                        FROM TOS_DL_DISCHARGE_LIST DL,
                             TOS_DL_BOOKED_DISCHARGE BKD
                        WHERE
                        /* Start commented by vikas, as suggested by K'Chatgamol, 14.11.2011*/
                        /*  DL.FK_SERVICE           = p_i_v_old_act_service
                        AND DL.FK_VESSEL            = p_i_v_old_act_vessel
                        AND DL.FK_DIRECTION         = p_i_v_old_act_port_direction
                        AND DL.FK_PORT_SEQUENCE_NO  = p_i_n_old_act_port_seq
                        AND  End commented by vikas*/
                            DL.DN_PORT              = p_i_v_old_discharge_port
                        AND DL.RECORD_STATUS        = 'A'
                        AND DL.PK_DISCHARGE_LIST_ID = BKD.FK_DISCHARGE_LIST_ID
                        AND BKD.FK_BOOKING_NO       = p_i_v_booking_no
                        AND DL.DN_TERMINAL          = p_i_v_old_to_terminal
                        AND DL.RECORD_STATUS        = 'A'
                        AND BKD.RECORD_STATUS       = 'A'
                        and rownum = 1 ; -- added 08.12.2011
                    END IF;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      g_v_err_code   := TO_CHAR (SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);

                      g_v_record_table  := 'Discharge List Not found in TOS_DL_DISCHARGE_LIST' ;

                      RAISE l_exce_main;
                   WHEN OTHERS THEN
                      g_v_err_code   := TO_CHAR (SQLCODE);
                      g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                      g_v_record_table  := 'Error occured.Contact System administrator';
                      RAISE l_exce_main;
                END;
                --remove record from discharge list
                g_v_sql_id := 'SQL-11031';
                PRE_TOS_REMOVE_BKG_DL(p_i_v_booking_no
                                    , NULL
                                    , l_n_discharge_list_id
                                    , p_o_v_return_status
                                     );
                IF p_o_v_return_status = '1' THEN
                   g_v_err_code   := TO_CHAR (SQLCODE);
                   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                   RAISE l_exce_main;
                END IF;
             EXCEPTION
                WHEN OTHERS THEN
                  g_v_err_code   := TO_CHAR (SQLCODE);
                  g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                   g_v_record_table  := 'Error occured.Contact System administrator';
                  RAISE l_exce_main;
             END;
          END IF;
          --for routing leg insert
          IF p_i_v_record_status='A' THEN
             --create new load list
             BEGIN
                g_v_sql_id := 'SQL-11032';
                PRE_TOS_CREATE_LOAD_LIST(p_i_v_booking_no
                                       , p_i_n_voyage_seq_no
                                       , NULL
                                       , NULL
                                       , NULL
                                       , NULL
                                       , p_o_v_return_status
                                        );
                IF p_o_v_return_status = '1' THEN
                   g_v_err_code   := TO_CHAR (SQLCODE);
                   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                   RAISE l_exce_main;
                END IF;
             EXCEPTION
                WHEN OTHERS THEN
                   g_v_err_code   := TO_CHAR (SQLCODE);
                   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                   RAISE l_exce_main;
             END;
             --create new discharge list
             BEGIN
                g_v_sql_id := 'SQL-11033';
                PRE_TOS_CREATE_DISCHARGE_LIST(p_i_v_booking_no
                                            , p_i_n_voyage_seq_no
                                            , NULL
                                            , NULL
                                            , NULL
                                            , NULL
                                            , p_o_v_return_status
                                             );
                IF p_o_v_return_status = '1' THEN
                   g_v_err_code   := TO_CHAR (SQLCODE);
                   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                   RAISE l_exce_main;
                END IF;
             EXCEPTION
                WHEN OTHERS THEN
                   g_v_err_code   := TO_CHAR (SQLCODE);
                   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
                   RAISE l_exce_main;
             END;
          END IF; --end if of  routing leg insert
             p_o_v_return_status := '0';
       ELSE
          p_o_v_return_status := '0';
       END IF;
    EXCEPTION
        WHEN l_exce_main THEN

           p_o_v_return_status := '1';
           ROLLBACK;

            /*
                start added by vikas for logging, 13.02.2012
            */
            IF g_v_err_code = '1' OR g_v_err_desc = 'User-Defined Exception' THEN
                g_v_err_code := TO_CHAR(SQLCODE);
                g_v_err_desc := SUBSTR(SQLERRM, 1, 100);
            END IF;
            /*
                End added by vikas, 13.02.2012
            */

           PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                             , 'L102_M'
                             , p_i_v_record_status
                             , substr(g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc, 1, 100)
                             , 'A'
                             , g_v_user
                             , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                             , g_v_user
                             , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                             , g_v_record_filter
                             , g_v_record_table
                              );
        COMMIT;
        WHEN OTHERS THEN
           g_v_sql_id := 'SQL-11034';
           p_o_v_return_status := '1';
           ROLLBACK;
           PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                             , 'L102_O'
                             , p_i_v_record_status
                             , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                             , 'A'
                             , g_v_user
                             , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                             , g_v_user
                             , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                             , g_v_record_filter
                             , g_v_record_table
                              );
        COMMIT;
    END PRE_TOS_ROUTING_UPDATE;

    PROCEDURE PRE_TOS_EQUIPMENT_UPDATE
    (
      p_i_v_booking_no         IN   VARCHAR2
    , p_i_n_equipment_seq_no   IN   NUMBER
    , p_i_v_old_equipment_no   IN   VARCHAR2
    , p_i_v_new_equipment_no   IN   VARCHAR2
    , p_i_n_overheight         IN   NUMBER
    , p_i_n_overlength_rear    IN   NUMBER
    , p_i_n_overlength_front   IN   NUMBER
    , p_i_n_overwidth_left     IN   NUMBER
    , p_i_n_overwidth_right    IN   NUMBER
    , p_i_v_imdg               IN   VARCHAR2
    , p_i_v_unno               IN   VARCHAR2
    , p_i_v_un_var             IN   VARCHAR2
    , p_i_v_flash_point        IN   VARCHAR2
    , p_i_n_flash_unit         IN   VARCHAR2
    , p_i_n_reefer_tmp         IN   VARCHAR2
    , p_i_v_reefer_tmp_unit    IN   VARCHAR2
    , p_i_n_humidity           IN   NUMBER
    , p_i_n_ventilation        IN   NUMBER
    , P_I_V_USER_ID            IN   VARCHAR2 -- *19
    , P_I_V_WEIGHT             IN NUMBER --*30
    , P_I_V_VGM_CATEGORY       IN VARCHAR2 -- *30
    , P_I_V_VGM                IN NUMBER --*31
    , p_o_v_return_status      OUT NOCOPY  VARCHAR2
    ) IS

    /********************************************************************************
    * Name           : PRE_TOS_EQUIPMENT_UPDATE                                     *
    * Module         : EZLL                                                         *
    * Purpose        : To Update data in load list and discharge list whenever above
                       parameters are going to change.This procedure is called
                        by Handler                                                   *
    * Calls          : PRE_TOS_TEMP_CONT_REMOVAL,PRE_TOS_CREATE_LOAD_LIST                                                         *
    * Returns        : NONE                                                         *
    * Steps Involved :                                                              *
    * History        : None                                                         *
    *  Author          Date               What
       ------          ----               ----
       Rajat           13/01/2010          1.0                                      *
    *********************************************************************************/


    l_v_booking_stat      VARCHAR2(1);
    l_v_cntr_replace_flg  VARCHAR2(1);
    l_n_cntr_rec          NUMBER;
    l_v_terminal          VARCHAR2(17);
    l_v_rep_typ           VARCHAR2(1);
    l_v_rep_terminal      VARCHAR2(17);
    l_v_subsequent_ter    VARCHAR2(100);
    l_v_portclass         VARCHAR2(5);
    l_v_portclass_type    VARCHAR2(5);
    l_n_ll_vouge_seq_no   NUMBER;
    l_n_dl_vouge_seq_no   NUMBER;
    l_v_dis_ter           VARCHAR2(5);
    l_n_count             NUMBER := 0;
    l_v_time              TIMESTAMP;
    l_v_parameter_str     VARCHAR2(500);
    l_exce_main           EXCEPTION;
    l_n_size_type_seq_no  NUMBER;
    l_n_supplier_seq_no   NUMBER;
    l_v_soc_coc_flg       VARCHAR2(1);

    l_n_discharge_list_status TOS_DL_DISCHARGE_LIST.DISCHARGE_LIST_STATUS%TYPE; --Added by Rajeev on 04/04/2011
    p_o_v_error         VARCHAR2(100);

    L_V_IS_UPDATE_DG VARCHAR2(5); -- *21
    IS_ALREADY_SEND       VARCHAR2(5) := FALSE; /* *24 start */

    l_v_err_msg varchar2(4000) := SQLERRM;

    l_v_is_equipment_found    VARCHAR2(1); -- Added by vikas, 23.02.2012
    L_V_LIST_STATUS VARCHAR2(2) ;/* *23 */
    l_n_found           NUMBER:=0; --*28

    CURSOR terminal_dtl IS
       SELECT TO_TERMINAL
       FROM (
           SELECT  FROM_TERMINAL TO_TERMINAL
                 , VOYAGE_SEQNO
                 , 1 SN
           FROM BOOKING_VOYAGE_ROUTING_DTL
           WHERE BOOKING_NO  = p_i_v_booking_no
           UNION ALL
           SELECT  TO_TERMINAL
                 , VOYAGE_SEQNO
                 , 2 SN
           FROM BOOKING_VOYAGE_ROUTING_DTL
           WHERE BOOKING_NO  = p_i_v_booking_no
            )
       ORDER BY VOYAGE_SEQNO, SN;

    CURSOR l_cur_load_list IS
       SELECT BL.FK_LOAD_LIST_ID
            , BL.LOADING_STATUS
            , LL.LOAD_LIST_STATUS
            , NVL(BL.PREADVICE_FLAG,'N') PREADVICE_FLAG
            , LL.PK_LOAD_LIST_ID
            , BL.PK_BOOKED_LOADING_ID
            , LL.DN_TERMINAL
            , BL.FK_BKG_VOYAGE_ROUTING_DTL
            , LL.DN_PORT
            , BL.DAMAGED --added by bindu on 15/04/2011.
       FROM TOS_LL_BOOKED_LOADING BL,
            TOS_LL_LOAD_LIST      LL
       WHERE LL.PK_LOAD_LIST_ID      = BL.FK_LOAD_LIST_ID
       AND   BL.FK_BOOKING_NO        = p_i_v_booking_no
       AND   BL.FK_BKG_EQUIPM_DTL    = p_i_n_equipment_seq_no
       AND   BL.RECORD_STATUS        = 'A' ;

    CURSOR l_cur_discharge_list IS
       SELECT BD.FK_DISCHARGE_LIST_ID
            , BD.DISCHARGE_STATUS
            , DL.PK_DISCHARGE_LIST_ID
            , BD.PK_BOOKED_DISCHARGE_ID
            , DL.DISCHARGE_LIST_STATUS
            , DL.DN_TERMINAL
            , BD.FK_BKG_VOYAGE_ROUTING_DTL
            , DL.DN_PORT
            , BD.DAMAGED  --added by bindu on 15/04/2011.
       FROM TOS_DL_BOOKED_DISCHARGE BD,
            TOS_DL_DISCHARGE_LIST   DL
       WHERE DL.PK_DISCHARGE_LIST_ID    = BD.FK_DISCHARGE_LIST_ID
       AND   BD.FK_BOOKING_NO           = p_i_v_booking_no
       AND   BD.FK_BKG_EQUIPM_DTL       = p_i_n_equipment_seq_no
       AND   BD.RECORD_STATUS           = 'A' ;


    BEGIN
       l_v_parameter_str := p_i_v_booking_no       ||'~'||
                            p_i_n_equipment_seq_no ||'~'||
                            p_i_v_old_equipment_no ||'~'||
                            p_i_v_new_equipment_no ||'~'||
                            p_i_n_overheight       ||'~'||
                            p_i_n_overlength_rear  ||'~'||
                            p_i_n_overlength_front ||'~'||
                            p_i_n_overwidth_left   ||'~'||
                            p_i_n_overwidth_right  ||'~'||
                            p_i_v_imdg             ||'~'||
                            p_i_v_unno             ||'~'||
                            p_i_v_un_var           ||'~'||
                            p_i_v_flash_point      ||'~'||
                            p_i_n_flash_unit       ||'~'||
                            p_i_n_reefer_tmp       ||'~'||
                            p_i_v_reefer_tmp_unit  ||'~'||
                            p_i_n_humidity         ||'~'||
                            p_i_n_ventilation      ||'~'||
                            P_I_V_WEIGHT           ||'~'|| --*30
                            P_I_V_VGM_CATEGORY     ||'~'||--*30
                            P_I_V_VGM              --*31
                            ;

        g_v_sql_id := 'SQL-1001_1';

        BEGIN
                  SELECT CNTR.SUPPLIER_SQNO
                , SEQ_NO.EQP_SIZETYPE_SEQNO
            INTO
                  l_n_supplier_seq_no
                , l_n_size_type_seq_no
            FROM BKP009 CNTR,
                (SELECT BOOKING_NO,SUPPLIER_SQNO,EQP_SIZETYPE_SEQNO FROM BOOKING_SUPPLIER_DETAIL SP
                WHERE EXISTS (SELECT 'X' FROM BKP032 SZ
                WHERE SP.BOOKING_NO       = SZ.BCBKNO
                AND SP.EQP_SIZETYPE_SEQNO = SZ.EQP_SIZETYPE_SEQNO
                )) SEQ_NO
            WHERE CNTR.BIBKNO      = SEQ_NO.BOOKING_NO
            AND CNTR.SUPPLIER_SQNO = SEQ_NO.SUPPLIER_SQNO
            AND CNTR.BISEQN        = p_i_n_equipment_seq_no
            AND CNTR.BIBKNO        = p_i_v_booking_no;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                g_v_record_filter := 'BOOKING_NO:'|| p_i_v_booking_no || ' EQUIPMENT_SEQ_NO: '||p_i_n_equipment_seq_no ;
                g_v_record_table  := 'Supplier seq no and size type seq no not found in BKP009' ;
                RAISE l_exce_main;

            WHEN OTHERS THEN
                g_v_record_filter := 'BOOKING_NO:'|| p_i_v_booking_no || ' EQUIPMENT_SEQ_NO: '||p_i_n_equipment_seq_no ;
                g_v_record_table  := 'Error occured.Contact System administrator' ;
                RAISE l_exce_main;
        END;


       l_v_time:= SYSDATE ; -- CURRENT_TIMESTAMP; --*12

       g_v_sql_id := 'SQL-10001';
       BEGIN
          SELECT BASTAT, BABKTP
          INTO l_v_booking_stat, l_v_soc_coc_flg
          FROM BKP001
          WHERE BABKNO = p_i_v_booking_no;
       EXCEPTION
          WHEN OTHERS THEN

             g_v_record_filter := 'BOOKING_NO:'|| p_i_v_booking_no  ;
             g_v_record_table  := 'BASTAT Not found in BKP001' ;

             RAISE l_exce_main;
       END;
       IF l_v_booking_stat IN ('L','P','C') THEN
       --------------------------------------UPDATION OF LOAD LIST STARTS----------------------------
       g_v_sql_id := 'SQL-10002';

       BEGIN
             SELECT TERMINAL, REPLACEMENT_TYPE, 'Y' CONT_REPL_FLG
             INTO l_v_terminal, l_v_rep_typ, l_v_cntr_replace_flg
                 FROM BKG_CONTAINER_REPLACEMENT
             WHERE  PK_CONTAINER_REPLACEMENT_ID = (SELECT NVL(MAX(PK_CONTAINER_REPLACEMENT_ID), 0)
                FROM BKG_CONTAINER_REPLACEMENT
             WHERE FK_BOOKING_NO    = p_i_v_booking_no
             AND   NEW_EQUIPMENT_NO = p_i_v_new_equipment_no
                AND   RECORD_STATUS    = 'A');
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                l_v_cntr_replace_flg := 'N';
                l_v_terminal         := NULL;
                l_v_rep_typ          := NULL;

--                g_v_record_filter := 'FK_BOOKING_NO:'    ||p_i_v_booking_no ||
--                                     ' NEW_EQUIPMENT_NO:' ||p_i_v_new_equipment_no ||
--                                     ' RECORD_STATUS = A';
--                g_v_record_table  := 'Terminal, replacement type Not found in BKG_CONTAINER_REPLACEMENT' ;

             WHEN OTHERS THEN
                g_v_record_filter :=  'FK_BOOKING_NO:'    ||p_i_v_booking_no ||
                                      ' NEW_EQUIPMENT_NO:' ||p_i_v_new_equipment_no ||
                                      ' RECORD_STATUS = A';
                g_v_record_table  := 'Error occured.Contact System administrator' ;
                RAISE l_exce_main;
          END;
          g_v_sql_id := 'SQL-10004';
          BEGIN
             SELECT COUNT(1)
             INTO l_n_cntr_rec
             FROM BKG_CONTAINER_REPLACEMENT
             WHERE FK_BOOKING_NO    = p_i_v_booking_no
             AND   NEW_EQUIPMENT_NO = p_i_v_new_equipment_no
             AND   RECORD_STATUS    = 'A';
          EXCEPTION
             WHEN OTHERS THEN

                g_v_record_filter := 'FK_BOOKING_NO:'    ||p_i_v_booking_no ||
                                     ' NEW_EQUIPMENT_NO:' ||p_i_v_new_equipment_no ||
                                     ' RECORD_STATUS = A';
                g_v_record_table  := 'Records Not found in BKG_CONTAINER_REPLACEMENT' ;

                RAISE l_exce_main;
          END;
          g_v_sql_id := 'SQL-10005';
          IF l_v_cntr_replace_flg = 'Y' THEN
             --COC Container Replacement(l_v_rep_typ = '1'  )
             IF l_v_rep_typ  IN ('1' ,'3') THEN --added replace ment type 3 on 18/10/2010 by bindu.
                FOR terminal_dtl_data IN terminal_dtl
                LOOP
                   IF l_n_count = 0 THEN
                      IF terminal_dtl_data.TO_TERMINAL = l_v_terminal THEN
                         l_v_rep_terminal :=  l_v_terminal;
                         l_n_count   :=  l_n_count + 1;
                      END IF;
                   ELSE
                      IF l_n_count = 1 THEN
                         l_v_subsequent_ter := terminal_dtl_data.TO_TERMINAL;
                         l_n_count          := l_n_count + 1;
                      ELSE
                         l_v_subsequent_ter := '`'||terminal_dtl_data.TO_TERMINAL;
                         l_n_count          := l_n_count + 1;
                      END IF;
                   END IF;
                END LOOP;
                l_n_count := 0;
             ELSIF l_v_rep_typ = '2' THEN
                --SOC Container Replacement(l_v_rep_typ = '2'  )
                l_v_rep_terminal := 'ALL';
             END IF;

          END IF;
        ------------updating load list  ----------------
          g_v_sql_id := 'SQL-10006';
          IF p_i_v_old_equipment_no IS NULL AND p_i_v_new_equipment_no  IS NOT NULL THEN
          
          
             UPDATE TOS_LL_BOOKED_LOADING
             SET DN_EQUIPMENT_NO        = p_i_v_new_equipment_no
               , RECORD_CHANGE_USER     = g_v_user
               , RECORD_CHANGE_DATE     = l_v_time
             WHERE FK_BOOKING_NO        = p_i_v_booking_no
             AND   FK_BKG_EQUIPM_DTL    = p_i_n_equipment_seq_no
             AND   RECORD_STATUS        = 'A';

             --UPDATE  Booking No. in EMS start
        /*     Comented by vikas, 01.12.2011 */ -- *7
            g_v_sql_id := 'SQL-10006A';
            IF l_v_soc_coc_flg = 'C' THEN
                BEGIN
                    PCE_ECM_EMS.PRE_UPDATE_EMS_BKG(p_i_v_booking_no,p_i_v_new_equipment_no,p_o_v_return_status);

                    IF p_o_v_return_status = '1' THEN
                        g_v_err_desc :='EMS Update Error.';
                        -- RAISE l_exce_main; -- *14
                    END IF;
                EXCEPTION
                    WHEN OTHERS THEN

                    g_v_err_desc :='EMS Update Error.';
                    -- RAISE l_exce_main; -- *14
                END;
            END IF;
             --UPDATE  Booking No. in EMS End
        /* end commented by vikas 01.12.2011 */ -- *7


          END IF;

          l_v_is_equipment_found := NULL; -- Added by vikas, 23.02.2012

          FOR l_cur_load_list_data IN l_cur_load_list
          LOOP
                l_v_is_equipment_found := 'Y'; -- Added by vikas, 23.02.2012

                IF p_i_v_old_equipment_no IS NOT NULL AND
                ((p_i_v_new_equipment_no IS NULL) OR
                 (p_i_v_new_equipment_no IS NOT NULL  AND p_i_v_old_equipment_no <> p_i_v_new_equipment_no)) THEN
                g_v_sql_id := 'SQL-10007';
                

                
                 IF l_v_cntr_replace_flg = 'N' THEN
                    g_v_sql_id := 'SQL-10008';

                    IF l_cur_load_list_data.LOADING_STATUS IN ('SS','BK')  AND l_cur_load_list_data.PREADVICE_FLAG = 'N' THEN
                       UPDATE TOS_LL_BOOKED_LOADING
                       SET DN_EQUIPMENT_NO     = p_i_v_new_equipment_no
                         , RECORD_CHANGE_USER  = g_v_user
                         , RECORD_CHANGE_DATE  = l_v_time
                       WHERE FK_BOOKING_NO        = p_i_v_booking_no
                       AND   FK_BKG_EQUIPM_DTL    = p_i_n_equipment_seq_no
                       AND   PK_BOOKED_LOADING_ID = l_cur_load_list_data.PK_BOOKED_LOADING_ID
                       AND   RECORD_STATUS        = 'A';

                    ELSIF l_cur_load_list_data.LOADING_STATUS IN ('LO','RB')  THEN
                       BEGIN
                          g_v_sql_id := 'SQL-10009';
                          PRE_TOS_TEMP_CONT_REMOVAL(p_i_v_booking_no
                                                  , l_cur_load_list_data.FK_LOAD_LIST_ID
                                                  , l_cur_load_list_data.PK_BOOKED_LOADING_ID
                                                  , l_cur_load_list_data.PREADVICE_FLAG
                                                  , 'L'
                                                  , p_o_v_return_status
                                                   );
                       IF p_o_v_return_status = '1' THEN
                          RAISE l_exce_main;
                       END IF;
                       EXCEPTION
                          WHEN OTHERS THEN
                             RAISE l_exce_main;
                       END;
                      -----EMS API TO BE ADDED starts-----------------
                                                  -- IF l_n_ll_id >= 10 THEN
                                                   --             NULL;
                                                     --               END IF;
                      -----EMS API TO BE ADDED ends-----------------

                      BEGIN
                         g_v_sql_id := 'SQL-10010';
                         PRE_TOS_CREATE_LOAD_LIST(p_i_v_booking_no
                                                , l_cur_load_list_data.FK_BKG_VOYAGE_ROUTING_DTL
                                                , l_cur_load_list_data.FK_LOAD_LIST_ID
                                                , p_i_n_equipment_seq_no
                                                , l_n_size_type_seq_no
                                                , l_n_supplier_seq_no
                                                , p_o_v_return_status
                                                 );
                      IF p_o_v_return_status = '1' THEN
                         RAISE l_exce_main;
                      END IF;
                      EXCEPTION
                         WHEN OTHERS THEN
                            RAISE l_exce_main;
                      END;

                    ELSIF l_cur_load_list_data.LOADING_STATUS = 'BK' AND l_cur_load_list_data.PREADVICE_FLAG = 'Y' THEN
                        g_v_sql_id := 'SQL-10011';
                        BEGIN
                           PRE_TOS_TEMP_CONT_REMOVAL(p_i_v_booking_no
                                                   , l_cur_load_list_data.FK_LOAD_LIST_ID
                                                   , l_cur_load_list_data.PK_BOOKED_LOADING_ID
                                                   , l_cur_load_list_data.PREADVICE_FLAG
                                                   , 'L'  ---------load list
                                                   , p_o_v_return_status
                                                    );
                            IF p_o_v_return_status = '1' THEN
                               RAISE l_exce_main;
                            END IF;
                        EXCEPTION
                           WHEN OTHERS THEN
                              RAISE l_exce_main;
                        END;

                        g_v_sql_id := 'SQL-10012';
                          BEGIN
                             PRE_TOS_CREATE_LOAD_LIST(p_i_v_booking_no
                                                    , l_cur_load_list_data.FK_BKG_VOYAGE_ROUTING_DTL
                                                    , l_cur_load_list_data.FK_LOAD_LIST_ID
                                                    , p_i_n_equipment_seq_no
                                                    , l_n_size_type_seq_no
                                                    , l_n_supplier_seq_no
                                                    , p_o_v_return_status
                                                      );
                              IF p_o_v_return_status = '1' THEN
                                 RAISE l_exce_main;
                              END IF;
                          EXCEPTION
                             WHEN OTHERS THEN
                                RAISE l_exce_main;
                          END;
                    END IF;
                    -------------
                     --UPDATE  Booking No. in EMS start
                     /* Commented by vikas, 01.12.2011 */ -- *7
                     g_v_sql_id := 'SQL-10012A';
                     IF l_v_soc_coc_flg = 'C' AND p_i_v_new_equipment_no IS NOT NULL THEN
                         BEGIN
                            PCE_ECM_EMS.PRE_UPDATE_EMS_BKG(p_i_v_booking_no,p_i_v_new_equipment_no,p_o_v_return_status);
                            IF p_o_v_return_status = '1' THEN
                                g_v_err_desc :='EMS Update Error.';
                                -- RAISE l_exce_main; -- *14
                            END IF;
                         EXCEPTION
                             WHEN OTHERS THEN
                             g_v_err_desc :='EMS Update Error.';
                             -- RAISE l_exce_main; -- *14
                         END;
                     END IF;
                     --UPDATE  Booking No. in EMS End

                     /* Commented by vikas, 01.12.2011 */ -- *7
                    --------
                 ELSE
                    --When  Container replcaement=Yes
                    g_v_sql_id := 'SQL-10013';
                    --COC Container Replacement(l_v_rep_typ = '1'  )
                    IF l_v_rep_typ = '1' OR (l_v_rep_typ = '3') THEN --added replace ment type 3 on 18/10/2010 by bindu.
                      IF (l_cur_load_list_data.DN_TERMINAL = l_v_rep_terminal)
                         OR INSTR(l_v_subsequent_ter,l_cur_load_list_data.DN_TERMINAL) > 0  THEN

                         UPDATE TOS_LL_BOOKED_LOADING
                         SET DN_EQUIPMENT_NO        = p_i_v_new_equipment_no
                           , RECORD_CHANGE_USER     = g_v_user
                           , RECORD_CHANGE_DATE     = l_v_time
                         WHERE FK_BOOKING_NO        = p_i_v_booking_no
                         AND   FK_BKG_EQUIPM_DTL    = p_i_n_equipment_seq_no
                         AND   FK_LOAD_LIST_ID      = l_cur_load_list_data.FK_LOAD_LIST_ID
                         AND   PK_BOOKED_LOADING_ID = l_cur_load_list_data.PK_BOOKED_LOADING_ID
                         AND   RECORD_STATUS        = 'A';
                      END IF;
                    ELSIF l_v_rep_typ = '2' THEN
                    --SOC Container Replacement(l_v_rep_typ = '2'  )
                         g_v_sql_id := 'SQL-10014';
                         UPDATE TOS_LL_BOOKED_LOADING
                         SET DN_EQUIPMENT_NO        = p_i_v_new_equipment_no
                           , RECORD_CHANGE_USER     = g_v_user
                           , RECORD_CHANGE_DATE     = l_v_time
                         WHERE FK_BOOKING_NO        = p_i_v_booking_no
                         AND   FK_BKG_EQUIPM_DTL    = p_i_n_equipment_seq_no
                         AND   FK_LOAD_LIST_ID      = l_cur_load_list_data.FK_LOAD_LIST_ID
                         AND   PK_BOOKED_LOADING_ID = l_cur_load_list_data.PK_BOOKED_LOADING_ID
                         AND   RECORD_STATUS        = 'A';
                    END IF;
                 END IF;--end if of Replacement type
             END IF; --end if of equipment no check

             ----------------Get PORT CLASS/Type if applicable------------------
             IF p_i_v_unno IS NOT NULL AND p_i_v_un_var IS NOT NULL  AND p_i_v_imdg  IS NOT NULL THEN
               BEGIN

                 SELECT PORT_CLASS_CODE, PORT_CLASS_TYPE
                 INTO l_v_portclass, l_v_portclass_type
                 FROM PORT_CLASS
                 WHERE UNNO          = p_i_v_unno
                 AND VARIANT         = NVL(p_i_v_un_var, '-')  -- Change by vikas, varint can not null, 18.11.2011
                 AND IMDG_CLASS      = p_i_v_imdg
                 AND PORT_CLASS_TYPE IN (SELECT PORT_CLASS_TYPE
                                          FROM PORT_CLASS_TYPE
                                          WHERE PORT_CODE = l_cur_load_list_data.DN_PORT
                                        );
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    l_v_portclass      := NULL;
                    l_v_portclass_type := NULL;

                    --g_v_record_filter := 'UNNO:'|| p_i_v_unno  ||
                    --                     ' VARIANT:'|| p_i_v_un_var ||
                    --                     ' IMDG_CLASS:'|| p_i_v_imdg ;
                    --g_v_record_table  := 'Port Class code Not found in PORT_CLASS' ;

                 WHEN OTHERS THEN
                    l_v_portclass      := NULL;
                    l_v_portclass_type := NULL;

                    --g_v_record_filter := 'UNNO:'|| p_i_v_unno  ||
                    --                     ' VARIANT:'|| p_i_v_un_var ||
                    --                     ' IMDG_CLASS:'|| p_i_v_imdg ;
                    --g_v_record_table  := 'Error occured.Contact System administrator' ;
              END;
             END IF;
             g_v_sql_id := 'SQL-10015';
             --------------------OOG /DG /REEFERDETAL UPDATE----------------------
            IF p_i_n_overheight IS NOT NULL
                OR p_i_n_overlength_rear IS NOT NULL
                OR p_i_n_overlength_front IS NOT NULL
                OR p_i_n_overwidth_left  IS NOT NULL
                OR p_i_n_overwidth_right IS NOT NULL
                --fOR DG
                OR p_i_v_unno IS NOT NULL
                OR p_i_v_un_var IS NOT NULL
                OR p_i_v_flash_point IS NOT NULL
                OR p_i_n_flash_unit IS NOT NULL
                OR p_i_v_imdg  IS NOT NULL
                --fOR REEFER
                OR p_i_n_reefer_tmp  IS NOT NULL
                OR  p_i_v_reefer_tmp_unit  IS NOT NULL
                OR p_i_n_humidity   IS NOT NULL
                OR p_i_n_ventilation IS NOT NULL
                OR P_I_V_WEIGHT IS NOT NULL --*30
                OR P_I_V_VGM_CATEGORY IS NOT NULL --*30
                OR P_I_V_VGM          IS NOT NULL --*31 



                THEN

                    /* *21 start */
                    /* * check whether to update DG info in ezll or not * */
                    g_v_sql_id := 'SQL1015-1';
                    BEGIN
                        L_V_IS_UPDATE_DG := FALSE;
                        SELECT
                            FN_CAN_UPDATE_DG (
                                DN_SPECIAL_HNDL,
                                DN_EQ_TYPE
                            ) AS "IS_UPDATE_DG"
                        INTO
                            L_V_IS_UPDATE_DG
                        FROM
                            TOS_LL_BOOKED_LOADING
                        WHERE
                            FK_BOOKING_NO = p_i_v_booking_no
                            AND FK_BKG_EQUIPM_DTL = p_i_n_equipment_seq_no
                            AND PK_BOOKED_LOADING_ID = l_cur_load_list_data.PK_BOOKED_LOADING_ID
                            AND NVL(PREADVICE_FLAG,'N') = 'N'
                            AND LOADING_STATUS = 'BK'
                            AND RECORD_STATUS = 'A';

                    EXCEPTION
                        WHEN OTHERS THEN NULL;
                    END;
                    /* *21 end */
                    g_v_sql_id := 'SQL1015-2';
                    IF ((P_I_V_USER_ID = 'EZLL') AND (L_V_IS_UPDATE_DG = TRUE)) THEN -- *19, -- *21
                        /* * if user is ezll means booking updated by maintenance screen
                            * so update DG details also in ezll table. * */
                        g_v_sql_id := 'SQL1015-3';

                        select count(1) into l_n_found from TOS_LL_LOAD_LIST where DN_port='HKHKG' and PK_LOAD_LIST_ID = l_cur_load_list_data.PK_LOAD_LIST_ID; -- *28


                        UPDATE TOS_LL_BOOKED_LOADING
                        SET OVERHEIGHT_CM           = NVL2(p_i_n_overheight,p_i_n_overheight,OVERHEIGHT_CM)
                        , OVERLENGTH_REAR_CM        = NVL2(p_i_n_overlength_rear,p_i_n_overlength_rear,OVERLENGTH_REAR_CM)
                        , OVERLENGTH_FRONT_CM       = NVL2(p_i_n_overlength_front,p_i_n_overlength_front,OVERLENGTH_FRONT_CM)
                        , OVERWIDTH_LEFT_CM         = NVL2(p_i_n_overwidth_left, p_i_n_overwidth_left,OVERWIDTH_LEFT_CM)
                        , OVERWIDTH_RIGHT_CM        = NVL2(p_i_n_overwidth_right,p_i_n_overwidth_right,OVERWIDTH_RIGHT_CM)
                        -- , FK_UNNO                   = DECODE(p_i_v_unno,'~',NULL,NVL2(p_i_v_unno,p_i_v_unno,FK_UNNO)) *28
                        -- , FK_UN_VAR                 = DECODE(p_i_v_un_var,'~',NULL,NVL2(p_i_v_un_var,p_i_v_un_var,FK_UN_VAR)) *28
                        -- , FK_IMDG                   = DECODE(p_i_v_imdg,'~',NULL,NVL2(p_i_v_imdg,p_i_v_imdg,FK_IMDG)) *28
                        ,FK_UNNO = CASE WHEN l_n_found=0 THEN DECODE(p_i_v_unno,'~',NULL,NVL2(p_i_v_unno,p_i_v_unno,FK_UNNO)) ELSE FK_UNNO END -- *28
                        , FK_IMDG = CASE WHEN l_n_found=0 THEN DECODE(p_i_v_imdg,'~',NULL,NVL2(p_i_v_imdg,p_i_v_imdg,FK_IMDG))ELSE FK_IMDG END -- *28
                        , FK_UN_VAR = CASE WHEN l_n_found=0 THEN DECODE(p_i_v_un_var,'~',NULL,NVL2(p_i_v_un_var,p_i_v_un_var,FK_UN_VAR)) ELSE FK_UN_VAR END -- *28

                        , FLASH_POINT               = DECODE(p_i_v_flash_point,'~',NULL,NVL2(p_i_v_flash_point,p_i_v_flash_point,FLASH_POINT))
                        , FLASH_UNIT                = DECODE(p_i_n_flash_unit,'~',NULL,NVL2(p_i_n_flash_unit,p_i_n_flash_unit,FLASH_UNIT))
                        , REEFER_TMP                = DECODE(p_i_n_reefer_tmp,'~',NULL,NVL2(p_i_n_reefer_tmp,p_i_n_reefer_tmp,REEFER_TMP))
                        , REEFER_TMP_UNIT           = DECODE(p_i_v_reefer_tmp_unit,'~',NULL,NVL2(p_i_v_reefer_tmp_unit,p_i_v_reefer_tmp_unit,REEFER_TMP_UNIT))
                        , DN_HUMIDITY               = NVL2(p_i_n_humidity,p_i_n_humidity,DN_HUMIDITY)
                        , DN_VENTILATION            = NVL2(P_I_N_VENTILATION,P_I_N_VENTILATION,DN_VENTILATION)
                        --, FK_PORT_CLASS             = NVL2(l_v_portclass,l_v_portclass,FK_PORT_CLASS) -- *26
                        , FK_PORT_CLASS_TYP         = NVL2(l_v_portclass_type,l_v_portclass_type,FK_PORT_CLASS_TYP)
                        , RECORD_CHANGE_USER        = g_v_user
                        , RECORD_CHANGE_DATE        = l_v_time
                        -- START *30
                        , CONTAINER_GROSS_WEIGHT = NVL2(P_I_V_WEIGHT,P_I_V_WEIGHT,CONTAINER_GROSS_WEIGHT)
                        ,CATEGORY_CODE = NVL2(P_I_V_VGM_CATEGORY,P_I_V_VGM_CATEGORY,CATEGORY_CODE)
                        -- END *30
                        , VGM = NVL2(P_I_V_VGM,P_I_V_VGM,VGM) --*31
                        WHERE FK_BOOKING_NO           = p_i_v_booking_no
                        AND   FK_BKG_EQUIPM_DTL       = p_i_n_equipment_seq_no
                        AND   PK_BOOKED_LOADING_ID    = l_cur_load_list_data.PK_BOOKED_LOADING_ID
                        AND   NVL(PREADVICE_FLAG,'N') = 'N'
                        AND   LOADING_STATUS          = 'BK'
                        AND   RECORD_STATUS           = 'A';

                    ELSE  -- *19

                        g_v_sql_id := 'SQL1015-4';
                        /* * *19 start * */

                        /* * if user is not ezll means booking updated by booking user
                            * so no need to update DG details also in ezll table. * */
                        UPDATE TOS_LL_BOOKED_LOADING
                        SET OVERHEIGHT_CM             = NVL2(p_i_n_overheight,p_i_n_overheight,OVERHEIGHT_CM)
                        , OVERLENGTH_REAR_CM        = NVL2(p_i_n_overlength_rear,p_i_n_overlength_rear,OVERLENGTH_REAR_CM)
                        , OVERLENGTH_FRONT_CM       = NVL2(p_i_n_overlength_front,p_i_n_overlength_front,OVERLENGTH_FRONT_CM)
                        , OVERWIDTH_LEFT_CM         = NVL2(p_i_n_overwidth_left, p_i_n_overwidth_left,OVERWIDTH_LEFT_CM)
                        , OVERWIDTH_RIGHT_CM        = NVL2(p_i_n_overwidth_right,p_i_n_overwidth_right,OVERWIDTH_RIGHT_CM)
                        , FLASH_POINT               = DECODE(p_i_v_flash_point,'~',NULL,NVL2(p_i_v_flash_point,p_i_v_flash_point,FLASH_POINT))
                        , FLASH_UNIT                = DECODE(p_i_n_flash_unit,'~',NULL,NVL2(p_i_n_flash_unit,p_i_n_flash_unit,FLASH_UNIT))
                        , REEFER_TMP                = DECODE(p_i_n_reefer_tmp,'~',NULL,NVL2(p_i_n_reefer_tmp,p_i_n_reefer_tmp,REEFER_TMP))
                        , REEFER_TMP_UNIT           = DECODE(p_i_v_reefer_tmp_unit,'~',NULL,NVL2(p_i_v_reefer_tmp_unit,p_i_v_reefer_tmp_unit,REEFER_TMP_UNIT))
                        , DN_HUMIDITY               = NVL2(p_i_n_humidity,p_i_n_humidity,DN_HUMIDITY)
                        , DN_VENTILATION            = NVL2(p_i_n_ventilation,p_i_n_ventilation,DN_VENTILATION)
                        , RECORD_CHANGE_USER        = g_v_user
                        , RECORD_CHANGE_DATE        = l_v_time
                        -- START *30
                        , CONTAINER_GROSS_WEIGHT = NVL2(P_I_V_WEIGHT,P_I_V_WEIGHT,CONTAINER_GROSS_WEIGHT)
                        ,CATEGORY_CODE = NVL2(P_I_V_VGM_CATEGORY,P_I_V_VGM_CATEGORY,CATEGORY_CODE)
                        -- END *30
                        , VGM = NVL2(P_I_V_VGM,P_I_V_VGM,VGM) --*31
                        WHERE FK_BOOKING_NO           = p_i_v_booking_no
                        AND   FK_BKG_EQUIPM_DTL       = p_i_n_equipment_seq_no
                        AND   PK_BOOKED_LOADING_ID    = l_cur_load_list_data.PK_BOOKED_LOADING_ID
                        AND   NVL(PREADVICE_FLAG,'N') = 'N'
                        AND   LOADING_STATUS          = 'BK'
                        AND   RECORD_STATUS           = 'A';
                    END IF;
                    /* * *19 end * */

                END IF;

          END LOOP;--end of l_cur_load_list

        /*
            Block start by vikas, check if booking# and container# not found in the load list then
            create booking into load list,to solve swap container issue, k'chatgamol 23.02.2012
        */
        IF l_v_is_equipment_found IS NULL OR l_v_is_equipment_found != 'Y' THEN
            PRE_TOS_CREATE_LOAD_LIST ( p_i_v_booking_no , '', '', '', '', '', p_o_v_return_status );
            l_v_is_equipment_found := NULL;
        END IF;
        /*
            Block Ended by vikas, 23.02.2012
        */


     ------------------------------------UPDATION OF LOAD LIST ENDS----------------------------

     ------------------------------------UPDATION OF DISCHARGE LIST STARTS----------------------------
          l_v_is_equipment_found := NULL; -- Added 23.02.2012
            g_v_sql_id := 'SQL1015-5';
          IF p_i_v_old_equipment_no IS NULL AND p_i_v_new_equipment_no  IS NOT NULL THEN

            FOR l_cur_discharge_list_DATA IN l_cur_discharge_list
            LOOP
                l_v_is_equipment_found := 'Y'; -- Added 23.02.2012
                g_v_sql_id := 'SQL1015-6';
                BEGIN
                    SELECT DISCHARGE_LIST_STATUS
                    INTO   l_n_discharge_list_status
                    FROM   TOS_DL_DISCHARGE_LIST
                    WHERE  PK_DISCHARGE_LIST_ID = l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_n_discharge_list_status := 0;

                        --g_v_record_filter := 'PK_DISCHARGE_LIST_ID:'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID;
                        --g_v_record_table  := 'Discharg List status Not found in TOS_DL_DISCHARGE_LIST' ;


                END;
                g_v_sql_id := 'SQL1015-7';
                IF l_n_discharge_list_status != 0 THEN

                    g_v_sql_id := 'SQL1015-8';
                    /* * *23 start * */
                    PRE_GET_LIST_STATUS (
                        l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID,
                        DISCHARGE_LIST,
                        L_V_LIST_STATUS
                    );

                    /* * *23 end * */
                    IF ((L_V_LIST_STATUS = DISCHARGE_COMPLETE) OR
                        (L_V_LIST_STATUS = READY_FOR_INVOICE) OR
                        (L_V_LIST_STATUS = WORK_COMPLETE)) THEN  -- *23

                        g_v_sql_id := 'SQL1015A8';

                        BEGIN
                            PCE_ECM_RAISE_ENOTICE.PRE_DL_WRK_SRT_SYNC (
                                  l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                , p_i_n_equipment_seq_no
                                , p_i_v_booking_no
                                , g_n_bussiness_key_sync_dws_ud1
                                , g_v_user
                                , TO_CHAR(l_v_time,'YYYYMMDDHH24MISS')
                                , p_o_v_error
                            );

                            /* *24 start * */
                            --g_v_sql_id := 'SQL1015-9';
                            --PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                            --      l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                            --    , p_i_n_equipment_seq_no
                            --    , p_i_v_booking_no
                            --    , g_n_bussiness_key_sync_cch_ud1
                            --    , p_i_v_old_equipment_no -- Old Equipment No.
                            --    , p_i_v_new_equipment_no -- New Equipment No.
                            --    , 'U'
                            --    , g_v_user
                            --    , TO_CHAR(l_v_time,'YYYYMMDDHH24MISS')
                            --    , p_o_v_error
                            --);
                            /* *24 end * */
                        EXCEPTION
                            WHEN OTHERS THEN
                                PRE_TOS_SYNC_ERROR_LOG(
                                    'EXCETION in calling mail '
                                        ||'~'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                        ||'~'|| g_v_sql_id
                                        ||'~'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                        ||'~'|| p_i_n_equipment_seq_no
                                        ||'~'|| p_i_v_booking_no,
                                    'SYNC',
                                    'D',
                                    'SYNC',
                                    'A',
                                    g_v_user,
                                    SYSDATE,
                                    g_v_user,
                                    SYSDATE
                                );
                        END ;
                    END IF; -- *23
                END IF;

                /* *24 start * */
                BEGIN
                            g_v_sql_id := 'SQL1015-9';
                    /* * check if mail is already send for this vessel voyage then
                        no need to send mail * */
                    IF IS_ALREADY_SEND = FALSE THEN
                        PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                              l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                            , p_i_n_equipment_seq_no
                            , p_i_v_booking_no
                            , g_n_bussiness_key_sync_cch_ud1
                            , p_i_v_old_equipment_no -- Old Equipment No.
                            , p_i_v_new_equipment_no -- New Equipment No.
                            , 'U'
                            , g_v_user
                            , TO_CHAR(l_v_time,'YYYYMMDDHH24MISS')
                            , p_o_v_error
                        );

                    END IF;
                        EXCEPTION
                            WHEN OTHERS THEN
                                PRE_TOS_SYNC_ERROR_LOG(
                                    'EXCETION in calling mail '
                                        ||'~'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                        ||'~'|| g_v_sql_id
                                        ||'~'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                        ||'~'|| p_i_n_equipment_seq_no
                                        ||'~'|| p_i_v_booking_no,
                                    'SYNC',
                                    'D',
                                    'SYNC',
                                    'A',
                                    g_v_user,
                                    SYSDATE,
                                    g_v_user,
                                    SYSDATE
                                );
                        END ;
                IS_ALREADY_SEND := TRUE;
                /* *24 end  * */
            END LOOP;

             g_v_sql_id := 'SQL-10020';
             UPDATE TOS_DL_BOOKED_DISCHARGE
             SET DN_EQUIPMENT_NO     = p_i_v_new_equipment_no
               , RECORD_CHANGE_USER  = g_v_user
               , RECORD_CHANGE_DATE  =  l_v_time
             WHERE FK_BOOKING_NO        = p_i_v_booking_no
             AND   FK_BKG_EQUIPM_DTL    = p_i_n_equipment_seq_no
             AND   RECORD_STATUS        = 'A';

            /* --UPDATE  Booking No. in EMS start */ -- *7
            /* -- start comment *33 
            g_v_sql_id := 'SQL-10020A';
             IF l_v_soc_coc_flg = 'C' AND p_i_v_new_equipment_no IS NOT NULL THEN
                 BEGIN
                    PCE_ECM_EMS.PRE_UPDATE_EMS_BKG(p_i_v_booking_no,p_i_v_new_equipment_no,p_o_v_return_status);
                    IF p_o_v_return_status = '1' THEN
                        g_v_err_desc :='EMS Update Error.';
                        -- RAISE l_exce_main; -- *14
                    END IF;
                 EXCEPTION
                     WHEN OTHERS THEN
                     g_v_err_desc :='EMS Update Error.';
                     -- RAISE l_exce_main; -- *14
                 END;
             END IF;
             --UPDATE  Booking No. in EMS End -- *7
             -- end comment *33 */

          END IF;
        

          g_v_sql_id := 'SQL115-15';
          l_v_is_equipment_found := NULL; -- Added 23.02.2012

          FOR l_cur_discharge_list_DATA IN l_cur_discharge_list
          LOOP
            g_v_sql_id := 'SQL115-16';
             l_v_is_equipment_found := 'Y'; -- Added 23.02.2012
                IF (p_i_v_old_equipment_no IS NOT NULL AND
                     ((p_i_v_new_equipment_no IS NULL) OR
                      (p_i_v_new_equipment_no IS NOT NULL AND p_i_v_old_equipment_no <> p_i_v_new_equipment_no))) THEN

                    g_v_sql_id := 'SQL-10021';
                    IF l_v_cntr_replace_flg = 'N' THEN
                       IF l_cur_discharge_list_DATA.DISCHARGE_STATUS IN('SS','BK')  THEN
                          UPDATE TOS_DL_BOOKED_DISCHARGE
                          SET DN_EQUIPMENT_NO          = p_i_v_new_equipment_no
                            , RECORD_CHANGE_USER       = g_v_user
                            , RECORD_CHANGE_DATE       = l_v_time
                          WHERE FK_BOOKING_NO          = p_i_v_booking_no
                          AND   PK_BOOKED_DISCHARGE_ID = l_cur_discharge_list_DATA.PK_BOOKED_DISCHARGE_ID
                          AND   FK_BKG_EQUIPM_DTL      = p_i_n_equipment_seq_no
                          AND   RECORD_STATUS          = 'A';

                       ELSIF l_cur_discharge_list_DATA.DISCHARGE_STATUS IN ('DI','BD','RB') THEN
                          g_v_sql_id := 'SQL-10023';
                          BEGIN
                             PRE_TOS_TEMP_CONT_REMOVAL (p_i_v_booking_no
                                                      , l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                                      , l_cur_discharge_list_DATA.PK_BOOKED_DISCHARGE_ID
                                                      , NULL
                                                      , 'D'     ----Discharge List
                                                      , p_o_v_return_status);
                          IF p_o_v_return_status = '1' THEN
                             RAISE l_exce_main;
                          END IF;
                          EXCEPTION
                             WHEN OTHERS THEN
                                RAISE l_exce_main;
                          END;
                          -----EMS API TO BE ADDED starts-----------------
                            -- IF l_n_ll_id >= 10 THEN
                                                                     --       NULL;
                                                                    --     END IF;
                          -----EMS API TO BE ADDED ends-----------------
                          g_v_sql_id := 'SQL-10024';
                          BEGIN
                             PRE_TOS_CREATE_DISCHARGE_LIST(p_i_v_booking_no
                                                         , l_cur_discharge_list_DATA.FK_BKG_VOYAGE_ROUTING_DTL
                                                         , l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                                         , p_i_n_equipment_seq_no
                                                         , l_n_size_type_seq_no
                                                         , l_n_supplier_seq_no
                                                         , p_o_v_return_status
                                                          );
                          IF p_o_v_return_status = '1' THEN
                             RAISE l_exce_main;
                          END IF;
                          EXCEPTION
                             WHEN OTHERS THEN
                                RAISE l_exce_main;
                          END;
                       END IF;

                     /*--UPDATE  Booking No. in EMS start */ -- *7
                     /* -- start comment *33 
                     g_v_sql_id := 'SQL-10024A';
                     IF l_v_soc_coc_flg = 'C' THEN
                         BEGIN
                            PCE_ECM_EMS.PRE_UPDATE_EMS_BKG(p_i_v_booking_no,p_i_v_new_equipment_no,p_o_v_return_status);
                            IF p_o_v_return_status = '1' THEN
                                g_v_err_desc :='EMS Update Error.';
                                -- RAISE l_exce_main; -- *14
                            END IF;
                         EXCEPTION
                             WHEN OTHERS THEN
                             g_v_err_desc :='EMS Update Error.';
                             -- RAISE l_exce_main; -- *14
                         END;
                     END IF;
                     -- end comment *33 */
                 --UPDATE  Booking No. in EMS End -- *7

                ELSE
                    g_v_sql_id := 'SQL-10024e';
                   --COC Container Replacement(l_v_rep_typ = '1')
                   IF l_v_rep_typ = '1'  OR (l_v_rep_typ = '3')  THEN --added replace ment type 3 on 18/10/2010 by bindu.
                      g_v_sql_id := 'SQL-10025';
                      --Added by Bindu on 21-04-2011.
                      IF (l_cur_discharge_list_DATA.DN_TERMINAL = l_v_rep_terminal AND l_v_rep_typ = '3' AND l_cur_discharge_list_DATA.DAMAGED = 'Y') THEN

                         UPDATE TOS_DL_BOOKED_DISCHARGE
                         SET DN_EQUIPMENT_NO          = p_i_v_old_equipment_no
                           , RECORD_CHANGE_USER       = g_v_user
                           , RECORD_CHANGE_DATE       = l_v_time
                         WHERE FK_BOOKING_NO          = p_i_v_booking_no
                         AND   PK_BOOKED_DISCHARGE_ID = l_cur_discharge_list_DATA.PK_BOOKED_DISCHARGE_ID
                         AND   FK_BKG_EQUIPM_DTL      = p_i_n_equipment_seq_no
                         AND   RECORD_STATUS          = 'A';
                      END IF;
                      --end by Bindu on 21-04-2011.
                      IF  INSTR(l_v_subsequent_ter, l_cur_discharge_list_DATA.DN_TERMINAL) > 0 THEN
                         UPDATE TOS_DL_BOOKED_DISCHARGE
                         SET DN_EQUIPMENT_NO          = p_i_v_new_equipment_no
                           , RECORD_CHANGE_USER       = g_v_user
                           , RECORD_CHANGE_DATE       = l_v_time
                         WHERE FK_BOOKING_NO          = p_i_v_booking_no
                         AND   PK_BOOKED_DISCHARGE_ID = l_cur_discharge_list_DATA.PK_BOOKED_DISCHARGE_ID
                         AND   FK_BKG_EQUIPM_DTL      = p_i_n_equipment_seq_no
                         AND   RECORD_STATUS          = 'A';
                      END IF;
                   ELSIF l_v_rep_typ = '2' THEN
                   --SOC Container Replacement(l_v_rep_typ = '2'  )
                   g_v_sql_id := 'SQL-10026';
                      UPDATE TOS_DL_BOOKED_DISCHARGE
                      SET DN_EQUIPMENT_NO          = p_i_v_new_equipment_no
                        , RECORD_CHANGE_USER       = g_v_user
                        , RECORD_CHANGE_DATE       = l_v_time
                      WHERE FK_BOOKING_NO          = p_i_v_booking_no
                      AND   PK_BOOKED_DISCHARGE_ID = l_cur_discharge_list_DATA.PK_BOOKED_DISCHARGE_ID
                      AND   FK_BKG_EQUIPM_DTL      = p_i_n_equipment_seq_no
                      AND   RECORD_STATUS          = 'A';
                   END IF;
              END IF;
            END IF;


            g_v_sql_id := 'SQL-10026a';
            ----------------Get PORT CLASS/Type if applicable------------------
            IF p_i_v_unno IS NOT NULL AND p_i_v_un_var IS NOT NULL  AND p_i_v_imdg  IS NOT NULL THEN
              BEGIN
                SELECT PORT_CLASS_CODE, PORT_CLASS_TYPE
                INTO l_v_portclass, l_v_portclass_type
                FROM PORT_CLASS
                WHERE UNNO          = p_i_v_unno
                AND VARIANT         = NVL(p_i_v_un_var,'-')  -- Change by vikas, varint can not null, 18.11.2011
                AND IMDG_CLASS      = p_i_v_imdg
                AND PORT_CLASS_TYPE IN (SELECT PORT_CLASS_TYPE
                                         FROM PORT_CLASS_TYPE
                                         WHERE PORT_CODE = l_cur_discharge_list_DATA.DN_PORT
                                       );
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   l_v_portclass      := NULL;
                   l_v_portclass_type := NULL;
                WHEN OTHERS THEN
                   l_v_portclass      := NULL;
                   l_v_portclass_type := NULL;
             END;
            END IF;
            --------------------OOG /DG /REEFERDETAL UPDATE----------------------
            g_v_sql_id := 'SQL-10026b';
            IF p_i_n_overheight IS NOT NULL
                 OR p_i_n_overlength_rear IS NOT NULL
                 OR p_i_n_overlength_front IS NOT NULL
                 OR p_i_n_overwidth_left  IS NOT NULL
                 OR p_i_n_overwidth_right IS NOT NULL
                 --fOR DG
                 OR p_i_v_unno IS NOT NULL
                 OR p_i_v_un_var IS NOT NULL
                 OR p_i_v_flash_point IS NOT NULL
                 OR p_i_n_flash_unit IS NOT NULL
                 OR p_i_v_imdg  IS NOT NULL
                 --fOR REEFER
                 OR p_i_n_reefer_tmp  IS NOT NULL
                 OR p_i_v_reefer_tmp_unit  IS NOT NULL
                 OR p_i_n_humidity   IS NOT NULL
                 OR p_i_n_ventilation IS NOT NULL
                 OR P_I_V_WEIGHT IS NOT NULL  --*30
                 OR P_I_V_VGM_CATEGORY IS NOT NULL --*30
                 OR P_I_V_VGM          IS NOT NULL --*31 

                 THEN

                    g_v_sql_id := 'SQL-10026c';
                BEGIN
                    SELECT DISCHARGE_LIST_STATUS
                    INTO   l_n_discharge_list_status
                    FROM   TOS_DL_DISCHARGE_LIST
                    WHERE  PK_DISCHARGE_LIST_ID = l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_n_discharge_list_status := 0;

                        -- g_v_record_filter := 'PK_DISCHARGE_LIST_ID:'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID  ;
                        -- g_v_record_table  := 'DISCHARGE_LIST_STATUS Not found in TOS_DL_DISCHARGE_LIST' ;

                END;

                g_v_sql_id := 'SQL-10026d';
                IF l_n_discharge_list_status != 0 THEN

                    g_v_sql_id := 'SQL-10026e';
                    begin
                        PCE_ECM_RAISE_ENOTICE.PRE_DL_WRK_SRT_SYNC (
                              l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                            , p_i_n_equipment_seq_no
                            , p_i_v_booking_no
                            , g_n_bussiness_key_sync_dws_ud2
                            , g_v_user
                            , TO_CHAR(l_v_time,'YYYYMMDDHH24MISS')
                            , p_o_v_error
                        );

                        /* *24 strat * */
                        -- g_v_sql_id := 'SQL-10026f';
                        --
                        -- PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                        --       l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                        --     , p_i_n_equipment_seq_no
                        --     , p_i_v_booking_no
                        --     , g_n_bussiness_key_sync_cch_ud2
                        --     , p_i_v_old_equipment_no -- Old Equipment No.
                        --     , p_i_v_new_equipment_no -- New Equipment No.
                        --     , 'D'
                        --     , g_v_user
                        --     , TO_CHAR(l_v_time,'YYYYMMDDHH24MISS')
                        --     , p_o_v_error
                        -- );
                        /* *24 end * */
                    exception
                        when others then
                            l_v_err_msg := SQLERRM;
                            PRE_TOS_SYNC_ERROR_LOG(
                                'EXCETION in calling mail '
                                    ||'~'||g_v_sql_id
                                    ||'~'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                    ||'~'|| l_v_err_msg
                                    ||'~'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                    ||'~'|| p_i_n_equipment_seq_no
                                    ||'~'|| p_i_v_booking_no,
                                'SYNC',
                                'D',
                                'SYNC',
                                'A',
                                g_v_user,
                                SYSDATE,
                                g_v_user,
                                SYSDATE
                            );
                    end ;

                END IF;
                /* *24 start * */
                BEGIN
                    g_v_sql_id := 'SQL-10026f';
                    /* * check if mail is already send for this vessel voyage then
                        no need to send mail * */
                    IF IS_ALREADY_SEND = FALSE THEN
                        PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                              l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                            , p_i_n_equipment_seq_no
                            , p_i_v_booking_no
                            , g_n_bussiness_key_sync_cch_ud2
                            , p_i_v_old_equipment_no -- Old Equipment No.
                            , p_i_v_new_equipment_no -- New Equipment No.
                            , 'D'
                            , g_v_user
                            , TO_CHAR(l_v_time,'YYYYMMDDHH24MISS')
                            , p_o_v_error
                        );
                      END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                            PRE_TOS_SYNC_ERROR_LOG(
                                'EXCETION in calling mail '
                                    ||'~'||g_v_sql_id
                                    ||'~'|| l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID
                                    ||'~'|| l_v_err_msg

                                    ||'~'|| p_i_n_equipment_seq_no
                                    ||'~'|| p_i_v_booking_no,
                                'SYNC',
                                'D',
                                'SYNC',
                                'A',
                                g_v_user,
                                SYSDATE,
                                g_v_user,
                                SYSDATE
                            );
                END ;
                /* *24 end  * */

                g_v_sql_id := 'SQL-10026g';
                /* *21 start */
                /* * check whether to update DG info in ezdl or not * */
                BEGIN
                    L_V_IS_UPDATE_DG := FALSE;
                    SELECT
                        FN_CAN_UPDATE_DG (
                            DN_SPECIAL_HNDL,
                            DN_EQ_TYPE
                        ) AS "IS_UPDATE_DG"
                    INTO
                        L_V_IS_UPDATE_DG
                    FROM
                        TOS_DL_BOOKED_DISCHARGE
                    WHERE
                        FK_BOOKING_NO = p_i_v_booking_no
                        AND FK_BKG_EQUIPM_DTL = p_i_n_equipment_seq_no
                        AND PK_BOOKED_DISCHARGE_ID = l_cur_discharge_list_DATA.PK_BOOKED_DISCHARGE_ID
                        AND DISCHARGE_STATUS = 'BK'
                        AND RECORD_STATUS = 'A';

                EXCEPTION
                    WHEN OTHERS THEN NULL;
                END;
                /* *21 end */

                g_v_sql_id := 'SQL-10026h';
                IF ((P_I_V_USER_ID = 'EZLL') AND (L_V_IS_UPDATE_DG = TRUE)) THEN -- *19, -- *21
                    /* * if user is ezll means booking updated by maintenance screen
                        * so update DG details also in ezll table. * */

                    select count(1) into l_n_found from TOS_DL_DISCHARGE_LIST where DN_port='HKHKG' and PK_DISCHARGE_LIST_ID = l_cur_discharge_list_DATA.FK_DISCHARGE_LIST_ID; -- *28


                    UPDATE TOS_DL_BOOKED_DISCHARGE
                    SET OVERHEIGHT_CM            = NVL2(p_i_n_overheight,p_i_n_overheight,OVERHEIGHT_CM)
                        , OVERLENGTH_REAR_CM       = NVL2(p_i_n_overlength_rear,p_i_n_overlength_rear,OVERLENGTH_REAR_CM)
                        , OVERLENGTH_FRONT_CM      = NVL2(p_i_n_overlength_front,p_i_n_overlength_front,OVERLENGTH_FRONT_CM)
                        , OVERWIDTH_LEFT_CM        = NVL2(p_i_n_overwidth_left, p_i_n_overwidth_left,OVERWIDTH_LEFT_CM)
                        , OVERWIDTH_RIGHT_CM       = NVL2(p_i_n_overwidth_right,p_i_n_overwidth_right,OVERWIDTH_RIGHT_CM)
                        ,FK_UNNO = CASE WHEN l_n_found=0 THEN DECODE(p_i_v_unno,'~',NULL,NVL2(p_i_v_unno,p_i_v_unno,FK_UNNO)) ELSE FK_UNNO END -- *28
                        , FK_IMDG = CASE WHEN l_n_found=0 THEN DECODE(p_i_v_imdg,'~',NULL,NVL2(p_i_v_imdg,p_i_v_imdg,FK_IMDG))ELSE FK_IMDG END -- *28
                        , FK_UN_VAR = CASE WHEN l_n_found=0 THEN DECODE(p_i_v_un_var,'~',NULL,NVL2(p_i_v_un_var,p_i_v_un_var,FK_UN_VAR)) ELSE FK_UN_VAR END -- *28

                        -- *28 , FK_UNNO                  = DECODE(p_i_v_unno,'~',NULL,NVL2(p_i_v_unno,p_i_v_unno,FK_UNNO))
                        -- *28 , FK_UN_VAR                = DECODE(p_i_v_un_var,'~',NULL,NVL2(p_i_v_un_var,p_i_v_un_var,FK_UN_VAR))
                        -- *28 , FK_IMDG                  = DECODE(p_i_v_imdg,'~',NULL,NVL2(p_i_v_imdg,p_i_v_imdg,FK_IMDG))

                        , FLASH_POINT              = DECODE(p_i_v_flash_point,'~',NULL,NVL2(p_i_v_flash_point,p_i_v_flash_point,FLASH_POINT))
                        , FLASH_UNIT               = DECODE(p_i_n_flash_unit,'~',NULL,NVL2(p_i_n_flash_unit,p_i_n_flash_unit,FLASH_UNIT))
                        , REEFER_TEMPERATURE       = DECODE(p_i_n_reefer_tmp,'~',NULL,NVL2(p_i_n_reefer_tmp,p_i_n_reefer_tmp,REEFER_TEMPERATURE))
                        , REEFER_TMP_UNIT          = DECODE(p_i_v_reefer_tmp_unit,'~',NULL,NVL2(p_i_v_reefer_tmp_unit,p_i_v_reefer_tmp_unit,REEFER_TMP_UNIT))
                        , DN_HUMIDITY              = NVL2(p_i_n_humidity,p_i_n_humidity,DN_HUMIDITY)
                        , DN_VENTILATION           = NVL2(P_I_N_VENTILATION,P_I_N_VENTILATION,DN_VENTILATION)
                      --  , FK_PORT_CLASS            = NVL2(l_v_portclass,l_v_portclass,FK_PORT_CLASS) --*26
                        , FK_PORT_CLASS_TYP        = NVL2(l_v_portclass_type,l_v_portclass_type,FK_PORT_CLASS_TYP)
                        , RECORD_CHANGE_USER       = g_v_user
                        , RECORD_CHANGE_DATE       = l_v_time
                        -- START *30
                        , CONTAINER_GROSS_WEIGHT = NVL2(P_I_V_WEIGHT,P_I_V_WEIGHT,CONTAINER_GROSS_WEIGHT)
                        ,CATEGORY_CODE = NVL2(P_I_V_VGM_CATEGORY,P_I_V_VGM_CATEGORY,CATEGORY_CODE)
                        -- END *30
                        , VGM = NVL2(P_I_V_VGM,P_I_V_VGM,VGM) --*31
                    WHERE FK_BOOKING_NO          = p_i_v_booking_no
                    AND   FK_BKG_EQUIPM_DTL      = p_i_n_equipment_seq_no
                    AND   PK_BOOKED_DISCHARGE_ID = l_cur_discharge_list_DATA.PK_BOOKED_DISCHARGE_ID
                    AND   DISCHARGE_STATUS       = 'BK'
                    AND   RECORD_STATUS          = 'A';
                ELSE -- *19
                    /* * *19 start * */
                    /* * if user is ezll means booking updated by booking user
                        * so no need to update DG details also in ezll table. * */
                    UPDATE TOS_DL_BOOKED_DISCHARGE
                    SET OVERHEIGHT_CM            = NVL2(p_i_n_overheight,p_i_n_overheight,OVERHEIGHT_CM)
                        , OVERLENGTH_REAR_CM       = NVL2(p_i_n_overlength_rear,p_i_n_overlength_rear,OVERLENGTH_REAR_CM)
                        , OVERLENGTH_FRONT_CM      = NVL2(p_i_n_overlength_front,p_i_n_overlength_front,OVERLENGTH_FRONT_CM)
                        , OVERWIDTH_LEFT_CM        = NVL2(p_i_n_overwidth_left, p_i_n_overwidth_left,OVERWIDTH_LEFT_CM)
                        , OVERWIDTH_RIGHT_CM       = NVL2(p_i_n_overwidth_right,p_i_n_overwidth_right,OVERWIDTH_RIGHT_CM)
                        , FLASH_POINT              = DECODE(p_i_v_flash_point,'~',NULL,NVL2(p_i_v_flash_point,p_i_v_flash_point,FLASH_POINT))
                        , FLASH_UNIT               = DECODE(p_i_n_flash_unit,'~',NULL,NVL2(p_i_n_flash_unit,p_i_n_flash_unit,FLASH_UNIT))
                        , REEFER_TEMPERATURE       = DECODE(p_i_n_reefer_tmp,'~',NULL,NVL2(p_i_n_reefer_tmp,p_i_n_reefer_tmp,REEFER_TEMPERATURE))
                        , REEFER_TMP_UNIT          = DECODE(p_i_v_reefer_tmp_unit,'~',NULL,NVL2(p_i_v_reefer_tmp_unit,p_i_v_reefer_tmp_unit,REEFER_TMP_UNIT))
                        , DN_HUMIDITY              = NVL2(p_i_n_humidity,p_i_n_humidity,DN_HUMIDITY)
                        , DN_VENTILATION           = NVL2(p_i_n_ventilation,p_i_n_ventilation,DN_VENTILATION)
                        , RECORD_CHANGE_USER       = g_v_user
                        , RECORD_CHANGE_DATE       = l_v_time
                        -- START *30
                        , CONTAINER_GROSS_WEIGHT = NVL2(P_I_V_WEIGHT,P_I_V_WEIGHT,CONTAINER_GROSS_WEIGHT)
                        ,CATEGORY_CODE = NVL2(P_I_V_VGM_CATEGORY,P_I_V_VGM_CATEGORY,CATEGORY_CODE)
                        -- END *30
                        , VGM = NVL2(P_I_V_VGM,P_I_V_VGM,VGM) --*31
                    WHERE FK_BOOKING_NO          = p_i_v_booking_no
                    AND   FK_BKG_EQUIPM_DTL      = p_i_n_equipment_seq_no
                    AND   PK_BOOKED_DISCHARGE_ID = l_cur_discharge_list_DATA.PK_BOOKED_DISCHARGE_ID
                    AND   DISCHARGE_STATUS       = 'BK'
                    AND   RECORD_STATUS          = 'A';
                END IF;
                /* * *19 end * */

            END IF;
            IS_ALREADY_SEND := TRUE; -- *24
       END LOOP;

        /*
            Block start by vikas, check if booking# and container# not found in the load list then
            create booking into load list,to solve swap container issue, k'chatgamol 23.02.2012
        */
        IF l_v_is_equipment_found IS NULL OR l_v_is_equipment_found != 'Y' THEN
            PRE_TOS_CREATE_DISCHARGE_LIST ( p_i_v_booking_no , '', '', '', '', '', p_o_v_return_status );
            l_v_is_equipment_found := NULL;
        END IF;
        /*
            Block Ended by vikas, 23.02.2012
        */
       p_o_v_return_status := '0';
--------------------------ALERT TO BE INCLUDED------------------------------------
       END IF;

     --inserting Batch status into TOS_ERROR_MST table.

    EXCEPTION
       WHEN l_exce_main THEN
          p_o_v_return_status := '1';

          ROLLBACK;
          PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                            , 'L106_M'
                            , 'U'
                            , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                            , 'A'
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_record_filter
                            , g_v_record_table
                             );
          COMMIT;
       WHEN OTHERS THEN
          p_o_v_return_status := '1';
          ROLLBACK;
          PRE_TOS_SYNC_ERROR_LOG(l_v_parameter_str
                            , 'L106_O'
                            , 'U'
                            , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                            , 'A'
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            , g_v_record_filter
                            , g_v_record_table
                             );
       COMMIT;
    END PRE_TOS_EQUIPMENT_UPDATE;

    PROCEDURE PRE_TOS_TEMP_CONT_REMOVAL
    (
      p_i_v_booking_no     IN         VARCHAR2
    , p_i_n_list_id        IN         NUMBER
    , p_i_n_booked_id      IN         NUMBER
    , p_i_v_preadvice_flg  IN         VARCHAR2
    , p_i_v_ll_dl_flg      IN         VARCHAR2
    , p_o_v_return_status  OUT NOCOPY VARCHAR2
    ) AS
    /********************************************************************************
    * Name           : PRE_TOS_TEMP_CONT_REMOVAL                                    *
    * Module         : EZLL                                                         *
    * Purpose        : This  Stored  Procedure is for suspending records in         *
    *                : Load List and Discharge List                                 *
    * Calls          : None                                                         *
    * Returns        : NONE                                                         *
    * Steps Involved :                                                              *
    * History        : None                                                         *
    * Author           Date          What                                           *
    * ---------------  ----------    ----                                           *
    * Arijeet Palt     28/01/2011     1.0                                           *
    *********************************************************************************/
       l_v_sql_id         VARCHAR2(20);
       l_e_no_data_found  EXCEPTION;
       l_d_time           TIMESTAMP;
    BEGIN
           l_d_time := SYSDATE ; -- CURRENT_TIMESTAMP; -- *12

        IF p_i_v_ll_dl_flg = 'L' THEN
            -- SUSPENDS BOOKED LOADING RECORD BASED ON PASSED PARAMETERS
            g_v_sql_id := 'SQL-15001';
            UPDATE TOS_LL_BOOKED_LOADING
            SET    RECORD_STATUS      = 'S'
                , RECORD_CHANGE_USER = g_v_user
                , RECORD_CHANGE_DATE = l_d_time
            WHERE  PK_BOOKED_LOADING_ID  = p_i_n_booked_id
            AND    FK_LOAD_LIST_ID       = p_i_n_list_id
            AND    FK_BOOKING_NO         = p_i_v_booking_no
            AND    ((p_i_v_preadvice_flg = 'Y' AND LOADING_STATUS = 'BK') OR LOADING_STATUS IN ('LO','RB'));

        ELSE
            -- SUSPENDS BOOKED DISCHARGED RECORD BASED ON PASSED PARAMETERS
            g_v_sql_id := 'SQL-15002';
            UPDATE TOS_DL_BOOKED_DISCHARGE
            SET    RECORD_STATUS = 'S'
                , RECORD_CHANGE_USER = g_v_user
                , RECORD_CHANGE_DATE = l_d_time
            WHERE  PK_BOOKED_DISCHARGE_ID = p_i_n_booked_id
            AND    FK_DISCHARGE_LIST_ID   = p_i_n_list_id
            AND    FK_BOOKING_NO          = p_i_v_booking_no
            AND    DISCHARGE_STATUS IN ('DI','BD','RB');
        END IF;
        p_o_v_return_status := '0';

        -- COMMIT; -- *2
    EXCEPTION
       WHEN OTHERS THEN
            COMMIT; -- *3
          p_o_v_return_status := '1';
          -- ROLLBACK;
    END PRE_TOS_TEMP_CONT_REMOVAL;

PROCEDURE PRE_TOS_UPDATE_DG (
    p_i_v_booking_no              IN         VARCHAR2
   ,p_i_v_imo_class               IN         VARCHAR2
   ,p_i_v_un_no                   IN         VARCHAR2
   ,p_i_v_fumigation_only         IN         VARCHAR2 --added by Bindu on 30/03/2011
   ,p_i_v_residue                 IN         VARCHAR2 --added by Bindu on 30/03/2011
   ,p_o_v_return_status           OUT NOCOPY VARCHAR2
) AS
/********************************************************************************
* Name           : PRE_TOS_UPDATE_DG                                            *
* Module         : EZLL                                                         *
* Purpose        : This  Stored  Procedure is for Updation of DG information    *
*                : to existing Load / Discharge List based on Booking no        *
* Calls          : None                                                         *
* Returns        : NONE                                                         *
* Steps Involved :                                                              *
* History        : None                                                         *
* Author           Date          What                                           *
* ---------------  ----------    ----                                           *
* Arijeet Palt     17/01/2011     1.0
* Bindu            30/03/2011     Added p_i_v_fumigation_only and p_i_v_residue
                                  paramets and updating if special_hndl ='D1'   *
*********************************************************************************/
l_v_sql_id                                 VARCHAR2(20);
l_e_no_data_found                          EXCEPTION;
l_v_sql_type                               VARCHAR2(1);

l_v_bk_status                              BKP001.BASTAT%TYPE;
l_v_min_imo_class                          TOS_LL_BOOKED_LOADING.FK_IMDG%TYPE;
l_v_un_no                                  TOS_LL_BOOKED_LOADING.FK_UNNO%TYPE;
l_v_un_variant                             TOS_LL_BOOKED_LOADING.FK_UN_VAR%TYPE;
l_v_port_class                             TOS_LL_BOOKED_LOADING.FK_PORT_CLASS%TYPE;
l_v_port_class_typ                         TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP%TYPE;
l_v_fumigation_only                        TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY%TYPE;--added by Bindu on 30/03/2011
l_v_residue                                TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG%TYPE;--added by Bindu on 30/03/2011

-- Load/Discharge List Variables
l_v_port_cls_type                          PORT_CLASS_TYPE.PORT_CLASS_TYPE%TYPE;
l_v_port_cls_cd                            PORT_CLASS.PORT_CLASS_CODE%TYPE;
l_v_parameter_str                          TOS_SYNC_ERROR_LOG.PARAMETER_STRING%TYPE;
l_v_is_dg            VARCHAR2(1) ; -- added by vikas to identify dg booking, 30.11.2011
-- Load List Cursor
CURSOR l_cur_ll IS
SELECT DISTINCT
       BL.FK_LOAD_LIST_ID   FK_LOAD_LIST_ID,
       LL.DN_PORT           DN_PORT,
       NVL(l_v_un_variant,B9.UN_VARIANT)  UN_VARIANT
FROM   TOS_LL_BOOKED_LOADING BL,
       TOS_LL_LOAD_LIST      LL,
       BKP009                B9
WHERE  BL.FK_LOAD_LIST_ID = LL.PK_LOAD_LIST_ID
AND    B9.BIBKNO           = BL.FK_BOOKING_NO
AND    BL.FK_BOOKING_NO   = p_i_v_booking_no
AND    B9.BIBKNO          = p_i_v_booking_no
AND    B9.BISEQN          = BL.FK_BKG_EQUIPM_DTL
AND    BL.LOADING_STATUS  = 'BK'
AND    BL.RECORD_STATUS   = 'A';


-- Dscharge List Cursor
CURSOR l_cur_dl IS
SELECT DISTINCT
       BD.FK_DISCHARGE_LIST_ID FK_DISCHARGE_LIST_ID,
       DL.DN_PORT              DN_PORT,
       NVL(l_v_un_variant,B9.UN_VARIANT)  UN_VARIANT
FROM   TOS_DL_BOOKED_DISCHARGE BD,
       TOS_DL_DISCHARGE_LIST   DL,
       BKP009                  B9
WHERE  BD.FK_DISCHARGE_LIST_ID = DL.PK_DISCHARGE_LIST_ID
AND    B9.BIBKNO                = BD.FK_BOOKING_NO
AND    BD.FK_BOOKING_NO        = p_i_v_booking_no
AND    B9.BIBKNO               = p_i_v_booking_no
AND    B9.BISEQN               = BD.FK_BKG_EQUIPM_DTL
AND    BD.DN_LOADING_STATUS    = 'BK'
AND    BD.RECORD_STATUS        = 'A';

BEGIN
    l_v_parameter_str := p_i_v_booking_no      ||'~'||
                         p_i_v_imo_class       ||'~'||
                         p_i_v_un_no           ||'~'||
                         p_i_v_fumigation_only ||'~'||--added by Bindu on 30/03/2011
                         p_i_v_residue; --added by Bindu on 30/03/2011

    -- RAISE EXCEPTION AND RETURN FAILED WHEN OLD BOOKING STATUS IS NULL OR NEW BOOKING STATUS IS NULL
    g_v_sql_id := 'SQL-12001';
   IF (p_i_v_imo_class IS NULL AND p_i_v_un_no IS NULL AND p_i_v_fumigation_only IS NULL AND p_i_v_residue IS NULL) THEN --modified by Bindu on 30/03/2011
      p_o_v_return_status := '0';
   ELSE
      -- SELECT BOOKING STATUS FROM BKP001 FOR PASSED BOOKING NO
    g_v_sql_id := 'SQL-12002';
      SELECT BASTAT
      INTO   l_v_bk_status
      FROM   BKP001
      WHERE  BABKNO = p_i_v_booking_no;

      -- IF BOOKING STATUS IS (c'L'osed,'P'artial,'C'onfirm) THEN DO THE FOLLOWING
      IF l_v_bk_status IN ('L','P','C') THEN
         BEGIN
            -- SELECT MININUM IMO_CLASS AND CORRESPONDING UN_NO FROM BOOKING_DG_COMM_DETAIL TABLE FOR PASSED BOOKING NO
            g_v_sql_id := 'SQL-12003';
            SELECT '1', IMO_CLASS, UN_NO, UN_VARIANT, FUMIGATION_YN, RESIDUE
            INTO   l_v_is_dg, l_v_min_imo_class, l_v_un_no, l_v_un_variant, l_v_fumigation_only, l_v_residue  --modified by Bindu on 30/03/2011
            FROM   BOOKING_DG_COMM_DETAIL
            WHERE  IMO_CLASS = (SELECT MIN(IMO_CLASS)
                                FROM   BOOKING_DG_COMM_DETAIL
                                WHERE  BOOKING_NO = p_i_v_booking_no)
            AND    BOOKING_NO = p_i_v_booking_no
            AND    ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               l_v_min_imo_class   := NULL;
               l_v_un_no           := NULL;
               l_v_fumigation_only := NULL;
               l_v_residue         := NULL;

               g_v_record_filter := 'BOOKING_NO:'|| p_i_v_booking_no  ;
               g_v_record_table  := 'IMO_CLASS Not found in BOOKING_DG_COMM_DETAIL' ;


         END;

         IF l_v_min_imo_class IS NULL AND l_v_un_no IS NULL AND l_v_fumigation_only IS NULL AND l_v_residue IS NULL THEN --modified by Bindu on 30/03/2011
            -- IF RECORD DOES NOT EXISTS IN BOOKING_DG_COMM_DETAIL THEN
            -- REMOVE IMDG, UNNO and PORT CLASS FROM TOS_LL_BOOKED_LOADING
            -- FOR THE SAME BOOKING NO WHERE LOADING STATUS = 'BOOKED' AND RECORD STATUS = 'A'
            g_v_sql_id := 'SQL-12004';
            UPDATE TOS_LL_BOOKED_LOADING
            SET    FK_IMDG           = '',
                   FK_UNNO           = '',
                   FK_UN_VAR         = '',
                   FK_PORT_CLASS     = '',
                   FK_PORT_CLASS_TYP = '',
                   FUMIGATION_ONLY   = '', --added by Bindu on 30/03/2011
                   RESIDUE_ONLY_FLAG = ''  --added by Bindu on 30/03/2011
            WHERE  FK_BOOKING_NO   = p_i_v_booking_no
            AND    LOADING_STATUS  = 'BK'
            AND    DN_SPECIAL_HNDL = 'D1' --added by Bindu on 30/03/2011
            AND    NVL(PREADVICE_FLAG,'~') <> 'Y'
            AND    RECORD_STATUS  = 'A';

            --IF SQL%NOTFOUND THEN
            --   g_v_err_code   := TO_CHAR (SQLCODE);
            --   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            --   l_v_sql_type := 'D';
            --   RAISE l_e_no_data_found;
            -- END IF;

            -- IF RECORD DOES NOT EXISTS IN BOOKING_DG_COMM_DETAIL THEN
            -- REMOVE IMDG, UNNO and PORT CLASS FROM TOS_DL_BOOKED_DISCHARGED
            -- FOR THE SAME BOOKING NO WHERE LOADING STATUS = 'BOOKED' AND RECORD STATUS = 'A'
            g_v_sql_id := 'SQL-12005';
            UPDATE TOS_DL_BOOKED_DISCHARGE
            SET    FK_IMDG            = '',
                   FK_UNNO            = '',
                   FK_UN_VAR          = '',
                   FK_PORT_CLASS      = '',
                   FK_PORT_CLASS_TYP  = '',
                   FUMIGATION_ONLY    = '', --added by Bindu on 30/03/2011
                   RESIDUE_ONLY_FLAG  = ''  --added by Bindu on 30/03/2011
            WHERE  FK_BOOKING_NO  = p_i_v_booking_no
            AND    DISCHARGE_STATUS  = 'BK'
            AND    DN_SPECIAL_HNDL   = 'D1' --added by Bindu on 30/03/2011
            AND    RECORD_STATUS     = 'A';

            --IF SQL%NOTFOUND THEN
            --   g_v_err_code   := TO_CHAR (SQLCODE);
            --   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
            --   l_v_sql_type := 'D';
            --   RAISE l_e_no_data_found;
            --END IF;
         ELSE
            -- IF RECORD EXISTS IN BOOKING_DG_COMM_DETAIL THEN
            -- UPDATE IMDG, UNNO, VARIANT and PORT CLASS OF TOS_LL_BOOKED_LOADING
            -- FOR THE SAME BOOKING NO WHERE LOADING STATUS = 'BOOKED' AND RECORD STATUS = 'A'
            g_v_sql_id := 'SQL-12006';
            FOR l_local IN l_cur_ll LOOP
                BEGIN
                    -- Get Port Class Type from Port Class Type
                    g_v_sql_id := 'SQL-12007';

                    /*    Modified by vikas if normal booking then no need to
                    validate port class and port code, as k'chatgamol, 30.11.2011    */
                    IF l_v_is_dg = '1' THEN

                        SELECT PORT_CLASS_TYPE
                        INTO   l_v_port_cls_type
                        FROM   PORT_CLASS_TYPE
                        WHERE  PORT_CODE = l_local.DN_PORT;
                    END IF;
                    /*    End Modified vikas, 30.11.2011    */

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                            l_v_port_cls_type := NULL;

                            g_v_record_filter := 'BOOKING_NO:'|| l_local.DN_PORT  ;
                            g_v_record_table  := 'Port class Type Not found in PORT_CLASS_TYPE' ;

                    WHEN OTHERS THEN
                            l_v_port_cls_type := NULL;

                            g_v_record_filter := 'PORT_CODE:'|| l_local.DN_PORT  ;
                            g_v_record_table  := 'Error occured.Contact System administrator' ;

                END;
                g_v_sql_id := 'SQL-12008';
                IF l_v_un_no IS NULL
                    OR l_local.UN_VARIANT IS NULL
                    OR l_v_min_imo_class  IS NULL
                    OR l_v_port_cls_type  IS NULL
                THEN
                    l_v_port_cls_cd := NULL;
                ELSE
                    BEGIN
                        -- Get Port Class Code from Port Class
                        g_v_sql_id := 'SQL-12009';
                        /*    Modified by vikas if normal booking then no need to
                            validate port class and port code, as k'chatgamol, 30.11.2011    */
                        IF l_v_is_dg = '1' THEN
                            SELECT PORT_CLASS_CODE
                            INTO   l_v_port_cls_cd
                            FROM   PORT_CLASS
                            WHERE  PORT_CLASS_TYPE = l_v_port_cls_type
                            AND    UNNO            = l_v_un_no
                            AND    VARIANT         = nvl(l_local.UN_VARIANT, '-') -- Change by vikas, varint can not null, 18.11.2011
                            AND    IMDG_CLASS      = l_v_min_imo_class;
                        END IF;
                        /*    End Modified vikas, 30.11.2011    */
                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                            l_v_port_cls_cd := NULL;

                            g_v_record_filter := 'PORT_CLASS_TYPE:'|| l_v_port_cls_type ||
                                                ' UNNO:'           || l_v_un_no         ||
                                                ' VARIANT:'        || l_local.UN_VARIANT||
                                                ' IMDG_CLASS:'     || l_v_min_imo_class  ;
                            g_v_record_table  := 'Port class Type Not found in PORT_CLASS' ;

                    WHEN OTHERS THEN
                            l_v_port_cls_cd := NULL;

                            g_v_record_filter := 'PORT_CLASS_TYPE:'|| l_v_port_cls_type ||
                                                ' UNNO:'           || l_v_un_no         ||
                                                ' VARIANT:'        || l_local.UN_VARIANT||
                                                ' IMDG_CLASS:'     || l_v_min_imo_class  ;
                            g_v_record_table  := 'Error occured.Contact System administrator' ;

                    END;
                END IF;

               -- UPDATE IMDG, UNNO, VARIANT and  PORT CLASS OF TOS_LL_BOOKED_LOADING
               g_v_sql_id := 'SQL-12010';
               UPDATE TOS_LL_BOOKED_LOADING
               SET    FK_IMDG            = l_v_min_imo_class,
                      FK_UNNO            = l_v_un_no,
                      FK_UN_VAR          = NVL(l_local.UN_VARIANT,'-'), -- Change by vikas, varint can not null, 18.11.2011
                      FK_PORT_CLASS_TYP  = l_v_port_cls_type,
                      FK_PORT_CLASS      = l_v_port_cls_cd,
                      FUMIGATION_ONLY    = l_v_fumigation_only, --added by Bindu on 30/03/2011
                      RESIDUE_ONLY_FLAG  = l_v_residue --added by Bindu on 30/03/2011
               WHERE  FK_BOOKING_NO     = p_i_v_booking_no
               AND    FK_LOAD_LIST_ID   = l_local.FK_LOAD_LIST_ID
               AND    LOADING_STATUS    = 'BK'
               AND    DN_SPECIAL_HNDL   = 'D1' --added by Bindu on 30/03/2011
               AND    NVL(PREADVICE_FLAG,'~') <> 'Y'
               AND    RECORD_STATUS     = 'A';

               --IF SQL%NOTFOUND THEN
               --   g_v_err_code   := TO_CHAR (SQLCODE);
               --   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               --   l_v_sql_type := 'U';
               --   RAISE l_e_no_data_found;
               --END IF;
            END LOOP;
            g_v_sql_id := 'SQL-12011';
            -- IF RECORD EXISTS IN BOOKING_DG_COMM_DETAIL THEN
            -- UPDATE IMDG, UNNO, VARIANT and PORT CLASS OF TOS_DL_BOOKED_DISCHARGED
            -- FOR THE SAME BOOKING NO WHERE LOADING STATUS = 'BOOKED' AND RECORD STATUS = 'A'
            FOR l_local IN l_cur_dl LOOP
              BEGIN
                   -- Get Port Class Type from Port Class Type
                   g_v_sql_id := 'SQL-12012';
                    /*    Modified by vikas if normal booking then no need to
                    validate port class and port code, as k'chatgamol, 30.11.2011    */
                    IF l_v_is_dg = '1' THEN
                       SELECT PORT_CLASS_TYPE
                       INTO   l_v_port_cls_type
                       FROM   PORT_CLASS_TYPE
                       WHERE  PORT_CODE = l_local.DN_PORT;
                    END IF;
                    /*    End Modified vikas, 30.11.2011    */

              EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                        l_v_port_cls_type := NULL;

                        g_v_record_filter := 'PORT_CODE:'|| l_local.DN_PORT ;
                        g_v_record_table  := 'Port Class Typ Not found in PORT_CLASS_TYPE' ;


                  WHEN OTHERS THEN
                        l_v_port_cls_type := NULL;

                        g_v_record_filter := 'PORT_CODE:'|| l_local.DN_PORT ;
                        g_v_record_table  := 'Error occured.Contact System administrator' ;

              END;
               g_v_sql_id := 'SQL-12013';
               IF l_v_un_no IS NULL
                  OR l_local.UN_VARIANT IS NULL
                  OR l_v_min_imo_class  IS NULL
                  OR l_v_port_cls_type  IS NULL
               THEN
                   l_v_port_cls_cd := NULL;
               ELSE
                    BEGIN
                        -- Get Port Class Code from Port Class
                        g_v_sql_id := 'SQL-12014';
                    /*    Modified by vikas if normal booking then no need to
                        validate port class and port code, as k'chatgamol, 30.11.2011    */
                    IF l_v_is_dg = '1' THEN
                        SELECT PORT_CLASS_CODE
                        INTO   l_v_port_cls_cd
                        FROM   PORT_CLASS
                        WHERE  PORT_CLASS_TYPE = l_v_port_cls_type
                        AND    UNNO            = l_v_un_no
                        AND    VARIANT         = nvl(l_local.UN_VARIANT,'-') -- Change by vikas, varint can not null, 18.11.2011
                        AND    IMDG_CLASS      = l_v_min_imo_class;
                    END IF;
                    /*    End Modified vikas, 30.11.2011    */
                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                            l_v_port_cls_cd := NULL;

                            g_v_record_filter := 'PORT_CLASS_TYPE:'|| l_v_port_cls_type ||
                                                ' UNNO:'           || l_v_un_no         ||
                                                ' VARIANT:'        || l_local.UN_VARIANT||
                                             ' IMDG_CLASS:'     || l_v_min_imo_class;
                        g_v_record_table  := 'Port Class Code Not found in PORT_CLASS' ;

                  WHEN OTHERS THEN
                        l_v_port_cls_cd := NULL;

                        g_v_record_filter := 'PORT_CLASS_TYPE:'|| l_v_port_cls_type ||
                                             ' UNNO:'           || l_v_un_no         ||
                                             ' VARIANT:'        || l_local.UN_VARIANT||
                                             ' IMDG_CLASS:'     || l_v_min_imo_class;
                        g_v_record_table  := 'Error occured.Contact System administrator' ;

                  END;
               END IF;

               -- UPDATE IMDG, UNNO, VARIANT and PORT CLASS OF TOS_DL_BOOKED_DISCHARGE
               g_v_sql_id := 'SQL-12015';
               UPDATE TOS_DL_BOOKED_DISCHARGE
               SET    FK_IMDG              = l_v_min_imo_class,
                      FK_UNNO              = l_v_un_no,
                      FK_UN_VAR            = nvl(l_local.UN_VARIANT,'-'), -- Change by vikas, varint can not null, 18.11.2011
                      FK_PORT_CLASS_TYP    = l_v_port_cls_type,
                      FK_PORT_CLASS        = l_v_port_cls_cd,
                      FUMIGATION_ONLY      = l_v_fumigation_only, --added by Bindu on 30/03/2011
                      RESIDUE_ONLY_FLAG    = l_v_residue --added by Bindu on 30/03/2011
               WHERE  FK_BOOKING_NO        = p_i_v_booking_no
               AND    FK_DISCHARGE_LIST_ID = l_local.FK_DISCHARGE_LIST_ID
               AND    DN_LOADING_STATUS  = 'BK'
               AND    DN_SPECIAL_HNDL    = 'D1' --added by Bindu on 30/03/2011
               AND    RECORD_STATUS      = 'A';

               --IF SQL%NOTFOUND THEN
               --   g_v_err_code   := TO_CHAR (SQLCODE);
               --   g_v_err_desc   := SUBSTR(SQLERRM,1,100);
               --   l_v_sql_type := 'U';
               --   RAISE l_e_no_data_found;
               --END IF;
            END LOOP;

            p_o_v_return_status := '0';
         END IF;
      ELSE
         p_o_v_return_status := '0';
      END IF;
   END IF;
   COMMIT;

EXCEPTION
   WHEN l_e_no_data_found THEN
        p_o_v_return_status := '1';
        ROLLBACK;
         PRE_TOS_SYNC_ERROR_LOG( l_v_parameter_str
                            ,'DG_M'
                            ,l_v_sql_type
                            , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                            ,'A'
                            ,g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            ,g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            ,g_v_record_filter
                            ,g_v_record_table
                           );
        COMMIT;
   WHEN OTHERS THEN
        p_o_v_return_status := '1';
        g_v_err_code   := NVL(g_v_err_code,TO_CHAR (SQLCODE));
        g_v_err_desc   := SUBSTR(NVL(g_v_err_desc,SQLERRM),1,100);
        ROLLBACK;
        PRE_TOS_SYNC_ERROR_LOG( l_v_parameter_str
                            ,'DG_O'
                            ,l_v_sql_type
                            , g_v_sql_id||'~'||g_v_err_code||'~'||g_v_err_desc
                            ,'A'
                            ,g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            ,g_v_user
                            , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                            ,g_v_record_filter
                            ,g_v_record_table
                           );
        COMMIT;
END;

PROCEDURE PRE_TOS_CHECK_CREATE_LL_DL
   ( p_i_v_booking_no      IN           VARCHAR2
   , p_o_v_return_status   OUT  NOCOPY  VARCHAR2
   , p_o_v_exec_flg        OUT  NOCOPY  VARCHAR2
   ) AS
/********************************************************************************
* Name           : PRE_TOS_CHECK_CREATE_LL_DL                                   *
* Module         : EZLL                                                         *
* Purpose        : This  Stored  Procedure is for create load list
                    and discharge_list                                          *
* Calls          :  PRE_TOS_CREATE_LL_DL                                        *
* Returns        : NONE                                                         *
* Steps Involved :                                                              *
* History        : None                                                         *
* Author           Date          What                                           *
* ---------------  ----------    ----                                           *
* Bindu            06/05/2011    1.0                                            *
*********************************************************************************/
   l_rec_count         NUMBER(10) := 0;
   l_v_booking_status  BKP001.BASTAT%TYPE;
   l_v_booking_type    BKP001.BOOKING_TYPE%TYPE;
   l_exce_main         EXCEPTION;


BEGIN
   BEGIN
      g_v_sql_id := 'SQL-00001';
      SELECT COUNT(1)
      INTO l_rec_count
      FROM TOS_LL_BOOKED_LOADING
      WHERE FK_BOOKING_NO = p_i_v_booking_no
      AND   RECORD_STATUS = 'A';
   EXCEPTION
      WHEN OTHERS THEN
         g_v_err_code := TO_CHAR (SQLCODE);
         g_v_err_desc := SUBSTR(SQLERRM,1,100);

         g_v_record_filter := 'FK_BOOKING_NO:'|| p_i_v_booking_no ||
                              ' RECORD_STATUS = A';
         g_v_record_table  := 'Record Not found in TOS_LL_BOOKED_LOADING' ;

         RAISE l_exce_main;
   END;
   p_o_v_exec_flg := 'N';
   IF l_rec_count = 0 THEN
      p_o_v_exec_flg := 'S';
      g_v_sql_id := 'SQL-00002';

      BEGIN
         SELECT BK1.BASTAT, BK1.BOOKING_TYPE
         INTO l_v_booking_status, l_v_booking_type
         FROM BKP001 BK1
         WHERE BK1.BABKNO = p_i_v_booking_no;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            l_v_booking_status := '*';
            l_v_booking_type   := '*';

            g_v_record_filter := 'BABKNO:'|| p_i_v_booking_no;
            g_v_record_table  := 'BASTAT,Booking Type found in BKP001' ;

         WHEN OTHERS THEN
            l_v_booking_status := '*';
            l_v_booking_type   := '*';

            g_v_record_filter := 'BABKNO:'|| p_i_v_booking_no;
            g_v_record_table  := 'Error occured.Contact System administrator' ;

      END;
      g_v_sql_id := 'SQL-00003';

      PRE_TOS_CREATE_REMOVE_LL_DL( p_i_v_booking_no, l_v_booking_type, 'Z', l_v_booking_status, p_o_v_return_status);
      IF p_o_v_return_status = '1' THEN
         g_v_err_code := TO_CHAR (SQLCODE);
         g_v_err_desc := SUBSTR(SQLERRM,1,100);
         RAISE l_exce_main;
      END IF;
   END IF;
   p_o_v_return_status := '0';

   --COMMIT;
EXCEPTION
   WHEN l_exce_main THEN
      p_o_v_return_status := '1';
      ROLLBACK;
   WHEN OTHERS THEN
      p_o_v_return_status := '1';
      ROLLBACK;
END PRE_TOS_CHECK_CREATE_LL_DL;

    PROCEDURE PRE_TOS_SYNC_ERROR_LOG
    (
         p_parameter_string   IN VARCHAR2
       , p_prog_type          IN VARCHAR2
       , p_opeartion_type     IN VARCHAR2
       , p_error_msg          IN VARCHAR2
       , p_record_status      IN VARCHAR2
       , p_record_add_user    IN VARCHAR2
       , p_record_add_date    IN TIMESTAMP
       , p_record_change_user IN VARCHAR2
       , p_record_change_date IN TIMESTAMP

    ) AS

    BEGIN

     PRE_TOS_SYNC_ERROR_LOG( p_parameter_string
                            ,p_prog_type
                            ,p_opeartion_type
                            , p_error_msg
                            ,p_record_status
                            ,p_record_add_user
                            ,p_record_add_date
                            ,p_record_add_user
                            ,p_record_change_date
                            ,''
                            ,''
                           );

    END;

    PROCEDURE PRE_TOS_SYNC_ERROR_LOG
    (
         p_parameter_string   IN VARCHAR2
       , p_prog_type          IN VARCHAR2
       , p_opeartion_type     IN VARCHAR2
       , p_error_msg          IN VARCHAR2
       , p_record_status      IN VARCHAR2
       , p_record_add_user    IN VARCHAR2
       , p_record_add_date    IN TIMESTAMP
       , p_record_change_user IN VARCHAR2
       , p_record_change_date IN TIMESTAMP
       , p_record_filter      IN VARCHAR2
       , p_record_table       IN VARCHAR2
    ) AS
       l_v_parameter_string   VARCHAR2(500) := SUBSTR(p_parameter_string,1,500);
       l_v_prog_type          VARCHAR2(20)  := SUBSTR(p_prog_type,1,20);
       l_v_opeartion_type     VARCHAR2(1)   := SUBSTR(p_opeartion_type,1,1);
       l_v_error_msg          VARCHAR2(100) := SUBSTR(p_error_msg,1,100);
       l_v_record_status      VARCHAR2(1)   := SUBSTR(p_record_status,1,1);
       l_v_record_add_user    VARCHAR2(10)  := SUBSTR(p_record_add_user,1,10);
       l_d_record_add_date    TIMESTAMP(6)  := p_record_add_date;
       l_v_record_change_user VARCHAR2(10)  := SUBSTR(p_record_change_user,1,10);
       l_d_record_change_date TIMESTAMP(6)  := p_record_change_date;
       l_n_rec_count          NUMBER        := 0;
       /*
       l_n_record_filter      VARCHAR2(100) := p_record_filter;
       l_n_record_table       VARCHAR2(100) := p_record_table;
       */
       l_n_record_filter      VARCHAR2(1000) := SUBSTR(p_record_filter,1, 1000);
       l_n_record_table       VARCHAR2(500)  := SUBSTR(p_record_table,1, 500);

    BEGIN
       --When this procedure is called from error handler
       IF g_v_err_handler_flg = 'Y' THEN
            SELECT COUNT(1) INTO l_n_rec_count
            FROM TOS_SYNC_ERROR_LOG
            WHERE PARAMETER_STRING = l_v_parameter_string
            AND   PROG_TYPE        = l_v_prog_type
            AND   OPEARTION_TYPE   = l_v_opeartion_type
            AND   ERROR_MSG        = l_v_error_msg
            AND   RECORD_STATUS    = 'A'
            AND   RERUN_STATUS     = 0;

            IF l_n_rec_count > 0 THEN
               UPDATE TOS_SYNC_ERROR_LOG
                SET RERUN_STATUS = 1
                  , RECORD_CHANGE_USER = l_v_record_change_user
                  , RECORD_CHANGE_DATE = l_d_record_change_date
                WHERE PARAMETER_STRING = l_v_parameter_string
                AND   PROG_TYPE        = l_v_prog_type
                AND   OPEARTION_TYPE   = l_v_opeartion_type
                AND   ERROR_MSG        = l_v_error_msg
                AND   RECORD_STATUS    = 'A'
                AND   RERUN_STATUS     = 0;
            ELSE
               INSERT INTO TOS_SYNC_ERROR_LOG
                 (PK_SYNC_ERR_LOG_ID
                 , PARAMETER_STRING
                 , PROG_TYPE
                 , OPEARTION_TYPE
                 , ERROR_MSG
                 , RERUN_STATUS
                 , RECORD_STATUS
                 , RECORD_ADD_USER
                 , RECORD_ADD_DATE
                 , RECORD_CHANGE_USER
                 , RECORD_CHANGE_DATE
                 , RECORD_FILTER
                 , RECORD_TABLE
                 )
               VALUES
                 ( SE_SEL01.NEXTVAL
                  , l_v_parameter_string
                  , l_v_prog_type
                  , l_v_opeartion_type
                  , l_v_error_msg
                  , 0   --bY DEFAULT IT WILL BE ZERO
                  , l_v_record_status
                  , l_v_record_add_user
                  , l_d_record_add_date
                  , l_v_record_change_user
                  , l_d_record_change_date
                  , l_n_record_filter
                  , l_n_record_table
                  );
            END IF;
            g_v_err_handler_flg := 'N';
       ELSE
           --When this procedure is directly called from procedure
           INSERT INTO TOS_SYNC_ERROR_LOG
             (PK_SYNC_ERR_LOG_ID
             , PARAMETER_STRING
             , PROG_TYPE
             , OPEARTION_TYPE
             , ERROR_MSG
             , RERUN_STATUS
             , RECORD_STATUS
             , RECORD_ADD_USER
             , RECORD_ADD_DATE
             , RECORD_CHANGE_USER
             , RECORD_CHANGE_DATE
             , RECORD_FILTER
             , RECORD_TABLE
             )
           VALUES
             ( SE_SEL01.NEXTVAL
              , l_v_parameter_string
              , l_v_prog_type
              , l_v_opeartion_type
              , l_v_error_msg
              , 0   --bY DEFAULT IT WILL BE ZERO
              , l_v_record_status
              , l_v_record_add_user
              , l_d_record_add_date
              , l_v_record_change_user
              , l_d_record_change_date
              , l_n_record_filter
              , l_n_record_table );
       END IF;

       COMMIT;

    END PRE_TOS_SYNC_ERROR_LOG;

    /*  Start Added by Vikas to delete the duplicate entries from
        discharge list and load list detail tables., as k'chatgamol, 29.11.2011    */

    PROCEDURE PRE_REMOVE_DUPLICATE_LLDL (
          p_i_v_booking_no            TOS_LL_BOOKED_LOADING.FK_BOOKING_NO%TYPE
        , p_i_v_bkg_equipm_dtl        TOS_LL_BOOKED_LOADING.FK_BKG_EQUIPM_DTL%TYPE
        , p_i_v_voyage_seqno          TOS_LL_BOOKED_LOADING.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
        , p_i_v_discharge_port        TOS_LL_BOOKED_LOADING.DN_DISCHARGE_PORT%TYPE
        , p_i_v_discharge_terminal    TOS_LL_BOOKED_LOADING.DN_DISCHARGE_TERMINAL%TYPE
        , p_i_v_dn_equipment_no       TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO%TYPE -- ADDED 21.12.2011
        , p_o_v_loading_status        OUT TOS_LL_BOOKED_LOADING.LOADING_STATUS%TYPE
    )
    AS
        l_v_booked_loading_id         TOS_LL_BOOKED_LOADING.PK_BOOKED_LOADING_ID%TYPE;
        l_v_load_list_id              TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID%TYPE;
        l_v_discharge_list_id         TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID%TYPE;
        l_o_v_return_status           VARCHAR2(10);
    BEGIN

        BEGIN
            SELECT     PK_BOOKED_LOADING_ID
                    , FK_LOAD_LIST_ID
            INTO
                l_v_booked_loading_id
                , l_v_load_list_id
            FROM (  -- get the new created booking id
                SELECT ROW_NUMBER() over (ORDER BY STOWAGE_POSITION, RECORD_ADD_DATE desc) id
                    , PK_BOOKED_LOADING_ID
                    , FK_LOAD_LIST_ID
                FROM   VASAPPS.TOS_LL_BOOKED_LOADING
                WHERE  FK_BOOKING_NO             = p_i_v_booking_no
                -- AND    FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
                -- AND    FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
                AND    DN_DISCHARGE_PORT         = p_i_v_discharge_port
                and    DN_DISCHARGE_TERMINAL     = p_i_v_discharge_terminal
                AND    RECORD_STATUS             = 'A'
                /*
                    Start added by vikas, if equipment no# is
                    not blank then check duplicate using
                    equipment#, 21.12.2011
                */
                AND    (
                            (
                                p_i_v_dn_equipment_no IS NOT NULL
                                AND DN_EQUIPMENT_NO = p_i_v_dn_equipment_no)
                            OR(
                                p_i_v_dn_equipment_no IS NULL
                                AND    FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
                                AND    FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
                            )
                        )
                /*
                    End Added by vikas, 21.12.2011
                */

                ORDER BY STOWAGE_POSITION, RECORD_ADD_DATE DESC

            ) WHERE ID = 1;

            /* Delete duplicate data from load list */
            DELETE FROM
                VASAPPS.TOS_LL_BOOKED_LOADING
            WHERE
                FK_BOOKING_NO             = p_i_v_booking_no        -- l_cur_voyage_rec.BOOKING_NO
                -- AND    FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl -- l_cur_detail_rec.FK_BKG_EQUIPM_DTL
                -- AND    FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno      -- l_cur_voyage_rec.VOYAGE_SEQNO
                /*
                    Start added by vikas, if equipment no# is
                    not blank then check duplicate using
                    equipment#, 21.12.2011
                */

                AND    (
                            (
                                p_i_v_dn_equipment_no IS NOT NULL
                                AND DN_EQUIPMENT_NO = p_i_v_dn_equipment_no)
                            OR(
                                p_i_v_dn_equipment_no IS NULL
                                AND FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
                                AND FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
                            )
                        )
                /*
                    End added by vikas, 21.12.2011
                */
                AND    DN_DISCHARGE_PORT         = p_i_v_discharge_port    -- l_cur_voyage_rec.DISCHARGE_PORT
                AND    DN_DISCHARGE_TERMINAL     = p_i_v_discharge_terminal
                AND    RECORD_STATUS             = 'A'
                AND    PK_BOOKED_LOADING_ID      <> l_v_booked_loading_id ;

            /*
                Start Added by vikas to log the deleted records, 30.11.2011
            *
            IF SQL%ROWCOUNT >= 1 THEN
                PRE_TOS_SYNC_ERROR_LOG(
                    'LL~' || p_i_v_booking_no||'~'||
                        p_i_v_bkg_equipm_dtl||'~'||
                        p_i_v_voyage_seqno||'~'||
                        p_i_v_discharge_port ||'~'||
                        p_i_v_discharge_terminal
                    , 'SYNC'
                    , 'D'
                    , 'Delete duplicate booking from load list'
                    , 'A'
                    , g_v_user
                    , CURRENT_TIMESTAMP
                    , g_v_user
                    , CURRENT_TIMESTAMP
                 );
            END IF;
            *
                End Added by vikas to log the deleted records, 30.11.2011
            */

        EXCEPTION
            WHEN OTHERS THEN
                NULL; -- do nothing.
        END;

        BEGIN
            /* Delete duplicate data from discharge list */
            DELETE FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE
            WHERE   FK_BOOKING_NO             = p_i_v_booking_no
            -- AND        FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
            -- AND        FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
            /*
                Start added by vikas, if equipment no# is
                not blank then check duplicate using
                equipment#, 21.12.2011
            */
            AND    (
                        (
                            p_i_v_dn_equipment_no IS NOT NULL
                            AND DN_EQUIPMENT_NO = p_i_v_dn_equipment_no)
                        OR(
                            p_i_v_dn_equipment_no IS NULL
                            AND FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
                            AND FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
                        )
                    )

            /*
                End added by vikas, 21.12.2011
            */
            AND        RECORD_STATUS             = 'A'
            AND        PK_BOOKED_DISCHARGE_ID NOT IN ( -- get the new created booking id
            SELECT BID FROM (
                SELECT ROW_NUMBER() OVER (ORDER BY STOWAGE_POSITION, BD.RECORD_ADD_DATE DESC) ID
                , BD.PK_BOOKED_DISCHARGE_ID  BID
                FROM VASAPPS.TOS_DL_BOOKED_DISCHARGE BD,
                    VASAPPS.TOS_DL_DISCHARGE_LIST DL
                WHERE  FK_BOOKING_NO             = p_i_v_booking_no
                -- AND    FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
                -- AND    FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
                AND    DL.DN_PORT                = p_i_v_discharge_port
                AND    DL.DN_TERMINAL            = p_i_v_discharge_terminal
                AND    BD.RECORD_STATUS          = 'A'
                AND    DL.RECORD_STATUS          = 'A'
                AND    BD.FK_DISCHARGE_LIST_ID = DL.PK_DISCHARGE_LIST_ID
                /*
                    Start added by vikas, if equipment no# is
                    not blank then check duplicate using
                    equipment#, 21.12.2011
                */
                AND    (
                            (
                                p_i_v_dn_equipment_no IS NOT NULL
                                AND DN_EQUIPMENT_NO = p_i_v_dn_equipment_no)
                            OR(
                                p_i_v_dn_equipment_no IS NULL
                                AND FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
                                AND FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
                            )
                        )
                /*
                    End added by vikas, 21.12.2011
                */
                ORDER BY STOWAGE_POSITION, BD.RECORD_ADD_DATE DESC -- get priority to eq# with null stowage position
            )   WHERE ID = 1) ;

           
            /*    Start Added by vikas to log the deleted records, 08.12.2011    */
           /*-- START #32 
            IF SQL%ROWCOUNT >= 1 THEN
                PRE_TOS_SYNC_ERROR_LOG(
                    'DL~' || p_i_v_booking_no||'~'||
                        p_i_v_bkg_equipm_dtl||'~'||
                        p_i_v_voyage_seqno||'~'||
                        p_i_v_discharge_port ||'~'||
                        p_i_v_discharge_terminal
                    , 'SYNC'
                    , 'D'
                    , 'Delete duplicate booking from discharge list'
                    , 'A'
                    , g_v_user
                    , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                    , g_v_user
                    , SYSDATE  -- CURRENT_TIMESTAMP, -- *12
                 );
            END IF;
            --END *32 */
            /*    End Added by vikas to log the deleted records, 08.12.2011    */
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        /* Update deleted booking status in LL header table. */
        PRE_TOS_STATUS_COUNT(
              l_v_load_list_id
            , 'L'
            , l_o_v_return_status
        );

        /*    Start Added by vikas, 06.12.2011    */

        /* Update status count in DL header table */
        BEGIN

            SELECT  FK_DISCHARGE_LIST_ID
            INTO    l_v_discharge_list_id
            FROM    VASAPPS.TOS_DL_BOOKED_DISCHARGE
            WHERE   FK_BOOKING_NO             = p_i_v_booking_no
            AND     FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
            AND     FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
            AND     RECORD_STATUS             = 'A'
            AND     ROWNUM                    = 1 ;

            /* Update status count in DL header table */
            PRE_TOS_STATUS_COUNT(
                  l_v_discharge_list_id
                , 'D'
                , l_o_v_return_status
            );

        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        /*    End Added by vikas, 06.12.2011    */

        /* Get loading status from old booking */
        SELECT LOADING_STATUS
        INTO   p_o_v_loading_status
        FROM   TOS_LL_BOOKED_LOADING
        WHERE  FK_BOOKING_NO             = p_i_v_booking_no
        AND    FK_BKG_EQUIPM_DTL         = p_i_v_bkg_equipm_dtl
        AND    FK_BKG_VOYAGE_ROUTING_DTL = p_i_v_voyage_seqno
        AND    DN_DISCHARGE_PORT         = p_i_v_discharge_port
        AND    DN_DISCHARGE_TERMINAL     = p_i_v_discharge_terminal
        AND    RECORD_STATUS             = 'A';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_loading_status:='X';


            g_v_record_filter := 'FK_BOOKING_NO:'     || p_i_v_booking_no     ||
                ' FK_BKG_EQUIPM_DTL:'               || p_i_v_bkg_equipm_dtl ||
                ' FK_BKG_VOYAGE_ROUTING_DTL:'       || p_i_v_voyage_seqno   ||
                ' DN_DISCHARGE_PORT:'               || p_i_v_discharge_port ||
                ' DN_DISCHARGE_TERMINAL:'           || p_i_v_discharge_terminal ||
                ' RECORD_STATUS =A';
            g_v_record_table  := 'Loading Status Not found in TOS_LL_BOOKED_LOADING' ;

        WHEN OTHERS THEN
            p_o_v_loading_status := 'Y';

            g_v_record_filter := 'FK_BOOKING_NO:'     || p_i_v_booking_no     ||
                ' FK_BKG_EQUIPM_DTL:'               || p_i_v_bkg_equipm_dtl ||
                ' FK_BKG_VOYAGE_ROUTING_DTL:'       || p_i_v_voyage_seqno   ||
                ' DN_DISCHARGE_PORT:'               || p_i_v_discharge_port ||
                ' DN_DISCHARGE_TERMINAL:'           || p_i_v_discharge_terminal ||
                ' RECORD_STATUS =A';

            g_v_record_table  := 'Error occured.Contact System administrator' ;

    END PRE_REMOVE_DUPLICATE_LLDL;
    /*    End added by vikas, 29.11.2011    */

    /*
        *13: start
    */
    PROCEDURE PRE_GET_LL_DL_STATUS (
        P_I_V_LIST_ID          TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE,
        P_I_V_EQUIPMENT_NO     TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO%TYPE,
        P_I_V_LL_DL_TYPE       VARCHAR2,
        P_O_V_STATUS           OUT TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS%TYPE
    ) AS

        L_V_STOWAGE_POSITION TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION%TYPE;
        L_V_LIST_STATUS      TOS_DL_DISCHARGE_LIST.DISCHARGE_LIST_STATUS%TYPE;
        L_V_CONTAINER_STATUS TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS%TYPE; -- *25
        error_msg varchar2(4000); -- *25

        DISCHARGE      CONSTANT VARCHAR2(2) DEFAULT 'DI';
        LOAD           CONSTANT VARCHAR2(2) DEFAULT 'LO';
        BOOKED         CONSTANT VARCHAR2(2) DEFAULT 'BK';
        LOAD_DISCHARGE CONSTANT NUMBER DEFAULT 10;
        DISCHARGE_LIST CONSTANT VARCHAR2(2) DEFAULT 'DL';
        LOAD_LIST      CONSTANT VARCHAR2(2) DEFAULT 'LL';
        ROB            CONSTANT VARCHAR2(2) DEFAULT 'RB';
    BEGIN
        P_O_V_STATUS := BOOKED;

        /* *25 start */
        IF P_I_V_EQUIPMENT_NO IS NULL THEN
            /* equipment number is blank so the container status can be BOOKED only
            so no need to check further */
            P_O_V_STATUS := BOOKED;
            RETURN;
        END IF;
        /* *25 end */

        /* * get loading status for load list * */
        IF P_I_V_LL_DL_TYPE = LOAD_LIST THEN
            BEGIN
                SELECT
                    BL.STOWAGE_POSITION,
                    LL.LOAD_LIST_STATUS,
                    BL.LOADING_STATUS -- *25
                INTO
                    L_V_STOWAGE_POSITION,
                    L_V_LIST_STATUS,
                    L_V_CONTAINER_STATUS -- *25
                FROM
                    VASAPPS.TOS_LL_LOAD_LIST LL,
                    VASAPPS.TOS_LL_BOOKED_LOADING BL
                WHERE
                    LL.PK_LOAD_LIST_ID       = P_I_V_LIST_ID
                    AND DN_EQUIPMENT_NO      = NVL(P_I_V_EQUIPMENT_NO, '~')
                    AND BL.FK_LOAD_LIST_ID   = LL.PK_LOAD_LIST_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    P_O_V_STATUS := BOOKED; -- *25

                    /* * when new container is getting inserted * */
                    BEGIN
                        SELECT
                            LL.LOAD_LIST_STATUS,
                            '1'
                        INTO
                            L_V_LIST_STATUS,
                            L_V_STOWAGE_POSITION
                        FROM
                            VASAPPS.TOS_LL_LOAD_LIST LL
                        WHERE
                            LL.PK_LOAD_LIST_ID       = P_I_V_LIST_ID;

                    EXCEPTION
                        WHEN OTHERS THEN NULL;
                    END;
                WHEN OTHERS THEN
                    P_O_V_STATUS := BOOKED; -- *25
            END;

             /* *25 start */
            /* When container status is ROB then it will remain ROB not need to
            change it */
            IF L_V_CONTAINER_STATUS = ROB AND NVL(L_V_STOWAGE_POSITION,'1') != '1' THEN
                P_O_V_STATUS := ROB;
                RETURN;
            END IF;
            /* *25 end */

            IF L_V_LIST_STATUS >= LOAD_DISCHARGE AND L_V_STOWAGE_POSITION IS NOT NULL THEN
                /* container number is there, and list status is greater or equal to load complete
                    then set loading status to loaded */
                P_O_V_STATUS := LOAD;
            ELSE
                P_O_V_STATUS := BOOKED;
            END IF;
        END IF;

        /* * get discharge status for discharge list * */
        IF P_I_V_LL_DL_TYPE = DISCHARGE_LIST THEN
            BEGIN
                SELECT
                    BD.STOWAGE_POSITION,
                    DL.DISCHARGE_LIST_STATUS,
                    BD.DISCHARGE_STATUS -- *25
                INTO
                    L_V_STOWAGE_POSITION,
                    L_V_LIST_STATUS,
                    L_V_CONTAINER_STATUS -- *25
                FROM
                    VASAPPS.TOS_DL_DISCHARGE_LIST DL,
                    VASAPPS.TOS_DL_BOOKED_DISCHARGE BD
                WHERE
                    DL.PK_DISCHARGE_LIST_ID       = P_I_V_LIST_ID
                    AND DN_EQUIPMENT_NO           = nvl(P_I_V_EQUIPMENT_NO, '~')
                    AND BD.FK_DISCHARGE_LIST_ID   = DL.PK_DISCHARGE_LIST_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    /* * when new container is getting inserted * */

                    BEGIN
                        SELECT
                            DL.DISCHARGE_LIST_STATUS,
                            '1'
                        INTO
                            L_V_LIST_STATUS,
                            L_V_STOWAGE_POSITION
                        FROM
                            VASAPPS.TOS_DL_DISCHARGE_LIST DL
                        WHERE
                            DL.PK_DISCHARGE_LIST_ID       = P_I_V_LIST_ID;

                    EXCEPTION
                        WHEN OTHERS THEN NULL;
                    END;

                WHEN OTHERS THEN NULL;
            END;

            /* *25 start */
            /* When container status is ROB then it will remain ROB not need to
            change it */
            IF L_V_CONTAINER_STATUS = ROB AND NVL(L_V_STOWAGE_POSITION,'1') != '1' THEN
                P_O_V_STATUS := ROB;
                RETURN;
            END IF;
            /* *25 end */

            IF L_V_LIST_STATUS >= LOAD_DISCHARGE AND L_V_STOWAGE_POSITION IS NOT NULL THEN
                P_O_V_STATUS := DISCHARGE;
            ELSE
                P_O_V_STATUS := BOOKED;
            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            P_O_V_STATUS := BOOKED;
            error_msg := sqlerrm; -- *25

    END PRE_GET_LL_DL_STATUS;
    /*
        *13: end
    */

    /* *21 start * */
    FUNCTION FN_CAN_UPDATE_DG(
        P_V_SPECIAL_HNDL VARCHAR2,
        P_V_SIZE_TYPE VARCHAR2
    )
    RETURN VARCHAR2
    IS
        DG CONSTANT VARCHAR2(5) DEFAULT 'D1';
        OOG CONSTANT VARCHAR2(5) DEFAULT 'O0';
        NORMAL CONSTANT VARCHAR2(5) DEFAULT 'N';
        RE CONSTANT VARCHAR2(5) DEFAULT 'RE';
        RH CONSTANT VARCHAR2(5) DEFAULT 'RH';

        CAN_UPDATE VARCHAR2(5);

    BEGIN
        IF (
            (P_V_SPECIAL_HNDL = DG) OR
            (P_V_SPECIAL_HNDL = OOG) OR
            (P_V_SPECIAL_HNDL = NORMAL AND (P_V_SIZE_TYPE = RE OR P_V_SIZE_TYPE= RH))
        )THEN
            /* * dg information can be updated * */
            CAN_UPDATE := TRUE;
        ELSE
            /* * dg information can not updated * */
            CAN_UPDATE := FALSE;
        END IF;

        RETURN CAN_UPDATE;

    END FN_CAN_UPDATE_DG;
    /* *21 end * */

    /* * *23 start * */
    PROCEDURE PRE_GET_LIST_STATUS (
        P_I_V_LIST_ID     VARCHAR2,
        P_I_LL_DL_FLAG    VARCHAR2,
        P_O_V_LIST_STATUS OUT VARCHAR2
    )
    AS
        OPEN CONSTANT      VARCHAR2(2) DEFAULT '0';
    BEGIN
        BEGIN
            SELECT
                LIST_STATUS
            INTO
                P_O_V_LIST_STATUS
            FROM(
                SELECT
                    LOAD_LIST_STATUS AS "LIST_STATUS"
                FROM
                    TOS_LL_LOAD_LIST
                WHERE
                    PK_LOAD_LIST_ID =  P_I_V_LIST_ID
                    AND RECORD_STATUS = ACTIVE
                    AND P_I_LL_DL_FLAG = LOAD_LIST
                UNION

                SELECT
                    DISCHARGE_LIST_STATUS
                FROM
                    TOS_DL_DISCHARGE_LIST
                WHERE
                    PK_DISCHARGE_LIST_ID =  P_I_V_LIST_ID
                    AND RECORD_STATUS = ACTIVE
                    AND P_I_LL_DL_FLAG = DISCHARGE_LIST
            ) ;

        EXCEPTION
            WHEN OTHERS THEN
                /* no need to raise exception just send mail */
                P_O_V_LIST_STATUS := OPEN;
        END;
    END PRE_GET_LIST_STATUS;
    /* * *23 end * */

    /* *24 start * */
    PROCEDURE PRE_EQ_REMOVE_SYNC_MAIL(
        P_I_V_BOOKING_NO       VARCHAR2,
        P_I_N_EQUIPMENT_SEQ_NO VARCHAR2
    )
    AS
      L_V_ERRCD VARCHAR2(200);

        CURSOR L_CUR_BOOKED_DISCHARGE
        IS
           SELECT FK_BOOKING_NO,
                  FK_DISCHARGE_LIST_ID,
                  PK_BOOKED_DISCHARGE_ID,
                  DISCHARGE_STATUS,
                  FK_BKG_EQUIPM_DTL
            FROM TOS_DL_BOOKED_DISCHARGE
            WHERE FK_BOOKING_NO   = P_I_V_BOOKING_NO
            AND FK_BKG_EQUIPM_DTL = NVL(P_I_N_EQUIPMENT_SEQ_NO, FK_BKG_EQUIPM_DTL)
            AND RECORD_STATUS     = 'A';

        IS_ALREADY_SEND            VARCHAR2(5) := FALSE;
    BEGIN

        FOR J IN L_CUR_BOOKED_DISCHARGE LOOP

            BEGIN
                G_V_SQL_ID := 'SQL-11009';

                /* * CHECK IF MAIL IS ALREADY SEND FOR THIS VESSEL VOYAGE THEN
                    NO NEED TO SEND MAIL * */
                DBMS_OUTPUT.PUT_LINE('IS_ALREADY_SEND: '|| IS_ALREADY_SEND);

                IF IS_ALREADY_SEND = FALSE THEN
                    DBMS_OUTPUT.PUT_LINE('CALLING MAIL LOGIC');
                    DBMS_OUTPUT.PUT_LINE('PARAMETERS'
                        ||'~'|| J.FK_DISCHARGE_LIST_ID
                        ||'~'|| J.FK_BKG_EQUIPM_DTL
                        ||'~'|| J.FK_BOOKING_NO
                        ||'~'|| G_N_BUSSINESS_KEY_SYNC_CCH_DEL);

                    /* * entotice logic check if list status is loading complete or
                    higher then only it send mail * */
                    PCE_ECM_RAISE_ENOTICE.PRE_CONT_CHNG_SYNC (
                          J.FK_DISCHARGE_LIST_ID
                        -- , P_I_N_EQUIPMENT_SEQ_NO
                        , J.FK_BKG_EQUIPM_DTL
                        , J.FK_BOOKING_NO
                        , G_N_BUSSINESS_KEY_SYNC_CCH_DEL
                        , NULL -- OLD EQUIPMENT NO.
                        , NULL -- NEW EQUIPMENT NO.
                        , 'U'
                        , G_V_USER
                        , TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')
                        , L_V_ERRCD
                    );
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    PRE_TOS_SYNC_ERROR_LOG(
                        'EXCETION IN CALLING MAIL '
                            ||'~'|| J.FK_DISCHARGE_LIST_ID
                            ||'~'|| G_V_SQL_ID
                            ||'~'|| J.FK_BKG_EQUIPM_DTL
                            ||'~'|| J.FK_BOOKING_NO,
                        'SYNC',
                        'D',
                        'SYNC',
                        'A',
                        G_V_USER,
                        SYSDATE,
                        G_V_USER,
                        SYSDATE
                    );
            END ;
            /* *24 end  * */
            IS_ALREADY_SEND := TRUE;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
          L_V_ERRCD := SUBSTR(SQLERRM, 1, 200);
            PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                'EXCETION IN CALLING MAIL '
                    ||'~'|| G_V_SQL_ID
                    ||'~'|| P_I_V_BOOKING_NO
                    ||'~'|| P_I_N_EQUIPMENT_SEQ_NO
                    ||'~'|| L_V_ERRCD,
                'SYNC',
                'D',
                'SYNC',
                'A',
                G_V_USER,
                SYSDATE,
                G_V_USER,
                SYSDATE
            );

    END PRE_EQ_REMOVE_SYNC_MAIL;
    /* *24 end */
END PCE_ECM_SYNC_BOOKING_EZLL;
