/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).
:- use_module(tabela_pessoas).


:- ensure_loaded(gabarito(boot5rest)).

pessoas(_Pedido):-
  apelido_rota(root(itens), RotaDeRetorno),
    reply_html_page(
        boot5rest,
        [ title('Cadastro Pessoa')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Aqui estao todas as pessoas'),
              \tab_pessoas(RotaDeRetorno)
              ]) ]).
            
formulario7(_Pedido):- 
              reply_html_page(
                      boot5rest,
                      [ title('Cadastro de pessoas')],
                      [ div(class(container),
                      [ \html_requires(js('bookmark.js')),
                         h1('Cadastro de pessoas'),
                         \form_usuarios
                                            
                       ]) ]).

form_usuarios -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/pessoas/') ],
              [ \metodo_de_envio('POST'),
                \campo(nome,'Nome:',text),
                \campo(endereco,'Endereço:',text),
                \campo(telefone,'Telefone:',text),
                \campo('bairro','Bairro:',text),
                \campo('cpf','Cpf:',text),
                \campo('identidade','Identidade:',text),
                \campo('complemento','Complemento:',text),
                \enviar_ou_cancelar('/entrada')
              ])).



