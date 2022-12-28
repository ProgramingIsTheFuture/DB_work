
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
        </ul>
        <span class="navbar-text">
          Gestão de Projetos UBI / Francisco Santos e Leonardo Santos
        </span>
      </div>
    </div>
  </nav>



