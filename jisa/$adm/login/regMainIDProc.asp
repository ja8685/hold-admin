<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<%
	if Request.Cookies(admincheck)("IDAuth") = 0 then 
		call Msg_Box("���� ������ �����ϴ�.","","/","top")
	end if

	on Error Resume Next

	'������ ����
	Dim proc, f_idx, f_supervisorid, f_supervisorpwd, f_auth
	Dim page, keyfield, keyword

	proc = Request("proc")
	f_idx = Request("f_idx")
	f_name = Request("f_name")
	f_supervisorid = Request("f_supervisorid")
	f_supervisorpwd = Request("pass1") 
	f_auth   = Request("f_auth")

	page   = Request("page")
	keyfield = Trim(Request("keyfield"))
	keyword = Trim(Request("keyword"))

	if f_auth = "" then f_auth = 0

	Dim Cmd, strSQL
	Dim Return_URL, parameters

	parameters = "f_headcode=" & f_headcode & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
	parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
	parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size

	Return_URL = "MainIDList.asp?" & parameters

	'Response.Redirect Return_URL

	connectionDB("PNC")

	If proc = "write" Then
		'���θ���Ʈ ���
		strSQL = "select f_supervisorid from AX_SUPERVISORLIST where f_supervisorid = '" & f_supervisorid & "'"
		Rs.Open strSQL, DBconn, adOpenForwardOnly, adLockReadOnly
		If Rs.EOF Then
			strSQL = "insert into AX_SUPERVISORLIST(f_supervisorid,f_supervisorpwd,f_auth) values('"& f_supervisorid & "','"& f_supervisorpwd & "',"& f_auth &")"
			Msg = "��ϵǾ����ϴ�." 
		Else
			Msg = "�ߺ��� ���̵� �ֽ��ϴ�.\n\n�ٸ� ���̵� ������ּ���."
			Rs.close
			closeDB
			call Msg_Box(Msg ,"","","")
		End If
		Rs.close
	ElseIf proc = "edit" then
		'���θ���Ʈ ����
		strSQL = "update AX_SUPERVISORLIST set f_supervisorid = '" & f_supervisorid & "',  f_supervisorpwd = '" & f_supervisorpwd 
		strSQL = strSQL & "', f_auth = " & f_auth & " where F_IDX = "& f_idx
		Msg = "�����Ǿ����ϴ�." 
	Else
		'���θ���Ʈ ����
		strSQL = "delete from  AX_SUPERVISORLIST where F_IDX = "& f_idx
		Msg = "�����Ǿ����ϴ�." 
	End If
	'Response.Write strSQL
	CommandExec(strSQL)
	
	closeDB

	if Err.Number = 0 then
		call Msg_Box(Msg ,"",Return_URL,"parent")
	else
		call Msg_Box( "ó���� ������ �߻��Ǿ����ϴ�.\n\n�����ڵ� : " & Err.Number & "\n\n" & Replace(Err.Description,vbCRLF,"\n"),"","","")
	end if
%>