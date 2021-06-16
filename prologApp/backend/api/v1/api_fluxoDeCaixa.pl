:-module(api_fluxoDeCaixa,[fluxoDeCaixa/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(fluxoDeCaixa), []).

/*
   GET api/v1/pessoas/
   Retorna uma lista com todos os pessoas.
*/
fluxoDeCaixa(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/pessoas/Iduser
   Retorna o `pessoas` com Iduser 1 ou erro 404 caso o `pessoas` não
   seja encontrado.
*/
fluxoDeCaixa(get, AtomId, _Pedido):-
    atom_number(AtomId, Flu_id),
    !,
    envia_tupla(Flu_id).

/*
   POST api/v1/pessoas
   Adiciona um novo pessoas. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
fluxoDeCaixa(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/pessoas/Iduser
  Atualiza o pessoas com o Iduser informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
fluxoDeCaixa(put, AtomId, Pedido):-
    atom_number(AtomId, Flu_id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Flu_id).

/*
   DELETE api/v1/pessoas/Iduser
   Apaga o pessoas com o Iduser informado
*/
fluxoDeCaixa(delete, AtomId, _Pedido):-
    atom_number(AtomId, Flu_id),
    !,
    fluxoDeCaixa:remove(Flu_id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

fluxoDeCaixa(Metodo, Flu_id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Flu_id))).


insere_tupla( _{ numeroTransacao:NumeroTransacao,valor:Valor}):-
    % Validar URL antes de inserir
   fluxoDeCaixa:insere(Flu_id,NumeroTransacao,Valor)
    -> envia_tupla(Flu_id)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ numeroTransacao:NumeroTransacao,valor:Valor}, Flu_id):-
    fluxoDeCaixa:atualiza(Flu_id,NumeroTransacao,Valor)
    -> envia_tupla(Flu_id)
    ;  throw(http_reply(not_found(Flu_id))).


envia_tupla(Flu_id):-
       fluxoDeCaixa:fluxoDeCaixa(Flu_id,NumeroTransacao,Valor)
    -> reply_json_dict( _{flu_id:Flu_id,numeroTransacao:NumeroTransacao,valor:Valor} )
    ;  throw(http_reply(not_found(Flu_id))).


envia_tabela :-
    findall( _{flu_id:Flu_id,numeroTransacao:NumeroTransacao,valor:Valor},
        fluxoDeCaixa:fluxoDeCaixa(Flu_id,NumeroTransacao,Valor),
             Tuplas ),
    reply_json_dict(Tuplas).