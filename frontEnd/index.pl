/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

index(_) :-
  reply_html_page(
    bootstrap,
    [title('teste')],
    [
      \content
    ]
  ).

metas -->
  html(meta([name(viewport), content('width=device-width, initial-scale=1.0')], [])).

content -->
  html(
    div(
      [class('container')],[
        h1(['Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de Desenvolvendo']),
        a([class(''), href('./Produtos')], ['Produtos']),
        a([class(''), href('./Pessoas')], ['Pessoas']), 
    ])
  ).