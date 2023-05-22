package com.rclgroup.dolphin.web.igm.vo;

public class TrnsprtDocMsr {
	public String nmbrOfPkgs;
	public String typsOfPkgs;
	public String marksNoOnPkgs;
	public String grossWeight;
	public String netWeight;
	public String unitOfWeight;
	//public String invoiceValueOfCnsgmt;
	public String crncyCd;

      //This value is come from BL Json object  "Number of Packages"  (Same like above. Details in 3.5.6.3	MC Location_Customs)
	public String getNmbrOfPkgs() {
		return nmbrOfPkgs;
	}

	public void setNmbrOfPkgs(String nmbrOfPkgs) {
		this.nmbrOfPkgs = nmbrOfPkgs;
	}

  //This value is come from BL Json object   "Type of Package" (Same like above. Details in 3.5.6.3	MC Location_Customs)
	public String getTypsOfPkgs() {
		return typsOfPkgs;
	}

	public void setTypsOfPkgs(String typsOfPkgs) {
		typsOfPkgs = FiledValidation.isNullAndSetlength(typsOfPkgs, 3);
		this.typsOfPkgs = typsOfPkgs;
	}
     //  "marksNumberDtlstls"  (Use Marks & Numbers from IGM screen. First 512 characters) > mandatory
	public String getMarksNoOnPkgs() {
		return marksNoOnPkgs;
	}

	public void setMarksNoOnPkgs(String marksNoOnPkgs) {
		marksNoOnPkgs = FiledValidation.isNullAndSetlength(marksNoOnPkgs, 512);
		this.marksNoOnPkgs = marksNoOnPkgs;
	}
    
	  //This value is come from BL Json object  "GrossWeightVessel" , "Gross Cargo Weight BL level" (Use Gross Cargo Weight  of BL while generating json file)
	public String getGrossWeight() {
		return grossWeight;
	}

	public void setGrossWeight(String grossWeight) {
		//grossWeight = FiledValidation.isNullAndSetlength(grossWeight, 512);
		this.grossWeight = grossWeight;
	}
     
	  //This value is come from BL Json object "NetWeightVessel" (Use general tab Net Cargo Weight of BL while generating JSON file)>optional
	public String getNetWeight() {
		return netWeight;
	}

	public void setNetWeight(String netWeight) {
		this.netWeight = netWeight;
	}
  //(Use System Parameters Maintenance under DocumentationUnit of Measurement) >optional
	public String getUnitOfWeight() {
		return unitOfWeight;
	}

	public void setUnitOfWeight(String unitOfWeight) {
		unitOfWeight = FiledValidation.isNullAndSetlength(unitOfWeight, 3);
		this.unitOfWeight = unitOfWeight;
	}

   // given in red color ms doc. not clear Guru
	/*
	 * public String getInvoiceValueOfCnsgmt() { return invoiceValueOfCnsgmt; }
	 * 
	 * public void setInvoiceValueOfCnsgmt(String invoiceValueOfCnsgmt) {
	 * this.invoiceValueOfCnsgmt = invoiceValueOfCnsgmt; }
	 */
  // given in red color ms doc. not clear Guru
	public String getCrncyCd() {
		return crncyCd;
	}

	public void setCrncyCd(String crncyCd) {
		this.crncyCd = crncyCd;
	}
}
