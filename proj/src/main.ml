let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" @@ Handlers.serve Home.home "Gestão de Projetos UBI";
         Dream.get "/projetos" @@ Handlers.serve Home.projetos "Projetos";
         (*Dream.get "/contratos"*)
         Dream.get "/investigadores" @@ Handlers.serve Home.investigadores "Investigadores";
         Dream.get "/assets/**" @@ Dream.static "./assets"
       ]
