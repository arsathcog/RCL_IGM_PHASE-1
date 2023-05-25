package com.rclgroup.dolphin.web.igm.action;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.dao.DataAccessException;

import com.niit.control.common.exception.BusinessException;
import com.niit.control.web.action.BaseAction;
import com.rclgroup.dolphin.web.igm.actionform.ImportGeneralManifestUim;
import com.rclgroup.dolphin.web.igm.dao.ImportGeneralManifestDao;
import com.rclgroup.dolphin.web.igm.vo.ArvlDtlsSEI;
import com.rclgroup.dolphin.web.igm.vo.AuthPrsn;
import com.rclgroup.dolphin.web.igm.vo.AuthPrsnSEI;
import com.rclgroup.dolphin.web.igm.vo.CrewEfctSEI;
import com.rclgroup.dolphin.web.igm.vo.DecRef;
import com.rclgroup.dolphin.web.igm.vo.DecRefSEI;
import com.rclgroup.dolphin.web.igm.vo.DigSign;
import com.rclgroup.dolphin.web.igm.vo.DigSignSEI;
import com.rclgroup.dolphin.web.igm.vo.HeaderField;
import com.rclgroup.dolphin.web.igm.vo.HeaderFieldSEI;
import com.rclgroup.dolphin.web.igm.vo.ImportGeneralManifestMod;
import com.rclgroup.dolphin.web.igm.vo.ImportGeneralManifestResultSet;
import com.rclgroup.dolphin.web.igm.vo.ImportGenralManifestExcel;
import com.rclgroup.dolphin.web.igm.vo.ItemDtls;
import com.rclgroup.dolphin.web.igm.vo.Itnry;
import com.rclgroup.dolphin.web.igm.vo.JsonMainObjct;
import com.rclgroup.dolphin.web.igm.vo.JsonSEIObjct;
import com.rclgroup.dolphin.web.igm.vo.LocCstm;
import com.rclgroup.dolphin.web.igm.vo.MCRef;
import com.rclgroup.dolphin.web.igm.vo.Master;
import com.rclgroup.dolphin.web.igm.vo.MasterSEI;
import com.rclgroup.dolphin.web.igm.vo.MastrCnsgmtDec;
import com.rclgroup.dolphin.web.igm.vo.PrsnDtls;
import com.rclgroup.dolphin.web.igm.vo.PrsnId;
import com.rclgroup.dolphin.web.igm.vo.PrsnOnBoard;
import com.rclgroup.dolphin.web.igm.vo.PrsnOnBoardSEI;
import com.rclgroup.dolphin.web.igm.vo.ShipItnry;
import com.rclgroup.dolphin.web.igm.vo.ShipStoresSEI;
import com.rclgroup.dolphin.web.igm.vo.TrnsprtDoc;
import com.rclgroup.dolphin.web.igm.vo.TrnsprtDocMsr;
import com.rclgroup.dolphin.web.igm.vo.TrnsprtEqmt;
import com.rclgroup.dolphin.web.igm.vo.VesselDtls;
import com.rclgroup.dolphin.web.igm.vo.VesselDtlsSEI;
import com.rclgroup.dolphin.web.igm.vo.VoyageDtls;
import com.rclgroup.dolphin.web.igm.vo.VoyageTransportEquipment;
import com.sun.syndication.io.SyndFeedOutput;

/**
 * The Class ImportGeneralManifestSvc.
 */
public class ImportGeneralManifestSvc extends BaseAction {

	/** The Constant DAO_BEAN_ID. */
	private static final String DAO_BEAN_ID = "importGeneralManifestDao";

	/** The Constant ONLOAD. */
	private static final String ONLOAD = "onload";

	/** The Constant SEARCH. */
	private static final String SEARCH = "igmsearch";

	/** The Constant SAVE. */
	private static final String SAVE = "igmsave";

	/** The Constant DOWNLOAD. */
	private static final String DOWNLOAD = "igmsavefile";

	/** The Constant REFRESH. */
	private static final String REFRESH = "igmrefresh";

	/** The Constant EXCELUPLOAD. */
	private static final String EXCELUPLOAD = "igmexcelupload";

	public static String generatedFileNameOfJson;

