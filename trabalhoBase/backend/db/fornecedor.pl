:- module(
        fornecedor, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          fornecedor/10
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

%    table FORNECEDOR {
%        for_id: NUMBER(10)(PK)
%        pes_id: NUMBER(10)(FK)
%        for_cnpj: VARCHAR(45)
%        for_inscricao: VARCHAR(14)
%        for_nome_contato: VARCHAR(25)
%        for_email_contato: VARCHAR(25)
%        for_situacao: VARCHAR(100)
%        for_telefone_contato: VARCHAR(30)
%        for_status: VARCHAR(30)
%        for_categoria: VARCHAR(30)
%    }

% Esquema da relação fornecedor
:- persistent
   fornecedor(for_id:nonneg,
              pes_id:nonneg,
              for_cnpj:string,
              for_inscricao:string,
              for_nome_contato:string,
              for_email_contato:string,
              for_situacao:string,
              for_telefone_contato:string,
              for_status:string,
              for_categoria:string).
              
              
:- initialization((db_attach('./backend/db/tbl_fornecedor.pl', []),
                     at_halt(db_sync(gc(always))) )).

% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(FOR_ID,
       PES_ID,
       FOR_CNPJ,
       FOR_INSCRICAO,
       FOR_NOME_CONTATO,
       FOR_EMAIL_CONTATO,
       FOR_SITUACAO,
       FOR_TELEFONE_CONTATO,
       FOR_STATUS,
       FOR_CATEGORIA) :-
    with_mutex(fornecedor,
               assert_fornecedor(FOR_ID,
                                 PES_ID,
                                 FOR_CNPJ,
                                 FOR_INSCRICAO,
                                 FOR_NOME_CONTATO,
                                 FOR_EMAIL_CONTATO,
                                 FOR_SITUACAO,
                                 FOR_TELEFONE_CONTATO,
                                 FOR_STATUS,
                                 FOR_CATEGORIA)).

% Método de Remoção de um fornecedor, passando o ID da mesma.
% É como se fosse um DELETE FROM fornecedor WHERE id = id do Sql.
remove(FOR_ID) :-
    with_mutex(fornecedor,
               retract_fornecedor(FOR_ID,
                                  _PES_ID,
                                  _FOR_CNPJ,
                                  _FOR_INSCRICAO,
                                  _FOR_NOME_CONTATO,
                                  _FOR_EMAIL_CONTATO,
                                  _FOR_SITUACAO,
                                  _FOR_TELEFONE_CONTATO,
                                  _FOR_STATUS,
                                  _FOR_CATEGORIA)).
                           
% Método de Atualização de um fornecedor, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(FOR_ID,
         PES_ID,
         FOR_CNPJ,
         FOR_INSCRICAO,
         FOR_NOME_CONTATO,
         FOR_EMAIL_CONTATO,
         FOR_SITUACAO,
         FOR_TELEFONE_CONTATO,
         FOR_STATUS,
         FOR_CATEGORIA) :-
    with_mutex(fornecedor,
               (retractall_fornecedor(FOR_ID,
                                     _PES_ID,
                                     _FOR_CNPJ,
                                     _FOR_INSCRICAO,
                                     _FOR_NOME_CONTATO,
                                     _FOR_EMAIL_CONTATO,
                                     _FOR_SITUACAO,
                                     _FOR_TELEFONE_CONTATO,
                                     _FOR_STATUS,
                                     _FOR_CATEGORIA),
               assert_fornecedor(FOR_ID,
                                 PES_ID,
                                 FOR_CNPJ,
                                 FOR_INSCRICAO,
                                 FOR_NOME_CONTATO,
                                 FOR_EMAIL_CONTATO,
                                 FOR_SITUACAO,
                                 FOR_TELEFONE_CONTATO,
                                 FOR_STATUS,
                                 FOR_CATEGORIA))).
