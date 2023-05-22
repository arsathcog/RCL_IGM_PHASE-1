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
        <title>IGM Marks/Description Details</title>
        <link rel="stylesheet" href="<%=lstrCtxPath1%>/css/NTL.css" />
		<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/RCL.css" />
		<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/EZL.css" />
		
		<SCRIPT language="javascript" type="text/javascript">
		   var PROG_ID          = 'SIGM001UPLOADFILE';
		   var FORM_ID          = 'figm001';
		</SCRIPT>
<style type="text/css">
.scrollabletextbox {
	height: 280px;
	width: 395px;
	font-family: Verdana, Tahoma, Arial, Helvetica, sans-serif;
	font-size: 82%;
	overflow: scroll;
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

.marksNo {
	margin: 1px;
	width: 350px;
	height: 150px;
	margin-top: 2px;
	vertical-align: top;
	font-size: 12px;
	color: #333333;
	border: #3E71CC 1px solid;
	letter-spacing: -1px;
}

.description {
	margin: 1px;
	width: 350px;
	height: 150px;
	margin-top: 2px;
	margin-left: 30px;
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
				<h2 class="text_header" style="width:99.5%"><b>Import General Manifest Marks/Description Details</b></h2>
			</td>
			<br><br><br>

		<table class="table_search">
		<tbody class="whitebg" border="0" style="background-color: #CCCCCC;">
			<thead style="font-size: 15px;">
				<tr>
					<th class="TableLeftSub" style="margin: 0px;width: 1100px;">Marks & Numbers</th>
					<th class="TableLeftSub" style="margin: 0px;padding-left: 20px;width: 1100px;">Description</th>
				</tr>
			</thead>
		</tbody>
	</table>
</div>	
	<br>
<div id="container" style="overflow: scroll; height: 200px; width: 100%;">
	<table id="blTable">
		<tr id="row3">
			<td id="marksNumberinfo"></td>
		</tr>
	</table>
</div>	
	<div class="buttons_box">
			<input type="button" value="Close" name="btnClose"
			id="closeType" class="event_btnbutton" onclick='closeBtn()' />
		</div>
        </html:form>
     </body>   
<script>
    
var MND= [ {
		'type' : 'text',
		'columnName' : 'MarksNo',
		"mappedCol" : 'marksNumbers'
	},{
		'type' : 'text',
		'columnName' : 'Description',
		'mappedCol' : 'description'
	},{
		'type' : 'hidden',
		'columnName' : 'BLNO',
		'mappedCol' : 'blNO'
	}]

     function closeBtn() {
			updateJson();
			window.close();
 	}

	window.onbeforeunload = confirmExit;
	function confirmExit() {
		updateJson();
	}
	function updateJson() {
		
		var listOfMarksNumberInformation = window.opener.listOfMarksNumberInformation;

		for (i = 0; i < listOfMarksNumberInformation.length; i++)

		{
			var blno = document
					.getElementById(listOfMarksNumberInformation[i]["BLNO"]).value;

			window.opener.popupjson.popup[blno].marksNumber[i]["marksNumbers"] = document
					.getElementById(listOfMarksNumberInformation[i]["MarksNo"]).value;
			window.opener.popupjson.popup[blno].marksNumber[i]["description"] = document
					.getElementById(listOfMarksNumberInformation[i]["Description"]).value;
		}

	}

	
</script>     
</html>     