
<%@taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@page import="com.niit.control.common.GlobalConstants"%>
<%@page import="com.niit.control.web.action.BaseAction"%>
<%@ page import="com.niit.control.web.UserAccountBean"%>
<%@page import="com.niit.control.common.StringUtil"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="javax.servlet.*,java.text.*"%>
<%@page import="com.niit.control.web.*"%>
<%@page import="com.niit.control.common.*"%>

<%
	boolean[] arrAuthFlags = BaseAction.getAuthFlags(request, "SIGM001");
	boolean blnReadFlag = arrAuthFlags[GlobalConstants.IDX_READ_FLAG];
	boolean blnDelFlag = arrAuthFlags[GlobalConstants.IDX_DEL_FLAG];
	String lstrSysDate = BaseAction.getSysDate();
	String lstrCtxPath1 = request.getContextPath();
%>



<!DOCTYPE html>
<html>
<head>
<tiles:useAttribute id='lstrScreenVersion' name='screenVersion' />
<meta http-equiv="X-UA-Compatible" content="IE=11" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>IGM</title>



<!-- date picker -->

<link href="<%=lstrCtxPath1%>/3rdjs/jquery-ui.css" rel="stylesheet">
<script src="<%=lstrCtxPath1%>/3rdjs/external/jquery/jquery.js"></script>
<script src="<%=lstrCtxPath1%>/3rdjs/jquery-ui.js"></script>
<script src="<%=lstrCtxPath1%>/3rdjs/moment.js"></script>
<link
	href="<%=lstrCtxPath1%>/3rdjs/jquery-timepicker-master/jquery.timepicker.min.css"
	rel="stylesheet">
<script
	src="<%=lstrCtxPath1%>/3rdjs/jquery-timepicker-master/jquery.timepicker.min.js"></script>

<!-- css  -->

<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/NTL.css" />
<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/RCL.css" />
<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/EZL.css" />
<style type="text/css">
.buttons_box1 {
    height: 20px;
    text-align: right;
    border-bottom: 1px solid #6A7896;
    background-color: #E9E7D7;
    margin: 1px 1px;
    padding-top: 1px;
    clear: both;
}

.scoll-pane {
    width: 100%;
    height: auto;
    overflow: auto;
    outline: none;
    overflow-y: hidden;
    padding-bottom: 15px;
    -ms-overflow-style: scroll;  // IE 10+
    scrollbar-width: none;  // Firefox
}
  .scoll-pane::-webkit-scrollbar { 
  display: none;  // Safari and Chrome
  }
a {
	text-decoration: underline;
}

.bg_textbox2 {
	background-color: yellow;
}
.refreshcolor{
background-color: pink;
}
.validateBL{
background-color: #ADFF2F ;
}

.TableLeftSub {
	height: 20px;
	text-align: left;
	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
	font-weight: normal;
	FONT-SIZE: 100%;
	COLOR: #003399; /* changed color  from #000000*/
	BACKGROUND: #E9E7D7; /* changed color for R1.2 to 72A2F6*/
	vertical-align: middle;
	PADDING-LEFT: 2px;
	BORDER-BOTTOM: #6A7896 1px solid; /* changed color and px*/
	BORDER-TOP: #6A7896 1px solid; /* changed color */
	border-spacing: 5px;
}

.TableCenterSub {
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

input, select, .must {
	font-family: verdana, arial, helvetica, sans-serif;
	border: 1px solid #3E71CC;
	height: 15px;
	width: 100px;
	font-size: 10px;
	font-family: verdana, arial, helvetica, sans-serif;
	padding: 1px;
	margin: 0;
	required
}

body {
	margin: 1px;
	font-family: verdana, arial, helvetica, sans-serif;
	font-size: 15px;
	font-weight: normal;
	background: #efefeb;
}

table {
	border-spacing: 1;
}

.whitebg {
	background: #efefeb !important;
	font-weight: normal;
	color: #003399;
}

table.table_search tr td {
	color: #0000ff;
	padding: 0px 0px 2px 2px;
	border-top: 1px solid #efefeb;
}

table.table_search tr td.whitebg {
	background: #fff;
}

div.search_result {
	height: 190px;
}

table.table_results tbody {
	height: 190px;
}

.roundshap1 {
	margin: 1px;
	width: 80px;
	height: 15px;
	border-color: blue;
}

.roundshap2 {
	margin: 1px;
	width: 100px;
	height: 15px;
	border-color: blue;
}


.roundshap3 {
	margin: 1px;
	width: 100px;
	height: 19px;
	border-color: blue;
}

.
roundshap4 {
	margin: 1px;
	width: 100px;
	height: 15px;
	border-color: blue;
}
.seqCss {
	margin: 1px;
	width: 50px;
	height: 15px;
	border-color: blue;
}
.smallDPCss {
	margin: 1px;
	width: 60px;
	height: 19px;
	border-color: blue;
}

.smallInputBox {
	margin: 1px;
	width: 60px;
	height: 15px;
	border-color: blue;
}


.roundshap5 {
	margin: 1px;
	width: 100px;
	height: 19px;
	margin-top: 2px;
	vertical-align: top;
	font-size: 12px;
	color: #333333;
	border: #3E71CC 1px solid;
	letter-spacing: -1px;
	background: #fed url(<%=lstrCtxPath1%>/images/input_bg.gif) top left
		repeat-x;

}
.roundshap6 {
	margin: 1px;
	width: 80px;
	height: 19px;
	border-color: blue;
	}
.loading
{
    text-align: left;
	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
	font-weight: normal;
	FONT-SIZE: 100%;
	COLOR: #003399; /* changed color  from #000000*/
  
}

@keyframes blink {
    
    0% {
      opacity: .2;
    }
    
    20% {
       opacity: 1;
    }
    
    100% {
      opacity: .2;
    }
}
#loading span {
    
    animation-name: blink;
    animation-duration: 1.4s;
    animation-iteration-count: infinite;
    animation-fill-mode: both;
}

#loading span:nth-child(2) {
    animation-delay: .2s;
}

