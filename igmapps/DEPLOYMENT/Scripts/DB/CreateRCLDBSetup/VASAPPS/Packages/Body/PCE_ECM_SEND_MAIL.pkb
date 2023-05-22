create or replace PACKAGE BODY PCE_ECM_SEND_MAIL AS

/* Begin of PRE_ECM_GET_SERVER_DETAILS */
PROCEDURE PRE_ECM_GET_SERVER_DETAILS
                (
                  p_o_v_server_ip                  OUT VARCHAR2
                  ,p_o_v_server_user               OUT VARCHAR2
                  ,p_o_v_server_user_password      OUT VARCHAR2
                  ,p_o_v_error                     OUT VARCHAR2
                 )   AS

BEGIN
  p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

  SELECT config_value into p_o_v_server_ip
  FROM vcm_config_mst
  WHERE config_typ = 'MAIL_SERVER' AND config_cd = 'MAIL_SERVER_IP';

  SELECT config_value into p_o_v_server_user
  FROM vcm_config_mst
  WHERE config_typ = 'MAIL_SERVER' AND config_cd = 'MAIL_SERVER_USER_ID';

  SELECT config_value into p_o_v_server_user_password
  FROM vcm_config_mst
  WHERE config_typ = 'MAIL_SERVER' AND config_cd = 'MAIL_SERVER_PASSWORD';

EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
      WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));


END PRE_ECM_GET_SERVER_DETAILS;
/* End of PRE_ECM_GET_SERVER_DETAILS */

PROCEDURE PRE_ECM_GET_MAIL_RECIPIENTS
                (
                  p_o_refMail_recipients           OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                  ,p_o_v_error                     OUT VARCHAR2
                 ) AS
BEGIN
  p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

  open p_o_refMail_recipients for

  SELECT config_value email_id
  FROM vcm_config_mst
  WHERE config_typ = 'EDI_DOCUMMENT' AND config_cd = 'EDI_MAIL';

  EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
      WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

END PRE_ECM_GET_MAIL_RECIPIENTS;

PROCEDURE PRE_ECM_GET_MAIL_SENDER
                (
                  p_o_refMail_sender           OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                  ,p_o_v_error                     OUT VARCHAR2
                 ) AS
BEGIN
  p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

  open p_o_refMail_sender for

  SELECT config_value sender_email_id
  FROM vcm_config_mst
  WHERE config_typ = 'EDI_DOCUMMENT' AND config_cd = 'EDI_SENDER_MAIL';

  EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
      WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

END PRE_ECM_GET_MAIL_SENDER;

END PCE_ECM_SEND_MAIL;
/* End of Package Body */

/