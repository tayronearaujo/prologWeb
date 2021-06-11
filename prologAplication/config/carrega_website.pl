% Configuração do servidor


% Carrega o servidor e as rotas

:- load_files([ servidor,
                rotas
              ],
              [ silent(true),
                if(not_loaded) ]).

% Inicializa o servidor para ouvir a porta 8000
:- initialization( servidor(8000) ).


% Carrega o frontend

:- load_files([ gabarito(bootstrap), 
                frontend(index),
                frontend(pessoas),
                frontend(produtos),
                frontend(funcionarios),
                frontend(fluxoDeCaixa),
                frontend(vendas),
                frontend(transacao),
                frontend(itemVenda),
                frontend(clientes)
              ],
              [ silent(true),
                if(not_loaded) ]).

% Carrega o backend

:- load_files([ api1(pessoas) % API REST
              ],
              [ silent(true),
                if(not_loaded) ]).
