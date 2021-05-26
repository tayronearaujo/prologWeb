/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(base(bootstrap)).

index(_) :-
    reply_html_page(
    bootstrap,
    [title('Login')],
     [
     \links,
     \html_requires(js('main.js')),
     \index_navbar,
     \index_body]).


metas -->
         html(meta([name(viewport), content('width=device-width, initial-scale=1.0, shrink-to-fit=no')], [])).


bootstrap -->
    html([
    link([rel(stylesheet), href('https://cdn.jsdelivr.net/npm/reset-css@5.0.1/reset.min.css')], []),
        link([rel(stylesheet), href('https://fonts.googleapis.com/css2?family=Mulish:wght@200;600;800&display=swap')], []),
        link([rel(stylesheet), href('https://fonts.googleapis.com/css2?family=Source+Sans+Pro&display=swap')], []),
        link([rel(stylesheet), href('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css')], []),
        \html_requires(css('styles.css'))
    ]).

links -->
    html(
        div(
            [class('container')],
            [ 
              h1(['Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de Desenvolvendo'])
              a([class(''), href('./Produtos')], ['Produtos'])  
              a([class(''), href('./Pessoas')], ['Pessoas'])   
            ]
          )
        ).