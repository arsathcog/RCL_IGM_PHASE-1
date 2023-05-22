package com.rclgroup.dolphin.web.igm.vo;

import java.util.List;

public class JsonSEIObjct {
	public List<HeaderFieldSEI> headerField;
	public List<MasterSEI> master;
	//public List<DigSignSEI> digSign;
	
	public List<HeaderFieldSEI> getHeaderField() {
		return headerField;
	}
	public void setHeaderField(List<HeaderFieldSEI> headerField) {
		this.headerField = headerField;
	}
	public List<MasterSEI> getMaster() {
		return master;
	}
	public void setMaster(List<MasterSEI> master) {
		this.master = master;
	}
	/*public List<DigSignSEI> getDigSign() {
		return digSign;
	}
	public void setDigSign(List<DigSignSEI> digSign) {
		this.digSign = digSign;
	}*/

	
	
}