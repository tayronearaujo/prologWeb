:- module(
  produtos, % nome do módulo
  [ % aqui são colocados os predicados a serem exportados
    % no formato funtor/aridade.
    produtos/7
  ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

:- persistent
produtos(prod_cod:nonneg,
          prod_nome:string,
          prod_qtdeAtual:nonneg,
          prod_qtdeMinima:nonneg,
          prod_preco1:float,
          prod_descricao:string,
          prod_preco2:float).

:- initialization( ( db_attach('./db/tbl_produtos.pl', []),
               at_halt(db_sync(gc(always))) )).
