package com.rclgroup.dolphin.web.igm.actionform;

import java.util.List;

import org.apache.struts.upload.FormFile;

import com.niit.control.web.actionform.PaginationForm;

/**
 * The Class ImportGeneralManifestUim.
 */
public class ImportGeneralManifestUim extends PaginationForm {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	
	private FormFile fileExl;
	
	public FormFile getFileExl() {
		return fileExl;
	}

	public void setFileExl(FormFile fileExl) {
		this.fileExl = fileExl;
	}

	/** The bl. */
	private String bl;

	/** The in status. */
	private String inStatus;
	
	/** The del*/
	private String del;
	
	/** The depot*/
	private String depot;

	/** The bl creation date from. */
	private String blCreationDateFrom;

	/** The bl creation date to. */
	private String blCreationDateTo;

	/** The igmservice. */
	private String igmservice;

	/** The vessel. */
	private String vessel;

	/** The voyage. */
	private String voyage;

	/** The direction. */
	private String direction;

	/** The pol. */
	private String pol;

	/** The pol terminal. */
	private String polTerminal;

	/** The pod. */
	private String pod;

	/** The pod terminal. */
	private String podTerminal;
	
	/** The find response. */
	private List findResponse;

	/** The save response. */
	private String saveResponse;

	/** The custom code. */
	private String customCode;

	/** The call sign. */
	private String callSign;

	/** The imo code. */
	private String imoCode;

	/** The agent code. */
	private String agentCode;

	/** The line code. */
	private String lineCode;

	/** The port origin. */
	private String portOrigin;

	/** The prt 1. */
	private String prt1;  //-3

	/** The prt 2. */
	private String prt2;  //-2

	/** The prt 3. */
	private String prt3;   //-1

	/** The port of arrival. */
	private String portOfArrival;

	/** The Vessel types. */
	private String VesselTypes;

	/** The general description. */
	private String generalDescription;

	/** The Nationality of vessel. */
	private String NationalityOfVessel;

	/** The Master name. */
	private String MasterName;

	/** The igm no. */
	private String igmNo;

	/** The igm date. */
	private String igmDate;

	/** The a date. */
	private String aDate;

	/** The a time. */
	private String aTime;

	/** The ata ad. */
	private String ataAd;

	/** The ata at. */
	private String ataAt;

	/** The total item. */
	private String totalItem;

	/** The Lighthouse due. */
	private String lighthouseDue;

	/** The Gross weight vessel. */
	private String GrossWeightVessel;

	/** The Net weight vessel. */
	private String NetWeightVessel;
	
	/** The Net weight vessel. */
	private String excelfile ;

	/** The Same bottom cargo. */
	private String SameBottomCargo;

	/** The Ship store declaration. */
	private String ShipStoreDeclaration;

	/** The Crew list declaration. */
	private String CrewListDeclaration;

	/** The Cargo declaration. */
	private String CargoDeclaration;

	/** The Passenger list. */
	private String PassengerList;

	/** The Crew effect. */
	private String CrewEffect;

	/** The Maritime declaration. */
	private String MaritimeDeclaration;
	
	/**The serial number */
	private String serialNumber;

	/** The BL details. */
	private String BLDetails;

	/** The vessel voyage dtls. */
	private String vesselVoyageDtls;
	
	/** The vessel consignee dtls. */
	private String consigneeDtls;
	
	/** The vessel notify Party dtls. */
	private String notifyPartyDlts;

	/** The vessel containerDetails dtls. */
	private String containerDetailsDtls;
	
	/** The vessel marks Number dtls. */
	private String marksNumberDtlstls;
	
	/** The file.1 */
	private FormFile file1;

	/** The file.2 */
	private FormFile file2;

	private String departureManifestNumber;
	
	private String departureManifestDate;
	
	private String submitterType;
	
	private String submitterCode;
	
	private String authorizedRepresentativeCode;
	
	private String shippingLineBondNumber;
	
	private String modeofTransport;
	
	private String shipType;
	
    private String conveyanceReferenceNumber;
	
	private String totalNoofTransportEquipmentManifested;
	
	private String cargoDescription;
	
	private String briefCargoDescription;
	
	private String expectedDate;
	
	private String timeofDeparture;
	
	private String portofcallCoded;
	
	private String totalnooftransportcontractsreportedonArrivalDeparture;
	
    private String messtype;
	
	private String vesType;
	
	private String authoseaCarcode;
	
