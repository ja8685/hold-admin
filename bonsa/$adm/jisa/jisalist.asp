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
startpage	= request("startpage")


parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id
move_url = "jisalist.asp?" & parameters
sql=" select distributor2_rate from dealer_rate_manager with(nolock)"
tot_jisa_rate = CDbl(Replace(GetString_List(sql),RowDel,""))

sql=" select count(a.number) from distributor15 a with(nolock) inner join distributor1 b with(nolock) on a.distribute1_link = b.number "
if IDAuth = 0 then
sql=sql&" where b.user_id like '%%'"
elseif IDAuth = 1 then
sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
bonsa_no = request.Cookies(admincheck)("adminNO")
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
    
if startpage <= 0 then	'바로가기 목록의 시작페이지를 받아 온다.
	startpage = 1
end if

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

    function update_st(no, st, game_id) {
        var str = st;
        if (str == 0) {
            if (confirm("상태를 정상으로 변경하시겠습니까?")) {
                pFrame.location.href = "../bonsa/update_jisa_status.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 1) {
            if (confirm("상태를 홀드로 변경하시겠습니까?")) {
                pFrame.location.href = "../bonsa/update_jisa_status.asp?no=" + no + "&str=" + st + "&game_id=" + escape(game_id);
            }
        }
        if (str == 2) {
            if (confirm("본사를 삭제하시겠습니까?")) {
                pFrame.location.href = "../bonsa/update_jisa_status.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
    }
    function update_rate(idx, no) {
        var f = document.frm1;
        var jisa_rate = document.getElementById("jisa_rate" + idx).value;
        if (jisa_rate > <%=tot_jisa_rate %>) {
            alert("본사 수수료는 <%=tot_jisa_rate%>%를 넘을 수 없습니다!");
            return;
        }
        if (confirm("수수료를 " + jisa_rate + "%로 변경하시겠습니까?")) {
            pFrame.location.href = "../bonsa/update_jisa_rate.asp?shop_idx=" + no + "&jisa_rate=" + jisa_rate;
        }
    }
    function jisa_detail(uid, bno) {
        document.location.href = "jisadetail.asp?user_id=" + escape(uid) + "&bonsa_no=" + bno;
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
                    <h2>본사리스트</h2>
                    
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                            <div class="row pull-right">
                                <form name="frm1" method="post" action="?u_id=<%=u_id%>" class="form-horizontal">
	                                 <input type="hidden" name="user_id" />                       
                                     <div class="form-inline form-group" >                                             
                                          <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                            <option value="a.user_id" <%if keyfield="a.user_id" then response.write "selected" end if%>>본사ID</option>
                                            <option value="a.phone" <%if keyfield="a.phone" then response.write "selected" end if%>>전화번호</option>
                                            <option value="a.email" <%if keyfield="a.email" then response.write "selected" end if%>>이메일</option>                                    
                                          </select>                                                                                            
                                        <input type="text" name="keyword" value="<%=keyword%>" onFocus="this.select()" id="autocomplete-custom-append" class="form-control col-sm-2"/>                                                                                                         
                                         &nbsp;&nbsp;
                                        <button class="btn btn-primary form-control col-sm-1" onClick="javascript:document.frm1.submit();return false;">검색</button>
                                    </div>
                                </form>
                            </div>
                    
                    </div>
                      <div class="row">&nbsp;</div>                    
                      <table id="charge_list_table" class="table table-striped table-bordered dt-responsive nowrap">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>NO</b></th>
                            <th style="text-align:center" height="25"><b>본사ID</b></th>
                            <th style="text-align:center" height="25"><b>본사PW</b></th>
                            <th style="text-align:center" height="25"><b>본사명</b></th>
                            <th style="text-align:center" height="25"><b>등록일</b></th>
                            <th style="text-align:center" height="25"><b>전화번호</b></th>
	                        <th style="text-align:center" height="25"><b>수수료</b></th>
                            <th style="text-align:center" height="25"><b>보유골드</b></th>
                            <th style="text-align:center" height="25"><b>보유골드합계</b></th>
                            <th style="text-align:center" height="25"><b>유저보유골드</b></th>
                            <th style="text-align:center" height="25"><b>골드총합계</b></th>
                            <th style="text-align:center" height="25"><b>보유총판</b></th>
                            <th style="text-align:center" height="25"><b>보유매장</b></th>
                            <th style="text-align:center" height="25"><b>보유회원</b></th>
                            <th style="text-align:center" height="25"><b>총판목록</b></th>
                            <th style="text-align:center" height="25"><b>상태</b></th>                      
                        </tr>
                      </thead>
                      <tbody>
               <%
                sql="   select top "&PageSize&" 'ddd' as ddd,'sdfsd' as sdgs, a.number,a.user_id,a.register_date,a.phone,a.email,a.bank_name,a.accountno,a.account_name,a.status,b.user_id as jisa_id,a.distribute15_rate,a.game_id,a.name,a.deal_money,a.user_pass,a.deal_money from distributor15 a with(nolock) inner join distributor1 b with(nolock) on a.distribute1_link=b.number "
                sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                sql=sql&" and a.number not in (select top "&int((page-1)*PageSize)&" a.number from distributor15 a with(nolock) inner join distributor1 b with(nolock) on a.distribute1_link=b.number "
                sql=sql&" where b.user_id ='"&request.Cookies(admincheck)("adminID")&"'"
                sql=sql&searchSQL&" order by a.number desc"
                sql=sql&" ) "&searchSQL
                sql=sql&" order by a.number desc "
                   
                    RegList = GetString_List(sql)    
                    Record_String = RegList  
   	                if RegList = "" then
                 %>
                        <script type="text/javascript">
                            $(document).ready(function () {
                                $("#charge_td").attr("colspan", 10);

                            })
                        </script>
                        <tr> 
	                        <td id="charge_td"><b>등록된 본사가 없습니다.</b></td>
                        </tr>
                      <%else 
                            page_list = 10		'페이지 바로가기의 갯수		
                            totalrecord=RecordCount	'총 레코드 수
                            PageCount = int((RecordCount-1)/PageSize) + 1
                            totalpage=PageCount	'총 페이지 구하기

    	                    cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber    	
	                        Rows = split(RegList,RowDel)
        
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)      
                                no       = Cols(0)
                                chongpan_idx = Cols(2)
                                sql=" select isnull(sum(a.distribute3_rate)+sum(b.distribute2_rate)+sum(c.distribute15_rate),0) from distributor3 a with(nolock) inner join distributor2 b with(nolock) on a.distribute2_link=b.number inner join distributor15 c with(nolock)"
                                sql=sql&" on a.distribute15_link=c.number where c.number="&chongpan_idx
                          
                                 tot_sum_deal_money = CDbl(Replace(GetString_List(sql),RowDel,""))          
                                if tot_sum_deal_money>0 then
                                    notdealmoney = "N"
                                else
                                    notdealmoney = "Y"
                                end if                                  
                                sql="select isnull(count(number),0) from distributor2 with(nolock) where distribute15_link="&chongpan_idx
                                chongpan_cnt = CDbl(Replace(GetString_List(sql),RowDel,""))    
                                 sql="select isnull(sum(deal_money),0) from distributor2 with(nolock) where distribute15_link="&chongpan_idx            
                                chongpan_amt = CDbl(Replace(GetString_List(sql),RowDel,""))     
                                sql="select isnull(count(number),0) from distributor3 with(nolock) where distribute15_link="&chongpan_idx
                                shop_cnt = CDbl(Replace(GetString_List(sql),RowDel,""))       
                                sql="select isnull(sum(deal_money),0) from distributor3 with(nolock) where distribute15_link="&chongpan_idx
                                shop_amt = CDbl(Replace(GetString_List(sql),RowDel,""))     
                                sql="select isnull(count(number),0) from users with(nolock) where user_distributor15_link="&chongpan_idx&" and user_distributor3_link>0 "            
                                member_cnt = CDbl(Replace(GetString_List(sql),RowDel,""))     
                                sql="select isnull(sum(user_money)+sum(user_save),0) from users with(nolock) where user_distributor15_link="&chongpan_idx&" and user_distributor3_link>0 "            
                                member_amt = CDbl(Replace(GetString_List(sql),RowDel,""))     
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
                                jisa_id  = Cols(11)
                                jisa_rate  = Cols(12)
                                game_id  = Cols(13)          
                                name = Cols(14)          
                                user_pass = Cols(16)          
                                deal_money = Cols(17)   
                                if user_id="상어" then
                                    'response.Write "select sum(deal_money) from distributor2 where distribute15_link="&chongpan_idx
                                    'response.Write "deal_money = "&deal_money&"<br>"
                                    'response.Write "chongpan_amt = "&chongpan_amt&"<br>"
                                    'response.Write "shop_amt = "&shop_amt&"<br>"
                                end if      
                                sql="select isnull(sum(deal_money),0) from distributor15 with(nolock) where number="&Cols(2)
                                deal_money= CDbl(Replace(GetString_List(sql),RowDel,""))                            
                                sql="select isnull(sum(deal_money),0) from distributor2 with(nolock) where distribute15_link="&Cols(2)
                                chongpan_amt= CDbl(Replace(GetString_List(sql),RowDel,""))                            
                                sql="select isnull(sum(deal_money),0) from distributor3 with(nolock) where distribute15_link="&Cols(2)
                                shop_amt= CDbl(Replace(GetString_List(sql),RowDel,""))                                                                                            
                                tot_deal_money=deal_money+chongpan_amt+shop_amt    
                                tot_user_money=deal_money+chongpan_amt+shop_amt+member_amt    
                                sql="select isnull(user_money,0)+isnull(user_save,0) from users with(nolock) where user_id='"&user_id&"'"
            
                                gold  = Replace(GetString_List(sql),RowDel,"")            
                                if gold = "" then
                                    gold = 0
                                end if
                                gold = gold / 1000

                      %>
                         <tr> 	                        
	                        <td align="center"><b><%=listnumber%></b></td>
	                        <td align="center"><b><a href="javascript:jisa_detail('<%=user_id%>','<%=request.Cookies(admincheck)("adminNo")%>')"><font color="<%if notdealmoney = "N" then%>red<%else%>blue<%end if%>"><%=user_id%></font></a></b></td>
                            <td align="center"><b><%=user_pass%></b></td>
                            <td align="center"><b><%=name%></b></td>
                            <td align="center"><b><%=regdate%></b></td>
                            <td align="center"><b><%=phone%></b></td>
	                        <td align="center"><b><%=jisa_rate%>%</b></td>
                            <td align="right"><b><%=formatnumber(deal_money,0)%></b></td>
                            <td align="right"><b><%=formatnumber(tot_deal_money,0)%></b></td>        
                            <td align="right"><b><%=formatnumber(member_amt,0)%></b></td>        
                            <td align="right"><b><%=formatnumber(tot_user_money,0)%></b></td>        
                            <td align="center"><b><%=chongpan_cnt%></b></td>
                            <td align="center"><b><%=shop_cnt%></b></td>
                            <td align="center"><b><%=formatnumber(member_cnt,0)%></b></td>
                            <td align="center">
                                <input type="button" value="보기" onclick="document.location.href ='below_chongpanlist.asp?u_id=<%=chongpan_idx%>&bonsa_id=<%=request.Cookies(admincheck)("adminID")%>&jisa_id=<%=user_id%>'" class="btn btn-round btn-danger btn-xs" />
                            </td>
                            <td align="center"><b><%=state%><br />
                                <input type="button" value="홀드" onclick="update_st(<%=chongpan_idx %>,1, '<%=game_id%>')" class="btn btn-warning btn-xs" />
                                <!--input type="button" value="삭제" onclick="update_st(<%=chongpan_idx %>,2, '<%=game_id%>')" class="btn btn-danger btn-xs" /-->
                                <input type="button" value="정상" onclick="update_st(<%=chongpan_idx %>,0, '<%=game_id%>')" class="btn btn-success btn-xs" /></b></td>                                                                                                                                                                

                        </tr>
                        <%
                             sum_deal_money=sum_deal_money+cdbl(deal_money)
                            sum_tot_deal_money=sum_tot_deal_money+cdbl(tot_deal_money)
                            sum_member_amt=sum_member_amt+cdbl(member_amt)
                            sum_tot_user_money=sum_tot_user_money+cdbl(tot_user_money)
                            sum_chongpan_cnt=sum_chongpan_cnt+cdbl(chongpan_cnt)
                            sum_shop_cnt=sum_shop_cnt+cdbl(shop_cnt)
                            sum_member_cnt=sum_member_cnt+cdbl(member_cnt)
                             listnumber = listnumber-1
                             tot_deal_money = 0
                             jisa_rate = 0
                             chongpan_amt = 0
                             chongpan_cnt = 0
                             tot_user_money = 0
                             member_cnt = 0
                             member_amt = 0
                             deal_money = 0
                             shop_amt = 0
                             shop_cnt = 0
                             jisa_rate = 0
	                        Next
     
                       end if
                       closeGameDB
                       %>      
                         <tr bgcolor="#FCF7ED" height="25"> 
	                            <td align="center"><b>합   계</b></td>	    
                                <td align="center">&nbsp;</td>	    
                                <td align="center">&nbsp;</td>	    
                                <td align="center">&nbsp;</td>	    
                                <td align="center">&nbsp;</td>	    
                                <td align="center">&nbsp;</td>	    
                                <td align="center">&nbsp;</td>	    
                                <td align="right"><b style="color:red"><%=formatnumber(sum_deal_money,0)%></b></td>
                                <td align="right"><b style="color:red"><%=formatnumber(sum_tot_deal_money,0)%></b></td>        
                                <td align="right"><b style="color:red"><%=formatnumber(sum_member_amt,0)%></b></td>        
                                <td align="right"><b style="color:red"><%=formatnumber(sum_tot_user_money,0)%></b></td>        
                                <td align="center"><b style="color:red"><%=formatnumber(sum_chongpan_cnt,0)%></b></td>
                                <td align="center"><b style="color:red"><%=formatnumber(sum_shop_cnt,0)%></b></td>
                                <td align="center"><b style="color:red"><%=formatnumber(sum_member_cnt,0)%></b></td>
                                <td align="center">&nbsp;</td>	    
                                <td align="center">&nbsp;</td>	                                 
                            </tr>
                        </tbody>                      
                    </table>       
                      <div class="row text-center">
                          <div class="col-xs-3">
                          </div>
                          <div class="col-xs-6">
                          <!-- 페이지 이동 -->
		                    <%=PageMove(move_url)%>
		                    <!-- 페이지 이동 -->
                          </div>
                          <div class="col-xs-3">
                            <button class="btn btn-primary form-control btn-sm" onclick="document.location.href='../bonsa/insert_jisa.asp?bonsa_no=<%=chongpan_idx%>'"><i class="fa fa-download"></i> 본사 추가</button>
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
