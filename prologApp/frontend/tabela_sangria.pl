:- module(
    tabela_sangria,
    [
        tab_sangria//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_sangria(RotaDeRetorno) -->
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
               [ \cabeca_da_tabela('Sangria', '/form_sangria'),
                 table(class('table table-striped table-responsive-md'),
                     [ \cabecalho,
                       tbody(\corpo_tabela(RotaDeRetorno))
                     ])]))).



cabecalho -->
 html(thead(tr([ th([scope(col)], '#'),
                 th([scope(col)], 'Numero'),
                 th([scope(col)], 'Valor'),
                 th([scope(col)], 'Horas'),
                th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), IdSangria), td(Numero), td(Valor), td(Hora),td(Acoes)]),
              linha(IdSangria,Numero,Valor,Hora, Acoes, RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(IdSangria,Numero,Valor,Hora,Acoes, RotaDeRetorno):-
 sangria:sangria(IdSangria,Numero,Valor,Hora),
 acoes(IdSangria, RotaDeRetorno, Acoes).

acoes(IdSangria, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/sangria/editar/~w' - IdSangria),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/sangria/~w' - IdSangria),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].
