<% 

'//@UTF-8 castle_admin_download.asp
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

Dim submit, check_array, check
Set submit = CreateObject("Scripting.Dictionary")
Set check = CreateObject("Scripting.Dictionary")
'/* 내부 변수 초기화 끝 */

'/* 요청 변수 처리 */
castle_clear_submit()

if Not(isEmpty(Request.QueryString("filename"))) then
	submit("filename") = Request.QueryString("filename")
end if

if Not(isEmpty(Request.QueryString("filepath"))) then
	submit("filepath") = Request.QueryString("filepath")
end if

	'// 예외 사항 체크
check_array = array("filename", "filepath")
Application.Contents("key_array") = check_array
castle_check_submit()

	'// 변수 트림
submit("filename") = trim(submit("filename"))
submit("filepath") = trim(submit("filepath"))

check("filepath_length") = Len(submit("filepath"))
castle_check_length "파일경로", check("filepath_length"), 1, 256

	'// 디렉터리 트레버스 제거
submit("filepath") = castle_delete_directory_traverse(submit("filepath"))

	'// 다운로드 전체 경로 작성
submit("filepath") = Server.MapPath(submit("filepath"))

	'// 파일 정보 가져옴
Dim fso, fileinfo
Set fso = Server.CreateObject("Scripting.FileSystemObject")
Set fileinfo = fso.GetFile(submit("filepath"))

'response.write submit("filename") & "<br>" & submit("filepath") & "<br>" & fileinfo.Size
'response.end

	'// 파일 다운로드
castle_file_download submit("filename"), submit("filepath"), fileinfo.Size

Response.End
'/* 파일 다운로드 끝 */

%>