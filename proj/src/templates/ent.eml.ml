open Types

(*
[nacional] bit NOT NULL,
  [nome] varchar(255) NOT NULL,
  [descricao] varchar(255),
  [email] varchar(255),
  [telemovel] bigint,
  [designacao] varchar(255) NOT NULL,
  [morada] varchar(255),
  [url] varchar(255),
  [pais] varchar(255) NOT NULL,
 *)

let entidades (ents: data list) =
  General.navbar_inpage "Entidades" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Nome</th>
          <th scope="col">Designação</th>
        </tr>
      </thead>
      <tbody class="table-group-divider">
        <% ents |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/entidades/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
          <td><%s x<|"designacao" %></td>
        </tr>
        <% end; %>
      </tbody>
    </table>
  </div>

let ent_template (ent: data list) (projs: data list) =
  General.navbar_inpage "Entidade" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px">
    <% ent |> List.hd |> begin fun x -> %>
    <h1><%s x<|"nome" %></h1>
    <h5 style="color: #2895bd">Descrição:</h5> 
    <p style="margin-right: 40rem;"><%s x <| "descricao" %></p>
    
    <div style="width: 30rem; word-wrap: normal; white-space:normal">
    <h5 style="color: #2895bd">Designacao:</h5>
    <p><%s x<|"designacao" %></p>

    <h5 style="color: #2895bd">Email:</h5>
    <p><%s x<|"email" %></p>

    <h5 style="color: #2895bd">Telemóvel:</h5>
    <p><%s x<|"telemovel" %></p>

    <h5 style="color: #2895bd">Morada:</h5>
    <p><%s x<|"morada" %></p>

    <h5 style="color: #2895bd">País:</h5>
    <p><%s x<|"pais" %></p>

    <h5 style="color: #2895bd">Nacional:</h5>
    <p><%s x<|"nacional" |> (fun n -> if n = "1" then "Sim" else "Não") %></p>
    
    <p style="margin-bottom: 2rem;"></p>
    <% end; %>
    </div>
  </div>

  <div class="top-left2" style="position: absolute; top: 16em; left: 39em;">
    <h2 style="margin-bottom: 1rem;">Programas</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Designação</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <% ent |> List.iter begin fun x -> %>
          <tr>
            <th scope="row"><%s x <| "Pid" %></th>
            <td><%s x<|"id"%><%s x <| "pdesignacao" %></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="centre" style="position: absolute; top: 16em; left: 78em;">
    <h2 style="margin-bottom: 1rem;">Projetos Financiados</h2>
    <div style="width: 24rem" ;>
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

  <div class="centre" style="position: absolute; top: 16em; left: 120em;">
    <h2>Classificação</h2>
    <p style="margin-bottom: 2rem;"></p>
    PLACEHOLDER
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href="/index.html" class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
    Modificar
    </a>
  </div>

