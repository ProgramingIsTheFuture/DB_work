open Types

let projetos_contratos request lst =
  General.navbar_home "Projetos / Contratos" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Projeto</th>
          <th scope="col">Contrato Associado</th>
        </tr>
      </thead>
      <tbody class="table-group-divider"> 
        <% lst |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/projetos/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
          <td><a href='/contratos/<%s x<|"Cid" %>'><%s x<|"contrato" %></a></td>
        </tr>
        <% end; %>
      </tbody>
    </table>

    <p style="margin-bottom: 2rem;"></p>
    <h5 style="color: #2895bd">Pesquisar projetos por palavras-chave:</h5>
    <p style="margin-bottom: 2rem;"></pkeyword>
  </div>
  <div style="text-align:center; width: 300px; margin: 0 auto;">
    <form class="d-flex" role="search" method="POST" action="/projetos">
      <%s! Dream.csrf_tag request %>
      <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" name="keyword">
      <button class="btn btn-outline-success" type="submit">Search</button>
    </form>
  </div>

let procura_projetos projs keyword =
  General.navbar_home "Modificar Projetos" ^
  <div style="text-align: center; width: 1000px; margin: 0 auto; border-style: none; margin-top: 30px;">
    <p style="margin-bottom: 2rem;"></p>
    <h5 style="color: #2895bd">Projetos com a palavra-chave <%s keyword %></h5>
    <p style="margin-bottom: 2rem;"></p>
    <table class="table table-dark table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Projeto</th>
        </tr>
      </thead>
      <tbody class="table-group-divider"> 
        <% projs |> List.iter begin fun x -> %> 
        <tr>
          <th scope="row"><%s x<|"id" %></th>
          <td><a href='/projetos/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
        </tr>
        <% end; %>
      </tbody>
    </table>
  </div>

