<% 
adminID = request.Cookies(admincheck)("adminID")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))    
   select case IDAuth 
            case 99
            sql="select deal_money from patriot_distributor where user_id='"&adminID&"'"  
            case 0
            sql="select (user_money+user_save) from boss_distributor where user_id='"&adminID&"'"  
            case 1
            'sql="select (user_money+user_save) from users where user_id='"&adminID&"'"  
            sql="select deal_money from distributor1 where user_id='"&adminID&"'"              
            case 2
            sql="select (user_money+user_save) from users where user_id='"&adminID&"'"  
            case 3
            sql="select (user_money+user_save) from users where user_id='"&adminID&"'"  

  end select
if blnconnectionGameDB <> True then
    connectionGameDB("PNC")     
end if
    admin_gold = trim(Replace(GetString_List(sql),RowDel,""))
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