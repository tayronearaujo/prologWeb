% http_server
:- use_module(library(http/thread_httpd)).

% http_dispatch
:- use_module(library(http/http_dispatch)).

% serve_files_in_directory
:- use_module(library(http/http_server_files)).

:- use_module(library(http/http_json)).

/* Aumenta a lista de tipos aceitos pelo servidor */
:- multifile http_json/1.

http_json:json_type('application/x-javascript').
http_json:json_type('application/x-www-form-urlencoded').
http_json:json_type('text/javascript').
http_json:json_type('text/x-javascript').
http_json:json_type('text/x-json').

servidor(Porta) :-
  http_server(http_dispatch, [port(Porta)]).

:- initialization( servidor(8080) ).

% Front-end
user:file_search_path(frontend,  './frontEnd').

% Backend
user:file_search_path(backend,  './db').

% Banco de dados
user:file_search_path(db, backend(db)).

user:file_search_path(dicionario, './bootstrap').

:- load_files([
                servidor
                dicionario(bootstrap),
                frontend(index)
              ],
	          [ silent(true)
	          ]).

