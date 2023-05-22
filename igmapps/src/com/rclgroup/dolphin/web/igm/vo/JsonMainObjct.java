package com.rclgroup.dolphin.web.igm.vo;

import java.util.List;

public class JsonMainObjct {
	public List<HeaderField> headerField;
	public List<Master> master;
//	public List<DigSign> digSign;

	public List<HeaderField> getHeaderField() {
		return headerField;
	}

	public void setHeaderField(List<HeaderField> headerField) {
		this.headerField = headerField;
	}

	public List<Master> getMaster() {
		return master;
	}

	public void setMaster(List<Master> master) {
		this.master = master;
	}

	/*public List<DigSign> getDigSign() {
		return digSign;
	}

	public void setDigSign(List<DigSign> digSign) {
		this.digSign = digSign;
	}*/
}