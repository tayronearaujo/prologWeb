:- module(
    sangria,
    [ carrega_tab/1,
    sangria/4,
      insere/4,
      remove/1,
      atualiza/4]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).
:- persistent
   sangria( idSangria:nonneg,
               numero:string,
               valor:string,
               hora:string).

            :- initialization( at_halt(db_sync(gc(always))) ).

        carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).
        
        insere(IdSangria,Numero,Valor,Hora):-
            chave:pk(idSangria,IdSangria),
            with_mutex(sangria,
                       assert_sangria(IdSangria,Numero,Valor,Hora)).
        
        remove(IdSangria):-
            with_mutex(sangria,
                       retract_sangria(IdSangria,_,_,_,_,_,_,_)).
        
        atualiza(IdSangria,Numero,Valor,Hora):-
            with_mutex(sangria,
                       ( retract_sangria(IdSangria,_,_,_,_,_,_,_),
                         assert_sangria(IdSangria,Numero,Valor,Hora))).