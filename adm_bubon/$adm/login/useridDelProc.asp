<%
''################################################
''	File Name : useridDelProc.asp
''	Summary   : 환전소 삭제 처리
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

		response.write "<script>alert('아이디 삭제가 정상적으로 완료되었습니다.');</script>"
		response.write "<script>location.href='/login/useridList.asp';</script>"
	End If

	rootdb.Close : Set rootdb = Nothing
End If
%>