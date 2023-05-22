package com.rclgroup.dolphin.web.igm.vo;

import java.util.List;

public class PrsnOnBoardSEI {
	public String prsnOnBoardSeqNmbr;
	public List<CrewEfctSEI> crewEfct;
	public String getPrsnOnBoardSeqNmbr() {
		return prsnOnBoardSeqNmbr;
	}
	public void setPrsnOnBoardSeqNmbr(String prsnOnBoardSeqNmbr) {
		this.prsnOnBoardSeqNmbr = prsnOnBoardSeqNmbr;
	}
	public List<CrewEfctSEI> getCrewEfct() {
		return crewEfct;
	}
	public void setCrewEfct(List<CrewEfctSEI> crewEfct) {
		this.crewEfct = crewEfct;
	}
	

	

}
