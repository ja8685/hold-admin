<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
keyfield = Request("keyfield")
keyword = trim(Request("keyword"))
connectionGameDB("PNC")
searchSQL = searchSQL & " where " & keyfield & " = '"& keyword &"'"
Server.ScriptTimeOut=10000
Response.Expires = 0
Response.ContentType = "application/vnd.ms-excel"
	
Response.AddHeader "Content-Disposition", "attachment;filename=" & RandomVal(1000) & "_E.xls"

	sql=" select * from ("
sql=sql&" select *,ROW_NUMBER() OVER(ORDER BY user_date desc) AS 'RowNumber' from UserIPList b "&searchSQL&") a "

    RegList = GetString_List(sql)
    
    Record_String = RegList  
%>
<html>
<head><title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>    
<body>
<table border="0" cellpadding="3" cellspacing="1" bgcolor="F0E7DD" width="700">
    <tr> 
	    <td align="center" bgcolor="#E1D1BD" height="25" width="10%"><b>번호</b></td>
        <td align="center" bgcolor="#E1D1BD" height="25" width="20%"><b>유저ID</b></td>
	    <td align="center" bgcolor="#E1D1BD" height="25" width="20%"><b>닉네임</b></td>
        <td align="center" bgcolor="#E1D1BD" height="25" width="20%"><b>IP</b></td>
	    <td align="center" bgcolor="#E1D1BD" height="25" width="30%"><b>접속일자</b></td>        
	    </tr>
<%
   	if RegList = "" then
 %>
    <tr bgcolor="#FCF7ED" height="25"> 
	    <td align="center" height="25" colspan="5"><b>등록된 접속기록이 없습니다.</b></td>
    </tr>
  <%else 
    	
	    Rows = split(RegList,RowDel)
	    For i = 0 to UBound(Rows)-1
		    Cols = split(Rows(i),ColDel)      
            user_id= Cols(0)
            user_nick= Cols(1)
            user_ip= Cols(2)
            user_date= Cols(3)          
            RowNumber=Cols(4)
    %>
    <tr bgcolor="#FCF7ED" height="25"> 
	    <td align="center" height="25"><b><%=RowNumber%></b></td>
        <td align="center" height="25"><b><%=user_id%></b></td>
        <td align="center" height="25"><b><%=user_nick%></b></td>
	    <td align="center" height="25"><b><%=user_ip%></b></td>
        <td align="center" height="25"><b><%=user_date%></b></td>	    
    </tr>
         <%
        Next
     
   end if
   closeGameDB
   %>
</table>
</body>