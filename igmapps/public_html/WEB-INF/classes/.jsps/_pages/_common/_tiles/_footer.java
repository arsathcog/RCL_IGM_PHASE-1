package _pages._common._tiles;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _footer extends com.orionserver.http.OrionHttpJspPage {


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
    _footer page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      
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
      
      
      out.write(__oracle_jsp_text[3]);
      out.write(__oracle_jsp_text[4]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[5]);
      {
        com.niit.control.web.tag.ErrorMsgTag __jsp_taghandler_1=(com.niit.control.web.tag.ErrorMsgTag)OracleJspRuntime.getTagHandler(pageContext,com.niit.control.web.tag.ErrorMsgTag.class,"com.niit.control.web.tag.ErrorMsgTag");
        __jsp_taghandler_1.setParent(null);
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[6]);

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
  private static final char __oracle_jsp_text[][]=new char[7][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n<p>&nbsp;</p>\r\n<script>\r\nif (!document.layers) {\r\n\tdocument.write('<div id=\"divStayTopLeft\" style=\"position:absolute\">')\r\n}\r\n</script>\r\n<layer id=\"divStayTopLeft\" style=\"visibility:hidden;\">\r\n    <table border=\"0\" width=\"100%\" cellspacing=\"1\" cellpadding=\"4\">\r\n    <tr>\r\n        <td width=\"3%\" bgcolor=\"#D4D0C8\" >\r\n            <p align=\"center\">\r\n            <img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[5] = 
    "/images/imgError.gif\" width=\"16\" height=\"16\">\r\n        </td>\r\n        <td width=\"97%\" bgcolor=\"#D4D0C8\" valign=\"middle\" align=\"left\" id=\"messagetd\" style=\"font-family:Verdana;font-size:8pt;\">\r\n            <p align=\"left\">\r\n            <div id='msg'>\r\n            ".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n            </div>\r\n        </td>\r\n    </tr>\r\n    </table>\r\n</layer>\r\n<script type=\"text/javascript\">\r\n\r\n    //Enter \"frombottom\" or \"fromtop\"\r\n    var verticalpos = \"frombottom\"\r\n\r\n    if (!document.layers) {\r\n        document.write('</div>')\r\n\t}\r\n\r\n    JSFX_FloatTopDiv();\r\n\t\r\n</script>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
