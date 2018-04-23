<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<audio id="ding_dong"><source type="audio/mpeg"></audio>
<script type="text/javascript">
    $(document).ready(function () {
        updateData();
    });
    function set_comma(n) {
        var reg = /(^[+-]?\d+)(\d{3})/;
        n += '';
        while (reg.test(n))
            n = n.replace(reg, '$1' + ',' + '$2');

        return n;
    }
    function updateData() {
        $.ajax({
            url: "/$adm/include/admin_alm.asp",
            type: "post",
            cache: false,
            success: function (data) { // getserver.php 파일에서 echo 결과값이 data 임
                //0|0|0|0|0|813|52|7|0|5200100000|0|114880002|1124618
                //충전/환전/QNA/회원가입/블랙리스트/전체회원/오늘가입회원/접속중회원/오늘충전/오늘환전/유저보유머니합계(마스터제외)/본사보유골드합계(마스터제외)/총판보유골드합계(마스터제외) / 매장보유골드합계(마스터제외)
                arr_str = data.split("|");
                if (Number(arr_str[0]) > 0) { // 충전                
                    playing_charge();
                    $("#li_charge").show();
                    $("#lbl_charge").html("<b style='color:red'>" + set_comma(arr_str[0]) + "</b>");
                } else {
                    $("#li_charge").hide();
                }
                if (Number(arr_str[1]) > 0) { // 환전                
                    playing_outcome();
                    $("#li_excharge").show();
                    $("#lbl_excharge").html("<b style='color:red'>" + set_comma(arr_str[1]) + "</b>");
                } else {                    
                    $("#li_excharge").hide();
                }
                if (Number(arr_str[2]) > 0) { // 1대1 문의                
                    playing_qna();
                    $("#li_1n1").show();
                    $("#lbl_1n1").html("<b style='color:red'>" + set_comma(arr_str[2]) + "</b>");
                } else {                    
                    $("#li_1n1").hide();
                }
                if (Number(arr_str[3]) > 0) { // 회원 가입           
                    playing_register();
                    $("#li_register").show();
                    $("#lbl_register").html("<b style='color:red'>" + set_comma(arr_str[3]) + "</b>");
                } else {                    
                    $("#li_register").hide();
                }
                if (Number(arr_str[4]) > 0) { // 블랙리스트          
                    playing_blacklist();
                    $("#li_blacklist").show();
                    $("#lbl_blacklist").html("<b style='color:red'>" + set_comma(arr_str[4]) + "</b>");
                } else {                    
                    $("#li_blacklist").hide();
                }
                $("#lbl_tot_member").html("<b style='color:white'>" + set_comma(arr_str[5]) + "</b>");
                $("#lbl_register_today").html("<b style='color:white'>" + set_comma(arr_str[6]) + "</b>");
                $("#lbl_connect_userlist").html("<b style='color:white'>" + set_comma(arr_str[7]) + "</b>");
                $("#lbl_today_charge").html("<b style='color:white'>" + set_comma(arr_str[8]) + "</b>");
                $("#lbl_today_excharge").html("<b style='color:white'>" + set_comma(arr_str[9]) + "</b>");
                $("#lbl_today_income").html("<b style='color:white'>" + set_comma(Number(arr_str[8]) - Number(arr_str[9])) + "</b>");                
                $("#lbl_today_user").html("<b style='color:white'>" + set_comma(arr_str[10]) + "</b>");
                var tot_number = Number(arr_str[10]) + Number(arr_str[11]) + Number(arr_str[12]);
                $("#lbl_today_sales").html("<b style='color:white'>" + set_comma(Number(arr_str[12])) + "</b>");                                
            }
        });
        setTimeout("updateData()", 10000); // 10초 단위로 갱신 처리
    }


    function playing_charge() {
        $('audio').attr({ src: '/$adm/include/trumpet.wav', autoplay: "true" });
    }
    function playing_outcome() {
        $('audio').attr({ src: '/$adm/include/dog01.wav', autoplay: "true" });

    }
    function playing_qna() {
        $('audio').attr({ src: '/$adm/include/ringout.wav', autoplay: "true" });
    }
    function playing_register() {
        $('audio').attr({ src: '/$adm/include/ringout.wav', autoplay: "true" });
    }
    function playing_blacklist() {
        $('audio').attr({ src: '/$adm/include/xylofun.wav', autoplay: "true" });
    }    
