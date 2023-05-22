create or replace PROCEDURE "BKP009_HANDLER" (in_any IN ANYDATA) IS
/********************************************************************************
* Name           : BKP009_HANDLER                                               *
* Module         : EZLL_ADMIN                                                   *
* Purpose        : This  Stored  Procedure is capture update,insert,delete on   *
                   BKP009 TABLE USING streams.                                  *
* Calls          : VASAPPS.PRE_TOS_EQUIPMENT_ADD                                *
*                : VASAPPS.PRE_TOS_EQUIPMENT_REMOVE                             *
*                : VASAPPS.PRE_TOS_EQUIPMENT_UPDATE                             *
* Returns        : NONE                                                         *
* Steps Involved :                                                              *
* History        : None                                                         *
* Author           Date          What                                           *
* ---------------  ----------    ----                                           *
* Avdhesh          12/01/2011     1.0                                           *
* *1 Vikas            10/09/2012     get user name of bkp009   
* *2 WACCHO1	   08/08/2016	  flow WEIGHT/Category to EZLL/EZDL.
* *3 WACCHO1  	   16/08/2016     FLOW VGM TO EZLL/EZDL.
*********************************************************************************/
       lcr          SYS.LCR$_ROW_RECORD;
       rc           PLS_INTEGER;
       command      VARCHAR2(30);
       old_values   SYS.LCR$_ROW_LIST;
       res          number;
   /*variable to hold lcr values*/

    p_i_v_booking_no          sealiner.BKP009.BIBKNO%TYPE;
    p_i_n_equipment_seq_no    sealiner.BKP009.BISEQN%TYPE;
    p_i_v_old_equipment_no    sealiner.BKP009.BICTRN%TYPE;
    p_i_v_new_equipment_no    sealiner.BKP009.BICTRN%TYPE;
    p_i_n_overheight          sealiner.BKP009.BIXHGT%TYPE;
    p_i_n_overlength_rear     sealiner.BKP009.BIXLNB%TYPE;
    p_i_n_overlength_front    sealiner.BKP009.BIXLNF%TYPE;
    p_i_n_overwidth_left      sealiner.BKP009.BIXWDL%TYPE;
    p_i_n_overwidth_right     sealiner.BKP009.BIXWDR%TYPE;

    p_i_v_imdg_old            sealiner.BKP009.BIIMCL%TYPE;
    p_i_v_imdg_new            sealiner.BKP009.BIIMCL%TYPE;
    p_i_v_imdg                sealiner.BKP009.BIIMCL%TYPE;

    p_i_v_unno_old            sealiner.BKP009.BIUNN%TYPE;
    p_i_v_unno_new            sealiner.BKP009.BIUNN%TYPE;
    p_i_v_unno                sealiner.BKP009.BIUNN%TYPE;

    p_i_v_un_var_old          sealiner.BKP009.UN_VARIANT%TYPE;
    p_i_v_un_var_new          sealiner.BKP009.UN_VARIANT%TYPE;
    p_i_v_un_var              sealiner.BKP009.UN_VARIANT%TYPE;

    p_i_v_flash_point_old     sealiner.BKP009.BIFLPT%TYPE;
    p_i_v_flash_point_new     sealiner.BKP009.BIFLPT%TYPE;
    p_i_v_flash_point         VARCHAR2(7);

    p_i_n_flash_unit_old      sealiner.BKP009.BIFLBS%TYPE;
    p_i_n_flash_unit_new      sealiner.BKP009.BIFLBS%TYPE;
    p_i_n_flash_unit          sealiner.BKP009.BIFLBS%TYPE;

    p_i_n_reefer_tmp_old      sealiner.BKP009.BIRFFM%TYPE;
    p_i_n_reefer_tmp_new      sealiner.BKP009.BIRFFM%TYPE;
    p_i_n_reefer_tmp          VARCHAR2(7);

    p_i_v_reefer_tmp_unit_old sealiner.BKP009.BIRFBS%TYPE;
    p_i_v_reefer_tmp_unit_new sealiner.BKP009.BIRFBS%TYPE;
    p_i_v_reefer_tmp_unit     sealiner.BKP009.BIRFBS%TYPE;

    p_i_n_humidity            sealiner.BKP009.HUMIDITY%TYPE;
    p_i_n_size_type_seq_no    sealiner.BKP032.EQP_SIZETYPE_SEQNO%TYPE;
    p_i_n_supplier_seq_no     sealiner.BKP009.SUPPLIER_SQNO%TYPE;

    p_i_n_ventilation_old     sealiner.BKP009.AIR_PRESSURE%TYPE;
    p_i_n_ventilation_new     sealiner.BKP009.AIR_PRESSURE%TYPE;
    p_i_n_ventilation         sealiner.BKP009.AIR_PRESSURE%TYPE;

    P_o_v_return_status       VARCHAR(1);
    p_o_v_exec_flg            VARCHAR2(1);

    P_I_V_USER_ID             sealiner.BKP009.BICUSR%TYPE; -- *1
    /*variable to hold lcr values*/
	
    -- start *2
	P_I_V_WEIGHT			  SEALINER.BKP009.MET_WEIGHT%TYPE ;
	P_I_V_VGM_CATEGORY		  SEALINER.BKP009.EQP_CATEGORY%TYPE;
	-- end *2 
	
	--START *3 
	P_I_V_VGM				  SEALINER.BKP009.EQP_VGM%TYPE;
	--END *3

    BEGIN
      rc := in_any.GETOBJECT(lcr);
      command := lcr.GET_COMMAND_TYPE();
      command := upper(command);

      IF command = 'INSERT' THEN

        if (LCR.GET_VALUE('new','BIBKNO')) is not null then
           res := LCR.GET_VALUE('new','BIBKNO').getvarchar2(p_i_v_booking_no);
        end if;

        if (LCR.GET_VALUE('new','BISEQN')) is not null then
           res := LCR.GET_VALUE('new','BISEQN').getnumber(p_i_n_equipment_seq_no);
        end if;
        if (LCR.GET_VALUE('new','SUPPLIER_SQNO')) is not null then
           res := LCR.GET_VALUE('new','SUPPLIER_SQNO').getnumber(p_i_n_supplier_seq_no);
        end if;

        BEGIN
          select SEQ_NO.eqp_sizetype_seqno into p_i_n_size_type_seq_no
          from sealiner.BKP009 cntr,
          (select booking_no,supplier_sqno,eqp_sizetype_seqno from sealiner.booking_supplier_detail sp
          where exists (select 'X' from sealiner.bkp032 sz
          where sp.booking_no = sz.bcbkno
          and sp.eqp_sizetype_seqno = sz.eqp_sizetype_seqno
          )) SEQ_NO
          where cntr.bibkno = SEQ_NO.booking_no
          and cntr.supplier_sqno = SEQ_NO.supplier_sqno
          and cntr.biseqn = p_i_n_equipment_seq_no
          and cntr.bibkno = p_i_v_booking_no;
         EXCEPTION
            WHEN no_data_found THEN
               p_i_n_size_type_seq_no :=NULL;
            WHEN OTHERS THEN
              p_i_n_size_type_seq_no :=NULL;
        END ;
        /* Update booking bkp009_ezll_tmp table */
        /* INSERT */
        BEGIN
            INSERT INTO BK009_EZLL_TMP (
                BOOKING_NO,
                EQUIPMENT_SEQ_NO,
                SIZE_TYPE_SEQ_NO,
                SUPPLIER_SEQ_NO,
                OPERATION_TYPE,
                RECORD_ADD_DATE
            ) VALUES (
                p_i_v_booking_no,
                p_i_n_equipment_seq_no,
                p_i_n_size_type_seq_no,
                p_i_n_supplier_seq_no,
                command,
                CURRENT_TIMESTAMP
            );
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_CHECK_CREATE_LL_DL(p_i_v_booking_no, P_o_v_return_status, p_o_v_exec_flg);
        IF p_o_v_exec_flg = 'N' THEN
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_ADD(p_i_v_booking_no,
                                                              p_i_n_equipment_seq_no,
                                                              p_i_n_size_type_seq_no,
                                                              p_i_n_supplier_seq_no  ,
                                                              P_o_v_return_status
                                                            ) ;
        END IF;
      END IF;

      IF command = 'DELETE' THEN
        if (LCR.GET_VALUE('old','BIBKNO')) is not null then
           res := LCR.GET_VALUE('old','BIBKNO').getvarchar2(p_i_v_booking_no);
        end if;

        if (LCR.GET_VALUE('old','BISEQN')) is not null then
           res := LCR.GET_VALUE('old','BISEQN').getnumber(p_i_n_equipment_seq_no);
        end if;

        /* Update booking bkp009_ezll_tmp table */
        /* DELETE */
        BEGIN
            INSERT INTO BK009_EZLL_TMP (
                BOOKING_NO,
                EQUIPMENT_SEQ_NO,
                OPERATION_TYPE,
                RECORD_ADD_DATE
            ) VALUES (
                p_i_v_booking_no,
                p_i_n_equipment_seq_no,
                command,
                CURRENT_TIMESTAMP
            );
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_CHECK_CREATE_LL_DL(p_i_v_booking_no, P_o_v_return_status, p_o_v_exec_flg);
        IF p_o_v_exec_flg = 'N' THEN
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_REMOVE(p_i_v_booking_no,
                                                                p_i_n_equipment_seq_no,
                                                                P_o_v_return_status
                                                               ) ;
        END IF;
      END IF;


       IF command = 'UPDATE' THEN
        if (LCR.GET_VALUE('new','BIBKNO')) is not null then
           res := LCR.GET_VALUE('new','BIBKNO').getvarchar2(p_i_v_booking_no);
        end if;

        if (LCR.GET_VALUE('new','BISEQN')) is not null then
           res := LCR.GET_VALUE('new','BISEQN').getnumber(p_i_n_equipment_seq_no);
        end if;

        if (LCR.GET_VALUE('old','BICTRN')) is not null then
           res := LCR.GET_VALUE('old','BICTRN').getvarchar2(p_i_v_old_equipment_no);
        end if;
        if (LCR.GET_VALUE('new','BICTRN')) is not null then
           res := LCR.GET_VALUE('new','BICTRN').getvarchar2(p_i_v_new_equipment_no);
        end if;


        if (LCR.GET_VALUE('new','BIXHGT')) is not null then
           res := LCR.GET_VALUE('new','BIXHGT').getnumber(p_i_n_overheight);
        end if;

        if (LCR.GET_VALUE('new','BIXLNB')) is not null then
           res := LCR.GET_VALUE('new','BIXLNB').getnumber(p_i_n_overlength_rear);
        end if;

        if (LCR.GET_VALUE('new','BIXLNF')) is not null then
           res := LCR.GET_VALUE('new','BIXLNF').getnumber(p_i_n_overlength_front);
        end if;

        if (LCR.GET_VALUE('new','BIXWDL')) is not null then
           res := LCR.GET_VALUE('new','BIXWDL').getnumber(p_i_n_overwidth_left);
        end if;

        if (LCR.GET_VALUE('new','BIXWDR')) is not null then
           res := LCR.GET_VALUE('new','BIXWDR').getnumber(p_i_n_overwidth_right);
        end if;

        if (LCR.GET_VALUE('old','UN_VARIANT')) is not null then
           res := LCR.GET_VALUE('old','UN_VARIANT').getvarchar2(p_i_v_un_var_old);
        end if;

        if (LCR.GET_VALUE('new','UN_VARIANT')) is not null then
           res := LCR.GET_VALUE('new','UN_VARIANT').getvarchar2(p_i_v_un_var_new);
        end if;

        IF p_i_v_un_var_new IS NOT NULL THEN
            p_i_v_un_var := p_i_v_un_var_new;
        ELSIF p_i_v_un_var_old IS NOT NULL THEN
            p_i_v_un_var := '~';
        ELSE
            p_i_v_un_var := NULL;
        END IF;

        if (LCR.GET_VALUE('old','BIFLPT')) is not null then
           res := LCR.GET_VALUE('old','BIFLPT').getnumber(p_i_v_flash_point_old);
        end if;

        if (LCR.GET_VALUE('new','BIFLPT')) is not null then
           res := LCR.GET_VALUE('new','BIFLPT').getnumber(p_i_v_flash_point_new);
        end if;

        IF p_i_v_flash_point_new IS NOT NULL THEN
            p_i_v_flash_point := TO_CHAR(p_i_v_flash_point_new);
        ELSIF p_i_v_flash_point_old IS NOT NULL THEN
            p_i_v_flash_point := '~';
        ELSE
            p_i_v_flash_point := NULL;
        END IF;

        if (LCR.GET_VALUE('old','BIFLBS')) is not null then
           res := LCR.GET_VALUE('old','BIFLBS').getvarchar2(p_i_n_flash_unit_old);
        end if;

        if (LCR.GET_VALUE('new','BIFLBS')) is not null then
           res := LCR.GET_VALUE('new','BIFLBS').getvarchar2(p_i_n_flash_unit_new);
        end if;

        IF p_i_n_flash_unit_new IS NOT NULL THEN
            p_i_n_flash_unit := p_i_n_flash_unit_new;
        ELSIF p_i_n_flash_unit_old IS NOT NULL THEN
            p_i_n_flash_unit := '~';
        ELSE
            p_i_n_flash_unit := NULL;
        END IF;

        if (LCR.GET_VALUE('old','BIRFFM')) is not null then
           res := LCR.GET_VALUE('old','BIRFFM').getnumber(p_i_n_reefer_tmp_old);
        end if;

        if (LCR.GET_VALUE('new','BIRFFM')) is not null then
           res := LCR.GET_VALUE('new','BIRFFM').getnumber(p_i_n_reefer_tmp_new);
        end if;

        IF p_i_n_reefer_tmp_new IS NOT NULL THEN
            p_i_n_reefer_tmp := TO_CHAR(p_i_n_reefer_tmp_new);
        ELSIF p_i_n_reefer_tmp_old IS NOT NULL THEN
            p_i_n_reefer_tmp := '~';
        ELSE
            p_i_n_reefer_tmp := NULL;
        END IF;

        if (LCR.GET_VALUE('old','BIRFBS')) is not null then
           res := LCR.GET_VALUE('old','BIRFBS').getvarchar2(p_i_v_reefer_tmp_unit_old);
        end if;

        if (LCR.GET_VALUE('new','BIRFBS')) is not null then
            res := LCR.GET_VALUE('new','BIRFBS').getvarchar2(p_i_v_reefer_tmp_unit_new);
        end if;

        IF p_i_v_reefer_tmp_unit_new IS NOT NULL THEN
            p_i_v_reefer_tmp_unit := p_i_v_reefer_tmp_unit_new;
        ELSIF p_i_v_reefer_tmp_unit_old IS NOT NULL THEN
            p_i_v_reefer_tmp_unit := '~';
        ELSE
            p_i_v_reefer_tmp_unit := NULL;
        END IF;

        if (LCR.GET_VALUE('old','BIIMCL')) is not null then
           res := LCR.GET_VALUE('old','BIIMCL').getvarchar2(p_i_v_imdg_old);
        end if;

        if (LCR.GET_VALUE('new','BIIMCL')) is not null then
           res := LCR.GET_VALUE('new','BIIMCL').getvarchar2(p_i_v_imdg_new);
        end if;

        IF p_i_v_imdg_new IS NOT NULL THEN
            p_i_v_imdg := p_i_v_imdg_new;
        ELSIF p_i_v_imdg_old IS NOT NULL THEN
            p_i_v_imdg := '~';
        ELSE
            p_i_v_imdg := NULL;
        END IF;

        if (LCR.GET_VALUE('old','BIUNN')) is not null then
           res := LCR.GET_VALUE('old','BIUNN').getvarchar2(p_i_v_unno_old);
        end if;

        if (LCR.GET_VALUE('new','BIUNN')) is not null then
           res := LCR.GET_VALUE('new','BIUNN').getvarchar2(p_i_v_unno_new);
        end if;

        IF p_i_v_unno_new IS NOT NULL THEN
            p_i_v_unno := p_i_v_unno_new;
        ELSIF p_i_v_unno_old IS NOT NULL THEN
            p_i_v_unno := '~';
        ELSE
            p_i_v_unno := NULL;
        END IF;

        if (LCR.GET_VALUE('new','HUMIDITY')) is not null then
           res := LCR.GET_VALUE('new','HUMIDITY').getnumber(p_i_n_humidity);
        end if;

        if (LCR.GET_VALUE('old','AIR_PRESSURE')) is not null then
           res := LCR.GET_VALUE('old','AIR_PRESSURE').getnumber(p_i_n_ventilation_old);
        end if;

        if (LCR.GET_VALUE('new','AIR_PRESSURE')) is not null then
           res := LCR.GET_VALUE('new','AIR_PRESSURE').getnumber(p_i_n_ventilation_new);
        end if;

        IF p_i_n_ventilation_new IS NOT NULL THEN
            p_i_n_ventilation := p_i_n_ventilation_new;
        ELSIF p_i_n_ventilation_old IS NOT NULL THEN
            p_i_n_ventilation := 0;
        ELSE
            p_i_n_ventilation := NULL;
        END IF;

        /* *1 start * */
        if (LCR.GET_VALUE('new','BICUSR')) is not null then
           res := LCR.GET_VALUE('new','BICUSR').getvarchar2(P_I_V_USER_ID);
        end if;
        /* *1 end  * */
		
		-- START *2
		if (LCR.GET_VALUE('new','MET_WEIGHT')) is not null then
           res := LCR.GET_VALUE('new','MET_WEIGHT').getnumber(P_I_V_WEIGHT);
        end if;
		if (LCR.GET_VALUE('new','EQP_CATEGORY')) is not null then
           res := LCR.GET_VALUE('new','EQP_CATEGORY').getvarchar2(P_I_V_VGM_CATEGORY);
        end if;		
		-- END *2
		-- START *3 
		if (LCR.GET_VALUE('new','EQP_VGM')) is not null then
           res := LCR.GET_VALUE('new','EQP_VGM').getnumber(P_I_V_VGM);
        end if;		
		-- END *3 

        /* Update booking bkp009_ezll_tmp table */
        /* UPDATE */
        BEGIN
            INSERT INTO BK009_EZLL_TMP (
                BOOKING_NO,
                EQUIPMENT_SEQ_NO,
                OLD_EQUIPMENT_NO,
                NEW_EQUIPMENT_NO,
                OVERHEIGHT,
                OVERLENGTH_REAR,
                OVERLENGTH_FRONT,
                OVERWIDTH_LEFT,
                OVERWIDTH_RIGHT,
                IMDG,
                UNNO,
                UN_VAR,
                FLASH_POINT,
                FLASH_UNIT,
                REEFER_TMP,
                REEFER_TMP_UNIT,
                HUMIDITY,
                VENTILATION,
                OPERATION_TYPE,
                RECORD_ADD_DATE
            ) VALUES (
                p_i_v_booking_no,
                p_i_n_equipment_seq_no,
                p_i_v_old_equipment_no,
                p_i_v_new_equipment_no,
                p_i_n_overheight,
                p_i_n_overlength_rear,
                p_i_n_overlength_front,
                p_i_n_overwidth_left   ,
                p_i_n_overwidth_right  ,
                p_i_v_imdg,
                p_i_v_unno,
                p_i_v_un_var           ,
                p_i_v_flash_point      ,
                p_i_n_flash_unit       ,
                p_i_n_reefer_tmp       ,
                p_i_v_reefer_tmp_unit  ,
                p_i_n_humidity,
                p_i_n_ventilation,
                command,
                SYSDATE
            );
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_CHECK_CREATE_LL_DL(p_i_v_booking_no, P_o_v_return_status, p_o_v_exec_flg);
        IF p_o_v_exec_flg = 'N' THEN
        PCE_ECM_SYNC_BOOKING_EZLL.PRE_TOS_EQUIPMENT_UPDATE(
            p_i_v_booking_no,
            p_i_n_equipment_seq_no,
            p_i_v_old_equipment_no,
            p_i_v_new_equipment_no,
            p_i_n_overheight,
            p_i_n_overlength_rear,
            p_i_n_overlength_front,
            p_i_n_overwidth_left   ,
            p_i_n_overwidth_right  ,
            p_i_v_imdg,
            p_i_v_unno,
            p_i_v_un_var           ,
            p_i_v_flash_point      ,
            p_i_n_flash_unit       ,
            p_i_n_reefer_tmp       ,
            p_i_v_reefer_tmp_unit  ,
            p_i_n_humidity,
            p_i_n_ventilation,
            P_I_V_USER_ID, -- *1
			P_I_V_WEIGHT, --*2
			P_I_V_VGM_CATEGORY , --*2 
			P_I_V_VGM, --*3 
            P_o_v_return_status
        ) ;
        END IF;
       END IF;
   END;