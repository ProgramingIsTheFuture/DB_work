open Async_kernel
open Async_unix
open Templates

let conn =
  let host = "192.168.100.14" in
  let db = "BD_PL2_01" in
  let user = "User_BD_PL2_01" in
  let password = "diubi:2022!BD!PL2_01" in
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

let find_field tl nome =
  List.filter (fun (n, _) -> n = nome) tl |> List.hd |> snd

let rec get_str str = function
  | (x, y) :: xs ->
      (match (fun n -> str = n) x with true -> Some y | false -> None)
      :: get_str str xs
  | [] -> []

let add_record req records common_atr atribute intermediate_table end_table =
  match records with
  | [] -> ()
  | _ ->
      query
        ~params:
          [
            Mssql.Param.Int (Dream.param req "id" |> int_of_string);
            Mssql.Param.Array
              (records
              |> List.map (fun a -> Mssql.Param.Int (a |> int_of_string)));
          ]
        ("INSERT INTO " ^ intermediate_table ^ " (" ^ common_atr ^ ", "
       ^ atribute ^ " )\n            SELECT $1, T.id FROM " ^ end_table
       ^ " T WHERE T.id IN ($2)")
      |> ignore

let rec update_record req records common_atr atribute atribute2
    intermediate_table =
  match records with
  | [] -> ()
  | (p, v) :: xs ->
      query
        ~params:
          [
            Mssql.Param.Int p;
            Mssql.Param.Int v;
            Mssql.Param.Int (Dream.param req "id" |> int_of_string);
          ]
        ("UPDATE " ^ intermediate_table ^ " SET " ^ atribute2
       ^ " = $2 \n         WHERE " ^ common_atr ^ " = $3 AND " ^ atribute
       ^ " = $1")
      |> ignore;
      update_record req xs common_atr atribute atribute2 intermediate_table

let remove_record req records common_atr atribute intermediate_table =
  match records with
  | [] -> ()
  | _ ->
      query
        ~params:
          [
            Mssql.Param.Array
              (records
              |> List.map (fun a -> Mssql.Param.Int (a |> int_of_string)));
            Mssql.Param.Int (Dream.param req "id" |> int_of_string);
          ]
        ("DELETE FROM " ^ intermediate_table ^ " WHERE\n         " ^ common_atr
       ^ " = $2 AND " ^ atribute ^ " IN ($1)")
      |> ignore

let home _req = serve home "Gestão de Projetos UBI"

(* PROJETOS *)
let projects req =
  serve
    (projects req
       (query
          "SELECT C.id as Cid, C.nome as contrato, P.* FROM Projeto P, \
           Contrato C WHERE P.id = C.projetoId;"))
    "Projetos / Contratos"

