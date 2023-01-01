open Types

let areas lst area =
  General.navbar_home "Áreas Científicas" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Áreas Cienfíficas</th>
        </tr>
      </thead>
      <tbody class="table-group-divider"> 
        <% lst |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/dominios/<%s x<|"id" %>'><%s x<|"designacao" %></a></td>
        </tr>
        <% end; %>
      </tbody>
    </table>

    <p style="margin-bottom: 2rem;"></p>
    <h5 style="color: #2895bd">Área com mais projetos:</h5>
    <p><%s area |> List.hd <| "designacao" %></p>
  </div>

let area (area: data list) dom projs =
  General.navbar_inpage "Programa" ^
  <div class="left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <% area |> List.hd |> begin fun x -> %>
    <h1><%s x<|"designacao" %></h1>
    <p style="margin-bottom: 2rem;"></p>
    <% end; %>
    </div>
  </div>

  <div class="top-left2" style="position: absolute; top: 14em; left: 5em;">
    <h5 style="color: #2895bd">Domínio:</h5>
    <p><a href='/dominios/<%s dom |> List.hd <| "id" %>'><%s dom |> List.hd <| "designacao" %></a></p>
  </div>

  <div class="center" style="position: absolute; top: 14em; left: 61em;">
    <h2 style="margin-bottom: 1rem;">Projetos</h2>
    <div style="width: 24rem;">
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <% projs |> List.iter begin fun x -> %>
          <tr>
            <th scope="row"><%s x<|"id"%></th>
            <td><a href='/projetos/<%s x<|"id" %>'><%s x<|"nome"%></td>
          </tr>
          <% end; %>
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
