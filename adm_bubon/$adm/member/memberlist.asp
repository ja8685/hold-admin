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
dis_no = request.Cookies(admincheck)("adminNo")

usercheck = Request("usercheck")

If usercheck = "" Then
	usercheck = "F"
End If

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & keyword & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size& "&usercheck=" & usercheck

move_url = "memberlist.asp?" & parameters
'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
startpage	= request("startpage")
page		= request("page")	
go_url		= Request.Servervariables("path_info")
opt_str		= "&stc_type="& stc_type &"&stc_id="&stc_id &"&menukind="&menukind&parameters	                    
'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if keyword <> "" then 
	searchSQL = searchSQL & " where " & keyfield & " like '%"& keyword &"%'"
end if

sql="select * from (select a.user_id,user_nick,user_money as user_money,user_save as user_save,c.user_ip as connect_status,user_currentdate,a.user_regdate,user_phone as f_hp,'' as f_email,shop_id,chongpan_id,bonsa_id,jisa_id from users a with(nolock) "
sql=sql&" left outer join connectedusers c with(nolock) on a.user_id=c.user_id left outer join v_member_list01 d on a.user_id=d.user_id"
sql=sql&" where user_distributor15_link IN (" & request.Cookies(admincheck)("BubonJisaNo") & ")"
sql=sql&" and a.user_state<>2 "
If usercheck = "Y" Then
	sql = sql & " and c.user_ip is not null and len(c.user_ip) > 0"
End If
sql=sql&" ) a"
if IDAuth = 99 then
if keyword <> "" then 
	sql = sql & " where " & keyfield & " like '%"& keyword &"%'"
end if
else
if keyword <> "" then 
	sql = sql & " where " & keyfield & " like '%"& keyword &"%'"
end if
end If


