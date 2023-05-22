CREATE OR REPLACE FUNCTION FE_TRANS_DATA
    (
         p_i_n_eme_uid     NUMBER
       , p_i_v_field_nm    VARCHAR2
       , p_i_v_value       VARCHAR2
    )
RETURN VARCHAR2
IS

l_v_value       IDP050.BYRMKS%TYPE; -- VARCHAR2(100); commented by vikas, 04.11.2011
l_n_email_stat  NUMBER(2) ;

    l_n_eth_uid       NUMBER;

    BEGIN
           SELECT ETH_UID
           INTO   l_n_eth_uid
           FROM   EDI_MESSAGE_TRANSLATION
           WHERE  EME_UID       = p_i_n_eme_uid
           AND    FIELD_CODE    = p_i_v_field_nm
           AND    RECORD_STATUS = 'A';

           SELECT PARTNER_VALUE
           INTO   l_v_value
           FROM   EDI_TRANSLATION_DETAIL
           WHERE  ETH_UID           = l_n_eth_uid
           AND    SEALINER_VALUE    = p_i_v_value;

           RETURN   l_v_value  ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           l_v_value := p_i_v_value;
           RETURN   l_v_value  ;
    END ;
 
/