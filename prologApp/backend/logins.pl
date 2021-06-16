:- module(
    logins,
    [
        valida/2
    ]
).
/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(usuario), []).
:- use_module(bd(funcao), []).
:- use_module(bd(usuario_funcao), []).


% http_read_data estÃ¡ aqui
% :- use_module(library(http/http_client)).

% valida(post, Pedido):-
%     http_read_data(Pedido, Dados, []), !,
%    format('Content-type: text/htmln~n', []),
%	format('<p>', [])
%     portray_clause(Dados), % escreve os dados do corpo
%	format('</p><p>========~n', []),
%	portray_clause(Pedido), % escreve o pedido todo
%	format('</p>').


valida(post, Pedido):-
 catch(
     http_parameters(Pedido,
                     [
                         email(Email,   [ string ]),
                         senha(Senha,   [ length >= 2 ]),
                         funcao(Funcao, [ oneof([ admin, prof, estudante]) ])
                     ]),
     _E,
     fail ),
 !,
 (  credencial_valida(Email, Senha, Funcao, Usuario_ID, _Nome)
 -> % Redireciona para a pagina de entrada do usuario
    http_redirect(see_other, root(Funcao/Usuario_ID), Pedido)
 ;  http_link_to_id(login, [ motivo('Falha no login') ], Link),
    http_redirect(see_other, Link, Pedido)
 ).


/* Essa pagina sera exibida em caso de erro de validacao
de algum parametro */
valida(_, _Pedido):-
 reply_html_page(bootstrap5,
                 [ title('Erro no login') ],
                 [ h1('Erro'),
                   p('Algum parametro nao e valido')
                 ]).



/*******************************
*       DADOS DO USUARIO      *
*******************************/


% ! credencial_valida(+Email, +Senha, +Funcao, -UsuarioId, -Nome)
% semidet.
%
%   Verdadeiro se Senha e a senha correta para usuario com o dado Email
%   e com a funcao Funcao.

credencial_valida(Email, Senha, Funcao, Usuario_ID, Nome):-
 usuario:senha_valida( Email, Senha, Usuario_ID, Nome ),
 possui_funcao( Usuario_ID, Funcao ).

possui_funcao(Usuario_ID, Funcao):-
 usuario_funcao:usuario_funcao(_, Usuario_ID, Funcao_ID, _, _),
 funcao:funcao(Funcao_ID, Funcao, _, _).





