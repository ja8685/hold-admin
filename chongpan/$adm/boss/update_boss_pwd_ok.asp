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
if IDAuth = 0 then
    sql = "update boss_distributor set password = '"&user_pwd&"',bank_name='"&bank_name&"',accountno='"&accountno&"',account_name='"&account_name&"' where user_id='"&userid&"'"
elseif IDAuth = 1 then
    sql = "update distributor1 set user_pass = '"&user_pwd&"',bank_name='"&bank_name&"',accountno='"&accountno&"',account_name='"&account_name&"' where user_id='"&userid&"'"
elseif IDAuth = 2 then
    sql = "update distributor2 set user_pass = '"&user_pwd&"',bank_name='"&bank_name&"',accountno='"&accountno&"',account_name='"&account_name&"' where user_id='"&userid&"'"
elseif IDAuth = 3 then
    sql = "update distributor3 set user_pass = '"&user_pwd&"' where user_id='"&userid&"'"
end if 

GameDBconn.Execute(sql)		
closeGameDB

    response.Write "<script>alert(""패스워드가 수정되었습니다."");</script>"
%>