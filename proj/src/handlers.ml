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

let home _req = serve home "Gestão de Projetos UBI"

let projects req =
  serve
    (projects req
       (query
          "SELECT C.id as Cid, C.nome as contrato, P.* FROM Projeto P, \
           Contrato C WHERE P.id = C.projetoId;"))
    "Projetos / Contratos"

let search_projects_kw request =
  match%lwt Dream.form request with
  | `Ok [ ("keyword", keyword) ] ->
      let projetos =
        query
          ~params:[ Mssql.Param.String keyword ]
          "SELECT P.id, P.nome FROM Projeto P\n\
          \           INNER JOIN Keyword K ON P.id = K.projetoId\n\
          \           WHERE K.keyword LIKE CONCAT('%', $1, '%')"
      in
      serve (search_projects projetos keyword) "Projetos"
  | _ ->
      (*Change to a "error message"*)
      let projetos =
        query
          ~params:[ Mssql.Param.String "Fields" ]
          "SELECT P.id, P.nome, K.keyword FROM Projeto P\n\
          \           INNER JOIN Keyword K ON P.id = K.projetoId\n\
          \           WHERE K.keyword LIKE $1"
      in
      serve (search_projects projetos "Fields") "Projetos"

let project_id req =
  let id = Dream.param req "id" |> int_of_string in
  let proj =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM projeto P WHERE id = $1"
    |> List.hd
  in
  let keywords =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT K.id, K.keyword FROM projeto P, keyword K \n\
      \       WHERE P.id = $1 AND P.id = K.projetoId;"
  in
  let publicacoes =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT Pub.nomeJornal, Pub.id, Pub.url, Pub.doi \n\
      \       FROM Projeto P, Publicacao Pub \n\
      \       WHERE P.id = $1 AND P.id = Pub.projetoId"
  in
  let investigadores =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT I.id as Iid, I.nome as Inome, Pl.designacao as papel \n\
      \       FROM Projeto P \n\
      \       INNER JOIN Participa PI ON P.id = PI.projetoId \n\
      \       INNER JOIN Investigador I ON PI.investigadorId = I.id \n\
      \       INNER JOIN Papel Pl ON PI.papelId = Pl.id \n\
      \       WHERE P.id = $1"
  in
  let areas_dominios =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT AC.designacao as area, D.designacao as dominio \n\
      \       FROM Projeto P \n\
      \       INNER JOIN AreaProjeto AP ON P.id = AP.projetoId \n\
      \       INNER JOIN AreaCientifica AC ON AP.areaCientificaId = AC.id \n\
      \       INNER JOIN Dominio D ON AC.dominioId = D.id \n\
      \       WHERE P.id = $1"
  in
  let status =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT designacao FROM Status S \n\
      \       INNER JOIN Projeto P ON P.statusId = S.id \n\
      \       WHERE P.id = $1"
  in
  let historico_status =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT HS.id, S.designacao, HS.data FROM HistoricoStatus HS \n\
      \       INNER JOIN Projeto P ON HS.projetoId = P.id \n\
      \       INNER JOIN Status S ON HS.statusId = S.id \n\
      \       WHERE P.id = $1"
  in
  serve
    (project proj id keywords publicacoes investigadores areas_dominios status
       historico_status)
    "Projetos"

let project_id_entities req =
  let id = Dream.param req "id" |> int_of_string in
  let proj =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM projeto P WHERE id = $1"
    |> List.hd
  in
  let contrato =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT C.id, C.nome FROM Contrato C \n\
      \      INNER JOIN Projeto P ON C.projetoId = P.id \n\
      \      WHERE P.id = $1"
  in
  let entidades =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT E.id, E.nome FROM Entidade E \n\
      \       INNER JOIN Entigrama EP ON EP.entidadeId = E.id \n\
      \       INNER JOIN Programa Pr ON EP.programaId = Pr.id\n\
      \       INNER JOIN Projama PP ON PP.programaId = Pr.id\n\
      \       INNER JOIN Projeto P ON PP.projetoId = P.id \n\
      \       WHERE P.id = $1"
  in
  let programas =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT Pr.id, Pr.designacao FROM Programa Pr \n\
      \       INNER JOIN Projama PP ON PP.programaId = Pr.id \n\
      \       INNER JOIN Projeto P ON PP.projetoId = P.id \n\
      \       WHERE P.id = $1"
  in
  serve (project_entities proj contrato entidades programas) "Projetos"

let contract_id req =
  let id = Dream.param req "id" |> int_of_string in
  let cont =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT C.*, S.designacao as estado FROM Contrato C, Status S \n\
      \       WHERE C.id = $1 and C.statusId = S.id"
    |> List.hd
  in
  let projeto =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM Projeto P \n\
      \       INNER JOIN Contrato C ON P.id = C.projetoId \n\
      \       WHERE C.id = $1"
  in
  serve (contract cont projeto) "Contratos"

let domains _req = serve (domains (query "SELECT * FROM Dominio")) "Domínios"

let domain_id req =
  let dominio_area =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT D.id as Did, D.designacao, A.id, A.designacao as Adesignacao \
       FROM Dominio D\n\
      \      INNER JOIN AreaCientifica A ON D.id = A.dominioId\n\
      \      WHERE D.id = $1"
  in
  serve (domain dominio_area) "Dominio"

let modify_domain req _message =
  let institute =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT id, designacao FROM Dominio WHERE id = $1"
    |> List.hd
  in
  serve (domain_form req institute _message) "Domínio"

let modify_domain_form request =
  let id = Dream.param request "id" |> int_of_string in
  match%lwt Dream.form request with
  | `Ok [ ("designacao", des) ] ->
      query
        ~params:[ Mssql.Param.String des; Mssql.Param.Int id ]
        "UPDATE Dominio SET designacao = $1 WHERE id = $2"
      |> ignore;
      (* List.map (fun (s, v) -> Dream.log "%s: %s\n\n" s v) tl |> ignore; *)
      modify_domain request (Some "Sucesso!")
  | _ -> modify_domain request (Some "Erro!")

