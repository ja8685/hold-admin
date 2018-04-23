<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%

keyfield = Request("keyfield")
keyword = trim(Request("keyword"))
if keyword <> "" then
    u_id = trim(Request("keyword"))
else
    u_id = Request("u_id")
end if
syear = Request("syear")
smonth = Request("smonth")
sday = Request("sday")
stime = Request("stime")
lyear = Request("lyear")
lmonth = Request("lmonth")
lday = Request("lday")
ltime = Request("ltime")
if stime = "" then stime = "13"
if ltime = "" then ltime = hour(now())

if Request("smonth") <> "" and Request("sday") <> "" then    
sdate = syear & "-" & putZero(smonth) & "-" & putZero(sday) & " " & putZero(stime) & ":00:00"
else
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
end if

if Request("lmonth") <> "" and Request("lday") <> "" then
ldate = lyear & "-" & putZero(lmonth) & "-" & putZero(lday)   & " " & putZero(ltime) & ":59:59"
else
'e_ndate = dateadd("d",1,now())
e_ndate = now()
eyear1 = year(e_ndate)
emon1 = month(e_ndate)
eday1 = day(e_ndate)
ldate = eyear1 & "-" & putZero(emon1) & "-" & putZero(eday1) &" " & putZero(ltime) & ":59:59"
end if
page_size = Request("page_size")
page = Request("page")
if page = "" then
	page = 1
else 
	page = cint(page)
end if
connectionGameDB("PNC")
adminno = Request("adminno")
adminID = Request("adminID")
if adminID = "" then
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
adminID = request.Cookies(admincheck)("adminID")
else
IDAuth = cint(adminno)
adminID = adminID
end if
s_jisa_id = request("s_jisa_id")
s_chongpan_id = request("s_chongpan_id")
s_shop_id = request("s_shop_id")
if s_jisa_id <> "" then
searchshop = " and jisa_id='"&s_jisa_id&"'" 
end if
if s_chongpan_id <> "" then
searchshop = " and chongpan_id='"&s_chongpan_id&"'" 
end if
if s_shop_id <> "" then
searchshop = searchshop&" and shop_id='"&s_shop_id&"'"  
end if
parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id& "&adminno="&adminno&"&adminID="&adminID

move_url = "boss_deal_paylist.asp?" & parameters

if keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " = '"& keyword &"'"
end if
'1페이지당 리스트 개수

