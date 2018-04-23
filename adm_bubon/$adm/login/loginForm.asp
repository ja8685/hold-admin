<!-- #include virtual="/$adm/include/Config.asp" -->
<!-- #include virtual="/$adm/include/Function.asp" -->
<%Session.Codepage=65001 

	LOGINID = Request.Cookies(admincheck)("adminID")  
	id_save = Request.Cookies(savecheck)("id_save")  

	'return_url = "/default.asp"
	return_url = Request("return_url")
	if return_url = "" then
		RTNURL = Request("HTTP_REFERER")
	else
		RTNURL = return_url
	end if

	'Response.Write Request.ServerVariables("HTTP_REFERER")

	'Response.Write "LOGINID=" & LOGINID & "<BR>"
	'Response.Write "LOGINPW=" & LOGINPW & "<BR>"
	'Response.Write "id_save=" & id_save & "<BR>"

	If id_save = "" then 
		OnLoad = "document.loginfrm.LOGINID.focus()"
	Else
		OnLoad = "document.loginfrm.LOGINPW.focus()"
	End if
    str = server.HTMLEncode(encrypt("gubun=0"))
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title><%=AdminTitle%></title>

    <!-- Bootstrap -->
    <link href="/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- NProgress -->
    <link href="/vendors/nprogress/nprogress.css" rel="stylesheet">
    <!-- Animate.css -->
    <link href="/vendors/animate.css/animate.min.css" rel="stylesheet">

    <!-- Custom Theme Style -->
    <link href="/build/css/custom.min.css" rel="stylesheet">
<script>
<!--
	function submitForm()
	{
		var frm = eval(document.loginfrm);

		if(frm.LOGINID.value == "")
		{
			alert("관리자 아이디를 입력해주세요.");
			frm.LOGINID.focus();
			return false;
		}
		if(frm.LOGINPW.value == "")
		{
			alert("관리자 비밀번호를 입력해주세요.");
			frm.LOGINPW.focus();
			return false;
		}

		return true;
	}

	function master_chk() {
	    var frm = eval(document.loginfrm);

	    if (frm.LOGINID.value == "") {
	        alert("관리자 아이디를 입력해주세요.");
	        frm.LOGINID.focus();
	        return;
	    }
	    if (frm.LOGINPW.value == "") {
	        alert("관리자 비밀번호를 입력해주세요.");
	        frm.LOGINPW.focus();
	        return;
	    }
	    //btnEncryptData_onclick();
	   // frm.submit();

	    
	}
	function patriot_chk() {
	    var frm = eval(document.loginfrm);

	    if (frm.LOGINID.value == "") {
	        alert("관리자 아이디를 입력해주세요.");
	        frm.LOGINID.focus();
	        return;
	    }
	    if (frm.LOGINPW.value == "") {
	        alert("관리자 비밀번호를 입력해주세요.");
	        frm.LOGINPW.focus();
	        return;
	    }
	  //  btnEncryptData_onclick();
	    frm.action = "loginProc.asp?gubun=99";
	   // frm.submit();

	}

	function bonsa_chk() {
	    var frm = eval(document.loginfrm);

	    if (frm.LOGINID.value == "") {
	        alert("관리자 아이디를 입력해주세요.");
	        frm.LOGINID.focus();
	        return;
	    }
	    if (frm.LOGINPW.value == "") {
	        alert("관리자 비밀번호를 입력해주세요.");
	        frm.LOGINPW.focus();
	        return;
	    }
	   // btnEncryptData_onclick();
	    frm.action = "loginProc.asp?gubun=15";
	    frm.submit();


	}
	function chongpan_chk() {
	    var frm = eval(document.loginfrm);

	    if (frm.LOGINID.value == "") {
	        alert("관리자 아이디를 입력해주세요.");
	        frm.LOGINID.focus();
	        return;
	    }
	    if (frm.LOGINPW.value == "") {
	        alert("관리자 비밀번호를 입력해주세요.");
	        frm.LOGINPW.focus();
	        return;
	    }
	    //btnEncryptData_onclick();
	    frm.action = "loginProc.asp?gubun=2";
	    frm.submit();


	}
	function shop_chk() {
	    var frm = eval(document.loginfrm);

	    if (frm.LOGINID.value == "") {
	        alert("관리자 아이디를 입력해주세요.");
	        frm.LOGINID.focus();
	        return;
	    }
	    if (frm.LOGINPW.value == "") {
	        alert("관리자 비밀번호를 입력해주세요.");
	        frm.LOGINPW.focus();
	        return;
	    }
	   // btnEncryptData_onclick();
	    frm.action = "loginProc.asp?gubun=3";
	    frm.submit();


	}
	function search_enter_check(e) {
		var t = document.loginfrm;
		if (e.keyCode==13) {
		    bonsa_chk();
		}
	}

	function resetForm()
	{
		history.back();
		//document.loginfrm.LOGINID.value = "";
		//document.loginfrm.LOGINPW.value = "";
		//document.loginfrm.LOGINID.focus();
	}
