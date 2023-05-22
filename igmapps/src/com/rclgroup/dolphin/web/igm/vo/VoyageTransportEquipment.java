package com.rclgroup.dolphin.web.igm.vo;

public class VoyageTransportEquipment {
	public String quipmentSequenceNo;
	public String quipmentId;
	public String quipmentType;
	//public String quipmentSize;
	public String quipmentLoadStatus;
	//public String additionalEquipmentHold;

	// # new sch              All Optional field r comment
	// public String finalDestinationLocation;
	// #
	//public String quipmentSealType;
	//public String quipmentSealNumber;
	//public String otherEquipmentId;

	// # new sch
	// public String equipmentStatus;
	// #

	public String socFlag;
	//public String containerAgentCode;
	//public String containerWeight;
	//public String totalNumberOfPackages;

	// # new sch
	// public String stowagePositionOfContainer;
	// #

	// (Already in IGM screen in container section. Use same seq
	// fromthere.)>mandatory
	public String getQuipmentSequenceNo() {
		return quipmentSequenceNo;
	}

	public void setQuipmentSequenceNo(String quipmentSequenceNo) {
		this.quipmentSequenceNo = quipmentSequenceNo;
	}

	// (Already in IGM screen in container section. Container no) >mandatory
	public String getQuipmentId() {
		return quipmentId;
	}

	public void setQuipmentId(String quipmentId) {
		this.quipmentId = quipmentId;
	}

	// (Use value as CN) >mandatory
	public String getQuipmentType() {
		return quipmentType;
	}

	public void setQuipmentType(String quipmentType) {
		this.quipmentType = quipmentType;
	}

	// (Same as IGM screen) >optional
	/*public String getQuipmentSize() {
		return quipmentSize;
	}

	public void setQuipmentSize(String quipmentSize) {
		this.quipmentSize = quipmentSize;
	}*/

	// (LOV : FCL, LCL, EMP) >mandatory
	public String getQuipmentLoadStatus() {
		return quipmentLoadStatus;
	}

	public void setQuipmentLoadStatus(String quipmentLoadStatus) {
		this.quipmentLoadStatus = quipmentLoadStatus;
	}

	// (The Identifier for Additional Equipment used for Hold )
	/*public String getAdditionalEquipmentHold() {
		return additionalEquipmentHold;
	}

	public void setAdditionalEquipmentHold(String additionalEquipmentHold) {
		this.additionalEquipmentHold = additionalEquipmentHold;
	}

	// value come from BL "Equipment seal type"(LOV : ESEAL/ BTSL Add New column in
	// equipment: default value BTSL. User will manually select. )
	public String getQuipmentSealType() {
		return quipmentSealType;
	}

	public void setQuipmentSealType(String quipmentSealType) {
		this.quipmentSealType = quipmentSealType;
	}

	// value come from BL "Equipment Seal Number" (Same as IGM screen. Always
	// Carrier Seal)
	public String getQuipmentSealNumber() {
		return quipmentSealNumber;
	}

	public void setQuipmentSealNumber(String quipmentSealNumber) {
		this.quipmentSealNumber = quipmentSealNumber;
	}

	// (The Identifier of Other Additional Equipment used for Carriage)
	public String getOtherEquipmentId() {
		return otherEquipmentId;
	}

	public void setOtherEquipmentId(String otherEquipmentId) {
		this.otherEquipmentId = otherEquipmentId;
	}
*/
	// value come from BL from "SOC Flagrl" (LOV : Y, N default value will be N) >
	// mandatory
	public String getSocFlag() {
		return socFlag;
	}

	public void setSocFlag(String socFlag) {
		this.socFlag = socFlag;
	}

	// value come from BL from (containerDetailsDtls) "containerAgentCode"
	// (Mandatory incase of EQU_TYPE : CN The PAN number registered with Customs for
	// Bond given for Re-export of Box Same as agent code of vessel/voyage section.
	// Exist in Container Agent Code)
	/*public String getContainerAgentCode() {
		return containerAgentCode;
	}

	public void setContainerAgentCode(String containerAgentCode) {
		this.containerAgentCode = containerAgentCode;
	}

	// value come from BL from (containerDetailsDtls) ""containerWeight" (Take VGM
	// value from EZDL.)
	public String getContainerWeight() {
		return containerWeight;
	}

	public void setContainerWeight(String containerWeight) {
		this.containerWeight = containerWeight;
	}

	// value come from BL from (containerDetailsDtls)
	// "totalNumberOfPackagesInContainer" (Same as container section)
	public String getTotalNumberOfPackages() {
		return totalNumberOfPackages;
	}

	public void setTotalNumberOfPackages(String totalNumberOfPackages) {
		this.totalNumberOfPackages = totalNumberOfPackages;
	}*/
}
