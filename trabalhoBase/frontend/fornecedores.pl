:- encoding(utf8).
/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(base(bootstrap)).
:- use_module(db(fornecedor)).

fornecedores_pedido(_Pedido):-
    reply_html_page(
        bootstrap,
        [ title('Fornecedores')],
        [
        \html_requires(css('styles.css')),
        \html_requires(js('fornecedores.js')),
        \fornecedores_navbar,
        \fornecedores_modal_aviso,
        \fornecedores_body,
        \fornecedores_inflar_modal,
        \fornecedores_links
        ]).


fornecedores_links -->
    html([
        link([rel(stylesheet), href('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css')], [])
    ]).

fornecedores_navbar -->
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
                            a([class('nav-link active'),
                               href('./fornecedores')],
                               ['Fornecedores']),
                            a([class('nav-link'),
                               href('./compras')],
                               ['Compras']),
                            a([class('nav-link'),
                               href('./pecas')],
                               ['Peças'])
                        ])]
               )]
            )
        ).

fornecedores_body -->
    html(
        form([autocomplete('off'),class('container container-card')],[
            div([class('row m-3')],[
                h3([class('col-12 mt-5 mb-3')],'Fornecedores cadastrados'),
                div([class('container-card col-12 mt-3')], [
                    div([class('col-12 row d-flex align-items-center mt-3')], [
                        div([class('form-group col-9')], [
                            label([for(inputBusca), class('title-input')], 'Buscar'),
                            input([name(inputBusca),
                            type(name),
                            class('form-control'),
                            id(inputBusca),
                            placeholder('')], [])
                        ]),
                        div([class('form-group col-3 mt-4')],[
                            button([class('btn btn-primary w-100'),
                            type(button),
                            'data-toggle'('modal'),
                            'data-target'('#modalFornecedor')], 'Incluir novo fornecedor')
                            
                        ]),
                        %inicio_tabela
                        div([class('col-12')],[
                            table([class('table')],[
                                thead([class('thead-light')],[
                                    tr([
                                            th([scope('col')],'Código'),
                                            th([scope('col')],'Nome do fornecedor'),
                                            th([scope('col')],'Nome do contato'),
                                            th([scope('col')],'Telefone'),
                                            th([scope('col')],'Opções')
                                        ])
                                ]),
                                        tbody([
                                            \fornecedores_items_tabela
                                        ])            
                            ])
                        ]),
                        %fim_tabela
                        %inicio_modal
                        div([class('modal fade')],[
                        ])

                    ])
                ])
            ])
    ])).

