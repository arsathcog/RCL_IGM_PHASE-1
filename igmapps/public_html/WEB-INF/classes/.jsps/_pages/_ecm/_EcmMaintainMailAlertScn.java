package _pages._ecm;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _EcmMaintainMailAlertScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EcmMaintainMailAlertScn page = this;
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
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm007search", pageContext));
      out.write(__oracle_jsp_text[7]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm007", pageContext));
      out.write(__oracle_jsp_text[8]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm007search", pageContext));
      out.write(__oracle_jsp_text[9]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm008", pageContext));
      out.write(__oracle_jsp_text[10]);
      out.write(__oracle_jsp_text[11]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm007save", pageContext));
      out.write(__oracle_jsp_text[12]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/secm007");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setName("fecm007");
              __jsp_taghandler_2.setProperty("searchPerformed");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[14]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_3=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setName("fecm007");
              __jsp_taghandler_3.setProperty("searchOn");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[15]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_4=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fecm007");
              __jsp_taghandler_4.setProperty("organizationDesc");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[16]);
            out.write(__oracle_jsp_text[17]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_5=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setName("fecm007");
              __jsp_taghandler_5.setOnclick("onSelect()");
              __jsp_taghandler_5.setProperty("radioGroup");
              __jsp_taghandler_5.setStyleClass("check");
              __jsp_taghandler_5.setValue("noticeType");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[18]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_6=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setName("fecm007");
              __jsp_taghandler_6.setOnclick("onSelect()");
              __jsp_taghandler_6.setProperty("radioGroup");
              __jsp_taghandler_6.setStyleClass("check");
              __jsp_taghandler_6.setValue("organizationType");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[19]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_7=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag property");
              __jsp_taghandler_7.setParent(__jsp_taghandler_1);
              __jsp_taghandler_7.setProperty("orgType");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_7,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[20]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_8=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_8.setParent(__jsp_taghandler_7);
                    __jsp_taghandler_8.setLabel("name");
                    __jsp_taghandler_8.setName("fecm007");
                    __jsp_taghandler_8.setProperty("organizationTypeValues");
                    __jsp_taghandler_8.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
                    if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,3);
                  }
                  out.write(__oracle_jsp_text[21]);
                } while (__jsp_taghandler_7.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[22]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_9=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag property");
              __jsp_taghandler_9.setParent(__jsp_taghandler_1);
              __jsp_taghandler_9.setProperty("templateDescription");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_9,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[23]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_10=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_10.setParent(__jsp_taghandler_9);
                    __jsp_taghandler_10.setLabel("name");
                    __jsp_taghandler_10.setName("fecm007");
                    __jsp_taghandler_10.setProperty("templateDescriptionValues");
                    __jsp_taghandler_10.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
                    if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,3);
                  }
                  out.write(__oracle_jsp_text[24]);
                } while (__jsp_taghandler_9.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[25]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_11=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
              __jsp_taghandler_11.setParent(__jsp_taghandler_1);
              __jsp_taghandler_11.setName("fecm007");
              __jsp_taghandler_11.setProperty("noticeType");
              __jsp_taghandler_11.setStyle("width:95%");
              __jsp_taghandler_11.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_11,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[26]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_12=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_12.setParent(__jsp_taghandler_11);
                    __jsp_taghandler_12.setLabel("name");
                    __jsp_taghandler_12.setName("fecm007");
                    __jsp_taghandler_12.setProperty("noticeTypeValues");
                    __jsp_taghandler_12.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
                    if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,3);
                  }
                  out.write(__oracle_jsp_text[27]);
                } while (__jsp_taghandler_11.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[28]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_13=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
              __jsp_taghandler_13.setParent(__jsp_taghandler_1);
              __jsp_taghandler_13.setName("fecm007");
              __jsp_taghandler_13.setOnchange("comboChange(-1)");
              __jsp_taghandler_13.setProperty("organizationType");
              __jsp_taghandler_13.setStyle("width:95%");
              __jsp_taghandler_13.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_13,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[29]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_14=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_14.setParent(__jsp_taghandler_13);
                    __jsp_taghandler_14.setLabel("name");
                    __jsp_taghandler_14.setName("fecm007");
                    __jsp_taghandler_14.setProperty("organizationTypeValues");
                    __jsp_taghandler_14.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
                    if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,3);
                  }
                  out.write(__oracle_jsp_text[30]);
                } while (__jsp_taghandler_13.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,2);
            }
            out.write(__oracle_jsp_text[31]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_15=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_15.setParent(__jsp_taghandler_1);
              __jsp_taghandler_15.setMaxlength("1000");
              __jsp_taghandler_15.setName("fecm007");
              __jsp_taghandler_15.setProperty("recipientOrganization");
              __jsp_taghandler_15.setReadonly(true);
              __jsp_taghandler_15.setStyle("width:150px");
              __jsp_taghandler_15.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
              if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,2);
            }
            out.write(__oracle_jsp_text[32]);
            out.write(__oracle_jsp_text[33]);
            out.write(__oracle_jsp_text[34]);
            {
              org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_16=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
              __jsp_taghandler_16.setParent(__jsp_taghandler_1);
              __jsp_taghandler_16.setId("rowdata");
              __jsp_taghandler_16.setIndexId("ctr");
              __jsp_taghandler_16.setName("fecm007");
              __jsp_taghandler_16.setProperty("values");
              __jsp_taghandler_16.setType("com.rclgroup.dolphin.ezl.web.ecm.vo.EcmMaintainMailAlertMod");
              com.rclgroup.dolphin.ezl.web.ecm.vo.EcmMaintainMailAlertMod rowdata = null;
              java.lang.Integer ctr = null;
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_16,__jsp_tag_starteval,out);
                do {
                  rowdata = (com.rclgroup.dolphin.ezl.web.ecm.vo.EcmMaintainMailAlertMod) pageContext.findAttribute("rowdata");
                  ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
                  out.write(__oracle_jsp_text[35]);
                  out.print( "row" + ctr );
                  out.write(__oracle_jsp_text[36]);
                  {
                    org.apache.struts.taglib.html.RadioTag __jsp_taghandler_17=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
                    __jsp_taghandler_17.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_17.setName("fecm007");
                    __jsp_taghandler_17.setOnclick(OracleJspRuntime.toStr( "highlightRow("+ctr+")"));
                    __jsp_taghandler_17.setProperty("radioGroup1");
                    __jsp_taghandler_17.setStyleClass("check");
                    __jsp_taghandler_17.setValue(OracleJspRuntime.toStr( ctr));
                    __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
                    if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,3);
                  }
                  out.write(__oracle_jsp_text[37]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_18=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_18.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_18.setName("fecm007");
                    __jsp_taghandler_18.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].selectedIndexTempDesc"));
                    __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
                    if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,3);
                  }
                  out.write(__oracle_jsp_text[38]);
                  {
                    org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_19=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                    __jsp_taghandler_19.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_19.setName("fecm007");
                    __jsp_taghandler_19.setProperty("searchOn");
                    __jsp_taghandler_19.setValue("organizationType");
                    __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[39]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_20=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_20.setParent(__jsp_taghandler_19);
                          __jsp_taghandler_20.setName("fecm007");
                          __jsp_taghandler_20.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_20.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[40]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_21=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style styleClass size");
                                __jsp_taghandler_21.setParent(__jsp_taghandler_20);
                                __jsp_taghandler_21.setName("fecm007");
                                __jsp_taghandler_21.setOnchange(OracleJspRuntime.toStr( "noticeTypeComboChange("+ctr+")"));
                                __jsp_taghandler_21.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].noticeType"));
                                __jsp_taghandler_21.setStyle("height:25px;");
                                __jsp_taghandler_21.setStyleClass("must");
                                __jsp_taghandler_21.setSize("1");
                                __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_21,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[41]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_22=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_22.setParent(__jsp_taghandler_21);
                                      __jsp_taghandler_22.setLabel("name");
                                      __jsp_taghandler_22.setName("fecm007");
                                      __jsp_taghandler_22.setProperty("noticeTypeValues");
                                      __jsp_taghandler_22.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
                                      if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,6);
                                    }
                                    out.write(__oracle_jsp_text[42]);
                                  } while (__jsp_taghandler_21.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,5);
                              }
                              out.write(__oracle_jsp_text[43]);
                            } while (__jsp_taghandler_20.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,4);
                        }
                        out.write(__oracle_jsp_text[44]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_23=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_23.setParent(__jsp_taghandler_19);
                          __jsp_taghandler_23.setName("fecm007");
                          __jsp_taghandler_23.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_23.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[45]);
                              {
                                org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_24=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                                __jsp_taghandler_24.setParent(__jsp_taghandler_23);
                                __jsp_taghandler_24.setName("fecm007");
                                __jsp_taghandler_24.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].noticeType"));
                                __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
                                if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,5);
                              }
                              out.write(__oracle_jsp_text[46]);
                            } while (__jsp_taghandler_23.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,4);
                        }
                        out.write(__oracle_jsp_text[47]);
                      } while (__jsp_taghandler_19.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,3);
                  }
                  out.write(__oracle_jsp_text[48]);
                  {
                    org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_25=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                    __jsp_taghandler_25.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_25.setName("fecm007");
                    __jsp_taghandler_25.setProperty("searchOn");
                    __jsp_taghandler_25.setValue("organizationType");
                    __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[49]);
                        {
                          org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_26=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                          __jsp_taghandler_26.setParent(__jsp_taghandler_25);
                          __jsp_taghandler_26.setName("fecm007");
                          __jsp_taghandler_26.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].noticeType"));
                          __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
                          if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,4);
                        }
                        out.write(__oracle_jsp_text[50]);
                      } while (__jsp_taghandler_25.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,3);
                  }
                  out.write(__oracle_jsp_text[51]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_27=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_27.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_27.setName("fecm007");
                    __jsp_taghandler_27.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].noticeType"));
                    __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
                    if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,3);
                  }
                  out.write(__oracle_jsp_text[52]);
                  {
                    org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_28=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                    __jsp_taghandler_28.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_28.setName("fecm007");
                    __jsp_taghandler_28.setProperty("searchOn");
                    __jsp_taghandler_28.setValue("organizationType");
                    __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[53]);
                        {
                          org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_29=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                          __jsp_taghandler_29.setParent(__jsp_taghandler_28);
                          __jsp_taghandler_29.setName("fecm007");
                          __jsp_taghandler_29.setProperty("organizationDesc");
                          __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
                          if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,4);
                        }
                        out.write(__oracle_jsp_text[54]);
                      } while (__jsp_taghandler_28.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,3);
                  }
                  out.write(__oracle_jsp_text[55]);
                  {
                    org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_30=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                    __jsp_taghandler_30.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_30.setName("fecm007");
                    __jsp_taghandler_30.setProperty("searchOn");
                    __jsp_taghandler_30.setValue("organizationType");
                    __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[56]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_31=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_31.setParent(__jsp_taghandler_30);
                          __jsp_taghandler_31.setName("fecm007");
                          __jsp_taghandler_31.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_31.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[57]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_32=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style styleClass size");
                                __jsp_taghandler_32.setParent(__jsp_taghandler_31);
                                __jsp_taghandler_32.setName("fecm007");
                                __jsp_taghandler_32.setOnchange(OracleJspRuntime.toStr( "comboChange("+ctr+")"));
                                __jsp_taghandler_32.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].organizationType"));
                                __jsp_taghandler_32.setStyle("width:95%;height:25px;");
                                __jsp_taghandler_32.setStyleClass("must");
                                __jsp_taghandler_32.setSize("1");
                                __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_32,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[58]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_33=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_33.setParent(__jsp_taghandler_32);
                                      __jsp_taghandler_33.setLabel("name");
                                      __jsp_taghandler_33.setName("fecm007");
                                      __jsp_taghandler_33.setProperty("organizationTypeValues");
                                      __jsp_taghandler_33.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
                                      if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,6);
                                    }
                                    out.write(__oracle_jsp_text[59]);
                                  } while (__jsp_taghandler_32.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,5);
                              }
                              out.write(__oracle_jsp_text[60]);
                            } while (__jsp_taghandler_31.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,4);
                        }
                        out.write(__oracle_jsp_text[61]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_34=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_34.setParent(__jsp_taghandler_30);
                          __jsp_taghandler_34.setName("fecm007");
                          __jsp_taghandler_34.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_34.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[62]);
                              {
                                org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_35=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                                __jsp_taghandler_35.setParent(__jsp_taghandler_34);
                                __jsp_taghandler_35.setName("fecm007");
                                __jsp_taghandler_35.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].organizationType"));
                                __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
                                if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,5);
                              }
                              out.write(__oracle_jsp_text[63]);
                            } while (__jsp_taghandler_34.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,4);
                        }
                        out.write(__oracle_jsp_text[64]);
                      } while (__jsp_taghandler_30.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,3);
                  }
                  out.write(__oracle_jsp_text[65]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_36=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_36.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_36.setName("fecm007");
                    __jsp_taghandler_36.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].organizationType"));
                    __jsp_tag_starteval=__jsp_taghandler_36.doStartTag();
                    if (__jsp_taghandler_36.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_36,3);
                  }
                  out.write(__oracle_jsp_text[66]);
                  {
                    org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_37=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                    __jsp_taghandler_37.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_37.setName("fecm007");
                    __jsp_taghandler_37.setProperty("searchOn");
                    __jsp_taghandler_37.setValue("organizationType");
                    __jsp_tag_starteval=__jsp_taghandler_37.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[67]);
                        {
                          org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_38=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                          __jsp_taghandler_38.setParent(__jsp_taghandler_37);
                          __jsp_taghandler_38.setName("fecm007");
                          __jsp_taghandler_38.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].recipientOrganization"));
                          __jsp_tag_starteval=__jsp_taghandler_38.doStartTag();
                          if (__jsp_taghandler_38.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_38,4);
                        }
                        out.write(__oracle_jsp_text[68]);
                      } while (__jsp_taghandler_37.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_37.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_37,3);
                  }
                  out.write(__oracle_jsp_text[69]);
                  {
                    org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_39=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                    __jsp_taghandler_39.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_39.setName("fecm007");
                    __jsp_taghandler_39.setProperty("searchOn");
                    __jsp_taghandler_39.setValue("organizationType");
                    __jsp_tag_starteval=__jsp_taghandler_39.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[70]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_40=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_40.setParent(__jsp_taghandler_39);
                          __jsp_taghandler_40.setName("fecm007");
                          __jsp_taghandler_40.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_40.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_40.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[71]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_41=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_41.setParent(__jsp_taghandler_40);
                                __jsp_taghandler_41.setMaxlength("1000");
                                __jsp_taghandler_41.setName("fecm007");
                                __jsp_taghandler_41.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].recipientOrganization"));
                                __jsp_taghandler_41.setReadonly(true);
                                __jsp_taghandler_41.setStyle("width:125px");
                                __jsp_taghandler_41.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_41.doStartTag();
                                if (__jsp_taghandler_41.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_41,5);
                              }
                              out.write(__oracle_jsp_text[72]);
                              out.print(ctr);
                              out.write(__oracle_jsp_text[73]);
                            } while (__jsp_taghandler_40.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_40.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_40,4);
                        }
                        out.write(__oracle_jsp_text[74]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_42=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_42.setParent(__jsp_taghandler_39);
                          __jsp_taghandler_42.setName("fecm007");
                          __jsp_taghandler_42.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_42.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_42.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[75]);
                              {
                                org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_43=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                                __jsp_taghandler_43.setParent(__jsp_taghandler_42);
                                __jsp_taghandler_43.setName("fecm007");
                                __jsp_taghandler_43.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].recipientOrganization"));
                                __jsp_tag_starteval=__jsp_taghandler_43.doStartTag();
                                if (__jsp_taghandler_43.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_43,5);
                              }
                              out.write(__oracle_jsp_text[76]);
                            } while (__jsp_taghandler_42.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_42.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_42,4);
                        }
                        out.write(__oracle_jsp_text[77]);
                      } while (__jsp_taghandler_39.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_39.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_39,3);
                  }
                  out.write(__oracle_jsp_text[78]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_44=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_44.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_44.setName("fecm007");
                    __jsp_taghandler_44.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].recipientOrganization"));
                    __jsp_tag_starteval=__jsp_taghandler_44.doStartTag();
                    if (__jsp_taghandler_44.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_44,3);
                  }
                  out.write(__oracle_jsp_text[79]);
                  {
                    org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_45=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                    __jsp_taghandler_45.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_45.setName("fecm007");
                    __jsp_taghandler_45.setProperty("searchOn");
                    __jsp_taghandler_45.setValue("organizationType");
                    __jsp_tag_starteval=__jsp_taghandler_45.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[80]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_46=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_46.setParent(__jsp_taghandler_45);
                          __jsp_taghandler_46.setName("fecm007");
                          __jsp_taghandler_46.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_46.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_46.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[81]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_47=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style styleClass size");
                                __jsp_taghandler_47.setParent(__jsp_taghandler_46);
                                __jsp_taghandler_47.setName("fecm007");
                                __jsp_taghandler_47.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].templateDesc"));
                                __jsp_taghandler_47.setStyle("width:95%;height:25px;");
                                __jsp_taghandler_47.setStyleClass("must");
                                __jsp_taghandler_47.setSize("1");
                                __jsp_tag_starteval=__jsp_taghandler_47.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_47,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[82]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_48=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_48.setParent(__jsp_taghandler_47);
                                      __jsp_taghandler_48.setValue(" ");
                                      __jsp_tag_starteval=__jsp_taghandler_48.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_48,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[83]);
                                        } while (__jsp_taghandler_48.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_48.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_48,6);
                                    }
                                    out.write(__oracle_jsp_text[84]);
                                    out.print(ctr);
                                    out.write(__oracle_jsp_text[85]);
                                  } while (__jsp_taghandler_47.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_47.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_47,5);
                              }
                              out.write(__oracle_jsp_text[86]);
                            } while (__jsp_taghandler_46.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_46.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_46,4);
                        }
                        out.write(__oracle_jsp_text[87]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_49=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_49.setParent(__jsp_taghandler_45);
                          __jsp_taghandler_49.setName("fecm007");
                          __jsp_taghandler_49.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_49.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_49.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[88]);
                              {
                                org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_50=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                                __jsp_taghandler_50.setParent(__jsp_taghandler_49);
                                __jsp_taghandler_50.setName("fecm007");
                                __jsp_taghandler_50.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].templateDesc"));
                                __jsp_tag_starteval=__jsp_taghandler_50.doStartTag();
                                if (__jsp_taghandler_50.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_50,5);
                              }
                              out.write(__oracle_jsp_text[89]);
                            } while (__jsp_taghandler_49.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_49.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_49,4);
                        }
                        out.write(__oracle_jsp_text[90]);
                      } while (__jsp_taghandler_45.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_45.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_45,3);
                  }
                  out.write(__oracle_jsp_text[91]);
                  {
                    org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_51=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                    __jsp_taghandler_51.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_51.setName("fecm007");
                    __jsp_taghandler_51.setProperty("searchOn");
                    __jsp_taghandler_51.setValue("organizationType");
                    __jsp_tag_starteval=__jsp_taghandler_51.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[92]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_52=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_52.setParent(__jsp_taghandler_51);
                          __jsp_taghandler_52.setName("fecm007");
                          __jsp_taghandler_52.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_52.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_52.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[93]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_53=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style styleClass size");
                                __jsp_taghandler_53.setParent(__jsp_taghandler_52);
                                __jsp_taghandler_53.setName("fecm007");
                                __jsp_taghandler_53.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].templateDesc"));
                                __jsp_taghandler_53.setStyle("width:95%;height:25px;");
                                __jsp_taghandler_53.setStyleClass("must");
                                __jsp_taghandler_53.setSize("1");
                                __jsp_tag_starteval=__jsp_taghandler_53.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_53,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[94]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_54=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_54.setParent(__jsp_taghandler_53);
                                      __jsp_taghandler_54.setLabel("name");
                                      __jsp_taghandler_54.setName("fecm007");
                                      __jsp_taghandler_54.setProperty("templateDescriptionValues");
                                      __jsp_taghandler_54.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_54.doStartTag();
                                      if (__jsp_taghandler_54.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_54,6);
                                    }
                                    out.write(__oracle_jsp_text[95]);
                                  } while (__jsp_taghandler_53.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_53.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_53,5);
                              }
                              out.write(__oracle_jsp_text[96]);
                            } while (__jsp_taghandler_52.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_52.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_52,4);
                        }
                        out.write(__oracle_jsp_text[97]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_55=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_55.setParent(__jsp_taghandler_51);
                          __jsp_taghandler_55.setName("fecm007");
                          __jsp_taghandler_55.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                          __jsp_taghandler_55.setValue("ADD");
                          __jsp_tag_starteval=__jsp_taghandler_55.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[98]);
                              {
                                org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_56=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                                __jsp_taghandler_56.setParent(__jsp_taghandler_55);
                                __jsp_taghandler_56.setName("fecm007");
                                __jsp_taghandler_56.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].templateDesc"));
                                __jsp_tag_starteval=__jsp_taghandler_56.doStartTag();
                                if (__jsp_taghandler_56.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_56,5);
                              }
                              out.write(__oracle_jsp_text[99]);
                            } while (__jsp_taghandler_55.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_55.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_55,4);
                        }
                        out.write(__oracle_jsp_text[100]);
                      } while (__jsp_taghandler_51.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_51.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_51,3);
                  }
                  out.write(__oracle_jsp_text[101]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_57=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_57.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_57.setName("fecm007");
                    __jsp_taghandler_57.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].templateDesc"));
                    __jsp_tag_starteval=__jsp_taghandler_57.doStartTag();
                    if (__jsp_taghandler_57.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_57,3);
                  }
                  out.write(__oracle_jsp_text[102]);
                  {
                    org.apache.struts.taglib.html.SelectTag __jsp_taghandler_58=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style styleClass size");
                    __jsp_taghandler_58.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_58.setName("fecm007");
                    __jsp_taghandler_58.setOnchange(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_58.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].priority"));
                    __jsp_taghandler_58.setStyle("width:100px;height:25px");
                    __jsp_taghandler_58.setStyleClass("must");
                    __jsp_taghandler_58.setSize("1");
                    __jsp_tag_starteval=__jsp_taghandler_58.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_58,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[103]);
                        {
                          org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_59=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                          __jsp_taghandler_59.setParent(__jsp_taghandler_58);
                          __jsp_taghandler_59.setLabel("name");
                          __jsp_taghandler_59.setName("fecm007");
                          __jsp_taghandler_59.setProperty("priorityValues");
                          __jsp_taghandler_59.setValue("code");
                          __jsp_tag_starteval=__jsp_taghandler_59.doStartTag();
                          if (__jsp_taghandler_59.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_59,4);
                        }
                        out.write(__oracle_jsp_text[104]);
                      } while (__jsp_taghandler_58.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_58.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_58,3);
                  }
                  out.write(__oracle_jsp_text[105]);
                  {
                    org.apache.struts.taglib.html.SelectTag __jsp_taghandler_60=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style styleClass size");
                    __jsp_taghandler_60.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_60.setName("fecm007");
                    __jsp_taghandler_60.setOnchange(OracleJspRuntime.toStr( "updateRecordStatus("+ctr+")"));
                    __jsp_taghandler_60.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].recordStatus"));
                    __jsp_taghandler_60.setStyle("width:95%;height:25px;");
                    __jsp_taghandler_60.setStyleClass("must");
                    __jsp_taghandler_60.setSize("1");
                    __jsp_tag_starteval=__jsp_taghandler_60.doStartTag();
                    if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                    {
                      out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_60,__jsp_tag_starteval,out);
                      do {
                        out.write(__oracle_jsp_text[106]);
                        {
                          org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_61=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                          __jsp_taghandler_61.setParent(__jsp_taghandler_60);
                          __jsp_taghandler_61.setLabel("name");
                          __jsp_taghandler_61.setName("fecm007");
                          __jsp_taghandler_61.setProperty("recStatusValues");
                          __jsp_taghandler_61.setValue("code");
                          __jsp_tag_starteval=__jsp_taghandler_61.doStartTag();
                          if (__jsp_taghandler_61.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_61,4);
                        }
                        out.write(__oracle_jsp_text[107]);
                      } while (__jsp_taghandler_60.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                      out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                    }
                    if (__jsp_taghandler_60.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_60,3);
                  }
                  out.write(__oracle_jsp_text[108]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_62=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_62.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_62.setName("fecm007");
                    __jsp_taghandler_62.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].status"));
                    __jsp_tag_starteval=__jsp_taghandler_62.doStartTag();
                    if (__jsp_taghandler_62.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_62,3);
                  }
                  out.write(__oracle_jsp_text[109]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_63=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_63.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_63.setName("fecm007");
                    __jsp_taghandler_63.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].updTime"));
                    __jsp_tag_starteval=__jsp_taghandler_63.doStartTag();
                    if (__jsp_taghandler_63.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_63,3);
                  }
                  out.write(__oracle_jsp_text[110]);
                  {
                    org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_64=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
                    __jsp_taghandler_64.setParent(__jsp_taghandler_16);
                    __jsp_taghandler_64.setName("fecm007");
                    __jsp_taghandler_64.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].recieverId"));
                    __jsp_tag_starteval=__jsp_taghandler_64.doStartTag();
                    if (__jsp_taghandler_64.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_64,3);
                  }
                  out.write(__oracle_jsp_text[111]);
                } while (__jsp_taghandler_16.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[112]);
            out.write(__oracle_jsp_text[113]);
            {
              String __url=OracleJspRuntime.toStr("../common/tiles/pagination.jsp");
              __url=OracleJspRuntime.genPageUrl(__url,request,response,new String[] {"formName" } ,new String[] {OracleJspRuntime.toStr("fecm007") } );
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[114]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[115]);

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
  private static final char __oracle_jsp_text[][]=new char[116][];
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
    "/css/EZL.css\"/>\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \n    <STYLE TYPE=\"text/css\">\n         div.search_result{height:100px;}\n         table.table_results tbody{height:100px;}\n    </STYLE>\n    <!--[if IE]>\n        <style type=\"text/css\">\n            div.search_result {\n                position: relative;\n                height: 180px;\n                width: 100%;\n                overflow-y: scroll;\n                overflow-x: hidden;\n            }\n            table.table_results{width:99%}\n           \n            table.table_results thead tr {\n                position: absolute;width:100%;\n                top: expression(this.offsetParent.scrollTop);\n            }\n            table.table_results tbody {\n                height: auto;\n            }\n            /*table.table_results tbody tr td.first_row {\n                padding-top: 24px;}*/}\n             table.header{width:99%; }             \n        </style>\n    <![endif]-->   \n    \n\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\n    var FORM_ID       = 'fecm007';\n    var currselrowid  = 'row0';\n    var searchPerformed = '';\n    var findDone      = 'false';\n   var lastNoticetype = '';\n   var lastOrganizationType ='';\n   var lastRecipient   = '';\n   var lastRadioSelected = '';\n    \n    /*Called by framework on-load of this JSP*/\n    function onLoad() {    \n        //document.forms[0].templateLanguage.style.display = \"none\";\n        document.forms[0].orgType.style.display = \"none\";\n        document.forms[0].templateDescription.style.display = \"none\";\n        searchPerformed   = document.getElementById(\"searchPerformed\").value;\n        if(document.forms[0].radioGroup[0].checked == false && document.forms[0].radioGroup[1].checked == false) {\n            document.forms[0].radioGroup[0].checked = true;\n            \n        }\n        onSelect();\n        lastNoticetype        = document.getElementById(\"noticetype\").value;\n        lastOrganizationType  = document.getElementById(\"organizationtype\").value;\n        lastRecipient         = document.getElementById(\"recipientOrganization\").value;\n        if(document.forms[0].radioGroup[0].checked == true) {\n            lastRadioSelected = 'noticeType';\n        } else if(document.forms[0].radioGroup[1].checked == true) {\n            lastRadioSelected = 'organizationType';\n        }\n                \n                document.forms[0].searchOn.value = lastRadioSelected;\n    }\n    \n    function openHelp() {\n        \n        var strFileName = '1';\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\n        objWindow.focus();\n    }\n    \n    \n    /*Called by framework for Pagination*/\n    function getActionUrl(){     \n        resetSearchCriteria();\n        lstrUrl = '".toCharArray();
    __oracle_jsp_text[7] = 
    "';\n        document.forms[0].action=lstrUrl;\n        return lstrUrl;\n    }\n     \n    /*To reset theoriginal search criteria before processing*/\n    function resetSearchCriteria() {\n         document.getElementById(\"noticetype\").value = lastNoticetype;\n         document.getElementById(\"organizationtype\").value = lastOrganizationType;\n         document.getElementById(\"recipientOrganization\").value = lastRecipient ;\n         \n         if(lastRadioSelected == 'noticeType') {\n            document.forms[0].radioGroup[0].checked = true;\n         } else if(lastRadioSelected == 'organizationType') {\n            document.forms[0].radioGroup[1].checked = true;\n         }\n         onSelect();\n    }\n    \n    /*Called by framework on reset or refresh for reloading the page*/\n    function onResetForm(){\n        \n        var urlString = '".toCharArray();
    __oracle_jsp_text[8] = 
    "';\n        \n        document.forms[0].currPageNo.value= 1;\n        document.forms[0].totRecord.value=0;\n        \n        document.forms[0].action=urlString;        \n        document.forms[0].submit();        \n        return false;\n    }\n    \n    /*Called by Find Button*/\n    function onSearch() {\n        \n        if(document.forms[0].radioGroup[0].checked == false &&document.forms[0].radioGroup[1].checked == false) {\n            \n                        showBarMessage(ECM_SE0017,ERROR_MSG);\n            return false;\n        } else if(document.forms[0].radioGroup[0].checked == true && (document.forms[0].noticeType.value == '' || document.forms[0].noticeType.value.length == 0)) {\n            showBarMessage(ECM_SE0017,ERROR_MSG);\n            return false;\n        } else if(document.forms[0].radioGroup[1].checked == true && (document.forms[0].organizationType.value == '' || document.forms[0].organizationType.value.length == 0 )) {\n            showBarMessage(ECM_SE0018,ERROR_MSG);\n            return false;\n            \n        } else if(document.forms[0].radioGroup[1].checked == true && (document.forms[0].recipientOrganization.value.length == 0 ||document.forms[0].recipientOrganization.value == '')) {\n            showBarMessage(ECM_SE0019,ERROR_MSG);\n                return false;\n        }\n        \n        var idx = document.getElementById(\"organizationType\").selectedIndex ;\n        var organizationCodeDesc = document.getElementById(\"organizationType\").options[idx].text;\n        document.getElementById(\"organizationDesc\").value  = organizationCodeDesc;\n        \n        //Clear the Data Table\n        clearDiv('search_result');\n       \n        findDone = 'true';\n        //set the action\n        document.getElementById(\"currPageNo\").value= 1;\n        /* Disable all controls */\n        disableOnSubmit();            \n    \n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[9] = 
    "';\n        document.forms[0].submit();\n        return false;\n    }\n    \n    function openRecipientOrganizationLookup(aintIndex) {\n            \n        if(aintIndex == -1) {\n            \n            var recepientOrganization = document.getElementById(\"organizationType\").value;\n            if(recepientOrganization == '') {\n                showBarMessage(ECM_SE0018,ERROR_MSG);\n                return false;\n            }\n            \n            if(recepientOrganization == 'F') {\n                var rowId = aintIndex;\n                 openLookup(FORM_ID, rowId, \"FSC\", '');\n                                 \n                \n            } else if(recepientOrganization == 'V') {\n                var rowId = aintIndex;\n                 openLookup(FORM_ID, rowId, \"VENDOR\", '');\n            } else if(recepientOrganization == 'C') {\n                    var rowId = aintIndex;\n                 openLookup(FORM_ID, rowId, \"CUSTOMER\", '');\n            } else if(recepientOrganization == 'S') {\n                        var rowId = aintIndex;\n                 openLookup(FORM_ID, rowId, \"SYSTEM\", '');\n            }\n        } else {\n        var recepientOrganization = document.getElementById('value[' + aintIndex + '].organizationType').value;\n        if(recepientOrganization == '') {\n                showBarMessage(ECM_SE0018,ERROR_MSG);\n                return false;\n            }\n        \n        if(recepientOrganization == 'F') {\n                var rowId = aintIndex;\n                 openLookup(FORM_ID, rowId, \"FSC\", '');\n                \n            } else if(recepientOrganization == 'V') {\n                    var rowId = aintIndex;\n                 openLookup(FORM_ID, rowId, \"VENDOR\", '');\n            } else if(recepientOrganization == 'C') {\n                    var rowId = aintIndex;\n                 openLookup(FORM_ID, rowId, \"CUSTOMER\", '');\n            } else if(recepientOrganization == 'S') {\n                        var rowId = aintIndex;\n                 openLookup(FORM_ID, rowId, \"SYSTEM\", '');\n            }\n        }\n        \n    }\n        \n        \n    function openRecipientLookup() {\n        \n        var ctr = 0;\n        var table     = document.getElementById(\"result_dtl\");\n        var totalRows = table.rows.length;\n        var recieverId = '';\n        var rowSelected = 'false';\n        var searchPerformed = '';\n        \n        searchPerformed = document.getElementById(\"searchPerformed\").value ;\n        \n        if(searchPerformed == 'false') {\n            showBarMessage(ECM_SE0007,ERROR_MSG);\n            return false;\n        \n        } else     if(totalRows == 0 && searchPerformed == 'true') {\n            showBarMessage(ECM_GE0007,ERROR_MSG);\n            return false;\n        }\n        \n        for(ctr = 0 ; ctr<totalRows ;ctr++) {\n                var value = document.getElementById('value[' + ctr + '].status').value;\n                if(value == 'ADD' || value == 'UPD'){\n                    \n                    showBarMessage(ECM_SE0020,ERROR_MSG);\n                    return ;\n                }\n            \n        }\n        \n        if(document.forms[0].radioGroup1 != null){\n            if(document.forms[0].radioGroup1[0] != null){\n                for( i = 0; i < document.forms[0].radioGroup1.length; i++ )\n                {   if(document.forms[0].radioGroup1[i].checked == true) {\n                                ctr = i;\n                                rowSelected = 'true';\n                                recieverId = document.getElementById('value[' + i + '].recieverId').value;\n                    }\n                    \n                }\n            } else {\n                if(document.forms[0].radioGroup1.checked == false) {\n                rowSelected = 'false';\n                } else {\n                    rowSelected = 'true';\n                }\n                recieverId = document.getElementById('value[' + 0 + '].recieverId').value;\n            }\n        }\n        if(recieverId == '' || recieverId.length==0) {\n            showBarMessage(ECM_GE0007,ERROR_MSG);\n            return false;\n        }\n        if(rowSelected == 'false') {\n            showBarMessage(ECM_GE0007,ERROR_MSG);\n            return false;\n        }\n        \n      var urlStr = '".toCharArray();
    __oracle_jsp_text[10] = 
    "?recieverOrgId='+recieverId;\n        \n         window.open(urlStr,'secm008','height=500px','width=300px');\n        //window.open(urlStr,'secm008','height=500px,width=550px');\n        //openChildWindow(urlStr,window,'600px','500px');\n        //openChildScreen(urlStr,'secm006');\n    //    window.open(urlStr,'secm008');\n        return false;\n    }\n    \n    /*Called by master lookup screens to return selected values*/\n    function setLookupValues(aFormName, aRowId,strMasterId, arrResultData){\n    \n        if(arrResultData[0] == FAILURE){\n            return;\n        }\n        \n        if(aRowId == -1) {\n         if(strMasterId == 'SYSTEM') {\n            document.getElementById(\"recipientOrganization\").value = arrResultData[0] + '~' + arrResultData[1] + '~' + arrResultData[2];\n            } else {\n                document.getElementById(\"recipientOrganization\").value = arrResultData[0];\n            }\n        } else {\n            if(strMasterId == 'SYSTEM') {\n            document.getElementById('value[' + aRowId + '].recipientOrganization').value = arrResultData[0] + '~' + arrResultData[1] + '~' + arrResultData[2];\n            } else {\n                document.getElementById('value[' + aRowId + '].recipientOrganization').value = arrResultData[0];\n            }\n            \n        }\n    }\n    \n    function addRow() {\n            resetSearchCriteria();\n        searchPerformed   = document.getElementById(\"searchPerformed\").value;\n        if(searchPerformed == 'false') {\n            showBarMessage(ECM_SE0007,ERROR_MSG);\n            return false;\n        }\n        if(document.forms[0].radioGroup[0].checked == true) {\n            addRowNoticeType();\n        } else if(document.forms[0].radioGroup[1].checked == true) {\n            addRowOrganizationType();\n        }\n    }\n    \n    function addRowOrganizationType() {\n        searchPerformed   = document.getElementById(\"searchPerformed\").value;\n        if(searchPerformed == 'false') {\n            showBarMessage(ECM_SE0007,ERROR_MSG);\n            return false;\n        }\n        \n        var table     = document.getElementById(\"result_dtl\");\n        var totalRows = table.rows.length;\n        var rowIndex  = table.rows.length;\n        //var lstrLanguageCode = \"value[\"+rowIndex+\"].templateLanguage\";\n        //var attachmentFlag = \"value[\"+rowIndex+\"].attachmentFlag\";\n        var priority  = \"value[\"+rowIndex+\"].priority\";\n        \n        var idx = document.getElementById(\"organizationType\").selectedIndex ;\n        var organizationCodeDesc = document.getElementById(\"organizationType\").options[idx].text;\n        var organizationCode = document.getElementById(\"organizationType\").options[idx].value;\n        \n        var lstrNoticeTypeCode = \"value[\"+rowIndex+\"].noticeType\";\n        var templateDesc = \"value[\"+rowIndex+\"].templateDesc\";\n        var nameRadioGroup1  = \"radioGroup1\";\n        var recipientOrganization = document.getElementById(\"recipientOrganization\").value;\n        \n        \n        var statusValue = \"value[\"+rowIndex+\"].recordStatus\";\n        var row       = table.insertRow(totalRows);\n        row.setAttribute(\"id\", \"row\"+rowIndex);\n        row.setAttribute(\"height\", \"20px\");\n        var selectedIdx = \"value[\"+rowIndex+\"].selectedIndexTempDesc\";\n        \n        var cell1         = row.insertCell(0);\n        cell1.className   = \"center\";\n        cell1.setAttribute(\"width\", \"5%\");\n        cell1.innerHTML   = \"<td>\"\n                            + \" <input  type='radio' name=\"+nameRadioGroup1+\" onclick='highlightRow(\"+rowIndex+\")' value=\" + rowIndex + \"  class='check'/>\"+\n                            \"<input type='hidden' value='' name='value[\"+rowIndex+\"].recieverId' >\"+\n                            \"<input type='hidden' value='' name='value[\"+rowIndex+\"].updTime' >\"+\n                            \"<input type='hidden' value='' name=\"+selectedIdx+\">\" +\n                            \"<input type='hidden' value='ADD' name='value[\"+rowIndex+\"].status' >\"+\n                            \"<input type='hidden' value=\"+organizationCode+\" name='value[\"+rowIndex+\"].organizationType' >\"+\n                            \"<input type='hidden' value=\"+recipientOrganization+\" name='value[\"+rowIndex+\"].recipientOrganization' >\" +\n                              \"</td>\";\n            \n\n        var lobjNoticeTypeCell;\n             lobjNoticeTypeCell='<TD><select name =' + lstrNoticeTypeCode + ' style=\"height:25px\" class=\"must\" size=\"1\" onchange=\"noticeTypeComboChange('+rowIndex +')\" style=\"width:95%\"><option value=\"\">Select One...</option>';\n          \n             var lobjCombo = eval(document.forms[0].noticeType);\n                for(lintCtr=1;lintCtr<lobjCombo.length;lintCtr++) {\n                   var lstrCellVal= document.forms[0].noticeType[lintCtr].value;\n                   var lstrOpt= document.forms[0].noticeType[lintCtr].text;\n                   lobjNoticeTypeCell = lobjNoticeTypeCell +'<option value=\"'+lstrCellVal+'\">'+lstrOpt+'</option>';\n                }\n             lobjNoticeTypeCell=lobjNoticeTypeCell+'</select></TD>';\n             \n             var cell2       = row.insertCell(1);\n             cell2.className = \"center\";\n             cell2.setAttribute(\"width\", \"15%\");\n             cell2.innerHTML = lobjNoticeTypeCell;\n             \n             var cell3       = row.insertCell(2);\n             cell3.setAttribute(\"width\", \"15%\");\n             cell3.innerHTML = '<td>' \n                            +organizationCodeDesc +  '</td>';\n        \n        \n        var cell4 = row.insertCell(3);\n        cell4.setAttribute(\"width\", \"20%\");\n        cell4.innerHTML = \"<TD class='whitebg'>\"+recipientOrganization+\"</TD>\";\n        \n        \n        var lobjTemplateCell;\n             lobjTemplateCell='<TD class=\"center\"><select name =' + templateDesc + ' class=\"must\" size=\"1\" style=\"width:95%;height:25px;\"><option value=\"\">Select One...</option>';\n          /*\n             var lobjCombo = eval(document.forms[0].templateDescription);\n                for(lintCtr=1;lintCtr<lobjCombo.length;lintCtr++) {\n                   var lstrCellVal= document.forms[0].templateDescription[lintCtr].value;\n                   var lstrOpt= document.forms[0].templateDescription[lintCtr].text;\n                   lobjTemplateCell = lobjTemplateCell +'<option value=\"'+lstrCellVal+'\">'+lstrOpt+'</option>';\n                }\n                */\n             lobjTemplateCell=lobjTemplateCell+'</select></TD>';\n             \n             var cell5       = row.insertCell(4);\n             cell5.className = \"center\";\n             cell5.setAttribute(\"width\", \"18%\");\n             cell5.innerHTML = lobjTemplateCell;\n        \n        var priorityCell  = '<td class=\"center\"><select name = ' +priority + ' size=\"1\" class=\"must\" style=\"width:100px;height:25px;\">';\n        priorityCell=  priorityCell + '<option value=\"H\">High </option>'\n                            + '<option value=\"N\">Normal</option>'\n                            + '<option value=\"L\">Low</option>';\n        priorityCell = priorityCell + '</select></td>';\n        var cell6 = row.insertCell(5);\n        //cell6.className = \"center\";\n        cell6.setAttribute(\"width\", \"12%\");\n        cell6.innerHTML = priorityCell;\n        \n        var statusCell  = '<td class=\"center\"><select name = ' +statusValue + ' size=\"1\" class=\"must\" style=\"width:95%;height:25px;\">';\n        statusCell=  statusCell + '<option value=\"A\">Active </option>'\n                                + '<option value=\"S\">Suspended</option>';\n        statusCell = statusCell + '</select></td>';\n        var cell7 = row.insertCell(6);\n        //cell7.className = \"center\";\n        cell7.innerHTML = statusCell;\n        return false;\n    }\n    \n    function addRowNoticeType() {\n        searchPerformed   = document.getElementById(\"searchPerformed\").value;\n        if(searchPerformed == 'false') {\n            showBarMessage(ECM_SE0007,ERROR_MSG);\n            return false;\n        }\n        \n        var table     = document.getElementById(\"result_dtl\");\n        var totalRows = table.rows.length;\n        var rowIndex  = table.rows.length;\n        //var lstrLanguageCode = \"value[\"+rowIndex+\"].templateLanguage\";\n        //var attachmentFlag = \"value[\"+rowIndex+\"].attachmentFlag\";\n        var priority  = \"value[\"+rowIndex+\"].priority\";\n        \n        var idx = document.getElementById(\"noticeType\").selectedIndex ;\n        var noticeType = document.getElementById(\"noticeType\").options[idx].text;\n        var selectedIdx = \"value[\"+rowIndex+\"].selectedIndexTempDesc\";\n        var lintPos = noticeType.indexOf(\" \");\n        \n        var noticeTypeDesc = noticeType.substring(lintPos);\n        \n        //document.getElementById('value[' + rowIndex + '].noticeType').value = noticeTypeDesc;\n        var lstrOrganizationCode = \"value[\"+rowIndex+\"].organizationType\";\n        var templateDesc = \"value[\"+rowIndex+\"].templateDesc\";\n        var nameRadioGroup1  = \"radioGroup1\";\n        \n        var statusValue = \"value[\"+rowIndex+\"].recordStatus\";\n        var row       = table.insertRow(totalRows);\n        row.setAttribute(\"id\", \"row\"+rowIndex);\n        row.setAttribute(\"height\", \"20px\");\n        \n        var cell1         = row.insertCell(0);\n        cell1.className   = \"center\";\n        cell1.setAttribute(\"width\", \"5%\");\n        cell1.innerHTML   = '<td>'\n                            + ' <input  type=\"radio\" name='+nameRadioGroup1+' onclick=\"highlightRow('+rowIndex+')\" value=' + rowIndex + '  class=\"check\"/>'\n                            +  '</td>';\n        var cell2         = row.insertCell(1);\n        cell2.setAttribute(\"width\", \"15%\");\n        cell2.innerHTML   = \"<td>\"+\n                                                    \"<input type='hidden' value='' name='value[\"+rowIndex+\"].recieverId' >\"+\n                            \"<input type='hidden' value='' name='value[\"+rowIndex+\"].updTime' >\"+\n                            \"<input type='hidden' value='' name=\"+selectedIdx+\">\" +\n                            \"<input type='hidden' value='ADD' name='value[\"+rowIndex+\"].status' >\"+\n                            \"<input type='hidden' value='\"+noticeTypeDesc+\"' name='value[\"+rowIndex+\"].noticeType' >\"+\n                                                    noticeTypeDesc+\"</TD>\";\n        \n        var lobjOrganizationCell;\n             lobjOrganizationCell='<TD><select name =' + lstrOrganizationCode + ' class=\"must\" size=\"1\" onchange=\"comboChange('+rowIndex +')\" style=\"width:95%;height:25px;\"><option value=\"\">Select One...</option>';\n          \n             var lobjCombo = eval(document.forms[0].orgType);\n                for(lintCtr=1;lintCtr<lobjCombo.length;lintCtr++) {\n                   var lstrCellVal= document.forms[0].orgType[lintCtr].value;\n                   var lstrOpt= document.forms[0].orgType[lintCtr].text;\n                   lobjOrganizationCell = lobjOrganizationCell +'<option value=\"'+lstrCellVal+'\">'+lstrOpt+'</option>';\n                }\n             lobjOrganizationCell=lobjOrganizationCell+'</select></TD>';\n             \n             var cell3       = row.insertCell(2);\n             cell3.className = \"center\";\n             cell3.setAttribute(\"width\", \"15%\");\n             cell3.innerHTML = lobjOrganizationCell;\n        \n        \n        var cell4 = row.insertCell(3);\n        cell4.setAttribute(\"width\", \"20%\");\n        cell4.innerHTML = \"<TD class='whitebg'>\"+\n                                \"<input type='text' style='width:125px' value='' readonly='true' class='non_edit' name='value[\"+rowIndex+\"].recipientOrganization' >\"+\n                                \n                                \"&nbsp;&nbsp;<input type='button' value='. . .' name='btnBodyHeaderLookup' class='btnbutton' onclick='openRecipientOrganizationLookup(\"+rowIndex+\")'/>\"+\n                            \"</TD>\";\n        var lobjTemplateCell;\n             lobjTemplateCell='<TD class=\"center\"><select name =' + templateDesc + ' class=\"must\" size=\"1\" style=\"width:95%;height:25px;\"><option value=\"\">Select One...</option>';\n          \n             var lobjCombo = eval(document.forms[0].templateDescription);\n                for(lintCtr=1;lintCtr<lobjCombo.length;lintCtr++) {\n                   var lstrCellVal= document.forms[0].templateDescription[lintCtr].value;\n                   var lstrOpt= document.forms[0].templateDescription[lintCtr].text;\n                   lobjTemplateCell = lobjTemplateCell +'<option value=\"'+lstrCellVal+'\">'+lstrOpt+'</option>';\n                }\n             lobjTemplateCell=lobjTemplateCell+'</select></TD>';\n             \n             var cell5       = row.insertCell(4);\n             cell5.className = \"center\";\n             cell5.setAttribute(\"width\", \"18%\");\n             cell5.innerHTML = lobjTemplateCell;\n        \n        var priorityCell  = '<td class=\"center\"><select name = ' +priority + ' size=\"1\" class=\"must\" style=\"width:100px;height:25px;\">';\n        priorityCell=  priorityCell + '<option value=\"H\">High </option>'\n                            + '<option value=\"N\">Normal</option>'\n                            + '<option value=\"L\">Low</option>';\n        priorityCell = priorityCell + '</select></td>';\n        var cell6 = row.insertCell(5);\n        //cell6.className = \"center\";\n        cell6.setAttribute(\"width\", \"12%\");\n        cell6.innerHTML = priorityCell;\n        \n        var statusCell  = '<td class=\"center\"><select name = ' +statusValue + ' size=\"1\" class=\"must\" style=\"width:95%;height:25px;\">';\n        statusCell=  statusCell + '<option value=\"A\">Active </option>'\n                                + '<option value=\"S\">Suspended</option>';\n        statusCell = statusCell + '</select></td>';\n        var cell7 = row.insertCell(6);\n        //cell7.className = \"center\";\n        cell7.innerHTML = statusCell;\n        return false;\n    }\n    function updateRecordStatus(arow) {\n        var lobjStatus = document.getElementById('value[' + arow + '].status');\n      var lstrstatus = lobjStatus.value;\n      if(lstrstatus == '') {\n             lobjStatus.value = UPD;\n             //Set status to upd\n           \n          }\n    }\n    \n     function onSelect(){\n            if(document.forms[0].radioGroup[0].checked){\n               document.getElementById(\"organizationType\").setAttribute(\"class\", \"non_edit\");\n               document.forms[0].organizationType.value = '';\n               document.forms[0].organizationType.disabled = true;\n               document.forms[0].noticeType.disabled = false;\n               document.forms[0].noticeType.styleClass = \"must\";\n               document.forms[0].recipientOrganization.value= '';\n               document.getElementById(\"btnOrganizationKeyLookup\").disabled = true;\n            \n            } else if(document.forms[0].radioGroup[1].checked){\n                document.forms[0].noticeType.value= '';\n              document.forms[0].organizationType.disabled = false;\n               document.forms[0].noticeType.styleClass = \"non_edit\";\n               document.forms[0].noticeType.disabled = true;\n                document.getElementById(\"btnOrganizationKeyLookup\").disabled = false;\n            }\n        return false;\n    }\n    \n    function onSave() {\n                resetSearchCriteria();\n        if(document.forms[0].radioGroup[0].checked == false &&document.forms[0].radioGroup[1].checked == false) {\n            showBarMessage(ECM_SE0017,ERROR_MSG);\n            return;\n        } else if(document.forms[0].radioGroup[0].checked == true && (document.forms[0].noticeType.value == '' || document.forms[0].noticeType.value.length == 0)) {\n            showBarMessage(ECM_SE0017,ERROR_MSG);\n            return;\n        } else if(document.forms[0].radioGroup[1].checked == true && (document.forms[0].organizationType.value == '' || document.forms[0].organizationType.value.length == 0)) {\n            showBarMessage(ECM_SE0018,ERROR_MSG);\n            return;\n        } else if(document.forms[0].radioGroup[1].checked == true && (document.forms[0].recipientOrganization.value.length == 0 ||document.forms[0].recipientOrganization.value == '')) {\n            showBarMessage(ECM_SE0019,ERROR_MSG);\n                return false;\n        }\n        \n        \n        var ctr =0;\n        var table     = document.getElementById(\"result_dtl\");\n        var totalRows = table.rows.length;\n        var rowIndex  = table.rows.length;\n        for(ctr = 0 ; ctr<totalRows ;ctr++) {\n            if(document.forms[0].radioGroup[1].checked == true)".toCharArray();
    __oracle_jsp_text[11] = 
    " {\n                var value = document.getElementById('value[' + ctr + '].noticeType').value;\n                if(value == '' || value.length == 0){\n                    showBarMessage(ECM_SE0017,ERROR_MSG);\n                    return ;\n                }\n            } else if(document.forms[0].radioGroup[0].checked == true) {\n                var value = document.getElementById('value[' + ctr + '].organizationType').value;\n                if(value == '' || value.length == 0){\n                    showBarMessage(ECM_SE0018,ERROR_MSG);\n                    return ;\n                }\n                var value = document.getElementById('value[' + ctr + '].recipientOrganization').value;\n                if(value == '' || value.length == 0){\n                    showBarMessage(ECM_SE0019,ERROR_MSG);\n                    return ;\n                }\n            }\n            \n            var value = document.getElementById('value[' + ctr + '].templateDesc').value;\n            if(value == '' || value.length == 0){\n                showBarMessage(ECM_SE0003,ERROR_MSG);\n                return ;\n            }\n            var status = document.getElementById('value[' + ctr + '].status').value;\n            if(status != \"\" && status == \"ADD\") {\n\n\n                document.getElementById('value[' + ctr + '].selectedIndexTempDesc').value = document.getElementById('value[' + ctr + '].templateDesc').value;\n            \n        }\n        }\n        \n        \n        /* Disable all controls */\n        \n    \n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[12] = 
    "';\n        document.forms[0].submit();\n        return false;\n    }\n    function comboChange(arow) {\n        if(arow == -1) {\n            document.getElementById(\"recipientOrganization\").value = '';\n        } else {\n            document.getElementById('value[' + arow + '].recipientOrganization').value = '';\n        }\n    }\n    function noticeTypeComboChange(aintRowIndex) {\n    \n        var parentObj = eval(document.getElementById('value[' + aintRowIndex + '].noticeType'));\n        \n        \n        var childCombo = eval(document.getElementById('value[' + aintRowIndex + '].templateDesc'));\n        \n        var hiddenCombo = eval(document.getElementById(\"templateDescription\"));\n        \n        var lstrMasterTypeCode = parentObj.value;\n        \n        var laarVal ;\n        laarVal = new Array(1);        \n        laarVal[0] = lstrMasterTypeCode;\n        \n        \n        populateCombo(parentObj,childCombo,hiddenCombo,laarVal,1);\n        if(document.getElementById('value[' + aintRowIndex + '].selectedIndexTempDesc').value != \"\") {\n            document.getElementById('value[' + aintRowIndex + '].templateDesc').value = document.getElementById('value[' + aintRowIndex + '].selectedIndexTempDesc').value;\n        }\n    }\n    \n    function highlightRow(aintRowIndex) \n    { \n    highlightradioTD(\"row\"+aintRowIndex);\n    \n   }\n</SCRIPT>\n</HEAD>\n<BODY onload='javascript:onLoad()' onunload=\"javascript:doCloseAllChilds()\">\n\n".toCharArray();
    __oracle_jsp_text[13] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[14] = 
    "\n".toCharArray();
    __oracle_jsp_text[15] = 
    "\n".toCharArray();
    __oracle_jsp_text[16] = 
    "\n\n\n    ".toCharArray();
    __oracle_jsp_text[17] = 
    "\n    <div class=\"text_header\"><h2>E-Notice Recieving Organization Master</h2></div>\n    <TABLE CLASS=\"table_search\" BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"0\" CELLPADDING=\"0\">\n        <TR>\n            <TD width=\"150px\">Search On</TD>\n            <TD width=\"250px\" >\n                ".toCharArray();
    __oracle_jsp_text[18] = 
    "\n                Notice Type\n            </TD>\n            <TD width=\"200px\">\n                ".toCharArray();
    __oracle_jsp_text[19] = 
    "\n                Organization Type    \n            </TD>\n                \n            <TD>\n            </TD>\n            <TD>\n            ".toCharArray();
    __oracle_jsp_text[20] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[21] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[22] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[23] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[24] = 
    "\n         ".toCharArray();
    __oracle_jsp_text[25] = 
    "\n            </TD>\n            \n        </TR>\n        <TR>\n            <TD>Notice Type</TD>\n            <TD>\n                ".toCharArray();
    __oracle_jsp_text[26] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[27] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[28] = 
    "\n            </TD>\n            <TD></TD>\n            <TD ></TD>\n            <TD>\n            </TD>\n        </TR>\n        <TR>\n            <TD>Organization Type</TD>\n            <TD valign=\"center\">\n                ".toCharArray();
    __oracle_jsp_text[29] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[30] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[31] = 
    "\n            </TD>\n            <TD>\n                ".toCharArray();
    __oracle_jsp_text[32] = 
    "\n                \n                <input type=\"button\" value=\". . .\" name=\"btnOrganizationKeyLookup\" class=\"btnbutton\" onclick='openRecipientOrganizationLookup(-1)'/>\n                \n            </TD>\n            <TD>\n                \n            </TD>\n            <TD>\n            </TD>\n        </TR>\n    </TABLE>\n    ".toCharArray();
    __oracle_jsp_text[33] = 
    "\n    \n    \n    ".toCharArray();
    __oracle_jsp_text[34] = 
    "    \n    <DIV CLASS=\"buttons_box\">\n        <INPUT TYPE=\"button\" VALUE=\"Find\" NAME=\"btnFind\" CLASS=\"event_btnbutton\" ONCLICK='return onSearch()'/>\n    </DIV>\n    <DIV CLASS=\"text_header\"><H2>Search Results</H2></DIV>\n        <TABLE ID=\"result_hdr\" class=\"header\" BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"0\" WIDTH=\"100%\" >\n            <THEAD>\n                <TR>\n                    <TH STYLE=\"WIDTH:5%;HEIGHT:20px;\" class=\"center\">Select</TH>\n                    <TH  STYLE=\"WIDTH:15%\">Notice Type</TH>\n                    <TH STYLE=\"WIDTH:15%\">Organization Type</TH>\n                    <TH STYLE=\"WIDTH:20%\">Recipient Organization</TH>\n                    <TH STYLE=\"WIDTH:18%\">Template</TH>\n                    <TH STYLE=\"WIDTH:12%\">Priority</TH>\n                    <TH >Record Status</TH>\n                </TR>            \n            </THEAD>\n        </TABLE>   \n        \n        <DIV ID=\"search_result\" CLASS=\"search_result\" STYLE=\"HEIGHT:250px;WIDTH:100%\">\n        \n        <TABLE ID=\"result_dtl\" CLASS=\"table_results\"  BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"0\">\n      \n            <TBODY>\n            \n                ".toCharArray();
    __oracle_jsp_text[35] = 
    "\n                    <tr id='".toCharArray();
    __oracle_jsp_text[36] = 
    "' height=\"20px\">\n                        <TD width=\"5%\" class=\"center\">\n                            ".toCharArray();
    __oracle_jsp_text[37] = 
    "\n                         </TD>\n                        <TD  width=\"15%\" >\n                        ".toCharArray();
    __oracle_jsp_text[38] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[39] = 
    "\n                            \n                                ".toCharArray();
    __oracle_jsp_text[40] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[41] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[42] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[43] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[44] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[45] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[46] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[47] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[48] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[49] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[50] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[51] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[52] = 
    "\n                        </TD>\n                        <TD width=\"15%\">\n                            \n                            ".toCharArray();
    __oracle_jsp_text[53] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[54] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[55] = 
    "\n                            \n                            ".toCharArray();
    __oracle_jsp_text[56] = 
    "\n                                \n                                ".toCharArray();
    __oracle_jsp_text[57] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[58] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[59] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[60] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[61] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[62] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[63] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[64] = 
    "\n                                \n                            ".toCharArray();
    __oracle_jsp_text[65] = 
    "\n                                                        \n                            ".toCharArray();
    __oracle_jsp_text[66] = 
    "\n                        </TD>\n                        <TD width=\"20%\">\n                            \n                            ".toCharArray();
    __oracle_jsp_text[67] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[68] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[69] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[70] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[71] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[72] = 
    "\n                                    <input type=\"button\" value=\". . .\" name=\"btnOrganizationKeyLookup\" class=\"btnbutton\" onclick=\"openRecipientOrganizationLookup('".toCharArray();
    __oracle_jsp_text[73] = 
    "')\"/>\n                                ".toCharArray();
    __oracle_jsp_text[74] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[75] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[76] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[77] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[78] = 
    "\n                            \n                            ".toCharArray();
    __oracle_jsp_text[79] = 
    "\n                        </TD>\n                        <TD width=\"18%\">\n                        \n                            ".toCharArray();
    __oracle_jsp_text[80] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[81] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[82] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[83] = 
    "Select One...".toCharArray();
    __oracle_jsp_text[84] = 
    "\n                                    <script language=\"JavaScript\">\n                                        noticeTypeComboChange('".toCharArray();
    __oracle_jsp_text[85] = 
    "');\n                                    </script>\n                                ".toCharArray();
    __oracle_jsp_text[86] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[87] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[88] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[89] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[90] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[91] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[92] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[93] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[94] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[95] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[96] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[97] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[98] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[99] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[100] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[101] = 
    "\n                            \n                            ".toCharArray();
    __oracle_jsp_text[102] = 
    "\n                        </TD>\n                        \n                        <TD width=\"12%\">\n                            ".toCharArray();
    __oracle_jsp_text[103] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[104] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[105] = 
    "\n                        </TD>\n                        <TD>\n                            ".toCharArray();
    __oracle_jsp_text[106] = 
    "\n                                ".toCharArray();
    __oracle_jsp_text[107] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[108] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[109] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[110] = 
    "\n                            ".toCharArray();
    __oracle_jsp_text[111] = 
    "\n                            \n                        </TD>\n                    </TR>\n                ".toCharArray();
    __oracle_jsp_text[112] = 
    "\n                \n            </TBODY>\n        </TABLE>\n        </DIV>\n ".toCharArray();
    __oracle_jsp_text[113] = 
    "\n  <div class=\"buttons_box\">\n    <input type=\"button\" value=\"Add/View Recipient\" name=\"btnAdd\" class=\"event_btnbutton\" onclick='return openRecipientLookup()'/>\n       <input type=\"button\" value=\"Add\" name=\"btnAdd\" class=\"event_btnbutton\" onclick='return addRow()'/>\n        \n    </div>\n \n <br>\n ".toCharArray();
    __oracle_jsp_text[114] = 
    "\n  \n".toCharArray();
    __oracle_jsp_text[115] = 
    "\n</BODY>\n</HTML>\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
