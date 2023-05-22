
<%@ page contentType= "text/html;charset=UTF-8" pageEncoding= "UTF-8" %>
<%@ page import="com.niit.control.web.action.BaseAction" %>

<%
System.out.println("Calendar JSP");
String lstrCtxPath = request.getContextPath();
String currentDate2= BaseAction.getReportDate(request);
String reqFormat   = request.getParameter("reqFormat");
System.out.println("currentDate2" +currentDate2);


String disDate2 = currentDate2;
String disDate3 = currentDate2;

int _day = Integer.parseInt(disDate3.substring(0,2));
int _month = Integer.parseInt(disDate3.substring(3,5));
int _year = Integer.parseInt(disDate3.substring(6,10));

int _day3 = Integer.parseInt(disDate2.substring(0,2));
int _month3 = Integer.parseInt(disDate2.substring(3,5));
int _year3 = Integer.parseInt(disDate2.substring(6,10));

out.print("<script>");
out.print("var giYear = "+_year+";");
out.print("var giMonth = "+_month+";");
out.print("var giDay = "+_day+";");
out.print("var _year = "+_year+";");
out.print("var _month = "+_month+";");
out.print("var _day = "+_day+";");

out.print("var _year3 = "+_year3+";");
out.print("var _month3 = "+_month3+";");
out.print("var _day3 = "+_day3+";");




out.print("var _daysOfWeek = new Array('Sun','Mon','Tue','Wed','Thu','Fri','Sat');");
out.print("var _monthsOfYear = new Array('Jan','Feb','Mar','Apr','May','Jun','July','Aug','Sep','Oct','Nov','Dec');");
out.print("var _today = 'Today'");
out.print("</script>");
System.out.println("currentDate3" +currentDate2);
%>

<html>
<head>
<title>Calendar</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<SCRIPT>
var isCalledFromApplet = 1;
</SCRIPT>
<SCRIPT language="JavaScript" type="text/javascript" src="<%=lstrCtxPath%>/js/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">

/**
* Pops up the javascript calendar.
*/
function callOnload(){
var lstrReqFormat = <%=reqFormat%>;
	if(lstrReqFormat!=null){
		fPopCalendar(document.frmCal.txtCal,document.frmCal.txtCal,'DD/MM/YYYY HH24:MI',<%=_day %>,<%=_month %>,<%=_year %>);
	}else{
fPopCalendar(document.frmCal.txtCal,document.frmCal.txtCal,'DD/MM/YYYY',<%=_day %>,<%=_month %>,<%=_year %>);
	}
}

/**
* Passes the selected date from calendar to parent jsp of the applet.
*/
function passDateToJSP(strDate)
{
	var opener = window.dialogArguments;
	opener.setDate(document.frmCal.txtCal.value);
}

</SCRIPT>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad = "callOnload()">
<form name="frmCal">
<input type="hidden" name="txtCal" value="">
</form>
</body>
</html>
