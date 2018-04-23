<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<%
connectionGameDB("PNC")
no = request("no")
sql="select title,contents from tb_notice with(nolock) where idx = "&no
    below_list = split(replace(GetString_List(sql),RowDel,""),ColDel)
if isarray(below_list) = true then
    title = below_list(0)
    contents = below_list(1)                
end if
closeGameDB
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
        if (document.getElementById("title").value == "") {
            alert("제목을 입력해 주세요!");
            document.getElementById("title").focus();
            return;
        }
        if (document.getElementById("contents").value == "") {
            alert("내용을 입력해 주세요!");
            document.getElementById("contents").focus();
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
                    <h2>공지사항 쓰기</h2>
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
                    <form class="form-horizontal form-label-left" name="frm1" id="frm1" method="post" action="notice_edit_ok.asp?no=<%=no%>">                        
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">제목 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="title" value="<%=title%>" id="title" class="date-picker form-control col-md-7 col-xs-12" maxlength="200" />
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">내용
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">                          
                              <textarea cols="60" class="date-picker form-control col-md-7 col-xs-12" name="contents" id="contents" rows="10"><%=contents%></textarea>                        
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">상태
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                             <select class="select2_single form-control col-md-7 col-xs-12" name="state">
                                <option value="Y" <%if status="Y" then response.write "selected" end if%>>등록</option>
                                <option value="N" <%if status="N" then response.write "selected" end if%>>대기</option>
                             </select>
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