	private String portoDreg;
	
	private String regDate;
	
	private String voyDetails;
	
	private String shipItiseq;
	
	private String shipItinerary;
	
    private String portofCallname;
	
	private String arrivalDepdetails;
	
	private String totalnoTransarrivdep;
	
	private String consignerDtlstls;
	
	private String last1;   //1
	
	private String last2;	//2
	
	private String last3;   //3
	
	private String generatFalg;
	
	private String numberofCrewManifested;

	public String getNumberofCrewManifested() {
		return numberofCrewManifested;
	}

	public void setNumberofCrewManifested(String numberofCrewManifested) {
		this.numberofCrewManifested = numberofCrewManifested;
	}

	public String getGeneratFalg() {
		return generatFalg;
	}

	public void setGeneratFalg(String generatFalg) {
		this.generatFalg = generatFalg;
	}

	/**
	 * Gets the file.
	 *
	 * @return the file
	 */
	public FormFile getFile1() {
		return file1;
	}

	/**
	 * Sets the file.
	 *
	 * @param file the new file
	 */
	public void setFile1(FormFile file1) {
		this.file1 = file1;
	}

	/**
	 * Gets the file.
	 *
	 * @return the file
	 */
	public FormFile getFile2() {
		return file2;
	}

	/**
	 * Sets the file.
	 *
	 * @param file the new file
	 */
	public void setFile2(FormFile file2) {
		this.file2 = file2;
	}

	/**
	 * Gets the cargo declaration.
	 *
	 * @return the cargo declaration
	 */
	public String getCargoDeclaration() {
		return CargoDeclaration;
	}

	/**
	 * Sets the cargo declaration.
	 *
	 * @param cargoDeclaration the new cargo declaration
	 */
	public void setCargoDeclaration(String cargoDeclaration) {
		CargoDeclaration = cargoDeclaration;
	}

	/**
	 * Gets the custom code.
	 *
	 * @return the custom code
	 */
	public String getCustomCode() {
		return customCode;
	}

	/**
	 * Sets the custom code.
	 *
	 * @param customCode the new custom code
	 */
	public void setCustomCode(String customCode) {
		this.customCode = customCode;
	}

	/**
	 * Gets the call sign.
	 *
	 * @return the call sign
	 */
	public String getCallSign() {
		return callSign;
	}

	/**
	 * Sets the call sign.
	 *
	 * @param callSign the new call sign
	 */
	public void setCallSign(String callSign) {
		this.callSign = callSign;
	}

	/**
	 * Gets the imo code.
	 *
	 * @return the imo code
	 */
	public String getImoCode() {
		return imoCode;
	}

	/**
	 * Sets the imo code.
	 *
	 * @param imoCode the new imo code
	 */
	public void setImoCode(String imoCode) {
		this.imoCode = imoCode;
	}

	/**
	 * Gets the agent code.
	 *
	 * @return the agent code
	 */
	public String getAgentCode() {
		return agentCode;
	}

	/**
	 * Sets the agent code.
	 *
	 * @param agentCode the new agent code
	 */
	public void setAgentCode(String agentCode) {
		this.agentCode = agentCode;
	}

	/**
	 * Gets the line code.
	 *
	 * @return the line code
	 */
	public String getLineCode() {
		return lineCode;
	}

	/**
	 * Sets the line code.
	 *
	 * @param lineCode the new line code
	 */
	public void setLineCode(String lineCode) {
		this.lineCode = lineCode;
	}

	/**
	 * Gets the port origin.
	 *
	 * @return the port origin
	 */
	public String getPortOrigin() {
		return portOrigin;
	}

	/**
	 * Sets the port origin.
	 *
	 * @param portOrigin the new port origin
	 */
	public void setPortOrigin(String portOrigin) {
		this.portOrigin = portOrigin;
	}

	/**
	 * Gets the prt 1.
	 *
	 * @return the prt 1
	 */
	public String getPrt1() {
		return prt1;
	}

	/**
	 * Sets the prt 1.
	 *
	 * @param prt1 the new prt 1
	 */
	public void setPrt1(String prt1) {
		this.prt1 = prt1;
	}

	/**
	 * Gets the prt 2.
	 *
	 * @return the prt 2
	 */
	public String getPrt2() {
		return prt2;
	}

	/**
	 * Sets the prt 2.
	 *
	 * @param prt2 the new prt 2
	 */
	public void setPrt2(String prt2) {
		this.prt2 = prt2;
	}

