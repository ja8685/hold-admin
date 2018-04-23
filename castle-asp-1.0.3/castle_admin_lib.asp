<% 

'//@UTF-8 castle_admin_lib.asp
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

On Error Resume Next

Dim libCAPIUtil
Set libCAPIUtil = Server.CreateObject("CAPICOM.Utilities")
Dim HashedData	' For HASH

' CAPICOM 등록 유/무 체크
If (hex(Err.Number) = "800401F3" Or hex(Err.Number) = "8007007E" Or hex(Err.Number) = "80029C4A") Then
	Response.Write("===== 서버 오브젝트 에러 ======<br><br>")
	Response.Write("capicom.dll을 등록하여 주세요.<br><br>")
	Response.Write("마이크로소프트웨어 홈페이지에서 다운로드 받을 수 있습니다.<br><br>")
	Response.Write("capicom.dll을 다운로드 받은 위치에서 cmd 창을 이용하여 등록해 줍니다.<br><br>")
	Response.Write("=== 등록법 ===<br>")
	Response.Write("> regsvr32 capicom.dll<br>")
	Response.Write("<script>if (confirm(""CAPICOM을 다운로드 할 수 있는 Microsoft 웹사이트로 이동합니다.""))")
	Response.Write("{location.href=""http://www.microsoft.com/downloads/details.aspx?displaylang=en&FamilyID=860EE43A-A843-462F-ABB5-FF88EA5896F6"";}")
	Response.Write("else {history.back();}</script>")
	Response.End
End If
   
Dim libxmlDoc
Set libxmlDoc = Server.CreateObject("Microsoft.XMLDOM")
'Set libxmlDoc = Server.CreateObject("MSXML2.DOMDocument.3.0")
libxmlDoc.async = "false"
Dim libobjFS
Set libobjFS = Server.CreateObject("Scripting.FileSystemObject")

Dim CASTLE_ADMIN_LIB_ASP, CASTLE_POLICY_ASP		'임시정의

If (isEmpty(CASTLE_ADMIN_LIB_ASP)) Then

	'/* _CASTLE_ADMIN_LIB_ASP_ routine */

	'/* 초기값 선언 */
	Dim CASTLE_BASE_MODULE_NAME, MAX_VAR_LENGTH, MAX_FILESIZE
	CASTLE_BASE_MODULE_NAME = "CASTLE 웹해킹방어도구 - ASP 버전"
	MAX_VAR_LENGTH = 65535
	MAX_FILESIZE = 209715200	'// 200MB

	'/* 세션 시작 */
	
	if Not(isEmpty(CASTLE_POLICY_ASP)) then
	
		'/* CASTLE 정책 파일 가져옴 */
		If (libobjFS.FileExists(Server.MapPath("castle_policy.asp"))) Then

			libxmlDoc.Load (Server.MapPath("castle_policy.asp"))

			If (libxmlDoc.parseError.errorCode <> 0) Then
				Response.Write "문서 로드중 에러가 발생하였습니다."
				Response.End
			End If

		End If
	
	end if

	'/* CASTLE 설치 여부 확인 */
	
	if (isEmpty(check_installed)) then
		castle_check_installed()
	else
		if Not(check_installed) then
			castle_check_installed()
		end if
	end if

	'/* CASTLE 인증 여부 확인 */
	
	if (isEmpty(check_authorized)) then
		castle_check_authorized()
	'else
	'	if Not(check_authorized) then
	'		castle_check_authorized()
	'	end if
	end if

	'/* End of _CASTLE_ADMIN_LIB_ASP_ */
End If

function castle_write_policy(libxmlDoc)

	'	/* 정책 파일 최종 수정 날짜 변경 */
	libxmlDoc.GetElementsByTagName("LASTMODIFIED")(0).text = libCAPIUtil.Base64Encode(Now())
	
	'	XML 형식으로 파일 저장
	libxmlDoc.save(Server.MapPath("castle_policy.asp"))
	Set libxmlDoc = nothing
	
	castle_write_policy = null
