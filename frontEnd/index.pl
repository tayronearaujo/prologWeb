/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
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

user:body(bootstrap, Corpo) -->
  html(body([ \html_post(head,
                         [ meta([name(viewport),
                                 content('width=device-width, initial-scale=1')])]),
              \html_root_attribute(lang,'pt-br'),
              \html_requires(css('bootstrap.min.css')),

              Corpo,

              script([ src('js/bootstrap.bundle.min.js'),
                       type('text/javascript')], [])
            ])).

% Rotas
:- multifile http:location/3.
:- dynamic   http:location/3.

:- http_handler(root(.), home , []).

:- http_handler(root(pessoas), pessoas, []).

:- http_handler(root(produtos), produtos, []).


home(_Pedido) :-
  reply_html_page(
      bootstrap,
      [ title('GCM')],
      [ div(class(container),
        [ h1('Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de Desenvolvendo'),
          nav(class(['nav','flex-row']),
              [ 
                \linkPessoas(),
                \linkProdutos() 
              ])
        ]) 
      ]).


linkPessoas() -->
  html(
    a([class('nav-link'),
    href('./pessoas')],
    'Cadastro de pessoas')
  ).

linkProdutos() -->
  html(
    a([class('nav-link'),
    href('/produtos')],
    'Cadastro de produtos')
  ).