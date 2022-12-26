open Types

let investigadores (invs: data list) = 
  General.navbar_inpage "Investigadores" ^
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
          <td><a href='/investigador/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
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


let investigador (invs: data) =
  General.navbar_inpage "Investigador" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Nome</th>
          <th scope="col">Idade</th>
          <th scope="col">Morada</th>
          <th scope="col">Instituto</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <tr>
          <th scope="row"><%s invs<|"id" %></th>
          <td><%s invs<|"nome" %></td>
          <td><%s invs<|"idade" %></td>
          <td><%s invs<|"morada" %></td>
          <td><%s invs<|"instituto" %></td>
        </tr>
      </tbody>
    </table>
  </div>
