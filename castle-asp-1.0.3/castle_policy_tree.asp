<%

'//@UTF-8 castle_policy_tree.asp
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
%>
<!--#include file="castle_policy_secure.asp"-->
<%
Response.ContentType = "text/xml"
Session.CodePage = 65001
Response.CharSet = "UTF-8"

'xmlDoc.removeChild(xmlDoc.childnodes(1))
xmlSecure.removeChild(xmlSecure.childnodes(1))

For Each element in xmlSecure.GetElementsByTagName("*") 'xmlDoc.GetElementsByTagName("*")

	if (element.hasChildNodes = true And element.firstChild.nodeTypeString = "text") then
		element.text = CAPIUtilSe.Base64Decode(element.text)
	end if
	 	
Next

Response.Write xmlSecure.xml 'xmlDoc.xml

Set element = nothing
Set xmlSecure = nothing 'xmlDoc = nothing
Set CAPIUtilSe = nothing

Response.End
%>