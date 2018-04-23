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
if hour(now())<13 then
s_ndate = dateadd("d",-1,now())
else
s_ndate = now()
end if
syear1 = year(s_ndate)
smon1 = month(s_ndate)
sday1 = day(s_ndate)
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
if adminno = "" then
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
adminID = request.Cookies(admincheck)("adminID")
adminnum = request.Cookies(admincheck)("adminNo")
else
IDAuth = cint(adminno)
adminnum = cint(adminno)
adminID = adminID
end if
s_chongpan_id = request("s_chongpan_id")
s_shop_id = request("s_shop_id")
if s_chongpan_id <> "" then
searchshop = " and chongpan_id='"&s_chongpan_id&"'" 
end if
if s_shop_id <> "" then
searchshop = searchshop&" and shop_id='"&s_shop_id&"'"  
end if
parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear=" & eyear1 & "&l_month=" & emon1 & "&l_day=" & eday1 & "&page_size=" & page_size & "&u_id=" & u_id& "&adminno="&adminno&"&adminID="&adminID

move_url = "below_chongpan_deal_paylist.asp?" & parameters

if keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " = '"& keyword &"'"
end if
'1페이지당 리스트 개수

IDAuth = 2
if IDAuth = 1 then
    sql = "select bonsa_id,chongpan_id,shop_id,sum(income_amt) as income_amt,sum(income_amt_save) as income_amt_save,sum(outcome_amt) as outcome_amt,sum(bonsa_commission) as bonsa_commission,sum(chongpan_commission) as chongpan_commission "
    sql = sql&", sum(shop_commission) as shop_commission from ( "
    sql = sql&" select bonsa_id,chongpan_id,shop_id,0 as income_amt_save,sum(outcome_amt) as income_amt,0 as outcome_amt,sum(bonsa_commission) as bonsa_commission,sum(chongpan_commission) as chongpan_commission,sum(shop_commission) as shop_commission,approval_date,status from tb_deposit_log where 1=1"
    sql = sql&searchshop
    sql = sql&" group by bonsa_id,chongpan_id,shop_id,approval_date,status having bonsa_id='"&adminID&"' and status='Y' and chongpan_id<>'' and approval_date between '"&sdate&"' and '"&ldate&"' "
    sql = sql&" union all "
    sql = sql&" select bonsa_id,chongpan_id,shop_id,0 as income_amt,sum(outcome_amt) as outcome_amt,0 as bonsa_commission,0 as chongpan_commission,0 as shop_commission,approval_date,status from tb_outcome_log  where 1=1"
    sql = sql&searchshop
    sql = sql&" group by bonsa_id,chongpan_id,shop_id,approval_date,status having bonsa_id='"&adminID&"' and status='Y' and chongpan_id<>'' and approval_date between '"&sdate&"' and '"&ldate&"' "    
    sql = sql&" ) a group by bonsa_id,chongpan_id,shop_id order by bonsa_id,chongpan_id,shop_id "
    response.Write sql
    RegList2 = GetString_List(sql)
    Rows2 = split(RegList2,RowDel)
    RecordCount = UBound(Rows2)
    RegList = GetString_List(sql)
    Record_String = RegList 
    Rows = split(RegList,RowDel)
