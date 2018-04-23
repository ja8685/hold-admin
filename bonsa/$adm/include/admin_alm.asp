<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<%
'관리자 알람 설정
'------------------------------------------------------------------
  
dim ret_alm      
connectionGameDB("PNC")
szql = "select count(a.idx) from tb_deposit a with(nolock)  inner join users b with(nolock)  on a.send_id=b.user_id where a.status = 'N'"
    
Set Rs1 = GameDBconn.Execute(szql)
If Rs1(0)>0 then
	ret_alm = Rs1(0)
else
    ret_alm = 0
End if
Rs1.Close
Set Rs1= nothing
RecordCount = 0
'------------------------------------------------------------------
szql = "SELECT count(a.idx) FROM tb_outcome a with(nolock)  inner join users b with(nolock)  on a.take_id=b.user_id where a.status= 'N'"
Set Rs1 = GameDBconn.Execute(szql)
	ret_alm = ret_alm & "|"& Rs1(0)
    
Set Rs1 = nothing
szql = "SELECT count(a.idx) FROM tb_qna a with(nolock)  inner join users b with(nolock)  on a.user_id=b.user_id  where repl_cnt <> 'Y'"
Set Rs1 = GameDBconn.Execute(szql)
	ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = nothing

szql = "SELECT isnull(count(number),0) FROM users with(nolock)  where user_ring=1 "
Set Rs1 = GameDBconn.Execute(szql)
    ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = nothing
 
'블랙리스트
szql = "select isnull(count(c.midx),0) from connectedusers a inner join users b on a.user_id=b.user_id inner join TB_User_Blacklist c on b.number=c.midx where b.user_black_list>0"
'Set Rs1 = GameDBconn.Execute(szql)
'ret_alm = ret_alm & "|"& Rs1(0)
ret_alm = ret_alm & "|0"
Set Rs1 = nothing
    
if hour(now())<13 then

else

end if

'오늘날짜 strDateNow
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
szql = "select count(number) from users with(nolock)  where user_distributor15_link <> 228"
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing

'오늘회원가입 intMemberNowCnt
szql = "select count(number) from users with(nolock)  where user_distributor15_link <> 228 and "&now_jungsandate("user_regdate")
'CONVERT(varchar(10),user_regdate,120) = CONVERT(varchar(10),GETDATE(),120) "
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing

'접속중인회원 intConnectCnt
szql = "select count(A.user_id) from connectedusers A with(nolock) , users B with(nolock)  where A.user_id = B.user_id"
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing
'szql = "select count(A.user_id) from connectedusers A with(nolock) , users B with(nolock)  where A.user_id = B.user_id and B.user_distributor15_link <> 본사"
'Set Rs1 = GameDBconn.Execute(szql)
'ret_alm = ret_alm & "|"& Rs1(0)
'Set Rs1 = Nothing

 
'오늘 충전금액 intDepositSum
szql = "select isnull(sum(A.outcome_amt),0) from tb_deposit_log A with(nolock) , v_member_list01 B where A.take_id = B.user_id and B.jisa_id <> '마스터' and A.status='Y' and "&now_jungsandate("A.approval_date") 
'CONVERT(varchar(10),A.request_date,120) = CONVERT(varchar(10),GETDATE(),120)"
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing

'오늘 환전금액 intOutcomeSum
szql = "select isnull(sum(A.outcome_amt),0) from tb_outcome_log A with(nolock) , v_member_list01 B where A.take_id = B.user_id and B.jisa_id <> '마스터' and A.status='Y' and "&now_jungsandate("A.approval_date") 
'CONVERT(varchar(10),A.request_date,120) = CONVERT(varchar(10),GETDATE(),120)"
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing
 


'유저보유머니합계 (마스터제외) intUserMoneySum
szql = "select isnull(sum(user_money),0)+isnull(sum(user_save),0) from users with(nolock)  where user_distributor15_link <> 228"
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing
 
'유저보유골드합계_1 (마스터제외) intDealMoneySum = intDealMoneySum_1 + intDealMoneySum_2 + intDealMoneySum_3
szql = "select sum(a.deal_money)+sum(b.deal_money)+sum(c.deal_money) from distributor3 a with(nolock) inner join distributor2 b with(nolock) on a.distribute2_link=b.number"
szql = szql&" inner join distributor15 c with(nolock) on b.distribute15_link=c.number where c.user_id<>'마스터'"
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing

'유저보유골드합계_2 
szql = "select isnull(sum(jisa_amt),0) from ("
szql = szql&" select isnull(sum(deal_money),0) as jisa_amt from distributor15 with(nolock) where number<>228"
szql = szql&" union all"
szql = szql&" select isnull(sum(deal_money),0) as jisa_amt from distributor2 with(nolock) where distribute15_link<>228"
szql = szql&" union all"
szql = szql&" select isnull(sum(deal_money),0) as jisa_amt from distributor3 with(nolock) where distribute15_link<>228) a"
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing

'유저보유골드합계_3 
szql = "select isnull(sum(deal_money),0) from distributor3 with(nolock)  where distribute15_link <> 228"
Set Rs1 = GameDBconn.Execute(szql)
ret_alm = ret_alm & "|"& Rs1(0)
Set Rs1 = Nothing



closeGameDB
response.Write ret_alm
%>
