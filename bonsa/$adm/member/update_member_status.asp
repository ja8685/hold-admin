<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
str=checkvalue(1,trim(request("str")))
game_id=checkvalue(1,trim(request("game_id")))
no=checkvalue(1,trim(request("no")))
connectionGameDB("PNC")
    GameDBconn.BeginTrans

    if str = 0 then  '--일반
        if game_id <> "" then
        'sql = "update users set user_black_list=0 where user_id = '" & game_id & "'"
        sql = "update users set user_black_list=0 where number = " & no
        GameDBconn.Execute(sql)
        end if        
    elseif str = 1 then '-- 블랙
		if game_id <> "" then
        'sql = "update users set user_black_list=1 where user_id = '" & game_id & "'"
        sql = "update users set user_black_list=1 where number = " & no
        GameDBconn.Execute(sql)
        end if        
    elseif str = 3 then '-- 화이트
        if game_id <> "" then
        'sql = "update users set user_black_list=3 where user_id = '" & game_id & "'"
        sql = "update users set user_black_list=3 where number = " & no
        GameDBconn.Execute(sql)
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