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
stime = Request("stime")
lyear = Request("lyear")
lmonth = Request("lmonth")
lday = Request("lday")
ltime = Request("ltime")
if stime = "" then stime = "14"
if ltime = "" then ltime = hour(now())

if Request("smonth") <> "" and Request("sday") <> "" then    
sdate = syear & "-" & putZero(smonth) & "-" & putZero(sday) & " " & putZero(stime) & ":00:00"
else
if cint(hour(now()))>-1 and cint(hour(now()))<14 then
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
take_id = trim(Request("take_id"))

page_size = Request("page_size")
page = Request("page")

if page = "" then
	page = 1
end if

realuser = Request("realuser")
If realuser = "" Then realuser = "N"

'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size
connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear=" & lyear & "&lmonth=" & lmonth & "&lday=" & lday & "&page_size=" & page_size & "&take_id=" & take_id & "&stime=" & stime & "&ltime=" & ltime 
parameters = parameters & "&realuser=" & realuser

move_url = "jackpotlist.asp?" & parameters
sql=" select count(j_money) from JackpotLog a inner join users b on a.user_id=b.user_id  where 1=1 and b.user_distributor1_link="&request.Cookies(admincheck)("adminNO")
authtitle = "본사"

if syear <> "" and lyear <> "" then 
	searchSQL = " and game_date between '"& sdate &"' and '"& ldate &"'"
else
    searchSQL = " and game_date between '"& sdate &"' and '"& ldate &"'"
end if
if take_id <> "" then 
	searchSQL = searchSQL&" and a.user_id like '%"& take_id &"%'"
end If

