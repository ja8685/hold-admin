<% 

'//@UTF-8 castle_admin_policy_submit.asp
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

Dim submit, check_array, check, list, string, token
Set submit = CreateObject("Scripting.Dictionary")
Set check = CreateObject("Scripting.Dictionary")
'/* 내부 변수 초기화 끝 */

'/* SQL_INJECTION 정책 재설정 */
if ("POLICY_SQL_INJECTION" = page_mode) then 

    '/* 요청 변수 처리 */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("policy_sql_injection"))) then
		submit("policy_sql_injection") = Request.Form("policy_sql_injection")
	end if

	if Not(isEmpty(Request.Form("policy_sql_injection_list"))) then
		submit("policy_sql_injection_list") = Request.Form("policy_sql_injection_list")
	end if

		'// 예외 사항 체크
	check_array = array("policy_sql_injection", "policy_sql_injection_list")
	Application.Contents("key_array") = check_array
	castle_check_submit()

	'/* CASTLE 정책 정보 수정: SQL_INJECTION 정책 수정 */
		'// 적용 모드 설정

	if (submit("policy_sql_injection") = "true") then
		libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
    end if
    
    	'// 목록 설정
    if (libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("LIST").length > 0) then
		libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("LIST").RemoveAll()
	end if

    string = submit("policy_sql_injection_list")
    token = split(string, Chr(13)&Chr(10))
    
    Dim sql_injection
	Set sql_injection = libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0)
    for each list in token
        if (Trim(list) <> "") then
            sql_injection.appendChild libxmlDoc.createElement("LIST") 
            sql_injection.lastChild.text = libCAPIUtil.Base64Encode(Trim(list))
        end if
    next
         
		'// 정책이 하나도 없을 경우 비적용 상태로 바꿈
	if (libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("LIST").length = 0) then
		libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("BOOL")(0).firstChild.NodeValue = libCAPIUtil.Base64Encode("FALSE")
		html_msg "SQL_INJECTION 정책 목록이 없어 비설정으로 설정합니다."
	end if

	'// CASTLE 정책 쓰기
	castle_write_policy(libxmlDoc)

	html_msgmove "SQL_INJECTION 정책이 수정되었습니다.", "castle_admin_policy.asp#sql_injection"

	Response.End
end if
'/* SQL_INJECTION 정책 재설정 끝 */

'/* XSS 정책 재설정 */
if ("POLICY_XSS" = page_mode) then 

	'/* 요청 변수 처리 */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("policy_xss"))) then
		submit("policy_xss") = Request.Form("policy_xss")
	end if

	if Not(isEmpty(Request.Form("policy_xss_list"))) then
		submit("policy_xss_list") = Request.Form("policy_xss_list")
	end if

		'// 예외 사항 체크
	check_array = array("policy_xss", "policy_xss_list")
	Application.Contents("key_array") = check_array
	castle_check_submit()

	'/* CASTLE 정책 정보 수정: XSS 정책 수정 */
		'// 적용 모드 설정
	if (submit("policy_xss") = "true") then
		libxmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
    end if
    
		'// 목록 설정
	if (libxmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("LIST").length > 0) then
		libxmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("LIST").RemoveAll()
	end if
	
	string = submit("policy_xss_list")
    token = split(string, Chr(13)&Chr(10))
    
    Dim xss
	Set xss = libxmlDoc.GetElementsByTagName("XSS")(0)
    for each list in token
        if Not(trim(list) = "") then
            xss.appendChild libxmlDoc.createElement("LIST")
            xss.lastChild.text = libCAPIUtil.Base64Encode(trim(list))
        end if
    next
            
		'// 정책이 하나도 없을 경우 비적용 상태로 바꿈
	if (libxmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("LIST").length = 0) then
		libxmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("BOOL")(0).firstChild.NodeValue = libCAPIUtil.Base64Encode("FALSE")
		html_msg "XSS 정책 목록이 없어 비설정으로 설정합니다."
	end if

	'// CASTLE 정책 쓰기
	castle_write_policy(libxmlDoc)

	html_msgmove "XSS 정책이 수정되었습니다.", "castle_admin_policy.asp#xss"

	Response.End
end if
'/* XSS 정책 재설정 끝 */

