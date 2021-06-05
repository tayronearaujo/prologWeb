/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap)).

pessoas(_Pedidos):-
    reply_html_page(
        bootstrap,
        [ title('Cadastro de pessoas')],
        [ div(class(container),
              [ 
                h1('Cadastro de pessoas'),
                    div([class('modal-body')],[
                        div([class('col-12 row m-auto p-0')],[
                            
                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Nome:'),
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ]),
                            
                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Endereço:'),
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Telefone:'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Bairro:'),
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Cpf:'),
                                input([
                                        type(number),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Identidade:'),
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ]),

                            div([class('form-group col-12')],[
                                label([class('title-input')], 'Complemento:'),
                                input([
                                        type(text),
                                        class('form-control')
                                    ],[])
                            ])
                            
                        ])
                    ]),
                    div([class('modal-footer')],[
                        button([class('btn btn-success'), type(submit)], 'Cadastrar pessoa'),
                        button([class('btn btn-danger')], 'Cancelar'),
                        a([class(['btn' ,'btn-primary']), href('/')],
                     'Voltar para home')
                    ])
              ]
            ) 
        ]).
