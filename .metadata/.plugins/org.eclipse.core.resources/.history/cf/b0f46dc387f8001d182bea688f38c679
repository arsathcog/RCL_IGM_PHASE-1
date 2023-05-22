var FORM_ID = 'figm001'
	var igmdata;
var checkSubmit = false;
var checkBLsearch = false;

/*array for bl details field*/
var idJsonObjectForTextBox = [];

/*array for vessel/voyage  field*/
var listOfVesselVoyageSearchDetails=[];

/*array for check box heandler field*/
var newResult = [];
var saveddataForcheckHandler=[];
var checkHandlerArray=[];

/*variable for check veliadtion*/    
var submitvalidationaftersave=true;
var t;

/*vareavles for popupwindow*/
var popupWindow;
var consigneeInfor = false;
var consignerInfo = false;
var marksInfor = false;
var containerDetailsInfor = false;
var notifyInfor = false;
var meregefile = false;

/*Declare variable for popupwindow*/
popupjson={};
popupjson.popup= {};

/**Declar variable for IGM NO validation*/
var checkedVeSselAndVoyageRow="";

/*function for find  operation*/
function findData() {
	
	/* checking searchSection Validation Started */
	var service1 = document.getElementById("igmservice").value;
	var vessel1 = document.getElementById("vessel").value;
	var voyage1 = document.getElementById("voyage").value;
	var pod1 = document.getElementById("pod").value;
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	if (vessel1 == "") {
		showBarMessages("Vessel is required.",1);
		return false;
	} else if (voyage1 == "") {
		showBarMessages("Voyage is required.",1);
		return false;
	} else if (pod1 == "") {
		showBarMessages("POD is required",1);
		return false;
	}
	/* checking searchSection Validation Ened */

	else {
		document.getElementById("vessel&voyage1st").style.display = "block";
		document.getElementById("vessel&voyage2nd").style.display = "none";
		document.getElementById("blankowndiv").style.display = "none";
		

		/* Restore the vessel/voyage section and BL section 
		 * refresh all the edited field in igm screen  */

		document.getElementById("selectall").checked = false;
		document.getElementById("selectall").disabled = true;
		document.getElementById("igmNo").readOnly = false;
		document.getElementById("checkIgmInfo").disabled = true;
		document.getElementById("checkBLInfo").disabled = true;
		document.getElementById("checkIgmInfo").checked = false;
		document.getElementById("checkBLInfo").checked  = false;

		checkSubmit = false;
		$("#customCode").val('');
		$("#callSign").val('');
		$("#imoCode").val('');
		$("#agentCode").val('');
		$("#lineCode").val('');
		$("#portOrigin").val('');
		$("#prt1").val('');
		$("#File1").val('');
		$("#prt2").val('');
		$("#prt3").val('');
		$("#portOfArrival").val('');
		$("#nov").val('');
		$("#mn").val('');
		$("#igmNo").val('');
		$("#aDate").val('');
		$("#aTime").val('');
		$("#ataAd").val('');
		$("#ataAt").val('');
		$("#totalItem").val('');
		$("#lhd").val('');
		$("#gwv").val('');
		$("#nwv").val('');
		$("#serialnumber").val('');
		$("#blSearchNo").val('');
		$("#fileUpload").val('');
		billdetail = document.getElementById("billAmount");
		foo = document.getElementById("fooBar");
		document.getElementById("igmDate").value = "";
		$("#igmDate").datepicker('disable');
		document.getElementById("blSearchNoButton").disabled = true;
		document.getElementById("submitype").disabled = true;
		document.getElementById("generatetype").disabled = true;
		document.getElementById("manifestfilegeneratoredifile").disabled = true;
		checkHandlerArray=[];
		submitvalidationaftersave=true;
		billdetail.innerHTML = '';
		foo.innerHTML='';
		var blDetails = [];
		newResult = [];
		saveddataForcheckHandler=[];
		/*Ended .....*/
		/*for generate file*/
		 generatFalg="";
	     fileNme="";

		/* Get the data from search section */
		var inStatus = document.getElementById("inStatus").value;
		var blCreationDateFrom = document.getElementById("blCreationDateFrom").value;
		var blCreationDateTo = document.getElementById("blCreationDateTo").value;
		var del = document.getElementById("del").value;
		var igmservice = document.getElementById("igmservice").value;
		var vessel = document.getElementById("vessel").value;
		var voyage = document.getElementById("voyage").value;
		var direction = document.getElementById("direction").value;
		var pol = document.getElementById("pol").value;
		var depot = document.getElementById("depo").value;
		var polTerminal = document.getElementById("polTerminal").value;
		var pod = document.getElementById("pod").value;
		var podTerminal = document.getElementById("podTerminal").value;
		/**disable all button search section*/
		disableButton();
		/*send data to backend*/
		$.ajax({
			method : "POST",
			async : true,
			url : ONFIND,
			beforeSend:function()
			{
				loadingfun();
			},
			data : {
				inStatus : inStatus,
				blCreationDateFrom : blCreationDateFrom,
				blCreationDateTo : blCreationDateTo,
				del:del,
				igmservice : igmservice,
				vessel : vessel,
				voyage : voyage,
				direction : direction,
				pol : pol,
				polTerminal : polTerminal,
				pod : pod,
				podTerminal : podTerminal,
				depot:depot
			},
            error: function(error){
            	EnableButton();
            	var mgsnull=document.getElementById("msg");
				mgsnull.innerHTML = '';
				showBarMessages("error : "+error.responseText,1);
            },
			success : function(result) {
				//console.log(result);
				/**enable all button search section*/
				EnableButton();
				/* Get the Data From backend 
				 * And convert the string to json*/
				result1 = JSON.parse(result);
				/* if combination is wrong */
				if (result1.result.length == 0) {
					var mgsnull=document.getElementById("msg");
					mgsnull.innerHTML = '';
					showBarMessages("No data found for this combination",1);
				} else {
					var foo = document.getElementById("fooBar");
					foo.innerHTML = '';
					listOfVesselVoyageSearchDetails = [];
					for (i = 0; i < result1.result.length; i++) {
						var eachVesselVoyageSearchDetailsRow = {};
						var element = document.createElement("input");
						element.setAttribute("type", "radio");
						element.setAttribute("name", "rowSelectedVV");
						element.setAttribute("id", i
								+ "rowSelectedForRadioSet");
						eachVesselVoyageSearchDetailsRow["id"] = i
						+ "rowSelectedForRadioSet";
						element.setAttribute("value", i);
						element.setAttribute('onclick',
						'blDataInsert();');
						foo.appendChild(element);

						var element1 = document.createElement("input");
						element1.setAttribute("type", "text");
						element1.setAttribute("class", "roundshap1");
						element1.setAttribute("value", i + 1);
						element1.setAttribute("readonly", true);
						element1.setAttribute("name", i + "sequence");
						element1.setAttribute("id", i +"-"+ "sequence");
						foo.appendChild(element1);

						for (var t = 2; t < vvd.length; t++) {
							var temppod=result1.result[i]["service"]["pod"];
							var tempPodTemp=result1.result[i]["service"]["podTerminal"];
							if((i + "-" + vvd[t].columnName == i + "-"
									+ "Road Carr code"))
							{
								var element1 =  document.createElement("select");
								var elem2 = document.createElement("option");
								if(result1.DropDown["roadCarrCoadDropdown"].length>0){
									elem2.text =  "Select One option";
									elem2.value="";
								}else{elem2.text =  "No Data";
								elem2.value="";
								}

								elem2.setAttribute("selected","selected");
								elem2.setAttribute("style", "display:none");

								element1
								.setAttribute("class", "roundshap6");
								element1.setAttribute("name",
										vvd[t].columnName);
								element1.setAttribute("id", i + "-"
										+ vvd[t].columnName);
								eachVesselVoyageSearchDetailsRow[vvd[t].columnName] = i
								+ "-" + vvd[t].columnName;
								element1.appendChild(elem2);
								element1.setAttribute("onchange","roadCarrCodeHandle(this)");
								foo.appendChild(element1);
								if(result1.DropDown["roadCarrCoadDropdown"].length>0)
								{
									for(var rcc=0; rcc < result1.DropDown["roadCarrCoadDropdown"].length;rcc++ )
									{
										var elem3 = document.createElement("option");
										elem3.text = result1.DropDown["roadCarrCoadDropdown"][rcc]["partnerValuedre"];
										elem3.title = result1.DropDown["roadCarrCoadDropdown"][rcc]["descriptiondrw"];
										element1.appendChild(elem3);
									}
								}
							}
							else if((i + "-" + vvd[t].columnName == i + "-"
									+ "TP Bond No"))
							{
								var element1 =  document.createElement("select");
								var elem2 = document.createElement("option");
									elem2.text =  "Select One option";
									elem2.value="";
								elem2.setAttribute("selected","selected");
								elem2.setAttribute("style", "display:none");

								element1
								.setAttribute("class", "roundshap6");
								element1.setAttribute("name",
										vvd[t].columnName);
								element1.setAttribute("id", i + "-"
										+ vvd[t].columnName);
								element1.setAttribute("disabled", true);
								eachVesselVoyageSearchDetailsRow[vvd[t].columnName] = i
								+ "-" + vvd[t].columnName;
								element1.appendChild(elem2);
								element1.setAttribute("onchange","tPBondNoHnadler(this)");
								foo.appendChild(element1); 
								
							}
							else if((i + "-" + vvd[t].columnName == i + "-"
									+ "CFS Custom Code"))
							{
								var element1 =  document.createElement("select");
								var elem2 = document.createElement("option");
								if(Object.keys(result1.DropDown["CFSCustomDropdown"]).length>0){
									elem2.text =  "Select One option";
									elem2.value="";
								}else{elem2.text =  "No Data";
								elem2.value="";}
								elem2.setAttribute("selected","selected");
								elem2.setAttribute("style", "display:none");

								element1
								.setAttribute("class", "roundshap6");
								element1.setAttribute("name",
										vvd[t].columnName);
								element1.setAttribute("id", i + "-"
										+ vvd[t].columnName);
								eachVesselVoyageSearchDetailsRow[vvd[t].columnName] = i
								+ "-" + vvd[t].columnName;
								element1.appendChild(elem2);
								element1.setAttribute("onchange","cfsHandler(this)");
								foo.appendChild(element1); 
								if(Object.keys(result1.DropDown["CFSCustomDropdown"]).length>0){
									
									for (var cfs=0; cfs < result1.DropDown["CFSCustomDropdown"][tempPodTemp].length;cfs++)
									{
										var elem3 = document.createElement("option");
										elem3.text = result1.DropDown["CFSCustomDropdown"][tempPodTemp][cfs]["cfsCustomCode"];
										element1.appendChild(elem3);
									}
								}
							}
							else{
								var element1 = document
								.createElement("input");
								element1.setAttribute("type", vvd[t].type);
								element1
								.setAttribute("class", "roundshap1");
								if (!result1.result[i]["service"][vvd[t].mappedCol]) {
									element1.setAttribute("value", "");
								} else {
									element1
									.setAttribute(
											"value",
											result1.result[i]["service"][vvd[t].mappedCol]);
								}
							}	
							element1.setAttribute("name",
									vvd[t].columnName);
							element1.setAttribute("id", i + "-"
									+ vvd[t].columnName);
							eachVesselVoyageSearchDetailsRow[vvd[t].columnName] = i
							+ "-" + vvd[t].columnName;
							foo.appendChild(element1);

							if ((i + "-" + vvd[t].columnName == i + "-"
									+ "Service")
									|| (i + "-" + vvd[t].columnName == i
											+ "-" + "Vessel")
											|| (i + "-" + vvd[t].columnName == i
													+ "-" + "Voyage")
													|| (i + "-" + vvd[t].columnName == i
															+ "-" + "Port")
															|| (i + "-" + vvd[t].columnName == i
																	+ "-" + "Terminal")) {
								element1.setAttribute("readonly", true);
							}
							if ((i + "-" + vvd[t].columnName == i + "-"
									+ "From Item No")) {
								element1.setAttribute("title" ,"Enter Numeric Values only");
								element1.setAttribute("onchange",
								"FromItemOnblurHandler(this)");
							}
							if ((i + "-" + vvd[t].columnName == i + "-"
									+ "To Item No")) {
								element1.setAttribute("title" ,"Enter Numeric Values only");
								element1.setAttribute("readonly", true);
								element1.setAttribute("onchange",
								"ToItemOnblurHandler(this)");
							}
						}
						//console.log(eachVesselVoyageSearchDetailsRow);
						listOfVesselVoyageSearchDetails     
						.push(eachVesselVoyageSearchDetailsRow);      /*store all the id by key(column name ) 
								                                                      value(inout field id) pair of vessel voyage section*/
						//console.log(listOfVesselVoyageSearchDetails);
						var node = document.createElement("p");       
						foo.appendChild(node);
					}
					var mgsnull=document.getElementById("msg");
					mgsnull.innerHTML = '';
					showBarMessages("Ready",0);
				}
			}
		});

	}
}
/*
 * Find() Ended
 */

/*
 * Generate BL section field blDataInsert() started
 */
function blDataInsert() {
	document.getElementById("vessel&voyage2nd").style.display = "block";
	document.getElementById("blankowndiv").style.display = "block";
	
	document.getElementById("selectall").disabled = false;
	document.getElementById("blSearchNoButton").disabled = false;
	document.getElementById("submitype").disabled = false;
	document.getElementById("generatetype").disabled = false;
	document.getElementById("manifestfilegeneratoredifile").disabled = false;
	document.getElementById("refreshButton").disabled = false;
	idJsonObjectForTextBox = [];

	for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
		checkedVeSselAndVoyageRow=x;
		blsValueObject = result1.result[x]["BLS"];
		if (document.getElementsByName("rowSelectedVV")[x].checked) {
			console.log(document.getElementsByName("rowSelectedVV")[x]);
			for (f = 0; f < blsValueObject.length; f++) {
				if (blsValueObject[f].itemNumber != "") {
					checkHandlerArray.push(result1.result[x]["BLS"][f].itemNumber);
				}
			}
			console.log(checkHandlerArray);
			for (r = 0; r < blsValueObject.length;r++) {
				if ((blsValueObject[r].itemNumber != "")&&(result1.result[x]["BLS"][r].igmNumber != "")) {
					newResult.push(result1.result[x]["BLS"][r]);
				}
			}
			console.log(newResult);
			for (b = 0; b < blsValueObject.length; b++) {
				if (blsValueObject[b].itemNumber != "") {
					saveddataForcheckHandler.push(result1.result[x]["BLS"][b]);
				}
			}
			console.log(saveddataForcheckHandler);
			var fromitemno = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["From Item No"]).value;
			var Toitemno = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["To Item No"]).value;

			/*set data in vessel voyage 2nd row*/
			document.getElementById("customCode").value = result1.result[x]["service"].codeCode;
			document.getElementById("callSign").value = result1.result[x]["service"].callSing;
			document.getElementById("imoCode").value = result1.result[x]["service"].imoCode;
			document.getElementById("agentCode").value = result1.result[x]["service"].agentCode;
			document.getElementById("lineCode").value = result1.result[x]["service"].lineCode;
			document.getElementById("portOrigin").value = result1.result[x]["service"].portOrigin;
			document.getElementById("prt1").value = result1.result[x]["service"].lastPort1;
			document.getElementById("prt2").value = result1.result[x]["service"].lastPort2;
			document.getElementById("prt3").value = result1.result[x]["service"].lastPort3;
			document.getElementById("nprt1").value = result1.result[x]["service"].nextport1;
			document.getElementById("nprt2").value = result1.result[x]["service"].nextport2;
			document.getElementById("nprt3").value = result1.result[x]["service"].nextport3;
			document.getElementById("portOfArrival").value = result1.result[x]["service"].portArrival;
			document.getElementById("nov").value = result1.result[x]["service"].vesselNation;
			document.getElementById("mn").value = result1.result[x]["service"].masterName;
			if (result1.result[x]["service"].igmNumber != '') {
				document.getElementById("igmNo").value = result1.result[x]["service"].igmNumber;
				document.getElementById("igmNo").readOnly = true;
				document.getElementById("checkIgmInfo").disabled = false;
				document.getElementById("checkBLInfo").disabled = false;
				$("#igmDate").datepicker('disable');
			}
			document.getElementById("igmDate").value = result1.result[x]["service"].igmDate;
			document.getElementById("aDate").value = result1.result[x]["service"].arrivalDate;
			document.getElementById("aTime").value = result1.result[x]["service"].arrivalTime;
			if(result1.result[x]["service"].ataarrivalDate !="")
			{
				var ataDate =result1.result[x]["service"].ataarrivalDate;
				$("#ataAd").datepicker();
				$("#ataAd").datepicker("option", "dateFormat", "dd/mm/yy");
				var currentDate = moment(ataDate, 'DD/MM/YYYY');
				var cDate = moment(currentDate).format('DD/MM/YYYY');
				document.getElementById("ataAd").value=cDate;
			}
			else
			{
				$("#ataAd").datepicker();
				$("#ataAd").datepicker("option", "dateFormat", "dd/mm/yy");
				var ArrivalDateupdate = new Date();
				var currentDate = moment(ArrivalDateupdate).format('DD/MM/YYYY');
				$("#ataAd").val(currentDate);
			}
			if(result1.result[x]["service"].ataarrivalTime !="")
			{
				var ataTime = result1.result[x]["service"].ataarrivalTime;
				$('#ataAt').timepicker();
				$('#ataAt').timepicker({ 'timeFormat': 'H:i' });
				var currentTime = moment(ataTime, 'H:mm');
				var currentTime = moment(currentTime).format('H:mm');
				//console.log(currentTime);
				$("#ataAt").val(currentTime);
			}
			else
			{
				$('#ataAt').timepicker({ 'timeFormat': 'H:i' });
				$('#ataAt').timepicker('setTime', new Date());
			}
			document.getElementById("totalItem").value = result1.result[x]["service"].totalBls;
			document.getElementById("lhd").value = result1.result[x]["service"].lightDue;
			document.getElementById("gwv").value = result1.result[x]["service"].grossWeight;
			document.getElementById("nwv").value = result1.result[x]["service"].netWeight;
			// document.getElementById("igmDate").value =
			// result1.result[x]["service"].igmDate;
			document.getElementById("smbc").value = result1.result[x]["service"].smBtCargo;
			document.getElementById("shsd").value = result1.result[x]["service"].shipStrDect;
			document.getElementById("crld").value = result1.result[x]["service"].crewListDeclaration;
			document.getElementById("card").value = result1.result[x]["service"].cargoDeclaration;
			document.getElementById("pasl").value = result1.result[x]["service"].passengerList;
			document.getElementById("cre").value = result1.result[x]["service"].crewEffect;
			document.getElementById("mard").value = result1.result[x]["service"].mariTimeDecl;
			
			//new added row for vessel voyage
			
			document.getElementById("departMainnumber").value = result1.result[x]["service"].dep_manif_no;
			document.getElementById("departMaindate").value = result1.result[x]["service"].dep_manifest_date;
			if(result1.result[x]["service"].submitter_type!=""){
			document.getElementById("submitTypet").value = result1.result[x]["service"].submitter_type;}
			document.getElementById("submitCode").value = result1.result[x]["service"].submitter_code;
			document.getElementById("authorizRepcode").value = result1.result[x]["service"].authoriz_rep_code;
			document.getElementById("shiplineBondnumber").value = result1.result[x]["service"].shipping_line_bond_no_r;
			if(result1.result[x]["service"].mode_of_transport!=""){
			document.getElementById("modofTransport").value = result1.result[x]["service"].mode_of_transport;}
			document.getElementById("shipType").value = result1.result[x]["service"].ship_type;
			document.getElementById("convanceRefnum").value = result1.result[x]["service"].conveyance_reference_no;
			document.getElementById("totalnotRaneqpmin").value = result1.result[x]["service"].tol_no_of_trans_equ_manif;
			document.getElementById("cargoDescrip").value = result1.result[x]["service"].cargo_description;
			document.getElementById("briefCargodescon").value = result1.result[x]["service"].brief_cargo_des;
			document.getElementById("expdate").value = result1.result[x]["service"].expected_date;
			document.getElementById("timeofdep").value = result1.result[x]["service"].time_of_dept;
			document.getElementById("tonotransrepoaridep").value = result1.result[x]["service"].total_no_of_tran_s_cont_repo_on_ari_dep;
			document.getElementById("mesType").value = result1.result[x]["service"].message_type;
			document.getElementById("vesType").value = result1.result[x]["service"].vessel_type_movement;
			document.getElementById("authoseaCarcode").value = result1.result[x]["service"].authorized_sea_carrier_code;
			document.getElementById("portoDreg").value = result1.result[x]["service"].port_of_registry;
			document.getElementById("regDate").value = result1.result[x]["service"].registry_date;
			document.getElementById("voyDetails").value = result1.result[x]["service"].voyage_details_movement;
			document.getElementById("shipItiseq").value = result1.result[x]["service"].ship_itinerary_sequence;
			document.getElementById("shipItinerary").value = result1.result[x]["service"].ship_itinerary;
			document.getElementById("portofCallname").value = result1.result[x]["service"].port_of_call_name;
			document.getElementById("arrivalDepdetails").value = result1.result[x]["service"].arrival_departure_details;
			document.getElementById("totalnoTransarrivdep").value = result1.result[x]["service"].total_no_of_transport_equipment_reported_on_arrival_departure;
			
			
			//end 

			billdetail = document.getElementById("billAmount");
			billdetail.innerHTML = '';

			for (i = 0; i < blsValueObject.length; i++) {
				var idListForTextBox = {};
				var arrayofconsignee = [];
				var arrayofconsigner = [];
				var arrayofNotyfyparty=[];
				var arrayofmarksNumber = [];
				var arrayofcontainerDetailes=[];
				var element = document.createElement("input");
				element.setAttribute("type", "checkbox");
				element.setAttribute("name", "rowSelectedBL");
				element.setAttribute("id", i + "rowSelected");
				element.setAttribute('onclick', 'handlerforcheckbox(this);');
				idListForTextBox["id"] = i + "rowSelected";
				element.setAttribute("value", i);
				billdetail.appendChild(element);
				var element1 = document.createElement("input");
				element1.setAttribute("type", "text");
				element1.setAttribute("class", "seqCss");
				element1.setAttribute("value", i + 1);
				element1.setAttribute("readOnly", true);
				element1.setAttribute("name", i + "sequence");
				element1.setAttribute("id", i + "sequence");
				billdetail.appendChild(element1);

				for (var t = 2; t < bld.length; t++) {

					if(bld[t].columnName == "Cargo Nature")
					{

						var element1=document.createElement("select");
						//  element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallDPCss")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var CargoNaturevalue=blsValueObject[i][bld[t].mappedCol]; 
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						el.textContent = "C";
						el.value = "C";
						element1.appendChild(el);
						el2.textContent = "P";
						el2.value = "P";
						element1.appendChild(el2);
						//console.log(i + bld[t].columnName);
						element1.value=CargoNaturevalue;
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}

					}
					
					else if(bld[t].columnName == "Item Type")
					{
						var element1=document.createElement("select");
						//  element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallDPCss")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var ItemTypeValue=blsValueObject[i][bld[t].mappedCol];
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						var el3 = document.createElement("option");
						el.textContent = "OT";
						el.value = "OT";
						element1.appendChild(el);
						el2.textContent = "UB";
						el2.value = "UB";
						element1.appendChild(el2);
						el3.textContent = "GC";
						el3.value = "GC";
						element1.appendChild(el3);
						element1.value=ItemTypeValue;
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}
					}

					else if(bld[t].columnName == "Cargo Movement Type")
					{
						var element1=document.createElement("select");
						//element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallDPCss")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var cargomovementtypeval=blsValueObject[i][bld[t].mappedCol];
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						el.textContent = "FCL";
						el.value = "FCL";
						element1.appendChild(el);
						el2.textContent = "LCL";
						el2.value = "LCL";
						element1.appendChild(el2);
						element1.value=cargomovementtypeval;
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}
					}
					
					else if(bld[t].columnName == "Consolidated Indicator")
					{
						var element1=document.createElement("select");
						//element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "roundshap3")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var consolidatedindicatorval=blsValueObject[i][bld[t].mappedCol];
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						var el3 = document.createElement("option");
						el.textContent = "STRAIGHT BL";
						el.value = "S";
						element1.appendChild(el);
						el2.textContent = "CONSOLIDATED BL";
						el2.value = "C";
						element1.appendChild(el2);
						el3.textContent = "HOUSE BL";
						el3.value = "H";
						element1.appendChild(el3);
						if(consolidatedindicatorval!=""){
						element1.value=consolidatedindicatorval;}
						else{
						element1.value='S';}	
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}
					}
					
					else if(bld[t].columnName == "Type Of Cargo")
					{
						var element1=document.createElement("select");
						//element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "roundshap3")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var typeofcargoVal=blsValueObject[i][bld[t].mappedCol];
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						var el3 = document.createElement("option");
						var el4 = document.createElement("option");
						el.textContent = "IMPORTED  GOODS";
						el.value = "IM";
						element1.appendChild(el);
						el2.textContent = "EXPORTED GOOODS";
						el2.value = "EX";
						element1.appendChild(el2);
						el3.textContent = "COASTAL GOODS";
						el3.value = "CG";
						element1.appendChild(el3);
						el4.textContent = "EMPTY";
						el4.value = "EM";
						element1.appendChild(el4);
						
						if(typeofcargoVal!=""){
						element1.value=typeofcargoVal;}
						else{
						element1.value='IM';}	
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}
					}
					
					
					
					else if(bld[t].columnName == "Split Indicator List")
					{
						var element1=document.createElement("select");
						//element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallDPCss")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var splitindicatorval=blsValueObject[i][bld[t].mappedCol];
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						var el3 = document.createElement("option");
						var el4 = document.createElement("option");
						el.textContent = "Y";
						el.value = "Y";
						element1.appendChild(el);
						el2.textContent = "N";
						el2.value = "N";
						element1.appendChild(el2);
						
						if(splitindicatorval!=""){
						element1.value=splitindicatorval;}
						else{
						element1.value='N';}	
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}
					}
					
					else if(bld[t].columnName == "Previous Declaration")
					{
						var element1=document.createElement("select");
						//element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallDPCss")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var previousdeclarationval=blsValueObject[i][bld[t].mappedCol];
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						var el3 = document.createElement("option");
						el.textContent = "N";
						el.value = "N";
						element1.appendChild(el);
						el2.textContent = "C";
						el2.value = "C";
						element1.appendChild(el2);
						el3.textContent = "Y";
						el3.value = "Y";
						element1.appendChild(el3);
						if(previousdeclarationval!=""){
						element1.value=previousdeclarationval;}
						else{
						element1.value='N';}	
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}
					}
					
					else if(bld[t].columnName == "CIN TYPE")
					{
						var element1=document.createElement("select");
						//element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallDPCss")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var cintypeval=blsValueObject[i][bld[t].mappedCol];
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						el.textContent = "MCIN";
						el.value = "MCIN";
						element1.appendChild(el);
						el2.textContent = "PCIN";
						el2.value = "PCIN";
						element1.appendChild(el2);
						
						if(cintypeval!=""){
						element1.value=cintypeval;}
						else{
						element1.value='MCIN';}	
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}
					}
					
					else if(bld[t].columnName == "Type Of Cargo")
					{
						var element1=document.createElement("select");
						//element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "roundshap3")
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						var typeofcargoval=blsValueObject[i][bld[t].mappedCol];
						var el = document.createElement("option");
						var el2 = document.createElement("option");
						var el3 = document.createElement("option");
						var el4 = document.createElement("option");
						el.textContent = "IMPORTED  GOODS";
						el.value = "IM";
						element1.appendChild(el);
						el2.textContent = "EXPORTED GOOODS";
						el2.value = "EX";
						element1.appendChild(el2);
						el3.textContent = "COASTAL GOODS";
						el3.value = "CG";
						element1.appendChild(el3);
						el4.textContent = "EMPTY";
						el4.value = "EM";
						element1.appendChild(el4);
						
						if(typeofcargoval!=""){
						element1.value=typeofcargoval;}
						else{
						element1.value='IM';}	
						if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
						{
							element1.setAttribute("disabled", true);
						}
					}
					
					
					else if(bld[t].columnName == "Consigner")
					{
						var element1=document.createElement("input");
						element1.setAttribute("type", "button");
						element1.setAttribute("class", "roundshap5");
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						element1.setAttribute("value", "+");
						element1.setAttribute("servicepath", x);
						element1.setAttribute("blspath", i);
						element1.setAttribute('onclick',"ConsignerInfo(this)");

					}
					else if(bld[t].columnName == "Consignee")
					{
						var element1=document.createElement("input");
						element1.setAttribute("type", "button");
						element1.setAttribute("class", "roundshap5");
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						element1.setAttribute("value", "+");
						element1.setAttribute("servicepath", x);
						element1.setAttribute("blspath", i);
						element1.setAttribute('onclick',"consigneeInfo(this)");

					}
					else if(bld[t].columnName == "Notify Party")
					{
						var element1=document.createElement("input");
						element1.setAttribute("type", "button");
						element1.setAttribute("class", "roundshap5");
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						element1.setAttribute("servicepath", x);
						element1.setAttribute("blspath", i);
						element1.setAttribute("value", "+");
						element1.setAttribute('onclick',"notifyInfo(this)");
					}
					else if(bld[t].columnName == "Marks_Number")
					{
						var element1=document.createElement("input");
						element1.setAttribute("type", "button");
						element1.setAttribute("class", "roundshap5");
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						element1.setAttribute("servicepath", x);
						element1.setAttribute("blspath", i);
						element1.setAttribute("value", "+");
						element1.setAttribute('onclick',"marksInfo(this)");
					}
					else if(bld[t].columnName == "Container Details")
					{
						var element1=document.createElement("input");
						element1.setAttribute("type", "button");
						element1.setAttribute("class", "roundshap5");
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						element1.setAttribute("servicepath", x);
						element1.setAttribute("blspath", i);
						element1.setAttribute("value", "+");
						element1.setAttribute('onclick',"containerDetailsInfo(this)");
					}
					else if(bld[t].columnName == "BL Version")
					{
						var element1=document.createElement("input");
						element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallInputBox");
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						if (!blsValueObject[i][bld[t].mappedCol]) {
							element1.setAttribute("value", "");
						} else{
							element1.setAttribute("value",
									blsValueObject[i][bld[t].mappedCol]);
						}
					}
					else if(bld[t].columnName == "Transport Mode")
					{
						var element1=document.createElement("input");
						element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallInputBox");
						element1.setAttribute("id", i + bld[t].columnName);
						element1.setAttribute("name", bld[t].columnName);
						if (!blsValueObject[i][bld[t].mappedCol]) {
							element1.setAttribute("value", "");
						} else{
							element1.setAttribute("value",
									blsValueObject[i][bld[t].mappedCol]);
						}
					}
					else if(bld[t].columnName == "Port of Acceptance"){
						var element1 = document.createElement("input");
						element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallInputBox")

						if (!blsValueObject[i][bld[t].mappedCol]){
							element1.setAttribute("value", "");
						}else{
							element1.setAttribute("value",
									blsValueObject[i][bld[t].mappedCol]);
						}
					}
					else if(bld[t].columnName == "First Port of Entry/Last Port of Departure"){
						var element1 = document.createElement("input");
						element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallInputBox")

						if (!blsValueObject[i][bld[t].mappedCol]){
							element1.setAttribute("value", "");
						}else{
							element1.setAttribute("value",
									blsValueObject[i][bld[t].mappedCol]);
						}
					}else if(bld[t].columnName == "Cargo Movement"){
						var element1 = document.createElement("input");
						element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "smallInputBox")

						if (!blsValueObject[i][bld[t].mappedCol]){
							element1.setAttribute("value", "");
						}else{
							element1.setAttribute("value",
									blsValueObject[i][bld[t].mappedCol]);
						}
					}
					else {
						var element1 = document.createElement("input");
						element1.setAttribute("type", bld[t].type);
						element1.setAttribute("class", "roundshap2")

						if (!blsValueObject[i][bld[t].mappedCol]){
							element1.setAttribute("value", "");
						}else{
							element1.setAttribute("value",
									blsValueObject[i][bld[t].mappedCol]);
						}
					}

					/*if (!blsValueObject[i][bld[t].mappedCol]) {
						element1.setAttribute("value", "");
					} else {
						element1.setAttribute("value",
							//	blsValueObject[i][bld[t].mappedCol]);
					}*/
					// element1.setAttribute("name", bld[t].columnName);
					element1.setAttribute("id", i + bld[t].columnName);
					if (i + bld[t].columnName == i + 'BL#') {
						element1.setAttribute("name",
								blsValueObject[i][bld[t].mappedCol]);
					} else {
						element1.setAttribute("name", bld[t].columnName);
					}
					if(i + bld[t].columnName == i + 'Item Number')
					{
						var id1=i + 'Item Number';
						element1.setAttribute("title" ,"Enter Numeric Values only");
						element1.setAttribute("onchange",
						"itemNoHandler(this)");
					}


					if ((i + bld[t].columnName == i + 'Item Number')&& (blsValueObject[i].itemNumber == ""))
					{
						element1.setAttribute("readonly", true);
					}

					/*if (i + bld[t].columnName == i + "Submit Date Time"
							&& blsValueObject[i].submitDateTime == "") {

						element1.setAttribute("value", newdate);
					}*/
					if (i + bld[t].columnName == i + "Submit Date Time")
					{
						element1.setAttribute("readonly", true);
					}
					if (i + bld[t].columnName == i + "BL Validate Flag" && ((blsValueObject[i][bld[t].mappedCol])=="TRUE") )
					{

						//document.getElementById(i+"sequence").classList.add("validateBL");
						blColorChange(i);
					}
					if ((i + bld[t].columnName == i + 'Is Present')
							&& (blsValueObject[i].itemNumber != "")) {
						element1.setAttribute("value", "TRUE");
					} else if ((i + bld[t].columnName == i + 'Is Present')
							&& (blsValueObject[i].itemNumber == "")) {
						element1.setAttribute("value", "FALSE");
					}
					if ((i + bld[t].columnName == i + "BL#")
							|| (i + bld[t].columnName == i + "BL_Date")||(i + bld[t].columnName == i + "BL Version")) {
						element1.setAttribute("readonly", true);
					}
					if ((i + bld[t].columnName == i + 'Item Number')
							&& (blsValueObject[i].itemNumber != "")) {
						//element1.setAttribute("readonly", false);
						document.getElementById(i + "rowSelected").checked = true;
					}

					if ((i + bld[t].columnName == i + 'Cargo Movement'))
					{
						element1.setAttribute("readonly", true);
					}
					if ((i + bld[t].columnName == i + 'Transport Mode'))
					{
						element1.setAttribute("readonly", true);
					}
					if(i + bld[t].columnName==i+ 'Consolidator PAN')
					{
						var node = document.createElement("p");
						billdetail.appendChild(node);
					}
					if(i + bld[t].columnName==i+ 'UCR Type')
					{
					var node = document.createElement("p");
					billdetail.appendChild(node);
					}
					if (((i + bld[t].columnName == i + 'CFS-Custom Code')
							|| (i + bld[t].columnName == i + 'Cargo Movement')
							|| (i + bld[t].columnName == i + 'Transport Mode')
							|| (i + bld[t].columnName == i + 'Item Number')
							|| (i + bld[t].columnName == i + 'Road Carr code')
							|| (i + bld[t].columnName == i + 'TP Bond No'))
							&& (document.getElementById("igmNo").value != "")
							&& (blsValueObject[i].itemNumber != "")) {
						element1.setAttribute("readonly", true);
						document.getElementById(i + "rowSelected").disabled = true;

					}
					idListForTextBox[bld[t].columnName] = i + bld[t].columnName;
					billdetail.appendChild(element1);
				}
				idJsonObjectForTextBox.push(idListForTextBox);			/*store all the id by key(column name ) 
                														value(inout field id) pair of vessel voyage section*/

				var node = document.createElement("p");
				billdetail.appendChild(node);
				//console.log(idJsonObjectForTextBox);

				/*for loop for generate Json for popupwindow */

				/*loop for consignee popup*/
				for(m=0;m<blsValueObject[i].consignee.length;m++)
				{
					var eachconsigneeindexdtl={};
					eachconsigneeindexdtl["zip"]=blsValueObject[i].consignee[m].zip;
					eachconsigneeindexdtl["blNO"]=blsValueObject[i].consignee[m].blNO;
					eachconsigneeindexdtl["city"]=blsValueObject[i].consignee[m].city;
					eachconsigneeindexdtl["countryCode"]=blsValueObject[i].consignee[m].countryCode;
					eachconsigneeindexdtl["addressLine1"]=blsValueObject[i].consignee[m].addressLine1;
					eachconsigneeindexdtl["addressLine2"]=blsValueObject[i].consignee[m].addressLine2;
					eachconsigneeindexdtl["addressLine3"]=blsValueObject[i].consignee[m].addressLine3;
					eachconsigneeindexdtl["addressLine4"]=blsValueObject[i].consignee[m].addressLine4;
					eachconsigneeindexdtl["customerCode"]=blsValueObject[i].consignee[m].customerCode;
					eachconsigneeindexdtl["state"]=blsValueObject[i].consignee[m].state;
					eachconsigneeindexdtl["customerName"]=blsValueObject[i].consignee[m].customerName;
					if(blsValueObject[i].isValidateBL!=""){
						eachconsigneeindexdtl["vaidation"]=blsValueObject[i].isValidateBL;	
					}else{
						eachconsigneeindexdtl["vaidation"]="";	
					}
					arrayofconsignee.push(eachconsigneeindexdtl);
				}
				
				/*loop for consigner popup*/
				for(m=0;m<blsValueObject[i].consigner.length;m++)
				{
					var eachconsignerindexdtl={};
					eachconsignerindexdtl["zip"]=blsValueObject[i].consigner[m].zip;
					eachconsignerindexdtl["blNO"]=blsValueObject[i].consigner[m].blNO;
					eachconsignerindexdtl["city"]=blsValueObject[i].consigner[m].city;
					eachconsignerindexdtl["countryCode"]=blsValueObject[i].consigner[m].countryCode;
					eachconsignerindexdtl["addressLine1"]=blsValueObject[i].consigner[m].addressLine1;
					eachconsignerindexdtl["addressLine2"]=blsValueObject[i].consigner[m].addressLine2;
					eachconsignerindexdtl["addressLine3"]=blsValueObject[i].consigner[m].addressLine3;
					eachconsignerindexdtl["addressLine4"]=blsValueObject[i].consigner[m].addressLine4;
					eachconsignerindexdtl["customerCode"]=blsValueObject[i].consigner[m].customerCode;
					eachconsignerindexdtl["state"]=blsValueObject[i].consigner[m].state;
					eachconsignerindexdtl["customerName"]=blsValueObject[i].consigner[m].customerName;
					if(blsValueObject[i].isValidateBL!=""){
						eachconsignerindexdtl["vaidation"]=blsValueObject[i].isValidateBL;	
					}else{
						eachconsignerindexdtl["vaidation"]="";	
					}
					arrayofconsigner.push(eachconsignerindexdtl);
				}
				
				/*loop for notifyParty popup*/
				for(m=0;m<blsValueObject[i].notifyParty.length;m++)
				{
					var eachnotifyPartyindexdtl={};
					eachnotifyPartyindexdtl["zip"]=blsValueObject[i].notifyParty[m].zip;
					eachnotifyPartyindexdtl["blNO"]=blsValueObject[i].notifyParty[m].blNo;
					eachnotifyPartyindexdtl["city"]=blsValueObject[i].notifyParty[m].city;
					eachnotifyPartyindexdtl["countryCode"]=blsValueObject[i].notifyParty[m].countryCode;
					eachnotifyPartyindexdtl["addressLine1"]=blsValueObject[i].notifyParty[m].addressLine1;
					eachnotifyPartyindexdtl["addressLine2"]=blsValueObject[i].notifyParty[m].addressLine2;
					eachnotifyPartyindexdtl["addressLine3"]=blsValueObject[i].notifyParty[m].addressLine3;
					eachnotifyPartyindexdtl["addressLine4"]=blsValueObject[i].notifyParty[m].addressLine4;
					eachnotifyPartyindexdtl["customerCode"]=blsValueObject[i].notifyParty[m].costumerCode;
					eachnotifyPartyindexdtl["state"]=blsValueObject[i].notifyParty[m].state;
					eachnotifyPartyindexdtl["customerName"]=blsValueObject[i].notifyParty[m].costumerName;
					if(blsValueObject[i].isValidateBL!=""){
						eachnotifyPartyindexdtl["vaidation"]=blsValueObject[i].isValidateBL;	
					}else{
						eachnotifyPartyindexdtl["vaidation"]="";	
					}
					arrayofNotyfyparty.push(eachnotifyPartyindexdtl);
				}
				/*loop for marksNumber popup*/
				for(m=0;m<blsValueObject[i].marksNumber.length;m++)
				{
					var eachmarksNumberindexdtl={};
					eachmarksNumberindexdtl["marksNumbers"]=blsValueObject[i].marksNumber[m].marksNumbers;
					eachmarksNumberindexdtl["blNO"]=blsValueObject[i].marksNumber[m].blNO;
					eachmarksNumberindexdtl["description"]=blsValueObject[i].marksNumber[m].description;
					if(blsValueObject[i].isValidateBL!=""){
						eachmarksNumberindexdtl["vaidation"]=blsValueObject[i].isValidateBL;	
					}else{
						eachmarksNumberindexdtl["vaidation"]="";	
					}
					arrayofmarksNumber.push(eachmarksNumberindexdtl);
				}
				/*loop for containerDetailes popup*/
				for(m=0;m<blsValueObject[i].containerDetailes.length;m++)
				{
					var eachcontainerDetailesindexdtl={};
					eachcontainerDetailesindexdtl["ContainerSize"]=blsValueObject[i].containerDetailes[m].containerSize;
					eachcontainerDetailesindexdtl["ContainerType"]=blsValueObject[i].containerDetailes[m].containerType;
					eachcontainerDetailesindexdtl["containerNumber"]=blsValueObject[i].containerDetailes[m].containerNumber;
					eachcontainerDetailesindexdtl["blNO"]=blsValueObject[i].containerDetailes[m].blNo;
					eachcontainerDetailesindexdtl["containerSealNumber"]=blsValueObject[i].containerDetailes[m].containerSealNumber;
					eachcontainerDetailesindexdtl["containerWeight"]=blsValueObject[i].containerDetailes[m].containerWeight;
					eachcontainerDetailesindexdtl["totalNumberOfPackagesInContainer"]=blsValueObject[i].containerDetailes[m].totalNumberOfPackagesInContainer;
					eachcontainerDetailesindexdtl["containerAgentCode"]=result1.result[x]["service"].agentCode;;
					eachcontainerDetailesindexdtl["status"]=blsValueObject[i].containerDetailes[m].status;
					if(blsValueObject[i].containerDetailes[m].equipmentLoadStatus==""){
						eachcontainerDetailesindexdtl["equipmentLoadStatus"]='FLC';
					}else{
						eachcontainerDetailesindexdtl["equipmentLoadStatus"]=blsValueObject[i].containerDetailes[m].equipmentLoadStatus;
					}
					if(blsValueObject[i].containerDetailes[m].soc_flag==""){
						eachcontainerDetailesindexdtl["soc_flag"]='N';
					}else{
						eachcontainerDetailesindexdtl["soc_flag"]=blsValueObject[i].containerDetailes[m].soc_flag;
					}
					if(blsValueObject[i].containerDetailes[m].equipment_seal_type==""){
						eachcontainerDetailesindexdtl["equipment_seal_type"]='BTSL';
					}else{
						eachcontainerDetailesindexdtl["equipment_seal_type"]=blsValueObject[i].containerDetailes[m].equipment_seal_type;
					}
					
					if(blsValueObject[i].isValidateBL!=""){
						eachcontainerDetailesindexdtl["vaidation"]=blsValueObject[i].isValidateBL;	
					}else{
						eachcontainerDetailesindexdtl["vaidation"]="";	
					}
					arrayofcontainerDetailes.push(eachcontainerDetailesindexdtl);
				}
				var objecToStorPopupArray ={"consignee": arrayofconsignee,
						"notifyParty" : arrayofNotyfyparty,"marksNumber":arrayofmarksNumber,"containerDetailes":arrayofcontainerDetailes,"consigner":arrayofconsigner}
				popupjson.popup[blsValueObject[i].bl]=objecToStorPopupArray;  
			}
		}
	}
	//	console.log(result1);
	//console.log(popupjson);
}
/*
 * blDataInsert() Ended
 */

