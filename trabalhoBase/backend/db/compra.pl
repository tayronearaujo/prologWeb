:- module(
        compra, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          compra/6
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).
/*
    table COMPRA {
        com_id: NUMBER(10)(PK)
        for_id: NUMBER(10)(FK)
        com_data_compra: DATE
        com_data_entrega: DATE
        com_numero_documento: VARCHAR(15)
        com_nota_total: FLOAT
    }
*/

% Esquema da relação compra
:- persistent
   compra(com_id:nonneg,
          for_id:nonneg,
          com_data_compra:string,
          com_data_entrega:string,
          com_numero_documento:string,
          com_nota_total:float).

:- initialization( ( db_attach('./backend/db/tbl_compra.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(COM_ID,
       FOR_ID,
       COM_DATA_COMPRA,
       COM_DATA_ENTREGA,
       COM_NUMERO_DOCUMENTO,
       COM_TOTAL_NOTA) :-
    with_mutex(compra,
               assert_compra(COM_ID,
                             FOR_ID,
                             COM_DATA_COMPRA,
                             COM_DATA_ENTREGA,
                             COM_NUMERO_DOCUMENTO,
                             COM_TOTAL_NOTA)).

% Método de Remoção de uma compra, passando o ID da mesma.
% É como se fosse um DELETE FROM compra WHERE id = id do Sql.
remove(COM_ID) :-
    with_mutex(compra,
               retract_compra(COM_ID,
                              _FOR_ID,
                              _COM_DATA_COMPRA,
                              _COM_DATA_ENTREGA,
                              _COM_NUMERO_DOCUMENTO,
                              _COM_TOTAL_NOTA)).
                           
% Método de Atualização de uma compra, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(COM_ID,
         FOR_ID,
         COM_DATA_COMPRA,
         COM_DATA_ENTREGA,
         COM_NUMERO_DOCUMENTO,
         COM_TOTAL_NOTA) :-
    with_mutex(compra,
               (retractall_compra(COM_ID,
                                 _FOR_ID,
                                 _COM_DATA_COMPRA,
                                 _COM_DATA_ENTREGA,
                                 _COM_NUMERO_DOCUMENTO,
                                 _COM_TOTAL_NOTA),
               assert_compra(COM_ID,
                             FOR_ID,
                             COM_DATA_COMPRA,
                             COM_DATA_ENTREGA,
                             COM_NUMERO_DOCUMENTO,
                             COM_TOTAL_NOTA))).


