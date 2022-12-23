
let cont_template =
  General.navbar_inpage "Contratos" ^
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


