:- module(
    tabela_pessoas,
    [
        tab_pessoas//1
    ]
).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).


tab_pessoas(RotaDeRetorno) -->
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
               [ \cabeca_da_tabela('Pessoas', '/form_pessoas'),
                 table(class('table table-striped table-responsive-md'),
                     [ \cabecalho,
                       tbody(\corpo_tabela(RotaDeRetorno))
                     ])]))).



cabecalho -->
 html(thead(tr([ th([scope(col)], '#'),
                 th([scope(col)], 'Nome'),
                 th([scope(col)], 'End'),
                 th([scope(col)], 'telefone'),
                 th([scope(col)], 'bairro'),
                 th([scope(col)], 'CPF'),
                 th([scope(col)], 'Id'),
                 th([scope(col)], 'complemento'),
                th([scope(col)], 'Acoes')
               ]))).

corpo_tabela(RotaDeRetorno) -->
 {
     findall( tr([th(scope(row), Iduser), td(Nome), td(Endereco), td(Telefone),td(Bairro),td(Cpf), td(Identidade), td(Complemento) ,td(Acoes)]),
              linha(Iduser, Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento, Acoes, RotaDeRetorno),
              Linhas )
 },
 html(Linhas).


linha(Iduser, Nome,Endereco,Telefone,Bairro,Cpf,Identidade,Complemento, Acoes, RotaDeRetorno):-
 pessoas:pessoas(Iduser, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento),
 acoes(Iduser, RotaDeRetorno, Acoes).

acoes(IdUser, RotaDeRetorno, Campo):-
 Campo = [ a([ class('text-success'), title('Alterar'),
               href('/pessoas/editar/~w' - IdUser),
               'data-toggle'(tooltip)],
             [ \lapis ]),
           a([ class('text-danger ms-2'), title('Excluir'),
               href('/api/v1/pessoas/~w' - IdUser),
               onClick("apagar( event, '~w' )" - RotaDeRetorno),
               'data-toggle'(tooltip)],
             [ \lixeira ])
         ].
