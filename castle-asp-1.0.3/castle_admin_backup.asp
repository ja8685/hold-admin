<% 

'//@UTF-8 castle_admin_backup.asp
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
                                  <font color="#C0C0C0"><li><b>백업관리</b> - CASTLE 정책을 백업합니다.</font>
                                </td>
                                <td width="8"><img src="img/menu_top_rt.gif"></td>
                              </tr>
                            </table>
                            <table width="100%" cellspacing="10" cellpadding="0" border="0">
                              <tr>
                                <td width="100%" style="line-height:160%" nowrap="">
                                  <li>
                                    <b>알림: 자주 정책 파일을 백업하면 안정적인 CASTLE 운영에 도움이 됩니다.</b>
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
                                    <font color="#FFFFFF">CASTLE 정책백업</font>
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
'/* 정책 파일 출력 */
Dim print
Set print = CreateObject("Scripting.Dictionary")
print("policy_filename") = "castle_policy.asp"
print("policy_down_filename") = Replace(Date(), "-", "") & "-castle_policy.xml"

Dim fso, objFile
Set fso = Server.CreateObject("Scripting.FileSystemObject")
Set objFile = fso.GetFile(Server.MapPath(print("policy_filename")))
print("policy_filesize") = FormatNumber(objfile.size, 0, -1, 0, -1)
print("policy_filemtime") = FormatDateTime(objFile.DateLastModified, 0)
%>
                            <table cellspacing="2" cellpadding="5" border="0">
                              <tr>
                                <th width="150" height="30" bgcolor="#D8D8D8" align="right">정책 파일 이름</th>
                                <td width="475">
                                  <%= print("policy_filename") %>
                                  </a>
                                </td>
                              </tr>
                              <tr>
                                <th width="150" height="30" bgcolor="#D8D8D8" align="right">정책 파일 크기</th>
                                <td width="475">
                                  <%= print("policy_filesize") %> Bytes</a>
                                </td>
                              </tr>
                              <tr>
                                <th width="150" height="30" bgcolor="#D8D8D8" align="right">최근 정책 수정일</th>
                                <td width="475">
                                  <%= print("policy_filemtime") %>
                                  </a>
                                </td>
                              </tr>
                              <tr>
                                <td></td>
                                <td>
                                  <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                    <tr>
                                      <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                        "Year.Month.Day-castle_policy.xml" 이름으로 다운로드 됩니다.<br>
                                          (ex. 20071016-castle_policy.xml)
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
                                  <a href="castle_admin_download.asp?filename=<%= print("policy_down_filename") %>&filepath=<%= print("policy_filename") %>">
                                  <img src="img/button_confirm.gif" border="0"></a>
                                  <input type="image" src="img/button_cancel.gif" onclick="history.back(-1);">
                                    </a>
                                  </td>
                              </tr>
                            </table>
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