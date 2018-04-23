<% @LANGUAGE="VBSCRIPT" %>
<% Server.ScriptTimeout = 100 %>
<%
	'Response.Expires = 0 
	'Response.Expiresabsolute = Now() - 1 
	'Response.AddHeader "pragma","no-cache" 
	'Response.AddHeader "cache-control","private" 
	'Response.CacheControl = "no-cache" 
	Response.ContentType="text/html" 
	Response.CharSet = "UTF-8" 
	Response.Buffer = true 'false일 경우 Server.Execute 실행시 헤더 오류 발생에 유의

	Const admincheck = "AXMain" '관리자 로그인 체크 Cookies Array

	Const savecheck = "AXMainAdmin" '관리자 아이디 저장 Cookies Array

	Const AdminTitle = "영업본사" '관리자 타이틀
	
	Const AdminRole = "영업본사" '관리자 구분(마스터,총본사,본사,총판,매장)

	Const CompanyLogo = "../images/logo.gif"
	
	Const DefaultPage = "/$adm/member/memberlist.asp"

	Const LogoutReturnPage = "/$adm/login/loginForm.asp"
	
	Const HomePage = "http://007games.co.kr"
	
	Const HeadCode = "A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z"

	Const StartSalesDate = "9:00:00 AM"

	Const EndSalesDate = "9:00:00 AM"

    Const Jackpotrate = 0
	Dim Domain, SCRIPT_NAME, QUERY_STRING, ConnectPort 

	Domain = Request.ServerVariables("Server_Name")
	SCRIPT_NAME = Request.ServerVariables("SCRIPT_NAME")
	SERVER_PORT = Request.ServerVariables("SERVER_PORT")
	QUERY_STRING = Request.ServerVariables("QUERY_STRING")

	ConnectPort = "3434" '접속포트
    if SERVER_PORT<> ConnectPort then
    %>   
    <script type="text/javascript">
        alert("접속 포트가 잘못되었습니다.");
        document.location.herf = '/$adm/login/logoutproc.asp';
    </script>
    <%
        response.end
    end if
    nowDate = now
    now_date_second = Year(nowDate) & Right("0" & month(nowDate),2) & Right("0" & Day(nowDate),2) & _
	                 Right("0" & Hour(nowDate),2) & Right("0" & minute(nowDate),2) & Right("0" & second(nowDate),2)
    now_date = Year(nowDate) & Right("0" & month(nowDate),2) & Right("0" & Day(nowDate),2) 	                
%>