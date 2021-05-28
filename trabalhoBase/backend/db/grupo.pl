:- module(
        grupo, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          grupo/2
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).
/*
    table GRUPO {
        gru_id:   NUMBER(10)(PK)
        gru_nome: VARCHAR(45)
    }
*/

% Esquema da relação grupo
:- persistent
   grupo(gru_id:nonneg,
         gru_nome:string).

:- initialization( ( db_attach('./backend/db/tbl_grupo.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(GRU_ID,
       GRU_NOME) :-
    with_mutex(grupo,
               assert_grupo(GRU_ID,
                            GRU_NOME)).

% Método de Remoção de um grupo, passando o ID da mesma.
% É como se fosse um DELETE FROM grupo WHERE id = id do Sql.
remove(GRU_ID) :-
    with_mutex(grupo,
               retract_grupo(GRU_ID,
                           _GRU_NOME)).
                           
% Método de Atualização de um grupo, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(GRU_ID,
         GRU_NOME) :-
    with_mutex(grupo,
               (retractall_grupo(GRU_ID,
                                _GRU_NOME),
               assert_grupo(GRU_ID,
                            GRU_NOME))).


