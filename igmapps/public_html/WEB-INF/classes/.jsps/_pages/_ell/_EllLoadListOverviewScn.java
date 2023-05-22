package _pages._ell;

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


public class _EllLoadListOverviewScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EllLoadListOverviewScn page = this;
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
      
          boolean[] arrAuthFlags = BaseAction.getAuthFlags(request, "SELL001");
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
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sell001search", pageContext));
      out.write(__oracle_jsp_text[11]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sell001", pageContext));
      out.write(__oracle_jsp_text[12]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sell001search", pageContext));
      out.write(__oracle_jsp_text[13]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm004", pageContext));
      out.write(__oracle_jsp_text[14]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sell001search", pageContext));
      out.write(__oracle_jsp_text[15]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm011", pageContext));
      out.write(__oracle_jsp_text[16]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/sell002", pageContext));
      out.write(__oracle_jsp_text[17]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_1=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setAction("/sell001");
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
              __jsp_taghandler_2.setName("fell001");
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
              __jsp_taghandler_3.setName("fell001");
              __jsp_taghandler_3.setProperty("selLoadListId");
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
              __jsp_taghandler_4.setName("fell001");
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
              __jsp_taghandler_5.setName("fell001");
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
              __jsp_taghandler_6.setName("fell001");
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
              __jsp_taghandler_7.setName("fell001");
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
              __jsp_taghandler_8.setName("fell001");
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
              __jsp_taghandler_9.setName("fell001");
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
              __jsp_taghandler_10.setName("fell001");
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
              __jsp_taghandler_11.setName("fell001");
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
              __jsp_taghandler_12.setName("fell001");
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
              __jsp_taghandler_13.setName("fell001");
              __jsp_taghandler_13.setProperty("selETD");
              __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
              if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,2);
            }
            out.write(__oracle_jsp_text[42]);
            out.write(__oracle_jsp_text[43]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_14=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_14.setParent(__jsp_taghandler_1);
              __jsp_taghandler_14.setName("fell001");
              __jsp_taghandler_14.setProperty("loadListCount");
              __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
              if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,2);
            }
            out.write(__oracle_jsp_text[44]);
            out.write(__oracle_jsp_text[45]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_15=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_15.setParent(__jsp_taghandler_1);
              __jsp_taghandler_15.setMaxlength("3");
              __jsp_taghandler_15.setName("fell001");
              __jsp_taghandler_15.setOnblur("changeUpper(this)");
              __jsp_taghandler_15.setProperty("serviceGroup");
              __jsp_taghandler_15.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
              if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,2);
            }
            out.write(__oracle_jsp_text[46]);
            out.write(__oracle_jsp_text[47]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_16=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_16.setParent(__jsp_taghandler_1);
              __jsp_taghandler_16.setMaxlength("5");
              __jsp_taghandler_16.setName("fell001");
              __jsp_taghandler_16.setOnblur("changeUpper(this);");
              __jsp_taghandler_16.setProperty("serviceCd");
              __jsp_taghandler_16.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[48]);
            out.write(__oracle_jsp_text[49]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_17=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style styleClass");
              __jsp_taghandler_17.setParent(__jsp_taghandler_1);
              __jsp_taghandler_17.setMaxlength("5");
              __jsp_taghandler_17.setName("fell001");
              __jsp_taghandler_17.setOnblur("changeUpper(this);");
              __jsp_taghandler_17.setProperty("port");
              __jsp_taghandler_17.setStyle("width:75%");
              __jsp_taghandler_17.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
              if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,2);
            }
            out.write(__oracle_jsp_text[50]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_18=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly styleClass value");
              __jsp_taghandler_18.setParent(__jsp_taghandler_1);
              __jsp_taghandler_18.setMaxlength("3");
              __jsp_taghandler_18.setName("fell001");
              __jsp_taghandler_18.setOnblur("changeUpper(this)");
              __jsp_taghandler_18.setProperty("fsc");
              __jsp_taghandler_18.setReadonly(true);
              __jsp_taghandler_18.setStyleClass("non_edit");
              __jsp_taghandler_18.setValue(OracleJspRuntime.toStr( strUserFsc));
              __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
              if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,2);
            }
            out.write(__oracle_jsp_text[51]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_19=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_19.setParent(__jsp_taghandler_1);
              __jsp_taghandler_19.setMaxlength("5");
              __jsp_taghandler_19.setName("fell001");
              __jsp_taghandler_19.setOnblur("changeUpper(this)");
              __jsp_taghandler_19.setProperty("vessel");
              __jsp_taghandler_19.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
              if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,2);
            }
            out.write(__oracle_jsp_text[52]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_20=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
              __jsp_taghandler_20.setParent(__jsp_taghandler_1);
              __jsp_taghandler_20.setMaxlength("10");
              __jsp_taghandler_20.setName("fell001");
              __jsp_taghandler_20.setOnblur("changeUpper(this)");
              __jsp_taghandler_20.setProperty("outVoyage");
              __jsp_taghandler_20.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
              if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,2);
            }
            out.write(__oracle_jsp_text[53]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_21=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style styleClass");
              __jsp_taghandler_21.setParent(__jsp_taghandler_1);
              __jsp_taghandler_21.setMaxlength("5");
              __jsp_taghandler_21.setName("fell001");
              __jsp_taghandler_21.setOnblur("changeUpper(this);");
              __jsp_taghandler_21.setProperty("terminal");
              __jsp_taghandler_21.setStyle("width:75%");
              __jsp_taghandler_21.setStyleClass("must");
              __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
              if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,2);
            }
            out.write(__oracle_jsp_text[54]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_22=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property style");
              __jsp_taghandler_22.setParent(__jsp_taghandler_1);
              __jsp_taghandler_22.setMaxlength("10");
              __jsp_taghandler_22.setName("fell001");
              __jsp_taghandler_22.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_22.setOnclick("this.select();");
              __jsp_taghandler_22.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_22.setProperty("fromEta");
              __jsp_taghandler_22.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
              if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,2);
            }
            out.write(__oracle_jsp_text[55]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[56]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_23=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property style");
              __jsp_taghandler_23.setParent(__jsp_taghandler_1);
              __jsp_taghandler_23.setMaxlength("10");
              __jsp_taghandler_23.setName("fell001");
              __jsp_taghandler_23.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_23.setOnclick("this.select();");
              __jsp_taghandler_23.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_23.setProperty("toEta");
              __jsp_taghandler_23.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
              if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,2);
            }
            out.write(__oracle_jsp_text[57]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[58]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_24=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property style");
              __jsp_taghandler_24.setParent(__jsp_taghandler_1);
              __jsp_taghandler_24.setMaxlength("10");
              __jsp_taghandler_24.setName("fell001");
              __jsp_taghandler_24.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_24.setOnclick("this.select();");
              __jsp_taghandler_24.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_24.setProperty("fromAta");
              __jsp_taghandler_24.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
              if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,2);
            }
            out.write(__oracle_jsp_text[59]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[60]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_25=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick onkeypress property style");
              __jsp_taghandler_25.setParent(__jsp_taghandler_1);
              __jsp_taghandler_25.setMaxlength("10");
              __jsp_taghandler_25.setName("fell001");
              __jsp_taghandler_25.setOnblur("dateFormat(this,this.value,event,true,1,document.all('msg'));");
              __jsp_taghandler_25.setOnclick("this.select();");
              __jsp_taghandler_25.setOnkeypress("dateFormat(this,this.value,event,false,1,document.all('msg'));");
              __jsp_taghandler_25.setProperty("toAta");
              __jsp_taghandler_25.setStyle("width:75%");
              __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
              if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,2);
            }
            out.write(__oracle_jsp_text[61]);
            out.print(request.getContextPath());
            out.write(__oracle_jsp_text[62]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_26=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style size");
              __jsp_taghandler_26.setParent(__jsp_taghandler_1);
              __jsp_taghandler_26.setName("fell001");
              __jsp_taghandler_26.setProperty("sortBy");
              __jsp_taghandler_26.setStyle("width:90%");
              __jsp_taghandler_26.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_26,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[63]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_27=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_27.setParent(__jsp_taghandler_26);
                    __jsp_taghandler_27.setLabel("name");
                    __jsp_taghandler_27.setName("fell001");
                    __jsp_taghandler_27.setProperty("sortByValues");
                    __jsp_taghandler_27.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
                    if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,3);
                  }
                  out.write(__oracle_jsp_text[64]);
                } while (__jsp_taghandler_26.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,2);
            }
            out.write(__oracle_jsp_text[65]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_28=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property size");
              __jsp_taghandler_28.setParent(__jsp_taghandler_1);
              __jsp_taghandler_28.setName("fell001");
              __jsp_taghandler_28.setProperty("sortIn");
              __jsp_taghandler_28.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_28,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[66]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_29=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_29.setParent(__jsp_taghandler_28);
                    __jsp_taghandler_29.setLabel("name");
                    __jsp_taghandler_29.setName("fell001");
                    __jsp_taghandler_29.setProperty("sortInValues");
                    __jsp_taghandler_29.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
                    if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,3);
                  }
                  out.write(__oracle_jsp_text[67]);
                } while (__jsp_taghandler_28.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,2);
            }
            out.write(__oracle_jsp_text[68]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_30=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property style styleClass size");
              __jsp_taghandler_30.setParent(__jsp_taghandler_1);
              __jsp_taghandler_30.setName("fell001");
              __jsp_taghandler_30.setProperty("loadlistStatus");
              __jsp_taghandler_30.setStyle("height:20px");
              __jsp_taghandler_30.setStyleClass("must");
              __jsp_taghandler_30.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_30,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[69]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_31=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_31.setParent(__jsp_taghandler_30);
                    __jsp_taghandler_31.setLabel("name");
                    __jsp_taghandler_31.setName("fell001");
                    __jsp_taghandler_31.setProperty("loadListStatusValues");
                    __jsp_taghandler_31.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
                    if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,3);
                  }
                  out.write(__oracle_jsp_text[70]);
                } while (__jsp_taghandler_30.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,2);
            }
            out.write(__oracle_jsp_text[71]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_32=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onchange property style size");
              __jsp_taghandler_32.setParent(__jsp_taghandler_1);
              __jsp_taghandler_32.setName("fell001");
              __jsp_taghandler_32.setOnchange("changeViewCombo()");
              __jsp_taghandler_32.setProperty("view");
              __jsp_taghandler_32.setStyle("height:25px");
              __jsp_taghandler_32.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_32,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[72]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_33=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_33.setParent(__jsp_taghandler_32);
                    __jsp_taghandler_33.setLabel("name");
                    __jsp_taghandler_33.setName("fell001");
                    __jsp_taghandler_33.setProperty("viewListValues");
                    __jsp_taghandler_33.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
                    if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,3);
                  }
                  out.write(__oracle_jsp_text[73]);
                } while (__jsp_taghandler_32.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,2);
            }
            out.write(__oracle_jsp_text[74]);
            out.write(__oracle_jsp_text[75]);
            out.write(__oracle_jsp_text[76]);
            out.write(__oracle_jsp_text[77]);
            out.write(__oracle_jsp_text[78]);
            {
              String __url=OracleJspRuntime.toStr("../ell/EllLoadListOverviewGrid.jsp");
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[79]);
            out.write(__oracle_jsp_text[80]);
            out.write(__oracle_jsp_text[81]);
            out.write(__oracle_jsp_text[82]);
            out.write(__oracle_jsp_text[83]);
            out.write(__oracle_jsp_text[84]);
            {
              String __url=OracleJspRuntime.toStr("../common/tiles/pagination.jsp");
              __url=OracleJspRuntime.genPageUrl(__url,request,response,new String[] {"formName" } ,new String[] {OracleJspRuntime.toStr("fell001") } );
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[85]);
            out.write(__oracle_jsp_text[86]);
          } while (__jsp_taghandler_1.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[87]);

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
  private static final char __oracle_jsp_text[][]=new char[88][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[10] = 
    "/js/riaGridCommon.js\"></script>    \n<SCRIPT language=\"javascript\" type=\"text/javascript\">    \n    \n    var PROG_ID           = 'SELL001';\n    var FORM_ID           = 'fell001';\n    \n    var lastServiceGroup   = '';\n    var lastServiceCd    = '';\n    var lastPort         = '';\n    var lastTerminal     = '';\n    var lastFsc          = '';\n    var lastVessel       = '';\n    var lastOutVoyage     = '';\n    var lastFromEta      = '';\n    var lastToEta        = '';\n    var lastFromAta      = '';\n    var lastToAta        = '';\n    var lastStatus       = '';\n    var lastSortBy       = '';\n    var lastSortIn       = '';\n    var lastView         = '';\n    var searchPerformed  = \"false\";\n    var defaultFromEta   = '';\n    var defaultToEta     = '';\n    \n    \n    /*Called by framework on-load of this JSP*/\n    function onLoad() {  \n        \n        searchPerformed = document.getElementById(\"searchPerformed\").value;\n        \n        lastServiceGroup  = document.forms[0].serviceGroup.value;\n        lastServiceCd     = document.forms[0].serviceCd.value;\n        lastPort          = document.forms[0].port.value;\n        lastTerminal      = document.forms[0].terminal.value;\n        lastFsc           = document.forms[0].fsc.value;\n        lastVessel        = document.forms[0].vessel.value;\n        lastOutVoyage     = document.forms[0].outVoyage.value;\n        lastFromEta       = document.forms[0].fromEta.value;\n        lastToEta         = document.forms[0].toEta.value;\n        lastFromAta       = document.forms[0].fromAta.value;\n        lastToAta         = document.forms[0].toAta.value;\n        lastStatus        = document.forms[0].loadlistStatus.value;\n        lastSortBy        = document.forms[0].sortBy.value;\n        lastSortIn        = document.forms[0].sortIn.value;\n        lastView          = document.forms[0].view.value;\n        \n        if(searchPerformed == \"false\") {\n            defaultFromEta = document.forms[0].fromEta.value;\n            defaultToEta   = document.forms[0].toEta.value;\n        }\n        \n        /*Check the value of load list counter for radio button selected*/\n        if(document.forms[0].radioGroup1 != null){\n            if(document.forms[0].radioGroup1[0] != null){\n                for( i = 0; i < document.forms[0].radioGroup1.length; i++ )\n                {\n                    if(document.forms[0].radioGroup1[i].value == document.forms[0].loadListCount.value) {\n                  document.forms[0].radioGroup1[i].checked = 'true'; \n                    }\n                }\n            } else {\n                if(document.forms[0].radioGroup1.value == document.forms[0].loadListCount.value) {\n                    document.forms[0].radioGroup1.checked = 'true';\n                }\n            }\n        }\n        \n        //highlight the radio button acc to load list counter\n        \n        document.forms[0].serviceGroup.focus();\n        \n    }\n    \n    /*Called by framework for Pagination*/\n    function getActionUrl(){        \n        resetSearchCriteria();\n        //Set the load list counter to 0\n        document.forms[0].loadListCount.value= \"0\";\n        lstrUrl = '".toCharArray();
    __oracle_jsp_text[11] = 
    "';\n        document.forms[0].action=lstrUrl;\n        return lstrUrl;\n    }\n    \n    function openServiceGroupLookup(){\n            var rowId = FORM_ID;\n            openLookup(FORM_ID, rowId, MASTER_ID_SERVICE_GRP, '');\n    }\n    \n    function openServiceLookup(){\n            \n            var rowId = FORM_ID;\n            openLookup(FORM_ID, rowId, MASTER_ID_SERVICE, '');\n    }\n    \n    function openPortLookup(){\n            var rowId = FORM_ID;\n            openLookup(FORM_ID, rowId, MASTER_ID_PORT, '');\n    }\n    \n    function openTerminalLookup(){\n            var rowId = FORM_ID;\n            openLookup(FORM_ID, rowId, MASTER_ID_TERMINAL, '');\n    }\n    \n    \n    function openVesselLookup(){\n            var rowId = FORM_ID;            \n            openLookup(FORM_ID, rowId, MASTER_ID_VESSEL, '');\n    }\n\n    function openOutVoyageLookup(){\n            var rowId = FORM_ID;            \n            openLookup(FORM_ID, rowId, MASTER_ID_OUT_VOYAGE, '');\n    }\n\n    /*Called by master lookup screens to return selected values*/\n    function setLookupValues(aFormName, aRowId,strMasterId, arrResultData){\n    \n    \n        if(arrResultData[0] == FAILURE){\n            return;\n        }\n                        \n        if(strMasterId == MASTER_ID_SERVICE_GRP\n            || (strMasterId == MASTER_ID_SERVICE) \n            || (strMasterId == MASTER_ID_VESSEL)\n            || (strMasterId == MASTER_ID_OUT_VOYAGE)){\n            document.forms[0].serviceGroup.value=arrResultData[IDX_SRV_GRP_CD];\n            document.forms[0].serviceCd.value=arrResultData[IDX_SRV_CD];\n            document.forms[0].port.value=arrResultData[IDX_PRT_CD];\n            document.forms[0].terminal.value=arrResultData[IDX_TRM_CD];\n            document.forms[0].vessel.value=arrResultData[IDX_VSL_CD];\n            document.forms[0].outVoyage.value=arrResultData[IDX_OUT_VOY_CD];\n                \n        }  else if(strMasterId == MASTER_ID_PORT){            \n            //set Port       \n            document.forms[0].port.value=arrResultData[IDX_PORT_CD];\n        } else if(strMasterId == MASTER_ID_TERMINAL){\n            //set Terminal\n            document.forms[0].terminal.value=arrResultData[IDX_TRML_CD];\n        }  \n    }\n\n    \n    /*Called by framework on reset or refresh for reloading the page*/\n    function onResetForm(){\n        document.forms[0].currPageNo.value= 1;\n        document.forms[0].totRecord.value=0;\n        \n        //Set the DischargeList counter to 0\n        document.forms[0].loadListCount.value= \"0\";\n        //Setting the default values for controls\n        getGridSearchCriteria();\n        /*\n        document.forms[0].serviceGroup.value = \"\";\n        document.forms[0].serviceCd.value   = \"\";\n        document.forms[0].port.value        = \"\";\n        document.forms[0].terminal.value    = \"\";\n        document.forms[0].fsc.value         = \"\";\n        document.forms[0].vessel.value      = \"\";\n        document.forms[0].outVoyage.value    = \"\";\n        document.forms[0].fromEta.value     = defaultFromEta;\n        document.forms[0].toEta.value       = defaultToEta;\n        document.forms[0].fromAta.value     = \"\";\n        document.forms[0].toAta.value       = \"\";\n        document.forms[0].loadlistStatus.value   = lastStatus;\n        document.forms[0].sortBy.value      = lastSortBy;\n        document.forms[0].sortIn.value      = lastSortIn;\n        document.forms[0].view.value        = lastView;\n        \n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[12] = 
    "';        \n        document.forms[0].submit();        \n        */\n        return false;\n    }\n        \n    /*Called by Find Button*/\n    function onSearch() {       \n        //Clear the Data Table\n        //clearDiv('search_result');\n        clearDiv('fixedColumns_bodyDiv');\n        var strFromEta = document.forms[0].fromEta.value;\n        var strToEta = document.forms[0].toEta.value;\n        var strFromAta = document.forms[0].fromAta.value;\n        var strToAta = document.forms[0].toAta.value;\n        var strStatus =document.forms[0].loadlistStatus.value;\n        var strServiceCode=document.forms[0].serviceCd.value;\n        var strVessel =document.forms[0].vessel.value;\n        var strvoyage=document.forms[0].outVoyage.value;\n       \n        if(!mandatoryCheckNoSpaces(document.forms[0].port)) {\n            showBarMessage(ELL_SE0001, ERROR_MSG);\n            document.forms[0].port.focus();\n            return false;\n        }\n        \n        //Check if Terminal is entered or not\n        if(!mandatoryCheckNoSpaces(document.forms[0].terminal)) {\n            showBarMessage(ELL_SE0002, ERROR_MSG);\n            document.forms[0].terminal.focus();\n            return false;\n        }\n        \n       if((!mandatoryCheckNoSpaces(document.forms[0].fromEta))\n            && (!mandatoryCheckNoSpaces(document.forms[0].toEta))\n            && (!mandatoryCheckNoSpaces(document.forms[0].fromAta))\n            &&  (!mandatoryCheckNoSpaces(document.forms[0].toAta)))  {\n            \n                showBarMessage(ELL_SE0017, ERROR_MSG);\n                document.forms[0].fromEta.focus();\n                return false;\n        } \n\n        if(((mandatoryCheckNoSpaces(document.forms[0].fromEta)) && (!mandatoryCheckNoSpaces(document.forms[0].toEta)))\n            || (!mandatoryCheckNoSpaces(document.forms[0].fromEta)) && (mandatoryCheckNoSpaces(document.forms[0].toEta))){\n                \n                if((!mandatoryCheckNoSpaces(document.forms[0].fromEta)) && (mandatoryCheckNoSpaces(document.forms[0].toEta))) {\n                    showBarMessage(ELL_SE0008, ERROR_MSG);\n                    document.forms[0].fromEta.focus();\n                    return false;    \n               \n                } else if((mandatoryCheckNoSpaces(document.forms[0].fromEta)) && (!mandatoryCheckNoSpaces(document.forms[0].toEta))) {\n                        showBarMessage(ELL_SE0009, ERROR_MSG);\n                        document.forms[0].toEta.focus();\n                        return false; \n                } else {\n                    if(!isValidDate(strFromEta)){\n                        showBarMessage(ELL_SE0010, ERROR_MSG);\n                        document.forms[0].fromEta.focus();\n                        return false;    \n                    }\n                    if(!isValidDate(strToEta)){\n                        showBarMessage(ELL_SE0011, ERROR_MSG);\n                        document.forms[0].toEta.focus();\n                        return false;    \n                    }\n                    //comapare both the dates\n                    if(strFromEta != \"\" && strToEta != \"\"){\n                        if(compareDate(strFromEta,strToEta,'1')){\n                            //Load List From Eta Date cannot be greater than To Eta Date\n                            showBarMessage(ELL_SE0014,ERROR_MSG);\n                            document.forms[0].fromEta.focus();\n                            return false;\n                        }\n                    }\n                \n                }\n        } \n    if(((mandatoryCheckNoSpaces(document.forms[0].fromAta)) && (!mandatoryCheckNoSpaces(document.forms[0].toAta)))\n            || (!mandatoryCheckNoSpaces(document.forms[0].fromAta)) && (mandatoryCheckNoSpaces(document.forms[0].toAta))) {\n                \n                if((!mandatoryCheckNoSpaces(document.forms[0].fromAta)) && (mandatoryCheckNoSpaces(document.forms[0].toAta))) {\n                    showBarMessage(ELL_SE0005, ERROR_MSG);\n                    document.forms[0].fromAta.focus();\n                    return false;    \n               \n                } else if((mandatoryCheckNoSpaces(document.forms[0].fromAta)) && (!mandatoryCheckNoSpaces(document.forms[0].toAta))) {\n                    showBarMessage(ELL_SE0006, ERROR_MSG);\n                    document.forms[0].toAta.focus();\n                    return false; \n                } else {\n                    if(!isValidDate(strFromAta)){\n                        showBarMessage(ELL_SE0012, ERROR_MSG);\n                        document.forms[0].fromAta.focus();\n                        return false;    \n                    }\n                    if(!isValidDate(strToAta)){\n                        showBarMessage(ELL_SE0013, ERROR_MSG);\n                        document.forms[0].toAta.focus();\n                        return false;    \n                    }\n                    //comapare both the dates\n                    if(strFromAta != \"\" && strToAta != \"\"){\n                        if(compareDate(strFromAta,strToAta,'1')){\n                            //Load List From Eta Date cannot be greater than To Eta Date\n                            showBarMessage(ELL_SE0015,ERROR_MSG);\n                            document.forms[0].fromAta.focus();\n                            return false;\n                        }\n                    }\n                \n                }\n        } \n        // added for mandatory as per K. chatgamol.\n        if(strStatus==\"\" && strServiceCode==\"\" && strVessel==\"\" && strvoyage==\"\"){            \n            showBarMessage('Service or vessel or voyage no should not be blank', ERROR_MSG);\n            document.forms[0].serviceCd.focus();\n            return false;    \n       }\n       // end  \n        \n        //Set search Performed to true\n        searchPerformed = \"true\";\n        //Set the LoadList counter to 0\n        document.forms[0].loadListCount.value= \"0\";\n        //set the action\n        document.forms[0].currPageNo.value= 1;\n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[13] = 
    "';\n        /* Disable all controls */\n        disableOnSubmit();\n        document.forms[0].submit();\n        return false;\n    }\n\n    \n    \n   function onSaveSett() {\n        var strSearchCriteria    = ''; \n       strSearchCriteria        = setSearchCriteria(); \n       var screenName           = '6';\n       var winName              = 'secm004';\n       \n       var pageId = document.getElementById(\"pageId\").value;\n       var viewId = document.getElementById(\"view\").value;\n       var urlStr = '".toCharArray();
    __oracle_jsp_text[14] = 
    "?screenName='+screenName+'&pageId='+pageId+'&searchCriteria='+strSearchCriteria+'&viewId='+viewId;\n       \n       getGridControl().updateServerModel();\n                    \n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[15] = 
    "';\n        document.forms[0].submit();\n    \n        //var responseMap= SweetDevRia.ComHelper.syncCallIAction (\"com.niit.control.common.ria.grid.common.ValidateMasterData\", {\"key\":\"UPDATED_GRID\",\"codeVal2\":pageId},null);\n        openChildWindow(urlStr,window,'500px','350px');\n            \n        onRefresh();\n        \n       return false;\n    }\n     \n    //--richa\n    /*Called by Refresh Button*/\n    function onRefresh() {\n         getGridSearchCriteria();\n         deleteGridRows();\n        document.forms[0].fsc.value = lastFsc;\n         onSearch();\n    }\n    \n    \n    \n    /*To reset theoriginal search criteria before processing*/\n    function resetSearchCriteria() {\n          document.forms[0].serviceGroup.value = lastServiceGroup;\n          document.forms[0].serviceCd.value  = lastServiceCd;\n          document.forms[0].port.value       = lastPort;\n          document.forms[0].terminal.value   = lastTerminal;\n          document.forms[0].fsc.value        = lastFsc;\n          document.forms[0].vessel.value     = lastVessel;\n          document.forms[0].outVoyage.value   = lastOutVoyage;\n          document.forms[0].fromEta.value    = lastFromEta;\n          document.forms[0].toEta.value      = lastToEta;\n          document.forms[0].fromAta.value    = lastFromAta;\n          document.forms[0].toAta.value      = lastToAta;\n          document.forms[0].loadlistStatus.value  = lastStatus;\n          document.forms[0].sortBy.value     = lastSortBy;\n          document.forms[0].sortIn.value     = lastSortIn;\n          document.forms[0].view.value       = lastView;\n    }\n    \n    function setRowData(){\n        var selRowNo = getCurrRowNo();\n        \n        document.forms[0].selLoadListId.value  = document.getElementById('value[' + selRowNo + '].loadListId').value;\n        document.forms[0].selServiceCode.value  = document.getElementById('value[' + selRowNo + '].serviceCd').value;\n        document.forms[0].selVesselCode.value = document.getElementById('value[' + selRowNo + '].vessel').value;\n        document.forms[0].selDirection.value  = document.getElementById('value[' + selRowNo + '].direction').value;\n        document.forms[0].selVoyageCode.value  = document.getElementById('value[' + selRowNo + '].outVoyage').value;\n        document.forms[0].selPortSequenceNo.value = document.getElementById('value[' + selRowNo + '].sequence').value;\n        document.forms[0].selPortId.value = document.getElementById('value[' + selRowNo + '].port').value;\n        document.forms[0].selTerminalCode.value = document.getElementById('value[' + selRowNo + '].terminal').value;\n        document.forms[0].selBargeNo.value = document.getElementById('value[' + selRowNo + '].bargeName').value;\n        document.forms[0].selETA.value = document.getElementById('value[' + selRowNo + '].fromEta').value;\n        document.forms[0].selETD.value = document.getElementById('value[' + selRowNo + '].toEta').value;\n        \n        //document.forms[0].selContractId.value  = document.getElementById('value[' + selRowNo + '].rowId').value;\n        //document.forms[0].selContractFsc.value = document.getElementById('value[' + selRowNo + '].fsc').value;\n    }\n    \n    function getSelRecStatus(){\n            var selRowNo = getCurrRowNo();\n            var recStatus = document.getElementById('value[' + selRowNo + '].loadlistStatus').value;\n            if (recStatus == ''){\n                    recStatus = REC_STATUS_SUSPEND;\n            }\n            return recStatus;\n    }\n    \n    /*Called by Create Arrival Bay Plan Button*/\n    function openCreateArrivalBayPlan() {\n        resetSearchCriteria();\n        var selectedIndex       = '';\n        var port                = '';\n        var terminal            = '';\n        var service             = '';\n        var vessel              = '';\n        var eta                 = '';\n        var voyage              = '';\n        var direction           = '';\n        var screenName          = '6';\n        var pageId              = '';\n        var viewId              = '';\n        var hdrEtaTm            = '';\n        var hdrEtdTm            = '';\n        var hdrEtaDateTime      = '';\n        var hdrEtdDateTime      = '';\n        var hdrEta              = '';\n        \n        \n        \n        \n        //If search not performed show error\n        searchPerformed = document.getElementById(\"searchPerformed\").value;\n                if(searchPerformed == \"false\") {\n                 showBarMessage(ECM_SE0007,ERROR_MSG);\n                 return false;\n                }\n                \n                if(document.forms[0].radioGroup1 != null){\n                    if(document.forms[0].radioGroup1[0] != null){\n                        for( i = 0; i < document.forms[0].radioGroup1.length; i++ ) {\n                            if(document.forms[0].radioGroup1[i].checked) {\n                                    selectedIndex = i;\n                            }\n                        }\n                    } else {\n            selectedIndex = 0;\n                    }\n                }\n                \n                //Call RiaGridCommon getSelectedRowData function to get the values of selected record in an array\n                rowData             =    getSelectedRowData(selectedIndex);\n                service = rowData[\"serviceCd\"];\n                port    = rowData[\"port\"];\n                terminal = rowData[\"terminal\"];\n                vessel = rowData[\"vessel\"];\n                voyage  = rowData[\"outVoyage\"];\n                direction = rowData[\"direction\"];\n                pageId  = document.getElementById(\"pageId\").value;\n                viewId  = document.getElementById(\"view\").value;\n                hdrEta            = rowData[\"toEta\"];\n                hdrEtaTm = document.getElementById('value[' + selectedIndex + '].etdTime').value;\n                hdrEtaDateTime = hdrEta;\n                hdrPortSeq          = rowData[\"sequence\"];                \n                \n                var urlStr = '".toCharArray();
    __oracle_jsp_text[16] = 
    "?screenName='+screenName+'&pageId='+pageId+'&arrivalPort='+port+'&arrivalTerminal='+terminal+'&viewId='+viewId+'&service='+service+'&vessel='+vessel+'&eta='+hdrEtaDateTime+'&voyage='+voyage+'&direction='+direction+'&portSeq='+hdrPortSeq+'&lldlflag=L';\n                \n                //openChildWindow(urlStr,window,'1000px','500px');\n                                openChildScreen64(urlStr,FORM_ID);\n                return false;\n    }\n    \n    function callLoadListMaintenance() {\n            resetSearchCriteria();\n        var rowData             = {};\n        var selectedIndex       = '';\n        var hdrService          = '';\n        var hdrVesselName       = '';\n        var hdrDirection        = '';\n        var hdrVoyage           = '';\n        var hdrPortSeq          = '';\n        var hdrPort             = '';\n        var hdrTerminal         = '';\n        var hdrBargeNameVoyage  = '';\n        var hdrEta              = '';\n        var hdrEtd              = '';\n        var loadlistStatus       = '';\n        var readOnlyFlg         = '';\n        var loadListId     = '';\n                var flag                = '';\n                var hdrEtaTm            = '';\n                var hdrEtdTm            = '';\n                var hdrEtaDateTime      = '';\n                var hdrEtdDateTime      = '';\n        var etaTmFlag            = 'N';\n        var etdTmFlag            = 'N';\n        var llstatus             = ''; //#1\n        \n                //If search not performed show error\n        searchPerformed = document.getElementById(\"searchPerformed\").value;\n                if(searchPerformed == \"false\") {\n                 showBarMessage(ECM_SE0007,ERROR_MSG);\n                 return false;\n                }\n        if(document.forms[0].radioGroup1 != null){\n                    if(document.forms[0].radioGroup1[0] != null){\n                        for( i = 0; i < document.forms[0].radioGroup1.length; i++ ) {\n                            if(document.forms[0].radioGroup1[i].checked) {\n                                    selectedIndex = i;\n                            }\n                        }\n                    } else {\n            selectedIndex = 0;\n                    }\n                }\n        flag = document.getElementById('value[' + selectedIndex + '].flag').value;\n        hdrEtaTm = document.getElementById('value[' + selectedIndex + '].etaTime').value;\n        hdrEtdTm = document.getElementById('value[' + selectedIndex + '].etdTime').value;\n\n        /* when Eta time and Etd time is null then pass 0000 to LL_MAINTENANCE screen. */\n        if ((hdrEtaTm == null) || (hdrEtaTm.length == 0)) {\n            etaTmFlag = 'Y';\n            hdrEtaTm = '0000';\n        }\n\n        if ((hdrEtdTm == null) || (hdrEtdTm.length == 0)) {\n            etdTmFlag = 'Y';\n            hdrEtdTm = '0000';\n        }\n\n        \n        //Call RiaGridCommon getSelectedRowData function to get the values of selected record in an array\n        rowData             =    getSelectedRowData(selectedIndex);\n        \n        hdrService          = rowData[\"serviceCd\"];\n        hdrVessel           = rowData[\"vessel\"];\n        hdrDirection        = rowData[\"direction\"];\n        hdrVoyage           = rowData[\"outVoyage\"];\n        hdrPortSeq          = rowData[\"sequence\"];\n        hdrPort             = rowData[\"port\"];\n        hdrTerminal         = rowData[\"terminal\"];\n        hdrBargeNameVoyage  = rowData[\"bargeName\"];\n        hdrEta                = rowData[\"fromEta\"];\n        hdrEtd              = rowData[\"toEta\"];\n        // loadlistStatus         = lastStatus; //#1\n        llstatus            = rowData[\"loadlistStatus\"];\n        readOnlyFlg            = flag ;\n        loadListId             = document.getElementById('value[' + selectedIndex + '].loadListId').value;\n        \n        //#1 begin\n        var op  = 'open';\n        var ar  = 'alert required';        \n        var lc  = 'loading complete';\n        var rfi = 'ready for invoice';\n        var wc  = 'work complete';\n        if(llstatus.toLowerCase() == op){\n            loadlistStatus = 0;\n        }else if(llstatus.toLowerCase() == ar){\n            loadlistStatus = 5;\n        }else if(llstatus.toLowerCase() == lc){\n            loadlistStatus = 10;\n        }else if(llstatus.toLowerCase() == rfi){\n            loadlistStatus = 20;\n        }else if(llstatus.toLowerCase() == wc){\n            loadlistStatus = 30;\n        }else{\n            loadlistStatus = null;\n        }\n        //#1 end\n        \n        var fromAta            = rowData[\"fromAta\"].substring(0, 10);\n        \n        var index1 = hdrEta.indexOf(\":\");\n        var index2 = hdrEtd.indexOf(\":\");\n        var index3 = hdrEta.indexOf(\" \");\n        var index4 = hdrEtd.indexOf(\" \");\n        \n        hdrEtaDateTime =  hdrEta;  \n        hdrEtdDateTime = hdrEtd;\n\n        if (etdTmFlag == 'N') {\n            hdrEta = hdrEta.substring(0,index3);\n        }\n        \n        if (etaTmFlag == 'N') {\n            hdrEtd = hdrEtd.substring(0,index4);\n        }\n\n        \n        var urlStr = '".toCharArray();
    __oracle_jsp_text[17] = 
    "?hdrService='\n                      +hdrService+'&hdrVessel='+hdrVessel+'&hdrDirection='+hdrDirection+'&hdrVoyage='\n                      +hdrVoyage+'&hdrPortSeq='+hdrPortSeq+'&hdrTerminal='+hdrTerminal+'&hdrBargeNameVoyage='\n                      +hdrBargeNameVoyage+'&hdrEta='+hdrEta+'&hdrEtd='+hdrEtd+'&loadListStatus='\n                      +loadlistStatus+'&readOnlyFlg='+readOnlyFlg+'&loadListId='+loadListId+'&hdrPort='\n                      +hdrPort+'&hdrEtaTm='+hdrEtaTm+'&hdrEtdTm='+hdrEtdTm+'&hdrEtaDateTime='\n                      +hdrEtaDateTime+'&hdrEtdDateTime='+hdrEtdDateTime+'&fromAta='+fromAta;\n                document.forms[0].action= urlStr;\n                document.forms[0].submit();\n                return false;\n    }\n    \n    function changeViewCombo()\n    {\n    \n        getGridSearchCriteria();\n        document.forms[0].fsc.value  = lastFsc;\n        \n    }\n    \n</SCRIPT>\n\n".toCharArray();
    __oracle_jsp_text[18] = 
    "\n        \n    ".toCharArray();
    __oracle_jsp_text[19] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[20] = 
    "\n    \n    ".toCharArray();
    __oracle_jsp_text[21] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[22] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[23] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[24] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[25] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[26] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[27] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[28] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[29] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[30] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[31] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[32] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[33] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[34] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[35] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[36] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[37] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[38] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[39] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[40] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[41] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[42] = 
    "\n    \n    ".toCharArray();
    __oracle_jsp_text[43] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[44] = 
    "\n    \n    ".toCharArray();
    __oracle_jsp_text[45] = 
    "\n    <div class=\"text_header\"><h2>Search</h2></div>\n    <table class=\"table_search\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n      <tr>\n        <td>Service Group</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[46] = 
    "\n            <input type=\"button\" value=\". . .\" name=\"btnServiceGroupLookup\" class=\"btnbutton\" onclick='return openServiceGroupLookup()'/>\n        </td>\n        <td>Service</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[47] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[48] = 
    "\n            <input type=\"button\" value=\". . .\" name=\"btnServiceLookup\" class=\"btnbutton\" onclick='return openServiceLookup()'/>\n        </td>\n        <td>Port</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[49] = 
    "           \n            ".toCharArray();
    __oracle_jsp_text[50] = 
    "\n            <input type=\"button\" value=\". . .\" name=\"btnPortLookup\" class=\"btnbutton\" onclick='return openPortLookup()'/>\n        </td>\n        <td>FSC</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[51] = 
    "\n            \n        </td>\n                \n      </tr>  \n      <tr>\n        \n        <td>Vessel</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[52] = 
    "\n            <input type=\"button\" value=\". . .\" name=\"btnVesselLookup\" class=\"btnbutton\" onclick='return openVesselLookup()'/>\n        </td>\n        <td>Out Voyage</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[53] = 
    "\n            <input type=\"button\" value=\". . .\" name=\"btnInVoyagelLookup\" class=\"btnbutton\" onclick='return openOutVoyageLookup()'/>\n        </td>\n        <td>Terminal</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[54] = 
    "\n            <input type=\"button\" value=\". . .\" name=\"btnTerminalLookup\" class=\"btnbutton\" onclick='return openTerminalLookup()'/>\n            \n        </td>\n      </tr>\n      <tr>\n        <td width=\"8%\">From ETA</td>\n        <td class=\"whitebg\" width=\"16%\">\n            ".toCharArray();
    __oracle_jsp_text[55] = 
    "\n            <a href=\"#\" onClick=\"showCalendar('forms[0].fromEta', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[56] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\n        </td>\n        <td width=\"7%\">To ETA</td>\n        <td class=\"whitebg\" width=\"15%\">\n            ".toCharArray();
    __oracle_jsp_text[57] = 
    "\n            <a href=\"#\" onClick=\"showCalendar('forms[0].toEta', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[58] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\n        </td>\n        <td width=\"6%\">From ATA</td>\n        <td class=\"whitebg\" width=\"15%\">\n            ".toCharArray();
    __oracle_jsp_text[59] = 
    "\n            <a href=\"#\" onClick=\"showCalendar('forms[0].fromAta', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[60] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\n        </td>\n        <td width=\"4%\">To ATA</td>\n        <td class=\"whitebg\" width=\"15%\">\n            ".toCharArray();
    __oracle_jsp_text[61] = 
    "\n            <a href=\"#\" onClick=\"showCalendar('forms[0].toAta', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[62] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\n        </td>\n      </tr>  \n      <tr height=\"25px\">\n        \n        <td >In</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[63] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[64] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[65] = 
    "\n        </td>\n        <td>Sort Order</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[66] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[67] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[68] = 
    "\n        </td>\n        <td>Status</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[69] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[70] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[71] = 
    "\n         </td>\n        <td>View</td>\n        <td class=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[72] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[73] = 
    "\n            ".toCharArray();
    __oracle_jsp_text[74] = 
    "  \n        </td>\n      </tr>\n    </table>\n    ".toCharArray();
    __oracle_jsp_text[75] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[76] = 
    "\n    <div class=\"buttons_box\">\n        <input type=\"button\" value=\"Create Arrival Bay Plan\" name=\"btnCreateBayPlan\" class=\"event_btnbutton\" onclick='return openCreateArrivalBayPlan()'/>\n        <input type=\"button\" value=\"Save Sett.\" name=\"btnSaveSett\" class=\"event_btnbutton\" onclick='return onSaveSett()'/>\n        <input type=\"button\" value=\"Refresh\" name=\"btnRefresh\" class=\"event_btnbutton\" onclick='return onRefresh()'/>\n        <input type=\"button\" value=\"Reset\" name=\"btnReset\" class=\"event_btnbutton\" onclick='return onResetForm()'/>\n        <input type=\"button\" value=\"Find\" name=\"btnFind\" class=\"event_btnbutton\" onclick='return onSearch()'/>\n    </div>\n    \n    ".toCharArray();
    __oracle_jsp_text[77] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[78] = 
    "\n    \n    <div class=\"text_header\"><h2>Search Result</h2></div>      \n         ".toCharArray();
    __oracle_jsp_text[79] = 
    "\n   \n      </div>\n    \n    ".toCharArray();
    __oracle_jsp_text[80] = 
    "  \n      \n    ".toCharArray();
    __oracle_jsp_text[81] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[82] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[83] = 
    "\n    \n    <div class=\"buttons_box\">\n        <div id=\"editDiv\">\n        <input type=\"button\" value=\"Edit\" name=\"btnEdit\" class=\"event_btnbutton\" onclick='return callLoadListMaintenance()'/>\n        </div>\n    </div>\n    \n    ".toCharArray();
    __oracle_jsp_text[84] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[85] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[86] = 
    "\n".toCharArray();
    __oracle_jsp_text[87] = 
    "\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