#loading span:nth-child(3) {
    animation-delay: .4s;
}
.roundshapnormal {
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
    .footer {
	position: fixed;
	left: 0;
	bottom: 0;
	width: 100%;
	color: white;
	text-align: center;
	style="font-family: Verdana;
	font-size: 10pt
	valign=middle;
	align=left;
	background-color: #D4D0C8;
    color: white;
    text-align: center;
}
.roundshapError {
	margin: 1px;
	width: 70px;
	height: 19px;
	margin-top: 2px;
	vertical-align: top;
	font-size: 12px;
	color: black;
	border: red 1px solid;
	letter-spacing: -1px;
	background-image: linear-gradient(red, white);
		}

</style>
<script language="JavaScript" src="<%=lstrCtxPath1%>/js/validate.js"></script>
<script language="JavaScript"
	src="<%=lstrCtxPath1%>/js/RutMessageBar.js"></script>
<SCRIPT language="javascript" type="text/javascript">
       var PROG_ID          = 'SIGM001';
       var FORM_ID          = 'figm001';

           var ONLOADCONE         = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/sigm001", pageContext)%>';
    	   var ONFIND        	  = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/sigm001search", pageContext)%>';
    	   var ONREFRESH          = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/sigm001refresh", pageContext)%>';
    	   var ONSAVE             = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/sigm001save", pageContext)%>' ;
    	   var ONSAVEFILE         = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/sigm001savefile", pageContext)%>';
    	   var ONEXCEL            = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/sigm001excelfile", pageContext)%>';
    	   var ONFILEUPLOAD       =	'<%=com.niit.control.web.JSPUtils.getActionMappingURL("/sigm001edifilegenerate", pageContext)%>';
    	   var ctxPath1           = '<%=lstrCtxPath1%>';
    	   var USERID             = '<%=BaseAction.getUserID(request)%>';
    	   
            <%String strUserFsc = null;
			String userName = null;
			String userId = null;
			UserAccountBean account = (UserAccountBean) session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
			strUserFsc = account.getUserFsc();
			userName = account.getUserName();
			userId = account.getUserId();%>
			
	      var autoCloseTimer;
	      var timeoutObject;

	function promptForClose() {
		alert("Session timeout.")
		autoCloseTimer = setTimeout("definitelyClose()", 1000);
	}
	function resetTimeout() {
		clearTimeout(timeoutObject);
		timeoutObject = setTimeout("promptForClose()", 1000 * 60 * 10);
	}

	function definitelyClose() {
		top.opener = self;
		top.window.close();
		top.popupWindow.window.close();
	}
</SCRIPT>
<script language="JavaScript"
	src="<%=lstrCtxPath1%>/js/ImportGeneralManifest.js"></script>
</head>

<BODY topmargin="0" leftmargin="0">
	<%-- <form  method="POST" action="<%=lstrCtxPath1%>/do/sigm001"> --%>
	<div id="container" style="width: 100%;">
		<TABLE border="0" width="100%" cellspacing="0" cellpadding="0">
			<TR>
				<TD>
					<div class="page_title">
						<table border="0" width="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td class="PageTitle">Import General Manifest(IGM)</td>
								<td class="PageTitleRight">
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td valign="middle" align="right"><font size="1"
												face="Verdana" color="#FFFFFF"></font></td>
											<td valign="middle" align="right"><font size="1"
												face="Verdana" color="#FFFFFF"> <%=userName%>(<%=userId%>)-<%=strUserFsc%>&nbsp;&nbsp;-&nbsp;R/*/***&nbsp;<%
 	Date dNow = new Date();
 	SimpleDateFormat ft = new SimpleDateFormat(" dd/MM/yyyy ");
 	out.print(ft.format(dNow));
 %>
											</font></td>
											<td valign="middle" align="left"><img border="0"
												src="<%=lstrCtxPath1%>/images/imgDivider.gif" height="20"></td>
											<td width="50" valign="middle" align="center"><a href=""><img
													border="0" alt="Help" onClick="openHelp()"
													src="<%=lstrCtxPath1%>/images/btnHelp.jpg" width="40"
													height="16"></a></td>
											<td width="6" valign="middle" align="center"><img
												border="0" src="<%=lstrCtxPath1%>/images/imgDivider.gif"
												width="12" height="20"></td>
											<td width="2%"><a href=""><img border="0"
													src="<%=lstrCtxPath1%>/images/btnClose.gif" alt="Close"
													onClick="closeWindow()" width="16" height="16"></a></td>

										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>

					<div class="page_info">

						<span
							style="font-family: verdana, arial, helvetica, sans-serif; font-size: 10px; font-weight: normal; background: #efefeb;"><%=lstrScreenVersion%>&nbsp;&nbsp;</span>

					</div>

					

						<div class="text_header">
							<h2>Import General Manifest Search</h2>
						</div>
						<br>

						<table class="table_search" border="0" cellspacing="0"
							cellpadding="0" style="FONT-SIZE: 15px;">
							<tr>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">Service</td>
								<td class="whitebg"><input type="text" name="figm001"
									id="igmservice" value="" style="width: 75%"
									onblur="changeUpper(this)"> <input type="button"
									value=". . ." name="igmservicefield" class="btnbutton"
									onclick='' /></td>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">Vessel</td>
								<td class="whitebg"><input type="text" name="figm001"
									id="vessel" value="" style="width: 75%" class="must"
									onblur="changeUpper(this)"> <input type="button"
									value=". . ." name="igmvesselfield" class="btnbutton"
									onclick='' /></td>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">Voyage</td>
								<td class="whitebg"><input type="text" name="figm001"
									id="voyage" value="" style="width: 75%" class="must"
									onblur="changeUpper(this)"> <input type="button"
									value=". . ." name="igmvoyagefield" class="btnbutton"
									onclick='' /></td>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">POD</td>
								<td class="whitebg"><input type="text" name="figm001"
									id="pod" value="" style="width: 75%" class="must"
									onblur="changeUpper(this)"> <input type="button"
									value=". . ." name="igmpodfield" class="btnbutton" onclick='' /></td>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">DEL</td>
								<td class="whitebg"><input type="text" name="figm001"
									id="del" value="" style="width: 75%" onblur="changeUpper(this)">
									<input type="button" value=". . ." name="igmdelfield"
									class="btnbutton" onclick='' /></td>
							</tr>

							<tr>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">POL</td>
								<td class="whitebg"><input type="text" name="figm001"
									id="pol" value="" style="width: 75%" onblur="changeUpper(this)">
									<input type="button" value=". . ." name="igmpolfield"
									class="btnbutton" onclick='' /></td>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">POL
									Terminal</td>

								<td class="whitebg"><input type="text" name="figm001"
									id="polTerminal" value="" style="width: 75%"
									onblur="changeUpper(this)"> <input type="button"
									value=". . ." name="igmpolterminalfield" class="btnbutton"
									onclick='' /></td>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">POD
									Terminal</td>
								<td class="whitebg"><input type="text" name="figm001"
									id="podTerminal" value="" style="width: 75%"
									onblur="changeUpper(this)"> <input type="button"
									value=". . ." name="igmpodterminalfield" class="btnbutton"
									onclick='' /></td>
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">Direction</td>
								<td class="whitebg"><select name="figm001" id="direction"
									style="height: 20px; width: 95%;">
										<option value="10">ALL</option>
								</select></td>
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">DEPOT</td>
								<td class="whitebg"><input type="text" name="figm001"
									id="depo" value="" style="width: 75%"
									onblur="changeUpper(this)"> <input type="button"
									value=". . ." name="igmdepofield" class="btnbutton" onclick='' /></td>

							</tr>

							<tr>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal;  background: #efefeb;">BL
									Creation Date From</td>
								<td class="whitebg"><input type="text" name="figm001" readonly="readonly"
									id="blCreationDateFrom" maxlength="10" value="20190120"
									style="width: 70%"> <a href="#"></a> <img
									src="<%=lstrCtxPath1%>/images/btnCalendar.gif"
									onClick="dateFrom()" alt="Calender" class="calender"></td>
								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal;  background: #efefeb;">BL
									Creation Date To</td>

								<td class="whitebg"><input type="text" name="figm001" readonly="readonly"
									id="blCreationDateTo" maxlength="10" value="20190123"
									style="width: 70%" >
									<a href="#"><img
										src="<%=lstrCtxPath1%>/images/btnCalendar.gif" alt="Calender"
										class="calender" onClick="dateTo()"></a></td>

								<td
									style="font-family: verdana, arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; background: #efefeb;">BL
									Status</td>
								<td class="whitebg"><select name="figm001" id="inStatus"
									style="height: 20px; width: 95%">
										<option value="" selected>ALL</option>
										<option value="1">Entry</option>
										<option value="2">Confirmed</option>
										<option value="3">Printed</option>
										<option value="4">Manifested</option>
										<option value="5">Invoiced</option>
										<option value="6">WAIT LISTED</option>

								</select></td>
							</tr>

						</table>
						<br>

						<div class="buttons_box">
							
							    <input type="button" value="Refresh" id="refreshButton" disabled='true' 
							    name="btnRefresh" class="event_btnbutton" onclick='refreshBtn()' /> 
							    <input type="button" value="Merge Files" name="btnCreateBayPlan" id="btnCreateBayPlan"
								class="event_btnbutton" onclick='mergeFiles()' />
								<input type="button" value="  SEI  " id="seiButton" 
								 name="btnsei"	class="event_btnbutton" onclick='onseiBtn()' />
								<input type="button" value="  SAM  " name="generatemanifest"
								class="event_btnbutton" disabled='true' id="generatetype"
								onclick='return onsamBtn()' />
								<input type="button" value=" Generate Manifest " name="manifestfilegeneratoredifile"
								class="event_btnbutton" disabled='true' id="manifestfilegeneratoredifile"
								onclick='return manifestFileGeneratorEdiFile()' /> 
								<input type="button" value="Find" name="figm001" id="onfindData"
								class="event_btnbutton" onclick='return findData()' /> 
								<input type="button" value="Reset" name="btnReset" id="onResetData"
								class="event_btnbutton" onclick='onResetForm()' />
								<input type="button" value="Submit" name="Submit" id="submitype"
								class="event_btnbutton" disabled='true'
								onclick='return submitData()' />

						</div>
				</TD>
			</TR>
		</TABLE>
	</div>

	
<div id="vessel&voyage1st" style="display: none">
		<div class="text_header">
			<h2>Vessel/Voyage Search Details</h2>
			<h2 style="margin-left:39%;font-size: 09px;">Acknowledgment File</h2>
						<table style="margin-left:78%">
							<tr>
								<td><input class="event_btnbutton"  style="margin-top:-17px;"  type="file" 
									name="figm001" id="acknowledgmentFileUpload" size="50px"/></td>
								<td ><input class="event_btnbutton" style="width: 80px;margin-top: -15px;"
									type="button" name="figm001" id="btnacknowledgmentFileUpload" value="Upload"
									onclick="onUploadAcknowledgment()" /></td>
							</tr>
						</table>
		</div>
		<div class="table">
			<table class="whitebg" border="0" style="background-color: #CCCCCC">
				<thead style="font-size: 10px;">
					<tr>
						<th class="TableCenterSub" style="width: 90px; height: 30px;border:1px solid gray;">Option</th>
						<th class="TableCenterSub" style="width: 90px; height: 30px;border:1px solid gray;">Sequence</th>
						<th class="TableCenterSub" style="width: 80px; height: 30px;border:1px solid gray;">Service</th>
						<th class="TableCenterSub" style="width: 80px; height: 30px;border:1px solid gray;">Vessel</th>
						<th class="TableCenterSub" style="width: 80px; height: 30px;border:1px solid gray;">Voyage</th>
						<th class="TableCenterSub" style="width: 85px; height: 30px;border:1px solid gray;">Port</th>
						<th class="TableCenterSub" style="width: 80px; height: 30px;border:1px solid gray;">Terminal</th>
						<th class="TableCenterSub" style="width: 85px; height: 30px;border:1px solid gray;">Custom
							Terminal Code</th>
						<th class="TableCenterSub" style="width: 80px; height: 30px;border:1px solid gray;">From
							Item No</th>
						<th class="TableCenterSub" style="width: 85px; height: 30px;border:1px solid gray;">To
							Item No</th>
						<th class="TableCenterSub" style="width: 80px; height: 30px;border:1px solid gray;">New
							Voyage</th>
						<th class="TableCenterSub" style="width: 80px; height: 30px;border:1px solid gray;">New
							Vessel</th>
						<th class="TableCenterSub" style="width: 80px; height: 30px;border:1px solid gray;">Road
							Carr. Code</th>
						<th class="TableCenterSub" style="width: 75px; height: 30px;border:1px solid gray;">TP
							Bond No</th>
						<th class="TableCenterSub" style="width: 85px; height: 30px;border:1px solid gray;">CFS
							Custom Code</th>
					</tr>
				</thead>
			</table>
		</div>
		<br>
		<div id="container" style="overflow-y: scroll; height: 40px;">
			<table>
				<tr id="row3">
					<td id="fooBar"></td>
				</tr>
			</table>
		</div>
</div>
	
	
	<div id="vessel&voyage2nd" style="display: none">
		<div id="container">
			<div class="Table">
				<table class="whitebg" border="0" style="background-color: #CCCCCC;overflow-x: scroll;" id="row1">
					<thead style="font-size: 10px;">
						<tr>
							<th class="TableCenterSub" style="border:1px solid gray; ">Custom Port Code</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Call Sign</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">IMO Code</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Agent Code</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Line Code</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Port Origin</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">-3</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">-2</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">-1</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">1</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">2</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">3</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Port Of Arrival</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Vessel Type</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">General Description</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Nationality Of Vessel</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Master Name</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">IGM Number</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">IGM Date</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Arrival Date</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Arrival Time</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">DEL Arrival Date</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">DEL Arrival Time</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Total Items</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Lighthouse Due</th>
							<th class="TableCenterSub" style="border:1px solid gray; ">Gross Weight Vessel</th>
							
						</tr>
					</thead>

					<tr>

						<th><input type="text" name="figm001" id="customCode"
							value="" onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="callSign" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="imoCode" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="agentCode" value=""
							onblur="changeUpper(this)" readonly="readonly"></th>
						<th><input type="text" name="figm001" id="lineCode" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="portOrigin"
							value="" onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="prt1" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="prt2" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="prt3" value=""
							onblur="changeUpper(this)"></th>
<!-- insert next port -->
						<th><input type="text" name="figm001" id="nprt1" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="nprt2" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="nprt3" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="portOfArrival"
							value="" onblur="changeUpper(this)"></th>
						<th><select name="figm001" id="cont" style="height: 19px;">
								<option value="C" selected>Containerised</option>
							</select></th>
						<th><input type="text" name="figm001" id="generalDescription"
							value="Containers" onblur="changeUpper(this)" readonly="readonly"></th>

						<th><input type="text" name="figm001" id="nov" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="mn" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="igmNo" value=""
							onblur="changeUpper(this)" max = "7"
							onkeydown="systemGenerateDateForIgmDate(this)"></th>
						<th><input type="text" name="figm001" id="igmDate" value=""
							onblur="changeUpper(this)" readonly="readonly"></th>
						<th><input type="text" name="figm001" id="aDate" value=""
							onblur="changeUpper(this)" readonly="readonly"></th>
						<th><input type="text" name="figm001" id="aTime" value=""
							onblur="changeUpper(this)" readonly="readonly"></th>
						<th><input type="text" name="figm001" id="ataAd" value=""
							onblur="changeUpper(this)" readonly="readonly"></th>
						<th><input type="text" name="figm001" id="ataAt" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="totalItem" value=""
							onblur="changeUpper(this)" readonly="readonly"></th>
						<th><input type="text" name="figm001" id="lhd" value=""
							onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="gwv" value=""
							onblur="changeUpper(this)"></th>
						</tr>
						<thead style="font-size: 10px;">
						<tr>
						
						<th class="TableCenterSub" style="border:1px solid gray; ">Net Weight Vessel</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Same Bottom Cargo</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Ship Store Declaration</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Crew List Declaration</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Cargo Declaration</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Passenger List</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Crew Effect</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Maritime Declaration</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Dep. Manif No.</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Dep. Manifest Date</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Submitter Type </th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Submitter Code</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Authoriz Rep. Code</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Shipping Line Bond No.</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Mode of Transport </th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Ship Type</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Conveyance J No.</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Tol. No. of Trans. Equ. Manif</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Cargo Description</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Brief Cargo Des.</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Expected Date </th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Time of Dept.</th>
						<th class="TableCenterSub" style="border:1px solid gray; ">Total no.of tran.s cont. repo on Ari/Dep</th>
					</tr>
					
				</thead>	
<!--OLD CODE -->	<tr>
						<th><input type="text" name="figm001" id="nwv" value=""
							onblur="(this)"></th>
						<th><select name="figm001" id="smbc" style="height: 19px;">
								<option value="Y">Y</option>
								<option value="N" selected>N</option>
						</select></th>
						
						<th><select name="figm001" id="shsd" style="height: 19px;">
								<option value="Y">Y</option>
								<option value="N" selected>N</option>
						</select></th>
						<th><input type="text" name="figm001" id="crld" culumnName="Crew List Declaration"
						 value="" maxlength="4"
							onchange="checkNumeric(this)"></th>
						<th><select name="figm001" id="card" style="height: 19px;">
								<option value="Y">Y</option>
								<option value="N" selected>N</option>
						</select></th>
						<th><select name="figm001" id="pasl" style="height: 19px;">
								<option value="Y">Y</option>
								<option value="N" selected>N</option>
						</select></th>
						<th><select name="figm001" id="cre" style="height: 19px;">
								<option value="Y">Y</option>
								<option value="N" selected>N</option>
						</select></th>
						<th><select name="figm001" id="mard" style="height: 19px;">
								<option value="Y">Y</option>
								<option value="N" selected>N</option>
						</select></th>
					
				<!-- New field 12/1119 kamalakanta-->
				
						<th><input type="text" name="figm001" id="departMainnumber"  value="" size="7" maxlength="7" onchange="checkNumeric(this)"></th>
						<th><input type="text" name="figm001" id="departMaindate"  value=""  onclick="dateForDepartMaindate(this)"></th>
						<th><select name="figm001" id="submitTypet" style="height: 19px;"> 
						<option value="asa" selected>ASA</option>
						<option value="ato" >ATO</option>
						<option value="asc" >ASC</option>
						<option value="anc" >ANC</option>
						</select></th>
						<th><input type="text" name="figm001" id="submitCode" value="" size="15" maxlength="15" onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="authorizRepcode" value="" size="10" maxlength="10"  onblur="changeUpper(this)"></th> 
						<th><input type="text" name="figm001" id="shiplineBondnumber" value="" size="10" maxlength="10" onblur="changeUpper(this)"></th>
						<th><select name="figm001" id="modofTransport" style="height: 19px;"> 
						<option value="1" selected>Sea</option>
						<option value="2" >Rail </option>
						<option value="3" >Truck</option>
						<option value="4" >Air</option>  
						</select></th>
						<th><input type="text" name="figm001" id="shipType" value=""  size="3" maxlength="3" onblur="changeUpper(this)"></th>  
						<th><input type="text" name="figm001" id="convanceRefnum" value="" size="35" maxlength="35"onblur="changeUpper(this)"></th>  
						<th><input type="text" name="figm001" id="totalnotRaneqpmin" value="" size="5" maxlength="5"  onchange="checkNumeric(this)"></th> 
						<th><input type="text" name="figm001" id="cargoDescrip"  value="" size="3" maxlength="3" onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="briefCargodescon" value="" size="30" maxlength="30"></th>
						<th><input type="text" name="figm001" id="expdate" value=""  readonly="readonly"></th>
						<th><input type="text" name="figm001" id="timeofdep" value="" onblur="changeUpper(this)"></th>
						<th><input type="text" name="figm001" id="tonotransrepoaridep"  Value="" size="5" maxlength="5" onblur="changeUpper(this)"></th>
						<!-- New field 12/1119 kamalakanta hidden field-->
						<th><input type="hidden" id="mesType" name="Message Type "  size="1" maxlength="1"  value=""></th>
						<th><input type="hidden" id="vesType" name="vessel Type Movement " size="2" maxlength="2"   value=""></th>
						<th><input type="hidden" id="authoseaCarcode" name="Authorized Sea Carrier Code  " size="10" maxlength="10"  value=""></th>
						<th><input type="hidden" id="portoDreg" name="Port of Registry " size="6" maxlength="6" value=""></th>
						<th><input type="hidden" id="regDate" name="Registry Date  "   size="35" maxlength="35" value=""></th> 
						<th><input type="hidden" id="voyDetails" name="Voyage details " value=""></th>
						<th><input type="hidden" id="shipItiseq" name="Ship Itinerary sequence  " size="6" maxlength="6" value=""></th>
						<th><input type="hidden" id="shipItinerary" name="Ship Itinerary  " size="15" maxlength="15" value=""></th>
						<th><input type="hidden" id="portofCallname" name="Port of call Name  " min="6" max="25"  value=""></th>
						<th><input type="hidden" id="arrivalDepdetails" name="Arrival/Departure Details  " size="4" maxlength="4" value=""></th>
						<th><input type="hidden" id="totalnoTransarrivdep" name="Total no.of transport equipment reported on Arrival/Departure  "value=""></th>
					</tr>

				</table>

			</div>
			
		</div>
	</div>
	<div id="blankowndiv" style="display: none">
		<div class="text_header" style="height: 20%">
			<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
					<td><h2 style="height: 20px; width: 70px;">BL Details</h2></td>
					<td style="float: right">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="middle" align="left"><img border="0"
									src="<%=lstrCtxPath1%>/images/imgDivider.gif" height="20"></td>
								<td class="text_header"><input type="checkbox"
									name="figm001" disabled='true' id="checkIgmInfo" value=""
									style="height: 15px; width: 35px;" onclick="igmnumbercheck()"><span
									style="float: right; font-size: 12px; font-weight: bold;">IGM-Update</span></td>
								<td valign="middle" align="left"><img border="0"
									src="<%=lstrCtxPath1%>/images/imgDivider.gif" height="20"></td>
								<td class="text_header"><input type="checkbox"
									name="figm001" disabled='true' id="checkBLInfo" value=""
									style="height: 15px; width: 35px;" onclick="bllevelcheck()" ><span
									style="float: right; font-size: 12px; font-weight: bold;">BL-Level</span></td>
								
								
								<td valign="middle" align="left"><img border="0"
									src="<%=lstrCtxPath1%>/images/imgDivider.gif" height="20"></td>
								<form id="fileUploadForm"  enctype="multipart/form-data" method="post">
								<td>
								<input  class="event_btnbutton" type="file"
									name="fileExl" id="fileUpload" size="50px"/>
								</td>
								<td><input class="event_btnbutton" style="width: 80px"
									type="button" name="figm001" id="btnUpload" value="Upload"
									onclick="onUpload()" />
								</td>
								</form>
								<td valign="middle" align="left"><img border="0"
									src="<%=lstrCtxPath1%>/images/imgDivider.gif" height="20"></td>
								<td class=""><input type="text" name="figm001"
									placeholder="BL_Number" id="blSearchNo" value=""
									style="width: 90%" onblur="changeUpper(this)"></td>
								<td class=""><input type="button" value="Search"
									name="figm001" class="event_btnbutton" disabled='true'
									id="blSearchNoButton" onclick='return findBlNo()'></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		
			<div class="buttons_box1" >		
			<button id="slideBack" type="button" style="background: url(<%=lstrCtxPath1%>/images/btnArrowBack.gif) top left no-repeat;boder:none;height: 20px;float:left;"></button>
			<button id="slide" type="button" style="background: url(<%=lstrCtxPath1%>/images/btnArrowNext.gif) top left no-repeat;boder:none;height: 20px;float:right;"></button>						
		</div>
		<div class="scoll-pane mt-4"  id="blankowndiv1"  >
		<div class="table">
					<table class="whitebg" border="0" style="display: inline-table;background-color: #CCCCCC;font-size: 10px;word-spacing: 5px;width:100%">
						<tr style="line-height:.7rem">
							<th class="TableLeftSub" style="border:1px solid gray;"><input
								type="checkbox" disabled='true' name="SelectAll" value="Y"
								id="selectall" onclick="clickSelectAll()"></input></th>
							<th class="TableLeftSub"  style="padding-right: 5px;border:1px solid gray; ">Sequence</th>
							<th class="TableLeftSub" style="padding-right: 55px;border:1px solid gray;  ">Item
								Number</th>
							<th class="TableLeftSub" style="padding-right: 80px;border:1px solid gray; ">BL#</th>
								<th class="TableLeftSub" style="padding-right: 25px;border:1px solid gray; ">BL
								Version</th>
							<th class="TableLeftSub" style="padding-right: 65px;border:1px solid gray; ">BL_Date</th>
							<th class="TableLeftSub" style="padding-right: 55px; border:1px solid gray;">CFS-Custom
								Code</th>
							<th class="TableLeftSub" style="padding-right: 25px; border:1px solid gray;">Cargo
								Nature</th>
							<th class="TableLeftSub" style="padding-right: 35px;border:1px solid gray;">Item
								Type</th>
							<th class="TableLeftSub" style="padding-right: 15px; border:1px solid gray;">Cargo
								Movement</th>
							<th class="TableLeftSub" style="padding-right: 5px;border:1px solid gray; ">Cargo
								Movement Type</th>
							<th class="TableLeftSub" style="padding-right: 10px; border:1px solid gray;">Transport
								Mode</th>
							<th class="TableLeftSub" style="padding-right: 75px;border:1px solid gray;">Road
								Carr. Code</th>
							<th class="TableLeftSub" style="padding-right: 75px;border:1px solid gray; ">TP
								Bond No</th>
							<th class="TableLeftSub" style="padding-right: 65px;border:1px solid gray;">Submit
								Date Time</th>
							<th class="TableLeftSub" style="padding-right: 55px;border:1px solid gray;">DPD
								Movement</th>
							<th class="TableLeftSub" style="padding-right: 75px;border:1px solid gray; ">DPD
								Code</th>
							<th class="TableLeftSub" style="padding-right: 30px;border:1px solid gray;  ">Consolidated Indicator</th>
							<th class="TableLeftSub" style="padding-right: 5px;border:1px solid gray;">Previous Declaration</th>
							
							</tr>
							</table>
							<table class="whitebg" border="0" style="display: inline-table;background-color: #CCCCCC;font-size: 10px;word-spacing: 5px;width:100%">
							<tr style="line-height:.7rem"> 
							 <!-- break -->
							<th class="TableLeftSub" style="padding-right: 40px;border:1px solid gray; ">Consolidator PAN</th> 
							<th class="TableLeftSub" style="padding-right: 30px; border:1px solid gray; ">CIN TYPE</th>
							<th class="TableLeftSub" style="padding-right: 75px; border:1px solid gray; ">MCIN</th>
							<th class="TableLeftSub" style="padding-right: 55px; border:1px solid gray;">CSN Submitted Type </th>
							<th class="TableLeftSub" style="padding-right: 45px; border:1px solid gray; ">CSN Submitted by </th>
							<th class="TableLeftSub" style="padding-right: 60px;border:1px solid gray;">CSN Reporting Type</th>
							<th class="TableLeftSub" style="padding-right: 75px;border:1px solid gray; ">CSN Site ID</th>
							<th class="TableLeftSub" style="padding-right: 65px;border:1px solid gray; ">CSN Number</th>
							<th class="TableLeftSub" style="padding-right: 70px;border:1px solid gray; ">CSN Date</th>
							<th class="TableLeftSub" style="padding-right: 60px;border:1px solid gray; ">Previous MCIN</th>
							<th class="TableLeftSub" style="padding-right: 55px; border:1px solid gray;">Split Indicator</th>
							<th class="TableLeftSub" style="padding-right: 55px;border:1px solid gray;">Number of Packages </th>
							<th class="TableLeftSub" style="padding-right: 65px;border:1px solid gray;  ">Type of Package</th>
							<th class="TableLeftSub" style="padding-right: 30px; border:1px solid gray; ">FPPD </th>
							<th class="TableLeftSub" style="padding-right: 65px;border:1px solid gray; ">Type of Cargo</th>
							<th class="TableLeftSub" style="padding-right: 15px; border:1px solid gray;">Split Indicator List</th>
							<th class="TableLeftSub" style="padding-right: 10px; border:1px solid gray; ">Port of Acceptance</th>
							<th class="TableLeftSub" style="padding-right: 60px;border:1px solid gray; ">Port of Receipt</th>
							</tr>
							</table>
							<table class="whitebg" border="0" style="display: inline-table;background-color: #CCCCCC;font-size: 10px;word-spacing: 5px;width:54%">
							<tr style="line-height:.7rem"> 
							<th class="TableLeftSub" style="padding-right: 70px;border:1px solid gray; ">UCR Type</th>
							<th class="TableLeftSub" style="padding-right: 60px;border:1px solid gray; ">UCR Code</th>
							<th class="TableLeftSub" style="padding-right: 50px;border:1px solid gray; ">Consignee</th>
							<th class="TableLeftSub" style="padding-right: 50px;border:1px solid gray; ">Consignor</th>
							<th class="TableLeftSub" style="padding-right: 60px;border:1px solid gray; ">Notify Party</th>
							<th class="TableLeftSub" style="padding-right: 55px;border:1px solid gray; ">Marks-Number</th>
							<th class="TableLeftSub" style="padding-right: 40px;border:1px solid gray; ">Container
								Details</th>
							</tr>				

				</table>

			</div>
			<br>
			<div id="container"	style="overflow-y: scroll;width:150%; height:90px" >
				<table id="blTable">
					<tr id="row3">
						<td id="billAmount"></td>

					</tr>
				</table>
			</div>
	
		</div>
	</div>
	
	<br>
	<br>
	<br>
	<br>
	<!--  <div id="container" style="width: 100%;">  -->
		<div class="footer" >
		<table border="0" width="100%" cellspacing="1" cellpadding="4">
			<tr>
				<td width="3%" bgcolor="#D4D0C8">
					<p align="center">
						<img border="0" src="<%=lstrCtxPath1%>/images/imgError.gif"
							width="16" height="16">
							</p>
				</td>
				<td width="97%" bgcolor="#D4D0C8" valign="middle" align="left"
					id="messagetd" style="font-family: Verdana; font-size: 10pt;">
					<p align="left">
					<div id='msg' style="width: 100%; color:black;"></div>
					</p>
				</td>
			</tr>
		</table>
	</div>

	<!-- </form> -->

</BODY>
<script>
	var igmpage;
	var vvd = [ {
		'type' : 'radio',
		'columnName' : 'Option'
	}, {
		'type' : 'text',
		'columnName' : 'Sequence'
	}, {
		'type' : 'text',
		'columnName' : 'Service',
		"mappedCol" : 'service'
	}, {
		'type' : 'text',
		'columnName' : 'Vessel',
		'mappedCol' : 'vessel'
	}, {
		'type' : 'text',
		'columnName' : 'Voyage',
		'mappedCol' : 'voyage'
	}, {
		'type' : 'text',
		'columnName' : 'Port',
		'mappedCol' : 'pod'
	}, {
		'type' : 'text',
		'columnName' : 'Terminal',
		'mappedCol' : 'terminal'
	}, {
		'type' : 'text',
		'columnName' : 'Custom Terminal Code',
		'mappedCol' : 'customTerminalCode'
	}, {
		'type' : 'text',
		'columnName' : 'From Item No',
		'mappedCol' : 'fromItemNo'
	}, {
		'type' : 'text',
		'columnName' : 'To Item No',
		'mappedCol' : 'toItemNo'
	}, {
		'type' : 'text',
		'columnName' : 'New Voyage',
		'mappedCol' : 'newVoyage'

	}, {
		'type' : 'text',
		'columnName' : 'New Vessel',
		'mappedCol' : 'newVessel'

	}, {
		'type' : 'text',
		'columnName' : 'Road Carr code',
		'mappedCol' : 'roadCarrCodeVVS'
	}, {
		'type' : 'text',
		'columnName' : 'TP Bond No',
		'mappedCol' : 'roadTpBondNoVVSS'
	}, {
		'type' : 'text',
		'columnName' : 'CFS Custom Code',
		'mappedCol' : 'cfsCustomCode'
	}, {
		'type' : 'hidden',
		'columnName' : 'Pol',
		'mappedCol' : 'pol'
	}, {
		'type' : 'hidden',
		'columnName' : 'Pol Terminal',
		'mappedCol' : 'polTerminal'
	}, {
		'type' : 'hidden',
		'columnName' : 'DEL VLS',
		'mappedCol' : 'del'
	}, {
		'type' : 'hidden',
		'columnName' : 'DEPOT VLS',
		'mappedCol' : 'depot'
	}]

var bld = [{
		'type' : 'checkbox',
		'columnName' : 'Option'
	},{
		'type' : 'text',
		'columnName' : 'Sequence'
	},{
		'type' : 'text',
		'columnName' : 'Item Number',
		"mappedCol" : 'itemNumber'
	},{
		'type' : 'text',
		'columnName' : 'BL#',
		'mappedCol' : 'bl'
	},{
		'type' : 'text',
		'columnName' : 'BL Version',
		'mappedCol' : 'blVersion'
	},{
		'type' : 'text',
		'columnName' : 'BL_Date',
		'mappedCol' : 'blDate'
	},{
		'type' : 'hidden',
		'columnName' : 'BL Status',
		'mappedCol' : 'blStatus'
	},{
		'type' : 'text',
		'columnName' : 'CFS-Custom Code',
		'mappedCol' : 'cfsName'
	},{
		'type' : '',
		'columnName' : 'Cargo Nature',
		'mappedCol' : 'cargoNature'
	},{
		'type' : 'text',
		'columnName' : 'Item Type',
		'mappedCol' : 'itemType'
	},{
		'type' : 'text',
		'columnName' : 'Cargo Movement',
		'mappedCol' : 'cargoMovmnt'
	},{
		'type' : 'text',
		'columnName' : 'Cargo Movement Type',
		'mappedCol' : 'cargoMovmntType'
	},{
		'type' : 'text',
		'columnName' : 'Transport Mode',
		'mappedCol' : 'transportMode'
	},{
		'type' : 'text',
		'columnName' : 'Road Carr code',
		'mappedCol' : 'roadCarrCode'
	},{
		'type' : 'text',
		'columnName' : 'TP Bond No',
		'mappedCol' : 'roadTpBondNo'
	},{
		'type' : 'text',
		'columnName' : 'Submit Date Time',
		'mappedCol' : 'submitDateTime'
	},{
		'type' : 'text',
		'columnName' : 'DPD Movement',
		'mappedCol' : 'dpdMovement'
	},{
		'type' : 'text',
		'columnName' : 'DPD Code',
		'mappedCol' : 'dpdCode'
	},{
		'type' : 'text',
		'columnName' : 'Consolidated Indicator',
		'mappedCol' : 'consolidated_indicator'
	},{
		'type' : 'text',
		'columnName' : 'Previous Declaration',
		'mappedCol' : 'previous_declaration'
	},{
		'type' : 'text',
		'columnName' : 'Consolidator PAN',
		'mappedCol' : 'consolidator_pan'
	},{
		'type' : 'text',
		'columnName' : 'CIN TYPE',
		'mappedCol' : 'cin_type'
	},{
		'type' : 'text',
		'columnName' : 'MCIN',
		'mappedCol' : 'mcin'
	},{
		'type' : 'text',
		'columnName' : 'CSN Submitted Type',
		'mappedCol' : 'csn_submitted_type'
	},{
		'type' : 'text',
		'columnName' : 'CSN Submitted by',
		'mappedCol' : 'csn_submitted_type'
	},{
		'type' : 'text',
		'columnName' : 'CSN Reporting Type',
		'mappedCol' : 'csn_reporting_type'
	},{
		'type' : 'text',
		'columnName' : 'CSN Site ID',
		'mappedCol' : 'csn_site_id'
	},{
		'type' : 'text',
		'columnName' : 'CSN Number',
		'mappedCol' : 'csn_number'
	},{
		'type' : 'text',
		'columnName' : 'CSN Date',
		'mappedCol' : 'csn_date'
	},{
		'type' : 'text',
		'columnName' : 'Previous MCIN',
		'mappedCol' : 'previous_mcin'
	},{							
		'type' : 'text',
		'columnName' : 'Split Indicator',
		'mappedCol' : 'split_indicator'
								
	},{
		'type' : 'text',
		'columnName' : 'Number of Packages',
		'mappedCol' : 'packageBLLevel'							
	},{
		'type' : 'text',
		'columnName' : 'Type of Package',
		'mappedCol' : 'type_of_package'
										
	},{
		'type' : 'text',
		'columnName' : 'First Port of Entry/Last Port of Departure',
		'mappedCol' : 'first_port_of_entry_last_port_of_departure'
	},{
		'type' : 'text',
		'columnName' : 'Type Of Cargo',
		'mappedCol' : 'type_of_cargo'
	},{
		'type' : 'text',
		'columnName' : 'Split Indicator List',
		'mappedCol' : 'split_indicator_list'
	},{											
		'type' : 'text',
		'columnName' : 'Port of Acceptance',
		'mappedCol' : 'port_of_acceptance'
	},{											
		'type' : 'text',
		'columnName' : 'Port of Receipt',
		'mappedCol' : 'port_of_receipt'
	},{																
	    'type' : 'text',
	    'columnName' : 'UCR Type',
	    'mappedCol' : 'ucr_type'
	},{																	
	    'type' : 'text',
	    'columnName' : 'UCR Code',
	     'mappedCol' : 'ucr_code'
	},{
		'type' : 'text',
		'columnName' : 'Consignee',
		'mappedCol' : 'consignee'
	},{
		'type' : 'text',
		'columnName' : 'Consigner',
		'mappedCol' : 'consigner'
	},{
		'type' : 'text',
		'columnName' : 'Notify Party',
		'mappedCol' : 'notifyParty'
	},{
		'type' : 'text',
		'columnName' : 'Marks_Number',
		'mappedCol' : 'marksNumber'
	},{
		'type' : 'text',
		'columnName' : 'Container Details',
		'mappedCol' : 'containerDetails'
	},{
		'type' : 'hidden',
		'columnName' : 'Is Present',
		'mappedCol' : 'isPresent'
	},{
		'type' : 'hidden',
		'columnName' : 'Custom ADD1',
		'mappedCol' : 'cusAdd1'
	},{
		'type' : 'hidden',
		'columnName' : 'Custom ADD2',
		'mappedCol' : 'cusAdd2'
	},{
		'type' : 'hidden',
		'columnName' : 'Custom ADD3',
		'mappedCol' : 'cusAdd3'
	},{
		'type' : 'hidden',
		'columnName' : 'Custom ADD4',
		'mappedCol' : 'cusAdd4'
	},{
		'type' : 'hidden',
		'columnName': 'BL Validate Flag',
        'mappedCol'  :  'isValidateBL'
	},{
		'type' : 'hidden',
		'columnName': 'Package BL Level',
	    'mappedCol'  : 'packageBLLevel'
	},{
		'type' : 'hidden',
		'columnName': 'Gross Cargo Weight BL level',
	    'mappedCol' : 'grossCargoWeightBLlevel'
	},{
		/* Hidden field bl  section */
		'type'      : 'hidden',
		'columnName': 'Port of Acceptance Name',
	    'mappedCol' : 'port_of_acceptance_name'
	},{
		'type'      : 'hidden',
		'columnName': 'Port of Receipt Name',
	    'mappedCol' : 'port_of_receipt_name'
	},{
		'type'      : 'hidden',
		'columnName': 'PAN of notified party',
	    'mappedCol' : 'pan_of_notified_party'
	},{
		'type'      : 'hidden',
		'columnName': 'Unit of weight',
	    'mappedCol' : 'unit_of_weight'
	},{
		'type'      : 'hidden',
		'columnName': 'Gross Volume',
	    'mappedCol' : 'gross_volume'
	},{
		'type'      : 'hidden',
		'columnName': 'Unit of Volume',
	    'mappedCol' : 'unit_of_volume'
	},{
		'type'      : 'hidden',
		'columnName': 'Cargo Item Sequence No', 
	    'mappedCol' : 'cargo_item_sequence_no'   
	},{
		'type'      : 'hidden',
		'columnName': 'Cargo Item Description',
	    'mappedCol' : 'cargo_item_description'
	},{
		'type'      : 'hidden',
		'columnName': 'UNO Code',
	    'mappedCol' : 'uno_code'
	},{
		'type'      : 'hidden',
		'columnName': 'IMDG Code',
	    'mappedCol' : 'imdg_code'
	},{
		'type'      : 'hidden',
		'columnName': 'Number of Packages Hidden',
	    'mappedCol' : 'number_of_packages'
	},{
		'type'      : 'hidden',
		'columnName': 'Type of Packages Hidden',
	    'mappedCol' : 'type_of_packages_hidden'
	},{
		'type'      : 'hidden',
		'columnName': 'Container Weight',
	    'mappedCol' : 'container_weight'
	},{
		'type'      : 'hidden',
		'columnName': 'Port of call sequence number',
	    'mappedCol' : 'port_of_call_sequence_number'
	},{
		'type'      : 'hidden',
		'columnName': 'Port of Call Coded',
	    'mappedCol' : 'port_of_call_coded'
	},{
		'type'      : 'hidden',
		'columnName': 'Next port of call coded',
	    'mappedCol' : 'next_port_of_call_coded'
	},{
		'type'      : 'hidden',
		'columnName': 'MC Location Customs',
	    'mappedCol' : 'mc_location_customs'
	}]


	
	
	/* function for date and calendar */
	var counter = 1;
	$(function() {

		$("#blCreationDateFrom").datepicker();
		$("#blCreationDateTo").datepicker();
		//$("#ataAd").datepicker();

		$("#blCreationDateFrom").datepicker("option", "dateFormat", "dd/mm/yy");
		$("#blCreationDateTo").datepicker("option", "dateFormat", "dd/mm/yy");
		//$("#ataAd").datepicker("option", "dateFormat", "dd/mm/yy");

		/* var toBeModifiedDate = new Date();
		onloadDateShow(toBeModifiedDate); */

	});

	/* function blCreationDateToFunction() {

		var today = $("#blCreationDateTo").val();
		var check = moment(today, 'DD/MM/YYYY');
		console.log(check);
		var month = check.format('M');

		var c = moment(check).subtract(3, 'months').format('DD/MM/YYYY');

		$("#blCreationDateFrom").val(c);
	} */

	/* function onloadDateShow(toBeModifiedDate) {

		var currentDate = moment(toBeModifiedDate).format('DD/MM/YYYY');
		$("#blCreationDateTo").val(currentDate);
		//$("#ataAd").val(currentDate);
		blCreationToDate = currentDate;
		blCreationDateToFunction();
	} */
	function dateTo() {

		$("#blCreationDateTo").datepicker();
		$("#blCreationDateTo").datepicker("option", "dateFormat", "dd/mm/yy"); 

		/*	if (counter == 1) {
			var currentDate = new Date();
			onloadDateShow(new Date());
			counter++;
		} */
		$("#blCreationDateTo").datepicker("show");
		
	}
	function dateFrom() {
		$("#blCreationDateFrom").datepicker();
		$("#blCreationDateFrom").datepicker("option", "dateFormat", "dd/mm/yy"); 
		
		$("#blCreationDateFrom").datepicker("show");
		//blCreationDateToFunction();
	}

	/* Button Function For Rest the Page */

	function onResetForm() {

		document.getElementById("inStatus").value = "";
		document.getElementById("pol").value = "";
		document.getElementById("polTerminal").value = "";
		document.getElementById("blCreationDateTo").value = "";
		document.getElementById("blCreationDateFrom").value = "";
		document.getElementById("igmservice").value = "";
		document.getElementById("vessel").value = "";
		document.getElementById("voyage").value = "";
		document.getElementById("podTerminal").value = "";
		document.getElementById("pod").value = "";
	}

	function mergeFiles() {
		var mgsnull=document.getElementById("msg");
		mgsnull.innerHTML = '';
		meregefile = true;
		if (popupWindow && !popupWindow.closed)
			popupWindow.focus();
		else

			popupWindow = window
			.open(
					"<%=lstrCtxPath1%>/pages/igm/ImportGeneralManifestMergeFiles.jsp",
					"", "width=360,height=210, top=100, left=500,");
		popupWindow.focus();
	}

	function consigneeInfo(selectObject) {
		var mgsnull=document.getElementById("msg");
		mgsnull.innerHTML = '';
		var popupWindow=""
		consigneeInfor = true;
		if (popupWindow && !popupWindow.closed)
			popupWindow.focus();
		else{
			popupWindow=null;
			popupWindow = window
			.open(
					"<%=lstrCtxPath1%>/pages/igm/ImportGeneralManifestConsignee.jsp",
					"_blank", "width=1050,height=350, top=100, left=160,");
		}
		if (window.focus) {popupWindow.focus()}
		
		setTimeout(consigneeMethod, 500, popupWindow, selectObject);

	}

	function ConsignerInfo(selectObject) {
		var mgsnull=document.getElementById("msg");
		mgsnull.innerHTML = '';
		var popupWindow=""
			consignerInfo = true;
		if (popupWindow && !popupWindow.closed)
			popupWindow.focus();
		else{
			popupWindow=null;
			popupWindow = window
			.open(
					"<%=lstrCtxPath1%>/pages/igm/ImportGeneralManefestConsigner.jsp",
					"_blank", "width=1050,height=350, top=100, left=160,");
		}
		if (window.focus) {popupWindow.focus()}
		
		setTimeout(consignerMethod, 500, popupWindow, selectObject);

	}

	function notifyInfo(selectObject) {
		var mgsnull = document.getElementById("msg");
		mgsnull.innerHTML = '';
		notifyInfor = true;
		var popupWindow = ""
		if (popupWindow && !popupWindow.closed)
			popupWindow.focus();
		else {
			popupWindow = null;
			popupWindow = window
					.open(
							"<%=lstrCtxPath1%>/pages/igm/ImportGeneralManifestNotifyParty.jsp",
					        "_blank", "width=1050,height=350, top=100, left=160,");
		}

		if (window.focus) {popupWindow.focus()}
		
		setTimeout(notifyPartyme, 500, popupWindow, selectObject);

	}
	function marksInfo(selectObject) {
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
					"<%=lstrCtxPath1%>/pages/igm/ImportGeneralManifestMarksNumber.jsp",
					"_blank", "width=800,height=400, top=100, left=300,");
		}

		if (window.focus) {popupWindow.focus()}

		setTimeout(markNumberme, 500, popupWindow, selectObject);
	}

	function containerDetailsInfo(selectObject) {
		var mgsnull=document.getElementById("msg");
		mgsnull.innerHTML = '';
		var popupWindow="";
		containerDetailsInfor = true;
		if (popupWindow && !popupWindow.closed)
			popupWindow.focus();
		else
		{
			popupWindow=null;
			popupWindow = window
			.open(
					"<%=lstrCtxPath1%>/pages/igm/ImportGeneralManifestContainerDetails.jsp",
					"_blank", "width=1350,height=350, top=200, left=0,");
		}

	if (window.focus) {popupWindow.focus()} 

	setTimeout(containerme, 500, popupWindow, selectObject);

	}
	
