:-module(api_produtos,[produtos/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(produtos), []).

/*
   GET api/v1/produtos/
   Retorna uma lista com todos os produtos.
*/
produtos(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/produtos/Id
   Retorna o `produtos` com Id 1 ou erro 404 caso o `produtos` não
   seja encontrado.
*/
produtos(get, AtomId, _Pedido):-
    atom_number(AtomId, IdProdutos),
    !,
    envia_tupla(IdProdutos).

/*
   POST api/v1/produtos
   Adiciona um novo produtos. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
produtos(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/produtos/IdProdutos
  Atualiza o produtos com o IdProdutos informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
produtos(put, AtomId, Pedido):-
    atom_number(AtomId, IdProdutos),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdProdutos).

/*
   DELETE api/v1/produtos/IdProdutos
   Apaga o produtos com o IdProdutos informado
*/
produtos(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdProdutos),
    !,
    tabFormaPag:remove(IdProdutos),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

produtos(Metodo, IdProdutos, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdProdutos))).

insere_tupla( _{ codigo:Codigo,nome:Nome,qtdeAtual:QtdeAtual,qtdeMinima:QtdeMinima,preco1:Preco1,descricao:Descricao,preco2:Preco2}):-
    % Validar URL antes de inserir
    produtos:insere(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2)
    -> envia_tupla(IdProdutos)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ codigo:Codigo,nome:Nome,qtdeAtual:QtdeAtual,qtdeMinima:QtdeMinima,preco1:Preco1,descricao:Descricao,preco2:Preco2}, IdProdutos):-
       produtos:atualiza(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2)
    -> envia_tupla(IdProdutos)
    ;  throw(http_reply(not_found(IdProdutos))).


envia_tupla(IdProdutos):-
       produtos:produtos(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2)
    -> reply_json_dict( _{idProdutos:IdProdutos,codigo:Codigo,nome:Nome,qtdeAtual:QtdeAtual,qtdeMinima:QtdeMinima,preco1:Preco1,descricao:Descricao,preco2:Preco2} )
    ;  throw(http_reply(not_found(IdProdutos))).


envia_tabela :-
    findall( _{idProdutos:IdProdutos,codigo:Codigo,nome:Nome,qtdeAtual:QtdeAtual,qtdeMinima:QtdeMinima,preco1:Preco1,descricao:Descricao,preco2:Preco2},
produtos:produtos(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2),
             Tuplas ),
    reply_json_dict(Tuplas).