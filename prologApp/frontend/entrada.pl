/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap5)).

:- use_module(bd(pessoas), []).
:- use_module(bd(produtos), []).


entrada(_Pedido) :-
    reply_html_page(
        bootstrap5,
        [ title('GCM')],
        [ div(class(container),
            [ h1('Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de desenvolvendo'),
                nav(class(['nav','flex-column']),
                    [ 
                        \link_pessoas(1),
                        \link_produtos(1)
            
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
        'Cadastro pessoas')).

link_produtos(1) -->
    html(a([ class(['nav-link']),
            href('/produtos')],
        'Cadastro produtos')).


enviar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).

metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_metodo'), value(Metodo)])).
