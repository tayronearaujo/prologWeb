:- module(
    tabela_transacao,
    [
        tab_transacao//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_transacao(RotaDeRetorno) -->
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
               [ \cabeca_da_tabela('Transacao', '/form_transacao'),
                 table(class('table table-striped table-responsive-md'),
                     [ \cabecalho,
                       tbody(\corpo_tabela(RotaDeRetorno))
                     ])]))).



cabecalho -->
 html(thead(tr([ th([scope(col)], '#'),
                 th([scope(col)], 'Numero'),
                 th([scope(col)], 'Hora'),
                 th([scope(col)], 'Valor'),
                th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), IdTranscao), td(Numero), td(Hora), td(Valor),td(Acoes)]),
              linha(IdTranscao,Numero,Hora,Valor, Acoes, RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(IdTranscao,Numero,Hora,Valor,Acoes, RotaDeRetorno):-
 transacao:transacao(IdTranscao,Numero,Hora,Valor),
 acoes(IdTranscao, RotaDeRetorno, Acoes).

acoes(IdTransacao, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/transacao/editar/~w' - IdTransacao),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/transacao/~w' - IdTransacao),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].