sql = sql & " order by user_regdate desc"
sql_member = sql
'Response.write sql
RegList = GetString_List(sql)
Record_String = RegList 
Rows = split(RegList,RowDel)
RecordCount = UBound(Rows)  

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
                    <h3>회원리스트</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                        <div class="row pull-right">
                            <form name="frm1" method="post" action="?" class="form-horizontal">
	                                <input type="hidden" name="user_id" />                       
                                    <div class="form-inline form-group" >                                                    
                                        <select name="keyfield" id="heard" class="form-control col-sm-3" required>
                                        <option value="a.user_id" <%if keyfield="a.user_id" then response.write "selected" end if%>>회원ID</option>
                                        <option value="user_nick" <%if keyfield="a.user_nick" then response.write "selected" end if%>>닉네임</option>  
                                        </select>                                                                                            
                                    &nbsp;&nbsp;<input type="text" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()" class="form-control col-sm-4" />
                                    &nbsp;&nbsp;<input type="radio" class="radio form-control" name="usercheck" value="F" <% If usercheck ="F" Then Response.write "checked" End If %> /> 전체 
                                                <input type="radio" class="radio form-control" name="usercheck" value="Y" <% If usercheck ="Y" Then Response.write "checked" End If %> /> 접속중인회원
                                    &nbsp;&nbsp;<input type=button name=headregist value=" 검색 " onClick="javascript: goWrite()" class="btn btn-primary form-control col-sm-1" />
                                </div>
                            </form>
                        </div>
                      <div class="row">&nbsp;</div>                    
                    <table id="member_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25"><b>번호</b></th>
                            <th style="text-align:center" height="25"><b>본사ID</b></th>
                            <th style="text-align:center" height="25"><b>총판ID</b></th>
                            <th style="text-align:center" height="25"><b>매장ID</b></th>
                            <th style="text-align:center" height="25"><b>회원ID</b></th>
                            <!--th style="text-align:center" height="25"><b>본사ID</b></th-->
                            <th style="text-align:center" height="25"><b>닉네임</b></th>
	                        <th style="text-align:center" height="25"><b>게임머니</b></th>
                            <th style="text-align:center" height="25"><b>금고머니</b></th>
                            <th style="text-align:center" height="25"><b>합계머니</b></th>
                            <!--th style="text-align:center" height="25"><b>금고머니</b></th-->
                            <%if IDAuth=1 then %>
                            <!--th style="text-align:center" height="25"><b>총판골드 충전/회수</b></th-->
                            <%end if %>
	                        <th style="text-align:center" height="25"><b>상태</b></th>
                            <th style="text-align:center" height="25"><b>최근접속일</b></th>
	                        <th style="text-align:center" height="25"><b>등록일</b></th>
                            <th style="text-align:center" height="25"><b>전화번호</b></th> 
                        </tr>
                      </thead>
                      <tbody>
                   <%
                      Set rs1=server.createobject("adodb.recordset")
                        rs1.open sql_member,GameDBconn,1

	                        If scnt="" Then 
		                        rs1.pagesize=20		'한페이지에 출력할 총수 
	                        Else
		                        rs1.pagesize=slist
	                        End If
                            listnumber = rs1.recordcount
                            page_list = 10		'페이지 바로가기의 갯수		



                            If page <= 1 then	'현재페이지 구하기
	                            page = 1
                            End If

                            totalrecord=RS1.recordcount	'총 레코드 수
                            totalpage=RS1.pagecount	'총 페이지 구하기


                            if totalrecord <> 0 then	'현재 페이지에서 첫번째 레코드를 가르킴
                                rs1.absolutepage = page 
                            end if

                            cnumber = (page-1) * rs1.pagesize '게시물에 대한 일괄적인 번호 붙이기
                            listnumber = totalrecord - cnumber

                            if startpage <= 0 then	'바로가기 목록의 시작페이지를 받아 온다.
	                            startpage = 1
                            end if
                            if not rs1.eof then
                                RegList = rs1.GetRows(rs1.pagesize)                           
                            end if
                            set rs1 = nothing
                                if startpage = "" then
                                startpage = 1
                                end if
                    closeGameDB
                       
   	                    if isArray(RegList)=false then
                     %>
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#charge_td").attr("colspan", 11);

                        })
                    </script>
                        <tr height="25"> 
	                        <td id="charge_td" align="center" height="25"><b>등록된 회원이 없습니다.</b></td>
                        </tr>
                      <%else 
    	
	                         FOR rowcounter= 0 TO UBound(RegList,2) 
	                            'RecordSet항목
		                        user_id = RegList(0,rowcounter)
                                nick = RegList(1,rowcounter)
		                        gold = cdbl(RegList(2,rowcounter))
		                        save = cdbl(RegList(3,rowcounter))
                                tot_money = gold+save
		                        isconnected = trim(RegList(4,rowcounter))
                                if len(isconnected)>0 then
                                    isconnected = "<font color=""red"">ON</font>"
                                else
                                    isconnected = "<font color=""gray"">OFF</font>"
                                end if
                                last_conn_date = RegList(5,rowcounter)
		                        reg_date = RegList(6,rowcounter)
                                tel = RegList(7,rowcounter)
                                email = RegList(8,rowcounter)
                                shop_id = RegList(9,rowcounter)
                                chongpan_id= RegList(10,rowcounter)
                                bonsa_id= RegList(11,rowcounter)
                                jisa_id= RegList(12,rowcounter)
            
                        %>
                        <tr height="25"> 
	                        <td align="center" height="25"><%=listnumber%></td>         
                            <td align="center" height="25"><b><%=jisa_id%></b></td>
                            <td align="center" height="25"><b><%=chongpan_id%></b></td>
                            <td align="center" height="25"><b><%=shop_id%></b></td>
                            <td align="center" height="25"><a href="./memberdetail.asp?user_id=<%=user_id%>"><b><%=user_id%></b></a></td>
                            <td align="center" height="25"><b><%=nick%></b></td>
	                        <td align="right" height="25" style="padding-right:10px"><b><%=formatnumber(gold,0)%></b></td>
                            <td align="right" height="25" style="padding-right:10px"><b><%=formatnumber(save,0)%></b></td>
                            <td align="right" height="25" style="padding-right:10px"><b><%=formatnumber(tot_money,0)%></b></td>
                            <td align="center" height="25"><b><%=isconnected%></b></td>
                            <td align="center" height="25"><b><%=last_conn_date%></b></td>
	                        <td align="center" height="25"><b><%=reg_date%></b></td>
                            <td align="center" height="25"><b><%=tel%></b></td>					    
                        </tr>
                         <%	listnumber = listnumber-1
	                        Next
     
                       end if%>     
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