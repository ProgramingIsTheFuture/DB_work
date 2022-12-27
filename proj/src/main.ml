let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.home;
         Dream.get "/projetos" @@ Handlers.projects;
         Dream.get "/projetos/:id" @@ Handlers.projects_id;
         Dream.get "/projetos/:id/financiamento"
         @@ Handlers.projects_id_entities;
         Dream.get "/contratos/:id" @@ Handlers.contracts_id;
         Dream.get "/investigadores" @@ Handlers.investigators;
         Dream.get "/investigador/:id" @@ Handlers.investigator;
         Dream.get "/institutos" @@ Handlers.institutes;
         Dream.get "/institute/:id" @@ Handlers.institute;
         Dream.get "/entidades" @@ Handlers.entities;
         Dream.get "/entidade/:id" @@ Handlers.entity;
         Dream.get "/inves_teste" @@ Handlers.inves_test;
         Dream.get "/assets/**" @@ Dream.static "./assets";
       ]
