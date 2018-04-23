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
if page_size = "" then page_size = 20
PageSize = page_size
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

sql="select deal_money from distributor3 where user_id IN ('" & request.Cookies(admincheck)("adminID") & "')"
admin_rest_money = CDbl(Replace(GetString_List(sql),RowDel,""))
keyword = request("keyword")
keyfield = request("keyfield")

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id


move_url = "gold_del_charge.asp?" & parameters

if (keyfield = "from_user" or keyfield = "to_user") And keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " = '"& keyword &"'"
end If

sql="select count(number) from ("
sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.from_user=b.user_id"
sql=sql&" where b.shop_id='"&adminID&"' and grade in  (3,4)"
sql=sql&" and date between '"&sdate&"' and '"&ldate&"' " & searchSQL 
'sql=sql&" union "
'sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.to_user=b.user_id"
'sql=sql&" where b.shop_id='"&adminID&"' and grade in  (3,4)"
'sql=sql&" and date between '"&sdate&"' and '"&ldate&"' " & searchSQL & ") a"
sql=sql&" ) a"

RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))

'1페이지당 리스트 개수

    
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
        if (document.getElementById("gold_amt").value == "") {
            alert("머니를 입력해 주세요!");
            document.getElementById("gold_amt").focus();
            return;
        }
        isNumber(document.getElementById("gold_amt").value);
        if (isNaN(document.getElementById("gold_amt").value)) {
            alert("숫자만 입력해 주세요!");
            document.getElementById("gold_amt").focus();
            return;
        }
        if (document.getElementById("grade").value == "") {
            alert("등급을 선택해 주세요!");
            document.getElementById("grade").focus();
            return;
        }
        if (document.getElementById("request_id").value == "") {
            alert("ID를 입력해 주세요!");
            document.getElementById("request_id").focus();
            return;
        }
        if (document.getElementById("possible_ex_amt").value == "") {
            alert("ID를 조회해 주세요!");
            document.getElementById("request_id").focus();
            return;
        }
        if (document.getElementById("request_id").value != "") {
            if (document.getElementById("request_id").value != document.getElementById("str_view_id").value) {
                alert("ID를 조회해 주세요!");
                document.getElementById("possible_ex_amt").value = "";
                document.getElementById("request_id").focus();
                return;
            }
        }
        /*
        if (document.getElementById("request_nick").value != "") {
            if (document.getElementById("request_nick").value != document.getElementById("str_view_id").value) {
                alert("닉네임을 조회해 주세요!");
                document.getElementById("possible_ex_amt").value = "";
                document.getElementById("request_nick").focus();
                return;
            }
        }
        */
        if (document.getElementById("del_charge_desc").value.length < 2) {
            alert("충전/회수 사유를 입력해 주세요!");
            document.getElementById("del_charge_desc").focus();
            return;
        }
        var gold_amt = document.getElementById("possible_ex_amt").value.replace(/,/gi, "");   
        if (Number("<%=admin_rest_money%>") < Number(document.getElementById("gold_amt").value)) {
                alert("충전머니가 보유머니를 초과하였습니다!");
                document.getElementById("gold_amt").focus();
                return;           
        }
        var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
        while (_regExp.test(document.getElementById("gold_amt").value)) {
            document.getElementById("gold_amt").value = document.getElementById("gold_amt").value.replace(_regExp, "$1,$2");
        }
        if (document.getElementById("act_type").value == "del") { var act_type = "회수" }
        else { var act_type = "충전" }
        if (confirm(document.getElementById("request_id").value + "님의 머니중 " + document.getElementById("gold_amt").value + "머니를 " + act_type + " 하시겠습니까?")) {
            document.getElementById("possible_ex_amt").value.replace(/,/gi, "");
            document.getElementById("gold_amt").value.replace(/,/gi, "");
            document.getElementById("frm1").target = "Hframe";
            document.getElementById("frm1").submit();
        } else {
            document.getElementById("possible_ex_amt").value = document.getElementById("possible_ex_amt").value.replace(/,/gi, "");
            document.getElementById("gold_amt").value = document.getElementById("gold_amt").value.replace(/,/gi, "");
        }

    }
    function chk_id() {
        var f = document.frm1;
        var id = document.getElementById("request_id").value;
        //var nick = document.getElementById("request_nick").value;
        //var url = "/$adm/patriot/view_usergold.asp?request_id=" + escape(id) + "&request_nick=" + escape(nick) + "&grade=" + document.getElementById("grade").value;
        var url = "/$adm/patriot/view_usergold.asp?request_id=" + escape(id) + "&grade=" + document.getElementById("grade").value;
        if (document.getElementById("grade").value == "") {
            alert("등급을 선택해 주세요!");
            document.getElementById("grade").focus();
            return;
        }
        if (id == "") {
            alert("ID를 입력해 주세요!");
            id.focus();
            return;
        }
        /*
        if (id != "" && nick != "") {
            alert("ID와 닉네임중 하나만 입력해 주세요!");
            id.focus();
            return;
        }
        */
        $.get("/$adm/patriot/view_usergold.asp?request_id=" + escape(id) + "&grade=" + document.getElementById("grade").value, function (code, status) {
        //$.get("/$adm/patriot/view_usergold.asp?request_id=" + escape(id) + "&request_nick=" + escape(nick) + "&grade=" + document.getElementById("grade").value, function (code, status) {
            if (code != "" && code != null) {
                    var msg = ConvertObj(ConvertObj(code));
                    if (msg != null) {
                        var _regExp = new RegExp("(-?[0-9]+)([0-9]{3})");
                        document.getElementById("possible_ex_amt").value = msg;
                        if (id != "") {
                            document.getElementById("str_view_id").value = id;
                        } else if (nick != "") {
                            document.getElementById("str_view_id").value = nick;
                        }
                        while (_regExp.test(document.getElementById("possible_ex_amt").value)) {
                            document.getElementById("possible_ex_amt").value = document.getElementById("possible_ex_amt").value.replace(_regExp, "$1,$2");
                        }
                        return;
                    }                
            }
            else {
                alert(Msg_EmptyCode);
            }
        });
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
            val.value = val.value.replace(str, "");            
            return;
        }
    }
    function goWrite2() {
        document.frm2.submit();
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
                    <form name="frm11" method="post" action="?" class="form-horizontal">
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
                                <option value="from_user" <%if keyfield="from_user" then response.write "selected" end if%>>보낸ID</option>
                                <option value="to_user" <%if keyfield="to_user" then response.write "selected" end if%>>받은ID</option>
                            </select>                                
                            &nbsp;&nbsp;<input type="text" class="form-control" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()" />
                            &nbsp;&nbsp;<input type="button" name="headregist" class="btn btn-info form-control" value=" 검색 " onclick="javascript: document.frm11.submit()" />
                         </div>                          
                     </form>
                    <table id="boss_deal_pay_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>NO</b></th>
                            <th style="text-align:center" height="25"><b>선물한ID</b></th>
                            <th style="text-align:center" height="25"><b>선물받은ID</b></th>
                            <th style="text-align:center" height="25"><b>선물 머니</b></th>        
                            <th style="text-align:center" height="25"><b>잔액</b></th>        
                            <th style="text-align:center" height="25"><b>사유</b></th>                                    
                            <th style="text-align:center" height="25"><b>선물일자</b></th>
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
                          sql="select top "&pageSize&" * from ("
                          sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.from_user=b.user_id where b.shop_id='"&adminID&"' and grade in  (3,4)"
                          sql=sql&" and date between '"&sdate&"' and '"&ldate&"'"&searchSQL
                          'sql=sql&" union "
                          'sql=sql&"   select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.to_user=b.user_id where b.shop_id='"&adminID&"' and grade in  (3,4)"
                          'sql=sql&" and date between '"&sdate&"' and '"&ldate&"'"&searchSQL
                          'sql=sql&" ) a where number not in "
                          sql=sql&" ) a where number not in "
  
                          sql=sql&" (select top "&int((page-1)*PageSize)&" number from ("
                          sql=sql&" ("
                          sql=sql&" select a.* from GiftToLog a with(nolock) inner join v_all_member_list b with(nolock) on a.from_user=b.user_id where b.shop_id='"&adminID&"' and grade in  (3,4)"
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
                                rest_amt   =  cdbl(Cols(4))
                                gift_desc    = Cols(5)
                                reg_date    = Cols(6)
                        %> 
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td align="center" style="color:blue"><b><%=listnumber%></b></td>
	                        <td align="center" style="color:blue"><%=send_id%></td>
                            <td align="center" style="color:blue"><%=user_id%></td>
                            <td align="right" style="color:blue"><%=FormatNumber(gold_amt,0)%></td>
                            <td align="right" style="color:blue"><%=FormatNumber(rest_amt,0)%></td>
                            <td align="left" style="color:blue"><%=gift_desc%></td>
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
                            <td align="center">&nbsp;</td>
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
                    <form class="form-horizontal form-label-left" name="frm1" id="frm1" method="post" action="update_gold_del_charge.asp">     
                         <input type="hidden" name="grade" id="grade" value="4" />
                         <input type="hidden" name="act_type" id="act_type" value="charge" />                                                                               
                         <input type="hidden" name="str_view_id" id="str_view_id" />
                      <div class="form-inline form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">ID
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12 form-inline">
                            <label class="form-control col-sm-2">ID :     </label><input type="text" name="request_id" id="request_id" class="form-control col-sm-2" /> 
                            <!--label class="form-control col-sm-2">닉네임 : </!--label><input type="text" name="request_nick" id="request_nick" class="form-control col-sm-2" /--> 
                            <input type="button" class="btn btn-info form-control col-sm-2" onclick="chk_id()" value="보유 머니 조회">
                        </div>
                      </div>
                      <div class="ln_solid"></div>  
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">보유 머니
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="possible_ex_amt" id="possible_ex_amt" class="form-control col-sm-2" size="20" maxlength="15" readonly="readonly" />
                        </div>
                      </div>
                      <div class="ln_solid"></div>                      
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">선물 머니
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="gold_amt" id="gold_amt" class="form-control col-sm-2" size="20" maxlength="15" />
                        </div>
                      </div>
                      <div class="ln_solid"></div>  
                        <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">선물 사유
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <textarea cols="60" class="date-picker form-control col-md-7 col-xs-12" name="del_charge_desc" id="del_charge_desc" rows="10"></textarea>                        
                        </div>
                      </div>
                      <div class="ln_solid"></div>   
                      <br />
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                          <button class="btn btn-primary" onclick="goWrite();return false" type="button">수정</button>
						  <button class="btn btn-info" onclick="history.back()" type="reset">돌아가기</button>
                        </div>
                      </div>
                    </form>                      
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
            $("#charge_td2").attr("colspan", 5);
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
