<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
mode=checkvalue(1,trim(request("mode")))
a_idx=checkvalue(1,trim(request("a_idx")))
a_url=checkvalue(1,trim(request("a_url")))
a_accountname=checkvalue(1,trim(request("a_accountname")))
a_accountno=checkvalue(1,trim(request("a_accountno")))
a_depositname=checkvalue(1,trim(request.Form("a_depositname")))
connectionGameDB("PNC")

  GameDBconn.BeginTrans
if mode="insert" then
sql = "insert into TB_AccountInfo (url,  accountno,  accountname,depositname)"
sql = sql&" values ('"&a_url&"','"&a_accountno&"','"&a_accountname&"','"&a_depositname&"')" 
elseif mode="update" then
sql = "update TB_AccountInfo set url='"&a_url&"' ,accountno='"&a_accountno&"' ,accountname='"&a_accountname&"' ,depositname='"&a_depositname&"' where idx="&a_idx
elseif mode="del" then
sql = "delete from TB_AccountInfo where idx="&a_idx
end if
GameDBconn.Execute(sql)		       
    If GameDBconn.Errors.Count <> 0 Then         
        GameDBconn.RollbackTrans 
        response.Write "<script>alert(""오류가 발생하였습니다.\n잠시후 다시 시도해 주세요"");</script>"
    else
        GameDBconn.CommitTrans        
            response.Write "<script>alert(""충전계좌 등록이 완료되었습니다."");parent.document.location.href='/$adm/bonsa/accountNo_setting_domain.asp'</script>"        
    end if
    closeGameDB        
%>