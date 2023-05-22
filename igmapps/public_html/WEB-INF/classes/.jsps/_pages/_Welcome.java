package _pages;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import javax.servlet.http.*;
import com.niit.control.common.*;
import com.niit.control.web.*;
import com.niit.control.web.action.*;
import java.util.Locale;


public class _Welcome extends com.orionserver.http.OrionHttpJspPage {


  // ** Begin Declarations


  // ** End Declarations

  public void _jspService(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException, ServletException {

    response.setContentType( "text/html;charset=windows-1252");
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
    _Welcome page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      out.write(__oracle_jsp_text[3]);
      out.write(__oracle_jsp_text[4]);
      out.write(__oracle_jsp_text[5]);
      out.write(__oracle_jsp_text[6]);
      		
          String lstrCtxPath = request.getContextPath();
          
      
      out.write(__oracle_jsp_text[7]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[8]);

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
  private static final char __oracle_jsp_text[][]=new char[9][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"\n\"http://www.w3.org/TR/html4/loose.dtd\">\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\n\n<html>\n  <head>\n    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\"/>\n    <title>Welcome EZL</title>\n    <style type=\"text/css\">\n      body {\n      background-color: #aabbcc; \n      }\n      a:link { color: #ffee22; }\n    </style>\n  </head>\n  <body>\n  <form name=\"welcome\" method=\"POST\" action=\"".toCharArray();
    __oracle_jsp_text[8] = 
    "/pages/DummyMenu.jsp\">\n  <div align='center'>\n  <p>\n  <b>RCL - EZY LOAD LIST APPLICATION</b>\n  </p>\n  <BR>\n  <BR>\n  </div>\n  <div align='center'>\n  <table border=\"1\" cellspacing=\"0\" cellpadding=\"0\" width=\"300\">\n  <tr>\n\t<td>User ID :</td>\n\t<td>\n\t<select name=\"userid\" size=\"1\">\n\t\t<option value=\"NIIT01\">Principal User(Admin)</option>\n\t\t<option value=\"EDLOPR\">Discharge List Operator</option>\n\t\t<option value=\"EDLMGR\">Discharge List Manager</option>\n\t</td>\n  </tr>\n  </table>\n  </p>\n  <table border=\"1\" cellspacing=\"0\" cellpadding=\"0\" width=\"250\">\n  <tr>\n  <td>\n  <input type=\"submit\" value=\" OK \"/>\n  </td>\n  </tr>  \n  </table>\n  </div>\n  </form>\n  </body>\n</html>".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
