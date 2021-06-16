/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).
:- use_module(tabela_sangria).


:- ensure_loaded(gabarito(boot5rest)).

sangria(_Pedido):-
apelido_rota(root(itens), RotaDeRetorno),
    reply_html_page(
        boot5rest,
        [ title('Registro de sangria ')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Aqui estao todas as sangrias'),
              \tab_sangria(RotaDeRetorno)
              ]) ]).

formulario5(_Pedido):- 
              reply_html_page(
                      boot5rest,
                      [ title('Registro de sangria')],
                      [ div(class(container),
                      [ \html_requires(js('bookmark.js')),
                         h1('Registro de sangria'),
                         \form_sangria
                                            
                       ]) ]).



form_sangria -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/sangria/') ],
              [ \metodo_de_envio('POST'),
                \campo(numero,'Número:',text),
                \campo(valor,'Valor:',text),
                \campo(hora,'Horas:',text),
                \enviar_ou_cancelar('/')
              ])).