<% 

'//@UTF-8 castle_admin_log.asp
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
        <script language="javascript">
          <!--
      function log_delete_submit(log_filename)
      {
        ret = confirm("삭제하시겠습니까?");
        if (!ret)
          return;
        location.href = 'castle_admin_log_submit.asp?mode=LOG_DELETE&log_filename='+log_filename;  
      }
    //-->
        </script>
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
                      <table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
                        <tr valign="top">
                          <td width="100%">
                            <table width="100%" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr height="100%">
                                <td width="9"><img src="img/menu_top_lt.gif"></td>
                                <td width="100%" background="img/menu_top_bg.gif">
                                  <font color="#C0C0C0"><li><b>로그관리</b> - CASTLE 로그 관리합니다.</font>
                                </td>
                                <td width="8"><img src="img/menu_top_rt.gif"></td>
                              </tr>
                            </table>
                            <table width="100%" cellspacing="10" cellpadding="0" border="0">
                              <tr>
                                <td width="100%" style="line-height:160%" nowrap="">
                                  <li>
                                    <b>알림: 로그는 수시로 파일 용량을 확인하시고 백업 받으시길 바랍니다.</b>
                                    <br>
                                    </td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr>
                                <td width="2"></td>
                                <td height="100%" bgcolor="#B0B0B0" align="center">
                                  <b>
                                    <font color="#FFFFFF">CASTLE 로그설정</font>
                                  </b>
                                </td>
                                <td width="2"></td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
<%
'/* 로그 정보 수정 폼 시작 */

	'// 로그 정보 설정 변수 설정
Dim print
Set policy = createObject("Scripting.Dictionary")
Set print = createObject("Scripting.Dictionary")

policy("log_bool") = "FALSE"
policy("log_filename") = ""
policy("log_simple") = ""
policy("log_detail") = ""
policy("log_list_count") = ""
policy("log_charset_utf8") = ""
policy("log_charset_euckr") = ""

if Not(isEmpty(libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue)) then
	policy("log_bool") = libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("BOOL")(0).firstChild.nodeValue
end if

if Not(isEmpty(libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("FILENAME")(0).firstChild.nodeValue)) then
	policy("log_filename") = libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("FILENAME")(0).firstChild.nodeValue
end if

if Not(isEmpty(libxmlDoc.GetElementsByTagName("SIMPLE")(0).firstChild.nodeValue)) then
	policy("log_simple") = libxmlDoc.GetElementsByTagName("SIMPLE")(0).firstChild.nodeValue
end if

if Not(isEmpty(libxmlDoc.GetElementsByTagName("DETAIL")(0).firstChild.nodeValue)) then
	policy("log_detail") = libxmlDoc.GetElementsByTagName("DETAIL")(0).firstChild.nodeValue
end if

if Not(isEmpty(libxmlDoc.GetElementsByTagName("LIST_COUNT")(0).firstChild.nodeValue)) then
	policy("log_list_count") = libxmlDoc.GetElementsByTagName("LIST_COUNT")(0).firstChild.nodeValue
end if

if Not(isEmpty(libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue)) then
	policy("log_charset_utf8") = libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue
end if

if Not(isEmpty(libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("eucKR")(0).firstChild.nodeValue)) then
	policy("log_charset_euckr") = libxmlDoc.GetElementsByTagName("LOG")(0).GetElementsByTagName("eucKR")(0).firstChild.nodeValue
end if

print("log_filename") = libCAPIUtil.Base64Decode(policy("log_filename"))
print("log_bool_true_check") = ""
print("log_bool_false_check") = ""
print("log_simple_check") = ""
print("log_detail_check") = ""
print("log_charset_utf8_check") = ""
print("log_charset_euckr_check") = ""

if (libCAPIUtil.Base64Decode(policy("log_bool")) = "TRUE") then
	print("log_bool_true_check") = "checked"
else
	print("log_bool_false_check") = "checked"
end if

if (libCAPIUtil.Base64Decode(policy("log_simple")) = "TRUE") then
	print("log_simple_check") = "checked"
else
	print("log_detail_check") = "checked"
end if

if (libCAPIUtil.Base64Decode(policy("log_charset_utf8")) = "TRUE") then
	print("log_charset_utf8_check") = "checked"
