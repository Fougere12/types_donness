open Auxdefs
open Lang


(* globals: all global variable declarations
   locals: local variable declarations of current function
 *)
type var_environment = {
    globals: (vname * tp) list; 
    locals: (vname * tp) list;
}
[@@deriving show]

(* fdecls: all the function declarations of the program
   static_vars: according to variable declarations, static
   dyn_vars: types of current variable assignments, dynamically changing
   curfun: current function (when within a function). Only for purposes of error messages.
 *)
type environment = { 
    fdecls: (vname * ((tp list) * tp)) list; 
    static_vars: var_environment;
    dyn_vars: var_environment;
    curfun: fname option;
    }
  [@@deriving show]

(*type expr =
  Const of value                           (* constant *)
  | VarE of vname                            (* variable *)
  | BinOp of  binop * expr * expr            (* binary operation *)
  | CallE of vname * (expr list)             (* function call *)
  [@@deriving show]
  
type value =
  BoolV of bool
  | IntV of int
  | FloatV of float
  | NoneV
  | StringV of string
  
  type stmt =
    Block of stmt list
  | Assign of vname * expr                   (* Variable assignment: x = e *)
  | Cond of expr * stmt * stmt               (* if .. then .. else *)
  | While of expr * stmt                  
  | Return of  expr
  | CallS of vname * (expr list)             (* procedure call *)
  [@@deriving show]
  *)


let tp_const v = match v with |BoolV(b) -> BoolT | IntV(i) -> IntT | FloatV(f) -> FloatT | StringV(s) -> StringT | NoneV -> NoneT ;;

type 'a option =
None
| Some of 'a;;

let rec look (env : (vname * tp) list) (var : vname) = match env with 
          |[] -> None
          |(c,v)::l -> if c = var then (Some v) else look l var;;


exception Variable_inexistante;;
exception Erreur_type;;

let rec compatible ( b : binop) (t1 : tp) (t2 : tp) = match b with 
                    | BArith ba -> if t1 = t2 then t1 else raise Erreur_type
                    | BBool bb -> if t1 = t2 && t1 = UnionT([BoolT]) then UnionT([BoolT]) else raise Erreur_type
                    | BCompar bc -> if t1 = t2 then UnionT([BoolT]) else raise Erreur_type;;

let rec tp_expr (env : environment) (exp : expr) : tp = match exp with
              | Const (v) -> UnionT ([tp_const(v)])
              | VarE (v) -> let looking = (look env.dyn_vars.locals v) in (match looking with
	                                        |None -> (let looking2 = (look env.dyn_vars.globals v) in (match looking2 with
	                                                |None -> raise Variable_inexistante 
	                                                |Some t -> t ))
	                                        |Some t -> t )
              |BinOp (b, e1, e2) -> (compatible b (tp_expr env e1) (tp_expr env e1))
              (*|CallE -> *)

let rec tp_stmt ((env, t, returned) : (environment * tp * bool)) s = match s with 
              | Block [Assign(v,e)] -> let t = tp_expr env e in Printf.printf "Type: %s\n"(Lang.show_tp t);true
              |_ -> Printf.printf"type inconnu \n";true


              




let tp_fundefn init_env (Fundefn(Fundecl(fn, pards, rt), vds, s)) = true

  (* Function declarations of library / predefined functions *)
let library_fds = [
    ("input", ([UnionT[StringT]], UnionT[StringT]))
  ; ("int",   ([UnionT[BoolT; FloatT; IntT; StringT]], UnionT[IntT]))
  ; ("print", ([UnionT[StringT]], UnionT[NoneT]))
  ; ("str",   ([UnionT[BoolT; FloatT; IntT; StringT]], UnionT[StringT]))
  ]

(* The following has to be defined in detail *)
let tp_prog (Prog(fdefns, vds, s)) = 
  let fds = [] in
  let globs = [] in
  let init_venv = { globals = globs; locals = [] } in 
  let init_env = 
    { fdecls = fds @ library_fds; static_vars = init_venv; dyn_vars = init_venv; curfun = None } in
  if duplicate_free (List.map fst fds) 
    && duplicate_free (List.map fst globs) 
  && List.for_all (tp_fundefn init_env) fdefns
  then tp_stmt (init_env, UnionT[NoneT], false) s
  else failwith "duplicate function or variable declarations"
