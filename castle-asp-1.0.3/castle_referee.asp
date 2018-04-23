<%

'//@ castle_referee.asp
'/*
' * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : 안중호 <hackeran@hotmail.com>
' *          이재서 <mirr1004@gmail.com>
' *          주필환 <juluxer@gmail.com>
' *
' * Last modified Jan. 09, 2009
' *
' */

Option Explicit
    
if (inStr(Request.ServerVariables("Script_Name"), "castle_") > 0) then
	Dim access_err	
	access_err = "<script language=""javascript"" "&_
		"CodePage="" "& Session.CodePage &" "" charset="" "& Response.Charset &" "">"&_
		"alert(""정상적인 접근이 아닙니다."");"&_
	        "history.back(-1);</script>"
	Response.Write(access_err)
	Response.End	
end if

if (IsEmpty(Application("CASTLE_ASP_VERSION_BASE_DIR"))) then
	Dim dir_err	
	dir_err = "<script language=""javascript"" "&_
		"CodePage="" "& Session.CodePage &" "" charset="" "& Response.Charset &" "">"&_
		"alert(""설치 디렉토리가 올바르게 지정되지 않았습니다."");"&_
	        "history.back(-1);</script>"
	Response.Write(dir_err)
	Response.End	
end if

Dim castle_xmlDoc
Set castle_xmlDoc = Server.CreateObject("Microsoft.XMLDOM")
castle_xmlDoc.async = "false"

'/* CASTLE 정책 파일 존재 검사 */
Dim castle_objFS
Set castle_objFS = Server.CreateObject("Scripting.FileSystemObject")

Dim castle_CAPIUtil, castle_policy, castle_check, castle_log, castle_objReg
Set castle_CAPIUtil = Server.CreateObject("CAPICOM.Utilities") 
Set castle_policy = CreateObject("Scripting.Dictionary")
Set castle_check = CreateObject("Scripting.Dictionary")
Set castle_log = CreateObject("Scripting.Dictionary")
Set castle_objReg = new RegExp
	castle_objReg.Global = true
	castle_objReg.IgnoreCase = true
    
If (castle_objFS.FileExists(Server.MapPath(Application("CASTLE_ASP_VERSION_BASE_DIR") & "/castle_policy.asp"))) Then

'/* CASTLE 정책 파일 참조 */
    castle_xmlDoc.Load (Server.MapPath(Application("CASTLE_ASP_VERSION_BASE_DIR") & "/castle_policy.asp"))

    if (castle_xmlDoc.parseError.errorCode <> 0) Then
	    Response.Write "문서 로드중 에러가 발생하였습니다."
	    Response.End
    end if
    
	if ("TRUE" = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue)) then
  	    Session.CodePage = 65001
  	    Response.Charset = "UTF-8"
	else
  		Session.CodePage = 949
  		Response.Charset = "euc-KR"
	end if

Else
	Session.CodePage = 949
	Response.Charset = "euc-KR"
		
	Dim castle_install_err	
	castle_install_err = "<script language=""javascript"" "&_
		"CodePage="" "& Session.CodePage &" "" charset="" "& Response.Charset &" "">"&_
		"alert(""CASTLE가 설치되어 있지 않습니다."");"&_
	               "history.back(-1);</script>" 
	Response.Write(castle_install_err)
	Response.End
End If
	
'/* CASTLE 집행 프레임워크 함수들 */

