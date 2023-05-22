CREATE OR REPLACE PACKAGE BODY PKG_PORT_SEQ_UPDATE AS
    PROCEDURE PRE_UPDATE_PORT_SEQ_EZLL
    AS
        /********************************************************************************
        * Name           : PKG_PORT_SEQ_UPDATE.PRE_UPDATE_PORT_SEQ_EZLL                 *
        * Module         : EZLL                                                         *
        * Purpose        : Procedure to check the bookings in EZLL whoes port seq
                           is not synch with vessel schedule master, and update the
                           correct port sequence in the ezll/ezdl.
        * Calls          : PRE_GET_POD_PCSQ                                             *
        *                  PRE_UPDATE_PORT_SEQ_IN_BOOKING                               *
        *                  PRE_UPDATE_BVRD_BL_INFO                                      *
        *                  PRE_FIRST_SEA_LEG                                            *
        *                  PRE_GET_BL_NUMBER                                            *
        * Returns        : NONE                                                         *
        * Steps Involved :                                                              *
        * History        : None                                                         *
        * Author           Date          What                                           *
        * ---------------  ----------    ----                                           *
        * Vikas Verma     02/10/2012     1.0                                            *
        *********************************************************************************/

        /* ******************************** CHANGE LOG ********************************** *
            *1: Modified by vikas, removed port code validation from config master table,
            as k'chatgamol, 06.12.2012
        * ****************************************************************************** */

        /* * variable declaration start * */
        L_V_NUMBER_OF_DAYS NUMBER DEFAULT 0; /* * count of days * */
        L_V_CHANGE_DATE DATE;
        L_V_PORT_SEQ ITP063.VVPCSQ%TYPE;
        L_V_DIRECTION ITP063.VVPDIR%TYPE;
        L_V_VAR VARCHAR2(1);
        L_V_OUT_VOYAGE ITP063.VVVOYN%TYPE;
        L_V_CORRECT_DISCHARGE_LIST_ID VASAPPS.TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID%TYPE;
        IS_DISCHARGE_LIST_FOUND VARCHAR2(5);
        L_V_DATE VARCHAR2(8);
        L_V_TIME VARCHAR2(4);
        L_V_OUT_PORT_SEQ ITP063.VVPCSQ%TYPE;
        L_O_V_RETURN_STATUS VARCHAR2(10);
        FIRST_SEA_LEG_VOY_SEQ NUMBER DEFAULT 0;
        L_V_BL_NO IDP002.TYBLNO%TYPE;

        /* * variable declaration end  * */

        /* * cursor declaration start * */

        /* * cursor to get load list id not in sync with vessel schedule master * */

        CURSOR CUR_LOAD_LIST_ID IS
            SELECT
                PK_LOAD_LIST_ID,
                FK_SERVICE,
                FK_VESSEL,
                FK_VOYAGE,
                FK_PORT_SEQUENCE_NO,
                DN_PORT,
                DN_TERMINAL,
                FK_DIRECTION
            FROM
                VASAPPS.TOS_LL_LOAD_LIST
            WHERE
                RECORD_ADD_DATE    > SYSDATE - L_V_NUMBER_OF_DAYS
                AND LOAD_LIST_STATUS = C_OPEN
                AND FK_SERVICE NOT IN ('AFS', 'DFS')
                /* *1 start *
                AND DN_PORT  IN
                    (SELECT
                        CONFIG_CD
                    FROM
                        VASAPPS.VCM_CONFIG_MST
                    WHERE
                        CONFIG_TYP = C_PORT_SEQ_UPD
                        AND STATUS = 'A')
                * *1 end * */
                AND NOT EXISTS(
                    SELECT
                        1
                    FROM
                        ITP063
                    WHERE
                        VVVERS              = 99
                        AND VVVESS          = FK_VESSEL
                        AND VVVOYN          = FK_VOYAGE
                        AND VVSRVC          = FK_SERVICE
                        AND VVPCSQ          = FK_PORT_SEQUENCE_NO
                        AND VVPCAL          = DN_PORT
                        AND VVTRM1          = DN_TERMINAL
                        AND VVPDIR          = FK_DIRECTION
                        AND OMMISSION_FLAG IS NULL
                        AND ACT_DMY_FLG = 'A'
                );

        /* * cursor to get discharge list id not in sync with vessel schedule master * */

        CURSOR CUR_DISCHARGE_LIST_ID IS
            SELECT
                PK_DISCHARGE_LIST_ID,
                FK_SERVICE,
                FK_VESSEL,
                FK_VOYAGE,
                FK_PORT_SEQUENCE_NO,
                DN_PORT,
                DN_TERMINAL,
                FK_DIRECTION
            FROM
                VASAPPS.TOS_DL_DISCHARGE_LIST
            WHERE
                RECORD_ADD_DATE    > SYSDATE - L_V_NUMBER_OF_DAYS
                AND DISCHARGE_LIST_STATUS = C_OPEN
                /* *1 start *
                AND DN_PORT IN
                    (SELECT
                        CONFIG_CD
                    FROM
                        VASAPPS.VCM_CONFIG_MST
                    WHERE
                        CONFIG_TYP = C_PORT_SEQ_UPD
                        AND STATUS = 'A')
                * *1 end * */
                AND FK_SERVICE NOT IN ('AFS', 'DFS')
                AND NOT EXISTS(
                    SELECT
                        1
                    FROM
                        ITP063
                    WHERE
                        VVVERS              = 99
                        AND VVVESS          = FK_VESSEL
                        AND INVOYAGENO      = FK_VOYAGE
                        AND VVSRVC          = FK_SERVICE
                        AND VVPCSQ          = FK_PORT_SEQUENCE_NO
                        AND VVPCAL          = DN_PORT
                        AND VVTRM1          = DN_TERMINAL
                        AND VVPDIR          = FK_DIRECTION
                        AND OMMISSION_FLAG IS NULL
                        AND ACT_DMY_FLG = 'A'
                );

        /* * cursor to get bookings of discharge list * */

        CURSOR CUR_DL_BOOKINGS(P_I_V_DISCHARGE_LIST_ID VARCHAR2) IS
            SELECT
                FK_BOOKING_NO,
                FK_BKG_VOYAGE_ROUTING_DTL,
                DN_POL,
                DN_POL_TERMINAL,
                DN_EQUIPMENT_NO
            FROM
                VASAPPS.TOS_DL_BOOKED_DISCHARGE
            WHERE
                FK_DISCHARGE_LIST_ID = P_I_V_DISCHARGE_LIST_ID
                AND RECORD_STATUS = ACTIVE
            GROUP BY
                FK_BOOKING_NO,
                FK_BKG_VOYAGE_ROUTING_DTL,
                DN_POL,
                DN_POL_TERMINAL,
                DN_EQUIPMENT_NO;

        /* * cursor to get bookings of load list * */

        CURSOR CUR_LL_BOOKINGS(P_I_V_LOAD_LIST_ID VARCHAR2) IS
            SELECT
                FK_BOOKING_NO,
                DN_EQUIPMENT_NO,
                FK_BKG_VOYAGE_ROUTING_DTL
            FROM
                VASAPPS.TOS_LL_BOOKED_LOADING
            WHERE
                FK_LOAD_LIST_ID = P_I_V_LOAD_LIST_ID
                AND RECORD_STATUS = ACTIVE
            GROUP BY
                FK_BOOKING_NO,
                DN_EQUIPMENT_NO,
                FK_BKG_VOYAGE_ROUTING_DTL,
                DN_EQUIPMENT_NO;

        /* * cursor declaration end * */



    /* * start of anonymous block * */
    BEGIN /* beg1 */
        G_V_SQL_ID := 'SQL001';
        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
        /* * get system time * */
        SELECT
            SYSDATE,
            TO_CHAR(SYSDATE, 'YYYYMMDD'),
            TO_CHAR(SYSDATE, 'HH24MI')
        INTO
            L_V_CHANGE_DATE,
            L_V_DATE,
            L_V_TIME
        FROM
            DUAL;

        /* * get the date range from the vcm_config_mst table * */

        G_V_SQL_ID := 'SQL002';
        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

        BEGIN /* beg2 */

            SELECT
                TO_NUMBER(CONFIG_VALUE)
            INTO
                L_V_NUMBER_OF_DAYS
            FROM
                VASAPPS.VCM_CONFIG_MST
            WHERE
                CONFIG_TYP = PORT_SEQ_UPDATE
                AND CONFIG_CD = NO_OF_DAYS
                AND STATUS = ACTIVE;

        EXCEPTION /* beg2 */
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLERRM);
                DBMS_OUTPUT.PUT_LINE('No of days setting not found in VCM_CONFIG_MST table.');
                RETURN;

            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||'ORACLE EXCEPTION OCCURED');
                DBMS_OUTPUT.PUT_LINE(SQLCODE ||SEP||SQLERRM);
                RETURN;
        END; /* beg2 */
        G_V_SQL_ID := 'SQL003';
        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

        /* * get currect port sequence for load list * */
        FOR L_VAR_CUR_LOAD_LIST_ID IN CUR_LOAD_LIST_ID LOOP /* loop1 */
            BEGIN /* beg3 */
                L_V_PORT_SEQ := NULL;
                L_V_DIRECTION := NULL;
                DBMS_OUTPUT.PUT_LINE('LOAD LIST: ' ||L_VAR_CUR_LOAD_LIST_ID.PK_LOAD_LIST_ID);
                /* * get updated port sequence and direction * */

                G_V_SQL_ID := 'SQL004';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

                SELECT
                    VVPCSQ,
                    VVPDIR
                INTO
                    L_V_PORT_SEQ,
                    L_V_DIRECTION
                FROM
                    ITP063
                WHERE
                    VVVERS              = 99
                    AND VVVESS          = L_VAR_CUR_LOAD_LIST_ID.FK_VESSEL
                    AND VVVOYN          = L_VAR_CUR_LOAD_LIST_ID.FK_VOYAGE
                    AND VVSRVC          = L_VAR_CUR_LOAD_LIST_ID.FK_SERVICE
                    AND VVPCAL          = L_VAR_CUR_LOAD_LIST_ID.DN_PORT
                    AND VVTRM1          = L_VAR_CUR_LOAD_LIST_ID.DN_TERMINAL
                    AND OMMISSION_FLAG IS NULL
                    AND ACT_DMY_FLG = 'A';
    --
                DBMS_OUTPUT.PUT_LINE(
                    'LOAD LIST' || SEP ||
                    L_VAR_CUR_LOAD_LIST_ID.PK_LOAD_LIST_ID || SEP ||
                    L_V_PORT_SEQ);

                /* * update port sequence, direction into ezll header table * */

                G_V_SQL_ID := 'SQL005';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                DBMS_OUTPUT.PUT_LINE('updating load list');

                UPDATE
                    VASAPPS.TOS_LL_LOAD_LIST
                SET
                    FK_PORT_SEQUENCE_NO = L_V_PORT_SEQ,
                    FK_DIRECTION = L_V_DIRECTION,
                    RECORD_CHANGE_DATE = L_V_CHANGE_DATE,
                    RECORD_CHANGE_USER = C_USER
                WHERE
                    PK_LOAD_LIST_ID = L_VAR_CUR_LOAD_LIST_ID.PK_LOAD_LIST_ID
                    AND EXISTS (
                        SELECT
                            1
                        FROM
                            VASAPPS.TOS_LL_BOOKED_LOADING
                        WHERE
                            FK_LOAD_LIST_ID = L_VAR_CUR_LOAD_LIST_ID.pk_load_list_id
                            AND RECORD_STATUS = ACTIVE
                    );

                /* * update port seq and direction into bookings * */
                G_V_SQL_ID := 'SQL006';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                DBMS_OUTPUT.PUT_LINE(L_V_DIRECTION
                    ||sep||L_V_PORT_SEQ
                    ||sep||L_VAR_CUR_LOAD_LIST_ID.FK_SERVICE
                    ||sep||L_VAR_CUR_LOAD_LIST_ID.FK_VESSEL
                    ||sep||L_VAR_CUR_LOAD_LIST_ID.FK_VOYAGE
                    ||sep||L_VAR_CUR_LOAD_LIST_ID.DN_PORT
                    ||sep||L_VAR_CUR_LOAD_LIST_ID.DN_TERMINAL
                );

                UPDATE
                    BOOKING_VOYAGE_ROUTING_DTL
                SET
                    DIRECTION= L_V_DIRECTION,
                    POL_PCSQ = L_V_PORT_SEQ,
                    RECORD_CHANGE_USER = C_USER,
                    RECORD_CHANGE_DATE = L_V_DATE,
                    RECORD_CHANGE_TIME = L_V_TIME
                WHERE
                    SERVICE = L_VAR_CUR_LOAD_LIST_ID.FK_SERVICE AND
                    VESSEL = L_VAR_CUR_LOAD_LIST_ID.FK_VESSEL AND
                    VOYNO = L_VAR_CUR_LOAD_LIST_ID.FK_VOYAGE AND
                    LOAD_PORT = L_VAR_CUR_LOAD_LIST_ID.DN_PORT AND
                    FROM_TERMINAL = L_VAR_CUR_LOAD_LIST_ID.DN_TERMINAL;

                /* * update port sequence and direction in BL (IDP005) * */
                BEGIN /* beg3-1 */
                    /* * update port seq and direction into BL * */
                    G_V_SQL_ID := 'SQL006-1';
                    DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                    UPDATE
                        IDP005
                    SET
                        DIRECTION = L_V_DIRECTION,
                        POL_PCSQ = L_V_PORT_SEQ,
                        SYCUSR = C_USER,
                        SYCDAT = L_V_DATE,
                        SYCTIM = L_V_TIME
                    WHERE
                        SERVICE = L_VAR_CUR_LOAD_LIST_ID.FK_SERVICE AND
                        VESSEL = L_VAR_CUR_LOAD_LIST_ID.FK_VESSEL AND
                        VOYAGE = L_VAR_CUR_LOAD_LIST_ID.FK_VOYAGE AND
                        LOAD_PORT = L_VAR_CUR_LOAD_LIST_ID.DN_PORT AND
                        FROM_TERMINAL = L_VAR_CUR_LOAD_LIST_ID.DN_TERMINAL;

                EXCEPTION /* beg3-1 */
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                        DBMS_OUTPUT.PUT_LINE('ERROR IN UPDATING BL INFO FOR THIS VSL/VOYAGE:=> ');
                        DBMS_OUTPUT.PUT_LINE(L_VAR_CUR_LOAD_LIST_ID.FK_VESSEL
                            ||SEP|| L_VAR_CUR_LOAD_LIST_ID.FK_VOYAGE
                            ||SEP|| L_VAR_CUR_LOAD_LIST_ID.FK_SERVICE
                            ||SEP|| L_VAR_CUR_LOAD_LIST_ID.DN_PORT
                            ||SEP|| L_VAR_CUR_LOAD_LIST_ID.DN_TERMINAL
                            ||SEP|| L_VAR_CUR_LOAD_LIST_ID.PK_LOAD_LIST_ID);
                END; /* beg3-1 */

                /* * update bookings (BKP001) * */
                G_V_SQL_ID := 'SQL006-2';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                BEGIN /* beg3-2 */

                    /* * loop to every booking in the load list * */
                    FOR L_V_CUR_LL_BOOKINGS IN CUR_LL_BOOKINGS(L_VAR_CUR_LOAD_LIST_ID.PK_LOAD_LIST_ID) LOOP /* loop2 */
                        dbms_output.put_line('updating bkp001');
                        dbms_output.put_line(
                            L_V_CUR_LL_BOOKINGS.FK_BOOKING_NO
                            ||sep||L_VAR_CUR_LOAD_LIST_ID.DN_PORT);

                        /* * update bookings * */
                        UPDATE
                            BKP001
                        SET
                            POL_PCSQ = L_V_PORT_SEQ
                        WHERE
                            BABKNO = L_V_CUR_LL_BOOKINGS.FK_BOOKING_NO
                            AND BAPOL =  L_VAR_CUR_LOAD_LIST_ID.DN_PORT;

                        /* * get first sea leg * */
                        PRE_FIRST_SEA_LEG(
                            L_V_CUR_LL_BOOKINGS.FK_BOOKING_NO,
                            FIRST_SEA_LEG_VOY_SEQ
                        );

                        /* * first sea leg need to update pol pcsq to idp010 table * */
                        IF FIRST_SEA_LEG_VOY_SEQ = L_V_CUR_LL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL THEN /* if7 * */

                            L_V_BL_NO := NULL;
                            IF L_V_CUR_LL_BOOKINGS.DN_EQUIPMENT_NO IS NOT NULL THEN /* if7-1 * */

                                /* get BL number for the booking and container number */
                                PRE_GET_BL_NUMBER(
                                    L_V_CUR_LL_BOOKINGS.FK_BOOKING_NO,
                                    L_V_CUR_LL_BOOKINGS.DN_EQUIPMENT_NO,
                                    L_V_BL_NO
                                );

                                /* * BL number found for booking# and container# * */
                                IF L_V_BL_NO IS NOT NULL THEN /* if7-2 * */
                                        DBMS_OUTPUT.PUT_LINE('IDP010 CHANGE USER NAME: '|| C_USER);
                                    /* * update port seq in IDP010 table * */
                                    UPDATE
                                        IDP010
                                    SET
                                        AYPSEQ = L_V_PORT_SEQ
                                        -- ,
                                        -- AYCUSR = C_USER,
                                        -- AYCDAT = L_V_DATE,
                                        -- AYCTIM = L_V_TIME
                                    WHERE
                                        AYBLNO = L_V_BL_NO;

                                END IF; /* if7-2 * */

                            END IF; /* if7-1 * */

                        END IF; /* if7 * */

                    END LOOP; /* loop2 */

                EXCEPTION /* beg3-2 */
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('IGNORE'||SEP||G_V_SQL_ID||SEP||SQLCODE||SQLERRM);
                END ; /* beg3-2 */

            EXCEPTION /* beg3 */
                WHEN OTHERS  THEN
                    DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                    DBMS_OUTPUT.PUT_LINE('LOAD LIST CAN NOT UPDATED FOR THIS VSL/VOYAGE:=> ');
                    DBMS_OUTPUT.PUT_LINE(L_VAR_CUR_LOAD_LIST_ID.FK_VESSEL
                        ||SEP|| L_VAR_CUR_LOAD_LIST_ID.FK_VOYAGE
                        ||SEP|| L_VAR_CUR_LOAD_LIST_ID.FK_SERVICE
                        ||SEP|| L_VAR_CUR_LOAD_LIST_ID.DN_PORT
                        ||SEP|| L_VAR_CUR_LOAD_LIST_ID.DN_TERMINAL
                        ||SEP|| L_VAR_CUR_LOAD_LIST_ID.PK_LOAD_LIST_ID);

            END; /* beg3 */

        END LOOP; /* loop1 */
        COMMIT;
        /* * end of load list operations * */

        /* * get currect port sequence for discharge list * */
        G_V_SQL_ID := 'SQL003-1';
        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
        FOR L_VAR_CUR_DISCHARGE_LIST_ID IN CUR_DISCHARGE_LIST_ID LOOP /* loop2 */

            DBMS_OUTPUT.PUT_LINE('DISCHARGE LIST: ' ||L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID);

            BEGIN /* beg4 */
                L_V_PORT_SEQ := NULL;
                L_V_DIRECTION := NULL;
                L_V_OUT_VOYAGE := NULL;

                /* get correct port seq and direction from the itp063 table.*/

                G_V_SQL_ID := 'SQL007';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

                SELECT
                    VVPCSQ,
                    VVPDIR,
                    VVVOYN
                INTO
                    L_V_PORT_SEQ,
                    L_V_DIRECTION,
                    L_V_OUT_VOYAGE
                FROM
                    ITP063
                WHERE
                    VVVERS = 99
                    AND VVVESS = L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                    AND INVOYAGENO = L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                    AND VVSRVC = L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                    AND VVPCAL = L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                    AND VVTRM1 = L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                    -- AND VVPDIR = L_VAR_CUR_DISCHARGE_LIST_ID.FK_DIRECTION
                    -- AND VVPCSQ = L_VAR_CUR_DISCHARGE_LIST_ID.FK_PORT_SEQUENCE_NO
                    AND OMMISSION_FLAG IS NULL
                    AND ACT_DMY_FLG = 'A'
                    AND VVFORL IN ('F', 'O');

                /* * reset local variable * */

                IS_DISCHARGE_LIST_FOUND := C_FALSE;

                /* * check the record exists in discharge list with correct port sequence and direction or not * */

                BEGIN /* beg4-1 */

                    G_V_SQL_ID := 'SQL008';
                    DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

                    SELECT
                        PK_DISCHARGE_LIST_ID,
                        C_TRUE
                    INTO
                        L_V_CORRECT_DISCHARGE_LIST_ID,
                        IS_DISCHARGE_LIST_FOUND
                    FROM
                        VASAPPS.TOS_DL_DISCHARGE_LIST
                    WHERE
                        FK_SERVICE = L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                        AND FK_VESSEL = L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                        AND FK_VOYAGE = L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                        AND FK_DIRECTION = L_V_DIRECTION -- correct value direction from ITP063 table.
                        AND FK_PORT_SEQUENCE_NO = L_V_PORT_SEQ   -- correct value port seq from ITP063 table.
                        AND DN_PORT = L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                        AND DN_TERMINAL = L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                        AND RECORD_STATUS = ACTIVE;
                EXCEPTION /* beg4-1 */
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('IGNORE'||SEP||G_V_SQL_ID||SEP||SQLCODE||SQLERRM);
                END ; /* beg4-1 */

                /* * ez discharge list not found for correct port seq, and direction * */
                G_V_SQL_ID := 'SQL008-1';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                DBMS_OUTPUT.PUT_LINE('IS_DISCHARGE_LIST_FOUND: '||IS_DISCHARGE_LIST_FOUND);

                IF IS_DISCHARGE_LIST_FOUND = C_TRUE THEN -- if1
                    /* * get all the bookings of old discharge list and move them into
                        new discharge list id * */

                    FOR L_V_CUR_DL_BOOKINGS IN CUR_DL_BOOKINGS(L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID) LOOP /* loop3 */
                        G_V_SQL_ID := 'SQL008-2';
                        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                        BEGIN /* beg4-2 */
                               dbms_output.put_line('TOS_DL_BOOKED_DISCHARGE');
                            UPDATE
                                VASAPPS.TOS_DL_BOOKED_DISCHARGE
                            SET
                                FK_DISCHARGE_LIST_ID = L_V_CORRECT_DISCHARGE_LIST_ID,
                                RECORD_CHANGE_USER = C_USER,
                                RECORD_CHANGE_DATE = L_V_CHANGE_DATE
                            WHERE
                                FK_BOOKING_NO = L_V_CUR_DL_BOOKINGS.FK_BOOKING_NO
                                AND FK_DISCHARGE_LIST_ID = L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID
                                AND FK_BKG_VOYAGE_ROUTING_DTL = L_V_CUR_DL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL
                                AND RECORD_STATUS = ACTIVE;

                        EXCEPTION /* beg4-2 */
                            WHEN OTHERS THEN
                                DBMS_OUTPUT.PUT_LINE('IGNORE'||SEP||G_V_SQL_ID||SEP||SQLCODE||SQLERRM);
                        END; /* beg4-2 */
                        G_V_SQL_ID := 'SQL008-3';
                        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                        BEGIN /* beg4-3 */

                            PRE_UPDATE_PORT_SEQ_IN_BOOKING(
                                L_V_CUR_DL_BOOKINGS.FK_BOOKING_NO
                                , L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                , L_V_CUR_DL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL
                                , L_V_PORT_SEQ
                            );

                        EXCEPTION /* beg4-3 */
                            WHEN OTHERS THEN
                                DBMS_OUTPUT.PUT_LINE('IGNORE'||SEP||G_V_SQL_ID||SEP||SQLCODE||SQLERRM);
                        END; /* beg4-3 */
                        G_V_SQL_ID := 'SQL008-4';
                        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                        BEGIN /* beg4-4 */
                            /* * get pod port seq * */
                            PRE_GET_POD_PCSQ(
                                L_V_CUR_DL_BOOKINGS.FK_BOOKING_NO,
                                L_V_CUR_DL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL,
                                L_V_OUT_VOYAGE,
                                L_V_PORT_SEQ,
                                L_V_OUT_PORT_SEQ
                            );

                            /* * pod pcsq not found update another discharge list * */
                            IF (L_V_OUT_PORT_SEQ IS NULL ) THEN -- if1-1
                                RAISE POD_PCSQ_NOT_FOUND_EXCEP;
                            END IF; -- if1-1
                            G_V_SQL_ID := 'SQL008-5';
                            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                            IF L_V_OUT_PORT_SEQ IS NOT NULL THEN -- if2
                                /* * update that port seq, and direction in ezdl detail table * */

                                BEGIN /* beg4-4-1 */

                                    /* * update into bvrd table. * */

                                    G_V_SQL_ID := 'SQL010';
                                    DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                                    /* * update booking voyage routing detail and bl information * */
                                    PRE_UPDATE_BVRD_BL_INFO(
                                        L_V_DIRECTION
                                        , L_V_PORT_SEQ
                                        , L_V_OUT_PORT_SEQ
                                        , L_V_DATE
                                        , L_V_TIME
                                        , L_V_CUR_DL_BOOKINGS.FK_BOOKING_NO
                                        , L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                                        , L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                                        , L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                                        , L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                        , L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                                        , L_V_CUR_DL_BOOKINGS.DN_POL
                                        , L_V_CUR_DL_BOOKINGS.DN_POL_TERMINAL
                                        , L_V_CUR_DL_BOOKINGS.DN_EQUIPMENT_NO
                                        , L_V_CUR_DL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL
                                    );

                                EXCEPTION /* beg4-4-1 */
                                    WHEN OTHERS THEN
                                        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                                        DBMS_OUTPUT.PUT_LINE('DISCHARGE LIST CAN NOT UPDATED FOR THIS VSL/VOYAGE:=> ');
                                        DBMS_OUTPUT.PUT_LINE(L_V_CUR_DL_BOOKINGS.FK_BOOKING_NO
                                            ||SEP|| L_V_CUR_DL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL
                                            ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                                            ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                                            ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                                            ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                            ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                                            ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID);
                                END; /* beg4-4-1 */

                            END IF; -- if2
                        EXCEPTION /* beg4-4 */
                            WHEN POD_PCSQ_NOT_FOUND_EXCEP THEN
                                /* * no need to cancel update operation on header table */
                                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                                DBMS_OUTPUT.PUT_LINE('POD_PCSQ NOT FOUND FOR VSL/VOYAGE:=> ');
                                DBMS_OUTPUT.PUT_LINE(L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID);

                            WHEN OTHERS THEN
                                /* * no need to cancel update operation on header table */
                                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                                DBMS_OUTPUT.PUT_LINE('POD_PCSQ NOT FOUND FOR VSL/VOYAGE:=> ');
                                DBMS_OUTPUT.PUT_LINE(L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID);
                        END; /* beg4-4 */

                    END LOOP; /* loop3 */

                    G_V_SQL_ID := 'SQL010-1';
                    /* * update booking count in old discharge list header table * */
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
                        L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID,
                        C_DISCHARGE_LIST,
                        L_O_V_RETURN_STATUS
                    );

                    G_V_SQL_ID := 'SQL010-2';
                    /* * update booking count in new discharge list header table * */
                    PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_STATUS_COUNT(
                        L_V_CORRECT_DISCHARGE_LIST_ID,
                        C_DISCHARGE_LIST,
                        L_O_V_RETURN_STATUS
                    );

                END IF; -- if1

                /* * correct discharge list not found then update correct port seq and dir in the
                    header table. * */

                IF IS_DISCHARGE_LIST_FOUND = C_FALSE THEN --if1-a
                    /* * update port seq, and direction into the discharge list header table * */
                    BEGIN /* beg5 */

                        G_V_SQL_ID := 'SQL011';
                        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

                        UPDATE
                            VASAPPS.TOS_DL_DISCHARGE_LIST
                        SET
                            FK_PORT_SEQUENCE_NO = L_V_PORT_SEQ,
                            FK_DIRECTION = L_V_DIRECTION,
                            RECORD_CHANGE_USER = C_USER,
                            RECORD_CHANGE_DATE = L_V_CHANGE_DATE
                        WHERE
                            RECORD_STATUS = ACTIVE
                            AND PK_DISCHARGE_LIST_ID = L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID
                            AND EXISTS (
                                SELECT
                                    1
                                FROM
                                    VASAPPS.TOS_DL_BOOKED_DISCHARGE
                                WHERE
                                    FK_DISCHARGE_LIST_ID = L_VAR_CUR_DISCHARGE_LIST_ID.pk_discharge_list_id
                                    AND RECORD_STATUS = ACTIVE);

                        /* * update correct port seq, direction in booking table. * */

                    EXCEPTION /* beg5 */
                        WHEN OTHERS THEN
                            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                            DBMS_OUTPUT.PUT_LINE('DISCHARGE LIST CAN NOT UPDATED FOR THIS VSL/VOYAGE :=> ');
                            DBMS_OUTPUT.PUT_LINE(L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                                ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                                ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                                ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                                ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID);
                    END; /* beg5 */
                    G_V_SQL_ID := 'SQL011-A';
                    DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

                    FOR L_V_CUR_DL_BOOKINGS IN CUR_DL_BOOKINGS(L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID)
                    LOOP /* loop4 */
                        /* * update bkp001 table * */
                        G_V_SQL_ID := 'SQL011-1';
                        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                        BEGIN /* beg6 */

                            PRE_UPDATE_PORT_SEQ_IN_BOOKING(
                                L_V_CUR_DL_BOOKINGS.FK_BOOKING_NO
                                , L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                , L_V_CUR_DL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL
                                , L_V_PORT_SEQ
                            );

                        EXCEPTION /* beg6 */
                            WHEN OTHERS THEN
                                DBMS_OUTPUT.PUT_LINE('IGNORE'||SEP||G_V_SQL_ID||SEP||SQLCODE||SQLERRM);
                        END; /* beg6 */

                        BEGIN /* beg7 */
                            G_V_SQL_ID := 'SQL012';
                            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                            /* * get pod port seq * */
                            PRE_GET_POD_PCSQ(
                                L_V_CUR_DL_BOOKINGS.FK_BOOKING_NO,
                                L_V_CUR_DL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL,
                                L_V_OUT_VOYAGE,
                                L_V_PORT_SEQ,
                                L_V_OUT_PORT_SEQ
                            );
                            /* * pod pcsq not found update another discharge list * */
                            IF (L_V_OUT_PORT_SEQ IS NULL ) THEN -- if1-1
                                RAISE POD_PCSQ_NOT_FOUND_EXCEP;
                            END IF; -- if1-1

                            G_V_SQL_ID := 'SQL012-1';
                            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                            DBMS_OUTPUT.PUT_LINE('POD_PCSQ: ' || L_V_OUT_PORT_SEQ);

                            /* * update booking voyage routing detail and bl information * */
                            PRE_UPDATE_BVRD_BL_INFO(
                                L_V_DIRECTION
                                , L_V_PORT_SEQ
                                , L_V_OUT_PORT_SEQ
                                , L_V_DATE
                                , L_V_TIME
                                , L_V_CUR_DL_BOOKINGS.FK_BOOKING_NO
                                , L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                                , L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                                , L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                                , L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                , L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                                , L_V_CUR_DL_BOOKINGS.DN_POL
                                , L_V_CUR_DL_BOOKINGS.DN_POL_TERMINAL
                                , L_V_CUR_DL_BOOKINGS.DN_EQUIPMENT_NO
                                , L_V_CUR_DL_BOOKINGS.FK_BKG_VOYAGE_ROUTING_DTL
                            );

                        EXCEPTION /* beg7 */
                            WHEN POD_PCSQ_NOT_FOUND_EXCEP THEN
                                /* * no need to cancel update operation on header table */
                                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                                DBMS_OUTPUT.PUT_LINE('POD_PCSQ NOT FOUND FOR VSL/VOYAGE:=> ');
                                DBMS_OUTPUT.PUT_LINE(L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID);

                            WHEN OTHERS THEN
                                /* * no need to cancel update operation on header table */
                                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                                DBMS_OUTPUT.PUT_LINE('POD_PCSQ NOT FOUND FOR VSL/VOYAGE:=> ');
                                DBMS_OUTPUT.PUT_LINE(L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                                    ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID);

                        END; /* beg7 */
                    END LOOP; /* loop4 */


                END IF; --if1-a

            EXCEPTION /* beg4 */
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);
                    DBMS_OUTPUT.PUT_LINE('DISCHARGE LIST CAN NOT UPDATED FOR VSL/VOYAGE:=> ');
                    DBMS_OUTPUT.PUT_LINE(L_VAR_CUR_DISCHARGE_LIST_ID.FK_VESSEL
                        ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_VOYAGE
                        ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.FK_SERVICE
                        ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_PORT
                        ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.DN_TERMINAL
                        ||SEP|| L_VAR_CUR_DISCHARGE_LIST_ID.PK_DISCHARGE_LIST_ID);
            END; /* beg4 */

        END LOOP; /* loop2 */
        COMMIT;

        /* * end of discharge list operation * */

    EXCEPTION /* beg1 */
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID||SEP||SQLCODE||SEP||SQLERRM);

     END PRE_UPDATE_PORT_SEQ_EZLL; /* beg1 */

     /* * LOGIC TO GET POD_PCSQ * */
    PROCEDURE PRE_GET_POD_PCSQ(
        P_I_V_BOOKING             VARCHAR2,
        P_I_V_VOYAGE_SEQ          VARCHAR2,
        P_I_V_OUTVOYAGE           VARCHAR2,
        P_I_V_ACT_PORT_SEQ        VARCHAR2,
        P_O_V_POD_PORT_SEQ        OUT VARCHAR2
    ) AS

        CURSOR CUR_BVRD_DETAIL IS
            SELECT
                SERVICE,
                VESSEL,
                VOYNO,
                LOAD_PORT,
                FROM_TERMINAL
            FROM
                BOOKING_VOYAGE_ROUTING_DTL
            WHERE
                BOOKING_NO = P_I_V_BOOKING
                AND VOYAGE_SEQNO = P_I_V_VOYAGE_SEQ;

    BEGIN -- beg1

        FOR L_V_CUR_BVRD_DETAIL IN CUR_BVRD_DETAIL LOOP --loop1

            IF P_I_V_OUTVOYAGE <> L_V_CUR_BVRD_DETAIL.VOYNO THEN -- if1

                /* * get pod pcsq from itp063 table * */
                SELECT
                    VVPCSQ
                INTO
                    P_O_V_POD_PORT_SEQ
                FROM
                    ITP063
                WHERE
                    VVVERS              = 99
                    AND VVVESS          = L_V_CUR_BVRD_DETAIL.VESSEL
                    AND VVVOYN          = L_V_CUR_BVRD_DETAIL.VOYNO
                    AND VVSRVC          = L_V_CUR_BVRD_DETAIL.SERVICE
                    AND VVPCAL          = L_V_CUR_BVRD_DETAIL.LOAD_PORT
                    AND VVTRM1          = L_V_CUR_BVRD_DETAIL.FROM_TERMINAL
                    AND OMMISSION_FLAG IS NULL
                    AND (
                        (TURN_PORT_FLAG = 'Y' AND VVFORL IS NOT NULL)
                        OR
                        (TURN_PORT_FLAG <> 'Y' AND VVFORL IS NULL)
                        )
                    AND ROWNUM = 1;

            ELSE -- if1

                P_O_V_POD_PORT_SEQ :=  P_I_V_ACT_PORT_SEQ;

            END IF; -- if1
        END LOOP; --loop1

    EXCEPTION -- beg1
        WHEN OTHERS THEN -- beg1
            P_O_V_POD_PORT_SEQ := NULL;
    END PRE_GET_POD_PCSQ;  -- beg1

    /*
        This procedure is used to udpate port sequence for in bookings
        for discharge list *
    */
    PROCEDURE PRE_UPDATE_PORT_SEQ_IN_BOOKING (
        P_I_V_BOOKING_NO     VASAPPS.TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE,
        P_I_V_DISCHARGE_PORT VASAPPS.TOS_DL_DISCHARGE_LIST.DN_PORT%TYPE,
        P_I_V_VOY_SEQ_NO     VASAPPS.TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO%TYPE,
        P_I_V_PORT_SEQ       VASAPPS.TOS_DL_DISCHARGE_LIST.FK_PORT_SEQUENCE_NO%TYPE
    ) AS

        C_RAIL VARCHAR2(1) DEFAULT 'R';
        C_TRUCK VARCHAR2(1) DEFAULT 'T';
        FIRST_SEA_LEG_VOY_SEQ NUMBER DEFAULT 0;
        G_V_SQL_ID VARCHAR2(10);

    BEGIN
        DBMS_OUTPUT.PUT_LINE(P_I_V_BOOKING_NO
            ||SEP|| P_I_V_DISCHARGE_PORT
            ||SEP|| P_I_V_VOY_SEQ_NO
            ||SEP|| P_I_V_PORT_SEQ);
        /* * get the voyage seq number of the first sea leg * */
        G_V_SQL_ID := 'SQLP01';
        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

        PRE_FIRST_SEA_LEG(
            P_I_V_BOOKING_NO,
            FIRST_SEA_LEG_VOY_SEQ
        );

        /*
        SELECT
            VOYAGE_SEQNO
        INTO
            FIRST_SEA_LEG_VOY_SEQ
        FROM
            (SELECT
                    ROW_NUMBER() OVER (ORDER BY VOYAGE_SEQNO) R,
                    VOYAGE_SEQNO
            FROM
                BOOKING_VOYAGE_ROUTING_DTL B
            WHERE
                BOOKING_NO = P_I_V_BOOKING_NO
                AND ROUTING_TYPE = 'S'
                AND TRANSPORT_MODE NOT IN (C_RAIL, C_TRUCK)
                AND VESSEL      IS NOT NULL
                AND VOYNO       IS NOT NULL
            )
        WHERE R = 1;
        */

        /* * if first sea leg * */
        G_V_SQL_ID := 'SQLP02';
        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
        DBMS_OUTPUT.PUT_LINE(FIRST_SEA_LEG_VOY_SEQ);

        IF P_I_V_VOY_SEQ_NO = FIRST_SEA_LEG_VOY_SEQ THEN
            /* * Check if BAPOD = discharge _port then update
                new port sequence of pod to pod_pcsq * */

            /* * update bookings * */
            G_V_SQL_ID := 'SQLP03';
            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
            UPDATE
                BKP001
            SET
                POD_PCSQ = P_I_V_PORT_SEQ
            WHERE
                BABKNO = P_I_V_BOOKING_NO
                AND BAPOD =  P_I_V_DISCHARGE_PORT;

            /* * check if record not updated means BAPOD is not equals to discharge port * */
            NO_OF_UPD_ROW := SQL%ROWCOUNT;
            G_V_SQL_ID := 'SQLP04';
            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
            DBMS_OUTPUT.PUT_LINE('NO_OF_UPD_ROW: ' || NO_OF_UPD_ROW);

            IF NO_OF_UPD_ROW = 0 THEN
                /* * update new port sequence of pod to pot_pcsq * */
                G_V_SQL_ID := 'SQLP05';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                UPDATE
                    BKP001
                SET
                    POT_PCSQ = P_I_V_PORT_SEQ
                WHERE
                    BABKNO = P_I_V_BOOKING_NO;
            END IF;
        ELSE
            /* * update bookings * */
            G_V_SQL_ID := 'SQLP06';
            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

            UPDATE
                BKP001
            SET
                POD_PCSQ = P_I_V_PORT_SEQ
            WHERE
                BABKNO = P_I_V_BOOKING_NO
                AND BAPOD =  P_I_V_DISCHARGE_PORT;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('PRE_UPDATE_PORT_SEQ_BOOKING');
            DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID ||'~'|| SQLCODE||'~'||SQLERRM);
    END PRE_UPDATE_PORT_SEQ_IN_BOOKING;

    /* * update booking voyage routing detail and bl information * */
    PROCEDURE PRE_UPDATE_BVRD_BL_INFO (
        P_I_V_U_DIRECTION          VARCHAR2,
        P_I_V_U_PORT_SEQ           VARCHAR2,
        P_I_V_U_OUT_PORT_SEQ       VARCHAR2,
        P_I_V_U_DATE               VARCHAR2,
        P_I_V_U_TIME               VARCHAR2,
        P_I_V_BOOKING_NO           VARCHAR2,
        P_I_V_SERVICE              VARCHAR2,
        P_I_V_VESSEL               VARCHAR2,
        P_I_V_VOYAGE               VARCHAR2,
        P_I_V_PORT                 VARCHAR2,
        P_I_V_TERMINAL             VARCHAR2,
        P_I_V_POL                  VARCHAR2,
        P_I_V_POL_TERMINAL         VARCHAR2,
        P_I_V_EQUIPMENT_NO         VARCHAR2,
        P_I_V_VOYAGE_SEQ           VARCHAR2
    )
    AS
        L_V_BL_NUMBER IDP002.TYBLNO%TYPE;
    BEGIN /* beg1 */
        DBMS_OUTPUT.PUT_LINE(P_I_V_U_DIRECTION
            ||SEP|| P_I_V_U_PORT_SEQ
            ||SEP|| P_I_V_U_OUT_PORT_SEQ
            ||SEP|| P_I_V_U_DATE
            ||SEP|| P_I_V_U_TIME
            ||SEP|| P_I_V_BOOKING_NO
            ||SEP|| P_I_V_SERVICE
            ||SEP|| P_I_V_VESSEL
            ||SEP|| P_I_V_VOYAGE
            ||SEP|| P_I_V_PORT
            ||SEP|| P_I_V_TERMINAL
            ||SEP|| P_I_V_POL
            ||SEP|| P_I_V_POL_TERMINAL
            ||SEP|| P_I_V_EQUIPMENT_NO
            ||SEP|| P_I_V_VOYAGE_SEQ);
        BEGIN /* beg1-1 */
            dbms_output.put_line('BOOKING_VOYAGE_ROUTING_DTL');
            UPDATE
                BOOKING_VOYAGE_ROUTING_DTL
            SET
                ACT_PORT_DIRECTION= P_I_V_U_DIRECTION,
                ACT_PORT_SEQUENCE = P_I_V_U_PORT_SEQ,
                POD_PCSQ = P_I_V_U_OUT_PORT_SEQ,
                RECORD_CHANGE_USER = C_USER,
                RECORD_CHANGE_DATE = P_I_V_U_DATE,
                RECORD_CHANGE_TIME = P_I_V_U_TIME
            WHERE
                BOOKING_NO = P_I_V_BOOKING_NO
                AND ACT_SERVICE_CODE = P_I_V_SERVICE
                AND ACT_VESSEL_CODE = P_I_V_VESSEL
                AND ACT_VOYAGE_NUMBER = P_I_V_VOYAGE
                AND DISCHARGE_PORT = P_I_V_PORT
                AND TO_TERMINAL = P_I_V_TERMINAL
                and LOAD_PORT = P_I_V_POL
                AND FROM_TERMINAL = P_I_V_POL_TERMINAL;

        EXCEPTION /* beg1-1 */
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('IGNORE'||SEP||G_V_SQL_ID||SEP||SQLCODE||SQLERRM);
        END; /* beg1-1 */

        G_V_SQL_ID := 'SQLA01';
        DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
        DBMS_OUTPUT.PUT_LINE('P_I_V_EQUIPMENT_NO: '||P_I_V_EQUIPMENT_NO);

        /* * update port sequence and direction in BL (IDP005) * */
        IF P_I_V_EQUIPMENT_NO IS NOT NULL THEN /* if1 */
            BEGIN /* beg1-2 */

                G_V_SQL_ID := 'SQLA02';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);
                /* * get bl number for the boooking * */
                PRE_GET_BL_NUMBER(
                    P_I_V_BOOKING_NO,
                    P_I_V_EQUIPMENT_NO,
                    L_V_BL_NUMBER
                );

                IF L_V_BL_NUMBER IS NULL THEN
                    RAISE NO_DATA_FOUND ;
                END IF;

                /*
                SELECT
                    I02.TYBLNO
                INTO
                    L_V_BL_NUMBER
                FROM
                    IDP055 I55,
                    IDP002 I02,
                    IDP010 I10
                WHERE I55.EYBLNO = I02.TYBLNO
                AND I55.EYBLNO = I10.AYBLNO
                AND I02.TYBLNO = I10.AYBLNO
                AND I10.AYSTAT >=1
                AND I10.AYSTAT <=6
                AND I10.part_of_bl IS NULL
                AND I02.TYBKNO = P_I_V_BOOKING_NO
                AND I55.EYEQNO = P_I_V_EQUIPMENT_NO
                AND ROWNUM = 1;
                */

                /* * update port seq and direction into BL * */
                G_V_SQL_ID := 'SQLA02';
                DBMS_OUTPUT.PUT_LINE(G_V_SQL_ID);

                UPDATE
                    IDP005
                SET
                    ACT_PORT_DIRECTION = P_I_V_U_DIRECTION,
                    ACT_PORT_SEQUENCE = P_I_V_U_PORT_SEQ,
                    POD_PCSQ = P_I_V_U_OUT_PORT_SEQ,
                    SYCUSR = C_USER, /*NEED TO CHECK WITH K'CHATGAMOL */
                    SYCDAT = P_I_V_U_DATE, /*NEED TO CHECK WITH K'CHATGAMOL */
                    SYCTIM = P_I_V_U_TIME /*NEED TO CHECK WITH K'CHATGAMOL */
                WHERE
                    SYBLNO     = L_V_BL_NUMBER
                    AND VOYAGE_SEQ = P_I_V_VOYAGE_SEQ;

            EXCEPTION /* beg1-2 */
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('IGNORE'||SEP||G_V_SQL_ID||SEP||SQLCODE||SQLERRM);
            END; /* beg1-2 */
        END IF; /* if1 */


    END PRE_UPDATE_BVRD_BL_INFO;

    /* get first sea leg for the booking * */
    PROCEDURE PRE_FIRST_SEA_LEG(
        P_I_V_BOOKING_NO           VARCHAR2,
        P_O_V_VOYAGE_SEQNO         OUT VARCHAR2
    )
    as
    BEGIN
        SELECT
            VOYAGE_SEQNO
        INTO
            P_O_V_VOYAGE_SEQNO
        FROM
            (SELECT
                    ROW_NUMBER() OVER (ORDER BY VOYAGE_SEQNO) R,
                    VOYAGE_SEQNO
            FROM
                BOOKING_VOYAGE_ROUTING_DTL B
            WHERE
                BOOKING_NO = P_I_V_BOOKING_NO
                AND ROUTING_TYPE = C_SEA_LEG
                AND TRANSPORT_MODE NOT IN (C_RAIL, C_TRUCK)
                AND VESSEL      IS NOT NULL
                AND VOYNO       IS NOT NULL
            )
        WHERE R = 1;
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END PRE_FIRST_SEA_LEG;

    /* get BL number from the IDP002 table * */
    PROCEDURE PRE_GET_BL_NUMBER (
        P_I_V_BOOKING_NO        VARCHAR2,
        P_I_V_EQUIPMENT_NO      VARCHAR2,
        P_O_V_BL_NUMBER         OUT VARCHAR2
    )
    AS

    BEGIN
        SELECT
            I02.TYBLNO
        INTO
            P_O_V_BL_NUMBER
        FROM
            IDP055 I55,
            IDP002 I02,
            IDP010 I10
        WHERE I55.EYBLNO = I02.TYBLNO
        AND I55.EYBLNO = I10.AYBLNO
        AND I02.TYBLNO = I10.AYBLNO
        AND I10.AYSTAT >=1
        AND I10.AYSTAT <=6
        AND I10.part_of_bl IS NULL
        AND I02.TYBKNO = P_I_V_BOOKING_NO
        AND I55.EYEQNO = P_I_V_EQUIPMENT_NO
        AND ROWNUM = 1;

    EXCEPTION
        WHEN OTHERS THEN NULL;
    END PRE_GET_BL_NUMBER;
END PKG_PORT_SEQ_UPDATE;
/