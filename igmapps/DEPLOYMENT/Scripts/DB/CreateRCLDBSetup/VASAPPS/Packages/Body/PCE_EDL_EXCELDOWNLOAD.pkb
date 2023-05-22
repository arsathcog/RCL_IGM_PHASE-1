create or replace
PACKAGE BODY         "PCE_EDL_EXCELDOWNLOAD" AS
   g_v_sql           varchar2(20000 char);

    /*
        *1: Added by vikas: Show crane type field also in exceel download, as k'chatgamol,16.05.2012
        *2 : Added by Saisuda : Show category field also in excel download , 13.06.2016
        *3 : Edit get cagetory description at where conditon from CONFIG_TYPE to CONFIG_VALUE base on TSI 
        *4 : Add VGM Column to Excel Download by PONAPR1
    */

    PROCEDURE PRE_EDL_DISCHARGELIST_BOOKED(
          p_o_refDischargelistBooked   OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_find1                  IN  VARCHAR2
        , p_i_v_in1                    IN  VARCHAR2
        , p_i_v_find2                  IN  VARCHAR2
        , p_i_v_in2                    IN  VARCHAR2
        , p_i_v_order1                 IN  VARCHAR2
        , p_i_v_order1order            IN  VARCHAR2
        , p_i_v_order2                 IN  VARCHAR2
        , p_i_v_order2order            IN  VARCHAR2
        , p_i_v_discharge_list_id      IN  VARCHAR2
        , p_o_v_error                  OUT VARCHAR2
    )  AS

        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_err varchar2(5000);
        l_v_SQL_1 varchar2(4000);
        l_v_SQL_2 varchar2(4000);
        l_v_SQL_3 varchar2(4000);

    BEGIN

        /* Set Success Code*/
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;
            -- when order1 is not not null.
            IF ( p_i_v_order1 IS NOT NULL ) THEN
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;
            -- when order2 is not not null.
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                --  when order1 is not null then add comma(,) after first order by clause.
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'tos_dl_booked_discharge.fk_booking_no
                , tos_dl_booked_discharge.dn_eq_size
                , tos_dl_booked_discharge.dn_eq_type
                , tos_dl_booked_discharge.dn_equipment_no' ;
        END IF;

        /* Construct the SQL */
        g_v_sql := ' 
            SELECT
            TOS_DL_BOOKED_DISCHARGE.CONTAINER_SEQ_NO CONTAINER_SEQ_NO ,
            TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO FK_BOOKING_NO ,
            TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO DN_EQUIPMENT_NO ,
            CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
                ( SELECT IDP002.TYBLNO
              FROM  IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE IDP055.EYBLNO  = IDP002.TYBLNO
                    AND IDP055.EYBLNO      = IDP010.AYBLNO
                    AND IDP002.TYBLNO      = IDP010.AYBLNO
                    AND IDP010.AYSTAT     >=1
                    AND IDP010.AYSTAT     <=6
                    AND IDP010.part_of_bl IS NULL
                    AND IDP002.TYBKNO      = TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO
                    AND IDP055.EYEQNO      = TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO
                    AND ROWNUM=''1'')
                  ELSE
                    ''''
                  END BLNO ,
                  TOS_DL_BOOKED_DISCHARGE.DN_EQ_SIZE DN_EQ_SIZE ,
                  TOS_DL_BOOKED_DISCHARGE.DN_EQ_TYPE DN_EQ_TYPE ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_MT_OVLD'', TOS_DL_BOOKED_DISCHARGE.DN_FULL_MT) DN_FULL_MT ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_BTYP_OVLD'', TOS_DL_BOOKED_DISCHARGE.DN_BKG_TYP) DN_BKG_TYP ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_OC_OVLD'', TOS_DL_BOOKED_DISCHARGE.DN_SOC_COC) DN_SOC_COC ,
                  TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TERM DN_SHIPMENT_TERM ,
                  TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TERM DN_SHIPMENT_TERM ,
                  TOS_DL_BOOKED_DISCHARGE.DN_SHIPMENT_TYP DN_SHIPMENT_TYP ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_PODSTS_OVLD'', TOS_DL_BOOKED_DISCHARGE.LOCAL_STATUS) LOCAL_STATUS ,
                  TOS_DL_BOOKED_DISCHARGE.LOCAL_TERMINAL_STATUS LOCAL_TERMINAL_STATUS ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_MS_OVLD'', TOS_DL_BOOKED_DISCHARGE.MIDSTREAM_HANDLING_CODE) MIDSTREAM_HANDLING_CODE,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_LC_BOOK'', TOS_DL_BOOKED_DISCHARGE.LOAD_CONDITION) LOAD_CONDITION,
                  DECODE(TOS_DL_BOOKED_DISCHARGE.DN_LOADING_STATUS,''BK'',''Booked'',''LO'',''Loaded'',''RB'',''Retained on board'',''SS'',''Short Shipped'') DN_LOADING_STATUS ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_DIS_BOOK'',TOS_DL_BOOKED_DISCHARGE.DISCHARGE_STATUS) DISCHARGE_STATUS ,
                  TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION STOWAGE_POSITION ,
                  TO_CHAR(TOS_DL_BOOKED_DISCHARGE.ACTIVITY_DATE_TIME,''DD/MM/YYYY HH24:MI'') ACTIVITY_DATE_TIME ,
                  TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT CONTAINER_GROSS_WEIGHT ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_DMG_OVLD'', TOS_DL_BOOKED_DISCHARGE.DAMAGED) DAMAGED ,
                  DECODE(TOS_DL_BOOKED_DISCHARGE.VOID_SLOT,0,'''') VOID_SLOT ,
                  TOS_DL_BOOKED_DISCHARGE.FK_SLOT_OPERATOR FK_SLOT_OPERATOR ,
                  TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR ,
                  TOS_DL_BOOKED_DISCHARGE.OUT_SLOT_OPERATOR OUT_SLOT_OPERATOR ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_SPL_HAND_OVLD'', TOS_DL_BOOKED_DISCHARGE.DN_SPECIAL_HNDL) DN_SPECIAL_HNDL,
                  TOS_DL_BOOKED_DISCHARGE.SEAL_NO SEAL_NO ,
                  TOS_DL_BOOKED_DISCHARGE. DN_POL  DN_POL ,
                  TOS_DL_BOOKED_DISCHARGE.DN_POL_TERMINAL DN_POL_TERMINAL ,
                  TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD1 DN_NXT_POD1 ,
                  TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD2 DN_NXT_POD2 ,
                  TOS_DL_BOOKED_DISCHARGE.DN_NXT_POD3 DN_NXT_POD3 ,
                  TOS_DL_BOOKED_DISCHARGE.DN_FINAL_POD DN_FINAL_POD ,
                  TOS_DL_BOOKED_DISCHARGE.FINAL_DEST FINAL_DEST ,
                  TOS_DL_BOOKED_DISCHARGE.DN_NXT_SRV DN_NXT_SRV ,
                  TOS_DL_BOOKED_DISCHARGE.DN_NXT_VESSEL DN_NXT_VESSEL ,
                  TOS_DL_BOOKED_DISCHARGE.DN_NXT_VOYAGE DN_NXT_VOYAGE ,
                  TOS_DL_BOOKED_DISCHARGE.DN_NXT_DIR DN_NXT_DIR ,
                  TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL MLO_VESSEL ,
                  TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE MLO_VOYAGE ,
                  TO_CHAR(TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL_ETA,''DD/MM/YYYY HH24:MI'') MLO_VESSEL_ETA,
                  TOS_DL_BOOKED_DISCHARGE.MLO_POD1 MLO_POD1 ,
                  TOS_DL_BOOKED_DISCHARGE.MLO_POD2 MLO_POD2 ,
                  TOS_DL_BOOKED_DISCHARGE.MLO_POD3 MLO_POD3 ,
                  TOS_DL_BOOKED_DISCHARGE.MLO_DEL MLO_DEL ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_SW_BOOK'', TOS_DL_BOOKED_DISCHARGE.SWAP_CONNECTION_ALLOWED) SWAP_CONNECTION_ALLOWED,
                  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1 FK_HANDLING_INSTRUCTION_1 ,
                  HI1.SHI_DESCRIPTION HANDLING_DISCRIPTION_1,
                  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2 FK_HANDLING_INSTRUCTION_2 ,
                  HI2.SHI_DESCRIPTION HANDLING_DISCRIPTION_2,
                  TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3 FK_HANDLING_INSTRUCTION_3 ,
                  HI3.SHI_DESCRIPTION HANDLING_DISCRIPTION_3,
                  SHP041_CLR1.CLR_DESC CONTAINER_LOADING_REM_1,
                  SHP041_CLR2.CLR_DESC CONTAINER_LOADING_REM_2,
                  TOS_DL_BOOKED_DISCHARGE.FK_SPECIAL_CARGO FK_SPECIAL_CARGO ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_TCPOD_BOOK'', TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG1) TIGHT_CONNECTION_FLAG1,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_TCPOD_BOOK'', TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG2) TIGHT_CONNECTION_FLAG2,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_TCPOD_BOOK'', TOS_DL_BOOKED_DISCHARGE.TIGHT_CONNECTION_FLAG3) TIGHT_CONNECTION_FLAG3,
                  TOS_DL_BOOKED_DISCHARGE.FK_IMDG FK_IMDG ,
                  TOS_DL_BOOKED_DISCHARGE.FK_UNNO FK_UNNO ,
                  TOS_DL_BOOKED_DISCHARGE.FK_UN_VAR FK_UN_VAR ,
                  TOS_DL_BOOKED_DISCHARGE.FK_PORT_CLASS FK_PORT_CLASS ,
                  TOS_DL_BOOKED_DISCHARGE.FK_PORT_CLASS_TYP FK_PORT_CLASS_TYP ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_U_BOOK'', TOS_DL_BOOKED_DISCHARGE.FLASH_UNIT) FLASH_UNIT ,
                  TOS_DL_BOOKED_DISCHARGE.FLASH_POINT FLASH_POINT ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_FUM_BOOK'', TOS_DL_BOOKED_DISCHARGE.FUMIGATION_ONLY) FUMIGATION_ONLY,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_RS_OVLD'', TOS_DL_BOOKED_DISCHARGE.RESIDUE_ONLY_FLAG) RESIDUE_ONLY_FLAG,
                  TOS_DL_BOOKED_DISCHARGE.OVERHEIGHT_CM OVERHEIGHT_CM ,
                  TOS_DL_BOOKED_DISCHARGE.OVERWIDTH_LEFT_CM OVERWIDTH_LEFT_CM ,
                  TOS_DL_BOOKED_DISCHARGE.OVERWIDTH_RIGHT_CM OVERWIDTH_RIGHT_CM ,
                  TOS_DL_BOOKED_DISCHARGE.OVERLENGTH_FRONT_CM OVERLENGTH_FRONT_CM ,
                  TOS_DL_BOOKED_DISCHARGE.OVERLENGTH_REAR_CM OVERLENGTH_REAR_CM ,
                  TOS_DL_BOOKED_DISCHARGE.REEFER_TEMPERATURE REEFER_TEMPERATURE ,
                  PCE_EDL_EXCELDOWNLOAD.FN_REFEER_TEMP_GET_CONFIG_DESC(TOS_DL_BOOKED_DISCHARGE.REEFER_TMP_UNIT) REEFER_TMP_UNIT,
                  TOS_DL_BOOKED_DISCHARGE.DN_HUMIDITY  DN_HUMIDITY ,
                  TOS_DL_BOOKED_DISCHARGE.DN_VENTILATION DN_VENTILATION ,
                  TOS_DL_BOOKED_DISCHARGE.PUBLIC_REMARK PUBLIC_REMARK,
                  (SELECT TRREFR FROM ITP075 WHERE TRTYPE = DN_EQ_TYPE) REEFER_FLAG,
                  TOS_DL_BOOKED_DISCHARGE.CRANE_TYPE CRANE_TYPE,
                  TOS_DL_BOOKED_DISCHARGE.VGM VGM,    --*4
                 --*3 ( SELECT CONFIG_DESC FROM  VASAPPS.VCM_CONFIG_MST  WHERE CONFIG_CD=''CATEGORY'' AND CONFIG_TYPE = TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE) AS CATEGORY_CODE,
                 ( SELECT CONFIG_DESC FROM  VASAPPS.VCM_CONFIG_MST  WHERE CONFIG_CD=''CATEGORY'' AND CONFIG_VALUE = TOS_DL_BOOKED_DISCHARGE.CATEGORY_CODE) AS CATEGORY_CODE,
                   --CR SOLAS begin
           
            
             CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP055.EYMTWT
              FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
              AND    IDP055.EYBLNO  = IDP010.AYBLNO
              AND    IDP002.TYBLNO  = IDP010.AYBLNO
              AND    IDP010.AYSTAT  >=1
              AND    IDP010.AYSTAT  <=6
              AND    IDP010.PART_OF_BL IS NULL
              AND    IDP002.TYBKNO  = TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO
              AND    IDP055.EYEQNO  = TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO
              AND ROWNUM=''1'' )
            ELSE
              null
            END GROSS_CARGO,
               CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP055.EYTARE
              FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
              AND    IDP055.EYBLNO  = IDP010.AYBLNO
              AND    IDP002.TYBLNO  = IDP010.AYBLNO
              AND    IDP010.AYSTAT  >=1
              AND    IDP010.AYSTAT  <=6
              AND    IDP010.PART_OF_BL IS NULL
              AND    IDP002.TYBKNO  = TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO
              AND    IDP055.EYEQNO  = TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO
              AND ROWNUM=''1'' )
            ELSE
              null
            END TARE_WEIGHT,
               CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP055.NET_WEIGHT_METRIC
              FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
              AND    IDP055.EYBLNO  = IDP010.AYBLNO
              AND    IDP002.TYBLNO  = IDP010.AYBLNO
              AND    IDP010.AYSTAT  >=1
              AND    IDP010.AYSTAT  <=6
              AND    IDP010.PART_OF_BL IS NULL
              AND    IDP002.TYBKNO  = TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO
              AND    IDP055.EYEQNO  = TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO
              AND ROWNUM=''1'' )
            ELSE
              null
            END GROSS_WEIGHT
            --CR SOLAS end
                  FROM TOS_DL_BOOKED_DISCHARGE ,
                  SHP007 HI1                   ,
                  SHP007 HI2                   ,
                  SHP007 HI3                   ,
                  SHP041 SHP041_CLR1           ,
                  SHP041 SHP041_CLR2
            WHERE  FK_HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
                  AND FK_HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
                  AND FK_HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
                  AND TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1 = SHP041_CLR1.CLR_CODE (+)
                  AND TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2 = SHP041_CLR2.CLR_CODE (+)
                  AND   TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID = ''' || p_i_v_discharge_list_id || '''
                  AND TOS_DL_BOOKED_DISCHARGE.RECORD_STATUS = ''A''
                   ';

        --Where clause conditions.
        IF(p_i_v_in1 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_DL(p_i_v_in1, p_i_v_find1, 'BOOKED_TAB');
        END IF;

        IF(p_i_v_in2 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_DL(p_i_v_in2, p_i_v_find2, 'BOOKED_TAB');
        END IF;

      g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

        dbms_output.put_line(g_v_sql);
        /* Execute the SQL */
        OPEN p_o_refDischargelistBooked FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                l_v_err := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(l_v_err));

    END PRE_EDL_DISCHARGELIST_BOOKED;

    PROCEDURE PRE_EDL_DL_BOOKED_FORMAT(
          p_o_refDischargelistBooked   OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_find1                  IN  VARCHAR2
        , p_i_v_in1                    IN  VARCHAR2
        , p_i_v_find2                  IN  VARCHAR2
        , p_i_v_in2                    IN  VARCHAR2
        , p_i_v_order1                 IN  VARCHAR2
        , p_i_v_order1order            IN  VARCHAR2
        , p_i_v_order2                 IN  VARCHAR2
        , p_i_v_order2order            IN  VARCHAR2
        , p_i_v_discharge_list_id      IN  VARCHAR2
        , p_o_v_error                  OUT VARCHAR2
    )  AS

        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_err varchar2(5000);
        l_v_SQL_1 varchar2(4000);
        l_v_SQL_2 varchar2(4000);
        l_v_SQL_3 varchar2(4000);

    BEGIN

        /* Set Success Code*/
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;
            -- when order1 is not not null.
            IF ( p_i_v_order1 IS NOT NULL ) THEN
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;
            -- when order2 is not not null.
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                --  when order1 is not null then add comma(,) after first order by clause.
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'tos_dl_booked_discharge.fk_booking_no
                , tos_dl_booked_discharge.dn_eq_size
                , tos_dl_booked_discharge.dn_eq_type
                , tos_dl_booked_discharge.dn_equipment_no' ;
        END IF;

        /* Construct the SQL */
        g_v_sql := ' SELECT
                        ''DISC'' ACTIVITY_CODE ,
                        TOS_DL_DISCHARGE_LIST.DN_PORT DN_PORT ,
            TOS_DL_DISCHARGE_LIST.DN_TERMINAL DN_TERMINAL ,
            TOS_DL_DISCHARGE_LIST.FK_VESSEL FK_VESSEL ,
            TOS_DL_DISCHARGE_LIST.FK_VOYAGE FK_VOYAGE ,
            ITP060.VSLGNM VSLGNM ,
            BKP001.BAORGN BAORGN ,
            BKP001.BAPOL BAPOL ,
            BKP001.BAPOD BAPOD ,
            TOS_DL_BOOKED_DISCHARGE.FINAL_DEST FINAL_DEST ,
            BKP001.BADSTN BADSTN ,
            TOS_DL_BOOKED_DISCHARGE.STOWAGE_POSITION STOWAGE_POSITION ,
            TO_CHAR(TOS_DL_BOOKED_DISCHARGE.ACTIVITY_DATE_TIME, ''DD-MON-YY'') ACTIVITY_DATE_TIME ,
            TOS_DL_BOOKED_DISCHARGE.FK_SLOT_OPERATOR FK_SLOT_OPERATOR ,
            TOS_DL_BOOKED_DISCHARGE.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR ,
            TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO FK_BOOKING_NO ,
            CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
              ( SELECT IDP002.TYBLNO
              FROM  IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE IDP055.EYBLNO  = IDP002.TYBLNO
              AND IDP055.EYBLNO      = IDP010.AYBLNO
              AND IDP002.TYBLNO      = IDP010.AYBLNO
              AND IDP010.AYSTAT     >=1
              AND IDP010.AYSTAT     <=6
              AND IDP010.part_of_bl IS NULL
              AND IDP002.TYBKNO      = FK_BOOKING_NO
              AND IDP055.EYEQNO      = DN_EQUIPMENT_NO
              AND ROWNUM=''1'')
            ELSE
              ''''
            END BLNO ,
            '''' JOB_NO ,
            TOS_DL_BOOKED_DISCHARGE.DN_EQUIPMENT_NO DN_EQUIPMENT_NO ,
            TOS_DL_BOOKED_DISCHARGE.DN_EQ_SIZE ,
            TOS_DL_BOOKED_DISCHARGE.DN_EQ_TYPE ,
            TOS_DL_BOOKED_DISCHARGE.LOCAL_STATUS LOCAL_STATUS ,
            TOS_DL_BOOKED_DISCHARGE.DN_FULL_MT DN_FULL_MT ,
            TOS_DL_BOOKED_DISCHARGE.CONTAINER_GROSS_WEIGHT CONTAINER_GROSS_WEIGHT ,
            ''KGM'' GROSS_WEIGHT_UOM ,
            ''CM'' LENGTH_UOM ,
            TOS_DL_BOOKED_DISCHARGE.OVERLENGTH_FRONT_CM OVERLENGTH_FRONT_CM ,
            TOS_DL_BOOKED_DISCHARGE.OVERLENGTH_REAR_CM OVERLENGTH_REAR_CM ,
            TOS_DL_BOOKED_DISCHARGE.OVERWIDTH_RIGHT_CM OVERWIDTH_RIGHT_CM ,
            TOS_DL_BOOKED_DISCHARGE.OVERWIDTH_LEFT_CM OVERWIDTH_LEFT_CM ,
            TOS_DL_BOOKED_DISCHARGE.OVERHEIGHT_CM OVERHEIGHT_CM ,
            TOS_DL_BOOKED_DISCHARGE.REEFER_TEMPERATURE REEFER_TEMPERATURE ,
            PCE_EDL_EXCELDOWNLOAD.FN_REFEER_TEMP_GET_CONFIG_DESC(TOS_DL_BOOKED_DISCHARGE.REEFER_TMP_UNIT) REEFER_TMP_UNIT,
            TOS_DL_BOOKED_DISCHARGE.FK_IMDG FK_IMDG ,
            TOS_DL_BOOKED_DISCHARGE.FK_UNNO FK_UNNO ,
            TOS_DL_BOOKED_DISCHARGE.MLO_VOYAGE MLO_VOYAGE ,
            TOS_DL_BOOKED_DISCHARGE.MLO_VESSEL MLO_VESSEL ,
            TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_1 FK_HANDLING_INSTRUCTION_1 ,
            TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_2 FK_HANDLING_INSTRUCTION_2 ,
            TOS_DL_BOOKED_DISCHARGE.FK_HANDLING_INSTRUCTION_3 FK_HANDLING_INSTRUCTION_3 ,
            TOS_DL_BOOKED_DISCHARGE.RECORD_ADD_USER RECORD_ADD_USER ,
            TO_CHAR(TOS_DL_BOOKED_DISCHARGE.RECORD_ADD_DATE, ''DD-MON-YY'') RECORD_ADD_DATE,
            TOS_DL_BOOKED_DISCHARGE.VGM VGM
        FROM TOS_DL_BOOKED_DISCHARGE,
            SHP007 HI1                   ,
            SHP007 HI2                   ,
            SHP007 HI3                   ,
            SHP041 SHP041_CLR1           ,
            SHP041 SHP041_CLR2    ,
            TOS_DL_DISCHARGE_LIST ,
            ITP060 ,
            BKP001
        WHERE FK_HANDLING_INSTRUCTION_1                         = HI1.SHI_CODE(+)
            AND FK_HANDLING_INSTRUCTION_2                       = HI2.SHI_CODE(+)
            AND FK_HANDLING_INSTRUCTION_3                       = HI3.SHI_CODE(+)
            AND TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_1 = SHP041_CLR1.CLR_CODE (+)
            AND TOS_DL_BOOKED_DISCHARGE.CONTAINER_LOADING_REM_2 = SHP041_CLR2.CLR_CODE (+)
            AND TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID    = '''|| p_i_v_discharge_list_id ||'''
            AND TOS_DL_DISCHARGE_LIST.PK_DISCHARGE_LIST_ID = TOS_DL_BOOKED_DISCHARGE.FK_DISCHARGE_LIST_ID
            AND ITP060.VSVESS = TOS_DL_DISCHARGE_LIST.FK_VESSEL
            AND TOS_DL_BOOKED_DISCHARGE.FK_BOOKING_NO = BKP001.BABKNO (+)
            AND TOS_DL_DISCHARGE_LIST.RECORD_STATUS = ''A''
            AND TOS_DL_BOOKED_DISCHARGE.RECORD_STATUS = ''A'' ';


        --Where clause conditions.
        IF(p_i_v_in1 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_DL(p_i_v_in1, p_i_v_find1, 'BOOKED_TAB');
        END IF;

        IF(p_i_v_in2 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_DL(p_i_v_in2, p_i_v_find2, 'BOOKED_TAB');
        END IF;

      g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

        /* Execute the SQL */
        OPEN p_o_refDischargelistBooked FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                l_v_err := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(l_v_err));

    END PRE_EDL_DL_BOOKED_FORMAT;

    -- This procedure called to get additional where clause conditions.
    PROCEDURE ADDITION_WHERE_CONDTIONS_DL(
          p_i_v_in              IN  VARCHAR2
        , p_i_v_find            IN  VARCHAR2
        , p_i_v_tab             IN  VARCHAR2

    )AS
        l_v_in  VARCHAR2(30);
    BEGIN

            -- Where condition for BOOKED TAB.
        IF(p_i_v_tab = 'BOOKED_TAB') THEN
           --  when BB Cargo is selectd
        IF(p_i_v_in = 'BBCARGO') then
          g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TERM = ''BBK''' ;

            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''ER''' ;
            END IF;
            -- when COC Transshipped  is selectd
            IF(p_i_v_in = 'COCTRANS') then
          g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
               --  when DG Cargo is selectd
            IF(p_i_v_in = 'DGCARGO') then
                -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL = ''DG'' OR FK_UNNO IS NOT NULL    OR FK_UN_VAR IS NOT NULL OR FLASH_UNIT IS NOT NULL OR FLASH_POINT IS NOT NULL)' ; -- IMO class NOT FOUND.
            END IF;
              --  when OOG Cargo is selectd
            IF(p_i_v_in = 'OOGCARGO') then
                -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL = ''OOG''OR OVERHEIGHT_CM IS NOT NULL  OR OVERLENGTH_FRONT_CM IS NOT NULL OR OVERWIDTH_RIGHT_CM IS NOT NULL OR OVERWIDTH_LEFT_CM IS NOT NULL)' ; -- Over Length in Back  NOT FOUND.
            END IF;
              --  when Reefer Cargo is selectd
            IF(p_i_v_in = 'REEFERCARGO') then
                -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
              g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL != ''NOR''OR REEFER_TEMPERATURE IS NOT NULL  OR REEFER_TMP_UNIT IS NOT NULL OR DN_HUMIDITY IS NOT NULL OR DN_VENTILATION IS NOT NULL)' ;
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''FC''' ;
            END IF;

            -- when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
                 g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;

            --  when Tight Connection is selectd
              -- IF(p_i_v_in = 'TIGHTCON') then
            --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
              -- END IF;

            --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
            g_v_sql := g_v_sql || ' AND LOCAL_STATUS = ''T''';
            END IF;
            -- when With Remarks is selectd
            IF(p_i_v_in = 'WITHREM') then
               g_v_sql := g_v_sql || ' AND PUBLIC_REMARK IS NOT NULL';
            END IF;

        -- add the find value in dynamic sql queries booked .
            IF(p_i_v_in = 'FK_BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND FK_BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_BKG_TYP') then
                g_v_sql := g_v_sql || ' AND DN_BKG_TYP = DECODE(''' || p_i_v_find || ''',''NORMAL'',''N'',
                                                                                 ''EMPTY REPOSITIONING'',''ER'',
                                                                                 ''FEEDER CARGO'',''FC'')';
            END IF;
            IF(p_i_v_in = 'FK_CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND FK_CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DISCHARGE_STATUS') THEN
                g_v_sql := g_v_sql || ' AND  DISCHARGE_STATUS = DECODE(''' || p_i_v_find || ''',''BOOKED'',''BK'',
                                                                                    ''DISCHARGED'',''DI'',
                                                                                    ''RETAINED ON BOARD'',''RB'',
                                                                                    ''ROB'',''RB'',
                                                                                    ''SHORT LANDED'',''SL'')';
            END IF;
            IF(p_i_v_in = 'DN_EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND  DN_EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_CONDITION') THEN
                g_v_sql := g_v_sql || ' AND LOAD_CONDITION =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',
                                                                                      ''FULL'',''F'',
                                                                                      ''BUNDLE'',''P'',
                                                                                      ''BASE'',''B'',
                                                                                      ''RESIDUE'',''R'',
                                                                                      ''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_STATUS =  DECODE(''' || p_i_v_find || ''',''LOCAL'',''L'',
                                                                                      ''TRANSHIPMENT'',''T'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_TERMINAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_TERMINAL_STATUS = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VESSEL= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_POD1') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_POD1= ''' || p_i_v_find || '''';
            END IF;
      IF(p_i_v_in = 'DN_NXT_POD2') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_POD2= ''' || p_i_v_find || '''';
            END IF;
      IF(p_i_v_in = 'DN_NXT_POD3') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_POD3= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_SRV') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_SRV= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_VESSEL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD1') THEN
                g_v_sql := g_v_sql || ' AND  MLO_POD1 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD2') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD2 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD3') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD3 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_POL') THEN
                g_v_sql := g_v_sql || ' AND DN_POL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TYP = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND DN_EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND FK_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND DN_SOC_COC = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',
                                                                                 ''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'DN_SPECIAL_HNDL') THEN
                g_v_sql := g_v_sql || ' AND DN_SPECIAL_HNDL = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',
                                                                                      ''DG'',''D1'',
                                                                                      ''NORMAL'',''N'',
                                                                                      ''DOOR AJAR'',''DA'',
                                                                                      ''OPEN DOOR'',''OD'',
                                                                                      ''NON REFER '',''NR'')';
            END IF;
      IF(p_i_v_in = 'DN_EQ_TYPE') THEN
        g_v_sql := g_v_sql || ' AND DN_EQ_TYPE = ''' || p_i_v_find || '''';
      END IF;
            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND  DN_EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;


        -- Where condition for OVERLANDED TAB.
       ELSIF(p_i_v_tab = 'OVERLANDED_TAB') THEN

             --  when BB Cargo is selectd
            IF(p_i_v_in = 'BBCARGO') then
              g_v_sql := g_v_sql || ' AND SHIPMENT_TERM = ''BBK''' ;
            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''ER''' ;
            END IF;
             --  when COC Transshipped  is selectd
      IF(p_i_v_in = 'COCTRANS') then
                 g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
               --  when DG Cargo is selectd
            IF(p_i_v_in = 'DGCARGO') then
                -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING = ''DG'' OR UN_NUMBER IS NOT NULL  OR UN_NUMBER_VARIANT IS NOT NULL OR FLASHPOINT_UNIT IS NOT NULL OR FLASHPOINT IS NOT NULL)' ; -- IMO class NOT FOUND.
            END IF;

              --  when OOG Cargo is selectd
            IF(p_i_v_in = 'OOGCARGO') then
                -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING = ''OOG''OR OVERHEIGHT_CM IS NOT NULL  OR OVERLENGTH_FRONT_CM IS NOT NULL OR OVERWIDTH_RIGHT_CM IS NOT NULL OR OVERWIDTH_LEFT_CM IS NOT NULL)' ; -- Over Length in Back  NOT FOUND.
            END IF;
              --  when Reefer Cargo is selectd
            IF(p_i_v_in = 'REEFERCARGO') then
                -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
              g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING != ''NOR''OR REEFER_TEMPERATURE IS NOT NULL  OR REEFER_TMP_UNIT IS NOT NULL OR HUMIDITY IS NOT NULL OR VENTILATION IS NOT NULL)' ;
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''FC''' ;
            END IF;

            --  when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
        g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;

            --  when Tight Connection is selectd
              -- IF(p_i_v_in = 'TIGHTCON') then
            --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
              -- END IF;

      --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
          g_v_sql := g_v_sql || ' AND LOCAL_STATUS = ''T''';
            END IF;

              -- add the find value in dynamic sql queries for overlanded tab.

      IF(p_i_v_in = 'BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'BKG_TYP') then
                g_v_sql := g_v_sql || ' AND BKG_TYP = DECODE(''' || p_i_v_find || ''',''NORMAL'',''N'',''EMPTY REPOSITIONING'',''ER'',''FEEDER CARGO'',''FC'')';
            END IF;
            IF(p_i_v_in = 'CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_CONDITION') THEN
                g_v_sql := g_v_sql || ' AND LOAD_CONDITION =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',''FULL'',''F'',''BUNDLE'',''P'',''BASE'',''B'',''RESIDUE'',''R'',''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_STATUS =  DECODE(''' || p_i_v_find || ''',''LOCAL'',''L'',''TRANSHIPMENT'',''T'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_TERMINAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_TERMINAL_STATUS = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND MLO_VESSEL= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_POD1') THEN
                g_v_sql := g_v_sql || ' AND NXT_POD1= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_SRV') THEN
                g_v_sql := g_v_sql || ' AND NXT_SRV= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND NXT_VESSEL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND NXT_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD1') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD1 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD2') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD2 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD3') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD3 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'POL') THEN
                g_v_sql := g_v_sql || ' AND POL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND SHIPMENT_TYP = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FLAG_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND FLAG_SOC_COC = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'SPECIAL_HANDLING') THEN
                g_v_sql := g_v_sql || ' AND SPECIAL_HANDLING = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',''DG'',''D1'',''NORMAL'',''N'',''DOOR AJAR'',''DA'',''OPEN DOOR'',''OD'',''NON REFER '',''NR'')';
            END IF;
            IF(p_i_v_in = 'EQ_TYPE') THEN
            g_v_sql := g_v_sql || ' AND EQ_TYPE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND  EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;

            IF(p_i_v_in = 'STOWAGE_POSITION') THEN
                g_v_sql := g_v_sql || ' AND STOWAGE_POSITION = ''' || p_i_v_find || '''';
            END IF;

    -- Where condition for restow tab.
        ELSIF (p_i_v_tab = 'RESTOW_TAB') THEN
             --  when BB Cargo is selectd
            IF(p_i_v_in = 'BBCARGO') then
              g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TERM = ''BBK''' ;
            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND FK_BKG_SIZE_TYPE_DTL = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND FK_BKG_SIZE_TYPE_DTL = ''ER''' ;
            END IF;
             --  when COC Transshipped  is selectd
            IF(p_i_v_in = 'COCTRANS') then
        g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND FK_BKG_SIZE_TYPE_DTL = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND FK_BKG_SIZE_TYPE_DTL = ''FC''' ;
            END IF;

            --  when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
                g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;
            --  when Tight Connection is selectd
              -- IF(p_i_v_in = 'TIGHTCON') then
            --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
              -- END IF;

      --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
                    g_v_sql := g_v_sql || 'AND LOCAL_STATUS = ''T''';
            END IF;
            --  when With Remarks is selectd
            IF(p_i_v_in = 'WITHREM') then
              g_v_sql := g_v_sql || ' AND PUBLIC_REMARK IS NOT NULL';
            END IF;

     -- add the find value in dynamic sql queries.
            IF(p_i_v_in = 'FK_BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND FK_BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND FK_CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_COND') THEN
                g_v_sql := g_v_sql || ' AND LOAD_COND =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',
                                                                                      ''FULL'',''F'',
                                                                                      ''BUNDLE'',''P'',
                                                                                      ''BASE'',''B'',
                                                                                      ''RESIDUE'',''R'',
                                                                                      ''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'DN_SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TYP = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND DN_EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND FK_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND DN_SOC_COC  = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',
                                                                                 ''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'DN_SPECIAL_HNDL') THEN
                g_v_sql := g_v_sql || ' AND DN_SPECIAL_HNDL = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',
                                                                                      ''DG'',''D1'',
                                                                                      ''NORMAL'',''N'',
                                                                                      ''DOOR AJAR'',''DA'',
                                                                                      ''OPEN DOOR'',''OD'',
                                                                                      ''NON REFER '',''NR'')';
            END IF;
      IF(p_i_v_in = 'DN_EQ_TYPE') THEN
        g_v_sql := g_v_sql || ' AND  DN_EQ_TYPE = ''' || p_i_v_find || '''';
          END IF;
            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;
    -- Where condition for summary tab.
        -- ELSIF (p_i_v_tab = 'SUMMARY_TAB') THEN
    END IF;

    END ADDITION_WHERE_CONDTIONS_DL;

  PROCEDURE PRE_EDL_DL_OVERLANDED(
          p_o_refDischargelistOverlanded  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_find1                     IN  VARCHAR2
        , p_i_v_in1                       IN  VARCHAR2
        , p_i_v_find2                     IN  VARCHAR2
        , p_i_v_in2                       IN  VARCHAR2
        , p_i_v_order1                    IN  VARCHAR2
        , p_i_v_order1order               IN  VARCHAR2
        , p_i_v_order2                    IN  VARCHAR2
        , p_i_v_order2order               IN  VARCHAR2
        , p_i_v_discharge_list_id         IN  VARCHAR2
        , p_o_v_error                     OUT VARCHAR2
    ) AS
        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_err varchar2(5000);
        l_v_SQL_1 varchar2(4000);
        l_v_SQL_2 varchar2(4000);
        l_v_SQL_3 varchar2(4000);

    BEGIN

        /* Set Success Code */
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;

            -- when order1 is not not null.
            IF ( p_i_v_order1 IS NOT NULL ) THEN
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;

            --  when order1 is not null then add comma(,) after first order by clause.
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_DL_OVERLANDED_CONTAINER.BOOKING_NO
                , TOS_DL_OVERLANDED_CONTAINER.EQ_SIZE
                , TOS_DL_OVERLANDED_CONTAINER.EQ_TYPE
                , TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO' ;
        END IF;

        -- Construct the SQL
        g_v_sql := ' SELECT
            TOS_DL_OVERLANDED_CONTAINER.BOOKING_NO BOOKING_NO                                ,
            TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO EQUIPMENT_NO                            ,
            CASE WHEN TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO IS NOT NULL THEN
              ( SELECT IDP002.TYBLNO
              FROM  IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE IDP055.EYBLNO  = IDP002.TYBLNO
              AND IDP055.EYBLNO      = IDP010.AYBLNO
              AND IDP002.TYBLNO      = IDP010.AYBLNO
              AND IDP010.AYSTAT     >=1
              AND IDP010.AYSTAT     <=6
              AND IDP010.part_of_bl IS NULL
              AND IDP002.TYBKNO      = TOS_DL_OVERLANDED_CONTAINER.BOOKING_NO
              AND IDP055.EYEQNO      = TOS_DL_OVERLANDED_CONTAINER.EQUIPMENT_NO
              AND ROWNUM=''1'')
            ELSE
              ''''
            END BLNO,
            TOS_DL_OVERLANDED_CONTAINER.EQ_SIZE EQ_SIZE                                 ,
            TOS_DL_OVERLANDED_CONTAINER.EQ_TYPE EQ_TYPE                                 ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_MT_OVLD'', TOS_DL_OVERLANDED_CONTAINER.FULL_MT) FULL_MT,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_BTYP_OVLD'', TOS_DL_OVERLANDED_CONTAINER.BKG_TYP) BKG_TYP,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_OC_OVLD'', TOS_DL_OVERLANDED_CONTAINER.FLAG_SOC_COC) FLAG_SOC_COC,
            TOS_DL_OVERLANDED_CONTAINER.SHIPMENT_TERM SHIPMENT_TERM                     ,
            TOS_DL_OVERLANDED_CONTAINER.SHIPMENT_TYP SHIPMENT_TYP                       ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_PODSTS_OVLD'', TOS_DL_OVERLANDED_CONTAINER.LOCAL_STATUS) LOCAL_STATUS,
            TOS_DL_OVERLANDED_CONTAINER.LOCAL_TERMINAL_STATUS LOCAL_TERMINAL_STATUS     ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_MS_OVLD'', TOS_DL_OVERLANDED_CONTAINER.MIDSTREAM_HANDLING_CODE) MIDSTREAM_HANDLING_CODE,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_LC_BOOK'', TOS_DL_OVERLANDED_CONTAINER.LOAD_CONDITION) LOAD_CONDITION,
            TOS_DL_OVERLANDED_CONTAINER.STOWAGE_POSITION STOWAGE_POSITION               ,
            TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.ACTIVITY_DATE_TIME,''DD/MM/YYYY HH24:MI'') ACTIVITY_DATE_TIME,
            TOS_DL_OVERLANDED_CONTAINER.CONTAINER_GROSS_WEIGHT CONTAINER_GROSS_WEIGHT   ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_DMG_OVLD'', TOS_DL_OVERLANDED_CONTAINER.DAMAGED) DAMAGED,
            DECODE(TOS_DL_OVERLANDED_CONTAINER.VOID_SLOT,0,'''') VOID_SLOT ,
            TOS_DL_OVERLANDED_CONTAINER.SLOT_OPERATOR SLOT_OPERATOR                     ,
            TOS_DL_OVERLANDED_CONTAINER.CONTAINER_OPERATOR CONTAINER_OPERATOR           ,
            TOS_DL_OVERLANDED_CONTAINER.OUT_SLOT_OPERATOR OUT_SLOT_OPERATOR             ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_SPL_HAND_OVLD'', TOS_DL_OVERLANDED_CONTAINER.SPECIAL_HANDLING) SPECIAL_HANDLING,
            TOS_DL_OVERLANDED_CONTAINER.SEAL_NO SEAL_NO                                 ,
            TOS_DL_OVERLANDED_CONTAINER.POL POL                                         ,
            TOS_DL_OVERLANDED_CONTAINER.POL_TERMINAL POL_TERMINAL                       ,
            TOS_DL_OVERLANDED_CONTAINER.NXT_POD1 NXT_POD1                               ,
            TOS_DL_OVERLANDED_CONTAINER.NXT_POD2 NXT_POD2                               ,
            TOS_DL_OVERLANDED_CONTAINER.NXT_POD3 NXT_POD3                               ,
            TOS_DL_OVERLANDED_CONTAINER.FINAL_POD FINAL_POD                             ,
            TOS_DL_OVERLANDED_CONTAINER.FINAL_DEST FINAL_DEST                           ,
            TOS_DL_OVERLANDED_CONTAINER.NXT_SRV NXT_SRV                                 ,
            TOS_DL_OVERLANDED_CONTAINER.NXT_VESSEL NXT_VESSEL                           ,
            TOS_DL_OVERLANDED_CONTAINER.NXT_VOYAGE NXT_VOYAGE                           ,
            TOS_DL_OVERLANDED_CONTAINER.NXT_DIR NXT_DIR                                 ,
            TOS_DL_OVERLANDED_CONTAINER.MLO_VESSEL MLO_VESSEL                           ,
            TOS_DL_OVERLANDED_CONTAINER.MLO_VOYAGE MLO_VOYAGE                           ,
            TO_CHAR(TOS_DL_OVERLANDED_CONTAINER.MLO_VESSEL_ETA,''DD/MM/YYYY HH24:MI'') MLO_VESSEL_ETA,
            TOS_DL_OVERLANDED_CONTAINER.MLO_POD1 MLO_POD1                               ,
            TOS_DL_OVERLANDED_CONTAINER.MLO_POD2 MLO_POD2                               ,
            TOS_DL_OVERLANDED_CONTAINER.MLO_POD3 MLO_POD3                               ,
            TOS_DL_OVERLANDED_CONTAINER.MLO_DEL MLO_DEL                                 ,
            TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_1 HANDLING_INSTRUCTION_1   ,
            HI1.SHI_DESCRIPTION HANDLING_DISCRIPTION_1                                    ,
            TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_2 HANDLING_INSTRUCTION_2   ,
            HI2.SHI_DESCRIPTION HANDLING_DISCRIPTION_2                                    ,
            TOS_DL_OVERLANDED_CONTAINER.HANDLING_INSTRUCTION_3 HANDLING_INSTRUCTION_3   ,
            HI3.SHI_DESCRIPTION HANDLING_DISCRIPTION_3                                    ,
            SHP041_CLR1.CLR_DESC CONTAINER_LOADING_REM_1,
            SHP041_CLR2.CLR_DESC CONTAINER_LOADING_REM_2,
            TOS_DL_OVERLANDED_CONTAINER.SPECIAL_CARGO SPECIAL_CARGO                     ,
            TOS_DL_OVERLANDED_CONTAINER.IMDG_CLASS IMDG_CLASS                           ,
            TOS_DL_OVERLANDED_CONTAINER.UN_NUMBER UN_NUMBER                             ,
            TOS_DL_OVERLANDED_CONTAINER.UN_NUMBER_VARIANT UN_VAR                        ,
            TOS_DL_OVERLANDED_CONTAINER.PORT_CLASS PORT_CLASS                           ,
            TOS_DL_OVERLANDED_CONTAINER.PORT_CLASS_TYP PORT_CLASS_TYP                   ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_U_BOOK'', TOS_DL_OVERLANDED_CONTAINER.FLASHPOINT_UNIT) FLASHPOINT_UNIT ,
            TOS_DL_OVERLANDED_CONTAINER.FLASHPOINT FLASHPOINT                           ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_FUM_BOOK'', TOS_DL_OVERLANDED_CONTAINER.FUMIGATION_ONLY) FUMIGATION_ONLY,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_RS_OVLD'', TOS_DL_OVERLANDED_CONTAINER.RESIDUE_ONLY_FLAG) RESIDUE_ONLY_FLAG,
            TOS_DL_OVERLANDED_CONTAINER.OVERHEIGHT_CM OVERHEIGHT_CM                     ,
            TOS_DL_OVERLANDED_CONTAINER.OVERWIDTH_LEFT_CM OVERWIDTH_LEFT_CM             ,
            TOS_DL_OVERLANDED_CONTAINER.OVERWIDTH_RIGHT_CM OVERWIDTH_RIGHT_CM           ,
            TOS_DL_OVERLANDED_CONTAINER.OVERLENGTH_FRONT_CM OVERLENGTH_FRONT_CM         ,
            TOS_DL_OVERLANDED_CONTAINER.OVERLENGTH_REAR_CM OVERLENGTH_REAR_CM           ,
            TOS_DL_OVERLANDED_CONTAINER.REEFER_TEMPERATURE REEFER_TEMPERATURE           ,
            PCE_EDL_EXCELDOWNLOAD.FN_REFEER_TEMP_GET_CONFIG_DESC(TOS_DL_OVERLANDED_CONTAINER.REEFER_TMP_UNIT) REEFER_TMP_UNIT,
            TOS_DL_OVERLANDED_CONTAINER.HUMIDITY HUMIDITY                               ,
            TOS_DL_OVERLANDED_CONTAINER.VENTILATION VENTILATION                         ,
            TOS_DL_OVERLANDED_CONTAINER.DA_ERROR DA_ERROR,
            TOS_DL_OVERLANDED_CONTAINER.VGM VGM
            FROM TOS_DL_OVERLANDED_CONTAINER,
                  SHP007 HI1,
                  SHP007 HI2,
                  SHP007 HI3,
                  SHP041 SHP041_CLR1,
                  SHP041 SHP041_CLR2
            WHERE  HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
                  AND HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
                  AND HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
                  AND TOS_DL_OVERLANDED_CONTAINER.CONTAINER_LOADING_REM_1 = SHP041_CLR1.CLR_CODE (+)
                  AND TOS_DL_OVERLANDED_CONTAINER.CONTAINER_LOADING_REM_2 = SHP041_CLR2.CLR_CODE (+)
                  AND    TOS_DL_OVERLANDED_CONTAINER.FK_DISCHARGE_LIST_ID = ''' || p_i_v_discharge_list_id || '''
                  AND TOS_DL_OVERLANDED_CONTAINER.RECORD_STATUS = ''A'' ';

        -- Additional where clause conditions.
        IF(p_i_v_in1 IS NOT NULL) THEN
            -- This function add the additional where clauss condtions in
            -- Dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_DL(p_i_v_in1, p_i_v_find1, 'OVERLANDED_TAB');
        END IF;

        IF(p_i_v_in2 IS NOT NULL) THEN
            -- This function add the additional where clauss condtions in
            -- Dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_DL(p_i_v_in2, p_i_v_find2, 'OVERLANDED_TAB');
        END IF;

        g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

        -- Execute the SQL
        OPEN p_o_refDischargelistOverlanded FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    END PRE_EDL_DL_OVERLANDED;

    PROCEDURE PRE_EDL_DL_RESTOWED  (
          p_o_refDischargelistRestowed  OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_find1                   IN  VARCHAR2
        , p_i_v_in1                     IN  VARCHAR2
        , p_i_v_find2                   IN  VARCHAR2
        , p_i_v_in2                     IN  VARCHAR2
        , p_i_v_order1                  IN  VARCHAR2
        , p_i_v_order1order             IN  VARCHAR2
        , p_i_v_order2                  IN  VARCHAR2
        , p_i_v_order2order             IN  VARCHAR2
        , p_i_v_discharge_list_id       IN  VARCHAR2
        , p_o_v_error                   OUT VARCHAR2
    ) AS
        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_SQL_1 varchar2(4000);
        l_v_SQL_2 varchar2(4000);
        l_v_SQL_3 varchar2(4000);

    BEGIN

        /* Set Success Code */
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;

            IF ( p_i_v_order1 IS NOT NULL ) THEN
                -- when order1 is not not null.
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                --  when order1 is not null then add comma(,) after first order by clause.
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
                -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_RESTOW.FK_BOOKING_NO
                , TOS_RESTOW.DN_EQ_SIZE
                , TOS_RESTOW.DN_EQ_TYPE
                , TOS_RESTOW.DN_EQUIPMENT_NO' ;
        END IF;

        /* Construct the SQL */
        g_v_sql := 'SELECT
            TOS_RESTOW.FK_BOOKING_NO FK_BOOKING_NO                              ,
            TOS_RESTOW.DN_EQUIPMENT_NO DN_EQUIPMENT_NO                          ,
            TOS_RESTOW.DN_EQ_SIZE DN_EQ_SIZE                                    ,
            TOS_RESTOW.DN_EQ_TYPE DN_EQ_TYPE                                    ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_OC_OVLD'', TOS_RESTOW.DN_SOC_COC) DN_SOC_COC,
            TOS_RESTOW.DN_SHIPMENT_TERM DN_SHIPMENT_TERM                        ,
            TOS_RESTOW.DN_SHIPMENT_TYP DN_SHIPMENT_TYP                          ,
            TOS_RESTOW.MIDSTREAM_HANDLING_CODE MIDSTREAM_HANDLING_CODE          ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_LC_BOOK'', TOS_RESTOW.LOAD_CONDITION ) LOAD_COND,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_RESTS_RESTW'', TOS_RESTOW.RESTOW_STATUS) RESTOW_STATUS,
            TOS_RESTOW.STOWAGE_POSITION STOWAGE_POSITION                        ,
            TO_CHAR(TOS_RESTOW.ACTIVITY_DATE_TIME,''DD/MM/YYYY HH24:MI'') ACTIVITY_DATE_TIME,
            TOS_RESTOW.CONTAINER_GROSS_WEIGHT CONTAINER_GROSS_WEIGHT            ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_DMG_OVLD'', TOS_RESTOW.DAMAGED) DAMAGED,
            DECODE(TOS_RESTOW.VOID_SLOT,0,'''') VOID_SLOT ,
            TOS_RESTOW.FK_SLOT_OPERATOR FK_SLOT_OPERATOR                        ,
            TOS_RESTOW.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR              ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_SPL_HAND_OVLD'', TOS_RESTOW.DN_SPECIAL_HNDL) DN_SPECIAL_HNDL,
            TOS_RESTOW.SEAL_NO SEAL_NO                                              ,
            TOS_RESTOW.FK_SPECIAL_CARGO FK_SPECIAL_CARGO                            ,
            TOS_RESTOW.PUBLIC_REMARK PUBLIC_REMARK
            FROM TOS_RESTOW
            WHERE TOS_RESTOW.FK_DISCHARGE_LIST_ID = ''' || p_i_v_discharge_list_id || '''
            AND TOS_RESTOW.RECORD_STATUS = ''A'' ';


    -- Additional where clause conditions.
    IF(p_i_v_in1 IS NOT NULL) THEN
        -- this function add the additional where clauss condtions in
        -- dynamic sql according to the passed parameter.
        ADDITION_WHERE_CONDTIONS_DL(p_i_v_in1, p_i_v_find1, 'RESTOW_TAB');
    END IF;

    IF(p_i_v_in2 IS NOT NULL) THEN
        -- this function add the additional where clauss condtions in
        -- dynamic sql according to the passed parameter.
        ADDITION_WHERE_CONDTIONS_DL(p_i_v_in2, p_i_v_find2, 'RESTOW_TAB');
    END IF;

    g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

    /* Execute the SQL */
    OPEN p_o_refDischargelistRestowed FOR g_v_sql;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    END PRE_EDL_DL_RESTOWED;

    PROCEDURE PRE_ELL_LL_BOOKED(
          p_o_refLoadlistBooked     OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_find1               IN  VARCHAR2
        , p_i_v_in1                 IN  VARCHAR2
        , p_i_v_find2               IN  VARCHAR2
        , p_i_v_in2                 IN  VARCHAR2
        , p_i_v_order1              IN  VARCHAR2
        , p_i_v_order1order         IN  VARCHAR2
        , p_i_v_order2              IN  VARCHAR2
        , p_i_v_order2order         IN  VARCHAR2
        , p_i_v_load_list_id        IN  VARCHAR2
        , p_o_v_error               OUT VARCHAR2
    )  AS

        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_err   varchar2(5000);

    BEGIN

        /* Set Success Code*/
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;
            -- when order1 is not not null.
            IF ( p_i_v_order1 IS NOT NULL ) THEN
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;
            -- when order2 is not not null.
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                --  when order1 is not null then add comma(,) after first order by clause.
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_LL_BOOKED_LOADING.fk_booking_no
                , TOS_LL_BOOKED_LOADING.dn_eq_size
                , TOS_LL_BOOKED_LOADING.dn_eq_type
                , TOS_LL_BOOKED_LOADING.dn_equipment_no' ;
        END IF;

        /* Construct the SQL */
       g_v_sql := ' 
           SELECT
            TOS_LL_BOOKED_LOADING.CONTAINER_SEQ_NO CONTAINER_SEQ_NO ,
            TOS_LL_BOOKED_LOADING.FK_BOOKING_NO FK_BOOKING_NO ,
            TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO DN_EQUIPMENT_NO ,
            CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP002.TYBLNO
              FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
              AND    IDP055.EYBLNO  = IDP010.AYBLNO
              AND    IDP002.TYBLNO  = IDP010.AYBLNO
              AND    IDP010.AYSTAT  >=1
              AND    IDP010.AYSTAT  <=6
              AND    IDP010.PART_OF_BL IS NULL
              AND    IDP002.TYBKNO  = TOS_LL_BOOKED_LOADING.FK_BOOKING_NO
              AND    IDP055.EYEQNO  = DN_EQUIPMENT_NO
              AND ROWNUM=''1'')
            ELSE
              ''''
            END BLNO,
            TOS_LL_BOOKED_LOADING.EQUPMENT_NO_SOURCE,
            TOS_LL_BOOKED_LOADING.DN_EQ_SIZE DN_EQ_SIZE ,
            TOS_LL_BOOKED_LOADING.DN_EQ_TYPE DN_EQ_TYPE ,
              PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_MT_OVLD'', TOS_LL_BOOKED_LOADING.DN_FULL_MT) DN_FULL_MT ,
              PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_BTYP_OVLD'', TOS_LL_BOOKED_LOADING.DN_BKG_TYP) DN_BKG_TYP ,
              PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_OC_OVLD'', TOS_LL_BOOKED_LOADING.DN_SOC_COC) DN_SOC_COC ,

            TOS_LL_BOOKED_LOADING.DN_SHIPMENT_TERM DN_SHIPMENT_TERM ,
            TOS_LL_BOOKED_LOADING.DN_SHIPMENT_TYP DN_SHIPMENT_TYP ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_PODSTS_OVLD'', TOS_LL_BOOKED_LOADING.LOCAL_STATUS) LOCAL_STATUS ,
            TOS_LL_BOOKED_LOADING.LOCAL_TERMINAL_STATUS LOCAL_TERMINAL_STATUS ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_MS_OVLD'', TOS_LL_BOOKED_LOADING.MIDSTREAM_HANDLING_CODE) MIDSTREAM_HANDLING_CODE,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_LC_BOOK'', TOS_LL_BOOKED_LOADING.LOAD_CONDITION) LOAD_CONDITION,
                              DECODE(TOS_LL_BOOKED_LOADING.LOADING_STATUS,''BK'',''Booked'',''LO'',''Loaded'',''RB'',''Retained on board'',''SS'',''Short Shipped'')  LOADING_STATUS ,
            TOS_LL_BOOKED_LOADING.STOWAGE_POSITION STOWAGE_POSITION ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.ACTIVITY_DATE_TIME,''DD/MM/YYYY HH24:MI'') ACTIVITY_DATE_TIME,
            TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT CONTAINER_GROSS_WEIGHT ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_DMG_OVLD'', TOS_LL_BOOKED_LOADING.DAMAGED) DAMAGED ,
            DECODE(TOS_LL_BOOKED_LOADING.VOID_SLOT,0,'''') VOID_SLOT ,
            DECODE(TOS_LL_BOOKED_LOADING.PREADVICE_FLAG,''Y'',''Yes'',''N'',''No'')    PREADVICE_FLAG,
            TOS_LL_BOOKED_LOADING.FK_SLOT_OPERATOR FK_SLOT_OPERATOR ,
            TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR ,
            TOS_LL_BOOKED_LOADING.OUT_SLOT_OPERATOR OUT_SLOT_OPERATOR ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_SPL_HAND_OVLD'', TOS_LL_BOOKED_LOADING.DN_SPECIAL_HNDL) DN_SPECIAL_HNDL,
            TOS_LL_BOOKED_LOADING.SEAL_NO SEAL_NO ,
            TOS_LL_BOOKED_LOADING.DN_DISCHARGE_PORT  DN_DISCHARGE_PORT ,
            TOS_LL_BOOKED_LOADING.DN_DISCHARGE_TERMINAL DN_DISCHARGE_TERMINAL ,
            TOS_LL_BOOKED_LOADING.DN_NXT_POD1 DN_NXT_POD1 ,
            TOS_LL_BOOKED_LOADING.DN_NXT_POD2 DN_NXT_POD2 ,
            TOS_LL_BOOKED_LOADING.DN_NXT_POD3 DN_NXT_POD3 ,
            TOS_LL_BOOKED_LOADING.DN_FINAL_POD DN_FINAL_POD ,
            TOS_LL_BOOKED_LOADING.FINAL_DEST FINAL_DEST ,
            TOS_LL_BOOKED_LOADING.DN_NXT_SRV DN_NXT_SRV ,
            TOS_LL_BOOKED_LOADING.DN_NXT_VESSEL DN_NXT_VESSEL ,
            TOS_LL_BOOKED_LOADING.DN_NXT_VOYAGE DN_NXT_VOYAGE ,
            TOS_LL_BOOKED_LOADING.DN_NXT_DIR DN_NXT_DIR ,
            TOS_LL_BOOKED_LOADING.MLO_VESSEL MLO_VESSEL ,
            TOS_LL_BOOKED_LOADING.MLO_VOYAGE MLO_VOYAGE ,
            TO_CHAR(TOS_LL_BOOKED_LOADING.MLO_VESSEL_ETA,''DD/MM/YYYY HH24:MI'') MLO_VESSEL_ETA,
            TOS_LL_BOOKED_LOADING.MLO_POD1 MLO_POD1 ,
            TOS_LL_BOOKED_LOADING.MLO_POD2 MLO_POD2 ,
            TOS_LL_BOOKED_LOADING.MLO_POD3 MLO_POD3 ,
            TOS_LL_BOOKED_LOADING.MLO_DEL MLO_DEL ,
            TOS_LL_BOOKED_LOADING.EX_MLO_VESSEL,
                  TOS_LL_BOOKED_LOADING.EX_MLO_VOYAGE,
                  TO_CHAR(TOS_LL_BOOKED_LOADING.EX_MLO_VESSEL_ETA,''DD/MM/YYYY HH24:MI'') EX_MLO_VESSEL_ETA,
            TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1 FK_HANDLING_INSTRUCTION_1 ,
            HI1.SHI_DESCRIPTION HANDLING_DISCRIPTION_1,
            TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2 FK_HANDLING_INSTRUCTION_2 ,
            HI2.SHI_DESCRIPTION HANDLING_DISCRIPTION_2,
            TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3 FK_HANDLING_INSTRUCTION_3 ,
            HI3.SHI_DESCRIPTION HANDLING_DISCRIPTION_3,
                  SHP041_CLR1.CLR_DESC CONTAINER_LOADING_REM_1,
                  SHP041_CLR2.CLR_DESC CONTAINER_LOADING_REM_2,
            TOS_LL_BOOKED_LOADING.FK_SPECIAL_CARGO FK_SPECIAL_CARGO ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_TCPOD_BOOK'', TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG1) TIGHT_CONNECTION_FLAG1,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_TCPOD_BOOK'', TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG2) TIGHT_CONNECTION_FLAG2,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_TCPOD_BOOK'', TOS_LL_BOOKED_LOADING.TIGHT_CONNECTION_FLAG3) TIGHT_CONNECTION_FLAG3,
            TOS_LL_BOOKED_LOADING.FK_IMDG FK_IMDG ,
            TOS_LL_BOOKED_LOADING.FK_UNNO FK_UNNO ,
            TOS_LL_BOOKED_LOADING.FK_UN_VAR FK_UN_VAR ,
            TOS_LL_BOOKED_LOADING.FK_PORT_CLASS FK_PORT_CLASS ,
            TOS_LL_BOOKED_LOADING.FK_PORT_CLASS_TYP FK_PORT_CLASS_TYP ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_U_BOOK'', TOS_LL_BOOKED_LOADING.FLASH_UNIT) FLASH_UNIT ,
            TOS_LL_BOOKED_LOADING.FLASH_POINT FLASH_POINT ,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_FUM_BOOK'', TOS_LL_BOOKED_LOADING.FUMIGATION_ONLY) FUMIGATION_ONLY,
                  PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_RS_OVLD'', TOS_LL_BOOKED_LOADING.RESIDUE_ONLY_FLAG) RESIDUE_ONLY_FLAG,
            TOS_LL_BOOKED_LOADING.OVERHEIGHT_CM OVERHEIGHT_CM ,
            TOS_LL_BOOKED_LOADING.OVERWIDTH_LEFT_CM OVERWIDTH_LEFT_CM ,
            TOS_LL_BOOKED_LOADING.OVERWIDTH_RIGHT_CM OVERWIDTH_RIGHT_CM ,
            TOS_LL_BOOKED_LOADING.OVERLENGTH_FRONT_CM OVERLENGTH_FRONT_CM ,
            TOS_LL_BOOKED_LOADING.OVERLENGTH_REAR_CM OVERLENGTH_REAR_CM ,
            TOS_LL_BOOKED_LOADING.REEFER_TMP REEFER_TEMPERATURE ,
            PCE_EDL_EXCELDOWNLOAD.FN_REFEER_TEMP_GET_CONFIG_DESC(TOS_LL_BOOKED_LOADING.REEFER_TMP_UNIT) REEFER_TMP_UNIT,
            TOS_LL_BOOKED_LOADING.DN_HUMIDITY  DN_HUMIDITY ,
            TOS_LL_BOOKED_LOADING.DN_VENTILATION DN_VENTILATION ,
            TOS_LL_BOOKED_LOADING.PUBLIC_REMARK PUBLIC_REMARK ,
            (SELECT TRREFR FROM ITP075 WHERE TRTYPE = DN_EQ_TYPE) REEFER_FLAG,
            TOS_LL_BOOKED_LOADING.CRANE_TYPE CRANE_TYPE,
            TOS_LL_BOOKED_LOADING.VGM VGM,  --*4
         --*3 ( SELECT CONFIG_DESC FROM  VASAPPS.VCM_CONFIG_MST  WHERE CONFIG_CD=''CATEGORY'' AND CONFIG_TYP = TOS_LL_BOOKED_LOADING.CATEGORY_CODE) AS CATEGORY_CODE,
              ( SELECT CONFIG_DESC FROM  VASAPPS.VCM_CONFIG_MST  WHERE CONFIG_CD=''CATEGORY'' AND CONFIG_VALUE = TOS_LL_BOOKED_LOADING.CATEGORY_CODE) AS CATEGORY_CODE,
         
           --CR SOLAS begin
           
            
             CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP055.EYMTWT
              FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
              AND    IDP055.EYBLNO  = IDP010.AYBLNO
              AND    IDP002.TYBLNO  = IDP010.AYBLNO
              AND    IDP010.AYSTAT  >=1
              AND    IDP010.AYSTAT  <=6
              AND    IDP010.PART_OF_BL IS NULL
              AND    IDP002.TYBKNO  = TOS_LL_BOOKED_LOADING.FK_BOOKING_NO
              AND    IDP055.EYEQNO  = TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO
              AND ROWNUM=''1'' )
            ELSE
              null
            END GROSS_CARGO,
               CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP055.EYTARE
              FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
              AND    IDP055.EYBLNO  = IDP010.AYBLNO
              AND    IDP002.TYBLNO  = IDP010.AYBLNO
              AND    IDP010.AYSTAT  >=1
              AND    IDP010.AYSTAT  <=6
              AND    IDP010.PART_OF_BL IS NULL
              AND    IDP002.TYBKNO  = TOS_LL_BOOKED_LOADING.FK_BOOKING_NO
              AND    IDP055.EYEQNO  = TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO
              AND ROWNUM=''1'' )
            ELSE
              null
            END TARE_WEIGHT,
               CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP055.NET_WEIGHT_METRIC
              FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
              AND    IDP055.EYBLNO  = IDP010.AYBLNO
              AND    IDP002.TYBLNO  = IDP010.AYBLNO
              AND    IDP010.AYSTAT  >=1
              AND    IDP010.AYSTAT  <=6
              AND    IDP010.PART_OF_BL IS NULL
              AND    IDP002.TYBKNO  = TOS_LL_BOOKED_LOADING.FK_BOOKING_NO
              AND    IDP055.EYEQNO  = TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO
              AND ROWNUM=''1'' )
            ELSE
              null
            END GROSS_WEIGHT
            --CR SOLAS end
            
            FROM TOS_LL_BOOKED_LOADING,
            SHP007 HI1,
            SHP007 HI2,
            SHP007 HI3,
            
          SHP041 SHP041_CLR1           ,
          SHP041 SHP041_CLR2
            WHERE FK_HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
            AND FK_HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
            AND FK_HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
            AND TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1 = SHP041_CLR1.CLR_CODE (+)
            AND TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2 = SHP041_CLR2.CLR_CODE (+)
            AND TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID = ''' || p_i_v_load_list_id || '''
            AND TOS_LL_BOOKED_LOADING.RECORD_STATUS = ''A'' ';

        --Where clause conditions.
        IF(p_i_v_in1 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_LL(p_i_v_in1, p_i_v_find1, 'BOOKED_TAB');
        END IF;

        IF(p_i_v_in2 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_LL(p_i_v_in2, p_i_v_find2, 'BOOKED_TAB');
        END IF;

        g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

        /* Execute the SQL */
        OPEN p_o_refLoadlistBooked FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                l_v_err := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(l_v_err));
    END PRE_ELL_LL_BOOKED;

        -- This procedure called to get additional where clause conditions.
    PROCEDURE ADDITION_WHERE_CONDTIONS_LL(
          p_i_v_in                  IN  VARCHAR2
        , p_i_v_find                IN  VARCHAR2
        , p_i_v_tab                 IN  VARCHAR2

    )AS
        l_v_in  VARCHAR2(30);
    BEGIN

            -- Where condition for BOOKED TAB.
        IF(p_i_v_tab = 'BOOKED_TAB') THEN
           --  when BB Cargo is selectd
        IF(p_i_v_in = 'BBCARGO') then
          g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TERM = ''BBK''' ;

            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND DN_BKG_TYP = ''ER''' ;
            END IF;
            -- when COC Transshipped  is selectd
            IF(p_i_v_in = 'COCTRANS') then
          g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
               --  when DG Cargo is selectd
            IF(p_i_v_in = 'DGCARGO') then
                -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL = ''DG'' OR FK_UNNO IS NOT NULL    OR FK_UN_VAR IS NOT NULL OR FLASH_UNIT IS NOT NULL OR FLASH_POINT IS NOT NULL)' ; -- IMO class NOT FOUND.
            END IF;
              --  when OOG Cargo is selectd
            IF(p_i_v_in = 'OOGCARGO') then
                -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL = ''OOG''OR OVERHEIGHT_CM IS NOT NULL  OR OVERLENGTH_FRONT_CM IS NOT NULL OR OVERWIDTH_RIGHT_CM IS NOT NULL OR OVERWIDTH_LEFT_CM IS NOT NULL)' ; -- Over Length in Back  NOT FOUND.
            END IF;
              --  when Reefer Cargo is selectd
            IF(p_i_v_in = 'REEFERCARGO') then
                -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
              g_v_sql := g_v_sql || ' AND (DN_SPECIAL_HNDL != ''NOR''OR REEFER_TMP IS NOT NULL  OR REEFER_TMP_UNIT IS NOT NULL OR DN_HUMIDITY IS NOT NULL OR DN_VENTILATION IS NOT NULL)' ;
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND DN_BKG_TYP = ''FC''' ;
            END IF;

            -- when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
                 g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;

            --  when Tight Connection is selectd
              -- IF(p_i_v_in = 'TIGHTCON') then
            --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
              -- END IF;

            --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
            g_v_sql := g_v_sql || ' AND LOCAL_STATUS = ''T''';
            END IF;
            -- when With Remarks is selectd
            IF(p_i_v_in = 'WITHREM') then
               g_v_sql := g_v_sql || ' AND PUBLIC_REMARK IS NOT NULL';
            END IF;

        -- add the find value in dynamic sql queries booked .
