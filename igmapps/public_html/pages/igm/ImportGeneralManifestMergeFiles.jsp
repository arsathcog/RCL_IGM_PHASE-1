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
        <meta http-equiv="X-UA-Compatible" content="IE=11" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>IGM Merge Files</title>
        <link rel="stylesheet" href="<%=lstrCtxPath1%>/css/NTL.css" />
		<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/RCL.css" />
		<link rel="stylesheet" href="<%=lstrCtxPath1%>/css/EZL.css" />
		
		<SCRIPT language="javascript" type="text/javascript">
		   var PROG_ID          = 'SIGM001UPLOADFILE';
		   var FORM_ID          = 'figm001';
		</SCRIPT>
    </head>
    <body>
        <html:errors />
        <html:form action="/sigm001uploadfile" method="post" enctype="multipart/form-data"  >
			 <td>
				<h2 class="text_header" style="width:100%"><b>Import General Manifest Merge Files</b></h2>
			</td>
			<br><br><br>
			 <table class="table_search">
				<tbody>
			        <tr>
						<td style="font-family: verdana, arial, helvetica, sans-serif; font-size: 11px; font-weight: normal; background: #efefeb;"><b>Select First Manifest File&nbsp;&nbsp;&nbsp;&nbsp;   :</b></td>
			            <td ><html:file property="file1" name="figm001" onblur="changeUpper(this)" styleId='firstfile' style="height : 12pt; font-size : 7pt " onchange='fileone()'	 />   
			            </td>
					</tr>
				</tbody>
			</table>
			<br><br>
			<table class="table_search">
				<tbody>		
					
					<tr>
						<td style="font-family: verdana, arial, helvetica, sans-serif; font-size: 11px; font-weight: normal; background: #efefeb;"><b>Select Second Manifest File :</b></td>
			            <td ><html:file property="file2" name="figm001" onblur="changeUpper(this)" disabled='true' style="height : 12pt; font-size : 7pt " title='First file selection is required' styleId='secondfile' onchange='filesecond()' />   
			            </td>
					</tr>
				</tbody>
			</table>
			<br><br>
			<table>
				<tbody>		
					<tr>
					    <td>
					    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    <html:button  value= '  Reset  ' property="button" onblur="changeUpper(this)" styleClass="event_btnbutton" style="height : 15pt; font-size : 8pt ; color : blue" styleId='resettype' onclick="resetmethod()"/>
			   			</td> 
						<td>&nbsp;
			    		<html:submit  value= ' Submit ' onblur="changeUpper(this)" styleClass="event_btnbutton" disabled='true' style="height : 15pt; font-size : 8pt ; color : blue" title="File selection is required" styleId='submitype' />
			   			</td>
			   			
			   		</tr>
				</tbody>
			</table>
        </html:form>
     </body>   
     <script>
       function fileone()
       {
         if(document.getElementById("firstfile").value!='')
             {
             document.getElementById("secondfile").disabled = false; 
             document.getElementById("secondfile").title = "";            
             }
        }
       function filesecond()
       {
    	   if(document.getElementById("secondfile").value!='')
        	   {
        	   document.getElementById("submitype").disabled = false;
        	   document.getElementById("submitype").title = "";             
               }
       }
       function resetmethod()
       {
    	   document.getElementById("firstfile").value = "";
   		   document.getElementById("secondfile").value = "";
   		   document.getElementById("secondfile").disabled = true;
   		   document.getElementById("submitype").disabled = true;
   		   document.getElementById("secondfile").title = "First file selection is required";
		   document.getElementById("submitype").title = "File selection is required";
       }
      
           
      
     </script>
</html>     