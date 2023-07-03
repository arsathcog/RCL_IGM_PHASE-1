package com.rclgroup.dolphin.web.igm.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.niit.control.common.exception.BusinessException;

/**
 * The Interface ImportGeneralManifestDao.
 */
public interface ImportGeneralManifestDao {

	/** The Constant SQL_GET_IGM_DATA. */
	public static final String SQL_GET_IGM_DATA = "RCL_IGM_INFO.RCL_IGM_GET_DATA";

	/** The Constant SQL_GET_IGM_DATA. */
	public static final String SQL_GET_REFRESH_IGM_DATA = "RCL_IGM_INFO.RCL_IGM_GET_REFRESH_DATA";
	
	/** The Constant SQL_SAVE_IGM_DATA. */
	public static final String SQL_SAVE_IGM_DATA = "RCL_IGM_INFO.RCL_IGM_SAVE_DATA";
	
	/** The Constant SQL_GET_SERIAL_NUMBER. */
	public static final String SQL_SERIAL_NUMBER_DATA = "RCL_IGM_INFO.RCL_IGM_GET_SRL_NO";

	public static final String SQL_SAVE_CONTAINOR = "RCL_IGM_INFO.RCL_IGM_SAVE_CONTAINOR";
	
	/** The Constant KEY_REF_IGM_DATA. */
	public static final String KEY_REF_IGM_DATA = "P_O_REFIGMTABFIND";
	
	/** The Constant KEY_REF_IGM_DATA. */
	public static final String KEY_REF_IGM_DATA_JOB = "P_O_REFIGMTABFIND_JOB";

	/** The Constant KEY_IGM_BL. */
	public static final String KEY_IGM_BL = "P_I_V_BL";

	/** The Constant KEY_IGM_POD. */
	public static final String KEY_IGM_POD = "P_I_V_POD";

	/** The Constant KEY_IGM_SERVICE. */
	public static final String KEY_IGM_SERVICE = "P_I_V_SERVICE";

	/** The Constant KEY_IGM_VESSEL. */
	public static final String KEY_IGM_VESSEL = "P_I_V_VESSEL";

	/** The Constant KEY_IGM_VOYAGE. */
	public static final String KEY_IGM_VOYAGE = "P_I_V_VOYAGE";

	/** The Constant KEY_IGM_POD_TERMINAL. */
	public static final String KEY_IGM_POD_TERMINAL = "P_I_V_POD_TERMINAL";

	/** The Constant KEY_IGM_FROM_DATE. */
	public static final String KEY_IGM_FROM_DATE = "P_I_V_FROM_DATE";

	/** The Constant KEY_IGM_TO_DATE. */
	public static final String KEY_IGM_TO_DATE = "P_I_V_TO_DATE";

	/** The Constant KEY_IGM_BL_STATUS. */
	public static final String KEY_IGM_BL_STATUS = "P_I_V_BL_STATUS";

	/** The Constant KEY_IGM_POL. */
	public static final String KEY_IGM_POL = "P_I_V_POL";
	
	/** The Constant KEY_IGM_DEL. */
	public static final String KEY_IGM_DEL = "P_I_V_DEL";
	
	/** The Constant KEY_IGM_DEPOT. */
	public static final String KEY_IGM_DEPOT = "P_I_V_DEPOT";

	/** The Constant KEY_IGM_POL_TERMINAL. */
	public static final String KEY_IGM_POL_TERMINAL = "P_I_V_POL_TERMINAL";

	/** The Constant KEY_IGM_DIRECTION. */
	public static final String KEY_IGM_DIRECTION = "P_I_V_DIRECTION";

	/** The Constant KEY_IGM_TOT_REC. */
	public static final String KEY_IGM_TOT_REC = "P_O_V_TOT_REC";

	/** The Constant KEY_IGM_ERROR. */
	public static final String KEY_IGM_ERROR = "P_O_V_ERROR";

	/** The Constant KEY_IGM_PORT. */
	public static final String KEY_IGM_PORT = "P_I_V_PORT";

	/** The Constant KEY_IGM_TERMINAL. */
	public static final String KEY_IGM_TERMINAL = "P_I_V_TERMINAL";

	/** The Constant KEY_IGM_NEW_VESSEL. */
	public static final String KEY_IGM_NEW_VESSEL = "P_I_V_NEW_VESSEL";

	/** The Constant KEY_IGM_NEW_VOYAGE. */
	public static final String KEY_IGM_NEW_VOYAGE = "P_I_V_NEW_VOYAGE";

	/** The Constant KEY_IGM_SERIAL_NUMBER. */
	public static final String KEY_IGM_SRL_NO = "P_I_V_SRL_NO";
	
	/** The Constant KEY_IGM_TO_CUSTOM_TERMINAL_CODE. */
	public static final String KEY_IGM_TO_CUSTOM_TERMINAL_CODE="P_I_V_CUSTOM_TERMINAL_CODE";
	
