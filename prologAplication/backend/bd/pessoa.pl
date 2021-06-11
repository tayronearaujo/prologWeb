:- module(
    pessoa, % nome do módulo
    [ carrega_tab/1,
        insere/3,
        pessoa/3 ]).

  % Importa a biblioteca persistency
  :- use_module(library(persistency)).
  
:- use_module(chave,[]).

  :- persistent
      pessoa( 
        id:positive_integer,
        nome:string,
        endereco:string
        % pessoa_telefone:nonneg,
        % pessoa_bairro:string,
        % pessoa_cpf:nonneg,
        % pessoa_identidade:nonneg,
        % pessoa_complemento:string
        ).
  
:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

insere(Id, Nome, Sobrenome) :-
        chave:pk(pessoa, Id),
        with_mutex(pessoa, assert_pessoas(Id, Nome, Sobrenome)).
