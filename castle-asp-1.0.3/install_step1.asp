<% 

'//@UTF-8 install_step1.asp
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

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="""=Content-Type" content="text/html; charset=eucKR">
      <link rel="StyleSheet" HREF="style.css" type="text/css" title="style">
        <title>CASTLE ����ŷ���� - ��ġ 1�ܰ�</title>
      </head>
  <body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" bgcolor="#D0D0D0">
    <script language="javascript">
      function nextstep() {
        location.href = "install_step2.asp";
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
                  <form name="step1">
                    <table width="600" cellspacing="1" cellpadding="20" border="0" bgcolor="#000000"
                      <tr>
                        <td width="100%" bgcolor="#FFFFFF" style="line-height:160%" nowrap="">
                          <OL type="1">
                            <li>CASTLE ����ŷ���� ��ġ�� ���Ͽ� <font color="red">
                              <b>IIS ���ͳ� ���� ����(MMC)</b></font>�� �̿��Ͽ�</br>
                              <font color="red"><b>���� ���͸� ��</b></font>�� �����Ͻʽÿ�.</br>
                              ���͸��� ������ <font color="red"><b>�б�</b></font>�� �����Ͻʽÿ�.</br>
                              ���� ������ <font color="red"><b>��ũ��Ʈ ����</b></font>���� �����Ͻʽÿ�.</br>
                              <br>
                            </li>
                            <li>������ Ž���⿡�� ��ġ�� ���͸��� ��������� ��� <font color="red"><b>���� ��</b></font>�� �����Ͻʽÿ�.</br>
                              <font color="red"><b>���ͳ� �Խ�Ʈ ����</b></font>�� �߰��ϰ� ��� ���ѿ��� <font color="red"><b>����</b></font>�� �߰��Ͻʽÿ�.</br>
                            </li>
                          </OL>
                          <UL type="dot">
                            <li>CASTLE ����ŷ���� ��ġ ���͸� <%= Server.MapPath("./")%></li>
                            <li>./log ���͸� <%= Server.MapPath("./log")%></li>
                          </UL>                            
                        </td>
                      </tr>
                    </table>
                    <br>
                      <br>
                        <table width="100%" height="1">
                          <tr>
                            <td width="100%" height="100%" background="img/line_bg.gif"></td>
                          </tr>
                        </table>
                        <input type="button" value="���� �ܰ��(Next).." class="submit" style="height:20px;" onclick="return nextstep();">
                        </form>
                </td>
              </tr>
            </table>
          </center>
        </body>
</html>