let search_projects_kw req =
  match%lwt Dream.form req with
  | `Ok [ ("keyword", keyword) ] ->
      let projetos =
        query
          ~params:[ Mssql.Param.String keyword ]
          "SELECT P.id, P.nome FROM Projeto P\n\
          \           INNER JOIN Keyword K ON P.id = K.projetoId\n\
          \           WHERE K.designacao LIKE CONCAT('%', $1, '%')"
      in
      serve (search_projects None projetos keyword) "Projetos"
  | _ -> serve (search_projects (Some "Ocorreu um erro!") [] "") "Projetos"

let project_id req =
  let id = Dream.param req "id" |> int_of_string in
  let proj =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM projeto P WHERE id = $1"
    |> List.hd
  in
  let keywords =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT K.id, K.designacao FROM projeto P, keyword K \n\
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
      \       WHERE P.id = $1 ORDER BY data DESC"
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

let add_project req _message =
  let programas = query "SELECT * FROM Programa" in
  let status = query "SELECT * FROM Status" in
  let areas = query "SELECT * FROM AreaCientifica" in
  serve (project_add req programas status areas _message) "Projeto"

let add_project_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let nome = find_field tl "nome" in
      let titulo = find_field tl "titulo" in
      let descricao = find_field tl "descricao" in
      let portugues = find_field tl "portugues" in
      let ingles = find_field tl "ingles" in
      let data_ini = find_field tl "data_ini" in
      let data_fim = find_field tl "data_fim" in
      let url = find_field tl "url" in
      let doi = find_field tl "doi" in
      let status = find_field tl "status" in
      let nomeCont = find_field tl "nomeCont" in
      let tituloCont = find_field tl "tituloCont" in
      let descricaoCont = find_field tl "descricaoCont" in
      let statusCont = find_field tl "statusCont" |> int_of_string in
      let kw1 = find_field tl "keyword1" in
      let kw2 = find_field tl "keyword2" in
      let kw3 = find_field tl "keyword3" in
      let progs = List.filter_map (fun a -> a) (get_str "progs" tl) in
      let areas = List.filter_map (fun a -> a) (get_str "areas" tl) in
      query
        ~params:
          [
            Mssql.Param.String nome;
            Mssql.Param.String titulo;
            Mssql.Param.String descricao;
            Mssql.Param.String portugues;
            Mssql.Param.String ingles;
            Mssql.Param.String data_ini;
            Mssql.Param.String data_fim;
            Mssql.Param.String url;
            Mssql.Param.String doi;
            Mssql.Param.Int (status |> int_of_string);
          ]
        ("INSERT INTO Projeto \n\
         \        (nome, titulo, descricao, portugues, ingles, data_ini, \
          data_fim, url, doi, statusId) \n\
         \        VALUES ($1, $2, $3, $4, $5, $6, " ^ data_fim
       ^ ", $8, $9, $10)")
      |> ignore;
      query
        ~params:
          [
            Mssql.Param.String kw1;
            Mssql.Param.String kw2;
            Mssql.Param.String kw3;
            Mssql.Param.String url;
          ]
        "INSERT INTO Keyword (projetoId, designacao)\n\
        \          SELECT P.id, $1 FROM Projeto P WHERE P.url = $4\n\
        \          UNION ALL\n\
        \          SELECT P.id, $2 FROM Projeto P WHERE P.url = $4\n\
        \          UNION ALL\n\
        \          SELECT P.id, $3 FROM Projeto P WHERE P.url = $4"
      |> ignore;
      query
        ~params:
          [
            Mssql.Param.String nomeCont;
            Mssql.Param.String tituloCont;
            Mssql.Param.String descricaoCont;
            Mssql.Param.Int statusCont;
            Mssql.Param.String url;
          ]
        "INSERT INTO Contrato\n\
        \          (nome, titulo, descricao, statusId, projetoId)\n\
        \          SELECT $1, $2, $3, $4, P.id FROM Projeto P WHERE P.url = $5"
      |> ignore;
      query
        ~params:
          [
            Mssql.Param.String url;
            Mssql.Param.Array
              (progs |> List.map (fun a -> Mssql.Param.Int (a |> int_of_string)));
          ]
        "INSERT INTO Projama (projetoId, programaId)\n\
        \         SELECT P.id, Pr.id FROM Projeto P, Programa Pr\n\
        \         WHERE P.url = $1 AND Pr.id IN ($2)"
      |> ignore;
      query
        ~params:
          [
            Mssql.Param.String url;
            Mssql.Param.Array
              (areas |> List.map (fun a -> Mssql.Param.Int (a |> int_of_string)));
          ]
        "INSERT INTO AreaProjeto (projetoId, areaCientificaId)\n\
        \         SELECT P.id, A.id FROM Projeto P, AreaCientifica A\n\
        \         WHERE P.url = $1 AND A.id IN ($2)"
      |> ignore;
      Dream.log "Inseriu!";
      add_project req (Some "Sucesso!")
  | _ -> add_project req (Some "Erro!")

let project_id_modify req message =
  let id = Dream.param req "id" |> int_of_string in
  let status = query "SELECT * FROM status;" in
  let projeto =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM Projeto WHERE id = $1;"
    |> List.hd
  in
  let programas = query "SELECT * FROM Programa P" in
  let projama =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT Pr.id, Pr.designacao as Pdes FROM Projeto P \n\
      \       INNER JOIN Projama PP ON P.id = PP.projetoId\n\
      \       INNER JOIN Programa Pr ON Pr.id = PP.programaId\n\
      \       WHERE P.id = $1"
  in
  let areas = query "SELECT * FROM AreaCientifica" in
  let areaprojeto =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT A.id, A.designacao FROM Projeto P\n\
      \       INNER JOIN AreaProjeto AP ON P.id = AP.projetoId\n\
      \       INNER JOIN AreaCientifica A ON AP.areaCientificaId = A.id\n\
      \       WHERE P.id = $1"
  in
  let keywords =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT K.id, K.designacao FROM Keyword K WHERE K.projetoId = $1 "
  in
  serve
    (project_modify req message projeto status programas projama areas
       areaprojeto keywords)
    "Projeto"

let project_id_modify_post req =
  let id = Dream.param req "id" |> int_of_string in
  let programas_antes =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT Pr.id, Pr.designacao as Pdes FROM Projeto P \n\
      \       INNER JOIN Projama PP ON P.id = PP.projetoId\n\
      \       INNER JOIN Programa Pr ON Pr.id = PP.programaId\n\
      \       WHERE P.id = $1"
    |> List.map (fun a -> Types.find "id" a)
  in
  let areas_antes =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT A.id, A.designacao FROM Projeto P\n\
      \       INNER JOIN AreaProjeto AP ON P.id = AP.projetoId\n\
      \       INNER JOIN AreaCientifica A ON AP.areaCientificaId = A.id\n\
      \       WHERE P.id = $1"
    |> List.map (fun a -> Types.find "id" a)
  in
  let keywords_antes =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT K.id, K.designacao FROM Projeto P\n\
      \     INNER JOIN Keyword K ON K.projetoId = P.id\n\
      \     WHERE P.id = $1"
    |> List.map (fun a -> Types.find "designacao" a)
  in
  match%lwt Dream.form req with
  | `Ok tl ->
      let nome = find_field tl "nome" in
      let titulo = find_field tl "titulo" in
      let descricao = find_field tl "descricao" in
      let portugues = find_field tl "portugues" in
      let ingles = find_field tl "ingles" in
      let data_ini = find_field tl "data_ini" in
      let data_fim = find_field tl "data_fim" in
      let url = find_field tl "url" in
      let doi = find_field tl "doi" in
      let status = find_field tl "status" |> int_of_string in
      let keywords =
        List.filter_map (fun a -> a) (get_str "keyword" tl)
        |> List.filter (fun b -> not (List.mem b keywords_antes))
        |> List.filter (fun k -> k <> "")
      in
      let progs =
        List.filter_map (fun a -> a) (get_str "progs" tl)
        |> List.filter (fun b -> not (List.mem b programas_antes))
      in
      let del_progs =
        programas_antes
        |> List.filter (fun a ->
               not
                 (List.mem a
                    (List.filter_map (fun a -> a) (get_str "progs" tl))))
      in
      let areas =
        List.filter_map (fun a -> a) (get_str "areas" tl)
        |> List.filter (fun b -> not (List.mem b areas_antes))
      in
      let del_areas =
        areas_antes
        |> List.filter (fun a ->
               not
                 (List.mem a
                    (List.filter_map (fun a -> a) (get_str "areas" tl))))
      in
      let prev_status =
        query ~params:[ Mssql.Param.Int id ]
          "SELECT TOP 1 statusId FROM HistoricoStatus WHERE projetoId = $1 \
           ORDER BY data DESC;"
      in
      let _ =
        let open Types in
        if List.length prev_status == 0 || prev_status |> List.hd <| "statusId" |> int_of_string <> status then 
          query
            ~params:
              [
                Mssql.Param.Int id;
                Mssql.Param.Int status;
              ]
            "INSERT INTO HistoricoStatus (projetoId, statusId, data) VALUES \
             ($1, $2, GETDATE());"
          |> ignore
      in
      query
        ~params:
          [
            Mssql.Param.String nome;
            Mssql.Param.String titulo;
            Mssql.Param.String descricao;
            Mssql.Param.String portugues;
            Mssql.Param.String ingles;
            Mssql.Param.String data_ini;
            Mssql.Param.String data_fim;
            Mssql.Param.String url;
            Mssql.Param.String doi;
            Mssql.Param.Int status;
            Mssql.Param.Int id;
          ]
        (match data_fim with
        | "NULL" ->
            "UPDATE Projeto SET nome = $1, titulo = $2, descricao = $3, \
             portugues = $4, ingles = $5, data_ini = $6, data_fim = " ^ data_fim
            ^ ", url = $8, doi = $9, statusId = $10 WHERE id = $11;"
        | _ ->
            "UPDATE Projeto SET nome = $1, titulo = $2, descricao = $3, \
             portugues = $4, ingles = $5, data_ini = $6, data_fim = $7\n\
            \                  , url = $8, doi = $9, statusId = $10 WHERE id = \
             $11;")
      |> ignore;
      let _ =
        if List.length keywords > 0 then
          query
            ~params:
              [
                Mssql.Param.Array
                  (keywords |> List.map (fun a -> Mssql.Param.String a));
                Mssql.Param.Int id;
              ]
            "INSERT INTO Keyword (projetoId, designacao) \n\
            \           SELECT $2, a FROM (VALUES ($1)) as t(a)"
          |> ignore
      in
      add_record req progs "projetoId" "programaId" "Projama" "Programa";
      remove_record req del_progs "projetoId" "programaId" "Projama";
      add_record req areas "projetoId" "areaCientificaId" "AreaProjeto"
        "AreaCientifica";
      remove_record req del_areas "projetoId" "AreaCientificaId" "AreaProjeto";
      Dream.log "Atualizou!";
      project_id_modify req (Some "Sucesso!")
  | _ -> project_id_modify req (Some "Erro!")

