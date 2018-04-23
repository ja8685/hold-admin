<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
uid=checkvalue(1,trim(request("uid")))
urate=checkvalue(1,trim(request("urate")))
connectionDB("PNC")
        sql = "update users set "
        if urate <> "" then
        sql = sql&" user_rate= "&urate
        end if
        sql = sql&" where user_id='"&uid&"'"
	    DBconn.Execute(sql)		        
        closeDB	            

    response.Write "<script>alert(""수수료가 수정되었습니다."");parent.document.location.href='memberlist.asp'</script>"
%>