let areas _req =
  let areamaior =
    query
      "SELECT A.id, A.designacao, count(P.id) FROM AreaCientifica A, \
       AreaProjeto AP, Projeto P\n\
      \      WHERE A.id = AP.areaCientificaId\n\
      \      AND AP.projetoId = P.id\n\
      \      GROUP BY A.id, A.designacao\n\
      \      ORDER BY count(P.id) DESC"
  in
  serve
    (areas (query "SELECT * FROM AreaCientifica") areamaior)
    "Áreas Científicas"

let area_id req =
  let id = Dream.param req "id" |> int_of_string in
  let area_c =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM AreaCientifica AC WHERE AC.id = $1"
  in
  let dominio =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT D.id, D.designacao FROM AreaCientifica AC \n\
      \      INNER JOIN Dominio D ON AC.dominioId = D.id\n\
      \      WHERE AC.id = $1"
  in
  let projetos =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM AreaCientifica AC\n\
      \      INNER JOIN AreaProjeto AP ON AC.id = AP.areaCientificaId\n\
      \      INNER JOIN Projeto P ON AP.projetoId = P.id\n\
      \      WHERE AC.id = $1"
  in
  serve (area area_c dominio projetos) "Áreas Científica"

let investigators _req =
  serve (investigadores (query "SELECT * FROM investigador;")) "Investigadores"

let investigator_id req =
  let id = Dream.param req "id" |> int_of_string in
  let invest =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT Inves.*, Inst.designacao as instituto FROM Investigador Inves \
       INNER JOIN Instituto Inst ON Inves.institutoId = Inst.id \n\
      \       WHERE Inves.id = $1;"
    |> List.hd
  in
  let unidades =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT U.id, U.nome FROM Investigador I\n\
      \       INNER JOIN UnidadeInvestigador UI ON I.id = UI.investigadorId \n\
      \       INNER JOIN UnidadeInvestigacao U ON UI.unidadeInvestigacaoId = \
       U.id \n\
      \       WHERE I.id = $1"
  in
  let projetos =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome, Pap.designacao, Par.tempoPerc FROM Investigador I \n\
      \       INNER JOIN Participa Par ON I.id = Par.investigadorId \n\
      \       INNER JOIN Projeto P ON Par.projetoId = P.id \n\
      \       INNER JOIN Papel Pap ON Par.papelId = Pap.id\n\
      \       WHERE I.id = $1"
  in
  serve (investigador invest unidades projetos) "Investigador"

let unids _req =
  serve
    (unidades (query "SELECT id, nome FROM UnidadeInvestigacao;"))
    "Unidades"

