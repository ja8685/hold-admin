<%
''################################################
''	File Name : regUseridProc.asp
''	Summary   : ���̵� ���ó��
''################################################
%>
<!--#include virtual="/inc/func.asp"-->
<%
'If ADMIN_UID = "" Then
'	response.redirect "/"
'Else
	vUid = checkvalue(1,request("uid"))
	vPass1 = checkvalue(1,request("pass1"))
	vPass2 = checkvalue(1,request("pass2"))

	vStat = True
	vCause = 0

	If vUid = "" Then vStat = False : vCause = 1
	If vPass1 = "" Then vStat = False : vCause = 2
	If vPass2 = "" Then vStat = False : vCause = 3

	If vPass1 <> vPass2 Then vStat = False : vCause = 4

	Set rootdb=getrootdb()

	If vStat then
		sql = "SELECT F_IDX FROM AX_VISORLIST WHERE F_VISORID = '" & vUid & "'"
		Set Grs = rootdb.Execute(sql)

		If Not Grs.EOF Then
			vStat = False
			vCause = 5
		End If

		Grs.Close : Set Grs = Nothing
	End If

	If vStat Then
		sql = "INSERT INTO AX_VISORLIST (F_VISORID,F_VISORPWD) VALUES"
		sql = sql & " ('" & vUid & "','" & vPass1 & "')"

		rootdb.Execute(sql)
		response.write "<script>alert('���̵� ����Ͽ����ϴ�.');</script>"
		response.write "<script>location.href='/login/useridList.asp';</script>"
	Else
		Select Case vCause
			Case 1
				vMsg = "���̵� �Է��� �ּ���."
			Case 2
				vMsg = "��й�ȣ�� �Է��� �ּ���."
			Case 3
				vMsg = "Ȯ�ο� ��й�ȣ�� �Է��� �ּ���."
			Case 4
				vMsg = "Ȯ�ο� ��й�ȣ�� ���� �ʽ��ϴ�."
			Case 5
				vMsg = "�̹� ��ϵǾ� �ִ� ���̵� �Դϴ�."
		End Select

		response.write "<script>alert('" & vMsg & "');</script>"
		response.write "<script>location.href='/login/regUserid.asp';</script>"
	End If

	rootdb.Close : Set rootdb = Nothing
'End If
%>