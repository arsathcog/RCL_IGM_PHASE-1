<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="com.niit.control.common.*"%>
<%@ page import="com.niit.control.web.*"%>
<%@ page import="com.niit.control.web.action.*"%>
<%
session.removeAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
String strUserid = (String)request.getParameter("userid");
String password  = "x";
String strUserFsc = "R";
String strAccessLvl = "R~*~***";
String dateFormat = "1";
if(strUserid == null){
    strUserid = "NIIT01";
}
if ( strUserid.equals("NESTLE")){
	strUserFsc = "-";
	strAccessLvl = "-~-~-";
} else if ( !strUserid.equals("NIIT01")){
	strUserFsc = "BKK";
	strAccessLvl = "R~I~BKK";
}
Cookie objCookie1 = new Cookie("RCL_AUTH_KEY",strUserid + "~" + password + "~" + strUserFsc + "~" + strAccessLvl + "~" + dateFormat);
objCookie1.setMaxAge(-1);
//objCookie1.setDomain(".rclgroup.com");
//objCookie1.setDomain(".in.niit-tech.com");
objCookie1.setPath("/");
response.addCookie(objCookie1);
String strServerName = request.getServerName();
String strServerPort = ""+request.getServerPort();
System.out.println("request.getServerName()="+strServerName);
System.out.println("request.getServerPort()="+strServerPort);
String lstrCtxPath = request.getContextPath();
%>
<%

UserAccountBean account = (UserAccountBean) session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
if(account!= null){
String astrProgId = "SVCT001";
String strProgGroupId = (String)GlobalParam.loadProgInfo().get(astrProgId);
System.out.println("strProgGroupId="+strProgGroupId);
ProgInfo        lobjProgInfo = account.getProgInfo(strProgGroupId);
System.out.println("lobjProgInfo.getReadFlag()="+lobjProgInfo.getReadFlag());
}
%>
<script language="javascript">
var serverUrl = '<%="http://" + strServerName + ":" + strServerPort%>';
var aw = screen.availWidth;
var ah = screen.availHeight;
function openScreen(screen_url,screen_id)
{
	var screenWidth = aw-5;	    
	var screenHeight= ah-54;
	var x = aw>800?(aw-screenWidth)/2:0;
	var y = ah>600?(ah-screenHeight)/2:0;
	
	var winName = screen_id;		
	childWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=yes,scrollbars=yes,toolbar=yes,titlebar=yes');					
        //childWindow = window.open(screen_url,winName);
        childWindow.focus();
}
function openChildScreen(screen_url,screen_id)
{	
	var screenWidth = 600;	    
	var screenHeight= 400;
	var x = aw>800?(aw-screenWidth)/2:0;
	var y = ah>600?(ah-screenHeight)/2:0;
	var winName = screen_id;		
	childWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=no,scrollbars=no,toolbar=no,titlebar=yes');					
	childWindow.focus();
}

function doBack() {
	document.menu.action='<%=lstrCtxPath%>/pages/Welcome.jsp';
	document.menu.submit();
	return false;
}
</script>
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
  <form name="menu" method="POST" action="#">
  <div align='center'>
  <p>
  <b>RCL - EZY LOAD LIST APPLICATION</b>
  </p>
  <BR>
  <BR>
  </div>
  <div align='center'>
  <table border="1" cellspacing="0" cellpadding="0" width="250">
  <tr>
	<td>User ID :</td>
	<td>
	<input type="text" name="userid" value='<%=strUserid%>' readonly />
	</td>
  </tr>
  </table>
  </p>
  <table border="1" cellspacing="0" cellpadding="0" width="250">
  <tr>
  <td>
  <b>EZL MENU</b>
  </td>
  </tr>
  <tr>
  <td>
  <a href="javascript:openScreen(serverUrl + '<%=lstrCtxPath%>/do/sigm001?appId=Dolphin&PAGE_URL=/do/sigm001','sigm001')"> Import General Manifest(IGM)</a>
  </td>
  </tr>
  
  </table>
  </p>
  <table border="1" cellspacing="0" cellpadding="0" width="250">
  <tr>
	<td>
	<input type="button" value=" BACK " onclick="doBack()"/>
	</td>
  </tr>
  </table>
  </div>
  </form>
  </body>
</html>