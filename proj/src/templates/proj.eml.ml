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
    <p style="margin-bottom: 2rem;"></p>
  </div>
  <div style="text-align:center; width: 300px; margin: 0 auto;">
    <form class="d-flex" role="search" method="POST" action="/projetos">
      <%s! Dream.csrf_tag request %>
      <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" name="keyword">
      <button class="btn btn-outline-success" type="submit">Search</button>
    </form>
  </div>

let procura_projetos projs keyword =
  General.navbar_home "Projetos" ^
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
  <div class="top-left" style="position: absolute; top: 5em; left: 4em; font-size: 18px; word-wrap: break-word;">
    <h1><%s _proj <| "nome" %></h1>
    <h5 style="color: #2895bd">Descrição:</h5> 
    <p style="margin-right: 40rem;"><%s _proj <| "descricao" %></p>
    
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

    <h2 style="margin-bottom: 1rem;">Publicações</h2>
    <div style="width: 24rem" ;>
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
            <td><%s x<|"url" %></td>
            <td><%s x<|"doi" %></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>

    <p style="margin-bottom: 2rem;"></p>
  </div>

  <div class="top-left2" style="position: absolute; top: 17em; left: 64em;">
    <h2 style="margin-bottom: 1rem;">Keywords</h2>
    <div style="width: 24rem" ;>
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
            <td><%s x<|"keyword" %></td>
          </tr>
          <% end; %>
        </tbody>
      </table>
    </div>
    <p style="margin-bottom: 2rem;"></p>

    <h2 style="margin-bottom: 1rem;">Investigadores</h2>
    <div style="width: 24rem" ;>
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


  <div class="centre" style="position: absolute; top: 17em; left: 120em;">
    <h2 style="margin-bottom: 1rem;">Estados</h2>
    <h5 style="color: #2895bd">Atual:</h5> 
    <p style="margin-right: 40rem;"><%s status |> List.hd <| "designacao" %></p>
    <h4>Histórico:</h4>
    <div style="width: 24rem" ;>
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
    <p style="margin-bottom: 2rem;"></p>
    PLACEHOLDER
  </div>

  <div class="d-grid gap-2 col-1 mx-auto" style="width: 3rem; position: absolute; top: 5em; right: 6em">
    <a href="/index.html" class="btn btn-secondary" tabindex="-1" role="button" aria-disabled="true">
      Modificar
    </a>
  </div>

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
