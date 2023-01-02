open Types

let dominios lst =
  General.navbar_home "dominios" "Domínios" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Domínio</th>
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
  </div>

let dominio (dom: data list) = 
  General.navbar_inpage "Domínio" ^
  <div class="left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <h1><%s dom |> List.hd <| "designacao" %></h1>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Áreas Científicas</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Designação</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <% dom |> List.iter begin fun x -> %> 
          <tr>
            <th scope="row"><%s x<|"id" %></th>
            <td><a href='/areas/<%s x<|"id" %>'><%s x<|"Adesignacao" %></a></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href='/dominios/<%s dom |> List.hd <| "Did" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>

let dom_form request dominio message =
  General.navbar_inpage "Domínio" ^
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <p style="margin-bottom: 2rem;"></p>

    <div id="form-fields">
    <form method="POST" action='/dominios/<%s dominio<|"id"%>/modificar'>
      <%s! Dream.csrf_tag request %>
        <div class="mb-3">
          <label for="designacaoDom" class="form-label">Designacao</label>
          <input value='<%s dominio <| "designacao"%>' name="designacao" type="designacao" class="form-control" id="designacaoDom" aria-describedby="emailHelp">
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
