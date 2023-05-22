CREATE OR REPLACE PACKAGE BODY "PCE_EDL_DISCHARGELISTOVERVIEW" AS
 /*
        *1:  Modified by leena, Added ETA and ETD in sort option 19.07.2012

  */

/* Begin of PRE_EDL_DISCHARGELISTOVERVIEW */
PROCEDURE PRE_EDL_DISCHARGELISTOVERVIEW (
         p_o_refDischargeListOverview        OUT PCE_ECM_REF_CUR.ECM_REF_CUR
       , p_i_v_service_grp_cd                VARCHAR2
       , p_i_v_service_cd                    VARCHAR2
       , p_i_v_port_cd                       VARCHAR2
       , p_i_v_terminal_cd                   VARCHAR2
       , p_i_v_fsc_cd                        VARCHAR2
       , p_i_v_vessel_cd                     VARCHAR2
       , p_i_v_in_voyage_cd                  VARCHAR2
       , p_i_v_from_eta_dt                   VARCHAR2
       , p_i_v_to_eta_dt                     VARCHAR2
       , p_i_v_from_ata_dt                   VARCHAR2
       , p_i_v_to_ata_dt                     VARCHAR2
       , p_i_v_status_cd                     VARCHAR2
       , p_i_v_sort_by                       VARCHAR2
       , p_i_v_sort_order                    VARCHAR2
       , p_o_v_tot_rec                       OUT VARCHAR2
       , p_i_v_is_control_fsc                VARCHAR2
       , p_i_v_user_id                       VARCHAR2
       , p_o_v_error                         OUT VARCHAR2
    )  AS

    /*Variable to store SQL*/
    l_v_SQL            VARCHAR2(5000);

    --Type ref_cur_type PCE_ECM_REF_CUR.ECM_REF_CUR;
    l_v_return_values  VARCHAR2(100);
    l_v_fsc            VARCHAR2(3);
    l_v_port           VARCHAR2(10);
    l_v_flag           VARCHAR2(5);

