<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/include/md5.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
if request("str")="" then
reg_desc=checkvalue(1,trim(request("reg_desc")))
str=checkvalue(1,trim(request("request_number")))
else
no=trim(request("no"))
str_status=trim(request("str"))
end if
connectionGameDB("PNC")

    GameDBconn.BeginTrans
if str_status="" then    
    sql="select idx from TB_User_BlackList where midx="&str    
    cnt_black = cstr(Replace(GetString_List(sql),RowDel,""))
    if len(cnt_black)>0 then
    sql = "update TB_User_BlackList set blacklist='Y',ring_yn='Y' where midx = " & str    
    else
    sql = "insert into TB_User_BlackList (midx,blacklist,reg_date,reg_desc,ring_yn) values ("&str&",'Y',getdate(),'"&reg_desc&"','Y')"
    end if
    GameDBconn.Execute(sql)
else
      if str_status="1" then
        str_status="N"
        sql = "update TB_User_BlackList set blacklist='N',del_date=getdate() where midx = " & no    
         GameDBconn.Execute(sql)
      elseif str_status="0" then
        str_status="Y"
        sql = "update TB_User_BlackList set blacklist='Y',reg_date=getdate(),ring_yn='Y' where midx = " & no    
         GameDBconn.Execute(sql)
      elseif str_status="2" then        
        sql = "delete from  TB_User_BlackList where midx = " & no    
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