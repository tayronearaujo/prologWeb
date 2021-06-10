% http_handler, http_reply_file
:- use_module(library(http/http_dispatch)).

% http:location
:- use_module(library(http/http_path)).

/*********************
 *                   *
 *      Rotas        *
 *                   *
 *********************/

:- multifile http:location/3.
:- dynamic   http:location/3.

%% http:location(Apelido, Rota, Opções)
%      Apelido é como será chamada uma Rota do servidor.
%      Os apelidos css, icons e js já estão definidos na
%      biblioteca http/http_server_files, os demais precisam
%      ser definidos.

% http:location(api, root(api), []).
% http:location(api1, api(v1), []).

/**************************
 *                        *
 *      Tratadores        *
 *                        *
 **************************/

%% Recursos estáticos
:- http_handler(css(.),
                serve_files_in_directory(dir_css), [prefix]).
            
:- http_handler(js(.),
                serve_files_in_directory(dir_js),  [prefix]).

%% Frontend
:- http_handler(root(.), home, []).

%Tayrone
:- http_handler(root(pessoas), pessoas, []).
:- http_handler(root(produtos), produtos, []).

%Gabi
:- http_handler(root(funcionarios), funcionarios, []).
:- http_handler(root(fluxoDeCaixa), fluxoDeCaixa, []).

%heitor
:- http_handler(root(vendas), vendas, []).
:- http_handler(root(transacao), transacao, []).

%amora
:- http_handler(root(clientes), clientes, []).
:- http_handler(root(itemVenda), itemVenda, []).

%% Backend
% :- http_handler( api1(produtos/Id),
%                 produtos(Método,Id) ,
%                  [ method(Método),
%                    methods([ get, post, put, delete ]) ]).

% %% Backend
% :- http_handler( api1(pessoa/Id),
%                 produtos(Método,Id) ,
%                  [ method(Método),
%                    methods([ get, post, put, delete ]) ]).