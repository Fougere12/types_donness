  $ dune exec PythonToJS f translation_test.py
  Programme source: (Lang.Prog (
     [(Lang.Fundefn (
         (Lang.Fundecl ("affectation", [], (Lang.UnionT [Lang.IntT]))),
         [(Lang.Vardecl ("a", (Lang.UnionT [Lang.IntT])))],
         (Lang.Block
            [(Lang.Assign ("a", (Lang.Const (Lang.IntV 2))));
              (Lang.Return (Lang.VarE "a"))])
         ));
       (Lang.Fundefn (
          (Lang.Fundecl ("condition",
             [(Lang.Vardecl ("n", (Lang.UnionT [Lang.IntT])))],
             (Lang.UnionT [Lang.BoolT]))),
          [(Lang.Vardecl ("a", (Lang.UnionT [Lang.IntT])))],
          (Lang.Block
             [(Lang.Assign ("a", (Lang.Const (Lang.IntV 3))));
               (Lang.Cond (
                  (Lang.BinOp ((Lang.BCompar Lang.BClt), (Lang.VarE "a"),
                     (Lang.VarE "n"))),
                  (Lang.Block [(Lang.Return (Lang.Const (Lang.BoolV true)))]),
                  (Lang.Block [(Lang.Return (Lang.Const (Lang.BoolV false)))])
                  ))
               ])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("boucle_while",
             [(Lang.Vardecl ("n", (Lang.UnionT [Lang.IntT])))],
             (Lang.UnionT [Lang.IntT]))),
          [(Lang.Vardecl ("a", (Lang.UnionT [Lang.IntT])))],
          (Lang.Block
             [(Lang.Assign ("a", (Lang.Const (Lang.IntV 0))));
               (Lang.While (
                  (Lang.BinOp ((Lang.BCompar Lang.BClt), (Lang.VarE "a"),
                     (Lang.VarE "n"))),
                  (Lang.Block
                     [(Lang.Assign ("a",
                         (Lang.BinOp ((Lang.BArith Lang.BAadd),
                            (Lang.VarE "a"), (Lang.Const (Lang.IntV 1))))
                         ))
                       ])
                  ));
               (Lang.Return (Lang.VarE "a"))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("affichage",
             [(Lang.Vardecl ("nom", (Lang.UnionT [Lang.StringT])))],
             (Lang.UnionT [Lang.NoneT]))),
          [],
          (Lang.Block
             [(Lang.CallS ("print", [(Lang.Const (Lang.StringV "Bonjour"))]));
               (Lang.CallS ("print", [(Lang.VarE "nom")]))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("complet",
             [(Lang.Vardecl ("nom", (Lang.UnionT [Lang.StringT])));
               (Lang.Vardecl ("n", (Lang.UnionT [Lang.IntT])))],
             (Lang.UnionT [Lang.BoolT]))),
          [(Lang.Vardecl ("a", (Lang.UnionT [Lang.IntT])));
            (Lang.Vardecl ("x", (Lang.UnionT [Lang.FloatT])))],
          (Lang.Block
             [(Lang.Assign ("a", (Lang.Const (Lang.IntV 1))));
               (Lang.Assign ("x", (Lang.Const (Lang.IntV 32))));
               (Lang.CallS ("print", [(Lang.VarE "nom")]));
               (Lang.While (
                  (Lang.BinOp ((Lang.BCompar Lang.BClt), (Lang.VarE "a"),
                     (Lang.VarE "n"))),
                  (Lang.Block
                     [(Lang.Assign ("a",
                         (Lang.BinOp ((Lang.BArith Lang.BAmul),
                            (Lang.VarE "a"), (Lang.Const (Lang.IntV 2))))
                         ))
                       ])
                  ));
               (Lang.Cond (
                  (Lang.BinOp ((Lang.BBool Lang.BBand),
                     (Lang.BinOp ((Lang.BCompar Lang.BCeq), (Lang.VarE "x"),
                        (Lang.Const (Lang.IntV 16)))),
                     (Lang.BinOp ((Lang.BCompar Lang.BCeq), (Lang.VarE "a"),
                        (Lang.Const (Lang.IntV 16))))
                     )),
                  (Lang.Block [(Lang.Return (Lang.Const (Lang.BoolV true)))]),
                  (Lang.Block
                     [(Lang.CallS ("print",
                         [(Lang.Const (Lang.StringV "pas encore bon"))]))
                       ])
                  ));
               (Lang.Return
                  (Lang.BinOp ((Lang.BCompar Lang.BCeq), (Lang.VarE "x"),
                     (Lang.VarE "a"))))
               ])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("division_euclidienne",
             [(Lang.Vardecl ("a", (Lang.UnionT [Lang.IntT])));
               (Lang.Vardecl ("b", (Lang.UnionT [Lang.IntT])))],
             (Lang.UnionT [Lang.IntT]))),
          [(Lang.Vardecl ("q", (Lang.UnionT [Lang.IntT])));
            (Lang.Vardecl ("r", (Lang.UnionT [Lang.IntT])))],
          (Lang.Block
             [(Lang.Assign ("q", (Lang.Const (Lang.IntV 0))));
               (Lang.Assign ("r", (Lang.VarE "a")));
               (Lang.While (
                  (Lang.BinOp ((Lang.BCompar Lang.BCge), (Lang.VarE "r"),
                     (Lang.VarE "b"))),
                  (Lang.Block
                     [(Lang.Assign ("r",
                         (Lang.BinOp ((Lang.BArith Lang.BAsub),
                            (Lang.VarE "r"), (Lang.VarE "b")))
                         ));
                       (Lang.Assign ("q",
                          (Lang.BinOp ((Lang.BArith Lang.BAadd),
                             (Lang.VarE "q"), (Lang.Const (Lang.IntV 1))))
                          ))
                       ])
                  ));
               (Lang.Return (Lang.VarE "q"))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("test_div", [], (Lang.UnionT [Lang.IntT]))), [],
          (Lang.Block
             [(Lang.Return
                 (Lang.CallE ("division_euclidienne",
                    [(Lang.Const (Lang.IntV 8)); (Lang.Const (Lang.IntV 4))])))
               ])
          ))
       ],
     [], (Lang.Block [])))
  function affectation() {
      let a;
      a = 2;
      return a;
  }
  function condition(n) {
      let a;
      a = 3;
      if ((a < n)) {
          return true;
      } else {
          return false;
      }
  }
  function boucle_while(n) {
      let a;
      a = 0;
      while ((a < n)) {
          a = (a + 1);
      }
      return a;
  }
  function affichage(nom) {
  
      alert("Bonjour");
      alert(nom);
  }
  function complet(nom,n) {
      let a;
      let x;
      a = 1;
      x = 32;
      alert(nom);
      while ((a < n)) {
          a = (a * 2);
      }
      if (((x == 16) && (a == 16))) {
          return true;
      } else {
          alert("pas encore bon");
      }
      return (x == a);
  }
  function division_euclidienne(a,b) {
      let q;
      let r;
      q = 0;
      r = a;
      while ((r >= b)) {
          r = (r - b);
          q = (q + 1);
      }
      return q;
  }
  function test_div() {
  
      return division_euclidienne(8,4);
  }
  
  
