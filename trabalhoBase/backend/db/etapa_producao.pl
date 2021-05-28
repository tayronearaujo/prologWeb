:- module(
        etapa_producao, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          etapa_producao/5
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).
/*
    table ETAPA_PRODUCAO {
        ep_id: NUMBER(10)(PK)
        ep_tempo_inicial: DATE
        ep_tempo_final: DATE
        ep_tempo_etapa: DATE
        ep_descricao: VARCHAR(30)
    }
*/

% Esquema da relação etapa_producao
:- persistent
   etapa_producao(ep_id:nonneg,
         ep_tempo_inicial:string,
         ep_tempo_final:string,
         ep_tempo_etapa:string,
         ep_descricao:string).

:- initialization( ( db_attach('./backend/db/tbl_etapa_producao.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(EP_ID,
       EP_TEMPO_INICIAL,
       EP_TEMPO_FINAL,
       EP_TEMPO_ETAPA,
       EP_DESCRICAO) :-
    with_mutex(etapa_producao,
               assert_etapa_producao(EP_ID,
                                     EP_TEMPO_INICIAL,
                                     EP_TEMPO_FINAL,
                                     EP_TEMPO_ETAPA,
                                     EP_DESCRICAO)).

% Método de Remoção de uma etapa_producao, passando o ID da mesma.
% É como se fosse um DELETE FROM etapa_producao WHERE id = id do Sql.
remove(EP_ID) :-
    with_mutex(etapa_producao,
               retract_etapa_producao(EP_ID,
                                      _EP_TEMPO_INICIAL,
                                      _EP_TEMPO_FINAL,
                                      _EP_TEMPO_ETAPA,
                                      _EP_DESCRICAO)).
                           
% Método de Atualização de uma etapa_producao, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(EP_ID,
         EP_TEMPO_INICIAL,
         EP_TEMPO_FINAL,
         EP_TEMPO_ETAPA,
         EP_DESCRICAO) :-
    with_mutex(etapa_producao,
               (retractall_etapa_producao(EP_ID,
                                         _EP_TEMPO_INICIAL,
                                         _EP_TEMPO_FINAL,
                                         _EP_TEMPO_ETAPA,
                                         _EP_DESCRICAO),
               assert_etapa_producao(EP_ID,
                                     EP_TEMPO_INICIAL,
                                     EP_TEMPO_FINAL,
                                     EP_TEMPO_ETAPA,
                                     EP_DESCRICAO))).


