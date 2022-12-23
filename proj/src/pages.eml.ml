open Types

let base title bdy =
  <html>
    <head>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
            integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
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

let navbar name =
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
      <span class="navbar-brand"><%s name %></span>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarText">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link" href="/">Voltar</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#">Adicionar</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#">Remover</a>
          </li>
        </ul>
        <span class="navbar-text">
          Gestão de Projetos UBI / Francisco Santos e Leonardo Santos
        </span>
      </div>
    </div>
  </nav>
    

let home = 
  <div class="container">
    <h1 class="title" style="text-align: center; padding: 30px">Gestão de Projetos UBI</h1>
    <nav>
      <ul class="options">
        <li><a href="/projetos">Projetos</a></li>
        <li><a href="/investigadores">Investigadores</a></li>
        <li><a href="/departamentos">Departamentos</a></li>
        <li><a href="#">Option 4</a></li>
        <li><a href="#">Option 5</a></li>
        <li><a href="#">Option 6</a></li>
      </ul>
    </nav>
  </div>


let projetos _lst =
  navbar "Projetos" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">First</th>
        </tr>
      </thead>
      <tbody class="table-group-divider"> 
        <% _lst |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/projetos/<%s x<|"id" %>'><%s x<|"name" %></a></td>
        </tr>
        <% end; %>
      </tbody>
    </table>
  </div>

let investigadores =
  navbar "Investigadores" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">First</th>
          <th scope="col">Last</th>
          <th scope="col">Handle</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <tr>
          <th scope="row">1</th>
          <td>Mark</td>
          <td>Otto</td>
          <td>@mdo</td>
        </tr>
        <tr>
          <th scope="row">2</th>
          <td>Jacob</td>
          <td>Thornton</td>
          <td>@fat</td>
        </tr>
        <tr>
          <th scope="row">3</th>
          <td>Larry</td>
          <td>The Bird</td>
          <td>@twitter</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="margin: 30px">
    <a href="/index.html" class="btn btn-outline-secondary" tabindex="-1" role="button" aria-disabled="true">
      Adicionar investigador
    </a>
  </div>


