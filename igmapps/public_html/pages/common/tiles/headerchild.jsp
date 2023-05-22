<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<%@page import="com.niit.control.common.GlobalConstants,com.niit.control.web.action.BaseAction,com.niit.control.web.*" %>

<!--style href>
a {
    text-decoration: none
  }
</style-->

<tiles:useAttribute id='lstrProgID'     name='progId' />
<tiles:useAttribute id='lstrFormBeanID'     name='formId' />
<tiles:useAttribute id='lstrScrTitle'       name='title' />
<tiles:useAttribute id='lstrScreenHeading'  name='screenHeading' />
<tiles:useAttribute id='lstrScreenVersion'  name='screenVersion' />

<%
String lstrCtxPath = request.getContextPath();
UserAccountBean account=(UserAccountBean)session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
%>
<script type="text/javascript" language="JavaScript">
var fscAccessLevels = '<%=account.getFscAccessLevels()%>';
var allVals = fscAccessLevels.split("/");
function getLine(){
	return allVals[0];
}
function getTrade(){
	return allVals[1];
}
function getAgent(){
	return allVals[2];
}
</script>
<div class="page_title">
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td width="40%" class="PageTitle"><%=lstrScreenHeading%></td>
    <td width="60%" class="PageTitleRight">
        <table border="0" width="100%" cellspacing="0" cellpadding="0">
        <tr>
            <td width="15%" valign="middle" align="right"><font size="1" face="Verdana" color="#FFFFFF"></font></td>
            <td width="70%" valign="middle" align="right"><font size="1" face="Verdana" color="#FFFFFF"></font></td>
            <td valign="middle" align="left"><img border="0" src="<%=lstrCtxPath%>/images/imgDivider.gif" height="20"></td>
            <td width="50" valign="middle" align="center"><a href="javascript:openHelp()"><img border="0" alt="Help" src="<%=lstrCtxPath%>/images/btnHelp.jpg" width="40" height="16"></a></td>
            <td width="6" valign="middle" align="center"><img border="0" src="<%=lstrCtxPath%>/images/imgDivider.gif" width="12" height="20"></td>						
            <td width="2%"><a href="javascript:window.close()"><img border="0" src="<%=lstrCtxPath%>/images/btnClose.gif" alt="Close" width="16" height="16"></a></td>       
        </tr>
        </table>                                
    </td>
</tr>
</table>
</div>
<div class="page_info">
<span><%=lstrScreenVersion%>&nbsp;&nbsp;</span>
</div>
