:- module(
        pessoa, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          pessoa/6
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

%    table PESSOA {
%        pes_id: NUMBER(10)(PK)
%        cep_id: NUMBER(10)(FK)
%        pes_nome: VARCHAR(45)
%        pes_telefone: VARCHAR(20)
%        pes_email: VARCHAR(100)
%        pes_numero: VARCHAR(20)
%    }

% Esquema da relação pessoa
:- persistent
   pessoa(pes_id:nonneg,
          cep_id:nonneg,
          pes_nome:string,
          pes_telefone:string,
          pes_email:string,
          pes_numero:string).


:- initialization( ( db_attach('./backend/db/tbl_pessoa.pl', []),
                     at_halt(db_sync(gc(always))) )).

% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(PES_ID,
       CEP_ID,
       PES_NOME,
       PES_TELEFONE,
       PES_EMAIL,
       PES_NUMERO) :-
    with_mutex(pessoa,
               assert_pessoa(PES_ID,
                             CEP_ID,
                             PES_NOME,
                             PES_TELEFONE,
                             PES_EMAIL,
                             PES_NUMERO)).

% Método de Remoção de uma pessoa, passando o ID da mesma.
% É como se fosse um DELETE FROM pessoa WHERE id = id do Sql.
remove(PES_ID) :-
    with_mutex(pessoa,
               retract_pessoa(PES_ID,
                              _CEP_ID,
                              _PES_NOME,
                              _PES_TELEFONE,
                              _PES_EMAIL,
                              _PES_NUMERO)).

% Método de Atualização de uma pessoa, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(PES_ID,
         CEP_ID,
         PES_NOME,
         PES_TELEFONE,
         PES_EMAIL,
         PES_NUMERO) :-
    with_mutex(pessoa,
               (retractall_pessoa(PES_ID,
                                 _CEP_ID,
                                 _PES_NOME,
                                 _PES_TELEFONE,
                                 _PES_EMAIL,
                                 _PES_NUMERO),
               assert_pessoa(PES_ID,
                             CEP_ID,
                             PES_NOME,
                             PES_TELEFONE,
                             PES_EMAIL,
                             PES_NUMERO))).
