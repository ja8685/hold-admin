<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
str=checkvalue(1,trim(request("str")))
no=checkvalue(1,trim(request("no")))
game_id=checkvalue(1,trim(request("game_id")))
connectionGameDB("PNC")
    GameDBconn.BeginTrans

    if str = 0 then  '--일반
        if no <> "" then
        sql = "update users set user_state=0 where number = " & no
        GameDBconn.Execute(sql)
        end if        
    elseif str = 1 then '-- 홀드
    if no <> "" then
        sql = "update users set user_state=1 where number = " & no
        GameDBconn.Execute(sql)
        end if        
    elseif str = 2 then '-- 삭제
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""회원 삭제기능은 이용하실 수 없습니다!"");</script>"
        response.end
        closeGameDB
        if no <> "" then
         sql = "delete from AX_GAMEUSERLIST where F_GAMEID in (select user_id from users where number="&no&")"	
        GameDBconn.Execute(sql)
        sql = "delete from common_game_log_detail where game_id in (select game_id from common_game_log where user_id in (select user_nick from users where number="&no&"))"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from common_game_log where user_id in (select user_nick from users where number="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from JackpotLog where user_id in (select user_id from users where number="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from t_gold_del_charge_log where user_id in (select user_id from users where number="&no&") and user_grade=4"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from TB_Deposit_log where take_id in (select user_id from users where number="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from tb_outcome_log where take_id in (select user_id from users where number="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from TB_QnA where user_id in (select user_id from users where number="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql = "delete from UserGameInfo where user_id in (select user_id from users where number="&no&")"
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경
        sql="delete from users where number="&no
        GameDBconn.Execute(sql) '-- 패트리어트 소속으로 변경  
        end if        
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