/* 	function (element){
	 var max_chars = 2;
     
	    if(element.value.length > max_chars) {
	        element.value = element.value.substr(0, max_chars);
	    }
	}
		 */
/*
 * Function for restricting the legnth of the text filed
 */


		 var igmNoTxtBox = document.getElementById('igmNo');
		  var maxLength = 7;

		  igmNoTxtBox.addEventListener('input', function() {
		    if (igmNoTxtBox.value.length > maxLength) {
		    	igmNoTxtBox.value = igmNoTxtBox.value.slice(0, maxLength);
		    }
		  });

  /*
  * Function for restricting the legnth of the text filed
  */
/*    function setMaxLength() {
	    var textbox = document.getElementById('myTextbox');
	    textbox.maxLength = 10;
	  }
			 var cfsCustCodeTxtBox = document.getElementById('0CFS-Custom Code');
		  var maxLength = 7;

		  cfsCustCodeTxtBox.addEventListener('input', function() {
		    if (cfsCustCodeTxtBox.value.length > maxLength) {
		    	cfsCustCodeTxtBox.value = cfsCustCodeTxtBox.value.slice(0, maxLength);
		    }
		  }); */
		  
</script>

<script>
var button = document.getElementById('slide');
button.onclick = function () {
    var blankowndiv1 = document.getElementById('blankowndiv1');
    sideScroll(blankowndiv1,'right',25,500,10);
};

var back = document.getElementById('slideBack');
back.onclick = function () {
    var blankowndiv1 = document.getElementById('blankowndiv1');
    sideScroll(blankowndiv1,'left',25,500,10);
};

function sideScroll(element,direction,speed,distance,step){
    scrollAmount = 0;
    var slideTimer = setInterval(function(){
        if(direction == 'left'){
            element.scrollLeft -= step;
        } else {
            element.scrollLeft += step;
        }
        scrollAmount += step;
        if(scrollAmount >= distance){
            window.clearInterval(slideTimer);
        }
    }, speed);
}
</script>
</html>
