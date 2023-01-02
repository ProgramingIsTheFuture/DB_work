open Types

let institutos (inst: data list) =
  General.navbar_home "Institutos" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Designação</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <% inst |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/institutos/<%s x<|"id" %>'><%s x<|"designacao" %></a></td>
        </tr>
        <% end; %>
      </tbody>
    </table>
  </div>

let instituto (inst: data list) = 
  General.navbar_inpage "Instituto" ^
  <div class="left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1><%s inst |> List.hd <| "designacao" %></h1>
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
          <% inst |> List.iter begin fun x -> %> 
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
    <a href='/institutos/<%s inst |> List.hd <| "InstId" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>

let inst_form request instituto message =
  General.navbar_inpage "Modificar Instituto" ^
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <p style="margin-bottom: 2rem;"></p>

    <div id="form-fields">
    <form method="POST" action='/institutos/<%s instituto<|"id"%>/modificar'>
      <%s! Dream.csrf_tag request %>
        <div class="mb-3">
          <label for="designacaoInst" class="form-label">Designacao</label>
          <input value='<%s instituto<| "designacao"%>' name="designacao" type="designacao" class="form-control" id="designacaoInst" aria-describedby="emailHelp">
          <div id="emailHelp" class="form-text">Introduza aqui a nova designação.</div>
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
