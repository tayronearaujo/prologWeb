:- encoding(utf8).
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
                \html_requires(css('all.min.css')),
                \html_requires(js('rest.js')),
                \html_requires(js('bookmark.js')),
                h1('Cadastro de pessoas'),

                form([
                    id('products-form'),
                    onsubmit("redirecionaResposta(event, '/')"),
                    action('/api/v1/pessoa/'), method('POST') ],
                    
                    [

                        div([class('modal-body')],[
                            div([class('col-12 row m-auto p-0')],[
                                
                                div([class('form-group col-12')],[
                                    label([class('title-input')], 'Nome:'),
                                    input([
                                            name(pessoa_nome),
                                            type(text),
                                            class('form-control')
                                        ],[])
                                ]),
                                
                                div([class('form-group col-12')],[
                                    label([class('title-input')], 'Endereço:'),
                                    input([
                                            name(pessoa_endereco),
                                            type(text),
                                            class('form-control')
                                        ],[])
                                ]),
                        
                                div([class('form-group col-12')],[
                                    label([class('title-input')], 'Telefone:'),
                                    input([
                                            name(pessoa_telefone),
                                            type(number),
                                            class('form-control')
                                        ],[])
                                ]),
                        
                                div([class('form-group col-12')],[
                                    label([class('title-input')], 'Bairro:'),
                                    input([
                                            name(pessoa_bairro),
                                            type(text),
                                            class('form-control')
                                        ],[])
                                ]),
                        
                                div([class('form-group col-12')],[
                                    label([class('title-input')], 'CPF:'),
                                    input([
                                            name(pessoa_cpf),
                                            type(number),
                                            class('form-control')
                                        ],[])
                                ]),
                        
                                div([class('form-group col-12')],[
                                    label([class('title-input')], 'Identidade:'),
                                    input([
                                            name(pessoa_identidade),
                                            type(text),
                                            class('form-control')
                                        ],[])
                                ]),
                        
                                div([class('form-group col-12')],[
                                    label([class('title-input')], 'Complemento:'),
                                    input([
                                            name(pessoa_complemento),
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

                )]        
            ) 
        ]).
