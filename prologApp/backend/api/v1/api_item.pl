:-module(api_item,[item/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(item), []).

/*
   GET api/v1/item/
   Retorna uma lista com todos os itens.
*/
item(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/item/IdItem
   Retorna o `item` com Id 1 ou erro 404 caso o `item` não
   seja encontrado.
*/
item(get, AtomId, _Pedido):-
    atom_number(AtomId, IdItem),
    !,
    envia_tupla(IdItem).

/*
   POST api/v1/item
   Adiciona um novo item. Os dados deverão ser passados no corpo
   da requisição no formato JSON. Um erro 400 (BAD REQUEST) deve ser
   retornado caso a URL não tenha sido informada.
*/
item(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/item/IdItem
  Atualiza o produtos com o IdItem informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
item(put, AtomId, Pedido):-
    atom_number(AtomId, IdItem),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdItem).

/*
   DELETE api/v1/item/IdItem
   Apaga o produtos com o IdItem informado
*/
item(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdItem),
    !,
    item:remove(IdItem),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

item(Metodo, IdItem, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdItem))).

insere_tupla(_{codigo:Codigo, quantidade:Quantidade, valor:Valor}):-
    % Validar URL antes de inserir
    item:insere(IdItem ,Codigo, Quantidade, Valor)
    -> envia_tupla(IdItem)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{codigo:Codigo, quantidade:Quantidade, valor:Valor}, IdItem):-
       item:atualiza(IdItem,Codigo, Quantidade, Valor)
    -> envia_tupla(IdItem)
    ;  throw(http_reply(not_found(IdItem))).


envia_tupla(IdItem):-
       item:item(IdItem,Codigo, Quantidade, Valor)
    -> reply_json_dict( _{idItem:IdItem,codigo:Codigo, quantidade:Quantidade, valor:Valor} )
    ;  throw(http_reply(not_found(IdItem))).


envia_tabela :-
    findall( _{idItem:IdItem,codigo:Codigo, quantidade:Quantidade, valor:Valor},
item:item(IdItem,Codigo, Quantidade, Valor),
             Tuplas ),
    reply_json_dict(Tuplas).
