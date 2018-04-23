<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
keyfield = Request("keyfield")
keyword = trim(Request("keyword"))
u_id = trim(Request("u_id"))
shop_no = trim(Request("shop_no"))
chongpan_id = trim(Request("chongpan_id"))
bonsa_id = trim(Request("bonsa_id"))
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
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id & "&bonsa_id=" & bonsa_id & "&shop_no=" & shop_no & "&chongpan_id=" & chongpan_id

move_url = "below_memberlist.asp?" & parameters

if keyword <> "" then 
	searchSQL = searchSQL & " where " & keyfield & " like '%"& keyword &"%'"
end if

sql="     select count(user_id) "
sql=sql&" from v_member_list01 where shop_id = '"&u_id&"'"
if keyword <> "" then
    select case keyfield 
            case "user_id"
             sql=sql&" and user_id like '%"&keyword&"%'"
            case "user_distributor3_link"
             sql=sql&" and shop_id like '%"&keyword&"%'"
            case "user_distributor2_link"
             sql=sql&" and chongpan_id like '%"&keyword&"%'"
            case "user_distributor1_link"
             sql=sql&" and bonsa_id like '%"&keyword&"%'"
    end select    
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
                    <h3>회원 목록</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                        <div class="row pull-right">
                            <form name="frm1" method="post" action="?u_id=<%=u_id%>" class="form-horizontal">
                                  <input type="hidden" name="shop_no" value="<%=shop_no%>" />
                                  <input type="hidden" name="chongpan_id" value="<%=chongpan_id%>" />
                                  <input type="hidden" name="bonsa_id" value="<%=bonsa_id%>" />
                                    <div class="form-inline form-group" >                                                    
                                        <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                            <option value="user_id" <%if keyfield="user_id" then response.write "selected" end if%>>회원ID</option>
                                            <option value="user_distributor3_link" <%if keyfield="user_distributor3_link" then response.write "selected" end if%>>매장ID</option>
                                            <option value="user_distributor2_link" <%if keyfield="user_distributor2_link" then response.write "selected" end if%>>총판ID</option>
                                        </select>                                                                                            
                                &nbsp;&nbsp;<input type="text" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()" class="form-control col-sm-4" />
                                &nbsp;&nbsp;<input type=button name=headregist value=" 검색 " onClick="goWrite()" class="btn btn-primary form-control col-sm-1" />
                                </div>
                            </form>
                        </div>
                      <div class="row">&nbsp;</div>                    
                    <table id="member_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>매장ID</b></th>
                            <th style="text-align:center" height="25"><b>회원ID</b></th>
                            <th style="text-align:center" height="25"><b>닉네임</b></th>
                            <th style="text-align:center" height="25"><b>게임머니</b></th>
                            <th style="text-align:center" height="25"><b>금고머니</b></th>
                            <th style="text-align:center" height="25"><b>합계머니</b></th>        
                            <th style="text-align:center" height="25"><b>등록일</b></th>
                            <th style="text-align:center" height="25"><b>최근접속일</b></th>
                            <th style="text-align:center" height="25"><b>접속여부</b></th>
	                        <!--th style="text-align:center" height="25" width="83"><b>실버</b></th>
                            <th style="text-align:center" height="25" width="83"><b>수수료(%)</b></th>				
	                        <th style="text-align:center" height="25" width="126"><b>게임로그</b></th--> 
                            <th style="text-align:center" height="25"><b>상태</b></th>  
                        </tr>
                      </thead>
                      <tbody>
                    <%

                      sql=" select top "&PageSize&" *"
                      sql=sql&" from v_member_list01 where shop_id = '"&u_id&"' and user_id not in (select top "&int((page-1)*PageSize)&" user_id from v_member_list01 where shop_id = '"&u_id&"'"
  
                    if keyword <> "" then
                        select case keyfield 
                                case "user_id"
                                 sql=sql&" and user_id like '%"&keyword&"%'"
                                case "user_distributor3_link"
                                 sql=sql&" and shop_id like '%"&keyword&"%'"
                                case "user_distributor2_link"
                                 sql=sql&" and chongpan_id like '%"&keyword&"%'"
                                case "user_distributor1_link"
                                 sql=sql&" and bonsa_id like '%"&keyword&"%'"
                        end select    
                    end if
                    sql=sql&" order by user_regdate)"
                    if keyword <> "" then
                        select case keyfield 
                                case "user_id"
                                 sql=sql&" and user_id like '%"&keyword&"%'"
                                case "user_distributor3_link"
                                 sql=sql&" and shop_id like '%"&keyword&"%'"
                                case "user_distributor2_link"
                                 sql=sql&" and chongpan_id like '%"&keyword&"%'"
                                case "user_distributor1_link"
                                 sql=sql&" and bonsa_id like '%"&keyword&"%'"
                        end select    
                    end if
                      sql=sql&" order by user_regdate "
  
                      user_id = GetString_List(sql)
  	                        Rows = split(user_id,RowDel)
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)
                                userid = userid&"'"&Cols(0)&"',"            
                            next
                            if right(userid,1) = "," then
                                userid = left(userid,len(userid)-1)
                            end if
                      if userid = "" then
                        userid = "''"
                      end if      
   
                      sql="     select top "&PageSize&" a.user_id,b.user_id as shop_id,c.user_id as chongpan_ID,d.user_id as bonsa_id,user_money as user_money,user_save as user_save, user_smoney as user_smoney,a.user_rate,a.user_state,a.user_nick,a.user_regdate,a.user_currentdate "
                      sql=sql&" from users a inner join distributor3 b on a.user_distributor3_link=b.number inner join distributor2 c on a.user_distributor2_link=c.number"
                      sql=sql&" inner join  distributor1 d on a.user_distributor1_link=d.number where b.user_id='"&u_id&"' and a.number not in (select top "&int((page-1)*PageSize)&" a.number from "
                      sql=sql&" users a inner join distributor3 b on a.user_distributor3_link=b.number inner join distributor2 c on a.user_distributor2_link=c.number"
                      sql=sql&" inner join  distributor1 d on a.user_distributor1_link=d.number where b.user_id='"&u_id&"'"
                    if keyword <> "" then
                        select case keyfield 
                                case "user_id"
                                 sql=sql&" and a.user_id like '%"&keyword&"%'"
                                case "user_distributor3_link"
                                 sql=sql&" and b.user_id like '%"&keyword&"%'"
                                case "user_distributor2_link"
                                 sql=sql&" and c.user_id like '%"&keyword&"%'"
                                case "user_distributor1_link"
                                 sql=sql&" and d.user_id like '%"&keyword&"%'"
                        end select    
                    end if
                      sql=sql&" order by a.user_regdate desc)"   
                    if keyword <> "" then
                        select case keyfield 
                                case "user_id"
                                 sql=sql&" and a.user_id like '%"&keyword&"%'"
                                case "user_distributor3_link"
                                 sql=sql&" and b.user_id like '%"&keyword&"%'"
                                case "user_distributor2_link"
                                 sql=sql&" and c.user_id like '%"&keyword&"%'"
                                case "user_distributor1_link"
                                 sql=sql&" and d.user_id like '%"&keyword&"%'"
                        end select    
                    end if
  
                      sql=sql&" order by a.user_regdate desc "
  
                        RegList = GetString_List(sql)
    
                        Record_String = RegList  
   	                    if RegList = "" then
                     %>
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#charge_td").attr("colspan", 11);

                        })
                    </script>
                        <tr height="25"> 
	                        <td id="charge_td2" style="text-align:center" height="25"><b>등록된 회원이 없습니다.</b></td>
                        </tr>
                      <%else 
                            cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber    	    	    	
	                        Rows = split(RegList,RowDel)
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)

		                        'RecordSet항목
		                        user_id = Cols(0)
                                sql = "select status from connectedusers where user_id = '"&user_id&"'"
                                conn_yn = cstr(Replace(GetString_List(sql),RowDel,""))
                                if conn_yn = "" then
                                    conn_yn = 99
                                end if
                                select case conn_yn 
                                        case 0
                                        conn_state = "로비"
                                        case 1
                                        conn_state = "1번방"
                                        case 2
                                        conn_state = "2번방"
                                        case 3
                                        conn_state = "3번방"
                                        case 4
                                        conn_state = "4번방"
                                        case 99
                                        conn_state = "OFF"
                                end select
		                        shop_id = Cols(1)
		                        chongpan_id = Cols(2)
		                        bonsa_id = Cols(3)
		                        gold = cdbl(Cols(4))
                                save = cdbl(Cols(5))
                                tot_money = gold+save
		                        silver = Cols(6)
                                user_rate = Cols(7)
                                state  = Cols(8)
                                user_nick  = Cols(9)
                                reg_date  = Cols(10)
                                cur_date  = Cols(11)
                                select case state
                                        case 0
                                        state = "<font color=""blue"">정상</font>"
                                        case 1
                                        state = "<font color=""gray"">홀드</font>"
                                        case 2
                                        state = "<font color=""red"">삭제</font>"
                                end select 
                        %>
                        <tr height="25"> 
	                        <td align="center" height="25"><b><%=chongpan_id%></b></td>
                            <td align="center" height="25"><b><%=shop_id%></b></td>
                            <td align="center" height="25"><a href="./memberdetail.asp?user_id=<%=user_id%>"><b><%=user_id%></b></a></td>
                            <td align="center" height="25"><b><%=user_nick%></b></td>
                            <td height="25"  style="text-align:right;padding-right:10px"><b><%=formatnumber(gold,0)%></b></td>
                            <td align="right" height="25"  style="padding-right:20px"><b><%=formatnumber(save,0)%></b></td>
                            <td align="right" height="25"  style="padding-right:20px"><b><%=formatnumber(tot_money,0)%></b></td>
	                        <!--td align="right" height="25"  style="padding-right:20px"><b><%'=formatnumber(silver,0)%></b></td>
                            <td align="center" height="25" width="83"><b><%'=user_rate%></b></td>				
	                        <td align="center" height="25" width="126"><b><a href="gameloglist.asp?u_id=<%'=user_id%>&bonsa_id=<%'=bonsa_id%>&chongpan_id=<%'=chongpan_id%>&shop_no=<%=u_id%>">게임로그</a></b></td-->        
                            <td align="center" height="25"><b><%=reg_date%></b></td>        
                            <td align="center" height="25"><b><%=cur_date%></b></td>        
                            <td align="center" height="25"><b><%=conn_state%></b></td>        
                            <td align="center"><%=state%></td>        
                        </tr>
                         <%listnumber = listnumber-1
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
        <%if RecordCount = 0 then%>
            $("#charge_td2").attr("colspan", 11);
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
