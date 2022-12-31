let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.home;
         Dream.get "/projetos" @@ Handlers.projects;
         Dream.post "/projetos" @@ Handlers.search_projects_kw;
         Dream.get "/projetos/:id" @@ Handlers.project_id;
         Dream.get "/projetos/:id/financiamento" @@ Handlers.project_id_entities;
         Dream.get "/contratos/:id" @@ Handlers.contract_id;
         Dream.get "/dominios" Handlers.domains;
         Dream.get "/dominios/:id" Handlers.domain_id;
         Dream.get "/areas" Handlers.areas;
         Dream.get "/areas/:id" Handlers.area_id;
         Dream.get "/investigadores" @@ Handlers.investigators;
         Dream.get "/investigadores/:id" @@ Handlers.investigator_id;
         Dream.get "/unidades" Handlers.unids;
         Dream.get "/unidades/:id" Handlers.unid_id;
         Dream.get "/institutos" @@ Handlers.institutes;
         Dream.get "/institutos/:id" @@ Handlers.institute_id;
         Dream.get "/institutos/:id/modificar" @@ Handlers.modify_institute;
         Dream.post "/institutos/:id/modificar" @@ Handlers.modify_institute_form;
         Dream.get "/entidades" @@ Handlers.entities;
         Dream.get "/entidades/:id" @@ Handlers.entity_id;
         Dream.get "/programas" @@ Handlers.programs;
         Dream.get "/programas/:id" @@ Handlers.program_id;
         Dream.get "/assets/**" @@ Dream.static "./assets";
       ]
