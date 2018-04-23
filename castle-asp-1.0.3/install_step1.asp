<% 

'//@UTF-8 install_step1.asp
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
    <meta http-equiv="""=Content-Type" content="text/html; charset=eucKR">
      <link rel="StyleSheet" HREF="style.css" type="text/css" title="style">
        <title>CASTLE 웹해킹방어도구 - 설치 1단계</title>
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
                            <li>CASTLE 웹해킹방어도구 설치를 위하여 <font color="red">
                              <b>IIS 인터넷 정보 서비스(MMC)</b></font>를 이용하여</br>
                              <font color="red"><b>가상 디렉터리 탭</b></font>을 선택하십시오.</br>
                              디렉터리의 권한을 <font color="red"><b>읽기</b></font>로 설정하십시오.</br>
                              실행 권한은 <font color="red"><b>스크립트 전용</b></font>으로 설정하십시오.</br>
                              <br>
                            </li>
                            <li>윈도우 탐색기에서 설치할 디렉터리의 등록정보를 열어서 <font color="red"><b>보안 탭</b></font>을 선택하십시오.</br>
                              <font color="red"><b>인터넷 게스트 계정</b></font>을 추가하고 사용 권한에서 <font color="red"><b>쓰기</b></font>를 추가하십시오.</br>
                            </li>
                          </OL>
                          <UL type="dot">
                            <li>CASTLE 웹해킹방어도구 설치 디렉터리 <%= Server.MapPath("./")%></li>
                            <li>./log 디렉터리 <%= Server.MapPath("./log")%></li>
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
                        <input type="button" value="다음 단계로(Next).." class="submit" style="height:20px;" onclick="return nextstep();">
                        </form>
                </td>
              </tr>
            </table>
          </center>
        </body>
</html>