let delete_project req =
  let id = Dream.param req "id" |> int_of_string in
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Contrato WHERE projetoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM AreaProjeto WHERE projetoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Projama WHERE projetoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Participa WHERE projetoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Participa WHERE projetoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Keyword WHERE projetoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Publicacao WHERE projetoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM HistoricoStatus WHERE projetoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ] "DELETE FROM Projeto WHERE id = $1"
  |> ignore;
  Dream.redirect req "/projetos"

(* CONTRATOS *)
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

let modify_contract req message =
  let contrato =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT * FROM Contrato WHERE id = $1;"
    |> List.hd
  in
  let status = query "SELECT * FROM Status;" in
  serve (contract_modify req contrato status message) "Modificar Contrato"

let modify_contract_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let nome = find_field tl "nome" in
      let titulo = find_field tl "titulo" in
      let descricao = find_field tl "descricao" in
      let status = find_field tl "status" |> int_of_string in
      let id = Dream.param req "id" |> int_of_string in
      query
        ~params:
          [
            Mssql.Param.String nome;
            Mssql.Param.String titulo;
            Mssql.Param.String descricao;
            Mssql.Param.Int status;
            Mssql.Param.Int id;
          ]
        "UPDATE Contrato SET nome = $1, titulo = $2, descricao = $3, statusId \
         = $4 WHERE id = $5"
      |> ignore;
      modify_contract req (Some "Sucesso!")
  | _ -> modify_contract req (Some "Erro!")

(* PUBLICAÇÕES *)
let publication_id req =
  let id = Dream.param req "id" |> int_of_string in
  let pub =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM Publicacao P WHERE P.id = $1"
    |> List.hd
  in
  let projeto =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id, P.nome FROM Projeto P \n\
      \       INNER JOIN Contrato C ON P.id = C.projetoId \n\
      \       WHERE C.id = $1"
  in
  serve (publication pub projeto) "Publicação"

let add_publication req _message =
  serve (publication_add req _message) "Adicionar Publicação"

let add_publication_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let url = find_field tl "url" in
      let jornal = find_field tl "jornal" in
      let indicador = 
        let ind =
          find_field tl "indicador" |> int_of_string in
        if ind <> 1 then 0 else 1
      in
      let doi = find_field tl "doi" in
      let id = Dream.param req "id" |> int_of_string in
      query
        ~params:
          [
            Mssql.Param.String url;
            Mssql.Param.String jornal;
            Mssql.Param.Int indicador;
            Mssql.Param.String doi;
            Mssql.Param.Int id;
          ]
        "INSERT INTO Publicacao (url, nomeJornal, indicador, doi, projetoId)\n\
        \        VALUES ($1, $2, $3, $4, $5)"
      |> ignore;
      Dream.log "Inseriu!";
      add_publication req (Some "Sucesso!")
  | _ -> add_publication req (Some "Erro!")

