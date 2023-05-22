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


public class _EllLoadListMaintenanceBookedTabGrid extends com.orionserver.http.OrionHttpJspPage {


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
    _EllLoadListMaintenanceBookedTabGrid page = this;
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
      out.write(__oracle_jsp_text[12]);
       String lstrContextPath = request.getContextPath(); 
      out.write(__oracle_jsp_text[13]);
      {
        com.ideo.sweetdevria.taglib.resourcesImport.ResourcesImportTag __jsp_taghandler_1=(com.ideo.sweetdevria.taglib.resourcesImport.ResourcesImportTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.resourcesImport.ResourcesImportTag.class,"com.ideo.sweetdevria.taglib.resourcesImport.ResourcesImportTag");
        __jsp_taghandler_1.setParent(null);
        __jsp_tag_starteval=__jsp_taghandler_1.doStartTag();
        if (__jsp_taghandler_1.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_1,1);
      }
      out.write(__oracle_jsp_text[14]);
      out.print(lstrContextPath);
      out.write(__oracle_jsp_text[15]);
      out.print(lstrContextPath);
      out.write(__oracle_jsp_text[16]);
      out.print(lstrContextPath);
      out.write(__oracle_jsp_text[17]);
      out.print(GridConstants.GRID_ID);
      out.write(__oracle_jsp_text[18]);
      {
        org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_2=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property value");
        __jsp_taghandler_2.setParent(null);
        __jsp_taghandler_2.setName("fell002");
        __jsp_taghandler_2.setProperty("pageId");
        __jsp_taghandler_2.setValue(OracleJspRuntime.toStr( com.ideo.sweetdevria.page.Page.getPageId(request)));
        __jsp_tag_starteval=__jsp_taghandler_2.doStartTag();
        if (__jsp_taghandler_2.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_2,1);
      }
      out.write(__oracle_jsp_text[19]);
      {
        com.ideo.sweetdevria.taglib.grid.grid.GridTag __jsp_taghandler_3=(com.ideo.sweetdevria.taglib.grid.grid.GridTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridTag id height heightHeader heightRow resizable width persistanceClassName frameDisplayed showPropertyButton");
        __jsp_taghandler_3.setParent(null);
        __jsp_taghandler_3.setId(OracleJspRuntime.toStr( GridConstants.GRID_ID));
        __jsp_taghandler_3.setHeight("287px");
        __jsp_taghandler_3.setHeightHeader("32");
        __jsp_taghandler_3.setHeightRow("31");
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
            out.write(__oracle_jsp_text[20]);
            {
              com.ideo.sweetdevria.taglib.grid.grid.GridHeaderTag __jsp_taghandler_4=(com.ideo.sweetdevria.taglib.grid.grid.GridHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridHeaderTag");
              __jsp_taghandler_4.setParent(__jsp_taghandler_3);
              __jsp_tag_starteval=__jsp_taghandler_4.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[21]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_5=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_5.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_5.setLabel("BL #");
                    __jsp_taghandler_5.setWidth("50px");
                    __jsp_taghandler_5.setId("billNo");
                    __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
                    if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,3);
                  }
                  out.write(__oracle_jsp_text[22]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_6=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_6.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_6.setLabel("Booking No. Source");
                    __jsp_taghandler_6.setWidth("50px");
                    __jsp_taghandler_6.setId("equipmentNoSource");
                    __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
                    if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,3);
                  }
                  out.write(__oracle_jsp_text[23]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_7=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_7.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_7.setLabel("Size");
                    __jsp_taghandler_7.setWidth("50px");
                    __jsp_taghandler_7.setId("size");
                    __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
                    if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,3);
                  }
                  out.write(__oracle_jsp_text[24]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_8=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_8.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_8.setLabel("Equipment Type");
                    __jsp_taghandler_8.setWidth("50px");
                    __jsp_taghandler_8.setId("equipmentType");
                    __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
                    if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,3);
                  }
                  out.write(__oracle_jsp_text[25]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_9=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_9.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_9.setLabel("Full/MT");
                    __jsp_taghandler_9.setWidth("50px");
                    __jsp_taghandler_9.setId("fullMT");
                    __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
                    if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,3);
                  }
                  out.write(__oracle_jsp_text[26]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_10=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_10.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_10.setLabel("Booking Type");
                    __jsp_taghandler_10.setWidth("50px");
                    __jsp_taghandler_10.setId("bookingType");
                    __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
                    if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,3);
                  }
                  out.write(__oracle_jsp_text[27]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_11=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_11.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_11.setLabel("SOC/COC");
                    __jsp_taghandler_11.setWidth("50px");
                    __jsp_taghandler_11.setId("socCoc");
                    __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
                    if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,3);
                  }
                  out.write(__oracle_jsp_text[28]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_12=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_12.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_12.setLabel("Shipment Term");
                    __jsp_taghandler_12.setWidth("50px");
                    __jsp_taghandler_12.setId("shipmentTerm");
                    __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
                    if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,3);
                  }
                  out.write(__oracle_jsp_text[29]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_13=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_13.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_13.setLabel("Shipment Type");
                    __jsp_taghandler_13.setWidth("50px");
                    __jsp_taghandler_13.setId("shipmentType");
                    __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
                    if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,3);
                  }
                  out.write(__oracle_jsp_text[30]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_14=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_14.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_14.setLabel("POL Status");
                    __jsp_taghandler_14.setWidth("50px");
                    __jsp_taghandler_14.setId("polStatus");
                    __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
                    if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,3);
                  }
                  out.write(__oracle_jsp_text[31]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_15=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_15.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_15.setLabel("Local Container Status");
                    __jsp_taghandler_15.setWidth("50px");
                    __jsp_taghandler_15.setId("localContSts");
                    __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                    if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,3);
                  }
                  out.write(__oracle_jsp_text[32]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_16=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_16.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_16.setLabel("Midstream");
                    __jsp_taghandler_16.setWidth("50px");
                    __jsp_taghandler_16.setId("midstream");
                    __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
                    if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,3);
                  }
                  out.write(__oracle_jsp_text[33]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_17=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_17.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_17.setLabel("Load Condition");
                    __jsp_taghandler_17.setWidth("50px");
                    __jsp_taghandler_17.setId("loadCondition");
                    __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
                    if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,3);
                  }
                  out.write(__oracle_jsp_text[34]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_18=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_18.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_18.setLabel("Loading Status");
                    __jsp_taghandler_18.setWidth("50px");
                    __jsp_taghandler_18.setId("loadingStatus");
                    __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
                    if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,3);
                  }
                  out.write(__oracle_jsp_text[35]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_19=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_19.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_19.setLabel("Stow Position");
                    __jsp_taghandler_19.setWidth("50px");
                    __jsp_taghandler_19.setId("stowPosition");
                    __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
                    if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,3);
                  }
                  out.write(__oracle_jsp_text[36]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_20=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_20.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_20.setLabel("Activity Date");
                    __jsp_taghandler_20.setWidth("50px");
                    __jsp_taghandler_20.setId("activityDate");
                    __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
                    if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,3);
                  }
                  out.write(__oracle_jsp_text[37]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_21=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_21.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_21.setLabel("Weight");
                    __jsp_taghandler_21.setWidth("50px");
                    __jsp_taghandler_21.setId("weight");
                    __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
                    if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,3);
                  }
                  out.write(__oracle_jsp_text[38]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_22=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_22.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_22.setLabel("Damaged");
                    __jsp_taghandler_22.setWidth("50px");
                    __jsp_taghandler_22.setId("damaged");
                    __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
                    if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,3);
                  }
                  out.write(__oracle_jsp_text[39]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_23=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_23.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_23.setLabel("Crane Description");
                    __jsp_taghandler_23.setWidth("50px");
                    __jsp_taghandler_23.setId("craneDescription");
                    __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
                    if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,3);
                  }
                  out.write(__oracle_jsp_text[40]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_24=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_24.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_24.setLabel("Void Slot");
                    __jsp_taghandler_24.setWidth("50px");
                    __jsp_taghandler_24.setId("voidSlot");
                    __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
                    if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,3);
                  }
                  out.write(__oracle_jsp_text[41]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_25=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_25.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_25.setLabel("Preadvice");
                    __jsp_taghandler_25.setWidth("50px");
                    __jsp_taghandler_25.setId("preAdvice");
                    __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
                    if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,3);
                  }
                  out.write(__oracle_jsp_text[42]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_26=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_26.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_26.setLabel("Slot Operator");
                    __jsp_taghandler_26.setWidth("50px");
                    __jsp_taghandler_26.setId("slotOperator");
                    __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
                    if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,3);
                  }
                  out.write(__oracle_jsp_text[43]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_27=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_27.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_27.setLabel("Container Operator");
                    __jsp_taghandler_27.setWidth("50px");
                    __jsp_taghandler_27.setId("contOperator");
                    __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
                    if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,3);
                  }
                  out.write(__oracle_jsp_text[44]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_28=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_28.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_28.setLabel("Out Slot Operator");
                    __jsp_taghandler_28.setWidth("50px");
                    __jsp_taghandler_28.setId("outSlotOperator");
                    __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
                    if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,3);
                  }
                  out.write(__oracle_jsp_text[45]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_29=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_29.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_29.setLabel("Special Handling");
                    __jsp_taghandler_29.setWidth("50px");
                    __jsp_taghandler_29.setId("specialHandling");
                    __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
                    if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,3);
                  }
                  out.write(__oracle_jsp_text[46]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_30=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_30.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_30.setLabel("Seal No.");
                    __jsp_taghandler_30.setWidth("50px");
                    __jsp_taghandler_30.setId("sealNo");
                    __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
                    if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,3);
                  }
                  out.write(__oracle_jsp_text[47]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_31=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_31.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_31.setLabel("POD");
                    __jsp_taghandler_31.setWidth("50px");
                    __jsp_taghandler_31.setId("pod");
                    __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
                    if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,3);
                  }
                  out.write(__oracle_jsp_text[48]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_32=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_32.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_32.setLabel("POD Terminal");
                    __jsp_taghandler_32.setWidth("50px");
                    __jsp_taghandler_32.setId("podTerminal");
                    __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
                    if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,3);
                  }
                  out.write(__oracle_jsp_text[49]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_33=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_33.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_33.setLabel("Next POD1");
                    __jsp_taghandler_33.setWidth("50px");
                    __jsp_taghandler_33.setId("nextPOD1");
                    __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
                    if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,3);
                  }
                  out.write(__oracle_jsp_text[50]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_34=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_34.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_34.setLabel("Next POD2");
                    __jsp_taghandler_34.setWidth("50px");
                    __jsp_taghandler_34.setId("nextPOD2");
                    __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
                    if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,3);
                  }
                  out.write(__oracle_jsp_text[51]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_35=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_35.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_35.setLabel("Next POD3");
                    __jsp_taghandler_35.setWidth("50px");
                    __jsp_taghandler_35.setId("nextPOD3");
                    __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
                    if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,3);
                  }
                  out.write(__oracle_jsp_text[52]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_36=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_36.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_36.setLabel("Final POD");
                    __jsp_taghandler_36.setWidth("50px");
                    __jsp_taghandler_36.setId("finalPOD");
                    __jsp_tag_starteval=__jsp_taghandler_36.doStartTag();
                    if (__jsp_taghandler_36.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_36,3);
                  }
                  out.write(__oracle_jsp_text[53]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_37=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_37.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_37.setLabel("Final Destination");
                    __jsp_taghandler_37.setWidth("50px");
                    __jsp_taghandler_37.setId("finalDest");
                    __jsp_tag_starteval=__jsp_taghandler_37.doStartTag();
                    if (__jsp_taghandler_37.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_37,3);
                  }
                  out.write(__oracle_jsp_text[54]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_38=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_38.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_38.setLabel("Next Service");
                    __jsp_taghandler_38.setWidth("50px");
                    __jsp_taghandler_38.setId("nextService");
                    __jsp_tag_starteval=__jsp_taghandler_38.doStartTag();
                    if (__jsp_taghandler_38.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_38,3);
                  }
                  out.write(__oracle_jsp_text[55]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_39=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_39.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_39.setLabel("Next Vessel");
                    __jsp_taghandler_39.setWidth("50px");
                    __jsp_taghandler_39.setId("nextVessel");
                    __jsp_tag_starteval=__jsp_taghandler_39.doStartTag();
                    if (__jsp_taghandler_39.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_39,3);
                  }
                  out.write(__oracle_jsp_text[56]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_40=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_40.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_40.setLabel("Next Voyage");
                    __jsp_taghandler_40.setWidth("50px");
                    __jsp_taghandler_40.setId("nextVoyage");
                    __jsp_tag_starteval=__jsp_taghandler_40.doStartTag();
                    if (__jsp_taghandler_40.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_40,3);
                  }
                  out.write(__oracle_jsp_text[57]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_41=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_41.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_41.setLabel("Next Direction");
                    __jsp_taghandler_41.setWidth("50px");
                    __jsp_taghandler_41.setId("nextDirection");
                    __jsp_tag_starteval=__jsp_taghandler_41.doStartTag();
                    if (__jsp_taghandler_41.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_41,3);
                  }
                  out.write(__oracle_jsp_text[58]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_42=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_42.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_42.setLabel("Connecting MLO Vessel");
                    __jsp_taghandler_42.setWidth("50px");
                    __jsp_taghandler_42.setId("connectingMLOVessel");
                    __jsp_tag_starteval=__jsp_taghandler_42.doStartTag();
                    if (__jsp_taghandler_42.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_42,3);
                  }
                  out.write(__oracle_jsp_text[59]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_43=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_43.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_43.setLabel("Connecting MLO Voyage");
                    __jsp_taghandler_43.setWidth("50px");
                    __jsp_taghandler_43.setId("connectingMLOVoyage");
                    __jsp_tag_starteval=__jsp_taghandler_43.doStartTag();
                    if (__jsp_taghandler_43.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_43,3);
                  }
                  out.write(__oracle_jsp_text[60]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_44=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_44.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_44.setLabel("MLO ETA Date");
                    __jsp_taghandler_44.setWidth("50px");
                    __jsp_taghandler_44.setId("mloETADate");
                    __jsp_tag_starteval=__jsp_taghandler_44.doStartTag();
                    if (__jsp_taghandler_44.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_44,3);
                  }
                  out.write(__oracle_jsp_text[61]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_45=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_45.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_45.setLabel("Connecting MLO POD1");
                    __jsp_taghandler_45.setWidth("50px");
                    __jsp_taghandler_45.setId("connectingMLOPOD1");
                    __jsp_tag_starteval=__jsp_taghandler_45.doStartTag();
                    if (__jsp_taghandler_45.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_45,3);
                  }
                  out.write(__oracle_jsp_text[62]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_46=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_46.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_46.setLabel("Connecting MLO POD2");
                    __jsp_taghandler_46.setWidth("50px");
                    __jsp_taghandler_46.setId("connectingMLOPOD2");
                    __jsp_tag_starteval=__jsp_taghandler_46.doStartTag();
                    if (__jsp_taghandler_46.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_46,3);
                  }
                  out.write(__oracle_jsp_text[63]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_47=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_47.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_47.setLabel("Connecting MLO POD3");
                    __jsp_taghandler_47.setWidth("50px");
                    __jsp_taghandler_47.setId("connectingMLOPOD3");
                    __jsp_tag_starteval=__jsp_taghandler_47.doStartTag();
                    if (__jsp_taghandler_47.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_47,3);
                  }
                  out.write(__oracle_jsp_text[64]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_48=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_48.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_48.setLabel("Place Of Delivery");
                    __jsp_taghandler_48.setWidth("50px");
                    __jsp_taghandler_48.setId("placeOfDel");
                    __jsp_tag_starteval=__jsp_taghandler_48.doStartTag();
                    if (__jsp_taghandler_48.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_48,3);
                  }
                  out.write(__oracle_jsp_text[65]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_49=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_49.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_49.setLabel("Ex MLO Vessel");
                    __jsp_taghandler_49.setWidth("50px");
                    __jsp_taghandler_49.setId("exMLOVessel");
                    __jsp_tag_starteval=__jsp_taghandler_49.doStartTag();
                    if (__jsp_taghandler_49.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_49,3);
                  }
                  out.write(__oracle_jsp_text[66]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_50=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_50.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_50.setLabel("Ex MLO Voyage");
                    __jsp_taghandler_50.setWidth("50px");
                    __jsp_taghandler_50.setId("exMLOVoyage");
                    __jsp_tag_starteval=__jsp_taghandler_50.doStartTag();
                    if (__jsp_taghandler_50.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_50,3);
                  }
                  out.write(__oracle_jsp_text[67]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_51=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_51.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_51.setLabel("Ex MLO Vessel ETA");
                    __jsp_taghandler_51.setWidth("50px");
                    __jsp_taghandler_51.setId("exMloETADate");
                    __jsp_tag_starteval=__jsp_taghandler_51.doStartTag();
                    if (__jsp_taghandler_51.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_51,3);
                  }
                  out.write(__oracle_jsp_text[68]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_52=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_52.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_52.setLabel("Handling Instruction 1 Code");
                    __jsp_taghandler_52.setWidth("50px");
                    __jsp_taghandler_52.setId("handlingInstCode1");
                    __jsp_tag_starteval=__jsp_taghandler_52.doStartTag();
                    if (__jsp_taghandler_52.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_52,3);
                  }
                  out.write(__oracle_jsp_text[69]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_53=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_53.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_53.setLabel("Handling Instruction 1 Description");
                    __jsp_taghandler_53.setWidth("50px");
                    __jsp_taghandler_53.setId("handlingInstDesc1");
                    __jsp_tag_starteval=__jsp_taghandler_53.doStartTag();
                    if (__jsp_taghandler_53.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_53,3);
                  }
                  out.write(__oracle_jsp_text[70]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_54=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_54.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_54.setLabel("Handling Instruction 2 Code");
                    __jsp_taghandler_54.setWidth("50px");
                    __jsp_taghandler_54.setId("handlingInstCode2");
                    __jsp_tag_starteval=__jsp_taghandler_54.doStartTag();
                    if (__jsp_taghandler_54.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_54,3);
                  }
                  out.write(__oracle_jsp_text[71]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_55=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_55.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_55.setLabel("Handling Instruction 2 Description");
                    __jsp_taghandler_55.setWidth("50px");
                    __jsp_taghandler_55.setId("handlingInstDesc2");
                    __jsp_tag_starteval=__jsp_taghandler_55.doStartTag();
                    if (__jsp_taghandler_55.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_55,3);
                  }
                  out.write(__oracle_jsp_text[72]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_56=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_56.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_56.setLabel("Handling Instruction 3 Code");
                    __jsp_taghandler_56.setWidth("50px");
                    __jsp_taghandler_56.setId("handlingInstCode3");
                    __jsp_tag_starteval=__jsp_taghandler_56.doStartTag();
                    if (__jsp_taghandler_56.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_56,3);
                  }
                  out.write(__oracle_jsp_text[73]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_57=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_57.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_57.setLabel("Handling Instruction 3 Description");
                    __jsp_taghandler_57.setWidth("50px");
                    __jsp_taghandler_57.setId("handlingInstDesc3");
                    __jsp_tag_starteval=__jsp_taghandler_57.doStartTag();
                    if (__jsp_taghandler_57.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_57,3);
                  }
                  out.write(__oracle_jsp_text[74]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_58=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_58.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_58.setLabel("Container Loading Remark 1");
                    __jsp_taghandler_58.setWidth("50px");
                    __jsp_taghandler_58.setId("contLoadRemark1");
                    __jsp_tag_starteval=__jsp_taghandler_58.doStartTag();
                    if (__jsp_taghandler_58.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_58,3);
                  }
                  out.write(__oracle_jsp_text[75]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_59=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_59.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_59.setLabel("Container Loading Remark 2");
                    __jsp_taghandler_59.setWidth("50px");
                    __jsp_taghandler_59.setId("contLoadRemark2");
                    __jsp_tag_starteval=__jsp_taghandler_59.doStartTag();
                    if (__jsp_taghandler_59.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_59,3);
                  }
                  out.write(__oracle_jsp_text[76]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_60=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_60.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_60.setLabel("Special Cargo");
                    __jsp_taghandler_60.setWidth("50px");
                    __jsp_taghandler_60.setId("specialCargo");
                    __jsp_tag_starteval=__jsp_taghandler_60.doStartTag();
                    if (__jsp_taghandler_60.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_60,3);
                  }
                  out.write(__oracle_jsp_text[77]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_61=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_61.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_61.setLabel("Tight Connection @ POD1");
                    __jsp_taghandler_61.setWidth("50px");
                    __jsp_taghandler_61.setId("tightConnectionPOD1");
                    __jsp_tag_starteval=__jsp_taghandler_61.doStartTag();
                    if (__jsp_taghandler_61.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_61,3);
                  }
                  out.write(__oracle_jsp_text[78]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_62=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_62.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_62.setLabel("Tight Connection @ POD2");
                    __jsp_taghandler_62.setWidth("50px");
                    __jsp_taghandler_62.setId("tightConnectionPOD2");
                    __jsp_tag_starteval=__jsp_taghandler_62.doStartTag();
                    if (__jsp_taghandler_62.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_62,3);
                  }
                  out.write(__oracle_jsp_text[79]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_63=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_63.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_63.setLabel("Tight Connection @ POD3");
                    __jsp_taghandler_63.setWidth("50px");
                    __jsp_taghandler_63.setId("tightConnectionPOD3");
                    __jsp_tag_starteval=__jsp_taghandler_63.doStartTag();
                    if (__jsp_taghandler_63.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_63,3);
                  }
                  out.write(__oracle_jsp_text[80]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_64=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_64.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_64.setLabel("IMDG Class");
                    __jsp_taghandler_64.setWidth("50px");
                    __jsp_taghandler_64.setId("imdgClass");
                    __jsp_tag_starteval=__jsp_taghandler_64.doStartTag();
                    if (__jsp_taghandler_64.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_64,3);
                  }
                  out.write(__oracle_jsp_text[81]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_65=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_65.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_65.setLabel("UN Number");
                    __jsp_taghandler_65.setWidth("50px");
                    __jsp_taghandler_65.setId("unNumber");
                    __jsp_tag_starteval=__jsp_taghandler_65.doStartTag();
                    if (__jsp_taghandler_65.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_65,3);
                  }
                  out.write(__oracle_jsp_text[82]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_66=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_66.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_66.setLabel("UN Number Variant");
                    __jsp_taghandler_66.setWidth("50px");
                    __jsp_taghandler_66.setId("unNumberVariant");
                    __jsp_tag_starteval=__jsp_taghandler_66.doStartTag();
                    if (__jsp_taghandler_66.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_66,3);
                  }
                  out.write(__oracle_jsp_text[83]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_67=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_67.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_67.setLabel("Port Class");
                    __jsp_taghandler_67.setWidth("50px");
                    __jsp_taghandler_67.setId("portClass");
                    __jsp_tag_starteval=__jsp_taghandler_67.doStartTag();
                    if (__jsp_taghandler_67.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_67,3);
                  }
                  out.write(__oracle_jsp_text[84]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_68=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_68.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_68.setLabel("Port Class Type");
                    __jsp_taghandler_68.setWidth("50px");
                    __jsp_taghandler_68.setId("portClassType");
                    __jsp_tag_starteval=__jsp_taghandler_68.doStartTag();
                    if (__jsp_taghandler_68.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_68,3);
                  }
                  out.write(__oracle_jsp_text[85]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_69=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_69.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_69.setLabel("Flash Unit");
                    __jsp_taghandler_69.setWidth("50px");
                    __jsp_taghandler_69.setId("flashUnit");
                    __jsp_tag_starteval=__jsp_taghandler_69.doStartTag();
                    if (__jsp_taghandler_69.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_69,3);
                  }
                  out.write(__oracle_jsp_text[86]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_70=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_70.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_70.setLabel("Flash Point");
                    __jsp_taghandler_70.setWidth("50px");
                    __jsp_taghandler_70.setId("flashPoint");
                    __jsp_tag_starteval=__jsp_taghandler_70.doStartTag();
                    if (__jsp_taghandler_70.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_70,3);
                  }
                  out.write(__oracle_jsp_text[87]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_71=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_71.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_71.setLabel("Fumigation Only");
                    __jsp_taghandler_71.setWidth("50px");
                    __jsp_taghandler_71.setId("fumigationOnly");
                    __jsp_tag_starteval=__jsp_taghandler_71.doStartTag();
                    if (__jsp_taghandler_71.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_71,3);
                  }
                  out.write(__oracle_jsp_text[88]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_72=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_72.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_72.setLabel("Residue");
                    __jsp_taghandler_72.setWidth("50px");
                    __jsp_taghandler_72.setId("residue");
                    __jsp_tag_starteval=__jsp_taghandler_72.doStartTag();
                    if (__jsp_taghandler_72.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_72,3);
                  }
                  out.write(__oracle_jsp_text[89]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_73=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_73.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_73.setLabel("Overheight");
                    __jsp_taghandler_73.setWidth("50px");
                    __jsp_taghandler_73.setId("overheight");
                    __jsp_tag_starteval=__jsp_taghandler_73.doStartTag();
                    if (__jsp_taghandler_73.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_73,3);
                  }
                  out.write(__oracle_jsp_text[90]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_74=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_74.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_74.setLabel("Overwidth Left");
                    __jsp_taghandler_74.setWidth("50px");
                    __jsp_taghandler_74.setId("overwidthLeft");
                    __jsp_tag_starteval=__jsp_taghandler_74.doStartTag();
                    if (__jsp_taghandler_74.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_74,3);
                  }
                  out.write(__oracle_jsp_text[91]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_75=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_75.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_75.setLabel("Overwidth Right");
                    __jsp_taghandler_75.setWidth("50px");
                    __jsp_taghandler_75.setId("overwidthRight");
                    __jsp_tag_starteval=__jsp_taghandler_75.doStartTag();
                    if (__jsp_taghandler_75.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_75,3);
                  }
                  out.write(__oracle_jsp_text[92]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_76=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_76.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_76.setLabel("Overlength Front");
                    __jsp_taghandler_76.setWidth("50px");
                    __jsp_taghandler_76.setId("overlengthFront");
                    __jsp_tag_starteval=__jsp_taghandler_76.doStartTag();
                    if (__jsp_taghandler_76.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_76,3);
                  }
                  out.write(__oracle_jsp_text[93]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_77=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_77.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_77.setLabel("Overlength After");
                    __jsp_taghandler_77.setWidth("50px");
                    __jsp_taghandler_77.setId("overlengthAfter");
                    __jsp_tag_starteval=__jsp_taghandler_77.doStartTag();
                    if (__jsp_taghandler_77.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_77,3);
                  }
                  out.write(__oracle_jsp_text[94]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_78=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_78.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_78.setLabel("Reefer Temperature");
                    __jsp_taghandler_78.setWidth("50px");
                    __jsp_taghandler_78.setId("reeferTemp");
                    __jsp_tag_starteval=__jsp_taghandler_78.doStartTag();
                    if (__jsp_taghandler_78.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_78,3);
                  }
                  out.write(__oracle_jsp_text[95]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_79=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_79.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_79.setLabel("Reefer Temperature Unit");
                    __jsp_taghandler_79.setWidth("50px");
                    __jsp_taghandler_79.setId("reeferTempUnit");
                    __jsp_tag_starteval=__jsp_taghandler_79.doStartTag();
                    if (__jsp_taghandler_79.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_79,3);
                  }
                  out.write(__oracle_jsp_text[96]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_80=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_80.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_80.setLabel("Humidity");
                    __jsp_taghandler_80.setWidth("50px");
                    __jsp_taghandler_80.setId("humidity");
                    __jsp_tag_starteval=__jsp_taghandler_80.doStartTag();
                    if (__jsp_taghandler_80.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_80,3);
                  }
                  out.write(__oracle_jsp_text[97]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_81=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_81.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_81.setLabel("Ventilation");
                    __jsp_taghandler_81.setWidth("50px");
                    __jsp_taghandler_81.setId("ventilation");
                    __jsp_tag_starteval=__jsp_taghandler_81.doStartTag();
                    if (__jsp_taghandler_81.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_81,3);
                  }
                  out.write(__oracle_jsp_text[98]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_82=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_82.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_82.setLabel("Remarks");
                    __jsp_taghandler_82.setWidth("50px");
                    __jsp_taghandler_82.setId("remarks");
                    __jsp_tag_starteval=__jsp_taghandler_82.doStartTag();
                    if (__jsp_taghandler_82.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_82,3);
                  }
                  out.write(__oracle_jsp_text[99]);
                } while (__jsp_taghandler_4.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[100]);
            {
              com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag __jsp_taghandler_83=(com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag collection var rowPerPage rowCountVar");
              __jsp_taghandler_83.setParent(__jsp_taghandler_3);
              __jsp_taghandler_83.setCollection((java.util.Collection)oracle.jsp.runtime.OracleJspRuntime.evaluate("${KEY_SCREEN_GRID_DATA}",java.util.Collection.class, __ojsp_varRes,null));
              __jsp_taghandler_83.setVar("col");
              __jsp_taghandler_83.setRowPerPage(1000);
              __jsp_taghandler_83.setRowCountVar("rowCount");
              __jsp_tag_starteval=__jsp_taghandler_83.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[101]);
                  {
                    com.ideo.sweetdevria.taglib.grid.common.GridRowTag __jsp_taghandler_84=(com.ideo.sweetdevria.taglib.grid.common.GridRowTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.common.GridRowTag.class,"com.ideo.sweetdevria.taglib.grid.common.GridRowTag id");
                    __jsp_taghandler_84.setParent(__jsp_taghandler_83);
                    __jsp_taghandler_84.setId((java.lang.String) ("row"+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)));
                    __jsp_tag_starteval=__jsp_taghandler_84.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[102]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_85=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_85.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_85.setId("billNo");
                          __jsp_tag_starteval=__jsp_taghandler_85.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_85,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[103]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_86=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_86.setParent(__jsp_taghandler_85);
                                __jsp_taghandler_86.setMaxlength("17");
                                __jsp_taghandler_86.setName("fell002");
                                __jsp_taghandler_86.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].billNo"));
                                __jsp_taghandler_86.setReadonly(true);
                                __jsp_taghandler_86.setStyle("width:96%");
                                __jsp_taghandler_86.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_86.doStartTag();
                                if (__jsp_taghandler_86.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_86,5);
                              }
                              out.write(__oracle_jsp_text[104]);
                            } while (__jsp_taghandler_85.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_85.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_85,4);
                        }
                        out.write(__oracle_jsp_text[105]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_87=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_87.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_87.setId("equipmentNoSource");
                          __jsp_tag_starteval=__jsp_taghandler_87.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_87,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[106]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_88=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_88.setParent(__jsp_taghandler_87);
                                __jsp_taghandler_88.setMaxlength("15");
                                __jsp_taghandler_88.setName("fell002");
                                __jsp_taghandler_88.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].equipmentNoSource"));
                                __jsp_taghandler_88.setReadonly(true);
                                __jsp_taghandler_88.setStyle("width:96%");
                                __jsp_taghandler_88.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_88.doStartTag();
                                if (__jsp_taghandler_88.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_88,5);
                              }
                              out.write(__oracle_jsp_text[107]);
                            } while (__jsp_taghandler_87.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_87.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_87,4);
                        }
                        out.write(__oracle_jsp_text[108]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_89=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_89.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_89.setId("size");
                          __jsp_tag_starteval=__jsp_taghandler_89.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_89,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_90=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_90.setParent(__jsp_taghandler_89);
                                __jsp_taghandler_90.setMaxlength("2");
                                __jsp_taghandler_90.setName("fell002");
                                __jsp_taghandler_90.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].size"));
                                __jsp_taghandler_90.setReadonly(true);
                                __jsp_taghandler_90.setStyle("width:96%");
                                __jsp_taghandler_90.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_90.doStartTag();
                                if (__jsp_taghandler_90.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_90,5);
                              }
                            } while (__jsp_taghandler_89.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_89.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_89,4);
                        }
                        out.write(__oracle_jsp_text[109]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_91=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_91.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_91.setId("equipmentType");
                          __jsp_tag_starteval=__jsp_taghandler_91.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_91,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_92=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_92.setParent(__jsp_taghandler_91);
                                __jsp_taghandler_92.setMaxlength("2");
                                __jsp_taghandler_92.setName("fell002");
                                __jsp_taghandler_92.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].equipmentType"));
                                __jsp_taghandler_92.setReadonly(true);
                                __jsp_taghandler_92.setStyle("width:96%");
                                __jsp_taghandler_92.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_92.doStartTag();
                                if (__jsp_taghandler_92.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_92,5);
                              }
                            } while (__jsp_taghandler_91.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_91.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_91,4);
                        }
                        out.write(__oracle_jsp_text[110]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_93=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_93.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_93.setId("fullMT");
                          __jsp_tag_starteval=__jsp_taghandler_93.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_93,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_94=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_94.setParent(__jsp_taghandler_93);
                                __jsp_taghandler_94.setMaxlength("1");
                                __jsp_taghandler_94.setName("fell002");
                                __jsp_taghandler_94.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                __jsp_taghandler_94.setReadonly(true);
                                __jsp_taghandler_94.setStyle("width:96%");
                                __jsp_taghandler_94.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_94.doStartTag();
                                if (__jsp_taghandler_94.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_94,5);
                              }
                            } while (__jsp_taghandler_93.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_93.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_93,4);
                        }
                        out.write(__oracle_jsp_text[111]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_95=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_95.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_95.setId("bookingType");
                          __jsp_tag_starteval=__jsp_taghandler_95.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_95,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_96=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_96.setParent(__jsp_taghandler_95);
                                __jsp_taghandler_96.setMaxlength("2");
                                __jsp_taghandler_96.setName("fell002");
                                __jsp_taghandler_96.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].bookingType"));
                                __jsp_taghandler_96.setReadonly(true);
                                __jsp_taghandler_96.setStyle("width:96%");
                                __jsp_taghandler_96.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_96.doStartTag();
                                if (__jsp_taghandler_96.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_96,5);
                              }
                            } while (__jsp_taghandler_95.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_95.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_95,4);
                        }
                        out.write(__oracle_jsp_text[112]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_97=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_97.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_97.setId("socCoc");
                          __jsp_tag_starteval=__jsp_taghandler_97.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_97,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_98=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_98.setParent(__jsp_taghandler_97);
                                __jsp_taghandler_98.setMaxlength("1");
                                __jsp_taghandler_98.setName("fell002");
                                __jsp_taghandler_98.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_98.setReadonly(true);
                                __jsp_taghandler_98.setStyle("width:96%");
                                __jsp_taghandler_98.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_98.doStartTag();
                                if (__jsp_taghandler_98.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_98,5);
                              }
                            } while (__jsp_taghandler_97.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_97.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_97,4);
                        }
                        out.write(__oracle_jsp_text[113]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_99=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_99.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_99.setId("shipmentTerm");
                          __jsp_tag_starteval=__jsp_taghandler_99.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_99,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_100=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_100.setParent(__jsp_taghandler_99);
                                __jsp_taghandler_100.setMaxlength("4");
                                __jsp_taghandler_100.setName("fell002");
                                __jsp_taghandler_100.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].shipmentTerm"));
                                __jsp_taghandler_100.setReadonly(true);
                                __jsp_taghandler_100.setStyle("width:96%");
                                __jsp_taghandler_100.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_100.doStartTag();
                                if (__jsp_taghandler_100.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_100,5);
                              }
                            } while (__jsp_taghandler_99.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_99.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_99,4);
                        }
                        out.write(__oracle_jsp_text[114]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_101=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_101.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_101.setId("shipmentType");
                          __jsp_tag_starteval=__jsp_taghandler_101.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_101,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_102=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_102.setParent(__jsp_taghandler_101);
                                __jsp_taghandler_102.setMaxlength("3");
                                __jsp_taghandler_102.setName("fell002");
                                __jsp_taghandler_102.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].shipmentType"));
                                __jsp_taghandler_102.setReadonly(true);
                                __jsp_taghandler_102.setStyle("width:96%");
                                __jsp_taghandler_102.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_102.doStartTag();
                                if (__jsp_taghandler_102.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_102,5);
                              }
                            } while (__jsp_taghandler_101.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_101.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_101,4);
                        }
                        out.write(__oracle_jsp_text[115]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_103=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_103.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_103.setId("polStatus");
                          __jsp_tag_starteval=__jsp_taghandler_103.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_103,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_104=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_104.setParent(__jsp_taghandler_103);
                                __jsp_taghandler_104.setMaxlength("1");
                                __jsp_taghandler_104.setName("fell002");
                                __jsp_taghandler_104.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].polStatus"));
                                __jsp_taghandler_104.setReadonly(true);
                                __jsp_taghandler_104.setStyle("width:96%");
                                __jsp_taghandler_104.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_104.doStartTag();
                                if (__jsp_taghandler_104.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_104,5);
                              }
                            } while (__jsp_taghandler_103.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_103.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_103,4);
                        }
                        out.write(__oracle_jsp_text[116]);
                        out.write(__oracle_jsp_text[117]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_105=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_105.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_105.setId("localContSts");
                          __jsp_tag_starteval=__jsp_taghandler_105.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_105,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[118]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_106=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_106.setParent(__jsp_taghandler_105);
                                __jsp_taghandler_106.setMaxlength("10");
                                __jsp_taghandler_106.setName("fell002");
                                __jsp_taghandler_106.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_106.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].localContSts"));
                                __jsp_taghandler_106.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_106.doStartTag();
                                if (__jsp_taghandler_106.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_106,5);
                              }
                              out.write(__oracle_jsp_text[119]);
                              out.write(__oracle_jsp_text[120]);
                            } while (__jsp_taghandler_105.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_105.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_105,4);
                        }
                        out.write(__oracle_jsp_text[121]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_107=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_107.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_107.setId("midstream");
                          __jsp_tag_starteval=__jsp_taghandler_107.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_107,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[122]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_108=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_108.setParent(__jsp_taghandler_107);
                                __jsp_taghandler_108.setName("fell002");
                                __jsp_taghandler_108.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_108.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].midstream"));
                                __jsp_taghandler_108.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_108.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_108,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[123]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_109=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_109.setParent(__jsp_taghandler_108);
                                      __jsp_taghandler_109.setLabel("name");
                                      __jsp_taghandler_109.setName("fell002");
                                      __jsp_taghandler_109.setProperty("midstreamValues");
                                      __jsp_taghandler_109.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_109.doStartTag();
                                      if (__jsp_taghandler_109.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_109,6);
                                    }
                                    out.write(__oracle_jsp_text[124]);
                                  } while (__jsp_taghandler_108.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_108.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_108,5);
                              }
                              out.write(__oracle_jsp_text[125]);
                            } while (__jsp_taghandler_107.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_107.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_107,4);
                        }
                        out.write(__oracle_jsp_text[126]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_110=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_110.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_110.setId("loadCondition");
                          __jsp_tag_starteval=__jsp_taghandler_110.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_110,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[127]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_111=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style styleClass");
                                __jsp_taghandler_111.setParent(__jsp_taghandler_110);
                                __jsp_taghandler_111.setName("fell002");
                                __jsp_taghandler_111.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_111.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].loadCondition"));
                                __jsp_taghandler_111.setStyle("width:96%;height:20px");
                                __jsp_taghandler_111.setStyleClass("must");
                                __jsp_tag_starteval=__jsp_taghandler_111.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_111,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[128]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_112=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_112.setParent(__jsp_taghandler_111);
                                      __jsp_taghandler_112.setLabel("name");
                                      __jsp_taghandler_112.setName("fell002");
                                      __jsp_taghandler_112.setProperty("loadConditionValues");
                                      __jsp_taghandler_112.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_112.doStartTag();
                                      if (__jsp_taghandler_112.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_112,6);
                                    }
                                    out.write(__oracle_jsp_text[129]);
                                  } while (__jsp_taghandler_111.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_111.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_111,5);
                              }
                              out.write(__oracle_jsp_text[130]);
                            } while (__jsp_taghandler_110.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_110.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_110,4);
                        }
                        out.write(__oracle_jsp_text[131]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_113=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_113.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_113.setId("loadingStatus");
                          __jsp_tag_starteval=__jsp_taghandler_113.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_113,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[132]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_114=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style styleClass");
                                __jsp_taghandler_114.setParent(__jsp_taghandler_113);
                                __jsp_taghandler_114.setName("fell002");
                                __jsp_taghandler_114.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_114.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].loadingStatus"));
                                __jsp_taghandler_114.setStyle("width:96%;height:20px");
                                __jsp_taghandler_114.setStyleClass("must");
                                __jsp_tag_starteval=__jsp_taghandler_114.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_114,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[133]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_115=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_115.setParent(__jsp_taghandler_114);
                                      __jsp_taghandler_115.setLabel("name");
                                      __jsp_taghandler_115.setName("fell002");
                                      __jsp_taghandler_115.setProperty("loadingStatusValue");
                                      __jsp_taghandler_115.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_115.doStartTag();
                                      if (__jsp_taghandler_115.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_115,6);
                                    }
                                    out.write(__oracle_jsp_text[134]);
                                    out.write(__oracle_jsp_text[135]);
                                  } while (__jsp_taghandler_114.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_114.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_114,5);
                              }
                              out.write(__oracle_jsp_text[136]);
                            } while (__jsp_taghandler_113.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_113.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_113,4);
                        }
                        out.write(__oracle_jsp_text[137]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_116=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_116.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_116.setId("stowPosition");
                          __jsp_tag_starteval=__jsp_taghandler_116.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_116,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_117=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onchange property style");
                                __jsp_taghandler_117.setParent(__jsp_taghandler_116);
                                __jsp_taghandler_117.setMaxlength("7");
                                __jsp_taghandler_117.setName("fell002");
                                __jsp_taghandler_117.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_117.setOnchange((java.lang.String) ("onChangeStowagePosition("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_117.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].stowPosition"));
                                __jsp_taghandler_117.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_117.doStartTag();
                                if (__jsp_taghandler_117.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_117,5);
                              }
                            } while (__jsp_taghandler_116.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_116.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_116,4);
                        }
                        out.write(__oracle_jsp_text[138]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_118=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_118.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_118.setId("activityDate");
                          __jsp_tag_starteval=__jsp_taghandler_118.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_118,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[139]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_119=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_119.setParent(__jsp_taghandler_118);
                                __jsp_taghandler_119.setMaxlength("16");
                                __jsp_taghandler_119.setName("fell002");
                                __jsp_taghandler_119.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_119.setOnclick("this.select();");
                                __jsp_taghandler_119.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].activityDate"));
                                __jsp_taghandler_119.setStyle("width:60%");
                                __jsp_tag_starteval=__jsp_taghandler_119.doStartTag();
                                if (__jsp_taghandler_119.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_119,5);
                              }
                              out.write(__oracle_jsp_text[140]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[141]);
                              out.print(lstrContextPath);
                              out.write(__oracle_jsp_text[142]);
                            } while (__jsp_taghandler_118.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_118.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_118,4);
                        }
                        out.write(__oracle_jsp_text[143]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_120=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_120.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_120.setId("weight");
                          __jsp_tag_starteval=__jsp_taghandler_120.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_120,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_121=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_121.setParent(__jsp_taghandler_120);
                                __jsp_taghandler_121.setMaxlength("15");
                                __jsp_taghandler_121.setName("fell002");
                                __jsp_taghandler_121.setOnblur((java.lang.String) ("putMask_Number(this, 12, 2);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_121.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_121.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].weight"));
                                __jsp_taghandler_121.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_121.doStartTag();
                                if (__jsp_taghandler_121.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_121,5);
                              }
                            } while (__jsp_taghandler_120.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_120.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_120,4);
                        }
                        out.write(__oracle_jsp_text[144]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_122=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_122.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_122.setId("damaged");
                          __jsp_tag_starteval=__jsp_taghandler_122.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_122,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[145]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_123=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_123.setParent(__jsp_taghandler_122);
                                __jsp_taghandler_123.setName("fell002");
                                __jsp_taghandler_123.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_123.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].damaged"));
                                __jsp_taghandler_123.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_123.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_123,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[146]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_124=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_124.setParent(__jsp_taghandler_123);
                                      __jsp_taghandler_124.setLabel("name");
                                      __jsp_taghandler_124.setName("fell002");
                                      __jsp_taghandler_124.setProperty("damagedValues");
                                      __jsp_taghandler_124.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_124.doStartTag();
                                      if (__jsp_taghandler_124.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_124,6);
                                    }
                                    out.write(__oracle_jsp_text[147]);
                                  } while (__jsp_taghandler_123.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_123.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_123,5);
                              }
                              out.write(__oracle_jsp_text[148]);
                            } while (__jsp_taghandler_122.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_122.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_122,4);
                        }
                        out.write(__oracle_jsp_text[149]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_125=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_125.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_125.setId("craneDescription");
                          __jsp_tag_starteval=__jsp_taghandler_125.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_125,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[150]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_126=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_126.setParent(__jsp_taghandler_125);
                                __jsp_taghandler_126.setName("fell002");
                                __jsp_taghandler_126.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_126.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].craneDescription"));
                                __jsp_taghandler_126.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_126.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_126,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[151]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_127=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_127.setParent(__jsp_taghandler_126);
                                      __jsp_taghandler_127.setLabel("name");
                                      __jsp_taghandler_127.setName("fell002");
                                      __jsp_taghandler_127.setProperty("craneDescriptionValues");
                                      __jsp_taghandler_127.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_127.doStartTag();
                                      if (__jsp_taghandler_127.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_127,6);
                                    }
                                    out.write(__oracle_jsp_text[152]);
                                  } while (__jsp_taghandler_126.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_126.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_126,5);
                              }
                              out.write(__oracle_jsp_text[153]);
                            } while (__jsp_taghandler_125.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_125.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_125,4);
                        }
                        out.write(__oracle_jsp_text[154]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_128=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_128.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_128.setId("voidSlot");
                          __jsp_tag_starteval=__jsp_taghandler_128.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_128,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_129=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_129.setParent(__jsp_taghandler_128);
                                __jsp_taghandler_129.setMaxlength("6");
                                __jsp_taghandler_129.setName("fell002");
                                __jsp_taghandler_129.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].voidSlot"));
                                __jsp_taghandler_129.setReadonly(true);
                                __jsp_taghandler_129.setStyle("width:96%");
                                __jsp_taghandler_129.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_129.doStartTag();
                                if (__jsp_taghandler_129.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_129,5);
                              }
                            } while (__jsp_taghandler_128.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_128.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_128,4);
                        }
                        out.write(__oracle_jsp_text[155]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_130=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_130.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_130.setId("preAdvice");
                          __jsp_tag_starteval=__jsp_taghandler_130.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_130,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_131=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_131.setParent(__jsp_taghandler_130);
                                __jsp_taghandler_131.setMaxlength("3");
                                __jsp_taghandler_131.setName("fell002");
                                __jsp_taghandler_131.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].preAdvice"));
                                __jsp_taghandler_131.setReadonly(true);
                                __jsp_taghandler_131.setStyle("width:96%");
                                __jsp_taghandler_131.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_131.doStartTag();
                                if (__jsp_taghandler_131.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_131,5);
                              }
                            } while (__jsp_taghandler_130.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_130.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_130,4);
                        }
                        out.write(__oracle_jsp_text[156]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_132=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_132.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_132.setId("slotOperator");
                          __jsp_tag_starteval=__jsp_taghandler_132.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_132,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_133=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_133.setParent(__jsp_taghandler_132);
                                __jsp_taghandler_133.setMaxlength("4");
                                __jsp_taghandler_133.setName("fell002");
                                __jsp_taghandler_133.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].slotOperator"));
                                __jsp_taghandler_133.setReadonly(true);
                                __jsp_taghandler_133.setStyle("width:96%");
                                __jsp_taghandler_133.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_133.doStartTag();
                                if (__jsp_taghandler_133.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_133,5);
                              }
                            } while (__jsp_taghandler_132.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_132.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_132,4);
                        }
                        out.write(__oracle_jsp_text[157]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_134=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_134.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_134.setName("fell002");
                          __jsp_taghandler_134.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                          __jsp_taghandler_134.setValue("COC");
                          __jsp_tag_starteval=__jsp_taghandler_134.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[158]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_135=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_135.setParent(__jsp_taghandler_134);
                                __jsp_taghandler_135.setId("contOperator");
                                __jsp_tag_starteval=__jsp_taghandler_135.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_135,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[159]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_136=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                      __jsp_taghandler_136.setParent(__jsp_taghandler_135);
                                      __jsp_taghandler_136.setMaxlength("4");
                                      __jsp_taghandler_136.setName("fell002");
                                      __jsp_taghandler_136.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contOperator"));
                                      __jsp_taghandler_136.setReadonly(true);
                                      __jsp_taghandler_136.setStyle("width:96%");
                                      __jsp_taghandler_136.setStyleClass("non_edit");
                                      __jsp_taghandler_136.setValue("RCL");
                                      __jsp_tag_starteval=__jsp_taghandler_136.doStartTag();
                                      if (__jsp_taghandler_136.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_136,6);
                                    }
                                    out.write(__oracle_jsp_text[160]);
                                  } while (__jsp_taghandler_135.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_135.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_135,5);
                              }
                              out.write(__oracle_jsp_text[161]);
                            } while (__jsp_taghandler_134.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_134.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_134,4);
                        }
                        out.write(__oracle_jsp_text[162]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_137=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_137.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_137.setName("fell002");
                          __jsp_taghandler_137.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                          __jsp_taghandler_137.setValue("COC");
                          __jsp_tag_starteval=__jsp_taghandler_137.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[163]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_138=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_138.setParent(__jsp_taghandler_137);
                                __jsp_taghandler_138.setId("contOperator");
                                __jsp_tag_starteval=__jsp_taghandler_138.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_138,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[164]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_139=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style styleClass");
                                      __jsp_taghandler_139.setParent(__jsp_taghandler_138);
                                      __jsp_taghandler_139.setMaxlength("4");
                                      __jsp_taghandler_139.setName("fell002");
                                      __jsp_taghandler_139.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateOperatorCode1(this, "+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                      __jsp_taghandler_139.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contOperator"));
                                      __jsp_taghandler_139.setStyle("width:75%");
                                      __jsp_taghandler_139.setStyleClass("must");
                                      __jsp_tag_starteval=__jsp_taghandler_139.doStartTag();
                                      if (__jsp_taghandler_139.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_139,6);
                                    }
                                    out.write(__oracle_jsp_text[165]);
                                    out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                    out.write(__oracle_jsp_text[166]);
                                  } while (__jsp_taghandler_138.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_138.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_138,5);
                              }
                              out.write(__oracle_jsp_text[167]);
                            } while (__jsp_taghandler_137.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_137.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_137,4);
                        }
                        out.write(__oracle_jsp_text[168]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_140=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_140.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_140.setId("outSlotOperator");
                          __jsp_tag_starteval=__jsp_taghandler_140.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_140,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[169]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_141=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_141.setParent(__jsp_taghandler_140);
                                __jsp_taghandler_141.setMaxlength("4");
                                __jsp_taghandler_141.setName("fell002");
                                __jsp_taghandler_141.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateOutSlotOperatorCode1(this, "+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_141.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].outSlotOperator"));
                                __jsp_taghandler_141.setStyle("width:75%");
                                __jsp_tag_starteval=__jsp_taghandler_141.doStartTag();
                                if (__jsp_taghandler_141.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_141,5);
                              }
                              out.write(__oracle_jsp_text[170]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[171]);
                            } while (__jsp_taghandler_140.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_140.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_140,4);
                        }
                        out.write(__oracle_jsp_text[172]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_142=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_142.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_142.setId("specialHandling");
                          __jsp_tag_starteval=__jsp_taghandler_142.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_142,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_143=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_143.setParent(__jsp_taghandler_142);
                                __jsp_taghandler_143.setMaxlength("3");
                                __jsp_taghandler_143.setName("fell002");
                                __jsp_taghandler_143.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_143.setReadonly(true);
                                __jsp_taghandler_143.setStyle("width:96%");
                                __jsp_taghandler_143.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_143.doStartTag();
                                if (__jsp_taghandler_143.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_143,5);
                              }
                            } while (__jsp_taghandler_142.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_142.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_142,4);
                        }
                        out.write(__oracle_jsp_text[173]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_144=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_144.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_144.setId("sealNo");
                          __jsp_tag_starteval=__jsp_taghandler_144.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_144,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_145=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_145.setParent(__jsp_taghandler_144);
                                __jsp_taghandler_145.setMaxlength("20");
                                __jsp_taghandler_145.setName("fell002");
                                __jsp_taghandler_145.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_145.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].sealNo"));
                                __jsp_taghandler_145.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_145.doStartTag();
                                if (__jsp_taghandler_145.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_145,5);
                              }
                            } while (__jsp_taghandler_144.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_144.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_144,4);
                        }
                        out.write(__oracle_jsp_text[174]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_146=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_146.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_146.setId("pod");
                          __jsp_tag_starteval=__jsp_taghandler_146.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_146,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_147=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_147.setParent(__jsp_taghandler_146);
                                __jsp_taghandler_147.setMaxlength("5");
                                __jsp_taghandler_147.setName("fell002");
                                __jsp_taghandler_147.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].pod"));
                                __jsp_taghandler_147.setReadonly(true);
                                __jsp_taghandler_147.setStyle("width:96%");
                                __jsp_taghandler_147.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_147.doStartTag();
                                if (__jsp_taghandler_147.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_147,5);
                              }
                            } while (__jsp_taghandler_146.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_146.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_146,4);
                        }
                        out.write(__oracle_jsp_text[175]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_148=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_148.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_148.setId("podTerminal");
                          __jsp_tag_starteval=__jsp_taghandler_148.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_148,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_149=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_149.setParent(__jsp_taghandler_148);
                                __jsp_taghandler_149.setMaxlength("5");
                                __jsp_taghandler_149.setName("fell002");
                                __jsp_taghandler_149.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].podTerminal"));
                                __jsp_taghandler_149.setReadonly(true);
                                __jsp_taghandler_149.setStyle("width:96%");
                                __jsp_taghandler_149.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_149.doStartTag();
                                if (__jsp_taghandler_149.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_149,5);
                              }
                            } while (__jsp_taghandler_148.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_148.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_148,4);
                        }
                        out.write(__oracle_jsp_text[176]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_150=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_150.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_150.setId("nextPOD1");
                          __jsp_tag_starteval=__jsp_taghandler_150.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_150,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_151=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_151.setParent(__jsp_taghandler_150);
                                __jsp_taghandler_151.setMaxlength("5");
                                __jsp_taghandler_151.setName("fell002");
                                __jsp_taghandler_151.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextPOD1"));
                                __jsp_taghandler_151.setReadonly(true);
                                __jsp_taghandler_151.setStyle("width:96%");
                                __jsp_taghandler_151.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_151.doStartTag();
                                if (__jsp_taghandler_151.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_151,5);
                              }
                            } while (__jsp_taghandler_150.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_150.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_150,4);
                        }
                        out.write(__oracle_jsp_text[177]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_152=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_152.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_152.setId("nextPOD2");
                          __jsp_tag_starteval=__jsp_taghandler_152.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_152,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_153=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_153.setParent(__jsp_taghandler_152);
                                __jsp_taghandler_153.setMaxlength("5");
                                __jsp_taghandler_153.setName("fell002");
                                __jsp_taghandler_153.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextPOD2"));
                                __jsp_taghandler_153.setReadonly(true);
                                __jsp_taghandler_153.setStyle("width:96%");
                                __jsp_taghandler_153.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_153.doStartTag();
                                if (__jsp_taghandler_153.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_153,5);
                              }
                            } while (__jsp_taghandler_152.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_152.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_152,4);
                        }
                        out.write(__oracle_jsp_text[178]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_154=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_154.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_154.setId("nextPOD3");
                          __jsp_tag_starteval=__jsp_taghandler_154.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_154,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_155=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_155.setParent(__jsp_taghandler_154);
                                __jsp_taghandler_155.setMaxlength("5");
                                __jsp_taghandler_155.setName("fell002");
                                __jsp_taghandler_155.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextPOD3"));
                                __jsp_taghandler_155.setReadonly(true);
                                __jsp_taghandler_155.setStyle("width:96%");
                                __jsp_taghandler_155.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_155.doStartTag();
                                if (__jsp_taghandler_155.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_155,5);
                              }
                            } while (__jsp_taghandler_154.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_154.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_154,4);
                        }
                        out.write(__oracle_jsp_text[179]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_156=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_156.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_156.setId("finalPOD");
                          __jsp_tag_starteval=__jsp_taghandler_156.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_156,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_157=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_157.setParent(__jsp_taghandler_156);
                                __jsp_taghandler_157.setMaxlength("5");
                                __jsp_taghandler_157.setName("fell002");
                                __jsp_taghandler_157.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].finalPOD"));
                                __jsp_taghandler_157.setReadonly(true);
                                __jsp_taghandler_157.setStyle("width:96%");
                                __jsp_taghandler_157.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_157.doStartTag();
                                if (__jsp_taghandler_157.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_157,5);
                              }
                            } while (__jsp_taghandler_156.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_156.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_156,4);
                        }
                        out.write(__oracle_jsp_text[180]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_158=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_158.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_158.setId("finalDest");
                          __jsp_tag_starteval=__jsp_taghandler_158.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_158,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_159=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_159.setParent(__jsp_taghandler_158);
                                __jsp_taghandler_159.setMaxlength("5");
                                __jsp_taghandler_159.setName("fell002");
                                __jsp_taghandler_159.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].finalDest"));
                                __jsp_taghandler_159.setReadonly(true);
                                __jsp_taghandler_159.setStyle("width:96%");
                                __jsp_taghandler_159.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_159.doStartTag();
                                if (__jsp_taghandler_159.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_159,5);
                              }
                            } while (__jsp_taghandler_158.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_158.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_158,4);
                        }
                        out.write(__oracle_jsp_text[181]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_160=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_160.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_160.setId("nextService");
                          __jsp_tag_starteval=__jsp_taghandler_160.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_160,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_161=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_161.setParent(__jsp_taghandler_160);
                                __jsp_taghandler_161.setMaxlength("5");
                                __jsp_taghandler_161.setName("fell002");
                                __jsp_taghandler_161.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextService"));
                                __jsp_taghandler_161.setReadonly(true);
                                __jsp_taghandler_161.setStyle("width:96%");
                                __jsp_taghandler_161.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_161.doStartTag();
                                if (__jsp_taghandler_161.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_161,5);
                              }
                            } while (__jsp_taghandler_160.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_160.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_160,4);
                        }
                        out.write(__oracle_jsp_text[182]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_162=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_162.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_162.setId("nextVessel");
                          __jsp_tag_starteval=__jsp_taghandler_162.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_162,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_163=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_163.setParent(__jsp_taghandler_162);
                                __jsp_taghandler_163.setMaxlength("25");
                                __jsp_taghandler_163.setName("fell002");
                                __jsp_taghandler_163.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextVessel"));
                                __jsp_taghandler_163.setReadonly(true);
                                __jsp_taghandler_163.setStyle("width:96%");
                                __jsp_taghandler_163.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_163.doStartTag();
                                if (__jsp_taghandler_163.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_163,5);
                              }
                            } while (__jsp_taghandler_162.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_162.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_162,4);
                        }
                        out.write(__oracle_jsp_text[183]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_164=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_164.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_164.setId("nextVoyage");
                          __jsp_tag_starteval=__jsp_taghandler_164.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_164,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_165=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_165.setParent(__jsp_taghandler_164);
                                __jsp_taghandler_165.setMaxlength("10");
                                __jsp_taghandler_165.setName("fell002");
                                __jsp_taghandler_165.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextVoyage"));
                                __jsp_taghandler_165.setReadonly(true);
                                __jsp_taghandler_165.setStyle("width:96%");
                                __jsp_taghandler_165.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_165.doStartTag();
                                if (__jsp_taghandler_165.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_165,5);
                              }
                            } while (__jsp_taghandler_164.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_164.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_164,4);
                        }
                        out.write(__oracle_jsp_text[184]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_166=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_166.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_166.setId("nextDirection");
                          __jsp_tag_starteval=__jsp_taghandler_166.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_166,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_167=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_167.setParent(__jsp_taghandler_166);
                                __jsp_taghandler_167.setMaxlength("2");
                                __jsp_taghandler_167.setName("fell002");
                                __jsp_taghandler_167.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextDirection"));
                                __jsp_taghandler_167.setReadonly(true);
                                __jsp_taghandler_167.setStyle("width:96%");
                                __jsp_taghandler_167.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_167.doStartTag();
                                if (__jsp_taghandler_167.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_167,5);
                              }
                            } while (__jsp_taghandler_166.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_166.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_166,4);
                        }
                        out.write(__oracle_jsp_text[185]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_168=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_168.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_168.setId("connectingMLOVessel");
                          __jsp_tag_starteval=__jsp_taghandler_168.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_168,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[186]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_169=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_169.setParent(__jsp_taghandler_168);
                                __jsp_taghandler_169.setName("fell002");
                                __jsp_taghandler_169.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_169.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_169.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[187]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_170=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_170.setParent(__jsp_taghandler_169);
                                      __jsp_taghandler_170.setName("fell002");
                                      __jsp_taghandler_170.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_170.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_170.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[188]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_171=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_171.setParent(__jsp_taghandler_170);
                                            __jsp_taghandler_171.setMaxlength("35");
                                            __jsp_taghandler_171.setName("fell002");
                                            __jsp_taghandler_171.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_171.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVessel"));
                                            __jsp_taghandler_171.setReadonly(true);
                                            __jsp_taghandler_171.setStyle("width:96%");
                                            __jsp_taghandler_171.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_171.doStartTag();
                                            if (__jsp_taghandler_171.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_171,7);
                                          }
                                          out.write(__oracle_jsp_text[189]);
                                        } while (__jsp_taghandler_170.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_170.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_170,6);
                                    }
                                    out.write(__oracle_jsp_text[190]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_172=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_172.setParent(__jsp_taghandler_169);
                                      __jsp_taghandler_172.setName("fell002");
                                      __jsp_taghandler_172.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_172.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_172.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[191]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_173=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_173.setParent(__jsp_taghandler_172);
                                            __jsp_taghandler_173.setMaxlength("35");
                                            __jsp_taghandler_173.setName("fell002");
                                            __jsp_taghandler_173.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_173.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVessel"));
                                            __jsp_taghandler_173.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_173.doStartTag();
                                            if (__jsp_taghandler_173.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_173,7);
                                          }
                                          out.write(__oracle_jsp_text[192]);
                                        } while (__jsp_taghandler_172.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_172.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_172,6);
                                    }
                                    out.write(__oracle_jsp_text[193]);
                                  } while (__jsp_taghandler_169.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_169.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_169,5);
                              }
                              out.write(__oracle_jsp_text[194]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_174=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_174.setParent(__jsp_taghandler_168);
                                __jsp_taghandler_174.setName("fell002");
                                __jsp_taghandler_174.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_174.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_174.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[195]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_175=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_175.setParent(__jsp_taghandler_174);
                                      __jsp_taghandler_175.setMaxlength("35");
                                      __jsp_taghandler_175.setName("fell002");
                                      __jsp_taghandler_175.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_175.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVessel"));
                                      __jsp_taghandler_175.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_175.doStartTag();
                                      if (__jsp_taghandler_175.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_175,6);
                                    }
                                    out.write(__oracle_jsp_text[196]);
                                  } while (__jsp_taghandler_174.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_174.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_174,5);
                              }
                              out.write(__oracle_jsp_text[197]);
                            } while (__jsp_taghandler_168.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_168.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_168,4);
                        }
                        out.write(__oracle_jsp_text[198]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_176=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_176.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_176.setId("connectingMLOVoyage");
                          __jsp_tag_starteval=__jsp_taghandler_176.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_176,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[199]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_177=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_177.setParent(__jsp_taghandler_176);
                                __jsp_taghandler_177.setName("fell002");
                                __jsp_taghandler_177.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_177.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_177.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[200]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_178=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_178.setParent(__jsp_taghandler_177);
                                      __jsp_taghandler_178.setName("fell002");
                                      __jsp_taghandler_178.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_178.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_178.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[201]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_179=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_179.setParent(__jsp_taghandler_178);
                                            __jsp_taghandler_179.setMaxlength("10");
                                            __jsp_taghandler_179.setName("fell002");
                                            __jsp_taghandler_179.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_179.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVoyage"));
                                            __jsp_taghandler_179.setReadonly(true);
                                            __jsp_taghandler_179.setStyle("width:96%");
                                            __jsp_taghandler_179.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_179.doStartTag();
                                            if (__jsp_taghandler_179.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_179,7);
                                          }
                                          out.write(__oracle_jsp_text[202]);
                                        } while (__jsp_taghandler_178.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_178.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_178,6);
                                    }
                                    out.write(__oracle_jsp_text[203]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_180=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_180.setParent(__jsp_taghandler_177);
                                      __jsp_taghandler_180.setName("fell002");
                                      __jsp_taghandler_180.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_180.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_180.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[204]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_181=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_181.setParent(__jsp_taghandler_180);
                                            __jsp_taghandler_181.setMaxlength("10");
                                            __jsp_taghandler_181.setName("fell002");
                                            __jsp_taghandler_181.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_181.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVoyage"));
                                            __jsp_taghandler_181.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_181.doStartTag();
                                            if (__jsp_taghandler_181.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_181,7);
                                          }
                                          out.write(__oracle_jsp_text[205]);
                                        } while (__jsp_taghandler_180.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_180.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_180,6);
                                    }
                                    out.write(__oracle_jsp_text[206]);
                                  } while (__jsp_taghandler_177.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_177.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_177,5);
                              }
                              out.write(__oracle_jsp_text[207]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_182=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_182.setParent(__jsp_taghandler_176);
                                __jsp_taghandler_182.setName("fell002");
                                __jsp_taghandler_182.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_182.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_182.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[208]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_183=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_183.setParent(__jsp_taghandler_182);
                                      __jsp_taghandler_183.setMaxlength("10");
                                      __jsp_taghandler_183.setName("fell002");
                                      __jsp_taghandler_183.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_183.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVoyage"));
                                      __jsp_taghandler_183.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_183.doStartTag();
                                      if (__jsp_taghandler_183.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_183,6);
                                    }
                                    out.write(__oracle_jsp_text[209]);
                                  } while (__jsp_taghandler_182.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_182.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_182,5);
                              }
                              out.write(__oracle_jsp_text[210]);
                            } while (__jsp_taghandler_176.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_176.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_176,4);
                        }
                        out.write(__oracle_jsp_text[211]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_184=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_184.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_184.setId("mloETADate");
                          __jsp_tag_starteval=__jsp_taghandler_184.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_184,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[212]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_185=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_185.setParent(__jsp_taghandler_184);
                                __jsp_taghandler_185.setName("fell002");
                                __jsp_taghandler_185.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_185.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_185.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[213]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_186=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_186.setParent(__jsp_taghandler_185);
                                      __jsp_taghandler_186.setName("fell002");
                                      __jsp_taghandler_186.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_186.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_186.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[214]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_187=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property readonly style styleClass");
                                            __jsp_taghandler_187.setParent(__jsp_taghandler_186);
                                            __jsp_taghandler_187.setMaxlength("16");
                                            __jsp_taghandler_187.setName("fell002");
                                            __jsp_taghandler_187.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_187.setOnclick("this.select();");
                                            __jsp_taghandler_187.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].mloETADate"));
                                            __jsp_taghandler_187.setReadonly(true);
                                            __jsp_taghandler_187.setStyle("width:60%");
                                            __jsp_taghandler_187.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_187.doStartTag();
                                            if (__jsp_taghandler_187.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_187,7);
                                          }
                                          out.write(__oracle_jsp_text[215]);
                                          out.print(lstrContextPath);
                                          out.write(__oracle_jsp_text[216]);
                                        } while (__jsp_taghandler_186.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_186.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_186,6);
                                    }
                                    out.write(__oracle_jsp_text[217]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_188=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_188.setParent(__jsp_taghandler_185);
                                      __jsp_taghandler_188.setName("fell002");
                                      __jsp_taghandler_188.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_188.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_188.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[218]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_189=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                            __jsp_taghandler_189.setParent(__jsp_taghandler_188);
                                            __jsp_taghandler_189.setMaxlength("16");
                                            __jsp_taghandler_189.setName("fell002");
                                            __jsp_taghandler_189.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_189.setOnclick("this.select();");
                                            __jsp_taghandler_189.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].mloETADate"));
                                            __jsp_taghandler_189.setStyle("width:60%");
                                            __jsp_tag_starteval=__jsp_taghandler_189.doStartTag();
                                            if (__jsp_taghandler_189.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_189,7);
                                          }
                                          out.write(__oracle_jsp_text[219]);
                                          out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                          out.write(__oracle_jsp_text[220]);
                                          out.print(lstrContextPath);
                                          out.write(__oracle_jsp_text[221]);
                                        } while (__jsp_taghandler_188.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_188.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_188,6);
                                    }
                                    out.write(__oracle_jsp_text[222]);
                                  } while (__jsp_taghandler_185.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_185.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_185,5);
                              }
                              out.write(__oracle_jsp_text[223]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_190=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_190.setParent(__jsp_taghandler_184);
                                __jsp_taghandler_190.setName("fell002");
                                __jsp_taghandler_190.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_190.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_190.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[224]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_191=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                      __jsp_taghandler_191.setParent(__jsp_taghandler_190);
                                      __jsp_taghandler_191.setMaxlength("16");
                                      __jsp_taghandler_191.setName("fell002");
                                      __jsp_taghandler_191.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_191.setOnclick("this.select();");
                                      __jsp_taghandler_191.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].mloETADate"));
                                      __jsp_taghandler_191.setStyle("width:60%");
                                      __jsp_tag_starteval=__jsp_taghandler_191.doStartTag();
                                      if (__jsp_taghandler_191.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_191,6);
                                    }
                                    out.write(__oracle_jsp_text[225]);
                                    out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                    out.write(__oracle_jsp_text[226]);
                                    out.print(lstrContextPath);
                                    out.write(__oracle_jsp_text[227]);
                                  } while (__jsp_taghandler_190.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_190.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_190,5);
                              }
                              out.write(__oracle_jsp_text[228]);
                            } while (__jsp_taghandler_184.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_184.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_184,4);
                        }
                        out.write(__oracle_jsp_text[229]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_192=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_192.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_192.setId("connectingMLOPOD1");
                          __jsp_tag_starteval=__jsp_taghandler_192.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_192,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[230]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_193=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_193.setParent(__jsp_taghandler_192);
                                __jsp_taghandler_193.setName("fell002");
                                __jsp_taghandler_193.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_193.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_193.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[231]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_194=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_194.setParent(__jsp_taghandler_193);
                                      __jsp_taghandler_194.setName("fell002");
                                      __jsp_taghandler_194.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_194.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_194.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[232]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_195=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_195.setParent(__jsp_taghandler_194);
                                            __jsp_taghandler_195.setMaxlength("5");
                                            __jsp_taghandler_195.setName("fell002");
                                            __jsp_taghandler_195.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_195.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD1"));
                                            __jsp_taghandler_195.setReadonly(true);
                                            __jsp_taghandler_195.setStyle("width:96%");
                                            __jsp_taghandler_195.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_195.doStartTag();
                                            if (__jsp_taghandler_195.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_195,7);
                                          }
                                          out.write(__oracle_jsp_text[233]);
                                        } while (__jsp_taghandler_194.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_194.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_194,6);
                                    }
                                    out.write(__oracle_jsp_text[234]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_196=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_196.setParent(__jsp_taghandler_193);
                                      __jsp_taghandler_196.setName("fell002");
                                      __jsp_taghandler_196.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_196.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_196.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[235]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_197=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_197.setParent(__jsp_taghandler_196);
                                            __jsp_taghandler_197.setMaxlength("5");
                                            __jsp_taghandler_197.setName("fell002");
                                            __jsp_taghandler_197.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_197.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD1"));
                                            __jsp_taghandler_197.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_197.doStartTag();
                                            if (__jsp_taghandler_197.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_197,7);
                                          }
                                          out.write(__oracle_jsp_text[236]);
                                        } while (__jsp_taghandler_196.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_196.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_196,6);
                                    }
                                    out.write(__oracle_jsp_text[237]);
                                  } while (__jsp_taghandler_193.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_193.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_193,5);
                              }
                              out.write(__oracle_jsp_text[238]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_198=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_198.setParent(__jsp_taghandler_192);
                                __jsp_taghandler_198.setName("fell002");
                                __jsp_taghandler_198.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_198.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_198.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[239]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_199=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_199.setParent(__jsp_taghandler_198);
                                      __jsp_taghandler_199.setMaxlength("5");
                                      __jsp_taghandler_199.setName("fell002");
                                      __jsp_taghandler_199.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_199.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD1"));
                                      __jsp_taghandler_199.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_199.doStartTag();
                                      if (__jsp_taghandler_199.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_199,6);
                                    }
                                    out.write(__oracle_jsp_text[240]);
                                  } while (__jsp_taghandler_198.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_198.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_198,5);
                              }
                              out.write(__oracle_jsp_text[241]);
                            } while (__jsp_taghandler_192.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_192.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_192,4);
                        }
                        out.write(__oracle_jsp_text[242]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_200=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_200.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_200.setId("connectingMLOPOD2");
                          __jsp_tag_starteval=__jsp_taghandler_200.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_200,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[243]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_201=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_201.setParent(__jsp_taghandler_200);
                                __jsp_taghandler_201.setName("fell002");
                                __jsp_taghandler_201.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_201.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_201.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[244]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_202=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_202.setParent(__jsp_taghandler_201);
                                      __jsp_taghandler_202.setName("fell002");
                                      __jsp_taghandler_202.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_202.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_202.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[245]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_203=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_203.setParent(__jsp_taghandler_202);
                                            __jsp_taghandler_203.setMaxlength("5");
                                            __jsp_taghandler_203.setName("fell002");
                                            __jsp_taghandler_203.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_203.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD2"));
                                            __jsp_taghandler_203.setReadonly(true);
                                            __jsp_taghandler_203.setStyle("width:96%");
                                            __jsp_taghandler_203.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_203.doStartTag();
                                            if (__jsp_taghandler_203.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_203,7);
                                          }
                                          out.write(__oracle_jsp_text[246]);
                                        } while (__jsp_taghandler_202.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_202.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_202,6);
                                    }
                                    out.write(__oracle_jsp_text[247]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_204=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_204.setParent(__jsp_taghandler_201);
                                      __jsp_taghandler_204.setName("fell002");
                                      __jsp_taghandler_204.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_204.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_204.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[248]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_205=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_205.setParent(__jsp_taghandler_204);
                                            __jsp_taghandler_205.setMaxlength("5");
                                            __jsp_taghandler_205.setName("fell002");
                                            __jsp_taghandler_205.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_205.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD2"));
                                            __jsp_taghandler_205.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_205.doStartTag();
                                            if (__jsp_taghandler_205.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_205,7);
                                          }
                                          out.write(__oracle_jsp_text[249]);
                                        } while (__jsp_taghandler_204.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_204.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_204,6);
                                    }
                                    out.write(__oracle_jsp_text[250]);
                                  } while (__jsp_taghandler_201.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_201.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_201,5);
                              }
                              out.write(__oracle_jsp_text[251]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_206=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_206.setParent(__jsp_taghandler_200);
                                __jsp_taghandler_206.setName("fell002");
                                __jsp_taghandler_206.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_206.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_206.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[252]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_207=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_207.setParent(__jsp_taghandler_206);
                                      __jsp_taghandler_207.setMaxlength("5");
                                      __jsp_taghandler_207.setName("fell002");
                                      __jsp_taghandler_207.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_207.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD2"));
                                      __jsp_taghandler_207.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_207.doStartTag();
                                      if (__jsp_taghandler_207.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_207,6);
                                    }
                                    out.write(__oracle_jsp_text[253]);
                                  } while (__jsp_taghandler_206.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_206.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_206,5);
                              }
                              out.write(__oracle_jsp_text[254]);
                            } while (__jsp_taghandler_200.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_200.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_200,4);
                        }
                        out.write(__oracle_jsp_text[255]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_208=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_208.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_208.setId("connectingMLOPOD3");
                          __jsp_tag_starteval=__jsp_taghandler_208.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_208,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[256]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_209=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_209.setParent(__jsp_taghandler_208);
                                __jsp_taghandler_209.setName("fell002");
                                __jsp_taghandler_209.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_209.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_209.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[257]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_210=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_210.setParent(__jsp_taghandler_209);
                                      __jsp_taghandler_210.setName("fell002");
                                      __jsp_taghandler_210.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_210.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_210.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[258]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_211=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_211.setParent(__jsp_taghandler_210);
                                            __jsp_taghandler_211.setMaxlength("5");
                                            __jsp_taghandler_211.setName("fell002");
                                            __jsp_taghandler_211.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_211.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD3"));
                                            __jsp_taghandler_211.setReadonly(true);
                                            __jsp_taghandler_211.setStyle("width:96%");
                                            __jsp_taghandler_211.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_211.doStartTag();
                                            if (__jsp_taghandler_211.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_211,7);
                                          }
                                          out.write(__oracle_jsp_text[259]);
                                        } while (__jsp_taghandler_210.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_210.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_210,6);
                                    }
                                    out.write(__oracle_jsp_text[260]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_212=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_212.setParent(__jsp_taghandler_209);
                                      __jsp_taghandler_212.setName("fell002");
                                      __jsp_taghandler_212.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_212.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_212.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[261]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_213=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_213.setParent(__jsp_taghandler_212);
                                            __jsp_taghandler_213.setMaxlength("5");
                                            __jsp_taghandler_213.setName("fell002");
                                            __jsp_taghandler_213.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_213.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD3"));
                                            __jsp_taghandler_213.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_213.doStartTag();
                                            if (__jsp_taghandler_213.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_213,7);
                                          }
                                          out.write(__oracle_jsp_text[262]);
                                        } while (__jsp_taghandler_212.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_212.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_212,6);
                                    }
                                    out.write(__oracle_jsp_text[263]);
                                  } while (__jsp_taghandler_209.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_209.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_209,5);
                              }
                              out.write(__oracle_jsp_text[264]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_214=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_214.setParent(__jsp_taghandler_208);
                                __jsp_taghandler_214.setName("fell002");
                                __jsp_taghandler_214.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_214.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_214.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[265]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_215=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_215.setParent(__jsp_taghandler_214);
                                      __jsp_taghandler_215.setMaxlength("5");
                                      __jsp_taghandler_215.setName("fell002");
                                      __jsp_taghandler_215.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_215.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD3"));
                                      __jsp_taghandler_215.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_215.doStartTag();
                                      if (__jsp_taghandler_215.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_215,6);
                                    }
                                    out.write(__oracle_jsp_text[266]);
                                  } while (__jsp_taghandler_214.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_214.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_214,5);
                              }
                              out.write(__oracle_jsp_text[267]);
                            } while (__jsp_taghandler_208.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_208.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_208,4);
                        }
                        out.write(__oracle_jsp_text[268]);
                        out.write(__oracle_jsp_text[269]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_216=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_216.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_216.setId("placeOfDel");
                          __jsp_tag_starteval=__jsp_taghandler_216.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_216,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[270]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_217=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_217.setParent(__jsp_taghandler_216);
                                __jsp_taghandler_217.setName("fell002");
                                __jsp_taghandler_217.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_217.setValue("SOC");
                                __jsp_tag_starteval=__jsp_taghandler_217.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[271]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_218=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_218.setParent(__jsp_taghandler_217);
                                      __jsp_taghandler_218.setMaxlength("5");
                                      __jsp_taghandler_218.setName("fell002");
                                      __jsp_taghandler_218.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_218.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].placeOfDel"));
                                      __jsp_taghandler_218.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_218.doStartTag();
                                      if (__jsp_taghandler_218.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_218,6);
                                    }
                                    out.write(__oracle_jsp_text[272]);
                                  } while (__jsp_taghandler_217.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_217.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_217,5);
                              }
                              out.write(__oracle_jsp_text[273]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_219=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_219.setParent(__jsp_taghandler_216);
                                __jsp_taghandler_219.setName("fell002");
                                __jsp_taghandler_219.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_219.setValue("SOC");
                                __jsp_tag_starteval=__jsp_taghandler_219.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[274]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_220=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_220.setParent(__jsp_taghandler_219);
                                      __jsp_taghandler_220.setName("fell002");
                                      __jsp_taghandler_220.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_220.setValue("Empty");
                                      __jsp_tag_starteval=__jsp_taghandler_220.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[275]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_221=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_221.setParent(__jsp_taghandler_220);
                                            __jsp_taghandler_221.setMaxlength("5");
                                            __jsp_taghandler_221.setName("fell002");
                                            __jsp_taghandler_221.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_221.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].placeOfDel"));
                                            __jsp_taghandler_221.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_221.doStartTag();
                                            if (__jsp_taghandler_221.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_221,7);
                                          }
                                          out.write(__oracle_jsp_text[276]);
                                        } while (__jsp_taghandler_220.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_220.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_220,6);
                                    }
                                    out.write(__oracle_jsp_text[277]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_222=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_222.setParent(__jsp_taghandler_219);
                                      __jsp_taghandler_222.setName("fell002");
                                      __jsp_taghandler_222.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_222.setValue("Empty");
                                      __jsp_tag_starteval=__jsp_taghandler_222.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[278]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_223=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                            __jsp_taghandler_223.setParent(__jsp_taghandler_222);
                                            __jsp_taghandler_223.setMaxlength("5");
                                            __jsp_taghandler_223.setName("fell002");
                                            __jsp_taghandler_223.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].placeOfDel"));
                                            __jsp_taghandler_223.setReadonly(true);
                                            __jsp_taghandler_223.setStyle("width:96%");
                                            __jsp_taghandler_223.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_223.doStartTag();
                                            if (__jsp_taghandler_223.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_223,7);
                                          }
                                          out.write(__oracle_jsp_text[279]);
                                        } while (__jsp_taghandler_222.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_222.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_222,6);
                                    }
                                    out.write(__oracle_jsp_text[280]);
                                  } while (__jsp_taghandler_219.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_219.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_219,5);
                              }
                              out.write(__oracle_jsp_text[281]);
                            } while (__jsp_taghandler_216.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_216.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_216,4);
                        }
                        out.write(__oracle_jsp_text[282]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_224=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_224.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_224.setId("exMLOVessel");
                          __jsp_tag_starteval=__jsp_taghandler_224.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_224,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_225=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_225.setParent(__jsp_taghandler_224);
                                __jsp_taghandler_225.setMaxlength("5");
                                __jsp_taghandler_225.setName("fell002");
                                __jsp_taghandler_225.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_225.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].exMLOVessel"));
                                __jsp_taghandler_225.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_225.doStartTag();
                                if (__jsp_taghandler_225.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_225,5);
                              }
                            } while (__jsp_taghandler_224.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_224.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_224,4);
                        }
                        out.write(__oracle_jsp_text[283]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_226=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_226.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_226.setId("exMLOVoyage");
                          __jsp_tag_starteval=__jsp_taghandler_226.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_226,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_227=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_227.setParent(__jsp_taghandler_226);
                                __jsp_taghandler_227.setMaxlength("20");
                                __jsp_taghandler_227.setName("fell002");
                                __jsp_taghandler_227.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_227.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].exMLOVoyage"));
                                __jsp_taghandler_227.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_227.doStartTag();
                                if (__jsp_taghandler_227.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_227,5);
                              }
                            } while (__jsp_taghandler_226.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_226.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_226,4);
                        }
                        out.write(__oracle_jsp_text[284]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_228=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_228.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_228.setId("exMloETADate");
                          __jsp_tag_starteval=__jsp_taghandler_228.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_228,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[285]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_229=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_229.setParent(__jsp_taghandler_228);
                                __jsp_taghandler_229.setMaxlength("16");
                                __jsp_taghandler_229.setName("fell002");
                                __jsp_taghandler_229.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_229.setOnclick("this.select();");
                                __jsp_taghandler_229.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].exMloETADate"));
                                __jsp_taghandler_229.setStyle("width:60%");
                                __jsp_tag_starteval=__jsp_taghandler_229.doStartTag();
                                if (__jsp_taghandler_229.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_229,5);
                              }
                              out.write(__oracle_jsp_text[286]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[287]);
                              out.print(lstrContextPath);
                              out.write(__oracle_jsp_text[288]);
                            } while (__jsp_taghandler_228.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_228.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_228,4);
                        }
                        out.write(__oracle_jsp_text[289]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_230=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_230.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_230.setId("handlingInstCode1");
                          __jsp_tag_starteval=__jsp_taghandler_230.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_230,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[290]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_231=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_231.setParent(__jsp_taghandler_230);
                                __jsp_taghandler_231.setMaxlength("3");
                                __jsp_taghandler_231.setName("fell002");
                                __jsp_taghandler_231.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateHandInsCode1(this,1,("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"));"));
                                __jsp_taghandler_231.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstCode1"));
                                __jsp_taghandler_231.setStyle("width:75%");
                                __jsp_tag_starteval=__jsp_taghandler_231.doStartTag();
                                if (__jsp_taghandler_231.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_231,5);
                              }
                              out.write(__oracle_jsp_text[291]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[292]);
                            } while (__jsp_taghandler_230.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_230.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_230,4);
                        }
                        out.write(__oracle_jsp_text[293]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_232=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_232.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_232.setId("handlingInstDesc1");
                          __jsp_tag_starteval=__jsp_taghandler_232.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_232,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_233=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_233.setParent(__jsp_taghandler_232);
                                __jsp_taghandler_233.setMaxlength("60");
                                __jsp_taghandler_233.setName("fell002");
                                __jsp_taghandler_233.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstDesc1"));
                                __jsp_taghandler_233.setReadonly(true);
                                __jsp_taghandler_233.setStyle("width:96%");
                                __jsp_taghandler_233.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_233.doStartTag();
                                if (__jsp_taghandler_233.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_233,5);
                              }
                            } while (__jsp_taghandler_232.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_232.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_232,4);
                        }
                        out.write(__oracle_jsp_text[294]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_234=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_234.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_234.setId("handlingInstCode2");
                          __jsp_tag_starteval=__jsp_taghandler_234.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_234,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[295]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_235=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_235.setParent(__jsp_taghandler_234);
                                __jsp_taghandler_235.setMaxlength("3");
                                __jsp_taghandler_235.setName("fell002");
                                __jsp_taghandler_235.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateHandInsCode1(this,2,("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"));"));
                                __jsp_taghandler_235.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstCode2"));
                                __jsp_taghandler_235.setStyle("width:75%");
                                __jsp_tag_starteval=__jsp_taghandler_235.doStartTag();
                                if (__jsp_taghandler_235.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_235,5);
                              }
                              out.write(__oracle_jsp_text[296]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[297]);
                            } while (__jsp_taghandler_234.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_234.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_234,4);
                        }
                        out.write(__oracle_jsp_text[298]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_236=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_236.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_236.setId("handlingInstDesc2");
                          __jsp_tag_starteval=__jsp_taghandler_236.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_236,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_237=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_237.setParent(__jsp_taghandler_236);
                                __jsp_taghandler_237.setMaxlength("60");
                                __jsp_taghandler_237.setName("fell002");
                                __jsp_taghandler_237.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstDesc2"));
                                __jsp_taghandler_237.setReadonly(true);
                                __jsp_taghandler_237.setStyle("width:96%");
                                __jsp_taghandler_237.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_237.doStartTag();
                                if (__jsp_taghandler_237.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_237,5);
                              }
                            } while (__jsp_taghandler_236.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_236.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_236,4);
                        }
                        out.write(__oracle_jsp_text[299]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_238=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_238.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_238.setId("handlingInstCode3");
                          __jsp_tag_starteval=__jsp_taghandler_238.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_238,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[300]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_239=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_239.setParent(__jsp_taghandler_238);
                                __jsp_taghandler_239.setMaxlength("3");
                                __jsp_taghandler_239.setName("fell002");
                                __jsp_taghandler_239.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateHandInsCode1(this,3,("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"));"));
                                __jsp_taghandler_239.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstCode3"));
                                __jsp_taghandler_239.setStyle("width:75%");
                                __jsp_tag_starteval=__jsp_taghandler_239.doStartTag();
                                if (__jsp_taghandler_239.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_239,5);
                              }
                              out.write(__oracle_jsp_text[301]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[302]);
                            } while (__jsp_taghandler_238.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_238.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_238,4);
                        }
                        out.write(__oracle_jsp_text[303]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_240=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_240.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_240.setId("handlingInstDesc3");
                          __jsp_tag_starteval=__jsp_taghandler_240.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_240,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_241=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_241.setParent(__jsp_taghandler_240);
                                __jsp_taghandler_241.setMaxlength("60");
                                __jsp_taghandler_241.setName("fell002");
                                __jsp_taghandler_241.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstDesc3"));
                                __jsp_taghandler_241.setReadonly(true);
                                __jsp_taghandler_241.setStyle("width:96%");
                                __jsp_taghandler_241.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_241.doStartTag();
                                if (__jsp_taghandler_241.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_241,5);
                              }
                            } while (__jsp_taghandler_240.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_240.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_240,4);
                        }
                        out.write(__oracle_jsp_text[304]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_242=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_242.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_242.setId("contLoadRemark1");
                          __jsp_tag_starteval=__jsp_taghandler_242.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_242,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[305]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_243=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_243.setParent(__jsp_taghandler_242);
                                __jsp_taghandler_243.setMaxlength("3");
                                __jsp_taghandler_243.setName("fell002");
                                __jsp_taghandler_243.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_243.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contLoadRemark1"));
                                __jsp_taghandler_243.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_243.doStartTag();
                                if (__jsp_taghandler_243.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_243,5);
                              }
                              out.write(__oracle_jsp_text[306]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_244=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_244.setParent(__jsp_taghandler_242);
                                __jsp_taghandler_244.setName("fell002");
                                __jsp_taghandler_244.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_244.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contLoadRemark1"));
                                __jsp_taghandler_244.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_244.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_244,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[307]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_245=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_245.setParent(__jsp_taghandler_244);
                                      __jsp_taghandler_245.setLabel("name");
                                      __jsp_taghandler_245.setName("fell002");
                                      __jsp_taghandler_245.setProperty("clrValues");
                                      __jsp_taghandler_245.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_245.doStartTag();
                                      if (__jsp_taghandler_245.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_245,6);
                                    }
                                    out.write(__oracle_jsp_text[308]);
                                  } while (__jsp_taghandler_244.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_244.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_244,5);
                              }
                              out.write(__oracle_jsp_text[309]);
                            } while (__jsp_taghandler_242.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_242.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_242,4);
                        }
                        out.write(__oracle_jsp_text[310]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_246=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_246.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_246.setId("contLoadRemark2");
                          __jsp_tag_starteval=__jsp_taghandler_246.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_246,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[311]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_247=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_247.setParent(__jsp_taghandler_246);
                                __jsp_taghandler_247.setMaxlength("3");
                                __jsp_taghandler_247.setName("fell002");
                                __jsp_taghandler_247.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_247.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contLoadRemark2"));
                                __jsp_taghandler_247.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_247.doStartTag();
                                if (__jsp_taghandler_247.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_247,5);
                              }
                              out.write(__oracle_jsp_text[312]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_248=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_248.setParent(__jsp_taghandler_246);
                                __jsp_taghandler_248.setName("fell002");
                                __jsp_taghandler_248.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_248.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contLoadRemark2"));
                                __jsp_taghandler_248.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_248.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_248,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[313]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_249=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_249.setParent(__jsp_taghandler_248);
                                      __jsp_taghandler_249.setLabel("name");
                                      __jsp_taghandler_249.setName("fell002");
                                      __jsp_taghandler_249.setProperty("clrValues");
                                      __jsp_taghandler_249.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_249.doStartTag();
                                      if (__jsp_taghandler_249.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_249,6);
                                    }
                                    out.write(__oracle_jsp_text[314]);
                                  } while (__jsp_taghandler_248.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_248.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_248,5);
                              }
                              out.write(__oracle_jsp_text[315]);
                            } while (__jsp_taghandler_246.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_246.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_246,4);
                        }
                        out.write(__oracle_jsp_text[316]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_250=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_250.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_250.setId("specialCargo");
                          __jsp_tag_starteval=__jsp_taghandler_250.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_250,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_251=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_251.setParent(__jsp_taghandler_250);
                                __jsp_taghandler_251.setMaxlength("3");
                                __jsp_taghandler_251.setName("fell002");
                                __jsp_taghandler_251.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialCargo"));
                                __jsp_taghandler_251.setReadonly(true);
                                __jsp_taghandler_251.setStyle("width:96%");
                                __jsp_taghandler_251.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_251.doStartTag();
                                if (__jsp_taghandler_251.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_251,5);
                              }
                            } while (__jsp_taghandler_250.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_250.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_250,4);
                        }
                        out.write(__oracle_jsp_text[317]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_252=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_252.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_252.setId("tightConnectionPOD1");
                          __jsp_tag_starteval=__jsp_taghandler_252.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_252,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[318]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_253=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_253.setParent(__jsp_taghandler_252);
                                __jsp_taghandler_253.setName("fell002");
                                __jsp_taghandler_253.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_253.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].tightConnectionPOD1"));
                                __jsp_taghandler_253.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_253.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_253,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[319]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_254=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_254.setParent(__jsp_taghandler_253);
                                      __jsp_taghandler_254.setLabel("name");
                                      __jsp_taghandler_254.setName("fell002");
                                      __jsp_taghandler_254.setProperty("tightConnectionPODValues");
                                      __jsp_taghandler_254.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_254.doStartTag();
                                      if (__jsp_taghandler_254.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_254,6);
                                    }
                                    out.write(__oracle_jsp_text[320]);
                                  } while (__jsp_taghandler_253.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_253.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_253,5);
                              }
                              out.write(__oracle_jsp_text[321]);
                            } while (__jsp_taghandler_252.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_252.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_252,4);
                        }
                        out.write(__oracle_jsp_text[322]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_255=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_255.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_255.setId("tightConnectionPOD2");
                          __jsp_tag_starteval=__jsp_taghandler_255.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_255,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[323]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_256=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_256.setParent(__jsp_taghandler_255);
                                __jsp_taghandler_256.setName("fell002");
                                __jsp_taghandler_256.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_256.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].tightConnectionPOD2"));
                                __jsp_taghandler_256.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_256.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_256,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[324]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_257=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_257.setParent(__jsp_taghandler_256);
                                      __jsp_taghandler_257.setLabel("name");
                                      __jsp_taghandler_257.setName("fell002");
                                      __jsp_taghandler_257.setProperty("tightConnectionPODValues");
                                      __jsp_taghandler_257.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_257.doStartTag();
                                      if (__jsp_taghandler_257.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_257,6);
                                    }
                                    out.write(__oracle_jsp_text[325]);
                                  } while (__jsp_taghandler_256.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_256.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_256,5);
                              }
                              out.write(__oracle_jsp_text[326]);
                            } while (__jsp_taghandler_255.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_255.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_255,4);
                        }
                        out.write(__oracle_jsp_text[327]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_258=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_258.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_258.setId("tightConnectionPOD3");
                          __jsp_tag_starteval=__jsp_taghandler_258.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_258,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[328]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_259=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_259.setParent(__jsp_taghandler_258);
                                __jsp_taghandler_259.setName("fell002");
                                __jsp_taghandler_259.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_259.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].tightConnectionPOD3"));
                                __jsp_taghandler_259.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_259.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_259,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[329]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_260=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_260.setParent(__jsp_taghandler_259);
                                      __jsp_taghandler_260.setLabel("name");
                                      __jsp_taghandler_260.setName("fell002");
                                      __jsp_taghandler_260.setProperty("tightConnectionPODValues");
                                      __jsp_taghandler_260.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_260.doStartTag();
                                      if (__jsp_taghandler_260.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_260,6);
                                    }
                                    out.write(__oracle_jsp_text[330]);
                                  } while (__jsp_taghandler_259.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_259.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_259,5);
                              }
                              out.write(__oracle_jsp_text[331]);
                            } while (__jsp_taghandler_258.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_258.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_258,4);
                        }
                        out.write(__oracle_jsp_text[332]);
                        out.write(__oracle_jsp_text[333]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_261=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_261.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_261.setName("fell002");
                          __jsp_taghandler_261.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].isUpdateDG"));
                          __jsp_taghandler_261.setValue("TRUE");
                          __jsp_tag_starteval=__jsp_taghandler_261.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[334]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_262=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_262.setParent(__jsp_taghandler_261);
                                __jsp_taghandler_262.setId("imdgClass");
                                __jsp_tag_starteval=__jsp_taghandler_262.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_262,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[335]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_263=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_263.setParent(__jsp_taghandler_262);
                                      __jsp_taghandler_263.setMaxlength("4");
                                      __jsp_taghandler_263.setName("fell002");
                                      __jsp_taghandler_263.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_263.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].imdgClass"));
                                      __jsp_taghandler_263.setReadonly(true);
                                      __jsp_taghandler_263.setStyle("width:96%");
                                      __jsp_taghandler_263.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_263.doStartTag();
                                      if (__jsp_taghandler_263.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_263,6);
                                    }
                                  } while (__jsp_taghandler_262.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_262.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_262,5);
                              }
                              out.write(__oracle_jsp_text[336]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_264=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_264.setParent(__jsp_taghandler_261);
                                __jsp_taghandler_264.setId("unNumber");
                                __jsp_tag_starteval=__jsp_taghandler_264.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_264,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[337]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_265=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_265.setParent(__jsp_taghandler_264);
                                      __jsp_taghandler_265.setMaxlength("6");
                                      __jsp_taghandler_265.setName("fell002");
                                      __jsp_taghandler_265.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_265.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].unNumber"));
                                      __jsp_taghandler_265.setReadonly(true);
                                      __jsp_taghandler_265.setStyle("width:75%");
                                      __jsp_taghandler_265.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_265.doStartTag();
                                      if (__jsp_taghandler_265.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_265,6);
                                    }
                                    out.write(__oracle_jsp_text[338]);
                                    out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                    out.write(__oracle_jsp_text[339]);
                                  } while (__jsp_taghandler_264.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_264.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_264,5);
                              }
                              out.write(__oracle_jsp_text[340]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_266=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_266.setParent(__jsp_taghandler_261);
                                __jsp_taghandler_266.setId("unNumberVariant");
                                __jsp_tag_starteval=__jsp_taghandler_266.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_266,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_267=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_267.setParent(__jsp_taghandler_266);
                                      __jsp_taghandler_267.setMaxlength("1");
                                      __jsp_taghandler_267.setName("fell002");
                                      __jsp_taghandler_267.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_267.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].unNumberVariant"));
                                      __jsp_taghandler_267.setReadonly(true);
                                      __jsp_taghandler_267.setStyle("width:96%");
                                      __jsp_taghandler_267.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_267.doStartTag();
                                      if (__jsp_taghandler_267.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_267,6);
                                    }
                                  } while (__jsp_taghandler_266.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_266.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_266,5);
                              }
                              out.write(__oracle_jsp_text[341]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_268=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_268.setParent(__jsp_taghandler_261);
                                __jsp_taghandler_268.setId("portClass");
                                __jsp_tag_starteval=__jsp_taghandler_268.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_268,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_269=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_269.setParent(__jsp_taghandler_268);
                                      __jsp_taghandler_269.setMaxlength("5");
                                      __jsp_taghandler_269.setName("fell002");
                                      __jsp_taghandler_269.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_269.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].portClass"));
                                      __jsp_taghandler_269.setReadonly(true);
                                      __jsp_taghandler_269.setStyle("width:96%");
                                      __jsp_taghandler_269.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_269.doStartTag();
                                      if (__jsp_taghandler_269.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_269,6);
                                    }
                                  } while (__jsp_taghandler_268.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_268.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_268,5);
                              }
                              out.write(__oracle_jsp_text[342]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_270=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_270.setParent(__jsp_taghandler_261);
                                __jsp_taghandler_270.setId("portClassType");
                                __jsp_tag_starteval=__jsp_taghandler_270.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_270,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_271=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_271.setParent(__jsp_taghandler_270);
                                      __jsp_taghandler_271.setMaxlength("5");
                                      __jsp_taghandler_271.setName("fell002");
                                      __jsp_taghandler_271.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_271.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].portClassType"));
                                      __jsp_taghandler_271.setReadonly(true);
                                      __jsp_taghandler_271.setStyle("width:96%");
                                      __jsp_taghandler_271.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_271.doStartTag();
                                      if (__jsp_taghandler_271.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_271,6);
                                    }
                                  } while (__jsp_taghandler_270.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_270.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_270,5);
                              }
                              out.write(__oracle_jsp_text[343]);
                            } while (__jsp_taghandler_261.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_261.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_261,4);
                        }
                        out.write(__oracle_jsp_text[344]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_272=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_272.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_272.setName("fell002");
                          __jsp_taghandler_272.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].isUpdateDG"));
                          __jsp_taghandler_272.setValue("TRUE");
                          __jsp_tag_starteval=__jsp_taghandler_272.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[345]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_273=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_273.setParent(__jsp_taghandler_272);
                                __jsp_taghandler_273.setId("imdgClass");
                                __jsp_tag_starteval=__jsp_taghandler_273.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_273,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_274=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_274.setParent(__jsp_taghandler_273);
                                      __jsp_taghandler_274.setMaxlength("4");
                                      __jsp_taghandler_274.setName("fell002");
                                      __jsp_taghandler_274.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_274.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].imdgClass"));
                                      __jsp_taghandler_274.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_274.doStartTag();
                                      if (__jsp_taghandler_274.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_274,6);
                                    }
                                  } while (__jsp_taghandler_273.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_273.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_273,5);
                              }
                              out.write(__oracle_jsp_text[346]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_275=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_275.setParent(__jsp_taghandler_272);
                                __jsp_taghandler_275.setId("unNumber");
                                __jsp_tag_starteval=__jsp_taghandler_275.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_275,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[347]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_276=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_276.setParent(__jsp_taghandler_275);
                                      __jsp_taghandler_276.setMaxlength("6");
                                      __jsp_taghandler_276.setName("fell002");
                                      __jsp_taghandler_276.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_276.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].unNumber"));
                                      __jsp_taghandler_276.setStyle("width:75%");
                                      __jsp_tag_starteval=__jsp_taghandler_276.doStartTag();
                                      if (__jsp_taghandler_276.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_276,6);
                                    }
                                    out.write(__oracle_jsp_text[348]);
                                    out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                    out.write(__oracle_jsp_text[349]);
                                  } while (__jsp_taghandler_275.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_275.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_275,5);
                              }
                              out.write(__oracle_jsp_text[350]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_277=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_277.setParent(__jsp_taghandler_272);
                                __jsp_taghandler_277.setId("unNumberVariant");
                                __jsp_tag_starteval=__jsp_taghandler_277.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_277,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_278=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_278.setParent(__jsp_taghandler_277);
                                      __jsp_taghandler_278.setMaxlength("1");
                                      __jsp_taghandler_278.setName("fell002");
                                      __jsp_taghandler_278.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_278.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].unNumberVariant"));
                                      __jsp_taghandler_278.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_278.doStartTag();
                                      if (__jsp_taghandler_278.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_278,6);
                                    }
                                  } while (__jsp_taghandler_277.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_277.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_277,5);
                              }
                              out.write(__oracle_jsp_text[351]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_279=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_279.setParent(__jsp_taghandler_272);
                                __jsp_taghandler_279.setId("portClass");
                                __jsp_tag_starteval=__jsp_taghandler_279.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_279,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_280=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_280.setParent(__jsp_taghandler_279);
                                      __jsp_taghandler_280.setMaxlength("5");
                                      __jsp_taghandler_280.setName("fell002");
                                      __jsp_taghandler_280.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_280.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].portClass"));
                                      __jsp_taghandler_280.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_280.doStartTag();
                                      if (__jsp_taghandler_280.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_280,6);
                                    }
                                  } while (__jsp_taghandler_279.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_279.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_279,5);
                              }
                              out.write(__oracle_jsp_text[352]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_281=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_281.setParent(__jsp_taghandler_272);
                                __jsp_taghandler_281.setId("portClassType");
                                __jsp_tag_starteval=__jsp_taghandler_281.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_281,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_282=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_282.setParent(__jsp_taghandler_281);
                                      __jsp_taghandler_282.setMaxlength("5");
                                      __jsp_taghandler_282.setName("fell002");
                                      __jsp_taghandler_282.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_282.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].portClassType"));
                                      __jsp_taghandler_282.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_282.doStartTag();
                                      if (__jsp_taghandler_282.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_282,6);
                                    }
                                  } while (__jsp_taghandler_281.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_281.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_281,5);
                              }
                              out.write(__oracle_jsp_text[353]);
                            } while (__jsp_taghandler_272.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_272.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_272,4);
                        }
                        out.write(__oracle_jsp_text[354]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_283=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_283.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_283.setId("flashUnit");
                          __jsp_tag_starteval=__jsp_taghandler_283.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_283,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[355]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_284=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_284.setParent(__jsp_taghandler_283);
                                __jsp_taghandler_284.setName("fell002");
                                __jsp_taghandler_284.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_284.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].flashUnit"));
                                __jsp_taghandler_284.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_284.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_284,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[356]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_285=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_285.setParent(__jsp_taghandler_284);
                                      __jsp_taghandler_285.setLabel("name");
                                      __jsp_taghandler_285.setName("fell002");
                                      __jsp_taghandler_285.setProperty("reeferTempUnitValues");
                                      __jsp_taghandler_285.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_285.doStartTag();
                                      if (__jsp_taghandler_285.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_285,6);
                                    }
                                    out.write(__oracle_jsp_text[357]);
                                  } while (__jsp_taghandler_284.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_284.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_284,5);
                              }
                              out.write(__oracle_jsp_text[358]);
                            } while (__jsp_taghandler_283.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_283.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_283,4);
                        }
                        out.write(__oracle_jsp_text[359]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_286=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_286.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_286.setId("flashPoint");
                          __jsp_tag_starteval=__jsp_taghandler_286.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_286,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_287=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_287.setParent(__jsp_taghandler_286);
                                __jsp_taghandler_287.setMaxlength("7");
                                __jsp_taghandler_287.setName("fell002");
                                __jsp_taghandler_287.setOnblur((java.lang.String) ("putMask_Number(this, 3, 3);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_287.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_287.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].flashPoint"));
                                __jsp_taghandler_287.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_287.doStartTag();
                                if (__jsp_taghandler_287.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_287,5);
                              }
                            } while (__jsp_taghandler_286.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_286.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_286,4);
                        }
                        out.write(__oracle_jsp_text[360]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_288=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_288.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_288.setId("fumigationOnly");
                          __jsp_tag_starteval=__jsp_taghandler_288.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_288,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[361]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_289=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_289.setParent(__jsp_taghandler_288);
                                __jsp_taghandler_289.setName("fell002");
                                __jsp_taghandler_289.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_289.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fumigationOnly"));
                                __jsp_taghandler_289.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_289.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_289,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[362]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_290=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_290.setParent(__jsp_taghandler_289);
                                      __jsp_taghandler_290.setLabel("name");
                                      __jsp_taghandler_290.setName("fell002");
                                      __jsp_taghandler_290.setProperty("fumigationOnlyValues");
                                      __jsp_taghandler_290.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_290.doStartTag();
                                      if (__jsp_taghandler_290.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_290,6);
                                    }
                                    out.write(__oracle_jsp_text[363]);
                                  } while (__jsp_taghandler_289.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_289.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_289,5);
                              }
                              out.write(__oracle_jsp_text[364]);
                            } while (__jsp_taghandler_288.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_288.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_288,4);
                        }
                        out.write(__oracle_jsp_text[365]);
                        out.write(__oracle_jsp_text[366]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_291=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_291.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_291.setId("residue");
                          __jsp_tag_starteval=__jsp_taghandler_291.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_291,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[367]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_292=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_292.setParent(__jsp_taghandler_291);
                                __jsp_taghandler_292.setName("fell002");
                                __jsp_taghandler_292.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_292.setValue("DG");
                                __jsp_tag_starteval=__jsp_taghandler_292.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[368]);
                                    {
                                      org.apache.struts.taglib.html.SelectTag __jsp_taghandler_293=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag disabled name property style");
                                      __jsp_taghandler_293.setParent(__jsp_taghandler_292);
                                      __jsp_taghandler_293.setDisabled(true);
                                      __jsp_taghandler_293.setName("fell002");
                                      __jsp_taghandler_293.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].residue"));
                                      __jsp_taghandler_293.setStyle("width:98%");
                                      __jsp_tag_starteval=__jsp_taghandler_293.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_293,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[369]);
                                          {
                                            org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_294=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                            __jsp_taghandler_294.setParent(__jsp_taghandler_293);
                                            __jsp_taghandler_294.setLabel("name");
                                            __jsp_taghandler_294.setName("fell002");
                                            __jsp_taghandler_294.setProperty("residueValues");
                                            __jsp_taghandler_294.setValue("code");
                                            __jsp_tag_starteval=__jsp_taghandler_294.doStartTag();
                                            if (__jsp_taghandler_294.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_294,7);
                                          }
                                          out.write(__oracle_jsp_text[370]);
                                        } while (__jsp_taghandler_293.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_293.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_293,6);
                                    }
                                    out.write(__oracle_jsp_text[371]);
                                  } while (__jsp_taghandler_292.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_292.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_292,5);
                              }
                              out.write(__oracle_jsp_text[372]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_295=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_295.setParent(__jsp_taghandler_291);
                                __jsp_taghandler_295.setName("fell002");
                                __jsp_taghandler_295.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_295.setValue("DG");
                                __jsp_tag_starteval=__jsp_taghandler_295.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[373]);
                                    {
                                      org.apache.struts.taglib.html.SelectTag __jsp_taghandler_296=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                      __jsp_taghandler_296.setParent(__jsp_taghandler_295);
                                      __jsp_taghandler_296.setName("fell002");
                                      __jsp_taghandler_296.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'residue',this)"));
                                      __jsp_taghandler_296.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].residue"));
                                      __jsp_taghandler_296.setStyle("width:98%");
                                      __jsp_tag_starteval=__jsp_taghandler_296.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_296,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[374]);
                                          {
                                            org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_297=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                            __jsp_taghandler_297.setParent(__jsp_taghandler_296);
                                            __jsp_taghandler_297.setLabel("name");
                                            __jsp_taghandler_297.setName("fell002");
                                            __jsp_taghandler_297.setProperty("residueValues");
                                            __jsp_taghandler_297.setValue("code");
                                            __jsp_tag_starteval=__jsp_taghandler_297.doStartTag();
                                            if (__jsp_taghandler_297.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_297,7);
                                          }
                                          out.write(__oracle_jsp_text[375]);
                                        } while (__jsp_taghandler_296.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_296.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_296,6);
                                    }
                                    out.write(__oracle_jsp_text[376]);
                                  } while (__jsp_taghandler_295.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_295.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_295,5);
                              }
                              out.write(__oracle_jsp_text[377]);
                            } while (__jsp_taghandler_291.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_291.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_291,4);
                        }
                        out.write(__oracle_jsp_text[378]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_298=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_298.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_298.setId("overheight");
                          __jsp_tag_starteval=__jsp_taghandler_298.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_298,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_299=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_299.setParent(__jsp_taghandler_298);
                                __jsp_taghandler_299.setMaxlength("15");
                                __jsp_taghandler_299.setName("fell002");
                                __jsp_taghandler_299.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_299.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_299.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overheight"));
                                __jsp_taghandler_299.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_299.doStartTag();
                                if (__jsp_taghandler_299.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_299,5);
                              }
                            } while (__jsp_taghandler_298.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_298.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_298,4);
                        }
                        out.write(__oracle_jsp_text[379]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_300=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_300.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_300.setId("overwidthLeft");
                          __jsp_tag_starteval=__jsp_taghandler_300.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_300,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_301=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_301.setParent(__jsp_taghandler_300);
                                __jsp_taghandler_301.setMaxlength("15");
                                __jsp_taghandler_301.setName("fell002");
                                __jsp_taghandler_301.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_301.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_301.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overwidthLeft"));
                                __jsp_taghandler_301.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_301.doStartTag();
                                if (__jsp_taghandler_301.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_301,5);
                              }
                            } while (__jsp_taghandler_300.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_300.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_300,4);
                        }
                        out.write(__oracle_jsp_text[380]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_302=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_302.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_302.setId("overwidthRight");
                          __jsp_tag_starteval=__jsp_taghandler_302.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_302,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_303=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_303.setParent(__jsp_taghandler_302);
                                __jsp_taghandler_303.setMaxlength("15");
                                __jsp_taghandler_303.setName("fell002");
                                __jsp_taghandler_303.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_303.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_303.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overwidthRight"));
                                __jsp_taghandler_303.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_303.doStartTag();
                                if (__jsp_taghandler_303.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_303,5);
                              }
                            } while (__jsp_taghandler_302.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_302.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_302,4);
                        }
                        out.write(__oracle_jsp_text[381]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_304=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_304.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_304.setId("overlengthFront");
                          __jsp_tag_starteval=__jsp_taghandler_304.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_304,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_305=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_305.setParent(__jsp_taghandler_304);
                                __jsp_taghandler_305.setMaxlength("15");
                                __jsp_taghandler_305.setName("fell002");
                                __jsp_taghandler_305.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_305.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_305.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overlengthFront"));
                                __jsp_taghandler_305.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_305.doStartTag();
                                if (__jsp_taghandler_305.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_305,5);
                              }
                            } while (__jsp_taghandler_304.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_304.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_304,4);
                        }
                        out.write(__oracle_jsp_text[382]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_306=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_306.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_306.setId("overlengthAfter");
                          __jsp_tag_starteval=__jsp_taghandler_306.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_306,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_307=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_307.setParent(__jsp_taghandler_306);
                                __jsp_taghandler_307.setMaxlength("15");
                                __jsp_taghandler_307.setName("fell002");
                                __jsp_taghandler_307.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_307.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_307.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overlengthAfter"));
                                __jsp_taghandler_307.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_307.doStartTag();
                                if (__jsp_taghandler_307.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_307,5);
                              }
                            } while (__jsp_taghandler_306.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_306.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_306,4);
                        }
                        out.write(__oracle_jsp_text[383]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_308=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_308.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_308.setId("reeferTemp");
                          __jsp_tag_starteval=__jsp_taghandler_308.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_308,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_309=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_309.setParent(__jsp_taghandler_308);
                                __jsp_taghandler_309.setMaxlength("8");
                                __jsp_taghandler_309.setName("fell002");
                                __jsp_taghandler_309.setOnblur((java.lang.String) ("putMask_Number(this, 3, 3);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_309.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_309.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferTemp"));
                                __jsp_taghandler_309.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_309.doStartTag();
                                if (__jsp_taghandler_309.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_309,5);
                              }
                            } while (__jsp_taghandler_308.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_308.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_308,4);
                        }
                        out.write(__oracle_jsp_text[384]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_310=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_310.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_310.setId("reeferTempUnit");
                          __jsp_tag_starteval=__jsp_taghandler_310.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_310,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[385]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_311=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_311.setParent(__jsp_taghandler_310);
                                __jsp_taghandler_311.setName("fell002");
                                __jsp_taghandler_311.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_311.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferTempUnit"));
                                __jsp_taghandler_311.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_311.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_311,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[386]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_312=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_312.setParent(__jsp_taghandler_311);
                                      __jsp_taghandler_312.setLabel("name");
                                      __jsp_taghandler_312.setName("fell002");
                                      __jsp_taghandler_312.setProperty("reeferTempUnitValues");
                                      __jsp_taghandler_312.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_312.doStartTag();
                                      if (__jsp_taghandler_312.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_312,6);
                                    }
                                    out.write(__oracle_jsp_text[387]);
                                  } while (__jsp_taghandler_311.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_311.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_311,5);
                              }
                              out.write(__oracle_jsp_text[388]);
                            } while (__jsp_taghandler_310.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_310.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_310,4);
                        }
                        out.write(__oracle_jsp_text[389]);
                        out.write(__oracle_jsp_text[390]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_313=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_313.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_313.setId("humidity");
                          __jsp_tag_starteval=__jsp_taghandler_313.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_313,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[391]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_314=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_314.setParent(__jsp_taghandler_313);
                                __jsp_taghandler_314.setName("fell002");
                                __jsp_taghandler_314.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferFlag"));
                                __jsp_taghandler_314.setValue("N");
                                __jsp_tag_starteval=__jsp_taghandler_314.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[392]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_315=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                      __jsp_taghandler_315.setParent(__jsp_taghandler_314);
                                      __jsp_taghandler_315.setMaxlength("5");
                                      __jsp_taghandler_315.setName("fell002");
                                      __jsp_taghandler_315.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].humidity"));
                                      __jsp_taghandler_315.setReadonly(true);
                                      __jsp_taghandler_315.setStyle("width:96%");
                                      __jsp_taghandler_315.setStyleClass("non_edit");
                                      __jsp_taghandler_315.setValue("");
                                      __jsp_tag_starteval=__jsp_taghandler_315.doStartTag();
                                      if (__jsp_taghandler_315.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_315,6);
                                    }
                                    out.write(__oracle_jsp_text[393]);
                                  } while (__jsp_taghandler_314.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_314.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_314,5);
                              }
                              out.write(__oracle_jsp_text[394]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_316=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_316.setParent(__jsp_taghandler_313);
                                __jsp_taghandler_316.setName("fell002");
                                __jsp_taghandler_316.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferFlag"));
                                __jsp_taghandler_316.setValue("N");
                                __jsp_tag_starteval=__jsp_taghandler_316.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[395]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_317=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_317.setParent(__jsp_taghandler_316);
                                      __jsp_taghandler_317.setName("fell002");
                                      __jsp_taghandler_317.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                      __jsp_taghandler_317.setValue("Non Reefer");
                                      __jsp_tag_starteval=__jsp_taghandler_317.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[396]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_318=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                            __jsp_taghandler_318.setParent(__jsp_taghandler_317);
                                            __jsp_taghandler_318.setMaxlength("5");
                                            __jsp_taghandler_318.setName("fell002");
                                            __jsp_taghandler_318.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].humidity"));
                                            __jsp_taghandler_318.setReadonly(true);
                                            __jsp_taghandler_318.setStyle("width:96%");
                                            __jsp_taghandler_318.setStyleClass("non_edit");
                                            __jsp_taghandler_318.setValue("");
                                            __jsp_tag_starteval=__jsp_taghandler_318.doStartTag();
                                            if (__jsp_taghandler_318.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_318,7);
                                          }
                                          out.write(__oracle_jsp_text[397]);
                                        } while (__jsp_taghandler_317.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_317.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_317,6);
                                    }
                                    out.write(__oracle_jsp_text[398]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_319=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_319.setParent(__jsp_taghandler_316);
                                      __jsp_taghandler_319.setName("fell002");
                                      __jsp_taghandler_319.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                      __jsp_taghandler_319.setValue("Non Reefer");
                                      __jsp_tag_starteval=__jsp_taghandler_319.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[399]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_320=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                            __jsp_taghandler_320.setParent(__jsp_taghandler_319);
                                            __jsp_taghandler_320.setMaxlength("6");
                                            __jsp_taghandler_320.setName("fell002");
                                            __jsp_taghandler_320.setOnblur((java.lang.String) ("putMask_Number(this, 3, 2);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                            __jsp_taghandler_320.setOnclick("hideMask_Number(this);");
                                            __jsp_taghandler_320.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].humidity"));
                                            __jsp_taghandler_320.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_320.doStartTag();
                                            if (__jsp_taghandler_320.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_320,7);
                                          }
                                          out.write(__oracle_jsp_text[400]);
                                        } while (__jsp_taghandler_319.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_319.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_319,6);
                                    }
                                    out.write(__oracle_jsp_text[401]);
                                  } while (__jsp_taghandler_316.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_316.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_316,5);
                              }
                              out.write(__oracle_jsp_text[402]);
                            } while (__jsp_taghandler_313.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_313.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_313,4);
                        }
                        out.write(__oracle_jsp_text[403]);
                        out.write(__oracle_jsp_text[404]);
                        out.write(__oracle_jsp_text[405]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_321=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_321.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_321.setId("ventilation");
                          __jsp_tag_starteval=__jsp_taghandler_321.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_321,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[406]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_322=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_322.setParent(__jsp_taghandler_321);
                                __jsp_taghandler_322.setName("fell002");
                                __jsp_taghandler_322.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferFlag"));
                                __jsp_taghandler_322.setValue("N");
                                __jsp_tag_starteval=__jsp_taghandler_322.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[407]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_323=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                      __jsp_taghandler_323.setParent(__jsp_taghandler_322);
                                      __jsp_taghandler_323.setMaxlength("5");
                                      __jsp_taghandler_323.setName("fell002");
                                      __jsp_taghandler_323.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].ventilation"));
                                      __jsp_taghandler_323.setReadonly(true);
                                      __jsp_taghandler_323.setStyle("width:96%");
                                      __jsp_taghandler_323.setStyleClass("non_edit");
                                      __jsp_taghandler_323.setValue("");
                                      __jsp_tag_starteval=__jsp_taghandler_323.doStartTag();
                                      if (__jsp_taghandler_323.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_323,6);
                                    }
                                    out.write(__oracle_jsp_text[408]);
                                  } while (__jsp_taghandler_322.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_322.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_322,5);
                              }
                              out.write(__oracle_jsp_text[409]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_324=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_324.setParent(__jsp_taghandler_321);
                                __jsp_taghandler_324.setName("fell002");
                                __jsp_taghandler_324.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferFlag"));
                                __jsp_taghandler_324.setValue("N");
                                __jsp_tag_starteval=__jsp_taghandler_324.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[410]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_325=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_325.setParent(__jsp_taghandler_324);
                                      __jsp_taghandler_325.setName("fell002");
                                      __jsp_taghandler_325.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                      __jsp_taghandler_325.setValue("Non Reefer");
                                      __jsp_tag_starteval=__jsp_taghandler_325.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[411]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_326=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                            __jsp_taghandler_326.setParent(__jsp_taghandler_325);
                                            __jsp_taghandler_326.setMaxlength("5");
                                            __jsp_taghandler_326.setName("fell002");
                                            __jsp_taghandler_326.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].ventilation"));
                                            __jsp_taghandler_326.setReadonly(true);
                                            __jsp_taghandler_326.setStyle("width:96%");
                                            __jsp_taghandler_326.setStyleClass("non_edit");
                                            __jsp_taghandler_326.setValue("");
                                            __jsp_tag_starteval=__jsp_taghandler_326.doStartTag();
                                            if (__jsp_taghandler_326.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_326,7);
                                          }
                                          out.write(__oracle_jsp_text[412]);
                                        } while (__jsp_taghandler_325.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_325.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_325,6);
                                    }
                                    out.write(__oracle_jsp_text[413]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_327=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_327.setParent(__jsp_taghandler_324);
                                      __jsp_taghandler_327.setName("fell002");
                                      __jsp_taghandler_327.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                      __jsp_taghandler_327.setValue("Non Reefer");
                                      __jsp_tag_starteval=__jsp_taghandler_327.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[414]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_328=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                            __jsp_taghandler_328.setParent(__jsp_taghandler_327);
                                            __jsp_taghandler_328.setMaxlength("6");
                                            __jsp_taghandler_328.setName("fell002");
                                            __jsp_taghandler_328.setOnblur((java.lang.String) ("putMask_Number(this, 3, 2);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                            __jsp_taghandler_328.setOnclick("hideMask_Number(this);");
                                            __jsp_taghandler_328.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].ventilation"));
                                            __jsp_taghandler_328.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_328.doStartTag();
                                            if (__jsp_taghandler_328.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_328,7);
                                          }
                                          out.write(__oracle_jsp_text[415]);
                                        } while (__jsp_taghandler_327.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_327.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_327,6);
                                    }
                                    out.write(__oracle_jsp_text[416]);
                                  } while (__jsp_taghandler_324.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_324.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_324,5);
                              }
                              out.write(__oracle_jsp_text[417]);
                            } while (__jsp_taghandler_321.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_321.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_321,4);
                        }
                        out.write(__oracle_jsp_text[418]);
                        out.write(__oracle_jsp_text[419]);
                        out.write(__oracle_jsp_text[420]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_329=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_329.setParent(__jsp_taghandler_84);
                          __jsp_taghandler_329.setId("remarks");
                          __jsp_tag_starteval=__jsp_taghandler_329.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_329,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_330=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_330.setParent(__jsp_taghandler_329);
                                __jsp_taghandler_330.setMaxlength("2000");
                                __jsp_taghandler_330.setName("fell002");
                                __jsp_taghandler_330.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_330.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].remarks"));
                                __jsp_taghandler_330.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_330.doStartTag();
                                if (__jsp_taghandler_330.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_330,5);
                              }
                            } while (__jsp_taghandler_329.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_329.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_329,4);
                        }
                        out.write(__oracle_jsp_text[421]);
                      } while (__jsp_taghandler_84.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_84.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_84,3);
                  }
                  out.write(__oracle_jsp_text[422]);
                } while (__jsp_taghandler_83.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_83.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_83,2);
            }
            out.write(__oracle_jsp_text[423]);
          } while (__jsp_taghandler_3.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,1);
      }
      out.write(__oracle_jsp_text[424]);
      {
        org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_331=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
        __jsp_taghandler_331.setParent(null);
        __jsp_taghandler_331.setName("fell002");
        __jsp_taghandler_331.setProperty("vesselOwner");
        __jsp_tag_starteval=__jsp_taghandler_331.doStartTag();
        if (__jsp_taghandler_331.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_331,1);
      }
      out.write(__oracle_jsp_text[425]);
      {
        org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_332=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
        __jsp_taghandler_332.setParent(null);
        __jsp_taghandler_332.setId("rowdata");
        __jsp_taghandler_332.setIndexId("ctr");
        __jsp_taghandler_332.setName("fell002");
        __jsp_taghandler_332.setProperty("marlBookedDtlTable");
        __jsp_taghandler_332.setType("com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListBookingMod");
        com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListBookingMod rowdata = null;
        java.lang.Integer ctr = null;
        __jsp_tag_starteval=__jsp_taghandler_332.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_332,__jsp_tag_starteval,out);
          do {
            rowdata = (com.rclgroup.dolphin.ezl.web.ell.vo.EllLoadListBookingMod) pageContext.findAttribute("rowdata");
            ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
            out.write(__oracle_jsp_text[426]);
            out.print( "row" + ctr );
            out.write(__oracle_jsp_text[427]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_333=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_333.setParent(__jsp_taghandler_332);
              __jsp_taghandler_333.setName("fell002");
              __jsp_taghandler_333.setOnclick(OracleJspRuntime.toStr( "highlightRow("+ctr+")"));
              __jsp_taghandler_333.setProperty("radioGroup1");
              __jsp_taghandler_333.setStyleClass("check");
              __jsp_taghandler_333.setValue(OracleJspRuntime.toStr( ctr));
              __jsp_tag_starteval=__jsp_taghandler_333.doStartTag();
              if (__jsp_taghandler_333.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_333,2);
            }
            out.write(__oracle_jsp_text[428]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_334=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_334.setParent(__jsp_taghandler_332);
              __jsp_taghandler_334.setMaxlength("5");
              __jsp_taghandler_334.setName("fell002");
              __jsp_taghandler_334.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].contSeq"));
              __jsp_taghandler_334.setReadonly(true);
              __jsp_taghandler_334.setStyle("width:96%");
              __jsp_taghandler_334.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_334.doStartTag();
              if (__jsp_taghandler_334.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_334,2);
            }
            out.write(__oracle_jsp_text[429]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_335=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_335.setParent(__jsp_taghandler_332);
              __jsp_taghandler_335.setMaxlength("17");
              __jsp_taghandler_335.setName("fell002");
              __jsp_taghandler_335.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].bookingNo"));
              __jsp_taghandler_335.setReadonly(true);
              __jsp_taghandler_335.setStyle("width:96%");
              __jsp_taghandler_335.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_335.doStartTag();
              if (__jsp_taghandler_335.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_335,2);
            }
            out.write(__oracle_jsp_text[430]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_336=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_336.setParent(__jsp_taghandler_332);
              __jsp_taghandler_336.setName("fell002");
              __jsp_taghandler_336.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].bookedId"));
              __jsp_tag_starteval=__jsp_taghandler_336.doStartTag();
              if (__jsp_taghandler_336.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_336,2);
            }
            out.write(__oracle_jsp_text[431]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_337=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_337.setParent(__jsp_taghandler_332);
              __jsp_taghandler_337.setName("fell002");
              __jsp_taghandler_337.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].recordChangeDt"));
              __jsp_tag_starteval=__jsp_taghandler_337.doStartTag();
              if (__jsp_taghandler_337.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_337,2);
            }
            out.write(__oracle_jsp_text[432]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_338=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_338.setParent(__jsp_taghandler_332);
              __jsp_taghandler_338.setName("fell002");
              __jsp_taghandler_338.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].status"));
              __jsp_tag_starteval=__jsp_taghandler_338.doStartTag();
              if (__jsp_taghandler_338.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_338,2);
            }
            out.write(__oracle_jsp_text[433]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_339=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_339.setParent(__jsp_taghandler_332);
              __jsp_taghandler_339.setName("fell002");
              __jsp_taghandler_339.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].bookedSeqNo"));
              __jsp_tag_starteval=__jsp_taghandler_339.doStartTag();
              if (__jsp_taghandler_339.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_339,2);
            }
            out.write(__oracle_jsp_text[434]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_340=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_340.setParent(__jsp_taghandler_332);
              __jsp_taghandler_340.setName("fell002");
              __jsp_taghandler_340.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].reeferFlag"));
              __jsp_tag_starteval=__jsp_taghandler_340.doStartTag();
              if (__jsp_taghandler_340.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_340,2);
            }
            out.write(__oracle_jsp_text[435]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_341=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_341.setParent(__jsp_taghandler_332);
              __jsp_taghandler_341.setName("fell002");
              __jsp_taghandler_341.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].isUpdateDG"));
              __jsp_tag_starteval=__jsp_taghandler_341.doStartTag();
              if (__jsp_taghandler_341.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_341,2);
            }
            out.write(__oracle_jsp_text[436]);
            {
              org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_342=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
              __jsp_taghandler_342.setParent(__jsp_taghandler_332);
              __jsp_taghandler_342.setName("fell002");
              __jsp_taghandler_342.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].socCoc"));
              __jsp_taghandler_342.setValue("SOC");
              __jsp_tag_starteval=__jsp_taghandler_342.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[437]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_343=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                    __jsp_taghandler_343.setParent(__jsp_taghandler_342);
                    __jsp_taghandler_343.setMaxlength("12");
                    __jsp_taghandler_343.setName("fell002");
                    __jsp_taghandler_343.setOnblur(OracleJspRuntime.toStr( "updateBookingStatusFlage(" + ctr + ")"));
                    __jsp_taghandler_343.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].equipmentNo"));
                    __jsp_taghandler_343.setStyle("width:96%");
                    __jsp_tag_starteval=__jsp_taghandler_343.doStartTag();
                    if (__jsp_taghandler_343.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_343,3);
                  }
                  out.write(__oracle_jsp_text[438]);
                } while (__jsp_taghandler_342.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_342.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_342,2);
            }
            out.write(__oracle_jsp_text[439]);
            {
              org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_344=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
              __jsp_taghandler_344.setParent(__jsp_taghandler_332);
              __jsp_taghandler_344.setName("fell002");
              __jsp_taghandler_344.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].socCoc"));
              __jsp_taghandler_344.setValue("SOC");
              __jsp_tag_starteval=__jsp_taghandler_344.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[440]);
                  {
                    org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_345=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                    __jsp_taghandler_345.setParent(__jsp_taghandler_344);
                    __jsp_taghandler_345.setName("fell002");
                    __jsp_taghandler_345.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].fullMT"));
                    __jsp_taghandler_345.setValue("Empty");
                    __jsp_tag_starteval=__jsp_taghandler_345.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[441]);
                        {
                          org.apache.struts.taglib.html.TextTag __jsp_taghandler_346=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                          __jsp_taghandler_346.setParent(__jsp_taghandler_345);
                          __jsp_taghandler_346.setMaxlength("12");
                          __jsp_taghandler_346.setName("fell002");
                          __jsp_taghandler_346.setOnblur(OracleJspRuntime.toStr( "updateBookingStatusFlage(" + ctr + ")"));
                          __jsp_taghandler_346.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].equipmentNo"));
                          __jsp_taghandler_346.setStyle("width:96%");
                          __jsp_tag_starteval=__jsp_taghandler_346.doStartTag();
                          if (__jsp_taghandler_346.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_346,4);
                        }
                        out.write(__oracle_jsp_text[442]);
                      } while (__jsp_taghandler_345.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_345.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_345,3);
                  }
                  out.write(__oracle_jsp_text[443]);
                  {
                    org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_347=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                    __jsp_taghandler_347.setParent(__jsp_taghandler_344);
                    __jsp_taghandler_347.setName("fell002");
                    __jsp_taghandler_347.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].fullMT"));
                    __jsp_taghandler_347.setValue("Empty");
                    __jsp_tag_starteval=__jsp_taghandler_347.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[444]);
                        {
                          org.apache.struts.taglib.html.TextTag __jsp_taghandler_348=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                          __jsp_taghandler_348.setParent(__jsp_taghandler_347);
                          __jsp_taghandler_348.setMaxlength("12");
                          __jsp_taghandler_348.setName("fell002");
                          __jsp_taghandler_348.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].equipmentNo"));
                          __jsp_taghandler_348.setReadonly(true);
                          __jsp_taghandler_348.setStyle("width:96%");
                          __jsp_taghandler_348.setStyleClass("non_edit");
                          __jsp_tag_starteval=__jsp_taghandler_348.doStartTag();
                          if (__jsp_taghandler_348.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_348,4);
                        }
                        out.write(__oracle_jsp_text[445]);
                      } while (__jsp_taghandler_347.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_347.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_347,3);
                  }
                  out.write(__oracle_jsp_text[446]);
                } while (__jsp_taghandler_344.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_344.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_344,2);
            }
            out.write(__oracle_jsp_text[447]);
          } while (__jsp_taghandler_332.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_332.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_332,1);
      }
      out.write(__oracle_jsp_text[448]);
      out.write(__oracle_jsp_text[449]);

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
  private static final char __oracle_jsp_text[][]=new char[450][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!--\n--------------------------------------------------------\nEllLoadListMaintenanceBookedTabGrid.jsp\n--------------------------------------------------------\nCopyright RCL Public Co., Ltd. 2009\n--------------------------------------------------------\nAuthor NIIT\n- Change Log--------------------------------------------\n## DD/MM/YY -User- -TaskRef- -ShortDescription\n01 03/10/13  Leena            Bug fix :For dg details, after validation error shown\n                              in screen, user unable to edit dg column\n--------------------------------------------------------\n-->\n ".toCharArray();
    __oracle_jsp_text[1] = 
    "\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\n".toCharArray();
    __oracle_jsp_text[10] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\n".toCharArray();
    __oracle_jsp_text[12] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[13] = 
    "\n\n".toCharArray();
    __oracle_jsp_text[14] = 
    "\n\n<!-- Link Custom CSS -->\n<!-- Rajeev: Move to file where all CSS Files are added-->\n<!-- *1: Vikas: for normal booking disable the DG details, 18.09.2012 -->\n\n<link rel=\"stylesheet\" type=\"text/css\" href=\"".toCharArray();
    __oracle_jsp_text[15] = 
    "/css/customizeRiaGrid.css\"></link>\n\n<!-- Link Common Grid JS -->\n<!-- Rajeev: Move to file where all CSS Files are added-->\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[16] = 
    "/js/riaGridCommon.js\"></script>\n\n<!-- Link Screen Specific JS -->\n<!-- #1: Added new field crane description, 27.03.2012-->\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[17] = 
    "/js/EllLoadListMaintenanceBookedGrid.js\"></script>\n\n<script language=\"JavaScript\">\n    function initialize()\n    {\n        mobjGrid            = SweetDevRia.$('".toCharArray();
    __oracle_jsp_text[18] = 
    "');\n        mintTotalRows       = mobjGrid.totalDataNumber;\n        mobjFixedTable      = 'tableFixedColumns';\n        return false;\n    }\n</script>\n\n".toCharArray();
    __oracle_jsp_text[19] = 
    "\n\n<!-- Rajeev : Change Table Height as per screen requirement -->\n<!-- table id=\"GridContainer\" border=\"0\" cellspacing=0 cellpadding=0 height=\"100%\" width=\"960PX\" -->\n<div style='height:320px'>\n<table id=\"GridContainer\" border=\"0\" cellspacing=0 cellpadding=0 height=\"100%\" width=\"100%\">\n\n    <!-- Rajeev : Change TR height as per screen requirement -->\n    <!-- Row to Store Fixed Table Header and Dynamic Grid -->\n    <tr height=\"20px\" valign=\"TOP\">\n\n            <!-- Start Store Fixed Table Header -->\n            <td width=\"35%\">\n                <div style='height:30px'>\n                    <table class=\"header\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n                        <thead>\n                            <tr>\n                                <th width=\"13%\">Select</th>\n                                <th width=\"17%\">Container Sequence</th>\n                                <th width=\"40%\">Booking #</th>\n                                <th width=\"30%\">Equipment #</th>\n\n                            </tr>\n                        </thead>\n                    </table>\n                </div>\n            </td>\n\n            <!-- Start to Add Grid Component -->\n            <td width=\"65%\" rowspan=\"2\">\n                <div style='height:290px'>\n\n                    ".toCharArray();
    __oracle_jsp_text[20] = 
    "\n                    ".toCharArray();
    __oracle_jsp_text[21] = 
    "\n                                                        ".toCharArray();
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
    "  <!-- #1-->\n                                                        ".toCharArray();
    __oracle_jsp_text[41] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[42] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[43] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[44] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[45] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[46] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[47] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[48] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[49] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[50] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[51] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[52] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[53] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[54] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[55] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[56] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[57] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[58] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[59] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[60] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[61] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[62] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[63] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[64] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[65] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[66] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[67] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[68] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[69] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[70] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[71] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[72] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[73] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[74] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[75] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[76] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[77] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[78] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[79] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[80] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[81] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[82] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[83] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[84] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[85] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[86] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[87] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[88] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[89] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[90] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[91] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[92] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[93] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[94] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[95] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[96] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[97] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[98] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[99] = 
    "\n\n                                        ".toCharArray();
    __oracle_jsp_text[100] = 
    "\n\n                                        ".toCharArray();
    __oracle_jsp_text[101] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[102] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[103] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[104] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[105] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[106] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[107] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[108] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[109] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[110] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[111] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[112] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[113] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[114] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[115] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[116] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[117] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[118] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[119] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[120] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[121] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[122] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[123] = 
    "\n                                                          ".toCharArray();
    __oracle_jsp_text[124] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[125] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[126] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[127] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[128] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[129] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[130] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[131] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[132] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[133] = 
    "\n                                                                    ".toCharArray();
    __oracle_jsp_text[134] = 
    "\n\n                                                                                ".toCharArray();
    __oracle_jsp_text[135] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[136] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[137] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[138] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[139] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[140] = 
    "\n                                                    <a href=\"#\" onClick=\"showCalendarWithTime('bookingValue[".toCharArray();
    __oracle_jsp_text[141] = 
    "].activityDate', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[142] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\n\n                                                ".toCharArray();
    __oracle_jsp_text[143] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[144] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[145] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[146] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[147] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[148] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[149] = 
    "\n\n                                                <!-- #1 Changes start -->\n                                                ".toCharArray();
    __oracle_jsp_text[150] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[151] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[152] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[153] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[154] = 
    "\n                                                <!-- #1 Changes end -->\n\n                                                ".toCharArray();
    __oracle_jsp_text[155] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[156] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[157] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[158] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[159] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[160] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[161] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[162] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[163] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[164] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[165] = 
    "\n                                                        <input type=\"button\" value=\". . .\" name=\"btnOperatorCodeLookup\" class=\"btnbutton\" onclick='return openContainerOperatorLookup(".toCharArray();
    __oracle_jsp_text[166] = 
    ")'/>\n                                                    ".toCharArray();
    __oracle_jsp_text[167] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[168] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[169] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[170] = 
    "\n                                                        <input type=\"button\" value=\". . .\" name=\"btnOperatorCodeLookup\" class=\"btnbutton\" onclick='return openOutSlotOperatorLookup(".toCharArray();
    __oracle_jsp_text[171] = 
    ")'/>\n                                                ".toCharArray();
    __oracle_jsp_text[172] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[173] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[174] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[175] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[176] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[177] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[178] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[179] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[180] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[181] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[182] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[183] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[184] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[185] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[186] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[187] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[188] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[189] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[190] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[191] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[192] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[193] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[194] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[195] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[196] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[197] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[198] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[199] = 
    "\n                                                       ".toCharArray();
    __oracle_jsp_text[200] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[201] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[202] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[203] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[204] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[205] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[206] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[207] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[208] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[209] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[210] = 
    "                                             \n                                               ".toCharArray();
    __oracle_jsp_text[211] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[212] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[213] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[214] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[215] = 
    "\n                                                                <a href=\"#\" ><img src=\"".toCharArray();
    __oracle_jsp_text[216] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\n                                                            ".toCharArray();
    __oracle_jsp_text[217] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[218] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[219] = 
    "\n                                                                <a href=\"#\" onClick=\"showCalendarWithTime('bookingValue[".toCharArray();
    __oracle_jsp_text[220] = 
    "].mloETADate', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[221] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" styleClass = \"non_edit\" readonly=\"true\" class=\"calender\"></a>\n                                                            ".toCharArray();
    __oracle_jsp_text[222] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[223] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[224] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[225] = 
    "\n                                                            <a href=\"#\" onClick=\"showCalendarWithTime('bookingValue[".toCharArray();
    __oracle_jsp_text[226] = 
    "].mloETADate', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[227] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\n                                                        ".toCharArray();
    __oracle_jsp_text[228] = 
    "    \n                                                ".toCharArray();
    __oracle_jsp_text[229] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[230] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[231] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[232] = 
    "\n                                                                 ".toCharArray();
    __oracle_jsp_text[233] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[234] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[235] = 
    "\n                                                                 ".toCharArray();
    __oracle_jsp_text[236] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[237] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[238] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[239] = 
    "\n                                                             ".toCharArray();
    __oracle_jsp_text[240] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[241] = 
    "                                                   \n                                                ".toCharArray();
    __oracle_jsp_text[242] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[243] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[244] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[245] = 
    "\n                                                                  ".toCharArray();
    __oracle_jsp_text[246] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[247] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[248] = 
    "\n                                                                  ".toCharArray();
    __oracle_jsp_text[249] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[250] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[251] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[252] = 
    "\n                                                              ".toCharArray();
    __oracle_jsp_text[253] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[254] = 
    "                                                    \n                                                ".toCharArray();
    __oracle_jsp_text[255] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[256] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[257] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[258] = 
    "\n                                                                 ".toCharArray();
    __oracle_jsp_text[259] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[260] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[261] = 
    "\n                                                                 ".toCharArray();
    __oracle_jsp_text[262] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[263] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[264] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[265] = 
    "\n                                                              ".toCharArray();
    __oracle_jsp_text[266] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[267] = 
    "                                                    \n                                                ".toCharArray();
    __oracle_jsp_text[268] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[269] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[270] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[271] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[272] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[273] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[274] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[275] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[276] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[277] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[278] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[279] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[280] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[281] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[282] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[283] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[284] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[285] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[286] = 
    "\n                                                    <a href=\"#\" onClick=\"showCalendarWithTime('bookingValue[".toCharArray();
    __oracle_jsp_text[287] = 
    "].exMloETADate', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[288] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\n                                                ".toCharArray();
    __oracle_jsp_text[289] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[290] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[291] = 
    "\n                                                    <input type=\"button\" value=\". . .\" name=\"btnHandlingInsCodeLookup\" class=\"btnbutton\" onclick='return openHandlingInsCodeLookup1((".toCharArray();
    __oracle_jsp_text[292] = 
    "))'/>\n                                                ".toCharArray();
    __oracle_jsp_text[293] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[294] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[295] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[296] = 
    "\n                                                    <input type=\"button\" value=\". . .\" name=\"btnHandlingInsCodeLookup\" class=\"btnbutton\" onclick='return openHandlingInsCodeLookup2(".toCharArray();
    __oracle_jsp_text[297] = 
    ")'/>\n                                                ".toCharArray();
    __oracle_jsp_text[298] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[299] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[300] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[301] = 
    "\n                                                    <input type=\"button\" value=\". . .\" name=\"btnHandlingInsCodeLookup\" class=\"btnbutton\" onclick='return openHandlingInsCodeLookup3(".toCharArray();
    __oracle_jsp_text[302] = 
    ")'/>\n                                                ".toCharArray();
    __oracle_jsp_text[303] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[304] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[305] = 
    "\n                                                   <!-- ".toCharArray();
    __oracle_jsp_text[306] = 
    "-->\n                                                    ".toCharArray();
    __oracle_jsp_text[307] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[308] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[309] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[310] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[311] = 
    "\n                                                    <!-- ".toCharArray();
    __oracle_jsp_text[312] = 
    " -->\n                                                    ".toCharArray();
    __oracle_jsp_text[313] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[314] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[315] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[316] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[317] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[318] = 
    "\n\n                                                                ".toCharArray();
    __oracle_jsp_text[319] = 
    "\n                                                                    ".toCharArray();
    __oracle_jsp_text[320] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[321] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[322] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[323] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[324] = 
    "\n                                                                    ".toCharArray();
    __oracle_jsp_text[325] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[326] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[327] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[328] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[329] = 
    "\n                                                         ".toCharArray();
    __oracle_jsp_text[330] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[331] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[332] = 
    "\n                                                \n                                                 <!-- *1: start -->\n                                                 \n                                                ".toCharArray();
    __oracle_jsp_text[333] = 
    "\n\n                                                \n                                                ".toCharArray();
    __oracle_jsp_text[334] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[335] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[336] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[337] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[338] = 
    "\n                                                        <input type=\"button\" value=\". . .\" name=\"btnUNNoLookup\" class=\"btnbutton\" onclick='return openUNNoLookup(".toCharArray();
    __oracle_jsp_text[339] = 
    ")' disabled='true' />\n                                                    ".toCharArray();
    __oracle_jsp_text[340] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[341] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[342] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[343] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[344] = 
    "\n                                            \n                                                ".toCharArray();
    __oracle_jsp_text[345] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[346] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[347] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[348] = 
    "\n                                                        <input type=\"button\" value=\". . .\" name=\"btnUNNoLookup\" class=\"btnbutton\" onclick='return openUNNoLookup(".toCharArray();
    __oracle_jsp_text[349] = 
    ")'/>\n                                                    ".toCharArray();
    __oracle_jsp_text[350] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[351] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[352] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[353] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[354] = 
    "\n                                                <!-- *1: end -->\n                                                \n                                                ".toCharArray();
    __oracle_jsp_text[355] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[356] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[357] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[358] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[359] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[360] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[361] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[362] = 
    "\n                                                                    ".toCharArray();
    __oracle_jsp_text[363] = 
    "\n                                                                ".toCharArray();
    __oracle_jsp_text[364] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[365] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[366] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[367] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[368] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[369] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[370] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[371] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[372] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[373] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[374] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[375] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[376] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[377] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[378] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[379] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[380] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[381] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[382] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[383] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[384] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[385] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[386] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[387] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[388] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[389] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[390] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[391] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[392] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[393] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[394] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[395] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[396] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[397] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[398] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[399] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[400] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[401] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[402] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[403] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[404] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[405] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[406] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[407] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[408] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[409] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[410] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[411] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[412] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[413] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[414] = 
    "\n                                                            ".toCharArray();
    __oracle_jsp_text[415] = 
    "\n                                                        ".toCharArray();
    __oracle_jsp_text[416] = 
    "\n                                                    ".toCharArray();
    __oracle_jsp_text[417] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[418] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[419] = 
    "\n\n                                                ".toCharArray();
    __oracle_jsp_text[420] = 
    "\n                                                ".toCharArray();
    __oracle_jsp_text[421] = 
    "\n\n  ".toCharArray();
    __oracle_jsp_text[422] = 
    "\n                        ".toCharArray();
    __oracle_jsp_text[423] = 
    "\n\n                    ".toCharArray();
    __oracle_jsp_text[424] = 
    "\n\n\n                </div>\n            </td>\n\n    </tr>\n    ".toCharArray();
    __oracle_jsp_text[425] = 
    "\n    <!-- Row to Store Fixed Table Body -->\n    <tr height=\"270px\" valign=\"top\">\n\n            <!-- Start Store Fixed Table Header -->\n            <td >\n                <div id=\"fixedColumns_bodyDiv\" CLASS='clsNoScroll'  style='height:270px;'>\n                    <table id=\"tableFixedColumns\" class=\"table_results\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n                        <tbody>\n                            ".toCharArray();
    __oracle_jsp_text[426] = 
    "\n                                <tr id='".toCharArray();
    __oracle_jsp_text[427] = 
    "' height=\"27px\">\n                                    <td width=\"12%\" class=\"center\">\n                                        ".toCharArray();
    __oracle_jsp_text[428] = 
    "\n                                    </td>\n                                    <td width=\"18%\">\n                                        ".toCharArray();
    __oracle_jsp_text[429] = 
    "\n                                    </td>\n                                    <td width=\"40%\">\n                                        ".toCharArray();
    __oracle_jsp_text[430] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[431] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[432] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[433] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[434] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[435] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[436] = 
    " <!--##01 -->\n                                    </td>\n                                    ".toCharArray();
    __oracle_jsp_text[437] = 
    "\n                                        <td width=\"30%\">\n                                            ".toCharArray();
    __oracle_jsp_text[438] = 
    "\n                                        </td>\n                                    ".toCharArray();
    __oracle_jsp_text[439] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[440] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[441] = 
    "\n                                            <td width=\"30%\">\n                                                ".toCharArray();
    __oracle_jsp_text[442] = 
    "\n                                            </td>\n                                        ".toCharArray();
    __oracle_jsp_text[443] = 
    "\n                                        ".toCharArray();
    __oracle_jsp_text[444] = 
    "\n                                            <td width=\"30%\">\n                                                ".toCharArray();
    __oracle_jsp_text[445] = 
    "\n                                            </td>\n                                        ".toCharArray();
    __oracle_jsp_text[446] = 
    "\n                                    ".toCharArray();
    __oracle_jsp_text[447] = 
    "\n\n                                </tr>\n                            ".toCharArray();
    __oracle_jsp_text[448] = 
    "\n                        </tbody>\n                    </table>\n                </div>\n            </td>\n    </tr>\n\n</table>\n</div>\n".toCharArray();
    __oracle_jsp_text[449] = 
    "\n\n    <script language=\"JavaScript\">\n        initialize();\n    //    highlightRow(0);\n    </script>\n\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
