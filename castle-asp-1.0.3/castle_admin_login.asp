<%
response.end
'//@UTF-8 castle_admin_login.asp
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

'Option Explicit
'Session.CodePage = 65001
'Response.Charset = "UTF-8"
Session.CodePage = 949
Response.Charset = "eucKR"
Session("castle_site_charset") = Response.Charset

'/* ���� �� ��ġ �˻� ���� ������ */
Dim check_installed, check_authorized
check_authorized = TRUE

'Dim error_msg
'Set error_msg = CreateObject("Scripting.Dictionary")
'error_msg("admin_id") = castle_charset_change("������ ���̵� �Էµ��� �ʾҽ��ϴ�.")
'error_msg("admin_password") = castle_charset_change("������ ��ȣ�� �Էµ��� �ʾҽ��ϴ�.")
%>
<!--#include file="castle_admin_lib.asp"-->
<%
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

'/* SITE ���ڼ� ������ ���� ��ȯ */
'if (libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("CHARSET")(0).hasChildNodes) then
'
'  if (libCAPIUtil.Base64Decode(libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue) = "TRUE") then
'    Session("castle_site_charset") = "UTF-8"
'    Session.CodePage = 65001
'    Response.Charset = "UTF-8"
'  else
'    Session("castle_site_charset") = "eucKR"
'    Session.CodePage = 949
'    Response.Charset = "eucKR"
'  end if
'
'end if
%>
<!DOCTYPE HTML="" PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=<%= Response.Charset %>">
      <link rel="StyleSheet" HREF="style.css" type="text/css" title="style">
        <!--#include file="castle_admin_title.asp"-->
      </head>
  <body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" bgcolor="#D0D0D0">
    <script language="javascript">
      function nextstep() {
      var len = document.login.admin_id.value.length;
      if (len == 0) {
      //alert("<%'= error_msg("admin_id") %>");
      alert("������ ���̵� �Էµ��� �ʾҽ��ϴ�.");
      document.login.admin_id.focus();
      return false;
      }
      len = document.login.admin_password.value.length;
      if (len == 0) {
      //alert("<%'= error_msg("admin_password") %>");
      alert("������ ��ȣ�� �Էµ��� �ʾҽ��ϴ�.");
      document.login.admin_password.focus();
      return false;
      }
      document.login.submit();
      }
    </script>
    <br>
      <br>
        <br>
          <center>
            <table width="600" height="80" cellspacing="0" cellpadding="0" border="0">
              <tr>
                <td width="100%" height="80">
                  <img src="img/logo.png" border="0" alt="LOGO">
                  </td>
              </tr>
              <tr>
                <td>
                  <form name="login" action="castle_admin_login_submit.asp" method="post" onsubmit="return nextstep();">
                    <table width="100%" height="1">
                      <tr>
                        <td width="100%" height="100%" background="img/line_bg.gif"></td>
                      </tr>
                    </table>
                    <br>
                      <br>
                        <center>
                          <b>������ ����ȭ��</b>
                          <br>
                            <br>
                              <br>
                                <table width="300" cellspacing="1" cellpadding="5" border="0" bgcolor="#808080">
                                  <tr height="30">
                                    <td width="100" bgcolor="#C0C0C0" align="right">
                                      <b>
                                        <font color="#404040">������ ���̵�</font>
                                      </b>
                                    </td>
                                    <td width="200" colspan="3" bgcolor="#FFFFFF">
                                      <input type="text" name="admin_id" size="24">
                                    </td>
                                  </tr>
                                  <tr height="30">
                                    <td width="100" bgcolor="#C0C0C0" align="right">
                                      <b>
                                        <font color="#404040">��ȣ</font>
                                      </b>
                                    </td>
                                    <td width="200" bgcolor="#FFFFFF">
                                      <input type="password" name="admin_password" size="24">
                                    </td>
                                  </tr>
                                </tr>
            </table>
            <br>
              <input type="submit" value="�α���(Login)" class="submit" style="height:20px;">
                <input type="button" value="���(Cancel)" class="submit" style="height:20px;" onclick="reset(); return false">
                  <br>
                    <br>
                      <br>
                        <table width="100%" height="1">
                          <tr>
                            <td width="100%" height="100%" background="img/line_bg.gif"></td>
                          </tr>
                        </table>
                        <br>
                          <!--#include file="castle_admin_bottom.asp"-->
                          </form>
                          </td>
                          </tr>
                          </table>
                        </center>
        </body>
</html>