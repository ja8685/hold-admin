<%

'//@UTF-8 install.asp
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

'	// ���� ���� �ܰ� ������ ���� ����
Session("castle_install") = TRUE
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=eucKR">
      <link rel="StyleSheet" HREF="style.css" type="text/css" title="style">
        <title>CASTLE ����ŷ���� - ASP ���� ��ġ�� �����մϴ�.</title>
      </head>
  <body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" bgcolor="#D0D0D0">
    <script language="javascript">
      function agree_check() {
         if (document.license.agreement.checked) {
              if (confirm("���̼����� ��� �а� �̿� �����Ͻʴϱ�?"))
                 return true;
              else
                 return false;
          }
      }
      function submit_check() {
        if (!document.license.agreement.checked) {
            alert("���̼����� ��� �а� �̿� �����Ͻʴϱ�?");
            return false;
        }

      location.href = "install_step1.asp";
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
                  <form name="license">
                    <textarea cols="90" rows="20" class="textarea">
 �ȳ���&���̼���

 �߿��� �����̹Ƿ� �ڼ��� �о� ���ñ� �ٶ��ϴ�.

 ����ڴ� �񿵸� �������� ����Կ� ���Ͽ� ��������Ʈ����� ����� �Ǹ���
 ����մϴ�. �� "����Ʈ����"��ǰ�� ��ǰ ���� ���Ե� ��� �μӹ�,�μ� �μ⹰
 �� ����Ʈ������ ���纻�鿡 ���� ���۱ǰ� ���� ��������
 �ѱ�������ȣ��������� �ֽ��ϴ�.

 �ѱ�������ȣ������� ��������Ʈ����� ����� �� ���ų� ������ �����
 �ν����� ���ؼ� �߻��� ���� �ս�,���� �ߴ�,��� ������ �ս� �Ǵ� ��������
 �ս� �� ������� ���ظ� ������ �μ����̰� �������� ���ؿ� ���ؼ� ��� �̿�
 ���� ���� ���ɼ��� ���� ������ �˰� �־��ٰ� �ص� �ѱ�������ȣ�����������
 ��� å�ӵ� ���� �ʽ��ϴ�.	
                    </textarea>
                    <br>
                    �� CASTLE�� ���õ� ���� ������ <font color="gray">castle@krcert.or.kr</font>�� �Ͻʽÿ�.
                    <br>
                      <input name="agreement" type="checkbox" value="1" onclick="return agree_check();">
                        ���� ���̼����� ��� �о����� �����մϴ�.<br>
                          <br>
                            <br>
                              <table width="100%" height="1">
                                <tr>
                                  <td width="100%" height="100%" background="img/line_bg.gif"></td>
                                </tr>
                              </table>
                              <input type="button" value="���� �ܰ��(Next).." class="submit" style="height:20px;" onclick="return submit_check();">
                              </form>
                </td>
              </tr>
            </table>
          </center>
        </body>
</html>
