<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%on error resume next
IDAuth = cdbl(request.Cookies(admincheck)("IDAuth"))
keyword = URLDecode(Request("keyword"))
keyfield = URLDecode(Request("keyfield"))
page_size = Request("page_size")
page = Request("page")
if page = "" then
	page = 1
else 
	page = cdbl(page)
end If


realuser = Request("realuser")
If realuser = "" Then realuser = "N"

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id
parameters = parameters & "&realuser=" & realuser &"&keyword=" & server.URLEncode(keyword) 
move_url = "userblacklist.asp?" & parameters
if keyword <> "" then 
	searchSQL = " and " & keyfield & " like '%"& keyword &"%'"
end if    



'sql=" select count(a.number) from t_gold_del_charge_log a inner join v_member_admin_list b on a.user_id=b.user_id"
'sql=sql&" where send_grade=1 and send_id='"&request.Cookies(admincheck)("adminID")&"' "&searchSQL
sql=" select count(idx) from TB_User_BlackList a inner join users b on a.midx=b.number where 1=1"
  
connectionGameDB("PNC")
RecordCount = CDbl(Replace(GetString_List(sql&searchSQL),RowDel,""))
'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size
    
'총 페이지수
PageCount = int((RecordCount-1)/PageSize) + 1
sql="update connectedusers set black_list='N'"
'DBconn.Execute(sql)         
GetString_List(sql)
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

        if (f.reg_desc.value == "") {
            alert("충전/회수 사유를 입력해 주세요!");
            f.reg_desc.focus();
            return;
        }
        if (confirm(f.request_id.value + "님을 블랙리스트로 등록 하시겠습니까?")) {
            document.frm1.target = "Hframe";
            document.frm1.submit();
        } else {
            f.possible_ex_amt.value = "";
        }

    }
    function chk_id() {
        var f = document.frm1;
        var id = f.request_id.value;
        var nick = f.request_nick.value;
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
        $.get("view_userblacklist.asp?request_id=" + escape(id) + "&request_nick=" + escape(nick), function (data, status) {
            if (data != "0") {
                alert("존재하는 아이디입니다.!");
                f.possible_ex_amt.value = "Y";
                f.request_number.value = data;
                return;
            } else {
                alert("존재하지 않는 아이디입니다.!");
                f.request_id.value = "";
                f.request_nick.value = "";
                f.possible_ex_amt.value = "";
                f.request_number.value = "";
                f.request_id.focus();
                return;
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
            val.value = val.value.replace(re, "");
            return;
        }
    }
    function goWrite2() {
        document.frm2.submit();
    }
    function update_st(no, st) {
        var str = st;
        if (str == 0) {
            if (confirm("블랙리스트로 변경하시겠습니까?")) {
                Hframe.location.href = "update_blacklist_status.asp?no=" + no + "&str=" + st;
            }
        }
        if (str == 1) {
            if (confirm("블랙리스트를 해제 하시겠습니까?")) {
                Hframe.location.href = "update_blacklist_status.asp?no=" + no + "&str=" + st;
            }
        }
        if (str == 2) {
            if (confirm("블랙리스트를 삭제 하시겠습니까?")) {
                Hframe.location.href = "update_blacklist_status.asp?no=" + no + "&str=" + st;
            }
        }
    }
    //-->
</SCRIPT>
  <body class="nav-md">
<iframe name="Hframe" style="width:0px;height:0px;display:none"></iframe>
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
                    <h3>블랙리스트</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <div class="row">
                        <form name="frm2" class="form-inline form-group" method="post" action="?">
                            <table border="0" cellpadding="3" cellspacing="1" width="90%">
                                <tr> 
                                <td align="right" width="100%">
		                            <select name="keyfield" class="select2_single form-control">
                                        <option value="a.user_id" <%if keyfield="b.user_id" then response.write "selected" end if%>>ID</option>
                                        <option value="b.user_nick" <%if keyfield="b.user_nick" then response.write "selected" end if%>>닉네임</option>            
                                    </select>
                                    &nbsp;&nbsp;<input type="text" class="form-control" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()">        
                                    &nbsp;&nbsp;<input type=button class="btn btn-primary form-control" name=headregist value=" 검색 " onClick="goWrite2()">
                                </td>	
                                </tr>
                            </table>
                        </form>
                    </div>        
                    <table id="member_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>                         
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>NO</b></th>
                            <th style="text-align:center" height="25"><b>본사ID</b></th>
                            <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>매장ID</b></th>
                            <th style="text-align:center" height="25"><b>유저ID</b></th>
                            <th style="text-align:center" height="25"><b>닉네임</b></th>
	                        <th style="text-align:center" height="25"><b>등록일자</b></th>
                            <th style="text-align:center" height="25"><b>해제일자</b></th>
                            <th style="text-align:center" height="25"><b>사유</b></th>
                            <th style="text-align:center" height="25"><b>상태</b></th> 
                        </tr>
                      </thead>
                      <tbody>
                   <%
                        sql="     select top "&PageSize&" b.number, a.jisa_id,a.chongpan_id,a.shop_id,a.user_id,b.user_nick,c.blacklist,c.reg_date,c.del_date,c.reg_desc from v_member_list01 a"
                        sql=sql&" inner join users b on a.user_id=b.user_id"
                        sql=sql&" inner join TB_User_BlackList c on b.number=c.midx"
                        sql=sql&" where b.number not in (select top "&int((page-1)*PageSize)&" b.number from v_member_list01 a"
                        sql=sql&" inner join users b on a.user_id=b.user_id"
                        sql=sql&" inner join TB_User_BlackList c on b.number=c.midx where 1=1"&searchSQL&")"
                        sql=sql&searchSQL
                        sql=sql&" order by c.reg_date desc "

                            RegList = GetString_List(sql)    
                            Record_String = RegList  
   	                        if RegList = "" then
                         %>
                            <tr bgcolor="#FCF7ED" height="25"> 
	                            <td align="center" height="25" colspan="10"><b>등록된 블랙리스트가 없습니다.</b></td>
                            </tr>
                          <%else 
    	                        cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                                listnumber = RecordCount - cnumber    	
	                            Rows = split(RegList,RowDel)
        
	                            For i = 0 to UBound(Rows)-1
		                            Cols = split(Rows(i),ColDel)      
                                    no       = Cols(0)
                                    jisa_id = Cols(1)
                                    chongpan_id = Cols(2)
                                    shop_id = Cols(3)
                                    user_id = Cols(4)
                                    user_nick = Cols(5)
                                    User_status = Cols(6)
                                    if User_status="Y" then
                                      User_status="<font color=""red"">블랙리스트</font>"
                                    else
                                        User_status="<font color=""gray"">해제</font>"
                                    end if

                                    reg_date = Cols(7)
                                    del_date = Cols(8)
                                    del_desc = Cols(9)
           
                          %>
                            <tr bgcolor="#FCF7ED" height="25"> 
	                            <td align="center"><b><%=listnumber%></b></td>
	                            <td align="center"><b><%=jisa_id%></b></td>
                                <td align="center"><b><%=chongpan_id%></b></td>
                                <td align="center"><b><%=shop_id%></b></td>
                                <td align="center"><b><%=user_id%></b></td>        
                                <td align="center"><b><%=user_nick%></b></td>        
                                <td align="center"><b><%=reg_date%></b></td>
                                <td align="center"><b><%=del_date%></b></td>
                                <td align="center"><b><%=del_desc%></b></td>        
                                <td align="center"><b><%=User_status%><br />
                                    <input type="button" class="btn btn-primary btn-xs form-control" value="해제" onclick="update_st(<%=no %>,1)" />
                                    <input type="button" class="btn btn-success btn-xs form-control" value="등록" onclick="update_st(<%=no %>,0)" />
                                    <input type="button" class="btn btn-danger btn-xs form-control" value="삭제" onclick="update_st(<%=no %>,2)"  />
                                    </td>                
                            </tr>
                                 <% listnumber = listnumber-1      
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
                            <!-- 페이지 이동 -->
		                    <%=PageMove(move_url)%>
		                    <!-- 페이지 이동 -->
                          </div>
                          <div class="col-xs-1">
                          </div>
                      </div>    
                    <form class="form-horizontal form-label-left" name="frm1" id="frm1" method="post" action="update_blacklist_status.asp">                                                                                                  
                        <input type="hidden" name="possible_ex_amt" />
                        <input type="hidden" name="request_number" />
                      <div class="form-inline form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">ID
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12 form-inline">
                            <label class="form-control col-sm-2">ID :     </label><input type="text" name="request_id" id="request_id" class="form-control col-sm-2" /> 
                            <label class="form-control col-sm-2">닉네임 : </label><input type="text" name="request_nick" id="request_nick" class="form-control col-sm-2" /> 
                                     <input type="button" class="btn btn-info form-control" onclick="chk_id()" value=" 유저 조회  ">
                        </div>
                      </div>
                      <div class="ln_solid"></div>  
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">블랙리스트 등록 사유
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                            
                            <textarea cols="150" rows="6" name="reg_desc" class="date-picker form-control col-md-7 col-xs-12"></textarea>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <br />
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                          <button class="btn btn-primary" onclick="goWrite();return false" type="button">등록</button>
						  <button class="btn btn-info" onclick="history.back()" type="reset">돌아가기</button>
                        </div>
                      </div>
                    </form>                      
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
