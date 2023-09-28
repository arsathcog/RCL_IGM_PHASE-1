package com.rclgroup.dolphin.web.igm.vo;

import java.util.ArrayList;
import java.util.List;



/**
 * The Class ImportGeneralManifestMod.
 */
public class ImportGeneralManifestMod {

	/** The consignee*/
	private List<Consignee> consignee=new ArrayList<>() ;
	
	/** The consigner*/
	private List<Consigner> consigner=new ArrayList<>() ;
	
	/**The nortify party*/
	private List<NotifyParty> notifyParty=new ArrayList<>();
	
	/**The marks no.*/
	private List<MarksNumber> marksNumber=new ArrayList<>();
	
	/**The container Details*/
	private List<ContainerDetails> containerDetailes=new ArrayList<>();
	
	/** The bl. */
	private String bl;

	/** The service. */
	private String service;

	/** The vessel. */
	private String vessel;

	/** The voyage. */
	private String voyage;

	/** The pol. */
	private String pol;

	/** The pol terminal. */
	private String polTerminal;
	
	/** The del. */
	private String del;
	
	/** The depot. */
	private String depot;

	/** The pod. */
	private String pod;

	/** The pod terminal. */
	private String podTerminal;

	/** The code code. */
	private String codeCode;

	/** The call sing. */
	private String callSing;

	/** The line code. */
	private String lineCode;

	/** The agent code. */
	private String agentCode;

	/** The port origin. */
	private String portOrigin;

	/** The port arrival. */
	private String portArrival;

	/** The last port 1. */
	private String lastPort1;

	/** The last port 2. */
	private String lastPort2;

	/** The last port 3. */
	private String lastPort3;

	/** The last port 1. */
	private String nextport1;

	/** The last port 2. */
	private String nextport2;

	/** The last port 3. */
	private String nextport3;
	
	/** The terminal. */
	private String terminal;

	/** The vessel type. */
	private String vesselType;

	/** The gen desc. */
	private String genDesc;

	/** The master name. */
	private String masterName;

	/** The vessel nation. */
	private String vesselNation;

	/** The igm number. */
	private String igmNumber;

	/** The igm date. */
	private String igmDate;

	/** The arrival date. */
	private String arrivalDate;

	/** The arrival time. */
	private String arrivalTime;
	
	/** The Ata arrival date. */
	private String ataarrivalDate;

	/** The Ata Arrival time. */
	private String ataarrivalTime;

	/** The total bls. */
	private String totalBls;

	/** The light due. */
	private String lightDue;

	/** The gross weight. */
	private String grossWeight;

	/** The net weight. */
	private String netWeight;

	/** The sm bt cargo. */
	private String smBtCargo;

	/** The ship str dect. */
	private String shipStrDect;

	/** The crew effect. */
	private String crewEffect;

	/** The mari time decl. */
	private String mariTimeDecl;

	/** The item number. */
	private String itemNumber;

	/** The cargo nature. */
	private String cargoNature;

	/** The cargo movmnt. */
	private String cargoMovmnt;

	/** The item type. */
	private String itemType;

	/** The cargo movmnt type. */
	private String cargoMovmntType;

	/** The transport mode. */
	private String transportMode;

	/** The road carr code. */
	private String roadCarrCode;

	/** The road TP bond no. */
	private String roadTPBondNo;
	
	/**The custom Terminal Code */
    private String customTerminalCode;

	/** The submit date time. */
	private String submitDateTime;

	/** The weight. */
	private String weight;

	/** The nhava sheva eta. */
	private String nhavaShevaEta;

	/** The final place delivery. */
	private String finalPlaceDelivery;

	/** The packages. */
	private String packages;

	/** The cfs name. */
	private String cfsName;

	/** The mbl no. */
	private String mblNo;

	/** The hbl no. */
	private String hblNo;

	/** The bl date. */
	private String blDate;

	/** The from BL Status */
	private String blStatus;
	
	/** The from item no. */
	private String fromItemNo;

	/** The to item no. */
	private String toItemNo;

	/** The imo code. */
	private String imoCode;

	/**The new vessel */
	private String newVessel;
	
	/**The new vessel */
	private String newVoyage;
	
	/**The serial number */
	private String serialNumber;

	/**The Crew List Declaration*/
    private String crewListDeclaration;
    
    /**The Cargo Declaration*/
    private String cargoDeclaration;
    
    /**the Passenger List*/
    private String passengerList;
	
    /**the DPD Movement*/
    private String dpdMovement;
    
    /**the DPD code*/
    private String dpdCode;
    
    /**the BL Version*/
    private String blVersion;
    
    /**the custom Address1*/
    private String CusAdd1;
    
    /**the custom Address2*/
	private String CusAdd2;
	
	/**the custom Address3*/
	private String CusAdd3;
	
	/**the custom Address4*/
	private String CusAdd4; 
	
	/**The IsValidateBL*/
	private String IsValidateBL;
	
	/**The GrossCargoWeightBLlevel*/
	private String GrossCargoWeightBLlevel;
	
	/**The PackageBLLevel*/
	private String PackageBLLevel;
	
	//SID NEW IGM MANIFEST CR VESSEL VOYAGE SECTION 14/11/2019
	
	/**The PackageBLLevel*/
	private String dep_manif_no;
	
	/**The PackageBLLevel*/
	private String dep_manifest_date;
	
	/**The PackageBLLevel*/
	private String submitter_type;
	
	/**The PackageBLLevel*/
	private String submitter_code;
	
	/**The PackageBLLevel*/
	private String authoriz_rep_code;
	
	/**The PackageBLLevel*/
	private String shipping_line_bond_no_r;
	
	/**The PackageBLLevel*/
	private String mode_of_transport;
	
	/**The PackageBLLevel*/
	private String ship_type;
	
	/**The PackageBLLevel*/
	private String conveyance_reference_no;
	
	/**The PackageBLLevel*/
	private String cargo_description;
	
	/**The PackageBLLevel*/
	private String tol_no_of_trans_equ_manif;
	
	/**The PackageBLLevel*/
	private String brief_cargo_des;
	
	/**The PackageBLLevel*/
	private String expected_date;
	
	
	/**The PackageBLLevel*/
	private String time_of_dept;
	
	
	/**The PackageBLLevel*/
	private String no_of_crew_manif;
	
	/**The PackageBLLevel*/
	private String port_of_call_cod;
	
	/**The PackageBLLevel*/
	private String total_no_of_tran_s_cont_repo_on_ari_dep;
	
	/**The PackageBLLevel*/
	private String message_type;
	
	/**The PackageBLLevel*/
	private String port_of_reporting;
	
	
	/**The PackageBLLevel*/
	private String job_number;
	
	/**The PackageBLLevel*/
	private String job_date;
	
	
	/**The PackageBLLevel*/
	private String reporting_event;
	
	/**The PackageBLLevel*/
	private String manifest_no_csn_no;
	
	/**The PackageBLLevel*/
	private String manifest_date_csn_date;
	
	/**The PackageBLLevel*/
	private String vessel_type_movement;
	
	/**The PackageBLLevel*/
	private String shipping_line_code;
	
	/**The PackageBLLevel*/
	private String authorized_sea_carrier_code;
	
	/**The PackageBLLevel*/
	private String port_of_registry;
	
	/**The PackageBLLevel*/
	private String registry_date;
	
	/**The PackageBLLevel*/
	private String voyage_details_movement;
	
	/**The PackageBLLevel*/
	private String ship_itinerary_sequence;
	
	/**The PackageBLLevel*/
	private String ship_itinerary;
	
	/**The PackageBLLevel*/
	private String port_of_call_name;
	
	/**The PackageBLLevel*/
	private String arrival_departure_details;
	
	/**The PackageBLLevel*/
	private String number_of_crew;
	
	/**The PackageBLLevel*/
	private String total_no_of_transport_equipment_reported_on_arrival_departure;
	
