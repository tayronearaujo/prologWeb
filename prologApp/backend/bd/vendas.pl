:- module(
    vendas,
    [ carrega_tab/1,
    vendas/6,
      insere/6,
      remove/1,
      atualiza/6]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).
:- persistent
   vendas( idVendas:nonneg,
               numero_vendendor:string,
               numero:string,
               data:string,
               hora: string,
               forma_pagamento:string).

            :- initialization( at_halt(db_sync(gc(always))) ).

        carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).
        
        insere(IdVendas,Numero_Vendedor,Numero,Data,Hora,Forma_Pagamento):-
            chave:pk(idVendas,IdVendas),
            with_mutex(vendas,
                       assert_vendas(IdVendas,Numero_Vendedor,Numero,Data,Hora,Forma_Pagamento)).
        
        remove(IdVendas):-
            with_mutex(vendas,
                       retract_vendas(IdVendas,_,_,_,_,_,_,_)).
        
        atualiza(IdVendas,Numero_Vendedor,Numero,Data,Hora,Forma_Pagamento):-
            with_mutex(vendas,
                       ( retract_vendas(IdVendas,_,_,_,_,_,_,_),
                         assert_vendas(IdVendas,Numero_Vendedor,Numero,Data,Hora,Forma_Pagamento))).
        