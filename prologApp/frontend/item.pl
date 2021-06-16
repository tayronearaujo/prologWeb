/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

item(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de itens')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para o cadastro'),
                \form_item
              ]) ]).

form_item -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/item/') ],
              [ \metodo_de_envio('POST'),
                \campo(codigo,'Codigo:',text),
                \campo(quantidade,'Quantidade:',text),
                \campo(valor,'Valor:',text),
                \enviar_ou_cancelar('/')
              ])).