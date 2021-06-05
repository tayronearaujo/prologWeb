/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap)).

home(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('GCM')],
        [ div(class(container),
          [ 
            \html_requires(css('all.min.css')),
            \html_requires(js('rest.js')),
            \html_requires(js('bookmark.js')),
              
            h1('Desenvolvendo aplicativo de gestão comercial multiplataforma utilizando padrões livres de Desenvolvendo'),
            nav(class(['nav','flex-row']),
                [ 
                  \linkPessoas(),
                  \linkProdutos() 
                ])
          ]) 
        ]).
  
  linkPessoas() -->
    html(
      a([class('nav-link'),
      href('./pessoas')],
      'Cadastro de pessoas')
    ).
  
  linkProdutos() -->
    html(
      a([class('nav-link'),
      href('/produtos')],
      'Cadastro de produtos')
    ).

footer -->
  html(
  div([class('modal-footer')],[
          button([class('btn btn-success'), type(submit)], 'Cadastrar pessoa'),
          button([class('btn btn-danger')], 'Cancelar'),
          a([class(['btn' ,'btn-primary']), href('/')],
       'Voltar para home')
      ])).

