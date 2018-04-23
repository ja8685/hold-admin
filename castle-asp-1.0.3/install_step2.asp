<% 

'//@UTF-8 install_step2.asp
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
Session.CodePage = 949
Response.Charset = "eucKR"

'/* 인증 및 설치 검사 예외 페이지 */
Dim check_installed, check_authorized
check_installed = TRUE
check_authorized = TRUE

%>
<!--#include file="castle_admin_lib.asp"-->
<%

  '  /* 설치 여부 판단 */
Dim objFS
Set objFS = Server.CreateObject("Scripting.FileSystemObject")
If (objFS.FileExists(Server.MapPath("castle_policy.asp"))) Then
  html_msgmove "CASTLE 웹해킹방어도구 - ASP 버전이 이미 설치되어 있습니다.", "castle_admin.asp"
End If
Set objFS = Nothing

if (isEmpty(Session("castle_install"))) then
	html_msgmove "install.asp 설치 초기 페이지로 접근하십시오.", "install.asp"
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=eucKR">
      <link rel="StyleSheet" HREF="style.css" type="text/css" title="style">
        <title>CASTLE 웹해킹방어도구 - 설치 2단계</title>
      </head>
  <body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" bgcolor="#D0D0D0">
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
                  <form name="step2" action="install_step2_submit.asp" method="post">
                    <table width="600" cellspacing="1" cellpadding="20" border="0" bgcolor="#000000"
                      <tr>
                        <td width="100%" bgcolor="#FFFFFF" style="line-height:160%" nowrap="">
                          <li>
                            <b>CASTLE 웹해킹방어도구 문자셋(charset) 환경을 설정합니다.</b>
                            <br>
                              <br>
                                <b>UTF-8</b>: 서버 및 웹 페이지 설정이 UTF-8인 경우<br>
                                  <b>eucKR</b>: 서버 및 웹 페이지 설정이 eucKR인 경우(기본)<br>
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
                                  <font color="#404040">문자셋</font>
                                </b>
                              </td>
                              <td width="200" colspan="3" bgcolor="#FFFFFF">
                                <input type="radio" name="site_charset" value="UTF-8">
                                  UTF-8
                                  <input type="radio" name="site_charset" value="eucKR" checked="">
                                    eucKR
                                  </td>
                            </tr>
                          </table>
                          <br>
                            <br>
                              <b>
                                <font color="red">※ 주의: 문자셋이 잘못 설정되어 있는 경우 글자가 깨질 수 있습니다.</font>
                              </b>
                              <br>
                                <br>
                                </center>
                        <table width="100%" height="1">
                          <tr>
                            <td width="100%" height="100%" background="img/line_bg.gif"></td>
                          </tr>
                        </table>
                        <input type="submit" value="다음 단계로(Next).." class="submit" style="height:20px;">
                        </form>
                </td>
              </tr>
            </table>
          </center>
        </body>
</html>