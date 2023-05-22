CREATE OR REPLACE PACKAGE BODY VASAPPS.PCE_ECM_ENOTICE AS
    /* *1:  Issue Fix by vikas, Generate mail only for active receive organization,
            as k'chatgamol, 07.01.2012 * */
    /* *2:  Issue Fix by vikas, enotice sending mail to suspended receipient also,
            as k'watcharee, 10.01.2012 * */
    /* *3:  Modified by vikas, to prevent duplicate mail, commit after changing
            process status, as k'myo, 26.02.2013 */
    /* *4:  Added by vikas, to fix unique key voilation error use sequence
            to get pk value as k'myo, 14.03.2013 */
    /* *5:  Modified by vikas, add filter for suspended record,
            as k'myo, 09.05.2013 */
    /* *6:  Modified by vikas, get attachment directory path form the
            config_master table, as k'myo, 13.05.2013 */
    /* *7   Modified by Nuttapol, Verify only defined application server will process ENotice (SEP 25, 2013) */            

PROCEDURE PRE_GET_SYSTEM_DATE (
      p_i_v_format                          VARCHAR2
    , p_o_v_system_date         OUT NOCOPY  VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
    l_v_system_date  VARCHAR2(30);
BEGIN
    SELECT TO_CHAR(SYSDATE,p_i_v_format)
    INTO   p_o_v_system_date
    FROM   DUAL;

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

FUNCTION EXTRACT_TOKENS(  p_i_v_input_txt VARCHAR2
                        , p_i_v_seperator VARCHAR2
) RETURN tab_tokens IS

    l_v_curr_token            VARCHAR2(4000);
    l_v_remaining_txt         VARCHAR2(4000);

    l_n_token_start_index     NUMBER := 0;
    l_n_token_end_index       NUMBER;
    l_n_sep_size              NUMBER;
    l_n_curr_tab_index        NUMBER := 0;

    l_tab_tokens tab_tokens;

BEGIN

    l_v_remaining_txt := p_i_v_input_txt || p_i_v_seperator;
    l_n_sep_size      := LENGTH(p_i_v_seperator);

    WHILE( INSTR(l_v_remaining_txt, P_i_v_seperator) > 0)
    LOOP
        l_n_token_end_index := INSTR(l_v_remaining_txt
                                    , P_i_v_seperator);

        l_v_curr_token := SUBSTR( l_v_remaining_txt
                                , l_n_token_start_index
                                , (l_n_token_end_index-1));

        l_v_remaining_txt := SUBSTR(  l_v_remaining_txt
                                    , (l_n_token_end_index+l_n_sep_size));

        l_n_curr_tab_index := l_n_curr_tab_index + 1;
        l_tab_tokens(l_n_curr_tab_index) := l_v_curr_token;

    END LOOP;

    RETURN l_tab_tokens;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        DBMS_OUTPUT.PUT_LINE('Exception in - EXTRACT_TOKENS');
END;

FUNCTION EXTRACT_PLACEHOLDERS (
      p_i_v_input_txt         VARCHAR2
    , p_i_v_begin_identifier  VARCHAR2
    , p_i_v_end_identifier    VARCHAR2
) RETURN tab_tokens IS

    l_v_curr_token            VARCHAR2(4000);
    l_v_remaining_txt         VARCHAR2(4000);

    l_n_token_start_index     NUMBER := 0;
    l_n_token_end_index       NUMBER;
    l_n_begin_identifier_size NUMBER;
    l_n_end_identifier_size   NUMBER;
    l_n_curr_tab_index        NUMBER := 0;

    l_tab_tokens tab_tokens;

BEGIN
    l_v_remaining_txt         := p_i_v_input_txt;
    l_n_begin_identifier_size := LENGTH(p_i_v_begin_identifier);
    l_n_end_identifier_size   := LENGTH(p_i_v_end_identifier);

    WHILE( INSTR(l_v_remaining_txt, p_i_v_begin_identifier) > 0)
    LOOP
        l_n_token_start_index := INSTR(l_v_remaining_txt,
                                       p_i_v_begin_identifier);

        l_n_token_start_index := l_n_token_start_index + l_n_begin_identifier_size;

        l_n_token_end_index   := INSTR(l_v_remaining_txt,
                                       p_i_v_end_identifier);

        l_v_curr_token := SUBSTR(l_v_remaining_txt      ,
                                 l_n_token_start_index  ,
                                 (l_n_token_end_index-l_n_token_start_index));

        l_v_remaining_txt := SUBSTR(l_v_remaining_txt,
                                    (l_n_token_end_index+l_n_begin_identifier_size));

        l_n_curr_tab_index := l_n_curr_tab_index + 1;
        l_tab_tokens(l_n_curr_tab_index) := p_i_v_begin_identifier ||
                                            l_v_curr_token         ||
                                            p_i_v_end_identifier;

    END LOOP;

    RETURN l_tab_tokens;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        DBMS_OUTPUT.PUT_LINE('Exception in - EXTRACT_PLACEHOLDERS');
END;

PROCEDURE PRE_GET_ENOTICE_TYPE (
      p_o_refNoticeType         OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN

    p_o_v_error := g_v_success;

    OPEN p_o_refNoticeType FOR
    SELECT CODE, NAME
    FROM (
        SELECT    ''                CODE
                , 'Select One...'   NAME
                , 1                 SR_NO
        FROM DUAL
        UNION ALL
        SELECT    TO_CHAR(PK_E_NOTICE_TYPE_ID)              CODE
                , (E_NOTICE_CODE || ' ' || E_NOTICE_DESC)   NAME
                , 2                                         SR_NO
        FROM   ZND_E_NOTICE_TYPE
        WHERE  RECORD_STATUS = 'A'
    )
    ORDER BY SR_NO, UPPER(NAME);

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_TEMPLATE_LANGUAGE (
      p_o_refTemplateLanguage   OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN

    p_o_v_error := g_v_success;

    OPEN p_o_refTemplateLanguage FOR
    SELECT    g_v_default_lang_cd   CODE
            , ''                    NAME
    FROM DUAL
    UNION ALL
    SELECT   LOCAL_LANGUAGE_CODE    CODE
           , DESCRIPTION            NAME
    FROM LOCAL_LANGUAGE
    ORDER BY 2 ASC NULLS FIRST;

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_ENOTICE_TEMPLATE_DATA (
      p_o_refResultList         OUT        PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_enotice_type_id                 VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN

    p_o_v_error := g_v_success;

    OPEN p_o_refResultList FOR
        SELECT  PK_MAIL_TEMPLATE_ID                             TEMPLATE_ID
              , MAIL_TEMPLATE_DESCRIPTION                       TEMPLATE_DESC
              , NVL(FK_LOCAL_LANGUAGE, g_v_default_lang_cd)     TEMPLATE_LANGUAGE
              , SUBJECT_TEMPLATE                                SUBJECT
              , BODY_HEADER_TEMPLATE                            BODY_HEADER
              , BODY_DETAIL_TEMPLATE                            BODY_DETAIL
              , BODY_FOOTER_TEMPLATE                            BODY_FOOTER
              , ATTACHMENT_FLG                                  ATTACHMENT_FLAG
              , RECORD_STATUS                                   RECORD_STATUS
              , TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')  RECORD_CHANGE_DATE
        FROM ZND_MAIL_TEMPLATE
        WHERE FK_E_NOTICE_TYPE_ID = p_i_v_enotice_type_id
        ORDER BY TEMPLATE_LANGUAGE;

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_INS_ENOTICE_TEMPLATE (
      p_i_v_template_desc                   VARCHAR2
    , p_i_v_enotice_type_id                 VARCHAR2
    , p_i_v_template_language               VARCHAR2
    , p_i_v_subject                         VARCHAR2
    , p_i_v_body_header                     VARCHAR2
    , p_i_v_body_detail                     VARCHAR2
    , p_i_v_body_footer                     VARCHAR2
    , p_i_v_attachment_flag                 VARCHAR2
    , p_i_v_record_status                   VARCHAR2
    , p_i_v_record_add_user                 VARCHAR2
    , p_i_v_record_add_date                 VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

l_n_mail_template_id ZND_MAIL_TEMPLATE.PK_MAIL_TEMPLATE_ID%TYPE;

BEGIN

    p_o_v_error := g_v_success;

    /* *4 start */
    /* SELECT  NVL(MAX(PK_MAIL_TEMPLATE_ID),0) + 1
    INTO    l_n_mail_template_id
    FROM    ZND_MAIL_TEMPLATE; */

    SELECT
        SEQ_MAIL_TEMPLATE.NEXTVAL
    INTO
        L_N_MAIL_TEMPLATE_ID
    FROM
        DUAL;

    /* *4 end */
    INSERT INTO ZND_MAIL_TEMPLATE
    (
      PK_MAIL_TEMPLATE_ID
    , MAIL_TEMPLATE_DESCRIPTION
    , FK_E_NOTICE_TYPE_ID
    , FK_LOCAL_LANGUAGE
    , SUBJECT_TEMPLATE
    , BODY_HEADER_TEMPLATE
    , BODY_DETAIL_TEMPLATE
    , BODY_FOOTER_TEMPLATE
    , ATTACHMENT_FLG
    , RECORD_STATUS
    , RECORD_ADD_USER
    , RECORD_ADD_DATE
    , RECORD_CHANGE_USER
    , RECORD_CHANGE_DATE
    )
    VALUES
    (
      l_n_mail_template_id
    , p_i_v_template_desc
    , p_i_v_enotice_type_id
    , DECODE(p_i_v_template_language, g_v_default_lang_cd, '', p_i_v_template_language)
    , p_i_v_subject
    , p_i_v_body_header
    , p_i_v_body_detail
    , p_i_v_body_footer
    , p_i_v_attachment_flag
    , p_i_v_record_status
    , p_i_v_record_add_user
    , TO_DATE(p_i_v_record_add_date, 'YYYYMMDDHH24MISS')
    , p_i_v_record_add_user ,
      TO_DATE(p_i_v_record_add_date, 'YYYYMMDDHH24MISS')
    );

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_UPD_ENOTICE_TEMPLATE (
      p_i_v_template_id                     VARCHAR2
    , p_i_v_template_desc                   VARCHAR2
    , p_i_v_template_language               VARCHAR2
    , p_i_v_subject                         VARCHAR2
    , p_i_v_body_header                     VARCHAR2
    , p_i_v_body_detail                     VARCHAR2
    , p_i_v_body_footer                     VARCHAR2
    , p_i_v_attachment_flag                 VARCHAR2
    , p_i_v_record_status                   VARCHAR2
    , p_i_v_record_change_user              VARCHAR2
    , p_i_v_record_change_date              VARCHAR2
    , p_i_v_last_upd_time                   VARCHAR2
    , p_o_v_error              OUT  NOCOPY  VARCHAR2
)
IS
    l_v_rec_upd_time        VARCHAR2(14);
    l_v_excp                EXCEPTION;

BEGIN

    p_o_v_error := g_v_success;

    BEGIN
        SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
        INTO   l_v_rec_upd_time
        FROM   ZND_MAIL_TEMPLATE
        WHERE  PK_MAIL_TEMPLATE_ID = p_i_v_template_id
        FOR   UPDATE NOWAIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_error := PCE_EUT_COMMON.G_V_GE0005;
            RAISE l_v_excp;
    END;

    IF l_v_rec_upd_time <> p_i_v_last_upd_time THEN
        p_o_v_error := PCE_EUT_COMMON.G_V_GE0006;
        RAISE l_v_excp;
    END IF;

    UPDATE ZND_MAIL_TEMPLATE
    SET   MAIL_TEMPLATE_DESCRIPTION = p_i_v_template_desc
        , FK_LOCAL_LANGUAGE         = DECODE(p_i_v_template_language, g_v_default_lang_cd, '', p_i_v_template_language)
        , SUBJECT_TEMPLATE          = p_i_v_subject
        , BODY_HEADER_TEMPLATE      = p_i_v_body_header
        , BODY_DETAIL_TEMPLATE      = p_i_v_body_detail
        , BODY_FOOTER_TEMPLATE      = p_i_v_body_footer
        , ATTACHMENT_FLG            = p_i_v_attachment_flag
        , RECORD_STATUS             = p_i_v_record_status
        , RECORD_CHANGE_USER        = p_i_v_record_change_user
        , RECORD_CHANGE_DATE        = TO_DATE(p_i_v_record_change_date, 'YYYYMMDDHH24MISS')
    WHERE PK_MAIL_TEMPLATE_ID       = p_i_v_template_id;

EXCEPTION
    WHEN l_v_excp THEN
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_ENOTICE_VARIABLES (
      p_o_refENoticeVariables   OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_enotice_type_id                 VARCHAR2
    , p_i_v_template_section                VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN

    p_o_v_error := g_v_success;

    OPEN p_o_refENoticeVariables FOR
        SELECT    ''                                CODE
                , ''                                NAME
        FROM DUAL
        UNION ALL
        SELECT   TO_CHAR(PK_E_NOTICE_VARIABLE_ID)   CODE
               , VARIABLE_DESC                      NAME
        FROM  ZND_E_NOTICE_VARIABLE_TYPE
        WHERE FK_E_NOTICE_TYPE_ID  = p_i_v_enotice_type_id
        AND   MULTIPLE_VALUES_FLAG = DECODE(p_i_v_template_section,'D','Y','N')
        AND   RECORD_STATUS        = 'A'
        ORDER BY 2 ASC NULLS FIRST;

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_TEMPLATE_DESCRIPTION (
      p_o_refTemplateList       OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_enotice_type_id                 VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN

    p_o_v_error := g_v_success;

    OPEN p_o_refTemplateList FOR
        SELECT    ''                            CODE
                , 'Select One...'               NAME
        FROM DUAL
        UNION ALL
        SELECT    TO_CHAR(PK_MAIL_TEMPLATE_ID || '~' || FK_E_NOTICE_TYPE_ID)  CODE
                , MAIL_TEMPLATE_DESCRIPTION                                   NAME
        FROM ZND_MAIL_TEMPLATE
        WHERE (p_i_v_enotice_type_id IS NULL OR FK_E_NOTICE_TYPE_ID = p_i_v_enotice_type_id)
        ORDER BY 1 ASC NULLS FIRST;

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_RECIEVING_ORG_DATA (
      p_o_refResultList         OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_search_on                       VARCHAR2
    , p_i_v_enotice_type_id                 VARCHAR2
    , p_i_v_org_type                        VARCHAR2
    , p_i_v_recipient_org                   VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

    l_v_sql_select_clause       VARCHAR2(4000) ;
    l_v_sql_from_clause         VARCHAR2(4000) ;
    l_v_sql_where_clause        VARCHAR2(4000) ;
    l_v_sql_order_by_clause     VARCHAR2(4000) ;

    l_v_system_level_line       ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_LINE%TYPE;
    l_v_system_level_trade      ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_TRADE%TYPE;
    l_v_system_level_agent      ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_AGENT%TYPE;

BEGIN

    p_o_v_error := g_v_success;

    l_v_sql_select_clause :=
        ' SELECT RCV_ORG.PK_RECEIVER_ORG_ID      RECIEVER_ID'            ||
        '     , NOTICE_TYP.E_NOTICE_DESC         NOTICE_TYPE_DESC'       ||
        '     , DECODE(RCV_ORG.ORG_TYPE'                                 ||
        '               ,''F'''                                          ||
        '               ,''FSC'''                                        ||
        '               ,''C'''                                          ||
        '               ,''Customer'''                                   ||
        '               ,''V'''                                          ||
        '               ,''Vendor'''                                     ||
        '               ,''S'''                                          ||
        '               ,''System Level'') ORG_TYPE'                     ||
        '     , DECODE( RCV_ORG.ORG_TYPE'                                ||
        '              , ''F'''                                          ||
        '              , RCV_ORG.FK_FSC_ID'                              ||
        '              , ''C'''                                          ||
        '              , RCV_ORG.FK_CUSTOMER_ID'                         ||
        '              , ''V'''                                          ||
        '              , RCV_ORG.FK_VENDOR_ID'                           ||
        '              , ''S'''                                          ||
        '              , RCV_ORG.FK_SYSTEM_LEVEL_LINE   || ''~'' || '    ||
        '                RCV_ORG.FK_SYSTEM_LEVEL_TRADE  || ''~'' || '    ||
        '                RCV_ORG.FK_SYSTEM_LEVEL_AGENT'                  ||
        '            ) RECIPIENT_ORG'                                    ||
        '    , NOTICE_TEMPLATE.MAIL_TEMPLATE_DESCRIPTION  TEMPLATE_DESC' ||
        '    , RCV_ORG.PRIORITY      PRIORITY'                           ||
        '    , RCV_ORG.RECORD_STATUS STATUS'                             ||
        '    , TO_CHAR(RCV_ORG.RECORD_CHANGE_DATE, ''YYYYMMDDHH24MISS'') RECORD_CHANGE_DATE';

    l_v_sql_from_clause :=
        ' FROM  ZND_RECEIVER_ORG   RCV_ORG'               ||
        '     , ZND_MAIL_TEMPLATE  NOTICE_TEMPLATE'       ||
        '     , ZND_E_NOTICE_TYPE  NOTICE_TYP';

    l_v_sql_where_clause :=
        ' WHERE NOTICE_TYP.PK_E_NOTICE_TYPE_ID      = NOTICE_TEMPLATE.FK_E_NOTICE_TYPE_ID ' ||
        ' AND   NOTICE_TEMPLATE.PK_MAIL_TEMPLATE_ID = RCV_ORG.FK_MAIL_TEMPLATE_ID ' ;

    IF p_i_v_search_on = 'NT' THEN

        l_v_sql_where_clause := l_v_sql_where_clause ||
            ' AND NOTICE_TYP.PK_E_NOTICE_TYPE_ID = ' || p_i_v_enotice_type_id;

        l_v_sql_order_by_clause :=
            ' ORDER BY RCV_ORG.ORG_TYPE'        ||
            '  , RCV_ORG.FK_CUSTOMER_ID'        ||
            '  , RCV_ORG.FK_FSC_ID'             ||
            '  , RCV_ORG.FK_SYSTEM_LEVEL_LINE'  ||
            '  , RCV_ORG.FK_SYSTEM_LEVEL_TRADE' ||
            '  , RCV_ORG.FK_SYSTEM_LEVEL_AGENT' ||
            '  , RCV_ORG.FK_VENDOR_ID'          ||
            '  , NOTICE_TEMPLATE.MAIL_TEMPLATE_DESCRIPTION';

    ELSE

        l_v_sql_where_clause := l_v_sql_where_clause ||
            ' AND   RCV_ORG.ORG_TYPE = ''' || p_i_v_org_type || '''';

        IF p_i_v_org_type = 'F' THEN
            l_v_sql_where_clause := l_v_sql_where_clause ||
            ' AND   RCV_ORG.FK_FSC_ID = ''' || p_i_v_recipient_org || '''';

        ELSIF p_i_v_org_type = 'C' THEN
            l_v_sql_where_clause := l_v_sql_where_clause ||
            ' AND   RCV_ORG.FK_CUSTOMER_ID = ''' || p_i_v_recipient_org || '''';

        ELSIF p_i_v_org_type = 'V' THEN
            l_v_sql_where_clause := l_v_sql_where_clause ||
            ' AND   RCV_ORG.FK_VENDOR_ID = ''' || p_i_v_recipient_org || '''';

        ELSIF p_i_v_org_type = 'S' THEN

            l_v_system_level_line  := SUBSTR(p_i_v_recipient_org,1,INSTR(p_i_v_recipient_org,'~')-1);

            l_v_system_level_trade := SUBSTR(p_i_v_recipient_org,
                                             INSTR(p_i_v_recipient_org,'~')+1,
                                             INSTR(p_i_v_recipient_org,
                                                   '~',
                                                   INSTR(p_i_v_recipient_org,'~')+1) -
                                             INSTR(p_i_v_recipient_org,'~')-1 );

            l_v_system_level_agent := SUBSTR(p_i_v_recipient_org,
                                             INSTR(p_i_v_recipient_org,
                                             '~',
                                             INSTR(p_i_v_recipient_org,'~')+1)+1);

            l_v_sql_where_clause := l_v_sql_where_clause ||
            ' AND   RCV_ORG.FK_SYSTEM_LEVEL_LINE  = '''    || l_v_system_level_line  || '''' ||
            ' AND   RCV_ORG.FK_SYSTEM_LEVEL_TRADE = '''    || l_v_system_level_trade || '''' ||
            ' AND   RCV_ORG.FK_SYSTEM_LEVEL_AGENT = '''    || l_v_system_level_agent || '''' ;

        END IF;

        l_v_sql_order_by_clause :=
            ' ORDER BY NOTICE_TYP.E_NOTICE_DESC ' ||
            '  , NOTICE_TEMPLATE.MAIL_TEMPLATE_DESCRIPTION';
    END IF;

    OPEN p_o_refResultList FOR
        l_v_sql_select_clause ||
        l_v_sql_from_clause   ||
        l_v_sql_where_clause  ||
        l_v_sql_order_by_clause;

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_INS_ENOTICE_RECIEVING_ORG (
      p_i_v_template_id                     VARCHAR2
    , p_i_v_org_type                        VARCHAR2
    , p_i_v_reciever_org                    VARCHAR2
    , p_i_v_priority                        VARCHAR2
    , p_i_v_record_status                   VARCHAR2
    , p_i_v_record_add_user                 VARCHAR2
    , p_i_v_record_add_date                 VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
    l_n_pk_receiver_org_id     ZND_RECEIVER_ORG.PK_RECEIVER_ORG_ID%TYPE;

    l_v_system_level_line       ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_LINE%TYPE;
    l_v_system_level_trade      ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_TRADE%TYPE;
    l_v_system_level_agent      ZND_RECEIVER_ORG.FK_SYSTEM_LEVEL_AGENT%TYPE;

    l_v_template_id             ZND_RECEIVER_ORG.FK_MAIL_TEMPLATE_ID%TYPE;
    l_v_templ_desc              ZND_MAIL_TEMPLATE.MAIL_TEMPLATE_DESCRIPTION%TYPE;
    l_n_existing_rec            NUMBER;

    l_v_excp                    EXCEPTION;

BEGIN
    p_o_v_error := g_v_success;

    /* *4 start */
    /* SELECT  NVL(MAX(PK_RECEIVER_ORG_ID),0) + 1
    INTO    l_n_pk_receiver_org_id
    FROM    ZND_RECEIVER_ORG; */

    SELECT
        SEQ_RECEIVER_ORG.NEXTVAL
    INTO
        l_n_pk_receiver_org_id
    FROM
        DUAL;

    /* *4 end */

    IF p_i_v_org_type = 'S' THEN

        l_v_system_level_line  := SUBSTR(p_i_v_reciever_org,1,INSTR(p_i_v_reciever_org,'~')-1);

        l_v_system_level_trade := SUBSTR(p_i_v_reciever_org,
                                         INSTR(p_i_v_reciever_org,'~')+1,
                                         INSTR(p_i_v_reciever_org,
                                               '~',
                                               INSTR(p_i_v_reciever_org,'~')+1) -
                                         INSTR(p_i_v_reciever_org,'~')-1 );

        l_v_system_level_agent := SUBSTR(p_i_v_reciever_org,
                                         INSTR(p_i_v_reciever_org,
                                         '~',
                                         INSTR(p_i_v_reciever_org,'~')+1)+1);
    ELSE
        l_v_system_level_line  := '';
        l_v_system_level_trade := '';
        l_v_system_level_agent := '';
    END IF;

    IF INSTR(p_i_v_template_id,'~') >0 THEN
    l_v_template_id := SUBSTR(p_i_v_template_id,1,INSTR(p_i_v_template_id,'~')-1);

    ELSE l_v_template_id := p_i_v_template_id;
    END IF;

    IF p_i_v_org_type ='F' THEN
      SELECT COUNT(1)
            INTO l_n_existing_rec
      FROM ZND_RECEIVER_ORG
      WHERE FK_FSC_ID           = p_i_v_reciever_org
      AND   FK_MAIL_TEMPLATE_ID = l_v_template_id ;
    ELSIF p_i_v_org_type ='C' THEN
       SELECT COUNT(1)
            INTO l_n_existing_rec
      FROM ZND_RECEIVER_ORG
      WHERE FK_CUSTOMER_ID      = p_i_v_reciever_org
      AND   FK_MAIL_TEMPLATE_ID = l_v_template_id ;
    ELSIF p_i_v_org_type ='V' THEN
       SELECT COUNT(1)
            INTO l_n_existing_rec
      FROM ZND_RECEIVER_ORG
      WHERE FK_VENDOR_ID        = p_i_v_reciever_org
      AND   FK_MAIL_TEMPLATE_ID = l_v_template_id ;
    ELSIF p_i_v_org_type ='S' THEN
       SELECT COUNT(1)
            INTO l_n_existing_rec
      FROM ZND_RECEIVER_ORG
      WHERE FK_SYSTEM_LEVEL_LINE   = l_v_system_level_line
      AND   FK_SYSTEM_LEVEL_TRADE  = l_v_system_level_trade
      AND   FK_SYSTEM_LEVEL_AGENT  = l_v_system_level_agent
      AND   FK_MAIL_TEMPLATE_ID    = l_v_template_id ;
     END IF;

     IF l_n_existing_rec >0 THEN

        SELECT MAIL_TEMPLATE_DESCRIPTION
        INTO   l_v_templ_desc
        FROM  ZND_MAIL_TEMPLATE
        WHERE PK_MAIL_TEMPLATE_ID = l_v_template_id;


        p_o_v_error := 'ECM.GE0025' || PCE_EUT_COMMON.G_V_ERR_DATA_SEP || REPLACE(p_i_v_reciever_org,'~','/') ||PCE_EUT_COMMON.G_V_ERR_DATA_SEP || l_v_templ_desc ||PCE_EUT_COMMON.G_V_ERR_CD_SEP;
        RAISE l_v_excp;
     END IF;

    INSERT INTO ZND_RECEIVER_ORG
    (
          PK_RECEIVER_ORG_ID
        , FK_MAIL_TEMPLATE_ID
        , ORG_TYPE
        , FK_FSC_ID
        , FK_SYSTEM_LEVEL_LINE
        , FK_SYSTEM_LEVEL_TRADE
        , FK_SYSTEM_LEVEL_AGENT
        , FK_CUSTOMER_ID
        , FK_VENDOR_ID
        , PRIORITY
        , RECORD_STATUS
        , RECORD_ADD_USER
        , RECORD_ADD_DATE
        , RECORD_CHANGE_USER
        , RECORD_CHANGE_DATE
    ) VALUES (
          l_n_pk_receiver_org_id
        , l_v_template_id
        , p_i_v_org_type
        , DECODE(p_i_v_org_type,'F', p_i_v_reciever_org    , NULL)
        , DECODE(p_i_v_org_type,'S', l_v_system_level_line , NULL)
        , DECODE(p_i_v_org_type,'S', l_v_system_level_trade, NULL)
        , DECODE(p_i_v_org_type,'S', l_v_system_level_agent, NULL)
        , DECODE(p_i_v_org_type,'C', p_i_v_reciever_org    , NULL)
        , DECODE(p_i_v_org_type,'V', p_i_v_reciever_org    , NULL)
        , p_i_v_priority
        , p_i_v_record_status
        , p_i_v_record_add_user
        , TO_DATE(p_i_v_record_add_date, 'YYYYMMDDHH24MISS')
        , p_i_v_record_add_user
        , TO_DATE(p_i_v_record_add_date, 'YYYYMMDDHH24MISS')
    );

EXCEPTION
    WHEN l_v_excp THEN
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_UPD_ENOTICE_RECIEVING_ORG(
      p_i_v_reciever_id                     VARCHAR2
    , p_i_v_priority                        VARCHAR2
    , p_i_v_record_status                   VARCHAR2
    , p_i_v_record_change_user              VARCHAR2
    , p_i_v_record_change_date              VARCHAR2
    , p_i_v_last_upd_time                   VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
    l_v_rec_upd_time        VARCHAR2(14);
    l_v_excp                EXCEPTION;
BEGIN
    p_o_v_error := g_v_success;

    BEGIN
        SELECT TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS')
        INTO   l_v_rec_upd_time
        FROM   ZND_RECEIVER_ORG
        WHERE  PK_RECEIVER_ORG_ID = p_i_v_reciever_id
        FOR   UPDATE NOWAIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_error := PCE_EUT_COMMON.G_V_GE0005;
            RAISE l_v_excp;
    END;

    IF l_v_rec_upd_time <> p_i_v_last_upd_time THEN
        p_o_v_error := PCE_EUT_COMMON.G_V_GE0006;
        RAISE l_v_excp;
    END IF;

    UPDATE ZND_RECEIVER_ORG
    SET   PRIORITY            = p_i_v_priority
        , RECORD_STATUS       = p_i_v_record_status
        , RECORD_CHANGE_USER  = p_i_v_record_change_user
        , RECORD_CHANGE_DATE  = TO_DATE(p_i_v_record_change_date, 'YYYYMMDDHH24MISS')
    WHERE  PK_RECEIVER_ORG_ID  = p_i_v_reciever_id;

EXCEPTION
    WHEN l_v_excp THEN
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_RCV_ORG_RECIPIENT_DATA (
      p_o_refResultList         OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_reciever_org                    VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN
    p_o_v_error := g_v_success;

    OPEN p_o_refResultList FOR
        SELECT  PK_ORG_RECIPIENT_ID
              , RECIPIENT_TYPE
              , RECIPIENT_EMAIL
              , RECORD_STATUS
              , TO_CHAR(RECORD_CHANGE_DATE, 'YYYYMMDDHH24MISS') RECORD_CHANGE_DATE
        FROM ZND_ORG_RECIPIENT
        WHERE FK_RECEIVER_ORG_ID = p_i_v_reciever_org;

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;


PROCEDURE PRE_INS_RCV_ORG_RECIPIENT (
      p_i_v_reciever_org                    VARCHAR2
    , p_i_v_recipient_type                  VARCHAR2
    , p_i_v_recipient_email                 VARCHAR2
    , p_i_v_record_status                   VARCHAR2
    , p_i_v_record_add_user                 VARCHAR2
    , p_i_v_record_add_date                 VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

    l_n_pk_org_recipient_id ZND_ORG_RECIPIENT.PK_ORG_RECIPIENT_ID%TYPE;

BEGIN
    p_o_v_error := g_v_success;

    /* *4 start */
    /* SELECT  NVL(MAX(PK_ORG_RECIPIENT_ID),0) + 1
    INTO    l_n_pk_org_recipient_id
    FROM    ZND_ORG_RECIPIENT; */

    SELECT
        SEQ_ORG_RECIPIENT.NEXTVAL
    INTO
        l_n_pk_org_recipient_id
    FROM
        DUAL;

    /* *4 end */

    INSERT INTO ZND_ORG_RECIPIENT
    (
          PK_ORG_RECIPIENT_ID
        , FK_RECEIVER_ORG_ID
        , RECIPIENT_TYPE
        , RECIPIENT_EMAIL
        , RECORD_STATUS
        , RECORD_ADD_USER
        , RECORD_ADD_DATE
        , RECORD_CHANGE_USER
        , RECORD_CHANGE_DATE
    ) VALUES (
          l_n_pk_org_recipient_id
        , p_i_v_reciever_org
        , p_i_v_recipient_type
        , p_i_v_recipient_email
        , p_i_v_record_status
        , p_i_v_record_add_user
        , TO_DATE(p_i_v_record_add_date, 'YYYYMMDDHH24MISS')
        , p_i_v_record_add_user
        , TO_DATE(p_i_v_record_add_date, 'YYYYMMDDHH24MISS')
    );

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_UPD_RCV_ORG_RECIPIENT (
      p_i_v_org_recipient_id                VARCHAR2
    , p_i_v_recipient_type                  VARCHAR2
    , p_i_v_recipient_email                 VARCHAR2
    , p_i_v_record_status                   VARCHAR2
    , p_i_v_record_change_user              VARCHAR2
    , p_i_v_record_change_date              VARCHAR2
    , p_i_v_last_upd_time                   VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
    l_v_rec_upd_time        VARCHAR2(14);
    l_v_excp                EXCEPTION;

BEGIN
    p_o_v_error := g_v_success;

    BEGIN
        SELECT TO_CHAR(RECORD_CHANGE_DATE,'YYYYMMDDHH24MISS')
        INTO   l_v_rec_upd_time
        FROM   ZND_ORG_RECIPIENT
        WHERE  PK_ORG_RECIPIENT_ID = p_i_v_org_recipient_id
        FOR   UPDATE NOWAIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_error := PCE_EUT_COMMON.G_V_GE0005;
            RAISE l_v_excp;
    END;

    IF l_v_rec_upd_time <> p_i_v_last_upd_time THEN
        p_o_v_error := PCE_EUT_COMMON.G_V_GE0006;
        RAISE l_v_excp;
    END IF;

    UPDATE ZND_ORG_RECIPIENT
    SET   RECIPIENT_TYPE      = p_i_v_recipient_type
        , RECIPIENT_EMAIL     = p_i_v_recipient_email
        , RECORD_STATUS       = p_i_v_record_status
        , RECORD_CHANGE_USER  = p_i_v_record_change_user
        , RECORD_CHANGE_DATE  = TO_DATE(p_i_v_record_change_date, 'YYYYMMDDHH24MISS')
    WHERE  PK_ORG_RECIPIENT_ID = p_i_v_org_recipient_id;

EXCEPTION
    WHEN l_v_excp THEN
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_PREPARE_ENOTICE_CONTENTS (
      p_i_v_enotice_request_id              VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
    l_v_fk_e_notice_type_id     ZND_E_NOTICE_REQUEST.FK_E_NOTICE_TYPE_ID%TYPE;
    l_v_data_key                ZND_E_NOTICE_REQUEST.DATA_KEY%TYPE;
    l_v_data_value              ZND_E_NOTICE_REQUEST.DATA_VALUE%TYPE;
    l_v_fk_originating_fsc      ZND_E_NOTICE_REQUEST.FK_ORIGINATING_FSC%TYPE;

    l_v_subject_template        ZND_MAIL_TEMPLATE.SUBJECT_TEMPLATE%TYPE;
    l_v_body_header_template    ZND_MAIL_TEMPLATE.BODY_HEADER_TEMPLATE%TYPE;
    l_v_body_detail_template    ZND_MAIL_TEMPLATE.BODY_DETAIL_TEMPLATE%TYPE;
    l_v_body_footer_template    ZND_MAIL_TEMPLATE.BODY_FOOTER_TEMPLATE%TYPE;
    l_v_attachment_flg          ZND_MAIL_TEMPLATE.ATTACHMENT_FLG%TYPE;
    l_v_priority                ZND_RECEIVER_ORG.PRIORITY%TYPE;
    l_v_pk_receiver_org_id      ZND_RECEIVER_ORG.PK_RECEIVER_ORG_ID%TYPE;

    l_v_subject_line            ZND_E_NOTICE.MAIL_SUBJECT%TYPE;
    l_v_mail_body_header        ZND_E_NOTICE.MAIL_BODY_HEADER%TYPE;
    l_v_mail_body_detail        ZND_E_NOTICE.MAIL_BODY_DETAIL%TYPE;
    l_v_mail_body_footer        ZND_E_NOTICE.MAIL_BODY_FOOTER%TYPE;

    l_v_system_date             VARCHAR2(20);

    l_n_remaining_recs          NUMBER;

    l_excp_finish             EXCEPTION;

    CURSOR l_cur_znd_e_notice IS
        SELECT    PK_E_NOTICE_ID
                , ORG_TYPE
                , FK_FSC_ID
                , FK_SYSTEM_LEVEL_LINE
                , FK_SYSTEM_LEVEL_TRADE
                , FK_SYSTEM_LEVEL_AGENT
                , FK_CUSTOMER_ID
                , FK_VENDOR_ID
        FROM ZND_E_NOTICE
        WHERE FK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

    CURSOR l_cur_znd_e_notice_param IS
        SELECT    DATA_KEY
                , DATA_VALUE
        FROM ZND_E_NOTICE_PARAM
        WHERE FK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

BEGIN
    p_o_v_error := g_v_success;

    g_v_sql_id := '1';
    DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
    PRE_GET_SYSTEM_DATE('YYYYMMHH24MISS', l_v_system_date, p_o_v_error);

    g_v_sql_id := '2';
    DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
    SELECT    FK_E_NOTICE_TYPE_ID
            , DATA_KEY
            , DATA_VALUE
            , FK_ORIGINATING_FSC
    INTO      l_v_fk_e_notice_type_id
            , l_v_data_key
            , l_v_data_value
            , l_v_fk_originating_fsc
    FROM ZND_E_NOTICE_REQUEST
    WHERE PK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

    g_v_sql_id := '3';
    DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
    FOR l_rec_znd_e_notice IN l_cur_znd_e_notice
    LOOP

        l_v_subject_line     := '';
        l_v_mail_body_header := '';
        l_v_mail_body_detail := '';
        l_v_mail_body_footer := '';

        g_v_sql_id := '4';
        DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
        DBMS_OUTPUT.PUT_LINE(
            l_rec_znd_e_notice.PK_E_NOTICE_ID
            ||'~'||l_rec_znd_e_notice.ORG_TYPE
            ||'~'||l_rec_znd_e_notice.FK_FSC_ID
            ||'~'||l_rec_znd_e_notice.FK_SYSTEM_LEVEL_LINE
            ||'~'||l_rec_znd_e_notice.FK_SYSTEM_LEVEL_TRADE
            ||'~'||l_rec_znd_e_notice.FK_SYSTEM_LEVEL_AGENT
            ||'~'||l_rec_znd_e_notice.FK_CUSTOMER_ID
            ||'~'||l_rec_znd_e_notice.FK_VENDOR_ID
            ||'~'||p_i_v_enotice_request_id
            ||'~'||l_v_fk_e_notice_type_id);

        BEGIN
            BEGIN

               SELECT    MT.SUBJECT_TEMPLATE
                        , MT.BODY_HEADER_TEMPLATE
                        , MT.BODY_DETAIL_TEMPLATE
                        , MT.BODY_FOOTER_TEMPLATE
                        , MT.ATTACHMENT_FLG
                        , RO.PRIORITY
                        , RO.PK_RECEIVER_ORG_ID
                INTO      l_v_subject_template
                        , l_v_body_header_template
                        , l_v_body_detail_template
                        , l_v_body_footer_template
                        , l_v_attachment_flg
                        , l_v_priority
                        , l_v_pk_receiver_org_id
                FROM      ZND_MAIL_TEMPLATE        MT
                        , ZND_RECEIVER_ORG         RO
                WHERE MT. PK_MAIL_TEMPLATE_ID     = RO. FK_MAIL_TEMPLATE_ID
                AND   MT.FK_E_NOTICE_TYPE_ID      = l_v_fk_e_notice_type_id
                AND   RO.ORG_TYPE                 = l_rec_znd_e_notice.ORG_TYPE
                AND   RO.RECORD_STATUS            = 'A' -- *1
                AND   MT.RECORD_STATUS            = 'A' -- *5
                AND   ( (RO.ORG_TYPE              = 'C' AND
                         RO.FK_CUSTOMER_ID        = l_rec_znd_e_notice.FK_CUSTOMER_ID) OR
                        (RO.ORG_TYPE              = 'F' AND
                         RO.FK_FSC_ID             = l_rec_znd_e_notice.FK_FSC_ID ) OR
                        (RO.ORG_TYPE              = 'S' AND
                         RO.FK_SYSTEM_LEVEL_LINE  = l_rec_znd_e_notice.FK_SYSTEM_LEVEL_LINE  AND
                         RO.FK_SYSTEM_LEVEL_TRADE = l_rec_znd_e_notice.FK_SYSTEM_LEVEL_TRADE AND
                         RO.FK_SYSTEM_LEVEL_AGENT = l_rec_znd_e_notice.FK_SYSTEM_LEVEL_AGENT) OR
                        (RO.ORG_TYPE              = 'V' AND
                         RO.FK_VENDOR_ID          = l_rec_znd_e_notice.FK_VENDOR_ID)
                      );
            EXCEPTION
                WHEN OTHERS THEN   
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
                        l_rec_znd_e_notice.ORG_TYPE
                        ||'~'|| l_rec_znd_e_notice.FK_CUSTOMER_ID
                        ||'~'|| l_rec_znd_e_notice.FK_FSC_ID
                        ||'~'|| l_rec_znd_e_notice.FK_SYSTEM_LEVEL_LINE
                        ||'~'|| l_rec_znd_e_notice.FK_SYSTEM_LEVEL_TRADE
                        ||'~'|| l_rec_znd_e_notice.FK_SYSTEM_LEVEL_AGENT
                        ||'~'|| l_rec_znd_e_notice.FK_VENDOR_ID,
                        'ENOTICE',
                        'M',
                        'FSC NOT FOUND:~'|| SQLERRM,
                        'A',
                        'EZLL',
                        SYSDATE,
                        'EZLL',
                        SYSDATE,
                        P_O_V_ERROR,
                        NULL
                    );
                    COMMIT;

                    RAISE NO_DATA_FOUND ;
            END;

        g_v_sql_id := '5';
        DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
        l_v_subject_line := l_v_subject_template;
        DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS SUBJECT TEMP~'||l_v_subject_template);
        PRE_REPLACE_PLACEHOLDERS( l_v_subject_template
                                , l_v_data_key
                                , l_v_data_value
                                , l_v_subject_line
                                );

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_excp_finish;
        END IF;

        g_v_sql_id := '6';
        DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
        l_v_mail_body_header := l_v_body_header_template;
        PRE_REPLACE_PLACEHOLDERS( l_v_body_header_template
                                , l_v_data_key
                                , l_v_data_value
                                , l_v_mail_body_header
                                );

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_excp_finish;
        END IF;

        g_v_sql_id := '7';
        DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
        l_v_mail_body_footer := l_v_body_footer_template;
        PRE_REPLACE_PLACEHOLDERS( l_v_body_footer_template
                                , l_v_data_key
                                , l_v_data_value
                                , l_v_mail_body_footer
                                );

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_excp_finish;
        END IF;

        g_v_sql_id := '8';
        DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
        FOR l_rec_znd_e_notice_param IN l_cur_znd_e_notice_param
        LOOP
            g_v_sql_id := '9';

            DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
            l_v_mail_body_detail := l_v_mail_body_detail        ||
                                    l_v_body_detail_template    ||
                                    g_c_new_line;

            g_v_sql_id := '10';

            DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
            PRE_REPLACE_PLACEHOLDERS( l_v_body_detail_template
                                    , l_rec_znd_e_notice_param.DATA_KEY
                                    , l_rec_znd_e_notice_param.DATA_VALUE
                                    , l_v_mail_body_detail);

            IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
                RAISE l_excp_finish;
            END IF;

        END LOOP;

        g_v_sql_id := '11';
        DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
        PRE_UPD_ENOTICE(  l_rec_znd_e_notice.PK_E_NOTICE_ID
                        , l_v_priority
                        , l_v_subject_line
                        , l_v_mail_body_header
                        , l_v_mail_body_detail
                        , l_v_mail_body_footer);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_excp_finish;
        END IF;

        g_v_sql_id := '12';
        DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
        PRE_INS_ENOTICE_RECIPIENTS(  l_rec_znd_e_notice.PK_E_NOTICE_ID
                                   , l_v_pk_receiver_org_id
                                   , l_v_system_date);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            RAISE l_excp_finish;
        END IF;

 EXCEPTION
 WHEN NO_DATA_FOUND THEN

    DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS delete called');
    g_v_sql_id := '13';
    DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);

    DELETE FROM ZND_E_NOTICE
    WHERE PK_E_NOTICE_ID = l_rec_znd_e_notice.PK_E_NOTICE_ID;

    g_v_sql_id := '14';
    DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
    DELETE FROM ZND_E_NOTICE_RECIPIENT
    WHERE FK_E_NOTICE_ID = l_rec_znd_e_notice.PK_E_NOTICE_ID;

    g_v_sql_id := '15';
    DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
    SELECT COUNT(1)
    INTO   l_n_remaining_recs
    FROM   ZND_E_NOTICE
    WHERE  FK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

    IF l_n_remaining_recs = 0 THEN

      g_v_sql_id := '16';
      DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
      DELETE FROM ZND_E_NOTICE_REQUEST
      WHERE PK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

      g_v_sql_id := '17';
      DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);

      DELETE FROM ZND_E_NOTICE_PARAM
      WHERE FK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

      g_v_sql_id := '18';
      DBMS_OUTPUT.PUT_LINE('PCE_ECM_ENOTICE.PRE_PREPARE_ENOTICE_CONTENTS~'||g_v_sql_id);
      DELETE FROM ZND_E_NOTICE_ATTACHMENT
      WHERE FK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

    END IF;
 END;

    END LOOP;

    /* Completed Successfully */
    g_v_sql_id := '';
    g_v_usr_err_msg := 'Program finished successfully.';
    p_o_v_error := g_v_success ;

EXCEPTION
    WHEN l_excp_finish THEN

        DBMS_OUTPUT.PUT_LINE('In exception block l_excp_finish >>> ' || g_v_sql_id);
        DBMS_OUTPUT.PUT_LINE('g_v_ora_err_cd >>> '|| g_v_ora_err_cd);
        DBMS_OUTPUT.PUT_LINE('g_v_usr_err_cd >>> '|| g_v_usr_err_cd);
        DBMS_OUTPUT.PUT_LINE('ERROR >>> '         || SQLERRM);

        IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
            IF (g_v_usr_err_cd <> g_v_success ) THEN
                p_o_v_error := g_v_usr_err_cd;
            ELSE
                p_o_v_error := g_v_ora_err_cd;
            END IF;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        END IF ;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('In exception block others >>> ' || g_v_sql_id);
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_REPLACE_PLACEHOLDERS (
      p_i_v_template_text                   VARCHAR2
    , p_i_v_variable_key                    VARCHAR2
    , p_i_v_variable_value                  VARCHAR2
    , p_io_v_return_text     IN OUT NOCOPY  VARCHAR2
)
IS

    l_v_tab_placeholders    PCE_ECM_ENOTICE.tab_tokens;
    l_v_tab_keys            PCE_ECM_ENOTICE.tab_tokens;
    l_v_tab_values          PCE_ECM_ENOTICE.tab_tokens;

    l_v_curr_placeholder    ZND_E_NOTICE_PARAM.DATA_KEY%TYPE;
    l_v_curr_key            ZND_E_NOTICE_PARAM.DATA_KEY%TYPE;
    l_v_curr_value          ZND_E_NOTICE_PARAM.DATA_VALUE%TYPE;

BEGIN

    l_v_tab_placeholders := PCE_ECM_ENOTICE.EXTRACT_PLACEHOLDERS( p_i_v_template_text
                                                                , g_c_placeholder_begin_text
                                                                , g_c_placeholder_end_text
                                                                );

    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RETURN;
    END IF;

    l_v_tab_keys   := PCE_ECM_ENOTICE.EXTRACT_TOKENS( p_i_v_variable_key
                                                    , g_c_param_seperator);

    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RETURN;
    END IF;

    l_v_tab_values := PCE_ECM_ENOTICE.EXTRACT_TOKENS( p_i_v_variable_value
                                                    , g_c_param_seperator);

    IF g_v_ora_err_cd <> g_v_success OR g_v_usr_err_cd <> g_v_success THEN
        RETURN;
    END IF;

    FOR i IN 1..l_v_tab_placeholders.COUNT
    LOOP
        l_v_curr_placeholder := l_v_tab_placeholders(i);

        FOR j IN 1..l_v_tab_keys.COUNT
        LOOP
            l_v_curr_key := l_v_tab_keys(j);

            IF l_v_curr_placeholder = l_v_curr_key THEN

                l_v_curr_value := l_v_tab_values(j);

                p_io_v_return_text := replace(p_io_v_return_text,
                                                l_v_curr_placeholder,
                                              l_v_curr_value);

            END IF;
        END LOOP;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_REPLACE_PLACEHOLDERS');
END;

PROCEDURE PRE_UPD_ENOTICE (
      p_i_v_pk_e_notice_id                  VARCHAR2
    , p_i_v_priority                        VARCHAR2
    , p_i_v_subject_line                    VARCHAR2
    , p_i_v_mail_body_header                VARCHAR2
    , p_i_v_mail_body_detail                VARCHAR2
    , p_i_v_mail_body_footer                VARCHAR2
)
IS
BEGIN
    UPDATE ZND_E_NOTICE
    SET   PRIORITY            = p_i_v_priority
        , MAIL_SUBJECT        = p_i_v_subject_line
        , MAIL_BODY_HEADER    = p_i_v_mail_body_header
        , MAIL_BODY_DETAIL    = p_i_v_mail_body_detail
        , MAIL_BODY_FOOTER    = p_i_v_mail_body_footer
        , DAEMON_FLG          = 'Y'
    WHERE PK_E_NOTICE_ID = p_i_v_pk_e_notice_id;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_UPD_ENOTICE');
END;

PROCEDURE PRE_INS_ENOTICE_RECIPIENTS (
      p_i_v_enotice_id                      VARCHAR2
    , p_i_v_receiver_org_id                 VARCHAR2
    , p_i_v_system_date                     VARCHAR2
)
IS
    l_n_pk_e_notice_recipient_id    ZND_E_NOTICE_RECIPIENT.PK_E_NOTICE_RECIPIENT_ID%TYPE;

    CURSOR l_cur_znd_org_recipient IS
    SELECT   RECIPIENT_TYPE
           , RECIPIENT_EMAIL
    FROM  ZND_ORG_RECIPIENT
    WHERE FK_RECEIVER_ORG_ID = p_i_v_receiver_org_id
    AND RECORD_STATUS = 'A'; -- *2

BEGIN

    FOR l_rec_znd_org_recipient IN l_cur_znd_org_recipient
    LOOP

        /* *4 start */
        /* SELECT  NVL(MAX(PK_E_NOTICE_RECIPIENT_ID),0) + 1
        INTO    l_n_pk_e_notice_recipient_id
        FROM    ZND_E_NOTICE_RECIPIENT; */

        SELECT
            SEQ_MAIL_RECIPIENT.NEXTVAL
        INTO
            l_n_pk_e_notice_recipient_id
        FROM
            DUAL;

        /* *4 end */

        INSERT INTO ZND_E_NOTICE_RECIPIENT
        (
              PK_E_NOTICE_RECIPIENT_ID
            , FK_E_NOTICE_ID
            , RECIPIENT_TYPE
            , RECIPIENT_EMAIL
            , RECORD_STATUS
            , RECORD_ADD_USER
            , RECORD_ADD_DATE
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE
        ) VALUES (
              l_n_pk_e_notice_recipient_id
            , p_i_v_enotice_id
            , l_rec_znd_org_recipient.RECIPIENT_TYPE
            , l_rec_znd_org_recipient.RECIPIENT_EMAIL
            , 'A'
            , 'SYSTEM'
            , SYSDATE -- TO_DATE(p_i_v_system_date, 'YYYYMMHH24MISS')
            , 'SYSTEM'
            , SYSDATE -- TO_DATE(p_i_v_system_date, 'YYYYMMHH24MISS')
        );

    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        g_v_ora_err_cd  := SQLCODE;
        DBMS_OUTPUT.PUT_LINE('Exception in - PRE_INS_ENOTICE_RECIPIENTS');
END;

PROCEDURE PRE_GEN_ENOTICE_REQUEST (
      p_io_enotice_request_id OUT    NOCOPY   VARCHAR2
    , p_i_v_business_key                      VARCHAR2
    , p_i_v_notice_type                       VARCHAR2
    , p_array_data_key                        STRING_ARRAY
    , p_array_data_value                      STRING_ARRAY
    , p_i_v_originating_fsc                   VARCHAR2
    , p_i_v_add_user                          VARCHAR2
    , p_i_v_add_date                          VARCHAR2
    , p_o_v_error               OUT NOCOPY    VARCHAR2
)
IS

    l_v_data_key            ZND_E_NOTICE_REQUEST.DATA_KEY%TYPE   := '';
    l_v_data_value          ZND_E_NOTICE_REQUEST.DATA_VALUE%TYPE := '';

    l_v_error varchar2(4000); -- *4
BEGIN

    p_o_v_error := g_v_success;

    FOR i IN 1 .. p_array_data_key.COUNT
    LOOP
        l_v_data_key   := l_v_data_key   || g_c_param_seperator || p_array_data_key(i);
        l_v_data_value := l_v_data_value || g_c_param_seperator || p_array_data_value(i);
    END LOOP;

    IF l_v_data_key IS NOT NULL THEN
        l_v_data_key   := SUBSTR(l_v_data_key  , 2);
        l_v_data_value := SUBSTR(l_v_data_value, 2);
    END IF;

    /* *4 start */
    /* SELECT  NVL(MAX(PK_E_NOTICE_REQUEST_ID),0) + 1
    INTO    p_io_enotice_request_id
    FROM    ZND_E_NOTICE_REQUEST; */

    SELECT
        SE_ZND_E_REQ.NEXTVAL
    INTO
        P_IO_ENOTICE_REQUEST_ID
    FROM
        DUAL;

    /* *4 end */

    INSERT INTO ZND_E_NOTICE_REQUEST
    (
          PK_E_NOTICE_REQUEST_ID
        , BUSINESS_KEY_ID
        , FK_E_NOTICE_TYPE_ID
        , DATA_KEY
        , DATA_VALUE
        , FK_ORIGINATING_FSC
        , RECORD_ADD_USER
        , RECORD_ADD_DATE
    ) VALUES (
          p_io_enotice_request_id
        , p_i_v_business_key
        , p_i_v_notice_type
        , l_v_data_key
        , l_v_data_value
        , p_i_v_originating_fsc
        , p_i_v_add_user
        , TO_DATE(p_i_v_add_date, 'YYYYMMDDHH24MISS')
    );

EXCEPTION
    WHEN OTHERS THEN 
        --p_o_v_error := SQLCODE || '~' || SQLERRM;
        l_v_error := SQLCODE || '~' || SQLERRM;
        p_o_v_error := SQLCODE;
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(
            'PRE_GEN_ENOTICE_REQUEST'
                ||'~'|| p_io_enotice_request_id
                ||'~'|| p_i_v_business_key
                ||'~'|| p_i_v_notice_type
                ||'~'|| l_v_data_key
                ||'~'|| l_v_data_value
                ||'~'|| p_i_v_originating_fsc
                ||'~'|| p_i_v_add_user
                ||'~'|| p_i_v_add_date,
            'MAIL_TRIG-5',
            'M',
            l_v_error,
            'A',
            p_i_v_add_user,
            SYSDATE,
            p_i_v_add_user,
            SYSDATE,
            'PRE_GEN_ENOTICE_REQUEST',
            l_v_error
        );
        commit;

        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GEN_ENOTICE_DETAIL_LINE (
      p_i_v_enotice_request_id              VARCHAR2
    , p_array_data_key                      STRING_ARRAY
    , p_array_data_value                    STRING_ARRAY
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
    l_v_enotice_param_id    ZND_E_NOTICE_PARAM.PK_E_NOTICE_PARAM_ID%TYPE;
    l_v_data_key            ZND_E_NOTICE_PARAM.DATA_KEY%TYPE   := '';
    l_v_data_value          ZND_E_NOTICE_PARAM.DATA_VALUE%TYPE := '';

BEGIN

    p_o_v_error := g_v_success;

    FOR i IN 1 .. p_array_data_key.COUNT
    LOOP
        l_v_data_key   := l_v_data_key   || g_c_param_seperator || p_array_data_key(i);
        l_v_data_value := l_v_data_value || g_c_param_seperator || p_array_data_value(i);
    END LOOP;

    IF l_v_data_key IS NOT NULL THEN
        l_v_data_key   := SUBSTR(l_v_data_key  , 2);
        l_v_data_value := SUBSTR(l_v_data_value, 2);
    END IF;

    /* *4 start */
    /* SELECT  NVL(MAX(PK_E_NOTICE_PARAM_ID),0) + 1
    INTO    l_v_enotice_param_id
    FROM    ZND_E_NOTICE_PARAM; */

    SELECT
        SEQ_MAIL_PARAM.NEXTVAL
    INTO
        l_v_enotice_param_id
    FROM
        DUAL;

    /* *4 end */
dbms_output.put_line('l_v_enotice_param_id:'||l_v_enotice_param_id);
dbms_output.put_line('p_i_v_enotice_request_id:'||p_i_v_enotice_request_id);
dbms_output.put_line('l_v_data_key:'||l_v_data_key);
dbms_output.put_line('l_v_data_value:'||l_v_data_value);
    INSERT INTO ZND_E_NOTICE_PARAM
    (
          PK_E_NOTICE_PARAM_ID
        , FK_E_NOTICE_REQUEST_ID
        , DATA_KEY
        , DATA_VALUE
        , RECORD_ADD_USER
        , RECORD_ADD_DATE
    ) VALUES (
          l_v_enotice_param_id
        , p_i_v_enotice_request_id
        , l_v_data_key
        , l_v_data_value
        , p_i_v_add_user
        , TO_DATE(p_i_v_add_date, 'YYYYMMDDHH24MISS')
    );

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GEN_ENOTICE_RCV_ORG (
      p_i_v_enotice_request_id              VARCHAR2
    , p_i_v_org_type                        VARCHAR2
    , p_i_v_fsc_id                          VARCHAR2
    , p_i_v_customer_id                     VARCHAR2
    , p_i_v_vendor_id                       VARCHAR2
    , p_i_v_system_level_line               VARCHAR2
    , p_i_v_system_level_trade              VARCHAR2
    , p_i_v_system_level_agent              VARCHAR2
    , p_i_v_attachment_flag                 VARCHAR2
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

    l_v_enotice_id      ZND_E_NOTICE.PK_E_NOTICE_ID%TYPE;

BEGIN

    p_o_v_error := g_v_success;

    /* *4 start */
    /* SELECT  NVL(MAX(PK_E_NOTICE_ID),0) + 1
    INTO    l_v_enotice_id
    FROM    ZND_E_NOTICE; */

    SELECT
        SEQ_E_NOTICE.NEXTVAL
    INTO
        l_v_enotice_id
    FROM
        DUAL;
    /* *4 end */

    INSERT INTO ZND_E_NOTICE (
          PK_E_NOTICE_ID
        , FK_E_NOTICE_REQUEST_ID
        , ORG_TYPE
        , FK_FSC_ID
        , FK_CUSTOMER_ID
        , FK_VENDOR_ID
        , FK_SYSTEM_LEVEL_LINE
        , FK_SYSTEM_LEVEL_TRADE
        , FK_SYSTEM_LEVEL_AGENT
        , SUBMIT_TS
        , START_TS
        , END_TS
        , STATUS
        , PARAMETER
        , DAEMON_FLG
        , PRIORITY
        , MAIL_SUBJECT
        , MAIL_BODY_HEADER
        , MAIL_BODY_DETAIL
        , MAIL_BODY_FOOTER
        , ATTACHMENT_FLG
        , RECORD_STATUS
        , RECORD_ADD_USER
        , RECORD_ADD_DATE
        , RECORD_CHANGE_USER
        , RECORD_CHANGE_DATE
    ) VALUES (
          l_v_enotice_id
        , p_i_v_enotice_request_id
        , p_i_v_org_type
        , p_i_v_fsc_id
        , p_i_v_customer_id
        , p_i_v_vendor_id
        , p_i_v_system_level_line
        , p_i_v_system_level_trade
        , p_i_v_system_level_agent
        , SYSDATE
        , NULL
        , NULL
        , '2'
        , NULL
        , 'N'
        , NULL
        , NULL
        , NULL
        , NULL
        , NULL
        , p_i_v_attachment_flag
        , 'A'
        , p_i_v_add_user
        , TO_DATE(p_i_v_add_date, 'YYYYMMDDHH24MISS')
        , p_i_v_add_user
        , TO_DATE(p_i_v_add_date, 'YYYYMMDDHH24MISS')
    );

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GEN_ENOTICE_ATTACHMENT (
      p_i_v_enotice_request_id              VARCHAR2
    , p_i_v_file_name                       VARCHAR2
    , p_i_v_add_user                        VARCHAR2
    , p_i_v_add_date                        VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS

    l_v_enotice_attachment_id   ZND_E_NOTICE_ATTACHMENT.PK_MAIL_ATTACHMENT_ID%TYPE;

BEGIN

    p_o_v_error := g_v_success;

    /* *4 start */
    /* SELECT  NVL(MAX(PK_MAIL_ATTACHMENT_ID),0) + 1
    INTO    l_v_enotice_attachment_id
    FROM    ZND_E_NOTICE_ATTACHMENT; */

    SELECT
        SEQ_MAIL_ATTACHMENT.NEXTVAL
    INTO
        l_v_enotice_attachment_id
    FROM
        DUAL;
    /* *4 end */

    INSERT INTO ZND_E_NOTICE_ATTACHMENT (
          PK_MAIL_ATTACHMENT_ID
        , FK_E_NOTICE_REQUEST_ID
        , FILE_NAME
        , RECORD_STATUS
        , RECORD_ADD_USER
        , RECORD_ADD_DATE
        , RECORD_CHANGE_USER
        , RECORD_CHANGE_DATE
    ) VALUES (
          l_v_enotice_attachment_id
        , p_i_v_enotice_request_id
        , p_i_v_file_name
        , 'A'
        , p_i_v_add_user
        , TO_DATE(p_i_v_add_date, 'YYYYMMDDHH24MISS')
        , p_i_v_add_user
        , TO_DATE(p_i_v_add_date, 'YYYYMMDDHH24MISS')
    );

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_DAEMON_FREQUENCY (
      p_o_v_daemon_frequency    OUT NOCOPY  VARCHAR2
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN
    p_o_v_error := g_v_success;

    SELECT CONFIG_VALUE
    INTO   p_o_v_daemon_frequency
    FROM   VCM_CONFIG_MST
    WHERE CONFIG_CD  = 'MAIL_DAEMON_FREQUENCY'
    AND   CONFIG_TYP = 'ENOTICE';

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_SERVER_DETAILS (
      p_o_v_server_ip            OUT NOCOPY  VARCHAR2
    , p_o_v_server_user          OUT NOCOPY  VARCHAR2
    , p_o_v_server_user_password OUT NOCOPY  VARCHAR2
    , p_o_v_sender_name          OUT NOCOPY  VARCHAR2
    , p_o_v_sender_email         OUT NOCOPY  VARCHAR2
    , p_o_v_purge_days           OUT NOCOPY  VARCHAR2
    , p_o_v_error                OUT NOCOPY  VARCHAR2
)
IS
l_v_err_msg                      ZND_DISPATCH_ERROR.USER_ERR_MSG%TYPE;
BEGIN
    p_o_v_error := g_v_success;

    l_v_err_msg := 'Error while getting Mail Server IP Details';
    SELECT CONFIG_VALUE
    INTO   p_o_v_server_ip
    FROM   VCM_CONFIG_MST
    WHERE CONFIG_CD  = 'MAIL_SERVER_IP'
    AND   CONFIG_TYP = 'MAIL_SERVER';

    l_v_err_msg := 'Error while getting Mail Server User ID';
    SELECT CONFIG_VALUE
    INTO   p_o_v_server_user
    FROM   VCM_CONFIG_MST
    WHERE CONFIG_CD  = 'MAIL_SERVER_USER_ID'
    AND   CONFIG_TYP = 'MAIL_SERVER';

    l_v_err_msg := 'Error while getting Mail Server Password';
    SELECT CONFIG_VALUE
    INTO   p_o_v_server_user_password
    FROM   VCM_CONFIG_MST
    WHERE CONFIG_CD  = 'MAIL_SERVER_PASSWORD'
    AND   CONFIG_TYP = 'MAIL_SERVER';

    l_v_err_msg := 'Error while getting Sender Name';
    SELECT CONFIG_VALUE
    INTO   p_o_v_sender_name
    FROM   VCM_CONFIG_MST
    WHERE CONFIG_CD = 'MAIL_SENDER_NAME'
    AND   CONFIG_TYP = 'ENOTICE';

    l_v_err_msg := 'Error while getting Mail Sender Email ID';
    SELECT CONFIG_VALUE
    INTO   p_o_v_sender_email
    FROM   VCM_CONFIG_MST
    WHERE CONFIG_CD = 'MAIL_SENDER_EMAIL'
    AND   CONFIG_TYP = 'ENOTICE';

/*
    SELECT CONFIG_VALUE
    INTO   p_o_v_purge_days
    FROM   VCM_CONFIG_MST
    WHERE CONFIG_CD  = 'PURGE_MAIL_DATA_AFTER_DAYS'
    AND   CONFIG_TYP = 'ENOTICE';
*/

EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_o_v_error := SQLCODE || '~' || SQLERRM;
        PRE_INS_ERR_LOG('', SQLCODE , l_v_err_msg , p_o_v_error);

    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        PRE_INS_ERR_LOG('', SQLCODE , SQLERRM , p_o_v_error);
END;

PROCEDURE PRE_GET_PENDING_MAILS (
      p_o_ref_pending_mails     OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
    /* *6 start * */
    UPLOAD_DIR CONSTANT VARCHAR2(15) DEFAULT 'UPLOAD_DIR';
    ATTACHMENT_DIR CONSTANT VARCHAR2(15) DEFAULT 'ATTACHMENT_DIR';
    BLANK CONSTANT VARCHAR2(1) DEFAULT '';
    L_V_ATTACHMENT_DIR_PATH VCM_CONFIG_MST.CONFIG_VALUE%TYPE;
    /* *6 END * */
BEGIN

    /* *6 start * */
    BEGIN
        SELECT
            CONFIG_VALUE
        INTO
            L_V_ATTACHMENT_DIR_PATH
        FROM
            VCM_CONFIG_MST
        WHERE
            CONFIG_TYP = UPLOAD_DIR
            AND CONFIG_CD = ATTACHMENT_DIR
            AND STATUS = 'A';
    EXCEPTION
    WHEN OTHERS THEN
        L_V_ATTACHMENT_DIR_PATH := BLANK;
    END;

    /* *6 end  * */
    p_o_v_error := g_v_success;

    OPEN p_o_ref_pending_mails FOR
        SELECT
              PK_E_NOTICE_ID
            , FK_E_NOTICE_REQUEST_ID
            , PRIORITY
            , MAIL_SUBJECT
            , MAIL_BODY_HEADER
            , MAIL_BODY_DETAIL
            , MAIL_BODY_FOOTER
            , ATTACHMENT_FLG
            , L_V_ATTACHMENT_DIR_PATH AS "ATTACHMENT_DIR" -- *6
        FROM ZND_E_NOTICE
        WHERE  DAEMON_FLG = 'Y'
        AND    STATUS     = 2  ; -- Waiting to Start

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_UPD_PROCESS_STATUS (
      p_i_v_enotice_id                      VARCHAR
    , p_i_v_process_status                  VARCHAR
    , p_o_v_error              OUT NOCOPY  VARCHAR2
)
IS
BEGIN
    p_o_v_error := g_v_success;

    UPDATE ZND_E_NOTICE
    SET   START_TS   = DECODE(p_i_v_process_status,'3', SYSDATE, START_TS)
        , END_TS     = DECODE(p_i_v_process_status,'3', END_TS , SYSDATE )
        , STATUS     = p_i_v_process_status
        , DAEMON_FLG = 'N'
    WHERE PK_E_NOTICE_ID = p_i_v_enotice_id;

    COMMIT; /* *3 */
EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_MAIL_RECIPIENTS (
      p_o_ref_mail_recipients    OUT PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_enotice_id                      VARCHAR
    , p_i_v_mail_recipient_type             VARCHAR
    , p_o_v_error                OUT NOCOPY VARCHAR2
)
IS
BEGIN
    p_o_v_error := g_v_success;

    OPEN p_o_ref_mail_recipients FOR
        SELECT RECIPIENT_EMAIL
        FROM   ZND_E_NOTICE_RECIPIENT
        WHERE  RECIPIENT_TYPE     = p_i_v_mail_recipient_type
        AND    FK_E_NOTICE_ID     = p_i_v_enotice_id;
EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_ORIGIN_FSC_RECIPIENTS (
      p_o_ref_mail_recipients    OUT PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_enotice_request_id              VARCHAR
    , p_i_v_mail_recipient_type             VARCHAR
    , p_i_v_enotice_id                     VARCHAR
    , p_o_v_error                OUT NOCOPY VARCHAR2
)
IS

    l_v_originating_fsc      ZND_E_NOTICE_REQUEST.FK_ORIGINATING_FSC%TYPE;
    l_v_enotice_type_id      ZND_E_NOTICE_REQUEST.FK_E_NOTICE_TYPE_ID%TYPE;
    l_v_pk_receiver_org_id   ZND_RECEIVER_ORG.PK_RECEIVER_ORG_ID%TYPE;
BEGIN
    p_o_v_error := g_v_success;

    SELECT   FK_ORIGINATING_FSC
           , FK_E_NOTICE_TYPE_ID
    INTO     l_v_originating_fsc
           , l_v_enotice_type_id
    FROM   ZND_E_NOTICE_REQUEST
    WHERE  PK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

    BEGIN
        SELECT    RO.PK_RECEIVER_ORG_ID
        INTO      l_v_pk_receiver_org_id
        FROM      ZND_MAIL_TEMPLATE        MT
              , ZND_RECEIVER_ORG         RO
        WHERE MT. PK_MAIL_TEMPLATE_ID  = RO. FK_MAIL_TEMPLATE_ID
        AND   MT.FK_E_NOTICE_TYPE_ID   = l_v_enotice_type_id
        AND   RO.ORG_TYPE              = 'F'
        AND   RO.FK_FSC_ID             = l_v_originating_fsc
        AND   MT.RECORD_STATUS = 'A' -- *5
        AND   RO.RECORD_STATUS = 'A'; -- *5
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        PRE_INS_ERR_LOG(p_i_v_enotice_id,SQLCODE,'Record Not maintained for Notice Type Id :' || l_v_enotice_type_id || ' and Origin FSC :' ||l_v_originating_fsc,p_o_v_error);
    END;

    OPEN p_o_ref_mail_recipients FOR
    SELECT RECIPIENT_EMAIL
    FROM   ZND_ORG_RECIPIENT
    WHERE  FK_RECEIVER_ORG_ID = l_v_pk_receiver_org_id
    AND    RECIPIENT_TYPE     = p_i_v_mail_recipient_type
    AND    RECORD_STATUS = 'A'; -- *5

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLERRM;

        -- PRE_INS_ERR_LOG('',SQLCODE,SQLERRM,p_o_v_error);
        PRE_INS_ERR_LOG(
            p_i_v_enotice_id,
            SQLCODE,
            'PRE_GET_ORIGIN_FSC_RECIPIENTS:' || p_o_v_error,
            p_o_v_error); --*5
        --RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_GET_MAIL_ATTACHMENTS (
      p_o_ref_mail_attachments  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
    , p_i_v_enotice_request_id              VARCHAR
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
BEGIN
    p_o_v_error := g_v_success;

    OPEN p_o_ref_mail_attachments FOR
        SELECT FILE_NAME
        FROM   ZND_E_NOTICE_ATTACHMENT
        WHERE  FK_E_NOTICE_REQUEST_ID = p_i_v_enotice_request_id;

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SQLCODE || '~' || SQLERRM;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
END;

PROCEDURE PRE_INS_ERR_LOG (
      p_i_v_enotice_id                      VARCHAR
    , p_i_v_err_cd                          VARCHAR
    , p_i_v_err_msg                         VARCHAR
    , p_o_v_error               OUT NOCOPY  VARCHAR2
)
IS
    l_v_next_err_id ZND_DISPATCH_ERROR.PK_DISPATCH_ERROR_ID%TYPE;

BEGIN
    p_o_v_error := '000000';

    /* *4 start */
    /* SELECT NVL(MAX(PK_DISPATCH_ERROR_ID),0)+1
    INTO   l_v_next_err_id
    FROM ZND_DISPATCH_ERROR; */

    SELECT
        SEQ_DISPATCH_ERROR.NEXTVAL
    INTO
        l_v_next_err_id
    FROM
        DUAL;
    /* *4 end */

    INSERT INTO ZND_DISPATCH_ERROR (
          PK_DISPATCH_ERROR_ID
        , FK_DISPATCH_ID
        , USER_ERR_CD
        , USER_ERR_MSG
        , ORA_ERR_CD
        , ORA_ERR_MSG
        , RECORD_STATUS
        , RECORD_ADD_USER
        , RECORD_ADD_DATE
        , RECORD_CHANGE_USER
        , RECORD_CHANGE_DATE
    ) VALUES(
          l_v_next_err_id
        , p_i_v_enotice_id
        , NULL
        , NULL
        , SUBSTR(p_i_v_err_cd,1,20 )
        , SUBSTR(p_i_v_err_msg,1,100)
        ,  'A'
        , 'SYSTEM'
        , SYSDATE
        , 'SYSTEM'
        , SYSDATE
    ) ;


EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
END;

--#07 BEGIN
PROCEDURE PRE_IS_DEFINED_APP_SERVER (
      p_i_app_server_id             IN VARCHAR2
    , p_o_is_defined_app_server     OUT NOCOPY  VARCHAR2
    , p_o_v_error                   OUT NOCOPY  VARCHAR2
)
IS
BEGIN

    p_o_v_error := '000000';
    
    P_O_IS_DEFINED_APP_SERVER := '0';

    /* Formatted on 2013/09/25 11:45 (Formatter Plus v4.8.8) */
    SELECT COUNT (CONFIG_VALUE)
    INTO   P_O_IS_DEFINED_APP_SERVER
    FROM   VASAPPS.VCM_CONFIG_MST
    WHERE  CONFIG_TYP = 'DEFINED_APP_SERVER'
    AND    UPPER (TRIM (CONFIG_VALUE)) = UPPER (TRIM (P_I_APP_SERVER_ID));
    
EXCEPTION
    WHEN OTHERS THEN
        VASAPPS.PCR_RCM_RECORD_LOG.PRR_RECORD_LOG ('EZLL'
                                                   ,'-'
                                                   ,'PRE_IS_DEFINED_APP_SERVER'
                                                   ,SQLERRM);        
        p_o_is_defined_app_server := 0;
        p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);

END;
--#07 END


END PCE_ECM_ENOTICE;
/
