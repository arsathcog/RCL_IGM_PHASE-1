CREATE OR REPLACE PACKAGE BODY PCE_ELL_LOADLISTOVERVIEW AS
 /*
        *1:  Modified by leena, Added ETA and ETD in sort option 12.07.2012
                 
    */

/* Begin of PRE_EDL_LoadListOverview */
PROCEDURE PRE_ELL_LoadListOverview
                (
                   p_o_refLoadListOverview     OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                   ,p_i_v_service_grp_cd       		  VARCHAR2
                   ,p_i_v_service_cd         		  VARCHAR2
                   ,p_i_v_port_cd        			  VARCHAR2
                   ,p_i_v_terminal_cd       		  VARCHAR2
                   ,p_i_v_fsc_cd            		  VARCHAR2
                   ,p_i_v_vessel_cd      			  VARCHAR2
                   ,p_i_v_out_voyage_cd         	  VARCHAR2
                   ,p_i_v_from_eta_dt				        VARCHAR2
                   ,p_i_v_to_eta_dt					        VARCHAR2
                   ,p_i_v_from_ata_dt				        VARCHAR2
                   ,p_i_v_to_ata_dt					        VARCHAR2
                   ,p_i_v_status_cd      			      VARCHAR2
                   ,p_i_v_sort_by           			  VARCHAR2
                   ,p_i_v_sort_order           		  VARCHAR2
                   ,p_o_v_tot_rec           			  OUT VARCHAR2
                   ,p_i_v_is_control_fsc            VARCHAR2
                   ,p_i_v_user_id                   VARCHAR2
                   ,p_o_v_error             			  OUT VARCHAR2
                )  AS

/*Variable to store SQL*/
l_v_SQL VARCHAR2(5000);
l_v_return_values  VARCHAr2(100);
l_v_fsc           VARCHAR2(3);
l_v_port          VARCHAR2(10);
l_v_flag          VARCHAR2(5);

