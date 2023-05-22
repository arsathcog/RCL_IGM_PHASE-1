package com.rclgroup.dolphin.web.igm.vo;

public class ShipItnry {
	public String shipItnrySeq;
	public String prtOfCallCdd;
	public String prtOfCallName;

    //This value is come from BL Json object  "shipItiseq"
	public String getShipItnrySeq() {
		return shipItnrySeq;
	}

	public void setShipItnrySeq(String shipItnrySeq) {

		shipItnrySeq = FiledValidation.isNullAndSetlength(shipItnrySeq, 6);
		this.shipItnrySeq = shipItnrySeq;
	}
        //This value is come from BL Json object  "Port of Call Coded"  (Add next three port column in current screen)
	public String getPrtOfCallCdd() {
		return prtOfCallCdd;
	}

	public void setPrtOfCallCdd(String prtOfCallCdd) {
		prtOfCallCdd = FiledValidation.isNullAndSetlength(prtOfCallCdd, 6);
		this.prtOfCallCdd = prtOfCallCdd;
	}
   
    //This value is come from BL Json object "portofCallname" (Take value from port master)
	public String getPrtOfCallName() {
		return prtOfCallName;
	}

	public void setPrtOfCallName(String prtOfCallName) {
		prtOfCallName = FiledValidation.isNullAndSetlength(prtOfCallName, 256);
		this.prtOfCallName = prtOfCallName;
	}

}