'/* CASTLE 리퍼리 경고 메시지 함수
' *
' * 함수명: castle_referee_alert
' *
' * 정책 설정에 따라 입력된 메시지를 브라우져 화면에 출력하거나
' * 경고창을 통해 출력함. 스텔스 모드인 경우에는 아무것도 출력하지 않음
' *
' * 파라미터: 
' *    castle_msg - 출력할 메시지
' *
' * 리턴: 없음
' */
function castle_referee_alert(castle_msg)

	'/* 경고 부분 정책 존재 여부 */
	if Not(castle_xmlDoc.GetElementsByTagName("ALERT")(0).hasChildNodes) then
		castle_referee_alert = null
		Exit function
	end if

	'/* 경고 정책 가져오기 */
	castle_policy("config") = castle_xmlDoc.GetElementsByTagName("MODULE_NAME")(0).firstChild.nodeValue
	castle_policy("config_title") = castle_CAPIUtil.Base64Decode(castle_policy("config"))
	castle_policy("alert") = castle_xmlDoc.GetElementsByTagName("CONFIG")(0).GetElementsByTagName("ALERT")(0).firstChild.nodeValue
	castle_policy("alert_alert") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("ALERT")(0).GetElementsByTagName("ALERT")(0).firstChild.nodeValue)
	castle_policy("alert_message") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("ALERT")(0).GetElementsByTagName("MESSAGE")(0).firstChild.nodeValue)
	castle_policy("alert_stealth") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("ALERT")(0).GetElementsByTagName("STEALTH")(0).firstChild.nodeValue)

	'// 스텔스 모드일 경우
	if (castle_policy("alert_stealth") = "TRUE") then
	    Response.Write("")
		castle_referee_alert = null
	    Exit function
	end if

	Dim castle_page
	castle_page = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("SCRIPT_NAME")

	Dim error_img
	error_img = Application("CASTLE_ASP_VERSION_BASE_DIR") & "/img/sorry.gif"
    
	'// 메시지 모드일 경우
	if (castle_policy("alert_message") = "TRUE") then
        Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
        Response.Write("<html>")
        Response.Write("<head>")
        Response.Write("<meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"">")
        Response.Write("</head>")
        Response.Write("<body bgcolor=""#FFFFFF"">")
        Response.Write("<center><br><br><br><img src=" & error_img & "></center>")
        Response.Write("</body>")
        Response.Write("</html>")
        castle_referee_alert = null
        exit Function
	end if

	'// 경고 모드일 경우
	if (castle_policy("alert_alert") = "TRUE") then
		Dim castle_alert_msg
		castle_alert_msg  = "<script language=""javascript"" "&_
			"codepage="" "& Session.CodePage & " "" charset="" "& Response.charset &" "">" &_
			"alert(""\n" &_
	                "※ CASTLE 알림 ※ \n" &_
	                "\n" &_
	                "CASTLE에 의해 접근이 차단되었습니다.\n" &_
	                "\n" &_
	                "--- 차단 페이지 ---\n\n" & castle_page & "\n" &_
	                "\n" &_
	                "--- 차단 사유 ---\n\n" & castle_msg & "\n" &_
	                "\n" &_
	                "특별한 사유 없이 위의 에러가 반복되면 관리자에게 문의하십시오.\n" &_
	                "위의 결과는 모두 별도의 로그에 기록됩니다.\n" &_
	                "\n""); history.back(-1);</script>"
	                
		Response.Write(castle_alert_msg)

		castle_referee_alert = null
        exit function
	end if

    castle_referee_alert = null
end function


'/* CASTLE 리퍼리 로깅 함수
' *
' * 함수명: castle_referee_logger
' *
' * 정책 설정에 따라 입력된 로그 메시지를 로그 파일에 추가함
' * 무기록 모드인 경우에는 로그를 기록하지 않음
' *
' * 파라미터: 
' *    castle_msg - 로그 메시지
' *
' * 리턴: 없음
' */
function castle_referee_logger(castle_msg)

	'/* 로그 부분 정책 존재 여부 */
	if Not(castle_xmlDoc.GetElementsByTagName("LOG")(0).hasChildNodes) then
	    castle_referee_logger = null
		exit Function
	end if

	'/* 로그 정책 가져오기 */	
	castle_policy("log_bool") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)
	castle_policy("log_filename") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("FILENAME")(0).firstChild.nodeValue)

	'/* 로그 기록 여부 판단 */
	if (castle_policy("log_bool") = "FALSE") then
		castle_referee_logger = null
		exit Function
	end if
	
	'/* 로그 디렉토리 유무 판단 및 생성 */
	if (castle_objFS.FolderExists(Server.MapPath(Application("CASTLE_ASP_VERSION_BASE_DIR") & "/log")) <> True) Then
	    castle_objFS.CreateFolder(Server.MapPath( Application("CASTLE_ASP_VERSION_BASE_DIR") & "/log"))
	end if

	'/* 로그 남김 */
	castle_log("filename") = Application("CASTLE_ASP_VERSION_BASE_DIR") &_
	                  "/log/" & Replace(Date, "-", "") & "-" & castle_policy("log_filename")

    	Dim castle_objLog
	if (castle_objFS.FileExists(Server.MapPath(castle_log("filename")))) then
    	Set castle_objLog = castle_objFS.OpenTextFile(Server.MapPath(castle_log("filename")), 8, True) 		'ForAppending
	else
		Set castle_objLog = castle_objFS.CreateTextFile(Server.MapPath(castle_log("filename")), True)
	end if	

	if Not(isEmpty(castle_objLog)) then
		castle_objLog.WriteLine(castle_msg)
		castle_objLog.Close
	end if

	Set castle_objLog = nothing

    castle_referee_logger = null
