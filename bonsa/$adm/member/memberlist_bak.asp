<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<!-- #include virtual="/$adm/include/page_move.asp" -->
<%
keyfield = Request("keyfield")
keyword = URLDecode(trim(Request("keyword")))
page_size = Request("page_size")
page = Request("page")
if page = "" or page = "0" then
	page = 1
else 
	page = cint(page)
end if
'1페이지당 리스트 개수
if page_size = "" then page_size = 20
PageSize = page_size
connectionGameDB("PNC")
orderby = Request("orderby")
if orderby = "" then
    orderby ="user_regdate"
end If

realuser = Request("realuser")
If realuser = "" Then realuser = "N"

IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
dis_no = request.Cookies(admincheck)("adminNo")
parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & server.URLEncode(keyword) & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&orderby=" & orderby
parameters = parameters & "&realuser=" & realuser

move_url = "memberlist.asp?" & parameters
'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
startpage	= request("startpage")
go_url		= Request.Servervariables("path_info")
opt_str		= "&stc_type="& stc_type &"&stc_id="&stc_id &"&menukind="&menukind&parameters	                        
'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'if keyword <> "" then 
'	searchSQL = searchSQL & " where " & keyfield & " like '%"& keyword &"%'"
'end If


If realuser = "Y" Then
	searchSQL = searchSQL & " and jisa_id <> '마스터' "
	searchSQL1 = searchSQL1 & " and user_distributor15_link <> '145' "
End If

sql="select * from ("
sql=sql&" select a.user_id,user_nick,user_money as user_money,user_save as user_save,c.user_ip as connect_status,user_currentdate,"
sql=sql&" a.user_regdate,user_phone as f_hp,'' as f_email,shop_id,chongpan_id,jisa_id,bonsa_id,user_account_name,a.user_avata,"
sql=sql&" user_black_list,a.user_state,a.number,a.user_degree , ROW_NUMBER() OVER (ORDER BY number DESC) AS RowNum, "
sql=sql&" (SELECT count(number) FROM users a"
if keyword <> "" then 
	sql = sql & " where " & keyfield & " like '%"& keyword &"%'"
end if
sql=sql&" ) as tot_cnt"
sql=sql&" ,user_distributor1_link from users a with(nolock)"
sql=sql&" left outer join connectedusers c with(nolock) on a.user_id=c.user_id left outer join v_member_list01 d on a.user_id=d.user_id"
if keyword <> "" then 
	sql = sql & " where " & keyfield & " like '%"& keyword &"%'"
end if
sql=sql&" ) a"
sql=sql&" where user_distributor1_link="&dis_no & searchSQL

sql=sql&" and RowNum BETWEEN "& (PageSize * (Page -1)) + 1 &" AND "&PageSize * Page
sql = sql & " order by "&orderby&" desc"

With DBHelper	  
		set Rs1 = .ExecSQLReturnRS(sql, Nothing, Constring)
end With
if startpage <= 0 then	'바로가기 목록의 시작페이지를 받아 온다.
	startpage = 1
end if
If Not(Rs1.Bof Or Rs1.Eof) Then
    arrRs = Rs1.getrows
End If
Rs1.close
set Rs1 = nothing    

sql="select ROW_NUMBER() OVER( ORDER BY idx) as num,idx from TB_AccountInfo"
With DBHelper	  
		set rs_idx = .ExecSQLReturnRS(sql, Nothing, Constring)
end With
If Not(rs_idx.Bof Or rs_idx.Eof) Then
    arrRs2 = rs_idx.getrows
End If
rs_idx.close
set rs_idx = nothing


if startpage <= 0 then	'바로가기 목록의 시작페이지를 받아 온다.
	startpage = 1
end if

sql12="update users set user_ring=0 where user_ring=1"
GameDBconn.execute(sql12)


SQL00 = "SELECT SUM(user_money) AS TOT_USER_MONEY FROM users where user_distributor15_link not in (43,44,45)" & searchSQL1
TOT_USER_MONEY = CDbl(Replace(GetString_List(SQL00),RowDel,""))

SQL00 = "SELECT isnull(SUM(user_money),0) AS TOT_USER_MONEY FROM users where user_distributor15_link=43" & searchSQL1
TOT_ADMIN_MONEY = CDbl(Replace(GetString_List(SQL00),RowDel,""))

