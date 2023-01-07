let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.home;
         (* Projetos *)
         Dream.get "/projetos" @@ Handlers.projects;
         Dream.post "/projetos" @@ Handlers.search_projects_kw;
         Dream.get "/projetos/:id" @@ Handlers.project_id;
         ( Dream.get "/projetos/:id/modificar" @@ fun a ->
           Handlers.project_id_modify a None );
         Dream.post "/projetos/:id/modificar" @@ Handlers.project_id_modify_post;
         Dream.get "/projetos/:id/financiamento" @@ Handlers.project_id_entities;
         ( Dream.get "/projetos/0/adicionar" @@ fun a ->
           Handlers.add_project a None );
         Dream.post "/projetos/0/adicionar" @@ Handlers.add_project_form;
         ( Dream.get "/projetos/:id/remover" @@ fun a ->
           Handlers.delete_project a );
         ( Dream.get "/projetos/:id/novapublicacao" @@ fun a ->
           Handlers.add_publication a None );
         Dream.post "/projetos/:id/novapublicacao"
         @@ Handlers.add_publication_form;
         (* Contratos *)
         Dream.get "/contratos/:id" @@ Handlers.contract_id;
         ( Dream.get "/contratos/:id/modificar" @@ fun a ->
           Handlers.modify_contract a None );
         Dream.post "/contratos/:id/modificar" @@ Handlers.modify_contract_form;
         (* Publicações *)
         Dream.get "/publicacoes/:id" @@ Handlers.publication_id;
         ( Dream.get "/publicacoes/:id/modificar" @@ fun a ->
           Handlers.modify_publication a None );
         Dream.post "/publicacoes/:id/modificar"
         @@ Handlers.modify_publication_form;
         ( Dream.get "/publicacoes/:id/remover" @@ fun a ->
           Handlers.delete_publication a );
         (* Dominios *)
         Dream.get "/dominios" Handlers.domains;
         Dream.get "/dominios/:id" Handlers.domain_id;
         ( Dream.get "/dominios/:id/modificar" @@ fun a ->
           Handlers.modify_domain a None );
         Dream.post "/dominios/:id/modificar" @@ Handlers.modify_domain_form;
         ( Dream.get "/dominios/0/adicionar" @@ fun a ->
           Handlers.add_domain a None );
         Dream.post "/dominios/0/adicionar" @@ Handlers.add_domain_form;
         ( Dream.get "/dominios/:id/remover" @@ fun a ->
           Handlers.delete_domain a None );
         Dream.post "/dominios/:id/remover" @@ Handlers.delete_domain_form;
         (* Areas *)
         Dream.get "/areas" Handlers.areas;
         Dream.get "/areas/:id" Handlers.area_id;
         ( Dream.get "/areas/:id/modificar" @@ fun a ->
           Handlers.modify_area a None );
         Dream.post "/areas/:id/modificar" @@ Handlers.modify_area_form;
         (Dream.get "/areas/0/adicionar" @@ fun a -> Handlers.add_area a None);
         Dream.post "/areas/0/adicionar" @@ Handlers.add_area_form;
         (Dream.get "/areas/:id/remover" @@ fun a -> Handlers.delete_area a);
         (* Investigador *)
         Dream.get "/investigadores" @@ Handlers.investigators;
         Dream.get "/investigadores/0/adicionar"
         @@ Handlers.create_investigators;
         Dream.post "/investigadores/0/adicionar"
         @@ Handlers.create_investigators_post;
         Dream.get "/investigadores/:id" @@ Handlers.investigator_id;
         ( Dream.get "/investigadores/:id/modificar" @@ fun a ->
           Handlers.investigator_id_modificar a None );
         Dream.post "/investigadores/:id/modificar"
         @@ Handlers.investigator_id_modificar_post;
         Dream.get "/investigadores/:id/remover"
         @@ Handlers.investigador_id_delete;
         ( Dream.get "/investigadores/:id/unidade/modificar" @@ fun req ->
           Handlers.investigator_id_modificar req None );
         Dream.post "/investigadores/:id/unidade/modificar"
         @@ Handlers.unidade_investigador_id_modificar_post;
         Dream.get "/investigadores/:idi/participa/:idp/remover"
         @@ Handlers.participa_investigador_remove;
         (Dream.get "/investigadores/:id/participa/adicionar" @@ fun req ->
           Handlers.participa_investigador_id req None);
         Dream.post "/investigadores/:id/participa/adicionar"
         @@ Handlers.participa_investigador_id_post;
         (* Unidades *)
         Dream.get "/unidades" Handlers.unids;
         Dream.get "/unidades/:id" Handlers.unid_id;
         ( Dream.get "/unidades/:id/modificar" @@ fun a ->
           Handlers.modify_unid a None );
         Dream.post "/unidades/:id/modificar" @@ Handlers.modify_unid_form;
         (Dream.get "/unidades/0/adicionar" @@ fun a -> Handlers.add_unid a None);
         Dream.post "/unidades/0/adicionar" @@ Handlers.add_unid_form;
         (Dream.get "/unidades/:id/remover" @@ fun a -> Handlers.delete_unid a);
         (* Institutos *)
         Dream.get "/institutos" @@ Handlers.institutes;
         Dream.get "/institutos/:id" @@ Handlers.institute_id;
         ( Dream.get "/institutos/:id/modificar" @@ fun a ->
           Handlers.modify_institute a None );
         Dream.post "/institutos/:id/modificar"
         @@ Handlers.modify_institute_form;
         ( Dream.get "/institutos/0/adicionar" @@ fun a ->
           Handlers.add_institute a None );
         Dream.post "/institutos/0/adicionar" @@ Handlers.add_institute_form;
         ( Dream.get "/institutos/:id/remover" @@ fun a ->
           Handlers.delete_institute a );
         (* Entidades *)
         Dream.get "/entidades" @@ Handlers.entities;
         Dream.get "/entidades/:id" @@ Handlers.entity_id;
         ( Dream.get "/entidades/:id/modificar" @@ fun a ->
           Handlers.modify_entity a None );
         Dream.post "/entidades/:id/modificar" @@ Handlers.modify_entity_form;
         ( Dream.get "/entidades/0/adicionar" @@ fun a ->
           Handlers.add_entity a None );
         Dream.post "/entidades/0/adicionar" @@ Handlers.add_entity_form;
         ( Dream.get "/entidades/:id/remover" @@ fun a ->
           Handlers.delete_entity a );
         (* Programas *)
         Dream.get "/programas" @@ Handlers.programs;
         Dream.get "/programas/:id" @@ Handlers.program_id;
         ( Dream.get "/programas/:id/modificar" @@ fun a ->
           Handlers.modify_program a None );
         Dream.post "/programas/:id/modificar" @@ Handlers.modify_program_form;
         ( Dream.get "/programas/0/adicionar" @@ fun a ->
           Handlers.add_program a None );
         Dream.post "/programas/0/adicionar" @@ Handlers.add_program_form;
         ( Dream.get "/programas/:id/remover" @@ fun a ->
           Handlers.delete_program a );
         Dream.get "/assets/**" @@ Dream.static "./assets";
       ]
