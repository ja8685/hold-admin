<!-- 헤더 JS/CSS 메뉴 -->
<!-- #include virtual="/$adm/include/header.asp" -->
<!-- 헤더 JS/CSS 끝 -->
<!-- #include virtual="/$adm/include/ConnectionDB.asp" -->
<!-- #include virtual="/$adm/include/DBHelper.asp" -->
<%
user_id = trim(Request.Cookies(admincheck)("adminID"))
if user_id = "" then
response.End
end if
connectionGameDB("PNC")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))
if IDAuth = 0 then
    sql=" select self_rate from dealer_rate_manager"
    boss_rate = CDbl(Replace(GetString_List(sql),RowDel,""))
    sql="select * from boss_distributor"
    authtitle = "루트본사"
elseif IDAuth = 1 then
    sql="select distribute1_rate from distributor1 where user_id='"&user_id&"'"
    boss_rate = CDbl(Replace(GetString_List(sql),RowDel,""))
    sql="select * from distributor1 where user_id='"&user_id&"'"
    authtitle = "본사"
elseif IDAuth = 2 then
    sql="select distribute2_rate from distributor2 where user_id='"&user_id&"'"
    boss_rate = CDbl(Replace(GetString_List(sql),RowDel,""))
    sql="select * from distributor2 where user_id='"&user_id&"'"
    authtitle = "총판"
elseif IDAuth = 3 then
    sql=" select distribute3_rate from distributor3 where number="&trim(Request.Cookies(admincheck)("adminNo"))
    boss_rate = CDbl(Replace(GetString_List(sql),RowDel,""))
    sql="select * from distributor3 where user_id='"&user_id&"'"
    authtitle = "매장"
end if 
 %>
<SCRIPT LANGUAGE="JavaScript">
<!--
    function goWrite() {
        var f = document.frm1;
        if (f.user_pwd.value == "") {
            alert("패스워드를 입력해 주세요!");
            f.user_pwd.focus();
            return;
        }
        if (f.user_pwd_chk.value == "") {
            alert("패스워드를 입력해 주세요!");
            f.user_pwd_chk.focus();
            return;
        }
        if (f.user_pwd.value != f.user_pwd_chk.value) {
            alert("패스워드가 일치하지 않습니다!");
            return;
        }
        document.frm1.target = "Hframe";
        document.frm1.submit();
    }
//-->
</SCRIPT>
   <iframe name="Hframe" width="0" height="0" frameborder="0" style="display:none"></iframe>
  <body class="nav-md">
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
                    <h2><%=authtitle%> 정보변경</h2>
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
                               <table><tr><td height="30"></td></tr></table>
                            <%  

                                RegList = GetString_List(sql)
                                closeGameDB
                                Record_String = RegList  
   	                            if RegList = "" then
                             %>
                              <%else 
    	
	                                Rows = split(RegList,RowDel)
	                                For i = 0 to UBound(Rows)-1
        
		                                Cols = split(Rows(i),ColDel)            
                                        if IDAuth = 0 then
                                            gold = Cols(1)	
                                            user_nm = Cols(2)		               
                                            reg_date = Cols(5)
                                            bank_name    = trim(Cols(10))
                                            accountno    = trim(Cols(11))
                                            account_name    = trim(Cols(12))
                                        elseif IDAuth = 1 then		               
                                            user_nm = Cols(3)		               
                                            reg_date = Cols(8)
                                            bank_name    = trim(Cols(9))
                                            accountno    = trim(Cols(10))
                                            account_name    = trim(Cols(11))
                                            gold = Cols(14)	
                                        elseif IDAuth = 3 then		               
                                            user_nm = Cols(3)		               
                                            reg_date = Cols(9)
                                            bank_name    = trim(Cols(10))
                                            accountno    = trim(Cols(11))
                                            account_name    = trim(Cols(12))
                                            gold = Cols(14)	
                                        end if
            
                                    Next     
                               end if
                               closeDB

                               %>
                    <form data-parsley-validate class="form-horizontal form-label-left" name="frm1" method="post" action="update_boss_pwd_ok.asp">
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name"><%=authtitle%>ID 
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                             <label class="control-label" for="user_id"><%=user_id%></label>
                          
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name"><%=authtitle%>이름
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id"><%=user_nm%></label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>                     
                     <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="user_pwd" class="date-picker form-control col-md-7 col-xs-12" name="user_pwd" type="password">
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">패스워드 확인
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="user_pwd_chk" class="date-picker form-control col-md-7 col-xs-12" name="user_pwd_chk" type="password">
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                        <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">수수료
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id"><%=boss_rate%>%</label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">은행명
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="bank_name" class="date-picker form-control col-md-7 col-xs-12" name="bank_name" type="text" value="<%=bank_name%>" maxlength="50" />
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">계좌번호
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="accountno" class="date-picker form-control col-md-7 col-xs-12" name="accountno" type="text" value="<%=accountno%>" maxlength="50" />
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">예금주
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <input id="account_name" class="date-picker form-control col-md-7 col-xs-12" name="account_name" type="text" value="<%=account_name%>" maxlength="50" />
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">골드
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id"><%=formatnumber(gold,0)%></label>
                        </div>
                      </div>                             
                      <div class="ln_solid"></div>
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">가입일자
                        </label>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                          <label class="control-label" for="user_id"><%=reg_date%></label>
                        </div>
                      </div>
                      <div class="ln_solid"></div>
                      <br />
                      <div class="form-group text-center">
                        <div class="col-md-6 col-sm-6 col-xs-12 col-md-offset-3">
                          <button class="btn btn-primary" onclick="goWrite();return false" type="button">수정</button>
						  <button class="btn btn-info" onclick="history.back()" type="reset">돌아가기</button>
                        </div>
                      </div>
                    </form>
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
    </div>
        <!-- Javascript 파일 -->
        <!-- #include virtual="/$adm/include/jQuery.asp" -->
        <!-- Javascript 파일 끝 -->
