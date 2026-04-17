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

let rec lookg (env : var_environment) (var : vname) = match env.globals with 
          |[] -> None
          |(c,v)::l -> if c = var then (Some var) else look env var;;

let rec lookl (env : var_environment) (var : vname) = match env.locals with 
          |[] -> None
          |(c,v)::l -> if c = var then (Some var) else look env var;;

exception Variable_inexistante;;

let rec tp_expr (env : environment) (exp : expr) : tp = match exp with
              | Const (v) -> tp_const(v)
              | VarE (v) -> let looking = (lookg s env.dyn_vars) in (match looking with
	                                        |None -> raise Variable_inexistante 
	                                        |Some t -> t )
              |BinOp -> 
              |CallE -> 

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
