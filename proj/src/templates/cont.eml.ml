open Types

let contrato (_cont : data) projeto =
  General.navbar_inpage "Contrato" ^
  <div class="left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
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
    <a href='/contratos/<%s _cont <| "id" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>

let contrato_form request (cont: data) status message =
  General.navbar_inpage "Modificar Contrato" ^
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <form method="POST" action='/contratos/<%s cont <| "id" %>/modificar'>
      <%s! Dream.csrf_tag request %>
      <div class="mb-3">
        <label for="input1" class="form-label">Nome</label>
        <input name="nome" placeholder="nome" value='<%s cont<|"nome" %>' type="text" class="form-control" id="input1" aria-describedby="input1Help" />
        <div id="input1Help" class="form-text">Novo nome do contrato.</div>

        <label for="input4" class="form-label">Título</label>
        <input name="titulo" placeholder="titulo" value='<%s cont<|"titulo" %>' type="text" class="form-control" id="input4" aria-describedby="input4Help" />
        <div id="input4Help" class="form-text">Novo título do contrato.</div>

        <label for="input2" class="form-label">Descrição</label>
        <input name="descricao" placeholder="descricao" value='<%s cont<|"descricao" %>' type="text" class="form-control" id="input2" aria-describedby="input2Help" />
        <div id="input2Help" class="form-text">Nova descrição do contrato.</div>
      </div>
      <div class="forms">
        <label for="status">Status</label>
        <select class="form-select" multiple name="status" id="status" style="margin-top: 5px">
        <% status |> List.iter begin fun x -> %>
% begin match (x<|"id") = (cont<|"statusId") with
% | true -> 
  <option selected value='<%s x<|"id" %>'><%s x<|"designacao" %></option>
% | false -> 
  <option value='<%s x<|"id" %>'><%s x<|"designacao" %></option>
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
