package com.rclgroup.dolphin.web.igm.vo;

public class MCRef {
	public String lineNo;
	public String mstrBlNo;
	public String mstrBlDt ;
	public String consolidatedIndctr;
	public String prevDec;
	public String consolidatorPan;

//Same as Item Number from current screen "Item Number"
	public String getLineNo() {
		return lineNo;
	}

	public void setLineNo(String lineNo) {
		/*
		 * int i = Integer.parseInt(lineNo); if (1.0 < i || i < 9999999.0) { lineNo =
		 * Integer.toString(i); lineNo = FiledValidation.isNullAndSetlength(lineNo,
		 * 100); }
		 */
		this.lineNo = lineNo;
	}

   //Same as Item Number from current screen "BL#"
	public String getMstrBlNo() {
		return mstrBlNo;
	}

	public void setMstrBlNo(String mstrBlNo) {
		mstrBlNo = FiledValidation.isNullAndSetlength(mstrBlNo, 100);
		this.mstrBlNo = mstrBlNo;
	}

   //Same as Item Number from current screen "BL_Date"
	public String getMstrBlDt() {
		return mstrBlDt;
	}

	public void setMstrBlDt(String mstrBlDt) {
		if (mstrBlDt==null) {
			this.mstrBlDt = mstrBlDt;
		} else {
			if (mstrBlDt.contains("/")) {
				String dateArray[] = mstrBlDt.split("/");
				mstrBlDt = dateArray[2] + dateArray[1] + dateArray[0];
				this.mstrBlDt = mstrBlDt;
			}
		}
	}

   //Same as Item Number from current screen "Consolidated Indicator"
	public String getConsolidatedIndctr() {
		return consolidatedIndctr;
	}

	public void setConsolidatedIndctr(String consolidatedIndctr) {
		consolidatedIndctr = FiledValidation.isNullAndSetlength(consolidatedIndctr, 4);
		this.consolidatedIndctr = consolidatedIndctr;
	}
    //Same as Item Number from current screen "Previous Declaration"
	public String getPrevDec() {
		return prevDec;
	}

	public void setPrevDec(String prevDec) {
		prevDec = FiledValidation.isNullAndSetlength(prevDec, 4);
		this.prevDec = prevDec;
	}
    //Same as Item Number from current screen  "Consolidator PAN"
	public String getConsolidatorPan() {
		return consolidatorPan;
	}

	public void setConsolidatorPan(String consolidatorPan) {
		consolidatorPan = FiledValidation.isNullAndSetlength(consolidatorPan, 35);
		this.consolidatorPan = consolidatorPan;
	}
}