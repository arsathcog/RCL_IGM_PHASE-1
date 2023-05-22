CREATE OR REPLACE PROCEDURE PRE_CUTOVER_VOYAGE_CHECK (
      p_i_v_pod                                TOS_ONBOARD_LIST.POD%TYPE
    , p_i_v_pod_terminal                       TOS_ONBOARD_LIST.POD_TERMINAL%TYPE
    , p_i_v_pol_service                        TOS_ONBOARD_LIST.POL_SERVICE%TYPE
    , p_i_v_pol_vessel                         TOS_ONBOARD_LIST.POL_VESSEL%TYPE
    , p_i_v_act_voyage_number                  TOS_ONBOARD_LIST.ACT_VOYAGE_NUMBER%TYPE -- modified by 30.11.2011
    , p_i_v_act_port_sequence                  TOS_ONBOARD_LIST.ACT_PORT_SEQUENCE%TYPE -- modified by 30.11.2011
    , p_o_v_exe_flag                           OUT VARCHAR2
)
AS
/*********************************************************************************************
  Name           :  PRE_CUTOVER_VOYAGE_CHECK
  Module         :  EZLL
  Purpose        :  For TOS_ONBOARD_LIST table update
                    This procedure is called by TOS_ONBOARD_LIST_HANDLER package
                    to check the voyage is available in cutover table TOS_LL_DL_CUTOVER.
  Calls          :
  Returns        :  0: success (voyage found in cutover table)
                    1: failuer

  Author          Date               What
  ------          ----               ----
  VIKAS          23/11/2011         INITIAL VERSION
*********************************************************************************************/

    l_v_invoyage_no                            TOS_LL_DL_CUTOVER.INVOYAGE_NO%TYPE;
    LL_DL_FLAG                                 VARCHAR2(1) := 'D';
    SUCCESS                                    VARCHAR2(1) := '0';
    FAILUER                                       VARCHAR2(1) := '1';
BEGIN

    p_o_v_exe_flag   := FAILUER;

    DBMS_OUTPUT.PUT_LINE(p_i_v_pod ||'~'|| p_i_v_pod_terminal ||'~'|| p_i_v_pol_service
        ||'~'|| p_i_v_pol_vessel ||'~'|| p_i_v_act_voyage_number ||'~'||p_i_v_act_port_sequence);

    /*
        When pod is dubai then no need to check voyage in cutover table,as k'chatgamol, 19.12.2011
        #1 more port added, 09.01.2012
    */
    IF p_i_v_pod NOT IN ('THBKK','THLCH'  -- #1
        ,'MYPKG','MYPEN','SGSIN','INMAA'
        ,'THSGZ','INBOM','INPAV','IDJKT'
        ,'AEDXB')
    THEN
        /*
            Check voyage in cutover table
        */
        SELECT    INVOYAGE_NO
        INTO      l_v_invoyage_no
        FROM      VASAPPS.TOS_LL_DL_CUTOVER LDC
        WHERE     LDC.PORT        = p_i_v_pod
        AND       LDC.TERMINAL    = p_i_v_pod_terminal
        AND       LDC.SERVICE     = p_i_v_pol_service
        AND       LDC.VESSEL      = p_i_v_pol_vessel
        AND       LDC.VOYAGE      = p_i_v_act_voyage_number -- modified by 30.11.2011
        AND       LDC.PORT_SEQ    = p_i_v_act_port_sequence -- modified by 30.11.2011
        AND       LDC.LOAD_DISCH_INDICATOR = LL_DL_FLAG
        AND       ROWNUM         = 1;                        -- added by 30.11.2011

    END IF; -- End of port check

    /* voyage found */
    p_o_v_exe_flag   := SUCCESS;

    DBMS_OUTPUT.PUT_LINE('VOYAGE AVAILABLE IN CUTOVER TABLE');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_o_v_exe_flag   := FAILUER;
        DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
    WHEN OTHERS THEN
        p_o_v_exe_flag   := FAILUER;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);

END PRE_CUTOVER_VOYAGE_CHECK;
/