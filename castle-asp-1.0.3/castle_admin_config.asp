<%

'//@UTF-8 castle_admin_config.asp
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
'If ("UTF-8" = Session("castle_site_charset")) then
'  Session.CodePage = 65001
'  Response.Charset = "UTF-8"
'else
  Session.CodePage = 949
  Response.Charset = "eucKR"
'end if

Dim check_installed, check_authorized

%>
<!--#include file="castle_admin_lib.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=<%= Response.Charset %>">
      <link rel="StyleSheet" HREF="style.css" type="text/css" title="style">
        <!--#include file="castle_admin_title.asp"-->
  </head>
  <body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" bgcolor="#D0D0D0">
    <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#000000">
      <tr bgcolor="#FFFFFF">
        <td>
          <table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
            <tr bgcolor="#606060">
              <td width="100%" height="80" colspan="2">
                <!--#include file="castle_admin_top.asp"-->
              </td>
            </tr>
            <tr>
              <td height="2" bgcolor="#000000" colspan="2"></td>
            </tr>
            <tr>
              <td width="160" bgcolor="#D0D0D0">
                <!--#include file="castle_admin_menu.asp"-->
              </td>
              <td width="100%" bgcolor="#E0E0E0">
                <table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
                  <tr valign="top">
                    <td width="100%">
                      <table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
                        <tr valign="top">
                          <td width="100%" style="line-height:120%" nowrap>
                            <table width="100%" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr height="100%">
                                <td width="9"><img src="img/menu_top_lt.gif"></td>
                                <td width="100%" background="img/menu_top_bg.gif">
                                  <font color="#C0C0C0"><li><b>�⺻����</b> - CASTLE �⺻ ��å�� �����մϴ�.</font>
                                </td>
                                <td width="8"><img src="img/menu_top_rt.gif"></td>
                              </tr>
                            </table>
                            <table width="100%" cellspacing="10" cellpadding="0" border="0">
                              <tr>
                                <td width="100%" style="line-height:160%" nowrap>
                                  <li>
                                    <b>�˸�: CASTLE �̸��� ���� �����Ͻñ� �ٶ��ϴ�.</b>
                                    <br>
                                    </td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr>
                                <td width="2"></td>
                                <td height="100%" bgcolor="#B0B0B0" align="center">
                                  <b>
                                    <font color="#FFFFFF">CASTLE �⺻����</font>
                                  </b>
                                </td>
                                <td width="2"></td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* ��å �⺻ ���� ���� �� ���� */

'	// ������ ���� ���� ���� ���� ����
Dim print
Set policy = createObject("Scripting.Dictionary")
Set print = createObject("Scripting.Dictionary")

if Not(isEmpty(libxmlDoc.GetElementsByTagName("MODULE_NAME")(0).firstChild.nodeValue)) then
	policy("admin_module_name") = libxmlDoc.GetElementsByTagName("MODULE_NAME")(0).firstChild.nodeValue
else
	policy("admin_module_name") = libCAPIUtil.Base64Encode(CASTLE_BASE_MODULE_NAME)
end if

print("admin_module_name") = libCAPIUtil.Base64Decode(policy("admin_module_name"))

'// CASTLE ���� ��� ���� ���� ����
policy("mode_enforcing") = libxmlDoc.GetElementsByTagName("ENFORCING")(0).firstChild.nodeValue
policy("mode_permissive") = libxmlDoc.GetElementsByTagName("PERMISSIVE")(0).firstChild.nodeValue
policy("mode_disabled") = libxmlDoc.GetElementsByTagName("DISABLED")(0).firstChild.nodeValue

policy("mode_enforcing") = libCAPIUtil.Base64Decode(policy("mode_enforcing"))
policy("mode_permissive") = libCAPIUtil.Base64Decode(policy("mode_permissive"))
policy("mode_disabled") = libCAPIUtil.Base64Decode(policy("mode_disabled"))

print("mode_enforcing_select") = ""
print("mode_permissive_select") = ""
print("mode_disabled_select") = ""

