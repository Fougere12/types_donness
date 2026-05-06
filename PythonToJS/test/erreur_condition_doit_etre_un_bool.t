  $ dune exec PythonToJS f erreur_condition_doit_etre_un_bool.py
  Programme source: (Lang.Prog ([], [],
     (Lang.Block
        [(Lang.Cond ((Lang.Const (Lang.IntV 4)),
            (Lang.Block
               [(Lang.CallS ("print", [(Lang.Const (Lang.BoolV true))]))]),
            (Lang.Block
               [(Lang.CallS ("print", [(Lang.Const (Lang.BoolV false))]))])
            ))
          ])
     ))
  Fatal error: exception PythonToJS.Typing.Condition_doit_etre_un_bool
  [2]