'/* WORD 정책 재설정 */
if ("POLICY_WORD" = page_mode) then 

    '/* 요청 변수 처리 */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("policy_word"))) then
		submit("policy_word") = Request.Form("policy_word")
	end if

	if Not(isEmpty(Request.Form("policy_word_list"))) then
		submit("policy_word_list") = Request.Form("policy_word_list")
	end if

		'// 예외 사항 체크
	check_array = array("policy_word", "policy_word_list")
	Application.Contents("key_array") = check_array
	castle_check_submit()

	'/* CASTLE 정책 정보 수정: WORD 정책 수정 */
		'// 적용 모드 설정
	if (submit("policy_word") = "true") then
		libxmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
    end if
    
    	'// 목록 설정
    if (libxmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("LIST").length > 0) then
		libxmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("LIST").RemoveAll()
	end if

    string = submit("policy_word_list")
    token = split(string, Chr(13)&Chr(10))
    
    Dim word
	Set word = libxmlDoc.GetElementsByTagName("WORD")(0)
    for each list in token
        if Not(trim(list) = "") then
            word.appendChild libxmlDoc.createElement("LIST")
            word.lastChild.text = libCAPIUtil.Base64Encode(trim(list))
        end if
    next
            
		'// 정책이 하나도 없을 경우 비적용 상태로 바꿈
	if (libxmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("LIST").length = 0) then
		libxmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("BOOL")(0).firstChild.NodeValue = libCAPIUtil.Base64Encode("FALSE")
		html_msg "WORD 정책 목록이 없어 비설정으로 설정합니다."
	end if

	'// CASTLE 정책 쓰기
	castle_write_policy(libxmlDoc)

	html_msgmove "WORD 정책이 수정되었습니다.", "castle_admin_policy.asp#word"

	Response.End
end if
'/* WORD 정책 재설정 끝 */

'/* TAG 정책 재설정 */
if ("POLICY_TAG" = page_mode) then 

    '/* 요청 변수 처리 */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("policy_tag"))) then
		submit("policy_tag") = Request.Form("policy_tag")
	end if

	if Not(isEmpty(Request.Form("policy_tag_list"))) then
		submit("policy_tag_list") = Request.Form("policy_tag_list")
	end if

		'// 예외 사항 체크
	check_array = array("policy_tag", "policy_tag_list")
	Application.Contents("key_array") = check_array
	castle_check_submit()

	'/* CASTLE 정책 정보 수정: TAG 정책 수정 */
		'// 적용 모드 설정
	if (submit("policy_tag") = "true") then
		libxmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
    end if
    
    	'// 목록 설정
    if (libxmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("LIST").length > 0) then
		libxmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("LIST").RemoveAll()
	end if

    string = submit("policy_tag_list")
    token = split(string, Chr(13)&Chr(10))
    
    Dim tag
	Set tag = libxmlDoc.GetElementsByTagName("TAG")(0)
    for each list in token
        if Not(trim(list) = "") then
            tag.appendChild libxmlDoc.createElement("LIST")
            tag.lastChild.text = libCAPIUtil.Base64Encode(trim(list))
        end if
    next
            
		'// 정책이 하나도 없을 경우 비적용 상태로 바꿈
	if (libxmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("LIST").length = 0) then
		libxmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("BOOL")(0).firstChild.NodeValue = libCAPIUtil.Base64Encode("FALSE")
		html_msg "TAG 정책 목록이 없어 비설정으로 설정합니다."
	end if

	'// CASTLE 정책 쓰기
	castle_write_policy(libxmlDoc)

	html_msgmove "TAG 정책이 수정되었습니다.", "castle_admin_policy.asp#tag"

	Response.End
end if
'/* TAG 정책 재설정 끝 */

