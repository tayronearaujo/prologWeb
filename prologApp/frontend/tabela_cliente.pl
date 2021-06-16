:- module(
    tabela_cliente,
    [
        tab_cliente//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_cliente(RotaDeRetorno) -->
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
               [ \cabeca_da_tabela('Clientes', '/form_cliente'),
                 table(class('table table-striped table-responsive-md'),
                     [ \cabecalho,
                       tbody(\corpo_tabela(RotaDeRetorno))
                     ])]))).



cabecalho -->
 html(thead(tr([ th([scope(col)], '#'),
                 th([scope(col)], 'Compras'),
                 th([scope(col)], 'Num Cliente'),
                 th([scope(col)], 'Num Vendedor'),
                 th([scope(col)], 'Cred'),
                 th([scope(col)], 'ValorCred'),
                 th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), IdCliente), td(Compras), td(Num_cliente), td(Num_vendedor),td(Credito),td(Valor_credito), td(Acoes)]),
              linha(IdCliente, Compras, Num_cliente,Num_vendedor, Credito, Valor_credito, Acoes, RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(IdCliente, Compras, Num_cliente,Num_vendedor, Credito, Valor_credito, Acoes, RotaDeRetorno):-
 cliente:cliente(IdCliente, Compras, Num_cliente,Num_vendedor, Credito, Valor_credito),
 acoes(IdCliente, RotaDeRetorno, Acoes).

acoes(IdCliente, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/cliente/editar/~w' - IdCliente),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/cliente/~w' - IdCliente),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].