end function

function castle_policy_tree()

    Response.Write ("<IFRAME name=""castle_policy_tree"" "&_
                    " src=""castle_policy_tree.asp"" "&_
                    " width=""100%"" height=""1000"" " &_
                    " frameborder=""0""></IFRAME>")
    
    castle_policy_tree = null
end function

function castle_check_length(check_name, length, min, max)

	if (length < min) then
		html_msgback(check_name & ": 최소 " & min & "자 이상으로 설정하십시오.")
	end if

	if (length > max) then
		html_msgback(check_name & ": 최대 " & min & "자 이하로 설정하십시오.")
	end if

	castle_check_length = null
end function

function castle_print_error(error)

	Response.Write(error)
	
    castle_print_error(error)
end function

function castle_init_page()

	if Not(isEmpty(Application("page"))) Then
		Application.Contents.Remove("page")
	end if

	if Not(isEmpty(Application("print"))) Then
		Application.Contents.Remove("print")
	end if

	if Not(isEmpty(Application("submit"))) Then
		Application.Contents.Remove("submit")
	end if

	if Not(isEmpty(Application("poicy"))) Then
		Application.Contents.Remove("poicy")
	end if
    
    castle_init_page = null
end function

function castle_check_installed()

   	Set libobjFS = Server.CreateObject("Scripting.FileSystemObject")

	if Not(libobjFS.FileExists(Server.MapPath("castle_policy.asp"))) then
		html_msgmove "CASTLE 웹해킹방어도구이 설치되어 있지 않습니다.", "install.asp"
	end if

	castle_check_installed = null
end function

function castle_check_authorized()

'  If ("UTF-8" = Session("castle_site_charset") Or isEmpty(Session("castle_site_charset"))) then
'    Session.CodePage = 65001
'    Response.Charset = "UTF-8"
'  else
    Session.CodePage = 949
    Response.Charset = "eucKR"
'  end if

  Set HashedData = CreateObject("CAPICOM.HashedData")
  HashedData.Algorithm = 4 'CAPICOM_HASH_ALGORITHM_MD5
	Set libCAPIUtil = Server.CreateObject("CAPICOM.Utilities")
	Set libxmlDoc = Server.CreateObject("Microsoft.XMLDOM")
	'Set libxmlDoc = Server.CreateObject("MSXML2.DOMDocument.3.0")
	If (libobjFS.FileExists(Server.MapPath("castle_policy.asp"))) Then

		libxmlDoc.Load (Server.MapPath("castle_policy.asp"))

		If (libxmlDoc.parseError.errorCode <> 0) Then
			Response.Write "문서 로드중 에러가 발생하였습니다."
			Response.End
		End If

	End If

  Dim auth
  Set auth = CreateObject("Scripting.Dictionary")
	auth("remote_addr") = Request.ServerVariables("REMOTE_ADDR") 
	'auth("user_agent") = Request.ServerVariables("HTTP_USER_AGENT")
	auth("user_id") = libCAPIUtil.Base64Decode(libxmlDoc.GetElementsByTagName("ID")(0).firstChild.nodeValue)
	
	auth("key") = "castle_auth_token_" & auth("user_id")
	HashedData.Hash(auth("remote_addr"))
	auth("value") = HashedData.Value

	if (isEmpty(Session.Contents)) then
		html_msgmove "관리자 페이지 접근이 인증 되지 않습니다.", "castle_admin_login.asp"
    end if
    
	if (isEmpty(Session(auth("key")))) then
		html_msgmove "관리자 페이지 접근이 인증 되지 않습니다.", "castle_admin_login.asp"
	end if

	if (SESSION(auth("key")) <> auth("value")) then
		html_msgmove "관리자 페이지 접근이 인증 되지 않습니다.", "castle_admin_login.asp"
	end if

	castle_check_authorized = null
