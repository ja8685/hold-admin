<% 

'//@UTF-8 install_step2_submit.asp
'/*
'  * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : 안중호 <hackeran@hotmail.com>
' *          이재서 <mirr1004@gmail.com>
' *          주필환 <juluxer@gmail.com>
' *
' * Last modified Jan. 06, 2009
' *
' */

Option Explicit
Session.CodePage = 949
Response.Charset = "eucKR"

'/* 인증 및 설치 검사 예외 페이지 */
Dim check_installed, check_authorized
check_installed = TRUE
check_authorized = TRUE

%>
<!--#include file="castle_admin_lib.asp"-->
<%

'  /* 설치 여부 판단 */
Dim objFS
Set objFS = Server.CreateObject("Scripting.FileSystemObject")
If (objFS.FileExists(Server.MapPath("castle_policy.asp"))) Then
  html_msgmove "CASTLE 웹해킹방어도구 - ASP 버전이 이미 설치되어 있습니다.", "castle_admin.asp"
End If
Set objFS = Nothing

if (isEmpty(Session("castle_install"))) then
	html_msgmove "install.asp 설치 초기 페이지로 접근하십시오.", "install.asp"
end if

'/* 내부 변수 초기화 */
castle_init_page()

'/* 내부 변수 초기화 끝 */

'/* 요청 변수 처리 */
castle_clear_submit()

Dim submit
Set submit = CreateObject("Scripting.Dictionary")

if Not(isEmpty(Request.Form("site_charset"))) then
	submit("site_charset") = Request.Form("site_charset")
end if

'	// 예외 사항 체크
Dim check_array
check_array = array("site_charset")
Application.Contents("key_array") = check_array
castle_check_submit()

if ((submit("site_charset") <> "UTF-8") And _
	(submit("site_charset") <> "eucKR")) then
	html_msgback "Charset은 UTF-8 또는 eucKR만 지원합니다."
end if


Session("castle_site_charset") = submit("site_charset")

html_move "install_step3.asp"

Response.End

'/* 2단계 끝 */

%>
