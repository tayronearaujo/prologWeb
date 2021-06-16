:- module(
    cliente,
    [ carrega_tab/1,
    cliente/6,
      insere/6,
      remove/1,
      atualiza/6]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).
:- persistent
   cliente( idCliente:nonneg,
               compras:string,
               num_cliente:string,
               num_vendedor:string,
               credito: string,
               valor_credito:string).

            :- initialization( at_halt(db_sync(gc(always))) ).

        carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).
        
        insere(IdCliente,Compras,Num_cliente,Num_vendendor,Credito,Valor_credito):-
            chave:pk(idCliente,IdCliente),
            with_mutex(cliente,
                       assert_cliente(IdCliente,Compras,Num_cliente,Num_vendendor,Credito,Valor_credito)).
        
        remove(IdCliente):-
            with_mutex(cliente,
                       retract_vendas(IdCliente,_,_,_,_,_,_,_)).
        
        atualiza(IdCliente,Compras,Num_cliente,Num_vendendor,Credito,Valor_credito):-
            with_mutex(cliente,
                       ( retract_cliente(IdCliente,_,_,_,_,_,_,_),
                         assert_cliente(IdCliente,Compras,Num_cliente,Num_vendendor,Credito,Valor_credito))).