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
                frontend(produtos),
                frontend(fluxoDeCaixa),
                frontend(funcionarios),
                frontend(transacao),
                frontend(vendas),
                frontend(sangria),
                frontend(cliente),
                frontend(item),
                frontend(login),
                frontend(pag_cadastro),
                frontend(menu_topo),
                frontend(icones)
          
              ],
              [ silent(true),
                if(not_loaded) ]).


% Carrega o backend

:- load_files([
                api1(api_pessoas),
                api1(api_produtos),
                api1(api_fluxoDeCaixa),
                api1(api_funcionarios),
                api1(api_transacao),
                api1(api_vendas),
                api1(api_sangria),
                api1(api_cliente),
                api1(api_item),
                api1(api_usuarios)
                

              ],
              [ silent(true),
                if(not_loaded),
                imports([]) ]).
