:- module(
        aviao, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          aviao/2
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).
/*
    table AVIAO {
        avi_id: NUMBER(10)(PK)
        avi_nome: VARCHAR(30)
    }
*/

% Esquema da relação aviao
:- persistent
   aviao(avi_id:nonneg,
         avi_nome:string).

:- initialization( ( db_attach('./backend/db/tbl_aviao.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(AVI_ID,
       AVI_NOME) :-
    with_mutex(aviao,
               assert_aviao(AVI_ID,
                            AVI_NOME)).

% Método de Remoção de um aviao, passando o ID da mesma.
% É como se fosse um DELETE FROM aviao WHERE id = id do Sql.
remove(AVI_ID) :-
    with_mutex(aviao,
               retract_aviao(AVI_ID,
                           _AVI_NOME)).
                           
% Método de Atualização de um aviao, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(AVI_ID,
         AVI_NOME) :-
    with_mutex(aviao,
               (retractall_aviao(AVI_ID,
                                _AVI_NOME),
               assert_aviao(AVI_ID,
                            AVI_NOME))).