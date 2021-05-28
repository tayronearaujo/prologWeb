:- module(
        peca, % nome do módulo
        [ % aqui são colocados os predicados a serem exportados
          % no formato funtor/aridade.
          peca/18
        ]).

% Importa a biblioteca persistency
:- use_module(library(persistency)).
/*
    table PECA {
        pec_id: NUMBER(10)(PK)
        gru_id: NUMBER(10)(FK)
        con_id: NUMBER(10)(FK)
        avi_id: NUMBER(10)(FK)
        pec_nome: VARCHAR(45)
        pec_peso_bruto: FLOAT
        pec_peso_liquido: FLOAT
        pec_custo: FLOAT
        pec_cod_fabricacao: VARCHAR(15)
        pec_cod_armazenamento: VARCHAR(15)
        pec_estoque_max: FLOAT
        pec_estoque_min: FLOAT
        pec_qtd_estoque: FLOAT
        pec_sala: VARCHAR(15)
        pec_prateleira: VARCHAR(45)
        pec_gaveta: VARCHAR(45)
        pec_estante: VARCHAR(45)
        pec_corredor: VARCHAR(45)
    }
*/

% Esquema da relação peca
:- persistent
   peca(pec_id:nonneg,
        gru_id:nonneg,
        con_id:nonneg,
        avi_id:nonneg,
        pec_nome:string,
        pec_peso_bruto:float,
        pec_peso_liquido:float,
        pec_custo:float,
        pec_cod_fabricacao:string,
        pec_cod_armazenamento:string,
        pec_estoque_max:float,
        pec_estoque_min:float,
        pec_qtd_estoque:float,
        pec_sala:string,
        pec_prateleira:string,
        pec_gaveta:string,
        pec_estante:string,
        pec_corredor:string).

:- initialization( ( db_attach('./backend/db/tbl_peca.pl', []),
                     at_halt(db_sync(gc(always))) )).

% Método de Inserção na relação
% É como se fosse o INSERT INTO do Sql.
insere(PEC_ID,
       GRU_ID,
       CON_ID,
       AVI_ID,
       PEC_NOME,
       PEC_PESO_BRUTO,
       PEC_PESO_LIQUIDO,
       PEC_CUSTO,
       PEC_COD_FABRICACAO,
       PEC_COD_ARMAZENAMENTO,
       PEC_ESTOQUE_MAX,
       PEC_ESTOQUE_MIN,
       PEC_QTD_ESTOQUE,
       PEC_SALA,
       PEC_PRATELEIRA,
       PEC_GAVETA,
       PEC_ESTANTE,
       PEC_CORREDOR) :-
    with_mutex(peca,
               assert_peca(PEC_ID,
                           GRU_ID,
                           CON_ID,
                           AVI_ID,
                           PEC_NOME,
                           PEC_PESO_BRUTO,
                           PEC_PESO_LIQUIDO,
                           PEC_CUSTO,
                           PEC_COD_FABRICACAO,
                           PEC_COD_ARMAZENAMENTO,
                           PEC_ESTOQUE_MAX,
                           PEC_ESTOQUE_MIN,
                           PEC_QTD_ESTOQUE,
                           PEC_SALA,
                           PEC_PRATELEIRA,
                           PEC_GAVETA,
                           PEC_ESTANTE,
                           PEC_CORREDOR)).

% Método de Remoção de uma peça, passando o ID da mesma.
% É como se fosse um DELETE FROM peca WHERE id = id do Sql.
remove(PEC_ID) :-
    with_mutex(peca,
               retract_peca(PEC_ID,
                           _GRU_ID,
                           _CON_ID,
                           _AVI_ID,
                           _PEC_NOME,
                           _PEC_PESO_BRUTO,
                           _PEC_PESO_LIQUIDO,
                           _PEC_CUSTO,
                           _PEC_COD_FABRICACAO,
                           _PEC_COD_ARMAZENAMENTO,
                           _PEC_ESTOQUE_MAX,
                           _PEC_ESTOQUE_MIN,
                           _PEC_QTD_ESTOQUE,
                           _PEC_SALA,
                           _PEC_PRATELEIRA,
                           _PEC_GAVETA,
                           _PEC_ESTANTE,
                           _PEC_CORREDOR)).



% Método de Atualização de uma peça, passando o ID da mesma.
% É como se fosse um UPDATE do Sql, só que aqui ele remove primeiro e insere com os novos dados
% atualizados.
atualiza(PEC_ID,
         GRU_ID,
         CON_ID,
         AVI_ID,
         PEC_NOME,
         PEC_PESO_BRUTO,
         PEC_PESO_LIQUIDO,
         PEC_CUSTO,
         PEC_COD_FABRICACAO,
         PEC_COD_ARMAZENAMENTO,
         PEC_ESTOQUE_MAX,
         PEC_ESTOQUE_MIN,
         PEC_QTD_ESTOQUE,
         PEC_SALA,
         PEC_PRATELEIRA,
         PEC_GAVETA,
         PEC_ESTANTE,
         PEC_CORREDOR) :-
    with_mutex(peca,
               (retractall_peca(PEC_ID,
                           _GRU_ID,
                           _CON_ID,
                           _AVI_ID,
                           _PEC_NOME,
                           _PEC_PESO_BRUTO,
                           _PEC_PESO_LIQUIDO,
                           _PEC_CUSTO,
                           _PEC_COD_FABRICACAO,
                           _PEC_COD_ARMAZENAMENTO,
                           _PEC_ESTOQUE_MAX,
                           _PEC_ESTOQUE_MIN,
                           _PEC_QTD_ESTOQUE,
                           _PEC_SALA,
                           _PEC_PRATELEIRA,
                           _PEC_GAVETA,
                           _PEC_ESTANTE,
                           _PEC_CORREDOR),
               assert_peca(PEC_ID,
                           GRU_ID,
                           CON_ID,
                           AVI_ID,
                           PEC_NOME,
                           PEC_PESO_BRUTO,
                           PEC_PESO_LIQUIDO,
                           PEC_CUSTO,
                           PEC_COD_FABRICACAO,
                           PEC_COD_ARMAZENAMENTO,
                           PEC_ESTOQUE_MAX,
                           PEC_ESTOQUE_MIN,
                           PEC_QTD_ESTOQUE,
                           PEC_SALA,
                           PEC_PRATELEIRA,
                           PEC_GAVETA,
                           PEC_ESTANTE,
                           PEC_CORREDOR))).


