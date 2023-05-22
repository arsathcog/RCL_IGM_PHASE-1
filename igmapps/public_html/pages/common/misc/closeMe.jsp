<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="com.niit.control.common.GlobalConstants" %>
<html>
<%
    // remove the any information from Session object for current screen
    session.removeAttribute((String)request.getAttribute(GlobalConstants.SCR_ID));
%>
<head>
<script language="javascript">
//to do
</script>
</head>
<body onload="window.close()">
</body>
</html>