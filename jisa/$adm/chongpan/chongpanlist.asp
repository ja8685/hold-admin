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
move_url = "chongpanlist.asp?" & parameters
sql=" select distributor2_rate from dealer_rate_manager"
tot_chongpan_rate = CDbl(Replace(GetString_List(sql),RowDel,""))

sql=" select count(a.number) from distributor2 a inner join distributor15 b with(nolock) on a.distribute15_link = b.number "
if IDAuth = 0 then
sql=sql&" where b.user_id like '%%'"
elseif IDAuth = 1 then
sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
bonsa_no = request.Cookies(admincheck)("adminNO")
elseif IDAuth = 15 then
sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
elseif IDAuth = 2 then
sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
elseif IDAuth = 3 then
sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
end if 
if keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " like '%"& keyword &"%'"
end if

sql=sql&searchSQL
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
        document.location.href = "regHead.asp?proc=write&<%=parameters%>";
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
                    <h3>총판 목록</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                        <div class="row pull-right">
                            <form name="frm1" method="post" action="?u_id=<%=u_id%>" class="form-horizontal">
	                                <input type="hidden" name="user_id" />                       
                                    <div class="form-inline form-group" >                                                    
                                        <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                            <option value="a.user_id" <%if keyfield="a.user_id" then response.write "selected" end if%>>총판ID</option>
                                            <option value="a.phone" <%if keyfield="a.phone" then response.write "selected" end if%>>전화번호</option>
                                            <option value="a.email" <%if keyfield="a.email" then response.write "selected" end if%>>이메일</option>                                    
                                        </select>                                                                                            
                                &nbsp;&nbsp;<input type="text" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()" class="form-control col-sm-4" />
                                &nbsp;&nbsp;<input type=button name=headregist value=" 검색 " onClick="javascript: document.frm1.submit()" class="btn btn-primary form-control col-sm-1" />
                                </div>
                            </form>
                        </div>
                      <div class="row">&nbsp;</div>                    
                    <table id="member_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>NO</b></th>
                            <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>총판PW</b></th>
                            <th style="text-align:center" height="25"><b>총판명</b></th>
                            <th style="text-align:center" height="25"><b>등록일</b></th>
                            <th style="text-align:center" height="25"><b>전화번호</b></th>
	                        <th style="text-align:center" height="25"><b>이메일</b></th>        
                            <th style="text-align:center" height="25"><b>수수료</b></th>
                            <th style="text-align:center" height="25"><b>보유골드</b></th>
                            <th style="text-align:center" height="25"><b>보유매장</b></th>
                            <th style="text-align:center" height="25"><b>보유회원</b></th>
                            <th style="text-align:center" height="25"><b>매장목록</b></th>
                        </tr>
                      </thead>
                      <tbody>
                  <%
                    sql="   select top "&PageSize&" 'ddd' as ddd,'sdfsd' as sdgs, a.number,a.user_id,a.register_date,a.phone,a.email,a.bank_name,a.accountno,a.account_name,a.status,b.user_id as chongpan_id,a.distribute2_rate,a.game_id,a.name,a.deal_money,a.user_pass from distributor2 a inner join distributor15 b with(nolock) on a.distribute15_link=b.number "
                    if IDAuth = 0 then
                    sql=sql&" where b.user_id like '%%'"
                    elseif IDAuth = 1 then
                    sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                    elseif IDAuth = 15 then
                    sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                    elseif IDAuth = 2 then
                    sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                    elseif IDAuth = 3 then
                    sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                    end if 
                    sql=sql&" and a.number not in (select top "&int((page-1)*PageSize)&" a.number from distributor2 a inner join distributor15 b with(nolock) on a.distribute15_link=b.number "
                    if IDAuth = 0 then
                    sql=sql&" where b.user_id like '%%'"
                    elseif IDAuth = 1 then
                    sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                    elseif IDAuth = 2 then
                    sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                    elseif IDAuth = 15 then
                    sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                    elseif IDAuth = 3 then
                    sql=sql&" where a.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                    end if 
                    sql=sql&searchSQL&" order by a.number desc"
                    sql=sql&" ) "&searchSQL
                    sql=sql&" order by a.number desc "

                        RegList = GetString_List(sql)    
                        Record_String = RegList  
   	                    if RegList = "" then
                     %>
                        <tr height="25"> 
	                        <td id="charge_td2" align="center" height="25"><b>등록된 총판이 없습니다.</b></td>
                        </tr>
                      <%else 
    	                    cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber    	
	                        Rows = split(RegList,RowDel)
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)      
                                no       = Cols(0)
                                shop_idx = Cols(2)
                                sql="select isnull(count(number),0) from distributor3 where distribute2_link="&shop_idx
                                shop_cnt = CDbl(Replace(GetString_List(sql),RowDel,""))       
                                sql="select isnull(count(number),0) from users where user_distributor2_link="&shop_idx&" and user_distributor3_link>0 "            
                                member_cnt = CDbl(Replace(GetString_List(sql),RowDel,""))     
                                user_id  = Cols(3)
                                regdate  = Cols(4)
                                phone    = trim(Cols(5))
                                email    = trim(Cols(6))
                                bank_name    = trim(Cols(7))
                                accountno    = trim(Cols(8))
                                account_name    = trim(Cols(9))
                                state  = Cols(10)
                                select case state
                                        case 0
                                        state = "<font color=""blue"">정상</font>"
                                        case 1
                                        state = "<font color=""gray"">홀드</font>"
                                        case 2
                                        state = "<font color=""red"">삭제</font>"
                                end select
                                chongpan_id  = Cols(11)
                                chongpan_rate  = Cols(12)
                                game_id  = Cols(13)          
                                name = Cols(14)          
                                deal_money = Cols(15)          
                                user_pass = Cols(16)          
                                sql="select isnull(user_money,0)+isnull(user_save,0) from users where user_id='"&user_id&"'"
            
                                gold  = Replace(GetString_List(sql),RowDel,"")            
                                if gold = "" then
                                    gold = 0
                                end if
                                gold = gold / 1000
                      %>
                        <tr height="25"> 
	                        <td align="center"><b><%=listnumber%></b></td>
	                        <td align="center"><a href="chongpandetail.asp?user_id=<%=server.URLencode(user_id)%>&bonsa_no=<%=request.Cookies(admincheck)("adminNo")%>"><font color="red"><%=user_id%></font></a></td>
                            <td align="center"><%=user_pass%></td>
                            <td align="center"><%=name%></td>
                            <td align="center"><%=regdate%></td>
                            <td align="center"><%=phone%></td>
	                        <td align="center"><%=email%></td>        
                            <td align="center"><b><%=chongpan_rate%>%</b></td>
                            <td style="text-align:right;padding-right:10px"><%=formatnumber(deal_money,0)%></td>
                            <td align="center"><b><%=shop_cnt%></b></td>
                            <td align="center"><b><%=formatnumber(member_cnt,0)%></b></td>
                            <td style="text-align:center">
                                <input type=button name=headregist value=" 보기 " onclick="document.location.href ='below_shoplist.asp?u_id=<%=shop_idx%>&bonsa_id=<%=server.URLencode(request.Cookies(admincheck)("adminID"))%>&chongpan_id=<%=server.URLencode(user_id)%>'" class="btn btn-primary btn-xs" />                                
                            </td>
                        </tr>
                             <%
                             listnumber = listnumber-1
                             shop_cnt = 0
                             chongpan_rate = 0
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
                              <input type=button name=headregist value=" 총판추가 " onClick="document.location.href='insert_chongpan.asp'" class="btn btn-primary form-control col-sm-1" />
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
        <%if RecordCount = 0 then%>
            $("#charge_td2").attr("colspan", 12);
        <%end if%>
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
