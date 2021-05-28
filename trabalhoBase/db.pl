:- load_files([ rotas,
                schemas(aviao),
                schemas(bairro),
                schemas(cep),
                schemas(chave),
                schemas(cidade),
                schemas(compra),
                schemas(compra_item),
                schemas(conjunto),
                schemas(etapa_peca),
                schemas(etapa_producao),
                schemas(fabrica),
                schemas(fornecedor),
                schemas(funcionario),
                schemas(grupo),
                schemas(logradouro),
                schemas(peca),
                schemas(pessoa),
                schemas(teste)
              ],
	          [ if(not_loaded), 
                silent(true) 
	          ]).
        
:- initialization(init_tables).

table(aviao).
table(bairro).
table(cep).
table(chave).
table(cidade).
table(compra).
table(compra_item).
table(conjunto).
table(etapa_peca).
table(etapa_producao).
table(fabrica).
table(fornecedor).
table(funcionario).
table(grupo).
table(logradouro).
table(peca).
table(pessoa).
table(teste).

init_tables :-
    findall(Table, table(Table), Tables),
    append_all_files(Tables).

append_all_files([Table|Tables]) :-
    append_files(Table), !,
    append_all_files(Tables).

append_all_files([]).

append_files(File) :- !,
    atomic_list_concat(['tbl_', File, '.pl'], FileName),
    expand_file_search_path(tables(FileName), PathTableFile),
    File:file_path(PathTableFile).


% Lista Fornecedores relacionando as "tabelas" dependentes
lista_for(FORNECEDORES) :-
findall((FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
         FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO,
         CID_ID,CID_NOME,CID_UF,BAI_ID, BAI_NOME, LOG_ID,LOG_NOME,LOG_NUMERO),
    lista_fornecedores(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                       FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO,
                       CID_ID,CID_NOME,CID_UF,BAI_ID, BAI_NOME, LOG_ID,LOG_NOME,LOG_NUMERO),
                       FORNECEDORES).

