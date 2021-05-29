:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).

% html_requires está aqui
:- use_module(library(http/html_head)).

% serve_files_in_directory está aqui
:- use_module(library(http/http_server_files)).

servidor(Porta) :-
    http_server(http_dispatch, [port(Porta)]).

% Localização dos diretórios no sistema de arquivos
:- multifile user:file_search_path/2.
user:file_search_path(dir_css, 'css').
user:file_search_path(dir_js,  'js').

% Liga as rotas aos respectivos diretórios
:- http_handler(css(.),
                serve_files_in_directory(dir_css), [prefix]).
:- http_handler(js(.),
                serve_files_in_directory(dir_js), [prefix]).

% Gabaritos
:- multifile 
    user:body//2.

:- http_handler(root(.), home , []).

:- http_handler(root(produtos), produtos , []).
:- http_handler(root(pessoas), pessoas , []).

:- ensure_loaded(base(bootstrap)).

home(_Pedido) :-
  reply_html_page(
      bootstrap,
      [ title('GCM')],
      [ div(class(container),
        [ h1('Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de Desenvolvendo'),
          nav(class(['nav','flex-row']),
              [ 
                a([class('nav-link'),
                href('./pessoas')],
                ['Pessoas']),

                a([class('nav-link'),
                href('./produtos')],
                ['Produtos'])
              ])
        ]) 
      ]).
