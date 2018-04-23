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

    sql="select send_id,deposit_amt,status from TB_Deposit with(nolock) where idx="&no
    set rs4 = GameDBconn.execute(sql)
    if not rs4.eof then
        send_id = rs4("send_id")
        deposit_amt = cdbl(rs4("deposit_amt"))
        status = rs4("status")         
                select case gubun
                        case "Y"
                        sql = "select count(user_id) from connectedusers with(nolock) where user_id='"&send_id&"' and status<>'0'"
                        set rs1 = GameDBconn.execute(sql)
                        if cint(rs1(0)) = 0 then
                          
                            if status <> "Y" then
                                sql="select count(status) from tb_outcome_log where parent_no="&no
    
                                set rs2 = GameDBconn.execute(sql)                         
                                log_cnt = rs2(0)
                                set rs2 = nothing
                                'if log_cnt = 0 then
                                    sql="update TB_Deposit set status='Y',approval_date=getdate() where idx="&no
                                    GameDBconn.execute(sql)
                                    sql="update users set user_money=user_money+"&deposit_amt&" where user_id='"&send_id&"'"
                                    GameDBconn.execute(sql)   
                                    sql="     select c.user_id as bonsa_id,e.user_id as jisa_id,b.user_id as chongpan_id,a.user_id as shop_id,d.user_id,c.distribute1_rate,e.distribute15_rate,b.distribute2_rate ,a.distribute3_rate from distributor3 a inner join distributor2 b on a.distribute2_link=b.number"
                                    sql=sql&" inner join distributor15 e on a.distribute15_link=e.number inner join distributor1 c on a.distribute1_link=c.number inner join users d on a.number=user_distributor3_link where d.user_id='"&send_id&"'"            
                                    
                                    set rs2 = GameDBconn.execute(sql)
                                    if not rs2.eof then
                                        bonsa_id=trim(rs2("bonsa_id"))
                                        jisa_id=trim(rs2("jisa_id"))
                                        chongpan_id=trim(rs2("chongpan_id"))
                                        shop_id=trim(rs2("shop_id"))
                                        distribute1_rate=trim(rs2("distribute1_rate"))
                                        distribute15_rate=trim(rs2("distribute15_rate"))
                                        distribute2_rate=trim(rs2("distribute2_rate"))
                                        distribute3_rate=trim(rs2("distribute3_rate"))
                                        distribute1_amt=deposit_amt*(cdbl(trim(rs2("distribute1_rate")))-cdbl(trim(rs2("distribute15_rate"))))/100
                                        distribute15_amt=deposit_amt*(cdbl(trim(rs2("distribute15_rate")))-cdbl(trim(rs2("distribute2_rate"))))/100
                                        if chongpan_id <> "한1234" then
                                        distribute2_amt=deposit_amt*(cdbl(trim(rs2("distribute2_rate")))-cdbl(trim(rs2("distribute3_rate"))))/100
                                        else
                                        distribute2_amt=0
                                        end if
                                        distribute3_amt=deposit_amt*cdbl(trim(rs2("distribute3_rate")))/100
                                                                           
                                        sql21="insert into tb_Deposit_log (parent_no,take_id,outcome_amt,status,bonsa_id,jisa_id,chongpan_id,shop_id,bonsa_rate,jisa_rate,chongpan_rate,shop_rate,bonsa_commission,jisa_commission,chongpan_commission,shop_commission,approval_date)"
                                        sql21=sql21&" values ("&no&",'"&send_id&"',"&deposit_amt&",'Y','"&bonsa_id&"','"&jisa_id&"','"&chongpan_id&"','"&shop_id&"',"&distribute1_rate&","&distribute15_rate&","&distribute2_rate&","&distribute3_rate&","&distribute1_amt&","&distribute15_amt&","&distribute2_amt&","&distribute3_amt&",getdate())"
                                    else
                                        sql21="insert into tb_Deposit_log (parent_no,take_id,outcome_amt,status,bonsa_id,jisa_id,chongpan_id,shop_id,bonsa_rate,jisa_rate,chongpan_rate,shop_rate,bonsa_commission,jisa_commission,chongpan_commission,shop_commission,approval_date)"
                                        sql21=sql21&" values ("&no&",'"&send_id&"',"&deposit_amt&",'Y','','','','',0,0,0,0,0,0,0,0,getdate())"
                                    end if
                                    GameDBconn.execute(sql21)
                                    sql23123="update JackpotManager set parent_money=parent_money+("&deposit_amt&"*1/100)"
                                    GameDBconn.execute(sql23123)
                                    sql="update distributor1 set deal_money=deal_money-"&deposit_amt&" where user_id='"&request.Cookies(admincheck)("adminID")&"'"
                                    GameDBconn.execute(sql)   
                                'end if
                            end if    
                        else
                            GameDBconn.RollbackTrans
                            response.Write "<script>alert(""게임중인 회원은 충전을 할 수 없습니다!\n잠시후 다시 시도해 주세요"");history.back();</script>"
                            response.end
                        end if      
                        set rs1 = nothing              
                        case "C"
                            if status <> "C" then
                                 sql="update TB_Deposit set status='C',approval_date=getdate() where idx="&no
                                 GameDBconn.execute(sql)
                                 'sql="update users set user_money=user_money-"&deposit_amt&" where user_id='"&send_id&"'"
                                 'GameDBconn.execute(sql)                            
                                 sql="update distributor1 set deal_money=deal_money+"&deposit_amt&" where user_id='"&request.Cookies(admincheck)("adminID")&"'"
                                 'GameDBconn.execute(sql)   
                             end if
                        case "D"
                        if status <> "Y" then
                             sql="delete from TB_Deposit where idx="&no&" and status <> 'Y'"
                             GameDBconn.execute(sql) 
                             sql="delete from tb_Deposit_log where parent_no="&no
                             GameDBconn.execute(sql)                        
                         end if
                end select             

    else
        GameDBconn.RollbackTrans
        response.end
    end if
    set rs4 = nothing          

    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");history.back()</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""처리가 완료되었습니다."");document.location.href='bonsa_chargelist.asp';</script>"
    end if
    closeGameDB    
%>