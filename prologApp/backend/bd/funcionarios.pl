:- module(
    funcionarios,
    [ carrega_tab/1,
    funcionarios/6,
      insere/6,
      remove/1,
      atualiza/6]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
funcionarios(fun_id: nonneg,
      numfunc: string,
      adimissao: string,
      carteiraTrabalho: string,
      ferias: string,
      horario: string).
:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario):-
 chave:pk(funcionarios,Fun_id),
 with_mutex(funcionarios,
            assert_funcionarios(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario)).

remove(Fun_id):-
 with_mutex(funcionarios,
            retract_funcionarios(Fun_id,_,_,_,_,_,_,_)).

atualiza(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horariorio):-
 with_mutex(funcionarios,
            ( retractall_funcionarios(Fun_id,_,_,_,_,_,_,_),
              assert_fluxoDeCaixa(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horariorio)) ).
