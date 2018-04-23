<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if IDAuth <> 1 then
response.end
end if
no=checkvalue(1,trim(request("no")))
gubun=checkvalue(1,trim(request("gubun")))
connectionGameDB("PNC")

    GameDBconn.BeginTrans    
            
    if no = "" then
        GameDBconn.RollbackTrans
        response.end
    end if    

    sql="select take_id,outcome_amt,status from TB_outcome with(nolock) where idx="&no
    
    set rs4 = GameDBconn.execute(sql)
    if not rs4.eof then
        take_id = rs4("take_id")
        outcome_amt = cdbl(rs4("outcome_amt"))
        status = rs4("status") 
       
            sql = "select user_money from users where user_id='"&take_id&"'"
            
            'set rs1 = GameDBconn.execute(sql)
            'if cdbl(rs1(0)) < outcome_amt then
                'GameDBconn.RollbackTrans
                'response.Write "<script>alert(""환전금액이 보유금액보다 적습니다!"");history.back();</script>"
                'response.end
            'else
                            sql="     select c.user_id as bonsa_id,e.user_id as jisa_id,b.user_id as chongpan_id,a.user_id as shop_id,d.user_id,c.distribute1_rate,e.distribute15_rate ,b.distribute2_rate ,a.distribute3_rate from distributor3 a inner join distributor2 b on a.distribute2_link=b.number"
                            sql=sql&" inner join distributor1 c on a.distribute1_link=c.number inner join users d on a.number=user_distributor3_link inner join distributor15 e on a.distribute15_link=e.number  where d.user_id='"&take_id&"'"
            
                            set rs2 = GameDBconn.execute(sql)
                                bonsa_id=trim(rs2("bonsa_id"))
                                jisa_id=trim(rs2("jisa_id"))
                                chongpan_id=trim(rs2("chongpan_id"))
                                shop_id=trim(rs2("shop_id"))
                                distribute1_rate=trim(rs2("distribute1_rate"))
                                distribute15_rate=trim(rs2("distribute15_rate"))
                                distribute2_rate=trim(rs2("distribute2_rate"))
                                distribute3_rate=trim(rs2("distribute3_rate"))
                                distribute1_amt=outcome_amt*cdbl(trim(rs2("distribute1_rate")))/100
                                distribute15_amt=outcome_amt*cdbl(trim(rs2("distribute15_rate")))/100
                                distribute2_amt=outcome_amt*cdbl(trim(rs2("distribute2_rate")))/100
                                distribute3_amt=outcome_amt*cdbl(trim(rs2("distribute3_rate")))/100

                            set rs2 = nothing                
                select case gubun
                        case "Y"
            
                        if status <> "Y" then
                            sql="select count(status) from tb_outcome_log where parent_no="&no
                            
                            set rs2 = GameDBconn.execute(sql)                         
                            log_cnt = rs2(0)
                            set rs2 = nothing
                            'if log_cnt = 0 then
                                sql="update TB_outcome set status='Y',approval_date=getdate() where idx="&no
                                GameDBconn.execute(sql)
                                sql312="update users set user_money=user_money-"&outcome_amt&" where user_id='"&take_id&"'"
                                'GameDBconn.execute(sql312)  
                                sql21="insert into tb_outcome_log (parent_no,take_id,outcome_amt,status,bonsa_id,jisa_id,chongpan_id,shop_id,bonsa_rate,jisa_rate,chongpan_rate,shop_rate,bonsa_commission,jisa_commission,chongpan_commission,shop_commission,approval_date)"
                                sql21=sql21&" values ("&no&",'"&take_id&"',"&outcome_amt&",'Y','"&bonsa_id&"','"&jisa_id&"','"&chongpan_id&"','"&shop_id&"',"&distribute1_rate&","&distribute15_rate&","&distribute2_rate&","&distribute3_rate&","&distribute1_amt&","&distribute15_amt&","&distribute2_amt&","&distribute3_amt&",getdate())"
                                GameDBconn.execute(sql21)
                                sql1="update distributor1 set deal_money=deal_money+"&outcome_amt&" where user_id='"&bonsa_id&"'"
                                GameDBconn.execute(sql1)
                                'sql2="update distributor2 set deal_money=deal_money+"&distribute2_amt&" where user_id='"&chongpan_id&"'"
                                'GameDBconn.execute(sql2)
                                'sql3="update distributor3 set deal_money=deal_money+"&distribute3_amt&" where user_id='"&shop_id&"'"
                                'GameDBconn.execute(sql3)
                            'end if
                        end if
                        case "C"
                         
                         if status = "N" then
                         sql6="update users set user_money=user_money+"&outcome_amt&" where user_id='"&take_id&"'"
                         GameDBconn.execute(sql6)     
                        sql1="update distributor1 set deal_money=deal_money-"&outcome_amt&" where user_id='"&bonsa_id&"'"
                       ' GameDBconn.execute(sql1)
                        sql2="update distributor15 set deal_money=deal_money-"&distribute15_amt&" where user_id='"&jisa_id&"'"
                       ' GameDBconn.execute(sql2)
                        sql2="update distributor2 set deal_money=deal_money-"&distribute2_amt&" where user_id='"&chongpan_id&"'"
                       ' GameDBconn.execute(sql2)
                        sql3="update distributor3 set deal_money=deal_money-"&distribute3_amt&" where user_id='"&shop_id&"'"                                                          
                       ' GameDBconn.execute(sql3)
                        end if
                        sql="update TB_outcome set status='C',approval_date=getdate() where idx="&no
                         GameDBconn.execute(sql)
                        case "D"
                         sql="delete from TB_outcome where idx="&no
                         GameDBconn.execute(sql)
                         sql="delete from tb_outcome_log where parent_no="&no
                         GameDBconn.execute(sql)
                          if status = "N" then
                         sql6="update users set user_money=user_money+"&outcome_amt&" where user_id='"&take_id&"'"
                         GameDBconn.execute(sql6)     
                         end if
                end select 
            'end if      
    else
        GameDBconn.RollbackTrans
        response.end
    end if
    set rs4 = nothing          
    
    GameDBconn.Execute(sql)		
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");history.back()</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""처리가 완료되었습니다."");document.location.href='bonsa_exchangelist.asp';</script>"
    end if
    closeGameDB    
%>