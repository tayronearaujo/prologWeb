:-module(api_funcionarios,[funcionarios/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(funcionarios), []).

/*
   GET api/v1/pessoas/
   Retorna uma lista com todos os funcionarios.
*/
funcionarios(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/pessoas/Iduser
   Retorna o `pessoas` com Iduser 1 ou erro 404 caso o `pessoas` não
   seja encontrado.
*/
funcionarios(get, AtomId, _Pedido):-
    atom_number(AtomId, Fun_id),
    !,
    envia_tupla(Fun_id).

/*
   POST api/v1/pessoas
   Adiciona um novo pessoas. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
funcionarios(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/pessoas/Iduser
  Atualiza o pessoas com o Iduser informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
funcionarios(put, AtomId, Pedido):-
    atom_number(AtomId, Fun_id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Fun_id).

/*
   DELETE api/v1/pessoas/Iduser
   Apaga o pessoas com o Iduser informado
*/
funcionarios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Fun_id),
    !,
    funcionarios:remove(Fun_id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

funcionarios(Metodo, Fun_id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Fun_id))).


insere_tupla( _{ numfunc:Numfunc,adimissao:Adimissao,carteiraTrabalho:CarteiraTrabalho,ferias:Ferias,horario:Horario}):-
    % Validar URL antes de inserir
    funcionarios:insere(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario)
    -> envia_tupla(Fun_id)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ numfunc:Numfunc,adimissao:Adimissao,carteiraTrabalho:CarteiraTrabalho,ferias:Ferias,horario:Horario}, Fun_id):-
    funcionarios:atualiza(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario)
    -> envia_tupla(Fun_id)
    ;  throw(http_reply(not_found(Fun_id))).


envia_tupla(Fun_id):-
       funcionarios:funcionarios(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario)
    -> reply_json_dict( _{fun_id:Fun_id,numfunc:Numfunc,adimissao:Adimissao,carteiraTrabalho:CarteiraTrabalho,ferias:Ferias,horario:Horario} )
    ;  throw(http_reply(not_found(Fun_id))).


envia_tabela :-
    findall( _{fun_id:Fun_id,numfunc:Numfunc,adimissao:Adimissao,carteiraTrabalho:CarteiraTrabalho,ferias:Ferias,horario:Horario},
           funcionarios:funcionarios(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario),
             Tuplas ),
    reply_json_dict(Tuplas).