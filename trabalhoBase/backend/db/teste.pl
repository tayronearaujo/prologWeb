:- module(
        teste, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          teste/5
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).
/*
    table TESTE {
        tes_id: NUMBER(10)(PK)
        avi_id: NUMBER(10)(FK)
        tes_data_hora: DATE
        tes_descricao: VARCHAR(30)
        tes_ind_rejeicao: VARCHAR(30)
    }
*/

% Esquema da relação teste
:- persistent
   teste(tes_id:nonneg,
         avi_id:nonneg,
         tes_data_hora:string,
         tes_descricao:string,
         tes_ind_rejeicao:string).

:- initialization( ( db_attach('./backend/db/tbl_teste.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(TES_ID,
       AVI_ID,
       TES_DATA_HORA,
       TES_DESCRICAO,
       TES_IND_REJEICAO) :-
    with_mutex(teste,
               assert_teste(TES_ID,
                            AVI_ID,
                            TES_DATA_HORA,
                            TES_DESCRICAO,
                            TES_IND_REJEICAO)).

% Método de Remoção de um teste, passando o ID da mesma.
% É como se fosse um DELETE FROM teste WHERE id = id do Sql.
remove(TES_ID) :-
    with_mutex(teste,
               retract_teste(TES_ID,
                             _AVI_ID,
                             _TES_DATA_HORA,
                             _TES_DESCRICAO,
                             _TES_IND_REJEICAO)).
                           
% Método de Atualização de um teste, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(TES_ID,
         AVI_ID,
         TES_DATA_HORA,
         TES_DESCRICAO,
         TES_IND_REJEICAO) :-
    with_mutex(teste,
               retractall_teste(TES_ID,
                                _AVI_ID,
                                _TES_DATA_HORA,
                                _TES_DESCRICAO,
                                _TES_IND_REJEICAO),
               assert_teste(TES_ID,
                            AVI_ID,
                            TES_DATA_HORA,
                            TES_DESCRICAO,
                            TES_IND_REJEICAO)).


