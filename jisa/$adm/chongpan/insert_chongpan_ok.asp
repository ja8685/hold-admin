<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%

bonsa_id=checkvalue(1,trim(request("bonsa_no")))
chongpan_no=checkvalue(1,trim(request("chongpan_no")))
chongpan_id=checkvalue(1,trim(request.Form("chongpan_id")))
chongpan_name=checkvalue(1,trim(request.Form("chongpan_name")))
'request_id=checkvalue(1,trim(request.Form("request_id")))
request_id=chongpan_id
chongpan_hp=checkvalue(1,trim(request.Form("chongpan_hp")))
chongpan_mail=checkvalue(1,trim(request.Form("chongpan_mail")))
chongpan_pwd=checkvalue(1,trim(request.Form("chongpan_pwd")))
chongpan_pwd_chk=checkvalue(1,trim(request.Form("chongpan_pwd_chk")))
chongpan_rate=checkvalue(1,trim(request.Form("chongpan_rate")))
bank_name=checkvalue(1,trim(request.Form("bank_name")))
accountno=checkvalue(1,trim(request.Form("accountno")))
account_name=checkvalue(1,trim(request.Form("account_name")))

connectionGameDB("PNC")

  GameDBconn.BeginTrans
        sql = "select distributor2_rate,distributor3_rate from dealer_rate_manager"
        set rs4 = GameDBconn.Execute(sql)		
        if not rs4.eof then            
            shop_rate = trim(rs4("distributor3_rate"))
        end if
        set rs4 = nothing
        jisa_no = request.Cookies(admincheck)("adminNo")
	sql = "select distribute1_link from distributor15 where number="&request.Cookies(admincheck)("adminNo")
	set rsno = GameDBconn.Execute(sql)		
	if not rsno.eof then
	bonsa_no=rsno(0)
	end if
	set rson = nothing
        sql = "insert into distributor2 (user_id,  user_pass,  name,master_name,phone,email, register_date,  status,bank_name,accountno,account_name,  money,  deal_money,  distribute2_rate,distribute3_rate,  user_rate,  distribute1_link,distribute15_link,game_id)"
        sql = sql&" values ('"&chongpan_id&"','"&chongpan_pwd&"','"&chongpan_name&"','"&chongpan_id&"','"&chongpan_hp&"','"&chongpan_mail&"',getdate()"
        sql = sql&",0,'"&bank_name&"','"&accountno&"','"&account_name&"',0,0,"&chongpan_rate&","&shop_rate&",0,"&bonsa_no&","&jisa_no&",'"&request_id&"')" 
        
        GameDBconn.Execute(sql)		
        IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
        if IDAuth = 3 then
            sql = "select distribute1_link,distribute2_link from distributor3 where user_id='"&chongpan_id&"'"
            set rs4 = GameDBconn.Execute(sql)		
            if not rs4.eof then            
                dis1_link = trim(rs4("distribute1_link"))
            end if
            set rs4 = nothing
        else
            dis1_link = 0
            dis2_link = 0
            dis3_link = 0
        end if

        sql="INSERT INTO users (user_id, user_pass, user_name, user_nick,user_sex, user_money, user_smoney, user_save, user_deal_money, user_avata, user_cardnum1, user_cardnum2, user_address1, user_address2, user_phone, "
        sql=sql&"user_regdate, user_currentdate, user_state, user_distributor1_link, user_distributor2_link, user_distributor3_link, user_rate, user_baduki_win, user_baduki_lose, user_baduki_cwin, user_holdem_win, "
        sql=sql&" user_holdem_lose, user_holdem_cwin, user_go_win, user_go_lose, user_go_cwin) VALUES "
        sql=sql&"('"&chongpan_id&"', '"&md5(chongpan_pwd)&"', '"&chongpan_name&"', '"&chongpan_name&"',0, 0, 0, 0, 0, 0, '', '', '', '', '',getdate(),getdate(), 0, "&dis1_link&", "&dis2_link&", "&dis3_link&", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)"
        
       ' GameDBconn.Execute(sql)	

        sql="INSERT INTO AX_GAMEUSERLIST (F_GAMEID,F_GAMEPWD,F_STORECODE,F_CODE,F_STATUS,F_NAME,F_SSN1,F_SSN2,F_SEX,F_NICK,F_ADDR,F_ADDR_GUBUN,F_EMAIL,F_EMAIL_YESNO,F_HP,F_BIRTH,F_FRIEND)"
        sql=sql&" VALUES ('"&chongpan_id&"','"&md5(txtPassword1)&"','A000000001','A000000001','Y','"&encrypt(chongpan_name)&"','"&encrypt("111111")&"','"&encrypt("1111111")&"',0,'"&chongpan_name&"','','1'"
        sql=sql&" ,'"&chongpan_mail&"','Y','"&chongpan_hp&"','1950-1-1','"&chongpan_id&"')"
        
        'GameDBconn.Execute(sql)

    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""총판 등록이 완료되었습니다."");parent.document.location.href='../chongpan/chongpanlist.asp?u_id="&bonsa_id&"'</script>"
    end if
    closeGameDB        
%>