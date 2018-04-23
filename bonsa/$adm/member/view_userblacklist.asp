<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
request_id=checkvalue(1,trim(request("request_id")))
request_nick=checkvalue(1,trim(request("request_nick")))
connectionGameDB("PNC")
if request_id<>"" then
sql="select isnull(number,0) from users where user_id='"&request_id&"'"
elseif request_nick<>"" then
sql="select isnull(number,0) from users where user_nick='"&request_nick&"'"
end if    
rest_gold = Replace(GetString_List(sql),RowDel,"")
if isnull(rest_gold)=true or len(rest_gold)=0 then rest_gold=0
response.Write rest_gold
closeGameDB
response.end    
%>