end function

function castle_check_submit()'key_array)
    
    Dim key_array
    key_array = Application.Contents("key_array")

	if (isEmpty(Application.Contents("key_array"))) then
		html_msgback "변수 입력에 문제가 발생하였습니다."
		exit function
	end if

	if Not(isArray(Application.Contents("key_array"))) then
	    exit function
	end if

	if Not(isArray(key_array)) then
	
	    if (isEmpty(Applicaton.Contents("key_array"))) then
		    html_msgback key_array & " 변수가 선언되지 않았습니다."
		end if
		
		exit function
	end if

	Dim key
    For Each key in key_array
        if (isEmpty(Application.Contents("key_array"))) then
		    html_msgback "submit("" "& key &" "")  변수가 선언되지 않았습니다."
	    end if
	Next
	Application.Contents.Remove("key_array")
	
	castle_check_submit = null
end function

function castle_clear_submit()

	if (isEmpty(Application("submit"))) then
		exit function
	end if

	if Not(isArray(Application("submit"))) Then
		Application.Contents.Remove("submit")
	end if

	for each key in Application.Contents("submit")
	    Application.Contents.Remove(submit(key))
	next

	castle_clear_submit = null
end function

function castle_file_download(filename, filepath, filesize)

    Dim user_agent
    user_agent = Request.ServerVariables("HTTP_USER_AGENT") 
   	Set libobjFS = Server.CreateObject("Scripting.FileSystemObject")
   	
    If Not(libobjFS.FileExists(filepath)) Then
		html_msgback "파일이 존재하지 않습니다."
	End If
	
	Dim libobjReg
	Set libobjReg = new regexp
	libobjReg.Pattern =  "(MSIE 5.0|MSIE 5.1|MSIE 6.0)"
	libobjReg.IgnoreCase = true

	if (libobjReg.Test(user_agent)) then
		Response.AddHeader "Cache-Control", "public"
		Response.AddHeader "Content-Disposition", "attachment; filename=" & filename & ";"
		Response.AddHeader "Content-type" , "application/x-force-download"
	else
			
		libobjReg.Pattern = "MSIE 5.5"		
		if (libobjReg.Test(user_agent)) then
			Response.AddHeader "Cache-Control", "no-store, no-cache, must-revalidate"
			Response.AddHeader "Cache-Control", "post-check=0, pre-check=0"
			Response.AddHeader "Pragma", "no-cache"
			Response.AddHeader "Content-Disposition", "inline; filename=" & filename & ";"
		else
			'Response.AddHeader "Pragma", "no-cache"
			Response.AddHeader "Cache-Control", "public"
			Response.AddHeader "Content-Disposition", "attachment; filename=" & filename & ";"
			Response.AddHeader "Content-type", "application/octet-stream"
		end if
	
	end if

	Response.Expires = 120
	'Response.ExpiresAbsolute = Now() - 1
	'Response.AddHeader "Expires", "0"
	Response.AddHeader "Last-Modified", now & " GMT"
	Response.AddHeader "Content-Length", filesize
	Response.AddHeader "Content-Transfer-Encoding", "binary"

    Dim objStream
    Set objStream = Server.CreateObject("ADODB.Stream")
    objStream.Open
    objStream.Type = 1
    objStream.LoadFromFile filepath
    
    Dim download
    download = objStream.Read
    Response.BinaryWrite download

    Set objStream = Nothing
	Set libobjReg = Nothing
	Set libobjFS = Nothing
	
	Response.End

	castle_file_download = null
end function

