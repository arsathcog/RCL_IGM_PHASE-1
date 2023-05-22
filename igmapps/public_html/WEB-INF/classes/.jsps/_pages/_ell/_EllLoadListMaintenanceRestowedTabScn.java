package _pages._ell;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;


public class _EllLoadListMaintenanceRestowedTabScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EllLoadListMaintenanceRestowedTabScn page = this;
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
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_1=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setName("fell002");
        __jsp_taghandler_1.setOnchange("getGridSearchCriteria();changeValIn1();changeValIn2();setHiddenView();");
        __jsp_taghandler_1.setProperty("restowedView");
        __jsp_taghandler_1.setStyle("width:98%");
        __jsp_taghandler_1.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_1,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[6]);
            {
              org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_2=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setLabel("name");
              __jsp_taghandler_2.setName("fell002");
              __jsp_taghandler_2.setProperty("restowedViewValues");
              __jsp_taghandler_2.setValue("code");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[7]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[8]);
      {
        org.apache.struts.taglib.html.TextTag __jsp_taghandler_3=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
        __jsp_taghandler_3.setParent(null);
        __jsp_taghandler_3.setMaxlength("100");
        __jsp_taghandler_3.setName("fell002");
        __jsp_taghandler_3.setOnblur("changeUpper(this)");
        __jsp_taghandler_3.setProperty("srchRestowedFind1");
        __jsp_taghandler_3.setStyle("width:96%");
        __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
        if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,1);
      }
      out.write(__oracle_jsp_text[9]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_4=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
        __jsp_taghandler_4.setParent(null);
        __jsp_taghandler_4.setName("fell002");
        __jsp_taghandler_4.setOnchange("changeValIn1()");
        __jsp_taghandler_4.setProperty("srchRestowedIn1");
        __jsp_taghandler_4.setStyle("width:98%");
        __jsp_taghandler_4.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_4,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[10]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_5=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_5.setParent(__jsp_taghandler_4);
              __jsp_taghandler_5.setValue("");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_5,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[11]);
                } while (__jsp_taghandler_5.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[12]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_6=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_6.setParent(__jsp_taghandler_4);
              __jsp_taghandler_6.setValue("FK_BOOKING_NO");
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
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_7=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_7.setParent(__jsp_taghandler_4);
              __jsp_taghandler_7.setValue("FK_CONTAINER_OPERATOR");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_7,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[15]);
                } while (__jsp_taghandler_7.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[16]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_8=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_8.setParent(__jsp_taghandler_4);
              __jsp_taghandler_8.setValue("DN_EQUIPMENT_NO");
              __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_8,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[17]);
                } while (__jsp_taghandler_8.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,2);
            }
            out.write(__oracle_jsp_text[18]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_9=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_9.setParent(__jsp_taghandler_4);
              __jsp_taghandler_9.setValue("LOAD_CONDITION");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_9,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[19]);
                } while (__jsp_taghandler_9.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[20]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_10=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_10.setParent(__jsp_taghandler_4);
              __jsp_taghandler_10.setValue("DN_SHIPMENT_TYP");
              __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_10,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[21]);
                } while (__jsp_taghandler_10.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,2);
            }
            out.write(__oracle_jsp_text[22]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_11=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_11.setParent(__jsp_taghandler_4);
              __jsp_taghandler_11.setValue("DN_EQ_SIZE");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_11,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[23]);
                } while (__jsp_taghandler_11.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[24]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_12=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_12.setParent(__jsp_taghandler_4);
              __jsp_taghandler_12.setValue("FK_SLOT_OPERATOR");
              __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_12,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[25]);
                } while (__jsp_taghandler_12.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,2);
            }
            out.write(__oracle_jsp_text[26]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_13=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_13.setParent(__jsp_taghandler_4);
              __jsp_taghandler_13.setValue("DN_SOC_COC");
              __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_13,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[27]);
                } while (__jsp_taghandler_13.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,2);
            }
            out.write(__oracle_jsp_text[28]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_14=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_14.setParent(__jsp_taghandler_4);
              __jsp_taghandler_14.setValue("DN_SPECIAL_HNDL");
              __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_14,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[29]);
                } while (__jsp_taghandler_14.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,2);
            }
            out.write(__oracle_jsp_text[30]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_15=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_15.setParent(__jsp_taghandler_4);
              __jsp_taghandler_15.setValue("DN_EQ_TYPE");
              __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_15,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[31]);
                } while (__jsp_taghandler_15.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,2);
            }
            out.write(__oracle_jsp_text[32]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_16=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_16.setParent(__jsp_taghandler_4);
              __jsp_taghandler_16.setValue("L3EQPNUM");
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_16,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[33]);
                } while (__jsp_taghandler_16.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[34]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_17=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_17.setParent(__jsp_taghandler_4);
              __jsp_taghandler_17.setValue("BBCARGO");
              __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_17,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[35]);
                } while (__jsp_taghandler_17.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,2);
            }
            out.write(__oracle_jsp_text[36]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_18=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_18.setParent(__jsp_taghandler_4);
              __jsp_taghandler_18.setValue("COCCUST");
              __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_18,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[37]);
                } while (__jsp_taghandler_18.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,2);
            }
            out.write(__oracle_jsp_text[38]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_19=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_19.setParent(__jsp_taghandler_4);
              __jsp_taghandler_19.setValue("COCEMPTY");
              __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_19,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[39]);
                } while (__jsp_taghandler_19.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,2);
            }
            out.write(__oracle_jsp_text[40]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_20=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_20.setParent(__jsp_taghandler_4);
              __jsp_taghandler_20.setValue("COCTRANS");
              __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_20,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[41]);
                } while (__jsp_taghandler_20.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,2);
            }
            out.write(__oracle_jsp_text[42]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_21=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_21.setParent(__jsp_taghandler_4);
              __jsp_taghandler_21.setValue("SOCALL");
              __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_21,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[43]);
                } while (__jsp_taghandler_21.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,2);
            }
            out.write(__oracle_jsp_text[44]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_22=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_22.setParent(__jsp_taghandler_4);
              __jsp_taghandler_22.setValue("SOCDIRECT");
              __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_22,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[45]);
                } while (__jsp_taghandler_22.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,2);
            }
            out.write(__oracle_jsp_text[46]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_23=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_23.setParent(__jsp_taghandler_4);
              __jsp_taghandler_23.setValue("SOCPARTNER");
              __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_23,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[47]);
                } while (__jsp_taghandler_23.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,2);
            }
            out.write(__oracle_jsp_text[48]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_24=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_24.setParent(__jsp_taghandler_4);
              __jsp_taghandler_24.setValue("SOCTRANS");
              __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_24,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[49]);
                } while (__jsp_taghandler_24.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,2);
            }
            out.write(__oracle_jsp_text[50]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_25=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_25.setParent(__jsp_taghandler_4);
              __jsp_taghandler_25.setValue("TRANSSHPD");
              __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_25,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[51]);
                } while (__jsp_taghandler_25.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,2);
            }
            out.write(__oracle_jsp_text[52]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_26=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_26.setParent(__jsp_taghandler_4);
              __jsp_taghandler_26.setValue("WITHREM");
              __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_26,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[53]);
                } while (__jsp_taghandler_26.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,2);
            }
            out.write(__oracle_jsp_text[54]);
          } while (__jsp_taghandler_4.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,1);
      }
      out.write(__oracle_jsp_text[55]);
      {
        org.apache.struts.taglib.html.TextTag __jsp_taghandler_27=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
        __jsp_taghandler_27.setParent(null);
        __jsp_taghandler_27.setMaxlength("100");
        __jsp_taghandler_27.setName("fell002");
        __jsp_taghandler_27.setOnblur("changeUpper(this)");
        __jsp_taghandler_27.setProperty("srchRestowedFind2");
        __jsp_taghandler_27.setStyle("width:96%");
        __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
        if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,1);
      }
      out.write(__oracle_jsp_text[56]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_28=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
        __jsp_taghandler_28.setParent(null);
        __jsp_taghandler_28.setName("fell002");
        __jsp_taghandler_28.setOnchange("changeValIn2()");
        __jsp_taghandler_28.setProperty("srchRestowedIn2");
        __jsp_taghandler_28.setStyle("width:98%");
        __jsp_taghandler_28.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_28,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[57]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_29=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_29.setParent(__jsp_taghandler_28);
              __jsp_taghandler_29.setValue("");
              __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_29,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[58]);
                } while (__jsp_taghandler_29.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,2);
            }
            out.write(__oracle_jsp_text[59]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_30=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_30.setParent(__jsp_taghandler_28);
              __jsp_taghandler_30.setValue("FK_BOOKING_NO");
              __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_30,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[60]);
                } while (__jsp_taghandler_30.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,2);
            }
            out.write(__oracle_jsp_text[61]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_31=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_31.setParent(__jsp_taghandler_28);
              __jsp_taghandler_31.setValue("FK_CONTAINER_OPERATOR");
              __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_31,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[62]);
                } while (__jsp_taghandler_31.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,2);
            }
            out.write(__oracle_jsp_text[63]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_32=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_32.setParent(__jsp_taghandler_28);
              __jsp_taghandler_32.setValue("DN_EQUIPMENT_NO");
              __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_32,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[64]);
                } while (__jsp_taghandler_32.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,2);
            }
            out.write(__oracle_jsp_text[65]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_33=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_33.setParent(__jsp_taghandler_28);
              __jsp_taghandler_33.setValue("LOAD_CONDITION");
              __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_33,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[66]);
                } while (__jsp_taghandler_33.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,2);
            }
            out.write(__oracle_jsp_text[67]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_34=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_34.setParent(__jsp_taghandler_28);
              __jsp_taghandler_34.setValue("DN_SHIPMENT_TYP");
              __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_34,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[68]);
                } while (__jsp_taghandler_34.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,2);
            }
            out.write(__oracle_jsp_text[69]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_35=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_35.setParent(__jsp_taghandler_28);
              __jsp_taghandler_35.setValue("DN_EQ_SIZE");
              __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_35,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[70]);
                } while (__jsp_taghandler_35.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,2);
            }
            out.write(__oracle_jsp_text[71]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_36=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_36.setParent(__jsp_taghandler_28);
              __jsp_taghandler_36.setValue("FK_SLOT_OPERATOR");
              __jsp_tag_starteval=__jsp_taghandler_36.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_36,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[72]);
                } while (__jsp_taghandler_36.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_36.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_36,2);
            }
            out.write(__oracle_jsp_text[73]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_37=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_37.setParent(__jsp_taghandler_28);
              __jsp_taghandler_37.setValue("DN_SOC_COC");
              __jsp_tag_starteval=__jsp_taghandler_37.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_37,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[74]);
                } while (__jsp_taghandler_37.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_37.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_37,2);
            }
            out.write(__oracle_jsp_text[75]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_38=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_38.setParent(__jsp_taghandler_28);
              __jsp_taghandler_38.setValue("DN_SPECIAL_HNDL");
              __jsp_tag_starteval=__jsp_taghandler_38.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_38,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[76]);
                } while (__jsp_taghandler_38.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_38.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_38,2);
            }
            out.write(__oracle_jsp_text[77]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_39=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_39.setParent(__jsp_taghandler_28);
              __jsp_taghandler_39.setValue("DN_EQ_TYPE");
              __jsp_tag_starteval=__jsp_taghandler_39.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_39,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[78]);
                } while (__jsp_taghandler_39.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_39.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_39,2);
            }
            out.write(__oracle_jsp_text[79]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_40=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_40.setParent(__jsp_taghandler_28);
              __jsp_taghandler_40.setValue("L3EQPNUM");
              __jsp_tag_starteval=__jsp_taghandler_40.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_40,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[80]);
                } while (__jsp_taghandler_40.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_40.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_40,2);
            }
            out.write(__oracle_jsp_text[81]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_41=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_41.setParent(__jsp_taghandler_28);
              __jsp_taghandler_41.setValue("BBCARGO");
              __jsp_tag_starteval=__jsp_taghandler_41.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_41,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[82]);
                } while (__jsp_taghandler_41.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_41.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_41,2);
            }
            out.write(__oracle_jsp_text[83]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_42=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_42.setParent(__jsp_taghandler_28);
              __jsp_taghandler_42.setValue("COCCUST");
              __jsp_tag_starteval=__jsp_taghandler_42.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_42,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[84]);
                } while (__jsp_taghandler_42.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_42.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_42,2);
            }
            out.write(__oracle_jsp_text[85]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_43=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_43.setParent(__jsp_taghandler_28);
              __jsp_taghandler_43.setValue("COCEMPTY");
              __jsp_tag_starteval=__jsp_taghandler_43.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_43,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[86]);
                } while (__jsp_taghandler_43.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_43.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_43,2);
            }
            out.write(__oracle_jsp_text[87]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_44=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_44.setParent(__jsp_taghandler_28);
              __jsp_taghandler_44.setValue("COCTRANS");
              __jsp_tag_starteval=__jsp_taghandler_44.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_44,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[88]);
                } while (__jsp_taghandler_44.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_44.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_44,2);
            }
            out.write(__oracle_jsp_text[89]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_45=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_45.setParent(__jsp_taghandler_28);
              __jsp_taghandler_45.setValue("SOCALL");
              __jsp_tag_starteval=__jsp_taghandler_45.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_45,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[90]);
                } while (__jsp_taghandler_45.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_45.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_45,2);
            }
            out.write(__oracle_jsp_text[91]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_46=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_46.setParent(__jsp_taghandler_28);
              __jsp_taghandler_46.setValue("SOCDIRECT");
              __jsp_tag_starteval=__jsp_taghandler_46.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_46,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[92]);
                } while (__jsp_taghandler_46.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_46.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_46,2);
            }
            out.write(__oracle_jsp_text[93]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_47=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_47.setParent(__jsp_taghandler_28);
              __jsp_taghandler_47.setValue("SOCPARTNER");
              __jsp_tag_starteval=__jsp_taghandler_47.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_47,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[94]);
                } while (__jsp_taghandler_47.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_47.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_47,2);
            }
            out.write(__oracle_jsp_text[95]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_48=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_48.setParent(__jsp_taghandler_28);
              __jsp_taghandler_48.setValue("SOCTRANS");
              __jsp_tag_starteval=__jsp_taghandler_48.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_48,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[96]);
                } while (__jsp_taghandler_48.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_48.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_48,2);
            }
            out.write(__oracle_jsp_text[97]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_49=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_49.setParent(__jsp_taghandler_28);
              __jsp_taghandler_49.setValue("TRANSSHPD");
              __jsp_tag_starteval=__jsp_taghandler_49.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_49,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[98]);
                } while (__jsp_taghandler_49.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_49.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_49,2);
            }
            out.write(__oracle_jsp_text[99]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_50=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_50.setParent(__jsp_taghandler_28);
              __jsp_taghandler_50.setValue("WITHREM");
              __jsp_tag_starteval=__jsp_taghandler_50.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_50,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[100]);
                } while (__jsp_taghandler_50.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_50.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_50,2);
            }
            out.write(__oracle_jsp_text[101]);
          } while (__jsp_taghandler_28.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,1);
      }
      out.write(__oracle_jsp_text[102]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_51=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
        __jsp_taghandler_51.setParent(null);
        __jsp_taghandler_51.setName("fell002");
        __jsp_taghandler_51.setProperty("srchRestowedOrder1");
        __jsp_taghandler_51.setStyle("width:98%");
        __jsp_taghandler_51.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_51.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_51,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[103]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_52=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_52.setParent(__jsp_taghandler_51);
              __jsp_taghandler_52.setValue("");
              __jsp_tag_starteval=__jsp_taghandler_52.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_52,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[104]);
                } while (__jsp_taghandler_52.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_52.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_52,2);
            }
            out.write(__oracle_jsp_text[105]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_53=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_53.setParent(__jsp_taghandler_51);
              __jsp_taghandler_53.setValue("FK_BOOKING_NO");
              __jsp_tag_starteval=__jsp_taghandler_53.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_53,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[106]);
                } while (__jsp_taghandler_53.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_53.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_53,2);
            }
            out.write(__oracle_jsp_text[107]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_54=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_54.setParent(__jsp_taghandler_51);
              __jsp_taghandler_54.setValue("FK_CONTAINER_OPERATOR");
              __jsp_tag_starteval=__jsp_taghandler_54.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_54,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[108]);
                } while (__jsp_taghandler_54.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_54.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_54,2);
            }
            out.write(__oracle_jsp_text[109]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_55=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_55.setParent(__jsp_taghandler_51);
              __jsp_taghandler_55.setValue("DN_EQUIPMENT_NO");
              __jsp_tag_starteval=__jsp_taghandler_55.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_55,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[110]);
                } while (__jsp_taghandler_55.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_55.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_55,2);
            }
            out.write(__oracle_jsp_text[111]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_56=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_56.setParent(__jsp_taghandler_51);
              __jsp_taghandler_56.setValue("LOAD_CONDITION");
              __jsp_tag_starteval=__jsp_taghandler_56.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_56,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[112]);
                } while (__jsp_taghandler_56.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_56.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_56,2);
            }
            out.write(__oracle_jsp_text[113]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_57=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_57.setParent(__jsp_taghandler_51);
              __jsp_taghandler_57.setValue("DN_EQ_SIZE");
              __jsp_tag_starteval=__jsp_taghandler_57.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_57,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[114]);
                } while (__jsp_taghandler_57.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_57.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_57,2);
            }
            out.write(__oracle_jsp_text[115]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_58=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_58.setParent(__jsp_taghandler_51);
              __jsp_taghandler_58.setValue("FK_SLOT_OPERATOR");
              __jsp_tag_starteval=__jsp_taghandler_58.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_58,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[116]);
                } while (__jsp_taghandler_58.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_58.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_58,2);
            }
            out.write(__oracle_jsp_text[117]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_59=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_59.setParent(__jsp_taghandler_51);
              __jsp_taghandler_59.setValue("DN_SOC_COC");
              __jsp_tag_starteval=__jsp_taghandler_59.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_59,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[118]);
                } while (__jsp_taghandler_59.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_59.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_59,2);
            }
            out.write(__oracle_jsp_text[119]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_60=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_60.setParent(__jsp_taghandler_51);
              __jsp_taghandler_60.setValue("DN_SPECIAL_HNDL");
              __jsp_tag_starteval=__jsp_taghandler_60.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_60,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[120]);
                } while (__jsp_taghandler_60.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_60.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_60,2);
            }
            out.write(__oracle_jsp_text[121]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_61=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_61.setParent(__jsp_taghandler_51);
              __jsp_taghandler_61.setValue("STOWAGE_POSITION");
              __jsp_tag_starteval=__jsp_taghandler_61.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_61,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[122]);
                } while (__jsp_taghandler_61.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_61.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_61,2);
            }
            out.write(__oracle_jsp_text[123]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_62=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_62.setParent(__jsp_taghandler_51);
              __jsp_taghandler_62.setValue("DN_EQ_TYPE");
              __jsp_tag_starteval=__jsp_taghandler_62.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_62,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[124]);
                } while (__jsp_taghandler_62.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_62.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_62,2);
            }
            out.write(__oracle_jsp_text[125]);
          } while (__jsp_taghandler_51.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_51.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_51,1);
      }
      out.write(__oracle_jsp_text[126]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_63=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
        __jsp_taghandler_63.setParent(null);
        __jsp_taghandler_63.setName("fell002");
        __jsp_taghandler_63.setProperty("srchRestowedOrder1Ord");
        __jsp_taghandler_63.setStyle("width:98%");
        __jsp_taghandler_63.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_63.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_63,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[127]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_64=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_64.setParent(__jsp_taghandler_63);
              __jsp_taghandler_64.setValue("");
              __jsp_tag_starteval=__jsp_taghandler_64.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_64,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[128]);
                } while (__jsp_taghandler_64.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_64.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_64,2);
            }
            out.write(__oracle_jsp_text[129]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_65=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_65.setParent(__jsp_taghandler_63);
              __jsp_taghandler_65.setValue("ASC");
              __jsp_tag_starteval=__jsp_taghandler_65.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_65,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[130]);
                } while (__jsp_taghandler_65.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_65.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_65,2);
            }
            out.write(__oracle_jsp_text[131]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_66=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_66.setParent(__jsp_taghandler_63);
              __jsp_taghandler_66.setValue("DESC");
              __jsp_tag_starteval=__jsp_taghandler_66.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_66,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[132]);
                } while (__jsp_taghandler_66.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_66.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_66,2);
            }
            out.write(__oracle_jsp_text[133]);
          } while (__jsp_taghandler_63.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_63.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_63,1);
      }
      out.write(__oracle_jsp_text[134]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_67=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
        __jsp_taghandler_67.setParent(null);
        __jsp_taghandler_67.setName("fell002");
        __jsp_taghandler_67.setProperty("srchRestowedOrder2");
        __jsp_taghandler_67.setStyle("width:98%");
        __jsp_taghandler_67.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_67.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_67,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[135]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_68=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_68.setParent(__jsp_taghandler_67);
              __jsp_taghandler_68.setValue("");
              __jsp_tag_starteval=__jsp_taghandler_68.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_68,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[136]);
                } while (__jsp_taghandler_68.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_68.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_68,2);
            }
            out.write(__oracle_jsp_text[137]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_69=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_69.setParent(__jsp_taghandler_67);
              __jsp_taghandler_69.setValue("FK_BOOKING_NO");
              __jsp_tag_starteval=__jsp_taghandler_69.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_69,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[138]);
                } while (__jsp_taghandler_69.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_69.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_69,2);
            }
            out.write(__oracle_jsp_text[139]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_70=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_70.setParent(__jsp_taghandler_67);
              __jsp_taghandler_70.setValue("FK_CONTAINER_OPERATOR");
              __jsp_tag_starteval=__jsp_taghandler_70.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_70,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[140]);
                } while (__jsp_taghandler_70.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_70.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_70,2);
            }
            out.write(__oracle_jsp_text[141]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_71=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_71.setParent(__jsp_taghandler_67);
              __jsp_taghandler_71.setValue("DN_EQUIPMENT_NO");
              __jsp_tag_starteval=__jsp_taghandler_71.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_71,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[142]);
                } while (__jsp_taghandler_71.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_71.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_71,2);
            }
            out.write(__oracle_jsp_text[143]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_72=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_72.setParent(__jsp_taghandler_67);
              __jsp_taghandler_72.setValue("LOAD_CONDITION");
              __jsp_tag_starteval=__jsp_taghandler_72.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_72,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[144]);
                } while (__jsp_taghandler_72.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_72.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_72,2);
            }
            out.write(__oracle_jsp_text[145]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_73=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_73.setParent(__jsp_taghandler_67);
              __jsp_taghandler_73.setValue("DN_EQ_SIZE");
              __jsp_tag_starteval=__jsp_taghandler_73.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_73,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[146]);
                } while (__jsp_taghandler_73.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_73.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_73,2);
            }
            out.write(__oracle_jsp_text[147]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_74=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_74.setParent(__jsp_taghandler_67);
              __jsp_taghandler_74.setValue("FK_SLOT_OPERATOR");
              __jsp_tag_starteval=__jsp_taghandler_74.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_74,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[148]);
                } while (__jsp_taghandler_74.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_74.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_74,2);
            }
            out.write(__oracle_jsp_text[149]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_75=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_75.setParent(__jsp_taghandler_67);
              __jsp_taghandler_75.setValue("DN_SOC_COC");
              __jsp_tag_starteval=__jsp_taghandler_75.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_75,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[150]);
                } while (__jsp_taghandler_75.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_75.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_75,2);
            }
            out.write(__oracle_jsp_text[151]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_76=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_76.setParent(__jsp_taghandler_67);
              __jsp_taghandler_76.setValue("DN_SPECIAL_HNDL");
              __jsp_tag_starteval=__jsp_taghandler_76.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_76,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[152]);
                } while (__jsp_taghandler_76.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_76.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_76,2);
            }
            out.write(__oracle_jsp_text[153]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_77=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_77.setParent(__jsp_taghandler_67);
              __jsp_taghandler_77.setValue("STOWAGE_POSITION");
              __jsp_tag_starteval=__jsp_taghandler_77.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_77,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[154]);
                } while (__jsp_taghandler_77.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_77.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_77,2);
            }
            out.write(__oracle_jsp_text[155]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_78=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_78.setParent(__jsp_taghandler_67);
              __jsp_taghandler_78.setValue("DN_EQ_TYPE");
              __jsp_tag_starteval=__jsp_taghandler_78.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_78,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[156]);
                } while (__jsp_taghandler_78.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_78.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_78,2);
            }
            out.write(__oracle_jsp_text[157]);
          } while (__jsp_taghandler_67.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_67.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_67,1);
      }
      out.write(__oracle_jsp_text[158]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_79=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
        __jsp_taghandler_79.setParent(null);
        __jsp_taghandler_79.setName("fell002");
        __jsp_taghandler_79.setProperty("srchRestowedOrder2Ord");
        __jsp_taghandler_79.setStyle("width:98%");
        __jsp_taghandler_79.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_79.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_79,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[159]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_80=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_80.setParent(__jsp_taghandler_79);
              __jsp_taghandler_80.setValue("");
              __jsp_tag_starteval=__jsp_taghandler_80.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_80,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[160]);
                } while (__jsp_taghandler_80.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_80.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_80,2);
            }
            out.write(__oracle_jsp_text[161]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_81=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_81.setParent(__jsp_taghandler_79);
              __jsp_taghandler_81.setValue("ASC");
              __jsp_tag_starteval=__jsp_taghandler_81.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_81,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[162]);
                } while (__jsp_taghandler_81.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_81.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_81,2);
            }
            out.write(__oracle_jsp_text[163]);
            {
              org.apache.struts.taglib.html.OptionTag __jsp_taghandler_82=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
              __jsp_taghandler_82.setParent(__jsp_taghandler_79);
              __jsp_taghandler_82.setValue("DESC");
              __jsp_tag_starteval=__jsp_taghandler_82.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_82,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[164]);
                } while (__jsp_taghandler_82.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_82.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_82,2);
            }
            out.write(__oracle_jsp_text[165]);
          } while (__jsp_taghandler_79.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_79.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_79,1);
      }
      out.write(__oracle_jsp_text[166]);
      {
        org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_83=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
        __jsp_taghandler_83.setParent(null);
        __jsp_taghandler_83.setName("fell002");
        __jsp_taghandler_83.setProperty("readOnlyFlg");
        __jsp_taghandler_83.setValue("E");
        __jsp_tag_starteval=__jsp_taghandler_83.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[167]);
          } while (__jsp_taghandler_83.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_83.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_83,1);
      }
      out.write(__oracle_jsp_text[168]);
      {
        org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_84=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
        __jsp_taghandler_84.setParent(null);
        __jsp_taghandler_84.setName("fell002");
        __jsp_taghandler_84.setProperty("readOnlyFlg");
        __jsp_taghandler_84.setValue("E");
        __jsp_tag_starteval=__jsp_taghandler_84.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[169]);
            {
              String __url=OracleJspRuntime.toStr("../ell/EllLoadListMaintenanceRestowedTabGrid.jsp");
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[170]);
          } while (__jsp_taghandler_84.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_84.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_84,1);
      }
      out.write(__oracle_jsp_text[171]);
      {
        org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_85=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
        __jsp_taghandler_85.setParent(null);
        __jsp_taghandler_85.setName("fell002");
        __jsp_taghandler_85.setProperty("readOnlyFlg");
        __jsp_taghandler_85.setValue("E");
        __jsp_tag_starteval=__jsp_taghandler_85.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[172]);
            {
              String __url=OracleJspRuntime.toStr("/pages/ell/EllLoadListMaintenanceRestowedTabViewOnlyGrid.jsp");
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[173]);
          } while (__jsp_taghandler_85.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_85.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_85,1);
      }
      out.write(__oracle_jsp_text[174]);

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
  private static final char __oracle_jsp_text[][]=new char[175][];
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
    "\n\n    <!-- Tab Search Section -->\n    <table class=\"table_search\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n    <tbody>\n    <tr>\n    <td>View</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[6] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[7] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[8] = 
    "\n    </td>\n    \n    <td>&nbsp;&nbsp;&nbsp;Find1</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[9] = 
    "\n    </td> \n    \n    <td>&nbsp;&nbsp;&nbsp;In1</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[10] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[11] = 
    "Select One...".toCharArray();
    __oracle_jsp_text[12] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[13] = 
    "Booking #".toCharArray();
    __oracle_jsp_text[14] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[15] = 
    "Container Operator".toCharArray();
    __oracle_jsp_text[16] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[17] = 
    "Equipment#".toCharArray();
    __oracle_jsp_text[18] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[19] = 
    "Load condition".toCharArray();
    __oracle_jsp_text[20] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[21] = 
    "Shipment type".toCharArray();
    __oracle_jsp_text[22] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[23] = 
    "Size".toCharArray();
    __oracle_jsp_text[24] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[25] = 
    "Slot Operator".toCharArray();
    __oracle_jsp_text[26] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[27] = 
    "SOC/COC".toCharArray();
    __oracle_jsp_text[28] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[29] = 
    "Special Handling".toCharArray();
    __oracle_jsp_text[30] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[31] = 
    "Type".toCharArray();
    __oracle_jsp_text[32] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[33] = 
    "Last 3 digits of equipment number".toCharArray();
    __oracle_jsp_text[34] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[35] = 
    "BB Cargo".toCharArray();
    __oracle_jsp_text[36] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[37] = 
    "COC Customer".toCharArray();
    __oracle_jsp_text[38] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[39] = 
    "COC Empty".toCharArray();
    __oracle_jsp_text[40] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[41] = 
    "COC Transshipped".toCharArray();
    __oracle_jsp_text[42] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[43] = 
    "SOC all".toCharArray();
    __oracle_jsp_text[44] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[45] = 
    "SOC direct".toCharArray();
    __oracle_jsp_text[46] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[47] = 
    "SOC Partner".toCharArray();
    __oracle_jsp_text[48] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[49] = 
    "SOC transshipped".toCharArray();
    __oracle_jsp_text[50] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[51] = 
    "Transshipped".toCharArray();
    __oracle_jsp_text[52] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[53] = 
    "With Remarks".toCharArray();
    __oracle_jsp_text[54] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[55] = 
    "\n    </td>                \n    \n    <td>&nbsp;&nbsp;&nbsp;Find2</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[56] = 
    "\n    </td> \n    \n    <td>&nbsp;&nbsp;&nbsp;In2</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[57] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[58] = 
    "Select One...".toCharArray();
    __oracle_jsp_text[59] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[60] = 
    "Booking #".toCharArray();
    __oracle_jsp_text[61] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[62] = 
    "Container Operator".toCharArray();
    __oracle_jsp_text[63] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[64] = 
    "Equipment#".toCharArray();
    __oracle_jsp_text[65] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[66] = 
    "Load condition".toCharArray();
    __oracle_jsp_text[67] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[68] = 
    "Shipment type".toCharArray();
    __oracle_jsp_text[69] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[70] = 
    "Size".toCharArray();
    __oracle_jsp_text[71] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[72] = 
    "Slot Operator".toCharArray();
    __oracle_jsp_text[73] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[74] = 
    "SOC/COC".toCharArray();
    __oracle_jsp_text[75] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[76] = 
    "Special Handling".toCharArray();
    __oracle_jsp_text[77] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[78] = 
    "Type".toCharArray();
    __oracle_jsp_text[79] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[80] = 
    "Last 3 digits of equipment number".toCharArray();
    __oracle_jsp_text[81] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[82] = 
    "BB Cargo".toCharArray();
    __oracle_jsp_text[83] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[84] = 
    "COC Customer".toCharArray();
    __oracle_jsp_text[85] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[86] = 
    "COC Empty".toCharArray();
    __oracle_jsp_text[87] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[88] = 
    "COC Transshipped".toCharArray();
    __oracle_jsp_text[89] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[90] = 
    "SOC all".toCharArray();
    __oracle_jsp_text[91] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[92] = 
    "SOC direct".toCharArray();
    __oracle_jsp_text[93] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[94] = 
    "SOC Partner".toCharArray();
    __oracle_jsp_text[95] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[96] = 
    "SOC transshipped".toCharArray();
    __oracle_jsp_text[97] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[98] = 
    "Transshipped".toCharArray();
    __oracle_jsp_text[99] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[100] = 
    "With Remarks".toCharArray();
    __oracle_jsp_text[101] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[102] = 
    "\n    </td>             \n    </tr>\n    \n    <tr>\n    <td>Order1</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[103] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[104] = 
    "Select One...".toCharArray();
    __oracle_jsp_text[105] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[106] = 
    "Booking #".toCharArray();
    __oracle_jsp_text[107] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[108] = 
    "Container Operator".toCharArray();
    __oracle_jsp_text[109] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[110] = 
    "Equipment #".toCharArray();
    __oracle_jsp_text[111] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[112] = 
    "Load Condition".toCharArray();
    __oracle_jsp_text[113] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[114] = 
    "Size".toCharArray();
    __oracle_jsp_text[115] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[116] = 
    "Slot Operator".toCharArray();
    __oracle_jsp_text[117] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[118] = 
    "SOC/COC".toCharArray();
    __oracle_jsp_text[119] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[120] = 
    "Special Handling".toCharArray();
    __oracle_jsp_text[121] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[122] = 
    "Stowage Position".toCharArray();
    __oracle_jsp_text[123] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[124] = 
    "Type".toCharArray();
    __oracle_jsp_text[125] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[126] = 
    "\n    </td>\n    \n    <td>&nbsp;&nbsp;&nbsp;</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[127] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[128] = 
    "Select One...".toCharArray();
    __oracle_jsp_text[129] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[130] = 
    "Ascending".toCharArray();
    __oracle_jsp_text[131] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[132] = 
    "Descending".toCharArray();
    __oracle_jsp_text[133] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[134] = 
    "                \n    </td>\n    \n    <td>&nbsp;&nbsp;&nbsp;Order2</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[135] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[136] = 
    "Select One...".toCharArray();
    __oracle_jsp_text[137] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[138] = 
    "Booking #".toCharArray();
    __oracle_jsp_text[139] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[140] = 
    "Container Operator".toCharArray();
    __oracle_jsp_text[141] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[142] = 
    "Equipment #".toCharArray();
    __oracle_jsp_text[143] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[144] = 
    "Load Condition".toCharArray();
    __oracle_jsp_text[145] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[146] = 
    "Size".toCharArray();
    __oracle_jsp_text[147] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[148] = 
    "Slot Operator".toCharArray();
    __oracle_jsp_text[149] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[150] = 
    "SOC/COC".toCharArray();
    __oracle_jsp_text[151] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[152] = 
    "Special Handling".toCharArray();
    __oracle_jsp_text[153] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[154] = 
    "Stowage Position".toCharArray();
    __oracle_jsp_text[155] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[156] = 
    "Type".toCharArray();
    __oracle_jsp_text[157] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[158] = 
    "\n    </td>\n    \n    <td>&nbsp;&nbsp;&nbsp;</td>\n    <td class=\"whitebg\" width='166px'>\n    ".toCharArray();
    __oracle_jsp_text[159] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[160] = 
    "Select One...".toCharArray();
    __oracle_jsp_text[161] = 
    "    \n    ".toCharArray();
    __oracle_jsp_text[162] = 
    "Ascending".toCharArray();
    __oracle_jsp_text[163] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[164] = 
    "Descending".toCharArray();
    __oracle_jsp_text[165] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[166] = 
    "                \n    </td>\n    </tr>\n    </tbody>\n    </table>            \n    \n    <table class=\"table_search\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n    <tbody>\n    <tr>\n    <td>\n    <div class=\"buttons_box\">\n        ".toCharArray();
    __oracle_jsp_text[167] = 
    "    \n            <input type=\"button\" value=\"Save Setting\" name=\"btnSaveSetting\" class=\"event_btnbutton\" onclick='return onSaveSett()'/>\n            <input type=\"button\" value=\"Excel Upload\" name=\"btnExcelUpload\" class=\"event_btnbutton\" onclick='return excelUpload()'/>\n            <input type=\"button\" value=\"Excel Download\" name=\"btnExcelDownload\" class=\"event_btnbutton\" onclick='return excelDownload()'/>\n    ".toCharArray();
    __oracle_jsp_text[168] = 
    "\n    <input type=\"button\" value=\"Refresh\" name=\"btnRefresh\" class=\"event_btnbutton\" onclick='return onRefresh()'/>\n    <input type=\"button\" value=\"Reset\" name=\"btnReset\" class=\"event_btnbutton\" onclick='return onResetForm()'/>\n    <input id='btnFind' type=\"button\" value=\"Find\" name=\"btnFind\" class=\"event_btnbutton\" onclick='return onSearch()'/>\n    </div>\n    </td>\n    </tr>\n    </tbody>\n    </table>\n    \n    <div class=\"text_header\"><h2>Load List Detail</h2></div>\n    \n    ".toCharArray();
    __oracle_jsp_text[169] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[170] = 
    "  \n    ".toCharArray();
    __oracle_jsp_text[171] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[172] = 
    "                \n        ".toCharArray();
    __oracle_jsp_text[173] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[174] = 
    "    \n\n    </div>".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
