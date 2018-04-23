<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
user_id     =request.Cookies(admincheck)("adminID")
request_id=checkvalue(1,trim(request("request_id")))

connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if IDAuth = 3 then
     sql="select count(user_id) from v_all_member_list where user_id='"&request_id&"'"
    rest_gold = cint(Replace(GetString_List(sql),RowDel,""))
else
rest_gold = 1
end if
    response.Write rest_gold
    closeGameDB
    response.end    
%>