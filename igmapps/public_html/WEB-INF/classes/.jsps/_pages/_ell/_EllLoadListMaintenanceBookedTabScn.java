package _pages._ell;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;


public class _EllLoadListMaintenanceBookedTabScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EllLoadListMaintenanceBookedTabScn page = this;
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
        org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_1=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setName("fell002");
        __jsp_taghandler_1.setProperty("restowedId");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[6]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_2=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
        __jsp_taghandler_2.setParent(null);
        __jsp_taghandler_2.setName("fell002");
        __jsp_taghandler_2.setOnchange("getGridSearchCriteria();changeValIn1();changeValIn2();setHiddenView();");
        __jsp_taghandler_2.setProperty("bookedView");
        __jsp_taghandler_2.setStyle("width:98%");
        __jsp_taghandler_2.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_2,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[7]);
            {
              org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_3=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
              __jsp_taghandler_3.setParent(__jsp_taghandler_2);
              __jsp_taghandler_3.setLabel("name");
              __jsp_taghandler_3.setName("fell002");
              __jsp_taghandler_3.setProperty("bookedViewValues");
              __jsp_taghandler_3.setValue("code");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[8]);
          } while (__jsp_taghandler_2.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,1);
      }
      out.write(__oracle_jsp_text[9]);
      {
        org.apache.struts.taglib.html.TextTag __jsp_taghandler_4=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
        __jsp_taghandler_4.setParent(null);
        __jsp_taghandler_4.setMaxlength("15");
        __jsp_taghandler_4.setName("fell002");
        __jsp_taghandler_4.setOnblur("changeUpper(this)");
        __jsp_taghandler_4.setProperty("srchBookingFind1");
        __jsp_taghandler_4.setStyle("width:96%");
        __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
        if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,1);
      }
      out.write(__oracle_jsp_text[10]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_5=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
        __jsp_taghandler_5.setParent(null);
        __jsp_taghandler_5.setName("fell002");
        __jsp_taghandler_5.setOnchange("changeValIn1()");
        __jsp_taghandler_5.setProperty("srchBookingIn1");
        __jsp_taghandler_5.setStyle("width:98%");
        __jsp_taghandler_5.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_5,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[11]);
            {
              org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_6=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
              __jsp_taghandler_6.setParent(__jsp_taghandler_5);
              __jsp_taghandler_6.setLabel("name");
              __jsp_taghandler_6.setName("fell002");
              __jsp_taghandler_6.setProperty("llBookingInValues");
              __jsp_taghandler_6.setValue("code");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[12]);
          } while (__jsp_taghandler_5.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,1);
      }
      out.write(__oracle_jsp_text[13]);
      {
        org.apache.struts.taglib.html.TextTag __jsp_taghandler_7=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
        __jsp_taghandler_7.setParent(null);
        __jsp_taghandler_7.setMaxlength("15");
        __jsp_taghandler_7.setName("fell002");
        __jsp_taghandler_7.setOnblur("changeUpper(this)");
        __jsp_taghandler_7.setProperty("srchBookingFind2");
        __jsp_taghandler_7.setStyle("width:96%");
        __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
        if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,1);
      }
      out.write(__oracle_jsp_text[14]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_8=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
        __jsp_taghandler_8.setParent(null);
        __jsp_taghandler_8.setName("fell002");
        __jsp_taghandler_8.setOnchange("changeValIn2()");
        __jsp_taghandler_8.setProperty("srchBookingIn2");
        __jsp_taghandler_8.setStyle("width:98%");
        __jsp_taghandler_8.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_8,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[15]);
            {
              org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_9=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
              __jsp_taghandler_9.setParent(__jsp_taghandler_8);
              __jsp_taghandler_9.setLabel("name");
              __jsp_taghandler_9.setName("fell002");
              __jsp_taghandler_9.setProperty("llBookingInValues");
              __jsp_taghandler_9.setValue("code");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[16]);
          } while (__jsp_taghandler_8.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,1);
      }
      out.write(__oracle_jsp_text[17]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_10=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
        __jsp_taghandler_10.setParent(null);
        __jsp_taghandler_10.setName("fell002");
        __jsp_taghandler_10.setProperty("srchBookingOrder1");
        __jsp_taghandler_10.setStyle("width:98%");
        __jsp_taghandler_10.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_10,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[18]);
            {
              org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_11=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
              __jsp_taghandler_11.setParent(__jsp_taghandler_10);
              __jsp_taghandler_11.setLabel("name");
              __jsp_taghandler_11.setName("fell002");
              __jsp_taghandler_11.setProperty("llBookingOrderValues");
              __jsp_taghandler_11.setValue("code");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[19]);
          } while (__jsp_taghandler_10.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,1);
      }
      out.write(__oracle_jsp_text[20]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_12=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
        __jsp_taghandler_12.setParent(null);
        __jsp_taghandler_12.setName("fell002");
        __jsp_taghandler_12.setProperty("srchBookingOrder1Ord");
        __jsp_taghandler_12.setStyle("width:98%");
        __jsp_taghandler_12.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_12,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[21]);
            {
              org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_13=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
              __jsp_taghandler_13.setParent(__jsp_taghandler_12);
              __jsp_taghandler_13.setLabel("name");
              __jsp_taghandler_13.setName("fell002");
              __jsp_taghandler_13.setProperty("bookingOrder2OrdValues");
              __jsp_taghandler_13.setValue("code");
              __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
              if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,2);
            }
            out.write(__oracle_jsp_text[22]);
          } while (__jsp_taghandler_12.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,1);
      }
      out.write(__oracle_jsp_text[23]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_14=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
        __jsp_taghandler_14.setParent(null);
        __jsp_taghandler_14.setName("fell002");
        __jsp_taghandler_14.setProperty("srchBookingOrder2");
        __jsp_taghandler_14.setStyle("width:98%");
        __jsp_taghandler_14.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_14,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[24]);
            {
              org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_15=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
              __jsp_taghandler_15.setParent(__jsp_taghandler_14);
              __jsp_taghandler_15.setLabel("name");
              __jsp_taghandler_15.setName("fell002");
              __jsp_taghandler_15.setProperty("llBookingOrderValues");
              __jsp_taghandler_15.setValue("code");
              __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
              if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,2);
            }
            out.write(__oracle_jsp_text[25]);
          } while (__jsp_taghandler_14.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,1);
      }
      out.write(__oracle_jsp_text[26]);
      {
        org.apache.struts.taglib.html.SelectTag __jsp_taghandler_16=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
        __jsp_taghandler_16.setParent(null);
        __jsp_taghandler_16.setName("fell002");
        __jsp_taghandler_16.setProperty("srchBookingOrder2Ord");
        __jsp_taghandler_16.setStyle("width:98%");
        __jsp_taghandler_16.setSize("1");
        __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_16,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[27]);
            {
              org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_17=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
              __jsp_taghandler_17.setParent(__jsp_taghandler_16);
              __jsp_taghandler_17.setLabel("name");
              __jsp_taghandler_17.setName("fell002");
              __jsp_taghandler_17.setProperty("bookingOrder2OrdValues");
              __jsp_taghandler_17.setValue("code");
              __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
              if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,2);
            }
            out.write(__oracle_jsp_text[28]);
          } while (__jsp_taghandler_16.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,1);
      }
      out.write(__oracle_jsp_text[29]);
      {
        org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_18=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
        __jsp_taghandler_18.setParent(null);
        __jsp_taghandler_18.setName("fell002");
        __jsp_taghandler_18.setProperty("readOnlyFlg");
        __jsp_taghandler_18.setValue("E");
        __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[30]);
          } while (__jsp_taghandler_18.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,1);
      }
      out.write(__oracle_jsp_text[31]);
      {
        org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_19=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
        __jsp_taghandler_19.setParent(null);
        __jsp_taghandler_19.setName("fell002");
        __jsp_taghandler_19.setProperty("readOnlyFlg");
        __jsp_taghandler_19.setValue("E");
        __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[32]);
            {
              String __url=OracleJspRuntime.toStr("../ell/EllLoadListMaintenanceBookedTabGrid.jsp");
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[33]);
          } while (__jsp_taghandler_19.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,1);
      }
      out.write(__oracle_jsp_text[34]);
      {
        org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_20=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
        __jsp_taghandler_20.setParent(null);
        __jsp_taghandler_20.setName("fell002");
        __jsp_taghandler_20.setProperty("readOnlyFlg");
        __jsp_taghandler_20.setValue("E");
        __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[35]);
            {
              String __url=OracleJspRuntime.toStr("/pages/ell/EllLoadListMaintenanceBookedTabViewOnlyGrid.jsp");
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[36]);
          } while (__jsp_taghandler_20.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,1);
      }
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
    "\n\n<div class=\"tab\" id=\"tab1\">\n    ".toCharArray();
    __oracle_jsp_text[6] = 
    "\n    \n    <!-- Tab Search Section -->\n    <table class=\"table_search\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n    <tbody>\n        <tr>\n            <td>View</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[7] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[8] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[9] = 
    "\n            </td>\n            \n            <td>&nbsp;&nbsp;&nbsp;Find1</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[10] = 
    "\n            </td> \n            \n            <td>&nbsp;&nbsp;&nbsp;In1</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[11] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[12] = 
    "                  \n                ".toCharArray();
    __oracle_jsp_text[13] = 
    "\n            </td>                \n    \n            <td>&nbsp;&nbsp;&nbsp;Find2</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[14] = 
    "\n            </td> \n            \n            <td>&nbsp;&nbsp;&nbsp;In2</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[15] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[16] = 
    "                                  \n                ".toCharArray();
    __oracle_jsp_text[17] = 
    "\n            </td>             \n        </tr>\n        \n        <tr>\n            <td>Order1</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[18] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[19] = 
    "                                  \n                ".toCharArray();
    __oracle_jsp_text[20] = 
    "\n            </td>\n            \n            <td>&nbsp;&nbsp;&nbsp;</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[21] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[22] = 
    "                                  \n                ".toCharArray();
    __oracle_jsp_text[23] = 
    "                \n            </td>\n\n            <td>&nbsp;&nbsp;&nbsp;Order2</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[24] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[25] = 
    "                                  \n                ".toCharArray();
    __oracle_jsp_text[26] = 
    "\n            </td>\n            \n            <td>&nbsp;&nbsp;&nbsp;</td>\n            <td class=\"whitebg\" width='166px'>\n                ".toCharArray();
    __oracle_jsp_text[27] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[28] = 
    "                                                  \n                ".toCharArray();
    __oracle_jsp_text[29] = 
    "                \n            </td>\n        </tr>\n    </tbody>\n    </table>            \n\n    <table class=\"table_search\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n    <tbody>\n        <tr>\n            <td>\n            <div class=\"buttons_box\">\n                ".toCharArray();
    __oracle_jsp_text[30] = 
    "    \n\t\t\t\t    <input type=\"button\" value=\"Bulk Update\" name=\"btnBulkUpdate\" class=\"event_btnbutton\" onclick='return bulkUpdate(2)'/>\n                    <input type=\"button\" value=\"Declare Loadings\" name=\"btnDeclareLoadList\" class=\"event_btnbutton\" onclick='return declareLoadList()'/>\n                    <input type=\"button\" value=\"Create Arrival Bayplan\" name=\"btnCreateArrivalBayplan\" class=\"event_btnbutton\" onclick='return createArrivalBayplan()'/>\n                    <input type=\"button\" value=\"Save Setting\" name=\"btnSaveSetting\" class=\"event_btnbutton\" onclick='return onSaveSett()'/>\n                    <input type=\"button\" value=\"Excel Upload\" name=\"btnExcelUpload\" class=\"event_btnbutton\" onclick='return excelUpload()'/>\n                    <input type=\"button\" value=\"Excel Download\" name=\"btnExcelDownload\" class=\"event_btnbutton\" onclick='return excelDownload()'/>\n                ".toCharArray();
    __oracle_jsp_text[31] = 
    "\n                <input type=\"button\" value=\"Refresh\" name=\"btnRefresh\" class=\"event_btnbutton\" onclick='return onRefresh()'/>\n                <input type=\"button\" value=\"Reset\" name=\"btnReset\" class=\"event_btnbutton\" onclick='return onResetForm()'/>\n                <input id = 'btnFind' type=\"button\" value=\"Find\" name=\"btnFind\" class=\"event_btnbutton\" onclick='return onSearch()'/>\n            </div>\n            </td>\n       </tr>\n    </tbody>\n    </table>\n    \n    <div class=\"text_header\"><h2>Booked Detail</h2></div>\n\n        ".toCharArray();
    __oracle_jsp_text[32] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[33] = 
    "  \n        ".toCharArray();
    __oracle_jsp_text[34] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[35] = 
    "                \n            ".toCharArray();
    __oracle_jsp_text[36] = 
    "\n        ".toCharArray();
    __oracle_jsp_text[37] = 
    "\n\n    </div>    \n    \n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
