/* ****************** Change Log ****************** *
*1: Modified by vikas, Check every booking from the
    load list and scan the booking in ezll and
    ezdl, if container missing in ezll then log that
    container and booking in missing booking logging table
    and no need to check in discharge list,otherwise check
    that booking in discahrge list als,
    as k'chatgamol, 13.11.2012

*2: Issue fix by vikas, Script checking booking which already
    canceled, as k'chatgamol, 30.11.2012
* ************************************************* */
CREATE OR REPLACE PROCEDURE PRE_GET_MISSING_BOOKINGS IS
/*
SET SERVEROUTPUT ON;
DECLARE
*/
    NO_OF_DAYS NUMBER DEFAULT 30; /* * count of days * */
    p_i_v_booking_no VARCHAR2(20) DEFAULT NULL; /* * to check any specific booking * */

    SEP CONSTANT VARCHAR2(2) DEFAULT '~';
    TOTAL_LEG_IN_BVRD NUMBER DEFAULT 0;
    TOTAL_EQUIPMENT_COUNT  NUMBER DEFAULT 0;
    EZLL_COUNT  NUMBER DEFAULT 0;
    L_V_CHANGE_DATE DATE;
    L_V_CHANGE_USER CONSTANT VASAPPS.TOS_LL_LOAD_LIST.RECORD_CHANGE_USER%TYPE DEFAULT 'EZLL_TRG';
    ACTIVE CONSTANT VARCHAR2(1) DEFAULT 'A';
    EMPTY_REPOSITIONING CONSTANT VARCHAR2(2) DEFAULT 'ER';
    FEEDER_CARGO CONSTANT VARCHAR2(2) DEFAULT 'FC';
    NORMAL CONSTANT VARCHAR2(2) DEFAULT 'N';
    C_CLOSE CONSTANT VARCHAR2(2) DEFAULT 'C';
    C_PARTIAL CONSTANT VARCHAR2(2) DEFAULT 'P';
    C_CONFIRM CONSTANT VARCHAR2(2) DEFAULT 'L';
    TRUE CONSTANT VARCHAR2(5) DEFAULT 'true';
    FALSE CONSTANT VARCHAR2(5) DEFAULT 'false';
    IS_BOOKING_LOGGED VARCHAR2(5) ;
    SQL_ID VARCHAR2(10);
    CANCELED_BOOKING CONSTANT VARCHAR2(5) DEFAULT 'CB'; -- *2

    /* * Gets the total booking count for a specific booking * */
    CURSOR CUR_BOOKINGS (p_i_v_booking_no VARCHAR2)  is
        SELECT
            COUNT(1) total_count
        FROM
            BKP001 B1,
            BKP009 B9
        WHERE
            B9.BIBKNO    = B1.BABKNO
            AND B1.BOOKING_TYPE IN (EMPTY_REPOSITIONING, FEEDER_CARGO, NORMAL)
            AND B1.BASTAT IN (C_CLOSE, C_PARTIAL, C_CONFIRM)
            AND B9.BIBKNO = p_i_v_booking_no
        GROUP BY
            B9.BIBKNO;

    /* * get the booking number and continer count from ezdl * */
    CURSOR CUR_EZDL is
        SELECT
            FK_BOOKING_NO,
            COUNT(1) TOTAL_COUNT
        FROM
            VASAPPS.TOS_DL_BOOKED_DISCHARGE
        WHERE
            RECORD_STATUS = ACTIVE
            AND FK_BOOKING_NO = NVL(P_I_V_BOOKING_NO, FK_BOOKING_NO)
            AND RECORD_ADD_DATE > SYSDATE - NO_OF_DAYS
        GROUP BY
            fk_booking_no;

    /* * get the booking number and container count from ezdl * */
    CURSOR CUR_EZLL is
        SELECT
            fk_booking_no,
            COUNT(1) total_count
        FROM
            VASAPPS.TOS_LL_BOOKED_LOADING
        WHERE
            RECORD_STATUS = ACTIVE
            AND FK_BOOKING_NO = NVL(p_i_v_booking_no, FK_BOOKING_NO)
            AND RECORD_ADD_DATE > SYSDATE - NO_OF_DAYS
        GROUP BY
            fk_booking_no;
