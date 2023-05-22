package com.rclgroup.dolphin.web.igm.vo;

import java.util.List;

public class Master {
	public List<DecRef> decRef;
	public List<AuthPrsn> authPrsn;
	public List<VesselDtls> vesselDtls;
	public List<VoyageDtls> voyageDtls;
	public List<MastrCnsgmtDec> mastrCnsgmtDec;
//	public List<PrsnOnBoard> prsnOnBoard;
	public List<VoyageTransportEquipment> voyageTransportEquipment;

	public List<DecRef> getDecRef() {
		return decRef;
	}

	public void setDecRef(List<DecRef> decRef) {
		this.decRef = decRef;
	}

	public List<AuthPrsn> getAuthPrsn() {
		return authPrsn;
	}

	public void setAuthPrsn(List<AuthPrsn> authPrsn) {
		this.authPrsn = authPrsn;
	}

	public List<VesselDtls> getVesselDtls() {
		return vesselDtls;
	}

	public void setVesselDtls(List<VesselDtls> vesselDtls) {
		this.vesselDtls = vesselDtls;
	}

	public List<VoyageDtls> getVoyageDtls() {
		return voyageDtls;
	}

	public void setVoyageDtls(List<VoyageDtls> voyageDtls) {
		this.voyageDtls = voyageDtls;
	}

	public List<MastrCnsgmtDec> getMastrCnsgmtDec() {
		return mastrCnsgmtDec;
	}

	public void setMastrCnsgmtDec(List<MastrCnsgmtDec> mastrCnsgmtDec) {
		this.mastrCnsgmtDec = mastrCnsgmtDec;
	}

	/*public List<PrsnOnBoard> getPrsnOnBoard() {
		return prsnOnBoard;
	}

	public void setPrsnOnBoard(List<PrsnOnBoard> prsnOnBoard) {
		this.prsnOnBoard = prsnOnBoard;
	}*/

	public List<VoyageTransportEquipment> getVoyageTransportEquipment() {
		return voyageTransportEquipment;
	}

	public void setVoyageTransportEquipment(List<VoyageTransportEquipment> voyageTransportEquipment) {
		this.voyageTransportEquipment = voyageTransportEquipment;
	}
}
