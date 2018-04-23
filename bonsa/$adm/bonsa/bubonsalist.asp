<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
keyfield = Request("keyfield")
keyword = trim(Request("keyword"))
page_size = Request("page_size")
page = Request("page")
if page = "" then
	page = 1
else 
	page = cint(page)
end if
connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
dis_no = cint(request.Cookies(admincheck)("adminNO"))

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id
move_url = "bubonsalist.asp?" & parameters

sql = "select count(number) from bubonsa with(nolock) where 1=1 "

if keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " like '%"& keyword &"%'"
end if

sql = sql & searchSQL
RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))

'Response.write sql
'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size

'총 페이지수
PageCount = int((RecordCount-1)/PageSize) + 1

 %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function update_st(no, st, user_id) {
        var str = st;
        if (str == 0) {
            if (confirm("상태를 정상으로 변경하시겠습니까?")) {
                pFrame.location.href = "../bonsa/update_bubonsa_status.asp?no=" + no + "&str=" + st + "&user_id=" + escape(user_id);
            }
        }
        if (str == 1) {
            if (confirm("상태를 홀드로 변경하시겠습니까?")) {
                pFrame.location.href = "../bonsa/update_bubonsa_status.asp?no=" + no + "&str=" + st + "&user_id=" + escape(user_id);
            }
        }
        if (str == 2) {
            if (confirm("영업본사를 삭제하시겠습니까?")) {
                pFrame.location.href = "../bonsa/update_bubonsa_status.asp?no=" + no + "&str=" + st + "&user_id=" + escape(user_id);
            }
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
                    <h2>영업본사리스트</h2>
                    
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                            <div class="row pull-right">
                                <form name="frm1" method="post" action="?" class="form-horizontal">
	                                 <input type="hidden" name="user_id" />                       
                                     <div class="form-inline form-group" >                                             
                                          <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                            <option value="user_id" <%if keyfield="user_id" then response.write "selected" end if%>>영업본사ID</option>
                                            <option value="phone" <%if keyfield="phone" then response.write "selected" end if%>>전화번호</option>
                                            <option value="email" <%if keyfield="email" then response.write "selected" end if%>>이메일</option>
                                          </select>                                                                                            
                                        <input type="text" name="keyword" value="<%=keyword%>" onFocus="this.select()" id="autocomplete-custom-append" class="form-control col-sm-4"/>                                                                                                         
                                         &nbsp;&nbsp;
                                        <button onclick="goWrite()" class="btn btn-primary form-control col-sm-1">검색</button>
                                    </div>
                                </form>
                            </div>
                    
                    </div>
                      <div class="row">&nbsp;</div>                    
                      <table class="table table-striped table-bordered">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                      <th style="text-align:center">NO</th>
                          <th style="text-align:center">영업본사ID</th>
                          <th style="text-align:center">영업본사PW</th>
                          <th style="text-align:center">본사ID</th>
                          <th style="text-align:center">전화번호</th>
                          <th style="text-align:center">등록일</th>
                          <th style="text-align:center">상태</th>                        
                        </tr>
                      </thead>
                      <tbody>
                 <%
	tableColumns = "number, user_id, user_pass, phone, email, money, status, register_date"

	SQL =       "	SELECT TOP " & CDbl(PageSize) & " A.* "
	SQL = SQL & "	FROM ( "
	SQL = SQL & "			SELECT  AA.* "
	SQL = SQL & "			FROM ( "
	SQL = SQL & "					SELECT (" & CDbl(RecordCount) & " +1) - ROW_NUMBER() OVER(ORDER BY register_date DESC) AS ROWNUM, " & tableColumns & " "
	SQL = SQL & "					FROM  bubonsa"
	SQL = SQL & "					WHERE 1=1 " & searchSQL
	SQL = SQL & "			) AA "
	SQL = SQL & "			WHERE ROWNUM  <= " & CDbl(RecordCount) & " - ((" & CDbl(page) & "-1) * " & CDbl(PageSize) & ") AND ROWNUM >= " & CDbl(RecordCount) & " - (" & CDbl(page) & " * " & CDbl(RecordCount) & " - 1) "
	SQL = SQL & "	) A "
	SQL = SQL & "	ORDER BY register_date DESC "
	'response.write SQL
	RegList = GetString_List(SQL)
    Record_String = RegList

   	                    if RegList = "" then%>
                        <tr> 
	                        <td colspan="7"><b>등록된 영업본사가 없습니다.</b></td>
                        </tr>
                      <%else 
	                        Rows = split(RegList,RowDel)
    	                    cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber

	                        For i = 0 to UBound(Rows)-1
		                        Cols			= split(Rows(i),ColDel)      
                                no				= trim(Cols(0)) 
                                number			= trim(Cols(1))
                                user_id			= trim(Cols(2))
                                user_pass		= trim(Cols(3))
                                phone			= trim(Cols(4)) 
                                email			= trim(Cols(5)) 
                                money			= trim(Cols(6)) 
                                status			= trim(Cols(7)) 
                                register_date	= trim(Cols(8)) 

                                select case status
				                    case 0
					                    status_str = "<font color=""blue"">정상</font>"
				                    case 1
					                    status_str = "<font color=""gray"">홀드</font>"
				                    case 2
					                    status_str = "<font color=""red"">삭제</font>"
                                end Select

			                    strJisa = ""

			                    SQL = "select number, jisa_id from bubonsa_jisalist with(nolock) where bubonsa_id = '" & user_id & "'"
			                    JisaList = GetString_List(SQL)

			                    If JisaList = "" Then
				                    strJisa = "등록된 본사가 없습니다."
			                    Else
				                    JisaRows = split(JisaList,RowDel)

				                    For j = 0 to UBound(JisaRows)-1
					                    JisaCols		= split(JisaRows(j),ColDel)      
					                    jisa_no			= trim(JisaCols(0))     
					                    jisa_id			= trim(JisaCols(1)) 

					                    If j = 0 Then
						                    strJisa = strJisa & jisa_id
					                    Else
						                    strJisa = strJisa  & " , " & jisa_id
					                    End If
				                    Next
			                    End If

                      %>
                         <tr> 	                        
	                        <td align="center"><b><%=no%></b></td>
	                        <td align="center"><b><a href="bubonsadetail.asp?user_id=<%=escape(user_id)%>&bonsa_no=<%=request.Cookies(admincheck)("adminNo")%>"><font color="red"><%=user_id%></font></a></b></td>
                            <td align="center"><b><%=user_pass%></b></td>
                            <td align="center"><b><%=strJisa%></b></td>
                            <td align="center"><b><%=phone%></b></td>
                            <td align="center"><b><%=register_date%></b></td>
                            <td align="center"><b><%=status_str%><br />
                                <input type="button" value="홀드" onclick="update_st(<%=number %>,1, '<%=user_id%>')" class="btn btn-warning btn-xs" />
                                <input type="button" value="삭제" onclick="update_st(<%=number %>,2, '<%=user_id%>')" class="btn btn-danger btn-xs" />
                                <input type="button" value="정상" onclick="update_st(<%=number %>,0, '<%=user_id%>')" class="btn btn-success btn-xs" /></b></td>                                                                                                                                                                
                        </tr>
                          <%
	                            Next
     
                           end if
                           closeGameDB
                        %>                     
                      </tbody>
                      <tfoot>
                          <tr>
                              <td colspan="13">
                                  <div class="row pull-right">
                                      <div class="form-inline form-group">                                             
                                          <button class="btn btn-primary pull-right" onclick="document.location.href='insert_bubonsa.asp'" style="margin-right: 5px;"><i class="fa fa-download"></i> 영업본사 추가</button>
                                         
                                    </div>
                                 </div>
                              </td>
                          </tr>
                      </tfoot>
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
  </body>
</html>
