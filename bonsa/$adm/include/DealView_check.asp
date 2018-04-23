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

	'관리자 아이디/권한 체크
	if vBView = "N" then
		Response.Write "<script>alert('과부하로 인해 정해진 시간외에는 정산자료를 열람하실수 없습니다.\n\n정산시간에는 모두 연람가능합니다.');</script>"
		Response.Write "<script>location.href='/report/StoreGameConnect.asp';</script>"
	end If


%>