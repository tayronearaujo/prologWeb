:- module(
    funcionarios, % nome do módulo
    [ % aqui são colocados os predicados a serem exportados
      % no formato funtor/aridade.
      funcionarios/5
    ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).


% Esquema da relação funcionarios
:- persistent
funcionarios(numfunc: integer,
      adimissao: date(Date),
      carteiraTrabalho: integer,
      ferias: date,
      horario: integer).

:- initialization( ( db_attach('../db/tbl_funcionarios.pl', []),
                 at_halt(db_sync(gc(always))) )).