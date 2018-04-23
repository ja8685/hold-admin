<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<link href="/$adm/css/admin.css" rel="stylesheet" type="text/css">
<object id="MPlayer" name="MPlayer" classid="clsid:22D6F312-B0F6-11D0-94AB-0080C74C7E95" codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=6,4,7,1112" width=0 height=0 border=0 style="left:0px;top:0px;border-width:0; border-color:#000000; border-style:solid;" type=application/x-oleobject>
<!-- 디폴트 동영상의 URL을 삽입한다/-->
<param name="filename"  value="">
<param name="AutoStart" value="1">
<param name="AnimationAtStart" value="1">
<param name="EnableContextMenu" value="false">
<param name="EnablePositionControls" value="-1">
<param name="EnableFullScreenControls" value="0">
<param name="Mute" value="0">
<param name="ShowCaptioning" value="0">
<param name="ShowControls" value="1">
<param name="ShowAudioControls" value="1">
<param name="ShowDisplay" value="0">
<param name="ShowGotoBar" value="0">
<param name="ShowPositionControls" value="-1">
<param name="ShowStatusBar" value="1">
<param name="ShowTracker" value="-1">
<param name="Volume" value="100">
<param name="SendMouseClickEvents" value="-1">
</object>
<script language="javascript">
    function nextWin()
    { location = "/$adm/alm.asp" }
    setTimeout("nextWin();", 20000);
    function playing_charge() {
        document.MPlayer.filename = "/trumpet.wav";
        document.MPlayer.Play();

    }
    function playing_outcome() {
        document.MPlayer.filename = "/dog01.wav";
        document.MPlayer.Play();

    }
    function playing_qna() {
        document.MPlayer.filename = "/ringout.wav";
        document.MPlayer.Play();
    }
    function playing_register() {
        document.MPlayer.filename = "/ringout.wav";
        document.MPlayer.Play();
    }
    function playing_blacklist() {
        document.MPlayer.filename = "/xylofun.wav";
        document.MPlayer.Play();
    }
</script>
<%
'관리자 알람 설정
'------------------------------------------------------------------
    
connectionGameDB("007games")
    
szql = "select count(a.idx) from tb_deposit a inner join users b on a.send_id=b.user_id where a.status = 'N'"
    
Set Rs1 = GameDBconn.Execute(szql)
If Rs1(0)>0 then
	sound_charge = Rs1(0)
End if
Rs1.Close
Set Rs1= nothing
RecordCount = 0
'------------------------------------------------------------------
szql = "SELECT count(a.idx) FROM tb_outcome a inner join users b on a.take_id=b.user_id where a.status= 'N'"
Set Rs1 = GameDBconn.Execute(szql)
If Rs1(0)>0 then
	sound_outcome = Rs1(0)
End if
Set Rs1 = nothing
szql = "SELECT count(a.idx) FROM tb_qna a inner join users b on a.user_id=b.user_id  where repl_cnt <> 'Y'"
Set Rs1 = GameDBconn.Execute(szql)
If Rs1(0)>0 then
	sound_qna = Rs1(0)
End if
Set Rs1 = nothing

szql = "SELECT count(number) FROM users where user_ring=1 "
Set Rs1 = GameDBconn.Execute(szql)
If Rs1(0)>0 then
	sound_register = Rs1(0)
End if
Set Rs1 = nothing


'szql="select b.user_id from connectedusers a inner join users b on a.user_id=b.user_id "
'szql=szql&" inner join TB_User_Blacklist c on b.number=c.midx where a.black_list='O' "
'Set Rs1 = GameDBconn.Execute(szql)
'if not Rs1.eof then
 '   do until Rs1.eof
  '  sql="update connectedusers set black_list='Y' where user_id='"&Rs1("user_id")&"'"    
 '   GameDBconn.Execute(sql)
   ' Rs1.movenext
  '  loop
