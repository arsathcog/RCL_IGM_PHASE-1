 /* -----------------------------------------------------------------------------
 System  : RCL-EZLL
 Module  : Load List
 Prog ID : ELL002 - EllLoadListOvershippedMod.java
 Name    : Load List Maintenance
 Purpose : VO of Overshipped List Detail for Load List Maintenance
 --------------------------------------------------------------------------------
 History : None
 --------------------------------------------------------------------------------
 Author          Date            What
 --------------- --------------- ------------------------------------------------
 Anshul Mahajan   25/02/2011      <Initial version>
 --Change Log--------------------------------------------------------------------
 ## DD/MM/YY –User- -Task/CR No- -Short Description-
 01 18/08/16    PONAPR1     #01     Add VGM
 ----------------------------------------------------------------------------- */

package com.rclgroup.dolphin.web.igm.vo;

import com.niit.control.common.BaseVO;

/** 
 * VO for Overshipped List Detail
 * @class EllLoadListOvershippedMod
 * @author NTL) Anshul Mahajan
 * @version v1.00 2011/02/25
 * @see
 */ 
public class EllLoadListOvershippedMod extends BaseVO{
    private String overshippedSeqNo     = null;
    private String overshippedContainerId = null;
    private String bookingNo            = null;
    private String equipmentNo          = null;
    private String billNo               = null;
    private String size                 = null;
    private String equipmentType        = null;
    private String fullMT               = null;
    private String bookingType          = null;
    private String socCoc               = null;
    private String shipmentTerm         = null;
    private String shipmentType         = null;
    private String polStatus            = null;
    private String localContSts         = null;
    private String midstream            = null;
    private String loadCondition        = null;
    private String loadingStatus        = null;
    private String stowPosition         = null;
    private String activityDate         = null;    
    private String weight               = null;     
    private String vgm                  = null;     //#01
    private String damaged              = null;    
    private String voidSlot             = null;
    private String slotOperator         = null;    
    private String contOperator         = null;    
    private String outSlotOperator      = null;
    private String specialHandling      = null;
    private String sealNo               = null;    
    private String pod                  = null;
    private String podTerminal          = null;
    private String nextPOD1             = null;
    private String nextPOD2             = null;
    private String nextPOD3             = null;
    private String finalPOD             = null;
    private String finalDest            = null;
    private String nextService          = null;
    private String nextVessel           = null;
    private String nextVoyage           = null;
    private String nextDirection        = null;
    private String connectingMLOVessel  = null;
    private String connectingMLOVoyage  = null;    
    private String mloETADate           = null;    
    private String connectingMLOPOD1    = null;
    private String connectingMLOPOD2    = null;
    private String connectingMLOPOD3    = null; 
    private String placeOfDel           = null;
    private String handlingInstCode1    = null;
    private String handlingInstDesc1    = null;
    private String handlingInstCode2    = null;
    private String handlingInstDesc2    = null;
    private String handlingInstCode3    = null;
    private String handlingInstDesc3    = null;
    private String contLoadRemark1      = null;
    private String contLoadRemark2      = null;
    private String specialCargo         = null;
    private String imdgClass            = null;
    private String unNumber             = null;
    private String unNumberVariant      = null;
    private String portClass            = null;
    private String portClassType        = null;
    private String flashUnit            = null;
    private String flashPoint           = null;
    private String fumigationOnly       = null;
    private String residue              = null;
    private String overheight           = null;
    private String overwidthLeft        = null;
    private String overwidthRight       = null;
    private String overlengthFront      = null;
    private String overlengthAfter      = null;
    private String reeferTemp           = null;
    private String reeferTempUnit       = null;
    private String humidity             = null;  
    private String ventilation          = null;   
    private String mergeAction          = null;   
    private String error                = null;
    private String recordChangeDt       = null;
    private String tempRecordStatus     = null;
    private String bookingNoSource      = null;
    private String preAdvice            = null;
    private String exMLOVessel          = null;
    private String exMLOVoyage          = null;
    private String exMloETADate         = null;
    
    public void setEquipmentNo(String equipmentNo) {
        this.equipmentNo = equipmentNo;
    }

    public String getEquipmentNo() {
        return equipmentNo;
    }

    public void setBookingNo(String bookingNo) {
        this.bookingNo = bookingNo;
    }

    public String getBookingNo() {
        return bookingNo;
    }

    public void setLocalContSts(String localContSts) {
        this.localContSts = localContSts;
    }

