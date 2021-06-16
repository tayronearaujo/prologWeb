:- module(
    tabela_vendas,
    [
        tab_vendas//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_vendas(RotaDeRetorno) -->
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
               [ \cabeca_da_tabela('Vendas', '/form_vendas'),
                 table(class('table table-striped table-responsive-md'),
                     [ \cabecalho,
                       tbody(\corpo_tabela(RotaDeRetorno))
                     ])]))).
                    


cabecalho -->
 html(thead(tr([ th([scope(col)], '#'),
                 th([scope(col)], 'Numero vendendor'),
                 th([scope(col)], 'Numero'),
                 th([scope(col)], 'Data'),
                 th([scope(col)], 'Horas'),
                 th([scope(col)], 'Forma Pagamento'),
                th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), IdVendas), td(Numero_Vendedor), td(Numero), td(Data),td(Hora),td(Forma_Pagamento),td(Acoes)]),
              linha(IdVendas,Numero_Vendedor,Numero,Data,Hora,Forma_Pagamento, Acoes, RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(IdVendas,Numero_Vendedor,Numero,Data,Hora,Forma_Pagamento,Acoes, RotaDeRetorno):-
 vendas:vendas(IdVendas,Numero_Vendedor,Numero,Data,Hora,Forma_Pagamento),
 acoes(IdVendas, RotaDeRetorno, Acoes).

acoes(IdVendas, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/vendas/editar/~w' - IdVendas),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/vendas/~w' - IdVendas),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].
