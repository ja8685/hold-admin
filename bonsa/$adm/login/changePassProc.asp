<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<%
''################################################
''	File Name : changePassProc.asp
''	Summary   : ��й�ȣ ���� ó��
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

		call Msg_Box("��й�ȣ�� ����Ǿ����ϴ�.\n\n����� ��й�ȣ�� �� ����� �ּ���.","","/","top")
	Else
		Select Case vCause
			Case 1
				vMsg = "��й�ȣ�� �Է��� �ּ���."
			Case 2
				vMsg = "Ȯ�� ��й�ȣ�� �Է��� �ּ���."
			Case 3
				vMsg = "Ȯ�� ��й�ȣ�� ���� �ʽ��ϴ�."
		End Select

		call Msg_Box(vMsg,"parent.frmLogin.pass1","","")
	End If
%>