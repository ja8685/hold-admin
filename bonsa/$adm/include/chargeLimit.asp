<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/login/login_check.asp" -->
<%
	''################################################
	''	File Name : chargeLimit.asp
	''	Summary   : ��ǥ����Ʈ
	''################################################

	connectionDB("PNC")

	strSQL = "SELECT F_TOTALMONEY,F_CHPERCENT FROM AX_STOREMONEY WHERE F_STORECODE = '" & SES_CODE & "'"
	Rs.Open strSQL, DBconn, adOpenForwardOnly, adLockReadOnly

	If Rs.EOF Or Rs.BOF Then
		limitMoney = 0
		changeRatio = 0
	Else
		limitMoney = Rs("F_TOTALMONEY")
		changeRatio = Rs("F_CHPERCENT")
	End If

	Rs.Close

	closeDB
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td height="23"></td>
  </tr>
  <tr>
	<td height="1" bgcolor="8c615a"></td>
  </tr>
  <tr>
	<td height="26" bgcolor="f7efef" style="font-size:12px; padding: 0 0 0 10 ; COLOR: #af1212;"><b>�������ɱݾ� : <%=FormatNumber(limitMoney,0,,0)%> ��&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;ȯ�������� : <%=changeRatio%>%</b></td>
  </tr>
  <tr>
	<td height="2" bgcolor="ffffff"></td>
  </tr>
  <tr>
	<td height="1" bgcolor="8c615a"></td>
  </tr>
  <tr>
	<td height="25"></td>
  </tr>
</table>