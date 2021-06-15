% Configuração do servidor


% Carrega o servidor e as rotas

:- load_files([ servidor,
                rotas
              ],
              [ silent(true),
                if(not_loaded) ]).

% Inicializa o servidor para ouvir a porta 9000
:- initialization( servidor(9000) ).


% Carrega o frontend

:- load_files([ gabarito(bootstrap5),  % gabarito usando Bootstrap 5
                gabarito(boot5rest),   % Bootstrap 5 com API REST
                frontend(entrada),
                frontend(usuarios),
                frontend(clientes)
          
              ],
              [ silent(true),
                if(not_loaded) ]).


% Carrega o backend

:- load_files([
                api1(api_usuarios),
                api1(api_clientes)
              ],
              [ silent(true),
                if(not_loaded),
                imports([]) ]).
