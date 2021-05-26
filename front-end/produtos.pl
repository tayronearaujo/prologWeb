/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).

/* html_requires  */
:- use_module(library(http/html_head)).

servidor(Porta) :-
    http_server(http_dispatch, [port(Porta)]).

:- http_handler(/, oi, []).

oi(_pedido) :-
    format('content-type: text/plain~n~n'),
    format('oi mundo !').
    


    


