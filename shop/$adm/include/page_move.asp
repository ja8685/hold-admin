<%
Function PageMove(LinkURL)
	Dim SplitPage, StartPage, EndPage
	'레코드가 있을때 처리
	if Record_String <> "" then
		SplitPage = 10
		StartPage = int((page-1)/SplitPage)*SplitPage + 1
		EndPage = StartPage + SplitPage - 1
		'EndPage = (int((page-1)/SplitPage)+1)*SplitPage
%>
<table cellspacing="0" cellpadding="0" border="0">
	<tr style="text-align:center"> 
<%			 
		'이전 n개 페이지
		if StartPage <> 1 then
%>
		<td width="21" align="left"><a href="<%=LinkURL%>&page=<%=StartPage-1%>"><img src="../Images/icon_c_ppre.gif" width="17" height="17" border="0" align="absmiddle"></a> </td>
<%
		else
%>
		<td width="21" align="left"><img src="../Images/icon_c_ppre.gif" width="17" height="17" border="0" align="absmiddle"> </td>
<%
		end if

		if page <> 1 Then 
%>
		<td width="45" align="left"><a href="<%=LinkURL%>&page=<%=page-1%>"><img src="../Images/icon_c_pre.gif" width="40" height="17" border="0" align="absmiddle"></a></td>
<%
		else
%>
		<td width="45" align="left"><img src="../Images/icon_c_pre.gif" width="40" height="17" border="0" align="absmiddle"></td>
<%
		end if
%>
		<td style="padding-top:2px;">
<%
		i = StartPage

		Do While i <= EndPage and i <= PageCount
			if i <> 1 then
%>
			<font size="-1" color="#E5E5E5">|</font>
<%
			else
%>
			&nbsp;
<%
			end if
            
			if cint(i) = cint(page) then
%>
				<a href="<%=LinkURL%>&page=<%=i%>"> <font color="#FF9600"><%=i%></font></a>
<%
			else
%>
				<a href="<%=LinkURL%>&page=<%=i%>"><%=i%></a>
<%
			end if
			i = i + 1
		Loop
%>
			&nbsp;
		</td>
<%
		'다음페이지 보기
		if page < PageCount Then 
%>
		<td width="45" align="right"><a href="<%=LinkURL%>&page=<%=page+1%>"><img src="../Images/icon_c_next.gif" width="40" height="17" border="0" align="absmiddle"></a></td>
<%
		else
%>
		<td width="45" align="right"><img src="../Images/icon_c_next.gif" width="40" height="17" border="0" align="absmiddle"></td>
<%
		end if

		'다음 n개 페이지
		if EndPage < PageCount then
%>
		<td width="21" align="right"><a href="<%=LinkURL%>&page=<%=EndPage+1%>"><img src="../Images/icon_c_nnext.gif" width="17" height="17" border="0" align="absmiddle"></a></td>
<%
		else
%>
		<td width="21" align="right"><img src="../Images/icon_c_nnext.gif" width="17" height="17" border="0" align="absmiddle"></td>
<%
		end if
%>
  </tr>
</table>
<%
	end if'레코드가 있을때 처리 끝
End Function
%>		
