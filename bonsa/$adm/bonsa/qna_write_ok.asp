<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
no=checkvalue(1,trim(request.form("no")))
repl_contents=checkvalue(1,trim(request.form("repl_contents")))

connectionGameDB("PNC")

  GameDBconn.BeginTrans
        sql = "update tb_qna set repl_contents='"&repl_contents&"',  repl_cnt='Y',repl_date=getdate() where idx="&no
        GameDBconn.Execute(sql)		
        
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""답변 등록이 완료되었습니다."");parent.document.location.href='qna_list.asp'</script>"
    end if
    closeGameDB        
%>