:- module(
    fluxoDeCaixa,
    [ carrega_tab/1,
    fluxoDeCaixa/3,
      insere/3,
      remove/1,
      atualiza/3]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
fluxoDeCaixa(
              flu_id:nonneg,
              numeroTransacao:string,
              valor:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(Flu_id,NumeroTransacao,Valor):-
 chave:pk(fluxoDeCaixa,Flu_id),
 with_mutex(fluxoDeCaixa,
            assert_fluxoDeCaixa(Flu_id,NumeroTransacao,Valor)).

remove(Flu_id):-
 with_mutex(fluxoDeCaixa,
            retract_fluxoDeCaixa(Flu_id,_,_,_,_,_,_,_)).

atualiza(Flu_id,NumeroTransacao,Valor):-
 with_mutex(fluxoDeCaixa,
            ( retractall_fluxoDeCaixa(Flu_id,_,_,_,_,_,_,_),
              assert_fluxoDeCaixa(Flu_id,NumeroTransacao,Valor)) ).


