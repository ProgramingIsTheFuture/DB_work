open Async_kernel
open Async_unix
open Templates

let conn =
  let host = "localhost" in
  let db = "bd" in
  let user = "sa" in
  let password = "yourStrong(#)Password" in
  let port = Some 1433 in
  Mssql.with_conn ~host ~db ~user ~password ?port

let query ?(params : Mssql.Param.t list = []) q =
  Thread_safe.block_on_async_exn @@ fun () ->
  let param = List.map (fun a -> Some a) params in
  conn (fun db -> Mssql.execute ~params:param db q) >>| function
  | [] -> []
  | rows ->
      List.map Mssql.Row.to_alist rows
      |> List.map
           (List.fold_left
              (fun ctx (name, value) -> Types.SMap.add name value ctx)
              Types.empty)

let home _request = serve home "Gestão de Projetos UBI"

let projects _req =
  serve (projects (query "SELECT id, nome FROM Projeto;")) "Projetos / Contratos"

let investigators _req = serve investigadores "Investigadores"
let institute _req = serve institutes "Institutos"
let entities _req = serve entities "Entidades"

let projects_id req =
  let id = (Dream.param req "id" |> int_of_string)
  in
  let result =
    query
      ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM projeto P WHERE id = $1"
    |> List.hd
  in
let result2 =
    query
      ~params:[ Mssql.Param.Int id ]
      "SELECT K.id, K.keyword FROM projeto P, keywords K \
      WHERE P.id = $1 AND P.id \
       = K.projectId;"
  in
let result3 =
    query
      ~params:[ Mssql.Param.Int id ]
      "SELECT Pub.nomeJornal, Pub.id, Pub.url, Pub.doi FROM Projeto P, Publicacao Pub \
      WHERE P.id = $1 AND P.id = Pub.projectId"
  in
let result4 =
    query
      ~params:[ Mssql.Param.Int id ]
      "SELECT I.id as Iid, I.nome as Inome, Pl.designacao as papel \ 
      FROM Projeto P \
      INNER JOIN Participa PI ON P.id = PI.projectId \
      INNER JOIN Investigador I ON PI.investigadorId = I.id \
      INNER JOIN Papel Pl ON PI.papelId = Pl.id \
      WHERE P.id = $1"
  in
let result5 =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT DISTINCT AC.designacao as area, D.designacao as dominio FROM Projeto P \
      INNER JOIN AreaProjeto AP ON P.id = AP.projectId \
      INNER JOIN AreaCientifica AC ON AP.areaCientificaId = AC.id \
      INNER JOIN Dominio D ON AC.dominioId = D.id \
      WHERE P.id = $1"
  in
  serve (project result id result2 result3 result4 result5) "Projetos"

let projects_id_entities req =
  let id = (Dream.param req "id" |> int_of_string)
  in
  let result =
    query
      ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM projeto P WHERE id = $1"
    |> List.hd
  in
  let result2 =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT C.id, C.nome FROM Contrato C \
      INNER JOIN Projeto P ON C.projectId = P.id \
      WHERE P.id = $1"
  in
  serve (project_entities result result2) "Projetos"

let inves_test _req = serve "" "Investigadores"
