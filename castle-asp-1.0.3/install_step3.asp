<% 

'//@UTF-8 install_step3.asp
'/*
'  * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : ����ȣ <hackeran@hotmail.com>
' *          ���缭 <mirr1004@gmail.com>
' *          ����ȯ <juluxer@gmail.com>
' *
' * Last modified Jun. 29, 2009
' *
' */

Option Explicit
'If (Session("castle_site_charset") = "UTF-8") then
'  Session.CodePage = 65001
'  Response.Charset = "UTF-8"
'else
  Session.CodePage = 949
  Response.Charset = "eucKR"
'end if

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

if (isEmpty(Session("castle_site_charset"))) then
	html_msgmove "Charset�� �������� �ʾҽ��ϴ�.", "install_step2.asp"
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=eucKR">
      <link rel="StyleSheet" HREF="style.css" type="text/css" title="style">
        <title>CASTLE ����ŷ���� - ��ġ 3�ܰ�</title>
      </head>
  <body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" bgcolor="#D0D0D0">
    <script language="javascript">
      function nextstep() {
      var len = document.step2.admin_id.value.length;
      if (len == 0) {
        alert("������ ���̵� �Էµ��� �ʾҽ��ϴ�.");
        document.step2.admin_id.focus();
      return;
      }
      len = document.step2.admin_password.value.length;
      if (len == 0) {
        alert("������ ��ȣ�� �Էµ��� �ʾҽ��ϴ�.");
        document.step2.admin_password.focus();
      return;
      }
      len = document.step2.admin_repassword.value.length;
      if (len == 0) {
        alert("������ Ȯ�ξ�ȣ�� �Էµ��� �ʾҽ��ϴ�.");
        document.step2.admin_repassword.focus();
      return;
      }
      if (document.step2.admin_password.value != document.step2.admin_repassword.value) {
        alert("��ȣ�� Ȯ�� ��ȣ�� ���� �ʽ��ϴ�.");
        document.step2.admin_repassword.focus();
      return;
      }

    	len = document.step2.log_filename.value.length;
      if (len == 0) {
        alert("�α� �����̸��� �Էµ��� �ʾҽ��ϴ�.");
        document.step2.log_filename.focus();
        return;
      }
			if (document.step2.log_filename.value == 'castle_log.txt') {
		          alert("�α� �����̸��� �����Ͽ� �ֽʽÿ�.");
		          document.step2.log_filename.focus();
		          return;
			}
      document.step2.submit();
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
                  <form name="step2" action="install_step3_submit.asp" method="post">
                    <table width="600" cellspacing="1" cellpadding="20" border="0" bgcolor="#000000"
                      <tr>
                        <td width="100%" bgcolor="#FFFFFF" style="line-height:160%" nowrap="">
                          <li>
                            <b>CASTLE ������ ������ �����ϰ� �α� �����̸��� �����մϴ�.</b>
                            <br>
                              <br>
                                �� �˸�1: ���̵�� �ּ� 4�� �̻��̸� �ִ� 16�� �����Դϴ�.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ����Ʈ���̵�(admininstartor, admin��) ������.<br>
                                  �� �˸�2: ���̵�� ������ ��ȣ�� ����� �� �����ϴ�.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ȣ�� �ּ� 8�� �̻��̸� �ִ� 32�� �����Դϴ�.<br>
                                  �� �˸�3: �α� �����̸��� �����Ͻñ� �ٶ��ϴ�.<br>
                                  </td>
                      </tr>
                    </table>
                    <br>
                      <br>
                        <center>
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
                            <tr height="30">
                              <td width="100" bgcolor="#C0C0C0" align="right">
                                <b>
                                  <font color="#404040">��ȣȮ��</font>
                                </b>
                              </td>
                              <td width="200" bgcolor="#FFFFFF">
                                <input type="password" name="admin_repassword" size="24">
                              </td>
                            </tr>
                          </table>
                          <br>
                            <br>
                              <b>
                                <font color="red">�� ����: ������ ���� ������ ��ȣ ã�� ����� �������� �����Ƿ� �ݵ�� ����ϼž� �մϴ�.</font>
                              </b>
                              <br><br>
                           
	                        <table width="300" cellspacing="1" cellpadding="5" border="0" bgcolor="#808080">
							            	<tr height="30">
							              	<td width="100" bgcolor="#C0C0C0" align="right"><b><font color="#404040">�α� �����̸�</font></b></td>
							              	<td width="200" bgcolor="#FFFFFF"><input type="text" name="log_filename" size="24" value='castle_log.txt'></td>
							            	</tr>
							          	</table>
							          	<br>
                      </center>
                        <table width="100%" height="1">
                          <tr>
                            <td width="100%" height="100%" background="img/line_bg.gif"></td>
                          </tr>
                        </table>
                        <input type="button" value="��ġ �Ϸ��ϱ�(Finish).." class="submit" style="height:20px;" onclick="return nextstep();">
                        </form>
                </td>
              </tr>
            </table>
          </center>
        </body>
</html>