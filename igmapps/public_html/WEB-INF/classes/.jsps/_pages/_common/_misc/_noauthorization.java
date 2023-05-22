package _pages._common._misc;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _noauthorization extends com.orionserver.http.OrionHttpJspPage {


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
    _noauthorization page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.print( request.getContextPath() + "/" );
      out.write(__oracle_jsp_text[2]);

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
  private static final char __oracle_jsp_text[][]=new char[3][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n<html>\r\n<head>\r\n<title>VAS - Error Page</title>\r\n\r\n<style type=\"text/css\">\r\n.noframe-framing-table  { background-color: #767776; background-image: none; border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000; border-left: 1px solid #000000; }\r\n.table-text {   font-family: Arial,Helvetica, sans-serif; font-size:70.0%; background-color: #F7F7F7; background-image: none; }\r\n.column-head {  padding-left: .35em; font-family: Arial,Helvetica, sans-serif; font-size: 77.0%; font-weight:bold; text-align: left; color: #FFFFFF; background-color: #8691C7; background-image: none; }\r\n</style>\r\n\r\n</head>\r\n<SCRIPT language=\"JavaScript\">\r\n if (window.screen) {\r\n    var aw = screen.availWidth;\r\n    var ah = screen.availHeight;\r\n    window.moveTo(0, 0);\r\n    window.resizeTo(aw, ah+5);\r\n    window.resizable=0;\r\n  }\r\n\r\n  function doOK(){\r\n     window.close();\r\n  }\r\n\r\n</script>\r\n<BODY  onload=\"javascript:document.all.ok.focus();\">\r\n<form name=\"logonForm\" action='/' method=\"post\">\r\n<table border=0 cellpadding=0 cellspacing=0 width=\"100%\" height=\"100%\"  align=\"center\" >\r\n    <tr>\r\n      <td  >\r\n        <table class=\"noframe-framing-table\" border=0 cellpadding=\"5\" cellspacing=\"0\" width=\"300\" summary=\"Login Table\" align=\"center\">\r\n        <tbody>\r\n          <tr>\r\n            <th colspan=\"2\" class=\"column-head\" scope=\"rowgroup\">Error&nbsp;&nbsp;</th>\r\n          </tr>\r\n          <tr>\r\n          <td valign=top  colspan=\"2\" class=\"table-text\"  nowrap >\r\n            <br>\r\n                <span>\r\n                <img align=\"baseline\" height=\"16\" width=\"16\" src=\"".toCharArray();
    __oracle_jsp_text[2] = 
    "images/imgError.gif\"/>\r\n                &nbsp;&nbsp;&nbsp;Not Authorized for the requested resource.\r\n                </span>\r\n            <br>\r\n            <br>\r\n          </td>\r\n          </tr>\r\n\r\n          <tr>\r\n            <td valign=top  align=\"right\" width='150'>\r\n              <input type=\"button\" name=\"ok\" value='    OK   ' onclick=\"doOK()\">\r\n            </td>\r\n          </tr>\r\n          </tbody>\r\n        </table>\r\n  </tr>\r\n</table>\r\n</body>\r\n</html>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
