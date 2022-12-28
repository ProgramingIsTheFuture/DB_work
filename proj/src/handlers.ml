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

let home request = serve (home request None) "Gestão de Projetos UBI"

let projects _req =
  serve
    (projects
       (query
          "SELECT C.id as Cid, C.nome as contrato, P.* FROM Projeto P, \
           Contrato C WHERE P.id = C.projectId;"))
    "Projetos / Contratos"

let investigators _req =
  serve (investigadores (query "SELECT * FROM investigador;")) "Investigadores"

let investigator req =
  let id = Dream.param req "id" |> int_of_string in
  let result =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT inves.*, inst.designacao as instituto FROM investigador inves \
       inner join instituto inst ON inves.institutoId = inst.id WHERE inves.id \
       = $1;"
    |> List.hd
  in
  let result2 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT U.id, U.nome FROM Investigador I INNER JOIN UnidadeInvestigador \
       UI ON I.id = UI.investigadorId INNER JOIN UnidadeInvestigacao U ON \
       UI.unidadeInvestigacaoId = U.id WHERE I.id = $1"
  in
  let result3 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome, Pap.designacao, Par.tempoPerc FROM Investigador I \
       INNER JOIN Participa Par ON I.id = Par.investigadorId INNER JOIN \
       Projeto P ON Par.projectId = P.id INNER JOIN Papel Pap ON Par.papelId = \
       Pap.id WHERE I.id = $1"
  in
  serve (investigador result result2 result3) "Investigador"

let unids _req =
  serve
    (unidades (query "SELECT id, nome FROM UnidadeInvestigacao;"))
    "Unidades"

let unid req =
  let result =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT U.nome as Unome, I.id, I.nome as Inome FROM UnidadeInvestigacao \
       U INNER JOIN UnidadeInvestigador UI ON U.id = UI.unidadeInvestigacaoId \
       INNER JOIN Investigador I ON UI.investigadorId = I.id WHERE U.id = $1;"
  in
  serve (unidade result) "Instituto"

let institutes _req =
  serve
    (institutes (query "SELECT id, designacao FROM instituto;"))
    "Institutos"

let institute req =
  let result =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT Inst.designacao, Invs.id, Invs.nome FROM instituto Inst INNER \
       JOIN Investigador Invs ON Inst.id = Invs.institutoId AND Inst.id = $1;"
  in
  serve (institute result) "Instituto"

let entities _req =
  serve
    (entities (query "SELECT id, nome, designacao FROM entidade;"))
    "Entidades"

let entity req =
  let programas =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT P.id as Pid, P.designacao as pdesignacao, E.* FROM Entidade E \
       INNER JOIN Entigrama EP ON E.id = EP.entidadeId INNER JOIN Programa P \
       ON EP.programId = P.id WHERE E.id = $1;"
  in
  let projects =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT DISTINCT Proj.id, Proj.nome FROM Entigrama EP INNER JOIN \
       Programa P ON EP.programId = P.id INNER JOIN Projama PJ ON PJ.programId \
       = P.id INNER JOIN Projeto Proj ON Proj.id = PJ.projectId WHERE \
       EP.entidadeId = $1;"
  in
  serve (entity programas projects) "Instituto"

let programs _req =
  serve (programs (query "SELECT id, designacao FROM Programa;")) "Programas"

let projects_id req =
  let id = Dream.param req "id" |> int_of_string in
  let result =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM projeto P WHERE id = $1"
    |> List.hd
  in
  let result2 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT K.id, K.keyword FROM projeto P, keywords K WHERE P.id = $1 AND \
       P.id = K.projectId;"
  in
  let result3 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT Pub.nomeJornal, Pub.id, Pub.url, Pub.doi FROM Projeto P, \
       Publicacao Pub WHERE P.id = $1 AND P.id = Pub.projectId"
  in
  let result4 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT I.id as Iid, I.nome as Inome, Pl.designacao as papel FROM \
       Projeto P INNER JOIN Participa PI ON P.id = PI.projectId INNER JOIN \
       Investigador I ON PI.investigadorId = I.id INNER JOIN Papel Pl ON \
       PI.papelId = Pl.id WHERE P.id = $1"
  in
  let result5 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT AC.designacao as area, D.designacao as dominio FROM \
       Projeto P INNER JOIN AreaProjeto AP ON P.id = AP.projectId INNER JOIN \
       AreaCientifica AC ON AP.areaCientificaId = AC.id INNER JOIN Dominio D \
       ON AC.dominioId = D.id WHERE P.id = $1"
  in
  let result6 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT designacao FROM Status S INNER JOIN Projeto P ON P.statusId = \
       S.id WHERE P.id = $1"
  in
  let result7 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT HS.id, S.designacao, HS.data FROM HistoricoStatus HS INNER JOIN \
       Projeto P ON HS.projectId = P.id INNER JOIN Status S ON HS.statusId = \
       S.id WHERE P.id = $1"
  in
  serve
    (project result id result2 result3 result4 result5 result6 result7)
    "Projetos"

let projects_id_entities req =
  let id = Dream.param req "id" |> int_of_string in
  let result =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM projeto P WHERE id = $1"
    |> List.hd
  in
  let result2 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT C.id, C.nome FROM Contrato C INNER JOIN Projeto P ON C.projectId \
       = P.id WHERE P.id = $1"
  in
  let result3 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT E.id, E.nome FROM Entidade E INNER JOIN Entigrama EP ON \
       EP.entidadeId = E.id INNER JOIN Programa Pr ON EP.programId = Pr.id \
       INNER JOIN Projama PP ON PP.programId = Pr.id INNER JOIN Projeto P ON \
       PP.projectId = P.id WHERE P.id = $1"
  in
  let result4 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT Pr.id, Pr.designacao FROM Programa Pr INNER JOIN \
       Projama PP ON PP.programId = Pr.id INNER JOIN Projeto P ON PP.projectId \
       = P.id WHERE P.id = $1"
  in
  serve (project_entities result result2 result3 result4) "Projetos"

let contracts_id req =
  let id = Dream.param req "id" |> int_of_string in
  let result =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT C.*, S.designacao as estado FROM Contrato C, Status S WHERE C.id \
       = $1 and C.statusId = S.id"
    |> List.hd
  in
  let result2 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM Projeto P INNER JOIN Contrato C ON P.id = \
       C.projectId WHERE C.id = $1"
  in
  serve (contract result result2) "Contratos"

let programs_id req =
  let id = Dream.param req "id" |> int_of_string in
  let result =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM Programa P WHERE P.id = $1"
  in
  let result2 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT E.id, E.nome FROM Programa Pr INNER JOIN Entigrama EP ON Pr.id = \
       EP.programId INNER JOIN Entidade E ON EP.entidadeId = E.id WHERE Pr.id \
       = $1"
  in
  let result3 =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM Programa Pr INNER JOIN Projama PP ON Pr.id = \
       PP.programId INNER JOIN Projeto P ON PP.projectId = P.id WHERE Pr.id = \
       $1"
  in
  serve (program result result2 result3) "Programas"

let example request =
  match%lwt Dream.form request with
  | `Ok _ -> serve (Templates.home request (Some ("Tudo fixe", 0))) "Home"
  | _ ->
      (*Change to a "error message"*)
      serve (Templates.home request (Some ("Deu merda", 1))) "Home"

let inves_test _req = serve "" "Investigadores"