	/** The Constant KEY_IGM_FROM_ITEM_NO. */
	public static final String KEY_IGM_FROM_ITEM_NO = "P_I_V_FROM_ITEM_NO";

	/** The Constant KEY_IGM_TO_ITEM_NO. */
	public static final String KEY_IGM_TO_ITEM_NO = "P_I_V_TO_ITEM_NO";

	/** The Constant KEY_IGM_ROAD_CARR_CODE. */
	public static final String KEY_IGM_ROAD_CARR_CODE = "P_I_V_ROAD_CARR_CODE";

	/** The Constant KEY_IGM_ROAD_TP_BOND_NO. */
	public static final String KEY_IGM_ROAD_TP_BOND_NO = "P_I_V_ROAD_TP_BOND_NO";

	/** The Constant KEY_IGM_CUST_CODE. */
	public static final String KEY_IGM_CUST_CODE = "P_I_V_CUST_CODE";

	/** The Constant KEY_IGM_CALL_SIGN. */
	public static final String KEY_IGM_CALL_SIGN = "P_I_V_CALL_SIGN";

	/** The Constant KEY_IGM_IMO_CODE. */
	public static final String KEY_IGM_IMO_CODE = "P_I_V_IMO_CODE";

	/** The Constant KEY_IGM_AGENT_CODE. */
	public static final String KEY_IGM_AGENT_CODE = "P_I_V_AGENT_CODE";

	/** The Constant KEY_IGM_LINE_CODE. */
	public static final String KEY_IGM_LINE_CODE = "P_I_V_LINE_CODE";

	/** The Constant KEY_IGM_PORT_ORIGIN. */
	public static final String KEY_IGM_PORT_ORIGIN = "P_I_V_PORT_ORIGIN";

	/** The Constant KEY_IGM_PORT_ARRIVAL. */
	public static final String KEY_IGM_PORT_ARRIVAL = "P_I_V_PORT_ARRIVAL";

	/** The Constant KEY_IGM_LAST_PORT_1. */
	public static final String KEY_IGM_LAST_PORT_1 = "P_I_V_LAST_PORT_1";

	/** The Constant KEY_IGM_LAST_PORT_2. */
	public static final String KEY_IGM_LAST_PORT_2 = "P_I_V_LAST_PORT_2";

	/** The Constant KEY_IGM_LAST_PORT_3. */
	public static final String KEY_IGM_LAST_PORT_3 = "P_I_V_LAST_PORT_3";
	
	/** The Constant KEY_IGM_LAST_PORT_1. */
	public static final String KEY_IGM_NEXT_PORT_1 = "P_I_V_NEXT_PORT_1";

	/** The Constant KEY_IGM_LAST_PORT_2. */
	public static final String KEY_IGM_NEXT_PORT_2 = "P_I_V_NEXT_PORT_2";

	/** The Constant KEY_IGM_LAST_PORT_3. */
	public static final String KEY_IGM_NEXT_PORT_3 = "P_I_V_NEXT_PORT_3";


	/** The Constant KEY_IGM_VESSEL_TYPE. */
	public static final String KEY_IGM_VESSEL_TYPE = "P_I_V_VESSEL_TYPE";

	/** The Constant KEY_IGM_GEN_DESC. */
	public static final String KEY_IGM_GEN_DESC = "P_I_V_GEN_DESC";

	/** The Constant KEY_IGM_MASTER_NAME. */
	public static final String KEY_IGM_MASTER_NAME = "P_I_V_MASTER_NAME";

	/** The Constant KEY_IGM_IGM_NUMBER. */
	public static final String KEY_IGM_IGM_NUMBER = "P_I_V_IGM_NUMBER";

	/** The Constant KEY_IGM_IGM_DATE. */
	public static final String KEY_IGM_IGM_DATE = "P_I_V_IGM_DATE";

	/** The Constant KEY_IGM_VESSEL_NATION. */
	public static final String KEY_IGM_VESSEL_NATION = "P_I_V_VESSEL_NATION";

	/** The Constant KEY_IGM_ARRIVAL_DATE_ETA. */
	public static final String KEY_IGM_ARRIVAL_DATE_ETA = "P_I_V_ARRIVAL_DATE_ETA";

	/** The Constant KEY_IGM_ARRIVAL_TIME_ETA. */
	public static final String KEY_IGM_ARRIVAL_TIME_ETA = "P_I_V_ARRIVAL_TIME_ETA";

	/** The Constant KEY_IGM_ARRIVAL_DATE_ATA. */
	public static final String KEY_IGM_ARRIVAL_DATE_ATA = "P_I_V_ARRIVAL_DATE_ATA";

