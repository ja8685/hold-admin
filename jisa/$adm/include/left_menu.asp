<%'=request.Cookies(admincheck)("IDAuth")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))

 %>

<div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
              <div class="menu_section">                
                <ul class="nav side-menu">
                  <li><a><i class="fa fa-home"></i> 영업 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/chongpan/chongpanlist.asp">총판 목록</a></li>
                      <li><a href="/$adm/member/memberlist.asp">회원리스트</a></li>
                    </ul>
                  </li>
                  <li><a><i class="fa fa-cc-visa"></i> 정산 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/deal_pay/boss_deal_paylist.asp">정산관리</a></li>
                      <li><a href="/$adm/deal_pay/bonsa_inoutlist.asp">유저손익관리</a></li>                      
                    </ul>
                  </li>
                  <li><a><i class="fa fa-clone"></i>로그 <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="/$adm/gamelog/gameloglist_baduki.asp">게임로그</a></li>
                      <li><a href="/$adm/patriot/gold_del_charge.asp">선물로그</a></li>
                      <li><a href="/$adm/point/point_list.asp">포인트로그</a></li>
                    </ul>
                  </li>
                </ul>
              </div>              
            </div>