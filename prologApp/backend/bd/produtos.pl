:- module(
       produtos,
       [ carrega_tab/1,
         produtos/8,
         insere/8,
         remove/1,
         atualiza/8]
   ).
   
:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   produtos( idProdutos:nonneg,
               codigo:string,
               nome:string,
               qtdeAtual:string,
               qtdeMinima:string,
               preco1:string,
               descricao:string,
               preco2:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2):-
    chave:pk(idProdutos,IdProdutos),
    with_mutex(produtos,
               assert_produtos(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2)).

remove(IdProdutos):-
    with_mutex(produtos,
               retract_produtos(IdProdutos,_,_,_,_,_,_,_)).

atualiza(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2):-
    with_mutex(produtos,
               ( retract_produtos(IdProdutos,_,_,_,_,_,_,_),
                 assert_produtos(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2))).
