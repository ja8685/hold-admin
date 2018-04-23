<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%

title=checkvalue(1,trim(request("title")))
contents=checkvalue(1,trim(request("contents")))
state=checkvalue(1,trim(request("state")))

connectionGameDB("PNC")

  GameDBconn.BeginTrans
        sql = "insert into tb_notice (title,  contents,  status,  viewnum)"
        sql = sql&" values ('"&title&"','"&contents&"','"&state&"',0)" 
        GameDBconn.Execute(sql)		
        
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>alert(""공지사항 등록이 완료되었습니다."");parent.document.location.href='notice_list.asp'</script>"
    end if
    closeGameDB        
%>