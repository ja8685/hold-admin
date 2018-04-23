<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
IDAuth			= cint(request.Cookies(admincheck)("IDAuth"))
bubonsa_id		= checkvalue(1,trim(request.Form("bubonsa_id")))
bubonsa_hp		= checkvalue(1,trim(request.Form("bubonsa_hp")))
bubonsa_pwd		= checkvalue(1,trim(request.Form("bubonsa_pwd")))
bubonsa_pwd_chk	= checkvalue(1,trim(request.Form("bubonsa_pwd_chk")))
exist_id		= checkvalue(1,trim(request.Form("exist_id")))
cnt				= request.Form("jisa_id[]").count

'For k = 1 To cnt
'	Response.write checkvalue(1,trim(request.Form("jisa_id[]")(k))) & "<br>"
'Next
'
'Response.write cnt
'Response.end

if exist_id = "N" then
	response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");parent.document.location.href='/$adm/bonsa/insert_bubonsa.asp'</script>"
	response.end
end If

connectionGameDB("PNC")

if IDAuth = 1 then
	GameDBconn.BeginTrans
	bonsa_no = cint(request.Cookies(admincheck)("adminNo"))

	sql = "insert into bubonsa (user_id, user_pass, phone, email, money, status, register_date)"
	sql = sql&" values ('"&bubonsa_id&"','"&bubonsa_pwd&"','"&bubonsa_hp&"',NULL,0,0,getdate())" 
	GameDBconn.Execute(sql)	

	
	For k = 1 To cnt
		sql = "insert into bubonsa_jisalist (bubonsa_id, jisa_id, register_date)"
		sql = sql&" values ('"&bubonsa_id&"','"&checkvalue(1,trim(request.Form("jisa_id[]")(k)))&"',getdate())" 
		GameDBconn.Execute(sql)
	Next
	
	If GameDBconn.Errors.Count <> 0 Then
		GameDBconn.RollbackTrans
		response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");parent.document.location.href='/$adm/bonsa/insert_bubonsa.asp'</script>"
		response.end
	else
		GameDBconn.CommitTrans
		response.Write "<script>alert(""부본사 등록이 완료되었습니다."");parent.document.location.href='/$adm/bonsa/bubonsalist.asp'</script>"
		response.end
	end If
else
	response.Write "<script>alert(""부본사를 등록할 수 없습니다."");parent.document.location.href='/$adm/bonsa/insert_bubonsa.asp'</script>"
	response.end
end If

closeGameDB
%>