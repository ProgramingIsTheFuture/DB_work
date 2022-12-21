open Async_kernel
open Async_unix
open Users

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
  | rows -> List.map Mssql.Row.to_alist rows

let find_row nameval row =
  List.find (fun (name, _) -> name = nameval) row |> snd

let user_of_row (row : (string * string) list) =
  let id = find_row "id" row |> int_of_string in
  let name = find_row "name" row in
  { id; name }

let users_of_row = List.map user_of_row
let home _request = Dream.html @@ Pages.base "Gestão de Projetos UBI" Pages.home
let serve page name _request = Dream.html @@ Pages.base name page 


