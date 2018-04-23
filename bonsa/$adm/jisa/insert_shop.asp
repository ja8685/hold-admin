<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<%
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
connectionGameDB("PNC")
if IDAuth = 2 then
dis_no = request.Cookies(admincheck)("adminNo")
chongpan_no = dis_no
bonsa_no    = Request("bonsa_no")
chongpan_id   = request.Cookies(admincheck)("adminID")
else
chongpan_no = Request("chongpan_no")
bonsa_no    = Request("bonsa_no")
sql="select user_id from distributor2 where number="&chongpan_no
chongpan_id  = Replace(GetString_List(sql),RowDel,"")            
end if
  sql="select distributor2_rate from dealer_rate_manager"
    RegList = GetString_List(sql)
    if RegList = "" then
 %>
  <%else 
    	
	    Rows = split(RegList,RowDel)
	    For i = 0 to UBound(Rows)-1
		    Cols = split(Rows(i),ColDel)
            bonsa_rate_tot = cdbl(Cols(0))		    
            sql="select distribute2_rate from distributor2 where number="&chongpan_no
            bonsa_rate_tot = cdbl(Replace(GetString_List(sql),RowDel,""))                        
            shop_rate = bonsa_rate_tot 
            if shop_rate>2.5 then
                shop_rate = 2.5
                bonsa_rate_tot = 2.5
            end if
        Next     
   end if     
   
   closeGameDB   
   
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
    var Msg_EmptyCode = "등록할 수 없는 아이디입니다!";
    var Msg_CorrectCode = "등록 가능한 아이디입니다!";
    var Msg_UnknownCode = "등록할 수 없는 아이디입니다!";
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
        var str = strLen(f.chongpan_id.value);
        if (str > 20) {
            alert("영문 20자, 한글10자 이상 입력할 수 없습니다!");
            return;
        }

        if (f.chongpan_id.value == "") {
            alert("매장ID를 입력해 주세요!");
            f.chongpan_id.focus();
            return;
        }
        if (f.chongpan_name.value == "") {
            alert("매장명을 입력해 주세요!");
            f.chongpan_name.focus();
            return;
        }
        if (f.exist_id.value == "N") {
            alert("매장ID를 조회해 주세요!");
            f.request_id.focus();
            return;
        }
        if (f.chongpan_hp.value == "") {
            alert("전화번호를 입력해 주세요!");
            f.chongpan_hp.focus();
            return;
        }
        //if (f.chongpan_mail.value == "") {
        //alert("이메일을 입력해 주세요!");
        //f.chongpan_mail.focus();
        //return;
        //}
        if (f.chongpan_pwd.value == "") {
            alert("패스워드를 입력해 주세요!");
            f.chongpan_pwd.focus();
            return;
        }
        if (f.chongpan_pwd_chk.value == "") {
            alert("패스워드를 입력해 주세요!");
            f.chongpan_pwd_chk.focus();
            return;
        }
        if (f.chongpan_pwd_chk.value != f.chongpan_pwd.value) {
            alert("패스워드가 일치하지 않습니다!");
            f.chongpan_pwd.value = "";
            f.chongpan_pwd_chk.value = "";
            f.chongpan_pwd.focus();
            return;
        }
        if (f.chongpan_rate.value == "") {
            alert("딜비수수료 비율을 입력해 주세요!");
            f.chongpan_rate.focus();
            return;
        }
        if (f.chongpan_rate.value > <%=bonsa_rate_tot %>) {
            alert("딜비수수료 비율은 <%=bonsa_rate_tot%>%를 넘을수 없습니다!");
            return;
        }
        if (confirm("이대로 등록하시겠습니까?")) {
            document.frm1.target = "Hframe";
            document.frm1.submit();
        }

    }
    function chk_id() {
        var f = document.frm1;
        var id = f.chongpan_id.value;
        if (f.chongpan_id.value == "") {
            alert("매장ID를 입력해 주세요!");
            f.chongpan_id.focus();
            return;
        }
        var xmlHttp = null;
        try {
            xmlHttp = new XMLHttpRequest();
        }
        catch (e) {
            try {
                xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
            }
            catch (e) {
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
        }
        xmlHttp.open("get", "/$adm/chongpan/view_shop_game_id.asp?request_id=" + escape(id) + "&grade=4", false);
        xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=euc-kr');
        xmlHttp.send();
        var str_id = xmlHttp.responseText;
        if (str_id > 0) {
            alert("등록할 수 없는 아이디 입니다!");
            f.exist_id.value = 'N';

        } else {
            alert("등록 가능한 아이디 입니다!");
            f.exist_id.value = 'Y';
        }

        //   Request_Proc(url);    
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
            if (code != 0) {
                //var msg = ConvertObj(ConvertObj(code));
                f.exist_id.value = 'Y';
                alert(Msg_CorrectCode);
            }
            else {
                f.exist_id.value = 'N';
                alert(Msg_UnknownCode);
            }
        }
        else {
            f.exist_id.value = 'N';
            alert(Msg_EmptyCode);
        }
    }

    function ConvertObj(code) {
        return eval(code);
    }
    function strLen(str) {
        var len = 0;
        var c;

        for (i = 0; i < str.length; i++) {
            len++;
            c = str.substring(i, i + 1).charCodeAt(0);
            if (c <= 0 || c > 255) len++;
        }
        return (len);
    }
