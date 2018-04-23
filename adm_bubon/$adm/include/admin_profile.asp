<% 
adminID = request.Cookies(admincheck)("adminID")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))  


    %>
            <div class="profile clearfix">
              <div class="profile_pic">
                <img src="/$adm/images/img.jpg" alt="..." class="img-circle profile_img">
              </div>
              <div class="profile_info">
               <h2><%=request.Cookies(admincheck)("adminAuth")%></h2>                
              </div>
            </div>