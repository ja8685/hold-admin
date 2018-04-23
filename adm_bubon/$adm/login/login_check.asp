<%
	Dim adminID, adminAuth, adminPort
	
	adminID = Request.Cookies(admincheck)("adminID")
	adminAuth = Request.Cookies(admincheck)("adminAuth")
	adminPort = Request.Cookies(admincheck)("adminPort")

	'관리자 아이디/권한 체크
	if adminID = "" then
		'Response.Redirect "/$adm/login/loginForm.asp"
		Call returnURL("/$adm/login/loginForm.asp","top")
	end If

	if AdminAuth <> AdminRole then
		'Call Msg_Box(AdminRole & " 관리자 권한이 없습니다.\n\n다시 한번 확인하시기 바랍니다.","","/$adm/login/loginForm.asp","top")
	end If

	if SERVER_PORT <> adminPort then
		'Call Msg_Box(AdminRole & " 관리자 접속포트가 틀립니다.","","/$adm/login/loginForm.asp","top")
	end If
%>