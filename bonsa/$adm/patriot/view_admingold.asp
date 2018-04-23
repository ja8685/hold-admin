<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
user_id     =request.Cookies(admincheck)("adminID")
connectionGameDB("PNC")

    if user_id <> "" then       
        sql="select isnull(deal_money,0) from v_member_admin_gold_list where user_id='"&user_id&"'"
        rest_gold = cdbl(Replace(GetString_List(sql),RowDel,""))          
    else
	    Response.Cookies(admincheck).domain = Domain
	    Response.Cookies(admincheck).path = "/"
	    Response.Cookies(admincheck).secure = false
	    Response.Cookies(admincheck) = ""
	    Response.Cookies(admincheck).Expires = Now
        Response.Cookies(admincheck)("adminID") = ""
        Response.Cookies(admincheck)("adminNo") = ""
	    Response.Cookies(admincheck)("adminAuth") = ""
	    Response.Cookies(admincheck)("adminPort") = ""
	    Response.Cookies(admincheck)("IDAuth") = ""
	    Response.Cookies(savecheck)("id_save") = ""
        response.Write "<script>alert('세션이 초기화되었습니다.\n다시 로그인해주세요!');top.document.location.href='$adm/login/loginform.asp';</script>"
    end if
    response.Write rest_gold
    closeGameDB
    response.end    
%>