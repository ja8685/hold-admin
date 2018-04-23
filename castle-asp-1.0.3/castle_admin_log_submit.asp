<% 

'//@UTF-8 castle_admin_log_submit.asp
'/*
'  * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : 안중호 <hackeran@hotmail.com>
' *          이재서 <mirr1004@gmail.com>
' *          주필환 <juluxer@gmail.com>
' *
' * Last modified Jun. 29, 2009
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

Dim submit, check_array, check
Set submit = CreateObject("Scripting.Dictionary")
Set check = CreateObject("Scripting.Dictionary")
'/* 내부 변수 초기화 끝 */

'/* 로그 재설정 */
if ("LOG_MODIFY" = page_mode) then 

	'/* 요청 변수 처리 */
	castle_clear_submit()

	'if Not(isEmpty(Request.Form("log_filename"))) then
		'submit("log_filename") = Request.Form("log_filename")
	'end if

	if Not(isEmpty(Request.Form("log_bool"))) then
		submit("log_bool") = Request.Form("log_bool")
    end if
    
	if Not(isEmpty(Request.Form("log_mode"))) then
		submit("log_mode") = Request.Form("log_mode")
    end if
    
	if Not(isEmpty(Request.Form("log_list_count"))) then
		submit("log_list_count") = Request.Form("log_list_count")
    end if
    
	if Not(isEmpty(Request.Form("log_charset"))) then
		submit("log_charset") = Request.Form("log_charset")
    end if
    
		'// 예외 사항 체크
	'check_array = array("log_filename", "log_bool", "log_mode", "log_list_count", "log_charset")
	check_array = array("log_bool", "log_mode", "log_list_count", "log_charset")
	Application.Contents("key_array") = check_array
	castle_check_submit()

	'check("log_filename_length") = Len(submit("log_filename"))
	'castle_check_length "로그 파일이름", check("log_filename_length"), 4, 48

	check("log_list_count_length") = Len(submit("log_list_count"))
	castle_check_length "로그 목록개수", check("log_list_count_length"), 1, 3

	'/* CASTLE 정책 정보 수정: 로그 정보 설정 */

		'// 변수 트림
	'	submit("log_filename") = trim(submit("log_filename"))

		'// magic_quotes_gpc() 상태에 따른 stripslashes 실행
	'if (get_magic_quotes_gpc()) then
	'	submit("log_filename") = stripslashes(submit("log_filename"))
	'end if

		'// 로그 파일이름 설정
	'libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("FILENAME")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(submit("log_filename"))

		'// 로그 기록 여부 설정
	if (submit("log_bool") = "true") then
		libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if

		'// 로그 모드 설정
	if (submit("log_mode") = "simple") then
		libxmlDoc.GetElementsByTagName("SIMPLE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
		libxmlDoc.GetElementsByTagName("DETAIL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	else
	    if (submit("log_mode") = "detail") then
		    libxmlDoc.GetElementsByTagName("SIMPLE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
		    libxmlDoc.GetElementsByTagName("DETAIL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
		end if
	end if

		'// 로그 문자셋 설정
	if (submit("log_charset") = "UTF-8") then
		libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if

	if (submit("log_charset") = "eucKR") then
		libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("eucKR")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("eucKR")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if

		'// 로그 기록 개수
			'// 변수 트림
	submit("log_list_count") = trim(submit("log_list_count"))

		'// magic_quotes_gpc() 상태에 따른 stripslashes 실행
	'if (get_magic_quotes_gpc()) then
	'	submit("log_list_count") = stripslashes(submit("log_list_count"))
	'end if

	libxmlDoc.GetElementsByTagName("LIST_COUNT")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(submit("log_list_count"))

		'// CASTLE 정책 쓰기
	castle_write_policy(libxmlDoc)

	html_msgmove "로그 설정 정보가 수정되었습니다.", "castle_admin_log.asp"

	Response.End
end if
'/* 로그 재설정 끝 */

'/* 로그 삭제 */
if ("LOG_DELETE" = page_mode) then

	'/* 요청 변수 처리 */
	castle_clear_submit()

	if Not(isEmpty(Request.QueryString("log_filename"))) then
		submit("log_filename") = Request.QueryString("log_filename")
	end if

		'// 예외 사항 체크
	check_array = array("log_filename")
	Application.Contents("key_array") = check_array
	castle_check_submit()

		'// 파일 삭제
	Dim log
	Set log = CreateObject("Scripting.Dictionary")
	
	log("filename") = "./log/" & submit("log_filename")

	If (libobjFS.FileExists(Server.MapPath(log("filename")))) Then
	    On Error Resume Next
		libobjFS.DeleteFile (Server.MapPath(log("filename")))
		if Err.Number <> 0 then
		    html_msgmove "로그 파일을 삭제한 권한이 없습니다.", "castle_admin_log.asp"
            Response.End
        end if
	end if

	html_msgmove "로그 파일이 삭제되었습니다.", "castle_admin_log.asp"

	Response.End
    
end if
'/* 로그 삭제 끝 */

%>