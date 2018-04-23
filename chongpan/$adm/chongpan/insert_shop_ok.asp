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
        sql = "select distribute1_link,distribute15_link from distributor2 where number="&request.Cookies(admincheck)("adminNo")
        set rs5 = GameDBconn.Execute(sql)		
        if not rs5.eof then
            bonsa_no = trim(rs5("distribute1_link"))
            jisa_no = trim(rs5("distribute15_link"))
        end if
        set rs5 = nothing
    end if             
    
        sql = "insert into distributor3 (user_id,  user_pass,  name,master_name,phone,email, register_date,  status,  money,  deal_money,  distribute3_rate,  user_rate,  distribute1_link,distribute15_link,distribute2_link,game_id)"
        sql = sql&" values ('"&chongpan_id&"','"&chongpan_pwd&"','"&chongpan_name&"','"&chongpan_name&"','"&chongpan_hp&"','"&chongpan_mail&"',getdate()"
        sql = sql&",0,0,0,"&chongpan_rate&",0,"&bonsa_no&","&jisa_no&","&chongpan_no&",'"&chongpan_id&"')" 
   
        GameDBconn.Execute(sql)		       

        
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        
            sql = "select distribute1_link,distribute2_link,number from distributor3 where user_id='"&chongpan_id&"'"
            set rs4 = GameDBconn.Execute(sql)		
            if not rs4.eof then            
                dis1_link = trim(rs4("distribute1_link"))
                dis2_link = trim(rs4("distribute2_link"))
                dis3_link = trim(rs4("number"))
            end if
            set rs4 = nothing        

         sql="INSERT INTO users (user_id, user_pass, user_name, user_nick,user_sex, user_money, user_smoney, user_save, user_deal_money, user_avata, user_cardnum1, user_cardnum2, user_address1, user_address2, user_phone, "
        sql=sql&"user_regdate, user_currentdate, user_state, user_distributor1_link, user_distributor2_link, user_distributor3_link, user_rate, user_baduki_win, user_baduki_lose, user_baduki_cwin, user_holdem_win, "
        sql=sql&" user_holdem_lose, user_holdem_cwin, user_go_win, user_go_lose, user_go_cwin) VALUES "
        sql=sql&"('"&chongpan_id&"', '"&md5(chongpan_pwd)&"', '"&chongpan_name&"', '"&chongpan_name&"',0, 0, 0, 0, 0, 0, '', '', '', '', '',getdate(),getdate(), 0, "&dis1_link&", "&dis2_link&", "&dis3_link&", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)"
        
       ' GameDBconn.Execute(sql)	

        sql="INSERT INTO AX_GAMEUSERLIST (F_GAMEID,F_GAMEPWD,F_STORECODE,F_CODE,F_STATUS,F_NAME,F_SSN1,F_SSN2,F_SEX,F_NICK,F_ADDR,F_ADDR_GUBUN,F_EMAIL,F_EMAIL_YESNO,F_HP,F_BIRTH,F_FRIEND)"
        sql=sql&" VALUES ('"&chongpan_id&"','"&md5(chongpan_pwd)&"','A000000001','A000000001','Y','"&encrypt(chongpan_name)&"','"&encrypt("111111")&"','"&encrypt("1111111")&"',0,'"&chongpan_name&"','','1'"
        sql=sql&" ,'"&chongpan_mail&"','Y','"&chongpan_hp&"','1950-1-1','"&chongpan_id&"')"
        
        'GameDBconn.Execute(sql)        
        if IDAuth = 0 then
        
        elseif IDAuth = 1 then                                                                                                'u_id=83&bonsa_id=007&chongpan_id=fdfdfd
            response.Write "<script>alert(""매장 등록이 완료되었습니다."");parent.document.location.href='./below_shoplist.asp?u_id="&chongpan_no&"&bonsa_id="&bonsa_id2&"&chongpan_id="&chongpan_no&"'</script>"
        elseif IDAuth = 2 then
            response.Write "<script>alert(""매장 등록이 완료되었습니다."");parent.document.location.href='../chongpan/below_shoplist.asp'</script>"
        end if
    end if
    closeGameDB        
%>