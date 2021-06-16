:-module(api_vendas,[vendas/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(vendas), []).

/*
   GET api/v1/vendas/
   Retorna uma lista com todas as vendas.
*/
vendas(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/vendas/Id
   Retorna as `vendas` com Id 1 ou erro 404 caso as `vendas` não
   sejam encontrado.
*/
vendas(get, AtomId, _Pedido):-
    atom_number(AtomId, IdVendas),
    !,
    envia_tupla(IdVendas).

/*
   POST api/v1/vendas
   Adiciona um novo produtos. Os dados deverão ser passados no corpo da
   requisição no formato JSON.
   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
vendas(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/produtos/IdVendas
  Atualiza o produtos com o IdVendas informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
vendas(put, AtomId, Pedido):-
    atom_number(AtomId, IdVendas),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdVendas).

/*
   DELETE api/v1/produtos/IdVendas
   Apaga as vendas com o IdVendas informado
*/
vendas(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdVendas),
    !,
    vendas:remove(IdVendas),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

vendas(Metodo, IdVendas, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdVendas))).

insere_tupla( _{numero_vendedor:Numero_Vendedor, numero:Numero, data:Data, hora:Hora, forma_pagamento:Forma_Pagamento}):-
    % Validar URL antes de inserir
    vendas:insere(IdVendas,Numero_Vendedor, Numero,Data, Hora, Forma_Pagamento)
    -> envia_tupla(IdVendas)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{numero_vendedor:Numero_Vendedor, numero:Numero, data:Data, hora:Hora, forma_pagamento:Forma_Pagamento }, IdVendas):-
       vendas:atualiza(IdVendas,Numero_Vendedor, Numero,Data, Hora, Forma_Pagamento)
    -> envia_tupla(IdVendas)
    ;  throw(http_reply(not_found(IdVendas))).


envia_tupla(IdVendas):-
       vendas:vendas(IdVendas,Numero_Vendedor, Numero,Data, Hora, Forma_Pagamento)
    -> reply_json_dict( _{idVendas:IdVendas,numero_vendedor:Numero_Vendedor, numero:Numero, data:Data, hora:Hora, forma_pagamento:Forma_Pagamento})
    ;  throw(http_reply(not_found(IdVendas))).


envia_tabela :-
    findall( _{idVendas:IdVendas,numero_vendedor:Numero_Vendedor, numero:Numero, data:Data, hora:Hora, forma_pagamento:Forma_Pagamento},
vendas:vendas(IdVendas,Numero_Vendedor, Numero,Data, Hora, Forma_Pagamento),
             Tuplas ),
    reply_json_dict(Tuplas).
