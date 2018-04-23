<%
realuser = "Y"
If realuser = "Y" Then
	searchSQL = searchSQL & " and user_distributor15_link <> 145 "	
End If    
    
sql="select count(number) from users with(nolock) "
sql=sql&" where 1=1 "&searchSQL
TOT__REAL_USER_CNT = CDbl(Replace(GetString_List(sql),RowDel,""))

sql="select count(number) from users with(nolock) "
TOT_USER_CNT = CDbl(Replace(GetString_List(sql),RowDel,""))

SQL00 = "SELECT SUM(user_money) AS TOT_USER_MONEY FROM users with(nolock) where user_distributor15_link not in (43,44,45)" & searchSQL
TOT_USER_MONEY = CDbl(Replace(GetString_List(SQL00),RowDel,""))

SQL00 = "SELECT isnull(SUM(user_money),0) AS TOT_USER_MONEY FROM users with(nolock) where user_distributor15_link=43" & searchSQL
TOT_ADMIN_MONEY = CDbl(Replace(GetString_List(SQL00),RowDel,""))

SQL00 = "SELECT isnull(SUM(user_money),0) AS TOT_USER_MONEY FROM users with(nolock) where user_distributor15_link in (44,45)" & searchSQL
TOT_ALBA_MONEY = CDbl(Replace(GetString_List(SQL00),RowDel,""))

SQL00 = "SELECT isnull(count(number),0) AS TOT_TODAY_REGUSER FROM users with(nolock) where convert(varchar(10),user_regdate,112)='"&now_date&"'" & searchSQL
TOT_TODAY_REGUSER = CDbl(Replace(GetString_List(SQL00),RowDel,""))


SQL00 = "select isnull(sum(outcome_amt),0) from TB_Deposit_log with(nolock) where status='Y' and jisa_id<>'마스터' and convert(varchar(10),approval_date,112)='"&now_date&"'" 
TOT_REAL_CHARGE_CNT = CDbl(Replace(GetString_List(SQL00),RowDel,""))

SQL00 = "select isnull(sum(outcome_amt),0) from TB_Deposit_log with(nolock) where status='Y' and convert(varchar(10),approval_date,112)='"&now_date&"'" 
TOT_CHARGE_CNT = CDbl(Replace(GetString_List(SQL00),RowDel,""))

'=======본사별 베팅 순위 ===================
sql="select top 5 jisa_id,sum(betting_amt) as betting_amt from deal_money_ins_log with(nolock) "
sql=sql&" where 1=1 and jisa_id is not null "
sql=sql&" group by jisa_id having jisa_id<>'NULL' and jisa_id<>'' and jisa_id<>'마스터' order by sum(betting_amt) desc"
With DBHelper	  
		set rs_idx = .ExecSQLReturnRS(sql, Nothing, Constring)
end With
If Not(rs_idx.Bof Or rs_idx.Eof) Then
    arrRs2 = rs_idx.getrows
    For i = 0 To Ubound(arrRs2, 2)	
        tot_jisa_amt = tot_jisa_amt + cdbl(arrRs2(1,i))
    next
End If
rs_idx.close
set rs_idx = nothing

'=======본사별 충전 순위 ===================
sql="select top 5 jisa_id,sum(outcome_amt) as outcome_amt  from tb_deposit_log"
sql=sql&" where status='Y' and jisa_id<>'' and jisa_id<>'마스터'"
sql=sql&" group by jisa_id order by sum(outcome_amt) desc"
With DBHelper	  
		set rs_idx = .ExecSQLReturnRS(sql, Nothing, Constring)
end With
If Not(rs_idx.Bof Or rs_idx.Eof) Then
    arrRs_charge = rs_idx.getrows    
End If
rs_idx.close
set rs_idx = nothing

'=======보유머니 ( 본사 ) ===================
sql="select top 5 user_id,deal_money from distributor15 where user_id<>'마스터' order by deal_money desc"
With DBHelper	  
		set rs_idx = .ExecSQLReturnRS(sql, Nothing, Constring)
