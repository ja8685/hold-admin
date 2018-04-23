
<table border="0"  cellpadding="0" cellspacing="0">
  <tr> 
    <td height="5"></td>
  </tr>
  <tr> 
    <td style="padding-left:5;padding-right:5"> 
      <table border="0" cellpadding=0 cellspacing=0 width="180" >
        <tr> 
          <td valign="top" style="padding-top:0"> 
            <table border="0"  cellpadding="0" cellspacing="0" width="95%"  background="../images/left_center.gif">
              <tr height=30> 
                <td> 
                  <table border="0" cellpadding="0" cellspacing="0" background="../images/left_top.gif" height="34" width="170">
                    <Tr> 
                      <td valign="bottom"> 
                        <table border="0" cellpadding="0" cellspacing="0">
                          <Tr> 
                            <td style="padding-left:35;padding-bottom:5"><b><font color="#ffffff">관리자 아이디 관리</font></b></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td height="10"></td>
              </tr>
              <tr> 
                <td> 
                  <table border="0" cellpadding="0" cellspacing="0" width=100%>
                    <tr> 
                      <td style="padding-left:10" height="25"> 
                        <table border="0" cellpadding="0" cellspacing="0">
                          <Tr> 
                            <td align="center"><img src="../images/left_icon.gif" border="0" hspace="3"></td>
                            <td align="center" style="padding-left:5"><a href="/$adm/login/chagePass.asp"> 
                              비밀번호 변경</a></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
<%
	if Request.Cookies(admincheck)("IDAuth") > 0 then 
%>
              <tr> 
                <td> 
                  <table border="0" cellpadding="0" cellspacing="0" width=100%>
                    <tr> 
                      <td style="padding-left:10" height="25"> 
                        <table border="0" cellpadding="0" cellspacing="0">
                          <Tr> 
                            <td align="center"><img src="../images/left_icon.gif" border="0" hspace="3"></td>
                            <td align="center" style="padding-left:5"><a href="/$adm/login/MainIDList.asp"> 
                              관리자 아이디 관리</a></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
<%
	end if
%>
							<tr> 
                <td style="padding-top:10"><img src="../images/left_bottom.gif" border="0" hspace="0"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
