<%@ page import='com.niit.control.common.GlobalConstants' %>
<%@ taglib uri="/WEB-INF/niit-html.tld" prefix="niit" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<script type="text/javascript" language="JavaScript">
function gotoPage(pageNo)
{
    //alert('pageNo='+pageNo);
    if(pageNo == null || pageNo == '' || !isInteger(pageNo)){
            return false;
    }
	
    var lstrUrl = getActionUrl();
    if( lstrUrl != '' ) {
		if(eval(pageNo) <= 0) {
			document.forms[0].currPageNo.value= 1;
		} else if (eval(pageNo) > document.forms[0].totPage.value) {
			document.forms[0].currPageNo.value= document.forms[0].totPage.value;
		} else {
			document.forms[0].currPageNo.value= pageNo ;
		}
		
        document.forms[0].action = lstrUrl ;
        document.forms[0].submit();
    }
    return false;
}
</script>
<% 
String lstrForm       = (String) request.getParameter("formName");
if( lstrForm != null ) {
%>
<html:hidden name="<%=lstrForm%>" property="currPageSet" />
<html:hidden name="<%=lstrForm%>" property="currPageNo" />
<html:hidden name="<%=lstrForm%>" property="totRecord" />
<html:hidden name="<%=lstrForm%>" property="totPage" />
<bean:define id="theCurrPageNo" name="<%=lstrForm%>" property="currPageNo" type="java.lang.Integer"/> 
<bean:define id="theTotPageSet" name="<%=lstrForm%>" property="totPageSet" type="java.lang.Integer"/> 
<bean:define id="theFirstPageNo" name="<%=lstrForm%>" property="firstPageNo" type="java.lang.Integer"/> 
<bean:define id="thePrevPageNo" name="<%=lstrForm%>" property="prevPageNo" type="java.lang.Integer"/> 
<bean:define id="theNextPageNo" name="<%=lstrForm%>" property="nextPageNo" type="java.lang.Integer"/> 
<bean:define id="theLastPageNo" name="<%=lstrForm%>" property="lastPageNo" type="java.lang.Integer"/> 

<logic:greaterThan name="<%=lstrForm%>" property="totPage" value="1" >
<div class="buttons_box">
<div class="pagination">
Pages:&nbsp;<bean:write name="<%=lstrForm%>" property="totPage"/>&nbsp;&nbsp;
<input type="text" name="txtGoto" maxlength='5' class='txtGoto'/>&nbsp;&nbsp;
<a href="#" onclick="return gotoPage(document.forms[0].txtGoto.value)">Go to Page</a>&nbsp;&nbsp;
<span>
<logic:greaterThan  name="<%=lstrForm%>" property="currPageSet" value="1" >
    <A href="#" onclick="return gotoPage('<%=theFirstPageNo%>')">&lt;&lt;</A>&nbsp;&nbsp;
    <A href="#" onclick="return gotoPage('<%=thePrevPageNo%>')">&lt;</A>&nbsp;&nbsp;
</logic:greaterThan>
<logic:iterate id="linkData" name="<%=lstrForm%>" indexId='ctr' property="allLinks" type="java.lang.String" >
	<bean:define id="thePageNo" name="<%=lstrForm%>" property='<%= "pageLink[" + ctr + "]"%>' type="java.lang.String"/> 
    <logic:equal name="<%=lstrForm%>" property='<%= "pageLink[" + ctr + "]"%>' value="<%=theCurrPageNo.toString()%>">
    <a class="current">
	<bean:write name="<%=lstrForm%>" property='<%= "pageLink[" + ctr + "]"%>'/></a>
    </logic:equal>
    <logic:notEqual name="<%=lstrForm%>" property='<%= "pageLink[" + ctr + "]"%>' value="<%=theCurrPageNo.toString()%>">
    <a href="#" onclick="return gotoPage('<%=thePageNo%>')" ><bean:write name="<%=lstrForm%>" property='<%= "pageLink[" + ctr + "]"%>'/></a>
    </logic:notEqual>
</logic:iterate>
&nbsp;
<logic:lessThan  name="<%=lstrForm%>" property="currPageSet" value="<%=theTotPageSet.toString()%>" >
    <A href="#" onclick="gotoPage('<%=theNextPageNo%>')">&gt;</A>&nbsp;&nbsp;
    <A href="#" onclick="gotoPage('<%=theLastPageNo%>')">&gt;&gt;</A>&nbsp;&nbsp;
</logic:lessThan>
</span>
</div>
</div>
</logic:greaterThan>
<%
}
%>
