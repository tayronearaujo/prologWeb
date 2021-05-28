:- module(
       bairro,
       [ bairro/2 ]).

:- use_module(library(persistency)).

:- use_module(db(chave)).


:- persistent
   bairro(bai_id:nonneg,
          bai_nome:string).

:- initialization( ( db_attach('./backend/db/tbl_bairro.pl', []),
                     at_halt(db_sync(gc(always))) )).


insere(BAI_ID, BAI_NOME):-
    chave:pk(bairro, BAI_ID),
    with_mutex(bairro,
               assert_bairro(BAI_ID, BAI_NOME)).

remove(BAI_ID):-
    with_mutex(bairro,
               retractall_bairro(BAI_ID, _BAI_NOME)).

atualiza(BAI_ID, BAI_NOME):-
    with_mutex(bairro,
               ( retractall_bairro(BAI_ID, _BAI_NOME),
                 assert_bairro(BAI_ID, BAI_NOME)) ).
