:- module(
    tabela_produtos,
    [
        tab_produtos//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_produtos(RotaDeRetorno) -->
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
               [ \cabeca_da_tabela('Produtos', '/form_produtos'),
                 table(class('table table-striped table-responsive-md'),
                     [ \cabecalho,
                       tbody(\corpo_tabela(RotaDeRetorno))
                     ])]))).



cabecalho -->
 html(thead(tr([ th([scope(col)], '#'),
                 th([scope(col)], 'Codigo'),
                 th([scope(col)], 'Nome'),
                 th([scope(col)], 'QtdAtual'),
                 th([scope(col)], 'QtdMinima'),
                 th([scope(col)], 'Preco1'),
                 th([scope(col)], 'Descricao'),
                 th([scope(col)], 'Preco2'),
                th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), IdProdutos), td(Codigo),td(Nome), td(QtdeAtual),td(QtdeMinima),td(Preco1),td(Descricao),td(Preco2),td(Acoes)]),
              linha(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2, Acoes, RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2, Acoes, RotaDeRetorno):-
 produtos:produtos(IdProdutos,Codigo,Nome,QtdeAtual,QtdeMinima,Preco1,Descricao,Preco2),
 acoes(IdProdutos, RotaDeRetorno, Acoes).

acoes(IdProduto, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/produtos/editar/~w' - IdProduto),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/produtos/~w' - IdProduto),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].
