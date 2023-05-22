package _pages._edl;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;
import com.niit.control.web.action.BaseAction;


public class _EdlContainerReplacementScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EdlContainerReplacementScn page = this;
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
         // UserAccountBean account=(UserAccountBean)session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
         // String lstrUserId = account.getUserId();
      
      
      out.write(__oracle_jsp_text[6]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[7]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl003save", pageContext));
      out.write(__oracle_jsp_text[8]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl003back", pageContext));
      out.write(__oracle_jsp_text[9]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/sedl003");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[10]);
            out.write(__oracle_jsp_text[11]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_2=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property styleClass");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setMaxlength("10");
              __jsp_taghandler_2.setName("fedl003");
              __jsp_taghandler_2.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_2.setOnclick("this.select();");
              __jsp_taghandler_2.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_2.setProperty("date");
              __jsp_taghandler_2.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[12]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_3=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property styleClass");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setMaxlength("5");
              __jsp_taghandler_3.setName("fedl003");
              __jsp_taghandler_3.setOnblur("timeFormat();");
              __jsp_taghandler_3.setOnclick("this.select();");
              __jsp_taghandler_3.setProperty("time");
              __jsp_taghandler_3.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[14]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_4=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag name property readonly size styleClass tabindex");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fedl003");
              __jsp_taghandler_4.setProperty("terminal");
              __jsp_taghandler_4.setReadonly(true);
              __jsp_taghandler_4.setSize("10");
              __jsp_taghandler_4.setStyleClass("non_edit");
              __jsp_taghandler_4.setTabindex("-1");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[15]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_5=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag name property readonly size styleClass tabindex");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setName("fedl003");
              __jsp_taghandler_5.setProperty("bookingNo");
              __jsp_taghandler_5.setReadonly(true);
              __jsp_taghandler_5.setSize("17");
              __jsp_taghandler_5.setStyleClass("non_edit");
              __jsp_taghandler_5.setTabindex("-1");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[16]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_6=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag name property readonly size styleClass tabindex");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setName("fedl003");
              __jsp_taghandler_6.setProperty("oldContainerNo");
              __jsp_taghandler_6.setReadonly(true);
              __jsp_taghandler_6.setSize("12");
              __jsp_taghandler_6.setStyleClass("non_edit");
              __jsp_taghandler_6.setTabindex("-1");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[17]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_7=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag name property readonly size styleClass tabindex");
              __jsp_taghandler_7.setParent(__jsp_taghandler_1);
              __jsp_taghandler_7.setName("fedl003");
              __jsp_taghandler_7.setProperty("oldShippersSeal");
              __jsp_taghandler_7.setReadonly(true);
              __jsp_taghandler_7.setSize("20");
              __jsp_taghandler_7.setStyleClass("non_edit");
              __jsp_taghandler_7.setTabindex("-1");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[18]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_8=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property styleClass");
              __jsp_taghandler_8.setParent(__jsp_taghandler_1);
              __jsp_taghandler_8.setMaxlength("12");
              __jsp_taghandler_8.setName("fedl003");
              __jsp_taghandler_8.setOnblur("changeUpper(this)");
              __jsp_taghandler_8.setProperty("newContainerNo");
              __jsp_taghandler_8.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
              if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,2);
            }
            out.write(__oracle_jsp_text[19]);
            out.write(__oracle_jsp_text[20]);
            {
              org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_9=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
              __jsp_taghandler_9.setParent(__jsp_taghandler_1);
              __jsp_taghandler_9.setName("fedl003");
              __jsp_taghandler_9.setProperty("flagSocCoc");
              __jsp_taghandler_9.setValue("SOC");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[21]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_10=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property");
                    __jsp_taghandler_10.setParent(__jsp_taghandler_9);
                    __jsp_taghandler_10.setMaxlength("12");
                    __jsp_taghandler_10.setName("fedl003");
                    __jsp_taghandler_10.setOnblur("changeUpper(this)");
                    __jsp_taghandler_10.setProperty("newShippersSeal");
                    __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
                    if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,3);
                  }
                  out.write(__oracle_jsp_text[22]);
                } while (__jsp_taghandler_9.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[23]);
            {
              org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_11=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
              __jsp_taghandler_11.setParent(__jsp_taghandler_1);
              __jsp_taghandler_11.setName("fedl003");
              __jsp_taghandler_11.setProperty("flagSocCoc");
              __jsp_taghandler_11.setValue("COC");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[24]);
                  {
                    org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_12=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                    __jsp_taghandler_12.setParent(__jsp_taghandler_11);
                    __jsp_taghandler_12.setName("fedl003");
                    __jsp_taghandler_12.setProperty("fullMT");
                    __jsp_taghandler_12.setValue("Full");
                    __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[25]);
                        {
                          org.apache.struts.taglib.html.TextTag __jsp_taghandler_13=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property styleClass");
                          __jsp_taghandler_13.setParent(__jsp_taghandler_12);
                          __jsp_taghandler_13.setMaxlength("12");
                          __jsp_taghandler_13.setName("fedl003");
                          __jsp_taghandler_13.setOnblur("changeUpper(this)");
                          __jsp_taghandler_13.setProperty("newShippersSeal");
                          __jsp_taghandler_13.setStyleClass("must");
                          __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
                          if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,4);
                        }
                        out.write(__oracle_jsp_text[26]);
                      } while (__jsp_taghandler_12.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,3);
                  }
                  out.write(__oracle_jsp_text[27]);
                  {
                    org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_14=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                    __jsp_taghandler_14.setParent(__jsp_taghandler_11);
                    __jsp_taghandler_14.setName("fedl003");
                    __jsp_taghandler_14.setProperty("fullMT");
                    __jsp_taghandler_14.setValue("Full");
                    __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[28]);
                        {
                          org.apache.struts.taglib.html.TextTag __jsp_taghandler_15=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property");
                          __jsp_taghandler_15.setParent(__jsp_taghandler_14);
                          __jsp_taghandler_15.setMaxlength("12");
                          __jsp_taghandler_15.setName("fedl003");
                          __jsp_taghandler_15.setOnblur("changeUpper(this)");
                          __jsp_taghandler_15.setProperty("newShippersSeal");
                          __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                          if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,4);
                        }
                        out.write(__oracle_jsp_text[29]);
                      } while (__jsp_taghandler_14.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,3);
                  }
                  out.write(__oracle_jsp_text[30]);
                } while (__jsp_taghandler_11.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[31]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_16=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property styleClass");
              __jsp_taghandler_16.setParent(__jsp_taghandler_1);
              __jsp_taghandler_16.setMaxlength("50");
              __jsp_taghandler_16.setName("fedl003");
              __jsp_taghandler_16.setOnblur("changeUpper(this)");
              __jsp_taghandler_16.setProperty("reason");
              __jsp_taghandler_16.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[32]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_17=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_17.setParent(__jsp_taghandler_1);
              __jsp_taghandler_17.setName("fedl003");
              __jsp_taghandler_17.setProperty(OracleJspRuntime.toStr( "bookingNo"));
              __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
              if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,2);
            }
            out.write(__oracle_jsp_text[33]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_18=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_18.setParent(__jsp_taghandler_1);
              __jsp_taghandler_18.setName("fedl003");
              __jsp_taghandler_18.setProperty(OracleJspRuntime.toStr( "date"));
              __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
              if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,2);
            }
            out.write(__oracle_jsp_text[34]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_19=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_19.setParent(__jsp_taghandler_1);
              __jsp_taghandler_19.setName("fedl003");
              __jsp_taghandler_19.setProperty(OracleJspRuntime.toStr( "terminal"));
              __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
              if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,2);
            }
            out.write(__oracle_jsp_text[35]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_20=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_20.setParent(__jsp_taghandler_1);
              __jsp_taghandler_20.setName("fedl003");
              __jsp_taghandler_20.setProperty(OracleJspRuntime.toStr( "oldContainerNo"));
              __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
              if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,2);
            }
            out.write(__oracle_jsp_text[36]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_21=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_21.setParent(__jsp_taghandler_1);
              __jsp_taghandler_21.setName("fedl003");
              __jsp_taghandler_21.setProperty(OracleJspRuntime.toStr( "oldShippersSeal"));
              __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
              if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,2);
            }
            out.write(__oracle_jsp_text[37]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_22=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_22.setParent(__jsp_taghandler_1);
              __jsp_taghandler_22.setName("fedl003");
              __jsp_taghandler_22.setProperty(OracleJspRuntime.toStr( "newContainerNo"));
              __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
              if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,2);
            }
            out.write(__oracle_jsp_text[38]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_23=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_23.setParent(__jsp_taghandler_1);
              __jsp_taghandler_23.setName("fedl003");
              __jsp_taghandler_23.setProperty(OracleJspRuntime.toStr( "newShippersSeal"));
              __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
              if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,2);
            }
            out.write(__oracle_jsp_text[39]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_24=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_24.setParent(__jsp_taghandler_1);
              __jsp_taghandler_24.setName("fedl003");
              __jsp_taghandler_24.setProperty(OracleJspRuntime.toStr( "reason"));
              __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
              if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,2);
            }
            out.write(__oracle_jsp_text[40]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_25=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_25.setParent(__jsp_taghandler_1);
              __jsp_taghandler_25.setName("fedl003");
              __jsp_taghandler_25.setProperty(OracleJspRuntime.toStr( "bookedId"));
              __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
              if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,2);
            }
            out.write(__oracle_jsp_text[41]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_26=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_26.setParent(__jsp_taghandler_1);
              __jsp_taghandler_26.setName("fedl003");
              __jsp_taghandler_26.setProperty(OracleJspRuntime.toStr( "hdrEtd"));
              __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
              if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,2);
            }
            out.write(__oracle_jsp_text[42]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_27=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_27.setParent(__jsp_taghandler_1);
              __jsp_taghandler_27.setName("fedl003");
              __jsp_taghandler_27.setProperty(OracleJspRuntime.toStr( "hdrEtdTm"));
              __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
              if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,2);
            }
            out.write(__oracle_jsp_text[43]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_28=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_28.setParent(__jsp_taghandler_1);
              __jsp_taghandler_28.setName("fedl003");
              __jsp_taghandler_28.setProperty(OracleJspRuntime.toStr( "hdrPort"));
              __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
              if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,2);
            }
            out.write(__oracle_jsp_text[44]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_29=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_29.setParent(__jsp_taghandler_1);
              __jsp_taghandler_29.setName("fedl003");
              __jsp_taghandler_29.setProperty(OracleJspRuntime.toStr( "fullMT"));
              __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
              if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,2);
            }
            out.write(__oracle_jsp_text[45]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_30=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_30.setParent(__jsp_taghandler_1);
              __jsp_taghandler_30.setName("fedl003");
              __jsp_taghandler_30.setProperty(OracleJspRuntime.toStr( "flagSocCoc"));
              __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
              if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,2);
            }
            out.write(__oracle_jsp_text[46]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[47]);

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
  private static final char __oracle_jsp_text[][]=new char[48][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n<HTML xmlns=\"http://www.w3.org/1999/xhtml\">\r\n\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n\r\n<HEAD>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n<TITLE> </TITLE>\r\n\r\n    <LINK REL=\"stylesheet\" HREF=\"".toCharArray();
    __oracle_jsp_text[7] = 
    "/css/EZL.css\"/>\r\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \r\n    <STYLE TYPE=\"text/css\">\r\n         div.search_result{height:100px;}\r\n         table.table_results tbody{height:100px;}\r\n    </STYLE>\r\n\r\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\r\n    \r\n    var FORM_ID                = 'fedl003';\r\n    var PROG_ID                = 'SEDL003';\r\n    var lastBookingNo          = '';\r\n    var lastDate               = '';\r\n    var lastTerminal           = '';\r\n    var lastOldContainerNo     = '';\r\n    var lastOldShippersSeal    = '';\r\n    var lastNewContainerNo     = '';    \r\n    var lastNewShippersSeal    = '';\r\n    var lastReason             = '';\r\n    \r\n    /*Called by framework on-load of this JSP*/\r\n    function onLoad() {\r\n    }\r\n\r\n    function openHelp() {\r\n        alert('Help...');\r\n        var strFileName = '1';\r\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\r\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\r\n        objWindow.focus();\r\n    }\r\n    /*Called by Save Button*/\r\n    function onSave() {\r\n        lastDate               = document.getElementById(\"date\").value;\r\n        lastNewContainerNo     = document.getElementById(\"newContainerNo\").value;\r\n        lastNewShippersSeal    = document.getElementById(\"newShippersSeal\").value;\r\n        lastReason             = document.getElementById(\"reason\").value;\r\n        flagcoc                = document.getElementById(\"flagSocCoc\").value;\r\n        fullMT                 = document.getElementById(\"fullMT\").value;\r\n        time                   = document.getElementById(\"time\").value;\r\n        \r\n        if ((lastDate =='') || (lastDate == null)){\r\n                showBarMessage(EZL_SE0104,ERROR_MSG);    \r\n                return false;\r\n        }   \r\n\r\n        if ((time =='') || (time == null)){\r\n                showBarMessage(EZL_SE0110,ERROR_MSG);    \r\n                return false;\r\n        }           \r\n        \r\n        if ((lastNewContainerNo =='') || (lastNewContainerNo == null)){\r\n            showBarMessage(EZL_SE0105,ERROR_MSG);    \r\n            return false;    \r\n        }\r\n\r\n        if ((lastReason =='') || (lastReason == null)){\r\n            showBarMessage(EZL_SE0107,ERROR_MSG);    \r\n            return false;    \r\n        }\r\n        \r\n        /* when old container is coc laiden only then new shippersSeal is mandatory then */\r\n        if((flagcoc == 'COC') && (fullMT == 'Full')) {\r\n            if ((lastNewShippersSeal =='') || (lastNewShippersSeal == null)){\r\n                showBarMessage(EZL_SE0106,ERROR_MSG);    \r\n                return false;    \r\n            }\r\n        }\r\n\r\n\t\t/* Check time format */\r\n\t\tif(!timeFormat()) {\r\n\t\t\treturn false;\r\n\t\t}\r\n\t\t\r\n\t\t\t\r\n        /* Disable all controls */\r\n        disableOnSubmit();        \r\n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[8] = 
    "';\r\n        document.forms[0].submit();\r\n        return false;\r\n    }\r\n\r\n    function timeFormat() {\r\n        var time = document.getElementById(\"time\").value;\r\n        var len = 0;\r\n        var t1 = '';\r\n        var t2 = '';\r\n        var t3 = '';\r\n        var formatedTime= '';\r\n        var intFormatedTime= 0;\r\n\t\t\r\n\t\tvar intT1 = 0;\r\n\t\tvar intT2 = 0;\r\n\t\t\r\n        time = trimString(time);\r\n        \r\n        len  = time.length;\r\n        /* time should not be less then four character */\r\n        if(len == 5) {\r\n            t1 = time.substring (0,2);\r\n            t2 = time.substring (3,5);\r\n            t3 = time.substring (2,3);\r\n            if (t3 != \"\\:\") {\r\n                /* Enter valid time. */\r\n                showBarMessage(EZL_SE0111,ERROR_MSG);                    \r\n                return false;\r\n            }\r\n            \r\n            formatedTime = t1 + t2;\r\n        } else if (len == 4) {\r\n            t1 = time.substring (0,2);\r\n            t2 = time.substring (2,4);\r\n            formatedTime = time;\r\n        }\r\n        else {\r\n            /* Time should be of 4 characters. */\r\n            showBarMessage(EZL_SE0112,ERROR_MSG);                    \r\n            return false;\r\n        }\r\n\r\n        /* number validation */\r\n        if(!isInteger(formatedTime)) {\r\n            /* Enter valid time. */\r\n            showBarMessage(EZL_SE0111,ERROR_MSG);                    \r\n            return false;\r\n        }\r\n        \r\n        /* range validation */\r\n        intFormatedTime = parseInt(formatedTime, 10);\r\n        if ( (intFormatedTime < 0) || (intFormatedTime > 2359) ){\r\n            /* Enter valid time. */\r\n            showBarMessage(EZL_SE0111,ERROR_MSG);                    \r\n            return false;\r\n        }\r\n        \r\n\t\tintT1 =\tparseInt(t1, 10);\t\r\n\t\tintT2 = parseInt(t2, 10);\r\n\r\n\t\tif ( ( (intT1 < 0) || (intT1 > 23) ) ||\r\n\t\t\t( (intT2 < 0) || (intT2 > 59) ) ) {\r\n            /* Enter valid time. */\r\n            showBarMessage(EZL_SE0111,ERROR_MSG);                    \r\n            return false;\r\n\t\t}\r\n\t\t\r\n        /* change time format */\r\n        formatedTime = t1 + \":\" + t2;\r\n        \r\n        document.getElementById(\"time\").value = formatedTime;\r\n\t\treturn true;\r\n    }\r\n\t\r\n    /*Called by Back Button*/\r\n    function onBack() {\r\n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[9] = 
    "';\r\n        document.forms[0].submit();\r\n        return false;\r\n    }\r\n\r\n</SCRIPT>\r\n</HEAD>\r\n<BODY onload='javascript:onLoad()'>\r\n".toCharArray();
    __oracle_jsp_text[10] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n       <div class=\"text_header\"><h2>Container Replacement</h2></div>\r\n    <br>\r\n    <TABLE CLASS=\"table_search\" BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"0\" CELLPADDING=\"0\">\r\n     <TR>\r\n         <TD >Date</TD>\r\n         <TD>\r\n            ".toCharArray();
    __oracle_jsp_text[12] = 
    "\r\n            <a href=\"#\" onClick=\"showCalendar('forms[0].date', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[13] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n         </TD>\r\n          <TD>Time</TD>\r\n          <TD>".toCharArray();
    __oracle_jsp_text[14] = 
    "</TD>\r\n     </TR>        \r\n        \r\n     <TR>\r\n         <TD>Terminal</TD>\r\n         <TD>\r\n            ".toCharArray();
    __oracle_jsp_text[15] = 
    "            \r\n         </TD>\r\n          <TD colspan='2'>&nbsp;</TD>\r\n     </TR>\r\n        \r\n    <TR>\r\n         <TD>Booking Number</TD>\r\n         <TD >\r\n            ".toCharArray();
    __oracle_jsp_text[16] = 
    "            \r\n         </TD>\r\n          <TD colspan='2'>&nbsp;</TD>\r\n    </TR>\r\n        \r\n    <TR>\r\n         <TD>Old Container No.</TD>\r\n         <TD >\r\n            ".toCharArray();
    __oracle_jsp_text[17] = 
    "            \r\n         </TD>\r\n         \r\n         <TD>Old Shippers Seal</TD>\r\n         <TD >\r\n            ".toCharArray();
    __oracle_jsp_text[18] = 
    "            \r\n         </TD>\r\n    </TR>\r\n        \r\n    <TR>\r\n         <TD>New Container No.</TD>\r\n         <TD>\r\n            ".toCharArray();
    __oracle_jsp_text[19] = 
    "\r\n         </TD>\r\n         <TD>New Shippers Seal </TD>\r\n         <TD>\r\n            ".toCharArray();
    __oracle_jsp_text[20] = 
    "\r\n\r\n            ".toCharArray();
    __oracle_jsp_text[21] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[22] = 
    "                \r\n            ".toCharArray();
    __oracle_jsp_text[23] = 
    "\r\n\r\n            ".toCharArray();
    __oracle_jsp_text[24] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[25] = 
    "\r\n                    ".toCharArray();
    __oracle_jsp_text[26] = 
    "                \r\n                ".toCharArray();
    __oracle_jsp_text[27] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[28] = 
    "\r\n                    ".toCharArray();
    __oracle_jsp_text[29] = 
    "                \r\n                ".toCharArray();
    __oracle_jsp_text[30] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[31] = 
    "\r\n            \r\n         </TD>\r\n     </TR>\r\n         \r\n    <TR>\r\n         <TD>Reason</TD>\r\n         <TD>\r\n            ".toCharArray();
    __oracle_jsp_text[32] = 
    "\r\n         </TD>\r\n          <TD colspan='2'>&nbsp;</TD>\r\n    </TR>\r\n    \r\n    </TABLE>\r\n    \r\n    \r\n    <br><br><br><br>\r\n    \r\n    <div class=\"buttons_box\">\r\n        <input type=\"button\" value=\"Save\" name=\"btnSave\" class=\"event_btnbutton\" onclick='onSave()'/>       \r\n    </div>    \r\n    \r\n    \r\n            ".toCharArray();
    __oracle_jsp_text[33] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[34] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[35] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[36] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[37] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[38] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[39] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[40] = 
    "       \r\n            ".toCharArray();
    __oracle_jsp_text[41] = 
    "      \r\n            ".toCharArray();
    __oracle_jsp_text[42] = 
    "       \r\n            ".toCharArray();
    __oracle_jsp_text[43] = 
    "      \r\n            ".toCharArray();
    __oracle_jsp_text[44] = 
    "      \r\n            ".toCharArray();
    __oracle_jsp_text[45] = 
    "      \r\n            ".toCharArray();
    __oracle_jsp_text[46] = 
    "      \r\n            \r\n    ".toCharArray();
    __oracle_jsp_text[47] = 
    "    \r\n</html>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