lista_fornecedores(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                   FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO,
                   CID_ID,CID_NOME,CID_UF,BAI_ID, BAI_NOME, LOG_ID,LOG_NOME,LOG_NUMERO) :-
    fornecedor(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
               FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA),
    pessoa(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
    cidade(CID_ID,CID_NOME,CID_UF),
    bairro(BAI_ID, BAI_NOME),
    logradouro(LOG_ID,LOG_NOME,LOG_NUMERO),
    cep(CEP_ID, CID_ID, BAI_ID, LOG_ID).

% Cadastra um fornecedor novo:

cadastra_fornecedor(FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                    FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO,
                    CID_NOME,CID_UF,BAI_NOME,LOG_NOME,LOG_NUMERO) :-
    pk(fornecedor,FOR_ID),
    pk(pessoa,PES_ID),
    pk(cidade,CID_ID),
    pk(bairro,BAI_ID),
    pk(logradouro,LOG_ID),
    pk(cep,CEP_ID),
    cidade:insere(CID_ID,CID_NOME,CID_UF),
    bairro:insere(BAI_ID, BAI_NOME),
    logradouro:insere(LOG_ID,LOG_NOME,LOG_NUMERO),
    cep:insere(CEP_ID, CID_ID, BAI_ID, LOG_ID),
    pessoa:insere(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
    fornecedor:insere(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                      FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA).


% Remove um fornecedor
remove_fornecedor(FOR_ID) :-
    fornecedor(FOR_ID,PES_ID,_,_,_,_,_,_,_,_),
    pessoa:remove(PES_ID),
    fornecedor:remove(FOR_ID).

% Atualiza o cadastro de um fornecedor:
atualiza_fornecedor(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                    FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO,
                  CID_ID,CID_NOME,CID_UF,BAI_ID, BAI_NOME, LOG_ID,LOG_NOME,LOG_NUMERO) :-

    fornecedor:atualiza(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                         FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA),
    pessoa:atualiza(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
    cidade:atualiza(CID_ID,CID_NOME,CID_UF),
    bairro:atualiza(BAI_ID, BAI_NOME),
    logradouro:atualiza(LOG_ID,LOG_NOME,LOG_NUMERO),

    cep:atualiza(CEP_ID, CID_ID, BAI_ID, LOG_ID).


% ----------------------------------------- CRUD PEÇAS ------------------------------------------------

lista_pecas(PEC_ID,GRU_ID,CON_ID,AVI_ID,PEC_NOME,PEC_PESO_BRUTO,
           PEC_PESO_LIQUIDO,PEC_CUSTO,PEC_COD_FABRICACAO,
           PEC_COD_ARMAZENAMENTO,PEC_ESTOQUE_MAX,PEC_ESTOQUE_MIN,
           PEC_QTD_ESTOQUE,PEC_SALA,PEC_PRATELEIRA,PEC_GAVETA,
           PEC_ESTANTE,PEC_CORREDOR,AVI_NOME,GRU_NOME,CON_NOME) :-
    peca(PEC_ID,GRU_ID,CON_ID,AVI_ID,PEC_NOME,PEC_PESO_BRUTO,
         PEC_PESO_LIQUIDO,PEC_CUSTO,PEC_COD_FABRICACAO,PEC_COD_ARMAZENAMENTO,
         PEC_ESTOQUE_MAX,PEC_ESTOQUE_MIN,PEC_QTD_ESTOQUE,PEC_SALA,PEC_PRATELEIRA,
         PEC_GAVETA,PEC_ESTANTE,PEC_CORREDOR),
    grupo(GRU_ID,GRU_NOME),
    conjunto(CON_ID,CON_NOME),
    aviao(AVI_ID, AVI_NOME).


% ----------------------------------------- CRUD COMPRAS -----------------------------------------------

% Cadastra uma compra:
cadastra_compra(FOR_ID,COM_DATA_COMPRA, COM_DATA_ENTREGA, COM_NUMERO_DOCUMENTO, COM_TOTAL_NOTA) :-
    pk(compra,COM_ID),
    fornecedor(FOR_ID,_,_,_,_,_,_,_,_,_),
    compra:insere(COM_ID,FOR_ID,COM_DATA_COMPRA, COM_DATA_ENTREGA, COM_NUMERO_DOCUMENTO, COM_TOTAL_NOTA).

% Atualiza uma compra:
atualiza_compra(COM_ID, FOR_ID,COM_DATA_COMPRA, COM_DATA_ENTREGA, COM_NUMERO_DOCUMENTO, COM_TOTAL_NOTA) :-
    compra:atualiza(COM_ID,FOR_ID,COM_DATA_COMPRA, COM_DATA_ENTREGA, COM_NUMERO_DOCUMENTO, COM_TOTAL_NOTA).

% Cadastra um item de compra:
cadastra_compra_item(COM_ID, PEC_ID, CI_QTD, CI_VALOR_UNITARIO) :-
    pk(compra_item,CI_ID),
    compra_item:insere(CI_ID,COM_ID, PEC_ID, CI_QTD, CI_VALOR_UNITARIO),
    peca(PEC_ID,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_).

% atualiza um item de compra:
atualiza_compra_item(CI_ID,COM_ID, PEC_ID, CI_QTD, CI_VALOR_UNITARIO) :-
    compra:atualiza(CI_ID,COM_ID, PEC_ID, CI_QTD, CI_VALOR_UNITARIO).

% Lista itens de compra:
lista_items(COM_ID,ITEMS) :-
findall((CI_ID,COM_ID, PEC_ID, CI_QTD, CI_VALOR_UNITARIO),
    lista_compra_items(CI_ID, COM_ID, PEC_ID, CI_QTD, CI_VALOR_UNITARIO),ITEMS).

lista_compra_items(CI_ID, COM_ID, PEC_ID, CI_QTD, CI_VALOR_UNITARIO) :-
    compra_item(CI_ID,COM_ID, PEC_ID, CI_QTD, CI_VALOR_UNITARIO).

% Remove compra:
remove_compra(COM_ID) :-
    compra_item(CI_ID,COM_ID, _,_,_),
    compra_item:remove(CI_ID),
    compra:remove(COM_ID).

% Remove item de compra:
remove_compra_item(CI_ID) :-
    compra_item:remove(CI_ID).