let modify_publication req message =
  let publicacao =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT * FROM Publicacao WHERE id = $1;"
    |> List.hd
  in
  serve (publication_modify req publicacao message) "Modificar Publicação"

let modify_publication_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let url = find_field tl "url" in
      let jornal = find_field tl "jornal" in
      let indicador = find_field tl "indicador" |> int_of_string in
      let doi = find_field tl "doi" in
      let id = Dream.param req "id" |> int_of_string in
      query
        ~params:
          [
            Mssql.Param.String url;
            Mssql.Param.String jornal;
            Mssql.Param.Int indicador;
            Mssql.Param.String doi;
            Mssql.Param.Int id;
          ]
        "UPDATE Publicacao SET url = $1, nomeJornal = $2, indicador = $3, doi \
         = $4 WHERE id = $5"
      |> ignore;
      modify_publication req (Some "Sucesso!")
  | _ -> modify_publication req (Some "Erro!")

let delete_publication req =
  let id = Dream.param req "id" |> int_of_string in
  query ~params:[ Mssql.Param.Int id ] "DELETE FROM Publicacao WHERE id = $1"
  |> ignore;
  Dream.redirect req "/projetos"

(* DOMINIOS *)
let domains _req = serve (domains (query "SELECT * FROM Dominio")) "Domínios"

let domain_id req =
  let dominio =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT id, designacao FROM Dominio D WHERE D.id = $1"
  in
  let area =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT id, designacao FROM AreaCientifica WHERE dominioId = $1"
  in
  serve (domain dominio area) "Dominio"

let add_domain req _message =
  serve (domain_add req _message) "Adicionar Domínio"

let add_domain_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let des = find_field tl "designacao" in
      query ~params:[ Mssql.Param.String des ]
        "INSERT INTO Dominio (designacao) VALUES ($1)"
      |> ignore;
      Dream.log "Inseriu!";
      add_domain req (Some "Sucesso!")
  | _ -> add_domain req (Some "Erro!")

let modify_domain req _message =
  let institute =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT id, designacao FROM Dominio WHERE id = $1"
    |> List.hd
  in
  serve (domain_form req institute _message) "Domínio"

let modify_domain_form req =
  let id = Dream.param req "id" |> int_of_string in
  match%lwt Dream.form req with
  | `Ok [ ("designacao", des) ] ->
      query
        ~params:[ Mssql.Param.String des; Mssql.Param.Int id ]
        "UPDATE Dominio SET designacao = $1 WHERE id = $2"
      |> ignore;
      modify_domain req (Some "Sucesso!")
  | _ -> modify_domain req (Some "Erro!")

let delete_domain req message =
  let dominios = 
    query 
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT * FROM Dominio
       WHERE id != $1" 
  in
  serve (domain_delete req dominios message) "Remover Domínio"

let delete_domain_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let dom = Dream.param req "id" |> int_of_string in
      let dom_novo = find_field tl "dom2" |> int_of_string in
      query
        ~params:[ Mssql.Param.Int dom_novo; Mssql.Param.Int dom ]
        "UPDATE AreaCientifica SET dominioId = $1 WHERE dominioId = $2"
      |> ignore;
      query ~params:[ Mssql.Param.Int dom ] "DELETE FROM Dominio WHERE id = $1"
      |> ignore;
      Dream.redirect req "/dominios"
  | _ -> delete_domain req (Some "Erro!")

(* AREAS CIENTIFICAS *)
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
  serve (area area_c dominio projetos) "Área Científica"

let add_area req _message =
  let dominios = query "SELECT * FROM Dominio" in
  serve (area_add req dominios _message) "Área Científica"

let add_area_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let des = find_field tl "designacao" in
      let dom = find_field tl "dom" in
      query
        ~params:[ Mssql.Param.String des; Mssql.Param.String dom ]
        "INSERT INTO AreaCientifica (designacao, dominioId) VALUES ($1, $2)"
      |> ignore;
      Dream.log "Inseriu!";
      add_area req (Some "Sucesso!")
  | _ -> add_area req (Some "Erro!")

let modify_area req _message =
  let domains = query "SELECT * FROM Dominio" in
  let institute =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT * FROM AreaCientifica WHERE id = $1"
    |> List.hd
  in
  serve (area_form req institute domains _message) "Modificar Área Científica"

let modify_area_form req =
  let id = Dream.param req "id" |> int_of_string in
  match%lwt Dream.form req with
  | `Ok tl ->
      let designacao = find_field tl "designacao" in
      let dominioId = find_field tl "dominioId" in
      query
        ~params:
          [
            Mssql.Param.String designacao;
            Mssql.Param.Int (dominioId |> int_of_string);
            Mssql.Param.Int id;
          ]
        "UPDATE AreaCientifica SET designacao = $1, dominioId = $2\n\
        \         WHERE id = $3;"
      |> ignore;
      Dream.log "Atualizou!";
      modify_area req (Some "Sucesso!")
  | _ -> modify_area req (Some "Erro!")

let delete_area req =
  let id = Dream.param req "id" |> int_of_string in
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM AreaProjeto WHERE areaCientificaId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM AreaCientifica WHERE id = $1"
  |> ignore;
  Dream.redirect req "/areas"

