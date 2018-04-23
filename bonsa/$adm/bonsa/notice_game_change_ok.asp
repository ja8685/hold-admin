<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
notice_txt=checkvalue(1,trim(request.Form("notice_txt")))

connectionGameDB("PNC")
GameDBconn.BeginTrans
    sql = "select game_type from noticeMSG where game_type='baduki'"
    set rs2 = GameDBconn.Execute(sql)		
    if not rs2.eof then
    sql = "update noticeMSG set msg='"&notice_txt&"' where game_type='baduki'"
    else
    sql = "insert into noticeMSG (game_type,msg) values('baduki','"&notice_txt&"')"
    end if    
    GameDBconn.Execute(sql)		
    
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""공지사항 등록이 완료되었습니다."");parent.document.location.href='notice_list_game.asp'</script>"
    end if
    closeGameDB        
%>