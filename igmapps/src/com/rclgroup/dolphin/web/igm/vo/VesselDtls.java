package com.rclgroup.dolphin.web.igm.vo;

public class VesselDtls {
	public String modeOfTrnsprt;
	//public String typOfTrnsprtMeans;
	//public String trnsprtMeansId;
	
        //#   scma given 
     public String vesselCd;
       
      public String shipTyp;

        //# new added feild not reqired  
       /* public String natnltyOfShip ;
        public String prtOfRegistry;
        public String registryDt;
        public String registryNmbr;
        public String grossTonnage;
        public String netTonnage;*/
        //#

        //#   Exmp given 
	public String purposeOfCall;


//(Default value as sea =1, (1=Sea, 2=Rail, 3=Truck, 4=Air). Add new column in vessel voyage . user will select manually.). mandatory
	public String getModeOfTrnsprt() {
		return modeOfTrnsprt;
	}

	public void setModeOfTrnsprt(String modeOfTrnsprt) {
		this.modeOfTrnsprt = modeOfTrnsprt;
	}

/*	public String getTypOfTrnsprtMeans() {
		return typOfTrnsprtMeans;
	}

	public void setTypOfTrnsprtMeans(String typOfTrnsprtMeans) {
		this.typOfTrnsprtMeans = typOfTrnsprtMeans;
	}

	public String getTrnsprtMeansId() {
		return trnsprtMeansId;
	}

	public void setTrnsprtMeansId(String trnsprtMeansId) {
		this.trnsprtMeansId = trnsprtMeansId;
	}*/

//(Same as Call Sign from current screen),(A unique ship'sidentification used primarily for radio communications shown on the ship's IMO certificates.)
	public String getVesselCd() {
		return vesselCd;
	}

	public void setVesselCd(String vesselCd) {
		this.vesselCd = vesselCd;
	}
//(Add Ship Type in current screen with free text. No default value).>optional
	public String getShipTyp() {
		return shipTyp;
	}

	public void setShipTyp(String shipTyp) {
		this.shipTyp = shipTyp;
	}

//  value of vessel type "NationalityOfVessel"  (Same as Nationality Of Vessel from current screen)
	/*public String getNatnltyOfShip() {
		return natnltyOfShip;
	}

	public void setNatnltyOfShip(String natnltyOfShip) {
		this.natnltyOfShip = natnltyOfShip;
	}

// (Port of Registry take from vessel master . no need to show on screen)
	public String getPrtOfRegistry() {
		return prtOfRegistry;
	}

	public void setPrtOfRegistry(String prtOfRegistry) {
		this.prtOfRegistry = prtOfRegistry;
	}
*/
 //(Same as Flag/Ownership Effective Date from vessel master. No need to show on screen)
	/*public String getRegistryDt() {
		return registryDt;
	}

	public void setRegistryDt(String registryDt) {
		this.registryDt = registryDt;
	}
 
 // (Same as IMO Code from current screen)
	public String getRegistryNmbr() {
		return registryNmbr;
	}

	public void setRegistryNmbr(String registryNmbr) {
		this.registryNmbr = registryNmbr;
	}
// value of vessel type "GrossWeightVessel" (Same as Gross Weight Vessel from current screen)
	public String getGrossTonnage() {
		return grossTonnage;
	}

	public void setGrossTonnage(String grossTonnage) {
		this.grossTonnage = grossTonnage;
	}

// value of vessel type "NetWeightVessel" (Same as Net Weight Vessel from current screen)
	public String getNetTonnage() {
		return netTonnage;
	}

	public void setNetTonnage(String netTonnage) {
		this.netTonnage = netTonnage;
	}*/
//  (Value will be always 1 as mentioned in PURP_CALL)
	public String getPurposeOfCall() {
		return purposeOfCall;
	}

	public void setPurposeOfCall(String purposeOfCall) {
		this.purposeOfCall = purposeOfCall;
	}
	
	

}