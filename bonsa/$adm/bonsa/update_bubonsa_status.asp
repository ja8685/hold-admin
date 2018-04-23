<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
	no		= checkvalue(1,trim(request("no")))
	str		= checkvalue(1,trim(request("str")))
	user_id	= checkvalue(1,trim(request("user_id")))

	connectionGameDB("PNC")

    GameDBconn.BeginTrans

    if str = 1 then  '--홀드
        sql = "update bubonsa set status=1 where user_id = '" & user_id & "'"
        GameDBconn.Execute(sql)
    elseif str = 2 then '-- 삭제 
        sql = "delete from bubonsa where user_id = '" & user_id & "'"
        GameDBconn.Execute(sql)
		
        sql = "delete from bubonsa_jisalist where bubonsa_id = '" & user_id & "'"
        GameDBconn.Execute(sql)

    else  '-- 정상
        sql = "update bubonsa set status=0 where user_id = '" & user_id & "'"
        GameDBconn.Execute(sql)    
    end If
    
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""상태 변경이 완료되었습니다."");parent.document.location.reload();</script>"
    end If
    
	closeGameDB
%>