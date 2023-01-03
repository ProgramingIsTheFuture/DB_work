open Types

let investigadores (invs: data list) = 
  General.navbar_home "investigadores" "Investigadores" ^
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


let investigador (invs: data) unidades projetos =
  General.navbar_inpage "Investigador" ^
  <div class="left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1><%s invs <| "nome" %></h1>
    <h4>Pertence a: <%s invs <| "instituto" %></h4>
    <p style="margin-bottom: 2rem;"></p>

    <h5 style="color: #2895bd">Idade:</h5>
    <p><%s invs <| "idade" %></p>
    <h5 style="color: #2895bd">Morada:</h5>
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
            <td><a href='/unidades/<%s x<|"id" %>'><%s x <| "nome" %></a></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="center" style="position: absolute; top: 14em; left: 78em;">
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

    <h5 style="color: #2895bd">Tempo total:</h5>
    <p><%i projetos |> List.map (fun p -> p <| "tempoPerc" |> int_of_string) |> List.fold_left (+) 0 %></p>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href='/investigadores/<%s invs <| "id" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
    <a href='/investigadores/<%s invs <| "id" %>/remover' class="btn btn-danger" tabindex="-1" role="button" aria-disabled="true">
      Apagar
    </a>
  </div>

let create_inves request inves inst subm = 
  <div style="width: 750px; margin: 0 auto; text-align: left">
  <form method="POST" action='<%s subm %>'>
    <%s! Dream.csrf_tag request %>
    <div class="mb-3">
      <label for="input1" class="form-label">Nome</label>
      <input name="nome" placeholder="nome" value='<%s inves<|"nome" %>' type="text" class="form-control" id="input1" aria-describedby="input1Help" />
      <div id="input1Help" class="form-text">Novo nome do investigador.</div>

      <label for="input2" class="form-label">Idade</label>
      <input name="idade" placeholder="idade" value='<%s inves<|"idade" %>' type="number" class="form-control" id="input2" aria-describedby="input2Help" />
      <div id="input2Help" class="form-text">Nova idade do investigador.</div>

      <label for="input3" class="form-label">Morada</label>
      <input name="morada" placeholder="morada" value='<%s inves<|"morada" %>' type="text" class="form-control" id="input3" aria-describedby="input3Help" />
      <div id="input3Help" class="form-text">Nova morada do investigador.</div>
    </div>
    <div class="forms">
      <label for="institutoId" class="form-label">Instituto</label>
      <select class="form-select" multiple name="institutoId" id="status" style="margin-top: 5px">
      <% inst |> List.iter begin fun x -> %>
% begin match (x<|"id") = (inves<|"institutoId") with
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
  </div>


let investigador_create request inves inst =
  General.navbar_crud "investigadores" "Criar Investigador" ^
  create_inves request inves inst "/investigadores/create"

let investigador_add_participa request inves projetos papel = 
  General.navbar_inpage "Participa" ^
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <form method="POST" action='/investigadores/<%s inves<|"id" %>/participa/adicionar'>
      <%s! Dream.csrf_tag request %>
      <div class="mb-2">
      <h2 style="margin-top:50px; margin-bottom:10px;">Projeto</h2>
      <select class="form-select" multiple name="projectId" id="papel" style="margin-top: 5px">
      <% projetos |> List.iter begin fun x -> %>
  % begin match participa |> List.exists (fun p -> (x<|"id") = (p<|"projetoId")) with
  % | true -> ()
  % | false ->
        <option value='<%s x<|"id" %>'><%s x<|"nome" %></option>
  % end;
      <% end; %>
      </select>
      </div>

      <h2 style="margin-top:50px; margin-bottom:10px;">Papel</h2>
      <select class="form-select" multiple name="papelId" id="papel" style="margin-top: 5px">
        <% papel |> List.iter begin fun pp -> %>
          <option value='<%s pp<|"id" %>'><%s pp<|"designacao" %></option>
        <% end; %>
      </select>
      <div class="mb-2" style="margin-top:25px;">
        <label for="input5" class="form-label">Tempo (%)</label>
        <input type="text" name="tempoPerc" placeholder="0" class="form-control" id="input5" aria-describedby="input5Help"/>
        <div id="input5Help" class="form-text">Novo tempo de dedicacao.</div>
      </div>
      <button type="submit" class="btn btn-primary" style="margin-top: 25px; margin-bottom: 5px;">Submeter</button>
    </form>
  </div>

let investigador_form request (inves: data) (inst: data list) (unidades: data list) (unidade_investigador: data list) projetos participa message =
  General.navbar_crud "investigadores" "Modificar Investigador" ^ create_inves request inves inst ("/investigadores/"^ (inves<|"id") ^"/modificar") ^ 
  <div style="width: 750px; margin: 0 auto; text-align: left">
% begin match message with 
%   | None -> () 
%   | Some message -> 
      <p><b><%s message %></b></p>
%   end;
    <h2 style="margin-top:50px;">UnidadeInvestigador</h2>
    <form method="POST" action='/investigadores/<%s inves<|"id" %>/unidade/modificar'>
      <%s! Dream.csrf_tag request %>
      <% unidades |> List.iter begin fun x -> %> 
      <div class="mb-2">
% begin match unidade_investigador |> List.exists (fun ui -> (x<|"id") = (ui<|"unidadeInvestigacaoId" )) with
% | true ->
  <input value='<%s x<|"id" %>' name="unidade" class="form-check-input" type="checkbox" id="flexCheckChecked" checked />
  <label class="form-check-label" for="flexCheckChecked"></label> 
% | false -> 
  <input value='<%s x<|"id" %>' name="unidade" class="form-check-input" type="checkbox" id="flexCheckDefault" />
  <label class="form-check-label" for="flexCheckDefault"></label> 
% end;
      <%s x <| "id" %> - <%s x<|"nome" %>
      </div>
      <% end; %>
      <button type="submit" class="btn btn-primary" style="margin-top: 25px; margin-bottom: 5px;">Submeter</button>
    </form>

    <h2 style="margin-top:50px;">Participa em projetos</h2>
    <a href='/investigadores/<%s inves<|"id"%>/participa/adicionar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Adicionar
    </a>
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Projeto</th>
          <th scope="col">Apagar</th>
        </tr>
      </thead>
      <tbody class="table-group-divider"> 
        <% projetos |> List.iter begin fun x -> %>
% begin match participa |> List.exists (fun p -> (x<|"id") = (p<|"projetoId")) with
% | true ->
          <tr>
            <th scope="row"><%s x<|"id" %></th>
            <td><a href='/projetos/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
            <td><a href='/investigadores/<%s inves<|"id" %>/participa/<%s x<|"id" %>/remover'>Remover</a></td>
          </tr>
% | false -> ()
% end;
        <% end; %>
      </tbody>
    </table> 
  </div>
