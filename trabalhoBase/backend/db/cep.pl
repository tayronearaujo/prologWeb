:- module(
        cep, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          cep/4
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

%    table CEP {
%        cep_id: NUMBER(10)(PK)
%        cid_id: NUMBER(10)(FK)
%        bai_id: NUMBER(10)(FK)
%        log_id: NUMBER(10)(FK)
%    }

% Esquema da relação cep
:- persistent
   cep(cep_id:nonneg,
       cid_id:nonneg,
       bai_id:nonneg,
       log_id:nonneg).

:- initialization( ( db_attach('./backend/db/tbl_cep.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(CEP_ID,
       CID_ID,
       BAI_ID,
       LOG_ID) :-
    with_mutex(cep,
               assert_cep(CEP_ID,
                          CID_ID,
                          BAI_ID,
                          LOG_ID)).

% Método de Remoção de um cep, passando o ID da mesma.
% É como se fosse um DELETE FROM cep WHERE id = id do Sql.
remove(CEP_ID) :-
    with_mutex(cep,
               retract_cep(CEP_ID,
                           _CID_ID,
                           _BAI_ID,
                           _LOG_ID)).

% Método de Atualização de um cep, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(CEP_ID,
         CID_ID,
         BAI_ID,
         LOG_ID) :-
    with_mutex(cep,
               (retractall_cep(CEP_ID,
                              _CID_ID,
                              _BAI_ID,
                              _LOG_ID),
               assert_cep(CEP_ID,
                          CID_ID,
                          BAI_ID,
                          LOG_ID))).