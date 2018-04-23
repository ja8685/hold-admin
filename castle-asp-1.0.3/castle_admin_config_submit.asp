<% 

'//@UTF-8 castle_admin_account_submit.asp
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
On Error Resume Next
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

Set libxmlDoc = Server.CreateObject("Microsoft.XMLDOM")
'Set libxmlDoc = Server.CreateObject("MSXML2.DOMDocument.3.0")
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

'/* ��å �⺻ ���� �缳�� */
if ("CONFIG_BASIC" = page_mode) then

	'/* ��û ���� ó�� */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("admin_module_name"))) then
		submit("admin_module_name") = Request.Form("admin_module_name")
	end if

	if Not(isEmpty(Request.Form("config_mode"))) then
		submit("config_mode") = Request.Form("config_mode")
    end if
    
	if Not(isEmpty(Request.Form("config_alert"))) then
		submit("config_alert") = Request.Form("config_alert")
	end if

	'	// ���� ���� üũ
	check_array = array("admin_module_name", "config_mode", "config_alert")
	Application.Contents("key_array") = check_array
    castle_check_submit()

'/* CASTLE ��å ���� ����: �⺻ ���� ���� */
	'	// ���� Ʈ��
	submit("admin_module_name") = trim(submit("admin_module_name"))

    check("module_name_length") = Len(submit("admin_module_name"))
	castle_check_length "���ø� �̸�", check("module_name_length"), 4, 64

	'	// magic_quotes_gpc() ���¿� ���� stripslashes ����
	'if (get_magic_quotes_gpc()) then
	'	submit("admin_module_name") = stripslashes(submit("admin_module_name"))
	'end if

	'	// ���ø� �̸� ����
	libxmlDoc.GetElementsByTagName("MODULE_NAME")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode(submit("admin_module_name"))

	'	// ���� ��� ����
	libxmlDoc.GetElementsByTagName("ENFORCING")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("PERMISSIVE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("DISABLED")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")

	if (submit("config_mode") = "enforcing") then
		libxmlDoc.GetElementsByTagName("ENFORCING")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	end if

	if (submit("config_mode") = "permissive") then
		libxmlDoc.GetElementsByTagName("PERMISSIVE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	end if

	if (submit("config_mode") = "disabled") then
		libxmlDoc.GetElementsByTagName("DISABLED")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	end if

	'	// ��ϸ�� ����
	libxmlDoc.GetElementsByTagName("ALERT")(0).GetElementsByTagName("ALERT")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("MESSAGE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("STEALTH")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")

	if (submit("config_alert") = "alert") then
		libxmlDoc.GetElementsByTagName("ALERT")(0).GetElementsByTagName("ALERT")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	end if
		
	if (submit("config_alert") = "message") then
		libxmlDoc.GetElementsByTagName("MESSAGE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	end if

	if (submit("config_alert") = "stealth") then
		libxmlDoc.GetElementsByTagName("STEALTH")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	end if

	'	// CASTLE ��å ����
	castle_write_policy(libxmlDoc)

	html_msgmove "CASTLE ��å �⺻���� ������ �����Ǿ����ϴ�.", "castle_admin_config.asp#basic"
	
    Set submit = nothing
    Set check = nothing
    
	Response.End
end if
'/* ��å �⺻ ���� �缳�� �� */

'/* SITE ��å �缳�� */
if ("CONFIG_SITE" = page_mode) then

	'/* ��û ���� ó�� */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("config_site_bool"))) then
		submit("config_site_bool") = Request.Form("config_site_bool")
	end if

	if Not(isEmpty(Request.Form("config_site_charset"))) then
		submit("config_site_charset") = Request.Form("config_site_charset")
    end if
    
	'	// ���� ���� üũ
	check_array = array("config_site_bool", "config_site_charset")
	Application.Contents("key_array") = check_array
    castle_check_submit()

	'/* CASTLE ��å ���� ����: SITE ��å ���� */
	'	// ���� ��� ����

	if (submit("config_site_bool") = "true") then
		libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if

	if (submit("config_site_charset") = "UTF-8") then
		libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if

	if (submit("config_site_charset") = "eucKR") then
		libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("eucKR")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
	else
		libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("eucKR")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	end if

	'	// CASTLE ��å ����
	castle_write_policy(libxmlDoc)

	html_msgmove "SITE ��å�� �����Ǿ����ϴ�.", "castle_admin_config.asp#site"

	Set submit = nothing
    Set check = nothing
    
	Response.End
end if
'/* SITE ��å �缳�� �� */

'/* CASTLE ������ ���� �缳�� */
if ("CONFIG_TARGET" = page_mode) then

	'/* ��û ���� ó�� */
	castle_clear_submit()

	if Not(isEmpty(Request.Form("target_get"))) then
		submit("target_get") = Request.Form("target_get")
    end if
    
	if Not(isEmpty(Request.Form("target_post"))) then
		submit("target_post") = Request.Form("target_post")
	end if

	if Not(isEmpty(Request.Form("target_cookie"))) then
		submit("target_cookie") = Request.Form("target_cookie")
    end if
    
	if Not(isEmpty(Request.Form("target_file"))) then
		submit("target_file") = Request.Form("target_file")
    end if
    
	'	// ���� ���� üũ
	check_array = array("target_get", "target_post", "target_cookie", "target_file")
	Application.Contents("key_array") = check_array
    castle_check_submit()

	'/* CASTLE ��å ���� ����: �⺻ ���� ���� */
	'	// ���� ��� ����
	libxmlDoc.GetElementsByTagName("GET")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("POST")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("FILE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")
	libxmlDoc.GetElementsByTagName("COOKIE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("FALSE")

	if (submit("target_get") = "true") then
		libxmlDoc.GetElementsByTagName("GET")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
    end if
    
	if (submit("target_post") = "true") then
		libxmlDoc.GetElementsByTagName("POST")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
    end if
    
	if (submit("target_cookie") = "true") then
		libxmlDoc.GetElementsByTagName("COOKIE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
    end if
    
	if (submit("target_file") = "true") then
		libxmlDoc.GetElementsByTagName("FILE")(0).firstChild.nodeValue = libCAPIUtil.Base64Encode("TRUE")
    end if
    
	'	// CASTLE ��å ����
	castle_write_policy(libxmlDoc)

	html_msgmove "CASTLE ��å ���� ��� ������ �����Ǿ����ϴ�.", "castle_admin_config.asp#target"

    Set submit = nothing
    Set check = nothing
    
	Response.End
end if
'/* CASTLE ������ ���� �缳�� �� */

%>