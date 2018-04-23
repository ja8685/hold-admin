<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
keyfield = trim(Request("keyfield"))
keyword = trim(Request("keyword"))

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
realuser = Request("realuser")
If realuser = "" Then realuser = "N"
connectionGameDB("PNC")
adminno = Request("adminno")
adminID = Request("adminID")
if adminno = "" then
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
adminID = request.Cookies(admincheck)("adminID")
else
IDAuth = cint(adminno)
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
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id& "&adminno="&adminno&"&adminID="&adminID&"&s_chongpan_id="&s_chongpan_id&"&s_shop_id="&s_shop_id
parameters = parameters & "&realuser=" & realuser
if keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " = '"& keyword &"'"    
    searchSQL_new = " and a.user_id = '"& keyword &"'"        
end if


move_url = "bonsa_inoutlist.asp?" & parameters


'1페이지당 리스트 개수
if page_size = "" then page_size = 200000
PageSize = page_size
If realuser = "Y" Then
	searchSQL = searchSQL & " and jisa_id <> '마스터' "
	searchSQL1 = searchSQL1 & " and user_distributor15_link <> '145' "
End If

if IDAuth = 1 then
    
    
    sql=" select * from ("
    sql=sql&" select jisa_id,chongpan_id,shop_id,take_id,user_account_name,sum(income_amt_save) as income_amt_save,sum(income_amt) as income_amt"
    sql=sql&" ,sum(outcome_amt) as outcome_amt,sum(outcome_amt_save) as outcome_amt_save,row_number() over(order by take_id desc) as row_num,sum(betting_amt) as betting_amt,sum(tot_deal_money) as tot_deal_money,sum(user_money) as user_money from ("
    sql=sql&" select jisa_id,chongpan_id,shop_id,take_id,user_account_name,0 as income_amt_save,sum(outcome_amt) as income_amt,0 as outcome_amt,0 as outcome_amt_save,"
    sql=sql&" status,0 as betting_amt,0 as tot_deal_money,0 as user_money from tb_deposit_log a with(nolock) inner join users b with(nolock) on a.take_id=b.user_id where approval_date between '"&sdate&"' and '"&ldate&"' "&searchshop
    if keyword <> "" then 
    sql=sql&" and "&keyfield&" = '"&keyword&"'"
    end if
    sql=sql&" group by bonsa_id,jisa_id,chongpan_id,shop_id,take_id,user_account_name,status having bonsa_id='"&adminID&"' "
    sql=sql&" and status='Y' and chongpan_id<>''"
    sql=sql&" union all"
    sql=sql&" select a.jisa_id,a.chongpan_id,a.shop_id,a.take_id,user_account_name,0 as income_amt_save,0 as income_amt,sum(a.outcome_amt) as outcome_amt,0 as outcome_amt_save,a.status,0 as betting_amt,0 as tot_deal_money,0 as user_money "
    sql=sql&" from tb_outcome_log a with(nolock) inner join users b with(nolock) on a.take_id=b.user_id where a.approval_date between '"&sdate&"' and '"&ldate&"' "&searchshop
    if keyword <> "" then 
    sql=sql&" and "&keyfield&" = '"&keyword&"'"
    end if
    sql=sql&" group by a.bonsa_id,a.jisa_id,a.chongpan_id,a.shop_id,a.take_id,user_account_name,a.status having a.bonsa_id='"&adminID&"' "
    sql=sql&" and a.status='Y' and a.chongpan_id<>''"    
    sql=sql&" union all "
    
    sql=sql&" select b.jisa_id,b.chongpan_id,b.shop_id,a.user_id as take_id,user_account_name,0 as income_amt_save,0 as income_amt,0 as outcome_amt,0 as outcome_amt_save,'Y' as status,0 as betting_amt,0 as tot_deal_money,0 as user_money from MoneyChangeLog a with(nolock)"
    sql=sql&" inner join v_member_list01 b with(nolock) on a.user_id=b.user_id inner join users c on a.user_id=c.user_id where a.update_time between '"&sdate&"' and '"&ldate&"' "&searchshop
    if keyword <> "" then 
        if keyfield="take_id" then
            sql=sql&searchSQL_new
        else
            sql=sql&" and "&keyfield&" = '"&keyword&"'"
        end if
    end if
    sql=sql&" group by b.bonsa_id,b.jisa_id,b.chongpan_id,b.shop_id,a.user_id ,user_account_name,a.status having b.bonsa_id='"&adminID&"' and a.status=1 and b.chongpan_id<>''"   
    
    sql = sql&" union all "
    sql = sql&" select a.jisa_id,a.chongpan_id,a.shop_id,a.user_id as take_id,user_account_name,0 as income_amt_save,0 as income_amt,0 as outcome_amt,0 as outcome_amt_save,'Y' as status,sum(betting_amt) as betting_amt "
    sql = sql&" ,SUM(deal_money) as tot_deal_money,0 as user_money from deal_money_ins_log a inner join v_member_list01 b on a.user_id=b.user_id inner join users c on a.user_id=c.user_id where 1=1 "
    sql = sql&searchshop
    if keyword <> "" then 
        if keyfield="take_id" then
            sql=sql&searchSQL_new
        else
            sql=sql&" and "&keyfield&" = '"&keyword&"'"
        end if
    end if
    sql = sql&" and a.reg_date between '"&sdate&"' and '"&ldate&"'"
    sql = sql&" group by a.bonsa_id,a.jisa_id,a.chongpan_id,a.shop_id,a.user_id,user_account_name"
    sql = sql&" having a.bonsa_id='"&adminID&"' and a.chongpan_id<>''"

    sql = sql&" union all "
    sql = sql&" select jisa_id,chongpan_id,shop_id,a.to_user as take_id,user_account_name,sum(money) as income_amt_save,0 as income_amt,0 as outcome_amt,0 as outcome_amt_save,'Y' as status,0 as betting_amt,0 as tot_deal_money,0 as user_money  from "
    sql = sql&" GiftToLog a inner join users b on a.to_user=b.user_id inner join v_member_list01 c on b.user_id=c.user_id where  money>0 and user_distributor1_link="&request.Cookies(admincheck)("adminNO")&" and a.date between"
    sql = sql&" '"&sdate&"' and '"&ldate&"'"
    if keyword <> "" then 
        if keyfield="take_id" then
           sql=sql&" and a.to_user = '"&keyword&"'"
        else
            sql=sql&" and "&keyfield&" = '"&keyword&"'"
        end if
    end if
    sql = sql&" group by jisa_id,chongpan_id,shop_id,a.to_user,user_account_name"
    sql = sql&" union all "
    sql = sql&" select jisa_id,chongpan_id,shop_id,a.to_user as take_id,user_account_name,0 as income_amt_save,0 as income_amt,0 as outcome_amt,-sum(money) as outcome_amt_save,'Y' as status,0 as betting_amt,0 as tot_deal_money,0 as user_money  from "
    sql = sql&" GiftToLog a inner join users b on a.to_user=b.user_id inner join v_member_list01 c on b.user_id=c.user_id where  money<0 and user_distributor1_link="&request.Cookies(admincheck)("adminNO")&" and a.date between"
    sql = sql&" '"&sdate&"' and '"&ldate&"'"
    if keyword <> "" then 
        if keyfield="take_id" then
           sql=sql&" and a.to_user = '"&keyword&"'"
        else
            sql=sql&" and "&keyfield&" = '"&keyword&"'"
        end if
    end if
    sql = sql&" group by jisa_id,chongpan_id,shop_id,a.to_user,user_account_name)"
    sql=sql&" a group by jisa_id,chongpan_id,shop_id,take_id,user_account_name "    
    sql=sql& " ) b where b.ROW_NUM BETWEEN(("&PAGE&" - 1) * "&page_size&") + 1 AND ("&PAGE&" * "&PAGE_SIZE&") "&searchSQL&" order by jisa_id desc,chongpan_id desc,shop_id"    
    RegList = GetString_List(sql)
    Record_String = RegList 
    Rows = split(RegList,RowDel)
    RecordCount = UBound(Rows)
    
