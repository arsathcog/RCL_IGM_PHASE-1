DECLARE
BEGIN
    /* * Collect missing bookings * */
    BEGIN
        PRE_GET_MISSING_BOOKINGS;
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;

    /* * Retrigger bookings * */
    BEGIN
        PRE_RETRIGGER_BOOKINGS;
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;
END;
/