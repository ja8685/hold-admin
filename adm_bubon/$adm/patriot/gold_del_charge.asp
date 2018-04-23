<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
IDAuth = cdbl(request.Cookies(admincheck)("IDAuth"))
connectionGameDB("PNC")
page_size = Request("page_size")
page = Request("page")
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
if page = "" then
	page = 1
else 
	page = cdbl(page)
end if
adminID = request.Cookies(admincheck)("adminID")
adminNum = request.Cookies(admincheck)("adminNo")

sql="select isnull(deal_money,0) from distributor15 where user_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ")"

admin_rest_money = CDbl(Replace(GetString_List(sql),RowDel,""))

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id

keyword = request("keyword")
keyfield = request("keyfield")
move_url = "gold_del_charge.asp?" & parameters

if (keyfield = "from_user" or keyfield = "to_user") And keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " = '"& keyword &"'"
end If

sql="select count(number) from ("
sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.from_user=b.user_id"
sql=sql&" where b.jisa_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ") and grade in  (15,2,3,4)"
sql=sql&" and date between '"&sdate&"' and '"&ldate&"' " & searchSQL 
'sql=sql&" union "
'sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.to_user=b.user_id"
'sql=sql&" where b.shop_id='"&adminID&"' and grade in  (3,4)"
'sql=sql&" and date between '"&sdate&"' and '"&ldate&"' " & searchSQL & ") a"
sql=sql&" ) a"

RecordCount = CDbl(Replace(GetString_List(sql&searchSQL),RowDel,""))

'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size

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
//-->
</SCRIPT>
  <body class="nav-md">
<iframe name="Hframe" id="Hframe" style="width:0px;height:0px;display:none"></iframe>
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
                    <h3>선물 로그</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <form name="frm1" method="post" action="?" class="form-horizontal">
                       <input type="hidden" name="user_id" />                       
                        <div class="row form-inline form-group pull-right">
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
		                    <select name="keyfield" class="select2_single form-control">
                                <option value="a.user_id" <%if keyfield="a.user_id" then response.write "selected" end if%>>ID</option>                              
                            </select>                                
                            &nbsp;&nbsp;<input type="text" class="form-control" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()" />
                            &nbsp;&nbsp;<input type="button" name="headregist" class="btn btn-info form-control" value=" 검색 " onclick="goWrite()" />
                         </div>                          
                     </form>
                    <table id="boss_deal_pay_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>NO</b></th>
                            <th style="text-align:center" height="25"><b>선물한ID</b></th>
                            <th style="text-align:center" height="25"><b>선물받은ID</b></th>
                            <th style="text-align:center" height="25"><b>선물 머니</b></th>        
                            <th style="text-align:center" height="25"><b>선물일자</b></th>
                        </tr>
                      </thead>
                      <tbody>
                      <%
    
   	                    if RecordCount = 0 then
                     %>
                        <tr height="25"> 
	                        <td id="charge_td2" class="text-center" height="25"><b>등록된 내역이 없습니다.</b></td>
                        </tr>
                     <%else 

	                    sql="select top "&pageSize&" * from ("
                          sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.from_user=b.user_id where b.jisa_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ") and grade in  (15,2,3,4)"
                          sql=sql&" and date between '"&sdate&"' and '"&ldate&"'"&searchSQL
                          'sql=sql&" union "
                          'sql=sql&"   select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.to_user=b.user_id where b.shop_id='"&adminID&"' and grade in  (3,4)"
                          'sql=sql&" and date between '"&sdate&"' and '"&ldate&"'"&searchSQL
                          'sql=sql&" ) a where number not in "
                          sql=sql&" ) a where number not in "
  
                          sql=sql&" (select top "&int((page-1)*PageSize)&" number from ("
                          sql=sql&" ("
                          sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.from_user=b.user_id where b.jisa_id IN (" & request.Cookies(admincheck)("BubonJisaId") & ") and grade in  (15,2,3,4)"
                          sql=sql&" and date between '"&sdate&"' and '"&ldate&"'"&searchSQL
                         ' sql=sql&" union "
                         ' sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.to_user=b.user_id where b.shop_id='"&adminID&"' and grade in  (3,4)"
                         ' sql=sql&" and date between '"&sdate&"' and '"&ldate&"'"&searchSQL
                          sql=sql&" )) b order by date desc)"
                          sql=sql&" order by date desc"



                        RegList = GetString_List(sql)    
                        Record_String = RegList  
    	
	                        Rows = split(RegList,RowDel)
                            cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber
	                         For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)      
                                no          = Cols(0)
                                grade       = "회원"
                                send_id     = Cols(1)
                                user_id     = Cols(2)
                                gold_amt    = Cols(3)
                                if gold_amt = "" then
                                    gold_amt = 0
                                end if           
                                reg_date    = Cols(4)
                        %> 
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td align="center" style="color:blue"><b><%=listnumber%></b></td>
	                        <td align="center" style="color:blue"><%=send_id%></td>
                            <td align="center" style="color:blue"><%=user_id%></td>
                            <td align="right" style="color:blue"><%=FormatNumber(gold_amt,0)%></td>
                            <td align="center" style="color:blue"><%=reg_date%></td>
                        </tr>                        
                        <%                        
                             listnumber = listnumber-1
                             tot_gold_amt = tot_gold_amt + cdbl(gold_amt)
	                        Next
     
                       end if
                       closeGameDB
                       %>
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td align="center"><b>합  계</b></td>
                            <td align="center">&nbsp;</td>
                            <td align="center">&nbsp;</td>                            
                            <td align="right"><b><font color="red"><%=FormatNumber(tot_gold_amt,0)%></font></b></td>                            
                            <td align="center">&nbsp;</td>
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
                      <br />                                          
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
        <%if RecordCount = 0 then%>
            $("#charge_td2").attr("colspan", 9);
        <%end if%>
        var oTable = $('#boss_deal_pay_list_table').DataTable({
                "bPaginate": false,
                "bFilter": false,
                "sort": false
            });
        //$("#tot_sum_td").attr("colspan", 2);        

    });
</script>
  </body>
</html>
