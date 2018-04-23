<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
'grade=4&request_id=ja8685&possible_ex_amt=32%2C904%2C756&act_type=del&gold_amt=1%2C000&del_charge_desc=%B1%D7%B3%C9....
grade=trim(request.Form("grade"))

request_id=trim(request.Form("request_id"))
request_nick=trim(request.Form("request_nick"))
'possible_ex_amt=trim(request.Form("possible_ex_amt")*1000)
possible_ex_amt=trim(request.Form("possible_ex_amt"))
act_type=trim(request.Form("act_type"))
'gold_amt=cdbl(trim(request.Form("gold_amt"))*1000)
gold_amt=cdbl(trim(request.Form("gold_amt")))
gold_amt= replace(gold_amt,"-","")
del_charge_desc=trim(request.Form("del_charge_desc"))

connectionGameDB("PNC")
if grade = 4 then
    if request_id <> "" then       
        sql="select isnull(count(number),0) from users where user_id='"&request_id&"'"
        exit_user = Replace(GetString_List(sql),RowDel,"")       
    elseif request_nick <> "" then
        sql="select isnull(count(number),0) from users where user_nick='"&request_nick&"'"
        exit_user = Replace(GetString_List(sql),RowDel,"")                     
    end if
    if exit_user=0 then
        closeGameDB
        response.Write "<script>alert(""계정이 존재하지 않습니다."");parent.document.location.href='gold_del_charge.asp';</script>"
        response.end
    end if
end if

IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
AdminID = cstr(request.Cookies(admincheck)("AdminID")) 
Set SPcmd2 = Server.CreateObject("ADODB.Command")
SPcmd2.ActiveConnection = GameDBconn
with SPcmd2
	.CommandText = "[dbo].[SP_UDT_Gift]" 
	.CommandType = adCmdStoredProc
	.Parameters.Append .CreateParameter("@request_id", adVarWchar, adParamInput, 20, left(request_id,20)) 
	.Parameters.Append .CreateParameter("@request_nick", adVarWchar, adParamInput, 20, left(request_nick,20)) 
	.Parameters.Append .CreateParameter("@act_type", adVarchar, adParamInput, 10, left(act_type,10)) 
	.Parameters.Append .CreateParameter("@grade", adInteger, adParamInput, , cint(grade)) 
	.Parameters.Append .CreateParameter("@IDAuth", adInteger, adParamInput, , cint(IDAuth)) 
	.Parameters.Append .CreateParameter("@admin_id", adVarWchar, adParamInput, 20, left(AdminID,20)) 
	.Parameters.Append .CreateParameter("@gold_amt", adBigInt, adParamInput, , cdbl(gold_amt)) 
	.Parameters.Append .CreateParameter("@del_charge_desc", adVarWchar, adParamInput, 1000, left(del_charge_desc,1000)) 
	.Parameters.Append .CreateParameter("@ret_val", adInteger, adParamOutput, ,null) 
	.Execute
	ret_val = cint(.Parameters("@ret_val").Value)
end with
SPcmd2.ActiveConnection = nothing
Set SPcmd2 = nothing

upsql="select deal_money from distributor1 where user_id='"&AdminID&"'"
admin_rest_gold = trim(Replace(GetString_List(upsql),RowDel,""))
    If ret_val=3 Then                 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    elseIf ret_val=2 Then                 
        response.Write "<script>alert(""머니가 부족합니다.\n잠시후 다시 시도해 주세요"");</script>"
    elseIf ret_val=1 Then                 
        response.Write "<script>alert(""보유머니가 회수머니보다 부족합니다.\n잠시후 다시 시도해 주세요"");</script>"
    else                
        response.Write "<script>alert(""골드 충전/회수가 완료되었습니다."");parent.document.location.reload();top.menu.document.getElementById('admin_rest_money').innerHTML='"&formatnumber(admin_rest_gold,0)&"';</script>"
    end if
    closeGameDB
    
%>