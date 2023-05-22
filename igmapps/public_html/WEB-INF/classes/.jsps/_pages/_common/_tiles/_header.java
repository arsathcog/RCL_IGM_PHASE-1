package _pages._common._tiles;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;
import com.niit.control.web.action.BaseAction;
import com.niit.control.web.*;


public class _header extends com.orionserver.http.OrionHttpJspPage {


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
    _header page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      out.write(__oracle_jsp_text[3]);
      out.write(__oracle_jsp_text[4]);
      {
        org.apache.struts.taglib.tiles.UseAttributeTag __jsp_taghandler_1=(org.apache.struts.taglib.tiles.UseAttributeTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.UseAttributeTag.class,"org.apache.struts.taglib.tiles.UseAttributeTag id name");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setId("lstrProgID");
        __jsp_taghandler_1.setName("progId");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      java.lang.Object lstrProgID = null;
      lstrProgID = (java.lang.Object) pageContext.findAttribute("lstrProgID");
      out.write(__oracle_jsp_text[5]);
      {
        org.apache.struts.taglib.tiles.UseAttributeTag __jsp_taghandler_2=(org.apache.struts.taglib.tiles.UseAttributeTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.UseAttributeTag.class,"org.apache.struts.taglib.tiles.UseAttributeTag id name");
        __jsp_taghandler_2.setParent(null);
        __jsp_taghandler_2.setId("lstrFormBeanID");
        __jsp_taghandler_2.setName("formId");
        __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
        if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,1);
      }
      java.lang.Object lstrFormBeanID = null;
      lstrFormBeanID = (java.lang.Object) pageContext.findAttribute("lstrFormBeanID");
      out.write(__oracle_jsp_text[6]);
      {
        org.apache.struts.taglib.tiles.UseAttributeTag __jsp_taghandler_3=(org.apache.struts.taglib.tiles.UseAttributeTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.UseAttributeTag.class,"org.apache.struts.taglib.tiles.UseAttributeTag id name");
        __jsp_taghandler_3.setParent(null);
        __jsp_taghandler_3.setId("lstrScrTitle");
        __jsp_taghandler_3.setName("title");
        __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
        if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,1);
      }
      java.lang.Object lstrScrTitle = null;
      lstrScrTitle = (java.lang.Object) pageContext.findAttribute("lstrScrTitle");
      out.write(__oracle_jsp_text[7]);
      {
        org.apache.struts.taglib.tiles.UseAttributeTag __jsp_taghandler_4=(org.apache.struts.taglib.tiles.UseAttributeTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.UseAttributeTag.class,"org.apache.struts.taglib.tiles.UseAttributeTag id name");
        __jsp_taghandler_4.setParent(null);
        __jsp_taghandler_4.setId("lstrScreenHeading");
        __jsp_taghandler_4.setName("screenHeading");
        __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
        if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,1);
      }
      java.lang.Object lstrScreenHeading = null;
      lstrScreenHeading = (java.lang.Object) pageContext.findAttribute("lstrScreenHeading");
      out.write(__oracle_jsp_text[8]);
      {
        org.apache.struts.taglib.tiles.UseAttributeTag __jsp_taghandler_5=(org.apache.struts.taglib.tiles.UseAttributeTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.UseAttributeTag.class,"org.apache.struts.taglib.tiles.UseAttributeTag id name");
        __jsp_taghandler_5.setParent(null);
        __jsp_taghandler_5.setId("lstrScreenVersion");
        __jsp_taghandler_5.setName("screenVersion");
        __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
        if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,1);
      }
      java.lang.Object lstrScreenVersion = null;
      lstrScreenVersion = (java.lang.Object) pageContext.findAttribute("lstrScreenVersion");
      out.write(__oracle_jsp_text[9]);
      {
        org.apache.struts.taglib.bean.DefineTag __jsp_taghandler_6=(org.apache.struts.taglib.bean.DefineTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.DefineTag.class,"org.apache.struts.taglib.bean.DefineTag id name property type");
        __jsp_taghandler_6.setParent(null);
        __jsp_taghandler_6.setId("hasBack");
        __jsp_taghandler_6.setName(OracleJspRuntime.toStr( lstrFormBeanID));
        __jsp_taghandler_6.setProperty("backVisible");
        __jsp_taghandler_6.setType("java.lang.Boolean");
        __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
        if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,1);
      }
      java.lang.Boolean hasBack = null;
      hasBack = (java.lang.Boolean) pageContext.findAttribute("hasBack");
      out.write(__oracle_jsp_text[10]);
      {
        org.apache.struts.taglib.bean.DefineTag __jsp_taghandler_7=(org.apache.struts.taglib.bean.DefineTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.DefineTag.class,"org.apache.struts.taglib.bean.DefineTag id name property type");
        __jsp_taghandler_7.setParent(null);
        __jsp_taghandler_7.setId("hasRefresh");
        __jsp_taghandler_7.setName(OracleJspRuntime.toStr( lstrFormBeanID));
        __jsp_taghandler_7.setProperty("refreshVisible");
        __jsp_taghandler_7.setType("java.lang.Boolean");
        __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
        if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,1);
      }
      java.lang.Boolean hasRefresh = null;
      hasRefresh = (java.lang.Boolean) pageContext.findAttribute("hasRefresh");
      out.write(__oracle_jsp_text[11]);
      {
        org.apache.struts.taglib.bean.DefineTag __jsp_taghandler_8=(org.apache.struts.taglib.bean.DefineTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.DefineTag.class,"org.apache.struts.taglib.bean.DefineTag id name property type");
        __jsp_taghandler_8.setParent(null);
        __jsp_taghandler_8.setId("hasSave");
        __jsp_taghandler_8.setName(OracleJspRuntime.toStr( lstrFormBeanID));
        __jsp_taghandler_8.setProperty("saveVisible");
        __jsp_taghandler_8.setType("java.lang.Boolean");
        __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
        if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,1);
      }
      java.lang.Boolean hasSave = null;
      hasSave = (java.lang.Boolean) pageContext.findAttribute("hasSave");
      out.write(__oracle_jsp_text[12]);
      
      System.out.println("-------hasBack-----------"+hasBack);
      String lstrCtxPath = request.getContextPath();
      UserAccountBean account=(UserAccountBean)session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
      
      out.write(__oracle_jsp_text[13]);
      out.print(account.getFscAccessLevels());
      out.write(__oracle_jsp_text[14]);
      out.print(lstrScreenHeading);
      out.write(__oracle_jsp_text[15]);
      out.print(account.getUserName()+" ("+account.getUserId()+")");
      out.write(__oracle_jsp_text[16]);
      out.print(account.getUserFsc());
      out.write(__oracle_jsp_text[17]);
      out.print(account.getFscAccessLevels());
      out.write(__oracle_jsp_text[18]);
      out.print(account.getDateFormat());
      out.write(__oracle_jsp_text[19]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[20]);
      if (hasBack) {
      out.write(__oracle_jsp_text[21]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[22]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[23]);
      }
      out.write(__oracle_jsp_text[24]);
      if (hasRefresh) {
      out.write(__oracle_jsp_text[25]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[26]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[27]);
      }
      out.write(__oracle_jsp_text[28]);
      if (hasSave) {
      out.write(__oracle_jsp_text[29]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[30]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[31]);
      }
      out.write(__oracle_jsp_text[32]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[33]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[34]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[35]);
      out.print(lstrScreenVersion);
      out.write(__oracle_jsp_text[36]);

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
  private static final char __oracle_jsp_text[][]=new char[37][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n\r\n<!--style href>\r\na {\r\n    text-decoration: none\r\n  }\r\n</style-->\r\n\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[10] = 
    " \r\n".toCharArray();
    __oracle_jsp_text[11] = 
    " \r\n".toCharArray();
    __oracle_jsp_text[12] = 
    " \r\n\r\n".toCharArray();
    __oracle_jsp_text[13] = 
    "\r\n<script type=\"text/javascript\" language=\"JavaScript\">\r\nvar fscAccessLevels = '".toCharArray();
    __oracle_jsp_text[14] = 
    "';\r\nvar allVals = fscAccessLevels.split(\"/\");\r\nfunction getLine(){\r\n\treturn allVals[0];\r\n}\r\nfunction getTrade(){\r\n\treturn allVals[1];\r\n}\r\nfunction getAgent(){\r\n\treturn allVals[2];\r\n}\r\n</script>\r\n<div class=\"page_title\">\r\n<table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\r\n<tr>\r\n    <td width=\"40%\" class=\"PageTitle\">".toCharArray();
    __oracle_jsp_text[15] = 
    "</td>\r\n    <td width=\"60%\" class=\"PageTitleRight\">\r\n        <table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\r\n        <tr>\r\n            <td width=\"15%\" valign=\"middle\" align=\"right\"><font size=\"1\" face=\"Verdana\" color=\"#FFFFFF\"></font></td>\r\n            <td width=\"70%\" valign=\"middle\" align=\"right\"><font size=\"1\" face=\"Verdana\" color=\"#FFFFFF\">".toCharArray();
    __oracle_jsp_text[16] = 
    "-&nbsp;".toCharArray();
    __oracle_jsp_text[17] = 
    "&nbsp;-&nbsp;".toCharArray();
    __oracle_jsp_text[18] = 
    "&nbsp;".toCharArray();
    __oracle_jsp_text[19] = 
    "</font></td>\r\n            <td valign=\"middle\" align=\"left\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[20] = 
    "/images/imgDivider.gif\" height=\"20\"></td>\r\n            ".toCharArray();
    __oracle_jsp_text[21] = 
    "\t\t\r\n                <td valign=\"middle\" align=\"right\">\r\n                    <a href=\"javascript:onBack();\"><img border=\"0\" alt=\"Back\" src=\"".toCharArray();
    __oracle_jsp_text[22] = 
    "/images/btnBack.jpg\"></a>\r\n                </td>\r\n                <td valign=\"middle\" align=\"center\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[23] = 
    "/images/imgDivider.gif\" height=\"20\"></td>\r\n            ".toCharArray();
    __oracle_jsp_text[24] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[25] = 
    "\r\n                <td valign=\"middle\" align=\"right\">\r\n                    <a href=\"javascript:onResetForm();\"><img border=\"0\" alt=\"Refresh\" src=\"".toCharArray();
    __oracle_jsp_text[26] = 
    "/images/btnRefresh.jpg\"></a>\r\n                </td>\r\n                <td valign=\"middle\" align=\"center\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[27] = 
    "/images/imgDivider.gif\" height=\"20\"></td>\r\n            ".toCharArray();
    __oracle_jsp_text[28] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[29] = 
    "\r\n                <td valign=\"middle\" align=\"right\">\r\n                    <a href=\"javascript:onSave();\"><img border=\"0\" alt=\"Save\" src=\"".toCharArray();
    __oracle_jsp_text[30] = 
    "/images/btnSave.jpg\"></a>\r\n                </td>\r\n                <td valign=\"middle\" align=\"center\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[31] = 
    "/images/imgDivider.gif\" height=\"20\"></td>\r\n            ".toCharArray();
    __oracle_jsp_text[32] = 
    "\r\n            <td width=\"50\" valign=\"middle\" align=\"center\"><a href=\"javascript:openHelp()\"><img border=\"0\" alt=\"Help\" src=\"".toCharArray();
    __oracle_jsp_text[33] = 
    "/images/btnHelp.jpg\" width=\"40\" height=\"16\"></a></td>\r\n            <td width=\"6\" valign=\"middle\" align=\"center\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[34] = 
    "/images/imgDivider.gif\" width=\"12\" height=\"20\"></td>\t\t\t\t\t\t\r\n            <td width=\"2%\"><a href=\"javascript:window.close()\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[35] = 
    "/images/btnClose.gif\" alt=\"Close\" width=\"16\" height=\"16\"></a></td>       \r\n        </tr>\r\n        </table>                                \r\n    </td>\r\n</tr>\r\n</table>\r\n</div>\r\n<div class=\"page_info\">\r\n<span>".toCharArray();
    __oracle_jsp_text[36] = 
    "&nbsp;&nbsp;</span>\r\n</div>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
