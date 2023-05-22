package _pages._edl;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _EdlBulkUpdateScn__1 extends com.orionserver.http.OrionHttpJspPage {


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
    _EdlBulkUpdateScn__1 page = this;
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
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl008save", pageContext));
      out.write(__oracle_jsp_text[7]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/sedl008");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[8]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setName("fedl008");
              __jsp_taghandler_2.setProperty("flag");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[9]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_3=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property style");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setMaxlength("20");
              __jsp_taghandler_3.setName("fedl008");
              __jsp_taghandler_3.setProperty("find1");
              __jsp_taghandler_3.setStyle("width:100px");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[10]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_4=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fedl008");
              __jsp_taghandler_4.setOnchange("changeFind1();");
              __jsp_taghandler_4.setProperty("findIn1");
              __jsp_taghandler_4.setStyle("width:100px");
              __jsp_taghandler_4.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_4,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[11]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_5=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_5.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_5.setLabel("name");
                    __jsp_taghandler_5.setName("fedl008");
                    __jsp_taghandler_5.setProperty("findValues");
                    __jsp_taghandler_5.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
                    if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,3);
                  }
                  out.write(__oracle_jsp_text[12]);
                } while (__jsp_taghandler_4.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_6=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property style");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setMaxlength("20");
              __jsp_taghandler_6.setName("fedl008");
              __jsp_taghandler_6.setProperty("find2");
              __jsp_taghandler_6.setStyle("width:100px");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[14]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_7=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
              __jsp_taghandler_7.setParent(__jsp_taghandler_1);
              __jsp_taghandler_7.setName("fedl008");
              __jsp_taghandler_7.setOnchange("changeFind2();");
              __jsp_taghandler_7.setProperty("findIn2");
              __jsp_taghandler_7.setStyle("width:103px");
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
                    __jsp_taghandler_8.setName("fedl008");
                    __jsp_taghandler_8.setProperty("findValues1");
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
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_9=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_9.setParent(__jsp_taghandler_1);
              __jsp_taghandler_9.setMaxlength("4");
              __jsp_taghandler_9.setName("fedl008");
              __jsp_taghandler_9.setOnblur("changeUpper(this)");
              __jsp_taghandler_9.setProperty("containerop");
              __jsp_taghandler_9.setStyle("width:200px");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[18]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_10=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_10.setParent(__jsp_taghandler_1);
              __jsp_taghandler_10.setMaxlength("4");
              __jsp_taghandler_10.setName("fedl008");
              __jsp_taghandler_10.setOnblur("changeUpper(this)");
              __jsp_taghandler_10.setProperty("slotop");
              __jsp_taghandler_10.setStyle("width:200px");
              __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
              if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,2);
            }
            out.write(__oracle_jsp_text[19]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_11=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_11.setParent(__jsp_taghandler_1);
              __jsp_taghandler_11.setMaxlength("4");
              __jsp_taghandler_11.setName("fedl008");
              __jsp_taghandler_11.setOnblur("changeUpper(this)");
              __jsp_taghandler_11.setProperty("outslotop");
              __jsp_taghandler_11.setStyle("width:200px");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[20]);
            {
              org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_12=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
              __jsp_taghandler_12.setParent(__jsp_taghandler_1);
              __jsp_taghandler_12.setName("fedl008");
              __jsp_taghandler_12.setProperty("flag");
              __jsp_taghandler_12.setValue("L");
              __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[21]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_13=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                    __jsp_taghandler_13.setParent(__jsp_taghandler_12);
                    __jsp_taghandler_13.setMaxlength("5");
                    __jsp_taghandler_13.setName("fedl008");
                    __jsp_taghandler_13.setOnblur("changeUpper(this)");
                    __jsp_taghandler_13.setProperty("pod");
                    __jsp_taghandler_13.setStyle("width:200px");
                    __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
                    if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,3);
                  }
                  out.write(__oracle_jsp_text[22]);
                } while (__jsp_taghandler_12.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,2);
            }
            out.write(__oracle_jsp_text[23]);
            {
              org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_14=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
              __jsp_taghandler_14.setParent(__jsp_taghandler_1);
              __jsp_taghandler_14.setName("fedl008");
              __jsp_taghandler_14.setProperty("flag");
              __jsp_taghandler_14.setValue("L");
              __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[24]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_15=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                    __jsp_taghandler_15.setParent(__jsp_taghandler_14);
                    __jsp_taghandler_15.setMaxlength("5");
                    __jsp_taghandler_15.setName("fedl008");
                    __jsp_taghandler_15.setOnblur("changeUpper(this)");
                    __jsp_taghandler_15.setProperty("pol");
                    __jsp_taghandler_15.setStyle("width:200px");
                    __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                    if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,3);
                  }
                  out.write(__oracle_jsp_text[25]);
                } while (__jsp_taghandler_14.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,2);
            }
            out.write(__oracle_jsp_text[26]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_16=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_16.setParent(__jsp_taghandler_1);
              __jsp_taghandler_16.setMaxlength("2");
              __jsp_taghandler_16.setName("fedl008");
              __jsp_taghandler_16.setOnblur("changeUpper(this)");
              __jsp_taghandler_16.setProperty("eqtype");
              __jsp_taghandler_16.setStyle("width:200px");
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[27]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_17=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
              __jsp_taghandler_17.setParent(__jsp_taghandler_1);
              __jsp_taghandler_17.setName("fedl008");
              __jsp_taghandler_17.setProperty("midstream");
              __jsp_taghandler_17.setStyle("width:203px");
              __jsp_taghandler_17.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_17,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[28]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_18=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_18.setParent(__jsp_taghandler_17);
                    __jsp_taghandler_18.setLabel("name");
                    __jsp_taghandler_18.setName("fedl008");
                    __jsp_taghandler_18.setProperty("findMid");
                    __jsp_taghandler_18.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
                    if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,3);
                  }
                  out.write(__oracle_jsp_text[29]);
                } while (__jsp_taghandler_17.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,2);
            }
            out.write(__oracle_jsp_text[30]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_19=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_19.setParent(__jsp_taghandler_1);
              __jsp_taghandler_19.setMaxlength("5");
              __jsp_taghandler_19.setName("fedl008");
              __jsp_taghandler_19.setOnblur("changeUpper(this)");
              __jsp_taghandler_19.setProperty("mlovessel");
              __jsp_taghandler_19.setStyle("width:200px");
              __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
              if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,2);
            }
            out.write(__oracle_jsp_text[31]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_20=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_20.setParent(__jsp_taghandler_1);
              __jsp_taghandler_20.setMaxlength("10");
              __jsp_taghandler_20.setName("fedl008");
              __jsp_taghandler_20.setOnblur("changeUpper(this)");
              __jsp_taghandler_20.setProperty("mlovoyage");
              __jsp_taghandler_20.setStyle("width:200px");
              __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
              if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,2);
            }
            out.write(__oracle_jsp_text[32]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_21=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
              __jsp_taghandler_21.setParent(__jsp_taghandler_1);
              __jsp_taghandler_21.setName("fedl008");
              __jsp_taghandler_21.setProperty("soc");
              __jsp_taghandler_21.setStyle("width:200px");
              __jsp_taghandler_21.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_21,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[33]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_22=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_22.setParent(__jsp_taghandler_21);
                    __jsp_taghandler_22.setLabel("name");
                    __jsp_taghandler_22.setName("fedl008");
                    __jsp_taghandler_22.setProperty("findSoc");
                    __jsp_taghandler_22.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
                    if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,3);
                  }
                  out.write(__oracle_jsp_text[34]);
                } while (__jsp_taghandler_21.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,2);
            }
            out.write(__oracle_jsp_text[35]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
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
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n<HTML xmlns=\"http://www.w3.org/1999/xhtml\">\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n\r\n<HEAD>\r\n\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n\r\n    <LINK REL=\"stylesheet\" HREF=\"".toCharArray();
    __oracle_jsp_text[6] = 
    "/css/EZL.css\"/>\r\n    \r\n<SCRIPT language=\"javascript\" type=\"text/javascript\">\r\n\r\n    var FORM_ID         = 'fedl008';  \r\n    var lastLookup ;\r\n\r\n    function onLoad() {\r\n    }\r\n    \r\n    function onSave(){\r\n        var value_flag           =document.forms[0].flag.value;\r\n        var container_op        = document.forms[0].containerop.value;\r\n        var slot_op             = document.forms[0].slotop.value;\r\n        var equipment           = document.forms[0].eqtype.value;\r\n        var midstream           = document.forms[0].midstream.value;\r\n        var mlovessel           = document.forms[0].mlovessel.value;\r\n        var mlovoyage           = document.forms[0].mlovoyage.value;\r\n        var soc_coc             = document.forms[0].soc.value;\r\n        \r\n        if(value_flag =='D'){\r\n\t\t\tvar out_slot_op         = document.forms[0].outslotop.value;\r\n\t\t\tvar pol                 = document.forms[0].pol.value;\r\n\t\t\tif(container_op ==\"\" && \r\n\t\t\t\tslot_op ==\"\" && \r\n\t\t\t\tequipment ==\"\" && \r\n\t\t\t\tmidstream ==\"\" && \r\n\t\t\t\tmlovessel ==\"\" && \r\n\t\t\t\tmlovoyage ==\"\" &&\r\n\t\t\t\tsoc_coc ==\"\" && \r\n\t\t\t\tout_slot_op ==\"\"&&\r\n\t\t\t\tpol ==\"\"){\r\n\t\t\t\t\r\n\t\t\t\tshowBarMessage(EZL_SE0100,ERROR_MSG);\r\n\t\t\t\treturn false;\r\n\t\t\t}\r\n        }\r\n         if(value_flag =='L'){\r\n           \r\n           var pod        = document.forms[0].pod.value;\r\n           \r\n           if(container_op ==\"\" && \r\n            slot_op ==\"\" && \r\n            equipment ==\"\" && \r\n            midstream ==\"\" && \r\n            mlovessel ==\"\" && \r\n            mlovoyage ==\"\" &&\r\n            soc_coc ==\"\" && \r\n            pod ==\"\"){\r\n           \r\n            showBarMessage(EZL_SE0100,ERROR_MSG);\r\n            return false;\r\n            }\r\n        }\r\n            document.forms[0].action='".toCharArray();
    __oracle_jsp_text[7] = 
    "';\r\n            document.forms[0].submit();\r\n        return false;\r\n    }\r\n\r\n    \r\n    function openContainerOperatorLookup(){\r\n\t\t\tvar rowId = FORM_ID;     \r\n            lastLookup = 'Container';\r\n            openLookup(FORM_ID, rowId, MASTER_ID_OPERATOR, '');\r\n    }\r\n    function openSlotOperatorLookup(){\r\n            var rowId = FORM_ID;     \r\n            lastLookup='Slot';\r\n            openLookup(FORM_ID, rowId, MASTER_ID_OPERATOR, '');\r\n    }\r\n    function openPodLookup(){\r\n            var rowId = FORM_ID;\r\n            lastLookup='Pod';\r\n            openLookup(FORM_ID, rowId, MASTER_ID_PORT, '');\r\n    }\r\n    function openPolLookup(){\r\n            var rowId = FORM_ID; \r\n            lastLookup='Pol';\r\n            openLookup(FORM_ID, rowId, MASTER_ID_PORT, '');\r\n    }\r\n    \r\n    function openEquipmentTypeLookup(){\r\n            var rowId = FORM_ID; \r\n            lastLookup='Equipment';\r\n            openLookup(FORM_ID, rowId, MASTER_ID_EQUIPMENT, '');\r\n    }\r\n    \r\n    /*Called by master lookup screens to return selected values*/\r\n    function setLookupValues(aFormName, aRowId,strMasterId, arrResultData){\r\n\t\t\r\n        if(arrResultData[0] == FAILURE){\r\n            return;\r\n        }\r\n        if(lastLookup ==\"Container\"){\r\n                //set container code\r\n                document.forms[0].containerop.value=arrResultData[IDX_CONTAINER_OP];\t\r\n        } else if(lastLookup ==\"Slot\"){\r\n                //set slot code\r\n                 document.forms[0].slotop.value=arrResultData[IDX_SLOT_OP];\t\t\r\n        }else if(lastLookup ==\"Pod\"){\r\n                //set port code\r\n                document.forms[0].pod.value=arrResultData[IDX_PORT];\r\n               \r\n        }else if(lastLookup ==\"Pol\"){\r\n                //set port code\r\n                document.forms[0].pol.value=arrResultData[IDX_PORT];\r\n               \r\n        } else if(lastLookup ==\"Equipment\"){\r\n                //set equipment code\r\n                 document.forms[0].eqtype.value=arrResultData[IDX_EQUIPMENT_TYPE];\r\n        } \r\n    }\r\n    \r\n    \r\n    function changeFind1(){  \r\n\r\n    var in1ComboVal     = document.forms[0].findIn1.value;\r\n    var lobjFind        = document.forms[0].find1;\r\n    \r\n    if( in1ComboVal == \"L3EQPNUM\"     ||  \r\n        in1ComboVal == \"BBCARGO\"     ||  \r\n        in1ComboVal == \"COCCUST\"     ||\r\n        in1ComboVal == \"COCEMPTY\"    ||\r\n        in1ComboVal == \"COCTRANS\"    ||\r\n        in1ComboVal == \"DGCARGO\"     ||\r\n        in1ComboVal == \"OOGCARGO\"    ||\r\n        in1ComboVal == \"REEFERCARGO\" ||\r\n        in1ComboVal == \"SOCALL\"      ||\r\n        in1ComboVal == \"SOCDIRECT\"   ||\r\n        in1ComboVal == \"SOCPARTNER\"  ||\r\n        in1ComboVal == \"SOCTRANS\"    ||\r\n        in1ComboVal == \"SPECIALHANDLING\"     ||\r\n        in1ComboVal == \"TRANSSHPD\"   ||\r\n        in1ComboVal == \"WITHERROR\"     \r\n){\r\n        lobjFind.value = \"\";\r\n        lobjFind.disabled = true;\r\n        lobjFind.style.backgroundColor = \"#EBEEEA\";\r\n\r\n        }else{\r\n\r\n        lobjFind.disabled = false;\r\n        lobjFind.style.background = 'white';\r\n        lobjFind.style.color      = 'black';\r\n }\r\n        return false;\r\n\r\n}\r\n\r\n    function changeFind2(){  \r\n\r\n    var in1ComboVal      = document.forms[0].findIn2.value;\r\n    var lobjFind        = document.forms[0].find2;\r\n    \r\n    if( in1ComboVal == \"L3EQPNUM\"     ||  \r\n        in1ComboVal == \"BBCARGO\"     ||  \r\n        in1ComboVal == \"COCCUST\"     ||\r\n        in1ComboVal == \"COCEMPTY\"    ||\r\n        in1ComboVal == \"COCTRANS\"    ||\r\n        in1ComboVal == \"DGCARGO\"     ||\r\n        in1ComboVal == \"OOGCARGO\"    ||\r\n        in1ComboVal == \"REEFERCARGO\" ||\r\n        in1ComboVal == \"SOCALL\"      ||\r\n        in1ComboVal == \"SOCDIRECT\"   ||\r\n        in1ComboVal == \"SOCPARTNER\"  ||\r\n        in1ComboVal == \"SOCTRANS\"    ||\r\n        in1ComboVal == \"SPECIALHANDLING\"     ||\r\n        in1ComboVal == \"TRANSSHPD\"   ||\r\n        in1ComboVal == \"WITHERROR\"     \r\n       ){\r\n        lobjFind.value = \"\";\r\n        lobjFind.disabled = true;\r\n        lobjFind.style.backgroundColor = \"#EBEEEA\";\r\n\r\n        }else{\r\n\r\n        lobjFind.disabled = false;\r\n        lobjFind.style.background = 'white';\r\n        lobjFind.style.color      = 'black';\r\n        }\r\n        return false;\r\n\r\n}\r\n    \r\n</SCRIPT>  \r\n</HEAD>\r\n<BODY>\r\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\r\n            \r\n<div class=\"text_header\"><h2>Bulk Update Input</h2></div>\r\n    <TABLE CLASS=\"table_search\" BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"0\" CELLPADDING=\"0\">\r\n\t\t<tr height = '15px'/>\r\n        <TR>\r\n            <TD>Find 1</TD>\r\n            <TD>\r\n                ".toCharArray();
    __oracle_jsp_text[10] = 
    "\r\n            </TD>\r\n            <TD>In 1</TD>\r\n            <TD>\r\n            ".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[12] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[13] = 
    "\r\n            </TD>\r\n            <TD>Find 2</TD>\r\n            <TD>\r\n                ".toCharArray();
    __oracle_jsp_text[14] = 
    "\r\n            </TD>\r\n           <TD >In 2</TD>\r\n           <TD>\r\n               ".toCharArray();
    __oracle_jsp_text[15] = 
    "\r\n                   ".toCharArray();
    __oracle_jsp_text[16] = 
    "\r\n               ".toCharArray();
    __oracle_jsp_text[17] = 
    "\r\n           </TD>\r\n       </TR>\r\n\t   <tr height = '15px'/>\r\n\r\n   </TABLE>\r\n    <TABLE BORDER = '0' WIDTH = '75%'>\r\n\t    <TR height = '22px' width='15%'>\r\n        <TD>Container Operator\r\n\t\t</TD>\r\n        <TD>\r\n        ".toCharArray();
    __oracle_jsp_text[18] = 
    "\r\n        <input type=\"button\" value=\". . .\" name=\"btnContLookup\" class=\"btnbutton\" onclick='return openContainerOperatorLookup()'/>\r\n        </TR>\r\n        <TR height = '22px'>\r\n\t\t\t<!-- TD/ -->\r\n\t\t\t<TD>Slot Operator</TD>\r\n\t\t\t<TD>\r\n\t\t\t".toCharArray();
    __oracle_jsp_text[19] = 
    "\r\n\t\t\t<input type=\"button\" value=\". . .\" name=\"btnSlotLookup\" class=\"btnbutton\" onclick='return openSlotOperatorLookup()'/>\r\n        </TR>\r\n        <TR height = '22px'>\r\n\t\t\t<!-- TD/ -->\r\n        <TD>Out Slot Operator</TD>\r\n        <TD>\r\n        ".toCharArray();
    __oracle_jsp_text[20] = 
    "\r\n        </TR>\r\n        <TR height = '22px'>\r\n\t\t\t<!-- TD/ -->\r\n\t\t".toCharArray();
    __oracle_jsp_text[21] = 
    "\r\n\t\t\t<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;POD</TD>\r\n\t\t\t\t<TD>\r\n\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[22] = 
    "\r\n\t\t\t\t\t<input type=\"button\" value=\". . .\" name=\"btnPodLookup\" class=\"btnbutton\" onclick='return openPodLookup()'/>\r\n\t\t\t\t</TD>\r\n\t\t\t</td>\r\n\t\t".toCharArray();
    __oracle_jsp_text[23] = 
    "\r\n\t\t".toCharArray();
    __oracle_jsp_text[24] = 
    "\r\n\t\t\t<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;POL</TD>\r\n\t\t\t\t<TD>\r\n\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[25] = 
    "\r\n\t\t\t\t\t<input type=\"button\" value=\". . .\" name=\"btnPolLookup\" class=\"btnbutton\" onclick='return openPolLookup()'/>\r\n\t\t\t\t</td>\r\n\t\t\t</td>\r\n\t\t".toCharArray();
    __oracle_jsp_text[26] = 
    "\r\n\t\t</TR>\r\n        <TR height = '22px'>\r\n\t\t\t<!-- TD/ -->\r\n        <TD>Equipment Type</TD>\r\n        <TD>\r\n        ".toCharArray();
    __oracle_jsp_text[27] = 
    "\r\n        <input type=\"button\" value=\". . .\" name=\"btnEquipLookup\" class=\"btnbutton\" onclick='return openEquipmentTypeLookup()'/>\r\n        </TR>\r\n        <TR height = '22px'>\r\n\t\t\t<!-- TD/ -->\r\n        <TD>Midstream Handling</TD>\r\n        <TD>\r\n        ".toCharArray();
    __oracle_jsp_text[28] = 
    "  \r\n\t\t\t".toCharArray();
    __oracle_jsp_text[29] = 
    "\r\n        ".toCharArray();
    __oracle_jsp_text[30] = 
    "\r\n        </TD>\r\n        </TR>\r\n        <TR height = '22px'>\r\n\t\t\t<!-- TD/ -->\r\n        <TD>MOL Vessel</TD>\r\n        <TD>\r\n        ".toCharArray();
    __oracle_jsp_text[31] = 
    "\r\n        </TR>\r\n        <TR height = '22px'>\r\n\t\t\t<!-- TD/ -->\r\n        <TD>MOL Voyage#</TD>\r\n        <TD>\r\n        ".toCharArray();
    __oracle_jsp_text[32] = 
    "\r\n        </TR>\r\n        <TR height = '22px'>\r\n\t\t\t<!-- TD/ -->\r\n        <TD>SOC/COC</TD>\r\n        <TD>\r\n        ".toCharArray();
    __oracle_jsp_text[33] = 
    "\r\n        ".toCharArray();
    __oracle_jsp_text[34] = 
    "\r\n        ".toCharArray();
    __oracle_jsp_text[35] = 
    "\r\n        </TD>\r\n        </TR>\r\n    </TABLE>\r\n    \r\n    <div class=\"buttons_box\">   \r\n        <input type=\"button\" value=\"Save\" name=\"btnSave\" class=\"event_btnbutton\" onclick='onSave();'/>\r\n    </div>\r\n   \r\n    <div class=\"buttons_box\">\r\n    </div>\r\n    <br>\r\n    \r\n    <TABLE BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"1\" CELLPADDING=\"4\">\r\n    <TR>\r\n        <TD ALIGN=\"center\">\r\n            <P>\r\n            <DIV ID='msg'>\r\n            <niit:errorMsg/>\r\n            </DIV>\r\n        </TD>\r\n    </TR>\r\n    </TABLE>\r\n\r\n".toCharArray();
    __oracle_jsp_text[36] = 
    "\r\n</BODY>\r\n</HTML>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
