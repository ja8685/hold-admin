<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
no=checkvalue(1,trim(request("no")))
connectionGameDB("PNC")

  GameDBconn.BeginTrans
        sql = "delete from tb_qna where repl_cnt='Y' and repl_date is not null"
        GameDBconn.Execute(sql)		
        
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""삭제가 완료되었습니다."");parent.document.location.href='qna_list.asp'</script>"
    end if
    closeGameDB        
%>