:- module(
        etapa_peca, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          etapa_peca/3
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).
/*
    table etapa_peca {
        ep_id: NUMBER(10)(FK)
        pec_id: NUMBER(10)(FK)
        epe_qtd_peca: FLOAT
    }
*/

% Esquema da relação etapa_peca
:- persistent
   etapa_peca(ep_id:nonneg,
              pec_id:nonneg,
              epe_qtd_peca:float).

:- initialization( ( db_attach('./backend/db/tbl_etapa_peca.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(EP_ID,
       PEC_ID,
       EPE_QTD_PECA) :-
    with_mutex(etapa_peca,
               assert_etapa_peca(EP_ID,
                                 PEC_ID,
                                 EPE_QTD_PECA)).

% Método de Remoção de uma etapa_peca, passando o ID da mesma.
% É como se fosse um DELETE FROM etapa_peca WHERE id = id do Sql.
remove(EP_ID,
       PEC_ID) :-
    with_mutex(etapa_peca,
               retract_etapa_peca(EP_ID,
                                  PEC_ID,
                                  _EPE_QTD_PECA)).
                           
% Método de Atualização de uma etapa_peca, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(EP_ID,
         PEC_ID,
         EPE_QTD_PECA) :-
    with_mutex(etapa_peca,
               (retractall_etapa_peca(EP_ID,
                                     PEC_ID,
                                     _EPE_QTD_PECA),
               assert_etapa_peca(EP_ID,
                                 PEC_ID,
                                 EPE_QTD_PECA))).


