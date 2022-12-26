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
  serve (projects (query "SELECT * FROM projeto;")) "Projetos / Contratos"

let investigators _req =
  serve (investigadores (query "SELECT * FROM investigador;")) "Investigadores"

let investigator req =
  let result =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT inves.*, inst.designacao as instituto FROM investigador inves \
       inner join instituto inst ON inves.institutoId = inst.id WHERE inves.id \
       = $1;"
    |> List.hd
  in

  serve (investigador result) "Investigador"

let institute _req = serve institutes "Institutos"
let entities _req = serve entities "Entidades"

let projects_id req =
  let result =
    query ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ] ""
    |> List.hd
  in
  serve (project result) "Projetos"

let inves_test _req = serve "" "Investigadores"
