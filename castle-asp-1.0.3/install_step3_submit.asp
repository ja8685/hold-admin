<% 

'//@UTF-8 install_step3_submit.asp
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
'If ("UTF-8" = Session("castle_site_charset")) then
'  Session.CodePage = 65001
'  Response.Charset = "UTF-8"
'else
  Session.CodePage = 949
  Response.Charset = "eucKR"
'end if

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

'	// 정책 리스트 목록
Dim list_sql_injection
list_sql_injection = array( _    		
				"delete\s+from", _
				"drop\s+database", _ 
				"drop\s+table", _
				"drop\s+column", _
				"drop\s+procedure", _
				"create\s+table", _
				"update\s+.*?set", _
				"insert\s+into.*?values", _
				"select\s+.*?from", _
				"bulk\s+insert", _
				"union\s+select", _
				"or\s+['""\s]*\w+['""\s]*\s*=\s*['""\s]*\w+", _
				"alter\s+table", _
				"into\s+outfile", _
				"load\s+data", _
				"declare.+?varchar.+?set" _
			)

Dim list_xss
list_xss = array( _
				"<script", _ 
				"javascript:", _ 
				"script.+?src\s*=", _ 
				"%3cscript", _ 
				"&#x3c;script", _ 
				"expression\s*\(", _ 
				"xss:.*\(", _
				"document\.cookie", _ 
				"document\.location", _ 
				"document\.write", _ 
				"onAbort\s*=", _ 
				"onBlur\s*=", _ 
				"onChange\s*=", _ 
				"onClick\s*=", _ 
				"onDblClick\s*=", _ 
				"onDragDrop\s*=", _ 
				"onError\s*=", _ 
				"onFocus\s*=", _ 
				"onKeyDown\s*=", _ 
				"onKeyPress\s*=", _ 
				"onKeyUp\s*=", _ 
				"onLoad\s*=", _ 
				"onMouseDown\s*=", _ 
				"onMouseMove\s*=", _ 
				"onMouseOut\s*=", _ 
				"onMouseOver\s*=", _ 
				"onMouseUp\s*=", _ 
				"onMove\s*=", _ 
				"onReset\s*=", _ 
				"onResize\s*=", _ 
				"onSelect\s*=", _ 
				"onSubmit\s*=", _ 
				"onUnload\s*=", _ 
				"location.href\s*=" _ 
			)

Dim list_word
list_word = array( _	
				"새끼", _ 
				"개새끼", _ 
				"소새끼", _ 
				"병신", _ 
				"지랄", _ 
				"씨팔", _ 
				"십팔", _ 
				"니기미", _ 
				"찌랄", _ 
				"쌍년", _ 
				"쌍놈", _ 
				"빙신", _ 
				"좆까", _ 
				"니기미", _ 
				"좆같은게", _ 
				"잡놈", _ 
				"벼엉신", _ 
				"바보새끼", _ 
				"씹새끼", _ 
				"씨발", _ 
				"씨팔", _ 
				"시벌", _ 
				"씨벌", _ 
				"떠그랄", _ 
				"좆밥", _ 
				"추천인", _ 
				"추천id", _ 
				"추천아이디", _ 
				"추/천/인", _ 
				"쉐이", _ 
				"등신", _ 
				"싸가지", _ 
				"미친놈", _ 
				"미친넘", _ 
				"찌랄", _ 
				"죽습니다", _ 
				"아님들아", _ 
				"씨밸넘", _ 
				"sex", _ 
				"섹스", _ 
				"바카라" _ 
			)

Dim list_tag
list_tag = array( _
				"<iframe\s*", _
				"<meta\s*", _
				"\.\./", _
				"\.\.\\\\" _	
			)

'Dim list_filetype
'list_filetype = array("txt", "jpg", "gif", "mp3", "hwp", "doc", "pdf", "zip")

'/* 내부 변수 초기화 */
castle_init_page()

'/* 내부 변수 초기화 끝 */

'/* 요청 변수 처리 */
castle_clear_submit()

Dim submit
Set submit = createObject("Scripting.Dictionary")

