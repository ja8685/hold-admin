
CASTLE - ASP 버전 
------------

1. CASTLE을 적용하려면 아래와 같이 하십시오.

   각 페이지 첫줄에 

<% '// CASTLE - KISA Web Attack Defense Tool
Application("CASTLE_ASP_VERSION_BASE_DIR") = "CASTLE 설치 경로"
Server.Execute(Application("CASTLE_ASP_VERSION_BASE_DIR") & "/castle_referee.asp")
%>

   위의 네줄을 추가하시면 됩니다.

   특히 주의해야할 것은 ROOT 이후의 경로를 적으셔야 합니다.
   ex) IIS의 ROOT 폴더가 "C:/inet_pub/"이고 
       C:/inet_pub/castle-jsp/ 에 CASTLE을 설치할 경우

<% '// CASTLE - KISA Web Attack Defense Tool
Application("CASTLE_ASP_VERSION_BASE_DIR") = "/castle-asp"
Server.Execute(Application("CASTLE_ASP_VERSION_BASE_DIR") & "/castle_referee.asp")
%>

   위와 같이 추가하시면 됩니다.

   위에 대한 자세한 설명은 http://www.krcert.or.kr 홈페이지에서 확인하실 수 있습니다.
   
   감사합니다.

   - CASTLE 운영팀 - 