if (policy("mode_enforcing") = "TRUE") then
	print("mode_enforcing_select") = "selected"
end if

if (policy("mode_permissive") = "TRUE") then
	print("mode_permissive_select") = "selected"
end if

if (policy("mode_disabled") = "TRUE") then
	print("mode_disabled_select") = "selected"
end if

'// CASTLE �˸� ��� ���� ���� ����
policy("alert_alert") = libxmlDoc.GetElementsByTagName("ALERT")(0).GetElementsByTagName("ALERT")(0).firstChild.nodeValue
policy("alert_message") = libxmlDoc.GetElementsByTagName("MESSAGE")(0).firstChild.nodeValue
policy("alert_stealth") = libxmlDoc.GetElementsByTagName("STEALTH")(0).firstChild.nodeValue

policy("alert_alert") = libCAPIUtil.Base64Decode(policy("alert_alert"))
policy("alert_message") = libCAPIUtil.Base64Decode(policy("alert_message"))
policy("alert_stealth") = libCAPIUtil.Base64Decode(policy("alert_stealth"))

print("alert_alert_select") = ""
print("alert_message_select") = ""
print("alert_stealth_select") = ""

if (policy("alert_alert") = "TRUE") then
	print("alert_alert_select") = "selected"
end if

if (policy("alert_message") = "TRUE") then
	print("alert_message_select") = "selected"
end if

if (policy("alert_stealth") = "TRUE") then
	print("alert_stealth_select") = "selected"
end if

%>
                            <a name="basic"></a>
                            <table cellspacing="2" cellpadding="5" border="0">
                              <form action="castle_admin_config_submit.asp?mode=CONFIG_BASIC" method="post">
                                <tr>
                                  <th width="150" height="30" bgcolor="#D8D8D8" align="right">CASTLE �̸�</th>
                                  <td>
                                    <input type="text" name="admin_module_name" size="48" maxlength="64" value="<%= print("admin_module_name") %>">
                                  </td>
                                </tr>
                              </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <tr>
                                <th width="150" height="30" bgcolor="#D8D8D8" align="right">������</th>
                                <td>
                                  <select type="radio" name="config_mode">
                                    <option value="enforcing" 
                                      <%= print("mode_enforcing_select") %>>������
                                      <option value="permissive" 
                                        <%= print("mode_permissive_select") %>>������
                                        <option value="disabled" 
                                          <%= print("mode_disabled_select") %>>��������
                                        </select>
                                </td>
                              </tr>
                              <tr>
                                <td></td>
                                <td>
                                  <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                    <tr>
                                      <td bgcolor="#FFFFFF" style="line-height:120%" nowrap>
                                        <li>
                                          ������(enforcing) - ���� ����ŷ������ ������.
                                          <li>
                                            ������(permissive) - ����ŷ������ ���������� ���������� ����(�⺻).
                                            <li>
                                              ��������(disabled) - �� CASTLE�� �������� ����.
                                            </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr>
                                <th width="150" height="30" bgcolor="#D8D8D8" align="right">�˸����</th>
                                <td>
                                  <select type="radio" name="config_alert">
                                    <option value="alert" 
                                      <%= print("alert_alert_select") %>>�����
                                      <option value="message"  
                                        <%= print("alert_message_select") %>>�޼������
                                        <option value="stealth" 
                                          <%= print("alert_stealth_select") %>>���ڽ����
                                        </select>
                                </td>
                                <tr>
                                  <td></td>
                                  <td>
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap>
                                          <li>
                                            �����(Alert) - �������� ���â���� �˸�.
                                            <li>
                                              �޼������(Message) - �������� �޽����� �˸�.
                                              <li>
                                                ���ڽ����(Stealth) - �ƹ��� ����� �˸��� ����(�⺻).
                                              </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="475" height="35" cellspacing="0" cellpadding="0" border="0">
                              <tr valign="top">
                                <td width="175">&nbsp;</td>
                                <td width="300">
                                  <input type="image" src="img/button_confirm.gif">
                                    <input type="image" src="img/button_cancel.gif" onclick="reset(); return false;">
                                    </td>
                              </tr>
                              </form>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr>
                                <td width="2"></td>
                                <td height="100%" bgcolor="#B0B0B0" align="center">
                                  <b>
                                    <font color="#FFFFFF">����Ʈ ����</font>
                                  </b>
                                </td>
                                <td width="2"></td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* SITE ��� ���� ���� �� */