BEGIN
    /* Set Success Code */
    p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /* Set Total Record to Default -1  */
    p_o_v_tot_rec  := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

      l_v_return_values := PCE_EUT_COMMON.FN_GET_PORT_LIST(p_i_v_user_id,p_i_v_is_control_fsc,p_i_v_port_cd);
      

      l_v_fsc :=SUBSTR(l_v_return_values,0,INSTR(l_v_return_values,',')-1);
      l_v_port :=SUBSTR(SUBSTR(l_v_return_values,INSTR(l_v_return_values,',')+1),0,LENGTH(SUBSTR(l_v_return_values,INSTR(l_v_return_values,',')+1))-LENGTH(SUBSTR(l_v_return_values,INSTR(l_v_return_values,',',-1))));
      l_v_flag := SUBSTR(l_v_return_values,INSTR(l_v_return_values,',',-1)+1,LENGTH(l_v_return_values));

    /* Construct the SQL */
    l_v_SQL := '  SELECT TLL.PK_LOAD_LIST_ID LOAD_LIST_ID,
				  AFS.fsc_code FSC_ID                             ,
				  TLL.DN_SERVICE_GROUP_CODE SERVICEGROUP          ,
				  TLL.fk_service SERVICECD                        ,
				  TLL.dn_port PORT                                ,
				  TLL.fk_vessel VESSEL                            ,
				  TLL.fk_voyage OUTVOYAGE                         ,
				  TLL.fk_direction DIRECTION                      ,
				  TLL.FK_PORT_SEQUENCE_NO SEQUENCE                ,
				  TLL.DN_TERMINAL TERMINAL                        ,
				  AFS.actual_barge_name BARGENAME                 ,
				  AFS.actual_barge_voyage BARGEVOYAGE             ,
				  ITP.VVARDT FROMETA                              ,
				  ITP.VVDPDT TOETA                                ,
				   NVL(ITP.VVAPDT, ITP.VVARDT) FROMATA,
				   NVL(ITP.VVSLDT, ITP.VVDPDT) TOATA,
                  ITP.VVARTM ETATIME                              ,
                  ITP.VVDPTM ETDTIME                              ,
                  ITP.VVAPTM ATATIME                              ,
                  ITP.VVSLTM ATDTIME                              ,
				  DECODE(TLL.LOAD_LIST_STATUS,0,' || '''Open'''     ||
                                    ',5,' || '''Alert Required'''    ||
                                    ',10,'|| '''Loading Complete'''||
                                    ',20,'|| '''Ready for Invoice''' ||
                                    ',30,'|| '''Work Complete'''     ||
          ') STATUS                                       ,
				  TLL.DA_BOOKED_TOT BOOKEDNO                      ,
				  TLL.DA_LOADED_TOT DISCHARGEDNO                  ,
				  TLL.DA_ROB_TOT ROBNO                            ,
				  TLL.DA_OVERSHIPPED_TOT OVERLD                   ,
				  TLL.DA_SHORTSHIPPED_TOT SHORTLD                 ,
				  (TLL.DA_BOOKED_TOT - TLL.DA_LOADED_TOT - TLL.DA_ROB_TOT+TLL.DA_OVERSHIPPED_TOT) ISSUES ,'''
				  || l_v_flag ||''' FLAG '
          ||'FROM
           TOS_LL_LOAD_LIST TLL,
				  afs_voyage_schedule AFS        ,
				  ITP063 ITP
				  WHERE TLL.fk_service       = afs.service(+)
				AND TLL.fk_vessel            = afs.vessel(+)
				AND TLL.fk_voyage            = afs.voyage_no(+)
				AND TLL.fk_direction         = afs.service_direction(+)
				AND TLL.fk_port_sequence_no  = afs.pol_pcsq(+)
				AND afs.version(+)              = 99
				AND TLL.fk_service           = itp.vvsrvc
				AND TLL.fk_vessel            = itp.vvvess
				AND TLL.fk_voyage            = itp.vvvoyn
				AND TLL.fk_direction         = itp.vvpdir
				AND TLL.fk_port_sequence_no  = itp.vvpcsq
                AND TLL.dn_port              = itp.vvpcal
                AND TLL.dn_terminal          = itp.vvtrm1
                AND ITP.OMMISSION_FLAG IS NULL 
				AND itp.vvvers               = 99
				AND TLL.fk_version           = 99
				AND afs.seq_no(+)            = 1';

    /*l_v_SQL := l_v_SQL ||' AND ( ''G1'' IS NULL OR'
    ||' TLL.dn_service_group_code = ''G1'' )';*/

    l_v_SQL := l_v_SQL ||' AND ( ''' || p_i_v_service_grp_cd || ''' IS NULL OR'
    ||' TLL.dn_service_group_code = ''' || p_i_v_service_grp_cd || ''' )'
    ||' AND ( ''' || p_i_v_service_cd || ''' IS NULL OR'
    ||' TLL.fk_service = ''' || p_i_v_service_cd || ''' )'
    ||' AND (  TLL.dn_port = ''' || p_i_v_port_cd || ''')'
    ||' AND (  TLL.dn_terminal = ''' || p_i_v_terminal_cd || ''' )'
    ||' AND ( ''' || p_i_v_vessel_cd || ''' IS NULL OR'
    ||' TLL.fk_vessel = ''' || p_i_v_vessel_cd || ''' )'
    ||' AND ( ''' || p_i_v_out_voyage_cd || ''' IS NULL OR'
    ||' TLL.fk_voyage = ''' || p_i_v_out_voyage_cd || ''' )'
    ||' AND ( ''' || p_i_v_status_cd || ''' IS NULL OR'
    ||' TLL.LOAD_LIST_STATUS = ''' || p_i_v_status_cd ||''' ) '
    ||' AND ( ''' || p_i_v_from_eta_dt || ''' IS NULL OR'
    ||' ITP.vvardt >= ''' || p_i_v_from_eta_dt ||''' ) '
    ||' AND ( ''' || p_i_v_to_eta_dt || ''' IS NULL OR'
    ||' ITP.vvardt <= ''' || p_i_v_to_eta_dt ||''' ) '
    ||' AND ( ''' || p_i_v_from_ata_dt || ''' IS NULL OR'
    ||' ITP.vvapdt >= ''' || p_i_v_from_ata_dt ||''' ) '
    ||' AND ( ''' || p_i_v_to_ata_dt || ''' IS NULL OR'
    ||' ITP.vvapdt <= ''' || p_i_v_to_ata_dt ||''' ) ';


    IF p_i_v_sort_by = 'SERVICE_GRP' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' TLL.dn_service_group_code';
      IF p_i_v_sort_order = 'DESC' THEN
      l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL ||' ,TLL.fk_service,TLL.fk_vessel,TLL.fk_voyage,TLL.fk_direction,TLL.dn_port,TLL.dn_terminal';
    ELSIF p_i_v_sort_by = 'SERVICE' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' TLL.fk_service';
      IF p_i_v_sort_order = 'DESC' THEN
      l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL || ' ,TLL.dn_service_group_code,TLL.fk_vessel,TLL.fk_voyage,TLL.fk_direction,TLL.dn_port,TLL.dn_terminal';
    ELSIF p_i_v_sort_by = 'VESSEL' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' TLL.fk_vessel';
      IF p_i_v_sort_order = 'DESC' THEN
      l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL ||',TLL.dn_service_group_code,TLL.fk_service,TLL.fk_voyage,TLL.fk_direction,TLL.dn_port,TLL.dn_terminal';
    ELSIF p_i_v_sort_by = 'VOYAGE' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' TLL.fk_voyage';
      IF p_i_v_sort_order = 'DESC' THEN
      l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL || ',TLL.dn_service_group_code,TLL.fk_service,TLL.fk_vessel,TLL.fk_direction,TLL.dn_port,TLL.dn_terminal';
    ELSIF p_i_v_sort_by = 'DIRECTION' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' TLL.fk_direction';
      IF p_i_v_sort_order = 'DESC' THEN
      l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL || ',TLL.dn_service_group_code,TLL.fk_service,TLL.fk_vessel,TLL.fk_voyage,TLL.dn_port,TLL.dn_terminal';
    ELSIF p_i_v_sort_by = 'PORT' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' TLL.dn_port';
      IF p_i_v_sort_order = 'DESC' THEN
      l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL || ',TLL.dn_service_group_code,TLL.fk_service,TLL.fk_vessel,TLL.fk_voyage,TLL.fk_direction,TLL.dn_terminal';
    ELSIF p_i_v_sort_by = 'TERMINAL' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' TLL.dn_terminal';
      IF p_i_v_sort_order = 'DESC' THEN
      l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL || ',TLL.dn_service_group_code,TLL.fk_service,TLL.fk_vessel,TLL.fk_voyage,TLL.fk_direction,TLL.dn_port';
	  --*01 begin
	ELSIF p_i_v_sort_by = 'ETA' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' ITP.vvardt ';
      IF p_i_v_sort_order = 'DESC' THEN
      	 l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL || ',TLL.dn_service_group_code,TLL.fk_service,TLL.fk_vessel,TLL.fk_voyage,TLL.fk_direction,TLL.dn_terminal';
    ELSIF p_i_v_sort_by = 'ETD' THEN
      l_v_SQL := l_v_SQL || ' ORDER BY'
      ||' ITP.vvdpdt ';
      IF p_i_v_sort_order = 'DESC' THEN
      	 l_v_SQL := l_v_SQL || ' DESC';
      END IF;
      l_v_SQL := l_v_SQL || ',TLL.dn_service_group_code,TLL.fk_service,TLL.fk_vessel,TLL.fk_voyage,TLL.fk_direction,TLL.dn_terminal';
    --ELSE
   -- l_v_SQL := l_v_SQL || ' ORDER BY'||' ITP.vvardt ' || p_i_v_sort_order;
   --*01 end
    END IF;
	
	
    /* Execute the SQL */
    OPEN p_o_refLoadListOverview FOR l_v_SQL;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
      WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

  END PRE_ELL_LoadListOverview;
  /* End of PRV_ELL_LoadListOverview */

END PCE_ELL_LOADLISTOVERVIEW;
/* End of Package Body */
/
