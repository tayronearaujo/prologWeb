:- encoding(utf8).
/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).

/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap)).

transacao(_Pedidos):-
    reply_html_page(
        bootstrap,
        [ title('Registro de Transação')],
        [ div(class(container),
              [
                h1('Registro de Transação'),
                    div([class('modal-body')],[
                        div([class('col-12 row m-auto p-0')],[

                             div([class('form-group col-12')],[
                                label([class('title-input')], 'Numero:'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Hora:'), 
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ]),

                                 div([class('form-group col-12')],[
                                label([class('title-input')], 'Valor:'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ])
                        ])
                    ]),
                    div([class('modal-footer')],[
                        button([class('btn btn-primary'), type(submit)], 'Confirmar Transação'),
                        button([class('btn btn-primary'), type(submit)], 'Editar'),
                        button([class('btn btn-danger'), type(submit)], 'Excluir'),
                        a([class(['btn' ,'btn-primary']), href('/')],
                        'Voltar para home')
                    ])
              ]
            )
        ]).
