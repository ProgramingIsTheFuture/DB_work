let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.serve Pages.home "Gestão de Projetos UBI";
         Dream.get "/projetos" @@ Handlers.serve Pages.projetos "Projetos";
         (*Dream.get "/contratos"*)
         Dream.get "/investigadores" @@ Handlers.serve Pages.investigadores "Investigadores";
         Dream.get "/assets/**" @@ Dream.static "./assets"
       ]