	//END NEW IGM MANIFEST CR VESSEL VOYAGE SECTION 14/11/2019 
	
	//start Bl section 
	
	private String consolidated_indicator;
	
	private String previous_declaration;
	
	private String consolidator_pan;
	
	private String cin_type;
	
	private String mcin;
	
	private String csn_submitted_type;
	
	private String csn_submitted_by;
	
	private String csn_reporting_type;
	
	private String csn_site_id;
	
	private String csn_number;
	
	private String csn_date;
	
	private String previous_mcin;
	
	private String split_indicator;
	
	private String number_of_packages;   // need to discussion  ??? 
	
	private String gros_weight;
	
	private String type_of_package;
	
	private String first_port_of_entry_last_port_of_departure;
	
	private String type_of_cargo;
	
	private String split_indicator_list;
	
	private String port_of_acceptance;
	
	private String port_of_receipt;
	
	private String ucr_type;
	
	private String ucr_code;
	
	private String soc_flag;
	
	private String equipment_load_status;
	
	private String equipment_seal_type;
	
	private String port_of_acceptance_name;
	
	private String port_of_receipt_name;
	
	private String pan_of_notified_party;
	
	private String unit_of_weight;
	
	private String gross_volume;
	
	private String unit_of_volume;
	
	private String cargo_item_sequence_no;
	
	private String cargo_item_description;
	
	private String total_number_of_packages;
	
	private String number_of_packages_hidden;
	
	private String type_of_packages_hidden;
	
	private String mc_item_details;
	
	private String container_weight;
	
	private String port_of_call_sequence_number;
	
	private String port_of_call_coded;
	
	private String next_port_of_call_coded;
	
	private String mc_location_customs;
	
	private String uno_code;
	
	private String imdg_code; 
	
	private String port_of_destination;
	
	private String tshipmentFlag;
	
	private String terminal_op_cod;
	
	private String actualPod;
	
	private String igmDestinationPort;
	
	private String igmport;
	
	private String DestinationPortFinal;
	
	
	//end bl section 
	
    public String getUno_code() {
		return uno_code;
	}

	public void setUno_code(String uno_code) {
		this.uno_code = uno_code;
	}

	public String getImdg_code() {
		return imdg_code;
	}

	public void setImdg_code(String imdg_code) {
		this.imdg_code = imdg_code;
	}


	public String getPort_of_destination() {
		return port_of_destination;
	}

	public void setPort_of_destination(String port_of_destination) {
		this.port_of_destination = port_of_destination;
	}

	public String getTshipmentFlag() {
		return tshipmentFlag;
	}

	public void setTshipmentFlag(String tshipmentFlag) {
		this.tshipmentFlag = tshipmentFlag;
	}

	public String getTerminal_op_cod() {
		return terminal_op_cod;
	}

	public void setTerminal_op_cod(String terminal_op_cod) {
		this.terminal_op_cod = terminal_op_cod;
	}

	public String getActualPod() {
		return actualPod;
	}

	public void setActualPod(String actualPod) {
		this.actualPod = actualPod;
	}

	
	public String getIgmDestinationPort() {
		return igmDestinationPort;
	}

	public void setIgmDestinationPort(String igmDestinationPort) {
		this.igmDestinationPort = igmDestinationPort;
	}

	public String getIgmport() {
		return igmport;
	}

	public void setIgmport(String igmport) {
		this.igmport = igmport;
	}

	
	public String getDestinationPortFinal() {
		return DestinationPortFinal;
	}

	public void setDestinationPortFinal(String destinationPortFinal) {
		DestinationPortFinal = destinationPortFinal;
	}

	/**
	 * Gets the New Vessel.
	 *
	 * @return the New Vessel
	 */

	public String getNewVessel() {
		return newVessel;
	}

	/**
	 * Sets the New Vessel.
	 *
	 * @param newVessel the new New Vessel
	 */
	public void setNewVessel(String newVessel) {
		this.newVessel = newVessel;
	}
    
    /**
	 * Gets the New Voyage.
	 *
	 * @return the New Voyage
	 */

	public String getNewVoyage() {
		return newVoyage;
	}

	/**
	 * Sets the New Voyage.
	 *
	 * @param newVoyage the new New Voyage
	 */
	public void setNewVoyage(String newVoyage) {
		this.newVoyage = newVoyage;
	}

	/**
	 * Gets the Crew List Declaration.
	 *
	 * @return the Crew List Declaration
	 */

	public String getCrewListDeclaration() {
		return crewListDeclaration;
	}

	/**
	 * Sets the Crew List Declaration.
	 *
	 * @param crewListDeclaration the new Crew List Declaration
	 */
	public void setCrewListDeclaration(String crewListDeclaration) {
		this.crewListDeclaration = crewListDeclaration;
	}
	
	/**
	 * Gets the Cargo Declaration.
	 *
	 * @return the Cargo Declaration
	 */
	public String getCargoDeclaration() {
		return cargoDeclaration;
	}

	/**
	 * Sets the Cargo Declaration.
	 *
	 * @param cargoDeclaration the new Cargo Declaration
	 */
	public void setCargoDeclaration(String cargoDeclaration) {
		this.cargoDeclaration = cargoDeclaration;
	}

	/**
	 * Gets the Passenger List.
	 *
	 * @return the Passenger List
	 */
	public String getPassengerList() {
		return passengerList;
	}