//-->
</script>
  </head>

  <body class="login" onLoad="<%=OnLoad%>">
    <div>
      <a class="hiddenanchor" id="signup"></a>
      <a class="hiddenanchor" id="signin"></a>

      <div class="login_wrapper">
        <div class="animate form login_form">
          <section class="login_content">
            <FORM method="post" name="loginfrm" target="pFrame" action="loginProc.asp" onSubmit="return submitForm()">
                <input type=hidden name=returl value="<%=RTNURL%>">
              <h3><%=AdminTitle%></h3>
                <p>&nbsp;</p>
              <div>
                <input type="text" class="form-control" placeholder="아이디" onFocus="this.select()"  name="LOGINID" value="<%=id_save%>" required="" />
              </div>
              <div>
                <input type="password" class="form-control" name="LOGINPW"  onkeypress="search_enter_check(event)" onFocus="this.select()" placeholder="Password" required="" />
              </div>
                <a class="btn btn-default submit" href="javascript:bonsa_chk()">Log in</a>
              <div>
                <input type="checkbox" name="id_save" <% if id_save <> "" then %>checked <% end if %> value="yes">아이디 저장
              </div>

              <div class="clearfix"></div>

              <div class="separator">
                <div class="clearfix"></div>
                <br />

                <div>
                  <p>©2017 All Rights Reserved.</p>
                </div>
              </div>
            </form>
          </section>
        </div>

        <div id="register" class="animate form registration_form">
          <section class="login_content">
            <form>
              <h1>Create Account</h1>
              <div>
                <input type="text" class="form-control" placeholder="Username" required="" />
              </div>
              <div>
                <input type="email" class="form-control" placeholder="Email" required="" />
              </div>
              <div>
                <input type="password" class="form-control" placeholder="Password" required="" />
              </div>
              <div>
                <a class="btn btn-default submit" href="index.html">Submit</a>
              </div>

              <div class="clearfix"></div>

              <div class="separator">
                <p class="change_link">Already a member ?
                  <a href="#signin" class="to_register"> Log in </a>
                </p>

                <div class="clearfix"></div>
                <br />

                <div>
                  <h1><i class="fa fa-paw"></i> Gentelella Alela!</h1>
                  <p>©2016 All Rights Reserved. Gentelella Alela! is a Bootstrap 3 template. Privacy and Terms</p>
                </div>
              </div>
            </form>
          </section>
        </div>
      </div>
    </div>
<SCRIPT LANGUAGE=javascript>
<!--
<% if id_save = "" then %>
   document.loginfrm.LOGINID.focus();
<% else %>
   document.loginfrm.LOGINPW.focus();
<% end if %>
//-->
</SCRIPT>
<!-- 처리폼 -->
<iframe name="pFrame" frameborder="0" border="0" width="0" height="0"></iframe> 
  </body>
</html>
