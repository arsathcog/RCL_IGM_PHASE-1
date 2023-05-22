package com.rclgroup.dolphin.web.igm.vo;

public class TrnsprtDoc {
	public String prtOfAcptCdd;
	public String prtOfAcptName;
	public String prtOfReceiptCdd;
	public String prtOfReceiptName;
	public String cnsgnrsName;
	public String cnsgnrsCd;
	public String cnsgnrCdTyp;
	public String cnsgnrStreetAddress;
	public String cnsgnrCity;
	public String cnsgnrCntrySubDivName;
	public String cnsgnrCntrySubDivCd;
	public String cnsgnrCntryCd;
	public String cnsgnrPstcd;
	public String cnsgnesName;
	public String cnsgnesCd ;
	public String typOfCd;
	public String cnsgneStreetAddress;
	public String cnsgneCity;
	public String cnsgneCntrySubDivName;
	public String cnsgneCntrySubDiv ;
	public String cnsgneCntryCd ;
	public String cnsgnePstcd ;
	public String nameOfAnyOtherNotfdParty ;
	public String panOfNotfdParty;
	public String typOfNotfdPartyCd;
	public String notfdPartyStreetAddress;
	public String notfdPartyCity;
	public String notfdPartyCntrySubDivName;
	public String notfdPartyCntrySubDiv;
	public String notfdPartyCntryCd;
	public String notfdPartyPstcd;
	public String goodsDescAsPerBl;
	public String ucrTyp;
	public String ucrCd;


  //This value is come from BL Json object "Port of Acceptance"  (Add new field  BL POL in BL section)
	public String getPrtOfAcptCdd() {
		return prtOfAcptCdd;
	}

	public void setPrtOfAcptCdd(String prtOfAcptCdd) {
		prtOfAcptCdd = FiledValidation.isNullAndSetlength(prtOfAcptCdd, 6);
		this.prtOfAcptCdd = prtOfAcptCdd;
	}
	//This value is come from BL Json object "Port of Acceptance Name"(Take from port master setup while generating json file)
	public String getPrtOfAcptName() {
		return prtOfAcptName;
	}

	public void setPrtOfAcptName(String prtOfAcptName) {
		prtOfAcptName = FiledValidation.isNullAndSetlength(prtOfAcptName, 256);
		this.prtOfAcptName = prtOfAcptName;
	}
 //This value is come from BL Json object "porTrept" Add new field DEL which will come from BL DEL. .  make it 
	public String getPrtOfReceiptCdd() {
		return prtOfReceiptCdd;
	}

	public void setPrtOfReceiptCdd(String prtOfReceiptCdd) {
		prtOfReceiptCdd = FiledValidation.isNullAndSetlength(prtOfReceiptCdd, 10);
		this.prtOfReceiptCdd = prtOfReceiptCdd;
	}
     //   (Take from inland  master setup while generating json file)
	public String getPrtOfReceiptName() {
		return prtOfReceiptName;
	}

	public void setPrtOfReceiptName(String prtOfReceiptName) {
		prtOfReceiptName = FiledValidation.isNullAndSetlength(prtOfReceiptName, 256);
		this.prtOfReceiptName = prtOfReceiptName;
	}
        // This value is come from BL Json object "Consignor?s Name"(Shipper name based on shipper code  from BL. Add this new field )
	public String getCnsgnrsName() {
		return cnsgnrsName;
	}

	public void setCnsgnrsName(String cnsgnrsName) {
		cnsgnrsName = FiledValidation.isNullAndSetlength(cnsgnrsName, 70);
		this.cnsgnrsName = cnsgnrsName;
	}
      //   (Take from BL while generating json file) 
	public String getCnsgnrsCd() {
		return cnsgnrsCd;
	}

	public void setCnsgnrsCd(String cnsgnrsCd) {
		cnsgnrsCd = FiledValidation.isNullAndSetlength(cnsgnrsCd, 17);
		this.cnsgnrsCd = cnsgnrsCd;
	}
                    
