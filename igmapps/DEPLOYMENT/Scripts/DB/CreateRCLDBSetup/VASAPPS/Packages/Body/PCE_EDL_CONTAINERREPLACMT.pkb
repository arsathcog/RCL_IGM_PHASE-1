CREATE OR REPLACE PACKAGE BODY VASAPPS."PCE_EDL_CONTAINERREPLACMT" AS

    PROCEDURE PRE_EDL_CONTAINERREPLACMTSAVE (
              p_i_v_booking_id             VARCHAR2
            , p_i_v_booking_no             VARCHAR2
            , p_i_v_terminal               VARCHAR2
            , p_i_v_old_container_no       VARCHAR2
            , p_i_v_old_shippers_seal      VARCHAR2
            , p_i_v_new_container_no       VARCHAR2
            , p_i_v_new_shippers_seal      VARCHAR2
            , p_i_v_reason                 VARCHAR2
            , p_i_v_user                   VARCHAR2
            , p_i_v_new_activity_dt        VARCHAR2
            , p_i_v_time                   VARCHAR2
            , p_i_v_port                   VARCHAR2
            , p_i_v_etd_date               VARCHAR2
            , p_i_v_etd_time               VARCHAR2
            , p_o_v_error                  OUT VARCHAR2
         )  AS
              l_v_SQL                      VARCHAR2(500);
              l_v_replacement_type         VARCHAR2(1);
              l_v_old_activity_date        VARCHAR(15);
              l_v_soc_coc                  VARCHAR2(1);
              l_v_old_coc_flag             BOOLEAN;
              l_v_new_coc_flag             BOOLEAN;
              l_v_date                     VARCHAR2(15);
              l_v_pk_cont_repl_id          NUMBER;
              l_v_bkg_size_type_dtl        NUMBER;
              l_v_bkg_supplier             NUMBER;
              l_v_bkg_equipm_dtl           NUMBER;
              EXP_ON_SAVE                  EXCEPTION;
    BEGIN
        p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        /* Get system date */
        SELECT to_char(SYSDATE, 'YYYYMMDDHH24MISS')
        INTO l_v_date
        FROM DUAL;

        /*Get the required details from booked table */
        SELECT FK_BKG_SIZE_TYPE_DTL
        , FK_BKG_SUPPLIER
        , FK_BKG_EQUIPM_DTL
        , ACTIVITY_DATE_TIME
        , DN_SOC_COC
        INTO
          l_v_bkg_size_type_dtl
        , l_v_bkg_supplier
        , l_v_bkg_equipm_dtl
        , l_v_old_activity_date
        , l_v_soc_coc
        FROM TOS_DL_BOOKED_DISCHARGE
        WHERE PK_BOOKED_DISCHARGE_ID = p_i_v_booking_id;

        /* Get the SOC - COC status of the new equipment number */
        /* This function return true if equipment is COC */
        IF (PCE_EUT_COMMON.FN_CHECK_COC_FLAG(
              p_i_v_new_container_no
            , p_i_v_port
            , p_i_v_etd_date
            , p_i_v_etd_time
            , p_o_v_error
        )) THEN
            /* when new container is COC then old container should also be COC. */
            IF(l_v_soc_coc <> 'C') THEN
                p_o_v_error := 'EDL.SE0165';
                RAISE EXP_ON_SAVE;
            END IF;
        ELSE
            /* when new container is SOC then old container should also be SOC. */
            IF(l_v_soc_coc <> 'S') THEN
                p_o_v_error := 'EDL.SE0164';
                RAISE EXP_ON_SAVE;
            END IF;
        END IF;

        /* Set replacement type value*/
        IF(l_v_soc_coc = 'C') THEN
            /* Replacement type is replacement */
            l_v_replacement_type := '1';
        ELSE
            /* Replacement type is correction */
            l_v_replacement_type := '2';
        END IF;

        /* Get pk for bkg_container_replacement table. */
        SELECT SE_CRZ01.NEXTVAL
        INTO l_v_pk_cont_repl_id
        FROM DUAL;

        INSERT INTO BKG_CONTAINER_REPLACEMENT(
              PK_CONTAINER_REPLACEMENT_ID
            , DATE_OF_REPLACEMENT
            , TERMINAL
            , FK_BOOKING_NO
            , OLD_EQUIPMENT_NO
            , FK_BKG_SIZE_TYPE_DTL
            , FK_BKG_SUPPLIER
            , FK_BKG_EQUIPM_DTL
            , NEW_EQUIPMENT_NO
            , OLD_SEAL_NO
            , NEW_SEAL_NO
            , REPLACEMENT_TYPE
            , REASON
            , RECORD_STATUS
            , RECORD_ADD_USER
            , RECORD_ADD_DATE
            , RECORD_CHANGE_USER
            , RECORD_CHANGE_DATE
        )VALUES(
              l_v_pk_cont_repl_id
            , TO_DATE(l_v_date,'YYYYMMDDHH24MISS')
            , p_i_v_terminal
            , p_i_v_booking_no
            , p_i_v_old_container_no
            , l_v_bkg_size_type_dtl
            , l_v_bkg_supplier
            , l_v_bkg_equipm_dtl
            , p_i_v_new_container_no
            , p_i_v_old_shippers_seal
            , p_i_v_new_shippers_seal
            , l_v_replacement_type
            , p_i_v_reason
            , 'A'
            , p_i_v_user
            , TO_DATE(l_v_date,'YYYYMMDDHH24MISS')
            , p_i_v_user
            , TO_DATE(l_v_date,'YYYYMMDDHH24MISS')
        );

        /* Calling Synchronization batch */
        PCE_ECM_SYNC_EZLL_BOOKING.PRE_BKG_EQUIPMENT_UPDATE
        (
              p_i_v_booking_no
            , l_v_bkg_equipm_dtl
            , p_i_v_new_container_no
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
          --  , '' --CR SOLAS effect parameter
          --  , '' --CR SOLAS effect paramter
            , ''
            , p_o_v_error
        );

        IF(p_o_v_error = '0') THEN
            p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;
        ELSE
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE EXP_ON_SAVE;
        END IF;

        /* Call EMS Update batch if old container is coc. */
        IF(l_v_soc_coc = 'C') THEN
            PCE_ECM_EMS.PRE_EMS_CONTAINER_REPLACEMENT(
                  TO_NUMBER(p_i_v_booking_id)
                , p_i_v_old_container_no
                , p_i_v_new_container_no
                , TO_DATE(p_i_v_new_activity_dt || p_i_v_time, 'DD/MM/YYYYHH24MI')
                , p_o_v_error
            );

            IF(p_o_v_error = '0') THEN
                p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;
            ELSE
                p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE EXP_ON_SAVE;
            END IF;
        END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
  WHEN EXP_ON_SAVE THEN
      RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    WHEN OTHERS THEN
        p_o_v_error := PCE_EUT_COMMON.G_V_GE0001||PCE_EUT_COMMON.G_V_ERR_DATA_SEP||SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
        RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
    END PRE_EDL_CONTAINERREPLACMTSAVE;

END PCE_EDL_CONTAINERREPLACMT;
/