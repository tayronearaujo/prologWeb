/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).
:- use_module(tabela_item).

:- ensure_loaded(gabarito(boot5rest)).

item(_Pedido):- 
apelido_rota(root(itens), RotaDeRetorno),
    reply_html_page(
        boot5rest,
        [ title('Cadastro de itens')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Aqui estao todos os itens'),
                \tab_item(RotaDeRetorno)
                
              ]) ]).

formulario(_Pedido):- 
reply_html_page(
        boot5rest,
        [ title('Cadastro de itens')],
        [ div(class(container),
        [ \html_requires(js('bookmark.js')),
           h1('Cadastro de item'),
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