let projeto (_proj: data) (id : int) keywords publicacoes investigadores areas_dominios status historico_status =
  General.navbar_inpage "Projeto" ^
  <div>
    <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 4rem; right: 8rem; z-index: 99;">
      <a href='/projetos/<%s _proj <| "id" %>/modificar' class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
        Modificar
      </a>
    </div>
    <div class="parent-container">
      <div class="esq">
        <h1><%s _proj <| "nome" %></h1>
        <h5 style="color: #2895bd">Descrição:</h5> 
        <p style="margin-right: 66%;"><%s _proj <| "descricao" %></p>
        
        <div style="width: 30rem; word-wrap: normal; white-space:normal">
          <p style="margin-bottom: 2rem;"></p>
          <h5 style="color: #2895bd">Título:</h5>
          <p><%s _proj <| "titulo" %></p>

          <h5 style="color: #2895bd">Português:</h5>
          <p><%s _proj <| "portugues" %></p>

          <h5 style="color: #2895bd">Inglês:</h5> 
          <p><%s _proj <| "ingles" %></p>

          <h5 style="color: #2895bd">Data de Início:</h5>
          <p><%s _proj <| "data_ini" %></p>

          <h5 style="color: #2895bd">Data de Fim:</h5> 
          <p><%s _proj <| "data_fim" %></p>

          <h5 style="color: #2895bd">URL:</h5> 
          <p><%s _proj <| "url" %></p>

          <h5 style="color: #2895bd">Digital Object Identifier:</h5>
          <p><%s _proj <| "doi" %></p>
          <p style="margin-bottom: 2rem;"></p>
        </div>

        <div class="tbl" style="width: 24rem" ;>
          <h2 style="margin-bottom: 1rem;">Publicações</h2>
          <table class="table table-dark table-hover">
            <thead class="table-dark">
              <tr>
                <th scope="col">#</th>
                <th scope="col">Nome</th>
                <th scope="col">URL</th>
                <th scope="col">DOI</th>
              </tr>
            </thead>
            <tbody class="table-group-divider">
              <% publicacoes |> List.iter begin fun x -> %> 
              <tr>
                <th scope="row"><%s x<|"id" %></th>
                <td><%s x<|"nomeJornal" %></td>
                <td><a href='/publicacoes/<%s x<|"id" %>'><%s x<|"url" %></a></td>
                <td><%s x<|"doi" %></td>
              </tr>
              <% end; %>
            </tbody>
          </table>
        </div>
        <p style="margin-bottom: 2rem;"></p>
      </div>

      <div class="cen"> 
        <h2 style="margin-bottom: 1rem;">Keywords</h2>
        <div class="tbl" style="width: 24rem" ;>
          <table class="table table-dark table-hover">
            <thead class="table-dark">
              <tr>
                <th scope="col">#</th>
                <th scope="col">Keywords</th>
              </tr>
            </thead>
            <tbody class="table-group-divider">
              <% keywords |> List.iter begin fun x -> %> 
              <tr>
                <th scope="row"><%s x<|"id" %></th>
                <td><%s x<|"designacao" %></td>
              </tr>
              <% end; %>
            </tbody>
          </table>
        </div>
        <p style="margin-bottom: 2rem;"></p>

        <h2 style="margin-bottom: 1rem;">Investigadores</h2>
        <div class="tbl" style="width: 24rem" ;>
          <table class="table table-dark table-hover">
            <thead class="table-dark">
              <tr>
                <th scope="col">#</th>
                <th scope="col">Nome</th>
                <th scope="col">Papel</th>
              </tr>
            </thead>
            <tbody class="table-group-divider">
              <% investigadores |> List.iter begin fun x -> %> 
              <tr>
                <th scope="row"><%s x <| "Iid" %></th>
                <td><a href='/investigadores/<%s x<| "Iid" %>'><%s x<|"Inome" %></a></td>
                <td><%s x<|"papel" %></td>
              </tr>
              <% end; %>
            </tbody>
          </table>
        </div>
        <p style="margin-bottom: 2rem;"></p>
        <h2 style="margin-bottom: 1rem;">Áreas e Domínios Cientificos</h2>
          <% areas_dominios |> List.iter begin fun x -> %> 
            <p><%s x <| "area" %> -> <%s x<|"dominio" %></p>
          <% end; %>

        <p style="margin-bottom: 2rem;"></p>
        <h2><a href='<%s id |> string_of_int %>/financiamento'>Detalhes de financiamento</a></h2>
      </div>
   
      <div class="dir">
        <h2 style="margin-bottom: 1rem;">Estados</h2>
        <h5 style="color: #2895bd">Atual:</h5> 
        <p style="margin-right: 66%;"><%s status |> List.hd <| "designacao" %></p>
        <h4>Histórico:</h4>
        <div class="tbl" style="width: 24rem" ;>
          <table class="table table-dark table-hover">
            <thead class="table-dark">
              <tr>
                <th scope="col">#</th>
                <th scope="col">Status</th>
                <th scope="col">Data</th>
              </tr>
            </thead>
            <tbody class="table-group-divider">
              <% historico_status |> List.iter begin fun x -> %> 
              <tr>
                <th scope="row"><%s x<|"id" %></th>
                <td><%s x<|"designacao" %></a></td>
                <td><%s x<|"data" %></td>
              </tr>
              <% end; %>
            </tbody>
          </table>
        </div>
        <p style="margin-bottom: 2rem;"></p>

        <h2>Classificação</h2>
        <p style="margin-bottom: 2rem;">
        PLACEHOLDER
        </p>
      </div>
    </div>
  <div/>

let proj_entities (_proj : data) contrato entidades programas =
  General.navbar_inpage "Projetos" ^
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px; word-wrap: break-word;">
    <h1><%s _proj <| "nome" %></h1>
  </div>
  <div class="left" style="position: absolute; top: 12em; left: 4em;">
    <h2 style="margin-bottom: 1rem;">Contrato Associado</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">IDCont</th>
            <th scope="col">Nome</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <% contrato |> List.iter begin fun x -> %> 
          <tr>
            <th scope="row"><%s x<|"id" %></th>
            <td><a href='/contratos/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
  </div>

  <div class="centre" style="position: absolute; top: 12em; left: 64em;">
    <h2 style="margin-bottom: 1rem;">Entidades Financiadoras</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <% entidades |> List.iter begin fun x -> %> 
          <tr>
            <th scope="row"><%s x <| "id" %></th>
            <td><a href='/entidades/<%s x<|"id" %>'><%s x<|"nome" %></a></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="right" style ="position: absolute; top: 12em; left: 120em;">
    <h2 style="margin-bottom: 1rem;">Programas</h2>
    <div style="width: 24rem" ;>
      <table class="table table-dark table-hover">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          <% programas |> List.iter begin fun x -> %> 
          <tr>
            <th scope="row"><%s x <| "id" %></th>
            <td><a href='/programas/<%s x<|"id" %>'><%s x<|"designacao" %></a></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
  </div>

