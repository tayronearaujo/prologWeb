:-module(api_cliente,[cliente/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(cliente), []).

/*
   GET api/v1/cliente/
   Retorna uma lista com todos os cadastros de clientes.
*/
cliente(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/cliente/IdCliente
   Retorna o `cliente` com Id 1 ou erro 404 caso o `cliente` não
   sejam encontrado.
*/
cliente(get, AtomId, _Pedido):-
    atom_number(AtomId, IdCliente),
    !,
    envia_tupla(IdCliente).

/*
   POST api/v1/cliente
   Adiciona um novo produtos. Os dados deverão ser passados no corpo da
   requisição no formato JSON.
   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
cliente(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/cliente/IdCliente
  Atualiza o produtos com o IdCliente informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
cliente(put, AtomId, Pedido):-
    atom_number(AtomId, IdCliente),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdCliente).

/*
   DELETE api/v1/Cliente/IdCliente
   Apaga as vendas com o IdCliente informado
*/
cliente(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdCliente),
    !,
    cliente:remove(IdCliente),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

cliente(Metodo, IdCliente, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdCliente))).

insere_tupla( _{compras:Compras,num_cliente:Num_cliente, num_vendedor:Num_vendedor, credito:Credito, valor_credito:Valor_credito}):-
    % Validar URL antes de inserir
    cliente:insere(IdCliente,Compras,Num_cliente,Num_vendedor, Credito, Valor_credito)
    -> envia_tupla(IdCliente)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{compras:Compras,num_cliente:Num_cliente, num_vendedor:Num_vendedor, credito:Credito, valor_credito:Valor_credito }, IdCliente):-
       cliente:atualiza(IdCliente, Compras,Num_cliente,Num_vendedor, Credito, Valor_credito)
    -> envia_tupla(IdCliente)
    ;  throw(http_reply(not_found(IdCliente))).


envia_tupla(IdCliente):-
       cliente:cliente(IdCliente, Compras,Num_cliente,Num_vendedor, Credito, Valor_credito)
    -> reply_json_dict( _{idCliente:IdCliente, compras:Compras,num_cliente:Num_cliente, num_vendedor:Num_vendedor, credito:Credito, valor_credito:Valor_credito})
    ;  throw(http_reply(not_found(IdCliente))).


envia_tabela :-
    findall( _{idCliente:IdCliente, compras:Compras,num_cliente:Num_cliente, num_vendedor:Num_vendedor, credito:Credito, valor_credito:Valor_credito},
cliente:cliente(IdCliente, Compras,Num_cliente,Num_vendedor, Credito, Valor_credito),
             Tuplas ),
    reply_json_dict(Tuplas).