	public String getCnsgnrCdTyp() {
		return cnsgnrCdTyp;
	}

	public void setCnsgnrCdTyp(String cnsgnrCdTyp) {
		cnsgnrCdTyp = FiledValidation.isNullAndSetlength(cnsgnrCdTyp, 3);
		this.cnsgnrCdTyp = cnsgnrCdTyp;
	}
     // This value is come from BL Json object "Consignor Street Address" (Add new column.Value will come from shipper. Same as consignee in current IGM)
	public String getCnsgnrStreetAddress() {
		return cnsgnrStreetAddress;
	}

	public void setCnsgnrStreetAddress(String cnsgnrStreetAddress) {
		cnsgnrStreetAddress = FiledValidation.isNullAndSetlength(cnsgnrStreetAddress, 70);
		this.cnsgnrStreetAddress = cnsgnrStreetAddress;
	}
   // (This value is come from BL Json object) (Add new column. Value will come from shipper. )
	public String getCnsgnrCity() {
		return cnsgnrCity;
	}

	public void setCnsgnrCity(String cnsgnrCity) {
		cnsgnrCity = FiledValidation.isNullAndSetlength(cnsgnrCity, 70);
		this.cnsgnrCity = cnsgnrCity;
	}

      // This value is come from BL Json object  "Consignor country sub division name"  (Add new column. Value will come from shipper. )
	public String getCnsgnrCntrySubDivName() {
		return cnsgnrCntrySubDivName;
	}

	public void setCnsgnrCntrySubDivName(String cnsgnrCntrySubDivName) {
		cnsgnrCntrySubDivName = FiledValidation.isNullAndSetlength(cnsgnrCntrySubDivName, 35);
		this.cnsgnrCntrySubDivName = cnsgnrCntrySubDivName;
	}

          //  (Add new column. Value will come from shipper. )
	public String getCnsgnrCntrySubDivCd() {
		return cnsgnrCntrySubDivCd;
	}

	public void setCnsgnrCntrySubDivCd(String cnsgnrCntrySubDivCd) {
		cnsgnrCntrySubDivCd = FiledValidation.isNullAndSetlength(cnsgnrCntrySubDivCd, 2);
		this.cnsgnrCntrySubDivCd = cnsgnrCntrySubDivCd;
	}

     //This value is come from BL Json object  "Consignor Country Code" (Add new column. Value will come from shipper. )
	public String getCnsgnrCntryCd() {
		return cnsgnrCntryCd;
	}

	public void setCnsgnrCntryCd(String cnsgnrCntryCd) {
		cnsgnrCntryCd = FiledValidation.isNullAndSetlength(cnsgnrCntryCd, 9);
		this.cnsgnrCntryCd = cnsgnrCntryCd;
	}
       //     (Add new column. Value will come from shipper. )
	public String getCnsgnrPstcd() {
		return cnsgnrPstcd;
	}

	public void setCnsgnrPstcd(String cnsgnrPstcd) {
		cnsgnrPstcd = FiledValidation.isNullAndSetlength(cnsgnrPstcd, 9);
		this.cnsgnrPstcd = cnsgnrPstcd;
	}

    //This value is come from BL Json object "customerName"(Already in current IGM screen)
	public String getCnsgnesName() {
		return cnsgnesName;
	}

	public void setCnsgnesName(String cnsgnesName) {
		cnsgnesName = FiledValidation.isNullAndSetlength(cnsgnesName, 70);
		this.cnsgnesName = cnsgnesName;
	}

     //This value is come from BL Json object  "customerCode"(Already in current IGM screen)
	public String getCnsgnesCd() {
		return cnsgnesCd;
	}

	public void setCnsgnesCd(String cnsgnesCd) {
		cnsgnesCd = FiledValidation.isNullAndSetlength(cnsgnesCd, 17);
		this.cnsgnesCd = cnsgnesCd;
	}

      //This value is optional feild not need to print in json file
	public String getTypOfCd() {
		return typOfCd;
	}

