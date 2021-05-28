/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(base(bootstrap)).

:- use_module(db(compra)).

compra_pedido(_Pedido):-
    reply_html_page(
        bootstrap,
        [ title('Compras')],
        [
        \html_requires(css('styles.css')),
        \html_requires(js('cliente.js')),
        \compras_navbar,
        \modal_aviso,
        \compras_body
        ]).



%cadastro(post, Compra) :-
%    reply_html_page([title('Compras')],
%                    [\resposta(Compra)]).

compras_navbar -->
    html(
        nav(
            [class('navbar fixed-top navbar-expand-lg navbar-dark bg-primary navbar-fixed-top')],
            [   a([class('navbar-brand'), href('./')], ['AeroSystem']),
                button([class('navbar-toggler'), type(button), 'data-toogle'(collapse), 'data-target'('#header'), 'aria-controls'(header),
                    'aria-expanded'(false), 'aria-label'('Toggle navigation')], [span([class('navbar-toggler-icon')], [])]),
                div([class('collapse navbar-collapse'), id(header)],
                    [div([class('navbar-nav')],
                        [
                            a([class('nav-link'),
                               href('./funcionarios')],
                               ['Funcionários']),
                            a([class('nav-link'),
                               href('./fornecedores')],
                               ['Fornecedores']),
                            a([class('nav-link active'),
                               href('./compras')],
                               ['Compras']),
                            a([class('nav-link'),
                               href('./pecas')],
                               ['Peças'])
                        ])]
               )]
            )
        ).

compras_body -->
    html(
        form([method('post'), action('/incluir'), autocomplete('off'),class('container container-card')],[
                div([class('row m-3')],[
                        h3([class('col-12 mt-5 mb-3')],'Cadastro de compras'),
                        div([class('container-card col-12 mr-auto ml-auto mt-3 mb-5 row')], [
                            div([class('col-6 mt-3 mb-3')], [
                                div([class('col-12 row')],[
                                     h5([class('col-12 mt-3')],'Nova Compra'),
                                     div([class('form-group col-12 m-0 mt-3')], [
                                          label([for(controlFornecedor), class('title-input')], 'Fornecedor'),
                                          select([name(controlFornecedor),
                                                  id(controlFornecedor),
                                                  class('form-control')], [
%                                                    \select_fornecedores
                                                  ])
                                     ]),
                                     div([class('form-group col-12 m-0 mt-3')], [
                                          label([for(controlPeca), class('title-input')], 'Peça'),
                                          select([name(controlPeca),
                                                  id(controlPeca),
                                                  class('form-control')], [
                                                    option([value(1)], 'HÉLICE'),
                                                    option([value(2)], 'ASA'),
                                                    option([value(3)], 'TORPEDO'),
                                                    option([value(4)], 'POLTRONA')
                                                  ])
                                     ]),
                                     div([class('form-group col-12 m-0 mt-3')], [
                                          label([for(inputDoc), class('title-input')], 'Num. Doc.'),
                                          input([name(inputDoc),
                                                 type(name),
                                                 class('form-control'),
                                                 id(inputDoc),
                                                 placeholder('')], [])
                                     ]),
                                     div([class('form-group col-12 m-0 mt-3')], [
                                          label([for(inputNome), class('title-input')], 'Nome'),
                                          input([name(inputNome),
                                                 type(name),
                                                 class('form-control'),
                                                 id(inputNome),
                                                 placeholder('')], [])
                                     ]),
                                     div([class('form-group col-6 m-0 mt-3')], [
                                          label([for(inputDataDocumento), class('title-input')], 'Data documento'),
                                          input([name(inputDataDocumento),
                                                 type(date),
                                                 class('form-control'),
                                                 id(inputDataDocumento),
                                                 placeholder('')], [])
                                     ]),
                                     div([class('form-group col-6 m-0 mt-3')], [
                                          label([for(inputDataEntrega), class('title-input')], 'Data entrega'),
                                          input([name(inputDataEntrega),
                                                 type(date),
                                                 class('form-control'),
                                                 id(inputDataEntrega),
                                                 placeholder('')], [])
                                     ]),
                                     div([class('form-group col-4 m-0 mt-3')], [
                                          label([for(inputCodFab), class('title-input')], 'Cod fab'),
                                          input([name(inputCodFab),
                                                 type(number),
                                                 class('form-control'),
                                                 id(inputCodFab),
                                                 placeholder('')], [])
                                     ]),
                                     div([class('form-group col-4 m-0 mt-3')], [
                                          label([for(inputQuantidade), class('title-input')], 'Quantidade'),
                                          input([name(inputQuantidade),
                                                 type(float),
                                                 class('form-control'),
                                                 id(inputQuantidade),
                                                 placeholder('')], [])
                                     ]),
                                     div([class('form-group col-4 m-0 mt-3')], [
                                          label([for(inputValor), class('title-input')], 'Valor unit'),
                                          input([name(inputValor),
                                                 type(float),
                                                 class('form-control'),
                                                 id(inputValor),
                                                 placeholder('')], [])
                                     ]),
                                     div([class('form-group mb-3 mt-3 col-12')], [
                                         button([class('btn btn-primary w-100'),
                                         type(submit)], 'Incluir')
                                     ])
                                ])
                            ]),

                            % TABELA -----------
                            div([class('col-6 mt-3 mb-3')], [
                                 div(['col-12'], [
                                    h5(class('col-12 mt-3'),'Itens de compra'),
                                    table([class('table border-bottom')], [
                                        thead([class('thead-light')],[
                                            tr([
                                                th([scope('col')],'Nome'),
                                                th([scope('col')],'Quantidade'),
                                                th([scope('col')],'Valor unitário'),
                                                th([scope('col')],'Opções')
                                            ])
                                        ]),
                                        tbody([
                                            \items_tabela(20)
                                        ])
                                    ]),
                                    div([class('form-group col-8 m-0 mt-3 d-flex ml-auto')],[
                                        label([for(inputValorTotal),
                                               class('title-input col-5 m-0 m-auto')], 'Valor Total'),
                                        input([name(inputValorTotal),
                                               type(name),
                                               class('form-control m-0 col-7'),
                                               disabled(disabled),
                                               id(inputValorTotal),
                                               value('R$ 20.500,00')], [])
                                    ]),
                                    div([class('form-group mb-3 mt-3 col-12')], [
                                        button([class('btn btn-primary w-100')], 'Incluir')
                                    ])
                                 ])
                            ])

                        ])
                ])
        ])

    ).


