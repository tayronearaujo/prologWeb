:-module(api_pessoas,[pessoas/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(pessoas), []).

/*
   GET api/v1/pessoas/
   Retorna uma lista com todos os pessoas.
*/
pessoas(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/pessoas/Iduser
   Retorna o `pessoas` com Iduser 1 ou erro 404 caso o `pessoas` não
   seja encontrado.
*/
pessoas(get, AtomId, _Pedido):-
    atom_number(AtomId, Iduser),
    !,
    envia_tupla(Iduser).

/*
   POST api/v1/pessoas
   Adiciona um novo pessoas. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
pessoas(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/pessoas/Iduser
  Atualiza o pessoas com o Iduser informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
pessoas(put, AtomId, Pedido):-
    atom_number(AtomId, Iduser),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Iduser).

/*
   DELETE api/v1/pessoas/Iduser
   Apaga o pessoas com o Iduser informado
*/
pessoas(delete, AtomId, _Pedido):-
    atom_number(AtomId, Iduser),
    !,
    pessoas:remove(Iduser),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

pessoas(Metodo, Iduser, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Iduser))).


insere_tupla( _{ nome:Nome,endereco:Endereco,telefone:Telefone,bairro:Bairro,cpf:Cpf,identidade:Identidade,complemento:Complemento}):-
    % Validar URL antes de inserir
    pessoas:insere(Iduser,Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento)
    -> envia_tupla(Iduser)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ nome:Nome,endereco:Endereco,telefone:Telefone,bairro:Bairro,cpf:Cpf,identidade:Identidade,complemento:Complemento}, Iduser):-
    pessoas:atualiza(Iduser,Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento)
    -> envia_tupla(Iduser)
    ;  throw(http_reply(not_found(Iduser))).


envia_tupla(Iduser):-
       pessoas:pessoas(Iduser,Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento)
    -> reply_json_dict( _{iduser:Iduser,nome:Nome,endereco:Endereco,telefone:Telefone,bairro:Bairro,cpf:Cpf,identidade:Identidade,complemento:Complemento} )
    ;  throw(http_reply(not_found(Iduser))).


envia_tabela :-
    findall( _{iduser:Iduser,nome:Nome,endereco:Endereco,telefone:Telefone,bairro:Bairro,cpf:Cpf,identidade:Identidade,complemento:Complemento},
             pessoas:pessoas(Iduser,Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento),
             Tuplas ),
    reply_json_dict(Tuplas).