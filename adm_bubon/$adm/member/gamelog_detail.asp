<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<%
game_id = Request("game_id")
connectionGameDB("PNC")

sql = "select user_nick from users"
user_id = GetString_List(sql)
Rows2 = split(user_id,RowDel)
 
  sql="select game_id, game_type, str from common_game_log_detail where game_id='"&game_id&"'"

    RegList = GetString_List(sql)
    Record_String = RegList  
   	if RegList = "" then
 %>
  <%else 
    	
	    Rows = split(RegList,RowDel)
	    For i = 0 to UBound(Rows)-1
		    Cols = split(Rows(i),ColDel)

		    'RecordSet항목
		    game_id = Cols(0)		
		    game_type = Cols(1)	    
            game_txt = Cols(2)		    
         
        Next     
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
        if (f.gold_amt.value == "") {
            alert("충전할 골드를 입력해 주세요!");
            f.gold_amt.focus();
            return;
        }
        isNumber();
        if (f.gold_amt.value > <%=boss_gold %>) {
            alert("보유한 골드보다 충전금액이 많습니다!");
            return;
        }
        if (confirm(f.gold_amt.value + "골드를 충전하시겠습니까?")) {
            document.frm1.target = "Hframe";
            document.frm1.submit();
        }

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
                    <h2>게임 내용</h2>
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
                    <form class="form-horizontal form-label-left" name="frm1" method="post" action="insert_bubonsa_ok.asp">
                        <input type="hidden" name="exist_id" value="N" readonly />
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">게임번호 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                             <label class="control-label" for="user_id"><%=game_id%></label>
                          
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">게임내용
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id">
                                <%
                                    arr_txt = split(game_txt,chr(10))
                                    for i = 0 to ubound(arr_txt)-1
                                        if instr(arr_txt(i),"승")>0 then
                                            response.Write "<font color=""red"">"&arr_txt(i)&"</font><br>"
                                        else
                                            response.Write arr_txt(i)&"<br>"
                                        end if
                
                                    next                   
            
                                %> 
                          </label>                            
                        </div>
                      </div>                                            
                      <div class="ln_solid"></div>               
                      <br />
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
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
