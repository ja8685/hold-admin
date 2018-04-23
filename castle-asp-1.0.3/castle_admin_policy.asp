<% 

'//@UTF-8 castle_admin_policy.asp
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
                                  <font color="#C0C0C0"><li><b>정책설정</b> - CASTLE 정책을 설정합니다.</font>
                                </td>
                                <td width="8"><img src="img/menu_top_rt.gif"></td>
                              </tr>
                            </table>
                            <table width="100%" cellspacing="10" cellpadding="0" border="0">
                              <tr>
                                <td width="100%" style="line-height:160%" nowrap="">
                                  <li><b>주의: 적용 여부에 주의하시고 설정에 오류가 없도록 주의하십시오.</b><br>
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
                                    <font color="#FFFFFF">정책 설정</font>
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
'/* SQL INJECTION 정책 정보 수정 폼 */

'	// SQL INJECTION 정책 정보 설정 변수 설정
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
                                  <th width="100" height="30" bgcolor="#D8D8D8">적용여부</th>
                                  <td width="480">
                                    <input type="radio" name="policy_sql_injection" value="true" 
                                      <%= print("sql_injection_bool_true_check") %>>적용
                                      <input type="radio" name="policy_sql_injection" value="false" 
                                        <%= print("sql_injection_bool_false_check") %>>비적용
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            적용(True) - SQL Injection 취약점 탐지를 실행합니다.
                                            <li>
                                              비적용(False) - SQL Injection 취약점 탐지를 실행하지 않습니다.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">목록</th>
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
'/* SQL INJECTION 정책 정보 수정 폼 끝 */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* XSS 정책 정보 수정 폼 */

'	// XSS 정책 정보 설정 변수 설정
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
                                  <th width="100" height="30" bgcolor="#D8D8D8">적용여부</th>
                                  <td width="480">
                                    <input type="radio" name="policy_xss" value="true" 
                                      <%= print("xss_bool_true_check") %>>적용
                                      <input type="radio" name="policy_xss" value="false" 
                                        <%= print("xss_bool_false_check") %>>비적용
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            적용(True) - XSS 취약점 탐지를 실행합니다.
                                            <li>
                                              비적용(False) - XSS 취약점 탐지를 실행하지 않습니다.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">목록</th>
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
'/* XSS 정책 정보 수정 폼 끝 */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <%
'/* WORD 정책 정보 수정 폼 */

'	// WORD 정책 정보 설정 변수 설정
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
                                  <th width="150" height="30" rowspan="5" bgcolor="#D8D8D8" align="right">금칙어(WORD)&nbsp;</th>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">적용여부</th>
                                  <td width="480">
                                    <input type="radio" name="policy_word" value="true" 
                                      <%= print("word_bool_true_check") %>>적용
                                      <input type="radio" name="policy_word" value="false" 
                                        <%= print("word_bool_false_check") %>>비적용
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            적용(True) - WORD 취약점 탐지를 실행합니다.
                                            <li>
                                              비적용(False) - WORD 취약점 탐지를 실행하지 않습니다.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">목록</th>
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
'/* WORD 정책 정보 수정 폼 끝 */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* TAG 정책 정보 수정 폼 */

'	// TAG 정책 정보 설정 변수 설정
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
                                  <th width="150" height="30" rowspan="5" bgcolor="#D8D8D8" align="right">태그(TAG)</th>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">적용여부</th>
                                  <td width="480">
                                    <input type="radio" name="policy_tag" value="true" 
                                      <%= print("tag_bool_true_check") %>>적용
                                      <input type="radio" name="policy_tag" value="false" 
                                        <%= print("tag_bool_false_check") %>>비적용
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            적용(True) - TAG 취약점 탐지를 실행합니다.
                                            <li>
                                              비적용(False) - TAG 취약점 탐지를 실행하지 않습니다.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">목록</th>
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
'/* TAG 정책 정보 수정 폼 끝 */
%>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* IP 정책 정보 수정 폼 */

'	// IP 정책 정보 설정 변수 설정
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
                                  <th width="150" height="30" rowspan="7" bgcolor="#D8D8D8" align="right">아이피(IP)</th>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">적용여부</th>
                                  <td width="480">
                                    <input type="radio" name="policy_ip" value="true" 
                                      <%= print("ip_bool_true_check") %>>적용
                                      <input type="radio" name="policy_ip" value="false" 
                                        <%= print("ip_bool_false_check") %>>비적용
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            적용(True) - IP 탐지를 실행합니다.
                                            <li>
                                              비적용(False) - IP 탐지를 실행하지 않습니다.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">적용기반</th>
                                  <td width="480">
                                    <input type="radio" name="policy_ip_base" value="allow" 
                                      <%= print("ip_base_allow_check") %>>화이트리스트
                                      <input type="radio" name="policy_ip_base" value="deny" 
                                        <%= print("ip_base_deny_check") %>>블랙리스트(기본)
                                      </td>
                                </tr>
                                <tr>
                                  <th width="100"></th>
                                  <td width="410" colspan="2">
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            화이트리스트 - 다음 목록에서의 접근만을 허용합니다.
                                          <li>
                                            블랙리스트 - 다음 목록에서의 접근을 차단합니다.
                                          <li>예) 단일 IP나 192.168.128.0 대역, 192.168.128.1-255 가능
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="100" height="30" bgcolor="#D8D8D8">목록</th>
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
'/* IP 정책 정보 수정 폼 끝 */
%>
<%
'/* FILE 정책 정보 수정 폼
'                            <table width="800" height="1">
'                              <tr>
'                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
'                              </tr>
'                            </table>
'/* FILE 정책 정보 수정 폼 끝 */
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