end function


'/* CASTLE 리퍼리 확장 정규표현식 체크 함수
' *
' * 함수명: castle_referee_eregi
' *
' * 입력된 정규표현식 패턴과 입렶 문자열을 디코딩하고
' * UTF-8, CP949(eucKR)로 변환한 후 각각 테스트를 수행함
' *
' * 파라미터: 
' *    castle_regexp - 정규표현식 패턴
' *    castle_str - 입력된 문자열
' *
' * 리턴:
' *    (utf8_regexp or eucKR_regexp) - 탐지된 정규표현식 패턴
' *    NULL - 탐지되지 않을 경우 널
' */
function castle_referee_eregi(castle_list, castle_string)

Dim list, castle_regexp
for each list in castle_list

    castle_regexp = castle_CAPIUtil.Base64Decode(list.text)
    
    Dim castle_str
    castle_str = castle_string
    castle_regexp = trim(castle_regexp)
    castle_str = trim(castle_str)

	'// 예외사항
    if (Len(castle_regexp) = 0 Or Len(castle_str) = 0) then
	castle_referee_eregi = null
	exit function
    end if
    
	'// 입력값 디코딩
	castle_str = castle_referee_urldecode(castle_str)
	castle_str = castle_referee_unhtmlentities(castle_str)

	'// 정규표현식 체크
    castle_objReg.IgnoreCase = True
    castle_objReg.Pattern = castle_regexp

    if (castle_objReg.Test(castle_str)) then
	'// SkipList 체크
	if Not(IsEmpty(Application("SkipList"))) then
	    castle_objReg.IgnoreCase = True
	    castle_objReg.Pattern = "(" & Application("SkipList") & ")"
	    if (castle_objReg.Test(castle_str)) then
		castle_referee_eregi = null
	        exit function
	    end if
	end if

	castle_referee_eregi = castle_regexp
	exit function

    end if
    
next
	
    castle_referee_eregi = null
end function

function castle_referee_urldecode(castle_str)

    On Error Resume Next
	'/* HTTP URL Decoding */
    Dim aSplit
    Dim sOutput
    Dim i
    Dim castle_regEx, Match, Matches
    Set castle_regEx = New RegExp

    If IsNull(castle_str) Then
       castle_referee_urldecode = ""
       Exit Function
    End If

    sOutput = Replace(castle_str, "+", " ")
    castle_regEx.Pattern = "%([0-9A-F]{2})"
    castle_regEx.IgnoreCase = True
    castle_regEx.Global = True
    Set Matches = castle_regEx.Execute(sOutput)

    For Each Match in Matches
    	sOutput = Replace(sOutput, Match.Value, Chr("&H" & Match.SubMatches(0)))
    	if (Err.Number <> 0) then
            castle_error_handler()
            Err.Clear
        end if
    Next

    Set Matches = Nothing
    Set	castle_regEx = Nothing

    castle_referee_urldecode = sOutput
end function

