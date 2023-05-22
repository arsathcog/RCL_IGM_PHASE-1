<html></html>
<html>
<body></body>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page  isErrorPage="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<body bgcolor="#e6c8c8">
<b><font color="#6666ff">EXCEPTION DETECTED</font></b>
<br />
<div style="width: 800; height: 300; overflow: auto;" id="temp1">
<TABLE border="1">
	<TBODY>
		<TR>
			<TD bgcolor="#f8f0f0">
			<html:errors/>
			</TD>
			<TD bgcolor="#f8f0f0" width="530">
				<font color="#ff0000" face="Arial" size="1"> <%
							java.io.PrintWriter pw = new java.io.PrintWriter(out);
							if(exception!=null)
							{
								exception.printStackTrace(pw);
							}
							String str =(String) 
									request.getAttribute("STACKTRACE");
							if(str != null)
							{ 
							%>
								<%=str%>
							<%
							}
						%> 
				</font>
			</TD>
		</TR>
	</TBODY>
</TABLE>
</div>
<br/>
<hr />
<br/>
<font color="#6666ff" size="2">
<b>==========REQUEST DUMP BEGINS=========</b>
<br />
<div style="width: 800; height: 300; overflow: auto;" id="temp">
<TABLE border="1" bgcolor="#f8f0f0" width="743">
	<TBODY>
		<TR>
			<TD width="247"><B>Request Parameters:</B></TD>
			<TD width="488"></TD>
		</TR>
		<%
java.util.Enumeration enum1 = request.getParameterNames();
while (enum1.hasMoreElements()) {
	String name = (String)enum1.nextElement();
%>
		<TR>
			<TD width="247"><%=name%></TD>
			<TD width="488"><%=request.getParameter(name)%></TD>
		</TR>
		<%	
}
%>

		<TR>
			<TD width="247"></TD>
			<TD width="488"></TD>
		</TR>
		
		<TR>
			<TD width="247"><B>Request Attributes:</B></TD>
			<TD width="488"></TD>
		</TR>
<%
enum1 = request.getAttributeNames();
while (enum1.hasMoreElements()) {
	String name = (String)enum1.nextElement();
%>
		<TR>
			<TD width="247"><%=name%></TD>
			<TD width="488"><%=request.getAttribute(name)%></TD>
		</TR>
		<%	
}
%>
	</TBODY>
</TABLE>
</div>
<br></br>
<b><font color="#6666ff">==========REQUEST DUMP ENDS=========</font></b>
<br />
<hr />
<b><font color="#6666ff"><BR>
==========SESSION DUMP BEGINS=========</font></b>
<br />
<div style="width: 800; height: 170; overflow: auto;" id="temp2">
<table border="1" bgcolor="#f8f0f0" width="742">
	<tbody>
		<tr>
			<td width="244"><B>Session Id</B></td>
			<td width="490"><%=session.getId()%></td>
		</tr>
		<tr>
			<td width="244"></td>
			<td width="490"></td>
		</tr>
		<tr>
			<td width="244"><B>Session Attributes:</B></td>
			<td width="490"></td>
		</tr>

		<%
enum1 = session.getAttributeNames();
while (enum1.hasMoreElements()) {
	String name = (String)enum1.nextElement();
%>
		<tr>
			<td width="244"><%=name%></td>
			<td width="490"><%=session.getAttribute(name)%></td>
		</tr>
		<%	
}
%>
		<br />

		<tr>
			<td width="244"></td>
			<td width="490"></td>
		</tr>

		<tr>
			<td width="244"><B>Session Values:</B></td>
			<td width="490"></td>
		</tr>
		<%
String[] arr= session.getValueNames();
for(int i = 0; i<arr.length; i++){
%>
		<tr>
			<td width="244"><%=arr[i]%></td>
			<td width="490"><%=session.getValue(arr[i])%></td>
		</tr>
		<%	
}
%>
	</tbody>
</table>
</div>
<br />
<b><font color="#6666ff">==========SESSION DUMP ENDS=========</font></b>
</font>
</body>
</html>
