/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(pessoa), []).

/*
   GET api/v1/pessoas/
   Retorna uma lista com todos os pessoas.
*/
pessoas(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/pessoas/Id
   Retorna o `pessoa` com Id 1 ou erro 404 caso o `pessoa` não
   seja encontrado.
*/
pessoas(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

/*
   POST api/v1/pessoas
   Adiciona um novo pessoa. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
pessoas(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/pessoas/Id
  Atualiza o pessoa com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
pessoas(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).

/*
   DELETE api/v1/pessoas/Id
   Apaga o pessoa com o Id informado
*/
pessoas(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    pessoa:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de Metodo não
   permitido será retornada.
 */

pessoas(Metodo, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id))).


insere_tupla( _{ nome: Nome, sobrenome: Sobrenome}):-
    % Validar URL antes de inserir
    pessoa:insere(Id, Nome, Sobrenome)
        -> envia_tupla(Id)
        ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ nome: Nome, sobrenome: Sobrenome}, Id):-
    pessoa:pessoa(Id, Nome, Sobrenome)
        -> envia_tupla(Id)
        ;  throw(http_reply(not_found(Id))).

envia_tupla(Id):-
    pessoa:pessoa(Id, Nome, Sobrenome)
        -> reply_json_dict( _{id:Id, nome: Nome, sobrenome: Sobrenome} )
        ;  throw(http_reply(not_found(Id))).


envia_tabela :-
    findall( _{id:Id, nome: Nome, sobrenome: Sobrenome},
        pessoa:pessoa(Id, Nome, Sobrenome),
             Tuplas ),
    reply_json_dict(Tuplas).