	/** The Constant KEY_IGM_ARRIVAL_TIME_ATA. */
	public static final String KEY_IGM_ARRIVAL_TIME_ATA = "P_I_V_ARRIVAL_TIME_ATA";

	/** The Constant KEY_IGM_TOTAL_BLS. */
	public static final String KEY_IGM_TOTAL_BLS = "P_I_V_TOTAL_BLS";

	/** The Constant KEY_IGM_LIGHT_DUE. */
	public static final String KEY_IGM_LIGHT_DUE = "P_I_V_LIGHT_DUE";

	/** The Constant KEY_IGM_GROSS_WEIGHT. */
	public static final String KEY_IGM_GROSS_WEIGHT = "P_I_V_GROSS_WEIGHT";

	/** The Constant KEY_IGM_NET_WEIGHT. */
	public static final String KEY_IGM_NET_WEIGHT = "P_I_V_NET_WEIGHT";

	/** The Constant KEY_IGM_SM_BT_CARGO. */
	public static final String KEY_IGM_SM_BT_CARGO = "P_I_V_SM_BT_CARGO";

	/** The Constant KEY_IGM_SHIP_STR_DECL. */
	public static final String KEY_IGM_SHIP_STR_DECL = "P_I_V_SHIP_STR_DECL";

	/** The Constant KEY_IGM_CREW_LST_DECL. */
	public static final String KEY_IGM_CREW_LST_DECL = "P_I_V_CREW_LST_DECL";

	/** The Constant KEY_IGM_CARGO_DECL. */
	public static final String KEY_IGM_CARGO_DECL = "P_I_V_CARGO_DECL";

	/** The Constant KEY_IGM_PASSNGR_LIST. */
	public static final String KEY_IGM_PASSNGR_LIST = "P_I_V_PASSNGR_LIST";

	/** The Constant KEY_IGM_CREW_EFFECT. */
	public static final String KEY_IGM_CREW_EFFECT = "P_I_V_CREW_EFFECT";

	/** The Constant KEY_IGM_MARITIME_DECL. */
	public static final String KEY_IGM_MARITIME_DECL = "P_I_V_MARITIME_DECL";

	/** The Constant KEY_IGM_ITEM_NUMBER. */
	public static final String KEY_IGM_ITEM_NUMBER = "P_I_V_ITEM_NUMBER";

	/** The Constant KEY_IGM_BL_NO. */
	public static final String KEY_IGM_BL_NO = "P_I_V_BL_NO";

	/** The Constant KEY_IGM_CFS_NAME. */
	public static final String KEY_IGM_CFS_NAME = "P_I_V_CFS_NAME";

	/** The Constant KEY_IGM_CARGO_NATURE. */
	public static final String KEY_IGM_CARGO_NATURE = "P_I_V_CARGO_NATURE";

	/** The Constant KEY_IGM_CARGO_MOVMNT. */
	public static final String KEY_IGM_CARGO_MOVMNT = "P_I_V_CARGO_MOVMNT";

	/** The Constant KEY_IGM_ITEM_TYPE. */
	public static final String KEY_IGM_ITEM_TYPE = "P_I_V_ITEM_TYPE";

	/** The Constant KEY_IGM_CARGO_MOVMNT_TYPE. */
	public static final String KEY_IGM_CARGO_MOVMNT_TYPE = "P_I_V_CARGO_MOVMNT_TYPE";
	
	/** The Constant KEY_IGM_TRANSPORT_MODE. */
	public static final String KEY_IGM_TRANSPORT_MODE = "P_I_V_TRANSPORT_MODE";

	/** The Constant KEY_IGM_SUBMIT_DATE_TIME. */
	public static final String KEY_IGM_SUBMIT_DATE_TIME = "P_I_V_SUBMIT_DATE_TIME";

	/** The Constant KEY_IGM_BL_DATE. */
	public static final String KEY_IGM_BL_DATE = "P_I_V_BL_DATE";
	
	/** The Constant KEY_IGM_IS_CHECK. */
	public static final String KEY_IGM_IS_PRESENT_IN_DB = "P_I_V_IS_PRESENT_IN_DB";
	
	/** The Constant KEY_IGM_IS_CHECK. */
	public static final String KEY_IGM_IS_SELECTED = "P_I_V_IS_SELECTED";
	
	/** The Constant KEY_IGM_IS_CHECK. */
	public static final String KEY_IGM_DPD_MOVEMENT = "P_I_V_DPD_MOVEMENT";
	
	/** The Constant KEY_IGM_IS_CHECK. */
	public static final String KEY_IGM_DPD_CODE = "P_I_V_DPD_CODE";
	
	/** The Constant KEY_IGM_IS_CHECK. */
	public static final String KEY_IGM_BL_VEERSION = "P_I_V_BL_VEERSION";
	
	/** The Constant KEY_IGM_MBL_NO. */
	public static final String KEY_IGM_MBL_NO = "P_I_V_MBL_NO";

