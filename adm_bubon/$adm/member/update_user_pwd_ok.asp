<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
user_pwd=checkvalue(1,trim(request.Form("user_pwd")))
user_pwd_chk=checkvalue(1,trim(request.Form("user_pwd_chk")))
user_ECpwd=checkvalue(1,trim(request.Form("user_ECpwd")))
user_ECpwd_chk=checkvalue(1,trim(request.Form("user_ECpwd_chk")))
hp_1=checkvalue(1,trim(request.Form("hp_1")))
hp_2=checkvalue(1,trim(request.Form("hp_2")))
hp_3=checkvalue(1,trim(request.Form("hp_3")))
hp = hp_1&"-"&hp_2&"-"&hp_3
bank_name=checkvalue(1,trim(request.Form("bank_name")))
accountno=checkvalue(1,trim(request.Form("accountno")))
accountname=checkvalue(1,trim(request.Form("accountname")))
user_nick=checkvalue(1,trim(request.Form("user_nick")))

user_degree=checkvalue(1,trim(request.Form("user_degree")))

if user_pwd<>user_pwd_chk then
response.End
end if
userid=trim(request.Form("user_id"))
connectionDB("PNC")


        sql = "update users set "
        if user_pwd <> "" then
        sql = sql&" user_pass = '"&md5(user_pwd)&"',"
        end if
        if user_ECpwd <> "" then
        sql = sql&" user_CEpass = '"&md5(user_ECpwd)&"',"
        end if
        if user_nick <> "" then
        sql = sql&" user_nick = '"&user_nick&"',"
        end if
    
        sql = sql&" user_bank_name='"&bank_name&"',user_account_no='"&accountno&"',user_account_name='"&accountname&"',user_phone='"&hp&"',user_degree='"&user_degree&"' where user_id='"&userid&"'"
	    DBconn.Execute(sql)		
        if user_pwd <> "" then
        sql = "update AX_GAMEUSERLIST set "
        sql = sql&" F_GAMEPWD = '"&md5(user_pwd)&"' where F_GAMEID='"&userid&"'"
        
	    DBconn.Execute(sql)	
        sql = "update users set "
        sql = sql&" user_pass = '"&md5(user_pwd)&"' where user_id='"&userid&"'"
        
	    DBconn.Execute(sql)	
        end if
        closeDB	            

    response.Write "<script>alert(""개인정보가 수정되었습니다."");</script>"
%>