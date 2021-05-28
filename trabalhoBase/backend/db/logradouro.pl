:- module(
        logradouro, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          logradouro/3
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

%    table LOGRADOURO {
%        log_id: NUMBER(10)(PK)
%        log_nome: VARCHAR(45)
%        log_numero: VARCHAR(10)
%    }

% Esquema da relação logradouro
:- persistent
   logradouro(log_id:nonneg,
              log_nome:string,
              log_numero:string).

:- initialization( ( db_attach('./backend/db/tbl_logradouro.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(LOG_ID,
       LOG_NOME,
       LOG_NUMERO) :-
    with_mutex(logradouro,
               assert_logradouro(LOG_ID,
                                 LOG_NOME,
                                 LOG_NUMERO)).

% Método de Remoção de um logradouro, passando o ID da mesma.
% É como se fosse um DELETE FROM logradouro WHERE id = id do Sql.
remove(LOG_ID) :-
    with_mutex(logradouro,
               retract_logradouro(LOG_ID,
                                  _LOG_NOME,
                                  _LOG_NUMERO)).

% Método de Atualização de um logradouro, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(LOG_ID,
         LOG_NOME,
         LOG_NUMERO) :-
    with_mutex(logradouro,
               (retractall_logradouro(LOG_ID,
                                     _LOG_NOME,
                                     _LOG_NUMERO),
               assert_logradouro(LOG_ID,
                                 LOG_NOME,
                                 LOG_NUMERO))).
