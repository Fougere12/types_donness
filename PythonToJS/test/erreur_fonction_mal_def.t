  $ dune exec PythonToJS f erreur_fonction_mal_def.py
  Programme source: (Lang.Prog (
     [(Lang.Fundefn (
         (Lang.Fundecl ("f", [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])))],
            (Lang.UnionT [Lang.BoolT]))),
         [], (Lang.Block [(Lang.Return (Lang.VarE "x"))])))
       ],
     [], (Lang.Block [])))
  Fatal error: exception PythonToJS.Typing.Fonction_mal_def
  [2]
