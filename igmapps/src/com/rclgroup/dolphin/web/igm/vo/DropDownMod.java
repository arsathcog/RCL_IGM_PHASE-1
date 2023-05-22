package com.rclgroup.dolphin.web.igm.vo;

public class DropDownMod {

	private String partnerValuedre;
	private String descriptiondrw;
	private String podValue;
	
	
	public String getPartnerValuedre() {
		return partnerValuedre;
	}
	public void setPartnerValuedre(String partnerValuedre) {
		this.partnerValuedre = partnerValuedre;
	}
	
	public String getDescriptiondrw() {
		return descriptiondrw;
	}
	public void setDescriptiondrw(String descriptiondrw) {
		this.descriptiondrw = descriptiondrw;
	}
	public String getPodValue() {
		return podValue;
	}
	public void setPodValue(String podValue) {
		this.podValue = podValue;
	}
	@Override
	public String toString() {
		return "DropDownMod [partnerValuedre=" + partnerValuedre + ", descriptiondrw=" + descriptiondrw + ", podValue="
				+ podValue + "]";
	}
	
}
