<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<%
connectionGameDB("PNC")
no = request("NO")
sql="select * from tb_qna with(nolock) where idx ="&no
 RegList = GetString_List(sql)
Rows = split(RegList,RowDel)
Cols = split(Rows(0),ColDel)      
user_id = Cols(1)
title = Cols(3)
contents = Cols(4)
repl_contents = Cols(5)
reg_date = Cols(7)
repl_date = Cols(8)
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
        var f = document.frm1;

        if (document.getElementById("repl_contents").value == "") {
            alert("내용을 입력해 주세요!");
            document.getElementById("repl_contents").focus();
            return;
        }
        if (confirm("이대로 등록하시겠습니까?")) {
            document.frm1.target = "Hframe";
            document.frm1.submit();
        }

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
    function goList() {
        document.location.href = "qna_list.asp"
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
                    <h2>1:1문의 쓰기</h2>
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
                    <form class="form-horizontal form-label-left" name="frm1" id="frm1" method="post" action="qna_write_ok.asp">                        
                        <input type="hidden" name="no" value="<%=no%>" />
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">아이디 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                            
                             <label class="control-label  col-md-7 col-xs-12" for="user_id"><%=user_id%></label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">제목 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                            
                             <label class="control-label  col-md-7 col-xs-12" for="title"><%=title%></label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">내용 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                              <div class="bs-example" data-example-id="simple-jumbotron">    
                                 <pre><%=contents%></pre>
                              </div>                     
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                       <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">등록일 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                            
                             <label class="control-label  col-md-7 col-xs-12" for="reg_date"><%=reg_date%></label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">답변
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                          
                              <textarea cols="60" class="date-picker form-control col-md-7 col-xs-12" name="repl_contents" id="repl_contents" rows="10"><%=repl_contents%></textarea>                        
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                       <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">답변일 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                            
                             <label class="control-label  col-md-7 col-xs-12" for="reg_date"><%=repl_date%></label>
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
