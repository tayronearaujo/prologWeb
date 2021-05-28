:- encoding(utf8).
/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(base(bootstrap)).

:- use_module(db(funcionario)).
:- use_module(db(pessoa)).
:- use_module(db(cidade)).
:- use_module(db(bairro)).
:- use_module(db(logradouro)).
:- use_module(db(cep)).

funcionarios_pedido(_Pedido):-
    reply_html_page(
        bootstrap,
        [ title('Funcionários')],
        [
        \html_requires(css('styles.css')),
        \html_requires(js('funcionarios.js')),
        \funcionarios_navbar,
        \funcionarios_modal_aviso,
        \funcionarios_body,
        \funcionarios_inflar_modal,
        \funcionarios_snackbar
        ]).

funcionarios_navbar -->
    html(
        nav(
            [class('navbar fixed-top navbar-expand-lg navbar-dark bg-primary navbar-fixed-top')],
            [   a([class('navbar-brand'), href('./')], ['AeroSystem']),
                button([class('navbar-toggler'), type(button), 'data-toogle'(collapse), 'data-target'('#header'), 'aria-controls'(header),
                    'aria-expanded'(false), 'aria-label'('Toggle navigation')], [span([class('navbar-toggler-icon')], [])]),
                div([class('collapse navbar-collapse'), id(header)],
                    [div([class('navbar-nav')],
                        [
                            a([class('nav-link active'),
                               href('./funcionarios')],
                               ['Funcionários']),
                            a([class('nav-link'),
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

funcionarios_body -->
    html(
        form([autocomplete('off'),class('container container-card')],[
            div([class('row m-3')],[
                h3([class('col-12 mt-5 mb-3')],'Funcionários cadastrados'),
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
                            'data-target'('#modalFuncionario')], 'Incluir novo funcionario')
                            
                        ]),
                        %inicio_tabela
                        div([class('col-12')],[
                            table([class('table')],[
                                thead([class('thead-light')],[
                                    tr([
                                            th([scope('col')],'Código'),
                                            th([scope('col')],'Nome'),
                                            th([scope('col')],'Nome do contato'),
                                            th([scope('col')],'Telefone'),
                                            th([scope('col')],'Opções')
                                        ])
                                ]),
                                        tbody([
                                            \funcionarios_items_tabela
                                        ])
                                
                            ])
                        ])
                    ])
                ])
            ])
    ])).

funcionarios_items_tabela -->
    {
        findall(
                tr([
            td(FUN_ID),
            td(PES_NOME),
            td(FUN_CPF),
            td(FUN_MATRICULA),
            td([
                button([class('mb-table mr-1'),
                        type(button),
                        'data-toggle'('modal'),
                        'data-target'('#modalFuncionario')], [
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
                (funcionario:funcionario(FUN_ID,PES_ID,_,FUN_CPF,_,_,_,FUN_MATRICULA),
                pessoa:pessoa(PES_ID,CEP_ID,PES_NOME,_,_,_),
                cidade:cidade(CID_ID,_,_),
                bairro:bairro(BAI_ID, _),
                logradouro:logradouro(LOG_ID,_,_),
                cep:cep(CEP_ID, CID_ID, BAI_ID, LOG_ID)
                ),Colunas)
             },
             html(Colunas).


funcionarios_inflar_modal -->
            html(
            div([class('modal fade'), id('modalFuncionario'), tabindex('-1'), 'aria-labelledby'('titlemodalFornecedor'), 'aria-hidden'(true)],[
                        div([class('modal-dialog modal-xl modal-dialog-centered')], [
                            form([ id('funcionarios-form'),
                                   onsubmit("redireciona(event, '/funcionarios')"),
                                   class('modal-content'),
                                   action('/api/v1/employees/'),
                                   method('POST'),
                                   autocomplete('off')],[
                                div([class('modal-header')], [
                                    h3([class('modal-title'), id('titlemodalFornecedor')],'Cadastro de funcionários'),
                                    button([class('close'),
                                    type(button),
                                    'data-dismiss'('modal'),
                                    'aria-label'('Close')], [
                                        span(['aria-hidden'('true')],'x')
                                     ])
                                ]),
                                div([class('modal-body')],[
                                         div([class('col-12 row m-auto p-0')],[
                                         
                                             div([class('form-group col-6 mt-1')],[
                                                  label([for(fun_login), class('title-input')], 'Login'),
                                             input([name(fun_login),
                                                 type(text),
                                                 class('form-control'),
                                                 id(fun_login)],[])
                                             ]),
                                             div([class('form-group col-6 mt-1')],[
                                                  label([for(fun_senha), class('title-input')], 'Senha'),
                                          input([name(fun_senha),
                                              type(password),
                                                 class('form-control'),
                                                 id(fun_senha)],[])
                                             ]),
                                             
                                             div([class('form-group col-8')],[
                                                  label([for(pes_nome), class('title-input')], 'Nome'),
                                          input([name(pes_nome),
                                              type(text),
                                                 class('form-control'),
                                                 id(pes_nome)],[])
                                             ]),
                                             div([class('form-group col-2')],[
                                                  label([for(fun_cpf), class('title-input')], 'CPF'),
                                          input([name(fun_cpf),
                                              type(text),
                                                 class('form-control'),
                                                 id(fun_cpf)],[])
                                             ]),
                                             div([class('form-group col-2')],[
                                                  label([for(fun_matricula), class('title-input')], 'Matricula'),
                                          input([name(fun_matricula),
                                              type(text),
                                                 class('form-control'),
                                                 id(fun_matricula)],[])
                                             ]),
                                             span([class('border-bottom col-12')],[]),
                                             
                                             div([class('form-group col-8')],[
                                                  label([for(log_nome), class('title-input')], 'Endereço'),
                                          input([name(log_nome),
                                              type(text),
                                                 class('form-control'),
                                                 id(log_nome)],[])
                                             ]),
                                              div([class('form-group col-2')],[
                                                    label([for(log_numero), class('title-input')], 'Numero'),
                                                    input([name(log_numero),
                                                    type(text),
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
                                              type(text),
                                                 class('form-control'),
                                                 id(bai_nome)],[])
                                             ]),
                                             div([class('form-group col-6')],[
                                                  label([for(cid_nome), class('title-input')], 'Cidade'),
                                          input([name(cid_nome),
                                              type(text),
                                                 class('form-control'),
                                                 autocomplete('no'),
                                                 id(cid_nome)],[])
                                             ]),
                                             div([class('form-group col-1')],[
                                                  label([for(cid_uf), class('title-input')], 'UF'),
                                          input([name(cid_uf),
                                              type(text),
                                                 class('form-control'),
                                                 id(cid_uf)],[])
                                             ]),
                                             
                                             span([class('border-bottom col-12')],[]),
                                             
                                             div([class('form-group mb-3 col-6')],[
                                                  label([for(pes_email), class('title-input')], 'E-mail'),
                                          input([name(pes_email),
                                              type(text),
                                                 class('form-control'),
                                                 id(pes_email)],[])
                                             ]),
                                             div([class('form-group mb-3 col-2')],[
                                                  label([for(pes_telefone), class('title-input')], 'Telefone'),
                                          input([name(pes_telefone),
                                              type(text),
                                                 class('form-control'),
                                                 id(pes_telefone)],[])
                                             ]),
                                             div([class('form-group mb-3 col-4')],[
                                                  label([for(fun_cargo), class('title-input')], 'Cargo'),
                                          input([name(fun_cargo),
                                              type(text),
                                                 class('form-control'),
                                                 id(fun_cargo)],[])
                                             ]),

                                             span([class('border-bottom col-12')],[])

                                         ])
                                     ]),
                                     div([class('modal-footer')],[
                                          button([class('btn btn-secondary'),'data-dismiss'('modal')], 'Cancelar'),
                                          button([class('btn btn-primary'),
                                          type(submit)], 'Cadastrar funcionario')
                                     ])
                            ])
                         ])
                    ])
            ).

funcionarios_snackbar -->
    html(div([id('snackbar')], 'CEP inválido')).

funcionarios_modal_aviso -->
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