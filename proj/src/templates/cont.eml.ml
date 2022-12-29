open Types

let contrato (_cont : data) projeto =
  General.navbar_inpage "Contrato" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1><%s _cont <| "nome" %></h1>
    <h5><%s _cont <| "descricao" %></h5>

    <div style="width: 30rem; word-wrap: normal; white-space:normal">
    <p style="margin-bottom: 2rem;"></p>
    <h5 style="color: #2895bd">Título:</h5>
    <p><%s _cont <| "titulo" %></p>

    <h5 style="color: #2895bd">Estado:</h5>
    <p><%s _cont <| "estado" %></p>

    <p style="margin-bottom: 2rem;"></p>
    </div>
  </div>

  <div class="top-left2" style="position: absolute; top: 12em; left: 64em;">
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
          <% projeto |> List.iter begin fun x -> %> 
          <tr>
            <th scope="row"><%s x<|"id" %></th>
            <td><a href='/projetos/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
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

