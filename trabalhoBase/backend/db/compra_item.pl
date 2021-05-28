:- module(
        compra_item, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          compra_item/5
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).
/*
    table COMPRA_ITEM {
        ci_id: NUMBER(10)(PK)
        com_id: NUMBER(10)(FK)
        pec_id: NUMBER(10)(FK)
        ci_qtd_item: FLOAT
        ci_valor_unitario: FLOAT
    }
*/

% Esquema da relação compra_item
:- persistent
   compra_item(ci_id:nonneg,
               com_id:nonneg,
               pec_id:nonneg,
               ci_qtd_item:float,
               ci_valor_unitario:float).

:- initialization( ( db_attach('./backend/db/tbl_compra_item.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(CI_ID,
       COM_ID,
       PEC_ID,
       CI_QTD_ITEM,
       CI_VALOR_UNITARIO) :-
    with_mutex(compra_item,
               assert_compra_item(CI_ID,
                                  COM_ID,
                                  PEC_ID,
                                  CI_QTD_ITEM,
                                  CI_VALOR_UNITARIO)).

% Método de Remoção de uma compra_item, passando o ID da mesma.
% É como se fosse um DELETE FROM compra_item WHERE id = id do Sql.
remove(CI_ID) :-
    with_mutex(compra_item,
               retract_compra_item(CI_ID,
                                   _COM_ID,
                                   _PEC_ID,
                                   _CI_QTD_ITEM,
                                   _CI_VALOR_UNITARIO)).
                           
% Método de Atualização de uma compra_item, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(CI_ID,
         COM_ID,
         PEC_ID,
         CI_QTD_ITEM,
         CI_VALOR_UNITARIO) :-
    with_mutex(compra_item,
               (retractall_compra_item(CI_ID,
                                      _COM_ID,
                                      _PEC_ID,
                                      _CI_QTD_ITEM,
                                      _CI_VALOR_UNITARIO),
               assert_compra_item(CI_ID,
                                  COM_ID,
                                  PEC_ID,
                                  CI_QTD_ITEM,
                                  CI_VALOR_UNITARIO))).


