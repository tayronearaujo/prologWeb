/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(base(bootstrap)).

index(_) :-
    reply_html_page(
    bootstrap,
    [title('Login')],
     [
     \links,
     \html_requires(js('main.js')),
     \index_navbar,
     \index_body]).


metas -->
         html(meta([name(viewport), content('width=device-width, initial-scale=1.0, shrink-to-fit=no')], [])).


links -->
    html([
    link([rel(stylesheet), href('https://cdn.jsdelivr.net/npm/reset-css@5.0.1/reset.min.css')], []),
        link([rel(stylesheet), href('https://fonts.googleapis.com/css2?family=Mulish:wght@200;600;800&display=swap')], []),
        link([rel(stylesheet), href('https://fonts.googleapis.com/css2?family=Source+Sans+Pro&display=swap')], []),
        link([rel(stylesheet), href('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css')], []),
        \html_requires(css('styles.css'))
    ]).

index_navbar -->
    html(
        nav(
            [class('navbar fixed-top navbar-expand-lg navbar-dark bg-primary navbar-fixed-top')],
            [   a([class('navbar-brand'), href('./')], ['AeroSystem']),
                button([class('navbar-toggler'), type(button), 'data-toogle'(collapse), 'data-target'('#header'), 'aria-controls'(header),
                    'aria-expanded'(false), 'aria-label'('Toggle navigation')], [span([class('navbar-toggler-icon')], [])]),
                div([class('collapse navbar-collapse'), id(header)],
                    [div([class('navbar-nav')],[])]
               )]
            )
        ).


index_body -->
    html(
        div([class('container d-flex align-items-center')],[            
        form([autocomplete('off'),class('col-lg-5 col-md-8 m-auto container-card d-flex justify-content-center row')],[
            div([class('form-group col-10 mt-5')],[
                label([for(inputUsuario), class('title-input')], 'Usuário'),
                 input([name(inputUsuario),
                        type(text),
                        class('form-control'),
                        id(inputUsuario)]),
                small([id(usuarioHelp),
                    class('form-text text-muted')],'Digite sua senha, se ainda não for um usuário,procure o adm do sistema')
            ]),
            div([class('form-group col-10 mt-1')],[
                label([for(inputSenha), class('title-input')], 'Senha'),
                 input([name(inputSenha),
                        type(text),
                        class('form-control'),
                        id(inputSenha)])
            ]),
            div([class('col-10 mt-3 mb-5')],[
                     button([class('btn btn-primary w-100'), type(button), onclick('login()')], 'Entrar')
                                     ])

            ])
        ])
        ).