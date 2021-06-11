:- encoding(utf8).
/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap)).

fluxoDeCaixa(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('Fluxo de Caixa')],
        [ div(class(container),
              [ 
                h1('Fluxo de Caixa'),
                    div([class('modal-body')],[
                        div([class('col-12 row m-auto p-0')],[
                            
                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Numero Transação'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ]),
                            
                            div([class('form-group col-6')],[
                                label([class('title-input')], 'Valor:'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ])


                            
                        ]),
                        div([class('modal-footer')],[
                          button([class('btn btn-primary'), type(submit)], 'Abrir caixa'),
                          button([class('btn btn-danger'), type(submit)], 'Fechar caixa'),
                          a([class(['btn' ,'btn-primary']), href('/')],'Voltar para home')
                      ])

                    ])
              ]
            ) 
        ]).