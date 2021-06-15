:- module(
       pessoas,
       [ carrega_tab/1,
         pessoas/8,
         insere/8,
         remove/1,
         atualiza/8]
   ).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   pessoas(idusuarios:nonneg,
            nome:string,
            endereco:string,
            telefone:string,
            bairro:string,
            cpf:string,
            identidade:string,
            complemento:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(Iduser,Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento):-
    chave:pk(pessoa,Iduser),
    with_mutex(pessoas,
               assert_pessoas(Iduser,Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento)).

 remove(Iduser):-
    with_mutex(pessoas,
               retract_pessoas(Iduser,_,_,_,_,_,_,_)).

atualiza(Iduser,Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento):-
    with_mutex(pessoas,
               ( retractall_pessoas(Iduser,_,_,_,_,_,_,_),
                 assert_pessoas(Iduser,Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento)) ).


