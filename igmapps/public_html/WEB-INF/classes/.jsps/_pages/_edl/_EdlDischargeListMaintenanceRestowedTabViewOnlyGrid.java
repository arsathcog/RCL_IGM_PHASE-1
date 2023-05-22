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


public class _EdlDischargeListMaintenanceRestowedTabViewOnlyGrid extends com.orionserver.http.OrionHttpJspPage {


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
    _EdlDischargeListMaintenanceRestowedTabViewOnlyGrid page = this;
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
        __jsp_taghandler_2.setName("fedl002");
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
        __jsp_taghandler_3.setHeight("270px");
        __jsp_taghandler_3.setHeightHeader("21");
        __jsp_taghandler_3.setHeightRow("25");
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
                    __jsp_taghandler_5.setLabel("Size");
                    __jsp_taghandler_5.setWidth("50px");
                    __jsp_taghandler_5.setId("size");
                    __jsp_tag_starteval=__jsp_taghandler_5.doStartTag();
                    if (__jsp_taghandler_5.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_5,3);
                  }
                  out.write(__oracle_jsp_text[21]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_6=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_6.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_6.setLabel("Equipment Type");
                    __jsp_taghandler_6.setWidth("50px");
                    __jsp_taghandler_6.setId("equipmentType");
                    __jsp_tag_starteval=__jsp_taghandler_6.doStartTag();
                    if (__jsp_taghandler_6.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_6,3);
                  }
                  out.write(__oracle_jsp_text[22]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_7=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_7.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_7.setLabel("SOC/COC");
                    __jsp_taghandler_7.setWidth("50px");
                    __jsp_taghandler_7.setId("socCoc");
                    __jsp_tag_starteval=__jsp_taghandler_7.doStartTag();
                    if (__jsp_taghandler_7.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_7,3);
                  }
                  out.write(__oracle_jsp_text[23]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_8=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_8.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_8.setLabel("Shipment Term");
                    __jsp_taghandler_8.setWidth("50px");
                    __jsp_taghandler_8.setId("shipmentTerm");
                    __jsp_tag_starteval=__jsp_taghandler_8.doStartTag();
                    if (__jsp_taghandler_8.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_8,3);
                  }
                  out.write(__oracle_jsp_text[24]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_9=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_9.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_9.setLabel("Shipment Type");
                    __jsp_taghandler_9.setWidth("50px");
                    __jsp_taghandler_9.setId("shipmentType");
                    __jsp_tag_starteval=__jsp_taghandler_9.doStartTag();
                    if (__jsp_taghandler_9.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_9,3);
                  }
                  out.write(__oracle_jsp_text[25]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_10=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_10.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_10.setLabel("Midstream");
                    __jsp_taghandler_10.setWidth("50px");
                    __jsp_taghandler_10.setId("midstream");
                    __jsp_tag_starteval=__jsp_taghandler_10.doStartTag();
                    if (__jsp_taghandler_10.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_10,3);
                  }
                  out.write(__oracle_jsp_text[26]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_11=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_11.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_11.setLabel("Load Condition");
                    __jsp_taghandler_11.setWidth("50px");
                    __jsp_taghandler_11.setId("loadCondition");
                    __jsp_tag_starteval=__jsp_taghandler_11.doStartTag();
                    if (__jsp_taghandler_11.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_11,3);
                  }
                  out.write(__oracle_jsp_text[27]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_12=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_12.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_12.setLabel("Restow Status");
                    __jsp_taghandler_12.setWidth("50px");
                    __jsp_taghandler_12.setId("restowSts");
                    __jsp_tag_starteval=__jsp_taghandler_12.doStartTag();
                    if (__jsp_taghandler_12.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_12,3);
                  }
                  out.write(__oracle_jsp_text[28]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_13=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_13.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_13.setLabel("Stow Position");
                    __jsp_taghandler_13.setWidth("50px");
                    __jsp_taghandler_13.setId("stowPosition");
                    __jsp_tag_starteval=__jsp_taghandler_13.doStartTag();
                    if (__jsp_taghandler_13.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_13,3);
                  }
                  out.write(__oracle_jsp_text[29]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_14=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_14.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_14.setLabel("Weight");
                    __jsp_taghandler_14.setWidth("50px");
                    __jsp_taghandler_14.setId("weight");
                    __jsp_tag_starteval=__jsp_taghandler_14.doStartTag();
                    if (__jsp_taghandler_14.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_14,3);
                  }
                  out.write(__oracle_jsp_text[30]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_15=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_15.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_15.setLabel("Damaged");
                    __jsp_taghandler_15.setWidth("50px");
                    __jsp_taghandler_15.setId("damaged");
                    __jsp_tag_starteval=__jsp_taghandler_15.doStartTag();
                    if (__jsp_taghandler_15.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_15,3);
                  }
                  out.write(__oracle_jsp_text[31]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_16=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_16.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_16.setLabel("Void Slot");
                    __jsp_taghandler_16.setWidth("50px");
                    __jsp_taghandler_16.setId("voidSlot");
                    __jsp_tag_starteval=__jsp_taghandler_16.doStartTag();
                    if (__jsp_taghandler_16.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_16,3);
                  }
                  out.write(__oracle_jsp_text[32]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_17=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_17.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_17.setLabel("Slot Operator");
                    __jsp_taghandler_17.setWidth("50px");
                    __jsp_taghandler_17.setId("slotOperator");
                    __jsp_tag_starteval=__jsp_taghandler_17.doStartTag();
                    if (__jsp_taghandler_17.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_17,3);
                  }
                  out.write(__oracle_jsp_text[33]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_18=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_18.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_18.setLabel("Container Operator");
                    __jsp_taghandler_18.setWidth("50px");
                    __jsp_taghandler_18.setId("contOperator");
                    __jsp_tag_starteval=__jsp_taghandler_18.doStartTag();
                    if (__jsp_taghandler_18.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_18,3);
                  }
                  out.write(__oracle_jsp_text[34]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_19=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_19.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_19.setLabel("Special Handle");
                    __jsp_taghandler_19.setWidth("50px");
                    __jsp_taghandler_19.setId("specialHandle");
                    __jsp_tag_starteval=__jsp_taghandler_19.doStartTag();
                    if (__jsp_taghandler_19.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_19,3);
                  }
                  out.write(__oracle_jsp_text[35]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_20=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_20.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_20.setLabel("Seal No.");
                    __jsp_taghandler_20.setWidth("50px");
                    __jsp_taghandler_20.setId("sealNo");
                    __jsp_tag_starteval=__jsp_taghandler_20.doStartTag();
                    if (__jsp_taghandler_20.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_20,3);
                  }
                  out.write(__oracle_jsp_text[36]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_21=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_21.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_21.setLabel("Special Carg");
                    __jsp_taghandler_21.setWidth("50px");
                    __jsp_taghandler_21.setId("specialCargo");
                    __jsp_tag_starteval=__jsp_taghandler_21.doStartTag();
                    if (__jsp_taghandler_21.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_21,3);
                  }
                  out.write(__oracle_jsp_text[37]);
                  {
                    com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag __jsp_taghandler_22=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnHeaderTag label width id");
                    __jsp_taghandler_22.setParent(__jsp_taghandler_4);
                    __jsp_taghandler_22.setLabel("Remarks");
                    __jsp_taghandler_22.setWidth("50px");
                    __jsp_taghandler_22.setId("remarks");
                    __jsp_tag_starteval=__jsp_taghandler_22.doStartTag();
                    if (__jsp_taghandler_22.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_22,3);
                  }
                  out.write(__oracle_jsp_text[38]);
                } while (__jsp_taghandler_4.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_4.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_4,2);
            }
            out.write(__oracle_jsp_text[39]);
            {
              com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag __jsp_taghandler_23=(com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridBodyIteratorTag collection var rowPerPage rowCountVar");
              __jsp_taghandler_23.setParent(__jsp_taghandler_3);
              __jsp_taghandler_23.setCollection((java.util.Collection)oracle.jsp.runtime.OracleJspRuntime.evaluate("${KEY_SCREEN_GRID_DATA}",java.util.Collection.class, __ojsp_varRes,null));
              __jsp_taghandler_23.setVar("col");
              __jsp_taghandler_23.setRowPerPage(1000);
              __jsp_taghandler_23.setRowCountVar("rowCount");
              __jsp_tag_starteval=__jsp_taghandler_23.doStartTag();
              if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
              {
                do {
                  out.write(__oracle_jsp_text[40]);
                  {
                    com.ideo.sweetdevria.taglib.grid.common.GridRowTag __jsp_taghandler_24=(com.ideo.sweetdevria.taglib.grid.common.GridRowTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.common.GridRowTag.class,"com.ideo.sweetdevria.taglib.grid.common.GridRowTag id");
                    __jsp_taghandler_24.setParent(__jsp_taghandler_23);
                    __jsp_taghandler_24.setId((java.lang.String) ("row"+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)));
                    __jsp_tag_starteval=__jsp_taghandler_24.doStartTag();
                    if (OracleJspRuntime.checkStartTagEval(__jsp_tag_starteval))
                    {
                      do {
                        out.write(__oracle_jsp_text[41]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_25=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_25.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_25.setId("size");
                          __jsp_tag_starteval=__jsp_taghandler_25.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_25,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[42]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_26=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_26.setParent(__jsp_taghandler_25);
                                __jsp_taghandler_26.setMaxlength("2");
                                __jsp_taghandler_26.setName("fedl002");
                                __jsp_taghandler_26.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'size',this)"));
                                __jsp_taghandler_26.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].size"));
                                __jsp_taghandler_26.setReadonly(true);
                                __jsp_taghandler_26.setStyle("width:96%");
                                __jsp_taghandler_26.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_26.doStartTag();
                                if (__jsp_taghandler_26.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_26,5);
                              }
                              out.write(__oracle_jsp_text[43]);
                            } while (__jsp_taghandler_25.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_25.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_25,4);
                        }
                        out.write(__oracle_jsp_text[44]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_27=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_27.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_27.setId("equipmentType");
                          __jsp_tag_starteval=__jsp_taghandler_27.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_27,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[45]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_28=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_28.setParent(__jsp_taghandler_27);
                                __jsp_taghandler_28.setMaxlength("2");
                                __jsp_taghandler_28.setName("fedl002");
                                __jsp_taghandler_28.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'equipmentType',this)"));
                                __jsp_taghandler_28.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].equipmentType"));
                                __jsp_taghandler_28.setReadonly(true);
                                __jsp_taghandler_28.setStyle("width:96%");
                                __jsp_taghandler_28.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_28.doStartTag();
                                if (__jsp_taghandler_28.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_28,5);
                              }
                              out.write(__oracle_jsp_text[46]);
                            } while (__jsp_taghandler_27.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_27.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_27,4);
                        }
                        out.write(__oracle_jsp_text[47]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_29=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_29.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_29.setId("socCoc");
                          __jsp_tag_starteval=__jsp_taghandler_29.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_29,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[48]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_30=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_30.setParent(__jsp_taghandler_29);
                                __jsp_taghandler_30.setMaxlength("3");
                                __jsp_taghandler_30.setName("fedl002");
                                __jsp_taghandler_30.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'socCoc',this)"));
                                __jsp_taghandler_30.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].socCoc"));
                                __jsp_taghandler_30.setReadonly(true);
                                __jsp_taghandler_30.setStyle("width:96%");
                                __jsp_taghandler_30.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_30.doStartTag();
                                if (__jsp_taghandler_30.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_30,5);
                              }
                              out.write(__oracle_jsp_text[49]);
                            } while (__jsp_taghandler_29.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_29.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_29,4);
                        }
                        out.write(__oracle_jsp_text[50]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_31=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_31.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_31.setId("shipmentTerm");
                          __jsp_tag_starteval=__jsp_taghandler_31.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_31,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[51]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_32=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_32.setParent(__jsp_taghandler_31);
                                __jsp_taghandler_32.setMaxlength("4");
                                __jsp_taghandler_32.setName("fedl002");
                                __jsp_taghandler_32.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'shipmentTerm',this)"));
                                __jsp_taghandler_32.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].shipmentTerm"));
                                __jsp_taghandler_32.setReadonly(true);
                                __jsp_taghandler_32.setStyle("width:96%");
                                __jsp_taghandler_32.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_32.doStartTag();
                                if (__jsp_taghandler_32.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_32,5);
                              }
                              out.write(__oracle_jsp_text[52]);
                            } while (__jsp_taghandler_31.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_31.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_31,4);
                        }
                        out.write(__oracle_jsp_text[53]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_33=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_33.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_33.setId("shipmentType");
                          __jsp_tag_starteval=__jsp_taghandler_33.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_33,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[54]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_34=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_34.setParent(__jsp_taghandler_33);
                                __jsp_taghandler_34.setMaxlength("3");
                                __jsp_taghandler_34.setName("fedl002");
                                __jsp_taghandler_34.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'shipmentType',this)"));
                                __jsp_taghandler_34.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].shipmentType"));
                                __jsp_taghandler_34.setReadonly(true);
                                __jsp_taghandler_34.setStyle("width:96%");
                                __jsp_taghandler_34.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_34.doStartTag();
                                if (__jsp_taghandler_34.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_34,5);
                              }
                              out.write(__oracle_jsp_text[55]);
                            } while (__jsp_taghandler_33.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_33.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_33,4);
                        }
                        out.write(__oracle_jsp_text[56]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_35=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_35.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_35.setId("midstream");
                          __jsp_tag_starteval=__jsp_taghandler_35.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_35,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[57]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_36=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag disabled name onblur property style");
                                __jsp_taghandler_36.setParent(__jsp_taghandler_35);
                                __jsp_taghandler_36.setDisabled(true);
                                __jsp_taghandler_36.setName("fedl002");
                                __jsp_taghandler_36.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'midstream',this)"));
                                __jsp_taghandler_36.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].midstream"));
                                __jsp_taghandler_36.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_36.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_36,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[58]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_37=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_37.setParent(__jsp_taghandler_36);
                                      __jsp_taghandler_37.setValue("");
                                      __jsp_tag_starteval=__jsp_taghandler_37.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_37,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[59]);
                                        } while (__jsp_taghandler_37.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_37.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_37,6);
                                    }
                                    out.write(__oracle_jsp_text[60]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_38=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_38.setParent(__jsp_taghandler_36);
                                      __jsp_taghandler_38.setValue("BT");
                                      __jsp_tag_starteval=__jsp_taghandler_38.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_38,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[61]);
                                        } while (__jsp_taghandler_38.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_38.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_38,6);
                                    }
                                    out.write(__oracle_jsp_text[62]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_39=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_39.setParent(__jsp_taghandler_36);
                                      __jsp_taghandler_39.setValue("SH");
                                      __jsp_tag_starteval=__jsp_taghandler_39.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_39,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[63]);
                                        } while (__jsp_taghandler_39.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_39.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_39,6);
                                    }
                                    out.write(__oracle_jsp_text[64]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_40=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_40.setParent(__jsp_taghandler_36);
                                      __jsp_taghandler_40.setValue("LS");
                                      __jsp_tag_starteval=__jsp_taghandler_40.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_40,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[65]);
                                        } while (__jsp_taghandler_40.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_40.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_40,6);
                                    }
                                    out.write(__oracle_jsp_text[66]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_41=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_41.setParent(__jsp_taghandler_36);
                                      __jsp_taghandler_41.setValue("TC");
                                      __jsp_tag_starteval=__jsp_taghandler_41.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_41,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[67]);
                                        } while (__jsp_taghandler_41.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_41.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_41,6);
                                    }
                                    out.write(__oracle_jsp_text[68]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_42=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_42.setParent(__jsp_taghandler_36);
                                      __jsp_taghandler_42.setValue("FY");
                                      __jsp_tag_starteval=__jsp_taghandler_42.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_42,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[69]);
                                        } while (__jsp_taghandler_42.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_42.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_42,6);
                                    }
                                    out.write(__oracle_jsp_text[70]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_43=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_43.setParent(__jsp_taghandler_36);
                                      __jsp_taghandler_43.setValue("VT");
                                      __jsp_tag_starteval=__jsp_taghandler_43.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_43,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[71]);
                                        } while (__jsp_taghandler_43.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_43.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_43,6);
                                    }
                                    out.write(__oracle_jsp_text[72]);
                                  } while (__jsp_taghandler_36.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_36.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_36,5);
                              }
                              out.write(__oracle_jsp_text[73]);
                            } while (__jsp_taghandler_35.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_35.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_35,4);
                        }
                        out.write(__oracle_jsp_text[74]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_44=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_44.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_44.setId("loadCondition");
                          __jsp_tag_starteval=__jsp_taghandler_44.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_44,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[75]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_45=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag disabled name onblur property style");
                                __jsp_taghandler_45.setParent(__jsp_taghandler_44);
                                __jsp_taghandler_45.setDisabled(true);
                                __jsp_taghandler_45.setName("fedl002");
                                __jsp_taghandler_45.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'loadCondition',this)"));
                                __jsp_taghandler_45.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].loadCondition"));
                                __jsp_taghandler_45.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_45.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_45,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[76]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_46=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_46.setParent(__jsp_taghandler_45);
                                      __jsp_taghandler_46.setValue("E");
                                      __jsp_tag_starteval=__jsp_taghandler_46.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_46,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[77]);
                                        } while (__jsp_taghandler_46.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_46.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_46,6);
                                    }
                                    out.write(__oracle_jsp_text[78]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_47=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_47.setParent(__jsp_taghandler_45);
                                      __jsp_taghandler_47.setValue("F");
                                      __jsp_tag_starteval=__jsp_taghandler_47.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_47,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[79]);
                                        } while (__jsp_taghandler_47.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_47.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_47,6);
                                    }
                                    out.write(__oracle_jsp_text[80]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_48=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_48.setParent(__jsp_taghandler_45);
                                      __jsp_taghandler_48.setValue("P");
                                      __jsp_tag_starteval=__jsp_taghandler_48.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_48,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[81]);
                                        } while (__jsp_taghandler_48.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_48.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_48,6);
                                    }
                                    out.write(__oracle_jsp_text[82]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_49=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_49.setParent(__jsp_taghandler_45);
                                      __jsp_taghandler_49.setValue("B");
                                      __jsp_tag_starteval=__jsp_taghandler_49.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_49,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[83]);
                                        } while (__jsp_taghandler_49.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_49.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_49,6);
                                    }
                                    out.write(__oracle_jsp_text[84]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_50=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_50.setParent(__jsp_taghandler_45);
                                      __jsp_taghandler_50.setValue("R");
                                      __jsp_tag_starteval=__jsp_taghandler_50.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_50,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[85]);
                                        } while (__jsp_taghandler_50.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_50.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_50,6);
                                    }
                                    out.write(__oracle_jsp_text[86]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_51=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_51.setParent(__jsp_taghandler_45);
                                      __jsp_taghandler_51.setValue("L");
                                      __jsp_tag_starteval=__jsp_taghandler_51.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_51,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[87]);
                                        } while (__jsp_taghandler_51.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_51.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_51,6);
                                    }
                                    out.write(__oracle_jsp_text[88]);
                                  } while (__jsp_taghandler_45.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_45.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_45,5);
                              }
                              out.write(__oracle_jsp_text[89]);
                            } while (__jsp_taghandler_44.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_44.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_44,4);
                        }
                        out.write(__oracle_jsp_text[90]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_52=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_52.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_52.setId("restowSts");
                          __jsp_tag_starteval=__jsp_taghandler_52.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_52,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[91]);
                              {
                                org.apache.struts.taglib.html.SelectTag __jsp_taghandler_53=(org.apache.struts.taglib.html.SelectTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.SelectTag.class,"org.apache.struts.taglib.html.SelectTag disabled name onblur property style");
                                __jsp_taghandler_53.setParent(__jsp_taghandler_52);
                                __jsp_taghandler_53.setDisabled(true);
                                __jsp_taghandler_53.setName("fedl002");
                                __jsp_taghandler_53.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'restowSts',this)"));
                                __jsp_taghandler_53.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].restowSts"));
                                __jsp_taghandler_53.setStyle("width:96%");
                                __jsp_tag_starteval=__jsp_taghandler_53.doStartTag();
                                if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                {
                                  out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_53,__jsp_tag_starteval,out);
                                  do {
                                    out.write(__oracle_jsp_text[92]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_54=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_54.setParent(__jsp_taghandler_53);
                                      __jsp_taghandler_54.setValue("DC");
                                      __jsp_tag_starteval=__jsp_taghandler_54.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_54,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[93]);
                                        } while (__jsp_taghandler_54.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_54.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_54,6);
                                    }
                                    out.write(__oracle_jsp_text[94]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_55=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_55.setParent(__jsp_taghandler_53);
                                      __jsp_taghandler_55.setValue("DR");
                                      __jsp_tag_starteval=__jsp_taghandler_55.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_55,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[95]);
                                        } while (__jsp_taghandler_55.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_55.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_55,6);
                                    }
                                    out.write(__oracle_jsp_text[96]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_56=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_56.setParent(__jsp_taghandler_53);
                                      __jsp_taghandler_56.setValue("RA");
                                      __jsp_tag_starteval=__jsp_taghandler_56.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_56,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[97]);
                                        } while (__jsp_taghandler_56.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_56.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_56,6);
                                    }
                                    out.write(__oracle_jsp_text[98]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_57=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_57.setParent(__jsp_taghandler_53);
                                      __jsp_taghandler_57.setValue("LR");
                                      __jsp_tag_starteval=__jsp_taghandler_57.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_57,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[99]);
                                        } while (__jsp_taghandler_57.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_57.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_57,6);
                                    }
                                    out.write(__oracle_jsp_text[100]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_58=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_58.setParent(__jsp_taghandler_53);
                                      __jsp_taghandler_58.setValue("LC");
                                      __jsp_tag_starteval=__jsp_taghandler_58.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_58,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[101]);
                                        } while (__jsp_taghandler_58.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_58.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_58,6);
                                    }
                                    out.write(__oracle_jsp_text[102]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_59=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_59.setParent(__jsp_taghandler_53);
                                      __jsp_taghandler_59.setValue("RP");
                                      __jsp_tag_starteval=__jsp_taghandler_59.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_59,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[103]);
                                        } while (__jsp_taghandler_59.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_59.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_59,6);
                                    }
                                    out.write(__oracle_jsp_text[104]);
                                    {
                                      org.apache.struts.taglib.html.OptionTag __jsp_taghandler_60=(org.apache.struts.taglib.html.OptionTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.OptionTag.class,"org.apache.struts.taglib.html.OptionTag value");
                                      __jsp_taghandler_60.setParent(__jsp_taghandler_53);
                                      __jsp_taghandler_60.setValue("XX");
                                      __jsp_tag_starteval=__jsp_taghandler_60.doStartTag();
                                      if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                                      {
                                        out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_60,__jsp_tag_starteval,out);
                                        do {
                                          out.write(__oracle_jsp_text[105]);
                                        } while (__jsp_taghandler_60.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                        out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                      }
                                      if (__jsp_taghandler_60.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                        return;
                                      OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_60,6);
                                    }
                                    out.write(__oracle_jsp_text[106]);
                                  } while (__jsp_taghandler_53.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                                  out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                                }
                                if (__jsp_taghandler_53.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_53,5);
                              }
                              out.write(__oracle_jsp_text[107]);
                            } while (__jsp_taghandler_52.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_52.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_52,4);
                        }
                        out.write(__oracle_jsp_text[108]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_61=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_61.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_61.setId("stowPosition");
                          __jsp_tag_starteval=__jsp_taghandler_61.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_61,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[109]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_62=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur onchange property readonly style styleClass");
                                __jsp_taghandler_62.setParent(__jsp_taghandler_61);
                                __jsp_taghandler_62.setMaxlength("7");
                                __jsp_taghandler_62.setName("fedl002");
                                __jsp_taghandler_62.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'stowPosition',this)"));
                                __jsp_taghandler_62.setOnchange((java.lang.String) ("onChangeStowagePosition("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+")"));
                                __jsp_taghandler_62.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].stowPosition"));
                                __jsp_taghandler_62.setReadonly(true);
                                __jsp_taghandler_62.setStyle("width:96%");
                                __jsp_taghandler_62.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_62.doStartTag();
                                if (__jsp_taghandler_62.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_62,5);
                              }
                              out.write(__oracle_jsp_text[110]);
                            } while (__jsp_taghandler_61.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_61.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_61,4);
                        }
                        out.write(__oracle_jsp_text[111]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_63=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_63.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_63.setId("weight");
                          __jsp_tag_starteval=__jsp_taghandler_63.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_63,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[112]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_64=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_64.setParent(__jsp_taghandler_63);
                                __jsp_taghandler_64.setMaxlength("15");
                                __jsp_taghandler_64.setName("fedl002");
                                __jsp_taghandler_64.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'weight',this)"));
                                __jsp_taghandler_64.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].weight"));
                                __jsp_taghandler_64.setReadonly(true);
                                __jsp_taghandler_64.setStyle("width:96%");
                                __jsp_taghandler_64.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_64.doStartTag();
                                if (__jsp_taghandler_64.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_64,5);
                              }
                              out.write(__oracle_jsp_text[113]);
                            } while (__jsp_taghandler_63.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_63.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_63,4);
                        }
                        out.write(__oracle_jsp_text[114]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_65=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_65.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_65.setId("damaged");
                          __jsp_tag_starteval=__jsp_taghandler_65.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_65,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[115]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_66=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_66.setParent(__jsp_taghandler_65);
                                __jsp_taghandler_66.setMaxlength("3");
                                __jsp_taghandler_66.setName("fedl002");
                                __jsp_taghandler_66.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'damaged',this)"));
                                __jsp_taghandler_66.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].damaged"));
                                __jsp_taghandler_66.setReadonly(true);
                                __jsp_taghandler_66.setStyle("width:96%");
                                __jsp_taghandler_66.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_66.doStartTag();
                                if (__jsp_taghandler_66.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_66,5);
                              }
                              out.write(__oracle_jsp_text[116]);
                            } while (__jsp_taghandler_65.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_65.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_65,4);
                        }
                        out.write(__oracle_jsp_text[117]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_67=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_67.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_67.setId("voidSlot");
                          __jsp_tag_starteval=__jsp_taghandler_67.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_67,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[118]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_68=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_68.setParent(__jsp_taghandler_67);
                                __jsp_taghandler_68.setMaxlength("6");
                                __jsp_taghandler_68.setName("fedl002");
                                __jsp_taghandler_68.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'voidSlot',this)"));
                                __jsp_taghandler_68.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].voidSlot"));
                                __jsp_taghandler_68.setReadonly(true);
                                __jsp_taghandler_68.setStyle("width:96%");
                                __jsp_taghandler_68.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_68.doStartTag();
                                if (__jsp_taghandler_68.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_68,5);
                              }
                              out.write(__oracle_jsp_text[119]);
                            } while (__jsp_taghandler_67.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_67.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_67,4);
                        }
                        out.write(__oracle_jsp_text[120]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_69=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_69.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_69.setId("slotOperator");
                          __jsp_tag_starteval=__jsp_taghandler_69.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_69,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[121]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_70=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_70.setParent(__jsp_taghandler_69);
                                __jsp_taghandler_70.setMaxlength("4");
                                __jsp_taghandler_70.setName("fedl002");
                                __jsp_taghandler_70.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'slotOperator',this)"));
                                __jsp_taghandler_70.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].slotOperator"));
                                __jsp_taghandler_70.setReadonly(true);
                                __jsp_taghandler_70.setStyle("width:96%");
                                __jsp_taghandler_70.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_70.doStartTag();
                                if (__jsp_taghandler_70.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_70,5);
                              }
                              out.write(__oracle_jsp_text[122]);
                            } while (__jsp_taghandler_69.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_69.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_69,4);
                        }
                        out.write(__oracle_jsp_text[123]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_71=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_71.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_71.setId("contOperator");
                          __jsp_tag_starteval=__jsp_taghandler_71.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_71,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[124]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_72=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_72.setParent(__jsp_taghandler_71);
                                __jsp_taghandler_72.setMaxlength("4");
                                __jsp_taghandler_72.setName("fedl002");
                                __jsp_taghandler_72.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'contOperator',this)"));
                                __jsp_taghandler_72.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].contOperator"));
                                __jsp_taghandler_72.setReadonly(true);
                                __jsp_taghandler_72.setStyle("width:96%");
                                __jsp_taghandler_72.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_72.doStartTag();
                                if (__jsp_taghandler_72.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_72,5);
                              }
                              out.write(__oracle_jsp_text[125]);
                            } while (__jsp_taghandler_71.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_71.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_71,4);
                        }
                        out.write(__oracle_jsp_text[126]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_73=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_73.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_73.setId("specialHandle");
                          __jsp_tag_starteval=__jsp_taghandler_73.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_73,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[127]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_74=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_74.setParent(__jsp_taghandler_73);
                                __jsp_taghandler_74.setMaxlength("3");
                                __jsp_taghandler_74.setName("fedl002");
                                __jsp_taghandler_74.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'specialHandle',this)"));
                                __jsp_taghandler_74.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialHandle"));
                                __jsp_taghandler_74.setReadonly(true);
                                __jsp_taghandler_74.setStyle("width:96%");
                                __jsp_taghandler_74.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_74.doStartTag();
                                if (__jsp_taghandler_74.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_74,5);
                              }
                              out.write(__oracle_jsp_text[128]);
                            } while (__jsp_taghandler_73.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_73.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_73,4);
                        }
                        out.write(__oracle_jsp_text[129]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_75=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_75.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_75.setId("sealNo");
                          __jsp_tag_starteval=__jsp_taghandler_75.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_75,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[130]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_76=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_76.setParent(__jsp_taghandler_75);
                                __jsp_taghandler_76.setMaxlength("20");
                                __jsp_taghandler_76.setName("fedl002");
                                __jsp_taghandler_76.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'sealNo',this)"));
                                __jsp_taghandler_76.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].sealNo"));
                                __jsp_taghandler_76.setReadonly(true);
                                __jsp_taghandler_76.setStyle("width:96%");
                                __jsp_taghandler_76.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_76.doStartTag();
                                if (__jsp_taghandler_76.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_76,5);
                              }
                              out.write(__oracle_jsp_text[131]);
                            } while (__jsp_taghandler_75.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_75.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_75,4);
                        }
                        out.write(__oracle_jsp_text[132]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_77=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_77.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_77.setId("specialCargo");
                          __jsp_tag_starteval=__jsp_taghandler_77.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_77,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[133]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_78=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_78.setParent(__jsp_taghandler_77);
                                __jsp_taghandler_78.setMaxlength("3");
                                __jsp_taghandler_78.setName("fedl002");
                                __jsp_taghandler_78.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'specialCargo',this)"));
                                __jsp_taghandler_78.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].specialCargo"));
                                __jsp_taghandler_78.setReadonly(true);
                                __jsp_taghandler_78.setStyle("width:96%");
                                __jsp_taghandler_78.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_78.doStartTag();
                                if (__jsp_taghandler_78.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_78,5);
                              }
                              out.write(__oracle_jsp_text[134]);
                            } while (__jsp_taghandler_77.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_77.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_77,4);
                        }
                        out.write(__oracle_jsp_text[135]);
                        {
                          com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag __jsp_taghandler_79=(com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag)OracleJspRuntime.getTagHandler(pageContext,com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag.class,"com.ideo.sweetdevria.taglib.grid.grid.GridColumnTag id");
                          __jsp_taghandler_79.setParent(__jsp_taghandler_24);
                          __jsp_taghandler_79.setId("remarks");
                          __jsp_tag_starteval=__jsp_taghandler_79.doStartTag();
                          if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
                          {
                            out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_79,__jsp_tag_starteval,out);
                            do {
                              out.write(__oracle_jsp_text[136]);
                              {
                                org.apache.struts.taglib.html.TextTag __jsp_taghandler_80=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
                                __jsp_taghandler_80.setParent(__jsp_taghandler_79);
                                __jsp_taghandler_80.setMaxlength("2000");
                                __jsp_taghandler_80.setName("fedl002");
                                __jsp_taghandler_80.setOnblur((java.lang.String) ("updateRestowedStatusFlage("+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+",'remarks',this)"));
                                __jsp_taghandler_80.setProperty((java.lang.String) ("restowedValue["+ (java.lang.String)oracle.jsp.runtime.OracleJspRuntime.evaluate("${rowCount}",java.lang.String.class, __ojsp_varRes, null)+"].remarks"));
                                __jsp_taghandler_80.setReadonly(true);
                                __jsp_taghandler_80.setStyle("width:96%");
                                __jsp_taghandler_80.setStyleClass("non_edit");
                                __jsp_tag_starteval=__jsp_taghandler_80.doStartTag();
                                if (__jsp_taghandler_80.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                                  return;
                                OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_80,5);
                              }
                              out.write(__oracle_jsp_text[137]);
                            } while (__jsp_taghandler_79.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                            out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
                          }
                          if (__jsp_taghandler_79.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                            return;
                          OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_79,4);
                        }
                        out.write(__oracle_jsp_text[138]);
                      } while (__jsp_taghandler_24.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
                    }
                    if (__jsp_taghandler_24.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                      return;
                    OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_24,3);
                  }
                  out.write(__oracle_jsp_text[139]);
                } while (__jsp_taghandler_23.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
              }
              if (__jsp_taghandler_23.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_23,2);
            }
            out.write(__oracle_jsp_text[140]);
          } while (__jsp_taghandler_3.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_3.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_3,1);
      }
      out.write(__oracle_jsp_text[141]);
      {
        org.apache.struts.taglib.logic.IterateTag __jsp_taghandler_81=(org.apache.struts.taglib.logic.IterateTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.logic.IterateTag.class,"org.apache.struts.taglib.logic.IterateTag id indexId name property type");
        __jsp_taghandler_81.setParent(null);
        __jsp_taghandler_81.setId("rowdata");
        __jsp_taghandler_81.setIndexId("ctr");
        __jsp_taghandler_81.setName("fedl002");
        __jsp_taghandler_81.setProperty("marlRestowedDtlTable");
        __jsp_taghandler_81.setType("com.rclgroup.dolphin.ezl.web.edl.vo.EdlDischargeListRestowedMod");
        com.rclgroup.dolphin.ezl.web.edl.vo.EdlDischargeListRestowedMod rowdata = null;
        java.lang.Integer ctr = null;
        __jsp_tag_starteval=__jsp_taghandler_81.doStartTag();
        if (OracleJspRuntime.checkStartBodyTagEval(__jsp_tag_starteval))
        {
          out=OracleJspRuntime.pushBodyIfNeeded(pageContext,__jsp_taghandler_81,__jsp_tag_starteval,out);
          do {
            rowdata = (com.rclgroup.dolphin.ezl.web.edl.vo.EdlDischargeListRestowedMod) pageContext.findAttribute("rowdata");
            ctr = (java.lang.Integer) pageContext.findAttribute("ctr");
            out.write(__oracle_jsp_text[142]);
            out.print( "row" + ctr );
            out.write(__oracle_jsp_text[143]);
            {
              org.apache.struts.taglib.html.CheckboxTag __jsp_taghandler_82=(org.apache.struts.taglib.html.CheckboxTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.CheckboxTag.class,"org.apache.struts.taglib.html.CheckboxTag disabled name property styleClass");
              __jsp_taghandler_82.setParent(__jsp_taghandler_81);
              __jsp_taghandler_82.setDisabled(true);
              __jsp_taghandler_82.setName("fedl002");
              __jsp_taghandler_82.setProperty(OracleJspRuntime.toStr( "restowedValue[" + ctr + "].selected"));
              __jsp_taghandler_82.setStyleClass("check");
              __jsp_tag_starteval=__jsp_taghandler_82.doStartTag();
              if (__jsp_taghandler_82.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_82,2);
            }
            out.write(__oracle_jsp_text[144]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_83=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name property readonly style styleClass");
              __jsp_taghandler_83.setParent(__jsp_taghandler_81);
              __jsp_taghandler_83.setMaxlength("17");
              __jsp_taghandler_83.setName("fedl002");
              __jsp_taghandler_83.setProperty(OracleJspRuntime.toStr( "restowedValue[" + ctr + "].bookingNo"));
              __jsp_taghandler_83.setReadonly(true);
              __jsp_taghandler_83.setStyle("width:96%");
              __jsp_taghandler_83.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_83.doStartTag();
              if (__jsp_taghandler_83.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_83,2);
            }
            out.write(__oracle_jsp_text[145]);
            {
              org.apache.struts.taglib.html.TextTag __jsp_taghandler_84=(org.apache.struts.taglib.html.TextTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.TextTag.class,"org.apache.struts.taglib.html.TextTag maxlength name onblur property readonly style styleClass");
              __jsp_taghandler_84.setParent(__jsp_taghandler_81);
              __jsp_taghandler_84.setMaxlength("12");
              __jsp_taghandler_84.setName("fedl002");
              __jsp_taghandler_84.setOnblur(OracleJspRuntime.toStr( "updateRestowedStatusFlage(" + ctr + ")"));
              __jsp_taghandler_84.setProperty(OracleJspRuntime.toStr( "restowedValue[" + ctr + "].equipmentNo"));
              __jsp_taghandler_84.setReadonly(true);
              __jsp_taghandler_84.setStyle("width:96%");
              __jsp_taghandler_84.setStyleClass("non_edit");
              __jsp_tag_starteval=__jsp_taghandler_84.doStartTag();
              if (__jsp_taghandler_84.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_84,2);
            }
            out.write(__oracle_jsp_text[146]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_85=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_85.setParent(__jsp_taghandler_81);
              __jsp_taghandler_85.setName("fedl002");
              __jsp_taghandler_85.setProperty(OracleJspRuntime.toStr( "restowedValue[" + ctr + "].restowedId"));
              __jsp_tag_starteval=__jsp_taghandler_85.doStartTag();
              if (__jsp_taghandler_85.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_85,2);
            }
            out.write(__oracle_jsp_text[147]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_86=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_86.setParent(__jsp_taghandler_81);
              __jsp_taghandler_86.setName("fedl002");
              __jsp_taghandler_86.setProperty(OracleJspRuntime.toStr( "restowedValue[" + ctr + "].recordChangeDt"));
              __jsp_tag_starteval=__jsp_taghandler_86.doStartTag();
              if (__jsp_taghandler_86.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_86,2);
            }
            out.write(__oracle_jsp_text[148]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_87=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_87.setParent(__jsp_taghandler_81);
              __jsp_taghandler_87.setName("fedl002");
              __jsp_taghandler_87.setProperty(OracleJspRuntime.toStr( "restowedValue[" + ctr + "].status"));
              __jsp_tag_starteval=__jsp_taghandler_87.doStartTag();
              if (__jsp_taghandler_87.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_87,2);
            }
            out.write(__oracle_jsp_text[149]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_88=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_88.setParent(__jsp_taghandler_81);
              __jsp_taghandler_88.setName("fedl002");
              __jsp_taghandler_88.setProperty(OracleJspRuntime.toStr( "restowedValue[" + ctr + "].tempRecordStatus"));
              __jsp_tag_starteval=__jsp_taghandler_88.doStartTag();
              if (__jsp_taghandler_88.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_88,2);
            }
            out.write(__oracle_jsp_text[150]);
            {
              org.apache.struts.taglib.html.HiddenTag __jsp_taghandler_89=(org.apache.struts.taglib.html.HiddenTag)OracleJspRuntime.getTagHandler(pageContext,org.apache.struts.taglib.html.HiddenTag.class,"org.apache.struts.taglib.html.HiddenTag name property");
              __jsp_taghandler_89.setParent(__jsp_taghandler_81);
              __jsp_taghandler_89.setName("fedl002");
              __jsp_taghandler_89.setProperty(OracleJspRuntime.toStr( "restowedValue[" + ctr + "].restowedSeqNo"));
              __jsp_tag_starteval=__jsp_taghandler_89.doStartTag();
              if (__jsp_taghandler_89.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
                return;
              OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_89,2);
            }
            out.write(__oracle_jsp_text[151]);
          } while (__jsp_taghandler_81.doAfterBody()==javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN);
          out=OracleJspRuntime.popBodyIfNeeded(pageContext,out);
        }
        if (__jsp_taghandler_81.doEndTag()==javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
          return;
        OracleJspRuntime.releaseTagHandler(pageContext,__jsp_taghandler_81,1);
      }
      out.write(__oracle_jsp_text[152]);
      out.write(__oracle_jsp_text[153]);

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
  private static final char __oracle_jsp_text[][]=new char[154][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[3] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[4] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[5] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[6] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[7] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[8] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[9] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[10] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[11] = 
    "\r\n\r\n\r\n\r\n\r\n".toCharArray();
    __oracle_jsp_text[12] = 
    "\r\n\r\n".toCharArray();
    __oracle_jsp_text[13] = 
    " \r\n\r\n<!-- Link Custom CSS -->\r\n<!-- Rajeev: Move to file where all CSS Files are added-->\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"".toCharArray();
    __oracle_jsp_text[14] = 
    "/css/customizeRiaGrid.css\"></link>\r\n\r\n<!-- Link Common Grid JS -->\r\n<!-- Rajeev: Move to file where all CSS Files are added-->\t\r\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[15] = 
    "/js/riaGridCommon.js\"></script>\r\n\r\n<!-- Link Screen Specific JS -->\r\n<script language=\"JavaScript\" src=\"".toCharArray();
    __oracle_jsp_text[16] = 
    "/js/EdlDischargeListMaintenanceRestowedGrid.js\"></script>\r\n\r\n<script language=\"JavaScript\">\r\n\tfunction initialize() \r\n\t{      \r\n\t\tmobjGrid            = SweetDevRia.$('".toCharArray();
    __oracle_jsp_text[17] = 
    "');\r\n\t\tmintTotalRows       = mobjGrid.totalDataNumber;\r\n\t\tmobjFixedTable      = 'tableFixedColumns';\r\n\t\treturn false;\r\n\t}\r\n</script>\r\n\r\n".toCharArray();
    __oracle_jsp_text[18] = 
    "\r\n\r\n<!-- Rajeev : Change Table Height as per screen requirement -->\r\n<div style='height:290px'>\r\n<table id=\"GridContainer\" border=\"0\" cellspacing=0 cellpadding=0 height=\"100%\" width=\"100%\">\r\n\r\n\t<!-- Rajeev : Change TR height as per screen requirement -->\r\n\t<!-- Row to Store Fixed Table Header and Dynamic Grid -->\r\n\t<tr height=\"20px\" valign=\"TOP\">\r\n\t\t\t\r\n\t\t\t<!-- Start Store Fixed Table Header -->\r\n\t\t\t<td width=\"30%\">\r\n\t\t\t\t<div style='height:20px'>\r\n\t\t\t\t\t<table class=\"header\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\r\n\t\t\t\t\t\t<thead>\r\n\t\t\t\t\t\t\t<tr>\r\n\t\t\t\t\t\t\t\t<th width=\"20%\">Delete</th>\r\n\t\t\t\t\t\t\t\t<th width=\"40%\">Booking #</th>\r\n                                <th width=\"40%\">Equipment #</th>\r\n\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t</tr>\r\n\t\t\t\t\t\t</thead>\r\n\t\t\t\t\t</table>\r\n\t\t\t\t</div>\r\n\t\t\t</td>\r\n\r\n\t\t\t<!-- Start to Add Grid Component -->\r\n\t\t\t<td width=\"70%\" rowspan=\"2\">\r\n\t\t\t\t<div style='height:270px'>\r\n                                     \r\n\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[19] = 
    " \r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[20] = 
    "\t\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[21] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[22] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[23] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[24] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[25] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[26] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[27] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[28] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[29] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[30] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[31] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[32] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[33] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[34] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[35] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[36] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[37] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[38] = 
    "\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[39] = 
    "\r\n\t\t\t\t\t\t\r\n                        ".toCharArray();
    __oracle_jsp_text[40] = 
    " \r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[41] = 
    "\r\n\r\n                        ".toCharArray();
    __oracle_jsp_text[42] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[43] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[44] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[45] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[46] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[47] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[48] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[49] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[50] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[51] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[52] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[53] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[54] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[55] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[56] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[57] = 
    "\r\n                            ".toCharArray();
    __oracle_jsp_text[58] = 
    "\r\n                                ".toCharArray();
    __oracle_jsp_text[59] = 
    "Select One...".toCharArray();
    __oracle_jsp_text[60] = 
    "\r\n                                ".toCharArray();
    __oracle_jsp_text[61] = 
    "Block transfer".toCharArray();
    __oracle_jsp_text[62] = 
    "\r\n                                ".toCharArray();
    __oracle_jsp_text[63] = 
    "Short stay".toCharArray();
    __oracle_jsp_text[64] = 
    "\r\n                                ".toCharArray();
    __oracle_jsp_text[65] = 
    "Long Stay".toCharArray();
    __oracle_jsp_text[66] = 
    "\r\n                                ".toCharArray();
    __oracle_jsp_text[67] = 
    "Tackle".toCharArray();
    __oracle_jsp_text[68] = 
    "\r\n                                ".toCharArray();
    __oracle_jsp_text[69] = 
    "Floating Yard Delivery".toCharArray();
    __oracle_jsp_text[70] = 
    "\r\n                                ".toCharArray();
    __oracle_jsp_text[71] = 
    "Vessel to terminal".toCharArray();
    __oracle_jsp_text[72] = 
    "\r\n                            ".toCharArray();
    __oracle_jsp_text[73] = 
    "       \r\n                        ".toCharArray();
    __oracle_jsp_text[74] = 
    "                                \r\n                        ".toCharArray();
    __oracle_jsp_text[75] = 
    "   \r\n                            ".toCharArray();
    __oracle_jsp_text[76] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[77] = 
    "Empty".toCharArray();
    __oracle_jsp_text[78] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[79] = 
    "Full".toCharArray();
    __oracle_jsp_text[80] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[81] = 
    "Bundle".toCharArray();
    __oracle_jsp_text[82] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[83] = 
    "Base".toCharArray();
    __oracle_jsp_text[84] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[85] = 
    "Residue".toCharArray();
    __oracle_jsp_text[86] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[87] = 
    "Break Bulk".toCharArray();
    __oracle_jsp_text[88] = 
    "\r\n                            ".toCharArray();
    __oracle_jsp_text[89] = 
    "      \r\n                        ".toCharArray();
    __oracle_jsp_text[90] = 
    "                                \r\n                        ".toCharArray();
    __oracle_jsp_text[91] = 
    "\r\n                            ".toCharArray();
    __oracle_jsp_text[92] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[93] = 
    "Discharged for CFS and Reload".toCharArray();
    __oracle_jsp_text[94] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[95] = 
    "Discharged for Reload".toCharArray();
    __oracle_jsp_text[96] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[97] = 
    "Restowed aboard".toCharArray();
    __oracle_jsp_text[98] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[99] = 
    "Re-loaded".toCharArray();
    __oracle_jsp_text[100] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[101] = 
    "Re-loaded after CFS".toCharArray();
    __oracle_jsp_text[102] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[103] = 
    "Restowed via pier".toCharArray();
    __oracle_jsp_text[104] = 
    "\r\n\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[105] = 
    "Stowage position correction at transit port".toCharArray();
    __oracle_jsp_text[106] = 
    "\r\n                            ".toCharArray();
    __oracle_jsp_text[107] = 
    "      \r\n                        \r\n                        ".toCharArray();
    __oracle_jsp_text[108] = 
    "\t\t\t\t\t\t\t\t\r\n                        \r\n                        ".toCharArray();
    __oracle_jsp_text[109] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[110] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[111] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[112] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[113] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[114] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[115] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[116] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[117] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[118] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[119] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[120] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[121] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[122] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[123] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[124] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[125] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[126] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[127] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[128] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[129] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[130] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[131] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[132] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[133] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[134] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[135] = 
    "\t\r\n                        ".toCharArray();
    __oracle_jsp_text[136] = 
    "\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[137] = 
    "\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[138] = 
    "\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[139] = 
    "\t\r\n\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[140] = 
    " \r\n\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[141] = 
    "\t\r\n                                      \r\n\t\t\t\t</div>\t\r\n\t\t\t</td>\r\n\t\t\r\n\t</tr>\t\t\r\n\r\n\t<!-- Row to Store Fixed Table Body -->\r\n\t<tr height=\"250px\" valign=\"top\">\r\n\r\n\t\t\t<!-- Start Store Fixed Table Header -->\r\n\t\t\t<td >\r\n\t\t\t\t<div id=\"fixedColumns_bodyDiv\" CLASS='clsNoScroll'  style='height:250px;'>\r\n\t\t\t\t\t<table id=\"tableFixedColumns\" class=\"table_results\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n\t\t\t\t\t\t<tbody>\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[142] = 
    "\r\n\t\t\t\t\t\t\t\t<tr id='".toCharArray();
    __oracle_jsp_text[143] = 
    "' height=\"20px\">\r\n\t\t\t\t\t\t\t\t\t<td width=\"20%\" class=\"first_row center\">\r\n\t\t\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[144] = 
    "\r\n\t\t\t\t\t\t\t\t\t</td>\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t<td width=\"40%\">".toCharArray();
    __oracle_jsp_text[145] = 
    "</td>\t\r\n\t\t\t\t\t\t\t\t\t<td width=\"40%\">".toCharArray();
    __oracle_jsp_text[146] = 
    "\t\r\n\t\t\t\t\t\t\t\t\t   \r\n\t\t\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[147] = 
    "\r\n\t\t\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[148] = 
    "\r\n\t\t\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[149] = 
    "\r\n\t\t\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[150] = 
    "\r\n\t\t\t\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[151] = 
    "\r\n                                     </td>                                   \r\n\t\t\t\t\t\t\t\t</tr>\t\r\n\t\t\t\t\t\t\t".toCharArray();
    __oracle_jsp_text[152] = 
    " \t\r\n\t\t\t\t\t\t</tbody> \r\n\t\t\t\t\t</table>\r\n\t\t\t\t</div>\r\n\r\n\t\t\t</td>\r\n\t</tr>\r\n\r\n</table> \r\n</div>\r\n".toCharArray();
    __oracle_jsp_text[153] = 
    "\r\n\r\n\t<script language=\"JavaScript\">\r\n\t\tinitialize();\r\n\t\t//highlightRow(0);\r\n\t</script>        \r\n\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