function castle_delete_directory_traverse(path)

    Dim libobjReg
    Set libobjReg = new regexp
	libobjReg.Global = true
	libobjReg.IgnoreCase = true
	
	'	// "/../" -> "/"
	libobjReg.Pattern = "/\.\./"
	while (libobjReg.Test(path))
	    path = libobjReg.Replace(path, "/")
	Wend
	
	'	// "./" -> ""
	libobjReg.Pattern = "\./"
	while (libobjReg.Test(path))
		path = libobjReg.Replace(path, "")
	Wend
	
	'	// "//" -> "/"
	libobjReg.Pattern = "//"
	while (libobjReg.Test(path)) 
		path = libobjReg.Replace(path, "/")
	Wend
	
	'	// "\..\" -> "\"
	libobjReg.Pattern = "\\\.\.\\"
	while (libobjReg.Test(path)) 
		path = libobjReg.Replace(path, "\")
	Wend
	
	'	// ".\" -> ""
	libobjReg.Pattern = "\.\\"
 	while (libobjReg.Test(path))
		path = libobjReg.Replace(path, "")
	Wend
	
	'	// "\\" -> "\"
	libobjReg.Pattern = "\\\\"
	while (libobjReg.Test(path)) 
		path = libobjReg.Replace(path, "\")
	Wend
	
	Set libobjReg = nothing
	
	castle_delete_directory_traverse = path
end function

function castle_charset_change(string)

     Dim site_charset
     
'    If (libobjFS.FileExists(Server.MapPath("castle_policy.asp"))) Then
'
'		libxmlDoc.Load (Server.MapPath("castle_policy.asp"))
'
'		If (libxmlDoc.parseError.errorCode <> 0) Then
'			Response.Write "문서 로드중 에러가 발생하였습니다."
'			Response.End
'		End If
'
'        libxmlDoc.async = "false"
'        
'	    '/* SITE 문자셋 설정에 따라 변환 */
'	    if (libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("CHARSET")(0).hasChildNodes) then
'           
'            if (libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue = "TRUE") then
'                site_charset = libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("UTF-8")(0).firstChild.nodeValue
'            else
'                site_charset = libxmlDoc.GetElementsByTagName("SITE")(0).GetElementsByTagName("eucKR")(0).firstChild.nodeValue
'            end if
'            
'        end if
'    
'    Else

        if Not(isEmpty(Session("castle_site_charset"))) then
                   
            site_charset = Session("castle_site_charset")
 
        end if
    
'    End If
        

'    Select Case Session("castle_site_charset")
'        Case "UTF-8"
'            Session.CodePage = 65001
'            Response.Charset = "UTF-8"
'        Case "eucKR"
'            Session.CodePage = 949
'            Response.Charset = "eucKR"
'    End Select
    
	castle_charset_change = string
end function
'/* CASTLE 관련 함수들 끝 */

'/* HTML 관련 함수들 */
function html_msg(msg) 

	'/* SITE 문자셋 설정에 따라 변환 */
	'msg = castle_charset_change(msg)

	Response.Write("<script language=""javascript"" " &_
		"codepage="" "& Session.CodePage & " "" charset="" "& Response.charset &" "">" &_
		"alert("" "& msg &" "");</script>")
        	
	html_msg = null
end function

function html_move(url)

    Dim target
    target = ""
    
	if (target <> "") then
		target = target & "./"
	end if

	Response.Write("<script language=""javascript"">location.href="" "& target & url &" ""; </script>")
    Response.End
    	
	html_move = null
end function

function html_close() 

	Response.Write("<script> window.close(); </script>")
	Response.End
    
    html_close = null
end function

function html_back() 

	Response.Write ("<script language=""javascript"">history.back(-1); </script>")
	Response.End

    html_back = null
end function

function html_msgmove(msg, url)

    Dim target
    target = "" 

	html_msg(msg)
	html_move(url)

    html_msgmove = null
end function

function html_msgback(msg) 

	html_msg(msg)
	html_back()

    html_msgback = null
end function

function html_msgclose(msg)

	html_msg(msg)
	html_close()

    html_msgclose = null
end function

'/* HTML 관련 함수들 끝 */

'/* End of castle_admin_lib.asp */
%>