IDAuth = 0
     sql = "select a.chongpan_id,sum(a.income_amt_save) as income_amt_save,sum(a.income_amt) as income_amt,sum(a.outcome_amt) as outcome_amt,sum(a.outcome_save_amt) as outcome_save_amt,sum(a.rest_amt) as rest_amt,sum(a.betting_amt) as betting_amt,sum(a.deal_use_money) as tot_deal_money,sum(a.bonsa_commission) as bonsa_commission,sum(a.chongpan_commission) as chongpan_commission "
    sql = sql&", sum(a.shop_commission) as shop_commission "
	'sql = sql&", (select b.user_id from dbo.distributor2 c , distributor15 b where c.user_id=a.chongpan_id and c.distribute15_link = b.number ) as jisa_id "
	sql = sql&" from ( "
    sql = sql&" select chongpan_id,shop_id,0 as income_amt_save,sum(outcome_amt) as income_amt,0 as outcome_amt,0 as outcome_save_amt,0 as rest_amt,0 as betting_amt,0 as deal_use_money,sum(bonsa_commission) as bonsa_commission,sum(chongpan_commission) as chongpan_commission,sum(shop_commission) as shop_commission,approval_date,status from tb_deposit_log where 1=1"
    'sql = sql&searchshop
    sql = sql&" group by jisa_id,chongpan_id,shop_id,approval_date,status having jisa_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ") and status='Y' and shop_id<>'' and approval_date between '"&sdate&"' and '"&ldate&"' "
    sql = sql&" union all "
    sql = sql&" select chongpan_id,shop_id,0 as income_amt_save,0 as income_amt,sum(outcome_amt) as outcome_amt,0 as outcome_save_amt,0 as rest_amt,0 as betting_amt,0 as deal_use_money,0 as bonsa_commission,0 as chongpan_commission,0 as shop_commission,approval_date,status from tb_outcome_log  where 1=1"
    'sql = sql&searchshop
    sql = sql&" group by jisa_id,chongpan_id,shop_id,approval_date,status having jisa_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ")  and status='Y' and shop_id<>'' and approval_date between '"&sdate&"' and '"&ldate&"' "
    sql = sql&" union all "
    sql = sql&" select chongpan_id,shop_id,0 as income_amt_save,0 as income_amt,0 as outcome_amt,0 as outcome_save_amt,0 as rest_amt,sum(betting_amt) as betting_amt ,SUM(deal_money) as tot_deal_money,0 as bonsa_commission,0 as "
    sql = sql&" chongpan_commission,0 as shop_commission,reg_date,'Y' as status from deal_money_ins_log where 1=1 "
    'sql = sql&searchshop
    sql = sql&" group by jisa_id,chongpan_id,shop_id,reg_date "
    sql = sql&" having jisa_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ")  and reg_date between '"&sdate&"' and '"&ldate&"'"
    sql = sql&" union all "
    sql = sql&" select d.user_id as chongpan_id,c.user_id as shop_id,sum(a.money) as income_amt_save,0 as incoume_amtt,0 as outcome_amt,0 as outcome_save_amt,sum(user_money) as rest_amt,0 as betting_amt,0 as deal_use_money"
    sql = sql&" ,0 as bonsa_commission,0 as chongpan_commision,0 as shop_commission,'Y' as status,'' as reg_date "
    sql = sql&" from GiftToLog a inner join users b on a.to_user=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number inner join distributor2 d on b.user_distributor2_link=d.number"
    sql = sql&" where a.money>0 and b.user_distributor15_link IN (" & request.Cookies(admincheck)("BubonJisaNo") & ")"
    sql = sql&" and a.date between '"&sdate&"' and '"&ldate&"' "
    'sql = sql&searchshop
    sql = sql&" group by c.user_id,d.user_id "
    sql = sql&" union all "
    sql = sql&" select d.user_id as chongpan_id,c.user_id as shop_id,0 as income_amt_save,0 as incoume_amtt,0 as outcome_amt,-sum(a.money) as outcome_save_amt,0 as rest_amt,0 as betting_amt,0 as deal_use_money"
    sql = sql&" ,0 as bonsa_commission,0 as chongpan_commision,0 as shop_commission,'Y' as status,'' as reg_date "
    sql = sql&" from GiftToLog a inner join users b on a.to_user=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number inner join distributor2 d on b.user_distributor2_link=d.number"
    sql = sql&" where a.money<0 and b.user_distributor15_link IN (" & request.Cookies(admincheck)("BubonJisaNo") & ")"
    sql = sql&" and a.date between '"&sdate&"' and '"&ldate&"' "
    'sql = sql&searchshop
    sql = sql&" group by c.user_id,d.user_id "
    sql = sql&" union all "
    sql = sql&" select d.user_id as chongpan_id,c.user_id as shop_id,0 as income_amt_save,0 as incoume_amtt,0 as outcome_amt,-sum(a.money) as outcome_save_amt,sum(user_money) as rest_amt,0 as betting_amt,0 as deal_use_money"
    sql = sql&" ,0 as bonsa_commission,0 as chongpan_commision,0 as shop_commission,'Y' as status,'' as reg_date "
    sql = sql&" from GiftToLog a inner join users b on a.from_user=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number inner join distributor2 d on b.user_distributor2_link=d.number"
    sql = sql&" where a.money<0 and b.user_distributor15_link IN (" & request.Cookies(admincheck)("BubonJisaNo") & ")"
    sql = sql&" and a.date between '"&sdate&"' and '"&ldate&"' "
    'sql = sql&searchshop
    sql = sql&" group by c.user_id,d.user_id "   
    sql = sql&" union all "
    sql = sql&" select d.user_id as chongpan_id,c.user_id as shop_id,sum(a.money) as income_amt_save,0 as incoume_amtt,0 as outcome_amt,0 as outcome_save_amt,0 as rest_amt,0 as betting_amt,0 as deal_use_money"
    sql = sql&" ,0 as bonsa_commission,0 as chongpan_commision,0 as shop_commission,'Y' as status,'' as reg_date "
    sql = sql&" from GiftToLog a inner join users b on a.from_user=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number inner join distributor2 d on b.user_distributor2_link=d.number"
    sql = sql&" where a.money>0 and b.user_distributor15_link IN (" & request.Cookies(admincheck)("BubonJisaNo") & ")"
    sql = sql&" and a.date between '"&sdate&"' and '"&ldate&"' "
    'sql = sql&searchshop
    sql = sql&" group by c.user_id,d.user_id "   
    
    sql = sql&" ) a where 1=1 "&searchshop&" group by a.chongpan_id order by a.chongpan_id "
    'response.Write sql
    'response.end
    RegList2 = GetString_List(sql)
    Rows2 = split(RegList2,RowDel)
    RecordCount = UBound(Rows2)
    RegList = GetString_List(sql)
    Record_String = RegList 
    Rows = split(RegList,RowDel)