</script>
<%
syear_alm = year(now())
smon_alm = month(now())
sday_alm = day(now())
stime_alm = hour(now())
sdate_alm = syear_alm & "-" & putZero(smon_alm) & "-" & putZero(sday_alm) 
    %>
<iframe name="almframe" id="almframe" width="0" height="0" frameborder="0" style="display:none"></iframe>
<input type="hidden" name="ret_alm_val" id="ret_alm_val" />
<div class="col-xs-12 col-sm-12 col-xs-12">
    <div class="x_content">        
        <div class="pricing_features" style="background-color:#2a3f54">
            <ul class="list-unstyled text-left" style="background-color:#2a3f54;color:white">
             <li class="text-center">[<%=sdate_alm%>]</li>
            <li id="li_charge"><i class="fa fa-times text-danger"></i> 충전 신청 : <strong> <a href="/$adm/charge/bonsa_chargelist.asp"><b><span id="lbl_charge"></span></b></a>건</strong></li>            
            <li id="li_excharge"><i class="fa fa-times text-danger"></i> 환전 신청 : <strong> <a href="/$adm/charge/bonsa_exchangelist.asp"><b><span id="lbl_excharge"></span></b></a>건</strong></li>
            <li id="li_1n1"><i class="fa fa-times text-danger"></i> 1:1 문의 : <strong> <a href="/$adm/bonsa/qna_list.asp"" target="content"><b><span id="lbl_1n1"></span></b></a>건</strong></li>
            <li id="li_register"><i class="fa fa-times text-danger"></i> 회원가입 : <strong> <a href="/$adm/member/memberlist.asp" target="content"><b><span id="lbl_register"></span></b></a>건</strong></li>
            <li id="li_blacklist"><i class="fa fa-times text-danger"></i> 블랙리스트 : <strong> <a href="/$adm/member/UserBlackList.asp" target="content"><b><span id="lbl_blacklist"></span></b></a>건</strong></li>            
            <li><i class="fa fa-male"></i> 전체회원 : <strong> <a href="/$adm/member/memberlist.asp"><b><span id="lbl_tot_member"></span></b></a>명</strong></li>            
            <li><i class="fa fa-male"></i> 오늘회원가입 : <strong> <a href="/$adm/member/memberlist.asp"><b><span id="lbl_register_today"></span></b></a>명</strong></li>            
            <li><i class="fa fa-twitter"></i> 접속중인회원 : <strong> <a href="/$adm/member/connect_userlist.asp"><b><span id="lbl_connect_userlist"></span></b></a>명</strong></li>            
            <li><i class="fa fa-won"></i> 충전 : <strong> <a href="/$adm/member/connect_userlist.asp"><b><span id="lbl_today_charge"></span></b></a>원</strong></li>            
            <li><i class="fa fa-won"></i> 환전 : <strong> <a href="/$adm/member/connect_userlist.asp"><b><span id="lbl_today_excharge"></span></b></a>원</strong></li>            
            <li><i class="fa fa-won"></i> 손익 : <strong> <a href="/$adm/member/connect_userlist.asp"><b><span id="lbl_today_income"></span></b></a>원</strong></li>            
            <li><i class="fa fa-won"></i> 유저 : <strong> <a href="/$adm/member/connect_userlist.asp"><b><span id="lbl_today_user"></span></b></a>원</strong></li>            
            <li><i class="fa fa-won"></i> 영업 : <strong> <a href="/$adm/member/connect_userlist.asp"><b><span id="lbl_today_sales"></span></b></a>원</strong></li>            
            </ul>
        </div>
    </div>
        <!--div class="pricing_footer">
        <a href="javascript:void(0);" class="btn btn-success btn-block" role="button">Download <span> now!</span></a>
        <p>
            <a href="javascript:void(0);">Sign up</a>
        </p>
        </div-->    
</div>
