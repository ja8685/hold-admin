<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
keyfield = Request("keyfield")
keyword = trim(Request("keyword"))
connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
bonsa_no = request.Cookies(admincheck)("adminNO")
u_id = Request("u_id")
chongpan_id = Request("chongpan_id")
bonsa_id = Request("bonsa_id")
page_size = Request("page_size")
page = Request("page")
if page = "" then
	page = 1
else 
	page = cint(page)
end if
parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id & "&chongpan_id=" & chongpan_id & "&bonsa_id=" & bonsa_id

move_url = "below_shoplist.asp?" & parameters

if keyword <> "" then 
	searchSQL = searchSQL & " and " & keyfield & " like '%"& keyword &"%'"
end if

sql="select distributor2_rate+distributor3_rate from dealer_rate_manager"
tot_chongpan_rate = CDbl(Replace(GetString_List(sql),RowDel,""))

sql=" select count(a.number) from distributor3 a left outer join distributor2 b on a.distribute2_link = b.number left outer join distributor15 d on a.distribute15_link=d.number left outer join distributor1 c on a.distribute1_link=c.number where a.distribute2_link=" &u_id&searchSQL

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

    function goDailyCharge() {
        if (confirm("부본사에 기준머니를 일괄 지급하시겠습니까?")) {
            pFrame.location.href = "DailyHeadMoneyCharge.asp";
        }
    }
    function update_st(no, st, game_id) {
        var str = st;
        if (str == 0) {
            if (confirm("상태를 정상으로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_shop_status.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 1) {
            if (confirm("상태를 홀드로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_shop_status.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 2) {
            if (confirm("매장을 삭제하시겠습니까?")) {
                pFrame.location.href = "./update_shop_status.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
    }

    function goMemList(obj1, obj2, obj3, obj4) {
        document.f.shop_no.value = obj1;
        document.f.u_id.value = obj2;
        document.f.bonsa_id.value = obj3;
        document.f.chongpan_id.value = obj4;
        document.f.action = "below_memberlist.asp";
        document.f.submit();
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
                    <h2>매장 리스트</h2>
                    
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                            <div class="row pull-right">
                                <form name="frm1" method="post" action="?u_id=<%=u_id%>" class="form-horizontal">
	                                 <input type="hidden" name="user_id" />                       
                                     <div class="form-inline form-group" >                                             
                                          <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                            <option value="a.user_id" <%if keyfield="a.user_id" then response.write "selected" end if%>>매장ID</option>
                                            <option value="a.name" <%if keyfield="a.name" then response.write "selected" end if%>>매장이름</option>
                                            <option value="b.user_id" <%if keyfield="b.user_id" then response.write "selected" end if%>>총판ID</option>            
                                          </select>                                                                                            
                                        <input type="text" name="keyword" value="<%=keyword%>" onFocus="this.select()" id="autocomplete-custom-append" class="form-control col-sm-4"/>                                                                                                         
                                         &nbsp;&nbsp;
                                        <button class="btn btn-primary form-control col-sm-1" onClick="javascript:document.frm1.submit();return false;">검색</button>
                                    </div>
                                </form>
                                <form name="f" method="post">
                                <input type="hidden" name="shop_no" readonly />
                                <input type="hidden" name="u_id" readonly />
                                <input type="hidden" name="bonsa_id" readonly />
                                <input type="hidden" name="chongpan_id" readonly />
                                </form>
                            </div>
                    
                    </div>
                      <div class="row">&nbsp;</div>                    
                      <table class="table table-striped table-bordered">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>NO</b></th>
                            <th style="text-align:center" height="25"><b>매장ID</b></th>
                            <th style="text-align:center" height="25"><b>매장PW</b></th>
	                        <th style="text-align:center" height="25"><b>매장이름</b></th>
                            <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>가입일자</b></th>
	                        <th style="text-align:center" height="25"><b>수수료</b></th>        
                            <th style="text-align:center" height="25"><b>보유골드</b></th>        
                            <th style="text-align:center" height="25"><b>유저보유골드</b></th>        
                            <th style="text-align:center" height="25"><b>회원수</b></th>        
                            <th style="text-align:center" height="25"><b>회원목록</b></th>        
                            <th style="text-align:center" height="25"><b>상태</b></th>	    
                            <!--th style="text-align:center" height="25"><b>매장수수료</b></th-->     
                            <th style="text-align:center" height="25"><b>연락처</b></th>	                    
                        </tr>
                      </thead>
                      <tbody>
                 <%
                    'int((page-1)*PageSize)
                    sql="   select top "&PageSize&" 3 as sdfs, 2 as sdfd,a.*,b.user_id as chongpan_id,b.distribute2_rate as chongpan_rate,a.deal_money from distributor3 a left outer join distributor2 b on a.distribute2_link=b.number left outer join distributor1 c on a.distribute1_link=c.number "
                    sql=sql&" where a.number not in (select top "&int((page-1)*PageSize)&" a.number from distributor3 a left outer join distributor2 b on a.distribute2_link=b.number left outer join distributor1 c on a.distribute1_link=c.number where a.distribute2_link="&u_id&searchSQL&" order by a.register_date desc) and a.distribute2_link="&u_id
                    sql=sql&searchSQL

                    sql=sql&" order by a.register_date desc"
    
                        RegList = GetString_List(sql)    
                        Record_String = RegList  
   	                    if RegList = "" then
                     %>
                        <tr bgcolor="#FCF7ED" height="25"> 
                        <%if IDAuth = 2 then%>
	                        <td style="text-align:center" height="25" colspan="10"><b>등록된 매장이 없습니다.</b></td>
                        <%else%>
                            <td style="text-align:center" height="25" colspan="10"><b>등록된 매장이 없습니다.</b></td>
                        <%end if%>
                        </tr>
                      <%else 
  
                            cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber    	    	
	                        Rows = split(RegList,RowDel)
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)      
                                no       = listnumber
                                shop_idx = Cols(2)
                                sql="select isnull(sum(user_money),0) from users where user_distributor3_link="&shop_idx
                                shop_user_money = CDbl(Replace(GetString_List(sql),RowDel,""))     
                                user_id  = Cols(3)
                                user_pass  = Cols(4)
                                user_nm  = Cols(5)
                                phone  = Cols(9)
                                reg_date = Cols(11)   
                                state  = Cols(15)
                                select case state
                                        case 0
                                        state = "<font color=""blue"">정상</font>"
                                        case 1
                                        state = "<font color=""gray"">홀드</font>"
                                        case 2
                                        state = "<font color=""red"">삭제</font>"
                                end select    
                                game_id=Cols(22)            
                                sql="select isnull(user_money,0)+isnull(user_save,0) from users where user_id='"&game_id&"'"                        
                                gold  = Replace(GetString_List(sql),RowDel,"")            
                                if gold = "" then
                                    gold = 0
                                end if
                                gold = gold 
                                shop_rate= Cols(18)
                                sub_master_id= Cols(24)
                                chongpan_rate= Cols(25)
                                deal_money= Cols(26)
                                chongpan_rate = formatnumber(chongpan_rate-cdbl(shop_rate),1)
                                user_rate= 0
                                sql="select count(user_id) from users where user_distributor3_link ="&shop_idx
                                cnt_member = CDbl(Replace(GetString_List(sql),RowDel,""))
                                sum_deal_money=sum_deal_money+cdbl(deal_money)
                                sum_shop_user_money=sum_shop_user_money+cdbl(shop_user_money)
                                sum_cnt_member=sum_cnt_member+cdbl(cnt_member)
                      %>
                        <tr bgcolor="#FCF7ED" height="25"> 
	                        <td style="font-weight: bold;text-align:center"><b><%=no%></b></td>
	                        <td style="font-weight: bold;text-align:center">
	                        <a href="shopdetail.asp?user_id=<%=server.urlencode(user_id)%>&bonsa_id=<%=server.urlencode(bonsa_id)%>"><%=user_id%></a>				
	                        </td>
                            <td style="font-weight: bold;text-align:center"><%=user_pass%></td>
                            <td style="font-weight: bold;text-align:center"><%=user_nm%></td>
	                        <td style="font-weight: bold;text-align:center"><%=sub_master_id%></td>        
	                        <td style="font-weight: bold;text-align:center"><%=reg_date%></td>
                            <td align="right" style="font-weight: bold;"><%=shop_rate%>%(총판수수료:<%=chongpan_rate%>)</td>        
                            <td align="right" style="font-weight: bold;text-align:right"><%=formatnumber(deal_money,0)%></td>
                            <td align="right" style="font-weight: bold;text-align:right"><%=formatnumber(shop_user_money,0)%></td>
                            <td style="font-weight: bold;text-align:center"><%=cnt_member%></td>
  	                        <td style="font-weight: bold;text-align:center">
                                  <input type="button" value="보기" onclick="goMemList('<%=no%>', '<%=user_id%>', '<%=bonsa_id%>', '<%=sub_master_id%>')" class="btn btn-round btn-danger btn-xs" />                              
                            </td>				 
                            <td style="font-weight: bold;text-align:center"><%=state%><br />
                                <input type="button" value="홀드" onclick="update_st(<%=shop_idx %>,1, '<%=game_id%>')" class="btn btn-warning btn-xs" />
                                <!--input type="button" value="삭제" onclick="update_st(<%=shop_idx %>,2, '<%=game_id%>')" class="btn btn-danger btn-xs" /-->
                                <input type="button" value="정상" onclick="update_st(<%=shop_idx %>,0, '<%=game_id%>')" class="btn btn-success btn-xs" />
                            </td>       
                            <td style="font-weight: bold;text-align:center"><%=phone%></td> 
                        </tr>
                             <%
                             listnumber = listnumber-1
	                        Next
     
                       end if
                       closeGameDB
                       %>
                            <tr bgcolor="#FCF7ED" height="25"> 
	                        <td style="font-weight: bold;text-align:center" colspan="7"><b>합   계</b></td>	       
                            <td style="font-weight: bold;color:red;text-align:right"><%=formatnumber(sum_deal_money,0)%></td>
                            <td style="font-weight: bold;color:red;text-align:right"><%=formatnumber(sum_shop_user_money,0)%></td>
                            <td style="font-weight: bold;color:red;text-align:center"><%=formatnumber(sum_cnt_member,0)%></td>
  	                        <td style="font-weight: bold;color:red;text-align:center" colspan="3"><b></b></td>	       
                        </tr>
                      </tbody>
                      <tfoot>
                          <tr>
                              <td colspan="13">
                                  <div class="row pull-right">
                                      <div class="form-inline form-group">                                             
                                          <%if IDAuth = 1 then%>
                                              &nbsp;&nbsp;&nbsp;<input type="button" value=" 돌아가기 " class="btn btn-warning btn-xs form-control col-sm-3" onclick="history.back()" />
                                              <%end if%>
                                              &nbsp;&nbsp;
                                          <input type="button" value=" 매장 추가 " class="btn btn-success btn-xs form-control col-sm-4" onclick="document.location.href = 'insert_shop.asp?bonsa_no=<%=bonsa_no%>&bonsa_id=<%=bonsa_id%>&chongpan_no=<%=u_id%>'" />
                                    </div>
                                 </div>
                              </td>
                          </tr>
                      </tfoot>
                    </table>
                    <%if RegList <> "" then %>
                      <div class="row text-center">
                          <div class="col-xs-5">
                          </div>
                          <div class="col-xs-6">
                          <!-- 페이지 이동 -->
		                    <%=PageMove(move_url)%>                          
                          </div>
                          <div class="col-xs-1">
                          </div>
                      </div>    
                      <%end if %>
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
