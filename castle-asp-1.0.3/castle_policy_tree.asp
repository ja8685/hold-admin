<%

'//@UTF-8 castle_policy_tree.asp
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

' �������� XML �ҽ� ���� ����
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