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


let base title bdy =
  <html>
    <head>
      <link rel="stylesheet" href="/assets/style.css">
      <title><%s title %></title>
    </head>
    <body>
      <div id="root">
      </div>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css"></script>
      <script>
        const pagehtml = `<%s bdy %>`;
        const ConvertStringToHTML = function (str) {
         let parser = new DOMParser();
         let doc = parser.parseFromString(str, 'text/html');
         return doc.body;
        };
        const page = ConvertStringToHTML(pagehtml);
        document.getElementById("root").append(ConvertStringToHTML(page.childNodes[0].data));
      </script>
    </body>
  </html>

let home = 
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
