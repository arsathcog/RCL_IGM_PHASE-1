package com.rclgroup.dolphin.web.igm.vo;

import java.util.List;

public class PrsnOnBoard {
	public String prsnOnBoardSeqNmbr;
	public List<PrsnDtls> prsnDtls;
	public List<PrsnId> prsnId;

	public List<PrsnDtls> getPrsnDtls() {
		return prsnDtls;
	}

	public void setPrsnDtls(List<PrsnDtls> prsnDtls) {
		this.prsnDtls = prsnDtls;
	}

	public List<PrsnId> getPrsnId() {
		return prsnId;
	}

	public void setPrsnId(List<PrsnId> prsnId) {
		this.prsnId = prsnId;
	}

	public String getPrsnOnBoardSeqNmbr() {
		return prsnOnBoardSeqNmbr;
	}

	public void setPrsnOnBoardSeqNmbr(String prsnOnBoardSeqNmbr) {
		this.prsnOnBoardSeqNmbr = prsnOnBoardSeqNmbr;
	}

}