authtitle = "본사"
elseif IDAuth = 2 then
    'sql = "select chongpan_id,shop_id,sum(outcome_amt),sum(chongpan_commission),sum(shop_commission),convert(varchar(10),approval_date,120),status from tb_deposit_log "
    'sql = sql&" group by chongpan_id,shop_id,convert(varchar(10),approval_date,120),status having chongpan_id='"&adminID&"' and status='Y' and chongpan_id<>'' and convert(varchar(10),approval_date,120) between '"&sdate&"' and '"&ldate&"' order by convert(varchar(10),approval_date,120) desc"
    sql=" select take_id,sum(income_amt) as income_amt,sum(outcome_amt) as outcome_amt,approval_date from ("
    sql=sql&" select take_id,sum(outcome_amt) as income_amt,0 as outcome_amt,convert(varchar(10),approval_date,120) as approval_date,"
    sql=sql&" status from tb_deposit_log group by chongpan_id,take_id,convert(varchar(10),approval_date,120),status having chongpan_id='"&adminID&"' "
    sql=sql&" and status='Y' and chongpan_id<>'' and convert(varchar(10),approval_date,120) between '"&sdate&"' and '"&ldate&"'"
    sql=sql&" union all"
    sql=sql&" select take_id,0 as income_amt,sum(outcome_amt) as outcome_amt,convert(varchar(10),approval_date,120) as approval_date,"
    sql=sql&" status from tb_outcome_log group by chongpan_id,take_id,convert(varchar(10),approval_date,120),status having chongpan_id='"&adminID&"' "
    sql=sql&" and status='Y' and chongpan_id<>'' and convert(varchar(10),approval_date,120) between '"&sdate&"' and '"&ldate&"' ) "
    sql=sql&" a group by approval_date,take_id order by approval_date desc "




    RegList2 = GetString_List(sql)
    Rows2 = split(RegList2,RowDel)
    RecordCount = UBound(Rows2)
    
    RegList = GetString_List(sql)
    Record_String = RegList 
    Rows = split(RegList,RowDel)
	authtitle = "총판"
