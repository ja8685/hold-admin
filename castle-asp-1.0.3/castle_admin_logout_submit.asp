<%

'//@UTF-8 castle_admin_logout_submit.asp
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

'	// ���� ���� ����
Session.Contents.RemoveAll()

html_msgmove "������ �α׾ƿ� �Ǿ����ϴ�.", "castle_admin_login.asp"

Response.End
'/* ������ �α׾ƿ� �� */

%>
