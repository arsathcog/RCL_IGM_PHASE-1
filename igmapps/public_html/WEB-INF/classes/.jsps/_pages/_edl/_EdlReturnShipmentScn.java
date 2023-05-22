package _pages._edl;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _EdlReturnShipmentScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EdlReturnShipmentScn page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      
          String lstrCtxPath = request.getContextPath();
      
      out.write(__oracle_jsp_text[2]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[3]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl004save", pageContext));
      out.write(__oracle_jsp_text[4]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/sedl004");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[5]);
            out.write(__oracle_jsp_text[6]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_2=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property size styleClass");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setMaxlength("17");
              __jsp_taghandler_2.setName("fedl004");
              __jsp_taghandler_2.setOnblur("changeUpper(this)");
              __jsp_taghandler_2.setProperty("bookingNo");
              __jsp_taghandler_2.setSize("20");
              __jsp_taghandler_2.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[7]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_3=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property size styleClass");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setMaxlength("17");
              __jsp_taghandler_3.setName("fedl004");
              __jsp_taghandler_3.setOnblur("changeUpper(this)");
              __jsp_taghandler_3.setProperty("importBlNo");
              __jsp_taghandler_3.setSize("20");
              __jsp_taghandler_3.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[8]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_4=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fedl004");
              __jsp_taghandler_4.setOnclick("changeRadio()");
              __jsp_taghandler_4.setProperty("robContainer");
              __jsp_taghandler_4.setStyleClass("check");
              __jsp_taghandler_4.setValue("A");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[9]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_5=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setName("fedl004");
              __jsp_taghandler_5.setOnclick("changeRadio()");
              __jsp_taghandler_5.setProperty("robContainer");
              __jsp_taghandler_5.setStyleClass("check");
              __jsp_taghandler_5.setValue("R");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[10]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_6=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style styleClass size");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setName("fedl004");
              __jsp_taghandler_6.setProperty("kindOfReturn");
              __jsp_taghandler_6.setStyle("width:80%;height:20px");
              __jsp_taghandler_6.setStyleClass("must");
              __jsp_taghandler_6.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_6,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[11]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_7=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_7.setParent(__jsp_taghandler_6);
                    __jsp_taghandler_7.setLabel("name");
                    __jsp_taghandler_7.setName("fedl004");
                    __jsp_taghandler_7.setProperty("kindofReturnValues");
                    __jsp_taghandler_7.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
                    if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,3);
                  }
                  out.write(__oracle_jsp_text[12]);
                } while (__jsp_taghandler_6.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_8=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property size style");
              __jsp_taghandler_8.setParent(__jsp_taghandler_1);
              __jsp_taghandler_8.setMaxlength("254");
              __jsp_taghandler_8.setName("fedl004");
              __jsp_taghandler_8.setProperty("reason");
              __jsp_taghandler_8.setSize("40");
              __jsp_taghandler_8.setStyle("width:98%");
              __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
              if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,2);
            }
            out.write(__oracle_jsp_text[14]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[15]);

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
  private static final char __oracle_jsp_text[][]=new char[16][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n<HTML xmlns=\"http://www.w3.org/1999/xhtml\">\r\n\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n\r\n<HEAD>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n<TITLE> </TITLE>\r\n\r\n    <LINK REL=\"stylesheet\" HREF=\"".toCharArray();
    __oracle_jsp_text[3] = 
    "/css/EZL.css\"/>\r\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \r\n    <STYLE TYPE=\"text/css\">\r\n         div.search_result{height:100px;}\r\n         table.table_results tbody{height:100px;}\r\n    </STYLE>\r\n\r\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\r\n    \r\n    var FORM_ID                = 'fedl004';\r\n    var PROG_ID                = 'SEDL004';\r\n    var lastBookingNo          = '';\r\n    var lastRobContainer       = '';\r\n    var lastImportBlNo         = '';\r\n    var lastKindofReturn       = '';\r\n    var lastReason             = '';\r\n\t\r\n    /*Called by framework on-load of this JSP*/\r\n    function onLoad() {  \r\n\tchangeRadio();\r\n    }\r\n\r\n    function openHelp() {\r\n        var strFileName = '1';\r\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\r\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\r\n        objWindow.focus();\r\n    }\r\n    /*Called by Save Button*/\r\n    function onSave() {\r\n\r\n        var strBookingNo          = document.forms[0].bookingNo.value;\r\n        var strImportBlNo         = document.forms[0].importBlNo.value;\r\n        var strKindofReturn       = document.forms[0].kindOfReturn.value;          \r\n        var strReason             = document.forms[0].reason.value;\t\r\n        var strRobContainer       = document.forms[0].robContainer.value;\r\n\r\n        //validate bookingNo\r\n        if(strBookingNo == \"\"){\r\n            showBarMessage(EDL_SE0001,ERROR_MSG);    \r\n\t\t\treturn;    \r\n        }\r\n        //validate importBlNo\r\n        if(strImportBlNo == \"\"){\r\n            showBarMessage(EDL_SE0003,ERROR_MSG);    \r\n\t\t\treturn;    \r\n        }\r\n        //validate kindofReturn\r\n        if(strKindofReturn == \"\"){\r\n            showBarMessage(EDL_SE0005,ERROR_MSG);    \r\n            return;    \r\n        }\r\n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[4] = 
    "';\r\n        document.forms[0].submit();\r\n        return false;\r\n    }\r\n\r\n    function changeRadio() {    \r\n\r\n\tif( document.forms[0].robContainer[0].checked==true ) {\r\n\t\tdocument.forms[0].robContainer[0].value = \"A\";\r\n\t} else if( document.forms[0].robContainer[1].checked==true ) {\r\n\t\tdocument.forms[0].robContainer[1].value = \"R\";\r\n\t}else {\r\n\t\tdocument.forms[0].robContainer[0].checked=true;\r\n\t}\r\n    }\r\n\r\n\r\n</SCRIPT>\r\n</HEAD>\r\n<BODY onload='javascript:onLoad()'>\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n   <div class=\"text_header\"></div>\r\n   <br>\r\n    <TABLE CLASS=\"table_search\" BORDER=\"0\"  width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\r\n       <TR>\r\n\t <TD width=\"2%\">&nbsp;</TD>\r\n         <TD  width=\"15%\">Booking Number</TD>\r\n         <TD  class=\"whitebg\" width=\"33%\">\r\n            ".toCharArray();
    __oracle_jsp_text[7] = 
    "            \r\n         </TD>\r\n         <TD width=\"50%\">&nbsp;</TD>\r\n       </TR>\r\n       <TR>\r\n\t <TD>&nbsp;</TD>\r\n         <TD>Import BL Number</TD>\r\n         <TD  class=\"whitebg\">\r\n             ".toCharArray();
    __oracle_jsp_text[8] = 
    "          \r\n         </TD>\r\n\t<TD>&nbsp;</TD>\r\n       </TR>\r\n        <TR>\r\n\t <TD>&nbsp;</TD>\r\n         <TD>All Containers</TD>\r\n         <TD  class=\"whitebg\" align = 'left'>\r\n          ".toCharArray();
    __oracle_jsp_text[9] = 
    "\r\n         </TD>\r\n\t <TD>&nbsp;</TD>\r\n        </TR>\r\n        <TR>\r\n         <TD>&nbsp;</TD>\r\n         <TD>ROB Containers</TD>\r\n         <TD  class=\"whitebg\">\r\n          ".toCharArray();
    __oracle_jsp_text[10] = 
    "\r\n         </TD>\r\n\t <TD>&nbsp;</TD>\r\n        </TR>\r\n        <TR>\r\n\t <TD>&nbsp;</TD>\r\n\t <TD>Kind of Return</TD>\r\n         <TD class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[12] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[13] = 
    "\r\n         </TD> \r\n\t <TD>&nbsp;</TD>\r\n        </TR>\r\n        <TR>\r\n\t <TD>&nbsp;</TD>\r\n         <TD>Return Reason</TD>\r\n         <TD class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[14] = 
    "\r\n         </TD>\r\n\t <TD>&nbsp;</TD>\r\n        </TR>\r\n  </TABLE>\r\n".toCharArray();
    __oracle_jsp_text[15] = 
    "\r\n</BODY>\r\n</HTML>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
