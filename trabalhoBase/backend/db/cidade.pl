:- module(
        cidade, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          cidade/3
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

%    table CIDADE {
%        cid_id: NUMBER(10)(PK)
%        cid_nome: VARCHAR(45)
%        cid_uf: VARCHAR(2)
%    }

% Esquema da relação cidade
:- persistent
   cidade(cid_id:nonneg,
          cid_nome:string,
          cid_uf:string).

:- initialization( ( db_attach('./backend/db/tbl_cidade.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(CID_ID,
       CID_NOME,
       CID_UF) :-
    with_mutex(cidade,
               assert_cidade(CID_ID,
                             CID_NOME,
                             CID_UF)).

% Método de Remoção de uma cidade, passando o ID da mesma.
% É como se fosse um DELETE FROM cidade WHERE id = id do Sql.
remove(CID_ID) :-
    with_mutex(cidade,
               retract_cidade(CID_ID,
                              _CID_NOME,
                              _CID_UF)).

% Método de Atualização de uma cidade, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(CID_ID,
         CID_NOME,
         CID_UF) :-
    with_mutex(cidade,
               (retractall_cidade(CID_ID,
                                 _CID_NOME,
                                 _CID_UF),
               assert_cidade(CID_ID,
                             CID_NOME,
                             CID_UF))).
