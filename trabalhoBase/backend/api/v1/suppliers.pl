/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(db(chave)).
:- use_module(db(fornecedor)).
:- use_module(db(pessoa)).
:- use_module(db(cidade)).
:- use_module(db(bairro)).
:- use_module(db(logradouro)).
:- use_module(db(cep)).

suppliers(get, '', _Pedido):- !,
    suppliers_envia_tabela.

suppliers(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    suppliers_envia_tupla(Id).

suppliers(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    suppliers_insere_tupla(Dados, Id),
    suppliers_envia_tupla(Id).

suppliers(put, _, Pedido):- !,
    http_read_json_dict(Pedido, Dados),
    suppliers_atualiza_tupla(Dados, Id),
    suppliers_envia_tupla(Id).

suppliers(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    fornecedor:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrou de errado */
suppliers(Método, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Método, Id))).


suppliers_insere_tupla( _{ for_cnpj:FOR_CNPJ,for_inscricao:FOR_INSCRICAO,for_nome_contato:FOR_NOME_CONTATO,
                 for_email_contato:FOR_EMAIL_CONTATO,for_situacao:FOR_SITUACAO,
                 for_telefone_contato:FOR_TELEFONE_CONTATO,for_status:FOR_STATUS,for_categoria:FOR_CATEGORIA,
                 pes_nome:PES_NOME,pes_telefone:PES_TELEFONE,pes_email:PES_EMAIL,pes_numero:PES_NUMERO,
                 cid_nome:CID_NOME,cid_uf:CID_UF,bai_nome:BAI_NOME,log_nome:LOG_NOME,log_numero:LOG_NUMERO}, Id):-
                    pk(fornecedor,Id),
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
                    fornecedor:insere(Id,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                                      FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA).

suppliers_atualiza_tupla( _{for_id:AtomId,pes_id:PES_ID,for_cnpj:FOR_CNPJ,for_inscricao:FOR_INSCRICAO,for_nome_contato:FOR_NOME_CONTATO,
                  for_email_contato:FOR_EMAIL_CONTATO,for_situacao:FOR_SITUACAO,for_telefone_contato:FOR_TELEFONE_CONTATO,
                  for_status:FOR_STATUS,for_categoria:FOR_CATEGORIA,cep_id:CEP_ID,pes_nome:PES_NOME,pes_telefone:PES_TELEFONE,
                  pes_email:PES_EMAIL,pes_numero:PES_NUMERO,cid_id:CID_ID,cid_nome:CID_NOME,cid_uf:CID_UF,bai_id:BAI_ID,
                  bai_nome:BAI_NOME, log_id:LOG_ID,log_nome:LOG_NOME,log_numero:LOG_NUMERO}, Id):-
                    atom_number(AtomId, Id),

                    fornecedor:atualiza(Id,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                             FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA),
                    pessoa:atualiza(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
                    cidade:atualiza(CID_ID,CID_NOME,CID_UF),
                    bairro:atualiza(BAI_ID, BAI_NOME),
                    logradouro:atualiza(LOG_ID,LOG_NOME,LOG_NUMERO),
                    cep:atualiza(CEP_ID, CID_ID, BAI_ID, LOG_ID).

%suppliers_envia_tupla(Id):-
%    (  fornecedor:fornecedor((FUN_ID,PES_ID,FUN_CARGO,FUN_CPF,FUN_NRO,FUN_LOGIN,FUN_SENHA,FUN_MATRICULA))
%    -> reply_json_dict( _{id:Id, pes_id:PES_ID, fun_cargo:FUN_CARGO, fun_cpf:FUN_CPF, fun_nro:FUN_NRO,
%                                          fun_login:FUN_LOGIN,fun_senha:FUN_SENHA,fun_matricula:FUN_MATRICULA } )
%    ;  throw(http_reply(not_found(Id)))
%    ).


suppliers_envia_tupla(Id):-
    (  fornecedor(Id,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,
                  FOR_SITUACAO,FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA),
        pessoa(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
        cidade(CID_ID,CID_NOME,CID_UF),
        bairro(BAI_ID, BAI_NOME),
        logradouro(LOG_ID,LOG_NOME,LOG_NUMERO),
        cep(CEP_ID, CID_ID, BAI_ID, LOG_ID)

    -> reply_json_dict( _{ for_id:Id,for_cnpj:FOR_CNPJ, for_inscricao:FOR_INSCRICAO,for_nome_contato:FOR_NOME_CONTATO,
                            for_email_contato:FOR_EMAIL_CONTATO, for_situacao:FOR_SITUACAO,for_telefone_contato:FOR_TELEFONE_CONTATO,
                            for_status:FOR_STATUS,for_categoria:FOR_CATEGORIA,
                            pes_nome:PES_NOME, pes_telefone:PES_TELEFONE,
                            pes_email:PES_EMAIL, pes_numero:PES_NUMERO, cid_nome:CID_NOME, cid_uf:CID_UF,
                            bai_nome:BAI_NOME, log_nome:LOG_NOME, log_numero:LOG_NUMERO } )
    ;  throw(http_reply(not_found(Id)))
    ).


suppliers_envia_tabela :-
    findall( _{ for_id:FOR_ID,pes_id:PES_ID,for_cnpj:FOR_CNPJ,for_inscricao:FOR_INSCRICAO,for_nome_contato:FOR_NOME_CONTATO,
                for_email_contato:FOR_EMAIL_CONTATO,for_situacao:FOR_SITUACAO,for_telefone_contato:FOR_TELEFONE_CONTATO,
                for_status:FOR_STATUS,for_categoria:FOR_CATEGORIA,cep_id:CEP_ID,pes_nome:PES_NOME,pes_telefone:PES_TELEFONE,
                pes_email:PES_EMAIL,pes_numero:PES_NUMERO,cid_id:CID_ID,cid_nome:CID_NOME,cid_uf:CID_UF,bai_id:BAI_ID,
                bai_nome:BAI_NOME, log_id:LOG_ID,log_nome:LOG_NOME,log_numero:LOG_NUMERO },
             (
                fornecedor(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                               FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA),
                    pessoa(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
                    cidade(CID_ID,CID_NOME,CID_UF),
                    bairro(BAI_ID, BAI_NOME),
                    logradouro(LOG_ID,LOG_NOME,LOG_NUMERO),
                    cep(CEP_ID, CID_ID, BAI_ID, LOG_ID)
              ),
             Tuplas ),
    reply_json_dict(Tuplas).