(* INVESTIGADORES *)
let investigators _req =
  serve (investigadores (query "SELECT * FROM investigador;")) "Investigadores"

let create_investigators req =
  let investigador =
    let add = Types.SMap.add in
    Types.empty |> add "id" "0" |> add "institutoId" "0" |> add "nome" ""
    |> add "idade" "0" |> add "morada" ""
  in
  let institutes = query "SELECT * FROM Instituto;" in
  serve (investigador_create req investigador institutes) "Criar Investigadores"

let create_investigators_post req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let nome = find_field tl "nome" in
      let idade = find_field tl "idade" |> int_of_string in
      let morada = find_field tl "morada" in
      let institutoId = find_field tl "institutoId" |> int_of_string in
      let _ =
        query
          ~params:
            [
              Mssql.Param.String nome;
              Mssql.Param.Int idade;
              Mssql.Param.String morada;
              Mssql.Param.Int institutoId;
            ]
          "INSERT INTO Investigador (nome, idade, morada, institutoId) VALUES \
           ($1, $2, $3, $4);"
      in
      Dream.redirect req "/investigadores"
  | _ -> create_investigators req

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

let investigator_id_modificar req message =
  let inves_id = Dream.param req "id" |> int_of_string in
  let investigador =
    query
      ~params:[ Mssql.Param.Int inves_id ]
      "SELECT * FROM Investigador WHERE id = $1;"
    |> List.hd
  in
  let institutes = query "SELECT * FROM Instituto;" in
  let unidades = query "SELECT id, nome FROM UnidadeInvestigacao" in
  let insvestigador_unidade =
    query
      ~params:[ Mssql.Param.Int inves_id ]
      "SELECT * FROM UnidadeInvestigacao UI INNER JOIN UnidadeInvestigador UIR \
       ON UI.id = UIR.unidadeInvestigacaoId WHERE UIR.investigadorId = $1"
  in
  let projeto = query 
      ~params:[ Mssql.Param.Int inves_id ]
        "SELECT PI.tempoPerc, P.* FROM Projeto P
         INNER JOIN Participa PI ON P.id = PI.projetoId
         WHERE PI.investigadorId = $1"
  in
  let participa =
    query
      ~params:[ Mssql.Param.Int inves_id ]
      "SELECT * FROM participa WHERE investigadorId = $1;"
  in
  serve
    (investigador_form req investigador institutes unidades
       insvestigador_unidade projeto participa message)
    "Modificar Investigador"

let investigator_id_modificar_post req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let nome = find_field tl "nome" in
      let idade = find_field tl "idade" |> int_of_string in
      let morada = find_field tl "morada" in
      let institute_id = find_field tl "institutoId" |> int_of_string in
      let id = Dream.param req "id" |> int_of_string in
      query
        ~params:
          [
            Mssql.Param.String nome;
            Mssql.Param.Int idade;
            Mssql.Param.String morada;
            Mssql.Param.Int institute_id;
            Mssql.Param.Int id;
          ]
        "UPDATE Investigador SET nome = $1, idade = $2, morada = $3, \
         institutoId = $4 WHERE id = $5"
      |> ignore;
      investigator_id_modificar req (Some "Sucesso!")
  | _ -> investigator_id_modificar req (Some "Erro!")

let investigador_id_delete req =
  let invs_id = Dream.param req "id" |> int_of_string in
  let _ =
    query
      ~params:[ Mssql.Param.Int invs_id ]
      "DELETE FROM participa WHERE investigadorId = $1"
  in
  let _ =
    query
      ~params:[ Mssql.Param.Int invs_id ]
      "DELETE FROM unidadeInvestigador WHERE investigadorId = $1"
  in
  let _ =
    query
      ~params:[ Mssql.Param.Int invs_id ]
      "DELETE FROM investigador WHERE id = $1"
  in
  Dream.redirect req "/investigadores"

let unidade_investigador_id_modificar_post req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let inves_id = Dream.param req "id" |> int_of_string in
      let _ =
        query
          ~params:[ Mssql.Param.Int inves_id ]
          "DELETE FROM UnidadeInvestigador WHERE investigadorId = $1;"
      in
      let campos_unidades = List.filter (fun (n, _) -> n = "unidade") tl in
      let unidade_id = List.map (fun (_, b) -> b) campos_unidades in
      let q =
        List.map (fun a -> "($1," ^ a ^ ")") unidade_id |> String.concat ", "
      in
      let tempo =
        let tem_wasted =
          query
            ~params:[ Mssql.Param.Int inves_id ]
            "SELECT SUM(tempoPerc) as tempoPerc FROM participa WHERE \
             investigadorId = $1"
          |> List.hd
        in
        match Types.find "tempoPerc" tem_wasted with
        | "NULL" -> 0
        | x -> x |> int_of_string
      in 
      if tempo < 15 then
        investigator_id_modificar req (Some "O investigador precisa de ter mais do que 15% de tempo dedicado em projetos!")
      else
      let _ =
        query
          ~params:[ Mssql.Param.Int inves_id ]
          ("INSERT INTO UnidadeInvestigador (investigadorId, \
            unidadeInvestigacaoId) VALUES " ^ q ^ ";")
      in
      investigator_id_modificar req (Some "Sucesso!")
  | _ -> investigator_id_modificar req (Some "Erro!")

