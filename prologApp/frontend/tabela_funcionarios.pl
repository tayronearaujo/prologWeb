:- module(
    tabela_funcionarios,
    [
        tab_funcionarios//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_funcionarios(RotaDeRetorno) -->
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
               [ \cabeca_da_tabela('Funcionarios', '/form_funcionarios'),
                 table(class('table table-striped table-responsive-md'),
                     [ \cabecalho,
                       tbody(\corpo_tabela(RotaDeRetorno))
                     ])]))).



cabecalho -->
 html(thead(tr([ th([scope(col)], '#'),
                 th([scope(col)], 'Numero funcionario'),
                 th([scope(col)], 'Dta Admissao'),
                 th([scope(col)], 'Carteira Trabalho'),
                 th([scope(col)], 'Dta Ferias'),
                 th([scope(col)], 'Horario'),
                 th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), Fun_id), td(Numfunc), td(Adimissao), td(CarteiraTrabalho),td(Ferias), td(Horario), td(Acoes)]),
              linha(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario, Acoes,RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario, Acoes,RotaDeRetorno):-
 funcionarios:funcionarios(Fun_id,Numfunc,Adimissao,CarteiraTrabalho,Ferias,Horario),
 acoes(Fun_id, RotaDeRetorno, Acoes).

acoes(Fun_id, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/funcionarios/editar/~w' - Fun_id),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/funcionarios/~w' - Fun_id),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].