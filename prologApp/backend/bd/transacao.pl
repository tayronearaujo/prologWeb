:- module(
    transacao,
    [ carrega_tab/1,
    transacao/4,
      insere/4,
      remove/1,
      atualiza/4]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).
:- persistent
   transacao( idTranscao:nonneg,
               numero:string,
               hora:string,
               valor:string).

            :- initialization( at_halt(db_sync(gc(always))) ).

        carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).
        
        insere(IdTranscao,Numero,Hora,Valor):-
            chave:pk(idTranscao,IdTranscao),
            with_mutex(transacao,
                       assert_transacao(IdTranscao,Numero,Hora,Valor)).
        
        remove(IdTranscao):-
            with_mutex(transacao,
                       retract_transacao(IdTranscao,_,_,_,_,_,_,_)).
        
        atualiza(IdTranscao,Numero,Hora,Valor):-
            with_mutex(transacao,
                       ( retract_produtos(IdTranscao,_,_,_,_,_,_,_),
                         assert_produtos(IdTranscao,Numero,Hora,Valor))).
        


