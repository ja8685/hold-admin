<%

'//@UTF-8 castle_admin_title.asp
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

'Dim libxmlDoc
Set libxmlDoc = Server.CreateObject("MSXML2.DOMDocument.3.0")
libxmlDoc.async = "false"
'Dim libobjFS
Set libobjFS = Server.CreateObject("Scripting.FileSystemObject")
If (libobjFS.FileExists(Server.MapPath("castle_policy.asp"))) Then

	libxmlDoc.Load (Server.MapPath("castle_policy.asp"))

	If (libxmlDoc.parseError.errorCode <> 0) Then
		Response.Write "���� �ε��� ������ �߻��Ͽ����ϴ�."
		Response.End
	End If

End If

Dim title
if Not(isEmpty(libxmlDoc.GetElementsByTagName("MODULE_NAME")(0).firstChild.nodeValue)) Then
  title = libxmlDoc.GetElementsByTagName("MODULE_NAME")(0).firstChild.nodeValue
else
  title = libCAPIUtil.Base64Encode(WSM_BASE_MODULE_NAME)
end if
  
title = libCAPIUtil.Base64Decode(title)

%>
<title>
  <%= title %>
</title>
