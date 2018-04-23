<% 

'//@UTF-8 castle_admin_policy.asp
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
                          <td width="100%">
                            <table width="100%" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr height="100%">
                                <td width="9"><img src="img/menu_top_lt.gif"></td>
                                <td width="100%" background="img/menu_top_bg.gif">
                                  <font color="#C0C0C0"><li><b>��å����</b> - CASTLE ��å�� �����մϴ�.</font>
                                </td>
                                <td width="8"><img src="img/menu_top_rt.gif"></td>
                              </tr>
                            </table>
                            <table width="100%" cellspacing="10" cellpadding="0" border="0">
                              <tr>
                                <td width="100%" style="line-height:160%" nowrap="">
                                  <li><b>����: ���� ���ο� �����Ͻð� ������ ������ ������ �����Ͻʽÿ�.</b><br>
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
                                    <font color="#FFFFFF">��å ����</font>
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
'/* SQL INJECTION ��å ���� ���� �� */

'	// SQL INJECTION ��å ���� ���� ���� ����
Dim print, list
Set policy = createObject("Scripting.Dictionary")
Set print = createObject("Scripting.Dictionary")

policy("sql_injection_bool") = libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue
policy("sql_injection_bool") = libCAPIUtil.Base64Decode(policy("sql_injection_bool"))
print("sql_injection_bool_true_check") = ""
print("sql_injection_bool_false_check") = ""

if (policy("sql_injection_bool") = "TRUE") then
  print("sql_injection_bool_true_check") = "checked"
else
  print("sql_injection_bool_false_check") = "checked"
end if

print("sql_injection_list") = ""
for each list in libxmlDoc.GetElementsByTagName("SQL_INJECTION")(0).GetElementsByTagName("LIST")
  print("sql_injection_list") = print("sql_injection_list") & libCAPIUtil.Base64Decode(list.firstChild.nodeValue) & chr(13)
Next

%>
                            <a name="sql_injection"></a>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <form action="castle_admin_policy_submit.asp?mode=POLICY_SQL_INJECTION" method="post">
                                <tr>
                                  <th width="150" height="30" rowspan="5" bgcolor="#D8D8D8" align="right">SQL Injection</th>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���뿩��</th>
                                  <td width="480">
                                    <input type="radio" name="policy_sql_injection" value="true" 
                                      <%= print("sql_injection_bool_true_check") %>>����
                                      <input type="radio" name="policy_sql_injection" value="false" 
                                        <%= print("sql_injection_bool_false_check") %>>������
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            ����(True) - SQL Injection ����� Ž���� �����մϴ�.
                                            <li>
                                              ������(False) - SQL Injection ����� Ž���� �������� �ʽ��ϴ�.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���</th>
                                  <td width="410" colspan="2">
                                    <textarea cols="65" rows="10" name="policy_sql_injection_list"><%= print("sql_injection_list") %></textarea>
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
'/* SQL INJECTION ��å ���� ���� �� �� */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* XSS ��å ���� ���� �� */

'	// XSS ��å ���� ���� ���� ����
policy("xss_bool") = libxmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue
policy("xss_bool") = libCAPIUtil.Base64Decode(policy("xss_bool"))
print("xss_bool_true_check") = ""
print("xss_bool_false_check") = ""

if (policy("xss_bool") = "TRUE") then
	print("xss_bool_true_check") = "checked"
else
	print("xss_bool_false_check") = "checked"
end if

print("xss_list") = ""
for each list in libxmlDoc.GetElementsByTagName("XSS")(0).GetElementsByTagName("LIST")
  print("xss_list") = print("xss_list") & libCAPIUtil.Base64Decode(list.firstChild.nodeValue) & chr(13)
Next
  
%>
  <a name="xss"></a>
  <table width="800" cellspacing="2" cellpadding="5" border="0">
    <form action="castle_admin_policy_submit.asp?mode=POLICY_XSS" method="post">
                                <tr>
                                  <th width="150" height="30" rowspan="5" bgcolor="#D8D8D8" align="right">
                                    XSS<br>
                                      (Cross-Site Script)
                                    </th>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���뿩��</th>
                                  <td width="480">
                                    <input type="radio" name="policy_xss" value="true" 
                                      <%= print("xss_bool_true_check") %>>����
                                      <input type="radio" name="policy_xss" value="false" 
                                        <%= print("xss_bool_false_check") %>>������
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            ����(True) - XSS ����� Ž���� �����մϴ�.
                                            <li>
                                              ������(False) - XSS ����� Ž���� �������� �ʽ��ϴ�.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���</th>
                                  <td width="410" colspan="2">
                                    <textarea cols="65" rows="10" name="policy_xss_list"><%= print("xss_list") %></textarea>
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
'/* XSS ��å ���� ���� �� �� */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <%
'/* WORD ��å ���� ���� �� */

'	// WORD ��å ���� ���� ���� ����
policy("word_bool") = libxmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue
policy("word_bool") = libCAPIUtil.Base64Decode(policy("word_bool"))
print("word_bool_true_check") = ""
print("word_bool_false_check") = ""

if (policy("word_bool") = "TRUE") then
	print("word_bool_true_check") = "checked"
else
	print("word_bool_false_check") = "checked"
end if

print("word_list") = ""
for each list in libxmlDoc.GetElementsByTagName("WORD")(0).GetElementsByTagName("LIST")
  print("word_list") = print("word_list") & libCAPIUtil.Base64Decode(list.firstChild.nodeValue) & chr(13)
Next

