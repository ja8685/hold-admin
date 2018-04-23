<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
on error resume next
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

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id

move_url = "qna_list.asp?" & parameters

if keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " like '%"& keyword &"%'"
end if
if keyword <> "" then 
sql=" select count(idx) from tb_qna a inner join users b on a.user_id=b.user_id where 1=1 and b.user_distributor1_link="&request.Cookies(admincheck)("adminNO")&searchSQL 
else
sql=" select count(idx) from tb_qna a inner join users b on a.user_id=b.user_id where b.user_distributor1_link="&request.Cookies(admincheck)("adminNO")
end if
 

RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))


'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size

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

    function qna_del(no) {
        if (confirm("해당 질문을 삭제하시겠습니까?")) {
            document.hFrame.location.href = "qna_del.asp?no=" + no;
        }
    }
    function qna_delall() {
        if (confirm("답변완료한 질문을 삭제하시겠습니까?")) {
            document.hFrame.location.href = "qna_delall.asp"
        }
    }
    //-->
</SCRIPT>
  <body class="nav-md">
<iframe name="hFrame" style="width:0px;height:0px;display:none"></iframe>
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
                    <h2>1:1문의 목록</h2>
                    
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <div class="row">
                        <form name="frm1" method="post" action="?">
                            <div class="form-inline form-group">
                                <div class="col-sm-12 text-right">                                        
                                    <select class="select2_single form-control" name="keyfield">
                                        <option value="b.user_id" <%if keyfield="b.user_id" then response.write "selected" end if%>>아이디</option>
                                        <option value="b.user_nick" <%if keyfield="b.user_nick" then response.write "selected" end if%>>닉네임</option>
                                        <option value="title" <%if keyfield="title" then response.write "selected" end if%>>제목</option>
                                        <option value="contents" <%if keyfield="contents" then response.write "selected" end if%>>내용</option>            
                                    </select>
                                    &nbsp;&nbsp;<input type="text" class="form-control" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()">
                                    &nbsp;&nbsp;<input type=button class="btn btn-info form-control" name=headregist value=" 검색 " onClick="goWrite()">
                                    &nbsp;&nbsp;<input type="button" class="btn btn-info form-control" value="일괄삭제" onclick="qna_delall()" />
                                </div>
                            </div>
                        </form>
                        </div>                    
                    </div>
                      <div class="row">&nbsp;</div>                    
                      <table id="charge_list_table" class="table table-striped table-bordered dt-responsive nowrap">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25" width="83"><b>번호</b></th>
                            <th style="text-align:center" height="25" width="85"><b>본사ID</b></th>
                            <th style="text-align:center" height="25" width="85"><b>총판ID</b></th>
                            <th style="text-align:center" height="25" width="85"><b>매장ID</b></th>
                            <th style="text-align:center" height="25" width="126"><b>회원ID</b></th>
                            <th style="text-align:center" height="25" width="126"><b>닉네임</b></th>
                            <th style="text-align:center" height="25" width="126"><b>제목</b></th>
	                        <th style="text-align:center" height="25" width="83"><b>상태</b></th>
                            <th style="text-align:center" height="25" width="126"><b>관리</b></th>
	                        <th style="text-align:center" height="25" width="83"><b>등록일자</b></th>        
                            <th style="text-align:center" height="25" width="83"><b>답변일자</b></th>                           
                        </tr>
                      </thead>
                      <tbody>
                  <%sql="select top "&PageSize&" a.*,b.user_nick,b.user_avata from tb_qna a inner join users b on a.user_id=b.user_id where b.user_distributor1_link="&request.Cookies(admincheck)("adminNO")&" and idx not in (select top "&int((page-1)*PageSize)&" idx from tb_qna a inner join users b on a.user_id=b.user_id where b.user_distributor1_link="&request.Cookies(admincheck)("adminNO")&" order by reg_date desc) "&searchSQL&" order by reg_date desc "
    
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
	                            <td id="charge_td" align="center" height="25"><b>등록된 1:1문의가 없습니다.</b></td>
                            </tr>
                          <%else 
    	                        cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                                listnumber = RecordCount - cnumber
	                            Rows = split(RegList,RowDel)
	                            For i = 0 to UBound(Rows)-1
		                            Cols = split(Rows(i),ColDel)      
                                    no = Cols(0)
                                    user_id = Cols(1)
                                    user_nick = Cols(9)
                                    sql="select jisa_id,chongpan_id,shop_id from v_member_list01 where user_id='"&user_id&"'"
                                    arr_data = split(CSTR(Replace(GetString_List(sql),RowDel,"")),ColDel)
                                    jisa_id = arr_data(0)
                                    chongpan_id = arr_data(1)
                                    shop_id = arr_data(2)
                                    title = Cols(3)
                                    contents = Cols(4)
                                    repl_contents = Cols(5)
                                    state = Cols(6)
                                     if state = "N" then
                                        state = "<font color=""blue"">처리중</font>"
                                    elseif state = "Y" then
                                        state = "답변완료"            
                                    end if
                                    reg_date = Cols(7)
                                    repl_date = Cols(8)
                                     user_avata = Cols(9)
            
                            %>
                            <tr bgcolor="#FCF7ED" height="25"> 
	                            <td align="center" height="25" width="83"><b><%=listnumber%></b></td>
                                <td align="center"><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=jisa_id%></font></td>
                                <td align="center"><font color="<%if cstr(user_avata) = "0" then%>red<%else%>blue<%end if%>"><%=chongpan_id%></font></td>
                                <td align="center"><font color="<%if cstr(user_avata) = "0" then%>blue<%else%>blue<%end if%>"><%=shop_id%></font></td>
                                <td align="center" height="25" width="126"><b><%=user_id%></b></td>
                                <td align="center" height="25" width="126"><b style="color:red;"><%=user_nick%></b></td>
                                <td align="center" height="25"><a href="qna_view.asp?gubun=Y&no=<%=no%>"><b><%=title%></b></a></td>
                                <td align="center" height="25" width="126"><b><%=state%></b></td>
	                            <td align="center" height="25" width="83" align="center">
                                    <button onclick="document.location.href='qna_view.asp?gubun=Y&no=<%=no%>';" class="btn btn-info form-control btn-sm">답변</button>
                                    <button onclick="qna_del(<%=no%>);" class="btn btn-danger form-control btn-sm">삭제</button>
	                            </td>
                                <td align="center" height="25"><b><%=reg_date%></b></td>
                                <td align="center" height="25"><b><%=repl_date%></b></td>
                                 </tr>
                                     <% listnumber = listnumber-1            
	                            Next
     
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