'end if
'    Set Rs1 = nothing
'szql = "select count(c.midx) from connectedusers a inner join users b on a.user_id=b.user_id inner join TB_User_Blacklist c on b.number=c.midx where a.black_list='Y'"
'Set Rs1 = GameDBconn.Execute(szql)
'If Rs1(0)>0 then
'	sound_blacklist = Rs1(0)
'End if
'Set Rs1 = nothing

'오늘날짜 strDateNow
szql = "select CONVERT(varchar(10),GETDATE(),120)"
Set Rs1 = GameDBconn.Execute(szql)
strDateNow = Rs1(0)
Set Rs1 = Nothing

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

stime = "13"
ltime = hour(now())

if cint(hour(now()))>-1 and cint(hour(now()))<13 then
e_ndate = dateadd("d",-1,now())
syear1 = year(e_ndate)
smon1 = month(e_ndate)
sday1 = day(e_ndate)
else
syear1 = year(now())
smon1 = month(now())
sday1 = day(now())
end if
sdate = syear1 & "-" & putZero(smon1) & "-" & putZero(sday1) & " " & putZero(stime) & ":00:00"

e_ndate = now()
eyear1 = year(e_ndate)
emon1 = month(e_ndate)
eday1 = day(e_ndate)
ldate = eyear1 & "-" & putZero(emon1) & "-" & putZero(eday1) &" " & putZero(ltime) & ":59:59"

'response.write e_ndate & "<br>"
'response.write sdate & "<br>"
'response.write ldate & "<br>"
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'전체회원 intMemberCnt
szql = "select count(number) from users where user_distributor15_link <> 145"
Set Rs1 = GameDBconn.Execute(szql)
intMemberCnt = Rs1(0)
Set Rs1 = Nothing

'오늘회원가입 intMemberNowCnt
szql = "select count(number) from users where user_distributor15_link <> 12 and user_regdate between '" & sdate & "' and '" & ldate & "' "
'CONVERT(varchar(10),user_regdate,120) = CONVERT(varchar(10),GETDATE(),120) "
Set Rs1 = GameDBconn.Execute(szql)
intMemberNowCnt = Rs1(0)
Set Rs1 = Nothing

'접속중인회원 intConnectCnt
szql = "select count(A.user_id) from connectedusers A, users B where A.user_id = B.user_id"
Set Rs1 = GameDBconn.Execute(szql)
inttotConnectCnt = Rs1(0)
Set Rs1 = Nothing
szql = "select count(A.user_id) from connectedusers A, users B where A.user_id = B.user_id and B.user_distributor15_link <> 145"
Set Rs1 = GameDBconn.Execute(szql)
intConnectCnt = Rs1(0)
Set Rs1 = Nothing

 
'오늘 충전금액 intDepositSum
szql = "select isnull(sum(A.deposit_amt),0) from TB_Deposit A, v_member_list01 B where A.send_id = B.user_id and B.jisa_id <> '마스터' and A.request_date between '" & sdate & "' and '" & ldate & "' "
'CONVERT(varchar(10),A.request_date,120) = CONVERT(varchar(10),GETDATE(),120)"
Set Rs1 = GameDBconn.Execute(szql)
intDepositSum= Rs1(0)
Set Rs1 = Nothing

'오늘 환전금액 intOutcomeSum
szql = "select isnull(sum(A.outcome_amt),0) from TB_outcome A, v_member_list01 B where A.take_id = B.user_id and B.jisa_id <> '마스터' and A.request_date between '" & sdate & "' and '" & ldate & "' "
'CONVERT(varchar(10),A.request_date,120) = CONVERT(varchar(10),GETDATE(),120)"
Set Rs1 = GameDBconn.Execute(szql)
intOutcomeSum = Rs1(0)
Set Rs1 = Nothing
 
