<% 

'//@UTF-8 castle_admin_log_submit.asp
'/*
'  * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : ����ȣ <hackeran@hotmail.com>
' *          ���缭 <mirr1004@gmail.com>
' *          ����ȯ <juluxer@gmail.com>
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

'/* ���� ���� �ʱ�ȭ */
castle_init_page()

'//page_mode : �⺻ ���� ��� ����
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
	    Response.Write "���� �ε��� ������ �߻��Ͽ����ϴ�."
	    Response.End
    End If

End If

Dim submit, check_array, check
Set submit = CreateObject("Scripting.Dictionary")
Set check = CreateObject("Scripting.Dictionary")
'/* ���� ���� �ʱ�ȭ �� */

'/* �α� �缳�� */
if ("LOG_MODIFY" = page_mode) then 

	'/* ��û ���� ó�� */
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
    
		'// ���� ���� üũ
	'check_array = array("log_filename", "log_bool", "log_mode", "log_list_count", "log_charset")
	check_array = array("log_bool", "log_mode", "log_list_count", "log_charset")
	Application.Contents("key_array") = check_array
	castle_check_submit()

	'check("log_filename_length") = Len(submit("log_filename"))
	'castle_check_length "�α� �����̸�", check("log_filename_length"), 4, 48

	check("log_list_count_length") = Len(submit("log_list_count"))
	castle_check_length "�α� ��ϰ���", check("log_list_count_length"), 1, 3

	'/* CASTLE ��å ���� ����: �α� ���� ���� */

		'// ���� Ʈ��
	'	submit("log_filename") = trim(submit("log_filename"))

		'// magic_quotes_gpc() ���¿� ���� stripslashes ����
	'if (get_magic_quotes_gpc()) then
	'	submit("log_filename") = stripslashes(submit("log_filename"))
	'end if

		'// �α� �����̸� ����
	'libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("FILENAME")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(submit("log_filename"))

		'// �α� ��� ���� ����
	if (submit("log_bool") = "true") then
		libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if

		'// �α� ��� ����
	if (submit("log_mode") = "simple") then
		libxmlDoc.GetElementsByTagName("SIMPLE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
		libxmlDoc.GetElementsByTagName("DETAIL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	else
	    if (submit("log_mode") = "detail") then
		    libxmlDoc.GetElementsByTagName("SIMPLE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
		    libxmlDoc.GetElementsByTagName("DETAIL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
		end if
	end if

		'// �α� ���ڼ� ����
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

		'// �α� ��� ����
			'// ���� Ʈ��
	submit("log_list_count") = trim(submit("log_list_count"))

		'// magic_quotes_gpc() ���¿� ���� stripslashes ����
	'if (get_magic_quotes_gpc()) then
	'	submit("log_list_count") = stripslashes(submit("log_list_count"))
	'end if

	libxmlDoc.GetElementsByTagName("LIST_COUNT")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(submit("log_list_count"))

		'// CASTLE ��å ����
	castle_write_policy(libxmlDoc)

	html_msgmove "�α� ���� ������ �����Ǿ����ϴ�.", "castle_admin_log.asp"

	Response.End
end if
'/* �α� �缳�� �� */

'/* �α� ���� */
if ("LOG_DELETE" = page_mode) then

	'/* ��û ���� ó�� */
	castle_clear_submit()

	if Not(isEmpty(Request.QueryString("log_filename"))) then
		submit("log_filename") = Request.QueryString("log_filename")
	end if

		'// ���� ���� üũ
	check_array = array("log_filename")
	Application.Contents("key_array") = check_array
	castle_check_submit()

		'// ���� ����
	Dim log
	Set log = CreateObject("Scripting.Dictionary")
	
	log("filename") = "./log/" & submit("log_filename")

	If (libobjFS.FileExists(Server.MapPath(log("filename")))) Then
	    On Error Resume Next
		libobjFS.DeleteFile (Server.MapPath(log("filename")))
		if Err.Number <> 0 then
		    html_msgmove "�α� ������ ������ ������ �����ϴ�.", "castle_admin_log.asp"
            Response.End
        end if
	end if

	html_msgmove "�α� ������ �����Ǿ����ϴ�.", "castle_admin_log.asp"

	Response.End
    
end if
'/* �α� ���� �� */

%>