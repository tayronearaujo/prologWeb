/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).
:- use_module(tabela_vendas).


:- ensure_loaded(gabarito(boot5rest)).

vendas(_Pedido):-
    apelido_rota(root(vendas), RotaDeRetorno),
    reply_html_page(
        boot5rest,
        [ title('Vendas')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Aqui estao todas as vendas'),
                \tab_vendas(RotaDeRetorno)
              ]) ]).

formulario8(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Registro de vendas')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para registro'),
                \form_vendas
              ]) ]).


form_vendas -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/vendas/') ],
              [ \metodo_de_envio('POST'),
                \campo(numero_vendedor,'Numero vendendor:',text),
                \campo(numero,'Numero:',text),
                \campo(data,'Data:',text),
                \campo(hora,'Horas:',text),
                \campo(forma_pagamento,'Forma de pagamento',text),
                \enviar_ou_cancelar('/')
              ])).
