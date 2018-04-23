<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
user_id     =request.Cookies(admincheck)("adminID")
request_id=checkvalue(1,trim(request("request_id")))
request_nick=checkvalue(1,trim(request("request_nick")))
grade=cint(checkvalue(1,trim(request("grade"))))
connectionGameDB("PNC")

IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if grade="4" then
    if request_id <> "" then       
        sql="select isnull(user_money,0) from users where user_id='"&request_id&"'"
        rest_gold = Replace(GetString_List(sql),RowDel,"")       
    elseif request_nick <> "" then
        sql="select isnull(user_money,0) from users where user_nick='"&request_nick&"'"
        rest_gold = Replace(GetString_List(sql),RowDel,"")                     
    end if
elseif grade="3" then
    if request_id <> "" then       
        sql="select isnull(deal_money,0) from distributor3 where user_id='"&request_id&"'"
        rest_gold = Replace(GetString_List(sql),RowDel,"")       
    elseif request_nick <> "" then
        sql="select isnull(deal_money,0) from distributor3 where name='"&request_nick&"'"
        rest_gold = Replace(GetString_List(sql),RowDel,"")                     
    end if
elseif grade="2" then
    if request_id <> "" then       
        sql="select isnull(deal_money,0) from distributor2 where user_id='"&request_id&"'"
        rest_gold = Replace(GetString_List(sql),RowDel,"")       
    elseif request_nick <> "" then
        sql="select isnull(deal_money,0) from distributor2 where name='"&request_nick&"'"
        rest_gold = Replace(GetString_List(sql),RowDel,"")                     
    end if
elseif grade="15" then
    if request_id <> "" then       
        sql="select isnull(deal_money,0) from distributor15 where user_id='"&request_id&"'"
        rest_gold = Replace(GetString_List(sql),RowDel,"")       
    elseif request_nick <> "" then
        sql="select isnull(deal_money,0) from distributor15 where name='"&request_nick&"'"
        rest_gold = Replace(GetString_List(sql),RowDel,"")                     
    end if   
end if
    response.Write rest_gold
    closeGameDB
    response.end    
%>