SQL00 = "SELECT isnull(SUM(user_money),0) AS TOT_USER_MONEY FROM users where user_distributor15_link in (44,45)" & searchSQL1
TOT_ALBA_MONEY = CDbl(Replace(GetString_List(SQL00),RowDel,""))    
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
    function update_st(no, st, game_id) {
        var str = st;
        if (str == 0) {
            if (confirm("상태를 일반으로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_member_status.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 1) {
            if (confirm("상태를 블랙으로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_member_status.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
        if (str == 3) {
            if (confirm("상태를 화이트로 변경하시겠습니까?")) {
                pFrame.location.href = "./update_member_status.asp?no=" + no + "&str=" + st + "&game_id=" + game_id;
            }
        }
    }
    function update_account(no) {
        var u_accno = document.getElementById('U_Account_No' + no).options[document.getElementById('U_Account_No' + no).selectedIndex].value;
        var str = no;
        if (confirm("충전계좌를 변경하시겠습니까?")) {
            pFrame.location.href = "./update_member_accountno.asp?no=" + no + "&str=" + u_accno;
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
    function orderby(str) {
        <%
            parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & escape(keyword) & "&period=" & period
        parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
        parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size
        parameters = parameters & "&realuser=" & realuser
        move_url = "memberlist.asp?" & parameters
            %>
                if (str == 'M') {
            document.location.href = "<%=move_url%>&orderby=user_money"
        }
        if (str == 'R') {
            document.location.href = "<%=move_url%>&orderby=user_regdate"
        }
        if (str == 'S') {
            document.location.href = "<%=move_url%>&orderby=user_save"
        }
        if (str == 'A') {
            document.location.href = "<%=move_url%>&orderby=shop_id"
        }
    }
    function goMemDetail(obj) {
        document.frm1.user_id.value = obj;
        document.frm1.action = "memberdetail.asp";
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
                    <h2>회원리스트</h2>
                    
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                            <div class="row pull-right">
                                <form name="frm1" method="post" action="?" class="form-horizontal">
	                                 <input type="hidden" name="user_id" />                       
                                     <div class="form-inline form-group" >                                             
                                         <div class="form-control radio col-sm-4">     
                                                <input type="radio" name="realuser" class="radio" id="optionsRadios1"  value="N" <% If realuser = "N" Then Response.write "checked" End If %>>전체
                                                <input type="radio" name="realuser" class="radio" id="optionsRadios2" value="Y" <% If realuser = "Y" Then Response.write "checked" End If %>/>실유저                                                                                                                           
                                         </div>
                                          <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                            <option value="a.user_id" <%if keyfield="a.user_id" then response.write "selected" end if%>>회원ID</option>
                                            <option value="user_account_name" <%if keyfield="user_account_name" then response.write "selected" end if%>>유저이름</option>
                                            <option value="user_nick" <%if keyfield="a.user_nick" then response.write "selected" end if%>>닉네임</option>            
                                            <option value="shop_id" <%if keyfield="shop_id" then response.write "selected" end if%>>매장ID</option>  
                                          </select>                                                                                            
                                        <input type="text" name="keyword" value="<%=keyword%>" onFocus="this.select()" id="autocomplete-custom-append" class="form-control col-sm-4"/>                                                                                                         
                                         &nbsp;&nbsp;
                                         <% if IDAuth=3 then %>
                                            <a href="insert_member.asp"><b>[회원 추가]</b></a>
                                         <%end if %>
                                        <button onclick="goWrite()" class="btn btn-primary form-control col-sm-1">검색</button>
                                    </div>
                                </form>
                            </div>
                            <div class="form-inline form-group pull-right">
                                <button onclick="orderby('M')" class="btn btn-<%if orderby="" or orderby<>"user_money" then response.write "primary" else response.write "info" end if %> form-control">머니순정열</button>
                                <button onclick="orderby('R')" class="btn btn-<%if orderby="" or orderby<>"user_regdate" then response.write "primary" else response.write "info" end if %> form-control">가입순정열</button>
                                <button onclick="orderby('S')" class="btn btn-<%if orderby="" or orderby<>"user_save" then response.write "primary" else response.write "info" end if %> form-control">금고머니순정열</button>
                                <button onclick="orderby('A')" class="btn btn-<%if orderby="" or orderby<>"shop_id" then response.write "primary" else response.write "info" end if %> form-control">매장ID순정열</button>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </div>
                    
                    </div>
                      <div class="row">&nbsp;</div>                    
                      <table class="table table-striped table-bordered">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                      <th style="text-align:center">번호</th>
                          <th style="text-align:center">본사</th>
                          <th style="text-align:center">총판</th>
                          <th style="text-align:center">매장</th>
                          <th style="text-align:center">ID</th>
                          <th style="text-align:center">닉네임</th>
                          <!--th style="text-align:center">등급</!--th>
                          <th style="text-align:center">유저이름</th>
                          <!--th style="text-align:center">충전계좌</th-->
                          <th style="text-align:center">머니</th>
                          <th style="text-align:center">금고</th>
                          <th style="text-align:center">합계</th>
                          <th style="text-align:center">상태</th>
                          <th style="text-align:center">최근접속일</th>
                          <!--th style="text-align:center">게임수</!--th>
                          <th style="text-align:center">승리</th>
                          <th style="text-align:center">패배</th-->
                          <th style="text-align:center">등록일</th>
                          <th style="text-align:center">블랙리스트</th>
                          <th style="text-align:center">HP</th>
                          <th style="text-align:center">관리</th>                          
                        </tr>
                      </thead>


                      <tbody>
                    <%
   	                    If IsArray(arrRs)=False Then
                     %>
                        <tr> 
	                        <td colspan="15"><b>등록된 회원이 없습니다.</b></td>
                        </tr>
                      <%else 
                            page_list = 10		'페이지 바로가기의 갯수		
                            RecordCount = arrRs(20, i)                          
                            totalrecord=RecordCount	'총 레코드 수
                            PageCount = int((RecordCount-1)/PageSize) + 1
                            totalpage=PageCount	'총 페이지 구하기
                            cnumber = (page-1) * PageSize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = totalrecord - cnumber

	                         For i = 0 To Ubound(arrRs, 2)
	                            'RecordSet항목
		                        user_id = arrRs(0,i)
                                user_avata = arrRs(14,i)
                                user_black_list = arrRs(15,i)
                                if user_black_list=0 then
                                    user_black_list="<font color=""black"">일반</font>"
                                elseif user_black_list=1 then
                                    user_black_list="<font color=""red"">블랙</font>"
                                elseif user_black_list=3 then
                                    user_black_list="<font color=""blue"">화이트</font>"
                                end if
                                if tot_sum_deal_money>0 then
                                    notdealmoney = "N"
                                else
                                    notdealmoney = "Y"
                                end if                 
                                nick = arrRs(1,i)
		                        gold = cdbl(arrRs(2,i))
		                        save = cdbl(arrRs(3,i))
                                tot_money = gold+save
		                        isconnected = trim(arrRs(4,i))
                                if len(isconnected)>0 then
                                    isconnected = "<font color=""red"">ON</font>"
                                else
                                    isconnected = "<font color=""gray"">OFF</font>"
                                end if
                                last_conn_date = arrRs(5,i)
		                        reg_date = arrRs(6,i)
                                tel = arrRs(7,i)
                                email = arrRs(8,i)
                                shop_id = arrRs(9,i)
                                chongpan_id= arrRs(10,i)
                                jisa_id= arrRs(11,i)
                                bonsa_id= arrRs(12,i)
                                account_name= arrRs(13,i)   
                                sql="select user_win,user_lose,user_win+user_lose as tot_game from UserGameInfo where user_id='"&user_id&"' and game_name='holdem'"
      
                                    set rsgame = GameDBconn.execute(sql)
                                    if not rsgame.eof then                    
                                        game_win_cnt = rsgame(0)
                                        game_lose_cnt = rsgame(1)
                                        tot_game = rsgame(2)
                                    else
                                        game_win_cnt = 0
                                        game_lose_cnt = 0
                                        tot_game = 0
                                    end if  
                                    set rsgame = nothing                   
                                 state  = arrRs(16,i)
                                select case state
                                        case 0
                                        state = "<font color=""blue"">정상</font>"
                                        case 1
                                        state = "<font color=""gray"">홀드</font>"
                                        case 2
                                        state = "<font color=""red"">삭제</font>"
                                end select       
                                user_no = arrRs(17,i)

			
                                user_degree = arrRs(18,i)            
                        %>
                         <tr> 
	                        <td><%=listnumber%></td>
                            <td><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><b><%=jisa_id%></b></font></td>
                            <td><font color="<%if cstr(user_avata) = "0" then%>red<%else%>blue<%end if%>"><b><%=chongpan_id%></b></font></td>
                            <td><font color="<%if cstr(user_avata) = "0" then%>blue<%else%>blue<%end if%>"><b><%=shop_id%></b></font></td>
                            <td><font color="<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><a href="javascript:goMemDetail('<%=user_id%>');" style="color:<%if cstr(user_avata) = "0" then%>black<%else%>blue<%end if%>"><b><%=user_id%></b></a></font></td>
                            <td><font color="<%if cstr(user_avata) = "0" then%>blue<%else%>blue<%end if%>"><b><%=nick%></b></font></td>
                            <!--td><b><%=UserDegree(user_degree)%></b></!--td>        
                            <td><b><%=account_name%></b></td>
                            <td> <select name="U_Account_No<%=user_no%>" id="U_Account_No<%=user_no%>" onchange="update_account(<%=user_no%>)">
                                <%  sql="select accountno from TB_Member_Accountno where midx="&user_no
                                    u_accountno = CSTR(Replace(GetString_List(sql),RowDel,""))
                                    if u_accountno="" then                    
                                        u_accountno = 1
                                    end if
                                    If IsArray(arrRs2) Then                    
                                        For idxi = 0 To Ubound(arrRs2, 2)                
                                        %><option value="<%=arrRs2(idxi,0)%>" <%if cint(u_accountno)=cint(arrRs2(idxi,0)) then response.write "selected" end if%>><%=arrRs2(idxi,0)%></option><%
                                        next                
                                     end if%>            
                            </select></td-->        
                            <td style="text-align:right"><b><%=formatnumber(gold,0)%></b></td>       
                            <td style="text-align:right"><b><%=formatnumber(save,0)%></b></td>        
                            <td style="text-align:right"><b><%=formatnumber(tot_money,0)%></b></td>        
                            <%if IDAuth=1 then %>
                            <!--td align="center"><a href="../chongpan/charge_gold_member.asp?user_id=<%=user_id%>"><font color="red">[충전/회수]</font></a></td-->
                            <%end if %>
                            <td><b><%=isconnected%></b></td>
                            <td><b><%=last_conn_date%></b></td>
                            <!--td><b><%=tot_game%></b></!--td>
                            <td><b><%=game_win_cnt%></b></td>
                            <td><b><%=game_lose_cnt%></b></td-->
	                        <td><b><%=reg_date%></b></td>
                            <td>
                                <b><%=user_black_list%></b>
                                <button type="button" onclick="update_st('<%=user_no%>', 0, '<%=user_id%>')" class="btn btn-warning btn-xs">일반</button>                                
                                <button type="button" onclick="update_st('<%=user_no%>', 1, '<%=user_id%>')" class="btn btn-danger btn-xs">블랙</button>                                
                                <button type="button" onclick="update_st('<%=user_no%>', 3, '<%=user_id%>')" class="btn btn-success btn-xs">화이트</button>                                
                            <td><b><%=tel%></b></td>					    
                            <td><%=state%>
                                <button type="button" onclick="update_st_str(<%=user_no %>,1, '<%=game_id%>')" class="btn btn-warning btn-xs">홀드</button>                                
                                <button type="button" onclick="update_st_str(<%=user_no %>,2, '<%=game_id%>')" class="btn btn-danger btn-xs">삭제</button>                                
                                <button type="button" onclick="update_st_str(<%=user_no %>,0, '<%=game_id%>')" class="btn btn-success btn-xs">정상</button>                                                                                                                                
                        </tr>
                         <%	listnumber = listnumber-1
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
		                    <% call Board_pagecount(go_url,opt_str) %>
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
