package com.rclgroup.dolphin.web.igm.vo;

public class DecRef {
	public String msgTyp;
	public String prtofRptng;
	public String jobNo;
	public String jobDt;
	public String rptngEvent;
	public String mnfstNoRotnNo;
	public String mnfstDtRotnDt;
	public String vesselTypMvmt;

	// #
	// public String dptrMnfstNo;
	// public String dptrMnfstDt;
	// #
	// This value is come from BL Json object "messtype"
	public String getMsgTyp() {
		return msgTyp;
	}

	public void setMsgTyp(String msgTyp) {
		msgTyp = FiledValidation.isNullAndSetlength(msgTyp, 1);
		this.msgTyp = msgTyp;
	}

	// This value is come from BL Json object "porTrept"
	public String getPrtofRptng() {
		return prtofRptng;
	}

	public void setPrtofRptng(String prtofRptng) {
		prtofRptng = FiledValidation.isNullAndSetlength(prtofRptng, 6);
		this.prtofRptng = prtofRptng;
	}

	// This value is come from BL Json object "jobNum"
	public String getJobNo() {
		return jobNo;
	}

	public void setJobNo(String jobNo) {
		jobNo = FiledValidation.isNullAndSetlength(jobNo, 7);
		this.jobNo = jobNo;
	}

	// This value is come from BL Json object "jobDate"
	public String getJobDt() {
		return jobDt;
	}

	public void setJobDt(String jobDt) {
		if (jobDt == null) {
			this.jobDt = jobDt;
		} else {
			if (jobDt.contains("/")) {
				String dateArray[] = jobDt.split("/");
				jobDt = dateArray[2] + dateArray[1] + dateArray[0];
				this.jobDt = jobDt;
			}
			this.jobDt = jobDt;
		}
	}

	// This value is come from BL Json object "reportEvent"
	public String getRptngEvent() {
		return rptngEvent;
	}

	public void setRptngEvent(String rptngEvent) {
		rptngEvent = FiledValidation.isNullAndSetlength(rptngEvent, 4);
		this.rptngEvent = rptngEvent;
	}

	// This value is come from BL Json object "mainNocsnno"
	public String getMnfstNoRotnNo() {
		return mnfstNoRotnNo;
	}

	public void setMnfstNoRotnNo(String mnfstNoRotnNo) {
		mnfstNoRotnNo = FiledValidation.isNullAndSetlength(mnfstNoRotnNo, 100);
		this.mnfstNoRotnNo = mnfstNoRotnNo;
	}

	// This value is come from BL Json object "manifestdateCsndate"
	public String getMnfstDtRotnDt() {
		return mnfstDtRotnDt;
	}

	public void setMnfstDtRotnDt(String mnfstDtRotnDt) {
		if (mnfstDtRotnDt == null) {
			System.out.println("this.mnfstDtRotnDt 2 = " + mnfstDtRotnDt);
			this.mnfstDtRotnDt = "";
		} else {
			if (mnfstDtRotnDt.contains("/")) {
				String dateArray[] = jobDt.split("/");
				mnfstDtRotnDt = dateArray[2] + dateArray[1] + dateArray[0];
				this.mnfstDtRotnDt = mnfstDtRotnDt;
			}
			this.mnfstDtRotnDt = mnfstDtRotnDt;
		}
	}

	// This value is come from BL Json object "vesType"
	public String getVesselTypMvmt() {
		return vesselTypMvmt;
	}

	public void setVesselTypMvmt(String vesselTypMvmt) {
		vesselTypMvmt = FiledValidation.isNullAndSetlength(vesselTypMvmt, 2);
		this.vesselTypMvmt = vesselTypMvmt;
	}

}