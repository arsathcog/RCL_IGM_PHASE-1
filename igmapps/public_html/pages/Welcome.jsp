<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="com.niit.control.common.*"%>
<%@ page import="com.niit.control.web.*"%>
<%@ page import="com.niit.control.web.action.*"%>
<%@ page import="java.util.Locale"%>
<%		
    String lstrCtxPath = request.getContextPath();
    
%>

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
    <title>Welcome EZL</title>
    <style type="text/css">
      body {
      background-color: #aabbcc; 
      }
      a:link { color: #ffee22; }
    </style>
  </head>
  <body>
  <form name="welcome" method="POST" action="<%=lstrCtxPath%>/pages/DummyMenu.jsp">
  <div align='center'>
  <p>
  <b>RCL - EZY LOAD LIST APPLICATION</b>
  </p>
  <BR>
  <BR>
  </div>
  <div align='center'>
  <table border="1" cellspacing="0" cellpadding="0" width="300">
  <tr>
	<td>User ID :</td>
	<td>
	<select name="userid" size="1">
		<option value="NIIT01">Principal User(Admin)</option>
		<option value="KANHAN1">Discharge List Operator</option>
		<option value="EDLMGR">Discharge List Manager</option>
	</td>
  </tr>
  </table>
  </p>
  <table border="1" cellspacing="0" cellpadding="0" width="250">
  <tr>
  <td>
  <input type="submit" value=" OK "/>
  </td>
  </tr>  
  </table>
  </div>
  </form>
  </body>
</html>