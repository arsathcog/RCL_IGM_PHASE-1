package _pages._edl;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;
import com.niit.control.web.action.BaseAction;
import com.niit.control.web.*;
import com.niit.control.common.*;


public class _EdlExcelUploadScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EdlExcelUploadScn page = this;
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
          UserAccountBean account=(UserAccountBean)session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
          String lstrUserId = account.getUserId();
      
      out.write(__oracle_jsp_text[7]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[8]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl009upload", pageContext));
      out.write(__oracle_jsp_text[9]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action enctype method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/sedl009upload");
        __jsp_taghandler_1.setEnctype("multipart/form-data");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[10]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setName("fedl009");
              __jsp_taghandler_2.setProperty("screenName");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[11]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_3=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setName("fedl009");
              __jsp_taghandler_3.setProperty("prmObject");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[12]);
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.html.FileTag __jsp_taghandler_4=(org.apache.struts.taglib.html.FileTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FileTag.class,"org.apache.struts.taglib.html.FileTag name onkeydown property style styleClass");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fedl009");
              __jsp_taghandler_4.setOnkeydown("this.blur();");
              __jsp_taghandler_4.setProperty("filePath");
              __jsp_taghandler_4.setStyle("width:97%;height:18px");
              __jsp_taghandler_4.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[14]);
            out.write(__oracle_jsp_text[15]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[16]);

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
  private static final char __oracle_jsp_text[][]=new char[17][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n<HTML xmlns=\"http://www.w3.org/1999/xhtml\">\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\r\n<HEAD>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n<TITLE> </TITLE>\r\n\r\n    <LINK REL=\"stylesheet\" HREF=\"".toCharArray();
    __oracle_jsp_text[8] = 
    "/css/EZL.css\"/>\r\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \r\n    <STYLE TYPE=\"text/css\">\r\n         div.search_result{height:100px;}\r\n         table.table_results tbody{height:100px;}\r\n    </STYLE>\r\n\r\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\r\n    var FORM_ID       = 'fedl009';\r\n    var currselrowid  = 'row0';\r\n \r\n    /*Called by framework on-load of this JSP*/\r\n    function onLoad() {  \r\n    \r\n    }\r\n    \r\n    /*Called by framework for help*/\r\n    function openHelp(){\r\n        var strFileName = '1';\r\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\r\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\r\n        objWindow.focus();\r\n    }\r\n\r\n    /*Called on upload button*/\r\n    function onUpload() {\r\n        /*Get the upload file path */\r\n        var fPath      = document.forms[0].filePath.value;\r\n        /*check whether file is selected for upload*/\r\n        if (fPath == null || fPath == \"\") {\r\n            showBarMessage(ECM_GE0023,ERROR_MSG);\r\n            return false;\r\n        }\r\n        /*Extract the file name*/\r\n        var fName      = fPath.substring(fPath.lastIndexOf('\\\\') + 1);\r\n        var temp = fName.replace(' ','');\r\n        /*Extract the file extension*/\r\n        var fExt       = fName.substring(fName.lastIndexOf('.'));\r\n            \r\n        var upperCaseFExt  = fExt.toUpperCase();\r\n        // check for executable file    \r\n        if( upperCaseFExt != '.XLS'){\r\n            showBarMessage(ECM_GE0009,ERROR_MSG);\r\n            return;\r\n        }\r\n        /*XLS File Name Validation */\r\n        if(temp.length==0){\r\n            showBarMessage(ECM_GE0009,ERROR_MSG);\r\n            return;\r\n        }\r\n        // check for the length of file name\r\n        if ( fName.length > 50 ){ \r\n            showBarMessage(ECM_GE0018,ERROR_MSG);\r\n            return;\r\n        }\r\n\r\n        /* Disable all controls */\r\n        disableOnSubmit();                \r\n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[9] = 
    "';        \r\n        document.forms[0].submit();\r\n        return false;\r\n    } \r\n\r\n</SCRIPT>\r\n</HEAD>\r\n\r\n<BODY onload='javascript:onLoad()'>\r\n".toCharArray();
    __oracle_jsp_text[10] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[12] = 
    "\r\n    \r\n    ".toCharArray();
    __oracle_jsp_text[13] = 
    "\r\n    <div class=\"text_header\"><h2>Excel Upload</h2></div>\r\n    <br>\r\n    <TABLE CLASS=\"table_search\" BORDER=\"0\" WIDTH=\"100%\">\r\n        <TR oncontextmenu=\"return false\">\r\n            <TD width='16%'>Select File </TD>\r\n            <TD class=\"whitebg\">".toCharArray();
    __oracle_jsp_text[14] = 
    "</TD>\r\n        </TR>\r\n    </TABLE>\r\n    ".toCharArray();
    __oracle_jsp_text[15] = 
    "\r\n    <br><br><br><br>\r\n    \r\n    <div class=\"buttons_box\">\r\n        <input type=\"button\" value=\"Upload\" name=\"btnUpload\" class=\"event_btnbutton\" onclick='return onUpload()'/>      \r\n    </div>\r\n    \r\n".toCharArray();
    __oracle_jsp_text[16] = 
    "\r\n</BODY>\r\n</HTML>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
