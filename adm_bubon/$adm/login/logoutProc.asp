<!-- #include virtual="/$adm/include/Config.asp" -->
<% 
	Response.Cookies(admincheck).domain = Domain
	Response.Cookies(admincheck).path = "/"
	Response.Cookies(admincheck).secure = false
	Response.Cookies(admincheck) = ""
	Response.Cookies(admincheck).Expires = Now
    Response.Cookies(admincheck)("adminID") = ""
    Response.Cookies(admincheck)("adminNo") = ""
	Response.Cookies(admincheck)("adminAuth") = ""
	Response.Cookies(admincheck)("adminPort") = ""
	Response.Cookies(admincheck)("IDAuth") = ""
	Response.Cookies(savecheck)("id_save") = ""

	'Response.Redirect LogoutReturnPage '�α׾ƿ��� ������������ �̵�
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
	top.location.href = "<%=LogoutReturnPage%>";
//-->
</SCRIPT>