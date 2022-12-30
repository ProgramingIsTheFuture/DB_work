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
  | `Ok ["keyword", keyword] -> begin 
      let projetos = 
        query ~params:[ Mssql.Param.String keyword]
          "SELECT P.id, P.nome FROM Projeto P
           INNER JOIN Keyword K ON P.id = K.projetoId
           WHERE K.keyword LIKE CONCAT('%', $1, '%')"
      in
      serve (search_projects projetos keyword) "Projetos"
  end
  | _ ->
      (*Change to a "error message"*)
      let projetos = 
        query ~params:[ Mssql.Param.String "Fields"]
          "SELECT P.id, P.nome, K.keyword FROM Projeto P
           INNER JOIN Keyword K ON P.id = K.projetoId
           WHERE K.keyword LIKE $1"
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
      "SELECT K.id, K.keyword FROM projeto P, keyword K 
       WHERE P.id = $1 AND P.id = K.projetoId;"
  in
  let publicacoes =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT Pub.nomeJornal, Pub.id, Pub.url, Pub.doi 
       FROM Projeto P, Publicacao Pub 
       WHERE P.id = $1 AND P.id = Pub.projetoId"
  in
  let investigadores =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT I.id as Iid, I.nome as Inome, Pl.designacao as papel 
       FROM Projeto P 
       INNER JOIN Participa PI ON P.id = PI.projetoId 
       INNER JOIN Investigador I ON PI.investigadorId = I.id 
       INNER JOIN Papel Pl ON PI.papelId = Pl.id 
       WHERE P.id = $1"
  in
  let areas_dominios =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT AC.designacao as area, D.designacao as dominio 
       FROM Projeto P 
       INNER JOIN AreaProjeto AP ON P.id = AP.projetoId 
       INNER JOIN AreaCientifica AC ON AP.areaCientificaId = AC.id 
       INNER JOIN Dominio D ON AC.dominioId = D.id 
       WHERE P.id = $1"
  in
  let status =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT designacao FROM Status S 
       INNER JOIN Projeto P ON P.statusId = S.id 
       WHERE P.id = $1"
  in
  let historico_status =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT HS.id, S.designacao, HS.data FROM HistoricoStatus HS 
       INNER JOIN Projeto P ON HS.projetoId = P.id 
       INNER JOIN Status S ON HS.statusId = S.id 
       WHERE P.id = $1"
  in
  serve
    (project proj id keywords publicacoes investigadores areas_dominios status historico_status)
    "Projetos"

let project_id_entities req =
  let id = Dream.param req "id" |> int_of_string in
  let proj =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM projeto P WHERE id = $1"
    |> List.hd
  in
  let contrato =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT C.id, C.nome FROM Contrato C 
      INNER JOIN Projeto P ON C.projetoId = P.id 
      WHERE P.id = $1"
  in
  let entidades =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT E.id, E.nome FROM Entidade E 
       INNER JOIN Entigrama EP ON EP.entidadeId = E.id 
       INNER JOIN Programa Pr ON EP.programaId = Pr.id
       INNER JOIN Projama PP ON PP.programaId = Pr.id
       INNER JOIN Projeto P ON PP.projetoId = P.id 
       WHERE P.id = $1"
  in
  let programas =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT Pr.id, Pr.designacao FROM Programa Pr 
       INNER JOIN Projama PP ON PP.programaId = Pr.id 
       INNER JOIN Projeto P ON PP.projetoId = P.id 
       WHERE P.id = $1"
  in
  serve (project_entities proj contrato entidades programas) "Projetos"

let contract_id req =
  let id = Dream.param req "id" |> int_of_string in
  let cont =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT C.*, S.designacao as estado FROM Contrato C, Status S 
       WHERE C.id = $1 and C.statusId = S.id"
    |> List.hd
  in
  let projeto =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM Projeto P 
       INNER JOIN Contrato C ON P.id = C.projetoId 
       WHERE C.id = $1"
  in
  serve (contract cont projeto) "Contratos"

let domains _req =
  serve (domains (query "SELECT * FROM Dominio")) "Domínios"

let domain_id req =
  let dominio_area =
    query ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT D.id as Did, D.designacao, A.id, A.designacao as Adesignacao FROM Dominio D
      INNER JOIN AreaCientifica A ON D.id = A.dominioId
      WHERE D.id = $1"
  in
  serve (domain dominio_area) "Dominio"

let areas _req =
  let areamaior =
    query 
      "SELECT A.id, A.designacao, count(P.id) FROM AreaCientifica A, AreaProjeto AP, Projeto P
      WHERE A.id = AP.areaCientificaId
      AND AP.projetoId = P.id
      GROUP BY A.id, A.designacao
      ORDER BY count(P.id) DESC"
  in
  serve (areas (query "SELECT * FROM AreaCientifica") areamaior) "Áreas Científicas"

let area_id req =
  let id = Dream.param req "id" |> int_of_string in
  let area_c =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM AreaCientifica AC WHERE AC.id = $1"
  in
  let dominio =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT D.id, D.designacao FROM AreaCientifica AC 
      INNER JOIN Dominio D ON AC.dominioId = D.id
      WHERE AC.id = $1"
  in
  let projetos =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM AreaCientifica AC
      INNER JOIN AreaProjeto AP ON AC.id = AP.areaCientificaId
      INNER JOIN Projeto P ON AP.projetoId = P.id
      WHERE AC.id = $1"
  in
  serve (area area_c dominio projetos) "Áreas Científica"

let investigators _req =
  serve (investigadores (query "SELECT * FROM investigador;")) "Investigadores"

let investigator_id req =
  let id = Dream.param req "id" |> int_of_string in
  let invest =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT Inves.*, Inst.designacao as instituto FROM Investigador Inves \
       INNER JOIN Instituto Inst ON Inves.institutoId = Inst.id 
       WHERE Inves.id = $1;"
    |> List.hd
  in
  let unidades =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT U.id, U.nome FROM Investigador I
       INNER JOIN UnidadeInvestigador UI ON I.id = UI.investigadorId 
       INNER JOIN UnidadeInvestigacao U ON UI.unidadeInvestigacaoId = U.id 
       WHERE I.id = $1"
  in
  let projetos =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome, Pap.designacao, Par.tempoPerc FROM Investigador I 
       INNER JOIN Participa Par ON I.id = Par.investigadorId 
       INNER JOIN Projeto P ON Par.projetoId = P.id 
       INNER JOIN Papel Pap ON Par.papelId = Pap.id
       WHERE I.id = $1"
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
      "SELECT U.nome as Unome, I.id, I.nome as Inome FROM UnidadeInvestigacao U
       INNER JOIN UnidadeInvestigador UI ON U.id = UI.unidadeInvestigacaoId 
       INNER JOIN Investigador I ON UI.investigadorId = I.id 
       WHERE U.id = $1;"
  in
  serve (unidade unid) "Instituto"

let institutes _req =
  serve
    (institutes (query "SELECT id, designacao FROM instituto;"))
    "Institutos"

let institute_id req =
  let instituto =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT Inst.id as InstId, Inst.designacao, Invs.id, Invs.nome FROM instituto Inst 
       INNER JOIN Investigador Invs ON Inst.id = Invs.institutoId 
       WHERE Inst.id = $1;"
  in
  serve (institute instituto) "Instituto"

let entities _req =
  let bigger =
    query
      "SELECT TOP 1 E.id, E.nome, sum(EP.valor) as total FROM Entidade E
      INNER JOIN Entigrama EP ON E.id = EP.entidadeId
      GROUP BY E.id, E.nome
      ORDER BY sum(EP.valor) DESC"
  in
  let extbigger =
    query
      "SELECT TOP 1 E.id, E.nome, count(DISTINCT P.id) as numero FROM Entidade E
      INNER JOIN Entigrama EP ON E.id = EP.entidadeId
      INNER JOIN Programa Pr ON EP.programaId = Pr.id
      INNER JOIN Projama PP ON Pr.id = PP.programaId
      INNER JOIN Projeto P ON PP.projetoId = P.id
      WHERE E.nacional = 0
      GROUP BY E.id, E.nome
      ORDER BY count(P.id) DESC" 
  in
  serve
    (entities (query "SELECT id, nome, designacao FROM entidade;") bigger extbigger)
    "Entidades"

let entity_id req =
  let id = (Dream.param req "id" |> int_of_string) in
  let programas =
    query
      ~params:[ Mssql.Param.Int id ]
      "SELECT P.id as Pid, P.designacao as pdesignacao, EP.valor, E.* FROM Entidade E 
       INNER JOIN Entigrama EP ON E.id = EP.entidadeId 
       INNER JOIN Programa P ON EP.programaId = P.id 
       WHERE E.id = $1;"
  in
  let projects =
    query
      ~params:[ Mssql.Param.Int id ]
      "SELECT DISTINCT Proj.id, Proj.nome FROM Entigrama EP 
       INNER JOIN Programa P ON EP.programaId = P.id 
       INNER JOIN Projama PJ ON PJ.programaId = P.id 
       INNER JOIN Projeto Proj ON Proj.id = PJ.projetoId 
       WHERE EP.entidadeId = $1;"
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
      "SELECT E.id, E.nome, EP.valor FROM Programa Pr 
       INNER JOIN Entigrama EP ON Pr.id = EP.programaId 
       INNER JOIN Entidade E ON EP.entidadeId = E.id 
       WHERE Pr.id = $1"
  in
  let projetos =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM Programa Pr 
       INNER JOIN Projama PP ON Pr.id = PP.programaId 
       INNER JOIN Projeto P ON PP.projetoId = P.id 
       WHERE Pr.id = $1"
  in
  serve (program programa entidades projetos) "Programas"

let institute_form request =
  match%lwt Dream.form request with
  | `Ok _ -> serve (Templates.institute_form request (Some "Tudo fixe")) "Institutos"
  | _ ->
      (*Change to a "error message"*)
      serve (Templates.institute_form request (Some "Deu merda")) "Institutos"

