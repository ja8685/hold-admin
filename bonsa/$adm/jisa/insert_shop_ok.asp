<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%

bonsa_id=checkvalue(1,trim(request("bonsa_no")))
bonsa_id2=checkvalue(1,trim(request("bonsa_id")))
chongpan_no=checkvalue(1,trim(request("chongpan_no")))
chongpan_id=checkvalue(1,trim(request.Form("chongpan_id")))
chongpan_name=checkvalue(1,trim(request.Form("chongpan_name")))
request_id=checkvalue(1,trim(request.Form("request_id")))
chongpan_hp=checkvalue(1,trim(request.Form("chongpan_hp")))
chongpan_mail=checkvalue(1,trim(request.Form("chongpan_mail")))
chongpan_pwd=checkvalue(1,trim(request.Form("chongpan_pwd")))
chongpan_pwd_chk=checkvalue(1,trim(request.Form("chongpan_pwd_chk")))
chongpan_rate=checkvalue(1,trim(request.Form("chongpan_rate")))
exist_id=checkvalue(1,trim(request.Form("exist_id")))
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if exist_id = "N" then
response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
response.Write "<script>history.back();</script>"
response.end
end if
connectionGameDB("PNC")

  GameDBconn.BeginTrans
  IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
    if IDAuth = 1 then
        bonsa_no = cint(request.Cookies(admincheck)("adminNo"))    
    elseif IDAuth = 2 then
        sql = "select distribute1_link from distributor2 where number="&request.Cookies(admincheck)("adminNo")
        set rs5 = GameDBconn.Execute(sql)		
        if not rs5.eof then
            bonsa_no = trim(rs5("distribute1_link"))
        end if
        set rs5 = nothing
    end if             
     sql="select distribute15_link from distributor2 where number ="&chongpan_no
     jisa_no = Cint(Replace(GetString_List(sql),RowDel,""))
        sql = "insert into distributor3 (user_id,  user_pass,  name,master_name,phone,email, register_date,  status,  money,  deal_money,  distribute3_rate,  user_rate,  distribute1_link,distribute15_link,distribute2_link,game_id)"
        sql = sql&" values ('"&chongpan_id&"','"&chongpan_pwd&"','"&chongpan_name&"','"&chongpan_name&"','"&chongpan_hp&"','"&chongpan_mail&"',getdate()"
        sql = sql&",0,0,0,"&chongpan_rate&",0,"&bonsa_no&","&jisa_no&","&chongpan_no&",'"&chongpan_id&"')" 
   
        GameDBconn.Execute(sql)		       

        
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        
        response.Write "<script>alert(""매장 등록이 완료되었습니다."");parent.document.location.reload()</script>"
        
    end if
    closeGameDB        
%>