else
  if (libCAPIUtil.Base64Decode(policy("log_charset_euckr")) = "TRUE") then
	  print("log_charset_euckr_check") = "checked"
  end if
end if

print("log_list_count") = libCAPIUtil.Base64Decode(policy("log_list_count"))
%>
                            <table cellspacing="2" cellpadding="5" border="0">
                              <form action="castle_admin_log_submit.asp?mode=LOG_MODIFY" method="post">
                               <!-- <tr>
                                  <th width="150" height="30" bgcolor="#D8D8D8" align="right">로그 파일이름</th>
                                  <td width="475">
                                    <input type="text" name="log_filename" size="48" maxlength="64" value="<%= print("log_filename") %>">
                                  </td>
                                </tr>
                                <tr>
                                  <td></td>
                                  <td>
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          "log/Year.Month.Day-로그파일이름"에 기록됩니다.<br>
                                            (ex. log/20071016-castle_log.txt)
                                          </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>-->
                                <tr>
                                  <th width="150" height="30" bgcolor="#D8D8D8" align="right">로그 기록여부</th>
                                  <td>
                                    <input type="radio" name="log_bool" value="true" 
                                      <%= print("log_bool_true_check") %>>기록
                                      <input type="radio" name="log_bool" value="false" 
                                        <%= print("log_bool_false_check") %>>무기록
                                      </td>
                                </tr>
                                <tr>
                                  <td></td>
                                  <td>
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            기록(logging) - 웹해킹방어도구 기록을 남김(기본).
                                            <li>
                                              무기록(none) - 웹해킹방어도구 기록을 남기지 않음.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="150" height="30" bgcolor="#D8D8D8" align="right">로그 기록방식</th>
                                  <td>
                                    <input type="radio" name="log_mode" value="simple" 
                                      <%= print("log_simple_check") %>>간략
                                      <input type="radio" name="log_mode" value="detail" 
                                        <%= print("log_detail_check") %>>상세
                                      </td>
                                </tr>
                                <tr>
                                  <td></td>
                                  <td>
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            간략(simple) - 웹해킹방어도구 기록을 간략히 남김(기본).<br>
                                              &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                              (REMOTE_ADDR - [Date] REQUEST_URL: Message)
                                              <li>
                                                상세(detail) - 웹해킹방어도구 기록을 상세히 남김.<br>
                                                  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                                  (REMOTE_ADDR - [Date] REQUEST_URL: Message: ...)
                                                </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="150" height="30" bgcolor="#D8D8D8" align="right">로그 문자셋</th>
                                  <td>
                                    <input type="radio" name="log_charset" value="UTF-8" 
                                      <%= print("log_charset_utf8_check") %>>UTF-8(기본)
                                      <input type="radio" name="log_charset" value="eucKR" 
                                        <%= print("log_charset_euckr_check") %>>eucKR
                                        </td>
                                </tr>
                                <tr>
                                  <td></td>
                                  <td>
                                    <table width="100%" height="50" cellspacing="1" cellpadding="10" border="0" bgcolor="#000000">
                                      <tr>
                                        <td bgcolor="#FFFFFF" style="line-height:120%" nowrap="">
                                          <li>
                                            UTF-8 - 로그 기록을 UTF-8로 하는 경우(기본).
                                            <li>
                                              eucKR - 로그 기록을 eucKR로 하는 경우.
                                            </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr>
                                  <th width="150" height="30" bgcolor="#D8D8D8" align="right">로그 목록개수</th>
                                  <td>
                                    <input type="text" name="log_list_count" value="<%= print("log_list_count") %>">
                                    </td>
                                </tr>
                              </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="475" height="50" cellspacing="0" cellpadding="0" border="0">
                              <tr valign="top">
                                <td width="175">&nbsp;</td>
                                <td width="300">
                                  <a href="#">
                                    <input type="image" src="img/button_confirm.gif" >
                                  </a>
                                  <input type="image" src="img/button_cancel.gif" onclick="reset(); return false;">
                                    </a>
                                  </td>
                              </tr>
                              </form>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" height="25" cellspacing="0" cellpadding="0" border="0">
                              <tr>
                                <td width="2"></td>
                                <td height="100%" bgcolor="#B0B0B0" align="center">
                                  <b>
                                    <font color="#FFFFFF">CASTLE 로그목록</font>
                                  </b>
                                </td>
                                <td width="2"></td>
                              </tr>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" cellspacing="2" cellpadding="5" border="0">
                              <tr height="30">
                                <th width="80" bgcolor="#D8D8D8">번호</th>
                                <th width="370" bgcolor="#D8D8D8">로그파일</th>
                                <th width="100" bgcolor="#D8D8D8">파일크기</th>
                                <th width="200" bgcolor="#D8D8D8">최근시간</th>
                                <th width="50" bgcolor="#D8D8D8">삭제</th>
                              </tr>
                              <%
                              
