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

:- http_handler(root(funcionarios), funcionarios , []).

% Tratadores

funcionarios(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('Cadastro de funcionarios')],
        [ div(class(container),
              [ 
                h1('Cadastro de funcionarios'),
                    div([class('modal-body')],[
                        div([class('col-12 row m-auto p-0')],[
                            
                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Numero funcionario::'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ]),
                            
                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Data adimissao:'),
                                input([
                                        type(date(Date)
                                        ),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Numero carteira de trabalho::'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Data Ferias:'),
                                input([
                                        type(date(Date)
                                        ),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Horario:'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ])

                           
                            
                        ])
                    ]),
                    \footer
              ]
            ) 
        ]).

footer -->
    html(
    div([class('modal-footer')],[
            button([class('btn btn-primary'), type(submit)], 'Cadastrar funcionario'),
            button([class('btn btn-primary')], 'Editar'),
            button([class('btn btn-primary'), href('/')], 'Excluir funcionario')
        ])
    ).