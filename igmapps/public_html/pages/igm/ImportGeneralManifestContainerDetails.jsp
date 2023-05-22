<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@page import="com.niit.control.common.GlobalConstants"%>
<%@page import="com.niit.control.web.action.BaseAction"%>

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="javax.servlet.*,java.text.*"%>
<%@page import="com.niit.control.web.*"%>
<%@page import="com.niit.control.common.*"%>

<%
	boolean[] arrAuthFlags = BaseAction.getAuthFlags(request, "SIGM001UPLOADFILE");
	boolean blnReadFlag = arrAuthFlags[GlobalConstants.IDX_READ_FLAG];
	boolean blnDelFlag = arrAuthFlags[GlobalConstants.IDX_DEL_FLAG];
	String lstrSysDate = BaseAction.getSysDate();
	String lstrCtxPath1 = request.getContextPath();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
   <%@taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

 <html>
    <head>
        <tiles:useAttribute id='lstrScreenVersion' name='screenVersion' />
        <meta http-equiv="X-UA-Compatible" content="IE=11" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>IGM Container Details</title>
        <link rel="stylesheet" href="<%=lstrCtxPath1%>/css/NTL.css" />
		<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/RCL.css" />
		<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/EZL.css" />
		
		<SCRIPT language="javascript" type="text/javascript">
		   var PROG_ID          = 'SIGM001UPLOADFILE';
		   var FORM_ID          = 'figm001';
		</SCRIPT>
		
   <style>
   .TableLeftSub {
	height: 20px;
	text-align: center;
	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
	font-weight: normal;
	FONT-SIZE: 100%;
	COLOR: #003399; /* changed color  from #000000*/
	BACKGROUND: #E9E7D7; /* changed color for R1.2 to 72A2F6*/
	vertical-align: middle;
	PADDING-CENTER: 2px;
	BORDER-BOTTOM: #6A7896 1px solid; /* changed color and px*/
	BORDER-TOP: #6A7896 1px solid; /* changed color */
	border-spacing: 5px;
}
   .roundshapSeq{
    margin: 1px;
	width: 50px;
	height: 19px;
	margin-top: 2px;
	vertical-align: top;
	font-size: 12px;
	color: #333333;
	border: #3E71CC 1px solid;
	letter-spacing: -1px;
    }
    
  .roundshapnormal {
	margin: 1px;
	width: 130px;
	height: 19px;
	margin-top: 2px;
	vertical-align: top;
	font-size: 12px;
	color: #333333;
	border: #3E71CC 1px solid;
	letter-spacing: -1px;
                    }

   .roundshapname {
	margin: 1px;
	width: 80px;
	height: 19px;
	margin-top: 2px;
	vertical-align: top;
	font-size: 12px;
	color: #333333;
	border: #3E71CC 1px solid;
	letter-spacing: -1px;
    }

    .roundshapadress {
	margin: 1px;
	width: 100px;
	height: 19px;
	margin-top: 2px;
	vertical-align: top;
	font-size: 12px;
	color: #333333;
	border: #3E71CC 1px solid;
	letter-spacing: -1px;
    }
    
    .containerSealNo {
    
    	margin: 1px;
		width: 140px;
		height: 19px;
		margin-top: 2px;
		margin-left: 10px;
		vertical-align: top;
		font-size: 12px;
		color: #333333;
		border: #3E71CC 1px solid;
		letter-spacing: -1px;
    
    }
    .containerAgentCode {
    
    	margin: 1px;
		width: 130px;
		height: 19px;
		margin-top: 2px;
		margin-left: 10px;
		vertical-align: top;
		font-size: 12px;
		color: #333333;
		border: #3E71CC 1px solid;
		letter-spacing: -1px;
    
    }
    
    .containeStatus {
    
    	margin: 1px;
		width: 140px;
		height: 19px;
		margin-top: 2px;
		margin-left: 10px;
		vertical-align: top;
		font-size: 12px;
		color: #333333;
		border: #3E71CC 1px solid;
		letter-spacing: -1px;
    
    }
    
     .noPackages {
    
    	margin: 1px;
		width: 140px;
		height: 19px;
		margin-top: 2px;
		margin-left: 10px;
		vertical-align: top;
		font-size: 12px;
		color: #333333;
		border: #3E71CC 1px solid;
		letter-spacing: -1px;
    
    }
    
    .containerWeight {
    
    	margin: 1px;
		width: 130px;
		height: 19px;
		margin-top: 2px;
		margin-left: 10px;
		vertical-align: top;
		font-size: 12px;
		color: #333333;
		border: #3E71CC 1px solid;
		letter-spacing: -1px;
    
    }
    
    .ISOCode {
    
    	margin: 1px;
		width: 100px;
		height: 19px;
		margin-top: 2px;
		margin-left: 10px;
		vertical-align: top;
		font-size: 12px;
		color: #333333;
		border: #3E71CC 1px solid;
		letter-spacing: -1px;
    
    }
    .dropDown {
    
    	margin: 1px;
		width: 70px;
		height: 23px;
		margin-top: 2px;
		margin-left: 10px;
		vertical-align: top;
		font-size: 12px;
		color: #333333;
		border: #3E71CC 1px solid;
		letter-spacing: -1px;
    
    }
   </style>
    </head>
    <body>
        <html:errors />
        <html:form action="/sigm001uploadfile" method="post" enctype="multipart/form-data"  >
        <div id="container" style=" width: 100%;">
			 <td>
				<h2 class="text_header" style="width:99.5%"><b>Import General Manifest Container Details</b></h2>
			</td>
			<br>
	<table class="table_search" style="width: 100%;">
		<tbody class="whitebg" border="0" style="background-color: #CCCCCC;">
			<thead style="font-size: 11px;">
				<tr>
				    <td class="TableLeftSub" style="margin: 0px;padding-right: 10px;">Seq No.</td>    
					<td class="TableLeftSub" style="margin: 0px;padding-right: 60px;">Container No.</td>
					<td class="TableLeftSub" style="margin: 0px;padding-right: 45px;">Container Seal No.</td>
					<td class="TableLeftSub" style="margin: 0px;padding-right: 30px;">Container Agent Code</td>
					<td class="TableLeftSub" style="margin: 0px;padding-right: 39px;">Container Status</td>				
					<td class="TableLeftSub" style="margin: 0px;padding-right: 10px;word-spacing: -2px;">Total No. Of Packages in Container</td>
					<td class="TableLeftSub" style="margin: 0px;padding-right: 17px;">Container Weight</td>
					<td class="TableLeftSub" style="margin: 0px;padding-left: 29px;padding-right: 30px;">ISO Code</td>
					<td class="TableLeftSub" style="margin: 0px;padding-right: 10px;">Equip Load Status</td>
					<td class="TableLeftSub" style="margin: 0px;padding-right: 10px;">SOC Flagr</td>
      				<td class="TableLeftSub" style="margin: 0px;padding-right: 10px;">Equipment seal type</td>
			
				</tr>
			</thead>
		</tbody>
	</table>