BEGIN
    SQL_ID := 'SQL_01';
    --~DBMS_OUTPUT.PUT_LINE(SQL_ID);
    /* * get system time * */
    SELECT
        SYSDATE
    INTO
        L_V_CHANGE_DATE
    FROM
        DUAL;

    DBMS_OUTPUT.PUT_LINE('%%%%%%%%%BOOKINGS IN LOAD LIST%%%%%%%%%');

    SQL_ID := 'SQL_02';
    --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

    BEGIN
        /* * traverse for each booking of ezll * */
        FOR L_V_CUR_EZLL IN CUR_EZLL LOOP /* L1 * */

            SQL_ID := 'SQL_03';
            --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

            -- IS_BOOKING_LOGGED := FALSE; -- *2

            /* * booking not found with booking type
                empty_repositioning, feeder_cargo, normal
                then no need to check in load list and discharge
                list * */
            IS_BOOKING_LOGGED := CANCELED_BOOKING; -- *2

            /* * get the total equipment count for the ezll booking * */
            FOR L_V_CUR_BOOKINGS IN CUR_BOOKINGS(L_V_CUR_EZLL.fk_booking_no) LOOP /* L1-2 * */

                IS_BOOKING_LOGGED := FALSE; -- *2

                /* * Get routing details for a specific the booking  * */
                SQL_ID := 'SQL_04';
                --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

                SELECT
                    COUNT(1)
                INTO
                    TOTAL_LEG_IN_BVRD
                FROM
                    BOOKING_VOYAGE_ROUTING_DTL
                WHERE
                    BOOKING_NO = L_V_CUR_EZLL.FK_BOOKING_NO
                    AND ROUTING_TYPE='S'
                    AND VESSEL IS NOT NULL
                    AND VOYNO IS NOT NULL;

                /* * get the booking record count  * */
                TOTAL_EQUIPMENT_COUNT := L_V_CUR_BOOKINGS.TOTAL_COUNT*TOTAL_LEG_IN_BVRD;

                SQL_ID := 'SQL_05';
                --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

                IF ( TOTAL_EQUIPMENT_COUNT <> L_V_CUR_EZLL.total_count ) THEN
                    /* * if count is not matching then check if the container is available
                        but with different record add date * */

                    SQL_ID := 'SQL_06';
                    --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

                    SELECT
                        COUNT(1) total_count
                    INTO
                        EZLL_COUNT
                    FROM
                        VASAPPS.TOS_LL_BOOKED_LOADING
                    WHERE
                        RECORD_STATUS = ACTIVE
                        and fk_booking_no = L_V_CUR_EZLL.fk_booking_no
                    GROUP BY
                        fk_booking_no;

                    /* * check again the record count is same or not
                        if not same then log the containe number * */
                    IF (EZLL_COUNT <>  TOTAL_EQUIPMENT_COUNT) THEN

                        SQL_ID := 'SQL_07';
                        --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

                        DBMS_OUTPUT.PUT_LINE(
                            'LOAD_LIST~' ||
                            'BOOKING#: '|| L_V_CUR_EZLL.fk_booking_no||SEP||
                            'TOTAL EZLL CONT#: '||EZLL_COUNT ||SEP||
                            'TOTAL BOOKING CONT#: '||TOTAL_EQUIPMENT_COUNT ||SEP||
                            'CONT# IN EACH LEG: '||L_V_CUR_BOOKINGS.total_count ||SEP||
                            'TOTAL LEG: '||TOTAL_LEG_IN_BVRD
                        );
                        BEGIN
                            SQL_ID := 'SQL_08';
                            --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

                            INSERT INTO VASAPPS.TOS_BOOKING_RETRIGGER
                            (
                                BOOKING_NO,
                                TOTAL_EZLL_CONTAINER,
                                TOTAL_BOOKING_CONTAINER,
                                CONTAINER_IN_EACH_LEG,
                                TOTAL_LEG,
                                RECORD_STATUS,
                                RECORD_ADD_USER,
                                RECORD_ADD_DATE,
                                RECORD_CHANGE_USER,
                                RECORD_CHANGE_DATE
                            )
                            VALUES(
                                L_V_CUR_EZLL.fk_booking_no,
                                EZLL_COUNT,
                                TOTAL_EQUIPMENT_COUNT,
                                L_V_CUR_BOOKINGS.total_count,
                                TOTAL_LEG_IN_BVRD,
                                ACTIVE,
                                L_V_CHANGE_USER,
                                L_V_CHANGE_DATE,
                                L_V_CHANGE_USER,
                                L_V_CHANGE_DATE
                            );
                            /* * booking logged so no need to check in discharge list * */
                            IS_BOOKING_LOGGED := TRUE; -- *1

                        EXCEPTION
                            WHEN DUP_VAL_ON_INDEX THEN NULL;
                                DBMS_OUTPUT.PUT_LINE(SQL_ID||SEP||SQLERRM); -- *1
                                IS_BOOKING_LOGGED := TRUE; -- *1
                            WHEN OTHERS THEN NULL;
                                DBMS_OUTPUT.PUT_LINE(SQL_ID||SEP||SQLERRM); -- *1
                                IS_BOOKING_LOGGED := TRUE; -- *1
                        END;
                    END IF;

                END IF; /* * end if of count check if block * */

            END LOOP; /* L1-2 * */ /* * end loop of checking the total count in bookings * */

            /* *1 start * */
            /* * IS_BOOKING_LOGGED false means booking is correct
                in load list, and need to check in discharge list* */
            IF IS_BOOKING_LOGGED = FALSE THEN /* I1 * */

                /* * get the total equipment count for the ezll booking * */
                SQL_ID := 'SQL_09';
                --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

                BEGIN
                    SELECT
                        COUNT(1) TOTAL_COUNT
                    INTO
                        EZLL_COUNT
                    FROM
                        VASAPPS.TOS_DL_BOOKED_DISCHARGE
                    WHERE
                        RECORD_STATUS = ACTIVE
                        AND FK_BOOKING_NO = L_V_CUR_EZLL.FK_BOOKING_NO;
                EXCEPTION
                    WHEN OTHERS THEN
                        EZLL_COUNT := 0;
                END;

                /* * check if EZDL container count is different from total equipment count in bookings * */
                IF ( TOTAL_EQUIPMENT_COUNT <> EZLL_COUNT ) THEN

                    SQL_ID := 'SQL_10';
                    --~DBMS_OUTPUT.PUT_LINE(SQL_ID);

                    DBMS_OUTPUT.PUT_LINE(
                        'DISCHARGE_LIST~' ||
                        'BOOKING#: '|| L_V_CUR_EZLL.fk_booking_no||SEP||
                        'TOTAL EZLL CONT#: '||EZLL_COUNT ||SEP||
                        'TOTAL BOOKING CONT#: '||TOTAL_EQUIPMENT_COUNT ||SEP||
                        'TOTAL LEG: '||TOTAL_LEG_IN_BVRD
                    );

                    /* * log the booking number * */
                    BEGIN
                        SQL_ID := 'SQL_11';
                        --~DBMS_OUTPUT.PUT_LINE(SQL_ID);
                        INSERT INTO VASAPPS.TOS_BOOKING_RETRIGGER
                        (
                            BOOKING_NO,
                            TOTAL_EZLL_CONTAINER,
                            TOTAL_BOOKING_CONTAINER,
                            CONTAINER_IN_EACH_LEG,
                            TOTAL_LEG,
                            RECORD_STATUS,
                            RECORD_ADD_USER,
                            RECORD_ADD_DATE,
                            RECORD_CHANGE_USER,
                            RECORD_CHANGE_DATE
                        )VALUES(
                            L_V_CUR_EZLL.fk_booking_no,
                            EZLL_COUNT,
                            TOTAL_EQUIPMENT_COUNT,
                            EZLL_COUNT,
                            TOTAL_LEG_IN_BVRD,
                            ACTIVE,
                            L_V_CHANGE_USER,
                            L_V_CHANGE_DATE,
                            L_V_CHANGE_USER,
                            L_V_CHANGE_DATE
                        );

                    EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                            DBMS_OUTPUT.PUT_LINE(SQL_ID||SEP||SQLERRM); -- *1
                        WHEN OTHERS THEN
                            DBMS_OUTPUT.PUT_LINE(SQL_ID||SEP||SQLERRM); -- *1
                    END;
                END IF; /* * end if of count check if block * */

            END IF; /* I1 * */

            /* *1 end * */
        END LOOP; /* L1 * */ /* * end loop getting total bookings from the ezll * */
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQL_ID||SEP||SQLERRM); -- *1
    END;

    /* *1 start * */
    /* * no need to check discharge list explicitly * *
    DBMS_OUTPUT.PUT_LINE('%%%%%%%%%BOOKINGS IN DISCHARGE LIST%%%%%%%%%');

    BEGIN
        /* * traverse for each booking of ezll * *
        FOR L_V_CUR_EZDL IN CUR_EZDL LOOP
            /* * get the total equipment count for the ezll booking * *
            FOR L_V_CUR_BOOKINGS IN CUR_BOOKINGS(L_V_CUR_EZDL.fk_booking_no) LOOP
                /* * get routing details for the booking  * *
                SELECT
                    COUNT(1)
                INTO
                    TOTAL_LEG_IN_BVRD
                FROM
                    booking_voyage_routing_dtl
                WHERE
                    booking_no = L_V_CUR_EZDL.fk_booking_no
                    AND ROUTING_TYPE='S'
                    AND VESSEL IS NOT NULL
                    AND VOYNO IS NOT NULL;

                /* * get the booking record count  * *
                TOTAL_EQUIPMENT_COUNT := L_V_CUR_BOOKINGS.total_count*TOTAL_LEG_IN_BVRD;


                IF ( TOTAL_EQUIPMENT_COUNT <> L_V_CUR_EZDL.total_count ) then
                    /* * if count is not matching then check if the container is available
                        but with different record add date * *
                    SELECT
                        COUNT(1) total_count
                    INTO
                        EZLL_COUNT
                    FROM
                        VASAPPS.tos_dl_booked_discharge
                    WHERE
                        RECORD_STATUS = ACTIVE
                        and fk_booking_no = L_V_CUR_EZDL.fk_booking_no
                    GROUP BY
                        fk_booking_no;

                    /* * check agan the record count is same or not
                        if not same then log the containe number * *
                    IF (EZLL_COUNT <>  TOTAL_EQUIPMENT_COUNT) THEN
                        DBMS_OUTPUT.PUT_LINE(
                            'BOOKING#: '|| L_V_CUR_EZDL.fk_booking_no||SEP||
                            'TOTAL EZLL CONT#: '||EZLL_COUNT ||SEP||
                            'TOTAL BOOKING CONT#: '||TOTAL_EQUIPMENT_COUNT ||SEP||
                            'CONT# IN EACH LEG: '||L_V_CUR_BOOKINGS.total_count ||SEP||
                            'TOTAL LEG: '||TOTAL_LEG_IN_BVRD
                            );
                    END IF;
                    BEGIN
                        INSERT INTO VASAPPS.TOS_BOOKING_RETRIGGER
                        (
                            BOOKING_NO,
                            TOTAL_EZLL_CONTAINER,
                            TOTAL_BOOKING_CONTAINER,
                            CONTAINER_IN_EACH_LEG,
                            TOTAL_LEG,
                            RECORD_STATUS,
                            RECORD_ADD_USER,
                            RECORD_ADD_DATE,
                            RECORD_CHANGE_USER,
                            RECORD_CHANGE_DATE
                        )VALUES(
                            L_V_CUR_EZDL.fk_booking_no,
                            EZLL_COUNT,
                            TOTAL_EQUIPMENT_COUNT,
                            L_V_CUR_BOOKINGS.total_count,
                            TOTAL_LEG_IN_BVRD,
                            ACTIVE,
                            L_V_CHANGE_USER,
                            L_V_CHANGE_DATE,
                            L_V_CHANGE_USER,
                            L_V_CHANGE_DATE
                        );

                    EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN NULL;
                        WHEN OTHERS THEN NULL;
                    END;
                END IF; /* * end if of count check if block * *

            END LOOP; /* * end loop of checking the total count in bookings * *

        END LOOP; /* * end loop getting total bookings from the ezll * *
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;
    */

    /* *1 end * */

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQL_ID||SEP||SQLERRM); -- *1
END PRE_GET_MISSING_BOOKINGS ; /* * end of procedure * */
/