    public String getLocalContSts() {
        return localContSts;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getSize() {
        return size;
    }

    public void setEquipmentType(String equipmentType) {
        this.equipmentType = equipmentType;
    }

    public String getEquipmentType() {
        return equipmentType;
    }

    public void setActivityDate(String activityDate) {
        this.activityDate = activityDate;
    }

    public String getActivityDate() {
        return activityDate;
    }

    public void setBillNo(String billNo) {
        this.billNo = billNo;
    }

    public String getBillNo() {
        return billNo;
    }

    public void setBookingType(String bookingType) {
        this.bookingType = bookingType;
    }

    public String getBookingType() {
        return bookingType;
    }

    public void setContLoadRemark1(String contLoadRemark1) {
        this.contLoadRemark1 = contLoadRemark1;
    }

    public String getContLoadRemark1() {
        return contLoadRemark1;
    }

    public void setContLoadRemark2(String contLoadRemark2) {
        this.contLoadRemark2 = contLoadRemark2;
    }

    public String getContLoadRemark2() {
        return contLoadRemark2;
    }

    public void setPlaceOfDel(String placeOfDel) {
        this.placeOfDel = placeOfDel;
    }

    public String getPlaceOfDel() {
        return placeOfDel;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

//Start #01
    public String getVgm() {
        return vgm;
    }
    
    public void setVgm(String vgm) {
        this.vgm = vgm;
    }
//End #01

    public String getWeight() {
        return weight;
    }

    public void setContOperator(String contOperator) {
        this.contOperator = contOperator;
    }

    public String getContOperator() {
        return contOperator;
    }

    public void setDamaged(String damaged) {
        this.damaged = damaged;
    }

    public String getDamaged() {
        return damaged;
    }

    public void setFinalDest(String finalDest) {
        this.finalDest = finalDest;
    }

    public String getFinalDest() {
        return finalDest;
    }

    public void setFlashUnit(String flashUnit) {
        this.flashUnit = flashUnit;
    }

    public String getFlashUnit() {
        return flashUnit;
    }

    public void setFlashPoint(String flashPoint) {
        this.flashPoint = flashPoint;
    }

    public String getFlashPoint() {
        return flashPoint;
    }

    public void setFullMT(String fullMT) {
        this.fullMT = fullMT;
    }

    public String getFullMT() {
        return fullMT;
    }

    public void setFumigationOnly(String fumigationOnly) {
        this.fumigationOnly = fumigationOnly;
    }

    public String getFumigationOnly() {
        return fumigationOnly;
    }

    public void setHandlingInstCode1(String handlingInstCode1) {
        this.handlingInstCode1 = handlingInstCode1;
    }

    public String getHandlingInstCode1() {
        return handlingInstCode1;
    }

    public void setHandlingInstDesc1(String handlingInstDesc1) {
        this.handlingInstDesc1 = handlingInstDesc1;
    }

    public String getHandlingInstDesc1() {
        return handlingInstDesc1;
    }

    public void setHandlingInstCode2(String handlingInstCode2) {
        this.handlingInstCode2 = handlingInstCode2;
    }

    public String getHandlingInstCode2() {
        return handlingInstCode2;
    }

    public void setHandlingInstDesc2(String handlingInstDesc2) {
        this.handlingInstDesc2 = handlingInstDesc2;
    }

    public String getHandlingInstDesc2() {
        return handlingInstDesc2;
    }

    public void setHandlingInstCode3(String handlingInstCode3) {
        this.handlingInstCode3 = handlingInstCode3;
    }

    public String getHandlingInstCode3() {
        return handlingInstCode3;
    }

    public void setHandlingInstDesc3(String handlingInstDesc3) {
        this.handlingInstDesc3 = handlingInstDesc3;
    }

    public String getHandlingInstDesc3() {
        return handlingInstDesc3;
    }

    public void setImdgClass(String imdgClass) {
        this.imdgClass = imdgClass;
    }

    public String getImdgClass() {
        return imdgClass;
    }

    public void setLoadCondition(String loadCondition) {
        this.loadCondition = loadCondition;
    }

    public String getLoadCondition() {
        return loadCondition;
    }

    public void setMidstream(String midstream) {
        this.midstream = midstream;
    }

    public String getMidstream() {
        return midstream;
    }

    public void setMloETADate(String mloETADate) {
        this.mloETADate = mloETADate;
    }

    public String getMloETADate() {
        return mloETADate;
    }

    public void setConnectingMLOPOD1(String connectingMLOPOD1) {
        this.connectingMLOPOD1 = connectingMLOPOD1;
    }

    public String getConnectingMLOPOD1() {
        return connectingMLOPOD1;
    }

    public void setConnectingMLOPOD2(String connectingMLOPOD2) {
        this.connectingMLOPOD2 = connectingMLOPOD2;
    }

    public String getConnectingMLOPOD2() {
        return connectingMLOPOD2;
    }

    public void setConnectingMLOPOD3(String connectingMLOPOD3) {
        this.connectingMLOPOD3 = connectingMLOPOD3;
    }

    public String getConnectingMLOPOD3() {
        return connectingMLOPOD3;
    }

    public void setConnectingMLOVessel(String connectingMLOVessel) {
        this.connectingMLOVessel = connectingMLOVessel;
    }

    public String getConnectingMLOVessel() {
        return connectingMLOVessel;
    }

    public void setConnectingMLOVoyage(String connectingMLOVoyage) {
        this.connectingMLOVoyage = connectingMLOVoyage;
    }

    public String getConnectingMLOVoyage() {
        return connectingMLOVoyage;
    }

    public void setNextPOD1(String nextPOD1) {
        this.nextPOD1 = nextPOD1;
    }

    public String getNextPOD1() {
        return nextPOD1;
    }

    public void setNextPOD2(String nextPOD2) {
        this.nextPOD2 = nextPOD2;
    }

    public String getNextPOD2() {
        return nextPOD2;
    }

    public void setNextPOD3(String nextPOD3) {
        this.nextPOD3 = nextPOD3;
    }

    public String getNextPOD3() {
        return nextPOD3;
    }

    public void setNextDirection(String nextDirection) {
        this.nextDirection = nextDirection;
    }

    public String getNextDirection() {
        return nextDirection;
    }

    public void setNextService(String nextService) {
        this.nextService = nextService;
    }

    public String getNextService() {
        return nextService;
    }

    public void setNextVessel(String nextVessel) {
        this.nextVessel = nextVessel;
    }

    public String getNextVessel() {
        return nextVessel;
    }

    public void setNextVoyage(String nextVoyage) {
        this.nextVoyage = nextVoyage;
    }

    public String getNextVoyage() {
        return nextVoyage;
    }

    public void setOverheight(String overheight) {
        this.overheight = overheight;
    }

    public String getOverheight() {
        return overheight;
    }

    public void setOverlengthAfter(String overlengthAfter) {
        this.overlengthAfter = overlengthAfter;
    }

    public String getOverlengthAfter() {
        return overlengthAfter;
    }

    public void setOverlengthFront(String overlengthFront) {
        this.overlengthFront = overlengthFront;
    }

    public String getOverlengthFront() {
        return overlengthFront;
    }

    public void setOutSlotOperator(String outSlotOperator) {
        this.outSlotOperator = outSlotOperator;
    }

    public String getOutSlotOperator() {
        return outSlotOperator;
    }

    public void setOverwidthLeft(String overwidthLeft) {
        this.overwidthLeft = overwidthLeft;
    }

    public String getOverwidthLeft() {
        return overwidthLeft;
    }

    public void setOverwidthRight(String overwidthRight) {
        this.overwidthRight = overwidthRight;
    }

    public String getOverwidthRight() {
        return overwidthRight;
    }

    public void setPortClass(String portClass) {
        this.portClass = portClass;
    }

    public String getPortClass() {
        return portClass;
    }

    public void setPortClassType(String portClassType) {
        this.portClassType = portClassType;
    }

    public String getPortClassType() {
        return portClassType;
    }

    public void setReeferTemp(String reeferTemp) {
        this.reeferTemp = reeferTemp;
    }

    public String getReeferTemp() {
        return reeferTemp;
    }

    public void setReeferTempUnit(String reeferTempUnit) {
        this.reeferTempUnit = reeferTempUnit;
    }

    public String getReeferTempUnit() {
        return reeferTempUnit;
    }

    public void setResidue(String residue) {
        this.residue = residue;
    }

    public String getResidue() {
        return residue;
    }

    public void setSealNo(String sealNo) {
        this.sealNo = sealNo;
    }

    public String getSealNo() {
        return sealNo;
    }

    public void setShipmentTerm(String shipmentTerm) {
        this.shipmentTerm = shipmentTerm;
    }

    public String getShipmentTerm() {
        return shipmentTerm;
    }

    public void setShipmentType(String shipmentType) {
        this.shipmentType = shipmentType;
    }

    public String getShipmentType() {
        return shipmentType;
    }

    public void setSlotOperator(String slotOperator) {
        this.slotOperator = slotOperator;
    }

    public String getSlotOperator() {
        return slotOperator;
    }

    public void setSocCoc(String socCoc) {
        this.socCoc = socCoc;
    }

    public String getSocCoc() {
        return socCoc;
    }

    public void setSpecialCargo(String specialCargo) {
        this.specialCargo = specialCargo;
    }

    public String getSpecialCargo() {
        return specialCargo;
    }

    public void setSpecialHandling(String specialHandling) {
        this.specialHandling = specialHandling;
    }

    public String getSpecialHandling() {
        return specialHandling;
    }

    public void setStowPosition(String stowPosition) {
        this.stowPosition = stowPosition;
    }

    public String getStowPosition() {
        return stowPosition;
    }

    public void setUnNumberVariant(String unNumberVariant) {
        this.unNumberVariant = unNumberVariant;
    }

    public String getUnNumberVariant() {
        return unNumberVariant;
    }

    public void setUnNumber(String unNumber) {
        this.unNumber = unNumber;
    }

    public String getUnNumber() {
        return unNumber;
    }

    public void setVoidSlot(String voidSlot) {
        this.voidSlot = voidSlot;
    }

    public String getVoidSlot() {
        return voidSlot;
    }

    public void setHumidity(String humidity) {
        this.humidity = humidity;
    }

    public String getHumidity() {
        return humidity;
    }

    public void setVentilation(String ventilation) {
        this.ventilation = ventilation;
    }

    public String getVentilation() {
        return ventilation;
    }

    public void setFinalPOD(String finalPOD) {
        this.finalPOD = finalPOD;
    }

    public String getFinalPOD() {
        return finalPOD;
    }

    public void setMergeAction(String mergeAction) {
        this.mergeAction = mergeAction;
    }

    public String getMergeAction() {
        return mergeAction;
    }

    public void setError(String error) {
        this.error = error;
    }

    public String getError() {
        return error;
    }

    public void setOvershippedContainerId(String overshippedContainerId) {
        this.overshippedContainerId = overshippedContainerId;
    }

    public String getOvershippedContainerId() {
        return overshippedContainerId;
    }

    public void setRecordChangeDt(String recordChangeDt) {
        this.recordChangeDt = recordChangeDt;
    }

    public String getRecordChangeDt() {
        return recordChangeDt;
    }

    public void setOvershippedSeqNo(String overshippedSeqNo) {
        this.overshippedSeqNo = overshippedSeqNo;
    }

    public String getOvershippedSeqNo() {
        return overshippedSeqNo;
    }

    public void setTempRecordStatus(String tempRecordStatus) {
        this.tempRecordStatus = tempRecordStatus;
    }

    public String getTempRecordStatus() {
        return tempRecordStatus;
    }

    public void setLoadingStatus(String loadingStatus) {
        this.loadingStatus = loadingStatus;
    }

    public String getLoadingStatus() {
        return loadingStatus;
    }

    public void setPolStatus(String polStatus) {
        this.polStatus = polStatus;
    }

    public String getPolStatus() {
        return polStatus;
    }

    public void setPod(String pod) {
        this.pod = pod;
    }

    public String getPod() {
        return pod;
    }

    public void setPodTerminal(String podTerminal) {
        this.podTerminal = podTerminal;
    }

    public String getPodTerminal() {
        return podTerminal;
    }

    public void setBookingNoSource(String bookingNoSource) {
        this.bookingNoSource = bookingNoSource;
    }

    public String getBookingNoSource() {
        return bookingNoSource;
    }

    public void setPreAdvice(String preAdvice) {
        this.preAdvice = preAdvice;
    }

    public String getPreAdvice() {
        return preAdvice;
    }

    public void setExMLOVessel(String exMLOVessel) {
        this.exMLOVessel = exMLOVessel;
    }

    public String getExMLOVessel() {
        return exMLOVessel;
    }

    public void setExMLOVoyage(String exMLOVoyage) {
        this.exMLOVoyage = exMLOVoyage;
    }

    public String getExMLOVoyage() {
        return exMLOVoyage;
    }

    public void setExMloETADate(String exMloETADate) {
        this.exMloETADate = exMloETADate;
    }

    public String getExMloETADate() {
        return exMloETADate;
    }
}
