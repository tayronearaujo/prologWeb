:- module(
    pessoas, % nome do módulo
    [ carrega_tab/1,
        insere/8,
        pessoas/8
    ]).

  % Importa a biblioteca persistency
  :- use_module(library(persistency)).
  
:- use_module(chave,[]).

  :- persistent
      pessoas( 
        pessoa_id:nonneg,
        pessoa_nome:string,
        pessoa_endereco:nonneg,
        pessoa_telefone:nonneg,
        pessoa_bairro:string,
        pessoa_cpf:nonneg,
        pessoa_identidade:nonneg,
        pessoa_complemento:string).
  
:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

insere(PES_ID,
       PES_NOME,
       PES_ENDERECO,
       PES_TELEFONE,
       PES_BAIRRO,
       PES_CPF,
       PES_IDENTIDADE,
       PES_COMPLEMENTO) :-
        chave:pk(pessoas,PES_ID),
        with_mutex(pessoas,
               assert_pessoas(  PES_ID,
                                PES_NOME,
                                PES_ENDERECO,
                                PES_TELEFONE,
                                PES_BAIRRO,
                                PES_CPF,
                                PES_IDENTIDADE,
                                PES_COMPLEMENTO)).
