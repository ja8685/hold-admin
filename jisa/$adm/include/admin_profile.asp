<% 
adminID = request.Cookies(admincheck)("adminID")
IDAuth = cint(request.Cookies(admincheck)("IDAuth"))  
sql54="select deal_money from distributor15 where user_id='"&adminID&"'"    
if blnconnectionGameDB=False then
    connectionGameDB("PNC")
end if
admin_gold = trim(Replace(GetString_List(sql54),RowDel,""))
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
                   <h2>보유머니 : <br /><%=formatnumber(admin_gold,0) %>원</h2>               
              </div>
            </div>