	public void setTypOfCd(String typOfCd) {
		typOfCd = FiledValidation.isNullAndSetlength(typOfCd, 3);
		this.typOfCd = typOfCd;
	}

       //(Already in current IGM screen)
	public String getCnsgneStreetAddress() {
		return cnsgneStreetAddress;
	}

	public void setCnsgneStreetAddress(String cnsgneStreetAddress) {
		cnsgneStreetAddress = FiledValidation.isNullAndSetlength(cnsgneStreetAddress, 70);
		this.cnsgneStreetAddress = cnsgneStreetAddress;
	}
      //This value is come from BL Json object  "city"(Already in current IGM screen)
	public String getCnsgneCity() {
		return cnsgneCity;
	}

	public void setCnsgneCity(String cnsgneCity) {
		cnsgneCity = FiledValidation.isNullAndSetlength(cnsgneCity, 70);
		this.cnsgneCity = cnsgneCity;
	}

   //optional (Already in current IGM screen)
	public String getCnsgneCntrySubDivName() {
		return cnsgneCntrySubDivName;
	}

	public void setCnsgneCntrySubDivName(String cnsgneCntrySubDivName) {
		cnsgneCntrySubDivName = FiledValidation.isNullAndSetlength(cnsgneCntrySubDivName, 35);
		this.cnsgneCntrySubDivName = cnsgneCntrySubDivName;
	}
   //optional (Already in current IGM screen)
	public String getCnsgneCntrySubDiv() {
		return cnsgneCntrySubDiv;
	}

	public void setCnsgneCntrySubDiv(String cnsgneCntrySubDiv) {
		cnsgneCntrySubDiv = FiledValidation.isNullAndSetlength(cnsgneCntrySubDiv, 9);
		this.cnsgneCntrySubDiv = cnsgneCntrySubDiv;
	}
       //This value is come from BL Json object   "countryCode" (Already in current IGM screen)   mandatory.
	public String getCnsgneCntryCd() {
		return cnsgneCntryCd;
	}

	public void setCnsgneCntryCd(String cnsgneCntryCd) {
		cnsgneCntryCd = FiledValidation.isNullAndSetlength(cnsgneCntryCd, 2);
		this.cnsgneCntryCd = cnsgneCntryCd;
	}
         //optional (Already in current IGM screen)
	public String getCnsgnePstcd() {
		return cnsgnePstcd;
	}

	public void setCnsgnePstcd(String cnsgnePstcd) {
		cnsgnePstcd = FiledValidation.isNullAndSetlength(cnsgnePstcd, 9);
		this.cnsgnePstcd = cnsgnePstcd;
	}

    //This value is come from BL Json object   "notifyPartyDlts" (Already in current IGM screen)   mandatory.
	public String getNameOfAnyOtherNotfdParty() {
		return nameOfAnyOtherNotfdParty;
	}

	public void setNameOfAnyOtherNotfdParty(String nameOfAnyOtherNotfdParty) {
		nameOfAnyOtherNotfdParty = FiledValidation.isNullAndSetlength(nameOfAnyOtherNotfdParty, 9);
		this.nameOfAnyOtherNotfdParty = nameOfAnyOtherNotfdParty;
	}

     // (Take from customer master on the basis of notify party. During generating JSON file)
	public String getPanOfNotfdParty() {
		return panOfNotfdParty;
	}

	public void setPanOfNotfdParty(String panOfNotfdParty) {
		panOfNotfdParty = FiledValidation.isNullAndSetlength(panOfNotfdParty, 17);
		this.panOfNotfdParty = panOfNotfdParty;
	}

   //optional (The Type ofIdentification of Code of the Notified Party as per the Transport Document issued by MLO.)
	public String getTypOfNotfdPartyCd() {
		return typOfNotfdPartyCd;
	}