	/**
	 * Gets the prt 3.
	 *
	 * @return the prt 3
	 */
	public String getPrt3() {
		return prt3;
	}

	/**
	 * Sets the prt 3.
	 *
	 * @param prt3 the new prt 3
	 */
	public void setPrt3(String prt3) {
		this.prt3 = prt3;
	}

	
	
	public String getLast1() {
		return last1;
	}

	public void setLast1(String last1) {
		this.last1 = last1;
	}

	public String getLast2() {
		return last2;
	}

	public void setLast2(String last2) {
		this.last2 = last2;
	}

	public String getLast3() {
		return last3;
	}

	public void setLast3(String last3) {
		this.last3 = last3;
	}

	/**
	 * Gets the port of arrival.
	 *
	 * @return the port of arrival
	 */
	public String getPortOfArrival() {
		return portOfArrival;
	}

	/**
	 * Sets the port of arrival.
	 *
	 * @param portOfArrival the new port of arrival
	 */
	public void setPortOfArrival(String portOfArrival) {
		this.portOfArrival = portOfArrival;
	}

	/**
	 * Gets the vessel types.
	 *
	 * @return the vessel types
	 */
	public String getVesselTypes() {
		return VesselTypes;
	}

	/**
	 * Sets the vessel types.
	 *
	 * @param vesselTypes the new vessel types
	 */
	public void setVesselTypes(String vesselTypes) {
		VesselTypes = vesselTypes;
	}

	/**
	 * Gets the general description.
	 *
	 * @return the general description
	 */
	public String getGeneralDescription() {
		return generalDescription;
	}

	/**
	 * Sets the general description.
	 *
	 * @param generalDescription the new general description
	 */
	public void setGeneralDescription(String generalDescription) {
		this.generalDescription = generalDescription;
	}

	/**
	 * Gets the nationality of vessel.
	 *
	 * @return the nationality of vessel
	 */
	public String getNationalityOfVessel() {
		return NationalityOfVessel;
	}

	/**
	 * Sets the nationality of vessel.
	 *
	 * @param nationalityOfVessel the new nationality of vessel
	 */
	public void setNationalityOfVessel(String nationalityOfVessel) {
		NationalityOfVessel = nationalityOfVessel;
	}

	/**
	 * Gets the master name.
	 *
	 * @return the master name
	 */
	public String getMasterName() {
		return MasterName;
	}

	/**
	 * Sets the master name.
	 *
	 * @param masterName the new master name
	 */
	public void setMasterName(String masterName) {
		MasterName = masterName;
	}

	/**
	 * Gets the igm no.
	 *
	 * @return the igm no
	 */
	public String getIgmNo() {
		return igmNo;
	}

	/**
	 * Sets the igm no.
	 *
	 * @param igmNo the new igm no
	 */
	public void setIgmNo(String igmNo) {
		this.igmNo = igmNo;
	}

	/**
	 * Gets the igm date.
	 *
	 * @return the igm date
	 */
	public String getIgmDate() {
		return igmDate;
	}

	/**
	 * Sets the igm date.
	 *
	 * @param igmDate the new igm date
	 */
	public void setIgmDate(String igmDate) {
		this.igmDate = igmDate;
	}

	/**
	 * Gets the a date.
	 *
	 * @return the a date
	 */
	public String getaDate() {
		return aDate;
	}

	/**
	 * Sets the a date.
	 *
	 * @param aDate the new a date
	 */
	public void setaDate(String aDate) {
		String aNewDate="";
		if(aDate!=null && !aDate.equals("")) {
		String dateArray[] = aDate.split("/");
		aNewDate=dateArray[2]+dateArray[1]+dateArray[0];
		}
		this.aDate = aNewDate;
	
	}

	/**
	 * Gets the a time.
	 *
	 * @return the a time
	 */
	public String getaTime() {
		return aTime;
	}

	/**
	 * Sets the a time.
	 *
	 * @param aTime the new a time
	 */
	public void setaTime(String aTime) {
		String aNewTime="0";
		if(aTime!=null) {
		aNewTime=aTime.replace(":","");
		}
		this.aTime = aNewTime;
	}

	/**
	 * Gets the ata ad.
	 *
	 * @return the ata ad
	 */
	public String getAtaAd() {
		return ataAd;
	}

	/**
	 * Sets the ata ad.
	 *
	 * @param ataAd the new ata ad
	 */
	public void setAtaAd(String ataAd) {
		this.ataAd = ataAd;
	}

