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
         Dream.get "/investigadores/:id" @@ Handlers.investigator;
         Dream.get "/unidades" Handlers.unids;
         Dream.get "/unidades/:id" Handlers.unid;
         Dream.get "/institutos" @@ Handlers.institutes;
         Dream.get "/institutos/:id" @@ Handlers.institute;
         Dream.get "/institutos/:id/modificar" @@ Handlers.institute_form;
         Dream.post "/institutos/:id/modificar" @@ Handlers.institute_form;
         Dream.get "/entidades" @@ Handlers.entities;
         Dream.get "/entidades/:id" @@ Handlers.entity;
         Dream.get "/programas" @@ Handlers.programs;
         Dream.get "/programas/:id" @@ Handlers.programs_id;
         Dream.get "/assets/**" @@ Dream.static "./assets";
       ]
