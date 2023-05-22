package com.rclgroup.dolphin.web.igm.vo;

import java.util.List;

public class MasterSEI {
	public List<DecRefSEI> decRef;
	public List<AuthPrsnSEI> authPrsn;
	public List<VesselDtlsSEI> vesselDtls;
	public List<ArvlDtlsSEI> arvlDtls;
	//public List<PrsnOnBoardSEI> prsnOnBoard;
	public List<ShipStoresSEI> shipStores;
	public List<DecRefSEI> getDecRef() {
		return decRef;
	}
	public void setDecRef(List<DecRefSEI> decRefList) {
		this.decRef = decRefList;
	}
	public List<AuthPrsnSEI> getAuthPrsn() {
		return authPrsn;
	}
	public void setAuthPrsn(List<AuthPrsnSEI> authPrsn) {
		this.authPrsn = authPrsn;
	}
	public List<VesselDtlsSEI> getVesselDtls() {
		return vesselDtls;
	}
	public void setVesselDtls(List<VesselDtlsSEI> vesselDtls) {
		this.vesselDtls = vesselDtls;
	}
	public List<ArvlDtlsSEI> getArvlDtls() {
		return arvlDtls;
	}
	public void setArvlDtls(List<ArvlDtlsSEI> arvlDtls) {
		this.arvlDtls = arvlDtls;
	}
	/*public List<PrsnOnBoardSEI> getPrsnOnBoard() {
		return prsnOnBoard;
	}
	public void setPrsnOnBoard(List<PrsnOnBoardSEI> prsnOnBoard) {
		this.prsnOnBoard = prsnOnBoard;
	}*/
	public List<ShipStoresSEI> getShipStores() {
		return shipStores;
	}
	public void setShipStores(List<ShipStoresSEI> shipStores) {
		this.shipStores = shipStores;
	}
	
	

	}
