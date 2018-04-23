<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%on error resume next
keyfield = Request("keyfield")
keyword = trim(Request("keyword"))
page_size = Request("page_size")
page = Request("page")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if page = "" then
	page = 1
else 
	page = cint(page)
end if
connectionGameDB("PNC")

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size

move_url = "connect_userlist.asp?" & parameters

if keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " like '%"& keyword &"%'"
end if

sql="select count(a.user_id) from connectedusers a with(nolock) inner join users b with(nolock)  on a.user_id=b.user_id "
sql=sql&" inner join distributor1 c with(nolock)  on b.user_distributor1_link=c.number where a.user_id <> ''"&searchSQL
RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))

sql="select isnull(count(a.user_id),0) from connectedusers a with(nolock)  inner join users b with(nolock)  on a.user_id=b.user_id "
sql=sql&" inner join distributor1 c with(nolock) on b.user_distributor1_link=c.number inner join distributor15 d with(nolock) "
sql=sql&" on b.user_distributor15_link=d.number where b.user_distributor15_link not in (228) and a.user_id <> ''"&searchSQL
    
real_RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))
    
'1페이지당 리스트 개수
if page_size = "" then page_size = 200000
PageSize = page_size

'총 페이지수
PageCount = int((RecordCount-1)/PageSize) + 1

strShopList = ""

sql="select c.user_id, d.user_id,  e.user_id,f.user_id, COUNT(f.user_id) from connectedusers a with(nolock)  "
sql=sql&" inner join users b with(nolock)  on a.user_id=b.user_id  "
sql=sql&" inner join distributor1 c with(nolock)  on b.user_distributor1_link=c.number  "
sql=sql&" inner join distributor15 d with(nolock)  on b.user_distributor15_link=d.number "
sql=sql&" inner join distributor2 e with(nolock)  on b.user_distributor2_link=e.number "
sql=sql&" inner join distributor3 f with(nolock)  on b.user_distributor3_link=f.number "
sql=sql&" where b.user_distributor15_link =12 and a.user_id <> ''"
sql=sql&" group by d.user_id, c.user_id, e.user_id,f.user_id "
    
shop_RegList = GetString_List(sql)
	
	shop_Rows = split(shop_RegList,RowDel)
	For i = 0 to UBound(shop_Rows)-1
		shop_Cols = split(shop_Rows(i),ColDel)    
		shop_name	= shop_Cols(3)  '매장명
		shop_cnt	= shop_Cols(4)  '매장Cnt

		If i = 0 Then
			strShopList = shop_name & " <b>" & shop_cnt & "</b>명" 
		Else
			strShopList = strShopList & "<font color='#ff0000'>,</font>  " & shop_name & "  <b>" & shop_cnt & "</b>명" 
		End If
	Next
