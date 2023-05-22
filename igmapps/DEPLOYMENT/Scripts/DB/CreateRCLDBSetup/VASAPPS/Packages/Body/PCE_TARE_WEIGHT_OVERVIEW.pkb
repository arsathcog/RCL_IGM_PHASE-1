CREATE OR REPLACE PACKAGE BODY VASAPPS.PCE_TARE_WEIGHT_OVERVIEW AS
PROCEDURE PRE_TARE_WEIGHT_OVERVIEW ( p_o_ref_tw_overview     OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                                                     ,p_i_v_eq_number                 VARCHAR2
                                                                       ,p_o_v_error                           OUT VARCHAR2
                                                                   )
AS
BEGIN
      /* Set Success Code */
      p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      
     OPEN P_O_REF_TW_OVERVIEW FOR
       SELECT E61.EQUIP_NO AS EQUIPMENT_NO,
                 E10.EQSIZE AS SIZE_VALUE,
                 E75.TRTPNM AS TYPE_VALUE,
                  TO_CHAR(E61.TARE_WEIGHT, 'FM9,99,99,99,99,990.00') AS  TARE_WEIGHT 
         FROM  ECP061 E61,
                  ECP010 E10,
                 ITP075 E75      
          WHERE E61.EQUIP_NO = P_I_V_EQ_NUMBER
          AND E61.EQUIP_NO = E10.EQEQTN
          AND E10.EQTYPE = E75.TRTYPE(+);
 EXCEPTION
      WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
      WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
         
END  PRE_TARE_WEIGHT_OVERVIEW;    
                                                              
END PCE_TARE_WEIGHT_OVERVIEW;
/
