<% 

'//@UTF-8 install_step2_submit.asp
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
Session.CodePage = 949
Response.Charset = "eucKR"

'/* ���� �� ��ġ �˻� ���� ������ */
Dim check_installed, check_authorized
check_installed = TRUE
check_authorized = TRUE

%>
<!--#include file="castle_admin_lib.asp"-->
<%

'  /* ��ġ ���� �Ǵ� */
Dim objFS
Set objFS = Server.CreateObject("Scripting.FileSystemObject")
If (objFS.FileExists(Server.MapPath("castle_policy.asp"))) Then
  html_msgmove "CASTLE ����ŷ���� - ASP ������ �̹� ��ġ�Ǿ� �ֽ��ϴ�.", "castle_admin.asp"
End If
Set objFS = Nothing

if (isEmpty(Session("castle_install"))) then
	html_msgmove "install.asp ��ġ �ʱ� �������� �����Ͻʽÿ�.", "install.asp"
end if

'/* ���� ���� �ʱ�ȭ */
castle_init_page()

'/* ���� ���� �ʱ�ȭ �� */

'/* ��û ���� ó�� */
castle_clear_submit()

Dim submit
Set submit = CreateObject("Scripting.Dictionary")

if Not(isEmpty(Request.Form("site_charset"))) then
	submit("site_charset") = Request.Form("site_charset")
end if

'	// ���� ���� üũ
Dim check_array
check_array = array("site_charset")
Application.Contents("key_array") = check_array
castle_check_submit()

if ((submit("site_charset") <> "UTF-8") And _
	(submit("site_charset") <> "eucKR")) then
	html_msgback "Charset�� UTF-8 �Ǵ� eucKR�� �����մϴ�."
end if


Session("castle_site_charset") = submit("site_charset")

html_move "install_step3.asp"

Response.End

'/* 2�ܰ� �� */

%>
