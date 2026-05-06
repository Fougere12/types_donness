  $ dune exec PythonToJS f Verif_type_test.py
  Programme source: (Lang.Prog (
     [(Lang.Fundefn (
         (Lang.Fundecl ("affectation_block_retour", [],
            (Lang.UnionT [Lang.BoolT]))),
         [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])));
           (Lang.Vardecl ("y", (Lang.UnionT [Lang.IntT])))],
         (Lang.Block
            [(Lang.Assign ("x", (Lang.Const (Lang.IntV 3))));
              (Lang.Assign ("y", (Lang.Const (Lang.IntV 5))));
              (Lang.Return
                 (Lang.BinOp ((Lang.BCompar Lang.BCeq), (Lang.VarE "x"),
                    (Lang.VarE "y"))))
              ])
         ));
       (Lang.Fundefn (
          (Lang.Fundecl ("bool_int", [], (Lang.UnionT [Lang.NoneT]))),
          [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])))],
          (Lang.Block
             [(Lang.Assign ("x", (Lang.Const (Lang.BoolV true))));
               (Lang.Assign ("x", (Lang.Const (Lang.IntV 1))))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("if_correct", [], (Lang.UnionT [Lang.IntT]))),
          [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])))],
          (Lang.Block
             [(Lang.Cond ((Lang.Const (Lang.BoolV true)),
                 (Lang.Block [(Lang.Assign ("x", (Lang.Const (Lang.IntV 3))))]),
                 (Lang.Block [(Lang.Assign ("x", (Lang.Const (Lang.IntV 4))))])
                 ));
               (Lang.Return (Lang.VarE "x"))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("while_test", [], (Lang.UnionT [Lang.IntT]))),
          [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])))],
          (Lang.Block
             [(Lang.While ((Lang.Const (Lang.BoolV true)),
                 (Lang.Block [(Lang.Assign ("x", (Lang.Const (Lang.IntV 3))))])
                 ));
               (Lang.Return (Lang.VarE "x"))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("f",
             [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])))],
             (Lang.UnionT [Lang.IntT]))),
          [], (Lang.Block [(Lang.Return (Lang.VarE "x"))])));
       (Lang.Fundefn ((Lang.Fundecl ("appel", [], (Lang.UnionT [Lang.IntT]))),
          [(Lang.Vardecl ("y", (Lang.UnionT [Lang.IntT])))],
          (Lang.Block
             [(Lang.Assign ("y",
                 (Lang.CallE ("f", [(Lang.Const (Lang.IntV 3))]))));
               (Lang.Return (Lang.VarE "y"))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("test_print", [], (Lang.UnionT [Lang.NoneT]))), 
          [],
          (Lang.Block
             [(Lang.CallS ("print", [(Lang.Const (Lang.StringV "hello"))]))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("int_float", [], (Lang.UnionT [Lang.NoneT]))),
          [(Lang.Vardecl ("x", (Lang.UnionT [Lang.FloatT])))],
          (Lang.Block
             [(Lang.Assign ("x", (Lang.Const (Lang.IntV 3))));
               (Lang.Assign ("x", (Lang.Const (Lang.FloatV 3.5))))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("comparaison", [], (Lang.UnionT [Lang.BoolT]))),
          [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])));
            (Lang.Vardecl ("y", (Lang.UnionT [Lang.IntT])));
            (Lang.Vardecl ("z", (Lang.UnionT [Lang.BoolT])))],
          (Lang.Block
             [(Lang.Assign ("x", (Lang.Const (Lang.IntV 3))));
               (Lang.Assign ("y", (Lang.Const (Lang.IntV 4))));
               (Lang.Assign ("z",
                  (Lang.BinOp ((Lang.BCompar Lang.BClt), (Lang.VarE "x"),
                     (Lang.VarE "y")))
                  ));
               (Lang.Return (Lang.VarE "z"))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("bool_logique", [], (Lang.UnionT [Lang.BoolT]))),
          [(Lang.Vardecl ("x", (Lang.UnionT [Lang.BoolT])))],
          (Lang.Block
             [(Lang.Assign ("x",
                 (Lang.BinOp ((Lang.BBool Lang.BBand),
                    (Lang.Const (Lang.BoolV true)),
                    (Lang.Const (Lang.BoolV false))))
                 ));
               (Lang.Return (Lang.VarE "x"))])
          ));
       (Lang.Fundefn (
          (Lang.Fundecl ("arithmetique", [], (Lang.UnionT [Lang.IntT]))),
          [(Lang.Vardecl ("x", (Lang.UnionT [Lang.IntT])));
            (Lang.Vardecl ("y", (Lang.UnionT [Lang.IntT])));
            (Lang.Vardecl ("z", (Lang.UnionT [Lang.IntT])))],
          (Lang.Block
             [(Lang.Assign ("x", (Lang.Const (Lang.IntV 3))));
               (Lang.Assign ("y", (Lang.Const (Lang.IntV 2))));
               (Lang.Assign ("z",
                  (Lang.BinOp ((Lang.BArith Lang.BAadd), (Lang.VarE "x"),
                     (Lang.VarE "y")))
                  ));
               (Lang.Return (Lang.VarE "z"))])
          ))
       ],
     [], (Lang.Block [])))
  function affectation_block_retour() {
      let x;
      let y;
      x = 3;
      y = 5;
      return (x == y);
  }
  function bool_int() {
      let x;
      x = true;
      x = 1;
  }
  function if_correct() {
      let x;
      if (true) {
          x = 3;
      } else {
          x = 4;
      }
      return x;
  }
  function while_test() {
      let x;
      while (true) {
          x = 3;
      }
      return x;
  }
  function f(x) {
  
      return x;
  }
  function appel() {
      let y;
      y = f(3);
      return y;
  }
  function test_print() {
  
      alert("hello");
  }
  function int_float() {
      let x;
      x = 3;
      x = 3.5;
  }
  function comparaison() {
      let x;
      let y;
      let z;
      x = 3;
      y = 4;
      z = (x < y);
      return z;
  }
  function bool_logique() {
      let x;
      x = (true && false);
      return x;
  }
  function arithmetique() {
      let x;
      let y;
      let z;
      x = 3;
      y = 2;
      z = (x + y);
      return z;
  }
  
  
