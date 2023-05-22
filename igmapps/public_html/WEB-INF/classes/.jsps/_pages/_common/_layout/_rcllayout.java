package _pages._common._layout;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.web.UserAccountBean;
import com.niit.control.common.GlobalConstants;


public class _rcllayout extends com.orionserver.http.OrionHttpJspPage {


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
    PageContext pageContext = JspFactory.getDefaultFactory().getPageContext( this, request, response, "/pages/common/error/error.jsp", true, JspWriter.DEFAULT_BUFFER, true);
    // Note: this is not emitted if the session directive == false
    HttpSession session = pageContext.getSession();
    int __jsp_tag_starteval;
    ServletContext application = pageContext.getServletContext();
    JspWriter out = pageContext.getOut();
    _rcllayout page = this;
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
      out.write(__oracle_jsp_text[7]);
      out.write(__oracle_jsp_text[8]);
      out.write(__oracle_jsp_text[9]);
      out.write(__oracle_jsp_text[10]);
      		
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
          
      
      out.write(__oracle_jsp_text[11]);
      {
        org.apache.struts.taglib.tiles.GetAttributeTag __jsp_taghandler_1=(org.apache.struts.taglib.tiles.GetAttributeTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.GetAttributeTag.class,"org.apache.struts.taglib.tiles.GetAttributeTag name");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setName("title");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[12]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[13]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[14]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[15]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[16]);
      out.print(request.getContextPath());
      out.write(__oracle_jsp_text[17]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[18]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[19]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[20]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[21]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[22]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[23]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm001", pageContext));
      out.write(__oracle_jsp_text[24]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm002", pageContext));
      out.write(__oracle_jsp_text[25]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/seut001", pageContext));
      out.write(__oracle_jsp_text[26]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/openReport", pageContext));
      out.write(__oracle_jsp_text[27]);
      {
        org.apache.struts.taglib.tiles.InsertTag __jsp_taghandler_2=(org.apache.struts.taglib.tiles.InsertTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.InsertTag.class,"org.apache.struts.taglib.tiles.InsertTag attribute");
        __jsp_taghandler_2.setParent(null);
        __jsp_taghandler_2.setAttribute("header");
        __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[28]);
            {
              org.apache.struts.taglib.tiles.PutTag __jsp_taghandler_3=(org.apache.struts.taglib.tiles.PutTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.PutTag.class,"org.apache.struts.taglib.tiles.PutTag name beanName beanScope");
              __jsp_taghandler_3.setParent(__jsp_taghandler_2);
              __jsp_taghandler_3.setName("progId");
              __jsp_taghandler_3.setBeanName("progId");
              __jsp_taghandler_3.setBeanScope("tile");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[29]);
            {
              org.apache.struts.taglib.tiles.PutTag __jsp_taghandler_4=(org.apache.struts.taglib.tiles.PutTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.PutTag.class,"org.apache.struts.taglib.tiles.PutTag name beanName beanScope");
              __jsp_taghandler_4.setParent(__jsp_taghandler_2);
              __jsp_taghandler_4.setName("formId");
              __jsp_taghandler_4.setBeanName("formId");
              __jsp_taghandler_4.setBeanScope("tile");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[30]);
            {
              org.apache.struts.taglib.tiles.PutTag __jsp_taghandler_5=(org.apache.struts.taglib.tiles.PutTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.PutTag.class,"org.apache.struts.taglib.tiles.PutTag name beanName beanScope");
              __jsp_taghandler_5.setParent(__jsp_taghandler_2);
              __jsp_taghandler_5.setName("title");
              __jsp_taghandler_5.setBeanName("title");
              __jsp_taghandler_5.setBeanScope("tile");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[31]);
            {
              org.apache.struts.taglib.tiles.PutTag __jsp_taghandler_6=(org.apache.struts.taglib.tiles.PutTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.PutTag.class,"org.apache.struts.taglib.tiles.PutTag name beanName beanScope");
              __jsp_taghandler_6.setParent(__jsp_taghandler_2);
              __jsp_taghandler_6.setName("screenHeading");
              __jsp_taghandler_6.setBeanName("screenHeading");
              __jsp_taghandler_6.setBeanScope("tile");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[32]);
            {
              org.apache.struts.taglib.tiles.PutTag __jsp_taghandler_7=(org.apache.struts.taglib.tiles.PutTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.PutTag.class,"org.apache.struts.taglib.tiles.PutTag name beanName beanScope");
              __jsp_taghandler_7.setParent(__jsp_taghandler_2);
              __jsp_taghandler_7.setName("screenVersion");
              __jsp_taghandler_7.setBeanName("screenVersion");
              __jsp_taghandler_7.setBeanScope("tile");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[33]);
          } while (__jsp_taghandler_2.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,1);
      }
      out.write(__oracle_jsp_text[34]);
      {
        org.apache.struts.taglib.tiles.InsertTag __jsp_taghandler_8=(org.apache.struts.taglib.tiles.InsertTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.InsertTag.class,"org.apache.struts.taglib.tiles.InsertTag attribute");
        __jsp_taghandler_8.setParent(null);
        __jsp_taghandler_8.setAttribute("body");
        __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
        if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,1);
      }
      out.write(__oracle_jsp_text[35]);
      {
        org.apache.struts.taglib.tiles.InsertTag __jsp_taghandler_9=(org.apache.struts.taglib.tiles.InsertTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.tiles.InsertTag.class,"org.apache.struts.taglib.tiles.InsertTag attribute");
        __jsp_taghandler_9.setParent(null);
        __jsp_taghandler_9.setAttribute("footer");
        __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
        if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,1);
      }
      out.write(__oracle_jsp_text[36]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/openReport",pageContext));
      out.write(__oracle_jsp_text[37]);

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
  private static final char __oracle_jsp_text[][]=new char[38][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[10] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n<HEAD>\r\n    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n    <title>".toCharArray();
    __oracle_jsp_text[12] = 
    "</title>\r\n    <link rel=\"stylesheet\" href=\"".toCharArray();
    __oracle_jsp_text[13] = 
    "/css/NTL.css\"/>\r\n    <link rel=\"stylesheet\" href=\"".toCharArray();
    __oracle_jsp_text[14] = 
    "/css/RCL.css\"/>\r\n    <link rel=\"stylesheet\" href=\"".toCharArray();
    __oracle_jsp_text[15] = 
    "/css/EZL.css\"/>\r\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \r\n    <style type=\"text/css\">\r\n         div.search_result{height:190px;}\r\n         table.table_results tbody{height:190px;}\r\n    </style>\r\n    <!--[if IE]>\r\n        <style type=\"text/css\">\r\n            div.search_result {\r\n                position: relative;\r\n                height: 200px;\r\n                width: 100%;\r\n                overflow-y: scroll;\r\n                overflow-x: hidden;\r\n            }\r\n            table.table_results{width:99%}\r\n           \r\n            table.table_results thead tr {\r\n                position: absolute;width:100%;\r\n                top: expression(this.offsetParent.scrollTop);\r\n            }\r\n            table.table_results tbody {\r\n                height: auto;\r\n            }\r\n            /*table.table_results tbody tr td.first_row {\r\n                padding-top: 24px;}*/}\r\n             table.header{width:99%; }             \r\n        </style>\r\n    <![endif]-->         \r\n    <script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[16] = 
    "/js/front_messages.js\">\r\n\tvar contextPath4Date = \"".toCharArray();
    __oracle_jsp_text[17] = 
    "\";\r\n    </script>\r\n    <script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[18] = 
    "/js/validate.js\"></script>\t\r\n    <script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[19] = 
    "/js/RutMessageBar.js\"></script>\r\n    <script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[20] = 
    "/js/tab.js\"></script>\r\n    <script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[21] = 
    "/js/RutDate.js\"></script>    \r\n    <script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[22] = 
    "/js/jquery.js\"></script>    \r\n</HEAD>\r\n\r\n<SCRIPT type=\"text/javascript\" language=\"JavaScript\">\r\n    \r\n    var aw = screen.availWidth;\r\n    var ah = screen.availHeight;\r\n    var screenWidth = aw-5;\t    \r\n    var screenHeight= ah-54;\r\n    var x = aw>800?(aw-screenWidth)/2:0;\r\n    var y = ah>600?(ah-screenHeight)/2:0;\r\n\r\n    if (window.screen) {\r\n        window.moveTo(x,y) \r\n        window.resizeTo(screenWidth,screenHeight) \r\n    }\r\n    \r\n    \r\n</SCRIPT>\r\n<script type=\"text/javascript\" language=\"JavaScript\">\r\n    var globalobj;\r\n    var currselrowid='row0';\r\n    var size1 = 0;\r\n    var index = -1;\r\n\r\n    /*---------------------------------------------------------------------------------------------------*/\r\n    //Function to highlight the selected row\r\n    function highlightradioTD(rowid) {\r\n        rowobj = document.all(rowid);\r\n        oldrowobj = document.all(currselrowid);\r\n        if (oldrowobj != null) oldrowobj.style.background = \"#FFFFFF\";\r\n        if (rowobj != null) {\r\n            currselrowid = rowid;\r\n            rowobj.style.background = \"#ADC3E7\";\r\n        }\r\n    }\r\n\t//Function to highlight the selected multi-row\r\n    function highlightradioTDMultiRow(rowid) {\r\n        rowobj = document.all(rowid);\r\n        oldrowobj = document.all(currselrowid);\r\n        if (oldrowobj != null) {\r\n\t\t\tfor(var i = 0; i < oldrowobj.length; i++) {\r\n\t\t\t\toldrowobj[i].style.background = \"#FFFFFF\";\r\n\t\t\t}\r\n\t\t}\r\n        if (rowobj != null) {\r\n            currselrowid = rowid;\r\n\t\t\tfor(var i = 0; i < rowobj.length; i++) {\r\n\t\t\t\trowobj[i].style.background = \"#ADC3E7\";\r\n\t\t\t}\r\n        }\r\n    }\r\n    function selRow(radioObj) {\r\n        var rowid = 'row'+radioObj.value;\r\n        highlightradioTD(rowid);\r\n    }\r\n\tfunction selMultiRow(radioObj) {\r\n        var rowid = 'row'+radioObj.value;\r\n        highlightradioTDMultiRow(rowid);\r\n    }\r\n    function getCurrRowId(){\r\n        return currselrowid;\r\n    }\r\n    function getCurrRowNo(){\r\n        return currselrowid.substring(3);\r\n    }\r\n</script>\r\n<script type=\"text/javascript\" language=\"JavaScript\">\r\nvar appCtxPath = '".toCharArray();
    __oracle_jsp_text[23] = 
    "';\r\nvar svcm001Url = '".toCharArray();
    __oracle_jsp_text[24] = 
    "';\r\nvar secm002Url = '".toCharArray();
    __oracle_jsp_text[25] = 
    "';\r\nvar svut001Url = '".toCharArray();
    __oracle_jsp_text[26] = 
    "';\r\nvar reportUrl  = '".toCharArray();
    __oracle_jsp_text[27] = 
    "';\r\n</script>\r\n<BODY onload='javascript:onLoad()' topmargin=\"0\" leftmargin=\"0\" onunload=\"javascript:doCloseAllChilds()\">\r\n    <div id=\"container\">\r\n    <TABLE border=\"0\" width=\"100%\"  cellspacing=\"0\" cellpadding=\"0\">\r\n        <TR>\r\n            <TD>\r\n            ".toCharArray();
    __oracle_jsp_text[28] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[29] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[30] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[31] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[32] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[33] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[34] = 
    "\r\n            </TD>\r\n        </TR>\r\n        <TR>\r\n            <TD>\r\n            ".toCharArray();
    __oracle_jsp_text[35] = 
    "\r\n            </TD>\r\n        </TR>\r\n        <TR>\r\n            <TD>".toCharArray();
    __oracle_jsp_text[36] = 
    "</TD>\r\n        </TR>\t\t\t\r\n    </TABLE>\r\n    </div>\r\n    <FORM name=\"reportForm\" method=\"POST\" action='".toCharArray();
    __oracle_jsp_text[37] = 
    "' target=\"_new\" >\r\n        <INPUT TYPE=\"HIDDEN\" NAME=\"module\" VALUE=\"\" />\r\n        <INPUT TYPE=\"HIDDEN\" NAME=\"screen\" value=\"\" />\r\n        <INPUT TYPE=\"HIDDEN\" NAME=\"report\" value=\"\" />\r\n        <INPUT TYPE=\"HIDDEN\" NAME=\"desformat\" value=\"\" />\r\n        <INPUT TYPE=\"HIDDEN\" NAME=\"reportDetails\" VALUE=\"\" />\r\n        <INPUT TYPE=\"HIDDEN\" NAME=\"hidden_run_parameters\" VALUE=\"\" />\r\n    </FORM>\r\n</BODY>\r\n</HTML>".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
