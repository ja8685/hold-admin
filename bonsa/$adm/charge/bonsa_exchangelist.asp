<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
on error resume next
syear = Request("syear")
smonth = Request("smonth")
sday = Request("sday")
lyear = Request("lyear")
lmonth = Request("lmonth")
lday = Request("lday")
orderby = request("orderby")
if orderby = "" then
    orderby = "request_date"
end if
syear = Request("syear")
smonth = Request("smonth")
sday = Request("sday")
stime = Request("stime")
lyear = Request("lyear")
lmonth = Request("lmonth")
lday = Request("lday")
ltime = Request("ltime")
take_id = URLDecode(trim(Request("take_id")))
if stime = "" then stime = "13"
if ltime = "" then ltime = hour(now())

realuser = Request("realuser")
If realuser = "" Then realuser = "N"

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
keyfield = Request("keyfield")
send_id = trim(Request("send_id"))


page_size = Request("page_size")
page = Request("page")

if page = "" then
	page = 1
end if
'1페이지당 리스트 개수
'if page_size = "" then page_size = 20000000000
if page_size = "" then page_size = 30
PageSize = page_size

connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id & "&orderby="&orderby
parameters = parameters & "&realuser=" & realuser &"&take_id=" & server.URLEncode(take_id)
move_url = "bonsa_exchangelist.asp?" & parameters
sql=" select count(A.idx) from TB_outcome A, v_member_list01 B where A.take_id = B.user_id "
authtitle = "본사"

if syear <> "" and lyear <> "" then 
	searchSQL = " and A.request_date between '"& sdate &"' and '"& ldate &"'"
else
    searchSQL = " and A.idx>0 and A.request_date between '"& sdate &"' and '"& ldate &"'"
end If

if take_id <> "" then 
	searchSQL = searchSQL&" and A.take_id like '%"& take_id &"%'"
end If


If realuser = "Y" Then
	searchSQL = searchSQL & " and B.jisa_id <> '마스터' "
End If

sql=sql&searchSQL 

RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))

