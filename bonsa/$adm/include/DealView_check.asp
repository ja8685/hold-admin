<%


	    connectionDB("PNC")

		strSQL = "SELECT F_BVIEW,F_MVIEW FROM AX_DEALVIEW"
		'Response.Write strSQL
		Rs.Open strSQL, DBconn, adOpenForwardOnly, adLockReadOnly
		if not Rs.EOF Then 
		   vBView = Rs("F_BView")
		   'vMView = Rs("F_MView")
		End If 
		Rs.close

		closeDB

	'������ ���̵�/���� üũ
	if vBView = "N" then
		Response.Write "<script>alert('�����Ϸ� ���� ������ �ð��ܿ��� �����ڷḦ �����ϽǼ� �����ϴ�.\n\n����ð����� ��� ���������մϴ�.');</script>"
		Response.Write "<script>location.href='/report/StoreGameConnect.asp';</script>"
	end If


%>