:- module(
  pessoas, % nome do módulo
  [ % aqui são colocados os predicados a serem exportados
    % no formato funtor/aridade.
    pessoas/7
  ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

:- persistent
    pessoas( 
        pessoa_nome:string,
        pessoa_endereco:nonneg,
        pessoa_telefone:nonneg,
        pessoa_bairro:floar,
        pessoa_cpf:nonneg,
        pessoa_identidade:nonneg,
        pessoa_complemento:string).

:- initialization( ( db_attach('tbl_pessoas.pl', []),
               at_halt(db_sync(gc(always))) )).
