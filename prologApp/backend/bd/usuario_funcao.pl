:- module(
    usuario_funcao,
    [ carrega_tab/1,
      usuario_funcao/5,
      insere/3,
      remove/1,
      atualiza/3]
).

:- use_module(library(persistency)).

:- use_module(chave, []).

:- use_module(usuario, []).
:- use_module(funcao, []).


:- persistent
usuario_funcao(
    usuario_funcao_id:positive_integer,
    usuario_id:positive_integer,
    funcao_id:positive_integer,
    data_cad:constant,
    data_mod:constant
).


:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
 db_attach(ArqTabela, []).



verifica_insercao(Usuario_id, Funcao_id):-
 usuario:usuario(Usuario_id, _, _, _, _, _), % usuario existe
 funcao:funcao(Funcao_id, _, _, _),          % funcao existe
 !.


insere(Id, Usuario_id, Funcao_id):-
 chave:pk(usuario_funcao, Id),
 with_mutex(usuario_funcao,
            ( verifica_insercao(Usuario_id, Funcao_id),
              get_time(T),
              Data_Cad = T,
              Data_Mod = T,
              assert_usuario_funcao(Id,
                                    Usuario_id,
                                    Funcao_id,
                                    Data_Cad,
                                    Data_Mod
                                   ))),
 !.

insere(-1, Usuario_id, Funcao_id):-
 format('Usuario ~d ou funcao ~d inexistente.', [Usuario_id, Funcao_id]).


remove(Id):-
 with_mutex(usuario_funcao,
            retractall_usuario_funcao(Id,
                                      _Usuario_id,
                                      _Funcao_id,
                                      _Data_Cad,
                                      _Data_Mod)).


atualiza(Id, Usuario_id, Funcao_id):-
 with_mutex(usuario_funcao,
            (retract_usuario_funcao(Id,
                                    _Usuario_id,
                                    _Funcao_id,

                                    Data_Cad,
                                    _Data_Mod),
             get_time(T),
             Data_Mod = T,
             assert_usuario_funcao(Id,
                                   Usuario_id,
                                   Funcao_id,
                                   Data_Cad,
                                   Data_Mod))).