	/** The Constant KEY_IGM_HBL_NO. */
	public static final String KEY_IGM_HBL_NO = "P_I_V_HBL_NO";

	/** The Constant KEY_IGM_PACKAGES. */
	public static final String KEY_IGM_PACKAGES = "P_I_V_PACKAGES";

	/** The Constant KEY_IGM_NHAVA_SHEVA_ETA. */
	public static final String KEY_IGM_NHAVA_SHEVA_ETA = "P_I_V_NHAVA_SHEVA_ETA";

	/** The Constant KEY_IGM_FINAPL_PLACE_DELIVERY. */
	public static final String KEY_IGM_FINAL_PLACE_DELIVERY = "P_I_V_FINAL_PLACE_DELIVERY";

	/** The Constant KEY_IGM_ADD_USER. */
	public static final String KEY_IGM_ADD_USER = "P_I_V_ADD_USER";

	/** The Constant KEY_IGM_ADD_DATE. */
	public static final String KEY_IGM_ADD_DATE = "P_I_V_ADD_DATE";

	/** The Constant KEY_IGM_CHANGE_USER. */
	public static final String KEY_IGM_CHANGE_USER = "P_I_V_CHANGE_USER";

	/** The Constant KEY_IGM_CHANGE_DATE. */
	public static final String KEY_IGM_CHANGE_DATE = "P_I_V_CHANGE_DATE";

	/** The Constant KEY_IGM_BL_VERSION. */
	public static final String KEY_IGM_BL_VERSION = "P_I_V_BL_VERSION";
	
	/** The Constant KEY_IGM_CUSTOM_ADD1. */
	public static final String KEY_IGM_CUSTOM_ADD1 = "P_I_V_CUSTOM_ADD1";
	
	/** The Constant KEY_IGM_CUSTOM_ADD2. */
	public static final String KEY_IGM_CUSTOM_ADD2 = "P_I_V_CUSTOM_ADD2";
	
	/** The Constant KEY_IGM_CUSTOM_ADD3. */
	public static final String KEY_IGM_CUSTOM_ADD3 = "P_I_V_CUSTOM_ADD3";
	
	/** The Constant KEY_IGM_CUSTOM_ADD4. */
	public static final String KEY_IGM_CUSTOM_ADD4 = "P_I_V_CUSTOM_ADD4";
	
	/** The  Constant KEY_IGM_COLOR_FLAG*/
	public static final String KEY_IGM_COLOR_FLAG = "P_I_V_COLOR_FLAG";
	
	/** The Constant KEY_IGM_CONTAINER_DTLS. */
	public static final String KEY_IGM_CONTAINER_DTLS = "P_I_V_CONTAINER_DTLS";
	
	/** The  Constant KEY_IGM_PACKAGE_BL_LEVEL*/
	public static final String KEY_IGM_PACKAGE_BL_LEVEL = "P_I_V_PACKAGE_BL_LEVEL";
	
	/** The  ConstantKEY_IGM_GROSS_CARGO_WEIGHT_BL_LEVEL*/
	public static final String KEY_IGM_GROSS_CARGO_WEIGHT_BL_LEVEL = "P_I_V_GROSS_CARGO_WEIGHT_BL_LEVEL";
	
	//VESSEL/VOYAGE SECTION START
	
	/** The Constant KEY_IGM_DEP_MANIF_NO. */
	public static final String KEY_IGM_DEP_MANIF_NO = "P_I_V_DEP_MANIF_NO";

	/** The Constant KEY_IGM_DEP_MANIFEST_DATE. */
	public static final String KEY_IGM_DEP_MANIFEST_DATE = "P_I_V_DEP_MANIFEST_DATE";

	/** The Constant KEY_IGM_SUBMITTER_TYPE. */
	public static final String KEY_IGM_SUBMITTER_TYPE = "P_I_V_SUBMITTER_TYPE";

	/** The Constant KEY_IGM_SUBMITTER_CODE. */
	public static final String KEY_IGM_SUBMITTER_CODE = "P_I_V_SUBMITTER_CODE";

	/** The Constant KEY_IGM_AUTHORIZ_REP_CODE. */
	public static final String KEY_IGM_AUTHORIZ_REP_CODE = "P_I_V_AUTHORIZ_REP_CODE";

	/** The Constant KEY_IGM_SHIPPING_LINE_BOND_NO_R. */
	public static final String KEY_IGM_SHIPPING_LINE_BOND_NO_R = "P_I_V_SHIPPING_LINE_BOND_NO_R";

	/** The Constant KEY_IGM_MODE_OF_TRANSPORT. */
	public static final String KEY_IGM_MODE_OF_TRANSPORT = "P_I_V_MODE_OF_TRANSPORT";

