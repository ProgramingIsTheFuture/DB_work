let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router [ Dream.get "/" Handlers.home ]
