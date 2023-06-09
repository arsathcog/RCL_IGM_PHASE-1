CREATE OR REPLACE TRIGGER VASAPPS.PRE_TRG_BL_SUR_ENOTICE
BEFORE UPDATE
    OF SURRENDERED
    ON IDP010
    FOR EACH ROW
    WHEN (NEW.SURRENDERED ='Y')
DECLARE

    SEP CONSTANT VARCHAR2(1) DEFAULT '~';
    L_V_ERROR VARCHAR2(4000);
    EXCEPTION_IN_SENDING_MAIL EXCEPTION;
    L_V_PARAMETER_STR VARCHAR2(4000);
    L_V_CHANGE_DATE VARCHAR2(20);

    /* commit changes */
    PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN

    L_V_CHANGE_DATE := :NEW.AYCDAT|| LPAD(:NEW.AYCTIM,4,'0')||'00';

    L_V_PARAMETER_STR := :NEW.AYBLNO
        ||SEP|| :NEW.AYCUSR
        ||SEP|| :NEW.AYISOF
        ||SEP|| L_V_CHANGE_DATE;

    vasapps.PCE_ECM_RAISE_ENOTICE.PRE_ENOTICE_BL_SURRENDER (
          :NEW.AYBLNO
        , :NEW.AYCUSR
        , :NEW.AYISOF   -- BL_SURRENDER_FSC
        , L_V_CHANGE_DATE
        , L_V_ERROR
    );

    IF L_V_ERROR <> VASAPPS.PCE_EUT_COMMON.G_V_SUCCESS_CD THEN
        RAISE EXCEPTION_IN_SENDING_MAIL;
    END IF;

    /* commit changes  */
    COMMIT;

EXCEPTION
    WHEN EXCEPTION_IN_SENDING_MAIL THEN

        vasapps.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER_STR,
            'MAIL_TRIG',
            'M',
            L_V_ERROR,
            'A',
            :NEW.AYCUSR,
            SYSDATE,
            :NEW.AYCUSR,
            SYSDATE,
            L_V_ERROR,
            NULL
       );
       COMMIT;

    WHEN OTHERS THEN
        L_V_ERROR := SQLCODE||SEP||SQLERRM;
        vasapps.PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_SYNC_ERROR_LOG(L_V_PARAMETER_STR,
            'MAIL_TRIG',
            'M',
            L_V_ERROR,
            'A',
            :NEW.AYCUSR,
            SYSDATE,
            :NEW.AYCUSR,
            SYSDATE,
            L_V_ERROR,
            NULL
       );
       COMMIT;

END PRE_TRG_BL_SUR_ENOTICE;
/


