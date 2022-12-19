open Users

let home usrlist = 
  <html>
    <body>
      <% usrlist |> List.iter begin fun user -> %>
      <p>User <%s user.name %> with Id = <%s user.id |> string_of_int %> </p>
    <% end; %> 
    </body>
  </html>
