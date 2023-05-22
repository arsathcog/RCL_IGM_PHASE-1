CREATE OR REPLACE PACKAGE BODY PCE_EDL_DISCHARGELISTREPORT AS
  
/* Begin of PRV_VCT_ContractList */
PROCEDURE PRE_EDL_BayplanReport
    (   p_o_refCreateArrivalBayPlan     OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_port                    IN           VARCHAR2
        , p_i_v_service                 IN           VARCHAR2
        , p_i_v_vessel                  IN           VARCHAR2
        , p_i_v_terminal                IN           VARCHAR2
        , p_i_v_voyage                  IN           VARCHAR2
        , p_i_v_direction               IN           VARCHAR2
        , p_i_dt_dl_eta                 IN           VARCHAR2
        , p_i_dt_ll_etd                 IN           VARCHAR2
        , p_i_v_rob                     IN           VARCHAR2
        , p_o_v_err_cd                  OUT NOCOPY   VARCHAR2
    )   AS

    
    l_dt_bayplan                DATE;
	l_v_rob						VARCHAR2(1);

BEGIN
    
    IF p_i_dt_dl_eta IS NULL THEN
          l_dt_bayplan := TO_DATE(p_i_dt_ll_etd,'DD/MM/YYYY HH24:MI');
    ELSE
          l_dt_bayplan := TO_DATE(p_i_dt_dl_eta,'DD/MM/YYYY HH24:MI');
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
    FROM   V_TOS_ONBOARD_CONTAINER A , BKP050 B
  WHERE A.DL_FK_BOOKING_NO = B.BWBKNO
  AND A.dl_service   = p_i_v_service
  AND A.LL_VESSEL    = p_i_v_vessel
  AND A.DL_VOYAGE    = p_i_v_voyage
  AND A.DL_DIRECTION = p_i_v_direction
  AND A.DL_POD = p_i_v_port
  AND A.DL_DN_TERMINAL = p_i_v_terminal 
  AND l_dt_bayplan BETWEEN LL_ETD AND DL_ETA   
  AND (l_v_rob = 'N' OR (DL_DISCHARGE_LIST_STATUS NOT IN ('RB') AND LL_LOAD_LIST_STATUS NOT IN ('RB')));
  
EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_err_cd:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
      WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_err_cd));
      
END PRE_EDL_BayplanReport;
/* End of PRV_VCT_ContractList */

END PCE_EDL_DISCHARGELISTREPORT;
/* End of Package Body */

/
