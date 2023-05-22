--------------------------------------------------------
--  File created - Friday-September-23-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body PCE_EUT_COMMON
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "VASAPPS"."PCE_EUT_COMMON" AS

/*
    *1 Modified by vikas, Crane type data is not comming for the specific port and termianl, 24.05.2012
    *2 Issue fix by vikas, Oracle error fix, exact fetch return more then number of record,
        as k'chatgamol, 05.06.2013
*/
FUNCTION FN_EUT_GEN_VAS_ERROR (p_i_v_error VARCHAR2)
RETURN VARCHAR2 AS
BEGIN
    IF SUBSTR(p_i_v_error,LENGTH(p_i_v_error)) = PCE_EUT_COMMON.G_V_ERR_CD_SEP THEN
      RETURN G_V_SQL_ERR_PREFIX || SUBSTR(p_i_v_error,1,LENGTH(p_i_v_error)-1) || G_V_SQL_ERR_POSTFIX;
    ELSE
      RETURN G_V_SQL_ERR_PREFIX || p_i_v_error || G_V_SQL_ERR_POSTFIX;
    END IF;
END FN_EUT_GEN_VAS_ERROR;


FUNCTION FN_EUT_GET_FSC_ADDRESS(
                   p_i_business_object_cd   VARCHAR2
                  ,p_i_refeence_no          VARCHAR2
                )
RETURN PCE_ECM_REF_CUR.FSC_REF_CUR AS
p_o_refFsc PCE_ECM_REF_CUR.FSC_REF_CUR;
v_fsc_cd VARCHAR2(3);
BEGIN
  IF p_i_business_object_cd = G_V_BUS_OBJ_CD_FSC THEN
    v_fsc_cd := p_i_refeence_no;
  END IF;

  OPEN p_o_refFsc FOR
       SELECT  CRCONM FSC_NAME, CRADD1 FSC_ADD1, CRADD2 FSC_ADD2, CRADD3 FSC_ADD3, CRADD4 FSC_ADD4,
               CRCITY FSC_CITY, CRZIP FSC_ZIP, CRPHON FSC_TEL, CRFAXN FSC_FAX,
               CREMAL FSC_EMAIL
       FROM    ITP188
       WHERE   CRCNTR = v_fsc_cd;

  RETURN p_o_refFsc;

END;



FUNCTION FN_STR_2_TBL (
                         p_i_v_str VARCHAR2
                        ,p_i_v_separator VARCHAR2
                      )
RETURN PCE_ECM_REF_CUR.TAB_STR_2_ARR AS
l_v_str   VARCHAR2(2000);
l_v_col   VARCHAR2(20);
l_n_col   NUMBER(2) := 0;
l_data    PCE_ECM_REF_CUR.TAB_STR_2_ARR := PCE_ECM_REF_CUR.TAB_STR_2_ARR();
BEGIN
l_v_str  := p_i_v_str;
IF p_i_v_str IS NOT NULL THEN
  LOOP
     l_n_col := INSTR( l_v_str, p_i_v_separator );
     EXIT WHEN (l_n_col = 0);
     l_v_col := SUBSTR(l_v_str,1,l_n_col-1);
     l_data.EXTEND;
     l_data( l_data.COUNT ) := l_v_col;
     l_v_str := SUBSTR( l_v_str, l_n_col+1 );
  END LOOP;
  /* Add Last Element */
  l_data.EXTEND;
  l_data( l_data.COUNT ) := LTRIM(RTRIM(l_v_str));
END IF;
RETURN l_data;
END;

FUNCTION FN_STR_2_TBL(
                         p_i_v_str VARCHAR2
                        ,p_i_v_separator VARCHAR2
                        ,p_i_v_type VARCHAR2
                      )
RETURN GEN_STR_TBL_TAB AS
l_v_str   VARCHAR2(2000);
l_v_col   VARCHAR2(20);
l_n_col   NUMBER(2) := 0;
l_data    GEN_STR_TBL_TAB := GEN_STR_TBL_TAB();
BEGIN
  l_v_str  := p_i_v_str;
IF p_i_v_str IS NOT NULL THEN
  LOOP
    l_n_col := INSTR( l_v_str, p_i_v_separator );
    EXIT WHEN (l_n_col = 0);
    l_v_col := SUBSTR(l_v_str,1,l_n_col-1);
    l_data.EXTEND;
    l_data( l_data.LAST ) := GEN_STR_TBL_TYPE(l_v_col);
    l_v_str := SUBSTR( l_v_str, l_n_col+1 );
  END LOOP;
  /* Add Last Element */
  l_data.EXTEND;
  l_data( l_data.LAST ) := GEN_STR_TBL_TYPE(LTRIM(RTRIM(l_v_str)));
END IF;
  RETURN l_data;
END ;

