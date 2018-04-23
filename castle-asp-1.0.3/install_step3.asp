<% 

'//@UTF-8 install_step3.asp
'/*
'  * Castle: KISA Web Attack Defender - ASP Version
' * 
' * Author : 안중호 <hackeran@hotmail.com>
' *          이재서 <mirr1004@gmail.com>
' *          주필환 <juluxer@gmail.com>
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

if (isEmpty(Session("castle_site_charset"))) then
	html_msgmove "Charset이 설정되지 않았습니다.", "install_step2.asp"
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=eucKR">
      <link rel="StyleSheet" HREF="style.css" type="text/css" title="style">
        <title>CASTLE 웹해킹방어도구 - 설치 3단계</title>
      </head>
  <body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" bgcolor="#D0D0D0">
    <script language="javascript">
      function nextstep() {
      var len = document.step2.admin_id.value.length;
      if (len == 0) {
        alert("관리자 아이디가 입력되지 않았습니다.");
        document.step2.admin_id.focus();
      return;
      }
      len = document.step2.admin_password.value.length;
      if (len == 0) {
        alert("관리자 암호가 입력되지 않았습니다.");
        document.step2.admin_password.focus();
      return;
      }
      len = document.step2.admin_repassword.value.length;
      if (len == 0) {
        alert("관리자 확인암호가 입력되지 않았습니다.");
        document.step2.admin_repassword.focus();
      return;
      }
      if (document.step2.admin_password.value != document.step2.admin_repassword.value) {
        alert("암호와 확인 암호가 같지 않습니다.");
        document.step2.admin_repassword.focus();
      return;
      }

    	len = document.step2.log_filename.value.length;
      if (len == 0) {
        alert("로그 파일이름이 입력되지 않았습니다.");
        document.step2.log_filename.focus();
        return;
      }
			if (document.step2.log_filename.value == 'castle_log.txt') {
		          alert("로그 파일이름을 변경하여 주십시오.");
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
                            <b>CASTLE 관리자 계정을 생성하고 로그 파일이름을 설정합니다.</b>
                            <br>
                              <br>
                                ※ 알림1: 아이디는 최소 4자 이상이며 최대 16자 이하입니다.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 디폴트아이디(admininstartor, admin등) 사용금지.<br>
                                  ※ 알림2: 아이디와 동일한 암호는 사용할 수 없습니다.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;암호는 최소 8자 이상이며 최대 32자 이하입니다.<br>
                                  ※ 알림3: 로그 파일이름을 변경하시길 바랍니다.<br>
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
                                  <font color="#404040">관리자 아이디</font>
                                </b>
                              </td>
                              <td width="200" colspan="3" bgcolor="#FFFFFF">
                                <input type="text" name="admin_id" size="24">
                              </td>
                            </tr>
                            <tr height="30">
                              <td width="100" bgcolor="#C0C0C0" align="right">
                                <b>
                                  <font color="#404040">암호</font>
                                </b>
                              </td>
                              <td width="200" bgcolor="#FFFFFF">
                                <input type="password" name="admin_password" size="24">
                              </td>
                            </tr>
                            <tr height="30">
                              <td width="100" bgcolor="#C0C0C0" align="right">
                                <b>
                                  <font color="#404040">암호확인</font>
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
                                <font color="red">※ 주의: 관리자 계정 정보는 암호 찾기 기능이 존재하지 않으므로 반드시 기억하셔야 합니다.</font>
                              </b>
                              <br><br>
                           
	                        <table width="300" cellspacing="1" cellpadding="5" border="0" bgcolor="#808080">
							            	<tr height="30">
							              	<td width="100" bgcolor="#C0C0C0" align="right"><b><font color="#404040">로그 파일이름</font></b></td>
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
                        <input type="button" value="설치 완료하기(Finish).." class="submit" style="height:20px;" onclick="return nextstep();">
                        </form>
                </td>
              </tr>
            </table>
          </center>
        </body>
</html>