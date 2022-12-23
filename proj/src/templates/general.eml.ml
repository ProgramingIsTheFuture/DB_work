let navbar_home name =
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
      <span class="navbar-brand"><%s name %></span>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarText">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link" href="javascript:history.back()">Voltar</a>
          </li>
        </ul>
        <span class="navbar-text">
          Gestão de Projetos UBI / Francisco Santos e Leonardo Santos
        </span>
      </div>
    </div>
  </nav>

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

let navbar_inpage name =
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
      <span class="navbar-brand"><%s name %></span>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarText">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link" href="javascript:history.back()">Voltar</a>
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
    
let inves_template =
  navbar_inpage "Investigadores" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1>Investigador Nome</h1>
    <h4>Pertence a: Nome Instituto</h4>
    <p style="margin-bottom: 2rem;"></p>

    <p>Idade:</p>
    <p>Morada:</p>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="top-left2" style="position: absolute; top: 12em; left: 39em;">
    <h2 style="margin-bottom: 1rem;">Unidades de Investigação</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <th scope="row">1</th>
            <td>Unidade 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Unidade 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Unidade 3</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="centre" style="position: absolute; top: 12em; left: 78em;">
    <h2 style="margin-bottom: 1rem;">Projetos</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
            <th scope="col">Papel</th>
            <th scope="col">Tempo (%)</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <th scope="row">1</th>
            <td>Projeto 1</td>
            <td>Papel I1</td>
            <td>%1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Projeto 2</td>
            <td>Papel I2</td>
            <td>%2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Projeto 3</td>
            <td>Papel I3</td>
            <td>%3</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="centre" style="position: absolute; top: 12em; left: 120em;">
    <h2>Classificação</h2>
    <p style="margin-bottom: 2rem;"></p>
    PLACEHOLDER
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href="/index.html" class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>



