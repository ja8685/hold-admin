<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<%
user_id = trim(Request.Cookies(admincheck)("adminID"))
if user_id = "" then
response.End
end if
connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if IDAuth = 0 then
    sql=" select self_rate from dealer_rate_manager"
    boss_rate = CDbl(Replace(GetString_List(sql),RowDel,""))
    sql="select * from boss_distributor"
    authtitle = "루트본사"
elseif IDAuth = 1 then
    sql="select distribute1_rate from distributor1 where user_id='"&user_id&"'"
    boss_rate = CDbl(Replace(GetString_List(sql),RowDel,""))
    sql="select * from distributor1 where user_id='"&user_id&"'"
    authtitle = "본사"
elseif IDAuth = 2 then
    sql="select distribute2_rate from distributor2 where user_id='"&user_id&"'"
    boss_rate = CDbl(Replace(GetString_List(sql),RowDel,""))
    sql="select * from distributor2 where user_id='"&user_id&"'"
    authtitle = "총판"
elseif IDAuth = 3 then
    sql=" select distribute3_rate from distributor3 where number="&trim(Request.Cookies(admincheck)("adminNo"))
    boss_rate = CDbl(Replace(GetString_List(sql),RowDel,""))
    sql="select * from distributor3 where user_id='"&user_id&"'"
    authtitle = "매장"
end if 
 %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function goWrite() {
        var f = document.frm1;
        if (f.user_pwd.value == "") {
            alert("패스워드를 입력해 주세요!");
            f.user_pwd.focus();
            return;
        }
        if (f.user_pwd_chk.value == "") {
            alert("패스워드를 입력해 주세요!");
            f.user_pwd_chk.focus();
            return;
        }
        if (f.user_pwd.value != f.user_pwd_chk.value) {
            alert("패스워드가 일치하지 않습니다!");
            return;
        }
        document.frm1.target = "Hframe";
        document.frm1.submit();
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
                    <h2><%=authtitle%> 정보변경</h2>
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
                           <%  

                            RegList = GetString_List(sql)
                            closeGameDB
                            Record_String = RegList  
   	                        if RegList = "" then
                         %>
                          <%else 
    	
	                            Rows = split(RegList,RowDel)
	                            For i = 0 to UBound(Rows)-1
        
		                            Cols = split(Rows(i),ColDel)            
                                    if IDAuth = 0 then
                                        gold = Cols(1)	
                                        user_nm = Cols(2)		               
                                        reg_date = Cols(5)
                                        bank_name    = trim(Cols(10))
                                        accountno    = trim(Cols(11))
                                        account_name    = trim(Cols(12))
                                    elseif IDAuth = 1 then		               
                                        user_nm = Cols(3)		               
                                        reg_date = Cols(8)
                                        bank_name    = trim(Cols(9))
                                        accountno    = trim(Cols(10))
                                        account_name    = trim(Cols(11))
                                        gold = Cols(14)	
                                    elseif IDAuth = 3 then		               
                                        user_nm = Cols(3)		               
                                        reg_date = Cols(9)
                                        bank_name    = trim(Cols(10))
                                        accountno    = trim(Cols(11))
                                        account_name    = trim(Cols(12))
                                        gold = Cols(14)	
                                    elseif IDAuth = 2 then		               
                                        user_nm = Cols(3)		               
                                        reg_date = Cols(9)
                                        bank_name    = trim(Cols(10))
                                        accountno    = trim(Cols(11))
                                        account_name    = trim(Cols(12))
                                        gold = Cols(14)	
                                    end if
            
                                Next     
                           end if
                           closeDB

                           %>
                    <form data-parsley-validate class="form-horizontal form-label-left" name="frm1" method="post" action="update_boss_pwd_ok.asp">
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name"><%=authtitle%>ID 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                             <label class="control-label" for="user_id"><%=user_id%></label>
                          
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name"><%=authtitle%>이름
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id"><%=user_nm%></label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>                     
                     <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="user_pwd" class="date-picker form-control col-md-7 col-xs-12" name="user_pwd" type="password">
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드 확인
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="user_pwd_chk" class="date-picker form-control col-md-7 col-xs-12" name="user_pwd_chk" type="password">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                        <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">수수료
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id"><%=boss_rate%>%</label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">은행명
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="bank_name" class="date-picker form-control col-md-7 col-xs-12" name="bank_name" type="text" value="<%=bank_name%>" maxlength="50" />
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">계좌번호
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="accountno" class="date-picker form-control col-md-7 col-xs-12" name="accountno" type="text" value="<%=accountno%>" maxlength="50" />
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">예금주
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="account_name" class="date-picker form-control col-md-7 col-xs-12" name="account_name" type="text" value="<%=account_name%>" maxlength="50" />
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">골드
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id"><%=formatnumber(gold,0)%></label>
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">가입일자
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id"><%=reg_date%></label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <br />
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                          <button class="btn btn-primary" onclick="goWrite();return false" type="button">수정</button>
						  <button class="btn btn-info" onclick="document.location.href='<%=DefaultPage%>'" type="reset">돌아가기</button>
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
    </div>
        <!-- Javascript 파일 -->
        <!-- #include virtual="/$adm/include/jQuery.asp" -->
        <!-- Javascript 파일 끝 -->
  </body>
</html>
