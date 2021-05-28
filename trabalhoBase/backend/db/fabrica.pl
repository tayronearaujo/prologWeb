:- module(
        fabrica, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          fabrica/4
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

%    table FABRICA {
%        fab_id: NUMBER(10)(PK)
%        pes_id: NUMBER(10)(FK)
%        fab_cnpj: VARCHAR(14)
%        fab_inscricao: NUMBER(10)
%    }

% Esquema da relação fabrica
:- persistent
   fabrica(fab_id:nonneg,
           pes_id:nonneg,
           fab_cnpj:string,
           fab_inscricao:nonneg).

:- initialization( ( db_attach('./backend/db/tbl_fabrica.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(FAB_ID,
       PES_ID,
       FAB_CNPJ,
       FAB_INSCRICAO) :-
    with_mutex(fabrica,
               assert_fabrica(FAB_ID,
                             PES_ID,
                             FAB_CNPJ,
                             FAB_INSCRICAO)).

% Método de Remoção de uma fabrica, passando o ID da mesma.
% É como se fosse um DELETE FROM fabrica WHERE id = id do Sql.
remove(FAB_ID) :-
    with_mutex(fabrica,
               retract_fabrica(FAB_ID,
                              _PES_ID,
                              _FAB_CNPJ,
                              _FAB_INSCRICAO)).

% Método de Atualização de uma fabrica, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(FAB_ID,
         PES_ID,
         FAB_CNPJ,
         FAB_INSCRICAO) :-
    with_mutex(fabrica,
               (retractall_fabrica(FAB_ID,
                                 _PES_ID,
                                 _FAB_CNPJ,
                                 _FAB_INSCRICAO),
               assert_fabrica(FAB_ID,
                             PES_ID,
                             FAB_CNPJ,
                             FAB_INSCRICAO))).


