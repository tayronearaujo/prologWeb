/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

funcionarios(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de funcionarios')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para cadastro'),
                \form_funcionarios
              ]) ]).

form_funcionarios -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/funcionarios/') ],
              [ \metodo_de_envio('POST'),
                \campo(numfunc,'Número funcionario:',text),
                \campo(adimissao,'Data de admissão:',text),
                \campo(carteiraTrabalho,'Número carteira de trabalho:',text),
                \campo(ferias,'Data férias:',text),
                \campo(horario,'Horário',text),
                \enviar_ou_cancelar('/')
              ])).

