:- module(
    tabela_item,
    [
        tab_item//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_item(RotaDeRetorno) -->
 html(div(class('container-fluid py-2'),
          [ \tabela(RotaDeRetorno) ]
         )).


cabeca_da_tabela(Titulo, Link) -->
 html( div(class('d-flex p-1'),
           [ div(class('me-auto'), h2(b(Titulo))),
             div(class(''),
                 a([ href(Link), class('btn btn-primary')],
                   'Novo'))
           ]) ).


tabela(RotaDeRetorno) -->
 html(div(class('row justify-content-center'),
          div( class('col-md-8'),
               [ \cabeca_da_tabela('Itens', '/form_item'),
                 table(class('table table-striped table-responsive-md'),
                     [ \cabecalho,
                       tbody(\corpo_tabela(RotaDeRetorno))
                     ])]))).



cabecalho -->
 html(thead(tr([ th([scope(col)], '#'),
                 th([scope(col)], 'Codigo'),
                 th([scope(col)], 'Quantidade'),
                 th([scope(col)], 'Valor'),
                th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), IdItens), td(Codigo), td(Quantidade), td(Valor),td(Acoes)]),
              linha(IdItens, Codigo, Quantidade, Valor, Acoes, RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(IdItens, Codigo, Quantidade, Valor,Acoes, RotaDeRetorno):-
 item:item(IdItens, Codigo, Quantidade, Valor),
 acoes(IdItens, RotaDeRetorno, Acoes).

acoes(IdItem, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/item/editar/~w' - IdItem),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/item/~w' - IdItem),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].