	public void setTypOfNotfdPartyCd(String typOfNotfdPartyCd) {
		typOfNotfdPartyCd = FiledValidation.isNullAndSetlength(typOfNotfdPartyCd, 3);
		this.typOfNotfdPartyCd = typOfNotfdPartyCd;
	}
     //This value is come from BL Json object   "notifyPartyDlts" (Already in current IGM screen)   mandatory.
	public String getNotfdPartyStreetAddress() {
		return notfdPartyStreetAddress;
	}

	public void setNotfdPartyStreetAddress(String notfdPartyStreetAddress) {
		notfdPartyStreetAddress = FiledValidation.isNullAndSetlength(notfdPartyStreetAddress, 70);
		this.notfdPartyStreetAddress = notfdPartyStreetAddress;
	}
     
	  //This value is come from BL Json object "city" (Already in current IGM screen)   mandatory.
	public String getNotfdPartyCity() {
		return notfdPartyCity;
	}

	public void setNotfdPartyCity(String notfdPartyCity) {
		notfdPartyCity = FiledValidation.isNullAndSetlength(notfdPartyCity, 70);
		this.notfdPartyCity = notfdPartyCity;
	}
      //   optional (Already in current IGM screen)
	public String getNotfdPartyCntrySubDivName() {
		return notfdPartyCntrySubDivName;
	}

	public void setNotfdPartyCntrySubDivName(String notfdPartyCntrySubDivName) {
		notfdPartyCntrySubDivName = FiledValidation.isNullAndSetlength(notfdPartyCntrySubDivName, 35);
		this.notfdPartyCntrySubDivName = notfdPartyCntrySubDivName;
	}
      //   optional (Already in current IGM screen)
	public String getNotfdPartyCntrySubDiv() {
		return notfdPartyCntrySubDiv;
	}
      
	public void setNotfdPartyCntrySubDiv(String notfdPartyCntrySubDiv) {
		notfdPartyCntrySubDivName = FiledValidation.isNullAndSetlength(notfdPartyCntrySubDivName, 9);
		this.notfdPartyCntrySubDiv = notfdPartyCntrySubDiv;
	}

       //optional > This value is come from BL Json object "countryCode" optional (Already in current IGM screen)
	public String getNotfdPartyCntryCd() {
		return notfdPartyCntryCd;
	}

	public void setNotfdPartyCntryCd(String notfdPartyCntryCd) {
		notfdPartyCntryCd = FiledValidation.isNullAndSetlength(notfdPartyCntryCd, 2);
		this.notfdPartyCntryCd = notfdPartyCntryCd;
	}
       //   optional   (Already in current IGM screen)
	public String getNotfdPartyPstcd() {
		return notfdPartyPstcd;
	}

	public void setNotfdPartyPstcd(String notfdPartyPstcd) {
		notfdPartyPstcd = FiledValidation.isNullAndSetlength(notfdPartyPstcd, 9);
		this.notfdPartyPstcd = notfdPartyPstcd;
	}

     // (Use marks description from IGM screen. Just pickup first 512 character while) >mandatory
	public String getGoodsDescAsPerBl() {
		return goodsDescAsPerBl;
	}

	public void setGoodsDescAsPerBl(String goodsDescAsPerBl) {
		goodsDescAsPerBl = FiledValidation.isNullAndSetlength(goodsDescAsPerBl, 512);
		this.goodsDescAsPerBl = goodsDescAsPerBl;
	}

     // optional > This value is come from BL Json object  "UCR Typel" (Add new field Free text in BL )
	public String getUcrTyp() {
		return ucrTyp;
	}

	public void setUcrTyp(String ucrTyp) {
		ucrTyp = FiledValidation.isNullAndSetlength(ucrTyp, 3);
		this.ucrTyp = ucrTyp;
	}

    // optional >This value is come from BL Json object  "UCR Code" (Add new field Free text in BL )
	public String getUcrCd() {
		return ucrCd;
	}
  
	public void setUcrCd(String ucrCd) {
		ucrTyp = FiledValidation.isNullAndSetlength(ucrTyp, 35);
		this.ucrCd = ucrCd;
	}
}