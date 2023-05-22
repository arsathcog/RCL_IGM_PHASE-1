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
        <title>IGM Notify Party</title>
        <link href="<%=lstrCtxPath1%>/3rdjs/jquery-ui.css" rel="stylesheet">
<script src="<%=lstrCtxPath1%>/3rdjs/external/jquery/jquery.js"></script>
<script src="<%=lstrCtxPath1%>/3rdjs/jquery-ui.js"></script>
<script src="<%=lstrCtxPath1%>/3rdjs/moment.js"></script>
<link
	href="<%=lstrCtxPath1%>/3rdjs/jquery-timepicker-master/jquery.timepicker.min.css"
	rel="stylesheet">
<script
	src="<%=lstrCtxPath1%>/3rdjs/jquery-timepicker-master/jquery.timepicker.min.js"></script>
	
        <link rel="stylesheet" href="<%=lstrCtxPath1%>/css/NTL.css" />
		<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/RCL.css" />
		<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/EZL.css" />
		
		<SCRIPT language="javascript" type="text/javascript">
		   var PROG_ID          = 'SIGM001UPLOADFILE';
		   var FORM_ID          = 'figm001';
		</SCRIPT>
		
	    <style>
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
	width: 600px;
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
	width: 600px;
	height: 19px;
	margin-top: 2px;
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
				<h2 class="text_header" style="width:99.5%"><b>Import General Manifest Notify Party</b></h2>
			</td>
			<br>
		<table class="table_search" border="0" cellspacing="0"
							cellpadding="0" style="FONT-SIZE: 15px;">
							<tr>
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal; background: #efefeb;">Notify Code
									<span  id="NotifyCode"></span></td>
								
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal; background: #efefeb;">Notify Name
									<span  id="NotifyName"></span></td>
								
							</tr>
		</table>					
		<table class="table_search" border="0" cellspacing="0"
							cellpadding="0" style="FONT-SIZE: 15px;">
							<tr>
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal; background: #efefeb;">Notify Address 1
									<span id="NotifyAdress1"></span></td>
								
							</tr>
							<tr>
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal; background: #efefeb;">Notify Address 2
									<span  id="NotifyAdress2"></span></td>
								
							</tr>
							<tr>
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal; background: #efefeb;">Notify Address 3
									<span  id="NotifyAdress3"></span></td>
								
							</tr>
							<tr>	
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal; background: #efefeb;">Notify Address 4
									<span  id="NotifyAdress4"></span></td>
								
							</tr>
							

							
                               
		</table>
		<table class="table_search" border="0" cellspacing="0"
							cellpadding="0" style="FONT-SIZE: 15px;">
							<tr>
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal;  background: #efefeb;">City
									<span id="NotifyCity"></span></td>
								
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal;  background: #efefeb;">State
							    <span  id="NotifyState"></span></td>
								
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal;  background: #efefeb;">Country
							    <span id="NotifyCountry"></span></td>
								
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 14px;line-height:2; font-weight: normal;  background: #efefeb;">Zip
								<span  id="NotifyZip"></span></td>
								
								<td class="whitebg" id="NotifyBlNo"></td>
							</tr>
		</table>	
						<br>
	
	<div class="buttons_box" style="width:100%">
			<input type="button" value="Close" name="btnClose"
			id="closeType" class="event_btnbutton" onclick='closeBtn()' />
		</div>
        </html:form>
     </body>   
<script>
    

	var NTP = [ {
		'type' : 'text',
		'columnName' : 'Notify Code',
		"mappedCol" : 'customerCode'
	}, {
		'type' : 'text',
		'columnName' : 'Notify Name',
		'mappedCol' : 'customerName'
	}, {
		'type' : 'text',
		'columnName' : 'Notify Address1',
		'mappedCol' : 'addressLine1'
	}, {
		'type' : 'text',
		'columnName' : 'Notify Address2',
		'mappedCol' : 'addressLine2'
	}, {
		'type' : 'text',
		'columnName' : 'Notify Address3',
		'mappedCol' : 'addressLine3'
	}, {
		'type' : 'text',
		'columnName' : 'Notify Address4',
		'mappedCol' : 'addressLine4'
	}, {
		'type' : 'text',
		'columnName' : 'City',
		'mappedCol' : 'city'
	}, {
		'type' : 'text',
		'columnName' : 'State',
		'mappedCol' : 'state'
	}, {
		'type' : 'text',
		'columnName' : 'Country',
		'mappedCol' : 'countryCode'
	}, {
		'type' : 'text',
		'columnName' : 'Zip',
		'mappedCol' : 'zip'
	}, {
		'type' : 'hidden',
		'columnName' : 'BLNO',
		'mappedCol' : 'blNO'
	} ]

	function closeBtn() {
		updateJson();
		window.close();
	}
	window.onbeforeunload = confirmExit;
    function confirmExit() {
    	updateJson();
	}
	function updateJson() {
		var listOfnotifyInformation = window.opener.listOfnotifyInformation;

		for (i = 0; i < listOfnotifyInformation.length; i++)

		{
			var blno = document
					.getElementById(listOfnotifyInformation[i]["BLNO"]).value;

			window.opener.popupjson.popup[blno].notifyParty[i]["customerCode"] = document
					.getElementById(listOfnotifyInformation[i]["Notify Code"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["customerName"] = document
					.getElementById(listOfnotifyInformation[i]["Notify Name"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["addressLine1"] = document
					.getElementById(listOfnotifyInformation[i]["Notify Address1"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["addressLine2"] = document
			.getElementById(listOfnotifyInformation[i]["Notify Address2"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["addressLine3"] = document
			.getElementById(listOfnotifyInformation[i]["Notify Address3"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["addressLine4"] = document
			.getElementById(listOfnotifyInformation[i]["Notify Address4"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["city"] = document
					.getElementById(listOfnotifyInformation[i]["City"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["state"] = document
					.getElementById(listOfnotifyInformation[i]["State"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["countryCode"] = document
					.getElementById(listOfnotifyInformation[i]["Country"]).value;
			window.opener.popupjson.popup[blno].notifyParty[i]["zip"] = document
					.getElementById(listOfnotifyInformation[i]["Zip"]).value;
		}

	} 
</script>     
</html>     