if Not(isEmpty(Request.Form("admin_id"))) Then
    submit("admin_id") = Request.Form("admin_id")
End if

if Not(isEmpty(Request.Form("admin_password"))) Then
	submit("admin_password") = Request.Form("admin_password")
End If

if Not(isEmpty(Request.Form("admin_repassword"))) Then
	submit("admin_repassword") = Request.Form("admin_repassword")
End If

if Not(isEmpty(Request.Form("log_filename"))) Then
	submit("log_filename") = Request.Form("log_filename")
End If

'	// 예외 사항 체크
Dim check_array
check_array = array("admin_id", "admin_password", "admin_repassword", "log_filename")
Application.Contents("key_array") = check_array
castle_check_submit()

if (submit("admin_password") <> submit("admin_repassword")) then
    html_msgback "암호와 확인 암호가 같지 않습니다."
    Response.End
end if

Dim check
Set check = CreateObject("Scripting.Dictionary")
check("admin_id_length") = Len(submit("admin_id"))
castle_check_length "관리자 아이디", check("admin_id_length"), 4, 16

check("admin_password_length") = Len(submit("admin_password"))
castle_check_length "관리자 암호", check("admin_password_length"), 8, 32

check("log_filename_length") = Len(submit("log_filename"))
castle_check_length "로그 파일이름", check("log_filename_length"), 4, 48


if Not((submit("log_filename") <> "castle_log.txt")) then
	html_msgback "castle_log.txt는 로그 파일이름으로 사용할 수 없습니다."
  Response.End
end if

'/* CASTLE 기본 정책 생성 */
Dim CAPIUtil
Set CAPIUtil = Server.CreateObject("CAPICOM.Utilities")
'Dim HashedData
Set HashedData = CreateObject("CAPICOM.HashedData")
HashedData.Algorithm = 4 'CAPICOM_HASH_ALGORITHM_SHA256
HashedData.Hash(submit("admin_password"))
HashedData.Hash(HashedData.Value) 


Dim xmlDoc
Set xmlDoc = Server.CreateObject("Microsoft.XMLDOM")
'Set xmlDoc = Server.CreateObject("MSXML2.DOMDocument.3.0")
xmlDoc.async = "false"

Dim CASTLE_POLICY, CONFIG, POLICY
Set CASTLE_POLICY = xmlDoc.CreateElement("CASTLE_POLICY")
xmlDoc.appendChild(CASTLE_POLICY)

Dim ADMIN, SITE, MODE, ALERT, LOG, TARGET
Set CONFIG = xmlDoc.createElement("CONFIG")
CASTLE_POLICY.appendChild(CONFIG)

Set ADMIN = xmlDoc.createElement("ADMIN")
Set SITE = xmlDoc.createElement("SITE")
Set MODE = xmlDoc.createElement("MODE")
Set ALERT = xmlDoc.createElement("ALERT")
Set LOG = xmlDoc.createElement("LOG")
Set TARGET = xmlDoc.createElement("TARGET")
CONFIG.AppendChild(ADMIN)
CONFIG.AppendChild(SITE)
CONFIG.AppendChild(MODE)
CONFIG.AppendChild(ALERT)
CONFIG.AppendChild(LOG)
CONFIG.AppendChild(TARGET)

Dim MODULE_NAME, ID, PASSWORD, LASTMODIFIED
Set MODULE_NAME = xmlDoc.createElement("MODULE_NAME")
Set ID          = xmlDoc.createElement("ID")
Set PASSWORD    = xmlDoc.createElement("PASSWORD")
Set LASTMODIFIED = xmlDoc.createElement("LASTMODIFIED")
ADMIN.AppendChild(MODULE_NAME)
ADMIN.AppendChild(ID)
ADMIN.AppendChild(PASSWORD)
ADMIN.AppendChild(LASTMODIFIED)

Dim BOOL, CHARSET
Set BOOL    =  xmlDoc.createElement("BOOL")
Set CHARSET =  xmlDoc.createElement("CHARSET")
SITE.AppendChild(BOOL)
SITE.AppendChild(CHARSET)

