package _pages._common._misc;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.web.action.BaseAction;


public class _calendar extends com.orionserver.http.OrionHttpJspPage {


  // ** Begin Declarations


  // ** End Declarations

  public void _jspService(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException, ServletException {

    response.setContentType( "text/html;charset=UTF-8");
    /* set up the intrinsic variables using the pageContext goober:
    ** session = HttpSession
    ** application = ServletContext
    ** out = JspWriter
    ** page = this
    ** config = ServletConfig
    ** all session/app beans declared in globals.jsa
    */
    PageContext pageContext = JspFactory.getDefaultFactory().getPageContext( this, request, response, null, true, JspWriter.DEFAULT_BUFFER, true);
    // Note: this is not emitted if the session directive == false
    HttpSession session = pageContext.getSession();
    int __jsp_tag_starteval;
    ServletContext application = pageContext.getServletContext();
    JspWriter out = pageContext.getOut();
    _calendar page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      
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
      
      out.write(__oracle_jsp_text[3]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[4]);
      out.print(reqFormat);
      out.write(__oracle_jsp_text[5]);
      out.print(_day );
      out.write(__oracle_jsp_text[6]);
      out.print(_month );
      out.write(__oracle_jsp_text[7]);
      out.print(_year );
      out.write(__oracle_jsp_text[8]);
      out.print(_day );
      out.write(__oracle_jsp_text[9]);
      out.print(_month );
      out.write(__oracle_jsp_text[10]);
      out.print(_year );
      out.write(__oracle_jsp_text[11]);

    }
    catch (Throwable e) {
      if (!(e instanceof javax.servlet.jsp.SkipPageException)){
        try {
          if (out != null) out.clear();
        }
        catch (Exception clearException) {
        }
        pageContext.handlePageException(e);
      }
    }
    finally {
      OracleJspRuntime.extraHandlePCFinally(pageContext, true);
      JspFactory.getDefaultFactory().releasePageContext(pageContext);
    }

  }
  private static final char __oracle_jsp_text[][]=new char[12][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n\r\n<html>\r\n<head>\r\n<title>Calendar</title>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\r\n<SCRIPT>\r\nvar isCalledFromApplet = 1;\r\n</SCRIPT>\r\n<SCRIPT language=\"JavaScript\" type=\"text/javascript\" src=\"".toCharArray();
    __oracle_jsp_text[4] = 
    "/js/calendar.js\"></SCRIPT>\r\n<SCRIPT LANGUAGE=\"JavaScript\">\r\n\r\n/**\r\n* Pops up the javascript calendar.\r\n*/\r\nfunction callOnload(){\r\nvar lstrReqFormat = ".toCharArray();
    __oracle_jsp_text[5] = 
    ";\r\n\tif(lstrReqFormat!=null){\r\n\t\tfPopCalendar(document.frmCal.txtCal,document.frmCal.txtCal,'DD/MM/YYYY HH24:MI',".toCharArray();
    __oracle_jsp_text[6] = 
    ",".toCharArray();
    __oracle_jsp_text[7] = 
    ",".toCharArray();
    __oracle_jsp_text[8] = 
    ");\r\n\t}else{\r\nfPopCalendar(document.frmCal.txtCal,document.frmCal.txtCal,'DD/MM/YYYY',".toCharArray();
    __oracle_jsp_text[9] = 
    ",".toCharArray();
    __oracle_jsp_text[10] = 
    ",".toCharArray();
    __oracle_jsp_text[11] = 
    ");\r\n\t}\r\n}\r\n\r\n/**\r\n* Passes the selected date from calendar to parent jsp of the applet.\r\n*/\r\nfunction passDateToJSP(strDate)\r\n{\r\n\tvar opener = window.dialogArguments;\r\n\topener.setDate(document.frmCal.txtCal.value);\r\n}\r\n\r\n</SCRIPT>\r\n</head>\r\n<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\" onLoad = \"callOnload()\">\r\n<form name=\"frmCal\">\r\n<input type=\"hidden\" name=\"txtCal\" value=\"\">\r\n</form>\r\n</body>\r\n</html>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
