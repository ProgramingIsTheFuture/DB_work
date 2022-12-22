let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.home;
         Dream.get "/projetos" @@ Handlers.serve (Pages.projetos_contratos (Handlers.query ("SELECT * FROM users;") |> Handlers.users_of_row)) "Projetos";
         (*Dream.get "/contratos"*)
         Dream.get "/investigadores" @@ Handlers.serve Pages.investigadores "Investigadores";
         Dream.get "/projetos/:id" @@ (fun request -> Dream.html (Dream.param request "id" ));
         Dream.get "/inves_teste" @@ Handlers.serve Templates.inves_template "Investigadores";
         Dream.get "/assets/**" @@ Dream.static "./assets";
       ]
