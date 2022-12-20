(*open Users
*
*let home usrlist = 
*  <html>
 *   <body>
  *    <% usrlist |> List.iter begin fun user -> %>
   *   <p>User <%s user.name %> with Id = <%s user.id |> string_of_int %> </p>
    *<% end; %> 
    *</body>
*  </html> *)


let home= 
<head>
  <link rel="stylesheet" href="/static/assets/style.css">
  <title>Gestão de Projetos UBI</title>
</head>

<body>
  <div class="container">
    <h1 class="title" style="text-align: center; padding: 30px">Gestão de Projetos UBI</h1>
    <nav>
      <ul class="options">
        <li><a href="/projetos.html">Projetos</a></li>
        <li><a href="/investigadores.html">Investigadores</a></li>
        <li><a href="/departamentos.html">Departamentos</a></li>
        <li><a href="#">Option 4</a></li>
        <li><a href="#">Option 5</a></li>
        <li><a href="#">Option 6</a></li>
      </ul>
    </nav>
  </div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css"></script>
</body>

</html>
