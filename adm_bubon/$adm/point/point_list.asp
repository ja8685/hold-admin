<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
    'on error resume next
IDAuth = cdbl(request.Cookies(admincheck)("IDAuth"))  

page_size = Request("page_size")
page = Request("page")
keyfield = request("keyfield")
keyword = request("keyword")
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
end If

realuser = Request("realuser")
If realuser = "" Then realuser = "N"

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id
parameters = parameters & "&realuser=" & realuser

move_url = "jungsan_list.asp?" & parameters
sql=" select count(a.number) from PointChangeLog a with(nolock) inner join v_member_list01 b with(nolock) on a.user_id=b.user_id"
sql=sql&" inner join users c on a.user_id=c.user_id where a.date between '"&sdate&"' and '"&ldate&"' and c.user_distributor15_link in ("&request.Cookies(admincheck)("BubonJisaNo")&")"
if keyword <> "" then 
	searchSQL = " and " & keyfield & " like '%"& keyword &"%'"
end If
If realuser = "Y" Then
	searchSQL = searchSQL & " and b.jisa_id <> '마스터' "
End If
connectionGameDB("PNC")
RecordCount = CDbl(Replace(GetString_List(sql&searchSQL),RowDel,""))
'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size
'response.Write request.Cookies(admincheck)("BubonJisaNo")
'총 페이지수
PageCount = int((RecordCount-1)/PageSize) + 1
 %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    var Msg_EmptyCode = "아이디가 존재하지 않습니다!";
    var Msg_UnknownCode = "환전가능 금액이 없습니다!";
    function isNumber() {
        re = /[^0-9]/gi;
        if (re.test(document.frm1.gold_amt.value)) {
            alert("숫자만 입력하세요");
            val.value = val.value.replace(re, "");
            return;
        }
    }
    function goWrite() {
        var f = document.frm1;
        if (f.gold_amt.value == "") {
            alert("머니를 입력해 주세요!");
            f.gold_amt.focus();
            return;
        }
        if (isNaN(f.gold_amt.value)) {
            alert("숫자만 입력해 주세요!");
            f.gold_amt.focus();
            return;
        }
        if (f.request_id.value == "" && f.request_nick.value == "") {
            alert("ID를 입력해 주세요!");
            f.request_id.focus();
            return;
        }
        if (f.possible_ex_amt.value == "") {
            alert("ID를 조회해 주세요!");
            f.request_id.focus();
            return;
        }

        var gold_amt = f.possible_ex_amt.value.replace(/,/gi, "");
        if (Number(gold_amt) < Number(f.gold_amt.value)) {
            alert("선물머니가 보유머니를 초과하였습니다!");
            f.gold_amt.focus();
            return;
        }
        var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
        while (_regExp.test(f.gold_amt.value)) {
            f.gold_amt.value = f.gold_amt.value.replace(_regExp, "$1,$2");
        }
        if (confirm(f.request_id.value + "님의 머니중 " + f.gold_amt.value + "머니를 선물 하시겠습니까?")) {
            f.possible_ex_amt.value.replace(/,/gi, "");
            f.gold_amt.value.replace(/,/gi, "");
            document.frm1.target = "Hframe";
            document.frm1.submit();
        } else {
            f.possible_ex_amt.value = f.possible_ex_amt.value.replace(/,/gi, "");
            f.gold_amt.value = f.gold_amt.value.replace(/,/gi, "");
        }
    }
    function chk_id() {
        var f = document.frm1;
        var id = f.request_id.value;
        var nick = f.request_nick.value;
        var url = "/$adm/patriot/view_usergold.asp?request_id=" + escape(id) + "&request_nick=" + nick + "&grade=" + f.grade.value;
        if (f.request_id.value == "" && f.request_nick.value == "") {
            alert("ID를 입력해 주세요!");
            f.request_id.focus();
            return;
        }
        if (f.request_id.value != "" && f.request_nick.value != "") {
            alert("ID와 닉네임중 하나만 입력해 주세요!");
            f.request_id.focus();
            return;
        }
        Request_Proc(url);
    }
    function numberComma(str) {
        var e = str;
        var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
        while (_regExp.test(e)) {
            e = e.replace(_regExp, "$1,$2");
        }
        return e;
    }
    function Request_Proc(pageUrl) {
        var xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");

        xmlRequest.Open("POST", pageUrl, true);
        xmlRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xmlRequest.onreadystatechange = function () { GetResultCode(xmlRequest) }
        xmlRequest.Send(null);
    }
    //서버로부터 받은 결과코드를 인자로 들어온 함수에 매핑
    function GetResultCode(xmlRequest) {
        if (xmlRequest == null || xmlRequest.readyState != 4) return;
        //if(xmlRequest.responseText.length == 0) return;

        var resultCode = xmlRequest.responseText;
        //결과처리        
        ProcessByResultCode(resultCode);

    }
    function ProcessByResultCode(code) {
        var f = document.frm1;
        if (code != "" && code != null) {
            if (code.substr(0, 2) != 0) {
                var msg = ConvertObj(ConvertObj(code));
                if (msg != null) {
                    var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
                    f.possible_ex_amt.value = msg;
                    while (_regExp.test(f.possible_ex_amt.value)) {
                        f.possible_ex_amt.value = f.possible_ex_amt.value.replace(_regExp, "$1,$2");
                    }
                    return;
                }
            }
            else {
                f.possible_ex_amt.value = "0";
                alert(Msg_UnknownCode);
            }
        }
        else {
            alert(Msg_EmptyCode);
        }
    }

    function ConvertObj(code) {
        return eval(code);
    }
    function isNumber(str) {
        re = /[^0-9]/gi;
        if (re.test(str)) {
            alert("숫자만 입력하세요");
            val.value = val.value.replace(re, "");
            return;
        }
    }
    function goWrite2() {
        document.frm2.submit();
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
                    <h3>포인트 전환내역</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <form name="frm2" id="frm2" method="post" action="?" class="form-horizontal">
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
		                        <select class="select2_single form-control" name="keyfield">
                                    <option value="b.user_id" <%if keyfield="b.user_id" then response.write "selected" end if%>>ID</option>            
                                </select>
                                &nbsp;&nbsp;<input type="text" class="form-control" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()">
                                &nbsp;&nbsp;<input type="radio" class="radio form-control" name="realuser" value="N" <% If realuser = "N" Then Response.write "checked" End If %>/>전체 
                                            <input type="radio" class="radio form-control" name="realuser" value="Y" <% If realuser = "Y" Then Response.write "checked" End If %>/>실유저
                                &nbsp;&nbsp;<input type=button class="btn btn-info form-control" name=headregist value=" 검색 " onclick="document.getElementById('frm2').submit()">


                                </div>
                            </div>
                        </div>                            
                     </form>
                    <table id="boss_deal_pay_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>NO</b></th>
                            <th style="text-align:center" height="25"><b>본사</b></th>
                            <th style="text-align:center" height="25"><b>총판</b></th>
                            <th style="text-align:center" height="25"><b>매장</b></th>
                            <th style="text-align:center" height="25"><b>유저ID</b></th>
                            <th style="text-align:center" height="25"><b>전환포인트</b></th>
                            <th style="text-align:center" height="25"><b>남은포인트</b></th>        
                            <th style="text-align:center" height="25"><b>전환일자</b></th>
                        </tr>
                      </thead>
                      <tbody>
                      <%
    
   	                    if RecordCount = 0 then
                     %> 
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td id="charge_td2" align="center" height="25"><b>등록된 내역이 없습니다.</b></td>
                        </tr>
                      <%else 
                        sql=" select top "&PageSize&" a.*,b.jisa_id,b.chongpan_id,b.shop_id from PointChangeLog a with(nolock) inner join"
                         sql=sql&" v_member_list01 b with(nolock) on a.user_id=b.user_id inner join users c on a.user_id=c.user_id where a.date between '"&sdate&"' and '"&ldate&"'"
                         sql=sql&" "&searchSQL&" and c.user_distributor15_link in ("&request.Cookies(admincheck)("BubonJisaNo")&") and a.number not in (select top "&int((page-1)*PageSize)&" a.number from PointChangeLog a with(nolock) "
                         sql=sql&" inner join v_member_list01 b with(nolock) on a.user_id=b.user_id inner join users c on a.user_id=c.user_id where  a.date between '"&sdate&"'"
                         sql=sql&" and '"&ldate&"' "&searchSQL&" and c.user_distributor15_link in ("&request.Cookies(admincheck)("BubonJisaNo")&") order by a.date desc) order by date desc"
	
                        RegList = GetString_List(sql)    
                        Record_String = RegList  
    	
	                        Rows = split(RegList,RowDel)
                            cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)      
                                no          = Cols(0)
                                user_id   = Cols(1)
                                gold_amt    = Cols(2)
                                rest_amt    = Cols(3)
                                reg_date    = Cols(4)      
                                jisa_id    = Cols(5)      
                                chongpan_id    = Cols(6)      
                                shop_id    = Cols(7)      
                                if gold_amt = "" then
                                    gold_amt = 0           
                                end if
            
                                %>
 
                        <tr height="25" style="font-weight: bold"> 
	                        <td align="center"><b><%=listnumber%></b></td>
	                        <td align="center"><%=jisa_id%></td>
	                        <td align="center"><%=chongpan_id%></td>
	                        <td align="center"><%=shop_id%></td>
	                        <td align="center"><%=user_id%></td>
                            <td align="right"><font color="red"><%=FormatNumber(gold_amt,0)%></font></td>
                            <td align="right"><%=FormatNumber(rest_amt,0)%></td>
                            <td align="left"><%=reg_date%></td>        
                        </tr>
                             <%
                             listnumber = listnumber-1
                              from_user = ""
                              to_user=""  
                              tot_gold_amt = tot_gold_amt + cdbl(gold_amt)
                              tot_rest_amt = tot_rest_amt + cdbl(rest_amt)
                              gold_amt =""
		                      rest_amt=""
	                        Next
     
                       end if
                       closeGameDB
                       if RecordCount > 0 then
                       %>
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td align="center"><b>합  계</b></td>
                            <td align="center"><b></b></td>
                            <td align="center"><b></b></td>
                            <td align="center"><b></b></td>
                            <td align="center"><b></b></td>
                            <td align="right"><b><font color="red"><%=FormatNumber(tot_gold_amt,0)%></font></b></td>
                            <td align="right"><b><font><%=FormatNumber(tot_rest_amt,0)%></font></b></td>
                            <td align="right"><b><font color="red">&nbsp;</font></b></td>                
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
        
    })
</script>
  </body>
</html>
