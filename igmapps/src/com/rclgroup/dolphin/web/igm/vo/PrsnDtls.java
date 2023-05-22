package com.rclgroup.dolphin.web.igm.vo;

public class PrsnDtls {
	public String prsnTypCdd;
	public String prsnFamilyName;
	public String prsnGivenName;
	public String prsnNatnltyCdd;
	public String psngrInTransitIndctr;
	public String crewmemberRankOrRatingCdd;
	public String psngrPrtOfEmbrktnCdd;
	public String psngrPrtOfDsmbrktnCdd;
	public String prsnGenderCdd;
	public String prsnDtOfBirth;
	public String prsnPlaceOfBirthName;
	public String prsnCntryOfBirthCdd;

	public String getPrsnTypCdd() {
		return prsnTypCdd;
	}
	public void setPrsnTypCdd(String prsnTypCdd) {
		prsnTypCdd = FiledValidation.isNullAndSetlength(prsnTypCdd, 3);
		this.prsnTypCdd = prsnTypCdd;
	}
	public String getPrsnFamilyName() {
		return prsnFamilyName;
	}
	public void setPrsnFamilyName(String prsnFamilyName) {
		prsnFamilyName = FiledValidation.isNullAndSetlength(prsnFamilyName, 70);
		this.prsnFamilyName = prsnFamilyName;
	}
	public String getPrsnGivenName() {
		return prsnGivenName;
	}
	public void setPrsnGivenName(String prsnGivenName) {
		prsnGivenName = FiledValidation.isNullAndSetlength(prsnGivenName, 70);
		this.prsnGivenName = prsnGivenName;
	}
	public String getPrsnNatnltyCdd() {
		return prsnNatnltyCdd;
	}
	public void setPrsnNatnltyCdd(String prsnNatnltyCdd) {
		prsnNatnltyCdd = FiledValidation.isNullAndSetlength(prsnNatnltyCdd, 2);
		this.prsnNatnltyCdd = prsnNatnltyCdd;
	}
	public String getPsngrInTransitIndctr() {
		return psngrInTransitIndctr;
	}
	public void setPsngrInTransitIndctr(String psngrInTransitIndctr) {
		this.psngrInTransitIndctr = psngrInTransitIndctr;
	}
	public String getCrewmemberRankOrRatingCdd() {
		return crewmemberRankOrRatingCdd;
	}
	public void setCrewmemberRankOrRatingCdd(String crewmemberRankOrRatingCdd) {
		crewmemberRankOrRatingCdd = FiledValidation.isNullAndSetlength(crewmemberRankOrRatingCdd, 10);
		this.crewmemberRankOrRatingCdd = crewmemberRankOrRatingCdd;
	}
	public String getPsngrPrtOfEmbrktnCdd() {
		return psngrPrtOfEmbrktnCdd;
	}
	public void setPsngrPrtOfEmbrktnCdd(String psngrPrtOfEmbrktnCdd) {
		psngrPrtOfEmbrktnCdd = FiledValidation.isNullAndSetlength(psngrPrtOfEmbrktnCdd, 256);
		this.psngrPrtOfEmbrktnCdd = psngrPrtOfEmbrktnCdd;
	}
	public String getPsngrPrtOfDsmbrktnCdd() {
		return psngrPrtOfDsmbrktnCdd;
	}
	public void setPsngrPrtOfDsmbrktnCdd(String psngrPrtOfDsmbrktnCdd) {
		psngrPrtOfDsmbrktnCdd = FiledValidation.isNullAndSetlength(psngrPrtOfDsmbrktnCdd, 5);
		this.psngrPrtOfDsmbrktnCdd = psngrPrtOfDsmbrktnCdd;
	}
	public String getPrsnGenderCdd() {
		return prsnGenderCdd;
	}
	public void setPrsnGenderCdd(String prsnGenderCdd) {
		psngrPrtOfDsmbrktnCdd = FiledValidation.isNullAndSetlength(psngrPrtOfDsmbrktnCdd, 3);
		this.prsnGenderCdd = prsnGenderCdd;
	}
	public String getPrsnDtOfBirth() {
		return prsnDtOfBirth;
	}
	public void setPrsnDtOfBirth(String prsnDtOfBirth) {
		if ("".equals("prsnDtOfBirth")) {
			this.prsnDtOfBirth = prsnDtOfBirth;
		} else {
			if (prsnDtOfBirth.contains("/")) {
				String dateArray[] = prsnDtOfBirth.split("/");
				prsnDtOfBirth = dateArray[2] + dateArray[1] + dateArray[0];
				this.prsnDtOfBirth =prsnDtOfBirth;
			}
		}
	}
	public String getPrsnPlaceOfBirthName() {
		return prsnPlaceOfBirthName;
	}
	public void setPrsnPlaceOfBirthName(String prsnPlaceOfBirthName) {
		prsnPlaceOfBirthName = FiledValidation.isNullAndSetlength(prsnPlaceOfBirthName, 35);
		this.prsnPlaceOfBirthName = prsnPlaceOfBirthName;
	}
	public String getPrsnCntryOfBirthCdd() {
		return prsnCntryOfBirthCdd;
	}
	public void setPrsnCntryOfBirthCdd(String prsnCntryOfBirthCdd) {
		prsnCntryOfBirthCdd = FiledValidation.isNullAndSetlength(prsnCntryOfBirthCdd, 2);
		this.prsnCntryOfBirthCdd = prsnCntryOfBirthCdd;
	}

	
}
