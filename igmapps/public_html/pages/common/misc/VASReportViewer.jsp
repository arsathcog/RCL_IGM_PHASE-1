<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@ page import="com.niit.control.common.Debug"%>
<%@ page import="com.niit.control.common.GlobalConstants"%>
<%@ page import="com.niit.control.common.StringUtil"%>
<%@ page import="com.niit.control.web.action.BaseAction"%>
<%@ page import="com.rclgroup.dolphin.ezl.resource.ReportParams"%>

<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control", "no-cache"); 
response.setHeader("Cache-Control", "no-store"); 
response.setDateHeader ("Expires", -1);
%>

<%
String strReportServerUrl = BaseAction.getReportServerUrl(request);//application.getInitParameter("ReportServerUrl");
String strReportServerEnv = BaseAction.getReportServerEnv(request);//application.getInitParameter("ReportServerEnv");
/* Example URL *
String strServerURL = "http://dory-cs.rclgroup.com:4444/reports/rwservlet?vasrepenv";
*/
String strServerURL = strReportServerUrl + "?" + strReportServerEnv;
String strFinalParam= GlobalConstants.BLANK;
Debug.logFramework("strServerURL="+strServerURL);
String strModule    = request.getParameter("module"); ;
String strScreenId  = request.getParameter("screen"); ;
String strReportNm  = request.getParameter("report"); ;
String strDesformat = request.getParameter("desformat"); ;
String strRptDetails= request.getParameter("reportDetails"); ;
Debug.logFramework("VAS Reports Viewer Starts...");
int intTotParam       = 0;
String[] arrRptParams = ReportParams.getReportParams(strReportNm);

String strRptDate   = BaseAction.getFullDate(request);
String strUserId    = BaseAction.getUserID(request);;
        
if (strUserId == null) {
    Debug.logFramework("**UAB null Moving to Error Page");
    getServletConfig().getServletContext().getRequestDispatcher(GlobalConstants.NO_SESSION_PATH).forward(request,response);
    return;
}        

if (strRptDetails == null) {
    strRptDetails = GlobalConstants.BLANK;
}
Debug.logFramework("strModule=" + strModule);
Debug.logFramework("strScreenId=" + strScreenId);
Debug.logFramework("strReportNm=" + strReportNm);
Debug.logFramework("strDesformat=" + strDesformat);
Debug.logFramework("strRptDetails=" + strRptDetails);
try{
    String[] arrRptData = StringUtil.extractTokensWithSpaces(strRptDetails,GlobalConstants.HASH);
    Debug.logFramework("arrRptData" + arrRptData);
    Debug.logFramework("arrRptData[0]" + arrRptData[0]);
    intTotParam = Integer.parseInt(arrRptData[0]);
    Debug.logFramework("intTotParam=" + intTotParam);
    /* First Param Code is always report Date */
    strFinalParam = "&report="+strReportNm+"&desformat="+strDesformat+"&"+arrRptParams[0]+"="+strRptDate;
    Debug.logFramework("strFinalParam-1=" + strFinalParam);
    /* Create the other parameters came from screen */
    for (int lintCtr = 1; lintCtr <= intTotParam; lintCtr++){
        //create "param code + Value" url...
         strFinalParam = strFinalParam + "&" + arrRptParams[lintCtr] + "=" + arrRptData[lintCtr];
    }
    Debug.logFramework("strFinalParam-2=" + strFinalParam);
    request.setAttribute("hidden_run_parameters",response.encodeRedirectURL(strFinalParam));
    
    //forward to report server...
    //request.getRequestDispatcher(response.encodeRedirectURL(strServerURL)).forward(request,response);
    response.sendRedirect(response.encodeRedirectURL(strServerURL+strFinalParam));
}catch(Exception ex){
    Debug.logFramework(ex);
    getServletConfig().getServletContext().getRequestDispatcher(GlobalConstants.ERROR_PATH).forward(request,response);
}finally{
    Debug.logFramework("VAS Reports Viewer Ended...");
}

%>