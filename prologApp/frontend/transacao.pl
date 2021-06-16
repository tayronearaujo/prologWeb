/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

transacao(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Registro de transação ')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para o registro'),
                \form_transacao
              ]) ]).

form_transacao -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/transacao/') ],
              [ \metodo_de_envio('POST'),
                \campo(numero,'Número:',text),
                \campo(hora,'Horas:',text),
                \campo(valor,'Valor:',text),
                \enviar_ou_cancelar('/')
              ])).
