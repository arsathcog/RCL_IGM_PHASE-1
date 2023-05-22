/*
    script to read booking no# from the tos_booking_retrigger table
    and retrigger the booking, 09.07.2012
*/
CREATE OR REPLACE PROCEDURE PRE_RETRIGGER_BOOKINGS IS 

    CURSOR CUR_BOOKING IS
        SELECT
            BOOKING_NO
        FROM
            VASAPPS.TOS_BOOKING_RETRIGGER
        WHERE
            RECORD_STATUS = 'A';

    l_v_booking_status  BKP001.BASTAT%TYPE;

    C_OPEN VARCHAR2(1) DEFAULT 'O';
    C_CLOSE VARCHAR2(1) DEFAULT 'L';
    C_PARTIAL_CONFIRM VARCHAR2(1) DEFAULT 'P';
    C_CONFIRM VARCHAR2(1) DEFAULT 'C';

BEGIN

    /* * retrigger the booking * */
     FOR L_V_CUR_BOOKING IN CUR_BOOKING LOOP
        l_v_booking_status := NULL;
        /* * get the currect booking status * */
        BEGIN
            SELECT
                BASTAT
            INTO
                l_v_booking_status
            FROM
                BKP001
            WHERE
                BABKNO = L_V_CUR_BOOKING.BOOKING_NO;

            /* * retrigger logic start * */

            /* * booking is partial confirm then, then change status to O-P * */
            IF l_v_booking_status = C_PARTIAL_CONFIRM THEN
                UPDATE BKP001 SET BASTAT = C_OPEN WHERE BABKNO = L_V_CUR_BOOKING.BOOKING_NO;
                COMMIT;
                UPDATE BKP001 SET BASTAT = C_PARTIAL_CONFIRM WHERE BABKNO = L_V_CUR_BOOKING.BOOKING_NO;
                COMMIT;

            /* * booking is confirm then, then change status to O-C * */
            ELSIF l_v_booking_status = C_CONFIRM THEN
                UPDATE BKP001 SET BASTAT = C_OPEN WHERE BABKNO = L_V_CUR_BOOKING.BOOKING_NO;
                COMMIT;
                UPDATE BKP001 SET BASTAT = C_CONFIRM WHERE BABKNO = L_V_CUR_BOOKING.BOOKING_NO;
                COMMIT;

            /* * booking is confirm then, then change status to O-C-P * */
            ELSIF l_v_booking_status = C_CLOSE THEN
                UPDATE BKP001 SET BASTAT = C_OPEN WHERE BABKNO = L_V_CUR_BOOKING.BOOKING_NO;
                COMMIT;
                UPDATE BKP001 SET BASTAT = C_CONFIRM WHERE BABKNO = L_V_CUR_BOOKING.BOOKING_NO;
                COMMIT;
                UPDATE BKP001 SET BASTAT = C_CLOSE WHERE BABKNO = L_V_CUR_BOOKING.BOOKING_NO;
                COMMIT;

            END IF;
            /* * retrigger logic end * */

            DELETE FROM VASAPPS.TOS_BOOKING_RETRIGGER
            WHERE BOOKING_NO = L_V_CUR_BOOKING.BOOKING_NO;
            COMMIT;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Booking not found in BKP001: '|| L_V_CUR_BOOKING.BOOKING_NO);

            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Oracle Exceptioni in booking: '|| L_V_CUR_BOOKING.BOOKING_NO);
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END;

    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END PRE_RETRIGGER_BOOKINGS;

/
