open Async_kernel
open Async_unix

type user = { id : string; name : string } [@@deriving yojson]

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

let () =
  let data = query "SELECT * FROM users;" in
  List.map (fun a -> yojson_of_list (fun (_, b2) -> yojson_of_string b2) a) data
  |> List.map user_of_yojson
  |> List.map (fun a -> Format.printf "%s %s" a.id a.name)
  |> ignore

let home _request = Dream.html (Format.sprintf "<h1>%d</h1>" 1)