	/** The Constant KEY_IGM_SHIP_TYPE. */
	public static final String KEY_IGM_SHIP_TYPE = "P_I_V_SHIP_TYPE";

	/** The Constant KEY_IGM_CONVEYANCE_REFERENCE_NO. */
	public static final String KEY_IGM_CONVEYANCE_REFERENCE_NO = "P_I_V_CONVEYANCE_REFERENCE_NO";

	/** The Constant KEY_IGM_CARGO_DESCRIPTION. */
	public static final String KEY_IGM_CARGO_DESCRIPTION = "P_I_V_CARGO_DESCRIPTION";
	
	/** The Constant KEY_IGM_TOL_NO_OF_TRANS_EQU_MANIF. */
	public static final String KEY_IGM_TOL_NO_OF_TRANS_EQU_MANIF = "P_I_V_TOL_NO_OF_TRANS_EQU_MANIF";
	
	/** The Constant KEY_IGM_BRIEF_CARGO_DES. */
	public static final String KEY_IGM_BRIEF_CARGO_DES = "P_I_V_BRIEF_CARGO_DES";
	
	/** The Constant KEY_IGM_EXPECTED_DATE. */
	public static final String KEY_IGM_EXPECTED_DATE = "P_I_V_EXPECTED_DATE";
	
	/** The Constant KEY_IGM_TIME_OF_DEPT. */
	public static final String KEY_IGM_TIME_OF_DEPT = "P_I_V_TIME_OF_DEPT";
	
	/** The  Constant KEY_IGM_PORT_OF_CALL_COD*/
	public static final String KEY_IGM_PORT_OF_CALL_COD = "P_I_V_PORT_OF_CALL_COD";
	
	/** The Constant KEY_IGM_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP. */
	public static final String KEY_IGM_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP = "P_I_V_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP";
	
	/** The  Constant KEY_IGM_MESSAGE_TYPE*/
	public static final String KEY_IGM_MESSAGE_TYPE = "P_I_V_MESSAGE_TYPE";
	
	/** The  Constant KEY_IGM_VESSEL_TYPE_MOVEMENT*/
	public static final String KEY_IGM_VESSEL_TYPE_MOVEMENT = "P_I_V_VESSEL_TYPE_MOVEMENT";
	
	/** The Constant KEY_IGM_AUTHORIZED_SEA_CARRIER_CODE. */
	public static final String KEY_IGM_AUTHORIZED_SEA_CARRIER_CODE = "P_I_V_AUTHORIZED_SEA_CARRIER_CODE";

	/** The Constant KEY_IGM_PORT_OF_REGISTRY. */
	public static final String KEY_IGM_PORT_OF_REGISTRY = "P_I_V_PORT_OF_REGISTRY";

	/** The Constant KEY_IGM_REGISTRY_DATE. */
	public static final String KEY_IGM_REGISTRY_DATE = "P_I_V_REGISTRY_DATE";

	/** The Constant KEY_IGM_VOYAGE_DETAILS. */
	public static final String KEY_IGM_VOYAGE_DETAILS = "P_I_V_VOYAGE_DETAILS";

	/** The Constant KEY_IGM_SHIP_ITINERARY_SEQUENCE. */
	public static final String KEY_IGM_SHIP_ITINERARY_SEQUENCE = "P_I_V_SHIP_ITINERARY_SEQUENCE";

	/** The Constant KEY_IGM_PORT_OF_CALL_NAME. */
	public static final String KEY_IGM_SHIP_ITINERARY = "P_I_V_SHIP_ITINERARY";

	/** The Constant KEY_IGM_ADD_DATE. */
	public static final String KEY_IGM_PORT_OF_CALL_NAME = "P_I_V_PORT_OF_CALL_NAME";

	/** The Constant KEY_IGM_ARRIVAL_DEPARTURE_DETAILS. */
	public static final String KEY_IGM_ARRIVAL_DEPARTURE_DETAILS = "P_I_V_ARRIVAL_DEPARTURE_DETAILS";

	/** The Constant KEY_IGM_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE. */
	public static final String KEY_IGM_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE = "P_I_V_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE";

	/** The Constant KEY_IGM_NO_OF_CREW_MANIF. */

	
	//VESSEL/VOYAGE SECTION END
	//BL SECTION START
	
	/** The Constant KEY_IGM_CONSOLIDATED_INDICATOR. */
	public static final String KEY_IGM_CONSOLIDATED_INDICATOR = "P_I_V_CONSOLIDATED_INDICATOR";

	/** The Constant KEY_IGM_PREVIOUS_DECLARATION. */
	public static final String KEY_IGM_PREVIOUS_DECLARATION = "P_I_V_PREVIOUS_DECLARATION";

	/** The Constant KEY_IGM_CONSOLIDATOR_PAN. */
	public static final String KEY_IGM_CONSOLIDATOR_PAN = "P_I_V_CONSOLIDATOR_PAN";

