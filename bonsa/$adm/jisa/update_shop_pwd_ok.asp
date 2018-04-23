<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
user_pwd=checkvalue(1,trim(request.Form("user_pwd")))
user_pwd_chk=checkvalue(1,trim(request.Form("user_pwd_chk")))
if user_pwd<>user_pwd_chk then
response.End
end if
userid=trim(request.Form("user_id"))
connectionGameDB("PNC")

        sql = "update distributor3 set user_pass = '"&user_pwd&"' where user_id='"&userid&"'"
	    GameDBconn.Execute(sql)		
        closeGameDB

    response.Write "<script>alert(""패스워드가 수정되었습니다."");</script>"
%>