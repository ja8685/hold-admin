<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
keyfield = Request("keyfield")
keyword = trim(Request("keyword"))
if keyword <> "" then
    u_id = trim(Request("keyword"))
else
    u_id = Request("u_id")
end if
page_size = Request("page_size")
page = Request("page")
if page = "" then
	page = 1
else 
	page = cint(page)
end if
connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
adminNo = request.Cookies(admincheck)("adminNo")
parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size &"&u_id="&u_id&"&page2=" & page

move_url = "gameloglist_baduki.asp?" & parameters


'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size

If keyword = "" Then
	searchSQL = ""
Else
	searchSQL = " and a.user_id = '"&keyword&"' "
End If

sql="select count(*) from common_game_log a inner join users b on a.user_id=b.user_id  where 1=1 and b.user_distributor3_link=" & adminNo & searchSQL

RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))

'총 페이지수
PageCount = int((RecordCount-1)/PageSize) + 1
 %>
 <SCRIPT LANGUAGE="JavaScript">
<!--
    function goWrite() {
        document.frm1.submit();
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
                    <h3>게임 로그</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                        <div class="row pull-right">
                            <form name="frm1" method="post" action="?" class="form-horizontal">
	                                <input type="hidden" name="user_id" />                       
                                    <!--div class="form-inline form-group" >                                                    
                                        <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                            <option value="a.user_id" <%if keyfield="a.user_id" then response.write "selected" end if%>>아이디</option>
                                        </select>                                                                                            
                                    &nbsp;&nbsp;<input type="text" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()" class="form-control col-sm-4" />
                                    &nbsp;&nbsp;<input type=button name=headregist value=" 검색 " onClick="goWrite()" class="btn btn-primary form-control col-sm-1" />
                                </div-->
                            </form>
                        </div>
                      <div class="row">&nbsp;</div>                    
                    <table id="member_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>번호</b></th>
                            <th style="text-align:center" height="25"><b>아이디</b></th>
                            <th style="text-align:center" height="25"><b>시간</b></th>
	                        <th style="text-align:center" height="25"><b>게임종류</b></th>
                            <th style="text-align:center" height="25"><b>승자(족보)</b></th>
                            <th style="text-align:center" height="25"><b>이전금액</b></th>
                            <th style="text-align:center" height="25"><b>이긴금액</b></th>
                            <th style="text-align:center" height="25"><b>결과금액</b></th>
	                        <th style="text-align:center" height="25"><b>게임내용</b></th> 
                        </tr>
                      </thead>
                      <tbody>
                 <%
                    If keyword <> "" Then

                    'sql="select * from (select top "&PageSize&" 'sdfsd' as sdf,'sdff' as sdfgsjk, a.* from v_game_log_new a with(nolock) where  kind='baduki' and game_win='승' and game_id not in (select top "&int((page-1)*PageSize)&" game_id from  v_game_log_new a with(nolock) where kind='baduki' and game_win='승' order by game_start_time desc)"
                    'sql=sql&" order by game_start_time desc) a inner join v_game_log_new b on a.game_id=b.game_id where 1=1 "&searchSQL&" order by a.game_start_time desc"


	                   tableColumns = "a.game_id, a.user_id, a.game_start_time, a.game_type, a.game_trace, a.game_before_money, a.game_earn_money, a.game_after_money"

	                    SQL =       "	SELECT TOP " & CDbl(PageSize) & " A.* "
	                    SQL = SQL & "	FROM ( "
	                    SQL = SQL & "			SELECT  AA.* "
	                    SQL = SQL & "			FROM ( "
	                    SQL = SQL & "					SELECT (" & CDbl(RecordCount) & " +1) - ROW_NUMBER() OVER(ORDER BY game_start_time DESC) AS ROWNUM, " & tableColumns & " "
	                    SQL = SQL & "					FROM  common_game_log a inner join users b on a.user_id=b.user_id  "
	                    SQL = SQL & "					WHERE 1=1 and b.user_distributor3_link=" & adminNo & searchSQL
	                    SQL = SQL & "			) AA "
	                    SQL = SQL & "			WHERE ROWNUM  <= " & CDbl(RecordCount) & " - ((" & CDbl(page) & "-1) * " & CDbl(PageSize) & ") AND ROWNUM >= " & CDbl(RecordCount) & " - (" & CDbl(page) & " * " & CDbl(RecordCount) & " - 1) "
	                    SQL = SQL & "	) A "
	                    SQL = SQL & "	ORDER BY game_start_time DESC "
	                    'response.write SQL
	                    RegList = GetString_List(SQL)

                        RegList = GetString_List(sql)
  
                        Record_String = RegList  



   	                    if RegList = "" then
                     %>
                        <tr height="25"> 
	                        <td id="inout_td" align="center" height="25"><b>등록된 게임로그가 없습니다.</b></td>
                        </tr>
                    <%
	                    Else
    	
	                        Rows = split(RegList,RowDel)
    	                    cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber

	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)      
                                game_no = trim(Cols(0))   
                                game_id = trim(Cols(1))
                                user_id = trim(Cols(2))   
                                game_start_time = Cols(3)
                                game_type = Cols(4)
                                game_trace = Cols(5) 
                                game_before_money = Cols(6)                        
                                game_earn_money = Cols(7)
			                    game_after_money = Cols(8)
                    %>
                         <tr height="25"> 
	                        <td align="center" height="25" width="83"><b><%=game_id%></b></td>
	                        <td align="center" height="25" width="83"><b><%=user_id%></b></td>
                            <td align="center" height="25" width="126"><b><%=game_start_time%></b></td>
	                        <td align="center" height="25" width="83"><b><%=game_type%></b></td>
                            <td align="center" height="25" width="126"><b><%=game_trace%></b></td>
	                        <td align="center" height="25" width="83" style="text-align:right;padding-right:10px"><b><%=FormatNumber(game_before_money,0)%></b></td>
                            <td align="center" height="25" width="83" style="text-align:right;padding-right:10px"><b><%=FormatNumber(game_earn_money,0)%></b></td>
                            <td align="center" height="25" width="83" style="text-align:right;padding-right:10px"><b><%=FormatNumber(game_after_money,0)%></b></td>
	                        <td align="center" height="25" width="83">                                
                                <input type=button name=headregist value=" 보기 " onClick="document.location.href ='/$adm/member/gamelog_detail.asp?game_id=<%=server.urlencode(game_id)%>&<%=parameters%>'" class="btn btn-info form-control" />
	                        </td>
                        </tr>
                    <%
                              listnumber = listnumber-1
	                        Next
     
                       end if
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
     <%if  RegList = "" then%>  
        $("#inout_td").attr("colspan", 9);
      <%end if%>
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