function castle_referee_unhtmlentities(castle_str)

    On Error Resume Next
	'// replace numeric entities
    Dim Match, Matches
    castle_objReg.IgnoreCase = True

    castle_objReg.Pattern = "&#x([0-9A-F]+);?" '"&#[xX]?([0-9A-Fa-f]+);?"
    Set Matches = castle_objReg.Execute(castle_str)
    For Each Match in Matches
        castle_str = Replace(castle_str, Match.Value, ChrW("&H" & Match.SubMatches(0)))
        if (Err.Number <> 0) then
            castle_error_handler()
            Err.Clear
        end if
    Next

    castle_objReg.Pattern = "&#([0-9]+);?"
    Set Matches = castle_objReg.Execute(castle_str)
    For Each Match in Matches
        castle_str = Replace(castle_str, Match.Value, ChrW(Match.SubMatches(0)))
        if (Err.Number <> 0) then
            castle_error_handler()
            Err.Clear
        end if
    Next

    'castle_referee_unhtmlentities = Server.HTMLEncode(castle_str)
    castle_referee_unhtmlentities = castle_str
end function

function castle_referee_htmldecode(castle_str)

    Dim index
    castle_str = Replace(castle_str, "&quot;", Chr(34))
    castle_str = Replace(castle_str, "&lt;"  , Chr(60))
    castle_str = Replace(castle_str, "&gt;"  , Chr(62))
    castle_str = Replace(castle_str, "&amp;" , Chr(38))
    castle_str = Replace(castle_str, "&nbsp;", Chr(32))

    castle_referee_htmldecode = castle_str
End Function

function castle_referee_delete_directory_traverse(castle_path)

	'/* Delete directory traverse attack.. */

	castle_path = castle_referee_urldecode(castle_path)
	
	castle_objReg.IgnoreCase = true

	'	// "/../" -> "/"
	castle_objReg.Pattern = "/\.\./"
	while (castle_objReg.Test(castle_path)) 
		castle_path = castle_objReg.Replace(castle_path, "/")
	wend

	'	// "./" -> ""
	castle_objReg.Pattern = "\./"
	while (castle_objReg.Test(castle_path))
		castle_path = castle_objReg.Replace(castle_path ,"")
	wend
		
	'	// "//" -> "/"
	castle_objReg.Pattern = "//"
	while (castle_objReg.Test(castle_path)) 
		castle_path = castle_objReg.Replace(castle_path, "/")
	wend

	'	// "\..\" -> "\"
	castle_objReg.Pattern = "\\\.\.\\"
	while (castle_objReg.Test(castle_path)) 
		castle_path = castle_objReg.Replace(castle_path, "\")
	wend
	
	'	// ".\" -> ""
	castle_objReg.Pattern = "\.\\"
	while (castle_objReg.Test(castle_path))
	    castle_path = castle_objReg.Replace(castle_path, "")
    wend
    
	'	// "\\" -> "\"
	castle_objReg.Pattern = "\\\\"
	while (castle_objReg.Test(castle_path)) 
		castle_path = castle_objReg.Replace(castle_path, "\")
	wend

	castle_referee_delete_directory_traverse = castle_path
end function

function castle_referee_error_handler(policy_type, rule, method, key, value, castle_msg)

	'/* 경고 및 로그 부분 정책 존재 여부 */
	if Not(castle_xmlDoc.GetElementsByTagName("ALERT")(0).hasChildNodes) then
		castle_referee_error_handler = null
		exit function
	end if

	if Not(castle_xmlDoc.GetElementsByTagName("LOG")(0).hasChildNodes) then
		castle_referee_error_handler = null
		exit function
	end if

	'/* 로그 정책 가져오기 */
	castle_policy("log_bool") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)
	castle_policy("log_simple") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("SIMPLE")(0).firstChild.nodeValue)
	castle_policy("log_detail") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("DETAIL")(0).firstChild.nodeValue)
	
	'/* CASTLE 집행 모드 적용 */
	castle_policy("mode_enforcing") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("ENFORCING")(0).firstChild.nodeValue)
	castle_policy("mode_permissive") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("PERMISSIVE")(0).firstChild.nodeValue)

	'/* 로그 부분 정책 존재 여부 */
	if Not(castle_xmlDoc.GetElementsByTagName("SQL_INJECTION")(0).hasChildNodes) then
		castle_referee_error_handler = null
		exit function
	end if

	'/* 로그 메시지 작성: REMOTE_ADDR - [DATE] REQUEST_URL : MESSAGE */
	
	'// 개행제거
	castle_objReg.IgnoreCase = true
	castle_objReg.Pattern = Chr(13)
	value = castle_objReg.Replace(value, "\r")
	castle_objReg.Pattern = Chr(10)
	value = castle_objReg.Replace(value, "\n")

	'// 간략 메시지 작성
	if (castle_policy("log_simple") = "TRUE") then
		castle_log("simple")  = Request.ServerVariables("REMOTE_ADDR") & " - [" & Now &_
		                 Request.ServerVariables("SCRIPT_NAME") & ": " & key & " = " & Mid(value, 1, 64) & ": " &_
		                 castle_msg & vbCrLf

		castle_referee_logger(castle_log("simple"))
	else
		'// 상세 메시지 작성
	    if (castle_policy("log_detail") = "TRUE") then
		    castle_log("detail") = Request.ServerVariables("REMOTE_ADDR") & " - [" & Now &_
		                    Request.ServerVariables("SCRIPT_NAME") & ": " & key & " = " & Mid(value, 1, 64) & ": " &_
		                    castle_msg & vbCrLf &_
		                     
		                    " -> [Method: " & method & "]" & vbCrLf &_
		                    " -> [Policy: " & policy_type & "]" & vbCrLf &_
		                    " -> [Pattern: " & rule & "]" & vbCrLf

		    rule = "/" & rule & "/"

		    Dim Matches, Match
		    castle_objReg.IgnoreCase = true
		    castle_objReg.Pattern = rule
		    Set Matches = castle_objReg.Execute(value)

			'// 상세 정보 출력
		    if Not(isEmpty(Matches)) then
			    for each Match in Matches
    	        castle_log("detail") = castle_log("detail") & " -> [Offset: " & Match.FirstIndex & "] [Matched-Content: " & Match.Value & "]" & vbCrLf
			    next
		    end if

		    castle_referee_logger(castle_log("detail"))
	    end if
	    
    end if

    '// 집행모드이면 강제 종료
    if (castle_policy("mode_enforcing") = "TRUE") then
		castle_referee_alert(castle_msg & ": " & key)
		Response.End
	end if

	'// 감사모드이면 계속 실행
	if (castle_policy("mode_permissive") = "TRUE") then
		castle_referee_error_handler = null
		exit function
	end if

	castle_referee_error_handler = null
