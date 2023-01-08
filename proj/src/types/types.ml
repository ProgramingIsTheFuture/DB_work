module SMap = Map.Make (String)

type data = string SMap.t

let empty : data = SMap.empty
let find s ctx = SMap.find_opt s ctx |> function Some s -> s | None -> ""
let ( <| ) ctx s = find s ctx
