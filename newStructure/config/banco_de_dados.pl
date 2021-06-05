
tabela(chave).
tabela(procutos).

:- initialization ( carrega_tabelas ).

carrega_tabelas():-
    findall(Tab, tabela(Tab),Tabs),
    maplist(carrega_tableas, Tabs).

carrega_tab(Tabela):-
    use_module(bd(Tabela),[]),  
    atomic_list_concat(['tbl_', Tabela,'.pl'], ArqTab),
    expand_file_search_path(bd_tabs(ArqTab),CaminhoTab),
    Tabela:carrega_tab(CaminhoTab).
    
    

    


