<%
 
'//@UTF-8 castle_admin_top.asp
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
                            <font color="#FFFFFF"><b>CASTLE / ASP ����(<%= CASTLE_VERSION %>)</b></font><br><br>
                            <b>
                            <a href="castle_admin_logout_submit.asp"><font color="#FFFFFF">�α׾ƿ�</font></a> |
                            <a href="http://www.krcert.org" target="castle"><font color="#FFFFFF">����Ȩ������</font></a> |
                            <a href="http://www.krcert.org" target="castle"><font color="#FFFFFF">�޴���</font></a> | 
                            <a href="http://www.krcert.org"><font color="#FFFFFF">������</font></a> 
                            </b><br><br>
                            <font color="#B0B0B0">�ֱ� ��å ������: <%= last_modified %></font><br>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
