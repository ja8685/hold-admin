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
end If

page_size = Request("page_size")
page = Request("page")

if page = "" then
	page = 1
else 
	page = cint(page)
end If

connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
adminNo = request.Cookies(admincheck)("adminNo")

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & escape(keyword) & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size &"&u_id="&u_id&"&page2=" & page

move_url = "gameloglist_baduki.asp?" & parameters

'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size

If keyword = "" Then
	searchSQL = ""
Else
	searchSQL = " and user_id = '"&keyword&"' "
End If

sql="select count(*) from common_game_log a with(nolock)  where 1=1 " & searchSQL
    
RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))

'총 페이지수
PageCount = int((RecordCount-1)/PageSize) + 1


 %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function goWrite() {
        document.frm1.submit();
    }

    function goEdit(IDX) {
        document.location.href = "regHead.asp?proc=edit&f_idx=" + IDX + "&<%=parameters%>";
    }

    function goDel(IDX) {
        if (confirm("부본사를 삭제하시면 해당 본사 및 하위 매장에 대한 관련 정보들이 모두 삭제가 됩니다.\n\n정말로 삭제하시겠습니까?")) {
            document.frm.f_idx.value = IDX;
            document.all.ALERT_MSG.style.display = "block";
            document.frm.PWD.focus();
            //pFrame.location.href = "regHeadProc.asp?proc=del&f_idx=" + IDX + "&<%=parameters%>";
        }
    }

    function goDailyCharge() {
        if (confirm("부본사에 기준머니를 일괄 지급하시겠습니까?")) {
            pFrame.location.href = "DailyHeadMoneyCharge.asp";
        }
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
                    <h2>게임 로그</h2>
                    
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <div class="row">
                        <form name="frm1" method="post" action="?">
                            <div class="form-inline form-group">
                                <div class="col-sm-12 text-right">                                        
		                            <select class="select2_single form-control" name="keyfield">
                                        <option value="a.user_id" <%if keyfield="a.user_id" then response.write "selected" end if%>>닉네임</option>
                                    </select>
                                    &nbsp;&nbsp;<input type="text" class="form-control" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()">
                                    &nbsp;&nbsp;<input type=button class="btn btn-info form-control" name=headregist value=" 검색 " onClick="goWrite()">
                                </div>
                            </div>
                        </form>
                        </div>                    
                    </div>
                      <div class="row">&nbsp;</div>                    
                      <table id="charge_list_table" class="table table-striped table-bordered dt-responsive nowrap">
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
	                        <th style="text-align:center" height="25"><b>상태</b></th>                           
                        </tr>
                      </thead>
                      <tbody>
                   <%
                        If keyword <> "" Then
	
	                        'sql="select top "&PageSize&" 'sdfsd' as sdf,'sdff' as sdfgsjk, a.* from v_game_log_new a with(nolock) where  kind='baduki' and game_win='승' "&sSQL&" and game_id not in (select top "&int((page-1)*PageSize)&" game_id from  v_game_log_new a with(nolock) where kind='baduki' and game_win='승' "&sSQL&" order by game_start_time desc)"
	                        'sql="select top 100 a.game_id, a.game_start_time, a.game_type, a.game_trace, a.game_before_money, a.game_earn_money from common_game_log a with(nolock)  where 1=1 "&sSQL&" order by game_start_time desc"
   
	                        tableColumns = "game_id, user_id, game_start_time, game_type, game_trace, game_before_money, game_earn_money, game_after_money, game_status"

	                        SQL =       "	SELECT TOP " & CDbl(PageSize) & " A.* "
	                        SQL = SQL & "	FROM ( "
	                        SQL = SQL & "			SELECT  AA.* "
	                        SQL = SQL & "			FROM ( "
	                        SQL = SQL & "					SELECT (" & CDbl(RecordCount) & " +1) - ROW_NUMBER() OVER(ORDER BY game_start_time DESC) AS ROWNUM, " & tableColumns & " "
	                        SQL = SQL & "					FROM  common_game_log"
	                        SQL = SQL & "					WHERE 1=1 " & searchSQL
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
                        <script type="text/javascript">
                            $(document).ready(function () {
                                $("#charge_td").attr("colspan", 10);

                            })
                        </script>
                            <tr bgcolor="#FCF7ED" height="25"> 
	                            <td id="charge_td" align="center" height="25"><b>등록된 게임로그가 없습니다.</b></td>
                            </tr>
                          <%else 
    	
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
                                    game_earn_money = cdbl(Cols(7))
			                        game_after_money = Cols(8)
			                        game_status = Cols(9)
                            %>
                             <tr height="25"> 
	                            <td style="text-align:center"><b><%=game_id%></b></td>
	                            <td style="text-align:center"><b><%=user_id%></b></td>
                                <td style="text-align:center"><b><%=game_start_time%></b></td>
	                            <td style="text-align:center"><b><%=game_type%></b></td>
                                <td style="text-align:center"><b><%=game_trace%></b></td>
	                            <td style="text-align:right;padding-right:10px"><b><%=FormatNumber(game_before_money,0)%></b></td>
                                <td style="text-align:right;padding-right:10px"><b><%=FormatNumber(game_earn_money,0)%></b></td>
                                <td style="text-align:right;padding-right:10px"><b><%=FormatNumber(game_after_money,0)%></b></td>
	                            <td align="center" height="25" width="83">            
                                    <button class="btn btn-danger form-control btn-xs" onClick="javascript:document.location.href='/$adm/member/gamelog_detail.asp?game_id=<%=game_id%>&<%=parameters%>';">보기</button>
	                            </td>
	                            <td style="text-align:center"><b><%=game_status%></b></td>
                            </tr>
                           <%
                                  listnumber = listnumber-1
                                  sum_game_earn_money = sum_game_earn_money + game_earn_money
	                            Next
     
                           end if
                           closeGameDB
                           %>
                             <tr height="25"> 
	                            <td style="text-align:center">합계</td>
	                            <td style="text-align:center">&nbsp;</td>
                                <td style="text-align:center">&nbsp;</td>
	                            <td style="text-align:center">&nbsp;</td>                                
	                            <td style="text-align:right;padding-right:10px">&nbsp;</td>
                                <td style="text-align:right;padding-right:10px">&nbsp;</td>
                                <td style="text-align:right;padding-right:10px"><b><%=FormatNumber(sum_game_earn_money,0)%></b></td>
	                            <td align="center" height="25" width="83">&nbsp;</td>
	                            <td style="text-align:center">&nbsp;</td>
                                 <td style="text-align:center">&nbsp;</td>
                            </tr>                          
                          <%
                          else%>   
                        <script type="text/javascript">
                            $(document).ready(function () {
                                $("#charge_td2").attr("colspan", 10);

                            })
                        </script>
                            <tr bgcolor="#FCF7ED" height="25"> 
	                            <td id="charge_td2" align="center" height="25"><b>등록된 게임로그가 없습니다.</b></td>
                            </tr> 
                         <%end if %>
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
    $(document).ready(function () {
        var oTable = $('#charge_list_table').DataTable({
            "bPaginate": false,
            "bFilter": false,
            "sort": false
        });
        //$("#tot_sum_td").attr("colspan", 2);        

    })
</script>
  </body>
</html>