	/**
	 * Gets the ata at.
	 *
	 * @return the ata at
	 */
	public String getAtaAt() {
		return ataAt;
	}

	/**
	 * Sets the ata at.
	 *
	 * @param ataAt the new ata at
	 */
	public void setAtaAt(String ataAt) {
			this.ataAt = ataAt;
	}

	/**
	 * Gets the total item.
	 *
	 * @return the total item
	 */
	public String getTotalItem() {
		return totalItem;
	}

	/**
	 * Sets the total item.
	 *
	 * @param totalItem the new total item
	 */
	public void setTotalItem(String totalItem) {
		this.totalItem = totalItem;
	}

	/**
	 * Gets the lighthouse due.
	 *
	 * @return the lighthouse due
	 */
	public String getLighthouseDue() {
		return lighthouseDue;
	}

	public void setLighthouseDue(String lighthouseDue) {
		this.lighthouseDue = lighthouseDue;
	}

	/**
	 * Sets the lighthouse due.
	 *
	 * @param lighthouseDue the new lighthouse due
	 */


	/**
	 * Gets the gross weight vessel.
	 *
	 * @return the gross weight vessel
	 */
	public String getGrossWeightVessel() {
		return GrossWeightVessel;
	}

	/**
	 * Sets the gross weight vessel.
	 *
	 * @param grossWeightVessel the new gross weight vessel
	 */
	public void setGrossWeightVessel(String grossWeightVessel) {
		GrossWeightVessel = grossWeightVessel;
	}

	/**
	 * Gets the net weight vessel.
	 *
	 * @return the net weight vessel
	 */
	public String getNetWeightVessel() {
		return NetWeightVessel;
	}

	/**
	 * Sets the net weight vessel.
	 *
	 * @param netWeightVessel the new net weight vessel
	 */
	public void setNetWeightVessel(String netWeightVessel) {
		NetWeightVessel = netWeightVessel;
	}

	/**
	 * Gets the same bottom cargo.
	 *
	 * @return the same bottom cargo
	 */
	public String getSameBottomCargo() {
		return SameBottomCargo;
	}

	/**
	 * Sets the same bottom cargo.
	 *
	 * @param sameBottomCargo the new same bottom cargo
	 */
	public void setSameBottomCargo(String sameBottomCargo) {
		SameBottomCargo = sameBottomCargo;
	}

	/**
	 * Gets the ship store declaration.
	 *
	 * @return the ship store declaration
	 */
	public String getShipStoreDeclaration() {
		return ShipStoreDeclaration;
	}

	/**
	 * Sets the ship store declaration.
	 *
	 * @param shipStoreDeclaration the new ship store declaration
	 */
	public void setShipStoreDeclaration(String shipStoreDeclaration) {
		ShipStoreDeclaration = shipStoreDeclaration;
	}

	/**
	 * Gets the crew list declaration.
	 *
	 * @return the crew list declaration
	 */
	public String getCrewListDeclaration() {
		return CrewListDeclaration;
	}

	/**
	 * Sets the crew list declaration.
	 *
	 * @param crewListDeclaration the new crew list declaration
	 */
	public void setCrewListDeclaration(String crewListDeclaration) {
		CrewListDeclaration = crewListDeclaration;
	}

	/**
	 * Gets the passenger list.
	 *
	 * @return the passenger list
	 */
	public String getPassengerList() {
		return PassengerList;
	}

	/**
	 * Sets the passenger list.
	 *
	 * @param passengerList the new passenger list
	 */
	public void setPassengerList(String passengerList) {
		PassengerList = passengerList;
	}

	/**
	 * Gets the crew effect.
	 *
	 * @return the crew effect
	 */
	public String getCrewEffect() {
		return CrewEffect;
	}

	/**
	 * Sets the crew effect.
	 *
	 * @param crewEffect the new crew effect
	 */
	public void setCrewEffect(String crewEffect) {
		CrewEffect = crewEffect;
	}

	/**
	 * Gets the maritime declaration.
	 *
	 * @return the maritime declaration
	 */
	public String getMaritimeDeclaration() {
		return MaritimeDeclaration;
	}

	/**
	 * Sets the maritime declaration.
	 *
	 * @param maritimeDeclaration the new maritime declaration
	 */
	public void setMaritimeDeclaration(String maritimeDeclaration) {
		MaritimeDeclaration = maritimeDeclaration;
	}

