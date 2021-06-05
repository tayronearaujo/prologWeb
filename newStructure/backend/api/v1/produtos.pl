/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(produtos),[]).


/*
   POST api/v1/bookmarks
   Adiciona um novo bookmark. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/

produtos(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados, Id),
    envia_tupla(Id).

produtos(Metodo, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Método, Id))).

insere_tupla( _{prod_cod:PROD_COD, prod_nome:PROD_NOME, prod_qtdeAtual:PROD_QTD_ATUAL,prod_qtdeMinima:PROD_QTD_MINIMA,prod_preco1:PROD_PRECO1,prod_preco2:PROD_PRECO2,prod_descricao:PROD_DESC}, Id):-
    produtos:insere(PROD_COD, PROD_NOME, PROD_QTD_ATUAL,PROD_QTD_MINIMA,PROD_PRECO1,PROD_PRECO2,PROD_DESC)
    -> envia_tupla(Id)
    ;  throw(http_reply(bad_request('URL ausente'))).


envia_tupla(Id):-
    (  produtos:produtos(PROD_COD, PROD_NOME, PROD_QTD_ATUAL,PROD_QTD_MINIMA,PROD_PRECO1,PROD_PRECO2,PROD_DESC)
    -> reply_json_dict( _{prod_cod:PROD_COD,prod_nome:PROD_NOME, prod_qtdeAtual:PROD_QTDATUAL,prod_qtdeMinima:PROD_QTDEMINIMA,prod_preco1:PROD_PRECO1,prod_preco2:PROD_PRECO2,prod_descricao:PROD_DESC} )
    ;  throw(http_reply(not_found(Id)))
    ).

envia_tabela :-
    findall( _{prod_cod:PROD_COD,prod_nome:PROD_NOME, prod_qtdeAtual:PROD_QTD_ATUAL,prod_qtdeMinima:PROD_QTD_MINIMA,prod_preco1:PROD_PRECO1,prod_preco2:PROD_PRECO2,prod_descricao:PROD_DESC},
        produtos:bookmark(PROD_COD, PROD_NOME, PROD_QTD_ATUAL,PROD_QTD_MINIMA,PROD_PRECO1,PROD_PRECO2,PROD_DESC),
             Tuplas ),
    reply_json_dict(Tuplas).