'/* IP 정책 재설정 */
if ("POLICY_IP" = page_mode) then 

    '/* 요청 변수 처리 */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("policy_ip"))) then
		submit("policy_ip") = Request.Form("policy_ip")
	end if

	if Not(isEmpty(Request.Form("policy_ip_base"))) then
		submit("policy_ip_base") = Request.Form("policy_ip_base")
	end if

	if Not(isEmpty(Request.Form("policy_ip_list"))) then
		submit("policy_ip_list") = Request.Form("policy_ip_list")
	end if

		'// 예외 사항 체크
	check_array = array("policy_ip", "policy_ip_base", "policy_ip_list")
	Application.Contents("key_array") = check_array
	castle_check_submit()

	'/* CASTLE 정책 정보 수정: IP 정책 수정 */
		'// 적용 모드 설정
	if (submit("policy_ip") = "true") then
		libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
    end if

		'// 적용기반 설정
	libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("ALLOW")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("DENY")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")

	if (submit("policy_ip_base") = "allow") then
		libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("ALLOW")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("DENY")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	end if
	
		'// 목록 설정
	if (libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("LIST").length > 0) then
		libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("LIST").RemoveAll()
	end if
	
	string = submit("policy_ip_list")
    token = split(string, Chr(13)&Chr(10))
    
    Dim ip, ip_regEx, Matches
	Set ip_regEx = New RegExp
	
	for each list in token
        if Not(trim(list) = "") then
            
            'IP Address validation
	        ip_regEx.Pattern = "^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})(-([0-9]{1,3}))?$"
	        Set Matches = ip_regEx.Execute(list)
	        if (ip_regEx.Test(list) = True) then
	    
	            if (Matches(0).SubMatches(0) > 255 or _
	                Matches(0).SubMatches(1) > 255 or _
	                Matches(0).SubMatches(2) > 255 or _
	                Matches(0).SubMatches(3) > 255 or _
	                Matches(0).SubMatches(5) > 255) then
	                html_msgmove Matches(0) & " IP 주소 형식이 올바르지 않습니다.", "castle_admin_policy.asp#ip"
	                Response.End
	            end if
	            
	            if (CInt(Matches(0).SubMatches(3)) >= CInt(Matches(0).SubMatches(5)) and Not IsEmpty(Matches(0).SubMatches(5))) then
	                html_msgmove Matches(0).SubMatches(3) & Matches(0).SubMatches(4) & " 범위 에러!\n\n " & _
	                    Matches(0).SubMatches(3) & " 보다 큰값을 범위로 설정하세요.", "castle_admin_policy.asp#ip"
	                Response.End
	            end if
	        
	        else
                html_msgmove list & " IP 주소 형식이 올바르지 않습니다.", "castle_admin_policy.asp#ip"
                Response.End
	        end if

            Set ip = libxmlDoc.GetElementsByTagName("IP")(0)
            ip.appendChild libxmlDoc.createElement("LIST")
            ip.lastChild.text = libCAPIUtil.Base64Encode(trim(list))
        end if
    next

		'// 정책이 하나도 없을 경우 비적용 상태로 바꿈
	if (libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("LIST").length = 0) then
		libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("BOOL")(0).firstChild.NodeValue = libCAPIUtil.Base64Encode("FALSE")
		html_msg "IP 정책 목록이 없어 비설정으로 설정합니다."
	end if

	'// CASTLE 정책 쓰기
	castle_write_policy(libxmlDoc)

	html_msgmove "IP 정책이 수정되었습니다.", "castle_admin_policy.asp#ip"

	Response.End
end if
'/* IP 정책 재설정 끝 */

