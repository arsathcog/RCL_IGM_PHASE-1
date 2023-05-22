<%@ taglib uri="/WEB-INF/niit-html.tld" prefix="niit" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%    
	String lstrCtxPath = request.getContextPath();
%>
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
