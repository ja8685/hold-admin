<%
''################################################
''	File Name : useridDelProc.asp
''	Summary   : ȯ���� ���� ó��
''################################################
%>
<!--#include virtual="/inc/func.asp"-->
<%
If ADMIN_UID = "" Then
	response.redirect "/"
Else
	vIdx = checkvalue(1,request("idx"))

	vStat = True
	vCause = 0

	Set rootdb=getrootdb()

	If vStat Then
		sql = "DELETE FROM AX_VISORLIST WHERE F_IDX = " & vIdx
		rootdb.Execute(sql)

		response.write "<script>alert('���̵� ������ ���������� �Ϸ�Ǿ����ϴ�.');</script>"
		response.write "<script>location.href='/login/useridList.asp';</script>"
	End If

	rootdb.Close : Set rootdb = Nothing
End If
%>