let unid_id req =
  let unid =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT U.nome as Unome, I.id, I.nome as Inome FROM UnidadeInvestigacao U\n\
      \       INNER JOIN UnidadeInvestigador UI ON U.id = \
       UI.unidadeInvestigacaoId \n\
      \       INNER JOIN Investigador I ON UI.investigadorId = I.id \n\
      \       WHERE U.id = $1;"
  in
  serve (unidade unid) "Unidade"

let institutes _req =
  serve
    (institutes (query "SELECT id, designacao FROM instituto;"))
    "Institutos"

let institute_id req =
  let instituto =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT Inst.id as InstId, Inst.designacao, Invs.id, Invs.nome FROM \
       instituto Inst \n\
      \       INNER JOIN Investigador Invs ON Inst.id = Invs.institutoId \n\
      \       WHERE Inst.id = $1;"
  in
  serve (institute instituto) "Instituto"

let modify_institute req _message =
  let institute =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT id, designacao FROM Instituto WHERE id = $1"
    |> List.hd
  in
  serve (institute_form req institute _message) "Institutos"

let modify_institute_form request =
  let id = Dream.param request "id" |> int_of_string in
  match%lwt Dream.form request with
  | `Ok [ ("designacao", des) ] ->
      query
        ~params:[ Mssql.Param.String des; Mssql.Param.Int id ]
        "UPDATE Instituto SET designacao = $1 WHERE id = $2"
      |> ignore;
      (* List.map (fun (s, v) -> Dream.log "%s: %s\n\n" s v) tl |> ignore; *)
      modify_institute request (Some "Sucesso!")
  | _ -> modify_institute request (Some "Erro!")

let entities _req =
  let bigger =
    query
      "SELECT TOP 1 E.id, E.nome, sum(EP.valor) as total FROM Entidade E\n\
      \      INNER JOIN Entigrama EP ON E.id = EP.entidadeId\n\
      \      GROUP BY E.id, E.nome\n\
      \      ORDER BY sum(EP.valor) DESC"
  in
  let extbigger =
    query
      "SELECT TOP 1 E.id, E.nome, count(DISTINCT P.id) as numero FROM Entidade E\n\
      \      INNER JOIN Entigrama EP ON E.id = EP.entidadeId\n\
      \      INNER JOIN Programa Pr ON EP.programaId = Pr.id\n\
      \      INNER JOIN Projama PP ON Pr.id = PP.programaId\n\
      \      INNER JOIN Projeto P ON PP.projetoId = P.id\n\
      \      WHERE E.nacional = 0\n\
      \      GROUP BY E.id, E.nome\n\
      \      ORDER BY count(P.id) DESC"
  in
  serve
    (entities
       (query "SELECT id, nome, designacao FROM entidade;")
       bigger extbigger)
    "Entidades"

let entity_id req =
  let id = Dream.param req "id" |> int_of_string in
  let programas =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id as Pid, P.designacao as pdesignacao, EP.valor, E.* FROM \
       Entidade E \n\
      \       INNER JOIN Entigrama EP ON E.id = EP.entidadeId \n\
      \       INNER JOIN Programa P ON EP.programaId = P.id \n\
      \       WHERE E.id = $1;"
  in
  let projects =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT Proj.id, Proj.nome FROM Entigrama EP \n\
      \       INNER JOIN Programa P ON EP.programaId = P.id \n\
      \       INNER JOIN Projama PJ ON PJ.programaId = P.id \n\
      \       INNER JOIN Projeto Proj ON Proj.id = PJ.projetoId \n\
      \       WHERE EP.entidadeId = $1;"
  in
  serve (entity programas projects) "Entidades"

let programs _req =
  serve (programs (query "SELECT id, designacao FROM Programa;")) "Programas"

let program_id req =
  let id = Dream.param req "id" |> int_of_string in
  let programa =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM Programa P WHERE P.id = $1"
  in
  let entidades =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT E.id, E.nome, EP.valor FROM Programa Pr \n\
      \       INNER JOIN Entigrama EP ON Pr.id = EP.programaId \n\
      \       INNER JOIN Entidade E ON EP.entidadeId = E.id \n\
      \       WHERE Pr.id = $1"
  in
  let projetos =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM Programa Pr \n\
      \       INNER JOIN Projama PP ON Pr.id = PP.programaId \n\
      \       INNER JOIN Projeto P ON PP.projetoId = P.id \n\
      \       WHERE Pr.id = $1"
  in
  serve (program programa entidades projetos) "Programas"