	/** The Constant KEY_IGM_CIN_TYPE. */
	public static final String KEY_IGM_CIN_TYPE = "P_I_V_CIN_TYPE";

	/** The Constant KEY_IGM_MCIN. */
	public static final String KEY_IGM_MCIN = "P_I_V_MCIN";

	/** The Constant KEY_IGM_CSN_SUBMITTED_TYPE. */
	public static final String KEY_IGM_CSN_SUBMITTED_TYPE = "P_I_V_CSN_SUBMITTED_TYPE";

	/** The Constant KEY_IGM_CSN_SUBMITTED_BY. */
	public static final String KEY_IGM_CSN_SUBMITTED_BY = "P_I_V_CSN_SUBMITTED_BY";
	
	/** The Constant KEY_IGM_CSN_REPORTING_TYPE. */
	public static final String KEY_IGM_CSN_REPORTING_TYPE = "P_I_V_CSN_REPORTING_TYPE";
	
	/** The Constant KEY_IGM_CSN_SITE_ID. */
	public static final String KEY_IGM_CSN_SITE_ID = "P_I_V_CSN_SITE_ID";
	
	/** The Constant KEY_IGM_CSN_NUMBER. */
	public static final String KEY_IGM_CSN_NUMBER = "P_I_V_CSN_NUMBER";
	
	/** The Constant KEY_IGM_CSN_DATE. */
	public static final String KEY_IGM_CSN_DATE = "P_I_V_CSN_DATE";
	
	/** The  Constant KEY_IGM_PREVIOUS_MCIN*/
	public static final String KEY_IGM_PREVIOUS_MCIN = "P_I_V_PREVIOUS_MCIN";
	
	/** The Constant KEY_IGM_SPLIT_INDICATOR. */
	public static final String KEY_IGM_SPLIT_INDICATOR = "P_I_V_SPLIT_INDICATOR";
	
	/** The  Constant KEY_IGM_NUMBER_OF_PACKAGES.*/
	public static final String KEY_IGM_NUMBER_OF_PACKAGES = "P_I_V_NUMBER_OF_PACKAGES";
	
	/** The  Constant KEY_IGM_TYPE_OF_PACKAGE.*/
	public static final String KEY_IGM_TYPE_OF_PACKAGE = "P_I_V_TYPE_OF_PACKAGE";
	
	/** The Constant KEY_IGM_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE. */
	public static final String KEY_IGM_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE = "P_I_V_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE";

	/** The Constant KEY_IGM_TYPE_OF_CARGO. */
	public static final String KEY_IGM_TYPE_OF_CARGO = "P_I_V_TYPE_OF_CARGO";

	/** The Constant KEY_IGM_SPLIT_INDICATOR_LIST. */
	public static final String KEY_IGM_SPLIT_INDICATOR_LIST = "P_I_V_SPLIT_INDICATOR_LIST";

	/** The Constant KEY_IGM_PORT_OF_ACCEPTANCE. */
	public static final String KEY_IGM_PORT_OF_ACCEPTANCE = "P_I_V_PORT_OF_ACCEPTANCE";

	/** The Constant KEY_IGM_PORT_OF_RECEIPT. */
	public static final String KEY_IGM_PORT_OF_RECEIPT = "P_I_V_PORT_OF_RECEIPT";

	/** The Constant KEY_IGM_UCR_TYPE. */
	public static final String KEY_IGM_UCR_TYPE = "P_I_V_UCR_TYPE";

	/** The Constant KEY_IGM_UCR_CODE. */
	public static final String KEY_IGM_UCR_CODE = "P_I_V_UCR_CODE";

	/** The Constant KEY_IGM_EQUIPMENT_SEAL_TYPE. */
	public static final String KEY_IGM_EQUIPMENT_SEAL_TYPE = "P_I_V_EQUIPMENT_SEAL_TYPE";
	
	/** The Constant KEY_IGM_SOC_FLAG. */
	public static final String KEY_IGM_SOC_FLAG = "P_I_V_SOC_FLAG";

	/** The Constant KEY_IGM_PORT_OF_ACCEPTANCE_NAME. */
	public static final String KEY_IGM_PORT_OF_ACCEPTANCE_NAME = "P_I_V_PORT_OF_ACCEPTANCE_NAME";

	/** The Constant KEY_IGM_PORT_OF_RECEIPT_NAME. */
	public static final String KEY_IGM_PORT_OF_RECEIPT_NAME = "P_I_V_PORT_OF_RECEIPT_NAME";

	/** The Constant KEY_IGM_PAN_OF_NOTIFIED_PARTY. */
	public static final String KEY_IGM_PAN_OF_NOTIFIED_PARTY = "P_I_V_PAN_OF_NOTIFIED_PARTY";

