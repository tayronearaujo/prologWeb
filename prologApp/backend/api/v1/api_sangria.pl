:-module(api_sangria,[sangria/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(sangria), []).

/*
   GET api/v1/sangria/
   Retorna uma lista com todas as sangrias.
*/
sangria(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/sangria/Id
   Retorna a `sangria` com Id 1 ou erro 404 caso a `sangria` não
   seja encontrado.
*/
sangria(get, AtomId, _Pedido):-
    atom_number(AtomId, IdSangria),
    !,
    envia_tupla(IdSangria).

/*
   POST api/v1/sangria
   Adiciona uma nova sangria. Os dados deverão ser
   passados no corpo da requisição no formato JSON. Um erro 400 (BAD
   REQUEST) deve ser retornado caso a URL não tenha sido informada.
*/
sangria(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/sangria/IdSangria
  Atualiza o produtos com o IdSangria informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
sangria(put, AtomId, Pedido):-
    atom_number(AtomId, IdSangria),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdSangria).

/*
   DELETE api/v1/sangria/IdSangria
   Apaga as sangrias com o IdSangria
   informado
*/
sangria(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdSangria),
    !,
    sangria:remove(IdSangria),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

sangria(Metodo, IdSangria, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdSangria))).

insere_tupla(_{numero:Numero, valor:Valor, hora:Hora}):-
    % Validar URL antes de inserir
    sangria:insere(IdSangria ,Numero, Valor, Hora)
    -> envia_tupla(IdSangria)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{numero:Numero, valor:Valor, hora:Hora}, IdSangria):-
       sangria:atualiza(IdSangria,Numero, Valor, Hora)
    -> envia_tupla(IdSangria)
    ;  throw(http_reply(not_found(IdSangria))).


envia_tupla(IdSangria):-
       sangria:sangria(IdSangria, Numero, Valor, Hora)
    -> reply_json_dict( _{idSangria:IdSangria,numero:Numero, valor:Valor, hora:Hora} )
    ;  throw(http_reply(not_found(IdSangria))).


envia_tabela :-
    findall( _{idSangria:IdSangria,numero:Numero, valor:Valor, hora:Hora},
sangria:sangria(IdSangria, Numero, Valor, Hora),
             Tuplas ),
    reply_json_dict(Tuplas).