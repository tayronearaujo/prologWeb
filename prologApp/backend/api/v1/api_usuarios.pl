:- module(api_usuarios,[usuarios/3]).
   
  
/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(usuario), []).
:- use_module(bd(funcao), []).
:- use_module(bd(usuario_funcao), []).

/*
GET api/v1/usuarios/
Retorna uma lista com todos os usuarios.
*/
usuarios(get, '', _Pedido):- !,
 envia_tabela.

/*
GET api/v1/usuarios/Id
Retorna o usuario com Id 1 ou erro 404 caso o usuario nao
seja encontrado.
*/
usuarios(get, AtomId, _Pedido):-
 atom_number(AtomId, Id),
 !,
 envia_tupla(Id).

/*
POST api/v1/usuarios
Adiciona um novo usuario. Os dados deverao ser passados no corpo da
requisicao no formato JSON. Por default, o usuario possui a funcao
estudante

Um erro 400 (BAD REQUEST) deve ser retornado caso algo de errado
*/
usuarios(post, _, Pedido):-
 http_read_json_dict(Pedido, Dados),
 !,
 insere_tupla(Dados).

/*
PUT api/v1/usuarios/Id
Atualiza o usuÃ¡rio com o Id informado.
Os dados sao passados no corpo do pedido no formato JSON.
*/
usuarios(put, AtomId, Pedido):-
 atom_number(AtomId, Id),
 http_read_json_dict(Pedido, Dados),
 !,
 atualiza_tupla(Dados, Id).
/*
DELETE api/v1/usuarios/Id
Apaga o bookmark com o Id informado
*/
usuarios(delete, AtomId, _Pedido):-
 atom_number(AtomId, Usuario_ID),
 !,
 usuario:remove(Usuario_ID),
 throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo nao
permitido sera retornada.
*/

usuarios(Metodo, Id, _Pedido) :-
 throw(http_reply(method_not_allowed(Metodo, Id))).


insere_tupla( _{ nome:Nome, email:Email, senha:Senha, funcao:StrFun }):-
 ( usuario:insere(Usuario_ID, Nome, Email, Senha),
   atom_string(Funcao, StrFun),
   funcao:funcao(Funcao_ID, Funcao, _, _),
   usuario_funcao:insere(_, Usuario_ID, Funcao_ID)
 )
 -> envia_tupla(Usuario_ID)
 ;  throw(http_reply(bad_request('Email ja¡ cadastrado'))).

atualiza_tupla( _{ nome:Nome, email:Email, senha:Senha, funcao:StrFun}, Usuario_ID):-
 ( atom_string(Funcao, StrFun),
   funcao:funcao(Funcao_ID, Funcao, _, _),
   usuario_funcao:usuario_funcao(UF_ID, Usuario_ID, _, _, _),
   usuario:atualiza(Usuario_ID, Nome, Email),
   usuario:atualiza_senha(Usuario_ID, Senha),
   usuario_funcao:atualiza(UF_ID, Usuario_ID, Funcao_ID)
 )
 -> envia_tupla(Usuario_ID)
 ;  throw(http_reply(not_found(Usuario_ID))).

envia_tupla(Id):-
 usuario:usuario(Id, Nome, Email, _Senha, Data_Cad, Data_Mod)
 -> reply_json_dict( _{ id:Id, nome:Nome, email:Email,
                        data_cad: Data_Cad, data_mod: Data_Mod} )
 ;  throw(http_reply(not_found(Id))).


envia_tabela :-
 findall( _{ id:Id, nome:Nome, email:Email,
             data_cad: Data_Cad, data_mod: Data_Mod },
          usuario:usuario(Id, Nome, Email, _Senha, Data_Cad, Data_Mod),
         Tuplas ),
 reply_json_dict(Tuplas).
