<%

'//@UTF-8 castle_admin_account_submit.asp
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
If ("UTF-8" = Session("castle_site_charset")) then
  Session.CodePage = 65001
  Response.Charset = "UTF-8"
else
  Session.CodePage = 949
  Response.Charset = "eucKR"
end if

Dim check_installed, check_authorized

%>
<!--#include file="castle_admin_lib.asp"-->
<%

'/* 내부 변수 초기화 */
castle_init_page()

'//page_mode : 기본 설정 모드 변수
Dim page_mode
if (Not(isEmpty(Request.QueryString)) And Not(isEmpty(Request.QueryString("mode")))) then
    page_mode = Request.QueryString("mode")
end if

'/* 내부 변수 초기화 끝 */

'/* 관리자 계정 재설정 */
if ("CONFIG_ACCOUNT" = page_mode) then

    '	/* 요청 변수 처리 */
    castle_clear_submit()

    Dim submit
    Set submit = CreateObject("Scripting.Dictionary")
    
	if Not(isEmpty(Request.Form("admin_id"))) then
		submit("admin_id") = Request.Form("admin_id")
	end if

	if Not(isEmpty(Request.Form("admin_password"))) then
		submit("admin_password") = Request.Form("admin_password")
	end if

	if Not(isEmpty(Request.Form("admin_repassword"))) then
		submit("admin_repassword") = Request.Form("admin_repassword")
	end if

	if Not(isEmpty(Request.Form("admin_old_password"))) then
		submit("admin_old_password") = Request.Form("admin_old_password")
	end if

	'	// 예외 사항 체크
	Dim check_array
	check_array = array("admin_id", "admin_password", "admin_repassword", "admin_old_password")
	Application.Contents("key_array") = check_array
    castle_check_submit()

	if (submit("admin_password") <> submit("admin_repassword")) then
		html_msgback "암호와 확인 암호가 같지 않습니다."
	end if
    
    Dim check
    Set check = CreateObject("Scripting.Dictionary")
	check("admin_id_length") = Len(submit("admin_id"))
	castle_check_length "관리자 아이디", check("admin_id_length"), 4, 16

	check("admin_password_length") = Len(submit("admin_password"))
	castle_check_length "관리자 암호", check("admin_password_length"), 8, 32

	check("admin_old_password_length") = Len(submit("admin_old_password"))
	castle_check_length "관리자 이전 암호", check("admin_old_password_length"), 8, 32

	'	// 이전 암호 확인
	Dim policy
	Set policy = CreateObject("Scripting.Dictionary")
	
	Set libxmlDoc = Server.CreateObject("Microsoft.XMLDOM")
	'Set libxmlDoc = Server.CreateObject("MSXML2.DOMDocument.3.0")
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

	policy("admin_old_password") = libxmlDoc.GetElementsByTagName("PASSWORD")(0).firstChild.nodeValue
	policy("admin_old_password") = libCAPIUtil.Base64Decode(policy("admin_old_password"))

    'Dim HashedData
    Set HashedData = CreateObject("CAPICOM.HashedData")
    HashedData.Algorithm = 4 'CAPICOM_HASH_ALGORITHM_SH2
    HashedData.Hash(submit("admin_old_password"))
    HashedData.Hash(HashedData.Value)
	submit("admin_old_password") = HashedData.Value

	if (submit("admin_old_password") <> policy("admin_old_password")) then
		html_msgback "이전 암호가 정확하지 않습니다."
	end if

	'/* CASTLE 정책 정보 수정: 관리자 계정 아이디 및 암호 설정 */
	'	// 관리자 아이디 설정
	libxmlDoc.GetElementsByTagName("ID")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(submit("admin_id"))
	'	// 관리자 암호 설정
	HashedData.Hash(submit("admin_password"))
    HashedData.Hash(HashedData.Value)
	libxmlDoc.GetElementsByTagName("PASSWORD")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(HashedData.Value)

	'	// CASTLE 정책 쓰기
	castle_write_policy(libxmlDoc)

	html_msgmove "관리자 계정 정보가 수정되었습니다.", "castle_admin_account.asp"

	Response.End
end if
'/* 관리자 계정 재설정 끝 */

%>