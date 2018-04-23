<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
no=checkvalue(1,trim(request("no")))
str=checkvalue(1,trim(request("str")))
game_id=checkvalue(1,trim(request("game_id")))
connectionGameDB("PNC")
    GameDBconn.BeginTrans
    sql = "update distributor3 set status = "&str&" where number="&no    
    GameDBconn.Execute(sql)	
    if str = 1 then  '--홀드
    if game_id <> "" then
    sql = "update AX_GAMEUSERLIST set f_status='C' where F_GAMEID = '" & game_id & "'"	
    GameDBconn.Execute(sql)
    sql = "update users set user_state=1 where user_id = '" & game_id & "'"
    GameDBconn.Execute(sql)
    end if
    sql = "update users set user_state=1 where user_distributor3_link="&no&" and user_distributor2_link="&request.Cookies(admincheck)("adminNo")
    GameDBconn.Execute(sql)
    elseif str = 2 then '-- 삭제
        GameDBconn.RollbackTrans 
        response.end
            sql="select isnull(count(user_distributor3_link),0) from users where user_distributor3_link="&no
            tot_count_user = CDbl(Replace(GetString_List(sql),RowDel,""))         
            If tot_count_user > 0 Then         
                GameDBconn.RollbackTrans 
                response.Write "<script>alert(""소속 유저가 있는 관리자는 삭제하지 못합니다!"");</script>"
                closeGameDB
                response.end
            end if
        sql = "delete from AX_GAMEUSERLIST where F_GAMEID in (select user_id from users where user_distributor3_link="&no&")"	
        GameDBconn.Execute(sql)
        sql = "delete from common_game_log_detail where game_id in (select game_id from common_game_log where user_id in (select user_nick from users where user_distributor3_link="&no&"))"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from common_game_log where user_id in (select user_nick from users where user_distributor3_link="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from JackpotLog where user_id in (select user_id from users where user_distributor3_link="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from t_gold_del_charge_log where user_id in (select user_id from users where user_distributor3_link="&no&") and user_grade=4"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from TB_Deposit_log where take_id in (select user_id from users where user_distributor3_link="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from tb_outcome_log where take_id in (select user_id from users where user_distributor3_link="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from TB_QnA where user_id in (select user_id from users where user_distributor3_link="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from UserGameInfo where user_id in (select user_id from users where user_distributor3_link="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql="delete from users where user_distributor3_link="&no
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from t_gold_del_charge_log where (user_id in (select user_id from distributor3 where number="&no&") or send_id in (select user_id from distributor3 where number="&no&")) and (user_grade=3 or send_grade=3)"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from distributor3 where number="&no    
        GameDBconn.Execute(sql)	    
    else  '-- 정상
    if game_id <> "" then
    sql = "update AX_GAMEUSERLIST set f_status='Y' where F_GAMEID = '" & game_id & "'"	
    GameDBconn.Execute(sql)
    sql = "update users set user_state=0 where user_id = '" & game_id & "'"
    GameDBconn.Execute(sql)
    end if
    sql = "update users set user_state=0 where user_distributor3_link="&no&" and user_distributor2_link="&request.Cookies(admincheck)("adminNo")
    GameDBconn.Execute(sql)    
    end if
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""상태 변경이 완료되었습니다."");parent.document.location.reload();</script>"
    end if
    closeGameDB
    
%>