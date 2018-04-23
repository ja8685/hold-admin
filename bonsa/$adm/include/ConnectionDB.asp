<%
'==================웹 방화벽 Castle 적용 코드 =====================================
Application("CASTLE_ASP_VERSION_BASE_DIR")="/castle"
Server.Execute(Application("CASTLE_ASP_VERSION_BASE_DIR")&"/castle_referee.asp")
'==================웹 방화벽 Castle 적용 코드 끝 =====================================    
    %>
<!--METADATA TYPE="typelib" NAME="ADODB Type Library" UUID="00000205-0000-0010-8000-00AA006D2EA4" -->
<OBJECT RUNAT="Server" PROGID="ADODB.Connection" ID="DBconn"></OBJECT>
<OBJECT RUNAT="Server" PROGID="ADODB.Connection" ID="GameDBconn"></OBJECT>
<OBJECT RUNAT="Server" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>
<%

	'RecordSet Column,Row 구분자
	Const ColDel="；"
	Const RowDel="¶"
    Const Constring = "Provider=SQLOLEDB;Data Source=10.10.10.126;Initial Catalog=NGame;user ID=NGame3;password=sn9162(!^@;"
	'DB 연결여부변수. CloseDB 에서 DB연결이 되었는지 확인하기 위해 사용.
	Dim blnconnectionDB

	blnconnectionDB = false
    blnconnectionGameDB = false

	DBconn.CommandTimeOut = 60 'DB연결시간 설정(초단위)
    
            
    
	Sub connectionDB(Database)
		if blnconnectionDB = false then
			DBconn.open "Provider=SQLOLEDB;Data Source=10.10.10.126;Initial Catalog=NGame;user ID=NGame3;password=sn9162(!^@;"
			blnconnectionDB = true
		end if
	End Sub


	Sub closeDB()
		if blnconnectionDB = true then
			if IsObject(DBconn) and DBconn.State = 1 then
				DBconn.close
			end if  
			blnconnectionDB = false
		end if
	End Sub

   	Sub connectionGameDB(Database)
    GameDBconn.ConnectionTimeout=300
		if blnconnectionGameDB = false then            
            GameDBconn.open "Provider=SQLOLEDB;Data Source=10.10.10.126;Initial Catalog=NGame;user ID=NGame3;password=sn9162(!^@;"            
			blnconnectionGameDB = true
		end if
	End Sub


	Sub closeGameDB()
		if blnconnectionGameDB = true then
			if IsObject(GameDBconn) and GameDBconn.State = 1 then
				GameDBconn.close
			end if  
			blnconnectionGameDB = false
		end if
    	If IsObject(DBHelper) Then
		    DBHelper.Dispose
		    Set DBHelper = Nothing
	    End If
	End Sub
%>