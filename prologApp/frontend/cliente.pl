/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

cliente(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de cliente')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para cadastro'),
                \form_cliente
              ]) ]).

form_cliente -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/cliente/') ],
              [ \metodo_de_envio('POST'),
                \campo(compras,'Compras:',text),
                \campo(num_cliente,'Número do cliente:',text),
                \campo(num_vendedor,'Número do vendedor:',text),
                \campo(credito,'Credito:',text),
                \campo(valor_credito,'Valor Credito',text),
                \enviar_ou_cancelar('/')
              ])).