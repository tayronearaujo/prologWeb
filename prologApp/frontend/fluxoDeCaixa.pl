/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).
:- use_module(tabela_fluxoDeCaixa).


:- ensure_loaded(gabarito(boot5rest)).

fluxoDeCaixa(_Pedido):-
    apelido_rota(root(fluxoDeCaixa), RotaDeRetorno),
    reply_html_page(
        boot5rest,
        [ title('Fluxo de Caixa')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Aqui estao todos os registro de fluxo de caixa'),
             \tab_fluxo(RotaDeRetorno)
              ]) ]).


formulario3(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Registro Fluxo de Caixa')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para o registro'),
                \form_fluxoDeCaixa
              ]) ]).


form_fluxoDeCaixa -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/fluxoDeCaixa/') ],
              [ \metodo_de_envio('POST'),
                \campo(numeroTransacao,'Número Transação:',text),
                \campo(valor,'Valor:',text),
                \enviar_ou_cancelar('/')
              ])).