items_tabela(Max) -->
    {
        findall(
        tr([
            td('HÉLICE'),
            td('5'),
            td(['R$ 1.500, ', I]),
            td([
                button([class('mb-table mr-1'),
                        type(button),
                        'data-toggle'(modal),
                        'data-target'('#modalFornecedor')], [
                            i([class('fa fa-pencil-square-o m-auto'),style('font-size:17px')],[])
                        ]),
                button([class('mb-table'),
                        type(button),
                        'data-toggle'('modal'),
                        'data-target'('#modalAviso')], [
                            i([class('fa fa-trash m-auto'),style('font-size:17px')],[])
                        ])
            ])
        ]),
                between(1,Max,I),
                Colunas)
    },
    html(Colunas).


modal_aviso -->
    html(
        div([class('modal fade'),
             id('modalAviso'),
             'data-backdrop'(static),
             'data-keyboard'(false),
             tabindex('-1'),
             'aria-labelledby'('modalAvisoLabel'),
             'aria-hidden'(true)
             ],[
                div([class('modal-dialog modal-dialog-centered')],[
                    div([class('modal-content')],[
                        div([class('modal-header')],[
                            h5([class('modal-title'),id('modalAvisoLabel')],'Excluir item da compra'),
                            button([class('close'),
                                    type(button),
                                    'data-dismiss'('modal'),
                                    'aria-label'('Close')], [
                                        span(['aria-hidden'('true')],'x')
                                     ])
                        ]),
                        div([class('modal-body')],[
                            h6('Deseja mesmo excluir este item?')
                        ]),
                         div([class('modal-footer')],[
                         button([class('btn btn-secondary'),type(button),'data-dismiss'('modal')], 'Cancelar'),
                         button([class('btn btn-primary'),type(button)], 'Excluir')
                         ])
                    ])
                ])
             ])
    ).

resposta(Compra) -->
    {
        catch(
            http_parameters(Compra,[
                controlFornecedor(ControlFornecedor, [number]),
                controlPeca(ControlPeca, [number]),
                inputDoc(InputDoc, [string]),
                inputNome(InputNome, [string]),
                inputDataDocumento(InputDataDocumento, [string]),
                inputDataEntrega(InputDataEntrega, [string]),
                inputCodFab(InputCodFab, [string]),
                inputQuantidade(InputQuantidade, [number]),
                inputValor(InputValor, [number])
            ]),
        _E, fail), !,
            cadastra_compra_item(1, 1, InputQuantidade, InputValor)
        },
    html([
        p('ID do fornecedor: ~w' - ControlFornecedor),
        p('ID da peça: ~w' - ControlPeca),
        p('Num. Doc.: ~w' - InputDoc),
        p('Nome: ~w' - InputNome),
        p('Data documento: ~w' - InputDataDocumento),
        p('Data entrega: ~w' - InputDataEntrega),
        p('Cod fab: ~w' - InputCodFab),
        p('Quantidade: ~w' - InputQuantidade),
        p('Valor unit: ~w' - InputValor)

        ]).

resposta(_Compra) -->
    html([h1('Erro'),
        p('Formulario com parametros errados!')
        ]).


select_fornecedores -->
    {
        findall(
        option([value(FOR_ID)], PES_NOME),
                lista_fornecedores(FOR_ID,_,_,_,_,_,_,
                    _,_,_,_,PES_NOME,_,_,_,_,_,_,_,_,
                    _,_,_),
                Colunas)
    },
    html(Colunas).