let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.home;
         Dream.get "/projetos"
         @@ Handlers.serve
              (Pages.projetos_contratos (Handlers.query "SELECT * FROM users;"))
              "Projetos / Contratos";
         Dream.get "/investigadores"
         @@ Handlers.serve Pages.investigadores "Investigadores";
         Dream.get "/institutos"
         @@ Handlers.serve Pages.institutos "Institutos";
         Dream.get "/entidades"
         @@ Handlers.serve Pages.entidades "Entidades";
         ( Dream.get "/projetos/:id" @@
         Handlers.serve Templates.proj_template "Projetos");
         Dream.get "/inves_teste"
         @@ Handlers.serve Templates.inves_template "Investigadores";
         Dream.get "/assets/**" @@ Dream.static "./assets";
       ]
