<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<%
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if IDAuth = 3 then
dis_no = request.Cookies(admincheck)("adminNo")
chongpan_no = dis_no
bonsa_no    = Request("bonsa_no")
else
response.Write "<script>history.back()</script>"
response.end
end if
connectionGameDB("PNC")    
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
            alert("회원ID를 입력해 주세요!");
            f.chongpan_id.focus();
            return;
        }
        if (f.chongpan_name.value == "") {
            alert("닉네임을 입력해 주세요!");
            f.chongpan_name.focus();
            return;
        }
        if (f.exist_id.value == "N") {
            alert("회원ID를 조회해 주세요!");
            f.request_id.focus();
            return;
        }

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
        if (f.chongpan_cepwd.value != f.chongpan_cepwd_chk.value) {
            alert("환전 패스워드가 일치하지 않습니다!");
            f.chongpan_cepwd.value = "";
            f.chongpan_cepwd_chk.value = "";
            f.chongpan_cepwd.focus();
            return;
        }
        
        if (f.chongpan_pwd.value == f.chongpan_cepwd.value) {
            alert("환전 패스워드는 중복될 수 없습니다!\n다시 입력해 주세요!");
            f.chongpan_cepwd.value = "";
            f.chongpan_cepwd_chk.value = "";
            f.chongpan_cepwd.focus();
            return;
        }
        if (confirm("이대로 등록하시겠습니까?")) {
            document.frm1.target = "Hframe";
            document.frm1.submit();
        }

    }

    function chk_nick() {
        var f = document.frm1;
        var id = f.chongpan_name.value;
        if (f.chongpan_name.value == "") {
            alert("닉네임을 입력해 주세요!");
            f.chongpan_name.focus();
            return;
        }
        $.get("/$adm/member/view_member_nick.asp?request_id=" + id, function (data, status) {
            if (data == 0) {
                f.exist_nick.value = 'Y';
            } else {
                f.exist_nick.value = 'N';
            }
        });

    }
    function chk_id() {
        var f = document.frm1;
        var id = f.chongpan_id.value;
        if (f.chongpan_id.value == "") {
            alert("회원ID를 입력해 주세요!");
            f.chongpan_id.focus();
            return;
        }
        $.get("/$adm/member/view_member_id.asp?request_id=" + id, function (data, status) {
            if (data == 0) {
                alert(Msg_CorrectCode);
                f.exist_id.value = 'Y';
            } else {
                alert(Msg_EmptyCode);
                f.exist_id.value = 'N';
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
            if (code == 0) {
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
                    <h2>회원 추가</h2>
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
                  <table><tr><td height="30"></td></tr></table>                         
                    <form data-parsley-validate class="form-horizontal form-label-left" name="frm1" method="post" action="insert_member_ok.asp">
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">매장ID
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                             <label class="control-label" for="user_id"><%=request.Cookies(admincheck)("adminID")%></label>
                          
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-inline form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">회원ID
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="chongpan_id" class="date-picker form-control col-md-6 col-sm-6 col-xs-11" style="ime-mode:disabled;" name="chongpan_id" type="text" maxlength="20" />
                            &nbsp;<input type="button" onclick="chk_id()" class="form-control btn-info col-md-6 col-sm-6 col-xs-1 btn-xs" value="  조회  ">
                        </div>
                      </div>
                      <div class="ln_solid"></div>                     
                     <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">닉네임
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input type="text" class="date-picker form-control col-md-7 col-xs-12" name="chongpan_name" maxlength="20" />
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                     <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">전화번호
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input type="text" class="date-picker form-control col-md-7 col-xs-12" name="chongpan_hp" maxlength="20" />
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="chongpan_pwd" class="date-picker form-control col-md-7 col-xs-12" style="ime-mode:disabled;" name="chongpan_pwd" type="password">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>                     
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드 확인
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="chongpan_pwd_chk" class="date-picker form-control col-md-7 col-xs-12" style="ime-mode:disabled;" name="chongpan_pwd_chk" type="password">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>    
                        <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">환전 패스워드 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="chongpan_cepwd" class="date-picker form-control col-md-7 col-xs-12" style="ime-mode:disabled;" name="chongpan_cepwd" type="password">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>                     
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">환전 패스워드 확인
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="chongpan_cepwd_chk" class="date-picker form-control col-md-7 col-xs-12" style="ime-mode:disabled;" name="chongpan_cepwd_chk" type="password">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>                              
                      <br />
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                          <button class="btn btn-primary" onclick="goWrite();return false" type="button">등록</button>
						  <button class="btn btn-info" onclick="document.location.href='<%=DefaultPage%>'" type="reset">돌아가기</button>
                        </div>
                      </div>
                        <input type="hidden" name="user_id" value="<%=user_id%>" />
                        <input type="hidden" name="exist_id" value="N" />
                        <input type="hidden" name="exist_nick" id="exist_nick" value="N" />
                        
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