/* Handle the Checkbox 
 * Provide Total Item Number 
 * Enable And Disable the Submit Button 
 * handlerforcheckbox() started
 */

function handlerforcheckbox(selectObject) {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';	
	totalItemNoCheckCount = 0;
	var checkId=selectObject.id;
	var checkValue=selectObject.value;
	var fromitemno="";
	var toitemno="";
	for (var i = 0; i < listOfVesselVoyageSearchDetails.length; i++) {
		if (document.getElementById(listOfVesselVoyageSearchDetails[i].id).checked == true) {
			fromitemno=document.getElementById(listOfVesselVoyageSearchDetails[i]["From Item No"]).value;
			toitemno=document.getElementById(listOfVesselVoyageSearchDetails[i]["To Item No"]).value;
		}
	}
	if(fromitemno==""||toitemno=="")
	{
		showBarMessages("Item Number range is required.",1)
		document.getElementById(checkId).checked = false;
		return false;
	}


	else{

		/* if (document.getElementById(checkId).checked == true)
	      {
		  if(document.getElementById(checkValue+"Item Number").value!="")
			  {
		  checkHandlerArray.push(document.getElementById(checkValue+"Item Number").value);
		  console.log(checkHandlerArray);
			  }
		  }*/  /*if()
			  {*/
		//	console.log(saveddataForcheckHandler[0].bl);
		if(document.getElementById(checkId).checked == true)
		{

			for(w=0;w<saveddataForcheckHandler.length;w++)
			{
				//console.log(document.getElementById(checkValue+"BL#").value);
				//console.log((saveddataForcheckHandler[w].bl));
				if((document.getElementById(checkValue+"BL#").value)==(saveddataForcheckHandler[w].bl))
				{
					document.getElementById(checkValue+"Item Number").value=(saveddataForcheckHandler[w].itemNumber);
					checkHandlerArray.push(saveddataForcheckHandler[w].itemNumber)
				}
			}
			// console.log(saveddataForcheckHandler);
			document.getElementById(checkValue+"Item Number").readOnly=false;
		}
		else if(document.getElementById(checkId).checked == false){
			document.getElementById(checkValue+"Item Number").readOnly=true;
			for (var i = 0; i < checkHandlerArray.length; i++) {
				if((document.getElementById(checkValue+"Item Number").value)==checkHandlerArray[i])
				{
					checkHandlerArray.splice(i,1);
					//console.log(checkHandlerArray);
					document.getElementById(checkValue+"Item Number").readOnly=true;
					document.getElementById(checkValue+"Item Number").value="";
				}
			}
		}

		//console.log(checkHandlerArray);
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true) {
				totalItemNoCheckCount++;
			} else if(totalItemNoCheckCount == 0)
			{
				document.getElementById("totalItem").value = "0";
			}
		}
		//console.log("totalItemNoCheckCount" + totalItemNoCheckCount);
		document.getElementById("totalItem").value = totalItemNoCheckCount;
	}
}
/*
 * handlerforcheckbox() Ended
 */


/* Handle SelectAll and DiselectAll option 
 * clickSelectAll() Started
 */
function clickSelectAll() {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';	
	var fromitemno="";
	var toitemno="";
	var checkItemNo="";
	for (var i = 0; i < listOfVesselVoyageSearchDetails.length; i++) {
		if (document.getElementById(listOfVesselVoyageSearchDetails[i].id).checked == true) {
			fromitemno=document.getElementById(listOfVesselVoyageSearchDetails[i]["From Item No"]).value;
			toitemno=document.getElementById(listOfVesselVoyageSearchDetails[i]["To Item No"]).value;
		}
	}
	if(fromitemno==""||toitemno=="")
	{
		showBarMessages("Item number range is required.",1)
		document.getElementById("selectall").checked = false;
	}
	else{
		if(newResult.length==0)
		{
			if (document.getElementById('selectall').checked == true) {
				for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
					//checkHandlerArray=[];
					checkBLNoslectAll=document.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
					checkItemNoslectAll=document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value;
					document.getElementById(idJsonObjectForTextBox[i].id).checked = true;
					for(l=0;l<saveddataForcheckHandler.length;l++)
					{
						if((checkBLNoslectAll==saveddataForcheckHandler[l].bl)&&(checkItemNoslectAll==""))
						{
							document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value=saveddataForcheckHandler[l].itemNumber;
						}
					}

				}
				for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
					document.getElementById("totalItem").value = result1.result[x]['BLS'].length;
				}
			} else {
				for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
					checkHandlerArray=[];
					document.getElementById(idJsonObjectForTextBox[i].id).checked = false;
					document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value="";
				}
				document.getElementById("totalItem").value = "0";
			}
		}
		else
		{
			if (document.getElementById('selectall').checked == true)
			{
				for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
					if (document.getElementById(idJsonObjectForTextBox[i].id).checked != true)
					{
						document.getElementById(idJsonObjectForTextBox[i].id).checked = true;

					}
				}
				for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
					document.getElementById("totalItem").value = result1.result[x]['BLS'].length;
				}
			}
			else
			{
				for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
					var flag = false;
					checkItemNo=document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value;
					for(j=0;j<newResult.length;j++)
					{
						if(newResult[j].itemNumber==checkItemNo)
						{
							flag = true;
						}
					}
					if(flag == false)
					{
						document.getElementById(idJsonObjectForTextBox[i].id).checked = false;
					}
				}
				document.getElementById("totalItem").value = newResult.length;
			}
			//console.log(checkHandlerArray);
		}
	}
}
//document.getElementById(idJsonObjectForTextBox[i].id).checked = false;
/*
 * clickSelectAll() Ended
 */


/* SystemGenerate Date For IgmDate 
 *
 * systemGenerateDateForIgmDate() Started
 */
function systemGenerateDateForIgmDate() {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var igmvalue = document.getElementById("igmNo").value;
	var savedIGMNo=result1.result[checkedVeSselAndVoyageRow]["service"].igmNumber;

	if(savedIGMNo!="" && igmvalue=="")
	{
		showBarMessages("IGM NO can't be Blank",1);
		document.getElementById("igmDate").value="";
		document.getElementById("igmNo").focus();
	}

	else{
		if (igmvalue != "") {
			$('#igmDate').datepicker('enable');
			$("#igmDate").datepicker();
			$("#igmDate").datepicker("option", "dateFormat", "dd/mm/yy");
			var igmDateupdate = new Date();
			var currentDate = moment(igmDateupdate).format('DD/MM/YYYY');
			$("#igmDate").val(currentDate);
		} else {
			document.getElementById("igmDate").value = "";
			$("#igmDate").datepicker('disable');
		}
	}
}
function dateForDepartMaindate(selectObject)
{
	$("#departMaindate").datepicker();
	$("#departMaindate").datepicker("option", "dateFormat", "dd/mm/yy");
	//var igmDateupdate = new Date();
	//var currentDate = moment(igmDateupdate).format('DD/MM/YYYY');
	//$("#departMaindate").val(currentDate);
}
/*
 * systemGenerateDateForIgmDate() Ened
 */

/* Search BL Numbler in BL Section */
/*
 * findBlNo() Started
 */
function findBlNo() {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	if (t != null) {
		t.classList.remove("bg_textbox2");
	}
	if (document.getElementById("blSearchNo").value == "") {
		showBarMessages("BL No is required.",1);
	} else {
		if (document
				.getElementsByName(document.getElementById("blSearchNo").value)[0].defaultValue == document
				.getElementById("blSearchNo").value) {
			t = document.getElementsByName(document
					.getElementById("blSearchNo").value)[0];
			document
			.getElementsByName(document.getElementById("blSearchNo").value)[0].classList
			.add("bg_textbox2");
			document
			.getElementsByName(document.getElementById("blSearchNo").value)[0]
			.scrollIntoView();
		}
	}
}
/*
 * findBlNo() Ended
 */

/*
 *Handle the item no. 
 * itemNoHendler() 
 * */
function itemNoHandler(selectObject)
{
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var inum=selectObject.value;
	var id=selectObject.id;
	var fromitemno="";
	var toitemno="";
	var count=0;


	for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
		if (document.getElementsByName("rowSelectedVV")[x].checked) {

			var fromitemno = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["From Item No"]).value;
			var toitemno = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["To Item No"]).value;
		}
	}

	if(inum!="")
	{   
		if(isNaN(inum))
		{
			document.getElementById(id).value="";
			return false;
		}
		if ((Number(inum)<(Number(fromitemno)) || Number(inum)>(Number(toitemno)))) {
			showBarMessages("Given Item No is not in range.",1);
			document.getElementById(id).value="";
			return false;
		}
		else{
			for (var i = 0; i < checkHandlerArray.length; i++) {
				if(inum==checkHandlerArray[i])
				{
					showBarMessages("Provided Item No is already present.",1);
					document.getElementById(id).value="";
					break;
				}
			}
			//console.log(document.getElementById(id).value);
			if(document.getElementById(id).value!="")
			{
				checkHandlerArray.push(document.getElementById(id).value);
				//console.log(checkHandlerArray);

				for (var j = 0; j < checkHandlerArray.length; j++) 
				{
					var flag = false;
					for (var i = 0; i < idJsonObjectForTextBox.length; i++)
					{
						if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true) 
						{
							if((checkHandlerArray[j])==(document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value))
							{
								flag  =  true ;
							}
						}
					}
					if(flag == false){
						checkHandlerArray.splice(j,1);
					}
				}
				//console.log(checkHandlerArray);
			}
		}
	}
	else
	{
		//console.log(checkHandlerArray);
		for (var j = 0; j < checkHandlerArray.length; j++) 
		{
			var flag = false;
			for (var i = 0; i < idJsonObjectForTextBox.length; i++)
			{
				if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true) 
				{
					if((checkHandlerArray[j])==(document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value))
					{
						flag  =  true ;
					}
				}
			}
			if(flag == false){
				checkHandlerArray.splice(j,1);
			}
		}
		//console.log(checkHandlerArray.length);
		//console.log(checkHandlerArray);
	}
}	

function igmnumbercheck()
{
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	if(document.getElementById("checkIgmInfo").checked==true)
	{
		document.getElementById("igmNo").readOnly=false;
	}
	if(document.getElementById("checkIgmInfo").checked==false)
	{
		document.getElementById("igmNo").readOnly=true;
		$("#igmDate").datepicker('disable');
	}
}     

function bllevelcheck(){
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	//checkBLInfo
	if(document.getElementById("checkBLInfo").checked==true)
	{
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true) {

				document.getElementById(idJsonObjectForTextBox[i]["Cargo Nature"]).disabled=false;
				document.getElementById(idJsonObjectForTextBox[i]["Item Type"]).disabled=false;
				document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement Type"]).disabled=false;
			}
		}
	}
	if(document.getElementById("checkBLInfo").checked==false)
	{
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true) {

				document.getElementById(idJsonObjectForTextBox[i]["Cargo Nature"]).disabled=true;
				document.getElementById(idJsonObjectForTextBox[i]["Item Type"]).disabled=true;
				document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement Type"]).disabled=true;
			}
		}
	}
}