	/** The Constant KEY_IGM_UNIT_OF_WEIGHT. */
	public static final String KEY_IGM_UNIT_OF_WEIGHT = "P_I_V_UNIT_OF_WEIGHT";

	/** The Constant KEY_IGM_GROSS_VOLUME. */
	public static final String KEY_IGM_GROSS_VOLUME = "P_I_V_GROSS_VOLUME";
	
	/** The Constant KEY_IGM_UNIT_OF_VOLUME. */
	public static final String KEY_IGM_UNIT_OF_VOLUME = "P_I_V_UNIT_OF_VOLUME";

	/** The Constant KEY_IGM_CARGO_ITEM_SEQUENCE_NO. */
	public static final String KEY_IGM_CARGO_ITEM_SEQUENCE_NO = "P_I_V_CARGO_ITEM_SEQUENCE_NO";
	
	/** The Constant KEY_IGM_CARGO_ITEM_DESCRIPTION. */
	public static final String KEY_IGM_CARGO_ITEM_DESCRIPTION = "P_I_V_CARGO_ITEM_DESCRIPTION";
	
	/** The Constant KEY_IGM_CONTAINER_WEIGHT. */
	public static final String KEY_IGM_CONTAINER_WEIGHT = "P_I_V_CONTAINER_WEIGHT";
	
	/** The Constant KEY_IGM_NUMBER_OF_PACKAGES_HID. */
	public static final String KEY_IGM_NUMBER_OF_PACKAGES_HID = "P_I_V_NUMBER_OF_PACKAGES_HID";
	
	/** The Constant KEY_IGM_TYPE_OF_PACKAGES_HID. */
	public static final String KEY_IGM_TYPE_OF_PACKAGES_HID = "P_I_V_TYPE_OF_PACKAGES_HID";
	
	/** The  Constant KEY_IGM_PORT_OF_CALL_SEQUENCE_NUMBER*/
	public static final String KEY_IGM_PORT_OF_CALL_SEQUENCE_NUMBER = "P_I_V_PORT_OF_CALL_SEQUENCE_NUMBER";
	
	/** The Constant KEY_IGM_PORT_OF_CALL_CODED. */
	public static final String KEY_IGM_PORT_OF_CALL_CODED = "P_I_V_PORT_OF_CALL_CODED";
	
	/** The  Constant KEY_IGM_NEXT_PORT_OF_CALL_CODED.*/
	public static final String KEY_IGM_NEXT_PORT_OF_CALL_CODED = "P_I_V_NEXT_PORT_OF_CALL_CODED";
	
	/** The  Constant KEY_IGM_MC_LOCATION_CUSTOMS.*/
	public static final String KEY_IGM_MC_LOCATION_CUSTOMS = "P_I_V_MC_LOCATION_CUSTOMS";
	
	/** The Constant KEY_IGM_UNO_CODE. */
	public static final String KEY_IGM_UNO_CODE = "P_I_V_UNO_CODE";

	/** The Constant KEY_IGM_TYPE_OF_CARGO. */
	public static final String KEY_IGM_IMDG_CODE = "P_I_V_IMDG_CODE";
	
	/** The Constant KEY_IGM_TYPE_OF_CARGO. */
	public static final String KEY_IGM_PORT_OF_DESTINATION  = "P_I_V_PORT_OF_DESTINATION";
	
	public static final String KEY_IGM_TERMINAL_OP_COD  = "P_I_V_TERMINAL_OP_COD";
	
	//BL SECTION END
	
	
	/** The Constant KEY_IGM_CONSIGNEE_DTLS. */
    public static final String KEY_IGM_CONSIGNEE_ADD1 = "P_I_V_CONSIGNEE_ADD1";
	public static final String KEY_IGM_CONSIGNEE_ADD2 = "P_I_V_CONSIGNEE_ADD2";
	public static final String KEY_IGM_CONSIGNEE_ADD3= "P_I_V_CONSIGNEE_ADD3";
	public static final String KEY_IGM_CONSIGNEE_ADD4 = "P_I_V_CONSIGNEE_ADD4";
	public static final String KEY_IGM_CONSIGNEE_COUNTRYCODE = "P_I_V_CONSIGNEE_COUNTRYCODE";
	public static final String KEY_IGM_CONSIGNEE_CODE = "P_I_V_CONSIGNEE_CODE";
	public static final String KEY_IGM_CONSIGNEE_NAME = "P_I_V_CONSIGNEE_NAME";
	public static final String KEY_IGM_CONSIGNEE_STATE = "P_I_V_CONSIGNEE_STATE";
	public static final String KEY_IGM_CONSIGNEE_ZIP = "P_I_V_CONSIGNEE_ZIP";
	public static final String KEY_IGM_CONSIGNEE_CITY = "P_I_V_CONSIGNEE_CITY";
	
