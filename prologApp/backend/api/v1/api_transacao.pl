:-module(api_transacao,[transacao/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(transacao), []).

/*
   GET api/v1/transacao/
   Retorna uma lista com todos os produtos.
*/
transacao(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/transacao/Id
   Retorna o `transacao` com Id 1 ou erro 404 caso o `transacao` não
   seja encontrado.
*/
transacao(get, AtomId, _Pedido):-
    atom_number(AtomId, IdTransacao),
    !,
    envia_tupla(IdTransacao).

/*
   POST api/v1/transacao
   Adiciona uma nova transacao. Os dados deverão ser passados no corpo
   da requisição no formato JSON. Um erro 400 (BAD REQUEST) deve ser
   retornado caso a URL não tenha sido informada.
*/
transacao(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/produtos/IdProdutos
  Atualiza o produtos com o IdProdutos informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
transacao(put, AtomId, Pedido):-
    atom_number(AtomId, IdTransacao),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdTransacao).

/*
   DELETE api/v1/transacao/IdTransacao
   Apaga o produtos com o IdTransacao informado
*/
transacao(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdTransacao),
    !,
    transacao:remove(IdTransacao),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

transacao(Metodo, IdTransacao, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdTransacao))).

insere_tupla(_{numero:Numero, hora:Hora, valor:Valor}):-
    % Validar URL antes de inserir
    transacao:insere(IdTransacao ,Numero, Hora, Valor)
    -> envia_tupla(IdTransacao)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{numero:Numero, hora:Hora, valor:Valor}, IdTransacao):-
       transacao:atualiza(IdTransacao,Numero, Hora, Valor)
    -> envia_tupla(IdTransacao)
    ;  throw(http_reply(not_found(IdTransacao))).


envia_tupla(IdTransacao):-
       transacao:transacao(IdTransacao, Numero, Hora, Valor)
    -> reply_json_dict( _{idTransacao:IdTransacao,numero:Numero, hora:Hora, valor:Valor} )
    ;  throw(http_reply(not_found(IdTransacao))).


envia_tabela :-
    findall( _{idTransacao:IdTransacao,numero:Numero, hora:Hora, valor:Valor},
transacao:transacao(IdTransacao, Numero, Hora, Valor),
             Tuplas ),
    reply_json_dict(Tuplas).