'/* FILE 정책 재설정 */
if ("POLICY_FILE" = page_mode) then 

	'/* 요청 변수 처리 */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("policy_filename"))) then
		submit("policy_filename") = Request.Form("policy_filename")
	end if

	if Not(isEmpty(Request.Form("policy_filename_base"))) then
		submit("policy_filename_base") = Request.Form("policy_filename_base")
	end if

	if Not(isEmpty(Request.Form("policy_filename_list"))) then
		submit("policy_filename_list") = Request.Form("policy_filename_list")
	end if

	if Not(isEmpty(Request.Form("policy_filetype"))) then
		submit("policy_filetype") = Request.Form("policy_filetype")
	end if

	if Not(isEmpty(Request.Form("policy_filetype_base"))) then
		submit("policy_filetype_base") = Request.Form("policy_filetype_base")
	end if

	if Not(isEmpty(Request.Form("policy_filetype_list"))) then
		submit("policy_filetype_list") = Request.Form("policy_filetype_list")
	end if

	if Not(isEmpty(Request.Form("policy_filesize"))) then
		submit("policy_filesize") = Request.Form("policy_filesize")
	end if

	if Not(isEmpty(Request.Form("policy_filesize_min_size"))) then
		submit("policy_filesize_min_size") = Request.Form("policy_filesize_min_size")
	end if

	if Not(isEmpty(Request.Form("policy_filesize_max_size"))) then
		submit("policy_filesize_max_size") = Request.Form("policy_filesize_max_size")
	end if

		'// 예외 사항 체크
	check_array = array("policy_filename", "policy_filename_base", "policy_filename_list", _
							 "policy_filetype", "policy_filetype_base", "policy_filetype_list", _
							 "policy_filesize", "policy_filesize_min_size", "policy_filesize_max_size")
	Application.Contents("key_array") = check_array
	castle_check_submit()

	if (Len(submit("policy_filesize_min_size")) = 0) then
		html_msgback "파일 최소 크기 값이 입력되지 않았습니다."
	end if

	if (Len(submit("policy_filesize_max_size")) = 0) then
		html_msgback "파일 최대 크기 값이 입력되지 않았습니다."
	end if

	'/* CASTLE 정책 정보 수정: FILENAME 정책 수정 */
		'// 적용 모드 설정
	if (submit("policy_filename") = "true") then
		libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if

		'// 적용기반 설정
	libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("ALLOW")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("DENY")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")

	if (submit("policy_filename_base") = "allow") then
    	libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("ALLOW")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
    	libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("DENY")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
    end if

		'// 목록 설정
	if (libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("LIST").length > 0) then
		libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("LIST").RemoveAll()
	end if

	string = submit("policy_filename_list")
    token = split(string, Chr(13)&Chr(10))
    
    Dim filename
	Set filename = libxmlDoc.GetElementsByTagName("FILENAME")(1)
	for each list in token
        if Not(trim(list) = "") then
            filename.appendChild libxmlDoc.createElement("LIST")
            filename.lastChild.text = libCAPIUtil.Base64Encode(trim(list))
        end if
    next
            
		'// 정책이 하나도 없을 경우 비적용 상태로 바꿈
	if (libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("LIST").length = 0) then
		libxmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("BOOL")(0).firstChild.NodeValue = libCAPIUtil.Base64Encode("FALSE")
		html_msg "FILENAME 정책 목록이 없어 비설정으로 설정합니다."
	end if

	'/* CASTLE 정책 정보 수정: FILETYPE 정책 수정 */
		'// 적용 모드 설정
	if (submit("policy_filetype") = "true") then
		libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if
	
		'// 적용기반 설정
	libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("ALLOW")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("DENY")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")

	if (submit("policy_filetype_base") = "allow") then
    	libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("ALLOW")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
    	libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("DENY")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
    end if

		'// 목록 설정
	if (libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("LIST").length > 0) then
		libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("LIST").RemoveAll()
	end if
	
	string = submit("policy_filetype_list")
    token = split(string, Chr(13)&Chr(10))
    
    Dim filetype
	Set filetype = libxmlDoc.GetElementsByTagName("FILETYPE")(0)
	for each list in token
        if Not(trim(list) = "") then
            filetype.appendChild libxmlDoc.createElement("LIST")
            filetype.lastChild.text = libCAPIUtil.Base64Encode(trim(list))
        end if
    next
            
		'// 정책이 하나도 없을 경우 비적용 상태로 바꿈
	if (libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("LIST").length = 0) then
		libxmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("BOOL")(0).firstChild.NodeValue = libCAPIUtil.Base64Encode("FALSE")
		html_msg "FILETYPE 정책 목록이 없어 비설정으로 설정합니다."
	end if

	'/* CASTLE 정책 정보 수정: FILESIZE 정책 수정 */
		'// 적용 모드 설정
	if (submit("policy_filesize") = "true") then
		libxmlDoc.GetElementsByTagName("FILESIZE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("FILESIZE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if
	
		'// 최소&최대값 설정
	Dim min_size, max_size
	min_size = Trim(submit("policy_filesize_min_size"))
	max_size = Trim(submit("policy_filesize_max_size"))
    
    'Dim filesize
	'Set filesize = libxmlDoc.GetElementsByTagName("FILESIZE")(0)
	'if (libxmlDoc.GetElementsByTagName("MIN_SIZE")(0).hasChildNodes) then
	'	libxmlDoc.GetElementsByTagName("MIN_SIZE")(0).removeChild(libxmlDoc.GetElementsByTagName("MIN_SIZE")(0).lastchild)
	'	filesize.appendChild libxmlDoc.createElement("MIN_SIZE")
    '    filesize.lastChild.text = libCAPIUtil.Base64Encode(min_size)
    'else
       	libxmlDoc.GetElementsByTagName("MIN_SIZE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(min_size)
    'end if
	
	'if (libxmlDoc.GetElementsByTagName("MAX_SIZE")(0).hasChildNodes) then
	'	libxmlDoc.GetElementsByTagName("MAX_SIZE")(0).removeChild(libxmlDoc.GetElementsByTagName("MAX_SIZE")(0).lastchild)
	'	filesize.appendChild libxmlDoc.createElement("MAX_SIZE")
    '    filesize.lastChild.text = libCAPIUtil.Base64Encode(max_size)
    'else
       	libxmlDoc.GetElementsByTagName("MAX_SIZE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(max_size)       
	'end if

		'// CASTLE 정책 쓰기
	castle_write_policy(libxmlDoc)

	html_msgmove "FILENAME 정책이 수정되었습니다.", "castle_admin_policy.asp#file"

	Response.End
end if
'/* FILE 정책 재설정 끝 */

%>