end function

function castle_referee_detect_sql_injection(castle_string)

	'/* SQL INJECTION 정책 존재 여부 */
	if Not(castle_xmlDoc.GetElementsByTagName("SQL_INJECTION")(0).hasChildNodes) then
		castle_referee_detect_sql_injection = null
		exit function
	end if

	castle_policy("sql_injection_bool") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)

	'// SQL INJECTION 미적용 모드
	if (castle_policy("sql_injection_bool") = "FALSE") then
		castle_referee_detect_sql_injection = null
		exit function
	end if

	Dim sql_injection_list, list, castle_regexp
	Set sql_injection_list = castle_xmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("LIST")

	'// 정규표현식으로 탐지
	castle_regexp = castle_referee_eregi(sql_injection_list, castle_string)
	if Not(isNull(castle_regexp)) then
		castle_referee_detect_sql_injection = castle_regexp
		exit function
	end if

	castle_referee_detect_sql_injection = FALSE
end function

function castle_referee_detect_xss(castle_string)

	'/* XSS 정책 존재 여부 */
	if Not(castle_xmlDoc.GetElementsByTagName("XSS")(0).hasChildNodes) then
		castle_referee_detect_xss = null
		exit function
	end if

    castle_policy("xss_bool") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)

	'// XSS 미적용 모드
	if (castle_policy("xss_bool") = "FALSE") then
		castle_referee_detect_xss = null
		exit function
	end if

	Dim xss_list, list, castle_regexp
	Set xss_list = castle_xmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("LIST")

	'// 정규표현식으로 탐지
	castle_regexp = castle_referee_eregi(xss_list, castle_string)
	if Not(isNull(castle_regexp)) then
		castle_referee_detect_xss = castle_regexp
		exit function
	end if

	castle_referee_detect_xss = FALSE
end function

