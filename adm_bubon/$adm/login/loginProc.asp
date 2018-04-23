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
	strSQL = "select number,user_id,user_pass from bubonsa where user_id = '" & LOGINID & "' and status=0"
	Rs.Open strSQL, GameDBconn, adOpenForwardOnly, adLockReadOnly

	if not Rs.EOF then
        NM = Rs("user_id")
		PWD = trim(Rs(2))
        dis_no = Rs(0)
		AUTH = gubun

		strJisaNO = ""
		strJisaID = ""

		strSQL1 = "select a.number,a.user_id from distributor15 a, bubonsa_jisalist b where b.bubonsa_id='" & LOGINID & "' and a.user_id=b.jisa_id"

		RegList = GetString_List(strSQL1) 
		
		if RegList = "" Then
		else
			cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
			listnumber = RecordCount - cnumber    	
			Rows = split(RegList,RowDel)
			For i = 0 to UBound(Rows)-1
				Cols	= split(Rows(i),ColDel)       
				jisa_no	= Cols(0)    
				jisa_id	= Cols(1)

				If i=0 then
					strJisaNO = strJisaNO & "'" & jisa_no & "'"
					strJisaID = strJisaID & "'" & jisa_id & "'"
				else
					strJisaNO = strJisaNO & ",'"  & jisa_no & "'"
					strJisaID = strJisaID & ",'"  & jisa_id & "'"
				End if
			Next
		End if

	end if
	Rs.close
    
	closeGameDB
    
	if PWD = "" then
		call Msg_Box("로그인에 실패했습니다.\n\n해당되는 정보가 없습니다.","parent.loginfrm.LOGINID","","")
	elseif PWD <> LOGINPW then
		call Msg_Box("로그인에 실패했습니다. \n\n해당되는 정보가 없습니다.","parent.loginfrm.LOGINPW","","")
	else
		Response.Cookies(admincheck).Domain   = Domain
        Response.Cookies(admincheck).path = "/"
		Response.Cookies(admincheck).secure = False
		Response.Cookies(admincheck)("adminID") = LOGINID
        Response.Cookies(admincheck)("adminNo") = dis_no
		Response.Cookies(admincheck)("adminAuth") = NM
		Response.Cookies(admincheck)("adminPort") = ConnectPort
		Response.Cookies(admincheck)("IDAuth") = AUTH
		Response.Cookies(admincheck)("BubonJisaNo") = strJisaNO
		Response.Cookies(admincheck)("BubonJisaId") = strJisaID
        if id_save = "yes" then ' ID 쿠키저장
			'Response.Cookies(savecheck).domain   = Domain
			Response.Cookies(savecheck).path = "/"
			Response.Cookies(savecheck).secure = False
			Response.Cookies(savecheck)("id_save") = LOGINID
			Response.Cookies(savecheck).Expires = DateAdd("m",3,Now)
		else
			Response.Cookies(savecheck).Expires = Now
		end if
        
		'if returl = "" then
			call returnURL("/$adm/chongpan/chongpanlist.asp","parent")
		'else
		'	call returnURL(returl,"parent")
		'end if

	end if
%>