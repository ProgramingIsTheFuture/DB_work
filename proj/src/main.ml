open Async_unix
open Async_kernel

let conn =
  let host = "localhost" in
  let db = "abc" in
  let user = "sa" in
  let password = "super(#)password" in
  let port = Some 1433 in
  Mssql.with_conn ~host ~db ~user ~password ?port

let home _request =
  let id =
    Thread_safe.block_on_async_exn @@ fun () ->
    conn (fun db -> Mssql.execute db "SELECT * FROM users;") >>| function
    | row :: _ ->
        let id = Mssql.Row.int_exn row "id" in
        id
    | _ -> assert false
  in
  Dream.html (Format.sprintf "<h1>%d</h1>" id)

let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router [ Dream.get "/" home ]