end With
If Not(rs_idx.Bof Or rs_idx.Eof) Then
    arrRs3 = rs_idx.getrows
    For i = 0 To Ubound(arrRs3, 2)	
        tot_jisa_amt = tot_jisa_amt + cdbl(arrRs3(1,i))
    next
End If
rs_idx.close
set rs_idx = nothing

'=======충/환전 내역 ( 주간 ) ===================
sql="select  approval_date,sum(income_amt) as income_amt,sum(outcome_amt) as outcome_amt from ("
sql=sql&" select convert(varchar(10),approval_date,112) as approval_date,isnull(sum(outcome_amt),0) as income_amt,0 as outcome_amt "
sql=sql&" from tb_deposit_log where status='Y' and"
sql=sql&" convert(varchar(10),approval_date,112) between convert(varchar(10),dateadd(day,-7,getdate()),112)"
sql=sql&"  and convert(varchar(10),dateadd(day,0,getdate()),112)"
sql=sql&"  group by convert(varchar(10),approval_date,112) "
sql=sql&" union all"
sql=sql&" select convert(varchar(10),approval_date,112) as approval_date,0 as income_amt,isnull(sum(outcome_amt),0) as outcome_amt "
sql=sql&" from tb_outcome_log where status='Y' and"
sql=sql&" convert(varchar(10),approval_date,112) between convert(varchar(10),dateadd(day,-7,getdate()),112)"
sql=sql&"  and convert(varchar(10),dateadd(day,0,getdate()),112)"
sql=sql&"  group by convert(varchar(10),approval_date,112)"
sql=sql&"  union all"
sql=sql&"  select * from "
sql=sql&" ("
sql=sql&" select case convert(varchar(10),dateadd(day,-6,getdate()),112) when convert(varchar(10),dateadd(day,-6,getdate()),112) then convert(varchar(10),dateadd(day,-6,getdate()),112) end as approval_date,0 as income_amt,0 as outcome_amt "
sql=sql&" union all"
sql=sql&" select case convert(varchar(10),dateadd(day,-5,getdate()),112) when convert(varchar(10),dateadd(day,-5,getdate()),112) then convert(varchar(10),dateadd(day,-5,getdate()),112) end as approval_date,0 as income_amt,0 as outcome_amt "
sql=sql&" union all"
sql=sql&" select case convert(varchar(10),dateadd(day,-4,getdate()),112) when convert(varchar(10),dateadd(day,-4,getdate()),112) then convert(varchar(10),dateadd(day,-4,getdate()),112) end as approval_date,0 as income_amt,0 as outcome_amt "
sql=sql&" union all"
sql=sql&" select case convert(varchar(10),dateadd(day,-3,getdate()),112) when convert(varchar(10),dateadd(day,-3,getdate()),112) then convert(varchar(10),dateadd(day,-3,getdate()),112) end as approval_date,0 as income_amt,0 as outcome_amt "
sql=sql&" union all"
sql=sql&" select case convert(varchar(10),dateadd(day,-2,getdate()),112) when convert(varchar(10),dateadd(day,-2,getdate()),112) then convert(varchar(10),dateadd(day,-2,getdate()),112) end as approval_date,0 as income_amt,0 as outcome_amt "
sql=sql&" union all"
sql=sql&" select case convert(varchar(10),dateadd(day,-1,getdate()),112) when convert(varchar(10),dateadd(day,-1,getdate()),112) then convert(varchar(10),dateadd(day,-1,getdate()),112) end as approval_date,0 as income_amt,0 as outcome_amt "
sql=sql&" union all"
sql=sql&" select case convert(varchar(10),dateadd(day,0,getdate()),112) when convert(varchar(10),dateadd(day,0,getdate()),112) then convert(varchar(10),dateadd(day,0,getdate()),112) end as approval_date,0 as income_amt,0 as outcome_amt "
sql=sql&" ) date_qry"
sql=sql&" ) a group by approval_date"
With DBHelper	  
		set rs_idx = .ExecSQLReturnRS(sql, Nothing, Constring)
