package com.rclgroup.dolphin.web.igm.vo;

public class HeaderFieldSEI {

	// header field and dummy values

   //Values come from "getSerialNumber()"
	public String senderID ;
	public String receiverID ;
	public String versionNo ;
	public String indicator ;
	public String messageID ;
	public String sequenceOrControlNumber ;
	public String date ;
	public String time ;
	public String reportingEvent ;

	public String getSenderID() {
		return senderID;
	}

	public void setSenderID(String senderID) {
		senderID = FiledValidation.isNullAndSetlength(senderID, 30);
		this.senderID = senderID;
	}

	public String getReceiverID() {
		return receiverID;
	}

	public void setReceiverID(String receiverID) {
		receiverID = FiledValidation.isNullAndSetlength(receiverID, 30);
		this.receiverID = receiverID;
	}

	public String getVersionNo() {
		return versionNo;
	}

	public void setVersionNo(String versionNo) {
		versionNo = FiledValidation.isNullAndSetlength(versionNo, 7);
		this.versionNo = versionNo;
	}

	public String getIndicator() {
		return indicator;
	}

	public void setIndicator(String indicator) {
		indicator = FiledValidation.isNullAndSetlength(indicator, 1);
		this.indicator = indicator;
	}

	public String getMessageID() {
		return messageID;
	}

	public void setMessageID(String messageID) {
		messageID = FiledValidation.isNullAndSetlength(messageID, 7);
		this.messageID = messageID;
	}

	public String getSequenceOrControlNumber() {
		return sequenceOrControlNumber;
	}

	public void setSequenceOrControlNumber(String sequenceOrControlNumber) {
		
		    sequenceOrControlNumber = FiledValidation.isNullAndSetlength(sequenceOrControlNumber, 8);
			this.sequenceOrControlNumber = sequenceOrControlNumber;
		
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		if ("".equals("date")) {
			this.date = date;
		} else {
			if (date.contains("/")) {
				String dateArray[] = date.split("/");
				date = dateArray[2] + dateArray[1] + dateArray[0];
				this.date = date;
			}
			this.date = date;
		}
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getReportingEvent() {
		return reportingEvent;
	}

	public void setReportingEvent(String reportingEvent) {
		reportingEvent = FiledValidation.isNullAndSetlength(reportingEvent, 4);
		this.reportingEvent = reportingEvent;
	}
}