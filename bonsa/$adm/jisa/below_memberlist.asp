<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/connectionDB.asp" -->
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
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & escape(u_id) & "&bonsa_id=" & escape(bonsa_id) & "&shop_no=" & shop_no & "&chongpan_id=" & escape(chongpan_id)

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
            case "user_distributor15_link"
             sql=sql&" and jisa_id like '%"&keyword&"%'"
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
    function update_st_str(no, st, game_id) {
        var str = st;
        if (str == 0) {
            if (confirm("상태를 정상으로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_member_status_new.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 1) {
            if (confirm("상태를 홀드로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_member_status_new.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 2) {
            if (confirm("회원을 삭제하시겠습니까?")) {
                pFrame.location.href = "./update_member_status_new.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
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
                    <h2>회원 리스트</h2>
                    
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                            <div class="row pull-right">
                                <form name="frm1" method="post" action="?u_id=<%=u_id%>">
                                  <input type="hidden" name="shop_no" value="<%=shop_no%>" />
                                  <input type="hidden" name="chongpan_id" value="<%=chongpan_id%>" />
                                  <input type="hidden" name="bonsa_id" value="<%=bonsa_id%>" />
                                     <div class="form-inline form-group" >                                             
                                          <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                            <option value="user_id" <%if keyfield="user_id" then response.write "selected" end if%>>회원ID</option>
                                            <option value="user_distributor3_link" <%if keyfield="user_distributor3_link" then response.write "selected" end if%>>매장ID</option>
                                            <option value="user_distributor2_link" <%if keyfield="user_distributor2_link" then response.write "selected" end if%>>총판ID</option>
                                            <option value="user_distributor15_link" <%if keyfield="user_distributor15_link" then response.write "selected" end if%>>본사ID</option>
                                            <option value="user_distributor1_link" <%if keyfield="user_distributor1_link" then response.write "selected" end if%>>본사ID</option>
                                          </select>                                                                                            
                                        <input type="text" name="keyword" value="<%=keyword%>" onFocus="this.select()" id="autocomplete-custom-append" class="form-control col-sm-4"/>                                                                                                         
                                         &nbsp;&nbsp;
                                        <button class="btn btn-primary form-control col-sm-1" onClick="javascript:document.frm1.submit();return false;">검색</button>
                                    </div>
                                </form>                               
                            </div>
                    
                    </div>
                      <div class="row">&nbsp;</div>                    
                      <table class="table table-striped table-bordered">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
                            <th style="text-align:center" height="25"><b>본사ID</b></th>
                            <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>매장ID</b></th>        
	                        <th style="text-align:center" height="25"><b>회원ID</b></th>
                            <th style="text-align:center" height="25"><b>닉네임</b></th>
                            <th style="text-align:center" height="25"><b>게임머니</b></th>        
                            <th style="text-align:center" height="25"><b>수수료(%)</b></th>
                            <th style="text-align:center" height="25"><b>등록일</b></th>
                            <th style="text-align:center" height="25"><b>최근접속일</b></th>
                            <th style="text-align:center" height="25"><b>플레이시간</b></th>
                            <th style="text-align:center" height="25"><b>상태</b></th>       
                            <th style="text-align:center" height="25"><b>연락처</b></th>                     
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
                                case "user_distributor15_link"
                                 sql=sql&" and jisa_id like '%"&keyword&"%'"
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
                                case "user_distributor15_link"
                                 sql=sql&" and jisa_id like '%"&keyword&"%'"
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
                      sql=sql&" ,e.user_id as jisa_ID,user_game_time,user_avata,user_phone,a.number from users a inner join distributor3 b on a.user_distributor3_link=b.number inner join distributor2 c on a.user_distributor2_link=c.number"
                      sql=sql&" inner join  distributor15 e on a.user_distributor15_link=e.number inner join  distributor1 d on a.user_distributor1_link=d.number where b.user_id='"&u_id&"' and a.number not in (select top "&int((page-1)*PageSize)&" a.number from "
                      sql=sql&" users a inner join distributor3 b on a.user_distributor3_link=b.number inner join distributor2 c on a.user_distributor2_link=c.number"
                      sql=sql&" inner join distributor15 e on a.user_distributor15_link=e.number inner join  distributor1 d on a.user_distributor1_link=d.number where b.user_id='"&u_id&"'"
                    if keyword <> "" then
                        select case keyfield 
                                case "user_id"
                                 sql=sql&" and a.user_id like '%"&keyword&"%'"
                                case "user_distributor3_link"
                                 sql=sql&" and b.user_id like '%"&keyword&"%'"
                                case "user_distributor2_link"
                                 sql=sql&" and c.user_id like '%"&keyword&"%'"
                                case "user_distributor15_link"
                                 sql=sql&" and e.user_id like '%"&keyword&"%'"
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
                                case "user_distributor15_link"
                                 sql=sql&" and e.user_id like '%"&keyword&"%'"
                                case "user_distributor1_link"
                                 sql=sql&" and d.user_id like '%"&keyword&"%'"
                        end select    
                    end if
  
                      sql=sql&" order by a.user_regdate desc "
                      'response.write sql
                        RegList = GetString_List(sql)
    
                        Record_String = RegList  
   	                    if RegList = "" then
                     %>
                        <tr height="25"> 
	                        <th style="text-align:center" colspan="12"><b>등록된 회원이 없습니다.</b></th>
                        </tr>
                      <%else 
                            cnumber = (page-1) * pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = RecordCount - cnumber    	    	    	
	                        Rows = split(RegList,RowDel)
	                        For i = 0 to UBound(Rows)-1
		                        Cols = split(Rows(i),ColDel)

		                        'RecordSet항목
		                        user_id = Cols(0)

		                        shop_id = Cols(1)
		                        chongpan_id = Cols(2)
                                jisa_id = Cols(12)
		                        bonsa_id = Cols(3)
		                        gold = cdbl(Cols(4))
                                save = cdbl(Cols(5))
                                tot_money = gold+save
		                        silver = Cols(6)
                                user_rate = Cols(7)
                                user_gametime= Cols(13)      
                                user_avata= Cols(14)          
                                user_phone= Cols(15)      
                                user_no= Cols(16)      
                                HH = Fix(user_gametime / 3600)   Mod 24           '몇시간 남았는지.. 남은 일 수를 제외하고 시간만 구한다. 
                                MM = Fix(user_gametime / 60) Mod 60               '몇분 남았는지..남은 시간은 제외하고 분만 구함 
                                SS = user_gametime  Mod  60                            '초
                                IF HH > 0 THEN
                                user_gametime = HH&"시간"&MM&"분"
                                else
                                user_gametime = MM&"분"
                                end if
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
                                <td style="text-align:center" height="25"><b><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=jisa_id%></font></b></td>
	                            <td style="text-align:center" height="25"><b><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=chongpan_id%></font></b></td>
                                <td style="text-align:center" height="25"><b><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=shop_id%></font></b></td>
                                <td style="text-align:center" height="25"><a href="./memberdetail.asp?user_id=<%=server.urlencode(user_id)%>"><b><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=user_id%></font></b></a></td>
                                <td style="text-align:center" height="25"><b><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><%=user_nick%></font></b></td>
                                <td height="25"  style="text-align:right;padding-right:10px"><b><%=formatnumber(gold,0)%></b></td>        
	                            <td style="text-align:center" height="25" width="83"><b><%=user_rate%></b></td>				
                                <td style="text-align:center" height="25"><b><%=reg_date%></b></td>        
                                <td style="text-align:center" height="25"><b><%=cur_date%></b></td>                
                                <td style="text-align:center" height="25"><b><%=user_gametime%></b></td>                
                                <td align="center"><%=state%><br />
                                    <button type="button" onclick="update_st_str(<%=user_no %>,1, '<%=game_id%>')" class="btn btn-warning btn-xs">홀드</button>                                
                                <button type="button" onclick="update_st_str(<%=user_no %>,2, '<%=game_id%>')" class="btn btn-danger btn-xs">삭제</button>                                
                                <button type="button" onclick="update_st_str(<%=user_no %>,0, '<%=game_id%>')" class="btn btn-success btn-xs">정상</button>                                                                                                                                
                                </td>                  
                                <td style="text-align:center" height="25"><b><%=user_phone%></b></td>     
                            </tr>
                             <%listnumber = listnumber-1
                                 sum_gold = sum_gold+cdbl(gold)
	                            Next
     
                           end if
                           closeGameDB
                           %>
                            <tr height="25"> 
                                <td style="text-align:center" height="25" colspan="5"><b>합  계</b></td>	    
                                <td height="25"  style="text-align:right;padding-right:10px;color:red"><b><%=formatnumber(sum_gold,0)%></b></td>        
	                            <td style="text-align:center" height="25" width="83"><b></b></td>				
                                <td style="text-align:center" height="25"><b></b></td>        
                                <td style="text-align:center" height="25"><b></b></td>                
                                <td style="text-align:center" height="25"><b></b></td>                 
                                <td style="text-align:center" height="25"><b></b></td>                
                                <td align="center"></td>        
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