-- *************************************************************************************
            IF(p_i_v_in = 'FK_BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND FK_BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_BKG_TYP') then
                g_v_sql := g_v_sql || ' AND DN_BKG_TYP = DECODE(''' || p_i_v_find || ''',''NORMAL'',''N'',
                                                                                 ''EMPTY REPOSITIONING'',''ER'',
                                                                                 ''FEEDER CARGO'',''FC'')';
            END IF;
            IF(p_i_v_in = 'FK_CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND FK_CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOADING_STATUS') THEN
                g_v_sql := g_v_sql || ' AND  LOADING_STATUS = DECODE(''' || p_i_v_find || ''',''BOOKED'',''BK'',
                                                                                    ''LOADED'',''LO'',
                                                                                    ''RETAINED ON BOARD'',''RB'',
                                                                                    ''ROB'',''RB'',
                                                                                    ''SHORT SHIPPED'',''SL'')';
            END IF;
            IF(p_i_v_in = 'DN_EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND  DN_EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_CONDITION') THEN
                g_v_sql := g_v_sql || ' AND LOAD_CONDITION =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',
                                                                                      ''FULL'',''F'',
                                                                                      ''BUNDLE'',''P'',
                                                                                      ''BASE'',''B'',
                                                                                      ''RESIDUE'',''R'',
                                                                                      ''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_STATUS =  DECODE(''' || p_i_v_find || ''',''LOCAL'',''L'',
                                                                                      ''TRANSHIPMENT'',''T'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_TERMINAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_TERMINAL_STATUS = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VESSEL= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_POD1') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_POD1= ''' || p_i_v_find || '''';
            END IF;
      IF(p_i_v_in = 'DN_NXT_POD2') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_POD2= ''' || p_i_v_find || '''';
            END IF;
      IF(p_i_v_in = 'DN_NXT_POD3') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_POD3= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_SRV') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_SRV= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_VESSEL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_NXT_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  DN_NXT_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD1') THEN
                g_v_sql := g_v_sql || ' AND  MLO_POD1 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD2') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD2 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD3') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD3 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TYP = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND DN_EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND FK_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND DN_SOC_COC = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',
                                                                                 ''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'DN_SPECIAL_HNDL') THEN
                g_v_sql := g_v_sql || ' AND DN_SPECIAL_HNDL = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',
                                                                                      ''DG'',''D1'',
                                                                                      ''NORMAL'',''N'',
                                                                                      ''DOOR AJAR'',''DA'',
                                                                                      ''OPEN DOOR'',''OD'',
                                                                                      ''NON REFER '',''NR'')';
            END IF;
      IF(p_i_v_in = 'DN_EQ_TYPE') THEN
        g_v_sql := g_v_sql || ' AND DN_EQ_TYPE = ''' || p_i_v_find || '''';
      END IF;
            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND  DN_EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;


-- *************************************************************************************

        -- Where condition for OVERSHIPPED TAB.
       ELSIF(p_i_v_tab = 'OVERSHIPPED_TAB') THEN

             --  when BB Cargo is selectd
            IF(p_i_v_in = 'BBCARGO') then
              g_v_sql := g_v_sql || ' AND SHIPMENT_TERM = ''BBK''' ;
            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND BKG_TYP = ''ER''' ;
            END IF;
             --  when COC Transshipped  is selectd
      IF(p_i_v_in = 'COCTRANS') then
                 g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
               --  when DG Cargo is selectd
            IF(p_i_v_in = 'DGCARGO') then
                -- Special Handling='DG' OR any of DG field(UN No., UN Variant, IMO class, Flash Unit, Flash Point) is not empty
                g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING = ''DG'' OR UN_NUMBER IS NOT NULL  OR UN_NUMBER_VARIANT IS NOT NULL OR FLASHPOINT_UNIT IS NOT NULL OR FLASHPOINT IS NOT NULL)' ; -- IMO class NOT FOUND.
            END IF;

              --  when OOG Cargo is selectd
            IF(p_i_v_in = 'OOGCARGO') then
                -- Special Handling ='OOG' OR any of OOG field(Over Height, Over Length in front, Over Length in Back, Over Width Right, Over Width Left) not empty
                g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING = ''OOG''OR OVERHEIGHT_CM IS NOT NULL  OR OVERLENGTH_FRONT_CM IS NOT NULL OR OVERWIDTH_RIGHT_CM IS NOT NULL OR OVERWIDTH_LEFT_CM IS NOT NULL)' ; -- Over Length in Back  NOT FOUND.
            END IF;
              --  when Reefer Cargo is selectd
            IF(p_i_v_in = 'REEFERCARGO') then
                -- Special handling not 'NOR' OR  any of OOG field(Reefer Temperature, Reefer Temperature Unit, Humidity, Ventilation ) not empty
              g_v_sql := g_v_sql || ' AND (SPECIAL_HANDLING != ''NOR''OR REEFER_TEMPERATURE IS NOT NULL  OR REEFER_TMP_UNIT IS NOT NULL OR HUMIDITY IS NOT NULL OR VENTILATION IS NOT NULL)' ;
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND BKG_TYP = ''FC''' ;
            END IF;

            --  when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
              g_v_sql := g_v_sql || ' AND FLAG_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;

            --  when Tight Connection is selectd
              -- IF(p_i_v_in = 'TIGHTCON') then
            --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
              -- END IF;

      --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
          g_v_sql := g_v_sql || ' AND LOCAL_STATUS = ''T''';
            END IF;

              -- add the find value in dynamic sql queries for overshipped tab.
