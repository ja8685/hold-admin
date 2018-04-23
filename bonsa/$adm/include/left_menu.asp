<%'=request.Cookies(admincheck)("IDAuth")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))

 %>

<div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
              <div class="menu_section">                
                <ul class="nav side-menu">
                  <li><a><i class="fa fa-home"></i> 영업 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/bonsa/bubonsalist.asp">영업본사 목록</a></li>
                      <li><a href="/$adm/jisa/jisalist.asp">본사 목록</a></li>
                      <li><a href="/$adm/member/memberlist.asp">회원리스트</a></li>
                    </ul>
                  </li>
                  <li><a><i class="fa fa-cc-visa"></i> 정산 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/deal_pay/boss_deal_paylist.asp">정산관리</a></li>
                      <li><a href="/$adm/deal_pay/bonsa_inoutlist.asp">유저손익관리</a></li>                      
                    </ul>
                  </li>
                  <li><a><i class="fa fa-android"></i> 유저 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/member/connect_userlist.asp">접속중인 회원</a></li>
                      <li><a href="/$adm/member/UserBlackList.asp">블랙리스트</a></li>
                      <li><a href="/$adm/member/user_iplist.asp">IP조회</a></li>                      
                    </ul>
                  </li>
                  <li><a><i class="fa fa-table"></i> 충환전 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/bonsa/accountNo_setting_domain.asp">충전계좌관리</a></li>
                      <li><a href="/$adm/charge/bonsa_chargelist.asp">충전 관리</a></li>
                      <li><a href="/$adm/charge/bonsa_exchangelist.asp">환전 관리</a></li>                      
                    </ul>
                  </li>
                  <li><a><i class="fa fa-bell-o"></i> 공지사항 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/bonsa/notice_list.asp">web 유저</a></li>
                      <li><a href="/$adm/bonsa/notice_list_game.asp">web 영업</a></li>
                      <li><a href="/$adm/bonsa/notice_list_game.asp">게임</a></li>
                      <li><a href="/$adm/bonsa/qna_list.asp">1대1문의</a></li>                      
                    </ul>
                  </li>
                  <li><a><i class="fa fa-clone"></i>로그 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/gamelog/gameloglist_baduki.asp">게임로그</a></li>
                      <li><a href="/$adm/gamelog/jackpotlist.asp">잭팟로그</a></li>
                      <li><a href="/$adm/patriot/gold_del_charge.asp">선물로그</a></li>
                      <li><a href="/$adm/point/point_list.asp">포인트로그</a></li>
                    </ul>
                  </li>
                </ul>
                <!-- 알람창 -->
                <!-- #include virtual="/$adm/include/alm.asp" -->
                <!--알람창 끝 -->
              </div>              

            </div>