sql="select COUNT(isnull(number,0)) from users b with(nolock)  inner join ConnectedUsers c with(nolock)  on b.user_id=c.user_id where user_distributor3_link=746"                
south_sea = cdbl(Replace(GetString_List(sql),RowDel,""))  
sql="select COUNT(isnull(number,0)) from users b with(nolock)  inner join ConnectedUsers c with(nolock)  on b.user_id=c.user_id where user_distributor3_link=747"                
west_sea = cdbl(Replace(GetString_List(sql),RowDel,""))  
sql="select COUNT(isnull(number,0)) from users b with(nolock)  inner join ConnectedUsers c with(nolock)  on b.user_id=c.user_id where user_distributor3_link=748"                
east_sea = cdbl(Replace(GetString_List(sql),RowDel,""))  
sql="select COUNT(isnull(number,0)) from users b with(nolock)  inner join ConnectedUsers c with(nolock)  on b.user_id=c.user_id where user_distributor3_link=781"                
north_sea = cdbl(Replace(GetString_List(sql),RowDel,""))  
sql="select distribute1_rate from distribute1" 
tot_deal_rate = cdbl(replace(GetString_List(sql),RowDel,""))                                    
 %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function goWrite() {
        document.frm1.submit();
    }

    function goEdit(IDX) {
        document.location.href = "regHead.asp?proc=edit&f_idx=" + IDX + "&<%=parameters%>";
    }

    function goDel(IDX) {
        if (confirm("부본사를 삭제하시면 해당 본사 및 하위 매장에 대한 관련 정보들이 모두 삭제가 됩니다.\n\n정말로 삭제하시겠습니까?")) {
            document.frm.f_idx.value = IDX;
            document.all.ALERT_MSG.style.display = "block";
            document.frm.PWD.focus();
            //pFrame.location.href = "regHeadProc.asp?proc=del&f_idx=" + IDX + "&<%=parameters%>";
        }
    }

    function goDailyCharge() {
        if (confirm("부본사에 기준머니를 일괄 지급하시겠습니까?")) {
            pFrame.location.href = "DailyHeadMoneyCharge.asp";
        }
    }
    function update_st(no, st, game_id) {
        var str = st;
        if (str == 0) {
            if (confirm("상태를 일반으로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_member_status.asp?str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 1) {
            if (confirm("상태를 블랙으로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_member_status.asp?str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 2) {
            if (confirm("매장을 화이트로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_member_status.asp?str=" + st + "&game_id=" + game_id;
            }
        }
    }

    function nextWin()
    { location = "/$adm/member/connect_userlist.asp" }
    setTimeout("nextWin();", 60000);
    //-->
</SCRIPT>
  <body class="nav-md">
<iframe name="pFrame" style="width:0px;height:0px;display:none"></iframe>
    <div class="container body">
      <div class="main_container">
        <div class="col-md-3 left_col">
          <div class="left_col scroll-view">
            <!-- HOME 로고 -->
            <!-- #include virtual="/$adm/include/home.asp" -->
            <!-- HOME 로고 끝 -->
            <div class="clearfix"></div>

            <!-- 어드민 프로필 -->
            <!-- #include virtual="/$adm/include/admin_profile.asp" -->
            <!-- 어드민 프로필 끝 -->

            <br />

            <!-- 왼쪽 메뉴 -->
            <!-- #include virtual="/$adm/include/left_menu.asp" -->
            <!-- 왼쪽 메뉴 끝 -->

            <!-- 푸터 버튼 파일 -->
            <!-- #include virtual="/$adm/include/footer_button.asp" -->
            <!-- 푸터 버튼 파일 끝 -->
          </div>
        </div>

        <!-- 탑 메뉴 -->
        <!-- #include virtual="/$adm/include/top_menu.asp" -->
        <!-- 탑 메뉴 끝 -->

        <!-- 메인 컨텐츠 -->
        <div class="right_col" role="main">
        <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h3>접속자 목록</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <div class="row">
                        <table>
                            <tr>                            
                                <th style="padding-left:20px;"></th>
	                            <th style="padding-right:200px;text-align:center"><b>현재 접속자 수 : 
                                    <font color="red"><%=recordcount%></font>명(<font color="blue"><%=real_RecordCount %></font>명)</b>
                                    &nbsp;<b>chn <%=south_sea%> 명&nbsp;  phi&nbsp;<%=west_sea%> 명&nbsp;  kor <%=east_sea%>명&nbsp;  usa <%=north_sea%>명</b> <%=strShopList%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                            </tr>
                        </table>
                    </div>        
                    <table id="member_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>                         
                        <tr class="alert alert-info alert-dismissible fade in">
                            <th style="text-align:center" height="25"><b>게임종류</b></th>
                            <th style="text-align:center" height="25"><b>현재위치</b></th>
                            <th style="text-align:center" height="25"><b>엔티</b></th>
                            <th style="text-align:center" height="25"><b>본사ID</b></th>
	                        <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>매장ID</b></th>
                            <th style="text-align:center" height="25"><b>회원ID</b></th>
                            <th style="text-align:center" height="25"><b>닉네임</b></th>
                            <th style="text-align:center" height="25"><b>등급</b></th>
                            <th style="text-align:center" height="25"><b>충전</b></th>
                            <th style="text-align:center" height="25"><b>환전</b></th>
                            <th style="text-align:center" height="25"><b>게임머니</b></th>
                            <th style="text-align:center" height="25"><b>보유머니</b></th>
                            <th style="text-align:center" height="25"><b>포인트</b></th>
                            <th style="text-align:center" height="25"><b>합계</b></th>
                            <th style="text-align:center" height="25"><b>유저별손익</b></th>      
                            <th style="text-align:center" height="25"><b>베팅액</b></th>
                            <th style="text-align:center" height="25"><b>딜비</b></th>
                            <th style="text-align:center" height="25"><b>운영본사</b></th>
                            <th style="text-align:center" height="25"><b>본사</b></th>
                            <th style="text-align:center" height="25"><b>총판</b></th>
                            <th style="text-align:center" height="25"><b>매장</b></th>
                            <th style="text-align:center" height="25"><b>블랙리스트</b></th>	      
                            <th style="text-align:center" height="25"><b>접속 유지시간 </b></th>
                            <!--th style="text-align:center" height="25"><b>게임수</b></th>
                            <th style="text-align:center" height="25"><b>승리</b></th>
                            <th style="text-align:center" height="25"><b>패배</b></th-->
                            <th style="text-align:center" height="25"><b>유저IP</b></th>
                            <th style="text-align:center" height="25"><b>접속시간</b></th>  
                        </tr>
                      </thead>
                      <tbody>
                    <%
                        
 	                    if RecordCount = 0 then
                     %>
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td align="center" height="29" colspan="26"><b>현재 접속한 유저가 없습니다.</b></td>
                        </tr>
                      <%else 

                        'sql="   select top "&PageSize& " a.*,user_black_list,b.user_degree,isnull(c.distribute3_rate,0) as distribute3_rate from connectedusers a with(nolock) "
                        'sql=sql&" inner join users b with(nolock)  on a.user_id=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number" 
                        'sql=sql&" where a.user_id not in(select top "&int((page-1)*PageSize)&" a.user_id from connectedusers a with(nolock) "
                        'sql=sql&" inner join users b with(nolock)  on a.user_id=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number " 
                        'sql=sql&" where a.user_id <> '' order by connect_time desc) and a.user_id <> '' order by a.status"
    
                        sql="   select top "&PageSize& " a.*,user_black_list,b.user_degree,isnull(c.distribute3_rate,0) as "
                        sql=sql&"distribute3_rate,isnull(d.distribute2_rate,0) as distribute2_rate ,isnull(e.distribute15_rate,0) as"
                        sql=sql&"distribute15_rate ,isnull(f.distribute1_rate,0) as distribute1_rate,overlap_ip.user_ip as overlap_ip"
                        sql=sql&",overlap_id.user_id as overlap_id"
                        sql=sql&" from connectedusers a with(nolock)"
                        sql=sql&" inner join users b with(nolock) on a.user_id=b.user_id inner join distributor3 c with(nolock) on "
                        sql=sql&" b.user_distributor3_link=c.number inner join distributor2 d with(nolock) on b.user_distributor2_link=d.number"
                        sql=sql&" inner join distributor15 e with(nolock) on b.user_distributor15_link=e.number inner join distributor1 f "
                        sql=sql&" with(nolock) on b.user_distributor1_link=f.number"
                        sql=sql&" left outer join (select left(user_ip,len(user_ip)-4) as user_ip from connectedusers with(nolock)  group by left(user_ip,len(user_ip)-4) having COUNT(left(user_ip,len(user_ip)-4))>1) overlap_ip on left(a.user_ip,len(a.user_ip)-4)=overlap_ip.user_ip"
                        sql=sql&" left outer join (select user_id from connectedusers group by user_id having COUNT(user_id)>1) overlap_id on a.user_id=overlap_id.user_id"
                        sql=sql&" where a.user_id not in(select top "&int((page-1)*PageSize)&" a.user_id from"
                        sql=sql&" connectedusers a with(nolock) inner join users b with(nolock) on a.user_id=b.user_id inner join distributor3"
                        sql=sql&" c with(nolock)  on b.user_distributor3_link=c.number where a.user_id <> '' order by connect_time desc) and a.user_id <> '' order by a.status "
      
                        RegList = GetString_List(sql)    
                        Record_String = RegList  
    	
	                        Rows = split(RegList,RowDel)
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)    
                                if i > 0 and conn_state2 <> Cols(4) then
                                %>
                                <tr bgcolor="#E1D1BD">
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>
                                    <td height="2"></td>                                    
                                    <td height="2"></td>
                                    <td height="2"></td>    
                                </tr>
                                <%
                                end if
                                gametype       = Cols(3)  
                                if gametype="baduki" then
                                    gametype="홀덤"
                                else
                                    gametype="맞고"
                                end if
                                conn_state2       = Cols(4) 
                                user_black_list = Cols(7) 
                                if user_black_list=0 then
                                    user_black_list="<font color=""black"">일반</font>"
                                elseif user_black_list=1 then
                                    user_black_list="<font color=""red"">블랙</font>"
                                elseif user_black_list=3 then
                                    user_black_list="<font color=""blue"">화이트</font>"
                                end if                 
                                no          = Cols(0)
                                boss_name = "patriot"
                                root_name = "master"
                                user_id   = trim(Cols(0))

                                user_degree = Cols(8) 

                                    sql="select top 1 deposit_name from TB_Deposit with(nolock)  where send_id='"&user_id&"' order by request_date desc"                        
                                deposit_name  = cstr(Replace(GetString_List(sql),RowDel,""))      
                                if user_id <> "" then
                                    sql=" select user_nick,a.shop_id,a.chongpan_id,a.jisa_id,a.bonsa_id,user_money as user_money,user_save as user_save,user_avata from v_member_list01 a"
                                    sql=sql&" inner join users b with(nolock) on a.user_id=b.user_id where b.user_id='"&user_id&"'"
                                    RecordCount = split(replace(GetString_List(sql),RowDel,""),ColDel)
                                    if isarray(RecordCount) = true then
                                        user_nick = RecordCount(0)
                                        shop_id = RecordCount(1)
                                        chongpan_id = RecordCount(2)
                                        jisa_id = RecordCount(3)
                                        bonsa_id = RecordCount(4)         
                                        user_money = cdbl(RecordCount(5))         
                                        user_save  = cdbl(RecordCount(6))         
                                        user_avata = RecordCount(7)      
                
                                        sql="select ISNULL(sum(betting_amt),0) from deal_money_ins_log with(nolock) where user_id='"&user_id&"'" 
                                         if cint(hour(now())) < 10 then     
                                            e_ndate = dateadd("d",-1,now())
                                            eyear1 = year(e_ndate)
                                            emon1 = month(e_ndate)
                                            eday1 = day(e_ndate)
                                            sdate = year(now()) & "-" & putZero(month(now())) & "-" & putZero(eday1) & " 13:00:00"  
                                            sql=sql&" and reg_date >'"&sdate&"'"                                        
                                        elseif cint(hour(now())) > 13 then     
                                            e_ndate = now()
                                            eyear1 = year(e_ndate)
                                            emon1 = month(e_ndate)
                                            eday1 = day(e_ndate)
                                            sdate = year(now()) & "-" & putZero(month(now())) & "-" & putZero(eday1) & " 13:00:00"  
                                            sql=sql&" and reg_date >'"&sdate&"'"                
                                        end if

                                        user_betting_amt = cdbl(replace(GetString_List(sql),RowDel,""))                                    
                                        if user_betting_amt<0 then
                                        user_betting_amt = -user_betting_amt 
                                        end if
                                        sql="select ISNULL(sum(deal_money),0) from deal_money_ins_log with(nolock) where user_id='"&user_id&"'" 
                                         if cint(hour(now())) < 10 then     
                                            e_ndate = dateadd("d",-1,now())
                                            eyear1 = year(e_ndate)
                                            emon1 = month(e_ndate)
                                            eday1 = day(e_ndate)
                                            sdate = year(now()) & "-" & putZero(month(now())) & "-" & putZero(eday1) & " 13:00:00"  
                                            sql=sql&" and reg_date >'"&sdate&"'"                                        
                                        elseif cint(hour(now())) > 13 then     
                                            e_ndate = now()
                                            eyear1 = year(e_ndate)
                                            emon1 = month(e_ndate)
                                            eday1 = day(e_ndate)
                                            sdate = year(now()) & "-" & putZero(month(now())) & "-" & putZero(eday1) & " 13:00:00"  
                                            sql=sql&" and reg_date >'"&sdate&"'"                
                                        end if
                                        user_deal_amt = cdbl(replace(GetString_List(sql),RowDel,""))                                    
                    
                                        distribute3_rate=Cols(9) 
                                        if distribute3_rate = "" then distribute3_rate=0
                                        distribute2_rate=Cols(10)-distribute3_rate
                    
                                        distribute15_rate=Cols(11)-(distribute2_rate+distribute3_rate)                                        
                                        distribute1_rate=Cols(12)-(distribute15_rate+distribute2_rate+distribute3_rate)
                                        distribute1_amt=fix((user_betting_amt)*distribute1_rate/100)
                                        jackpot_amt = 0
                                        distribute15_amt=fix((user_betting_amt)*distribute15_rate/100)
                                        distribute2_amt=fix((user_betting_amt)*distribute2_rate/100)
                                        distribute3_amt=fix((user_betting_amt)*distribute3_rate/100)    
                   
                                    end if
                                    '=========유저별 충환전 금액계산======================
                                     if cint(hour(now())) > 12 and cint(hour(now())) <24 then                        
                                            e_ndate = now()
                                            eyear1 = year(e_ndate)
                                            emon1 = month(e_ndate)
                                            eday1 = day(e_ndate)
                                            sdate = year(now()) & "-" & putZero(month(now())) & "-" & putZero(day(now())) & " 13:00:00"
                                            edate = "getdate()"
                                        elseif cint(hour(now())) > -1 and cint(hour(now())) <13 then                        
                                            e_ndate = dateadd("d",-1,now())
                                            eyear1 = year(e_ndate)
                                            emon1 = month(e_ndate)
                                            eday1 = day(e_ndate)
                                            sdate = eyear1 & "-" & putZero(emon1) & "-" & putZero(eday1) & " 13:00:00"
                                            edate = "getdate()"
                                        else
                                            sdate = "2011-01-01 13:00:00"
                                            edate = "2011-01-02 13:00:00"
                                        end if

                                    sql=" select isnull(sum(outcome_amt),0) as income_amt from tb_deposit_log with(nolock) where take_id='"&user_id&"'  and approval_date between '"&sdate&"' and "&edate&""
                                    income_amt = replace(GetString_List(sql),RowDel,"")
                                    sql=" select isnull(sum(outcome_amt),0) as outcome_amt from tb_outcome_log with(nolock) where take_id='"&user_id&"'  and approval_date between '"&sdate&"' and "&edate&""
                                    outcome_amt = replace(GetString_List(sql),RowDel,"")
                                    '=========유저별 충환전 금액계산 끝======================

                                    '==========유저별 게임수,승리,패 갯수==============================================================
                                    'if int(hour(now()))<24 and int(hour(now()))>16 then
                                    if int(hour(now()))<24 and int(hour(now()))>13 then
                                        sql="select SUM(win) as win,SUM(lose) as lose,SUM(win)+SUM(lose) as tot_game_cnt from ("
                                        sql=sql&" select COUNT(game_win) as win,0 as lose from badukigame_log with(nolock) "
                                        sql=sql&" where user_id='"&user_id&"' and game_win='승' and CONVERT(varchar(10),game_start_time,112)+CONVERT(varchar(2),datepart(hour,game_start_time)) "
                                        sql=sql&" >CONVERT(varchar(10),dateadd(day,0,GETDATE()),112)+'16' "
                                        sql=sql&" union all"
                                        sql=sql&" select 0 as win,COUNT(game_win) as lose from badukigame_log with(nolock) "
                                        sql=sql&" where user_id='"&user_id&"' and game_win='패' and CONVERT(varchar(10),game_start_time,112)+CONVERT(varchar(2),datepart(hour,game_start_time)) "
                                        sql=sql&" >CONVERT(varchar(10),dateadd(day,0,GETDATE()),112)+'16' ) a"
                                         'tot_game_cnt = split(replace(GetString_List(sql),RowDel,""),ColDel)
                                    else
                                        sql="select SUM(win) as win,SUM(lose) as lose,SUM(win)+SUM(lose) as tot_game_cnt from ("
                                        sql=sql&" select COUNT(game_win) as win,0 as lose from badukigame_log with(nolock) "
                                        sql=sql&" where user_id='"&user_id&"' and game_win='승' and CONVERT(varchar(10),game_start_time,112)+CONVERT(varchar(2),datepart(hour,game_start_time)) "
                                        sql=sql&" >CONVERT(varchar(10),dateadd(day,-1,GETDATE()),112)+'17' "
                                        sql=sql&" union all"
                                        sql=sql&" select 0 as win,COUNT(game_win) as lose from badukigame_log with(nolock) "
                                        sql=sql&" where user_id='"&user_id&"' and game_win='패' and CONVERT(varchar(10),game_start_time,112)+CONVERT(varchar(2),datepart(hour,game_start_time)) "
                                        sql=sql&" >CONVERT(varchar(10),dateadd(day,-1,GETDATE()),112)+'17' ) a"
                                         'tot_game_cnt = split(replace(GetString_List(sql),RowDel,""),ColDel)
                                    end if
                                    sql="select distinct user_win,user_lose,user_win+user_lose as tot_game from ConnectedUsers a with(nolock) left outer join UserGameInfo b with(nolock) on a.user_id=b.user_id where a.user_id='"&user_id&"' and game_name='holdem'"
                                    tot_game_cnt = split(replace(GetString_List(sql),RowDel,""),ColDel)
                                    if isarray(tot_game_cnt) = true then                    
                                        game_win_cnt = tot_game_cnt(0)
                                        game_lose_cnt = tot_game_cnt(1)
                                        tot_game = tot_game_cnt(2)
                                    else
                                        game_win_cnt = 0
                                        game_lose_cnt = 0
                                        tot_game = 0
                                    end if
                                    '==========유저별 게임수,승리,패 갯수 끝==============================================================
                                end if
                                if user_money = "" then
                                    user_money = 0
                                end if    
                                if user_save   = "" then
                                    user_save   = 0
                                end if    
                                tot_money = user_money+user_save 
                                'user_benefit =  cdbl(income_amt)-(cdbl(outcome_amt)+cdbl(user_money)) 
                                user_benefit =  cdbl(income_amt)-(cdbl(outcome_amt)+cdbl(tot_money))     
                                user_id = user_id
                                 sql="select COUNT(isnull(midx,0)) from TB_User_BlackList a with(nolock)  inner join users b with(nolock)  on a.midx=b.number inner join ConnectedUsers c with(nolock)  on b.user_id=c.user_id where blacklist='Y' and c.user_id='"&user_id&"'"                
                                connect_blacklist = cdbl(Replace(GetString_List(sql),RowDel,""))   
                                connect_time   = Cols(1)
                                user_ip       = Cols(2)
                                game_nm       = Cols(3)
                                conn_state       = Cols(4)  
                                'if conn_state>0 then
                                sql="select room_enti from RoomInfo with(nolock) where room_num="&conn_state-1&" and game_name='baduki'"                
                                'room_enti = cdbl(Replace(GetString_List(sql),RowDel,""))      
                                    room_enti = Cols(5) 
                                select case room_enti
                                        case 0
                                        room_enti = "<font color=""black"">200</font>방"
                                        case 1
                                        room_enti = "<font color=""black"">400</font>방"
                                        case 2
                                        room_enti = "<font color=""black"">1000</font>방"
                                        case 3
                                        room_enti = "<font color=""black"">2000</font>방"
                                        case 4
                                        room_enti = "<font color=""black"">4000</font>방"
                                        case 5
                                        room_enti = "<font color=""black"">6000</font>방"
                                        case 6
                                        room_enti = "<font color=""black"">10000</font>방"
                                        case 7
                                        room_enti = "<font color=""black"">20000</font>방"
                                        case else   
                                        room_enti = "<font color=""black"">로비</font>"
                                end select
                                'end if       
                                txt_room_num = conn_state
                                select case conn_state
                                        case 0                                        
                                        conn_state = "로비"                                        
                                        case else                    
                                        conn_state = conn_state&"번방"   
                                end select
                                if game_nm = "matgo" then
                                    game_nm = "맞고("&conn_state&")"
                                elseif game_nm = "holdem" then
                                    game_nm = "홀덤("&conn_state&")"
                                elseif game_nm = "baduki" then
                                    game_nm = "바둑이("&conn_state&")"
                                end if
            
                                connect_min = cdbl(datediff("n",cdate(connect_time),now()))
                                if connect_min > 60 then
                                    connect_min = formatnumber(connect_min/60,0)&"시간"& connect_min mod 60&"분"
                                else
                                    connect_min = connect_min&"분"
                                end if               
                                overlap_ip = Cols(13)
                                overlap_id = Cols(14) 
                                sql="select isnull(-money,0) from RoomEnterData with(nolock)  where user_id='"&user_id&"' and room_num="&cint(txt_room_num)-1
                                  
                                game_money  = cdbl(Replace(GetString_List(sql),RowDel,""))                      
                                       %>
                        <tr bgcolor="#FCF7ED" height="25"> 
                            <td align="center" height="25"><b><%=gametype%></b></td>        
                            <td align="center" height="25"><b><%=conn_state%></b></td> 
                            <td align="center" height="25"><b><%=room_enti%></b></td> 
                            <td align="center" height="25" <% IF jisa_id = "마스터" Then response.write "bgcolor='#eeeeee'" Else response.write "bgcolor='#ffef00'" End If %>><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><b><%=jisa_id%></b></font></td>
                            <td align="center" height="25" <% IF jisa_id = "마스터" Then response.write "bgcolor='#eeeeee'" Else response.write "bgcolor='#ffef00'" End If %>><font color="<%if cstr(user_avata) = "0" then%>red<%else%>blue<%end if%>"><b><%=chongpan_id%></b></font></td>
                            <td align="center" height="25" <% IF jisa_id = "마스터" Then response.write "bgcolor='#eeeeee'" Else response.write "bgcolor='#ffef00'" End If %>><font color="<%if cstr(user_avata) = "0" then%>blue<%else%>blue<%end if%>"><b><%=shop_id%></b></font></td>
                            <%if connect_blacklist > 0 then%>        
                            <td align="center" height="25" style="background-color:red" <% IF jisa_id = "마스터" Then response.write "bgcolor='#eeeeee'" Else response.write "bgcolor='#ffef00'" End If %>><b><%=user_id%></b></td>        
                            <%else%>
                            <td align="center" height="25" <% IF jisa_id = "마스터" Then response.write "bgcolor='#eeeeee'" Else response.write "bgcolor='#ffef00'" End If %>><b><%=user_id%></b></td>        
                            <%end if%>
        
                            <td align="center" height="25" <% IF jisa_id = "마스터" Then response.write "bgcolor='#eeeeee'" Else response.write "bgcolor='#ffef00'" End If %>><font color="red"><b><%=user_nick%></b></font></td>
                            <td align="center" height="25" <% IF jisa_id = "마스터" Then response.write "bgcolor='#eeeeee'" Else response.write "bgcolor='#ffef00'" End If %>><b><%=UserDegree(user_degree)%></b></td>        
                            <td align="right" height="25"><b><%=formatnumber(income_amt,0)%></b></td>    
                            <td align="right" height="25"><font color="red"><b><%=formatnumber(outcome_amt,0)%></b></font></td> 
                            <td align="right" height="25"><b><%=formatnumber(game_money,0)%></b></td>                             
                            <td align="right" height="25"><b><%=formatnumber(user_money,0)%></b></td>   
                            <td align="right" height="25"><b><%=formatnumber(user_save,0)%></b></td>   
                            <td align="right" height="25"><b><%=formatnumber(tot_money,0)%></b></td> 
	                    <%if user_benefit<0 then %>
                            <td align="right" height="25"><font color="red"><b><%=formatnumber(user_benefit,0)%></b></font></td>           
                            <%else %>
                            <td align="right" height="25"><b><%=formatnumber(user_benefit,0)%></b></td>           
                            <%end if %>  
                            <td align="right" height="25"><b><%=formatnumber(user_betting_amt,0)%></b></td>                 
                            <td align="right" height="25"><b><%=formatnumber(user_deal_amt,0)%></b></td>                         
                            <td align="right" height="25"><b><%=formatnumber(distribute1_amt,0)%><font color="blue">(<%=distribute1_rate%>%)</font></b></td>                 
                            <td align="right" height="25"><b><%=formatnumber(distribute15_amt,0)%><font color="blue">(<%=distribute15_rate%>%)</font></b></td>                 
                            <td align="right" height="25"><b><%=formatnumber(distribute2_amt,0)%><font color="blue">(<%=distribute2_rate%>%)</font></b></td>                 
                            <td align="right" height="25"><b><%=formatnumber(distribute3_amt,0)%><br /><font color="blue">(<%=distribute3_rate%>%)</font></b></td>                         
                             <td align="center"><b><%=user_black_list%></b></td>               
                            <td align="center" height="25"><b><%=connect_min%></b></td>                    
                            <!--td align="center" height="25"><b><%=formatnumber(tot_game,0)%></b></td>
                            <td align="center" height="25"><b><%=formatnumber(game_win_cnt,0)%></b></td>
                            <td align="center" height="25"><b><%=formatnumber(game_lose_cnt,0)%></b></td-->         
                            <%if overlap_ip<>"" then%>
                            <td align="center" style="background-color:red" height="25"><b><%=user_ip%></b></td>
                            <%else%>
                            <td align="center" height="25"><b><%=user_ip%></b></td>
                            <%end if%>
                            <td align="center" height="25"><b><%=connect_time%></b></td>        
                         <%
                            user_nick=""   
                            room_enti = ""     
                            game_money = 0
	                        Next        
     
                       end if
                       closeGameDB
                       %>      
                      </tbody>
                    </table>                             
                      <div class="row text-center">
                          <div class="col-xs-5">
                          </div>
                          <div class="col-xs-6">
                          </div>
                          <div class="col-xs-1">
                          </div>
                      </div>           	
                  </div>
                </div>
              </div>
        </div>
        </div>
        <!-- 메인 컨텐츠 끝 -->

        <!-- 푸터 파일 -->
        <!-- #include virtual="/$adm/include/footer.asp" -->
        <!-- 푸터 파일 끝 -->
      </div>
        <!-- Javascript 파일 -->
        <!-- #include virtual="/$adm/include/jQuery.asp" -->
        <!-- Javascript 파일 끝 -->
<script type="text/javascript">
    $(document).ready(function () {
        var oTable = $('#member_list_table').DataTable({
            "bPaginate": false,
            "bFilter": false,            
            "sort": false
        });
        
      // oTable.$('th:odd').css('backgroundColor', 'blue');
    })
</script>
  </body>
</html>