	/**
	 * Gets the BL details.
	 *
	 * @return the BL details
	 */
	public String getBLDetails() {
		return BLDetails;
	}

	/**
	 * Sets the BL details.
	 *
	 * @param bLDetails the new BL details
	 */
	public void setBLDetails(String bLDetails) {
		BLDetails = bLDetails;
	}

	/**
	 * Gets the vessel voyage dtls.
	 *
	 * @return the vessel voyage dtls
	 */
	public String getVesselVoyageDtls() {
		return vesselVoyageDtls;
	}

	/**
	 * Sets the vessel voyage dtls.
	 *
	 * @param vesselVoyageDtls the new vessel voyage dtls
	 */
	public void setVesselVoyageDtls(String vesselVoyageDtls) {
		this.vesselVoyageDtls = vesselVoyageDtls;
	}

	/**
	 * Instantiates a new import general manifest uim.
	 */
	public ImportGeneralManifestUim() {
		super();
	}

	/**
	 * Gets the save response.
	 *
	 * @return the save response
	 */
	public String getSaveResponse() {
		return saveResponse;
	}

	/**
	 * Sets the save response.
	 *
	 * @param saveResponse the new save response
	 */
	public void setSaveResponse(String saveResponse) {
		this.saveResponse = saveResponse;
	}

	/**
	 * Gets the bl.
	 *
	 * @return the bl
	 */
	public String getBl() {
		return bl;
	}

	/**
	 * Sets the bl.
	 *
	 * @param bl the new bl
	 */
	public void setBl(String bl) {
		this.bl = bl;
	}

	/**
	 * Gets the in status.
	 *
	 * @return the in status
	 */
	public String getInStatus() {
		return inStatus;
	}

	/**
	 * Sets the in status.
	 *
	 * @param inStatus the new in status
	 */
	public void setInStatus(String inStatus) {
		this.inStatus = inStatus;
	}

	/**
	 * Gets the bl creation date from.
	 *
	 * @return the bl creation date from
	 */
	public String getBlCreationDateFrom() {
		return blCreationDateFrom;
	}

	/**
	 * Sets the bl creation date from.
	 *
	 * @param blCreationDateFrom the new bl creation date from
	 */
	/*public void setBlCreationDateFrom(String blCreationDateFrom) {
		if (blCreationDateFrom.contains("/"))
			this.blCreationDateFrom = blCreationDateFrom.replaceAll("/", "");
	}*/
	public void setBlCreationDateFrom(String blCreationDateFrom) {
		String blCreaDate = "";
		if(!blCreationDateFrom.equals("") && blCreationDateFrom != null) {
			String dateArray[] = blCreationDateFrom.split("/");
			blCreationDateFrom=dateArray[2]+dateArray[1]+dateArray[0];
			blCreaDate = blCreationDateFrom;
		}
		this.blCreationDateFrom = blCreaDate;
	}

	/**
	 * Gets the bl creation date to.
	 *
	 * @return the bl creation date to
	 */
	public String getBlCreationDateTo() {
		return blCreationDateTo;
	}

	/**
	 * Sets the bl creation date to.
	 *
	 * @param blCreationDateTo the new bl creation date to
	 */
	/*public void setBlCreationDateTo(String blCreationDateTo) {
		if (blCreationDateTo.contains("/"))
			this.blCreationDateTo = blCreationDateTo.replaceAll("/", "");

	}*/
	public void setBlCreationDateTo(String blCreationDateTo) {
		String blCreateDateTo = "";
		if(blCreationDateTo != null && !blCreationDateTo.equals("")) {
			String dateArray[] = blCreationDateTo.split("/");
			blCreationDateTo=dateArray[2]+dateArray[1]+dateArray[0];
			blCreateDateTo = blCreationDateTo;
		}
		this.blCreationDateTo = blCreateDateTo;
	}
	
	/**
	 * Gets the igmservice.
	 *
	 * @return the igmservice
	 */
	public String getIgmservice() {
		return igmservice;
	}

	/**
	 * Sets the igmservice.
	 *
	 * @param igmservice the new igmservice
	 */
	public void setIgmservice(String igmservice) {
		this.igmservice = igmservice;
	}

	/**
	 * Gets the vessel.
	 *
	 * @return the vessel
	 */
	public String getVessel() {
		return vessel;
	}

	/**
	 * Sets the vessel.
	 *
	 * @param vessel the new vessel
	 */
	public void setVessel(String vessel) {
		this.vessel = vessel;
	}

