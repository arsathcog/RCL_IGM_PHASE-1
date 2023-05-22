package _pages._ecm;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _EcmENoticeServiceMaintenanceScn extends com.orionserver.http.OrionHttpJspPage {


  // ** Begin Declarations


  // ** End Declarations

  public void _jspService(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException, ServletException {

    response.setContentType( "text/html");
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
    _EcmENoticeServiceMaintenanceScn page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
       
              String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
      	String mstrStatus = (String) request.getParameter("deamonStatus");
              
      	String status = null;
              
      	if("true".equals(mstrStatus)) {
                  status = "Running";
      	} else if("false".equals(mstrStatus)){
                  status = "Stopped";
      	} else {
                  status = "";
              }
              
      	out.println("Current E-Notice Service Status :: " + status);
      
      out.write(__oracle_jsp_text[1]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm010", pageContext));
      out.write(__oracle_jsp_text[2]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm010", pageContext));
      out.write(__oracle_jsp_text[3]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm010", pageContext));
      out.write(__oracle_jsp_text[4]);

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
  private static final char __oracle_jsp_text[][]=new char[5][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<B><FONT ALIGN=\"CENTER\">Welcome to maintain E-Notice service.</FONT><B><BR><BR>\n\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\n\n<HEAD>\n    \n    <SCRIPT language=\"JavaScript\">\n\t\t\n\t\tfunction onLoad() {\n\t\t\n\t\t}\n\t\t\n        function startMailService()\n        { \n             document.forms[0].SERVICE_TYPE.value = \"START\";\n             \n             var urlString = '".toCharArray();
    __oracle_jsp_text[2] = 
    "';\n             document.forms[0].action=urlString;        \n             document.forms[0].submit(); \n             return false;\n        }\n\n        function stopMailService()\n        {\n            document.forms[0].SERVICE_TYPE.value = \"STOP\";        \n            var urlString = '".toCharArray();
    __oracle_jsp_text[3] = 
    "';\n            document.forms[0].action=urlString;        \n            document.forms[0].submit(); \n            return false;    \n        }\n\t\t\n        function inquireStatus()\n        {\n            document.forms[0].SERVICE_TYPE.value = \"INQUIRY\";        \n            var urlString = '".toCharArray();
    __oracle_jsp_text[4] = 
    "';\n            document.forms[0].action=urlString;        \n            document.forms[0].submit(); \n            return;\n        }\n        \n    </SCRIPT>\n</HEAD>\n\n<BODY>\n    <form METHOD=\"POST\" ACTION=\"/secm010\">\n\n        <input type=\"hidden\" name=\"PAGE_URL\" value=\"/do/secm010\">    \n        <input type=\"hidden\" name=\"SERVICE_TYPE\" value=\"\">\n\n         <div class=\"buttons_box\">\t\t\n                <input type=\"button\" name=\"Start\" class=\"event_btnbutton\" value=\"Start\" onclick=\"startMailService()\">\n\t\t<input type=\"button\" name=\"Stop\" class=\"event_btnbutton\" value=\"Stop\" onclick=\"stopMailService()\">\n\t\t<input type=\"button\" name=\"Inquire Status\" value=\"Inquire Status\" class=\"event_btnbutton\" onclick=\"inquireStatus()\">\n        </div>   \n    </form> \n</BODY>".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
