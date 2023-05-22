<%@page language="java" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>VAS - Error Page</title>

<style type="text/css">
.noframe-framing-table  { background-color: #767776; background-image: none; border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000; border-left: 1px solid #000000; }
.table-text {   font-family: Arial,Helvetica, sans-serif; font-size:70.0%; background-color: #F7F7F7; background-image: none; }
.column-head {  padding-left: .35em; font-family: Arial,Helvetica, sans-serif; font-size: 77.0%; font-weight:bold; text-align: left; color: #FFFFFF; background-color: #8691C7; background-image: none; }
</style>

</head>
<SCRIPT language="JavaScript">
 if (window.screen) {
    var aw = screen.availWidth;
    var ah = screen.availHeight;
    window.moveTo(0, 0);
    window.resizeTo(aw, ah+5);
    window.resizable=0;
  }

  function doOK(){
     window.close();
  }

</script>
<BODY  onload="javascript:document.all.ok.focus();">
<form name="logonForm" action='/' method="post">
<table border=0 cellpadding=0 cellspacing=0 width="100%" height="100%"  align="center" >
    <tr>
      <td  >
        <table class="noframe-framing-table" border=0 cellpadding="5" cellspacing="0" width="300" summary="Login Table" align="center">
        <tbody>
          <tr>
            <th colspan="2" class="column-head" scope="rowgroup">Error&nbsp;&nbsp;</th>
          </tr>
          <tr>
          <td valign=top  colspan="2" class="table-text"  nowrap >
            <br>
                <span>
                <img align="baseline" height="16" width="16" src="<%= request.getContextPath() + "/" %>images/imgError.gif"/>
                &nbsp;&nbsp;&nbsp;Not Authorized for the requested resource.
                </span>
            <br>
            <br>
          </td>
          </tr>

          <tr>
            <td valign=top  align="right" width='150'>
              <input type="button" name="ok" value='    OK   ' onclick="doOK()">
            </td>
          </tr>
          </tbody>
        </table>
  </tr>
</table>
</body>
</html>
