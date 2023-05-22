<%@ taglib uri="/WEB-INF/niit-html.tld" prefix="niit" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%--
<!--TABLE bgcolor="#F71E1C" width="100%" cellspacing="0" cellpadding="0"  CLASS='footerFont'>
<TBODY valign="bottom">
 <TR ALIGN='center' valign="top" height='14px'>
   <TD valign="bottom">
	  <font face="Verdana, Arial, Geneva, Helvetica, sans-serif" size="1" color="#FFFFFF">
		&copy; 2009 NIIT Technologies Ltd. All trademarks acknowledged.
	  </font>
  </TD>
 </TR>
 </TBODY>
</TABLE-->
<!--
<form method="POST" action='<%=com.niit.control.web.JSPUtils.getActionMappingURL("/openreport",pageContext)%>' target="_new" name="MenuReportFrm" >
<INPUT TYPE="HIDDEN" NAME="module" VALUE="">
<INPUT TYPE="HIDDEN" NAME="reportDetails" VALUE="">
<INPUT TYPE="HIDDEN" NAME="sendType" VALUE="">
<INPUT TYPE="HIDDEN" NAME="screenIdFw" value="screenId">
<INPUT TYPE="HIDDEN" NAME="exportDetails" VALUE="">
</form>
-->
--%>
<%
    StringBuffer lstbServletPath = new StringBuffer("http://");
    lstbServletPath.append(request.getServerName());
    lstbServletPath.append(":").append(request.getServerPort());
    lstbServletPath.append(request.getContextPath());

    String  lstrRefreshURL = request.getRequestURL().toString();
    int     lintLength = lstrRefreshURL.length();
    int     lintIndex = lstrRefreshURL.lastIndexOf("/");

    if((lintLength - lintIndex) > 8 ){
        lintLength = lintIndex + 8 ;
    }
    lstrRefreshURL = lstrRefreshURL.substring(0, lintLength);

	String lstrCtxPath = request.getContextPath();

%>
<%--
<!--
<form method="POST" action='<%=com.niit.control.web.JSPUtils.getActionMappingURL("/openreport",pageContext)%>' name="AppJsp" >
    <INPUT TYPE="HIDDEN" NAME="jspParam">
    <INPUT TYPE="HIDDEN" NAME="appletParam">
    <INPUT TYPE="HIDDEN" NAME="parentParam">
    <INPUT TYPE="HIDDEN" NAME="frmFwFrcCd">
    <INPUT TYPE="HIDDEN" NAME="frmFwTable">
    <INPUT TYPE="HIDDEN" NAME="screenIdFw" value="screenId">
    <INPUT TYPE="HIDDEN" NAME="ajaxServlet" value='<%=lstbServletPath.toString()%>'>
    <INPUT TYPE='HIDDEN' NAME='refreshURL' value='<%=lstrRefreshURL%>'>
</form>
-->
--%>
<p>&nbsp;</p>
<script>
if (!document.layers) {
	document.write('<div id="divStayTopLeft" style="position:absolute">')
}
</script>
<layer id="divStayTopLeft" style="visibility:hidden;">
    <table border="0" width="100%" cellspacing="1" cellpadding="4">
    <tr>
        <td width="3%" bgcolor="#D4D0C8" >
            <p align="center">
            <img border="0" src="<%=lstrCtxPath%>/images/imgError.gif" width="16" height="16">
        </td>
        <td width="97%" bgcolor="#D4D0C8" valign="middle" align="left" id="messagetd" style="font-family:Verdana;font-size:8pt;">
            <p align="left">
            <div id='msg'>
            <niit:errorMsg/>
            </div>
        </td>
    </tr>
    </table>
</layer>
<script type="text/javascript">

    //Enter "frombottom" or "fromtop"
    var verticalpos = "frombottom"

    if (!document.layers) {
        document.write('</div>')
	}

    JSFX_FloatTopDiv();
	
</script>
