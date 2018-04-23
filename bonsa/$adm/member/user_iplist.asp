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
end if
page_size = Request("page_size")
page = Request("page")
if page = "" then
	page = 1
else 
	page = cint(page)
end if
connectionGameDB("PNC")

parameters = "f_storecode_key=" & f_storecode_key & "&search_date=" & search_date & "&keyfield=" & keyfield & "&keyword=" & escape(keyword) & "&period=" & period
parameters = parameters & "&syear=" & syear & "&smonth=" & smonth & "&sday=" & sday
parameters = parameters & "&lyear= " & lyear & "&l_month=" & l_month & "&l_day=" & l_day & "&page_size=" & page_size & "&u_id=" & u_id

move_url = "user_iplist.asp?" & parameters

if keyword <> "" then 
    if keyfield = "user_ip" then
	searchSQL = searchSQL & " where " & keyfield & " like '%"& keyword &"%'"
    else
    searchSQL = searchSQL & " where " & keyfield & " = '"& keyword &"'"
    end if
    sql=" select count(user_id) from UserIPList "&replace(searchSQL ,"b.","")
    RecordCount = CDbl(Replace(GetString_List(sql),RowDel,""))
else
    RecordCount = 0
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
    function excel_down(keyfield, keyword) {

        document.getElementById("excelfrm").src = "user_iplist_excel.asp?keyfield=" + keyfield + "&keyword=" + keyword;
    }
    //-->
</SCRIPT>
  <body class="nav-md">
<iframe name="excelfrm" id="excelfrm" style="width:0px;height:0px;display:none"></iframe>
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
                    <h3>IP목록</h3>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">                        
                    <div class="row form-inline form-group  pull-right">
                        <form name="frm1" method="post" action="?">
                           <div class="col-sm-12">		                               
                                <label><h2>총 검색개수 : <%=RecordCount%>개</h2></label>
                                <select name="keyfield" class="select2_single form-control">
                                    <option value="b.user_id" <%if keyfield="b.user_id" then response.write "selected" end if%>>회원ID</option>
                                    <option value="user_name" <%if keyfield="user_name" then response.write "selected" end if%>>닉네임</option>
                                    <option value="user_ip" <%if keyfield="user_ip" then response.write "selected" end if%>>아이피</option>            
                                </select>
                                &nbsp;&nbsp;<input type="text" name="keyword" size="20" value="<%=keyword%>" onFocus="this.select()"  class="form-control">
                                &nbsp;&nbsp;<input type=button name=headregist value=" 검색 " onClick="javascript: goWrite()" class="btn btn-info form-control">
                                <input type="button" value="엑셀다운로드" class="btn btn-success form-control" onclick="excel_down('<%=keyfield%>', '<%=keyword%>')" />
                           </div>
                        </form>
                    </div>        
                    <table id="member_list_table" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
                      <thead>                         
                        <tr class="alert alert-info alert-dismissible fade in">
	                        <th style="text-align:center" height="25" width="5%"><b>번호</b></th>
                            <th style="text-align:center" height="25" width="10%"><b>본사ID</b></th>
                            <th style="text-align:center" height="25" width="10%"><b>총판ID</b></th>
                            <th style="text-align:center" height="25" width="10%"><b>매장ID</b></th>
                            <th style="text-align:center" height="25" width="10%"><b>유저ID</b></th>
	                        <th style="text-align:center" height="25" width="10%"><b>닉네임</b></th>
                            <th style="text-align:center" height="25" width="15%"><b>IP</b></th>
	                        <th style="text-align:center" height="25" width="30%"><b>접속일자</b></th>  
                        </tr>
                      </thead>
                      <tbody>
                  <%
                    if RecordCount > 0 then
                FirstRow = (page-1)* PageSize+1
                LastRow = (Page-1)*PageSize+PageSize 
                sql=" select * from ("
                sql=sql&" select jisa_id,chongpan_id,shop_id,a.*,ROW_NUMBER() OVER(ORDER BY user_date desc) AS 'RowNumber' from UserIPList a inner join v_member_list01 b on a.user_id=b.user_id "&searchSQL&") a where RowNumber between "&FirstRow&" and "&LastRow

                    RegList = GetString_List(sql)
    
                    Record_String = RegList  
                  end if

   	                if RegList = "" then
                 %>
                    <tr bgcolor="#FCF7ED" height="25"> 	                    
                    </tr>
                  <%else 
    	
	                    Rows = split(RegList,RowDel)
	                    For i = 0 to UBound(Rows)-1
		                    Cols = split(Rows(i),ColDel)      
                            jisa_id= Cols(0)
                            chongpan_id= Cols(1)
                            shop_id= Cols(2)
                            user_id= Cols(3)
                            sql=" select isnull(sum(a.distribute3_rate)+sum(b.distribute2_rate)+sum(c.distribute15_rate),0) from distributor3 a inner join distributor2 b on a.distribute2_link=b.number inner join distributor15 c"
                            sql=sql&" on a.distribute15_link=c.number inner join users d on a.number=d.user_distributor3_link where d.user_id='"&user_id&"'"
            
                            tot_sum_deal_money = CDbl(Replace(GetString_List(sql),RowDel,""))          
                            if tot_sum_deal_money>0 then
                                notdealmoney = "N"
                            else
                                notdealmoney = "Y"
                            end if                       
                            user_nick= Cols(4)
                            user_ip= Cols(5)
                            user_date= Cols(6)          
                            RowNumber=Cols(7)
                    %>
                    <tr bgcolor="#FCF7ED" height="25"> 
	                    <td align="center" height="25"><b><%=RowNumber%></b></td>
                        <td align="center" height="25"><b style="color:<%if notdealmoney = "N" then%>black<%else%>blue<%end if%>"><%=jisa_id%></b></td>
                        <td align="center" height="25"><b style="color:<%if notdealmoney = "N" then%>black<%else%>blue<%end if%>"><%=chongpan_id%></b></td>
                        <td align="center" height="25"><b style="color:<%if notdealmoney = "N" then%>black<%else%>blue<%end if%>"><%=shop_id%></b></td>
                        <td align="center" height="25"><b style="color:<%if notdealmoney = "N" then%>black<%else%>blue<%end if%>"><%=user_id%></b></td>
                        <td align="center" height="25"><b style="color:<%if notdealmoney = "N" then%>black<%else%>blue<%end if%>"><%=user_nick%></b></td>
	                    <td align="center" height="25"><b><%=user_ip%></b></td>
                        <td align="center" height="25"><b><%=user_date%></b></td>	    
                    </tr>
                         <%
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
