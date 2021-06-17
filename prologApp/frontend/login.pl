:- module(
    login,
    [ login/1 ]).

:-encoding(utf8).

/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

login(_) :-
 reply_html_page(
     boot5rest,
     [ title('Login')],
     [ \html_requires(css('custom.css')),
       \html_requires(css('login.css')),
       \navegacao('menu-topo'),
       \form_login
     ]
 ).

form_login -->
 html(main(class('py-5'),
           section(class('container login py-5'),
                   div(class('row g-0'),
                       [div(class('col-lg-6'),
                            img([class('img-fluid'),alt('Universidade'),src('img/universidade.png')],[])),
                        div(class('col-lg-6 text-center py-5'),
                            [ h1('Login'),
                              \formulario_login,
                              p(['Ainda não possui uma conta? ',
                                 a([ href('/cadastro'),
                                     class([ 'primary-link',
                                             'text-decoration-none'])],
                                   'Cadastre-se')])
                            ])])))
     ).

formulario_login -->
 html(div([ class('p-3 rounded')],
           [ \mensagem,
             \campo(email, 'E-mail', email),
             \campo(senha,'Senha', password),
             \selecao(funcao),
             \enviar_ou_cancelar('/entrada')
            ])).

mensagem -->
 html(div([ class('alert alert-danger visually-hidden'), role(alert)], ' ')).

campo(Nome, Rotulo, Tipo) -->
 html(div(class('form-row py-3'),
          div(class('offset-1 col-lg-10'),
          input([ class('entrada px-2'),
                  name(Nome),
                  type(Tipo),
                  placeholder(Rotulo)])))).

selecao(Nome) -->
 html(div(class('mx-auto py-3 w-50'),
                select([class('form-select border-0 mb-3'),
                        name(Nome),
                        'aria-label'('Selecione tipo do usuário')],
                       [ option([ selected(selected), value('')],
                               'Tipo de usuário:'),
                         option( value(admin),     'Administrador'),
                         option( value(usuario), 'Usuario')
                         
                       ]))).

metodo_de_envio(Metodo) -->
 html(input([type(hidden), name('_metodo'), value(Metodo)])).


enviar_ou_cancelar(RotaDeRetorno) -->
 html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
          [ a([ href(RotaDeRetorno),
            class('btn btn-outline-primary')], 'Enviar'),
            a([ href('/'),
                class('ms-3 btn btn-outline-danger')], 'Cancelar')
         ])).
