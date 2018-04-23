<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<%
user_id = Request("user_id")
connectionGameDB("PNC")    
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function isNumber() {
        re = /[^0-9]/gi;
        if (re.test(document.frm1.gold_amt.value)) {
            alert("숫자만 입력하세요");
            val.value = val.value.replace(re, "");
            return;
        }
    }
    function goWrite() {
        var f = document.frm2;
        if (f.a_url.value == "") {
            alert("URL을 입력해 주세요!");
            f.a_url.focus();
            return;
        }
        if (f.a_accountname.value == "") {
            alert("은행명을 입력해 주세요!");
            f.a_accountname.focus();
            return;
        }
        if (f.a_accountno.value == "") {
            alert("계좌번호를 입력해 주세요!");
            f.a_accountno.focus();
            return;
        }
        if (f.a_depositname.value == "") {
            alert("예금주를 입력해 주세요!");
            f.a_depositname.focus();
            return;
        }
        document.frm2.target = "Hframe";
        document.frm2.submit();
    }
    function goWrite2(no) {
        var f = eval("document.frm1" + no);
        f.target = "Hframe";
        f.submit();
    }
    function godel(no) {
        document.getElementById("Hframe").src = "insert_account_url.asp?mode=del&a_idx=" + no;
    }
//-->
</SCRIPT>
   <iframe name="Hframe" id="Hframe" width="0" height="0" frameborder="0" style="display:none"></iframe>
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
                    <h2>충전계좌 관리</h2>
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
                    <%
                        sql="select ROW_NUMBER() OVER( ORDER BY idx) as num,* from TB_AccountInfo"
  
                            RegList = GetString_List(sql)
                            Record_String = RegList  
   	                        if RegList = "" then
                         %>
                          <%else 
    	
	                            Rows = split(RegList,RowDel)
	                            For i = 0 to UBound(Rows)-1      		    
                              Cols = split(Rows(i),ColDel)

		                            'RecordSet항목
                                    a_idx = Cols(0)	
                                    a_no =  Cols(1)	    
		                            a_url = Cols(2)		    
                                    a_accountno=   Cols(3)		    
                                    a_accountname= Cols(4)		               
                                    a_depositname= Cols(5)		    

                             %>
                      <form data-parsley-validate class="form-horizontal form-label-left" name="frm1<%=a_no%>" method="post" action="insert_account_url.asp?mode=update&a_idx=<%=a_no%>">
                        <input type="hidden" name="user_id" value="<%=user_id%>" />
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">NO 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                             <label class="control-label" for="user_id"><%=a_idx%></label>                          
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">URL
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input id="a_url" value="<%=a_url%>" class="form-control col-md-7 col-xs-12" name="a_url" type="text">
                        </div>
                      </div>
                      <div class="ln_solid"></div>                     
                     <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">은행명
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="a_accountname" class="form-control col-md-7 col-xs-12" value="<%=a_accountname%>" size="20" />
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">계좌번호
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="a_accountno" class="date-picker form-control col-md-7 col-xs-12" name="a_accountno" value="<%=a_accountno%>" type="text">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">예금주
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="a_depositname" class="date-picker form-control col-md-7 col-xs-12" name="a_depositname" value="<%=a_depositname%>" type="text">
                        </div>
                      </div>
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                          <button class="btn btn-primary" onclick="goWrite2(<%=a_no%>)" type="button">수정</button>
						  <button class="btn btn-info" onclick="godel(<%=a_no%>)" type="reset">삭제</button>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                    </form>
                        <%
                            Next     
                       end if   
                       closeGameDB               
                             %>
                      <form data-parsley-validate class="form-horizontal form-label-left" name="frm2" method="post" action="insert_account_url.asp?mode=insert">
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">URL
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input class="form-control col-md-7 col-xs-12" name="a_url" type="text">
                        </div>
                      </div>
                      <div class="ln_solid"></div>                     
                     <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">은행명
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="a_accountname" class="form-control col-md-7 col-xs-12" size="20" />
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">계좌번호
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input class="date-picker form-control col-md-7 col-xs-12" name="a_accountno" type="text">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">예금주
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input class="date-picker form-control col-md-7 col-xs-12" name="a_depositname" type="text">
                        </div>
                      </div>
                      <div class="ln_solid"></div>                     
                      <br />
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                          <button class="btn btn-primary" onclick="goWrite()" type="button">등록하기</button>						  
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
