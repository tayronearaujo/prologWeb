:- module(
        funcionario, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          funcionario/8
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

%    table FUNCIONARIO {
%        fun_id: NUMBER(10)(PK)
%        pes_id: NUMBER(10)(FK)
%        fun_cargo: VARCHAR(45)
%        fun_cpf: VARCHAR(14)
%        fun_nro: VARCHAR(25)
%        fun_login: VARCHAR(25)
%        fun_senha: VARCHAR(100)
%        fun_matricula: VARCHAR(30)
%    }

% Esquema da relação funcionario
:- persistent
   funcionario(fun_id:nonneg,
               pes_id:nonneg,
               fun_cargo:string,
               fun_cpf:string,
               fun_nro:string,
               fun_login:string,
               fun_senha:string,
               fun_matricula:string).

:- initialization( ( db_attach('./backend/db/tbl_funcionario.pl', []),
                     at_halt(db_sync(gc(always))) )).


% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(FUN_ID,
       PES_ID,
       FUN_CARGO,
       FUN_CPF,
       FUN_NRO,
       FUN_LOGIN,
       FUN_SENHA,
       FUN_MATRICULA) :-

    with_mutex(funcionario,(
               assert_funcionario(FUN_ID,
                                  PES_ID,
                                  FUN_CARGO,
                                  FUN_CPF,
                                  FUN_NRO,
                                  FUN_LOGIN,
                                  FUN_SENHA,
                                  FUN_MATRICULA))).

% Método de Remoção de um funcionario, passando o ID da mesma.
% É como se fosse um DELETE FROM funcionario WHERE id = id do Sql.
remove(FUN_ID) :-
    with_mutex(funcionario,
               retract_funcionario(FUN_ID,
                                   _PES_ID,
                                   _FUN_CARGO,
                                   _FUN_CPF,
                                   _FUN_NRO,
                                   _FUN_LOGIN,
                                   _FUN_SENHA,
                                   _FUN_MATRICULA)).
                           
% Método de Atualização de um funcionario, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(FUN_ID,
         PES_ID,
         FUN_CARGO,
         FUN_CPF,
         FUN_NRO,
         FUN_LOGIN,
         FUN_SENHA,
         FUN_MATRICULA) :-
    with_mutex(funcionario,
               (retractall_funcionario(FUN_ID,
                                      _PES_ID,
                                      _FUN_CARGO,
                                      _FUN_CPF,
                                      _FUN_NRO,
                                      _FUN_LOGIN,
                                      _FUN_SENHA,
                                      _FUN_MATRICULA),
               assert_funcionario(FUN_ID,
                                  PES_ID,
                                  FUN_CARGO,
                                  FUN_CPF,
                                  FUN_NRO,
                                  FUN_LOGIN,
                                  FUN_SENHA,
                                  FUN_MATRICULA))).


