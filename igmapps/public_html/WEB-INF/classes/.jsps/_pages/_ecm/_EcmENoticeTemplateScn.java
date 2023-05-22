package _pages._ecm;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _EcmENoticeTemplateScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EcmENoticeTemplateScn page = this;
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
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm005search", pageContext));
      out.write(__oracle_jsp_text[7]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm006", pageContext));
      out.write(__oracle_jsp_text[8]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm005save", pageContext));
      out.write(__oracle_jsp_text[9]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm009", pageContext));
      out.write(__oracle_jsp_text[10]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/secm005");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[11]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setName("fecm005");
              __jsp_taghandler_2.setProperty("searchPerformed");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[12]);
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_3=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style styleClass size");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setName("fecm005");
              __jsp_taghandler_3.setProperty("noticeType");
              __jsp_taghandler_3.setStyle("width:100%;height:25px");
              __jsp_taghandler_3.setStyleClass("must");
              __jsp_taghandler_3.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_3,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[14]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_4=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_4.setParent(__jsp_taghandler_3);
                    __jsp_taghandler_4.setLabel("name");
                    __jsp_taghandler_4.setName("fecm005");
                    __jsp_taghandler_4.setProperty("noticeTypeValues");
                    __jsp_taghandler_4.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
                    if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,3);
                  }
                  out.write(__oracle_jsp_text[15]);
                } while (__jsp_taghandler_3.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[16]);
            out.write(__oracle_jsp_text[17]);
            out.write(__oracle_jsp_text[18]);
            out.write(__oracle_jsp_text[19]);
            out.write(__oracle_jsp_text[20]);
            {
              org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_5=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setId("rowdata");
              __jsp_taghandler_5.setIndexId("ctr");
              __jsp_taghandler_5.setName("fecm005");
              __jsp_taghandler_5.setProperty("values");
              __jsp_taghandler_5.setType("com.rclgroup.dolphin.ezl.web.ecm.vo.EcmENoticeTemplateMod");
              com.rclgroup.dolphin.ezl.web.ecm.vo.EcmENoticeTemplateMod rowdata = null;
              java.lang.Integer ctr = null;
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_5,__jsp_tag_starteval,out);
                do {
                  rowdata = (com.rclgroup.dolphin.ezl.web.ecm.vo.EcmENoticeTemplateMod) pageContext.findAttribute("rowdata");
                  ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
                  out.write(__oracle_jsp_text[21]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_6=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style styleClass");
                    __jsp_taghandler_6.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_6.setMaxlength("100");
                    __jsp_taghandler_6.setName("fecm005");
                    __jsp_taghandler_6.setOnblur(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_6.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].templateDesc"));
                    __jsp_taghandler_6.setStyle("width:127px");
                    __jsp_taghandler_6.setStyleClass("must");
                    __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
                    if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,3);
                  }
                  out.write(__oracle_jsp_text[22]);
                  {
                    org.apache.struts.taglib.html.SelectTag __jsp_taghandler_7=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
                    __jsp_taghandler_7.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_7.setName("fecm005");
                    __jsp_taghandler_7.setOnchange(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_7.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].templateLanguage"));
                    __jsp_taghandler_7.setStyle("width:95%");
                    __jsp_taghandler_7.setSize("1");
                    __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_7,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[23]);
                        {
                          org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_8=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                          __jsp_taghandler_8.setParent(__jsp_taghandler_7);
                          __jsp_taghandler_8.setLabel("name");
                          __jsp_taghandler_8.setName("fecm005");
                          __jsp_taghandler_8.setProperty("templateLanguageValues");
                          __jsp_taghandler_8.setValue("code");
                          __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
                          if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,4);
                        }
                        out.write(__oracle_jsp_text[24]);
                      } while (__jsp_taghandler_7.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,3);
                  }
                  out.write(__oracle_jsp_text[25]);
                  {
                    org.apache.struts.taglib.html.TextareaTag __jsp_taghandler_9=(org.apache.struts.taglib.html.TextareaTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextareaTag.class,"org.apache.struts.taglib.html.TextareaTag cols name onblur property readonly rows styleClass");
                    __jsp_taghandler_9.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_9.setCols("6");
                    __jsp_taghandler_9.setName("fecm005");
                    __jsp_taghandler_9.setOnblur(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_9.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].subject"));
                    __jsp_taghandler_9.setReadonly(true);
                    __jsp_taghandler_9.setRows("1");
                    __jsp_taghandler_9.setStyleClass("non_edit");
                    __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_9,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[26]);
                      } while (__jsp_taghandler_9.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,3);
                  }
                  out.write(__oracle_jsp_text[27]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_10=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_10.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_10.setName("fecm005");
                    __jsp_taghandler_10.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].subject"));
                    __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
                    if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,3);
                  }
                  out.write(__oracle_jsp_text[28]);
                  out.print("openVariableLookup("+1+","+ctr+")");
                  out.write(__oracle_jsp_text[29]);
                  {
                    org.apache.struts.taglib.html.TextareaTag __jsp_taghandler_11=(org.apache.struts.taglib.html.TextareaTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextareaTag.class,"org.apache.struts.taglib.html.TextareaTag cols name onblur property readonly rows styleClass");
                    __jsp_taghandler_11.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_11.setCols("6");
                    __jsp_taghandler_11.setName("fecm005");
                    __jsp_taghandler_11.setOnblur(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_11.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].bodyHeader"));
                    __jsp_taghandler_11.setReadonly(true);
                    __jsp_taghandler_11.setRows("1");
                    __jsp_taghandler_11.setStyleClass("non_edit");
                    __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_11,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[30]);
                      } while (__jsp_taghandler_11.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,3);
                  }
                  out.write(__oracle_jsp_text[31]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_12=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_12.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_12.setName("fecm005");
                    __jsp_taghandler_12.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].bodyHeader"));
                    __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
                    if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,3);
                  }
                  out.write(__oracle_jsp_text[32]);
                  out.print("openVariableLookup("+2+","+ctr+")");
                  out.write(__oracle_jsp_text[33]);
                  {
                    org.apache.struts.taglib.html.TextareaTag __jsp_taghandler_13=(org.apache.struts.taglib.html.TextareaTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextareaTag.class,"org.apache.struts.taglib.html.TextareaTag cols name onblur property readonly rows styleClass");
                    __jsp_taghandler_13.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_13.setCols("6");
                    __jsp_taghandler_13.setName("fecm005");
                    __jsp_taghandler_13.setOnblur(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_13.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].bodyDetail"));
                    __jsp_taghandler_13.setReadonly(true);
                    __jsp_taghandler_13.setRows("1");
                    __jsp_taghandler_13.setStyleClass("non_edit");
                    __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_13,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[34]);
                      } while (__jsp_taghandler_13.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,3);
                  }
                  out.write(__oracle_jsp_text[35]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_14=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_14.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_14.setName("fecm005");
                    __jsp_taghandler_14.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].bodyDetail"));
                    __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
                    if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,3);
                  }
                  out.write(__oracle_jsp_text[36]);
                  out.print("openVariableLookup("+3+","+ctr+")");
                  out.write(__oracle_jsp_text[37]);
                  {
                    org.apache.struts.taglib.html.TextareaTag __jsp_taghandler_15=(org.apache.struts.taglib.html.TextareaTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextareaTag.class,"org.apache.struts.taglib.html.TextareaTag cols name onblur property readonly rows styleClass");
                    __jsp_taghandler_15.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_15.setCols("6");
                    __jsp_taghandler_15.setName("fecm005");
                    __jsp_taghandler_15.setOnblur(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_15.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].bodyFooter"));
                    __jsp_taghandler_15.setReadonly(true);
                    __jsp_taghandler_15.setRows("1");
                    __jsp_taghandler_15.setStyleClass("non_edit");
                    __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_15,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[38]);
                      } while (__jsp_taghandler_15.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,3);
                  }
                  out.write(__oracle_jsp_text[39]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_16=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_16.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_16.setName("fecm005");
                    __jsp_taghandler_16.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].bodyFooter"));
                    __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
                    if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,3);
                  }
                  out.write(__oracle_jsp_text[40]);
                  out.print("openVariableLookup("+4+","+ctr+")");
                  out.write(__oracle_jsp_text[41]);
                  {
                    org.apache.struts.taglib.html.SelectTag __jsp_taghandler_17=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style styleClass size");
                    __jsp_taghandler_17.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_17.setName("fecm005");
                    __jsp_taghandler_17.setOnchange(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_17.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].attachmentFlag"));
                    __jsp_taghandler_17.setStyle("width:95%;height:20px");
                    __jsp_taghandler_17.setStyleClass("must");
                    __jsp_taghandler_17.setSize("1");
                    __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_17,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[42]);
                        {
                          org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_18=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                          __jsp_taghandler_18.setParent(__jsp_taghandler_17);
                          __jsp_taghandler_18.setLabel("name");
                          __jsp_taghandler_18.setName("fecm005");
                          __jsp_taghandler_18.setProperty("attachmentFlagValues");
                          __jsp_taghandler_18.setValue("code");
                          __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
                          if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,4);
                        }
                        out.write(__oracle_jsp_text[43]);
                      } while (__jsp_taghandler_17.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,3);
                  }
                  out.write(__oracle_jsp_text[44]);
                  {
                    org.apache.struts.taglib.html.SelectTag __jsp_taghandler_19=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style styleClass size");
                    __jsp_taghandler_19.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_19.setName("fecm005");
                    __jsp_taghandler_19.setOnchange(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_19.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].recordStatus"));
                    __jsp_taghandler_19.setStyle("width:95%;height:20px");
                    __jsp_taghandler_19.setStyleClass("must");
                    __jsp_taghandler_19.setSize("1");
                    __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_19,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[45]);
                        {
                          org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_20=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                          __jsp_taghandler_20.setParent(__jsp_taghandler_19);
                          __jsp_taghandler_20.setLabel("name");
                          __jsp_taghandler_20.setName("fecm005");
                          __jsp_taghandler_20.setProperty("recStatusValues");
                          __jsp_taghandler_20.setValue("code");
                          __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
                          if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,4);
                        }
                        out.write(__oracle_jsp_text[46]);
                      } while (__jsp_taghandler_19.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,3);
                  }
                  out.write(__oracle_jsp_text[47]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_21=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_21.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_21.setName("fecm005");
                    __jsp_taghandler_21.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                    __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
                    if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,3);
                  }
                  out.write(__oracle_jsp_text[48]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_22=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_22.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_22.setName("fecm005");
                    __jsp_taghandler_22.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].updTime"));
                    __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
                    if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,3);
                  }
                  out.write(__oracle_jsp_text[49]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_23=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_23.setParent(__jsp_taghandler_5);
                    __jsp_taghandler_23.setName("fecm005");
                    __jsp_taghandler_23.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].templateId"));
                    __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
                    if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,3);
                  }
                  out.write(__oracle_jsp_text[50]);
                  out.print("openPreview("+ctr+")");
                  out.write(__oracle_jsp_text[51]);
                } while (__jsp_taghandler_5.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[52]);
            out.write(__oracle_jsp_text[53]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_24=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag property");
              __jsp_taghandler_24.setParent(__jsp_taghandler_1);
              __jsp_taghandler_24.setProperty("templateLanguage");
              __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_24,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[54]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_25=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_25.setParent(__jsp_taghandler_24);
                    __jsp_taghandler_25.setLabel("name");
                    __jsp_taghandler_25.setName("fecm005");
                    __jsp_taghandler_25.setProperty("templateLanguageValues");
                    __jsp_taghandler_25.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
                    if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,3);
                  }
                  out.write(__oracle_jsp_text[55]);
                } while (__jsp_taghandler_24.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,2);
            }
            out.write(__oracle_jsp_text[56]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[57]);

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
  private static final char __oracle_jsp_text[][]=new char[58][];
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
    "/css/EZL.css\"/>\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \n    <STYLE TYPE=\"text/css\">\n         div.search_result{height:100px;}\n         table.table_results tbody{height:100px;}\n    </STYLE>\n    <!--[if IE]>\n        <style type=\"text/css\">\n            div.search_result {\n                position: relative;\n                height: 180px;\n                width: 100%;\n                overflow-y: scroll;\n                overflow-x: hidden;\n            }\n            table.table_results{width:99%}\n           \n            table.table_results thead tr {\n                position: absolute;width:100%;\n                top: expression(this.offsetParent.scrollTop);\n            }\n            table.table_results tbody {\n                height: auto;\n            }\n            /*table.table_results tbody tr td.first_row {\n                padding-top: 24px;}*/}\n             table.header{width:99%; }             \n        </style>\n    <![endif]-->   \n    \n\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\n\n    var lastNoticeTyp = '';\n    /*Called by framework on-load of this JSP*/\n    function onLoad() {\n        lastNoticeTyp = document.getElementById(\"noticeType\").value;\n        document.forms[0].templateLanguage.style.display = \"none\";\n        //document.getElementById('value[' + 0 + '].subject').setAttribute('class','non_edit');\n    }\n    \n    /*Called by Find Button*/\n    function onSearch() {\n        lastNoticeTyp ='';\n       var value = document.getElementById(\"noticeType\").value ;\n       if(value=='' || value.length ==0) {\n        showBarMessage(ECM_SE0012,ERROR_MSG);\n        return false;\n       }\n        //Clear the Data Table\n        clearDiv('search_result');\n        \n        //set the action\n        //document.forms[0].currPageNo.value= 1;\n        \n        /* Disable all controls */\n        disableOnSubmit();            \n    \n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[7] = 
    "';\n        \n        document.forms[0].submit();\n        return false;\n    }\n    \n    function updateRecordStatus(arow) {\n        var lobjStatus = document.getElementById('value[' + arow + '].status');\n      var lstrstatus = lobjStatus.value;\n      if(lstrstatus == '') {\n             lobjStatus.value = UPD;\n             //Set status to upd\n           \n          }\n    }\n    \n    function openVariableLookup(fieldType,aintIndex) {\n       var prmMasterId = document.getElementById(\"noticeType\").value;\n       \n       var variableValue = '';\n       if(fieldType == '1') {\n            fieldType='S';\n            document.getElementById(\"mselectedControl\").value = document.getElementById('value[' + aintIndex + '].subject').value;\n       } else if(fieldType == '2') {\n            fieldType = 'H';\n            document.getElementById(\"mselectedControl\").value = document.getElementById('value[' + aintIndex + '].bodyHeader').value; \n       } else if(fieldType == '3') {\n            fieldType = 'D';\n            document.getElementById(\"mselectedControl\").value = document.getElementById('value[' + aintIndex + '].bodyDetail').value;\n       } else if(fieldType == '4') {\n            fieldType = 'F';\n            document.getElementById(\"mselectedControl\").value = document.getElementById('value[' + aintIndex + '].bodyFooter').value; \n       }\n      \n       var urlStr = '".toCharArray();
    __oracle_jsp_text[8] = 
    "?prmMasterId='+prmMasterId+'&fieldType='+fieldType+'&rowId='+aintIndex;\n        window.open(urlStr,'secm006','height=600px','width=530px');\n        //openChildScreen(urlStr,'secm006');\n        return false;\n    }\n    \n    function getSelectedControl() {\n        return document.getElementById(\"mselectedControl\").value;\n    }\n    \n    function setLookupValues(arowId,afieldType,aVariables) {\n    \n        if(afieldType == 'S') {\n            document.getElementById('value[' + arowId + '].subject').value = aVariables;\n        }    else if(afieldType == 'H') {\n            document.getElementById('value[' + arowId + '].bodyHeader').value = aVariables;\n        } else if(afieldType == 'D') {\n            document.getElementById('value[' + arowId + '].bodyDetail').value = aVariables ;\n        } else if (afieldType == 'F') {\n            document.getElementById('value[' + arowId + '].bodyFooter').value = aVariables ;\n        }\n        if(document.getElementById('value[' + arowId + '].status').value == '') {\n            \n            document.getElementById('value[' + arowId + '].status').value = 'UPD';\n        }\n    }\n    \n    function onSave() {\n        resetSearchCriteria();\n        var tableResult = \"result_dtl\";\n        var pkArr       = [\"templateLanguage\"];\n        \n        var ctr =0;\n        var table     = document.getElementById(\"result_dtl\");\n        var totalRows = table.rows.length;\n        var rowIndex  = table.rows.length;\n        \n        var searchPerformed = document.getElementById(\"searchPerformed\").value ;\n        \n        /*\n        if(searchPerformed == 'false') {\n            showBarMessage(ECM_SE0007,ERROR_MSG);\n                        return;\n        }*/\n                if(totalRows == 0) {\n                    showBarMessage(ECM_GE0014,ERROR_MSG);\n                        return;\n                }\n                \n        for(ctr = 0 ; ctr<totalRows ;ctr++) {\n        \n            var value = document.getElementById('value[' + ctr + '].templateDesc').value;\n            if(value == '' || (trimString(value).length == 0)){\n                showBarMessage(ECM_SE0003,ERROR_MSG);\n                document.getElementById('value[' + ctr + '].templateDesc').focus();\n                return ;\n            }\n            \n            var subject = document.getElementById('value[' + ctr + '].subject').value;\n            if(subject == '' || (trimString(subject).length == 0)){\n                showBarMessage(ECM_SE0005,ERROR_MSG);\n                return ;\n            } else if(subject.length >1000) {\n                            showBarMessage(ECM_SE0013,ERROR_MSG);\n                return;\n                        }\n            var header = document.getElementById('value[' + ctr + '].bodyHeader').value;\n            var body   = document.getElementById('value[' + ctr + '].bodyDetail').value;\n            var footer = document.getElementById('value[' + ctr + '].bodyFooter').value;\n            if((header == '' || (trimString(header).length == 0)) && (body == '' || (trimString(body).length == 0))&&(footer == '' || (trimString(footer).length == 0))) {\n                            showBarMessage(ECM_SE0006,ERROR_MSG);\n                            return;\n            }\n                        \n                        if(header.length!=0 && header.length>4000) {\n                            showBarMessage(ECM_SE0014,ERROR_MSG);\n                            return;\n                        }\n                        if(body.length!=0 && body.length>4000) {\n                           showBarMessage(ECM_SE0015,ERROR_MSG);\n                            return;\n                        }\n                         if(footer.length!=0 && footer.length>4000) {\n                           showBarMessage(ECM_SE0016,ERROR_MSG);\n                            return;\n                        }\n        }\n\n        if(checkDuplicacyTable(tableResult,pkArr)) {\n            showBarMessage(ECM_SE0004,ERROR_MSG);\n            return;\n        }\n        \n           \n        \n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[9] = 
    "';\n        \n        document.forms[0].submit();\n        return false;\n    }    \n    \nfunction  addRow() {\n    resetSearchCriteria();\n    var table     = document.getElementById(\"result_dtl\");\n    var totalRows = table.rows.length;\n    var rowIndex  = table.rows.length;\n    var lstrLanguageCode = \"value[\"+rowIndex+\"].templateLanguage\";\n    var attachmentFlag = \"value[\"+rowIndex+\"].attachmentFlag\";\n    /*\n        if(totalRows == 0) {\n            showBarMessage(ECM_SE0007,ERROR_MSG);\n        }\n      */\n    if(document.getElementById(\"noticeType\").value == '' || document.getElementById(\"noticeType\").value.length == 0) {\n        showBarMessage(ECM_SE0007,ERROR_MSG);\n        return false;\n    }\n      \n    var statusValue = \"value[\"+rowIndex+\"].recordStatus\";\n    var row       = table.insertRow(totalRows);\n    row.setAttribute(\"id\", \"row\"+rowIndex);\n    row.setAttribute(\"height\", \"20px\");\n    \n    var cell1         = row.insertCell(0);\n    cell1.setAttribute(\"width\", \"15%\");\n    cell1.innerHTML   = \"<td >\"+\n                                                \"<input type='hidden' value='' name='value[\"+rowIndex+\"].templateId' >\"+\n                                                \"<input type='hidden' value='' name='value[\"+rowIndex+\"].updTime' >\"+\n                        \"<input type='hidden' value='ADD' name='value[\"+rowIndex+\"].status' >\"+\n                        \"<input type='text' value=''  style='width:90%' class='must'  name='value[\"+rowIndex+\"].templateDesc' maxlength='100'></td>\";\n \n    \n    var lobjLanguageCell;\n         lobjLanguageCell='<TD ><select name =' + lstrLanguageCode + ' style=\"width:95%\" size=\"1\" >';\n      \n         var lobjCombo = eval(document.forms[0].templateLanguage);\n            for(lintCtr=0;lintCtr<lobjCombo.length;lintCtr++) {\n               var lstrCellVal= document.forms[0].templateLanguage[lintCtr].value;\n               var lstrOpt= document.forms[0].templateLanguage[lintCtr].text;\n               lobjLanguageCell = lobjLanguageCell +'<option value=\"'+lstrCellVal+'\">'+lstrOpt+'</option>';\n            }\n         lobjLanguageCell=lobjLanguageCell+'</select></TD>';\n         \n         var cell2       = row.insertCell(1);\n         cell2.setAttribute(\"width\", \"13%\");\n         cell2.innerHTML = lobjLanguageCell;\n    \n    \n    var cell3 = row.insertCell(2);\n    cell3.setAttribute(\"width\", \"11%\");\n    cell3.innerHTML = \"<TD  class='whitebg'>\"+\n                            \"<textarea rows='1' cols='6'  value='' class='non_edit' readOnly='true'  name='value[\"+rowIndex+\"].subject' ></textarea>\"+\n                            \"&nbsp;&nbsp;<input type='button' value='. . .' name='btnBodyHeaderLookup' class='btnbutton' onclick='openVariableLookup(\"+1+\",\"+rowIndex+\")'/>\"+\n                        \"</TD>\";\n    var cell4 = row.insertCell(3);\n    cell4.setAttribute(\"width\", \"12%\");\n    cell4.innerHTML = \"<TD  class='whitebg'>\"+\n                            \"<textarea rows='1' cols='6' value=''  class='non_edit' readOnly='true' name='value[\"+rowIndex+\"].bodyHeader' ></textarea>\"+\n                            \"&nbsp;&nbsp;<input type='button' value='. . .' name='btnBodyHeaderLookup' class='btnbutton' onclick='openVariableLookup(\"+2+\",\"+rowIndex+\")'/>\"+\n                        \"</TD>\";\n    var cell5 = row.insertCell(4);\n    cell5.setAttribute(\"width\", \"12%\");\n    cell5.innerHTML = \"<TD  class='whitebg'>\"+\n                            \"<textarea rows='1' cols='6' value=''  class='non_edit' readOnly='true' name='value[\"+rowIndex+\"].bodyDetail' ></textarea>\"+\n                            \"&nbsp;&nbsp;<input type='button' value='. . .' name='btnBodyHeaderLookup' class='btnbutton' onclick='openVariableLookup(\"+3+\",\"+rowIndex+\")'/>\"+\n                        \"</TD>\";\n    var cell6 = row.insertCell(5);\n    cell6.setAttribute(\"width\", \"12%\");\n    cell6.innerHTML = \"<TD  class='whitebg'>\"+\n                            \"<textarea rows='1' cols='6' value=''  class='non_edit' readOnly='true' name='value[\"+rowIndex+\"].bodyFooter' ></textarea>\"+\n                            \"&nbsp;&nbsp;<input type='button' value='. . .' name='btnBodyHeaderLookup' class='btnbutton' onclick='openVariableLookup(\"+4+\",\"+rowIndex+\")'/>\"+\n                        \"</TD>\";\n    var flagCell  = '<td  class=\"whitebg\"><select name = ' +attachmentFlag + ' style=\"width:95%;height:20px\" size=\"1\" class=\"must\" >';\n    flagCell=  flagCell + '<option value=\"Y\">Yes </option>'\n                        + '<option value=\"N\">No</option>';\n    flagCell = flagCell + '</select></td>';\n    var cell7 = row.insertCell(6);\n    cell7.setAttribute(\"width\", \"12%\");\n    cell7.innerHTML = flagCell;\n    \n    var statusCell  = '<td  class=\"whitebg\"><select name = ' +statusValue + ' size=\"1\" style=\"width:95%;height:20px\" class=\"must\" >';\n    statusCell=  statusCell + '<option value=\"A\">Active </option>'\n                            + '<option value=\"S\">Suspended</option>';\n    statusCell = statusCell + '</select></td>';\n    var cell8 = row.insertCell(7);\n    cell8.setAttribute(\"width\", \"8%\");\n    cell8.innerHTML = statusCell;\n    \n    var previewCell = \"<TD><input type='button' value='. . .' name='btnBodyHeaderLookup' class='btnbutton' onclick='openPreview(\"+rowIndex+\")'/><TD>\";\n    var cell9 = row.insertCell(8);\n    cell9.className = \"center\";\n    cell9.innerHTML = previewCell;\n    \n    return false;\n        \n    }\n    \n    /*To reset theoriginal search criteria before processing*/\n    function resetSearchCriteria() {\n        document.getElementById(\"noticeType\").value = lastNoticeTyp;\n    }\n\n    function openHelp() {\n        \n        var strFileName = '1';\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\n        objWindow.focus();\n    }    \n    \n    function openPreview(aintIndex) {\n        document.getElementById(\"mselectedSubject\").value = document.getElementById('value[' + aintIndex + '].subject').value;\n        document.getElementById(\"mselectedHeader\").value = document.getElementById('value[' + aintIndex + '].bodyHeader').value;\n        document.getElementById(\"mselectedDetail\").value = document.getElementById('value[' + aintIndex + '].bodyDetail').value;\n        document.getElementById(\"mselectedFooter\").value = document.getElementById('value[' + aintIndex + '].bodyFooter').value;\n        \n        var urlStr = '".toCharArray();
    __oracle_jsp_text[10] = 
    "';\n        //window.open(urlStr,'secm009','height=600px','width=1500px');\n        window.open(urlStr,'secm009');\n    }\n    \n    function getControlsForPreview() {\n        var subject = document.getElementById(\"mselectedSubject\").value ;\n        var body    = document.getElementById(\"mselectedHeader\").value + \"\\n\" +  document.getElementById(\"mselectedDetail\").value + \"\\n\" + document.getElementById(\"mselectedFooter\").value;\n        \n        return (subject + \"~\" + body) ;\n    }\n    \n</SCRIPT>\n</HEAD>\n<BODY onload='javascript:onLoad()' onunload=\"javascript:doCloseAllChilds()\">\n\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\n<input type=\"hidden\" name=\"mselectedControl\" />\n<input type=\"hidden\" name=\"mselectedSubject\" />\n<input type=\"hidden\" name=\"mselectedHeader\" />\n<input type=\"hidden\" name=\"mselectedDetail\" />\n<input type=\"hidden\" name=\"mselectedFooter\" />   \n".toCharArray();
    __oracle_jsp_text[12] = 
    " \n    ".toCharArray();
    __oracle_jsp_text[13] = 
    "\n    <div class=\"text_header\"><h2>E-Notice Template</h2></div>\n    <TABLE CLASS=\"table_search\" BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"0\" CELLPADDING=\"0\">\n        <TR>\n            <TD width=\"80px\">Notice Type</TD>\n            <TD width=\"250px\" CLASS=\"whitebg\">\n                ".toCharArray();
    __oracle_jsp_text[14] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[15] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[16] = 
    "    \n            </TD>\n            <TD>\n            </TD>\n            </TD>\n            \n        </TR>\n    \n        \n    </TABLE>\n    ".toCharArray();
    __oracle_jsp_text[17] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[18] = 
    "    \n    <DIV CLASS=\"buttons_box\">\n        <INPUT TYPE=\"button\" VALUE=\"Find\" NAME=\"btnFind\" CLASS=\"event_btnbutton\" ONCLICK='return onSearch()'/>\n        \n    </DIV>\n    ".toCharArray();
    __oracle_jsp_text[19] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[20] = 
    "    \n    <DIV CLASS=\"text_header\"><H2>Search Results</H2></DIV>   \n        <TABLE ID=\"result_hdr\" class=\"header\" BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"0\" WIDTH=\"100%\">\n            <THEAD>\n                <TR>\n                    <TH STYLE=\"WIDTH:15%;HEIGHT:20px;\" class=\"center\">Template Description</TH>\n                    <TH  STYLE=\"WIDTH:13%\">Template Language</TH>\n                    <TH STYLE=\"WIDTH:11%\">Subject</TH>\n                    <TH STYLE=\"WIDTH:12%\">Body Header</TH>\n                    <TH STYLE=\"WIDTH:12%\">Body Detail</TH>\n                    <TH STYLE=\"WIDTH:12%\">Body Footer</TH>\n                    <TH STYLE=\"WIDTH:12%\">Attachment Flag</TH>\n                    <TH STYLE=\"WIDTH:8%\">Record Status</TH>\n                    <TH >Preview</TH>\n                </TR>            \n            </THEAD>\n        </TABLE>   \n        \n        <DIV ID=\"search_result\" CLASS=\"search_result\" STYLE=\"HEIGHT:325px;WIDTH:100%\">\n        \n        <TABLE ID=\"result_dtl\" CLASS=\"table_results\"  BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"0\" >\n      \n            <TBODY>\n            \n                ".toCharArray();
    __oracle_jsp_text[21] = 
    "\n                    <TR >\n                        <TD width=\"15%\" class=\"left\">\n                                                    ".toCharArray();
    __oracle_jsp_text[22] = 
    "\n                                                </TD>\n                        <TD width=\"13%\">\n                            ".toCharArray();
    __oracle_jsp_text[23] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[24] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[25] = 
    "\n                        </TD>\n                        <TD width=\"11%\" >\n                            ".toCharArray();
    __oracle_jsp_text[26] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[27] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[28] = 
    "\n                            <input type=\"button\" value=\". . .\" name=\"btnLevelKeyLookup\" class=\"btnbutton\" onclick='".toCharArray();
    __oracle_jsp_text[29] = 
    "'/>\n                        </TD>\n                        <TD  width=\"12%\">\n                            \n                            ".toCharArray();
    __oracle_jsp_text[30] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[31] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[32] = 
    "\n                                                        <input type=\"button\" value=\". . .\" name=\"btnBodyHeaderLookup\" class=\"btnbutton\" onclick='".toCharArray();
    __oracle_jsp_text[33] = 
    "'/>\n                        </TD>\n                        <TD width=\"12%\">\n                            \n                            ".toCharArray();
    __oracle_jsp_text[34] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[35] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[36] = 
    "\n                                                        <input type=\"button\" value=\". . .\" name=\"btnBodyDetailLookup\" class=\"btnbutton\" onclick='".toCharArray();
    __oracle_jsp_text[37] = 
    "'/>\n                        </TD>\n                        <TD width=\"12%\">\n                            \n                            ".toCharArray();
    __oracle_jsp_text[38] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[39] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[40] = 
    "\n                                                        <input type=\"button\" value=\". . .\" name=\"btnBodyFooterLookup\" class=\"btnbutton\" onclick='".toCharArray();
    __oracle_jsp_text[41] = 
    "'/>\n                        </TD>\n                        <TD width=\"12%\">\n                                                \n                            ".toCharArray();
    __oracle_jsp_text[42] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[43] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[44] = 
    "\n                        </TD>\n                        <TD WIDTH=\"8%\">\n                            ".toCharArray();
    __oracle_jsp_text[45] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[46] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[47] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[48] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[49] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[50] = 
    "\n                        </TD>\n                        <TD class=\"center\"><input type=\"button\" value=\". . .\" name=\"btnLevelKeyLookup\" class=\"btnbutton\" onclick='".toCharArray();
    __oracle_jsp_text[51] = 
    "'/>\n                        </TD>\n                    </TR>\n                ".toCharArray();
    __oracle_jsp_text[52] = 
    "\n                \n            </TBODY>\n        </TABLE>\n        </DIV>\n ".toCharArray();
    __oracle_jsp_text[53] = 
    "\n  <div class=\"buttons_box\">\n       <input type=\"button\" value=\"Add\" name=\"btnAdd\" class=\"event_btnbutton\" onclick='return addRow()'/>\n        ".toCharArray();
    __oracle_jsp_text[54] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[55] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[56] = 
    "\n    </div>\n \n <br>\n \n  \n".toCharArray();
    __oracle_jsp_text[57] = 
    "\n</BODY>\n</HTML>\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
