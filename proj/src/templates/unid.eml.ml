open Types

let unidades (_unid: data list) =
  General.navbar_home "unidades" "Unidades" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Designação</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <% _unid |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/unidades/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
        </tr>
        <% end; %>
      </tbody>
    </table>
  </div>

let unidade (unid : data list) investigadores = 
  General.navbar_inpage "Unidade" ^
  <div class="left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1><%s unid |> List.hd <| "nome" %></h1>
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
          <% investigadores |> List.iter begin fun x -> %> 
          <tr>
            <th scope="row"><%s x<|"id" %></th>
            <td><a href='/investigadores/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href='/unidades/<%s unid |> List.hd <| "id" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
    <a href='/unidades/<%s unid |> List.hd <| "id" %>/remover' class="btn btn-danger" tabindex="-1" role="button" aria-disabled="true">
      Apagar
    </a>
  </div>

let unid_add request message =
  General.navbar_crud "unidades" "Adicionar Unidade" ^
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <p style="margin-bottom: 2rem;"></p>

    <div id="form-fields">
    <form method="POST" action='/unidades/0/adicionar'>
      <%s! Dream.csrf_tag request %>
        <div class="mb-3">
          <label for="designacaoUnid" class="form-label">Nome</label>
          <input name="nome" type="nome" class="form-control" id="designacaoUnid" aria-describedby="emailHelp" required>
          <div id="emailHelp" class="form-text">Introduza aqui o nome.</div>
        </div>
        <button type="submit" class="btn btn-primary">Submeter</button>
      </div>
    </form>
% begin match message with 
%   | None -> () 
%   | Some message -> 
      <p><b><%s message %></b></p>
%   end;
  </div>

let unid_form request unidade message =
  General.navbar_crud "unidades" "Modificar Unidade" ^
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <p style="margin-bottom: 2rem;"></p>

    <div id="form-fields">
    <form method="POST" action='/unidades/<%s unidade <|"id"%>/modificar'>
      <%s! Dream.csrf_tag request %>
        <div class="mb-3">
          <label for="nomeUnid" class="form-label">Nome</label>
          <input value='<%s unidade <| "nome"%>' name="nome" type="nome" class="form-control" id="nomeUnid" aria-describedby="nomeUnid">
          <div id="emailHelp" class="form-text">Introduza aqui o novo nome.</div>
        </div>
        <button type="submit" class="btn btn-primary">Submeter</button>
      </div>
    </form>
% begin match message with 
%   | None -> () 
%   | Some message -> 
      <p><b><%s message %></b></p>
%   end;
  </div>


