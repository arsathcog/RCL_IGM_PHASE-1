package com.rclgroup.dolphin.web.igm.vo;

public class Itnry {
	public String prtOfCallSeqNmbr;
	public String prtOfCallCdd;
	public String prtOfCallName;
	public String nxtPrtOfCallCdd;
	public String nxtPrtOfCallName;
	public String modeOfTrnsprt;


     //This value is come from BL Json object  "Port of call sequence numbe"
	public String getPrtOfCallSeqNmbr() {
		return prtOfCallSeqNmbr;
	}

	public void setPrtOfCallSeqNmbr(String prtOfCallSeqNmbr) {
		System.out.println("prtOfCallSeqNmbr 1"+prtOfCallSeqNmbr);
		prtOfCallSeqNmbr = FiledValidation.isNullAndSetlength(prtOfCallSeqNmbr, 100);
		System.out.println("prtOfCallSeqNmbr 1"+prtOfCallSeqNmbr);
		this.prtOfCallSeqNmbr = prtOfCallSeqNmbr;
	}

     //This value is come from BL Json object   "Port of Call Coded"
	public String getPrtOfCallCdd() {
		return prtOfCallCdd;
	}

	public void setPrtOfCallCdd(String prtOfCallCdd) {
		prtOfCallCdd = FiledValidation.isNullAndSetlength(prtOfCallCdd, 10);
		this.prtOfCallCdd = prtOfCallCdd;
	}
  //This value is come from BL Json object   "portofCallname"
	public String getPrtOfCallName() {
		return prtOfCallName;
	}

	public void setPrtOfCallName(String prtOfCallName) {
		prtOfCallName = FiledValidation.isNullAndSetlength(prtOfCallCdd, 10);
		this.prtOfCallName = prtOfCallName;
	}
 //This value is come from BL Json object   "Next port of call coded"
	public String getNxtPrtOfCallCdd() {
		return nxtPrtOfCallCdd;
	}

	public void setNxtPrtOfCallCdd(String nxtPrtOfCallCdd) {
		nxtPrtOfCallCdd = FiledValidation.isNullAndSetlength(nxtPrtOfCallCdd, 10);
		this.nxtPrtOfCallCdd = nxtPrtOfCallCdd;
	}

	//    This value is come from  "of Next Port of Call,Text"
	public String getNxtPrtOfCallName() {
		return nxtPrtOfCallName;
	}

	public void setNxtPrtOfCallName(String nxtPrtOfCallName) {
		nxtPrtOfCallName = FiledValidation.isNullAndSetlength(nxtPrtOfCallName, 256);
		this.nxtPrtOfCallName = nxtPrtOfCallName;
	}
//This value is come from BL Json object   "modeofTransport"
	public String getModeOfTrnsprt() {
		return modeOfTrnsprt;
	}

	public void setModeOfTrnsprt(String modeOfTrnsprt) {
		modeOfTrnsprt = FiledValidation.isNullAndSetlength(modeOfTrnsprt, 1);
		this.modeOfTrnsprt = modeOfTrnsprt;
	}
}