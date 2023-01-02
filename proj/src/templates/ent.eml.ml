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

let entidades (ents: data list) maior extmaior =
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

    <p style="margin-bottom: 2rem;"></p>
    <h5 style="color: #2895bd">Entidade que paga mais:</h5>
    <p><a href='/entidades/<%s extmaior |> List.hd <| "id" %>'><%s maior |> List.hd <| "nome" %></a> que investe <%s maior |> List.hd <| "total" %> euros</p>
    
    <p style="margin-bottom: 2rem;"></p>
    <h5 style="color: #2895bd">Entidade exterior com mais entidades financiados:</h5>
    <p><a href='/entidades/<%s extmaior |> List.hd <| "id" %>'><%s extmaior |> List.hd <| "nome" %></a> com <%s extmaior |> List.hd <| "numero" %> entidades financiados</p>
  </div>

let entidade (ent: data list) (projs: data list) =
  General.navbar_inpage "Entidade" ^
  <div>
    <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
      <a href='/entidades/<%s ent |> List.hd <| "id" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
      </a>
    </div>
  </div>
  <div class="container">
    <div class="esquerda" style="position: absolute; top: 6em; left: 4em;">
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

      <h5 style="color: #2895bd">URL:</h5>
      <p><%s x<|"url" %></p>
      
      <p style="margin-bottom: 2rem;"></p>
      <% end; %>
      </div>
    </div>

    <div class="centro" style="position: absolute; top: 16em; left: 39em;">
      <h2 style="margin-bottom: 1rem;">Programas</h2>
      <div style="width: 28rem" ;>
        <table class="table table-dark table-hover">
          <thead class="table-dark">
            <tr>
              <th scope="col">#</th>
              <th scope="col">Designação</th>
              <th scope="col">Valor</th>
            </tr>
          </thead>
          <tbody class="table-group-divider">
            <% ent |> List.iter begin fun x -> %>
            <tr>
              <th scope="row"><%s x <| "Pid" %></th>
              <td><a href='/programas/<%s x <| "Pid" %>'><%s x <| "pdesignacao" %></a></td>
              <td><%s x <| "valor" %></td>
            </tr>
            <% end; %>
          </tbody>
        </table>
      </div>
      <p style="margin-bottom: 2rem;"></p>
    </div>

    <div class="direita" style="position: absolute; top: 16em; left: 78em;">
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
              <td><a href='/entidades/<%s x<|"id" %>'><%s x<|"nome"%></td>
            </tr>
            <% end; %>
          </tbody>
        </table>
      </div>
      <p style="margin-bottom: 2rem;"></p>
    </div>
  </div>

let ent_form request entidade programas entigrama message=
  General.navbar_inpage "Entidade" ^ 
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <form method="POST" action='/entidades/<%s entidade<|"id" %>/modificar'>
      <%s! Dream.csrf_tag request %>
      <div class="mb-3">
        <label for="input1" class="form-label">Nome</label>
        <input name="nome" placeholder="nome" value='<%s entidade<|"nome" %>' type="text" class="form-control" id="input1" aria-describedby="input1Help">
        <div id="input1Help" class="form-text">Novo nome da entidade.</div>

        <label for="input3" class="form-label">Descrição</label>
        <input name="descricao" placeholder="descricao" value='<%s entidade<|"descricao" %>' type="text" class="form-control" id="input3" aria-describedby="input3Help">
        <div id="input3Help" class="form-text">Nova descrição da entidade.</div>
        
        <label for="input2" class="form-label">Designacao</label>
        <input name="designacao" placeholder="designacao" value='<%s entidade<|"designacao" %>' type="text" class="form-control" id="input2" aria-describedby="input2Help">
        <div id="input2Help" class="form-text">Nova designação da entidade.</div>

        <label for="input4" class="form-label">Email</label>
        <input name="email" placeholder="email" value='<%s entidade<|"email" %>' type="text" class="form-control" id="input4" aria-describedby="input4Help">
        <div id="input4Help" class="form-text">Novo email da entidade</div>

        <label for="input5" class="form-label">Telemóvel</label>
        <input name="telemovel" placeholder="telemovel" value='<%s entidade<|"telemovel" %>' type="text" class="form-control" id="input5" aria-describedby="input5Help">
        <div id="input5Help" class="form-text">Novo telemóvel da entidade em inglês (NULL se o título normal for em inglês)</div>

        <label for="input6" class="form-label">Morada</label>
        <input name="morada" placeholder="morada" value='<%s entidade<|"morada" %>' type="text" class="form-control" id="input6" aria-describedby="input6Help">
        <div id="input6Help" class="form-text">Nova morada da entidade</div>

        <label for="input7" class="form-label">País</label>
        <input name="pais" placeholder="pais" value='<%s entidade<|"pais" %>' type="text" class="form-control" id="input7" aria-describedby="input7Help">
        <div id="input7Help" class="form-text">Novo país da entidade</div>

        <label for="input8" class="form-label">URL</label>
        <input name="url" placeholder="url" value='<%s entidade<|"url" %>' type="text" class="form-control" id="input8" aria-describedby="input8Help">
        <div id="input8Help" class="form-text">Novo URL da entidade</div>
      </div>
      
      <div style="width: 750px; margin: 0 auto; text-align: left">
        <p>Programas:</p>
        <% programas |> List.iter begin fun x -> %> 
          <div class="form-check">
% begin match (entigrama |> List.exists (fun i -> String.equal (i <| "Pid") (x <| "id"))) with
%   | true -> 
            <input value='<%s x<|"id" %>' name="progs" class="form-check-input" type="checkbox" id="flexCheckChecked" checked>
            <label class="form-check-label" for="flexCheckChecked"> 
%   | false -> 
            <input value='<%s x<|"id" %>' name="progs" class="form-check-input" type="checkbox" id="flexCheckDefault">
            <label class="form-check-label" for="flexCheckDefault">
% end;
            <%s x <| "id" %> - <%s x<|"designacao" %>
          </div>
        <% end; %>
      </div>
      <div style="width: 750px; margin: 0 auto; text-align: left">
      <% entigrama |> List.iter begin fun x -> %> 
        <div class="mb-3">
          <label for="valor" class="form-label">Valor programa <%s x<| "Pid" %>:</label>
          <input name="prog" placeholder="prog" value='<%s x<|"Pid" %>' type="hidden">
          <input name="valor" placeholder="valor" value='<%s x<|"valor" %>' type="text" class="form-control" id="valor" aria-describedby="valorHelp">
          <div id="valorHelp" class="form-text">Se ativar a checkbox, introduza um valor em €. Se desativar a checkbox, deixe o valor em branco.</div>
        </div>
        <% end; %>
      </div>
      <button type="submit" class="btn btn-primary" style="margin-top: 50px;">Submeter</button>
    </form> 
% begin match message with 
%   | None -> () 
%   | Some message -> 
      <p><b><%s message %></b></p>
%   end;
  </div>