Dim UTF_8, EUC_KR
Set UTF_8   = xmlDoc.createElement("UTF-8")
Set EUC_KR = xmlDoc.createElement("eucKR")
CHARSET.AppendChild(UTF_8)
CHARSET.AppendChild(EUC_KR)

Dim ENFORCING, PERMISSIVE, DISABLED
Set ENFORCING    =  xmlDoc.createElement("ENFORCING")
Set PERMISSIVE =  xmlDoc.createElement("PERMISSIVE")
Set DISABLED    =  xmlDoc.createElement("DISABLED")
MODE.AppendChild(ENFORCING)
MODE.AppendChild(PERMISSIVE)
MODE.AppendChild(DISABLED)

Dim ALERT_, MESSAGE, STEALTH
Set ALERT_    =  xmlDoc.createElement("ALERT")
Set MESSAGE =  xmlDoc.createElement("MESSAGE")
Set STEALTH    =  xmlDoc.createElement("STEALTH")
ALERT.AppendChild(ALERT_)
ALERT.AppendChild(MESSAGE)
ALERT.AppendChild(STEALTH)

Dim FILENAME, DETAIL, SIMPLE, LIST_COUNT
Set BOOL    =  xmlDoc.createElement("BOOL")
Set FILENAME =  xmlDoc.createElement("FILENAME")
Set DETAIL    =  xmlDoc.createElement("DETAIL")
Set SIMPLE    =  xmlDoc.createElement("SIMPLE")
Set LIST_COUNT =  xmlDoc.createElement("LIST_COUNT")
Set CHARSET    =  xmlDoc.createElement("CHARSET")
LOG.AppendChild(BOOL)
LOG.AppendChild(FILENAME)
LOG.AppendChild(DETAIL)
LOG.AppendChild(SIMPLE)
LOG.AppendChild(LIST_COUNT)
LOG.AppendChild(CHARSET)

Set UTF_8   = xmlDoc.createElement("UTF-8")
Set EUC_KR = xmlDoc.createElement("eucKR")
CHARSET.AppendChild(UTF_8)
CHARSET.AppendChild(EUC_KR)

Dim GET_, POST_, FILE, COOKIE
Set GET_    =  xmlDoc.createElement("GET")
Set POST_    =  xmlDoc.createElement("POST")
'Set FILE =  xmlDoc.createElement("FILE")
Set COOKIE    =  xmlDoc.createElement("COOKIE")
TARGET.AppendChild(GET_)
TARGET.AppendChild(POST_)
'TARGET.AppendChild(FILE)
TARGET.AppendChild(COOKIE)

Dim SQL_INJECTION, XSS, WORD, TAG, IP', FILETYPE, FILESIZE
Set POLICY = xmlDoc.createElement("POLICY")
CASTLE_POLICY.appendChild(POLICY)

Set SQL_INJECTION = xmlDoc.createElement("SQL_INJECTION")
Set XSS = xmlDoc.createElement("XSS")
Set WORD = xmlDoc.createElement("WORD")
Set TAG = xmlDoc.createElement("TAG")
Set IP = xmlDoc.createElement("IP")
'Set FILENAME = xmlDoc.createElement("FILENAME")
'Set FILETYPE = xmlDoc.createElement("FILETYPE")
'Set FILESIZE = xmlDoc.createElement("FILESIZE")
POLICY.AppendChild(SQL_INJECTION)
POLICY.AppendChild(XSS)
POLICY.AppendChild(WORD)
POLICY.AppendChild(TAG)
POLICY.AppendChild(IP)
'POLICY.AppendChild(FILENAME)
'POLICY.AppendChild(FILETYPE)
'POLICY.AppendChild(FILESIZE)

Dim i, LIST
Set BOOL = xmlDoc.createElement("BOOL")
SQL_INJECTION.AppendChild(BOOL)
for i = LBound(list_sql_injection) to UBound(list_sql_injection)
		Set LIST = xmlDoc.createElement("LIST")
    SQL_INJECTION.AppendChild(LIST)
next