function castle_referee_detect_word(castle_string)

	'/* WORD 정책 존재 여부 */
	if Not(castle_xmlDoc.GetElementsByTagName("WORD")(0).hasChildNodes) then
		castle_referee_detect_word = null
		exit function
	end if

	castle_policy("word_bool") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)

	'// WORD 미적용 모드
	if (castle_policy("word_bool") = "FALSE") then
		castle_referee_detect_word = null
		exit function
	end if

	Dim word_list, list, castle_regexp
	Set word_list = castle_xmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("LIST")

	'// 정규표현식으로 탐지
	castle_regexp = castle_referee_eregi(word_list, castle_string)
	if Not(isNull(castle_regexp)) then
		castle_referee_detect_word = castle_regexp
		exit function
	end if

	castle_referee_detect_word = FALSE
end function

function castle_referee_detect_tag(castle_string)

	'/* TAG 정책 존재 여부 */
	if Not(castle_xmlDoc.GetElementsByTagName("TAG")(0).hasChildNodes) then
		castle_referee_detect_tag = null
		exit function
	end if

	castle_policy("tag_bool") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)

	'// TAG 미적용 모드
	if (castle_policy("tag_bool") = "FALSE") then
		castle_referee_detect_tag = null
		exit function
	end if

	Dim tag_list, list, castle_regexp
	Set tag_list = castle_xmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("LIST")

	'// 정규표현식으로 탐지
	castle_regexp = castle_referee_eregi(tag_list, castle_string)
	if Not(isNull(castle_regexp)) then
		castle_referee_detect_tag = castle_regexp
		exit function
	end if

	castle_referee_detect_tag = FALSE
end function

function castle_referee_check_ip_policy()

	'// 클라이언트 아이피 가져옴
    if Request.ServerVariables("HTTP_X_FORWARDED_FOR")<>"" then
    castle_check("ip") = Request.ServerVariables("HTTP_X_FORWARDED_FOR") 
    else
    castle_check("ip") = Request.ServerVariables("REMOTE_ADDR")
    end if
    

    if (castle_xmlDoc.GetElementsByTagName("IP")(0).hasChildNodes) then
	castle_policy("ip") = castle_xmlDoc.GetElementsByTagName("IP")(0).hasChildNodes
    end if

	'/* 아이피 정책 존재 판단 : IP 정책이 없으면 기본 허용 */
    if Not(castle_policy("ip")) then 
	castle_referee_check_ip_policy = null
	exit function
    end if

    castle_policy("ip_bool") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)
    castle_policy("ip_allow") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("ALLOW")(0).firstChild.nodeValue)
    castle_policy("ip_deny") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("DENY")(0).firstChild.nodeValue)
	
	'// 아이피 검사 사용 안함
    if (castle_policy("ip_bool") = "FALSE") then
	castle_referee_check_ip_policy = null
	exit function
    end if

	'// 목록 존재 판단
    if Not(castle_xmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("LIST")(0).hasChildNodes) then
	castle_referee_check_ip_policy = null
	exit function
    end if

	'// 목록 가져오기
    Dim ip_list, list, ip_exists, ip_regexp
    Set ip_list = castle_xmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("LIST")

	'// 목록에서 아이피 존재 검사
	ip_exists = FALSE
  
    Dim ip_comp1, ip_comp2, str_comp1, str_comp2
	
	for each list in ip_list
	    list = castle_CAPIUtil.Base64Decode(list.text)

        'IP Address validation
        list = Replace(list, "-", ".")
        ip_comp1 = Split(list, ".")
        ip_comp2 = Split(castle_check("ip"), ".")
        str_comp1 = ip_comp1(0) & ip_comp1(1) & ip_comp1(2)
        str_comp2 = ip_comp2(0) & ip_comp2(1) & ip_comp2(2)
        
        if (str_comp1 = str_comp2) then
	        
	        'IP 범위인 경우
	        if (UBound(ip_comp1) = 4) then
	        
	            if (ip_comp1(3) <= ip_comp2(3) And ip_comp2(3) <= ip_comp1(4)) then
	                ip_exists = TRUE
	            end if
            
            else
            
                if (ip_comp1(3) = 0 or ip_comp1(3) = ip_comp2(3)) then
	                ip_exists = TRUE
	            end if
            
	        end if
	        
        else

            str_comp1 = ip_comp1(0) & ip_comp1(1)
            str_comp2 = ip_comp2(0) & ip_comp2(1)
            
            if (str_comp1 = str_comp2 And ip_comp1(2) = 0 And ip_comp1(3) = 0) then
                ip_exists = TRUE
            else
            
                str_comp1 = ip_comp1(0)
                str_comp2 = ip_comp2(0)
                
                if (str_comp1 = str_comp2 And ip_comp1(1) = 0 And ip_comp1(2) = 0 And ip_comp1(3) = 0) then
                    ip_exists = TRUE
                else 
                    str_comp1 = ip_comp1(0) & ip_comp1(1) & ip_comp1(2) & ip_comp1(3)
                    if (str_comp1 = 0) then
                        ip_exists = TRUE
                    end if
                end if
                
            end if
	        
        end if
        	    
    next
    
    '/* 아이피 허용기반 정책 적용 */
	    '// 화이트리스트
    if (castle_policy("ip_allow") = "TRUE") then

        if Not(ip_exists) then
	        castle_referee_error_handler "아이피 정책", "check remote_ip", "IP", castle_check("ip"), "", "허용되지 않은 아이피 대역에서 접근 시도"
        end if
    	    
    else 
        '// 블랙리스트
        if (castle_policy("ip_deny") = "TRUE") then
            if (ip_exists) then
	           castle_referee_error_handler "아이피 정책", "check remote_ip", "IP", castle_check("ip"), "", "차단된 아이피 대역에서 접근 시도"
            end if
        end if		

    end if

    castle_referee_check_ip_policy = null