-- *************************************************************************************
      IF(p_i_v_in = 'BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'BKG_TYP') then
                g_v_sql := g_v_sql || ' AND BKG_TYP = DECODE(''' || p_i_v_find || ''',''NORMAL'',''N'',''EMPTY REPOSITIONING'',''ER'',''FEEDER CARGO'',''FC'')';
            END IF;
            IF(p_i_v_in = 'CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_CONDITION') THEN
                g_v_sql := g_v_sql || ' AND LOAD_CONDITION =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',''FULL'',''F'',''BUNDLE'',''P'',''BASE'',''B'',''RESIDUE'',''R'',''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_STATUS =  DECODE(''' || p_i_v_find || ''',''LOCAL'',''L'',''TRANSHIPMENT'',''T'')';
            END IF;
            IF(p_i_v_in = 'LOCAL_TERMINAL_STATUS') THEN
                g_v_sql := g_v_sql || ' AND LOCAL_TERMINAL_STATUS = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND MLO_VESSEL= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND  MLO_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_POD1') THEN
                g_v_sql := g_v_sql || ' AND NXT_POD1= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_SRV') THEN
                g_v_sql := g_v_sql || ' AND NXT_SRV= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_VESSEL') THEN
                g_v_sql := g_v_sql || ' AND NXT_VESSEL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'NXT_VOYAGE') THEN
                g_v_sql := g_v_sql || ' AND NXT_VOYAGE= ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD1') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD1 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD2') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD2 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'MLO_POD3') THEN
                g_v_sql := g_v_sql || ' AND MLO_POD3 = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'OUT_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND OUT_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'POL') THEN
                g_v_sql := g_v_sql || ' AND POL = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND SHIPMENT_TYPE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FLAG_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND FLAG_SOC_COC = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'SPECIAL_HANDLING') THEN
                g_v_sql := g_v_sql || ' AND SPECIAL_HANDLING = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',''DG'',''D1'',''NORMAL'',''N'',''DOOR AJAR'',''DA'',''OPEN DOOR'',''OD'',''NON REFER '',''NR'')';
            END IF;
            IF(p_i_v_in = 'EQ_TYPE') THEN
            g_v_sql := g_v_sql || ' AND EQ_TYPE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND  EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;

            IF(p_i_v_in = 'STOWAGE_POSITION') THEN
                g_v_sql := g_v_sql || ' AND STOWAGE_POSITION = ''' || p_i_v_find || '''';
            END IF;
-- *************************************************************************************

    -- Where condition for restow tab.
        ELSIF (p_i_v_tab = 'RESTOW_TAB') THEN
             --  when BB Cargo is selectd
            IF(p_i_v_in = 'BBCARGO') then
              g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TERM = ''BBK''' ;
            END IF;
             --  when COC Customer is selectd
            IF(p_i_v_in = 'COCCUST') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND FK_BKG_SIZE_TYPE_DTL = ''N''' ;
            END IF;
             --  when COC Empty is selectd
            IF(p_i_v_in = 'COCEMPTY') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND FK_BKG_SIZE_TYPE_DTL = ''ER''' ;
            END IF;
             --  when COC Transshipped  is selectd
            IF(p_i_v_in = 'COCTRANS') then
        g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''C'' AND LOCAL_STATUS = ''T''';
            END IF;
              --  when SOC all is selectd
            IF(p_i_v_in = 'SOCALL') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S''' ;
            END IF;
            --  when SOC is selectd
            IF(p_i_v_in = 'SOCDIRECT') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND FK_BKG_SIZE_TYPE_DTL = ''N''' ;
            END IF;
            --  when SOC Partner is selectd
            IF(p_i_v_in = 'SOCPARTNER') then
              g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND FK_BKG_SIZE_TYPE_DTL = ''FC''' ;
            END IF;

            --  when SOC transshipped is selectd
            IF(p_i_v_in = 'SOCTRANS') then
                g_v_sql := g_v_sql || ' AND DN_SOC_COC  = ''S'' AND LOCAL_STATUS = ''T''';
      END IF;
            --  when Tight Connection is selectd
              -- IF(p_i_v_in = 'TIGHTCON') then
            --    TIGHT_CONNECTION_FLAG1='Y' and POD = 'Current Port';
              -- END IF;

      --  when Transshipped is selectd
            IF(p_i_v_in = 'TRANSSHPD') then
                    g_v_sql := g_v_sql || 'AND LOCAL_STATUS = ''T''';
            END IF;
            --  when With Remarks is selectd
            IF(p_i_v_in = 'WITHREM') then
              g_v_sql := g_v_sql || ' AND PUBLIC_REMARK IS NOT NULL';
            END IF;

     -- add the find value in dynamic sql queries.
-- *************************************************************************************
            IF(p_i_v_in = 'FK_BOOKING_NO') then
                g_v_sql := g_v_sql || ' AND FK_BOOKING_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_CONTAINER_OPERATOR') then
                g_v_sql := g_v_sql || ' AND FK_CONTAINER_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQUIPMENT_NO') THEN
                g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'LOAD_CONDITION') THEN
                g_v_sql := g_v_sql || ' AND LOAD_CONDITION =  DECODE(''' || p_i_v_find || ''',''EMPTY'',''E'',''FULL'',''F'',''BUNDLE'',''P'',''BASE'',''B'',''RESIDUE'',''R'',''BREAK BULK'',''L'')';
            END IF;
            IF(p_i_v_in = 'DN_SHIPMENT_TYP') THEN
                g_v_sql := g_v_sql || ' AND DN_SHIPMENT_TYP = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_EQ_SIZE') THEN
                g_v_sql := g_v_sql || ' AND DN_EQ_SIZE = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'FK_SLOT_OPERATOR') THEN
                g_v_sql := g_v_sql || ' AND FK_SLOT_OPERATOR = ''' || p_i_v_find || '''';
            END IF;
            IF(p_i_v_in = 'DN_SOC_COC') THEN
                g_v_sql := g_v_sql || ' AND DN_SOC_COC  = DECODE(''' || p_i_v_find || ''',''SOC'',''S'',''COC'',''C'')';
            END IF;
            IF(p_i_v_in = 'DN_SPECIAL_HNDL') THEN
                g_v_sql := g_v_sql || ' AND DN_SPECIAL_HNDL = DECODE(''' || p_i_v_find || ''',''OOG'',''O0'',''DG'',''D1'',''NORMAL'',''N'',''DOOR AJAR'',''DA'',''OPEN DOOR'',''OD'',''NON REFER '',''NR'')';
            END IF;
      IF(p_i_v_in = 'DN_EQ_TYPE') THEN
        g_v_sql := g_v_sql || ' AND  DN_EQ_TYPE = ''' || p_i_v_find || '''';
          END IF;
            IF(p_i_v_in = 'L3EQPNUM') THEN
                l_v_in := '%' || p_i_v_find;
                g_v_sql := g_v_sql || ' AND DN_EQUIPMENT_NO LIKE ''' || l_v_in  || '''';
            END IF;
-- *************************************************************************************
    -- Where condition for summary tab.
        -- ELSIF (p_i_v_tab = 'SUMMARY_TAB') THEN
    END IF;

    END ADDITION_WHERE_CONDTIONS_LL;

    PROCEDURE PRE_ELL_LL_OVERSHIPPED (
          p_o_refLoadlistOverShipped   OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_find1                  IN  VARCHAR2
        , p_i_v_in1                    IN  VARCHAR2
        , p_i_v_find2                  IN  VARCHAR2
        , p_i_v_in2                    IN  VARCHAR2
        , p_i_v_order1                 IN  VARCHAR2
        , p_i_v_order1order            IN  VARCHAR2
        , p_i_v_order2                 IN  VARCHAR2
        , p_i_v_order2order            IN  VARCHAR2
        , p_i_v_load_list_id           IN  VARCHAR2
        , p_o_v_error                  OUT VARCHAR2
    ) AS
        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_err varchar2(5000);

    BEGIN

        /* Set Success Code */
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;

            -- when order1 is not not null.
            IF ( p_i_v_order1 IS NOT NULL ) THEN
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;

            --  when order1 is not null then add comma(,) after first order by clause.
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO
                , TOS_LL_OVERSHIPPED_CONTAINER.EQ_SIZE
                , TOS_LL_OVERSHIPPED_CONTAINER.EQ_TYPE
                , TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO' ;
        END IF;

        -- Construct the SQL
        g_v_sql := 'SELECT
            TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO BOOKING_NO                                  ,
            DECODE(TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO_SOURCE, ''I'',''Manual Input'',''E'',''EDI'',''S'',''Split'') BOOKING_NO_SOURCE,
            TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO EQUIPMENT_NO                              ,
            CASE WHEN TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO IS NOT NULL THEN
              ( SELECT IDP002.TYBLNO
              FROM  IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE IDP055.EYBLNO  = IDP002.TYBLNO
              AND IDP055.EYBLNO      = IDP010.AYBLNO
              AND IDP002.TYBLNO      = IDP010.AYBLNO
              AND IDP010.AYSTAT     >=1
              AND IDP010.AYSTAT     <=6
              AND IDP010.part_of_bl IS NULL
              AND IDP002.TYBKNO      = TOS_LL_OVERSHIPPED_CONTAINER.BOOKING_NO
              AND IDP055.EYEQNO      = TOS_LL_OVERSHIPPED_CONTAINER.EQUIPMENT_NO
              AND ROWNUM=''1''
              )
            ELSE
              ''''
            END BLNO,
            TOS_LL_OVERSHIPPED_CONTAINER.EQ_SIZE EQ_SIZE                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.EQ_TYPE EQ_TYPE                                 ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_MT_OVLD'', TOS_LL_OVERSHIPPED_CONTAINER.FULL_MT) FULL_MT,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_BTYP_OVLD'', TOS_LL_OVERSHIPPED_CONTAINER.BKG_TYP) BKG_TYP,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_OC_OVLD'', TOS_LL_OVERSHIPPED_CONTAINER.FLAG_SOC_COC) FLAG_SOC_COC,
            TOS_LL_OVERSHIPPED_CONTAINER.SHIPMENT_TERM SHIPMENT_TERM                     ,
            TOS_LL_OVERSHIPPED_CONTAINER.SHIPMENT_TYPE SHIPMENT_TYPE                     ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_PODSTS_OVLD'', TOS_LL_OVERSHIPPED_CONTAINER.LOCAL_STATUS) LOCAL_STATUS,
            TOS_LL_OVERSHIPPED_CONTAINER.LOCAL_TERMINAL_STATUS LOCAL_TERMINAL_STATUS     ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_MS_OVLD'', TOS_LL_OVERSHIPPED_CONTAINER.MIDSTREAM_HANDLING_CODE) MIDSTREAM_HANDLING_CODE,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_LC_BOOK'', TOS_LL_OVERSHIPPED_CONTAINER.LOAD_CONDITION) LOAD_CONDITION,
            TOS_LL_OVERSHIPPED_CONTAINER.STOWAGE_POSITION STOWAGE_POSITION               ,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.ACTIVITY_DATE_TIME,''DD/MM/YYYY HH24:MI'') ACTIVITY_DATE_TIME ,
            TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_GROSS_WEIGHT CONTAINER_GROSS_WEIGHT   ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_DMG_OVLD'', TOS_LL_OVERSHIPPED_CONTAINER.DAMAGED) DAMAGED,
            DECODE(TOS_LL_OVERSHIPPED_CONTAINER.VOID_SLOT,0,'''') VOID_SLOT ,
            DECODE(TOS_LL_OVERSHIPPED_CONTAINER.PREADVICE_FLAG,''Y'',''Yes'',''N'',''No'')    PREADVICE_FLAG ,
            TOS_LL_OVERSHIPPED_CONTAINER.SLOT_OPERATOR SLOT_OPERATOR                     ,
            TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_OPERATOR CONTAINER_OPERATOR           ,
            TOS_LL_OVERSHIPPED_CONTAINER.OUT_SLOT_OPERATOR OUT_SLOT_OPERATOR             ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_SPL_HAND_OVLD'', TOS_LL_OVERSHIPPED_CONTAINER.SPECIAL_HANDLING) SPECIAL_HANDLING,
            TOS_LL_OVERSHIPPED_CONTAINER.SEAL_NO SEAL_NO                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.DISCHARGE_PORT DISCHARGE_PORT                   ,
            TOS_LL_OVERSHIPPED_CONTAINER.POD_TERMINAL POD_TERMINAL                       ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_POD1 NXT_POD1                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_POD2 NXT_POD2                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_POD3 NXT_POD3                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.FINAL_POD FINAL_POD                             ,
            TOS_LL_OVERSHIPPED_CONTAINER.FINAL_DEST FINAL_DEST                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_SRV NXT_SRV                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_VESSEL NXT_VESSEL                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_VOYAGE NXT_VOYAGE                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.NXT_DIR NXT_DIR                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_VESSEL MLO_VESSEL                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_VOYAGE MLO_VOYAGE                           ,
            TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.MLO_VESSEL_ETA,''DD/MM/YYYY HH24:MI'') MLO_VESSEL_ETA,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_POD1 MLO_POD1                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_POD2 MLO_POD2                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_POD3 MLO_POD3                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.MLO_DEL MLO_DEL                                 ,
            TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VESSEL                                   ,
                  TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VOYAGE                                   ,
                  TO_CHAR(TOS_LL_OVERSHIPPED_CONTAINER.EX_MLO_VESSEL_ETA,''DD/MM/YYYY HH24:MI'')    EX_MLO_VESSEL_ETA ,
            TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_1 HANDLING_INSTRUCTION_1   ,
            HI1.SHI_DESCRIPTION HANDLING_DISCRIPTION_1                                    ,
            TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_2 HANDLING_INSTRUCTION_2   ,
            HI2.SHI_DESCRIPTION HANDLING_DISCRIPTION_2                                    ,
            TOS_LL_OVERSHIPPED_CONTAINER.HANDLING_INSTRUCTION_3 HANDLING_INSTRUCTION_3   ,
            HI3.SHI_DESCRIPTION HANDLING_DISCRIPTION_3                                    ,
            SHP041_CLR1.CLR_DESC CONTAINER_LOADING_REM_1,
            SHP041_CLR2.CLR_DESC CONTAINER_LOADING_REM_2,
            TOS_LL_OVERSHIPPED_CONTAINER.SPECIAL_CARGO SPECIAL_CARGO                     ,
            TOS_LL_OVERSHIPPED_CONTAINER.IMDG_CLASS IMDG_CLASS                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.UN_NUMBER UN_NUMBER                             ,
            TOS_LL_OVERSHIPPED_CONTAINER.UN_NUMBER_VARIANT UN_VAR                        ,
            TOS_LL_OVERSHIPPED_CONTAINER.PORT_CLASS PORT_CLASS                           ,
            TOS_LL_OVERSHIPPED_CONTAINER.PORT_CLASS_TYPE PORT_CLASS_TYPE                 ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_U_BOOK'', TOS_LL_OVERSHIPPED_CONTAINER.FLASHPOINT_UNIT) FLASHPOINT_UNIT ,
            TOS_LL_OVERSHIPPED_CONTAINER.FLASHPOINT FLASHPOINT                           ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_FUM_BOOK'', TOS_LL_OVERSHIPPED_CONTAINER.FUMIGATION_ONLY) FUMIGATION_ONLY,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_RS_OVLD'', TOS_LL_OVERSHIPPED_CONTAINER.RESIDUE_ONLY_FLAG) RESIDUE_ONLY_FLAG,
            TOS_LL_OVERSHIPPED_CONTAINER.OVERHEIGHT_CM OVERHEIGHT_CM                     ,
            TOS_LL_OVERSHIPPED_CONTAINER.OVERWIDTH_LEFT_CM OVERWIDTH_LEFT_CM             ,
            TOS_LL_OVERSHIPPED_CONTAINER.OVERWIDTH_RIGHT_CM OVERWIDTH_RIGHT_CM           ,
            TOS_LL_OVERSHIPPED_CONTAINER.OVERLENGTH_FRONT_CM OVERLENGTH_FRONT_CM         ,
            TOS_LL_OVERSHIPPED_CONTAINER.OVERLENGTH_REAR_CM OVERLENGTH_REAR_CM           ,
            TOS_LL_OVERSHIPPED_CONTAINER.REEFER_TEMPERATURE REEFER_TEMPERATURE           ,
            PCE_EDL_EXCELDOWNLOAD.FN_REFEER_TEMP_GET_CONFIG_DESC(TOS_LL_OVERSHIPPED_CONTAINER.REEFER_TMP_UNIT) REEFER_TMP_UNIT,
            TOS_LL_OVERSHIPPED_CONTAINER.HUMIDITY HUMIDITY                               ,
            TOS_LL_OVERSHIPPED_CONTAINER.VENTILATION VENTILATION                         ,
            TOS_LL_OVERSHIPPED_CONTAINER.DA_ERROR DA_ERROR,
            TOS_LL_OVERSHIPPED_CONTAINER.VGM VGM  --*4
        FROM TOS_LL_OVERSHIPPED_CONTAINER ,
            SHP007 HI1,
            SHP007 HI2,
            SHP007 HI3,
                  SHP041 SHP041_CLR1,
                  SHP041 SHP041_CLR2
        WHERE HANDLING_INSTRUCTION_1 = HI1.SHI_CODE(+)
            AND    HANDLING_INSTRUCTION_2 = HI2.SHI_CODE(+)
            AND    HANDLING_INSTRUCTION_3 = HI3.SHI_CODE(+)
            AND    TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_LOADING_REM_1 = SHP041_CLR1.CLR_CODE (+)
            AND    TOS_LL_OVERSHIPPED_CONTAINER.CONTAINER_LOADING_REM_2 = SHP041_CLR2.CLR_CODE (+)
            AND    TOS_LL_OVERSHIPPED_CONTAINER.fk_load_list_id= ''' || p_i_v_load_list_id || '''
            AND    TOS_LL_OVERSHIPPED_CONTAINER.RECORD_STATUS = ''A'' ';

        -- Additional where clause conditions.
        IF(p_i_v_in1 IS NOT NULL) THEN
            -- This function add the additional where clauss condtions in
            -- Dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_LL(p_i_v_in1, p_i_v_find1, 'OVERSHIPPED_TAB');
        END IF;

        IF(p_i_v_in2 IS NOT NULL) THEN
            -- This function add the additional where clauss condtions in
            -- Dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_LL(p_i_v_in2, p_i_v_find2, 'OVERSHIPPED_TAB');
        END IF;

        g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

        -- Execute the SQL
        OPEN p_o_refLoadlistOverShipped FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    END PRE_ELL_LL_OVERSHIPPED;

     PROCEDURE PRE_ELL_LL_RESTOWED (
          p_o_refLoadlistRestowed   OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_find1               IN  VARCHAR2
        , p_i_v_in1                 IN  VARCHAR2
        , p_i_v_find2               IN  VARCHAR2
        , p_i_v_in2                 IN  VARCHAR2
        , p_i_v_order1              IN  VARCHAR2
        , p_i_v_order1order         IN  VARCHAR2
        , p_i_v_order2              IN  VARCHAR2
        , p_i_v_order2order         IN  VARCHAR2
        , p_i_v_load_list_id        IN  VARCHAR2
        , p_o_v_error               OUT VARCHAR2
    ) AS
        l_v_SQL_SORT_ORDER VARCHAR2(4000);

    BEGIN

        /* Set Success Code */
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;

            IF ( p_i_v_order1 IS NOT NULL ) THEN
                -- when order1 is not not null.
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                --  when order1 is not null then add comma(,) after first order by clause.
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                    l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_RESTOW.FK_BOOKING_NO
                , TOS_RESTOW.DN_EQ_SIZE
                , TOS_RESTOW.DN_EQ_TYPE
                , TOS_RESTOW.DN_EQUIPMENT_NO' ;
        END IF;

        /* Construct the SQL */
        g_v_sql := ' SELECT
            TOS_RESTOW.FK_BOOKING_NO FK_BOOKING_NO                              ,
            TOS_RESTOW.DN_EQUIPMENT_NO DN_EQUIPMENT_NO                          ,
            TOS_RESTOW.DN_EQ_SIZE DN_EQ_SIZE                                    ,
            TOS_RESTOW.DN_EQ_TYPE DN_EQ_TYPE                                    ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_OC_OVLD'', TOS_RESTOW.DN_SOC_COC) DN_SOC_COC,
            TOS_RESTOW.DN_SHIPMENT_TERM DN_SHIPMENT_TERM                        ,
            TOS_RESTOW.DN_SHIPMENT_TYP DN_SHIPMENT_TYP                          ,
            TOS_RESTOW.MIDSTREAM_HANDLING_CODE MIDSTREAM_HANDLING_CODE          ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_LC_BOOK'', TOS_RESTOW.LOAD_CONDITION ) LOAD_COND,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_RESTS_RESTW'', TOS_RESTOW.RESTOW_STATUS) RESTOW_STATUS,
            TOS_RESTOW.STOWAGE_POSITION STOWAGE_POSITION                        ,
            TO_CHAR(TOS_RESTOW.ACTIVITY_DATE_TIME,''DD/MM/YYYY HH24:MI'') ACTIVITY_DATE_TIME,
            TOS_RESTOW.CONTAINER_GROSS_WEIGHT CONTAINER_GROSS_WEIGHT            ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_DMG_OVLD'', TOS_RESTOW.DAMAGED) DAMAGED,
            DECODE(TOS_RESTOW.VOID_SLOT,0,'''') VOID_SLOT ,
            TOS_RESTOW.FK_SLOT_OPERATOR FK_SLOT_OPERATOR                        ,
            TOS_RESTOW.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR              ,
            PCE_EDL_EXCELDOWNLOAD.FN_GET_CONFIG_DESC(''DL_SPL_HAND_OVLD'', TOS_RESTOW.DN_SPECIAL_HNDL) DN_SPECIAL_HNDL,
            TOS_RESTOW.SEAL_NO SEAL_NO                                         ,
            TOS_RESTOW.FK_SPECIAL_CARGO FK_SPECIAL_CARGO                        ,
            TOS_RESTOW.PUBLIC_REMARK PUBLIC_REMARK
            FROM TOS_RESTOW
            WHERE TOS_RESTOW.FK_LOAD_LIST_ID = ''' || p_i_v_load_list_id || '''
            AND TOS_RESTOW.RECORD_STATUS = ''A'' ';

    -- Additional where clause conditions.
    IF(p_i_v_in1 IS NOT NULL) THEN
        -- this function add the additional where clauss condtions in
        -- dynamic sql according to the passed parameter.
        ADDITION_WHERE_CONDTIONS_LL(p_i_v_in1, p_i_v_find1, 'RESTOW_TAB');
    END IF;

    IF(p_i_v_in2 IS NOT NULL) THEN
        -- this function add the additional where clauss condtions in
        -- dynamic sql according to the passed parameter.
        ADDITION_WHERE_CONDTIONS_LL(p_i_v_in2, p_i_v_find2, 'RESTOW_TAB');
    END IF;

    g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

    /* Execute the SQL */
    OPEN p_o_refLoadlistRestowed FOR g_v_sql;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

        WHEN OTHERS THEN
            p_o_v_error := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
            RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));

    END PRE_ELL_LL_RESTOWED;

    /* Funciton to get Config description */
    FUNCTION FN_GET_CONFIG_DESC (
          p_i_v_type        VARCHAR2
        , p_i_v_cd          VARCHAR2
    )
    RETURN VARCHAR2
    IS
        l_v_desc      VARCHAR(50);
    BEGIN

        SELECT CONFIG_DESC
        INTO l_v_desc
        FROM VCM_CONFIG_MST
        WHERE CONFIG_TYP = p_i_v_type
        AND CONFIG_CD = p_i_v_cd;

        RETURN l_v_desc;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            RETURN NULL;
    END; /* END OF FUNCTION  FN_GET_CONFIG_DESC*/


    /* Funciton to get Config description for reefer temprature unit*/
    FUNCTION FN_REFEER_TEMP_GET_CONFIG_DESC (
        p_i_v_cd          VARCHAR2
    )
    RETURN VARCHAR2
    IS
        l_v_desc      VARCHAR(50);
    BEGIN

        IF(p_i_v_cd = 'C') THEN
            l_v_desc := 'CEL';
        ELSIF (p_i_v_cd = 'F') THEN
            l_v_desc := 'FAH';
        END IF;

        RETURN l_v_desc;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            RETURN NULL;
    END; /* END OF FUNCTION  FN_REFEER_TEMP_GET_CONFIG_DESC*/

  PROCEDURE PRE_ELL_LL_BOOKED_FORMAT(
          p_o_refLoadlistBooked    OUT PCE_ECM_REF_CUR.ECM_REF_CUR
        , p_i_v_find1              IN  VARCHAR2
        , p_i_v_in1                IN  VARCHAR2
        , p_i_v_find2              IN  VARCHAR2
        , p_i_v_in2                IN  VARCHAR2
        , p_i_v_order1             IN  VARCHAR2
        , p_i_v_order1order        IN  VARCHAR2
        , p_i_v_order2             IN  VARCHAR2
        , p_i_v_order2order        IN  VARCHAR2
        , p_i_v_load_list_id       IN  VARCHAR2
        , p_o_v_error              OUT VARCHAR2
    )  AS

        l_v_SQL_SORT_ORDER VARCHAR2(4000);
        l_v_err   varchar2(5000);

    BEGIN

        /* Set Success Code*/
        p_o_v_error    := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        -- sorting on the basis of sort order
        IF (p_i_v_order1 IS NOT NULL) OR (p_i_v_order2 IS NOT NULL) THEN
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' ;
            -- when order1 is not not null.
            IF ( p_i_v_order1 IS NOT NULL ) THEN
                l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || p_i_v_order1 || ' ' || p_i_v_order1order;
            END IF;
            -- when order2 is not not null.
            IF ( p_i_v_order2 IS NOT NULL ) THEN
                --  when order1 is not null then add comma(,) after first order by clause.
                IF ( p_i_v_order1 IS NOT NULL ) THEN
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' , ' || p_i_v_order2 || ' ' || p_i_v_order2order;
                ELSE
                  l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' '   || p_i_v_order2 || ' ' || p_i_v_order2order;
                END IF;
            END IF;
        ELSE
            -- Default sort order.
            l_v_SQL_SORT_ORDER := l_v_SQL_SORT_ORDER || ' ORDER BY ' || 'TOS_LL_BOOKED_LOADING.fk_booking_no
                , TOS_LL_BOOKED_LOADING.dn_eq_size
                , TOS_LL_BOOKED_LOADING.dn_eq_type
                , TOS_LL_BOOKED_LOADING.dn_equipment_no' ;
        END IF;

        /* Construct the SQL */
       g_v_sql := ' SELECT
          ''LOAD'' ACTIVITY_CODE,
          TOS_LL_LOAD_LIST.DN_PORT DN_PORT,
          TOS_LL_LOAD_LIST.DN_TERMINAL DN_TERMINAL,
          TOS_LL_LOAD_LIST.FK_VESSEL FK_VESSEL,
          TOS_LL_LOAD_LIST.FK_VOYAGE FK_VOYAGE,
          ITP060.VSLGNM VSLGNM,
          BKP001.BAORGN BAORGN,
          BKP001.BAPOL BAPOL ,
          TOS_LL_BOOKED_LOADING.DN_DISCHARGE_PORT BAPOD,
          TOS_LL_BOOKED_LOADING.FINAL_DEST FINAL_DEST ,
          BKP001.BADSTN BADSTN,
          TOS_LL_BOOKED_LOADING.STOWAGE_POSITION STOWAGE_POSITION ,
          TO_CHAR(TOS_LL_BOOKED_LOADING.ACTIVITY_DATE_TIME,  ''DD-MON-YY'') ACTIVITY_DATE_TIME,
          TOS_LL_BOOKED_LOADING.FK_SLOT_OPERATOR FK_SLOT_OPERATOR ,
          TOS_LL_BOOKED_LOADING.FK_CONTAINER_OPERATOR FK_CONTAINER_OPERATOR ,
          TOS_LL_BOOKED_LOADING.FK_BOOKING_NO FK_BOOKING_NO ,
          CASE WHEN DN_EQUIPMENT_NO IS NOT NULL THEN
            (   SELECT IDP002.TYBLNO
              FROM   IDP055 IDP055, IDP002 IDP002, IDP010 IDP010
              WHERE  IDP055.EYBLNO  = IDP002.TYBLNO
              AND    IDP055.EYBLNO  = IDP010.AYBLNO
              AND    IDP002.TYBLNO  = IDP010.AYBLNO
              AND    IDP010.AYSTAT  >=1
              AND    IDP010.AYSTAT  <=6
              AND    IDP010.PART_OF_BL IS NULL
              AND    IDP002.TYBKNO  = FK_BOOKING_NO
              AND    IDP055.EYEQNO  = DN_EQUIPMENT_NO
              AND ROWNUM=''1'')
            ELSE
              ''''
          END BLNO,
          '''' JOB_NO,
          TOS_LL_BOOKED_LOADING.DN_EQUIPMENT_NO DN_EQUIPMENT_NO ,
          TOS_LL_BOOKED_LOADING.DN_EQ_SIZE ,
          TOS_LL_BOOKED_LOADING.DN_EQ_TYPE ,
          TOS_LL_BOOKED_LOADING.LOCAL_STATUS LOCAL_STATUS ,
          TOS_LL_BOOKED_LOADING.DN_FULL_MT DN_FULL_MT ,
          TOS_LL_BOOKED_LOADING.CONTAINER_GROSS_WEIGHT CONTAINER_GROSS_WEIGHT ,
          ''KGM'' GROSS_WEIGHT_UOM ,
          ''CM'' LENGTH_UOM ,
          TOS_LL_BOOKED_LOADING.OVERLENGTH_FRONT_CM OVERLENGTH_FRONT_CM ,
          TOS_LL_BOOKED_LOADING.OVERLENGTH_REAR_CM OVERLENGTH_REAR_CM ,
          TOS_LL_BOOKED_LOADING.OVERWIDTH_RIGHT_CM OVERWIDTH_RIGHT_CM ,
          TOS_LL_BOOKED_LOADING.OVERWIDTH_LEFT_CM OVERWIDTH_LEFT_CM ,
          TOS_LL_BOOKED_LOADING.OVERHEIGHT_CM OVERHEIGHT_CM ,
          TOS_LL_BOOKED_LOADING.REEFER_TMP REEFER_TEMPERATURE ,
          PCE_EDL_EXCELDOWNLOAD.FN_REFEER_TEMP_GET_CONFIG_DESC(TOS_LL_BOOKED_LOADING.REEFER_TMP_UNIT) REEFER_TMP_UNIT,
          TOS_LL_BOOKED_LOADING.FK_IMDG FK_IMDG ,
          TOS_LL_BOOKED_LOADING.FK_UNNO FK_UNNO ,
          TOS_LL_BOOKED_LOADING.MLO_VOYAGE MLO_VOYAGE ,
          TOS_LL_BOOKED_LOADING.MLO_VESSEL MLO_VESSEL ,
          TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_1 FK_HANDLING_INSTRUCTION_1 ,
          TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_2 FK_HANDLING_INSTRUCTION_2 ,
          TOS_LL_BOOKED_LOADING.FK_HANDLING_INSTRUCTION_3 FK_HANDLING_INSTRUCTION_3 ,
          TOS_LL_BOOKED_LOADING.RECORD_ADD_USER RECORD_ADD_USER ,
          TO_CHAR(TOS_LL_BOOKED_LOADING.RECORD_ADD_DATE, ''DD-MON-YY'') RECORD_ADD_DATE,
          TOS_LL_BOOKED_LOADING.VGM VGM --*4

      FROM
          SHP007 HI1                   ,
          SHP007 HI2                   ,
          SHP007 HI3                   ,
          SHP041 SHP041_CLR1           ,
          SHP041 SHP041_CLR2    ,
              TOS_LL_LOAD_LIST TOS_LL_LOAD_LIST,
              TOS_LL_BOOKED_LOADING TOS_LL_BOOKED_LOADING,
          ITP060 ITP060,
              BKP001 BKP001
      WHERE
              FK_HANDLING_INSTRUCTION_1                           = HI1.SHI_CODE(+)
        AND FK_HANDLING_INSTRUCTION_2                       = HI2.SHI_CODE(+)
        AND FK_HANDLING_INSTRUCTION_3                       = HI3.SHI_CODE(+)
        AND TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_1 = SHP041_CLR1.CLR_CODE (+)
        AND TOS_LL_BOOKED_LOADING.CONTAINER_LOADING_REM_2 = SHP041_CLR2.CLR_CODE (+)
        AND TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID = ''' || p_i_v_load_list_id || '''
              AND TOS_LL_LOAD_LIST.PK_LOAD_LIST_ID = TOS_LL_BOOKED_LOADING.FK_LOAD_LIST_ID
        AND ITP060.VSVESS = TOS_LL_LOAD_LIST.FK_VESSEL
        AND TOS_LL_BOOKED_LOADING.FK_BOOKING_NO = BKP001.BABKNO (+)
        AND TOS_LL_BOOKED_LOADING.RECORD_STATUS = ''A''
              AND TOS_LL_LOAD_LIST.RECORD_STATUS = ''A'' ';

        --Where clause conditions.
        IF(p_i_v_in1 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_LL(p_i_v_in1, p_i_v_find1, 'BOOKED_TAB');
        END IF;

        IF(p_i_v_in2 IS NOT NULL) THEN
            -- this function add the additional where clauss condtions in
            -- dynamic sql according to the passed parameter.
            ADDITION_WHERE_CONDTIONS_LL(p_i_v_in2, p_i_v_find2, 'BOOKED_TAB');
        END IF;

        g_v_sql :=g_v_sql || ' ' || l_v_SQL_SORT_ORDER;

        /* Execute the SQL */
        OPEN p_o_refLoadlistBooked FOR g_v_sql;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_o_v_error:= PCE_EUT_COMMON.G_V_GE0004;
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(p_o_v_error));
            WHEN OTHERS THEN
                l_v_err := SUBSTR(SQLCODE,1,10) || ':' || SUBSTR(SQLERRM,1,100);
                RAISE_APPLICATION_ERROR(PCE_EUT_COMMON.G_V_USER_ERR_CD,PCE_EUT_COMMON.FN_EUT_GEN_VAS_ERROR(l_v_err));
    END PRE_ELL_LL_BOOKED_FORMAT;

END PCE_EDL_EXCELDOWNLOAD;