Set BOOL = xmlDoc.createElement("BOOL")
XSS.AppendChild(BOOL)
for i = LBound(list_xss) to UBound(list_xss)
		Set LIST = xmlDoc.createElement("LIST")
    XSS.AppendChild(LIST)
next

Set BOOL = xmlDoc.createElement("BOOL")
WORD.AppendChild(BOOL)
for i = LBound(list_word) to UBound(list_word)
		Set LIST = xmlDoc.createElement("LIST")
    WORD.AppendChild(LIST)
next

Set BOOL = xmlDoc.createElement("BOOL")
TAG.AppendChild(BOOL)
for i = LBound(list_tag) to UBound(list_tag)
		Set LIST = xmlDoc.createElement("LIST")
    TAG.AppendChild(LIST)
next

Dim ALLOW, DENY
Set BOOL  =  xmlDoc.createElement("BOOL")
Set ALLOW =  xmlDoc.createElement("ALLOW")
Set DENY  =  xmlDoc.createElement("DENY")
IP.AppendChild(BOOL)
IP.AppendChild(ALLOW)
IP.AppendChild(DENY)

'Set BOOL  =  xmlDoc.createElement("BOOL")
'Set ALLOW =  xmlDoc.createElement("ALLOW")
'Set DENY  =  xmlDoc.createElement("DENY")
'FILENAME.AppendChild(BOOL)
'FILENAME.AppendChild(ALLOW)
'FILENAME.AppendChild(DENY)

'Set BOOL  =  xmlDoc.createElement("BOOL")
'Set ALLOW =  xmlDoc.createElement("ALLOW")
'Set DENY  =  xmlDoc.createElement("DENY")
'FILETYPE.AppendChild(BOOL)
'FILETYPE.AppendChild(ALLOW)
'FILETYPE.AppendChild(DENY)
'FILETYPE.AppendChild xmlDoc.createElement("BOOL")
'FILETYPE.AppendChild xmlDoc.createElement("ALLOW")
'FILETYPE.AppendChild xmlDoc.createElement("DENY")

'for i = LBound(list_filetype) to UBound(list_filetype)
'		Set LIST = xmlDoc.createElement("LIST")
'    FILETYPE.AppendChild(LIST)
'next

'Dim MIN_SIZE, MAX_SIZE
'Set BOOL    =  xmlDoc.createElement("BOOL")
'Set MIN_SIZE =  xmlDoc.createElement("MIN_SIZE")
'Set MAX_SIZE =  xmlDoc.createElement("MAX_SIZE")
'FILESIZE.AppendChild(BOOL)
'FILESIZE.AppendChild(MIN_SIZE)
'FILESIZE.AppendChild(MAX_SIZE)

' Charset Check
Dim char_utf8, char_euckr
if (Session("castle_site_charset") <> "eucKR") then
    char_utf8 = "TRUE"
    char_euckr = "FALSE"
else
    char_utf8 = "FALSE"
    char_euckr = "TRUE"
end if


