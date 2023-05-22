package _pages._edl;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;
import com.niit.control.web.action.BaseAction;
import com.niit.control.web.*;
import com.niit.control.common.*;


public class _EdlExcelDownloadScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EdlExcelDownloadScn page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      out.write(__oracle_jsp_text[3]);
      out.write(__oracle_jsp_text[4]);
      out.write(__oracle_jsp_text[5]);
      out.write(__oracle_jsp_text[6]);
      out.write(__oracle_jsp_text[7]);
              
          String lstrCtxPath = request.getContextPath();
          UserAccountBean account=(UserAccountBean)session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
          String lstrUserId = account.getUserId();
      
      out.write(__oracle_jsp_text[8]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[9]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl011download", pageContext));
      out.write(__oracle_jsp_text[10]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/sedl011");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[11]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setName("fedl011");
              __jsp_taghandler_2.setProperty("screenName");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[12]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_3=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setName("fedl011");
              __jsp_taghandler_3.setProperty("dischargelistId");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[13]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_4=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fedl011");
              __jsp_taghandler_4.setProperty("loadlistId");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[14]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_5=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setName("fedl011");
              __jsp_taghandler_5.setProperty("screenParameter");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[15]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_6=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setName("fedl011");
              __jsp_taghandler_6.setProperty("currentTab");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[16]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_7=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_7.setParent(__jsp_taghandler_1);
              __jsp_taghandler_7.setName("fedl011");
              __jsp_taghandler_7.setProperty("valRadioGroupSel1");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[17]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_8=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_8.setParent(__jsp_taghandler_1);
              __jsp_taghandler_8.setName("fedl011");
              __jsp_taghandler_8.setProperty("valRadioGroupSel2");
              __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
              if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,2);
            }
            out.write(__oracle_jsp_text[18]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_9=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_9.setParent(__jsp_taghandler_1);
              __jsp_taghandler_9.setName("fedl011");
              __jsp_taghandler_9.setProperty("downloadFormat");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[19]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_10=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_10.setParent(__jsp_taghandler_1);
              __jsp_taghandler_10.setName("fedl011");
              __jsp_taghandler_10.setProperty("find1Booked");
              __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
              if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,2);
            }
            out.write(__oracle_jsp_text[20]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_11=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_11.setParent(__jsp_taghandler_1);
              __jsp_taghandler_11.setName("fedl011");
              __jsp_taghandler_11.setProperty("in1Booked");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[21]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_12=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_12.setParent(__jsp_taghandler_1);
              __jsp_taghandler_12.setName("fedl011");
              __jsp_taghandler_12.setProperty("find2Booked");
              __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
              if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,2);
            }
            out.write(__oracle_jsp_text[22]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_13=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_13.setParent(__jsp_taghandler_1);
              __jsp_taghandler_13.setName("fedl011");
              __jsp_taghandler_13.setProperty("in2Booked");
              __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
              if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,2);
            }
            out.write(__oracle_jsp_text[23]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_14=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_14.setParent(__jsp_taghandler_1);
              __jsp_taghandler_14.setName("fedl011");
              __jsp_taghandler_14.setProperty("order1Booked");
              __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
              if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,2);
            }
            out.write(__oracle_jsp_text[24]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_15=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_15.setParent(__jsp_taghandler_1);
              __jsp_taghandler_15.setName("fedl011");
              __jsp_taghandler_15.setProperty("order1orderBooked");
              __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
              if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,2);
            }
            out.write(__oracle_jsp_text[25]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_16=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_16.setParent(__jsp_taghandler_1);
              __jsp_taghandler_16.setName("fedl011");
              __jsp_taghandler_16.setProperty("order2Booked");
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[26]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_17=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_17.setParent(__jsp_taghandler_1);
              __jsp_taghandler_17.setName("fedl011");
              __jsp_taghandler_17.setProperty("order2orderBooked");
              __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
              if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,2);
            }
            out.write(__oracle_jsp_text[27]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_18=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_18.setParent(__jsp_taghandler_1);
              __jsp_taghandler_18.setName("fedl011");
              __jsp_taghandler_18.setProperty("find1OverLanded");
              __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
              if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,2);
            }
            out.write(__oracle_jsp_text[28]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_19=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_19.setParent(__jsp_taghandler_1);
              __jsp_taghandler_19.setName("fedl011");
              __jsp_taghandler_19.setProperty("in1OverLanded");
              __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
              if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,2);
            }
            out.write(__oracle_jsp_text[29]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_20=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_20.setParent(__jsp_taghandler_1);
              __jsp_taghandler_20.setName("fedl011");
              __jsp_taghandler_20.setProperty("find2OverLanded");
              __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
              if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,2);
            }
            out.write(__oracle_jsp_text[30]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_21=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_21.setParent(__jsp_taghandler_1);
              __jsp_taghandler_21.setName("fedl011");
              __jsp_taghandler_21.setProperty("in2OverLanded");
              __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
              if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,2);
            }
            out.write(__oracle_jsp_text[31]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_22=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_22.setParent(__jsp_taghandler_1);
              __jsp_taghandler_22.setName("fedl011");
              __jsp_taghandler_22.setProperty("order1OverLanded");
              __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
              if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,2);
            }
            out.write(__oracle_jsp_text[32]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_23=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_23.setParent(__jsp_taghandler_1);
              __jsp_taghandler_23.setName("fedl011");
              __jsp_taghandler_23.setProperty("order1orderOverLanded");
              __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
              if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,2);
            }
            out.write(__oracle_jsp_text[33]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_24=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_24.setParent(__jsp_taghandler_1);
              __jsp_taghandler_24.setName("fedl011");
              __jsp_taghandler_24.setProperty("order2OverLanded");
              __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
              if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,2);
            }
            out.write(__oracle_jsp_text[34]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_25=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_25.setParent(__jsp_taghandler_1);
              __jsp_taghandler_25.setName("fedl011");
              __jsp_taghandler_25.setProperty("order2orderOverLanded");
              __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
              if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,2);
            }
            out.write(__oracle_jsp_text[35]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_26=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_26.setParent(__jsp_taghandler_1);
              __jsp_taghandler_26.setName("fedl011");
              __jsp_taghandler_26.setProperty("find1Restowed");
              __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
              if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,2);
            }
            out.write(__oracle_jsp_text[36]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_27=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_27.setParent(__jsp_taghandler_1);
              __jsp_taghandler_27.setName("fedl011");
              __jsp_taghandler_27.setProperty("in1Restowed");
              __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
              if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,2);
            }
            out.write(__oracle_jsp_text[37]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_28=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_28.setParent(__jsp_taghandler_1);
              __jsp_taghandler_28.setName("fedl011");
              __jsp_taghandler_28.setProperty("find2Restowed");
              __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
              if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,2);
            }
            out.write(__oracle_jsp_text[38]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_29=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_29.setParent(__jsp_taghandler_1);
              __jsp_taghandler_29.setName("fedl011");
              __jsp_taghandler_29.setProperty("in2Restowed");
              __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
              if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,2);
            }
            out.write(__oracle_jsp_text[39]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_30=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_30.setParent(__jsp_taghandler_1);
              __jsp_taghandler_30.setName("fedl011");
              __jsp_taghandler_30.setProperty("order1Restowed");
              __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
              if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,2);
            }
            out.write(__oracle_jsp_text[40]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_31=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_31.setParent(__jsp_taghandler_1);
              __jsp_taghandler_31.setName("fedl011");
              __jsp_taghandler_31.setProperty("order1orderRestowed");
              __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
              if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,2);
            }
            out.write(__oracle_jsp_text[41]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_32=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_32.setParent(__jsp_taghandler_1);
              __jsp_taghandler_32.setName("fedl011");
              __jsp_taghandler_32.setProperty("order2Restowed");
              __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
              if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,2);
            }
            out.write(__oracle_jsp_text[42]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_33=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_33.setParent(__jsp_taghandler_1);
              __jsp_taghandler_33.setName("fedl011");
              __jsp_taghandler_33.setProperty("order2orderRestowed");
              __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
              if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,2);
            }
            out.write(__oracle_jsp_text[43]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_34=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_34.setParent(__jsp_taghandler_1);
              __jsp_taghandler_34.setName("fedl011");
              __jsp_taghandler_34.setProperty("dataFlag");
              __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
              if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,2);
            }
            out.write(__oracle_jsp_text[44]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_35=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_35.setParent(__jsp_taghandler_1);
              __jsp_taghandler_35.setName("fedl011");
              __jsp_taghandler_35.setProperty("find1OverShipped");
              __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
              if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,2);
            }
            out.write(__oracle_jsp_text[45]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_36=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_36.setParent(__jsp_taghandler_1);
              __jsp_taghandler_36.setName("fedl011");
              __jsp_taghandler_36.setProperty("in1OverShipped");
              __jsp_tag_starteval=__jsp_taghandler_36.doStartTag();
              if (__jsp_taghandler_36.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_36,2);
            }
            out.write(__oracle_jsp_text[46]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_37=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_37.setParent(__jsp_taghandler_1);
              __jsp_taghandler_37.setName("fedl011");
              __jsp_taghandler_37.setProperty("find2OverShipped");
              __jsp_tag_starteval=__jsp_taghandler_37.doStartTag();
              if (__jsp_taghandler_37.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_37,2);
            }
            out.write(__oracle_jsp_text[47]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_38=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_38.setParent(__jsp_taghandler_1);
              __jsp_taghandler_38.setName("fedl011");
              __jsp_taghandler_38.setProperty("in2OverShipped");
              __jsp_tag_starteval=__jsp_taghandler_38.doStartTag();
              if (__jsp_taghandler_38.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_38,2);
            }
            out.write(__oracle_jsp_text[48]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_39=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_39.setParent(__jsp_taghandler_1);
              __jsp_taghandler_39.setName("fedl011");
              __jsp_taghandler_39.setProperty("order1OverShipped");
              __jsp_tag_starteval=__jsp_taghandler_39.doStartTag();
              if (__jsp_taghandler_39.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_39,2);
            }
            out.write(__oracle_jsp_text[49]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_40=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_40.setParent(__jsp_taghandler_1);
              __jsp_taghandler_40.setName("fedl011");
              __jsp_taghandler_40.setProperty("order1orderOverShipped");
              __jsp_tag_starteval=__jsp_taghandler_40.doStartTag();
              if (__jsp_taghandler_40.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_40,2);
            }
            out.write(__oracle_jsp_text[50]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_41=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_41.setParent(__jsp_taghandler_1);
              __jsp_taghandler_41.setName("fedl011");
              __jsp_taghandler_41.setProperty("order2OverShipped");
              __jsp_tag_starteval=__jsp_taghandler_41.doStartTag();
              if (__jsp_taghandler_41.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_41,2);
            }
            out.write(__oracle_jsp_text[51]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_42=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_42.setParent(__jsp_taghandler_1);
              __jsp_taghandler_42.setName("fedl011");
              __jsp_taghandler_42.setProperty("order2orderOverShipped");
              __jsp_tag_starteval=__jsp_taghandler_42.doStartTag();
              if (__jsp_taghandler_42.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_42,2);
            }
            out.write(__oracle_jsp_text[52]);
            out.write(__oracle_jsp_text[53]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_43=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_43.setParent(__jsp_taghandler_1);
              __jsp_taghandler_43.setName("fedl011");
              __jsp_taghandler_43.setOnclick("onSelect1()");
              __jsp_taghandler_43.setProperty("radioGroupSel1");
              __jsp_taghandler_43.setStyleClass("check");
              __jsp_taghandler_43.setValue("fromThisTab");
              __jsp_tag_starteval=__jsp_taghandler_43.doStartTag();
              if (__jsp_taghandler_43.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_43,2);
            }
            out.write(__oracle_jsp_text[54]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_44=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_44.setParent(__jsp_taghandler_1);
              __jsp_taghandler_44.setName("fedl011");
              __jsp_taghandler_44.setOnclick("onSelect1()");
              __jsp_taghandler_44.setProperty("radioGroupSel1");
              __jsp_taghandler_44.setStyleClass("check");
              __jsp_taghandler_44.setValue("fromAllTabs");
              __jsp_tag_starteval=__jsp_taghandler_44.doStartTag();
              if (__jsp_taghandler_44.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_44,2);
            }
            out.write(__oracle_jsp_text[55]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_45=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_45.setParent(__jsp_taghandler_1);
              __jsp_taghandler_45.setName("fedl011");
              __jsp_taghandler_45.setOnclick("onSelect2()");
              __jsp_taghandler_45.setProperty("radioGroupSel2");
              __jsp_taghandler_45.setStyleClass("check");
              __jsp_taghandler_45.setValue("allBoxes");
              __jsp_tag_starteval=__jsp_taghandler_45.doStartTag();
              if (__jsp_taghandler_45.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_45,2);
            }
            out.write(__oracle_jsp_text[56]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_46=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_46.setParent(__jsp_taghandler_1);
              __jsp_taghandler_46.setName("fedl011");
              __jsp_taghandler_46.setOnclick("onSelect2()");
              __jsp_taghandler_46.setProperty("radioGroupSel2");
              __jsp_taghandler_46.setStyleClass("check");
              __jsp_taghandler_46.setValue("onlyContainers");
              __jsp_tag_starteval=__jsp_taghandler_46.doStartTag();
              if (__jsp_taghandler_46.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_46,2);
            }
            out.write(__oracle_jsp_text[57]);
            {
              org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_47=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
              __jsp_taghandler_47.setParent(__jsp_taghandler_1);
              __jsp_taghandler_47.setName("fedl011");
              __jsp_taghandler_47.setProperty("currentTab");
              __jsp_taghandler_47.setValue("Booked");
              __jsp_tag_starteval=__jsp_taghandler_47.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[58]);
                  {
                    org.apache.struts.taglib.html.CheckboxTag __jsp_taghandler_48=(org.apache.struts.taglib.html.CheckboxTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.CheckboxTag.class,"org.apache.struts.taglib.html.CheckboxTag name property styleClass");
                    __jsp_taghandler_48.setParent(__jsp_taghandler_47);
                    __jsp_taghandler_48.setName("fedl011");
                    __jsp_taghandler_48.setProperty("downloadFormatCheck");
                    __jsp_taghandler_48.setStyleClass("check");
                    __jsp_tag_starteval=__jsp_taghandler_48.doStartTag();
                    if (__jsp_taghandler_48.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_48,3);
                  }
                  out.write(__oracle_jsp_text[59]);
                } while (__jsp_taghandler_47.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_47.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_47,2);
            }
            out.write(__oracle_jsp_text[60]);
            {
              org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_49=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
              __jsp_taghandler_49.setParent(__jsp_taghandler_1);
              __jsp_taghandler_49.setName("fedl011");
              __jsp_taghandler_49.setProperty("currentTab");
              __jsp_taghandler_49.setValue("Booked");
              __jsp_tag_starteval=__jsp_taghandler_49.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[61]);
                  {
                    org.apache.struts.taglib.html.CheckboxTag __jsp_taghandler_50=(org.apache.struts.taglib.html.CheckboxTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.CheckboxTag.class,"org.apache.struts.taglib.html.CheckboxTag disabled name property styleClass");
                    __jsp_taghandler_50.setParent(__jsp_taghandler_49);
                    __jsp_taghandler_50.setDisabled(true);
                    __jsp_taghandler_50.setName("fedl011");
                    __jsp_taghandler_50.setProperty("downloadFormatCheck");
                    __jsp_taghandler_50.setStyleClass("check");
                    __jsp_tag_starteval=__jsp_taghandler_50.doStartTag();
                    if (__jsp_taghandler_50.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_50,3);
                  }
                  out.write(__oracle_jsp_text[62]);
                } while (__jsp_taghandler_49.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_49.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_49,2);
            }
            out.write(__oracle_jsp_text[63]);
            out.write(__oracle_jsp_text[64]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[65]);

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
  private static final char __oracle_jsp_text[][]=new char[66][];
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
    "\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\r\n<HEAD>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n<TITLE> </TITLE>\r\n\r\n    <LINK REL=\"stylesheet\" HREF=\"".toCharArray();
    __oracle_jsp_text[9] = 
    "/css/EZL.css\"/>\r\n    <STYLE TYPE=\"text/css\">\r\n         div.search_result{height:100px;}\r\n         table.table_results tbody{height:100px;}\r\n    </STYLE>\r\n\r\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\r\n    var FORM_ID       = 'fedl011';\r\n    var currselrowid  = 'row0';\r\n \r\n    /*Called by framework on-load of this JSP*/\r\n    function onLoad() {     \r\n        var strCurrentTabVal = document.forms[0].currentTab.value;\r\n       \r\n       \r\n        if(strCurrentTabVal == \"Booked\"){\r\n            document.forms[0].downloadFormatCheck.value = \"on\";\r\n            document.forms[0].downloadFormatCheck.checked = true;\r\n        }\r\n        \r\n        \r\n        document.forms[0].radioGroupSel1[0].checked = true;\r\n        document.forms[0].valRadioGroupSel1.value = document.forms[0].radioGroupSel1[0].value;\r\n        document.forms[0].radioGroupSel2[0].checked = true;\r\n        document.forms[0].valRadioGroupSel2.value = document.forms[0].radioGroupSel2[0].value;\r\n    \r\n    }\r\n    /*Called by framework for help*/\r\n    function openHelp(){\r\n        var strFileName = '1';\r\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\r\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\r\n        objWindow.focus();\r\n    }\r\n    \r\n    /*Called on radio button selection*/\r\n    function onSelect1(){\r\n            if(document.forms[0].radioGroupSel1[0].checked){\r\n                document.forms[0].valRadioGroupSel1.value = document.forms[0].radioGroupSel1[0].value;\r\n                if(document.forms[0].currentTab.value == \"Booked\"){\r\n                    document.forms[0].downloadFormatCheck.disabled = false;\r\n                }else{\r\n                    document.forms[0].downloadFormatCheck.disabled = true;}\r\n                return false;\r\n            } else if(document.forms[0].radioGroupSel1[1].checked){\r\n                    document.forms[0].valRadioGroupSel1.value = document.forms[0].radioGroupSel1[1].value;\r\n                \r\n                    document.forms[0].downloadFormatCheck.checked = false;\r\n                    document.forms[0].downloadFormatCheck.disabled = true;\r\n                \r\n                return false;             \r\n            } \r\n        return false;\r\n    }\r\n    \r\n    /*Called on radio button selection*/\r\n    function onSelect2(){\r\n           if(document.forms[0].radioGroupSel2[0].checked){\r\n                document.forms[0].valRadioGroupSel2.value = document.forms[0].radioGroupSel2[0].value;\r\n                return false;             \r\n            } else if(document.forms[0].radioGroupSel2[1].checked){\r\n                document.forms[0].valRadioGroupSel2.value = document.forms[0].radioGroupSel2[1].value;\r\n                return false;             \r\n            }\r\n        return false;\r\n    }\r\n    \r\n    /*Called by Download Button*/\r\n    function onDownload(){ \r\n        if(document.forms[0].downloadFormatCheck.value == \"on\" && document.forms[0].downloadFormatCheck.checked == true) {\r\n            document.forms[0].downloadFormat.value = \"Y\" ;  \r\n        } else {\r\n            document.forms[0].downloadFormat.value = \"N\" ;   \r\n        }\r\n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[10] = 
    "';\r\n        document.forms[0].submit(); \r\n        return false; \r\n    }\r\n\r\n</SCRIPT>\r\n</HEAD>\r\n\r\n<BODY onload='javascript:onLoad()'>\r\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[12] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[13] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[14] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[15] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[16] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[17] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[18] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[19] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[20] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[21] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[22] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[23] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[24] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[25] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[26] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[27] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[28] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[29] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[30] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[31] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[32] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[33] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[34] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[35] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[36] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[37] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[38] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[39] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[40] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[41] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[42] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[43] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[44] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[45] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[46] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[47] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[48] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[49] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[50] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[51] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[52] = 
    "\r\n\r\n  \r\n    ".toCharArray();
    __oracle_jsp_text[53] = 
    "\r\n    <div class=\"text_header\"><h2>Excel Download</h2></div>\r\n    <br>\r\n       <TABLE  align=\"left\" CLASS=\"table_search\" BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"0\" CELLPADDING=\"0\">\r\n        <TR>\r\n        <TD width='20%' >Select 1</TD>\r\n        <TD width='22%' >From This Tab </TD>\r\n        <TD>".toCharArray();
    __oracle_jsp_text[54] = 
    "</TD>\r\n        <TD width='37%' >From All Tabs </TD>\r\n        <TD>".toCharArray();
    __oracle_jsp_text[55] = 
    "</TD>\r\n        </TR>\r\n        <TR>\r\n        <TD>Select 2</TD>\r\n        <TD>All Boxes </TD>\r\n        <TD>".toCharArray();
    __oracle_jsp_text[56] = 
    "</TD>\r\n        <TD>Only containers matching filter <br>(from the visible tab on the screen)</TD>\r\n        <TD> ".toCharArray();
    __oracle_jsp_text[57] = 
    "</TD>\r\n        </TR>\r\n        ".toCharArray();
    __oracle_jsp_text[58] = 
    "\r\n            <TR>\r\n                <TD>Upload Format </TD>\r\n                <TD>".toCharArray();
    __oracle_jsp_text[59] = 
    "</TD>\r\n            </TR>        \r\n        ".toCharArray();
    __oracle_jsp_text[60] = 
    "\r\n        ".toCharArray();
    __oracle_jsp_text[61] = 
    "\r\n            <TR>\r\n                <TD>Upload Format </TD>\r\n                <TD>".toCharArray();
    __oracle_jsp_text[62] = 
    "</TD>\r\n            </TR>        \r\n        ".toCharArray();
    __oracle_jsp_text[63] = 
    "\r\n\r\n        \r\n    </TABLE>\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[64] = 
    "\r\n    <br><br><br><br>\r\n    \r\n    <br><br>\r\n    <div class=\"buttons_box\">   \r\n    <input type=\"button\" value=\"Download\" align = \"center\" name=\"btnDownload\" class=\"event_btnbutton\" onclick='onDownload()'/>\r\n    </div>\r\n    \r\n".toCharArray();
    __oracle_jsp_text[65] = 
    "\r\n</BODY>\r\n</HTML>\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
