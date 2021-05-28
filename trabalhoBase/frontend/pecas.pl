:- encoding(utf8).
/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(base(bootstrap)).

:- use_module(db(compra)).

pecas_pedido(_Pedido):-
    reply_html_page(
        bootstrap,
        [ title('Peças')],
        [
        \html_requires(css('styles.css')),
        \html_requires(js('cliente.js')),
        \pecas_navbar,
        \pecas_modal_aviso,
        \pecas_body,
        \pecas_inflar_modal
        ]).

pecas_navbar -->
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
                            a([class('nav-link'),
                               href('./compras')],
                               ['Compras']),
                            a([class('nav-link active'),
                               href('./pecas')],
                               ['Peças'])
                        ])]
               )]
            )
        ).
pecas_body -->
    html(
        form([method('post'), action('/pecas'), autocomplete('off'),class('container container-card')],[
                div([class('row m-3')],[
                        h3([class('col-12 mt-5 mb-3')],'Peças Cadastradas'),
                        div([class('container-card col-12 mt-3')], [
                            div([class('col-12 row d-flex align-items-center mt-3')], [
                                div([class('form-group col-9')],[
                                          label([for(inputBusca), class('title-input')], 'Buscar'),
                                          input([name(inputBusca),
                                                 type(text),
                                                 class('form-control'),
                                                 id(inputBusca)],[])
                                     ]),
                                     div([class('form-group col-3 mt-4')],[
                                         button([class('btn btn-primary w-100'), 'data-toggle'('modal'), type(button), 'data-target'('#modalPeca')], 'Incluir Nova Peça')
                                     ])
                            ]),

                                 div([class('col-12')], [
                                    table([class('table')], [
                                        thead([class('thead-light')],[
                                            tr([
                                                th([scope('col')],'Código Peça'),
                                                th([scope('col')],'Descrição das Peças'),
                                                th([scope('col')],'Peso Liq.'),
                                                th([scope('col')],'Custos'),
                                                th([scope('col')],'Opções')
                                            ])
                                        ]),
                                        tbody([
%                                          \items_tabela
                                        ])
                                    ])
                                 ])
                            ])
                ])
        ])
    ).


pecas_items_tabela -->
    {
        findall(
        tr([
            td(PEC_ID),
            td(PEC_NOME),
            td(PEC_PESO_LIQUIDO),
            td(PEC_CUSTO),
            td([
                button([class('mb-table mr-1'),
                        type(button),
                        'data-toggle'('modal'),
                        'data-target'('#modalPeca')], [
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
            lista_pecas(PEC_ID,_,_,_,PEC_NOME,_,
                        PEC_PESO_LIQUIDO,PEC_CUSTO,
                        _,_,_,_,_,_,_,_,_,_,_,_,_),
                Colunas)
    },
    html(Colunas).

            
pecas_inflar_modal -->
            html(
            div([class('modal fade'), id('modalPeca'), tabindex('-1'), 'aria-labelledby'('titlemodalPeca'), 'aria-hidden'(true)],[
                        div([class('modal-dialog modal-xl modal-dialog-centered')], [
                            form([method('post'), action('/incluir'), autocomplete('off'), class('modal-content')], [
                                div([class('modal-header')], [
                                    h3([class('modal-title'), id('titlemodalPeca')],'Cadastro de Peças'),
                                    button([class('close'),
                                    type(button),
                                    'data-dismiss'('modal'),
                                    'aria-label'('Close')], [
                                        span(['aria-hidden'('true')],'x')
                                     ])
                                         
                                ]),

                                div([class('modal-body')],[
                                         div([class('col-12 row m-auto p-0')],[
                                             div([class('form-group col-6')],[
                                                  label([for(inputNome), class('title-input')], 'Nome'),
                                          input([type(text),
                                                 name(inputNome),
                                                 class('form-control'),
                                                 id(inputNome)],[])
                                             ]),
                                             div([class('form-group col-6')],[
                                                  label([for(inputAviao), class('title-input')], 'Avião'),
                                          input([type(text),
                                                 name(inputAviao),
                                                 class('form-control'),
                                                 id(inputAviao)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputCodArmazenamento), class('title-input')], 'Cód. de Armazenamento'),
                                          input([type(text),
                                                 name(inputCodArmazenamento),
                                                 class('form-control'),
                                                 id(inputCodArmazenamento)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputCodFabrica), class('title-input')], 'Cód. Fábrica'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputCodFabrica),
                                                 id(inputCodFabrica)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputGrupo), class('title-input')], 'Grupo'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputGrupo),
                                                 id(inputGrupo)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputPesoLiq), class('title-input')], 'Peso Líq.'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputPesoLiq),
                                                 id(inputPesoLiq)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputPesoBruto), class('title-input')], 'Peso Bruto'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputPesoBruto),
                                                 id(inputPesoBruto)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputConjunto), class('title-input')], 'Conjunto'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputConjunto),
                                                 id(inputConjunto)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputCusto), class('title-input')], 'Custo'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputCusto),
                                                 id(inputCusto)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputEstoqMin), class('title-input')], 'Estoque Mínimo'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputEstoqMin),
                                                 id(inputEstoqMin)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputEstoqMax), class('title-input')], 'Estoque Máximo'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputEstoqMax),
                                                 id(inputEstoqMax)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputQntEstoque), class('title-input')], 'Quantidade Estoque'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputQntEstoque),
                                                 id(inputQntEstoque)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputSala), class('title-input')], 'Sala'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputSala),
                                                 id(inputSala)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputCorredor), class('title-input')], 'Corredor'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputCorredor),
                                                 id(inputCorredor)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputGaveta), class('title-input')], 'Gaveta'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputGaveta),
                                                 id(inputGaveta)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputEstante), class('title-input')], 'Estante'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputEstante),
                                                 id(inputEstante)],[])
                                             ]),
                                             div([class('form-group col-3')],[
                                                  label([for(inputPrateleira), class('title-input')], 'Prateleira'),
                                          input([type(text),
                                                 class('form-control'),
                                                 name(inputPrateleira),
                                                 id(inputPrateleira)],[])
                                             ])
                                         ])
                                     ]),
                                     div([class('modal-footer')],[
                                          button([class('btn btn-secondary'),'data-dismiss'('modal')], 'Cancelar'),
                                          button([class('btn btn-primary'),
                                          type(submit)], 'Cadastrar Peça')
                                     ])
                            ])
                         ])
                    ])
            ).
