package _pages._common._error;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _error extends com.orionserver.http.OrionHttpJspPage {


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
    _error page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);
    Throwable exception = (Throwable) request.getAttribute(PageContext.EXCEPTION);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      out.write(__oracle_jsp_text[3]);
      {
        org.apache.struts.taglib.html.ErrorsTag __jsp_taghandler_1=(org.apache.struts.taglib.html.ErrorsTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.ErrorsTag.class,"org.apache.struts.taglib.html.ErrorsTag");
        __jsp_taghandler_1.setParent(null);
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[4]);
      
      							java.io.PrintWriter pw = new java.io.PrintWriter(out);
      							if(exception!=null)
      							{
      								exception.printStackTrace(pw);
      							}
      							String str =(String) 
      									request.getAttribute("STACKTRACE");
      							if(str != null)
      							{ 
      							
      out.write(__oracle_jsp_text[5]);
      out.print(str);
      out.write(__oracle_jsp_text[6]);
      
      							}
      						
      out.write(__oracle_jsp_text[7]);
      
      java.util.Enumeration enum1 = request.getParameterNames();
      while (enum1.hasMoreElements()) {
      	String name = (String)enum1.nextElement();
      
      out.write(__oracle_jsp_text[8]);
      out.print(name);
      out.write(__oracle_jsp_text[9]);
      out.print(request.getParameter(name));
      out.write(__oracle_jsp_text[10]);
      	
      }
      
      out.write(__oracle_jsp_text[11]);
      
      enum1 = request.getAttributeNames();
      while (enum1.hasMoreElements()) {
      	String name = (String)enum1.nextElement();
      
      out.write(__oracle_jsp_text[12]);
      out.print(name);
      out.write(__oracle_jsp_text[13]);
      out.print(request.getAttribute(name));
      out.write(__oracle_jsp_text[14]);
      	
      }
      
      out.write(__oracle_jsp_text[15]);
      out.print(session.getId());
      out.write(__oracle_jsp_text[16]);
      
      enum1 = session.getAttributeNames();
      while (enum1.hasMoreElements()) {
      	String name = (String)enum1.nextElement();
      
      out.write(__oracle_jsp_text[17]);
      out.print(name);
      out.write(__oracle_jsp_text[18]);
      out.print(session.getAttribute(name));
      out.write(__oracle_jsp_text[19]);
      	
      }
      
      out.write(__oracle_jsp_text[20]);
      
      String[] arr= session.getValueNames();
      for(int i = 0; i<arr.length; i++){
      
      out.write(__oracle_jsp_text[21]);
      out.print(arr[i]);
      out.write(__oracle_jsp_text[22]);
      out.print(session.getValue(arr[i]));
      out.write(__oracle_jsp_text[23]);
      	
      }
      
      out.write(__oracle_jsp_text[24]);

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
  private static final char __oracle_jsp_text[][]=new char[25][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<html></html>\r\n<html>\r\n<body></body>\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n\r\n<body bgcolor=\"#e6c8c8\">\r\n<b><font color=\"#6666ff\">EXCEPTION DETECTED</font></b>\r\n<br />\r\n<div style=\"width: 800; height: 300; overflow: auto;\" id=\"temp1\">\r\n<TABLE border=\"1\">\r\n\t<TBODY>\r\n\t\t<TR>\r\n\t\t\t<TD bgcolor=\"#f8f0f0\">\r\n\t\t\t".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n\t\t\t</TD>\r\n\t\t\t<TD bgcolor=\"#f8f0f0\" width=\"530\">\r\n\t\t\t\t<font color=\"#ff0000\" face=\"Arial\" size=\"1\"> ".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[7] = 
    " \r\n\t\t\t\t</font>\r\n\t\t\t</TD>\r\n\t\t</TR>\r\n\t</TBODY>\r\n</TABLE>\r\n</div>\r\n<br/>\r\n<hr />\r\n<br/>\r\n<font color=\"#6666ff\" size=\"2\">\r\n<b>==========REQUEST DUMP BEGINS=========</b>\r\n<br />\r\n<div style=\"width: 800; height: 300; overflow: auto;\" id=\"temp\">\r\n<TABLE border=\"1\" bgcolor=\"#f8f0f0\" width=\"743\">\r\n\t<TBODY>\r\n\t\t<TR>\r\n\t\t\t<TD width=\"247\"><B>Request Parameters:</B></TD>\r\n\t\t\t<TD width=\"488\"></TD>\r\n\t\t</TR>\r\n\t\t".toCharArray();
    __oracle_jsp_text[8] = 
    "\r\n\t\t<TR>\r\n\t\t\t<TD width=\"247\">".toCharArray();
    __oracle_jsp_text[9] = 
    "</TD>\r\n\t\t\t<TD width=\"488\">".toCharArray();
    __oracle_jsp_text[10] = 
    "</TD>\r\n\t\t</TR>\r\n\t\t".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n\r\n\t\t<TR>\r\n\t\t\t<TD width=\"247\"></TD>\r\n\t\t\t<TD width=\"488\"></TD>\r\n\t\t</TR>\r\n\t\t\r\n\t\t<TR>\r\n\t\t\t<TD width=\"247\"><B>Request Attributes:</B></TD>\r\n\t\t\t<TD width=\"488\"></TD>\r\n\t\t</TR>\r\n".toCharArray();
    __oracle_jsp_text[12] = 
    "\r\n\t\t<TR>\r\n\t\t\t<TD width=\"247\">".toCharArray();
    __oracle_jsp_text[13] = 
    "</TD>\r\n\t\t\t<TD width=\"488\">".toCharArray();
    __oracle_jsp_text[14] = 
    "</TD>\r\n\t\t</TR>\r\n\t\t".toCharArray();
    __oracle_jsp_text[15] = 
    "\r\n\t</TBODY>\r\n</TABLE>\r\n</div>\r\n<br></br>\r\n<b><font color=\"#6666ff\">==========REQUEST DUMP ENDS=========</font></b>\r\n<br />\r\n<hr />\r\n<b><font color=\"#6666ff\"><BR>\r\n==========SESSION DUMP BEGINS=========</font></b>\r\n<br />\r\n<div style=\"width: 800; height: 170; overflow: auto;\" id=\"temp2\">\r\n<table border=\"1\" bgcolor=\"#f8f0f0\" width=\"742\">\r\n\t<tbody>\r\n\t\t<tr>\r\n\t\t\t<td width=\"244\"><B>Session Id</B></td>\r\n\t\t\t<td width=\"490\">".toCharArray();
    __oracle_jsp_text[16] = 
    "</td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td width=\"244\"></td>\r\n\t\t\t<td width=\"490\"></td>\r\n\t\t</tr>\r\n\t\t<tr>\r\n\t\t\t<td width=\"244\"><B>Session Attributes:</B></td>\r\n\t\t\t<td width=\"490\"></td>\r\n\t\t</tr>\r\n\r\n\t\t".toCharArray();
    __oracle_jsp_text[17] = 
    "\r\n\t\t<tr>\r\n\t\t\t<td width=\"244\">".toCharArray();
    __oracle_jsp_text[18] = 
    "</td>\r\n\t\t\t<td width=\"490\">".toCharArray();
    __oracle_jsp_text[19] = 
    "</td>\r\n\t\t</tr>\r\n\t\t".toCharArray();
    __oracle_jsp_text[20] = 
    "\r\n\t\t<br />\r\n\r\n\t\t<tr>\r\n\t\t\t<td width=\"244\"></td>\r\n\t\t\t<td width=\"490\"></td>\r\n\t\t</tr>\r\n\r\n\t\t<tr>\r\n\t\t\t<td width=\"244\"><B>Session Values:</B></td>\r\n\t\t\t<td width=\"490\"></td>\r\n\t\t</tr>\r\n\t\t".toCharArray();
    __oracle_jsp_text[21] = 
    "\r\n\t\t<tr>\r\n\t\t\t<td width=\"244\">".toCharArray();
    __oracle_jsp_text[22] = 
    "</td>\r\n\t\t\t<td width=\"490\">".toCharArray();
    __oracle_jsp_text[23] = 
    "</td>\r\n\t\t</tr>\r\n\t\t".toCharArray();
    __oracle_jsp_text[24] = 
    "\r\n\t</tbody>\r\n</table>\r\n</div>\r\n<br />\r\n<b><font color=\"#6666ff\">==========SESSION DUMP ENDS=========</font></b>\r\n</font>\r\n</body>\r\n</html>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