end function

function castle_referee_check_file_policy()

	castle_referee_check_file_policy = null
end function

function castle_referee_check_site_policy()

	'/* 사이트 정책 적용 */
	if (isEmpty(isEmpty(castle_xmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue))) then
		castle_referee_check_site_policy = null
	    exit function
    	end if

	'// 사이트 정책 가져오기
	castle_policy("site") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)

	'// 사이트 정책 적용
	if (castle_policy("site") = "FALSE") then
	    castle_referee_error_handler "사이트 정책", "check site-policy", "SITE", "사이트차단됨", "", "사이트 폐쇄"
	end if	

	castle_referee_check_site_policy = null
end function

function castle_referee_check_basic_policy()

	'// 페이지 이름을 가져옴
	castle_check("page_name") = Request.ServerVariables("SCRIPT_NAME")
	castle_check("page_name") = castle_referee_delete_directory_traverse(castle_check("page_name"))

	'/* GET 메소드 처리 */
	Dim key, value, pattern

	if (castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("GET")(0).firstChild.nodeValue) = "TRUE") then

	for each key in Request.QueryString
	
		'/* 탐지 대상별 탐지 */
		value = Request.QueryString(key)
		'// SQL_INJECTION 탐지
		pattern = castle_referee_detect_sql_injection(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "GET", key, value, "SQL_Injection 공격 패턴 탐지"
        end if		

		'// XSS 탐지
		pattern = castle_referee_detect_xss(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "GET", key, value, "XSS 공격 패턴 탐지"
	    end if		
		
		'// WORD 탐지
		pattern = castle_referee_detect_word(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책a", pattern, "GET", key, value, "불량 WORD 탐지"
	    end if		
		
		'// TAG 탐지
		pattern = castle_referee_detect_tag(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "GET", key, value, "TAG  공격 패턴 탐지"
	    end if
	    	
	next
	
	end if
    
	'/* POST 메소드 처리 */
	if (castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("POST")(0).firstChild.nodeValue) = "TRUE") then	

	for each key in Request.Form 
	
		'/* 탐지 대상별 탐지 */
		value = Request.Form(key)

		'// SQL_INJECTION 탐지
		pattern = castle_referee_detect_sql_injection(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "POST", key, value, "SQL_Injection 공격 패턴 탐지"
	    end if

		'// XSS 탐지
		pattern = castle_referee_detect_xss(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "POST", key, value, "XSS 공격 패턴 탐지"
        end if		

		'// WORD 탐지
		pattern = castle_referee_detect_word(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "POST", key, value, "불량 WORD 탐지"
	    end if
	    	
		'	// TAG 탐지
		pattern = castle_referee_detect_tag(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "POST", key, value, "TAG 공격 패턴 탐지"
	    end if
	    		
	next

	end if

	castle_referee_check_basic_policy = null
end function

function castle_referee_check_cookie_policy()

	'/* COOKIE 전역 변수 처리 */
	Dim key, value, pattern

	if (castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("COOKIE")(0).firstChild.nodeValue) = "TRUE") then

	for each key in Request.Cookies 
	
		'/* COOKIE 전역 변수 처리 */
        value = Request.Cookies(key)
		'/* 탐지 대상별 탐지 */
		pattern = castle_referee_detect_sql_injection(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "COOKIE", key, value, "SQL_Injection 공격 패턴 탐지"
	    end if		

		'// XSS 탐지
		pattern = castle_referee_detect_xss(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "COOKIE", key, value, "XSS 공격 패턴 탐지"
        end if		
		
		'// WORD 탐지
		pattern = castle_referee_detect_word(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "COOKIE", key, value, "불량 WORD 탐지"
	    end if		
		
		'// TAG 탐지
		pattern = castle_referee_detect_tag(value)
		if (pattern <> False) then
			castle_referee_error_handler "기본정책", pattern, "COOKIE", key, value, "TAG 공격 패턴 탐지"
	    end if
	    
	next

	end if

	castle_referee_check_cookie_policy = null
end function

function castle_referee_check_advance_policy()

	castle_referee_check_advance_policy = null
end function

'/* CASTLE Referee 메인 함수 */
function castle_referee_main()

	'	// IP 접근 시도 중재
	castle_referee_check_site_policy()

	'	// IP 접근 시도 중재
	castle_referee_check_ip_policy()

	'	// 기본 정책 적용
	castle_referee_check_basic_policy()

	'	// COOKIE 중재
	castle_referee_check_cookie_policy()

	castle_referee_main = null
end function
'/* CASTLE 집행 프레임워크 함수들 끝 */


if (isEmpty(castle_xmlDoc.GetElementsByTagName("ENFORCING")(0).firstChild.nodeValue)) then
	Response.End
end if

'/* CASTLE 템플릿 DISABLED 상태이면 바로 종료 */
castle_policy("disabled") = castle_CAPIUtil.Base64Decode(castle_xmlDoc.GetElementsByTagName("DISABLED")(0).firstChild.nodeValue)

if (castle_policy("disabled") = "FALSE") then

	'/* CASTLE Referee 메인 함수 호출 */
	castle_referee_main()

end if

function castle_error_handler()
	
    ' For Windows 2000 or XP
    ' For Script Version Upgrade
    if (hex(Err.Number) = "800A01B6" or hex(Err.Number) = "1B6") then
    
        Response.Write("===== 하위 버전의 서버 스크립트 사용 에러 ======<br><br>")
	    Response.Write "현재 " & ScriptEngine & " " & _
		ScriptEngineMajorVersion & "." & _
		ScriptEngineMinorVersion & "." & _
		ScriptEngineBuildVersion & " 사용중입니다.<br><br>"
	    Response.Write(ScriptEngine & " 5.5 이상이나 Microsoft Windows Script 5.6 이상으로 Upgrade 하세요.<br><br>")
	    Response.Write("마이크로소프트웨어 홈페이지에서 다운로드 받을 수 있습니다.<br>")
	    Response.Write("<script>if (confirm(""Windows 2000 및 XP용 Windows Script 5.6 을 \n\n다운로드 할 수 있는 Microsoft 웹사이트로 이동합니다.""))")
	    Response.Write("{location.href=""http://www.microsoft.com/downloads/details.aspx?familyid=c717d943-7e4b-4622-86eb-95a22b832caa&displaylang=ko"";}")
	    Response.Write("else {history.back();}</script>")
	    Response.End
        
    end if       

end function
'/* End of castle_referee.asp */
%>