authtitle = "본사"
elseif IDAuth = 2 then
        sql = "select chongpan_id,shop_id,sum(income_amt_save) as income_amt_save,sum(income_amt) as income_amt,sum(outcome_amt) as outcome_amt,sum(outcome_save_amt) as outcome_save_amt,sum(rest_amt) as rest_amt,sum(betting_amt) as betting_amt,sum(deal_use_money) as deal_use_money,sum(bonsa_commission) as bonsa_commission,sum(chongpan_commission) as chongpan_commission "
    sql = sql&", sum(shop_commission) as shop_commission from ( "
    sql = sql&" select chongpan_id,shop_id,0 as income_amt_save,sum(outcome_amt) as income_amt,0 as outcome_amt,0 as outcome_save_amt,0 as rest_amt,0 as betting_amt,0 as deal_use_money,sum(bonsa_commission) as bonsa_commission,sum(chongpan_commission) as chongpan_commission,sum(shop_commission) as shop_commission,approval_date,status from tb_deposit_log where 1=1"
    'sql = sql&searchshop
    sql = sql&" group by chongpan_id,shop_id,approval_date,status having chongpan_id='"&adminID&"' and status='Y' and shop_id<>'' and approval_date between '"&sdate&"' and '"&ldate&"' "
    sql = sql&" union all "
    sql = sql&" select chongpan_id,shop_id,0 as income_amt_save,0 as income_amt,sum(outcome_amt) as outcome_amt,0 as outcome_save_amt,0 as rest_amt,0 as betting_amt,0 as deal_use_money,0 as bonsa_commission,0 as chongpan_commission,0 as shop_commission,approval_date,status from tb_outcome_log  where 1=1"
    'sql = sql&searchshop
    sql = sql&" group by chongpan_id,shop_id,approval_date,status having chongpan_id='"&adminID&"' and status='C' and shop_id<>'' and approval_date between '"&sdate&"' and '"&ldate&"' "
    sql = sql&" union all "
    sql = sql&" select chongpan_id,shop_id,0 as income_amt_save,0 as income_amt,0 as outcome_amt,0 as outcome_save_amt,0 as rest_amt,sum(betting_amt) as betting_amt ,sum(deal_money) as deal_use_money,0 as bonsa_commission,0 as "
    sql = sql&" chongpan_commission,0 as shop_commission,reg_date,'Y' as status from deal_money_ins_log where 1=1 "
    'sql = sql&searchshop
    sql = sql&" group by chongpan_id,shop_id,reg_date "
    sql = sql&" having chongpan_id='"&adminID&"' and reg_date between '"&sdate&"' and '"&ldate&"'"
    sql = sql&" union all "
    sql = sql&" select '"&adminID&"' as chongpan_id,c.user_id as shop_id,sum(a.money) as income_amt_save,0 as incoume_amt,0 as outcome_amt,0 as outcome_save_amt,sum(user_money) as rest_amt,0 as betting_amt,0 as deal_use_money"
    sql = sql&" ,0 as bonsa_commission,0 as chongpan_commision,0 as shop_commission,'Y' as status,'' as reg_date "
    sql = sql&" from GiftToLog a inner join users b on a.to_user=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number"
    sql = sql&" where a.money>0 and b.user_distributor2_link="&adminNum
    sql = sql&" and a.date between '"&sdate&"' and '"&ldate&"' "
    'sql = sql&searchshop
    sql = sql&" group by c.user_id "
    sql = sql&" union all "
    sql = sql&" select '"&adminID&"' as chongpan_id,c.user_id as shop_id,0 as income_amt_save,0 as incoume_amt,0 as outcome_amt,-sum(a.money) as outcome_save_amt,0 as rest_amt,0 as betting_amt,0 as deal_use_money"
    sql = sql&" ,0 as bonsa_commission,0 as chongpan_commision,0 as shop_commission,'Y' as status,'' as reg_date "
    sql = sql&" from GiftToLog a inner join users b on a.to_user=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number"
    sql = sql&" where a.money<0 and b.user_distributor2_link="&adminNum
    sql = sql&" and a.date between '"&sdate&"' and '"&ldate&"' "
    'sql = sql&searchshop
    sql = sql&" group by c.user_id "
    sql = sql&" union all "
    sql = sql&" select '"&adminID&"' as chongpan_id,c.user_id as shop_id,0 as income_amt_save,0 as incoume_amt,0 as outcome_amt,-sum(a.money) as outcome_save_amt,sum(user_money) as rest_amt,0 as betting_amt,0 as deal_use_money"
    sql = sql&" ,0 as bonsa_commission,0 as chongpan_commision,0 as shop_commission,'Y' as status,'' as reg_date "
    sql = sql&" from GiftToLog a inner join users b on a.from_user=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number"
    sql = sql&" where a.money<0 and b.user_distributor2_link="&adminNum
    sql = sql&" and a.date between '"&sdate&"' and '"&ldate&"' "
    'sql = sql&searchshop
    sql = sql&" group by c.user_id "
    sql = sql&" union all "
    sql = sql&" select '"&adminID&"' as chongpan_id,c.user_id as shop_id,sum(a.money) as income_amt_save,0 as incoume_amt,0 as outcome_amt,0 as outcome_save_amt,0 as rest_amt,0 as betting_amt,0 as deal_use_money"
    sql = sql&" ,0 as bonsa_commission,0 as chongpan_commision,0 as shop_commission,'Y' as status,'' as reg_date "
    sql = sql&" from GiftToLog a inner join users b on a.from_user=b.user_id inner join distributor3 c on b.user_distributor3_link=c.number"
    sql = sql&" where a.money>0 and b.user_distributor2_link="&adminNum
    sql = sql&" and a.date between '"&sdate&"' and '"&ldate&"' "
    'sql = sql&searchshop
    sql = sql&" group by c.user_id "
    'sql = sql&" union all "
    'sql = sql&" select chongpan_id,shop_id,sum(gold_amt) as income_amt_save,0 as income_amt,0 as outcome_amt,0 as betting_amt ,0 as deal_use_money,0 as bonsa_commission,0 as chongpan_commission,"
    'sql = sql&" 0 as shop_commission,a.reg_date , 'Y' as status from t_gold_del_charge_log a inner join v_member_list01 b on a.user_id=b.user_id where 1=1 "
    'sql = sql&" group by chongpan_id,shop_id,a.reg_date as approval_date,'Y' as status having chongpan_id='"&adminID&"' and a.reg_date between"
    'sql = sql&" '"&sdate&"' and '"&ldate&"'"
    sql = sql&" ) a where 1=1 "&searchshop&" group by chongpan_id,shop_id order by chongpan_id,shop_id "
    'response.Write sql
    'response.end
    RegList2 = GetString_List(sql)
    Rows2 = split(RegList2,RowDel)
    RecordCount = UBound(Rows2)
    
    RegList = GetString_List(sql)
    Record_String = RegList 
    Rows = split(RegList,RowDel)
	authtitle = "총판"
