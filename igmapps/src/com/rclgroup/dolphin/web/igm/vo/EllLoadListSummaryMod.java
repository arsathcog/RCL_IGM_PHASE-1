/* -----------------------------------------------------------------------------
System  : RCL-EZLL
Module  : Discharge List
Prog ID : EDL002 - EdlDischargeListSummaryMod.java
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
 * @class EdlDischargeListSummaryMod
 * @author NTL) Vikas Verma
 * @version v1.00 2011/01/24
 * @see
 */ 
public class EllLoadListSummaryMod extends BaseVO{
    private String seqNo        = null;
    private String slotOperator = null;
    private String contOperator = null;
    private String activity     = null;
    private String size         = null;
    private String fullMT       = null;
    private String noOfContainer= null;
    private String noOfTEU      = null;
    private String subTotal     = null;
    private String boldFlg = null;
    
    public void setSeqNo(String seqNo) {
        this.seqNo = seqNo;
    }

    public String getSeqNo() {
        return seqNo;
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

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public String getActivity() {
        return activity;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getSize() {
        return size;
    }

    public void setFullMT(String fullMT) {
        this.fullMT = fullMT;
    }

    public String getFullMT() {
        return fullMT;
    }

    public void setNoOfContainer(String noOfContainer) {
        this.noOfContainer = noOfContainer;
    }

    public String getNoOfContainer() {
        return noOfContainer;
    }

    public void setNoOfTEU(String noOfTEU) {
        this.noOfTEU = noOfTEU;
    }

    public String getNoOfTEU() {
        return noOfTEU;
    }

    public void setSubTotal(String subTotal) {
        this.subTotal = subTotal;
    }

    public String getSubTotal() {
        return subTotal;
    }
    
    public void setBoldFlg(String boldFlg) {
        this.boldFlg = boldFlg;
    }

    public String getBoldFlg() {
        return boldFlg;
    }    
}
