CREATE OR REPLACE TRIGGER PRE_TRG_ITP063_UPD_INVOYAGE
AFTER UPDATE
    ON ITP063
    FOR EACH ROW
    WHEN (
        ((NEW.INVOYAGENO <> OLD.INVOYAGENO
        OR (NEW.INVOYAGENO IS NULL AND OLD.INVOYAGENO IS NOT NULL) OR (NEW.INVOYAGENO IS NOT NULL AND OLD.INVOYAGENO IS NULL))
        AND OLD.VVSRVC <> 'AFS')
            OR
        ((NEW.VVVOYN <> OLD.VVVOYN
        OR (NEW.VVVOYN IS NULL AND OLD.VVVOYN IS NOT NULL) OR (NEW.VVVOYN IS NOT NULL AND OLD.VVVOYN IS NULL))
        AND OLD.VVSRVC = 'AFS')
    )
DECLARE
    L_V_PK_LOAD_LIST_ID       VASAPPS.TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID%TYPE;
    L_V_PK_DISCHARGE_LIST_ID  VASAPPS.TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE;
    L_V_CHANGE_DATE           DATE;
    L_V_SQL_ID                VARCHAR2(10);
    L_V_CHANGE_USER           VASAPPS.TOS_LL_LOAD_LIST.RECORD_CHANGE_USER%TYPE DEFAULT 'EZLL_TRG';
    L_V_PRG_NAME              VARCHAR2(30) DEFAULT 'PRE_TRG_ITP063_UPD_INV_PCSQ';
    SEP                       VARCHAR2(1) DEFAULT '~';
    LOAD_LIST                 VARCHAR2(5) DEFAULT ' LL';
    DISCHARGE_LIST            VARCHAR2(5) DEFAULT ' DL';

    PRAGMA AUTONOMOUS_TRANSACTION; -- Added for commit changes
BEGIN

    /* * get system time * */
    L_V_SQL_ID := 'SQL001';
    SELECT
        SYSDATE
    INTO
        L_V_CHANGE_DATE
    FROM
        DUAL;

    /* * update load list * */
    BEGIN
        /* * get the load list id * */
        L_V_SQL_ID := 'SQL002';
        SELECT
            TLL.PK_LOAD_LIST_ID
        INTO
            L_V_PK_LOAD_LIST_ID
        FROM
            VASAPPS.TOS_LL_LOAD_LIST TLL
        WHERE
            TLL.FK_SERVICE              = :OLD.VVSRVC
            AND TLL.FK_VESSEL           = :OLD.VVVESS
            AND TLL.FK_VOYAGE           = :OLD.VVVOYN
            AND TLL.FK_DIRECTION        = :OLD.VVPDIR
            AND TLL.FK_PORT_SEQUENCE_NO = :OLD.VVPCSQ
            AND TLL.DN_PORT             = :OLD.VVPCAL
            AND TLL.DN_TERMINAL         = :OLD.VVTRM1
            AND :OLD.OMMISSION_FLAG     IS NULL
            AND :OLD.VVVERS             = 99
            AND TLL.FK_VERSION          = 99;

        /* * Update new port sequence and new voyage into ez-load list header table * */
        L_V_SQL_ID := 'SQL003';
        UPDATE
            VASAPPS.TOS_LL_LOAD_LIST
        SET
            FK_VOYAGE             = :NEW.VVVOYN,
            RECORD_CHANGE_USER    = L_V_CHANGE_USER,
            RECORD_CHANGE_DATE    = L_V_CHANGE_DATE
        WHERE
            PK_LOAD_LIST_ID   = L_V_PK_LOAD_LIST_ID;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE (L_V_PRG_NAME||LOAD_LIST||SEP||L_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
            DBMS_OUTPUT.PUT_LINE(:OLD.VVSRVC
                ||SEP|| :OLD.VVVESS
                ||SEP|| :OLD.VVVOYN
                ||SEP|| :OLD.VVPDIR
                ||SEP|| :OLD.VVPCSQ
                ||SEP|| :OLD.VVPCAL
                ||SEP|| :OLD.VVTRM1);

    END; /* * end of load list update block * */

    /* * update discharge list * */
    BEGIN
        /* * get the discharge list id * */
        L_V_SQL_ID := 'SQL004';
        SELECT
            TDL.PK_DISCHARGE_LIST_ID
        INTO
            L_V_PK_DISCHARGE_LIST_ID
        FROM
            VASAPPS.TOS_DL_DISCHARGE_LIST TDL
        WHERE
            TDL.FK_SERVICE              = :OLD.VVSRVC
            AND TDL.FK_VESSEL           = :OLD.VVVESS
            AND TDL.FK_VOYAGE           = DECODE(TDL.FK_SERVICE,'AFS', :OLD.VVVOYN, :OLD.INVOYAGENO)
            AND TDL.DN_PORT             = :OLD.VVPCAL
            AND TDL.DN_TERMINAL         = :OLD.VVTRM1
            AND :OLD.OMMISSION_FLAG     IS NULL
            AND TDL.FK_DIRECTION        = :OLD.VVPDIR
            AND TDL.FK_PORT_SEQUENCE_NO = :OLD.VVPCSQ
            AND :OLD.VVVERS             = 99
            AND TDL.FK_VERSION          = 99;

        /* * Update new port sequence and new in-voyage into ez-discharge list header table * */
        L_V_SQL_ID := 'SQL005';
        UPDATE
            VASAPPS.TOS_DL_DISCHARGE_LIST
        SET
            FK_VOYAGE             = :NEW.INVOYAGENO,
            RECORD_CHANGE_USER    = L_V_CHANGE_USER,
            RECORD_CHANGE_DATE    = L_V_CHANGE_DATE
        WHERE
            PK_DISCHARGE_LIST_ID  = L_V_PK_DISCHARGE_LIST_ID;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE (L_V_PRG_NAME||DISCHARGE_LIST||SEP||L_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
            DBMS_OUTPUT.PUT_LINE(:OLD.VVSRVC
                ||SEP|| :OLD.VVVESS
                ||SEP|| :OLD.VVVOYN
                ||SEP|| :OLD.VVPDIR
                ||SEP|| :OLD.VVPCSQ
                ||SEP|| :OLD.VVPCAL
                ||SEP|| :OLD.VVTRM1
                ||SEP|| :NEW.INVOYAGENO);

    END; /* * end of discharge list update block * */

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE (L_V_PRG_NAME||L_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
        DBMS_OUTPUT.PUT_LINE(:OLD.VVSRVC
            ||SEP|| :OLD.VVVESS
            ||SEP|| :OLD.VVVOYN
            ||SEP|| :OLD.VVPDIR
            ||SEP|| :OLD.VVPCSQ
            ||SEP|| :OLD.VVPCAL
            ||SEP|| :OLD.VVTRM1
            ||SEP|| :NEW.INVOYAGENO);
END PRE_TRG_ITP063_UPD_INVOYAGE;
/* end of the trigger * */
/