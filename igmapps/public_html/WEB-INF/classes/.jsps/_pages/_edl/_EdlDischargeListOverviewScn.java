package _pages._edl;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.GlobalConstants;
import com.niit.control.web.action.BaseAction;
import com.niit.control.web.UserAccountBean;
import com.niit.control.common.StringUtil;


public class _EdlDischargeListOverviewScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EdlDischargeListOverviewScn page = this;
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
      
          boolean[] arrAuthFlags = BaseAction.getAuthFlags(request, "SEDL001");
          boolean blnReadFlag     = arrAuthFlags[GlobalConstants.IDX_READ_FLAG];
          boolean blnNewFlag      = arrAuthFlags[GlobalConstants.IDX_NEW_FLAG];
          boolean blnEditFlag     = arrAuthFlags[GlobalConstants.IDX_EDIT_FLAG];
          boolean blnDelFlag      = arrAuthFlags[GlobalConstants.IDX_DEL_FLAG];
          String lstrCtxPath = request.getContextPath();
      
      out.write(__oracle_jsp_text[8]);
      
          String  strUserFsc  = null;
          UserAccountBean account = (UserAccountBean) session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
          strUserFsc = account.getUserFsc();
      
      
      
      out.write(__oracle_jsp_text[9]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[10]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl001search", pageContext));
      out.write(__oracle_jsp_text[11]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl001", pageContext));
      out.write(__oracle_jsp_text[12]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl001search", pageContext));
      out.write(__oracle_jsp_text[13]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm004", pageContext));
      out.write(__oracle_jsp_text[14]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl001search", pageContext));
      out.write(__oracle_jsp_text[15]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm011", pageContext));
      out.write(__oracle_jsp_text[16]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sedl002", pageContext));
      out.write(__oracle_jsp_text[17]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/sedl001");
        __jsp_taghandler_1.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[18]);
            out.write(__oracle_jsp_text[19]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_2.setParent(__jsp_taghandler_1);
              __jsp_taghandler_2.setName("fedl001");
              __jsp_taghandler_2.setProperty("searchPerformed");
              __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
              if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,2);
            }
            out.write(__oracle_jsp_text[20]);
            out.write(__oracle_jsp_text[21]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_3=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_3.setParent(__jsp_taghandler_1);
              __jsp_taghandler_3.setName("fedl001");
              __jsp_taghandler_3.setProperty("selDischargeListId");
              __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
              if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,2);
            }
            out.write(__oracle_jsp_text[22]);
            out.write(__oracle_jsp_text[23]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_4=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_4.setParent(__jsp_taghandler_1);
              __jsp_taghandler_4.setName("fedl001");
              __jsp_taghandler_4.setProperty("selServiceCode");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[24]);
            out.write(__oracle_jsp_text[25]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_5=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_5.setParent(__jsp_taghandler_1);
              __jsp_taghandler_5.setName("fedl001");
              __jsp_taghandler_5.setProperty("selVesselCode");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[26]);
            out.write(__oracle_jsp_text[27]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_6=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_6.setParent(__jsp_taghandler_1);
              __jsp_taghandler_6.setName("fedl001");
              __jsp_taghandler_6.setProperty("selDirection");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[28]);
            out.write(__oracle_jsp_text[29]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_7=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_7.setParent(__jsp_taghandler_1);
              __jsp_taghandler_7.setName("fedl001");
              __jsp_taghandler_7.setProperty("selVoyageCode");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[30]);
            out.write(__oracle_jsp_text[31]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_8=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_8.setParent(__jsp_taghandler_1);
              __jsp_taghandler_8.setName("fedl001");
              __jsp_taghandler_8.setProperty("selPortSequenceNo");
              __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
              if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,2);
            }
            out.write(__oracle_jsp_text[32]);
            out.write(__oracle_jsp_text[33]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_9=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_9.setParent(__jsp_taghandler_1);
              __jsp_taghandler_9.setName("fedl001");
              __jsp_taghandler_9.setProperty("selPortId");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[34]);
            out.write(__oracle_jsp_text[35]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_10=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_10.setParent(__jsp_taghandler_1);
              __jsp_taghandler_10.setName("fedl001");
              __jsp_taghandler_10.setProperty("selTerminalCode");
              __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
              if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,2);
            }
            out.write(__oracle_jsp_text[36]);
            out.write(__oracle_jsp_text[37]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_11=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_11.setParent(__jsp_taghandler_1);
              __jsp_taghandler_11.setName("fedl001");
              __jsp_taghandler_11.setProperty("selBargeNo");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[38]);
            out.write(__oracle_jsp_text[39]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_12=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_12.setParent(__jsp_taghandler_1);
              __jsp_taghandler_12.setName("fedl001");
              __jsp_taghandler_12.setProperty("selETA");
              __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
              if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,2);
            }
            out.write(__oracle_jsp_text[40]);
            out.write(__oracle_jsp_text[41]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_13=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_13.setParent(__jsp_taghandler_1);
              __jsp_taghandler_13.setName("fedl001");
              __jsp_taghandler_13.setProperty("selETD");
              __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
              if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,2);
            }
            out.write(__oracle_jsp_text[42]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_14=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_14.setParent(__jsp_taghandler_1);
              __jsp_taghandler_14.setName("fedl001");
              __jsp_taghandler_14.setProperty("selATA");
              __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
              if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,2);
            }
            out.write(__oracle_jsp_text[43]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_15=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_15.setParent(__jsp_taghandler_1);
              __jsp_taghandler_15.setName("fedl001");
              __jsp_taghandler_15.setProperty("selATD");
              __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
              if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,2);
            }
            out.write(__oracle_jsp_text[44]);
            out.write(__oracle_jsp_text[45]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_16=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_16.setParent(__jsp_taghandler_1);
              __jsp_taghandler_16.setName("fedl001");
              __jsp_taghandler_16.setProperty("dischargeListCount");
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[46]);
            out.write(__oracle_jsp_text[47]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_17=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_17.setParent(__jsp_taghandler_1);
              __jsp_taghandler_17.setMaxlength("3");
              __jsp_taghandler_17.setName("fedl001");
              __jsp_taghandler_17.setOnblur("changeUpper(this)");
              __jsp_taghandler_17.setProperty("serviceGroup");
              __jsp_taghandler_17.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
              if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,2);
            }
            out.write(__oracle_jsp_text[48]);
            out.write(__oracle_jsp_text[49]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_18=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_18.setParent(__jsp_taghandler_1);
              __jsp_taghandler_18.setMaxlength("5");
              __jsp_taghandler_18.setName("fedl001");
              __jsp_taghandler_18.setOnblur("changeUpper(this);");
              __jsp_taghandler_18.setProperty("serviceCd");
              __jsp_taghandler_18.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
              if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,2);
            }
            out.write(__oracle_jsp_text[50]);
            out.write(__oracle_jsp_text[51]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_19=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style styleClass");
              __jsp_taghandler_19.setParent(__jsp_taghandler_1);
              __jsp_taghandler_19.setMaxlength("5");
              __jsp_taghandler_19.setName("fedl001");
              __jsp_taghandler_19.setOnblur("changeUpper(this);");
              __jsp_taghandler_19.setProperty("port");
              __jsp_taghandler_19.setStyle("width:75%");
              __jsp_taghandler_19.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
              if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,2);
            }
            out.write(__oracle_jsp_text[52]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_20=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly styleClass value");
              __jsp_taghandler_20.setParent(__jsp_taghandler_1);
              __jsp_taghandler_20.setMaxlength("3");
              __jsp_taghandler_20.setName("fedl001");
              __jsp_taghandler_20.setOnblur("changeUpper(this)");
              __jsp_taghandler_20.setProperty("fsc");
              __jsp_taghandler_20.setReadonly(true);
              __jsp_taghandler_20.setStyleClass("non_edit");
              __jsp_taghandler_20.setValue(OracleJspRuntime.toStr( strUserFsc));
              __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
              if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,2);
            }
            out.write(__oracle_jsp_text[53]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_21=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_21.setParent(__jsp_taghandler_1);
              __jsp_taghandler_21.setMaxlength("5");
              __jsp_taghandler_21.setName("fedl001");
              __jsp_taghandler_21.setOnblur("changeUpper(this)");
              __jsp_taghandler_21.setProperty("vessel");
              __jsp_taghandler_21.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
              if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,2);
            }
            out.write(__oracle_jsp_text[54]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_22=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_22.setParent(__jsp_taghandler_1);
              __jsp_taghandler_22.setMaxlength("10");
              __jsp_taghandler_22.setName("fedl001");
              __jsp_taghandler_22.setOnblur("changeUpper(this)");
              __jsp_taghandler_22.setProperty("inVoyage");
              __jsp_taghandler_22.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
              if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,2);
            }
            out.write(__oracle_jsp_text[55]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_23=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style styleClass");
              __jsp_taghandler_23.setParent(__jsp_taghandler_1);
              __jsp_taghandler_23.setMaxlength("5");
              __jsp_taghandler_23.setName("fedl001");
              __jsp_taghandler_23.setOnblur("changeUpper(this);");
              __jsp_taghandler_23.setProperty("terminal");
              __jsp_taghandler_23.setStyle("width:75%");
              __jsp_taghandler_23.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
              if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,2);
            }
            out.write(__oracle_jsp_text[56]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_24=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property style");
              __jsp_taghandler_24.setParent(__jsp_taghandler_1);
              __jsp_taghandler_24.setMaxlength("10");
              __jsp_taghandler_24.setName("fedl001");
              __jsp_taghandler_24.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_24.setOnclick("this.select();");
              __jsp_taghandler_24.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_24.setProperty("fromEta");
              __jsp_taghandler_24.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
              if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,2);
            }
            out.write(__oracle_jsp_text[57]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[58]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_25=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property style");
              __jsp_taghandler_25.setParent(__jsp_taghandler_1);
              __jsp_taghandler_25.setMaxlength("10");
              __jsp_taghandler_25.setName("fedl001");
              __jsp_taghandler_25.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_25.setOnclick("this.select();");
              __jsp_taghandler_25.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_25.setProperty("toEta");
              __jsp_taghandler_25.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
              if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,2);
            }
            out.write(__oracle_jsp_text[59]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[60]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_26=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property style");
              __jsp_taghandler_26.setParent(__jsp_taghandler_1);
              __jsp_taghandler_26.setMaxlength("10");
              __jsp_taghandler_26.setName("fedl001");
              __jsp_taghandler_26.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_26.setOnclick("this.select();");
              __jsp_taghandler_26.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_26.setProperty("fromAta");
              __jsp_taghandler_26.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
              if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,2);
            }
            out.write(__oracle_jsp_text[61]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[62]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_27=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property style");
              __jsp_taghandler_27.setParent(__jsp_taghandler_1);
              __jsp_taghandler_27.setMaxlength("10");
              __jsp_taghandler_27.setName("fedl001");
              __jsp_taghandler_27.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_27.setOnclick("this.select();");
              __jsp_taghandler_27.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_27.setProperty("toAta");
              __jsp_taghandler_27.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
              if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,2);
            }
            out.write(__oracle_jsp_text[63]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[64]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_28=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property size");
              __jsp_taghandler_28.setParent(__jsp_taghandler_1);
              __jsp_taghandler_28.setName("fedl001");
              __jsp_taghandler_28.setProperty("sortBy");
              __jsp_taghandler_28.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_28,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[65]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_29=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_29.setParent(__jsp_taghandler_28);
                    __jsp_taghandler_29.setLabel("name");
                    __jsp_taghandler_29.setName("fedl001");
                    __jsp_taghandler_29.setProperty("sortByValues");
                    __jsp_taghandler_29.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
                    if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,3);
                  }
                  out.write(__oracle_jsp_text[66]);
                } while (__jsp_taghandler_28.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,2);
            }
            out.write(__oracle_jsp_text[67]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_30=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property size");
              __jsp_taghandler_30.setParent(__jsp_taghandler_1);
              __jsp_taghandler_30.setName("fedl001");
              __jsp_taghandler_30.setProperty("sortIn");
              __jsp_taghandler_30.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_30,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[68]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_31=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_31.setParent(__jsp_taghandler_30);
                    __jsp_taghandler_31.setLabel("name");
                    __jsp_taghandler_31.setName("fedl001");
                    __jsp_taghandler_31.setProperty("sortInValues");
                    __jsp_taghandler_31.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
                    if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,3);
                  }
                  out.write(__oracle_jsp_text[69]);
                } while (__jsp_taghandler_30.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,2);
            }
            out.write(__oracle_jsp_text[70]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_32=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style styleClass size");
              __jsp_taghandler_32.setParent(__jsp_taghandler_1);
              __jsp_taghandler_32.setName("fedl001");
              __jsp_taghandler_32.setProperty("dischargelistStatus");
              __jsp_taghandler_32.setStyle("height:20px");
              __jsp_taghandler_32.setStyleClass("must");
              __jsp_taghandler_32.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_32,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[71]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_33=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_33.setParent(__jsp_taghandler_32);
                    __jsp_taghandler_33.setLabel("name");
                    __jsp_taghandler_33.setName("fedl001");
                    __jsp_taghandler_33.setProperty("dischargeListStatusValues");
                    __jsp_taghandler_33.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
                    if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,3);
                  }
                  out.write(__oracle_jsp_text[72]);
                } while (__jsp_taghandler_32.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,2);
            }
            out.write(__oracle_jsp_text[73]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_34=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property size");
              __jsp_taghandler_34.setParent(__jsp_taghandler_1);
              __jsp_taghandler_34.setName("fedl001");
              __jsp_taghandler_34.setOnchange("changeViewCombo()");
              __jsp_taghandler_34.setProperty("view");
              __jsp_taghandler_34.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_34,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[74]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_35=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_35.setParent(__jsp_taghandler_34);
                    __jsp_taghandler_35.setLabel("name");
                    __jsp_taghandler_35.setName("fedl001");
                    __jsp_taghandler_35.setProperty("viewListValues");
                    __jsp_taghandler_35.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
                    if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,3);
                  }
                  out.write(__oracle_jsp_text[75]);
                } while (__jsp_taghandler_34.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,2);
            }
            out.write(__oracle_jsp_text[76]);
            out.write(__oracle_jsp_text[77]);
            out.write(__oracle_jsp_text[78]);
            out.write(__oracle_jsp_text[79]);
            out.write(__oracle_jsp_text[80]);
            {
              String __url=OracleJspRuntime.toStr("../edl/EdlDischargeListOverviewGrid.jsp");
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[81]);
            out.write(__oracle_jsp_text[82]);
            out.write(__oracle_jsp_text[83]);
            out.write(__oracle_jsp_text[84]);
            out.write(__oracle_jsp_text[85]);
            {
              String __url=OracleJspRuntime.toStr("../common/tiles/pagination.jsp");
              __url=OracleJspRuntime.genPageUrl(__url,request,response,new String[] {"formName" } ,new String[] {OracleJspRuntime.toStr("fedl001") } );
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[86]);
            out.write(__oracle_jsp_text[87]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[88]);

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
  private static final char __oracle_jsp_text[][]=new char[89][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
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
    "\r\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\r\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[10] = 
    "/js/riaGridCommon.js\"></script>\r\n<SCRIPT language=\"javascript\" type=\"text/javascript\">\r\n\r\n    var PROG_ID           = 'SEDL001';\r\n    var FORM_ID           = 'fedl001';\r\n\r\n    var lastServiceGroup   = '';\r\n    var lastServiceCd      = '';\r\n    var lastPort           = '';\r\n    var lastTerminal       = '';\r\n    var lastFsc            = '';\r\n    var lastVessel         = '';\r\n    var lastInVoyage       = '';\r\n    var lastFromEta        = '';\r\n    var lastToEta          = '';\r\n    var lastFromAta        = '';\r\n    var lastToAta          = '';\r\n    var lastStatus         = '';\r\n    var lastSortBy         = '';\r\n    var lastSortIn         = '';\r\n    var lastView           = '';\r\n    var searchPerformed    = \"\";\r\n    var defaultFromETA     = '';\r\n    var defaultToETA       = '';\r\n\r\n    /*Called by framework on-load of this JSP*/\r\n    function onLoad() {\r\n\r\n    searchPerformed   = document.getElementById(\"searchPerformed\").value;\r\n        lastServiceGroup  = document.forms[0].serviceGroup.value;\r\n        lastServiceCd     = document.forms[0].serviceCd.value;\r\n        lastPort          = document.forms[0].port.value;\r\n        lastTerminal      = document.forms[0].terminal.value;\r\n        lastFsc           = document.forms[0].fsc.value;\r\n        lastVessel        = document.forms[0].vessel.value;\r\n        lastInVoyage      = document.forms[0].inVoyage.value;\r\n        lastFromEta       = document.forms[0].fromEta.value;\r\n        lastToEta         = document.forms[0].toEta.value;\r\n        lastFromAta       = document.forms[0].fromAta.value;\r\n        lastToAta         = document.forms[0].toAta.value;\r\n        lastStatus        = document.forms[0].dischargelistStatus.value;\r\n        lastSortBy        = document.forms[0].sortBy.value;\r\n        lastSortIn        = document.forms[0].sortIn.value;\r\n        lastView          = document.forms[0].view.value;\r\n\r\n        if(searchPerformed == \"false\") {\r\n            defaultFromETA = document.forms[0].fromEta.value;\r\n            defaultToETA   = document.forms[0].toAta.value;\r\n        }\r\n\r\n        /*Check the value of contact counter for radio button selected*/\r\n        if(document.forms[0].radioGroup1 != null){\r\n            if(document.forms[0].radioGroup1[0] != null){\r\n                for( i = 0; i < document.forms[0].radioGroup1.length; i++ )\r\n                {\r\n                    if(document.forms[0].radioGroup1[i].value == document.forms[0].dischargeListCount.value) {\r\n                  document.forms[0].radioGroup1[i].checked = 'true';\r\n                    }\r\n                }\r\n            } else {\r\n                if(document.forms[0].radioGroup1.value == document.forms[0].dischargeListCount.value) {\r\n                    document.forms[0].radioGroup1.checked = 'true';\r\n                }\r\n            }\r\n        }\r\n\r\n        document.forms[0].serviceGroup.focus();\r\n    }\r\n\r\n    /*Called by framework for Pagination*/\r\n    function getActionUrl(){\r\n        resetSearchCriteria();\r\n        //Set the Discharge counter to 0\r\n        document.forms[0].dischargeListCount.value= \"0\";\r\n        lstrUrl = '".toCharArray();
    __oracle_jsp_text[11] = 
    "';\r\n        document.forms[0].action=lstrUrl;\r\n        return lstrUrl;\r\n    }\r\n\r\n    function openServiceGroupLookup(){\r\n            var rowId = FORM_ID;\r\n            openLookup(FORM_ID, rowId, MASTER_ID_SERVICE_GRP, '');\r\n    }\r\n\r\n    function openServiceLookup(){\r\n            var rowId = FORM_ID;\r\n            openLookup(FORM_ID, rowId, MASTER_ID_SERVICE, '');\r\n    }\r\n\r\n    function openPortLookup(){\r\n            var rowId = FORM_ID;\r\n            openLookup(FORM_ID, rowId, MASTER_ID_PORT, '');\r\n    }\r\n\r\n    function openTerminalLookup(){\r\n            var rowId = FORM_ID;\r\n            openLookup(FORM_ID, rowId, MASTER_ID_TERMINAL, '');\r\n    }\r\n\r\n\r\n\r\n    function openVesselLookup(){\r\n            var rowId = FORM_ID;\r\n            openLookup(FORM_ID, rowId, MASTER_ID_VESSEL, '');\r\n    }\r\n\r\n    function openInVoyageLookup(){\r\n            var rowId = FORM_ID;\r\n            openLookup(FORM_ID, rowId, MASTER_ID_IN_VOYAGE, '');\r\n    }\r\n\r\n    /*Called by master lookup screens to return selected values*/\r\n    function setLookupValues(aFormName, aRowId,strMasterId, arrResultData){\r\n\r\n        if(arrResultData[0] == FAILURE){\r\n            return;\r\n        }\r\n\r\n        if((strMasterId == MASTER_ID_SERVICE_GRP)\r\n            || (strMasterId == MASTER_ID_SERVICE)\r\n            || (strMasterId == MASTER_ID_VESSEL)\r\n            || (strMasterId == MASTER_ID_IN_VOYAGE)){\r\n                //Setting Service Group,Service Code, Port, Terminal, Vessel and InVoyage\r\n                document.forms[0].serviceGroup.value=arrResultData[IDX_SRV_GRP_CD];\r\n                document.forms[0].serviceCd.value=arrResultData[IDX_SRV_CD];\r\n                document.forms[0].port.value=arrResultData[IDX_PRT_CD];\r\n                document.forms[0].terminal.value=arrResultData[IDX_TRM_CD];\r\n                document.forms[0].vessel.value=arrResultData[IDX_VSL_CD];\r\n                document.forms[0].inVoyage.value=arrResultData[IDX_IN_VOY_CD];\r\n        }  else if(strMasterId == MASTER_ID_PORT){\r\n                //set Port\r\n                document.forms[0].port.value=arrResultData[IDX_VND_CD];\r\n        } else if(strMasterId == MASTER_ID_FSC){\r\n                //set fsc code\r\n                document.forms[0].fsc.value=arrResultData[IDX_FSC_CD];\r\n        } else if(strMasterId == MASTER_ID_TERMINAL){\r\n                //set Terminal\r\n                document.forms[0].terminal.value=arrResultData[IDX_VND_CD];\r\n        }\r\n    }\r\n\r\n    /*Called by framework on reset or refresh for reloading the page*/\r\n    function onResetForm(){\r\n        document.forms[0].currPageNo.value= 1;\r\n        document.forms[0].totRecord.value=0;\r\n\r\n        //Set the DischargeList counter to 0\r\n        document.forms[0].dischargeListCount.value= \"0\";\r\n        //Setting the default values for controls\r\n        getGridSearchCriteria();\r\n        /*\r\n        document.forms[0].serviceGroup.value = \"\";\r\n        document.forms[0].serviceCd.value   = \"\";\r\n        document.forms[0].port.value        = \"\";\r\n        document.forms[0].terminal.value    = \"\";\r\n        document.forms[0].vessel.value      = \"\";\r\n        document.forms[0].inVoyage.value    = \"\";\r\n        document.forms[0].fromEta.value     = defaultFromETA;\r\n        document.forms[0].toEta.value       = defaultToETA;\r\n        document.forms[0].fromAta.value     = \"\";\r\n        document.forms[0].toAta.value       = \"\";\r\n        document.forms[0].dischargelistStatus.value   = lastStatus;\r\n        document.forms[0].sortBy.value      = lastSortBy;\r\n        document.forms[0].sortIn.value      = lastSortIn;\r\n        document.forms[0].view.value        = lastView;\r\n\r\n        */\r\n        //document.forms[0].action='".toCharArray();
    __oracle_jsp_text[12] = 
    "';\r\n        //document.forms[0].submit();\r\n        return false;\r\n    }\r\n\r\n    /*Called by Find Button*/\r\n    function onSearch() {\r\n        //Clear the Data Table\r\n        clearDiv('fixedColumns_bodyDiv');\r\n        //Check if Port is entered or not\r\n\r\n         var  strFromEta = document.forms[0].fromEta.value;\r\n         var  strToEta   = document.forms[0].toEta.value;\r\n         var strStatus = document.forms[0].dischargelistStatus.value;\r\n         var strServiceCode= document.forms[0].serviceCd.value;\r\n         var strVessel = document.forms[0].vessel.value;\r\n         var strvoyage= document.forms[0].inVoyage.value;\r\n\r\n        if(!mandatoryCheckNoSpaces(document.forms[0].port)) {\r\n            showBarMessage(ELL_SE0001, ERROR_MSG);\r\n            document.forms[0].port.focus();\r\n            return false;\r\n        }\r\n\r\n        //Check if Terminal is entered or not\r\n        if(!mandatoryCheckNoSpaces(document.forms[0].terminal)) {\r\n            showBarMessage(ELL_SE0002, ERROR_MSG);\r\n            document.forms[0].terminal.focus();\r\n            return false;\r\n        }\r\n\r\n       if((!mandatoryCheckNoSpaces(document.forms[0].fromEta))\r\n            && (!mandatoryCheckNoSpaces(document.forms[0].toEta))\r\n            && (!mandatoryCheckNoSpaces(document.forms[0].fromAta))\r\n            &&  (!mandatoryCheckNoSpaces(document.forms[0].toAta)))  {\r\n\r\n                showBarMessage(ELL_SE0017, ERROR_MSG);\r\n                document.forms[0].fromEta.focus();\r\n                return false;\r\n        }\r\n\r\n        if(((mandatoryCheckNoSpaces(document.forms[0].fromEta)) && (!mandatoryCheckNoSpaces(document.forms[0].toEta)))\r\n            || (!mandatoryCheckNoSpaces(document.forms[0].fromEta)) && (mandatoryCheckNoSpaces(document.forms[0].toEta))){\r\n\r\n                if((!mandatoryCheckNoSpaces(document.forms[0].fromEta)) && (mandatoryCheckNoSpaces(document.forms[0].toEta))) {\r\n                    showBarMessage(ELL_SE0008, ERROR_MSG);\r\n                    document.forms[0].fromEta.focus();\r\n                    return false;\r\n\r\n                } else if((mandatoryCheckNoSpaces(document.forms[0].fromEta)) && (!mandatoryCheckNoSpaces(document.forms[0].toEta))) {\r\n                        showBarMessage(ELL_SE0009, ERROR_MSG);\r\n                        document.forms[0].toEta.focus();\r\n                        return false;\r\n                } else {\r\n                    if(!isValidDate(strFromEta)){\r\n                        showBarMessage(ELL_SE0010, ERROR_MSG);\r\n                        document.forms[0].fromEta.focus();\r\n                        return false;\r\n                    }\r\n                    if(!isValidDate(strToEta)){\r\n                        showBarMessage(ELL_SE0011, ERROR_MSG);\r\n                        document.forms[0].toEta.focus();\r\n                        return false;\r\n                    }\r\n                    //comapare both the dates\r\n                    if(strFromEta != \"\" && strToEta != \"\"){\r\n                        if(compareDate(strFromEta,strToEta,'1')){\r\n                            //Load List From Eta Date cannot be greater than To Eta Date\r\n                            showBarMessage(ELL_SE0014,ERROR_MSG);\r\n                            document.forms[0].fromEta.focus();\r\n                            return false;\r\n                        }\r\n                    }\r\n\r\n                }\r\n        }\r\n    if(((mandatoryCheckNoSpaces(document.forms[0].fromAta)) && (!mandatoryCheckNoSpaces(document.forms[0].toAta)))\r\n            || (!mandatoryCheckNoSpaces(document.forms[0].fromAta)) && (mandatoryCheckNoSpaces(document.forms[0].toAta))) {\r\n\r\n                if((!mandatoryCheckNoSpaces(document.forms[0].fromAta)) && (mandatoryCheckNoSpaces(document.forms[0].toAta))) {\r\n                    showBarMessage(ELL_SE0005, ERROR_MSG);\r\n                    document.forms[0].fromAta.focus();\r\n                    return false;\r\n\r\n                } else if((mandatoryCheckNoSpaces(document.forms[0].fromAta)) && (!mandatoryCheckNoSpaces(document.forms[0].toAta))) {\r\n                    showBarMessage(ELL_SE0006, ERROR_MSG);\r\n                    document.forms[0].toAta.focus();\r\n                    return false;\r\n                } else {\r\n                    if(!isValidDate(strFromAta)){\r\n                        showBarMessage(ELL_SE0012, ERROR_MSG);\r\n                        document.forms[0].fromAta.focus();\r\n                        return false;\r\n                    }\r\n                    if(!isValidDate(strToAta)){\r\n                        showBarMessage(ELL_SE0013, ERROR_MSG);\r\n                        document.forms[0].toAta.focus();\r\n                        return false;\r\n                    }\r\n                    //comapare both the dates\r\n                    if(strFromAta != \"\" && strToAta != \"\"){\r\n                        if(compareDate(strFromAta,strToAta,'1')){\r\n                            //Load List From Eta Date cannot be greater than To Eta Date\r\n                            showBarMessage(ELL_SE0015,ERROR_MSG);\r\n                            document.forms[0].fromAta.focus();\r\n                            return false;\r\n                        }\r\n                    }\r\n\r\n                }\r\n        }\r\n        \r\n         // ##02 :added for mandatory as per K. chatgamol.\r\n        if(strStatus==\"\" && strServiceCode==\"\" && strVessel==\"\" && strvoyage==\"\"){            \r\n            showBarMessage('Service or vessel or voyage no should not be blank', ERROR_MSG);\r\n            document.forms[0].serviceCd.focus();\r\n            return false;    \r\n       }\r\n       // end  \r\n\r\n\r\n        //Set the DischargeList counter to 0\r\n        document.forms[0].dischargeListCount.value= \"0\";\r\n        //set the action\r\n        document.getElementById(\"currPageNo\").value= 1;\r\n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[13] = 
    "';\r\n        /* Disable all controls */\r\n        disableOnSubmit();\r\n        document.forms[0].submit();\r\n        return false;\r\n    }\r\n\r\n    function onSaveSett() {\r\n\r\n           var strSearchCriteria    = '';\r\n           strSearchCriteria        = setSearchCriteria();\r\n           var screenName           = '1';\r\n           var winName              = 'secm004';\r\n\r\n           var pageId = document.getElementById(\"pageId\").value;\r\n           var viewId = document.getElementById(\"view\").value;\r\n           var urlStr = '".toCharArray();
    __oracle_jsp_text[14] = 
    "?screenName='+screenName+'&pageId='+pageId+'&searchCriteria='+strSearchCriteria+'&viewId='+viewId;\r\n\r\n           getGridControl().updateServerModel();\r\n\r\n           document.forms[0].action='".toCharArray();
    __oracle_jsp_text[15] = 
    "';\r\n           document.forms[0].submit();\r\n\r\n           //var responseMap= SweetDevRia.ComHelper.syncCallIAction (\"com.niit.control.common.ria.grid.common.ValidateMasterData\", {\"key\":\"UPDATED_GRID\",\"codeVal2\":pageId},null);\r\n           openChildWindow(urlStr,window,'500px','350px');\r\n\r\n           onRefresh();\r\n           return false;\r\n    }\r\n\r\n    //--richa\r\n    /*Called by Refresh Button*/\r\n    function onRefresh() {\r\n         getGridSearchCriteria();\r\n        deleteGridRows();\r\n        document.forms[0].fsc.value = lastFsc;\r\n         onSearch();\r\n    }\r\n    /*\r\n    function deleteGridRows() {\r\n\r\n            var objGrid = getGridControl();\r\n            for(i=0; i<mintTotalRows; i++){\r\n                if(objGrid.data[i][0] != null){\r\n                    deleteRowFromRiaGrid(objGrid,\"row\"+i);\r\n                }\r\n            }\r\n        }\r\n\r\n        */\r\n    /*Called by Back Button of Header */\r\n    function onBack(){\r\n        //Not Applicable for this screen\r\n    }\r\n\r\n    /*To reset theoriginal search criteria before processing*/\r\n    function resetSearchCriteria() {\r\n          document.forms[0].serviceGroup.value = lastServiceGroup;\r\n          document.forms[0].serviceCd.value  = lastServiceCd;\r\n          document.forms[0].port.value       = lastPort;\r\n          document.forms[0].terminal.value   = lastTerminal;\r\n          document.forms[0].fsc.value        = lastFsc;\r\n          document.forms[0].vessel.value     = lastVessel;\r\n          document.forms[0].inVoyage.value   = lastInVoyage;\r\n          document.forms[0].fromEta.value    = lastFromEta;\r\n          document.forms[0].toEta.value      = lastToEta;\r\n          document.forms[0].fromAta.value    = lastFromAta;\r\n          document.forms[0].toAta.value      = lastToAta;\r\n          document.forms[0].dischargelistStatus.value  = lastStatus;\r\n          document.forms[0].sortBy.value     = lastSortBy;\r\n          document.forms[0].sortIn.value     = lastSortIn;\r\n          document.forms[0].view.value       = lastView;\r\n    }\r\n\r\n\r\n\r\n    function setRowData(){\r\n        var selRowNo = getCurrRowNo();\r\n\r\n        document.forms[0].selDischargeListId.value  = document.getElementById('value[' + selRowNo + '].dischargeListId').value;\r\n        document.forms[0].selServiceCode.value  = document.getElementById('value[' + selRowNo + '].serviceCd').value;\r\n        document.forms[0].selVesselCode.value = document.getElementById('value[' + selRowNo + '].vessel').value;\r\n        document.forms[0].selDirection.value  = document.getElementById('value[' + selRowNo + '].direction').value;\r\n        document.forms[0].selVoyageCode.value  = document.getElementById('value[' + selRowNo + '].inVoyage').value;\r\n        document.forms[0].selPortSequenceNo.value = document.getElementById('value[' + selRowNo + '].sequence').value;\r\n        document.forms[0].selPortId.value = document.getElementById('value[' + selRowNo + '].port').value;\r\n        document.forms[0].selTerminalCode.value = document.getElementById('value[' + selRowNo + '].terminal').value;\r\n        document.forms[0].selBargeNo.value = document.getElementById('value[' + selRowNo + '].bargeName').value;\r\n        document.forms[0].selETA.value = document.getElementById('value[' + selRowNo + '].fromEta').value;\r\n        document.forms[0].selETD.value = document.getElementById('value[' + selRowNo + '].toEta').value;\r\n        document.forms[0].selATA.value = document.getElementById('value[' + selRowNo + '].ataTime').value;\r\n        document.forms[0].selATD.value = document.getElementById('value[' + selRowNo + '].atdTime').value;\r\n\r\n    }\r\n\r\n    function getSelRecStatus(){\r\n            var selRowNo = getCurrRowNo();\r\n            var recStatus = document.getElementById('value[' + selRowNo + '].dischargelistStatus').value;\r\n            if (recStatus == ''){\r\n                    recStatus = REC_STATUS_SUSPEND;\r\n            }\r\n            return recStatus;\r\n    }\r\n\r\n    /*Called by Create Arrival Bay Plan Button*/\r\n    function openCreateArrivalBayPlan() {\r\n        resetSearchCriteria();\r\n        var selectedIndex       = '';\r\n        var port                = '';\r\n        var terminal            = '';\r\n        var service             = '';\r\n        var vessel              = '';\r\n        var eta                 = '';\r\n        var voyage              = '';\r\n        var direction           = '';\r\n        var screenName          = '1';\r\n        var pageId              = '';\r\n        var viewId              = '';\r\n        var hdrEtaTm            = '';\r\n        var hdrEtdTm            = '';\r\n        var hdrEtaDateTime      = '';\r\n        var hdrEtdDateTime      = '';\r\n        var hdrEta              = '';\r\n\r\n\r\n\r\n\r\n        //If search not performed show error\r\n        searchPerformed = document.getElementById(\"searchPerformed\").value;\r\n                if(searchPerformed == \"false\") {\r\n                 showBarMessage(ECM_SE0007,ERROR_MSG);\r\n                 return false;\r\n                }\r\n\r\n                if(document.forms[0].radioGroup1 != null){\r\n                    if(document.forms[0].radioGroup1[0] != null){\r\n                        for( i = 0; i < document.forms[0].radioGroup1.length; i++ ) {\r\n                            if(document.forms[0].radioGroup1[i].checked) {\r\n                                    selectedIndex = i;\r\n                            }\r\n                        }\r\n                    } else {\r\n            selectedIndex = 0;\r\n                    }\r\n                }\r\n\r\n                //Call RiaGridCommon getSelectedRowData function to get the values of selected record in an array\r\n                rowData             =    getSelectedRowData(selectedIndex);\r\n                service = rowData[\"serviceCd\"];\r\n                port    = rowData[\"port\"];\r\n                terminal = rowData[\"terminal\"];\r\n                vessel = rowData[\"vessel\"];\r\n                voyage  = rowData[\"inVoyage\"];\r\n                direction = rowData[\"direction\"];\r\n                pageId  = document.getElementById(\"pageId\").value;\r\n                viewId  = document.getElementById(\"view\").value;\r\n                hdrEta            = rowData[\"fromEta\"];\r\n                hdrEtaTm = document.getElementById('value[' + selectedIndex + '].etaTime').value;\r\n                hdrEtdTm = document.getElementById('value[' + selectedIndex + '].etdTime').value;\r\n                    hdrEtaDateTime = hdrEta ;\r\n\r\n\r\n                var urlStr = '".toCharArray();
    __oracle_jsp_text[16] = 
    "?screenName='+screenName+'&pageId='+pageId+'&arrivalPort='+port+'&arrivalTerminal='+terminal+'&viewId='+viewId+'&service='+service+'&vessel='+vessel+'&eta='+hdrEtaDateTime+'&voyage='+voyage+'&direction='+direction+'&lldlflag=D';\r\n                \r\n               // openChildWindow(urlStr,window,'1000px','500px');\r\n                openChildScreen64(urlStr,FORM_ID);\r\n\r\n                return false;\r\n\r\n\r\n    }\r\n\r\n    function callDischargeListMaintenance() {\r\n        resetSearchCriteria();\r\n        var rowData             = {};\r\n        var selectedIndex       = '';\r\n        var hdrService          = '';\r\n        var hdrVesselName       = '';\r\n        var hdrDirection        = '';\r\n        var hdrVoyage           = '';\r\n        var hdrPortSeq          = '';\r\n        var hdrPort             = '';\r\n        var hdrTerminal         = '';\r\n        var hdrBargeNameVoyage  = '';\r\n        var hdrEta              = '';\r\n        var hdrEtd              = '';\r\n        var dischargeListStatus = '';\r\n        var readOnlyFlg         = '';\r\n        var dischargeListId     = '';\r\n        var flag                = '';\r\n        var hdrEtaTm            = '';\r\n        var hdrEtdTm            = '';\r\n        var hdrEtaDateTime      = '';\r\n        var hdrEtdDateTime      = '';\r\n        var etaTmFlag            = 'N';\r\n        var etdTmFlag            = 'N';\r\n        var ataTime            = '';\r\n        var atdTimd            = '';\r\n        var fromAta             = ''; // #1\r\n        var dcstatus           = ''; //#3\r\n        //If search not performed show error\r\n        searchPerformed = document.getElementById(\"searchPerformed\").value;\r\n        if(searchPerformed == \"false\") {\r\n            showBarMessage(ECM_SE0007,ERROR_MSG);\r\n            return false;\r\n        }\r\n\r\n        if(document.forms[0].radioGroup1 != null){\r\n            if(document.forms[0].radioGroup1[0] != null){\r\n                for( i = 0; i < document.forms[0].radioGroup1.length; i++ ) {\r\n                    if(document.forms[0].radioGroup1[i].checked) {\r\n                        selectedIndex = i;\r\n                    }\r\n                }\r\n            } else {\r\n                selectedIndex = 0;\r\n            }\r\n        }\r\n\r\n        flag = document.getElementById('value[' + selectedIndex + '].flag').value;\r\n        hdrEtaTm = document.getElementById('value[' + selectedIndex + '].etaTime').value;\r\n        hdrEtdTm = document.getElementById('value[' + selectedIndex + '].etdTime').value;\r\n                \r\n        \r\n        /* when Eta time and Etd time is null then pass 0000 to DL_MAINTENANCE screen. */\r\n        if ((hdrEtaTm == null) || (hdrEtaTm.length == 0)) {\r\n            etaTmFlag = 'Y';\r\n            hdrEtaTm = '0000';\r\n        }\r\n\r\n        if ((hdrEtdTm == null) || (hdrEtdTm.length == 0)) {\r\n            etdTmFlag = 'Y';\r\n            hdrEtdTm = '0000';\r\n        }\r\n\r\n        //Call RiaGridCommon getSelectedRowData function to get the values of selected record in an array\r\n        rowData             =    getSelectedRowData(selectedIndex);\r\n\r\n        hdrService          = rowData[\"serviceCd\"];\r\n        hdrVessel           = rowData[\"vessel\"];\r\n        hdrDirection        = rowData[\"direction\"];\r\n        hdrVoyage           = rowData[\"inVoyage\"];\r\n        hdrPortSeq          = rowData[\"sequence\"];\r\n        hdrPort             = rowData[\"port\"];\r\n        hdrTerminal         = rowData[\"terminal\"];\r\n        hdrBargeNameVoyage  = rowData[\"bargeName\"];\r\n        hdrEta              = rowData[\"fromEta\"];\r\n        hdrEtd              = rowData[\"toEta\"];\r\n        ataTime             = rowData[\"fromAta\"];\r\n        atdTime             = rowData[\"toAta\"];\r\n        fromAta             = ataTime; // #1\r\n        \r\n        //#3 begin\r\n        //dischargeListStatus = lastStatus;\r\n        dcstatus            = rowData[\"dischargelistStatus\"];\r\n        var op  = 'open';\r\n        var ar  = 'alert required';        \r\n        var dc  = 'discharge complete';\r\n        var rfi = 'ready for invoice';\r\n        var wc  = 'work complete';\r\n        if(dcstatus.toLowerCase() == op){\r\n            dischargeListStatus = 0;\r\n        }else if(dcstatus.toLowerCase() == ar){\r\n            dischargeListStatus = 5;\r\n        }else if(dcstatus.toLowerCase() == dc){\r\n            dischargeListStatus = 10;\r\n        }else if(dcstatus.toLowerCase() == rfi){\r\n            dischargeListStatus = 20;\r\n        }else if(dcstatus.toLowerCase() == wc){\r\n            dischargeListStatus = 30;\r\n        }else{\r\n            dischargeListStatus = null;\r\n        }\r\n        //#3 end\r\n        readOnlyFlg         = flag ;\r\n        dischargeListId     = document.getElementById('value[' + selectedIndex + '].dischargeListId').value;\r\n\r\n        var index1 = hdrEta.indexOf(\":\");\r\n        var index2 = hdrEtd.indexOf(\":\");\r\n        var index3 = hdrEta.indexOf(\" \");\r\n        var index4 = hdrEtd.indexOf(\" \");\r\n        var index5 = ataTime.indexOf(\" \"); // #1\r\n        \r\n        ataTime = ataTime.substring(ataTime.indexOf(\" \") ) ;\r\n        atdTime = atdTime.substring(atdTime.indexOf(\" \") ) ;\r\n        fromAta = fromAta.substring(0,index5); // #1\r\n        \r\n        hdrEtaDateTime =  hdrEta;\r\n        hdrEtdDateTime = hdrEtd;\r\n        \r\n        if (etdTmFlag == 'N') {\r\n            hdrEta = hdrEta.substring(0,index3);\r\n        }\r\n        \r\n        if (etaTmFlag == 'N') {\r\n            hdrEtd = hdrEtd.substring(0,index4);\r\n        }\r\n//        var fromAta = document.forms[0].fromEta.value; #1\r\n        var urlStr = '".toCharArray();
    __oracle_jsp_text[17] = 
    "?hdrService='+hdrService\r\n            +'&hdrVessel='+hdrVessel\r\n            +'&hdrDirection='+hdrDirection+'&hdrVoyage='+hdrVoyage\r\n            +'&hdrPortSeq='+hdrPortSeq+'&hdrTerminal='+hdrTerminal\r\n            +'&hdrBargeNameVoyage='+hdrBargeNameVoyage+'&hdrEta='+hdrEta\r\n            +'&hdrEtd='+hdrEtd+'&dischargeListStatus='+dischargeListStatus\r\n            +'&readOnlyFlg='+readOnlyFlg+'&dischargeListId='+dischargeListId\r\n            +'&hdrPort='+hdrPort+'&hdrEtaTm='+hdrEtaTm+'&hdrEtdTm='+hdrEtdTm\r\n            +'&hdrEtaDateTime='+hdrEtaDateTime\r\n            +'&hdrEtdDateTime='+hdrEtdDateTime+'&fromAta='+fromAta\r\n            +'&ataTime='+ataTime+'&atdTime='+atdTime;\r\n            \r\n        document.forms[0].action= urlStr;\r\n        document.forms[0].submit();\r\n\r\n        return false;\r\n    }\r\n\r\n    function changeViewCombo()\r\n    {\r\n\r\n        getGridSearchCriteria();\r\n        document.forms[0].fsc.value  = lastFsc;\r\n\r\n    }\r\n\r\n</SCRIPT>\r\n\r\n".toCharArray();
    __oracle_jsp_text[18] = 
    "\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[19] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[20] = 
    "\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[21] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[22] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[23] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[24] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[25] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[26] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[27] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[28] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[29] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[30] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[31] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[32] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[33] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[34] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[35] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[36] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[37] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[38] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[39] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[40] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[41] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[42] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[43] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[44] = 
    "\r\n\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[45] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[46] = 
    "\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[47] = 
    "\r\n    <div class=\"text_header\"><h2>Search</h2></div>\r\n    <table class=\"table_search\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\r\n      <tr>\r\n        <td>Service Group</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[48] = 
    "\r\n            <input type=\"button\" value=\". . .\" name=\"btnServiceGroupLookup\" class=\"btnbutton\" onclick='return openServiceGroupLookup()'/>\r\n        </td>\r\n        <td>Service</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[49] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[50] = 
    "\r\n            <input type=\"button\" value=\". . .\" name=\"btnServiceLookup\" class=\"btnbutton\" onclick='return openServiceLookup()'/>\r\n        </td>\r\n        <td>Port</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[51] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[52] = 
    "\r\n            <input type=\"button\" value=\". . .\" name=\"btnPortLookup\" class=\"btnbutton\" onclick='return openPortLookup()'/>\r\n        </td>\r\n        <td>FSC</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[53] = 
    "\r\n        </td>\r\n\r\n      </tr>\r\n      <tr>\r\n\r\n        <td>Vessel</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[54] = 
    "\r\n            <input type=\"button\" value=\". . .\" name=\"btnVesselLookup\" class=\"btnbutton\" onclick='return openVesselLookup()'/>\r\n        </td>\r\n        <td>In Voyage</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[55] = 
    "\r\n            <input type=\"button\" value=\". . .\" name=\"btnInVoyagelLookup\" class=\"btnbutton\" onclick='return openInVoyageLookup()'/>\r\n        </td>\r\n        <td>Terminal</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[56] = 
    "\r\n            <input type=\"button\" value=\". . .\" name=\"btnTerminalLookup\" class=\"btnbutton\" onclick='return openTerminalLookup()'/>\r\n\r\n        </td>\r\n      </tr>\r\n      <tr>\r\n        <td width=\"8%\">From ETA</td>\r\n        <td class=\"whitebg\" width=\"16%\">\r\n            ".toCharArray();
    __oracle_jsp_text[57] = 
    "\r\n            <a href=\"#\" onClick=\"showCalendar('forms[0].fromEta', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[58] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n        </td>\r\n        <td width=\"6%\">To ETA</td>\r\n        <td class=\"whitebg\" width=\"15%\">\r\n            ".toCharArray();
    __oracle_jsp_text[59] = 
    "\r\n            <a href=\"#\" onClick=\"showCalendar('forms[0].toEta', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[60] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n        </td>\r\n        <td width=\"6%\">From ATA</td>\r\n        <td class=\"whitebg\" width=\"15%\">\r\n            ".toCharArray();
    __oracle_jsp_text[61] = 
    "\r\n            <a href=\"#\" onClick=\"showCalendar('forms[0].fromAta', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[62] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n        </td>\r\n        <td width=\"4%\">To ATA</td>\r\n        <td class=\"whitebg\" width=\"15%\">\r\n            ".toCharArray();
    __oracle_jsp_text[63] = 
    "\r\n            <a href=\"#\" onClick=\"showCalendar('forms[0].toAta', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[64] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n        </td>\r\n      </tr>\r\n      <tr>\r\n\r\n        <td>In</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[65] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[66] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[67] = 
    "\r\n        </td>\r\n        <td>Sort Order</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[68] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[69] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[70] = 
    "\r\n        </td>\r\n        <td>Status</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[71] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[72] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[73] = 
    "\r\n         </td>\r\n        <td>View</td>\r\n        <td class=\"whitebg\">\r\n            ".toCharArray();
    __oracle_jsp_text[74] = 
    "\r\n                ".toCharArray();
    __oracle_jsp_text[75] = 
    "\r\n            ".toCharArray();
    __oracle_jsp_text[76] = 
    "\r\n        </td>\r\n      </tr>\r\n    </table>\r\n    ".toCharArray();
    __oracle_jsp_text[77] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[78] = 
    "\r\n    <div class=\"buttons_box\">\r\n\r\n        <input type=\"button\" value=\"Create Arrival Bay Plan\" name=\"btnCreateArrivalBayPlan\" class=\"event_btnbutton\" onclick='return openCreateArrivalBayPlan()'/>\r\n        <input type=\"button\" value=\"Save Sett.\" name=\"btnSaveSett\" class=\"event_btnbutton\" onclick='return onSaveSett()'/>\r\n        <input type=\"button\" value=\"Refresh\" name=\"btnRefresh\" class=\"event_btnbutton\" onclick='return onRefresh()'/>\r\n        <input type=\"button\" value=\"Reset\" name=\"btnReset\" class=\"event_btnbutton\" onclick='return onResetForm()'/>\r\n        <input type=\"button\" value=\"Find\" name=\"btnFind\" class=\"event_btnbutton\" onclick='return onSearch()'/>\r\n    </div>\r\n\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[79] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[80] = 
    "\r\n\r\n    <div class=\"text_header\"><h2>Search Result</h2></div>\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[81] = 
    "\r\n\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[82] = 
    "\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[83] = 
    "\r\n    <div class=\"buttons_box\">\r\n            <div id=\"editDiv\">\r\n                <input type=\"button\" value=\"Edit\" name=\"btnEdit\" class=\"event_btnbutton\" onclick='return callDischargeListMaintenance()'/>\r\n            </div>\r\n        </div>\r\n\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[84] = 
    "\r\n\r\n    ".toCharArray();
    __oracle_jsp_text[85] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[86] = 
    "\r\n    ".toCharArray();
    __oracle_jsp_text[87] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[88] = 
    "\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
