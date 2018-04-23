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
     sql="select isnull(count(user_id),0) from users where user_name='"&request_id&"'"    
    rest_gold = cint(Replace(GetString_List(sql),RowDel,""))
else
rest_gold = 1
end if
    if rest_gold>0 then
        sql="select isnull(count(user_id),0) from v_all_member_list where user_id='"&request_id&"'"    
        rest_gold = cint(Replace(GetString_List(sql),RowDel,""))
        if rest_gold<1 then
            response.Write "Y"
        else
            response.Write "N"
        end if
    else
        response.Write "N"
    end if
    closeGameDB
    response.end    
%>