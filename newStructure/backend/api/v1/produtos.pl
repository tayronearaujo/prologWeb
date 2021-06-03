/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(produtos)).
:- use_module(bd(chave)).

produtos(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados, Id),
    envia_tupla(Id).

insere_tupla( _{prod_cod:PROD_COD,prod_nome:PROD_NOME, prod_qtdeAtual:PROD_QTDATUAL,prod_qtdeMinima:PROD_QTDEMINIMA,prod_preco1:PROD_PRECO1,prod_preco2:PROD_PRECO2,prod_descricao:PROD_DESC}, Id):-
    pk(produtos,PROD_COD),
    produtos:insere(PROD_COD, PROD_NOME, PROD_QTDATUAL,PROD_QTDEMINIMA,PROD_PRECO1,PROD_PRECO2,PROD_DESC).

envia_tupla(Id):-
    (  produtos:produtos(PROD_COD, PROD_NOME, PROD_QTDATUAL,PROD_QTDEMINIMA,PROD_PRECO1,PROD_PRECO2,PROD_DESC)
    -> reply_json_dict( _{prod_cod:PROD_COD,prod_nome:PROD_NOME, prod_qtdeAtual:PROD_QTDATUAL,prod_qtdeMinima:PROD_QTDEMINIMA,prod_preco1:PROD_PRECO1,prod_preco2:PROD_PRECO2,prod_descricao:PROD_DESC} )
    ;  throw(http_reply(not_found(Id)))
    ).


