:-load_files([ servidor,
        rotas
    
    ],[
        silent(true),
        if(not_loaded)]).

:- initialization( servidor(8000) ).