end With
If Not(rs_idx.Bof Or rs_idx.Eof) Then
    arrRs4 = rs_idx.getrows    
End If
rs_idx.close
set rs_idx = nothing

'=======QNA 최근게시글 ===================
sql="SELECT TOP 7 user_id,title,contents,reg_date,idx FROM [TB_QnA] with(nolock) order by idx desc"
With DBHelper	  
		set rs_idx = .ExecSQLReturnRS(sql, Nothing, Constring)
end With
If Not(rs_idx.Bof Or rs_idx.Eof) Then
    arrRs4 = rs_idx.getrows    
End If
rs_idx.close
set rs_idx = nothing

closeGameDB  
     %>
          <!-- top tiles -->
          <div class="row tile_count">
            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
              <span class="count_top"><i class="fa fa-user"></i> 전체 유저수(리얼)</span>
              <div class="count green" style="font-size:x-large;text-align:right"><%=formatnumber(TOT__REAL_USER_CNT,0)%>명</div>
              <span class="count_bottom"><i class="green" style="text-align:right">전체 유저수(전체)</i><%=formatnumber(TOT_USER_CNT,0)%>명</span>
            </div>
            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
              <span class="count_top"><i class="fa fa-clock-o"></i> 회원 보유머니</span>
              <div class="count green" style="font-size:x-large;text-align:right"><%=formatnumber(TOT_USER_MONEY,0)%>원</div>
              <!--span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>3% </i> From last Week</!--span-->
            </div>
            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
              <span class="count_top"><i class="fa fa-user"></i> 관리자 보유머니</span>
              <div class="count green" style="font-size:x-large;text-align:right"><%=formatnumber(TOT_ADMIN_MONEY,0)%>원</div>
              <!--span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>34% </i> From last Week</!--span-->
            </div>
            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
              <span class="count_top"><i class="fa fa-user"></i> 알바 보유머니</span>
              <div class="count green" style="font-size:x-large;text-align:right"><%=formatnumber(TOT_ALBA_MONEY,0)%>원</div>
              <!--span class="count_bottom"><i class="red"><i class="fa fa-sort-desc"></i>12% </i> From last Week</!--span-->
            </div>
            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
              <span class="count_top"><i class="fa fa-user"></i> 오늘 가입유저</span>
              <div class="count green" style="font-size:x-large;text-align:right"><%=formatnumber(TOT_TODAY_REGUSER,0)%>명</div>
              <!--span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>34% </i> From last Week</!--span-->
            </div>
            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
              <span class="count_top"><i class="fa fa-user"></i> 오늘 충전금액(리얼)</span>
              <div class="count green" style="font-size:x-large;text-align:right"><%=formatnumber(TOT_REAL_CHARGE_CNT,0)%>원</div>
              <span class="count_bottom"><i class="green"><i class="fa fa-sort-asc"></i>오늘 충전금액(전체) </i> <%=formatnumber(TOT_CHARGE_CNT,0)%>원</span>
            </div>
          </div>
          <!-- /top tiles -->          
          <div class="row">

            <div class="col-md-4 col-sm-4 col-xs-12">
              <div class="x_panel tile fixed_height_435">
                <div class="x_title">
                  <h2>본사별 베팅 순위</h2>
                  <ul class="nav navbar-right panel_toolbox">
                    <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                    </li>
                    <li class="dropdown">
                      <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                      <ul class="dropdown-menu" role="menu">
                        <li><a href="#">Settings 1</a>
                        </li>
                        <li><a href="#">Settings 2</a>
                        </li>
                      </ul>
                    </li>
                    <li><a class="close-link"><i class="fa fa-close"></i></a>
                    </li>
                  </ul>
                  <div class="clearfix"></div>
                </div>
                <div class="x_content">
            <%
   	            If IsArray(arrRs2)=True Then
                   tot_charge_rank = Ubound(arrRs2, 2)
                    For i = 0 To Ubound(arrRs2, 2)	        
                        if i = 0 then                            
                            max_charge_amt = cdbl(arrRs2(1,i))+10000
                        end if
		                charge_user_id = arrRs2(0,i)
                        charge_amt     = cdbl(arrRs2(1,i))
                %>
                  <div class="widget_summary">
                    <div class="w_left w_25">
                      <span><%=formatnumber(charge_amt,0)%>원</span>
                    </div>
                    <div class="w_center w_55">
                      <div class="progress">
                        <div class="progress-bar bg-green" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: <%=(charge_amt/max_charge_amt)*100%>%;">
                          <span class="sr-only">60% Complete</span>
                        </div>
                      </div>
                    </div>
                    <div class="w_right w_20">
                      <span><%=charge_user_id%></span>
                    </div>
                    <div class="clearfix"></div>
                  </div>
                    <%
                        tot_charge_rank = tot_charge_rank - 1
                    next
                end if
                     %>                 
                </div>
              </div>
              </div>
      
            <div class="col-md-4 col-sm-4 col-xs-12">
              <div class="x_panel tile fixed_height_435">
                <div class="x_title">
                  <h2>본사별 충전 순위</h2>
                  <ul class="nav navbar-right panel_toolbox">
                    <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                    </li>
                    <li class="dropdown">
                      <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                      <ul class="dropdown-menu" role="menu">
                        <li><a href="#">Settings 1</a>
                        </li>
                        <li><a href="#">Settings 2</a>
                        </li>
                      </ul>
                    </li>
                    <li><a class="close-link"><i class="fa fa-close"></i></a>
                    </li>
                  </ul>
                  <div class="clearfix"></div>
                </div>
                <div class="x_content">
            <%
   	            If IsArray(arrRs_charge)=True Then
                   tot_charge_rank = Ubound(arrRs_charge, 2)
                    For i = 0 To Ubound(arrRs_charge, 2)	        
                        if i = 0 then                            
                            max_charge_amt = cdbl(arrRs_charge(1,i))+10000
                        end if
		                charge_user_id = arrRs_charge(0,i)
                        charge_amt     = cdbl(arrRs_charge(1,i))
                %>
                  <div class="widget_summary">
                    <div class="w_left w_25">
                      <span><%=formatnumber(charge_amt,0)%>원</span>
                    </div>
                    <div class="w_center w_55">
                      <div class="progress">
                        <div class="progress-bar bg-green" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: <%=(charge_amt/max_charge_amt)*100%>%;">
                          <span class="sr-only">60% Complete</span>
                        </div>
                      </div>
                    </div>
                    <div class="w_right w_20">
                      <span><%=charge_user_id%></span>
                    </div>
                    <div class="clearfix"></div>
                  </div>
                    <%
                        tot_charge_rank = tot_charge_rank - 1
                    next
                end if
                     %>                 
                </div>
              </div>
              </div>

            <div class="col-md-4 col-sm-4 col-xs-12">
                <div class="x_panel ">
                  <div class="x_title">
                    <h2>본사 보유머니</h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                        <ul class="dropdown-menu" role="menu">
                          <li><a href="#">Settings 1</a>
                          </li>
                          <li><a href="#">Settings 2</a>
                          </li>
                        </ul>
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">

                    <div id="echart_pie" style="height:350px;"></div>

                  </div>
                </div>
              </div>

          </div>
          <div class="row">
            <div class="col-md-4 col-sm-4 col-xs-12">
              <div class="x_panel">
                <div class="x_title">
                  <h3>Q&A 최근 게시글</h3>
                  <ul class="nav navbar-right panel_toolbox">
                    <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                    </li>
                    <li class="dropdown">
                      <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                      <ul class="dropdown-menu" role="menu">
                        <li><a href="#">Settings 1</a>
                        </li>
                        <li><a href="#">Settings 2</a>
                        </li>
                      </ul>
                    </li>
                    <li><a class="close-link"><i class="fa fa-close"></i></a>
                    </li>
                  </ul>
                  <div class="clearfix"></div>
                </div>
                <div class="x_content">
                  <div class="dashboard-widget-content">

                    <ul class="list-unstyled timeline widget">
                    <%
   	                If IsArray(arrRs4)=True Then
                        tot_charge_rank = Ubound(arrRs4, 2)
                        For i = 0 To Ubound(arrRs4, 2)	        
		                    user_id = arrRs4(0,i)
                            if len(arrRs4(1,i)) > 20 then
                                title = left(arrRs4(1,i),20)&"..."
                            else
                                title = arrRs4(1,i)
                            end if
                            if len(arrRs4(2,i)) > 30 then
                                content = left(arrRs4(2,i),30)&"..."
                            else
                                content = arrRs4(2,i)
                            end if
                            qna_reg_date = arrRs4(3,i)
                            qna_no = arrRs4(4,i)
                    %>
                      <li>
                        <div class="block">
                          <div class="block_content">
                            <h2 class="title">
                                              <a><%=title%></a>
                                          </h2>
                            <div class="byline">
                              <span><%=qna_reg_date%></span> by <a><%=user_id%></a>
                            </div>
                            <p class="excerpt"><%=content%> <a href="/$adm/bonsa/qna_view.asp?gubun=Y&no=<%=qna_no%>">더 보기</a>
                            </p>
                          </div>
                        </div>
                      </li>
                     <%
                         next
                     end if
                          %>
                    </ul>
                  </div>
                </div>
              </div>
            </div>


            <div class="col-md-8 col-sm-8 col-xs-12">



              <div class="row">

                <div class="col-md-12 col-sm-12 col-xs-12">
                  <div class="x_panel">
                    <div class="x_title">
                      <h2>Visitors location <small>geo-presentation</small></h2>
                      <ul class="nav navbar-right panel_toolbox">
                        <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                        </li>
                        <li class="dropdown">
                          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                          <ul class="dropdown-menu" role="menu">
                            <li><a href="#">Settings 1</a>
                            </li>
                            <li><a href="#">Settings 2</a>
                            </li>
                          </ul>
                        </li>
                        <li><a class="close-link"><i class="fa fa-close"></i></a>
                        </li>
                      </ul>
                      <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                      <div class="dashboard-widget-content">
                        <div class="col-md-4 hidden-small">
                          <h2 class="line_30">125.7k Views from 60 countries</h2>

                          <table class="countries_list">
                            <tbody>
                              <tr>
                                <td>United States</td>
                                <td class="fs15 fw700 text-right">33%</td>
                              </tr>
                              <tr>
                                <td>France</td>
                                <td class="fs15 fw700 text-right">27%</td>
                              </tr>
                              <tr>
                                <td>Germany</td>
                                <td class="fs15 fw700 text-right">16%</td>
                              </tr>
                              <tr>
                                <td>Spain</td>
                                <td class="fs15 fw700 text-right">11%</td>
                              </tr>
                              <tr>
                                <td>Britain</td>
                                <td class="fs15 fw700 text-right">10%</td>
                              </tr>
                            </tbody>
                          </table>
                        </div>
                        <div id="world-map-gdp" class="col-md-8 col-sm-12 col-xs-12" style="height:230px;"></div>
                      </div>
                    </div>
                  </div>
                </div>

              </div>
              <div class="row">


                <!-- Start to do list -->
                <div class="col-md-6 col-sm-6 col-xs-12">
                  <div class="x_panel">
                    <div class="x_title">
                      <h2>To Do List <small>Sample tasks</small></h2>
                      <ul class="nav navbar-right panel_toolbox">
                        <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                        </li>
                        <li class="dropdown">
                          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                          <ul class="dropdown-menu" role="menu">
                            <li><a href="#">Settings 1</a>
                            </li>
                            <li><a href="#">Settings 2</a>
                            </li>
                          </ul>
                        </li>
                        <li><a class="close-link"><i class="fa fa-close"></i></a>
                        </li>
                      </ul>
                      <div class="clearfix"></div>
                    </div>
                    <div class="x_content">

                      <div class="">
                        <ul class="to_do">
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Schedule meeting with new client </p>
                          </li>
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Create email address for new intern</p>
                          </li>
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Have IT fix the network printer</p>
                          </li>
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Copy backups to offsite location</p>
                          </li>
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Food truck fixie locavors mcsweeney</p>
                          </li>
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Food truck fixie locavors mcsweeney</p>
                          </li>
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Create email address for new intern</p>
                          </li>
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Have IT fix the network printer</p>
                          </li>
                          <li>
                            <p>
                              <input type="checkbox" class="flat"> Copy backups to offsite location</p>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- End to do list -->
                
                <!-- start of weather widget -->
                <div class="col-md-6 col-sm-6 col-xs-12">
                  <div class="x_panel">
                    <div class="x_title">
                      <h2>Daily active users <small>Sessions</small></h2>
                      <ul class="nav navbar-right panel_toolbox">
                        <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                        </li>
                        <li class="dropdown">
                          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>
                          <ul class="dropdown-menu" role="menu">
                            <li><a href="#">Settings 1</a>
                            </li>
                            <li><a href="#">Settings 2</a>
                            </li>
                          </ul>
                        </li>
                        <li><a class="close-link"><i class="fa fa-close"></i></a>
                        </li>
                      </ul>
                      <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                      <div class="row">
                        <div class="col-sm-12">
                          <div class="temperature"><b>Monday</b>, 07:30 AM
                            <span>F</span>
                            <span><b>C</b></span>
                          </div>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-sm-4">
                          <div class="weather-icon">
                            <canvas height="84" width="84" id="partly-cloudy-day"></canvas>
                          </div>
                        </div>
                        <div class="col-sm-8">
                          <div class="weather-text">
                            <h2>Texas <br><i>Partly Cloudy Day</i></h2>
                          </div>
                        </div>
                      </div>
                      <div class="col-sm-12">
                        <div class="weather-text pull-right">
                          <h3 class="degrees">23</h3>
                        </div>
                      </div>

                      <div class="clearfix"></div>

                      <div class="row weather-days">
                        <div class="col-sm-2">
                          <div class="daily-weather">
                            <h2 class="day">Mon</h2>
                            <h3 class="degrees">25</h3>
                            <canvas id="clear-day" width="32" height="32"></canvas>
                            <h5>15 <i>km/h</i></h5>
                          </div>
                        </div>
                        <div class="col-sm-2">
                          <div class="daily-weather">
                            <h2 class="day">Tue</h2>
                            <h3 class="degrees">25</h3>
                            <canvas height="32" width="32" id="rain"></canvas>
                            <h5>12 <i>km/h</i></h5>
                          </div>
                        </div>
                        <div class="col-sm-2">
                          <div class="daily-weather">
                            <h2 class="day">Wed</h2>
                            <h3 class="degrees">27</h3>
                            <canvas height="32" width="32" id="snow"></canvas>
                            <h5>14 <i>km/h</i></h5>
                          </div>
                        </div>
                        <div class="col-sm-2">
                          <div class="daily-weather">
                            <h2 class="day">Thu</h2>
                            <h3 class="degrees">28</h3>
                            <canvas height="32" width="32" id="sleet"></canvas>
                            <h5>15 <i>km/h</i></h5>
                          </div>
                        </div>
                        <div class="col-sm-2">
                          <div class="daily-weather">
                            <h2 class="day">Fri</h2>
                            <h3 class="degrees">28</h3>
                            <canvas height="32" width="32" id="wind"></canvas>
                            <h5>11 <i>km/h</i></h5>
                          </div>
                        </div>
                        <div class="col-sm-2">
                          <div class="daily-weather">
                            <h2 class="day">Sat</h2>
                            <h3 class="degrees">26</h3>
                            <canvas height="32" width="32" id="cloudy"></canvas>
                            <h5>10 <i>km/h</i></h5>
                          </div>
                        </div>
                        <div class="clearfix"></div>
                      </div>
                    </div>
                  </div>

                </div>
                <!-- end of weather widget -->
              </div>
            </div>
          </div>                
