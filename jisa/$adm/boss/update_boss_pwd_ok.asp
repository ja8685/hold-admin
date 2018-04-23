<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
user_pwd=checkvalue(1,trim(request.Form("user_pwd")))
user_pwd_chk=checkvalue(1,trim(request.Form("user_pwd_chk")))
bank_name=checkvalue(1,trim(request.Form("bank_name")))
accountNo=checkvalue(1,trim(request.Form("accountNo")))
account_name=checkvalue(1,trim(request.Form("account_name")))
if user_pwd<>user_pwd_chk then
response.End
end if
userid=trim(Request.Cookies(admincheck)("adminID"))
connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
sql = "update distributor15 set user_pass = '"&user_pwd&"',bank_name='"&bank_name&"',accountno='"&accountno&"',account_name='"&account_name&"' where user_id='"&userid&"'"
GameDBconn.Execute(sql)		
closeGameDB

    response.Write "<script>alert(""패스워드가 수정되었습니다."");</script>"
%>