'총 페이지수
PageCount = int((RecordCount-1)/PageSize) + 1

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
    function exchange_put(str, no) {
        var url = "bonsa_exchange_ok.asp?gubun=" + str + "&no=" + no;
        if (str == "Y") {
            if (confirm("환전신청을 승인하시겠습니까?")) {
                document.location.href = url;
            }
        }
        if (str == "C") {
            if (confirm("환전신청을 취소하시겠습니까?")) {
                document.location.href = url;
            }
        }
        if (str == "D") {
            if (confirm("환전신청을 삭제하시겠습니까?")) {
                document.location.href = url;
            }
        }

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
                    <h2>환전 목록</h2>
                    
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <div class="row">
                        <form name="frm1" method="post" action="?">
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
                                </div>
                            <div class="form-inline form-group pull-right">
                                &nbsp;&nbsp;<!--본사:	
                                <select class="select2_single form-control"  name="s_jisa_id" onchange="document.frm1.submit()">
                                <option value="">=선택=</option>
                                <%
                                sql="select user_id from distributor15"
                                RegList2 = GetString_List(sql)
                                Rows2 = split(RegList2,RowDel)
                                %>
                                <% For asdf = 0 to UBound(Rows2)-1
                                    Cols = split(Rows2(asdf),ColDel)  
                                %>
                                <option value="<%=Cols(0)%>"<%if Cstr(request("s_jisa_id")) = Cstr(Cols(0)) then%> selected<%end if%>><%=Cols(0)%></option>
                                <%next%>
                            </select>
                            &nbsp;&nbsp;총판:	
                                <select class="select2_single form-control"  name="s_chongpan_id" onchange="document.frm1.submit()">
                                <option value="">=선택=</option>
                                <%
                                sql="select user_id from distributor2"
                                RegList2 = GetString_List(sql)
                                Rows2 = split(RegList2,RowDel)
                                %>
                                <% For essd = 0 to UBound(Rows2)-1
                                    Cols = split(Rows2(essd),ColDel)  
                                %>
                                <option value="<%=Cols(0)%>"<%if Cstr(request("s_chongpan_id")) = Cstr(Cols(0)) then%> selected<%end if%>><%=Cols(0)%></option>
                                <%next%>
                            </select>&nbsp;&nbsp;매장 :
                            <select class="select2_single form-control"  name="s_shop_id" onchange="document.frm1.submit()">
                                <option value="">=선택=</option>
                                <%
                                sql="select distinct a.user_id from distributor3 a with(nolock) left outer join distributor2 b with(nolock) on a.distribute2_link=b.number where 1=1 and b.user_id is not null"
                                if s_chongpan_id <> "" then
                                sql = sql&" and b.user_id='"&s_chongpan_id&"'"
                                end if
                      
                                RegList2 = GetString_List(sql)
                                Rows2 = split(RegList2,RowDel)
                                %>
                                <% For ersd = 0 to UBound(Rows2)-1
                                    Cols = split(Rows2(ersd),ColDel)  
                                %>
                                <option value="<%=Cols(0)%>"<%if Cstr(request("s_shop_id")) = Cstr(Cols(0)) then%> selected<%end if%>><%=Cols(0)%></option>
                                <%next%>
                            </select-->                                                            
		                    &nbsp;&nbsp;유저ID<input type="text" class="form-control" name="take_id" size="20" value="<%=take_id%>" onFocus="this.select()" onkeypress="if(event.keyCode == 13) javascript:goWrite();">
                            &nbsp;&nbsp;<input type="radio" class="radio form-control" name="realuser" value="N" <% If realuser = "N" Then Response.write "checked" End If %>/>전체 <input type="radio" name="realuser" value="Y" <% If realuser = "Y" Then Response.write "checked" End If %>/>실유저
		                    &nbsp;&nbsp;<input type=button name=headregist class="btn btn-info form-control" value=" 검색 " onkeypress="if(event.keyCode == 13) javascript:goWrite();" onClick="goWrite()">
                             &nbsp;&nbsp;<input type=button name="orderbymoney" class="btn btn-info form-control" value=" 환전머니순 정열 " onClick="javascript: document.location.href = 'bonsa_exchangelist.asp?orderby=outcome_amt'">

                            </div>
                            </div>
                        </form>
                        </div>                    
                    </div>
                      <div class="row">&nbsp;</div>                    
                      <table id="charge_list_table" class="table table-striped table-bordered dt-responsive nowrap">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>NO</b></th>
                            <th style="text-align:center" height="25"><b>본사ID</b></th>
                            <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>매장ID</b></th>
                            <th style="text-align:center" height="25"><b>신청ID</b></th>
                            <th style="text-align:center" height="25"><b>닉네임</b></th>
                            <th style="text-align:center" height="25"><b>은행명</b></th>
                            <th style="text-align:center" height="25"><b>계좌번호</b></th>
	                        <th style="text-align:center" height="25"><b>예금주</b></th>
                            <th style="text-align:center" height="25"><b>연락처</b></th>      
                            <th style="text-align:center" height="25"><b>기존금액</b></th>
                            <th style="text-align:center" height="25"><b>환전신청금액</b></th>  
	                        <th style="text-align:center" height="25"><b>남은금액</b></th>
                            <th style="text-align:center" height="25"><b>상태</b></th>
                            <th style="text-align:center" height="25"><b>관리</b></th>
                            <th style="text-align:center" height="25"><b>신청일자</b></th>                 
                        </tr>
                      </thead>
                      <tbody>
               <%
    
   	                if RecordCount = 0 then
                 %>
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#charge_td").attr("colspan", 16);

                        })
                    </script>
                    <tr bgcolor="#FCF7ED" height="25"> 
	                    <td id="charge_td" align="center" height="25"><b>등록된 기록이 없습니다.</b></td>
                    </tr>
                  <%else 
  
                    if take_id <> "" then
		                sql_where = " and A.take_id like '%"&take_id&"%' and A.request_date between '"& sdate &"' and '"& ldate &"' "

		                If realuser = "Y" Then
			                sql_where = sql_where & " and B.jisa_id <> '마스터' "
		                End If

		                'sql="select top "&PageSize&" 's' as sdfsd, 'sdfsd' as sdfdd, A.* from TB_outcome A with(nolock), v_member_list01 B where A.take_id = B.user_id and idx not in (select top "&int((page-1)*PageSize)&" A.idx from TB_outcome A with(nolock), v_member_list01 B where A.take_id = B.user_id " & sql_where & " order by "&orderby&" desc) " & sql_where & " order by "&orderby&" desc "
                    else
		                sql_where = " and A.request_date between '"& sdate &"' and '"& ldate &"' "

		                If realuser = "Y" Then
			                sql_where = sql_where & " and B.jisa_id <> '마스터' "
		                End If

		                'sql="select top "&PageSize&" 's' as sdfsd, 'sdfsd' as sdfdd, A.* from TB_outcome A with(nolock), v_member_list01 B where A.take_id = B.user_id and idx not in (select top "&int((page-1)*PageSize)&" A.idx from TB_outcome A with(nolock), v_member_list01 B where A.take_id = B.user_id " & sql_where & " order by "&orderby&" desc) " & sql_where & " order by "&orderby&" desc "
                    end if

                    sql="select * from (select row_number() over(order by "&orderby&" desc) as num,'s' as sdfsd, 'sdfsd' as sdfdd, A.* from TB_outcome A, v_member_list01 B where A.take_id = B.user_id " & sql_where & ") t WHERE	T.num BETWEEN("&int((page-1)*PageSize)&"+1) AND ("&page&" * "&PageSize&") ORDER BY	"&orderby&" desc"
    
                    RegList = GetString_List(sql)
    
                    Record_String = RegList  
                            cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                        listnumber = RecordCount - cnumber
	                    Rows = split(RegList,RowDel)
	                    For i = 0 to UBound(Rows)-1
		                    Cols = split(Rows(i),ColDel)      
                            no       = Cols(3)
                            take_id  = Cols(4)
                            if take_id <> "" then
                                sql=" select shop_id,chongpan_id,jisa_id from v_member_list01 a with(nolock) where user_id='"&take_id&"'"
                                below_list = split(replace(GetString_List(sql),RowDel,""),ColDel)
                                if isarray(below_list) = true then
                                    shop_id = below_list(0)
                                    chongpan_id = below_list(1)                    
                                    jisa_id = below_list(2)                    
                                end if
                                sql=" select user_nick from users where user_id='"&take_id&"'"
                                user_nick= replace(GetString_List(sql),RowDel,"")
                                sql=" select user_avata from users where user_id='"&take_id&"'"
                                user_avata= replace(GetString_List(sql),RowDel,"")
                            end if
                            sql = "select isnull(sum(user_money),0) from users where user_id='"&take_id&"'"
                            gold = CDbl(Replace(GetString_List(sql),RowDel,""))
      
                            bankname  = Cols(10)
                            accountno= Cols(9)
                            accountname= Cols(5)
                            hp= Cols(11)
                            'if cstr(user_avata)="1" then
                            'exchange_amt= cdbl(Cols(6))-(cdbl(Cols(6))*10/100)
                            'else
                            exchange_amt= Cols(6)
                            'end if
                            before_amt= Cols(7)
                            after_amt= Cols(8)
                            state= Cols(12)
                            if state = "N" then
                                state = "<font color=""blue"">신청</font>"
                            elseif state = "Y" then
                                state = "완료"
                            elseif state = "C" then
                                state = "취소"
                            end if
                            request_date= Cols(13)
                            tot_before_amt = tot_before_amt + cdbl(before_amt)
                            tot_exchange_amt = tot_exchange_amt + cdbl(exchange_amt)
                            tot_after_amt = tot_after_amt + cdbl(after_amt)
                            tot_gold = tot_gold + cdbl(gold)      
                  %>
                    <tr bgcolor="#FCF7ED" height="25" style="font-weight: bold"> 
	                    <td align="center"><b><%=listnumber%></b></td>
                        <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=jisa_id%></font></td>
                        <td align="center"><font color="<%if cstr(user_avata) = "0" then%>red<%else%>blue<%end if%>"><%=chongpan_id%></font></td>
                        <td align="center"><font color="<%if cstr(user_avata) = "0" then%>blue<%else%>blue<%end if%>"><%=shop_id%></font></td>
	                    <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=take_id%></font></td>
                        <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=user_nick%></font></td>        
                        <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=bankname%></font></td>
	                    <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=accountno%></font></td>
	                    <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=accountname%></font></td>
                        <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=hp%></font></td>        
                        <!--td align="right" style="padding-right:20px"><%=formatnumber(exchange_amt*(9/10),0)%></td-->
                        <td align="right" style="padding-right:20px"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=formatnumber(before_amt,0)%></font></td>
                        <td align="right" style="padding-right:20px"><font color="red"><%=formatnumber(exchange_amt,0)%></font></td>
                        <td align="right" style="padding-right:20px"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=formatnumber(after_amt,0)%></font></td>
                        <td align="center"><%=state%></td>
                        <td align="center"><%if state = "<font color=""blue"">신청</font>" then%>
                                                <button onclick="exchange_put('Y',<%=no%>);" class="btn btn-warning btn-xs">승인</button>
                                            <%end if%>
                                            <%if state <> "완료" and state<>"취소" then%>
                                                <button onclick="exchange_put('C',<%=no%>);" class="btn btn-success btn-xs">취소</button>
                                            <%end if%>
                                            <%if state <> "완료" then%>                                                
                                                <button onclick="exchange_put('D',<%=no%>);" class="btn btn-danger btn-xs">삭제</button>
                                            <%end if %></td>
                        <td align="center"><%=request_date%></td>
                    </tr>
                         <%
                         listnumber = listnumber-1

	                    Next
     
                   end if
                   closeGameDB
                   if RecordCount > 0 then
                   %>
                    <tr bgcolor="#FCF7ED" height="25" style="font-weight: bold"> 
	                    <td align="center"><b>합 계</b></td>      
                        <td align="center">&nbsp;</td>                        
                        <td align="center">&nbsp;</td>                        
                        <td align="center">&nbsp;</td>                        
                        <td align="center">&nbsp;</td>                        
                        <td align="center">&nbsp;</td>                        
                        <td align="center">&nbsp;</td>                        
                        <td align="center">&nbsp;</td>                                                              
                        <td align="center">&nbsp;</td>                        
                        <td align="center">&nbsp;</td>                        
                        <td align="right" style="padding-right:20px"><font color="red"><%=formatnumber(tot_before_amt,0)%></font></td>
                        <td align="right" style="padding-right:20px"><font color="red"><%=formatnumber(tot_exchange_amt,0)%></font></td>
                        <td align="right" style="padding-right:20px"><font color="red"><%=formatnumber(tot_after_amt,0)%></font></td>
                        <td align="center">&nbsp;</td>                                                
                        <td align="center">&nbsp;</td>                        
                        <td align="center">&nbsp;</td>                        
                    </tr>
                    <%end if %>             
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
        var oTable = $('#charge_list_table').DataTable({
            "bPaginate": false,
            "bFilter": false,
            "sort": false
        });
        //$("#tot_sum_td").attr("colspan", 2);        

    })
</script>
  </body>
</html>