If realuser = "Y" Then
	searchSQL = searchSQL & " and b.user_distributor15_link <> '12' "
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
                    <h3>잭팟 목록</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <form name="frm1" method="post" action="?" class="form-horizontal">
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
                                &nbsp;시 
                                   
                                &nbsp;&nbsp;유저ID<input type="text" class="form-control" name="take_id" size="20" value="<%=take_id%>" onFocus="this.select()" onkeypress="if(event.keyCode == 13) javascript:goWrite();">
                                &nbsp;&nbsp;<input type="radio" class="radio form-control" name="realuser" value="N" <% If realuser = "N" Then Response.write "checked" End If %>/>전체 
                                            <input type="radio" class="radio form-control" name="realuser" value="Y" <% If realuser = "Y" Then Response.write "checked" End If %>/>실유저
                                &nbsp;&nbsp;<input type=button class="btn btn-info form-control" name=headregist value=" 검색 " onClick="goWrite()">                                    
                                </div>
                            </div>
                        </div>                            
                     </form>
                    <table id="boss_deal_pay_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
                           <th style="text-align:center;width:4%;"><b>NO</b></th>     
                           <th style="text-align:center;width:6%;"><b>본사ID</b></th>   
                            <th style="text-align:center;width:10%;"><b>총판ID</b></th>
                            <th style="text-align:center;width:10%;"><b>매장ID</b></th>
                            <th style="text-align:center;width:10%;"><b>유저ID</b></th>
                            <th style="text-align:center;width:10%;"><b>게임ID</b></th>
	                        <th style="text-align:center;width:10%;"><b>게임 종류</b></th>
                            <th style="text-align:center;width:10%;"><b>잭팟타입</b></th>        
                            <th style="text-align:center;width:10%;"><b>잭팟금액</b></th>
                            <th style="text-align:center;width:5%;"><b>잭팟일자</b></th>
                            <th style="text-align:center;width:15%;"><b>시간</b></th>
                        </tr>
                      </thead>
                      <tbody>
                       <%
    
   	                    if RecordCount = 0 then
                     %>
                        <script type="text/javascript">
                            $(document).ready(function () {
                                $("#charge_td2").attr("colspan", 11);

                            })
                        </script>
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td id="charge_td2" align="center" height="25"><b>등록된 기록이 없습니다.</b></td>
                        </tr>
                      <%else 
                      if take_id <> "" Then
	                    If realuser = "Y" Then
		                    searchSQL = " and b.user_distributor15_link <> '12' "
	                    End If

                        sql="select * from (select row_number() over(order by game_date desc) as num,'s' as sdfsd, 'sdfsd' as sdfdd, a.*,b.user_avata,b.user_nick from JackpotLog a inner join users b on a.user_id=b.user_id where b.user_distributor1_link="&request.Cookies(admincheck)("adminNO")&" and a.user_id like '%"&take_id&"%' and game_date between '"& sdate &"' and '"& ldate &"' " & searchSQL & " ) t WHERE	T.num BETWEEN("&int((page-1)*PageSize)&"+1) AND ("&page&" * "&PageSize&") ORDER BY	game_date desc"
                      else
	                    If realuser = "Y" Then
		                    searchSQL = " and b.user_distributor15_link <> '12' "
	                    End If

                        sql="select * from (select row_number() over(order by game_date desc) as num,'s' as sdfsd, 'sdfsd' as sdfdd, a.*,b.user_avata,b.user_nick from JackpotLog a inner join users b on a.user_id=b.user_id where b.user_distributor1_link="&request.Cookies(admincheck)("adminNO")&" and game_date between '"& sdate &"' and '"& ldate &"' " & searchSQL & " ) t WHERE T.num BETWEEN("&int((page-1)*PageSize)&"+1) AND ("&page&" * "&PageSize&") ORDER BY game_date desc"
                      end if
  
                        RegList = GetString_List(sql)
    
                        Record_String = RegList  
                                cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber
	                        Rows = split(RegList,RowDel)
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)      
                                no       = Cols(2)
                                game_id  = Cols(3)
                                take_id  = Cols(6)
                                if take_id <> "" then
                                    sql=" select shop_id,chongpan_id,jisa_id from v_member_list01 a with(nolock) where user_id='"&take_id&"'"
                                    below_list = split(replace(GetString_List(sql),RowDel,""),ColDel)
                                    if isarray(below_list) = true then
                                        shop_id = below_list(0)
                                        chongpan_id = below_list(1)                    
                                        jisa_id = below_list(2)     
                                    end if
                                end if
                                game_type= Cols(4)               
                                j_type= Cols(5)                     
                                select case j_type
                                        case "1"
                                        j_type="패턴골프"
                                        case "2"
                                        j_type="충전잭팟"
                                        case "3"
                                        j_type="예시잭팟"
                                        case "10"
                                        j_type="500판 머니"
                                        case "11"
                                        j_type="1000판 머니"
                                        case "20"
                                        j_type="100승 머니"
                                        case "21"
                                        j_type="200승 머니"
                                        case "22"
                                        j_type="300승 머니"
                                         case "31"
                                        j_type="골프"
                                         case "32"
                                        j_type="세컨"
                                         case "52"
                                        j_type="2연승"
                                         case "53"
                                        j_type="3연승"
                                         case "54"
                                        j_type="4연승"
                                         case "55"
                                        j_type="5연승"
                                         case "33"
                                        j_type="써드"
                                end select
                                j_money= cdbl(Cols(7))
                                request_date= Cols(8) 
                                user_avata = Cols(9) 
                                user_nick = Cols(10) 
                      %>
                        <tr height="25" style="font-weight: bold"> 
	                        <td align="center"><b><%=listnumber%></b></td>
                            <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=jisa_id%></font></td>
                            <td align="center"><font color="<%if cstr(user_avata) = "0" then%>red<%else%>blue<%end if%>"><%=chongpan_id%></font></td>
                            <td align="center"><font color="<%if cstr(user_avata) = "0" then%>blue<%else%>blue<%end if%>"><%=shop_id%></font></td>
	                        <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=take_id%></font></td>     
                            <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=user_nick%></font></td>     
                            <td align="center"><b><%=game_id%></b></td>
                            <td align="center"><%=game_type%></td>
                            <td align="center"><%=j_type%></td>
                            <td align="right" style="padding-right:20px"><%=formatnumber(j_money,0)%></td>
                            <td align="center"><%=request_date%></td>        
                        </tr>
                             <%
                             listnumber = listnumber-1
                             tot_aftermoney = tot_aftermoney + cdbl(j_money)
	                        Next
     
                       end if
                       closeGameDB
                       if RecordCount > 0 then
                       %>
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td align="center"><b>합 계</b></td>
                            <td align="center">&nbsp;</td>     
                            <td align="center">&nbsp;</td>
                            <td align="center">&nbsp;</td>     
                            <td align="center">&nbsp;</td>
                            <td align="center">&nbsp;</td>
                            <td align="center">&nbsp;</td>     
                            <td align="center">&nbsp;</td>     
                            <td align="center">&nbsp;</td>
                            <td align="right" style="padding-right:20px;"><font color="red"><%=formatnumber(tot_aftermoney,0)%></font></td>        
                            <td align="center">&nbsp;</td>     
                        </tr>
                       <%end if%>
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
