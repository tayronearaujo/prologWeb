:- encoding(utf8).
/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap)).

home(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('GCM')],
        [ 
          \html_requires(css('all.min.css')),
          \html_requires(js('rest.js')),
          \html_requires(js('bookmark.js')),
          
          header(
            nav( [class('navbar navbar-dark bg-dark navbar-expand-lg')],[
                \linkPessoas(),
                \linkProdutos(),
                \linkFuncionarios(),
                \linkFluxoDeCaixa(), 
                \linkVendas(),
                \linkTransacao(),
                \linkCliente(),
                \linkItemVenda()
            ])
          ),
          main(
            h1('Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de Desenvolvendo')
            %h1('Content')
          ) 

        ]).
  
linkPessoas() -->
  html(
    a([class('nav-link'),
    href('/pessoas')],
    'Cadastro de pessoas')
  ).

linkProdutos() -->
  html(
    a([class('nav-link'),
    href('/produtos')],
    'Cadastro de produtos')
  ).

%///////////

linkFuncionarios() -->
  html(
    a([class('nav-link'),
    href('/funcionarios')],
    'Cadastro de funcionários')
  ).

linkFluxoDeCaixa() -->
  html(
    a([class('nav-link'),
    href('/fluxoDeCaixa')],
    'Fluxo De Caixa')
  ).



linkVendas() -->
  html(
    a([class('nav-link'),
    href('/vendas')],
    'Cadastro de Vendas')
  ).

linkTransacao() -->
  html(
    a([class('nav-link'),
    href('/transacao')],
    'Registro de Transação')
  ).


linkCliente() -->
  html(
    a([class('nav-link'),
    href('/clientes')],
    'Cadastro de clientes')
  ).

linkItemVenda() -->
  html(
    a([class('nav-link'),
    href('/itemVenda')],
    'Cadastro item venda')
  ).
