:- module(
    tabela_fluxoDeCaixa,
    [
        tab_fluxo//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_fluxo(RotaDeRetorno) -->
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
                 th([scope(col)], 'Numero Transacao'),
                 th([scope(col)], 'Valor'),
                th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), Flu_Id), td(NumeroTransacao), td(Valor),td(Acoes)]),
              linha(Flu_Id, NumeroTransacao, Valor, Acoes, RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(Flu_Id,NumeroTransacao,Valor,Acoes, RotaDeRetorno):-
 fluxoDeCaixa:fluxoDeCaixa(Flu_Id,NumeroTransacao, Valor),
 acoes(Flu_Id, RotaDeRetorno, Acoes).

acoes(Flu_Id, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/fluxoDeCaixa/editar/~w' - Flu_Id),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/fluxoDeCaixa/~w' - Flu_Id),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].
