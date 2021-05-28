etapa_producao:insere(1,'01-10-2020','01-11-2020','Construção da Asa de Avião').
etapa_producao:insere(2,'01-11-2020','01-12-2020','Construção do Rotax – Motores 915').
etapa_producao:insere(3,'01-09-2020','01-01-2021','Construção do Rotax – Motores 912 IS').
etapa_producao:insere(4,'01-08-2020','01-11-2022','Construção do Rotax – Motores 914UL').

etapa_peca:insere(1,1,25.00).
etapa_peca:insere(2,2,17.00).
etapa_peca:insere(3,3,5.00).
etapa_peca:insere(4,4,10.00).

%----------------------------------------------- CONSULTAS, REMOÇÕES E INSERÇÕES -------------------------------------------

% ------------- CRUD PEÇAS
cadastra_peca('Asa de Avião',1500.00,1300.00,25000.00,'AV465','AV4564',150.00,15.00,123.00,
              'PC4564','654','3C-56','3C','3C-12','Boeing 747','Bimotor','Motores','Aeroplanos').

atualiza_peca(1,1,3,2,'Asa de Avião',1500.00,1300.00,25000.00,'AV465','AV4564',150.00,15.00,123.00,
              'PC4564','654','3C-56','3C','3C-12','Boeing 747','Bimotor','Motores','Aeroplanos').


lista_pecas(PECAS).

remove_peca(1).

% ------------- CRUD FORNECEDORES
cadastra_fornecedor('69.288.010/0001-70',409277295649,'Francisca e Márcia Marketing ME','sac@franciscaemarciamarketingme.com.br','ATIVO',
                    '(11) 3867-7638','ATIVO','EMPRESA','Francisca e Márcia Marketing ME','(11) 3867-7638','sac@franciscaemarciamarketingme.com.br','P546',
                    'São Paulo','SP',11, 'Lapa', 'Alemeda São João','Casa').

atualiza_fornecedor(1,2,'69.288.010/0001-70',409277295649,'Francisca e Márcia Marketing ME','sac@franciscaemarciamarketingme.com.br','ATIVO',
                    '(11) 3867-7638','ATIVO','EMPRESA',2,'Francisca e Márcia Marketing ME','(11) 3867-7638','sac@franciscaemarciamarketingme.com.br','P546',
                    2,'São Paulo','SP',11,2, 'Lapa', 2,'Alemeda São João','Casa').

lista_for(FORNECEDORES).
remove_fornecedor(1).

% ------------- CRUD FUNCIONÁRIOS
cadastra_funcionario('Analista de Sistemas','217.499.837-88', 'M6546', '217.499.837-88',
                  'Teste123', 'M6546','Rita Eduarda Jesus','(68) 2549-7639','ritaeduardajesus..ritaeduardajesus@beminvestir.com.br','6546',
                  'Rio Branco','AC',68, 'Bahia Nova', 'Rua São Francisco','Casa').

atualiza_funcionario(1,1,'Analista de Sistemas','217.499.837-88', 'M6546', '217.499.837-88',
                  'Teste123', 'M6546',1,'Rita Eduarda Jesus','(68) 2549-7639','ritaeduardajesus..ritaeduardajesus@beminvestir.com.br','6546',
                  1,'Rio Branco','AC',68,1, 'Bahia Nova', 1,'Rua São Francisco','Casa').

lista_func(FUNCIONARIOS).
remove_funcionario(1).

% ------------- CRUD COMPRAS

cadastra_compra_item(1,1,5.0,5.60).
cadastra_compra_item(1,1,4.0,5.60).
cadastra_compra_item(1,1,3.0,5.60).
cadastra_compra_item(1,1,6.0,5.60).


% ------------- LIMPA LIXO DO BANCO
sincroniza_banco.