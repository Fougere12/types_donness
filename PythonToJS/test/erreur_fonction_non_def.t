  $ dune exec PythonToJS f erreur_fonction_non_def.py
  Programme source: (Lang.Prog ([], [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])))],
     (Lang.Block
        [(Lang.Assign ("x", (Lang.Const (Lang.IntV 2))));
          (Lang.CallS ("print", [(Lang.CallE ("g", [(Lang.VarE "x")]))]))])
     ))
  Fatal error: exception PythonToJS.Typing.Fonction_non_def
  [2]
