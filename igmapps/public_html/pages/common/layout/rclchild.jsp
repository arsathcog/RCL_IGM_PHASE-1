<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/niit-html.tld" prefix="niit" %>
<%@ page language="java" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page errorPage="/pages/common/error/error.jsp" %>
<%@ page import="com.niit.control.web.UserAccountBean" %>
<%@ page import="com.niit.control.common.GlobalConstants" %>

<%		
    // TO be removed once Login Page is made
    String lstrUser = null;
    String path = null;
    UserAccountBean account = (UserAccountBean) session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
    if (account == null || account.getUserId() == null || (account.getUserId()).equals("") ) {		
            //path = com.niit.control.web.JSPUtils.getActionMappingURL("/openlogin",pageContext);
            ((HttpServletResponse)pageContext.getResponse()).sendRedirect("/pages/Welcome.jsp");
            return;
    } 
    lstrUser = account.getUserId();
    String lstrCtxPath = request.getContextPath();

%>
<HEAD>
<BASE target= "_self"/>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title><tiles:getAsString name="title"/></title>
    <link rel="stylesheet" href="<%=lstrCtxPath%>/css/NTL.css"/>
    <link rel="stylesheet" href="<%=lstrCtxPath%>/css/RCL.css"/>
    <link rel="stylesheet" href="<%=lstrCtxPath%>/css/EZL.css"/>
    <!--meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7"/--> 
    <style type="text/css">
         div.search_result{height:100px;}
         table.table_results tbody{height:100px;}
    </style>
    <!--[if IE]>
        <style type="text/css">
            div.search_result {
                position: relative;
                height: 100px;
                width: 100%;
                overflow-y: scroll;
                overflow-x: hidden;
            }
            table.table_results{width:99%}
           
            table.table_results thead tr {
                position: absolute;width:100%;
                top: expression(this.offsetParent.scrollTop);
            }
            table.table_results tbody {
                height: auto;
            }
            /*table.table_results tbody tr td.first_row {
                padding-top: 24px;}*/}
             table.header{width:99%; }             
        </style>
    <![endif]-->        
    <script language="JavaScript" src="<%=lstrCtxPath%>/js/front_messages.js">
	var contextPath4Date = "<%=request.getContextPath()%>";
    </script>
    <script language="JavaScript" src="<%=lstrCtxPath%>/js/validate.js"></script>	
    <script language="JavaScript" src="<%=lstrCtxPath%>/js/RutMessageBar.js"></script>
    <script language="JavaScript" src="<%=lstrCtxPath%>/js/tab.js"></script>
    <script language="JavaScript" src="<%=lstrCtxPath%>/js/RutDate.js"></script>    
    <script language="JavaScript" src="<%=lstrCtxPath%>/js/jquery.js"></script>     
</HEAD>

<SCRIPT type="text/javascript" language="JavaScript">
    
    var aw = screen.availWidth;
    var ah = screen.availHeight;    
    
</SCRIPT>
<script type="text/javascript" language="JavaScript">
    var globalobj;
    var currselrowid='row0';
    var size1 = 0;
    var index = -1;
	
	function onLoad(){
		//NA
	}
	
    /*---------------------------------------------------------------------------------------------------*/
    //Function to highlight the selected row
    function highlightradioTD(rowid) {
        rowobj = document.all(rowid);
        oldrowobj = document.all(currselrowid);
        if (oldrowobj != null) oldrowobj.style.background = "#FFFFFF";
        if (rowobj != null) {
            currselrowid = rowid;
            rowobj.style.background = "#ADC3E7";
        }
    }
	//Function to highlight the selected multi-row
    function highlightradioTDMultiRow(rowid) {
        rowobj = document.all(rowid);
        oldrowobj = document.all(currselrowid);
        if (oldrowobj != null) {
			for(var i = 0; i < oldrowobj.length; i++) {
				oldrowobj[i].style.background = "#FFFFFF";
			}
		}
        if (rowobj != null) {
            currselrowid = rowid;
			for(var i = 0; i < rowobj.length; i++) {
				rowobj[i].style.background = "#ADC3E7";
			}
        }
    }
    function selRow(radioObj) {
        var rowid = 'row'+radioObj.value;
        highlightradioTD(rowid);
    }
	function selMultiRow(radioObj) {
        var rowid = 'row'+radioObj.value;
        highlightradioTDMultiRow(rowid);
    }
    function getCurrRowId(){
        return currselrowid;
    }
    function getCurrRowNo(){
        return currselrowid.substring(3);
    }
</script>
<script type="text/javascript" language="JavaScript">
var appCtxPath = '<%=lstrCtxPath%>';
var svcm001Url = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/svcm001", pageContext)%>';
var svcm002Url = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/svcm002", pageContext)%>';
var svut001Url = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/svut001", pageContext)%>';
var reportUrl  = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/openReport", pageContext)%>';
var secm002Url = '<%=com.niit.control.web.JSPUtils.getActionMappingURL("/secm002", pageContext)%>'; 
</script>
<BODY onload='javascript:onLoad()' topmargin="0" leftmargin="0" onunload="javascript:doCloseAllChilds()">
    <div id="container">
    <TABLE border="0" width="100%"  cellspacing="0" cellpadding="0">
        <TR>
            <TD>
            <tiles:insert attribute="header">
            <tiles:put name="progId" beanName="progId" beanScope="tile"  />
            <tiles:put name="formId" beanName="formId" beanScope="tile"  />
            <tiles:put name="title" beanName="title" beanScope="tile"  />
            <tiles:put name="screenHeading" beanName="screenHeading" beanScope="tile"  /> 
            <tiles:put name="screenVersion" beanName="screenVersion" beanScope="tile"  />
            </tiles:insert>
            </TD>
        </TR>
        <TR>
            <TD>
            <tiles:insert attribute='body'/>
            </TD>
        </TR>
        <TR>
            <TD><tiles:insert attribute="footer"/></TD>
        </TR>			
    </TABLE>
    </div>
    <FORM name="reportForm" method="post" action='<%=com.niit.control.web.JSPUtils.getActionMappingURL("/openReport",pageContext)%>' target="_new" >
        <INPUT TYPE="HIDDEN" NAME="module" VALUE="" />
        <INPUT TYPE="HIDDEN" NAME="screen" value="" />
        <INPUT TYPE="HIDDEN" NAME="report" value="" />
        <INPUT TYPE="HIDDEN" NAME="desformat" value="" />
        <INPUT TYPE="HIDDEN" NAME="reportDetails" VALUE="" />
        <INPUT TYPE="HIDDEN" NAME="hidden_run_parameters" VALUE="" />
    </FORM>
</BODY>
</HTML>