let participa_investigador_id req message =
  let inves_id = Dream.param req "id" |> int_of_string in
  let investigador =
    query
      ~params:[ Mssql.Param.Int inves_id ]
      "SELECT * FROM Investigador WHERE id = $1;"
    |> List.hd
  in
  let projeto = query "SELECT * FROM Projeto;" in
  let papel = query "SELECT * FROM papel;" in
  serve
    (investigador_add_participa req investigador projeto papel message)
    "Adicionar Participacão"

let participa_investigador_id_post req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let id = Dream.param req "id" |> int_of_string in
      let proj_id = find_field tl "projectId" |> int_of_string in
      let papel_id = find_field tl "papelId" |> int_of_string in
      let tempo_perc = find_field tl "tempoPerc" |> int_of_string in
      let tempo =
        let tem_wasted =
          query
            ~params:[ Mssql.Param.Int id ]
            "SELECT SUM(tempoPerc) as tempoPerc FROM participa WHERE \
             investigadorId = $1"
          |> List.hd
        in
        match Types.find "tempoPerc" tem_wasted with
        | "NULL" -> 0
        | x -> x |> int_of_string
      in
      if tempo + tempo_perc > 100 then
        participa_investigador_id req (Some "Demasiado tempo ocupado para os projetos!")
      else if papel_id == 3 && tempo_perc < 35 then
        participa_investigador_id req (Some "Para ser líder do projeto tem de ter pelo menos 35% do tempo ocupado.")
      else
        let _ =
          query
            ~params:
              [
                Mssql.Param.Int id;
                Mssql.Param.Int proj_id;
                Mssql.Param.Int papel_id;
                Mssql.Param.Int tempo_perc;
              ]
            "INSERT INTO Participa (investigadorId, projetoId, papelId, \
             tempoPerc) VALUES ($1, $2, $3, $4);"
        in

        participa_investigador_id req (Some "Sucesso!")
  | _ -> participa_investigador_id req (Some "Erro!")

let modify_participa_investigador_id req message =
  let inves_id = Dream.param req "idi" |> int_of_string in
  let proj_id = Dream.param req "idp" |> int_of_string in
  let investigador =
    query
      ~params:[ Mssql.Param.Int inves_id ]
      "SELECT * FROM Investigador WHERE id = $1;"
    |> List.hd
  in
  let projeto =
    query
      ~params:[ Mssql.Param.Int proj_id ]
      "SELECT id, nome FROM Projeto WHERE id = $1"
  |> List.hd
  in
  let papel = query "SELECT * FROM papel;" in
  let tempo =
    query
      ~params:[ Mssql.Param.Int inves_id; Mssql.Param.Int proj_id ]
      "SELECT tempoPerc FROM Participa PI WHERE \
       investigadorId = $1 AND projetoId = $2"
  |> List.hd
  in
  serve
    (investigador_modify_participa req investigador projeto papel tempo message)
    "Modificar Participacão"

let modify_participa_investigador_id_post req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let inves_id = Dream.param req "idi" |> int_of_string in
      let proj_id = Dream.param req "idp" |> int_of_string in
      let papel_id = find_field tl "papelId" |> int_of_string in
      let tempo_perc = find_field tl "tempoPerc" |> int_of_string in
      let tempo =
        let tem_wasted =
          query
            ~params:[ Mssql.Param.Int inves_id ]
            "SELECT SUM(tempoPerc) as tempoPerc FROM participa WHERE \
             investigadorId = $1"
          |> List.hd
        in
        match Types.find "tempoPerc" tem_wasted with
        | "NULL" -> 0
        | x -> x |> int_of_string
      in
      if tempo + tempo_perc > 100 then
        modify_participa_investigador_id req (Some "Demasiado tempo ocupado para os projetos!")
      else if papel_id == 3 && tempo_perc < 35 then
        modify_participa_investigador_id req (Some "Para ser líder do projeto tem de ter pelo menos 35% do tempo ocupado.")
      else
        let _ =
          query
            ~params:
              [
                Mssql.Param.Int inves_id;
                Mssql.Param.Int proj_id;
                Mssql.Param.Int papel_id;
                Mssql.Param.Int tempo_perc;
              ]
            "UPDATE Participa SET papelId = $3,tempoPerc = $4 
             WHERE investigadorId = $1 AND projetoId = $2"
        in

        modify_participa_investigador_id req (Some "Sucesso!")
  | _ -> modify_participa_investigador_id req (Some "Erro!")

let participa_investigador_remove req =
  let id_inves = Dream.param req "idi" |> int_of_string in
  let id_proj = Dream.param req "idp" |> int_of_string in
  let _ =
    query
      ~params:[ Mssql.Param.Int id_inves; Mssql.Param.Int id_proj ]
      "DELETE FROM participa WHERE investigadorId = $1 AND projetoId = $2;"
  in

  Dream.redirect req
    ("/investigadores/" ^ (id_inves |> string_of_int) ^ "/modificar")

(* UNIDADES DE INVESTIGACAO *)
let unids _req =
  serve
    (unidades (query "SELECT id, nome FROM UnidadeInvestigacao;"))
    "Unidades"

let unid_id req =
  let id = Dream.param req "id" |> int_of_string in
  let unid =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM UnidadeInvestigacao U WHERE U.id = $1;"
  in
  let investigadores =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT I.id, I.nome FROM UnidadeInvestigacao U\n\
      \       INNER JOIN UnidadeInvestigador UI ON U.id = \
       UI.unidadeInvestigacaoId\n\
      \       INNER JOIN Investigador I ON UI.investigadorId = I.id\n\
      \       WHERE U.id = $1"
  in
  serve (unidade unid investigadores) "Unidade"

