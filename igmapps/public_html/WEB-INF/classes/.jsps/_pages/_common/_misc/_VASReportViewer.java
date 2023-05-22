package _pages._common._misc;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import com.niit.control.common.Debug;
import com.niit.control.common.GlobalConstants;
import com.niit.control.common.StringUtil;
import com.niit.control.web.action.BaseAction;
import com.rclgroup.dolphin.ezl.resource.ReportParams;


public class _VASReportViewer extends com.orionserver.http.OrionHttpJspPage {


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
    _VASReportViewer page = this;
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
      
      response.setHeader("Pragma","no-cache");
      response.setHeader("Cache-Control", "no-cache"); 
      response.setHeader("Cache-Control", "no-store"); 
      response.setDateHeader ("Expires", -1);
      
      out.write(__oracle_jsp_text[8]);
      
      String strReportServerUrl = BaseAction.getReportServerUrl(request);//application.getInitParameter("ReportServerUrl");
      String strReportServerEnv = BaseAction.getReportServerEnv(request);//application.getInitParameter("ReportServerEnv");
      /* Example URL *
      String strServerURL = "http://dory-cs.rclgroup.com:4444/reports/rwservlet?vasrepenv";
      */
      String strServerURL = strReportServerUrl + "?" + strReportServerEnv;
      String strFinalParam= GlobalConstants.BLANK;
      Debug.logFramework("strServerURL="+strServerURL);
      String strModule    = request.getParameter("module"); ;
      String strScreenId  = request.getParameter("screen"); ;
      String strReportNm  = request.getParameter("report"); ;
      String strDesformat = request.getParameter("desformat"); ;
      String strRptDetails= request.getParameter("reportDetails"); ;
      Debug.logFramework("VAS Reports Viewer Starts...");
      int intTotParam       = 0;
      String[] arrRptParams = ReportParams.getReportParams(strReportNm);
      
      String strRptDate   = BaseAction.getFullDate(request);
      String strUserId    = BaseAction.getUserID(request);;
              
      if (strUserId == null) {
          Debug.logFramework("**UAB null Moving to Error Page");
          getServletConfig().getServletContext().getRequestDispatcher(GlobalConstants.NO_SESSION_PATH).forward(request,response);
          return;
      }        
      
      if (strRptDetails == null) {
          strRptDetails = GlobalConstants.BLANK;
      }
      Debug.logFramework("strModule=" + strModule);
      Debug.logFramework("strScreenId=" + strScreenId);
      Debug.logFramework("strReportNm=" + strReportNm);
      Debug.logFramework("strDesformat=" + strDesformat);
      Debug.logFramework("strRptDetails=" + strRptDetails);
      try{
          String[] arrRptData = StringUtil.extractTokensWithSpaces(strRptDetails,GlobalConstants.HASH);
          Debug.logFramework("arrRptData" + arrRptData);
          Debug.logFramework("arrRptData[0]" + arrRptData[0]);
          intTotParam = Integer.parseInt(arrRptData[0]);
          Debug.logFramework("intTotParam=" + intTotParam);
          /* First Param Code is always report Date */
          strFinalParam = "&report="+strReportNm+"&desformat="+strDesformat+"&"+arrRptParams[0]+"="+strRptDate;
          Debug.logFramework("strFinalParam-1=" + strFinalParam);
          /* Create the other parameters came from screen */
          for (int lintCtr = 1; lintCtr <= intTotParam; lintCtr++){
              //create "param code + Value" url...
               strFinalParam = strFinalParam + "&" + arrRptParams[lintCtr] + "=" + arrRptData[lintCtr];
          }
          Debug.logFramework("strFinalParam-2=" + strFinalParam);
          request.setAttribute("hidden_run_parameters",response.encodeRedirectURL(strFinalParam));
          
          //forward to report server...
          //request.getRequestDispatcher(response.encodeRedirectURL(strServerURL)).forward(request,response);
          response.sendRedirect(response.encodeRedirectURL(strServerURL+strFinalParam));
      }catch(Exception ex){
          Debug.logFramework(ex);
          getServletConfig().getServletContext().getRequestDispatcher(GlobalConstants.ERROR_PATH).forward(request,response);
      }finally{
          Debug.logFramework("VAS Reports Viewer Ended...");
      }
      
      

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
  private static final char __oracle_jsp_text[][]=new char[9][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\r\n".toCharArray();
    __oracle_jsp_text[1] = 
    "\r\n".toCharArray();
    __oracle_jsp_text[2] = 
    "\r\n\r\n".toCharArray();
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
    "\r\n\r\n".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
