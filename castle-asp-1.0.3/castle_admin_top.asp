<%
 
'//@UTF-8 castle_admin_top.asp
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

On Error Resume Next
%>
<!--#include file="castle_version.asp"-->
<%

Dim policy, last_modified
Set policy = createObject("Scripting.Dictionary")

if Not(isEmpty(libxmlDoc.GetElementsByTagName("LASTMODIFIED")(0).firstChild.nodeValue)) Then
  last_modified = libxmlDoc.GetElementsByTagName("LASTMODIFIED")(0).firstChild.nodeValue
else
    last_modified = libCAPIUtil.Base64Encode("0")
end if

last_modified = libCAPIUtil.Base64Decode(last_modified)

%>
                <table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
                  <tr valign="middle">
                    <td width="50%">&nbsp;<a href="castle_admin.asp"><img src="img/logo.png" alt="LOGO" border="0"></a></td>
                    <td width="50%" align="right">
                      <table width="100%" height="100%" cellspacing="0" cellpadding="10">
                        <tr align="right">
                          <td>
                            <font color="#FFFFFF"><b>CASTLE / ASP 버전(<%= CASTLE_VERSION %>)</b></font><br><br>
                            <b>
                            <a href="castle_admin_logout_submit.asp"><font color="#FFFFFF">로그아웃</font></a> |
                            <a href="http://www.krcert.org" target="castle"><font color="#FFFFFF">공식홈페이지</font></a> |
                            <a href="http://www.krcert.org" target="castle"><font color="#FFFFFF">메뉴얼</font></a> | 
                            <a href="http://www.krcert.org"><font color="#FFFFFF">만든이</font></a> 
                            </b><br><br>
                            <font color="#B0B0B0">최근 정책 수정일: <%= last_modified %></font><br>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