let add_unid req _message = serve (unidade_add req _message) "Adicionar Unidades"

let add_unid_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let nome = find_field tl "nome" in
      query
        ~params:[ Mssql.Param.String nome ]
        "INSERT INTO UnidadeInvestigacao (nome) VALUES ($1)"
      |> ignore;
      Dream.log "Inseriu!";
      add_unid req (Some "Sucesso!")
  | _ -> add_unid req (Some "Erro!")

let modify_unid req _message =
  let unit =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT id, nome FROM UnidadeInvestigacao WHERE id = $1"
    |> List.hd
  in
  serve (unidade_form req unit _message) "Modificar Unidade"

let modify_unid_form req =
  let id = Dream.param req "id" |> int_of_string in
  match%lwt Dream.form req with
  | `Ok [ ("nome", nome) ] ->
      query
        ~params:[ Mssql.Param.String nome; Mssql.Param.Int id ]
        "UPDATE UnidadeInvestigacao SET nome = $1 WHERE id = $2"
      |> ignore;
      (* List.map (fun (s, v) -> Dream.log "%s: %s\n\n" s v) tl |> ignore; *)
      modify_unid req (Some "Sucesso!")
  | _ -> modify_unid req (Some "Erro!")

let delete_unid req =
  let id = Dream.param req "id" |> int_of_string in
  let _ =
    query ~params:[ Mssql.Param.Int id ]
      "DELETE FROM UnidadeInvestigador WHERE unidadeInvestigacaoId = $1"
  in
  let _ =
    query ~params:[ Mssql.Param.Int id ]
      "DELETE FROM UnidadeInvestigacao WHERE id = $1"
  in
  Dream.redirect req "/unidades"

(* INSTITUTOS *)
let institutes _req =
  serve
    (institutes (query "SELECT id, designacao FROM instituto;"))
    "Institutos"

let institute_id req =
  let id = Dream.param req "id" |> int_of_string in
  let instituto =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT * FROM Instituto I WHERE I.id = $1"
  in
  let investigadores =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT I.id, I.nome FROM Instituto Ins\n\
      \       INNER JOIN Investigador I ON I.institutoId = Ins.id\n\
      \       WHERE Ins.id = $1"
  in
  serve (institute instituto investigadores) "Instituto"

let add_institute req _message = serve (institute_add req _message) "Adicionar Instituto"

let add_institute_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let des = find_field tl "designacao" in
      query ~params:[ Mssql.Param.String des ]
        "INSERT INTO Instituto (designacao) VALUES ($1)"
      |> ignore;
      (* List.map (fun (s, v) -> Dream.log "%s: %s\n\n" s v) tl |> ignore; *)
      Dream.log "Inseriu!";
      add_institute req (Some "Sucesso!")
  | _ -> add_institute req (Some "Erro!")

let modify_institute req _message =
  let institute =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT id, designacao FROM Instituto WHERE id = $1"
    |> List.hd
  in
  serve (institute_form req institute _message) "Modificar Instituto"

let modify_institute_form req =
  let id = Dream.param req "id" |> int_of_string in
  match%lwt Dream.form req with
  | `Ok [ ("designacao", des) ] ->
      query
        ~params:[ Mssql.Param.String des; Mssql.Param.Int id ]
        "UPDATE Instituto SET designacao = $1 WHERE id = $2"
      |> ignore;
      (* List.map (fun (s, v) -> Dream.log "%s: %s\n\n" s v) tl |> ignore; *)
      Dream.log "Atualizou!";
      modify_institute req (Some "Sucesso!")
  | _ -> modify_institute req (Some "Erro!")

let delete_institute req =
  let id = Dream.param req "id" |> int_of_string in
  query ~params:[ Mssql.Param.Int id ]
    "UPDATE Investigador SET institutoId = NULL WHERE institutoId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ] "DELETE FROM Instituto WHERE id = ($1)"
  |> ignore;
  Dream.redirect req "/institutos"

(* ENTIDADES *)
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
  let entidade =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM Entidade WHERE id = $1"
  in
  let programas =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id as Pid, P.designacao as pdesignacao, EP.valor FROM Entidade \
       E \n\
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
  serve (entity entidade programas projects) "Entidades"

let add_entity req _message = serve (entity_add req _message) "Adicionar Entidade"

let add_entity_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let nome = find_field tl "nome" in
      let descricao = find_field tl "descricao" in
      let designacao = find_field tl "designacao" in
      let email = find_field tl "email" in
      let telemovel = find_field tl "telemovel" in
      let morada = find_field tl "morada" in
      let pais = find_field tl "pais" in
      let nacional = if pais == "Portugal" then 1 else 0 in
      let url = find_field tl "url" in
      query
        ~params:
          [
            Mssql.Param.String nome;
            Mssql.Param.String descricao;
            Mssql.Param.String designacao;
            Mssql.Param.String email;
            Mssql.Param.Int (telemovel |> int_of_string);
            Mssql.Param.String morada;
            Mssql.Param.String pais;
            Mssql.Param.Int nacional;
            Mssql.Param.String url;
          ]
        "INSERT INTO Entidade \n\
        \        (nome, descricao, designacao, email, telemovel, morada, pais, \
         nacional, url) \n\
        \        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)"
      |> ignore;
      Dream.log "Inseriu!";
      add_entity req (Some "Sucesso!")
  | _ -> add_entity req (Some "Erro!")