	public static String EDIFILEGENERATEFILE = "edifilegenerate";
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.niit.control.web.action.BaseAction#executeAction(org.apache.struts.action
	 * .ActionMapping, org.apache.struts.action.ActionForm,
	 * javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse)
	 */

	/**
	 * Execute action.
	 *
	 * @param mapping
	 *            the mapping
	 * @param form
	 *            the form
	 * @param request
	 *            the request
	 * @param response
	 *            the response
	 * @return the action forward
	 * @throws Exception
	 *             the exception
	 */
	public ActionForward executeAction(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String strAction = mapping.getParameter();

		if (ONLOAD.equals(strAction)) {
			return onload(mapping, form, request, response);
		} else if (SEARCH.equals(strAction)) {
			return onSearch(mapping, form, request, response);
		} else if (SAVE.equals(strAction)) {
			return onSave(mapping, form, request, response);
		} else if (DOWNLOAD.equals(strAction)) {
			return onSaveFile(mapping, form, request, response);
		} else if ("upload".equals(strAction)) {
			return onUploadFile(mapping, form, request, response);
		} else if (REFRESH.equals(strAction)) {
			return onRefresh(mapping, form, request, response);
		} else if (EXCELUPLOAD.equals(strAction)) {
			return onExcelUpload(mapping, form, request, response);
		} else if (EDIFILEGENERATEFILE.equals(strAction)) {
			return onEdiFileGenerateFile(mapping, form, request, response);
		}
		return mapping.findForward(SUCCESS);

	}

	/**
	 * onExcelUpload.
	 *
	 * @param mapping
	 *            the mapping
	 * @param form
	 *            the form
	 * @param request
	 *            the request
	 * @param response
	 *            the response
	 * @return the action forward
	 * @throws Exception
	 */
	private ActionForward onExcelUpload(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println("onExcelUpload() calling....");
		ImportGeneralManifestUim objForm = (ImportGeneralManifestUim) form;
		List<ImportGenralManifestExcel> excelList = new ArrayList<ImportGenralManifestExcel>();
		String tmpdir = System.getProperty("java.io.tmpdir");
		System.out.println(objForm.getFileExl());
		/*
		 * File f =new File(objForm.getFileExl()); System.out.println(f.getName());
		 * String path1 = tmpdir + File.separator + objForm.getFileExl();
		 * System.out.println("onUploadFile 1st file :" + path1);
		 */
		try {
			InputStream file = objForm.getFileExl().getInputStream();

			Workbook workbook = null;
			if (objForm.getFileExl().getFileName().endsWith(".xlsx")) {
				workbook = new XSSFWorkbook(file);
			} else if (objForm.getFileExl().getFileName().endsWith(".xls")) {
				workbook = new HSSFWorkbook(file);
			}
			Sheet sheet;
			for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
				sheet = workbook.getSheetAt(i);
				int ignoreFirst = 0;
				System.out.println("Sheet Name>>>>>>>>>>>>>>>>>>>>>>>>>" + workbook.getSheetName(i));
				Iterator<Row> rowIterator = sheet.iterator();
				int count = 0;

				while (rowIterator.hasNext()) {
					Row row = rowIterator.next();
					Iterator<Cell> cellIterator = row.cellIterator();
					if (ignoreFirst == 0) {
						ignoreFirst++;
						continue;
					}

					int index = 1;

					System.out.println(count);
					count = 0;
					ImportGenralManifestExcel excelVO = new ImportGenralManifestExcel();

					while (cellIterator.hasNext()) {
						System.out.println(cellIterator.hasNext());
						Cell cell = cellIterator.next();
						cell.setCellType(cell.CELL_TYPE_STRING);
						count++;
						if (i == 0) {
							if (cell.getColumnIndex() == 0) {
								if (!cell.getStringCellValue().equals(null)) {
									excelVO.setBlNo(cell.getStringCellValue());
								}
							} else if (cell.getColumnIndex() == 1) {
								if (!cell.getStringCellValue().equals(null)) {
									excelVO.setCustomCode(cell.getStringCellValue());
									System.out.println("Cell Type CFS-CUSTOM_CODE>>>>>>>>>>>>>>>>>>>>>>>>>"
											+ cell.getStringCellValue());
								}
							} else if (cell.getColumnIndex() == 2) {
								if (!cell.getStringCellValue().equals(null)) {
									excelVO.setDpdMovement(cell.getStringCellValue());
									System.out.println("Cell Type DPD_Movement>>>>>>>>>>>>>>>>>>>>>>>>>"
											+ cell.getStringCellValue());
								}
							} else if (cell.getColumnIndex() == 3) {
								if (!cell.getStringCellValue().equals(null)) {
									excelVO.setDpdCode(cell.getStringCellValue());
									System.out.println(
											"Cell Type DPD_Code>>>>>>>>>>>>>>>>>>>>>>>>>" + cell.getStringCellValue());
								}
							}
						}
						index++;
					}
					if (index > 1)
						excelList.add(excelVO);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		net.sf.json.JSONObject jsonObj = new net.sf.json.JSONObject();
		jsonObj = new net.sf.json.JSONObject();
		jsonObj.put("result", excelList);
		jsonObj.write(response.getWriter());
		System.out.println("#IGMLogger EXCEL JSON obj: " + jsonObj.write(new StringWriter()));
		return null;
	}

	/**
	 * Onload.
	 *
	 * @param mapping
	 *            the mapping
	 * @param form
	 *            the form
	 * @param request
	 *            the request
	 * @param response
	 *            the response
	 * @return the action forward
	 */
	private ActionForward onload(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		return mapping.findForward(SUCCESS);
	}

	/**
	 * On save.
	 *
	 * @param mapping
	 *            the mapping
	 * @param form
	 *            the form
	 * @param request
	 *            the request
	 * @param response
	 *            the response
	 * @return the action forward
	 * @throws Exception
	 *             the exception
	 */

	@SuppressWarnings("unchecked")
	private ActionForward onSave(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		System.out.println("#IGMLogger onSave() started...........");
		org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();

		ImportGeneralManifestUim objForm = (ImportGeneralManifestUim) form;
		System.out.println("#IGMLogger onSave() form data : " + objForm.toString());

		System.out.println(objForm.getBLDetails() + "  .....");
		JSONArray blList = (org.json.simple.JSONArray) parser.parse(objForm.getBLDetails());

		System.out.println(objForm.getVesselVoyageDtls() + "  .....");
		JSONArray vesselVoyageList = (org.json.simple.JSONArray) parser.parse(objForm.getVesselVoyageDtls());
		JSONObject serviceVesselVoyageObj = (JSONObject) vesselVoyageList.get(0);

		System.out.println(objForm.getConsigneeDtls() + "   ....consignee Details");
		JSONArray consigneeDtlsList = (org.json.simple.JSONArray) parser.parse(objForm.getConsigneeDtls());

		System.out.println(objForm.getConsigneeDtls() + "   ....consignee Details");
		JSONArray consignerDtlsList = (org.json.simple.JSONArray) parser.parse(objForm.getConsignerDtlstls());

		System.out.println(objForm.getMarksNumberDtlstls() + "  ....marks number");
		JSONArray MarksNumberDtlstlsList = (org.json.simple.JSONArray) parser.parse(objForm.getMarksNumberDtlstls());

		System.out.println(objForm.getNotifyPartyDlts() + "  ....nortyfy Party");
		JSONArray NotifyPartyDltsList = (org.json.simple.JSONArray) parser.parse(objForm.getNotifyPartyDlts());

		System.out.println(objForm.getContainerDetailsDtls() + "   ....container Details");

		ImportGeneralManifestDao objDao = (ImportGeneralManifestDao) getDao(DAO_BEAN_ID);
		System.out.println("#IGMLogger onSave() Dao bean created successfully...");

		for (Object blObj : blList) {
			JSONObject blJSONObj = (JSONObject) blObj;
			Map<String, String> mapParam = createHeaderParamsForSave(objForm, blJSONObj, serviceVesselVoyageObj,
					consigneeDtlsList, consignerDtlsList, MarksNumberDtlstlsList, NotifyPartyDltsList);
			if ("TRUE".equalsIgnoreCase(mapParam.get(ImportGeneralManifestDao.KEY_IGM_IS_SELECTED))
					|| ("FALSE".equalsIgnoreCase(mapParam.get(ImportGeneralManifestDao.KEY_IGM_IS_SELECTED)) && "TRUE"
							.equalsIgnoreCase(mapParam.get(ImportGeneralManifestDao.KEY_IGM_IS_PRESENT_IN_DB)))) {
				objDao.saveIGMData(mapParam);
				System.out.println("#IGMLogger onSave() inserted record for #BL : " + blJSONObj.get("BL#"));
			}
		}
		System.out.println(objForm.getContainerDetailsDtls());
		if (!objForm.getContainerDetailsDtls().equals("") && objForm.getContainerDetailsDtls() != null) {
			Map<String, String> mapParamCon = createHeaderParams(objForm);
			objDao.saveContainerData(objForm.getContainerDetailsDtls(), mapParamCon);
		}
		System.out.println("#IGMLogger onSave() completed.");

		System.out.println("IGMlogger refresh part started.");
		System.out.println("Form data for refresh : " + objForm.toString());
		objForm.setPodTerminal((String) serviceVesselVoyageObj.get("Terminal"));

		Map<String, String> mapParam = createHeaderParams(objForm);
		System.out.println("#IGMLogger Map mapParam for reload: " + mapParam);
		objDao = (ImportGeneralManifestDao) getDao(DAO_BEAN_ID);
		System.out.println("#IGMLogger Dao bean created successfully...");
		Map<Object, Object> mapReturn = objDao.getIGMData(mapParam);
		System.out.println("#IGMLogger Proc executed successfully...");
		List<ImportGeneralManifestMod> result = (List<ImportGeneralManifestMod>) mapReturn
				.get(ImportGeneralManifestDao.KEY_REF_IGM_DATA);
		net.sf.json.JSONObject jsonObj = new net.sf.json.JSONObject();
		List<ImportGeneralManifestMod> uniqueRecords = getUniqueRecords(result);
		List<ImportGeneralManifestResultSet> finalResult = getFinalData(result, uniqueRecords);
		jsonObj = new net.sf.json.JSONObject();
		jsonObj.put("Savedresult", finalResult);
		jsonObj.write(response.getWriter());
		System.out.println("#IGMLogger final JSON for unique obj For reload: " + jsonObj.write(new StringWriter()));

		return null;

		// return mapping.findForward(SUCCESS);
	}

	/**
	 * On save file.
	 *
	 * @param mapping
	 *            the mapping
	 * @param form
	 *            the form
	 * @param request
	 *            the request
	 * @param response
	 *            the response
	 * @return the action forward
	 * @throws Exception
	 *             the exception
	 */

	private ActionForward onSaveFile(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println("#IGMLogger onSaveFile() started............");
		String fileName = "ManifesFile.json";
		response.setHeader("Content-Disposition", "attachment;filename=" + generatedFileNameOfJson);
		org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();
		ImportGeneralManifestUim objForm = (ImportGeneralManifestUim) form;
		System.out.println("#IGMLogger onSaveFile() form data : " + objForm.toString());

		ImportGeneralManifestDao objDao = (ImportGeneralManifestDao) getDao(DAO_BEAN_ID);
		System.out.println("#IGMLogger onSave() Dao bean created successfully...");

		String tmpdir = System.getProperty("java.io.tmpdir");
		String path = tmpdir + File.separator + fileName;
		new File(path).delete();
		System.out.println("onSaveFile :" + path);
		JSONArray blList = (org.json.simple.JSONArray) parser.parse(objForm.getBLDetails());
		JSONArray vesselVoyageList = (org.json.simple.JSONArray) parser.parse(objForm.getVesselVoyageDtls());
		JSONObject serviceVesselVoyageObj = (JSONObject) vesselVoyageList.get(0);
		JSONArray notifyPartyDetailes = (org.json.simple.JSONArray) parser.parse(objForm.getNotifyPartyDlts());
		JSONArray marksNumberDtlstls = (org.json.simple.JSONArray) parser.parse(objForm.getMarksNumberDtlstls());
		JSONArray containeerDtls = (org.json.simple.JSONArray) parser.parse(objForm.getContainerDetailsDtls());
		JSONArray consignee = (org.json.simple.JSONArray) parser.parse(objForm.getConsigneeDtls());
		JSONArray cnsNor = (org.json.simple.JSONArray) parser.parse(objForm.getConsignerDtlstls());
		File manifestFile = writeFile(path, objForm, blList, serviceVesselVoyageObj, objDao, notifyPartyDetailes,
				marksNumberDtlstls, containeerDtls, consignee, cnsNor);
		try (ServletOutputStream out = response.getOutputStream();
				FileInputStream in = new FileInputStream(manifestFile);) {
			byte[] bufferData = new byte[1024];
			int read = 0;
			while ((read = in.read(bufferData)) != -1) {
				out.write(bufferData, 0, read);
			}
		}
		System.out.println("#IGMLogger onSaveFile() completed..");
		return null;
	}

	/**
	 * On upload file.
	 *
	 * @param mapping
	 *            the mapping
	 * @param form
	 *            the form
	 * @param request
	 *            the request
	 * @param response
	 *            the response
	 * @return the action forward
	 * @throws Exception
	 *             the exception
	 */
	private ActionForward onUploadFile(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println("#IGMLogger onUploadFile() started..");
		ImportGeneralManifestUim uploadForm = (ImportGeneralManifestUim) form;
		String fileName = "MergeManifestFile.txt";
		response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
		String tmpdir = System.getProperty("java.io.tmpdir");
		FormFile formFile1 = uploadForm.getFile1();
		FormFile formFile2 = uploadForm.getFile2();
		System.out.println(formFile1.getFileName());
		String path1 = tmpdir + File.separator + formFile1.getFileName();
		System.out.println("onUploadFile 1st file :" + path1);
		String path2 = tmpdir + File.separator + formFile2.getFileName();
		System.out.println("onUploadFile 2nd file :" + path2);
		String path3 = tmpdir + File.separator + fileName;
		System.out.println("onUploadFile save file :" + path3);
		new File(path1).delete();
		new File(path2).delete();
		new File(path3).delete();
		try (FileOutputStream fos = new FileOutputStream(new File(path1));) {
			fos.write(formFile1.getFileData());
		}
		try (FileOutputStream fos = new FileOutputStream(new File(path2));) {
			fos.write(formFile2.getFileData());
		}
		mergeFiles(path1, path2, path3);
		try (ServletOutputStream out = response.getOutputStream();
				FileInputStream in = new FileInputStream(new File(path3));) {
			byte[] bufferData = new byte[1024];
			int read = 0;
			while ((read = in.read(bufferData)) != -1) {
				out.write(bufferData, 0, read);
			}
		}
		System.out.println("#IGMLogger onUploadFile() completed..");
		return null;
	}

	/**
	 * On search.
	 *
	 * @param mapping
	 *            the mapping
	 * @param form
	 *            the form
	 * @param request
	 *            the request
	 * @param response
	 *            the response
	 * @return the action forward
	 * @throws Exception
	 *             the exception
	 */
	@SuppressWarnings("unchecked")
	private ActionForward onSearch(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println("#IGMLogger onSearch() started..");
		ImportGeneralManifestUim objForm = (ImportGeneralManifestUim) form;
		System.out.println("#IGMLogger Form Data : " + objForm.toString());
		Map<String, String> mapParam = createHeaderParams(objForm);
		System.out.println("#IGMLogger Map mapParam : " + mapParam);
		ImportGeneralManifestDao objDao = (ImportGeneralManifestDao) getDao(DAO_BEAN_ID);
		System.out.println("#IGMLogger Dao bean created successfully...");
		Map<Object, Object> mapReturn = objDao.getIGMData(mapParam);
		System.out.println("#IGMLogger Proc executed successfully...");
		List<ImportGeneralManifestMod> result = (List<ImportGeneralManifestMod>) mapReturn
				.get(ImportGeneralManifestDao.KEY_REF_IGM_DATA);
		System.out.println("NEW RESULT :" + result.toString());
		net.sf.json.JSONObject jsonObj = new net.sf.json.JSONObject();
		List<ImportGeneralManifestMod> uniqueRecords = getUniqueRecords(result);
		List<ImportGeneralManifestResultSet> finalResult = getFinalData(result, uniqueRecords);
		jsonObj = new net.sf.json.JSONObject();
		jsonObj.put("result", finalResult);
		jsonObj.put("DropDown", objDao.getroadCarrCodeData(mapParam));
		jsonObj.write(response.getWriter());
		System.out.println("#IGMLogger final JSON for unique obj: " + jsonObj.write(new StringWriter()));
		return null;
	}

	/**
	 * Gets the final data.
	 *
	 * @param allRecords
	 *            the all records
	 * @param uniqueRecords
	 *            the unique records
	 * @return the final data
	 */
	private List<ImportGeneralManifestResultSet> getFinalData(List<ImportGeneralManifestMod> allRecords,
			List<ImportGeneralManifestMod> uniqueRecords) {
		List<ImportGeneralManifestResultSet> finalResult = new ArrayList<>();
		int index = 0;

		for (ImportGeneralManifestMod uMod : uniqueRecords) {
			index++;
			List<ImportGeneralManifestMod> bls = new ArrayList<ImportGeneralManifestMod>();
			List<ImportGeneralManifestMod> bls2 = new ArrayList<ImportGeneralManifestMod>();
			for (ImportGeneralManifestMod aMod : allRecords) {
				if (uMod.getTerminal().equals(aMod.getTerminal())) {
					bls.add(aMod);
					bls2.add(aMod);
				}
			}
			// first cargomovement to be sorted as per LC and TI
			List<ImportGeneralManifestMod> listWithItemNumbers = bls.stream()
					.filter(o -> o.getItemNumber() != null && !o.getItemNumber().trim().equals(""))
					.collect(Collectors.toList());
			listWithItemNumbers.sort((o1, o2) -> {
				return Integer.valueOf(o1.getItemNumber()).compareTo(Integer.valueOf(o2.getItemNumber()));
			});
			List<ImportGeneralManifestMod> listWithCargoMovement = bls.stream()
					.filter(o -> o.getItemNumber() == null || o.getItemNumber().trim().equals(""))
					.collect(Collectors.toList());
			listWithCargoMovement.sort((c1, c2) -> {
				return c1.getCargoMovmnt().compareTo(c2.getCargoMovmnt());
			});
			// cargoMovmnt
			// Get BL#
			List<ImportGeneralManifestMod> listWithOutCargoMovementLC = listWithCargoMovement.stream()
					.filter(c -> c.getCargoMovmnt().trim().equals("LC")).collect(Collectors.toList());
			listWithOutCargoMovementLC.sort((c1, c2) -> {
				return c1.getBl().compareTo(c2.getBl());
			});
			System.out.println(listWithOutCargoMovementLC);
			List<ImportGeneralManifestMod> listWithOutCargoMovementTI = listWithCargoMovement.stream()
					.filter(c -> c.getCargoMovmnt().trim().equals("TI")).collect(Collectors.toList());
			listWithOutCargoMovementTI.sort((o1, o2) -> {
				return o1.getBl().compareTo(o2.getBl());
			});

			bls.clear();
			bls.addAll(listWithItemNumbers);
			bls.addAll(listWithOutCargoMovementLC);
			bls.addAll(listWithOutCargoMovementTI);

			finalResult.add(new ImportGeneralManifestResultSet(uMod, index, bls));
		}
		return finalResult;
	}

	/**
	 * Gets the unique records.
	 *
	 * @param list
	 *            the list
	 * @return the unique records
	 */
	public List<ImportGeneralManifestMod> getUniqueRecords(List<ImportGeneralManifestMod> list) {
		Set<ImportGeneralManifestMod> uniqueRecords = new LinkedHashSet<>(list);
		list = new ArrayList<>(uniqueRecords);
		return list;
	}

	/**
	 * Creates the header params.
	 *
	 * @param aobjForm
	 *            the aobj form
	 * @return the map
	 */
	private Map<String, String> createHeaderParams(ImportGeneralManifestUim aobjForm) {
		System.out.println("#IGMLogger createHeaderParams() started..");
		Map<String, String> mapParam = new HashMap<>();
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_BL, aobjForm.getBl());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_POD, aobjForm.getPod());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SERVICE, aobjForm.getIgmservice());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_VESSEL, aobjForm.getVessel());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_VOYAGE, aobjForm.getVoyage());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_POD_TERMINAL, aobjForm.getPodTerminal());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_FROM_DATE, aobjForm.getBlCreationDateFrom());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TO_DATE, aobjForm.getBlCreationDateTo());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_BL_STATUS, aobjForm.getInStatus());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_POL, aobjForm.getPol());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_POL_TERMINAL, aobjForm.getPolTerminal());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DIRECTION, aobjForm.getDirection());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DEPOT, aobjForm.getDepot());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DEL, aobjForm.getDel());
		return mapParam;
	}

	/**
	 * Creates the header params for save.
	 *
	 * @param objForm
	 *            the obj form
	 * @param blObj
	 *            the bl obj
	 * @param serviceObj
	 *            the service obj
	 * @return the map
	 */

	private Map<String, String> createHeaderParamsForSave(ImportGeneralManifestUim objForm, JSONObject blObj,
			JSONObject serviceObj, JSONArray consigneeArray, JSONArray consignerarray, JSONArray MarksNumberArray,
			JSONArray NotifyPartyArray) {
		// System.out.println("#IGMLogger createHeaderParamsForSave() started..");
		Map<String, String> mapParam = new HashMap<>();
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SERVICE, (String) (String) serviceObj.get("Service"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_VESSEL, (String) serviceObj.get("Vessel"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_VOYAGE, (String) serviceObj.get("Voyage"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT, (String) serviceObj.get("Port"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TERMINAL, (String) serviceObj.get("Terminal"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NEW_VESSEL, (String) serviceObj.get("New Vessel"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NEW_VOYAGE, (String) serviceObj.get("New Voyage"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_FROM_ITEM_NO, (String) serviceObj.get("From Item No"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TO_ITEM_NO, (String) serviceObj.get("To Item No"));
		if ("TI".equalsIgnoreCase((String) blObj.get("Cargo Movement"))
				&& "TRUE".equalsIgnoreCase((String) blObj.get("flag"))) {
			/* System.out.println("TI VALIDATION......"); */
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_ROAD_CARR_CODE, (String) blObj.get("Road Carr code"));
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_ROAD_TP_BOND_NO, (String) blObj.get("TP Bond No"));
		} else {
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_ROAD_CARR_CODE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_ROAD_TP_BOND_NO, "");
		}
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_POL, (String) serviceObj.get("Pol"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_POL_TERMINAL, (String) serviceObj.get("Pol Terminal"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TO_CUSTOM_TERMINAL_CODE,
				(String) serviceObj.get("Custom Terminal Code"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DEL, (String) serviceObj.get("DEL VLS"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DEPOT, (String) serviceObj.get("DEPOT VLS"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CUST_CODE, objForm.getCustomCode());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CALL_SIGN, objForm.getCallSign());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_IMO_CODE, objForm.getImoCode());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_AGENT_CODE, objForm.getAgentCode());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_LINE_CODE, objForm.getLineCode());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_ORIGIN, objForm.getPortOrigin());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_ARRIVAL, objForm.getPortOfArrival());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_LAST_PORT_1, objForm.getPrt1());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_LAST_PORT_2, objForm.getPrt2());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_LAST_PORT_3, objForm.getPrt3());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NEXT_PORT_1, objForm.getLast1());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NEXT_PORT_2, objForm.getLast2());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NEXT_PORT_3, objForm.getLast3());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_VESSEL_TYPE, objForm.getVesselTypes());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_GEN_DESC, objForm.getGeneralDescription());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_MASTER_NAME, objForm.getMasterName());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_IGM_NUMBER, objForm.getIgmNo());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_IGM_DATE, objForm.getIgmDate());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_VESSEL_NATION, objForm.getNationalityOfVessel());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ARRIVAL_DATE_ETA, objForm.getaDate());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ARRIVAL_TIME_ETA, objForm.getaTime());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ARRIVAL_DATE_ATA, objForm.getAtaAd());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ARRIVAL_TIME_ATA, objForm.getAtaAt());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TOTAL_BLS, objForm.getTotalItem());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_LIGHT_DUE, objForm.getLighthouseDue());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_GROSS_WEIGHT, objForm.getGrossWeightVessel());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NET_WEIGHT, objForm.getNetWeightVessel());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SM_BT_CARGO, objForm.getSameBottomCargo());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SHIP_STR_DECL, objForm.getShipStoreDeclaration());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CREW_LST_DECL, objForm.getCrewListDeclaration());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CARGO_DECL, objForm.getCargoDeclaration());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PASSNGR_LIST, objForm.getPassengerList());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CREW_EFFECT, objForm.getCrewEffect());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_MARITIME_DECL, objForm.getMaritimeDeclaration());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ITEM_NUMBER, (String) blObj.get("Item Number"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_BL_NO, (String) blObj.get("BL#"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CFS_NAME, (String) blObj.get("CFS-Custom Code"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CARGO_NATURE, (String) blObj.get("Cargo Nature"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CARGO_MOVMNT, (String) blObj.get("Cargo Movement"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ITEM_TYPE, (String) blObj.get("Item Type"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CARGO_MOVMNT_TYPE, (String) blObj.get("Cargo Movement Type"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TRANSPORT_MODE, (String) blObj.get("Transport Mode"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ROAD_CARR_CODE, (String) blObj.get("Road Carr code"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ROAD_TP_BOND_NO, (String) blObj.get("TP Bond No"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SUBMIT_DATE_TIME, (String) blObj.get("Submit Date Time"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DPD_MOVEMENT, (String) blObj.get("DPD Movement"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DPD_CODE, (String) blObj.get("DPD Code"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_BL_VEERSION, (String) blObj.get("BL Version"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DIRECTION, "10");
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_BL_DATE, removeSlashForBlDate((String) blObj.get("BL_Date")));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_MBL_NO, "");
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_HBL_NO, "");
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PACKAGES, "");
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NHAVA_SHEVA_ETA, "");
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_FINAL_PLACE_DELIVERY, "");
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_BL_STATUS, (String) blObj.get("BL Status"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_IS_PRESENT_IN_DB, (String) blObj.get("Is Present"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CUSTOM_ADD1, (String) blObj.get("Custom ADD1"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CUSTOM_ADD2, (String) blObj.get("Custom ADD2"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CUSTOM_ADD3, (String) blObj.get("Custom ADD3"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CUSTOM_ADD4, (String) blObj.get("Custom ADD4"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_IS_SELECTED, (String) blObj.get("flag"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_COLOR_FLAG, (String) blObj.get("BL Validate Flag"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PACKAGE_BL_LEVEL, (String) blObj.get("Package BL Level"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_GROSS_CARGO_WEIGHT_BL_LEVEL,
				(String) blObj.get("Gross Cargo Weight BL level"));

		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DEP_MANIF_NO, objForm.getDepartureManifestNumber());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_DEP_MANIFEST_DATE, objForm.getDepartureManifestDate());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SUBMITTER_TYPE, objForm.getSubmitterType());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SUBMITTER_TYPE, objForm.getSubmitterType());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_AUTHORIZ_REP_CODE, objForm.getAuthorizedRepresentativeCode());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SHIPPING_LINE_BOND_NO_R, objForm.getShippingLineBondNumber());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_MODE_OF_TRANSPORT, objForm.getModeofTransport());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SHIP_TYPE, objForm.getShipType());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONVEYANCE_REFERENCE_NO, objForm.getConveyanceReferenceNumber());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CARGO_DESCRIPTION, objForm.getCargoDescription());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TOL_NO_OF_TRANS_EQU_MANIF,
				objForm.getTotalNoofTransportEquipmentManifested());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_BRIEF_CARGO_DES, objForm.getBriefCargoDescription());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_EXPECTED_DATE, objForm.getExpectedDate());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TIME_OF_DEPT, objForm.getTimeofDeparture());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_CALL_COD, objForm.getPortofcallCoded());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TOTAL_NO_OF_TRAN_S_CONT_REPO_ON_ARI_DEP,
				objForm.getTotalnooftransportcontractsreportedonArrivalDeparture());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_MESSAGE_TYPE, objForm.getMesstype());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_VESSEL_TYPE_MOVEMENT, objForm.getVesselTypes());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_AUTHORIZED_SEA_CARRIER_CODE,
				objForm.getAuthorizedRepresentativeCode());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_REGISTRY, objForm.getPortoDreg());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_REGISTRY_DATE, objForm.getRegDate());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_VOYAGE_DETAILS, objForm.getVoyDetails());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SHIP_ITINERARY_SEQUENCE, objForm.getShipItiseq());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SHIP_ITINERARY, objForm.getShipItinerary());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_CALL_NAME, objForm.getPortofCallname());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_ARRIVAL_DEPARTURE_DETAILS, objForm.getArrivalDepdetails());
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TOTAL_NO_OF_TRANSPORT_EQUIPMENT_REPORTED_ON_ARRIVAL_DEPARTURE,
				objForm.getTotalnoTransarrivdep());

		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSOLIDATED_INDICATOR,
				(String) blObj.get("Consolidated Indicator"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PREVIOUS_DECLARATION, (String) blObj.get("Previous Declaration"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSOLIDATOR_PAN, (String) blObj.get("Consolidator PAN"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CIN_TYPE, (String) blObj.get("CIN TYPE"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_MCIN, (String) blObj.get("MCIN"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CSN_SUBMITTED_TYPE, (String) blObj.get("CSN Submitted Type"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CSN_SUBMITTED_BY, (String) blObj.get("CSN Submitted by"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CSN_REPORTING_TYPE, (String) blObj.get("CSN Reporting Type"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CSN_SITE_ID, (String) blObj.get("CSN Site ID"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CSN_NUMBER, (String) blObj.get("CSN Number"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CSN_DATE, (String) blObj.get("CSN Date"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PREVIOUS_MCIN, (String) blObj.get("Previous MCIN"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SPLIT_INDICATOR, (String) blObj.get("Split Indicator"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NUMBER_OF_PACKAGES, (String) blObj.get("Number of Packages"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TYPE_OF_PACKAGE, (String) blObj.get("Type of Package"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_FIRST_PORT_OF_ENTRY_LAST_PORT_OF_DEPARTURE,
				(String) blObj.get("First Port of Entry/Last Port of Departure"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TYPE_OF_CARGO, (String) blObj.get("Type Of Cargo"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_SPLIT_INDICATOR_LIST, (String) blObj.get("Split Indicator List"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_ACCEPTANCE, (String) blObj.get("Port of Acceptance"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_RECEIPT, (String) blObj.get("Port of Receipt"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_UCR_TYPE, (String) blObj.get("UCR Typel"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_UCR_CODE, (String) blObj.get("UCR Code"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_ACCEPTANCE_NAME,
				(String) blObj.get("Port of Acceptance Name"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_RECEIPT_NAME, (String) blObj.get("Port of Receipt Name"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PAN_OF_NOTIFIED_PARTY,
				(String) blObj.get("PAN of notified party"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_UNIT_OF_WEIGHT, (String) blObj.get("Unit of weight"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_GROSS_VOLUME, (String) blObj.get("Gross Volume"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_UNIT_OF_VOLUME, (String) blObj.get("Unit of Volume"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CARGO_ITEM_SEQUENCE_NO,
				(String) blObj.get("Cargo Item Sequence No"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CARGO_ITEM_DESCRIPTION,
				(String) blObj.get("Cargo Item Description"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_UNO_CODE, (String) blObj.get("UNO Code"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_IMDG_CODE, (String) blObj.get("IMDG Code"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NUMBER_OF_PACKAGES_HID,
				(String) blObj.get("Number of Packages Hidden"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_TYPE_OF_PACKAGES_HID,
				(String) blObj.get("Type of Packages Hidden"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONTAINER_WEIGHT, (String) blObj.get("Container Weight"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_CALL_SEQUENCE_NUMBER,
				(String) blObj.get("Port of call sequence numbe"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_PORT_OF_CALL_CODED, (String) blObj.get("Port of Call Coded"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_NEXT_PORT_OF_CALL_CODED,
				(String) blObj.get("Next port of call coded"));
		mapParam.put(ImportGeneralManifestDao.KEY_IGM_MC_LOCATION_CUSTOMS, (String) blObj.get("MC Location Customsl"));

		if (!consigneeArray.isEmpty()) {
			for (Object consobj : consigneeArray) {
				JSONObject consigneeObj = (JSONObject) consobj;
				if ((blObj.get("BL#")).equals(consigneeObj.get("blNO"))) {
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ADD1,
							(String) consigneeObj.get("addressLine1"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ADD2,
							(String) consigneeObj.get("addressLine2"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ADD3,
							(String) consigneeObj.get("addressLine3"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ADD4,
							(String) consigneeObj.get("addressLine4"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_COUNTRYCODE,
							(String) consigneeObj.get("countryCode"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_CODE,
							(String) consigneeObj.get("customerCode"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_NAME,
							(String) consigneeObj.get("customerName"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_STATE, (String) consigneeObj.get("state"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ZIP, (String) consigneeObj.get("zip"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_CITY, (String) consigneeObj.get("city"));
					break;
				}
			}
		} else {
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ADD1, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ADD2, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ADD3, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ADD4, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_COUNTRYCODE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_CODE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_NAME, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_STATE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_ZIP, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNEE_CITY, "");

		}
		if (!consignerarray.isEmpty()) {
			for (Object conrsobj : consignerarray) {
				JSONObject consinerObj = (JSONObject) conrsobj;
				if ((blObj.get("BL#")).equals(consinerObj.get("blNO"))) {
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ADD1,
							(String) consinerObj.get("addressLine1"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ADD2,
							(String) consinerObj.get("addressLine2"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ADD3,
							(String) consinerObj.get("addressLine3"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ADD4,
							(String) consinerObj.get("addressLine4"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_COUNTRYCODE,
							(String) consinerObj.get("countryCode"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_CODE,
							(String) consinerObj.get("customerCode"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_NAME,
							(String) consinerObj.get("customerName"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_STATE, (String) consinerObj.get("state"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ZIP, (String) consinerObj.get("zip"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_CITY, (String) consinerObj.get("city"));
					break;
				}
			}
		} else {
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ADD1, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ADD2, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ADD3, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ADD4, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_COUNTRYCODE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_CODE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_NAME, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_STATE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_ZIP, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_CONSIGNER_CITY, "");

		}
		if (!MarksNumberArray.isEmpty()) {
			for (Object markNumObj : MarksNumberArray) {
				JSONObject MarksNumberObj = (JSONObject) markNumObj;
				if ((blObj.get("BL#")).equals(MarksNumberObj.get("blNO"))) {
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_MARKSNUMBER_DESCRIPTION,
							(String) MarksNumberObj.get("description"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_MARKSNUMBER_MARKS,
							(String) MarksNumberObj.get("marksNumbers"));
					break;
				}
			}
		} else {
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_MARKSNUMBER_DESCRIPTION, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_MARKSNUMBER_MARKS, "");

		}
		if (!NotifyPartyArray.isEmpty()) {
			for (Object notifyparObj : NotifyPartyArray) {
				JSONObject NotifyPartyObj = (JSONObject) notifyparObj;
				if ((blObj.get("BL#")).equals(NotifyPartyObj.get("blNO"))) {
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ADD1,
							(String) NotifyPartyObj.get("addressLine1"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ADD2,
							(String) NotifyPartyObj.get("addressLine2"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ADD3,
							(String) NotifyPartyObj.get("addressLine3"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ADD4,
							(String) NotifyPartyObj.get("addressLine4"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_CITY,
							(String) NotifyPartyObj.get("city"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_COUNTRYCODE,
							(String) NotifyPartyObj.get("countryCode"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_CODE,
							(String) NotifyPartyObj.get("customerCode"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_NAME,
							(String) NotifyPartyObj.get("customerName"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_STATE,
							(String) NotifyPartyObj.get("state"));
					mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ZIP, (String) NotifyPartyObj.get("zip"));
					break;
				}
			}
		} else {
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ADD1, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ADD2, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ADD3, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ADD4, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_CITY, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_COUNTRYCODE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_CODE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_NAME, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_STATE, "");
			mapParam.put(ImportGeneralManifestDao.KEY_IGM_NOTIFYPARTY_ZIP, "");

		}

		return mapParam;

	}

	/**
	 * Merge files.
	 *
	 * @param file1
	 *            the file 1
	 * @param file2
	 *            the file 2
	 * @param file3
	 *            the file 3
	 * @throws IOException
	 *             Signals that an I/O exception has occurred.
	 */
	private void mergeFiles(String file1, String file2, String file3) throws IOException {
		String st;
		try (BufferedReader firstfile = new BufferedReader(new FileReader(file1));
				BufferedReader secondFile = new BufferedReader(new FileReader(file2));
				BufferedWriter mergedFile = new BufferedWriter(new FileWriter(file3));) {
			while ((st = firstfile.readLine()) != null) {
				if (st.startsWith("<END-cargo>")) {
					break;
				}
				mergedFile.write(st);
				mergedFile.newLine();
			}

			while ((st = secondFile.readLine()) != null) {
				if (st.startsWith("<cargo>")) {
					break;
				}
			}

			while ((st = secondFile.readLine()) != null) {
				if (st.startsWith("<END-cargo>")) {
					mergedFile.write(st);
					mergedFile.newLine();
					break;
				}
				mergedFile.write(st);
				mergedFile.newLine();
			}

			while ((st = firstfile.readLine()) != null) {
				if (st.startsWith("<END-contain>")) {
					break;
				}
				mergedFile.write(st);
				mergedFile.newLine();
			}

			while ((st = secondFile.readLine()) != null) {
				if (st.startsWith("<contain>")) {
					break;
				}
			}
			while ((st = secondFile.readLine()) != null) {
				if (st.startsWith("<END-contain>")) {
					mergedFile.write(st);
					mergedFile.newLine();
					break;
				}
				mergedFile.write(st);
				mergedFile.newLine();
			}

			while ((st = firstfile.readLine()) != null) {
				mergedFile.write(st);
				mergedFile.newLine();
			}
			System.out.println("Done");
		}
	}

	/**
	 * Write file.
	 *
	 * @param path
	 *            the path
	 * @param objForm
	 *            the obj form
	 * @param blList
	 *            the bl list
	 * @param serviceObj
	 *            the service obj
	 * @return the file
	 * @throws BusinessException
	 * @throws DataAccessException
	 */
	public static File writeFile(String path, ImportGeneralManifestUim objForm, JSONArray blList, JSONObject serviceObj,
			ImportGeneralManifestDao objDao, JSONArray notifyPartyDetailes, JSONArray marksNumberDtlstls,
			JSONArray containeerDtls, JSONArray consignee, JSONArray cnsNor)
			throws DataAccessException, BusinessException {

		System.out.println("#IGMLogger Form Data : " + objForm.toString());

		// F_SACHM23_SAM_DBCSW2256R_3456556_22082019_DEC.json
		// (<messageType><msgID><reportingEvent><SenderID><jobID><date>_declaration)
		String messageType = objForm.getMesstype();
		String msgID = "msgID"; // objForm.getM
		// String reportingEvent = objForm.getReportEvent();
		Map data = objDao.getSerialNumber(objForm.getSerialNumber());
		String serialNumber = data.get("selno").toString();
		String jobID = data.get("jobno").toString();// JOB NUMBER
		String currDate = LocalDate.now().toString().replaceAll("-", "");
		String currTime = new StringBuffer().append(LocalTime.now().getHour()).append(LocalTime.now().getMinute())
				.toString();
		System.out.println("currTime = " + currTime);
		String decHeader = "Declaration";
		String requestedJsonFile = objForm.getGeneratFalg();
		String senderId = "RCLAIPL123";
		File jsonFile = null;
		String jobNum = jobID;
		String msgTyp = "F";
		String rpngEvent = null;
		String mnfstDtRotnDt = null;
		String igm = objForm.getIgmNo();
		// Make use of new vessel and new voyage
		String voyage = isNull((String) serviceObj.get("Voyage"));
		String newVoyage = isNull((String) serviceObj.get("New Voyage"));
		String pol = isNull((String) serviceObj.get("Pol"));
		if (newVoyage != null && !newVoyage.trim().equals("")) {
			voyage = newVoyage;
		}
		String vessel = isNull((String) serviceObj.get("Vessel"));
		String newVessel = isNull((String) serviceObj.get("New Vessel"));
		// JSONObject marksNumberDtls = (JSONObject)marksNumberDtlstls;
		if (newVessel != null && !newVessel.trim().equals("")) {
			vessel = newVessel;
		}

		if (igm == "" || igm == null || igm == " " || igm.equals("")) {
			rpngEvent = "SAM";
			msgTyp = "F";
		} else {
			rpngEvent = "SAA";
			msgTyp = "A";
			mnfstDtRotnDt = getTimeHeader();
		}

		if ("SAMFILE".equals(requestedJsonFile) || "SAAFILE".equals(requestedJsonFile)) {
			// generatedFileNameOfJson = messageType + "_" + msgID + "_" + reportingEvent +
			// "_" + serialNumber + "_"
			// + jobID + "_" + currDate + "_" + decHeader + ".json";
			generatedFileNameOfJson = msgTyp + "_" + msgID + "_" + rpngEvent + "_" + senderId + "_" + jobID + "_"
					+ currDate + "_" + decHeader + ".json";

			// Creating object of all class
			List<ItemDtls> itemDtls = new ArrayList<ItemDtls>();
			List<TrnsprtEqmt> trnsprtEqmt = new ArrayList<TrnsprtEqmt>();
			List<LocCstm> locCstm = new ArrayList<LocCstm>();
			List<MCRef> mCRef = new ArrayList<MCRef>();
			List<TrnsprtDocMsr> trnsprtDocMsr = new ArrayList<TrnsprtDocMsr>();
			List<ShipItnry> shipItnry = new ArrayList<ShipItnry>();
			List<Itnry> itnry = new ArrayList<Itnry>();
			List<TrnsprtDoc> trnsprtDoc = new ArrayList<TrnsprtDoc>();
			// ===================

			for (Object blObjjson : blList) {
				JSONObject blObj = (JSONObject) blObjjson;

				Itnry itnryClassObj = new Itnry();
				// Set all value of Itney class
				itnryClassObj.setPrtOfCallSeqNmbr((String) blObj.get("Port of call sequence numbe "));
				itnryClassObj.setModeOfTrnsprt((String) blObj.get("Cargo Movement"));
				itnryClassObj.setNxtPrtOfCallCdd((String) blObj.get("Next port of call coded"));
				// itnryClassObj.setNxtPrtOfCallName((String) blObj.get(" "));
				itnryClassObj.setNxtPrtOfCallName(objForm.getPortofCallname());
				// itnryClassObj.setModeOfTrnsprt((String) blObj.get(" "));
				itnryClassObj.setModeOfTrnsprt(objForm.getModeofTransport());
				// itnryClassObj.setPrtOfCallCdd((String) blObj.get(" "));
				itnryClassObj.setPrtOfCallCdd(objForm.getPortofcallCoded());
				// add to MCRef List
				itnry.add(itnryClassObj);

				// ----------------------------
				MCRef mCRefClassObj = new MCRef();
				// Set all value of MCRef class
				mCRefClassObj.setLineNo((String) blObj.get("Item Number")); // Line 60
				mCRefClassObj.setMstrBlNo((String) blObj.get("BL#")); // Line 53
				mCRefClassObj.setMstrBlDt((String) blObj.get("BL_Date")); // Line 53
				mCRefClassObj.setConsolidatedIndctr((String) blObj.get("Consolidated Indicator")); // Line 76
				mCRefClassObj.setPrevDec((String) blObj.get("Previous Declaration")); // Line77
				mCRefClassObj.setConsolidatorPan((String) blObj.get("Consolidator PAN")); // Line 78

				// add to MCRef List
				mCRef.add(mCRefClassObj);

				// ----------------------------
				LocCstm locCstmClassObj = new LocCstm();
				// all value set
				// below two field are optional in both SAM and SEI so keep hard coded
				// locCstmClassObj.setFirstPrtOfEntry((String) blObj.get(" "));
				locCstmClassObj.setFirstPrtOfEntry((String) blObj.get("First Port of Entry/Last Port of Departure"));
				locCstmClassObj.setDestPrt((String) blObj.get("CFS-Custom Code"));
				// locCstmClassObj.setNxtPrtOfUnlading((String) blObj.get(" ")); // red color
				// mean not cleared by Guru
				locCstmClassObj.setTypOfCrgo((String) blObj.get("Type Of Cargo")); // Line 90
				locCstmClassObj.setItemTyp((String) blObj.get("Item Type")); // Line 61
				locCstmClassObj.setCrgoMvmt((String) blObj.get("Cargo Movement")); // Line 57
				locCstmClassObj.setNatrOfCrgo((String) blObj.get("Cargo Nature")); // Line 59
				locCstmClassObj.setSplitIndctr((String) blObj.get("Split Indicato")); // Line 91
				locCstmClassObj.setNmbrOfPkgs((String) blObj.get("Number of Packages")); // Line 82
				locCstmClassObj.setTypOfPackage((String) blObj.get("Type of Package")); // Line 88

				locCstm.add(locCstmClassObj);
				// ------------------------------------------

				TrnsprtDocMsr trnsprtDocMsrClassObj = new TrnsprtDocMsr();

				// all value set
				trnsprtDocMsrClassObj.setNmbrOfPkgs((String) blObj.get("Number of Packages Hidden"));
				trnsprtDocMsrClassObj.setTypsOfPkgs((String) blObj.get("Type of Packages Hidden"));
				// trnsprtDocMsrClassObj.setMarksNoOnPkgs((String) blObj.get(" "));//below in
				// mark and no of for loop
				trnsprtDocMsrClassObj.setGrossWeight((String) blObj.get("Gross Cargo Weight BL level"));
				// below field is optional in both SAM and SEI so keep hard coded
				trnsprtDocMsrClassObj.setNetWeight("");
				trnsprtDocMsrClassObj.setUnitOfWeight((String) blObj.get("Unit of weight"));
				// trnsprtDocMsrClassObj.setInvoiceValueOfCnsgmt(" "); // not cleared by Guru
				trnsprtDocMsrClassObj.setCrncyCd("  "); // not cleared by Guru
				// add to trnsprtDocMsr List
				// trnsprtDocMsr.add(trnsprtDocMsrClassObj); below in mark nad no loop

				// --------------------------------------------------------

				// ------------------------------------------------------
				ItemDtls itemDtlsClassObj = new ItemDtls();

				// set all value to ItemDtls
				// # not given in scma
				// trnsprtEqmtClassObj.setHsCd((String)blObj.get(" ")); not cleared by guru

				itemDtlsClassObj.setCrgoItemSeqNmbr((String) blObj.get("Cargo Item Sequence No"));
				itemDtlsClassObj.setCrgoItemDesc((String) blObj.get("Cargo Item Description"));
				itemDtlsClassObj.setUnoCd((String) blObj.get("UNO Cod"));
				itemDtlsClassObj.setImdgCd((String) blObj.get("IMDG Code"));
				itemDtlsClassObj.setNmbrOfPkgs("");
				itemDtlsClassObj.setTypOfPkgs("");

				// add to trnsprtDocMsr List
				itemDtls.add(itemDtlsClassObj);
				// ------------------------------------------------------
				TrnsprtDoc trnsprtDocClassObj = new TrnsprtDoc();

				trnsprtDocClassObj.setPrtOfAcptName((String) blObj.get("Port of Acceptance Name"));
				trnsprtDocClassObj.setPrtOfReceiptName((String) blObj.get("Port of Receipt Name"));
				trnsprtDocClassObj.setPrtOfAcptCdd((String) blObj.get("Port of Acceptance"));
				trnsprtDocClassObj.setPrtOfReceiptCdd((String) blObj.get("Port of Receipt"));
				trnsprtDocClassObj.setUcrTyp((String) blObj.get("UCR Typel"));
				trnsprtDocClassObj.setUcrCd((String) blObj.get("UCR Code"));
				// System.out.println("length = " + add.length());
				// for notifyPartyDetailes and cogni detales
				for (Object notifyObj : notifyPartyDetailes) {
					JSONObject notyObj = (JSONObject) notifyObj;

					if ((blObj.get("BL#")).equals(notyObj.get("blNO"))) {
						String add = (String) notyObj.get("addressLine1") + notyObj.get("addressLine2")
								+ (String) notyObj.get("addressLine3");
						// set all values in TrnsprtDoc Class Obj
						trnsprtDocClassObj.setNotfdPartyStreetAddress(add);
						trnsprtDocClassObj.setNotfdPartyCity((String) notyObj.get("city"));
						trnsprtDocClassObj.setNotfdPartyCntrySubDivName((String) notyObj.get("state"));
						trnsprtDocClassObj.setNotfdPartyCntrySubDiv((String) notyObj.get(""));
						trnsprtDocClassObj.setNotfdPartyCntryCd((String) notyObj.get("countryCode"));
						trnsprtDocClassObj.setNotfdPartyPstcd((String) notyObj.get("zip"));
						trnsprtDocClassObj.setTypOfNotfdPartyCd((String) notyObj.get("customerCode"));
					}
				}
				trnsprtDocClassObj.setPanOfNotfdParty((String) blObj.get("PAN of notified party"));
				// ------------------------------------------------------------------
				for (Object nMD : marksNumberDtlstls) {
					JSONObject marksAndNumberDtls = (JSONObject) nMD;
					if ((blObj.get("BL#")).equals(marksAndNumberDtls.get("blNO"))) {
						trnsprtDocMsrClassObj.setMarksNoOnPkgs((String) marksAndNumberDtls.get("marksNumbers"));
						trnsprtDocClassObj.setGoodsDescAsPerBl((String) marksAndNumberDtls.get("description"));
					}
				}
				trnsprtDocMsr.add(trnsprtDocMsrClassObj);
				// ---------------------------------------------------

				// for (Object ctnerDtls: containeerDtls) {
				for (Object coneeDtls : consignee) {
					JSONObject cnerDtl = (JSONObject) coneeDtls;

					if ((blObj.get("BL#")).equals(cnerDtl.get("blNO"))) {
						String add = (String) cnerDtl.get("addressLine1") + cnerDtl.get("addressLine2")
								+ (String) cnerDtl.get("addressLine3") + (String) cnerDtl.get("addressLine4");
						// set all values in TrnsprtDoc Class Obj
						trnsprtDocClassObj.setCnsgneStreetAddress(add);
						trnsprtDocClassObj.setCnsgnesName((String) cnerDtl.get("customerName"));
						trnsprtDocClassObj.setCnsgneCity((String) cnerDtl.get("city"));
						trnsprtDocClassObj.setCnsgneCntrySubDivName((String) cnerDtl.get("state"));
						trnsprtDocClassObj.setCnsgneCntrySubDiv((String) cnerDtl.get(""));
						trnsprtDocClassObj.setCnsgneCntryCd((String) cnerDtl.get("countryCode"));
						trnsprtDocClassObj.setCnsgnePstcd((String) cnerDtl.get("zip"));
						trnsprtDocClassObj.setCnsgnrsCd((String) cnerDtl.get("customerCode"));
					}
				}

				// --------------------------------------------------------
				for (Object coneeDtls : cnsNor) {
					JSONObject cnerDtl = (JSONObject) coneeDtls;

					if ((blObj.get("BL#")).equals(cnerDtl.get("blNO"))) {
						String add = (String) cnerDtl.get("addressLine1") + cnerDtl.get("addressLine2")
								+ (String) cnerDtl.get("addressLine3") + (String) cnerDtl.get("addressLine4");
						// set all values in TrnsprtDoc Class Obj cnsgnrsName;
						trnsprtDocClassObj.setCnsgnrsCd((String) cnerDtl.get("customerCode"));
						trnsprtDocClassObj.setCnsgnrStreetAddress(add);
						trnsprtDocClassObj.setCnsgnrsName((String) cnerDtl.get("customerName"));
						trnsprtDocClassObj.setCnsgnrCity((String) cnerDtl.get("city"));
						trnsprtDocClassObj.setCnsgnrCntrySubDivName((String) cnerDtl.get("state"));
						trnsprtDocClassObj.setCnsgnrsCd((String) cnerDtl.get("customerCode"));
						trnsprtDocClassObj.setCnsgnrCntrySubDivCd((String) cnerDtl.get(""));
						trnsprtDocClassObj.setCnsgnrCntryCd((String) cnerDtl.get("countryCode"));
						trnsprtDocClassObj.setCnsgnrPstcd((String) cnerDtl.get("zip"));
					}
				}
				trnsprtDoc.add(trnsprtDocClassObj);
				// ------------------------------------------------

				TrnsprtEqmt trnsprtEqmtClassObj = new TrnsprtEqmt();

				for (Object ctnerDtls : containeerDtls) {
					JSONObject ctnerDtl = (JSONObject) ctnerDtls;

					if ((blObj.get("BL#")).equals(ctnerDtl.get("blNO"))) {

						trnsprtEqmtClassObj.setEqmtSeqNo((String) ctnerDtl.get("containerAgentCode"));
						trnsprtEqmtClassObj.setEqmtId((String) ctnerDtl.get("containerNumber"));
						trnsprtEqmtClassObj.setEqmtTyp("CN"); // alway CN hard codded customerCode
						// trnsprtEqmtClassObj.setEqmtSize((String) ctnerDtl.get("ISOCode")); //optonal
						// filed
						trnsprtEqmtClassObj.setEqmtLoadStatus((String) ctnerDtl.get("status"));
						trnsprtEqmtClassObj.setEqmtSealTyp((String) ctnerDtl.get("equipment_seal_type"));
						trnsprtEqmtClassObj.setEqmtSealNmbr((String) ctnerDtl.get("containerSealNumber"));
						trnsprtEqmtClassObj.setSocFlag((String) ctnerDtl.get("soc_flag"));
						// trnsprtEqmtClassObj.setAdtnlEqmtHold((String) blObj.get(" "));

					}
				} // add to trnsprtDocMsr List
				trnsprtEqmt.add(trnsprtEqmtClassObj);
				// ------------------------------------------------
				ShipItnry shipItny3 = new ShipItnry();
				String prtOfCallCdd = null;
				String itnrySeq = null;
				// all value set
				if (objForm.getPrt1() == null || objForm.getPrt1() == "") {
					prtOfCallCdd = null;
					itnrySeq = null;
				} else {
					itnrySeq = "-3";
					prtOfCallCdd = objForm.getPrt1();
				}
				shipItny3.setShipItnrySeq(itnrySeq);// if not null -3
				shipItny3.setPrtOfCallCdd(prtOfCallCdd);

				if (objForm.getPrt2() == null || objForm.getPrt2() == "") {
					prtOfCallCdd = null;
					itnrySeq = null;
				} else {
					itnrySeq = "-2";
					prtOfCallCdd = objForm.getPrt2();
				}
				ShipItnry shipItnry2 = new ShipItnry();
				shipItnry2.setShipItnrySeq(itnrySeq);
				shipItnry2.setPrtOfCallCdd(prtOfCallCdd);

				if (objForm.getPrt3() == null || objForm.getPrt3() == "") {
					prtOfCallCdd = null;
					itnrySeq = null;
				} else {
					itnrySeq = "-1";

					prtOfCallCdd = objForm.getPrt3();
				}
				ShipItnry shipItnry1 = new ShipItnry();
				shipItnry1.setShipItnrySeq(itnrySeq);
				shipItnry1.setPrtOfCallCdd(prtOfCallCdd);

				ShipItnry shipItnry0 = new ShipItnry();
				shipItnry0.setShipItnrySeq("0");
				shipItnry0.setPrtOfCallCdd(objForm.getPod()); // blObj.get("Port of call sequence numbe"));
				shipItnry0.setPrtOfCallName((String) blObj.get("Port of Call Coded"));

				if (objForm.getLast1() == null || objForm.getLast1() == "") {
					prtOfCallCdd = null;
					itnrySeq = null;
				} else {
					itnrySeq = "1";
					prtOfCallCdd = objForm.getLast1();
				}
				ShipItnry shipItnry11 = new ShipItnry();
				shipItnry11.setShipItnrySeq(itnrySeq);
				shipItnry11.setPrtOfCallCdd(prtOfCallCdd);

				if (objForm.getLast2() == null || objForm.getLast2() == "") {
					prtOfCallCdd = null;
					itnrySeq = null;
				} else {
					itnrySeq = "2";
					prtOfCallCdd = objForm.getLast2();
				}
				ShipItnry shipItnry22 = new ShipItnry();
				shipItnry22.setShipItnrySeq(itnrySeq);
				shipItnry22.setPrtOfCallCdd(prtOfCallCdd);
				shipItnry22.setPrtOfCallName((String) blObj.get("Port of Call Coded"));

				if (objForm.getLast3() == null || objForm.getLast3() == "") {
					prtOfCallCdd = null;
					itnrySeq = null;
				} else {
					itnrySeq = "3";
					prtOfCallCdd = objForm.getLast3();
				}
				ShipItnry shipItnry33 = new ShipItnry();
				shipItnry33.setShipItnrySeq(itnrySeq);
				shipItnry33.setPrtOfCallCdd(prtOfCallCdd);
				shipItnry33.setPrtOfCallName((String) blObj.get("Port of call sequence numbe"));
				// add to trnsprtDocMsr List
				shipItnry.add(shipItny3);
				shipItnry.add(shipItnry2);
				shipItnry.add(shipItnry1);
				shipItnry.add(shipItnry0);
				shipItnry.add(shipItnry11);
				shipItnry.add(shipItnry22);
				shipItnry.add(shipItnry33);
				// ------------------------------------------------------
			}
			// now add all List to relevant classs

			MastrCnsgmtDec mastrCnsgmtDec = new MastrCnsgmtDec();
			mastrCnsgmtDec.setItemDtls(itemDtls);
			mastrCnsgmtDec.setItnry(itnry);
			mastrCnsgmtDec.setLocCstm(locCstm);
			mastrCnsgmtDec.setmCRef(mCRef);
			mastrCnsgmtDec.setTrnsprtDoc(trnsprtDoc);
			mastrCnsgmtDec.setTrnsprtDocMsr(trnsprtDocMsr);
			mastrCnsgmtDec.setTrnsprtEqmt(trnsprtEqmt);

			List<MastrCnsgmtDec> mastrCnsgmtDecList = new ArrayList<MastrCnsgmtDec>();
			mastrCnsgmtDecList.add(mastrCnsgmtDec);

			VoyageDtls voyageDtlsClassObj = new VoyageDtls();
			voyageDtlsClassObj.setVoyageNo(voyage); // Line10
			voyageDtlsClassObj.setCnvnceRefNmbr(objForm.getConveyanceReferenceNumber()); // Line 193
			voyageDtlsClassObj.setTotalNoOfTrnsprtEqmtMnfsted(objForm.getCargoDeclaration()); // Line:-46
			voyageDtlsClassObj.setCrgoDescCdd(objForm.getCargoDescription()); // Line:-195
			voyageDtlsClassObj.setBriefCrgoDesc(objForm.getBriefCargoDescription()); // Line:-195
			voyageDtlsClassObj.setTotalNmbrOfLines(objForm.getTotalItem()); // Line38
			voyageDtlsClassObj.setExptdDtAndTimeOfArvl(objForm.getaDate() + "T" + getTime(objForm.getaTime()));
			voyageDtlsClassObj.setExptdDtAndTimeOfDptr(objForm.getaDate() + "T" + getTime(objForm.getaTime()));
			voyageDtlsClassObj.setNmbrOfPsngrsMnfsted(" "); // NotFound
			voyageDtlsClassObj.setNmbrOfCrewMnfsted(objForm.getCrewListDeclaration());
			voyageDtlsClassObj.setShipItnry(shipItnry);

			List<VoyageDtls> voyageDtlsList = new ArrayList<VoyageDtls>();
			voyageDtlsList.add(voyageDtlsClassObj);
			// ---------------------------------------------------
			VesselDtls vesselDtls = new VesselDtls();

			vesselDtls.setModeOfTrnsprt(objForm.getModeofTransport()); // Line 191
			// vesselDtls.setTypOfTrnsprtMeans(objForm.getImoCode()); // not found
			// vesselDtls.setTrnsprtMeansId("");
			vesselDtls.setVesselCd(objForm.getCallSign()); // Line 19
			vesselDtls.setShipTyp(objForm.getShipType()); // Line 192
			vesselDtls.setPurposeOfCall("1"); // always hard coded
			List<VesselDtls> vesselDtlsList = new ArrayList<VesselDtls>();
			vesselDtlsList.add(vesselDtls);
			// ----------------------------
			AuthPrsn authPrsClassObj = new AuthPrsn();
			authPrsClassObj.setSbmtrTyp(objForm.getSubmitterType()); //
			authPrsClassObj.setSbmtrCd(objForm.getSubmitterCode()); //
			authPrsClassObj.setAuthReprsntvCd(objForm.getAuthorizedRepresentativeCode()); //
			authPrsClassObj.setShpngLineCd("RCL"); // VALUE AL WAYS RCL
			authPrsClassObj.setAuthSeaCarrierCd(objForm.getAuthoseaCarcode()); // LinNo:-211
			authPrsClassObj.setMasterName(objForm.getMasterName());// 21
			authPrsClassObj.setShpngLineBondNmbr(objForm.getShippingLineBondNumber()); // LinNo:-190
			authPrsClassObj.setTrmnlOprtrCd(objForm.getCustomCode()); // LinNo:-132
			List<AuthPrsn> authPrsnList = new ArrayList<AuthPrsn>();
			authPrsnList.add(authPrsClassObj);
			// ----------------------------
			DecRef decRefClaObj = new DecRef();

			// decRefClaObj.setMsgTyp(objForm.getMesstype());
			decRefClaObj.setMsgTyp(msgTyp);
			decRefClaObj.setPrtofRptng(objForm.getPod()); // value from old screen [Pod]
			// decRefClaObj.setJobNo(objForm.getJobNum()); // sid will give this Number
			decRefClaObj.setJobNo(jobNum);
			// decRefClaObj.setJobDt(objForm.getJobDate()); //sid told me to keep crunt date
			decRefClaObj.setJobDt(currDate);
			// decRefClaObj.setRptngEvent(objForm.getReportEvent()); //
			decRefClaObj.setRptngEvent(rpngEvent);
			decRefClaObj.setMnfstNoRotnNo(objForm.getIgmNo()); //
			decRefClaObj.setMnfstDtRotnDt(objForm.getIgmDate()); //
			decRefClaObj.setVesselTypMvmt(objForm.getVesType()); //
			// #
			// * decRefClaObj.setDptrMnfstNo(); //
			// *decRefClaObj.setDptrMnfstDt(""); //
			// #
			List<DecRef> decRefList = new ArrayList<DecRef>();
			decRefList.add(decRefClaObj);
			// ----------------------------
			PrsnDtls prsDtls = new PrsnDtls();
			prsDtls.setPrsnTypCdd("");
			prsDtls.setPrsnFamilyName("");
			prsDtls.setPrsnGivenName("");
			prsDtls.setPrsnNatnltyCdd("");
			prsDtls.setPsngrInTransitIndctr("");
			prsDtls.setCrewmemberRankOrRatingCdd("");
			prsDtls.setPsngrPrtOfEmbrktnCdd("");
			prsDtls.setPsngrPrtOfDsmbrktnCdd("");
			prsDtls.setPrsnGenderCdd("");
			prsDtls.setPrsnDtOfBirth("");
			prsDtls.setPrsnPlaceOfBirthName("");
			prsDtls.setPrsnCntryOfBirthCdd("");

			// -----------------------------------------

			PrsnId prsnIdclassObj = new PrsnId();
			prsnIdclassObj.setPrsnIdDocExpiryDt("");
			prsnIdclassObj.setPrsnIdOrTravelDocIssuingNationCdd("");
			prsnIdclassObj.setPrsnIdOrTravelDocNmbr("");
			prsnIdclassObj.setPrsnIdOrTravelDocTypCdd("");
			List<PrsnId> prsnIdList = new ArrayList<PrsnId>();
			prsnIdList.add(prsnIdclassObj);
			// ---------------
			List<PrsnDtls> prsnDtlsList = new ArrayList<PrsnDtls>();
			prsnDtlsList.add(prsDtls);
			PrsnOnBoard prsnOnBoard = new PrsnOnBoard();
			prsnOnBoard.setPrsnDtls(prsnDtlsList);
			prsnOnBoard.setPrsnId(prsnIdList);
			prsnOnBoard.setPrsnOnBoardSeqNmbr("");

			List<PrsnOnBoard> prsnOnBoardList = new ArrayList<PrsnOnBoard>();
			prsnOnBoardList.add(prsnOnBoard);
			// ---------------
			int i = 0;
			List<VoyageTransportEquipment> voyageTransportEquipmentList = new ArrayList<VoyageTransportEquipment>();
			for (Object coneeDtls : containeerDtls) {
				JSONObject cnerDtl = (JSONObject) coneeDtls;
				System.out.println("   coneeDtls  " + i + ((String) cnerDtl.get("containerSealNumber")));
				VoyageTransportEquipment voyageTransportEquipmentClassObj = new VoyageTransportEquipment();
				voyageTransportEquipmentClassObj.setQuipmentSequenceNo(((String) cnerDtl.get("containerSealNumber")));
				voyageTransportEquipmentClassObj.setQuipmentId(((String) cnerDtl.get("containerNumber")));
				voyageTransportEquipmentClassObj.setQuipmentType("CN");
				voyageTransportEquipmentClassObj.setQuipmentLoadStatus(((String) cnerDtl.get("equipmentLoadStatus")));
				voyageTransportEquipmentClassObj.setSocFlag((String) cnerDtl.get("soc_flag"));

				voyageTransportEquipmentList.add(voyageTransportEquipmentClassObj);
			}

			// --------------------
			DigSign digSignClassObj = new DigSign();
			digSignClassObj.setStartSignature("");
			digSignClassObj.setStartCertificate("");
			digSignClassObj.setSignerVersion("");

			List<DigSign> digSignList = new ArrayList<DigSign>();
			digSignList.add(digSignClassObj);
			// ----------------
			Master mster = new Master();
			mster.setMastrCnsgmtDec(mastrCnsgmtDecList);
			mster.setVoyageDtls(voyageDtlsList);
			mster.setVesselDtls(vesselDtlsList);
			mster.setAuthPrsn(authPrsnList);
			mster.setDecRef(decRefList);
			// mster.setPrsnOnBoard(prsnOnBoardList);
			mster.setVoyageTransportEquipment(voyageTransportEquipmentList);
			// ----------------------------------
			HeaderField headerFieldClassObj = new HeaderField();

			headerFieldClassObj.setSenderID(senderId);
			// Port Code Default value :- ( For NHAVA SHEVA :- INNSA1 / MUMBAI :- INBOM1 /
			// MUNDRA :- INMUN1 & PIPAVAV :- INPAV1 )
			// headerFieldClassObj.setReceiverID(objForm.getCustomCode());
			// from old disscutions
			headerFieldClassObj.setReceiverID(objForm.getPod());
			headerFieldClassObj.setVersionNo("1.0");
			headerFieldClassObj.setIndicator("T");
			// "Default value: IECHE01"
			headerFieldClassObj.setMessageID("IECHE01");
			headerFieldClassObj.setSequenceOrControlNumber(serialNumber);// old screen String sId (
			headerFieldClassObj.setDate(currDate);
			headerFieldClassObj.setTime("T" + getTimeHeader());
			// "Default value: ES"
			headerFieldClassObj.setReportingEvent("ES");
			// -------------------------------------------------

			List<Master> masterList = new ArrayList<Master>();
			masterList.add(mster);
			List<HeaderField> headerFieldList = new ArrayList<HeaderField>();
			headerFieldList.add(headerFieldClassObj);
			JsonMainObjct org = new JsonMainObjct();
			// org.setHeaderField(headerFieldList);
			org.setHeaderField(headerFieldList);
			// org.setDigSign(digSignList);
			org.setMaster(masterList);

			// Creating Object of ObjectMapper define in Jakson Api
			ObjectMapper Obj = new ObjectMapper();
			jsonFile = new File(generatedFileNameOfJson);
			FileWriter file;
			try {
				// get Oraganisation object as a json string
				String jsonStr = Obj.writeValueAsString(org);
				// Displaying JSON String
				System.out.println(jsonStr);
				file = new FileWriter(jsonFile);
				file.write(jsonStr);
				file.flush();
			}

			catch (IOException e) {
				e.printStackTrace();
			}

		} else {
			generatedFileNameOfJson = "F" + "_" + msgID + "_" + "SEI" + "_" + senderId + "_" + jobID + "_" + currDate
					+ "_" + decHeader + ".json";
			jsonFile = new File(generatedFileNameOfJson);

			ShipStoresSEI shipStoreSEI = new ShipStoresSEI();

			CrewEfctSEI crewEfctSEI = new CrewEfctSEI();
			crewEfctSEI.setCrewEfctDescCdd("crewEfctDescCdd");
			crewEfctSEI.setCrewEfctQntyCdOnbrd("crewEfctQntyCdOnbrd");
			crewEfctSEI.setCrewEfctQntyOnbrd("crewEfctQntyOnbrd");
			crewEfctSEI.setCrewEfctsDesc("crewEfctsDesc");
			crewEfctSEI.setCrewEfctsSeqNmbr("crewEfctsSeqNmbr");

			List<CrewEfctSEI> crewEfctSEIList = new ArrayList<CrewEfctSEI>();
			crewEfctSEIList.add(crewEfctSEI);
			// --------------------------------------------

			PrsnOnBoardSEI prsnOnBoard = new PrsnOnBoardSEI();
			prsnOnBoard.setCrewEfct(crewEfctSEIList);
			prsnOnBoard.setPrsnOnBoardSeqNmbr("");

			List<PrsnOnBoardSEI> prsnOnBoardList = new ArrayList<PrsnOnBoardSEI>();
			prsnOnBoardList.add(prsnOnBoard);

			// ---------------------------
			ArvlDtlsSEI arvlDtlsSEI = new ArvlDtlsSEI();
			arvlDtlsSEI.setLightHouseDues(objForm.getLighthouseDue());
			// sid told me to keep hard code below value
			// arvlDtlsSEI.setNmbrOfCrew("CREW");
			arvlDtlsSEI.setNmbrOfPsngrs("nmbrOfPsngrs");
			arvlDtlsSEI.setTotalNmbrOfPrsnsOnBoard("totalNmbrOfPrsnsOnBoard");
			arvlDtlsSEI.setTotalNmbrOfTrnsprtContractsRprtdOnArvlDptr("totalNmbrOfTrnsprtContractsRprtdOnArvlDptr");
			arvlDtlsSEI.setTotalNoOfCntrsLanded("totalNoOfCntrsLanded");
			arvlDtlsSEI.setTotalNoOfCntrsLoaded("totalNoOfCntrsLoaded");
			arvlDtlsSEI.setTotalNoOfTrnsprtEqmtRprtdOnArvlDptr("totalNoOfTrnsprtEqmtRprtdOnArvlDptr");
			List<ArvlDtlsSEI> arvlDtlsSEIList = new ArrayList<ArvlDtlsSEI>();
			arvlDtlsSEIList.add(arvlDtlsSEI);

			// --------------------------------

			DigSignSEI digSignClassObj = new DigSignSEI();
			digSignClassObj.setStartSignature("");
			digSignClassObj.setStartCertificate("");
			digSignClassObj.setSignerVersion("");

			List<DigSignSEI> digSignList = new ArrayList<DigSignSEI>();
			digSignList.add(digSignClassObj);

			// ---------------------------------
			VesselDtlsSEI vesselDtls = new VesselDtlsSEI();

			vesselDtls.setModeOfTrnsprt(objForm.getModeofTransport()); // Line 191
			// vesselDtls.setTypOfTrnsprtMeans(" "); // not found
			// vesselDtls.setTrnsprtMeansId("");

			List<VesselDtlsSEI> vesselDtlsList = new ArrayList<VesselDtlsSEI>();
			vesselDtlsList.add(vesselDtls);

			// ----------------------------
			AuthPrsnSEI authPrsClassObj = new AuthPrsnSEI();
			authPrsClassObj.setSbmtrTyp(objForm.getSubmitterType()); //
			authPrsClassObj.setSbmtrCd(objForm.getSubmitterCode()); //
			authPrsClassObj.setAuthReprsntvCd(objForm.getAuthorizedRepresentativeCode()); //
			// authPrsClassObj.setShpngLineCd(objForm.getShilinCode()); // LineNo:-210
			authPrsClassObj.setAuthSeaCarrierCd(objForm.getAuthoseaCarcode()); // LinNo:-211
			// authPrsClassObj.setMasterName(objForm.getMasterName());// 21
			authPrsClassObj.setShpngLineBondNmbr(objForm.getShippingLineBondNumber()); // LinNo:-190
			authPrsClassObj.setTrmnlOprtrCd(objForm.getCustomCode()); // LinNo:-132
			List<AuthPrsnSEI> authPrsnList = new ArrayList<AuthPrsnSEI>();
			authPrsnList.add(authPrsClassObj);
			// ----------------------------
			DecRefSEI decRefClaObj = new DecRefSEI();

			decRefClaObj.setMsgTyp("F");
			decRefClaObj.setPrtofRptng(objForm.getPod()); // value from old screen [Pod]
			// decRefClaObj.setJobNo(objForm.getJobNum()); // sid will give this Number
			decRefClaObj.setJobNo(jobNum);
			decRefClaObj.setJobDt(currDate);
			decRefClaObj.setRptngEvent("SEI");
			decRefClaObj.setMnfstNoRotnNo(objForm.getIgmNo());
			decRefClaObj.setMnfstDtRotnDt(objForm.getIgmDate());
			decRefClaObj.setVesselTypMvmt(objForm.getVesType());

			List<DecRefSEI> decRefList = new ArrayList<DecRefSEI>();
			decRefList.add(decRefClaObj);
			// ----------------------------
			HeaderFieldSEI headerFieldClassObj = new HeaderFieldSEI();
			headerFieldClassObj.setSenderID(senderId);
			headerFieldClassObj.setReceiverID(objForm.getPod());
			headerFieldClassObj.setVersionNo("1.0");
			headerFieldClassObj.setIndicator("T");
			// "Default value: IECHE01"
			headerFieldClassObj.setMessageID("IECHE01");
			headerFieldClassObj.setSequenceOrControlNumber(serialNumber);
			headerFieldClassObj.setDate(currDate);
			headerFieldClassObj.setTime("T" + getTimeHeader());
			headerFieldClassObj.setReportingEvent("ES");

			List<HeaderFieldSEI> headerFieldSEIList = new ArrayList<HeaderFieldSEI>();
			headerFieldSEIList.add(headerFieldClassObj);

			MasterSEI mster = new MasterSEI();
			mster.setArvlDtls(arvlDtlsSEIList);
			mster.setVesselDtls(vesselDtlsList);
			mster.setAuthPrsn(authPrsnList);
			mster.setDecRef(decRefList);
			// mster.setPrsnOnBoard(prsnOnBoardList);

			List<MasterSEI> msterList = new ArrayList<MasterSEI>();
			msterList.add(mster);

			// ----------------------------------

			JsonSEIObjct jSEI = new JsonSEIObjct();
			// jSEI.setDigSign(digSignList);
			jSEI.setHeaderField(headerFieldSEIList);
			jSEI.setMaster(msterList);
			// Creating Object of ObjectMapper define in Jakson Api
			ObjectMapper Obj = new ObjectMapper();
			jsonFile = new File(generatedFileNameOfJson);
			FileWriter file;
			try {
				// get Oraganisation object as a json string
				String jsonStr = Obj.writeValueAsString(jSEI);
				// Displaying JSON String
				System.out.println(jsonStr);
				file = new FileWriter(jsonFile);
				file.write(jsonStr);
				file.flush();
			}

			catch (IOException e) {
				e.printStackTrace();
			}

		}

		return jsonFile;
	}

	public static String getTime(String currTime) {
		System.out.println("getTime(currTime) = " + currTime);
		if (currTime == null || currTime.length() < 2)
			return currTime;
		return currTime.substring(0, 2) + ":" + currTime.substring(2);
	}

	public static String getTimeHeader() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm");
		LocalDateTime now = LocalDateTime.now();
		return (dtf.format(now));
	}

	/**
	 * Checks if is null.
	 *
	 * @param sId
	 *            the s id
	 * @return the string
	 */
	private static String isNull(String sId) {
		return (sId == null) ? "" : sId;
	}
	
	
	private static String isNullUno(String sId) {
		return (sId == null) ? "ZZZZZ" : sId;
	}
	/**
	 * Removes the slash.
	 *
	 * @param date
	 *            the date
	 * @return the string
	 */
	public static String removeSlash(String date) {
		if (date.contains("/"))
			date = date.replaceAll("/", "");
		return date;
	}

	/**
	 * Removes the slash.
	 *
	 * @param date
	 *            the date
	 * @return the string
	 */
	public static String removeSlashForBlDate(String date) {
		if (date != null && !date.equals(""))
			;
		{
			String dateArray[] = date.split("/");
			date = dateArray[2] + dateArray[1] + dateArray[0];
		}
		return date;
	}

	/**
	 * OnRefresh.
	 * 
	 * @param mapping
	 *            the mapping
	 * @param form
	 *            the form
	 * @param request
	 *            the request
	 * @param response
	 *            the response
	 * @return the action forward
	 * @throws BusinessException
	 * @throws DataAccessException
	 * @throws IOException
	 * @throws Exception
	 *             the exception
	 */
	private ActionForward onRefresh(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws DataAccessException, BusinessException, IOException {
		System.out.println("#IGMLogger onRefresh() started..");
		ImportGeneralManifestUim objForm = (ImportGeneralManifestUim) form;
		System.out.println("#IGMLogger Form Data : " + objForm.toString());

		// objForm.setPodTerminal((String) serviceVesselVoyageObj.get("Terminal"));

		Map<String, String> mapParam = createHeaderParams(objForm);
		System.out.println("refresh ()>>>>>>>>>" + mapParam.toString());
		System.out.println("#IGMLogger Map mapParam for reload: " + mapParam);
		ImportGeneralManifestDao objDao1 = (ImportGeneralManifestDao) getDao(DAO_BEAN_ID);
		System.out.println("#IGMLogger Dao bean created successfully...");
		Map<Object, Object> mapReturn = objDao1.getRefreshIGMData(mapParam);
		System.out.println("#IGMLogger Proc executed successfully...");
		List<ImportGeneralManifestMod> result = (List<ImportGeneralManifestMod>) mapReturn
				.get(ImportGeneralManifestDao.KEY_REF_IGM_DATA);
		net.sf.json.JSONObject jsonObjREF = new net.sf.json.JSONObject();
		List<ImportGeneralManifestMod> uniqueRecords = getUniqueRecords(result);
		List<ImportGeneralManifestResultSet> finalResult = getFinalData(result, uniqueRecords);
		jsonObjREF = new net.sf.json.JSONObject();
		jsonObjREF.put("Refreshresult", finalResult);
		jsonObjREF.write(response.getWriter());
		System.out.println("#IGMLogger final JSON for unique obj For reload: " + jsonObjREF.write(new StringWriter()));
		return null;
	}

	/** return marks number to writeFile() */
	public static String getMarksNumber(String bl, JSONArray marksNumberDtlstls) {
		String markNumber = "";
		for (Object mrkObj : marksNumberDtlstls) {
			JSONObject mrkOb = (JSONObject) mrkObj;
			if (bl.equals(mrkOb.get("blNO"))) {
				markNumber = (String) mrkOb.get("marksNumbers");
			}
		}
		return markNumber;

	}

	/**
	 * specific the length
	 *
	 * @param date
	 *            the date
	 * @return the string
	 */
	public static String reqlength(String a, int l) {
		if (a.length() > l)
			return a.substring(0, l);
		else
			return a;
		
	}
	public static String settingLengthForDouble(String aField, int aintDigits,int aintDecimals){
        String val = aField+"";
        int dotIndex=val.indexOf('.');
        if(dotIndex > 0){
        	String cutDecimal = "";
            String fullValue = val.substring(0,dotIndex);  
            String decimalValue = val.substring(dotIndex+1);
            if(decimalValue.length()<3) {
            	cutDecimal = decimalValue.substring(0,decimalValue.length());
            }else {
            	cutDecimal = decimalValue.substring(0,aintDecimals);
            }
            aField = fullValue+"."+cutDecimal;
        }
    return aField;
}

	private ActionForward onEdiFileGenerateFile(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println("#IGMLogger onSaveFile() started............");
		String fileName = "ManifestFile.txt";
		response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
		org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();
		ImportGeneralManifestUim objForm = (ImportGeneralManifestUim) form;
		System.out.println("#IGMLogger onSaveFile() form data : " + objForm.toString());

		ImportGeneralManifestDao objDao = (ImportGeneralManifestDao) getDao(DAO_BEAN_ID);
		System.out.println("#IGMLogger onSave() Dao bean created successfully...");

		String tmpdir = System.getProperty("java.io.tmpdir");
		String path = tmpdir + File.separator + fileName;
		new File(path).delete();
		System.out.println("onSaveFile :" + path);
		JSONArray blList = (org.json.simple.JSONArray) parser.parse(objForm.getBLDetails());
		System.out.println(blList);
		JSONArray vesselVoyageList = (org.json.simple.JSONArray) parser.parse(objForm.getVesselVoyageDtls());
		JSONObject serviceVesselVoyageObj = (JSONObject) vesselVoyageList.get(0);
		JSONArray notifyPartyDetailes = (org.json.simple.JSONArray) parser.parse(objForm.getNotifyPartyDlts());
		JSONArray marksNumberDtlstls = (org.json.simple.JSONArray) parser.parse(objForm.getMarksNumberDtlstls());
		JSONArray containeerDtls = (org.json.simple.JSONArray) parser.parse(objForm.getContainerDetailsDtls());
		JSONArray consigneeDtls = (org.json.simple.JSONArray) parser.parse(objForm.getConsigneeDtls());
		File manifestFile = writeFileGenerateEdiFile(path, objForm, blList, serviceVesselVoyageObj, objDao,
				notifyPartyDetailes, marksNumberDtlstls, containeerDtls,consigneeDtls);
		try (ServletOutputStream out = response.getOutputStream();
				FileInputStream in = new FileInputStream(manifestFile);) {
			byte[] bufferData = new byte[1024];
			int read = 0;
			while ((read = in.read(bufferData)) != -1) {
				out.write(bufferData, 0, read);
			}
		}
		System.out.println("#IGMLogger onEdiFileGenerateFile() completed..");
		return null;
	}

	public static File writeFileGenerateEdiFile(String path, ImportGeneralManifestUim objForm, JSONArray blList,
			JSONObject serviceObj, ImportGeneralManifestDao objDao, JSONArray notifyPartyDetailes,
			JSONArray marksNumberDtlstls, JSONArray containeerDtls,JSONArray consigneeDtls) throws DataAccessException, BusinessException {
		String mesType = "F";

		// String sId = "RCLAIPL123";
		Map data = objDao.getSerialNumber(objForm.getSerialNumber());
		String sId = data.get("selno").toString();
		// String recID = "REC_ID";
		String SUB_LINE_NO = "0";
		String blank = null;
		String Item_Number = null;
		String igmNo = "";
		String igmDate = "";
		String currTime = new StringBuffer().append(LocalTime.now().getHour()).append(LocalTime.now().getMinute())
				.toString();
		System.out.println(currTime);
		String currDate = LocalDate.now().toString().replaceAll("-", "");
		System.out.println(currDate);
		// Required to add symbol after each field
		char fieldSepOp = (char) 29;
		// Required to add new line char after each line.
		String newLine = System.getProperty("line.separator");
		// Make use of new vessel and new voyage
		String voyage = isNull((String) serviceObj.get("Voyage"));
		String newVoyage = isNull((String) serviceObj.get("New Voyage"));
		String pol = isNull((String) serviceObj.get("Pol"));
		if (newVoyage != null && !newVoyage.trim().equals("")) {
			voyage = newVoyage;
		}
		String vessel = isNull((String) serviceObj.get("Vessel"));
		String newVessel = isNull((String) serviceObj.get("New Vessel"));
		// JSONObject marksNumberDtls = (JSONObject)marksNumberDtlstls;
		if (newVessel != null && !newVessel.trim().equals("")) {
			vessel = newVessel;
		}
		if(objForm.getMesstype().equals("A")) {
			 igmNo = isNull(reqlength(objForm.getIgmNo(), 7));
			 igmDate = removeSlash(isNull(objForm.getIgmDate()));
		}

		File manifestFile = new File(path);
		try (BufferedWriter bw = new BufferedWriter(new FileWriter(manifestFile));) {

			// Need some values if not found keep hard coding
			bw.write(String.join(Character.toString(fieldSepOp), "HREC", "ZZ", "RCLAIPL123", // isNull(sId),
					"ZZ", isNull(reqlength(objForm.getCustomCode(),6)), "ICES1_5", "P", isNull(blank), "SACHI01", isNull(sId), // isNull(objForm.getSerialNumber()),
					currDate, currTime + newLine));

			// hard code
			bw.write("<manifest>" + newLine);

			// hard code
			bw.write("<vesinfo>" + newLine);

			// Need some values if not found keep hard coding for each line.
			bw.write(String.join(Character.toString(fieldSepOp), mesType, isNull(reqlength(objForm.getCustomCode(),6)),
					igmNo,igmDate,
					isNull(reqlength(objForm.getImoCode(), 10)), isNull(reqlength(objForm.getCallSign(), 10)),
					isNull(reqlength(voyage, 10)),
					
					isNull(reqlength(objForm.getLineCode(), 10))
//					"RCA1" hard code value for line no 
					, isNull(reqlength(objForm.getAgentCode(), 16)),
					isNull(reqlength(objForm.getMasterName(), 30)), isNull(reqlength(objForm.getPortOfArrival(), 6)),
					isNull(reqlength(objForm.getPrt1(),6)), isNull(reqlength(objForm.getPrt2(),6)), isNull(reqlength(objForm.getPrt3(),6)),
					isNull(reqlength(objForm.getVesselTypes(), 1)), isNull(reqlength(objForm.getTotalItem(), 4)),
					"CONTAINERS", removeSlash(isNull(objForm.getAtaAd())) + " " + isNull(objForm.getaTime()),
					isNull(reqlength(objForm.getLighthouseDue(), 9)),
					isNull(reqlength(objForm.getSameBottomCargo(), 1)),
					isNull(reqlength(objForm.getShipStoreDeclaration(), 1)), "N",
					isNull(reqlength(objForm.getPassengerList(),1)), isNull(reqlength(objForm.getCrewEffect(),1)),
					isNull(reqlength(objForm.getMaritimeDeclaration(),1)),isNull(reqlength(objForm.getCustomCode(),10)),
					// newly added-------------------------------------------
					isNull(objForm.getDepartureManifestNumber()), isNull(objForm.getDepartureManifestDate()),
					isNull(objForm.getSubmitterType()), isNull(objForm.getSubmitterCode()),
					isNull(objForm.getAuthorizedRepresentativeCode()), isNull(objForm.getShippingLineBondNumber()),
					isNull(objForm.getModeofTransport()), isNull(objForm.getShipType()),
					isNull(objForm.getConveyanceReferenceNumber()),
					isNull(objForm.getTotalNoofTransportEquipmentManifested()), isNull(objForm.getCargoDescription()),
					isNull(reqlength(objForm.getBriefCargoDescription(),30)), isNull(objForm.getExpectedDate()),
					isNull(objForm.getTimeofDeparture()),
					isNull(objForm.getTotalnooftransportcontractsreportedonArrivalDeparture()),
					isNull(objForm.getMesstype()), isNull(objForm.getVesType()), isNull(objForm.getAuthoseaCarcode()),
					isNull(objForm.getPortoDreg()), isNull(objForm.getRegDate()), isNull(objForm.getVoyDetails()),
					isNull(objForm.getShipItiseq()), isNull(objForm.getShipItinerary()),
					isNull(objForm.getPortofCallname()), isNull(objForm.getArrivalDepdetails()),
					isNull(objForm.getTotalnoTransarrivdep()), isNull(objForm.getGeneratFalg()) + newLine));
			// hard code
			// hard code
			bw.write("<END-vesinfo>" + newLine);
			bw.write("<cargo>" + newLine);
			String containerStatus = "";
			for (Object blObjjson : blList) {
				JSONObject blObj = (JSONObject) blObjjson;
				String rc_Code = "";
				String tpBond = "";
				containerStatus = (String) blObj.get("Cargo Movement Type");

				if ("TI".equalsIgnoreCase((String) blObj.get("Cargo Movement"))) {
					rc_Code = isNull((String) serviceObj.get("Road Carr code"));
					tpBond = isNull((String) blObj.get("TP Bond No"));
				}
				String add = isNull(((String) blObj.get("Custom ADD1")) + ((String) blObj.get("Custom ADD2"))
						+ ((String) blObj.get("Custom ADD3")) + ((String) blObj.get("Custom ADD4")));
				String add1 = "";
				String add2 = "";
				String add3 = "";
				String nodifyAdd1 = "";
				String nodifyAdd2 = "";
				String nodifyAdd3 = "";
				String nodifyName = "";
				String consigneeAdd1 = "";
				String consigneeAdd2 = "";
				String consigneeAdd3 = "";
				String consigneeName = "";
				int l = add.length();
				System.out.println("length of address " + l);
				if (l > 35) {
					add1 = add.substring(0, 35);
					add = add.substring(35, l);
					if (add.length() > 35) {
						add2 = add.substring(0, 35);
						add = add.substring(35, add.length());
						if (add.length() > 35) {
							add3 = add.substring(0, 35);
						} else
							add3 = add;
					} else
						add2 = add;
					// System.out.println("length = " + add.length());

				} else
					add1 = add;
				// System.out.println("length = " + add.length());
				
				
				
				
				
				for (Object notifyObj : notifyPartyDetailes) {
					JSONObject notyObj = (JSONObject) notifyObj;
					if (((String) blObj.get("BL#")).equals(notyObj.get("blNO"))) {
						
						nodifyName = isNull(((String) notyObj.get("customerName")));
						
						String NodifyAdd = isNull(((String) notyObj.get("addressLine1"))
								+ ((String) notyObj.get("addressLine2")) + ((String) notyObj.get("addressLine3"))
								+ ((String) notyObj.get("addressLine4")));

						int len = NodifyAdd.length();
						System.out.println("length of Notify address " + len);
						if (len > 35) {
							nodifyAdd1 = NodifyAdd.substring(0, 35);
							NodifyAdd = NodifyAdd.substring(35, len);
							if (NodifyAdd.length() > 35) {
								nodifyAdd2 = NodifyAdd.substring(0, 35);
								NodifyAdd = NodifyAdd.substring(35, NodifyAdd.length());
								if (NodifyAdd.length() > 35) {
									nodifyAdd3 = NodifyAdd.substring(0, 35);
								} else
									nodifyAdd3 = NodifyAdd;
							} else
								nodifyAdd2 = NodifyAdd;
							// System.out.println("length = " + add.length());

							
						} else
							nodifyAdd1 = NodifyAdd;
						// System.out.println("length = " + add.length());

						break;
					}
				}
				
				for (Object consigneeObj : consigneeDtls) {
					JSONObject cnsgneeObj = (JSONObject) consigneeObj;
					if (((String) blObj.get("BL#")).equals(cnsgneeObj.get("blNO"))) {
						String consigneeAdd = isNull(((String) cnsgneeObj.get("addressLine1"))
								+ ((String) cnsgneeObj.get("addressLine2")) + ((String) cnsgneeObj.get("addressLine3"))
								+ ((String) cnsgneeObj.get("addressLine4")));
						 consigneeName = isNull(((String) cnsgneeObj.get("customerName")));
						

						int len = consigneeAdd.length();
						System.out.println("length of Notify address " + len);
						if (len > 35) {
							consigneeAdd1 = consigneeAdd.substring(0, 35);
							consigneeAdd = consigneeAdd.substring(35, len);
							if (consigneeAdd.length() > 35) {
								consigneeAdd2 = consigneeAdd.substring(0, 35);
								consigneeAdd = consigneeAdd.substring(35, consigneeAdd.length());
								if (consigneeAdd.length() > 35) {
									consigneeAdd3 = consigneeAdd.substring(0, 35);
								} else
									consigneeAdd3 = consigneeAdd;
							} else
								nodifyAdd2 = consigneeAdd;
							// System.out.println("length = " + add.length());

						} else
							nodifyAdd1 = consigneeAdd;
						// System.out.println("length = " + add.length());

						break;
					}
				}

				// Need some values if not found keep hard coding for each line
				bw.write(String.join(Character.toString(fieldSepOp), mesType,isNull(reqlength(objForm.getCustomCode(),6)),
						igmNo,igmDate,
						isNull(reqlength(objForm.getImoCode(), 10)), reqlength(objForm.getCallSign(), 10),
						reqlength(voyage, 10), 
						isNull(reqlength(objForm.getTotalItem(), 4)),
//						Item_Number = isNull((String) blObj.get("Item Number")), putting above line for line num 
						reqlength(SUB_LINE_NO,4),
						isNull(reqlength((String)blObj.get("BL#"),20)), isNull(removeSlash((String) blObj.get("BL_Date"))),
						isNull(reqlength(pol, 6)), isNull(reqlength((String)blObj.get("First Port of Entry/Last Port of Departure"),6)),
						isNull((String) blObj.get("HBL_NO")), isNull((String)blObj.get("HBL_Date")), isNull(consigneeName),
						isNull(consigneeAdd1), isNull(consigneeAdd2), isNull(consigneeAdd3), isNull(nodifyName), isNull(nodifyAdd1),
						isNull(nodifyAdd2), isNull(nodifyAdd2), isNull(reqlength((String)blObj.get("Cargo Nature"),2)),
						isNull(reqlength((String) blObj.get("Item Type"),2)), isNull(reqlength((String) blObj.get("Cargo Movement"),2)),
						isNull(reqlength((String) blObj.get("CFS-Custom Code"),10)), // "NUMBER_PACKAGES",
						isNull(reqlength((String) blObj.get("Number of Packages"),8)), isNull(reqlength((String) blObj.get("Type of Package"),3)),
						isNull(settingLengthForDouble(objForm.getGrossWeightVessel(),12,3)),isNull(reqlength((String) blObj.get("Unit of weight"),3)), isNull(settingLengthForDouble((String) blObj.get("Gross Volume"),12,3)),
						isNull(reqlength((String) blObj.get("Unit of Volume"),3)), 
						// "MARKS_NUMBER",
						isNull(reqlength(getMarksNumber((String) blObj.get("BL#"), marksNumberDtlstls), 300)),
						isNull(reqlength(objForm.getGeneralDescription(),250)), isNullUno(reqlength((String)blObj.get("UNO Code"),5)), // "UNO_CODE",
//						isNull(reqlength(objForm.getImoCode(), 3)), // Duplicate
						reqlength(tpBond, 10), reqlength(rc_Code, 10),
						isNull(reqlength((String)objForm.getModeofTransport(), 1)),
						isNull(reqlength(objForm.getAgentCode(), 16))
						
						/*
						 * // ----------------newly added
						 * 
						 * isNull((String) blObj.get("Previous Declaration")),
						 * 
						 * isNull((String) blObj.get("Consolidator PAN")),
						 * 
						 * isNull((String) blObj.get("CIN TYPE")),
						 * 
						 * isNull((String) blObj.get("MCIN")),
						 * 
						 * isNull((String) blObj.get("CSN Submitted Type")),
						 * 
						 * isNull((String) blObj.get("CSN Submitted by")),
						 * 
						 * isNull((String) blObj.get("CSN Reporting Type")),
						 * 
						 * isNull((String) blObj.get("CSN Site ID")),
						 * 
						 * isNull((String) blObj.get("CSN Number")),
						 * 
						 * isNull((String) blObj.get("CSN Date")),
						 * 
						 * isNull((String) blObj.get("Previous MCIN")),
						 * 
						 * isNull((String) blObj.get("Split Indicator")),
						 * 
						 * isNull((String) blObj.get("Number of Packages")),
						 * 
						 * isNull((String) blObj.get("Type of Package")),
						 * 
						 * isNull((String) blObj.get("First Port of Entry/Last Port of Departure")),
						 * 
						 * isNull((String) blObj.get("Type Of Cargo")),
						 * 
						 * isNull((String) blObj.get("Split Indicator List")),
						 * 
						 * isNull((String) blObj.get("Port of Acceptance")),
						 * 
						 * isNull((String) blObj.get("Port of Receipt")),
						 * 
						 * isNull((String) blObj.get("UCR Typel")),
						 * 
						 * isNull((String) blObj.get("UCR Code")),
						 * 
						 * isNull((String) blObj.get("Port of Acceptance Name")),
						 * 
						 * isNull((String) blObj.get("Port of Receipt Name")),
						 * 
						 * isNull((String) blObj.get("PAN of notified party")),
						 * 
						 * isNull((String) blObj.get("Unit of weight")),
						 * 
						 * isNull((String) blObj.get("Gross Volume")),
						 * 
						 * isNull((String) blObj.get("Unit of Volume")),
						 * 
						 * isNull((String) blObj.get("Cargo Item Sequence No")),
						 * 
						 * isNull((String) blObj.get("Cargo Item Description")),
						 * 
						 * isNull((String) blObj.get("UNO Code")),
						 * 
						 * isNull((String) blObj.get("IMDG Code")),
						 * 
						 * isNull((String) blObj.get("Number of Packages Hidden")),
						 * 
						 * isNull((String) blObj.get("Type of Packages Hidden")),
						 * 
						 * isNull((String) blObj.get("Container Weight")),
						 * 
						 * isNull((String) blObj.get("Port of call sequence numbe")),
						 * 
						 * isNull((String) blObj.get("Port of Call Coded")),
						 * 
						 * isNull((String) blObj.get("Next port of call coded")),
						 * 
						 * isNull((String) blObj.get("MC Location Customsl"))
						 */
						+newLine));

			}
			
			bw.write("<END-cargo>" + newLine);

			// Need some values if not found keep hard coding
			bw.write("<contain>" + newLine);
			
			String iso = null;
			for (Object containDtls : containeerDtls) {
				JSONObject coDtl = (JSONObject) containDtls;
				if( null == coDtl.get("containerSize") || coDtl.get("containerSize").equals(" ") ) {
					iso = " ";
				}else if(coDtl.get("containerSize").equals("40")) {
					if(coDtl.get("containerType").equals("HC")) {
						iso = "4200";
					}
					
				}else if(coDtl.get("containerSize").equals("20") ) {
					iso = "2000";
				}else {
					iso = "4000";
				}
				// Need some values if not found keep hard coding
				bw.write(String.join(Character.toString(fieldSepOp), mesType, isNull(reqlength(objForm.getCustomCode(),6)),
						isNull(reqlength(objForm.getImoCode(), 10)), reqlength(vessel, 10), reqlength(voyage, 10),
						igmNo,igmDate,
						// "Line_No",
						isNull(reqlength(objForm.getTotalItem(), 4)),
						// "SUB_LINE_NO",
						reqlength(SUB_LINE_NO,4), isNull(reqlength((String) coDtl.get("containerNumber"),11)),
						isNull(reqlength((String) coDtl.get("containerSealNumber"),15)),
						isNull(reqlength(objForm.getAgentCode(), 16)),
						// ---->"CONTAINER_STATUS"
						isNull(reqlength(containerStatus,3)), isNull(reqlength((String) coDtl.get("totalNumberOfPackagesInContainer"),8)),
						isNull(settingLengthForDouble((String) coDtl.get("containerWeight"),14,2)),
				
						reqlength(iso,4), "N"// "SOC_FLAG"
						
						+ newLine));
			}
			// hard code
			bw.write("<END-contain>" + newLine);
			// hard code
			bw.write("<END-manifest>" + newLine);
			// hard code need value of sequence char
			bw.write("TREC" + fieldSepOp + sId);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return manifestFile;
	}
}
