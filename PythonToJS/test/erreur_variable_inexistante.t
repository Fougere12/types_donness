  $ dune exec PythonToJS f erreur_variable_inexistante.py
  Programme source: (Lang.Prog (
     [(Lang.Fundefn (
         (Lang.Fundecl ("variable_inexistante", [], (Lang.UnionT [Lang.NoneT])
            )),
         [],
         (Lang.Block [(Lang.Assign ("y", (Lang.Const (Lang.StringV "hello"))))])
         ))
       ],
     [], (Lang.Block [])))
  Fatal error: exception PythonToJS.Typing.Variable_inexistante
  [2]