<script>
    	$(document).ready(function () {		     
            //====충/환전 내역========//
            if ($('#mybarChart').length ){ 
			  
			  var ctx = document.getElementById("mybarChart");
			  var mybarChart = new Chart(ctx, {
				type: 'bar',
				data: {
				  labels: ["월", "화", "수", "목", "금", "토", "일"],
				  datasets: [{
					label: '# of Votes',
					backgroundColor: "#26B99A",
					data: [51, 30, 40, 28, 92, 50, 45]
				  }, {
					label: '# of Votes',
					backgroundColor: "#03586A",
					data: [41, 56, 25, 48, 72, 34, 12]
				  }]
				},

				options: {
				  scales: {
					yAxes: [{
					  ticks: {
						beginAtZero: true
					  }
					}]
				  }
				}
			  });
			} 
  
    
   function init_echarts() {
		
				if( typeof (echarts) === 'undefined'){ return; }
				console.log('init_echarts');
			
		
				  var theme = {
				  color: [
					  '#26B99A', '#34495E', '#BDC3C7', '#3498DB',
					  '#9B59B6', '#8abb6f', '#759c6a', '#bfd3b7'
				  ],

				  title: {
					  itemGap: 8,
					  textStyle: {
						  fontWeight: 'normal',
						  color: '#408829'
					  }
				  },

				  dataRange: {
					  color: ['#1f610a', '#97b58d']
				  },

				  toolbox: {
					  color: ['#408829', '#408829', '#408829', '#408829']
				  },

				  tooltip: {
					  backgroundColor: 'rgba(0,0,0,0.5)',
					  axisPointer: {
						  type: 'line',
						  lineStyle: {
							  color: '#408829',
							  type: 'dashed'
						  },
						  crossStyle: {
							  color: '#408829'
						  },
						  shadowStyle: {
							  color: 'rgba(200,200,200,0.3)'
						  }
					  }
				  },

				  dataZoom: {
					  dataBackgroundColor: '#eee',
					  fillerColor: 'rgba(64,136,41,0.2)',
					  handleColor: '#408829'
				  },
				  grid: {
					  borderWidth: 0
				  },

				  categoryAxis: {
					  axisLine: {
						  lineStyle: {
							  color: '#408829'
						  }
					  },
					  splitLine: {
						  lineStyle: {
							  color: ['#eee']
						  }
					  }
				  },

				  valueAxis: {
					  axisLine: {
						  lineStyle: {
							  color: '#408829'
						  }
					  },
					  splitArea: {
						  show: true,
						  areaStyle: {
							  color: ['rgba(250,250,250,0.1)', 'rgba(200,200,200,0.1)']
						  }
					  },
					  splitLine: {
						  lineStyle: {
							  color: ['#eee']
						  }
					  }
				  },
				  timeline: {
					  lineStyle: {
						  color: '#408829'
					  },
					  controlStyle: {
						  normal: {color: '#408829'},
						  emphasis: {color: '#408829'}
					  }
				  },

				  k: {
					  itemStyle: {
						  normal: {
							  color: '#68a54a',
							  color0: '#a9cba2',
							  lineStyle: {
								  width: 1,
								  color: '#408829',
								  color0: '#86b379'
							  }
						  }
					  }
				  },
				  map: {
					  itemStyle: {
						  normal: {
							  areaStyle: {
								  color: '#ddd'
							  },
							  label: {
								  textStyle: {
									  color: '#c12e34'
								  }
							  }
						  },
						  emphasis: {
							  areaStyle: {
								  color: '#99d2dd'
							  },
							  label: {
								  textStyle: {
									  color: '#c12e34'
								  }
							  }
						  }
					  }
				  },
				  force: {
					  itemStyle: {
						  normal: {
							  linkStyle: {
								  strokeColor: '#408829'
							  }
						  }
					  }
				  },
				  chord: {
					  padding: 4,
					  itemStyle: {
						  normal: {
							  lineStyle: {
								  width: 1,
								  color: 'rgba(128, 128, 128, 0.5)'
							  },
							  chordStyle: {
								  lineStyle: {
									  width: 1,
									  color: 'rgba(128, 128, 128, 0.5)'
								  }
							  }
						  },
						  emphasis: {
							  lineStyle: {
								  width: 1,
								  color: 'rgba(128, 128, 128, 0.5)'
							  },
							  chordStyle: {
								  lineStyle: {
									  width: 1,
									  color: 'rgba(128, 128, 128, 0.5)'
								  }
							  }
						  }
					  }
				  },
				  gauge: {
					  startAngle: 225,
					  endAngle: -45,
					  axisLine: {
						  show: true,
						  lineStyle: {
							  color: [[0.2, '#86b379'], [0.8, '#68a54a'], [1, '#408829']],
							  width: 8
						  }
					  },
					  axisTick: {
						  splitNumber: 10,
						  length: 12,
						  lineStyle: {
							  color: 'auto'
						  }
					  },
					  axisLabel: {
						  textStyle: {
							  color: 'auto'
						  }
					  },
					  splitLine: {
						  length: 18,
						  lineStyle: {
							  color: 'auto'
						  }
					  },
					  pointer: {
						  length: '90%',
						  color: 'auto'
					  },
					  title: {
						  textStyle: {
							  color: '#333'
						  }
					  },
					  detail: {
						  textStyle: {
							  color: 'auto'
						  }
					  }
				  },
				  textStyle: {
					  fontFamily: 'Arial, Verdana, sans-serif'
				  }
			  };
			   //echart Pie
		<%
   	    If IsArray(arrRs3)=True Then                   
            For i = 0 To Ubound(arrRs3, 2)	        
                jisa_id      = arrRs3(0,i)
                arr_jisa_id = arr_jisa_id & "'" &jisa_id& "'"
                if i < Ubound(arrRs3, 2) then
                    arr_jisa_id = arr_jisa_id &","
                end if
                jisa_amt     = cdbl(arrRs3(1,i))
                jisa_amt_rate = formatnumber((jisa_amt/tot_jisa_amt)*100,2)
                txt_str = txt_str & "{"
				txt_str = txt_str & "value: "&jisa_amt&","
				txt_str = txt_str & "name: '"&jisa_id&"'"
				txt_str = txt_str & "}"
                if i < Ubound(arrRs3, 2) then
                    txt_str = txt_str &","
                end if
            next
        end if                
        %>  
			if ($('#echart_pie').length ){  
			  
			  var echartPie = echarts.init(document.getElementById('echart_pie'), theme);

			  echartPie.setOption({
				tooltip: {
				  trigger: 'item',
				  formatter: "{a} <br/>{b} : {c} ({d}%)"
				},
				legend: {
				  x: 'center',
				  y: 'bottom',
				  data: [<%=arr_jisa_id%>]
				},
				toolbox: {
				  show: true,
				  feature: {
					magicType: {
					  show: true,
					  type: ['pie', 'funnel'],
					  option: {
						funnel: {
						  x: '25%',
						  width: '50%',
						  funnelAlign: 'left',
						  max: 1548
						}
					  }
					},
					restore: {
					  show: true,
					  title: "Restore"
					},
					saveAsImage: {
					  show: true,
					  title: "Save Image"
					}
				  }
				},
				calculable: true,
				series: [{
				  name: '지사 보유머니',
				  type: 'pie',
				  radius: '55%',
				  center: ['50%', '48%'],
				  data: [<%=txt_str%>]
				}]
			  });

			  var dataStyle = {
				normal: {
				  label: {
					show: false
				  },
				  labelLine: {
					show: false
				  }
				}
			  };

			  var placeHolderStyle = {
				normal: {
				  color: 'rgba(0,0,0,0)',
				  label: {
					show: false
				  },
				  labelLine: {
					show: false
				  }
				},
				emphasis: {
				  color: 'rgba(0,0,0,0)'
				}
			  };

			} 
			
		}  
			init_echarts();
		});
</script>
  </body>
</html>
