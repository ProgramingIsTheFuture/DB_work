open Types

let projetos_contratos _lst =
  General.navbar_inpage "Projetos / Contratos" ^
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

let proj_template (_proj: data) =
  General.navbar_inpage "Projetos" ^
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


