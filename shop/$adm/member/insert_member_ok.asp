<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%

chongpan_no=checkvalue(1,trim(request("chongpan_no")))
chongpan_id=checkvalue(1,trim(request.Form("chongpan_id")))
chongpan_name=checkvalue(1,trim(request.Form("chongpan_name")))
chongpan_hp=checkvalue(1,trim(request.Form("chongpan_hp")))
request_id=checkvalue(1,trim(request.Form("request_id")))
chongpan_pwd=checkvalue(1,trim(request.Form("chongpan_pwd")))
chongpan_pwd_chk=checkvalue(1,trim(request.Form("chongpan_pwd_chk")))
chongpan_ce_pwd=checkvalue(1,trim(request.Form("chongpan_cepwd")))
chongpan_ce_pwd_chk=checkvalue(1,trim(request.Form("chongpan_cepwd_chk")))
exist_id=checkvalue(1,trim(request.Form("exist_id")))
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if exist_id = "N" then
response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
response.Write "<script>history.back();</script>"
response.end
end if
connectionGameDB("PNC")
sql="select isnull(count(user_id),0) from users where user_name='"&chongpan_name&"'"    
exit_nick = cint(Replace(GetString_List(sql),RowDel,""))
if exit_nick>0 then
    closeGameDB
    response.Write "<script>alert(""닉네임이 사용중 입니다.!"");</script>"
    response.End
end if
  GameDBconn.BeginTrans
        
            sql = "select distribute1_link,distribute15_link,distribute2_link,number from distributor3 where user_id='"&request.Cookies(admincheck)("adminID")&"'"
            set rs4 = GameDBconn.Execute(sql)		
            if not rs4.eof then            
                dis1_link = trim(rs4("distribute1_link"))
                dis2_link = trim(rs4("distribute2_link"))
                dis15_link = trim(rs4("distribute15_link"))
                dis3_link = trim(rs4("number"))
            end if
            set rs4 = nothing        
randomize
user_avatar = int((rnd*18)+1)
         sql="INSERT INTO users (user_id, user_pass,user_cepass, user_name, user_nick,user_sex, user_money, user_smoney, user_save, user_deal_money, user_avata, user_cardnum1, user_cardnum2, user_address1, user_address2, user_phone, "
        sql=sql&"user_regdate, user_currentdate, user_state, user_distributor1_link,user_distributor15_link, user_distributor2_link, user_distributor3_link, user_rate, user_baduki_win, user_baduki_lose, user_baduki_cwin, user_holdem_win, "
        sql=sql&" user_holdem_lose, user_holdem_cwin, user_go_win, user_go_lose, user_go_cwin) VALUES "
        sql=sql&"('"&chongpan_id&"', '"&md5(chongpan_pwd)&"','"&md5(chongpan_ce_pwd)&"', '"&chongpan_name&"', '"&chongpan_name&"',0, 0, 0, 0, 0, "&user_avatar&", '', '', '', '', '"&chongpan_hp&"',getdate(),getdate(), 0, "&dis1_link&", "&dis15_link&", "&dis2_link&", "&dis3_link&", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)"
        
        GameDBconn.Execute(sql)	

        sql="INSERT INTO AX_GAMEUSERLIST (F_GAMEID,F_GAMEPWD,F_STORECODE,F_CODE,F_STATUS,F_NAME,F_SSN1,F_SSN2,F_SEX,F_NICK,F_ADDR,F_ADDR_GUBUN,F_EMAIL,F_EMAIL_YESNO,F_HP,F_BIRTH,F_FRIEND)"
        sql=sql&" VALUES ('"&chongpan_id&"','"&md5(chongpan_pwd)&"','A000000001','A000000001','Y','"&encrypt(chongpan_name)&"','"&encrypt("111111")&"','"&encrypt("1111111")&"',0,'"&chongpan_name&"','','1'"
        sql=sql&" ,'"&chongpan_mail&"','Y','"&chongpan_hp&"','1950-1-1','"&request.Cookies(admincheck)("adminID")&"')"
        
        GameDBconn.Execute(sql)        

    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""회원 등록이 완료되었습니다."");parent.document.location.href='./memberlist.asp'</script>"
    end if
    closeGameDB        
%>