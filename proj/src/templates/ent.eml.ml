let entidades =
  General.navbar_inpage "Entidades" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">First</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <tr>
          <th scope="row">1</th>
          <td><a href="./ent_template.html">Mark</a></td>
        </tr>
        <tr>
          <th scope="row">2</th>
          <td>Jacob</td>
        </tr>
        <tr>
          <th scope="row">3</th>
          <td>Larry</td>
        </tr>
      </tbody>
    </table>
  </div>

let ent_template =
  General.navbar_inpage "Entidades" ^
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

