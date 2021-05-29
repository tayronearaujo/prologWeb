:- module(
    fluxoDeCaixa, % nome do módulo
    [ % aqui são colocados os predicados a serem exportados
      % no formato funtor/aridade.
      fluxoDeCaixa/2
    ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).


% Esquema da relação fluxoDeCaixa
:- persistent
fluxoDeCaixa(
              numeroTransacao: integer,
              valor:float).

:- initialization( ( db_attach('tbl_fluxoDeCaixa.pl', []),
               at_halt(db_sync(gc(always))) )).