' 정책 생성
xmlDoc.GetElementsByTagName("MODULE_NAME")(0).text = CAPIUtil.Base64Encode(CASTLE_BASE_MODULE_NAME)
xmlDoc.GetElementsByTagName("ID")(0).text = CAPIUtil.Base64Encode(submit("admin_id"))
xmlDoc.GetElementsByTagName("PASSWORD")(0).text = CAPIUtil.Base64Encode(HashedData.Value)
xmlDoc.GetElementsByTagName("LASTMODIFIED")(0).text = CAPIUtil.Base64Encode(Now())
xmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("UTF-8")(0).text = CAPIUtil.Base64Encode(char_utf8)
xmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("eucKR")(0).text = CAPIUtil.Base64Encode(char_euckr)
xmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName(Session("castle_site_charset"))(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("ENFORCING")(0).text = CAPIUtil.Base64Encode("FALSE")
xmlDoc.GetElementsByTagName("PERMISSIVE")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("DISABLED")(0).text = CAPIUtil.Base64Encode("FALSE")
xmlDoc.GetElementsByTagName("ALERT")(0).GetElementsByTagName("ALERT")(0).text = CAPIUtil.Base64Encode("FALSE")
xmlDoc.GetElementsByTagName("MESSAGE")(0).text = CAPIUtil.Base64Encode("FALSE")
xmlDoc.GetElementsByTagName("STEALTH")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("FILENAME")(0).text = CAPIUtil.Base64Encode(submit("log_filename"))
xmlDoc.GetElementsByTagName("DETAIL")(0).text = CAPIUtil.Base64Encode("FALSE")
xmlDoc.GetElementsByTagName("SIMPLE")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("LIST_COUNT")(0).text = CAPIUtil.Base64Encode("10")
xmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("UTF-8")(0).text = CAPIUtil.Base64Encode(char_utf8)
xmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("eucKR")(0).text = CAPIUtil.Base64Encode(char_euckr)
xmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName(Session("castle_site_charset"))(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("GET")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("POST")(0).text = CAPIUtil.Base64Encode("TRUE")
'xmlDoc.GetElementsByTagName("FILE")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("COOKIE")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("FALSE")
xmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("TRUE")
xmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("FALSE")
xmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("ALLOW")(0).text = CAPIUtil.Base64Encode("FALSE")
xmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("DENY")(0).text = CAPIUtil.Base64Encode("TRUE")
'xmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("FALSE")
'xmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("ALLOW")(0).text = CAPIUtil.Base64Encode("FALSE")
'xmlDoc.GetElementsByTagName("FILENAME")(1).GetElementsByTagName("DENY")(0).text = CAPIUtil.Base64Encode("TRUE")
'xmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("TRUE")
'xmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("ALLOW")(0).text = CAPIUtil.Base64Encode("TRUE")
'xmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("DENY")(0).text = CAPIUtil.Base64Encode("FALSE")
'xmlDoc.GetElementsByTagName("FILESIZE")(0).GetElementsByTagName("BOOL")(0).text = CAPIUtil.Base64Encode("TRUE")
'xmlDoc.GetElementsByTagName("MIN_SIZE")(0).text = CAPIUtil.Base64Encode("0")
'xmlDoc.GetElementsByTagName("MAX_SIZE")(0).text = CAPIUtil.Base64Encode(MAX_FILESIZE)

for i = LBound(list_sql_injection) to UBound(list_sql_injection)
    xmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("LIST")(i).text = CAPIUtil.Base64Encode(list_sql_injection(i))
Next

for i = LBound(list_xss) to UBound(list_xss)
    xmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("LIST")(i).text = CAPIUtil.Base64Encode(list_xss(i))
Next

for i = LBound(list_word) to UBound(list_word)
    xmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("LIST")(i).text = CAPIUtil.Base64Encode(list_word(i))
Next

for i = LBound(list_tag) to UBound(list_tag)
    xmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("LIST")(i).text = CAPIUtil.Base64Encode(list_tag(i))
Next

'for i = LBound(list_filetype) to UBound(list_filetype)
'    xmlDoc.GetElementsByTagName("FILETYPE")(0).GetElementsByTagName("LIST")(i).text = CAPIUtil.Base64Encode(list_filetype(i))
'Next

'	// CASTLE 정책 쓰기
' // XML 소스 보안 정책 적용
Dim stXml, seXml
'Set stXml = xmlDoc.createProcessingInstruction("xml", "version=""1.0"" ")
Set stXml = xmlDoc.createProcessingInstruction("xml", "version=""1.0"" encoding=""UTF-8""")
Set seXml = xmlDoc.createComment("#include file=""castle_policy_secure.asp""")
xmlDoc.insertBefore seXml, xmlDoc.childNodes(0)
xmlDoc.insertBefore stXml, xmlDoc.childNodes(0)
castle_write_policy(xmlDoc)

Set submit = nothing
Set check = nothing
Set xmlDoc = nothing
Set CAPIUtil = nothing
Set HashedData = nothing

html_msgmove "설치가 끝났습니다.", "castle_admin.asp"

Response.End

'/* 설치 끝 */

%>
