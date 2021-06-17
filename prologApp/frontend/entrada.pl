/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap5)).

:- use_module(bd(pessoas), []).
:- use_module(bd(produtos), []).
:- use_module(bd(fluxoDeCaixa), []).
:- use_module(bd(funcionarios), []).
:- use_module(bd(transacao), []).
:- use_module(bd(vendas), []).
:- use_module(bd(sangria), []).
:- use_module(bd(cliente), []).
:- use_module(bd(item), []).


entrada(_Pedido) :-
    reply_html_page(
        bootstrap5,
        [ title('GCM')],
        [ div(class(container),
            [ h1('Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de desenvolvendo'),
                nav(class(['nav','flex-column']),
                    [ 
                        \link_pessoas(1),
                        \link_produtos(1),
                        \link_fluxoDeCaixa(1),
                        \link_funcionarios(1),
                        \link_transacao(1),
                        \link_vendas(1),
                        \link_sangria(1),
                        \link_cliente(1),
                        \link_item(1)           
                    ])
                ])
        ]).

retorna_home -->
    html(div(class(row),
            a([ class(['btn','btn-primary']), href('/')],
                'Voltar para o inicio'))).


campo(Nome,Rotulo,Tipo) -->
    html(div(class('mb-3'),
    [label([for=Nome, class('form-label')],Rotulo),
        input([name=Nome,type=Tipo,class('form-control'),id=Nome])])).

link_pessoas(1) -->
    html(a([ class(['nav-link']),
            href('/pessoas')],
        'Cadastro de pessoas')).

link_produtos(1) -->
    html(a([ class(['nav-link']),
            href('/produtos')],
        'Cadastro de produtos')).

link_fluxoDeCaixa(1) -->
        html(a([ class(['nav-link']),
                href('/fluxoDeCaixa')],
            'Fluxo de Caixa')).

link_funcionarios(1) -->
            html(a([ class(['nav-link']),
                    href('/funcionarios')],
                'Cadastro de funcionarios')).

 link_transacao(1) -->
                html(a([ class(['nav-link']),
                        href('/transacao')],
                    'Registro de transacao')).

link_vendas(1) -->
                    html(a([ class(['nav-link']),
                            href('/vendas')],
                        'Registro de vendas')).

link_sangria(1) -->
                        html(a([ class(['nav-link']),
                                href('/sangria')],
                            'Registro de sangria')).

link_cliente(1) -->
                            html(a([ class(['nav-link']),
                                    href('/cliente')],
                                'Cadastro de cliente')).

link_item(1) -->
                                html(a([ class(['nav-link']),
                                        href('/item')],
                                    'Cadastro de itens')).



enviar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).

metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_metodo'), value(Metodo)])).

