package _pages._edl;

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


public class _EdlDischargeListMaintenanceBookedTabGrid extends com.orionserver.http.OrionHttpJspPage {


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
    _EdlDischargeListMaintenanceBookedTabGrid page = this;
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
        __jsp_taghandler_2.setName("fedl002");
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
                    __jsp_taghandler_6.setLabel("Size");
                    __jsp_taghandler_6.setWidth("50px");
                    __jsp_taghandler_6.setId("size");
                    __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
                    if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,3);
                  }
                  out.write(__oracle_jsp_text[23]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_7=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_7.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_7.setLabel("Equipment Type");
                    __jsp_taghandler_7.setWidth("50px");
                    __jsp_taghandler_7.setId("equipmentType");
                    __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
                    if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,3);
                  }
                  out.write(__oracle_jsp_text[24]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_8=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_8.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_8.setLabel("Full/MT");
                    __jsp_taghandler_8.setWidth("50px");
                    __jsp_taghandler_8.setId("fullMT");
                    __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
                    if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,3);
                  }
                  out.write(__oracle_jsp_text[25]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_9=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_9.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_9.setLabel("Booking Type");
                    __jsp_taghandler_9.setWidth("50px");
                    __jsp_taghandler_9.setId("bookingType");
                    __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
                    if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,3);
                  }
                  out.write(__oracle_jsp_text[26]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_10=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_10.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_10.setLabel("SOC/COC");
                    __jsp_taghandler_10.setWidth("50px");
                    __jsp_taghandler_10.setId("socCoc");
                    __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
                    if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,3);
                  }
                  out.write(__oracle_jsp_text[27]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_11=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_11.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_11.setLabel("Shipment Term");
                    __jsp_taghandler_11.setWidth("50px");
                    __jsp_taghandler_11.setId("shipmentTerm");
                    __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
                    if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,3);
                  }
                  out.write(__oracle_jsp_text[28]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_12=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_12.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_12.setLabel("Shipment Type");
                    __jsp_taghandler_12.setWidth("50px");
                    __jsp_taghandler_12.setId("shipmentType");
                    __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
                    if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,3);
                  }
                  out.write(__oracle_jsp_text[29]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_13=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_13.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_13.setLabel("POD Status");
                    __jsp_taghandler_13.setWidth("50px");
                    __jsp_taghandler_13.setId("podStatus");
                    __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
                    if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,3);
                  }
                  out.write(__oracle_jsp_text[30]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_14=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_14.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_14.setLabel("Local Container Status");
                    __jsp_taghandler_14.setWidth("50px");
                    __jsp_taghandler_14.setId("localContSts");
                    __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
                    if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,3);
                  }
                  out.write(__oracle_jsp_text[31]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_15=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_15.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_15.setLabel("Midstream");
                    __jsp_taghandler_15.setWidth("50px");
                    __jsp_taghandler_15.setId("midstream");
                    __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                    if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,3);
                  }
                  out.write(__oracle_jsp_text[32]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_16=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_16.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_16.setLabel("Load Condition");
                    __jsp_taghandler_16.setWidth("50px");
                    __jsp_taghandler_16.setId("loadCondition");
                    __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
                    if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,3);
                  }
                  out.write(__oracle_jsp_text[33]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_17=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_17.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_17.setLabel("Loading Status");
                    __jsp_taghandler_17.setWidth("50px");
                    __jsp_taghandler_17.setId("loadingStatus");
                    __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
                    if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,3);
                  }
                  out.write(__oracle_jsp_text[34]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_18=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_18.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_18.setLabel("Discharge Status");
                    __jsp_taghandler_18.setWidth("50px");
                    __jsp_taghandler_18.setId("dischargeSts");
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
                    __jsp_taghandler_25.setLabel("Slot Operator");
                    __jsp_taghandler_25.setWidth("50px");
                    __jsp_taghandler_25.setId("slotOperator");
                    __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
                    if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,3);
                  }
                  out.write(__oracle_jsp_text[42]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_26=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_26.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_26.setLabel("Container Operator");
                    __jsp_taghandler_26.setWidth("50px");
                    __jsp_taghandler_26.setId("contOperator");
                    __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
                    if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,3);
                  }
                  out.write(__oracle_jsp_text[43]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_27=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_27.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_27.setLabel("Out Slot Operator");
                    __jsp_taghandler_27.setWidth("50px");
                    __jsp_taghandler_27.setId("outSlotOperator");
                    __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
                    if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,3);
                  }
                  out.write(__oracle_jsp_text[44]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_28=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_28.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_28.setLabel("Special Handling");
                    __jsp_taghandler_28.setWidth("50px");
                    __jsp_taghandler_28.setId("specialHandling");
                    __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
                    if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,3);
                  }
                  out.write(__oracle_jsp_text[45]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_29=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_29.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_29.setLabel("Seal No.");
                    __jsp_taghandler_29.setWidth("50px");
                    __jsp_taghandler_29.setId("sealNo");
                    __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
                    if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,3);
                  }
                  out.write(__oracle_jsp_text[46]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_30=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_30.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_30.setLabel("POL");
                    __jsp_taghandler_30.setWidth("50px");
                    __jsp_taghandler_30.setId("pol");
                    __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
                    if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,3);
                  }
                  out.write(__oracle_jsp_text[47]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_31=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_31.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_31.setLabel("POL Terminal");
                    __jsp_taghandler_31.setWidth("50px");
                    __jsp_taghandler_31.setId("polTerminal");
                    __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
                    if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,3);
                  }
                  out.write(__oracle_jsp_text[48]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_32=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_32.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_32.setLabel("Next POD1");
                    __jsp_taghandler_32.setWidth("50px");
                    __jsp_taghandler_32.setId("nextPOD1");
                    __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
                    if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,3);
                  }
                  out.write(__oracle_jsp_text[49]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_33=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_33.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_33.setLabel("Next POD2");
                    __jsp_taghandler_33.setWidth("50px");
                    __jsp_taghandler_33.setId("nextPOD2");
                    __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
                    if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,3);
                  }
                  out.write(__oracle_jsp_text[50]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_34=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_34.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_34.setLabel("Next POD3");
                    __jsp_taghandler_34.setWidth("50px");
                    __jsp_taghandler_34.setId("nextPOD3");
                    __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
                    if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,3);
                  }
                  out.write(__oracle_jsp_text[51]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_35=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_35.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_35.setLabel("Final POD");
                    __jsp_taghandler_35.setWidth("50px");
                    __jsp_taghandler_35.setId("finalPOD");
                    __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
                    if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,3);
                  }
                  out.write(__oracle_jsp_text[52]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_36=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_36.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_36.setLabel("Final Destination");
                    __jsp_taghandler_36.setWidth("50px");
                    __jsp_taghandler_36.setId("finalDest");
                    __jsp_tag_starteval=__jsp_taghandler_36.doStartTag();
                    if (__jsp_taghandler_36.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_36,3);
                  }
                  out.write(__oracle_jsp_text[53]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_37=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_37.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_37.setLabel("Next Service");
                    __jsp_taghandler_37.setWidth("50px");
                    __jsp_taghandler_37.setId("nextService");
                    __jsp_tag_starteval=__jsp_taghandler_37.doStartTag();
                    if (__jsp_taghandler_37.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_37,3);
                  }
                  out.write(__oracle_jsp_text[54]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_38=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_38.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_38.setLabel("Next Vessel");
                    __jsp_taghandler_38.setWidth("50px");
                    __jsp_taghandler_38.setId("nextVessel");
                    __jsp_tag_starteval=__jsp_taghandler_38.doStartTag();
                    if (__jsp_taghandler_38.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_38,3);
                  }
                  out.write(__oracle_jsp_text[55]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_39=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_39.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_39.setLabel("Next Voyage");
                    __jsp_taghandler_39.setWidth("50px");
                    __jsp_taghandler_39.setId("nextVoyage");
                    __jsp_tag_starteval=__jsp_taghandler_39.doStartTag();
                    if (__jsp_taghandler_39.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_39,3);
                  }
                  out.write(__oracle_jsp_text[56]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_40=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_40.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_40.setLabel("Next Direction");
                    __jsp_taghandler_40.setWidth("50px");
                    __jsp_taghandler_40.setId("nextDirection");
                    __jsp_tag_starteval=__jsp_taghandler_40.doStartTag();
                    if (__jsp_taghandler_40.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_40,3);
                  }
                  out.write(__oracle_jsp_text[57]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_41=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_41.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_41.setLabel("Connecting MLO Vessel");
                    __jsp_taghandler_41.setWidth("50px");
                    __jsp_taghandler_41.setId("connectingMLOVessel");
                    __jsp_tag_starteval=__jsp_taghandler_41.doStartTag();
                    if (__jsp_taghandler_41.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_41,3);
                  }
                  out.write(__oracle_jsp_text[58]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_42=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_42.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_42.setLabel("Connecting MLO Voyage");
                    __jsp_taghandler_42.setWidth("50px");
                    __jsp_taghandler_42.setId("connectingMLOVoyage");
                    __jsp_tag_starteval=__jsp_taghandler_42.doStartTag();
                    if (__jsp_taghandler_42.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_42,3);
                  }
                  out.write(__oracle_jsp_text[59]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_43=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_43.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_43.setLabel("MLO ETA Date");
                    __jsp_taghandler_43.setWidth("50px");
                    __jsp_taghandler_43.setId("mloETADate");
                    __jsp_tag_starteval=__jsp_taghandler_43.doStartTag();
                    if (__jsp_taghandler_43.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_43,3);
                  }
                  out.write(__oracle_jsp_text[60]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_44=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_44.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_44.setLabel("Connecting MLO POD1");
                    __jsp_taghandler_44.setWidth("50px");
                    __jsp_taghandler_44.setId("connectingMLOPOD1");
                    __jsp_tag_starteval=__jsp_taghandler_44.doStartTag();
                    if (__jsp_taghandler_44.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_44,3);
                  }
                  out.write(__oracle_jsp_text[61]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_45=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_45.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_45.setLabel("Connecting MLO POD2");
                    __jsp_taghandler_45.setWidth("50px");
                    __jsp_taghandler_45.setId("connectingMLOPOD2");
                    __jsp_tag_starteval=__jsp_taghandler_45.doStartTag();
                    if (__jsp_taghandler_45.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_45,3);
                  }
                  out.write(__oracle_jsp_text[62]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_46=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_46.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_46.setLabel("Connecting MLO POD3");
                    __jsp_taghandler_46.setWidth("50px");
                    __jsp_taghandler_46.setId("connectingMLOPOD3");
                    __jsp_tag_starteval=__jsp_taghandler_46.doStartTag();
                    if (__jsp_taghandler_46.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_46,3);
                  }
                  out.write(__oracle_jsp_text[63]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_47=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_47.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_47.setLabel("Place Of Delivery");
                    __jsp_taghandler_47.setWidth("50px");
                    __jsp_taghandler_47.setId("placeOfDel");
                    __jsp_tag_starteval=__jsp_taghandler_47.doStartTag();
                    if (__jsp_taghandler_47.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_47,3);
                  }
                  out.write(__oracle_jsp_text[64]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_48=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_48.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_48.setLabel("Swap Connection");
                    __jsp_taghandler_48.setWidth("50px");
                    __jsp_taghandler_48.setId("swapConnection");
                    __jsp_tag_starteval=__jsp_taghandler_48.doStartTag();
                    if (__jsp_taghandler_48.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_48,3);
                  }
                  out.write(__oracle_jsp_text[65]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_49=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_49.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_49.setLabel("Handling Instruction 1 Code");
                    __jsp_taghandler_49.setWidth("50px");
                    __jsp_taghandler_49.setId("handlingInstCode1");
                    __jsp_tag_starteval=__jsp_taghandler_49.doStartTag();
                    if (__jsp_taghandler_49.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_49,3);
                  }
                  out.write(__oracle_jsp_text[66]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_50=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_50.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_50.setLabel("Handling Instruction 1 Description");
                    __jsp_taghandler_50.setWidth("50px");
                    __jsp_taghandler_50.setId("handlingInstDesc1");
                    __jsp_tag_starteval=__jsp_taghandler_50.doStartTag();
                    if (__jsp_taghandler_50.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_50,3);
                  }
                  out.write(__oracle_jsp_text[67]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_51=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_51.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_51.setLabel("Handling Instruction 2 Code");
                    __jsp_taghandler_51.setWidth("50px");
                    __jsp_taghandler_51.setId("handlingInstCode2");
                    __jsp_tag_starteval=__jsp_taghandler_51.doStartTag();
                    if (__jsp_taghandler_51.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_51,3);
                  }
                  out.write(__oracle_jsp_text[68]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_52=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_52.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_52.setLabel("Handling Instruction 2 Description");
                    __jsp_taghandler_52.setWidth("50px");
                    __jsp_taghandler_52.setId("handlingInstDesc2");
                    __jsp_tag_starteval=__jsp_taghandler_52.doStartTag();
                    if (__jsp_taghandler_52.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_52,3);
                  }
                  out.write(__oracle_jsp_text[69]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_53=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_53.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_53.setLabel("Handling Instruction 3 Code");
                    __jsp_taghandler_53.setWidth("50px");
                    __jsp_taghandler_53.setId("handlingInstCode3");
                    __jsp_tag_starteval=__jsp_taghandler_53.doStartTag();
                    if (__jsp_taghandler_53.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_53,3);
                  }
                  out.write(__oracle_jsp_text[70]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_54=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_54.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_54.setLabel("Handling Instruction 3 Description");
                    __jsp_taghandler_54.setWidth("50px");
                    __jsp_taghandler_54.setId("handlingInstDesc3");
                    __jsp_tag_starteval=__jsp_taghandler_54.doStartTag();
                    if (__jsp_taghandler_54.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_54,3);
                  }
                  out.write(__oracle_jsp_text[71]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_55=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_55.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_55.setLabel("Container Loading Remark 1");
                    __jsp_taghandler_55.setWidth("50px");
                    __jsp_taghandler_55.setId("contLoadRemark1");
                    __jsp_tag_starteval=__jsp_taghandler_55.doStartTag();
                    if (__jsp_taghandler_55.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_55,3);
                  }
                  out.write(__oracle_jsp_text[72]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_56=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_56.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_56.setLabel("Container Loading Remark 2");
                    __jsp_taghandler_56.setWidth("50px");
                    __jsp_taghandler_56.setId("contLoadRemark2");
                    __jsp_tag_starteval=__jsp_taghandler_56.doStartTag();
                    if (__jsp_taghandler_56.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_56,3);
                  }
                  out.write(__oracle_jsp_text[73]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_57=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_57.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_57.setLabel("Special Cargo");
                    __jsp_taghandler_57.setWidth("50px");
                    __jsp_taghandler_57.setId("specialCargo");
                    __jsp_tag_starteval=__jsp_taghandler_57.doStartTag();
                    if (__jsp_taghandler_57.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_57,3);
                  }
                  out.write(__oracle_jsp_text[74]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_58=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_58.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_58.setLabel("Tight Connection @ POD1");
                    __jsp_taghandler_58.setWidth("50px");
                    __jsp_taghandler_58.setId("tightConnectionPOD1");
                    __jsp_tag_starteval=__jsp_taghandler_58.doStartTag();
                    if (__jsp_taghandler_58.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_58,3);
                  }
                  out.write(__oracle_jsp_text[75]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_59=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_59.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_59.setLabel("Tight Connection @ POD2");
                    __jsp_taghandler_59.setWidth("50px");
                    __jsp_taghandler_59.setId("tightConnectionPOD2");
                    __jsp_tag_starteval=__jsp_taghandler_59.doStartTag();
                    if (__jsp_taghandler_59.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_59,3);
                  }
                  out.write(__oracle_jsp_text[76]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_60=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_60.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_60.setLabel("Tight Connection @ POD3");
                    __jsp_taghandler_60.setWidth("50px");
                    __jsp_taghandler_60.setId("tightConnectionPOD3");
                    __jsp_tag_starteval=__jsp_taghandler_60.doStartTag();
                    if (__jsp_taghandler_60.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_60,3);
                  }
                  out.write(__oracle_jsp_text[77]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_61=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_61.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_61.setLabel("IMDG Class");
                    __jsp_taghandler_61.setWidth("50px");
                    __jsp_taghandler_61.setId("imdgClass");
                    __jsp_tag_starteval=__jsp_taghandler_61.doStartTag();
                    if (__jsp_taghandler_61.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_61,3);
                  }
                  out.write(__oracle_jsp_text[78]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_62=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_62.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_62.setLabel("UN Number");
                    __jsp_taghandler_62.setWidth("50px");
                    __jsp_taghandler_62.setId("unNumber");
                    __jsp_tag_starteval=__jsp_taghandler_62.doStartTag();
                    if (__jsp_taghandler_62.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_62,3);
                  }
                  out.write(__oracle_jsp_text[79]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_63=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_63.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_63.setLabel("UN Number Variant");
                    __jsp_taghandler_63.setWidth("50px");
                    __jsp_taghandler_63.setId("unNumberVariant");
                    __jsp_tag_starteval=__jsp_taghandler_63.doStartTag();
                    if (__jsp_taghandler_63.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_63,3);
                  }
                  out.write(__oracle_jsp_text[80]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_64=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_64.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_64.setLabel("Port Class");
                    __jsp_taghandler_64.setWidth("50px");
                    __jsp_taghandler_64.setId("portClass");
                    __jsp_tag_starteval=__jsp_taghandler_64.doStartTag();
                    if (__jsp_taghandler_64.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_64,3);
                  }
                  out.write(__oracle_jsp_text[81]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_65=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_65.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_65.setLabel("Port Class Type");
                    __jsp_taghandler_65.setWidth("50px");
                    __jsp_taghandler_65.setId("portClassType");
                    __jsp_tag_starteval=__jsp_taghandler_65.doStartTag();
                    if (__jsp_taghandler_65.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_65,3);
                  }
                  out.write(__oracle_jsp_text[82]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_66=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_66.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_66.setLabel("Flash Unit");
                    __jsp_taghandler_66.setWidth("50px");
                    __jsp_taghandler_66.setId("flashUnit");
                    __jsp_tag_starteval=__jsp_taghandler_66.doStartTag();
                    if (__jsp_taghandler_66.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_66,3);
                  }
                  out.write(__oracle_jsp_text[83]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_67=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_67.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_67.setLabel("Flash Point");
                    __jsp_taghandler_67.setWidth("50px");
                    __jsp_taghandler_67.setId("flashPoint");
                    __jsp_tag_starteval=__jsp_taghandler_67.doStartTag();
                    if (__jsp_taghandler_67.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_67,3);
                  }
                  out.write(__oracle_jsp_text[84]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_68=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_68.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_68.setLabel("Fumigation Only");
                    __jsp_taghandler_68.setWidth("50px");
                    __jsp_taghandler_68.setId("fumigationOnly");
                    __jsp_tag_starteval=__jsp_taghandler_68.doStartTag();
                    if (__jsp_taghandler_68.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_68,3);
                  }
                  out.write(__oracle_jsp_text[85]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_69=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_69.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_69.setLabel("Residue");
                    __jsp_taghandler_69.setWidth("50px");
                    __jsp_taghandler_69.setId("residue");
                    __jsp_tag_starteval=__jsp_taghandler_69.doStartTag();
                    if (__jsp_taghandler_69.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_69,3);
                  }
                  out.write(__oracle_jsp_text[86]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_70=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_70.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_70.setLabel("Overheight");
                    __jsp_taghandler_70.setWidth("50px");
                    __jsp_taghandler_70.setId("overheight");
                    __jsp_tag_starteval=__jsp_taghandler_70.doStartTag();
                    if (__jsp_taghandler_70.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_70,3);
                  }
                  out.write(__oracle_jsp_text[87]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_71=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_71.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_71.setLabel("Overwidth Left");
                    __jsp_taghandler_71.setWidth("50px");
                    __jsp_taghandler_71.setId("overwidthLeft");
                    __jsp_tag_starteval=__jsp_taghandler_71.doStartTag();
                    if (__jsp_taghandler_71.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_71,3);
                  }
                  out.write(__oracle_jsp_text[88]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_72=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_72.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_72.setLabel("Overwidth Right");
                    __jsp_taghandler_72.setWidth("50px");
                    __jsp_taghandler_72.setId("overwidthRight");
                    __jsp_tag_starteval=__jsp_taghandler_72.doStartTag();
                    if (__jsp_taghandler_72.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_72,3);
                  }
                  out.write(__oracle_jsp_text[89]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_73=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_73.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_73.setLabel("Overlength Front");
                    __jsp_taghandler_73.setWidth("50px");
                    __jsp_taghandler_73.setId("overlengthFront");
                    __jsp_tag_starteval=__jsp_taghandler_73.doStartTag();
                    if (__jsp_taghandler_73.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_73,3);
                  }
                  out.write(__oracle_jsp_text[90]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_74=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_74.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_74.setLabel("Overlength After");
                    __jsp_taghandler_74.setWidth("50px");
                    __jsp_taghandler_74.setId("overlengthAfter");
                    __jsp_tag_starteval=__jsp_taghandler_74.doStartTag();
                    if (__jsp_taghandler_74.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_74,3);
                  }
                  out.write(__oracle_jsp_text[91]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_75=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_75.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_75.setLabel("Reefer Temperature");
                    __jsp_taghandler_75.setWidth("50px");
                    __jsp_taghandler_75.setId("reeferTemp");
                    __jsp_tag_starteval=__jsp_taghandler_75.doStartTag();
                    if (__jsp_taghandler_75.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_75,3);
                  }
                  out.write(__oracle_jsp_text[92]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_76=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_76.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_76.setLabel("Reefer Temperature Unit");
                    __jsp_taghandler_76.setWidth("50px");
                    __jsp_taghandler_76.setId("reeferTempUnit");
                    __jsp_tag_starteval=__jsp_taghandler_76.doStartTag();
                    if (__jsp_taghandler_76.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_76,3);
                  }
                  out.write(__oracle_jsp_text[93]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_77=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_77.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_77.setLabel("Humidity");
                    __jsp_taghandler_77.setWidth("50px");
                    __jsp_taghandler_77.setId("humidity");
                    __jsp_tag_starteval=__jsp_taghandler_77.doStartTag();
                    if (__jsp_taghandler_77.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_77,3);
                  }
                  out.write(__oracle_jsp_text[94]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_78=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_78.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_78.setLabel("Ventilation");
                    __jsp_taghandler_78.setWidth("50px");
                    __jsp_taghandler_78.setId("ventilation");
                    __jsp_tag_starteval=__jsp_taghandler_78.doStartTag();
                    if (__jsp_taghandler_78.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_78,3);
                  }
                  out.write(__oracle_jsp_text[95]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_79=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_79.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_79.setLabel("Remarks");
                    __jsp_taghandler_79.setWidth("50px");
                    __jsp_taghandler_79.setId("remarks");
                    __jsp_tag_starteval=__jsp_taghandler_79.doStartTag();
                    if (__jsp_taghandler_79.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_79,3);
                  }
                  out.write(__oracle_jsp_text[96]);
                } while (__jsp_taghandler_4.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[97]);
            {
              com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag __jsp_taghandler_80=(com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag collection var rowPerPage rowCountVar");
              __jsp_taghandler_80.setParent(__jsp_taghandler_3);
              __jsp_taghandler_80.setCollection((java.util.Collection)oracle.jsp.runtime.OracleJspRuntime.evaluate("${KEY_SCREEN_GRID_DATA}",java.util.Collection.class, __ojsp_varRes,null));
              __jsp_taghandler_80.setVar("col");
              __jsp_taghandler_80.setRowPerPage(1000);
              __jsp_taghandler_80.setRowCountVar("rowCount");
              __jsp_tag_starteval=__jsp_taghandler_80.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[98]);
                  {
                    com.ideo.sweetdevria.taglib.grid.common.GridRowTag __jsp_taghandler_81=(com.ideo.sweetdevria.taglib.grid.common.GridRowTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.common.GridRowTag.class,"com.ideo.sweetdevria.taglib.grid.common.GridRowTag id");
                    __jsp_taghandler_81.setParent(__jsp_taghandler_80);
                    __jsp_taghandler_81.setId((java.lang.String) ("row"+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)));
                    __jsp_tag_starteval=__jsp_taghandler_81.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[99]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_82=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_82.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_82.setId("billNo");
                          __jsp_tag_starteval=__jsp_taghandler_82.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_82,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[100]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_83=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_83.setParent(__jsp_taghandler_82);
                                __jsp_taghandler_83.setMaxlength("17");
                                __jsp_taghandler_83.setName("fedl002");
                                __jsp_taghandler_83.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].billNo"));
                                __jsp_taghandler_83.setReadonly(true);
                                __jsp_taghandler_83.setStyle("width:96%");
                                __jsp_taghandler_83.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_83.doStartTag();
                                if (__jsp_taghandler_83.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_83,5);
                              }
                              out.write(__oracle_jsp_text[101]);
                            } while (__jsp_taghandler_82.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_82.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_82,4);
                        }
                        out.write(__oracle_jsp_text[102]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_84=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_84.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_84.setId("size");
                          __jsp_tag_starteval=__jsp_taghandler_84.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_84,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_85=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_85.setParent(__jsp_taghandler_84);
                                __jsp_taghandler_85.setMaxlength("2");
                                __jsp_taghandler_85.setName("fedl002");
                                __jsp_taghandler_85.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].size"));
                                __jsp_taghandler_85.setReadonly(true);
                                __jsp_taghandler_85.setStyle("width:96%");
                                __jsp_taghandler_85.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_85.doStartTag();
                                if (__jsp_taghandler_85.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_85,5);
                              }
                            } while (__jsp_taghandler_84.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_84.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_84,4);
                        }
                        out.write(__oracle_jsp_text[103]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_86=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_86.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_86.setId("equipmentType");
                          __jsp_tag_starteval=__jsp_taghandler_86.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_86,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_87=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_87.setParent(__jsp_taghandler_86);
                                __jsp_taghandler_87.setMaxlength("2");
                                __jsp_taghandler_87.setName("fedl002");
                                __jsp_taghandler_87.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].equipmentType"));
                                __jsp_taghandler_87.setReadonly(true);
                                __jsp_taghandler_87.setStyle("width:96%");
                                __jsp_taghandler_87.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_87.doStartTag();
                                if (__jsp_taghandler_87.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_87,5);
                              }
                            } while (__jsp_taghandler_86.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_86.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_86,4);
                        }
                        out.write(__oracle_jsp_text[104]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_88=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_88.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_88.setId("fullMT");
                          __jsp_tag_starteval=__jsp_taghandler_88.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_88,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_89=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_89.setParent(__jsp_taghandler_88);
                                __jsp_taghandler_89.setMaxlength("1");
                                __jsp_taghandler_89.setName("fedl002");
                                __jsp_taghandler_89.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                __jsp_taghandler_89.setReadonly(true);
                                __jsp_taghandler_89.setStyle("width:96%");
                                __jsp_taghandler_89.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_89.doStartTag();
                                if (__jsp_taghandler_89.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_89,5);
                              }
                            } while (__jsp_taghandler_88.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_88.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_88,4);
                        }
                        out.write(__oracle_jsp_text[105]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_90=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_90.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_90.setId("bookingType");
                          __jsp_tag_starteval=__jsp_taghandler_90.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_90,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_91=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_91.setParent(__jsp_taghandler_90);
                                __jsp_taghandler_91.setMaxlength("2");
                                __jsp_taghandler_91.setName("fedl002");
                                __jsp_taghandler_91.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].bookingType"));
                                __jsp_taghandler_91.setReadonly(true);
                                __jsp_taghandler_91.setStyle("width:96%");
                                __jsp_taghandler_91.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_91.doStartTag();
                                if (__jsp_taghandler_91.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_91,5);
                              }
                            } while (__jsp_taghandler_90.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_90.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_90,4);
                        }
                        out.write(__oracle_jsp_text[106]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_92=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_92.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_92.setId("socCoc");
                          __jsp_tag_starteval=__jsp_taghandler_92.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_92,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_93=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_93.setParent(__jsp_taghandler_92);
                                __jsp_taghandler_93.setMaxlength("1");
                                __jsp_taghandler_93.setName("fedl002");
                                __jsp_taghandler_93.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_93.setReadonly(true);
                                __jsp_taghandler_93.setStyle("width:96%");
                                __jsp_taghandler_93.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_93.doStartTag();
                                if (__jsp_taghandler_93.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_93,5);
                              }
                            } while (__jsp_taghandler_92.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_92.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_92,4);
                        }
                        out.write(__oracle_jsp_text[107]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_94=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_94.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_94.setId("shipmentTerm");
                          __jsp_tag_starteval=__jsp_taghandler_94.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_94,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_95=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_95.setParent(__jsp_taghandler_94);
                                __jsp_taghandler_95.setMaxlength("4");
                                __jsp_taghandler_95.setName("fedl002");
                                __jsp_taghandler_95.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].shipmentTerm"));
                                __jsp_taghandler_95.setReadonly(true);
                                __jsp_taghandler_95.setStyle("width:96%");
                                __jsp_taghandler_95.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_95.doStartTag();
                                if (__jsp_taghandler_95.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_95,5);
                              }
                            } while (__jsp_taghandler_94.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_94.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_94,4);
                        }
                        out.write(__oracle_jsp_text[108]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_96=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_96.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_96.setId("shipmentType");
                          __jsp_tag_starteval=__jsp_taghandler_96.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_96,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_97=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_97.setParent(__jsp_taghandler_96);
                                __jsp_taghandler_97.setMaxlength("3");
                                __jsp_taghandler_97.setName("fedl002");
                                __jsp_taghandler_97.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].shipmentType"));
                                __jsp_taghandler_97.setReadonly(true);
                                __jsp_taghandler_97.setStyle("width:96%");
                                __jsp_taghandler_97.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_97.doStartTag();
                                if (__jsp_taghandler_97.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_97,5);
                              }
                            } while (__jsp_taghandler_96.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_96.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_96,4);
                        }
                        out.write(__oracle_jsp_text[109]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_98=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_98.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_98.setId("podStatus");
                          __jsp_tag_starteval=__jsp_taghandler_98.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_98,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_99=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_99.setParent(__jsp_taghandler_98);
                                __jsp_taghandler_99.setMaxlength("1");
                                __jsp_taghandler_99.setName("fedl002");
                                __jsp_taghandler_99.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].podStatus"));
                                __jsp_taghandler_99.setReadonly(true);
                                __jsp_taghandler_99.setStyle("width:96%");
                                __jsp_taghandler_99.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_99.doStartTag();
                                if (__jsp_taghandler_99.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_99,5);
                              }
                            } while (__jsp_taghandler_98.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_98.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_98,4);
                        }
                        out.write(__oracle_jsp_text[110]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_100=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_100.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_100.setId("localContSts");
                          __jsp_tag_starteval=__jsp_taghandler_100.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_100,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[111]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_101=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_101.setParent(__jsp_taghandler_100);
                                __jsp_taghandler_101.setMaxlength("10");
                                __jsp_taghandler_101.setName("fedl002");
                                __jsp_taghandler_101.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_101.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].localContSts"));
                                __jsp_taghandler_101.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_101.doStartTag();
                                if (__jsp_taghandler_101.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_101,5);
                              }
                              out.write(__oracle_jsp_text[112]);
                              out.write(__oracle_jsp_text[113]);
                            } while (__jsp_taghandler_100.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_100.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_100,4);
                        }
                        out.write(__oracle_jsp_text[114]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_102=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_102.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_102.setId("midstream");
                          __jsp_tag_starteval=__jsp_taghandler_102.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_102,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[115]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_103=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_103.setParent(__jsp_taghandler_102);
                                __jsp_taghandler_103.setName("fedl002");
                                __jsp_taghandler_103.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_103.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].midstream"));
                                __jsp_taghandler_103.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_103.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_103,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[116]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_104=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_104.setParent(__jsp_taghandler_103);
                                      __jsp_taghandler_104.setLabel("name");
                                      __jsp_taghandler_104.setName("fedl002");
                                      __jsp_taghandler_104.setProperty("midstreamValues");
                                      __jsp_taghandler_104.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_104.doStartTag();
                                      if (__jsp_taghandler_104.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_104,6);
                                    }
                                    out.write(__oracle_jsp_text[117]);
                                  } while (__jsp_taghandler_103.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_103.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_103,5);
                              }
                              out.write(__oracle_jsp_text[118]);
                            } while (__jsp_taghandler_102.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_102.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_102,4);
                        }
                        out.write(__oracle_jsp_text[119]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_105=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_105.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_105.setId("loadCondition");
                          __jsp_tag_starteval=__jsp_taghandler_105.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_105,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[120]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_106=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_106.setParent(__jsp_taghandler_105);
                                __jsp_taghandler_106.setName("fedl002");
                                __jsp_taghandler_106.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_106.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].loadCondition"));
                                __jsp_taghandler_106.setStyle("width:96%;height:20px");
                                __jsp_tag_starteval=__jsp_taghandler_106.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_106,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[121]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_107=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_107.setParent(__jsp_taghandler_106);
                                      __jsp_taghandler_107.setLabel("name");
                                      __jsp_taghandler_107.setName("fedl002");
                                      __jsp_taghandler_107.setProperty("loadConditionValues");
                                      __jsp_taghandler_107.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_107.doStartTag();
                                      if (__jsp_taghandler_107.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_107,6);
                                    }
                                    out.write(__oracle_jsp_text[122]);
                                  } while (__jsp_taghandler_106.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_106.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_106,5);
                              }
                              out.write(__oracle_jsp_text[123]);
                            } while (__jsp_taghandler_105.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_105.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_105,4);
                        }
                        out.write(__oracle_jsp_text[124]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_108=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_108.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_108.setId("loadingStatus");
                          __jsp_tag_starteval=__jsp_taghandler_108.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_108,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_109=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_109.setParent(__jsp_taghandler_108);
                                __jsp_taghandler_109.setMaxlength("20");
                                __jsp_taghandler_109.setName("fedl002");
                                __jsp_taghandler_109.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].loadingStatus"));
                                __jsp_taghandler_109.setReadonly(true);
                                __jsp_taghandler_109.setStyle("width:96%");
                                __jsp_taghandler_109.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_109.doStartTag();
                                if (__jsp_taghandler_109.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_109,5);
                              }
                            } while (__jsp_taghandler_108.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_108.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_108,4);
                        }
                        out.write(__oracle_jsp_text[125]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_110=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_110.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_110.setId("dischargeSts");
                          __jsp_tag_starteval=__jsp_taghandler_110.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_110,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[126]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_111=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style styleClass");
                                __jsp_taghandler_111.setParent(__jsp_taghandler_110);
                                __jsp_taghandler_111.setName("fedl002");
                                __jsp_taghandler_111.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_111.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].dischargeSts"));
                                __jsp_taghandler_111.setStyle("width:96%;height:20px");
                                __jsp_taghandler_111.setStyleClass("must");
                                __jsp_tag_starteval=__jsp_taghandler_111.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_111,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[127]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_112=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_112.setParent(__jsp_taghandler_111);
                                      __jsp_taghandler_112.setLabel("name");
                                      __jsp_taghandler_112.setName("fedl002");
                                      __jsp_taghandler_112.setProperty("dischargeStsValues");
                                      __jsp_taghandler_112.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_112.doStartTag();
                                      if (__jsp_taghandler_112.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_112,6);
                                    }
                                    out.write(__oracle_jsp_text[128]);
                                  } while (__jsp_taghandler_111.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_111.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_111,5);
                              }
                              out.write(__oracle_jsp_text[129]);
                            } while (__jsp_taghandler_110.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_110.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_110,4);
                        }
                        out.write(__oracle_jsp_text[130]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_113=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_113.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_113.setId("stowPosition");
                          __jsp_tag_starteval=__jsp_taghandler_113.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_113,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_114=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onchange property style");
                                __jsp_taghandler_114.setParent(__jsp_taghandler_113);
                                __jsp_taghandler_114.setMaxlength("7");
                                __jsp_taghandler_114.setName("fedl002");
                                __jsp_taghandler_114.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_114.setOnchange((java.lang.String) ("onChangeStowagePosition("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_114.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].stowPosition"));
                                __jsp_taghandler_114.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_114.doStartTag();
                                if (__jsp_taghandler_114.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_114,5);
                              }
                            } while (__jsp_taghandler_113.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_113.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_113,4);
                        }
                        out.write(__oracle_jsp_text[131]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_115=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_115.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_115.setId("activityDate");
                          __jsp_tag_starteval=__jsp_taghandler_115.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_115,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[132]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_116=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_116.setParent(__jsp_taghandler_115);
                                __jsp_taghandler_116.setMaxlength("16");
                                __jsp_taghandler_116.setName("fedl002");
                                __jsp_taghandler_116.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_116.setOnclick("this.select();");
                                __jsp_taghandler_116.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].activityDate"));
                                __jsp_taghandler_116.setStyle("width:60%");
                                __jsp_tag_starteval=__jsp_taghandler_116.doStartTag();
                                if (__jsp_taghandler_116.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_116,5);
                              }
                              out.write(__oracle_jsp_text[133]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[134]);
                              out.print(lstrContextPath);
                              out.write(__oracle_jsp_text[135]);
                            } while (__jsp_taghandler_115.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_115.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_115,4);
                        }
                        out.write(__oracle_jsp_text[136]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_117=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_117.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_117.setId("weight");
                          __jsp_tag_starteval=__jsp_taghandler_117.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_117,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_118=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_118.setParent(__jsp_taghandler_117);
                                __jsp_taghandler_118.setMaxlength("15");
                                __jsp_taghandler_118.setName("fedl002");
                                __jsp_taghandler_118.setOnblur((java.lang.String) ("putMask_Number(this, 12, 2);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_118.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_118.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].weight"));
                                __jsp_taghandler_118.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_118.doStartTag();
                                if (__jsp_taghandler_118.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_118,5);
                              }
                            } while (__jsp_taghandler_117.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_117.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_117,4);
                        }
                        out.write(__oracle_jsp_text[137]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_119=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_119.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_119.setId("damaged");
                          __jsp_tag_starteval=__jsp_taghandler_119.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_119,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[138]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_120=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_120.setParent(__jsp_taghandler_119);
                                __jsp_taghandler_120.setName("fedl002");
                                __jsp_taghandler_120.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_120.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].damaged"));
                                __jsp_taghandler_120.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_120.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_120,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[139]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_121=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_121.setParent(__jsp_taghandler_120);
                                      __jsp_taghandler_121.setLabel("name");
                                      __jsp_taghandler_121.setName("fedl002");
                                      __jsp_taghandler_121.setProperty("damagedValues");
                                      __jsp_taghandler_121.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_121.doStartTag();
                                      if (__jsp_taghandler_121.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_121,6);
                                    }
                                    out.write(__oracle_jsp_text[140]);
                                  } while (__jsp_taghandler_120.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_120.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_120,5);
                              }
                              out.write(__oracle_jsp_text[141]);
                            } while (__jsp_taghandler_119.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_119.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_119,4);
                        }
                        out.write(__oracle_jsp_text[142]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_122=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_122.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_122.setId("craneDescription");
                          __jsp_tag_starteval=__jsp_taghandler_122.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_122,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[143]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_123=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_123.setParent(__jsp_taghandler_122);
                                __jsp_taghandler_123.setName("fedl002");
                                __jsp_taghandler_123.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_123.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].craneDescription"));
                                __jsp_taghandler_123.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_123.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_123,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[144]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_124=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_124.setParent(__jsp_taghandler_123);
                                      __jsp_taghandler_124.setLabel("name");
                                      __jsp_taghandler_124.setName("fedl002");
                                      __jsp_taghandler_124.setProperty("craneDescriptionValues");
                                      __jsp_taghandler_124.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_124.doStartTag();
                                      if (__jsp_taghandler_124.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_124,6);
                                    }
                                    out.write(__oracle_jsp_text[145]);
                                  } while (__jsp_taghandler_123.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_123.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_123,5);
                              }
                              out.write(__oracle_jsp_text[146]);
                            } while (__jsp_taghandler_122.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_122.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_122,4);
                        }
                        out.write(__oracle_jsp_text[147]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_125=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_125.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_125.setId("voidSlot");
                          __jsp_tag_starteval=__jsp_taghandler_125.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_125,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_126=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_126.setParent(__jsp_taghandler_125);
                                __jsp_taghandler_126.setMaxlength("6");
                                __jsp_taghandler_126.setName("fedl002");
                                __jsp_taghandler_126.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].voidSlot"));
                                __jsp_taghandler_126.setReadonly(true);
                                __jsp_taghandler_126.setStyle("width:96%");
                                __jsp_taghandler_126.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_126.doStartTag();
                                if (__jsp_taghandler_126.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_126,5);
                              }
                            } while (__jsp_taghandler_125.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_125.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_125,4);
                        }
                        out.write(__oracle_jsp_text[148]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_127=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_127.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_127.setId("slotOperator");
                          __jsp_tag_starteval=__jsp_taghandler_127.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_127,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_128=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_128.setParent(__jsp_taghandler_127);
                                __jsp_taghandler_128.setMaxlength("4");
                                __jsp_taghandler_128.setName("fedl002");
                                __jsp_taghandler_128.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].slotOperator"));
                                __jsp_taghandler_128.setReadonly(true);
                                __jsp_taghandler_128.setStyle("width:96%");
                                __jsp_taghandler_128.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_128.doStartTag();
                                if (__jsp_taghandler_128.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_128,5);
                              }
                            } while (__jsp_taghandler_127.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_127.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_127,4);
                        }
                        out.write(__oracle_jsp_text[149]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_129=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_129.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_129.setName("fedl002");
                          __jsp_taghandler_129.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                          __jsp_taghandler_129.setValue("COC");
                          __jsp_tag_starteval=__jsp_taghandler_129.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[150]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_130=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_130.setParent(__jsp_taghandler_129);
                                __jsp_taghandler_130.setId("contOperator");
                                __jsp_tag_starteval=__jsp_taghandler_130.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_130,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[151]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_131=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                      __jsp_taghandler_131.setParent(__jsp_taghandler_130);
                                      __jsp_taghandler_131.setMaxlength("4");
                                      __jsp_taghandler_131.setName("fedl002");
                                      __jsp_taghandler_131.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contOperator"));
                                      __jsp_taghandler_131.setReadonly(true);
                                      __jsp_taghandler_131.setStyle("width:96%");
                                      __jsp_taghandler_131.setStyleClass("non_edit");
                                      __jsp_taghandler_131.setValue("RCL");
                                      __jsp_tag_starteval=__jsp_taghandler_131.doStartTag();
                                      if (__jsp_taghandler_131.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_131,6);
                                    }
                                    out.write(__oracle_jsp_text[152]);
                                  } while (__jsp_taghandler_130.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_130.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_130,5);
                              }
                              out.write(__oracle_jsp_text[153]);
                            } while (__jsp_taghandler_129.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_129.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_129,4);
                        }
                        out.write(__oracle_jsp_text[154]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_132=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_132.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_132.setName("fedl002");
                          __jsp_taghandler_132.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                          __jsp_taghandler_132.setValue("COC");
                          __jsp_tag_starteval=__jsp_taghandler_132.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[155]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_133=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_133.setParent(__jsp_taghandler_132);
                                __jsp_taghandler_133.setId("contOperator");
                                __jsp_tag_starteval=__jsp_taghandler_133.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_133,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[156]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_134=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style styleClass");
                                      __jsp_taghandler_134.setParent(__jsp_taghandler_133);
                                      __jsp_taghandler_134.setMaxlength("4");
                                      __jsp_taghandler_134.setName("fedl002");
                                      __jsp_taghandler_134.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateOperatorCode1(this, "+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                      __jsp_taghandler_134.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contOperator"));
                                      __jsp_taghandler_134.setStyle("width:75%");
                                      __jsp_taghandler_134.setStyleClass("must");
                                      __jsp_tag_starteval=__jsp_taghandler_134.doStartTag();
                                      if (__jsp_taghandler_134.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_134,6);
                                    }
                                    out.write(__oracle_jsp_text[157]);
                                    out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                    out.write(__oracle_jsp_text[158]);
                                  } while (__jsp_taghandler_133.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_133.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_133,5);
                              }
                              out.write(__oracle_jsp_text[159]);
                            } while (__jsp_taghandler_132.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_132.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_132,4);
                        }
                        out.write(__oracle_jsp_text[160]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_135=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_135.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_135.setId("outSlotOperator");
                          __jsp_tag_starteval=__jsp_taghandler_135.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_135,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[161]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_136=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_136.setParent(__jsp_taghandler_135);
                                __jsp_taghandler_136.setMaxlength("4");
                                __jsp_taghandler_136.setName("fedl002");
                                __jsp_taghandler_136.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");validateOutSlotOperatorCode1(this, "+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_136.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].outSlotOperator"));
                                __jsp_taghandler_136.setStyle("width:75%");
                                __jsp_tag_starteval=__jsp_taghandler_136.doStartTag();
                                if (__jsp_taghandler_136.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_136,5);
                              }
                              out.write(__oracle_jsp_text[162]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[163]);
                            } while (__jsp_taghandler_135.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_135.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_135,4);
                        }
                        out.write(__oracle_jsp_text[164]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_137=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_137.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_137.setId("specialHandling");
                          __jsp_tag_starteval=__jsp_taghandler_137.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_137,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_138=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_138.setParent(__jsp_taghandler_137);
                                __jsp_taghandler_138.setMaxlength("3");
                                __jsp_taghandler_138.setName("fedl002");
                                __jsp_taghandler_138.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_138.setReadonly(true);
                                __jsp_taghandler_138.setStyle("width:96%");
                                __jsp_taghandler_138.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_138.doStartTag();
                                if (__jsp_taghandler_138.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_138,5);
                              }
                            } while (__jsp_taghandler_137.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_137.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_137,4);
                        }
                        out.write(__oracle_jsp_text[165]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_139=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_139.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_139.setId("sealNo");
                          __jsp_tag_starteval=__jsp_taghandler_139.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_139,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_140=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_140.setParent(__jsp_taghandler_139);
                                __jsp_taghandler_140.setMaxlength("20");
                                __jsp_taghandler_140.setName("fedl002");
                                __jsp_taghandler_140.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_140.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].sealNo"));
                                __jsp_taghandler_140.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_140.doStartTag();
                                if (__jsp_taghandler_140.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_140,5);
                              }
                            } while (__jsp_taghandler_139.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_139.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_139,4);
                        }
                        out.write(__oracle_jsp_text[166]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_141=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_141.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_141.setId("pol");
                          __jsp_tag_starteval=__jsp_taghandler_141.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_141,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_142=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_142.setParent(__jsp_taghandler_141);
                                __jsp_taghandler_142.setMaxlength("5");
                                __jsp_taghandler_142.setName("fedl002");
                                __jsp_taghandler_142.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].pol"));
                                __jsp_taghandler_142.setReadonly(true);
                                __jsp_taghandler_142.setStyle("width:96%");
                                __jsp_taghandler_142.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_142.doStartTag();
                                if (__jsp_taghandler_142.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_142,5);
                              }
                            } while (__jsp_taghandler_141.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_141.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_141,4);
                        }
                        out.write(__oracle_jsp_text[167]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_143=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_143.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_143.setId("polTerminal");
                          __jsp_tag_starteval=__jsp_taghandler_143.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_143,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_144=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_144.setParent(__jsp_taghandler_143);
                                __jsp_taghandler_144.setMaxlength("5");
                                __jsp_taghandler_144.setName("fedl002");
                                __jsp_taghandler_144.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].polTerminal"));
                                __jsp_taghandler_144.setReadonly(true);
                                __jsp_taghandler_144.setStyle("width:96%");
                                __jsp_taghandler_144.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_144.doStartTag();
                                if (__jsp_taghandler_144.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_144,5);
                              }
                            } while (__jsp_taghandler_143.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_143.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_143,4);
                        }
                        out.write(__oracle_jsp_text[168]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_145=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_145.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_145.setId("nextPOD1");
                          __jsp_tag_starteval=__jsp_taghandler_145.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_145,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_146=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_146.setParent(__jsp_taghandler_145);
                                __jsp_taghandler_146.setMaxlength("5");
                                __jsp_taghandler_146.setName("fedl002");
                                __jsp_taghandler_146.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextPOD1"));
                                __jsp_taghandler_146.setReadonly(true);
                                __jsp_taghandler_146.setStyle("width:96%");
                                __jsp_taghandler_146.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_146.doStartTag();
                                if (__jsp_taghandler_146.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_146,5);
                              }
                            } while (__jsp_taghandler_145.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_145.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_145,4);
                        }
                        out.write(__oracle_jsp_text[169]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_147=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_147.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_147.setId("nextPOD2");
                          __jsp_tag_starteval=__jsp_taghandler_147.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_147,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_148=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_148.setParent(__jsp_taghandler_147);
                                __jsp_taghandler_148.setMaxlength("5");
                                __jsp_taghandler_148.setName("fedl002");
                                __jsp_taghandler_148.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextPOD2"));
                                __jsp_taghandler_148.setReadonly(true);
                                __jsp_taghandler_148.setStyle("width:96%");
                                __jsp_taghandler_148.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_148.doStartTag();
                                if (__jsp_taghandler_148.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_148,5);
                              }
                            } while (__jsp_taghandler_147.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_147.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_147,4);
                        }
                        out.write(__oracle_jsp_text[170]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_149=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_149.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_149.setId("nextPOD3");
                          __jsp_tag_starteval=__jsp_taghandler_149.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_149,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_150=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_150.setParent(__jsp_taghandler_149);
                                __jsp_taghandler_150.setMaxlength("5");
                                __jsp_taghandler_150.setName("fedl002");
                                __jsp_taghandler_150.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextPOD3"));
                                __jsp_taghandler_150.setReadonly(true);
                                __jsp_taghandler_150.setStyle("width:96%");
                                __jsp_taghandler_150.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_150.doStartTag();
                                if (__jsp_taghandler_150.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_150,5);
                              }
                            } while (__jsp_taghandler_149.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_149.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_149,4);
                        }
                        out.write(__oracle_jsp_text[171]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_151=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_151.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_151.setId("finalPOD");
                          __jsp_tag_starteval=__jsp_taghandler_151.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_151,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_152=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_152.setParent(__jsp_taghandler_151);
                                __jsp_taghandler_152.setMaxlength("5");
                                __jsp_taghandler_152.setName("fedl002");
                                __jsp_taghandler_152.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].finalPOD"));
                                __jsp_taghandler_152.setReadonly(true);
                                __jsp_taghandler_152.setStyle("width:96%");
                                __jsp_taghandler_152.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_152.doStartTag();
                                if (__jsp_taghandler_152.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_152,5);
                              }
                            } while (__jsp_taghandler_151.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_151.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_151,4);
                        }
                        out.write(__oracle_jsp_text[172]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_153=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_153.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_153.setId("finalDest");
                          __jsp_tag_starteval=__jsp_taghandler_153.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_153,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_154=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_154.setParent(__jsp_taghandler_153);
                                __jsp_taghandler_154.setMaxlength("5");
                                __jsp_taghandler_154.setName("fedl002");
                                __jsp_taghandler_154.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].finalDest"));
                                __jsp_taghandler_154.setReadonly(true);
                                __jsp_taghandler_154.setStyle("width:96%");
                                __jsp_taghandler_154.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_154.doStartTag();
                                if (__jsp_taghandler_154.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_154,5);
                              }
                            } while (__jsp_taghandler_153.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_153.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_153,4);
                        }
                        out.write(__oracle_jsp_text[173]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_155=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_155.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_155.setId("nextService");
                          __jsp_tag_starteval=__jsp_taghandler_155.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_155,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_156=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_156.setParent(__jsp_taghandler_155);
                                __jsp_taghandler_156.setMaxlength("5");
                                __jsp_taghandler_156.setName("fedl002");
                                __jsp_taghandler_156.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextService"));
                                __jsp_taghandler_156.setReadonly(true);
                                __jsp_taghandler_156.setStyle("width:96%");
                                __jsp_taghandler_156.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_156.doStartTag();
                                if (__jsp_taghandler_156.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_156,5);
                              }
                            } while (__jsp_taghandler_155.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_155.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_155,4);
                        }
                        out.write(__oracle_jsp_text[174]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_157=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_157.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_157.setId("nextVessel");
                          __jsp_tag_starteval=__jsp_taghandler_157.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_157,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_158=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_158.setParent(__jsp_taghandler_157);
                                __jsp_taghandler_158.setMaxlength("25");
                                __jsp_taghandler_158.setName("fedl002");
                                __jsp_taghandler_158.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextVessel"));
                                __jsp_taghandler_158.setReadonly(true);
                                __jsp_taghandler_158.setStyle("width:96%");
                                __jsp_taghandler_158.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_158.doStartTag();
                                if (__jsp_taghandler_158.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_158,5);
                              }
                            } while (__jsp_taghandler_157.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_157.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_157,4);
                        }
                        out.write(__oracle_jsp_text[175]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_159=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_159.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_159.setId("nextVoyage");
                          __jsp_tag_starteval=__jsp_taghandler_159.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_159,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_160=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_160.setParent(__jsp_taghandler_159);
                                __jsp_taghandler_160.setMaxlength("10");
                                __jsp_taghandler_160.setName("fedl002");
                                __jsp_taghandler_160.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextVoyage"));
                                __jsp_taghandler_160.setReadonly(true);
                                __jsp_taghandler_160.setStyle("width:96%");
                                __jsp_taghandler_160.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_160.doStartTag();
                                if (__jsp_taghandler_160.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_160,5);
                              }
                            } while (__jsp_taghandler_159.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_159.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_159,4);
                        }
                        out.write(__oracle_jsp_text[176]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_161=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_161.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_161.setId("nextDirection");
                          __jsp_tag_starteval=__jsp_taghandler_161.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_161,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_162=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_162.setParent(__jsp_taghandler_161);
                                __jsp_taghandler_162.setMaxlength("2");
                                __jsp_taghandler_162.setName("fedl002");
                                __jsp_taghandler_162.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].nextDirection"));
                                __jsp_taghandler_162.setReadonly(true);
                                __jsp_taghandler_162.setStyle("width:96%");
                                __jsp_taghandler_162.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_162.doStartTag();
                                if (__jsp_taghandler_162.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_162,5);
                              }
                            } while (__jsp_taghandler_161.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_161.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_161,4);
                        }
                        out.write(__oracle_jsp_text[177]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_163=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_163.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_163.setId("connectingMLOVessel");
                          __jsp_tag_starteval=__jsp_taghandler_163.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_163,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[178]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_164=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_164.setParent(__jsp_taghandler_163);
                                __jsp_taghandler_164.setName("fedl002");
                                __jsp_taghandler_164.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_164.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_164.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[179]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_165=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_165.setParent(__jsp_taghandler_164);
                                      __jsp_taghandler_165.setName("fedl002");
                                      __jsp_taghandler_165.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_165.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_165.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[180]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_166=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_166.setParent(__jsp_taghandler_165);
                                            __jsp_taghandler_166.setMaxlength("35");
                                            __jsp_taghandler_166.setName("fedl002");
                                            __jsp_taghandler_166.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_166.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVessel"));
                                            __jsp_taghandler_166.setReadonly(true);
                                            __jsp_taghandler_166.setStyle("width:96%");
                                            __jsp_taghandler_166.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_166.doStartTag();
                                            if (__jsp_taghandler_166.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_166,7);
                                          }
                                          out.write(__oracle_jsp_text[181]);
                                        } while (__jsp_taghandler_165.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_165.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_165,6);
                                    }
                                    out.write(__oracle_jsp_text[182]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_167=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_167.setParent(__jsp_taghandler_164);
                                      __jsp_taghandler_167.setName("fedl002");
                                      __jsp_taghandler_167.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_167.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_167.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[183]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_168=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_168.setParent(__jsp_taghandler_167);
                                            __jsp_taghandler_168.setMaxlength("35");
                                            __jsp_taghandler_168.setName("fedl002");
                                            __jsp_taghandler_168.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_168.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVessel"));
                                            __jsp_taghandler_168.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_168.doStartTag();
                                            if (__jsp_taghandler_168.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_168,7);
                                          }
                                          out.write(__oracle_jsp_text[184]);
                                        } while (__jsp_taghandler_167.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_167.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_167,6);
                                    }
                                    out.write(__oracle_jsp_text[185]);
                                  } while (__jsp_taghandler_164.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_164.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_164,5);
                              }
                              out.write(__oracle_jsp_text[186]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_169=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_169.setParent(__jsp_taghandler_163);
                                __jsp_taghandler_169.setName("fedl002");
                                __jsp_taghandler_169.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_169.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_169.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[187]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_170=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_170.setParent(__jsp_taghandler_169);
                                      __jsp_taghandler_170.setMaxlength("35");
                                      __jsp_taghandler_170.setName("fedl002");
                                      __jsp_taghandler_170.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_170.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVessel"));
                                      __jsp_taghandler_170.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_170.doStartTag();
                                      if (__jsp_taghandler_170.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_170,6);
                                    }
                                    out.write(__oracle_jsp_text[188]);
                                  } while (__jsp_taghandler_169.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_169.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_169,5);
                              }
                              out.write(__oracle_jsp_text[189]);
                            } while (__jsp_taghandler_163.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_163.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_163,4);
                        }
                        out.write(__oracle_jsp_text[190]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_171=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_171.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_171.setId("connectingMLOVoyage");
                          __jsp_tag_starteval=__jsp_taghandler_171.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_171,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[191]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_172=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_172.setParent(__jsp_taghandler_171);
                                __jsp_taghandler_172.setName("fedl002");
                                __jsp_taghandler_172.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_172.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_172.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[192]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_173=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_173.setParent(__jsp_taghandler_172);
                                      __jsp_taghandler_173.setName("fedl002");
                                      __jsp_taghandler_173.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_173.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_173.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[193]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_174=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_174.setParent(__jsp_taghandler_173);
                                            __jsp_taghandler_174.setMaxlength("10");
                                            __jsp_taghandler_174.setName("fedl002");
                                            __jsp_taghandler_174.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_174.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVoyage"));
                                            __jsp_taghandler_174.setReadonly(true);
                                            __jsp_taghandler_174.setStyle("width:96%");
                                            __jsp_taghandler_174.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_174.doStartTag();
                                            if (__jsp_taghandler_174.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_174,7);
                                          }
                                          out.write(__oracle_jsp_text[194]);
                                        } while (__jsp_taghandler_173.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_173.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_173,6);
                                    }
                                    out.write(__oracle_jsp_text[195]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_175=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_175.setParent(__jsp_taghandler_172);
                                      __jsp_taghandler_175.setName("fedl002");
                                      __jsp_taghandler_175.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_175.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_175.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[196]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_176=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_176.setParent(__jsp_taghandler_175);
                                            __jsp_taghandler_176.setMaxlength("10");
                                            __jsp_taghandler_176.setName("fedl002");
                                            __jsp_taghandler_176.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_176.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVoyage"));
                                            __jsp_taghandler_176.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_176.doStartTag();
                                            if (__jsp_taghandler_176.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_176,7);
                                          }
                                          out.write(__oracle_jsp_text[197]);
                                        } while (__jsp_taghandler_175.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_175.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_175,6);
                                    }
                                    out.write(__oracle_jsp_text[198]);
                                  } while (__jsp_taghandler_172.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_172.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_172,5);
                              }
                              out.write(__oracle_jsp_text[199]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_177=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_177.setParent(__jsp_taghandler_171);
                                __jsp_taghandler_177.setName("fedl002");
                                __jsp_taghandler_177.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_177.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_177.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[200]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_178=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_178.setParent(__jsp_taghandler_177);
                                      __jsp_taghandler_178.setMaxlength("10");
                                      __jsp_taghandler_178.setName("fedl002");
                                      __jsp_taghandler_178.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_178.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOVoyage"));
                                      __jsp_taghandler_178.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_178.doStartTag();
                                      if (__jsp_taghandler_178.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_178,6);
                                    }
                                    out.write(__oracle_jsp_text[201]);
                                  } while (__jsp_taghandler_177.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_177.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_177,5);
                              }
                              out.write(__oracle_jsp_text[202]);
                            } while (__jsp_taghandler_171.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_171.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_171,4);
                        }
                        out.write(__oracle_jsp_text[203]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_179=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_179.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_179.setId("mloETADate");
                          __jsp_tag_starteval=__jsp_taghandler_179.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_179,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[204]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_180=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_180.setParent(__jsp_taghandler_179);
                                __jsp_taghandler_180.setName("fedl002");
                                __jsp_taghandler_180.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_180.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_180.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[205]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_181=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_181.setParent(__jsp_taghandler_180);
                                      __jsp_taghandler_181.setName("fedl002");
                                      __jsp_taghandler_181.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_181.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_181.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[206]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_182=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property readonly style styleClass");
                                            __jsp_taghandler_182.setParent(__jsp_taghandler_181);
                                            __jsp_taghandler_182.setMaxlength("16");
                                            __jsp_taghandler_182.setName("fedl002");
                                            __jsp_taghandler_182.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_182.setOnclick("this.select();");
                                            __jsp_taghandler_182.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].mloETADate"));
                                            __jsp_taghandler_182.setReadonly(true);
                                            __jsp_taghandler_182.setStyle("width:60%");
                                            __jsp_taghandler_182.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_182.doStartTag();
                                            if (__jsp_taghandler_182.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_182,7);
                                          }
                                          out.write(__oracle_jsp_text[207]);
                                          out.print(lstrContextPath);
                                          out.write(__oracle_jsp_text[208]);
                                        } while (__jsp_taghandler_181.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_181.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_181,6);
                                    }
                                    out.write(__oracle_jsp_text[209]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_183=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_183.setParent(__jsp_taghandler_180);
                                      __jsp_taghandler_183.setName("fedl002");
                                      __jsp_taghandler_183.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_183.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_183.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[210]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_184=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                            __jsp_taghandler_184.setParent(__jsp_taghandler_183);
                                            __jsp_taghandler_184.setMaxlength("16");
                                            __jsp_taghandler_184.setName("fedl002");
                                            __jsp_taghandler_184.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_184.setOnclick("this.select();");
                                            __jsp_taghandler_184.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].mloETADate"));
                                            __jsp_taghandler_184.setStyle("width:60%");
                                            __jsp_tag_starteval=__jsp_taghandler_184.doStartTag();
                                            if (__jsp_taghandler_184.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_184,7);
                                          }
                                          out.write(__oracle_jsp_text[211]);
                                          out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                          out.write(__oracle_jsp_text[212]);
                                          out.print(lstrContextPath);
                                          out.write(__oracle_jsp_text[213]);
                                        } while (__jsp_taghandler_183.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_183.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_183,6);
                                    }
                                    out.write(__oracle_jsp_text[214]);
                                  } while (__jsp_taghandler_180.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_180.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_180,5);
                              }
                              out.write(__oracle_jsp_text[215]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_185=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_185.setParent(__jsp_taghandler_179);
                                __jsp_taghandler_185.setName("fedl002");
                                __jsp_taghandler_185.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_185.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_185.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[216]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_186=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                      __jsp_taghandler_186.setParent(__jsp_taghandler_185);
                                      __jsp_taghandler_186.setMaxlength("16");
                                      __jsp_taghandler_186.setName("fedl002");
                                      __jsp_taghandler_186.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_186.setOnclick("this.select();");
                                      __jsp_taghandler_186.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].mloETADate"));
                                      __jsp_taghandler_186.setStyle("width:60%");
                                      __jsp_tag_starteval=__jsp_taghandler_186.doStartTag();
                                      if (__jsp_taghandler_186.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_186,6);
                                    }
                                    out.write(__oracle_jsp_text[217]);
                                    out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                    out.write(__oracle_jsp_text[218]);
                                    out.print(lstrContextPath);
                                    out.write(__oracle_jsp_text[219]);
                                  } while (__jsp_taghandler_185.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_185.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_185,5);
                              }
                              out.write(__oracle_jsp_text[220]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[221]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[222]);
                            } while (__jsp_taghandler_179.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_179.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_179,4);
                        }
                        out.write(__oracle_jsp_text[223]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_187=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_187.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_187.setId("connectingMLOPOD1");
                          __jsp_tag_starteval=__jsp_taghandler_187.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_187,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[224]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_188=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_188.setParent(__jsp_taghandler_187);
                                __jsp_taghandler_188.setName("fedl002");
                                __jsp_taghandler_188.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_188.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_188.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[225]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_189=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_189.setParent(__jsp_taghandler_188);
                                      __jsp_taghandler_189.setName("fedl002");
                                      __jsp_taghandler_189.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_189.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_189.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[226]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_190=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_190.setParent(__jsp_taghandler_189);
                                            __jsp_taghandler_190.setMaxlength("5");
                                            __jsp_taghandler_190.setName("fedl002");
                                            __jsp_taghandler_190.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_190.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD1"));
                                            __jsp_taghandler_190.setReadonly(true);
                                            __jsp_taghandler_190.setStyle("width:96%");
                                            __jsp_taghandler_190.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_190.doStartTag();
                                            if (__jsp_taghandler_190.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_190,7);
                                          }
                                          out.write(__oracle_jsp_text[227]);
                                        } while (__jsp_taghandler_189.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_189.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_189,6);
                                    }
                                    out.write(__oracle_jsp_text[228]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_191=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_191.setParent(__jsp_taghandler_188);
                                      __jsp_taghandler_191.setName("fedl002");
                                      __jsp_taghandler_191.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_191.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_191.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[229]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_192=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_192.setParent(__jsp_taghandler_191);
                                            __jsp_taghandler_192.setMaxlength("5");
                                            __jsp_taghandler_192.setName("fedl002");
                                            __jsp_taghandler_192.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_192.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD1"));
                                            __jsp_taghandler_192.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_192.doStartTag();
                                            if (__jsp_taghandler_192.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_192,7);
                                          }
                                          out.write(__oracle_jsp_text[230]);
                                        } while (__jsp_taghandler_191.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_191.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_191,6);
                                    }
                                    out.write(__oracle_jsp_text[231]);
                                  } while (__jsp_taghandler_188.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_188.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_188,5);
                              }
                              out.write(__oracle_jsp_text[232]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_193=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_193.setParent(__jsp_taghandler_187);
                                __jsp_taghandler_193.setName("fedl002");
                                __jsp_taghandler_193.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_193.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_193.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[233]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_194=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_194.setParent(__jsp_taghandler_193);
                                      __jsp_taghandler_194.setMaxlength("5");
                                      __jsp_taghandler_194.setName("fedl002");
                                      __jsp_taghandler_194.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_194.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD1"));
                                      __jsp_taghandler_194.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_194.doStartTag();
                                      if (__jsp_taghandler_194.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_194,6);
                                    }
                                    out.write(__oracle_jsp_text[234]);
                                  } while (__jsp_taghandler_193.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_193.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_193,5);
                              }
                              out.write(__oracle_jsp_text[235]);
                            } while (__jsp_taghandler_187.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_187.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_187,4);
                        }
                        out.write(__oracle_jsp_text[236]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_195=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_195.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_195.setId("connectingMLOPOD2");
                          __jsp_tag_starteval=__jsp_taghandler_195.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_195,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[237]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_196=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_196.setParent(__jsp_taghandler_195);
                                __jsp_taghandler_196.setName("fedl002");
                                __jsp_taghandler_196.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_196.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_196.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[238]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_197=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_197.setParent(__jsp_taghandler_196);
                                      __jsp_taghandler_197.setName("fedl002");
                                      __jsp_taghandler_197.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_197.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_197.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[239]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_198=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_198.setParent(__jsp_taghandler_197);
                                            __jsp_taghandler_198.setMaxlength("5");
                                            __jsp_taghandler_198.setName("fedl002");
                                            __jsp_taghandler_198.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_198.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD2"));
                                            __jsp_taghandler_198.setReadonly(true);
                                            __jsp_taghandler_198.setStyle("width:96%");
                                            __jsp_taghandler_198.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_198.doStartTag();
                                            if (__jsp_taghandler_198.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_198,7);
                                          }
                                          out.write(__oracle_jsp_text[240]);
                                        } while (__jsp_taghandler_197.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_197.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_197,6);
                                    }
                                    out.write(__oracle_jsp_text[241]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_199=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_199.setParent(__jsp_taghandler_196);
                                      __jsp_taghandler_199.setName("fedl002");
                                      __jsp_taghandler_199.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_199.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_199.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[242]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_200=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_200.setParent(__jsp_taghandler_199);
                                            __jsp_taghandler_200.setMaxlength("5");
                                            __jsp_taghandler_200.setName("fedl002");
                                            __jsp_taghandler_200.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_200.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD2"));
                                            __jsp_taghandler_200.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_200.doStartTag();
                                            if (__jsp_taghandler_200.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_200,7);
                                          }
                                          out.write(__oracle_jsp_text[243]);
                                        } while (__jsp_taghandler_199.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_199.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_199,6);
                                    }
                                    out.write(__oracle_jsp_text[244]);
                                  } while (__jsp_taghandler_196.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_196.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_196,5);
                              }
                              out.write(__oracle_jsp_text[245]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_201=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_201.setParent(__jsp_taghandler_195);
                                __jsp_taghandler_201.setName("fedl002");
                                __jsp_taghandler_201.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_201.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_201.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[246]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_202=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_202.setParent(__jsp_taghandler_201);
                                      __jsp_taghandler_202.setMaxlength("5");
                                      __jsp_taghandler_202.setName("fedl002");
                                      __jsp_taghandler_202.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_202.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD2"));
                                      __jsp_taghandler_202.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_202.doStartTag();
                                      if (__jsp_taghandler_202.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_202,6);
                                    }
                                    out.write(__oracle_jsp_text[247]);
                                  } while (__jsp_taghandler_201.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_201.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_201,5);
                              }
                              out.write(__oracle_jsp_text[248]);
                            } while (__jsp_taghandler_195.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_195.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_195,4);
                        }
                        out.write(__oracle_jsp_text[249]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_203=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_203.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_203.setId("connectingMLOPOD3");
                          __jsp_tag_starteval=__jsp_taghandler_203.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_203,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[250]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_204=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_204.setParent(__jsp_taghandler_203);
                                __jsp_taghandler_204.setName("fedl002");
                                __jsp_taghandler_204.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_204.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_204.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[251]);
                                    {
                                      org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_205=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                      __jsp_taghandler_205.setParent(__jsp_taghandler_204);
                                      __jsp_taghandler_205.setName("fedl002");
                                      __jsp_taghandler_205.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_205.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_205.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[252]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_206=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                            __jsp_taghandler_206.setParent(__jsp_taghandler_205);
                                            __jsp_taghandler_206.setMaxlength("5");
                                            __jsp_taghandler_206.setName("fedl002");
                                            __jsp_taghandler_206.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_206.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD3"));
                                            __jsp_taghandler_206.setReadonly(true);
                                            __jsp_taghandler_206.setStyle("width:96%");
                                            __jsp_taghandler_206.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_206.doStartTag();
                                            if (__jsp_taghandler_206.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_206,7);
                                          }
                                          out.write(__oracle_jsp_text[253]);
                                        } while (__jsp_taghandler_205.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_205.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_205,6);
                                    }
                                    out.write(__oracle_jsp_text[254]);
                                    {
                                      org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_207=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                      __jsp_taghandler_207.setParent(__jsp_taghandler_204);
                                      __jsp_taghandler_207.setName("fedl002");
                                      __jsp_taghandler_207.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                      __jsp_taghandler_207.setValue("Full");
                                      __jsp_tag_starteval=__jsp_taghandler_207.doStartTag();
                                      if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                      {
                                        do {
                                          out.write(__oracle_jsp_text[255]);
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_208=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_208.setParent(__jsp_taghandler_207);
                                            __jsp_taghandler_208.setMaxlength("5");
                                            __jsp_taghandler_208.setName("fedl002");
                                            __jsp_taghandler_208.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_208.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD3"));
                                            __jsp_taghandler_208.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_208.doStartTag();
                                            if (__jsp_taghandler_208.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_208,7);
                                          }
                                          out.write(__oracle_jsp_text[256]);
                                        } while (__jsp_taghandler_207.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                      }
                                      if (__jsp_taghandler_207.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_207,6);
                                    }
                                    out.write(__oracle_jsp_text[257]);
                                  } while (__jsp_taghandler_204.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_204.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_204,5);
                              }
                              out.write(__oracle_jsp_text[258]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_209=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_209.setParent(__jsp_taghandler_203);
                                __jsp_taghandler_209.setName("fedl002");
                                __jsp_taghandler_209.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_209.setValue("COC");
                                __jsp_tag_starteval=__jsp_taghandler_209.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[259]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_210=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_210.setParent(__jsp_taghandler_209);
                                      __jsp_taghandler_210.setMaxlength("5");
                                      __jsp_taghandler_210.setName("fedl002");
                                      __jsp_taghandler_210.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_210.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].connectingMLOPOD3"));
                                      __jsp_taghandler_210.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_210.doStartTag();
                                      if (__jsp_taghandler_210.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_210,6);
                                    }
                                    out.write(__oracle_jsp_text[260]);
                                  } while (__jsp_taghandler_209.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_209.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_209,5);
                              }
                              out.write(__oracle_jsp_text[261]);
                            } while (__jsp_taghandler_203.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_203.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_203,4);
                        }
                        out.write(__oracle_jsp_text[262]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_211=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_211.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_211.setName("fedl002");
                          __jsp_taghandler_211.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                          __jsp_taghandler_211.setValue("SOC");
                          __jsp_tag_starteval=__jsp_taghandler_211.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[263]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_212=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_212.setParent(__jsp_taghandler_211);
                                __jsp_taghandler_212.setId("placeOfDel");
                                __jsp_tag_starteval=__jsp_taghandler_212.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_212,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_213=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_213.setParent(__jsp_taghandler_212);
                                      __jsp_taghandler_213.setMaxlength("5");
                                      __jsp_taghandler_213.setName("fedl002");
                                      __jsp_taghandler_213.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_213.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].placeOfDel"));
                                      __jsp_taghandler_213.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_213.doStartTag();
                                      if (__jsp_taghandler_213.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_213,6);
                                    }
                                  } while (__jsp_taghandler_212.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_212.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_212,5);
                              }
                              out.write(__oracle_jsp_text[264]);
                            } while (__jsp_taghandler_211.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_211.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_211,4);
                        }
                        out.write(__oracle_jsp_text[265]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_214=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_214.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_214.setName("fedl002");
                          __jsp_taghandler_214.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                          __jsp_taghandler_214.setValue("SOC");
                          __jsp_tag_starteval=__jsp_taghandler_214.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[266]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_215=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_215.setParent(__jsp_taghandler_214);
                                __jsp_taghandler_215.setName("fedl002");
                                __jsp_taghandler_215.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                __jsp_taghandler_215.setValue("Empty");
                                __jsp_tag_starteval=__jsp_taghandler_215.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[267]);
                                    {
                                      com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_216=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                      __jsp_taghandler_216.setParent(__jsp_taghandler_215);
                                      __jsp_taghandler_216.setId("placeOfDel");
                                      __jsp_tag_starteval=__jsp_taghandler_216.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_216,__jsp_tag_starteval,out);
                                        do {
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_217=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                            __jsp_taghandler_217.setParent(__jsp_taghandler_216);
                                            __jsp_taghandler_217.setMaxlength("5");
                                            __jsp_taghandler_217.setName("fedl002");
                                            __jsp_taghandler_217.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                            __jsp_taghandler_217.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].placeOfDel"));
                                            __jsp_taghandler_217.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_217.doStartTag();
                                            if (__jsp_taghandler_217.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_217,7);
                                          }
                                        } while (__jsp_taghandler_216.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_216.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_216,6);
                                    }
                                    out.write(__oracle_jsp_text[268]);
                                  } while (__jsp_taghandler_215.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_215.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_215,5);
                              }
                              out.write(__oracle_jsp_text[269]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_218=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_218.setParent(__jsp_taghandler_214);
                                __jsp_taghandler_218.setName("fedl002");
                                __jsp_taghandler_218.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fullMT"));
                                __jsp_taghandler_218.setValue("Empty");
                                __jsp_tag_starteval=__jsp_taghandler_218.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[270]);
                                    {
                                      com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_219=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                      __jsp_taghandler_219.setParent(__jsp_taghandler_218);
                                      __jsp_taghandler_219.setId("placeOfDel");
                                      __jsp_tag_starteval=__jsp_taghandler_219.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_219,__jsp_tag_starteval,out);
                                        do {
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_220=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                            __jsp_taghandler_220.setParent(__jsp_taghandler_219);
                                            __jsp_taghandler_220.setMaxlength("5");
                                            __jsp_taghandler_220.setName("fedl002");
                                            __jsp_taghandler_220.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].placeOfDel"));
                                            __jsp_taghandler_220.setReadonly(true);
                                            __jsp_taghandler_220.setStyle("width:96%");
                                            __jsp_taghandler_220.setStyleClass("non_edit");
                                            __jsp_tag_starteval=__jsp_taghandler_220.doStartTag();
                                            if (__jsp_taghandler_220.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_220,7);
                                          }
                                        } while (__jsp_taghandler_219.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_219.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_219,6);
                                    }
                                    out.write(__oracle_jsp_text[271]);
                                  } while (__jsp_taghandler_218.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_218.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_218,5);
                              }
                              out.write(__oracle_jsp_text[272]);
                            } while (__jsp_taghandler_214.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_214.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_214,4);
                        }
                        out.write(__oracle_jsp_text[273]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_221=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_221.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_221.setId("swapConnection");
                          __jsp_tag_starteval=__jsp_taghandler_221.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_221,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[274]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_222=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_222.setParent(__jsp_taghandler_221);
                                __jsp_taghandler_222.setName("fedl002");
                                __jsp_taghandler_222.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_222.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].swapConnection"));
                                __jsp_taghandler_222.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_222.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_222,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[275]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_223=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_223.setParent(__jsp_taghandler_222);
                                      __jsp_taghandler_223.setLabel("name");
                                      __jsp_taghandler_223.setName("fedl002");
                                      __jsp_taghandler_223.setProperty("swapConnectionValues");
                                      __jsp_taghandler_223.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_223.doStartTag();
                                      if (__jsp_taghandler_223.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_223,6);
                                    }
                                    out.write(__oracle_jsp_text[276]);
                                  } while (__jsp_taghandler_222.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_222.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_222,5);
                              }
                              out.write(__oracle_jsp_text[277]);
                            } while (__jsp_taghandler_221.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_221.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_221,4);
                        }
                        out.write(__oracle_jsp_text[278]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_224=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_224.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_224.setId("handlingInstCode1");
                          __jsp_tag_starteval=__jsp_taghandler_224.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_224,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[279]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_225=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_225.setParent(__jsp_taghandler_224);
                                __jsp_taghandler_225.setMaxlength("3");
                                __jsp_taghandler_225.setName("fedl002");
                                __jsp_taghandler_225.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateHandInsCode1(this,1,("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"));"));
                                __jsp_taghandler_225.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstCode1"));
                                __jsp_taghandler_225.setStyle("width:75%");
                                __jsp_tag_starteval=__jsp_taghandler_225.doStartTag();
                                if (__jsp_taghandler_225.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_225,5);
                              }
                              out.write(__oracle_jsp_text[280]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[281]);
                            } while (__jsp_taghandler_224.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_224.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_224,4);
                        }
                        out.write(__oracle_jsp_text[282]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_226=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_226.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_226.setId("handlingInstDesc1");
                          __jsp_tag_starteval=__jsp_taghandler_226.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_226,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_227=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_227.setParent(__jsp_taghandler_226);
                                __jsp_taghandler_227.setMaxlength("60");
                                __jsp_taghandler_227.setName("fedl002");
                                __jsp_taghandler_227.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstDesc1"));
                                __jsp_taghandler_227.setReadonly(true);
                                __jsp_taghandler_227.setStyle("width:96%");
                                __jsp_taghandler_227.setStyleClass("non_edit");
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
                        out.write(__oracle_jsp_text[283]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_228=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_228.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_228.setId("handlingInstCode2");
                          __jsp_tag_starteval=__jsp_taghandler_228.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_228,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[284]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_229=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_229.setParent(__jsp_taghandler_228);
                                __jsp_taghandler_229.setMaxlength("3");
                                __jsp_taghandler_229.setName("fedl002");
                                __jsp_taghandler_229.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateHandInsCode1(this,2,("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"));"));
                                __jsp_taghandler_229.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstCode2"));
                                __jsp_taghandler_229.setStyle("width:75%");
                                __jsp_tag_starteval=__jsp_taghandler_229.doStartTag();
                                if (__jsp_taghandler_229.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_229,5);
                              }
                              out.write(__oracle_jsp_text[285]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[286]);
                            } while (__jsp_taghandler_228.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_228.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_228,4);
                        }
                        out.write(__oracle_jsp_text[287]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_230=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_230.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_230.setId("handlingInstDesc2");
                          __jsp_tag_starteval=__jsp_taghandler_230.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_230,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_231=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_231.setParent(__jsp_taghandler_230);
                                __jsp_taghandler_231.setMaxlength("60");
                                __jsp_taghandler_231.setName("fedl002");
                                __jsp_taghandler_231.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstDesc2"));
                                __jsp_taghandler_231.setReadonly(true);
                                __jsp_taghandler_231.setStyle("width:96%");
                                __jsp_taghandler_231.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_231.doStartTag();
                                if (__jsp_taghandler_231.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_231,5);
                              }
                            } while (__jsp_taghandler_230.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_230.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_230,4);
                        }
                        out.write(__oracle_jsp_text[288]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_232=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_232.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_232.setId("handlingInstCode3");
                          __jsp_tag_starteval=__jsp_taghandler_232.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_232,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[289]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_233=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_233.setParent(__jsp_taghandler_232);
                                __jsp_taghandler_233.setMaxlength("3");
                                __jsp_taghandler_233.setName("fedl002");
                                __jsp_taghandler_233.setOnblur((java.lang.String) ("changeUpper(this); updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"); validateHandInsCode1(this,3,("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"));"));
                                __jsp_taghandler_233.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstCode3"));
                                __jsp_taghandler_233.setStyle("width:75%");
                                __jsp_tag_starteval=__jsp_taghandler_233.doStartTag();
                                if (__jsp_taghandler_233.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_233,5);
                              }
                              out.write(__oracle_jsp_text[290]);
                              out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                              out.write(__oracle_jsp_text[291]);
                            } while (__jsp_taghandler_232.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_232.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_232,4);
                        }
                        out.write(__oracle_jsp_text[292]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_234=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_234.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_234.setId("handlingInstDesc3");
                          __jsp_tag_starteval=__jsp_taghandler_234.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_234,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_235=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_235.setParent(__jsp_taghandler_234);
                                __jsp_taghandler_235.setMaxlength("60");
                                __jsp_taghandler_235.setName("fedl002");
                                __jsp_taghandler_235.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].handlingInstDesc3"));
                                __jsp_taghandler_235.setReadonly(true);
                                __jsp_taghandler_235.setStyle("width:96%");
                                __jsp_taghandler_235.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_235.doStartTag();
                                if (__jsp_taghandler_235.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_235,5);
                              }
                            } while (__jsp_taghandler_234.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_234.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_234,4);
                        }
                        out.write(__oracle_jsp_text[293]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_236=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_236.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_236.setId("contLoadRemark1");
                          __jsp_tag_starteval=__jsp_taghandler_236.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_236,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[294]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_237=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_237.setParent(__jsp_taghandler_236);
                                __jsp_taghandler_237.setMaxlength("3");
                                __jsp_taghandler_237.setName("fedl002");
                                __jsp_taghandler_237.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_237.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contLoadRemark1"));
                                __jsp_taghandler_237.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_237.doStartTag();
                                if (__jsp_taghandler_237.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_237,5);
                              }
                              out.write(__oracle_jsp_text[295]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_238=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_238.setParent(__jsp_taghandler_236);
                                __jsp_taghandler_238.setName("fedl002");
                                __jsp_taghandler_238.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_238.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contLoadRemark1"));
                                __jsp_taghandler_238.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_238.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_238,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[296]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_239=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_239.setParent(__jsp_taghandler_238);
                                      __jsp_taghandler_239.setLabel("name");
                                      __jsp_taghandler_239.setName("fedl002");
                                      __jsp_taghandler_239.setProperty("clrValues");
                                      __jsp_taghandler_239.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_239.doStartTag();
                                      if (__jsp_taghandler_239.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_239,6);
                                    }
                                    out.write(__oracle_jsp_text[297]);
                                  } while (__jsp_taghandler_238.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_238.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_238,5);
                              }
                              out.write(__oracle_jsp_text[298]);
                            } while (__jsp_taghandler_236.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_236.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_236,4);
                        }
                        out.write(__oracle_jsp_text[299]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_240=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_240.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_240.setId("contLoadRemark2");
                          __jsp_tag_starteval=__jsp_taghandler_240.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_240,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[300]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_241=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_241.setParent(__jsp_taghandler_240);
                                __jsp_taghandler_241.setMaxlength("3");
                                __jsp_taghandler_241.setName("fedl002");
                                __jsp_taghandler_241.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_241.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contLoadRemark2"));
                                __jsp_taghandler_241.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_241.doStartTag();
                                if (__jsp_taghandler_241.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_241,5);
                              }
                              out.write(__oracle_jsp_text[301]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_242=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_242.setParent(__jsp_taghandler_240);
                                __jsp_taghandler_242.setName("fedl002");
                                __jsp_taghandler_242.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_242.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contLoadRemark2"));
                                __jsp_taghandler_242.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_242.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_242,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[302]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_243=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_243.setParent(__jsp_taghandler_242);
                                      __jsp_taghandler_243.setLabel("name");
                                      __jsp_taghandler_243.setName("fedl002");
                                      __jsp_taghandler_243.setProperty("clrValues");
                                      __jsp_taghandler_243.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_243.doStartTag();
                                      if (__jsp_taghandler_243.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_243,6);
                                    }
                                    out.write(__oracle_jsp_text[303]);
                                  } while (__jsp_taghandler_242.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_242.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_242,5);
                              }
                              out.write(__oracle_jsp_text[304]);
                            } while (__jsp_taghandler_240.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_240.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_240,4);
                        }
                        out.write(__oracle_jsp_text[305]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_244=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_244.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_244.setId("specialCargo");
                          __jsp_tag_starteval=__jsp_taghandler_244.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_244,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_245=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                                __jsp_taghandler_245.setParent(__jsp_taghandler_244);
                                __jsp_taghandler_245.setMaxlength("3");
                                __jsp_taghandler_245.setName("fedl002");
                                __jsp_taghandler_245.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialCargo"));
                                __jsp_taghandler_245.setReadonly(true);
                                __jsp_taghandler_245.setStyle("width:96%");
                                __jsp_taghandler_245.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_245.doStartTag();
                                if (__jsp_taghandler_245.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_245,5);
                              }
                            } while (__jsp_taghandler_244.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_244.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_244,4);
                        }
                        out.write(__oracle_jsp_text[306]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_246=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_246.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_246.setId("tightConnectionPOD1");
                          __jsp_tag_starteval=__jsp_taghandler_246.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_246,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[307]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_247=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_247.setParent(__jsp_taghandler_246);
                                __jsp_taghandler_247.setName("fedl002");
                                __jsp_taghandler_247.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_247.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].tightConnectionPOD1"));
                                __jsp_taghandler_247.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_247.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_247,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[308]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_248=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_248.setParent(__jsp_taghandler_247);
                                      __jsp_taghandler_248.setLabel("name");
                                      __jsp_taghandler_248.setName("fedl002");
                                      __jsp_taghandler_248.setProperty("tightConnectionPODValues");
                                      __jsp_taghandler_248.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_248.doStartTag();
                                      if (__jsp_taghandler_248.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_248,6);
                                    }
                                    out.write(__oracle_jsp_text[309]);
                                  } while (__jsp_taghandler_247.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_247.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_247,5);
                              }
                              out.write(__oracle_jsp_text[310]);
                            } while (__jsp_taghandler_246.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_246.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_246,4);
                        }
                        out.write(__oracle_jsp_text[311]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_249=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_249.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_249.setId("tightConnectionPOD2");
                          __jsp_tag_starteval=__jsp_taghandler_249.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_249,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[312]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_250=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_250.setParent(__jsp_taghandler_249);
                                __jsp_taghandler_250.setName("fedl002");
                                __jsp_taghandler_250.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_250.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].tightConnectionPOD2"));
                                __jsp_taghandler_250.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_250.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_250,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[313]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_251=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_251.setParent(__jsp_taghandler_250);
                                      __jsp_taghandler_251.setLabel("name");
                                      __jsp_taghandler_251.setName("fedl002");
                                      __jsp_taghandler_251.setProperty("tightConnectionPODValues");
                                      __jsp_taghandler_251.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_251.doStartTag();
                                      if (__jsp_taghandler_251.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_251,6);
                                    }
                                    out.write(__oracle_jsp_text[314]);
                                  } while (__jsp_taghandler_250.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_250.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_250,5);
                              }
                              out.write(__oracle_jsp_text[315]);
                            } while (__jsp_taghandler_249.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_249.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_249,4);
                        }
                        out.write(__oracle_jsp_text[316]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_252=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_252.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_252.setId("tightConnectionPOD3");
                          __jsp_tag_starteval=__jsp_taghandler_252.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_252,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[317]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_253=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_253.setParent(__jsp_taghandler_252);
                                __jsp_taghandler_253.setName("fedl002");
                                __jsp_taghandler_253.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_253.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].tightConnectionPOD3"));
                                __jsp_taghandler_253.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_253.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_253,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[318]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_254=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_254.setParent(__jsp_taghandler_253);
                                      __jsp_taghandler_254.setLabel("name");
                                      __jsp_taghandler_254.setName("fedl002");
                                      __jsp_taghandler_254.setProperty("tightConnectionPODValues");
                                      __jsp_taghandler_254.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_254.doStartTag();
                                      if (__jsp_taghandler_254.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_254,6);
                                    }
                                    out.write(__oracle_jsp_text[319]);
                                  } while (__jsp_taghandler_253.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_253.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_253,5);
                              }
                              out.write(__oracle_jsp_text[320]);
                            } while (__jsp_taghandler_252.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_252.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_252,4);
                        }
                        out.write(__oracle_jsp_text[321]);
                        out.write(__oracle_jsp_text[322]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_255=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_255.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_255.setName("fedl002");
                          __jsp_taghandler_255.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].isUpdateDG"));
                          __jsp_taghandler_255.setValue("TRUE");
                          __jsp_tag_starteval=__jsp_taghandler_255.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[323]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_256=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_256.setParent(__jsp_taghandler_255);
                                __jsp_taghandler_256.setId("imdgClass");
                                __jsp_tag_starteval=__jsp_taghandler_256.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_256,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_257=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_257.setParent(__jsp_taghandler_256);
                                      __jsp_taghandler_257.setMaxlength("4");
                                      __jsp_taghandler_257.setName("fedl002");
                                      __jsp_taghandler_257.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_257.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].imdgClass"));
                                      __jsp_taghandler_257.setReadonly(true);
                                      __jsp_taghandler_257.setStyle("width:96%");
                                      __jsp_taghandler_257.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_257.doStartTag();
                                      if (__jsp_taghandler_257.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_257,6);
                                    }
                                  } while (__jsp_taghandler_256.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_256.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_256,5);
                              }
                              out.write(__oracle_jsp_text[324]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_258=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_258.setParent(__jsp_taghandler_255);
                                __jsp_taghandler_258.setId("unNumber");
                                __jsp_tag_starteval=__jsp_taghandler_258.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_258,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[325]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_259=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_259.setParent(__jsp_taghandler_258);
                                      __jsp_taghandler_259.setMaxlength("6");
                                      __jsp_taghandler_259.setName("fedl002");
                                      __jsp_taghandler_259.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_259.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].unNumber"));
                                      __jsp_taghandler_259.setReadonly(true);
                                      __jsp_taghandler_259.setStyle("width:75%");
                                      __jsp_taghandler_259.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_259.doStartTag();
                                      if (__jsp_taghandler_259.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_259,6);
                                    }
                                    out.write(__oracle_jsp_text[326]);
                                    out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                    out.write(__oracle_jsp_text[327]);
                                  } while (__jsp_taghandler_258.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_258.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_258,5);
                              }
                              out.write(__oracle_jsp_text[328]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_260=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_260.setParent(__jsp_taghandler_255);
                                __jsp_taghandler_260.setId("unNumberVariant");
                                __jsp_tag_starteval=__jsp_taghandler_260.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_260,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_261=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_261.setParent(__jsp_taghandler_260);
                                      __jsp_taghandler_261.setMaxlength("1");
                                      __jsp_taghandler_261.setName("fedl002");
                                      __jsp_taghandler_261.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_261.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].unNumberVariant"));
                                      __jsp_taghandler_261.setReadonly(true);
                                      __jsp_taghandler_261.setStyle("width:96%");
                                      __jsp_taghandler_261.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_261.doStartTag();
                                      if (__jsp_taghandler_261.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_261,6);
                                    }
                                  } while (__jsp_taghandler_260.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_260.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_260,5);
                              }
                              out.write(__oracle_jsp_text[329]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_262=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_262.setParent(__jsp_taghandler_255);
                                __jsp_taghandler_262.setId("portClass");
                                __jsp_tag_starteval=__jsp_taghandler_262.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_262,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_263=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_263.setParent(__jsp_taghandler_262);
                                      __jsp_taghandler_263.setMaxlength("5");
                                      __jsp_taghandler_263.setName("fedl002");
                                      __jsp_taghandler_263.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_263.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].portClass"));
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
                              out.write(__oracle_jsp_text[330]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_264=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_264.setParent(__jsp_taghandler_255);
                                __jsp_taghandler_264.setId("portClassType");
                                __jsp_tag_starteval=__jsp_taghandler_264.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_264,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_265=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                      __jsp_taghandler_265.setParent(__jsp_taghandler_264);
                                      __jsp_taghandler_265.setMaxlength("5");
                                      __jsp_taghandler_265.setName("fedl002");
                                      __jsp_taghandler_265.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_265.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].portClassType"));
                                      __jsp_taghandler_265.setReadonly(true);
                                      __jsp_taghandler_265.setStyle("width:96%");
                                      __jsp_taghandler_265.setStyleClass("non_edit");
                                      __jsp_tag_starteval=__jsp_taghandler_265.doStartTag();
                                      if (__jsp_taghandler_265.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_265,6);
                                    }
                                  } while (__jsp_taghandler_264.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_264.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_264,5);
                              }
                              out.write(__oracle_jsp_text[331]);
                            } while (__jsp_taghandler_255.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_255.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_255,4);
                        }
                        out.write(__oracle_jsp_text[332]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_266=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_266.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_266.setName("fedl002");
                          __jsp_taghandler_266.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].isUpdateDG"));
                          __jsp_taghandler_266.setValue("TRUE");
                          __jsp_tag_starteval=__jsp_taghandler_266.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[333]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_267=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_267.setParent(__jsp_taghandler_266);
                                __jsp_taghandler_267.setId("imdgClass");
                                __jsp_tag_starteval=__jsp_taghandler_267.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_267,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_268=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_268.setParent(__jsp_taghandler_267);
                                      __jsp_taghandler_268.setMaxlength("4");
                                      __jsp_taghandler_268.setName("fedl002");
                                      __jsp_taghandler_268.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_268.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].imdgClass"));
                                      __jsp_taghandler_268.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_268.doStartTag();
                                      if (__jsp_taghandler_268.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_268,6);
                                    }
                                  } while (__jsp_taghandler_267.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_267.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_267,5);
                              }
                              out.write(__oracle_jsp_text[334]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_269=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_269.setParent(__jsp_taghandler_266);
                                __jsp_taghandler_269.setId("unNumber");
                                __jsp_tag_starteval=__jsp_taghandler_269.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_269,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[335]);
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_270=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_270.setParent(__jsp_taghandler_269);
                                      __jsp_taghandler_270.setMaxlength("6");
                                      __jsp_taghandler_270.setName("fedl002");
                                      __jsp_taghandler_270.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_270.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].unNumber"));
                                      __jsp_taghandler_270.setStyle("width:75%");
                                      __jsp_tag_starteval=__jsp_taghandler_270.doStartTag();
                                      if (__jsp_taghandler_270.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_270,6);
                                    }
                                    out.write(__oracle_jsp_text[336]);
                                    out.write( (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null));
                                    out.write(__oracle_jsp_text[337]);
                                  } while (__jsp_taghandler_269.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_269.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_269,5);
                              }
                              out.write(__oracle_jsp_text[338]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_271=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_271.setParent(__jsp_taghandler_266);
                                __jsp_taghandler_271.setId("unNumberVariant");
                                __jsp_tag_starteval=__jsp_taghandler_271.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_271,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_272=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_272.setParent(__jsp_taghandler_271);
                                      __jsp_taghandler_272.setMaxlength("1");
                                      __jsp_taghandler_272.setName("fedl002");
                                      __jsp_taghandler_272.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_272.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].unNumberVariant"));
                                      __jsp_taghandler_272.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_272.doStartTag();
                                      if (__jsp_taghandler_272.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_272,6);
                                    }
                                  } while (__jsp_taghandler_271.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_271.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_271,5);
                              }
                              out.write(__oracle_jsp_text[339]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_273=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_273.setParent(__jsp_taghandler_266);
                                __jsp_taghandler_273.setId("portClass");
                                __jsp_tag_starteval=__jsp_taghandler_273.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_273,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_274=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_274.setParent(__jsp_taghandler_273);
                                      __jsp_taghandler_274.setMaxlength("5");
                                      __jsp_taghandler_274.setName("fedl002");
                                      __jsp_taghandler_274.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_274.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].portClass"));
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
                              out.write(__oracle_jsp_text[340]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_275=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_275.setParent(__jsp_taghandler_266);
                                __jsp_taghandler_275.setId("portClassType");
                                __jsp_tag_starteval=__jsp_taghandler_275.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_275,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_276=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                      __jsp_taghandler_276.setParent(__jsp_taghandler_275);
                                      __jsp_taghandler_276.setMaxlength("5");
                                      __jsp_taghandler_276.setName("fedl002");
                                      __jsp_taghandler_276.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                      __jsp_taghandler_276.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].portClassType"));
                                      __jsp_taghandler_276.setStyle("width:96%");
                                      __jsp_tag_starteval=__jsp_taghandler_276.doStartTag();
                                      if (__jsp_taghandler_276.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_276,6);
                                    }
                                  } while (__jsp_taghandler_275.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_275.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_275,5);
                              }
                              out.write(__oracle_jsp_text[341]);
                            } while (__jsp_taghandler_266.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_266.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_266,4);
                        }
                        out.write(__oracle_jsp_text[342]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_277=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_277.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_277.setId("flashUnit");
                          __jsp_tag_starteval=__jsp_taghandler_277.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_277,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[343]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_278=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_278.setParent(__jsp_taghandler_277);
                                __jsp_taghandler_278.setName("fedl002");
                                __jsp_taghandler_278.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_278.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].flashUnit"));
                                __jsp_taghandler_278.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_278.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_278,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[344]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_279=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_279.setParent(__jsp_taghandler_278);
                                      __jsp_taghandler_279.setLabel("name");
                                      __jsp_taghandler_279.setName("fedl002");
                                      __jsp_taghandler_279.setProperty("flashUnitValues");
                                      __jsp_taghandler_279.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_279.doStartTag();
                                      if (__jsp_taghandler_279.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_279,6);
                                    }
                                    out.write(__oracle_jsp_text[345]);
                                  } while (__jsp_taghandler_278.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_278.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_278,5);
                              }
                              out.write(__oracle_jsp_text[346]);
                            } while (__jsp_taghandler_277.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_277.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_277,4);
                        }
                        out.write(__oracle_jsp_text[347]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_280=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_280.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_280.setId("flashPoint");
                          __jsp_tag_starteval=__jsp_taghandler_280.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_280,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_281=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_281.setParent(__jsp_taghandler_280);
                                __jsp_taghandler_281.setMaxlength("7");
                                __jsp_taghandler_281.setName("fedl002");
                                __jsp_taghandler_281.setOnblur((java.lang.String) ("putMask_Number(this, 3, 3);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_281.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_281.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].flashPoint"));
                                __jsp_taghandler_281.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_281.doStartTag();
                                if (__jsp_taghandler_281.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_281,5);
                              }
                            } while (__jsp_taghandler_280.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_280.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_280,4);
                        }
                        out.write(__oracle_jsp_text[348]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_282=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_282.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_282.setId("fumigationOnly");
                          __jsp_tag_starteval=__jsp_taghandler_282.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_282,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[349]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_283=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_283.setParent(__jsp_taghandler_282);
                                __jsp_taghandler_283.setName("fedl002");
                                __jsp_taghandler_283.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_283.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].fumigationOnly"));
                                __jsp_taghandler_283.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_283.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_283,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[350]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_284=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_284.setParent(__jsp_taghandler_283);
                                      __jsp_taghandler_284.setLabel("name");
                                      __jsp_taghandler_284.setName("fedl002");
                                      __jsp_taghandler_284.setProperty("fumigationOnlyValues");
                                      __jsp_taghandler_284.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_284.doStartTag();
                                      if (__jsp_taghandler_284.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_284,6);
                                    }
                                    out.write(__oracle_jsp_text[351]);
                                  } while (__jsp_taghandler_283.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_283.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_283,5);
                              }
                              out.write(__oracle_jsp_text[352]);
                            } while (__jsp_taghandler_282.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_282.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_282,4);
                        }
                        out.write(__oracle_jsp_text[353]);
                        out.write(__oracle_jsp_text[354]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_285=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_285.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_285.setId("residue");
                          __jsp_tag_starteval=__jsp_taghandler_285.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_285,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[355]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_286=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_286.setParent(__jsp_taghandler_285);
                                __jsp_taghandler_286.setName("fedl002");
                                __jsp_taghandler_286.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_286.setValue("DG");
                                __jsp_tag_starteval=__jsp_taghandler_286.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[356]);
                                    {
                                      org.apache.struts.taglib.html.SelectTag __jsp_taghandler_287=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag disabled name property style");
                                      __jsp_taghandler_287.setParent(__jsp_taghandler_286);
                                      __jsp_taghandler_287.setDisabled(true);
                                      __jsp_taghandler_287.setName("fedl002");
                                      __jsp_taghandler_287.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].residue"));
                                      __jsp_taghandler_287.setStyle("width:98%");
                                      __jsp_tag_starteval=__jsp_taghandler_287.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_287,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[357]);
                                          {
                                            org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_288=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                            __jsp_taghandler_288.setParent(__jsp_taghandler_287);
                                            __jsp_taghandler_288.setLabel("name");
                                            __jsp_taghandler_288.setName("fedl002");
                                            __jsp_taghandler_288.setProperty("residueValues");
                                            __jsp_taghandler_288.setValue("code");
                                            __jsp_tag_starteval=__jsp_taghandler_288.doStartTag();
                                            if (__jsp_taghandler_288.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_288,7);
                                          }
                                          out.write(__oracle_jsp_text[358]);
                                        } while (__jsp_taghandler_287.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_287.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_287,6);
                                    }
                                    out.write(__oracle_jsp_text[359]);
                                  } while (__jsp_taghandler_286.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_286.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_286,5);
                              }
                              out.write(__oracle_jsp_text[360]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_289=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_289.setParent(__jsp_taghandler_285);
                                __jsp_taghandler_289.setName("fedl002");
                                __jsp_taghandler_289.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_289.setValue("DG");
                                __jsp_tag_starteval=__jsp_taghandler_289.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[361]);
                                    {
                                      org.apache.struts.taglib.html.SelectTag __jsp_taghandler_290=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                      __jsp_taghandler_290.setParent(__jsp_taghandler_289);
                                      __jsp_taghandler_290.setName("fedl002");
                                      __jsp_taghandler_290.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'residue',this)"));
                                      __jsp_taghandler_290.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].residue"));
                                      __jsp_taghandler_290.setStyle("width:98%");
                                      __jsp_tag_starteval=__jsp_taghandler_290.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_290,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[362]);
                                          {
                                            org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_291=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                            __jsp_taghandler_291.setParent(__jsp_taghandler_290);
                                            __jsp_taghandler_291.setLabel("name");
                                            __jsp_taghandler_291.setName("fedl002");
                                            __jsp_taghandler_291.setProperty("residueValues");
                                            __jsp_taghandler_291.setValue("code");
                                            __jsp_tag_starteval=__jsp_taghandler_291.doStartTag();
                                            if (__jsp_taghandler_291.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_291,7);
                                          }
                                          out.write(__oracle_jsp_text[363]);
                                        } while (__jsp_taghandler_290.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_290.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_290,6);
                                    }
                                    out.write(__oracle_jsp_text[364]);
                                  } while (__jsp_taghandler_289.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_289.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_289,5);
                              }
                              out.write(__oracle_jsp_text[365]);
                            } while (__jsp_taghandler_285.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_285.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_285,4);
                        }
                        out.write(__oracle_jsp_text[366]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_292=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_292.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_292.setId("overheight");
                          __jsp_tag_starteval=__jsp_taghandler_292.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_292,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_293=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_293.setParent(__jsp_taghandler_292);
                                __jsp_taghandler_293.setMaxlength("15");
                                __jsp_taghandler_293.setName("fedl002");
                                __jsp_taghandler_293.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_293.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_293.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overheight"));
                                __jsp_taghandler_293.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_293.doStartTag();
                                if (__jsp_taghandler_293.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_293,5);
                              }
                            } while (__jsp_taghandler_292.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_292.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_292,4);
                        }
                        out.write(__oracle_jsp_text[367]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_294=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_294.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_294.setId("overwidthLeft");
                          __jsp_tag_starteval=__jsp_taghandler_294.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_294,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_295=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_295.setParent(__jsp_taghandler_294);
                                __jsp_taghandler_295.setMaxlength("15");
                                __jsp_taghandler_295.setName("fedl002");
                                __jsp_taghandler_295.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_295.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_295.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overwidthLeft"));
                                __jsp_taghandler_295.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_295.doStartTag();
                                if (__jsp_taghandler_295.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_295,5);
                              }
                            } while (__jsp_taghandler_294.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_294.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_294,4);
                        }
                        out.write(__oracle_jsp_text[368]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_296=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_296.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_296.setId("overwidthRight");
                          __jsp_tag_starteval=__jsp_taghandler_296.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_296,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_297=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_297.setParent(__jsp_taghandler_296);
                                __jsp_taghandler_297.setMaxlength("15");
                                __jsp_taghandler_297.setName("fedl002");
                                __jsp_taghandler_297.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_297.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_297.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overwidthRight"));
                                __jsp_taghandler_297.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_297.doStartTag();
                                if (__jsp_taghandler_297.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_297,5);
                              }
                            } while (__jsp_taghandler_296.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_296.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_296,4);
                        }
                        out.write(__oracle_jsp_text[369]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_298=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_298.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_298.setId("overlengthFront");
                          __jsp_tag_starteval=__jsp_taghandler_298.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_298,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_299=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_299.setParent(__jsp_taghandler_298);
                                __jsp_taghandler_299.setMaxlength("15");
                                __jsp_taghandler_299.setName("fedl002");
                                __jsp_taghandler_299.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_299.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_299.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overlengthFront"));
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
                        out.write(__oracle_jsp_text[370]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_300=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_300.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_300.setId("overlengthAfter");
                          __jsp_tag_starteval=__jsp_taghandler_300.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_300,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_301=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_301.setParent(__jsp_taghandler_300);
                                __jsp_taghandler_301.setMaxlength("15");
                                __jsp_taghandler_301.setName("fedl002");
                                __jsp_taghandler_301.setOnblur((java.lang.String) ("putMask_Number(this, 10, 4);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_301.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_301.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].overlengthAfter"));
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
                        out.write(__oracle_jsp_text[371]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_302=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_302.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_302.setId("reeferTemp");
                          __jsp_tag_starteval=__jsp_taghandler_302.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_302,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_303=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                __jsp_taghandler_303.setParent(__jsp_taghandler_302);
                                __jsp_taghandler_303.setMaxlength("8");
                                __jsp_taghandler_303.setName("fedl002");
                                __jsp_taghandler_303.setOnblur((java.lang.String) ("putMask_Number(this, 3, 3);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                __jsp_taghandler_303.setOnclick("hideMask_Number(this);");
                                __jsp_taghandler_303.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferTemp"));
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
                        out.write(__oracle_jsp_text[372]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_304=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_304.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_304.setId("reeferTempUnit");
                          __jsp_tag_starteval=__jsp_taghandler_304.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_304,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[373]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_305=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag name onblur property style");
                                __jsp_taghandler_305.setParent(__jsp_taghandler_304);
                                __jsp_taghandler_305.setName("fedl002");
                                __jsp_taghandler_305.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_305.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferTempUnit"));
                                __jsp_taghandler_305.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_305.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_305,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[374]);
                                    {
                                      org.apache.struts.taglib.html.OptionsCollectionTag __jsp_taghandler_306=(org.apache.struts.taglib.html.OptionsCollectionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionsCollectionTag.class,"org.apache.struts.taglib.html.OptionsCollectionTag label name property value");
                                      __jsp_taghandler_306.setParent(__jsp_taghandler_305);
                                      __jsp_taghandler_306.setLabel("name");
                                      __jsp_taghandler_306.setName("fedl002");
                                      __jsp_taghandler_306.setProperty("reeferTempUnitValues");
                                      __jsp_taghandler_306.setValue("code");
                                      __jsp_tag_starteval=__jsp_taghandler_306.doStartTag();
                                      if (__jsp_taghandler_306.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_306,6);
                                    }
                                    out.write(__oracle_jsp_text[375]);
                                  } while (__jsp_taghandler_305.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_305.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_305,5);
                              }
                              out.write(__oracle_jsp_text[376]);
                            } while (__jsp_taghandler_304.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_304.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_304,4);
                        }
                        out.write(__oracle_jsp_text[377]);
                        out.write(__oracle_jsp_text[378]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_307=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_307.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_307.setName("fedl002");
                          __jsp_taghandler_307.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferFlag"));
                          __jsp_taghandler_307.setValue("N");
                          __jsp_tag_starteval=__jsp_taghandler_307.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[379]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_308=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_308.setParent(__jsp_taghandler_307);
                                __jsp_taghandler_308.setId("humidity");
                                __jsp_tag_starteval=__jsp_taghandler_308.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_308,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_309=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                      __jsp_taghandler_309.setParent(__jsp_taghandler_308);
                                      __jsp_taghandler_309.setMaxlength("5");
                                      __jsp_taghandler_309.setName("fedl002");
                                      __jsp_taghandler_309.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].humidity"));
                                      __jsp_taghandler_309.setReadonly(true);
                                      __jsp_taghandler_309.setStyle("width:96%");
                                      __jsp_taghandler_309.setStyleClass("non_edit");
                                      __jsp_taghandler_309.setValue("");
                                      __jsp_tag_starteval=__jsp_taghandler_309.doStartTag();
                                      if (__jsp_taghandler_309.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_309,6);
                                    }
                                  } while (__jsp_taghandler_308.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_308.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_308,5);
                              }
                              out.write(__oracle_jsp_text[380]);
                            } while (__jsp_taghandler_307.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_307.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_307,4);
                        }
                        out.write(__oracle_jsp_text[381]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_310=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_310.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_310.setName("fedl002");
                          __jsp_taghandler_310.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferFlag"));
                          __jsp_taghandler_310.setValue("N");
                          __jsp_tag_starteval=__jsp_taghandler_310.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[382]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_311=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_311.setParent(__jsp_taghandler_310);
                                __jsp_taghandler_311.setName("fedl002");
                                __jsp_taghandler_311.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_311.setValue("Non Reefer");
                                __jsp_tag_starteval=__jsp_taghandler_311.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[383]);
                                    {
                                      com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_312=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                      __jsp_taghandler_312.setParent(__jsp_taghandler_311);
                                      __jsp_taghandler_312.setId("humidity");
                                      __jsp_tag_starteval=__jsp_taghandler_312.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_312,__jsp_tag_starteval,out);
                                        do {
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_313=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                            __jsp_taghandler_313.setParent(__jsp_taghandler_312);
                                            __jsp_taghandler_313.setMaxlength("5");
                                            __jsp_taghandler_313.setName("fedl002");
                                            __jsp_taghandler_313.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].humidity"));
                                            __jsp_taghandler_313.setReadonly(true);
                                            __jsp_taghandler_313.setStyle("width:96%");
                                            __jsp_taghandler_313.setStyleClass("non_edit");
                                            __jsp_taghandler_313.setValue("");
                                            __jsp_tag_starteval=__jsp_taghandler_313.doStartTag();
                                            if (__jsp_taghandler_313.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_313,7);
                                          }
                                        } while (__jsp_taghandler_312.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_312.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_312,6);
                                    }
                                    out.write(__oracle_jsp_text[384]);
                                  } while (__jsp_taghandler_311.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_311.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_311,5);
                              }
                              out.write(__oracle_jsp_text[385]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_314=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_314.setParent(__jsp_taghandler_310);
                                __jsp_taghandler_314.setName("fedl002");
                                __jsp_taghandler_314.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_314.setValue("Non Reefer");
                                __jsp_tag_starteval=__jsp_taghandler_314.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[386]);
                                    {
                                      com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_315=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                      __jsp_taghandler_315.setParent(__jsp_taghandler_314);
                                      __jsp_taghandler_315.setId("humidity");
                                      __jsp_tag_starteval=__jsp_taghandler_315.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_315,__jsp_tag_starteval,out);
                                        do {
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_316=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                            __jsp_taghandler_316.setParent(__jsp_taghandler_315);
                                            __jsp_taghandler_316.setMaxlength("6");
                                            __jsp_taghandler_316.setName("fedl002");
                                            __jsp_taghandler_316.setOnblur((java.lang.String) ("putMask_Number(this, 3, 2);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                            __jsp_taghandler_316.setOnclick("hideMask_Number(this);");
                                            __jsp_taghandler_316.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].humidity"));
                                            __jsp_taghandler_316.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_316.doStartTag();
                                            if (__jsp_taghandler_316.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_316,7);
                                          }
                                        } while (__jsp_taghandler_315.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_315.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_315,6);
                                    }
                                    out.write(__oracle_jsp_text[387]);
                                  } while (__jsp_taghandler_314.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_314.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_314,5);
                              }
                              out.write(__oracle_jsp_text[388]);
                            } while (__jsp_taghandler_310.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_310.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_310,4);
                        }
                        out.write(__oracle_jsp_text[389]);
                        out.write(__oracle_jsp_text[390]);
                        out.write(__oracle_jsp_text[391]);
                        {
                          org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_317=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                          __jsp_taghandler_317.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_317.setName("fedl002");
                          __jsp_taghandler_317.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferFlag"));
                          __jsp_taghandler_317.setValue("N");
                          __jsp_tag_starteval=__jsp_taghandler_317.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[392]);
                              {
                                com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_318=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                __jsp_taghandler_318.setParent(__jsp_taghandler_317);
                                __jsp_taghandler_318.setId("ventilation");
                                __jsp_tag_starteval=__jsp_taghandler_318.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_318,__jsp_tag_starteval,out);
                                  do {
                                    {
                                      org.apache.struts.taglib.html.TextTag __jsp_taghandler_319=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                      __jsp_taghandler_319.setParent(__jsp_taghandler_318);
                                      __jsp_taghandler_319.setMaxlength("5");
                                      __jsp_taghandler_319.setName("fedl002");
                                      __jsp_taghandler_319.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].ventilation"));
                                      __jsp_taghandler_319.setReadonly(true);
                                      __jsp_taghandler_319.setStyle("width:96%");
                                      __jsp_taghandler_319.setStyleClass("non_edit");
                                      __jsp_taghandler_319.setValue("");
                                      __jsp_tag_starteval=__jsp_taghandler_319.doStartTag();
                                      if (__jsp_taghandler_319.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_319,6);
                                    }
                                  } while (__jsp_taghandler_318.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_318.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_318,5);
                              }
                              out.write(__oracle_jsp_text[393]);
                            } while (__jsp_taghandler_317.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_317.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_317,4);
                        }
                        out.write(__oracle_jsp_text[394]);
                        {
                          org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_320=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                          __jsp_taghandler_320.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_320.setName("fedl002");
                          __jsp_taghandler_320.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].reeferFlag"));
                          __jsp_taghandler_320.setValue("N");
                          __jsp_tag_starteval=__jsp_taghandler_320.doStartTag();
                          if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                          {
                            do {
                              out.write(__oracle_jsp_text[395]);
                              {
                                org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_321=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                                __jsp_taghandler_321.setParent(__jsp_taghandler_320);
                                __jsp_taghandler_321.setName("fedl002");
                                __jsp_taghandler_321.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_321.setValue("Non Reefer");
                                __jsp_tag_starteval=__jsp_taghandler_321.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[396]);
                                    {
                                      com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_322=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                      __jsp_taghandler_322.setParent(__jsp_taghandler_321);
                                      __jsp_taghandler_322.setId("ventilation");
                                      __jsp_tag_starteval=__jsp_taghandler_322.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_322,__jsp_tag_starteval,out);
                                        do {
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_323=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass value");
                                            __jsp_taghandler_323.setParent(__jsp_taghandler_322);
                                            __jsp_taghandler_323.setMaxlength("5");
                                            __jsp_taghandler_323.setName("fedl002");
                                            __jsp_taghandler_323.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].ventilation"));
                                            __jsp_taghandler_323.setReadonly(true);
                                            __jsp_taghandler_323.setStyle("width:96%");
                                            __jsp_taghandler_323.setStyleClass("non_edit");
                                            __jsp_taghandler_323.setValue("");
                                            __jsp_tag_starteval=__jsp_taghandler_323.doStartTag();
                                            if (__jsp_taghandler_323.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_323,7);
                                          }
                                        } while (__jsp_taghandler_322.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_322.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_322,6);
                                    }
                                    out.write(__oracle_jsp_text[397]);
                                  } while (__jsp_taghandler_321.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_321.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_321,5);
                              }
                              out.write(__oracle_jsp_text[398]);
                              {
                                org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_324=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                                __jsp_taghandler_324.setParent(__jsp_taghandler_320);
                                __jsp_taghandler_324.setName("fedl002");
                                __jsp_taghandler_324.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandling"));
                                __jsp_taghandler_324.setValue("Non Reefer");
                                __jsp_tag_starteval=__jsp_taghandler_324.doStartTag();
                                if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                                {
                                  do {
                                    out.write(__oracle_jsp_text[399]);
                                    {
                                      com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_325=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                                      __jsp_taghandler_325.setParent(__jsp_taghandler_324);
                                      __jsp_taghandler_325.setId("ventilation");
                                      __jsp_tag_starteval=__jsp_taghandler_325.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_325,__jsp_tag_starteval,out);
                                        do {
                                          {
                                            org.apache.struts.taglib.html.TextTag __jsp_taghandler_326=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onclick property style");
                                            __jsp_taghandler_326.setParent(__jsp_taghandler_325);
                                            __jsp_taghandler_326.setMaxlength("6");
                                            __jsp_taghandler_326.setName("fedl002");
                                            __jsp_taghandler_326.setOnblur((java.lang.String) ("putMask_Number(this, 3, 2);updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+");"));
                                            __jsp_taghandler_326.setOnclick("hideMask_Number(this);");
                                            __jsp_taghandler_326.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].ventilation"));
                                            __jsp_taghandler_326.setStyle("width:96%");
                                            __jsp_tag_starteval=__jsp_taghandler_326.doStartTag();
                                            if (__jsp_taghandler_326.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                              return;
                                            OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_326,7);
                                          }
                                        } while (__jsp_taghandler_325.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_325.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_325,6);
                                    }
                                    out.write(__oracle_jsp_text[400]);
                                  } while (__jsp_taghandler_324.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                }
                                if (__jsp_taghandler_324.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_324,5);
                              }
                              out.write(__oracle_jsp_text[401]);
                            } while (__jsp_taghandler_320.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                          }
                          if (__jsp_taghandler_320.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_320,4);
                        }
                        out.write(__oracle_jsp_text[402]);
                        out.write(__oracle_jsp_text[403]);
                        out.write(__oracle_jsp_text[404]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_327=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_327.setParent(__jsp_taghandler_81);
                          __jsp_taghandler_327.setId("remarks");
                          __jsp_tag_starteval=__jsp_taghandler_327.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_327,__jsp_tag_starteval,out);
                            do {
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_328=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                                __jsp_taghandler_328.setParent(__jsp_taghandler_327);
                                __jsp_taghandler_328.setMaxlength("2000");
                                __jsp_taghandler_328.setName("fedl002");
                                __jsp_taghandler_328.setOnblur((java.lang.String) ("updateBookingStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_328.setProperty((java.lang.String) ("bookingValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].remarks"));
                                __jsp_taghandler_328.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_328.doStartTag();
                                if (__jsp_taghandler_328.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_328,5);
                              }
                            } while (__jsp_taghandler_327.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_327.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_327,4);
                        }
                        out.write(__oracle_jsp_text[405]);
                      } while (__jsp_taghandler_81.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_81.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_81,3);
                  }
                  out.write(__oracle_jsp_text[406]);
                } while (__jsp_taghandler_80.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_80.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_80,2);
            }
            out.write(__oracle_jsp_text[407]);
          } while (__jsp_taghandler_3.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,1);
      }
      out.write(__oracle_jsp_text[408]);
      {
        org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_329=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
        __jsp_taghandler_329.setParent(null);
        __jsp_taghandler_329.setName("fedl002");
        __jsp_taghandler_329.setProperty("vesselOwner");
        __jsp_tag_starteval=__jsp_taghandler_329.doStartTag();
        if (__jsp_taghandler_329.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_329,1);
      }
      out.write(__oracle_jsp_text[409]);
      {
        org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_330=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
        __jsp_taghandler_330.setParent(null);
        __jsp_taghandler_330.setId("rowdata");
        __jsp_taghandler_330.setIndexId("ctr");
        __jsp_taghandler_330.setName("fedl002");
        __jsp_taghandler_330.setProperty("marlBookedDtlTable");
        __jsp_taghandler_330.setType("com.rclgroup.dolphin.ezl.web.edl.vo.EdlDischargeListBookingMod");
        com.rclgroup.dolphin.ezl.web.edl.vo.EdlDischargeListBookingMod rowdata = null;
        java.lang.Integer ctr = null;
        __jsp_tag_starteval=__jsp_taghandler_330.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_330,__jsp_tag_starteval,out);
          do {
            rowdata = (com.rclgroup.dolphin.ezl.web.edl.vo.EdlDischargeListBookingMod) pageContext.findAttribute("rowdata");
            ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
            out.write(__oracle_jsp_text[410]);
            out.print( "row" + ctr );
            out.write(__oracle_jsp_text[411]);
            {
              org.apache.struts.taglib.html.RadioTag __jsp_taghandler_331=(org.apache.struts.taglib.html.RadioTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.RadioTag.class,"org.apache.struts.taglib.html.RadioTag name onclick property styleClass value");
              __jsp_taghandler_331.setParent(__jsp_taghandler_330);
              __jsp_taghandler_331.setName("fedl002");
              __jsp_taghandler_331.setOnclick(OracleJspRuntime.toStr( "highlightRow("+ctr+")"));
              __jsp_taghandler_331.setProperty("radioGroup1");
              __jsp_taghandler_331.setStyleClass("check");
              __jsp_taghandler_331.setValue(OracleJspRuntime.toStr( ctr));
              __jsp_tag_starteval=__jsp_taghandler_331.doStartTag();
              if (__jsp_taghandler_331.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_331,2);
            }
            out.write(__oracle_jsp_text[412]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_332=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_332.setParent(__jsp_taghandler_330);
              __jsp_taghandler_332.setMaxlength("5");
              __jsp_taghandler_332.setName("fedl002");
              __jsp_taghandler_332.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].contSeq"));
              __jsp_taghandler_332.setReadonly(true);
              __jsp_taghandler_332.setStyle("width:96%");
              __jsp_taghandler_332.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_332.doStartTag();
              if (__jsp_taghandler_332.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_332,2);
            }
            out.write(__oracle_jsp_text[413]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_333=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_333.setParent(__jsp_taghandler_330);
              __jsp_taghandler_333.setMaxlength("17");
              __jsp_taghandler_333.setName("fedl002");
              __jsp_taghandler_333.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].bookingNo"));
              __jsp_taghandler_333.setReadonly(true);
              __jsp_taghandler_333.setStyle("width:96%");
              __jsp_taghandler_333.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_333.doStartTag();
              if (__jsp_taghandler_333.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_333,2);
            }
            out.write(__oracle_jsp_text[414]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_334=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_334.setParent(__jsp_taghandler_330);
              __jsp_taghandler_334.setName("fedl002");
              __jsp_taghandler_334.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].bookedId"));
              __jsp_tag_starteval=__jsp_taghandler_334.doStartTag();
              if (__jsp_taghandler_334.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_334,2);
            }
            out.write(__oracle_jsp_text[415]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_335=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_335.setParent(__jsp_taghandler_330);
              __jsp_taghandler_335.setName("fedl002");
              __jsp_taghandler_335.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].recordChangeDt"));
              __jsp_tag_starteval=__jsp_taghandler_335.doStartTag();
              if (__jsp_taghandler_335.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_335,2);
            }
            out.write(__oracle_jsp_text[416]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_336=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_336.setParent(__jsp_taghandler_330);
              __jsp_taghandler_336.setName("fedl002");
              __jsp_taghandler_336.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].status"));
              __jsp_tag_starteval=__jsp_taghandler_336.doStartTag();
              if (__jsp_taghandler_336.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_336,2);
            }
            out.write(__oracle_jsp_text[417]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_337=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_337.setParent(__jsp_taghandler_330);
              __jsp_taghandler_337.setName("fedl002");
              __jsp_taghandler_337.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].bookedSeqNo"));
              __jsp_tag_starteval=__jsp_taghandler_337.doStartTag();
              if (__jsp_taghandler_337.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_337,2);
            }
            out.write(__oracle_jsp_text[418]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_338=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_338.setParent(__jsp_taghandler_330);
              __jsp_taghandler_338.setName("fedl002");
              __jsp_taghandler_338.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].reeferFlag"));
              __jsp_tag_starteval=__jsp_taghandler_338.doStartTag();
              if (__jsp_taghandler_338.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_338,2);
            }
            out.write(__oracle_jsp_text[419]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_339=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_339.setParent(__jsp_taghandler_330);
              __jsp_taghandler_339.setName("fedl002");
              __jsp_taghandler_339.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].isUpdateDG"));
              __jsp_tag_starteval=__jsp_taghandler_339.doStartTag();
              if (__jsp_taghandler_339.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_339,2);
            }
            out.write(__oracle_jsp_text[420]);
            {
              org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_340=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
              __jsp_taghandler_340.setParent(__jsp_taghandler_330);
              __jsp_taghandler_340.setName("fedl002");
              __jsp_taghandler_340.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].socCoc"));
              __jsp_taghandler_340.setValue("SOC");
              __jsp_tag_starteval=__jsp_taghandler_340.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[421]);
                  {
                    org.apache.struts.taglib.html.TextTag __jsp_taghandler_341=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                    __jsp_taghandler_341.setParent(__jsp_taghandler_340);
                    __jsp_taghandler_341.setMaxlength("12");
                    __jsp_taghandler_341.setName("fedl002");
                    __jsp_taghandler_341.setOnblur(OracleJspRuntime.toStr( "updateBookingStatusFlage(" + ctr + ")"));
                    __jsp_taghandler_341.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].equipmentNo"));
                    __jsp_taghandler_341.setStyle("width:96%");
                    __jsp_tag_starteval=__jsp_taghandler_341.doStartTag();
                    if (__jsp_taghandler_341.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_341,3);
                  }
                  out.write(__oracle_jsp_text[422]);
                } while (__jsp_taghandler_340.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_340.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_340,2);
            }
            out.write(__oracle_jsp_text[423]);
            {
              org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_342=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
              __jsp_taghandler_342.setParent(__jsp_taghandler_330);
              __jsp_taghandler_342.setName("fedl002");
              __jsp_taghandler_342.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].socCoc"));
              __jsp_taghandler_342.setValue("SOC");
              __jsp_tag_starteval=__jsp_taghandler_342.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[424]);
                  {
                    org.apache.struts.taglib.logic.EqualTag __jsp_taghandler_343=(org.apache.struts.taglib.logic.EqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.EqualTag.class,"org.apache.struts.taglib.logic.EqualTag name property value");
                    __jsp_taghandler_343.setParent(__jsp_taghandler_342);
                    __jsp_taghandler_343.setName("fedl002");
                    __jsp_taghandler_343.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].fullMT"));
                    __jsp_taghandler_343.setValue("Empty");
                    __jsp_tag_starteval=__jsp_taghandler_343.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[425]);
                        {
                          org.apache.struts.taglib.html.TextTag __jsp_taghandler_344=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property style");
                          __jsp_taghandler_344.setParent(__jsp_taghandler_343);
                          __jsp_taghandler_344.setMaxlength("12");
                          __jsp_taghandler_344.setName("fedl002");
                          __jsp_taghandler_344.setOnblur(OracleJspRuntime.toStr( "trimString(this.value);updateBookingStatusFlage(" + ctr + ")"));
                          __jsp_taghandler_344.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].equipmentNo"));
                          __jsp_taghandler_344.setStyle("width:96%");
                          __jsp_tag_starteval=__jsp_taghandler_344.doStartTag();
                          if (__jsp_taghandler_344.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_344,4);
                        }
                        out.write(__oracle_jsp_text[426]);
                      } while (__jsp_taghandler_343.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_343.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_343,3);
                  }
                  out.write(__oracle_jsp_text[427]);
                  {
                    org.apache.struts.taglib.logic.NotEqualTag __jsp_taghandler_345=(org.apache.struts.taglib.logic.NotEqualTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.NotEqualTag.class,"org.apache.struts.taglib.logic.NotEqualTag name property value");
                    __jsp_taghandler_345.setParent(__jsp_taghandler_342);
                    __jsp_taghandler_345.setName("fedl002");
                    __jsp_taghandler_345.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].fullMT"));
                    __jsp_taghandler_345.setValue("Empty");
                    __jsp_tag_starteval=__jsp_taghandler_345.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[428]);
                        {
                          org.apache.struts.taglib.html.TextTag __jsp_taghandler_346=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
                          __jsp_taghandler_346.setParent(__jsp_taghandler_345);
                          __jsp_taghandler_346.setMaxlength("12");
                          __jsp_taghandler_346.setName("fedl002");
                          __jsp_taghandler_346.setProperty(OracleJspRuntime.toStr( "bookingValue[" + ctr + "].equipmentNo"));
                          __jsp_taghandler_346.setReadonly(true);
                          __jsp_taghandler_346.setStyle("width:96%");
                          __jsp_taghandler_346.setStyleClass("non_edit");
                          __jsp_tag_starteval=__jsp_taghandler_346.doStartTag();
                          if (__jsp_taghandler_346.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_346,4);
                        }
                        out.write(__oracle_jsp_text[429]);
                      } while (__jsp_taghandler_345.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_345.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_345,3);
                  }
                  out.write(__oracle_jsp_text[430]);
                } while (__jsp_taghandler_342.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_342.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_342,2);
            }
            out.write(__oracle_jsp_text[431]);
          } while (__jsp_taghandler_330.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_330.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_330,1);
      }
      out.write(__oracle_jsp_text[432]);
      out.write(__oracle_jsp_text[433]);

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
  private static final char __oracle_jsp_text[][]=new char[434][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!--\r\n--------------------------------------------------------\r\nEdlDischargeListMaintenanceBookedTabGrid.jsp\r\n--------------------------------------------------------\r\nCopyright RCL Public Co., Ltd. 2009\r\n--------------------------------------------------------\r\nAuthor NIIT \r\n- Change Log--------------------------------------------\r\n## DD/MM/YY -User- -TaskRef- -ShortDescription\r\n01 03/10/13  Leena            Bug fix :For dg details, after validation error shown\r\n                              in screen, user unable to edit dg column\r\n--------------------------------------------------------\r\n-->\r\n ".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[10] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[12] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[13] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[14] = 
    "\r\n\r\n<!-- Link Custom CSS -->\r\n<!-- Rajeev: Move to file where all CSS Files are added-->\r\n<!-- #1: Added new field crane description, 23.03.2012-->\r\n<!-- *2: Vikas: for normal booking disable the DG details, 18.09.2012 -->\r\n\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"".toCharArray();
    __oracle_jsp_text[15] = 
    "/css/customizeRiaGrid.css\"></link>\r\n\r\n<!-- Link Common Grid JS -->\r\n<!-- Rajeev: Move to file where all CSS Files are added-->\r\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[16] = 
    "/js/riaGridCommon.js\"></script>\r\n\r\n<!-- Link Screen Specific JS -->\r\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[17] = 
    "/js/EdlDischargeListMaintenanceBookedGrid.js\"></script>\r\n\r\n<script language=\"JavaScript\">\r\n    function initialize()\r\n    {\r\n        mobjGrid            = SweetDevRia.$('".toCharArray();
    __oracle_jsp_text[18] = 
    "');\r\n        mintTotalRows       = mobjGrid.totalDataNumber;\r\n        mobjFixedTable      = 'tableFixedColumns';\r\n        return false;\r\n    }\r\n</script>\r\n\r\n".toCharArray();
    __oracle_jsp_text[19] = 
    "\r\n\r\n<!-- Rajeev : Change Table Height as per screen requirement -->\r\n<!-- table id=\"GridContainer\" border=\"0\" cellspacing=0 cellpadding=0 height=\"100%\" width=\"960PX\" -->\r\n<div style='height:320px'>\r\n\r\n<table id=\"GridContainer\" border=\"0\" cellspacing=0 cellpadding=0 height=\"100%\" width=\"100%\">\r\n\r\n    <!-- Rajeev : Change TR height as per screen requirement -->\r\n    <!-- Row to Store Fixed Table Header and Dynamic Grid -->\r\n    <tr height=\"30px\" valign=\"TOP\">\r\n\r\n            <!-- Start Store Fixed Table Header -->\r\n            <td width=\"35%\">\r\n                <div style='height:30px'>\r\n                    <table class=\"header\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\r\n                        <thead>\r\n                            <tr>\r\n                                <th width=\"13%\">Select</th>\r\n                                <th width=\"17%\">Container Sequence</th>\r\n                                <th width=\"40%\">Booking #</th>\r\n                                <th width=\"30%\">Equipment #</th>\r\n                            </tr>\r\n                        </thead>\r\n                    </table>\r\n                </div>\r\n            </td>\r\n\r\n            <!-- Start to Add Grid Component -->\r\n            <td width=\"65%\" rowspan=\"2\">\r\n                <div style='height:290px'>\r\n\r\n                    ".toCharArray();
    __oracle_jsp_text[20] = 
    "\r\n                    ".toCharArray();
    __oracle_jsp_text[21] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[22] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[23] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[24] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[25] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[26] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[27] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[28] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[29] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[30] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[31] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[32] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[33] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[34] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[35] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[36] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[37] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[38] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[39] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[40] = 
    "  <!-- #1-->\r\n                                                        ".toCharArray();
    __oracle_jsp_text[41] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[42] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[43] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[44] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[45] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[46] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[47] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[48] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[49] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[50] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[51] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[52] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[53] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[54] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[55] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[56] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[57] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[58] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[59] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[60] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[61] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[62] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[63] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[64] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[65] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[66] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[67] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[68] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[69] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[70] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[71] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[72] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[73] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[74] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[75] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[76] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[77] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[78] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[79] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[80] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[81] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[82] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[83] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[84] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[85] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[86] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[87] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[88] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[89] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[90] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[91] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[92] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[93] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[94] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[95] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[96] = 
    "\r\n\r\n                                        ".toCharArray();
    __oracle_jsp_text[97] = 
    "\r\n\r\n                                        ".toCharArray();
    __oracle_jsp_text[98] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[99] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[100] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[101] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[102] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[103] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[104] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[105] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[106] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[107] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[108] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[109] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[110] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[111] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[112] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[113] = 
    "\r\n\r\n                                                    ".toCharArray();
    __oracle_jsp_text[114] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[115] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[116] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[117] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[118] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[119] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[120] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[121] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[122] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[123] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[124] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[125] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[126] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[127] = 
    "\r\n                                                                    ".toCharArray();
    __oracle_jsp_text[128] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[129] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[130] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[131] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[132] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[133] = 
    "\r\n                                                    <a href=\"#\" onClick=\"showCalendarWithTime('bookingValue[".toCharArray();
    __oracle_jsp_text[134] = 
    "].activityDate', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[135] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[136] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[137] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[138] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[139] = 
    "\r\n                                                                    ".toCharArray();
    __oracle_jsp_text[140] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[141] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[142] = 
    "\r\n                                                <!-- #1 Changes start -->\r\n                                                ".toCharArray();
    __oracle_jsp_text[143] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[144] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[145] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[146] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[147] = 
    "\r\n                                                <!-- #1 Changes end -->\r\n\r\n                                               ".toCharArray();
    __oracle_jsp_text[148] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[149] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[150] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[151] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[152] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[153] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[154] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[155] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[156] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[157] = 
    "\r\n                                                        <input type=\"button\" value=\". . .\" name=\"btnOperatorCodeLookup\" class=\"btnbutton\" onclick='return openContainerOperatorLookup(".toCharArray();
    __oracle_jsp_text[158] = 
    ")'/>\r\n                                                    ".toCharArray();
    __oracle_jsp_text[159] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[160] = 
    "\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[161] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[162] = 
    "\r\n                                                        <input type=\"button\" value=\". . .\" name=\"btnOperatorCodeLookup\" class=\"btnbutton\" onclick='return openOutSlotOperatorLookup(".toCharArray();
    __oracle_jsp_text[163] = 
    ")'/>\r\n                                                ".toCharArray();
    __oracle_jsp_text[164] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[165] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[166] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[167] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[168] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[169] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[170] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[171] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[172] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[173] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[174] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[175] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[176] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[177] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[178] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[179] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[180] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[181] = 
    "    \r\n                                                       ".toCharArray();
    __oracle_jsp_text[182] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[183] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[184] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[185] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[186] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[187] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[188] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[189] = 
    "                                                   \r\n                                                ".toCharArray();
    __oracle_jsp_text[190] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[191] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[192] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[193] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[194] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[195] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[196] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[197] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[198] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[199] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[200] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[201] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[202] = 
    "                                                     \r\n                                                ".toCharArray();
    __oracle_jsp_text[203] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[204] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[205] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[206] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[207] = 
    "\r\n                                                             <a href=\"#\" ><img src=\"".toCharArray();
    __oracle_jsp_text[208] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n                                                       ".toCharArray();
    __oracle_jsp_text[209] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[210] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[211] = 
    "\r\n                                                            <a href=\"#\" onClick=\"showCalendarWithTime('bookingValue[".toCharArray();
    __oracle_jsp_text[212] = 
    "].mloETADate', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[213] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n                                                       ".toCharArray();
    __oracle_jsp_text[214] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[215] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[216] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[217] = 
    "\r\n                                                        <a href=\"#\" onClick=\"showCalendarWithTime('bookingValue[".toCharArray();
    __oracle_jsp_text[218] = 
    "].mloETADate', '', '', '1')\"><img src=\"".toCharArray();
    __oracle_jsp_text[219] = 
    "/images/btnCalendar.gif\" alt=\"Calender\" class=\"calender\"></a>\r\n                                                    ".toCharArray();
    __oracle_jsp_text[220] = 
    "\r\n                                                    <!--html:text name=\"fedl002\" property=\"bookingValue[".toCharArray();
    __oracle_jsp_text[221] = 
    "].mloETADate\" onblur=\"updateBookingStatusFlage(".toCharArray();
    __oracle_jsp_text[222] = 
    ")\" style=\"width:60%\" maxlength=\"10\" onkeypress=\"dateFormat(this,this.value,event,false,1,document.all('msg'));\" onclick=\"this.select();\"/-->\r\n                                                   \r\n                                                ".toCharArray();
    __oracle_jsp_text[223] = 
    "\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[224] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[225] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[226] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[227] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[228] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[229] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[230] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[231] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[232] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[233] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[234] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[235] = 
    " \r\n                                                ".toCharArray();
    __oracle_jsp_text[236] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[237] = 
    "\r\n                                                     ".toCharArray();
    __oracle_jsp_text[238] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[239] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[240] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[241] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[242] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[243] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[244] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[245] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[246] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[247] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[248] = 
    "                                                    \r\n                                                ".toCharArray();
    __oracle_jsp_text[249] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[250] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[251] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[252] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[253] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[254] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[255] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[256] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[257] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[258] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[259] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[260] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[261] = 
    "\r\n                                                    \r\n                                                ".toCharArray();
    __oracle_jsp_text[262] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[263] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[264] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[265] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[266] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[267] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[268] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[269] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[270] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[271] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[272] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[273] = 
    "\r\n\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[274] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[275] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[276] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[277] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[278] = 
    "\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[279] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[280] = 
    "\r\n                                                    <input type=\"button\" value=\". . .\" name=\"btnHandlingInsCodeLookup\" class=\"btnbutton\" onclick='return openHandlingInsCodeLookup1((".toCharArray();
    __oracle_jsp_text[281] = 
    "))'/>\r\n                                                ".toCharArray();
    __oracle_jsp_text[282] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[283] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[284] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[285] = 
    "\r\n                                                    <input type=\"button\" value=\". . .\" name=\"btnHandlingInsCodeLookup\" class=\"btnbutton\" onclick='return openHandlingInsCodeLookup2(".toCharArray();
    __oracle_jsp_text[286] = 
    ")'/>\r\n                                                ".toCharArray();
    __oracle_jsp_text[287] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[288] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[289] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[290] = 
    "\r\n                                                    <input type=\"button\" value=\". . .\" name=\"btnHandlingInsCodeLookup\" class=\"btnbutton\" onclick='return openHandlingInsCodeLookup3(".toCharArray();
    __oracle_jsp_text[291] = 
    ")'/>\r\n                                                ".toCharArray();
    __oracle_jsp_text[292] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[293] = 
    "\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[294] = 
    "\r\n                                                   <!-- ".toCharArray();
    __oracle_jsp_text[295] = 
    "-->\r\n                                                    ".toCharArray();
    __oracle_jsp_text[296] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[297] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[298] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[299] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[300] = 
    "\r\n                                                    <!-- ".toCharArray();
    __oracle_jsp_text[301] = 
    " -->\r\n                                                    ".toCharArray();
    __oracle_jsp_text[302] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[303] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[304] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[305] = 
    "\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[306] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[307] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[308] = 
    "\r\n                                                                    ".toCharArray();
    __oracle_jsp_text[309] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[310] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[311] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[312] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[313] = 
    "\r\n                                                                    ".toCharArray();
    __oracle_jsp_text[314] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[315] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[316] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[317] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[318] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[319] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[320] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[321] = 
    "\r\n\r\n                                                 <!-- *2: start -->\r\n                                                 ".toCharArray();
    __oracle_jsp_text[322] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[323] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[324] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[325] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[326] = 
    "\r\n                                                        <input type=\"button\" value=\". . .\" name=\"btnUNNoLookup\" class=\"btnbutton\" onclick='return openUNNoLookup(".toCharArray();
    __oracle_jsp_text[327] = 
    ")' disabled='true' />\r\n                                                    ".toCharArray();
    __oracle_jsp_text[328] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[329] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[330] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[331] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[332] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[333] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[334] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[335] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[336] = 
    "\r\n                                                        <input type=\"button\" value=\". . .\" name=\"btnUNNoLookup\" class=\"btnbutton\" onclick='return openUNNoLookup(".toCharArray();
    __oracle_jsp_text[337] = 
    ")'/>\r\n                                                    ".toCharArray();
    __oracle_jsp_text[338] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[339] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[340] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[341] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[342] = 
    "\r\n                                                <!-- *2: end -->\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[343] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[344] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[345] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[346] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[347] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[348] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[349] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[350] = 
    "\r\n                                                                    ".toCharArray();
    __oracle_jsp_text[351] = 
    "\r\n                                                                ".toCharArray();
    __oracle_jsp_text[352] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[353] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[354] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[355] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[356] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[357] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[358] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[359] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[360] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[361] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[362] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[363] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[364] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[365] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[366] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[367] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[368] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[369] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[370] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[371] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[372] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[373] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[374] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[375] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[376] = 
    "\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[377] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[378] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[379] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[380] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[381] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[382] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[383] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[384] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[385] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[386] = 
    "\r\n                                                            ".toCharArray();
    __oracle_jsp_text[387] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[388] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[389] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[390] = 
    "\r\n\r\n                                                ".toCharArray();
    __oracle_jsp_text[391] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[392] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[393] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[394] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[395] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[396] = 
    "\r\n                                                        ".toCharArray();
    __oracle_jsp_text[397] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[398] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[399] = 
    "\r\n                                                       ".toCharArray();
    __oracle_jsp_text[400] = 
    "\r\n                                                    ".toCharArray();
    __oracle_jsp_text[401] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[402] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[403] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[404] = 
    "\r\n                                                ".toCharArray();
    __oracle_jsp_text[405] = 
    "\r\n\r\n\r\n                                        ".toCharArray();
    __oracle_jsp_text[406] = 
    "\r\n                        ".toCharArray();
    __oracle_jsp_text[407] = 
    "\r\n\r\n                    ".toCharArray();
    __oracle_jsp_text[408] = 
    "\r\n\r\n\r\n                </div>\r\n            </td>\r\n\r\n    </tr>\r\n    ".toCharArray();
    __oracle_jsp_text[409] = 
    "\r\n    \r\n    <!-- Row to Store Fixed Table Body -->\r\n    <tr height=\"270px\" valign=\"top\">\r\n\r\n            <!-- Start Store Fixed Table Header -->\r\n            <td >\r\n                <div id=\"fixedColumns_bodyDiv\" CLASS='clsNoScroll'  style='height:270px;'>\r\n                    <table id=\"tableFixedColumns\" class=\"table_results\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n                        <tbody>\r\n                            ".toCharArray();
    __oracle_jsp_text[410] = 
    "\r\n                                <tr id='".toCharArray();
    __oracle_jsp_text[411] = 
    "' height=\"27px\">\r\n                                    <td width=\"12%\" class=\"center\">\r\n                                        ".toCharArray();
    __oracle_jsp_text[412] = 
    "\r\n                                    </td>\r\n                                    <td width=\"18%\">\r\n                                        ".toCharArray();
    __oracle_jsp_text[413] = 
    "\r\n                                    </td>\r\n                                    <td width=\"40%\">\r\n                                        ".toCharArray();
    __oracle_jsp_text[414] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[415] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[416] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[417] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[418] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[419] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[420] = 
    "<!--##01 -->\r\n                                    </td>\r\n                                    ".toCharArray();
    __oracle_jsp_text[421] = 
    "\r\n                                        <td width=\"30%\">\r\n                                            ".toCharArray();
    __oracle_jsp_text[422] = 
    "\r\n                                        </td>\r\n                                    ".toCharArray();
    __oracle_jsp_text[423] = 
    "\r\n                                    ".toCharArray();
    __oracle_jsp_text[424] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[425] = 
    "\r\n                                            <td width=\"30%\">\r\n                                                ".toCharArray();
    __oracle_jsp_text[426] = 
    "\r\n                                            </td>\r\n                                        ".toCharArray();
    __oracle_jsp_text[427] = 
    "\r\n                                        ".toCharArray();
    __oracle_jsp_text[428] = 
    "\r\n                                            <td width=\"30%\">\r\n                                                ".toCharArray();
    __oracle_jsp_text[429] = 
    "\r\n                                            </td>\r\n                                        ".toCharArray();
    __oracle_jsp_text[430] = 
    "\r\n                                    ".toCharArray();
    __oracle_jsp_text[431] = 
    "\r\n\r\n                                </tr>\r\n                            ".toCharArray();
    __oracle_jsp_text[432] = 
    "\r\n                        </tbody>\r\n                    </table>\r\n                </div>\r\n            </td>\r\n    </tr>\r\n\r\n</table>\r\n</div>\r\n".toCharArray();
    __oracle_jsp_text[433] = 
    "\r\n\r\n    <script language=\"JavaScript\">\r\n        initialize();\r\n    //    highlightRow(0);\r\n    </script>\r\n\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