elseif IDAuth = 3 then
   'sql = "select shop_id,sum(outcome_amt) as outcome_amt,sum(bonsa_commission) as bonsa_commission,sum(chongpan_commission) as chongpan_commission "
    sql = "select shop_id,sum(outcome_amt) as outcome_amt,sum(chongpan_commission) as chongpan_commission "
    sql = sql&", sum(shop_commission) as shop_commission,convert(varchar(10),approval_date,120),status from ( "
    sql = sql&" select shop_id,sum(outcome_amt) as outcome_amt, sum(chongpan_commission) as chongpan_commission,sum(shop_commission) as shop_commission,approval_date,status from tb_deposit_log "
    sql = sql&" group by shop_id,approval_date,status having shop_id='"&adminID&"' and status='Y' and shop_id<>'' and approval_date between '"&sdate&"' and '"&ldate&"' ) a "
    sql = sql&" group by  shop_id,convert(varchar(10),approval_date,120),status order by convert(varchar(10),approval_date,120) desc "
    RegList2 = GetString_List(sql)
    Rows2 = split(RegList2,RowDel)
    RecordCount = UBound(Rows2)
    
    RegList = GetString_List(sql)
    Record_String = RegList 
    Rows = split(RegList,RowDel)
    RecordCount = UBound(Rows)
	authtitle = "매장"
