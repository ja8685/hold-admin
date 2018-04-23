<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
user_id     =request.Cookies(admincheck)("adminID")
request_id=checkvalue(1,trim(request("request_id")))
grade=4
connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
     sql="select count(user_id) from v_member_admin_list where user_id='"&request_id&"'"
    rest_gold = cint(Replace(GetString_List(sql),RowDel,""))
    response.Write rest_gold
    closeGameDB
    response.end    
%>