'/* 로그 파일 목록 출력 시작 */
Dim log
Set log = createObject("Scripting.Dictionary")
                                
log("dirname") = "./log"

Dim fso
Set fso = Server.CreateObject("Scripting.FileSystemObject")
'/* 로그 디렉토리 유무 판단 및 생성 */
if (fso.FolderExists(Server.MapPath(log("dirname"))) <> True) then
	fso.CreateFolder(Server.MapPath(log("dirname")))
end if

	'// 로그 디렉터리 목록 가져오기                         
if (fso.FolderExists(Server.MapPath(log("dirname")))) then

  Dim objFolder
  set objFolder = fso.GetFolder(Server.MapPath(log("dirname")))
	
	if (isObject(objFolder)) then

    Dim objReg, logfilename, log_array, logs, logcount
	  Set logs = createObject("Scripting.Dictionary")
    Set objReg = new regexp  'Create the RegExp object
    objReg.Pattern = print("log_filename")
    logcount = 0
    
    For each logfilename in objFolder.files
    '// 로그 관련 파일만 출력
      if (objReg.Test(logfilename)) then
                                
        Dim objFile
        Set objFile = fso.GetFile(logfilename)
        log_array = array(objFile.Name, FormatNumber(objFile.Size, 0,-1,0,-1), _
                          FormatDateTime(objFile.DateLastModified, 0))
        
        logs("log" & logcount) = log_array
        logcount = logcount + 1
                               
      end if
 
    next

    Set objFile = nothing
		
  end if
    
  Set fso = nothing

end if

		'// 로그 목록 정렬
'	krsort($logs);

		'// 로그 출력
Dim i
print("log_total_count") = logs.count

for i = 1 to print("log_total_count")

  print("log_num") = i                                
  print("filename") = logs("log" & logcount - i)(0)
  print("filesize") = logs("log" & logcount - i)(1)
  print("filemtime") = logs("log" & logcount - i)(2)

%>
                              <tr height="25" bgcolor="#FFFFFF">
                                <td align="center">
                                  <%= print("log_num") %>
                                </td>
                                <td align="center">
                                  <table>
                                    <tr>
                                      <td>
                                        <a href="castle_admin_download.asp?filename=<%= print("filename") %>&filepath=./log/<%= print("filename") %>">
                                          <%= print("filename") %>
                                        </a>
                                      </td>
                                      <td>
                                        <a href="castle_admin_download.asp?filename=<%= print("filename") %>&filepath=./log/<%= print("filename") %>">
                                          <img src="img/button_download.gif" border="0">
                                        </a>
                                      </td>
                                    </tr>
                                  </table>
                                  <td align="center">
                                    <%= print("filesize") %> Bytes
                                  </td>
                                  <td align="center">
                                    <%= print("filemtime") %>
                                  </td>
                                  <td align="center">
                                    <input type="image" src="img/button_delete.jpg" onclick="log_delete_submit('<%= print("filename") %>'); return false;">
                                  </td>
                                </tr>
                              <%
'/* 로그 파일 목록 출력 시작 */
next
%>
                            </table>
                            <table width="800" height="1">
                              <tr>
                                <td width="100%" height="100%" background="img/line_bg.gif"></td>
                              </tr>
                            </table>
                            <table width="800" height="40">
                              <tr>
                                <td width="100%" height="100%" align="center">
                                  <b>
                                    <%= print("log_total_count") %>
                                  </b> 개가 기록되었습니다.
                                </td>
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
