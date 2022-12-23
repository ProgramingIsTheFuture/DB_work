open Async_kernel
open Async_unix

let conn =
  let host = "localhost" in
  let db = "abc" in
  let user = "sa" in
  let password = "super(#)password" in
  let port = Some 1433 in
  Mssql.with_conn ~host ~db ~user ~password ?port

let query q =
  Thread_safe.block_on_async_exn @@ fun () ->
  conn (fun db -> Mssql.execute db q) >>| function
  | [] -> []
  | rows ->
      List.map Mssql.Row.to_alist rows
      |> List.map
           (List.fold_left
              (fun ctx (name, value) -> Types.SMap.add name value ctx)
              Types.empty)

let home _request = Dream.html @@ Pages.base "Gestão de Projetos UBI" Pages.home
let serve page name _request = Dream.html @@ Pages.base name page
