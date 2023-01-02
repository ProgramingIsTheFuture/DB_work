let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.home;
         (* Projetos *)
         Dream.get "/projetos" @@ Handlers.projects;
         Dream.post "/projetos" @@ Handlers.search_projects_kw;
         Dream.get "/projetos/:id" @@ Handlers.project_id;
         Dream.get "/projetos/:id/modificar" @@ Handlers.project_id_modify;
         Dream.post "/projetos/:id/modificar" @@ Handlers.project_id_modify_post;
         Dream.get "/projetos/:id/financiamento" @@ Handlers.project_id_entities;
         (* Contratos *)
         Dream.get "/contratos/:id" @@ Handlers.contract_id;
         (* Dominios *)
         Dream.get "/dominios" Handlers.domains;
         Dream.get "/dominios/:id" Handlers.domain_id;
         ( Dream.get "/dominios/:id/modificar" @@ fun a ->
           Handlers.modify_domain a None );
         Dream.post "/dominios/:id/modificar" @@ Handlers.modify_domain_form;
         (* Areas *)
         Dream.get "/areas" Handlers.areas;
         Dream.get "/areas/:id" Handlers.area_id;
         ( Dream.get "/areas/:id/modificar" @@ fun a ->
           Handlers.modify_area a None );
         Dream.post "/areas/:id/modificar" @@ Handlers.modify_area_form;
         (* Investigador *)
         Dream.get "/investigadores" @@ Handlers.investigators;
         Dream.get "/investigadores/:id" @@ Handlers.investigator_id;
         Dream.get "/investigadores/:id/modificar"
         @@ Handlers.investigator_id_modificar;
         Dream.post "/investigadores/:id/modificar"
         @@ Handlers.investigator_id_modificar_post;
         Dream.get "/investigadores/:id/unidade/modificar"
         @@ Handlers.investigator_id_modificar;
         Dream.post "/investigadores/:id/unidade/modificar"
         @@ Handlers.unidade_investigador_id_modificar_post;
         (* Unidades *)
         Dream.get "/unidades" Handlers.unids;
         Dream.get "/unidades/:id" Handlers.unid_id;
         ( Dream.get "/unidades/:id/modificar" @@ fun a ->
           Handlers.modify_unid a None );
         Dream.post "/unidades/:id/modificar" @@ Handlers.modify_unid_form;
         (* Institutos *)
         Dream.get "/institutos" @@ Handlers.institutes;
         Dream.get "/institutos/:id" @@ Handlers.institute_id;
         ( Dream.get "/institutos/:id/modificar" @@ fun a ->
           Handlers.modify_institute a None );
         Dream.post "/institutos/:id/modificar"
         @@ Handlers.modify_institute_form;
         (* Entidades *)
         Dream.get "/entidades" @@ Handlers.entities;
         Dream.get "/entidades/:id" @@ Handlers.entity_id;
         (* Programas *)
         ( Dream.get "/entidades/:id/modificar" @@ fun a ->
           Handlers.modify_entity a None );
         Dream.post "/entidades/:id/modificar" @@ Handlers.modify_entity_form;
         Dream.get "/programas" @@ Handlers.programs;
         Dream.get "/programas/:id" @@ Handlers.program_id;
         ( Dream.get "/programas/:id/modificar" @@ fun a ->
           Handlers.modify_program a None );
         Dream.post "/programas/:id/modificar" @@ Handlers.modify_area_form;
         Dream.get "/assets/**" @@ Dream.static "./assets";
       ]