function submitData() {
	/**disable all button search section*/
	disableButton();
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var blDetails = [];
	var listOfVesselVoyageSearchDetailsPrepraedJson = [];
	var listOfconsigneeDetailsForSave=[];
	var listOfconsignerDetailsForSave=[];
	var listOfNotifyPartyForSave=[];
	var listofcontainerdetailsForSave = [];
	var listofmarksNumberDtlsForSave =[];
	vesselIndex="";
	var validateItemNO=result1.result[checkedVeSselAndVoyageRow]["service"].igmNumber;
	var itemNoDataUI=document.getElementById("igmNo").value;
	var fitn = "";
	var titn = "";
	var itnu = "";
	var containrtVessel="";
	var caontainrVoyage="";
	var containerPOD="";

	if ((document.getElementById("totalItem").value == 0)||(document.getElementById("totalItem").value < 0)) {
		showBarMessages("Select BL first.",1);
		EnableButton();
		return false;
	}
	else if(validateItemNO!="" && itemNoDataUI==""){
		showBarMessages("IGM NO can't be Blank",1);
		document.getElementById("igmNo").focus();	
		EnableButton();
		return false;
	}
	else {
		/*search section field*/

		var inStatus = document.getElementById("inStatus").value;
		var blCreationDateFrom = document.getElementById("blCreationDateFrom").value;
		var blCreationDateTo = document.getElementById("blCreationDateTo").value;
		var igmservice = document.getElementById("igmservice").value;
		var vessel = document.getElementById("vessel").value;
		var voyage = document.getElementById("voyage").value;
		var direction = document.getElementById("direction").value;
		var pol = document.getElementById("pol").value;
		var polTerminal = document.getElementById("polTerminal").value;
		var pod = document.getElementById("pod").value;
		var podTerminal = document.getElementById("podTerminal").value;
		var del = document.getElementById("del").value;
		var depot = document.getElementById("depo").value;

		/* get value for 25 fields */

		var customCode = document.getElementById("customCode").value;
		var callSign = document.getElementById("callSign").value;
		var imoCode = document.getElementById("imoCode").value;
		var agentCode = document.getElementById("agentCode").value;
		var lineCode = document.getElementById("lineCode").value;
		var portOrigin = document.getElementById("portOrigin").value;
		var prt1 = document.getElementById("prt1").value;
		var prt2 = document.getElementById("prt2").value;
		var prt3 = document.getElementById("prt3").value;
		
		var last1 = document.getElementById("nprt1").value;
		var last2 = document.getElementById("nprt2").value;
		var last3 = document.getElementById("nprt3").value;
		
		var portOfArrival = document.getElementById("portOfArrival").value;
		var VesselTypes = document.getElementById("cont").value;
		var generalDescription = document.getElementById("generalDescription").value;
		var NationalityOfVessel = document.getElementById("nov").value;
		var MasterName = document.getElementById("mn").value;
		var igmNo = document.getElementById("igmNo").value;
		var igmDate = document.getElementById("igmDate").value;
		var aDate = document.getElementById("aDate").value;
		var aTime = document.getElementById("aTime").value;
		var ataAd = document.getElementById("ataAd").value;
		var ataAt = document.getElementById("ataAt").value;
		var totalItem = document.getElementById("totalItem").value;
		var LighthouseDue = document.getElementById("lhd").value;
		var GrossWeightVessel = document.getElementById("gwv").value;
		var NetWeightVessel = document.getElementById("nwv").value;
		var SameBottomCargo = document.getElementById("smbc").value;
		var ShipStoreDeclaration = document.getElementById("shsd").value;
		var CrewListDeclaration = document.getElementById("crld").value;
		var CargoDeclaration = document.getElementById("card").value;
		var PassengerList = document.getElementById("pasl").value;
		var CrewEffect = document.getElementById("cre").value;
		var MaritimeDeclaration = document.getElementById("mard").value;
		//NEW FIELD FOR VESSEL VOYAGE
		var departureManifestNumber=document.getElementById("departMainnumber").value;
		var departureManifestDate=document.getElementById("departMaindate").value;
		var submitterType=document.getElementById("submitTypet").value;
		var submitterCode=document.getElementById("submitCode").value;
		var authorizedRepresentativeCode=document.getElementById("authorizRepcode").value;
		var shippingLineBondNumber=document.getElementById("shiplineBondnumber").value;
		var modeofTransport=document.getElementById("modofTransport").value;
		var shipType=document.getElementById("shipType").value;
		var conveyanceReferenceNumber=document.getElementById("convanceRefnum").value;
		var totalNoofTransportEquipmentManifested=document.getElementById("totalnotRaneqpmin").value;
		var cargoDescription=document.getElementById("cargoDescrip").value;
		var briefCargoDescription=document.getElementById("briefCargodescon").value;
		var expectedDate=document.getElementById("expdate").value;
		var timeofDeparture=document.getElementById("timeofdep").value;
		var totalnooftransportcontractsreportedonArrivalDeparture=document.getElementById("tonotransrepoaridep").value;
		var messtype=document.getElementById("mesType").value;
		var vesType=document.getElementById("vesType").value;
		var authoseaCarcode=document.getElementById("authoseaCarcode").value;
		var portoDreg=document.getElementById("portoDreg").value;
		var regDate=document.getElementById("regDate").value;
		var voyDetails=document.getElementById("voyDetails").value;
		var shipItiseq=document.getElementById("shipItiseq").value;
		var shipItinerary=document.getElementById("shipItinerary").value;
		var portofCallname=document.getElementById("portofCallname").value;
		var arrivalDepdetails=document.getElementById("arrivalDepdetails").value;
		var totalnoTransarrivdep=document.getElementById("totalnoTransarrivdep").value;

		for (var i = 0; i < listOfVesselVoyageSearchDetails.length; i++) {

			if (document.getElementById(listOfVesselVoyageSearchDetails[i].id).checked == true) {
				vesselIndex=i;
				var eachVesselVoyageSearchDetailsRow = {};

				fitn = eachVesselVoyageSearchDetailsRow["From Item No"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["From Item No"]).value;
				eachVesselVoyageSearchDetailsRow["New Vessel"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["New Vessel"]).value;
				eachVesselVoyageSearchDetailsRow["New Voyage"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["New Voyage"]).value;
				eachVesselVoyageSearchDetailsRow["Port"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Port"]).value;
				containerPOD=document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Port"]).value;
				eachVesselVoyageSearchDetailsRow["Road Carr code"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Road Carr code"]).value;
				eachVesselVoyageSearchDetailsRow["Service"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Service"]).value;
				eachVesselVoyageSearchDetailsRow["TP Bond No"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["TP Bond No"]).value;
				eachVesselVoyageSearchDetailsRow["Terminal"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Terminal"]).value;
				titn = eachVesselVoyageSearchDetailsRow["To Item No"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["To Item No"]).value;
				eachVesselVoyageSearchDetailsRow["Vessel"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Vessel"]).value;
				containrtVessel=document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Vessel"]).value;
				eachVesselVoyageSearchDetailsRow["Voyage"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Voyage"]).value;
				caontainrVoyage=document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Voyage"]).value;
				eachVesselVoyageSearchDetailsRow["Pol"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Pol"]).value;
				eachVesselVoyageSearchDetailsRow["Pol Terminal"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Pol Terminal"]).value;
				eachVesselVoyageSearchDetailsRow["DEL VLS"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["DEL VLS"]).value;
				eachVesselVoyageSearchDetailsRow["DEPOT VLS"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["DEPOT VLS"]).value;
				eachVesselVoyageSearchDetailsRow["Custom Terminal Code"] = document
				.getElementById(listOfVesselVoyageSearchDetails[i]["Custom Terminal Code"]).value;

				listOfVesselVoyageSearchDetailsPrepraedJson
				.push(eachVesselVoyageSearchDetailsRow);
			}
		}
		var tempItemNo=(Number(fitn));

		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			var listOfBlDetails = {};
			var blnoforpopupdata;
			if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true) {
				blnoforpopupdata=document
				.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
				listOfBlDetails["BL#"] = document
				.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
				listOfBlDetails["BL_Date"] = document
				.getElementById(idJsonObjectForTextBox[i]["BL_Date"]).value;
				listOfBlDetails["BL Status"] = document
				.getElementById(idJsonObjectForTextBox[i]["BL Status"]).value;
				listOfBlDetails["CFS-Custom Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["CFS-Custom Code"]).value;
				listOfBlDetails["Cargo Movement"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
				listOfBlDetails["Cargo Movement Type"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Movement Type"]).value;
				listOfBlDetails["Cargo Nature"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Nature"]).value;

				if(document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value!="")
				{
					listOfBlDetails["Item Number"] =document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value;
				}else{
					for(k=0;k<checkHandlerArray.length;k++) {
						if(tempItemNo==Number(checkHandlerArray[k]))
						{
							tempItemNo=Number(checkHandlerArray[k])+1;
							k=-1;
						}
					}
					listOfBlDetails["Item Number"] =""+ tempItemNo;
					tempItemNo++;
				}
				listOfBlDetails["Item Type"] = document
				.getElementById(idJsonObjectForTextBox[i]["Item Type"]).value;
				listOfBlDetails["Road Carr code"] = document
				.getElementById(idJsonObjectForTextBox[i]["Road Carr code"]).value;
				listOfBlDetails["TP Bond No"] = document
				.getElementById(idJsonObjectForTextBox[i]["TP Bond No"]).value;
				if(document.getElementById(idJsonObjectForTextBox[i]["Submit Date Time"]).value=="")
				{
					var date = new Date();
					var newdate = moment(date).format("DD/MM/YYYY HH:mm");
					listOfBlDetails["Submit Date Time"] =newdate;
				}else
				{
					listOfBlDetails["Submit Date Time"] =document
					.getElementById(idJsonObjectForTextBox[i]["Submit Date Time"]).value;
				}
				listOfBlDetails["Transport Mode"] = document
				.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
				listOfBlDetails["DPD Movement"] = document
				.getElementById(idJsonObjectForTextBox[i]["DPD Movement"]).value;
				listOfBlDetails["DPD Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["DPD Code"]).value;
				listOfBlDetails["BL Version"] = document
				.getElementById(idJsonObjectForTextBox[i]["BL Version"]).value;
				listOfBlDetails["Is Present"] = document
				.getElementById(idJsonObjectForTextBox[i]["Is Present"]).value;
				listOfBlDetails["Custom ADD1"] = document
				.getElementById(idJsonObjectForTextBox[i]["Custom ADD1"]).value;
				listOfBlDetails["Custom ADD2"] = document
				.getElementById(idJsonObjectForTextBox[i]["Custom ADD2"]).value;
				listOfBlDetails["Custom ADD3"] = document
				.getElementById(idJsonObjectForTextBox[i]["Custom ADD3"]).value;
				listOfBlDetails["Custom ADD4"] = document
				.getElementById(idJsonObjectForTextBox[i]["Custom ADD4"]).value;
				listOfBlDetails["Package BL Level"] = document
				.getElementById(idJsonObjectForTextBox[i]["Package BL Level"]).value;
				listOfBlDetails["Gross Cargo Weight BL level"] = document
				.getElementById(idJsonObjectForTextBox[i]["Gross Cargo Weight BL level"]).value;
				
				listOfBlDetails["Consolidated Indicator"] = document
				.getElementById(idJsonObjectForTextBox[i]["Consolidated Indicator"]).value;
				listOfBlDetails["Previous Declaration"] = document
				.getElementById(idJsonObjectForTextBox[i]["Previous Declaration"]).value;
				listOfBlDetails["Consolidator PAN"] = document
				.getElementById(idJsonObjectForTextBox[i]["Consolidator PAN"]).value;
				listOfBlDetails["CIN TYPE"] = document
				.getElementById(idJsonObjectForTextBox[i]["CIN TYPE"]).value;
				listOfBlDetails["MCIN"] = document
				.getElementById(idJsonObjectForTextBox[i]["MCIN"]).value;
				listOfBlDetails["CSN Submitted Type"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Submitted Type"]).value;
				listOfBlDetails["CSN Submitted by"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Submitted by"]).value;
				listOfBlDetails["CSN Reporting Type"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Reporting Type"]).value;
				listOfBlDetails["CSN Site ID"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Site ID"]).value;
				listOfBlDetails["CSN Number"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Number"]).value;
				listOfBlDetails["CSN Date"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Date"]).value;
				listOfBlDetails["Previous MCIN"] = document
				.getElementById(idJsonObjectForTextBox[i]["Previous MCIN"]).value;
				listOfBlDetails["Split Indicator"] = document
				.getElementById(idJsonObjectForTextBox[i]["Split Indicator"]).value;
				listOfBlDetails["Number of Packages"] = document
				.getElementById(idJsonObjectForTextBox[i]["Number of Packages"]).value;
				listOfBlDetails["Type of Package"] = document
				.getElementById(idJsonObjectForTextBox[i]["Type of Package"]).value;
				listOfBlDetails["First Port of Entry/Last Port of Departure"] = document
				.getElementById(idJsonObjectForTextBox[i]["First Port of Entry/Last Port of Departure"]).value;
				listOfBlDetails["Type Of Cargo"] = document
				.getElementById(idJsonObjectForTextBox[i]["Type Of Cargo"]).value;
				listOfBlDetails["Split Indicator List"] = document
				.getElementById(idJsonObjectForTextBox[i]["Split Indicator List"]).value;
				listOfBlDetails["Port of Acceptance"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Acceptance"]).value;
				listOfBlDetails["Port of Receipt"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Receipt"]).value;
				listOfBlDetails["UCR Typel"] = document
				.getElementById(idJsonObjectForTextBox[i]["UCR Type"]).value;
				listOfBlDetails["UCR Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["UCR Code"]).value;
				listOfBlDetails["Port of Acceptance Name"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Acceptance Name"]).value;
				listOfBlDetails["Port of Receipt Name"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Receipt Name"]).value;
				listOfBlDetails["PAN of notified party"] = document
				.getElementById(idJsonObjectForTextBox[i]["PAN of notified party"]).value;
				listOfBlDetails["Unit of weight"] = document
				.getElementById(idJsonObjectForTextBox[i]["Unit of weight"]).value;
				listOfBlDetails["Gross Volume"] = document
				.getElementById(idJsonObjectForTextBox[i]["Gross Volume"]).value;
				listOfBlDetails["Unit of Volume"] = document
				.getElementById(idJsonObjectForTextBox[i]["Unit of Volume"]).value;
				listOfBlDetails["Cargo Item Sequence No"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Item Sequence No"]).value;
				listOfBlDetails["Cargo Item Description"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Item Description"]).value;
				listOfBlDetails["UNO Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["UNO Code"]).value;
				listOfBlDetails["IMDG Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["IMDG Code"]).value;
				listOfBlDetails["Number of Packages Hidden"] = document
				.getElementById(idJsonObjectForTextBox[i]["Number of Packages Hidden"]).value;
				listOfBlDetails["Type of Packages Hidden"] = document
				.getElementById(idJsonObjectForTextBox[i]["Type of Packages Hidden"]).value;
				listOfBlDetails["Container Weight"] = document
				.getElementById(idJsonObjectForTextBox[i]["Container Weight"]).value;
				listOfBlDetails["Port of call sequence numbe"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of call sequence number"]).value;
				listOfBlDetails["Port of Call Coded"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Call Coded"]).value;
				listOfBlDetails["Next port of call coded"] = document
				.getElementById(idJsonObjectForTextBox[i]["Next port of call coded"]).value;
				listOfBlDetails["MC Location Customsl"] = document
				.getElementById(idJsonObjectForTextBox[i]["MC Location Customs"]).value;

				if(popupjson.popup[blnoforpopupdata].consignee[0].vaidation=="TRUE" && popupjson.popup[blnoforpopupdata].notifyParty[0].vaidation=="TRUE"
					&& popupjson.popup[blnoforpopupdata].containerDetailes[0].vaidation=="TRUE" && popupjson.popup[blnoforpopupdata].marksNumber[0].vaidation=="TRUE"){
					listOfBlDetails["BL Validate Flag"] = "TRUE";
				}else{
					listOfBlDetails["BL Validate Flag"] = "FAlSE";
				}
				listOfBlDetails["flag"] = "TRUE";
				blDetails.push(listOfBlDetails);

				/*create json for consignee */

				//console.log(popupjson.popup);

				for(j=0;j<popupjson.popup[blnoforpopupdata].consignee.length;j++)
				{
					var listofconsignee={};
					listofconsignee["zip"]=popupjson.popup[blnoforpopupdata].consignee[j].zip;
					listofconsignee["blNO"]=popupjson.popup[blnoforpopupdata].consignee[j].blNO;
					listofconsignee["state"]=popupjson.popup[blnoforpopupdata].consignee[j].state;
					listofconsignee["customerName"]=popupjson.popup[blnoforpopupdata].consignee[j].customerName;
					listofconsignee["customerCode"]=popupjson.popup[blnoforpopupdata].consignee[j].customerCode;
					listofconsignee["countryCode"]=popupjson.popup[blnoforpopupdata].consignee[j].countryCode;
					listofconsignee["city"]=popupjson.popup[blnoforpopupdata].consignee[j].city;
					listofconsignee["addressLine1"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine1;
					listofconsignee["addressLine2"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine2;
					listofconsignee["addressLine3"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine3;
					listofconsignee["addressLine4"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine4;

					listOfconsigneeDetailsForSave.push(listofconsignee);
				}
				//  console.log(listOfconsigneeDetailsForSave);
				for(j=0;j<popupjson.popup[blnoforpopupdata].consigner.length;j++)
				{
					var listofconsigner={};
					listofconsigner["zip"]=popupjson.popup[blnoforpopupdata].consigner[j].zip;
					listofconsigner["blNO"]=popupjson.popup[blnoforpopupdata].consigner[j].blNO;
					listofconsigner["state"]=popupjson.popup[blnoforpopupdata].consigner[j].state;
					listofconsigner["customerName"]=popupjson.popup[blnoforpopupdata].consigner[j].customerName;
					listofconsigner["customerCode"]=popupjson.popup[blnoforpopupdata].consigner[j].customerCode;
					listofconsigner["countryCode"]=popupjson.popup[blnoforpopupdata].consigner[j].countryCode;
					listofconsigner["city"]=popupjson.popup[blnoforpopupdata].consigner[j].city;
					listofconsigner["addressLine1"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine1;
					listofconsigner["addressLine2"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine2;
					listofconsigner["addressLine3"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine3;
					listofconsigner["addressLine4"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine4;

					listOfconsignerDetailsForSave.push(listofconsigner);
				}
				/* create json for notify_party*/

				for(j=0;j<popupjson.popup[blnoforpopupdata].notifyParty.length;j++)
				{
					var listOfNotifyParty={};
					listOfNotifyParty["zip"]=popupjson.popup[blnoforpopupdata].notifyParty[j].zip;
					listOfNotifyParty["blNO"]=popupjson.popup[blnoforpopupdata].notifyParty[j].blNO;
					listOfNotifyParty["state"]=popupjson.popup[blnoforpopupdata].notifyParty[j].state;
					listOfNotifyParty["customerName"]=popupjson.popup[blnoforpopupdata].notifyParty[j].customerName;
					listOfNotifyParty["customerCode"]=popupjson.popup[blnoforpopupdata].notifyParty[j].customerCode;
					listOfNotifyParty["countryCode"]=popupjson.popup[blnoforpopupdata].notifyParty[j].countryCode;
					listOfNotifyParty["city"]=popupjson.popup[blnoforpopupdata].notifyParty[j].city;
					listOfNotifyParty["addressLine1"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine1;
					listOfNotifyParty["addressLine2"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine2;
					listOfNotifyParty["addressLine3"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine3;
					listOfNotifyParty["addressLine4"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine4;
					
					listOfNotifyPartyForSave.push(listOfNotifyParty);
				}
				//  console.log(listOfNotifyPartyForSave);

				/* create json for containerDetailes*/

				for(j=0;j<popupjson.popup[blnoforpopupdata].containerDetailes.length;j++)
				{
					var listofcontainerdetails={};
					var valueOfWeight=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerWeight;
					var valueOfPackage=popupjson.popup[blnoforpopupdata].containerDetailes[j].totalNumberOfPackagesInContainer;
					listofcontainerdetails["containerSize"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].ContainerSize;
					listofcontainerdetails["containerType"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].ContainerType;
					listofcontainerdetails["blNO"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].blNO;
					listofcontainerdetails["containerAgentCode"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerAgentCode;
					listofcontainerdetails["containerNumber"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerNumber;
					listofcontainerdetails["containerSealNumber"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerSealNumber;
					listofcontainerdetails["equipmentLoadStatus"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].equipmentLoadStatus;
					listofcontainerdetails["soc_flag"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].soc_flag;
					listofcontainerdetails["equipment_seal_type"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].equipment_seal_type;
					listofcontainerdetails["container_vessel"]=containrtVessel;
					listofcontainerdetails["container_voyage"]=caontainrVoyage;
					listofcontainerdetails["container_pod"]=containerPOD;
					
					if(valueOfWeight=="" || (Number(valueOfWeight)==0)){
						showBarMessages("Container weight can not be blank or 0.",1);
						document.getElementById(i+"Container Details").focus();
						document.getElementById(i+"Container Details").classList.add("roundshapError");
						EnableButton();
						return false;
					}
					else{
						listofcontainerdetails["containerWeight"]=valueOfWeight;
						document.getElementById(i+"Container Details").classList.remove("roundshapError")
						document.getElementById(i+"Container Details").classList.add("roundshap5");
					}
					listofcontainerdetails["status"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].status;
					if(valueOfPackage=="" || valueOfPackage==0){
						showBarMessages("Total No. of Package can not be blank or 0 in Container Details.",1);
						document.getElementById(i+"Container Details").focus();
						document.getElementById(i+"Container Details").classList.add("roundshapError");
						EnableButton();
						return false;
					}
					else{
						listofcontainerdetails["totalNumberOfPackagesInContainer"]=valueOfPackage;
						document.getElementById(i+"Container Details").classList.remove("roundshapError");
						document.getElementById(i+"Container Details").classList.add("roundshap5");
					}
					listofcontainerdetailsForSave.push(listofcontainerdetails);
				}
				//   console.log(listofcontainerdetailsForSave);

				for(j=0;j<popupjson.popup[blnoforpopupdata].marksNumber.length;j++)
				{
					var listofmarksNumberDtls={};
					listofmarksNumberDtls["description"]=popupjson.popup[blnoforpopupdata].marksNumber[j].description;
					listofmarksNumberDtls["blNO"]=popupjson.popup[blnoforpopupdata].marksNumber[j].blNO;
					listofmarksNumberDtls["marksNumbers"]=popupjson.popup[blnoforpopupdata].marksNumber[j].marksNumbers;

					listofmarksNumberDtlsForSave.push(listofmarksNumberDtls);
				}
				// console.log(listofmarksNumberDtlsForSave);

			}else{
				blnoforpopupdata=document
				.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
				listOfBlDetails["BL#"] = document
				.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
				listOfBlDetails["BL_Date"] = document
				.getElementById(idJsonObjectForTextBox[i]["BL_Date"]).value;
				listOfBlDetails["BL Status"] = document
				.getElementById(idJsonObjectForTextBox[i]["BL Status"]).value;
				listOfBlDetails["CFS-Custom Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["CFS-Custom Code"]).value;
				listOfBlDetails["Cargo Movement"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
				listOfBlDetails["Cargo Movement Type"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Movement Type"]).value;
				listOfBlDetails["Cargo Nature"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Nature"]).value;
				listOfBlDetails["Item Number"] = document
				.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value;
				listOfBlDetails["Item Type"] = document
				.getElementById(idJsonObjectForTextBox[i]["Item Type"]).value;
				listOfBlDetails["Road Carr code"] = document
				.getElementById(idJsonObjectForTextBox[i]["Road Carr code"]).value;
				listOfBlDetails["TP Bond No"] = document
				.getElementById(idJsonObjectForTextBox[i]["TP Bond No"]).value;
				listOfBlDetails["Submit Date Time"] = document
				.getElementById(idJsonObjectForTextBox[i]["Submit Date Time"]).value;
				listOfBlDetails["Transport Mode"] = document
				.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
				listOfBlDetails["DPD Movement"] = document
				.getElementById(idJsonObjectForTextBox[i]["DPD Movement"]).value;
				listOfBlDetails["DPD Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["DPD Code"]).value;
				listOfBlDetails["BL Version"] = document
				.getElementById(idJsonObjectForTextBox[i]["BL Version"]).value;
				listOfBlDetails["Is Present"] = document
				.getElementById(idJsonObjectForTextBox[i]["Is Present"]).value;
				listOfBlDetails["Custom ADD1"] = document
				.getElementById(idJsonObjectForTextBox[i]["Custom ADD1"]).value;
				listOfBlDetails["Custom ADD2"] = document
				.getElementById(idJsonObjectForTextBox[i]["Custom ADD2"]).value;
				listOfBlDetails["Custom ADD3"] = document
				.getElementById(idJsonObjectForTextBox[i]["Custom ADD3"]).value;
				listOfBlDetails["Custom ADD4"] = document
				.getElementById(idJsonObjectForTextBox[i]["Custom ADD4"]).value;
				listOfBlDetails["Package BL Level"] = document
				.getElementById(idJsonObjectForTextBox[i]["Package BL Level"]).value;
				listOfBlDetails["Gross Cargo Weight BL level"] = document
				.getElementById(idJsonObjectForTextBox[i]["Gross Cargo Weight BL level"]).value;
				listOfBlDetails["BL Validate Flag'"] = "FAlSE";
				listOfBlDetails["Package BL Level"]=document
				.getElementById(idJsonObjectForTextBox[i]["Package BL Level"]).value;
				listOfBlDetails["Gross Cargo Weight BL level"]=document
				.getElementById(idJsonObjectForTextBox[i]["Gross Cargo Weight BL level"]).value;
				
				listOfBlDetails["Consolidated Indicator"] = document
				.getElementById(idJsonObjectForTextBox[i]["Consolidated Indicator"]).value;
				listOfBlDetails["Previous Declaration"] = document
				.getElementById(idJsonObjectForTextBox[i]["Previous Declaration"]).value;
				listOfBlDetails["Consolidator PAN"] = document
				.getElementById(idJsonObjectForTextBox[i]["Consolidator PAN"]).value;
				listOfBlDetails["CIN TYPE"] = document
				.getElementById(idJsonObjectForTextBox[i]["CIN TYPE"]).value;
				listOfBlDetails["MCIN"] = document
				.getElementById(idJsonObjectForTextBox[i]["MCIN"]).value;
				listOfBlDetails["CSN Submitted Type"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Submitted Type"]).value;
				listOfBlDetails["CSN Submitted by"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Submitted by"]).value;
				listOfBlDetails["CSN Reporting Type"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Reporting Type"]).value;
				listOfBlDetails["CSN Site ID"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Site ID"]).value;
				listOfBlDetails["CSN Number"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Number"]).value;
				listOfBlDetails["CSN Date"] = document
				.getElementById(idJsonObjectForTextBox[i]["CSN Date"]).value;
				listOfBlDetails["Previous MCIN"] = document
				.getElementById(idJsonObjectForTextBox[i]["Previous MCIN"]).value;
				listOfBlDetails["Split Indicator"] = document
				.getElementById(idJsonObjectForTextBox[i]["Split Indicator"]).value;
				listOfBlDetails["Number of Packages"] = document
				.getElementById(idJsonObjectForTextBox[i]["Number of Packages"]).value;
				listOfBlDetails["Type of Package"] = document
				.getElementById(idJsonObjectForTextBox[i]["Type of Package"]).value;
				listOfBlDetails["First Port of Entry/Last Port of Departure"] = document
				.getElementById(idJsonObjectForTextBox[i]["First Port of Entry/Last Port of Departure"]).value;
				listOfBlDetails["Type Of Cargo"] = document
				.getElementById(idJsonObjectForTextBox[i]["Type Of Cargo"]).value;
				listOfBlDetails["Split Indicator List"] = document
				.getElementById(idJsonObjectForTextBox[i]["Split Indicator List"]).value;
				
				listOfBlDetails["Port of Acceptance"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Acceptance"]).value;
				listOfBlDetails["Port of Receipt"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Receipt"]).value;
				
				listOfBlDetails["UCR Typel"] = document
				.getElementById(idJsonObjectForTextBox[i]["UCR Type"]).value;
				listOfBlDetails["UCR Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["UCR Code"]).value;
				
				listOfBlDetails["Port of Acceptance Name"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Acceptance Name"]).value;
				listOfBlDetails["Port of Receipt Name"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Receipt Name"]).value;
				
				listOfBlDetails["PAN of notified party"] = document
				.getElementById(idJsonObjectForTextBox[i]["PAN of notified party"]).value;
				listOfBlDetails["Unit of weight"] = document
				.getElementById(idJsonObjectForTextBox[i]["Unit of weight"]).value;
				listOfBlDetails["Gross Volume"] = document
				.getElementById(idJsonObjectForTextBox[i]["Gross Volume"]).value;
				listOfBlDetails["Unit of Volume"] = document
				.getElementById(idJsonObjectForTextBox[i]["Unit of Volume"]).value;
				listOfBlDetails["Cargo Item Sequence No"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Item Sequence No"]).value;
				listOfBlDetails["Cargo Item Description"] = document
				.getElementById(idJsonObjectForTextBox[i]["Cargo Item Description"]).value;
				
				listOfBlDetails["UNO Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["UNO Code"]).value;
				listOfBlDetails["IMDG Code"] = document
				.getElementById(idJsonObjectForTextBox[i]["IMDG Code"]).value;
				
				listOfBlDetails["Number of Packages Hidden"] = document
				.getElementById(idJsonObjectForTextBox[i]["Number of Packages Hidden"]).value;
				
				listOfBlDetails["Type of Packages Hidden"] = document
				.getElementById(idJsonObjectForTextBox[i]["Type of Packages Hidden"]).value;
				listOfBlDetails["Container Weight"] = document
				.getElementById(idJsonObjectForTextBox[i]["Container Weight"]).value;
				
				
				listOfBlDetails["Port of call sequence numbe"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of call sequence number"]).value;
				listOfBlDetails["Port of Call Coded"] = document
				.getElementById(idJsonObjectForTextBox[i]["Port of Call Coded"]).value;
				listOfBlDetails["Next port of call coded"] = document
				.getElementById(idJsonObjectForTextBox[i]["Next port of call coded"]).value;
				listOfBlDetails["MC Location Customsl"] = document
				.getElementById(idJsonObjectForTextBox[i]["MC Location Customs"]).value;
				
				listOfBlDetails["flag"] = "FALSE";
				blDetails.push(listOfBlDetails);


				for(j=0;j<popupjson.popup[blnoforpopupdata].consignee.length;j++)
				{
					var listofconsignee={};
					listofconsignee["zip"]=popupjson.popup[blnoforpopupdata].consignee[j].zip;
					listofconsignee["blNO"]=popupjson.popup[blnoforpopupdata].consignee[j].blNO;
					listofconsignee["state"]=popupjson.popup[blnoforpopupdata].consignee[j].state;
					listofconsignee["customerName"]=popupjson.popup[blnoforpopupdata].consignee[j].customerName;
					listofconsignee["customerCode"]=popupjson.popup[blnoforpopupdata].consignee[j].customerCode;
					listofconsignee["countryCode"]=popupjson.popup[blnoforpopupdata].consignee[j].countryCode;
					listofconsignee["city"]=popupjson.popup[blnoforpopupdata].consignee[j].city;
					listofconsignee["addressLine1"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine1;
					listofconsignee["addressLine2"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine2;
					listofconsignee["addressLine3"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine3;
					listofconsignee["addressLine4"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine4;

					listOfconsigneeDetailsForSave.push(listofconsignee);
				}
				//  console.log(listOfconsigneeDetailsForSave);
				for(j=0;j<popupjson.popup[blnoforpopupdata].consigner.length;j++)
				{
					var listofconsigner={};
					listofconsigner["zip"]=popupjson.popup[blnoforpopupdata].consigner[j].zip;
					listofconsigner["blNO"]=popupjson.popup[blnoforpopupdata].consigner[j].blNO;
					listofconsigner["state"]=popupjson.popup[blnoforpopupdata].consigner[j].state;
					listofconsigner["customerName"]=popupjson.popup[blnoforpopupdata].consigner[j].customerName;
					listofconsigner["customerCode"]=popupjson.popup[blnoforpopupdata].consigner[j].customerCode;
					listofconsigner["countryCode"]=popupjson.popup[blnoforpopupdata].consigner[j].countryCode;
					listofconsigner["city"]=popupjson.popup[blnoforpopupdata].consigner[j].city;
					listofconsigner["addressLine1"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine1;
					listofconsigner["addressLine2"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine2;
					listofconsigner["addressLine3"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine3;
					listofconsigner["addressLine4"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine4;

					listOfconsignerDetailsForSave.push(listofconsigner);
				}
				/* create json for notify_party*/

				for(j=0;j<popupjson.popup[blnoforpopupdata].notifyParty.length;j++)
				{
					var listOfNotifyParty={};
					listOfNotifyParty["zip"]=popupjson.popup[blnoforpopupdata].notifyParty[j].zip;
					listOfNotifyParty["blNO"]=popupjson.popup[blnoforpopupdata].notifyParty[j].blNO;
					listOfNotifyParty["state"]=popupjson.popup[blnoforpopupdata].notifyParty[j].state;
					listOfNotifyParty["customerName"]=popupjson.popup[blnoforpopupdata].notifyParty[j].customerName;
					listOfNotifyParty["customerCode"]=popupjson.popup[blnoforpopupdata].notifyParty[j].customerCode;
					listOfNotifyParty["countryCode"]=popupjson.popup[blnoforpopupdata].notifyParty[j].countryCode;
					listOfNotifyParty["city"]=popupjson.popup[blnoforpopupdata].notifyParty[j].city;
					listOfNotifyParty["addressLine1"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine1;
					listOfNotifyParty["addressLine2"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine2;
					listOfNotifyParty["addressLine3"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine3;
					listOfNotifyParty["addressLine4"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine4;
					listOfNotifyPartyForSave.push(listOfNotifyParty);
				}
				//  console.log(listOfNotifyPartyForSave);

				/* create json for containerDetailes*/

				/*for(j=0;j<popupjson.popup[blnoforpopupdata].containerDetailes.length;j++)
				{
					var listofcontainerdetails={};
					listofcontainerdetails["ISOCode"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].ISOCode;
					listofcontainerdetails["blNO"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].blNO;
					listofcontainerdetails["containerAgentCode"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerAgentCode;
					listofcontainerdetails["containerNumber"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerNumber;
					listofcontainerdetails["containerSealNumber"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerSealNumber;
					listofcontainerdetails["containerWeight"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerWeight;
					listofcontainerdetails["status"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].status;
					listofcontainerdetails["totalNumberOfPackagesInContainer"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].totalNumberOfPackagesInContainer;

					listofcontainerdetailsForSave.push(listofcontainerdetails);
				}*/
				//   console.log(listofcontainerdetailsForSave);

				for(j=0;j<popupjson.popup[blnoforpopupdata].marksNumber.length;j++)
				{
					var listofmarksNumberDtls={};
					listofmarksNumberDtls["description"]=popupjson.popup[blnoforpopupdata].marksNumber[j].description;
					listofmarksNumberDtls["blNO"]=popupjson.popup[blnoforpopupdata].marksNumber[j].blNO;
					listofmarksNumberDtls["marksNumbers"]=popupjson.popup[blnoforpopupdata].marksNumber[j].marksNumbers;

					listofmarksNumberDtlsForSave.push(listofmarksNumberDtls);
				}
				// console.log(listofmarksNumberDtlsForSave);

			}
		}
		if (fitn == "") {
			showBarMessages("From Item No. is required.",1);
			EnableButton();
			return false;
		} else if (titn == "") {
			showBarMessages("To Item No. is required.",1);
			EnableButton();
			return false;
		}
		else if (Number(fitn) > Number(titn)) {
			showBarMessages("To Item No must be greater than From Item No.",1);
			EnableButton();
			return false;
		}
		else if(Number((document.getElementById("totalItem").value))>((Number(titn)-Number(fitn))+1))
		{
			showBarMessages("Enter valid range as per Selected no of BL",1);
			EnableButton();
			return false;
		}



		//console.log(blDetails);
		$.ajax({
			method : "POST",
			async : true,
			url : ONSAVE,
			beforeSend:function()
			{
				loadingfun();
			},
			data : {
				inStatus : inStatus,
				blCreationDateFrom : blCreationDateFrom,
				blCreationDateTo : blCreationDateTo,
				igmservice : igmservice,
				vessel : vessel,
				voyage : voyage,
				direction : direction,
				pol : pol,
				polTerminal : polTerminal,
				pod : pod,
				podTerminal : podTerminal,
			    del : del,
			    depot : depot,
				customCode : customCode,
				callSign : callSign,
				imoCode : imoCode,
				agentCode : agentCode,
				lineCode : lineCode,
				portOrigin : portOrigin,
				prt1 : prt1,
				prt2 : prt2,
				prt3 : prt3,
				last1 :last1,
				last2 : last2,
				last3 : last3,
				portOfArrival : portOfArrival,
				vesselTypes : VesselTypes,
				generalDescription : generalDescription,
				nationalityOfVessel : NationalityOfVessel,
				masterName : MasterName,
				igmNo : igmNo,
				igmDate : igmDate,
				aDate : aDate,
				aTime : aTime,
				ataAd : ataAd,
				ataAt : ataAt,
				totalItem : totalItem,
				lighthouseDue : LighthouseDue,
				grossWeightVessel : GrossWeightVessel,
				netWeightVessel : NetWeightVessel,
				sameBottomCargo : SameBottomCargo,
				shipStoreDeclaration : ShipStoreDeclaration,
				crewListDeclaration : CrewListDeclaration,
				cargoDeclaration : CargoDeclaration,
				passengerList : PassengerList,
				crewEffect : CrewEffect,
				maritimeDeclaration : MaritimeDeclaration,
				
				departureManifestNumber:departureManifestNumber,
				departureManifestDate:departureManifestDate,
				submitterType:submitterType,
				submitterCode:submitterCode,
				authorizedRepresentativeCode:authorizedRepresentativeCode,
				shippingLineBondNumber:shippingLineBondNumber,
				modeofTransport:modeofTransport,
				shipType:shipType,
				conveyanceReferenceNumber:conveyanceReferenceNumber,
				totalNoofTransportEquipmentManifested:totalNoofTransportEquipmentManifested,
				cargoDescription:cargoDescription,
				briefCargoDescription:briefCargoDescription,
				expectedDate:expectedDate,
				timeofDeparture:timeofDeparture,
				totalnooftransportcontractsreportedonArrivalDeparture:totalnooftransportcontractsreportedonArrivalDeparture,
				messtype:messtype,
				vesType:vesType,
				authoseaCarcode:authoseaCarcode,
				portoDreg:portoDreg,
				regDate:regDate,
				voyDetails:voyDetails,
				shipItiseq:shipItiseq,
				shipItinerary:shipItinerary,
				portofCallname:portofCallname,
				arrivalDepdetails:arrivalDepdetails,
				totalnoTransarrivdep:totalnoTransarrivdep,
				
				BLDetails : JSON.stringify(blDetails),
				vesselVoyageDtls : JSON
				.stringify(listOfVesselVoyageSearchDetailsPrepraedJson),
				consigneeDtls : JSON
				.stringify(listOfconsigneeDetailsForSave),
				consignerDtlstls : JSON
				.stringify(listOfconsignerDetailsForSave),
				notifyPartyDlts:JSON
				.stringify(listOfNotifyPartyForSave),
				containerDetailsDtls:JSON
				.stringify(listofcontainerdetailsForSave),
				marksNumberDtlstls:JSON
				.stringify(listofmarksNumberDtlsForSave)
			},
			success : function(result) {
				/**enable all button search section*/
				EnableButton();
				//console.log(result);
				result2 = JSON.parse(result);
				//console.log(result1);
				checkSubmit = true;
				document.getElementById("generatetype").disabled = false;
				document.getElementById("manifestfilegeneratoredifile").disabled = false;
				onLoadAreterSAved();
				var mgsnull=document.getElementById("msg");
				mgsnull.innerHTML = '';
				showBarMessages("IGM details saved successfully.",0);
			},
			error : function(e) {
				showBarMessages(error,1);
			}
		})
	}

}

/*
 * ToItemOnblurHandler function started
 */

function ToItemOnblurHandler(selectObject) {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var newValue=selectObject.value;
	var newId=selectObject.id;

	if(isNaN(newValue))
	{
		document.getElementById(newId).value="";
		return false;
	}
	for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
		if (document.getElementsByName("rowSelectedVV")[x].checked) {

			var fromitemno = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["From Item No"]).value;
			var toitemno = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["To Item No"]).value;
			var blcount = result1.result[x]["BLS"].length;
			if (Number(fromitemno) > Number(toitemno)) {
				showBarMessages("To Item No must be greater than From Item No.",1);
				return false;
			}
			else {
				return true;
			}
		}
	}
}

/*
 * ToItemOnblurHandler function ended
 */

function FromItemOnblurHandler(selectObject) {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var newFromItemNoValue=selectObject.value;
	var newId=selectObject.id;
	var fromitemno="";
	var toitemno="";
	var TOtalnoofBL;
	if(isNaN(newFromItemNoValue))
	{
		document.getElementById(newId).value="";
		showBarMessages("From Item NO. should be a no.",1);
		return false;
	}
	for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
		if (document.getElementsByName("rowSelectedVV")[x].checked) {

			fromitemno = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["From Item No"]).value;
			/*var toitemno = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["To Item No"]).value;*/
			if(fromitemno=='')
			{
				document.getElementById(listOfVesselVoyageSearchDetails[x]["To Item No"]).value="";
			}
			else{
				TOtalnoofBL=result1.result[0].BLS.length;
				//console.log(TOtalnoofBL);
				document.getElementById(listOfVesselVoyageSearchDetails[x]["To Item No"]).value=Number(fromitemno)+Number(TOtalnoofBL)-1;
			}
		}
	}


	//console.log(checkHandlerArray.length);
	if(checkHandlerArray.length!=0)
	{
		checkHandlerArray=[];
		saveddataForcheckHandler=[];
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true) {

				document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value="";
			}
		}
	}
	//console.log(checkHandlerArray.length);
	//console.log(checkHandlerArray);
	/*if ((Number(fromitemno) > Number(toitemno))
			&& (Number(toitemno) != "")) {
		showBarMessages("To Item No must be greater than From Item No.");
		return false;
	}*/



}
/*roadCarrCodeHandler() started */


function roadCarrCodeHandle(selectObject)
{ 
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var roadCarrCodevalue="";
	var CargoMovementValue="";
	var TransportModeValue="";
	var checkedRow="";

	for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
		if (document.getElementsByName("rowSelectedVV")[x].checked) {
			checkedRow=x;
			var roadCarrCodevalue = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["Road Carr code"]).value;
			//console.log("roadCarrCodevalue ......."+roadCarrCodevalue);
		}
	}

	if(roadCarrCodevalue!="")
	{
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			//if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true){
			CargoMovementValue= document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
			TransportModeValue= document.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
			if ((CargoMovementValue=="TI")&&(TransportModeValue=="R")) {
				document.getElementById(idJsonObjectForTextBox[i]["Road Carr code"]).value=roadCarrCodevalue;
				document.getElementById(i + "Road Carr code").readOnly = true;
			}
		}
		document.getElementById(checkedRow+"-"+"TP Bond No").disabled=false;	
		var tpBondNoObj=document.getElementById(checkedRow +"-"+"TP Bond No");
		tpBondNoObj.innerHTML = '';
		var elem2 = document.createElement("option");
		elem2.text =  "Select One option";
		elem2.value="";
		tpBondNoObj.appendChild(elem2);
		for(var i=0;i<result1.DropDown.TPBondNoDropdown[roadCarrCodevalue].length;i++)
			{
			var elem3 = document.createElement("option");
			elem3.text = result1.DropDown.TPBondNoDropdown[roadCarrCodevalue][i]["partnerValuedre"];
			elem3.title =result1.DropDown.TPBondNoDropdown[roadCarrCodevalue][i]["descriptiondrw"];
			tpBondNoObj.appendChild(elem3);
			}
	}
	else{
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			//if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true){
			CargoMovementValue= document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
			TransportModeValue= document.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
			if ((CargoMovementValue=="TI")&&(TransportModeValue=="R")) {
				document.getElementById(idJsonObjectForTextBox[i]["Road Carr code"]).value="";
				document.getElementById(i + "Road Carr code").readOnly = false;
			}
		} 
		var tpBondNoObj=document.getElementById(checkedRow+"-"+"TP Bond No");
		//console.log(tpBondNoObj);
		tpBondNoObj.innerHTML = '';
		var elem2 = document.createElement("option");
		elem2.text =  "Select One option";
		elem2.value="";
		tpBondNoObj.appendChild(elem2);
		document.getElementById(checkedRow+"-"+"TP Bond No").disabled=true;
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			//if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true){
			CargoMovementValue= document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
			TransportModeValue= document.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
			if ((CargoMovementValue=="TI")&&(TransportModeValue=="R")) {
				document.getElementById(idJsonObjectForTextBox[i]["TP Bond No"]).value="";
				document.getElementById(i + "TP Bond No").readOnly = false;
			}
		}
	}
	
}
/*roadCarrCodeHandler() ended*/ 

/*tPBondNoHnadler() started*/

function tPBondNoHnadler(selectObject)
{
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var CargoMovementValue="";
	var tPBondNovalue="";
	var TransportModeValue="";
	for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
		if (document.getElementsByName("rowSelectedVV")[x].checked) {

			var tPBondNovalue = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["TP Bond No"]).value;
		}
	}
	if(tPBondNovalue!="")
	{
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			//if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true){
			CargoMovementValue= document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
			TransportModeValue= document.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
			if ((CargoMovementValue=="TI")&&(TransportModeValue=="R")) {
				document.getElementById(idJsonObjectForTextBox[i]["TP Bond No"]).value=tPBondNovalue;
				document.getElementById(i + "TP Bond No").readOnly = true;
			}
		}
	}
	else
	{
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			//if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true){
			CargoMovementValue= document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
			TransportModeValue= document.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
			if ((CargoMovementValue=="TI")&&(TransportModeValue=="R")) {
				document.getElementById(idJsonObjectForTextBox[i]["TP Bond No"]).value="";
				document.getElementById(i + "TP Bond No").readOnly = false;
			}
		}
	}
}

function cfsHandler(selectObject)
{
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var CFSCustumCodeBLlevel="";
	var CFSCustumCodeVVlevel="";
	var CargoMovementValue="";

	for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {
		if (document.getElementsByName("rowSelectedVV")[x].checked) {

			var CFSCustumCodeVVlevel = document
			.getElementById(listOfVesselVoyageSearchDetails[x]["CFS Custom Code"]).value;
		}
	}
	if(CFSCustumCodeVVlevel!="")
	{
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			CargoMovementValue= document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
			if(CargoMovementValue=="LC"){
			document.getElementById(idJsonObjectForTextBox[i]["CFS-Custom Code"]).value=CFSCustumCodeVVlevel;
			document.getElementById(i + "CFS-Custom Code").readOnly = true;
			}
		}
	}
	else
	{
		for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
			CargoMovementValue= document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
			if(CargoMovementValue=="LC"){
			document.getElementById(idJsonObjectForTextBox[i]["CFS-Custom Code"]).value="";
			document.getElementById(i + "CFS-Custom Code").readOnly = false;
			}
		}
	}
}



function onLoadAreterSAved()
{
	/* for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {

	if (document.getElementsByName("rowSelectedVV")[x].checked) {

document.getElementById(x+"-"+"From Item No").value=result2.Savedresult[0]["service"].fromItemNo;
document.getElementById(x+"-"+"New Vessel").value=result2.Savedresult[0]["service"].newVoyage;
document.getElementById(x+"-"+"New Voyage").value=result2.Savedresult[0]["service"].newVessel;
document.getElementById(x+"-"+"Port").value=result2.Savedresult[0]["service"].pod;
document.getElementById(x+"-"+"Road Carr code").value=result2.Savedresult[0]["service"].roadCarrCodeVVS;
document.getElementById(x+"-"+"Service").value=result2.Savedresult[0]["service"].service;
document.getElementById(x+"-"+"TP Bond No").value=result2.Savedresult[0]["service"].roadTpBondNoVVSS;
document.getElementById(x+"-"+"Terminal").value=result2.Savedresult[0]["service"].terminal;
document.getElementById(x+"-"+"To Item No").value=result2.Savedresult[0]["service"].toItemNo;
document.getElementById(x+"-"+"Vessel").value=result2.Savedresult[0]["service"].vessel;
document.getElementById(x+"-"+"Voyage").value=result2.Savedresult[0]["service"].voyage;
document.getElementById(x+"-"+"Pol").value=result2.Savedresult[0]["service"].pol;
document.getElementById(x+"-"+"Pol Terminal").value=result2.Savedresult[0]["service"].polTerminal;

	}  
}*/
	var vasselVoyageindex=vesselIndex;
	checkHandlerArray=[];
	newResult = [];
	saveddataForcheckHandler=[];
	idJsonObjectForTextBox = [];
	
	document.getElementById("checkIgmInfo").disabled = true;
	document.getElementById("checkBLInfo").disabled = true;
	document.getElementById("checkIgmInfo").checked = false;
	document.getElementById("checkBLInfo").checked  = false;
//	console.log("idJsonObjectForTextBox saved:"+idJsonObjectForTextBox);
	var x=0;

	/*for (var x = 0; x < document.getElementsByName("rowSelectedVV").length; x++) {*/

	/*if (document.getElementsByName("rowSelectedVV")[x].checked) {*/
	//console.log(document.getElementsByName("rowSelectedVV")[x]);

	for (f = 0; f < result2.Savedresult[0]['BLS'].length; f++) {
		if (result2.Savedresult[0]["BLS"][f].itemNumber != "") {
			checkHandlerArray.push(result2.Savedresult[0]["BLS"][f].itemNumber);
		}
	}
	//console.log("checkHandlerArray saved :"+checkHandlerArray);
	for (r = 0; r < result2.Savedresult[x]['BLS'].length;r++) {
		if ((result2.Savedresult[x]["BLS"][r].itemNumber != "")&&(result2.Savedresult[x]["BLS"][r].igmNumber != "")) {
			newResult.push(result2.Savedresult[x]["BLS"][r]);
		}
	}
	//console.log("newResult saved :"+newResult);
	for (b = 0; b < result2.Savedresult[x]['BLS'].length; b++) {
		if (result2.Savedresult[x]["BLS"][b].itemNumber != "") {
			saveddataForcheckHandler.push(result2.Savedresult[x]["BLS"][b]);
		}
	}
	//console.log("saveddataForcheckHandler saved :"+saveddataForcheckHandler);
	var fromitemno = document
	.getElementById(listOfVesselVoyageSearchDetails[x]["From Item No"]).value;
	var Toitemno = document
	.getElementById(listOfVesselVoyageSearchDetails[x]["To Item No"]).value;

	document.getElementById("customCode").value = result2.Savedresult[x]["service"].codeCode;
	document.getElementById("callSign").value = result2.Savedresult[x]["service"].callSing;
	document.getElementById("imoCode").value = result2.Savedresult[x]["service"].imoCode;
	document.getElementById("agentCode").value = result2.Savedresult[x]["service"].agentCode;
	document.getElementById("lineCode").value = result2.Savedresult[x]["service"].lineCode;
	document.getElementById("portOrigin").value = result2.Savedresult[x]["service"].portOrigin;
	document.getElementById("prt1").value = result2.Savedresult[x]["service"].lastPort1;
	document.getElementById("prt2").value = result2.Savedresult[x]["service"].lastPort2;
	document.getElementById("prt3").value = result2.Savedresult[x]["service"].lastPort3;
	
	document.getElementById("nprt1").value = result2.Savedresult[x]["service"].nextport1;
	document.getElementById("nprt2").value = result2.Savedresult[x]["service"].nextport2;
	document.getElementById("nprt3").value = result2.Savedresult[x]["service"].nextport3;
	
	document.getElementById("portOfArrival").value = result2.Savedresult[x]["service"].portArrival;
	document.getElementById("nov").value = result2.Savedresult[x]["service"].vesselNation;
	document.getElementById("mn").value = result2.Savedresult[x]["service"].masterName;
	if (result2.Savedresult[x]["service"].igmNumber != '') {
		document.getElementById("igmNo").value = result2.Savedresult[x]["service"].igmNumber;
		document.getElementById("igmNo").readOnly = true;
		document.getElementById("checkIgmInfo").disabled = false;
		document.getElementById("checkBLInfo").disabled = false;
		$("#igmDate").datepicker('disable');
	}
	document.getElementById("igmDate").value = result2.Savedresult[x]["service"].igmDate;
	document.getElementById("aDate").value = result2.Savedresult[x]["service"].arrivalDate;
	document.getElementById("aTime").value = result2.Savedresult[x]["service"].arrivalTime;
	if(result2.Savedresult[x]["service"].ataarrivalDate !="")
	{
		var ataDate =result2.Savedresult[x]["service"].ataarrivalDate;
		$("#ataAd").datepicker();
		$("#ataAd").datepicker("option", "dateFormat", "dd/mm/yy");
		var currentDate = moment(ataDate, 'DD/MM/YYYY');
		var cDate = moment(currentDate).format('DD/MM/YYYY');
		document.getElementById("ataAd").value=cDate;
	}
	else
	{
		$("#ataAd").datepicker();
		$("#ataAd").datepicker("option", "dateFormat", "dd/mm/yy");
		var ArrivalDateupdate = new Date();
		var currentDate = moment(ArrivalDateupdate).format('DD/MM/YYYY');
		$("#ataAd").val(currentDate);
	}
	if(result2.Savedresult[x]["service"].ataarrivalTime !="")
	{
		var ataTime = result2.Savedresult[x]["service"].ataarrivalTime;
		$('#ataAt').timepicker();
		$('#ataAt').timepicker({ 'timeFormat': 'H:i' });
		var currentTime = moment(ataTime, 'H:mm');
		var currentTime = moment(currentTime).format('H:mm');
		$("#ataAt").val(currentTime);
	}
	else
	{
		$('#ataAt').timepicker({ 'timeFormat': 'H:i' });
		//$('#ataAt').timepicker({ 'interval' : 15 });
		$('#ataAt').timepicker('setTime', new Date());
	}
	document.getElementById("totalItem").value = result2.Savedresult[x]["service"].totalBls;
	document.getElementById("lhd").value = result2.Savedresult[x]["service"].lightDue;
	document.getElementById("gwv").value = result2.Savedresult[x]["service"].grossWeight;
	document.getElementById("nwv").value = result2.Savedresult[x]["service"].netWeight;
	// document.getElementById("igmDate").value =
	// result2.result[x]["service"].igmDate;
	document.getElementById("smbc").value = result2.Savedresult[x]["service"].smBtCargo;
	document.getElementById("shsd").value = result2.Savedresult[x]["service"].shipStrDect;
	document.getElementById("crld").value = result2.Savedresult[x]["service"].crewListDeclaration;
	document.getElementById("card").value = result2.Savedresult[x]["service"].cargoDeclaration;
	document.getElementById("pasl").value = result2.Savedresult[x]["service"].passengerList;
	document.getElementById("cre").value = result2.Savedresult[x]["service"].crewEffect;
	document.getElementById("mard").value = result2.Savedresult[x]["service"].mariTimeDecl;
	
	//new field
	document.getElementById("departMainnumber").value = result2.Savedresult[x]["service"].dep_manif_no;
	document.getElementById("departMaindate").value = result2.Savedresult[x]["service"].dep_manifest_date;
	if(result2.Savedresult[x]["service"].submitter_type!=""){
	document.getElementById("submitTypet").value = result2.Savedresult[x]["service"].submitter_type;}
	document.getElementById("submitCode").value = result2.Savedresult[x]["service"].submitter_code;
	document.getElementById("authorizRepcode").value = result2.Savedresult[x]["service"].authoriz_rep_code;
	document.getElementById("shiplineBondnumber").value = result2.Savedresult[x]["service"].shipping_line_bond_no_r;
	if(result2.Savedresult[x]["service"].mode_of_transport!=""){
	document.getElementById("modofTransport").value = result2.Savedresult[x]["service"].mode_of_transport;}
	document.getElementById("shipType").value = result2.Savedresult[x]["service"].ship_type;
	document.getElementById("convanceRefnum").value = result2.Savedresult[x]["service"].conveyance_reference_no;
	document.getElementById("totalnotRaneqpmin").value = result2.Savedresult[x]["service"].tol_no_of_trans_equ_manif;
	document.getElementById("cargoDescrip").value = result2.Savedresult[x]["service"].cargo_description;
	document.getElementById("briefCargodescon").value = result2.Savedresult[x]["service"].brief_cargo_des;
	document.getElementById("expdate").value = result2.Savedresult[x]["service"].expected_date;
	document.getElementById("timeofdep").value = result2.Savedresult[x]["service"].time_of_dept;
	document.getElementById("tonotransrepoaridep").value = result2.Savedresult[x]["service"].total_no_of_tran_s_cont_repo_on_ari_dep;
	document.getElementById("mesType").value = result2.Savedresult[x]["service"].message_type;
	document.getElementById("vesType").value = result2.Savedresult[x]["service"].vessel_type_movement;
	document.getElementById("authoseaCarcode").value = result2.Savedresult[x]["service"].authorized_sea_carrier_code;
	document.getElementById("portoDreg").value = result2.Savedresult[x]["service"].port_of_registry;
	document.getElementById("regDate").value = result2.Savedresult[x]["service"].registry_date;
	document.getElementById("voyDetails").value = result2.Savedresult[x]["service"].voyage_details_movement;
	document.getElementById("shipItiseq").value = result2.Savedresult[x]["service"].ship_itinerary_sequence;
	document.getElementById("shipItinerary").value = result2.Savedresult[x]["service"].ship_itinerary;
	document.getElementById("portofCallname").value = result2.Savedresult[x]["service"].port_of_call_name;
	document.getElementById("arrivalDepdetails").value = result2.Savedresult[x]["service"].arrival_departure_details;
	document.getElementById("totalnoTransarrivdep").value = result2.Savedresult[x]["service"].total_no_of_transport_equipment_reported_on_arrival_departure;
	
	
	billdetail = document.getElementById("billAmount");
	billdetail.innerHTML = '';
	blsValueSavedObject = result2.Savedresult[x]["BLS"];
	for (i = 0; i < blsValueSavedObject.length; i++) {
		var idListForTextBox = {};
		var arrayofconsignee = [];
		var arrayofNotyfyparty=[];
		var arrayofmarksNumber = [];
		var arrayofcontainerDetailes=[];
		var arrayofconsigner = [];
		var element = document.createElement("input");
		element.setAttribute("type", "checkbox");
		element.setAttribute("name", "rowSelectedBL");
		element.setAttribute("id", i + "rowSelected");
		element.setAttribute('onclick', 'handlerforcheckbox(this);');
		idListForTextBox["id"] = i + "rowSelected";
		element.setAttribute("value", i);
		billdetail.appendChild(element);
		var element1 = document.createElement("input");
		element1.setAttribute("type", "text");
		element1.setAttribute("class", "seqCss");
		element1.setAttribute("value", i + 1);
		element1.setAttribute("readOnly", true);
		element1.setAttribute("name", i + "sequence");
		element1.setAttribute("id", i + "sequence");
		billdetail.appendChild(element1);

		for (var t = 2; t < bld.length; t++) {

			if(bld[t].columnName == "Cargo Nature")
			{

				var element1=document.createElement("select");
				//  element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallDPCss")
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				var CargoNaturevalue=blsValueSavedObject[i][bld[t].mappedCol]; 
				var el = document.createElement("option");
				var el2 = document.createElement("option");
				el.textContent = "C";
				el.value = "C";
				element1.appendChild(el);
				el2.textContent = "P";
				el2.value = "P";
				element1.appendChild(el2);
				//console.log(i + bld[t].columnName);
				//if(CargoNaturevalue!="")
				element1.value=CargoNaturevalue;
				
				if((blsValueSavedObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
				{
					element1.setAttribute("disabled", true);
				}
			}
			else if(bld[t].columnName == "Item Type")
			{
				var element1=document.createElement("select");
				//  element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallDPCss")
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				var ItemTypeValue=blsValueSavedObject[i][bld[t].mappedCol];
				var el = document.createElement("option");
				var el2 = document.createElement("option");
				var el3 = document.createElement("option");
				el.textContent = "OT";
				el.value = "OT";
				element1.appendChild(el);
				el2.textContent = "UB";
				el2.value = "UB";
				element1.appendChild(el2);
				el3.textContent = "GC";
				el3.value = "GC";
				element1.appendChild(el3);
				//if(ItemTypeValue!="")
				element1.value=ItemTypeValue;
				
				if((blsValueSavedObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
				{
					element1.setAttribute("disabled", true);
				}
			}
			else if(bld[t].columnName == "Cargo Movement Type")
			{
				var element1=document.createElement("select");
				//  element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallDPCss")
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				var CargoMovementTypeValue=blsValueSavedObject[i][bld[t].mappedCol];
				var el = document.createElement("option");
				var el2 = document.createElement("option");
				el.textContent = "FCL";
				el.value = "FCL";
				element1.appendChild(el);
				el2.textContent = "LCL";
				el2.value = "LCL";
				element1.appendChild(el2);
				//if(CargoMovementTypeValue!=""){
					element1.value=CargoMovementTypeValue;//}
				//	else{
				//	element1.value='S';}
				
				if((blsValueSavedObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
				{
					element1.setAttribute("disabled", true);
				}
			}
			
			else if(bld[t].columnName == "Consolidated Indicator")
			{
				var element1=document.createElement("select");
				//element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "roundshap3")
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				var consolidatedindicatorvalue=blsValueSavedObject[i][bld[t].mappedCol];
				var el = document.createElement("option");
				var el2 = document.createElement("option");
				var el3 = document.createElement("option");
				el.textContent = "STRAIGHT BL";
				el.value = "S";
				element1.appendChild(el);
				el2.textContent = "CONSOLIDATED BL";
				el2.value = "C";
				element1.appendChild(el2);
				el3.textContent = "HOUSE BL";
				el3.value = "H";
				element1.appendChild(el3);
				if(consolidatedindicatorvalue!=""){
				element1.value=consolidatedindicatorvalue;}
				else{
				element1.value='S';	}
				if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
				{
					element1.setAttribute("disabled", true);
				}
			}
			
			else if(bld[t].columnName == "Previous Declaration")
			{
				var element1=document.createElement("select");
				//element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallDPCss")
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				var previousdeclarationval=blsValueSavedObject[i][bld[t].mappedCol];
				var el = document.createElement("option");
				var el2 = document.createElement("option");
				var el3 = document.createElement("option");
				el.textContent = "N";
				el.value = "N";
				element1.appendChild(el);
				el2.textContent = "C";
				el2.value = "C";
				element1.appendChild(el2);
				el3.textContent = "Y";
				el3.value = "Y";
				element1.appendChild(el3);
				if(previousdeclarationval!="")
				element1.value=previousdeclarationval;
				else{
				element1.value='N';	}
				if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
				{
					element1.setAttribute("disabled", true);
				}
			}
			
			else if(bld[t].columnName == "CIN TYPE")
			{
				var element1=document.createElement("select");
				//element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallDPCss")
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				var cintypeval=blsValueSavedObject[i][bld[t].mappedCol];
				var el = document.createElement("option");
				var el2 = document.createElement("option");
				var el3 = document.createElement("option");
				el.textContent = "MCIN";
				el.value = "MCIN";
				element1.appendChild(el);
				el2.textContent = "PCIN";
				el2.value = "PCIN";
				element1.appendChild(el2);
				
				if(cintypeval!=""){
				element1.value=cintypeval;}
				else{
				element1.value='MCIN';	}
				if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
				{
					element1.setAttribute("disabled", true);
				}
			}
			
			else if(bld[t].columnName == "Type Of Cargo")
			{
				var element1=document.createElement("select");
				//element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "roundshap3")
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				var typeofcargoval=blsValueSavedObject[i][bld[t].mappedCol];
				var el = document.createElement("option");
				var el2 = document.createElement("option");
				var el3 = document.createElement("option");
				var el4 = document.createElement("option");
				el.textContent = "IMPORTED  GOODS";
				el.value = "IM";
				element1.appendChild(el);
				el2.textContent = "EXPORTED GOOODS";
				el2.value = "EX";
				element1.appendChild(el2);
				el3.textContent = "COASTAL GOODS";
				el3.value = "CG";
				element1.appendChild(el3);
				el4.textContent = "EMPTY";
				el4.value = "EM";
				element1.appendChild(el4);
				
				if(typeofcargoval!=""){
				element1.value=typeofcargoval;}
				else{
				element1.value='IM';	}
				if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
				{
					element1.setAttribute("disabled", true);
				}
			}
			
			else if(bld[t].columnName == "Split Indicator List")
			{
				var element1=document.createElement("select");
				//element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallDPCss")
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				var splitindicatorval=blsValueSavedObject[i][bld[t].mappedCol];
				var el = document.createElement("option");
				var el2 = document.createElement("option");
				el.textContent = "Y";
				el.value = "Y";
				element1.appendChild(el);
				el2.textContent = "N";
				el2.value = "N";
				element1.appendChild(el2);
				
				if(splitindicatorval!=""){
				element1.value=splitindicatorval;}
				else{
				element1.value='N';	}
				if((blsValueObject[i].itemNumber != "")&&(document.getElementById("igmNo").value != ""))
				{
					element1.setAttribute("disabled", true);
				}
			}
			else if(bld[t].columnName == "BL Version")
			{
				var element1=document.createElement("input");
				element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallInputBox");
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				if (!blsValueSavedObject[i][bld[t].mappedCol]) {
					element1.setAttribute("value", "");
				} else{
					element1.setAttribute("value",
							blsValueSavedObject[i][bld[t].mappedCol]);
				}
			}
			else if(bld[t].columnName == "Cargo Movement")
			{
				var element1=document.createElement("input");
				element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallInputBox");
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				if (!blsValueSavedObject[i][bld[t].mappedCol]) {
					element1.setAttribute("value", "");
				} else{
					element1.setAttribute("value",
							blsValueSavedObject[i][bld[t].mappedCol]);
				}
			}
			else if(bld[t].columnName == "Transport Mode")
			{
				var element1=document.createElement("input");
				element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallInputBox");
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				if (!blsValueSavedObject[i][bld[t].mappedCol]) {
					element1.setAttribute("value", "");
				} else{
					element1.setAttribute("value",
							blsValueSavedObject[i][bld[t].mappedCol]);
				}
			}
			
			else if(bld[t].columnName == "Port of Acceptance"){
				var element1 = document.createElement("input");
				element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallInputBox")

				if (!blsValueObject[i][bld[t].mappedCol]){
					element1.setAttribute("value", "");
				}else{
					element1.setAttribute("value",
							blsValueSavedObject[i][bld[t].mappedCol]);
				}
			}
			else if(bld[t].columnName == "First Port of Entry/Last Port of Departure"){
				var element1 = document.createElement("input");
				element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "smallInputBox")

				if (!blsValueObject[i][bld[t].mappedCol]){
					element1.setAttribute("value", "");
				}else{
					element1.setAttribute("value",
							blsValueSavedObject[i][bld[t].mappedCol]);
				}
			}
			else if(bld[t].columnName == "Consigner")
			{
				var element1=document.createElement("input");
				element1.setAttribute("type", "button");
				element1.setAttribute("class", "roundshap5");
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				element1.setAttribute("value", "+");
				element1.setAttribute("servicepath", x);
				element1.setAttribute("blspath", i);
				element1.setAttribute('onclick',"ConsignerInfo(this)");

			}
			else if(bld[t].columnName == "Consignee")
			{
				var element1=document.createElement("input");
				element1.setAttribute("type", "button");
				element1.setAttribute("class", "roundshap5");
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				element1.setAttribute("value", "+");
				element1.setAttribute("servicepath", x);
				element1.setAttribute("blspath", i);
				element1.setAttribute('onclick',"consigneeInfo(this)");

			}
			else if(bld[t].columnName == "Notify Party")
			{
				var element1=document.createElement("input");
				element1.setAttribute("type", "button");
				element1.setAttribute("class", "roundshap5");
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				element1.setAttribute("servicepath", x);
				element1.setAttribute("blspath", i);
				element1.setAttribute("value", "+");
				element1.setAttribute('onclick',"notifyInfo(this)");
			}
			else if(bld[t].columnName == "Marks_Number")
			{
				var element1=document.createElement("input");
				element1.setAttribute("type", "button");
				element1.setAttribute("class", "roundshap5");
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				element1.setAttribute("servicepath", x);
				element1.setAttribute("blspath", i);
				element1.setAttribute("value", "+");
				element1.setAttribute('onclick',"marksInfo(this)");
			}
			else if(bld[t].columnName == "Container Details")
			{
				var element1=document.createElement("input");
				element1.setAttribute("type", "button");
				element1.setAttribute("class", "roundshap5");
				element1.setAttribute("id", i + bld[t].columnName);
				element1.setAttribute("name", bld[t].columnName);
				element1.setAttribute("servicepath", x);
				element1.setAttribute("blspath", i);
				element1.setAttribute("value", "+");
				element1.setAttribute('onclick',"containerDetailsInfo(this)");
			}
			else {
				var element1 = document.createElement("input");
				element1.setAttribute("type", bld[t].type);
				element1.setAttribute("class", "roundshap2")

				if (!blsValueSavedObject[i][bld[t].mappedCol]) 
				{
					element1.setAttribute("value", "");
				} else 
				{
					element1.setAttribute("value",
							blsValueSavedObject[i][bld[t].mappedCol]);
				}
			}


			/*if (!blsValueObject[i][bld[t].mappedCol]) {
					element1.setAttribute("value", "");
				} else {
					element1.setAttribute("value",
						//	blsValueObject[i][bld[t].mappedCol]);
				}*/
			// element1.setAttribute("name", bld[t].columnName);
			element1.setAttribute("id", i + bld[t].columnName);
			if (i + bld[t].columnName == i + 'BL#') {
				element1.setAttribute("name",
						blsValueSavedObject[i][bld[t].mappedCol]);
			} else {
				element1.setAttribute("name", bld[t].columnName);
			}
			if(i + bld[t].columnName == i + 'Item Number')
			{
				var id1=i + 'Item Number';
				element1.setAttribute("title" ,"Enter Numeric Values only");
				element1.setAttribute("onchange",
				"itemNoHandler(this)");
			}


			if ((i + bld[t].columnName == i + 'Item Number')&& (blsValueSavedObject[i].itemNumber == ""))
			{
				element1.setAttribute("readonly", true);
			}

			/*if (i + bld[t].columnName == i + "Submit Date Time"
						&& blsValueSavedObject[i].submitDateTime == "") {
					var date = new Date();
					var newdate = moment(date).format("DD/MM/YYYY HH:mm");
					element1.setAttribute("value", newdate);
				}*/
			if (i + bld[t].columnName == i + "Submit Date Time")
			{
				element1.setAttribute("readonly", true);
			}
			if (i + bld[t].columnName == i + "BL Validate Flag" && ((blsValueSavedObject[i][bld[t].mappedCol])=="TRUE") )
			{
			//	document.getElementById(i+"sequence").classList.add("validateBL");
				blColorChange(i);
			}
			if ((i + bld[t].columnName == i + 'Is Present')
					&& (blsValueSavedObject[i].itemNumber != "")) {
				element1.setAttribute("value", "TRUE");
			} else if ((i + bld[t].columnName == i + 'Is Present')
					&& (blsValueSavedObject[i].itemNumber == "")) {
				element1.setAttribute("value", "FALSE");
			}
			if ((i + bld[t].columnName == i + "BL#")
					|| (i + bld[t].columnName == i + "BL_Date")||(i + bld[t].columnName == i + "BL Version")) {
				element1.setAttribute("readonly", true);
			}
			if ((i + bld[t].columnName == i + 'Item Number')
					&& (blsValueSavedObject[i].itemNumber != "")) {
				//element1.setAttribute("readonly", false);
				document.getElementById(i + "rowSelected").checked = true;
			}

			if ((i + bld[t].columnName == i + 'Cargo Movement'))
			{
				element1.setAttribute("readonly", true);
			}
			if ((i + bld[t].columnName == i + 'Transport Mode'))
			{
				element1.setAttribute("readonly", true);
			}
			if(i + bld[t].columnName==i+ 'Consolidator PAN')
			{
				var node = document.createElement("p");
				billdetail.appendChild(node);
			}
			if(i + bld[t].columnName==i+ 'UCR Type')
			{
			var node = document.createElement("p");
			billdetail.appendChild(node);
			}
			if (((i + bld[t].columnName == i + 'CFS-Custom Code')
					|| (i + bld[t].columnName == i + 'Cargo Movement')
					|| (i + bld[t].columnName == i + 'Transport Mode')
					|| (i + bld[t].columnName == i + 'Item Number')
					|| (i + bld[t].columnName == i + 'Road Carr code')
					|| (i + bld[t].columnName == i + 'TP Bond No'))
					&& (document.getElementById("igmNo").value != "")
					&& (blsValueSavedObject[i].itemNumber != "")) {
				element1.setAttribute("readonly", true);
				document.getElementById(i + "rowSelected").disabled = true;

			}
			idListForTextBox[bld[t].columnName] = i + bld[t].columnName;
			billdetail.appendChild(element1);

		}
		idJsonObjectForTextBox.push(idListForTextBox);
		var node = document.createElement("p");
		billdetail.appendChild(node);

		for(m=0;m<blsValueSavedObject[i].consignee.length;m++)
		{
			var eachconsigneeindexdtl={};
			eachconsigneeindexdtl["zip"]=blsValueSavedObject[i].consignee[m].zip;
			eachconsigneeindexdtl["blNO"]=blsValueSavedObject[i].consignee[m].blNO;
			eachconsigneeindexdtl["city"]=blsValueSavedObject[i].consignee[m].city;
			eachconsigneeindexdtl["countryCode"]=blsValueSavedObject[i].consignee[m].countryCode;
			eachconsigneeindexdtl["addressLine1"]=blsValueSavedObject[i].consignee[m].addressLine1;
			eachconsigneeindexdtl["addressLine2"]=blsValueSavedObject[i].consignee[m].addressLine2;
			eachconsigneeindexdtl["addressLine3"]=blsValueSavedObject[i].consignee[m].addressLine3;
			eachconsigneeindexdtl["addressLine4"]=blsValueSavedObject[i].consignee[m].addressLine4;
			eachconsigneeindexdtl["customerCode"]=blsValueSavedObject[i].consignee[m].customerCode;
			eachconsigneeindexdtl["state"]=blsValueSavedObject[i].consignee[m].state;
			eachconsigneeindexdtl["customerName"]=blsValueSavedObject[i].consignee[m].customerName;
			if(blsValueSavedObject[i].isValidateBL!=""){
				eachconsigneeindexdtl["vaidation"]=blsValueSavedObject[i].isValidateBL;	
			}else{
				eachconsigneeindexdtl["vaidation"]="";	
			}
			arrayofconsignee.push(eachconsigneeindexdtl);
		}
		
		
		/*loop for consigner popup*/
		for(m=0;m<blsValueSavedObject[i].consigner.length;m++)
		{
			var eachconsignerindexdtl={};
			eachconsignerindexdtl["zip"]=blsValueSavedObject[i].consigner[m].zip;
			eachconsignerindexdtl["blNO"]=blsValueSavedObject[i].consigner[m].blNO;
			eachconsignerindexdtl["city"]=blsValueSavedObject[i].consigner[m].city;
			eachconsignerindexdtl["countryCode"]=blsValueSavedObject[i].consigner[m].countryCode;
			eachconsignerindexdtl["addressLine1"]=blsValueSavedObject[i].consigner[m].addressLine1;
			eachconsignerindexdtl["addressLine2"]=blsValueSavedObject[i].consigner[m].addressLine2;
			eachconsignerindexdtl["addressLine3"]=blsValueSavedObject[i].consigner[m].addressLine3;
			eachconsignerindexdtl["addressLine4"]=blsValueSavedObject[i].consigner[m].addressLine4;
			eachconsignerindexdtl["customerCode"]=blsValueSavedObject[i].consigner[m].customerCode;
			eachconsignerindexdtl["state"]=blsValueSavedObject[i].consigner[m].state;
			eachconsignerindexdtl["customerName"]=blsValueSavedObject[i].consigner[m].customerName;
			if(blsValueSavedObject[i].isValidateBL!=""){
				eachconsignerindexdtl["vaidation"]=blsValueSavedObject[i].isValidateBL;	
			}else{
				eachconsignerindexdtl["vaidation"]="";	
			}
			arrayofconsigner.push(eachconsignerindexdtl);
		}
		
		/*loop for notifyParty popup*/
		for(m=0;m<blsValueSavedObject[i].notifyParty.length;m++)
		{
			var eachnotifyPartyindexdtl={};
			eachnotifyPartyindexdtl["zip"]=blsValueSavedObject[i].notifyParty[m].zip;
			eachnotifyPartyindexdtl["blNO"]=blsValueSavedObject[i].notifyParty[m].blNo;
			eachnotifyPartyindexdtl["city"]=blsValueSavedObject[i].notifyParty[m].city;
			eachnotifyPartyindexdtl["countryCode"]=blsValueSavedObject[i].notifyParty[m].countryCode;
			eachnotifyPartyindexdtl["addressLine1"]=blsValueSavedObject[i].notifyParty[m].addressLine1;
			eachnotifyPartyindexdtl["addressLine2"]=blsValueSavedObject[i].notifyParty[m].addressLine2;
			eachnotifyPartyindexdtl["addressLine3"]=blsValueSavedObject[i].notifyParty[m].addressLine3;
			eachnotifyPartyindexdtl["addressLine4"]=blsValueSavedObject[i].notifyParty[m].addressLine4;
			eachnotifyPartyindexdtl["customerCode"]=blsValueSavedObject[i].notifyParty[m].costumerCode;
			eachnotifyPartyindexdtl["state"]=blsValueSavedObject[i].notifyParty[m].state;
			eachnotifyPartyindexdtl["customerName"]=blsValueSavedObject[i].notifyParty[m].costumerName;
			if(blsValueSavedObject[i].isValidateBL!=""){
				eachnotifyPartyindexdtl["vaidation"]=blsValueSavedObject[i].isValidateBL;	
			}else{
				eachnotifyPartyindexdtl["vaidation"]="";	
			}
			arrayofNotyfyparty.push(eachnotifyPartyindexdtl);
		}
		/*loop for marksNumber popup*/
		for(m=0;m<blsValueSavedObject[i].marksNumber.length;m++)
		{
			var eachmarksNumberindexdtl={};
			eachmarksNumberindexdtl["marksNumbers"]=blsValueSavedObject[i].marksNumber[m].marksNumbers;
			eachmarksNumberindexdtl["blNO"]=blsValueSavedObject[i].marksNumber[m].blNO;
			eachmarksNumberindexdtl["description"]=blsValueSavedObject[i].marksNumber[m].description;
			if(blsValueSavedObject[i].isValidateBL!=""){
				eachmarksNumberindexdtl["vaidation"]=blsValueSavedObject[i].isValidateBL;	
			}else{
				eachmarksNumberindexdtl["vaidation"]="";	
			}
			arrayofmarksNumber.push(eachmarksNumberindexdtl);
		}
		/*loop for containerDetailes popup*/
		for(m=0;m<blsValueSavedObject[i].containerDetailes.length;m++)
		{
			var eachcontainerDetailesindexdtl={};
			eachcontainerDetailesindexdtl["ContainerSize"]=blsValueSavedObject[i].containerDetailes[m].containerSize;
			eachcontainerDetailesindexdtl["ContainerType"]=blsValueSavedObject[i].containerDetailes[m].containerType;
			eachcontainerDetailesindexdtl["containerNumber"]=blsValueSavedObject[i].containerDetailes[m].containerNumber;
			eachcontainerDetailesindexdtl["blNO"]=blsValueSavedObject[i].containerDetailes[m].blNo;
			eachcontainerDetailesindexdtl["containerSealNumber"]=blsValueSavedObject[i].containerDetailes[m].containerSealNumber;
			eachcontainerDetailesindexdtl["containerWeight"]=blsValueSavedObject[i].containerDetailes[m].containerWeight;
			eachcontainerDetailesindexdtl["totalNumberOfPackagesInContainer"]=blsValueSavedObject[i].containerDetailes[m].totalNumberOfPackagesInContainer;
			eachcontainerDetailesindexdtl["containerAgentCode"]=result2.Savedresult[x]["service"].agentCode;
			eachcontainerDetailesindexdtl["status"]=blsValueSavedObject[i].containerDetailes[m].status;
			if(blsValueSavedObject[i].containerDetailes[m].equipmentLoadStatus==""){
				eachcontainerDetailesindexdtl["equipmentLoadStatus"]='FLC';
			}else{
				eachcontainerDetailesindexdtl["equipmentLoadStatus"]=blsValueSavedObject[i].containerDetailes[m].equipmentLoadStatus;
			}
			if(blsValueSavedObject[i].containerDetailes[m].soc_flag==""){
				eachcontainerDetailesindexdtl["soc_flag"]='N';
			}else{
				eachcontainerDetailesindexdtl["soc_flag"]=blsValueSavedObject[i].containerDetailes[m].soc_flag;
			}
			if(blsValueSavedObject[i].containerDetailes[m].equipment_seal_type==""){
				eachcontainerDetailesindexdtl["equipment_seal_type"]='BTSL';
			}else{
				eachcontainerDetailesindexdtl["equipment_seal_type"]=blsValueSavedObject[i].containerDetailes[m].equipment_seal_type;
			}
			if(blsValueSavedObject[i].vaidation!=""){
				eachcontainerDetailesindexdtl["vaidation"]=blsValueSavedObject[i].isValidateBL;	
			}else{
				eachcontainerDetailesindexdtl["vaidation"]="";	
			}
			arrayofcontainerDetailes.push(eachcontainerDetailesindexdtl);
		}
		var objecToStorPopupArray ={"consignee": arrayofconsignee,
				"notifyParty" : arrayofNotyfyparty,"marksNumber":arrayofmarksNumber,"containerDetailes":arrayofcontainerDetailes,"consigner":arrayofconsigner}
		popupjson.popup[blsValueSavedObject[i].bl]=objecToStorPopupArray;
	}
	//console.log(popupjson);
	/*	}
}*/
	result1.result[vasselVoyageindex]["BLS"]=result2.Savedresult[x]["BLS"];
	result1.result[vasselVoyageindex]["service"]=result2.Savedresult[x]["service"];
}

/*tPBondNoHnadler() ended*/


function onseiBtn(){
	generatFalg="SEIFILE";
	
	fileNme="SEI";
	manifestFileGenerator();
	}

function onsamBtn(){
	generatFalg="";
	if(document.getElementById("igmNo").value=="" )
	{
	fileNme="SAM"
	generatFalg="SAMFILE";
	}else{
		fileNme="SAA";
		generatFalg="SAAFILE";
	}
		
	manifestFileGenerator();
	}

/*
 * manifestFileGenerator function started
 */
function manifestFileGenerator() {
	
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	if (false) {
		showBarMessages("Save The BL Details First.",1);
		return false
	}else {
		var blDetails = [];
		var listOfVesselVoyageSearchDetailsPrepraedJson = [];
		var listOfconsigneeDetailsForSave=[];
		var listOfconsignerDetailsForSave=[];
		var listOfNotifyPartyForSave=[];
		var listofcontainerdetailsForSave = [];
		var listofmarksNumberDtlsForSave =[];
		var fitn = "";
		var titn = "";
		var itnu = "";

		if ((document.getElementById("totalItem").value == 0)||(document.getElementById("totalItem").value < 0)) {
			showBarMessages("Select BL first.",1);
		}
		else {

			var inStatus = document.getElementById("inStatus").value;
			var blCreationDateFrom = document.getElementById("blCreationDateFrom").value;
			var blCreationDateTo = document.getElementById("blCreationDateTo").value;
			var igmservice = document.getElementById("igmservice").value;
			var vessel = document.getElementById("vessel").value;
			var voyage = document.getElementById("voyage").value;
			var direction = document.getElementById("direction").value;
			var pol = document.getElementById("pol").value;
			var polTerminal = document.getElementById("polTerminal").value;
			var pod = document.getElementById("pod").value;
			var podTerminal = document.getElementById("podTerminal").value;

			/* get value for 25 fields */

			var customCode = document.getElementById("customCode").value;
			var callSign = document.getElementById("callSign").value;
			var imoCode = document.getElementById("imoCode").value;
			var agentCode = document.getElementById("agentCode").value;
			var lineCode = document.getElementById("lineCode").value;
			var portOrigin = document.getElementById("portOrigin").value;
			var prt1 = document.getElementById("prt1").value; //-3
			var prt2 = document.getElementById("prt2").value; //-2
			var prt3 = document.getElementById("prt3").value; //-1
 			
			var last1 = document.getElementById("nprt1").value; //1
			var last2 = document.getElementById("nprt2").value; //2
			var last3 = document.getElementById("nprt3").value; //3
			
			var portOfArrival = document.getElementById("portOfArrival").value;
			var VesselTypes = document.getElementById("cont").value;
			var generalDescription = document.getElementById("generalDescription").value;
			var NationalityOfVessel = document.getElementById("nov").value;
			var MasterName = document.getElementById("mn").value;
			var igmNo = document.getElementById("igmNo").value;
			var igmDate = document.getElementById("igmDate").value;
			var aDate = document.getElementById("aDate").value;
			var aTime = document.getElementById("aTime").value;
			var ataAd = document.getElementById("ataAd").value;
			var ataAt = document.getElementById("ataAt").value;
			var totalItem = document.getElementById("totalItem").value;
			var LighthouseDue = document.getElementById("lhd").value;
			var GrossWeightVessel = document.getElementById("gwv").value;
			var NetWeightVessel = document.getElementById("nwv").value;
			var SameBottomCargo = document.getElementById("smbc").value;
			var ShipStoreDeclaration = document.getElementById("shsd").value;
			var CrewListDeclaration = document.getElementById("crld").value;
			var CargoDeclaration = document.getElementById("card").value;
			var PassengerList = document.getElementById("pasl").value;
			var CrewEffect = document.getElementById("cre").value;
			var MaritimeDeclaration = document.getElementById("mard").value;
			
			//new field added in vessel&voyage section
			var departureManifestNumber=document.getElementById("departMainnumber").value;
			var departureManifestDate=document.getElementById("departMaindate").value;
			var submitterType=document.getElementById("submitTypet").value;
			var submitterCode=document.getElementById("submitCode").value;
			var authorizedRepresentativeCode=document.getElementById("authorizRepcode").value;
			var shippingLineBondNumber=document.getElementById("shiplineBondnumber").value;
			var modeofTransport=document.getElementById("modofTransport").value;
			var shipType=document.getElementById("shipType").value;
			var conveyanceReferenceNumber=document.getElementById("convanceRefnum").value;
			var totalNoofTransportEquipmentManifested=document.getElementById("totalnotRaneqpmin").value;
			var cargoDescription=document.getElementById("cargoDescrip").value;
			var briefCargoDescription=document.getElementById("briefCargodescon").value;
			var expectedDate=document.getElementById("expdate").value;
			var timeofDeparture=document.getElementById("timeofdep").value;
			var totalnooftransportcontractsreportedonArrivalDeparture=document.getElementById("tonotransrepoaridep").value;
			var messtype=document.getElementById("mesType").value;
			var vesType=document.getElementById("vesType").value;
			var authoseaCarcode=document.getElementById("authoseaCarcode").value;
			var portoDreg=document.getElementById("portoDreg").value;
			var regDate=document.getElementById("regDate").value;
			var voyDetails=document.getElementById("voyDetails").value;
			var shipItiseq=document.getElementById("shipItiseq").value;
			var shipItinerary=document.getElementById("shipItinerary").value;
			var portofCallname=document.getElementById("portofCallname").value;
			var arrivalDepdetails=document.getElementById("arrivalDepdetails").value;
			var totalnoTransarrivdep=document.getElementById("totalnoTransarrivdep").value;
			
			//serial no. validation
			var ArrivalDateupdate = new Date();
			var currentDate = moment(ArrivalDateupdate).format('YY');
			var serialnumber = currentDate;
           
			for (var i = 0; i < listOfVesselVoyageSearchDetails.length; i++) {

				if (document.getElementById(listOfVesselVoyageSearchDetails[i].id).checked == true) {
					vesselIndex=i;
					var eachVesselVoyageSearchDetailsRow = {};

					fitn = eachVesselVoyageSearchDetailsRow["From Item No"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["From Item No"]).value;
					eachVesselVoyageSearchDetailsRow["New Vessel"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["New Vessel"]).value;
					eachVesselVoyageSearchDetailsRow["New Voyage"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["New Voyage"]).value;
					eachVesselVoyageSearchDetailsRow["Port"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Port"]).value;
					eachVesselVoyageSearchDetailsRow["Road Carr code"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Road Carr code"]).value;
					eachVesselVoyageSearchDetailsRow["Service"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Service"]).value;
					eachVesselVoyageSearchDetailsRow["TP Bond No"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["TP Bond No"]).value;
					eachVesselVoyageSearchDetailsRow["Terminal"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Terminal"]).value;
					titn = eachVesselVoyageSearchDetailsRow["To Item No"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["To Item No"]).value;
					eachVesselVoyageSearchDetailsRow["Vessel"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Vessel"]).value;
					eachVesselVoyageSearchDetailsRow["Voyage"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Voyage"]).value;
					eachVesselVoyageSearchDetailsRow["Pol"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Pol"]).value;
					eachVesselVoyageSearchDetailsRow["Pol Terminal"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Pol Terminal"]).value;
					eachVesselVoyageSearchDetailsRow["Custom Terminal Code"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Custom Terminal Code"]).value;

					listOfVesselVoyageSearchDetailsPrepraedJson
					.push(eachVesselVoyageSearchDetailsRow);
				}
			}
			var tempItemNo=(Number(fitn));

			for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
				var listOfBlDetails = {};
				var blnoforpopupdata;
				if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true){
					if(document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value!=="") {
						blnoforpopupdata=document
						.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
						listOfBlDetails["BL#"] = document
						.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
						listOfBlDetails["BL_Date"] = document
						.getElementById(idJsonObjectForTextBox[i]["BL_Date"]).value;
						listOfBlDetails["BL Status"] = document
						.getElementById(idJsonObjectForTextBox[i]["BL Status"]).value;
						listOfBlDetails["CFS-Custom Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["CFS-Custom Code"]).value;
						listOfBlDetails["Cargo Movement"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
						listOfBlDetails["Cargo Movement Type"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Movement Type"]).value;
						listOfBlDetails["Cargo Nature"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Nature"]).value;
						listOfBlDetails["Item Number"] =document
						.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value;
						listOfBlDetails["Item Type"] = document
						.getElementById(idJsonObjectForTextBox[i]["Item Type"]).value;
						listOfBlDetails["Road Carr code"] = document
						.getElementById(idJsonObjectForTextBox[i]["Road Carr code"]).value;
						listOfBlDetails["TP Bond No"] = document
						.getElementById(idJsonObjectForTextBox[i]["TP Bond No"]).value;
						listOfBlDetails["Submit Date Time"] =document
						.getElementById(idJsonObjectForTextBox[i]["Submit Date Time"]).value;
						listOfBlDetails["Transport Mode"] = document
						.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
						listOfBlDetails["DPD Movement"] = document
						.getElementById(idJsonObjectForTextBox[i]["DPD Movement"]).value;
						listOfBlDetails["DPD Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["DPD Code"]).value;
						listOfBlDetails["BL Version"] = document
						.getElementById(idJsonObjectForTextBox[i]["BL Version"]).value;
						listOfBlDetails["Is Present"] = document
						.getElementById(idJsonObjectForTextBox[i]["Is Present"]).value;
						listOfBlDetails["Custom ADD1"] = document
						.getElementById(idJsonObjectForTextBox[i]["Custom ADD1"]).value;
						listOfBlDetails["Custom ADD2"] = document
						.getElementById(idJsonObjectForTextBox[i]["Custom ADD2"]).value;
						listOfBlDetails["Custom ADD3"] = document
						.getElementById(idJsonObjectForTextBox[i]["Custom ADD3"]).value;
						listOfBlDetails["Custom ADD4"] = document
						.getElementById(idJsonObjectForTextBox[i]["Custom ADD4"]).value;
						listOfBlDetails["Package BL Level"] = document
						.getElementById(idJsonObjectForTextBox[i]["Package BL Level"]).value;
						listOfBlDetails["Gross Cargo Weight BL level"] = document
						.getElementById(idJsonObjectForTextBox[i]["Gross Cargo Weight BL level"]).value;
						
						listOfBlDetails["Consolidated Indicator"] = document
						.getElementById(idJsonObjectForTextBox[i]["Consolidated Indicator"]).value;
						listOfBlDetails["Previous Declaration"] = document
						.getElementById(idJsonObjectForTextBox[i]["Previous Declaration"]).value;
						listOfBlDetails["Consolidator PAN"] = document
						.getElementById(idJsonObjectForTextBox[i]["Consolidator PAN"]).value;
						listOfBlDetails["CIN TYPE"] = document
						.getElementById(idJsonObjectForTextBox[i]["CIN TYPE"]).value;
						listOfBlDetails["MCIN"] = document
						.getElementById(idJsonObjectForTextBox[i]["MCIN"]).value;
						listOfBlDetails["CSN Submitted Type"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Submitted Type"]).value;
						listOfBlDetails["CSN Submitted by"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Submitted by"]).value;
						listOfBlDetails["CSN Reporting Type"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Reporting Type"]).value;
						listOfBlDetails["CSN Site ID"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Site ID"]).value;
						listOfBlDetails["CSN Number"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Number"]).value;
						listOfBlDetails["CSN Date"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Date"]).value;
						listOfBlDetails["Previous MCIN"] = document
						.getElementById(idJsonObjectForTextBox[i]["Previous MCIN"]).value;
						listOfBlDetails["Split Indicator"] = document
						.getElementById(idJsonObjectForTextBox[i]["Split Indicator"]).value;
						listOfBlDetails["Number of Packages"] = document
						.getElementById(idJsonObjectForTextBox[i]["Number of Packages"]).value;
						listOfBlDetails["Type of Package"] = document
						.getElementById(idJsonObjectForTextBox[i]["Type of Package"]).value;
						listOfBlDetails["First Port of Entry/Last Port of Departure"] = document
						.getElementById(idJsonObjectForTextBox[i]["First Port of Entry/Last Port of Departure"]).value;
						listOfBlDetails["Type Of Cargo"] = document
						.getElementById(idJsonObjectForTextBox[i]["Type Of Cargo"]).value;
						listOfBlDetails["Split Indicator List"] = document
						.getElementById(idJsonObjectForTextBox[i]["Split Indicator List"]).value;
						
						listOfBlDetails["Port of Acceptance"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Acceptance"]).value;
						listOfBlDetails["Port of Receipt"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Receipt"]).value;
						
						listOfBlDetails["UCR Typel"] = document
						.getElementById(idJsonObjectForTextBox[i]["UCR Type"]).value;
						listOfBlDetails["UCR Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["UCR Code"]).value;
						listOfBlDetails["Port of Acceptance Name"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Acceptance Name"]).value;
						listOfBlDetails["Port of Receipt Name"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Receipt Name"]).value;
						
						listOfBlDetails["PAN of notified party"] = document
						.getElementById(idJsonObjectForTextBox[i]["PAN of notified party"]).value;
						listOfBlDetails["Unit of weight"] = document
						.getElementById(idJsonObjectForTextBox[i]["Unit of weight"]).value;
						listOfBlDetails["Gross Volume"] = document
						.getElementById(idJsonObjectForTextBox[i]["Gross Volume"]).value;
						listOfBlDetails["Unit of Volume"] = document
						.getElementById(idJsonObjectForTextBox[i]["Unit of Volume"]).value;
						listOfBlDetails["Cargo Item Sequence No"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Item Sequence No"]).value;
						listOfBlDetails["Cargo Item Description"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Item Description"]).value;
						
						listOfBlDetails["UNO Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["UNO Code"]).value;
						listOfBlDetails["IMDG Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["IMDG Code"]).value;
						
						listOfBlDetails["Number of Packages Hidden"] = document
						.getElementById(idJsonObjectForTextBox[i]["Number of Packages Hidden"]).value;
						
						listOfBlDetails["Type of Packages Hidden"] = document
						.getElementById(idJsonObjectForTextBox[i]["Type of Packages Hidden"]).value;
						listOfBlDetails["Container Weight"] = document
						.getElementById(idJsonObjectForTextBox[i]["Container Weight"]).value;
						
						
						listOfBlDetails["Port of call sequence numbe"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of call sequence number"]).value;
						listOfBlDetails["Port of Call Coded"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Call Coded"]).value;
						listOfBlDetails["Next port of call coded"] = document
						.getElementById(idJsonObjectForTextBox[i]["Next port of call coded"]).value;
						listOfBlDetails["MC Location Customsl"] = document
						.getElementById(idJsonObjectForTextBox[i]["MC Location Customs"]).value;
						
						blDetails.push(listOfBlDetails);

						/*create json for consignee */

						//console.log(popupjson.popup);

						for(j=0;j<popupjson.popup[blnoforpopupdata].consignee.length;j++)
						{
							var listofconsignee={};
							listofconsignee["zip"]=popupjson.popup[blnoforpopupdata].consignee[j].zip;
							listofconsignee["blNO"]=popupjson.popup[blnoforpopupdata].consignee[j].blNO;
							listofconsignee["state"]=popupjson.popup[blnoforpopupdata].consignee[j].state;
							listofconsignee["customerName"]=popupjson.popup[blnoforpopupdata].consignee[j].customerName;
							listofconsignee["customerCode"]=popupjson.popup[blnoforpopupdata].consignee[j].customerCode;
							listofconsignee["countryCode"]=popupjson.popup[blnoforpopupdata].consignee[j].countryCode;
							listofconsignee["city"]=popupjson.popup[blnoforpopupdata].consignee[j].city;
							listofconsignee["addressLine1"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine1;
							listofconsignee["addressLine2"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine2;
							listofconsignee["addressLine3"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine3;
							listofconsignee["addressLine4"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine4;

							listOfconsigneeDetailsForSave.push(listofconsignee);
						}
						
						for(j=0;j<popupjson.popup[blnoforpopupdata].consigner.length;j++)
						{
							var listofconsigner={};
							listofconsigner["zip"]=popupjson.popup[blnoforpopupdata].consigner[j].zip;
							listofconsigner["blNO"]=popupjson.popup[blnoforpopupdata].consigner[j].blNO;
							listofconsigner["state"]=popupjson.popup[blnoforpopupdata].consigner[j].state;
							listofconsigner["customerName"]=popupjson.popup[blnoforpopupdata].consigner[j].customerName;
							listofconsigner["customerCode"]=popupjson.popup[blnoforpopupdata].consigner[j].customerCode;
							listofconsigner["countryCode"]=popupjson.popup[blnoforpopupdata].consigner[j].countryCode;
							listofconsigner["city"]=popupjson.popup[blnoforpopupdata].consigner[j].city;
							listofconsigner["addressLine1"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine1;
							listofconsigner["addressLine2"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine2;
							listofconsigner["addressLine3"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine3;
							listofconsigner["addressLine4"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine4;

							listOfconsignerDetailsForSave.push(listofconsigner);
						}
						//  console.log(listOfconsigneeDetailsForSave);

						/* create json for notify_party*/

						for(j=0;j<popupjson.popup[blnoforpopupdata].notifyParty.length;j++)
						{
							var listOfNotifyParty={};
							listOfNotifyParty["zip"]=popupjson.popup[blnoforpopupdata].notifyParty[j].zip;
							listOfNotifyParty["blNO"]=popupjson.popup[blnoforpopupdata].notifyParty[j].blNO;
							listOfNotifyParty["state"]=popupjson.popup[blnoforpopupdata].notifyParty[j].state;
							listOfNotifyParty["customerName"]=popupjson.popup[blnoforpopupdata].notifyParty[j].customerName;
							listOfNotifyParty["customerCode"]=popupjson.popup[blnoforpopupdata].notifyParty[j].customerCode;
							listOfNotifyParty["countryCode"]=popupjson.popup[blnoforpopupdata].notifyParty[j].countryCode;
							listOfNotifyParty["city"]=popupjson.popup[blnoforpopupdata].notifyParty[j].city;
							listOfNotifyParty["addressLine1"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine1;
							listOfNotifyParty["addressLine2"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine2;
							listOfNotifyParty["addressLine3"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine3;
							listOfNotifyParty["addressLine4"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine4;
							listOfNotifyPartyForSave.push(listOfNotifyParty);
						}
						//  console.log(listOfNotifyPartyForSave);

						/* create json for containerDetailes*/

						for(j=0;j<popupjson.popup[blnoforpopupdata].containerDetailes.length;j++)
						{
							var listofcontainerdetails={};
							var valueOfWeight=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerWeight;
							var valueOfPackage=popupjson.popup[blnoforpopupdata].containerDetailes[j].totalNumberOfPackagesInContainer;
							listofcontainerdetails["ISOCode"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].ISOCode;
							listofcontainerdetails["blNO"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].blNO;
							listofcontainerdetails["containerAgentCode"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerAgentCode;
							listofcontainerdetails["containerNumber"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerNumber;
							listofcontainerdetails["containerSealNumber"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerSealNumber;
							listofcontainerdetails["containerWeight"]=valueOfWeight;
							listofcontainerdetails["status"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].status;
							listofcontainerdetails["equipmentLoadStatus"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].equipmentLoadStatus;
							listofcontainerdetails["soc_flag"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].soc_flag;
							listofcontainerdetails["equipment_seal_type"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].equipment_seal_type;
							listofcontainerdetails["totalNumberOfPackagesInContainer"]=valueOfPackage;
							listofcontainerdetailsForSave.push(listofcontainerdetails);
						}
						//   console.log(listofcontainerdetailsForSave);

						for(j=0;j<popupjson.popup[blnoforpopupdata].marksNumber.length;j++)
						{
							var listofmarksNumberDtls={};
							listofmarksNumberDtls["description"]=popupjson.popup[blnoforpopupdata].marksNumber[j].description;
							listofmarksNumberDtls["blNO"]=popupjson.popup[blnoforpopupdata].marksNumber[j].blNO;
							listofmarksNumberDtls["marksNumbers"]=popupjson.popup[blnoforpopupdata].marksNumber[j].marksNumbers;

							listofmarksNumberDtlsForSave.push(listofmarksNumberDtls);
						}
						// console.log(listofmarksNumberDtlsForSave);

					}
					else{
						showBarMessages(document.getElementById(idJsonObjectForTextBox[i]["BL#"]).value+" : "+" BL is Not save.",1);
						return false;
					}
				} 

			}
			if (fitn == "") {
				showBarMessages("From Item No. is required.",1);
				return false;
			} else if (titn == "") {
				showBarMessages("To Item No. is required.",1);
				return false;
			}
			else if (Number(fitn) > Number(titn)) {
				showBarMessages("To Item No must be greater than From Item No.",1);
				return false;
			}
			else if(Number((document.getElementById("totalItem").value))>((Number(titn)-Number(fitn)))+1)
			{
				showBarMessages("Enter valid range as per Selected no of BL",1);
				return false;
			}



			//	console.log(blDetails);
			$.ajax({
				method : "POST",
				async : true,
				url : ONSAVEFILE,
				beforeSend:function()
				{
					loadingfun();
				},
				data : {
					inStatus : inStatus,
					blCreationDateFrom : blCreationDateFrom,
					blCreationDateTo : blCreationDateTo,
					igmservice : igmservice,
					vessel : vessel,
					voyage : voyage,
					direction : direction,
					pol : pol,
					polTerminal : polTerminal,
					pod : pod,
					podTerminal : podTerminal,
					customCode : customCode,
					callSign : callSign,
					imoCode : imoCode,
					agentCode : agentCode,
					lineCode : lineCode,
					portOrigin : portOrigin,
					prt1 : prt1,
					prt2 : prt2,
					prt3 : prt3,
				    last1 :last1,
					last2 :last2,
					last3 : last3,
					portOfArrival : portOfArrival,
					vesselTypes : VesselTypes,
					generalDescription : generalDescription,
					nationalityOfVessel : NationalityOfVessel,
					masterName : MasterName,
					igmNo : igmNo,
					igmDate : igmDate,
					aDate : aDate,
					aTime : aTime,
					ataAd : ataAd,
					ataAt : ataAt,
					totalItem : totalItem,
					lighthouseDue : LighthouseDue,
					grossWeightVessel : GrossWeightVessel,
					netWeightVessel : NetWeightVessel,
					sameBottomCargo : SameBottomCargo,
					shipStoreDeclaration : ShipStoreDeclaration,
					crewListDeclaration : CrewListDeclaration,
					cargoDeclaration : CargoDeclaration,
					passengerList : PassengerList,
					crewEffect : CrewEffect,
					maritimeDeclaration : MaritimeDeclaration,
					departureManifestNumber:departureManifestNumber,
					departureManifestDate:departureManifestDate,
					submitterType:submitterType,
					submitterCode:submitterCode,
					authorizedRepresentativeCode:authorizedRepresentativeCode,
					shippingLineBondNumber:shippingLineBondNumber,
					modeofTransport:modeofTransport,
					shipType:shipType,
					conveyanceReferenceNumber:conveyanceReferenceNumber,
					totalNoofTransportEquipmentManifested:totalNoofTransportEquipmentManifested,
					cargoDescription:cargoDescription,
					briefCargoDescription:briefCargoDescription,
					expectedDate:expectedDate,
					timeofDeparture:timeofDeparture,
					totalnooftransportcontractsreportedonArrivalDeparture:totalnooftransportcontractsreportedonArrivalDeparture,
					messtype:messtype,
					vesType:vesType,
					authoseaCarcode:authoseaCarcode,
					portoDreg:portoDreg,
					regDate:regDate,
					voyDetails:voyDetails,
					shipItiseq:shipItiseq,
					shipItinerary:shipItinerary,
					portofCallname:portofCallname,
					arrivalDepdetails:arrivalDepdetails,
					totalnoTransarrivdep:totalnoTransarrivdep,
					generatFalg:generatFalg,
					
					serialNumber:serialnumber,
					BLDetails : JSON.stringify(blDetails),
					vesselVoyageDtls : JSON
					.stringify(listOfVesselVoyageSearchDetailsPrepraedJson),
					consigneeDtls : JSON
					.stringify(listOfconsigneeDetailsForSave),
					notifyPartyDlts:JSON
					.stringify(listOfNotifyPartyForSave),
					containerDetailsDtls:JSON
					.stringify(listofcontainerdetailsForSave),
					marksNumberDtlstls:JSON
					.stringify(listofmarksNumberDtlsForSave),
					consignerDtlstls:JSON
					.stringify(listOfconsignerDetailsForSave)
				},error: function(error){
	            	EnableButton();
	            	var mgsnull=document.getElementById("msg");
					mgsnull.innerHTML = '';
					showBarMessages("error : "+error.responseText,1);
	            },
				success : function(result) {
					debugger;
					var mgsnull=document.getElementById("msg");
					mgsnull.innerHTML = '';
					showBarMessages("Manifest File generated successfully.",0);
					var StringResult=JSON.parse(result);
					var downloadfilename="";
					var one="";
					var two="";
					var three="";
					var fore="";
					var five="";
					if(fileNme=='SAM'){one='F'}else if(fileNme=='SAA'){one='A'}else{one='F'}
					two=StringResult['headerField'][0]['senderID'];
					three=StringResult['master'][0]['decRef'][0]['jobNo'];
					fore=StringResult['master'][0]['decRef'][0]['jobDt'];
					downloadfilename=one+'_'+'SACHM23'+'_'+fileNme+'_'+two+'_'+three+'_'+fore+'_'+'DEC'+'.json';
					
					var sampleBytes = new String(result);

					var saveByteArray = (function() {
						var a = document.createElement("a");
						document.body.appendChild(a);
						a.style = "display: none";
						
						return function(data, name) {
							if (navigator.msSaveBlob) {
								blobObject = new Blob(data);
								window.navigator.msSaveOrOpenBlob(blobObject,
										downloadfilename);

							} else {
								var blob = new Blob(data, {
									type : "octet/stream"
								}), url = window.URL.createObjectURL(blob);
								a.href = url;
								a.download = name;
								a.click();
								window.URL.revokeObjectURL(url);
							}
						};
					}());
					saveByteArray([ sampleBytes ], downloadfilename);
				},
				error : function(e) {
					showBarMessages(error,1);
				}
			})
		}
	}
}

/* manifestFileGenerator function
 Ended
 */
function onUpload()
{
	var afload=document.getElementById("msg");	
	afload.innerHTML = '';
	debugger;
	var form = document.getElementById('fileUploadForm');
    var fileData = new FormData(form);
	
		$.ajax({
			method : "POST",
			async : true,
			url : ONEXCEL,
			contentType: false, 
            processData: false,
			beforeSend:function()
			{
				loadingfun();	
			},
			data :fileData ,

			success : function(result) {
				excelResult=JSON.parse(result);
				var count=0;
				for(j=0;j<excelResult.result.length;j++)
				{
					for(i=0;i<idJsonObjectForTextBox.length;i++)
					{
						var blnoex=document.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
						//	console.log(excelResult.result[j].blNo);
						if((excelResult.result[j].blNo)==blnoex)
						{
							//console.log("blno."+excelResult.result[j].blNo);
							document.getElementById(idJsonObjectForTextBox[i]["CFS-Custom Code"]).value
							=excelResult.result[j].customCode;
							document.getElementById(idJsonObjectForTextBox[i]["DPD Movement"]).value
							=excelResult.result[j].dpdMovement;
							document.getElementById(idJsonObjectForTextBox[i]["DPD Code"]).value
							=excelResult.result[j].dpdCode;
							count++;
							break;
						}
					}
				}
				var afload=document.getElementById("msg");	
				afload.innerHTML = '';
				if(count==0)
					showBarMessages("No BL Matched.",1)
				else
				    showBarMessages("Excel Uploaded successFully.",0)
			},
			error : function(e) {
				showBarMessages(error);
			}
		});
	

}
/*popup page method Consigneepopup() started........... */	

/*function consigneeInfo(selectObject) {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var popupWindow=""
	console.log(consigneeInfor);
	consigneeInfor = true;
	if (popupWindow && !popupWindow.closed)
		popupWindow.focus();
	else{
		popupWindow=null;
		popupWindow = window
		.open(
				"/EZLL_WEB_APP/pages/ell/ImportGeneralManifestConsignee.jsp",
				"_blank", "width=1050,height=350, top=100, left=160,");
	}
	if (window.focus) {popupWindow.focus()}*/

	 function consigneeMethod(popupWindow,selectObject){
		//debugger;
		
		var idr=selectObject.id;
		var X=document.getElementById(idr).getAttribute("servicepath");
		var Y=document.getElementById(idr).getAttribute("blspath");
		//consinfot = popupWindow.document.getElementById("consigneeInformation");
		consigneeCode = popupWindow.document.getElementById("consigneeCode");
		consigneeName = popupWindow.document.getElementById("consigneeName");
		consigneeAdress1 = popupWindow.document.getElementById("consigneeAdress1");
		consigneeAdress2 = popupWindow.document.getElementById("consigneeAdress2");
		consigneeAdress3 = popupWindow.document.getElementById("consigneeAdress3");
		consigneeAdress4 = popupWindow.document.getElementById("consigneeAdress4");
		consigneeCity = popupWindow.document.getElementById("consigneeCity");
		consigneeState = popupWindow.document.getElementById("consigneeState");
		consigneeCountry = popupWindow.document.getElementById("consigneeCountry");
		consigneeZip = popupWindow.document.getElementById("consigneeZip");
		consigneeBlNo = popupWindow.document.getElementById("consigneeBlNo");
		//consinfot.innerHTML = '';
		consigneeCode.innerHTML = '';
		consigneeName.innerHTML = '';
		consigneeAdress1.innerHTML = '';
		consigneeAdress2.innerHTML = '';
		consigneeAdress3.innerHTML = '';
		consigneeAdress4.innerHTML = '';
		consigneeCity.innerHTML = '';
		consigneeState.innerHTML = '';
		consigneeCountry.innerHTML = '';
		consigneeZip.innerHTML = '';
		consigneeBlNo.innerHTML = '';
		
		listOfconsigneeInformation = [];
		//console.log(popupjson);
		var consigneeInformationpath=popupjson.popup[document.getElementById(Y+"BL#").value].consignee;
		var CNINF=popupWindow.CNINF;
		consigneeInformationpath[0].vaidation="TRUE";
		for (j = 0; j < consigneeInformationpath.length; j++) {
			var eachconsigneeInformationRow = {};	
			for(i=0;i<CNINF.length;i++)
			{
				if(CNINF[i].columnName=="Code") 
				{	
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeCode.appendChild(element);
				}
				else if(CNINF[i].columnName=="Name") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapname");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeName.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					consinfot.appendChild(node);*/
				}
				else if(CNINF[i].columnName=="Address1") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapadress");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeAdress1.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					consinfot.appendChild(node);*/
				}
				else if(CNINF[i].columnName=="Address2") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapadress");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeAdress2.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					consinfot.appendChild(node);*/
				}
				else if(CNINF[i].columnName=="Address3") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapadress");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeAdress3.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					consinfot.appendChild(node);*/
				}
				else if(CNINF[i].columnName=="Address4") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapadress");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeAdress4.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					consinfot.appendChild(node);*/
				}
				else if(CNINF[i].columnName =="City") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeCity.appendChild(element);
				}
				else if(CNINF[i].columnName=="State") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeState.appendChild(element);
				}
				else if(CNINF[i].columnName=="Country") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeCountry.appendChild(element);
				}
				else if(CNINF[i].columnName=="BLNO") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log("blNO");
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else {
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeBlNo.appendChild(element);
				}
				else if(CNINF[i].columnName=="Zip") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CNINF[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", CNINF[i].columnName);
					element.setAttribute("id", j
							+ CNINF[i].columnName);
					eachconsigneeInformationRow[CNINF[i].columnName] = j
					+ CNINF[i].columnName;
					//console.log(CNINF[i].mappedCol);
					//console.log(consigneeInformationpath[j][CNINF[i].mappedCol]);
					if (!consigneeInformationpath[j][CNINF[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								consigneeInformationpath[j][CNINF[i].mappedCol]);
					}
					consigneeZip.appendChild(element);
				}
			}
			listOfconsigneeInformation
			.push(eachconsigneeInformationRow);
			/*var node = popupWindow.document.createElement("p");
			consinfot.appendChild(node);*/
			//console.log(listOfconsigneeInformation);
		}
	}
	// this.consigneeme();
	/*if (popupWindow.addEventListener) {
		//popupWindow.addEventListener("load", this.consigneeme, false);
		 this.consigneeme();
	}
	else if (popupWindow.attachEvent) {
		popupWindow.attachEvent('onload', this.consigneeme);
	}
	else {
		wnd.onload = evt.consigneeme;
	}
}*/

/*popup page method notifyInfo() started........... */	

/*function notifyInfo(selectObject) {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	notifyInfor = true;
	if (popupWindow && !popupWindow.closed)
		popupWindow.focus();
	else{
		popupWindow=null;
		popupWindow = window
		.open(
				"/EZLL_WEB_APP/pages/ell/ImportGeneralManifestNotifyParty.jsp",
				"_blank", "width=1050,height=350, top=100, left=160,");
	}

	if (window.focus) {popupWindow.focus()}*/

	 
	 function consignerMethod(popupWindow,selectObject){
			debugger;
			
			var idr=selectObject.id;
			var X=document.getElementById(idr).getAttribute("servicepath");
			var Y=document.getElementById(idr).getAttribute("blspath");
			//consinfot = popupWindow.document.getElementById("ConsignerInformation");
			ConsignerCode = popupWindow.document.getElementById("ConsignerCode");
			ConsignerName = popupWindow.document.getElementById("ConsignerName");
			ConsignerAdress1 = popupWindow.document.getElementById("ConsignerAdress1");
			ConsignerAdress2 = popupWindow.document.getElementById("ConsignerAdress2");
			ConsignerAdress3 = popupWindow.document.getElementById("ConsignerAdress3");
			ConsignerAdress4 = popupWindow.document.getElementById("ConsignerAdress4");
			ConsignerCity = popupWindow.document.getElementById("ConsignerCity");
			ConsignerState = popupWindow.document.getElementById("ConsignerState");
			ConsignerCountry = popupWindow.document.getElementById("ConsignerCountry");
			ConsignerZip = popupWindow.document.getElementById("ConsignerZip");
			ConsignerBlNo = popupWindow.document.getElementById("ConsignerBlNo");
			//consinfot.innerHTML = '';
			ConsignerCode.innerHTML = '';
			ConsignerName.innerHTML = '';
			ConsignerAdress1.innerHTML = '';
			ConsignerAdress2.innerHTML = '';
			ConsignerAdress3.innerHTML = '';
			ConsignerAdress4.innerHTML = '';
			ConsignerCity.innerHTML = '';
			ConsignerState.innerHTML = '';
			ConsignerCountry.innerHTML = '';
			ConsignerZip.innerHTML = '';
			ConsignerBlNo.innerHTML = '';
			
			listOfConsignerInformation = [];
			//console.log(popupjson);
			var ConsignerInformationpath=popupjson.popup[document.getElementById(Y+"BL#").value].consigner;
			var CONSIGNERNINF=popupWindow.CONSIGNERNINF;
			ConsignerInformationpath[0].vaidation="TRUE";
			for (j = 0; j < ConsignerInformationpath.length; j++) {
				var eachConsignerInformationRow = {};	
				for(i=0;i<CONSIGNERNINF.length;i++)
				{
					if(CONSIGNERNINF[i].columnName=="Code") 
					{	
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapnormal");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerCode.appendChild(element);
					}
					else if(CONSIGNERNINF[i].columnName=="Name") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapname");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerName.appendChild(element);
						/*var node = popupWindow.document.createElement("p");
						consinfot.appendChild(node);*/
					}
					else if(CONSIGNERNINF[i].columnName=="Address1") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapadress");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerAdress1.appendChild(element);
						/*var node = popupWindow.document.createElement("p");
						consinfot.appendChild(node);*/
					}
					else if(CONSIGNERNINF[i].columnName=="Address2") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapadress");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerAdress2.appendChild(element);
						/*var node = popupWindow.document.createElement("p");
						consinfot.appendChild(node);*/
					}
					else if(CONSIGNERNINF[i].columnName=="Address3") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapadress");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerAdress3.appendChild(element);
						/*var node = popupWindow.document.createElement("p");
						consinfot.appendChild(node);*/
					}
					else if(CONSIGNERNINF[i].columnName=="Address4") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapadress");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerAdress4.appendChild(element);
						/*var node = popupWindow.document.createElement("p");
						consinfot.appendChild(node);*/
					}
					else if(CONSIGNERNINF[i].columnName =="City") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapnormal");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerCity.appendChild(element);
					}
					else if(CONSIGNERNINF[i].columnName=="State") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapnormal");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerState.appendChild(element);
					}
					else if(CONSIGNERNINF[i].columnName=="Country") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapnormal");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerCountry.appendChild(element);
					}
					else if(CONSIGNERNINF[i].columnName=="BLNO") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapnormal");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log("blNO");
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else {
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerBlNo.appendChild(element);
					}
					else if(CONSIGNERNINF[i].columnName=="Zip") 
					{
						var element = popupWindow.document.createElement("input");
						element.setAttribute("type", CONSIGNERNINF[i].type);
						element.setAttribute("class", "roundshapnormal");
						element.setAttribute("name", CONSIGNERNINF[i].columnName);
						element.setAttribute("id", j
								+ CONSIGNERNINF[i].columnName);
						eachConsignerInformationRow[CONSIGNERNINF[i].columnName] = j
						+ CONSIGNERNINF[i].columnName;
						//console.log(CONSIGNERNINF[i].mappedCol);
						//console.log(ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						if (!ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]) {
							element.setAttribute("value", "");
						} else 
						{
							element.setAttribute("value",
									ConsignerInformationpath[j][CONSIGNERNINF[i].mappedCol]);
						}
						ConsignerZip.appendChild(element);
					}
				}
				listOfConsignerInformation
				.push(eachConsignerInformationRow);
				/*var node = popupWindow.document.createElement("p");
				consinfot.appendChild(node);*/
				//console.log(listOfConsignerInformation);
			}
		}
	 
	 function notifyPartyme(popupWindow,selectObject){
		//debugger;
		 for(var i=0;i<1000;i++)
			{
			if(i==999)
				{
				console.log(popupWindow);
				console.log(selectObject);
				}
			}
		var idr=selectObject.id;
		var X=document.getElementById(idr).getAttribute("servicepath");
		var Y=document.getElementById(idr).getAttribute("blspath");
		//notifyInfot = popupWindow.document.getElementById("notifyPartyinfodtl");
		NotifyCode = popupWindow.document.getElementById("NotifyCode");
		NotifyName = popupWindow.document.getElementById("NotifyName");
		NotifyAdress1 = popupWindow.document.getElementById("NotifyAdress1");
		NotifyAdress2 = popupWindow.document.getElementById("NotifyAdress2");
		NotifyAdress3 = popupWindow.document.getElementById("NotifyAdress3");
		NotifyAdress4 = popupWindow.document.getElementById("NotifyAdress4");
		NotifyCity = popupWindow.document.getElementById("NotifyCity");
		NotifyState = popupWindow.document.getElementById("NotifyState");
		NotifyCountry = popupWindow.document.getElementById("NotifyCountry");
		NotifyZip = popupWindow.document.getElementById("NotifyZip");
		NotifyBlNo = popupWindow.document.getElementById("NotifyBlNo");
		//notifyInfot.innerHTML = '';
		NotifyCode.innerHTML = '';
		NotifyName.innerHTML = '';
		NotifyAdress1.innerHTML = '';
		NotifyAdress2.innerHTML = '';
		NotifyAdress3.innerHTML = '';
		NotifyAdress4.innerHTML = '';
		NotifyCity.innerHTML = '';
		NotifyState.innerHTML = '';
		NotifyCountry.innerHTML = '';
		NotifyZip.innerHTML = '';
		NotifyBlNo.innerHTML = '';
		listOfnotifyInformation = [];
		//console.log(popupjson);
		var notifyInformationpath=popupjson.popup[document.getElementById(Y+"BL#").value].notifyParty;
		notifyInformationpath[0].vaidation="TRUE";
		var NTP=popupWindow.NTP;
		for (j = 0; j < notifyInformationpath.length; j++) {
			var eachnotifyInformationRow = {};	
			for(i=0;i<NTP.length;i++)
			{

				if(NTP[i].columnName=="Notify Code") 
				{						
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("id", i
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = i
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}

					NotifyCode.appendChild(element);
				}
				else if(NTP[i].columnName=="Notify Name") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapname");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}

					NotifyName.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					notifyInfot.appendChild(node);*/
				}
				else if(NTP[i].columnName=="Notify Address1") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapadress");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}
					NotifyAdress1.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					notifyInfot.appendChild(node);*/
				}
				else if(NTP[i].columnName=="Notify Address2") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapadress");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}
					NotifyAdress2.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					notifyInfot.appendChild(node);*/
				}
				else if(NTP[i].columnName=="Notify Address3") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapadress");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}
					NotifyAdress3.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					notifyInfot.appendChild(node);*/
				}
				else if(NTP[i].columnName=="Notify Address4") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapadress");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}
					NotifyAdress4.appendChild(element);
					/*var node = popupWindow.document.createElement("p");
					notifyInfot.appendChild(node);*/
				}
				else if(NTP[i].columnName =="City") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}
					NotifyCity.appendChild(element);
				}
				else if(NTP[i].columnName=="State") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}

					NotifyState.appendChild(element);
				}
				else if(NTP[i].columnName=="Country") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}

					NotifyCountry.appendChild(element);
				}
				else if(NTP[i].columnName=="Zip") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", j
							+ NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = j
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}
					NotifyZip.appendChild(element);
				}
				else if(NTP[i].columnName=="BLNO") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", NTP[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", NTP[i].columnName);
					element.setAttribute("id", i
							+NTP[i].columnName);
					eachnotifyInformationRow[NTP[i].columnName] = i
					+ NTP[i].columnName;
					//console.log(NTP[i].mappedCol);
					//console.log(notifyInformationpath[j][NTP[i].mappedCol]);
					if (!notifyInformationpath[j][NTP[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								notifyInformationpath[j][NTP[i].mappedCol]);
					}
					NotifyBlNo.appendChild(element);
				}
			}
			listOfnotifyInformation
			.push(eachnotifyInformationRow);
			/*var node = popupWindow.document.createElement("p");
			notifyInfot.appendChild(node);*/
		}
	}
	/*//this.notifyPartyme();
	if (popupWindow.addEventListener) {
		//popupWindow.addEventListener("load", this.notifyPartyme, false);
		this.notifyPartyme();
	}
	else if (popupWindow.attachEvent) {
		popupWindow.attachEvent('onload', this.notifyPartyme);
	}
	else {
		wnd.onload = evt.notifyPartyme;
	}
}*/

/*popup page method marksInfo() started........... */	

/*function marksInfo(selectObject) {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var popupWindow="";
	
	marksInfor = true;
	if(popupWindow && !popupWindow.closed)
		popupWindow.focus();
	else
	{
		popupWindow=null;
		popupWindow = window
		.open(
				"/EZLL_WEB_APP/pages/ell/ImportGeneralManifestMarksNumber.jsp",
				"_blank", "width=800,height=400, top=100, left=300,");
	}

	if (window.focus) {popupWindow.focus()}*/

	 function markNumberme(popupWindow,selectObject){
		//debugger;
		var idr=selectObject.id;
		var X=document.getElementById(idr).getAttribute("servicepath");
		var Y=document.getElementById(idr).getAttribute("blspath");
		marksInfot = popupWindow.document.getElementById("marksNumberinfo");
		marksInfot.innerHTML = '';
		listOfMarksNumberInformation = [];
		//console.log(popupjson);
		var marksInformationpath=popupjson.popup[document.getElementById(Y+"BL#").value].marksNumber;
		marksInformationpath[0].vaidation="TRUE";
		var MND=popupWindow.MND;
		for (j = 0; j < marksInformationpath.length; j++) {
			var eachmarksInformationRow = {};	
			for(i=0;i< MND.length;i++)
			{

				if(MND[i].columnName=="MarksNo") 
				{						
					var element = popupWindow.document.createElement("textarea");
					element.setAttribute("type", MND[i].type);
					element.setAttribute("class", "marksNo");
					element.setAttribute("name", MND[i].columnName);
					element.setAttribute("id", j
							+ MND[i].columnName);
					eachmarksInformationRow[MND[i].columnName] = j
					+ MND[i].columnName;
					//console.log(MND[i].mappedCol);
					//console.log(marksInformationpath[j][MND[i].mappedCol]);
					if (!marksInformationpath[j][MND[i].mappedCol]) {
						element.innerText = "";
					} else 
					{
						element.innerText=marksInformationpath[j][MND[i].mappedCol];
					}
					marksInfot.appendChild(element);
				}
				else if(MND[i].columnName=="Description") 
				{
					var element = popupWindow.document.createElement("textarea");
					element.setAttribute("type", MND[i].type);
					element.setAttribute("class", "description");
					element.setAttribute("name", MND[i].columnName);
					element.setAttribute("id", j
							+ MND[i].columnName);
					eachmarksInformationRow[MND[i].columnName] = j
					+ MND[i].columnName;
					//console.log(MND[i].mappedCol);
					//console.log(marksInformationpath[j][MND[i].mappedCol]);
					if (!marksInformationpath[j][MND[i].mappedCol]) {
						element.innerText="";
					} else 
					{
						element.innerText=marksInformationpath[j][MND[i].mappedCol];
					}

					marksInfot.appendChild(element);
				}
				else if(MND[i].columnName=="BLNO") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", MND[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", MND[i].columnName);
					element.setAttribute("id", j
							+ MND[i].columnName);
					eachmarksInformationRow[MND[i].columnName] = j
					+ MND[i].columnName;
					//console.log(MND[i].mappedCol);
					//console.log(marksInformationpath[j][MND[i].mappedCol]);
					if (!marksInformationpath[j][MND[i].mappedCol]) {
						element.innerText="";
					} else 
					{
						element.setAttribute("value", marksInformationpath[j][MND[i].mappedCol]);
					}
					marksInfot.appendChild(element);
				}

			}	
			listOfMarksNumberInformation
			.push(eachmarksInformationRow);
			var node = popupWindow.document.createElement("p");
			marksInfot.appendChild(node);
		}
	}
	//this.markNumberme();
	/*if (popupWindow.addEventListener) {
		//popupWindow.addEventListener("load", this.markNumberme, false);
		this.markNumberme();
	}
	else if (popupWindow.attachEvent) {
		popupWindow.attachEvent('onload', this.markNumberme);
	}
	else {
		this.markNumberme();
	}
}*/

/*popup page method containerDetailsInfo() started........... */

/*function containerDetailsInfo(selectObject) {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var popupWindow="";
	containerDetailsInfor = true;
	listOfcontainerDetailsInformation = [];
	if (popupWindow && !popupWindow.closed)
		popupWindow.focus();
	else
	{
		popupWindow=null;
		popupWindow = window
		.open(
				"/EZLL_WEB_APP/pages/ell/ImportGeneralManifestContainerDetails.jsp",
				"_blank", "width=1150,height=350, top=100, left=160,");
	}

	if (window.focus) {popupWindow.focus()} */

	 function containerme(popupWindow,selectObject){
		debugger;
		var idr=selectObject.id;
		var X=document.getElementById(idr).getAttribute("servicepath");
		var Y=document.getElementById(idr).getAttribute("blspath");
		listOfcontainerDetailsInformation = [];
		containerinfot = popupWindow.document.getElementById("containerDetailsinfo");
		containerinfot.innerHTML = '';
		//console.log(popupjson.popup[document.getElementById(Y+"BL#").value].containerDetailes.length)
		var containerDetailsInfonpath=popupjson.popup[document.getElementById(Y+"BL#").value].containerDetailes;
		//console.log(popupjson);
		containerDetailsInfonpath[0].vaidation="TRUE";
		var CND=popupWindow.CND;
		for (j = 0; j < containerDetailsInfonpath.length; j++) {
			var eachcontainerDetailsInfonRow = {};	

			var element1=popupWindow.document.createElement("input");
			element1.setAttribute("type", "sequence");
			element1.setAttribute("class", "roundshapSeq");
			element1.setAttribute("id" , j + "seqNo"); 
			element1.setAttribute("name" , "seqNo"); 
			element1.setAttribute("value" , j+1);
			element1.setAttribute("readonly", true);
			eachcontainerDetailsInfonRow["seq"]=j +	"seqNo";
			containerinfot.appendChild(element1);

			for(i=0;i<CND.length;i++)
			{
				eachcontainerDetailsInfonRow["X"]=X;
				eachcontainerDetailsInfonRow["Y"]=Y;

				if(CND[i].columnName=="Container No") 
				{						
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CND[i].type);
					element.setAttribute("class", "roundshapnormal");
					element.setAttribute("name", CND[i].columnName);
					element.setAttribute("id", j
							+ CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					//console.log(CND[i].mappedCol);
					//console.log(containerDetailsInfonpath[j][CND[i].mappedCol])
					if (!containerDetailsInfonpath[j][CND[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								containerDetailsInfonpath[j][CND[i].mappedCol]);
					}
					containerinfot.appendChild(element);
				}
				else if(CND[i].columnName=="Container Seal No") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CND[i].type);
					element.setAttribute("class", "containerSealNo");
					element.setAttribute("name", CND[i].columnName);
					element.setAttribute("id", j
							+ CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					//console.log(CND[i].mappedCol);
					//console.log(containerDetailsInfonpath[j][CND[i].mappedCol])
					if (!containerDetailsInfonpath[j][CND[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								containerDetailsInfonpath[j][CND[i].mappedCol]);
					}
					containerinfot.appendChild(element);
				}
				else if(CND[i].columnName=="Container Agent Code") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CND[i].type);
					element.setAttribute("class", "containerAgentCode");
					element.setAttribute("name", CND[i].columnName);
					element.setAttribute("id", j
							+ CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					//console.log(CND[i].mappedCol);
					//console.log(containerDetailsInfonpath[j][CND[i].mappedCol])
					if (!containerDetailsInfonpath[j][CND[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								containerDetailsInfonpath[j][CND[i].mappedCol]);
					}
					containerinfot.appendChild(element);
				}
				else if(CND[i].columnName =="Container Status") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CND[i].type);
					element.setAttribute("class", "containeStatus");
					element.setAttribute("name", CND[i].columnName);
					element.setAttribute("id", j
							+ CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					//console.log(CND[i].mappedCol);
					//console.log(containerDetailsInfonpath[j][CND[i].mappedCol])
					if (!containerDetailsInfonpath[j][CND[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								containerDetailsInfonpath[j][CND[i].mappedCol]);
					}
					containerinfot.appendChild(element);
				}
				else if(CND[i].columnName=="Total No. Of Packages in Container") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CND[i].type);
					element.setAttribute("class", "noPackages");
					element.setAttribute("name", CND[i].columnName);
					element.setAttribute("id", j
							+ CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					//console.log(CND[i].mappedCol);
					//console.log(containerDetailsInfonpath[j][CND[i].mappedCol])
					if (!containerDetailsInfonpath[j][CND[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								containerDetailsInfonpath[j][CND[i].mappedCol]);
					}

					containerinfot.appendChild(element);
				}
				else if(CND[i].columnName=="Container Weight") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CND[i].type);
					element.setAttribute("class", "containerWeight");
					element.setAttribute("name", CND[i].columnName);
					element.setAttribute("id", j
							+ CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					//console.log(CND[i].mappedCol);
					//console.log(containerDetailsInfonpath[j][CND[i].mappedCol])
					if (!containerDetailsInfonpath[j][CND[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								containerDetailsInfonpath[j][CND[i].mappedCol]);
					}
					containerinfot.appendChild(element);
				}
				else if(CND[i].columnName=="ISO Code") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CND[i].type);
					element.setAttribute("class", "ISOCode");
					element.setAttribute("name", CND[i].columnName);
					element.setAttribute("id", j
							+ CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					//console.log(CND[i].mappedCol);
					//console.log(containerDetailsInfonpath[j]["ContainerSize"])
					if ((!containerDetailsInfonpath[j]['ContainerSize'])||(!containerDetailsInfonpath[j]['ContainerType'])) {
						element.setAttribute("value", "");
					} else 
					{
						var containerSize=containerDetailsInfonpath[j]["ContainerSize"];
						var containerType=containerDetailsInfonpath[j]["ContainerType"];
						if(containerSize=="")
							element.setAttribute("value", "");
						else if(containerSize=="20")
							element.setAttribute("value", 2000);
						else if(isoValue="40")
							{
							if(containerType=="HC")
								element.setAttribute("value", 4200);
							}
						else
							element.setAttribute("value", 4000);
							
					}
					containerinfot.appendChild(element);
				}
				else if(CND[i].columnName=="BLNO") 
				{
					var element = popupWindow.document.createElement("input");
					element.setAttribute("type", CND[i].type);
					element.setAttribute("class", "ISOCode");
					element.setAttribute("name", CND[i].columnName);
					element.setAttribute("id", j
							+ CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					//console.log(CND[i].mappedCol);
					//console.log(containerDetailsInfonpath[j][CND[i].mappedCol])
					if (!containerDetailsInfonpath[j][CND[i].mappedCol]) {
						element.setAttribute("value", "");
					} else 
					{
						element.setAttribute("value",
								containerDetailsInfonpath[j][CND[i].mappedCol]);
					}
					containerinfot.appendChild(element);
				}
				else if( CND[i].columnName == "Equipment Load Status")
				{
					var element = popupWindow.document.createElement("select");
					//element1.setAttribute("type", bld[t].type);
					element.setAttribute("class", "dropDown")
					element.setAttribute("id", j +  CND[i].columnName);
					element.setAttribute("name",  CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					var equipmentloadstatusval=containerDetailsInfonpath[j][CND[i].mappedCol];
					var el = popupWindow.document.createElement("option");
					var el2 = popupWindow.document.createElement("option");
					var el3 = popupWindow.document.createElement("option");
					el.textContent = "FCL";
					el.value = "FCL";
					element.appendChild(el);
					el2.textContent = "LCL";
					el2.value = "LCL";
					element.appendChild(el2);
					el3.textContent = "EMP";
					el3.value = "EMP";
					element.appendChild(el3);
					if(equipmentloadstatusval!=""){
						element.value=equipmentloadstatusval;}
					else{
						element.value='FCL';
						}	
					containerinfot.appendChild(element);
				}
				else if( CND[i].columnName == "SOC Flagr")
				{
					var element = popupWindow.document.createElement("select");
					//element1.setAttribute("type", bld[t].type);
					element.setAttribute("class", "dropDown")
					element.setAttribute("id", j +  CND[i].columnName);
					element.setAttribute("name",  CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					var equipmentloadstatusval=containerDetailsInfonpath[j][CND[i].mappedCol];
					var el1 = popupWindow.document.createElement("option");
					var el2 = popupWindow.document.createElement("option");
					el1.textContent = "Y";
					el1.value = "Y";
					element.appendChild(el1);
					el2.textContent = "N";
					el2.value = "N";
					element.appendChild(el2);
					
					if(equipmentloadstatusval!=""){
						element.value=equipmentloadstatusval;}
					else{
						element.value='N';
						}	
					containerinfot.appendChild(element);
				}
				else if(CND[i].columnName == "Equipment seal type")
				{
					var element = popupWindow.document.createElement("select");
					//element1.setAttribute("type", bld[t].type);
					element.setAttribute("class", "dropDown")
					element.setAttribute("id", j +  CND[i].columnName);
					element.setAttribute("name",  CND[i].columnName);
					eachcontainerDetailsInfonRow[CND[i].columnName] = j
					+ CND[i].columnName;
					var equipmentsealtype=containerDetailsInfonpath[j][CND[i].mappedCol];
					var el1 = popupWindow.document.createElement("option");
					var el2 = popupWindow.document.createElement("option");
					el1.textContent = "BTSL ";
					el1.value = "BTSL";
					element.appendChild(el1);
					el2.textContent = "ESEAL";
					el2.value = "ESEAL";
					element.appendChild(el2);
					if(equipmentsealtype!=""){
						element.value=equipmentsealtype;}
					else{
						element.value='BTSL';
						}	
					containerinfot.appendChild(element);
				}
			}

			listOfcontainerDetailsInformation
			.push(eachcontainerDetailsInfonRow);
			var node = popupWindow.document.createElement("p");
			containerinfot.appendChild(node);
		}
	}
	//this.containerme();
	/*if (popupWindow.addEventListener) {
		//popupWindow.addEventListener("load", this.containerme, false);
		this.containerme();
	}
	else if (popupWindow.attachEvent) {
		popupWindow.attachEvent('onload', this.containerme);
	}
	else {
		wnd.onload = evt.containerme;
	}
}*/

/*popup page method mergeFiles() started........... */


/*parent_disable() started...*/

function parent_disable() {
	if (popupWindow && !popupWindow.closed)
		popupWindow.focus();
}

/*closeWindow() started...*/

function closeWindow() {

	if (consigneeInfor == true) {
		popupWindow.close();
		window.close();
		return

	}
	else if (consignerInfo == true) {
		popupWindow.close();
		window.close();
		return

	}
	else if (marksInfor == true) {
		popupWindow.close();
		window.close();
		return

	}
	else if (containerDetailsInfor == true) {
		popupWindow.close();
		window.close();
		return

	}
	else if (notifyInfor == true) {
		popupWindow.close();
		window.close();
		return

	}
	else if (meregefile == true) {
		popupWindow.close();
		window.close();
		return

	}
	else {
		window.close();
		return false;
	}
}

/**refreshBtn() called 
 * to comparing the data based on bl version*/

function refreshBtn()
{   var mgsnull=document.getElementById("msg");
mgsnull.innerHTML = '';	
/**enable all button search section*/
disableButton();
debugger;
/* Get the data From ui and send to Backend for refresh*/
var inStatus = document.getElementById("inStatus").value;
var blCreationDateFrom = document.getElementById("blCreationDateFrom").value;
var blCreationDateTo = document.getElementById("blCreationDateTo").value;
var del = document.getElementById("del").value;
var igmservice = document.getElementById("igmservice").value;
var vessel = document.getElementById("vessel").value;
var voyage = document.getElementById("voyage").value;
var direction = document.getElementById("direction").value;
var pol = document.getElementById("pol").value;
var depot = document.getElementById("depo").value;
for (var i = 0; i < listOfVesselVoyageSearchDetails.length; i++) {

	if (document.getElementById(listOfVesselVoyageSearchDetails[i].id).checked == true) {
		var podTerminal =  document.getElementById(listOfVesselVoyageSearchDetails[i]["Terminal"]).value;
	}
}
var pod = document.getElementById("pod").value;
var polTerminal = document.getElementById("polTerminal").value;

$.ajax({
	method : "POST",
	async : true,
	url : ONREFRESH,
	beforeSend:function()
	{
		loadingfun();			
	},
	data : {
		inStatus : inStatus,
		blCreationDateFrom : blCreationDateFrom,
		blCreationDateTo : blCreationDateTo,
		del:del,
		igmservice : igmservice,
		vessel : vessel,
		voyage : voyage,
		direction : direction,
		pol : pol,
		polTerminal : polTerminal,
		pod : pod,
		podTerminal : podTerminal,
		depot:depot
	},
	error: function(error){
    	EnableButton();
    	var mgsnull=document.getElementById("msg");
		mgsnull.innerHTML = '';
		showBarMessages("error : "+error.responseText,1);
    },
	success : function(result) {
		/**enable all button search section*/
		EnableButton();
		result3 = JSON.parse(result);
		if (result3.Refreshresult.length == 0) {
			var mgsnull=document.getElementById("msg");
			mgsnull.innerHTML = '';
			showBarMessages("No data found for this combination",1);
		} else {
			for(i=0;i<idJsonObjectForTextBox.length;i++)
			{
				if(document.getElementById(idJsonObjectForTextBox[i].id).checked==true) 
				{
					var tempBL = document.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
					var IGMBLVersion = document.getElementById(idJsonObjectForTextBox[i]["BL Version"]).value;
					var IGMIsValidate = document.getElementById(idJsonObjectForTextBox[i]["BL Validate Flag"]).value;
					var refreshpath=result3.Refreshresult[0]['BLS'];
					for(j=0; j< refreshpath.length; j++){

						if(tempBL == refreshpath[j].bl)
						{

							if(IGMBLVersion!= refreshpath[j].blVersion){

								document.getElementById(idJsonObjectForTextBox[i]["BL Version"]).value=refreshpath[j].blVersion;
								document.getElementById(idJsonObjectForTextBox[i]["BL_Date"]).value=refreshpath[j].blDate;
								document.getElementById(idJsonObjectForTextBox[i]["BL Status"]).value=refreshpath[j].blStatus;
								document.getElementById(idJsonObjectForTextBox[i]["CFS-Custom Code"]).value=refreshpath[j].cfsName;
								document.getElementById(idJsonObjectForTextBox[i]["Cargo Nature"]).value=refreshpath[j].cargoNature;
								document.getElementById(idJsonObjectForTextBox[i]["Item Type"]).value=refreshpath[j].itemType;
								document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value=refreshpath[j].cargoMovmnt;
								document.getElementById(idJsonObjectForTextBox[i]["Cargo Movement Type"]).value=refreshpath[j].cargoMovmntType;
								document.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value=refreshpath[j].transportMode;


								/*loop for update consignee popup*/	
								for(m=0;m<refreshpath[j].consignee.length;m++)
								{
									popupjson.popup[tempBL].consignee[m]["customerCode"]=refreshpath[j].consignee[m].customerCode;
									popupjson.popup[tempBL].consignee[m]["customerName"]=refreshpath[j].consignee[m].customerName;
									popupjson.popup[tempBL].consignee[m]["addressLine1"]=refreshpath[j].consignee[m].addressLine1;
									popupjson.popup[tempBL].consignee[m]["city"]=refreshpath[j].consignee[m].city;
									popupjson.popup[tempBL].consignee[m]["state"]=refreshpath[j].consignee[m].state;
									popupjson.popup[tempBL].consignee[m]["countryCode"]=refreshpath[j].consignee[m].countryCode;
									popupjson.popup[tempBL].consignee[m]["zip"]=refreshpath[j].consignee[m].zip;
									popupjson.popup[tempBL].consignee[0]["vaidation"]="FALSE";
								}

								for(m=0;m<refreshpath[j].consigner.length;m++)
								{
									popupjson.popup[tempBL].consigner[m]["customerCode"]=refreshpath[j].consigner[m].customerCode;
									popupjson.popup[tempBL].consigner[m]["customerName"]=refreshpath[j].consigner[m].customerName;
									popupjson.popup[tempBL].consigner[m]["addressLine1"]=refreshpath[j].consigner[m].addressLine1;
									popupjson.popup[tempBL].consigner[m]["city"]=refreshpath[j].consigner[m].city;
									popupjson.popup[tempBL].consigner[m]["state"]=refreshpath[j].consigner[m].state;
									popupjson.popup[tempBL].consigner[m]["countryCode"]=refreshpath[j].consigner[m].countryCode;
									popupjson.popup[tempBL].consigner[m]["zip"]=refreshpath[j].consigner[m].zip;
									popupjson.popup[tempBL].consigner[0]["vaidation"]="FALSE";
								}
								
								/*loop for update notifyParty popup*/
								for(m=0;m<refreshpath[j].notifyParty.length;m++)
								{
									popupjson.popup[tempBL].notifyParty[m]["customerCode"]=refreshpath[j].notifyParty[m].costumerCode;
									popupjson.popup[tempBL].notifyParty[m]["customerName"]=refreshpath[j].notifyParty[m].costumerName;
									popupjson.popup[tempBL].notifyParty[m]["addressLine1"]=refreshpath[j].notifyParty[m].addressLine1;
									popupjson.popup[tempBL].notifyParty[m]["city"]=refreshpath[j].notifyParty[m].city;
									popupjson.popup[tempBL].notifyParty[m]["state"]=refreshpath[j].notifyParty[m].state;
									popupjson.popup[tempBL].notifyParty[m]["countryCode"]=refreshpath[j].notifyParty[m].countryCode;
									popupjson.popup[tempBL].notifyParty[m]["zip"]=refreshpath[j].notifyParty[m].zip;
									popupjson.popup[tempBL].notifyParty[0]["vaidation"]="FALSE";
								}

								/*loop for update marksNumber popup*/
								for(m=0;m<refreshpath[j].marksNumber.length;m++)
								{
									popupjson.popup[tempBL].notifyParty[m]["marksNumbers"]=refreshpath[j].notifyParty[m].marksNumbers;
									popupjson.popup[tempBL].notifyParty[m]["description"]=refreshpath[j].notifyParty[m].description;
									popupjson.popup[tempBL].notifyParty[0]["vaidation"]="FLASE";
								}

								/*loop for update containerDetailes popup json*/
								for(m=0;m<refreshpath[j].containerDetailes.length;m++)
								{
									popupjson.popup[tempBL].containerDetailes[m]["containerNumber"]=refreshpath[j].containerDetailes[m].containerNumber;
									popupjson.popup[tempBL].containerDetailes[m]["containerSealNumber"]=refreshpath[j].containerDetailes[m].containerSealNumber;
									popupjson.popup[tempBL].containerDetailes[m]["containerAgentCode"]=refreshpath[j].containerDetailes[m].containerAgentCode;
									popupjson.popup[tempBL].containerDetailes[m]["status"]=refreshpath[j].containerDetailes[m].status;
									popupjson.popup[tempBL].containerDetailes[m]["totalNumberOfPackagesInContainer"]=refreshpath[j].containerDetailes[m].totalNumberOfPackagesInContainer;
									popupjson.popup[tempBL].containerDetailes[m]["containerWeight"]=refreshpath[j].containerDetailes[m].containerWeight;
									popupjson.popup[tempBL].containerDetailes[m]["ISOCode"]=refreshpath[j].containerDetailes[m].ISOCode;
									popupjson.popup[tempBL].containerDetailes[0]["vaidation"]="FLASE";
								}							

								if((IGMIsValidate)=="TRUE")
								{
									removeblColorChange(i);
								}
								clolorChangeToPink(i);
							}
							/*else
							{
								console.log("bl no. :"+tempBL);
							}*/
							break;
						}
					}
				}
			}

			var mgsnull=document.getElementById("msg");
			mgsnull.innerHTML = '';
			showBarMessages("refresh completed",0);
		}
	}
});
}

function loadingfun()
{
//	document.getElementById("msg").classList.add("loader");
	var theDiv = document.getElementById("msg");
//	var content = document.createTextNode("Loading..");
	var sp1 = document.createElement("span");
	sp1.innerHTML = ".";
	var sp2 = document.createElement("span");
	sp2.innerHTML = ".";
	var sp3 = document.createElement("span");
	sp3.innerHTML = ".";
	var load = document.createElement("P");
	load.setAttribute("id","loading");
	load.setAttribute("class","loading");
	var t = document.createTextNode("Loading"); 
	load.appendChild(t); 
	load.appendChild(sp1);
	load.appendChild(sp2);
	load.appendChild(sp3);

	theDiv.appendChild(load);
//	document.getElementById("loading").style.display="block";

}


function disableButton()
{
	document.getElementById("refreshButton").disabled = true;
	document.getElementById("btnCreateBayPlan").disabled = true;
	document.getElementById("generatetype").disabled = true;
	document.getElementById("onfindData").disabled = true;
	document.getElementById("onResetData").disabled = true;
	document.getElementById("submitype").disabled = true;
	document.getElementById("manifestfilegeneratoredifile").disabled = true;
}
function EnableButton()
{
	document.getElementById("refreshButton").disabled = false;
	document.getElementById("btnCreateBayPlan").disabled = false;
	document.getElementById("generatetype").disabled = false;
	document.getElementById("onfindData").disabled = false;
	document.getElementById("onResetData").disabled = false;
	document.getElementById("submitype").disabled = false;
	document.getElementById("manifestfilegeneratoredifile").disabled =false;
}

/** start for all child window closing */
var arrChilds = new Array();

function doCloseAllChilds() {

	var x=0;
	var V;

	for (x=0; x<arrChilds.length; x++) {
		try{
			V = arrChilds[x];
			V.window.close();
		}catch(e){
//			do nothing...
		}
	}
}
/** end for all child window closing */

window.onbeforeunload = confirmExit;
function confirmExit() {
	popupWindow.close();	
}

function blColorChange(L)
{
	document.getElementById(L+"sequence").classList.add("validateBL");
	document.getElementById(L+"Item Number").classList.add("validateBL");
	document.getElementById(L+"BL#").classList.add("validateBL");
	document.getElementById(L+"BL Version").classList.add("validateBL");
	document.getElementById(L+"BL_Date").classList.add("validateBL");
	document.getElementById(L+"CFS-Custom Code").classList.add("validateBL");
	document.getElementById(L+"Cargo Nature").classList.add("validateBL");
	document.getElementById(L+"Item Type").classList.add("validateBL");
	document.getElementById(L+"Cargo Movement").classList.add("validateBL");
	document.getElementById(L+"Cargo Movement Type").classList.add("validateBL");
	document.getElementById(L+"Transport Mode").classList.add("validateBL");
	document.getElementById(L+"Road Carr code").classList.add("validateBL");
	document.getElementById(L+"TP Bond No").classList.add("validateBL");
	document.getElementById(L+"Submit Date Time").classList.add("validateBL");
	document.getElementById(L+"DPD Movement").classList.add("validateBL");
	document.getElementById(L+"DPD Code").classList.add("validateBL");
	
	document.getElementById(L+"Consolidated Indicator").classList.add("validateBL");
	document.getElementById(L+"Previous Declaration").classList.add("validateBL");
	document.getElementById(L+"Consolidator PAN").classList.add("validateBL");
	document.getElementById(L+"CIN TYPE").classList.add("validateBL");
	document.getElementById(L+"MCIN").classList.add("validateBL");
	document.getElementById(L+"CSN Submitted Type").classList.add("validateBL");
	document.getElementById(L+"CSN Submitted by").classList.add("validateBL");
	document.getElementById(L+"CSN Reporting Type").classList.add("validateBL");
	document.getElementById(L+"CSN Site ID").classList.add("validateBL");
	document.getElementById(L+"CSN Number").classList.add("validateBL");
	document.getElementById(L+"CSN Date").classList.add("validateBL");
	document.getElementById(L+"Previous MCIN").classList.add("validateBL");
	document.getElementById(L+"Split Indicator").classList.add("validateBL");
	document.getElementById(L+"Number of Packages").classList.add("validateBL");
	document.getElementById(L+"Type of Package").classList.add("validateBL");
	document.getElementById(L+"First Port of Entry/Last Port of Departure").classList.add("validateBL");

	document.getElementById(L+"Type Of Cargo").classList.add("validateBL");
	document.getElementById(L+"Split Indicator List").classList.add("validateBL");
	document.getElementById(L+"Port of Acceptance").classList.add("validateBL");
	document.getElementById(L+"Port of Receipt").classList.add("validateBL");
	document.getElementById(L+"UCR Type").classList.add("validateBL");
	document.getElementById(L+"UCR Code").classList.add("validateBL");
}

function removeblColorChange(L)
{
	
	document.getElementById(L+"sequence").classList.remove("validateBL");
	document.getElementById(L+"Item Number").classList.remove("validateBL");
	document.getElementById(L+"BL#").classList.remove("validateBL");
	document.getElementById(L+"BL Version").classList.remove("validateBL");
	document.getElementById(L+"BL_Date").classList.remove("validateBL");
	document.getElementById(L+"CFS-Custom Code").classList.remove("validateBL");
	document.getElementById(L+"Cargo Nature").classList.remove("validateBL");
	document.getElementById(L+"Item Type").classList.remove("validateBL");
	document.getElementById(L+"Cargo Movement").classList.remove("validateBL");
	document.getElementById(L+"Cargo Movement Type").classList.remove("validateBL");
	document.getElementById(L+"Transport Mode").classList.remove("validateBL");
	document.getElementById(L+"Road Carr code").classList.remove("validateBL");
	document.getElementById(L+"TP Bond No").classList.remove("validateBL");
	document.getElementById(L+"Submit Date Time").classList.remove("validateBL");
	document.getElementById(L+"DPD Movement").classList.remove("validateBL");
	document.getElementById(L+"DPD Code").classList.remove("validateBL");
	
	document.getElementById(L+"Consolidated Indicator").classList.remove("validateBL");
	document.getElementById(L+"Previous Declaration").classList.remove("validateBL");
	document.getElementById(L+"Consolidator PAN").classList.remove("validateBL");
	document.getElementById(L+"CIN TYPE").classList.remove("validateBL");
	document.getElementById(L+"MCIN").classList.remove("validateBL");
	document.getElementById(L+"CSN Submitted Type").classList.remove("validateBL");
	document.getElementById(L+"CSN Submitted by").classList.remove("validateBL");
	document.getElementById(L+"CSN Reporting Type").classList.remove("validateBL");
	document.getElementById(L+"CSN Site ID").classList.remove("validateBL");
	document.getElementById(L+"CSN Number").classList.remove("validateBL");
	document.getElementById(L+"CSN Date").classList.remove("validateBL");
	document.getElementById(L+"Previous MCIN").classList.remove("validateBL");
	document.getElementById(L+"Split Indicator").classList.remove("validateBL");
	document.getElementById(L+"Number of Packages").classList.remove("validateBL");
	document.getElementById(L+"Type of Package").classList.remove("validateBL");
	document.getElementById(L+"First Port of Entry/Last Port of Departure").classList.remove("validateBL");

	document.getElementById(L+"Type Of Cargo").classList.remove("validateBL");
	document.getElementById(L+"Split Indicator List").classList.remove("validateBL");
	document.getElementById(L+"Port of Acceptance").classList.remove("validateBL");
	document.getElementById(L+"Port of Receipt").classList.remove("validateBL");
	document.getElementById(L+"UCR Type").classList.remove("validateBL");
	document.getElementById(L+"UCR Code").classList.remove("validateBL");
}

function clolorChangeToPink(L)
{
	document.getElementById(L+"sequence").classList.add("refreshcolor");
	document.getElementById(L+"Item Number").classList.add("refreshcolor");
	document.getElementById(L+"BL#").classList.add("refreshcolor");
	document.getElementById(L+"BL Version").classList.add("refreshcolor");
	document.getElementById(L+"BL_Date").classList.add("refreshcolor");
	document.getElementById(L+"CFS-Custom Code").classList.add("refreshcolor");
	document.getElementById(L+"Cargo Nature").classList.add("refreshcolor");
	document.getElementById(L+"Item Type").classList.add("refreshcolor");
	document.getElementById(L+"Cargo Movement").classList.add("refreshcolor");
	document.getElementById(L+"Cargo Movement Type").classList.add("refreshcolor");
	document.getElementById(L+"Transport Mode").classList.add("refreshcolor");
	document.getElementById(L+"Road Carr code").classList.add("refreshcolor");
	document.getElementById(L+"TP Bond No").classList.add("refreshcolor");
	document.getElementById(L+"Submit Date Time").classList.add("refreshcolor");
	document.getElementById(L+"DPD Movement").classList.add("refreshcolor");
	document.getElementById(L+"DPD Code").classList.add("refreshcolor");
}


function onUploadAcknowledgment()
{
alert("onUploadAcknowledgment()")	
}
function showBarMessages(strMessage, intErrCode) {
	
	setErrorFlag();
    var objTd = document.getElementById("msg");
    if (objTd != null) {
        if (intErrCode == '1') {
            objTd.innerHTML = "<Font color=red>" + strMessage + "</font>";
        } else {
            objTd.innerHTML = "<Font color=black>"+strMessage+"</font>";
        }
    }
}
function checkNumeric(selectObject)
{
	
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	var id=selectObject.id
	var tempvalue=document.getElementById(id).value;
	var tempName=document.getElementById(id).culumnName;
	if(isNaN(tempvalue))
	{
		document.getElementById(id).value="";
		showBarMessages(tempName+" should be Numeric",1);
		return false;
	}
}


function manifestFileGeneratorEdiFile() {
	var mgsnull=document.getElementById("msg");
	mgsnull.innerHTML = '';
	if (false) {
		showBarMessage("Save The BL Details First.");
		return false
	}else {
		var blDetails = [];
		var listOfVesselVoyageSearchDetailsPrepraedJson = [];
		var listOfconsigneeDetailsForSave=[];
		var listOfconsignerDetailsForSave=[];
		var listOfNotifyPartyForSave=[];
		var listofcontainerdetailsForSave = [];
		var listofmarksNumberDtlsForSave =[];
		var fitn = "";
		var titn = "";
		var itnu = "";

		if ((document.getElementById("totalItem").value == 0)||(document.getElementById("totalItem").value < 0)) {
			showBarMessage("Select BL first.");
		}
		else {

			var inStatus = document.getElementById("inStatus").value;
			var blCreationDateFrom = document.getElementById("blCreationDateFrom").value;
			var blCreationDateTo = document.getElementById("blCreationDateTo").value;
			var igmservice = document.getElementById("igmservice").value;
			var vessel = document.getElementById("vessel").value;
			var voyage = document.getElementById("voyage").value;
			var direction = document.getElementById("direction").value;
			var pol = document.getElementById("pol").value;
			var polTerminal = document.getElementById("polTerminal").value;
			var pod = document.getElementById("pod").value;
			var podTerminal = document.getElementById("podTerminal").value;

			/* get value for 25 fields */

			var customCode = document.getElementById("customCode").value;
			var callSign = document.getElementById("callSign").value;
			var imoCode = document.getElementById("imoCode").value;
			var agentCode = document.getElementById("agentCode").value;
			var lineCode = document.getElementById("lineCode").value;
			var portOrigin = document.getElementById("portOrigin").value;
			var prt1 = document.getElementById("prt1").value;
			var prt2 = document.getElementById("prt2").value;
			var prt3 = document.getElementById("prt3").value;
			
			var last1 = document.getElementById("nprt1").value; //1
			var last2 = document.getElementById("nprt2").value; //2
			var last3 = document.getElementById("nprt3").value; //3
			
			var portOfArrival = document.getElementById("portOfArrival").value;
			var VesselTypes = document.getElementById("cont").value;
			var generalDescription = document.getElementById("generalDescription").value;
			var NationalityOfVessel = document.getElementById("nov").value;
			var MasterName = document.getElementById("mn").value;
			var igmNo = document.getElementById("igmNo").value;
			var igmDate = document.getElementById("igmDate").value;
			var aDate = document.getElementById("aDate").value;
			var aTime = document.getElementById("aTime").value;
			var ataAd = document.getElementById("ataAd").value;
			var ataAt = document.getElementById("ataAt").value;
			var totalItem = document.getElementById("totalItem").value;
			var LighthouseDue = document.getElementById("lhd").value;
			var GrossWeightVessel = document.getElementById("gwv").value;
			var NetWeightVessel = document.getElementById("nwv").value;
			var SameBottomCargo = document.getElementById("smbc").value;
			var ShipStoreDeclaration = document.getElementById("shsd").value;
			var CrewListDeclaration = document.getElementById("crld").value;
			var CargoDeclaration = document.getElementById("card").value;
			var PassengerList = document.getElementById("pasl").value;
			var CrewEffect = document.getElementById("cre").value;
			var MaritimeDeclaration = document.getElementById("mard").value;
			
			//new field added in vessel&voyage section
			var departureManifestNumber=document.getElementById("departMainnumber").value;
			var departureManifestDate=document.getElementById("departMaindate").value;
			var submitterType=document.getElementById("submitTypet").value;
			var submitterCode=document.getElementById("submitCode").value;
			var authorizedRepresentativeCode=document.getElementById("authorizRepcode").value;
			var shippingLineBondNumber=document.getElementById("shiplineBondnumber").value;
			var modeofTransport=document.getElementById("modofTransport").value;
			var shipType=document.getElementById("shipType").value;
			var conveyanceReferenceNumber=document.getElementById("convanceRefnum").value;
			var totalNoofTransportEquipmentManifested=document.getElementById("totalnotRaneqpmin").value;
			var cargoDescription=document.getElementById("cargoDescrip").value;
			var briefCargoDescription=document.getElementById("briefCargodescon").value;
			var expectedDate=document.getElementById("expdate").value;
			var timeofDeparture=document.getElementById("timeofdep").value;
			var totalnooftransportcontractsreportedonArrivalDeparture=document.getElementById("tonotransrepoaridep").value;
			var messtype=document.getElementById("mesType").value;
			var vesType=document.getElementById("vesType").value;
			var authoseaCarcode=document.getElementById("authoseaCarcode").value;
			var portoDreg=document.getElementById("portoDreg").value;
			var regDate=document.getElementById("regDate").value;
			var voyDetails=document.getElementById("voyDetails").value;
			var shipItiseq=document.getElementById("shipItiseq").value;
			var shipItinerary=document.getElementById("shipItinerary").value;
			var portofCallname=document.getElementById("portofCallname").value;
			var arrivalDepdetails=document.getElementById("arrivalDepdetails").value;
			var totalnoTransarrivdep=document.getElementById("totalnoTransarrivdep").value;
			
			//serial no. validation
			var ArrivalDateupdate = new Date();
			var currentDate = moment(ArrivalDateupdate).format('YY');
			var serialnumber = currentDate;
			
		
			
           
			for (var i = 0; i < listOfVesselVoyageSearchDetails.length; i++) {

				if (document.getElementById(listOfVesselVoyageSearchDetails[i].id).checked == true) {
					vesselIndex=i;
					var eachVesselVoyageSearchDetailsRow = {};

					fitn = eachVesselVoyageSearchDetailsRow["From Item No"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["From Item No"]).value;
					eachVesselVoyageSearchDetailsRow["New Vessel"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["New Vessel"]).value;
					eachVesselVoyageSearchDetailsRow["New Voyage"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["New Voyage"]).value;
					eachVesselVoyageSearchDetailsRow["Port"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Port"]).value;
					eachVesselVoyageSearchDetailsRow["Road Carr code"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Road Carr code"]).value;
					eachVesselVoyageSearchDetailsRow["Service"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Service"]).value;
					eachVesselVoyageSearchDetailsRow["TP Bond No"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["TP Bond No"]).value;
					eachVesselVoyageSearchDetailsRow["Terminal"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Terminal"]).value;
					titn = eachVesselVoyageSearchDetailsRow["To Item No"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["To Item No"]).value;
					eachVesselVoyageSearchDetailsRow["Vessel"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Vessel"]).value;
					eachVesselVoyageSearchDetailsRow["Voyage"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Voyage"]).value;
					eachVesselVoyageSearchDetailsRow["Pol"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Pol"]).value;
					eachVesselVoyageSearchDetailsRow["Pol Terminal"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Pol Terminal"]).value;
					eachVesselVoyageSearchDetailsRow["Custom Terminal Code"] = document
					.getElementById(listOfVesselVoyageSearchDetails[i]["Custom Terminal Code"]).value;

					listOfVesselVoyageSearchDetailsPrepraedJson
					.push(eachVesselVoyageSearchDetailsRow);
				}
			}
			var tempItemNo=(Number(fitn));

			for (var i = 0; i < idJsonObjectForTextBox.length; i++) {
				var listOfBlDetails = {};
				var blnoforpopupdata;
				if (document.getElementById(idJsonObjectForTextBox[i].id).checked == true){
					if(document.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value!=="") {
						blnoforpopupdata=document
						.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
						listOfBlDetails["BL#"] = document
						.getElementById(idJsonObjectForTextBox[i]["BL#"]).value;
						listOfBlDetails["BL_Date"] = document
						.getElementById(idJsonObjectForTextBox[i]["BL_Date"]).value;
						listOfBlDetails["BL Status"] = document
						.getElementById(idJsonObjectForTextBox[i]["BL Status"]).value;
						listOfBlDetails["CFS-Custom Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["CFS-Custom Code"]).value;
						listOfBlDetails["Cargo Movement"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Movement"]).value;
						listOfBlDetails["Cargo Movement Type"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Movement Type"]).value;
						listOfBlDetails["Cargo Nature"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Nature"]).value;
						listOfBlDetails["Item Number"] =document
						.getElementById(idJsonObjectForTextBox[i]["Item Number"]).value;
						listOfBlDetails["Item Type"] = document
						.getElementById(idJsonObjectForTextBox[i]["Item Type"]).value;
						listOfBlDetails["Road Carr code"] = document
						.getElementById(idJsonObjectForTextBox[i]["Road Carr code"]).value;
						listOfBlDetails["TP Bond No"] = document
						.getElementById(idJsonObjectForTextBox[i]["TP Bond No"]).value;
						listOfBlDetails["Submit Date Time"] =document
						.getElementById(idJsonObjectForTextBox[i]["Submit Date Time"]).value;
						listOfBlDetails["Transport Mode"] = document
						.getElementById(idJsonObjectForTextBox[i]["Transport Mode"]).value;
						listOfBlDetails["DPD Movement"] = document
						.getElementById(idJsonObjectForTextBox[i]["DPD Movement"]).value;
						listOfBlDetails["DPD Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["DPD Code"]).value;
						listOfBlDetails["BL Version"] = document
						.getElementById(idJsonObjectForTextBox[i]["BL Version"]).value;
						listOfBlDetails["Is Present"] = document
						.getElementById(idJsonObjectForTextBox[i]["Is Present"]).value;
						listOfBlDetails["Custom ADD1"] = document
						.getElementById(idJsonObjectForTextBox[i]["Custom ADD1"]).value;
						listOfBlDetails["Custom ADD2"] = document
						.getElementById(idJsonObjectForTextBox[i]["Custom ADD2"]).value;
						listOfBlDetails["Custom ADD3"] = document
						.getElementById(idJsonObjectForTextBox[i]["Custom ADD3"]).value;
						listOfBlDetails["Custom ADD4"] = document
						.getElementById(idJsonObjectForTextBox[i]["Custom ADD4"]).value;
						listOfBlDetails["Package BL Level"] = document
						.getElementById(idJsonObjectForTextBox[i]["Package BL Level"]).value;
						listOfBlDetails["Gross Cargo Weight BL level"] = document
						.getElementById(idJsonObjectForTextBox[i]["Gross Cargo Weight BL level"]).value;
						blDetails.push(listOfBlDetails);
						
						
						//bl new
						listOfBlDetails["Consolidated Indicator"] = document
						.getElementById(idJsonObjectForTextBox[i]["Consolidated Indicator"]).value;
						listOfBlDetails["Previous Declaration"] = document
						.getElementById(idJsonObjectForTextBox[i]["Previous Declaration"]).value;
						listOfBlDetails["Consolidator PAN"] = document
						.getElementById(idJsonObjectForTextBox[i]["Consolidator PAN"]).value;
						listOfBlDetails["CIN TYPE"] = document
						.getElementById(idJsonObjectForTextBox[i]["CIN TYPE"]).value;
						listOfBlDetails["MCIN"] = document
						.getElementById(idJsonObjectForTextBox[i]["MCIN"]).value;
						listOfBlDetails["CSN Submitted Type"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Submitted Type"]).value;
						listOfBlDetails["CSN Submitted by"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Submitted by"]).value;
						listOfBlDetails["CSN Reporting Type"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Reporting Type"]).value;
						listOfBlDetails["CSN Site ID"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Site ID"]).value;
						listOfBlDetails["CSN Number"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Number"]).value;
						listOfBlDetails["CSN Date"] = document
						.getElementById(idJsonObjectForTextBox[i]["CSN Date"]).value;
						listOfBlDetails["Previous MCIN"] = document
						.getElementById(idJsonObjectForTextBox[i]["Previous MCIN"]).value;
						listOfBlDetails["Split Indicator"] = document
						.getElementById(idJsonObjectForTextBox[i]["Split Indicator"]).value;
						listOfBlDetails["Number of Packages"] = document
						.getElementById(idJsonObjectForTextBox[i]["Number of Packages"]).value;
						listOfBlDetails["Type of Package"] = document
						.getElementById(idJsonObjectForTextBox[i]["Type of Package"]).value;
						listOfBlDetails["First Port of Entry/Last Port of Departure"] = document
						.getElementById(idJsonObjectForTextBox[i]["First Port of Entry/Last Port of Departure"]).value;
						listOfBlDetails["Type Of Cargo"] = document
						.getElementById(idJsonObjectForTextBox[i]["Type Of Cargo"]).value;
						listOfBlDetails["Split Indicator List"] = document
						.getElementById(idJsonObjectForTextBox[i]["Split Indicator List"]).value;
						
						listOfBlDetails["Port of Acceptance"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Acceptance"]).value;
						listOfBlDetails["Port of Receipt"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Receipt"]).value;
						
						listOfBlDetails["UCR Typel"] = document
						.getElementById(idJsonObjectForTextBox[i]["UCR Type"]).value;
						listOfBlDetails["UCR Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["UCR Code"]).value;
						listOfBlDetails["Port of Acceptance Name"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Acceptance Name"]).value;
						listOfBlDetails["Port of Receipt Name"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Receipt Name"]).value;
						
						listOfBlDetails["PAN of notified party"] = document
						.getElementById(idJsonObjectForTextBox[i]["PAN of notified party"]).value;
						listOfBlDetails["Unit of weight"] = document
						.getElementById(idJsonObjectForTextBox[i]["Unit of weight"]).value;
						listOfBlDetails["Gross Volume"] = document
						.getElementById(idJsonObjectForTextBox[i]["Gross Volume"]).value;
						listOfBlDetails["Unit of Volume"] = document
						.getElementById(idJsonObjectForTextBox[i]["Unit of Volume"]).value;
						listOfBlDetails["Cargo Item Sequence No"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Item Sequence No"]).value;
						listOfBlDetails["Cargo Item Description"] = document
						.getElementById(idJsonObjectForTextBox[i]["Cargo Item Description"]).value;
						
						listOfBlDetails["UNO Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["UNO Code"]).value;
						listOfBlDetails["IMDG Code"] = document
						.getElementById(idJsonObjectForTextBox[i]["IMDG Code"]).value;
						
						listOfBlDetails["Number of Packages Hidden"] = document
						.getElementById(idJsonObjectForTextBox[i]["Number of Packages Hidden"]).value;
						
						listOfBlDetails["Type of Packages Hidden"] = document
						.getElementById(idJsonObjectForTextBox[i]["Type of Packages Hidden"]).value;
						listOfBlDetails["Container Weight"] = document
						.getElementById(idJsonObjectForTextBox[i]["Container Weight"]).value;
						
						
						listOfBlDetails["Port of call sequence numbe"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of call sequence number"]).value;
						listOfBlDetails["Port of Call Coded"] = document
						.getElementById(idJsonObjectForTextBox[i]["Port of Call Coded"]).value;
						listOfBlDetails["Next port of call coded"] = document
						.getElementById(idJsonObjectForTextBox[i]["Next port of call coded"]).value;
						listOfBlDetails["MC Location Customsl"] = document
						.getElementById(idJsonObjectForTextBox[i]["MC Location Customs"]).value;

						blDetails.push(listOfBlDetails);
						/*create json for consignee */

						//console.log(popupjson.popup);

						for(j=0;j<popupjson.popup[blnoforpopupdata].consignee.length;j++)
						{
							var listofconsignee={};
							listofconsignee["zip"]=popupjson.popup[blnoforpopupdata].consignee[j].zip;
							listofconsignee["blNO"]=popupjson.popup[blnoforpopupdata].consignee[j].blNO;
							listofconsignee["state"]=popupjson.popup[blnoforpopupdata].consignee[j].state;
							listofconsignee["customerName"]=popupjson.popup[blnoforpopupdata].consignee[j].customerName;
							listofconsignee["customerCode"]=popupjson.popup[blnoforpopupdata].consignee[j].customerCode;
							listofconsignee["countryCode"]=popupjson.popup[blnoforpopupdata].consignee[j].countryCode;
							listofconsignee["city"]=popupjson.popup[blnoforpopupdata].consignee[j].city;
							listofconsignee["addressLine1"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine1;
							listofconsignee["addressLine2"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine2;
							listofconsignee["addressLine3"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine3;
							listofconsignee["addressLine4"]=popupjson.popup[blnoforpopupdata].consignee[j].addressLine4;

							listOfconsigneeDetailsForSave.push(listofconsignee);
						}
						
						/* create json for consigner*/
						for(j=0;j<popupjson.popup[blnoforpopupdata].consigner.length;j++)
						{
							var listofconsigner={};
							listofconsigner["zip"]=popupjson.popup[blnoforpopupdata].consigner[j].zip;
							listofconsigner["blNO"]=popupjson.popup[blnoforpopupdata].consigner[j].blNO;
							listofconsigner["state"]=popupjson.popup[blnoforpopupdata].consigner[j].state;
							listofconsigner["customerName"]=popupjson.popup[blnoforpopupdata].consigner[j].customerName;
							listofconsigner["customerCode"]=popupjson.popup[blnoforpopupdata].consigner[j].customerCode;
							listofconsigner["countryCode"]=popupjson.popup[blnoforpopupdata].consigner[j].countryCode;
							listofconsigner["city"]=popupjson.popup[blnoforpopupdata].consigner[j].city;
							listofconsigner["addressLine1"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine1;
							listofconsigner["addressLine2"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine2;
							listofconsigner["addressLine3"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine3;
							listofconsigner["addressLine4"]=popupjson.popup[blnoforpopupdata].consigner[j].addressLine4;

							listOfconsignerDetailsForSave.push(listofconsigner);
						}
						

						/* create json for notify_party*/

						for(j=0;j<popupjson.popup[blnoforpopupdata].notifyParty.length;j++)
						{
							var listOfNotifyParty={};
							listOfNotifyParty["zip"]=popupjson.popup[blnoforpopupdata].notifyParty[j].zip;
							listOfNotifyParty["blNO"]=popupjson.popup[blnoforpopupdata].notifyParty[j].blNO;
							listOfNotifyParty["state"]=popupjson.popup[blnoforpopupdata].notifyParty[j].state;
							listOfNotifyParty["customerName"]=popupjson.popup[blnoforpopupdata].notifyParty[j].customerName;
							listOfNotifyParty["customerCode"]=popupjson.popup[blnoforpopupdata].notifyParty[j].customerCode;
							listOfNotifyParty["countryCode"]=popupjson.popup[blnoforpopupdata].notifyParty[j].countryCode;
							listOfNotifyParty["city"]=popupjson.popup[blnoforpopupdata].notifyParty[j].city;
							listOfNotifyParty["addressLine1"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine1;
							listOfNotifyParty["addressLine2"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine2;
							listOfNotifyParty["addressLine3"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine3;
							listOfNotifyParty["addressLine4"]=popupjson.popup[blnoforpopupdata].notifyParty[j].addressLine4;
							listOfNotifyPartyForSave.push(listOfNotifyParty);
						}
						//  console.log(listOfNotifyPartyForSave);

						/* create json for containerDetailes*/

						for(j=0;j<popupjson.popup[blnoforpopupdata].containerDetailes.length;j++)
						{
							var listofcontainerdetails={};
							var valueOfWeight=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerWeight;
							var valueOfPackage=popupjson.popup[blnoforpopupdata].containerDetailes[j].totalNumberOfPackagesInContainer;
							listofcontainerdetails["ISOCode"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].ISOCode;
							listofcontainerdetails["blNO"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].blNO;
							listofcontainerdetails["containerAgentCode"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerAgentCode;
							listofcontainerdetails["containerNumber"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerNumber;
							listofcontainerdetails["containerSealNumber"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].containerSealNumber;
							listofcontainerdetails["containerWeight"]=valueOfWeight;
							listofcontainerdetails["status"]=popupjson.popup[blnoforpopupdata].containerDetailes[j].status;
							listofcontainerdetails["totalNumberOfPackagesInContainer"]=valueOfPackage;
							listofcontainerdetailsForSave.push(listofcontainerdetails);
						}
						//   console.log(listofcontainerdetailsForSave);

						for(j=0;j<popupjson.popup[blnoforpopupdata].marksNumber.length;j++)
						{
							var listofmarksNumberDtls={};
							listofmarksNumberDtls["description"]=popupjson.popup[blnoforpopupdata].marksNumber[j].description;
							listofmarksNumberDtls["blNO"]=popupjson.popup[blnoforpopupdata].marksNumber[j].blNO;
							listofmarksNumberDtls["marksNumbers"]=popupjson.popup[blnoforpopupdata].marksNumber[j].marksNumbers;

							listofmarksNumberDtlsForSave.push(listofmarksNumberDtls);
						}
						// console.log(listofmarksNumberDtlsForSave);

					}
					else{
						showBarMessage(document.getElementById(idJsonObjectForTextBox[i]["BL#"]).value+" : "+" BL is Not save.");
						return false;
					}
				} 

			}
			if (fitn == "") {
				showBarMessage("From Item No. is required.");
				return false;
			} else if (titn == "") {
				showBarMessage("To Item No. is required.");
				return false;
			}
			else if (Number(fitn) > Number(titn)) {
				showBarMessage("To Item No must be greater than From Item No.");
				return false;
			}
			else if(Number((document.getElementById("totalItem").value))>((Number(titn)-Number(fitn)))+1)
			{
				showBarMessage("Enter valid range as per Selected no of BL");
				return false;
			}



			//	console.log(blDetails);
			$.ajax({
				method : "POST",
				async : true,
				url : ONFILEUPLOAD,
				beforeSend:function()
				{
					loadingfun();
				},
				data : {
					inStatus : inStatus,
					blCreationDateFrom : blCreationDateFrom,
					blCreationDateTo : blCreationDateTo,
					igmservice : igmservice,
					vessel : vessel,
					voyage : voyage,
					direction : direction,
					pol : pol,
					polTerminal : polTerminal,
					pod : pod,
					podTerminal : podTerminal,
					customCode : customCode,
					callSign : callSign,
					imoCode : imoCode,
					agentCode : agentCode,
					lineCode : lineCode,
					portOrigin : portOrigin,
					prt1 : prt1,
					prt2 : prt2,
					prt3 : prt3,
				    last1 :last1,
					last2 :last2,
					last3 : last3,
					portOfArrival : portOfArrival,
					vesselTypes : VesselTypes,
					generalDescription : generalDescription,
					nationalityOfVessel : NationalityOfVessel,
					masterName : MasterName,
					igmNo : igmNo,
					igmDate : igmDate,
					aDate : aDate,
					aTime : aTime,
					ataAd : ataAd,
					ataAt : ataAt,
					totalItem : totalItem,
					lighthouseDue : LighthouseDue,
					grossWeightVessel : GrossWeightVessel,
					netWeightVessel : NetWeightVessel,
					sameBottomCargo : SameBottomCargo,
					shipStoreDeclaration : ShipStoreDeclaration,
					crewListDeclaration : CrewListDeclaration,
					cargoDeclaration : CargoDeclaration,
					passengerList : PassengerList,
					crewEffect : CrewEffect,
					maritimeDeclaration : MaritimeDeclaration,
					
					departureManifestNumber:departureManifestNumber,
					departureManifestDate:departureManifestDate,
					submitterType:submitterType,
					submitterCode:submitterCode,
					authorizedRepresentativeCode:authorizedRepresentativeCode,
					shippingLineBondNumber:shippingLineBondNumber,
					modeofTransport:modeofTransport,
					shipType:shipType,
					conveyanceReferenceNumber:conveyanceReferenceNumber,
					totalNoofTransportEquipmentManifested:totalNoofTransportEquipmentManifested,
					cargoDescription:cargoDescription,
					briefCargoDescription:briefCargoDescription,
					expectedDate:expectedDate,
					timeofDeparture:timeofDeparture,
					totalnooftransportcontractsreportedonArrivalDeparture:totalnooftransportcontractsreportedonArrivalDeparture,
					messtype:messtype,
					vesType:vesType,
					authoseaCarcode:authoseaCarcode,
					portoDreg:portoDreg,
					regDate:regDate,
					voyDetails:voyDetails,
					shipItiseq:shipItiseq,
					shipItinerary:shipItinerary,
					portofCallname:portofCallname,
					arrivalDepdetails:arrivalDepdetails,
					totalnoTransarrivdep:totalnoTransarrivdep,
					generatFalg:generatFalg,
					
					serialNumber:serialnumber,
					
					BLDetails : JSON.stringify(blDetails),
					vesselVoyageDtls : JSON
					.stringify(listOfVesselVoyageSearchDetailsPrepraedJson),
					consigneeDtls : JSON
					.stringify(listOfconsigneeDetailsForSave),
					notifyPartyDlts:JSON
					.stringify(listOfNotifyPartyForSave),
					containerDetailsDtls:JSON
					.stringify(listofcontainerdetailsForSave),
					marksNumberDtlstls:JSON
					.stringify(listofmarksNumberDtlsForSave),
					consignerDtlstls:JSON
					.stringify(listOfconsignerDetailsForSave)
				},
				success : function(result) {
					var mgsnull=document.getElementById("msg");
					mgsnull.innerHTML = '';
					showBarMessage("Manifest File generated successfully.");
					var sampleBytes = new String(result);

					var saveByteArray = (function() {
						var a = document.createElement("a");
						document.body.appendChild(a);
						a.style = "display: none";
						
						return function(data, name) {
							if (navigator.msSaveBlob) {
								blobObject = new Blob(data);
								window.navigator.msSaveOrOpenBlob(blobObject,
								'ManifestFile.txt');

							} else {
								var blob = new Blob(data, {
									type : "octet/stream"
								}), url = window.URL.createObjectURL(blob);
								a.href = url;
								a.download = name;
								a.click();
								window.URL.revokeObjectURL(url);
							}
						};
					}());
					saveByteArray([ sampleBytes ], 'ManifestFile.txt');
				},
				error : function(e) {
					showBarMessage(error);
				}
			})
		}
	}
}









