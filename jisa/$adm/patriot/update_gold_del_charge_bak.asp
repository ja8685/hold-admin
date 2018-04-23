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
if request_id <> "" then
sql="select status from  connectedusers where user_id='"&request_id&"'"
elseif request_nick <> "" then
sql="select user_id from  users where user_nick='"&request_nick&"'"
user_id = Replace(GetString_List(sql),RowDel,"")
sql="select status from  connectedusers where user_id='"&user_id&"'"
end if
'conn_yn = Replace(GetString_List(sql),RowDel,"")
          if conn_yn = "" then
                conn_yn = 99
            end if
            select case conn_yn 
                    case 0
                    conn_state = "로비"
                    case 1
                    conn_state = "1번방"
                    case 2
                    conn_state = "2번방"
                    case 3
                    conn_state = "3번방"
                    case 4
                    conn_state = "4번방"
                    case 99
                    conn_state = "OFF"
            end select
if conn_state <>"OFF" then
    'response.Write "<script>alert(""게임중인 유저는 충전/회수를 할 수 없습니다."");parent.document.location.href='gold_del_charge.asp';</script>"
    'response.end
end if

IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
AdminID = cstr(request.Cookies(admincheck)("AdminID"))
    GameDBconn.BeginTrans    

    if request_id <> "" then
  
        sql="select user_money from users where user_id='"&request_id&"'"
       if act_type = "charge" then
            upsql="update users set user_money= user_money+ "&gold_amt&" where user_id='"&request_id&"'"
        end if                          
        rest_gold = Replace(GetString_List(sql),RowDel,"")
          
    
    elseif request_nick <> "" then
   
        sql="select user_money from users where user_nick='"&request_nick&"'"
       if act_type = "charge" then
            upsql="update users set user_money= user_money+ "&gold_amt&" where user_nick='"&request_nick&"'"
        end if                          
        rest_gold = Replace(GetString_List(sql),RowDel,"")
       
  
    end if

    
    GameDBconn.Execute(upsql)
     rest_gold = Replace(GetString_List(sql),RowDel,"")            
    if act_type="charge" then
        act_type = "C"
    end if      
    if act_type="C" then
        upsql="update distributor15 set deal_money = deal_money - "&gold_amt&" where user_id='"&AdminID&"'"
        GameDBconn.execute(upsql)	
    end if      
    if request_nick <> "" then        

        upsql="select user_id from users where user_nick='"&request_nick&"'"        
        request_id = Replace(GetString_List(upsql),RowDel,"")    

    end if
 
    if grade = 4 then
        sql="select b.user_id as shop_id,c.user_id as chongpan_id,d.user_id as jisa_id from users a inner join distributor3 b on a.user_distributor3_link=b.number inner join distributor2 c on a.user_distributor2_link=c.number inner join distributor15 d on a.user_distributor15_link=d.number where a.user_id='"&request_id&"'"
        set rs12 = GameDBconn.Execute(sql)	
        if not rs12.eof then
            shop_id = rs12(0)
            chongpan_id= rs12(1)
            jisa_id = rs12(2)
        end if
        set rs12 = nothing
        if act_type="C" then
            'sql21="insert into tb_Deposit_log (parent_no,take_id,outcome_amt,status,bonsa_id,jisa_id,chongpan_id,shop_id,bonsa_rate,chongpan_rate,shop_rate,bonsa_commission,chongpan_commission,shop_commission,approval_date)"
            'sql21=sql21&" values ("&no&",'"&request_id&"',"&gold_amt&",'C','"&AdminID&"','"&jisa_id&"','"&chongpan_id&"','"&shop_id&"',0,0,0,0,0,0,getdate())"
            sql21="insert into GiftToLog (from_user,to_user,money,rest_gold,gold_desc,date)"
            sql21=sql21&" values ('"&adminID&"','"&request_id&"',"&gold_amt&","&rest_gold&",'"&del_charge_desc&"',getdate())"
        end if 
        GameDBconn.execute(sql21)	
    end if
     upsql="select deal_money from distributor15 where user_id='"&AdminID&"'"
    admin_rest_gold = trim(Replace(GetString_List(upsql),RowDel,""))
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans        
        response.Write "<script>alert(""머니 충전이 완료되었습니다."");parent.document.location.reload();top.menu.document.getElementById('admin_rest_money').innerHTML='"&formatnumber(admin_rest_gold,0)&"';</script>"
    end if
    closeGameDB
    
%>