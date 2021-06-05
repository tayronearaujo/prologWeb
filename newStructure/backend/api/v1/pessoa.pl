/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(pessoas), []).

/*
   GET api/v1/bookmarks/
   Retorna uma lista com todos os bookmarks.
*/
pessoa(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/bookmarks/Id
   Retorna o `bookmark` com Id 1 ou erro 404 caso o `bookmark` não
   seja encontrado.
*/
pessoa(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

/*
   POST api/v1/bookmarks
   Adiciona um novo bookmark. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
pessoa(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/bookmarks/Id
  Atualiza o bookmark com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/

/*
pessoa(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).


   DELETE api/v1/bookmarks/Id
   Apaga o bookmark com o Id informado

pessoa(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    bookmark:remove(Id),
    throw(http_reply(no_content)).
*/

/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.

 */

pessoa(Método, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Método, Id))).


insere_tupla( _{pessoa_id: PES_ID, pessoa_nome: PES_NOME, pessoa_endereco: PES_ENDERECO, pessoa_telefone: PES_TELEFONE, pessoa_bairro: PES_BAIRRO, pessoa_cpf: PES_CPF,  pessoa_identidade: PES_IDENTIDADE, pessoa_complemento: PES_COMPLEMENTO}):-
    pessoa:pessoas(PES_ID,PES_NOME,PES_ENDERECO,PES_TELEFONE,PES_BAIRRO,PES_CPF,PES_IDENTIDADE,PES_COMPLEMENTO)
    -> envia_tupla(Id)
    ;  throw(http_reply(bad_request('URL ausente'))).

/*atualiza_tupla( _{ título:Título, url:URL}, Id):-
       bookmark:atualiza(Id, Título, URL)
    -> envia_tupla(Id)
    ;  throw(http_reply(not_found(Id))).*/


envia_tupla(Id):-
    pessoa:pessoas(PES_ID,PES_NOME,PES_ENDERECO,PES_TELEFONE,PES_BAIRRO,PES_CPF,PES_IDENTIDADE,PES_COMPLEMENTO)
    -> reply_json_dict( _{pessoa_id: PES_ID, pessoa_nome: PES_NOME, pessoa_endereco: PES_ENDERECO, pessoa_telefone: PES_TELEFONE, pessoa_bairro: PES_BAIRRO, pessoa_cpf: PES_CPF,  pessoa_identidade: PES_IDENTIDADE, pessoa_complemento: PES_COMPLEMENTO} )
    ;  throw(http_reply(not_found(Id))).



envia_tabela :-
    findall( _{pessoa_id: PES_ID, pessoa_nome: PES_NOME, pessoa_endereco: PES_ENDERECO, pessoa_telefone: PES_TELEFONE, pessoa_bairro: PES_BAIRRO, pessoa_cpf: PES_CPF,  pessoa_identidade: PES_IDENTIDADE, pessoa_complemento: PES_COMPLEMENTO},
             pessoa:pessoas(PES_ID,PES_NOME,PES_ENDERECO,PES_TELEFONE,PES_BAIRRO,PES_CPF,PES_IDENTIDADE,PES_COMPLEMENTO),
             Tuplas ),
    reply_json_dict(Tuplas).