	/**
	 * Sets the Passenger List.
	 *
	 * @param passengerList the new Passenger List
	 */
	public void setPassengerList(String passengerList) {
		this.passengerList = passengerList;
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
	 * Gets the road TP bond no.
	 *
	 * @return the road TP bond no
	 */
	public String getRoadTPBondNo() {
		return roadTPBondNo;
	}

	/**
	 * Sets the road TP bond no.
	 *
	 * @param roadTPBondNo the new road TP bond no
	 */
	public void setRoadTPBondNo(String roadTPBondNo) {
		this.roadTPBondNo = roadTPBondNo;
	}

	/**
	 * Gets the from item no.
	 *
	 * @return the from item no
	 */
	public String getFromItemNo() {
		return fromItemNo;
	}

	/**
	 * Sets the from item no.
	 *
	 * @param fromItemNo the new from item no
	 */
	public void setFromItemNo(String fromItemNo) {
		this.fromItemNo = fromItemNo;
	}

	/**
	 * Gets the to item no.
	 *
	 * @return the to item no
	 */
	public String getToItemNo() {
		return toItemNo;
	}

	/**
	 * Sets the to item no.
	 *
	 * @param toItemNo the new to item no
	 */
	public void setToItemNo(String toItemNo) {
		this.toItemNo = toItemNo;
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
	 * Gets the service.
	 *
	 * @return the service
	 */
	public String getService() {
		return service;
	}

	/**
	 * Sets the service.
	 *
	 * @param service the new service
	 */
	public void setService(String service) {
		this.service = service;
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

	public String getDel() {
		return del;
	}

	public void setDel(String del) {
		this.del = del;
	}

	public String getDepot() {
		return depot;
	}

	public void setDepot(String depot) {
		this.depot = depot;
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
	 * Gets the Custom Terminal Code.
	 *
	 * @return the CustomTerminalCode
	 */
	public String getCustomTerminalCode() {
		return customTerminalCode;
	}
	
	/**
	 * Sets the Custom Terminal Code.
	 *
	 * @param pod the new CustomTerminalCode
	 */
	public void setCustomTerminalCode(String customTerminalCode) {
		this.customTerminalCode = customTerminalCode;
	}
	
	/**
	 * Gets the weight.
	 *
	 * @return the weight
	 */
	/*
	 * public String getRoadTPBondNo() { return roadTPBondNo; }
	 * 
	 *//**
		 * Sets the road TP bond no.
		 *
		 * @param roadTPBondNo the new road TP bond no
		 *//*
			 * public void setRoadTPBondNo(String roadTPBondNo) { this.roadTPBondNo =
			 * roadTPBondNo; }
			 */

	/**
	 * Gets the weight.
	 *
	 * @return the weight
	 */
	public String getWeight() {
		return weight;
	}

	/**
	 * Sets the weight.
	 *
	 * @param weight the new weight
	 */
	public void setWeight(String weight) {
		this.weight = weight;
	}

	/**
	 * Gets the bl date.
	 *
	 * @return the bl date
	 */
	public String getBlDate() {
		return blDate;
	}

	/**
	 * Sets the bl date.
	 *
	 * @param blDate the new bl date
	 */
	public void setBlDate(String blDate) {
		String blD="";
		if(blDate!=null && !blDate.equals(""))
		{
			blD = blDate.substring(6, 8)+"/"+blDate.substring(4, 6)+"/"+blDate.substring(0, 4);
		}
		this.blDate=blD;
	}
	
	/**
	 * Gets the bl Status.
	 *
	 * @return the bl Status
	 */
	public String getBlStatus() {
		return blStatus;
	}
	
	/**
	 * Sets the bl Status.
	 *
	 * @param blDate the new bl Status
	 */
	public void setBlStatus(String blStatus) {
		this.blStatus = blStatus;
	}


	/**
	 * Gets the code code.
	 *
	 * @return the code code
	 */
	public String getCodeCode() {
		return codeCode;
	}

	/**
	 * Sets the code code.
	 *
	 * @param codeCode the new code code
	 */
	public void setCodeCode(String codeCode) {
		this.codeCode = codeCode;
	}

	/**
	 * Gets the call sing.
	 *
	 * @return the call sing
	 */
	public String getCallSing() {
		return callSing;
	}

	/**
	 * Sets the call sing.
	 *
	 * @param callSing the new call sing
	 */
	public void setCallSing(String callSing) {
		this.callSing = callSing;
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
	 * Gets the port arrival.
	 *
	 * @return the port arrival
	 */
	public String getPortArrival() {
		return portArrival;
	}

	/**
	 * Sets the port arrival.
	 *
	 * @param portArrival the new port arrival
	 */
	public void setPortArrival(String portArrival) {
		this.portArrival = portArrival;
	}

	/**
	 * Gets the last port 1.
	 *
	 * @return the last port 1
	 */
	public String getLastPort1() {
		return lastPort1;
	}

	/**
	 * Sets the last port 1.
	 *
	 * @param lastPort1 the new last port 1
	 */
	public void setLastPort1(String lastPort1) {
		this.lastPort1 = lastPort1;
	}

	/**
	 * Gets the last port 2.
	 *
	 * @return the last port 2
	 */
	public String getLastPort2() {
		return lastPort2;
	}

	/**
	 * Sets the last port 2.
	 *
	 * @param lastPort2 the new last port 2
	 */
	public void setLastPort2(String lastPort2) {
		this.lastPort2 = lastPort2;
	}

	/**
	 * Gets the last port 3.
	 *
	 * @return the last port 3
	 */
	public String getLastPort3() {
		return lastPort3;
	}

	/**
	 * Sets the last port 3.
	 *
	 * @param lastPort3 the new last port 3
	 */
	public void setLastPort3(String lastPort3) {
		this.lastPort3 = lastPort3;
	}

	/**
	 * Gets the terminal.
	 *
	 * @return the terminal
	 */
	public String getTerminal() {
		return terminal;
	}

	/**
	 * Sets the terminal.
	 *
	 * @param terminal the new terminal
	 */
	public void setTerminal(String terminal) {
		this.terminal = terminal;
	}

	/**
	 * Gets the vessel type.
	 *
	 * @return the vessel type
	 */
	public String getVesselType() {
		return vesselType;
	}

	/**
	 * Sets the vessel type.
	 *
	 * @param vesselType the new vessel type
	 */
	public void setVesselType(String vesselType) {
		this.vesselType = vesselType;
	}

	/**
	 * Gets the gen desc.
	 *
	 * @return the gen desc
	 */
	public String getGenDesc() {
		return genDesc;
	}

	/**
	 * Sets the gen desc.
	 *
	 * @param genDesc the new gen desc
	 */
	public void setGenDesc(String genDesc) {
		this.genDesc = genDesc;
	}

	/**
	 * Gets the master name.
	 *
	 * @return the master name
	 */
	public String getMasterName() {
		return masterName;
	}

	/**
	 * Sets the master name.
	 *
	 * @param masterName the new master name
	 */
	public void setMasterName(String masterName) {
		this.masterName = masterName;
	}

	/**
	 * Gets the vessel nation.
	 *
	 * @return the vessel nation
	 */
	public String getVesselNation() {
		return vesselNation;
	}

	/**
	 * Sets the vessel nation.
	 *
	 * @param vesselNation the new vessel nation
	 */
	public void setVesselNation(String vesselNation) {
		this.vesselNation = vesselNation;
	}

	/**
	 * Gets the igm number.
	 *
	 * @return the igm number
	 */
	public String getIgmNumber() {
		return igmNumber;
	}

	/**
	 * Sets the igm number.
	 *
	 * @param igmNumber the new igm number
	 */
	public void setIgmNumber(String igmNumber) {
		this.igmNumber = igmNumber;
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
	 * Gets the arrival date.
	 *
	 * @return the arrival date
	 */
	public String getArrivalDate() {
		return arrivalDate;
	}

	/**
	 * Sets the arrival date.
	 *
	 * @param arrivalDate the new arrival date
	 */
	public void setArrivalDate(String arrivalDate) {
		String arDate="";
		if(arrivalDate!=null && !arrivalDate.equals(""))
		{
		arDate=	arrivalDate.substring(6, 8)+"/"+arrivalDate.substring(4, 6)+"/"+arrivalDate.substring(0, 4);
	    }
			this.arrivalDate=arDate;
	}		

	/**
	 * Gets the arrival time.
	 *
	 * @return the arrival time
	 */
	public String getArrivalTime() {
		return arrivalTime;
	}
	
	/**
	 * Sets the arrival time.
	 *
	 * @param arrivalTime the new arrival time
	 */
	public void setArrivalTime(String arrivalTime) {
		String hrsMin = "";
		if (arrivalTime != null) {
			if (arrivalTime.length() == 3) {
				hrsMin = arrivalTime.substring(0, 1) + ":" + arrivalTime.substring(1);
			} else if (arrivalTime.length() == 4) {
				hrsMin = arrivalTime.substring(0, 2) + ":" + arrivalTime.substring(2);
			} else {
				hrsMin = arrivalTime + ":00";
			}
		}
		this.arrivalTime = hrsMin;
	}

	/**
	 * Gets the Ata arrival Date.
	 *
	 * @return the Ata arrival date
	 */
	public String getAtaarrivalDate() {
		return ataarrivalDate;
	}

	/**
	 * Sets the Ata arrival Date.
	 *
	 * @param AtaarrivalDate the new ata arrival date
	 */
	public void setAtaarrivalDate(String ataarrivalDate) {
		this.ataarrivalDate = ataarrivalDate;
	}

	/**
	 * Gets the Ata arrival time.
	 *
	 * @return the Ata arrival time
	 */
	public String getAtaarrivalTime() {
		return ataarrivalTime;
	}

	/**
	 * Sets the Ata arrival time.
	 *
	 * @param Ata arrivalTime the new ata arrival time
	 */
	public void setAtaarrivalTime(String ataarrivalTime) {
		this.ataarrivalTime = ataarrivalTime;
	}

	/**
	 * Gets the total bls.
	 *
	 * @return the total bls
	 */
	public String getTotalBls() {
		return totalBls;
	}

	/**
	 * Sets the total bls.
	 *
	 * @param totalBls the new total bls
	 */
	public void setTotalBls(String totalBls) {
		this.totalBls = totalBls;
	}

	/**
	 * Gets the light due.
	 *
	 * @return the light due
	 */
	public String getLightDue() {
		return lightDue;
	}

	/**
	 * Sets the light due.
	 *
	 * @param lightDue the new light due
	 */
	public void setLightDue(String lightDue) {
		this.lightDue = lightDue;
	}

	/**
	 * Gets the gross weight.
	 *
	 * @return the gross weight
	 */
	public String getGrossWeight() {
		return grossWeight;
	}

	/**
	 * Sets the gross weight.
	 *
	 * @param grossWeight the new gross weight
	 */
	public void setGrossWeight(String grossWeight) {
		this.grossWeight = grossWeight;
	}

	/**
	 * Gets the net weight.
	 *
	 * @return the net weight
	 */
	public String getNetWeight() {
		return netWeight;
	}

	/**
	 * Sets the net weight.
	 *
	 * @param netWeight the new net weight
	 */
	public void setNetWeight(String netWeight) {
		this.netWeight = netWeight;
	}

	/**
	 * Gets the sm bt cargo.
	 *
	 * @return the sm bt cargo
	 */
	public String getSmBtCargo() {
		return smBtCargo;
	}

	/**
	 * Sets the sm bt cargo.
	 *
	 * @param smBtCargo the new sm bt cargo
	 */
	public void setSmBtCargo(String smBtCargo) {
		this.smBtCargo = smBtCargo;
	}

	/**
	 * Gets the ship str dect.
	 *
	 * @return the ship str dect
	 */
	public String getShipStrDect() {
		return shipStrDect;
	}

	/**
	 * Sets the ship str dect.
	 *
	 * @param shipStrDect the new ship str dect
	 */
	public void setShipStrDect(String shipStrDect) {
		this.shipStrDect = shipStrDect;
	}

	/**
	 * Gets the crew effect.
	 *
	 * @return the crew effect
	 */
	public String getCrewEffect() {
		return crewEffect;
	}

	/**
	 * Sets the crew effect.
	 *
	 * @param crewEffect the new crew effect
	 */
	public void setCrewEffect(String crewEffect) {
		this.crewEffect = crewEffect;
	}

	/**
	 * Gets the mari time decl.
	 *
	 * @return the mari time decl
	 */
	public String getMariTimeDecl() {
		return mariTimeDecl;
	}

	/**
	 * Sets the mari time decl.
	 *
	 * @param mariTimeDecl the new mari time decl
	 */
	public void setMariTimeDecl(String mariTimeDecl) {
		this.mariTimeDecl = mariTimeDecl;
	}

	/**
	 * Gets the item number.
	 *
	 * @return the item number
	 */
	public String getItemNumber() {
		return itemNumber;
	}

	/**
	 * Sets the item number.
	 *
	 * @param itemNumber the new item number
	 */
	public void setItemNumber(String itemNumber) {
		this.itemNumber = itemNumber;
	}

	/**
	 * Gets the cargo nature.
	 *
	 * @return the cargo nature
	 */
	public String getCargoNature() {
		return cargoNature;
	}

	/**
	 * Sets the cargo nature.
	 *
	 * @param cargoNature the new cargo nature
	 */
	public void setCargoNature(String cargoNature) {
		this.cargoNature = cargoNature;
	}

	/**
	 * Gets the cargo movmnt.
	 *
	 * @return the cargo movmnt
	 */
	public String getCargoMovmnt() {
		return cargoMovmnt;
	}

	/**
	 * Sets the cargo movmnt.
	 *
	 * @param cargoMovmnt the new cargo movmnt
	 */
	public void setCargoMovmnt(String cargoMovmnt) {
		this.cargoMovmnt = cargoMovmnt;
	}

	/**
	 * Gets the item type.
	 *
	 * @return the item type
	 */
	public String getItemType() {
		return itemType;
	}

	/**
	 * Sets the item type.
	 *
	 * @param itemType the new item type
	 */
	public void setItemType(String itemType) {
		this.itemType = itemType;
	}

	/**
	 * Gets the cargo movmnt type.
	 *
	 * @return the cargo movmnt type
	 */
	public String getCargoMovmntType() {
		return cargoMovmntType;
	}

	/**
	 * Sets the cargo movmnt type.
	 *
	 * @param cargoMovmntType the new cargo movmnt type
	 */
	public void setCargoMovmntType(String cargoMovmntType) {
		this.cargoMovmntType = cargoMovmntType;
	}

	/**
	 * Gets the transport mode.
	 *
	 * @return the transport mode
	 */
	public String getTransportMode() {
		return transportMode;
	}

	/**
	 * Sets the transport mode.
	 *
	 * @param transportMode the new transport mode
	 */
	public void setTransportMode(String transportMode) {
		this.transportMode = transportMode;
	}

	/**
	 * Gets the road carr code.
	 *
	 * @return the road carr code
	 */
	public String getRoadCarrCode() {
		return roadCarrCode;
	}

	/**
	 * Sets the road carr code.
	 *
	 * @param roadCarrCode the new road carr code
	 */
	public void setRoadCarrCode(String roadCarrCode) {
		this.roadCarrCode = roadCarrCode;
	}

	/**
	 * Gets the road tp bond no.
	 *
	 * @return the road tp bond no
	 */
	public String getRoadTpBondNo() {
		return roadTPBondNo;
	}

	/**
	 * Sets the road tp bond no.
	 *
	 * @param roadTpBondNo the new road tp bond no
	 */
	public void setRoadTpBondNo(String roadTpBondNo) {
		this.roadTPBondNo = roadTpBondNo;
	}

	/**
	 * Gets the submit date time.
	 *
	 * @return the submit date time
	 */
	public String getSubmitDateTime() {
		return submitDateTime;
	}

	/**
	 * Sets the submit date time.
	 *
	 * @param submitDateTime the new submit date time
	 */
	public void setSubmitDateTime(String submitDateTime) {
		this.submitDateTime = submitDateTime;
	}

	/**
	 * Gets the weigh.
	 *
	 * @return the weigh
	 */
	public String getWeigh() {
		return weight;
	}

	/**
	 * Sets the weigh.
	 *
	 * @param weigh the new weigh
	 */
	public void setWeigh(String weigh) {
		this.weight = weigh;
	}

	/**
	 * Gets the nhava sheva eta.
	 *
	 * @return the nhava sheva eta
	 */
	public String getNhavaShevaEta() {
		return nhavaShevaEta;
	}

	/**
	 * Sets the nhava sheva eta.
	 *
	 * @param nhavaShevaEta the new nhava sheva eta
	 */
	public void setNhavaShevaEta(String nhavaShevaEta) {
		this.nhavaShevaEta = nhavaShevaEta;
	}

	/**
	 * Gets the final place delivery.
	 *
	 * @return the final place delivery
	 */
	public String getFinalPlaceDelivery() {
		return finalPlaceDelivery;
	}

	/**
	 * Sets the final place delivery.
	 *
	 * @param finalPlaceDelivery the new final place delivery
	 */
	public void setFinalPlaceDelivery(String finalPlaceDelivery) {
		this.finalPlaceDelivery = finalPlaceDelivery;
	}

	/**
	 * Gets the packages.
	 *
	 * @return the packages
	 */
	public String getPackages() {
		return packages;
	}

	/**
	 * Sets the packages.
	 *
	 * @param packages the new packages
	 */
	public void setPackages(String packages) {
		this.packages = packages;
	}

	/**
	 * Gets the cfs name.
	 *
	 * @return the cfs name
	 */
	public String getCfsName() {
		return cfsName;
	}

	/**
	 * Sets the cfs name.
	 *
	 * @param cfsName the new cfs name
	 */
	public void setCfsName(String cfsName) {
		this.cfsName = cfsName;
	}

	/**
	 * Gets the mbl no.
	 *
	 * @return the mbl no
	 */
	public String getMblNo() {
		return mblNo;
	}

	/**
	 * Sets the mbl no.
	 *
	 * @param mblNo the new mbl no
	 */
	public void setMblNo(String mblNo) {
		this.mblNo = mblNo;
	}

	/**
	 * Gets the hbl no.
	 *
	 * @return the hbl no
	 */
	public String getHblNo() {
		return hblNo;
	}

	/**
	 * Sets the hbl no.
	 *
	 * @param hblNo the new hbl no
	 */
	public void setHblNo(String hblNo) {
		this.hblNo = hblNo;
	}

	
	/**
	 * Gets the dpd Movement.
	 *
	 * @return the dpd Movement
	 */
	public String getDpdMovement() {
		return dpdMovement;
	}

	/**
	 * Sets the dpd Movement.
	 *
	 * @param dpdMovement the new dpd Movement
	 */
	public void setDpdMovement(String dpdMovement) {
		this.dpdMovement = dpdMovement;
	}

	/**
	 * Gets the DPD code.
	 *
	 * @return the DPD code
	 */
	public String getDpdCode() {
		return dpdCode;
	}

	
	/**
	 * Sets the DPD code.
	 *
	 * @param DPDcode the new DPD code
	 */
	public void setDpdCode(String dpdCode) {
		this.dpdCode = dpdCode;
	}

	/**
	 * Gets the bl Version.
	 *
	 * @return the bl Version
	 */
	public String getBlVersion() {
		return blVersion;
	}

	/**
	 * Sets the bl Version.
	 *
	 * @param blVersion the new bl Version
	 */
	public void setBlVersion(String blVersion) {
		this.blVersion = blVersion;
	}

	
	/**
	 * Gets the Consignee.
	 *
	 * @return the Consignee
	 */
	public List<Consignee> getConsignee() {
		return consignee;
	}

	/**
	 * Sets the consignee.
	 *
	 * @param consignee the new consignee.
	 */
	public void setConsignee(List<Consignee> consignee) {
		this.consignee = consignee;
	}

	/**
	 * Gets the nortify Party.
	 *
	 * @return the nortify Party.
	 */
	public List<NotifyParty> getNotifyParty() {
		return notifyParty;
	}

	/**
	 * Sets the nortify Party.
	 *
	 * @param nortifyParty the new nortify Party.
	 */
	public void setNotifyParty(List<NotifyParty> notifyParty) {
		this.notifyParty = notifyParty;
	}

	/**
	 * Gets the marks Number.
	 *
	 * @return the marks Number.
	 */
	public List<MarksNumber> getMarksNumber() {
		return marksNumber;
	}

	

	/**
	 * Sets the marks Number.
	 *
	 * @param marksNumber the new marks Number.
	 */
	public void setMarksNumber(List<MarksNumber> marksNumber) {
		this.marksNumber = marksNumber;
	}

	/**
	 * Gets the Container Detailes.
	 *
	 * @return the Container Detailes.
	 */
	public List<ContainerDetails> getContainerDetailes() {
		return containerDetailes;
	}

	/**
	 * Sets the Container Detailes.
	 *
	 * @param containerDetailes the new Container Detailes.
	 */
	public void setContainerDetailes(List<ContainerDetails> containerDetailes) {
		this.containerDetailes = containerDetailes;
	}
	
	
	public String getCusAdd1() {
		return CusAdd1;
	}

	public void setCusAdd1(String cusAdd1) {
		CusAdd1 = cusAdd1;
	}

	public String getCusAdd2() {
		return CusAdd2;
	}

	public void setCusAdd2(String cusAdd2) {
		CusAdd2 = cusAdd2;
	}

	public String getCusAdd3() {
		return CusAdd3;
	}

	public void setCusAdd3(String cusAdd3) {
		CusAdd3 = cusAdd3;
	}

	public String getCusAdd4() {
		return CusAdd4;
	}

	public void setCusAdd4(String cusAdd4) {
		CusAdd4 = cusAdd4;
	}
	
	
	public String getIsValidateBL() {
		return IsValidateBL;
	}

	public void setIsValidateBL(String isValidateBL) {
		IsValidateBL = isValidateBL;
	}
	
	public String getGrossCargoWeightBLlevel() {
		return GrossCargoWeightBLlevel;
	}

	public void setGrossCargoWeightBLlevel(String grossCargoWeightBLlevel) {
		GrossCargoWeightBLlevel = grossCargoWeightBLlevel;
	}

	public String getPackageBLLevel() {
		return PackageBLLevel;
	}

	public void setPackageBLLevel(String packageBLLevel) {
		PackageBLLevel = packageBLLevel;
	}

	
	
	public String getDep_manif_no() {
		return dep_manif_no;
	}

	public void setDep_manif_no(String dep_manif_no) {
		this.dep_manif_no = dep_manif_no;
	}

	public String getDep_manifest_date() {
		return dep_manifest_date;
	}

	public void setDep_manifest_date(String dep_manifest_date) {
		this.dep_manifest_date = dep_manifest_date;
	}

	public String getSubmitter_type() {
		return submitter_type;
	}

	public void setSubmitter_type(String submitter_type) {
		this.submitter_type = submitter_type;
	}

	public String getSubmitter_code() {
		return submitter_code;
	}

	public void setSubmitter_code(String submitter_code) {
		this.submitter_code = submitter_code;
	}

	public String getAuthoriz_rep_code() {
		return authoriz_rep_code;
	}

	public void setAuthoriz_rep_code(String authoriz_rep_code) {
		this.authoriz_rep_code = authoriz_rep_code;
	}

	public String getShipping_line_bond_no_r() {
		return shipping_line_bond_no_r;
	}

	public void setShipping_line_bond_no_r(String shipping_line_bond_no_r) {
		this.shipping_line_bond_no_r = shipping_line_bond_no_r;
	}

	public String getMode_of_transport() {
		return mode_of_transport;
	}

	public void setMode_of_transport(String mode_of_transport) {
		this.mode_of_transport = mode_of_transport;
	}

	public String getShip_type() {
		return ship_type;
	}

	public void setShip_type(String ship_type) {
		this.ship_type = ship_type;
	}

	public String getConveyance_reference_no() {
		return conveyance_reference_no;
	}

	public void setConveyance_reference_no(String conveyance_reference_no) {
		this.conveyance_reference_no = conveyance_reference_no;
	}

	public String getTol_no_of_trans_equ_manif() {
		return tol_no_of_trans_equ_manif;
	}

	public void setTol_no_of_trans_equ_manif(String tol_no_of_trans_equ_manif) {
		this.tol_no_of_trans_equ_manif = tol_no_of_trans_equ_manif;
	}

	public String getBrief_cargo_des() {
		return brief_cargo_des;
	}

	public void setBrief_cargo_des(String brief_cargo_des) {
		this.brief_cargo_des = brief_cargo_des;
	}

	public String getExpected_date() {
		return expected_date;
	}

	public void setExpected_date(String expected_date) {
		this.expected_date = expected_date;
	}

	public String getTime_of_dept() {
		return time_of_dept;
	}

	public void setTime_of_dept(String time_of_dept) {
		this.time_of_dept = time_of_dept;
	}

	public String getNo_of_crew_manif() {
		return no_of_crew_manif;
	}

	public void setNo_of_crew_manif(String no_of_crew_manif) {
		this.no_of_crew_manif = no_of_crew_manif;
	}

	public String getPort_of_call_cod() {
		return port_of_call_cod;
	}

	public void setPort_of_call_cod(String port_of_call_cod) {
		this.port_of_call_cod = port_of_call_cod;
	}

	public String getTotal_no_of_tran_s_cont_repo_on_ari_dep() {
		return total_no_of_tran_s_cont_repo_on_ari_dep;
	}

	public void setTotal_no_of_tran_s_cont_repo_on_ari_dep(String total_no_of_tran_s_cont_repo_on_ari_dep) {
		this.total_no_of_tran_s_cont_repo_on_ari_dep = total_no_of_tran_s_cont_repo_on_ari_dep;
	}

	public String getMessage_type() {
		return message_type;
	}

	public void setMessage_type(String message_type) {
		this.message_type = message_type;
	}

	public String getPort_of_reporting() {
		return port_of_reporting;
	}

	public void setPort_of_reporting(String port_of_reporting) {
		this.port_of_reporting = port_of_reporting;
	}

	public String getJob_number() {
		return job_number;
	}

	public void setJob_number(String job_number) {
		this.job_number = job_number;
	}

	public String getJob_date() {
		return job_date;
	}

	public void setJob_date(String job_date) {
		this.job_date = job_date;
	}

	public String getReporting_event() {
		return reporting_event;
	}

	public void setReporting_event(String reporting_event) {
		this.reporting_event = reporting_event;
	}

	public String getManifest_no_csn_no() {
		return manifest_no_csn_no;
	}

	public void setManifest_no_csn_no(String manifest_no_csn_no) {
		this.manifest_no_csn_no = manifest_no_csn_no;
	}

	public String getManifest_date_csn_date() {
		return manifest_date_csn_date;
	}

	public void setManifest_date_csn_date(String manifest_date_csn_date) {
		this.manifest_date_csn_date = manifest_date_csn_date;
	}

	public String getVessel_type_movement() {
		return vessel_type_movement;
	}

	public void setVessel_type_movement(String vessel_type_movement) {
		this.vessel_type_movement = vessel_type_movement;
	}

	public String getShipping_line_code() {
		return shipping_line_code;
	}

	public void setShipping_line_code(String shipping_line_code) {
		this.shipping_line_code = shipping_line_code;
	}

	public String getAuthorized_sea_carrier_code() {
		return authorized_sea_carrier_code;
	}

	public void setAuthorized_sea_carrier_code(String authorized_sea_carrier_code) {
		this.authorized_sea_carrier_code = authorized_sea_carrier_code;
	}

	public String getPort_of_registry() {
		return port_of_registry;
	}

	public void setPort_of_registry(String port_of_registry) {
		this.port_of_registry = port_of_registry;
	}

	public String getRegistry_date() {
		return registry_date;
	}

	public void setRegistry_date(String registry_date) {
		this.registry_date = registry_date;
	}

	public String getVoyage_details_movement() {
		return voyage_details_movement;
	}

	public void setVoyage_details_movement(String voyage_details_movement) {
		this.voyage_details_movement = voyage_details_movement;
	}

	public String getShip_itinerary_sequence() {
		return ship_itinerary_sequence;
	}

	public void setShip_itinerary_sequence(String ship_itinerary_sequence) {
		this.ship_itinerary_sequence = ship_itinerary_sequence;
	}

	public String getShip_itinerary() {
		return ship_itinerary;
	}

	public void setShip_itinerary(String ship_itinerary) {
		this.ship_itinerary = ship_itinerary;
	}

	public String getPort_of_call_name() {
		return port_of_call_name;
	}

	public void setPort_of_call_name(String port_of_call_name) {
		this.port_of_call_name = port_of_call_name;
	}

	public String getArrival_departure_details() {
		return arrival_departure_details;
	}

	public void setArrival_departure_details(String arrival_departure_details) {
		this.arrival_departure_details = arrival_departure_details;
	}

	public String getNumber_of_crew() {
		return number_of_crew;
	}

	public void setNumber_of_crew(String number_of_crew) {
		this.number_of_crew = number_of_crew;
	}

	public String getTotal_no_of_transport_equipment_reported_on_arrival_departure() {
		return total_no_of_transport_equipment_reported_on_arrival_departure;
	}

	public void setTotal_no_of_transport_equipment_reported_on_arrival_departure(
			String total_no_of_transport_equipment_reported_on_arrival_departure) {
		this.total_no_of_transport_equipment_reported_on_arrival_departure = total_no_of_transport_equipment_reported_on_arrival_departure;
	}
	
	public String getCargo_description() {
		return cargo_description;
	}

	public void setCargo_description(String cargo_description) {
		this.cargo_description = cargo_description;
	}
	
	public String getConsolidated_indicator() {
		return consolidated_indicator;
	}

	public void setConsolidated_indicator(String consolidated_indicator) {
		this.consolidated_indicator = consolidated_indicator;
	}

	public String getPrevious_declaration() {
		return previous_declaration;
	}

	public void setPrevious_declaration(String previous_declaration) {
		this.previous_declaration = previous_declaration;
	}

	public String getConsolidator_pan() {
		return consolidator_pan;
	}

	public void setConsolidator_pan(String consolidator_pan) {
		this.consolidator_pan = consolidator_pan;
	}

	public String getCin_type() {
		return cin_type;
	}

	public void setCin_type(String cin_type) {
		this.cin_type = cin_type;
	}

	public String getMcin() {
		return mcin;
	}

	public void setMcin(String mcin) {
		this.mcin = mcin;
	}

	public String getCsn_submitted_type() {
		return csn_submitted_type;
	}

	public void setCsn_submitted_type(String csn_submitted_type) {
		this.csn_submitted_type = csn_submitted_type;
	}

	public String getCsn_submitted_by() {
		return csn_submitted_by;
	}

	public void setCsn_submitted_by(String csn_submitted_by) {
		this.csn_submitted_by = csn_submitted_by;
	}

	public String getCsn_site_id() {
		return csn_site_id;
	}

	public void setCsn_site_id(String csn_site_id) {
		this.csn_site_id = csn_site_id;
	}

	public String getCsn_number() {
		return csn_number;
	}

	public void setCsn_number(String csn_number) {
		this.csn_number = csn_number;
	}

	public String getCsn_date() {
		return csn_date;
	}

	public void setCsn_date(String csn_date) {
		this.csn_date = csn_date;
	}

	public String getSplit_indicator() {
		return split_indicator;
	}

	public void setSplit_indicator(String split_indicator) {
		this.split_indicator = split_indicator;
	}

	public String getNumber_of_packages() {
		return number_of_packages;
	}

	public void setNumber_of_packages(String number_of_packages) {
		this.number_of_packages = number_of_packages;
	}
	
	public String getGros_weight() {
		return gros_weight;
	}

	public void setGros_weight(String gros_weight) {
		this.gros_weight = gros_weight;
	}

	public String getType_of_package() {
		return type_of_package;
	}

	public void setType_of_package(String type_of_package) {
		this.type_of_package = type_of_package;
	}

	public String getFirst_port_of_entry_last_port_of_departure() {
		return first_port_of_entry_last_port_of_departure;
	}

	public void setFirst_port_of_entry_last_port_of_departure(String first_port_of_entry_last_port_of_departure) {
		this.first_port_of_entry_last_port_of_departure = first_port_of_entry_last_port_of_departure;
	}

	

	public String getPort_of_acceptance() {
		return port_of_acceptance;
	}

	public void setPort_of_acceptance(String port_of_acceptance) {
		this.port_of_acceptance = port_of_acceptance;
	}

	public String getUcr_type() {
		return ucr_type;
	}

	public void setUcr_type(String ucr_type) {
		this.ucr_type = ucr_type;
	}

	

	public String getUcr_code() {
		return ucr_code;
	}

	public void setUcr_code(String ucr_code) {
		this.ucr_code = ucr_code;
	}

	/*public String getUcr_type_of_packages() {
		return ucr_type_of_packages;
	}

	public void setUcr_type_of_packages(String ucr_type_of_packages) {
		this.ucr_type_of_packages = ucr_type_of_packages;
	}
*/
	public String getEquipment_load_status() {
		return equipment_load_status;
	}

	public void setEquipment_load_status(String equipment_load_status) {
		this.equipment_load_status = equipment_load_status;
	}

	/*public String getEquipment_size() {
		return equipment_size;
	}

	public void setEquipment_size(String equipment_size) {
		this.equipment_size = equipment_size;
	}
*/
	public String getEquipment_seal_type() {
		return equipment_seal_type;
	}

	public void setEquipment_seal_type(String equipment_seal_type) {
		this.equipment_seal_type = equipment_seal_type;
	}

	

	public String getSoc_flag() {
		return soc_flag;
	}

	public void setSoc_flag(String soc_flag) {
		this.soc_flag = soc_flag;
	}

	/*public String getContainer_agent_code() {
		return container_agent_code;
	}*/

	/*public void setContainer_agent_code(String container_agent_code) {
		this.container_agent_code = container_agent_code;
	}

	public String getContainer_weight() {
		return container_weight;
	}*/

	/*public void setContainer_weight(String container_weight) {
		this.container_weight = container_weight;
	}*/

	public String getTotal_number_of_packages() {
		return total_number_of_packages;
	}

	/*public void setTotal_number_of_packages(String total_number_of_packages) {
		this.total_number_of_packages = total_number_of_packages;
	}

	public String getPort_of_acceptance_name() {
		return port_of_acceptance_name;
	}*/

	public void setPort_of_acceptance_name(String port_of_acceptance_name) {
		this.port_of_acceptance_name = port_of_acceptance_name;
	}

	
	public String getMc_item_details() {
		return mc_item_details;
	}

	public void setMc_item_details(String mc_item_details) {
		this.mc_item_details = mc_item_details;
	}

	public String getCargo_item_sequence_no() {
		return cargo_item_sequence_no;
	}

	public void setCargo_item_sequence_no(String cargo_item_sequence_no) {
		this.cargo_item_sequence_no = cargo_item_sequence_no;
	}

	public String getCargo_item_description() {
		return cargo_item_description;
	}

	public void setCargo_item_description(String cargo_item_description) {
		this.cargo_item_description = cargo_item_description;
	}
	
	
	/*public String getType_of_packages() {
		return type_of_packages;
	}

	public void setType_of_packages(String type_of_packages) {
		this.type_of_packages = type_of_packages;
	}*/

	public String getCsn_reporting_type() {
		return csn_reporting_type;
	}

	public void setCsn_reporting_type(String csn_reporting_type) {
		this.csn_reporting_type = csn_reporting_type;
	}

	public String getPrevious_mcin() {
		return previous_mcin;
	}

	public void setPrevious_mcin(String previous_mcin) {
		this.previous_mcin = previous_mcin;
	}

	public String getType_of_cargo() {
		return type_of_cargo;
	}

	public void setType_of_cargo(String type_of_cargo) {
		this.type_of_cargo = type_of_cargo;
	}

	public String getSplit_indicator_list() {
		return split_indicator_list;
	}

	public void setSplit_indicator_list(String split_indicator_list) {
		this.split_indicator_list = split_indicator_list;
	}

	public String getPort_of_receipt() {
		return port_of_receipt;
	}

	public void setPort_of_receipt(String port_of_receipt) {
		this.port_of_receipt = port_of_receipt;
	}

	public String getPort_of_receipt_name() {
		return port_of_receipt_name;
	}

	public void setPort_of_receipt_name(String port_of_receipt_name) {
		this.port_of_receipt_name = port_of_receipt_name;
	}

	public String getPan_of_notified_party() {
		return pan_of_notified_party;
	}

	public void setPan_of_notified_party(String pan_of_notified_party) {
		this.pan_of_notified_party = pan_of_notified_party;
	}

	public String getUnit_of_weight() {
		return unit_of_weight;
	}

	public void setUnit_of_weight(String unit_of_weight) {
		this.unit_of_weight = unit_of_weight;
	}

	public String getGross_volume() {
		return gross_volume;
	}

	public void setGross_volume(String gross_volume) {
		this.gross_volume = gross_volume;
	}

	public String getUnit_of_volume() {
		return unit_of_volume;
	}

	public void setUnit_of_volume(String unit_of_volume) {
		this.unit_of_volume = unit_of_volume;
	}

	public String getNumber_of_packages_hidden() {
		return number_of_packages_hidden;
	}

	public void setNumber_of_packages_hidden(String number_of_packages_hidden) {
		this.number_of_packages_hidden = number_of_packages_hidden;
	}

	public String getType_of_packages_hidden() {
		return type_of_packages_hidden;
	}

	public void setType_of_packages_hidden(String type_of_packages_hidden) {
		this.type_of_packages_hidden = type_of_packages_hidden;
	}

	public String getContainer_weight() {
		return container_weight;
	}

	public void setContainer_weight(String container_weight) {
		this.container_weight = container_weight;
	}

	public String getPort_of_acceptance_name() {
		return port_of_acceptance_name;
	}

	public void setTotal_number_of_packages(String total_number_of_packages) {
		this.total_number_of_packages = total_number_of_packages;
	}

	public String getPort_of_call_sequence_number() {
		return port_of_call_sequence_number;
	}

	public void setPort_of_call_sequence_number(String port_of_call_sequence_number) {
		this.port_of_call_sequence_number = port_of_call_sequence_number;
	}

	public String getPort_of_call_coded() {
		return port_of_call_coded;
	}

	public void setPort_of_call_coded(String port_of_call_coded) {
		this.port_of_call_coded = port_of_call_coded;
	}

	public String getNext_port_of_call_coded() {
		return next_port_of_call_coded;
	}

	public void setNext_port_of_call_coded(String next_port_of_call_coded) {
		this.next_port_of_call_coded = next_port_of_call_coded;
	}

	public String getMc_location_customs() {
		return mc_location_customs;
	}

	public void setMc_location_customs(String mc_location_customs) {
		this.mc_location_customs = mc_location_customs;
	}
	
	

	public List<Consigner> getConsigner() {
		return consigner;
	}

	public void setConsigner(List<Consigner> consigner) {
		this.consigner = consigner;
	}

	public String getNextport1() {
		return nextport1;
	}

	public void setNextport1(String nextport1) {
		this.nextport1 = nextport1;
	}

	public String getNextport2() {
		return nextport2;
	}

	public void setNextport2(String nextport2) {
		this.nextport2 = nextport2;
	}

	public String getNextport3() {
		return nextport3;
	}

	public void setNextport3(String nextport3) {
		this.nextport3 = nextport3;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((pod == null) ? 0 : pod.hashCode());
		result = prime * result + ((service == null) ? 0 : service.hashCode());
		result = prime * result + ((terminal == null) ? 0 : terminal.hashCode());
		result = prime * result + ((vessel == null) ? 0 : vessel.hashCode());
		result = prime * result + ((voyage == null) ? 0 : voyage.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ImportGeneralManifestMod other = (ImportGeneralManifestMod) obj;
		if (pod == null) {
			if (other.pod != null)
				return false;
		} else if (!pod.equals(other.pod))
			return false;
		if (service == null) {
			if (other.service != null)
				return false;
		} else if (!service.equals(other.service))
			return false;
		if (terminal == null) {
			if (other.terminal != null)
				return false;
		} else if (!terminal.equals(other.terminal))
			return false;
		if (vessel == null) {
			if (other.vessel != null)
				return false;
		} else if (!vessel.equals(other.vessel))
			return false;
		if (voyage == null) {
			if (other.voyage != null)
				return false;
		} else if (!voyage.equals(other.voyage))
			return false;
		return true;
	}
	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#toString()
	 */

	@Override
	public String toString() {
		return "ImportGeneralManifestMod [consignee=" + consignee + ", consigner=" + consigner + ", notifyParty="
				+ notifyParty + ", marksNumber=" + marksNumber + ", containerDetailes=" + containerDetailes + ", bl="
				+ bl + ", service=" + service + ", vessel=" + vessel + ", voyage=" + voyage + ", pol=" + pol
				+ ", polTerminal=" + polTerminal + ", del=" + del + ", depot=" + depot + ", pod=" + pod
				+ ", podTerminal=" + podTerminal + ", codeCode=" + codeCode + ", callSing=" + callSing + ", lineCode="
				+ lineCode + ", agentCode=" + agentCode + ", portOrigin=" + portOrigin + ", portArrival=" + portArrival
				+ ", lastPort1=" + lastPort1 + ", lastPort2=" + lastPort2 + ", lastPort3=" + lastPort3 + ", nextport1="
				+ nextport1 + ", nextport2=" + nextport2 + ", nextport3=" + nextport3 + ", terminal=" + terminal
				+ ", vesselType=" + vesselType + ", genDesc=" + genDesc + ", masterName=" + masterName
				+ ", vesselNation=" + vesselNation + ", igmNumber=" + igmNumber + ", igmDate=" + igmDate
				+ ", arrivalDate=" + arrivalDate + ", arrivalTime=" + arrivalTime + ", ataarrivalDate=" + ataarrivalDate
				+ ", ataarrivalTime=" + ataarrivalTime + ", totalBls=" + totalBls + ", lightDue=" + lightDue
				+ ", grossWeight=" + grossWeight + ", netWeight=" + netWeight + ", smBtCargo=" + smBtCargo
				+ ", shipStrDect=" + shipStrDect + ", crewEffect=" + crewEffect + ", mariTimeDecl=" + mariTimeDecl
				+ ", itemNumber=" + itemNumber + ", cargoNature=" + cargoNature + ", cargoMovmnt=" + cargoMovmnt
				+ ", itemType=" + itemType + ", cargoMovmntType=" + cargoMovmntType + ", transportMode=" + transportMode
				+ ", roadCarrCode=" + roadCarrCode + ", roadTPBondNo=" + roadTPBondNo + ", customTerminalCode="
				+ customTerminalCode + ", submitDateTime=" + submitDateTime + ", weight=" + weight + ", nhavaShevaEta="
				+ nhavaShevaEta + ", finalPlaceDelivery=" + finalPlaceDelivery + ", packages=" + packages + ", cfsName="
				+ cfsName + ", mblNo=" + mblNo + ", hblNo=" + hblNo + ", blDate=" + blDate + ", blStatus=" + blStatus
				+ ", fromItemNo=" + fromItemNo + ", toItemNo=" + toItemNo + ", imoCode=" + imoCode + ", newVessel="
				+ newVessel + ", newVoyage=" + newVoyage + ", serialNumber=" + serialNumber + ", crewListDeclaration="
				+ crewListDeclaration + ", cargoDeclaration=" + cargoDeclaration + ", passengerList=" + passengerList
				+ ", dpdMovement=" + dpdMovement + ", dpdCode=" + dpdCode + ", blVersion=" + blVersion + ", CusAdd1="
				+ CusAdd1 + ", CusAdd2=" + CusAdd2 + ", CusAdd3=" + CusAdd3 + ", CusAdd4=" + CusAdd4 + ", IsValidateBL="
				+ IsValidateBL + ", GrossCargoWeightBLlevel=" + GrossCargoWeightBLlevel + ", PackageBLLevel="
				+ PackageBLLevel + ", dep_manif_no=" + dep_manif_no + ", dep_manifest_date=" + dep_manifest_date
				+ ", submitter_type=" + submitter_type + ", submitter_code=" + submitter_code + ", authoriz_rep_code="
				+ authoriz_rep_code + ", shipping_line_bond_no_r=" + shipping_line_bond_no_r + ", mode_of_transport="
				+ mode_of_transport + ", ship_type=" + ship_type + ", conveyance_reference_no="
				+ conveyance_reference_no + ", cargo_description=" + cargo_description + ", tol_no_of_trans_equ_manif="
				+ tol_no_of_trans_equ_manif + ", brief_cargo_des=" + brief_cargo_des + ", expected_date="
				+ expected_date + ", time_of_dept=" + time_of_dept + ", no_of_crew_manif=" + no_of_crew_manif
				+ ", port_of_call_cod=" + port_of_call_cod + ", total_no_of_tran_s_cont_repo_on_ari_dep="
				+ total_no_of_tran_s_cont_repo_on_ari_dep + ", message_type=" + message_type + ", port_of_reporting="
				+ port_of_reporting + ", job_number=" + job_number + ", job_date=" + job_date + ", reporting_event="
				+ reporting_event + ", manifest_no_csn_no=" + manifest_no_csn_no + ", manifest_date_csn_date="
				+ manifest_date_csn_date + ", vessel_type_movement=" + vessel_type_movement + ", shipping_line_code="
				+ shipping_line_code + ", authorized_sea_carrier_code=" + authorized_sea_carrier_code
				+ ", port_of_registry=" + port_of_registry + ", registry_date=" + registry_date
				+ ", voyage_details_movement=" + voyage_details_movement + ", ship_itinerary_sequence="
				+ ship_itinerary_sequence + ", ship_itinerary=" + ship_itinerary + ", port_of_call_name="
				+ port_of_call_name + ", arrival_departure_details=" + arrival_departure_details + ", number_of_crew="
				+ number_of_crew + ", total_no_of_transport_equipment_reported_on_arrival_departure="
				+ total_no_of_transport_equipment_reported_on_arrival_departure + ", consolidated_indicator="
				+ consolidated_indicator + ", previous_declaration=" + previous_declaration + ", consolidator_pan="
				+ consolidator_pan + ", cin_type=" + cin_type + ", mcin=" + mcin + ", csn_submitted_type="
				+ csn_submitted_type + ", csn_submitted_by=" + csn_submitted_by + ", csn_reporting_type="
				+ csn_reporting_type + ", csn_site_id=" + csn_site_id + ", csn_number=" + csn_number + ", csn_date="
				+ csn_date + ", previous_mcin=" + previous_mcin + ", split_indicator=" + split_indicator
				+ ", number_of_packages=" + number_of_packages + ", type_of_package=" + type_of_package
				+ ", first_port_of_entry_last_port_of_departure=" + first_port_of_entry_last_port_of_departure
				+ ", type_of_cargo=" + type_of_cargo + ", split_indicator_list=" + split_indicator_list
				+ ", port_of_acceptance=" + port_of_acceptance + ", port_of_receipt=" + port_of_receipt + ", ucr_type="
				+ ucr_type + ", ucr_code=" + ucr_code + ", soc_flag=" + soc_flag + ", equipment_load_status="
				+ equipment_load_status + ", equipment_seal_type=" + equipment_seal_type + ", port_of_acceptance_name="
				+ port_of_acceptance_name + ", port_of_receipt_name=" + port_of_receipt_name
				+ ", pan_of_notified_party=" + pan_of_notified_party + ", unit_of_weight=" + unit_of_weight
				+ ", gross_volume=" + gross_volume + ", unit_of_volume=" + unit_of_volume + ", cargo_item_sequence_no="
				+ cargo_item_sequence_no + ", cargo_item_description=" + cargo_item_description
				+ ", total_number_of_packages=" + total_number_of_packages + ", number_of_packages_hidden="
				+ number_of_packages_hidden + ", type_of_packages_hidden=" + type_of_packages_hidden
				+ ", mc_item_details=" + mc_item_details + ", container_weight=" + container_weight
				+ ", port_of_call_sequence_number=" + port_of_call_sequence_number + ", port_of_call_coded="
				+ port_of_call_coded + ", next_port_of_call_coded=" + next_port_of_call_coded + ", mc_location_customs="
				+ mc_location_customs + ", uno_code=" + uno_code + ", imdg_code=" + imdg_code + ", port_of_destination="
				+ port_of_destination + "]";
	}
	

	

	
}
