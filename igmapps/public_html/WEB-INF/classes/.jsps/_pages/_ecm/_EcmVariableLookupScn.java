package _pages._ecm;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _EcmVariableLookupScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EcmVariableLookupScn page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      out.write(__oracle_jsp_text[3]);
      out.write(__oracle_jsp_text[4]);
      		
          String lstrCtxPath = request.getContextPath();
      
      out.write(__oracle_jsp_text[5]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[6]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/secm006");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[7]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setName("fecm006");
              __jsp_taghandler_2.setProperty("prmMasterId");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[8]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_3=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setName("fecm006");
              __jsp_taghandler_3.setProperty("passedVariables");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[9]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_4=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fecm006");
              __jsp_taghandler_4.setProperty("fieldType");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[10]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_5=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setName("fecm006");
              __jsp_taghandler_5.setProperty("rowId");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[11]);
            out.write(__oracle_jsp_text[12]);
            {
              org.apache.struts.taglib.html.TextareaTag __jsp_taghandler_6=(org.apache.struts.taglib.html.TextareaTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextareaTag.class,"org.apache.struts.taglib.html.TextareaTag cols name property rows");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setCols("95");
              __jsp_taghandler_6.setName("fecm006");
              __jsp_taghandler_6.setProperty("selectedVariables");
              __jsp_taghandler_6.setRows("20");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_6,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[13]);
                } while (__jsp_taghandler_6.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[14]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_7=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
              __jsp_taghandler_7.setParent(__jsp_taghandler_1);
              __jsp_taghandler_7.setName("fecm006");
              __jsp_taghandler_7.setOnchange("comboChange(this)");
              __jsp_taghandler_7.setProperty("selectVariables");
              __jsp_taghandler_7.setStyle("width:300px");
              __jsp_taghandler_7.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_7,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[15]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_8=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_8.setParent(__jsp_taghandler_7);
                    __jsp_taghandler_8.setLabel("name");
                    __jsp_taghandler_8.setName("fecm006");
                    __jsp_taghandler_8.setProperty("selectVariablesValues");
                    __jsp_taghandler_8.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
                    if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,3);
                  }
                  out.write(__oracle_jsp_text[16]);
                } while (__jsp_taghandler_7.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[17]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[18]);

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
  private static final char __oracle_jsp_text[][]=new char[19][];
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
    "\n\n\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\n<HEAD>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n\n    <LINK REL=\"stylesheet\" HREF=\"".toCharArray();
    __oracle_jsp_text[6] = 
    "/css/EZL.css\"/>\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \n    <STYLE TYPE=\"text/css\">\n         div.search_result{height:100px;}\n         table.table_results tbody{height:100px;}\n    </STYLE>\n    <!--[if IE]>\n        <style type=\"text/css\">\n            div.search_result {\n                position: relative;\n                height: 180px;\n                width: 100%;\n                overflow-y: scroll;\n                overflow-x: hidden;\n            }\n            table.table_results{width:99%}\n           \n            table.table_results thead tr {\n                position: absolute;width:100%;\n                top: expression(this.offsetParent.scrollTop);\n            }\n            table.table_results tbody {\n                height: auto;\n            }\n            /*table.table_results tbody tr td.first_row {\n                padding-top: 24px;}*/}\n             table.header{width:99%; }             \n        </style>\n    <![endif]-->   \n    \n\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\n    var FORM_ID       = 'fecm006';\n    var currselrowid  = 'row0';\n    \n    \n    /*Called by framework on-load of this JSP*/\n    function onLoad() {    \n\t\tvar passedVariable = document.getElementById(\"passedVariables\").value;\n        //document.getElementById(\"selectedVariables\").value = passedVariable;\n\tdocument.getElementById(\"selectedVariables\").value = window.opener.getSelectedControl();\n    }\n    \n    function openHelp() {\n        \n        var strFileName = '1';\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\n        objWindow.focus();\n    }\n    \n    \n   \n     \n    /*To reset theoriginal search criteria before processing*/\n    function resetSearchCriteria() {\n        \n    }\n    \n    function comboChange(selectObj) {\n\t\n\t\tvar idx = document.getElementById(\"selectVariables\").selectedIndex ;\n\t\tvar variableValue = document.getElementById(\"selectedVariables\").value;\n                var value = document.getElementById(\"selectVariables\").options[idx].text;\n                \n\t\t\t\tvariableValue = variableValue + value;\n\t\t\t\tdocument.getElementById(\"selectedVariables\").value = variableValue;\n                //alert(document.forms[0].selectedVariables.value);\n\t\t//document.forms[0].selectedVariables.value + = value;\n\t\t\n\t}\n    \n    function returnValues(){\n        var rowId = document.getElementById(\"rowId\").value;\n\t\tvar fieldType = document.getElementById(\"fieldType\").value;\n\t\tvar selectedVariables = document.getElementById(\"selectedVariables\").value;\n        if(fieldType == 'S' && selectedVariables.length >1000) {\n\t\t\n            showBarMessage(ECM_SE0013,ERROR_MSG);\n            document.getElementById(\"selectedVariables\").focus();\n\t\treturn false;\n        } else if(selectedVariables.length >4000) {\n            showBarMessage(ECM_SE0015,ERROR_MSG);\n            document.getElementById(\"selectedVariables\").focus();\n                return false;\n        }\n        \n        window.opener.setLookupValues(rowId,fieldType,selectedVariables);\n\t    window.close();    \n    }\n    \n    \n</SCRIPT>\n</HEAD>\n<BODY onload='javascript:onLoad()' onunload=\"javascript:doCloseAllChilds()\">\n\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\n".toCharArray();
    __oracle_jsp_text[10] = 
    "    \n".toCharArray();
    __oracle_jsp_text[11] = 
    "  \n    ".toCharArray();
    __oracle_jsp_text[12] = 
    "\n    <div class=\"text_header\"><h2>Variable Lookup</h2></div>\n    \n    \n        <TABLE ID=\"result_hdr\" CLASS=\"table_search\"  BORDER=\"1\" CELLPADDING=\"0\" CELLSPACING=\"0\" WIDTH=\"100%\" HEIGHT=\"90%\">\n            <TR COLSPAN=\"2\">\n\t\t<TD valign=\"center\">Selected Variables</TD>\n\t\t\n\t\t</TR>\n\t\t<TR COLSPAN=\"2\">\n\t\t<TD>\n                    ".toCharArray();
    __oracle_jsp_text[13] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[14] = 
    "\n\t\t</TD>\n\t\t\n\t\t\n\t    </TR>\n\t    <TR>\n                <TD>Select Variables &nbsp;&nbsp;\n                    ".toCharArray();
    __oracle_jsp_text[15] = 
    "\n                        ".toCharArray();
    __oracle_jsp_text[16] = 
    "\n\t\t    ".toCharArray();
    __oracle_jsp_text[17] = 
    "\n\t\t</TD>\n\t    </TR>\n        </TABLE>   \n        \n        \n  <div class=\"buttons_box\">\n       <input type=\"button\" value=\"Ok\" name=\"btnEdit\" class=\"event_btnbutton\" onclick='return returnValues()'/>\n    </div>\n <br>\n \n  \n".toCharArray();
    __oracle_jsp_text[18] = 
    "\n</BODY>\n</HTML>\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