//-->
</SCRIPT>
   <iframe name="Hframe" width="0" height="0" frameborder="0" style="display:none"></iframe>
  <body class="nav-md">
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
                    <h2>매장 추가</h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                        <ul class="dropdown-menu" role="menu">
                          <li><a href="#">Settings 1</a>
                          </li>
                          <li><a href="#">Settings 2</a>
                          </li>
                        </ul>
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">                 
                    <form class="form-horizontal form-label-left" name="frm1" method="post" action="insert_shop_ok.asp?bonsa_no=<%=bonsa_no%>&chongpan_no=<%=chongpan_no%>&bonsa_rate_tot=<%=bonsa_rate_tot%>&bonsa_rate=<%=bonsa_rate%>">                        
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">총판ID 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                             <label class="control-label" for="user_id"><%=chongpan_id%></label>
                          
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">매장ID
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id">
                              <input type="text" name="chongpan_id" maxlength="20" />&nbsp;
                          </label>
                            <input type="button" class="btn btn-success btn-sm" onclick="chk_id()" value="  조회  ">
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">매장명
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id">
                              <input type="text" name="chongpan_name" maxlength="20" />
                          </label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>  
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">전화번호
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id">
                              <input type="text" name="chongpan_hp" maxlength="20" />
                          </label>
                        </div>
                      </div>
                      <div class="ln_solid"></div> 
                     <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="user_pwd" class="date-picker form-control col-md-7 col-xs-12" name="chongpan_pwd" type="password">
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드 확인
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="user_pwd_chk" class="date-picker form-control col-md-7 col-xs-12" name="chongpan_pwd_chk" type="password">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                    <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">딜비 수수료 비율
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id">
                              <input type="text" name="chongpan_rate" value="<%=shop_rate%>" maxlength="10" />%
                                (지급가능한 수수료:<%=formatnumber(shop_rate,1)%>%)
                          </label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <br />
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                          <button class="btn btn-primary" onclick="goWrite();return false" type="button">등록하기</button>
						  <button class="btn btn-info" onclick="history.back()" type="reset">돌아가기</button>
                        </div>
                      </div>
                        <input type="hidden" name="user_id" value="<%=user_id%>" />
                        <input type="hidden" name="exist_id" value="N" />
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
    </div>
        <!-- Javascript 파일 -->
        <!-- #include virtual="/$adm/include/jQuery.asp" -->
        <!-- Javascript 파일 끝 -->
  </body>
</html>
