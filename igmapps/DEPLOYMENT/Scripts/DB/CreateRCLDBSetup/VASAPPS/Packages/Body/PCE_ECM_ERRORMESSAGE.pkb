CREATE OR REPLACE PACKAGE BODY PCE_ECM_ERRORMESSAGE AS

/* Begin of PCE_ECM_ErrorMessage */
PROCEDURE PRE_ECM_ERRORMESSAGE
                (
                    p_o_refErrorMessage              OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                  , p_i_v_ll_dl_flag                 VARCHAR2
                  , p_i_v_load_discharg_id           TOS_DL_OVERLANDED_CONTAINER.FK_DISCHARGE_LIST_ID%TYPE
                  , p_i_v_ol_os_id                   TOS_DL_OVERLANDED_CONTAINER.PK_OVERLANDED_CONTAINER_ID%TYPE
                  , p_o_v_tot_rec                    OUT VARCHAR2
                  , p_o_v_error                      OUT VARCHAR2
                )  AS

/*Variable to store SQL*/
l_v_SQL VARCHAR2(5000);

BEGIN
    /* Set Success Code */
    p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
    /* Set Total Record to Default -1  */
    p_o_v_tot_rec  := PCE_EUT_COMMON.G_V_DEF_TOT_REC;

    /* Construct the SQL *
    l_v_SQL :='select erlg.error_code,erms.ERROR_MESSAGE from TOS_ERROR_LOG ERLG,TOS_ERROR_MST ERMS where erlg.error_code= erms.error_code (+) ';
    l_v_SQL := l_v_SQL ||' AND ( erlg.bkg_no =  ''' || p_i_v_load_discharg_id ||''' ) '||' AND ( erlg.equipment_no=''' || p_i_v_ol_os_id ||''')';

    /* Execute the SQL */
    OPEN p_o_refErrorMessage FOR
        SELECT ERLG.error_code,
          ERMS.ERROR_MESSAGE
           FROM TOS_ERROR_LOG ERLG,
          TOS_ERROR_MST ERMS
          WHERE p_i_v_ll_dl_flag            = 'D'
        AND ( ERLG.FK_DISCHARGE_LIST_ID = p_i_v_load_discharg_id )
        AND ( ERLG.FK_OVERLANDED_ID     = p_i_v_ol_os_id)
        AND ERLG.error_code         = ERMS.error_code (+)
        AND ERLG.RECORD_STATUS = 'A'

          UNION

        SELECT ERLG.error_code,
          ERMS.ERROR_MESSAGE
           FROM TOS_ERROR_LOG ERLG,
          TOS_ERROR_MST ERMS
          WHERE p_i_v_ll_dl_flag         = 'L'
        AND ( ERLG.FK_LOAD_LIST_ID   = p_i_v_load_discharg_id )
        AND ( ERLG.FK_OVERSHIPPED_ID = p_i_v_ol_os_id)
        AND ERLG.error_code      = ERMS.error_code (+)
        AND ERLG.RECORD_STATUS = 'A';

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
      WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

  END PRE_ECM_ERRORMESSAGE;
  /* End of PRE_ECM_ERRORMESSAGE */

END PCE_ECM_ERRORMESSAGE;
/* End of Package Body */

/