let projeto_id_modificar request message project status programs projama areas areaprojeto =
  General.navbar_inpage "Modificar Projeto" ^ 
  <div style="width: 750px; margin: 0 auto; text-align: left">
    <form method="POST" action='/projetos/<%s project<|"id" %>/modificar'>
      <%s! Dream.csrf_tag request %>
      <div class="mb-3">
        <label for="input1" class="form-label">Nome</label>
        <input name="nome" placeholder="nome" value='<%s project<|"nome" %>' type="text" class="form-control" id="input1" aria-describedby="input1Help">
        <div id="input1Help" class="form-text">Novo nome do projeto.</div>

        <label for="input2" class="form-label">Título</label>
        <input name="titulo" placeholder="titulo" value='<%s project<|"titulo" %>' type="text" class="form-control" id="input2" aria-describedby="input2Help">
        <div id="input2Help" class="form-text">Novo título do projeto.</div>

        <label for="input3" class="form-label">Descrição</label>
        <input name="descricao" placeholder="descricao" value='<%s project<|"descricao" %>' type="text" class="form-control" id="input3" aria-describedby="input3Help">
        <div id="input3Help" class="form-text">Nova descrição do projeto.</div>

        <label for="input4" class="form-label">Português</label>
        <input name="portugues" placeholder="portugues" value='<%s project<|"portugues" %>' type="text" class="form-control" id="input4" aria-describedby="input4Help">
        <div id="input4Help" class="form-text">Novo nome do projeto em português (NULL se o título normal for em português)</div>

        <label for="input5" class="form-label">Inglês</label>
        <input name="ingles" placeholder="ingles" value='<%s project<|"ingles" %>' type="text" class="form-control" id="input5" aria-describedby="input5Help">
        <div id="input5Help" class="form-text">Novo nome do projeto em inglês (NULL se o título normal for em inglês)</div>

        <label for="input6" class="form-label">Data de Início</label>
        <input name="data_ini" placeholder="data_ini" value='<%s project<|"data_ini" %>' type="text" class="form-control" id="input6" aria-describedby="input6Help">
        <div id="input6Help" class="form-text">Nova data de início do projeto (yyyy-mm-dd)</div>

        <label for="input7" class="form-label">Data de Fim</label>
        <input name="data_fim" placeholder="data_fim" value='<%s project<|"data_fim" %>' type="text" class="form-control" id="input7" aria-describedby="input7Help">
        <div id="input7Help" class="form-text">Nova data de fim do projeto (yyyy-mm-dd, NULL se ainda não estiver acabado)</div>

        <label for="input8" class="form-label">URL</label>
        <input name="url" placeholder="url" value='<%s project<|"url" %>' type="text" class="form-control" id="input8" aria-describedby="input8Help">
        <div id="input8Help" class="form-text">Novo URL do projeto</div>

        <label for="input9" class="form-label">DOI</label>
        <input name="doi" placeholder="doi" value='<%s project<|"doi" %>' type="text" class="form-control" id="input9" aria-describedby="input9Help">
        <div id="input9Help" class="form-text">Novo DOI do projeto</div>
      </div>
      <div class="forms">
        <label for="status">Status</label>
        <select class="form-select" multiple name="status" id="status" style="margin-top: 5px">
        <% status |> List.iter begin fun x -> %>
% begin match (x<|"id") = (project<|"statusId") with
% | true -> 
  <option selected value='<%s x<|"id" %>'><%s x<|"designacao" %></option>
% | false -> 
  <option value='<%s x<|"id" %>'><%s x<|"designacao" %></option>
% end;
        <% end; %>
        </select>
      </div>
      <div style="width: 750px; margin: 0 auto; margin-top: 50px; text-align: left">
        <p>Programas:</p>
        <% programs |> List.iter begin fun x -> %> 
          <div class="form-check">
% begin match (projama |> List.exists (fun i -> String.equal (i <| "id") (x <| "id"))) with
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
      <div style="width: 750px; margin: 0 auto; margin-top: 50px; text-align: left">
        <p>Areas:</p>
        <% areas |> List.iter begin fun x -> %> 
          <div class="form-check">
% begin match (areaprojeto |> List.exists (fun i -> String.equal (i <| "id") (x <| "id"))) with
%   | true -> 
            <input value='<%s x<|"id" %>' name="areas" class="form-check-input" type="checkbox" id="flexCheckChecked" checked>
            <label class="form-check-label" for="flexCheckChecked"> 
%   | false -> 
            <input value='<%s x<|"id" %>' name="areas" class="form-check-input" type="checkbox" id="flexCheckDefault">
            <label class="form-check-label" for="flexCheckDefault">
% end;
            <%s x <| "id" %> - <%s x<|"designacao" %>
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

