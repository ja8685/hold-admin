<%
 
'//@UTF-8 castle_admin.asp
'/*
'  * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : ����ȣ <hackeran@hotmail.com>
' *          ���缭 <mirr1004@gmail.com>
' *          ����ȯ <juluxer@gmail.com>
' *
' * Last modified Jun. 30, 2009
' *
' */

'Option Explicit
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
                      <table width="100%" height="100%" cellspacing="20" cellpadding="0" border="0">
                        <tr valign="top">
                          <td width="100%" style="line-height:160%" nowrap="">
                            <li><b>���� ������: CASTLE - KISA Web Attack Defender / ���� ������: ĳ��</b><br>
                            ���� ������ ��� <b>CASTLE</b>�� ��Ī�ϸ� ������ ��쿡�� <b>ĳ��</b>�� ��Ī�մϴ�.<br>
                            <br>
                            <b>CASTLE - ASP ���� ������ �������Դϴ�.</b><br>
                            ������ CASTLE�� ��ü���� ������ �� �� �ִ� ������ �������Դϴ�.<br>
                            ������ �������� �⺻, ��å �� ��� ������ CASTLE�� ���õ� ��� ������ �� �� �ֽ��ϴ�.<br>
                            ������ ������ ������ �����̸� ���� �ڼ��� ������ <a href="http://www.krcert.or.kr" target="castle"><b>����Ȩ������</b></a>�� ���ؼ� Ȯ���� �� �ֽ��ϴ�.<br>
                            <br>
                            <table width="800" height="1">
                              <tr>
                                <td width="100" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr>
                                <td width="5"></td>
                                <td height="100%" bgcolor="#B0B0B0" align="center"><b><font color="#FFFFFF">�޴� ����</font></b></td>
                                <td width="5"></td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <tr valign="top">
                                <td width="100" height="100%" bgcolor="#D8D8D8" style="line-height:160%" nowrap>
                                  1. <a href="castle_admin.asp#home">HOME</a><br>
                                  2. <a href="castle_admin.asp#account">��������</a><br>
                                  3. <a href="castle_admin.asp#config">�⺻����</a><br>
                                  4. <a href="castle_admin.asp#policy">��å����</a><br>
                                  5. <a href="castle_admin.asp#log">�αװ���</a><br>
                                  6. <a href="castle_admin.asp#policyview">��å����</a><br>
                                  7. <a href="castle_admin.asp#backup">�������</a><br>
                                </td>
                                <td>
                                  <table width="100%" height="100%" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                    <tr>
                                      <td bgcolor="#FFFFFF">
                                        <pre style="line-height:160%">
<a name="home"><b>1. HOME</b></a>
    HOME �޴��� ���� �������� ������ ó��ȭ������ �̵��ϴ� ���� �ǹ��մϴ�.


<a name="account"><b>2. ��������</b></a>
    ������ ���� ������ ���� �߿��� �����Դϴ�. ���� ������ �����Ͽ��� �մϴ�.
    ��ȣ�� ���� SHA-1�� ����Ǿ� �����մϴ�.
    <font color="red">* ����: ���̵�� ��ȣ�� �ݵ�� 8�� �̻����� �����Ͻʽÿ�.</font>


<a name="config"><b>3. �⺻����</b></a>
    �⺻ ������ CASTLE�� �⺻���̸鼭 ���� �߿��� ����� �����մϴ�.

    ��. CASTLE �⺻����
    ��. ����Ʈ ����
    ��. CASTLE ������


<a name="policy"><b>4. ��å����</b></a>
    ��å ������ ���� ������  CASTLE ��å�� �����մϴ�.
    �̷��� ������  ��å�� ��޼��� �κп��� �������� ���� ��� �������� ����˴ϴ�.

    ��. SQL Injection ��å ����
    ��. XSS ��å ����
    ��. ��Ģ��(WORD) ��å ����
    ��. �±�(TAG) ��å ����

<a name="log"><b>5. �αװ���</b></a>
    �α� ������ CASTLE�� ���� Ž���Ǿ� ��ϵǴ� �α׵��� �����մϴ�.

    ��. �α� ��Ͽ��� ����
    ��. �α� ��Ϲ�� ����
    ��. �α� �ۼ� ���ڼ� ����
    ��. �α� ��ϰ��� ����


<a name="policyview"><b>6. ��å����</b></a>
    ��å ����� ���� �����Ǿ� �ִ� ��å�� �����ݴϴ�.

    ��. Ʈ�� ������ ��å����
    ��. ���� ������ ��å����


<a name="backup"><b>7. �������</b></a>
    ��� ������ ���� �����Ǿ� �ִ� ��å�� ����Ͽ� �������� ���� ��ǻ�Ϳ� ������ �� �ֽ��ϴ�.

    ��. ��å���� ��������
    ��. ��å���� �ٿ�ε�

                                        </pre>
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