pecas_modal_aviso -->
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
pecas_resposta(Pecas) -->
    {
        catch(
            http_parameters(Pecas,
                [inputNome(Nome, [atom]),
                 inputAviao(Aviao, [atom]),
                 inputCodArmazenamento(CodArmazenamento, [atom]),
                 inputCodFabrica(CodFabrica, [atom]),
	             inputGrupo(Grupo, [atom]),
                 inputPesoLiq(PesoLiq, [number]),
		         inputPesoBruto(PesoBruto, [number]),
		         inputConjunto(Conjunto, [atom]),
		         inputCusto(Custo, [number]),
		         inputEstoqMin(EstoqMin, [number]),
		         inputEstoqMax(EstoqMax, [number]),
		         inputQntEstoque(QntEstoque, [number]),
		         inputSala(Sala, [atom]),
		         inputCorredor(Corredor, [atom]),
		         inputGaveta(Gaveta, [atom]),
		         inputEstante(Estante, [atom]),
		         inputPrateleira(Prateleira, [atom])
            ]), 
        _E, fail), !
%                (pk(peca,PEC_ID),
%                 pk(grupo,GRU_ID),
%                 pk(conjunto,CON_ID),
%                 pk(aviao,AVI_ID),
%                 grupo:insere(GRU_ID,Grupo),
%                 conjunto:insere(CON_ID,Conjunto),
%                 aviao:insere(AVI_ID, Aviao),
%                 peca:insere(PEC_ID,GRU_ID,CON_ID,AVI_ID,Nome,PesoBruto,
%                            PesoLiq, Custo,CodFabrica, CodArmazenamento,
%                            EstoqMax, EstoqMin, QntEstoque,Sala,Prateleira,
%                            Gaveta,Estante,Corredor)
%                )
    },
    html([
            p('Seu nome e ~w' - Nome),
            p('Seu aviao e ~w' - Aviao),
            p('Seu codArmazenamento e ~w' - CodArmazenamento),
            p('Seu codFabrica e ~w' - CodFabrica),
            p('Seu grupo e ~w' - Grupo),
            p('O peso liquido e ~w' - PesoLiq),
            p('O peso bruto e ~w' - PesoBruto),
            p('Seu conjunto e ~w' - Conjunto),
	        p('Seu custo e ~w' - Custo),
	        p('Seu estoque minimo e ~w' - EstoqMin),
	        p('Seu estoque maximo e ~w' - EstoqMax),
	        p('Sua quantidade de estoque e ~w' - QntEstoque),
	        p('Sua sala e ~w' - Sala),
	        p('Seu corredor e ~w' - Corredor),
	        p('Sua gaveta e ~w' - Gaveta),
	        p('Sua estante e ~w' - Estante),
            p('Sua prateleira e ~w' - Prateleira)
        ]).

pecas_resposta(_Pecas) -->
    html([h1('Erro'),
        p('Formulario com parametros errados!')
        ]).


                                