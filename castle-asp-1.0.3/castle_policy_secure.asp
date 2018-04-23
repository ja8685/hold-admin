<%

'//@UTF-8 castle_policy_secure.asp
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

' 인증없이 XML 소스 보기 방지

'If ("UTF-8" = Session("castle_site_charset") Or isEmpty(Session("castle_site_charset"))) then
'  Session.CodePage = 65001
'  Response.Charset = "UTF-8"
'else
  Session.CodePage = 949
  Response.Charset = "eucKR"
'end if

Dim HashedDataSe
Set HashedDataSe = CreateObject("CAPICOM.HashedData")

Dim CAPIUtilSe
Set CAPIUtilSe = Server.CreateObject("CAPICOM.Utilities")

Dim xmlSecure, root, element
Set xmlSecure = Server.CreateObject("Microsoft.XMLDOM")
'Set xmlSecure = Server.CreateObject("MSXML2.DOMDocument.3.0")
xmlSecure.async = "false"
Dim objFSse
Set objFSse = Server.CreateObject("Scripting.FileSystemObject")

Dim auth
Set auth = CreateObject("Scripting.Dictionary")

If (objFSse.FileExists(Server.MapPath("castle_policy.asp"))) Then

    xmlSecure.Load (Server.MapPath("castle_policy.asp"))

    If (xmlSecure.parseError.errorCode <> 0) Then
	    Response.Write "문서 로드중 에러가 발생하였습니다."
	    Response.End
    End If

    auth("user_id") = CAPIUtilse.Base64Decode(xmlSecure.GetElementsByTagName("ID")(0).firstChild.nodeValue)

End If

    auth("remote_addr") = Request.ServerVariables("REMOTE_ADDR")
    auth("key") = "castle_auth_token_" & auth("user_id")
    HashedDataSe.Algorithm = 4
    HashedDataSe.Hash(auth("remote_addr"))
    auth("value") = HashedDataSe.Value

If (Session(auth("key")) <> auth("value")) Then
%>
<script language="javascript">
    alert("정상적인 요청이 아닙니다.");
    parent.location.href="castle_admin_login.asp";
</script>
<%
    Set xmlSecure = nothing
    Set CAPIUtilSe = nothing
    
    Response.End
 
End If
%>