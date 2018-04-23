<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<%
''################################################
''	File Name : changePassProc.asp
''	Summary   : 비밀번호 수정 처리
''################################################
%>
<%
	vPass1 = checkvalue(1,request("pass1"))
	vPass2 = checkvalue(1,request("pass2"))

	vStat = True
	vCause = 0

	If vPass1 = "" Then vStat = False : vCause = 1
	If vPass2 = "" Then vStat = False : vCause = 2
	If vPass1 <> vPass2 Then vStat = False : vCause = 3

	If vStat Then
		
		connectionDB("PNC")

		sql = "UPDATE AX_SUPERVISORLIST SET F_SUPERVISORPWD = '" & vPass1 & "'"
		'sql = sql & " WHERE F_SUPERVISORID = '" & ADMIN_UID & "'"	
		DBconn.Execute(sql)

		closeDB

		call Msg_Box("비밀번호가 변경되었습니다.\n\n변경된 비밀번호는 꼭 기억해 주세요.","","/","top")
	Else
		Select Case vCause
			Case 1
				vMsg = "비밀번호를 입력해 주세요."
			Case 2
				vMsg = "확인 비밀번호를 입력해 주세요."
			Case 3
				vMsg = "확인 비밀번호가 맞지 않습니다."
		End Select

		call Msg_Box(vMsg,"parent.frmLogin.pass1","","")
	End If
%>