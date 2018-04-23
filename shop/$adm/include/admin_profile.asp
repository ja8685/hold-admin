<% 
adminID = request.Cookies(admincheck)("adminID")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))    
   sql23="select deal_money from distributor3 where user_id='"&adminID&"'"              

if blnconnectionGameDB <> True then
    connectionGameDB("PNC")     
end if
    admin_gold = trim(Replace(GetString_List(sql23),RowDel,""))
    if admin_gold = "" then
        admin_gold = 0
    ELSE
        admin_gold = CDBL(admin_gold)        
    end if      

    %>
            <div class="profile clearfix">
              <div class="profile_pic">
                <img src="/$adm/images/img.jpg" alt="..." class="img-circle profile_img">
              </div>
              <div class="profile_info">
                  <h2><%=request.Cookies(admincheck)("adminAuth")%></h2>                
                <span>보유골드 : <b id="admin_rest_money" style="color:white"><%=formatnumber(admin_gold,0)%></b></span>
                
              </div>
            </div>