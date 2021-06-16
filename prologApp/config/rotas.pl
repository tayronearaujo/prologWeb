% http_handler, http_reply_file
:- use_module(library(http/http_dispatch)).

% http:location
:- use_module(library(http/http_path)).

%:- ensure_loaded(caminhos).

/***********************************
 *                                 *
 *      Rotas do Servidor Web      *
 *                                 *
 ***********************************/

:- multifile http:location/3.
:- dynamic   http:location/3.

%% http:location(Apelido, Rota, Opções)
%      Apelido é como será chamada uma Rota do servidor.
%      Os apelidos css, icons e js já estão definidos na
%      biblioteca http/http_server_files, os demais precisam
%      ser definidos.

http:location(img, root(img), []).
http:location(api, root(api), []).
http:location(api1, api(v1), []).
http:location(webfonts, root(webfonts), []).

/**************************
 *                        *
 *      Tratadores        *
 *                        *
 **************************/

% Recursos estáticos
:- http_handler( css(.),
                 serve_files_in_directory(dir_css), [prefix]).
:- http_handler( img(.),
                 serve_files_in_directory(dir_img), [prefix]).
:- http_handler( js(.),
                 serve_files_in_directory(dir_js),  [prefix]).
:- http_handler( webfonts(.),
                 serve_files_in_directory(dir_webfonts), [prefix]).
:- http_handler( '/favicon.ico',
                 http_reply_file(dir_img('favicon.ico', [])),
                 []).

% Rotas do Frontend

%% A página inicial
:- http_handler( root(.), entrada,   []).

%% A página de cadastro de novos bookmarks
/* :- http_handler( root(bookmark), cadastro, []).
 */
%%pagina de cadastro
:- http_handler(root(pessoas), pessoas , []).
:- http_handler(root(produtos), produtos , []).
:- http_handler(root(fluxoDeCaixa), fluxoDeCaixa , []).
:- http_handler(root(funcionarios), funcionarios , []).
:- http_handler(root(transacao), transacao, []).
:- http_handler(root(vendas), vendas , []).
:- http_handler(root(sangria), sangria, []).
:- http_handler(root(cliente), cliente, []).
:- http_handler(root(item), item, []).


% Rotas do Backend

% Validasao de login
%:- http_handler( root(valida_login), logins:valida(Metodo),
                % [ method(Metodo) ]).








% Rotas API
:- http_handler( api1(usuarios/Id), usuarios:usuarios(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).


:- http_handler( api1(pessoas/Iduser), api_pessoas:pessoas(Metodo, Iduser),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(produtos/IdProdutos), api_produtos:produtos(Metodo, IdProdutos),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(fluxoDeCaixa/Flu_id), api_fluxoDeCaixa:fluxoDeCaixa(Metodo, Flu_id),
                [ method(Metodo),
                  methods([ get, post, put, delete ]) ]).

:- http_handler( api1(funcionarios/Fun_id), api_funcionarios:funcionarios(Metodo, Fun_id),
                [ method(Metodo),
                  methods([ get, post, put, delete ]) ]).

:- http_handler( api1(transacao/IdTranscao), api_transacao:transacao(Metodo, IdTranscao),
                [ method(Metodo),
                  methods([ get, post, put, delete ]) ]).

:- http_handler( api1(vendas/IdVendas), api_vendas:vendas(Metodo, IdVendas),
                [ method(Metodo),
                  methods([ get, post, put, delete ]) ]).

:- http_handler( api1(sangria/IdSangria), api_sangria:sangria(Metodo, IdSangria),
                [ method(Metodo),
                  methods([ get, post, put, delete ]) ]).

:- http_handler( api1(cliente/IdCliente), api_cliente:cliente(Metodo, IdCliente),
                [ method(Metodo),
                  methods([ get, post, put, delete ]) ]).

:- http_handler( api1(item/IdItem), api_item:item(Metodo, IdItem),
                [ method(Metodo),
                  methods([ get, post, put, delete ]) ]).
                