let modify_entity req _message =
  let id = Dream.param req "id" |> int_of_string in
  let entity =
    query ~params:[ Mssql.Param.Int id ] "SELECT * FROM Entidade WHERE id = $1;"
    |> List.hd
  in
  let programas = query "SELECT id, designacao FROM Programa" in
  let entigrama =
    query ~params:[ Mssql.Param.Int id ]
      "SELECT P.id as Pid, P.designacao as Pdes, EP.valor FROM Entidade E\n\
      \       INNER JOIN Entigrama EP ON E.id = EP.entidadeId\n\
      \       INNER JOIN Programa P ON P.id = EP.programaId\n\
      \       WHERE E.id = $1"
  in
  serve (entity_form req entity programas entigrama _message) "Modificar Entidade"

let modify_entity_form req =
  let programas_antes =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT P.id, P.designacao as Pdes FROM Entidade E\n\
      \       INNER JOIN Entigrama EP ON E.id = EP.entidadeId\n\
      \       INNER JOIN Programa P ON P.id = EP.programaId\n\
      \       WHERE E.id = $1"
    |> List.map (fun a -> Types.find "id" a)
  in
  match%lwt Dream.form req with
  | `Ok tl ->
      let nome = find_field tl "nome" in
      let descricao = find_field tl "descricao" in
      let designacao = find_field tl "designacao" in
      let email = find_field tl "email" in
      let telemovel = find_field tl "telemovel" in
      let morada = find_field tl "morada" in
      let pais = find_field tl "pais" in
      let nacional = if pais == "Portugal" then 1 else 0 in
      let pais = find_field tl "pais" in
      let url = find_field tl "url" in
      let progs =
        List.filter_map (fun a -> a) (get_str "progs" tl)
        |> List.filter (fun b -> not (List.mem b programas_antes))
      in
      let del_progs =
        programas_antes
        |> List.filter (fun a ->
               not
                 (List.mem a
                    (List.filter_map (fun a -> a) (get_str "progs" tl))))
      in
      let prog =
        List.filter_map (fun a -> a) (get_str "prog" tl)
        |> List.map (fun a -> a |> int_of_string)
      in
      let vals =
        List.filter_map (fun a -> a) (get_str "valor" tl)
        |> List.map (fun a -> if a = "NULL" then 0 else a |> int_of_string)
      in
      let prog_val = List.combine prog vals in
      query
        ~params:
          [
            Mssql.Param.String nome;
            Mssql.Param.String descricao;
            Mssql.Param.String designacao;
            Mssql.Param.String email;
            Mssql.Param.Int (telemovel |> int_of_string);
            Mssql.Param.String morada;
            Mssql.Param.String pais;
            Mssql.Param.Int nacional;
            Mssql.Param.String url;
            Mssql.Param.Int (Dream.param req "id" |> int_of_string);
          ]
        "UPDATE Entidade\n\
        \        SET nome = $1, descricao = $2, designacao = $3, email = $4, \
         telemovel = $5, morada = $6, pais = $7, nacional = $8, url = $9\n\
        \        WHERE id = $10;"
      |> ignore;
      add_record req progs "entidadeId" "programaId" "Entigrama" "Programa";
      update_record req prog_val "entidadeId" "programaId" "valor" "Entigrama";
      remove_record req del_progs "entidadeId" "programaId" "Entigrama";
      Dream.log "Atualizou!";
      modify_entity req (Some "Sucesso!")
  | _ -> modify_entity req (Some "Erro!")

let delete_entity req =
  let id = Dream.param req "id" |> int_of_string in
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Entigrama WHERE entidadeId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ] "DELETE FROM Entidade WHERE id = $1"
  |> ignore;
  Dream.redirect req "/entidades"

(* PROGRAMAS *)
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

let add_program req _message = serve (program_add req _message) "Adicionar Programa"

let add_program_form req =
  match%lwt Dream.form req with
  | `Ok tl ->
      let des = find_field tl "designacao" in
      query ~params:[ Mssql.Param.String des ]
        "INSERT INTO Programa (designacao) VALUES ($1)"
      |> ignore;
      Dream.log "Inseriu!";
      add_program req (Some "Sucesso!")
  | _ -> add_program req (Some "Erro!")

let modify_program req _message =
  let programa =
    query
      ~params:[ Mssql.Param.Int (Dream.param req "id" |> int_of_string) ]
      "SELECT * FROM Programa WHERE id = $1"
    |> List.hd
  in
  serve (program_form req programa _message) "Modificar Programa"

let modify_program_form req =
  let id = Dream.param req "id" |> int_of_string in
  match%lwt Dream.form req with
  | `Ok [ ("designacao", des) ] ->
      query
        ~params:[ Mssql.Param.String des; Mssql.Param.Int id ]
        "UPDATE Programa SET designacao = $1 WHERE id = $2"
      |> ignore;
      (* List.map (fun (s, v) -> Dream.log "%s: %s\n\n" s v) tl |> ignore; *)
      Dream.log "Atualizou!";
      modify_program req (Some "Sucesso!")
  | _ -> modify_program req (Some "Erro!")

let delete_program req =
  let id = Dream.param req "id" |> int_of_string in
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Entigrama WHERE programaId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ]
    "DELETE FROM Projama WHERE programaId = $1"
  |> ignore;
  query ~params:[ Mssql.Param.Int id ] "DELETE FROM Programa WHERE id = $1"
  |> ignore;
  Dream.redirect req "/programas"