elseif IDAuth = 3 then
   ' sql = "select shop_id,take_id,sum(outcome_amt),sum(shop_commission),convert(varchar(10),approval_date,120),status from tb_deposit_log "
   ' sql = sql&" group by shop_id,take_id,convert(varchar(10),approval_date,120),status having shop_id='"&adminID&"' and status='Y' and shop_id<>'' and convert(varchar(10),approval_date,120) between '"&sdate&"' and '"&ldate&"' order by convert(varchar(10),approval_date,120) desc"
     sql=" select take_id,sum(income_amt) as income_amt,sum(outcome_amt) as outcome_amt,approval_date from ("
    sql=sql&" select take_id,sum(outcome_amt) as income_amt,0 as outcome_amt,convert(varchar(10),approval_date,120) as approval_date,"
    sql=sql&" status from tb_deposit_log group by shop_id,take_id,convert(varchar(10),approval_date,120),status having shop_id='"&adminID&"' "
    sql=sql&" and status='Y' and shop_id<>'' and convert(varchar(10),approval_date,120) between '"&sdate&"' and '"&ldate&"'"
    sql=sql&" union all"
    sql=sql&" select take_id,0 as income_amt,sum(outcome_amt) as outcome_amt,convert(varchar(10),approval_date,120) as approval_date,"
    sql=sql&" status from tb_outcome_log group by shop_id,take_id,convert(varchar(10),approval_date,120),status having shop_id='"&adminID&"' "
    sql=sql&" and status='Y' and shop_id<>'' and convert(varchar(10),approval_date,120) between '"&sdate&"' and '"&ldate&"' ) "
    sql=sql&" a group by approval_date,take_id order by approval_date desc "

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
PageCount = int((RecordCount-1)/Page_Size) + 1

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
                    <h3>유저 손익 관리 - <%=adminID%>[<%=authtitle%>]</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <form name="frm1" method="post" action="?">
                       <input type="hidden" name="user_id" />                       
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
                                &nbsp;시<br />
                                 &nbsp;&nbsp;<!--본사:	
                                 <select class="select2_single form-control"  name="s_jisa_id" onchange="document.frm1.submit()">
                                  <option value="">=선택=</option>
                                  <%
                                  sql="select user_id from distributor15 with(nolock) where distribute1_link="&request.Cookies(admincheck)("adminNo")
                                   RegList2 = GetString_List(sql)
                                   Rows2 = split(RegList2,RowDel)
                                   %>
                                  <% For i = 0 to UBound(Rows2)-1
                                     Cols = split(Rows2(i),ColDel)  
                                  %>
                                  <option value="<%=Cols(0)%>"<%if Cstr(request("s_jisa_id")) = Cstr(Cols(0)) then%> selected<%end if%>><%=Cols(0)%></option>
                                  <%next%>
                                </select>
                                &nbsp;&nbsp;총판:	
                                 <select class="select2_single form-control"  name="s_chongpan_id" onchange="document.frm1.submit()">
                                  <option value="">=선택=</option>
                                  <%
                                  sql="select user_id from distributor2 with(nolock) where distribute1_link="&request.Cookies(admincheck)("adminNo")
                                   RegList2 = GetString_List(sql)
                                   Rows2 = split(RegList2,RowDel)
                                   %>
                                  <% For i = 0 to UBound(Rows2)-1
                                     Cols = split(Rows2(i),ColDel)  
                                  %>
                                  <option value="<%=Cols(0)%>"<%if Cstr(request("s_chongpan_id")) = Cstr(Cols(0)) then%> selected<%end if%>><%=Cols(0)%></option>
                                  <%next%>
                                </select>&nbsp;&nbsp;매장 :
                                <select class="select2_single form-control"  name="s_shop_id" onchange="document.frm1.submit()">
                                   <option value="">=선택=</option>
                                  <%
                                  sql="select distinct a.user_id from distributor3 a with(nolock) left outer join distributor2 b with(nolock) on a.distribute2_link=b.number where 1=1 and b.user_id is not null and a.distribute1_link="&request.Cookies(admincheck)("adminNo")
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
                                </select-->&nbsp;&nbsp;
                                <select class="select2_single form-control" name="keyfield">
                                <option value="take_id" <%if keyfield="take_id" then response.write "selected" end if%>>유저ID</option>
                                <!--option value="user_nick" <%if keyfield="user_nick" then response.write "selected" end if%>>닉네임</!--option-->
                                </select>
                                &nbsp;&nbsp;<input type="radio" class="rodio form-control" name="realuser" value="N" <% If realuser = "N" Then Response.write "checked" End If %>/>전체 <input type="radio" class="rodio form-control" name="realuser" value="Y" <% If realuser = "Y" Then Response.write "checked" End If %>/>실유저
                                 <input type="text" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()" class="form-control">	
                                &nbsp;&nbsp;<input type=button name=headregist value=" 검색 " onClick="javascript: goWrite()" class="form-control">                                           
                                </div>
                            </div>
                        </div>                            
                     </form>
                    <table id="boss_deal_pay_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>번호</b></th>
                            <th style="text-align:center" height="25"><b>본사ID</b></th>
                            <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>매장ID</b></th>
                            <th style="text-align:center" height="25"><b>유저ID</b></th>
                            <th style="text-align:center" height="25"><b>닉네임</b></th>
                            <th style="text-align:center" height="25"><b>충전금액</b></th>
                            <th style="text-align:center" height="25"><b>충전(선물)</b></th>
                            <th style="text-align:center" height="25"><b>환전금액</b></th>
                            <th style="text-align:center" height="25"><b>환전(선물)</b></th>
                            <th style="text-align:center" height="25"><b>수익</b></th>
                            <th style="text-align:center" height="25"><b>베팅액</b></th>
                            <th style="text-align:center" height="25"><b>딜비</b></th>
                            <th style="text-align:center" height="25"><b>보유머니</b></th>
                            <th style="text-align:center" height="25"><b>손익</b></th> 
                        </tr>
                      </thead>
                      <tbody>
                       <%

   	                        if RecordCount = 0 then
                         %>
                            <tr bgcolor="#FCF7ED" height="25"> 
	                            <td align="center" height="25" colspan="15"><b>등록된 손익내역이 없습니다.</b></td>
                            </tr>
                          <%else 
                                cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                                listnumber = RecordCount - cnumber    	
	                            For i = 0 to UBound(Rows)-1
		                            Cols = split(Rows(i),ColDel)      
                                    no       = listnumber
                                    jisa_id = Cols(0)                
                                    chongpan_id = Cols(1)                
                                    shop_id = Cols(2)
                                    user_id = Cols(3)
                                      sql=" select isnull(sum(a.distribute3_rate)+sum(b.distribute2_rate)+sum(c.distribute15_rate),0) from distributor3 a inner join distributor2 b on a.distribute2_link=b.number inner join distributor15 c"
                                    sql=sql&" on a.distribute15_link=c.number inner join users d on a.number=d.user_distributor3_link where d.user_id='"&user_id&"'"
                                     tot_sum_deal_money = CDbl(Replace(GetString_List(sql),RowDel,""))          
                                    if tot_sum_deal_money>0 then
                                        notdealmoney = "N"
                                    else
                                        notdealmoney = "Y"
                                    end if                 
		                         sql="select user_nick from users where user_id='"&user_id&"'"
                                     nick = CSTR(Replace(GetString_List(sql),RowDel,"")) 
                                    user_account_name = Cols(4)
                                    income_amt_save = cdbl(Cols(5))                                
                                    income_amt = cdbl(Cols(6))
                                    tot_sum_charge_amt = income_amt_save+income_amt 
                                    'exchange_amt = Cols(5)*(9/10)  
                                    exchange_amt = Cols(7)
                                    exchange_amt_save = Cols(8)
                                    betting_amt = Cols(10)
                                    tot_deal_money = fix(cdbl(Cols(11)))
                                    sql=" select isnull(user_money,0) from users with(nolock) where user_id='"&user_id&"'"
                                    user_money = CDbl(Replace(GetString_List(sql),RowDel,""))   
                                    tot_sum_exchange_amt= cdbl(exchange_amt_save)+cdbl(exchange_amt)
                                    tot_amt = (cdbl(income_amt)+cdbl(income_amt_save))-(cdbl(exchange_amt)+cdbl(exchange_amt_save))
                                    tot_user_inout = fix(tot_amt-(tot_deal_money+user_money)) '------손익(수익+딜비)           
                                    if tot_user_inout<0 then
                                        tot_user_inout2 = "<font color=""red"">"&FormatNumber(tot_user_inout,0)&"</font>"
                                    else
                                        tot_user_inout2 = FormatNumber(tot_user_inout,0)
                                    end if

                                    if tot_amt<0 then
                                        tot_amt2 = "<font color=""red"">"&FormatNumber(tot_amt,0)&"</font>"
                                    else
                                        tot_amt2 = FormatNumber(tot_amt,0)
                                    end if

            
                          %>
                            <tr bgcolor="#FCF7ED" height="25" style="font-weight: bold"> 
	                            <td align="center"><b><%=no%></b></td>
                                <td align="center"><font color="<%if notdealmoney = "N" then%>black<%else%>blue<%end if%>"><%=jisa_id%></font></td>
	                            <td align="center"><font color="<%if notdealmoney = "N" then%>red<%else%>blue<%end if%>"><%=chongpan_id%></font></td>
                                <td align="center"><font color="<%if notdealmoney = "N" then%>blue<%else%>blue<%end if%>"><%=shop_id%></font></td>
                                <td align="center"><font color="<%if notdealmoney = "N" then%>black<%else%>blue<%end if%>"><%=user_id%></font></td>
                                <td align="center"><font color="<%if notdealmoney = "N" then%>black<%else%>blue<%end if%>"><%=nick%></font></td>
                                <td align="right" style="padding-right:20px"><%=FormatNumber(income_amt,0)%></td>    
                                <td align="right" style="padding-right:20px"><%=FormatNumber(income_amt_save,0)%></td>    
                                <td align="right" style="padding-right:20px"><%=FormatNumber(exchange_amt,0)%></td>        
                                <td align="right" style="padding-right:20px"><%=FormatNumber(exchange_amt_save,0)%></td>        
                                <td align="right" style="padding-right:20px"><%=tot_amt2%></td>        
                                <td align="right" style="padding-right:20px"><%=FormatNumber(betting_amt,0)%></td>        
                                <td align="right" style="padding-right:20px"><%=FormatNumber(tot_deal_money,0)%></td>    
                                <td align="right" style="padding-right:20px"><%=FormatNumber(user_money,0)%></td>                                    
                                <td align="right" style="padding-right:20px"><%=tot_user_inout2%></td>        
                            </tr>
                                 <%
                                 listnumber = listnumber-1
                                 if jisa_id <> "마스터" then
                                     real_sum_exchange_amt=cdbl(real_sum_exchange_amt+exchange_amt)
                                     real_sum_exchange_amt_save=cdbl(real_sum_exchange_amt_save+exchange_amt_save)
                                     real_sum_income_amt=cdbl(real_sum_income_amt)+cdbl(income_amt)      
                                     real_sum_income_amt_save=cdbl(real_sum_income_amt_save)+cdbl(income_amt_save)      
                                     real_sum_tot_sum_charge_amt = real_sum_tot_sum_charge_amt + tot_sum_charge_amt 
                                     real_sum_betting_amt= real_sum_betting_amt+ cdbl(betting_amt)
                                     real_sum_tot_deal_money= real_sum_tot_deal_money+ cdbl(tot_deal_money)             
                                     real_sum_tot_sum_exchange_amt= real_sum_tot_sum_exchange_amt + tot_sum_exchange_amt
                                     real_sum_tot_amt=cdbl(real_sum_tot_amt+((cdbl(income_amt)+cdbl(0))-(cdbl(exchange_amt)+cdbl(0))))       
                                     real_sum_user_money = real_sum_user_money+ user_money                                     
                                     real_sum_tot_user_inout = real_sum_tot_user_inout + cdbl(tot_user_inout)
                                 end if

                                 sum_exchange_amt=cdbl(sum_exchange_amt+exchange_amt)
                                 sum_exchange_amt_save=cdbl(sum_exchange_amt_save+exchange_amt_save)
                                 sum_income_amt=cdbl(sum_income_amt)+cdbl(income_amt)      
                                 sum_income_amt_save=cdbl(sum_income_amt_save)+cdbl(income_amt_save)      
                                 sum_tot_sum_charge_amt = sum_tot_sum_charge_amt + tot_sum_charge_amt 
                                 sum_betting_amt= sum_betting_amt+ cdbl(betting_amt)
                                 sum_tot_deal_money= sum_tot_deal_money+ cdbl(tot_deal_money)             
                                 sum_tot_sum_exchange_amt= sum_tot_sum_exchange_amt + tot_sum_exchange_amt
                                 sum_tot_amt=cdbl(sum_tot_amt+((cdbl(income_amt)+cdbl(0))-(cdbl(exchange_amt)+cdbl(0))))       
                                 sum_user_money = sum_user_money + user_money                                     
                                 sum_tot_user_inout = sum_tot_user_inout + cdbl(tot_user_inout)
	                            Next
     
                           end if
                           closeGameDB
                            if sum_tot_amt<0 then
                                        sum_tot_amt = "<font color=""red"">"&FormatNumber(sum_tot_amt,0)&"</font>"
                                    else
                                        sum_tot_amt = FormatNumber(sum_tot_amt,0)
                                    end if
                           %>
                            <tr bgcolor="#FCF7ED" height="25"> 
                                <td align="center"><b>전체합계</b></td>	    
                                <td align="center"><b></b></td>	    
                                <td align="center"><b></b></td>	                                    
                                <td align="center"><b></b></td>	    
                                <td align="center"><b></b></td>	    
                                <td align="center"><b></b></td>	    
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(sum_income_amt,0)%></b></td>
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(sum_income_amt_save,0)%></b></td>
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(sum_exchange_amt,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(sum_exchange_amt_save,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=sum_tot_amt%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(sum_betting_amt,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(sum_tot_deal_money,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(sum_user_money,0)%></b></td>                                             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(sum_tot_user_inout,0)%></b></td>              
                            </tr>
                            <tr bgcolor="#FCF7ED" height="25"> 
                                <td align="center"><b>실제합계</b></td>	    
                                <td align="center"><b></b></td>	    
                                <td align="center"><b></b></td>	    
                                <td align="center"><b></b></td>	                                    
                                <td align="center"><b></b></td>	    
                                <td align="center"><b></b></td>	    
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_income_amt,0)%></b></td>
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_income_amt_save,0)%></b></td>
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_tot_sum_exchange_amt,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_exchange_amt_save,0)%></b></td>
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_tot_amt,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_betting_amt,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_tot_deal_money,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_user_money,0)%></b></td>             
                                <td align="right" style="padding-right:20px;color:red"><b><%=FormatNumber(real_sum_tot_user_inout,0)%></b></td>              
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