end if
    

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
                    <form name="frm1" method="post" action="<%=move_url%>" class="form-horizontal">
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
                                 &nbsp;&nbsp;매장 :
                                <select class="select2_single form-control" name="s_shop_id" onchange="document.frm1.submit()">
                                   <option value="">=선택=</option>
                                  <%
                                  sql="select distinct a.user_id from distributor3 a left outer join distributor2 b on a.distribute2_link=b.number where 1=1 and b.user_id is not null and b.user_id='"&adminid&"'"
                                  if s_chongpan_id <> "" then
                                    sql = sql&" and b.user_id='"&s_chongpan_id&"'"
                                  end if
                      
                                   RegList2 = GetString_List(sql)
                                   Rows2 = split(RegList2,RowDel)
                                   %>
                                  <% For i = 0 to UBound(Rows2)-1
                                     Cols = split(Rows2(i),ColDel)  
                                  %>
                                  <option value="<%=Cols(0)%>"<%if Cstr(request("s_shop_id")) = Cstr(Cols(0)) then%> selected<%end if%>><%=Cols(0)%></option>
                                  <%next%>
                                </select>                    
                                <button onclick="javascript:goWrite()" class="btn btn-info form-control">검색</button>                                                
                                </div>
                            </div>
                        </div>                            
                     </form>
                    <table id="boss_deal_pay_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>번호</b></th>        
                            <th style="text-align:center" height="25"><b>매장ID</b></th>            
                            <th style="text-align:center" height="25"><b>충전금액</b></th>
                            <th style="text-align:center" height="25"><b>충전(선물)</b></th>
                            <th style="text-align:center" height="25"><b>환전금액</b></th>
                            <th style="text-align:center" height="25"><b>환전(선물)</b></th>
                            <th style="text-align:center" height="25"><b>베팅액</b></th>                
                            <th style="text-align:center" height="25"><b>딜비</b></th>                
                            <th style="text-align:center" height="25"><b>유저보유머니</b></th>                        
                            <th style="text-align:center" height="25"><b>잭팟금액</b></th>                        
                            <th style="text-align:center" height="25"><b>매장수익</b></th>  
                        </tr>
                      </thead>
                      <tbody>
                       <%
    
   	                    if RecordCount = 0 then
                     %>
                            <script type="text/javascript">
                                $(document).ready(function () {
                                    $("#charge_td").attr("colspan", 13);

                                })
                            </script>
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td id="charge_td" style="text-align:center" height="25"><b>등록된 정산내역이 없습니다.</b></td>
                        </tr>
                       <%else 
  
                            cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber
            	
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)      
                                no       = listnumber
                                 IDAuth = 2
                                if IDAuth = 1 then
                                     bonsa_id = Cols(0)
                                     chongpan_id = Cols(1)
                                     chongpan_id ="<a href=""?adminID="&chongpan_id&"&adminNo=2"">"&chongpan_id&"</a>"
                                     shop_id = Cols(2)
                                     shop_id ="<a href=""?adminID="&shop_id&"&adminNo=3"">"&shop_id&"</a>"
                                     charge_amt_save = cdbl(Cols(3))
                                     charge_amt = cdbl(Cols(4))
                                     exchange_amt = cdbl(Cols(5))
                                     exchange_save_amt = cdbl(Cols(6))
                                     rest_amt = cdbl(Cols(7))
                                    sql="     select c.user_id as bonsa_id,b.user_id as chongpan_id,a.user_id as shop_id,'dd' as ddd,c.distribute1_rate,b.distribute2_rate ,a.distribute3_rate from distributor3 a inner join distributor2 b on a.distribute2_link=b.number"
                                    sql=sql&" inner join distributor1 c on a.distribute1_link=c.number where a.user_id='"&Cols(2)&"'"            
                
                                    set rs2 = GameDBconn.execute(sql)
                                    if not rs2.eof then
                                        bonsa_id=trim(rs2("bonsa_id"))
                                        chongpan_id=trim(rs2("chongpan_id"))
                                        shop_id=trim(rs2("shop_id"))
                    
                                        distribute2_rate=trim(rs2("distribute2_rate"))-trim(rs2("distribute3_rate"))                    
                                        distribute3_rate=trim(rs2("distribute3_rate"))
                                        distribute1_rate=trim(rs2("distribute1_rate"))-(distribute2_rate+distribute3_rate)
                                         distribute1_amt=(charge_amt+charge_amt_save)*distribute1_rate/100
                                        distribute2_amt=(charge_amt+charge_amt_save)*distribute2_rate/100
                                        distribute3_amt=(charge_amt+charge_amt_save)*distribute3_rate/100                    
                                        income_amt2=distribute3_amt
                                        income_amt=distribute2_amt
                                    end if
                                    set rs2 = nothing
                
                                    'income_amt2 = cdbl(Cols(5))-cdbl(Cols(6)) 
                                    'income_amt3 = cdbl(Cols(6))                           
                                    'income_amt = cdbl(Cols(4)) -(cdbl(Cols(5))-cdbl(Cols(6)))                
                                elseif IDAuth = 2 then
                                     user_id = "<a href=""?adminID="&Cols(1)&"&adminNo="&adminNo&""">"&Cols(1)&"</a>"
                                     charge_amt_save = cdbl(Cols(2))
                                     charge_amt = cdbl(Cols(3))
                                     sum_charge_amount = charge_amt_save+charge_amt
                                     exchange_amt = cdbl(Cols(4))
                                     exchange_save_amt = cdbl(Cols(5))
                                     exchange_tot_amt = exchange_amt+exchange_save_amt
                                     rest_amt = cdbl(Cols(6))
                 
                                     betting_amt = cdbl(Cols(7))
                                     tot_deal_money = cdbl(Cols(8))
                                     income_amt=0
                                     income_amt2=0
                                     sql="     select c.user_id as bonsa_id,b.user_id as chongpan_id,a.user_id as shop_id,'dd' as ddd,c.distribute1_rate,b.distribute2_rate ,a.distribute3_rate,d.user_rate from distributor3 a inner join distributor2 b on a.distribute2_link=b.number"
                                    sql=sql&" inner join distributor1 c on a.distribute1_link=c.number inner join users d on a.number=d.user_distributor3_link where a.user_id='"&Cols(1)&"'"            
      
                                    set rs2 = GameDBconn.execute(sql)
                                    distribute4_amt=0
                                    if not rs2.eof then
                                        distribute2_rate=cdbl(trim(rs2("distribute2_rate")))-cdbl(trim(rs2("distribute3_rate")))                    
                                        distribute3_rate=cdbl(trim(rs2("distribute3_rate")))
                                        distribute1_rate=cdbl(trim(rs2("distribute1_rate")))-(cdbl(distribute2_rate)+cdbl(distribute3_rate))
                                        distribute1_amt=cdbl(betting_amt)*cdbl(distribute1_rate)/100
                                        distribute2_amt=cdbl(betting_amt)*distribute2_rate/100
                                        distribute3_amt=fix(cdbl(betting_amt)*distribute3_rate/100)                    
                                         distribute4_rate=cdbl(trim(rs2("user_rate")))                    
                                        distribute4_amt=distribute4_amt+(cdbl(betting_amt)*distribute4_rate/100)  
                                        income_amt=distribute2_amt
                                        income_amt2=distribute3_amt-distribute4_amt                    

                                           tot_betting_amt  = tot_betting_amt + cdbl(Cols(7))
                 
                                        bonsa_id=trim(rs2("bonsa_id"))
                                        chongpan_id=trim(rs2("chongpan_id"))
                                        shop_id=trim(rs2("shop_id"))
                                     
                    
                 
                                    end if
                
                                    set rs2 = nothing
                                sql="select isnull(sum(user_money),0) from users a with(nolock) inner join distributor3 b on a.user_distributor3_link=b.number where b.user_id='"&Cols(1)&"'"            
                                set rs3 = GameDBconn.execute(sql)
                                if not rs3.eof then
                                    tot_user_money = trim(rs3(0))
                                else
                                    tot_user_money = 0
                                end if
                                set rs3 = nothing
                                    regdate = Cols(6)           
                                elseif IDAuth = 3 then
                                    user_id = Cols(1)
                                    exchange_amt = Cols(2)
                                    income_amt = cdbl(Cols(3))
                                    regdate = Cols(4)           
                                end if
            
                      %>
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td align="center"><b><%=no%></b></td>
                            <td align="center"><%=user_id%></td>
                            <td align="right" style="padding-right:20px"><%=FormatNumber(charge_amt,0)%></td>
                            <td align="right" style="padding-right:20px"><%=FormatNumber(charge_amt_save,0)%></td>        
                            <td align="right" style="padding-right:20px"><%=FormatNumber(exchange_amt,0)%></td>        
                            <td align="right" style="padding-right:20px"><%=FormatNumber(exchange_save_amt,0)%></td>        
                            <td align="right" style="padding-right:20px"><%=FormatNumber(betting_amt,0)%></td>        
                            <td align="right" style="padding-right:20px"><%=FormatNumber(tot_deal_money,0)%></td>
                            <td align="right" style="padding-right:20px"><%=FormatNumber(tot_user_money,0)%></td>                
                            <td align="right" style="padding-right:20px"><%=FormatNumber(jackpot_amt ,0)%>&nbsp;<font color="blue">(<%=Jackpotrate%>%)</font></td>        
                            <td align="right" style="padding-right:20px"><%=FormatNumber(distribute3_amt,0)%>&nbsp;<font color="blue">(<%=distribute3_rate%>%)</font></td>  
                        </tr>
                             <%
                             listnumber = listnumber-1
                             sum_charge_amt=cdbl(sum_charge_amt+charge_amt)
                             sum_charge_amt_save=cdbl(sum_charge_amt_save+charge_amt_save)
                             tot_sum_charge_amount=tot_sum_charge_amount+sum_charge_amount
                             sum_rest_amt=cdbl(sum_rest_amt+rest_amt)
                             sum_exchange_amt=cdbl(sum_exchange_amt+exchange_amt)
                             sum_exchange_save_amt=cdbl(sum_exchange_save_amt+exchange_save_amt)
                             sum_exchange_tot_amt=cdbl(sum_exchange_tot_amt+exchange_tot_amt)
                             sum_betting_amt=cdbl(sum_betting_amt+tot_betting_amt)
                             sum_income_amt=cdbl(sum_income_amt+distribute3_amt)         
                             if IDAuth = 1 then
                             sum_income_amt2=cdbl(sum_income_amt2+income_amt2)         
                             sum_income_amt3=cdbl(sum_income_amt3+income_amt3)         
                             elseif IDAuth = 2 then
                             sum_income_amt2=cdbl(sum_income_amt2+income_amt2)         
                             end if
                             sum_distribute4_amt=cdbl(sum_distribute4_amt+distribute4_amt)      
                             sum_tot_user_money=cdbl(sum_tot_user_money+tot_user_money)                   
                             sum_jackpot_amt=cdbl(sum_jackpot_amt+jackpot_amt)                   
                             tot_betting_amt=0
                             tot_deal_use_amt = tot_deal_use_amt+tot_deal_money
                             deal_use_amt=0
	                        Next
     
                       end if
                       closeGameDB
                       %>
                        <tr bgcolor="#FCF7ED" height="25"> 
                            <td align="center"><b>합   계</b></td>	    
                            <td align="center"><b></b></td>	    
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(sum_charge_amt,0)%></b></td>
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(sum_charge_amt_save,0)%></b></td>
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(sum_exchange_amt,0)%></b></td>
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(sum_exchange_save_amt,0)%></b></td>
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(sum_betting_amt,0)%></b></td>
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(tot_deal_use_amt,0)%></b></td>        
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(sum_tot_user_money,0)%></b></td>
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(sum_jackpot_amt ,0)%></b></td>        
                            <td align="right" style="padding-right:20px"><b><%=FormatNumber(sum_income_amt,0)%></b></td>       
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
