:- module(
    item,
    [ carrega_tab/1,
    item/4,
      insere/4,
      remove/1,
      atualiza/4]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).
:- persistent
   item( idItem:nonneg,
               codigo:string,
               quantidade:string,
               valor:string).

            :- initialization( at_halt(db_sync(gc(always))) ).

        carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).
        
        insere(IdItem,Codigo,Quantidade,Valor):-
            chave:pk(idItem,IdItem),
            with_mutex(item,
                       assert_item(IdItem,Codigo,Quantidade,Valor)).
        
        remove(IdItem):-
            with_mutex(item,
                       retract_item(IdItem,_,_,_,_,_,_,_)).
        
        atualiza(IdItem,Codigo,Quantidade,Valor):-
            with_mutex(item,
                       ( retract_item(IdItem,_,_,_,_,_,_,_),
                         assert_item(IdItem,Codigo,Quantidade,Valor))).