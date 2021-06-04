:- module(
    produtos,
    [ carrega_tab/1,
      produtos/7, insere/7
    ]).

:- use_module(library(persistency)).

:- use_module(bd(chave)).

% Importa a biblioteca persistency
:- use_module(library(persistency)).

:- use_module(chave, []).

:- persistent
produtos( prod_cod:nonneg,
          prod_nome:string,
          prod_qtdeAtual:nonneg,
          prod_qtdeMinima:nonneg,
          prod_preco1:float,
          prod_descricao:string,
          prod_preco2:float).

:- initialization( ( db_attach('./backend/db/tbl_produtos.pl', []),
               at_halt(db_sync(gc(always))) )).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

insere(PROD_COD, 
      PROD_NOME,
      PROD_QTDEATUAL,
      PROD_QTDEMINIMA,
      PROD_PRECO1,
      PROD_PRECO2,
      PROD_DESC):- chave: pk(produtos,PROD_COD),
         with_mutex(produtos, assert_produtos(
                PROD_COD, 
                PROD_NOME,
                PROD_QTDATUAL,
                PROD_QTDEMINIMA,
                PROD_PRECO1,
                PROD_PRECO2,
                PROD_DESC)
              ).