	/** The Constant KEY_IGM_CONSINOR_DTLS. */
    public static final String KEY_IGM_CONSIGNER_ADD1 = "P_I_V_CONSIGNER_ADD1";
	public static final String KEY_IGM_CONSIGNER_ADD2 = "P_I_V_CONSIGNER_ADD2";
	public static final String KEY_IGM_CONSIGNER_ADD3= "P_I_V_CONSIGNER_ADD3";
	public static final String KEY_IGM_CONSIGNER_ADD4 = "P_I_V_CONSIGNER_ADD4";
	public static final String KEY_IGM_CONSIGNER_COUNTRYCODE = "P_I_V_CONSIGNER_COUNTRYCODE";
	public static final String KEY_IGM_CONSIGNER_CODE = "P_I_V_CONSIGNER_CODE";
	public static final String KEY_IGM_CONSIGNER_NAME = "P_I_V_CONSIGNER_NAME";
	public static final String KEY_IGM_CONSIGNER_STATE = "P_I_V_CONSIGNER_STATE";
	public static final String KEY_IGM_CONSIGNER_ZIP = "P_I_V_CONSIGNER_ZIP";
	public static final String KEY_IGM_CONSIGNER_CITY = "P_I_V_CONSIGNER_CITY";
	
	
	/** The Constant KEY_IGM_MARKSNUMBER. */
	 public static final String KEY_IGM_MARKSNUMBER_DESCRIPTION = "P_I_V_MARKSNUMBER_DESCRIPTION";
	 public static final String KEY_IGM_MARKSNUMBER_MARKS = "P_I_V_MARKSNUMBER_MARKS";
	
	/** The Constant KEY_IGM_NOTIFYPARTY. */
	 public static final String KEY_IGM_NOTIFYPARTY_ADD1 = "P_I_V_NOTIFYPARTY_ADD1";
	 public static final String KEY_IGM_NOTIFYPARTY_ADD2 = "P_I_V_NOTIFYPARTY_ADD2";
	 public static final String KEY_IGM_NOTIFYPARTY_ADD3 = "P_I_V_NOTIFYPARTY_ADD3";
	 public static final String KEY_IGM_NOTIFYPARTY_ADD4 = "P_I_V_NOTIFYPARTY_ADD4";
	 public static final String KEY_IGM_NOTIFYPARTY_CITY = "P_I_V_NOTIFYPARTY_CITY";
	 public static final String KEY_IGM_NOTIFYPARTY_COUNTRYCODE = "P_I_V_NOTIFYPARTY_COUNTRYCODE";
	 public static final String KEY_IGM_NOTIFYPARTY_CODE = "P_I_V_NOTIFYPARTY_CODE";
	 public static final String KEY_IGM_NOTIFYPARTY_NAME = "P_I_V_NOTIFYPARTY_NAME";
	 public static final String KEY_IGM_NOTIFYPARTY_STATE = "P_I_V_NOTIFYPARTY_STATE";
	 public static final String KEY_IGM_NOTIFYPARTY_ZIP = "P_I_V_NOTIFYPARTY_ZIP";
	
	
	/**
	 * Gets the IGM data.
	 *
	 * @param amapParam the amap param
	 * @return the IGM data
	 * @throws BusinessException   the business exception
	 * @throws DataAccessException the data access exception
	 */
	public Map getIGMData(Map amapParam) throws BusinessException, DataAccessException;

	/**
	 * Save IGM data.
	 *
	 * @param amapParam the amap param
	 * @return the map
	 * @throws BusinessException   the business exception
	 * @throws DataAccessException the data access exception
	 */
	
	public Map saveIGMData(Map amapParam) throws BusinessException, DataAccessException;
	/**
	 * Refresh IGM data.
	 *
	 * @param amapParam the amap param
	 * @return the map
	 * @throws BusinessException   the business exception
	 * @throws DataAccessException the data access exception
	 */
	public Map getRefreshIGMData(Map amapParam) throws BusinessException, DataAccessException;
	
	/**
	 * Get  SL NO.
	 *
	 * @param amapParam the amap param
	 * @return the map
	 * @throws BusinessException   the business exception
	 * @throws DataAccessException the data access exception
	 */
	public Map getSerialNumber(String slNo)throws BusinessException, DataAccessException;
	
	/**
	 * Save ContanorDtls.
	 * Pass Container Dtl string
	 * @throws BusinessException   the business exception
	 * @throws DataAccessException the data access exception
	 */
	public String saveContainerData(String contDtl,Map amapParam)throws BusinessException, DataAccessException;
	
	/**
	 * get Road Carr Code.
	 * @param amapParam the amap param
	 * @return the map 
	 * @throws BusinessException   the business exception
	 * @throws DataAccessException the data access exception
	 */
	public Map getroadCarrCodeData(Map amapParam)throws BusinessException, DataAccessException;
	
}
