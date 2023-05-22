package _pages._ell;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.ideo.sweetdevria.taglib.alert.AlertTag;
import com.ideo.sweetdevria.taglib.grid.common.BaseColumnHeaderTag;
import com.ideo.sweetdevria.taglib.frame.FrameTag;
import com.niit.control.common.GlobalConstants;
import com.niit.control.web.action.BaseAction;
import com.niit.control.common.ria.grid.common.GridConstants;
import com.niit.control.common.ria.grid.common.PersistGridData;


public class _EllLoadListOverviewGrid extends com.orionserver.http.OrionHttpJspPage {


  // ** Begin Declarations


  // ** End Declarations

  public void _jspService(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException, ServletException {

    response.setContentType( "text/html;charset=UTF-8");
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
    _EllLoadListOverviewGrid page = this;
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
      out.write(__oracle_jsp_text[8]);
      out.write(__oracle_jsp_text[9]);
      out.write(__oracle_jsp_text[10]);
      out.write(__oracle_jsp_text[11]);
       String lstrContextPath = request.getContextPath(); 
      out.write(__oracle_jsp_text[12]);
      {
        com.ideo.sweetdevria.taglib.resourcesImport.ResourcesImportTag __jsp_taghandler_1=(com.ideo.sweetdevria.taglib.resourcesImport.ResourcesImportTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.resourcesImport.ResourcesImportTag.class,"com.ideo.sweetdevria.taglib.resourcesImport.ResourcesImportTag");
        __jsp_taghandler_1.setParent(null);
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[13]);
      out.print(lstrContextPath);
      out.write(__oracle_jsp_text[14]);
      out.print(lstrContextPath);
      out.write(__oracle_jsp_text[15]);
      out.print(lstrContextPath);
      out.write(__oracle_jsp_text[16]);
      out.print(GridConstants.GRID_ID);
      out.write(__oracle_jsp_text[17]);
      {
        org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property value");
        __jsp_taghandler_2.setParent(null);
        __jsp_taghandler_2.setName("fell001");
        __jsp_taghandler_2.setProperty("pageId");
        __jsp_taghandler_2.setValue(OracleJspRuntime.toStr( com.ideo.sweetdevria.page.Page.getPageId(request)));
        __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
        if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,1);
      }
      out.write(__oracle_jsp_text[18]);
      {
        com.ideo.sweetdevria.taglib.grid.grid.GridTag __jsp_taghandler_3=(com.ideo.sweetdevria.taglib.grid.grid.GridTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridTag id height heightHeader heightRow resizable width persistanceClassName frameDisplayed showPropertyButton");
        __jsp_taghandler_3.setParent(null);
        __jsp_taghandler_3.setId(OracleJspRuntime.toStr( GridConstants.GRID_ID));
        __jsp_taghandler_3.setHeight("265px");
        __jsp_taghandler_3.setHeightHeader("31");
        __jsp_taghandler_3.setHeightRow("24");
        __jsp_taghandler_3.setResizable(false);
        __jsp_taghandler_3.setWidth("100%");
        __jsp_taghandler_3.setPersistanceClassName("com.niit.control.common.ria.grid.common.PersistGridData");
        __jsp_taghandler_3.setFrameDisplayed(false);
        __jsp_taghandler_3.setShowPropertyButton(false);
        __jsp_tag_starteval=__jsp_taghandler_3.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_3,__jsp_tag_starteval,out);
          do {
            out.write(__oracle_jsp_text[19]);
            {
              com.ideo.sweetdevria.taglib.grid.grid.GridHeaderTag __jsp_taghandler_4=(com.ideo.sweetdevria.taglib.grid.grid.GridHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridHeaderTag");
              __jsp_taghandler_4.setParent(__jsp_taghandler_3);
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[20]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_5=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_5.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_5.setLabel("Service Group");
                    __jsp_taghandler_5.setWidth("50px");
                    __jsp_taghandler_5.setId("serviceGroup");
                    __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
                    if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,3);
                  }
                  out.write(__oracle_jsp_text[21]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_6=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_6.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_6.setLabel("Service");
                    __jsp_taghandler_6.setWidth("50px");
                    __jsp_taghandler_6.setId("serviceCd");
                    __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
                    if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,3);
                  }
                  out.write(__oracle_jsp_text[22]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_7=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_7.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_7.setLabel("Vessel");
                    __jsp_taghandler_7.setWidth("50px");
                    __jsp_taghandler_7.setId("vessel");
                    __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
                    if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,3);
                  }
                  out.write(__oracle_jsp_text[23]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_8=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_8.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_8.setLabel("Out Voyage");
                    __jsp_taghandler_8.setWidth("50px");
                    __jsp_taghandler_8.setId("outVoyage");
                    __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
                    if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,3);
                  }
                  out.write(__oracle_jsp_text[24]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_9=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_9.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_9.setLabel("Direction");
                    __jsp_taghandler_9.setWidth("50px");
                    __jsp_taghandler_9.setId("direction");
                    __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
                    if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,3);
                  }
                  out.write(__oracle_jsp_text[25]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_10=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_10.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_10.setLabel("Sequence");
                    __jsp_taghandler_10.setWidth("50px");
                    __jsp_taghandler_10.setId("sequence");
                    __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
                    if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,3);
                  }
                  out.write(__oracle_jsp_text[26]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_11=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_11.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_11.setLabel("Port");
                    __jsp_taghandler_11.setWidth("50px");
                    __jsp_taghandler_11.setId("port");
                    __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
                    if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,3);
                  }
                  out.write(__oracle_jsp_text[27]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_12=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_12.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_12.setLabel("Terminal");
                    __jsp_taghandler_12.setWidth("50px");
                    __jsp_taghandler_12.setId("terminal");
                    __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
                    if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,3);
                  }
                  out.write(__oracle_jsp_text[28]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_13=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_13.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_13.setLabel("Barge Name");
                    __jsp_taghandler_13.setWidth("50px");
                    __jsp_taghandler_13.setId("bargeName");
                    __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
                    if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,3);
                  }
                  out.write(__oracle_jsp_text[29]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_14=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_14.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_14.setLabel("Barge Voyage");
                    __jsp_taghandler_14.setWidth("50px");
                    __jsp_taghandler_14.setId("bargeVoyage");
                    __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
                    if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,3);
                  }
                  out.write(__oracle_jsp_text[30]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_15=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_15.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_15.setLabel("From Eta");
                    __jsp_taghandler_15.setWidth("50px");
                    __jsp_taghandler_15.setId("fromEta");
                    __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                    if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,3);
                  }
                  out.write(__oracle_jsp_text[31]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_16=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_16.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_16.setLabel("toEta");
                    __jsp_taghandler_16.setWidth("50px");
                    __jsp_taghandler_16.setId("toEta");
                    __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
                    if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,3);
                  }
                  out.write(__oracle_jsp_text[32]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_17=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_17.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_17.setLabel("From Ata");
                    __jsp_taghandler_17.setWidth("50px");
                    __jsp_taghandler_17.setId("fromAta");
                    __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
                    if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,3);
                  }
                  out.write(__oracle_jsp_text[33]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_18=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_18.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_18.setLabel("To Ata");
                    __jsp_taghandler_18.setWidth("50px");
                    __jsp_taghandler_18.setId("toAta");
                    __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
                    if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,3);
                  }
                  out.write(__oracle_jsp_text[34]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_19=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_19.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_19.setLabel("Dischargelist Status");
                    __jsp_taghandler_19.setWidth("50px");
                    __jsp_taghandler_19.setId("loadlistStatus");
                    __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
                    if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,3);
                  }
                  out.write(__oracle_jsp_text[35]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_20=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_20.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_20.setLabel("Booked No");
                    __jsp_taghandler_20.setWidth("50px");
                    __jsp_taghandler_20.setId("bookedNo");
                    __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
                    if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,3);
                  }
                  out.write(__oracle_jsp_text[36]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_21=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_21.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_21.setLabel("Loaded No");
                    __jsp_taghandler_21.setWidth("50px");
                    __jsp_taghandler_21.setId("loadedNo");
                    __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
                    if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,3);
                  }
                  out.write(__oracle_jsp_text[37]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_22=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_22.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_22.setLabel("Rob No");
                    __jsp_taghandler_22.setWidth("50px");
                    __jsp_taghandler_22.setId("robNo");
                    __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
                    if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,3);
                  }
                  out.write(__oracle_jsp_text[38]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_23=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_23.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_23.setLabel("overld");
                    __jsp_taghandler_23.setWidth("50px");
                    __jsp_taghandler_23.setId("overld");
                    __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
                    if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,3);
                  }
                  out.write(__oracle_jsp_text[39]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_24=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_24.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_24.setLabel("shortld");
                    __jsp_taghandler_24.setWidth("50px");
                    __jsp_taghandler_24.setId("shortld");
                    __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
                    if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,3);
                  }
                  out.write(__oracle_jsp_text[40]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_25=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_25.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_25.setLabel("Issues");
                    __jsp_taghandler_25.setWidth("50px");
                    __jsp_taghandler_25.setId("issues");
                    __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
                    if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,3);
                  }
                  out.write(__oracle_jsp_text[41]);
                } while (__jsp_taghandler_4.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[42]);
            {
              com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag __jsp_taghandler_26=(com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag collection var rowPerPage rowCountVar");
              __jsp_taghandler_26.setParent(__jsp_taghandler_3);
              __jsp_taghandler_26.setCollection((java.util.Collection)oracle.jsp.runtime.OracleJspRuntime.evaluate("${KEY_SCREEN_GRID_DATA}",java.util.Collection.class, __ojsp_varRes,null));
              __jsp_taghandler_26.setVar("dlo");
              __jsp_taghandler_26.setRowPerPage(10);
              __jsp_taghandler_26.setRowCountVar("rowCount");
              __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[43]);
                  {
                    com.ideo.sweetdevria.taglib.grid.common.GridRowTag __jsp_taghandler_27=(com.ideo.sweetdevria.taglib.grid.common.GridRowTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.common.GridRowTag.class,"com.ideo.sweetdevria.taglib.grid.common.GridRowTag id");
                    __jsp_taghandler_27.setParent(__jsp_taghandler_26);
                    __jsp_taghandler_27.setId((java.lang.String) ("row"+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)));
                    __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[44]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_28=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_28.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_28.setId("serviceGroup");
                          __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_28,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.serviceGroup}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_28.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,4);
                        }
                        out.write(__oracle_jsp_text[45]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_29=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_29.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_29.setId("serviceCd");
                          __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_29,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.serviceCd}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_29.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,4);
                        }
                        out.write(__oracle_jsp_text[46]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_30=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_30.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_30.setId("vessel");
                          __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_30,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.vessel}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_30.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,4);
                        }
                        out.write(__oracle_jsp_text[47]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_31=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_31.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_31.setId("outVoyage");
                          __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_31,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.outVoyage}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_31.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,4);
                        }
                        out.write(__oracle_jsp_text[48]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_32=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_32.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_32.setId("direction");
                          __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_32,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.direction}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_32.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,4);
                        }
                        out.write(__oracle_jsp_text[49]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_33=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_33.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_33.setId("sequence");
                          __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_33,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.sequence}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_33.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,4);
                        }
                        out.write(__oracle_jsp_text[50]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_34=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_34.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_34.setId("port");
                          __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_34,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.port}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_34.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,4);
                        }
                        out.write(__oracle_jsp_text[51]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_35=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_35.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_35.setId("terminal");
                          __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_35,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.terminal}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_35.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,4);
                        }
                        out.write(__oracle_jsp_text[52]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_36=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_36.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_36.setId("bargeName");
                          __jsp_tag_starteval=__jsp_taghandler_36.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_36,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.bargeName}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_36.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_36.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_36,4);
                        }
                        out.write(__oracle_jsp_text[53]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_37=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_37.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_37.setId("bargeVoyage");
                          __jsp_tag_starteval=__jsp_taghandler_37.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_37,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.bargeVoyage}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_37.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_37.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_37,4);
                        }
                        out.write(__oracle_jsp_text[54]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_38=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_38.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_38.setId("fromEta");
                          __jsp_tag_starteval=__jsp_taghandler_38.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_38,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.fromEta}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_38.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_38.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_38,4);
                        }
                        out.write(__oracle_jsp_text[55]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_39=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_39.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_39.setId("toEta");
                          __jsp_tag_starteval=__jsp_taghandler_39.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_39,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.toEta}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_39.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_39.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_39,4);
                        }
                        out.write(__oracle_jsp_text[56]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_40=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_40.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_40.setId("fromAta");
                          __jsp_tag_starteval=__jsp_taghandler_40.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_40,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.fromAta}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_40.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_40.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_40,4);
                        }
                        out.write(__oracle_jsp_text[57]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_41=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_41.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_41.setId("toAta");
                          __jsp_tag_starteval=__jsp_taghandler_41.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_41,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.toAta}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_41.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_41.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_41,4);
                        }
                        out.write(__oracle_jsp_text[58]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_42=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_42.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_42.setId("loadlistStatus");
                          __jsp_tag_starteval=__jsp_taghandler_42.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_42,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.loadlistStatus}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_42.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_42.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_42,4);
                        }
                        out.write(__oracle_jsp_text[59]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_43=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_43.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_43.setId("bookedNo");
                          __jsp_tag_starteval=__jsp_taghandler_43.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_43,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.bookedNo}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_43.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_43.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_43,4);
                        }
                        out.write(__oracle_jsp_text[60]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_44=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_44.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_44.setId("loadedNo");
                          __jsp_tag_starteval=__jsp_taghandler_44.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_44,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.loadedNo}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_44.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_44.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_44,4);
                        }
                        out.write(__oracle_jsp_text[61]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_45=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_45.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_45.setId("robNo");
                          __jsp_tag_starteval=__jsp_taghandler_45.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_45,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.robNo}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_45.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_45.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_45,4);
                        }
                        out.write(__oracle_jsp_text[62]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_46=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_46.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_46.setId("overld");
                          __jsp_tag_starteval=__jsp_taghandler_46.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_46,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.overld}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_46.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_46.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_46,4);
                        }
                        out.write(__oracle_jsp_text[63]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_47=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_47.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_47.setId("shortld");
                          __jsp_tag_starteval=__jsp_taghandler_47.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_47,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.shortld}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_47.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_47.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_47,4);
                        }
                        out.write(__oracle_jsp_text[64]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_48=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_48.setParent(__jsp_taghandler_27);
                          __jsp_taghandler_48.setId("issues");
                          __jsp_tag_starteval=__jsp_taghandler_48.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_48,__jsp_tag_starteval,out);
                            do {
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${dlo.issues}",java.lang.String.class, __ojsp_varRes, null));
                            } while (__jsp_taghandler_48.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_48.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_48,4);
                        }
                        out.write(__oracle_jsp_text[65]);
                      } while (__jsp_taghandler_27.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,3);
                  }
                  out.write(__oracle_jsp_text[66]);
                } while (__jsp_taghandler_26.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,2);
            }
            out.write(__oracle_jsp_text[67]);
          } while (__jsp_taghandler_3.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,1);
      }
      out.write(__oracle_jsp_text[68]);
      {
        org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_49=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
        __jsp_taghandler_49.setParent(null);
        __jsp_taghandler_49.setId("rowdata");
        __jsp_taghandler_49.setIndexId("ctr");
        __jsp_taghandler_49.setName("fell001");
        __jsp_taghandler_49.setProperty("values");
        __jsp_taghandler_49.setType("com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListOverviewMod");
        com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListOverviewMod rowdata = null;
        java.lang.Integer ctr = null;
        __jsp_tag_starteval=__jsp_taghandler_49.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_49,__jsp_tag_starteval,out);
          do {
            rowdata = (com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListOverviewMod) pageContext.findAttribute("rowdata");
            ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
            out.write(__oracle_jsp_text[69]);
            out.print( "row" + ctr );
            out.write(__oracle_jsp_text[70]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_50=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_50.setParent(__jsp_taghandler_49);
              __jsp_taghandler_50.setName("fell001");
              __jsp_taghandler_50.setOnclick(OracleJspRuntime.toStr( "highlightRow("+ctr+")"));
              __jsp_taghandler_50.setProperty("radioGroup1");
              __jsp_taghandler_50.setStyleClass("check");
              __jsp_taghandler_50.setValue(OracleJspRuntime.toStr( ctr));
              __jsp_tag_starteval=__jsp_taghandler_50.doStartTag();
              if (__jsp_taghandler_50.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_50,2);
            }
            out.write(__oracle_jsp_text[71]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_51=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_51.setParent(__jsp_taghandler_49);
              __jsp_taghandler_51.setName("fell001");
              __jsp_taghandler_51.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].flag"));
              __jsp_tag_starteval=__jsp_taghandler_51.doStartTag();
              if (__jsp_taghandler_51.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_51,2);
            }
            out.write(__oracle_jsp_text[72]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_52=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_52.setParent(__jsp_taghandler_49);
              __jsp_taghandler_52.setName("fell001");
              __jsp_taghandler_52.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].loadListId"));
              __jsp_tag_starteval=__jsp_taghandler_52.doStartTag();
              if (__jsp_taghandler_52.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_52,2);
            }
            out.write(__oracle_jsp_text[73]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_53=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_53.setParent(__jsp_taghandler_49);
              __jsp_taghandler_53.setName("fell001");
              __jsp_taghandler_53.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].etaTime"));
              __jsp_tag_starteval=__jsp_taghandler_53.doStartTag();
              if (__jsp_taghandler_53.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_53,2);
            }
            out.write(__oracle_jsp_text[74]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_54=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_54.setParent(__jsp_taghandler_49);
              __jsp_taghandler_54.setName("fell001");
              __jsp_taghandler_54.setProperty(OracleJspRuntime.toStr( "value[" + ctr + "].etdTime"));
              __jsp_tag_starteval=__jsp_taghandler_54.doStartTag();
              if (__jsp_taghandler_54.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_54,2);
            }
            out.write(__oracle_jsp_text[75]);
          } while (__jsp_taghandler_49.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_49.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_49,1);
      }
      out.write(__oracle_jsp_text[76]);
      out.write(__oracle_jsp_text[77]);

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
  private static final char __oracle_jsp_text[][]=new char[78][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[10] = 
    "\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[12] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[13] = 
    " \n\n<!-- Link Custom CSS -->\n<!-- Rajeev: Move to file where all CSS Files are added-->\n<link rel=\"stylesheet\" type=\"text/css\" href=\"".toCharArray();
    __oracle_jsp_text[14] = 
    "/css/customizeRiaGrid.css\"></link>\n\n<!-- Link Common Grid JS -->\n<!-- Rajeev: Move to file where all CSS Files are added-->\t\n<!--script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[15] = 
    "/js/riaGridCommon.js\"></script-->\n\n<!-- Link Screen Specific JS -->\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[16] = 
    "/js/EllLoadListOverviewGrid.js\"></script>\n\n<script language=\"JavaScript\">\n\tfunction initialize() \n\t{      \n\t\tmobjGrid            = SweetDevRia.$('".toCharArray();
    __oracle_jsp_text[17] = 
    "');\n\t\tmintTotalRows       = mobjGrid.totalDataNumber;\n\t\tmobjFixedTable      = 'tableFixedColumns';\n\t\treturn false;\n\t}\n</script>\n\n".toCharArray();
    __oracle_jsp_text[18] = 
    "\n\n<!-- Rajeev : Change Table Height as per screen requirement -->\n<div style='height:300px'>\n<table id=\"GridContainer\" border=\"0\" cellspacing=0 cellpadding=0 height=\"100%\" width=\"100%\">\n\n\t<!-- Rajeev : Change TR height as per screen requirement -->\n\t<!-- Row to Store Fixed Table Header and Dynamic Grid -->\n\t<tr height=\"30px\" valign=\"TOP\">\n\t\t\t\n\t\t\t<!-- Start Store Fixed Table Header -->\n\t\t\t<td width=\"5%\">\n\t\t\t\t<div style='height:30px'>\n\t\t\t\t\t<table class=\"header\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n\t\t\t\t\t\t<thead>\n\t\t\t\t\t\t\t<tr height=\"25px\">\n\t\t\t\t\t\t\t\t<th width=\"25px\">Select</th>\n\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t</thead>\n\t\t\t\t\t</table>\n\t\t\t\t</div>\n\t\t\t</td>\n\n\t\t\t<!-- Start to Add Grid Component -->\n\t\t\t<td width=\"95%\" rowspan=\"2\">\n\t\t\t\t<div style='height:270px'>\n                                        \n\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[19] = 
    " \n\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[20] = 
    "\t\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[21] = 
    "\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[22] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[23] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[24] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[25] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[26] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[27] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[28] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[29] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[30] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[31] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[32] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[33] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[34] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[35] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[36] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[37] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[38] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[39] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[40] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[41] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[42] = 
    "\n\t\t\t\t\t\t\n                                        ".toCharArray();
    __oracle_jsp_text[43] = 
    " \n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[44] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[45] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[46] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[47] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[48] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[49] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[50] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[51] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[52] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[53] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[54] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[55] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[56] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[57] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[58] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[59] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[60] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[61] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[62] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[63] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[64] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[65] = 
    "\n  ".toCharArray();
    __oracle_jsp_text[66] = 
    "\t\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[67] = 
    " \n                                          \n\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[68] = 
    "\t\n\t\t\t\t\t\t\n                                        \n\t\t\t\t</div>\t\n\t\t\t</td>\n\t\t\n\t</tr>\t\t\n\n\t<!-- Row to Store Fixed Table Body -->\n\t<tr height=\"250px\" valign=\"top\">\n\n\t\t\t<!-- Start Store Fixed Table Header -->\n\t\t\t<td >\n\t\t\t\t<div id=\"fixedColumns_bodyDiv\" CLASS='clsNoScroll'  style='height:250px;'>\n\t\t\t\t\t<table id=\"tableFixedColumns\" class=\"table_results\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n\t\t\t\t\t\t<tbody>\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[69] = 
    "\n\t\t\t\t\t\t\t\t<tr id='".toCharArray();
    __oracle_jsp_text[70] = 
    "' height=\"20px\">\n\t\t\t\t\t\t\t\t\t<td width=\"25px\" class=\"center\">\n                                                                                ".toCharArray();
    __oracle_jsp_text[71] = 
    "\n                                                                                ".toCharArray();
    __oracle_jsp_text[72] = 
    "\n                                                                                ".toCharArray();
    __oracle_jsp_text[73] = 
    "\n                                                                                ".toCharArray();
    __oracle_jsp_text[74] = 
    "\n                                                                                ".toCharArray();
    __oracle_jsp_text[75] = 
    "\n                                                                        </td>\n\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t</tr>\t\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[76] = 
    " \n\t\t\t\t\t\t</tbody> \n\t\t\t\t\t</table>\n\t\t\t\t</div>\n\t\t\t</td>\n\t</tr>\n\n</table> \n</div>\n".toCharArray();
    __oracle_jsp_text[77] = 
    "\n\n\t<script language=\"JavaScript\">\n\t\tinitialize();\n\t\t\n\t</script>        \n\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
