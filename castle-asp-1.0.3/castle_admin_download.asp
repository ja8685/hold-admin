<% 

'//@UTF-8 castle_admin_download.asp
'/*
'  * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : ����ȣ <hackeran@hotmail.com>
' *          ���缭 <mirr1004@gmail.com>
' *          ����ȯ <juluxer@gmail.com>
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

'/* ���� ���� �ʱ�ȭ */
castle_init_page()

Dim submit, check_array, check
Set submit = CreateObject("Scripting.Dictionary")
Set check = CreateObject("Scripting.Dictionary")
'/* ���� ���� �ʱ�ȭ �� */

'/* ��û ���� ó�� */
castle_clear_submit()

if Not(isEmpty(Request.QueryString("filename"))) then
	submit("filename") = Request.QueryString("filename")
end if

if Not(isEmpty(Request.QueryString("filepath"))) then
	submit("filepath") = Request.QueryString("filepath")
end if

	'// ���� ���� üũ
check_array = array("filename", "filepath")
Application.Contents("key_array") = check_array
castle_check_submit()

	'// ���� Ʈ��
submit("filename") = trim(submit("filename"))
submit("filepath") = trim(submit("filepath"))

check("filepath_length") = Len(submit("filepath"))
castle_check_length "���ϰ��", check("filepath_length"), 1, 256

	'// ���͸� Ʈ������ ����
submit("filepath") = castle_delete_directory_traverse(submit("filepath"))

	'// �ٿ�ε� ��ü ��� �ۼ�
submit("filepath") = Server.MapPath(submit("filepath"))

	'// ���� ���� ������
Dim fso, fileinfo
Set fso = Server.CreateObject("Scripting.FileSystemObject")
Set fileinfo = fso.GetFile(submit("filepath"))

'response.write submit("filename") & "<br>" & submit("filepath") & "<br>" & fileinfo.Size
'response.end

	'// ���� �ٿ�ε�
castle_file_download submit("filename"), submit("filepath"), fileinfo.Size

Response.End
'/* ���� �ٿ�ε� �� */

%>