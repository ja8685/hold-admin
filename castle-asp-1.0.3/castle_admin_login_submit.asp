<% 

'//@UTF-8 castle_admin_login_submit.asp
'/*
' * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : 안중호 <hackeran@hotmail.com>
' *          이재서 <mirr1004@gmail.com>
' *          주필환 <juluxer@gmail.com>
' *
' * Last modified Jan. 06, 2009
' *
' */

Option Explicit
If ("UTF-8" = Session("castle_site_charset")) then
  Session.CodePage = 65001
  Response.Charset = "UTF-8"
else
  Session.CodePage = 949
  Response.Charset = "eucKR"
end if

'/* 인증 및 설치 검사 예외 페이지 */
Dim check_installed, check_authorized
check_authorized = TRUE

%>
<!--#include file="castle_admin_lib.asp"-->
<%

'/* 내부 변수 초기화 */
castle_init_page()

'/* 내부 변수 초기화 끝 */

'/* 요청 변수 처리 */
castle_clear_submit()

Dim submit
Set submit = CreateObject("Scripting.Dictionary")
if Not(isEmpty(Request.Form("admin_id"))) then
	submit("admin_id") = Request.Form("admin_id")
end if

if Not(isEmpty(Request.Form("admin_password"))) then
	submit("admin_password") = Request.Form("admin_password")
end if

	'// 예외 사항 체크
Dim check_array
check_array = array("admin_id", "admin_password")
Application.Contents("key_array") = check_array
castle_check_submit()

'Dim check
'Set check = CreateObject("Scripting.Dictionary")
'check("admin_id_length") = Len(submit("admin_id"))
'castle_check_length "관리자 아이디", check("admin_id_length"), 4, 16

'check("admin_password_length") = Len(submit("admin_password"))
'castle_check_length "관리자 암호", check("admin_password_length"), 8, 32

'/* CASTLE 정책 정보: 관리자 계정 아이디 및 암호 가져오기 */
Dim policy
Set policy = CreateObject("Scripting.Dictionary")
policy("admin_id") = ""
policy("admin_password") = ""

'Dim libxmlDoc
Set libxmlDoc = Server.CreateObject("MSXML2.DOMDocument.3.0")
libxmlDoc.async = "false"
'Dim libobjFS
Set libobjFS = Server.CreateObject("Scripting.FileSystemObject")
If (libobjFS.FileExists(Server.MapPath("castle_policy.asp"))) Then

	libxmlDoc.Load (Server.MapPath("castle_policy.asp"))

	If (libxmlDoc.parseError.errorCode <> 0) Then
		Response.Write "문서 로드중 에러가 발생하였습니다."
		Response.End
	End If

End If

	'// 관리자 아이디 
if Not(isEmpty(libxmlDoc.GetElementsByTagName("ID")(0).firstChild.nodeValue)) then
	policy("admin_id") = libxmlDoc.GetElementsByTagName("ID")(0).firstChild.nodeValue
end if

	'// 관리자 암호
if Not(isEmpty(libxmlDoc.GetElementsByTagName("PASSWORD")(0).firstChild.nodeValue)) then
	policy("admin_password") = libxmlDoc.GetElementsByTagName("PASSWORD")(0).firstChild.nodeValue
end if

	'// BASE64 디코딩
policy("admin_id") = libCAPIUtil.Base64Decode(policy("admin_id"))
policy("admin_password") = libCAPIUtil.Base64Decode(policy("admin_password"))

	'// 아이디 & 암호 검사
'Dim HashedData
Set HashedData = CreateObject("CAPICOM.HashedData")
HashedData.Algorithm = 4 'CAPICOM_HASH_ALGORITHM_SHA256
HashedData.Hash(submit("admin_password"))
HashedData.Hash(HashedData.Value)

submit("admin_password") = HashedData.Value
if (submit("admin_id") <> policy("admin_id")) then
	html_msgback "잘못된 인증 정보입니다."
end if

if (submit("admin_password") <> policy("admin_password")) then
	html_msgback "잘못된 인증 정보입니다."
end if

	'// 인증 세션 생성
Dim auth
Set auth = CreateObject("Scripting.Dictionary")
auth("remote_addr") = Request.ServerVariables("REMOTE_ADDR")
'auth("user_agent") = Request.ServerVariables("HTTP_USER_AGENT")

auth("key") = "castle_auth_token_" & Request.Form("admin_id")
HashedData.Hash(auth("remote_addr"))
auth("value") = HashedData.Value

Session(auth("key")) = auth("value")

html_msgmove "관리자 인증 되었습니다.", "castle_admin.asp"

Response.End
'/* 관리자 인증 끝 */

%>