	/**
	 * Gets the voyage.
	 *
	 * @return the voyage
	 */
	public String getVoyage() {
		return voyage;
	}

	/**
	 * Sets the voyage.
	 *
	 * @param voyage the new voyage
	 */
	public void setVoyage(String voyage) {
		this.voyage = voyage;
	}

	/**
	 * Gets the direction.
	 *
	 * @return the direction
	 */
	public String getDirection() {
		return direction;
	}

	/**
	 * Sets the direction.
	 *
	 * @param direction the new direction
	 */
	public void setDirection(String direction) {
		this.direction = direction;
	}

	/**
	 * Gets the pol.
	 *
	 * @return the pol
	 */
	public String getPol() {
		return pol;
	}

	/**
	 * Sets the pol.
	 *
	 * @param pol the new pol
	 */
	public void setPol(String pol) {
		this.pol = pol;
	}

	/**
	 * Gets the pol terminal.
	 *
	 * @return the pol terminal
	 */
	public String getPolTerminal() {
		return polTerminal;
	}

	/**
	 * Sets the pol terminal.
	 *
	 * @param polTerminal the new pol terminal
	 */
	public void setPolTerminal(String polTerminal) {
		this.polTerminal = polTerminal;
	}

	/**
	 * Gets the pod.
	 *
	 * @return the pod
	 */
	public String getPod() {
		return pod;
	}

	/**
	 * Sets the pod.
	 *
	 * @param pod the new pod
	 */
	public void setPod(String pod) {
		this.pod = pod;
	}

	/**
	 * Gets the serial number.
	 *
	 * @return the serial number
	 */
	
	public String getSerialNumber() {
		return serialNumber;
	}

