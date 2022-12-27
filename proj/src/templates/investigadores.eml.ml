open Types

let investigadores (invs: data list) = 
  General.navbar_home "Investigadores" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Nome</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <% invs |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/investigadores/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
        </tr>
        <% end; %>
      </tbody>
    </table>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="margin: 30px">
    <a href="/index.html" class="btn btn-outline-secondary" tabindex="-1" role="button" aria-disabled="true">
      Adicionar investigador
    </a>
  </div>


let investigador (invs: data) unidades projetos =
  General.navbar_inpage "Investigador" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1><%s invs <| "nome" %></h1>
    <h4>Pertence a: <%s invs <| "instituto" %></h4>
    <p style="margin-bottom: 2rem;"></p>

    <h5 style="color: #2895bd">Idade:</h5>
    <p><%s invs <| "idade" %></p>
    <h5 style="color: #2895bd">Morada::</h5>
    <p><%s invs <| "morada" %></p>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="top-left2" style="position: absolute; top: 14em; left: 39em;">
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
          <% unidades |> List.iter begin fun x -> %>
          <tr>
            <th scope="row"><%s x <| "id" %></th>
            <td><%s x <| "nome" %></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="centre" style="position: absolute; top: 14em; left: 78em;">
    <h2 style="margin-bottom: 1rem;">Projetos</h2>
    <div style="width: 30rem" ;>
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
          <% projetos |> List.iter begin fun x -> %>
          <tr>
            <th scope="row"><%s x <| "id" %></th>
            <td><a href='/projetos/<%s x<|"id" %>'><%s x<|"nome"%></td>
            <td><%s x <| "designacao" %></td>
            <td><%s x <| "tempoPerc" %></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="centre" style="position: absolute; top: 14em; left: 120em;">
    <h2>Classificação</h2>
    <p style="margin-bottom: 2rem;"></p>
    PLACEHOLDER
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href="/index.html" class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>

