package _pages;

import oracle.jsp.runtime.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import oracle.jsp.el.*;
import javax.servlet.jsp.el.*;
import javax.servlet.http.*;
import com.niit.control.common.*;
import com.niit.control.web.*;
import com.niit.control.web.action.*;


public class _DummyMenu extends com.orionserver.http.OrionHttpJspPage {


  // ** Begin Declarations


  // ** End Declarations

  public void _jspService(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException, ServletException {

    response.setContentType( "text/html;charset=windows-1252");
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
    _DummyMenu page = this;
    ServletConfig config = pageContext.getServletConfig();
    javax.servlet.jsp.el.VariableResolver __ojsp_varRes = (VariableResolver)new OracleVariableResolverImpl(pageContext);

    try {


      out.write(__oracle_jsp_text[0]);
      out.write(__oracle_jsp_text[1]);
      out.write(__oracle_jsp_text[2]);
      out.write(__oracle_jsp_text[3]);
      out.write(__oracle_jsp_text[4]);
      out.write(__oracle_jsp_text[5]);
      
      session.removeAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
      String strUserid = (String)request.getParameter("userid");
      String password  = "x";
      String strUserFsc = "R";
      String strAccessLvl = "R~*~***";
      String dateFormat = "1";
      if(strUserid == null){
          strUserid = "NIIT01";
      }
      if ( strUserid.equals("NESTLE")){
      	strUserFsc = "-";
      	strAccessLvl = "-~-~-";
      } else if ( !strUserid.equals("NIIT01")){
      	strUserFsc = "BKK";
      	strAccessLvl = "R~I~BKK";
      }
      Cookie objCookie1 = new Cookie("RCL_AUTH_KEY",strUserid + "~" + password + "~" + strUserFsc + "~" + strAccessLvl + "~" + dateFormat);
      objCookie1.setMaxAge(-1);
      //objCookie1.setDomain(".rclgroup.com");
      //objCookie1.setDomain(".in.niit-tech.com");
      objCookie1.setPath("/");
      response.addCookie(objCookie1);
      String strServerName = request.getServerName();
      String strServerPort = ""+request.getServerPort();
      System.out.println("request.getServerName()="+strServerName);
      System.out.println("request.getServerPort()="+strServerPort);
      String lstrCtxPath = request.getContextPath();
      
      out.write(__oracle_jsp_text[6]);
      
      
      UserAccountBean account = (UserAccountBean) session.getAttribute(GlobalConstants.USER_ACCOUNT_BEAN);
      if(account!= null){
      String astrProgId = "SVCT001";
      String strProgGroupId = (String)GlobalParam.loadProgInfo().get(astrProgId);
      System.out.println("strProgGroupId="+strProgGroupId);
      ProgInfo        lobjProgInfo = account.getProgInfo(strProgGroupId);
      System.out.println("lobjProgInfo.getReadFlag()="+lobjProgInfo.getReadFlag());
      }
      
      out.write(__oracle_jsp_text[7]);
      out.print("http://" + strServerName + ":" + strServerPort);
      out.write(__oracle_jsp_text[8]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[9]);
      out.print(strUserid);
      out.write(__oracle_jsp_text[10]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[11]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[12]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[13]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[14]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[15]);
      out.print(lstrCtxPath);
      out.write(__oracle_jsp_text[16]);

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
  private static final char __oracle_jsp_text[][]=new char[17][];
  static {
    try {
    __oracle_jsp_text[0] = 
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"\n\"http://www.w3.org/TR/html4/loose.dtd\">\n".toCharArray();
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
    "\n<script language=\"javascript\">\nvar serverUrl = '".toCharArray();
    __oracle_jsp_text[8] = 
    "';\nvar aw = screen.availWidth;\nvar ah = screen.availHeight;\nfunction openScreen(screen_url,screen_id)\n{\n\tvar screenWidth = aw-5;\t    \n\tvar screenHeight= ah-54;\n\tvar x = aw>800?(aw-screenWidth)/2:0;\n\tvar y = ah>600?(ah-screenHeight)/2:0;\n\t\n\tvar winName = screen_id;\t\t\n\tchildWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=yes,scrollbars=yes,toolbar=yes,titlebar=yes');\t\t\t\t\t\n        //childWindow = window.open(screen_url,winName);\n        childWindow.focus();\n}\nfunction openChildScreen(screen_url,screen_id)\n{\t\n\tvar screenWidth = 600;\t    \n\tvar screenHeight= 400;\n\tvar x = aw>800?(aw-screenWidth)/2:0;\n\tvar y = ah>600?(ah-screenHeight)/2:0;\n\tvar winName = screen_id;\t\t\n\tchildWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=no,scrollbars=no,toolbar=no,titlebar=yes');\t\t\t\t\t\n\tchildWindow.focus();\n}\n\nfunction doBack() {\n\tdocument.menu.action='".toCharArray();
    __oracle_jsp_text[9] = 
    "/pages/Welcome.jsp';\n\tdocument.menu.submit();\n\treturn false;\n}\n</script>\n<html>\n  <head>\n    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\"/>\n    <title>Welcome EZL</title>\n    <style type=\"text/css\">\n      body {\n      background-color: #aabbcc; \n      }\n      a:link { color: #ffee22; }\n    </style>\n  </head>\n  <body>\n  <form name=\"menu\" method=\"POST\" action=\"#\">\n  <div align='center'>\n  <p>\n  <b>RCL - EZY LOAD LIST APPLICATION</b>\n  </p>\n  <BR>\n  <BR>\n  </div>\n  <div align='center'>\n  <table border=\"1\" cellspacing=\"0\" cellpadding=\"0\" width=\"250\">\n  <tr>\n\t<td>User ID :</td>\n\t<td>\n\t<input type=\"text\" name=\"userid\" value='".toCharArray();
    __oracle_jsp_text[10] = 
    "' readonly />\n\t</td>\n  </tr>\n  </table>\n  </p>\n  <table border=\"1\" cellspacing=\"0\" cellpadding=\"0\" width=\"250\">\n  <tr>\n  <td>\n  <b>EZL MENU</b>\n  </td>\n  </tr>\n  <tr>\n  <td>\n  <a href=\"javascript:openScreen(serverUrl + '".toCharArray();
    __oracle_jsp_text[11] = 
    "/do/sedl001?appId=Dolphin','sedl001')\"> Discharge List Overview</a>\n  </td>\n  </tr>\n    <tr>\n  <td>\n  <a href=\"javascript:openScreen(serverUrl + '".toCharArray();
    __oracle_jsp_text[12] = 
    "/do/sell001?appId=Dolphin','sell001')\"> Load List Overview</a>\n  </td>\n  </tr>\n  <tr>\n  <td>\n  <a href=\"javascript:openScreen(serverUrl + '".toCharArray();
    __oracle_jsp_text[13] = 
    "/do/secm005?appId=Dolphin','secm005')\"> E-Notice Template</a>\n  </td>\n  </tr>\n  <tr>\n  <td>\n  <a href=\"javascript:openScreen(serverUrl + '".toCharArray();
    __oracle_jsp_text[14] = 
    "/do/secm007?appId=Dolphin','secm007')\"> Maintain Mail Alert</a>\n  </td>\n  </tr>\n    <tr>\n  <td>\n  <a href=\"javascript:openScreen(serverUrl + '".toCharArray();
    __oracle_jsp_text[15] = 
    "/do/secm010?appId=Dolphin&PAGE_URL=/do/secm010','secm010')\"> E Notice Service</a>\n  </td>\n  </tr>\n      <tr>\n  <td>\n  <a href=\"javascript:openScreen(serverUrl + '".toCharArray();
    __oracle_jsp_text[16] = 
    "/do/sedl004?appId=Dolphin&PAGE_URL=/do/sedl004','sedl004')\"> Return Shipment</a>\n  </td>\n  </tr>\n  </table>\n  </p>\n  <table border=\"1\" cellspacing=\"0\" cellpadding=\"0\" width=\"250\">\n  <tr>\n\t<td>\n\t<input type=\"button\" value=\" BACK \" onclick=\"doBack()\"/>\n\t</td>\n  </tr>\n  </table>\n  </div>\n  </form>\n  </body>\n</html>".toCharArray();
    }
    catch (Throwable th) {
      System.err.println(th);
    }
}
}