</div>					
		<br>
<div id="container" style="overflow-y: scroll; height: 150px; width: 100%;">
	<table id="blTable">
		<tr id="row3">
			<td id="containerDetailsinfo"></td>
		</tr>
	</table>
</div>
	<br><br>
		<div class="buttons_box" style="width:100%">
			<input type="button" value="Weight"   name="btnWeight"   id="weightType"   class="event_btnbutton" onclick='WeightBtn()' />
		    <input type="button" value="Packages" name="btnPackages" id="packagesType" class="event_btnbutton" onclick='Packages()' />
			<input type="button" value="Default"  name="btnDefault"  id="defaultType"  class="event_btnbutton" onclick=' defaultcontainerDtl()' /> 	
			<input type="button" value="Close"    name="btnClose"    id="closeType"    class="event_btnbutton" onclick='closeBtn()' />
		</div>
        </html:form> 
     </body>   
<script language="JavaScript">


var CND= [ {
		'type' : 'text',
		'columnName' : 'Container No',
		"mappedCol" : 'containerNumber'
	},{
		'type' : 'text',
		'columnName' : 'Container Seal No',
		'mappedCol' : 'containerSealNumber'
	},{
		'type' : 'text',
		'columnName' : 'Container Agent Code',
		'mappedCol' : 'containerAgentCode'
	},{
		'type' : 'text',
		'columnName' : 'Container Status',
		'mappedCol' : 'status'
	},{
		'type' : 'text',
		'columnName' : 'Total No. Of Packages in Container',
		'mappedCol' : 'totalNumberOfPackagesInContainer'
	},{
		'type' : 'text',
		'columnName' : 'Container Weight',
		'mappedCol' : 'containerWeight'
	},{
		'type' : 'text',
		'columnName' : 'ISO Code',
		'mappedCol' : 'ISOCode'
	},{
		'type' : 'hidden',
		'columnName' : 'BLNO',
		'mappedCol' : 'blNO'
	},{																		
		'type' : 'text',
		'columnName' : 'Equipment Load Status',
		'mappedCol' : 'equipmentLoadStatus'
	},{
		'type' : 'text',
		'columnName' : 'SOC Flagr',
		'mappedCol' : 'soc_flag'
	},{																		
		'type' : 'text',
		'columnName' : 'Equipment seal type',
		'mappedCol' : 'equipment_seal_type'
	}]
	
   
	function closeBtn() {
		updateJson();
		window.close();
	}

	function defaultcontainerDtl() {
		debugger;
		var listOfcontainerDetailsInformation = window.opener.listOfcontainerDetailsInformation;
		var result1 = window.opener.result1;
	    var X = listOfcontainerDetailsInformation[0].X;
		var Y = listOfcontainerDetailsInformation[0].Y;
		var cantainerDtlpath = result1.result[X]["BLS"][Y].containerDetailes;
		for (i = 0; i < listOfcontainerDetailsInformation.length; i++) {
			document
					.getElementById(listOfcontainerDetailsInformation[i]["Container No"]).value = cantainerDtlpath[i].containerNumber;
			document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Seal No"]).value = cantainerDtlpath[i].containerSealNumber;
			document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Agent Code"]).value = cantainerDtlpath[i].containerAgentCode;
			document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Status"]).value = cantainerDtlpath[i].status;
			document
					.getElementById(listOfcontainerDetailsInformation[i]["Total No. Of Packages in Container"]).value = cantainerDtlpath[i].totalNumberOfPackagesInContainer;
			document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Weight"]).value = cantainerDtlpath[i].containerWeight;
            if(cantainerDtlpath[i].equipmentLoadStatus==""){
            	document
				.getElementById(listOfcontainerDetailsInformation[i]["Equipment Load Status"]).value ="FCL";
                }else{
                	document
					.getElementById(listOfcontainerDetailsInformation[i]["Equipment Load Status"]).value = cantainerDtlpath[i].equipmentLoadStatus;       
                    }
            if(cantainerDtlpath[i].soc_flag==""){
            	document
				.getElementById(listOfcontainerDetailsInformation[i]["SOC Flagr"]).value ="N" ;
                }else{
                	document
					.getElementById(listOfcontainerDetailsInformation[i]["SOC Flagr"]).value = cantainerDtlpath[i].soc_flag;    
                    }
            if(cantainerDtlpath[i].equipment_seal_type==""){
            	document
    			.getElementById(listOfcontainerDetailsInformation[i]["Equipment seal type"]).value="BTSL";
                }else{
                	document
        			.getElementById(listOfcontainerDetailsInformation[i]["Equipment seal type"]).value = cantainerDtlpath[i].equipment_seal_type;       
                    }
			
	        var ConSize=cantainerDtlpath[i].containerSize;
            var ConType=cantainerDtlpath[i].containerType;
            if(ConSize==""){
				var isoCode="";}
			else if(ConSize=="20"){
				var isoCode= 2000;}
			else if(ConSize="40"){
				if(ConType=="HC"){
					var isoCode= 4200;}
				}
			else{
				var isoCode=4000;}
			
			document
					.getElementById(listOfcontainerDetailsInformation[i]["ISO Code"]).value = isoCode;
		}
		updateJson();
	}
	function WeightBtn() {
		debugger;
		var listOfcontainerDetailsInformation = window.opener.listOfcontainerDetailsInformation;
		var result1 = window.opener.result1;
		var X = listOfcontainerDetailsInformation[0].X;
		var Y = listOfcontainerDetailsInformation[0].Y;
		var Grossweight = result1.result[X]["BLS"][Y].grossCargoWeightBLlevel;
		var Numberofbox = listOfcontainerDetailsInformation.length;
		var avarageWeight = (Number(Grossweight) / Number(Numberofbox));
		
		for (i = 0; i < listOfcontainerDetailsInformation.length; i++) {
			document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Weight"]).value = avarageWeight;
		}
	}

	function Packages() {
		debugger;
		var listOfcontainerDetailsInformation = window.opener.listOfcontainerDetailsInformation;
		var result1 = window.opener.result1;
		var X = listOfcontainerDetailsInformation[0].X;
		var Y = listOfcontainerDetailsInformation[0].Y;
		var reminderVlaue = 0;
		var lastValue = 0;
		var packageBL = result1.result[X]["BLS"][Y].packageBLLevel;
		var Numberofbox = listOfcontainerDetailsInformation.length;
		var avarageValue = packageBL / Numberofbox;
		var getValue = getIntValue(avarageValue);
		if ((packageBL - ((Number(getValue)) * (Number(Numberofbox)))) != 0) {
			reminderVlaue = (packageBL - ((Number(getValue)) * (Number(Numberofbox))));
			lastValue = Number(getValue) + reminderVlaue;
		} else {
			lastValue = getValue;
		}
		for (i = 0; i < listOfcontainerDetailsInformation.length; i++) {
			if (i == (listOfcontainerDetailsInformation.length - 1)) {
				document
						.getElementById(listOfcontainerDetailsInformation[i]["Total No. Of Packages in Container"]).value = lastValue;
			} else {
				document
						.getElementById(listOfcontainerDetailsInformation[i]["Total No. Of Packages in Container"]).value = getValue;
			}
		}
	}

	window.onbeforeunload = confirmExit;
	function confirmExit() {
		updateJson();
	}

	function updateJson() {
		debugger;
		var listOfcontainerDetailsInformation = window.opener.listOfcontainerDetailsInformation;

		for (i = 0; i < listOfcontainerDetailsInformation.length; i++)

		{
			var blno = document
					.getElementById(listOfcontainerDetailsInformation[i]["BLNO"]).value;

			window.opener.popupjson.popup[blno].containerDetailes[i]["containerNumber"] = document
					.getElementById(listOfcontainerDetailsInformation[i]["Container No"]).value;
			window.opener.popupjson.popup[blno].containerDetailes[i]["containerSealNumber"] = document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Seal No"]).value;
			window.opener.popupjson.popup[blno].containerDetailes[i]["containerAgentCode"] = document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Agent Code"]).value;
			window.opener.popupjson.popup[blno].containerDetailes[i]["status"] = document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Status"]).value;
			window.opener.popupjson.popup[blno].containerDetailes[i]["totalNumberOfPackagesInContainer"] = document
					.getElementById(listOfcontainerDetailsInformation[i]["Total No. Of Packages in Container"]).value;
			window.opener.popupjson.popup[blno].containerDetailes[i]["containerWeight"] = document
					.getElementById(listOfcontainerDetailsInformation[i]["Container Weight"]).value;
			window.opener.popupjson.popup[blno].containerDetailes[i]["equipmentLoadStatus"] = document
					.getElementById(listOfcontainerDetailsInformation[i]["Equipment Load Status"]).value;
			window.opener.popupjson.popup[blno].containerDetailes[i]["soc_flag"] = document
			.getElementById(listOfcontainerDetailsInformation[i]["SOC Flagr"]).value;
			window.opener.popupjson.popup[blno].containerDetailes[i]["equipment_seal_type"] = document
			.getElementById(listOfcontainerDetailsInformation[i]["Equipment seal type"]).value;
			var isoValueIn= document
			.getElementById(listOfcontainerDetailsInformation[i]["ISO Code"]).value;
			if(isoValueIn=="2000")
				{
				window.opener.popupjson.popup[blno].containerDetailes[i]["ContainerSize"] ="20";
				window.opener.popupjson.popup[blno].containerDetailes[i]["ContainerType"] ="GP";
				}
			else if(isoValueIn=="4200")
				{
				window.opener.popupjson.popup[blno].containerDetailes[i]["ContainerSize"] ="40";
				window.opener.popupjson.popup[blno].containerDetailes[i]["ContainerType"] ="HC";
				}
			else if(isoValueIn=="")
				{
				window.opener.popupjson.popup[blno].containerDetailes[i]["ContainerType"] ="";
			    window.opener.popupjson.popup[blno].containerDetailes[i]["ContainerType"] ="";
				}
		}	

	}

	function getIntValue(value) {
		var num = value;
		var str = num.toString();
		var numarray = str.split('.');
		var a = new Array();
		a = numarray;
		if (a.length > 1) {
			return a[0];
		} else {
			return value;
		}
	}
</script>     
     
</html>     