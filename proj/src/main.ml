let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.home;
         (*Dream.get "/contratos"*)
         Dream.get "/projetos"
         @@ Handlers.serve
              (Pages.projetos_contratos (Handlers.query "SELECT * FROM users;"))
              "Projetos";
         Dream.get "/investigadores"
         @@ Handlers.serve Pages.investigadores "Investigadores";
         ( Dream.get "/projetos/:id" @@ fun request ->
           Dream.html (Dream.param request "id") );
         Dream.get "/inves_teste"
         @@ Handlers.serve Templates.inves_template "Investigadores";
         (*Dream.get "/contratos"*)
         Dream.get "/assets/**" @@ Dream.static "./assets";
       ]
