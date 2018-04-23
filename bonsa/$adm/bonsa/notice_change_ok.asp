<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
'gubun=Y&no
gubun=checkvalue(1,trim(request("gubun")))
no=checkvalue(1,trim(request("no")))
connectionGameDB("PNC")

  GameDBconn.BeginTrans
  if gubun <> "D" then
     sql = "update tb_notice set status='"&gubun&"' where idx="&no
  else
     sql = "delete from tb_notice where idx="&no
  end if
        GameDBconn.Execute(sql)		
        
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans
        response.Write "<script>document.location.href='notice_list.asp'</script>"
    end if
    closeGameDB        
%>