BEGIN

    /* Set Success Code */
    p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /* Set Total Record to Default -1  */
    p_o_v_tot_rec  := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

    l_v_return_values := PCE_EUT_COMMON.FN_GET_PORT_LIST(p_i_v_user_id,p_i_v_is_control_fsc,p_i_v_port_cd);

    l_v_fsc  := SUBSTR(l_v_return_values,0,INSTR(l_v_return_values,',')-1);
    l_v_port := SUBSTR(SUBSTR(l_v_return_values,INSTR(l_v_return_values,',')+1),0,LENGTH(SUBSTR(l_v_return_values,INSTR(l_v_return_values,',')+1))-LENGTH(SUBSTR(l_v_return_values,INSTR(l_v_return_values,',',-1))));
    l_v_flag := SUBSTR(l_v_return_values,INSTR(l_v_return_values,',',-1)+1,LENGTH(l_v_return_values));


    /* Construct the SQL */
    l_v_SQL := ' SELECT
    TDL.PK_DISCHARGE_LIST_ID DISCHARGE_LIST_ID,
    AFS.fsc_code FSC_ID,
    TDL.dn_service_group_code SERVICEGROUP,
    TDL.fk_service SERVICECD,
    TDL.dn_port PORT,
    TDL.fk_vessel VESSEL,
    TDL.fk_voyage INVOYAGE,
    TDL.fk_direction DIRECTION,
    TDL.fk_port_sequence_no SEQUENCE,
    TDL.dn_terminal TERMINAL,
    AFS.actual_barge_name BARGENAME,
    AFS.actual_barge_voyage BARGEVOYAGE,
    ITP.VVARDT FROMETA,
    ITP.VVDPDT TOETA,
    NVL(ITP.VVAPDT, ITP.VVARDT) FROMATA,
    NVL(ITP.VVSLDT, ITP.VVDPDT) TOATA,
    ITP.VVARTM ETATIME,
    ITP.VVDPTM ETDTIME,
    ITP.VVAPTM ATATIME,
    ITP.VVSLTM ATDTIME,
    DECODE(TDL.discharge_list_status,0,'   || '''Open'''               ||
                                    ',5,'  || '''Alert Required'''    ||
                                    ',10,' || '''Pre-Discharge'''||
                                    ',20,' || '''Ready for Invoice''' ||
                                    ',30,' || '''Discharge Complete'''     ||
    ') STATUS                                       ,
    TDL.da_booked_tot BOOKEDNO,
    TDL.da_discharged_tot DISCHARGEDNO,
    TDL.da_rob_tot ROBNO,
    TDL.da_overlanded_tot OVERLD,
    TDL.da_shortlanded_tot SHORTLD,
    (TDL.da_booked_tot - TDL.da_discharged_tot - TDL.da_rob_tot + TDL.da_overlanded_tot) ISSUES
    ,'''  || l_v_flag ||''' FLAG
    ' ||'
    FROM
    tos_dl_discharge_list TDL,
    afs_voyage_schedule AFS,
    ITP063 ITP
    where
    tdl.fk_service = afs.service(+) and
    tdl.fk_vessel  = afs.vessel(+) and
    tdl.fk_voyage  = afs.voyage_no(+) and
    tdl.fk_direction = afs.service_direction(+) and
    tdl.fk_port_sequence_no = afs.pol_pcsq(+) and
    afs.version(+) = 99 and
    tdl.fk_service = itp.vvsrvc and
    tdl.fk_vessel  = itp.vvvess and
    tdl.fk_voyage  = DECODE(tdl.fk_service,'|| '''AFS''' ||', ITP.VVVOYN, itp.INVOYAGENO) and
    tdl.dn_port    = itp.vvpcal and
    tdl.dn_terminal = itp.vvtrm1 and
    ITP.OMMISSION_FLAG IS NULL and
    tdl.fk_direction = itp.vvpdir and
    tdl.fk_port_sequence_no = itp.vvpcsq and
    itp.vvvers = 99 and
    tdl.fk_version = 99 and
    afs.seq_no(+) = 1 ';

    l_v_SQL := l_v_SQL ||' AND ( ''' || p_i_v_service_grp_cd || ''' IS NULL OR'
    ||' TDL.dn_service_group_code = ''' || p_i_v_service_grp_cd || ''' )'
    ||' AND ( ''' || p_i_v_service_cd || ''' IS NULL OR'
    ||' TDL.fk_service = ''' || p_i_v_service_cd || ''' )'
    ||' AND ( TDL.dn_port = ''' || l_v_port || ''')'
    ||' AND (TDL.dn_terminal = ''' || p_i_v_terminal_cd || ''' )'
    ||' AND ( ''' || p_i_v_vessel_cd || ''' IS NULL OR'
    ||' TDL.fk_vessel = ''' || p_i_v_vessel_cd || ''' )'
    ||' AND ( ''' || p_i_v_in_voyage_cd || ''' IS NULL OR'
    ||' TDL.fk_voyage = ''' || p_i_v_in_voyage_cd || ''' )'
    ||' AND ( ''' || p_i_v_status_cd || ''' IS NULL OR '
    ||' TDL.discharge_list_status = ''' || p_i_v_status_cd ||''' ) '
    ||' AND ( ''' || p_i_v_from_eta_dt || ''' IS NULL OR '
    ||' ITP.vvardt >= ''' || p_i_v_from_eta_dt ||''' ) '
    ||' AND ( ''' || p_i_v_to_eta_dt || ''' IS NULL OR '
    ||'ITP.vvardt <= ''' || p_i_v_to_eta_dt ||''' ) '
    ||' AND ( ''' || p_i_v_from_ata_dt || ''' IS NULL OR '
    ||'ITP.vvapdt >= ''' || p_i_v_from_ata_dt||''' ) '
    ||' AND ( ''' || p_i_v_from_ata_dt || ''' IS NULL OR '
    ||'ITP.vvapdt <= ''' || p_i_v_to_ata_dt ||''' ) ';

    IF p_i_v_sort_by = 'SERVICE_GRP' THEN
        l_v_SQL := l_v_SQL || ' ORDER BY'
        ||' TDL.dn_service_group_code';
        IF p_i_v_sort_order = 'DESC' THEN
            l_v_SQL := l_v_SQL || ' DESC';
        END IF;
        l_v_SQL := l_v_SQL ||' ,TDL.fk_service,TDL.fk_vessel,TDL.fk_voyage,TDL.fk_direction,TDL.dn_port,TDL.dn_terminal';
    ELSIF p_i_v_sort_by = 'SERVICE' THEN
        l_v_SQL := l_v_SQL || ' ORDER BY'
        ||' TDL.fk_service';
        IF p_i_v_sort_order = 'DESC' THEN
            l_v_SQL := l_v_SQL || ' DESC';
        END IF;
        l_v_SQL := l_v_SQL || ' ,TDL.dn_service_group_code,TDL.fk_vessel,TDL.fk_voyage,TDL.fk_direction,TDL.dn_port,TDL.dn_terminal';
    ELSIF p_i_v_sort_by = 'VESSEL' THEN
        l_v_SQL := l_v_SQL || ' ORDER BY'
        ||' TDL.fk_vessel';
        IF p_i_v_sort_order = 'DESC' THEN
            l_v_SQL := l_v_SQL || ' DESC';
        END IF;
        l_v_SQL := l_v_SQL ||',TDL.dn_service_group_code,TDL.fk_service,TDL.fk_voyage,TDL.fk_direction,TDL.dn_port,TDL.dn_terminal';
    ELSIF p_i_v_sort_by = 'VOYAGE' THEN
        l_v_SQL := l_v_SQL || ' ORDER BY'
        ||' TDL.fk_voyage';
        IF p_i_v_sort_order = 'DESC' THEN
            l_v_SQL := l_v_SQL || ' DESC';
        END IF;
        l_v_SQL := l_v_SQL || ',TDL.dn_service_group_code,TDL.fk_service,TDL.fk_vessel,TDL.fk_direction,TDL.dn_port,TDL.dn_terminal';
    ELSIF p_i_v_sort_by = 'DIRECTION' THEN
        l_v_SQL := l_v_SQL || ' ORDER BY'
        ||' TDL.fk_direction';
        IF p_i_v_sort_order = 'DESC' THEN
            l_v_SQL := l_v_SQL || ' DESC';
        END IF;
        l_v_SQL := l_v_SQL || ',TDL.dn_service_group_code,TDL.fk_service,TDL.fk_vessel,TDL.fk_voyage,TDL.dn_port,TDL.dn_terminal';
    ELSIF p_i_v_sort_by = 'PORT' THEN
        l_v_SQL := l_v_SQL || ' ORDER BY'
        ||' TDL.dn_port';
        IF p_i_v_sort_order = 'DESC' THEN
            l_v_SQL := l_v_SQL || ' DESC';
        END IF;
        l_v_SQL := l_v_SQL || ',TDL.dn_service_group_code,TDL.fk_service,TDL.fk_vessel,TDL.fk_voyage,TDL.fk_direction,TDL.dn_terminal';
	ELSIF p_i_v_sort_by = 'TERMINAL' THEN
       l_v_SQL := l_v_SQL || ' ORDER BY'
       ||' TDL.dn_terminal';
       IF p_i_v_sort_order = 'DESC' THEN
           l_v_SQL := l_v_SQL || ' DESC';
       END IF;
       l_v_SQL := l_v_SQL || ',TDL.dn_service_group_code,TDL.fk_service,TDL.fk_vessel,TDL.fk_voyage,TDL.fk_direction,TDL.dn_port';
		-- *01 begin
   ELSIF p_i_v_sort_by = 'ETA' THEN
        l_v_SQL := l_v_SQL || ' ORDER BY'
        ||' ITP.VVARDT ';
        IF p_i_v_sort_order = 'DESC' THEN
            l_v_SQL := l_v_SQL || ' DESC';
        END IF;
        l_v_SQL := l_v_SQL || ',TDL.dn_service_group_code,TDL.fk_service,TDL.fk_vessel,TDL.fk_voyage,TDL.fk_direction,TDL.dn_terminal';

    ELSIF p_i_v_sort_by = 'ETD' THEN
        l_v_SQL := l_v_SQL || ' ORDER BY'
        ||' ITP.VVDPDT ';
        IF p_i_v_sort_order = 'DESC' THEN
            l_v_SQL := l_v_SQL || ' DESC';
        END IF;
        l_v_SQL := l_v_SQL || ',TDL.dn_service_group_code,TDL.fk_service,TDL.fk_vessel,TDL.fk_voyage,TDL.fk_direction,TDL.dn_port';
    END IF;
	-- *01 end
-- 	insert into temp3 values(l_v_SQL);
-- 	commit; 
    /* Execute the SQL */

    OPEN p_o_refDischargeListOverview FOR l_v_SQL;

    EXCEPTION

      WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
      WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

  END PRE_EDL_DISCHARGELISTOVERVIEW;
  /* End of PRV_EDL_DischargeListOverview */

END PCE_EDL_DISCHARGELISTOVERVIEW;
/* End of Package Body */
