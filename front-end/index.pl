/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(base(bootstrap)).

index(_) :-
  reply_html_page([
    \links
  ]).
metas -->
  html(meta([name(viewport), content('width=device-width, initial-scale=1.0, shrink-to-fit=no')], [])).
links -->
  html(
    div(
      [class('container')],[
        h1(['Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de Desenvolvendo']),
        a([class(''), href('./Produtos')], ['Produtos']),
        a([class(''), href('./Pessoas')], ['Pessoas']), 
    ])
  ).