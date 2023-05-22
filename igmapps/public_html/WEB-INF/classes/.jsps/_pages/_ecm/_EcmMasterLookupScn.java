package _pages._ecm;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;


public class _EcmMasterLookupScn extends com.orionserver.http.OrionHttpJspPage {


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
    _EcmMasterLookupScn page = this;
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
      {
        org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_1=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
        __jsp_taghandler_1.setParent(null);
        __jsp_taghandler_1.setName("fecm002");
        __jsp_taghandler_1.setProperty("screenTitle");
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[6]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[7]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[8]);
      out.print(request.getContextPath());
      out.write(__oracle_jsp_text[9]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[10]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[11]);
      {
        org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_2=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
        __jsp_taghandler_2.setParent(null);
        __jsp_taghandler_2.setName("fecm002");
        __jsp_taghandler_2.setProperty("screenTitle");
        __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
        if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,1);
      }
      out.write(__oracle_jsp_text[12]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[13]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[14]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[15]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[16]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm002search", pageContext));
      out.write(__oracle_jsp_text[17]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm002", pageContext));
      out.write(__oracle_jsp_text[18]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm002search", pageContext));
      out.write(__oracle_jsp_text[19]);
      out.print(com.niit.control.web.JSPUtils.getActionMappingURL("/secm002search", pageContext));
      out.write(__oracle_jsp_text[20]);
      {
        org.apache.struts.taglib.html.FormTag __jsp_taghandler_3=(org.apache.struts.taglib.html.FormTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.FormTag.class,"org.apache.struts.taglib.html.FormTag action method");
        __jsp_taghandler_3.setParent(null);
        __jsp_taghandler_3.setAction("/secm002");
        __jsp_taghandler_3.setMethod("POST");
        __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
        if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
        {
          do {
            out.write(__oracle_jsp_text[21]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_4=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_4.setParent(__jsp_taghandler_3);
              __jsp_taghandler_4.setName("fecm002");
              __jsp_taghandler_4.setProperty("prmFormName");
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[22]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_5=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_5.setParent(__jsp_taghandler_3);
              __jsp_taghandler_5.setName("fecm002");
              __jsp_taghandler_5.setProperty("prmRowId");
              __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
              if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,2);
            }
            out.write(__oracle_jsp_text[23]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_6=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_6.setParent(__jsp_taghandler_3);
              __jsp_taghandler_6.setName("fecm002");
              __jsp_taghandler_6.setProperty("prmMasterId");
              __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
              if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,2);
            }
            out.write(__oracle_jsp_text[24]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_7=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_7.setParent(__jsp_taghandler_3);
              __jsp_taghandler_7.setName("fecm002");
              __jsp_taghandler_7.setProperty("prmValues");
              __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
              if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,2);
            }
            out.write(__oracle_jsp_text[25]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_8=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_8.setParent(__jsp_taghandler_3);
              __jsp_taghandler_8.setName("fecm002");
              __jsp_taghandler_8.setProperty("screenTitle");
              __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
              if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,2);
            }
            out.write(__oracle_jsp_text[26]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_9=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_9.setParent(__jsp_taghandler_3);
              __jsp_taghandler_9.setName("fecm002");
              __jsp_taghandler_9.setProperty("sectionTitle");
              __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
              if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,2);
            }
            out.write(__oracle_jsp_text[27]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_10=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_10.setParent(__jsp_taghandler_3);
              __jsp_taghandler_10.setName("fecm002");
              __jsp_taghandler_10.setProperty("findInCode");
              __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
              if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,2);
            }
            out.write(__oracle_jsp_text[28]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_11=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_11.setParent(__jsp_taghandler_3);
              __jsp_taghandler_11.setName("fecm002");
              __jsp_taghandler_11.setProperty("findInDesc");
              __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
              if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,2);
            }
            out.write(__oracle_jsp_text[29]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_12=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_12.setParent(__jsp_taghandler_3);
              __jsp_taghandler_12.setName("fecm002");
              __jsp_taghandler_12.setProperty("sortByCode");
              __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
              if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,2);
            }
            out.write(__oracle_jsp_text[30]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_13=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_13.setParent(__jsp_taghandler_3);
              __jsp_taghandler_13.setName("fecm002");
              __jsp_taghandler_13.setProperty("sortByDesc");
              __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
              if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,2);
            }
            out.write(__oracle_jsp_text[31]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_14=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_14.setParent(__jsp_taghandler_3);
              __jsp_taghandler_14.setName("fecm002");
              __jsp_taghandler_14.setProperty("colNames");
              __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
              if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,2);
            }
            out.write(__oracle_jsp_text[32]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_15=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_15.setParent(__jsp_taghandler_3);
              __jsp_taghandler_15.setName("fecm002");
              __jsp_taghandler_15.setProperty("noOfColumn");
              __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
              if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,2);
            }
            out.write(__oracle_jsp_text[33]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_16=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_16.setParent(__jsp_taghandler_3);
              __jsp_taghandler_16.setName("fecm002");
              __jsp_taghandler_16.setProperty("preCriteria");
              __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
              if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,2);
            }
            out.write(__oracle_jsp_text[34]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_17=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_17.setParent(__jsp_taghandler_3);
              __jsp_taghandler_17.setName("fecm002");
              __jsp_taghandler_17.setProperty("orderBy");
              __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
              if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,2);
            }
            out.write(__oracle_jsp_text[35]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_18=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_18.setParent(__jsp_taghandler_3);
              __jsp_taghandler_18.setName("fecm002");
              __jsp_taghandler_18.setProperty("ascDesc");
              __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
              if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,2);
            }
            out.write(__oracle_jsp_text[36]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_19=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_19.setParent(__jsp_taghandler_3);
              __jsp_taghandler_19.setName("fecm002");
              __jsp_taghandler_19.setProperty("searchPerformed");
              __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
              if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,2);
            }
            out.write(__oracle_jsp_text[37]);
            {
              org.apache.struts.taglib.bean.DefineTag __jsp_taghandler_20=(org.apache.struts.taglib.bean.DefineTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.DefineTag.class,"org.apache.struts.taglib.bean.DefineTag id name property");
              __jsp_taghandler_20.setParent(__jsp_taghandler_3);
              __jsp_taghandler_20.setId("totalNoOfColumn");
              __jsp_taghandler_20.setName("fecm002");
              __jsp_taghandler_20.setProperty("noOfColumn");
              __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
              if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,2);
            }
            java.lang.Object totalNoOfColumn = null;
            totalNoOfColumn = (java.lang.Object) pageContext.findAttribute("totalNoOfColumn");
            out.write(__oracle_jsp_text[38]);
            
                    int totColumn = Integer.parseInt(totalNoOfColumn.toString())  ;
                    int colWidth = totColumn-2;
                
            out.write(__oracle_jsp_text[39]);
            out.write(__oracle_jsp_text[40]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_21=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property");
              __jsp_taghandler_21.setParent(__jsp_taghandler_3);
              __jsp_taghandler_21.setMaxlength("15");
              __jsp_taghandler_21.setName("fecm002");
              __jsp_taghandler_21.setProperty("findVal");
              __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
              if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,2);
            }
            out.write(__oracle_jsp_text[41]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_22=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property size");
              __jsp_taghandler_22.setParent(__jsp_taghandler_3);
              __jsp_taghandler_22.setName("fecm002");
              __jsp_taghandler_22.setProperty("findIn");
              __jsp_taghandler_22.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_22,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[42]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_23=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_23.setParent(__jsp_taghandler_22);
                    __jsp_taghandler_23.setLabel("name");
                    __jsp_taghandler_23.setName("fecm002");
                    __jsp_taghandler_23.setProperty("findInValues");
                    __jsp_taghandler_23.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
                    if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,3);
                  }
                  out.write(__oracle_jsp_text[43]);
                } while (__jsp_taghandler_22.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,2);
            }
            out.write(__oracle_jsp_text[44]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_24=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property size");
              __jsp_taghandler_24.setParent(__jsp_taghandler_3);
              __jsp_taghandler_24.setName("fecm002");
              __jsp_taghandler_24.setProperty("wildCard");
              __jsp_taghandler_24.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_24,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[45]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_25=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_25.setParent(__jsp_taghandler_24);
                    __jsp_taghandler_25.setLabel("name");
                    __jsp_taghandler_25.setName("fecm002");
                    __jsp_taghandler_25.setProperty("wildCardValues");
                    __jsp_taghandler_25.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
                    if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,3);
                  }
                  out.write(__oracle_jsp_text[46]);
                } while (__jsp_taghandler_24.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,2);
            }
            out.write(__oracle_jsp_text[47]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_26=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property size");
              __jsp_taghandler_26.setParent(__jsp_taghandler_3);
              __jsp_taghandler_26.setName("fecm002");
              __jsp_taghandler_26.setProperty("sortBy");
              __jsp_taghandler_26.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_26,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[48]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_27=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_27.setParent(__jsp_taghandler_26);
                    __jsp_taghandler_27.setLabel("name");
                    __jsp_taghandler_27.setName("fecm002");
                    __jsp_taghandler_27.setProperty("sortByValues");
                    __jsp_taghandler_27.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
                    if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,3);
                  }
                  out.write(__oracle_jsp_text[49]);
                } while (__jsp_taghandler_26.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,2);
            }
            out.write(__oracle_jsp_text[50]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_28=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property size");
              __jsp_taghandler_28.setParent(__jsp_taghandler_3);
              __jsp_taghandler_28.setName("fecm002");
              __jsp_taghandler_28.setProperty("sortIn");
              __jsp_taghandler_28.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_28,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[51]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_29=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_29.setParent(__jsp_taghandler_28);
                    __jsp_taghandler_29.setLabel("name");
                    __jsp_taghandler_29.setName("fecm002");
                    __jsp_taghandler_29.setProperty("sortInValues");
                    __jsp_taghandler_29.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
                    if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,3);
                  }
                  out.write(__oracle_jsp_text[52]);
                } while (__jsp_taghandler_28.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,2);
            }
            out.write(__oracle_jsp_text[53]);
            {
              org.apache.struts.taglib.html.SelectTag __jsp_taghandler_30=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name property size");
              __jsp_taghandler_30.setParent(__jsp_taghandler_3);
              __jsp_taghandler_30.setName("fecm002");
              __jsp_taghandler_30.setProperty("recStatus");
              __jsp_taghandler_30.setSize("1");
              __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_30,__jsp_tag_starteval,out);
                do {
                  out.write(__oracle_jsp_text[54]);
                  {
                    org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_31=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                    __jsp_taghandler_31.setParent(__jsp_taghandler_30);
                    __jsp_taghandler_31.setLabel("name");
                    __jsp_taghandler_31.setName("fecm002");
                    __jsp_taghandler_31.setProperty("recStatusValues");
                    __jsp_taghandler_31.setValue("code");
                    __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
                    if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,3);
                  }
                  out.write(__oracle_jsp_text[55]);
                } while (__jsp_taghandler_30.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,2);
            }
            out.write(__oracle_jsp_text[56]);
            out.write(__oracle_jsp_text[57]);
            out.write(__oracle_jsp_text[58]);
            out.write(__oracle_jsp_text[59]);
            out.write(__oracle_jsp_text[60]);
            {
              org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_32=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
              __jsp_taghandler_32.setParent(__jsp_taghandler_3);
              __jsp_taghandler_32.setName("fecm002");
              __jsp_taghandler_32.setProperty("sectionTitle");
              __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
              if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,2);
            }
            out.write(__oracle_jsp_text[61]);
            {
              org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_33=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
              __jsp_taghandler_33.setParent(__jsp_taghandler_3);
              __jsp_taghandler_33.setId("rowdata");
              __jsp_taghandler_33.setIndexId("ctr");
              __jsp_taghandler_33.setName("fecm002");
              __jsp_taghandler_33.setProperty("columnHeader");
              __jsp_taghandler_33.setType("java.lang.String");
              java.lang.String rowdata = null;
              java.lang.Integer ctr = null;
              __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_33,__jsp_tag_starteval,out);
                do {
                  rowdata = (java.lang.String) pageContext.findAttribute("rowdata");
                  ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
                  out.write(__oracle_jsp_text[62]);
                  
                                              if(ctr == 0){
                                          
                  out.write(__oracle_jsp_text[63]);
                  out.print( ctr );
                  out.write(__oracle_jsp_text[64]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_34=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_34.setParent(__jsp_taghandler_33);
                    __jsp_taghandler_34.setName("fecm002");
                    __jsp_taghandler_34.setProperty(OracleJspRuntime.toStr( "colName["+ctr+"]"));
                    __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
                    if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,3);
                  }
                  out.write(__oracle_jsp_text[65]);
                  
                                              } else if(ctr == 1){
                                          
                  out.write(__oracle_jsp_text[66]);
                  out.print( ctr );
                  out.write(__oracle_jsp_text[67]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_35=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_35.setParent(__jsp_taghandler_33);
                    __jsp_taghandler_35.setName("fecm002");
                    __jsp_taghandler_35.setProperty(OracleJspRuntime.toStr( "colName["+ctr+"]"));
                    __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
                    if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,3);
                  }
                  out.write(__oracle_jsp_text[68]);
                  
                                              }else if (ctr != colWidth+1){
                                          
                  out.write(__oracle_jsp_text[69]);
                  out.print((65/colWidth)+"%");
                  out.write(__oracle_jsp_text[70]);
                  out.print( ctr );
                  out.write(__oracle_jsp_text[71]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_36=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_36.setParent(__jsp_taghandler_33);
                    __jsp_taghandler_36.setName("fecm002");
                    __jsp_taghandler_36.setProperty(OracleJspRuntime.toStr( "colName["+ctr+"]"));
                    __jsp_tag_starteval=__jsp_taghandler_36.doStartTag();
                    if (__jsp_taghandler_36.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_36,3);
                  }
                  out.write(__oracle_jsp_text[72]);
                  
                                              } else {
                                          
                  out.write(__oracle_jsp_text[73]);
                  out.print( ctr );
                  out.write(__oracle_jsp_text[74]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_37=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_37.setParent(__jsp_taghandler_33);
                    __jsp_taghandler_37.setName("fecm002");
                    __jsp_taghandler_37.setProperty(OracleJspRuntime.toStr( "colName["+ctr+"]"));
                    __jsp_tag_starteval=__jsp_taghandler_37.doStartTag();
                    if (__jsp_taghandler_37.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_37,3);
                  }
                  out.write(__oracle_jsp_text[75]);
                  
                                              }
                                          
                  out.write(__oracle_jsp_text[76]);
                } while (__jsp_taghandler_33.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,2);
            }
            out.write(__oracle_jsp_text[77]);
            {
              org.apache.struts.taglib.html.ErrorsTag __jsp_taghandler_38=(org.apache.struts.taglib.html.ErrorsTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.ErrorsTag.class,"org.apache.struts.taglib.html.ErrorsTag");
              __jsp_taghandler_38.setParent(__jsp_taghandler_3);
              __jsp_tag_starteval=__jsp_taghandler_38.doStartTag();
              if (__jsp_taghandler_38.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_38,2);
            }
            out.write(__oracle_jsp_text[78]);
            {
              org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_39=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
              __jsp_taghandler_39.setParent(__jsp_taghandler_3);
              __jsp_taghandler_39.setId("rowdata");
              __jsp_taghandler_39.setIndexId("ctr");
              __jsp_taghandler_39.setName("fecm002");
              __jsp_taghandler_39.setProperty("values");
              __jsp_taghandler_39.setType("com.rclgroup.dolphin.ezl.web.ecm.vo.EcmMasterLookupMod");
              com.rclgroup.dolphin.ezl.web.ecm.vo.EcmMasterLookupMod rowdata = null;
              java.lang.Integer ctr = null;
              __jsp_tag_starteval=__jsp_taghandler_39.doStartTag();
              if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
              {
                out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_39,__jsp_tag_starteval,out);
                do {
                  rowdata = (com.rclgroup.dolphin.ezl.web.ecm.vo.EcmMasterLookupMod) pageContext.findAttribute("rowdata");
                  ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
                  out.write(__oracle_jsp_text[79]);
                  out.print( "row" + ctr );
                  out.write(__oracle_jsp_text[80]);
                  out.print("row" + ctr );
                  out.write(__oracle_jsp_text[81]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_40=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_40.setParent(__jsp_taghandler_39);
                    __jsp_taghandler_40.setName("fecm002");
                    __jsp_taghandler_40.setProperty(OracleJspRuntime.toStr( "value["+ctr+"].srlNo"));
                    __jsp_tag_starteval=__jsp_taghandler_40.doStartTag();
                    if (__jsp_taghandler_40.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_40,3);
                  }
                  out.write(__oracle_jsp_text[82]);
                   for (int i=1; i<=totColumn;i++){
                                                  if(i == 1){ 
                                           
                  out.write(__oracle_jsp_text[83]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_41=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_41.setParent(__jsp_taghandler_39);
                    __jsp_taghandler_41.setName("fecm002");
                    __jsp_taghandler_41.setProperty(OracleJspRuntime.toStr( "value["+ctr+"].col1"));
                    __jsp_tag_starteval=__jsp_taghandler_41.doStartTag();
                    if (__jsp_taghandler_41.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_41,3);
                  }
                  out.write(__oracle_jsp_text[84]);
                       }else if(i == 2){ 
                                           
                  out.write(__oracle_jsp_text[85]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_42=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_42.setParent(__jsp_taghandler_39);
                    __jsp_taghandler_42.setName("fecm002");
                    __jsp_taghandler_42.setProperty(OracleJspRuntime.toStr( "value["+ctr+"].col2"));
                    __jsp_tag_starteval=__jsp_taghandler_42.doStartTag();
                    if (__jsp_taghandler_42.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_42,3);
                  }
                  out.write(__oracle_jsp_text[86]);
                       } else if (i != totColumn) { 
                  out.write(__oracle_jsp_text[87]);
                  out.print((65/colWidth)+"%");
                  out.write(__oracle_jsp_text[88]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_43=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_43.setParent(__jsp_taghandler_39);
                    __jsp_taghandler_43.setName("fecm002");
                    __jsp_taghandler_43.setProperty(OracleJspRuntime.toStr( "value["+ctr+"].col"+i));
                    __jsp_tag_starteval=__jsp_taghandler_43.doStartTag();
                    if (__jsp_taghandler_43.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_43,3);
                  }
                  out.write(__oracle_jsp_text[89]);
                       } else { 
                  out.write(__oracle_jsp_text[90]);
                  {
                    org.apache.struts.taglib.bean.WriteTag __jsp_taghandler_44=(org.apache.struts.taglib.bean.WriteTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.bean.WriteTag.class,"org.apache.struts.taglib.bean.WriteTag name property");
                    __jsp_taghandler_44.setParent(__jsp_taghandler_39);
                    __jsp_taghandler_44.setName("fecm002");
                    __jsp_taghandler_44.setProperty(OracleJspRuntime.toStr( "value["+ctr+"].col"+i));
                    __jsp_tag_starteval=__jsp_taghandler_44.doStartTag();
                    if (__jsp_taghandler_44.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_44,3);
                  }
                  out.write(__oracle_jsp_text[91]);
                    } 
                                             }
                                          
                  out.write(__oracle_jsp_text[92]);
                } while (__jsp_taghandler_39.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
              }
              if (__jsp_taghandler_39.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_39,2);
            }
            out.write(__oracle_jsp_text[93]);
            out.write(__oracle_jsp_text[94]);
            out.write(__oracle_jsp_text[95]);
            {
              String __url=OracleJspRuntime.toStr("../common/tiles/pagination.jsp");
              __url=OracleJspRuntime.genPageUrl(__url,request,response,new String[] {"formName" } ,new String[] {OracleJspRuntime.toStr("fecm002") } );
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[96]);
            out.write(__oracle_jsp_text[97]);
            {
              String __url=OracleJspRuntime.toStr("../common/tiles/footer.jsp");
              __url=OracleJspRuntime.genPageUrl(__url,request,response,new String[] {"formName" } ,new String[] {OracleJspRuntime.toStr("fecm002") } );
              // Include 
              pageContext.include( __url,false);
              if (pageContext.getAttribute(OracleJspRuntime.JSP_REQUEST_REDIRECTED, PageContext.REQUEST_SCOPE) != null) return;
            }

            out.write(__oracle_jsp_text[98]);
          } while (__jsp_taghandler_3.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
        }
        if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,1);
      }
      out.write(__oracle_jsp_text[99]);

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
  private static final char __oracle_jsp_text[][]=new char[100][];
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
    "\n<HEAD>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n<TITLE> ".toCharArray();
    __oracle_jsp_text[6] = 
    "</TITLE>\n\n    <LINK REL=\"stylesheet\" HREF=\"".toCharArray();
    __oracle_jsp_text[7] = 
    "/css/EZL.css\"/>\n    <!--meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\"/--> \n    <STYLE TYPE=\"text/css\">\n         div.search_result{height:100px;}\n         table.table_results tbody{height:100px;}\n    </STYLE>\n    <!--[if IE]>\n        <style type=\"text/css\">\n            div.search_result {\n                position: relative;\n                height: 180px;\n                width: 100%;\n                overflow-y: scroll;\n                overflow-x: hidden;\n            }\n            table.table_results{width:99%}\n           \n            table.table_results thead tr {\n                position: absolute;width:100%;\n                top: expression(this.offsetParent.scrollTop);\n            }\n            table.table_results tbody {\n                height: auto;\n            }\n            /*table.table_results tbody tr td.first_row {\n                padding-top: 24px;}*/}\n             table.header{width:99%; }             \n        </style>\n    <![endif]-->   \n    \n    <script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[8] = 
    "/js/front_messages.js\">\n\tvar contextPath4Date = \"".toCharArray();
    __oracle_jsp_text[9] = 
    "\";\n    </script>\n    <SCRIPT LANGUAGE=\"JavaScript\" SRC=\"".toCharArray();
    __oracle_jsp_text[10] = 
    "/js/validate.js\"></SCRIPT>\t\t\n    <script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[11] = 
    "/js/RutMessageBar.js\"></script>\n    <div class=\"page_title\">\n        <table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n            <tr>\n                <td width=\"40%\" class=\"PageTitle\"><B>".toCharArray();
    __oracle_jsp_text[12] = 
    "</B></td>\n                <td width=\"60%\" class=\"PageTitleRight\">\n                    <table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n                        <tr>\n                            <td width=\"15%\" valign=\"middle\" align=\"right\"><font size=\"1\" face=\"Verdana\" color=\"#FFFFFF\"></font></td>\n                            <td valign=\"middle\" align=\"left\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[13] = 
    "/images/imgDivider.gif\" height=\"20\"></td>\n                            <td width=\"50\" valign=\"middle\" align=\"center\"><a href=\"javascript:openHelp()\"><img border=\"0\" alt=\"Help\" src=\"".toCharArray();
    __oracle_jsp_text[14] = 
    "/images/btnHelp.jpg\" width=\"40\" height=\"16\"></a></td>\n                            <td width=\"6\" valign=\"middle\" align=\"center\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[15] = 
    "/images/imgDivider.gif\" width=\"12\" height=\"20\"></td>\t\t\t\t\t\t\n                            <td width=\"2%\"><a href=\"javascript:window.close()\"><img border=\"0\" src=\"".toCharArray();
    __oracle_jsp_text[16] = 
    "/images/btnClose.gif\" alt=\"Close\" width=\"16\" height=\"16\"></a></td>       \n                        </tr>\n                    </table>                                \n                </td>\n            </tr>\n        </table>\n    </div>\n    \n    <div class=\"page_info\">\n        <span>v1.0&nbsp;&nbsp;</span>\n    </div>\n\n<SCRIPT TYPE=\"text/javascript\" LANGUAGE=\"JavaScript\">\n    var FORM_ID       = 'fecm002';\n    var currselrowid  = 'row0';\n    var lastFindVal   = '';\n    var lastFindIn    = '';\n    var lastWildCard  = '';\n    var lastSortBy    = '';\n    var lastSortIn    = '';\n    var lastRecStatus = '';\n    var lastOrderBy   = '';\n    var lastAscDesc   = '';\n    \n    \n    /*Called by framework on-load of this JSP*/\n    function onLoad() {    \n        lastFindVal   = document.forms[0].findVal.value;\n        lastFindIn    = document.forms[0].findIn.value;\n        lastWildCard  = document.forms[0].wildCard.value;\n        lastSortBy    = document.forms[0].sortBy.value;\n        lastSortIn    = document.forms[0].sortIn.value;\n        lastRecStatus = document.forms[0].recStatus.value;\n        \n        lastOrderBy = document.forms[0].orderBy.value;\n        lastAscDesc = document.forms[0].ascDesc.value;\n        \n        \n        //Focus on Module Combo Box\n        document.forms[0].findVal.focus();        \n    }\n    \n    function openHelp() {\n        \n        var strFileName = '1';\n        var strUrl = \"/RCLWebApp/help/ApplicationHelp.htm#\"+strFileName;\n        var objWindow = window.open(strUrl,\"Help\",\"width=900,height=600,status=no,resizable=no,top=150,left=150\");\n        objWindow.focus();\n    }\n    \n    //Function to highlight the selected row\n    function highlightradioTD(rowid) {\n        rowobj = document.all(rowid);\n        oldrowobj = document.all(currselrowid);\n        if (oldrowobj != null) oldrowobj.style.background = \"#FFFFFF\";\n        if (rowobj != null) {\n            currselrowid = rowid;\n            rowobj.style.background = \"#ADC3E7\";\n        }\n    }\n    \n    /*Called by framework for Pagination*/\n    function getActionUrl(){     \n        resetSearchCriteria();\n        lstrUrl = '".toCharArray();
    __oracle_jsp_text[17] = 
    "';\n        document.forms[0].action=lstrUrl;\n        return lstrUrl;\n    }\n     \n    /*To reset theoriginal search criteria before processing*/\n    function resetSearchCriteria() {\n        document.forms[0].findVal.value   = lastFindVal;\n        document.forms[0].findIn.value    = lastFindIn;\n        document.forms[0].wildCard.value  = lastWildCard;\n        document.forms[0].sortBy.value    = lastSortBy;\n        document.forms[0].sortIn.value    = lastSortIn;\n        document.forms[0].recStatus.value = lastRecStatus;   \n\n        document.forms[0].orderBy.value   = lastOrderBy ;\n        document.forms[0].ascDesc.value   = lastAscDesc ;        \n    }\n    \n    /*Called by framework on reset or refresh for reloading the page*/\n    function onResetForm(){\n        \n        var hdnFormName  = document.forms[0].prmFormName.value;\n        var hdnMasterId  = document.forms[0].prmMasterId.value;\n        var hdnPrmValues = document.forms[0].prmValues.value;\n        \n        var urlString = '".toCharArray();
    __oracle_jsp_text[18] = 
    "';\n        \n        document.forms[0].currPageNo.value= 1;\n        document.forms[0].totRecord.value=0;\n        \n        document.forms[0].action=urlString;        \n        document.forms[0].submit();        \n        return false;\n    }\n    \n    /*Called by Find Button*/\n    function onSearch() {\n\n        \n        var nameFindVal = document.forms[0].findVal.value;\n        var nameFindIn = document.forms[0].findIn.value;\n        \n        //Show error message to the user if he has select only findVal and not find In.\n        if(nameFindVal !=\"\" && nameFindIn == \"\"){\n            showBarMessage(ECM_SE0008, ERROR_MSG);\n            return false;\n        }\n        \n        //Show error message to the user if he has select only findVal and not find In.\n        if(nameFindVal ==\"\" && nameFindIn != \"\"){\n            showBarMessage(ECM_SE0009, ERROR_MSG);\n            return false;\n        }\n        \n        //Clear the Data Table\n        clearDiv('search_result');\n       \n        \n        //set the action\n        document.forms[0].currPageNo.value= 1;\n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[19] = 
    "';\n        \n        document.forms[0].submit();\n        return false;\n    }\n    \n    /*Return the values to the parent window*/\n     function returnValues(rowid){\n        var resultData = new Array();\n        var formName = document.forms[0].prmFormName.value;\n        var pRowId = document.forms[0].prmRowId.value;\n        var masterId = document.forms[0].prmMasterId.value;\n        var totCell = document.all(rowid).cells;\n        \n        for(var i=0; i<totCell.length-1; i++){      \n            resultData[i] = totCell[i+1].firstChild == null ? \" \" : totCell[i+1].firstChild.data;\n        }\n\n        window.opener.setLookupValues(formName, pRowId, masterId,resultData);\n\t    window.close();    \n    }\n    \n    /*Sort the data */\n    function sortData(sortColumn){\n        var strSearchPerformed = document.forms[0].searchPerformed.value ;    \n        if(strSearchPerformed == \"false\") {\n            \n            showBarMessage(ECM_SE0001, ERROR_MSG);\n            return false;\n        }\n        \n        var pColId = document.forms[0].colNames.value.split(\"~\");\n        var pColName = document.forms[0].findInCode.value.split(\"~\");\n\n        document.forms[0].orderBy.value= pColName[sortColumn];\n        if(document.forms[0].orderBy.value == 'undefined'){\n           document.forms[0].orderBy.value = ''; \n        }\n\n        if(document.forms[0].ascDesc.value == ''){\n            document.forms[0].ascDesc.value = \"ASC\";\n            document.forms[0].sortBy.value = pColName[sortColumn];\n            document.forms[0].sortIn.value = \"ASC\";\n        }\n        else if(document.forms[0].ascDesc.value == \"ASC\"){\n            document.forms[0].ascDesc.value = \"DESC\";\n            document.forms[0].sortBy.value = pColName[sortColumn];\n            document.forms[0].sortIn.value = \"DESC\";\n        }\n        else if(document.forms[0].ascDesc.value == \"DESC\"){\n            document.forms[0].ascDesc.value = \"ASC\";\n            document.forms[0].sortBy.value = pColName[sortColumn];\n            document.forms[0].sortIn.value = \"ASC\";\n        }\n        \n        document.forms[0].action='".toCharArray();
    __oracle_jsp_text[20] = 
    "';\n        document.forms[0].submit();\n        return false;\n    }\n    \n</SCRIPT>\n</HEAD>\n<BODY onload='javascript:onLoad()' onunload=\"javascript:doCloseAllChilds()\">\n\n".toCharArray();
    __oracle_jsp_text[21] = 
    "\n\n    ".toCharArray();
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
    "   \n    ".toCharArray();
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
    "\n    <div class=\"text_header\"><h2>Search</h2></div>\n    <TABLE CLASS=\"table_search\" BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"0\" CELLPADDING=\"0\">\n        <TR>\n            <TD>Find</TD>\n            <TD CLASS=\"whitebg\">\n                ".toCharArray();
    __oracle_jsp_text[41] = 
    "\n            </TD>\n            <TD>In</TD>\n            <TD CLASS=\"whitebg\">\n            ".toCharArray();
    __oracle_jsp_text[42] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[43] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[44] = 
    "\n            </TD>\n            <TD >Wild Card</TD>\n            <TD CLASS=\"whitebg\">\n                ".toCharArray();
    __oracle_jsp_text[45] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[46] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[47] = 
    "\n            </TD>\n        </TR>\n    \n        <TR>\n            <TD>Sort By</TD>\n            <TD CLASS=\"whitebg\">\n               ".toCharArray();
    __oracle_jsp_text[48] = 
    "\n                   ".toCharArray();
    __oracle_jsp_text[49] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[50] = 
    "\n            </TD>\n            <TD>In</TD>\n            <TD CLASS=\"whitebg\">\n                ".toCharArray();
    __oracle_jsp_text[51] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[52] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[53] = 
    "\n            </TD>\n            <TD>Status</TD>\n            <TD CLASS=\"whitebg\">\n                ".toCharArray();
    __oracle_jsp_text[54] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[55] = 
    "\n                ".toCharArray();
    __oracle_jsp_text[56] = 
    "\n            </TD>\n        </TR>\n    </TABLE>\n    ".toCharArray();
    __oracle_jsp_text[57] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[58] = 
    "    \n    <DIV CLASS=\"buttons_box\">\n        <INPUT TYPE=\"button\" VALUE=\"Reset\" NAME=\"btnReset\" CLASS=\"event_btnbutton\" ONCLICK='return onResetForm()'/>\n        <INPUT TYPE=\"button\" VALUE=\"Find\" NAME=\"btnFind\" CLASS=\"event_btnbutton\" ONCLICK='return onSearch()'/>\n    </DIV>\n    ".toCharArray();
    __oracle_jsp_text[59] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[60] = 
    "    \n    <DIV CLASS=\"text_header\"><H2>".toCharArray();
    __oracle_jsp_text[61] = 
    "</H2></DIV>   \n        <TABLE ID=\"result_hdr\" CLASS=\"header\" BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"0\" WIDTH=\"100%\" HEIGHT=\"80%\">\n            <THEAD>\n                <TR>\n                    <TH WIDTH='5%'>Seq#</TH>\n                    ".toCharArray();
    __oracle_jsp_text[62] = 
    "\n                        ".toCharArray();
    __oracle_jsp_text[63] = 
    "\n                        <TH WIDTH='10%' ID='".toCharArray();
    __oracle_jsp_text[64] = 
    "' onclick=\"sortData(this.id)\"><a href=\"#\">".toCharArray();
    __oracle_jsp_text[65] = 
    "</a></TH>\n                        ".toCharArray();
    __oracle_jsp_text[66] = 
    "\n                        <TH WIDTH='20%' ID='".toCharArray();
    __oracle_jsp_text[67] = 
    "' onclick=\"sortData(this.id)\"><a href=\"#\">".toCharArray();
    __oracle_jsp_text[68] = 
    "</a></TH>\n                        ".toCharArray();
    __oracle_jsp_text[69] = 
    "\n                        <TH WIDTH='".toCharArray();
    __oracle_jsp_text[70] = 
    "' ID='".toCharArray();
    __oracle_jsp_text[71] = 
    "' onclick=\"sortData(this.id)\" >\n                        <a href=\"#\">".toCharArray();
    __oracle_jsp_text[72] = 
    "</a>\n                        </TH>\n                        ".toCharArray();
    __oracle_jsp_text[73] = 
    "\n                        <TH  ID='".toCharArray();
    __oracle_jsp_text[74] = 
    "' onclick=\"sortData(this.id)\" >\n                        <a href=\"#\">".toCharArray();
    __oracle_jsp_text[75] = 
    "</a>\n                        </TH>\n                        ".toCharArray();
    __oracle_jsp_text[76] = 
    "\n\t\t\t\t\t\t\n                    ".toCharArray();
    __oracle_jsp_text[77] = 
    "\n                </TR>            \n            </THEAD>\n        </TABLE>   \n        \n        <DIV ID=\"search_result\" CLASS=\"search_result\">\n        <!--TABLE BORDER=\"0\" WIDTH=\"100%\" CELLSPACING=\"1\" CELLPADDING=\"4\">\n                       <TR>\n                           <TD ALIGN=\"center\">\n                                    <P>\n                                    <DIV ID='msg'>\n                                    <font color=\"red\">".toCharArray();
    __oracle_jsp_text[78] = 
    "</font>\n                                    </DIV>\n                                </TD>\n                       </TR>\n        </TABLE-->\n        <TABLE ID=\"result_dtl\" CLASS=\"table_results\" BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"0\">\n      \n            <TBODY>\n            \n                ".toCharArray();
    __oracle_jsp_text[79] = 
    "\n                    <TR ID='".toCharArray();
    __oracle_jsp_text[80] = 
    "'  ONCLICK=\"highlightradioTD('".toCharArray();
    __oracle_jsp_text[81] = 
    "')\" ONDBLCLICK=\"returnValues(this.id)\">\n                        <TD WIDTH='5%' class=\"right\">".toCharArray();
    __oracle_jsp_text[82] = 
    "</TD>\n                         ".toCharArray();
    __oracle_jsp_text[83] = 
    "\n                         <TD WIDTH='10%'  >".toCharArray();
    __oracle_jsp_text[84] = 
    "</td>\n                         ".toCharArray();
    __oracle_jsp_text[85] = 
    "\n                         <TD WIDTH='20%'  >".toCharArray();
    __oracle_jsp_text[86] = 
    "</td>\n                         ".toCharArray();
    __oracle_jsp_text[87] = 
    "\n                        <TD WIDTH='".toCharArray();
    __oracle_jsp_text[88] = 
    "'  >".toCharArray();
    __oracle_jsp_text[89] = 
    "</td>\n                         ".toCharArray();
    __oracle_jsp_text[90] = 
    "\n                        <TD  >".toCharArray();
    __oracle_jsp_text[91] = 
    "</td>\n                        ".toCharArray();
    __oracle_jsp_text[92] = 
    "\n\t\t\t\t\t\t\n                    </TR>\n                ".toCharArray();
    __oracle_jsp_text[93] = 
    "\n                <script type=\"text/javascript\">highlightradioTD(\"row0\");</script>\n            </TBODY>\n        </TABLE>\n        </DIV>\n ".toCharArray();
    __oracle_jsp_text[94] = 
    "\n  <div class=\"buttons_box\">\n       \n    </div>\n \n <br>\n ".toCharArray();
    __oracle_jsp_text[95] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[96] = 
    "\n    ".toCharArray();
    __oracle_jsp_text[97] = 
    "\n     ".toCharArray();
    __oracle_jsp_text[98] = 
    "\n  \n".toCharArray();
    __oracle_jsp_text[99] = 
    "\n</BODY>\n</HTML>\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
