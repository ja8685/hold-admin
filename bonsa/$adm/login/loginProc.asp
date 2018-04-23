<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<%

	Dim LOGINID, LOGINPW, id_save
	Dim F_SUPERVISORID, PWD, AUTH

	LOGINID = Trim(Request("LOGINID"))
	LOGINPW = Trim(Request("LOGINPW"))
	id_save = Trim(Request("id_save"))
    gubun   = Trim(Request("gubun"))
    'str = decrypt(Trim(Request("str")))
    
    'LOGINID = str
    returl = Trim(request("returl"))
    if LOGINID = "master" then
    gubun = 0
    end if

	connectionGameDB("PNC")
	select case gubun 
            case "0"
	        strSQL = "select number,name,password from boss_distributor where user_id = '" & LOGINID & "'"
            case "1"
	        strSQL = "select number,name,user_pass from distributor1 where user_id = '" & LOGINID & "'"
            case "2"
            strSQL = "select number,name,user_pass from distributor2 where user_id = '" & LOGINID & "'"
            case "3"
            strSQL = "select number,name,user_pass from distributor3 where user_id = '" & LOGINID & "'"
            case "99"
            strSQL = "select number,name,password from patriot_distributor where user_id = '" & LOGINID & "'"
            case else
            call Msg_Box("로그인에 실패했습니다.\n\n해당되는 아이디가 없습니다.","parent.loginfrm.LOGINID","","")
    end select
    
	Rs.Open strSQL, GameDBconn, adOpenForwardOnly, adLockReadOnly
	if not Rs.EOF then
        NM = Rs("name")
		PWD = trim(Rs(2))
        dis_no = Rs(0)
		AUTH = gubun
	end if
	Rs.close
    
	closeGameDB
    
	if PWD = "" then
		call Msg_Box("로그인에 실패했습니다.\n\n해당되는 아이디가 없습니다.","parent.loginfrm.LOGINID","","")
	elseif PWD <> LOGINPW then
		call Msg_Box("로그인에 실패했습니다. \n\n비밀번호가 틀립니다.","parent.loginfrm.LOGINPW","","")
	else
		Response.Cookies(admincheck).Domain   = Domain
		Response.Cookies(admincheck).path = "/"
		Response.Cookies(admincheck).secure = False
		Response.Cookies(admincheck)("adminID") = LOGINID
        Response.Cookies(admincheck)("adminNo") = dis_no
		Response.Cookies(admincheck)("adminAuth") = NM
		Response.Cookies(admincheck)("adminPort") = ConnectPort
		Response.Cookies(admincheck)("IDAuth") = AUTH

		if id_save = "yes" then ' ID 쿠키저장
			'Response.Cookies(savecheck).domain   = Domain
			Response.Cookies(savecheck).path = "/"
			Response.Cookies(savecheck).secure = False
			Response.Cookies(savecheck)("id_save") = LOGINID
			Response.Cookies(savecheck).Expires = DateAdd("m",3,Now)
		else
			Response.Cookies(savecheck).Expires = Now
		end if

		if returl = "" then
			call returnURL("/$adm/default.asp","parent")
		else
            call returnURL("/$adm/default.asp","parent")
			'call returnURL(returl,"parent")
		end if

	end if
%>