/* -----------------------------------------------------------------------------
System  : RCL-EZLL
Module  : Discharge List
Prog ID : EDL002 - EdlDischargeListRestowedMod.java
Name    : Discharge List Maintenance
Purpose : VO of Restow List Detail for Discharge List Maintenance
--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author          Date            What
--------------- --------------- ------------------------------------------------
VIKAS VERMA   04/01/2011      <Initial version>
--Change Log--------------------------------------------------------------------
## DD/MM/YY –User- -Task/CR No- -Short Description-
----------------------------------------------------------------------------- */

package com.rclgroup.dolphin.web.igm.vo;

import com.niit.control.common.BaseVO;

/** 
 * VO for Restowed List Detail
 * @class EdlDischargeListRestowedMod
 * @author NTL) Vikas Verma
 * @version v1.00 2011/01/04
 * @see
 */ 
public class EllLoadListRestowedMod extends BaseVO{
    private String restowedId           = null;
    private String bookingNo            = null;
    private String equipmentNo          = null;
    private String size                 = null;
    private String equipmentType        = null;
    private String socCoc               = null;
    private String shipmentTerm         = null;
    private String shipmentType         = null;
    private String midstream            = null;
    private String loadCondition        = null;
    private String loadingStatus        = null;
    private String stowPosition         = null;
    private String activityDateTime     = null;
    private String weight               = null;     
    private String damaged              = null;    
    private String voidSlot             = null;
    private String slotOperator         = null;    
    private String contOperator         = null;    
    private String specialHandle        = null;
    private String sealNo               = null;    
    private String error                = null;
    private String restowSts            = null;
    private String remarks              = null;
    private String specialCargo         = null;
    private String recordChangeDt       = null;
    private String restowedSeqNo        = null;
    private String tempRecordStatus     = null;
    
    
    public void setBookingNo(String bookingNo) {
        this.bookingNo = bookingNo;
    }

    public String getBookingNo() {
        return bookingNo;
    }

    public void setEquipmentNo(String equipmentNo) {
        this.equipmentNo = equipmentNo;
    }

    public String getEquipmentNo() {
        return equipmentNo;
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

    public void setSocCoc(String socCoc) {
        this.socCoc = socCoc;
    }

    public String getSocCoc() {
        return socCoc;
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

    public void setMidstream(String midstream) {
        this.midstream = midstream;
    }

    public String getMidstream() {
        return midstream;
    }

    public void setLoadCondition(String loadCondition) {
        this.loadCondition = loadCondition;
    }

    public String getLoadCondition() {
        return loadCondition;
    }

    public void setLoadingStatus(String loadingStatus) {
        this.loadingStatus = loadingStatus;
    }

    public String getLoadingStatus() {
        return loadingStatus;
    }

    public void setStowPosition(String stowPosition) {
        this.stowPosition = stowPosition;
    }

    public String getStowPosition() {
        return stowPosition;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public String getWeight() {
        return weight;
    }

    public void setDamaged(String damaged) {
        this.damaged = damaged;
    }

    public String getDamaged() {
        return damaged;
    }

    public void setVoidSlot(String voidSlot) {
        this.voidSlot = voidSlot;
    }

    public String getVoidSlot() {
        return voidSlot;
    }

    public void setSlotOperator(String slotOperator) {
        this.slotOperator = slotOperator;
    }

    public String getSlotOperator() {
        return slotOperator;
    }

    public void setContOperator(String contOperator) {
        this.contOperator = contOperator;
    }

    public String getContOperator() {
        return contOperator;
    }


    public void setSealNo(String sealNo) {
        this.sealNo = sealNo;
    }

    public String getSealNo() {
        return sealNo;
    }


    public void setError(String error) {
     this.error = error;
    }


    public String getError() {
        return error;
    }

    public void setRestowSts(String restowSts) {
        this.restowSts = restowSts;
    }

    public String getRestowSts() {
        return restowSts;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setSpecialCargo(String specialCargo) {
        this.specialCargo = specialCargo;
    }

    public String getSpecialCargo() {
        return specialCargo;
    }

    public void setSpecialHandle(String specialHandle) {
        this.specialHandle = specialHandle;
    }

    public String getSpecialHandle() {
        return specialHandle;
    }

    public void setRestowedId(String restowedId) {
        this.restowedId = restowedId;
    }

    public String getRestowedId() {
        return restowedId;
    }

    public void setRecordChangeDt(String recordChangeDt) {
        this.recordChangeDt = recordChangeDt;
    }

    public String getRecordChangeDt() {
        return recordChangeDt;
    }

    public void setRestowedSeqNo(String restowedSeqNo) {
        this.restowedSeqNo = restowedSeqNo;
    }

    public String getRestowedSeqNo() {
        return restowedSeqNo;
    }

    public void setTempRecordStatus(String tempRecordStatus) {
        this.tempRecordStatus = tempRecordStatus;
    }

    public String getTempRecordStatus() {
        return tempRecordStatus;
    }

    public void setActivityDateTime(String activityDateTime) {
        this.activityDateTime = activityDateTime;
    }

    public String getActivityDateTime() {
        return activityDateTime;
    }
}
