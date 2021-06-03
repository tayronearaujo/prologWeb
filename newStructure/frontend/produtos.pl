/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap)).

produtos(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('Cadastro de produtos')],
        [ div(class(container),
              [ 
                h1('Cadastro de Produtos'),

                    form([
                        id('products-form'),
                        onsubmit("redirecionaResposta(event, '/')"),
                        action('/api/v1/produtos/'), method('POST') ],
                        
                        [

                                div([class('modal-body')],[
                                    div([class('col-12 row m-auto p-0')],[

                                        div([class('form-group col-12')],[
                                            label([class('title-input')], 'Nome'),
                                            input([
                                                    name(prod_nome),
                                                    type(text),
                                                    class('form-control')
                                                ],[])
                                        ]),
                                        
                                        div([class('form-group col-6')],[
                                            label([class('title-input')], 'Quantidade atual:'),
                                            input([
                                                    name(prod_qtdeAtual),
                                                    type(number),
                                                    class('form-control')
                                                ],[])
                                        ]),

                                        div([class('form-group col-6')],[
                                            label([class('title-input')], 'Quantidade mínima:'),
                                            input([
                                                    name(prod_qtdeMinima),
                                                    type(number),
                                                    class('form-control')
                                                ],[])
                                        ]),

                                        div([class('form-group col-12')],[
                                            label([class('title-input')], 'Descrição:'),
                                            input([
                                                    name(prod_descricao),
                                                    type(text),
                                                    class('form-control')
                                                ],[])
                                        ]),

                                        div([class('form-group col-6')],[
                                            label([class('title-input')], 'Preço 1'),
                                            input([
                                                    name(prod_preco1),
                                                    type(number),
                                                    class('form-control')
                                                ],[])
                                        ]),

                                        div([class('form-group col-6')],[
                                            label([class('title-input')], 'Preço 2'),
                                            input([
                                                    name(prod_preco2),
                                                    type(number),
                                                    class('form-control')
                                                ],[])
                                        ])
                                        
                                    
                                    ])

                                ]),

                            div([class('modal-footer')],[
                                button([class('btn btn-success'), type(submit)], 'Cadastrar produto'),
                                button([class('btn btn-danger')], 'Cancelar'),
                                a([class(['btn' ,'btn-primary']), href('/')],'Voltar para home')
                            ])

                        ]

                    )
                ]
            ) 
        ]).



