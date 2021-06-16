/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

vendas(_Pedido):-
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
                \campo(numero_vendedor,'Número vendendor:',text),
                \campo(numero,'Número:',text),
                \campo(data,'Data:',text),
                \campo(hora,'Horas:',text),
                \campo(forma_pagamento,'Forma de pagamento',text),
                \enviar_ou_cancelar('/')
              ])).