FUNCTION FN_EUT_GET_USER_FSC (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2 AS
l_v_user_fsc VARCHAR2(20) := NULL;
BEGIN
  SELECT FSC_CODE INTO l_v_user_fsc
  FROM   SC_PRSN_LOG_INFO
  WHERE  PRSN_LOG_ID = p_i_v_user_id;

  RETURN l_v_user_fsc;

EXCEPTION
  WHEN OTHERS THEN
    RETURN l_v_user_fsc;
END;

FUNCTION FN_EUT_GET_USER_NM (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2 AS
l_v_user_nm VARCHAR2(100) := NULL;
BEGIN
  SELECT DESCR INTO l_v_user_nm
  FROM   SC_PRSN_LOG_INFO
  WHERE  PRSN_LOG_ID = p_i_v_user_id;

  RETURN l_v_user_nm;

EXCEPTION
  WHEN OTHERS THEN
    RETURN l_v_user_nm;
END;

FUNCTION FN_EUT_GET_FSC_LEVEL_ACCESS (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2 AS
l_v_user_fsc VARCHAR2(20)         := NULL;
l_v_fsc_level_access VARCHAR2(20) := NULL;
BEGIN
  l_v_user_fsc := FN_EUT_GET_USER_FSC(p_i_v_user_id);
  SELECT CRFLV1 || '/' || CRFLV2 || '/' || CRFLV3
  INTO   l_v_fsc_level_access
  FROM   ITP188
  WHERE  CRCNTR = l_v_user_fsc;

  RETURN l_v_fsc_level_access;

EXCEPTION
  WHEN OTHERS THEN
    RETURN l_v_fsc_level_access;
END;

FUNCTION FN_EUT_GET_ACCESS_LEVEL_LINE (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2 AS
l_v_user_fsc VARCHAR2(20)          := NULL;
l_v_access_level_line VARCHAR2(20) := NULL;
BEGIN
  l_v_user_fsc := FN_EUT_GET_USER_FSC(p_i_v_user_id);
  SELECT CRFLV1
  INTO   l_v_access_level_line
  FROM   ITP188
  WHERE  CRCNTR = l_v_user_fsc;

  RETURN l_v_access_level_line;

EXCEPTION
  WHEN OTHERS THEN
    RETURN l_v_access_level_line;
END;

FUNCTION FN_EUT_GET_ACCESS_LEVEL_TRADE (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2 AS
l_v_user_fsc VARCHAR2(20)           := NULL;
l_v_access_level_trade VARCHAR2(20) := NULL;
BEGIN
  l_v_user_fsc := FN_EUT_GET_USER_FSC(p_i_v_user_id);
  SELECT CRFLV2
  INTO   l_v_access_level_trade
  FROM   ITP188
  WHERE  CRCNTR = l_v_user_fsc;

  RETURN l_v_access_level_trade;

EXCEPTION
  WHEN OTHERS THEN
    RETURN l_v_access_level_trade;
END;

FUNCTION FN_EUT_GET_ACCESS_LEVEL_AGENT (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2 AS
l_v_user_fsc VARCHAR2(20)           := NULL;
l_v_access_level_agent VARCHAR2(20) := NULL;
BEGIN
  l_v_user_fsc := FN_EUT_GET_USER_FSC(p_i_v_user_id);
  SELECT CRFLV3
  INTO   l_v_access_level_agent
  FROM   ITP188
  WHERE  CRCNTR = l_v_user_fsc;

  RETURN l_v_access_level_agent;

EXCEPTION
  WHEN OTHERS THEN
    RETURN l_v_access_level_agent;
END;

FUNCTION FN_EUT_GET_USER_ORG_CODE (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2 AS
l_v_user_org_code      VARCHAR2(10) := NULL ;
BEGIN
  SELECT ORG_CODE
  INTO   l_v_user_org_code
  FROM   SC_PRSN_LOG_INFO
  WHERE  PRSN_LOG_ID = p_i_v_user_id ;

  RETURN l_v_user_org_code ;

EXCEPTION
  WHEN OTHERS THEN
    RETURN l_v_user_org_code ;
END;

FUNCTION FN_EUT_GET_USER_ORG_TYPE (p_i_v_user_id VARCHAR2)
RETURN VARCHAR2 AS
l_v_user_org_type      VARCHAR2(2) := NULL ;
BEGIN
  SELECT ORG_TYPE
  INTO   l_v_user_org_type
  FROM   SC_PRSN_LOG_INFO
  WHERE  PRSN_LOG_ID = p_i_v_user_id ;

  RETURN l_v_user_org_type ;

EXCEPTION
  WHEN OTHERS THEN
    RETURN l_v_user_org_type ;
END;
PROCEDURE PRE_EUT_GET_UAB(
                          p_o_refUAB      OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                          ,p_i_v_user_id  IN  VARCHAR2
                          ,p_o_v_error    OUT VARCHAR2
                         ) AS
l_v_user_fsc SC_PRSN_LOG_INFO.FSC_CODE%TYPE;
BEGIN
  p_o_v_error := G_V_SUCCESS_CD;

  l_v_user_fsc := FN_EUT_GET_USER_FSC(p_i_v_user_id);

  IF l_v_user_fsc = G_V_REGIONAL_FSC THEN

    OPEN p_o_refUAB FOR
      SELECT   UAB.PRSN_LOG_ID AS USER_ID
              ,UAB.DESCR AS USER_NM
              ,UAB.PERSON_CD AS EMP_ID
              ,UAB.FSC_CODE AS USER_FSC
              ,UAB.SHARE_FSC AS SHARE_FSC_FLAG
              ,FSC.CRFLV1 || '/' || FSC.CRFLV2 || '/' || FSC.CRFLV3 AS FSC_ACCESS_LEVELS
              ,UAB.ORG_CODE AS ORG_CD
              ,UAB.ORG_TYPE AS ORG_TYPE
              ,FSC.COMPANY_CODE AS COMP_CD
              ,FSC.CRCNCD AS CONTRY_CD
              ,NVL(UAB.EMAIL_ID1,UAB.EMAIL_ID2) AS EMAIL_ID
              ,GEN.SMCURR AS MAIN_CURR
              ,GEN.SSCURR AS SEC_CURR
              ,FSC.CRCURR AS INV_CURR
              ,NVL(UAB.LANG_CD,'EN') AS LANG_CD
              ,DECODE(FSC.SYS_DATE_FORMAT, 1,'DD/MM/YYYY','MM/DD/YYYY') AS DATE_FORMAT
      FROM    SC_PRSN_LOG_INFO UAB, ITP188 FSC, ITP001 GEN
      WHERE   GEN.SGLINE      = FSC.CRFLV1
      AND     GEN.SGTRAD      = FSC.CRFLV2
      AND     UAB.FSC_CODE    = FSC.CRCNTR
      AND     UAB.PRSN_LOG_ID = p_i_v_user_id
      AND     (UAB.RCST IS NULL OR UAB.RCST = G_V_STATUS_ACTIVE)
      AND     UAB.IS_LOCKED   = 'N'
      AND     FSC.CRCNTR      = 'R'
      AND     ROWNUM < 2;

  ELSE --NORMAL FSC

    OPEN p_o_refUAB FOR
      SELECT   UAB.PRSN_LOG_ID AS USER_ID
              ,UAB.DESCR AS USER_NM
              ,UAB.PERSON_CD AS EMP_ID
              ,UAB.FSC_CODE AS USER_FSC
              ,UAB.SHARE_FSC AS SHARE_FSC_FLAG
              ,FSC.CRFLV1 || '/' || FSC.CRFLV2 || '/' || FSC.CRFLV3 AS FSC_ACCESS_LEVELS
              ,UAB.ORG_CODE AS ORG_CD
              ,UAB.ORG_TYPE AS ORG_TYPE
              ,FSC.COMPANY_CODE AS COMP_CD
              ,FSC.CRCNCD AS CONTRY_CD
              ,NVL(UAB.EMAIL_ID1,UAB.EMAIL_ID2) AS EMAIL_ID
              ,AGNT.MAIN_CURRENCY AS MAIN_CURR
              ,GEN.SMCURR AS SEC_CURR
              ,FSC.CRCURR AS INV_CURR
              ,NVL(UAB.LANG_CD,'EN') AS LANG_CD
              ,DECODE(FSC.SYS_DATE_FORMAT, 1,'DD/MM/YYYY','MM/DD/YYYY') AS DATE_FORMAT
      FROM    SC_PRSN_LOG_INFO UAB, ITP188 FSC, ITP001 GEN, ITPLVL AGNT
      WHERE   GEN.SGLINE      = FSC.CRFLV1
      AND     GEN.SGTRAD      = FSC.CRFLV2
      AND     UAB.FSC_CODE    = FSC.CRCNTR
      AND     FSC.CRFLV1      = AGNT.LVLINE
      AND     FSC.CRFLV2      = AGNT.LVTRAD
      AND     FSC.CRFLV3      = AGNT.LVAGNT
      AND     UAB.PRSN_LOG_ID = p_i_v_user_id
      AND     (UAB.RCST IS NULL OR UAB.RCST = G_V_STATUS_ACTIVE)
      AND     UAB.IS_LOCKED   = 'N'
      AND     FSC.CRCNTR      <> 'R'
      AND     ROWNUM < 2;

  END IF;

EXCEPTION
    WHEN OTHERS THEN
      p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
END PRE_EUT_GET_UAB;


PROCEDURE PRE_EUT_GET_AUTH_LIST(
                                p_o_refAuthList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_i_v_user_id  IN  VARCHAR2
                                ,p_o_v_error    OUT VARCHAR2
                               ) AS
BEGIN
  p_o_v_error := G_V_SUCCESS_CD;

  OPEN p_o_refAuthList FOR
  SELECT   PROG_GROUP_ID
          ,MAX(READ_FLAG) AS READ_FLAG
          ,MAX(EDIT_FLAG) AS EDIT_FLAG
          ,MAX(DEL_FLAG)  AS DEL_FLAG
          ,MAX(NEW_FLAG)  AS NEW_FLAG
  FROM    (
          SELECT   MENU_ID AS PROG_GROUP_ID
                  ,NVL(MENU_ITEM_VISIBLE,'N') AS READ_FLAG
                  ,NVL(SC_UPDATE,'N') AS EDIT_FLAG
                  ,NVL(SC_DELETE,'N') AS DEL_FLAG
                  ,NVL(SC_CREATE,'N') AS NEW_FLAG
          FROM    PR_PRSN_ROLE USER_ROLE, SC_ROLE_PRIV_TEMPL ROLE_PROG
          WHERE   USER_ROLE.ROLE_CD     = ROLE_PROG.ROLE_CD
          AND     USER_ROLE.PRSN_LOG_ID = p_i_v_user_id
          AND     MENU_ITEM_VISIBLE     = 'Y'
          AND     (USER_ROLE.RCST IS NULL OR USER_ROLE.RCST = G_V_STATUS_ACTIVE)
  )
  GROUP BY PROG_GROUP_ID
  ORDER BY PROG_GROUP_ID;

EXCEPTION
    WHEN OTHERS THEN
      p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
END PRE_EUT_GET_AUTH_LIST;

PROCEDURE PRE_EUT_IS_CONTROL_FSC(
                                p_o_v_is_control_fsc OUT VARCHAR2
                                ,p_i_v_user_fsc      IN  VARCHAR2
                                ,p_o_v_error         OUT VARCHAR2
                               ) AS
BEGIN
  p_o_v_error := G_V_SUCCESS_CD;

  SELECT CONTROL_FSC
  INTO   p_o_v_is_control_fsc
  FROM   ITP188
  WHERE  CRCNTR = p_i_v_user_fsc
    AND  SHARE_FSC = 'N';

EXCEPTION
    WHEN OTHERS THEN
      p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
END PRE_EUT_IS_CONTROL_FSC;

PROCEDURE PRE_EUT_GET_SHARE_FSC_LIST(
                                p_o_refFSCList  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_i_v_user_id  IN  VARCHAR2
                                ,p_i_v_is_control_fsc IN VARCHAR2
                                ,p_o_v_error    OUT VARCHAR2
                               ) AS
l_v_fsc_access_levels VARCHAR2(20);
l_v_level1            VARCHAR2(3);
l_v_level2            VARCHAR2(3);
l_v_level3            VARCHAR2(3);
l_v_user_fsc           VARCHAR2(3);
p_o_refFSCList1  PCE_ECM_REF_CUR.ECM_REF_CUR;
BEGIN
  p_o_v_error := G_V_SUCCESS_CD;

  l_v_fsc_access_levels := FN_EUT_GET_FSC_LEVEL_ACCESS(p_i_v_user_id);
  l_v_user_fsc := FN_EUT_GET_USER_FSC(p_i_v_user_id);

  l_v_level1 := SUBSTR(l_v_fsc_access_levels,0,INSTR(l_v_fsc_access_levels,'/')-1);
  l_v_level2 := SUBSTR(SUBSTR(l_v_fsc_access_levels,INSTR(l_v_fsc_access_levels,'/')+1),0,INSTR(l_v_fsc_access_levels,'/')-1);
  l_v_level3 := SUBSTR(l_v_fsc_access_levels,INSTR(l_v_fsc_access_levels,'/',-1)+1,LENGTH(l_v_fsc_access_levels));
/*
  OPEN p_o_refFSCList FOR
  SELECT CRCNTR
  FROM ITP188
  WHERE CRFLV1    = l_v_level1
    AND CRFLV2      = l_v_level2
    AND CRFLV3      = l_v_level3
    AND SHARE_FSC   = 'Y'
    AND CONTROL_FSC = 'N';

  for l_rec_ref_fsc_list in p_o_refFSCList
  Loop
    SELECT
  End Loop;



  if p_i_v_is_control_fsc = 'true' then

      SELECT CRCNTR FSC,ITP040.PICODE PORT,'V' DISPLAY
      FROM ITP188,ITP040
      WHERE ITP188.CRCNTR = ITP040.PIOFFC
      AND CRFLV1    = l_v_level1
        AND CRFLV2      = l_v_level2
        AND CRFLV3      = l_v_level3
        AND SHARE_FSC   = 'Y'
        AND CONTROL_FSC = 'N'
        UNION ALL
        SELECT CRCNTR,ITP040.PICODE,'E' DISPLAY
        FROM ITP188,ITP040
        WHERE  ITP188.CRCNTR = ITP040.PIOFFC
        AND ITP040.PIOFFC = l_v_user_fsc;

  end if;
  if p_i_v_is_control_fsc = 'false' then

      SELECT CRCNTR,ITP040.PICODE PORT,'E' DISPLAY
        FROM ITP188,ITP040
        WHERE  ITP188.CRCNTR = ITP040.PIOFFC
        AND ITP040.PIOFFC = l_v_user_fsc;
  end if;

*/

EXCEPTION
    WHEN OTHERS THEN
      p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
END PRE_EUT_GET_SHARE_FSC_LIST;

FUNCTION  FN_GET_PORT_LIST (p_i_v_user_id  VARCHAR2,p_i_v_is_control_fsc VARCHAR2,p_i_port_id VARCHAR2)
    RETURN VARCHAR2
    IS
   l_v_fsc_access_levels  VARCHAR2(20);
    l_v_level1              VARCHAR2(3);
    l_v_level2              VARCHAR2(3);
    l_v_level3              VARCHAR2(3);
    l_v_user_fsc            VARCHAR2(3);
    l_v_fsc                            VARCHAR2(3);
    l_v_port                        VARCHAR2(10);
    l_v_display                      VARCHAr2(1);
  l_v_user_port           VARCHAR2(5);
  l_v_final               VARCHAR2(100);
    BEGIN


  l_v_fsc_access_levels := FN_EUT_GET_FSC_LEVEL_ACCESS(p_i_v_user_id);
  l_v_user_fsc := FN_EUT_GET_USER_FSC(p_i_v_user_id);

  l_v_level1 := SUBSTR(l_v_fsc_access_levels,0,INSTR(l_v_fsc_access_levels,'/')-1);
  l_v_level2 := SUBSTR(SUBSTR(l_v_fsc_access_levels,INSTR(l_v_fsc_access_levels,'/')+1),0,INSTR(l_v_fsc_access_levels,'/')-1);
  l_v_level3 := SUBSTR(l_v_fsc_access_levels,INSTR(l_v_fsc_access_levels,'/',-1)+1,LENGTH(l_v_fsc_access_levels));


  if p_i_v_is_control_fsc = 'true' then
       SELECT FSC,PORT,DISPLAY
       INTO l_v_fsc,l_v_port,l_v_display
       FROM(
      SELECT  CRCNTR FSC,ITP040.PICODE PORT,'E' DISPLAY
      FROM    ITP188,ITP040
      WHERE   ITP188.CRCNTR = ITP040.PIOFFC
      AND     CRFLV1    = l_v_level1
      AND     CRFLV2      = DECODE(l_v_level2,'*',CRFLV2,l_v_level2)
      AND     CRFLV3      = DECODE(l_v_level3,'***',CRFLV3,l_v_level3)
      AND     SHARE_FSC   = 'Y'
      AND     CONTROL_FSC = 'N'

      -- UNION ALL -- *2
      UNION -- *2

      SELECT  CRCNTR,ITP040.PICODE,'E' DISPLAY
      FROM    ITP188,ITP040
      WHERE   ITP188.CRCNTR = ITP040.PIOFFC
      AND (ITP040.PIOFFC = l_v_user_fsc OR PCE_EUT_COMMON.FN_EUT_GET_ACCESS_LEVEL_AGENT(p_i_v_user_id)=PCE_EUT_COMMON.G_V_ALL_FSC ))
      where   port = p_i_port_id;


  end if;
  if p_i_v_is_control_fsc = 'false' then
      SELECT CRCNTR,ITP040.PICODE PORT,'E' DISPLAY
      INTO l_v_fsc,l_v_port,l_v_display
        FROM ITP188,ITP040
        WHERE  ITP188.CRCNTR = ITP040.PIOFFC
        AND (ITP040.PIOFFC = l_v_user_fsc OR PCE_EUT_COMMON.FN_EUT_GET_ACCESS_LEVEL_AGENT(p_i_v_user_id)=PCE_EUT_COMMON.G_V_ALL_FSC )
            AND ITP040.PICODE = p_i_port_id;
  end if;
  l_v_final :=l_v_fsc||','||l_v_port||','||l_v_display;

  return l_v_final;

    END FN_GET_PORT_LIST;

FUNCTION FN_EUT_GET_FSC_CURRENCY(
                   p_i_fsc_cd VARCHAR2
                )
RETURN VARCHAR2 IS
    l_v_curr_cd ITP188.CRCURR%TYPE;
BEGIN
    SELECT CRCURR
    INTO   l_v_curr_cd
    FROM   ITP188
    WHERE  CRCNTR = p_i_fsc_cd;

    RETURN l_v_curr_cd;

END FN_EUT_GET_FSC_CURRENCY;


FUNCTION FN_EUT_GET_WEEK_NO(
                            p_i_d_date DATE
                           )
RETURN NUMBER IS

l_d_next_sunday  DATE   ;
l_n_year_days    NUMBER ;
l_n_weeks        NUMBER ;

BEGIN

   -- Start Code commented NB 15-Apr-2010--
  /*
  l_n_year_days   := NULL ;
  l_d_next_sunday := NULL ;
  l_n_weeks       := NULL ;

  -- get the next sunday for passed date
  -- if the passed date itself is SUNDAY in that case we have minus 1
  l_d_next_sunday := NEXT_DAY(p_i_d_date - 1, 'SUN');

  -- if passed date year and next sunday date year is not same
  -- then add 2 weeks else add 1 week

  IF TO_CHAR(l_d_next_sunday, 'YYYY') <> TO_CHAR(p_i_d_date, 'YYYY') THEN
      l_n_year_days := TO_CHAR(l_d_next_sunday - 7 ,'DDD') ;
      l_n_weeks     := TRUNC((l_n_year_days ) / 7) + 2     ;
  ELSE
      l_n_year_days := TO_CHAR(l_d_next_sunday , 'DDD')  ;
      l_n_weeks     := TRUNC(l_n_year_days / 7) + 1      ;
  END IF;
  */
  -- End Code commented NB 15-Apr-2010--
  --user gave new calender which is same like oracle ISO standards
  -- so now we dont have to process any data, since oracle provide
  -- this week in build
  SELECT TO_CHAR(p_i_d_date,'IW')
  INTO l_n_weeks
  FROM DUAL ;

  RETURN TO_NUMBER(l_n_weeks,99);

END FN_EUT_GET_WEEK_NO;

FUNCTION FN_WEEK_START_DT (  p_i_n_week_no NUMBER
                            ,p_i_n_year    NUMBER
                           )
RETURN DATE IS
l_d_year_strat_dt   DATE   := NULL;
l_d_week_start_date DATE   := NULL;
l_n_days            NUMBER := NULL;
BEGIN
    -- convert passed year to first date of year
    l_d_year_strat_dt :='01-JAN-' || TO_CHAR(p_i_n_year,'9999');

    -- calculate the days as per passed week
    l_n_days := ((p_i_n_week_no - 1) * 7);

    IF TO_CHAR(l_d_year_strat_dt,'DY') = 'SUN' THEN
        l_n_days :=  l_n_days - 1 ;
    END IF;

    -- TRUNC with 'Day' format would always return the first day of week
    SELECT TRUNC(l_d_year_strat_dt + l_n_days, 'DAY')
    INTO   l_d_week_start_date
    FROM DUAL;

    -- the above date would always return first day of week (sun)
    -- add 1 to get the monday of this week
    l_d_week_start_date := l_d_week_start_date + 1;

    -- if the output day belong to first week of the year then
    -- oracle reutrn the last years week date but we have to show
    -- first day of the year
    IF p_i_n_year > TO_NUMBER(TO_CHAR(l_d_week_start_date,'YYYY'))  THEN
        l_d_week_start_date := l_d_year_strat_dt ;
    END IF;

    -- Return the first date of week
    RETURN l_d_week_start_date;
END FN_WEEK_START_DT;

FUNCTION FN_WEEK_END_DT (  p_i_n_week_no NUMBER
                          ,p_i_n_year    NUMBER
                         )
RETURN DATE IS
l_d_year_strat_dt   DATE   := NULL;
l_d_year_end_dt     DATE   := NULL;
l_d_week_end_date   DATE   := NULL;
l_n_days            NUMBER := NULL;
BEGIN
    -- convert passed year to first date of year
    l_d_year_strat_dt :='01-JAN-' || TO_CHAR(p_i_n_year,'9999');
    l_d_year_end_dt   :='31-DEC-' || TO_CHAR(p_i_n_year,'9999');

    -- calculate the days as per passed week
    l_n_days := ((p_i_n_week_no - 1) * 7);

    -- ROUND with 'Day' format would always return the first day of next week
    -- so to get the last date of the week we have to minus 1 day
    SELECT ROUND(l_d_year_strat_dt + l_n_days, 'DAY')
    INTO   l_d_week_end_date
    FROM DUAL;

    -- if the output day belong to last week of the year then
    -- oracle reutrn the first years week date but we have to show
    -- last day of the year
    IF p_i_n_year < TO_NUMBER(TO_CHAR(l_d_week_end_date,'YYYY'))  THEN
        l_d_week_end_date := l_d_year_end_dt ;
    END IF;

    -- Return the Last date of week
    RETURN l_d_week_end_date;
END FN_WEEK_END_DT;

FUNCTION FN_EUT_GET_TEU(
                        p_i_v_equipment_size VARCHAR2
                       )
RETURN NUMBER IS
BEGIN
  IF p_i_v_equipment_size = '20' THEN
    RETURN 1;
  ELSIF p_i_v_equipment_size = '40' THEN
    RETURN 2;
  ELSIF p_i_v_equipment_size = '45' THEN
    RETURN 2.25;
  ELSE
    RETURN NULL;
  END IF;
END;

FUNCTION FN_EUT_GET_ATTCHMENT_DIR
RETURN VARCHAR2 IS
l_v_dir_path VCM_CONFIG_MST.CONFIG_VALUE%TYPE;
BEGIN
  SELECT  CONFIG_VALUE
  INTO    l_v_dir_path
  FROM    VCM_CONFIG_MST
  WHERE   CONFIG_TYP ='UPLOAD_DIR'
  AND     CONFIG_CD  ='ATTACHMENT_DIR';

  RETURN l_v_dir_path;
END;

FUNCTION FN_EUT_GET_DOWNLOAD_DIR
RETURN VARCHAR2 IS
l_v_dir_path VCM_CONFIG_MST.CONFIG_VALUE%TYPE;
BEGIN
  SELECT  CONFIG_VALUE
  INTO    l_v_dir_path
  FROM    VCM_CONFIG_MST
  WHERE   CONFIG_TYP ='DOWNLOAD_DIR'
  AND     CONFIG_CD  ='TEMP_DOWNLOAD_DIR';

  RETURN l_v_dir_path;
END;

FUNCTION FN_EUT_GET_UPLOAD_DIR
RETURN VARCHAR2 IS
l_v_dir_path VCM_CONFIG_MST.CONFIG_VALUE%TYPE;
BEGIN
  SELECT  CONFIG_VALUE
  INTO    l_v_dir_path
  FROM    VCM_CONFIG_MST
  WHERE   CONFIG_TYP ='UPLOAD_DIR'
  AND     CONFIG_CD  ='TEMP_UPLOAD_DIR';

  RETURN l_v_dir_path;
END;


FUNCTION FN_EUT_IS_NUMBER (p_i_v_value VARCHAR2)
RETURN BOOLEAN IS
l_n_value NUMBER;
BEGIN
  l_n_value := p_i_v_value;
  RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;

FUNCTION FN_EUT_IS_VALID_DT_TM (p_i_v_value VARCHAR2, p_i_v_format VARCHAR2)
RETURN BOOLEAN IS
l_d_value DATE;
BEGIN
  l_d_value := TO_DATE(p_i_v_value,p_i_v_format);
  RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;


PROCEDURE PRE_EUT_NOTIFY_USER (
                                 p_i_v_prog_id VARCHAR2
                                ,p_i_v_user_id VARCHAR2
                                ,p_i_v_notify_cat VARCHAR2
                                ,p_i_business_object_cd VARCHAR2
                                ,p_i_refeence_no VARCHAR2
                                ,p_o_v_error OUT VARCHAR2
                              ) IS
BEGIN
    p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    /* Call RCL/Dolphin API */
    --To Do

    /* Insert an Entry into VAS Log Table for success*/
    PRE_EUT_INS_ERR_LOG (
                           p_i_v_prog_id
                          ,p_i_v_notify_cat
                          ,0
                          ,0
                          ,p_i_business_object_cd
                          ,p_i_refeence_no
                          ,PCE_EUT_COMMON.G_V_SUCCESS_CD
                          ,'Successfully Notified'
                          ,NULL
                          ,NULL
                          ,p_i_v_user_id
                          ,SYSDATE
                        );

EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
END PRE_EUT_NOTIFY_USER;

PROCEDURE PRE_EUT_GET_SHIPPING_TERM (
                                p_o_refShippingTermList OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_o_v_error        OUT VARCHAR2
                               ) AS
BEGIN
  p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;

  OPEN p_o_refShippingTermList FOR
    SELECT SHIP_TERM_CD
           ,SHIP_TERM_DESC
    FROM (
          SELECT DISTINCT CONFIG_VALUE AS SHIP_TERM_CD
                 ,CONFIG_DESC AS SHIP_TERM_DESC,
                 SORT_ORDER
          FROM   VCM_CONFIG_MST
          WHERE  CONFIG_TYP = G_V_SHIPPING_TERM
          ORDER  BY SORT_ORDER
         );

EXCEPTION
    WHEN OTHERS THEN
      NULL;
END PRE_EUT_GET_SHIPPING_TERM;

FUNCTION FN_COMMA_SPR (
                           p_i_v_tab_nm    IN VARCHAR2,
                           p_i_v_fld_nm    IN VARCHAR2,
                           p_i_v_whr       IN VARCHAR2,
                           p_i_v_separator IN VARCHAR2
                         )
   RETURN VARCHAR2
   IS

   l_v_rtn_txt  VARCHAR2(1000) := '';
   l_n_cur      INTEGER;
   l_v_sql      VARCHAR2(1000);
   l_v_clm_val  VARCHAR2(100);
   l_v_clm_typ  VARCHAR2(100);
   l_n_count    NUMBER;
   ignore       NUMBER;

   BEGIN

       -- create select statment for cursor--
       l_v_sql := 'SELECT '|| p_i_v_fld_nm ||
                  ' FROM ' || p_i_v_tab_nm ||
                  ' WHERE '|| p_i_v_whr;

       -- open cursor --
       l_n_cur  := DBMS_SQL.OPEN_CURSOR;
       -- parse sql --
       DBMS_SQL.PARSE(l_n_cur,l_v_sql,DBMS_SQL.v7);
       --set column defination --
       DBMS_SQL.DEFINE_COLUMN(l_n_cur, 1, l_v_clm_typ,100);
       -- execute package --
       ignore   := DBMS_SQL.EXECUTE(l_n_cur);

       -- loop thru all the record fetched by cursor --
       LOOP
         IF DBMS_SQL.FETCH_ROWS(l_n_cur) > 0 THEN
            --get column value from the cursor
            DBMS_SQL.COLUMN_VALUE(l_n_cur,1,l_v_clm_val);
            l_v_rtn_txt := l_v_rtn_txt || p_i_v_separator || l_v_clm_val;
         ELSE
             EXIT;
         END IF;
       END LOOP;

       -- close cursor --
       DBMS_SQL.CLOSE_CURSOR(l_n_cur);

       -- remove last char which is seprator --
       IF SUBSTR(l_v_rtn_txt,-1,1) = p_i_v_separator THEN
          l_v_rtn_txt :=SUBSTR(l_v_rtn_txt,1,LENGTH(l_v_rtn_txt)-1);
       END IF;

       -- remove first char if that is seprator --
       IF SUBSTR(l_v_rtn_txt,1,1) =p_i_v_separator THEN
          l_v_rtn_txt :=SUBSTR(l_v_rtn_txt,2);
       END IF;

       RETURN l_v_rtn_txt;

      EXCEPTION
           WHEN  OTHERS THEN
           IF DBMS_SQL.IS_OPEN(l_n_cur) THEN
              DBMS_SQL.CLOSE_CURSOR(l_n_cur);
           END IF;
           RETURN l_v_rtn_txt;
           --DBMS_OUTPUT.PUT_LINE('ERROR CODE : '||SQLERRM) ;

   END FN_COMMA_SPR;

   PROCEDURE PRE_EUT_GET_CONFIG (
                                    p_o_refConfigList  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                   ,p_o_v_error        OUT VARCHAR2
                                ) AS
       BEGIN
           p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;

           OPEN p_o_refConfigList FOR
           SELECT CONFIG_CD
                 ,CONFIG_VALUE
           FROM   VCM_CONFIG_MST
           WHERE  CONFIG_TYP IN('UPLOAD_DIR','DOWNLOAD_DIR','REF_DIR'
                               ,'REPORT_ID' ,'REPORT_SERVER');
       EXCEPTION
           WHEN OTHERS THEN
               NULL;
   END PRE_EUT_GET_CONFIG;

    FUNCTION  FN_VESSEL_VOYAGE_FORMAT (
                                     p_i_v_vessel_1 VARCHAR2
                                    ,p_i_v_voyage_1 VARCHAR2
                                    ,p_i_v_vessel_2 VARCHAR2
                                    ,p_i_v_voyage_2 VARCHAR2
                                   )
    RETURN VARCHAR2
    IS
    l_v_return    VARCHAR2(133);
    l_v_seprator1 VARCHAR2(1)  := ' ';
    l_v_seprator2 VARCHAR2(1)  := '/';

    BEGIN

        l_v_return := p_i_v_vessel_1 || l_v_seprator1 || p_i_v_voyage_1;
        l_v_return := TRIM(l_v_return);

        IF l_v_return IS NULL THEN
            l_v_seprator2 := NULL;
        END IF;

        IF p_i_v_vessel_2 IS NOT NULL AND p_i_v_voyage_2 IS NOT NULL THEN
            l_v_return := l_v_return || l_v_seprator2 || p_i_v_vessel_2;
            l_v_return := l_v_return || l_v_seprator1 || p_i_v_voyage_2;
        ELSIF p_i_v_vessel_2 IS NOT NULL AND p_i_v_voyage_2 IS NULL THEN
            l_v_return := l_v_return || l_v_seprator2 || p_i_v_vessel_2;
        ELSIF p_i_v_voyage_2 IS NOT NULL AND p_i_v_vessel_2 IS NULL THEN
            l_v_return := l_v_return || l_v_seprator2 || p_i_v_voyage_2;
        END IF;

        RETURN l_v_return;

    END FN_VESSEL_VOYAGE_FORMAT;

    FUNCTION FN_EUT_CHECK_MASTER(
                                  p_i_mst_id     IN VARCHAR2
                                 ,p_i_mst_code   IN VARCHAR2
                                 ,p_i_rec_status IN VARCHAR2
                                )
    RETURN BOOLEAN IS
      l_n_count NUMBER := 0;
    BEGIN
     IF p_i_mst_id = G_V_ID_COUNTRY THEN
        SELECT  COUNT(1) INTO l_n_count
        FROM    ITP030
        WHERE   SCCODE = p_i_mst_code
        AND     (p_i_rec_status = G_V_STATUS_ALL OR SCRCST = p_i_rec_status);
      ELSIF p_i_mst_id = G_V_ID_CUSTOMER THEN
        SELECT  COUNT(1) INTO l_n_count
        FROM    ITP010
        WHERE   CUCUST = p_i_mst_code
        AND     (p_i_rec_status = G_V_STATUS_ALL OR CURCST = p_i_rec_status);
      ELSIF p_i_mst_id = G_V_ID_VENDOR THEN
        SELECT  COUNT(1) INTO l_n_count
        FROM    ITP025
        WHERE   VCVNCD = p_i_mst_code
        AND     (p_i_rec_status = G_V_STATUS_ALL OR VCRCST = p_i_rec_status);
      ELSIF p_i_mst_id = G_V_ID_SHIP_TERM THEN
        SELECT  COUNT(1) INTO l_n_count
        FROM    ITP070
        WHERE   MMMODE = p_i_mst_code
        AND     (p_i_rec_status = G_V_STATUS_ALL OR MMRCST = p_i_rec_status);
     ELSIF p_i_mst_id = G_V_ID_CATEGORY THEN
        SELECT  COUNT(1) INTO l_n_count
        FROM    ITP136
        WHERE   TXEQCT = p_i_mst_code
        AND     (p_i_rec_status = G_V_STATUS_ALL OR TXRCST = p_i_rec_status);
       ELSIF p_i_mst_id = G_V_ID_PACK_TYPE THEN
        SELECT  COUNT(1) INTO l_n_count
        FROM    ITP170
        WHERE   PKCODE = p_i_mst_code
        AND     (p_i_rec_status = G_V_STATUS_ALL OR PKRCST = p_i_rec_status);
     ELSIF p_i_mst_id = G_V_ID_FSC THEN
        SELECT  COUNT(1) INTO l_n_count
        FROM    ITP188
        WHERE   CRCNTR = p_i_mst_code;
      END IF;

      IF l_n_count > 0 THEN
        RETURN TRUE;
      ELSE
        RETURN FALSE;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        RETURN FALSE;
    END;


  FUNCTION FN_EUT_VALID_WEEK (
                                p_i_n_year NUMBER
                                ,p_i_n_wk_no NUMBER
                             )
  RETURN BOOLEAN AS
    l_n_start_wk_yr NUMBER := 1;
    l_n_last_wk_yr  NUMBER := 1;
  BEGIN
    l_n_last_wk_yr := FN_EUT_GET_WEEK_NO(TO_DATE('31/12/'||p_i_n_year,G_V_DATE_FORMAT));
    IF (p_i_n_wk_no < l_n_start_wk_yr OR  p_i_n_wk_no > l_n_last_wk_yr) THEN
      RETURN FALSE;
    END IF;
    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END FN_EUT_VALID_WEEK;

  FUNCTION FN_EUT_GET_ORG_NM ( p_i_v_org_code IN VARCHAR2)
  RETURN VARCHAR2
    IS
    l_v_org_nm   VARCHAR2(50);

    BEGIN

        l_v_org_nm := NULL ;
        -- check the org name in ITP010(Customer Master)
        BEGIN
            SELECT CUNAME INTO l_v_org_nm
            FROM ITP010
            WHERE CUCUST = p_i_v_org_code;
        EXCEPTION
            WHEN OTHERS THEN
                l_v_org_nm := NULL;
        END;

        -- if not found in customer master then check in ITP030(Vendor Master)
        IF l_v_org_nm IS NULL THEN
            BEGIN
                SELECT SCNAME INTO l_v_org_nm
                FROM ITP030
                WHERE SCCODE = p_i_v_org_code;
            EXCEPTION
                WHEN OTHERS THEN
                    l_v_org_nm := NULL;
            END;
        END IF;

        RETURN l_v_org_nm ;

  END FN_EUT_GET_ORG_NM;

PROCEDURE PRE_EUT_GET_ORG_NM ( p_i_v_org_code IN VARCHAR2
                                ,p_o_v_org_name OUT VARCHAR2
                                ) AS
  BEGIN
      p_o_v_org_name := FN_EUT_GET_ORG_NM(p_i_v_org_code);
  END PRE_EUT_GET_ORG_NM;

/* START BY RAJEEV for Save Settings */
     PROCEDURE PRE_GET_USER_APPLICABLE_VIEWS( p_o_ref_screen_views OUT         PCE_ECM_REF_CUR.ECM_REF_CUR
                                             ,p_i_v_screen_id                  VARCHAR2
                                             ,p_i_v_user_id                    VARCHAR2
                                             ,p_i_v_fsc_id                     VARCHAR2
                                             ,p_o_v_error          OUT  NOCOPY VARCHAR2
                                            )
    IS
    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        OPEN p_o_ref_screen_views FOR
        SELECT   PK_VIEW_ID VIEW_CODE
               , VIEW_NAME  VIEW_NAME
               , DEFAULT_FLAG
        FROM  ZCV_VIEW
        WHERE (FK_USER_ID IS NULL OR FK_USER_ID = p_i_v_user_id)
        AND   (FK_FSC_ID  IS NULL OR FK_FSC_ID  = p_i_v_fsc_id)
        AND   FK_SCREEN_ID  = p_i_v_screen_id
        AND   RECORD_STATUS = G_V_STATUS_ACTIVE -- Active
        ORDER BY DEFAULT_FLAG DESC;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;


    PROCEDURE PRE_GET_SELECTED_VIEW(  p_i_v_screen_id              VARCHAR2
                                    , p_i_v_user_id                VARCHAR2
                                    , p_i_v_fsc_id                 VARCHAR2
                                    , p_o_v_view_id     OUT NOCOPY VARCHAR2
                                    , p_o_v_error       OUT NOCOPY VARCHAR2
                                   )
    IS
        l_b_found     BOOLEAN;

    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        -- Get if Defined for User
        BEGIN
            l_b_found := TRUE;
            SELECT PK_VIEW_ID
            INTO   p_o_v_view_id
            FROM   ZCV_VIEW
            WHERE  FK_SCREEN_ID  = p_i_v_screen_id
            AND    FK_USER_ID    = p_i_v_user_id
            AND    DEFAULT_FLAG  = G_V_DEFAULT_YES
            AND    RECORD_STATUS = G_V_STATUS_ACTIVE; -- Active
        EXCEPTION WHEN NO_DATA_FOUND THEN
            l_b_found := FALSE;
        END;

        -- If not found then, get if Defined for FSC
        IF NOT l_b_found THEN
          BEGIN
              l_b_found := TRUE;
              SELECT PK_VIEW_ID
              INTO   p_o_v_view_id
              FROM   ZCV_VIEW
              WHERE  FK_SCREEN_ID  = p_i_v_screen_id
              AND    FK_FSC_ID     = p_i_v_fsc_id
              AND    DEFAULT_FLAG  = G_V_DEFAULT_YES
              AND    RECORD_STATUS = G_V_STATUS_ACTIVE; -- Active
          EXCEPTION WHEN NO_DATA_FOUND THEN
              l_b_found := FALSE;
          END;
        END IF;

        -- If not found then, get if Defined Global
        IF NOT l_b_found THEN
          BEGIN
              l_b_found := TRUE;
              SELECT PK_VIEW_ID
              INTO   p_o_v_view_id
              FROM   ZCV_VIEW
              WHERE  FK_SCREEN_ID  = p_i_v_screen_id
              AND    VIEW_TYPE     = G_V_GLOBAL_VIEW
              AND    DEFAULT_FLAG  = G_V_DEFAULT_YES
              AND    RECORD_STATUS = G_V_STATUS_ACTIVE; -- Active
          EXCEPTION WHEN NO_DATA_FOUND THEN
              l_b_found := FALSE;
          END;
        END IF;

        -- If not found then, get if Defined Default
        SELECT PK_VIEW_ID
        INTO   p_o_v_view_id
        FROM   ZCV_VIEW
        WHERE  FK_SCREEN_ID  = p_i_v_screen_id
        AND    VIEW_TYPE     = G_V_DEFAULT_VIEW
        AND    DEFAULT_FLAG  = G_V_DEFAULT_YES
        AND    RECORD_STATUS = G_V_STATUS_ACTIVE; -- Active

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;


    PROCEDURE PRE_GET_SEARCH_VALUES(  p_o_ref_search_on OUT        PCE_ECM_REF_CUR.ECM_REF_CUR
                                    , p_i_v_view_id                VARCHAR2
                                    , p_o_v_error       OUT NOCOPY VARCHAR2
                                   )
    IS
    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        OPEN p_o_ref_search_on FOR
        SELECT   COMPONENT_ID
               , COMPONENT_VALUE
        FROM  ZCV_VIEW_SEARCH
        WHERE FK_VIEW_ID    = p_i_v_view_id
        AND   RECORD_STATUS = G_V_STATUS_ACTIVE; -- Active

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;


    PROCEDURE PRE_GET_GRID_COLUMN_DEFINATION(  p_o_ref_col_def OUT        PCE_ECM_REF_CUR.ECM_REF_CUR
                                             , p_i_v_view_id              VARCHAR2
                                             , p_o_v_error     OUT NOCOPY VARCHAR2
                                            )
    IS
    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        OPEN p_o_ref_col_def FOR
        SELECT  ZSC.COLUMN_ID          COLUMN_ID
               ,ZSC.COLUMN_DESC        COLUMN_NAME
               ,ZVC.DISPLAY_WIDTH      COLUMN_WIDTH
               ,ZSC.DEFAULT_POSITION   DEFAULT_POSITION
               ,ZVC.COLUMN_SEQ         SHOW_POSITION
               ,ZVC.DISPLAY_FLAG       IS_VISIBLE
               ,ZSC.HIDEABLE           IS_HIDEABLE
        FROM  ZCV_SCREEN_COLUMN ZSC,
              ZCV_VIEW_COLUMN   ZVC
        WHERE ZSC.PK_SCREEN_COLUMN_ID = ZVC.FK_SCREEN_COLUMN_ID
        AND   ZVC.FK_VIEW_ID          = p_i_v_view_id
        AND   ZVC.RECORD_STATUS       = G_V_STATUS_ACTIVE  -- Active
        ORDER BY ZVC.COLUMN_SEQ;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;


    PROCEDURE PRE_GET_SYSDATE(  p_o_v_sysdate    OUT NOCOPY    VARCHAR2
                              , p_o_v_error      OUT NOCOPY    VARCHAR2
                              )
    IS
    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        SELECT TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')
        INTO p_o_v_sysdate
        FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;

    PROCEDURE PRE_INS_USER_VIEW_SETTINGS(  p_i_v_view_name                  VARCHAR2
                                         , p_i_v_screen_id                  VARCHAR2
                                         , p_i_v_view_type                  VARCHAR2
                                         , p_i_v_user_id                    VARCHAR2
                                         , p_i_v_fsc_id                     VARCHAR2
                                         , p_i_v_default_flag               VARCHAR2
                                         , p_i_v_record_status              VARCHAR2
                                         , p_i_v_record_add_user            VARCHAR2
                                         , p_i_v_record_add_date            VARCHAR2
                                         , p_o_v_view_id        OUT NOCOPY  VARCHAR2
                                         , p_o_v_error          OUT NOCOPY  VARCHAR2
                                        )
    IS
    l_n_existing_view  NUMBER := null ;
    l_v_excp           EXCEPTION;
    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        --Check If view Already exists
        SELECT COUNT(1)
        INTO l_n_existing_view
        FROM ZCV_VIEW
        WHERE VIEW_NAME = p_i_v_view_name;

        IF l_n_existing_view != 0 THEN
          RAISE l_v_excp;
        END IF;

        -- Get PK (Next View ID) to Insert the record.
        SELECT  NVL(MAX(PK_VIEW_ID),0) + 1
        INTO    p_o_v_view_id
        FROM    ZCV_VIEW;



        INSERT INTO ZCV_VIEW (  PK_VIEW_ID
                              , VIEW_NAME
                              , FK_SCREEN_ID
                              , VIEW_TYPE
                              , FK_USER_ID
                              , FK_FSC_ID
                              , DEFAULT_FLAG
                              , RECORD_STATUS
                              , RECORD_ADD_USER
                              , RECORD_ADD_DATE
                              , RECORD_CHANGE_USER
                              , RECORD_CHANGE_DATE )
        VALUES (
                  p_o_v_view_id
                , p_i_v_view_name
                , p_i_v_screen_id
                , p_i_v_view_type
                , DECODE(p_i_v_view_type, G_V_USER_VIEW, p_i_v_user_id, null)
                , DECODE(p_i_v_view_type, G_V_FSC_VIEW, p_i_v_fsc_id , null)
                , p_i_v_default_flag
                , p_i_v_record_status
                , p_i_v_record_add_user
                , TO_DATE(p_i_v_record_add_date,'YYYYMMDDHH24MISS')
                , p_i_v_record_add_user
                , TO_DATE(p_i_v_record_add_date,'YYYYMMDDHH24MISS')
              );

    EXCEPTION
        WHEN l_v_excp THEN
          p_o_v_error := PCE_EUT_COMMON.G_V_GE0024;
          RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;

    PROCEDURE PRE_INS_GRID_COLUMN_DEFINATION(  p_i_v_view_id                        VARCHAR2
                                             , p_i_v_screen_id                      VARCHAR2
                                             , p_i_v_column_id                      VARCHAR2
                                             , p_i_v_column_seq                     VARCHAR2
                                             , p_i_v_display_flag                   VARCHAR2
                                             , p_i_v_display_width                  VARCHAR2
                                             , p_i_v_record_status                  VARCHAR2
                                             , p_i_v_record_add_user                VARCHAR2
                                             , p_i_v_record_add_date                VARCHAR2
                                             , p_o_v_error              OUT NOCOPY  VARCHAR2
                                            )
    IS

        l_n_view_column_id      NUMBER;
        l_b_found               BOOLEAN;
        l_d_rec_add_date        TIMESTAMP ;
        l_n_pk_screen_column_id NUMBER;

    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        -- Get PK (Next record id) for insert.
        SELECT  NVL(MAX(PK_VIEW_COLUMN_ID),0)+1
        INTO    l_n_view_column_id
        FROM    ZCV_VIEW_COLUMN;

        SELECT PK_SCREEN_COLUMN_ID
        INTO   l_n_pk_screen_column_id
        FROM   ZCV_SCREEN_COLUMN
        WHERE  COLUMN_ID    = p_i_v_column_id
        AND    FK_SCREEN_ID = p_i_v_screen_id;

        INSERT INTO ZCV_VIEW_COLUMN (
                                      PK_VIEW_COLUMN_ID
                                    , FK_VIEW_ID
                                    , FK_SCREEN_COLUMN_ID
                                    , COLUMN_SEQ
                                    , DISPLAY_FLAG
                                    , DISPLAY_WIDTH
                                    , RECORD_STATUS
                                    , RECORD_ADD_USER
                                    , RECORD_ADD_DATE
                                    , RECORD_CHANGE_USER
                                    , RECORD_CHANGE_DATE
        ) VALUES (
              l_n_view_column_id
            , p_i_v_view_id
            , l_n_pk_screen_column_id
            , p_i_v_column_seq
            , p_i_v_display_flag
            , p_i_v_display_width
            , p_i_v_record_status
            , p_i_v_record_add_user
            , TO_DATE(p_i_v_record_add_date,'YYYYMMDDHH24MISS')
            , p_i_v_record_add_user
            , TO_DATE(p_i_v_record_add_date,'YYYYMMDDHH24MISS')
      );

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;


    PROCEDURE PRE_INS_SEARCH_CRITERIA(  p_i_v_view_id                       VARCHAR2
                                      , p_i_v_component_id                  VARCHAR2
                                      , p_i_v_component_value               VARCHAR2
                                      , p_i_v_record_status                 VARCHAR2
                                      , p_i_v_record_add_user               VARCHAR2
                                      , p_i_v_record_add_date               VARCHAR2
                                      , p_o_v_error            OUT NOCOPY   VARCHAR2
                                   )
    IS

        l_n_view_search_id  NUMBER;

    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        SELECT  NVL(MAX(PK_VIEW_SEARCH_ID),0) + 1
        INTO    l_n_view_search_id
        FROM    ZCV_VIEW_SEARCH;

        INSERT INTO ZCV_VIEW_SEARCH (
                                      PK_VIEW_SEARCH_ID
                                    , FK_VIEW_ID
                                    , COMPONENT_ID
                                    , COMPONENT_VALUE
                                    , RECORD_STATUS
                                    , RECORD_ADD_USER
                                    , RECORD_ADD_DATE
                                    , RECORD_CHANGE_USER
                                    , RECORD_CHANGE_DATE
        ) VALUES (
             l_n_view_search_id
            , p_i_v_view_id
            , p_i_v_component_id
            , p_i_v_component_value
            , p_i_v_record_status
            , p_i_v_record_add_user
            , TO_DATE(p_i_v_record_add_date,'YYYYMMDDHH24MISS')
            , p_i_v_record_add_user
            , TO_DATE(p_i_v_record_add_date,'YYYYMMDDHH24MISS')
        );

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;


    PROCEDURE PRE_UPD_GRID_COLUMN_DEFINATION(  p_i_v_view_id                        VARCHAR2
                                             , p_i_v_screen_id                      VARCHAR2
                                             , p_i_v_column_id                      VARCHAR2
                                             , p_i_v_column_seq                     VARCHAR2
                                             , p_i_v_display_flag                   VARCHAR2
                                             , p_i_v_display_width                  VARCHAR2
                                             , p_i_v_record_change_user             VARCHAR2
                                             , p_i_v_record_change_date             VARCHAR2
                                             , p_o_v_error               OUT NOCOPY VARCHAR2
                                            )
    IS
    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        UPDATE ZCV_VIEW_COLUMN
        SET    COLUMN_SEQ         = p_i_v_column_seq        ,
               DISPLAY_FLAG       = p_i_v_display_flag      ,
               DISPLAY_WIDTH      = p_i_v_display_width     ,
               RECORD_CHANGE_USER = p_i_v_record_change_user,
               RECORD_CHANGE_DATE = TO_DATE(p_i_v_record_change_date,'YYYYMMDDHH24MISS')
        WHERE  FK_VIEW_ID          = p_i_v_view_id
        AND    FK_SCREEN_COLUMN_ID = (SELECT PK_SCREEN_COLUMN_ID
                                      FROM   ZCV_SCREEN_COLUMN
                                      WHERE  COLUMN_ID    = p_i_v_column_id
                                      AND    FK_SCREEN_ID = p_i_v_screen_id);

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;


    PROCEDURE PRE_UPD_USER_VIEW_SETTINGS(  p_i_v_view_id                            VARCHAR2
                                         , p_i_v_view_type                          VARCHAR2
                                         , p_i_v_screen_id                          VARCHAR2
                                         , p_i_v_fsc_id                             VARCHAR2
                                         , p_i_v_record_change_user                 VARCHAR2
                                         , p_i_v_record_change_date                 VARCHAR2
                                         , p_o_v_error              OUT NOCOPY      VARCHAR2
                                        )
    IS

    BEGIN
        p_o_v_error := G_V_SUCCESS_CD;
        IF p_i_v_view_type = 'U' THEN

            UPDATE  ZCV_VIEW
            SET     DEFAULT_FLAG       = DECODE(PK_VIEW_ID, p_i_v_view_id, G_V_DEFAULT_YES, G_V_DEFAULT_NO)
                  , RECORD_CHANGE_USER = p_i_v_record_change_user
                  , RECORD_CHANGE_DATE = TO_DATE(p_i_v_record_change_date,'YYYYMMDDHH24MISS')
            WHERE FK_SCREEN_ID = p_i_v_screen_id
            AND   FK_USER_ID =  p_i_v_record_change_user;

        ELSIF p_i_v_view_type = G_V_FSC_VIEW THEN

            UPDATE  ZCV_VIEW
            SET     DEFAULT_FLAG       = DECODE(PK_VIEW_ID, p_i_v_view_id, G_V_DEFAULT_YES, G_V_DEFAULT_NO)
                  , RECORD_CHANGE_USER = p_i_v_record_change_user
                  , RECORD_CHANGE_DATE = TO_DATE(p_i_v_record_change_date,'YYYYMMDDHH24MISS')
            WHERE FK_SCREEN_ID = p_i_v_screen_id
            AND   FK_FSC_ID    =  p_i_v_fsc_id;

        ELSIF p_i_v_view_type = G_V_GLOBAL_VIEW THEN

            UPDATE ZCV_VIEW
            SET     DEFAULT_FLAG       = DECODE(PK_VIEW_ID, p_i_v_view_id, G_V_DEFAULT_YES, G_V_DEFAULT_NO)
                  , RECORD_CHANGE_USER = p_i_v_record_change_user
                  , RECORD_CHANGE_DATE = TO_DATE(p_i_v_record_change_date,'YYYYMMDDHH24MISS')
            WHERE FK_SCREEN_ID =  p_i_v_screen_id
            AND   VIEW_TYPE = G_V_GLOBAL_VIEW;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END PRE_UPD_USER_VIEW_SETTINGS;


    PROCEDURE PRE_UPD_SEARCH_CRITERIA(  p_i_v_view_id                           VARCHAR2
                                      , p_i_v_component_id                      VARCHAR2
                                      , p_i_v_component_value                   VARCHAR2
                                      , p_i_v_record_change_user                VARCHAR2
                                      , p_i_v_record_change_date                VARCHAR2
                                      , p_o_v_error                OUT NOCOPY   VARCHAR2
                               )
    IS
    BEGIN

        p_o_v_error := G_V_SUCCESS_CD;

        UPDATE ZCV_VIEW_SEARCH
        SET    COMPONENT_VALUE    = p_i_v_component_value
             , RECORD_CHANGE_USER = p_i_v_record_change_user
             , RECORD_CHANGE_DATE = TO_DATE(p_i_v_record_change_date,'YYYYMMDDHH24MISS')
        WHERE FK_VIEW_ID   = p_i_v_view_id
        AND   COMPONENT_ID = p_i_v_component_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END PRE_UPD_SEARCH_CRITERIA;

PROCEDURE PRE_EUT_DEL_ERR_LOG (
                                 p_i_v_prog_id       VARCHAR2
                                ,p_i_v_file_nm       VARCHAR2
                                ,p_i_v_user_id       VARCHAR2
                              ) AS
BEGIN
  DELETE
  FROM    VCM_ERR_LOG
  WHERE   PROG_ID = p_i_v_prog_id
  AND     FILE_NM = p_i_v_file_nm
  AND     UPD_BY  = p_i_v_user_id;
EXCEPTION
    WHEN OTHERS THEN
      NULL;
END PRE_EUT_DEL_ERR_LOG;

PROCEDURE PRE_EUT_INS_ERR_LOG (
                                 p_i_v_prog_id       VARCHAR2
                                ,p_i_v_file_nm       VARCHAR2
                                ,p_i_v_line_no       NUMBER
                                ,p_i_v_col_no        NUMBER
                                ,p_i_v_col_nm        VARCHAR2
                                ,p_i_v_col_val       VARCHAR2
                                ,p_i_v_user_err_cd   VARCHAR2
                                ,p_i_v_user_err_desc VARCHAR2
                                ,p_i_v_ora_err_cd    VARCHAR2
                                ,p_i_v_ora_err_desc  VARCHAR2
                                ,p_i_v_user_id       VARCHAR2
                                ,p_i_v_err_dt        DATE
                              ) AS
BEGIN
    INSERT INTO VCM_ERR_LOG
        (
             PROG_ID
            ,FILE_NM
            ,LINE_NO
            ,COL_NO
            ,COL_NAME
            ,COL_VALUE
            ,USER_ERR_CD
            ,USER_ERR_MSG
            ,ORA_ERR_CD
            ,ORA_ERR_MSG
            ,UPD_BY
            ,UPD_DT
        )
        VALUES
        (
             p_i_v_prog_id
            ,SUBSTR(p_i_v_file_nm,1,50)
            ,p_i_v_line_no
            ,p_i_v_col_no
            ,SUBSTR(p_i_v_col_nm,1,50)
            ,SUBSTR(p_i_v_col_val,1,200)
            ,SUBSTR(p_i_v_user_err_cd,1,15)
            ,SUBSTR(p_i_v_user_err_desc,1,100)
            ,SUBSTR(p_i_v_ora_err_cd,1,15)
            ,SUBSTR(p_i_v_ora_err_desc,1,100)
            ,p_i_v_user_id
            ,NVL(p_i_v_err_dt,SYSDATE)
        );
EXCEPTION
    WHEN OTHERS THEN
      NULL;
END PRE_EUT_INS_ERR_LOG;

  PROCEDURE PRE_EUT_GET_ERR_LOG (
                                p_o_refErrorLogList  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                ,p_i_v_prog_id       VARCHAR2
                                ,p_i_v_file_nm       VARCHAR2
                                ,p_i_v_user_id       VARCHAR2
                                ,p_o_v_error         OUT VARCHAR2
                              ) AS
  BEGIN
    p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    OPEN p_o_refErrorLogList FOR
    SELECT   LINE_NO
            ,COL_NO
            ,COL_NAME
            ,COL_VALUE
            ,USER_ERR_CD || ':' || USER_ERR_MSG AS USER_ERR_MSG
            ,ORA_ERR_CD  || ':' || ORA_ERR_MSG  AS ORA_ERR_MSG
    FROM    VCM_ERR_LOG
    WHERE   PROG_ID = p_i_v_prog_id
    AND     FILE_NM = p_i_v_file_nm
    AND     UPD_BY  = p_i_v_user_id
    ORDER   BY LINE_NO, COL_NO;
EXCEPTION
    WHEN OTHERS THEN
        p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
END PRE_EUT_GET_ERR_LOG;

FUNCTION FN_EUT_GET_VAT (p_i_v_fsc_cd VARCHAR2)
RETURN NUMBER IS
l_n_vat NUMBER;
BEGIN
    BEGIN
      SELECT  NVL(VAT_PERC,0)
      INTO    l_n_vat
      FROM    ITP188 FSC_MST, ITP030 CNTRY_MST
      WHERE   FSC_MST.CRCNCD = CNTRY_MST.SCCODE
      AND     FSC_MST.CRCNTR = p_i_v_fsc_cd;
    EXCEPTION
        WHEN OTHERS THEN
          l_n_vat := 0;
    END;
    RETURN l_n_vat;
END;

    /*    Handling Instruction Code validation */
    PROCEDURE PRE_EDL_VAL_HAND_CODE(
          p_i_v_shi_code    IN VARCHAR2
        , p_o_v_flag        OUT VARCHAR2
        , p_o_v_err_cd      OUT VARCHAR2
        ) AS
        l_shi_desc           VARCHAR2(60);
        BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        SELECT SHI_DESCRIPTION
        INTO l_shi_desc
        FROM SHP007
        WHERE SHI_CODE = p_i_v_shi_code
    AND   RECORD_STATUS = 'A';

        IF(l_shi_desc IS NOT NULL) THEN
            p_o_v_flag := l_shi_desc;
        ELSE
            p_o_v_flag := 'N';
        END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_o_v_flag := 'N';
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_EDL_VAL_HAND_CODE;

    PROCEDURE PRE_EUT_GET_CLR
    (
          p_o_refClr                OUT PCE_ECM_REF_CUR.ECM_REF_CUR
      , p_o_v_err_cd              OUT NOCOPY  VARCHAR2
    ) AS
    BEGIN
    p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

    OPEN p_o_refClr FOR
        SELECT CLR_CODE, CLR_DESC FROM SHP041
        WHERE RECORD_STATUS= 'A';

    EXCEPTION
      WHEN OTHERS THEN
        p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_EUT_GET_CLR;

    /*    Check for the Operator Code in OPERATOR_CODE Master Table. */
    PROCEDURE PRE_VAL_OPERATOR_CODE( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) IS
        l_rec_count       NUMBER := 0;
        BEGIN
            p_o_v_err_cd := G_V_SUCCESS_CD;


        SELECT COUNT(1)
        INTO l_rec_count
        FROM OPERATOR_CODE_MASTER
        WHERE OPERATOR_CODE = p_i_v_oper_cd
        AND   STATUS = 'A';

        IF(l_rec_count = 0) THEN
            p_o_v_flag := 'N';
        ELSE
            p_o_v_flag := 'Y';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_VAL_OPERATOR_CODE;

    /*    Check for the Shipment Term Code . */
    PROCEDURE PRE_VAL_SHIPMENT_TERM_CODE( p_i_v_shipmnt_cd                VARCHAR2
                                        , p_o_v_flag        OUT        VARCHAR2
                                        , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) IS
        l_rec_count       NUMBER := 0;
        BEGIN
              p_o_v_err_cd := G_V_SUCCESS_CD;
        SELECT COUNT(1)
        INTO l_rec_count
        FROM ITP070
        WHERE MMMODE = p_i_v_shipmnt_cd;

        IF(l_rec_count = 0) THEN
            p_o_v_flag := 'N';
        ELSE
            p_o_v_flag := 'Y';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_VAL_SHIPMENT_TERM_CODE;


    PROCEDURE PRE_VAL_EQUIPMENT_TYPE( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) IS
        l_rec_count       NUMBER := 0;
        BEGIN
              p_o_v_err_cd := G_V_SUCCESS_CD;

        commit;
        SELECT COUNT(1)
        INTO l_rec_count
        FROM ITP075
        WHERE TRTYPE = p_i_v_oper_cd
        AND   TRRCST = 'A';

        IF(l_rec_count = 0) THEN
            p_o_v_flag := 'N';
        ELSE
            p_o_v_flag := 'Y';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_VAL_EQUIPMENT_TYPE;


    PROCEDURE PRE_VAL_PORT_CODE( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) IS
        l_rec_count       NUMBER := 0;
        BEGIN
              p_o_v_err_cd := G_V_SUCCESS_CD;
        SELECT COUNT(1)
        INTO l_rec_count
        FROM ITP040
        WHERE PICODE = p_i_v_oper_cd
        AND   PIRCST = 'A';

        IF(l_rec_count = 0) THEN
            p_o_v_flag := 'N';
        ELSE
            p_o_v_flag := 'Y';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_VAL_PORT_CODE;

    PROCEDURE PRE_VAL_PORT_TERMINAL( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) IS
        l_rec_count       NUMBER := 0;
        BEGIN
              p_o_v_err_cd := G_V_SUCCESS_CD;
        SELECT COUNT(1)
        INTO l_rec_count
        FROM ITP130
        WHERE TQTERM = p_i_v_oper_cd
        AND   TQRCST = 'A';

        IF(l_rec_count = 0) THEN
            p_o_v_flag := 'N';
        ELSE
            p_o_v_flag := 'Y';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_VAL_PORT_TERMINAL;

    FUNCTION FN_EUT_GET_GMT_VAL
    (
          p_i_v_date           VARCHAR2
        , p_i_v_time           VARCHAR2
        , p_i_v_port           VARCHAR2
    )
    RETURN DATE IS
    l_v_date  DATE;
    BEGIN

        SELECT (  TO_DATE( p_i_v_date ,'RRRRMMDD')
                + (1/1440*(MOD( p_i_v_time , 100)+FLOOR( p_i_v_time /100)*60))
                - (1/1440*(MOD(P.PIVGMT, 100) + FLOOR(P.PIVGMT/100)*60))
               )
        INTO   l_v_date
        FROM   ITP040 P
        WHERE  P.PICODE = p_i_v_port ;

        /* start chenge by vikas verma*/
         BEGIN
            IF (l_v_date IS NULL) THEN
                SELECT TO_DATE(p_i_v_date, 'YYYYMMDD')
                INTO l_v_date
                FROM DUAL;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
            BEGIN
                SELECT TO_DATE(p_i_v_date, 'DD/MM/YYYY')
                INTO l_v_date
                FROM DUAL;
            EXCEPTION
                WHEN OTHERS THEN
                    l_v_date := NULL;
            END;
        END;

        /* end chenge by vikas verma*/


        RETURN l_v_date;
    END;

        /* Function to check passed container is coc or not. */
        /* Return true if container is coc otherwise false. */
        FUNCTION FN_CHECK_COC_FLAG (
              p_i_v_equ_no        VARCHAR2
            , p_i_v_port          VARCHAR2
            , p_i_v_etd_date      VARCHAR2
            , p_i_v_etd_time      VARCHAR2
            , p_o_v_err_cd        OUT VARCHAR2
        )
        RETURN BOOLEAN
        IS
            l_v_count     NUMBER := 0;
            l_v_etd_date      VARCHAR(8);
        BEGIN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
            l_v_etd_date := TO_CHAR(TO_DATE(p_i_v_etd_date, 'DD/MM/YYYY'), 'RRRRMMDD');

            SELECT  COUNT(1)
            INTO    l_v_count
            FROM     ECP010
            WHERE     ECP010.EQEQTN = p_i_v_equ_no;

            IF(l_v_count = 0)THEN
                RETURN FALSE;
            ELSE

                SELECT  COUNT(1)
                INTO    l_v_count
                FROM     ITP115,
                        ECP010
                WHERE     ECP010.EQCUST = ITP115.SQCODE
                AND     ECP010.EQEQTN = p_i_v_equ_no
                AND     NVL(ITP115.SQONOF,'~') = 'F';

                IF(l_v_count = 0)THEN
                    RETURN TRUE;
                ELSE

                    SELECT  COUNT(1)
                    INTO    l_v_count
                    FROM     ECP010
                    WHERE     ECP010.EQEQTN = p_i_v_equ_no
                    AND    (
                            PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(    ECP010.EQCUMD  , ECP010.LAST_MOVE_TIME    , ECP010.EQCUPT )
                            <
                            PCE_EUT_COMMON.FN_EUT_GET_GMT_VAL(    l_v_etd_date  , p_i_v_etd_time    , p_i_v_port )
                            );

                    IF(l_v_count = 0)THEN
                        RETURN FALSE;
                    ELSE
                        RETURN TRUE;
                    END IF;
                END IF;
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
            p_o_v_err_cd := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
   END;

    /* Populate Local Container Status */
    PROCEDURE PRE_POPULATE_CONT_STATUS (
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT CONT_STATUS_CD ,
          CONT_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS CONT_STATUS_CD  ,
            CONFIG_DESC                 AS CONT_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_LCS_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_CONT_STATUS;

    /* Populate Midstream combo */
    PROCEDURE PRE_POPULATE_MIDSTREAM(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT MIDSTREAM_CD ,
          MIDSTREAM_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS MIDSTREAM_CD  ,
            CONFIG_DESC                 AS MIDSTREAM_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_MS_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_MIDSTREAM;

    /* Populate Load Condition Combo */
    PROCEDURE PRE_POPULATE_LOAD_COND(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT LOAD_COND_CD ,
          LOAD_COND_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS LOAD_COND_CD  ,
            CONFIG_DESC                 AS LOAD_COND_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_LC_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );


    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_LOAD_COND;

    /* Populate Damaged Combo */
    PROCEDURE PRE_POPULATE_DAMAGED(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT DAMAGED_CD ,
          DAMAGED_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS DAMAGED_CD  ,
            CONFIG_DESC                 AS DAMAGED_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_DMG_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );


    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_DAMAGED;

    /* Populate Swap Connection Combo */
    PROCEDURE PRE_POPULATE_SWAP_CONECTION(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT SWAP_CONECTION_CD ,
          SWAP_CONECTION_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS SWAP_CONECTION_CD  ,
            CONFIG_DESC                 AS SWAP_CONECTION_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_SW_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_SWAP_CONECTION;

    /* Populate Tight Connection Combo */
    PROCEDURE PRE_POPULATE_TIGHT_CON(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT TIGHT_CON_CD ,
          TIGHT_CON_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS TIGHT_CON_CD  ,
            CONFIG_DESC                 AS TIGHT_CON_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_TCPOD_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_TIGHT_CON;

    /* Populate Flash unit Combo */
    PROCEDURE PRE_POPULATE_FLASH_UNIT(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT FLASH_UNIT_CD ,
          FLASH_UNIT_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS FLASH_UNIT_CD  ,
            CONFIG_DESC                 AS FLASH_UNIT_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_U_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_FLASH_UNIT;

    /* Populate Fumigation Combo */
    PROCEDURE PRE_POPULATE_FUMIGATION(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT FUMIGATION_CD ,
          FUMIGATION_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS FUMIGATION_CD  ,
            CONFIG_DESC                 AS FUMIGATION_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_FUM_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_FUMIGATION;

    /* Populate Size Combo */
    PROCEDURE PRE_POPULATE_SIZE(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT SIZE_CD ,
          SIZE_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS SIZE_CD  ,
            CONFIG_DESC                 AS SIZE_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_SZ_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_SIZE;

    /* Populate Full MT Combo */
    PROCEDURE PRE_POPULATE_FULL_MT(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT FULL_MT_CD ,
          FULL_MT_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS FULL_MT_CD  ,
            CONFIG_DESC                 AS FULL_MT_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_MT_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_FULL_MT;

    /* Populate Booking Type Combo */
    PROCEDURE PRE_POPULATE_BOOKING_TYP(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT BOOKING_TYP_CD ,
          BOOKING_TYP_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS BOOKING_TYP_CD  ,
            CONFIG_DESC                 AS BOOKING_TYP_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_BTYP_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_BOOKING_TYP;

    /* Populate SOC-COC Combo */
    PROCEDURE PRE_POPULATE_SOC_COC(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT SOC_COC_CD ,
          SOC_COC_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS SOC_COC_CD  ,
            CONFIG_DESC                 AS SOC_COC_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_OC_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_SOC_COC;

    /* Populate POD STATUS Combo */
    PROCEDURE PRE_POPULATE_POD_STATUS(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT POD_STATUS_CD ,
          POD_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS POD_STATUS_CD  ,
            CONFIG_DESC                 AS POD_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_PODSTS_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_POD_STATUS;

    /* Populate Special Heandling Combo */
    PROCEDURE PRE_POPULATE_SPECIAL_HEANDLING(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT SPECIAL_HEANDLING_CD ,
          SPECIAL_HEANDLING_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS SPECIAL_HEANDLING_CD  ,
            CONFIG_DESC                 AS SPECIAL_HEANDLING_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_SPL_HAND_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_SPECIAL_HEANDLING;

    /* Populate Residut Combo */
    PROCEDURE PRE_POPULATE_RESIDUE(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT RESIDUE_CD ,
          RESIDUE_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS RESIDUE_CD  ,
            CONFIG_DESC                 AS RESIDUE_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_RS_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_RESIDUE;

    /* Populate Restow Status Combo */
    PROCEDURE PRE_POPULATE_RESTOW_STATUS(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT RESTOW_STATUS_CD ,
          RESTOW_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS RESTOW_STATUS_CD  ,
            CONFIG_DESC                 AS RESTOW_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_RESTS_RESTW
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_RESTOW_STATUS;

    /* Populate Discharge Status Combo for Booking */
    PROCEDURE PRE_POPULATE_DISCHARGE_ST_BOOK(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT DISCHARGE_ST_BOOK_CD ,
          DISCHARGE_ST_BOOK_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS DISCHARGE_ST_BOOK_CD  ,
            CONFIG_DESC                 AS DISCHARGE_ST_BOOK_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_DIS_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_DISCHARGE_ST_BOOK;

    /* Populate Discharge Status Combo for Overlanded */
    PROCEDURE PRE_POPULATE_DISCHARGE_ST_OL(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT DISCHARGE_ST_OL_CD ,
          DISCHARGE_ST_OL_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS DISCHARGE_ST_OL_CD  ,
            CONFIG_DESC                 AS DISCHARGE_ST_OL_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_DISTS_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_DISCHARGE_ST_OL;

    /* Populate Find in value combos for Bookings */
    PROCEDURE PRE_POPULATE_BOOKED_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT BOOKED_IN_CD ,
          BOOKED_IN_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS BOOKED_IN_CD  ,
            CONFIG_DESC                 AS BOOKED_IN_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_IN_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_BOOKED_IN;

    /* Populate Find order value combos for Bookings */
    PROCEDURE PRE_POPULATE_BOOKED_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT BOOKED_ORDER_CD ,
          BOOKED_ORDER_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS BOOKED_ORDER_CD  ,
            CONFIG_DESC                 AS BOOKED_ORDER_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_OR_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_BOOKED_ORDER;

    /* Populate Find in value combos for Overlanding */
    PROCEDURE PRE_POPULATE_OL_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT OL_IN_CD ,
          OL_IN_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS OL_IN_CD  ,
            CONFIG_DESC                 AS OL_IN_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_IN_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_OL_IN;

    /* Populate Find order value combos for Bookings */
    PROCEDURE PRE_POPULATE_OL_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT OL_ORDER_CD ,
          OL_ORDER_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS OL_ORDER_CD  ,
            CONFIG_DESC                 AS OL_ORDER_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_OR_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_OL_ORDER;

    /* Populate Find in value combos for Restow */
    PROCEDURE PRE_POPULATE_RESTOW_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT RESTOW_IN_CD ,
          RESTOW_IN_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS RESTOW_IN_CD  ,
            CONFIG_DESC                 AS RESTOW_IN_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_IN_RESTWD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_RESTOW_IN;

    /* Populate Find order value combos for order */
    PROCEDURE PRE_POPULATE_RESTOW_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT RESTOW_ORDER_CD ,
          RESTOW_ORDER_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS RESTOW_ORDER_CD  ,
            CONFIG_DESC                 AS RESTOW_ORDER_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_OR_RESTWD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_RESTOW_ORDER;

    /* Populate Discharge List Status Value combo */
    PROCEDURE PRE_POPULATE_DISCHARGE_LIST_ST(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT DISCHARGE_LIST_STATUS_CD ,
          DISCHARGE_LIST_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS DISCHARGE_LIST_STATUS_CD  ,
            CONFIG_DESC                 AS DISCHARGE_LIST_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_DL_STS
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );

    EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_DISCHARGE_LIST_ST;

    /************************************************************************************************/
  /* FOR LOAD LIST */

    /* Populate Load List Status Combo */
    PROCEDURE PRE_POPULATE_LOAD_LIST_STATUS(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT LOADING_STATUS_CD ,
          LOADING_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS LOADING_STATUS_CD  ,
            CONFIG_DESC                 AS LOADING_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_LLS
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_LOAD_LIST_STATUS;

    /* Populate Load List Status Combo */
    PROCEDURE PRE_POP_LOADING_LIST_STATUS(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT LOADING_STATUS_CD ,
          LOADING_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS LOADING_STATUS_CD  ,
            CONFIG_DESC                 AS LOADING_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_LDS_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POP_LOADING_LIST_STATUS;


      /* Populate Load List Status Combo */
    PROCEDURE PRE_POPULATE_LL_BOOKED_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT BOOKED_STATUS_CD ,
          BOOKED_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS BOOKED_STATUS_CD  ,
            CONFIG_DESC                 AS BOOKED_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_IN_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_LL_BOOKED_IN;

    /* Populate Load List Status Combo */
    PROCEDURE PRE_POPULATE_LL_BOOKED_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT BOOKED_STATUS_CD ,
          BOOKED_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS BOOKED_STATUS_CD  ,
            CONFIG_DESC                 AS BOOKED_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_OR_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_LL_BOOKED_ORDER;


    /* Populate Load List Status Combo */
    PROCEDURE PRE_POP_LL_BOOK_SORT_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT BOOKED_STATUS_CD ,
          BOOKED_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS BOOKED_STATUS_CD  ,
            CONFIG_DESC                 AS BOOKED_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_SOR_BOOK
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POP_LL_BOOK_SORT_ORDER;

    /* Populate Overshipped in Combo */
    PROCEDURE PRE_POPULATE_OVERSHIPPED_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT OVERSHIPPED_IN_CD ,
          OVERSHIPPED_IN_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS OVERSHIPPED_IN_CD  ,
            CONFIG_DESC                 AS OVERSHIPPED_IN_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_IN_OVLD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_OVERSHIPPED_IN;


     /* Populate Overshipped in Combo */
    PROCEDURE PRE_POP_OVERSHIPPED_LOADING(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT LOADING_STATUS_CD ,
          LOADING_STATUS_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS LOADING_STATUS_CD  ,
            CONFIG_DESC                 AS LOADING_STATUS_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_LDSTS_OVSP
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END PRE_POP_OVERSHIPPED_LOADING;

      /* Populate Overshipped Order Combo */
    PROCEDURE PRE_POP_OVERSHIPPED_ORDER(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT OVERSHIPPED_ORD_CD ,
          OVERSHIPPED_ORD_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS OVERSHIPPED_ORD_CD  ,
            CONFIG_DESC                 AS OVERSHIPPED_ORD_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_OR_OVSP
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END PRE_POP_OVERSHIPPED_ORDER;


        /* Populate Restow in Combo */
    PROCEDURE PRE_POPULATE_LL_RESTOW_IN(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT RESTOW_IN_CD ,
          RESTOW_IN_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS RESTOW_IN_CD  ,
            CONFIG_DESC                 AS RESTOW_IN_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_IN_RESTWD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_LL_RESTOW_IN;

    /* Populate Load List Restow Order Combo */
    PROCEDURE PRE_POPULATE_RESTOW_ORD(
                                     p_o_ref_cur         OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                    ,p_o_v_err_cd       OUT VARCHAR2
                                   ) AS
    BEGIN
      p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

      OPEN p_o_ref_cur FOR
         SELECT RESTOW_ORD_CD ,
          RESTOW_ORD_DESC
           FROM
          (SELECT DISTINCT CONFIG_CD AS RESTOW_ORD_CD  ,
            CONFIG_DESC                 AS RESTOW_ORD_DESC,
            SORT_ORDER
             FROM VCM_CONFIG_MST
            WHERE CONFIG_TYP = G_V_LL_OR_RESTWD
             AND STATUS = 'A'
        ORDER BY SORT_ORDER
          );
        EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END PRE_POPULATE_RESTOW_ORD;

    PROCEDURE PRE_UPD_NEXT_POD (
          p_i_v_fk_booking_no                 TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE
        , p_i_v_lldl_flag                     VARCHAR2
        , p_i_v_fk_bkg_voyage_rout_dtl          TOS_DL_BOOKED_DISCHARGE.FK_BKG_VOYAGE_ROUTING_DTL%TYPE
        , p_i_v_load_condition                TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION%TYPE
        , p_i_v_container_gross_weight        TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT%TYPE
        --*01 begin
        , p_i_v_vgm  TOS_DL_BOOKED_DISCHARGE.VGM%TYPE
        , p_i_v_category TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE%TYPE
        --*01 end
        , p_i_v_damaged                       TOS_DL_BOOKED_DISCHARGE.DAMAGED%TYPE
        , p_i_v_fk_container_operator         TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR%TYPE
        , p_i_v_out_slot_operator             TOS_DL_BOOKED_DISCHARGE.OUT_SLOT_OPERATOR%TYPE
        , p_i_v_seal_no                       TOS_DL_BOOKED_DISCHARGE.SEAL_NO%TYPE
        , p_i_v_mlo_vessel                    TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL%TYPE
        , p_i_v_mlo_voyage                    TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE%TYPE
        , p_i_v_mlo_vessel_eta                TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL_ETA%TYPE
        , p_i_v_mlo_pod1                      TOS_DL_BOOKED_DISCHARGE.MLO_POD1%TYPE
        , p_i_v_mlo_pod2                      TOS_DL_BOOKED_DISCHARGE.MLO_POD2%TYPE
        , p_i_v_mlo_pod3                      TOS_DL_BOOKED_DISCHARGE.MLO_POD3%TYPE
        , p_i_v_mlo_del                       TOS_DL_BOOKED_DISCHARGE.MLO_DEL%TYPE
        , p_i_v_fk_handl_instruction_1        TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1%TYPE
        , p_i_v_fk_handl_instruction_2        TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2%TYPE
        , p_i_v_fk_handl_instruction_3        TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3%TYPE
        , p_i_v_container_loading_rem_1       TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1%TYPE
        , p_i_v_container_loading_rem_2       TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2%TYPE
        , p_i_v_tight_connection_flag1        TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1%TYPE
        , p_i_v_tight_connection_flag2        TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2%TYPE
        , p_i_v_tight_connection_flag3        TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3%TYPE
        , p_i_v_fumigation_only               TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY%TYPE
        , p_i_v_residue_only_flag             TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG%TYPE
        , p_i_v_fk_bkg_size_type_dtl          TOS_DL_BOOKED_DISCHARGE.FK_BKG_SIZE_TYPE_DTL%TYPE
        , p_i_v_fk_bkg_supplier               TOS_DL_BOOKED_DISCHARGE.FK_BKG_SUPPLIER%TYPE
        , p_i_v_fk_bkg_equipm_dtl             TOS_DL_BOOKED_DISCHARGE.FK_BKG_EQUIPM_DTL%TYPE
        , p_o_v_err_cd                        OUT VARCHAR2
    )
    AS

        l_v_rec_count                           NUMBER := 0;
        l_v_nxt_rec_flag                        NUMBER := 0;
        UPD_FLAG                                VARCHAR2(1) := 'N';
        DISCHARGE_LIST                          VARCHAR2(1) := 'D';
        LOAD_LIST                               VARCHAR2(1) := 'L';


    BEGIN

        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /* upload load list */
        UPDATE TOS_LL_BOOKED_LOADING
        SET
            LOAD_CONDITION = DECODE(p_i_v_load_condition,'~',NULL,NVL2(p_i_v_load_condition,p_i_v_load_condition,LOAD_CONDITION))
            ,CONTAINER_GROSS_WEIGHT = NVL2(p_i_v_container_gross_weight,p_i_v_container_gross_weight,CONTAINER_GROSS_WEIGHT)
            --*01 begin
            ,VGM = NVL2(p_i_v_vgm,p_i_v_vgm,VGM)
            ,CATEGORY_CODE = DECODE(p_i_v_category,'~',NULL,NVL2(p_i_v_category,p_i_v_category,CATEGORY_CODE))
            --*01 end
            ,DAMAGED = DECODE(p_i_v_damaged,'~',NULL,NVL2(p_i_v_damaged,p_i_v_damaged,DAMAGED))
            ,FK_CONTAINER_OPERATOR = DECODE(p_i_v_fk_container_operator,'~',NULL,NVL2(p_i_v_fk_container_operator,p_i_v_fk_container_operator,FK_CONTAINER_OPERATOR))
            ,OUT_SLOT_OPERATOR = DECODE(p_i_v_out_slot_operator,'~',NULL,NVL2(p_i_v_out_slot_operator,p_i_v_out_slot_operator,OUT_SLOT_OPERATOR))
            ,SEAL_NO = DECODE(p_i_v_seal_no,'~',NULL,NVL2(p_i_v_seal_no,p_i_v_seal_no,SEAL_NO))
            ,MLO_VESSEL = DECODE(p_i_v_mlo_vessel,'~',NULL,NVL2(p_i_v_mlo_vessel,p_i_v_mlo_vessel,MLO_VESSEL))
            ,MLO_VOYAGE = DECODE(p_i_v_mlo_voyage,'~',NULL,NVL2(p_i_v_mlo_voyage,p_i_v_mlo_voyage,MLO_VOYAGE))
            ,MLO_VESSEL_ETA = DECODE(p_i_v_mlo_vessel_eta,to_date('01/01/1900', 'dd/mm/yyyy'),NULL,NVL2(p_i_v_mlo_vessel_eta,p_i_v_mlo_vessel_eta,MLO_VESSEL_ETA))
            ,MLO_POD1 = DECODE(p_i_v_mlo_pod1,'~',NULL,NVL2(p_i_v_mlo_pod1,p_i_v_mlo_pod1,MLO_POD1))
            ,MLO_POD2 = DECODE(p_i_v_mlo_pod2,'~',NULL,NVL2(p_i_v_mlo_pod2,p_i_v_mlo_pod2,MLO_POD2))
            ,MLO_POD3 = DECODE(p_i_v_mlo_pod3,'~',NULL,NVL2(p_i_v_mlo_pod3,p_i_v_mlo_pod3,MLO_POD3))
            ,MLO_DEL = DECODE(p_i_v_mlo_del,'~',NULL,NVL2(p_i_v_mlo_del,p_i_v_mlo_del,MLO_DEL))
            ,FK_HANDLING_INSTRUCTION_1 = DECODE(p_i_v_fk_handl_instruction_1,'~',NULL,NVL2(p_i_v_fk_handl_instruction_1,p_i_v_fk_handl_instruction_1,FK_HANDLING_INSTRUCTION_1))
            ,FK_HANDLING_INSTRUCTION_2 = DECODE(p_i_v_fk_handl_instruction_2,'~',NULL,NVL2(p_i_v_fk_handl_instruction_2,p_i_v_fk_handl_instruction_2,FK_HANDLING_INSTRUCTION_2))
            ,FK_HANDLING_INSTRUCTION_3 = DECODE(p_i_v_fk_handl_instruction_3,'~',NULL,NVL2(p_i_v_fk_handl_instruction_3,p_i_v_fk_handl_instruction_3,FK_HANDLING_INSTRUCTION_3))
            ,CONTAINER_LOADING_REM_1 = DECODE(p_i_v_container_loading_rem_1,'~',NULL,NVL2(p_i_v_container_loading_rem_1,p_i_v_container_loading_rem_1,CONTAINER_LOADING_REM_1))
            ,CONTAINER_LOADING_REM_2 = DECODE(p_i_v_container_loading_rem_2,'~',NULL,NVL2(p_i_v_container_loading_rem_2,p_i_v_container_loading_rem_2,CONTAINER_LOADING_REM_2))
            ,TIGHT_CONNECTION_FLAG1 = DECODE(p_i_v_tight_connection_flag1,'~',NULL,NVL2(p_i_v_tight_connection_flag1,p_i_v_tight_connection_flag1,TIGHT_CONNECTION_FLAG1))
            ,TIGHT_CONNECTION_FLAG2 = DECODE(p_i_v_tight_connection_flag2,'~',NULL,NVL2(p_i_v_tight_connection_flag2,p_i_v_tight_connection_flag2,TIGHT_CONNECTION_FLAG2))
            ,TIGHT_CONNECTION_FLAG3 = DECODE(p_i_v_tight_connection_flag3,'~',NULL,NVL2(p_i_v_tight_connection_flag3,p_i_v_tight_connection_flag3,TIGHT_CONNECTION_FLAG3))
            ,FUMIGATION_ONLY = DECODE(p_i_v_fumigation_only,'~',NULL,NVL2(p_i_v_fumigation_only,p_i_v_fumigation_only,FUMIGATION_ONLY))
            ,RESIDUE_ONLY_FLAG = DECODE(p_i_v_residue_only_flag,'~',NULL,NVL2(p_i_v_residue_only_flag,p_i_v_residue_only_flag,RESIDUE_ONLY_FLAG))
        WHERE
            FK_BOOKING_NO = p_i_v_fk_booking_no
        AND FK_BKG_SIZE_TYPE_DTL = p_i_v_fk_bkg_size_type_dtl
        AND FK_BKG_SUPPLIER = p_i_v_fk_bkg_supplier
        AND FK_BKG_EQUIPM_DTL = p_i_v_fk_bkg_equipm_dtl
        AND FK_BKG_VOYAGE_ROUTING_DTL > p_i_v_fk_bkg_voyage_rout_dtl
        AND LOADING_STATUS NOT IN ('RB','LO');

        /* Update TOS_DL_BOOKED_DISCHARGE list table for that port */
        UPDATE TOS_DL_BOOKED_DISCHARGE
        SET
            LOAD_CONDITION = DECODE(p_i_v_load_condition,'~',NULL,NVL2(p_i_v_load_condition,p_i_v_load_condition,LOAD_CONDITION))
            ,CONTAINER_GROSS_WEIGHT = NVL2(p_i_v_container_gross_weight,p_i_v_container_gross_weight,CONTAINER_GROSS_WEIGHT)
            --*01 begin
            ,VGM = NVL2(p_i_v_vgm,p_i_v_vgm,VGM)
            ,CATEGORY_CODE = DECODE(p_i_v_category,'~',NULL,NVL2(p_i_v_category,p_i_v_category,CATEGORY_CODE))
            --*01 end
            ,DAMAGED = DECODE(p_i_v_damaged,'~',NULL,NVL2(p_i_v_damaged,p_i_v_damaged,DAMAGED))
            ,FK_CONTAINER_OPERATOR = DECODE(p_i_v_fk_container_operator,'~',NULL,NVL2(p_i_v_fk_container_operator,p_i_v_fk_container_operator,FK_CONTAINER_OPERATOR))
            ,OUT_SLOT_OPERATOR = DECODE(p_i_v_out_slot_operator,'~',NULL,NVL2(p_i_v_out_slot_operator,p_i_v_out_slot_operator,OUT_SLOT_OPERATOR))
            ,SEAL_NO = DECODE(p_i_v_seal_no,'~',NULL,NVL2(p_i_v_seal_no,p_i_v_seal_no,SEAL_NO))
            ,MLO_VESSEL = DECODE(p_i_v_mlo_vessel,'~',NULL,NVL2(p_i_v_mlo_vessel,p_i_v_mlo_vessel,MLO_VESSEL))
            ,MLO_VOYAGE = DECODE(p_i_v_mlo_voyage,'~',NULL,NVL2(p_i_v_mlo_voyage,p_i_v_mlo_voyage,MLO_VOYAGE))
            ,MLO_VESSEL_ETA = DECODE(p_i_v_mlo_vessel_eta,to_date('01/01/1900', 'dd/mm/yyyy'),NULL,NVL2(p_i_v_mlo_vessel_eta,p_i_v_mlo_vessel_eta,MLO_VESSEL_ETA))
            ,MLO_POD1 = DECODE(p_i_v_mlo_pod1,'~',NULL,NVL2(p_i_v_mlo_pod1,p_i_v_mlo_pod1,MLO_POD1))
            ,MLO_POD2 = DECODE(p_i_v_mlo_pod2,'~',NULL,NVL2(p_i_v_mlo_pod2,p_i_v_mlo_pod2,MLO_POD2))
            ,MLO_POD3 = DECODE(p_i_v_mlo_pod3,'~',NULL,NVL2(p_i_v_mlo_pod3,p_i_v_mlo_pod3,MLO_POD3))
            ,MLO_DEL = DECODE(p_i_v_mlo_del,'~',NULL,NVL2(p_i_v_mlo_del,p_i_v_mlo_del,MLO_DEL))
            ,FK_HANDLING_INSTRUCTION_1 = DECODE(p_i_v_fk_handl_instruction_1,'~',NULL,NVL2(p_i_v_fk_handl_instruction_1,p_i_v_fk_handl_instruction_1,FK_HANDLING_INSTRUCTION_1))
            ,FK_HANDLING_INSTRUCTION_2 = DECODE(p_i_v_fk_handl_instruction_2,'~',NULL,NVL2(p_i_v_fk_handl_instruction_2,p_i_v_fk_handl_instruction_2,FK_HANDLING_INSTRUCTION_2))
            ,FK_HANDLING_INSTRUCTION_3 = DECODE(p_i_v_fk_handl_instruction_3,'~',NULL,NVL2(p_i_v_fk_handl_instruction_3,p_i_v_fk_handl_instruction_3,FK_HANDLING_INSTRUCTION_3))
            ,CONTAINER_LOADING_REM_1 = DECODE(p_i_v_container_loading_rem_1,'~',NULL,NVL2(p_i_v_container_loading_rem_1,p_i_v_container_loading_rem_1,CONTAINER_LOADING_REM_1))
            ,CONTAINER_LOADING_REM_2 = DECODE(p_i_v_container_loading_rem_2,'~',NULL,NVL2(p_i_v_container_loading_rem_2,p_i_v_container_loading_rem_2,CONTAINER_LOADING_REM_2))
            ,TIGHT_CONNECTION_FLAG1 = DECODE(p_i_v_tight_connection_flag1,'~',NULL,NVL2(p_i_v_tight_connection_flag1,p_i_v_tight_connection_flag1,TIGHT_CONNECTION_FLAG1))
            ,TIGHT_CONNECTION_FLAG2 = DECODE(p_i_v_tight_connection_flag2,'~',NULL,NVL2(p_i_v_tight_connection_flag2,p_i_v_tight_connection_flag2,TIGHT_CONNECTION_FLAG2))
            ,TIGHT_CONNECTION_FLAG3 = DECODE(p_i_v_tight_connection_flag3,'~',NULL,NVL2(p_i_v_tight_connection_flag3,p_i_v_tight_connection_flag3,TIGHT_CONNECTION_FLAG3))
            ,FUMIGATION_ONLY = DECODE(p_i_v_fumigation_only,'~',NULL,NVL2(p_i_v_fumigation_only,p_i_v_fumigation_only,FUMIGATION_ONLY))
            ,RESIDUE_ONLY_FLAG = DECODE(p_i_v_residue_only_flag,'~',NULL,NVL2(p_i_v_residue_only_flag,p_i_v_residue_only_flag,RESIDUE_ONLY_FLAG))
        WHERE
            FK_BOOKING_NO = p_i_v_fk_booking_no
        AND FK_BKG_SIZE_TYPE_DTL = p_i_v_fk_bkg_size_type_dtl
        AND FK_BKG_SUPPLIER = p_i_v_fk_bkg_supplier
        AND FK_BKG_EQUIPM_DTL = p_i_v_fk_bkg_equipm_dtl
        AND( ((p_i_v_lldl_flag ='L')  AND (FK_BKG_VOYAGE_ROUTING_DTL >= p_i_v_fk_bkg_voyage_rout_dtl))
        OR  ((p_i_v_lldl_flag ='D')  AND (FK_BKG_VOYAGE_ROUTING_DTL > p_i_v_fk_bkg_voyage_rout_dtl)) )
        AND DISCHARGE_STATUS NOT IN ('RB','DI');


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_err_cd:= PCE_EUT_COMMON.G_V_GE0004;
        WHEN OTHERS THEN
            p_o_v_err_cd := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
    END PRE_UPD_NEXT_POD;


    /**
    * @ PRE_POPULATE_CRANE_DESC
    * Purpose : populate Midstream Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
    PROCEDURE PRE_POPULATE_CRANE_DESC(
                                        p_i_port                 TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE
                                        ,p_i_terminal            TOS_DL_DISCHARGE_LIST.DN_TERMINAL%TYPE
                                        ,p_o_ref_cur             OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                        ,p_o_v_err_cd            OUT VARCHAR2
    ) AS
    l_v_rec_count         NUMBER; -- *1
    BEGIN
        p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /*
            *1 start
        */
        SELECT
            COUNT(1)
        INTO
            l_v_rec_count
        FROM
            TOS_CRANE_SETUP
        WHERE
            DN_PORT=p_i_port
            AND DN_TERMINAL= p_i_terminal
            AND RECORD_STATUS='A';

        IF l_v_rec_count != 0 then
        /*
            *1 end
        */
            OPEN p_o_ref_cur FOR
                SELECT
                    CRANE_CODE
                    ,CRANE_DESCRIPTION
                FROM
                    TOS_CRANE_SETUP
                WHERE
                    DN_PORT=p_i_port
                    AND DN_TERMINAL= p_i_terminal
                    AND RECORD_STATUS='A';
            return; -- *1
        end if;  -- *1

        /*
            *1 start
        */

        SELECT
            count(1)
        into
            l_v_rec_count
        FROM
            TOS_CRANE_SETUP
        WHERE
            DN_PORT= p_i_port
            AND DN_TERMINAL='*****'
            AND RECORD_STATUS='A';

        IF l_v_rec_count != 0 then
        /*
            *1 end
        */

            OPEN p_o_ref_cur FOR
                SELECT
                    CRANE_CODE
                    ,CRANE_DESCRIPTION
                FROM
                    TOS_CRANE_SETUP
                WHERE
                    DN_PORT= p_i_port
                    AND DN_TERMINAL='*****'
                    AND RECORD_STATUS='A';
            return; -- *1
        end if; -- *1

        /*
            *1 start
        */
        SELECT
            count(1)
        into
            l_v_rec_count
        FROM
            TOS_CRANE_SETUP
        WHERE
            DN_PORT= '*****'
            AND DN_TERMINAL='*****'
            AND RECORD_STATUS='A';

        IF l_v_rec_count != 0 then
        /*
            *1 end
        */

            OPEN p_o_ref_cur FOR
                SELECT
                    CRANE_CODE
                    ,CRANE_DESCRIPTION
                FROM
                    TOS_CRANE_SETUP
                WHERE
                    DN_PORT= '*****'
                    AND DN_TERMINAL='*****'
                    AND RECORD_STATUS='A';
        end if;

        if l_v_rec_count = 0 then
              OPEN p_o_ref_cur FOR
                SELECT
                    CRANE_CODE
                    ,CRANE_DESCRIPTION
                FROM
                    TOS_CRANE_SETUP
                where 1 = 2; -- no need to show any record
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END PRE_POPULATE_CRANE_DESC;
/**
    * @ PRE_POPULATE_CATEGORY_DESC
    * Purpose : populate Category Combo
    * @param  : out cursor
    * @param  : error code.
    * @see   None
    * @exception None
    */
 PROCEDURE PRE_POPULATE_CATEGORY_DESC(
                                        p_o_ref_cur             OUT PCE_ECM_REF_CUR.ECM_REF_CUR
                                        ,p_o_v_err_cd            OUT VARCHAR2
    ) AS
 BEGIN
     p_o_v_err_cd := PCE_EUT_COMMON.G_V_SUCCESS_CD;
      /*02 begin*/
      OPEN p_o_ref_cur FOR
            SELECT CATEGOY_CODE,CATEGORY_DESC FROM (
            SELECT NULL AS CATEGOY_CODE ,   'No Category'  AS CATEGORY_DESC
            FROM DUAL
            UNION ALL
            SELECT CONFIG_TYP CATEGOY_CODE, CONFIG_DESC CATEGORY_DESC
              FROM VASAPPS.VCM_CONFIG_MST
              WHERE CONFIG_CD='CATEGORY'
        ) ORDER BY CATEGOY_CODE ASC NULLS FIRST ;
    /*--02 end */ -- <<<< **********when TSI fix code insert the category to RCL Standard , please uncomment and delete code below.
    /* OPEN p_o_ref_cur FOR
            SELECT CATEGOY_CODE,CATEGORY_DESC FROM (
            SELECT NULL AS CATEGOY_CODE ,   'No Category'  AS CATEGORY_DESC
            FROM DUAL
            UNION ALL
            SELECT CONFIG_VALUE CATEGOY_CODE, CONFIG_DESC CATEGORY_DESC
              FROM VASAPPS.VCM_CONFIG_MST
              WHERE CONFIG_CD='CATEGORY'
        ) ORDER BY CATEGOY_CODE ASC NULLS FIRST ; */
 EXCEPTION WHEN OTHERS THEN
  NULL;
 END PRE_POPULATE_CATEGORY_DESC;
 
 
 PROCEDURE PRE_VAL_PLACE_DELIVERY( p_i_v_oper_cd                VARCHAR2
                                   , p_o_v_flag        OUT        VARCHAR2
                                   , p_o_v_err_cd      OUT NOCOPY VARCHAR2
    ) IS
        l_rec_count       NUMBER := 0;
        BEGIN
              p_o_v_err_cd := G_V_SUCCESS_CD;
        SELECT COUNT(1)
        INTO l_rec_count
        FROM EZLL_GBL_PORT_MASTER
        WHERE PORT_CODE = p_i_v_oper_cd
        AND   RECORD_STATUS = 'A';

        IF(l_rec_count = 0) THEN
            p_o_v_flag := 'N';
        ELSE
            p_o_v_flag := 'Y';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            P_O_V_Err_Cd := Substr(Sqlcode,1,10) || ':' || Substr(Sqlerrm,1,100);
    END PRE_VAL_PLACE_DELIVERY;

END PCE_EUT_COMMON;

/
