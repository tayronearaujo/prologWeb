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



% Liga a rota ao tratador
:- http_handler(root(.), home , []).

:- http_handler(root(exemplo1), exemplo1 , []).
:- http_handler(root(exemplo2), exemplo2 , []).
:- http_handler(root(exemplo3), exemplo3 , []).


% Tratadores

pessoas(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('Cadastro de pessoas')],
        [ div(class(container),
              [ 
                h1('Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de Desenvolvendo'),
                    div([class('modal-body')],[
                        div([class('col-12 row m-auto p-0')],[
                            
                            div([class('form-group col-6')],[
                                label([class('title-input')], 'Nome'),
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ]),
                            
                            div([class('form-group col-6')],[
                                label([class('title-input')], 'Nome'),
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-6')],[
                                label([class('title-input')], 'Nome'),
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ])
                            
                        ])
                    ])
              ]
            ) 
        ]).

