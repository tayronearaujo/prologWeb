/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(db(chave)).
:- use_module(db(funcionario)).
:- use_module(db(pessoa)).
:- use_module(db(cidade)).
:- use_module(db(bairro)).
:- use_module(db(logradouro)).
:- use_module(db(cep)).

employees(get, '', _Pedido):- !,
    envia_tabela.

employees(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

employees(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados, Id),
    envia_tupla(Id).

employees(put, _, Pedido):- !,
    http_read_json_dict(Pedido, Dados),
    atualiza_tupla(Dados, Id),
    envia_tupla(Id).

employees(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    funcionario:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrou de errado */
employees(Método, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Método, Id))).


insere_tupla( _{ fun_cargo:FUN_CARGO, fun_cpf:FUN_CPF, fun_NRO:FUN_NRO, fun_login:FUN_LOGIN,
fun_senha:FUN_SENHA, fun_matricula:FUN_MATRICULA, pes_nome:PES_NOME, pes_telefone:PES_TELEFONE,
pes_email:PES_EMAIL, pes_numero:PES_NUMERO, cid_nome:CID_NOME, cid_uf:CID_UF,
bai_nome:BAI_NOME, log_nome:LOG_NOME, log_numero:LOG_NUMERO}, Id):-
               pk(bairro,BAI_ID),
               pk(cidade,CID_ID),
               pk(logradouro,LOG_ID),
               pk(pessoa,PES_ID),
               pk(funcionario,Id),
               pk(cep,CEP_ID),
               cidade:insere(CID_ID,CID_NOME,CID_UF),
               bairro:insere(BAI_ID, BAI_NOME),
               logradouro:insere(LOG_ID,LOG_NOME,LOG_NUMERO),
               cep:insere(CEP_ID, CID_ID, BAI_ID, LOG_ID),
               pessoa:insere(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
               funcionario:insere(Id,PES_ID,FUN_CARGO,FUN_CPF,FUN_NRO,FUN_LOGIN,
                                  FUN_SENHA,FUN_MATRICULA).

atualiza_tupla( _{id:AtomId, pes_id:PES_ID, fun_cargo:FUN_CARGO, fun_cpf:FUN_CPF, fun_nro:FUN_NRO,
                  fun_login:FUN_LOGIN,fun_senha:FUN_SENHA,fun_matricula:FUN_MATRICULA }, Id):-
    atom_number(AtomId, Id),
    funcionario:atualiza(Id,PES_ID,FUN_CARGO,FUN_CPF,FUN_NRO,FUN_LOGIN,FUN_SENHA,FUN_MATRICULA).

%envia_tupla(Id):-
%    (  funcionario:funcionario((FUN_ID,PES_ID,FUN_CARGO,FUN_CPF,FUN_NRO,FUN_LOGIN,FUN_SENHA,FUN_MATRICULA))
%    -> reply_json_dict( _{id:Id, pes_id:PES_ID, fun_cargo:FUN_CARGO, fun_cpf:FUN_CPF, fun_nro:FUN_NRO,
%                                          fun_login:FUN_LOGIN,fun_senha:FUN_SENHA,fun_matricula:FUN_MATRICULA } )
%    ;  throw(http_reply(not_found(Id)))
%    ).


envia_tupla(Id):-
    (  funcionario(Id,PES_ID,FUN_CARGO,FUN_CPF,FUN_NRO,FUN_LOGIN,FUN_SENHA,FUN_MATRICULA),
        pessoa(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
        cidade(CID_ID,CID_NOME,CID_UF),
        bairro(BAI_ID, BAI_NOME),
        logradouro(LOG_ID,LOG_NOME,LOG_NUMERO),
        cep(CEP_ID, CID_ID, BAI_ID, LOG_ID)

    -> reply_json_dict( _{ fun_id:Id, fun_cargo:FUN_CARGO, fun_cpf:FUN_CPF, fun_NRO:FUN_NRO, fun_login:FUN_LOGIN,
                        fun_senha:FUN_SENHA, fun_matricula:FUN_MATRICULA, pes_nome:PES_NOME, pes_telefone:PES_TELEFONE,
                        pes_email:PES_EMAIL, pes_numero:PES_NUMERO, cid_nome:CID_NOME, cid_uf:CID_UF,
                        bai_nome:BAI_NOME, log_nome:LOG_NOME, log_numero:LOG_NUMERO } )
    ;  throw(http_reply(not_found(Id)))
    ).


envia_tabela :-
    findall( _{fun_id:Id, fun_cargo:FUN_CARGO, fun_cpf:FUN_CPF, fun_NRO:FUN_NRO, fun_login:FUN_LOGIN,
               fun_senha:FUN_SENHA, fun_matricula:FUN_MATRICULA, pes_nome:PES_NOME, pes_telefone:PES_TELEFONE,
               pes_email:PES_EMAIL, pes_numero:PES_NUMERO, cid_nome:CID_NOME, cid_uf:CID_UF,
               bai_nome:BAI_NOME, log_nome:LOG_NOME, log_numero:LOG_NUMERO},
             (
                pessoa(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
                cep(CEP_ID, CID_ID, BAI_ID, LOG_ID),
                cidade(CID_ID,CID_NOME,CID_UF),
                bairro(BAI_ID, BAI_NOME),
                logradouro(LOG_ID,LOG_NOME,LOG_NUMERO),
                funcionario(Id,PES_ID,FUN_CARGO,FUN_CPF,FUN_NRO,FUN_LOGIN,FUN_SENHA,FUN_MATRICULA)
              ),
             Tuplas ),
    reply_json_dict(Tuplas).
