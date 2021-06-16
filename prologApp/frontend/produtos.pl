/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).
:- use_module(tabela_produtos).
:- ensure_loaded(gabarito(boot5rest)).

produtos(_Pedido):-
  apelido_rota(root(produto), RotaDeRetorno),
    reply_html_page(
        boot5rest,
        [ title('Cadastro produtos')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Aqui estao todos os produtos'),
              \tab_produtos(RotaDeRetorno)
                
              ]) ]).

formulario1(_Pedido):-
              reply_html_page(
                  boot5rest,
                  [ title('Cadastro de produtos ')],
                  [ div(class(container),
                        [ \html_requires(js('bookmark.js')),
                          h1('Insira os dados para o registro'),
                          \form_produtos
                        ]) ]).



form_produtos -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/produtos/') ],
              [ \metodo_de_envio('POST'),
                \campo(codigo,'Código:',text),
                \campo(nome,'Nome:',text),
                \campo(qtdeAtual,'Quantidade atual:',text),
                \campo(qtdeMinima,'Quantidade Mínima:',text),
                \campo(preco1,'Preço 1',text),
                \campo(descricao,'Descricao:',text),
                \campo(preco2,'Preco 2:',text),
                \enviar_ou_cancelar('/')
              ])).