'	// SITE ��å ���� ���� ���� ����
if Not(isEmpty(libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)) then 
  policy("site_bool") =libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue
  policy("site_bool") = libCAPIUtil.Base64Decode(policy("site_bool"))
end if

if (libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("CHARSET")(0).hasChildNodes) then

  if (libCAPIUtil.Base64Decode(libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue) = "TRUE") then
    policy("site_charset_utf8") = "TRUE"
  else
    if (libCAPIUtil.Base64Decode(libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("eucKR")(0).firstChild.nodeValue) = "TRUE") then
      policy("site_charset_euckr") = "TRUE"
    end if
  end if

end if  

print("site_bool_true_check") = ""
print("site_bool_false_check") = ""

print("site_charset_utf8_check") = ""
print("site_charset_euckr_check") = ""

if (policy("site_bool") = "TRUE") then
	print("site_bool_true_check") = "checked"
else
	print("site_bool_false_check") = "checked"
end if

if (policy("site_charset_utf8") = "TRUE") then
	print("site_charset_utf8_check") = "checked"
else
  if (policy("site_charset_euckr") = "TRUE") then
	  print("site_charset_euckr_check") = "checked"
  end if
end if

%>
                            <a name="site"></a>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <form action="castle_admin_config_submit.asp?mode=CONFIG_SITE" method="post">
                                <tr>
                                  <th width="150" height="30" bgcolor="#D8D8D8" align="right">����Ʈ ��ݿ���</th>
                                  <td>
                                    <input type="radio" name="config_site_bool" value="true" 
                                      <%= print("site_bool_true_check") %>>����(�⺻)
                                      <input type="radio" name="config_site_bool" value="false" 
                                        <%= print("site_bool_false_check") %>>���
                                      </td>
                                </tr>
                                <tr>
                                  <td></td>
                                  <td>
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap>
                                          <li>
                                            ����(Open) - ����Ʈ�� ���������� ���.
                                            <li>
                                              ���(Closed) - ����Ʈ�� ����Ͽ� ����� ����.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <tr>
                                <th width="150" height="30" bgcolor="#D8D8D8" align="right">����Ʈ ���ڼ�</th>
                                <td>
                                  <input type="radio" name="config_site_charset" value="UTF-8" 
                                    <%= print("site_charset_utf8_check") %>>UTF-8
                                    <input type="radio" name="config_site_charset" value="eucKR" 
                                      <%= print("site_charset_euckr_check") %>>eucKR(�⺻)
                                    </td>
                              </tr>
                              <tr>
                                <td></td>
                                <td>
                                  <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                    <tr>
                                      <td bgcolor="#FFFFFF" style="line-height:120%" nowrap>
                                        <li>
                                          UTF-8 - ���� �� �� ������ ������ UTF-8�� ���(�⺻).
                                          <li>
                                            eucKR - ���� �� �� ������ ������ eucKR�� ���.
                                          </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="475" height="35" cellspacing="0" cellpadding="0" border="0">
                              <tr valign="top">
                                <td width="175">&nbsp;</td>
                                <td width="300">
                                  <input type="image" src="img/button_confirm.gif">
                                    <input type="image" src="img/button_cancel.gif" onclick="reset(); return false;">
                                    </td>
                              </tr>
                              </form>
                            </table>

<%
'/* ��å �⺻ ���� ���� �� �� */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr>
                                <td width="2"></td>
                                <td height="100%" bgcolor="#B0B0B0" align="center">
                                  <b>
                                    <font color="#FFFFFF">CASTLE ������</font>
                                  </b>
                                </td>
                                <td width="2"></td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* CASTLE ������ ���� �� ���� */