fornecedores_inflar_modal -->
            html(
            div([class('modal fade'), id('modalFornecedor'), tabindex('-1'), 'aria-labelledby'('titlemodalFornecedor'), 'aria-hidden'(true)],[
                        div([class('modal-dialog modal-xl modal-dialog-centered')], [
                            form([id('funcionarios-form'),
                                  onsubmit("redireciona(event, '/fornecedores')"),
                                  class('modal-content'),
                                  action('/api/v1/suppliers/'),
                                  method('POST'),
                                  autocomplete('off')],[
                                div([class('modal-header')], [
                                    h3([class('modal-title'), id('titlemodalFornecedor')],'Cadastro de fornecedor'),
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
                                                  label([for(pes_nome), class('title-input')], 'Nome'),
                                          input([name(pes_nome),
                                                 type(name),
                                                 class('form-control'),
                                                 id(pes_nome)],[])
                                             ]),
                                             div([class('form-group col-2')],[
                                                  label([for(for_cnpj), class('title-input')], 'CNPJ'),
                                          input([name(for_cnpj),
                                              type(name),
                                                 class('form-control'),
                                                 id(for_cnpj)],[])
                                             ]),
                                             div([class('form-group col-2')],[
                                                  label([for(for_inscricao), class('title-input')], 'Insc. Estadual'),
                                          input([name(for_inscricao),
                                              type(name),
                                                 class('form-control'),
                                                 id(for_inscricao)],[])
                                             ]),
                                             div([class('form-group col-2')],[
                                                  label([for(for_situacao), class('title-input')], 'Situação'),
                                          input([name(for_situacao),
                                              type(name),
                                                 class('form-control'),
                                                 id(for_situacao)],[])
                                             ]),

                                             span([class('border-bottom col-12')],[]),

                                             div([class('form-group col-8')],[
                                                  label([for(log_nome), class('title-input')], 'Endereço'),
                                          input([name(log_nome),
                                              type(name),
                                                 class('form-control'),
                                                 id(log_nome)],[])
                                             ]),
                                             div([class('form-group col-2')],[
                                                  label([for(log_numero), class('title-input')], 'Número'),
                                          input([name(log_numero),
                                              type(name),
                                                 class('form-control'),
                                                 id(log_numero)],[])
                                             ]),
                                             div([class('form-group col-2')],[
                                                  label([for(inputCep), class('title-input')], 'CEP'),
                                          input([name(inputCep),
                                              type(number),
                                                 class('form-control'),
                                                 pattern('\\d*'),
                                                 autocomplete('no'),
                                                 maxlength('8'),
                                                 onkeyup('fetchCEP(this.value);'),
                                                 id(inputCep)],[])
                                             ]),
                                             div([class('form-group col-5')],[
                                                  label([for(bai_nome), class('title-input')], 'Bairro'),
                                          input([name(bai_nome),
                                              type(name),
                                                 class('form-control'),
                                                 id(bai_nome)],[])
                                             ]),
                                             div([class('form-group col-6')],[
                                                  label([for(cid_nome), class('title-input')], 'Cidade'),
                                          input([name(cid_nome),
                                              type(name),
                                                 class('form-control'),
                                                 autocomplete('no'),
                                                 id(cid_nome)],[])
                                             ]),
                                             div([class('form-group col-1')],[
                                                  label([for(cid_uf), class('title-input')], 'UF'),
                                          input([name(cid_uf),
                                              type(name),
                                                 class('form-control'),
                                                 id(cid_uf)],[])
                                             ]),
                                             div([class('form-group mb-3 col-6')],[
                                                  label([for(pes_email), class('title-input')], 'E-mail'),
                                          input([name(pes_email),
                                              type(name),
                                                 class('form-control'),
                                                 id(pes_email)],[])
                                             ]),
                                             div([class('form-group mb-3 col-2')],[
                                                  label([for(for_status), class('title-input')], 'Status'),
                                          input([name(for_status),
                                              type(name),
                                                 class('form-control'),
                                                 id(for_status)],[])
                                             ]),
                                             div([class('form-group mb-3 col-4')],[
                                                  label([for(for_categoria), class('title-input')], 'Categoria'),
                                          input([name(for_categoria),
                                              type(name),
                                                 class('form-control'),
                                                 id(for_categoria)],[])
                                             ]),
                                             
                                             span([class('border-bottom col-12')],[]),

                                             div([class('form-group mb-3 col-4')],[
                                                  label([for(for_nome_contato), class('title-input')], 'Nome do contato'),
                                          input([name(for_nome_contato),
                                              type(name),
                                                 class('form-control'),
                                                 id(for_nome_contato)],[])
                                             ]),
                                             div([class('form-group mb-3 col-6')],[
                                                  label([for(for_telefone_contato), class('title-input')], 'E-mail do contato'),
                                          input([name(for_telefone_contato),
                                              type(name),
                                                 class('form-control'),
                                                 id(for_telefone_contato)],[])
                                             ]),
                                             div([class('form-group mb-3 col-2')],[
                                                  label([for(pes_telefone), class('title-input')], 'Telefone do contato'),
                                          input([name(pes_telefone),
                                              type(name),
                                                 class('form-control'),
                                                 id(pes_telefone)],[])
                                             ]),

                                             span([class('border-bottom col-12')],[])

                                         ])
                                     ]),
                                     div([class('modal-footer')],[
                                          button([class('btn btn-secondary'),'data-dismiss'('modal')], 'Cancelar'),
                                          button([class('btn btn-primary'),
                                          type(submit)], 'Cadastrar fornecedor')
                                     ])
                            ])
                         ])
                    ])
            ).

fornecedores_modal_aviso -->
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

fornecedores_items_tabela -->
    {
        findall(
        tr([
            td(FOR_ID),
            td(PES_NOME),
            td(FOR_NOME_CONTATO),
            td(PES_TELEFONE),
            td([
                button([class('mb-table mr-1'),
                        type(button),
                        'data-toggle'('modal'),
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
                lista_fornecedores(FOR_ID,_,_,_,FOR_NOME_CONTATO,_,_,
                       _,_,_,_,PES_NOME,PES_TELEFONE,_,_,
                       _,_,_,_,_,_,_,_),
                Colunas)
    },
    html(Colunas).


lista_fornecedores(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
                   FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO,
                   CID_ID,CID_NOME,CID_UF,BAI_ID, BAI_NOME, LOG_ID,LOG_NOME,LOG_NUMERO) :-
    fornecedor(FOR_ID,PES_ID,FOR_CNPJ,FOR_INSCRICAO,FOR_NOME_CONTATO,FOR_EMAIL_CONTATO,FOR_SITUACAO,
               FOR_TELEFONE_CONTATO,FOR_STATUS,FOR_CATEGORIA),
    pessoa(PES_ID,CEP_ID,PES_NOME,PES_TELEFONE,PES_EMAIL,PES_NUMERO),
    cidade(CID_ID,CID_NOME,CID_UF),
    bairro(BAI_ID, BAI_NOME),
    logradouro(LOG_ID,LOG_NOME,LOG_NUMERO),

    cep(CEP_ID, CID_ID, BAI_ID, LOG_ID).