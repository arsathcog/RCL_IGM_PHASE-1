package _pages._ell;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;


public class _EllLoadListMaintenanceSummaryTabScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EllLoadListMaintenanceSummaryTabScn page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      out.write(__oracle_jsp_text[3]);
      out.write(__oracle_jsp_text[4]);
      out.write(__oracle_jsp_text[5]);
      {
        org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_1=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setId("rowdata");
        __jsp_taghandler_1.setIndexId("ctr");
        __jsp_taghandler_1.setName("fell002");
        __jsp_taghandler_1.setProperty("marlSummaryDtlTable");
        __jsp_taghandler_1.setType("com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListSummaryMod");
        com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListSummaryMod rowdata = null;
        java.lang.Integer ctr = null;
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_1,__jsp_tag_starteval,out);
          do {
            rowdata = (com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListSummaryMod) pageContext.findAttribute("rowdata");
            ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
            out.write(__oracle_jsp_text[6]);
            out.print( "row" + ctr );
            out.write(__oracle_jsp_text[7]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_2=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setMaxlength("4");
              __jsp_taghandler_2.setName("fell002");
              __jsp_taghandler_2.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].slotOperator"));
              __jsp_taghandler_2.setReadonly(true);
              __jsp_taghandler_2.setStyle("width:98%");
              __jsp_taghandler_2.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[8]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_3=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setMaxlength("4");
              __jsp_taghandler_3.setName("fell002");
              __jsp_taghandler_3.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].contOperator"));
              __jsp_taghandler_3.setReadonly(true);
              __jsp_taghandler_3.setStyle("width:98%");
              __jsp_taghandler_3.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[9]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_4=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setMaxlength("2");
              __jsp_taghandler_4.setName("fell002");
              __jsp_taghandler_4.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].activity"));
              __jsp_taghandler_4.setReadonly(true);
              __jsp_taghandler_4.setStyle("width:98%");
              __jsp_taghandler_4.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[10]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_5=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setMaxlength("2");
              __jsp_taghandler_5.setName("fell002");
              __jsp_taghandler_5.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].size"));
              __jsp_taghandler_5.setReadonly(true);
              __jsp_taghandler_5.setStyle("width:98%");
              __jsp_taghandler_5.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[11]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_6=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setMaxlength("1");
              __jsp_taghandler_6.setName("fell002");
              __jsp_taghandler_6.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].fullMT"));
              __jsp_taghandler_6.setReadonly(true);
              __jsp_taghandler_6.setStyle("width:98%");
              __jsp_taghandler_6.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[12]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_7=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_7.setParent(__jsp_taghandler_1);
              __jsp_taghandler_7.setName("fell002");
              __jsp_taghandler_7.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].boldFlg"));
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_8=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
              __jsp_taghandler_8.setParent(__jsp_taghandler_1);
              __jsp_taghandler_8.setName("fell002");
              __jsp_taghandler_8.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].boldFlg"));
              __jsp_taghandler_8.setValue("true");
              __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[14]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_9=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                    __jsp_taghandler_9.setParent(__jsp_taghandler_8);
                    __jsp_taghandler_9.setMaxlength("3");
                    __jsp_taghandler_9.setName("fell002");
                    __jsp_taghandler_9.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].noOfContainer"));
                    __jsp_taghandler_9.setReadonly(true);
                    __jsp_taghandler_9.setStyle("width:98%");
                    __jsp_taghandler_9.setStyleClass("non_edit");
                    __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
                    if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,3);
                  }
                  out.write(__oracle_jsp_text[15]);
                } while (__jsp_taghandler_8.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,2);
            }
            out.write(__oracle_jsp_text[16]);
            {
              org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_10=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
              __jsp_taghandler_10.setParent(__jsp_taghandler_1);
              __jsp_taghandler_10.setName("fell002");
              __jsp_taghandler_10.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].boldFlg"));
              __jsp_taghandler_10.setValue("true");
              __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[17]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_11=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                    __jsp_taghandler_11.setParent(__jsp_taghandler_10);
                    __jsp_taghandler_11.setMaxlength("3");
                    __jsp_taghandler_11.setName("fell002");
                    __jsp_taghandler_11.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].noOfContainer"));
                    __jsp_taghandler_11.setReadonly(true);
                    __jsp_taghandler_11.setStyle("width:98%");
                    __jsp_taghandler_11.setStyleClass("non_edit");
                    __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
                    if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,3);
                  }
                  out.write(__oracle_jsp_text[18]);
                } while (__jsp_taghandler_10.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,2);
            }
            out.write(__oracle_jsp_text[19]);
            {
              org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_12=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
              __jsp_taghandler_12.setParent(__jsp_taghandler_1);
              __jsp_taghandler_12.setName("fell002");
              __jsp_taghandler_12.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].boldFlg"));
              __jsp_taghandler_12.setValue("true");
              __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[20]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_13=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                    __jsp_taghandler_13.setParent(__jsp_taghandler_12);
                    __jsp_taghandler_13.setMaxlength("4");
                    __jsp_taghandler_13.setName("fell002");
                    __jsp_taghandler_13.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].noOfTEU"));
                    __jsp_taghandler_13.setReadonly(true);
                    __jsp_taghandler_13.setStyle("width:98%");
                    __jsp_taghandler_13.setStyleClass("non_edit");
                    __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
                    if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,3);
                  }
                  out.write(__oracle_jsp_text[21]);
                } while (__jsp_taghandler_12.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,2);
            }
            out.write(__oracle_jsp_text[22]);
            {
              org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_14=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
              __jsp_taghandler_14.setParent(__jsp_taghandler_1);
              __jsp_taghandler_14.setName("fell002");
              __jsp_taghandler_14.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].boldFlg"));
              __jsp_taghandler_14.setValue("true");
              __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[23]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_15=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                    __jsp_taghandler_15.setParent(__jsp_taghandler_14);
                    __jsp_taghandler_15.setMaxlength("4");
                    __jsp_taghandler_15.setName("fell002");
                    __jsp_taghandler_15.setProperty(OracleJspRuntime.toStr( "summaryValue[" + ctr + "].noOfTEU"));
                    __jsp_taghandler_15.setReadonly(true);
                    __jsp_taghandler_15.setStyle("width:98%");
                    __jsp_taghandler_15.setStyleClass("non_edit");
                    __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                    if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,3);
                  }
                  out.write(__oracle_jsp_text[24]);
                } while (__jsp_taghandler_14.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,2);
            }
            out.write(__oracle_jsp_text[25]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[26]);

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
  private static final char __oracle_jsp_text[][]=new char[27][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\n\n             \n<!-- Tab Search Section -->\n\n<div class=\"text_header\"><h2>Load List Detail</h2></div>\n<table class=\"header\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n    <thead> \n       <tr>\n            <th width=\"15%\"class=\"center\">Slot Oper.</th>\n            <th width=\"15%\">Cont Oper.</th>\n            <th width=\"15%\">Activity</th>\n            <th width=\"10%\">Size / Type</th>\n            <th width=\"10%\">Open Full / MT</th>\n            <th width=\"10%\">No of Container</th>\n            <th width=\"25%\"class=\"center\">No of TEUs</th>\n      </tr>\n </thead>  \n</table>\n  <div id=\"search_result\" class=\"search_result\">\n       <table id=\"tableSummary\" class=\"table_results\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">                  \n            <tbody>\n                ".toCharArray();
    __oracle_jsp_text[6] = 
    "\n                    <tr id='".toCharArray();
    __oracle_jsp_text[7] = 
    "'>\n                        <td width=\"15%\">".toCharArray();
    __oracle_jsp_text[8] = 
    "</td>\t\n                        <td width=\"15%\">".toCharArray();
    __oracle_jsp_text[9] = 
    "</td>\t\n                        <td width=\"15%\">".toCharArray();
    __oracle_jsp_text[10] = 
    "</td>\t\n                        <td width=\"10%\">".toCharArray();
    __oracle_jsp_text[11] = 
    "</td>\t\n                        <td width=\"10%\">\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[12] = 
    "\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[13] = 
    "                            \n\t\t\t\t\t\t</td>\t\n                        <td width=\"10%\">\n                            ".toCharArray();
    __oracle_jsp_text[14] = 
    "\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[15] = 
    "                            \n                            ".toCharArray();
    __oracle_jsp_text[16] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[17] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[18] = 
    "                            \n                            ".toCharArray();
    __oracle_jsp_text[19] = 
    "\n                        </td>\t\n                        <td width=\"25%\">\n                            ".toCharArray();
    __oracle_jsp_text[20] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[21] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[22] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[23] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[24] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[25] = 
    "\n                        </td>\t\n                    </tr> \n                ".toCharArray();
    __oracle_jsp_text[26] = 
    "\n            </tbody>\n    </table>      \n</div>    ".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
