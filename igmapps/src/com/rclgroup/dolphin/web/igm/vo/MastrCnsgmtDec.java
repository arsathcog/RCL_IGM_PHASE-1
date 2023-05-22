package com.rclgroup.dolphin.web.igm.vo;

import java.util.List;

public class MastrCnsgmtDec {
	public List<MCRef> mCRef;
	public List<LocCstm> locCstm;

       //# scma
       // public List<Trnshpr> trnshpr;
        //#
	public List<TrnsprtDoc> trnsprtDoc;
        public List<TrnsprtDocMsr> trnsprtDocMsr;
	public List<ItemDtls> itemDtls;
	public List<TrnsprtEqmt> trnsprtEqmt;
	public List<Itnry> itnry;

	public List<MCRef> getmCRef() {
		return mCRef;
	}

	public void setmCRef(List<MCRef> mCRef) {
		this.mCRef = mCRef;
	}

	public List<LocCstm> getLocCstm() {
		return locCstm;
	}

	public void setLocCstm(List<LocCstm> locCstm) {
		this.locCstm = locCstm;
	}

	public List<TrnsprtDoc> getTrnsprtDoc() {
		return trnsprtDoc;
	}

	public void setTrnsprtDoc(List<TrnsprtDoc> trnsprtDoc) {
		this.trnsprtDoc = trnsprtDoc;
	}

	public List<TrnsprtDocMsr> getTrnsprtDocMsr() {
		return trnsprtDocMsr;
	}

	public void setTrnsprtDocMsr(List<TrnsprtDocMsr> trnsprtDocMsr) {
		this.trnsprtDocMsr = trnsprtDocMsr;
	}

	public List<ItemDtls> getItemDtls() {
		return itemDtls;
	}

	public void setItemDtls(List<ItemDtls> itemDtls) {
		this.itemDtls = itemDtls;
	}

	public List<TrnsprtEqmt> getTrnsprtEqmt() {
		return trnsprtEqmt;
	}

	public void setTrnsprtEqmt(List<TrnsprtEqmt> trnsprtEqmt) {
		this.trnsprtEqmt = trnsprtEqmt;
	}

	public List<Itnry> getItnry() {
		return itnry;
	}

	public void setItnry(List<Itnry> itnry) {
		this.itnry = itnry;
	}
}