'유저보유머니합계 (마스터제외) intUserMoneySum
szql = "select isnull(sum(user_money),0)+isnull(sum(user_save),0) from users where user_distributor15_link <> 145"
Set Rs1 = GameDBconn.Execute(szql)
intUserMoneySum= Rs1(0)
Set Rs1 = Nothing
 
'유저보유골드합계_1 (마스터제외) intDealMoneySum = intDealMoneySum_1 + intDealMoneySum_2 + intDealMoneySum_3
szql = "select isnull(sum(deal_money),0) from distributor15 where number <> 145"
Set Rs1 = GameDBconn.Execute(szql)
intDealMoneySum_1 = Rs1(0)
Set Rs1 = Nothing

'유저보유골드합계_2 
szql = "select isnull(sum(deal_money),0) from distributor2 where distribute15_link <> 145"
Set Rs1 = GameDBconn.Execute(szql)
intDealMoneySum_2 = Rs1(0)
Set Rs1 = Nothing

'유저보유골드합계_3 
szql = "select isnull(sum(deal_money),0) from distributor3 where distribute15_link <> 145"
Set Rs1 = GameDBconn.Execute(szql)
intDealMoneySum_3 = Rs1(0)
Set Rs1 = Nothing


closeGameDB()

%><!--script>      alert(<%=cint(qna_cnt)%>);</script-->
<%If sound_charge >0 Then%>
충전 신청 : <a href="/$adm/charge/bonsa_chargelist.asp" target="content"><b><font color="red"><%=sound_charge%></font></b></a>건
<script language="javascript">

    playing_charge();

</script>
<br />
<%end if
If sound_outcome >0 Then%>
환전 신청 : <font color="red"><a href="/$adm/charge/bonsa_exchangelist.asp" target="content"><b><font color="red"><%=sound_outcome%></font></b></a></font>건
<script language="javascript">

    playing_outcome();

</script>
<br />
<%End if%>
<%If sound_qna >0 Then%>
1:1 문의 : <a href="/$adm/bonsa/qna_list.asp" target="content"><b><font color="red"><%=sound_qna%></font></b></a>건
<script language="javascript">

    playing_qna();

</script>
<br />
<%end if%>
<%If sound_register >0 Then%>
회원가입 : <a href="/$adm/member/memberlist.asp" target="content"><b><font color="red"><%=sound_register%></font></b></a>건
<script language="javascript">

    playing_register();

</script>
<br />
<br />
<%end if%>
<%If sound_blacklist >0 Then%>
블랙리스트 : <a href="/$adm/member/UserBlackList.asp" target="content"><b><font color="red"><%=sound_blacklist%></font></b></a>건
<script language="javascript">

    playing_blacklist();

</script>
<br />
<br />
<%end if%>
<%
'Response.Write "오늘날짜 : " & strDateNow & "<br>"
'Response.Write "기준 : " & sdate & " ~ " & ldate & "<br><br>"


Response.Write "[[ " & Left(sdate,10) & " ]]<br>"
Response.Write "전체회원 : " & FormatNumber(intMemberCnt,0) & " 명<br>"
Response.Write "오늘회원가입 : " & FormatNumber(intMemberNowCnt,0) & " 명<br>"
Response.Write "접속중인회원 : " & FormatNumber(inttotConnectCnt,0)&"("&FormatNumber(intConnectCnt,0) & ") 명 <br>"
Response.Write "충전 : " & FormatNumber(intDepositSum,0) & " 원<br>"
Response.Write "환전 : " & FormatNumber(intOutcomeSum,0) & " 원<br>"
Response.Write "손익 : " & FormatNumber(CDbl(CDbl(intDepositSum)-CDbl(intOutcomeSum)),0) & " 원<br>"
Response.Write "유저 : " & FormatNumber(intUserMoneySum,0) & " 원<br>"
Response.Write "영업 : " & FormatNumber(CDbl(intDealMoneySum_1)+CDbl(intDealMoneySum_2)+CDbl(intDealMoneySum_3),0) & " 원<br>"
%>