%>
                            <a name="word"></a>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <form action="castle_admin_policy_submit.asp?mode=POLICY_WORD" method="post">
                                <tr>
                                  <th width="150" height="30" rowspan="5" bgcolor="#D8D8D8" align="right">��Ģ��(WORD)&nbsp;</th>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���뿩��</th>
                                  <td width="480">
                                    <input type="radio" name="policy_word" value="true" 
                                      <%= print("word_bool_true_check") %>>����
                                      <input type="radio" name="policy_word" value="false" 
                                        <%= print("word_bool_false_check") %>>������
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            ����(True) - WORD ����� Ž���� �����մϴ�.
                                            <li>
                                              ������(False) - WORD ����� Ž���� �������� �ʽ��ϴ�.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���</th>
                                  <td width="410" colspan="2">
                                    <textarea cols="65" rows="10" name="policy_word_list"><%= print("word_list") %></textarea>
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
'/* WORD ��å ���� ���� �� �� */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* TAG ��å ���� ���� �� */

'	// TAG ��å ���� ���� ���� ����
policy("tag_bool") = libxmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue
policy("tag_bool") = libCAPIUtil.Base64Decode(policy("tag_bool"))
print("tag_bool_true_check") = ""
print("tag_bool_false_check") = ""

if (policy("tag_bool") = "TRUE") then
	print("tag_bool_true_check") = "checked"
else
	print("tag_bool_false_check") = "checked"
end if

print("tag_list") = ""
for each list in libxmlDoc.GetElementsByTagName("TAG")(0).GetElementsByTagName("LIST")
  print("tag_list") = print("tag_list") & libCAPIUtil.Base64Decode(list.firstChild.nodeValue) & chr(13)
Next

%>
                            <a name="tag"></a>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <form action="castle_admin_policy_submit.asp?mode=POLICY_TAG" method="post">
                                <tr>
                                  <th width="150" height="30" rowspan="5" bgcolor="#D8D8D8" align="right">�±�(TAG)</th>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���뿩��</th>
                                  <td width="480">
                                    <input type="radio" name="policy_tag" value="true" 
                                      <%= print("tag_bool_true_check") %>>����
                                      <input type="radio" name="policy_tag" value="false" 
                                        <%= print("tag_bool_false_check") %>>������
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            ����(True) - TAG ����� Ž���� �����մϴ�.
                                            <li>
                                              ������(False) - TAG ����� Ž���� �������� �ʽ��ϴ�.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���</th>
                                  <td width="410" colspan="2">
                                    <textarea cols="65" rows="10" name="policy_tag_list"><%= print("tag_list") %></textarea>
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
'/* TAG ��å ���� ���� �� �� */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* IP ��å ���� ���� �� */

'	// IP ��å ���� ���� ���� ����
policy("ip_bool") = libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue
policy("ip_allow") = libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("ALLOW")(0).firstChild.nodeValue
policy("ip_deny") = libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("DENY")(0).firstChild.nodeValue

policy("ip_bool") = libCAPIUtil.Base64Decode(policy("ip_bool"))
policy("ip_allow") = libCAPIUtil.Base64Decode(policy("ip_allow"))
policy("ip_deny") = libCAPIUtil.Base64Decode(policy("ip_deny"))

print("ip_bool_true_check") = ""
print("ip_bool_false_check") = ""
print("ip_base_allow_check") = ""
print("ip_base_deny_check") = ""

if (policy("ip_bool") = "TRUE") then
	print("ip_bool_true_check") = "checked"
else
	print("ip_bool_false_check") = "checked"
end if

if (policy("ip_allow") = "TRUE") then
	print("ip_base_allow_check") = "checked"
else
  if (policy("ip_deny") = "TRUE") then
		print("ip_base_deny_check") = "checked"
  end if
end if

print("ip_list") = ""
for each list in libxmlDoc.GetElementsByTagName("IP")(0).GetElementsByTagName("LIST")
  print("ip_list") = print("ip_list") & libCAPIUtil.Base64Decode(list.firstChild.nodeValue) & chr(13)
Next

%>
                            <a name="ip"></a>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <form action="castle_admin_policy_submit.asp?mode=POLICY_IP" method="post">
                                <tr>
                                  <th width="150" height="30" rowspan="7" bgcolor="#D8D8D8" align="right">������(IP)</th>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���뿩��</th>
                                  <td width="480">
                                    <input type="radio" name="policy_ip" value="true" 
                                      <%= print("ip_bool_true_check") %>>����
                                      <input type="radio" name="policy_ip" value="false" 
                                        <%= print("ip_bool_false_check") %>>������
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            ����(True) - IP Ž���� �����մϴ�.
                                            <li>
                                              ������(False) - IP Ž���� �������� �ʽ��ϴ�.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">������</th>
                                  <td width="480">
                                    <input type="radio" name="policy_ip_base" value="allow" 
                                      <%= print("ip_base_allow_check") %>>ȭ��Ʈ����Ʈ
                                      <input type="radio" name="policy_ip_base" value="deny" 
                                        <%= print("ip_base_deny_check") %>>������Ʈ(�⺻)
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            ȭ��Ʈ����Ʈ - ���� ��Ͽ����� ���ٸ��� ����մϴ�.
                                          <li>
                                            ������Ʈ - ���� ��Ͽ����� ������ �����մϴ�.
                                          <li>��) ���� IP�� 192.168.128.0 �뿪, 192.168.128.1-255 ����
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">���</th>
                                  <td width="410" colspan="2">
                                    <textarea cols="65" rows="10" name="policy_ip_list"><%= print("ip_list") %></textarea>
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
'/* IP ��å ���� ���� �� �� */
%>
<%
'/* FILE ��å ���� ���� ��
'                            <table width="800" height="1">
'                              <tr>
'                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
'                              </tr>
'                            </table>
'/* FILE ��å ���� ���� �� �� */
%>
                            </form>
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