package _pages._ecm;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;
import com.niit.control.web.action.BaseAction;
import com.niit.control.web.*;


public class _EcmSaveSettingsScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EcmSaveSettingsScn page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      out.write(__oracle_jsp_text[3]);
      out.write(__oracle_jsp_text[4]);
      out.write(__oracle_jsp_text[5]);
      		
          String lstrCtxPath = request.getContextPath();
          UserAccountBean account=(UserAccountBean)session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
          String lstrUserId = account.getUserId();
      
      out.write(__oracle_jsp_text[6]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[7]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm004save", pageContext));
      out.write(__oracle_jsp_text[8]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm004back", pageContext));
      out.write(__oracle_jsp_text[9]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/secm004");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[10]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setName("fecm004");
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
              __jsp_taghandler_3.setName("fecm004");
              __jsp_taghandler_3.setProperty("pageId");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[12]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_4=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fecm004");
              __jsp_taghandler_4.setProperty("viewId");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_5=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setName("fecm004");
              __jsp_taghandler_5.setProperty("defaultFlag");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[14]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_6=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setName("fecm004");
              __jsp_taghandler_6.setProperty("keyViewType");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[15]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_7=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_7.setParent(__jsp_taghandler_1);
              __jsp_taghandler_7.setName("fecm004");
              __jsp_taghandler_7.setProperty("searchCriteria");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[16]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_8=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_8.setParent(__jsp_taghandler_1);
              __jsp_taghandler_8.setName("fecm004");
              __jsp_taghandler_8.setProperty("accessLevel1");
              __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
              if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,2);
            }
            out.write(__oracle_jsp_text[17]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_9=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_9.setParent(__jsp_taghandler_1);
              __jsp_taghandler_9.setName("fecm004");
              __jsp_taghandler_9.setProperty("accessLevel2");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[18]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_10=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_10.setParent(__jsp_taghandler_1);
              __jsp_taghandler_10.setName("fecm004");
              __jsp_taghandler_10.setProperty("saveDone");
              __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
              if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,2);
            }
            out.write(__oracle_jsp_text[19]);
            out.write(__oracle_jsp_text[20]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_11=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style styleClass size");
              __jsp_taghandler_11.setParent(__jsp_taghandler_1);
              __jsp_taghandler_11.setName("fecm004");
              __jsp_taghandler_11.setOnchange("showText()");
              __jsp_taghandler_11.setProperty("viewName");
              __jsp_taghandler_11.setStyle("height:20px");
              __jsp_taghandler_11.setStyleClass("must");
              __jsp_taghandler_11.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_11,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[21]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_12=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_12.setParent(__jsp_taghandler_11);
                    __jsp_taghandler_12.setLabel("name");
                    __jsp_taghandler_12.setName("fecm004");
                    __jsp_taghandler_12.setProperty("viewNameValues");
                    __jsp_taghandler_12.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
                    if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,3);
                  }
                  out.write(__oracle_jsp_text[22]);
                } while (__jsp_taghandler_11.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[23]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_13=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property style styleClass");
              __jsp_taghandler_13.setParent(__jsp_taghandler_1);
              __jsp_taghandler_13.setMaxlength("100");
              __jsp_taghandler_13.setName("fecm004");
              __jsp_taghandler_13.setProperty("viewNameVal");
              __jsp_taghandler_13.setStyle("display:none;");
              __jsp_taghandler_13.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
              if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,2);
            }
            out.write(__oracle_jsp_text[24]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_14=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag disabled name property styleClass size");
              __jsp_taghandler_14.setParent(__jsp_taghandler_1);
              __jsp_taghandler_14.setDisabled(true);
              __jsp_taghandler_14.setName("fecm004");
              __jsp_taghandler_14.setProperty("viewType");
              __jsp_taghandler_14.setStyleClass("non_edit");
              __jsp_taghandler_14.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_14,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[25]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_15=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_15.setParent(__jsp_taghandler_14);
                    __jsp_taghandler_15.setLabel("name");
                    __jsp_taghandler_15.setName("fecm004");
                    __jsp_taghandler_15.setProperty("viewTypeValues");
                    __jsp_taghandler_15.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                    if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,3);
                  }
                  out.write(__oracle_jsp_text[26]);
                } while (__jsp_taghandler_14.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,2);
            }
            out.write(__oracle_jsp_text[27]);
            {
              org.apache.struts.taglib.html.CheckboxTag __jsp_taghandler_16=(org.apache.struts.taglib.html.CheckboxTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.CheckboxTag.class,"org.apache.struts.taglib.html.CheckboxTag name property styleClass");
              __jsp_taghandler_16.setParent(__jsp_taghandler_1);
              __jsp_taghandler_16.setName("fecm004");
              __jsp_taghandler_16.setProperty("defaultl");
              __jsp_taghandler_16.setStyleClass("check");
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[28]);
            out.write(__oracle_jsp_text[29]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[30]);

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
  private static final char __oracle_jsp_text[][]=new char[31][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<HTML xmlns=\"http://www.w3.org/1999/xhtml\">\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\n<HEAD>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n<TITLE> </TITLE>\n\n    <LINK REL=\"stylesheet\" HREF=\"".toCharArray();
    __oracle_jsp_text[7] = 
    "/css/EZL.css\"/>\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \n    <STYLE TYPE=\"text/css\">\n         div.search_result{height:100px;}\n         table.table_results tbody{height:100px;}\n    </STYLE>\n\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\n    var FORM_ID       = 'fecm004';\n    var currselrowid  = 'row0';\n \n    /*Called by framework on-load of this JSP*/\n    function onLoad() { \n    \n        if(document.forms[0].defaultFlag.value == \"Y\") {\n            document.forms[0].defaultl.checked = true;  \n        } else if(document.forms[0].defaultFlag.value == \"N\") {\n            document.forms[0].defaultl.checked = false;  \n        }\n        \n        if(document.forms[0].keyViewType.value == \"U\") {\n            document.forms[0].viewType[0].selected = true;\n\t\t\t\n        } else if(document.forms[0].keyViewType.value == \"F\") {\n             document.forms[0].viewType[1].selected = true;\n\t\t\t \n        } else if(document.forms[0].keyViewType.value == \"G\") {\n             document.forms[0].viewType[2].selected = true;\n\t\t\t \n        }\n        var viewVar = document.forms[0].viewName.value;\n        \n        var saveDone = document.getElementById(\"saveDone\").value;\n        if(saveDone != \"true\") {\n            if(viewVar == 'NEW'){\n                document.forms[0].viewNameVal.style.display=\"\"; \n                document.forms[0].viewNameVal.value = \"\"; \n            } \n        }\n        showText();\n    }\n    \n    /*Called by framework for help*/\n    function openHelp() {\n        alert('Help...');\n        var strFileName = '1';\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\n        objWindow.focus();\n    }\n    \n    /*Called by Save Button*/\n    function onSave(){\n    \n        var viewNameValue = document.forms[0].viewNameVal.value;\n        var viewNameVar = document.forms[0].viewName.value; \n        var viewTypeVar = document.forms[0].viewType.value;\n        var accessLevel1 = document.forms[0].accessLevel1.value;\n        var accessLevel2 = document.forms[0].accessLevel2.value;\n        \n        if(viewNameVar == \"NEW\" && viewNameValue == \"\"){\n            \n            showBarMessage(ECM_SE0001,ERROR_MSG);\n            return false;\n        } \n        if(viewTypeVar == \"\"){\n            \n            showBarMessage(ECM_SE0002,ERROR_MSG);\n            return false;\n        }\n        \n        \n        if(viewTypeVar == 'G' && accessLevel1 != '*') {\n            showBarMessage(ECM_SE0011,ERROR_MSG);\n            return false;\n        }\n        /* Disable all controls */\n        disableOnSubmit();        \n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[8] = 
    "';\n        document.forms[0].submit();\n        return false;            \n    }\n    \n    /*Called for New View settings*/\n    function showText()\n    {    \n        var viewVar = document.forms[0].viewName.value;\n        if(viewVar == 'NEW'){\n            document.forms[0].viewNameVal.style.display=\"\"; // this is for showing text field\n            document.forms[0].viewType.disabled=false;\n            \n        } else {\n            document.forms[0].viewType.disabled=true;\n            document.forms[0].viewNameVal.style.display=\"none\"; // this is for hiding text field\n        }            \n    }\n    \n    function onBack(){\n        document.forms[0].action = '".toCharArray();
    __oracle_jsp_text[9] = 
    "';\n        document.forms[0].submit();\n        return false;\n    }\n</SCRIPT>\n</HEAD>\n\n<BODY onload='javascript:onLoad()'>\n<base target=\"_self\">\n".toCharArray();
    __oracle_jsp_text[10] = 
    "\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\n".toCharArray();
    __oracle_jsp_text[12] = 
    "\n".toCharArray();
    __oracle_jsp_text[13] = 
    "\n".toCharArray();
    __oracle_jsp_text[14] = 
    "\n".toCharArray();
    __oracle_jsp_text[15] = 
    "\n".toCharArray();
    __oracle_jsp_text[16] = 
    "\n".toCharArray();
    __oracle_jsp_text[17] = 
    "\n".toCharArray();
    __oracle_jsp_text[18] = 
    "\n".toCharArray();
    __oracle_jsp_text[19] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[20] = 
    "\n\t<div class=\"text_header\"><h2>Save Settings</h2></div>\n    <br>\n    <TABLE CLASS=\"table_search\" BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"0\" CELLPADDING=\"0\">\n        <TR>\n            <TD width=\"80px\">View Name</TD>\n            <TD width=\"500px\" valign='top'>\n            ".toCharArray();
    __oracle_jsp_text[21] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[22] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[23] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[24] = 
    "\n            </TD>\n        </TR>\n        <TR><TD>&nbsp;</TD><TD>&nbsp;</TD></TR>\n        <TR>\n            <TD width=\"60px\">View Type</TD>\n            <TD width=\"60px\">\n            ".toCharArray();
    __oracle_jsp_text[25] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[26] = 
    "\n                    \n                ".toCharArray();
    __oracle_jsp_text[27] = 
    "\n            </TD>\n        </TR>\n        <TR><TD>&nbsp;</TD><TD>&nbsp;</TD></TR>\n        <TR>\n            <TD width=\"60px\">Default</TD>\n            <TD width=\"60px\">\n                ".toCharArray();
    __oracle_jsp_text[28] = 
    "\n            </TD>\n        </TR>      \n    </TABLE>\n    ".toCharArray();
    __oracle_jsp_text[29] = 
    "\n    <br><br><br><br>\n\n    <div class=\"buttons_box\">\n        <input type=\"button\" value=\"Save\" name=\"btnSave\" class=\"event_btnbutton\" onclick='onSave()'/>       \n    </div>\n    \n".toCharArray();
    __oracle_jsp_text[30] = 
    "\n\n</HTML>\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
