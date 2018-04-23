<%
    Function GetRSArray(strSQL)
        Set objRS = GameDBconn.Execute(strSQL)
        If Not objRS.EOF Then arrRS = objRS.GetRows()
        Set objRS = Nothing
        GetRSArray = arrRS
    End Function

	Function GetString_List(strSQL)
		Dim Rs, Cmd
    	Set Rs = GameDBconn.Execute(strSQL)
	
		if Rs.EOF then
			Result = ""
		else
			Result = Rs.GetString(adClipString,,ColDel,RowDel,"") ' Rs.GetString(adClipString,레코드의수,컬럼구분자,레코드구분자,Null대체문자) 
		end if
		Rs.close
        		
		Set Rs = nothing
		GetString_List = Result
	End Function 

	Function GetString_List_member(strSQL)
		Dim Rs, Cmd
    	Set Rs = DBconn.Execute(strSQL)
	
		if Rs.EOF then
			Result = ""
		else
			Result = Rs.GetString(adClipString,,ColDel,RowDel,"") ' Rs.GetString(adClipString,레코드의수,컬럼구분자,레코드구분자,Null대체문자) 
		end if
		Rs.close
        		
		Set Rs = nothing
		GetString_List_member = Result
	End Function

	Function CommandExec(strSQL)
		Set Cmd = Server.CreateObject("ADODB.Command")
		With Cmd
			.ActiveConnection = DBconn
			.CommandType = adCmdtext	
			.CommandText = strSQL
			.Execute
		End With
		Cmd.ActiveConnection = nothing
		Set Cmd = nothing
	End Function

	Function CheckWord(CheckValue)
		CheckValue = replace(CheckValue, "&" , "&amp;")
		CheckValue = replace(CheckValue, "<", "&lt;")
		CheckValue = replace(CheckValue, ">", "&gt;")
		CheckValue = replace(CheckValue, "'", "''")
		CheckWord = CheckValue
	End Function

	Function Str_Limit(str,limit_count)
		''' 제목 길이제한 (한글, 영문처리)'''
		nLen = 0
		tmpStr = str
		str = ""
		for j = 1 to len(tmpStr)
			if (asc(mid(tmpStr, j, 1)) < 0) or (asc(mid(tmpStr, j, 1)) > 255) then
				nLen = nLen + 2
			else
				nLen = nLen + 1
			end if
				if nLen > limit_count then
				str = str & ".."
				Exit for
			end if
			str = str & (mid(tmpStr, j, 1))
		next
		Str_Limit = str
	End Function

	Function Keyword_TitleStress(Str,keyword)
		Str = Replace(Str,keyword,"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&keyword&"</b></span>") '검색시
		Str = Replace(Str,Lcase(keyword),"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&Lcase(keyword)&"</b></span>") '검색시
		Str = Replace(Str,Ucase(keyword),"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&Ucase(keyword)&"</b></span>") '검색시
		Str = Replace(Str,Replace(keyword," ",""),"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&Replace(keyword," ","")&"</b></span>") '검색시
		Keyword_TitleStress = Str
	End Function

	Function Keyword_ContentsStress(Str,keyword)
				Str = Replace(Str,keyword,"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&keyword&"</b></span>") '검색시
				Str = Replace(Str,Lcase(keyword),"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&Lcase(keyword)&"</b></span>") '검색시
				Str = Replace(Str,Ucase(keyword),"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&Ucase(keyword)&"</b></span>") '검색시
				Str = Replace(Str,Replace(keyword," ",""),"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&Replace(keyword," ","")&"</b></span>") '검색시
				Str = Replace(Str,Replace(keyword," ","&nbsp;"),"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&Replace(keyword," ","&nbsp;")&"</b></span>") '검색시
				keyword = Replace(keyword,"&nbsp;"," ")
				sp_keyword = split(keyword," ") '검색어 분리시
				for j = 0 to UBound(sp_keyword)
					Str = Replace(Str,sp_keyword(j),"<span style='color:#0000CC;background-color:#FDF3EE;'><b>"&sp_keyword(j)&"</b></span>") '검색시
				next
				Keyword_ContentsStress = Str
	End Function

	Function Str_Len(str)
		'''문자 길이 (한글, 영문처리)'''
		nLen = 0
		tmpStr = str
		for j = 1 to len(tmpStr)
			if (asc(mid(tmpStr, j, 1)) < 0) or (asc(mid(tmpStr, j, 1)) > 255) then
				nLen = nLen + 2
			else
				nLen = nLen + 1
			end if
		next
		Str_Len = nLen
	End Function

	Function IsKorean(str)
		''' 한글/ 영문 구분'''
		tmpStr = str
		for j = 1 to len(tmpStr)
			if (asc(mid(tmpStr, j, 1)) < 0) or (asc(mid(tmpStr, j, 1)) > 255) then
				IsKorean = true
				exit for
			else
				IsKorean = false
			end if
		next
	End Function

	Function FileType(filename)
	  Dim fso
	  Set fso = CreateObject("Scripting.FileSystemObject")
	  GetAnExtension = fso.GetExtensionName(filename)
		Set fso = nothing
		'Response.Write GetAnExtension
		Select case Lcase(GetAnExtension)
			case "jpg","gif","bmp","png"
				FileType = "IMAGE"
			case "html","htm"
				FileType = "HTML"
			case "exe"
				FileType = "EXE"
			case "zip","alz"
				FileType = "ZIP"
			case else
				FileType = UCase(GetAnExtension)
		End Select
	End Function

	Function FileExtension(filename)
	  Dim fso
	  Set fso = CreateObject("Scripting.FileSystemObject")
	  GetAnExtension = fso.GetExtensionName(filename)
		Set fso = nothing
		FileExtension = LCase(GetAnExtension)
	End Function

	Function DeleteFile(filepath,filename)
	  Dim fso, file, filespec
		fileurl = filepath & "/" & filename
	  filespec = Server.MapPath(fileurl)
	  Set fso = CreateObject("Scripting.FileSystemObject")
	  If (fso.FileExists(filespec)) Then
			fso.DeleteFile(filespec)
	  Else
			Exit Function 
	  End if
	End Function

	REM 정규식을 이용한 HTML 태그 제거 =================================================
	Function StripTags( htmlDoc )
		Dim Rex

		set Rex = new Regexp

		Rex.Pattern= "<[^>]+>"

		Rex.Global=true

		StripTags = Rex.Replace(htmlDoc,"")

	End Function

	REM 정규식을 이용한 검색엔진 도메인 여부 확인 =================================================
	Private Function isSearchEngine(DomainString,SearchString)
		Dim regEx, Pattern
		Set regEx = New RegExp
		regEx.Pattern = SearchString
		regEx.Global = False
		regEx.IgnoreCase = True
		isSearchEngine = regEx.Test(DomainString)
	End Function

	'================== 정규식을 이용한 Search 함수 =================================================
	Function RegExpSearch(str,SearchString)
		'First, create a reg exp object
		Dim objRegExp
		Set objRegExp = New RegExp

		objRegExp.IgnoreCase = True '//대소문자 구분 여부(True:구분안함, False:구분함)
		objRegExp.Global = True '//전체 문서에서 검색
		objRegExp.Pattern = SearchString '//패턴 설정

		'Display all of the matches
		Dim objMatch
		
		For Each objMatch in objRegExp.Execute(str)
			'Response.Write objMatch.Value & "<BR>"
			RegExpSearch = objMatch.Value
		Next
	End Function	

	'================== 검색엔진 한글표시 함수 =================================================
	Function SearchEngineDisplay(str,SearchString)
		Select case RegExpSearch(str,SearchString)
			case "naver.com"
				SearchEngineDisplay = "네이버"
			case "nate.com"
				SearchEngineDisplay = "네이트닷컴"
			case "yahoo.co.kr","yahoo.com"
				SearchEngineDisplay = "야후코리아"
			case "empas.com"
				SearchEngineDisplay = "엠파스"
			case "google.co.kr","google.com"
				SearchEngineDisplay = "구글"
			case "korea.com"
				SearchEngineDisplay = "코리아닷컴"
			case "hanmir.com"
				SearchEngineDisplay = "한미르"
			case "dreamwiz.com"
				SearchEngineDisplay = "드림위즈"
			case "netian.com"
				SearchEngineDisplay = "네띠앙"
			case "hitel.net"
				SearchEngineDisplay = "하이텔"
			case "chol.com"
				SearchEngineDisplay = "천리안"
			case "msn.co.kr"
				SearchEngineDisplay = "MSN"
			case "freechal.com"
				SearchEngineDisplay = "프리첼"
			case "altavista.com"
				SearchEngineDisplay = "ALTAVISTA"
			case else
				SearchEngineDisplay = "기타"
		End Select
	End Function	

	Function RandomVal(var)
		'============================= 난수 발생 (0 ~ 9999) ======================
		Dim k, random_value
		Randomize
		random_value = Int((var * Rnd) + 1)
		'============================= 난수 발생 끝=================================
		for k = 1 to len(var) - len(random_value)
			random_value = "0" & random_value
		next
		RandomVal = random_value
	End Function 

Function URLDecode(Expression)

 Dim strSource, strTemp, strResult, strchr
 Dim lngPos, AddNum, IFKor
 strSource = Replace(Expression, "+", " ")

 For lngPos = 1 To Len(strSource)
  AddNum = 2
  strTemp = Mid(strSource, lngPos, 1)
  If strTemp = "%" Then
   If lngPos + AddNum < Len(strSource) + 1 Then
    strchr = CInt("&H" & Mid(strSource, lngPos + 1, AddNum))
    If strchr > 130 Then 
     AddNum = 5
     IFKor  = Mid(strSource, lngPos + 1, AddNum)
     IFKor  = Replace(IFKor, "%", "")
     strchr = CInt("&H" & IFKor )
    End If
    strResult = strResult & Chr(strchr)
    lngPos = lngPos + AddNum
   End If
  Else
   strResult = strResult & strTemp
  End If
 Next

 URLDecode = strResult

End Function   


	REM 본사리스트.........
	Function Display_Menu()
		strSQL = "select F_BUBONID, F_NAME from AX_BUBONLIST order by F_IDX desc"
		Rs.Open strSQL, DBconn, adOpenForwardOnly, adLockReadOnly
		SelectMenu = ""
		Do While not Rs.EOF
			SelectMenu = SelectMenu & "<OPTION VALUE='" & Rs("F_BUBONID") & "'"
			if f_bubonid_key = Rs("F_BUBONID") then SelectMenu = SelectMenu & " selected"
			SelectMenu = SelectMenu & ">"&Rs("F_NAME")&"</OPTION>"
			Rs.MoveNext
		Loop
		Rs.close
		Display_Menu =  SelectMenu
	End Function

	REM 입력될 rank를 리턴하는 함수.........
	Function GETRank(maxfiled, tbl, wherefiled, valuefiled)
		IF wherefiled<>"" THEN
			RE_SQL = "SELECT MAX("&maxfiled&")+1 as INCatrank FROM "&tbl&" WHERE "&wherefiled&"='"&valuefiled&"' "
		ELSE
			RE_SQL = "SELECT MAX("&maxfiled&")+1 as INCatrank FROM "&tbl&" " 
		END IF
		SET rs_rank = DBconn.Execute(RE_SQL)
			IF IsNull(rs_rank("INCatrank")) THEN
				rank_tmp=1
			ELSE
				rank_tmp=CINT(rs_rank("INCatrank"))
			END IF
		SET rs_rank=NOTHING
		GETRank = rank_tmp
	End Function

	''==================================================================================================
	'' 문자열을 길이만큼 리턴
	''==================================================================================================
	Function HanLeftDel(fcValue,fcLimit)
		Dim fcLen, fcCount, fcRtnStr
		fcLen = len(fcValue)
		fcCount = 0
		fcRtnStr = ""

		Dim fcI
		For fcI = 1 To fcLen
			If Asc(Mid(fcValue,fcI,1)) < 0 Then
				fcCount = fcCount + 2
			Else
				fcCount = fcCount + 1
			End If

			If fcCount = fcLimit Then
				fcRtnStr = mid(fcValue,1,fcI)
				HanLeftDel = fcRtnStr & ".."
				Exit Function
			ElseIf fcCount = (fcLimit + 1) Then
				fcRtnStr = mid(fcValue,1,fcI-1)
				HanLeftDel = fcRtnStr & ".."
				Exit Function
			End If
		Next

	  fcRtnStr = fcValue
	  HanLeftDel = fcRtnStr
	End Function

	''==================================================================================================
	'' 문자열 변환
	''==================================================================================================
	Function checkvalue(fcKind,fcValue)
	  fcValue = Rtrim(fcValue)

	  If isnull(fcValue) Then
		fcValue = ""
	  ElseIf fcValue = "" Then

	  ElseIf fcKind = 1 Then				'' 입력값을 DB에 저장할때
		fcValue = replace(fcValue,"'","`")
		fcValue = replace(fcValue,"&nbsp;&nbsp;",chr(32)+chr(32))
		fcValue = replace(fcValue,"--","-[@]-")

	  ElseIf fcKind = 2 Then				'' DB에서 불러와 입력폼에 뿌릴때
		fcValue = replace(fcValue,"`","'")
		fcValue = replace(fcValue,chr(34),"&quot;")
		fcValue = replace(fcValue,"-[@]-","--")

	  ElseIf fcKind = 3 Then				'' DB에서 불러와 HTML에 뿌릴때 (태그 허용안함)
		fcValue = replace(fcValue,"`","'")
		fcValue = replace(fcValue,"-[@]-","--")
		fcValue = replace(fcValue,"<","&lt;")
		fcValue = replace(fcValue,">","&gt;")
		fcValue = replace(fcValue,"&","&amp;")
		fcValue = replace(fcValue,chr(13),"<br>")
		fcValue = replace(fcValue,chr(34),"&quot;")
		fcValue = replace(fcValue,chr(32)+chr(32),"&nbsp;&nbsp;")

	  ElseIf fcKind = 4 Then				'' DB에서 불러와 HTML에 뿌릴때 (태그 허용함)
		fcValue = replace(fcValue,"`","'")
		fcValue = replace(fcValue,"-[@]-","--")
		fcValue = replace(fcValue,chr(13),"<br>")
		fcValue = replace(fcValue,chr(32)+chr(32),"&nbsp;&nbsp;")

	  End If
	  
	  checkvalue = fcValue
	End Function

	''==================================================================================================
	'' 숫자값 체크
	''==================================================================================================
	Function isDigit(fcIn)
		Dim fcI, rtnBool

		If fcIn = "" Then
			rtnBool = false
		Else
			rtnBool = True

			For fcI = 1 To Len(fcIn)
				If Asc(Mid(fcIn,fcI,1)) < 48 Or Asc(Mid(fcIn,fcI,1)) > 57 Then
					rtnBool = false
				End If
			Next
		End If

		isDigit = rtnBool
	End Function

	''==================================================================================================
	'' 비밀번호 인코딩
	''==================================================================================================
	FUNCTION codePass(strin)
		dim strout, strLen, tempout

		if strin = "" then
			strout = "[::]"
		else
			tempout = "[:"
			strLen = len(strin)
			for i = 1 to strLen
				tempout = tempout & asc(mid(strin,i,1))
			next

			strout = tempout & ":]"
		end if

		codePass = strout
	END Function

	FUNCTION deCodePass(strin)
		dim strout, strLen, tempout

		if strin = "" then
			strout = ""
		Else
			strin = Replace(strin,"[:","")
			strin = Replace(strin,":]","")

			strLen = len(strin)

			for i = 1 to strLen - 1 step 2
				strout = strout & chr(mid(strin,i,2))
			next

		end if

		deCodePass = strout
	END Function

	''==================================================================================================
	'' 비밀번호 생성
	''==================================================================================================
	Function makePass()
		Dim fcLnegth, fcI, fcRtnStr
		fcRtnStr = ""

		Randomize
		fcLength = Int((5 * Rnd) + 6)

		For fcI = 1 To fcLength
			Randomize
			fcAscii = Int((10 * Rnd) + 48)
			fcRtnStr = fcRtnStr & chr(fcAscii)
		Next

		makePass = fcRtnStr
	End Function

Const gcKEY = "!@#007game#@!"

Public Function Encrypt(Message)
    Dim ed, key
    key = gcKEY

    Set ed = CreateObject("CAPICOM.EncryptedData")
    ed.Content = Message
    ed.SetSecret key
    Encrypt = ed.Encrypt
    Set ed = Nothing
End Function

Public Function Decrypt(EncMessage)
    Dim ed, key

    key = gcKEY
    Set ed = CreateObject("CAPICOM.EncryptedData")

    ed.SetSecret key
    ed.Decrypt EncMessage
    Decrypt = ed.Content

    Set ed = Nothing
End Function 

Function putZero(obj)

             If CInt(obj) < 10 Then 

                           putZero = "0" & obj

             Else 

                           putZero = obj

             End If 

End Function
Function Board_pagecount(go_url,opt_str)'{
%>
     <div class="row">
        <div class="btn-toolbar">
        <div class="btn-group">
<%
	'이전페이지
	if startpage > 1 then									
				
		s_page = startpage - page_list
		p_page = s_page - 1        
        pre_str = "<button class='btn btn-info' type='button' onclick='document.location.href="""&go_url&"?page="&p_page&"&startpage="&s_page&opt_str&"""'>◀</button>"
	else							
	
		pre_str =  "" 
	end if
	
	response.write pre_str
	'이전페이지 끝

	'페이지 출력
	curpage   = startpage 
	limitpage = startpage + page_list

	for curpage = cint(startpage) to cint(limitpage-1) 
			
		if curpage > totalpage then
			exit for
		end if
										
		now_str =  "<a href='"&go_url&"?page="&curpage&"&startpage="&startpage&opt_str&"'>"

		if cint(curpage) = cint(page) then 			 
            response.write now_str & "<button class='btn btn-info active' type='button'>"& curpage &"</button></a>"
		else
			 response.write now_str & "<button class='btn btn-info' type='button'>"& curpage &"</button></a>"
		end if

	next
	'페이지 출력 끝

	'다음페이지 시작
	lastpage = startpage + page_list 
	if  lastpage-1 < totalpage then
	
			s_page = startpage + page_list
			n_page = s_page - 1
																
			next_str = " <a href='"&go_url&"?page="&n_page&"&startpage="&s_page&opt_str&"'>" 
            next_str = next_str & "<button class='btn btn-info' type='button'>▶</button></a>"			
	
	else
			next_str =  ""
	end if

	response.write next_str
	'다음페이지 끝
%>
       </div>
    </div>
</div>
<%
End Function '}
FUNCTION GetResultFromURL(Xurl)

	Dim RStr
	Dim xmlHttp

	SET xmlHttp = Server.CreateObject("Microsoft.XMLHTTP")
	xmlHttp.open "GET", Xurl, False
	xmlHttp.setRequestHeader "Content-Type","text/xml"
	xmlHttp.setRequestHeader "Accept-Language","ko"
	xmlHttp.send
    
	if xmlHttp.status = 200 then
		RStr = xmlHttp.responseText
	Else
		RStr = "get_fail"
	End if

	SET xmlHttp = Nothing

	GetResultFromURL = RStr

END Function

Function UserDegree(obj)
	Select case obj
		case "0"
			UserDegree = "F"
		case "1"
			UserDegree = "E"
		case "2"
			UserDegree = "D"
		case "3"
			UserDegree = "C"
		case "4"
			UserDegree = "B"
		case "5"
			UserDegree = "A"
		case "6"
			UserDegree = "S"
		case else
			UserDegree = "-"
	End Select
End Function

%>
<% Sub Msg_Box(Msg,Focus,RtnURL,Target) %>
<SCRIPT LANGUAGE="JavaScript">
<!--
	alert("<%=Msg%>");
<% if Focus <> "" then %>
	<%=Focus%>.focus();
	<%=Focus%>.select();
<% End if %>
//-->
</SCRIPT>
<% 
	if RtnURL <> "" then call returnURL(RtnURL,Target)
	Response.End
%>
<% End Sub %>

<% Sub returnURL(RtnURL,Target) %>
<SCRIPT LANGUAGE="JavaScript">
<!--
	<%=Target%>.location.href = "<%=RtnURL%>";
//-->
</SCRIPT>
<% End Sub %>
