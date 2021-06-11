:- encoding(utf8).
/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap)).

cadastra_pessoas(_Pedidos):-
    reply_html_page(
        bootstrap,
        [ title('Cadastro de pessoas')],
        [ div(class(container),
              [ 
                \html_requires(css('all.min.css')),
                \html_requires(js('rest.js')),
                \html_requires(js('bookmark.js')),
                h1('Cadastro de pessoas'),
                \form_pessoas    
            ])
        ]).

form_pessoas -->
    html(form([ id('pessoas-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/pessoas/') ],
                [ \metodo_de_envio('POST'),
                \campo(nome, 'Nome', text),
                \campo(sobrenome, 'Sobrenome', text),
                \enviar_ou_cancelar('/')
                ])).

enviar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
                [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar'),
                a([ href(RotaDeRetorno),
                    class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).

campo(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
                [ label([ for(Nome), class('form-label') ], Rotulo),
                input([ type(Tipo), class('form-control'),
                        id(Nome), name(Nome)])
                ] )).

metodo_de_envio(Metodo) -->
        html(input([type(hidden), name('_metodo'), value(Metodo)])).