authtitle = "본사"
 

'총 페이지수
'PageCount = int((RecordCount-1)/PageSize) + 1
if page_size = "" then page_size = 200000
PageSize = RecordCount
page_size = RecordCount
PageCount =1
 %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function goWrite() {
        //document.location.href = "bonsalist.asp?keyfield=" + document.frm1.keyfield.options[document.frm1.keyfield.selectedIndex].value + "&keyword=" + document.frm1.keyword.value;
        if (document.frm1.syear.options[document.frm1.syear.selectedIndex].value != "" && (document.frm1.smonth.options[document.frm1.smonth.selectedIndex].value == "" || document.frm1.sday.options[document.frm1.sday.selectedIndex].value == "")) {
            alert("시작 년,월,일을 선택해 주세요");
            return;
        }
        if (document.frm1.smonth.options[document.frm1.smonth.selectedIndex].value != "" && (document.frm1.syear.options[document.frm1.syear.selectedIndex].value == "" || document.frm1.sday.options[document.frm1.sday.selectedIndex].value == "")) {
            alert("시작 년,월,일을 선택해 주세요");
            return;
        }
        if (document.frm1.sday.options[document.frm1.sday.selectedIndex].value != "" && (document.frm1.syear.options[document.frm1.syear.selectedIndex].value == "" || document.frm1.smonth.options[document.frm1.smonth.selectedIndex].value == "")) {
            alert("시작 년,월,일을 선택해 주세요");
            return;
        }
        if (document.frm1.syear.options[document.frm1.syear.selectedIndex].value != "" && (document.frm1.smonth.options[document.frm1.smonth.selectedIndex].value != "" && document.frm1.sday.options[document.frm1.sday.selectedIndex].value != "")) {
            if (document.frm1.lyear.options[document.frm1.lyear.selectedIndex].value == "" && (document.frm1.lmonth.options[document.frm1.lmonth.selectedIndex].value == "" && document.frm1.lday.options[document.frm1.lday.selectedIndex].value == "")) {
                alert("종료 년,월,일을 선택해 주세요");
                return;
            }
            if (document.frm1.lyear.options[document.frm1.lyear.selectedIndex].value != "" && (document.frm1.lmonth.options[document.frm1.lmonth.selectedIndex].value == "" || document.frm1.lday.options[document.frm1.lday.selectedIndex].value == "")) {
                alert("종료 년,월,일을 선택해 주세요");
                return;
            }
            if (document.frm1.lmonth.options[document.frm1.lmonth.selectedIndex].value != "" && (document.frm1.lyear.options[document.frm1.lyear.selectedIndex].value == "" || document.frm1.lday.options[document.frm1.lday.selectedIndex].value == "")) {
                alert("종료 년,월,일을 선택해 주세요");
                return;
            }
            if (document.frm1.lday.options[document.frm1.lday.selectedIndex].value != "" && (document.frm1.lyear.options[document.frm1.lyear.selectedIndex].value == "" || document.frm1.lmonth.options[document.frm1.lmonth.selectedIndex].value == "")) {
                alert("종료 년,월,일을 선택해 주세요");
                return;
            }
        }
        if (document.frm1.lyear.options[document.frm1.lyear.selectedIndex].value != "" && (document.frm1.lmonth.options[document.frm1.lmonth.selectedIndex].value == "" || document.frm1.lday.options[document.frm1.lday.selectedIndex].value == "")) {
            alert("종료 년,월,일을 선택해 주세요");
            return;
        }
        if (document.frm1.lmonth.options[document.frm1.lmonth.selectedIndex].value != "" && (document.frm1.lyear.options[document.frm1.lyear.selectedIndex].value == "" || document.frm1.lday.options[document.frm1.lday.selectedIndex].value == "")) {
            alert("종료 년,월,일을 선택해 주세요");
            return;
        }
        if (document.frm1.lday.options[document.frm1.lday.selectedIndex].value != "" && (document.frm1.lyear.options[document.frm1.lyear.selectedIndex].value == "" || document.frm1.lmonth.options[document.frm1.lmonth.selectedIndex].value == "")) {
            alert("종료 년,월,일을 선택해 주세요");
            return;
        }
        document.frm1.submit();
    }
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
                    <h3>정산 관리 - <%=adminID%>[<%=authtitle%>]</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <form name="frm1" method="post" action="?" class="form-horizontal">
                        <div class="row">
                            <div class="form-inline form-group">
                                <div class="col-sm-12 text-right">                                        
                                    <select class="select2_single form-control"  name="syear" onkeypress="if(event.keyCode == 13) javascript:goWrite();">
                                    <option value="">년도</option>
                                    <%for syear2 = year(date)-3 to year(date)+3%>
                                    <option value="<%=syear2%>"<%if Cstr(request("syear")) = Cstr(syear2) or Cstr(syear1) = Cstr(syear2) then%> selected<%end if%>><%=syear2%></option>
                                    <%next%>
                                </select>
                                &nbsp;년&nbsp; 
                                <select class="select2_single form-control"  name="smonth" onkeypress="if(event.keyCode == 13) javascript:goWrite();">
                                    <option value="">월</option>
                                    <%for smonth2 = 1 to 12%>
                                    <option value="<%=smonth2%>"<%if Cstr(request("smonth")) = Cstr(smonth2) or Cstr(smon1) = Cstr(smonth2)  then%> selected<%end if%>><%=smonth2%></option>
                                    <%next%>
                                </select>
                                &nbsp;월&nbsp; 
                                <select class="select2_single form-control"  name="sday" onkeypress="if(event.keyCode == 13) javascript:goWrite();">
                                    <option value="">일</option>
                                    <%for sday2 = 1 to 31%>
                                    <option value="<%=sday2%>"<%if Cstr(request("sday")) = Cstr(sday2) or Cstr(sday1) = Cstr(sday2)  then%> selected<%end if%>><%=sday2%></option>
                                    <%next%>
                                </select>
                                &nbsp;일 
                                <select class="select2_single form-control"  name="stime" onkeypress="if(event.keyCode == 13) javascript:goWrite();">                      
                                    <%for stime2 = 13 to 23%>
                                    <option value="<%=stime2%>"<%if Cstr(request("stime")) = Cstr(stime2) or Cstr(stime1) = Cstr(stime2)  then%> selected<%end if%>><%=stime2%></option>
                                    <%next%>
                                </select>
                                &nbsp;시 ~ 
                                <select class="select2_single form-control"  name="lyear" onkeypress="if(event.keyCode == 13) javascript:goWrite();">
                                    <option value="">년도</option>
                                    <%for lyear2 = year(date)-3 to year(date)+3%>
                                    <option value="<%=lyear2%>"<%if Cstr(request("lyear")) = Cstr(lyear2) or Cstr(eyear1) = Cstr(lyear2)  then%> selected<%end if%>><%=lyear2%></option>
                                    <%next%>
                                </select>
                                &nbsp;년&nbsp; 
                                <select class="select2_single form-control"  name="lmonth" onkeypress="if(event.keyCode == 13) javascript:goWrite();">
                                    <option value="">월</option>
                                    <%for lmonth2 = 1 to 12%>
                                    <option value="<%=lmonth2%>"<%if Cstr(request("lmonth")) = Cstr(lmonth2) or Cstr(emon1) = Cstr(lmonth2)   then%> selected<%end if%>><%=lmonth2%></option>
                                    <%next%>
                                </select>
                                &nbsp;월&nbsp; 
                                <select class="select2_single form-control"  name="lday" onkeypress="if(event.keyCode == 13) javascript:goWrite();">
                                    <option value="">일</option>
                                    <%for lday2 = 1 to 31%>
                                    <option value="<%=lday2%>"<%if Cstr(request("lday")) = Cstr(lday2) or Cstr(eday1) = Cstr(lday2)   then%> selected<%end if%>><%=lday2%></option>
                                    <%next%>
                                </select>일
                                <select class="select2_single form-control"  name="ltime" onkeypress="if(event.keyCode == 13) javascript:goWrite();">                      
                                    <%for ltime2 = 0 to 23%>
                                    <%if ltime <> "" then%>
                                    <option value="<%=ltime2%>"<%if Cint(ltime2) = Cint(ltime)  then%> selected<%end if%>><%=ltime2%></option>
                                    <%else %>
                                    <option value="<%=ltime2%>"<%if Cint(ltime2) = 9  then%> selected<%end if%>><%=ltime2%></option>
                                    <%end if %>
                                    <%next%>
                                </select>
                                &nbsp;시                                     

                                 &nbsp;&nbsp;총판:	
                                  <select class="select2_single form-control"  name="s_chongpan_id" onchange="document.frm1.submit()">
                                   <option value="">=선택=</option>
                                  <%
                                  sql="select distinct a.user_id from distributor2 a left outer join distributor15 b on a.distribute15_link=b.number where 1=1 and b.user_id is not null and b.user_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ")"                          
                                  'if s_chongpan_id <> "" then
                                  '  sql = sql&" and a.user_id='"&s_chongpan_id&"'"
                                  'end if
                      
                                   RegList2 = GetString_List(sql)
                                   Rows2 = split(RegList2,RowDel)
                                   %>
                                  <% 
                                      For ddi = 0 to UBound(Rows2)-1
                                     Cols = split(Rows2(ddi),ColDel)  
                                  %>
                                  <option value="<%=Cols(0)%>"<%if Cstr(request("s_chongpan_id")) = Cstr(Cols(0)) then%> selected<%end if%>><%=Cols(0)%></option>
                                  <%next%>
					            </select>&nbsp;&nbsp;매장 :
                                <select class="select2_single form-control"  name="s_shop_id" onchange="document.frm1.submit()">
                                   <option value="">=선택=</option>
                                  <%
                                  sql="select distinct c.user_id from distributor2 a , distributor15 b , distributor3 c where 1=1 and a.distribute15_link=b.number and a.number = c.distribute2_link and b.user_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ")"
                                 ' if s_chongpan_id <> "" then
                                 '   sql = sql&" and a.user_id='"&s_chongpan_id&"'"
                                 ' end if
                      
                                   RegList2 = GetString_List(sql)
                                   Rows2 = split(RegList2,RowDel)
                                   %>
                                  <% For eei = 0 to UBound(Rows2)-1
                                     Cols = split(Rows2(eei),ColDel)  
                                  %>
                                  <option value="<%=Cols(0)%>"<%if Cstr(request("s_shop_id")) = Cstr(Cols(0)) then%> selected<%end if%>><%=Cols(0)%></option>
                                  <%next%>
					            </select>
                                <input type=button name=headregist class="btn btn-info form-control" value=" 검색 " onClick="goWrite()" />


                                </div>
                            </div>
                        </div>                            
                     </form>
                    <table id="boss_deal_pay_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>번호</b></th>  
                            <th style="text-align:center" height="25"><b>총판ID</b></th>      
                            <th style="text-align:center" height="25"><b>충전금액</b></th>
                            <th style="text-align:center" height="25"><b>충전(선물)</b></th>
                            <th style="text-align:center" height="25"><b>환전금액</b></th>
                            <th style="text-align:center" height="25"><b>환전(선물)</b></th>
                            <th style="text-align:center" height="25"><b>베팅액</b></th>                
                            <th style="text-align:center" height="25"><b>딜비</b></th>                
                            <th style="text-align:center" height="25"><b>유저보유머니</b></th>                        
                            <th style="text-align:center" height="25"><b>잭팟금액</b></th>                        
                            <th style="text-align:center" height="25"><b>본사수익</b></th>          
                            <th style="text-align:center" height="25"><b>하위수익</b></th>                
                            <th style="text-align:center" height="25"><b>하위보기</b></th>   
                        </tr>
                      </thead>
                      <tbody>
                        <%
                            IDAuth = 0
   	                        if RecordCount = 0 then
                         %>
                            <script type="text/javascript">
                                $(document).ready(function () {
                                    $("#charge_td").attr("colspan", 14);

                                })
                            </script>
                            <tr bgcolor="#FCF7ED" height="25"> 
	                            <td id="charge_td" align="center" height="25"><b>등록된 매출내역이 없습니다.</b></td>
                            </tr>
                              <%else 
  
                                    cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                                    listnumber = RecordCount - cnumber    	
	                                For isdsd = 0 to UBound(Rows)-1
		                                Cols = split(Rows(isdsd),ColDel)      
                                        no       = listnumber
      
                                        if IDAuth = 0 then
                                             bonsa_id = Cols(0)
                                             charge_amt_save = cdbl(Cols(1))
                                             charge_amt = cdbl(Cols(2))
                                             sum_charge_amount = charge_amt                 
      
                                             exchange_amt = cdbl(Cols(3))
                                            exchange_amt_save = cdbl(Cols(4))
                                             betting_amt = cdbl(Cols(6))                 
                                            sql="select isnull(sum(user_money),0) from users a with(nolock) inner join distributor15 b on a.user_distributor15_link=b.number where b.user_id='"&Cols(1)&"'"            
                                            set rs3 = GameDBconn.execute(sql)
                                            if not rs3.eof then
                                                tot_user_money = trim(rs3(0))
                                            else
                                                tot_user_money = 0
                                            end if
                                            set rs3 = nothing
                                            sql="     select c.user_id as bonsa_id,d.user_id as jisa_id,b.user_id as chongpan_id,a.user_id as shop_id,'dd' as ddd,c.distribute1_rate,d.distribute15_rate "&vbCrLf
                                            sql=sql&" ,isnull(b.distribute2_rate,0) as distribute2_rate ,isnull(a.distribute3_rate,0) as distribute3_rate,d.deal_money"&vbCrLf
                                            sql=sql&" ,(select SUM(a.deal_money) from distributor2 a inner join distributor15 b on a.distribute15_link=b.number where a.user_id='"&Cols(0)&"') as dis2_sum"&vbCrLf
                                            sql=sql&",(select SUM(a.deal_money) from distributor3 a inner join distributor2 b on a.distribute2_link=b.number where b.user_id='"&Cols(0)&"') as dis3_sum,"&vbCrLf
                                            sql=sql&"  b.number as jisano from distributor3 a inner join distributor2 b on a.distribute2_link=b.number"&vbCrLf
                                            sql=sql&"  inner join distributor15 d on a.distribute15_link=d.number inner join distributor1 c on a.distribute1_link=c.number where b.user_id='"&Cols(0)&"'"&vbCrLf            
                
                                            set rs2 = GameDBconn.execute(sql)
                                            if not rs2.eof then
                                               ' bonsa_id=trim(rs2("bonsa_id"))
                                                jisa_id=trim(rs2("jisa_id"))
                                                chongpan_id=trim(rs2("chongpan_id"))
                                                shop_id=trim(rs2("shop_id"))
                                                jisa_notdealmoney = cdbl(trim(rs2("distribute15_rate")))+cdbl(trim(rs2("distribute2_rate")))  +cdbl(trim(rs2("distribute3_rate")))        
                                                distribute3_rate=trim(rs2("distribute3_rate"))
                                                if distribute3_rate = "" then distribute3_rate=0
                                                distribute2_rate=trim(rs2("distribute2_rate"))-distribute3_rate
                                                distribute15_rate=trim(rs2("distribute15_rate"))-(distribute2_rate+distribute3_rate)                                        
                                                distribute1_rate=trim(rs2("distribute1_rate"))-(distribute15_rate+distribute2_rate+distribute3_rate)
                                                below_rate = cdbl(distribute2_rate+distribute3_rate) ' 하위 수수료
                                                rest_amt = trim(rs2("deal_money"))  
                                                jisano = trim(rs2("jisano"))        
                                                distribute1_amt=(betting_amt)*distribute1_rate/100
                                                jackpot_amt = betting_amt*0.0/100
                                                distribute15_amt=(betting_amt)*distribute15_rate/100
                                                distribute2_amt=(betting_amt)*distribute2_rate/100
                                                distribute3_amt=(betting_amt)*distribute3_rate/100                    		    
                                                income_amt15=distribute15_amt
                                                income_amt2=distribute2_amt
                                                income_amt3=distribute3_amt
                                                below_amt = cdbl(income_amt2)+cdbl(income_amt3)'---하위수익 

                                                'income_amt=cdbl(Cols(5))-(income_amt2+income_amt3)
                                                income_amt=distribute1_amt
                                                tot_deal_money = rest_amt+cdbl(trim(rs2("dis2_sum")))+cdbl(trim(rs2("dis3_sum")))                    
                                            else
                                                tot_deal_money=0
                                            end if
                                            set rs2 = nothing
                
                                            'income_amt2 = cdbl(Cols(5))-cdbl(Cols(6)) 
                                            'income_amt3 = cdbl(Cols(6))                           
                                            'income_amt = cdbl(Cols(4)) -(cdbl(Cols(5))-cdbl(Cols(6)))                         
                                        end if
      
                                    tot_deal_money = cdbl(Cols(7))
      
                                    income_amt = fix(((tot_deal_money+betting_amt)*distribute15_rate)/100)
                                    below_amt = fix(((betting_amt)*below_rate)/100)
                  
                              %>
                                <tr bgcolor="#FCF7ED" height="25" style="font-weight: bold"> 
	                                <td align="center"><b><%=no%></b></td>
	                                <td align="center"><font color="<%if jisa_notdealmoney = 0 then%>blue<%else%>red<%end if%>"><%=bonsa_id%></font></td>
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(charge_amt,0)%></td>
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(charge_amt_save,0)%></td>
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(exchange_amt,0)%></td>        
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(exchange_amt_save,0)%></td>        
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(betting_amt,0)%></td>        
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(tot_deal_money,0)%></td>
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(tot_user_money,0)%></td>                
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(jackpot_amt ,0)%>&nbsp;<font color="blue">(<%="0.0"%>%)</font></td>        
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(income_amt,0)%>&nbsp;<font color="blue">(<%=distribute15_rate%>%)</font></td>        
                                    <td align="right" style="padding-right:20px"><%=FormatNumber(below_amt,0)%>&nbsp;<font color="blue">(<%=below_rate%>%)</font></td>
                                    <td align="right" style="padding-right:20px">
                                        <input type="button" value="하위보기" class="btn btn-info form-control" 
                                        onclick="document.location.href = 'below_jisa_deal_paylist.asp?keyfield=<%=keyfield%>&keyword=<%=keyword%>&adminno=<%=jisano%>&adminid=<%=chongpan_id%>&syear=<%=syear%>&smonth=<%=smonth%>&sday=<%=sday%>&stime=<%=stime%>&lyear=<%=lyear%>&lmonth=<%=lmonth%>&lday=<%=lday%>&ltime=<%=ltime%>&page_size=<%=page_size%>&page=<%=page%>'" /></td>                
                                </tr>
                                     <%         
                                     listnumber = listnumber-1
                                     if jisa_id <> "마스터" then
                                         real_sum_charge_save_amt=cdbl(real_sum_charge_save_amt+charge_amt_save)
                                         real_sum_charge_amt=cdbl(real_sum_charge_amt+charge_amt)
                                         real_tot_sum_charge_amount=real_tot_sum_charge_amount+real_sum_charge_amount
                                         real_sum_exchange_amt=real_sum_exchange_amt+cdbl(exchange_amt)                                   
                                         real_sum_exchange_save_amt=real_sum_exchange_save_amt+cdbl(exchange_amt_save)                                   
                                         real_sum_tot_deal_money=real_sum_tot_deal_money+cdbl(tot_deal_money)
                                         real_sum_tot_user_money=real_sum_tot_user_money+cdbl(tot_user_money)
                                         real_sum_rest_amt=real_sum_rest_amt+cdbl(rest_amt)
                                         real_sum_betting_amt=cdbl(real_sum_betting_amt+betting_amt)
                                         real_sum_income_amt=cdbl(real_sum_income_amt+income_amt)       
                                         real_sum_jackpot_amt =cdbl(real_sum_jackpot_amt)+cdbl(jackpot_amt)       
                                         real_sum_income_amt_save=cdbl(real_sum_income_amt)         
                                         real_sum_income_amt15=cdbl(real_sum_income_amt15+income_amt15)         
                                         real_sum_income_amt2=cdbl(real_sum_income_amt2+income_amt2)         
                                         real_sum_income_amt3=cdbl(real_sum_income_amt3+income_amt3)         
                                         real_sum_income_amt_below=cdbl(real_sum_income_amt_below+below_amt) '===하위 실제 수익합계             

                                     end if
                                     sum_charge_amt=cdbl(sum_charge_amt+charge_amt)
                                     sum_charge_amt_save=cdbl(sum_charge_amt_save+charge_amt_save)
                                     tot_sum_charge_amount=tot_sum_charge_amount+sum_charge_amount
                                     sum_exchange_amt=sum_exchange_amt+cdbl(exchange_amt)                                   
                                     sum_exchange_amt_save=sum_exchange_amt_save+cdbl(exchange_amt_save)                                   
                                     sum_tot_deal_money=sum_tot_deal_money+cdbl(tot_deal_money)
                                     sum_tot_user_money=sum_tot_user_money+cdbl(tot_user_money)         
                                     sum_rest_amt=sum_rest_amt+cdbl(rest_amt)
                                     sum_betting_amt=cdbl(sum_betting_amt+betting_amt)
                                     sum_income_amt=cdbl(sum_income_amt+income_amt)       
                                     sum_jackpot_amt =cdbl(sum_jackpot_amt)+cdbl(jackpot_amt)       
                                     sum_income_amt_save=cdbl(sum_income_amt)         
                                     if IDAuth = 1 then
                                     sum_income_amt15=cdbl(sum_income_amt15+income_amt15)         
                                     sum_income_amt2=cdbl(sum_income_amt2+income_amt2)         
                                     sum_income_amt3=cdbl(sum_income_amt3+income_amt3)     
                                     sum_income_amt_below=cdbl(sum_income_amt_below+below_amt) '=====하위 전체 수익                  
                                     elseif IDAuth = 2 then
                                     sum_income_amt2=cdbl(sum_income_amt2+income_amt2)         
                                     end if
                                         tot_user_money=0
                                         charge_amt=0
                                         exchange_amt=0             
                                         rest_amt=0
                                         tot_deal_money=0
                                         tot_user_money=0
                                         betting_amt=0
                                         income_amt=0
                                         jackpot_amt =0
                                         income_amt15=0
                                         income_amt2=0
                                         income_amt3=0
                                         below_amt = 0
	                                 distribute3_rate= 0
	                                 distribute2_rate=0
  	                                 distribute15_rate=0
	                                 distribute1_rate= 0
	                                 distribute1_rate= 0
                                     below_rate = 0
	                                Next
     
                               end if
                               closeGameDB
                               %>   
                                <tr bgcolor="#FCF7ED" height="25"> 
                                    <td align="center"><b>실제합계</b></td>	    
                                    <td align="center"><b>&nbsp;</b></td>	    
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_charge_amt,0)%></b></td>
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_charge_save_amt,0)%></b></td>
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_exchange_amt,0)%></b></td>        
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_exchange_save_amt,0)%></b></td>        
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_betting_amt,0)%></b></td>
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_tot_deal_money,0)%></b></td>                        
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_tot_user_money,0)%></b></td>        
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_jackpot_amt,0)%></b></td>        
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_income_amt,0)%></b></td>                
                                    <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_income_amt_below,0)%></b></td>        
                                    <td align="right" style="padding-right:20px;color:red">&nbsp;</td>        
                                </tr>

                      </tbody>
                    </table>                             
                      <div class="row text-center">
                          <div class="col-xs-5">
                          </div>
                          <div class="col-xs-6">
                          <!-- 페이지 이동 -->
		                    <%=PageMove(move_url)%>
		                    <!-- 페이지 이동 -->
                          </div>
                          <div class="col-xs-1">
                          </div>
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
        var oTable = $('#boss_deal_pay_list_table').DataTable({
            "bPaginate": false,
            "bFilter": false,            
            "sort": false
        });        
        //$("#tot_sum_td").attr("colspan", 2);        
        
    })
</script>
  </body>
</html>