	/**
	 * Sets the serial number.
	 *
	 * @param serialNumber the new serial number
	 */
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}
	
	/**
	 * Gets the pod terminal.
	 *
	 * @return the pod terminal
	 */
	public String getPodTerminal() {
		return podTerminal;
	}

	/**
	 * Sets the pod terminal.
	 *
	 * @param podTerminal the new pod terminal
	 */
	public void setPodTerminal(String podTerminal) {
		this.podTerminal = podTerminal;
	}

	/**
	 * Sets the find response.
	 *
	 * @param findResponse the new find response
	 */
	public void setFindResponse(List findResponse) {
		this.findResponse = findResponse;
	}

	/**
	 * Gets the find response.
	 *
	 * @return the find response
	 */
	public List getFindResponse() {
		return findResponse;
	}

	/**
	 * Gets the DEL details.
	 *
	 * @return the DEL details
	 */
	public String getDel() {
		return del;
	}

	/**
	 * Sets the find response.
	 *
	 * @param findResponse the new find response
	 */
	public void setDel(String del) {
		this.del = del;
	}
	
	/**
	 * Gets the DEPOT details.
	 *
	 * @return the DEPOT details
	 */
	public String getDepot() {
		return depot;
	}

	/**
	 * Sets the depot.
	 *
	 * @param depot the new find depot
	 */
	public void setDepot(String depot) {
		this.depot = depot;
	}
	/**
	 * Gets the EXCEL upload.
	 *
	 * @return the EXCEL upload
	 */
	public String getExcelfile() {
		return excelfile;
	}

	/**
	 * Sets the EXCEL upload.
	 *
	 * @param excelupload the new excelupload
	 */
	public void setExcelfile(String excelfile) {
		this.excelfile = excelfile;
	}

	/**
	 * Gets the Consignee details.
	 *
	 * @return the Consignee details
	 */
	public String getConsigneeDtls() {
		return consigneeDtls;
	}

	/**
	 * Sets the Consignee details.
	 *
	 * @param consigneeDtls the new Consignee details
	 */
	public void setConsigneeDtls(String consigneeDtls) {
		this.consigneeDtls = consigneeDtls;
	}

	/**
	 * Gets the NotifyParty details.
	 *
	 * @return the NotifyParty details
	 */
	public String getNotifyPartyDlts() {
		return notifyPartyDlts;
	}

	/**
	 * Sets the NotifyParty details.
	 *
	 * @param notifyPartyDlts the new NotifyParty details
	 */
	public void setNotifyPartyDlts(String notifyPartyDlts) {
		this.notifyPartyDlts = notifyPartyDlts;
	}

	/**
	 * Gets the ContainerDetails details.
	 *
	 * @return the ContainerDetails details
	 */
	public String getContainerDetailsDtls() {
		return containerDetailsDtls;
	}

	/**
	 * Sets the ContainerDetails details.
	 *
	 * @param ContainerDetails the new ContainerDetails details
	 */
	public void setContainerDetailsDtls(String containerDetailsDtls) {
		this.containerDetailsDtls = containerDetailsDtls;
	}
	/**
	 * Gets the MarksNumber details.
	 *
	 * @return the MarksNumber details
	 */
	public String getMarksNumberDtlstls() {
		return marksNumberDtlstls;
	}

	/**
	 * Sets the MarksNumber details.
	 *
	 * @param MarksNumber the new MarksNumber details
	 */
	public void setMarksNumberDtlstls(String marksNumberDtlstls) {
		this.marksNumberDtlstls = marksNumberDtlstls;
	}

	public String getDepartureManifestNumber() {
		return departureManifestNumber;
	}

	public void setDepartureManifestNumber(String departureManifestNumber) {
		this.departureManifestNumber = departureManifestNumber;
	}

	public String getDepartureManifestDate() {
		return departureManifestDate;
	}

	public void setDepartureManifestDate(String departureManifestDate) {
		this.departureManifestDate = departureManifestDate;
	}

	public String getSubmitterType() {
		return submitterType;
	}

	public void setSubmitterType(String submitterType) {
		this.submitterType = submitterType;
	}

	public String getSubmitterCode() {
		return submitterCode;
	}

	public void setSubmitterCode(String submitterCode) {
		this.submitterCode = submitterCode;
	}

	public String getAuthorizedRepresentativeCode() {
		return authorizedRepresentativeCode;
	}

	public void setAuthorizedRepresentativeCode(String authorizedRepresentativeCode) {
		this.authorizedRepresentativeCode = authorizedRepresentativeCode;
	}

	public String getShippingLineBondNumber() {
		return shippingLineBondNumber;
	}

	public void setShippingLineBondNumber(String shippingLineBondNumber) {
		this.shippingLineBondNumber = shippingLineBondNumber;
	}

	public String getModeofTransport() {
		return modeofTransport;
	}

	public void setModeofTransport(String modeofTransport) {
		this.modeofTransport = modeofTransport;
	}

	public String getShipType() {
		return shipType;
	}

	public void setShipType(String shipType) {
		this.shipType = shipType;
	}

	public String getConveyanceReferenceNumber() {
		return conveyanceReferenceNumber;
	}

	public void setConveyanceReferenceNumber(String conveyanceReferenceNumber) {
		this.conveyanceReferenceNumber = conveyanceReferenceNumber;
	}

	public String getTotalNoofTransportEquipmentManifested() {
		return totalNoofTransportEquipmentManifested;
	}

	public void setTotalNoofTransportEquipmentManifested(String totalNoofTransportEquipmentManifested) {
		this.totalNoofTransportEquipmentManifested = totalNoofTransportEquipmentManifested;
	}

	public String getCargoDescription() {
		return cargoDescription;
	}

	public void setCargoDescription(String cargoDescription) {
		this.cargoDescription = cargoDescription;
	}

	public String getBriefCargoDescription() {
		return briefCargoDescription;
	}

	public void setBriefCargoDescription(String briefCargoDescription) {
		this.briefCargoDescription = briefCargoDescription;
	}

	public String getExpectedDate() {
		return expectedDate;
	}

	public void setExpectedDate(String expectedDate) {
		this.expectedDate = expectedDate;
	}

	public String getTimeofDeparture() {
		return timeofDeparture;
	}

	public void setTimeofDeparture(String timeofDeparture) {
		this.timeofDeparture = timeofDeparture;
	}

	public String getPortofcallCoded() {
		return portofcallCoded;
	}

	public void setPortofcallCoded(String portofcallCoded) {
		this.portofcallCoded = portofcallCoded;
	}

	public String getTotalnooftransportcontractsreportedonArrivalDeparture() {
		return totalnooftransportcontractsreportedonArrivalDeparture;
	}

	public void setTotalnooftransportcontractsreportedonArrivalDeparture(
			String totalnooftransportcontractsreportedonArrivalDeparture) {
		this.totalnooftransportcontractsreportedonArrivalDeparture = totalnooftransportcontractsreportedonArrivalDeparture;
	}

	public String getMesstype() {
		return messtype;
	}

	public void setMesstype(String messtype) {
		this.messtype = messtype;
	}

	public String getVesType() {
		return vesType;
	}

	public void setVesType(String vesType) {
		this.vesType = vesType;
	}

	public String getAuthoseaCarcode() {
		return authoseaCarcode;
	}

	public void setAuthoseaCarcode(String authoseaCarcode) {
		this.authoseaCarcode = authoseaCarcode;
	}

	public String getPortoDreg() {
		return portoDreg;
	}

	public void setPortoDreg(String portoDreg) {
		this.portoDreg = portoDreg;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getVoyDetails() {
		return voyDetails;
	}

	public void setVoyDetails(String voyDetails) {
		this.voyDetails = voyDetails;
	}

	public String getShipItiseq() {
		return shipItiseq;
	}

	public void setShipItiseq(String shipItiseq) {
		this.shipItiseq = shipItiseq;
	}

	public String getShipItinerary() {
		return shipItinerary;
	}

	public void setShipItinerary(String shipItinerary) {
		this.shipItinerary = shipItinerary;
	}

	public String getPortofCallname() {
		return portofCallname;
	}

	public void setPortofCallname(String portofCallname) {
		this.portofCallname = portofCallname;
	}

	public String getArrivalDepdetails() {
		return arrivalDepdetails;
	}

	public void setArrivalDepdetails(String arrivalDepdetails) {
		this.arrivalDepdetails = arrivalDepdetails;
	}

	public String getTotalnoTransarrivdep() {
		return totalnoTransarrivdep;
	}

	public void setTotalnoTransarrivdep(String totalnoTransarrivdep) {
		this.totalnoTransarrivdep = totalnoTransarrivdep;
	}

	public String getConsignerDtlstls() {
		return consignerDtlstls;
	}

	public void setConsignerDtlstls(String consignerDtlstls) {
		this.consignerDtlstls = consignerDtlstls;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#toString()
	 */
	@Override
	
	public String toString() {
		return "ImportGeneralManifestUim [bl=" + bl + ", inStatus=" + inStatus + ", del=" + del + ", depot=" + depot
				+ ", blCreationDateFrom=" + blCreationDateFrom + ", blCreationDateTo=" + blCreationDateTo
				+ ", igmservice=" + igmservice + ", vessel=" + vessel + ", voyage=" + voyage + ", direction="
				+ direction + ", pol=" + pol + ", polTerminal=" + polTerminal + ", pod=" + pod + ", podTerminal="
				+ podTerminal + ", findResponse=" + findResponse + ", saveResponse=" + saveResponse + ", customCode="
				+ customCode + ", callSign=" + callSign + ", imoCode=" + imoCode + ", agentCode=" + agentCode
				+ ", lineCode=" + lineCode + ", portOrigin=" + portOrigin + ", prt1=" + prt1 + ", prt2=" + prt2
				+ ", prt3=" + prt3 + ", portOfArrival=" + portOfArrival + ", VesselTypes=" + VesselTypes
				+ ", generalDescription=" + generalDescription + ", NationalityOfVessel=" + NationalityOfVessel
				+ ", MasterName=" + MasterName + ", igmNo=" + igmNo + ", igmDate=" + igmDate + ", aDate=" + aDate
				+ ", aTime=" + aTime + ", ataAd=" + ataAd + ", ataAt=" + ataAt + ", totalItem=" + totalItem
				+ ", lighthouseDue=" + lighthouseDue + ", GrossWeightVessel=" + GrossWeightVessel + ", NetWeightVessel="
				+ NetWeightVessel + ", excelfile=" + excelfile + ", SameBottomCargo=" + SameBottomCargo
				+ ", ShipStoreDeclaration=" + ShipStoreDeclaration + ", CrewListDeclaration=" + CrewListDeclaration
				+ ", CargoDeclaration=" + CargoDeclaration + ", PassengerList=" + PassengerList + ", CrewEffect="
				+ CrewEffect + ", MaritimeDeclaration=" + MaritimeDeclaration + ", serialNumber=" + serialNumber
				+ ", BLDetails=" + BLDetails + ", vesselVoyageDtls=" + vesselVoyageDtls + ", consigneeDtls="
				+ consigneeDtls + ", notifyPartyDlts=" + notifyPartyDlts + ", containerDetailsDtls="
				+ containerDetailsDtls + ", marksNumberDtlstls=" + marksNumberDtlstls + ", file1=" + file1 + ", file2="
				+ file2 + "]";
	}

	

}