'	// CASTLE ���� ��� ���� ���� ����
policy("target_get") = libxmlDoc.GetElementsByTagName("GET")(0).firstChild.nodeValue
policy("target_post") = libxmlDoc.GetElementsByTagName("POST")(0).firstChild.nodeValue
policy("target_cookie") = libxmlDoc.GetElementsByTagName("COOKIE")(0).firstChild.nodeValue
'policy("target_file") = libxmlDoc.GetElementsByTagName("FILE")(0).firstChild.nodeValue

policy("target_get") = libCAPIUtil.Base64Decode(policy("target_get"))
policy("target_post") = libCAPIUtil.Base64Decode(policy("target_post"))
policy("target_cookie") = libCAPIUtil.Base64Decode(policy("target_cookie"))
'policy("target_file") = libCAPIUtil.Base64Decode(policy("target_file"))

print("target_get_true_check") = ""
print("target_get_false_check") = ""
print("target_post_true_check") = ""
print("target_post_false_check") = ""
print("target_cookie_true_check") = ""
print("target_cookie_false_check") = ""
'print("target_file_true_check") = ""
'print("target_file_false_check") = ""

if (policy("target_get") = "TRUE") then
	print("target_get_true_check") = "checked"
else
	print("target_get_false_check") = "checked"
end if

if (policy("target_post") = "TRUE") then
	print("target_post_true_check") = "checked"
else
	print("target_post_false_check") = "checked"
end if

if (policy("target_cookie") = "TRUE") then
	print("target_cookie_true_check") = "checked"
else
	print("target_cookie_false_check") = "checked"
end if

'if (policy("target_file") = "TRUE") then
'	print("target_file_true_check") = "checked"
'else
'	print("target_file_false_check") = "checked"
'end if

%>
                            <a name="target"></a>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <form action="castle_admin_config_submit.asp?mode=CONFIG_TARGET" method="post">
                                <tr>
                                  <th width="150" height="30" bgcolor="#D8D8D8" align="right">GET ����</th>
                                  <td width="120">
                                    <input type="radio" name="target_get" value="true" 
                                      <%= print("target_get_true_check") %>>����
                                      <input type="radio" name="target_get" value="false" 
                                        <%= print("target_get_false_check") %>>������
                                      </td>
                                  <th width="120" height="30" bgcolor="#D8D8D8" align="right">POST ����</th>
                                  <td width="120">
                                    <input type="radio" name="target_post" value="true" 
                                      <%= print("target_post_true_check") %>>����
                                      <input type="radio" name="target_post" value="false" 
                                        <%= print("target_post_false_check") %>>������
                                      </td>
                                  <th width="120" height="30" bgcolor="#D8D8D8" align="right">COOKIE ����</th>
                                  <td width="120">
                                    <input type="radio" name="target_cookie" value="true" 
                                      <%= print("target_cookie_true_check") %>>����
                                      <input type="radio" name="target_cookie" value="false" 
                                        <%= print("target_cookie_false_check") %>>������
                                      </td>
                                </tr>
                                <tr>
                                  <th width="150" height="30"></th>
                                  <td width="500" colspan="5">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            ����(True) - �� ������ ���ؼ� ��å�� ������.</div>
                                            <li>
                                              ������(False) - �� ������  ���ؼ� ��å�� �������� ����.</div>
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="475" height="50" cellspacing="0" cellpadding="0" border="0">
                              <tr valign="top">
                                <td width="175">&nbsp;</td>
                                <td width="300">
                                  <input type="image" src="img/button_confirm.gif">
                                    <input type="image" src="img/button_cancel.gif" onclick="reset(); return false;">
                                    </td>
                              </tr>
                              </form>
                            </table>
<%
'/* CASTLE ������ ���� �� �� */
%>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td height="2" bgcolor="#000000" colspan="2"></td>
            </tr>
            <tr bgcolor="#A0A0A0">
              <td width="100%" height="50" colspan="2" align="center">
                <!--#include file="castle_admin_bottom.asp"-->
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>