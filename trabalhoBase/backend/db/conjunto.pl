:- module(
        conjunto, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          conjunto/2
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

%    table CONJUNTO {
%        con_id:   NUMBER(10)(PK)
%        con_nome: VARCHAR(30)
%    }

% Esquema da relação conjunto
:- persistent
   conjunto(con_id:nonneg,
            con_nome:string).

:- initialization( ( db_attach('./backend/db/tbl_conjunto.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(CON_ID,
       CON_NOME) :-
    with_mutex(conjunto,
               assert_conjunto(CON_ID,
                               CON_NOME)).

% Método de Remoção de um conjunto, passando o ID da mesma.
% É como se fosse um DELETE FROM conjunto WHERE id = id do Sql.
remove(CON_ID) :-
    with_mutex(conjunto,
               retract_conjunto(CON_ID,
                                _CON_NOME)).
                           
% Método de Atualização de um conjunto, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(CON_ID,
         CON_NOME) :-
    with_mutex(conjunto,
               (retractall_conjunto(CON_ID,
                                   _CON_NOME),
               assert_conjunto(CON_ID,
                               CON_NOME))).


