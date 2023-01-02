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
  </div>

let investigador_form request (inves: data) (inst: data list) message =
  General.navbar_inpage "Modificar investigador" ^
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <form method="POST" action='/investigadores/<%s inves <| "id" %>/modificar'>
      <%s! Dream.csrf_tag request %>
      <div class="mb-3">
        <label for="input1" class="form-label">Nome</label>
        <input name="nome" placeholder="nome" value='<%s inves<|"nome" %>' type="text" class="form-control" id="input1" aria-describedby="input1Help" />
        <div id="input1Help" class="form-text">Novo nome do investigador.</div>

        <label for="input2" class="form-label">Título</label>
        <input name="idade" placeholder="idade" value='<%s inves<|"idade" %>' type="number" class="form-control" id="input2" aria-describedby="input2Help" />
        <div id="input2Help" class="form-text">Nova idade do investigador.</div>

        <label for="input3" class="form-label">Descrição</label>
        <input name="morada" placeholder="morada" value='<%s inves<|"morada" %>' type="text" class="form-control" id="input3" aria-describedby="input3Help" />
        <div id="input3Help" class="form-text">Nova morada do investigador.</div>
      </div>
      <div class="forms">
        <label for="institutoId">Instituto</label>
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
% begin match message with 
%   | None -> () 
%   | Some message -> 
      <p><b><%s message %></b></p>
%   end;
  </div>
