open Types

let publicacao (_pub : data) projeto =
  General.navbar_inpage "Publicação" ^
  <div class="left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1><%s _pub <| "url" %></h1>

    <div style="width: 30rem; word-wrap: normal; white-space:normal">
    <p style="margin-bottom: 2rem;"></p>
    <h5 style="color: #2895bd">Jornal:</h5>
    <p><%s _pub <| "nomeJornal" %></p>

    <h5 style="color: #2895bd">Indicador de Sucesso:</h5>
    <p><%s if (_pub <| "indicador" |> int_of_string == 1) then "Teve sucesso!" else "Não teve sucesso." %></p>

    <h5 style="color: #2895bd">DOI:</h5>
    <p><%s _pub <| "doi" %></p>

    <p style="margin-bottom: 2rem;"></p>
    </div>
  </div>

  <div class="center" style="position: absolute; top: 12em; left: 64em;">
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
    <a href='/publicacoes/<%s _pub <| "id" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>

let publicacao_form request (pub: data) (proj: data list) message =
  General.navbar_inpage "Modificar Publicação" ^
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <form method="POST" action='/publicacoes/<%s pub <| "id" %>/modificar'>
      <%s! Dream.csrf_tag request %>
      <div class="mb-3">
        <label for="input1" class="form-label">URL</label>
        <input name="url" placeholder="url" value='<%s pub<|"url" %>' type="text" class="form-control" id="input1" aria-describedby="input1Help" />
        <div id="input1Help" class="form-text">Novo URL da publicação.</div>

        <label for="input4" class="form-label">Jornal</label>
        <input name="jornal" placeholder="jornal" value='<%s pub<|"nomeJornal" %>' type="text" class="form-control" id="input4" aria-describedby="input4Help" />
        <div id="input4Help" class="form-text">Novo jornal da publicação.</div>

        <label for="input2" class="form-label">Indicador de Sucesso</label>
        <input name="indicador" placeholder="indicador" value='<%s pub<|"indicador" %>' type="number" class="form-control" id="input2" aria-describedby="input2Help" />
        <div id="input2Help" class="form-text">Novo indicador de sucesso (1 ou 0).</div>

        <label for="input3" class="form-label">DOI</label>
        <input name="doi" placeholder="doi" value='<%s pub<|"doi" %>' type="text" class="form-control" id="input3" aria-describedby="input3Help" />
        <div id="input3Help" class="form-text">Novo DOI da publicação.</div>
      </div>
      <div class="forms">
        <label for="projectId">Instituto</label>
        <select class="form-select" multiple name="projectId" id="projectid" style="margin-top: 5px">
        <% proj |> List.iter begin fun x -> %>
% begin match (x<|"id") = (pub<|"projetoId") with
% | true -> 
  <option selected value='<%s x<|"id" %>'><%s x<|"nome" %></option>
% | false -> 
  <option value='<%s x<|"id" %>'><%s x<|"nome" %></option>
% end;
        <% end; %>
        </select>
      </div>
      <button type="submit" class="btn btn-primary" style="margin-top: 50px;">Submeter</button>
    </form>
% begin match message with 
%   | None -> () 
%   | Some message -> 
      <p><b><%s message %></b></p>
%   end;
  </div>
