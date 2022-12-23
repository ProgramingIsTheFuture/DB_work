

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
            <a class="nav-link" href="javascript:history.back()">Voltar</a>
          </li>
        </ul>
        <span class="navbar-text">
          Gestão de Projetos UBI / Francisco Santos e Leonardo Santos
        </span>
      </div>
    </div>
  </nav>


let proj_template =
  navbar "Projetos" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1>Projeto Nome</h1>
    <h5>Descrição</h5>

    <p style="margin-bottom: 2rem;"></p>
    <p>Título:</p>
    <p>Português:</p>
    <p>Inglês:</p>
    <p>Data de Início:</p>
    <p>Data de Fim:</p>
    <p>URL:</p>
    <p>Digital Object Identifier:</p>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Keywords</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Keywords</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <th scope="row">1</th>
            <td>Keyword 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Keyword 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Keyword 3</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Publicações</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
            <th scope="col">URL</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <th scope="row">1</th>
            <td>Pub1</td>
            <td>www.publicacao1.com/publicacao</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Pub2</td>
            <td>www.publicacao2.com/publicacao</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Pub3</td>
            <td>www.publicacao3.com/publicacao</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <div class="top-left2" style="position: absolute; top: 12em; left: 39em;">
    <h2 style="margin-bottom: 1rem;">Investigadores</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
            <th scope="col">Papel</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <th scope="row">1</th>
            <td>Investigador 1</td>
            <td>Papel I1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Investigador 2</td>
            <td>Papel I2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Investigador 3</td>
            <td>Papel I3</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Domínios Cientificos</h2>
    PLACEHOLDER
  </div>

  <div class="centre" style="position: absolute; top: 12em; left: 78em;">
    <h2 style="margin-bottom: 1rem;">Contrato Associado</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">IDCont</th>
            <th scope="col">Nome</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <td>x</td>
            <td>Nome Contrato</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Entidades Financiadoras</h2>
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
            <td>Entidade 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Entidade 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Entidade 3</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Programas</h2>
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
            <td>Programa 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Programa 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Programa 3</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <div class="centre" style="position: absolute; top: 12em; left: 120em;">
    <h2 style="margin-bottom: 1rem;">Estados</h2>
    <h4>Atual</h4>
    <p>Designação:</p>
    <p>Data:</p>
    <h4>Histórico:</h4>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Status</th>
            <th scope="col">Data</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <th scope="row">1</th>
            <td>Status1</td>
            <td>dd/mm/yyyy</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Status2</td>
            <td>dd/mm/yyyy</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Status3</td>
            <td>dd/mm/yyyy</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>

    <h2>Classificação</h2>
    <p style="margin-bottom: 2rem;"></p>
    PLACEHOLDER
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href="/index.html" class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>


let cont_template =
  navbar "Contratos" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1>Contrato Nome</h1>
    <h5>Descrição</h5>

    <p style="margin-bottom: 2rem;"></p>
    <p>Título:</p>
    <p>Data de Início:</p>
    <p>Data de Fim:</p>
    <p style="margin-bottom: 2rem;"></p>

  </div>

  <div class="top-left2" style="position: absolute; top: 12em; left: 39em;">
    <h2 style="margin-bottom: 1rem;">Projeto Associado</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">IDProj</th>
            <th scope="col">Nome</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <td>x</td>
            <td>Nome Projeto</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Investigadores Envolvidos</h2>
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
            <td>Investigador 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Investigador 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Investigador 3</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <div class="centre" style="position: absolute; top: 12em; left: 78em;">
    <h2 style="margin-bottom: 1rem;">Entidades F. Envolvidas</h2>
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
            <td>Entidade 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Entidade 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Entidade 3</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="centre" style="position: absolute; top: 12em; left: 122em;">
    <h2 style="margin-bottom: 1rem;">Estados</h2>
    <h4>Atual</h4>
    <p>Designação:</p>
    <p>Data:</p>
    <h4>Histórico:</h4>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Status</th>
            <th scope="col">Data</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <tr>
            <th scope="row">1</th>
            <td>Status1</td>
            <td>dd/mm/yyyy</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Status2</td>
            <td>dd/mm/yyyy</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Status3</td>
            <td>dd/mm/yyyy</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href="/index.html" class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>


let inves_template =
  navbar "Investigadores" ^
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


let inst_template = 
  navbar "Institutos" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1>Instituto Nome</h1>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Docentes</h2>
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
            <td>Docente 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Docente 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Docente 3</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href="/index.html" class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>

let ent_template =
  navbar "Entidades" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1>Entidade Nome</h1>
    <h5>Descrição</h5>
    <p style="margin-bottom: 3rem;"></p>

    <p>Designação:</p>
    <p>Email:</p>
    <p>Telemovel:</p>
    <p>Morada:</p>
    <p>País:</p>
    <p>Nacional:</p>
    <p></p>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="top-left2" style="position: absolute; top: 12em; left: 39em;">
    <h2 style="margin-bottom: 1rem;">Programas</h2>
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
            <td>Programa 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Programa 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Programa 3</td>
          </tr>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="centre" style="position: absolute; top: 12em; left: 78em;">
    <h2 style="margin-bottom: 1rem;">Projetos Financiados</h2>
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
            <td>Projeto 1</td>
          </tr>
          <tr>
            <th scope="row">2</th>
            <td>Projeto 2</td>
          </tr>
          <tr>
            <th scope="row">3</th>
            <td>Projeto 3</td>
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

